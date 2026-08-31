#Include "rwmake.ch"

/*___________________________________________________________________________________
¦ Função    ¦ PLESTETQ   ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 08/04/2008     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Impressão da Etiqueta da Pelmex (producao)                            ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLESTETQ01(cNumOP,cSeq)
	Local oDlg
	Local cPerg := PADR("ETQPEL",Len(SX1->X1_GRUPO))

	If cNumOP == Nil
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
	Local cLogo  := "~DG001.GRF,09216,048,,:::::::::::::::J080H080H080H080H080H080H080H080H080H080H080H080H080H080H080,"+;
	"H080H080H080H080H080H080H080H080,,M03FjGF,L037FjGF80,L07FjHFA8,L0jKF8,K02FjJFC,L0jKFC,K03FjJFE,K07FjKF,"+;
	"::K0jMF80,K07FjKF80,K0jMF,K0jMF80,J08FjLFC0,K0jMFC0,::::::::::::::J08FjLFC0,K0jMFC0,:::K0gHFBFRF87FKFEC0M03FQFEFMFCB7FMFC0,"+;
	"K0SF80020H020FFE0H020H023FE23FLF80020H0200FE0H020H021FFBFMF9FNFC0,K0SF80M01FC0N07C01FLFP07E0N07A03FKFE05FMFC0,"+;
	"K0SF80H080H080FC80H080H08FC09FLF80H080H080FE80H080H08780FLFA87FMFC0,K0SF80N03C0N07C01FLFP07E0N01801FJFD001FMFC0,"+;
	"K0SF80N03C0N03E03FLFP07E0N01802FKFH01FMFC0,K0SF80N03C0N07C01FLFP07E0N01800FKFH03FMFC0,K0SF80N03C0N0BC01FLFP0FE0N0F800BFIFC00BFMFC0,"+;
	"K0SF80N03C0N0FC01FLFP07E0N078003FIFC017FMFC0,K0SF807FJFC03C03FMFC01FLFH0HF80BF807E03FMFE002FHFE801FNFC0,"+;
	"K0SF807FJFC03C03FMFC01FLFH0HF80FF807E03FMFE001FHFE0037FMFC0,J08FRF80FKFC0BC03FMFC01FLF80FF80FF80FE03FNF800FHFE807FNFC0,"+;
	"K0SF807FJFC03C03FMFC01FLFH0HF80FF807E03FNFI0IFE007FNFC0,K0SF807FJFE03C03FMFE03FLFH0HF80FF807E03FNFC007FEC007FNFC0,"+;
	"K0SF807FJFC03C03FMFC01FLFH0HF80FF807E03FNFE001FE8007FNFC0,K0SF80FKFC03C03FMFC01FLFH0HF80FF80FE03FNFE0H0FE803FOFC0,"+;
	"K0SF807FJFC03C03FMFC01FLFH0HF80FF807E03FOFI0FE003FOFC0,K0SF807FJFC03E03FMFC01FLFH0HF80FF807E03FOFC003E007FOFC0,"+;
	"K0SF807FJFC03C03FMFC01FLFH0HF80FF807E03FOFC001C00FPFC0,K0SF80FKFC03C83FMFC09FLF80FF80FF80FE83FOFE001E80FPFC0,"+;
	"K0SF80N03C0M07FC01FLFH0HF80FF807E0M03FIFH017C3FPFC0,K0SF80N03C0M03FE03FLFH0HF80FF807E0M03FIFI07CBFPFC0,"+;
	"K0SF80N03C0M01FC01FLFH0HF80FF807E0M01FIFC001FBFPFC0,K0SF80N07C0M01FC01FLFH0HF80FF80FE0N0JFC003FRFC0,"+;
	"K0SF80N03C0M01FC01FLFH0HF80FF807E0N07FHFE001EFQFC0,K0SF80N07C0M01FC01FLFH0HF80FF807E0N0KF800BFQFC0,"+;
	":J08FRF8080H080H0BC0080H0801FC01FLF80FF80FF80FE0080H0800FJFC00BFQFC0,K0SF80M03FC0M03FC01FLFH0HF80FF807E0M03FJFI01FQFC0,"+;
	"K0SF807FKFEFC00202021BFE03FLFH0HF80FF807E00202020FJFE0H01FQFC0,K0SF807FMFC01FMFC01FLFH0HF80FF807E03FPF80I07FPFC0,"+;
	"K0SF80FNFC03FMFC01FLFH0HF80FF80FE03FPFC0I0BFPFC0,K0SF807FMFC03FMFC01FLFH0HF80FF807E03FPF80I03FPFC0,"+;
	"K0SF807FMFE03FMFC01FLFH0HF80FF807E03FPFK02FPFC0,K0SF807FMFC03FMFC01FLFH0HF80FF807E03FOFE0K0QFC0,"+;
	"K0SF80FNFC83FMFC09FLF80FF80FF80FE83FOF8001800BFOFC0,K0SF807FMFC03FMFC01FLFH0HF80FF807E03FOF80018007FOFC0,"+;
	"K0SF807FMFC03FMFE03FLFH0HF80FF807E03FOFI03E003FOFC0,K0SF807FMFC0M03FC0L01F00FF80FF807E0M03FFB001FF0017FNFC0,"+;
	"K0SF80FNFC008K89FC008J89F00FF80FF80FE008K8AFFA001FF800FOFC0,K0SF807FMFC0M01FC0L01F00FF80FF807E0M02FFA001FF0H07FNFC0,"+;
	"K0SF807FMFC0M017C0M0F00FF80FF807E0N07F0H01FF8003FNFC0,K0SF807FMFC0N07C0M0700FF80FF807E0N03E001FHFC003FNFC0,"+;
	"J08FRF80FNFC0080H0800BC0H080H08F80FF80FF80FE0080H08001A001FHFE800FNFC0,K0SF807FMFC0N03C0M0E00FF807F807E0N018001FHFE0H07FMFC0,"+;
	"K0SF807FMFC0N0FE0M0781FF807F80FE0N018002FIFI07FMFC0,K0SF807FMFC0N03C0M0E82FF80FFC17E0N078007FIF8007FMFC0,"+;
	"K0SF80FNFC0M01FE0M0FC2FF81FFE3FE0M01E800FIFEC00FNFC0,K0iLFC003FJFE003FMFC0,K0iLF8002FKFH03FMFC0,K0iLF800BFKF803FMFC0,"+;
	"K0iKFC0H0MFC8FNFC0,K0iKFC001FLFD07FMFC0,K0iJFC0H03FWFC0,:K0iJFE0H0YFC0,K0iJF4003FXFC0,K0iJF8001FXFC0,K0iIFE0H03FXFC0,J08FiHFE001FYFC0,"+;
	"K0iHFE0H01FYFC0,K0iHF40H03FYFC0,K0iHFC0H07FYFC0,K0iHFI01FgFC0,K0iFE0I07FgFC0,K0iGFI01BFgFC0,K0PFC6FhLFD0I03FgGFC0,K0PF8BFhLFE8800BFgGFC0,"+;
	"K0PF81FhLFE0I0BFgGFC0,K0PF8037FhJFA0H01FgHFC0,K0OFE0013FhIFD0I03FgHFC0,K0OFE0H01FhIFC0I0BFgHFC0,K0OFE0I017FhGFJ03FgIFC0,K0OFE0J03FhF80I03FgIFC0,"+;
	"K0OFE0L0gYF580H01FgJFC0,J08FNFE880H080FgXF800808FgJFC0,K0OFE0M0gWFE0J0gLFC0,K0QF60K03FgTFH8J05FgKFC0,K0QF70L01FgSF80I01FgLFC0,K0RFE80L0gRFE0J03FgLFC0,"+;
	"K0RFDC0L02FgOFC0J027FgLFC0,K0TF80M02FgKFE0L07FgMFC0,K0TF80M02DFgJFE0L07FgMFC0,K0TFE8080H0800BFgJFC8080H08FgNFC0,K0TFEC0N07FgIF80K03FgNFC0,"+;
	"K0VFC0N01ABFYFM03FgOFC0,K0WFA0N020FWF080K0H3gPFC0,K0XFD0O0B8BE9FMFE9E9A0L01FgQFC0,K0YF40R017FLFA10O03FgQFC0,K0YFC10R02067E480R06FgQFC0,K0gGF40gP0gTFC0,"+;
	"J08FgGFC80H080H080H080H080H080H080H0AFgTFC0,K0gIFE40gK0gVFC0,K0gKF20gH030FgUFC0,K0gJFDFC0g01FgWFC0,K0gLFE880W09FgXFC0,K0gLFE0Y017FgWFC0,K0gMFEF920S0237FgXFC0,"+;
	"K0gQFE0O060FhHFC0,K0gQFCEBFIFEFHFE9FhHFC0,K0jMFC0,::::::J08FjLFC0,K0jMFC0,::::K0jMF80,::K0jMF,:K07FjKF,K07FjKF80,K01FjJFC,K03FjKF,K01FjJFE,J080FjIFE880,L0jJFE0,"+;
	"L0jKF8,M06,M0C8jH80,,::::::::::~DG002.GRF,02944,092,nYF8,:::::::,:::::::::::::::::::::::"

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
	ElseIf !SZ4->(dbSeek(XFILIAL("SZ4")+mv_par01+" "+cSeq))
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

			cCodBarProd := Etq->C2_OP + cSeqB1
			cCodBarExp  := Etq->C2_PRODUTO + Etq->B1_COR + cSeqB1

			MsCbPrinter("ZM400","LPT1",,,.F.,,,,)
			MsCbChkStatus(.F.)

			MsCbBegin( 1, 6)

			MSCBWRITE("^XA~TA000~JSN^LT0^MMT^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2^MD10^JUS^LRN^CI0^XZ"+cLogo+"^XA^LL1200")
			MSCBWRITE("^PW1200")
			MSCBWRITE("^FT" + "10,230"   + "^XG" + "001.GRF,"+ "1,1" + "^FS")	//Logo
			MSCBWRITE("^BY5,2,125^FT608,193^BEN,,Y,N")
			MSCBWRITE("^FD"+SubStr(AllTrim(Etq->B1_CODBAR),1,12)+"^FS")

			MSCBWRITE("^FT" + "42,298"  + "^A0N," + "40,38" + " ^FH\^FD" + Etq->B1_DESC + "^FS")
			MSCBWRITE("^FT" + "42,343"  + "^XG" + "002.GRF,"+ "1,1" + "^FS")	//LINHA

			MSCBWRITE("^FT" + "35,376"   + "^A0N," + "28,60"         + "^FH\^FD" + "PRODUCAO " + "^FS")
			MSCBWRITE("^BY3,3,195^FT55,630^BCN,,Y,N")
			MSCBWRITE("^FD" + cCodBarProd + " " + "^FS") //ALTERADO POR LUIZ - ESPACOS ENTRE CARACTERES

			MSCBWRITE("^FT" + "608,376"  + "^A0N," + "28,60"         + "^FH\^FD" + "LOTE:  " + SubStr(Etq->C2_OP,1,6) + "^FS") //ALTERADO POR ADSON 020713

			MSCBWRITE("^FT" + "35,710"   + "^A0N," + "28,60"         + "^FH\^FD" + "EXPEDICAO" + "^FS")
			MSCBWRITE("^BY3,3,190^FT55,917^BCN,,Y,N")
			MSCBWRITE("^FD" + cCodBarExp + " " + "^FS") //ALTERADO POR LUIZ - ESPACOS ENTRE CARACTERES

			MSCBWRITE("^FT" + "35,1050"   + "^A0N," + "40,38"         + "^FH\^FD" + "COMPOSICAO DO TECIDO: "  + "^FS")

			nLin := 1090
			if !EMPTY(SB1->B1_XCOMP) //Len(Alltrim(SB1->B1_XCOMP)) <> 0
				MSCBWRITE("^FT" + "42," + Alltrim(Str(nLin)) + "^A0N," + "20,28" + "^FH\^FD" + SB1->B1_XCOMP + "^FS")
				nLin += 30
			EndIf
			if !EMPTY(SB1->B1_XCOMP1) //Len(Alltrim(SB1->B1_XCOMP1)) <> 0
				MSCBWRITE("^FT" + "42," + Alltrim(Str(nLin)) + "^A0N," + "20,28" + "^FH\^FD" + SB1->B1_XCOMP1 + "^FS")
				nLin += 30
			EndIf
			if !EMPTY(SB1->B1_XCOMP2) //Len(Alltrim(SB1->B1_XCOMP2)) <> 0
				MSCBWRITE("^FT" + "42," + Alltrim(Str(nLin)) + "^A0N," + "20,28" + "^FH\^FD" + SB1->B1_XCOMP2 + "^FS")
				nLin += 30
			EndIf
			if !EMPTY(SB1->B1_XCOMP3) //Len(Alltrim(SB1->B1_XCOMP3)) <> 0
				MSCBWRITE("^FT" + "42," + Alltrim(Str(nLin)) + "^A0N," + "20,28" + "^FH\^FD" + SB1->B1_XCOMP3 + "^FS")
				nLin += 30
			EndIf

			MSCBWRITE("^FT" + "42,1050"   + "^A0N," + "40,38"         + "^FH\^FD" + "                                              CUIDADOS PARA CONSERVACAO: "  + "^FS")
			MSCBWRITE("^FT" + "42,1090"   + "^A0N," + "20,28"         + "^FH\^FD" + "                                                                 NAO LAVAR   " + "^FS")
			MSCBWRITE("^FT" + "42,1120"   + "^A0N," + "20,28"         + "^FH\^FD" + "                                                                 NAO USAR ALVEJANTE A BASE DE CLORO" + "^FS")
			MSCBWRITE("^FT" + "42,1150"   + "^A0N," + "20,28"         + "^FH\^FD" + "                                                                 NAO SECAR EM MAQUINAS TAMBOR ROTATIVO" + "^FS")
			MSCBWRITE("^FT" + "42,1180"   + "^A0N," + "20,28"         + "^FH\^FD" + "                                                                 NAO PASSAR A FERRO OU USAR VAPORIZACAO" + "^FS")
			MSCBWRITE("^FT" + "42,1210"   + "^A0N," + "20,28"         + "^FH\^FD" + "                                                                 NAO LIMPAR A SECO, NAO USAR SOLVENTE" + "^FS")

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
	u_InPutSX1(cPerg,"01","OP		: ","", "", "mv_ch1","C",11,0,0,"G","","","","","mv_par01")
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