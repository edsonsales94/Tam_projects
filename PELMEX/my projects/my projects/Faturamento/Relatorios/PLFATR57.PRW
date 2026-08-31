#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR22    บAutor  ณWylliam Silva     				บ Data ณ  12/07/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   	Produtos Reservados do 50  	    	                     			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR57()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLFATR57"

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

	oReport := TReport():New(cPerg,"Pedidos armaz้m 50",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Pedidos armaz้m 50",{"SC5"},aOrdem)  

    TRCell():New(oSection,"EMISSAO"	         ,"SC5","DT_EMISSAO","@!",10) 
    TRCell():New(oSection,"C6_LOCAL"	     ,"C56","ARMAZษM","@!",3)             
	TRCell():New(oSection,"C6_NUM"           ,"SC6","NUM_PEDIDO","@!",6)
	TRCell():New(oSection,"C6_ITEM"          ,"SC6","ITEM","@!",3)
	TRCell():New(oSection,"C6_PRODUTO"       ,"SC6","PRODUTO","@!",16)
	TRCell():New(oSection,"C6_DESCRI"         ,"SC6","DESC_PRODUTO","@!",3)
	TRCell():New(oSection,"C6_QTDVEN"        ,"SC6","QTDE","@E 999,999,999,999",)
    TRCell():New(oSection,"C6_PRUNIT"        ,"SC6","PRC_UNIT","@E 999,999,999.99",)
    TRCell():New(oSection,"C6_PRCVEN"        ,"SC6","PRC_VENDA","@E 999,999,999.999",)
    TRCell():New(oSection,"C6_VALOR"         ,"SC6","VLR TOTAL","@E 999,999,999.999",)
    TRCell():New(oSection,"C5_NOTA"         ,"SC5","NOTA_FISCAL","@!",9)
    TRCell():New(oSection,"C5_SERIE"         ,"SC5","SERIE","@!",3)
	TRCell():New(oSection,"C5_CLIENTE"       ,"SC5","COD_CLIENTE","@!",8)
	TRCell():New(oSection,"A1_NOME"    	     ,"SA1","NOME_CLIENTE","@!",30)
    TRCell():New(oSection,"OBSSERV"        ,"SC5","OBSERVACOES","@!",45)

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
		

    SELECT CONVERT(VARCHAR,CAST(C5_EMISSAO AS DATE),112) EMISSAO,C6_LOCAL,C6_NUM,C6_ITEM,C6_PRODUTO,C6_DESCRI,
			C6_QTDVEN,C6_PRUNIT,C6_PRCVEN,C6_VALOR,C5_NOTA,C5_SERIE,C5_CLIENTE,A1_NOME,C5_OBS1+C5_OBS2+C5_OBS3 OBSSERV
    FROM SC6100 (NOLOCK) SC6
    INNER JOIN SC5100 (NOLOCK) SC5 ON C6_CLI = C5_CLIENTE AND C5_NUM = C6_NUM AND C5_FILIAL = C6_FILIAL AND SC5.D_E_L_E_T_ = ''
	INNER JOIN SA1100 (NOLOCK) SA1 ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND SA1.D_E_L_E_T_ = ''
    WHERE SC6.D_E_L_E_T_ = ''
    AND C6_LOCAL = '50'
    AND C5_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%

    EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Data Inc:"     ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data Fim:"    ,20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")


Return
