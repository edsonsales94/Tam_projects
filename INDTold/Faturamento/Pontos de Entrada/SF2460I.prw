#Include "Rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SF2460I ºAutor  ³ Reinaldo Magalhaes  º Data ³  14/09/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E apos a geracao do documento de saida.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ .T. ou .F.                                                 º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SF2460I

Local cBusca, cNatpj, cNatpf, cForpd, cInss, cBuscaIR, cBuscaPIS, cBuscaCOF,cBuscaINS, cIss, cBuscaISS, nReg, nInd, lret
Local dVencCOF, dVencPIS, nValPis, nValCof, nValISS, nValIRRF,nValIns, nValCsll,oDlg,lExec,oBtn1,oBtn2,cHist
Local cInvoice := ""
Local dEmisInv := CtoD(Space(6))
Local cCC      := ""
Local cITEM    := ""
Local cCLVL    := ""
Local cViag    := ""
Local cTrein   := ""
Local cRecMCT  := ""
Local cProd    := ""
Local cGrupo   := ""

Local cAlias  := Alias()    // Alias atual
Local nRecNo  := Recno()    // Registro em que o ponteiro esta posicionado
Local nIndex  := IndexOrd() // Indice atua

Private lContinua:= .T. // Variavel utilizada para checar se o botao Salvar foi clicado
Private cObjetiv := ""
Private cPedido  := ""

cBusca := SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)

//  .----------------------------------------------------------.
// |     Item da nota fiscal de saida (receita de servicos)     |
//  '----------------------------------------------------------'
dbSelectArea("SD2")              //  .----------------------------------------------------.
dbSetOrder(3)                    // |     D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA     |
If dbSeek(xFilial("SD2")+cBusca) //  '----------------------------------------------------'
	//  .-----------------------.
	// |     Pedido de Venda     |
	//  '-----------------------'
	dbSelectArea("SC5")                      //  .------------------------.
	dbSetOrder(1)                            // |     C5_FILIAL+C5_NUM     |
	If dbSeek(xFilial("SC5")+SD2->D2_PEDIDO) //  '------------------------'
		cInvoice:= SC5->C5_INVOICE
		dEmisInv:= SC5->C5_EMISINV
		cHist   := SC5->C5_MENNOTA
	Endif
	//  .-------------------------------.
	// |     Item do pedido de venda     |
	//  '-------------------------------'
	dbSelectArea("SC6")                                         //  .-------------------------------------------.
	dbSetOrder(2)                                               // |     C6_FILIAL+C6_PRODUTO+C6_NUM+C6_ITEM     |
	If dbSeek(xFilial("SC6")+SD2->(D2_COD+D2_PEDIDO+D2_ITEMPV)) //  '-------------------------------------------'
		cCC    := SC6->C6_CC
		cITEM  := SC6->C6_ITEMCTA
		cCLVL  := SC6->C6_CLVL
		cViag  := SC6->C6_VIAGEM
		cTrein := SC6->C6_TREINAM
		cPedido:= SC6->C6_NUM
		cRecMCT:= SC6->C6_VERBPED
		cProd  := SC6->C6_PRODUTO
		cGrupo := SC6->C6_GRUPO
	Endif
Endif

//  .----------------------------------------------.
// |     Ajustando item da nota fiscal de saida     |
//  '----------------------------------------------'
dbSelectArea("SD2")

nReg := Recno()

nValPis  := 0
nValCof  := 0
nValISS  := 0
nValIRRF := 0
nValIns  := 0
nValCsll := 0

While !Eof() .and. xFilial("SD2")+cBusca == D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA
	//  .-------------------------------.
	// |     Item do pedido de venda     |
	//  '-------------------------------'
	dbSelectArea("SC6")                                         //  .-------------------------------------------.
	dbSetOrder(2)                                               // |     C6_FILIAL+C6_PRODUTO+C6_NUM+C6_ITEM     |
	If dbSeek(xFilial("SC6")+SD2->(D2_COD+D2_PEDIDO+D2_ITEMPV)) //  '-------------------------------------------'
		Reclock("SD2",.F.)
		SD2->D2_CC      := SC6->C6_CC
		SD2->D2_ITEMCTA := SC6->C6_ITEMCTA
		SD2->D2_CLVL    := SC6->C6_CLVL
		SD2->D2_VIAGEM  := SC6->C6_VIAGEM
		SD2->D2_TREINAM := SC6->C6_TREINAM
		SD2->D2_VERBPED := SC6->C6_VERBPED // Verba P&D
		MsUnlock()
	Endif
	nValCof += SD2->D2_VALIMP5 //- COFINS via apuracao
	nValPis += SD2->D2_VALIMP6 //- PIS via apuracao
	nValISS += SD2->D2_VALISS  //- ISS Imposto sobre servicos
	//  .---------------------------------------.
	// |     Pegando detalhamento da receita     |
	//  '---------------------------------------'
	dbSelectArea("SZ6")
	dbSetOrder(1)
	If dbSeek(SD2->D2_FILIAL+"6"+cPedido)
		If !(AllTrim(Z6_OBJETIV) $ AllTrim(cObjetiv))
			cObjetiv := AllTrim(cObjetiv) + If( Empty(cObjetiv) , "", " ") + AllTrim(Z6_OBJETIV)
			cObjetiv += If(SubStr(cObjetiv,Len(cObjetiv),1) == "." ,"", ".")
		Endif
		FrSalva(cPedido,.F.)
	Endif
	dbSelectArea("SD2")
	dbSkip()
