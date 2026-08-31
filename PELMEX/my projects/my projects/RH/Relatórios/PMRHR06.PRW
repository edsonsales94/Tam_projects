
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMRHR06  บAutor  ณJuevan Silva     				บ Data ณ  24/04/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Rel. de Ausencia                     			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMRHR06()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMRHR06"

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

	oReport := TReport():New(cPerg,"Rel. de Ausencia",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. de Ausencia",{"SC2"},aOrdem) 

    TRCell():New(oSection,"EMPRESA"   	    ,"SRA","EMPRESA","@!",7)
	TRCell():New(oSection,"R8_FILIAL"		      ,"SR8","R8_FILIAL","@!",3)
	TRCell():New(oSection,"RA_NOME"		    ,"SRA","RA_NOME","@!",30)
    TRCell():New(oSection,"RA_CC"		     ,"SRA","RA_CC","@!",7)
	TRCell():New(oSection,"CTT_DESC01"		  ,"CTT","CTT_DESC01","@!",20)
    TRCell():New(oSection,"R8_TIPOAFA"	      ,"SR8","R8_TIPOAFA","@!",4) 
	TRCell():New(oSection,"DESCRICAO"  	     ,"SRA","DESCRICAO","@!",40)
	TRCell():New(oSection,"R8_CID"		 ,"SR8","R8_CID","@!",3)
	TRCell():New(oSection,"R8_DATA"         ,"SR8","R8_DATA","@!",10)
	TRCell():New(oSection,"R8_DATAINI" 	         ,"SR8","R8_DATAINI","@!",10)
	TRCell():New(oSection,"R8_DATAFIM"	    ,"SR8","R8_DATAFIM","@!",10)
	TRCell():New(oSection,"DIAS"  			,"SRA","DIAS","@!",3)
    TRCell():New(oSection,"R8_OBSAFAS"  	,"SR8","R8_OBSAFAS","@!",100)
	//TRCell():New(oSection,"CLIENTE"     	,"SC2","CLIENTE","@!",30) 

	
    
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("PED_QUANT"),"Total Etiqueta:","SUM",,,"@E 999,999,999.999",,.F.,.T.)

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


SELECT 'PELMEX' EMPRESA,R8_FILIAL,RA_MAT,RA_NOME,RA_CC,CTT_DESC01,R8_TIPOAFA,UPPER(RCM_DESCRI)DESCRICAO,R8_CID,R8_DATA,R8_DATAINI,R8_DATAFIM,R8_OBSAFAS,
       CASE WHEN R8_DATAFIM = '' THEN DATEDIFF(DAY,R8_DATAINI,CONVERT(VARCHAR,GETDATE(),112))+1 ELSE DATEDIFF(DAY,R8_DATAINI,R8_DATAFIM)+1 END DIAS
FROM SR8100 SR8 (NOLOCK)
INNER JOIN SRA100 SRA (NOLOCK) ON R8_FILIAL = RA_FILIAL AND R8_MAT = RA_MAT AND SRA.D_E_L_E_T_ = ''
INNER JOIN CTT100 CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
INNER JOIN RCM100 RCM (NOLOCK) ON R8_TIPOAFA = RCM_TIPO
WHERE SR8.D_E_L_E_T_ = ''
AND RA_CC BETWEEN '' AND 'ZZZZZZ'
AND R8_TIPOAFA BETWEEN '004' AND '004'
AND RA_FILIAL BETWEEN '01' AND '01'
AND R8_DATAINI BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
UNION
SELECT 'AMAZON' EMPRESA,R8_FILIAL,RA_MAT,RA_NOME,RA_CC,CTT_DESC01,R8_TIPOAFA,UPPER(RCM_DESCRI)DESCRICAO,R8_CID,R8_DATA,R8_DATAINI,R8_DATAFIM,R8_OBSAFAS,
       CASE WHEN R8_DATAFIM = '' THEN DATEDIFF(DAY,R8_DATAINI,CONVERT(VARCHAR,GETDATE(),112))+1 ELSE DATEDIFF(DAY,R8_DATAINI,R8_DATAFIM)+1 END DIAS
FROM SR8200 SR8 (NOLOCK)
INNER JOIN SRA200 SRA (NOLOCK) ON R8_FILIAL = RA_FILIAL AND R8_MAT = RA_MAT AND SRA.D_E_L_E_T_ = ''
INNER JOIN CTT200 CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
INNER JOIN RCM200 RCM (NOLOCK) ON R8_TIPOAFA = RCM_TIPO
WHERE SR8.D_E_L_E_T_ = ''
AND RA_CC BETWEEN '' AND 'ZZZZZZ'
AND R8_TIPOAFA BETWEEN '004' AND '004'
AND RA_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND R8_DATAINI BETWEEN  %Exp:MV_PAR03% AND %Exp:MV_PAR04%
ORDER BY 1,R8_FILIAL,CTT_DESC01,RA_NOME

		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

    u_InPutSX1(cPerg,"01",PADR("De Filial:" ,20)+"?","","","mv_ch3","C",4,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Filial:",20)+"?","","","mv_ch4","C",4,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par04")
	
	
	
	
Return
