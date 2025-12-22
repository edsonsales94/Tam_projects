#INCLUDE "totvs.ch"

//-----------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} IMPLOGEX

Relação das etiquetas em excel, conforme parâmetro passado para função. Utilizado no fonte XETQEMP2A4

@author Guilherme Ricci - TOTVS IP
@since 31/07/2018

@param Vetor com a lista de produtos que precisam ser impressos.

@return Não há.

@see XETQEMP2A4.prw
/*/
//-----------------------------------------------------------------------------------------------------------------------------------

User Function ImpLogExcel( aParam )

Local oReport

Private aProd	:= aClone(aParam)

oReport	:= ReportDef()

oReport:PrintDialog()

Return

Static Function ReportDef()

Local cTitulo 	:= "Log de Etiquetas impressas - XETQEMP2A4"
Local cHelp		:= "Relatório que lista as etiquetas impressas anteriormente no programa XETQEMP2A4 (Hondalock)."
Local oReport
Local oSection1

Local nX	:= 0

oReport := TReport():New("LOGETIQ", cTitulo, /*cPergunta*/,{|oReport|ReportPrint(oReport)}, cHelp)
oReport:SetTotalInLine(.F.)
oReport:SetLandScape()
oReport:ShowHeader()
	
//Primeira seção
oSection1 := TRSection():New(oReport,"Produtos")    

TRCell():New(oSection1, "PROD"		, 	"TEMP", "Produto"	, PesqPict("SB1","B1_COD"), TamSx3("B1_COD")[1])
//TRCell():New(oSection1, "DESC"		, 	"TEMP", "Descrição"	, PesqPict("SB1","B1_DESC"), TamSx3("B1_DESC")[1]) Luciano Lamberti
TRCell():New(oSection1, "DESC"		, 	"TEMP", "Descrição"	, PesqPict("SB1","B1_DESCHL"), TamSx3("B1_DESCHL")[1])
TRCell():New(oSection1, "LADO"		, 	"TEMP", "Lado"		, PesqPict("SB1","B1_LADO"), TamSx3("B1_LADO")[1])
TRCell():New(oSection1, "DATA"		, 	"TEMP", "Data"		, "@!", 10)
TRCell():New(oSection1, "QTD"		, 	"TEMP", "Quantidade", PesqPict("SD3","D3_QUANT"), TamSx3("D3_QUANT")[1]) 

Return oReport

//Busca e imprime os dados do relatório
Static Function ReportPrint(oReport)

Local oSecao1 := oReport:Section(1)

Local cProd 	:= ""
Local cDesc		:= ""
Local cLado		:= ""
Local dData		:= StoD("")
Local nQtd		:= 0

Local nX		:= 0

oSecao1:Init()

oReport:SetMeter(Len(aProd))  

For nX := 1 To Len(aProd)

	cProd := aProd[nX,1]
	cDesc := aProd[nX,2]
	cLado := aProd[nX,3]
	dData := aProd[nX,4]
	nQtd  := aProd[nX,5]
	
	oSecao1:Cell("PROD"):SetValue(cProd)
	oSecao1:Cell("DESC"):SetValue(cDesc)
	oSecao1:Cell("LADO"):SetValue(cLado)
	oSecao1:Cell("DATA"):SetValue(dData)
	oSecao1:Cell("QTD"):SetValue(nQtd)
	
	oSecao1:PrintLine()
	oReport:SkipLine()
	oReport:IncMeter()
Next

oSecao1:Finish()

Return