#INCLUDE "FINA200X.CH"
#include "fileio.ch"
#Include "PROTHEUS.CH"
#Include "FWMVCDEF.CH"

Static __nExeProc := 0
Static lFWCodFil  := .T.
Static nTamNat	  := 0
Static lVerifNat  := .F.

/*/
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinA200  ³ Autor ³ Wagner Xavier         ³ Data ³ 26/05/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorno da comunica‡„o banc ria - Receber                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinA200()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			ATUALIZACOES SOFRIDAS                              			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Claudio   	³13/07/00³xxxxxx³ Retirar todas as chamadas a WriteSx2    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FinA200X(nPosArotina)
	Local lPanelFin := IsPanelFin()
	Local lPergunte := .F.
	//Private LEXECJOB  := .F.

	Private cStProc := ""

	// Permite que o fina200 seja chamado mais de uma vez pelo schedule
	__nExeProc  := 0

	// Retorno Automatico via Job
	// parametro que controla execucao via Job utilizado para pontos de entrada que nao tem como passar o parametro
	Private lExecJob := ExecSchedule()

	if lExecJob
		nPosArotina := 3 // recebe arquivo
	Endif

	Private cPerg	:= "AFI200"

	/*
	___________________________________
	| Perguntas:						|
	| __________________________________|
	|									|
	| 01	Mostra Lanc Contab ?		|
	| 02	Aglut Lancamentos ?			|
	| 03	Atualiza Moedas por ?		|
	| 04	Arquivo de Entrada ?		|
	| 05	Arquivo de Config ?			|
	| 06	Codigo do Banco ?			|
	| 07	Codigo da Agencia ?			|
	| 08	Codigo da Conta ?			|
	| 09	Codigo da Sub-Conta ?		|
	| 10	Abate Desc Comissao ?		|
	| 11	Contabiliza On Line ?		|
	| 12	Configuracao CNAB ?			|
	| 13	Processa Filial?			|
	| 14	Contabiliza Transferencia ?	|
	| 15	Considera Dias de Retencao ?|
	|___________________________________|
	*/

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lPanelFin .and. ! lExecJob         // Retorno Automatico via Job - parametro que controla execucao via Job
		lPergunte := PergInPanel(cPerg,.T.)
	Else
		if lExecJob    // Retorno Automatico via Job - parametro que controla execucao via Job
			Pergunte(cPerg,.F.,Nil,Nil,Nil,.F.)  // carrega as perguntas que foram atualizadas pelo FINA205
			lPergunte := .T.
		Else
			lPergunte := pergunte(cPerg,.T.)
		Endif
	Endif

	If !lPergunte
		Return
	Endif
	MV_PAR04 := UPPER(MV_PAR04)

	PRIVATE cLotefin 	:= Space(TamSX3("EE_LOTE")[1]),nTotAbat := 0,cConta := " "
	PRIVATE nHdlBco		:= 0,nHdlConf := 0,nSeq := 0 ,cMotBx := "NOR"
	PRIVATE nValEstrang := 0
	PRIVATE cMarca 		:= GetMark()
	PRIVATE aRotina 	:= MenuDef()
	PRIVATE VALOR  		:= 0
	PRIVATE nHdlPrv 	:= 0
	PRIVATE nOtrGa		:= 0
	PRIVATE nTotAGer	:= 0
	PRIVATE ABATIMENTO 	:= 0
	Private lOracle		:= "ORACLE"$Upper(TCGetDB())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define o cabecalho da tela de baixas ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PRIVATE cCadastro := OemToAnsi("Comunica‡„o Banc ria-Retorno")  //"Comunica‡„o Banc ria-Retorno"

	DEFAULT nPosArotina := 0

	If nTamNat == 0
		F200VerNat()
	Endif

	If nPosArotina > 0
		dbSelectArea('SE1')
		bBlock := &( "{ |a,b,c,d,e| " + aRotina[ nPosArotina,2 ] + "(a,b,c,d,e) }" )
		Eval( bBlock, Alias(), (Alias())->(Recno()),nPosArotina,lExecJob) // Retorno Automatico via Job - parametro que controla execucao via Job
	Else
		mBrowse( 6, 1,22,75,"SE1")
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha os Arquivos ASCII ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FCLOSE(nHdlBco)
	FCLOSE(nHdlConf)

Return


