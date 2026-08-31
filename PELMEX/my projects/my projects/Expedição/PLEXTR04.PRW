#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLEXPR02    บAutor  ณWilson Guedes     				บ Data ณ  22/10/20 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  RELATORIO DE VEICULO X NOTA			    								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLEXPR04()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLEXPR04"

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

	oReport := TReport():New(cPerg,"Veiculo X Nota",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()                                                                                                                      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Veiculo X Nota",{"SAI"},aOrdem) 
	TRCell():New(oSection,"D2_DOC"		   			,"cAlias","Nota",,13)
	TRCell():New(oSection,"D2_SERIE"		   		,"cAlias","Serie",,7)
	TRCell():New(oSection,"D2_PEDIDO"		   		,"cAlias","Pedido",,9)
	TRCell():New(oSection,"C5_TRANSP"				,"cAlias","Cod.Transp",,13)
	TRCell():New(oSection,"A4_NOME"		   			,"cAlias","Nome",,20)
	TRCell():New(oSection,"C5_VEICULO"		   		,"cAlias","Cod.Veiculo",,13)
	TRCell():New(oSection,"DA3_PLACA"		   		,"cAlias","Placa",,13)
	TRCell():New(oSection,"VALOR"					,"cAlias","Valor",,20)

	//TRFunction():New(oSection:Cell("ENT_QUANT"),"TOTAL DE SAIDA","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	//Totalizador
	/*                                                                                  

	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)  
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)



	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%   



		SELECT D2_DOC,D2_SERIE,D2_PEDIDO,C5_TRANSP,A4_NOME,
		CASE WHEN C5_VEICULO = '' THEN 'SEM VEICULO' ELSE C5_VEICULO END C5_VEICULO,
		ISNULL(DA3_PLACA,'SEM PLACA') DA3_PLACA,'R$____________________,______' VALOR 
		FROM %Table:SC5% SC5
		INNER JOIN %Table:SD2% SD2 (NOLOCK) ON D2_PEDIDO = C5_NUM AND C5_FILIAL = D2_FILIAL
		LEFT JOIN %Table:SA4% SA4 (NOLOCK) ON A4_COD = C5_TRANSP
		LEFT JOIN %Table:DA3% DA3 (NOLOCK) ON DA3_COD = C5_VEICULO
		WHERE C5_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND C5_TRANSP NOT IN ('')
		AND SD2.D_E_L_E_T_ = ''
		AND SA4.D_E_L_E_T_ = ''
		AND SC5.D_E_L_E_T_ = ''
		GROUP BY D2_DOC,D2_SERIE,D2_PEDIDO,C5_TRANSP,A4_NOME,SC5.C5_VEICULO,DA3_PLACA
		ORDER BY C5_TRANSP,D2_DOC 	    




	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Emissใo De?     ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissใo Ate?    ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")  



Return