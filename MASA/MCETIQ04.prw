#include "TOTVS.ch"
#INCLUDE "PROTHEUS.CH"
#include "Tbiconn.ch"
#include "rwmake.ch"

// NOME DO PC PA-ALMOX01
// NOME IMPRESSORA COMPARTILHADA ZD220-203
// CONFIGURAÇÃO LPT1 : net use LPT1: \\PA-ALMOX01\ZD220-203 senha /USER:usuario /PERSISTENT:YES


User Function MCETIQ04()
	Local aArea := FwGetArea()
	Local aRet := {}
	Local aPergs := {}
	Local cProd := ''
	Local cPrinter := ''

	// RpcSetEnv('01','01')

	cProd := space(tamsx3("C2_NUM")[1])
	Aadd(aPergs,{1,"Ordem Producao: ",cProd,"@!","u_ValidOp()",'SC2',".T.",120,.T.})
	aAdd(aPergs,{1,"Quantidade: " ,Space(4),"","","","",0 ,.F.})
	aAdd(aPergs,{1,"Densidade: " ,'12',"","","","",0 ,.F.})
	aAdd(aPergs, {2, "Impressora",cPrinter, {"ZT411","ZT410","ZM400"},     122, ".T.", .F.})

	If !ParamBox(aPergs ,"Etiquetas ...",@aRet)
		Return
	Else
		Processa( {|| xfImpPA() }, "Aguarde...","Imprimindo...",.F.)
	Endif

	FwRestArea(aArea)

Return