/*/
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fA200Ger ³ Autor ³ Wagner Xavier         ³ Data ³ 26/05/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Comunicacao Bancaria - Retorno                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fA200Ger()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FinA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fa200gera(cAlias)
	__nExeProc++

	// Como esta rotina eh chamada duas vezes pela mBrowse, controlar
	// as chamadas para nao ocorrer duplo processamento
	If (__nExeProc%2)==0
		Return .T.
	Endif

	Processa({|lEnd| fa200Ger(cAlias)})  // Chamada com regua

Return .T.

/*/
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fA200Gera³ Autor ³ Wagner Xavier         ³ Data ³ 26/05/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Comunicacao Bancaria - Retorno                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fA200Ger()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FinA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fA200Ger(cAlias)
	Local lPosNum  :=.f.,lPosData:=.f.,lPosMot  :=.f.
	Local lPosDesp :=.f.,lPosDesc:=.f.,lPosAbat :=.f.
	Local lPosPrin :=.f.,lPosJuro:=.f.,lPosMult :=.f.
	Local lPosOcor :=.f.,lPosTipo:=.f.,lPosOutrD:= .F.
	Local lPosCC   :=.f.,lPosDtCC:=.f.,lPosNsNum:=.f.
	Local cArqConf,cArqEnt,xBuffer
	Local lDesconto,lContabiliza
	Local cData
	Local cPosNsNum , nLenNsNum
	Local lUmHelp 	:= .F.
	Local cTabela 	:= "17"
	Local lPadrao 	:= .f.
	Local lBaixou 	:= .f.
	Local nSavRecno	:= Recno()
	Local nPos
	Local aTabela 	:= {}
	Local lRecicl	:= GetMv("MV_RECICL")
	Local lNaoExiste:= .F.
	Local cIndex	:= " "
	LOCAL lFina200 	:= ExistBlock("FINA200" )
	LOCAL l200Pos  	:= ExistBlock("FA200POS" )
	LOCAL lT200Pos 	:= ExistTemplate("FA200POS" )
	LOCAL lFa200Fil	:= ExistBlock("FA200FIL")
	LOCAL lFa200F1 	:= ExistBlock("FA200F1" )
	LOCAL lF200Tit 	:= ExistBlock("F200TIT" )
	LOCAL lF200Fim 	:= ExistBlock("F200FIM" )
	LOCAL lTF200Fim := ExistTemplate("F200FIM" )
	LOCAL lF200Var 	:= ExistBlock("F200VAR" )
	LOCAL lF200Avl 	:= ExistBlock("F200AVL" )
	LOCAL l200Fil  	:= .F.
	LOCAL lFirst	:= .F.
	Local cMotBan	:= Space(10)				// motivo da ocorrencia no banco
	Local nCont, cMotivo, lSai := .f.
	Local aLeitura 	:= {}
	Local lFa200_02 := ExistBlock("FA200_02")
	Local aValores 	:= {}
	LOCAL lBxCnab  	:= GetMv("MV_BXCNAB") == "S"
	LOCAL cNomeArq
	LOCAL aCampos  	:= {}
	Local lAchouTit	:= .F.
	Local nX 		:= 0
	Local nRegSE5 	:= 0
	Local lPosDtVc 	:= .F.
	Local nLenDtVc
	Local cPosDtVc
	Local lF200ABAT := ExistBlock("F200ABAT")
	Local lFI0InDic := .T.
	Local nLastLn	:= 0
	Local nUltLinProc := 1
	Local lReproc 	:= .T.
	Local cTrailler
	Local cIdArq
	Local nLinRead	:= 0
	Local nRegEmp	:= SM0->(Recno())
	Local lF200PORT := ExistBlock("F200PORT")
	Local lAltPort 	:= .T.
	Local nTotAbImp := 0
	Local cFilOrig  := cFilAnt	// Salva a filial para garantir que nao seja alterada em customizacao
	Local lNewIndice:= FaVerInd()  //Verifica a existencia dos indices de IDCNAB sem filial
	Local nTamPre	:= TamSX3("E1_PREFIXO")[1]
	Local nTamNum	:= TamSX3("E1_NUM")[1]
	Local nTamPar	:= TamSX3("E1_PARCELA")[1]
	Local nTamTit	:= nTamPre+nTamNum+nTamPar
	Local aArqConf	:= {}		// Atributos do arquivo de configuracao
	// Local lCtbExcl	:= !Empty(xFilial("CT2"))
	Local lProcessa := .T.
	Local nValTot	:= 0

	Local lAltera   := Iif(IsBlind(), .F. , ALTERA)

	//--- Tratamento Gestao Corporativa
	Local lGestao   := Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
	//
	Local cFilFwSE1 := IIF( lGestao , FwFilial("SE1") , xFilial("SE1") )
	//
	Local cFilFwCT2 := IIF( lGestao , FwFilial("CT2") , xFilial("CT2") )
	//
	Local lCtbExcl	:= !Empty( cFilFwCT2 )

	Local lMulNatBx := SuperGetMV("MV_MULNATB",.F.,.F.)
	Local lJurComis := (mv_par16 == 1)

	Local oModelMov	:= Nil //Model de Movimento Bancário
	Local oSubFK5		:= Nil
	Local oSubFKA		:= ""
	Local cLog			:= ""
	Local lRet			:= .T.
	Local cCamposE5	:= ""

	If ExistBlock("F200CNAB")
		lBxCnab:=ExecBlock("F200CNAB",.F.,.F.,{lBxCnab,cAlias})
	EndIf

	nHdlBco   	:= 0
	nHdlConf   	:= 0
	nSeq       	:= 0
	cMotBx     	:= "NOR"
	nTotAGer   	:= 0
	nTotDesp   	:= 0 // Total de Despesas para uso com MV_BXCNAB
	nTotOutD   	:= 0 // Total de outras despesas para uso com MV_BXCNAB
	nTotValCC   := 0 // Total de outros creditos para uso com MV_BXCNAB
	nValEstrang := 0
	VALOR    	:= 0
	nHdlPrv  	:= 0
	ABATIMENTO  := 0

	Private cBanco
	Private cAgencia
	Private cConta
	Private cHist070
	Private lAut:=.f.,nTotAbat := 0
	Private cArquivo
	Private dDataCred,dBaixa
	Private lCabec := .f.
	Private cPadrao
	Private nTotal := 0
	Private cModSpb := "1"  // Informado apenas para nao dar problemas nas rotinas de baixa
	Private nAcresc
	Private nDecresc
	Private aFlagCTB		:= {}
	Private lUsaFlag		:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
	Private nLidos,nLenNum,nLenData,nLenDesp,nLenDesc,nLenAbat,nLenMot, nTamDet
	Private nLenPrin,nLenJuro,nLenMult,nLenOcor,nLenTipo,nLenCC,nLenDtCC, nLenOutrD
	Private cPosNum,cPosData,cPosDesp,cPosDesc,cPosAbat,cPosPrin,cPosJuro,cPosMult
	Private cPosOcor,cPosTipo,cPosCC,cPosDtCC,cPosMot, cPosOutrD

	// Se existir o arquivo de LOG, forca sua abertura antes do inicio da transacao
	If lFI0InDic
		DbSelectArea("FI0")
		DbSelectArea("FI1")
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no Banco indicado                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cBanco  := mv_par06
	cAgencia:= mv_par07
	cConta  := mv_par08
	cSubCta := mv_par09
	lDigita := IIF(mv_par01==1,.T.,.F.)
	lAglut  := IIF(mv_par02==1,.T.,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe inidce IDCNAB para multiplas filiais ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par13 == 2

		If !lNewIndice

			// Não foi encontrado o índice por IDCNAB sem Filial. ### Executar o compatibizador do ambiente Financeiro (U_UPDFIN).
			Help( "  ", 1, "NOIDCNAB" )

			// Retorno Automatico via Job
			if ExecSchedule()
				Aadd(aMsgSch, "Não foi encontrado o índice por IDCNAB sem Filial. Executar o compatibizador do ambiente Financeiro (U_UPDFIN).") // "Não foi encontrado o índice por IDCNAB sem Filial. Executar o compatibizador do ambiente Financeiro (U_UPDFIN)."
			Endif

			Return .F.

		Else

			If lCtbExcl
				// A Contabilidade está em modo exclusivo e foi solicitado o processamento de todas as filiais.
				// Neste caso, o sistema não realiza a contabilização on-line. Confirma mesmo assim?
				if ! ExecSchedule() // Retorno Automatico via Job - parametro que controla execucao via Job
					If ! MsgYesNo( "Retorno Automatico via Job - parametro que controla execucao via Job", "AVISO" )
						Return .F.
					Endif
				EndIf
			EndIf
		EndIf

	EndIf

	dbSelectArea("SA6")
	DbSetOrder(1)
	SA6->( dbSeek(xFilial("SA6")+cBanco+cAgencia+cConta) )

	dbSelectArea("SEE")
	DbSetOrder(1)
	SEE->( dbSeek(xFilial("SEE")+cBanco+cAgencia+cConta+cSubCta) )
	If !SEE->( found() )
		Help(" ",1,"PAR150")

		// Retorno Automatico via Job
		if ExecSchedule()
			Aadd(aMsgSch, "Parametros de Bancos nao encontrados para o Banco:"+cBanco+"  "+"Agencia:"+cAgencia+"  "+"Conta:"+cConta+"  "+"Sub-Conta:"+cSubCta) // "Parametros de Bancos nao encontrados para o Banco:" # "Agencia:" # "Conta:" # "Sub-Conta:"
		Endif

		Return .F.
	Endif

	If lBxCnab // Baixar arquivo recebidos pelo CNAB aglutinando os valores
		If Empty(SEE->EE_LOTE)
			cLoteFin := StrZero( 1, TamSX3("EE_LOTE")[1] )
		Else
			cLoteFin := FinSomaLote(SEE->EE_LOTE)
		EndIf
	EndIf
	nTamDet := Iif( Empty (SEE->EE_NRBYTES), 400 , SEE->EE_NRBYTES )
	nTamDet	+= 2  // ajusta tamanho do detalhe para ler o CR+LF
	cTabela := Iif( Empty(SEE->EE_TABELA), "17" , SEE->EE_TABELA )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a tabela existe           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "SX5" )
	If !SX5->( dbSeek( cFilial + cTabela ) )
		Help(" ",1,"PAR150")

		// Retorno Automatico via Job
		if ExecSchedule()
			Aadd(aMsgSch, "Tabela 17 nao localizada no arquivo de tabelas SX5") // "Tabela 17 nao localizada no arquivo de tabelas SX5"
		Endif

		Return .F.
	Endif

	//Altero banco da baixa pelo portador ?
	If lF200PORT
		lAltPort := ExecBlock("F200PORT",.F.,.F.)
	Endif

	While !SX5->(Eof()) .and. SX5->X5_TABELA == cTabela
		AADD(aTabela,{Alltrim(X5Descri()),AllTrim(SX5->X5_CHAVE)})
		SX5->(dbSkip( ))
	Enddo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o numero do Lote                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PRIVATE cLote
	dbSelectArea("SX5")
	dbSeek(cFilial+"09FIN")
	cLote := Substr(X5Descri(),1,4)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se ‚ um EXECBLOCK e caso sendo, executa-o							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If At(UPPER("EXEC"),X5Descri()) > 0
		cLote := &(X5Descri())
	Endif

	If ( MV_PAR12 == 1 )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abre arquivo de configuracao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cArqConf:=mv_par05
		IF !FILE(cArqConf)
			Help(" ",1,"NOARQPAR")

			// Retorno Automatico via Job
			if ExecSchedule()
				Conout("Arquivo de configuracao "+cArqConf+" nao localizado.") // "Arquivo de configuracao " # " nao localizado."
				Aadd(aMsgSch, "Arquivo de configuracao "+cArqConf+" nao localizado.") // "Arquivo de configuracao " # " nao localizado."
			Endif

			Return .F.
		Else
			nHdlConf:=FOPEN(cArqConf,0+64)
		EndIF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Lˆ arquivo de configuracao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nLidos:=0
		FSEEK(nHdlConf,0,0)
		nTamArq:=FSEEK(nHdlConf,0,2)
		FSEEK(nHdlConf,0,0)

		While nLidos <= nTamArq

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica o tipo de qual registro foi lido ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			xBuffer:=Space(85)
			FREAD(nHdlConf,@xBuffer,85)
			IF SubStr(xBuffer,1,1) == CHR(1)
				nLidos+=85
				Loop
			EndIF
			IF SubStr(xBuffer,1,1) == CHR(3)
				nLidos+=85
				Exit
			EndIF

			IF !lPosNum
				cPosNum:=Substr(xBuffer,17,10)
				nLenNum:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosNum:=.t.
				nLidos+=85
				Loop
			EndIF
			IF !lPosData
				cPosData:=Substr(xBuffer,17,10)
				nLenData:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosData:=.t.
				nLidos+=85
				Loop
			End
			IF !lPosDesp
				cPosDesp:=Substr(xBuffer,17,10)
				nLenDesp:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosDesp:=.t.
				nLidos+=85
				Loop
			End
			IF !lPosDesc
				cPosDesc:=Substr(xBuffer,17,10)
				nLenDesc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosDesc:=.t.
				nLidos+=85
				Loop
			End
			IF !lPosAbat
				cPosAbat:=Substr(xBuffer,17,10)
				nLenAbat:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosAbat:=.t.
				nLidos+=85
				Loop
			EndIF
			IF !lPosPrin
				cPosPrin:=Substr(xBuffer,17,10)
				nLenPrin:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosPrin:=.t.
				nLidos+=85
				Loop
			EndIF
			IF !lPosJuro
				cPosJuro:=Substr(xBuffer,17,10)
				nLenJuro:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosJuro:=.t.
				nLidos+=85
				Loop
			EndIF
			IF !lPosMult
				cPosMult:=Substr(xBuffer,17,10)
				nLenMult:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosMult:=.t.
				nLidos+=85
				Loop
			EndIF
			IF !lPosOcor
				cPosOcor:=Substr(xBuffer,17,10)
				nLenOcor:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosOcor:=.t.
				nLidos+=85
				Loop
			EndIF
			IF !lPosTipo
				cPosTipo:=Substr(xBuffer,17,10)
				nLenTipo:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosTipo:=.t.
				nLidos+=85
				Loop
			EndIF
			IF !lPosOutrD
				cPosOutrD:=Substr(xBuffer,17,10)
				nLenOutrD:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosOutrD:=.t.
				nLidos+=85
				Loop
			EndIF
			IF !lPosCC
				cPosCC:=Substr(xBuffer,17,10)
				nLenCC:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosCC:=.t.
				nLidos+=85
				Loop
			EndIF
			IF !lPosDtCc
				cPosDtCc:=Substr(xBuffer,17,10)
				nLenDtCc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosDtCc:=.t.
				nLidos+=85
				Loop
			EndIF
			IF !lPosNsNum
				cPosNsNum := Substr(xBuffer,17,10)
				nLenNsNum := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosNsNum := .t.
				nLidos += 85
				Loop
			EndIF
			IF !lPosMot									// codigo do motivo da ocorrencia
				cPosMot:=Substr(xBuffer,17,10)
				nLenMot:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosMot:=.t.
				nLidos+=85
				Loop
			EndIF
			If !lPosDtVc
				cPosDtVc:=Substr(xBuffer,17,10)
				nLenDtVc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
				lPosDtVc:=.t.
				nLidos+=85
				Loop
			Endif
		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ fecha arquivo de configuracao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Fclose(nHdlConf)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre arquivo enviado pelo banco ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqEnt:=mv_par04


	IF !FILE(cArqEnt)
		Help(" ",1,"NOARQENT")

		// Retorno Automatico via Job
		if ExecSchedule()
			Aadd(aMsgSch, "Arquivo de entrada "+cArqEnt+" nao localizado.") // "Arquivo de entrada " # " nao localizado."
		Endif

		Return .F.
	Else
		nHdlBco:=FOPEN(cArqEnt,0+64)
	EndIF

	If lRecicl
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra o arquivo por E1_NUMBCO - caso exista reciclagem      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE1")
		cIndex	:= CriaTrab(nil,.f.)
		cChave	:= IndexKey()
		IndRegua("SE1",cIndex,"E1_FILIAL+E1_NUMBCO",,Fa200ChecF(),OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
		nIndex 	:= RetIndex("SE1")
		dbSelectArea("SE1")
		dbSetOrder(nIndex+1)

		dbGoTop()
		IF BOF() .and. EOF()
			Help(" ",1,"RECNO")

			// Retorno Automatico via Job
			if ExecSchedule()
				Aadd(aMsgSch, "Nao foram localizados registros na tabela SE1.")  // "Nao foram localizados registros na tabela SE1."
			Endif

			Return
		EndIf
	EndIf

	// Se nao tiver o arquivo de LOG no dicionario, verifica se o arquivo ja foi processado anteriormente
	If ! lFI0InDic
		If !(Chk200File())
			Return .F.
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama a SumAbatRec antes do Controle de transa‡Æo para abrir o alias ³
	//³ auxiliar __SE1																		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SumAbatRec( "", "", "", 1, "")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera arquivo de Trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aCampos,{"FILMOV","C",IIf( lFWCodFil, FWGETTAMFILIAL, 2 ),0})
	AADD(aCampos,{"DATAC","D",08,0})
	AADD(aCampos,{"MOEDA","C",TamSX3("E1_MOEDA")[1],0})
	AADD(aCampos,{"NATURE","C",TamSX3("E1_NATUREZ")[1],0})
	AADD(aCampos,{"TOTAL","N",17,2})

	// para evitar abortar por area ja existente
	if Select("TRB") > 0
		TRB->( dbCloseArea())
	Endif
	cNomeArq:=CriaTrab(aCampos)
	dbUseArea( .T., __cRDDNTTS, cNomeArq, "TRB", if(.F. .Or. .F., !.F., NIL), .F. )
	IndRegua("TRB",cNomeArq,"FILMOV+Dtos(DATAC)",,,"")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lˆ arquivo enviado pelo banco ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLidos:=0
	FSEEK(nHdlBco,0,0)
	nTamArq:=FSEEK(nHdlBco,0,2)
	FSEEK(nHdlBco,0,0)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desenha o cursor e o salva para poder moviment -lo ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcRegua( nTamArq/nTamDet , 24 )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega atributos do arquivo de configuracao                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aArqConf := Directory(MV_PAR05)

	lFirst := .F.
	nTotAger := 0
	nCtDesp := 0
	nCtOutCrd := 0

	// Se existir o arquivo de LOG, grava as informacoes pertinentes, referente ao cabecalho do arquivo
	// Para futuro reprocessamento se preciso for.
	If lFI0InDic
		cTrailler := LeTrailler(nHdlBco) // Obtem o Trailler do Arquivo para gerar o CheckSum
		cIdArq	 := Str(MsCrc32(cTrailler),10) // Fa200ChkSum(cTrailler) // Gera o CheckSum
		lReproc	 := Fa200GrvLog(1, cArqEnt, cBanco, cAgencia, cConta, @nUltLinProc,,,,cIdArq)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa a gravacao dos lancamentos do SIGAPCO          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoIniLan("000004")
	PcoIniLan("000007")

	While lReproc .And. nLidos <= nTamArq
		IncProc()
		nLastLn ++
		// Se tiver o arquivo de LOG, avanca ate a proxima linha, apos a ultima processada
		If lFI0InDic
			If nLastLn < nUltLinProc
				If lBxCnab
					xBuffer:=Space(nTamDet)
					FREAD(nHdlBco,@xBuffer,nTamDet)

					LoadVlBx( nHdlBco, xBuffer, nTamDet, @nValtot, @nTotDesp, @nTotOutD, @nTotValCc, @nTotAGer, ,lBxCnab)
					nLidos+=nTamDet
				Else
					// Avanca uma linha do arquivo retorno
					nLidos+=nTamDet
					fReadLn(nHdlBco,,(nTamDet)) // Posiciona proxima linha
				Endif
				Loop
			Endif
			// Grava a ultima linha lida do arquivo
			FI0->(RecLock("FI0"))
			FI0->FI0_LASTLN	:= nLastLn
			MsUnlock()
		Endif

		nDespes :=0
		nDescont:=0
		nAbatim :=0
		nValRec :=0
		nJuros  :=0
		nMulta  :=0
		nValCc  :=0
		nCM     :=0
		nOutrDesp :=0

		// Template GEM
		nCm1     := 0
		nProRata := 0

		cFilAnt := cFilOrig					// sempre restaura a filial original

		If ( MV_PAR12 == 1 )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Tipo qual registro foi lido ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			xBuffer:=Space(nTamDet)
			FREAD(nHdlBco,@xBuffer,nTamDet)

			IF SubStr(xBuffer,1,1) $ "0|A"
				nLidos+=nTamDet
				Loop
			EndIF
			IF SubStr(xBuffer,1,1) $ "1|F|J|7|2"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Lˆ os valores do arquivo Retorno ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                           
				cNumTit :=Substr(xBuffer,Int(Val(Substr(cPosNum, 1,3))),nLenNum )
				cData   :=Substr(xBuffer,Int(Val(Substr(cPosData,1,3))),nLenData)
				cData   :=ChangDate(cData,SEE->EE_TIPODAT)
				dBaixa  :=Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5,2),"ddmmyy")
				cTipo   :=Substr(xBuffer,Int(Val(Substr(cPosTipo, 1,3))),nLenTipo )
				cTipo   := Iif(Empty(cTipo),"NF ",cTipo)		// Bradesco
				cNsNum  := " "
				cEspecie:= "   "
				dDataCred := Ctod("//")
				dDtVc := Ctod("//")
				IF !Empty(cPosDesp)
					nDespes:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosDesp,1,3))),nLenDesp))/100,2)
				EndIF
				IF !Empty(cPosDesc)
					nDescont:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosDesc,1,3))),nLenDesc))/100,2)
				EndIF
				IF !Empty(cPosAbat)
					nAbatim:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosAbat,1,3))),nLenAbat))/100,2)
				EndIF
				IF !Empty(cPosPrin)
					nValRec :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosPrin,1,3))),nLenPrin))/100,2)
				EndIF
				IF !Empty(cPosJuro)
					nJuros  :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosJuro,1,3))),nLenJuro))/100,2)
				EndIF
				IF !Empty(cPosMult)
					nMulta  :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosMult,1,3))),nLenMult))/100,2)
				EndIF
				IF !Empty(cPosOutrd)
					nOutrDesp  :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosOutrd,1,3))),nLenOutrd))/100,2)
				EndIF
				IF !Empty(cPosCc)
					nValCc :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosCc,1,3))),nLenCc))/100,2)
				EndIF
				IF !Empty(cPosDtCc)
					cData  :=Substr(xBuffer,Int(Val(Substr(cPosDtCc,1,3))),nLenDtCc)
					cData    := ChangDate(cData,SEE->EE_TIPODAT)
					dDataCred:=Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5,2),"ddmmyy")
					dDataUser:=dDataCred
				End
				IF !Empty(cPosNsNum)
					cNsNum  :=Substr(xBuffer,Int(Val(Substr(cPosNsNum,1,3))),nLenNsNum)
				End
				If nLenOcor == 2
					cOcorr  :=Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor) + " "
				Else
					cOcorr  :=Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor)
				EndIf
				If !Empty(cPosMot)
					cMotBan:=Substr(xBuffer,Int(Val(Substr(cPosMot,1,3))),nLenMot)
				EndIf
				IF !Empty(cPosDtVc)
					cDtVc :=Substr(xBuffer,Int(Val(Substr(cPosDtVc,1,3))),nLenDtVc)
					cDtVc := ChangDate(cDtVc,SEE->EE_TIPODAT)
					dDtVc :=Ctod(Substr(cDtVc,1,2)+"/"+Substr(cDtVc,3,2)+"/"+Substr(cDtVc,5,2),"ddmmyy")
				EndIf


				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ o array aValores ir  permitir ³
				//³ que qualquer exce‡„o ou neces-³
				//³ sidade seja tratado no ponto  ³
				//³ de entrada em PARAMIXB        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				// Estrutura de aValores
				//	Numero do T¡tulo	- 01
				//	data da Baixa		- 02
				// Tipo do T¡tulo		- 03
				// Nosso Numero			- 04
				// Valor da Despesa		- 05
				// Valor do Desconto	- 06
				// Valor do Abatiment	- 07
				// Valor Recebido    	- 08
				// Juros				- 09
				// Multa				- 10
				// Outras Despesas		- 11
				// Valor do Credito		- 12
				// Data Credito			- 13
				// Ocorrencia			- 14
				// Motivo da Baixa 		- 15
				// Linha Inteira		- 16
				// Data de Vencto	   	- 17

				aValores := ( { cNumTit, dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nOutrDesp, nValCc, dDataCred, cOcorr, cMotBan, xBuffer,dDtVc,{} })

				If ExistBlock("200GEMBX")
					ExecBlock("200GEMBX", .F., .F., {aValores})
				EndIf

				// Template GEM
				If lF200Var
					ExecBlock("F200VAR",.F.,.F.,{aValores})
				ElseIf ExistTemplate("GEMBaixa")
					ExecTemplate("GEMBaixa",.F.,.F.,)
				Endif

				If Empty(cNumTit)
					nLidos += nTamDet
					Loop
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica especie do titulo    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nPos := Ascan(aTabela, {|aVal|aVal[1] == Substr(cTipo,1,2)})
				If nPos != 0
					cEspecie := aTabela[nPos][2]
				Else
					cEspecie	:= "  "
				EndIf
				If cEspecie $ MVABATIM			// Nao lˆ titulo de abatimento
					nLidos += nTamDet
					Loop
				Endif
			Else
				nLidos += nTamDet
				Loop
			Endif
		Else
			aLeitura := ReadCnab2(nHdlBco,MV_PAR05,nTamDet,aArqConf,@nLinRead)
			cNumTit  := SubStr(aLeitura[1],1,nTamTit)
			cData    := aLeitura[04]
			cData    := ChangDate(cData,SEE->EE_TIPODAT)
			dBaixa   := Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5,2),"ddmmyy")
			cTipo    := aLeitura[02]
			cTipo    := Iif(Empty(cTipo),"NF ",cTipo)		// Bradesco
			cNsNum   := aLeitura[11]
			nDespes  := aLeitura[06]
			nDescont := aLeitura[07]
			nAbatim  := aLeitura[08]
			nValRec  := aLeitura[05]
			nJuros   := aLeitura[09]
			nMulta   := aLeitura[10]
			cOcorr   := PadR(aLeitura[03],3)
			nValOutrD:= aLeitura[12]
			nValCC   := aLeitura[13]
			cData    := aLeitura[14]
			cData    := ChangDate(cData,SEE->EE_TIPODAT)
			dDataCred:= Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5,2),"ddmmyy")
			dDataUser:= dDataCred
			cMotBan  := aLeitura[15]
			xBuffer  := aLeitura[17] // Segmentos concatenados
			aBuffer  := aLeitura[19] // Segmentos separados
			dDtVc		:= CTOD("//")

			aValores := ( { cNumTit, dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nVaLOutrD, nValCc, dDataCred, cOcorr, cMotBan, xBuffer, dDtVc, aBuffer })


			If ExistBlock("200GEMBX")
				ExecBlock("200GEMBX", .F., .F., {aValores})
			EndIf

			// Template GEM
			If lF200Var
				ExecBlock("F200VAR",.F.,.F.,{aValores})
			ElseIf ExistTemplate("GEMBaixa")
				ExecTemplate("GEMBaixa",.F.,.F.,)
			Endif

			If Empty(cNumTit)
				nLidos += nTamDet
				Loop
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica especie do titulo    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPos := Ascan(aTabela, {|aVal|aVal[1] == Alltrim(Substr(cTipo,1,3))})
			If nPos != 0
				cEspecie := aTabela[nPos][2]
			Else
				cEspecie	:= "  "
			EndIf
			If cEspecie $ MVABATIM			// Nao lˆ titulo de abatimento
				Loop
			EndIf
		EndIf
		If lF200Avl .And. !ExecBlock("F200AVL",.F.,.F.,{aValores} )
			Loop
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica codigo da ocorrencia ³
		//³ ¡ndice: Filial+banco+cod banco³
		//³ +tipo                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SEB")
		dbSetOrder(1)
		If !(dbSeek(xFilial("SEB")+mv_par06+cOcorr+"R"))
			Help(" ",1,"FA200OCORR",,mv_par06+"-"+cOcorr+"R",4,1)

			// Retorno Automatico via Job
			if ExecSchedule()
				Aadd(aMsgSch, "Ocorrencia "+mv_par06+" "+cOcorr+" nao localizada na tabela SEB.") // "Ocorrencia " # " nao localizada na tabela SEB."
			Endif
		Endif
		lHelp 		:= .F.
		lNaoExiste  := .F.				// Verifica se registro de reciclagem existe no SE1
		If lT200pos
			ExecTemplate("FA200POS",.F.,.F.,{aValores})
		Endif
		If l200pos
			Execblock("FA200POS",.F.,.F.,{aValores})
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existe o titulo no SE1. Caso este titulo nao seja ³
		//³ localizado, passa-se para a proxima linha do arquivo retorno. ³
		//³ O texto do help sera' mostrado apenas uma vez, tendo em vista ³
		//³ a possibilidade de existirem muitos titulos de outras filiais.³
		//³ OBS: Sera verificado inicialmente se nao existe outra chave   ³
		//³ igual para tipos de titulo diferentes.                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE1")
		IF ExistBlock("FA200SEB")
			lProcessa := ExecBlock("FA200SEB",.F.,.F.)
			lProcessa := IIF(ValType(lProcessa) != "L",.T., lProcessa)
		ENDIF

		IF lProcessa
			If SEB->EB_OCORR != "39"		// cod 39 -> indica reciclagem
				SE1->(dbSetOrder(1))
				lAchouTit := .F.

				If lFa200Fil
					l200Fil := .T.
					Execblock("FA200FIL",.F.,.F.,aValores)
				Else

					If (mv_par13 == 2 .And. lNewIndice) .And. !Empty( cFilFwSE1 )
						//Busca por IdCnab (sem filial)
						SE1->(dbSetOrder(19)) // IdCnab
						If SE1->(MsSeek(Substr(cNumTit,1,10)))
							cFilAnt	:= SE1->E1_FILIAL
							If lCtbExcl
								mv_par11 := 2  //Desligo contabilizacao on-line
							Endif
						Endif
					Else
						//Busca por IdCnab
						SE1->(dbSetOrder(16)) // Filial+IdCnab
						SE1->(MsSeek(xFilial("SE1")+	Substr(cNumTit,1,10)))
					Endif

					//Se nao achou, utiliza metodo antigo (titulo)
					If SE1->(!Found())
						SE1->(dbSetOrder(1))
						// Busca por chave antiga como retornado pelo banco
						If dbSeek(xFilial("SE1")+PadR(cNumTit,nTamTit)+cEspecie)
							lAchouTit := .T.
							nPos   := 1
						Endif

						While !lAchouTit
							// Busca por chave antiga
							dbSetOrder(1)
							If !MsSeek(xFilial("SE1")+Pad(cNumTit,nTamTit)+cEspecie)
								nPos := Ascan(aTabela, {|aVal|aVal[1] == Substr(cTipo,1,2)},nPos+1)
								If nPos != 0
									cEspecie := aTabela[nPos][2]
								Else
									Exit
								Endif
							Else
								lAchouTit := .T.
							Endif
						Enddo

						If !lAchouTit
							// Busca por chave antiga adaptada para o tamanho de 9 posicoes para numero de NF
							// Isto ocorre quando titulo foi enviado com 6 posicoes para numero de NF e retornou com o
							// campo ja atualizado para 9 posicoes
							cNumTit := SubStr(cNumTit,1,nTamPre)+Padr(Substr(cNumtit,4,6),nTamNum)+SubStr(cNumTit,10,nTamPar)
							If !Empty(cNumTit) .And. dbSeek(xFilial("SE1")+Substr(cNumTit,1,nTamTit))
								cEspecie := SE1->E1_TIPO
								lAchouTit := .T.
								nPos   := 1
							Endif


							While !lAchouTit
								// Busca por chave antiga
								dbSetOrder(1)
								If !dbSeek(xFilial("SE1")+Pad(cNumTit,nTamTit)+cEspecie)
									nPos := Ascan(aTabela, {|aVal|aVal[1] == Substr(cTipo,1,2)},nPos+1)
									If nPos != 0
										cEspecie := aTabela[nPos][2]
									Else
										Exit
									Endif
								Else
									lAchouTit := .T.
								Endif
							Enddo
						Endif
					Else
						nPos := 1
					Endif

					If nPos == 0
						lHelp := .T.
					EndIF
					If !lUmHelp .And. lHelp
						Help(" ",1,"NOESPECIE",,cNumTit+" "+cEspecie,5,1)
						lUmHelp := .T.

						// Retorno Automatico via Job
						if ExecSchedule()
							Aadd(aMsgSch, "Especie "+cEspecie+" nao localizada para o titulo "+cNumTit) // "Especie " # " nao localizada para o titulo "
						Endif
					Endif
				EndIf
			Else
				If lRecicl
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Mesmo que nao exista o registro no SE1, ele ser  criado no 	³
					//³ arquivo de reclicagem                                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSetOrder(nIndex+1)
					If !dbSeek(xFilial("SE1")+cNsNum)
						If !lFirst
							Fa200Recic()				// Abre arquivo de reciclagem
							lFirst := .T.
						EndIf
						Fa200GrRec(cNsNum)
						lNaoExiste := .T.				// Registro nao existente no SE1 -> portanto nao deve gravar nada no SE1!!
					Endif
				Else			//  uma rejeicao porem o registro nao foi cadastrado no SE1
					Help(" ",1,"NOESPECIE",,cNumTit+" "+cEspecie,5,1)
					lNaoExiste := .T.

					// Retorno Automatico via Job
					if ExecSchedule()
						Aadd(aMsgSch, "Especie "+cEspecie+" nao localizada para o titulo "+cNumTit) // "Especie " # " nao localizada para o titulo "
					Endif
				EndIf
			EndIF
		ENDIF

		BEGIN TRANSACTION

			// Retorno Automatico via Job
			// controla o status para emissao do relatorio de processamento
			if ExecSchedule()
				cStProc := ""
				if lNaoExiste
					cStProc := "Titulo Inexistente" // "Titulo Inexistente"
					Aadd(aFa205R,{cNumTit,"", "", dBaixa,	0, nValRec, cStProc })
				Elseif lHelp
					if SE1->E1_SALDO = 0
						cStProc := "Baixado anteriormente" // "Baixado anteriormente"
					Else
						cStProc := "Titulo com Erro" // "Titulo com Erro"
					Endif
				Endif
			Endif

			If !lHelp .And. !lNaoExiste
				// Retorno Automatico via Job
				// controla o status para emissao do relatorio de processamento do FINA205
				if ExecSchedule() .and. SE1->E1_SALDO = 0
					cStProc := "Baixado anteriormente" // "Baixado anteriormente"
				Endif

				lSai := .f.
				IF SEB->EB_OCORR $ "03|15|16|17|40|41|42|52|53"		//Registro rejeitado
					// Retorno Automatico via Job
					// controla o status para emissao do relatorio de processamento do FINA205
					if ExecSchedule()
						cStProc := "Entrada confirmada" // "Entrada confirmada"
					Endif

					For nCont := 1 To Len(cMotBan) Step 2
						cMotivo := Substr(cMotBan,nCont,2)
						If fa200Rejei(cMotivo,cOcorr)
							lSai := .T.
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Trata tarifas da retirada do titulo do banco	³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lBxCnab
								nTotDesp += nDespes
								nTotOutD += nOutrDesp
							Else
								IF nDespes > 0 .or. nOutrDesp > 0		//Tarifas diversas
									Fa200Tarifa()
								Endif
							Endif
							Exit
						EndIf
					Next nCont
					If lSai .And. ( MV_PAR12 == 1 )
						nLidos += nTamDet
					Endif
				Endif

				If !lSai
					IF SEB->EB_OCORR $ "06|07|08|36|37|38|39"		//Baixa do Titulo
						cPadrao:=fA070Pad()
						lPadrao:=VerPadrao(cPadrao)
						lContabiliza:= Iif(mv_par11==1,.T.,.F.)

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Monta Contabilizacao.         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !lCabec .and. lPadrao .and. lContabiliza
							nHdlPrv := HeadProva( cLote,;
							"FINA200",;
							substr( cUsuario, 7, 6 ),;
							@cArquivo )

							lCabec := .T.
						End
						nValEstrang := SE1->E1_SALDO
						lDesconto   := Iif(mv_par10==1,.T.,.F.)

						nTotAbImp	:= 0
						nTotAbat	:= SumAbatRec(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA, SE1->E1_MOEDA,"S",dBaixa,@nTotAbImp)
						ABATIMENTO 	:= nTotAbat

						If lAltPort
							cBanco      := Iif(Empty(SE1->E1_PORTADO),cBanco,SE1->E1_PORTADO)
							cAgencia    := Iif(Empty(SE1->E1_AGEDEP),cAgencia,SE1->E1_AGEDEP)
							cConta      := Iif(Empty(SE1->E1_CONTA),cConta,SE1->E1_CONTA)
						Endif

						cHist070    := OemToAnsi("Valor recebido s/ Titulo")  //"Valor recebido s/ Titulo"

						//Ponto de entrada para tratamento de abatimento e desconto que voltam na mesma posicao
						//Bradesco
						If lF200ABAT
							ExecBlock("F200ABAT",.F.,.F.)
						Endif

						SA6->(DbSetOrder(1))
						SA6->(MSSeek(xFilial("SA6")+cBanco+cAgencia+cConta))

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se a despesa est     ³
						//³ descontada do valor principal ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If SEE->EE_DESPCRD == "S"
							nValRec := nValRec+nDespes + nOutrDesp - nValCC
						EndIf
						// Calcula a data de credito, se esta estiver vazia
						If dDataCred == Nil .Or. Empty(dDataCred)
							dDataCred := dBaixa // Assume a data da baixa
							For nX := 1 To SA6->A6_Retenca // Para todos os dias de retencao
								// valida a data

								// O calculo eh feito desta forma, pois os dias de retencao
								// sao dias uteis, e se fosse apenas somado dDataCred+A6_Retenca
								// nao sera verdadeiro quando a data for em uma quinta-feira, por
								// exemplo e, tiver 2 dias de retencao.
								dDataCred := DataValida(dDataCred+1,.T.)
							Next
						EndIf
						dDataUser := dDataCred
						If dDataCred > dBaixa
							cModSpb := "3"   // COMPE
						Endif
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Possibilita alterar algumas das  ³
						//³ vari veis utilizadas pelo CNAB.  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

						If lFina200
							aValores[8] := nValRec
							ExecBlock("FINA200",.F.,.F., { aValores, nTotAbat, nTotAbImp } )
						Endif

						// Serao usadas na Fa070Grv para gravar a baixa do titulo, considerando os acrescimos e decrescimos
						nAcresc     := Round(NoRound(xMoeda(SE1->E1_SDACRES,SE1->E1_MOEDA,1,dBaixa,3),3),2)
						nDecresc    := Round(NoRound(xMoeda(SE1->E1_SDDECRE,SE1->E1_MOEDA,1,dBaixa,3),3),2)

						nDescont 	:= nDescont - nDecresc
						nJuros		:= nJuros - nAcresc

						lBaixou		:= fA070Grv(lPadrao,lDesconto,lContabiliza,cNsNum,.T.,dDataCred,lJurComis,cArqEnt,SEB->EB_OCORR)

						// evitando problemas de processamento
						if ExecSchedule()
							Sleep(500)
						Endif

						If lBaixou

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica se trata Rateio Multi-Natureza na Baixa CNAB  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lMulNatBx .And. MV_MULNATR .And. SE1->E1_MULTNAT == "1"

								//Variaveis para uso na funcao MultNatC
								nTotLtEZ  := 0
								lOK		  := .F.
								aColsSEV  := {}
								aGrvLctPco := {	{"000004","09","FINA200"}, ;
								{"000004","10","FINA200"}  }

								MultNatB("SE1",.F.,"1",@lOk,@aColsSEV,.T.,.T.)
								If lOk
									MultNatC( "SE1" /*cAlias*/,;
									@nHdlPrv /*@nHdlPrv*/,;
									@nTotal /*@nTotal*/,;
									@cArquivo /*@cArquivo*/,;
									lContabiliza /*lContabiliza*/,;
									.T. /*lBxLote*/,;
									"1" /*cReplica*/,;
									nTotLtEZ /*nTotLtEZ*/,;
									lOk /*lOk*/,;
									aColsSEV /*aCols*/,;
									.T. /*lBaixou*/,;
									aGrvLctPco /*aGrvLctPco*/,;
									lUsaFlag /*lUsaFlag*/,;
									@aFlagCTB /*@aFlagCTB*/	)
								Endif
							Endif


							// Retorno Automatico via Job
							// controla o status para emissao do relatorio de processamento do FINA205
							if ExecSchedule()
								cStProc := "Baixado Ok"
							Endif

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							//to do MARCOS BERTO
							If FWModeAccess("SE1") == "E"
								cFilAnt := SE1->E1_FILIAL
							EndIf
							If SE1->E1_SITUACA == "0"	// Carteira
								PcoDetLan("000004","01","FINA070")
							ElseIf SE1->E1_SITUACA == "1"	// Simples
								PcoDetLan("000004","02","FINA070")
							ElseIf SE1->E1_SITUACA == "2"	// Descontada
								PcoDetLan("000004","03","FINA070")
							ElseIf SE1->E1_SITUACA == "4"	// Vinculada
								PcoDetLan("000004","04","FINA070")
							ElseIf SE1->E1_SITUACA == "5"	// c/Advogado
								PcoDetLan("000004","05","FINA070")
							ElseIf SE1->E1_SITUACA == "6"	// Judicial
								PcoDetLan("000004","06","FINA070")
							ElseIf SE1->E1_SITUACA == "7"	// Caucionada Descontada
								PcoDetLan("000004","08","FINA070")

								//Para as novas situacoes de cobranca
								//repito os processos padroes existentes de acordo com a categoria de cada uma
							ElseIF FN022SITCB(cSituacao)[1]		//Carteira cSituacao $ "0|F|G"
								PcoDetLan("000004","01","FINA070")
							ElseIf FN022SITCB(cSituacao)[5]	//Simples e Cartorio   cSituacao $ "1|H"
								PcoDetLan("000004","02","FINA070")
							ElseIf FN022SITCB(cSituacao)[3]	//Descontada 	cSituacao $ "2|7"
								PcoDetLan("000004","03","FINA070")
							ElseIf FN022SITCB(cSituacao)[4]	//Cobranca em banco com protesto
								PcoDetLan("000004","06","FINA070")
							ElseIf FN022SITCB(cSituacao)[2]	//Cobranca em banco sem protesto exceto Simples e Cartorio
								PcoDetLan("000004","05","FINA070")
							EndIf
							cFilAnt := cFilOrig

							nTotAGer+=nValRec

							//Para baixa totalizadora somente gravo o movimento de titulos que
							//nao estejam em carteira descontada (2 ou 7) pois este movimento bancario
							//já foi gerado no momento da transferencia ou montagem do bordero
							IF !(FN022SITCB( SE1->E1_SITUACA )[3]) 	//SE1->E1_SITUACA $ "2/7"
								dbSelectArea("TRB")
								If !(dbSeek(xFilial("SE5")+Dtos(dDataCred)))
									Reclock("TRB",.T.)
									Replace FILMOV With xFilial("SE5")
									Replace DATAC With dDataCred
									Replace NATURE With SE1->E1_NATUREZ
									Replace MOEDA With StrZero(SE1->E1_MOEDA,2)
								Else
									Reclock("TRB",.F.)
								Endif
								Replace TOTAL WITH TOTAL + nValRec
								MsUnlock()
							Endif
						Else
							LoadVlBx( nHdlBco, xBuffer, nTamDet, @nValtot, @nTotDesp, @nTotOutD, @nTotValCc, @nTotAGer,aLeitura, lBxCnab)
							cStProc := "Problemas na Baixa"
						Endif

						If lBxCnab
							nTotValCc += nValCC
						Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Grava Outros Cr‚ditos, se houver valor                 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If nValcc > 0
								fa200Outros()
							Endif
						Endif

						If lCabec .and. lPadrao .and. lContabiliza .and. lBaixou
							nTotal += DetProva( nHdlPrv,;
							cPadrao,;
							"FINA200" /*cPrograma*/,;
							cLote,;
							/*nLinha*/,;
							/*lExecuta*/,;
							/*cCriterio*/,;
							/*lRateio*/,;
							/*cChaveBusca*/,;
							/*aCT5*/,;
							/*lPosiciona*/,;
							@aFlagCTB,;
							/*aTabRecOri*/,;
							/*aDadosProva*/ )
						Endif


						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Credito em C.Corrente -> gera ³
						//³ arquivo de reciclagem         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If SEB->EB_OCORR $ "39"
							If lRecicl
								If !lFirst
									Fa200Recic()
									lFirst := .T.
								EndIf
								Fa200GrRec(cNsNum)
								dbSelectArea("SE1")
								RecLock("SE1")
								Replace E1_OCORREN With "02"
								MsUnlock()
							EndIf
						EndIf
					Endif

					If lBxCnab
						nTotDesp += nDespes
						nTotOutD += nOutrDesp
					Else
						IF nDespes > 0 .or. nOutrDesp > 0		//Tarifas diversas
							Fa200Tarifa()
						Endif
					Endif

					If SEB->EB_OCORR == "02"			// Confirma‡„o
						RecLock("SE1")
						SE1->E1_OCORREN := "01"
						If Empty(SE1->E1_NUMBCO)
							SE1->E1_NUMBCO  := cNsNUM
						EndIf
						MsUnLock()
						If lFa200_02
							ExecBlock("FA200_02",.f.,.f.)
						Endif
					Endif

					//Grava alteracao da data de vencto quando for o caso
					If SEB->EB_OCORR $ "14" .and. !Empty(dDtVc)  //Alteracao de Vencto
						RecLock("SE1")
						Replace SE1->E1_VENCTO With dDtVc
						Replace SE1->E1_VENCREA With DataValida(dDtVc,.T.)
						MsUnlock()
					Endif

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Trecho incluido para integração e-commerce          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If  lBaixou
						If  LJ861EC01(SE1->E1_NUM, SE1->E1_PREFIXO, .T./*PrecisaTerPedido*/)
							LJ861EC02(SE1->E1_NUM, SE1->E1_PREFIXO)
						EndIf
					EndIf

					// Retorno Automatico via Job
					// armazena os dados do titulo para emissao de relatorio de processamento
					if ExecSchedule()
						If lBaixou
							Aadd(aFa205R,{SE1->E1_NUM,		SE1->E1_CLIENTE, 	SE1->E1_LOJA, dDataCred,	SE1->E1_VALOR, nValRec, "Baixado ok" })
						Else
							Aadd(aFa205R,{SE1->E1_NUM,		SE1->E1_CLIENTE, 	SE1->E1_LOJA, dDataCred,	SE1->E1_VALOR, nValRec, cStProc })
						Endif
					Endif

					//Instrucao de alteracao de carteira de cobrança
					IF SEB->EB_OCORR $ "90|91|93|94|95|96|9F|9G|9H"
						F200TRFCOB(SEB->EB_OCORR,cBanco,cAgencia,cConta)
					Endif

				EndIf

			Endif
			// evitando problemas de processamento
			If ExecSchedule()
				Sleep(500)
			Endif

		END TRANSACTION

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Integracao protheus X tin	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If !lSai .And. lBaixou
			ALTERA:=.T.
			FwIntegDef( 'FINA070' )
			ALTERA:= lAltera
		Endif

		If !lSai

			// Avanca uma linha do arquivo retorno
			nLidos+= IF(MV_PAR12 == 2, nLinRead*nTamDet, nTamDet)
			nLinRead := 0

			// Se baixou o titulo e existir o arquivo de LOG, grava as informacoes pertinentes
			// Para futuro reprocessamento se preciso for.
			If lBaixou .And. lFI0InDic
				Fa200GrvLog(2, cArqEnt, cBanco, cAgencia, cConta, nLastLn,If(Empty(SE1->E1_IDCNAB), SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO), SE1->E1_IDCNAB), SEB->EB_REFBAN, SEB->EB_OCORR, cIdArq )
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Possibilita alterar algumas das  ³
			//³ vari veis utilizadas pelo CNAB.  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lF200Tit
				ExecBlock("F200TIT",.F.,.F.)
			Endif

		EndIf

	Enddo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a gravacao dos lancamentos do SIGAPCO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoFinLan("000004")


	If lCabec .and. lPadrao .and. lContabiliza
		dbSelectArea("SE1")
		dbGoBottom()
		dbSkip()
		VALOR := nTotAger
		ABATIMENTO := 0
		//nTotal+=DetProva(nHdlPrv,cPadrao,"FINA200",cLote)
		nTotal += DetProva( nHdlPrv,;
		cPadrao,;
		"FINA200" /*cPrograma*/,;
		cLote,;
		/*nLinha*/,;
		/*lExecuta*/,;
		/*cCriterio*/,;
		/*lRateio*/,;
		/*cChaveBusca*/,;
		/*aCT5*/,;
		/*lPosiciona*/,;
		@aFlagCTB,;
		/*aTabRecOri*/,;
		/*aDadosProva*/ )


	Endif

	If l200Fil .and. lfa200F1
		Execblock("FA200F1",.f.,.f.)
	Endif

	If lTF200Fim
		ExecTemplate("F200FIM",.f.,.f.)
	Endif
	If lF200Fim
		Execblock("F200FIM",.f.,.f.)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava no SEE o n£mero do £ltimo lote recebido e gera ³
	//³ movimentacao bancaria											³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cLoteFin) .and. lBxCnab
		RecLock("SEE",.F.)
		SEE->EE_LOTE := cLoteFin
		MsUnLock()
		//MOVIMENTOS TOTALIZADORES
		If TRB->(Reccount()) > 0
			dbSelectArea("TRB")
			dbGoTop()
			While !Eof()
				cFilAnt := TRB->FILMOV

				//Define os campos que não existem na FK5 e que serão gravados apenas na E5, para que a gravação da E5 continue igual
				//Estrutura para o E5_CAMPOS: "{{'SE5->CAMPO', Valor}, {'SE5->CAMPO', Valor}}"
				cCamposE5 := "{"
				cCamposE5 += "{'E5_DTDIGIT'	,STOD('" + DToS(TRB->DATAC)	+ "')}"
				cCamposE5 += ",{'E5_LOTE'	,'" + cLoteFin				+ "' }"
				cCamposE5 += "}"

				oModelMov := FWLoadModel("FINM030")							//Model de Movimento Bancário
				oModelMov:SetOperation( MODEL_OPERATION_INSERT )			//Inclusao
				oModelMov:Activate()										//Ativa o modelo de dados
				oModelMov:SetValue( "MASTER","E5_GRV"	, .T.		)	//Informa se vai gravar SE5 ou não
				oModelMov:SetValue( "MASTER", "NOVOPROC", .T.		)	//Informa que a inclusão será feita com um novo número de processo
				oModelMov:SetValue( "MASTER","E5_CAMPOS", cCamposE5	)	//Informa os campos da SE5 que serão gravados indepentes de FK5

				oSubFK5 := oModelMov:GetModel( "FK5DETAIL" )
				oSubFKA := oModelMov:GetModel("FKADETAIL")

				oSubFKA:SetValue( "FKA_IDORIG", FWUUIDV4() )
				oSubFKA:SetValue( "FKA_TABORI", "FK5" )

				//Informacoes do movimento
				oSubFK5:SetValue( "FK5_ORIGEM"	,FunName() )
				oSubFK5:SetValue( "FK5_DATA"	,TRB->DATAC )
				oSubFK5:SetValue( "FK5_VALOR"	,(TRB->TOTAL + nValtot) )
				oSubFK5:SetValue( "FK5_RECPAG"	,"R" )
				oSubFK5:SetValue( "FK5_MOEDA"	,TRB->MOEDA )
				oSubFK5:SetValue( "FK5_NATURE"	,TRB->NATURE )
				oSubFK5:SetValue( "FK5_BANCO"	,cBanco )
				oSubFK5:SetValue( "FK5_AGENCI"	,cAgencia )
				oSubFK5:SetValue( "FK5_CONTA"	,cConta )
				oSubFK5:SetValue( "FK5_DTDISP"	,TRB->DATAC )
				oSubFK5:SetValue( "FK5_HISTOR"	,STR0011 + " " + cLoteFin ) // "Baixa por Retorno CNAB / Lote :"
				oSubFK5:SetValue( "FK5_TPDOC"	,"VL" ) //Colocado pois este movimento nao gera TIPODOC necessário para adequacao
				oSubFK5:SetValue( "FK5_FILORI"	,cFilAnt )
				oSubFK5:SetValue( "FK5_LA"		,"S" ) //Esse movimento não deve ser contabilizado
				If SpbInUse()
					oSubFK5:SetValue( "FK5_MODSPB", "1" )
				Endif

				If oModelMov:VldData()
					oModelMov:CommitData()
					SE5->(dbGoto(oModelMov:GetValue( "MASTER", "E5_RECNO" )))
					oModelMov:DeActivate()
				Else
					lRet := .F.
					cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
					cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
					cLog += cValToChar(oModelMov:GetErrorMessage()[6])

					Help( ,,"M030_FA200Ger",,cLog, 1, 0 )
				Endif

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Gravacao complementar dos dados da baixa aglutinada  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ExistBlock("F200BXAG")
					Execblock("F200BXAG",.f.,.f.)
				Endif

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza saldo bancario.      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				AtuSalBco(cBanco,cAgencia,cConta,SE5->E5_DATA,SE5->E5_VALOR,"+")
				dbSelectArea("TRB")
				dbSkip()
			Enddo
		Endif
		If nTotDesp > 0 .Or. nTotOutD > 0
			Fa200Tarifa(nTotDesp, nTotOutD)
		Endif
		If nTotValCC > 0
			fa200Outros(nTotValCC)
		Endif
	EndIf

	cFilAnt := cFilOrig					// sempre restaura a filial original

	//Contabilizo totalizador das despesas bancárias e outros creditos
	If !lBxCnab

		VALOR2 := nCtDesp
		VALOR3 := nCtOutCrd

		dbSelectArea("SE5")
		nRegSE5 := SE5->(Recno())
		dbGoBottom()
		dbSkip()

		lPadrao:=VerPadrao("562")		// Movimentacao Banc ria a Pagar
		lContabiliza:= Iif(mv_par11==1,.T.,.F.)

		If !lCabec .and. lPadrao .and. lContabiliza
			nHdlPrv := HeadProva( cLote,;
			"FINA200",;
			substr( cUsuario, 7, 6 ),;
			@cArquivo )
			lCabec := .T.
		Endif

		If lCabec .and. lPadrao .and. lContabiliza
			//Total de Despesas e Outras despesas
			nTotal += DetProva( nHdlPrv,;
			"562",;
			"FINA200" /*cPrograma*/,;
			cLote,;
			/*nLinha*/,;
			/*lExecuta*/,;
			/*cCriterio*/,;
			/*lRateio*/,;
			/*cChaveBusca*/,;
			/*aCT5*/,;
			/*lPosiciona*/,;
			@aFlagCTB,;
			/*aTabRecOri*/,;
			/*aDadosProva*/ )

			//Total de Outros Créditos
			nTotal += DetProva( nHdlPrv,;
			"563",;
			"FINA200" /*cPrograma*/,;
			cLote,;
			/*nLinha*/,;
			/*lExecuta*/,;
			/*cCriterio*/,;
			/*lRateio*/,;
			/*cChaveBusca*/,;
			/*aCT5*/,;
			/*lPosiciona*/,;
			@aFlagCTB,;
			/*aTabRecOri*/,;
			/*aDadosProva*/ )
		Endif

		PCODetLan("000007","11","FINA200")

		VALOR2 := VALOR3 := 0
		dbSelectArea("SE5")
		dbGoto(nRegSE5)
	Endif

	IF lCabec .and. nTotal > 0
		RodaProva(  nHdlPrv,;
		nTotal )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Envia para Lancamento Contabil                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cA100Incl( cArquivo,;
		nHdlPrv,;
		3 /*nOpcx*/,;
		cLote,;
		lDigita,;
		lAglut,;
		/*cOnLine*/,;
		/*dData*/,;
		/*dReproc*/,;
		@aFlagCTB,;
		/*aDadosProva*/,;
		/*aDiario*/ )

		aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento
	Endif

	PcoFinLan("000007")

	If lRecicl

		If lFirst
			dbSelectArea("cTemp")
			dbCloseArea()
		Endif
		If cIndex != " "
			RetIndex("SE1")
			Set Filter To
			FErase (cIndex+OrdBagExt())
		EndIf
	Endif

	dbSelectArea("TRB")
	dbCloseArea()
	if ExecSchedule()
		Sleep(2000)
	Endif
	Ferase(cNomeArq+GetDBExtension())         // Elimina arquivos de Trabalho
	Ferase(cNomeArq+OrdBagExt())	 			   // Elimina arquivos de Trabalho

	VALOR := 0
	ABATIMENTO := 0

	SM0->(dbGoTo(nRegEmp))
	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

	dbSelectArea( "SE1" )
	dbSetOrder(1)
	dbGoTo( nSavRecno )
	If ExistBlock("F200IMP")
		ExecBlock("F200IMP",.F.,.F.)
	Endif

