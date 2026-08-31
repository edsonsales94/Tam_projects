#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR56    บAutor  ณStan Lee lOpes     				บ Data ณ  08/02/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   	Protocolo Etiqueta RFID                                 			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR56()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR56"

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

	oReport := TReport():New(cPerg,"Protocolo Etiqueta RFID",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Protocolo Etiqueta RFID",{"PED"},aOrdem)  
	
	TRCell():New(oSection,"PED_NUM"	        ,"PED","Pedido","@!",10)             
	TRCell():New(oSection,"PED_OP"          ,"PED","Ordem Produ็ใo","@!",10)
	TRCell():New(oSection,"PED_DTPROPEL"	,"PED","Dt.Produ็ใo","@!",15)
	TRCell():New(oSection,"PED_PRODUTO"	    ,"PED","Produto","@!",20)
	TRCell():New(oSection,"PED_DESCRI"	    ,"PED","Descri็ใo","@!",100)
	TRCell():New(oSection,"PED_QUANT"	    ,"PED","Qtd.Pedido","@E 999,999,999.9",)
	TRCell():New(oSection,"QTD_ETIQUETA"	,"PED","Qtd.Etiqueta","@E 999,999,999.9",)
	TRCell():New(oSection,"DIFERENCA"	    ,"PED","Diferen็a","@E 999,999,999.9",)
	TRCell():New(oSection,"RECEB_ETIQUETA"	,"PED","Usuแrio Recebimento","@!",30)
	TRCell():New(oSection,"PED_NOME"	    ,"PED","Cliente","@!",30)
	TRCell():New(oSection,"PED_SETOR"	    ,"PED","Setor","@!",25)
	
	
	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("PED_QUANT"),"Total Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)

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

SELECT *
FROM(
	SELECT PED_NUM,PED_OP,PED_DTPROPEL,PED_PRODUTO,PED_DESCRI,CAST(SUM(PED_QUANT) AS INT)PED_QUANT,CAST(ISNULL(QTD_ETIQUETA,0) AS FLOAT)QTD_ETIQUETA,CAST(SUM(PED_QUANT) AS INT)-CAST(ISNULL(QTD_ETIQUETA,0) AS FLOAT)DIFERENCA,ISNULL(ETP_USERINC,'')RECEB_ETIQUETA,PED_NOME,PED_SETOR
			FROM PED
			LEFT JOIN (SELECT ETP_OP,ETP_PRODUTO,SUM(QTD_ETIQUETA)QTD_ETIQUETA,ETP_USERINC
						FROM(
						SELECT SUBSTRING(ETP_CPRODUC,1,6)ETP_OP,ETP_PRODUTO,ETP_DESCRI,CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END QTD_ETIQUETA,ETP_USERINC
						FROM ETP
						INNER JOIN SB1100 SB1 (NOLOCK) ON ETP_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
						)TB
						GROUP BY ETP_OP,ETP_PRODUTO,ETP_USERINC
						)ETP ON PED_OP = ETP_OP AND PED_PRODUTO = ETP_PRODUTO
			WHERE CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
			AND PED_STATUS = ''
	GROUP BY PED_NUM,PED_OP,PED_DTPROPEL,PED_PRODUTO,PED_DESCRI,QTD_ETIQUETA,PED_NOME,ETP_USERINC,PED_SETOR
	)TB
ORDER BY PED_OP


	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt.Produ็ใo:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Dt.Produto็ใo:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	
Return
