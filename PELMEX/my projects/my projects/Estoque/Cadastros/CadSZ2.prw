#Include "Protheus.Ch"

/*_____________________________________________________________________________
¦ Função    ¦ CadSZ2     ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 12/02/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Formação de Preços Pelmex													¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function CadSZ2

	Local aCores  := {{ "Z2_DatIni <= dDataBase .And. Z2_DatFim >= dDataBase" ,'ENABLE' },;
	{ "Z2_DatIni > dDataBase .Or. Z2_DatFim < dDataBase" ,'DISABLE'}}

	Private oDlg  := Nil
	Private cCadastro := "Formação de Preços"
	Private aRotina := {}

	SZ2->(dbsetorder(1))

	aAdd( aRotina, {"Pesquisar",	"AxPesqui",    0,1})
	aAdd( aRotina, {"Visualizar",	"u_Z2_Brow(2)",0,2})
	aAdd( aRotina, {"Incluir",		"u_Z2_Brow(3)",0,3})
	aAdd( aRotina, {"Alterar",		"u_Z2_Brow(4)",0,4})
	aAdd( aRotina, {"Excluir",		"u_Z2_Brow(5)",0,5})
	aAdd( aRotina, {"Imprimir",	"u_IMPSZ2(6)", 0,6})
	aAdd( aRotina, {"Legenda",		"u_Z2_Leg(cCadastro)",0,6})

	mBrowse( 6, 1, 22, 75, "SZ2",,"",,,,aCores)

Return Nil
/*_____________________________________________________________________________
¦ Função    ¦ Z2_Brow    ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 12/02/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Tela de Dados																	¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function Z2_Brow(nOpcX)

	Private cCod	:= if (nOpcX == 3, Space(15), SZ2->Z2_Cod)
	Private cDesCod:= if (nOpcX == 3, Space(40), SZ2->Z2_DesCod)
	Private cTipCst:= if (nOpcX == 3, Space(1), SZ2->Z2_TipCst)
	Private nCusTot:= 0
	Private aCampos:= { "Z2_COMP", "Z2_DESCMP", "Z2_UNICMP", "Z2_DATINI", "Z2_DATFIM", "Z2_QUANT", "Z2_CUSTO", "Z2_TOTAL", "Z2_PERPAR"}
	Private aCabec	:= { "Componente", "Descrição", "UM", "Início", "Fim", "Quant", "Custo Unit", "Custo Total", "Participação"}
	Private aHeader:= {}
	Private aCOLS	:= {}
	Private aRegs	:= {}
	Private nUsado	:= 0

	If nOpcX # 2													// Se Não Visualizar

		If nOpcX # 3												// Se Não Incluir

		End If

	End If

	Monta_aHead()							// Montagem do aHeader (Cabeçalho do Browse)
	Monta_aCols(nOpcX)					// Montagem do aCols   (Linhas do Browse)
	Monta_Tela(nOpcX)						// Montagem da tela com o browse

return .t.
/*_____________________________________________________________________________
¦ Função    ¦ Monta_aHead¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 13/02/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Montagem do aHeader (Cabeçalho dos dados)								¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
static function Monta_aHead()

	local nIndVet

	SX3->(dbSetOrder(2))

	For nIndVet := 1 To Len(aCampos)

		SX3->(dbSeek(aCampos[nIndVet]))

		IF X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
			nUsado++
			AADD(aHeader,{ aCabec[nIndVet],;
			SX3->X3_CAMPO    ,;
			SX3->X3_PICTURE  ,;
			SX3->X3_TAMANHO  ,;
			SX3->X3_DECIMAL  ,;
			SX3->X3_VALID    ,;
			SX3->X3_USADO    ,;
			SX3->X3_TIPO     ,;
			SX3->X3_ARQUIVO  ,;
			SX3->X3_CONTEXT  })
		Endif

	Next nIndVet

return nil
/*_____________________________________________________________________________
¦ Função    ¦ Monta_aCols¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 13/02/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Montagem do aCols (Linhas dos dados)										¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
static function Monta_aCols(nOpcX)
	Local x
	Local nCnt     := 0
	Local cVarTemp := ""

	if nOpcX == 3						// Incluir

		aAdd( aCOLS,Array(Len(aHeader)+1))

		nUsado := 0

		SX3->(dbSetOrder(2))

		For x:=1 To Len(aCampos)

			SX3->(dbSeek(aCampos[x]))

			IF X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL

				nUsado++

				IF	 		SX3->X3_TIPO == "C";	aCOLS[1][nUsado] := SPACE(SX3->x3_tamanho)
				ELSEIF	SX3->X3_TIPO == "N";	aCOLS[1][nUsado] := 0
				ELSEIF	SX3->X3_TIPO == "D";	aCOLS[1][nUsado] := dDataBase
				ELSEIF	SX3->X3_TIPO == "M";	aCOLS[1][nUsado] := CriaVar(AllTrim(SX3->X3_CAMPO))
					ELSE;			   					aCOLS[1][nUsado] := .F.
				Endif

				If SX3->X3_CONTEXT == "V"
					aCols[1][nUsado] := CriaVar(AllTrim(SX3->X3_CAMPO))
				Endif

			Endif

		Next

		aCOLS[1][nUsado+1] := .F.

	else

		SZ2->(dbSetOrder(1))
		SZ2->(dbSeek( xFilial() + cCod, .T.))

		nCnt := 0

		While !SZ2->(Eof()) .And. SZ2->Z2_Filial+SZ2->Z2_COD == SZ2->(xFilial())+cCod

			aAdd( aRegs, SZ2->(Recno()) )
			aAdd( aCOLS, Array(Len(aHeader)+1) )

			nCnt++
			nUsado:=0

			SX3->(dbSetOrder(2))

			For x:=1 To Len(aCampos)

				SX3->(dbSeek(aCampos[x]))

				IF X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL

					nUsado++

					If SX3->X3_CONTEXT == "V"
						aCols[nCnt][nUsado] := CriaVar(AllTrim(SX3->X3_CAMPO))
					else
						cVarTemp := SZ2->(SX3->X3_CAMPO)
						aCOLS[nCnt][nUsado] := &cVarTemp
					Endif

				Endif

			Next

			aCOLS[nCnt][nUsado+1] := (nOpcX == 5)					// Exluir ?

			SZ2->(dbSkip())

		End

		ASort(aCOLS,,,{|x,y| x[1] < y[1] })

	endif

return nil
/*_____________________________________________________________________________
¦ Função    ¦ Monta_Tela ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 13/02/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Montagem da Ficha																¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
static function Monta_Tela(nOpcX)
	Local oPanelT
	Local nOpcA := 0
	Local aButtons := {}
	Local aCombo := {"Médio", "Standard"}
	Local aObjects   :={},aPosObj  :={}
	Private oGet := Nil

	aAdd(aButtons,{"PRODUTO", {|| Z2_ExpEst(cCod, nOpcX) },"Explode Estrutura"})

	//DEFINE MSDIALOG oDlg TITLE cCadastro From 0,0 TO 60,140 PIXEL OF oMainWnd
	DEFINE MSDIALOG oDlg TITLE cCadastro From 0,0 TO 470,1100 PIXEL OF oMainWnd

	@ 0,3 MSPANEL oPanelT PROMPT "" SIZE 35,410 OF oDlg CENTERED LOWERED //"Botoes"
	oPanelT:Align := CONTROL_ALIGN_ALLCLIENT//BOTTOM

	@ 15, 5 TO 40,550 LABEL "Formação de Preços" OF oPanelT PIXEL

	@ 24, 006 SAY "Produto"		SIZE 70,7 PIXEL OF oPanelT
	@ 24, 320 SAY "Tipo Custo"	SIZE 70,7 PIXEL OF oPanelT
	@ 24, 420 SAY "Custo Total"	SIZE 70,7 PIXEL OF oPanelT

	@ 23, 030 MSGET cCod	SIZE 070,7 PIXEL OF oPanelT PICTURE "@!"	WHEN nOpcX == 3 F3 "SB1" VALID Crit_Tela(1) 			// Incluir
	@ 23, 110 MSGET cDesCod	SIZE 200,7 PIXEL OF oPanelT 				WHEN Upper(Left(cCod, 5)) == "FATOR"

	@ 23, 350 MSCOMBOBOX oCombo1 VAR cTipCst ITEMS aCombo SIZE 50, 90 PIXEL OF oPanelT 	VALID Crit_Tela(2) ON CHANGE Z2TipCst()

	@ 23, 450 MSGET oGetx Var nCusTot	SIZE 070,7 PICTURE "@E 999,999.99" PIXEL OF oPanelT WHEN .f.

	oGet := MSGetDados():New(40,5,200,550,nOpcX,"u_Z2LOk","u_Z2GetTOk",,.T.,,,,800,,,,"u_Z2GetDel",oPanelT)

	u_Z2_Partic()

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(u_Z2GetTOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()},,aButtons)

	If nOpcx > 2 .and. nOpcA == 1

		Begin Transaction
			Z2_Grava()
		End Transaction

	End If

Return Nil
/*_____________________________________________________________________________
¦ Função    ¦ Crit_Tela  ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 13/02/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Crítica dos dados da Tela													¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Crit_Tela(nCampo)

	If nCampo == 1							// Produto

		If !ExistCPO("SB1", cCod)
			IW_MsgBox("Produto não Cadastrado!","Erro!!!", "STOP")
			Return .f.
		End If
		/*
		If ExistChav("SZ2", cCod)
		IW_MsgBox("Formação de Preço já Cadastrada!","Erro!!!", "STOP")
		Return .f.
		End If
		*/
		cDesCod := Posicione("SB1", 1, SB1->(xFilial()) + cCod, "B1_DESC")

	End If

