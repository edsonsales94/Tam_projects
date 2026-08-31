#Include "rwmake.ch"

/*___________________________________________________________________________________
¦ Função    ¦ PLESTET3   ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 08/04/2008     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Impressão da Etiqueta da Pelmex (faixa)                               ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLESTET3(cNumOp,cSeq,nLogo)
	Local oDlg
	Local cPerg := PADR("ETQPEL2",Len(SX1->X1_GRUPO))

	If cNumOp == Nil
		ValidPerg(cPerg)
		Pergunte(cPerg,.F.)

		@ 96,042 TO 323,505 DIALOG oDlg TITLE "Geração de Etiquetas"
		@ 08,010 TO 84,222

		@ 23,014 SAY "Esta rotina irá imprimir as informações das "
		@ 33,014 SAY "etiquetas da Pelmex."

		@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg)
		@ 91,168 BMPBUTTON TYPE 1 ACTION (EtqPel01a(cSeq),oDlg:End())
		@ 91,196 BMPBUTTON TYPE 2 ACTION oDlg:End()

		ACTIVATE DIALOG oDlg CENTERED
	Else
		mv_par01 := PADR(AllTrim(cNumOP),Len(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
		mv_par02 := 1
		mv_par03 := If( nLogo == Nil , 1, nLogo)

		EtqPel01a(cSeq)
	Endif

Return Nil

/*_______________________________________________________________________________
¦ Função    ¦ ETQHPEL1a  ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 08/04/2008 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Distribuição das tarefas                                          ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function EtqPel01a(cSeq)

	MsgRun("Preparando Ambiente..." ,"Aguarde...",{|| EtqPel01b()     })
	MsgRun("Imprimindo Etiquetas...","Aguarde...",{|| EtqPel01c(cSeq) })

Return Nil

/*________________________________________________________________________________
¦ Função    ¦ EtqPel01b  ¦ Autor   | Ulisses Junior          ¦ Data ¦ 08/04/2008 ¦
+-----------+------------+---------+-------------------------+------+------------+
¦ Descriçäo ¦ Montagem da query para leitura das OP's abertas                    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function EtqPel01b
	Local cQry

	cQry := "SELECT SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN AS C2_OP, SC2.C2_PRODUTO, SB1.B1_DESC, SB1.B1_CODBAR, SB1.B1_COR, SC2.C2_QUANT, SC2.C2_YSLDIMP,"
	cQry += " SC2.C2_DATRF"
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
¦ Função    ¦ EtqPel01c  ¦ Revisão | Ulisses Junior          ¦ Data ¦ 08/04/2008 ¦
+-----------+------------+---------+-------------------------+------+------------+
¦ Descriçäo ¦ Impressão das Etiquetas.                                           ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function EtqPel01c(cSeq)
	Local cCodBarProd, cCodBarExp, cSeqB1, nX
	Local cPorta := "LPT1"
	Local lOk    := .T.
	Local nQuant := Etq->C2_QUANT - Etq->C2_YSLDIMP
	Local cLogo  := "~DG000.GRF,07680,048,"+;
	",:::::::::::::::::::::::::::::I080AEYEAEHEAEHEAEHEAEAEAEAEAEAEAEAEJEAEHEAEHEAEYE8,J015jG54,J0jIAB,I015H510H010H010H010hP010H010H010H015I5,I02EEAiYAIE0,I0H540iX015540,I02AHA2A2A2A2A2A2A2A2AHA2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2AHA0,I0H5jG0I50,I0HEjHAHE0,I05440404040404040H040H040H040H040H040H040H040H040H040H040H040H040H040H040H04040404041550,I0jLA0,I0540j01550,I0AEAjHAE0,I0540404040404040404040404040404040404040404040404040404040404040404040404040404040405H50,I0jLA0,I0540j01550,I0HEjHAHE0,I054jG4I50,I0OA8202020202AIA2A2A2A2A2AA22AgA2A2A2A2A2AYA0,I0H5M1Q010P01001I101H1R010O0H1H0101K1H0J1H50,I0AEALA80O0HAP0HAH0NAQ0A80N02A802ALA802AIAE0,I054M4Q0H4P0H4H0N4Q040P0H4H0M4I0H4I50,I0OA80O02A0O0HA02AMAQ0A80N02AA002AJA8002AJA0,I0H5M1H0M1H01001O1H0I101H1010H010H010H01001M10110H0K1H0K1H50,I0EAMA802AKA802A00AOAH0NAH0HA802AA00A80APAH80AJAH02AIAHE0,I054M4H0M4H0H4H0P4H0N4H0H4I0H4H04004Q4I0I4I0J4I50,I0OA802AKA802A00AOA02AMAH0HA802AA00A802APA800AHAH02ALA0,I0H5M1H0M1H01001O1H0O1H0H1H0H1I01001Q1I0H1I0K1I50,I0AEALA802AKA802A00AOAH0NAH0HA802AA00A80ARAI0HAH0KAEAE0,I054M4Q0H4I04040404H4H0N4H0H4I0H4H040H04040404K4I0H4H0I4K50,I0OA80O02A0N02AA02AMAH0HA802AA00A80N0LAH02A8ANA0,I0H5M1gH010H01010101010H010H010H010P0101010H010115L50,I0HEMA80080L0HAO02AA00AMA80AA802AA00A80N0LA8002AAEAEKE0,I0I5K450P0H4P0H4H0N4H0H4I0H4H040O0M4I0P50,I0OA802AOAH0PA02AMAH0HA802AA00A802ASAI02ANA0,I0K5J1H0P1H0P1H0O1H0H1H0H1I01001S1J015N50,I0AEAEAEAHA802AOAH0PAH0NAH0HA802AA00A80ASAK0EAEAEAEAE0,I0L5I4H0Q4H0P4H0N4H0H4I0H4H04004R4I040015M50,I0OA802AOAH0PA02AMAH0HA802AA00A802AQAI0A0H0NA0,I0O5H0I101H1011001010101011001010101010H010H010H010H010101H10115400150H0N50,I0EAEHEAEAE802AOAH0PAH0NAH0HA802AA00A80AOAEA800AEA002EEAEAEA0,I0O5H054O4P0H4O0400440H0H4H040O0I540015H5I0M50,I0OA802AOAP0HAO0A00AA802AA00A80N02AA8002AHA8002AKA0,I0O5H0J5L1Q010N0H1H0H1H0H1I010O01540H0J540015K50,I0AEAEAEAEA806AOAP0HAO0A80AHA0AHA80A80N02A8002AHAEA800AEAEAE0,I0O5H4M5J4O0I4N0M404K404M4H540H0L54005K50,I0iMA8002ALAH02AJA0,I0gI51010101010101010101010101010115R540H0N5H0L50,I0IEAEAEAEAEAEAEAEAEAEAEAEAgLAEAEAEAEAEAEAEE8002EAEAEAEAEHEAEAEE0,I0gS5M4545gH540H0W50,I0iKAI02AVA0,I0iJ5J0X50,I0AEAHAEAEAEAHAEAHAEALAEAgTAEAA0H02AEAHAEAHAEAHAEAEAE0,I0iI5J0Y50,I0iHA80H02AXA0,I0iG540H015Y50,I0EAEAEAAEEAEAEAEAEAEAEAEAEAEAHAEAHAEAHAEAHAEAHAEAHAEAHAEAHAEAA8800AEAEAEAEAEAEAEAEAEAEA0,I0K54005hQ5J0gH50,I0LAI02AhNA80H02AgGA0,I0K540J0hM5K0N5415R50,I0IAEAE0K0hKAE0I0EANA8AAEAHAEAHAEAE0,I0L5N0hH540I015M54545R50,I0NAM02AgYAJ02ANA8A8ARA0,I0N540M015gU5K0H1O504015Q50,I0EAEAEAEAEE80M0AEAEAJAEAHAEAHAEAHAEAHAEAJAEAE800800AEAHAEAEA8AE0E8AAEAEAEAEAEA0,I0Q540O0gO5M0P541515S50,I0SA80O0gLAM0QAH828ASA0,I0U5R015X5O0P54544145S50,I0AEAEAEAHAEAEAEAEA80R0HAEALAEAA80N02AQA2A88EANAEAEAE0,I0X540gS0Q5455145V50,I0gGAgP02AQAH2A0A2AUA0,I0gH540gL015Q54100445V50,I0EAEAEAEAEAEAEAEAEAEAHAEAEA80g0SAEAHA8EA2AEAEAEAEAEAEAEAEA0,I0gN540U015U505145415V50,I0gUAK02AXA02A08A2AXA0,I0hW515151040515X50,I0IAEAhRA8A2A88A86AVAEAE0,I0hV50441544545g50,I0SA2AhGA2AA2A8A2AgGA0,I0R5H0H1V515H515H515H515H515H50155115154515gG50,I0EAEAEAEAEAEA8AA882AAEALAEAPAEAMAH8HA8AA8028E8AAEAHAEAEAEAEAEAEAEAEAEA0,I0R50551550545gJ5454545445I51405gJ50,I0SA0AIA82A2A8AA2AUAH0282A2A2AA2AgPA0,I0Q545450010505515510541140040040155151H1510140150015gL50,I0AEAOA2A2AHA82AHA8AA282828A8A8AHAE8AIA288A08A8A8AWAEALAEAEAE0,I0R50451551105515515155154545545I51051451451545gP50,I0SA2A2AIA2AA8AA282A28A8A800A00AA82A02H2A28AgRA0,I0U5H05104551551H101154545I5451H14141I1gT50,I0EAEAEAEAEAEAEAEAIA8EAE8AHAH82A8A8A8AgKAEAHAEAHAEAEAEAEAEAEAEAEA0,I0gI5H0H514451545454400551545gY50,I0gPA28A8A800AA2AhJA0,I0jL50,I0IAEAiXAEAE0,I0jL50,I0jLA0,I0gN515H515151515151515151515151515H515gJ50,I0EAEAEAEAEAEAEAHAEAHAEAhLAEAHAEAEAEAEAEAEAEA0,I0jL50,I0jLA0,I0jL50,I0AEAHAEAiTAEAHAE0,I0jL50,I02AjJA0,I0gP515H515H515151515151515H5151515gK540,I02AEAEAEAEAEAHAEAHAEAhLAEAHAEAHAEAEAEAEAEAEA0,I015jI540,J0jJA,J015jG54,K0jGAE0,,::::::::::::::::::::"

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

			MsCbPrinter("ZM400","LPT1",,,.F.,,,,)
			MsCbChkStatus(.F.)

			MsCbBegin( 1, 6)

			If mv_par03 == 1
				MSCBWRITE("^XA~TA000~JSN^LT0^MMT^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2^MD10^JUS^LRN^CI0^XZ"+cLogo+"^XA^LL1500")
				MSCBWRITE("^PW1200")
				MSCBWRITE("^FT32,160^XG000.GRF,1,1^FS")
				MSCBWRITE("^FT44,259^A0N,33,33^FH\^FDPRODUCAO^FS")
				MSCBWRITE("^FO44,197^GB1002,0,7^FS")
				MSCBWRITE("^FT44,184^A0N,37,36^FH\^FD" + Etq->C2_PRODUTO + Etq->B1_DESC + "^FS")
				MSCBWRITE("^BY4,3,195^FT48,475^BCN,,Y,N")
				MSCBWRITE("^FD" + cCodBarProd + "^FS")
				MSCBWRITE("^PQ1,0,1,Y^XZ")
				MSCBWRITE("^XA^ID000.GRF^FS^XZ")
			Else
				MSCBWRITE("^XA~TA000~JSN^LT0^MMT^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2^MD10^JUS^LRN^CI0^XZ")
				MSCBWRITE("^XA^LL1500")
				MSCBWRITE("^PW1200")
				MSCBWRITE("^FT47,163^A0N,33,33^FH\^FDPRODUCAO^FS")
				MSCBWRITE("^FO47,102^GB1002,0,6^FS")
				MSCBWRITE("^FT47,88^A0N,37,36^FH\^FD" + Etq->C2_PRODUTO + Etq->B1_DESC + "^FS")
				MSCBWRITE("^BY4,3,195^FT48,379^BCN,,Y,N")
				MSCBWRITE("^FD" + cCodBarProd + "^FS")
				MSCBWRITE("^PQ1,0,1,Y^XZ")
			EndIf

			MsCbEnd()
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
¦ Função    ¦ ValidPerg  ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 23/11/2006 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Criação das Perguntas SX1                                         ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidPerg(cPerg)
	u_InPutSX1(cPerg,"01","OP		 : ","", "", "mv_ch1","C",11,0,0,"G","","SC2","","","mv_par01")
	u_InPutSX1(cPerg,"02","Etiquetas: ","", "", "mv_ch2","N",02,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03","Logo	    ? ","", "", "mv_ch3","N",01,0,0,"C","","","","","mv_par03","Sim","","","","Nao")
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