Return .F.

/*/
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fA200Par  ³ Autor ³ Wagner Xavier         ³ Data ³ 26/05/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Aciona parametros do Programa                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fA200Par()
	Pergunte( cPerg )
	MV_PAR04 := UPPER(MV_PAR04)
Return .T.

/*/
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fA200Rejei³ Autor ³ Wagner Xavier         ³ Data ³ 26/05/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Trata titulo rejeitado.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fa200Rejei                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fa200Rejei(cMotivo,cOcorr)
	Local cAlias		:= Alias()
	Local lRet			:= .F.
	Local lPadrao		:= .f.
	Local cNumBor		:= " "
	Local oModelMov	:= Nil //Model de Movimento Bancário
	Local oSubFKA		:= Nil
	Local oSubFK5		:= Nil
	Local cLog			:= ""
	Local cCamposE5	:= ""

	Private cSituant:= "0"									// Private para permitir condicionamento para contabilização

	Default cOcorr := ""

	dbSelectArea("SEB")
	dbSetOrder(1)
	// Procura pela chave completa->filial+banco+ocorrencia+tipo+motivo banco
	If dbSeek(xFilial("SEB")+mv_par06+cOcorr+"R"+cMotivo)
		IF SEB->EB_MOTSIS == "01" .OR. EMPTY(SEB->EB_MOTSIS)	// Titulo protestado ou nao pago
			dbSelectArea("SEA")											// Retorna p/ carteira
			dbSetOrder(1)
			If dbSeek(xFilial("SEA")+SE1->E1_NUMBOR+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
				Reclock( "SEA" , .F. , .T.)
				SEA->(dbDelete( ))
				MsUnlock()
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ PONTO DE ENTRADA FA280RE2                                     ³
			//³ Tratamento de dados de titulo rejeitado antes de "zerar" os 	³
			//³ dados do mesmo.                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistBlock("FA200RE2")
				Execblock("FA200RE2",.F.,.F.)
			Endif
			cSituant := SE1->E1_SITUACA
			cNumBor := SE1->E1_NUMBOR
			Reclock( "SE1" )
			SE1->E1_SITUACA := "0"
			SE1->E1_PORTADO := Space(Len(SE1->E1_PORTADO) )
			SE1->E1_AGEDEP  := Space(Len(SE1->E1_AGEDEP ) )
			SE1->E1_CONTA   := Space(Len(SE1->E1_CONTA  ) )
			SE1->E1_DATABOR := CtoD ( "" )
			SE1->E1_NUMBOR  := Space(Len(SE1->E1_NUMBOR ) )
			SE1->E1_NUMBCO  := Space(Len(SE1->E1_NUMBCO ) )
			SE1->E1_OCORREN := "01"
			lRet := .T.
			MsUnlock()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Efetua a contabilizacao da transferencia para carteira, caso   ³
			//³exista este lancamento padrao, pois se nao for feito neste mo- ³
			//³mento nao havera registro da rejeicao.                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lPadrao:=VerPadrao("540")
			If !lCabec .and. lPadrao
				nHdlPrv := HeadProva( cLote,;
				"FINA200",;
				substr( cUsuario, 7, 6 ),;
				@cArquivo )

				lCabec := .T.
			Endif

			If lCabec .and. lPadrao
				nTotal += DetProva( nHdlPrv,;
				"540",;
				"FINA200" /*cPrograma*/,;
				cLote,;
				/*nLinha*/,;
				/*lExecuta*/,;
				/*cCriterio*/,;
				/*lRateio*/,;
				/*cChaveBusca*/,;
				/*aCT5*/,;
				/*lPosiciona*/,;
				@aFlagCTB,;
				/*aTabRecOri*/,;
				/*aDadosProva*/ )

				// Forca a contabilizacao da rejeicao on-line pois nao e registrada
				// a transferencia para a carteira
				lDigita := .T.
			Endif

			If FN022SITCB( cSituAnt )[3]	//  'Se cobranca descontada e rejeita gera um movimento a pagar"

				//Define os campos que não existem na FK5 e que serão gravados apenas na E5, para que a gravação da E5 continue igual
				//Estrutura para o E5_CAMPOS: "{{'SE5->CAMPO', Valor}, {'SE5->CAMPO', Valor}}"
				cCamposE5 := "{"
				cCamposE5 += "{'E5_DTDIGIT'	,STOD('" + DTOS(dDataBase) + "')}"
				cCamposE5 += "}"

				oModelMov := FWLoadModel("FINM030")							//Model de Movimento Bancário
				oModelMov:SetOperation( MODEL_OPERATION_INSERT )			//Inclusao
				oModelMov:Activate()										//Ativa o modelo de dados
				oModelMov:SetValue( "MASTER","E5_GRV"		, .T.		)	//Informa se vai gravar SE5 ou não
				oModelMov:SetValue( "MASTER", "NOVOPROC"	, .T.		)	//Informa que a inclusão será feita com um novo número de processo
				oModelMov:SetValue( "MASTER","E5_CAMPOS"	,cCamposE5	)	//Informa os campos da SE5 que serão gravados indepentes de FK5

				oSubFKA := oModelMov:GetModel("FKADETAIL")
				oSubFKA:SetValue( "FKA_IDORIG", FWUUIDV4() )
				oSubFKA:SetValue( "FKA_TABORI", "FK5" )

				//Informacoes do movimento
				oSubFK5 := oModelMov:GetModel( "FK5DETAIL" )
				oSubFK5:SetValue( "FK5_ORIGEM"	,FunName() )
				oSubFK5:SetValue( "FK5_DATA"	,dBaixa )
				oSubFK5:SetValue( "FK5_VALOR"	,nValrec )
				oSubFK5:SetValue( "FK5_VLMOE2"	,nValrec )
				oSubFK5:SetValue( "FK5_RECPAG"	,"P" )
				oSubFK5:SetValue( "FK5_BANCO"	,cBanco )
				oSubFK5:SetValue( "FK5_AGENCI"	,cAgencia )
				oSubFK5:SetValue( "FK5_CONTA"	,cConta )
				oSubFK5:SetValue( "FK5_DTDISP"	,dBaixa )
				oSubFK5:SetValue( "FK5_HISTOR"	,"EST. " + cNumBor+" "+SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA+" "+SE1->E1_TIPO )
				oSubFK5:SetValue( "FK5_MOEDA"	,STRZero(SE1->E1_MOEDA,2))
				oSubFK5:SetValue( "FK5_NATURE"	,SE1->E1_NATUREZ)
				oSubFK5:SetValue( "FK5_TPDOC"	,"ES"			)
				If SpbInUse()
					oSubFK5:SetValue( "FK5_MODSPB", "1" )
				Endif

				If oModelMov:VldData()
					oModelMov:CommitData()
					oModelMov:DeActivate()
				Else
					lRet := .F.
					cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
					cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
					cLog += cValToChar(oModelMov:GetErrorMessage()[6])

					Help( ,,"M030_FA200Rejei",,cLog, 1, 0 )
				Endif

				AtuSalBco(cBanco,cAgencia,cConta,SE5->E5_DATA,SE5->E5_VALOR,"-")

				lPadrao:=VerPadrao("562")
				If !lCabec .and. lPadrao
					nHdlPrv := HeadProva( cLote,;
					"FINA200",;
					substr( cUsuario, 7, 6 ),;
					@cArquivo )
					lCabec := .T.
				Endif

				If lCabec .and. lPadrao

					If lUsaFlag // Armazena em aFlagCTB para atualizar no modulo Contabil
						aAdd( aFlagCTB, { "E5_LA", "S", "SE5", SE5->( RecNo() ), 0, 0, 0} )
					EndIf

					nTotal += DetProva( nHdlPrv,;
					"562",;
					"FINA200" /*cPrograma*/,;
					cLote,;
					/*nLinha*/,;
					/*lExecuta*/,;
					/*cCriterio*/,;
					/*lRateio*/,;
					/*cChaveBusca*/,;
					/*aCT5*/,;
					/*lPosiciona*/,;
					@aFlagCTB,;
					/*aTabRecOri*/,;
					/*aDadosProva*/ )

					If LanceiCtb .And. !lUsaFlag

						oModelMov := FWLoadModel("FINM030") //Recarrega o Model de movimentos para pegar o campo do relacionamento (SE5->E5_IDORIG)
						oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
						oModelMov:Activate()
						oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //habilita gravação de SE5

						//Posiciona a FKA com base no IDORIG da SE5 posicionada
						oSubFKA := oModelMov:GetModel( "FKADETAIL" )
						If oSubFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )

							//Dados do movimento
							oSubFK5 := oModelMov:GetModel( "FK5DETAIL" )
							oSubFK5:SetValue( "FK5_LA", "S")

							If oModelMov:VldData()
								oModelMov:CommitData()
								oModelMov:DeActivate()
							Else
								lRet := .F.
								cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
								cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
								cLog += cValToChar(oModelMov:GetErrorMessage()[6])

								Help( ,,"M030_FA200Rejei",,cLog, 1, 0 )
							Endif
						Endif
						oModelMov:DeActivate()

					EndIf

					// Forca a contabilizacao da rejeicao on-line pois nao e registrada
					// a transferencia para a carteira
					lDigita := .T.
				Endif
			EndIf
		Endif

		//DDA - Debito Direto Autorizado
		If Alltrim(cOcorr) $ "53/52"
			Reclock("SE1")
			SE1->E1_OCORREN := cOcorr
			MsUnlock()
		Endif

	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ PONTO DE ENTRADA FA280REJ                                     ³
	//³ Tratamento de dados de titulo rejeitado                     	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("FA200REJ")
		Execblock("FA200REJ",.F.,.F.)
	Endif
	MsUnlock()
	dbSelectArea( cAlias )
