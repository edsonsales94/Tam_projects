#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

#Define cMasQtd "@E 999,999,999.999"
#Define cMasCst "@E 9999,999,999.99"

/*_______________________________________________________________________________
¦ Função    ¦ CstR05     ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 30/05/2005 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Mapa de Movimentações em Dólar.                                   ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function CstR05()

	Local cDesc1        := "Este programa tem como objetivo imprimir relatório "
	Local cDesc2        := "de acordo com os parâmetros informados pelo usuário."
	Local cDesc3        := ""
	Local aOrd          := {}
	Local cPerg         := "CSTR05"
	Private titulo      := "Mapa de Movimentações"
	Private nLin        := 80
	Private nCntImpr    := 0
	Private cRodaTxt    := ''
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private limite      := 200
	Private tamanho     := "G"
	Private nomeprog    := "CSTR05"
	Private nTipo       := 18
	Private aReturn     := {"Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cbtxt       := Space(10)
	Private cbcont      := 00
	Private CONTFL      := 01
	Private m_pag       := 01
	Private wnrel       := "CSTR05"
	Private cString     := "SB1"
	Private cFilterUser := ""
	Private cFilGrp     := ""

	ValidPerg(cPerg)

	Pergunte(cPerg,.F.)

	wnrel:=SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return Nil
	End If

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return Nil
	End If

	nTipo 		:= If (aReturn[4] == 1, 15, 18)
	cFilterUser := aReturn[7]

	Titulo += 'Custo Médio'
	Titulo += '  em ' + Trim(Posicione('CTO',1,CTO->(xFilial())+Mv_Par13, 'CTO_DESC'))
	Titulo += Space(10) + 'Referência: '
	Titulo += DtoC(mv_par01)
	Titulo += ' Até '
	Titulo += DtoC(mv_par02)

	cFilGrp := CstR05y(MV_Par15)

	RptStatus({|| CstR05a() },Titulo)

Return Nil
/*_______________________________________________________________________________
¦ Função    ¦ CstR05a    ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 02/06/2005 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Distribuição de tarefas.                                          ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CstR05a()

	MsgRun("Criando Arquivo Temporário...", "Aguarde...", {|| CstR05b() })
	Processa( {|| CstR05c() } )												// Apurar Saldos Iniciais
	Processa( {|| CstR05d() } )												// Apurar Entradas
	Processa( {|| CstR05e() } )												// Apurar Saídas
	Processa( {|| CstR05f() } )												// Apurar Movimentações Internas
	Processa( {|| CstR05g() } )												// Rotina principal de Impressão

Return Nil
/*_______________________________________________________________________________
¦ Função    ¦ CstR05b    ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 30/05/2005 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Criação das Tabelas Temporárias.                                  ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CstR05b()

	local cArq := ''
	Local cInd := ''
	local aStr := {}

	AADD(aStr,{"TRB_LOCAL",	"C",02,0})
	AADD(aStr,{"TRB_CC",		"C",09,0})
	AADD(aStr,{"TRB_TIPO",  "C",02,0})
	AADD(aStr,{"TRB_COD",   "C",15,0})
	AADD(aStr,{"TRB_GRUPO", "C",04,0})
	AADD(aStr,{"TRB_DESC",	"C",38,0})
	AADD(aStr,{"TRB_SLDINI","N",13,3})
	AADD(aStr,{"TRB_CSTINI","N",13,2})
	AADD(aStr,{"TRB_SLDENT","N",13,3})
	AADD(aStr,{"TRB_CSTENT","N",13,2})
	AADD(aStr,{"TRB_SLDSAI","N",13,3})
	AADD(aStr,{"TRB_CSTSAI","N",13,2})
	AADD(aStr,{"TRB_SLDFIM","N",13,3})
	AADD(aStr,{"TRB_CSTFIM","N",13,2})

	cArq := CriaTrab(aStr,.T.)
	cInd := CriaTrab(Nil ,.f.)

	Use &cArq Alias TRB New
	IndRegua("TRB",cInd,"TRB_LOCAL+TRB_CC+TRB_TIPO+TRB_COD")

	aStr := {}

	AADD(aStr,{"TRC_LOCAL",	"C",02,0})
	AADD(aStr,{"TRC_COD",   "C",15,0})
	AADD(aStr,{"TRC_SEQCAL","C",14,0})
	AADD(aStr,{"TRC_DATA",	"D",08,0})
	AADD(aStr,{"TRC_TMCF",	"C",08,0})
	AADD(aStr,{"TRC_DOCTO", "C",06,0})
	AADD(aStr,{"TRC_QUANT", "N",13,3})
	AADD(aStr,{"TRC_ENTSAI","C",01,0})
	AADD(aStr,{"TRC_VALOR", "N",13,2})

	cArq := CriaTrab(aStr,.T.)
	cInd := CriaTrab(Nil ,.f.)

	Use &cArq Alias TRC New
	IndRegua("TRC",cInd,"TRC_LOCAL+TRC_COD+TRC_SEQCAL")

Return Nil
/*_______________________________________________________________________________
¦ Função    ¦ CstR05c    ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 30/05/2005 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Apuração de Saldos Iniciais.                                      ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CstR05c()

	Local dDatIni := Stod(Left(DtoS(mv_par01),6)+"01")//-1  Alidio Ribeiro retirado o 
	Local cQuery  := ""                                     // -1 conforme pedido do Sr. Walter
	Local nTxConv := 1
	Local aSldIni := {}

	// Todos os armazéns diferentes do CQ (dentro dos parâmetros informados pelo usuário)
	cQuery += "Select B2_LOCAL, B1_CC, B1_TIPO, B1_COD, B1_GRUPO, B1_DESC, @@ROWCOUNT As nTotReg"    
	cQuery += " From " + RetSQLName("SB1") + " As SB1, " + RetSQLName("SB2") + " As SB2"

	cQuery += " Where SB1.D_E_L_E_T_ = ''"
	cQuery += " And B1_CC Between '" + Trim(Mv_Par05) + "' And '" + Trim(Mv_Par06) + "'"
	cQuery += " And B1_TIPO Between '" + Trim(Mv_Par07) + "' And '" + Trim(Mv_Par08) + "'"
	cQuery += " And B1_COD Between '" + Trim(Mv_Par09) + "' And '" + Trim(Mv_Par10) + "'"
	cQuery += If (Empty(cFilGrp), "", " And B1_TIPO " + If (Mv_Par14 == 1, "In ", "Not In ") + cFilGrp)

	cQuery += " And B1_COD = B2_COD"
	cQuery += " And SB2.D_E_L_E_T_ = ''"
	cQuery += " And B2_FILIAL = '" + SB9->(xFilial()) + "'"
	cQuery += " And B2_LOCAL Between '" + Trim(Mv_Par03) + "' And '" + Trim(Mv_Par04) + "'"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRY", .T., .T.)

	ProcRegua(QRY->nTotReg)

	While !QRY->(Eof())													// Não é Fim do Arquivo

		IncProc('Pesquisando Saldos Iniciais...')

		If !Empty(cFilterUser).and.!(&cFilterUser)				// Considerar Filtro do Usuário
			QRY->(dbSkip())
			Loop
		End If

		If Mv_Par13 <> '01'												// Moeda diferente de Real
			If !SM2->(dbSeek(DtoS(dDatIni), .t.))
				SM2->(dbGoBottom())
			End If
			nTxConv := SM2->(FieldGet(FieldPos("M2_MOEDA"+Str(Val(Mv_Par13),1))))
		End If

		If SB9->(Dbseek(xFilial()+QRY->B1_COD+QRY->B2_LOCAL+Dtos(Mv_Par01-1)))
			aSldIni := {SB9->B9_QINI, SB9->B9_VINI1}
		Else
			aSldIni := CalcEst(QRY->B1_COD, QRY->B2_LOCAL, Mv_Par01)
		End If

		If aSldIni[1] # 0 .Or. aSldIni[2] # 0

			Reclock("TRB",.t.)												// Gravar Cabeçalho do Saldo Inicial
			TRB->TRB_Local	 := QRY->B2_Local
			TRB->TRB_CC		 := QRY->B1_CC
			TRB->TRB_Tipo   := QRY->B1_Tipo
			TRB->TRB_Cod    := QRY->B1_Cod
			TRB->TRB_Grupo  := QRY->B1_Grupo
			TRB->TRB_Desc	 := QRY->B1_Desc
			TRB->TRB_SldIni := aSldIni[1]
			TRB->TRB_CstIni := aSldIni[2]  / nTxConv
			TRB->TRB_SldFim := aSldIni[1]
			TRB->TRB_CstFim := aSldIni[2]  / nTxConv

			TRB->(msUnLock())

		End If

		QRY->(dbSkip())

	End

	TRB->(dbCommit())
	QRY->(dbCloseArea())

Return Nil
/*_______________________________________________________________________________
¦ Função    ¦ CstR05d    ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 30/05/2005 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Apuração de Entradas por Notas Fiscais.                           ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CstR05d()

	Local nTxConv := 1
	Local cQuery  := ""

	cQuery += "Select D1_LOCAL, B1_CC, B1_TIPO, D1_COD, B1_GRUPO, B1_DESC, D1_DTDIGIT, D1_TES, D1_CF, D1_DOC, D1_TIPO, D1_SEQCALC, SD1.R_E_C_N_O_, D1_QUANT,"
	cQuery += " D1_CUSTO, @@ROWCOUNT As nTotReg"

	cQuery += " From " + RetSQLName("SB1") + " As SB1, " + RetSQLName("SD1") + " As SD1, " + RetSQLName("SF4") + " As SF4"
	cQuery += " Where SB1.D_E_L_E_T_ = '' "
	cQuery += " And B1_CC Between '" + Trim(Mv_Par05) + "' And '" + Trim(Mv_Par06) + "'"
	cQuery += " And B1_TIPO Between '" + Trim(Mv_Par07) + "' And '" + Trim(Mv_Par08) + "'"
	cQuery += " And B1_COD Between '" + Trim(Mv_Par09) + "' And '" + Trim(Mv_Par10) + "'"
	cQuery += If (Empty(cFilGrp), "", " And B1_TIPO " + If (Mv_Par14 == 1, "In ", "Not In ") + cFilGrp)

	cQuery += " And B1_COD = D1_COD"
	cQuery += " And SD1.D_E_L_E_T_ = ''"
	cQuery += " And D1_FILIAL = '" + SD1->(xFilial()) + "'"
	cQuery += " And D1_DTDIGIT Between '" + DtoS(Mv_Par01) + "' And '" + Dtos(Mv_Par02) + "'"
	cQuery += " And D1_LOCAL Between '" + Trim(Mv_Par03) + "' And '" + Trim(Mv_Par04) + "'"

	cQuery += " And D1_TES = F4_CODIGO"
	cQuery += " And SF4.D_E_L_E_T_ = ''"
	cQuery += " And F4_FILIAL = '" + SF4->(xFilial()) + "'"
	cQuery += " And F4_ESTOQUE = 'S'"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRY", .T., .T.)

	ProcRegua(QRY->nTotReg)

	While !QRY->(Eof())															// Não é Fim do Arquivo

		IncProc('Pesquisando Entradas por NF...')

		If !Empty(cFilterUser).and.!(&cFilterUser)						// Considerar Filtro do Usuário
			QRY->(dbSkip())
			Loop
		End If

		If Mv_Par13 <> '01'														// Moeda diferente de Real
			If !SM2->(dbSeek(QRY->D1_DtDigit, .t.))
				SM2->(dbGoBottom())
			End If
			nTxConv := SM2->(FieldGet(FieldPos("M2_MOEDA"+Str(Val(Mv_Par13),1))))
		End If

		If !TRB->(dbSeek(QRY->(D1_LOCAL+B1_CC+B1_TIPO+D1_COD)))		// Gravar Cabeçalho do Saldo Inicial

			aSldIni := CalcEst(QRY->D1_COD, QRY->D1_LOCAL, Mv_Par01)

			Reclock("TRB",.t.)
			TRB->TRB_Local	 := QRY->D1_Local
			TRB->TRB_CC		 := QRY->B1_CC
			TRB->TRB_Tipo   := QRY->B1_Tipo
			TRB->TRB_Cod    := QRY->D1_Cod
			TRB->TRB_Grupo  := QRY->B1_Grupo
			TRB->TRB_Desc	 := QRY->B1_Desc
			TRB->TRB_SldIni := aSldIni[1]
			TRB->TRB_CstIni := aSldIni[2] * aSldIni[1]  / nTxConv
			TRB->TRB_SldFim := aSldIni[1]
			TRB->TRB_CstFim := aSldIni[2] * aSldIni[1]  / nTxConv

		Else
			Reclock("TRB",.f.)
		End If

		If QRY->D1_Tipo = "D"
			TRB->TRB_SldSai -= QRY->D1_Quant
			TRB->TRB_CstSai -= QRY->D1_Custo / nTxConv
		Else
			TRB->TRB_SldEnt += QRY->D1_Quant
			TRB->TRB_CstEnt += QRY->D1_Custo / nTxConv
		End If

		TRB->TRB_SldFim += QRY->D1_Quant
		TRB->TRB_CstFim += QRY->D1_Custo / nTxConv
		TRB->(msUnLock())
		TRB->(dbCommit())

		Reclock("TRC",.t.)														// Gravar Dados das Entradas
		TRC->TRC_Local	 := QRY->D1_Local
		TRC->TRC_Cod    := QRY->D1_Cod
		TRC->TRC_Data   := StoD(QRY->D1_DTDIGIT)
		TRC->TRC_SeqCal := If (Mv_Par12 == 1, Strzero(QRY->R_E_C_N_O_, 6), QRY->D1_SeqCalc)
		TRC->TRC_TMCF	 := QRY->D1_TES+"/"+QRY->D1_CF
		TRC->TRC_Docto  := QRY->D1_Doc

		If QRY->D1_Tipo = "D"
			TRC->TRC_EntSai := "S"
			TRC->TRC_Quant  := -QRY->D1_Quant
			TRC->TRC_Valor  := -(QRY->D1_Custo / nTxConv)
		Else
			TRC->TRC_EntSai := "E"
			TRC->TRC_Quant  := QRY->D1_Quant
			TRC->TRC_Valor  := QRY->D1_Custo / nTxConv
		End If

		TRC->(msUnLock())
		TRC->(dbCommit())

		QRY->(dbSkip())

	End

	QRY->(dbCloseArea())

Return Nil
/*_______________________________________________________________________________
¦ Função    ¦ CstR05e    ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 31/05/2005 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Apuração de Saídas por Notas Fiscais.                             ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CstR05e()

	Local nTxConv := 1
	Local cQuery  := ""

	cQuery += "Select D2_LOCAL, B1_CC, B1_TIPO, D2_COD, B1_GRUPO, B1_DESC, D2_EMISSAO, D2_TES, D2_CF, D2_DOC, D2_TIPO, D2_SEQCALC, SD2.R_E_C_N_O_, D2_QUANT,"
	cQuery += " D2_CUSTO1, @@ROWCOUNT As nTotReg"

	cQuery += " From " + RetSQLName("SB1") + " As SB1, " + RetSQLName("SD2") + " As SD2, " + RetSQLName("SF4") + " As SF4"

	cQuery += " Where SB1.D_E_L_E_T_ = '' "
	cQuery += " And B1_CC Between '" + Trim(Mv_Par05) + "' And '" + Trim(Mv_Par06) + "'"
	cQuery += " And B1_TIPO Between '" + Trim(Mv_Par07) + "' And '" + Trim(Mv_Par08) + "'"
	cQuery += " And B1_COD Between '" + Trim(Mv_Par09) + "' And '" + Trim(Mv_Par10) + "'"
	cQuery += If (Empty(cFilGrp), "", " And B1_TIPO " + If (Mv_Par14 == 1, "In ", "Not In ") + cFilGrp)

	cQuery += " And B1_COD = D2_COD"
	cQuery += " And SD2.D_E_L_E_T_ = ''"
	cQuery += " And D2_FILIAL = '" + SD2->(xFilial()) + "'"
	cQuery += " And D2_EMISSAO Between '" + DtoS(Mv_Par01) + "' And '" + Dtos(Mv_Par02) + "'"
	cQuery += " And D2_LOCAL Between '" + Trim(Mv_Par03) + "' And '" + Trim(Mv_Par04) + "'"

	cQuery += " And D2_TES = F4_CODIGO"
	cQuery += " And SF4.D_E_L_E_T_ = ''"
	cQuery += " And F4_FILIAL = '" + SF4->(xFilial()) + "'"
	cQuery += " And F4_ESTOQUE = 'S'"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRY", .T., .T.)

	ProcRegua(QRY->nTotReg)

	While !QRY->(Eof())															// Não é Fim do Arquivo

		IncProc('Pesquisando Saídas por NF...')

		If !Empty(cFilterUser).and.!(&cFilterUser)						// Considerar Filtro do Usuário
			QRY->(dbSkip())
			Loop
		End If

		If Mv_Par13 <> '01'												// Moeda diferente de Real
			If !SM2->(dbSeek(QRY->D2_Emissao, .t.))
				SM2->(dbGoBottom())
			End If
			nTxConv := SM2->(FieldGet(FieldPos("M2_MOEDA"+Str(Val(Mv_Par13),1))))
		End If

		If !TRB->(dbSeek(QRY->(D2_LOCAL+B1_CC+B1_TIPO+D2_COD)))		// Gravar Cabeçalho do Saldo Inicial

			aSldIni := CalcEst(QRY->D2_COD, QRY->D2_LOCAL, Mv_Par01)

			Reclock("TRB",.t.)
			TRB->TRB_Local	 := QRY->D2_Local
			TRB->TRB_CC		 := QRY->B1_CC
			TRB->TRB_Tipo   := QRY->B1_Tipo
			TRB->TRB_Cod    := QRY->D2_Cod
			TRB->TRB_Grupo  := QRY->B1_Grupo
			TRB->TRB_Desc	 := QRY->B1_Desc
			TRB->TRB_SldIni := aSldIni[1]
			TRB->TRB_CstIni := aSldIni[2] * aSldIni[1]  / nTxConv
			TRB->TRB_SldFim := aSldIni[1]
			TRB->TRB_CstFim := aSldIni[2] * aSldIni[1]  / nTxConv

		Else
			Reclock("TRB",.f.)
		End If

		If QRY->D2_Tipo == "D"
			TRB->TRB_SldEnt -= QRY->D2_Quant
			TRB->TRB_CstEnt -= QRY->D2_Custo1 / nTxConv
		Else
			TRB->TRB_SldSai += QRY->D2_Quant
			TRB->TRB_CstSai += QRY->D2_Custo1 / nTxConv
		End If

		TRB->TRB_SldFim -= QRY->D2_Quant
		TRB->TRB_CstFim -= QRY->D2_Custo1 / nTxConv
		TRB->(msUnLock())
		TRB->(dbCommit())

		Reclock("TRC",.t.)														// Gravar Dados das Entradas
		TRC->TRC_Local	 := QRY->D2_Local
		TRC->TRC_Cod    := QRY->D2_Cod
		TRC->TRC_SeqCal := If (Mv_Par12 == 1, Strzero(QRY->R_E_C_N_O_, 6), QRY->D2_SeqCalc)
		TRC->TRC_Data   := StoD(QRY->D2_EMISSAO)
		TRC->TRC_TMCF	 := QRY->D2_TES+"/"+QRY->D2_CF
		TRC->TRC_Docto  := QRY->D2_Doc

		If QRY->D2_Tipo == "D"
			TRC->TRC_EntSai := "E"
			TRC->TRC_Quant  := -QRY->D2_Quant
			TRC->TRC_Valor  := -(QRY->D2_Custo1 / nTxConv)
		Else
			TRC->TRC_EntSai := "S"
			TRC->TRC_Quant  := QRY->D2_Quant
			TRC->TRC_Valor  := QRY->D2_Custo1 / nTxConv
		End If

		TRC->(msUnLock())
		TRC->(dbCommit())

		QRY->(dbSkip())

	End

	QRY->(dbCloseArea())

Return Nil
/*_______________________________________________________________________________
¦ Função    ¦ CstR05f    ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 31/05/2005 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Apuração das Movimentações Internas.                              ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CstR05f()

	Local cLocPrc := GetMV("MV_LOCPROC")
	Local nTxConv := 1
	Local cQuery  := ""

	cQuery += "Select D3_LOCAL, B1_CC, B1_TIPO, D3_COD, B1_GRUPO, B1_DESC, D3_EMISSAO, D3_TM, D3_CF, D3_DOC, D3_SEQCALC, MOVINT.R_E_C_N_O_, D3_QUANT,"
	cQuery += " D3_CUSTO1, @@ROWCOUNT As nTotReg"

	cQuery += " From " + RetSQLName("SB1") + " As SB1, "
	cQuery += " ("

	//					Movimentos Internos fora do CQ
	cQuery += " 	Select D3_LOCAL, D3_COD, D3_EMISSAO, D3_TM, D3_CF, D3_DOC, D3_QUANT, D3_CUSTO1, D3_SEQCALC, R_E_C_N_O_"
	cQuery += " 	From " + RetSQLName("SD3")
	cQuery += " 	Where D_E_L_E_T_ = ''"
	cQuery += " 	And D3_ESTORNO = ''"
	cQuery += "    And D3_FILIAL = '" + SD3->(xFilial()) + "'"
	cQuery += "    And D3_EMISSAO Between '" + DtoS(Mv_Par01) + "' And '" + Dtos(Mv_Par02) + "'"
	cQuery += "    And D3_COD Between '" + Trim(Mv_Par09) + "' And '" + Trim(Mv_Par10) + "'"

	cQuery += " 	Union"

	//					Conversão de Requisições para Processo
	cQuery += " 	Select '" + cLocPrc + "' As D3_LOCAL, D3_COD, D3_EMISSAO, '499' As D3_TM, 'RE3*' As D3_CF, D3_DOC, D3_QUANT, D3_CUSTO1, D3_SEQCALC, R_E_C_N_O_"
	cQuery += " 	From " + RetSQLName("SD3")
	cQuery += " 	Where D_E_L_E_T_ = ''"
	cQuery += " 	And D3_ESTORNO = ''"
	cQuery += "    And D3_FILIAL = '" + SD3->(xFilial()) + "'"
	cQuery += "    And D3_EMISSAO Between '" + DtoS(Mv_Par01) + "' And '" + Dtos(Mv_Par02) + "'"
	cQuery += " 	And D3_CF = 'RE3'"
	cQuery += "    And D3_COD Between '" + Trim(Mv_Par09) + "' And '" + Trim(Mv_Par10) + "'"

	cQuery += " 	Union"

	//					Conversão de Devoluções do Processo
	cQuery += " 	Select '" + cLocPrc + "' As D3_LOCAL, D3_COD, D3_EMISSAO, '999' As D3_TM, 'DE3*' As D3_CF, D3_DOC, D3_QUANT, D3_CUSTO1, D3_SEQCALC, R_E_C_N_O_"
	cQuery += " 	From " + RetSQLName("SD3")
	cQuery += " 	Where D_E_L_E_T_ = ''"
	cQuery += " 	And D3_ESTORNO = ''"
	cQuery += "    And D3_FILIAL = '" + SD3->(xFilial()) + "'"
	cQuery += "    And D3_EMISSAO Between '" + DtoS(Mv_Par01) + "' And '" + Dtos(Mv_Par02) + "'"
	cQuery += " 	And D3_CF = 'DE3'"
	cQuery += "    And D3_COD Between '" + Trim(Mv_Par09) + "' And '" + Trim(Mv_Par10) + "'"

	cQuery += " ) As MOVINT"

	cQuery += " Where B1_CC Between '" + Trim(Mv_Par05) + "' And '" + Trim(Mv_Par06) + "'"
	cQuery += " And B1_TIPO Between '" + Trim(Mv_Par07) + "' And '" + Trim(Mv_Par08) + "'"
	cQuery += " And B1_COD Between '" + Trim(Mv_Par09) + "' And '" + Trim(Mv_Par10) + "'"
	cQuery += " And B1_COD = D3_COD"
	cQuery += " And D3_LOCAL Between '" + Trim(Mv_Par03) + "' And '" + Trim(Mv_Par04) + "'"
	cQuery += If (Empty(cFilGrp), "", " And B1_TIPO " + If (Mv_Par14 == 1, "In ", "Not In ") + cFilGrp)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRY", .T., .T.)

	ProcRegua(QRY->nTotReg)

	While !QRY->(Eof())															// Não é Fim do Arquivo

		IncProc('Pesquisando Movimentações Internas...')

		If !Empty(cFilterUser).and.!(&cFilterUser)						// Considerar Filtro do Usuário
			QRY->(dbSkip())
			Loop
		End If

		If Mv_Par13 <> '01'														// Moeda diferente de Real
			If !SM2->(dbSeek(QRY->D3_Emissao, .t.))
				SM2->(dbGoBottom())
			End If
			nTxConv := SM2->(FieldGet(FieldPos("M2_MOEDA"+Str(Val(Mv_Par13),1))))
		End If

		If !TRB->(dbSeek(QRY->(D3_LOCAL+B1_CC+B1_TIPO+D3_COD)))		// Gravar Cabeçalho

			aSldIni := CalcEst(QRY->D3_COD, QRY->D3_LOCAL, Mv_Par01)

			Reclock("TRB",.t.)
			TRB->TRB_Local	 := QRY->D3_Local
			TRB->TRB_CC		 := QRY->B1_CC
			TRB->TRB_Tipo   := QRY->B1_Tipo
			TRB->TRB_Cod    := QRY->D3_Cod
			TRB->TRB_Grupo  := QRY->B1_Grupo
			TRB->TRB_Desc	 := QRY->B1_Desc
			TRB->TRB_SldIni := aSldIni[1]
			TRB->TRB_CstIni := aSldIni[2] * aSldIni[1]  / nTxConv
			TRB->TRB_SldFim := aSldIni[1]
			TRB->TRB_CstFim := aSldIni[2] * aSldIni[1]  / nTxConv

		Else
			Reclock("TRB",.f.)
		End If

		If Val(Left(QRY->D3_TM, 1)) < 5										// Entradas

			If Left(QRY->D3_CF, 1) == "D" .And. QRY->D3_CF <> "DE8"
				TRB->TRB_SldSai -= QRY->D3_Quant
				TRB->TRB_CstSai -= QRY->D3_Custo1 / nTxConv
			Else
				TRB->TRB_SldEnt += QRY->D3_Quant
				TRB->TRB_CstEnt += QRY->D3_Custo1 / nTxConv
			End If

			TRB->TRB_SldFim += QRY->D3_Quant
			TRB->TRB_CstFim += QRY->D3_Custo1 / nTxConv

		Else																			// Saídas

			If Left(QRY->D3_CF, 1) == "D" .And. QRY->D3_CF <> "DE8"
				TRB->TRB_SldEnt -= QRY->D3_Quant
				TRB->TRB_CstEnt -= QRY->D3_Custo1 / nTxConv
			Else
				TRB->TRB_SldSai += QRY->D3_Quant
				TRB->TRB_CstSai += QRY->D3_Custo1 / nTxConv
			End If

			TRB->TRB_SldFim -= QRY->D3_Quant
			TRB->TRB_CstFim -= QRY->D3_Custo1 / nTxConv

		End If
		TRB->(msUnLock())
		TRB->(dbCommit())

		Reclock("TRC",.t.)														// Gravar Dados da Movimentação
		TRC->TRC_Local	 := QRY->D3_Local
		TRC->TRC_Cod    := QRY->D3_Cod
		TRC->TRC_SeqCal := If (Mv_Par12 == 1, Strzero(QRY->R_E_C_N_O_, 6), QRY->D3_SeqCalc)
		TRC->TRC_Data   := StoD(QRY->D3_EMISSAO)
		TRC->TRC_TMCF	 := QRY->D3_TM+"/"+QRY->D3_CF
		TRC->TRC_Docto  := QRY->D3_Doc

		If Left(QRY->D3_CF, 1) == "D"
			TRC->TRC_EntSai := If (Val(Left(QRY->D3_TM, 1)) < 5, "S", "E")
			TRC->TRC_Quant  := -QRY->D3_Quant
			TRC->TRC_Valor  := -(QRY->D3_Custo1 / nTxConv)
		Else
			TRC->TRC_EntSai := If (Val(Left(QRY->D3_TM, 1)) < 5, "E", "S")
			TRC->TRC_Quant  := QRY->D3_Quant
			TRC->TRC_Valor  := QRY->D3_Custo1 / nTxConv
		End If

		TRC->(msUnLock())
		TRC->(dbCommit())

		QRY->(dbSkip())

	End

	QRY->(dbCloseArea())

Return Nil
/*_______________________________________________________________________________
¦ Função    ¦ CstR05g    ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 30/05/2005 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Rotina de Impressão.                                              ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CstR05g

	Local   nTotRel := {0, 0, 0, 0}
	Local   nTotLoc := {0, 0, 0, 0}
	Local   nTotCC  := {0, 0, 0, 0}
	Local   nTotTip := {0, 0, 0, 0}
	Private cLocAtu := ""
	Private cCCAtu  := ""
	Private cTipAtu := ""

	ProcRegua(TRB->(LastRec()))
	TRB->(DbGoTop())

	While !TRB->(EOF())

	IncProc("Imprimindo. Local: " + TRB->TRB_Local + "  CC: " + TRB->TRB_CC + "  Tipo: " + TRB->TRB_Tipo)

	If lAbortPrint																// Verifica o cancelamento pelo usuario...
	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	Exit
	End If

	CstR05i()																	// Checar quebra de página ou de grupo

	nCstMed := (TRB->TRB_CstIni+TRB->TRB_CstEnt) / (TRB->TRB_SldIni+TRB->TRB_SldEnt)

	@ nLin,000 PSAY TRB->TRB_Cod
	@ nLin,016 PSAY TRB->TRB_Desc
	@ nLin,055 PSAY TRB->TRB_Grupo
	@ nLin,060 PSAY TRB->TRB_SldIni	Picture cMasQtd
	@ nLin,076 PSAY TRB->TRB_CstIni	Picture cMasCst
	@ nLin,092 PSAY TRB->TRB_SldEnt	Picture cMasQtd
	@ nLin,108 PSAY TRB->TRB_CstEnt	Picture cMasCst
	@ nLin,124 PSAY TRB->TRB_SldSai	Picture cMasQtd
	@ nLin,140 PSAY TRB->TRB_CstSai	Picture cMasCst
	@ nLin,156 PSAY TRB->TRB_SldFim	Picture cMasQtd
	@ nLin,172 PSAY TRB->TRB_CstFim	Picture cMasCst
	@ nLin,189 PSAY nCstMed				Picture "@E 9999.999999";	nLin++

	If Mv_Par11 == 1															// Impressão Analítica -> Imprime movimentos
	CstR05h()
	End If

	@ nLin,000 PSAY replicate('-', Limite);	nLin++

	nTotTip[1] += TRB->TRB_CstIni
	nTotTip[2] += TRB->TRB_CstEnt
	nTotTip[3] += TRB->TRB_CstSai
	nTotTip[4] += TRB->TRB_CstFim

	TRB->(DbSkip())

	If TRB->(Eof());								 							// Fim de arquivo
	.Or. TRB->TRB_Local <> cLocAtu;			 						// Quebra de Local
	.Or. TRB->TRB_CC <> cCCAtu;			 							// Quebra de Centro de Custos
	.Or. TRB->TRB_Tipo <> cTipAtu			 							// Quebra de Tipo

	@ nLin,000 PSAY "Encerramento do Tipo: " + cTipAtu

	@ nLin,076 PSAY nTotTip[1]	Picture cMasCst
	@ nLin,108 PSAY nTotTip[2]	Picture cMasCst
	@ nLin,140 PSAY nTotTip[3]	Picture cMasCst
	@ nLin,172 PSAY nTotTip[4]	Picture cMasCst;	nLin++

	@ nLin,000 PSAY replicate('=', Limite);	nLin++

	For nIndVet := 1 to 4;	nTotCC[nIndVet] += nTotTip[nIndVet]; Next nIndVet
	For nIndVet := 1 to 4;	nTotTip[nIndVet] := 0; 					 Next nIndVet

	End If

	If TRB->(Eof());								 							// Fim de arquivo
	.Or. TRB->TRB_Local <> cLocAtu;			 						// Quebra de Local
	.Or. TRB->TRB_CC <> cCCAtu				 							// Quebra de Centro de Custos

	@ nLin,000 PSAY "Encerramento do CC: " + cCCAtu

	@ nLin,076 PSAY nTotCC[1]	Picture cMasCst
	@ nLin,108 PSAY nTotCC[2]	Picture cMasCst
	@ nLin,140 PSAY nTotCC[3]	Picture cMasCst
	@ nLin,172 PSAY nTotCC[4]	Picture cMasCst;	nLin++

	@ nLin,000 PSAY replicate('+', Limite);	nLin++

	For nIndVet := 1 to 4;	nTotLoc[nIndVet] += nTotCC[nIndVet]; Next nIndVet
	For nIndVet := 1 to 4;	nTotCC[nIndVet] := 0; 					 Next nIndVet

	End If

	If TRB->(Eof());								 							// Fim de arquivo
	.Or. TRB->TRB_Local <> cLocAtu			 						// Quebra de Local

	@ nLin,000 PSAY "Encerramento do Local: " + cLocAtu

	@ nLin,076 PSAY nTotLoc[1]	Picture cMasCst
	@ nLin,108 PSAY nTotLoc[2]	Picture cMasCst
	@ nLin,140 PSAY nTotLoc[3]	Picture cMasCst
	@ nLin,172 PSAY nTotLoc[4]	Picture cMasCst;	nLin++

	@ nLin,000 PSAY replicate('*', Limite);	nLin++

	For nIndVet := 1 to 4;	nTotRel[nIndVet] += nTotLoc[nIndVet]; Next nIndVet
	For nIndVet := 1 to 4;	nTotLoc[nIndVet] := 0; 					  Next nIndVet

	End If

	If TRB->(Eof())								 							// Fim de arquivo

	@ nLin,000 PSAY "Encerramento do Relatório"

	@ nLin,076 PSAY nTotRel[1]	Picture cMasCst
	@ nLin,108 PSAY nTotRel[2]	Picture cMasCst
	@ nLin,140 PSAY nTotRel[3]	Picture cMasCst
	@ nLin,172 PSAY nTotRel[4]	Picture cMasCst

	End If

	End

	Roda(nCntImpr, cRodaTxt, Tamanho)

	TRB->(dbCloseArea())
	TRC->(dbCloseArea())

	If aReturn[5] == 1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
	End If

	MS_FLUSH()

Return Nil
/*_______________________________________________________________________________
¦ Função    ¦ CstR05h    ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 31/05/2005 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Impressão das Movimentações do Item                               ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CstR05h

	Local	nSldFim := TRB->TRB_SldIni
	Local	nCstFim := TRB->TRB_CstIni

	TRC->(dbSeek(TRB->(TRB_Local+TRB_Cod)))

	While !TRC->(Eof()) .And. TRC->(TRC_Local+TRC_Cod) == TRB->(TRB_Local+TRB_Cod)

		CstR05i()						// Checar quebra de página ou de grupo

		@ nLin,000 PSAY DtoC(TRC->TRC_Data)
		@ nLin,009 PSAY TRC->TRC_TMCF

		If Len(Trim(Substr(TRC->TRC_TMCF, 5, 4))) == 3						// Movimentacao Interna
			@ nLin,018 PSAY Posicione("SF5",1,SF5->(xFilial()+Left(TRC->TRC_TMCF, 3)),"F5_TEXTO")
		Else																				// Nota Fiscal
			@ nLin,018 PSAY Posicione("SF4",1,SF4->(xFilial()+Left(TRC->TRC_TMCF, 3)),"F4_TEXTO")
		End If

		@ nLin,039 PSAY TRC->TRC_DOCTO
		@ nLin,060 PSAY nSldFim	Picture cMasQtd
		@ nLin,076 PSAY nCstFim	Picture cMasCst

		If TRC->TRC_EntSai == "E"
			@ nLin,092 PSAY TRC->TRC_Quant	Picture cMasQtd
			@ nLin,108 PSAY TRC->TRC_Valor	Picture cMasCst
			nSldFim += TRC->TRC_Quant
			nCstFim += TRC->TRC_Valor
			nCstMed := (TRB->TRB_CstIni+TRC->TRC_Valor) / (TRB->TRB_SldIni+TRC->TRC_Quant)
		Else
			@ nLin,124 PSAY TRC->TRC_Quant	Picture cMasQtd
			@ nLin,140 PSAY TRC->TRC_Valor	Picture cMasCst
			nSldFim -= TRC->TRC_Quant
			nCstFim -= TRC->TRC_Valor
		End If

		@ nLin,156 PSAY nSldFim	Picture cMasQtd
		@ nLin,172 PSAY nCstFim	Picture cMasCst
		@ nLin,189 PSAY nCstMed	Picture "@E 9999.999999";	nLin++

		TRC->(DbSkip())

	End

Return Nil
/*_______________________________________________________________________________
¦ Função    ¦ CstR05i    ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 31/05/2005 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Impressão do cabeçalho                                            ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CstR05i

	Static lImpCab := .t.
	Local Cabec1  := "Produto-------- Descrição----------------------------- Grup ---------Saldo Inicial--------- ------------Entradas----------- -------------Saídas------------ ----------Saldo Final----------  -----------"
	Local Cabec2  := "--Data-- TM/CF--  Movimentação-------- Docto-               -----Quantidade ----------Custo -----Quantidade ----------Custo -----Quantidade ----------Custo -----Quantidade ----------Custo  Custo Médio"
	//                Local: 01-xxxxxxxxxxxxxxxxxxxx     CC: xxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx     Tipo: XX
	//                xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx XXXX 999,999,999.999 9999,999,999.99 999,999,999.999 9999,999,999.99 999,999,999.999 9999,999,999.99 999,999,999.999 9999,999,999.99  9999.999999
	//                99/99/99 999/9999 xxxxxxxxxxxxxxxxxxxx 999999               999,999,999.999 9999,999,999.99 999,999,999.999 9999,999,999.99 999,999,999.999 9999,999,999.99 999,999,999.999 9999,999,999.99  9999.999999
	//                          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20
	//                0123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789

	If nLin > 68
		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		lImpCab := .T.
	End If

	If TRB->TRB_Local <> cLocAtu;											// Quebra de Local
	.or. TRB->TRB_CC <> cCCAtu;										// Quebra de CC
	.or. TRB->TRB_Tipo <> cTipAtu;									// Quebra de Tipo
	.or. lImpCab															// Quebra de Página

		If !lImpCab
			nLin++
		End If

		@ nLin,000 PSAY "Local: " + TRB->TRB_Local
		@ nLin,010 PSAY Left(Posicione('SX5',1,SX5->(xFilial())+'65'+TRB->TRB_Local,'X5_DESCRI'), 20)
		cLocAtu := TRB->TRB_Local

		@ nLin,035 PSAY "CC: " + Trim(TRB->TRB_CC)
		@ nLin,044 PSAY Left(Posicione("CTT",1,CTT->(xFilial())+TRB->TRB_CC,"CTT_DESC01"), 30)
		cCCAtu  := TRB->TRB_CC

		@ nLin,079 PSAY "Tipo: " + Trim(TRB->TRB_Tipo)
		@ nLin,090 PSAY Left(Posicione('SX5',1,SX5->(xFilial())+'02'+TRB->TRB_Tipo,'X5_DESCRI'), 20);		nLin += 2
		cTipAtu  := TRB->TRB_Tipo

	End If

	lImpCab := .f.

Return Nil
/*_______________________________________________________________________________
¦ Função    ¦ CstR05y    ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 09/06/2005 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Formatação do Parâmetro de exclusão de Grupos para Query          ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CstR05y(cTexto)

	Local cRetorno := "('"
	Local nIndTxt := 0
	Local lTrocou := .t.

	For nIndTxt := 1 To Len(Trim(cTexto))

		cCarac := Substr(cTexto, nIndTxt, 1)

		If IsAlpha(cCarac) .Or. IsDigit(cCarac)

			If lTrocou .And. Len(cRetorno) > 2
				cRetorno += ",'"
			End If

			cRetorno += cCarac
			lTrocou  := .f.

		Else

			If !lTrocou
				cRetorno += "'"
				lTrocou := .t.
			End If

		End If

	Next nIndTxt

	If !lTrocou
		cRetorno += "'"
	End If

	cRetorno += ")"

Return (If (Len(cRetorno) <= 4, "", cRetorno))
/*_______________________________________________________________________________
¦ Função    ¦ ValidPerg  ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 30/05/2005 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Criação das Perguntas da rotina.                                  ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidPerg(cPerg)

	u_InPutSX1(cPerg,"01","    Data de:","","","mv_ch1","D",08,0,0,"G","","",	"","","mv_par01")
	u_InPutSX1(cPerg,"02","   Data Até:","","","mv_ch2","D",08,0,0,"G","","",	"","","mv_par02")
	u_InPutSX1(cPerg,"03","   Local de:","","","mv_ch3","C",02,0,0,"G","","65",	"","","mv_par03")
	u_InPutSX1(cPerg,"04","  Local Até:","","","mv_ch4","C",02,0,0,"G","","65",	"","","mv_par04")
	u_InPutSX1(cPerg,"05"," C.Custo de:","","","mv_ch5","C",09,0,0,"G","","CTT","","","mv_par05")
	u_InPutSX1(cPerg,"06","C.Custo Até:","","","mv_ch6","C",09,0,0,"G","","CTT","","","mv_par06")
	u_InPutSX1(cPerg,"07","    Tipo de:","","","mv_ch7","C",02,0,0,"G","","02", "","","mv_par07")
	u_InPutSX1(cPerg,"08","   Tipo Até:","","","mv_ch8","C",02,0,0,"G","","02", "","","mv_par08")
	u_InPutSX1(cPerg,"09","  Código de:","","","mv_ch9","C",15,0,0,"G","","SB1","","","mv_par09")
	u_InPutSX1(cPerg,"10"," Código Até:","","","mv_cha","C",15,0,0,"G","","SB1","","","mv_par10")
	u_InPutSX1(cPerg,"11","  Relatório:","","","mv_chb","C",01,0,1,"C","","",	"","","Mv_Par11","Analítico",	"","","","Sintético")
	u_InPutSX1(cPerg,"12","  Ordenação:","","","mv_chc","C",01,0,1,"C","","",	"","","Mv_Par12","Digitação",	"","","","Sequência")
	u_InPutSX1(cPerg,"13"," Qual Moeda:","","","mv_chd","C",02,0,0,"G","","CTO","","","mv_par13")
	u_InPutSX1(cPerg,"14","Crit. Grupo:","","","mv_chf","C",01,0,1,"C","","",	"","","Mv_Par14","Considera",	"","","","Desconsidera")
	u_InPutSX1(cPerg,"15","     Grupos:","","","mv_chg","C",50,0,0,"G","","",	"","","MV_Par15")

Return Nil
