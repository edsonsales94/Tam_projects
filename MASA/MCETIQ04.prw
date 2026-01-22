#include "TOTVS.ch"
#INCLUDE "PROTHEUS.CH"
#include "Tbiconn.ch"
#include "rwmake.ch"

// NOME DO PC PA-ALMOX01
// NOME IMPRESSORA COMPARTILHADA ZD220-203
// CONFIGURAÇÃO LPT1 : net use LPT1: \\PA-ALMOX01\ZD220-203 senha /USER:usuario /PERSISTENT:YES


User Function MCETIQ04()
	// Local aArea := FwGetArea()
	Local aRet := {}
	Local aPergs := {}
	Local cProd := ''
	Local cPrinter := ''

	// RpcSetEnv('01','01')
	// cAlias    := "SZ7"
	// cArquivo  := RETSQLNAME('SZ7')
	// CheckFile(cAlias, cArquivo)

	cProd := space(tamsx3("C2_NUM")[1])
	Aadd(aPergs,{1,"Ordem Producao: ",cProd,"@!","u_ValidOp()",'SC2',".T.",120,.T.})
	aAdd(aPergs,{1,"Quant. Produto: ",Space(8),"","!Empty(MV_PAR02)","","",0 ,.F.})
	aAdd(aPergs,{1,"Densidade: " ,'22',"","","","",0 ,.F.})
	aAdd(aPergs,{1,"Quant Etiqueta: " ,Space(4),"","!Empty(MV_PAR04)","","",0 ,.F.})
	aAdd(aPergs,{2, "Impressora",cPrinter, {"ZT411","ZT410","ZM400"},     122, ".T.", .F.})

	If !ParamBox(aPergs ,"Etiquetas ...",@aRet,,,,,,,,.F.,.T.)
		Return
	Else
		Processa( {|| xfImpPA() }, "Aguarde...","Imprimindo...",.F.)
	Endif

	// FwRestArea(aArea)
	u_MCETIQ04()
Return