Return .t.
/*_____________________________________________________________________________
¦ Função    ¦ Z2TipCst	 ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 26/02/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Apuração e Recálculo dos custos da planilha							¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Z2TipCst

	Local nIndVet := 0
	Local nPCod   := Ascan( aHeader , {|x| Trim(x[2]) == "Z2_COMP" } )
	Local nPDtIni := Ascan( aHeader , {|x| Trim(x[2]) == "Z2_DATINI" } )
	Local nPDtFim := Ascan( aHeader , {|x| Trim(x[2]) == "Z2_DATFIM" } )
	Local nPCusto := Ascan( aHeader , {|x| Trim(x[2]) == "Z2_CUSTO" } )

	For nIndVet := 1 to Len(aCols)

		If !aCols[nIndVet][nUsado+1];																				// Não Deletado
		.And. Upper(Left(aCols[nIndVet][nPCod], 5)) <> "FATOR";											// Não é Fator
		.And. aCols[nIndVet][nPDtIni] <= dDataBase .And. aCols[nIndVet][nPDtFim] >= dDataBase	// Dentro da Validade

			If cTipCst == "Médio"

				SB1->(dbSeek(xFilial() + aCols[nIndVet][nPCod]))
				SB2->(dbSeek(xFilial() + aCols[nIndVet][nPCod] + SB1->B1_LocPad))

				aCols[nIndVet][nPCusto] := SB2->B2_CM1

			Else

				SB1->(dbSeek(xFilial() + aCols[nIndVet][nPCod]))
				aCols[nIndVet][nPCusto] := SB1->B1_CuStd

			End If

		End If

	Next nIndVet

	u_Z2_Partic()

Return .t.
/*_____________________________________________________________________________
¦ Função    ¦ Z2LOk		 ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 13/02/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Montagem da Ficha																¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function Z2LOk

	local nIndVet

	if aCols[N][nUsado+1]											// Deletado
		return .t.
	endif

	For nIndVet = 1 to Len(aHeader)

		If Trim(aHeader[nIndVet][02]) == "Z2_QUANT";			// Real
		.and. Empty(aCols[N][nIndVet])						// Vazio
			IW_MsgBox("Quantidade Solicitada não Informada!","Erro!!!", "STOP")
			Return .f.
		End If

	Next nIndVet

Return .t.
/*_____________________________________________________________________________
¦ Função    ¦ Z2_Grava   ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 13/02/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Gravação dos Dados																¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Z2_Grava()

	Local nI := 0
	Local nY := 0
	Local cVar := ""
	Local lOk := .T.
	Local nDel := 0

	For nI := 1 To Len(aCols)

		lOk := .F.

		If nI <= Len(aRegs)
			SZ2->(dbGoTo(aRegs[nI]))
			lOk := .T.
		Endif

		If !aCols[nI][nUsado+1]

			RecLock("SZ2",!lOk)

			SZ2->Z2_Filial	:= SZ2->(xFilial())
			SZ2->Z2_Cod		:= cCod
			SZ2->Z2_DesCod	:= cDesCod
			SZ2->Z2_TipCst	:= cTipCst

			For nY = 1 to Len(aHeader)

				If aHeader[nY][10] # "V"
					cVar := Trim(aHeader[nY][2])
					SZ2->(&(cVar)) := aCols[nI][nY]
				Endif

			Next nY

			SZ2->(MsUnLock())

		Else

			If lOk
				RecLock("SZ2",.F.)
				SZ2->(dbDelete())
				MsUnLock("SZ2")
				nDel ++
			Endif

		Endif

	Next nI

	If nDel > 0
		SX2->(dbSetOrder(1))
		SX2->(dbSeek("SZ2"))
		RecLock("SX2",.F.)
		SX2->X2_DELET += nDel
		MsUnLock("SX2")
	Endif

Return .t.
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Funcao    ¦ Z2GETTOK   ¦ Autor ¦ Ulysses Ribeiro      ¦ Data ¦ 25/08/2003 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Critica do aCols todo                                         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function Z2GetTOk()

	local nLinVet := 0
	local nColVet := 0

	For nLinVet := 1 to len(aCols)

		If aCols[nLinVet][nUsado+1]								// Deletado
			loop
		End If

		For nColVet := 1 to len(aHeader)

			If Trim(aHeader[nColVet][02]) == "Z2_QUANT";		// Real
			.and. empty(aCols[nLinVet][nColVet])			// Vazio
				IW_MsgBox("Dados Incompletos!","Erro!!!", "STOP")
				return .f.
			End If

		Next nColVet

	Next nLinVet

Return .t.
/*_____________________________________________________________________________
¦ Função    ¦ Z2GetDel   ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 26/02/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Exclusão de linha no Browse													¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function Z2GetDel()

	local  nPos := 0

	if !aCols[N,len(aCols[N])]
		u_Z2_Partic()
		return .t.
	endif

	nPos := aScan(aCols,{|x| x[1] == aCols[N,1] .and. !x[len(x)]})

	If nPos # 0
		IW_MsgBox("Registro já Cadastrado!","Erro!!!", "STOP")
		return .f.
	endif

	u_Z2_Partic()

return .t.
/*_____________________________________________________________________________
¦ Função    ¦ Z2_ExpEst  ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 26/02/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Explosão da estrutura do item												¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Z2_ExpEst(cCod, nOpcX)
	Local nIndVet, nIndice
	Local nPCod  := Ascan( aHeader , {|x| Trim(x[2]) == "Z2_COMP" } )
	Local nQtBUsr:=1


	If nOpcX <> 3 .And. nOpcX <> 4																	// Inclusão e Alteração, respectivamente
		Return Nil
	End If

	If !SG1->(dbSeek(xFilial() + cCod))																// Item sem Estrutura
		Return Nil
	End If

	aCopia := {}

	For nIndVet := 1 to Len(aCols)

If Upper(Left(aCols[nIndVet][nPCod], 5)) == "FATOR";									// Não é Fator

aAdd( aCopia, Array(Len(aHeader)+1) )

For nIndice := 1 to Len(aHeader)+1
aCopia[Len(aCopia)][nIndice] := aCols[nIndVet][nIndice]
Next nIndice

End If

Next nIndVet

aCols := {}

SB1->(dbSeek(xFilial()+cCod))

If MsgYesNo("Quantidade de acordo com quantidade base da estrutura ?") .And. SB1->B1_QB > 0 
nQtBUsr:=SB1->B1_QB
EndIf

//Z2_ExpEst2(cCod, 1, If (SB1->B1_QB == 0, 1, SB1->B1_QB)) 
Z2_ExpEst2(cCod, nQtBUsr, If (SB1->B1_QB == 0, 1, SB1->B1_QB))

For nIndVet := 1 to Len(aCopia)

aAdd( aCols, Array(Len(aHeader)+1) )

For nIndice := 1 to Len(aHeader)+1
aCols[Len(aCols)][nIndice] := aCopia[nIndVet][nIndice]
Next nIndice

Next nIndVet

ASort(aCOLS,,,{|x,y| x[1] < y[1] })

u_Z2_Partic()

Return Nil
/*_____________________________________________________________________________
¦ Função    ¦ Z2_Leg     ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 26/02/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Explosão da estrutura do item												¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Z2_ExpEst2(cCod, nQuant, nQB)

Local nSG1Reg := 0
Local nPCod := Ascan( aHeader , {|x| Trim(x[2]) == "Z2_COMP" } )

While !SG1->(Eof()) .And. SG1->G1_Filial+SG1->G1_Cod == SG1->(xFilial())+cCod

nSG1Reg := SG1->(Recno())
nQtdNec := nQuant * (SG1->G1_Quant / nQB)

SB1->(dbSeek(xFilial()+SG1->G1_Comp))

// Amigo programador, qnd vc ler essa linha abaixo, favor não me xingar. Não tive outro meio pra distinguir os blocos dos d+ PIs,
// uma vez que a espuma não deve ser explodida. Faço isso com enorme pesar, nunca foi minha prática, mas a pressão era enorme pra concluir a rotina.
// Att. Ulysses Ribeiro - 02/03/2009.

If SB1->B1_Grupo <> "4036" .And. SG1->(dbSeek(xFilial() + SG1->G1_Comp))
SB1->(dbSeek(xFilial()+SG1->G1_Cod))
Z2_ExpEst2(SG1->G1_Cod, nQtdNec, If (SB1->B1_QB == 0, 1, SB1->B1_QB))
SG1->(dbGoTo(nSG1Reg))
Else

SG1->(dbGoTo(nSG1Reg))

If Left(SG1->G1_Comp, 3) <> "MOD"

nPos := aScan(aCols,{|x| x[nPCod] == SG1->G1_Comp .and. !x[len(x)]})

If nPos = 0

aAdd( aCOLS, Array(Len(aHeader)+1) )

SB1->(dbSeek(xFilial()+SG1->G1_Comp))
SB2->(dbSeek(xFilial()+SG1->G1_Comp+SB1->B1_LocPad))

aCols[Len(aCols)][1] := SG1->G1_Comp
aCols[Len(aCols)][2] := SB1->B1_Desc
aCols[Len(aCols)][3] := SB1->B1_UM
aCols[Len(aCols)][4] := SG1->G1_Ini
aCols[Len(aCols)][5] := SG1->G1_Fim
aCols[Len(aCols)][6] := nQtdNec
aCols[Len(aCols)][7] := SB2->B2_CM1
aCols[Len(aCols)][8] := nQtdNec * SB2->B2_CM1

aCOLS[Len(aCols)][Len(aCols[1])] := (SG1->G1_Ini > dDataBase .Or. SG1->G1_Fim < dDataBase)

Else
aCols[nPos][6] += nQtdNec
aCols[nPos][8] := aCols[nPos][6] * aCols[nPos][7]
End If

End If

End If

SG1->(dbSkip())

End

Return Nil
/*_____________________________________________________________________________
¦ Função    ¦ Z2_Partic  ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 13/02/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Calculo do Percentual de Participação									¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function Z2_Partic

Local nResult := 0
Local nTotal  := 0
Local nIndVet := 0
Local nPCod   := Ascan( aHeader , {|x| Trim(x[2]) == "Z2_COMP" } )
Local nPDtIni := Ascan( aHeader , {|x| Trim(x[2]) == "Z2_DATINI" } )
Local nPDtFim := Ascan( aHeader , {|x| Trim(x[2]) == "Z2_DATFIM" } )
Local nPQuant := Ascan( aHeader , {|x| Trim(x[2]) == "Z2_QUANT" } )
Local nPCusto := Ascan( aHeader , {|x| Trim(x[2]) == "Z2_CUSTO" } )
Local nPTotal := Ascan( aHeader , {|x| Trim(x[2]) == "Z2_TOTAL" } )
Local nPPerPar:= Ascan( aHeader , {|x| Trim(x[2]) == "Z2_PERPAR" } )

For nIndVet := 1 to Len(aCols)

If !aCols[nIndVet][nUsado+1];																				// Não Deletado
.And. Upper(Left(aCols[nIndVet][nPCod], 5)) <> "FATOR";											// Não é Fator
.And. aCols[nIndVet][nPDtIni] <= dDataBase .And. aCols[nIndVet][nPDtFim] >= dDataBase	// Dentro da Validade
aCols[nIndVet][nPTotal] := aCols[nIndVet][nPCusto] * aCols[nIndVet][nPQuant]
nTotal += aCols[nIndVet][nPTotal]
End If

Next nIndVet

For nIndVet := 1 to Len(aCols)

If !aCols[nIndVet][nUsado+1];																				// Não Deletado
.And. aCols[nIndVet][nPDtIni] <= dDataBase .And. aCols[nIndVet][nPDtFim] >= dDataBase	// Dentro da Validade
aCols[nIndVet][nPPerPar] := ((aCols[nIndVet][nPTotal] / nTotal) * 100)
Else
aCols[nIndVet][nPPerPar] := 0
End If

If nIndVet = n
nResult := aCols[nIndVet][nPPerPar]
End If

Next nIndVet

For nIndVet := 1 to Len(aCols)

If !aCols[nIndVet][nUsado+1];																				// Não Deletado
.And. Upper(Left(aCols[nIndVet][nPCod], 5)) == "FATOR"												// É Fator
aCols[nIndVet][nPCusto] := nTotal
aCols[nIndVet][nPTotal] := nTotal * aCols[nIndVet][nPQuant]
End If

Next nIndVet

nCusTot := nTotal

oGetx:refresh()		// Custo Total
oDlg:refresh()		// Custo Total
oGet:refresh()		// Custo Total

Return nResult
/*_____________________________________________________________________________
¦ Função    ¦ Z2_CusTot  ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 26/02/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Calculo do Custo Total do Item												¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Z2_CusTot

Local nTotal  := 0
Local nIndVet := 0
Local nPCod   := Ascan( aHeader , {|x| Trim(x[2]) == "Z2_COMP" } )
Local nPDtIni := Ascan( aHeader , {|x| Trim(x[2]) == "Z2_DATINI" } )
Local nPDtFim := Ascan( aHeader , {|x| Trim(x[2]) == "Z2_DATFIM" } )
Local nPTotal := Ascan( aHeader , {|x| Trim(x[2]) == "Z2_TOTAL" } )

For nIndVet := 1 to Len(aCols)

If !aCols[nIndVet][nUsado+1];								// Não Deletado
.And. Upper(Left(aCols[nIndVet][nPCod], 5)) <> "FATOR";											// Não é Fator
.And. aCols[nIndVet][nPDtIni] <= dDataBase .And. aCols[nIndVet][nPDtFim] >= dDataBase	// Dentro da Validade
nTotal += aCols[nIndVet][nPTotal]
End If

Next nIndVet

Return nTotal
/*_____________________________________________________________________________
¦ Função    ¦ Z2_Leg     ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 13/02/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Legendas das cores do browse												¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function Z2_Leg(cCadastro)

BrwLegenda(cCadastro,"Legendas",{{"ENABLE","Ativo"},{"DISABLE","Vencido"}})

Return Nil
