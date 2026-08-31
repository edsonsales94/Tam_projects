#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLEXTR11    บAutor  ณJuevan Silva   				บ Data ณ  05/10/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rio rastreio de nota assist๊ncia				   	  							 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMASSR07()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMASSR07"

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

	oReport := TReport():New(cPerg,"Rel.Rastreio de Nota Assistencia",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo todos os itens da select
	oSection := TRSection():New(oReport,"Rel.Rastreio de Nota Assistencia",{"SD1"},aOrdem)  
	
	TRCell():New(oSection,"DT_DIGITACAO"    	,"SD1","DATADIGIT","@!",15)
	TRCell():New(oSection,"NOTA_ENTRADA"  	,"SD1","ENTRADA","@!",10)
	TRCell():New(oSection,"SERIE_ENTRADA"   	,"SD1","SERIE","@!",4)
	TRCell():New(oSection,"NOTA_SAIDA"   	,"SC6","Nota Saida","@!",15)
    TRCell():New(oSection,"SERIE_SAIDA"    	,"SC6","SERSAIDA","@!",4)
    TRCell():New(oSection,"PEDIDO"    	,"SC6","PEDIDO","@!",8)
    TRCell():New(oSection,"ITEM"    	,"SD1","ITEMNOTA","@!",15)
    TRCell():New(oSection,"CODIGO"    	,"SD1","CODNOTA","@!",15)
    TRCell():New(oSection,"DESCRICAO"    	,"SB1","DESCRICAO","@!",60)
    TRCell():New(oSection,"ARMAZEM"    	,"SC6","LOCAL","@!",4)
    TRCell():New(oSection,"QTD_NOTA"    	,"SD1","LOCAL","@!",4)
    TRCell():New(oSection,"QTD_PEDIDO"    	,"SC6","QTPEDIDO","@E 999,999,999,999",)
    TRCell():New(oSection,"QTD_ENTREGUE"    	,"SC6","QTENTREGUE","@E 999,999,999,999",4)
    TRCell():New(oSection,"CLIENTE"    	,"SA1","CODCLI","@!",7)
    TRCell():New(oSection,"NOME"    	,"SA1","NOMECLI","@!",20)


   
    
	

	/* 
	TRCell():New(oSection,"QTD_PELMEX"	    ,"SF2","QTD.PELEX","@E 999,999,999,999",)          
	TRCell():New(oSection,"QTD_APTPEL"      ,"SF2","QTD.APT PEL","@E 999,999,999,999",) 
	TRCell():New(oSection,"QTD_AMAZON"   	,"SF2","QTD.AMAZON","@E 999,999,999,999",)
	TRCell():New(oSection,"QTD_APTAMA"      ,"SF2","QTD.APT AMA","@E 999,999,999,999",)
	TRCell():New(oSection,"DIF_PELXAMA"     ,"SF2","DIFERENCA","@E 999,999,999,999",)*/

	
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("ETIQUETA"),"Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)

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
		
		SELECT CONVERT(VARCHAR,CAST(D1_DTDIGIT AS DATE),103)DT_DIGITACAO,
       D1_DOC NOTA_ENTRADA,D1_SERIE SERIE_ENTRADA,C6_NOTA NOTA_SAIDA,C6_SERIE SERIE_SAIDA,
     C6_NUM PEDIDO,D1_ITEM ITEM,D1_COD CODIGO,B1_DESC DESCRICAO,C6_LOCAL ARMAZEM,D1_QUANT QTD_NOTA,C6_QTDVEN QTD_PEDIDO,C6_QTDENT QTD_ENTREGUE,A1_COD CLIENTE,A1_NOME NOME
FROM SD1100 SD1 (NOLOCK)
INNER JOIN SA1100 SA1 (NOLOCK) ON D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB1 (NOLOCK) ON D1_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
LEFT JOIN SB6100 SB6 (NOLOCK) ON D1_FILIAL = B6_FILIAL AND D1_DOC = B6_DOC AND D1_SERIE = B6_SERIE AND D1_IDENTB6 = B6_IDENT AND D1_COD = B6_PRODUTO AND SB6.D_E_L_E_T_ = ''
LEFT JOIN SC6100 SC6 (NOLOCK) ON B6_FILIAL = C6_FILIAL AND B6_CLIFOR = C6_CLI AND B6_LOJA = C6_LOJA AND B6_IDENT = C6_IDENTB6 AND B6_PRODUTO = C6_PRODUTO AND B6_DOC = C6_NFORI AND B6_SERIE = C6_SERIORI AND SC6.D_E_L_E_T_ = ''
WHERE SD1.D_E_L_E_T_ = ''
AND D1_DOC BETWEEN  %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
AND D1_SERIE BETWEEN  %Exp:MV_PAR03% AND %Exp:MV_PAR04% 

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Doc Entrada:",20)+"?","","","mv_ch1","C",9,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Doc Entrada:",20)+"?","","","mv_ch2","C",9,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Serie:" ,20)+"?","","","mv_ch3","C",3,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Serie:",20)+"?","","","mv_ch4","C",3,0,0,"G","","","","","mv_par04")
	

Return