Return lRet

/*/
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fA200Tarif³ Autor ³ Wagner Xavier         ³ Data ³ 26/05/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Trata uma determinada tarifa.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fa200Tarifa( )                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fa200Tarifa(nTotDesp, nTotOutD)

	Local cAlias		:= Alias()
	Local lPadrao		:= VerPadrao("562")		// Movimentacao Banc ria a Pagar
	Local lContabiliza	:= Iif(mv_par11==1,.T.,.F.)
	Local cNat			:= ""
	Local lSpbInUse		:= SpbInUse()
	Local nX			:= 0
	Local oModelMov		:= Nil //Model de Movimento Bancário
	Local oSubFK1		:= Nil
	Local oSubFK5		:= Nil
	Local oSubFKA		:= ""
	Local cLog			:= ""
	Local lRet			:= .T.
	Local cCamposE5		:= ""
	Local cChaveTit		:= ""
	Local cHistorDB		:= ""
	Local cChaveFK7 	:= ""
	Local cLoteDB		:= ""

	nDespes   := If(nTotDesp == Nil, nDespes  , nTotDesp)
	nOutrDesp := If(nTotOutD == Nil, nOutrDesp, nTotOutD)

	If nDespes > 0 .or. nOutrDesp > 0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula a data de credito, se esta estiver vazia			³
		//³ Se aplica apenas nos casos de confirma‡Æo de entrada do	³
		//³ titulo e tenha lancamento de Despesas Banc rias, pois 	³
		//³ nas ocorrencias de baixa, essa data ja estara calculada ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If dDataCred == Nil .Or. Empty(dDataCred)
			dDataCred := If(!Empty(dBaixa),dBaixa,SE5->E5_DATA)  // Assume a data da baixa ou a data do movimento totalizador
			dBaixa := If(!Empty(dBaixa),dBaixa,SE5->E5_DATA)
			For nX := 1 To Sa6->A6_Retenca // Para todos os dias de retencao
				// valida a data
				// O calculo eh feito desta forma, pois os dias de retencao
				// sao dias uteis, e se fosse apenas somado dDataCred+A6_Retenca
				// nao sera verdadeiro quando a data for em uma quinta-feira, por
				// exemplo e, tiver 2 dias de retencao.
				dDataCred := DataValida(dDataCred+1,.T.)
			Next
		EndIf

		// Gera registro na movimentacao bancaria
		cNat := F200VerNat()

		// Despesas Bancárias
		If nDespes > 0

			//Define os campos que não existem na FK5 e que serão gravados apenas na E5, para que a gravação da E5 continue igual
			//Estrutura para o E5_CAMPOS: "{{'SE5->CAMPO', Valor}, {'SE5->CAMPO', Valor}}"
			cCamposE5 := "{"
			cCamposE5 += "{'E5_DTDIGIT'	,STOD('" + DTOS(dDataBase) + "')}"
			cCamposE5 += ",{'E5_MOTBX'	,'NOR'		}"
			If nTotDesp # Nil
				cLoteDB := cLoteFin
				cHistorDB := "Baixa por Retorno CNAB / Lote :" + " " + cLoteFin //"Baixa por Retorno CNAB / Lote :"
				cChaveFK7 := ""
			Else
				cCamposE5 += ",{'E5_PREFIXO' ,'" + SE1->E1_PREFIXO	+ "'}"
				cCamposE5 += ",{'E5_NUMERO'	 ,'" + SE1->E1_NUM		+ "'}"
				cCamposE5 += ",{'E5_PARCELA' ,'" + SE1->E1_PARCELA	+ "'}"
				cCamposE5 += ",{'E5_TIPO'	 ,'" + SE1->E1_TIPO		+ "'}"
				cCamposE5 += ",{'E5_CLIFOR'	 ,'" + SE1->E1_CLIENTE	+ "'}"
				cCamposE5 += ",{'E5_LOJA'	 ,'" + SE1->E1_LOJA		+ "'}"
				cLoteDB		:= ""
				cHistorDB	:= SEB->EB_DESCRI
				//Dados da tabela auxiliar com o código do título a receber
				cChaveTit	:= xFilial("SE1") + "|" + SE1->E1_PREFIXO 	+ "|" + SE1->E1_NUM 	+ "|" + SE1->E1_PARCELA + "|" + ;
				SE1->E1_TIPO		+ "|" + SE1->E1_CLIENTE + "|" + SE1->E1_LOJA
				cChaveFK7	:= FINGRVFK7( "SE1", cChaveTit )

			EndIf
			cCamposE5 += "}"

			oModelMov := FWLoadModel("FINM030")							//Model de Movimento Bancario
			oModelMov:SetOperation( MODEL_OPERATION_INSERT )			//Inclusao
			oModelMov:Activate()											//Ativa o modelo de dados
			oModelMov:SetValue( "MASTER","E5_GRV"		,.T.		)	//Informa se vai gravar SE5 ou não
			oModelMov:SetValue( "MASTER","NOVOPROC"	,.T.		)	//Informa que a inclusão será feita com um novo número de processo
			oModelMov:SetValue( "MASTER","E5_CAMPOS"	,cCamposE5	)	//Informa os campos da SE5 que serão gravados indepentes de FK5

			oSubFKA := oModelMov:GetModel( "FKADETAIL" )
			oSubFKA:SetValue( 'FKA_IDORIG', FWUUIDV4() )
			oSubFKA:SetValue( 'FKA_TABORI', "FK5" )

			//Informacoes do movimento
			oSubFK5 := oModelMov:GetModel( "FK5DETAIL" )
			oSubFK5:SetValue( "FK5_IDDOC"	,cChaveFK7 )
			oSubFK5:SetValue( "FK5_ORIGEM"	,FunName() )
			oSubFK5:SetValue( "FK5_DATA"	,dBaixa )
			oSubFK5:SetValue( "FK5_VALOR"	,nDespes )
			oSubFK5:SetValue( "FK5_RECPAG"	,"P" )
			oSubFK5:SetValue( "FK5_BANCO"	,SA6->A6_COD )
			oSubFK5:SetValue( "FK5_AGENCI"	,SA6->A6_AGENCIA )
			oSubFK5:SetValue( "FK5_CONTA"	,SA6->A6_NUMCON )
			oSubFK5:SetValue( "FK5_DTDISP"	,dDataCred )
			oSubFK5:SetValue( "FK5_NATURE"	,If(!Empty(cNat),cNat,SE1 -> E1_NATUREZ)	)
			oSubFK5:SetValue( "FK5_TPDOC"	,"DB"	)
			oSubFK5:SetValue( "FK5_LOTE"	,cLoteDB )
			oSubFK5:SetValue( "FK5_FILORI"	,cFilAnt )
			oSubFK5:SetValue( "FK5_HISTOR"	,cHistorDB )
			oSubFK5:SetValue( "FK5_MOEDA"	,StrZero(SE1->E1_MOEDA,2) )
			If SpbInUse()
				oSubFK5:SetValue( "FK5_MODSPB", "1" )
			Endif

			If oModelMov:VldData()
				oModelMov:CommitData()
				SE5->(dbGoto(oModelMov:GetValue( "MASTER", "E5_RECNO" )))
			Else
				lRet := .F.
				cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
				cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
				cLog += cValToChar(oModelMov:GetErrorMessage()[6])

				Help( ,,"M_200TRFDB",,cLog, 1, 0 )
			Endif
			oModelMov:DeActivate()


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ PONTO DE ENTRADA F200DB1                                    ³
			//³ Serve para tratamento complementar das despesas bancarias.  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF ExistBlock("F200DB1")
				ExecBlock("F200DB1",.F.,.F.)
			Endif

			AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DATA,SE5->E5_VALOR,"-")

			If !lCabec .and. lPadrao .and. lContabiliza
				nHdlPrv := HeadProva( cLote,;
				"FINA200",;
				substr( cUsuario, 7, 6 ),;
				@cArquivo )

				lCabec := .T.
			Endif

			dbSelectArea("SE5")

			If lCabec .and. lPadrao .and. lContabiliza

				If lUsaFlag // Armazena em aFlagCTB para atualizar no modulo Contabil
					aAdd( aFlagCTB, { "E5_LA", "S", "SE5", SE5->( RecNo() ), 0, 0, 0} )
				EndIf

				nTotal += DetProva( nHdlPrv,;
				"562",;
				"FINA200" /*cPrograma*/,;
				cLote,;
				/*nLinha*/,;
				/*lExecuta*/,;
				/*cCriterio*/,;
				/*lRateio*/,;
				/*cChaveBusca*/,;
				/*aCT5*/,;
				/*lPosiciona*/,;
				@aFlagCTB,;
				/*aTabRecOri*/,;
				/*aDadosProva*/ )

				If LanceiCtb .And. !lUsaFlag

					//Recarrega o Model de movimento bancário para atualizar o flag de contabilizacao
					oModelMov := FWLoadModel("FINM030")
					oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
					oModelMov:Activate()
					oModelMov:SetValue( "MASTER", "E5_GRV", .T. )

					//Posiciona a FKA com base no IDORIG da SE5 posicionada
					oSubFKA := oModelMov:GetModel( "FKADETAIL" )
					If oSubFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )

						oSubFK5 := oModelMov:GetModel( "FK5DETAIL" )
						oSubFK5:SetValue( "FK5_LA", "S" )

						If oModelMov:VldData()
							oModelMov:CommitData()
							oModelMov:DeActivate()
						Else
							lRet := .F.
							cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
							cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
							cLog += cValToChar(oModelMov:GetErrorMessage()[6])
							oModelMov:DeActivate()
							Help( ,,"M_200TRFODC",,cLog, 1, 0 )
						Endif
					Else
						oModelMov:DeActivate()
					Endif
				EndIf
			Endif
			nCtDesp += nDespes
		Endif

		// Outras Despesas
		If nOutrDesp > 0

			// Gera registro na movimentacao bancaria
			cNat := F200VerNat()

			//Define os campos que não existem na FK5 e que serão gravados apenas na E5, para que a gravação da E5 continue igual
			//Estrutura para o E5_CAMPOS: "{{'SE5->CAMPO', Valor}, {'SE5->CAMPO', Valor}}"
			cCamposE5 := "{"
			cCamposE5 += "{'E5_DTDIGIT'	,STOD('" + DTOS(dDataBase) + "')}"
			cCamposE5 += ",{'E5_MOTBX'	,'NOR'		}"
			If nTotDesp # Nil
				cLoteDB		:= cLoteFin
				cHistorDB	:= STR0011 + " " + cLoteFin //"Baixa por Retorno CNAB / Lote :"
				cChaveFK7	:= ""
			Else
				cCamposE5 += ",{'E5_PREFIXO' ,'" + SE1->E1_PREFIXO	+ "'}"
				cCamposE5 += ",{'E5_NUMERO'	 ,'" + SE1->E1_NUM		+ "'}"
				cCamposE5 += ",{'E5_PARCELA' ,'" + SE1->E1_PARCELA	+ "'}"
				cCamposE5 += ",{'E5_TIPO'	 ,'" + SE1->E1_TIPO		+ "'}"
				cCamposE5 += ",{'E5_CLIFOR'	 ,'" + SE1->E1_CLIENTE	+ "'}"
				cCamposE5 += ",{'E5_LOJA'	 ,'" + SE1->E1_LOJA		+ "'}"

				cLoteDB		:= ""
				cHistorDB	:= SEB->EB_DESCRI
				//Dados da tabela auxiliar com o código do título a receber
				cChaveTit	:= xFilial("SE1") + "|" + SE1->E1_PREFIXO 	+ "|" + SE1->E1_NUM 	+ "|" + SE1->E1_PARCELA + "|" + ;
				SE1->E1_TIPO		+ "|" + SE1->E1_CLIENTE + "|" + SE1->E1_LOJA
				cChaveFK7	:= FINGRVFK7( "SE1", cChaveTit )

			EndIf
			cCamposE5 += "}"

			oModelMov := FWLoadModel("FINM030")							//Model de Movimento Bancario
			oModelMov:SetOperation( MODEL_OPERATION_INSERT )			//Inclusao
			oModelMov:Activate()
			oModelMov:SetValue( "MASTER","E5_GRV"		,.T.		)	//Informa se vai gravar SE5 ou não
			oModelMov:SetValue( "MASTER","NOVOPROC"	,.T.		)	//Informa que a inclusão será feita com um novo número de processo
			oModelMov:SetValue( "MASTER","E5_CAMPOS"	,cCamposE5	)	//Informa os campos da SE5 que serão gravados indepentes de FK5

			oSubFKA := oModelMov:GetModel( "FKADETAIL" )
			oSubFKA:SetValue( 'FKA_IDORIG', FWUUIDV4() )
			oSubFKA:SetValue( 'FKA_TABORI', "FK5" )

			//Informacoes do movimento
			oSubFK5 := oModelMov:GetModel( "FK5DETAIL" )

			oSubFK5:SetValue( "FK5_IDDOC"	,cChaveFK7 )
			oSubFK5:SetValue( "FK5_ORIGEM"	,FunName() )
			oSubFK5:SetValue( "FK5_DATA"	,dBaixa )
			oSubFK5:SetValue( "FK5_VALOR"	,nOutrDesp )
			oSubFK5:SetValue( "FK5_RECPAG"	,"P" )
			oSubFK5:SetValue( "FK5_DTDISP"	,dDataCred )
			oSubFK5:SetValue( "FK5_BANCO"	,SA6->A6_COD )
			oSubFK5:SetValue( "FK5_AGENCI"	,SA6->A6_AGENCIA )
			oSubFK5:SetValue( "FK5_CONTA"	,SA6->A6_NUMCON )
			oSubFK5:SetValue( "FK5_NATURE"	,If(!Empty(cNat),cNat,SE1 -> E1_NATUREZ)	)
			oSubFK5:SetValue( "FK5_TPDOC"	,"OD"	)
			oSubFK5:SetValue( "FK5_LOTE"	,cLoteDB )
			oSubFK5:SetValue( "FK5_MOEDA"	,StrZero(SE1->E1_MOEDA,2) )
			oSubFK5:SetValue( "FK5_FILORI"	,cFilAnt )
			oSubFK5:SetValue( "FK5_HISTOR"	,cHistorDB )

			If SpbInUse()
				oSubFK5:SetValue( "FK5_MODSPB", "1" )
			Endif
			If nTotOutD # Nil
				oSubFK5:SetValue( "FK5_BANCO"	,SA6->A6_COD )
				oSubFK5:SetValue( "FK5_AGENCI"	,SA6->A6_AGENCIA )
				oSubFK5:SetValue( "FK5_CONTA"	,SA6->A6_NUMCON )
			Else
				//Dados do Movimento
				oSubFK5:SetValue( "FK5_BANCO"	, If(!Empty(SE1->E1_PORTADO), SE1->E1_PORTADO, SA6->A6_COD     ))
				oSubFK5:SetValue( "FK5_AGENCI"	, If(!Empty(SE1->E1_AGEDEP) , SE1->E1_AGEDEP , SA6->A6_AGENCIA ))
				oSubFK5:SetValue( "FK5_CONTA"	, If(!Empty(SE1->E1_CONTA)  , SE1->E1_CONTA  , SA6->A6_NUMCON  ))
				oSubFK5:SetValue( "FK5_DTDISP"	,dDataCred )
			EndIf

			If oModelMov:VldData()
				oModelMov:CommitData()
				SE5->(dbGoto(oModelMov:GetValue( "MASTER", "E5_RECNO" )))
			Else
				lRet := .F.
				cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
				cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
				cLog += cValToChar(oModelMov:GetErrorMessage()[6])

				Help( ,,"M_200TRFOD",,cLog, 1, 0 )
			Endif
			oModelMov:DeActivate()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ PONTO DE ENTRADA F200DB2                                    ³
			//³ Serve para tratamento complementar de outras despesas.      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF ExistBlock("F200DB2")
				ExecBlock("F200DB2",.F.,.F.)
			Endif

			AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DATA,SE5->E5_VALOR,"-")

			If !lCabec .and. lPadrao .and. lContabiliza
				nHdlPrv := HeadProva( cLote,;
				"FINA200",;
				substr( cUsuario, 7, 6 ),;
				@cArquivo )

				lCabec := .T.
			Endif

			dbSelectArea("SE5")
			If lCabec .and. lPadrao .and. lContabiliza

				If lUsaFlag // Armazena em aFlagCTB para atualizar no modulo Contabil
					aAdd( aFlagCTB, { "E5_LA", "S", "SE5", SE5->( RecNo() ), 0, 0, 0} )
				EndIf

				nTotal += DetProva( nHdlPrv,;
				"562",;
				"FINA200" /*cPrograma*/,;
				cLote,;
				/*nLinha*/,;
				/*lExecuta*/,;
				/*cCriterio*/,;
				/*lRateio*/,;
				/*cChaveBusca*/,;
				/*aCT5*/,;
				/*lPosiciona*/,;
				@aFlagCTB,;
				/*aTabRecOri*/,;
				/*aDadosProva*/ )

				If LanceiCtb .And. !lUsaFlag

					//Recarrega o Model de movimento bancário para atualizar o flag de contabilizacao
					oModelMov := FWLoadModel("FINM030")
					oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
					oModelMov:Activate()
					oModelMov:SetValue( "MASTER", "E5_GRV", .T. )

					//Posiciona a FKA com base no IDORIG da SE5 posicionada
					oSubFKA := oModelMov:GetModel( "FKADETAIL" )
					If oSubFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )

						oSubFK5 := oModelMov:GetModel( "FK5DETAIL" )
						oSubFK5:SetValue( "FK5_LA", "S" )

						If oModelMov:VldData()
							oModelMov:CommitData()
						Else
							lRet := .F.
							cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
							cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
							cLog += cValToChar(oModelMov:GetErrorMessage()[6])
							Help( ,,"M_200TRFODC",,cLog, 1, 0 )
						Endif
					Endif
					oModelMov:DeActivate()
				EndIf

			Endif
			nCtDesp += nOutrDesp
		Endif
		dbSelectArea(cAlias)
	Endif

