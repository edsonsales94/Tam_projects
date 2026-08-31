#Include "PROTHEUS.CH"
#Include "TopConn.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMRHR08  บAutor  ณStan Lee Lopes     				    บ Data ณ  26/04/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Salแrio por Centro de Custo                                 			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMRHR08()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMRHR08"

	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)

	oReport := ReportDef(cAlias,cPerg)
	oReport:PrintDialog()
Return


Static Function ReportDef(cAlias,cPerg)
	Local oReport
	Local oSection
	Local oBreak
	Local aOrdem      := {"FILIAL"}

	oReport := TReport():New(cPerg,"Salแrio por Centro de Custo",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Salแrio por Centro de Custo",{"SRA"},aOrdem) 

   
    TRCell():New(oSection,"EMPRESA"   	        ,"SRA","Empresa","@!",10)
	TRCell():New(oSection,"RA_CC"		        ,"SRA","Centro_Custo","@!",8)
	TRCell():New(oSection,"CTT_DESC01"		    ,"SRA","Descri_CC","@!",55)
    TRCell():New(oSection,"TOTAL_SALARIO"	    ,"SRA","total_Salario","@E 999,999,999.99",) 
	TRCell():New(oSection,"TOTAL_A_PAGAR"		,"SRA","Total_Pagar","@E 999,999,999.99",) 
    /*TRCell():New(oSection,"RC_VALOR"	        ,"SRC","Valor","@E 999,999,999.99",) 
	TRCell():New(oSection,"RC_PERIODO"  	    ,"SRC","Periodo","@!",10)
	TRCell():New(oSection,"RC_DATA"		        ,"SRC","Data","@!",10)*/
	
	
    
	
	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("TOTAL_SALARIO"),"Total:","SUM",,,"@E 999,999,999.99",,.F.,.T.)
    TRFunction():New(oSection:Cell("TOTAL_A_PAGAR"),"Total:","SUM",,,"@E 999,999,999.99",,.F.,.T.)

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%

    SELECT 'PELMEX' EMPRESA,RA_CC,CTT_DESC01,SUM(SALARIO)TOTAL_SALARIO,SUM(A_PAGAR)TOTAL_A_PAGAR
    FROM(
        SELECT RD_FILIAL,RD_PD,RA_CC,CTT_DESC01,SUM(RD_VALOR)SALARIO,0 A_PAGAR
        FROM SRD100 SRD (NOLOCK)
        INNER JOIN SRA100 SRA (NOLOCK) ON RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND SRA.D_E_L_E_T_ = ''
        INNER JOIN SRJ100 SRJ (NOLOCK) ON RA_FILIAL = RJ_FILIAL AND RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = ''
        INNER JOIN CTT100 CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
        WHERE SRD.D_E_L_E_T_ = ''
        AND RD_PERIODO = %Exp:MV_PAR01%
        AND RD_PD IN ('318')
        GROUP BY RD_FILIAL,RD_PD,RA_CC,CTT_DESC01
        UNION
        SELECT RD_FILIAL,RD_PD,RA_CC,CTT_DESC01,0 SALARIO,SUM(RD_VALOR)A_PAGAR
        FROM SRD100 SRD (NOLOCK)
        INNER JOIN SRA100 SRA (NOLOCK) ON RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND SRA.D_E_L_E_T_ = ''
        INNER JOIN CTT100 CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
        WHERE SRD.D_E_L_E_T_ = ''
        AND RD_PERIODO = %Exp:MV_PAR01%
        AND RD_PD IN ('410','799')
        GROUP BY RD_FILIAL,RD_PD,RA_CC,CTT_DESC01
        UNION
        SELECT RC_FILIAL,RC_PD,RA_CC,CTT_DESC01,SUM(RC_VALOR)SALARIO,0 A_PAGAR
        FROM SRC100 SRC (NOLOCK)
        INNER JOIN SRA100 SRA (NOLOCK) ON RC_FILIAL = RA_FILIAL AND RC_MAT = RA_MAT AND SRA.D_E_L_E_T_ = ''
        INNER JOIN SRJ100 SRJ (NOLOCK) ON RA_FILIAL = RJ_FILIAL AND RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = ''
        INNER JOIN CTT100 CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
        WHERE SRC.D_E_L_E_T_ = ''
        AND RC_PERIODO = %Exp:MV_PAR01%
        AND RC_PD IN ('318')
        GROUP BY RC_FILIAL,RC_PD,RA_CC,CTT_DESC01
        UNION
        SELECT RC_FILIAL,RC_PD,RA_CC,CTT_DESC01,0 SALARIO,SUM(RC_VALOR)A_PAGAR
        FROM SRC100 SRC (NOLOCK)
        INNER JOIN SRA100 SRA (NOLOCK) ON RC_FILIAL = RA_FILIAL AND RC_MAT = RA_MAT AND SRA.D_E_L_E_T_ = ''
        INNER JOIN CTT100 CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
        WHERE SRC.D_E_L_E_T_ = ''
        AND RC_PERIODO = %Exp:MV_PAR01%
        AND RC_PD IN ('410','799')
        GROUP BY RC_FILIAL,RC_PD,RA_CC,CTT_DESC01
        )TB
        WHERE RA_CC NOT IN ('21000')
        GROUP BY RA_CC,CTT_DESC01
        UNION
        SELECT 'AMAZON' EMPRESA,RA_CC,CTT_DESC01,SUM(SALARIO)TOTAL_SALARIO,SUM(A_PAGAR)TOTAL_A_PAGAR
        FROM(
        SELECT RD_FILIAL,RD_PD,RA_CC,CTT_DESC01,SUM(RD_VALOR)SALARIO,0 A_PAGAR
        FROM SRD200 SRD (NOLOCK)
        INNER JOIN SRA200 SRA (NOLOCK) ON RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND SRA.D_E_L_E_T_ = ''
        INNER JOIN SRJ200 SRJ (NOLOCK) ON RA_FILIAL = RJ_FILIAL AND RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = ''
        INNER JOIN CTT200 CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
        WHERE SRD.D_E_L_E_T_ = ''
        AND RD_PERIODO = %Exp:MV_PAR01%
        AND RD_PD IN ('318')
        GROUP BY RD_FILIAL,RD_PD,RA_CC,CTT_DESC01
        UNION
        SELECT RD_FILIAL,RD_PD,RA_CC,CTT_DESC01,0 SALARIO,SUM(RD_VALOR)A_PAGAR
        FROM SRD200 SRD (NOLOCK)
        INNER JOIN SRA200 SRA (NOLOCK) ON RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND SRA.D_E_L_E_T_ = ''
        INNER JOIN CTT200 CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
        WHERE SRD.D_E_L_E_T_ = ''
        AND RD_PERIODO = %Exp:MV_PAR01%
        AND RD_PD IN ('410','799')
        GROUP BY RD_FILIAL,RD_PD,RA_CC,CTT_DESC01
        UNION
        SELECT RC_FILIAL,RC_PD,RA_CC,CTT_DESC01,SUM(RC_VALOR)SALARIO,0 A_PAGAR
        FROM SRC200 SRC (NOLOCK)
        INNER JOIN SRA200 SRA (NOLOCK) ON RC_FILIAL = RA_FILIAL AND RC_MAT = RA_MAT AND SRA.D_E_L_E_T_ = ''
        INNER JOIN SRJ200 SRJ (NOLOCK) ON RA_FILIAL = RJ_FILIAL AND RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = ''
        INNER JOIN CTT200 CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
        WHERE SRC.D_E_L_E_T_ = ''
        AND RC_PERIODO = %Exp:MV_PAR01%
        AND RC_PD IN ('318')
        GROUP BY RC_FILIAL,RC_PD,RA_CC,CTT_DESC01
        UNION
        SELECT RC_FILIAL,RC_PD,RA_CC,CTT_DESC01,0 SALARIO,SUM(RC_VALOR)A_PAGAR
        FROM SRC200 SRC (NOLOCK)
        INNER JOIN SRA200 SRA (NOLOCK) ON RC_FILIAL = RA_FILIAL AND RC_MAT = RA_MAT AND SRA.D_E_L_E_T_ = ''
        INNER JOIN CTT200 CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
        WHERE SRC.D_E_L_E_T_ = ''
        AND RC_PERIODO = %Exp:MV_PAR01%
        AND RC_PD IN ('410','799')
        GROUP BY RC_FILIAL,RC_PD,RA_CC,CTT_DESC01
        )TB
    WHERE RA_CC NOT IN ('22000')
    GROUP BY RA_CC,CTT_DESC01
    ORDER BY 1,4 DESC


EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

    u_InPutSX1(cPerg,"01",PADR("De Data:",20)+"?","","","mv_ch1","C",6,0,0,"G","","","","","mv_par01") 
	//u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
Return