Static Function xfImpPA()
	Local nX := 0
	// Local cDir    := "\etiquetas\" //pasta criada no protheus_data
	// Local cFile   :=""
	Local cLabel  := ""
	Local cAliasSZ7  := GETNEXTALIAS()
	// Local cPrinterPath:= "" //compartilhamento da impressora na rede
	Local cSeqEtiq1 := GETMV('MV_SEQETQ')
	// Local cNomePC := ComputerName()
	// Local cDirLocal := "C:\TEMP\"
	Local nTotal := VAL(MV_PAR04)
	Local cPrinter := ALLTRIM(MV_PAR05)

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
	// if cSeqEtiq1 == '99999999'
	// 	cSeqEtiq1 := '00000000'
	// endif

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
	BeginSQL ALIAS cAliasSZ7
		SELECT max(Z7_ETIQMAE) ULT_ETIQ FROM %table:SZ7%
	EndSQL

	cSeqEtiq1 := AllTRim((cAliasSZ7)->ULT_ETIQ) // sequencial da etiqueta MAE
  	
	ProcRegua(nTotal)
	//Incrementa a mensagem na régua
	for nx := 1 to nTotal

		cSeqEtiq1 := SOMA1(space(2)+cSeqEtiq1)
		cSeqEtiq1 := cvaltochar(val(cSeqEtiq1))
	
		// verificar se ainda existe saldo para imprimir
		// se o saldo já impresso + a quantidade sendo imprimida fo maior que a quantidade da OP aborta a impressão.
		if (val(MV_PAR02) + SC2->C2_QTDETIQ) > SC2->C2_QUANT .or. val(MV_PAR02) > SC2->C2_QUANT
			FwAlertWarning('O Saldo da etiqueta '+ cSeqEtiq1 + ' ultrapassa o Saldo da OP.','Impressao Cancelada!!!')
			Return
		EndIf


		IncProc("Imprindo etiquetas " + cValToChar(nX) + " de " + cValToChar(nTotal) + "...")
		// BR30BN6108855AMASAC9D0301
		
		cQR := 	SB1->B1_COD+space(1)+;  // CODIGO PRODUTO
		AllTRim(cSeqEtiq1)+;                 // SEQUENCIA
		STRZERO(VAL(MV_PAR02),5)+;	    // QUANTIDADE
		STRZERO(VAL(SC2->C2_NUM),8)     // OP

		dbselectarea('SZ7')
		dbsetorder(1)

		RECLOCK('SZ7', .T.)
			SZ7->Z7_ETIQMAE := cSeqEtiq1
			SZ7->Z7_PAMASA 	:= SB1->B1_COD
			SZ7->Z7_CODCLI 	:= cProdCli
			SZ7->Z7_DESCRI 	:= alltrim(SB1->B1_DESC)
			SZ7->Z7_OP 		:= SC2->C2_NUM
			SZ7->Z7_MOLDE 	:= SC2->C2_XMOLDE
			SZ7->Z7_QUANT 	:= VAL(MV_PAR02)
			SZ7->Z7_LOCAL 	:= SC2->C2_LOCAL
			SZ7->Z7_QRCODE1 := cQR
			SZ7->Z7_CLIENTE := cCliente
		SZ7->(MsUnlock())

		// FGRAVETIQ(cQR,cSeqEtiq1,cProdCli,MV_PAR02,SC2->C2_XMAQ,ddatabase,SC2->C2_NUM,SC2->C2_LOCAL,SC2->C2_XMOLDE,cCliente,;
		// alltrim(SB1->B1_DESC),SB1->B1_COD)

		cLabel:= ""
		cLabel+= ("CT~~CD,~CC^~CT~ ")
		cLabel+= (" ^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA ")
		cLabel+= (" ^PR10,10 ")
		cLabel+= (" ~SD"+alltrim(MV_PAR03))
		cLabel+= ("^JUS^LRN^CI0^XZ ")
		cLabel+= (" ^XA ")
		cLabel+= (" ^MMT ")
		cLabel+= (" ^PW945 ")
		cLabel+= (" ^LL0650 ")
		cLabel+= (" ^LS0 ")
		cLabel+= (" ^FT32,211^A0N,42,38^FH\^FD"+cProdCli+"^FS ")
		cLabel+= (" ^FT356,91^A0N,42,38^FH\^FD"+cSeqEtiq1+"^FS ")
		cLabel+= (" ^FT365,469^A0N,33,31^FH\^FD"+MV_PAR02+"^FS ")
		cLabel+= (" ^FT704,623^A0N,37,52^FH\^FDRE:____^FS ")
		cLabel+= (" ^FT703,575^A0N,37,36^FH\^FDTURNO:____^FS ")
		cLabel+= (" ^FT702,526^A0N,37,33^FH\^FDMAQ: "+SC2->C2_XMAQ+"^FS ")
		cLabel+= (" ^FT702,477^A0N,37,36^FH\^FD"+"___"+right(dtoc(ddatabase),8)+" ^FS ")
		cLabel+= (" ^FT270,468^A0N,33,31^FH\^FDQTD: ^FS ")
		cLabel+= (" ^FT101,468^A0N,33,31^FH\^FD"+SC2->C2_NUM+"^FS ")
		cLabel+= (" ^FT269,512^A0N,33,31^FH\^FDALMOX: ^FS ")
		cLabel+= (" ^FT394,512^A0N,33,31^FH\^FD"+SC2->C2_LOCAL+"^FS ")
		cLabel+= (" ^FT152,512^A0N,33,31^FH\^FD"+SC2->C2_XMOLDE+"^FS ")
		cLabel+= (" ^FT36,512^A0N,33,31^FH\^FDMOLDE:^FS ")
		cLabel+= (" ^FT36,468^A0N,33,31^FH\^FDOP: ^FS ")
		cLabel+= (" ^FT35,627^A0N,80,141^FH\^FD"+cCliente+"^FS ")
		if len(alltrim(SB1->B1_DESC)) <= 45
			cLabel+= (" ^FT33,345^A0N,37,36^FH\^FD"+alltrim(SB1->B1_DESC)+"^FS ")
		else
			cLabel+= (" ^FT33,345^A0N,37,36^FH\^FD"+left(alltrim(SB1->B1_DESC),45)+"^FS ")
			cLabel+= (" ^FT33,406^A0N,37,36^FH\^FD"+substr(alltrim(SB1->B1_DESC),46)+"^FS ")
		endif
		cLabel+= (" ^FT34,150^A0N,42,38^FH\^FD"+SB1->B1_COD+"^FS ")
		cLabel+= (" ^FT34,91^A0N,42,38^FH\^FDMASA^FS ")
		cLabel+= (" ^FT682,313^BQN,2,8 ")
		cLabel+= (" ^FDLA,"+cQR+"^FS ")
		cLabel+= (" ^PQ1,0,1,Y^XZ ")

		impriRaw(cLabel,cPrinter,cSeqEtiq1)

		// atualizar a quantida ja impressa
		// para limitar a impressao ate fecha a quantidade da OP.
		nQtdAtu := SC2->C2_QTDETIQ + val(MV_PAR02)
		Reclock('SC2' , .F.)
		SC2->C2_QTDETIQ := nQtdAtu
		SC2->(msUnLock())
	next nX
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

// Static function FGRAVETIQ(_cQR,_cSeqEtiq1,_cProdCli,_nQuantid,_cXMAQ,_ddatabase,_numOP,_cArmaz,_cXMOLDE,_cCliente,_cDesc,_cCod)
// Return

// Exemplo de impressão RAW usando FWMSPrinter
Static Function impriRaw(cZPL,cPrinter,cSeqEtiq1)

	Local oPrinter   := Nil
	Local cFileRel   := "RAW_ETIQUETA" // pode ser apenas identificador
	Local lAdjustToLegacy   := .F.
	Local lDisableSetup     := .T.
	Local nPrtType          := 2 // IMP_PDF > 6 || IMP_SPOOL > 2
	// Local oPrintSetupParam := Nil
	// Local oPrinter
	// Local cLocal            := "c:\temp"
	// Local aDevice           := {}
	// Local cSession          := GetPrinterSession()

	// Criar objeto FWMSPrinter em modo RAW
	oPrinter := FWMSPrinter():New(cFileRel, nPrtType, lAdjustToLegacy, '', lDisableSetup,.F.,NIL ,cPrinter ,.F. ,.T., .T. /*LRAW*/)

	// Aqui é só usar SAY, que em RAW escreve direto
	oPrinter:Say(0, 0, cZPL)

	oPrinter:Print()

	// PUTMV("MV_SEQETQ",cSeqEtiq1)
Return