Enddo
dbGoTo(nReg)

cBusca:= SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC

SM2->(dbSetOrder(1))
SM2->(dbSeek(dDataBase))

//  .----------------------------------.
// |     Ajustando contas a receber     |
//  '----------------------------------'
dbSelectArea("SE1")              //  .-----------------------------------------------------------------.
dbSetOrder(2)                    // |     E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA     |
If dbSeek(XFILIAL("SE1")+cBusca) //  '-----------------------------------------------------------------'
	While !Eof() .And. E1_FILIAL == xFilial("SE1") .And. cBusca == E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM
		RecLock("SE1",.F.)
		SE1->E1_CC      := cCC
		SE1->E1_ITEMCTA := cITEM
		SE1->E1_CLVL    := cCLVL
		SE1->E1_VIAGEM  := cViag
		SE1->E1_TREINAM := cTrein
		SE1->E1_MCT     := cRecMCT
		SE1->E1_PEDIDO  := cPedido
		SE1->E1_INVOICE := cInvoice
		SE1->E1_EMISINV := dEmisInv
		SE1->E1_HIST    := cHist
		SE1->E1_PRODUTO := cProd
		SE1->E1_GRUPO   := cGrupo
		SE1->E1_TXMOEDA := If( SE1->E1_MOEDA > 1 , &("SM2->M2_MOEDA"+Str(SE1->E1_MOEDA,1)), 0)
		MsUnLock()
		Dbskip()
	Enddo
EndIf
//  .---------------------------------------------------------------------------.
// |     Verificando a necessidade de geracao de titulos de impostos a pagar     |
//  '---------------------------------------------------------------------------'
cForPd := SubStr(GetMv("MV_UNIAO"),1,6)   //Fornecedor dos titulos de impostos
cInss  := SubStr(GetMv("MV_FORINSS"),1,6) //Fornecedor dos titulos de impostos de INSS
cIss   := SubStr(GetMv("MV_MUNIC"),1,6)   //Fornecedor dos titulos de impostos de ISS
//  .----------------------------------------------------------.
// |     Titulo no contas a pagar ISS (gerado pelo sistema)     |
//  '----------------------------------------------------------'
If nValISS > 0
	cBuscaISS := SF2->(F2_SERIE+F2_DOC)+" "+"TX "+cIss
	DbSelectArea("SE2")
	dbSetOrder(1)
	If dbSeek(XFILIAL("SE2")+cBuscaISS)
		RecLock("SE2",.F.)
		SE2->E2_CC      := cCC
		SE2->E2_CLVL    := cCLVL
		SE2->E2_ITEMCTA := cITEM
		SE2->E2_VIAGEM  := cViag
		SE2->E2_TREINAM := cTrein
		SE2->E2_HIST    := cHist
		MsUnLock()
	Endif
