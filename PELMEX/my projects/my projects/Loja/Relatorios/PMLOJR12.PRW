#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMLOJR11    บAutor  ณStan Lee Lopes     				บ Data ณ  07/22/20 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Controle de entrega														 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMLOJR12()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMLOJR12"

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

	oReport := TReport():New(cPerg,"Controle de entrega ",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Controle de entrega",{"SA1"},aOrdem) 




	TRCell():New(oSection,"A1_NOME"		,"SA1","Nome",/*Mascara*/,) 
	TRCell():New(oSection,"A1_END"   	,"SA1","Endere็o",/*Mascara*/,60) 
	TRCell():New(oSection,"A1_BAIRRO"	,"SA1","Bairro",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"A1_DDD" 		,"SA1","DDD",/*Mascara*/,)
	TRCell():New(oSection,"A1_TEL"		,"SA1","Telefone",,12)  
	TRCell():New(oSection,"A1_TELEX"	,"SA1","Telefone 2",,12)
	TRCell():New(oSection,"A1_FAX"		,"SA1","Telefone 3",,12) 
	TRCell():New(oSection,"D2_DOC"		,"SD2","Nota",,/*Tamanho*/) 
	TRCell():New(oSection,"D2_SERIE"	,"SD2","Serie",,/*Tamanho*/)
	TRCell():New(oSection,"D2_EMISSAO"	,"SD2","Emissใo",,/*Tamanho*/)
	TRCell():New(oSection,"SAI_DTEXP"	,"SAI","Expedi็ใo",,) 


	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("L2_VLRITEM"),"TOTAL BASE","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)


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

		SELECT A1_NOME,A1_END,A1_BAIRRO,A1_DDD,A1_TEL,A1_TELEX,A1_FAX,D2_DOC,D2_SERIE,D2_EMISSAO,ISNULL(CONVERT(VARCHAR(13),SAI_DTEXP, 112),'NรO EXPEDIDO') SAI_DTEXP
		FROM %Table:SD2% SD2
		LEFT JOIN SAI ON SAI_DOC = D2_DOC AND SAI_SERIE = D2_SERIE AND SD2.D_E_L_E_T_ ='' 
		INNER JOIN %Table:SA1% SA1 ON A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND SA1.D_E_L_E_T_ =''
		WHERE
		D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND D2_FILIAL = '01'
		GROUP BY A1_NOME,A1_END,A1_BAIRRO,A1_DDD,A1_TEL,A1_TELEX,A1_FAX,D2_DOC,D2_SERIE,D2_EMISSAO,SAI_DTEXP
		ORDER BY D2_EMISSAO,A1_NOME

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)
	u_InPutSX1(cPerg,"01",PADR("Emissใo De   ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissใo At้  ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 

Return