Static Function xfImpPA()
	Local nX := 0
	Local cDir    := "\etiquetas\" //pasta criada no protheus_data
	Local cFile   :=""
	Local cLabel  := ""
	Local cPrinterPath:= "" //compartilhamento da impressora na rede
	Local cSeq := GETMV('MV_SEQETQ')
	Local cNomePC := ComputerName()
	Local cDirLocal := "C:\TEMP\"
	Local cPrinter := ALLTRIM(MV_PAR04)

	// if Empty(SB1->B1_XHALB)
	// 	Alert('Codigo do cliente está vazio no cadastro do produto, verifique o cadastro.', 'Atenção!!!')
	// 	Return
	// endif

	// if Empty(SB1->B1_XNATCOD)
	// 	Alert('Codigo do país está vazio no cadastro do produto, verifique o cadastro.', 'Atenção!!!')
	// 	Return
	// endif

	// if Empty(SB1->B1_XIDCLIE)
	// 	Alert('ID do cliente está vazio no cadastro do produto, verifique o cadastro.', 'Atenção!!!')
	// 	Return
	// endif

	// SEMMPRE QUE ALCANÇAR 9999 REINICIA A SEQUENCIA.
	// if cSeq == '99999999'
	// 	cSeq := '00000000'
	// endif

	cSeq := SOMA1(cSeq)
	if cSeq == '99999999'
		cSeq := '100000000'
	endif

	cCliente:='SAMSUMG'

	dbselectarea('SB1')
	dbSetOrder(1)
	dbselectarea('SA7')
	dbSetOrder(2)
	dbselectarea('SA1')
	dbSetOrder(1)

	SB1->(MSSEEK(xFilial('SB1')+SC2->C2_PRODUTO))
	If SA7->(MSSEEK(xFilial('SA7')+SC2->C2_PRODUTO+SC2->C2_XCODCLI+SC2->C2_XLOJA))
		cProdCli := alltrim(SA7->A7_CODCLI)
	Else
		FwAlertWarning("Cliente "+alltrim(SC2->C2_XCODCLI)+" não encontrado nas SA1.",'Atenção!!!')
		Return
	EndIf

	If SA1->(MSSEEK(xFilial('SA1')+SC2->C2_XCODCLI+SC2->C2_XLOJA))
		if Empty(SA1->A1_NOMETIQ)
			FwAlertWarning("O Campo 'Abrev. Nome' na tebela  SA1 rotina Cadastro de Cliente não foi preenchido, ajuste o cadastro.",'Impressao Cancelada!!!')
			Return
		Else
			cCliente := alltrim(SA1->A1_NOMETIQ)
		endif
	EndIf

	// BR30BN6108855AMASAC9D0301
	cQR := 	SB1->B1_COD+;  // CODIGO PRODUTO
	AllTRim(cSeq)+; // SEQUENCIA
	STRZERO(VAL(MV_PAR02),5)+;	     // QUANTIDADE
	STRZERO(VAL(SC2->C2_NUM),8)     // OP

	//Incrementa a mensagem na régua
	IncProc("Imprindo etiquetas " + cValToChar(nX) + " de " + cValToChar(MV_PAR02) + "...")

	cLabel:= ""

	cLabel+= ("CT~~CD,~CC^~CT~ ")
	cLabel+= (" ^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA ")
	cLabel+= (" ^PR10,10 ")
	cLabel+= (" ~SD15^JUS^LRN^CI0^XZ ")
	cLabel+= (" ^XA ")
	cLabel+= (" ^MMT ")
	cLabel+= (" ^PW945 ")
	cLabel+= (" ^LL0650 ")
	cLabel+= (" ^LS0 ")
	cLabel+= (" ^FT32,211^A0N,42,38^FH\^FD"+cProdCli+"^FS ")
	cLabel+= (" ^FT356,91^A0N,42,38^FH\^FD"+cSeq+"^FS ")
	cLabel+= (" ^FT365,469^A0N,33,31^FH\^FD"+MV_PAR02+"^FS ")
	cLabel+= (" ^FT704,623^A0N,37,52^FH\^FDRE:____^FS ")
	cLabel+= (" ^FT703,575^A0N,37,36^FH\^FDTURNO:____^FS ")
	cLabel+= (" ^FT702,526^A0N,37,33^FH\^FDMAQ: "+SC2->C2_XMAQ+"^FS ")
	cLabel+= (" ^FT702,477^A0N,37,36^FH\^FD___/09/2025 ^FS ")
	cLabel+= (" ^FT270,468^A0N,33,31^FH\^FDQTD: ^FS ")
	cLabel+= (" ^FT101,468^A0N,33,31^FH\^FD"+SC2->C2_NUM+"^FS ")
	cLabel+= (" ^FT269,512^A0N,33,31^FH\^FDALMOX: ^FS ")
	cLabel+= (" ^FT394,512^A0N,33,31^FH\^FD"+SC2->C2_LOCAL+"^FS ")
	cLabel+= (" ^FT152,512^A0N,33,31^FH\^FD"+SC2->C2_XMOLDE+"^FS ")
	cLabel+= (" ^FT36,512^A0N,33,31^FH\^FDMOLDE:^FS ")
	cLabel+= (" ^FT36,468^A0N,33,31^FH\^FDOP: ^FS ")
	cLabel+= (" ^FT35,627^A0N,80,141^FH\^FD"+cCliente+"^FS ")
	cLabel+= (" ^FT33,345^A0N,37,36^FH\^FD"+SB1->B1_DESC+"^FS ")
	cLabel+= (" ^FT34,150^A0N,42,38^FH\^FD"+SB1->B1_COD+"^FS ")
	cLabel+= (" ^FT34,91^A0N,42,38^FH\^FDMASA^FS ")
	cLabel+= (" ^FT682,313^BQN,2,8 ")
	cLabel+= (" ^FDLA,"+cQR+"^FS ")
	cLabel+= (" ^PQ1,0,1,Y^XZ ")

	impriRaw(cLabel,cPrinter,cSeq)
Return


User function ValidOp()
	local lret:= .F.
	dbselectarea('SC2')
	dbsetorder(1)

	if MSSEEK(xFilial('SC2')+MV_PAR01)
		lRet := .T.
	Else
		Alert('Oderm de producao não localizada !!!')
	EndIf

return lret


// Exemplo de impressão RAW usando FWMSPrinter
Static Function impriRaw(cZPL,cPrinter,cSeq)

	Local oPrinter   := Nil
	Local cFileRel   := "RAW_ETIQUETA" // pode ser apenas identificador
	Local oPrintSetupParam := Nil
	Local lAdjustToLegacy   := .F.
	Local lDisableSetup     := .T.
	// Local oPrinter
	Local cLocal            := "c:\temp"
	Local nPrtType          := 2 // IMP_PDF > 6 || IMP_SPOOL > 2
	Local aDevice           := {}
	Local cSession          := GetPrinterSession()

	// Criar objeto FWMSPrinter em modo RAW
	oPrinter := FWMSPrinter():New(cFileRel, nPrtType, lAdjustToLegacy, '', lDisableSetup,.F.,NIL ,cPrinter ,.F. ,.T., .T. /*LRAW*/)

	// Aqui é só usar SAY, que em RAW escreve direto
	oPrinter:Say(0, 0, cZPL)

	oPrinter:Print()

	PUTMV("MV_SEQETQ",cSeq)
Return