Return .T.

/*/
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fA200Outro³ Autor ³ Wagner Xavier         ³ Data ³ 26/05/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Trata uma determinada tarifa.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fa200Tarifa( )                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fa200Outros( nTotValcc )

	Local cAlias		:= Alias()
	Local lPadrao		:= VerPadrao("563")		// Movimentacao Banc ria a Receber
	Local lContabiliza	:= Iif(mv_par11==1,.T.,.F.)
	Local cNat			:= ""
	Local nX			:= 0
	Local oModelMov		:= Nil //Model de Movimento
	Local oSubFK1		:= Nil
	Local oSubFK5		:= Nil
	Local oSubFKA		:= ""
	Local cLog			:= ""
	Local lRet			:= .T.
	Local cCamposE5		:= ""
	Local cChaveTit		:= ""
	Local cHistorDB		:= ""
	Local cChaveFK7 	:= ""


	nValCC := If(nTotValCC = Nil, nValCC, nTotValCC)

	If nValCC > 0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula a data de credito, se esta estiver vazia			³
		//³ Se aplica apenas nos casos de confirma‡Æo de entrada do	³
		//³ titulo e tenha lancamento de Despesas Banc rias, pois 	³
		//³ nas ocorrencias de baixa, essa data ja estara calculada ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If dDataCred == Nil .Or. Empty(dDataCred)
			dDataCred := If(!Empty(dBaixa),dBaixa,SE5->E5_DATA)  // Assume a data da baixa ou a data do movimento totalizador
			dBaixa := If(!Empty(dBaixa),dBaixa,SE5->E5_DATA)
			For nX := 1 To Sa6->A6_Retenca // Para todos os dias de retencao
				// valida a data
				// O calculo eh feito desta forma, pois os dias de retencao
				// sao dias uteis, e se fosse apenas somado dDataCred+A6_Retenca
				// nao sera verdadeiro quando a data for em uma quinta-feira, por
				// exemplo e, tiver 2 dias de retencao.
				dDataCred := DataValida(dDataCred+1,.T.)
			Next
		EndIf

		// Gera registro na movimentacao bancaria
		// Outros Creditos
		cNat := F200VerNat()

		//Define os campos que não existem na FK5 e que serão gravados apenas na E5, para que a gravação da E5 continue igual
		//Estrutura para o E5_CAMPOS: "{{'SE5->CAMPO', Valor}, {'SE5->CAMPO', Valor}}"
		cCamposE5 := "{"
		cCamposE5 += "{'E5_DTDIGIT'	,STOD('" + DTOS(dDataBase) + "')}"
		cCamposE5 += ",{'E5_MOTBX'	,'NOR'		}"
		If nTotValCC # Nil
			cCamposE5 += ",{'E5_LOTE'	,'" + cLoteFin	 + "'}"
			cHistorDB := "Baixa por Retorno CNAB / Lote :" + " " + cLoteFin	//"Baixa por Retorno CNAB / Lote :"
			cChaveFK7 := ""
		Else
			cCamposE5 += ",{'E5_PREFIXO','" + SE1->E1_PREFIXO	+ "'}"
			cCamposE5 += ",{'E5_NUMERO'	,'" + SE1->E1_NUM		+ "'}"
			cCamposE5 += ",{'E5_PARCELA','" + SE1->E1_PARCELA	+ "'}"
			cCamposE5 += ",{'E5_TIPO'	,'" + SE1->E1_TIPO		+ "'}"
			cCamposE5 += ",{'E5_CLIFOR'	,'" + SE1->E1_CLIENTE	+ "'}"
			cCamposE5 += ",{'E5_LOJA'	,'" + SE1->E1_LOJA		+ "'}"
			cHistorDB := SEB->EB_DESCRI
			//Dados da tabela auxiliar com o código do título a receber
			cChaveTit := xFilial("SE1") + "|" + SE1->E1_PREFIXO + "|" + SE1->E1_NUM 	+ "|" + SE1->E1_PARCELA + "|" + ;
			SE1->E1_TIPO    + "|" + SE1->E1_CLIENTE + "|" + SE1->E1_LOJA
			cChaveFK7 := FINGRVFK7( "SE1", cChaveTit )
		EndIf
		cCamposE5 += "}"

		oModelMov := FWLoadModel("FINM030")							//Model de Movimento Bancario
		oModelMov:SetOperation( MODEL_OPERATION_INSERT )			//Inclusao
		oModelMov:Activate()											//Ativa o modelo de dados
		oModelMov:SetValue( "MASTER","E5_GRV"		,.T.		)	//Informa se vai gravar SE5 ou não
		oModelMov:SetValue( "MASTER","NOVOPROC"		,.T.		)	//Informa que a inclusão será feita com um novo número de processo
		oModelMov:SetValue( "MASTER","E5_CAMPOS"	,cCamposE5	)	//Informa os campos da SE5 que serão gravados indepentes de FK5

		oSubFKA := oModelMov:GetModel("FKADETAIL")
		oSubFKA:SetValue( "FKA_IDORIG", FWUUIDV4() )
		oSubFKA:SetValue( "FKA_TABORI", "FK5" )

		//Informacoes do movimento
		oSubFK5 := oModelMov:GetModel( "FK5DETAIL" )
		oSubFK5:SetValue( "FK5_IDDOC"	,cChaveFK7 )
		oSubFK5:SetValue( "FK5_ORIGEM"	,FunName() )
		oSubFK5:SetValue( "FK5_DATA"	,dBaixa )
		oSubFK5:SetValue( "FK5_VALOR"	,nValcc )
		oSubFK5:SetValue( "FK5_RECPAG"	,"R" )
		oSubFK5:SetValue( "FK5_BANCO"	,SA6->A6_COD )
		oSubFK5:SetValue( "FK5_AGENCI"	,SA6->A6_AGENCIA )
		oSubFK5:SetValue( "FK5_CONTA"	,SA6->A6_NUMCON )
		oSubFK5:SetValue( "FK5_DTDISP"	,dDataCred )
		oSubFK5:SetValue( "FK5_NATURE"	,If(!Empty(cNat),cNat,SE1 -> E1_NATUREZ)	)
		oSubFK5:SetValue( "FK5_MOEDA"	,StrZero(SE1->E1_MOEDA,2))
		oSubFK5:SetValue( "FK5_TPDOC"	,"DB"	)
		oSubFK5:SetValue( "FK5_FILORI"	,cFilAnt )
		oSubFK5:SetValue( "FK5_HISTOR"	,cHistorDB )
		If SpbInUse()
			oSubFK5:SetValue( "FK5_MODSPB", "1" )
		Endif

		If oModelMov:VldData()
			oModelMov:CommitData()
			SE5->(dbGoto(oModelMov:GetValue( "MASTER", "E5_RECNO" )))
			oModelMov:DeActivate()
		Else
			lRet := .F.
			cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
			cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
			cLog += cValToChar(oModelMov:GetErrorMessage()[6])
			oModelMov:DeActivate()
			Help( ,,"F200OUTCRD",,cLog, 1, 0 )
		Endif


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ PONTO DE ENTRADA F200OCR                                    ³
		//³ Serve para tratamento complementar de outros creditos.      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF ExistBlock("F200OCR")
			ExecBlock("F200OCR",.F.,.F.)
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza saldo bancario.      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AtuSalBco(cBanco,cAgencia,cConta,dBaixa,nValcc,"+")

		If !lCabec .and. lPadrao .and. lContabiliza
			nHdlPrv := HeadProva( cLote,;
			"FINA200",;
			substr( cUsuario, 7, 6 ),;
			@cArquivo )

			lCabec := .T.
		Endif

		dbSelectArea("SE5")

		If lCabec .and. lPadrao .and. lContabiliza
			If lUsaFlag // Armazena em aFlagCTB para atualizar no modulo Contabil
				aAdd( aFlagCTB, { "E5_LA", "S", "SE5", SE5->( RecNo() ), 0, 0, 0} )
			EndIf
			nTotal += DetProva( nHdlPrv,;
			"563",;
			"FINA200" /*cPrograma*/,;
			cLote,;
			/*nLinha*/,;
			/*lExecuta*/,;
			/*cCriterio*/,;
			/*lRateio*/,;
			/*cChaveBusca*/,;
			/*aCT5*/,;
			/*lPosiciona*/,;
			@aFlagCTB,;
			/*aTabRecOri*/,;
			/*aDadosProva*/ )

			If LanceiCtb .And. !lUsaFlag

				oModelMov := FWLoadModel("FINM030") //Recarrega o Model de movimentos
				oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
				oModelMov:Activate()
				oModelMov:SetValue( "MASTER", "E5_GRV", .T. )

				//Posiciona a FKA com base no IDORIG da SE5 posicionada
				oSubFKA := oModelMov:GetModel( "FKADETAIL" )
				If oSubFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )

					oSubFK5 := oModelMov:GetModel( "FK5DETAIL" )

					oSubFK5:SetValue( "FK5_LA", "S" )

					If oModelMov:VldData()
						oModelMov:CommitData()
					Else
						lRet := .F.
						cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
						cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
						cLog += cValToChar(oModelMov:GetErrorMessage()[6])
						Help( ,,"M030_Fa200Outros",,cLog, 1, 0 )
					Endif
				EndIf
				oModelMov:DeActivate()
			EndIf
		Endif
		nCtOutCrd := nValcc
		dbSelectArea( cAlias )
	Endif

