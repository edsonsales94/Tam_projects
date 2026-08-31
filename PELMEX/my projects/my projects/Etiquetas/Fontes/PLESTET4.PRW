#Include "rwmake.ch"

/*___________________________________________________________________________________
¦ Função    ¦ PLESTET4   ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 30/06/2010     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Impressão da Etiqueta da PROBEL						    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLESTET4(cNumOp,cSeq)
	Local oDlg
	Local cPerg := Padr("PLESTT",Len(SX1->X1_GRUPO))

	If cNumOp == Nil
		ValidPerg(cPerg)
		Pergunte(cPerg,.F.)

		@ 96,042 TO 323,505 DIALOG oDlg TITLE "Geração de Etiquetas"
		@ 08,010 TO 84,222

		@ 23,014 SAY "Esta rotina irá imprimir as informações das "
		@ 33,014 SAY "etiquetas da Pelmex."

		@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg,.T.)
		@ 91,168 BMPBUTTON TYPE 1 ACTION (PLESTT04A(cSeq), oDlg:End())
		@ 91,196 BMPBUTTON TYPE 2 ACTION oDlg:End()

		ACTIVATE DIALOG oDlg CENTERED
	Else
		mv_par01 := PADR(AllTrim(cNumOP),Len(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
		mv_par02 := 1
		PLESTT04A(cSeq)
	Endif

Return Nil

/*____________________________________________________________________________
¦ Função    ¦ PLESTT04A  ¦ Autor ¦ Ulisses Junior         ¦ Data ¦ 30/06/2010 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Distribuição das tarefas                                        ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PLESTT04A(cSeq)
	MsgRun("Preparando Ambiente... ","Aguarde...",{|| PLESTT04B()     })
	MsgRun("Imprimindo Etiquetas...","Aguarde...",{|| PLESTT04C(cSeq) })
Return Nil

/*________________________________________________________________________________
¦ Função    ¦ PLESTT04B  ¦ Autor   | Ulisses Junior          ¦ Data ¦ 30/06/2010 ¦
+-----------+------------+---------+-------------------------+------+------------+
¦ Descriçäo ¦ Montagem da query para leitura das OP's abertas                    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PLESTT04B()
	Local cQry

	cQry := "SELECT SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN AS C2_OP, SC2.C2_PRODUTO, SB1.B1_DESC, SB1.B1_COR, SC2.C2_QUANT, SC2.C2_YSLDIMP, SC2.C2_DATRF"
	cQry += " FROM " + RetSQLName("SC2") + " SC2"
	cQry += " INNER JOIN " + RetSQLName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = SC2.C2_PRODUTO"
	cQry += " AND SB1.B1_FILIAL = '" + SB1->(xFilial("SB1")) + "'"
	cQry += " WHERE SC2.D_E_L_E_T_ = ' '"
	cQry += " AND SC2.C2_FILIAL = '" + SC2->(xFilial("SC2")) + "'"
	cQry += " AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN = '" + mv_par01 + "'"
	cQry += " ORDER BY SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_PRODUTO"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,ChangeQuery(cQry)), "ETQ", .T., .T.)

Return Nil

/*________________________________________________________________________________
¦ Função    ¦ PLESTT04C  ¦ Revisão | Ulisses Junior          ¦ Data ¦ 30/06/2010 ¦
+-----------+------------+---------+-------------------------+------+------------+
¦ Descriçäo ¦ Impressão das Etiquetas.                                           ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PLESTT04C(cSeq)
	Local cCodBarProd, cCodBarExp, cSeqB1, nX
	Local cPorta := "LPT1"
	Local lOk    := .T.
	Local nQuant := Etq->C2_QUANT - Etq->C2_YSLDIMP

	Etq->(dbGotop())

	SZ4->(dbSetOrder(1))

	If cSeq == Nil   // Se sequência não foi informada
		If !Empty(Etq->C2_DATRF)
			Aviso("Atenção","Ordem de produção encerrada!", {"Ok"})
			lOk := .F.
		ElseIf nQuant = 0
			Aviso("Atenção","As etiquetas referentes a esta OP já foram impressas!", {"Ok"})
			lOk := .F.
		ElseIf mv_par02 > nQuant
			Aviso("Atenção","Quantidade solicitada é maior que o saldo de "+StrZero(nQuant,3)+" etiquetas!", {"Ok"})
			lOk := .F.
		EndIf
	ElseIf Etq->(Bof() .And. Eof())
		Aviso("Atenção","Ordem de Produção informada não existe "+Trim(mv_par01)+"!", {"Ok"})
		lOk := .F.
	ElseIf !SZ4->(dbSeek(XFILIAL("SZ4")+mv_par01+" "+cSeq)) .And. !SZ4->(dbSeek(XFILIAL("SZ4")+mv_par01+cSeq))
		Aviso("Atenção","Sequência informada ("+cSeq+") não existe para a Ordem de Produção!", {"Ok"})
		lOk := .F.
	Endif

	SB1->(dbSetOrder(1))
	SC2->(dbSetOrder(6))

	While !Etq->(Eof()) .And. lOk

		SB1->(dbSeek(xFilial("SB1")+Etq->C2_PRODUTO))

		For nX:=1 To mv_par02

			If cSeq == Nil
				RecLock("SB1",.F.)
				SB1->B1_CHASSIS := cSeqB1 := Soma1(SB1->B1_CHASSIS,6)
				MsUnLock()
			Else
				cSeqB1 := cSeq
			Endif

			cCodBarProd := Etq->C2_OP + cSeqB1 + " "
			cCodBarExp  := Etq->C2_PRODUTO + Etq->B1_COR + cSeqB1

			MsCbPrinter("Z4M","LPT1",,,.F.,,,,)
			MsCbChkStatus(.F.)

			MsCbBegin( 1, 6)

			MSCBWRITE("^XA~TA000~JSN^LT0^MMT^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2^MD10^JUS^LRN^CI0^XZ")
			MSCBWRITE("^XA^LL1500")
			MSCBWRITE("^PW1200")

			//1ST QUADRO
			MSCBWRITE("^FT46,63^A0N,50,50^FH\^FDPROBEL^FS")
			MSCBWRITE("^FT46,120^A0N,38,36^FH\^FDREFERENCIA: " + Etq->C2_PRODUTO + "^FS")
			MSCBWRITE("^FT46,180^A0N,38,36^FH\^FD" +AllTrim(SUBSTR(SB1->B1_DESC,1,40))+"  "+AllTrim(SB1->B1_XDIMENS) + "^FS")
			MSCBWRITE("^FT600,58^A0N,38,36^FH\^FDCNPJ: 04.321.519/0001-22^FS")
			MSCBWRITE("^FO40,210^GB1106,0,9^FS")

			MSCBWRITE("^FT46,278^A0N,38,36^FH\^FDCOMPOSICAO DO TECIDO:^FS")
			MSCBWRITE("^FT46,325^A0N,29,28^FH\^FD" + AllTrim(SUBSTR(SB1->B1_XCOMP ,1,50)) + "^FS")
			MSCBWRITE("^FT46,360^A0N,29,28^FH\^FD" + AllTrim(SUBSTR(SB1->B1_XCOMP1,1,50)) + "^FS")
			MSCBWRITE("^FT46,395^A0N,29,28^FH\^FD" + AllTrim(SUBSTR(SB1->B1_XCOMP2,1,50)) + "^FS")
			MSCBWRITE("^FT46,430^A0N,29,28^FH\^FD" + AllTrim(SUBSTR(SB1->B1_XCOMP3,1,50)) + "^FS")

			MSCBWRITE("^FT580,278^A0N,38,36^FH\^FDCUIDADOS PARA CONSERVACAO:^FS")
			MSCBWRITE("^FT580,325^A0N,29,28^FH\^FDNao lavar. Nao usar alvejante a base de cloro.^FS")
			MSCBWRITE("^FT580,360^A0N,29,28^FH\^FDNao secar em maquinas tambor rotativo.^FS")
			MSCBWRITE("^FT580,395^A0N,29,28^FH\^FDNao passar a ferro ou usar vaporizacao.^FS")
			MSCBWRITE("^FT580,430^A0N,29,28^FH\^FDNao limpar a seco. Nao usar solvente.^FS")

			MSCBWRITE("^FT46,500^A0N,38,36^FH\^FDPRODUCAO^FS")
			MSCBWRITE("^FT620,500^A0N,38,36^FH\^FDLOTE: " + SubStr(Etq->C2_OP,1,6) + "^FS") //ALTERADO POR ADSON 020713
			MSCBWRITE("^FT46,730^A0N,38,36^FH\^FDEXPEDICAO^FS")

			MSCBWRITE("^BY3,3,150^FT50,670^BCN,,Y,N")
			MSCBWRITE("^FD"+cCodBarProd+"^FS")
			MSCBWRITE("^BY3,3,150^FT50,895^BCN,,Y,N")
			MSCBWRITE("^FD"+cCodBarExp+"^FS")

			MsCbEnd() //Finaliza a montagem da imagem
			MsCbClosePrinter()

			If cSeq == Nil   // Se sequência não foi informada
				If SC2->(dbSeek(xFilial("SC2")+Etq->(C2_OP+C2_PRODUTO)))
					RecLock("SC2",.F.)
					SC2->C2_YSLDIMP := SC2->C2_YSLDIMP + 1
					MsUnLock()
				Endif

				GravaSZ4(cCodBarProd,cCodBarExp)
			Endif

		Next nX

		Etq->(dbSkip())
	Enddo
	Etq->(dbCloseArea())

Return .T.

/*_______________________________________________________________________________
¦ Função    ¦ ValidPerg  ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 30/06/2010 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Criação das Perguntas SX1                                         ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidPerg(cPerg)
	u_InPutSX1(cPerg,"01","OP		:  ","", "", "mv_ch1","C",11,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02","Etiquetas: ","", "", "mv_ch2","N",02,0,0,"G","","","","","mv_par02")
Return Nil

Static Function GravaSZ4(cProds,cExpeds)
	Local _Area := GetArea()

	RecLock("SZ4",.T.)
	SZ4->Z4_FILIAL  := xFilial("SZ4")
	SZ4->Z4_CPRODUC := cProds
	SZ4->Z4_CEXPEDI := cExpeds
	SZ4->Z4_DATA    := Date()
	SZ4->Z4_HORA    := Time()
	SZ4->Z4_USUARIO := cUserName
	SZ4->Z4_NUMERO  := 1
	SZ4->Z4_STATUS  := "I"
	MsUnLock()

	RestArea(_Area)

Return .T.
