#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLETQR15    บAutor  ณWylliam Silva     				บ Data ณ  16/03/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   	Relat๓rio Checklist Reimpressใo Etiqueta                   			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLETQR15()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLETQR15"

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

	oReport := TReport():New(cPerg,"Relat๓rio Checklist Reimpressใo Etiqueta ",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Relat๓rio Checklist Reimpressใo Etiqueta ",{"SZ4"},aOrdem)  
	
	TRCell():New(oSection,"C2_NUM"	        ,"SC2","ORDEM","@!",8)             
	TRCell():New(oSection,"CODIGO"          ,"SZ4","CODIGO","@!",15)
	TRCell():New(oSection,"B1_DESC"			,"SB1","DESCRICAO","@!",30)
	TRCell():New(oSection,"Z4_CPRODUC"	    ,"SZ4","CHASSIS","@!",20)
	TRCell():New(oSection,"DTINC"	 		,"SZ4","DTINC","@!",8)
	TRCell():New(oSection,"Z4_USUARIO"	    ,"SZ4","USUARIO","@!",)
	TRCell():New(oSection,"Z4_RFID"			,"SZ4","IMPRESSO","@!",2)
	TRCell():New(oSection,"Z4_NUMERO"		,"SZ4","QTD","@!",3)
	TRCell():New(oSection,"Z4_XUSERAL"	    ,"SZ4","USUARIO ALT","@!",10)
	TRCell():New(oSection,"DTALTERACAO"	    ,"SZ4","DT ALTERACAO","@!",8)
	
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("PED_QUANT"),"Total Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)

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

			SELECT C2_NUM,SUBSTRING(Z4_CEXPEDI,1,15) CODIGO,B1_DESC,Z4_CPRODUC, CONVERT(VARCHAR,CAST(Z4_DATA AS DATE),103) DTINC,Z4_USUARIO,Z4_RFID,Z4_NUMERO,Z4_XUSERAL,
					CONVERT(VARCHAR,CAST(Z4_XDATALT AS DATE),103) DTALTERACAO 
			FROM SZ4100 SZ4
			INNER JOIN SB1100 SB1 ON SUBSTRING(Z4_CEXPEDI,1,15) = B1_COD AND SB1.D_E_L_E_T_ = '' 
			LEFT JOIN SC2100 SC2 ON SUBSTRING(Z4_CPRODUC,1,8) = C2_NUM+C2_ITEM AND SUBSTRING(Z4_CEXPEDI,1,15) =C2_PRODUTO AND SC2.D_E_L_E_T_ = ''
			WHERE Z4_XDATALT BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
			ORDER BY Z4_XDATALT	


	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Data:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	
Return