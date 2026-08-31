#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMRHR03    บAutor  ณJuevan Silva    				บ Data ณ  22/03/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio de Horas Extras							        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMRHR03()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMRHR03"

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

	oReport := TReport():New(cPerg,"Relatorio de Horas Extras",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Relatorio de Horas Extras",{"SRA"},aOrdem)  
	
	TRCell():New(oSection,"PERIODO"	        ,"RDA","PERIODO","@!",8)
	TRCell():New(oSection,"CCUSTO"	  		,"CTT","CCUSTO","@!",8)
	TRCell():New(oSection,"HORAS"	        ,"RDA","HORAS","@!",30)
	TRCell():New(oSection,"VALOR"	        ,"RDA","VALOR","@E 999,999,999,999",)
	
	
	/* 
	TRCell():New(oSection,"QTD_PELMEX"	    ,"SC2","QTD.PELEX","@E 999,999,999,999",)          
	TRCell():New(oSection,"QTD_APTPEL"      ,"SC2","QTD.APT PEL","@E 999,999,999,999",) 
	TRCell():New(oSection,"QTD_AMAZON"   	,"SC2","QTD.AMAZON","@E 999,999,999,999",)
	TRCell():New(oSection,"QTD_APTAMA"      ,"SC2","QTD.APT AMA","@E 999,999,999,999",)
	TRCell():New(oSection,"DIF_PELXAMA"     ,"SC2","DIFERENCA","@E 999,999,999,999",)*/

	
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("TOTAL"),"TOTAL:","SUM",,,"@E 999,999,999,999",,.F.,.T.)

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

SELECT TB1.RD_PERIODO PERIODO,TB1.CTT_DESC01 CCUSTO,SUM(TB1.PB_HORAS)HORAS,SUM(TB1.VAL_PROV)VALOR
	FROM(
		SELECT M0_CODIGO,M0_CODFIL,M0_FILIAL,M0_CGC,RA_FILIAL,RA_MAT,RA_NOME,RA_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,RD_PD,RV_DESC,ISNULL([1],0)VAL_PROV,RA_SALARIO,HORADIA,ISNULL(PB_HORAS,0)PB_HORAS,
		ISNULL([2],0)VAL_DESC,ISNULL([3],0)VAL_BASE,RD_PERIODO
			FROM (SELECT M0_CODIGO,M0_CODFIL,M0_FILIAL,M0_CGC,RA_FILIAL,RA_MAT,RA_NOME,RA_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,RD_PD,RV_DESC,RA_SALARIO,RA_SALARIO/24/6 HORADIA,RD_VALOR,PB_HORAS,RV_TIPOCOD,RD_PERIODO
					FROM SRD100 SRD
					INNER JOIN SRA100 SRA (NOLOCK) ON RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND SRA.D_E_L_E_T_ = ''
					INNER JOIN SRJ100 SRJ (NOLOCK) ON RA_FILIAL = RJ_FILIAL AND RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = ''
					INNER JOIN CTT100 CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
					INNER JOIN SIGAMAT SM (NOLOCK) ON M0_CODIGO = '10' AND RA_FILIAL = M0_CODFIL AND SM.D_E_L_E_T_ = ''
					INNER JOIN SRV100 SRV (NOLOCK) ON RD_PD = RV_COD
					LEFT JOIN (SELECT PB_FILIAL,PB_MAT,PB_PD,PB_TIPO1,PB_HORAS,SUBSTRING(PB_DATA,1,6)PB_PERIODO
								FROM SPB100 SPB
								INNER JOIN SRV100 SRV (NOLOCK) ON PB_PD = RV_COD AND SRV.D_E_L_E_T_ = ''
								WHERE SPB.D_E_L_E_T_ = ''
								AND SUBSTRING(PB_DATA,1,6) BETWEEN '202303' AND '202303'
								)SPB ON RD_FILIAL = PB_FILIAL AND RD_MAT = PB_MAT AND RD_PD = PB_PD AND RD_PERIODO = PB_PERIODO
					WHERE SRD.D_E_L_E_T_ = ''
					AND RD_PERIODO BETWEEN '202303' AND '202303'
					AND RD_PD IN ('262','243','261','113')
					GROUP BY M0_CODIGO,M0_CODFIL,M0_FILIAL,M0_CGC,RA_FILIAL,RA_MAT,RA_NOME,RA_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,RD_PD,RV_DESC,RA_SALARIO,RD_VALOR,PB_HORAS,RV_TIPOCOD,RD_PERIODO
					UNION
					SELECT M0_CODIGO,M0_CODFIL,M0_FILIAL,M0_CGC,RA_FILIAL,RA_MAT,RA_NOME,RA_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,RC_PD,RV_DESC,RA_SALARIO,RA_SALARIO/24/6 HORADIA,RC_VALOR,PB_HORAS,RV_TIPOCOD,RC_PERIODO
					FROM SRC100 SRC
					INNER JOIN SRA100 SRA (NOLOCK) ON RC_FILIAL = RA_FILIAL AND RC_MAT = RA_MAT AND SRA.D_E_L_E_T_ = ''
					INNER JOIN SRJ100 SRJ (NOLOCK) ON RA_FILIAL = RJ_FILIAL AND RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = ''
					INNER JOIN CTT100 CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
					INNER JOIN SIGAMAT SM (NOLOCK) ON M0_CODIGO = '10' AND RA_FILIAL = M0_CODFIL AND SM.D_E_L_E_T_ = ''
					INNER JOIN SRV100 SRV (NOLOCK) ON RC_PD = RV_COD
					LEFT JOIN (SELECT PB_FILIAL,PB_MAT,PB_PD,PB_TIPO1,PB_HORAS,SUBSTRING(PB_DATA,1,6)PB_PERIODO
								FROM SPB100 SPB
								INNER JOIN SRV100 SRV (NOLOCK) ON PB_PD = RV_COD AND SRV.D_E_L_E_T_ = ''
								WHERE SPB.D_E_L_E_T_ = ''
								AND SUBSTRING(PB_DATA,1,6) BETWEEN '202303' AND '202303'
								)SPB ON RC_FILIAL = PB_FILIAL AND RC_MAT = PB_MAT AND RC_PD = PB_PD AND RC_PERIODO = PB_PERIODO
					WHERE SRC.D_E_L_E_T_ = ''
					AND RC_PERIODO BETWEEN '202303' AND '202303'
					AND RC_PD IN ('262','243','261','113')
					GROUP BY M0_CODIGO,M0_CODFIL,M0_FILIAL,M0_CGC,RA_FILIAL,RA_MAT,RA_NOME,RA_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,RC_PD,RV_DESC,RA_SALARIO,RC_VALOR,PB_HORAS,RV_TIPOCOD,RC_PERIODO)TB
		PIVOT(SUM(RD_VALOR)
		FOR RV_TIPOCOD IN ([1],[2],[3]))P
		)TB1
GROUP BY RD_PERIODO,CTT_DESC01
ORDER BY 1,2

	ENDSQL



	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return




Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De Periodo:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Ate Periodo:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
//u_InPutSX1(cPerg,"03",PADR("Usuario:" ,20)+"?","","","mv_ch3","C",4,0,0,"G","","","","","mv_par03") 
//u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")           

Return