Return .T.

/*/
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fa200Recic³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 22/05/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Cria o arquivo de reciclagem                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fa200Recic( )	                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa200Recic()
	Local nTempNnum := TamSX3("E1_NUMBCO")[1]
	Local cDbf , aCampos
	cDbf := "RECICL" + SubStr(cNumEmp,1,2)

	If !File(cDbf+GetDBExtension())
		aCampos:={ {"FILIAL  ","C",IIf( lFWCodFil, FWGETTAMFILIAL, 2 ),0},;
		{"NOSSONUM","C",nTempNnum,0}}
		If (Select("cTemp") <> 0 )
			dbSelectArea ( "cTemp" )
			dbCloseArea ()
		Endif
		dbCreate(cDbf,aCampos)
		dbUseArea(.T.,,cDbf,"cTemp",NIL,.F.)
	Endif

	dbUseArea(.T.,,cDbf,"cTemp",NIL,.F.)
	IndRegua("cTemp",cDbf,"FILIAL+NOSSONUM",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
Return

/*/
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fa200GrRec³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 22/05/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Grava registros no arquivo de reciclagem                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fa200GrRec( )	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa200GrRec(cNsNum)
	Local cAlias := Alias()
	dbSelectArea("cTemp")
	If !dbSeek(xFilial("SE1")+cNsNum)
		RecLock("cTemp",.T.)
		Replace FILIAL		With xFilial("SE1")
		Replace NOSSONUM 	With cNsNum
		MsUnlock()
	EndIf
	dbSelectArea(cAlias)
