#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLETQR14    ºAutor  ³Stan Lee lOpes     				º Data ³  16/03/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   	Protocolo Diferenca Etiq. RFID                            			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLETQR14()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLETQR14"

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

	oReport := TReport():New(cPerg,"Protocolo Diferenca Etiq. RFID",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Protocolo Diferenca Etiq. RFID",{"PED"},aOrdem)  
	
	TRCell():New(oSection,"PED_NUM"	        ,"PED","Pedido","@!",10)             
	TRCell():New(oSection,"PED_OP"          ,"PED","Ordem Produção","@!",10)
	TRCell():New(oSection,"PED_DTPROPEL"	,"PED","Dt.Produção","@!",15)
	TRCell():New(oSection,"PED_PRODUTO"	    ,"PED","Produto","@!",20)
	TRCell():New(oSection,"PED_DESCRI"	    ,"PED","Descrição","@!",100)
	TRCell():New(oSection,"PED_QUANT"	    ,"PED","Qtd.Pedido","@!",30)
	TRCell():New(oSection,"QTD_ETIQUETA"	,"PED","Qtd.Etiqueta","@!",30)
	TRCell():New(oSection,"DIFERENCA"	    ,"PED","Diferença","@!",30)
	TRCell():New(oSection,"RECEB_ETIQUETA"	,"PED","Usuário Recebimento","@!",30)
	TRCell():New(oSection,"PED_NOME"	    ,"PED","Cliente","@!",30)
	
	
	
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

SELECT *
FROM(
SELECT PED_NUM,PED_OP,PED_DTPROPEL,PED_PRODUTO,PED_DESCRI,CAST(SUM(PED_QUANT) AS INT)PED_QUANT,ISNULL(QTD_ETIQUETA,0)QTD_ETIQUETA,CAST(SUM(PED_QUANT) AS INT)-ISNULL(QTD_ETIQUETA,0)DIFERENCA,ISNULL(ETP_USERINC,'')RECEB_ETIQUETA,PED_NOME
FROM PED
LEFT JOIN (SELECT SUBSTRING(ETP_CPRODUC,1,6)ETP_OP,ETP_PRODUTO,ETP_DESCRI,COUNT(ETP_CPRODUC)QTD_ETIQUETA,ETP_USERINC
		   FROM ETP
           GROUP BY SUBSTRING(ETP_CPRODUC,1,6),ETP_PRODUTO,ETP_DESCRI,ETP_USERINC
		   )ETP ON PED_OP = ETP_OP AND PED_PRODUTO = ETP_PRODUTO
WHERE CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND PED_STATUS = ''
GROUP BY PED_NUM,PED_OP,PED_DTPROPEL,PED_PRODUTO,PED_DESCRI,QTD_ETIQUETA,PED_NOME,ETP_USERINC
)TB
WHERE PED_QUANT > QTD_ETIQUETA
ORDER BY PED_OP



	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt.Produção:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Dt.Produtoção:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	
Return