Endif
//  .-----------------------------------------------------------------.
// |     Gerando titulo no contas a pagar ref. PIS via Apuracao        |
// |     Gerando titulo no contas a pagar ref. COFINS via Apuracao     |
//  '-----------------------------------------------------------------'
If nValCof > 0
	
	dVencCOF  := ProxVenc(SF2->F2_EMISSAO)
	
	SE2->(DbSelectArea("SE2"))
	SE2->(dbSetOrder(1))
	
	RecLock("SE2",.T.)
	SE2->E2_FILIAL  := xFilial("SE2")
	SE2->E2_PREFIXO := SF2->F2_SERIE
	SE2->E2_NUM     := SF2->F2_DOC
	SE2->E2_PARCELA := ProxParc(xFilial("SE2"),PADR(AllTrim(GetMv("MV_UNIAO")),6),"00",SF2->F2_SERIE,SF2->F2_DOC)
	SE2->E2_TIPO    := "TX"
	SE2->E2_NATUREZ := "2104010009"
	SE2->E2_FORNECE := cForPd
	SE2->E2_LOJA    := "00"
	SE2->E2_NOMFOR  := Posicione("SA2",1,xFilial("SA2")+PadR(AllTrim(cForPd),6)+"00","A2_NREDUZ")
	SE2->E2_EMISSAO := SF2->F2_EMISSAO
	SE2->E2_VENCTO  := dVencCOF
	SE2->E2_VENCREA := DataValida(dVencCOF,.T.)
	SE2->E2_VALOR   := nValCof
	SE2->E2_EMIS1   := SF2->F2_EMISSAO
	SE2->E2_LA      := "S"
	SE2->E2_VENCORI := dVencCOF
	SE2->E2_SALDO   := nValCof
	SE2->E2_MOEDA   := 1
	SE2->E2_VLCRUZ  := nValCof
	SE2->E2_ORIGEM  := "MATA460"
	SE2->E2_CC      := cCC
	SE2->E2_CLVL    := cCLVL
	SE2->E2_ITEMCTA := cITEM
	SE2->E2_VIAGEM  := cViag
	SE2->E2_TREINAM := cTrein
	SE2->E2_HIST    := cHist
	SE2->E2_DIRF    := "2"
	MsUnLock()
	
	RecLock("SF2",.F.)
	
	SF2->F2_XPARCOF := SE2->E2_PARCELA
	SF2->(MsUnlock())
	
Endif

dbSelectArea("SF2")

//  .--------------------------------------.
// |     Ajustando nota fiscal de saida     |
//  '--------------------------------------'
If !Empty(cInvoice) .Or. !Empty(dEmisInv)
	Reclock("SF2",.F.)
	SF2->F2_INVOICE := cInvoice
	SF2->F2_EMISINV := dEmisInv
	MsUnLock()
Endif

dbSelectArea(cAlias)
dbSetOrder(nIndex)
dbGoto(nRecno)
Return
//
//
//
Static Function FRSalva(cPedido,lMens)
Local uChave
If !Empty(cObjetiv)
	uChave:= SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM
	dbSelectArea("SZ6")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ6")+"7"+uChave)
		RecLock("SZ6",.F.)
	Else
		RecLock("SZ6",.T.)
	Endif
	SZ6->Z6_FILIAL  := XFILIAL("SZ6")
	SZ6->Z6_TIPO    := "7"
	SZ6->Z6_NUM     := SD2->D2_DOC
	SZ6->Z6_PREFIXO := SD2->D2_SERIE
	SZ6->Z6_FORNECE := SD2->D2_CLIENTE
	SZ6->Z6_LOJA    := SD2->D2_LOJA
	SZ6->Z6_ITEM    := SD2->D2_ITEM
	SZ6->Z6_OBJETIV := cObjetiv
	MsUnLock()
	lContinua := .F.
ElseIf lMens == Nil .Or. lMens
   //  .--------------------------------------------.
	// |     Caso um dos campos estejam em Branco     |
	//  '--------------------------------------------'
	If Empty(cObjetiv)
		Alert("É obrigatório o preenchimento do detalhamento da receita!!!")
	Endif
EndIf
Return
//
//
//
Static Function ProxParc(cFil,cUniao,cLoja,cSerie,cDoc)

Local cQry
Local cParc
cQry := "SELECT * "
cQry +=    "FROM " + RetSqlName("SE2") + " SE2 "
cQry += "WHERE D_E_L_E_T_ = ' ' "
cQry +=       "AND E2_FILIAL ='" + cFil + "'"
cQry +=       "AND E2_FORNECE ='" + cUniao + "'"
cQry +=       "AND E2_LOJA ='" + cLoja + "'"
cQry +=       "AND E2_PREFIXO ='" + cSerie + "'"
cQry +=       "AND E2_NUM = '" + cDoc + "'"
cQry += "ORDER BY E2_PARCELA DESC"

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TabTmp", .T., .F. )
DbSelectArea("TabTmp")
TabTmp->(DbGoTop())
cParc := AllTrim(STR(VAL(TabTmp->E2_PARCELA)+1))
DbCloseArea("TabTmp")

Return cParc
//
//
//
sTATIC Function ProxVenc(dData)

Local dVencCof
dVencCOF  := LastDay(dData) + GetMv("MV_XVCCOF")
While dVencCof <> DataValida(dVencCof)
	dVencCof--
End

Return dVencCof