Return

/*/
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa200ChecF³ Autor ³ Pilar S Albaladejo    ³ Data ³ 22/05/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna Expresao para Indice Condicional					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³Fa200ChecF() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³Generico													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA200ChecF()
	Local cFiltro := ""
	cFiltro := 'E1_FILIAL == "'+xFilial("SE1")+'" .And. E1_SALDO > 0'
Return cFiltro

/*/
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Chk200File³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 24/11/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Checa se arquivo de TB j  foi processado anteriormente	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³Chk200File()  											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³Fina200													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Chk200File()
	LOCAL cFile := "TB"+cNumEmp+".VRF"
	LOCAL lRet	:= .F.
	LOCAL aFiles:= {}
	LOCAL cString
	LOCAL nTam
	LOCAL nHdlFile

	If !FILE(cFile)
		nHdlFile := fCreate(cFile)
	ELSE
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tenta abrir o arquivo em modo exclusivo e Leitura/Gravacao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While (nHdlFile := fOpen(cFile,FO_READWRITE+FO_EXCLUSIVE))==-1 .AND. ;
		if(ExecSchedule(),.T.,MsgYesNo( "Retorno Automatico via Job"+cNumEmp, "AVISO" )) // Retorno Automatico via Job - parametro que controla execucao via Job
		Enddo
	Endif

	If nHdlFile > 0

		nTam := TamSx1("AFI200","04")[1] // Tamanho do parametro
		xBuffer := SPACE(nTam)
		// Le o arquivo e adiciona na matriz
		While fReadLn(nHdlFile,@xBuffer,nTam)
			Aadd(aFiles, Trim(xBuffer))
		Enddo

		If ASCAN(aFiles,Trim(MV_PAR04)) > 0
			Help(" ",1,"CHK200FILE")       // Arquivo de Trans.Banc. j  processado

			// Retorno Automatico via Job
			if ExecSchedule()
				Aadd(aMsgSch, STR0024+cFile+STR0034) // "Arquivo de entrada " # " processado anteriormente."
			Endif
		Else
			fSeek(nHdlFile,0,2) // Posiciona no final do arquivo
			cString := Alltrim(mv_par04)+Chr(13)+Chr(10)
			fWrite(nHdlFile,cString)	// Grava nome do arquivo a ser processado
			lRet := .T.
		endif
		fClose (nHdlFile)
	Else
		Help(" ", 1, "CHK200ERRO") // Erro na leitura do arquivo de entrada

		// Retorno Automatico via Job
		if ExecSchedule()
			Aadd(aMsgSch, STR0035+cFile) // "Erro na abertura/leitura do Arquivo "
		Endif
	EndIf
Return lRet

/*/
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa200GrvLog³ Autor ³ Claudio Donizete      ³ Data ³ 25/07/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Grava LOG de processamento do arquivo retorno				   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³Fa200GrvLog   											   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³Fina200													   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa200GrvLog(nTipo, cArquivo, cBanco, cAgencia, cConta, nLastLn, cIdTit,;
	cOcoBco, cOcoSis, cIdArq)
	Local cSeq := "00"
	Local lRet := .T.
	Local nLastRec
	Local cBarra	:= If(isSrvUnix(),"/","\")
	Local nBarra 	:= Rat(cBarra,cArquivo)
	Local aUsuario

	// Obtem o nome do arquivo apenas, desprezando o path
	cArquivo := If(nBarra > 0, SubStr(cArquivo,nBarra+1), cArquivo)
	cIdArq := VercIdArq(cIdArq, cArquivo) //verifica se o ID já foi usado anteriormente

	If nTipo == 1 // Cabecalho
		// Se o arquivo ja foi processado, a ultima linha sera a ultima
		// gravada no arquivo
		If FI0->(MsSeek(xFilial("FI0")+Pad(cIdArq,Len(FI0_IDARQ))+cBanco+cAgencia+cConta))
			While FI0->(FI0_FILIAL+Pad(FI0_IDARQ,Len(FI0_IDARQ))+FI0_BCO+FI0_AGE+FI0_CTA) == xFilial("FI0")+Pad(cIdArq,Len(FI0->FI0_IDARQ))+cBanco+cAgencia+cConta
				nLastLn	:= FI0->FI0_LASTLN
				cSeq	  	:= FI0->FI0_SEQ
				nLastRec := FI0->(Recno())
				FI0->(DbSkip())
			End
			FI0->(MsGoto(nLastRec))
			PswOrder(1)

			// caso de usuario excluido estava dando errorlog
			if PswSeek(FI0->FI0_USU)
				aUsuario := PswRet()
				cNomeUsuario := Alltrim(aUsuario[1][2])
			Else
				cNomeUsuario := FI0->FI0_USU
			Endif

			// se estiver em modo Job nao apresenta a mensagem e sempre reprocessa
			lRet := (ExecSchedule() .or. ApMsgYesNo("Arquivo retorno já processado anteriormente em " +;
			DTOC(FI0->FI0_DTPRC) + " às " + FI0->FI0_HRPRC + Chr(13)+Chr(10)+;
			"Processado com o nome : " + AllTrim(FI0->FI0_ARQ)+ Chr(13)+Chr(10)+ ;
			"Usuário que processou : " + cNomeUsuario+ Chr(13)+Chr(10)+;
			"A ultima linha lida do arquivo foi: " +	Transform(FI0->FI0_LASTLN, "")+ Chr(13)+Chr(10) +;
			"O arquivo já foi processado " + Str(Val(FI0->FI0_SEQ),3) +;
			If(Val(FI0->FI0_SEQ)<=1," vez", " vezes")+". Deseja  reprocessá-lo?"))

			// Retorno Automatico via Job
			if ExecSchedule()
				Aadd(aMsgSch, "Arquivo retorno já processado anteriormente em " +;
				DTOC(FI0->FI0_DTPRC) + " às " + FI0->FI0_HRPRC +;
				". Processado com o nome : " + AllTrim(FI0->FI0_ARQ)+ ;
				". A ultima linha lida do arquivo foi: " + Transform(FI0->FI0_LASTLN, "")+;
				". Verifique.")
				lRet := .F.
			Endif
		Endif
		If lRet
			RecLock("FI0", .T.)
			FI0->FI0_FILIAL	:= xFilial("FI0")
			FI0->FI0_ARQ		:= cArquivo
			FI0->FI0_IDARQ		:= cIdArq
			FI0->FI0_DTPRC		:= dDataBase
			FI0->FI0_HRPRC		:= Left(Time(), 6) // Grava a HH:MM do processamento
			FI0->FI0_BCO		:= cBanco
			FI0->FI0_AGE		:= cAgencia
			FI0->FI0_CTA		:= cConta
			FI0->FI0_USU		:= RetCodUsr()
			FI0->FI0_LASTLN		:= nLastLn
			FI0->FI0_SEQ		:= Soma1(cSeq)
			FI0->( Dbunlock())
			FKCOMMIT()
		Endif
	Elseif nTipo == 2 // Detalhe dos titulos processados
		RecLock("FI1", .T.)
		FI1->FI1_FILIAL		:= xFilial("FI1")
		FI1->FI1_IDARQ		:= cIdArq
		FI1->FI1_IDTIT		:= cIdTit
		FI1->FI1_OCORB		:= cOcoBco
		FI1->FI1_OCORS		:= cOcoSis
		FI1->FI1_SEQ	:= FI0->FI0_SEQ
		FI1->( Dbunlock())
		FKCOMMIT()
	Endif

Return lRet

/*/
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³LeTrailler | Autor ³ Claudio Donizete      ³ Data ³ 18/08/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Le as ultimas linhas do arquivo texto para gerar checksum		|±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³LeTrailler(nHdlBco)										   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³Fina200													   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LeTrailler(nHdlBco)
	Local cRet		:= ""
	Local cBuffer	:= Space(402)
	Local nOffSet	:= fSeek(nHdlBco,0,FS_RELATIVE) // Sera utilizado para retornar o ponteiro do arquivo a posicao original
	Local nTamArq	:= fSeek(nHdlBco,0,FS_END) // Obtem o tamanho do arquivo

	fSeek(nHdlBco,-804,FS_END) // Volta 804 bytes para compor o CheckSum

	// Le o arquivo ate final
	While fReadLn(nHdlBco,@cBuffer,402)
		cRet += cBuffer
	End

	fSeek(nHdlBco,nOffSet,FS_SET) // Retorna o ponteiro para a posicao original

Return cRet+Transform(nTamArq,"")

/*/
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa200ChkSum| Autor ³ Claudio Donizete      ³ Data ³ 18/08/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna sequencia numerica a partir da string enviada		   |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³Fa200ChkSum(cBuffer)											³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³Fina200													   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa200ChkSum(cBuffer)
	Local nX
	Local nCheck	:= 0
	Local nLen		:= Len(cBuffer)
	Local nPeso		:= 9
	Local nDgVrf

	For nX := 1 To nLen
		// Para cada byte da string, sera atribuido um peso (iniciando de 9 ate 2)
		nCheck += (Asc(SubStr(cBuffer,nX,1)) * nPeso)
		nPeso--
		If nPeso == 2
			nPeso := 9
		Endif
	Next

	// Calcula digito verificador para checksum
	nDgVrf := ((nCheck + nX) % 11)
	nDgVrf := If(nDgVrf > 9 .Or. nDgVrf == 0, 1, nDgVrf)

Return AllTrim(Transform(nCheck,"")) + Transform(nDgVrf,"")


/*/
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Ana Paula N. Silva     ³ Data ³23/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³	  1 - Pesquisa e Posiciona em um Banco de Dados     	  ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MenuDef()
	Local aRotina:= { {OemToAnsi("Parametros") ,"fA200Par" , 0 , 1},;  // "Parametros"
	{OemToAnsi("Visualizar") ,"AxVisual" , 0 , 2},;  // "Visualizar"
	{OemToAnsi("Receber Arquivo") ,"U_fA200Gera()", 0 , 3} }  // "Receber Arquivo"
Return(aRotina)



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FinA200T   ³ Autor ³ Marcelo Celi Marques ³ Data ³ 31.03.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada semi-automatica utilizado pelo gestor financeiro   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FinA200T(aParam)
	cRotinaExec := "FINA200"
	ReCreateBrow("SE1",FinWindow)
	FinA200(aParam[1])
	ReCreateBrow("SE1",FinWindow)

	dbSelectArea("SE1")

	INCLUI := .F.
	ALTERA := .F.

