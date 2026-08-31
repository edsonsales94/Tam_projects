#include "Protheus.ch"        // incluido pelo assistente de conversao do AP5 IDE em 09/08/00

User Function Duppel()        // incluido pelo assistente de conversao do AP5 IDE em 09/08/00

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
	SetPrvt("NLASTKEY,CPERG,LI,M_PAG,WNREL,MCOND")
	SetPrvt("MVALP1,CFATURA,CPREFIXO")
	SetPrvt("NVALNOTA,NREG,MEXTENSO,NLIN,EXTENSO1,EXTENSO2")
	SetPrvt("TAM1,TAM2,NDIFER,")

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ DUPPEL   ³ Autor ³ Ronilton O. Barros    ³ Data ³ 20/09/96 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Emissao Duplicata para uso com RDMAKE.                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Gen‚rico                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	titulo   := "EMISSAO DE DUPLICATA"
	cDesc1   := OemToAnsi("Este programa ir  emitir as Duplicatas da Industria")
	cDesc2   := OemToAnsi("utilizando recursos do SIGA Advanced.")
	cDesc3   := OemToAnsi("")
	cString  := "SE1"
	aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
	nLastKey := 0
	cPerg    := PADR("DUPPEL",LEN(SX1->X1_GRUPO))
	li       := -8
	m_pag    := 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas, busca o padrao da NFPARV ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	pergunte(CPERG,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01             // Da Duplicata                         ³
	//³ mv_par02             // At‚ a Duplicata                      ³ 
	//³ mv_par03             // Serie                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := SetPrint(cString,"DUPPEL",cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"")

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	RptStatus({|| Corpo2() })
Return

Static Function Corpo2()
	Local c, x
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³E1_PARCELA ser  criticado enquanto ¤ tiver formul rio cont¡nuo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	vBanco := { "001", "003", "237", "341", "347", "356", "399", "409", "453"}
	nOk   := 1  // 1 = Senha nao digitada ; 2 = Senha digitada correta ; 3 = Senha errada
	mCond :=.T.
	dbSelectArea("SE1")
	dbSetOrder(1)
	dbSeek(XFILIAL("SE1")+mv_par03+mv_par01,.T.)
	SetRegua(RecCount())
	While ! Eof() .And. E1_NUM <= mv_par02 .And. XFILIAL("SE1") == E1_FILIAL
		nPos   := 0 //Ascan(vBanco,E1_PORTADO)
		cDupli := E1_PREFIXO+E1_NUM
		While ! Eof() .And. E1_NUM <= mv_par02 .And. XFILIAL("SE1") == E1_FILIAL .And.;
		cDupli == E1_PREFIXO+E1_NUM

			IncRegua()

			If (!Empty(mv_par04) .And. E1_PARCELA <> mv_par04) .Or. E1_PREFIXO <> mv_par03
				dbSkip()
				Loop
			Endif

			If FieldPos("E1_DATIMP") > 0  // Verifica se o campo existe no SE1
				If !Empty(E1_DATIMP) // Verifica se a duplicata ainda nao foi impressa
					If nOk <> 2 .And. If( nOk == 1 , nOk := PegaSenha(), nOk) == 3
						dbSkip()
						Loop
					Endif
				Endif

				RecLock("SE1",.F.)
				SE1->E1_DATIMP := dDataBase
				MsUnLock()
			Endif

			dbSelectArea("SF2")
			dbSetOrder(1)
			dbSeek(XFILIAL("SF2")+SE1->E1_NUM+SE1->E1_PREFIXO)
			dbSelectArea("SE1")
			li       += 14
			mValp1   := E1_VALOR
			cFatura  := E1_FATURA
			cPrefixo := E1_PREFIXO
			nValnota := 0
			cCondPg  := SF2->F2_COND

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Quando a parcela for gerada a partir de um Nota Fiscal       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If E1_FATURA == space(09)
				nValnota := SF2->F2_VALMERC
			ElseIf AllTrim(E1_FATURA) == "NOTFAT"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Quando a parcela for gerada a partir de uma FATURA           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nReg:=recno()
				dbSeek(XFILIAL("SE1")+cPrefixo+cFatura,.T.)
				While ! Eof .And. E1_PREFIXO+E1_FATURA == cPrefixo+cFatura .And. ! Eof() .And. E1_NUM <= mv_par02 .And. XFILIAL("SE1") == E1_FILIAL
					nValnota := nValnota + E1_VALOR
					dbSkip()
				Enddo
				dbGoto(nReg)
			Else
				dbSkip()
			Endif

			/*/ Impressao da Duplicata /*/
			@ li,47 PSAY E1_EMISSAO
			li:=li+4
			@ li,05 PSAY nValnota Picture "@e 99,999.99"
			@ li,17 PSAY E1_NUM
			@ li,29 PSAY if(mValp1>0 .and. mCond,mValp1,E1_VALOR) Picture "@e 99,999.99"
			@ li,39 PSAY E1_NUM+E1_PARCELA+"/"+right(alltrim(str(year(E1_EMISSAO))),2)
			@ li,52 PSAY If( cCondPg == "887" , "C/ APRESENTACAO", E1_VENCTO)
			li:=li+5
			mCond:=.F.
			dbSelectArea("SA1")
			dbSetOrder(1)
			If dbSeek(XFILIAL("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
				@ li+0,023 PSAY A1_NOME
				@ li+0,065 PSAY A1_COD
				@ li+1,023 PSAY A1_END
				@ li+1,065 PSAY SE1->E1_VEND1
				@ li+2,023 PSAY A1_MUN
				@ li+2,051 PSAY A1_EST
				@ li+2,062 PSAY A1_CEP
				@ li+3,023 PSAY A1_CGC Picture "@R 99.999.999/9999.99"
				@ li+3,051 PSAY A1_INSCR
				If !empty(A1_ENDCOB)
					@ li+4,023 PSAY chr(15)+ALLTRIM(A1_ENDCOB)+"  MUN.:"+A1_MUN+" CEP: "+A1_CEP+chr(18)
				Else
					@ li+4,023 PSAY chr(15)+A1_MUN+" CEP: "+A1_CEP+chr(18)
				Endif
			Endif
			li:=li+6

			mExtenso := Alltrim(Extenso(if(mValp1>0,mValp1,SE1->E1_VALOR),.F.,1))
			dbSelectArea("SE1")
			nLB  := Li
			mLin := MLCount(mExtenso,53)
			For c:=1 To mLin
				cImprime := Alltrim(MemoLine(mExtenso,53,c))+" "
				@ li,23 PSAY cImprime+Repli("*",53-Len(cImprime))
				li:=li+1
			Next
			li:=nLb+7
			@ li,17 PSAY "BANCOS: "
			For x:=1 To Len(vBanco)
				@ li,PCol() PSAY If( x == nPos , "("+vBanco[x]+")",vBanco[x])+;
				If( x <> Len(vBanco) , " - ", "")
			Next

			dbSkip()
		Enddo
	Enddo

	if aReturn[5] == 1
		Set Printer TO 
		dbcommitAll()
		ourspool(wnrel)
	endif
	MS_FLUSH()
Return

/* Valida a senha para impressao da duplicata */
Static Function PegaSenha()
	Local oPsw, nOpc := 0, cPswFol := Space(06)
	Local oFont := TFont():New("Courier New",,-14,.T.,.T.)

	Set Device To Screen

	DEFINE MSDIALOG oPsw TITLE "Senha" From 8,70 To 13,90 OF oMainWnd
	oPsw:nStyle := nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_VISIBLE )

	@ 05,005 SAY "Senha" PIXEL OF oPsw
	@ 05,035 GET cPswFol PASSWORD SIZE 30,10 PIXEL OF oPsw FONT oFont

	@ 20,010 BUTTON oBut1 PROMPT "&Ok" SIZE 30,12 OF oPsw PIXEL;
	Action IIF(VldSenha(cPswFol),(nOpc:=1,oPsw:End()),nOpc:=0)
	@ 20,040 BUTTON oBut2 PROMPT "&Cancela" SIZE 30,12 OF oPsw PIXEL;
	Action (nOpc:=0,oPsw:End())

	ACTIVATE MSDIALOG oPsw CENTERED

	Set Device To Printer

Return(If( nOpc == 1 , 2, 3))

/* Valida a senha informada pelo usuario */
Static Function VldSenha(cPsw)
	Local lRet := .T., cCodUsr := "CRISTIANE      "  //"Administrador  "

	cCodUsr := RetCodUsr(cCodUsr)
	PswOrder(1)
	PswSeek(cCodUsr)
	If ! PswName(cPsw)
		Alert("Senha Invalida, Verifique a senha digitada !")
		lRet := .F.
	Endif
Return(lRet)

/* Pesquisa no cadastro de usuario do sistema o codigo do mesmo */
Static Function RetCodUsr(cUser)
	Local aUser, cUserAnt
	PswOrder(2)//Nome
	PswSeek(Alltrim(cUser)) //Pesquisa usuario  
	aUser := PswRet(1) //Retorna Matriz com detalhes, acessos do Usuario
	cUserAnt := aUser[1][1]  //Retorna codigo do usuario
Return(cUserAnt)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³    Fim do Programa DUPPEL.PRX, Obrigado pela Aten‡Æo !                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