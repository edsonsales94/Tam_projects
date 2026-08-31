#INCLUDE "Rwmake.ch"
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*_____________________________________________________________________________
¦ Função    ¦ PLESTR05   ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 10/12/2008 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Disponibilidade de Estoque													¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PlEstR05()

	LOCAL cString := "SC6"
	LOCAL cDesc1  := "Este programa tem como objetivo emitir uma relação de"
	LOCAL cDesc2  := "disponibilidade de estoque para faturamento, adcionado"
	LOCAL cDesc3  := "da relação de necessidade produto."

	Private lEnd
	Private wnrel   := "PlEstR05"
	Private titulo  := "Disponibilidade de Estoque"
	Private Tamanho := "G"
	PRIVATE aReturn:= { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
	PRIVATE aLinha := { } , nLastKey := 0
	PRIVATE cPerg  := "PEstR5"

	ValidPerg()

	pergunte(cPerg,.F.)

	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

	If nLastKey = 27
		Set Filter To
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey = 27
		Set Filter To
		Return
	Endif

	RptStatus({|lEnd| PlEstR05a()},titulo)				// Distribuição de Tarefas

Return NIL
/*_____________________________________________________________________________
¦ Função    ¦ PlEstR05a  ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 10/12/2008 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Distribuição de tarefas														¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PlEstR05a

	nTipo := IF (aReturn[4] == 1, 15, 18)

	cbtxt    := SPACE(10)
	cbcont   := 00
	li       := 999
	m_pag    := 01

	PlEstR05b()												// Criação das tabelas temporárias
	Processa({||PlEstR05c(), "Processando..."})	// Explosão dos Pedidos de Venda
	//PlEstR05e()											// Apuração dos Dados
	PlEstR05f()												// Impressão

	If aReturn[5] = 1
		Set Printer TO
		dbCommitAll()
		ourspool(wnrel)
	Endif

	MS_FLUSH()

	TR1->(dbCloseArea())
	TR2->(dbCloseArea())

Return NIL
/*_____________________________________________________________________________
¦ Função    ¦ PlEstR05b  ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 24/10/2008 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Criação das Tabelas Temporárias											¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PlEstR05b
	Local aArq1 := {{"X_Pai",		"C", 15, 0},;		// codigo do Produto
	{"X_Ordem",		"C", 11, 0},;		// ordem
	{"X_Cod",		"C", 15, 0},;		// codigo do componente
	{"X_Desc",		"C", 30, 0},;		// Descrição
	{"X_UM",			"C", 02, 0},;		// Unidade de Medida
	{"X_COR",		"C", 02, 0},;		// Cor
	{"X_QtdEst",	"N", 16, 6},;		// Estoque
	{"X_QtdNec",	"N", 16, 6},;		// Necessidade no Produto Pai
	{"X_QtdEmp",	"N", 16, 6},;		// Empenho ou Pedido de Venda
	{"X_QtdFir",	"N", 16, 6},;		// OP pendente Firme
	{"X_QtdPre",	"N", 16, 6}}		// OP pendente Prevista
	Local cArq1 := CriaTrab(aArq1,.T.)
	Local cInd1 := CriaTrab(Nil, .F.)

	Local aArq2 := {{"X_Cod",		"C", 15, 0},;		// codigo do componente
	{"X_QtdEst",	"N", 16, 6},;		// Estoque
	{"X_QtdNec",	"N", 16, 6},;		// Necessidade no Produto Pai
	{"X_QtdEmp",	"N", 16, 6},;		// Empenho ou Pedido de Venda
	{"X_QtdFir",	"N", 16, 6},;		// OP pendente Firme
	{"X_QtdPai",	"N", 16, 6},;		// Quantidade Pendente PAI
	{"X_QtdPre",	"N", 16, 6}}		// OP pendente Prevista
	Local cArq2 := CriaTrab(aArq2,.T.)
	Local cInd2 := CriaTrab(Nil, .F.)

	dbusearea(.T.,,cArq1, "TR1",.F.)
	indregua("TR1",cInd1,"X_Pai + X_Ordem + X_Cod",,,"Criando Arquivo Temporário...")

	dbusearea(.T.,,cArq2, "TR2",.F.)
	indregua("TR2",cInd2,"X_Cod",,,"Criando Arquivo Temporário...")

Return NIL
/*_____________________________________________________________________________
¦ Função    ¦ PlEstR05c  ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 10/12/2008 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Preparação para Explosão dos Pedidos de Venda       				¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PlEstR05c

	local cQuery
	Local aVetCli := {}

	If !Empty(Mv_Par15)		// Cliente 01
		aadd(aVetCli, Mv_Par15)
	End If

	If !Empty(Mv_Par16)		// Cliente 02
		aadd(aVetCli, Mv_Par16)
	End If

	If !Empty(Mv_Par17)		// Cliente 03
		aadd(aVetCli, Mv_Par17)
	End If

	If !Empty(Mv_Par18)		// Cliente 04
		aadd(aVetCli, Mv_Par18)
	End If

	If !Empty(Mv_Par19)		// Cliente 05
		aadd(aVetCli, Mv_Par19)
	End If

	If !Empty(Mv_Par20)		// Cliente 06
		aadd(aVetCli, Mv_Par20)
	End If


	// Definição da Query - SQL
	cCond := " FROM "+RetSQLName("SB1")+" SB1"
	cCond += " WHERE SB1.D_E_L_E_T_ = ' '"
	If !(Empty(MV_PAR04) .And. MV_PAR05 = "ZZ")
		cCond += " And B1_COD BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "'"
	Endif
	If !(Empty(MV_PAR06) .And. MV_PAR07 = "ZZ")
		cCond += " And B1_GRUPO BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "'"
	Endif

	cCond += " And B1_TIPO = 'PA'"

	If !(Empty(MV_PAR10) .And. MV_PAR11 = "ZZ")
		cCond += " And B1_CC BETWEEN '" + MV_PAR10 + "' AND '" + MV_PAR11 + "'"
	Endif

	cQUERY := "Select COUNT(*) AS TOTAL " + cCond

	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,CHANGEQUERY(cQUERY)),"TM1",.F.,.T.)
	nTotal := TOTAL
	dbCloseArea()

	cQUERY := "Select B1_COD, B1_DESC, B1_TIPO, B1_CC, B1_UM, B1_COR,"
	cQuery += " ISNULL("+SomaSB2()+", 0) As QEst,"
	cQuery += " ISNULL("+SomaSC6(aVetCli)+", 0) As QPlan,"
	cQuery += " ISNULL("+SomaSC2("F")+", 0) As QOPFir,"
	cQUERY += " ISNULL("+SomaSC2("P")+", 0) As QOPPre"
	cQuery += cCond
	cQuery += " ORDER BY B1_COD"

	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,CHANGEQUERY(cQUERY)),"TM1",.F.,.T.)

	SG1->(dbsetorder(1))

	TM1->(dbgotop())

	ProcRegua(nTotal)
	while !TM1->(eof())

		IncProc()

		RecLock("TR1",.T.)
		TR1->X_Pai		:= TM1->B1_Cod
		TR1->X_Ordem	:= TM1->B1_Tipo + TM1->B1_CC
		TR1->X_Desc		:= TM1->B1_Desc
		TR1->X_UM		:= TM1->B1_UM
		TR1->X_Cor		:= TM1->B1_Cor

		TR1->X_QtdEst	:= TM1->QEst
		TR1->X_QtdEmp	:= TM1->QPlan
		TR1->X_QtdFir	:= TM1->QOPFir
		TR1->X_QtdPre	:= TM1->QOPPre
		TR1->X_QtdNec	:= Max(TM1->QPlan - TM1->QEst - TM1->QOPFir - TM1->QOPPre, 0)
		MsUnLock()

		PlEstR05d(TM1->B1_Cod, TM1->B1_Cod, TR1->X_QtdNec)

		TM1->(dbskip())

	End

	TM1->(dbCloseArea())

return nil
/*_____________________________________________________________________________
¦ Função    ¦ PlEstR05d  ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 10/12/2008 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Explosão de Estrutura															¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PlEstR05d(cOrigem, cFilho, nQuant)

	Local nRegSG1 := SG1->(recno())

	SB1->(dbseek(xFilial()+cFilho))
	TR1->(DbSetOrder(1))

	If SB1->B1_Fantasma <> "S" .And. SB1->B1_Tipo == "PI"

		If TR1->(dbseek(cOrigem + SB1->B1_Tipo + SB1->B1_CC + cFilho))
			RecLock("TR1",.F.)
		Else

			RecLock("TR1",.T.)
			TR1->X_Pai		:= cOrigem
			TR1->X_Ordem	:= SB1->B1_Tipo + SB1->B1_CC
			TR1->X_Cod		:= cFilho
			TR1->X_Desc		:= SB1->B1_Desc
			TR1->X_UM		:= SB1->B1_UM

			PlEstR05e(cFilho, nQuant)	// Apuração dos dados do componente

		EndIf

		TR1->X_QtdNec	+= nQuant
		MsUnLock()

	EndIf

	If SG1->(dbseek(xFilial()+cFilho))                            		// tem filho?

		While SG1->G1_Cod == cFilho .and. ! SG1->(eof())

			If SG1->G1_Ini <= MV_Par02 .And. SG1->G1_Fim >= MV_Par01		// Só processar dentro do prazo de validade
				PlEstR05d(cOrigem, SG1->G1_Comp, nQuant * SG1->G1_Quant)
			EndIf

			SG1->(dbskip())

		End

	End If

	SG1->(dbgoto(nRegSG1))

Return Nil
/*_____________________________________________________________________________
¦ Função    ¦ PlEstR05e  ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 10/12/2008 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Apuração dos Dados																¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PlEstR05e(cProduto, nQuant2)

	Local cAlias := Alias()
	Local cQuery

	If TR2->(dbSeek(cProduto))  // Se não encontrar na tabela temporária dos acumuladores
		RecLock("TR2",.f.)
		TR2->X_QtdPai += nQuant2
		TR2->X_QtdNec := Max(TR2->X_QtdPai + TR2->X_QtdEmp - TR2->X_QtdEst - TR2->X_QtdFir - TR2->X_QtdPre, 0)
		MsUnLock()
	Else
		cQUERY := "SELECT"
		cQuery += " ISNULL("+SomaSB2()+", 0) As QEst,"
		cQuery += " ISNULL("+SomaSD4()+", 0) As QEmp,"
		cQuery += " ISNULL("+SomaSC2("F")+", 0) As QOPFir,"
		cQUERY += " ISNULL("+SomaSC2("P")+", 0) As QOPPre"

		cQUERY += " FROM " + RetSqlName("SB1") + " SB1"
		cQuery += " WHERE B1_COD = '" + cProduto + "'"
		cQuery += " AND SB1.D_E_L_E_T_ = ' '"

		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,CHANGEQUERY(cQUERY)),"TM2",.F.,.T.)

		RecLock("TR2",.T.)
		TR2->X_Cod    := cProduto
		TR2->X_QtdEst := TM2->QEst
		TR2->X_QtdEmp := TM2->QEmp
		TR2->X_QtdFir := TM2->QOPFir
		TR2->X_QtdPre := TM2->QOPPre
		TR2->X_QtdPai := nQuant2
		TR2->X_QtdNec := Max(nQuant2 + TM2->QEmp - TM2->QEst - TM2->QOPFir - TM2->QOPPre, 0)
		MsUnLock()

		TM2->(dbCloseArea())
		dbSelectArea(cAlias)
	Endif

Return Nil
/*_____________________________________________________________________________
¦ Função    ¦ PlEstR05f  ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 10/12/2008 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Impressão       																¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PlEstR05f

	Local lImpPA := .f.

	cabec1 := "Codigo Produto   Descricao                      UM COR -----Estoque -----Empenho --Disponivel ----OP Firme -OP Prevista -Necessidade -------Falta -------Sobra"
	cabec2 := "                                                            A            B         A - B = C       D1            D2           E            PI > A-B+D1+D2-E"
	//         XXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XX  999,999.9999 999,999.9999 999,999.9999 999,999.9999 999,999.9999 999,999.9999 999,999.9999 999,999.9999
	//                   1         2         3         4         5         6         7         8         9        10        11        12        13        14        15
	//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567

	SetRegua(TR1->(Recno()))

	TR1->(dbGoTop())

	While !TR1->(Eof())

		IF lEnd
			@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
			Exit
		End IF

		IncRegua()

		If Li > Mv_Par03
			cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		End If

		nQtdDis := Max(TR1->X_QtdEst - TR1->X_QtdEmp, 0)

		If lImpPA := (TR1->X_QtdNec <> 0) .Or. MV_Par14 = 1		// Tem necessidade ou é para imprimir zerados

			aTot := { TR1->X_QtdEst, TR1->X_QtdEmp, TR1->X_QtdNec, TR1->X_QtdFir, TR1->X_QtdPre}

			If Empty(TR1->X_Cod)
				@ Li,000 PSay TR1->X_Pai
				nQtdFal := aTot[3]
				nQtdSob := Max(aTot[1] - aTot[2] + aTot[4] + aTot[5], 0)
			Else
				@ Li,001 PSay TR1->X_Cod

				If TR2->(dbSeek(TR1->X_Cod))   // Pesquisa na tabela de acumuladores
					aTot := { TR2->X_QtdEst, TR2->X_QtdEmp, TR2->X_QtdNec, TR2->X_QtdFir, TR2->X_QtdPre, TR2->X_QtdPai}
				Endif

				nQtdFal := aTot[3]
				nQtdSob := Max(aTot[1] - aTot[2] - aTot[3] + aTot[4] + aTot[5] - aTot[6], 0)
			EndIf

			@ Li,017 PSay TR1->X_Desc
			@ Li,048 PSay TR1->X_UM
			@ Li,051 PSay TR1->X_Cor
			@ Li,055 PSay aTot[1]	Picture "@E 999,999.9999"
			@ Li,068 PSay aTot[2]	Picture "@E 999,999.9999"
			@ Li,081 PSay Max(aTot[1] - aTot[2], 0)	Picture "@E 999,999.9999"
			@ Li,094 PSay aTot[4]	Picture "@E 999,999.9999"
			@ Li,107 PSay aTot[5]	Picture "@E 999,999.9999"
			@ Li,120 PSay aTot[3]	Picture "@E 999,999.9999"
			@ Li,133 PSay nQtdFal	Picture "@E 999,999.9999"
			@ Li,146 PSay nQtdSob	Picture "@E 999,999.9999";		Li++

		End If

		TR1->(dbSkip())

		If Empty(TR1->X_Cod)	.And. (lImpPA .Or. MV_Par14 = 1)
			Li++
		End If

	End

Return Nil

Static Function SomaSB2()
	Local cRet := ""

	cRet += "SELECT SUM(SB2.B2_QATU)"
	cRet += " FROM " + RetSQLName("SB2") + " SB2"
	cRet += " Where SB2.D_E_L_E_T_ = ' '"
	cRet += " And SB2.B2_FILIAL = '" + SB2->(xFilial()) + "'"
	cRet += " AND SB2.B2_COD = SB1.B1_COD"
	cRet += " And SB2.B2_LOCAL BETWEEN '" + MV_PAR12 + "' AND '" + MV_PAR13 + "'"

Return "("+cRet+")"

Static Function SomaSC6(aVetCli)
	Local nIndVet
	Local cRet:= ""

	cRet += "SELECT SUM(SC6.C6_QTDVEN - SC6.C6_QTDENT)"
	cRet += " FROM " + RetSqlName("SC6")+" SC6"
	cRet += " WHERE SC6.D_E_L_E_T_ = ''"
	cRet += " AND SC6.C6_FILIAL = '" + SC6->(xFILIAL()) + "'"
	cRet += " AND SC6.C6_PRODUTO = SB1.B1_COD"
	cRet += " AND SC6.C6_ENTREG BETWEEN '" + dtos(MV_PAR01) + "' AND '" + dtos(MV_PAR02) + "'"
	cRet += " AND SC6.C6_BLOQUEI = ''"
	cRet += " AND SC6.C6_BLQ = ''"
	cRet += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT"

	If Len(aVetCli) > 0
		cRet += " AND ("

		For nIndVet := 1 To Len(aVetCli)
			cRet += "SC6.C6_CLIENTE = '" + aVetCli[nIndVet] + "'"
			If nIndVet + 1 < Len(aVetCli)
				cRet += " OR "
			End If
		Next nIndVet
		cRet += ")"
	End If

Return "("+cRet+")"

Static Function SomaSC2(cTpOp)
	Local cRet := ""

	cRet += "SELECT SUM(SC2.C2_QUANT"+If(cTpOp=="F"," - SC2.C2_QUJE","")+")"
	cRet += " FROM "+RetSqlName("SC2")+" SC2"
	cRet += " WHERE SC2.D_E_L_E_T_ = ' '"
	cRet += " AND SC2.C2_PRODUTO = SB1.B1_COD"
	cRet += " AND SC2.C2_FILIAL = '" + SC2->(xFILIAL()) + "'"
	If cTpOp == "F"  // Se filtra OP Firmes
		cRet += " AND SC2.C2_DATRF = ''"
	Endif
	cRet += " AND SC2.C2_TPOP = '"+cTpOp+"'"

Return "("+cRet+")"

Static Function SomaSD4()
	Local cRet := ""

	cRet += "SELECT SUM(D4_QUANT)"
	cRet += " From "+RetSqlName("SD4")+" SD4"
	cRet += " WHERE SD4.D_E_L_E_T_ = ''"
	cRet += " And SD4.D4_COD = SB1.B1_COD"
	cRet += " And SD4.D4_FILIAL = '" + SD4->(xFILIAL()) + "'"

Return "("+cRet+")"

/*_____________________________________________________________________________
¦ Função    ¦ ValidPerg  ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 10/12/2008 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Criação das Perguntas        												¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidPerg()

	u_InPutSX1(cPerg, "01", "Período De",		"","","mv_ch1","D", 8,0,0,"G","","",	"","","mv_par01")
	u_InPutSX1(cPerg, "02", "Período Até",		"","","mv_ch2","D", 8,0,0,"G","","",	"","","mv_par02")
	u_InPutSX1(cPerg, "03", "Linhas/Página",	"","","mv_ch3","N", 2,0,0,"G","","",	"","","mv_par03")
	u_InPutSx1(cPerg, "04", "Produto de",		"","","mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04")
	u_InPutSx1(cPerg, "05", "Produto Ate",		"","","mv_ch5","C",15,0,0,"G","","SB1","","","mv_par05")
	u_InPutSX1(cPerg, "06", "Grupo de",			"","","mv_ch6","C",04,0,0,"G","","SBM","","","mv_par06")
	u_InPutSX1(cPerg, "07", "Grupo Ate",			"","","mv_ch7","C",04,0,0,"G","","SBM","","","mv_par07")
	u_InPutSX1(cPerg, "08", "Tipo de",			"","","mv_ch8","C",02,0,0,"G","","02",	"","","mv_par08")
	u_InPutSX1(cPerg, "09", "Tipo Ate",			"","","mv_ch9","C",02,0,0,"G","","02",	"","","mv_par09")
	u_InPutSX1(cPerg, "10", "CC de",				"","","mv_chA","C",09,0,0,"G","","CTT","","","mv_par10")
	u_InPutSX1(cPerg, "11", "CC Ate",				"","","mv_chB","C",09,0,0,"G","","CTT","","","mv_par11")
	u_InPutSX1(cPerg, "12", "Local de",			"","","mv_chC","C",02,0,0,"G","","",	"","","mv_par12")
	u_InPutSX1(cPerg, "13", "Local Ate",			"","","mv_chD","C",02,0,0,"G","","",	"","","mv_par13")
	u_InPutSX1(cPerg, "14", "Falta zerada",		"","","mv_chE","N",01,0,1,"C","","","","","mv_par13","Sim","Si","Yes","","Nao","No","No")
	u_InPutSX1(cPerg, "15", "Cliente 01",		"","","mv_chF","C",06,0,0,"G","","SA1","","","mv_par15")
	u_InPutSX1(cPerg, "16", "Cliente 02",		"","","mv_chF","C",06,0,0,"G","","SA1","","","mv_par16")
	u_InPutSX1(cPerg, "17", "Cliente 03",		"","","mv_chH","C",06,0,0,"G","","SA1","","","mv_par17")
	u_InPutSX1(cPerg, "18", "Cliente 04",		"","","mv_chI","C",06,0,0,"G","","SA1","","","mv_par18")
	u_InPutSX1(cPerg, "19", "Cliente 05",		"","","mv_chJ","C",06,0,0,"G","","SA1","","","mv_par19")
	u_InPutSX1(cPerg, "20", "Cliente 06",		"","","mv_chK","C",06,0,0,"G","","SA1","","","mv_par20")

Return Nil