Return .T.


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³F200TrfCob ³ Autor ³ Mauricio Pequim Jr.  ³ Data ³ 31.03.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gravação das transferencias dos titulos                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function F200TrfCob(cOcorr,cBanco,cAgencia,cConta)

	Local aArea		:= GetArea()
	Local nJ		:= 0
	Local cPadrao2	:="540"
	Local cChavEA	:= xFilial("SEA")+E1_NUMBOR+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	Local cSituAnt  := SE1->E1_SITUACA
	Local lPadrao2	:= .F.
	Local lContabiliza := Iif(mv_par11==1,.T.,.F.)
	Local cSituacao := "0"
	Local l060SEA   := ExistBlock("F060SEA")
	Local cLstCart	:= FN022LSTCB(1)	//Lista de Situacoes de cobranca - Carteira
	Local cLstBanco	:= FN022LSTCB(3)	//Lista de Situacoes de cobranca - com portador (banco)
	Local cLstProt	:= FN022LSTCB(4)	//Lista de Situacoes de cobranca - Protesto


	DEFAULT cOcorr  := ""
	DEFAULT cBanco	:= ""
	DEFAULT cAgencia:= ""
	DEFAULT cConta	:= ""

	If !Empty (cOcorr)

		//Obtenho a nova situacao do titulo
		cSituacao := SUBSTR(cOcorr,2,1)

		//Alteracao para Cobrança Protesto (6) ou Carteira Protesto (F)
		//Atualiza numero de titulos protestados
		IF ( cSituacao $ cLstProt )  .and. !( cSituAnt $ cLstProt )
			dbSelectArea("SA1")
			If (dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
				Reclock("SA1")
				SA1->A1_TITPROT := A1_TITPROT+1
				SA1->A1_DTULTIT := dDataBase
				MsUnlock()
			Endif
			dbSelectArea("SE1")
		Endif

		//Retirada de protesto
		//Alteracao da Cobrança Protesto(6) ou Carteira Protesto(F) para Carteira(0) ou Carteira Acordo(G)
		IF ( (cSituacao $ cLstCart ) .and. !(cSituacao $ cLstProt) ) .and. (SE1->E1_SITUACA $ cLstProt)
			dbSelectArea("SA1")
			If (dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
				Reclock("SA1")
				SA1->A1_TITPROT := A1_TITPROT-1
				MsUnlock( )
			Endif
			dbSelectArea("SE1")
		Endif

		//Transferencia para cobranca bancaria
		IF cSituacao $ cLstBanco .and. cSituacao != cSituAnt
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza data vencto real c/reten‡„o Banc ria³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// Se possuir retencao bancaria, grava a data de vencimento
			IF mv_par15 == 1 .And. nRetencao>0
				dBase	:=	SE1->E1_VENCREA
				For nj:=1 To nRetencao
					dBase := DataValida(dBase+1,.T.)
				Next nj
				Reclock("SE1")
				SE1->E1_VENCREA := dBase
				MsUnlock()
				// Atualiza tambem os registros agregados
				F060AtuAgre()
			EndIF
		EndIF

		//Transferindo o titulo que estava em banco para a carteira
		IF cSituacao $ cLstCart .and. cSituAnt $ cLstBanco
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza data vencto real s/reten‡„o Banc ria³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// Se considera retencao bancaria
			If mv_par15 == 1
				Reclock("SE1")
				SE1->E1_VENCREA := DataValida(E1_VENCORI,.T.)
				If SE1->E1_VENCREA < SE1->E1_VENCTO
					SE1->E1_VENCREA := DataValida(E1_VENCTO,.T.)
				Endif
				MsUnlock()
				// Atualiza tambem os registros agregados
				F060AtuAgre()
			EndIF
		Endif

		// Banco vazio, contabiliza anterior
		If Empty(cBanco)
			dbSelectArea("SA6")
			dbSeek(xFilial()+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA)
		Else
			dbSelectArea("SA6")
			dbSeek(xFilial()+cBanco+cAgencia+cConta)
		Endif

		FKCOMMIT()

		// Guardo portador anterior, para possivel utilizacao no LP
		VAR_IXB			 := SE1->E1_PORTADO

		If cSituacao $ cLstCart
			//Atualizo dados do titulo
			RecLock("SE1")
			SE1->E1_PORTADO := ""
			SE1->E1_AGEDEP  := ""
			SE1->E1_SITUACA := cSituacao
			SE1->E1_NUMBCO  := ""
			SE1->E1_MOVIMEN := dDataBase
			SE1->E1_CONTA	 := ""
			If cSituacao != cSituAnt .And. !Empty(SE1->E1_NUMBOR)
				SE1->E1_NUMBOR := " "
				SE1->E1_DATABOR:= Ctod("  /  /  ")
			EndIf
			FKCOMMIT()

			//Excluo do bordero (SEA) se o titulo voltou para carteira
			dbSelectArea("SEA")
			If dbSeek(cChavEA)
				RecLock("SEA",.F.,.T.)
				dbDelete()
				MsUnlock()
				SX2->(MsUnlock())
			Endif

		Else

			//Atualizo dados do titulo
			RecLock("SE1")
			SE1->E1_PORTADO := cBanco
			SE1->E1_AGEDEP  := cAgencia
			SE1->E1_SITUACA := cSituacao
			SE1->E1_NUMBCO  := cNsNum
			SE1->E1_MOVIMEN := dDataBase
			SE1->E1_CONTA	:= cConta
			FKCOMMIT()

			//Incluo no SEA se o titulo foi para cobranca
			dbSelectArea("SEA")
			If !dbSeek(cChavEA)
				RecLock("SEA",.T.)
			Else
				RecLock("SEA")
			EndIf
			SEA->EA_FILIAL  := xFilial("SEA")
			SEA->EA_DATABOR := dDataBase
			SEA->EA_PORTADO := cBanco
			SEA->EA_AGEDEP  := cAgencia
			SEA->EA_NUMCON  := cConta
			SEA->EA_SITUACA := cSituacao
			SEA->EA_NUM 	:= SE1->E1_NUM
			SEA->EA_PARCELA := SE1->E1_PARCELA
			SEA->EA_PREFIXO := SE1->E1_PREFIXO
			SEA->EA_TIPO	:= SE1->E1_TIPO
			SEA->EA_CART	:= "R"
			SEA->EA_SITUANT := cSituant
			SEA->EA_FILORIG := SE1->E1_FILIAL
			If l060SEA
				ExecBlock("F060SEA",.f.,.f.)
			Endif
			SEA->(MsUnlock())
		Endif
		FKCOMMIT()

		//Contabiliza Transferencias
		If lContabiliza .and. cSituant != SE1->E1_SITUACA
			IF FN022SITCB(cSituacao)[1]		//Carteira cSituacao $ "0|F|G"
				cPadrao:="540"
			ElseIf FN022SITCB(cSituacao)[5]	//Simples e Cartorio   cSituacao $ "1|H"
				cPadrao:="541"
			ElseIf FN022SITCB(cSituacao)[3]	//Descontada 	cSituacao $ "2|7"
				cPadrao:="542"
			ElseIf FN022SITCB(cSituacao)[4]	//Cobranca em banco com protesto
				cPadrao:="543"
			ElseIf FN022SITCB(cSituacao)[2]	//Cobranca em banco sem protesto exceto Simples e Cartorio
				cPadrao:="544"
			EndIf

			//A situacao do titulo mudou de uma cobrança para outra sem passar pela carteira
			If !(cSituacao $ cLstCart) .and. !(cSituant  $ cLstCart)
				lPadrao2:=VerPadrao(cPadrao2)
			Endif

			lPadrao:=VerPadrao(cPadrao)
			STRLCTPAD := cSituant   // Disponibiliza a situacao anterior para ser utilizada no LP
			VALOR  := 0					// para contabilizar o total descontado (PRIVATE)
			VALOR2 := 0			 		// Saldo dos titulo para contabilizacao da diferenca

			If lPadrao .and. mv_par14 == 1
				If !lCabec
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Inicializa Lancamento Contabil                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nHdlPrv := HeadProva( cLote,;
					"FINA200" /*cPrograma*/,;
					Substr( cUsuario, 7, 6 ),;
					@cArquivo )
					lCabec := .T.
				Endif

				If lCabec
					//Quando existe mudança de situacao de cobranca sem que o titulo passe pela Carteira (Situacao 0)
					//Contabilizo movimento Cobrança -> Carteira
					If lPadrao2
						nTotal += DetProva( nHdlPrv,;
						cPadrao2,;
						"FINA200" /*cPrograma*/,;
						cLote,;
						/*nLinha*/,;
						/*lExecuta*/,;
						/*cCriterio*/,;
						/*lRateio*/,;
						/*cChaveBusca*/,;
						/*aCT5*/,;
						/*lPosiciona*/,;
						/*@aFlagCTB*/,;
						/*aTabRecOri*/,;
						/*aDadosProva*/ )
					Endif

					//Contabilizo movimento Carteira -> Cobrança
					nTotal += DetProva( nHdlPrv,;
					cPadrao,;
					"FINA200" /*cPrograma*/,;
					cLote,;
					/*nLinha*/,;
					/*lExecuta*/,;
					/*cCriterio*/,;
					/*lRateio*/,;
					/*cChaveBusca*/,;
					/*aCT5*/,;
					/*lPosiciona*/,;
					/*@aFlagCTB*/,;
					/*aTabRecOri*/,;
					/*aDadosProva*/ )
				Endif
			Endif
		EndIf

	Endif

	RestArea(aArea)


Return


/*|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ExecSchedule³ Autor ³ Aldo Barbosa dos Santos      ³01/07/11³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Retorna se o programa esta sendo executado via schedule     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ExecSchedule()
	Local lRetorno := .T.

	lRetorno := IsBlind()

Return( lRetorno )

/*|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³LoadVlBx    ³ Autor ³ Controladoria                ³01/07/11³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LoadVlBx( nHdlBco, xBuffer, nTamDet, nValtot, nTotDesp, nTotOutD, nTotValCc, nTotAGer,aLeitura, lBxCnab)
	Local aArea		:= GetArea()
	Local cOcorr	:= ''
	Local cMotBan	:= ''

	Local nCont		:= 0
	Local nDespes	:= 0
	Local nValrec	:= 0
	Local nOutrDesp	:= 0
	Local nValCc	:= 0
	LOCAL aArqConf 	:= Directory(MV_PAR05)

	Local lSai		:= .F.

	Default aLeitura := {}
	Default lBxCnab	:= GetMv("MV_BXCNAB") == "S"

	If MV_PAR12 == 1 // modelo do CNAB (Modelo1 # Modelo2)
		IF SubStr(xBuffer,1,1) $ "1|F|J|7|2"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Lˆ os valores do arquivo Retorno ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF !Empty(cPosDesp)
				nDespes:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosDesp,1,3))),nLenDesp))/100,2)
			EndIF
			IF !Empty(cPosPrin)
				nValrec :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosPrin,1,3))),nLenPrin))/100,2)
			EndIF
			IF !Empty(cPosOutrd)
				nOutrDesp  :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosOutrd,1,3))),nLenOutrd))/100,2)
			EndIF
			IF !Empty(cPosCc)
				nValCc :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosCc,1,3))),nLenCc))/100,2)
			EndIF
			If nLenOcor == 2
				cOcorr  :=Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor) + " "
			Else
				cOcorr  :=Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor)
			EndIf
			If !Empty(cPosMot)
				cMotBan:=Substr(xBuffer,Int(Val(Substr(cPosMot,1,3))),nLenMot)
			EndIf

		Endif
	Else
		If Len(aLeitura) == 0
			aLeitura := ReadCnab2(nHdlBco,MV_PAR05,nTamDet,aArqConf)
		EndIf
		nDespes  := aLeitura[06]
		nValRec  := aLeitura[05]
		nValCC   := aLeitura[13]
		cOcorr   := PadR(aLeitura[03],3)
		cMotBan  := aLeitura[15]
	Endif

	If !Empty(cOcorr)
		dbSelectArea("SEB")
		dbSetOrder(1)
		If !(dbSeek(xFilial("SEB")+mv_par06+cOcorr+"R"))
			Help(" ",1,"FA200OCORR",,mv_par06+"-"+cOcorr+"R",4,1)

			// Retorno Automatico via Job
			if ExecSchedule()
				Aadd(aMsgSch, "Ocorrencia "+mv_par06+" "+cOcorr+" nao localizada na tabela SEB.") // "Ocorrencia " # " nao localizada na tabela SEB."
			Endif
		Endif

		IF SEB->EB_OCORR $ "03|15|16|17|40|41|42|52|53"		//Registro rejeitado
			For nCont := 1 To Len(cMotBan) Step 2
				cMotivo := Substr(cMotBan,nCont,2)
				If fa200Rejei(cMotivo,cOcorr)
					lSai := .T.
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Trata tarifas da retirada do titulo do banco	³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lBxCnab
						nTotDesp += nDespes
						nTotOutD += nOutrDesp
					Endif
					Exit
				EndIf
			Next nCont

		EndIf

		If !lSai
			If SEB->EB_OCORR $ "06|07|08|36|37|38|39"		//Baixa do Titulo
				DbSelectArea( "FI1" )
				DbSetOrder(1)
				FI1->(dbSeek(xFilial("FI1")+ SE1->E1_NUM ))
				If SE1->E1_NUM == FI1->FI1_IDTIT
					nValtot 	+= nValrec+If(SEE->EE_DESPCRD == "S",nDespes + nOutrDesp - nValCC,0)
				EndIf
				nTotDesp 	+= nDespes
				nTotOutD 	+= nOutrDesp
				nTotValCc 	+= nValCC
				nTotAGer	+= nValrec+If(SEE->EE_DESPCRD == "S",nDespes + nOutrDesp - nValCC,0)
			EndIf
		Endif
	Endif

	RestArea( aArea )

Return



//-----------------------------------------------------------------------------------------
/*/
{Protheus.doc} F200VerNat
Verifica a natureza de despesas bancárias

@author pequim

@since 26/09/2014
@version 1.0
/*/
//-----------------------------------------------------------------------------------------

Static Function F200VerNat()

	Local cNatureza := ""
	Local aArea := GetArea()

	lVerifNat := .T.

	nTamNat := TamSX3("FK5_NATURE")[1]

	cNatureza := &(GetMv("MV_NATDPBC"))
	cNatureza := Padr(cNatureza,nTamNat)

	SED->(dbSetOrder(1))
	If SED->(!(MsSeek(xFilial("SED")+cNatureza)))
		RecLock("SED",.T.)
		SED->ED_FILIAL  := xFilial("SED")
		SED->ED_CODIGO  := cNatureza
		SED->ED_CALCIRF := "N"
		SED->ED_CALCISS := "N"
		SED->ED_CALCINS := "N"
		SED->ED_CALCCSL := "N"
		SED->ED_CALCCOF := "N"
		SED->ED_CALCPIS := "N"
		SED->ED_DESCRIC := "Despesas Bancárias - CNAB" //"Despesas Bancárias - CNAB"
		SED->ED_TIPO	:= "2"
		MsUnlock()
		FKCOMMIT()
	Endif

	RestArea(aArea)

Return cNatureza


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³VercIdArq³ Autor ³ Rodrigo Alexandre de Oliveira   ³10/02/15³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Retorna a Práxima numeração válida para o cIdArq            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VercIdArq(cIdArq, cArquivo)

	Local cQuery		:= ""
	Local aArea		:= GetArea()
	Local aAreaFI0	:= FI0->(GetArea())
	Local cAliasQry 	:= GetNextAlias()

	cQuery := "select FI0_ARQ, FI0_IDARQ "
	cQuery += " from "  + RetSqlName("FI0") + " FI0 "
	cQuery += " where FI0_IDARQ = '" +  PadL(cIdArq,Len(FI0->FI0_IDARQ)) + "' "
	cQuery += " and D_E_L_E_T_ = '' "
	cQuery += " group by FI0_ARQ, FI0_IDARQ "

	cQuery := ChangeQuery(cQuery)

	dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , "cAliasQry" , .T. , .T. )

	If !Empty(cAliasQry->FI0_IDARQ)

		While Alltrim(cAliasQry->FI0_ARQ) != Alltrim(cArquivo) .And. cAliasQry->(!Eof())

			cIdArq := PadL(Soma1(Alltrim(cIdArq)),Len(FI0->FI0_IDARQ))

			DbSelectArea("FI0")
			DbSetOrder(2)
			If MsSeek(xFilial("FI0") + cBanco + cAgencia + cConta + Pad(cArquivo,Len(FI0->FI0_ARQ)))
				If AllTrim(cIdArq) == AllTrim(FI0->FI0_IDARQ)
					cAliasQry->(DbSkip())
					Loop
				ElseIf Val(FI0->FI0_IDARQ) > Val(cIdArq)
					Loop
				Else
					cAliasQry->(DbSkip())
					Loop
				End
			Else // Evita um loop no caso de compartilhamento da FI0 diferente
				cAliasQry->(DbSkip())
				Loop
			End
			DbSkip()
		EndDo
	EndIf
	cAliasQry->(DbCloseArea())

	RestArea(aArea)
	RestArea(aAreaFI0)

Return( cIdArq )
