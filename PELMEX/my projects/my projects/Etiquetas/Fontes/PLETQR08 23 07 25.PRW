#Include "rwmake.ch"

/*___________________________________________________________________________________
¦ Função    ¦ PLETQR01   ¦ Autor ¦ Stan Lee Lopes           ¦ Data ¦ 22/01/2019     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Impressão da Etiqueta da Pelmex (producao)                            ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLETQR08(cNumOP,cSeq)
	Local oDlg
	Local cPerg := "PLETQR08"

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
		//mv_par01 := PADR(AllTrim(cNumOP),Len(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
		//mv_par02 := 1
		//mv_par03 := PADR(AllTrim(cNumOP),Len(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))

		EtqPel01a(cSeq)
	Endif

Return Nil

/*_______________________________________________________________________________
¦ Função    ¦ ETQHPEL1a  ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 08/04/2008 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Distribuição das tarefas                          
¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function EtqPel01a(cSeq)

	MsgRun("Preparando Ambiente..." ,"Aguarde...",{|| EtqPel01b()     })
	MsgRun("Imprimindo Etiquetas...","Aguarde...",{|| EtqPel01c(cSeq) })

Return Nil

/*________________________________________________________________________________
¦ Função    ¦ EtqPel01b  ¦ Autor   | Stan Lee Lopes          ¦ Data ¦ 22/01/2019 ¦
+-----------+------------+---------+-------------------------+------+------------+
¦ Descriçäo ¦ Montagem da query para leitura das OP's abertas                    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function EtqPel01b
	Local cQry

	cQry := "SELECT SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN AS C2_OP,*"
	cQry += " FROM " + RetSQLName("SC2") + " SC2"
	cQry += " INNER JOIN " + RetSQLName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = SC2.C2_PRODUTO"
	cQry += " WHERE SC2.D_E_L_E_T_ = ' '"
	cQry += " AND SC2.C2_FILIAL = '" + SC2->(xFilial("SC2")) + "'"
	cQry += " AND SC2.C2_NUM BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
	cQry += " ORDER BY SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_PRODUTO"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,ChangeQuery(cQry)), "ETQ", .T., .T.)

Return Nil

/*________________________________________________________________________________
¦ Função    ¦ EtqPel01c  ¦ Revisão | Stan Lee Lopes          ¦ Data ¦ 22/01/2019 ¦
+-----------+------------+---------+-------------------------+------+------------+
¦ Descriçäo ¦ Impressão das Etiquetas.                                           ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function EtqPel01c(cSeq)
	Local cCodBarProd, cCodBarExp, cSeqB1, nX
	Local cLinha   := Array(16)
	Local cLinhaAviso   := Array(6)
	Local _cAux    := ""
	Local _cAviso  := ""
	Local _cModelo := ""
	Local nP       := 0
	Local nP1      := 0
	Local FimRegistro :=0
	//	Local cPorta   := "LPT1"
	Local lOk      := .T.
	Local nQuant   := Etq->C2_QUANT - Etq->C2_YSLDIMP
	Local cLogo    := "~DG001.GRF,09216,048,,:::::::::::::::J080H080H080H080H080H080H080H080H080H080H080H080H080H080H080,"+;
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

	nQuant   := Etq->C2_QUANT - Etq->C2_YSLDIMP 

	If cSeq == Nil   // Se sequência não foi informada
		If !Empty(Etq->C2_DATRF)
			Aviso("Atenção","Ordem de produção encerrada!", {"Ok"})
			lOk := .F.
		ElseIf nQuant = 0
			Aviso("Atenção","As etiquetas referentes a esta OP já foram impressas!", {"Ok"})
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
		FimRegistro := Etq->C2_QUANT - Etq->C2_YSLDIMP
		//For nX:=1 To mv_par02
		For nX := 1 To FimRegistro

			If cSeq == Nil
				RecLock("SB1",.F.)
				SB1->B1_CHASSIS := cSeqB1 := Soma1(SB1->B1_CHASSIS,6)
				MsUnLock()
			Else
				cSeqB1 := cSeq
			Endif

			cCodBarProd := Etq->C2_OP + cSeqB1
			cCodBarExp  := Etq->C2_PRODUTO + Etq->B1_COR + cSeqB1

			cPesq    := ";"
			nP       := 1
			_cAux    := AllTrim(Etq->B1_DESC)
			//_cAviso  := AllTrim(Etq->B1_AVISO)

			_cAux    := STRTRAN(_cAux,"ã","\C6")
			_cAux    := STRTRAN(_cAux,"á","\A0")
			_cAux    := STRTRAN(_cAux,"â","\83")
			_cAux    := STRTRAN(_cAux,"Á","\B5")
			_cAux    := STRTRAN(_cAux,"Â","\B6")
			_cAux    := STRTRAN(_cAux,"Ã","\C7")
			_cAux    := STRTRAN(_cAux,"é","\82")
			_cAux    := STRTRAN(_cAux,"ê","\88")
			_cAux    := STRTRAN(_cAux,"É","\90")
			_cAux    := STRTRAN(_cAux,"Ê","\D2")
			_cAux    := STRTRAN(_cAux,"ó","\A2")
			_cAux    := STRTRAN(_cAux,"ô","\93")
			_cAux    := STRTRAN(_cAux,"õ","\E4")
			_cAux    := STRTRAN(_cAux,"Ó","\E3")
			_cAux    := STRTRAN(_cAux,"Ô","\E2")
			_cAux    := STRTRAN(_cAux,"Õ","\E5")
			_cAux    := STRTRAN(_cAux,"ú","\A3")
			_cAux    := STRTRAN(_cAux,"Ú","\E9")
			_cAux    := STRTRAN(_cAux,"í","\A1")
			_cAux    := STRTRAN(_cAux,"ç","\87")
			_cAux    := STRTRAN(_cAux,"Ç","\80")
			_cAux    := STRTRAN(_cAux,"²","\FD")
			_cAux    := STRTRAN(_cAux,"³","\FC")

			//_cAux    := "Espuma convencional 100% Poliuretano Flexível Classificação: Simples;Uso: Geral;"
			//"Espuma convencional D-20Kg/m³ 9cm;"+
			//"Revestimento; Tecido plano jacquard78% Poliéster e 22% Polipropileno 115g/m²com tratamento Ultra Fresh em matelassê;"+
			//"Espuma convencional D-18Kg/m³;"+
			//"TNT (Tecido nao tecido);"+
			//"Garantia da Espuma: 1 ano;"+
			//"Garantia de outros materiais: 6 meses;"             
		/*
			For I := 1 To 16 Step 1
				cLinha[I]  := SubStr(_cAux,nP,AT(cPesq,_cAux)-1)
				nP := AT(cPesq,_cAux) + 1
				_cAux := SubStr(_cAux,nP)
				nP := 1
			Next

			if !(AllTrim(Etq->B1_DESC) == "")
				cPesq1    := ";"
				nP1       := 1
				//_cAviso    := Etq->B1_AVISO

				_cAviso    := STRTRAN(_cAviso,"ã","\C6")
				_cAviso    := STRTRAN(_cAviso,"á","\A0")
				_cAviso    := STRTRAN(_cAviso,"â","\83")
				_cAviso    := STRTRAN(_cAviso,"Á","\B5")
				_cAviso    := STRTRAN(_cAviso,"Â","\B6")
				_cAviso    := STRTRAN(_cAviso,"Ã","\C7")
				_cAviso    := STRTRAN(_cAviso,"é","\82")
				_cAviso    := STRTRAN(_cAviso,"ê","\88")
				_cAviso    := STRTRAN(_cAviso,"É","\90")
				_cAviso    := STRTRAN(_cAviso,"Ê","\D2")
				_cAviso    := STRTRAN(_cAviso,"ó","\A2")
				_cAviso    := STRTRAN(_cAviso,"ô","\93")
				_cAviso    := STRTRAN(_cAviso,"õ","\E4")
				_cAviso    := STRTRAN(_cAviso,"Ó","\E3")
				_cAviso    := STRTRAN(_cAviso,"Ô","\E2")
				_cAviso    := STRTRAN(_cAviso,"Õ","\E5")
				_cAviso    := STRTRAN(_cAviso,"ú","\A3")
				_cAviso    := STRTRAN(_cAviso,"Ú","\E9")
				_cAviso    := STRTRAN(_cAviso,"í","\A1")
				_cAviso    := STRTRAN(_cAviso,"ç","\87")
				_cAviso    := STRTRAN(_cAviso,"Ç","\80")
				_cAviso    := STRTRAN(_cAviso,"²","\FD")
				_cAviso    := STRTRAN(_cAviso,"³","\FC")

				For I := 1 To 6 Step 1
					cLinhaAviso[I]  := SubStr(_cAviso,nP1,AT(cPesq1,_cAviso)-1)
					nP1 := AT(cPesq1,_cAviso) + 1
					_cAviso := SubStr(_cAviso,nP1)
					nP1 := 1
				Next   
			EndIf*/

			_cModelo := Etq->B1_XMODELO

			//MsCbPrinter("ZM400","LPT1",,,.F.,,,,)\\
			/*
			If (!(AllTrim(Etq->B1_AVISO) == "") .or. (AllTrim(Etq->B1_XETIQUE) == "")).and. (!(AllTrim(Etq->B1_XEMPRES) == "CAPA PROTETORA ANTIESTATICA") .or. !(AllTrim(Etq->B1_XEMPRES) == "CAPA PROTETORA TOPER ANTIESTATICA"))
			MsCbPrinter("ZM600","LPT2",,,.F.,,,,)
			else
			MsCbPrinter("ZM400","LPT1",,,.F.,,,,)
			endif

			MsCbChkStatus(.F.)
			MsCbBegin( 1, 6)                                                       
			*/  

			//COLCHÃO COM A ETIQUETA SEM AVISO



			MsCbPrinter("ZM400","LPT1",,,.F.,,,,)
			MsCbChkStatus(.F.)
			MsCbBegin( 1, 6)

			MSCBWRITE("CT~~CD,~CC^~CT~")
			MSCBWRITE("^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2~SD25^JUS^LRN^CI0^XZ")
			MSCBWRITE("^XA")
			MSCBWRITE("^MMT")
			MSCBWRITE("^PW2362")
			MSCBWRITE("^LL1890")
			MSCBWRITE("^LS0")
			MSCBWRITE("^FO0,0^GFA,56576,56576,00104,:Z64:")
			MSCBWRITE("eJzsXL9v3MgVfqSWMc3N2StAAgLjcNisCxk0YAUpfYCPAda9DtDCKc5Inyop3CTFDVxteID9HxiEKmIc2CkP8sF2keKQKoVdBhBSCQpgp0ghKICV994MudR6paWW+8aIwGdr+HP38duP37w3w+EAt")
			MSCBWRITE("NZaa6211lprrbXWWmuttdZaa6211lprrbXWWmutXQRTn/oCWmvt/9duqE99Bcu1wae+gCVb7MhPx5EfV3g8N25UrNw4Grpx44wfV9bqZzFbd+RHKzd+Rm7cOOPna0d+XOG568jPBdOPumD68W+78e")
			MSCBWRITE("NKP/6RGz/O+PmDGz/O8BwrN45c4fm278bRAzdunPFz340bZ/w4ut8eHme8VNKO7ifSHth8i0fcHPETHedO/HTubznx44ofb+QKz54TP4ErPP/9ixM/rvhxpR93/GRO/LjjZ8+JH2f8uKrfHlws/XQ")
			MSCBWRITE("uWH7gSecHilM2FTnCE4wSJ34Gjuq34EFP2sWYiqtGP6G0s0BcPz6XG+Z+E39KJ11fK3g4JgltMj8qVUqJ+gveMp5EzoOfUWn48bWcH2OXxOOPnyso9BOK45HPD/wbVF53xI98/ob8qDKeamH5uOCH")
			MSCBWRITE("OSnw9OUcceDx7knjifjJgs3fxJ8yBKb/oJOIeTD82PijMzE/xuz9JjYKQUHK9dtzbP8oGOtMTkAJFcE/GM8wkfKC9xuVm7Z+y8T8GFs3+hFM4lLWjMkPIi3XCjKSWWf9dARHiVT5iVzxI2ia+Xlu8")
			MSCBWRITE("bCYRMzy81ZaPzHz85U4P0Yy66PeZEPEtNVPBk744fZpR5yfEo+YH2Py+Y6uxJ9U52Lxx/Bj4k9nKFfB6Qo/sSA/PdZMwY+YgEKtqQOhjD9KypHlh+u3jmAAiiv5m6R+TMom3n+gkB9l7zflgJ+RdP")
			MSCBWRITE("zRHHMGVj+ZmB+jGItHLv5Y/VyRz99YMoHN3xIpN77hxxev34wFJj+Qa/+MNWJQKmU8WjD+DCv8DOXizxQ/ch08RjKedPyJNN9jpv8gNmISsRP6kYs/keXnFZWxlu4QEe9/SzXHHDP+QAvyY/XDeIa")
			MSCBWRITE("JOD/HNP5Anh94INz+SY1+fNaPPD9mfJVgfo2UUJ3mf2s3lJQja8LPTzF9s/qhp0DaJHMShiEnoaVtn4olCNryw89PYy2XwPVMA8g+PxUTUIHnwyGIxp9CMiPh9mmB58t/g7B+TM4mPf7A6ofHjyrZ")
			MSCBWRITE("+i2hxX2zLqafsn7rg7B+jGZ4/HVPNP4wHh5/LchPp1Op3xzw88cMHOYHcu2fUj/7AC7iT9H+SWTccH0ApJ8MRPXj2ZBzjxay+jmRv0k1uDtD8+bpbxJgfqQCUFTUbxkWsRwez0rmnt1c3jfbEW9mT")
			MSCBWRITE("ZXtn2wiJnveUrsShlPxR4ifQZEfEB7fVnYyZjQzqqwv18KQ7jVdiT/F9hhtub4w+hTxx2yJ8OPHcYnnqz739Wgd68GyR8FVxTKq7GkoImX+oY31CcOdDz9gkVZ3jhWyRCdbwS1iQ2OJXRR4OsOKJZ")
			MSCBWRITE("A0CUb+YLCzcxIO80PvNw6qO7MBkZf1F3cFVic2czNBZ2T39Ex7qEkkCsNwipgJHqD3T6NZB/NxuIiYLAe46HSGU/wwb+Vus1wMkj+Ydclg3w/24xkHG4nJ66FIvKpQ7PvB1X0LyuikPKoMKDx6REI")
			MSCBWRITE("55QQ6Q53HVZIMpwxrtyl+pg2PJ+fCM4uanQH+7wPV11TO4secdy5PvTLAfKyOj9unPSjVdB4LZ17oWOfpGCrtn1MIOkdA6pSKmDVXyKz2dofMKKmmD6zVKr/9jBBj+t+mPnICUr+mqzmx5cz+g3pK")
			MSCBWRITE("UtwInfzSNq6Y2MJJGv59MOvlXg5TZOUnM1XDlwk2yekDrM/AY2R06icrVv2lSS79j085Zf6D/oSlGR+athohZc78B706qV0pHYxAM95Q4F2nzrcRjtPUMjvXUQ0RnN1fVS+xo7xsEJ2dlp09fwhHp")
			MSCBWRITE("qWkdXPmD6mlIPp985R+YI4jJBlVvKpdlFoV7Z1yocqUb5xagtSZfjo1MrG5/Yk1+hbiGnf/nPldmKBsznf0aqRjc/H0VuedwfyoOefcYhWd/v4PB6s534GRJ5l3LXPn3xkO505xFdUI8PPm36nDT5")
			MSCBWRITE("27vzzlFBrmfIUCM8ZAV9oxNtJYhdhoE4/znBI5k6zx3nH5HTa1m9uhUCN6lD/+9imn1mkNYQzZySrbcR+LiPcwcZhh97u7L44UrOzqVzv2Pa3bJ7+hVhJ3Uj/BjKPeaPR7Klep55fZOPHEu1Yex7W")
			MSCBWRITE("TXSeJRArjkMGTWzxh9917xBO90+8P8AQ667fl58Mw1XW7sqp3/2e8Y/JG1jdm95Z5jLqNgLem8dQyfxDjv8n2JkGp8PPSnLWLaxn4+HeJjpWSosqNs/DzGj+8CiZ4bOcBNopoczWBS7+DRfCQAMI8")
			MSCBWRITE("13luuqff76M8okNcjw5o2NsH1pOfQ5d6sb/bh8fUHDqgyMMJHCrLSG4hPH+n1b9S8YZReVsQ0GbwGoL/VPAs8NLJwDR2jqh13eUC8UD0dI8OXs8gzmglh+tPM9bPYLDTP7eTiW2V/JjiV3zFnhWWt")
			MSCBWRITE("w0BpQuLjxgJU27HGDxXqLhq8PxIsro5hkc5roT7cOV5RvoJ05Ty8UXfSg14GEjABYoFPvM4OVsvZrlcQ1xJEzzWVjLqMuhSznCT1jZ/zlKPFTzj43dgJf7nEqaEC3prVFINEfAay4bwrPHxxfGoMu")
			MSCBWRITE("bQxnP1KAN4lO4BHD3DPQfwA5bqpRof8IlP1CZu4G518p86Lx5FkggCumZCMKIqDeBzMEtYSwJaa8zPZkY6iak4oiCzC9/T7pe0RvaF2ujvLoGfVa7HmBXGs8W8YPVmIawjP+tJIzymrTOOsB67dXk")
			MSCBWRITE("f/MNHWK8dhsgGhHnx/mk0vqqicXM8eL3JFJ6Eq4EKP4hnu6Eb/zas7NDPn4OffdGnN4RpttuVjAMrULi91Pfy5nh6lh+sn4kZrOMw5PC+CT+IbsEuUnP7U/G9ivYVXu6++kn2JFP+nopfK/jTPowP")
			MSCBWRITE("+HiqHmeX95WuPisyX6DO4xAzm9EbUs3nFg9uvwZipMIPbjbVj/9CPz0gfu7AJlzLYGNXv9gjVgp+rqnrfbitmvJDeLaIhbUJnoTTggo/S8DTPdD6JfET4SVj1nPL5GaoJFtfP1FXFaYKjfG8Gd79h")
			MSCBWRITE("rhYT7ZJOXeHw7tbpq6exB+8/ZriuU54YILnpsFzDQp+7sBGH1bypniIiFXigi551ZCCkiI8nLR6jAd6zfAopV8rlSo4gu7fDiHNqOs63VXqGerjWUan/Fk9xlpv96AZHBYKV8eEx9bLPzPa+SmfsM")
			MSCBWRITE("141prycwf/Vvbgl+AjLVHm80hl5VGm3c2owPytDyirhn442DCer3tIlkfXvW5S66IgPEFTPBRsuj9ilhbpPIz2fMqpY3WZ6OD8GgvUD2w2nJKU4gxgxsZVAl4856ABhyTwqCW0bfB0ft3MDzfhvNz")
			MSCBWRITE("/BfhfouyzDdreyLrEj0ctIWz/oH4aT7HKQkFSpvAYagjrms2zG/LTxdgD6oeHhzxp7+X9Z9St9jB7/O4YhfQdtU+tjho+ujfJ5xqYKq3AsxW8HW1zvk119zLwUB6AmRryQ2nByh7PhO9n3X+9wvZ2")
			MSCBWRITE("92jnOfUf9GFJUy5/HPxXuYtgdWkD5SNuz9xQOWdzYW5m9s9T08Gm+fEjxdblTMbzUWeaHdsbjBZO2/4HAAD//+2dP2/bRhTAj2cyYWjUkFFq6yDYQ4XToDVIi+IMyGMBGpC2foB+hk5XLSUYoP0CH")
			MSCBWRITE("S6crs+FDGQK1MDwGGTK0A9QZBI0BB0NDUHfkcc/kmVbpus6ae5nS7w7UiafHt/9e+/o/+9vEX+QpVeHM6I+pW0OKfOW/wafFHZxmXXk89h3/iAryzpElRJlXiz7gpbmCqoPNOYKhxu//V8voflcG1")
			MSCBWRITE("LMsdFiF7tZuMH94cvqG2cAwjepvCwwDoWgnKr247wlug2DUkHuSovj8FrjdK3TZy0dQjsmydLCZ7dnElTk+QBYMfUuSdDkNLqrYzoGTs2lUxUV2aIkvOCK2Ah/JqgJI6BKJOaqRV4kEhN7DbJ8TpI")
			MSCBWRITE("SQZPoN5THLbozvDKTlR5OWO5xhs3koco87i1XhpGnLDLbtDIlEEGnwXlQHsdcvFZG0Ydb0Q8pHURZGFYDAhzvGCG0sVR3VVlE8ofAmbvMh7iZ/YSls8AllW3w5YN4zWp4I/sJuliZ5UndeTaNZl1l")
			MSCBWRITE("JltYWdptZD8oT/37vlw/Fc30kwil8ipOW4ixF2M/ZGz0g0eMZZ6MIRENzuOSJUdqaLa1W1DDa5q73qm9jmBPdAv9CBwzmGKZb4ye6vqRLOk0OE9rOfjwevu56GrdiCBJlBl1ankK+ynqhZr9iDwZB")
			MSCBWRITE("031s5zN4ctH8UoK7jaTh7Ji1rNe1RVbkW+hGppK0m9ynlYVXXBF+1MlcfOwyXkSAbGJIsD2J16u3wQt2h8hIG900JRObuz1IdpgwjLNa5XYylG81kg10g8jlX6YLDpwq3oK5F4laRaqcFPqUWyXew")
			MSCBWRITE("926xprdr9hFZ0U6WrphTAlxn78MtoH+2+3Hgi5l7utm/XZalBSNf20ivfoVHszWC16qSz8EDHjmvzli5VxTy28pyi4zeIFy+3w16SuPs5yVyxFv112zJV/4F+8GIvlE0Tc9wVYLPeFIKvdtPX7hck")
			MSCBWRITE("tpW037s6pddYu8+1c6vP5hDtw2axoNSlwcT8p/PgZ+aC0GMGGhNTG6Veiw6z1lJv+AVW5UAsPkJ7PeTQTJJZZV4/qRyqSbNWpn01mC7UUCXcp2YSA8Sd4fM0BfI08xSTCDeTJwnizmYOOHnHmofId")
			MSCBWRITE("MzLFt56knUBSHW3VIVnEIm4e631YwjDTXf93V8lWX12xgEfLosOulmTN5HFu9FzFPqAVMG0IsZ4m8LPBaWxsBvPHr3wRxH4cKD/Whyjc7890eEKifO0nislGC1A94oz4oedwb5hHhuKbOyDt4Qi3w")
			MSCBWRITE("2jonR1GbT469LgX4V6XjAbOKHIJH3pvhq474uFarV6ACTJVjBHJAO83ChK/9gBSptf00GkKx38x2BY92E57QIHQFIBOFdAxgwUwCqnf22g1BsrT5rueQ9pHWpRWFrkTYg4zzlEr/JzvtlAex8Etyu")
			MSCBWRITE("OQI+60szUZXtRqOUe8tdk89vg8mL+EyY9vIU7mv5/A+Wks+sfz0xOYi0lyDvB6MYHX6iR5i6+5+AnOJ1g8CZJF8tsMJmr+8lTrR1x3HjfyeDg4dM50KGzonUU6hurgDL/1MxTt76HDhwPvIDrE7aG")
			MSCBWRITE("Lu8SbYXsQDZyDyD3C4wkPN/x/470AVXPspDrgTS+1ysIS0+5WB9A8UtgfoxrGkrFUUgkdmsonQB4DFSx5hqoT8HhvI/3oOPiw5TkHehZx12tFaDDtXaKvFJUVEbzwluNkUVYeFngkCsMs4G8XzSpE")
			MSCBWRITE("4wmdzSyov6MYTB7NM3kmKM8rtClQDwWQrsDs6wUkSbyTgHqgQDwA+fPv8fcQxID6YRDDr8FG8nAP9aPtJ9dP4XnDFBoRQUXwSK/K+Mw7GHpZ+Ggmj4vmRHL9fLFZtBXrb6eM9XpvX+xtp998mXaII")
			MSCBWRITE("v29ve4WQf2Mn6OhpCwYq36Qqp5kcgvkE0YXLBB9eCaf9Mbp13S60UwcihI6dXlCIw/Hai/iWh6tH8cJ6/Jobe3m99tm8vQXYjJjyXs5QXuZjd/JX2YkeJeqHdTPznwG7Oxknoj380Qez5J3cgwyeb")
			MSCBWRITE("qYPX0/nidqBuPFXIHa5FFd3hDrt4H7HdZoZMTdUdQeYL2WXal+9Cjq51u0odGI8HbkDjN5sH7z/nRG5ICHun5rR1fEK5T0FuQPxYLTDtZvU0WP5Vd4401TtdVJyf70OeyjIoLxD0BlbxpMtf2w/em")
			MSCBWRITE("L7QUF1A9D4+oydbPwvrt9DKyeiNaPD8GWRTc9Rfvj5yFwsXkzL90u6R8/+xQRfv7ZG3Xj3LuVp4Ru2NB/HOj/9nPf12CxfKwIO4tmsVgsFovFYrFYLBaLxWKxWCwWi8VisVgsFovFYrFYLBaLxWKx")
			MSCBWRITE("WCwWi8XyAfAP6U+UuQ==:8E36")

			MSCBWRITE("^BY10,3,390^FT94,1665^BCN,,Y,N")
			MSCBWRITE("^FD>:"+cCodBarProd+"^FS")
			MSCBWRITE("^FT58,744^A0N,117,115^FH\^FDPRODUTO: "+AllTrim(Etq->C2_PRODUTO)+"^FS")
			MSCBWRITE("^FT63,963^A0N,117,115^FH\^FDINFORMA\80\E5ES:^FS")
			MSCBWRITE("^FT821,961^A0N,117,115^FH\^FD"+AllTrim(Etq->C2_OBS)+"^FS")
			MSCBWRITE("^FT90,1249^A0N,100,98^FH\^FDORDEM DE PRODU\80\C7O: "+AllTrim(Etq->C2_NUM)+"^FS")
			MSCBWRITE("^FT57,538^A0N,100,98^FH\^FD"+AllTrim(Etq->B1_DESC)+"^FS")
			MSCBWRITE("^FO0,551^GB2347,0,19^FS")
			MSCBWRITE("^PQ1,0,1,Y^XZ")

			/*
			MSCBWRITE("CT~~CD,~CC^~CT~")
			MSCBWRITE("^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2~SD23^JUS^LRN^CI0^XZ")
			MSCBWRITE("^XA")
			MSCBWRITE("^MMT")
			MSCBWRITE("^PW2362")
			MSCBWRITE("^LL1890")
			MSCBWRITE("^LS0")
			MSCBWRITE("^FO96,32^GFA,29952,29952,00072,:Z64:")
			MSCBWRITE("eJzt3E2O2zYUAGAKLIZdBOHWi0C8gpddCOAcJUfIUgUKmcYAnWW2XbVHKQEDza65ggZZzJZANyoqmH2PlOT/GSemHE3yHga2Rj+fTeqRokbSMEZBQUFBQUFxhXg1MUdOzbHkPOk4csghh5yX7WhyyCHnu3E8OS/LackhhxxyyPmGHT45J83xixxyyCGHnLSOJOelODdbzs0EHGE2T")
			MSCBWRITE("j4Fp4YXHcct1SVOMzjZegpOHZxQPxeV61t1DBvyh5zDUPW0nEV02mH6azvN4GR+Kk48/xKTcNbknOmoCTjCbzsNOeRc4Hz5X4HIIecyx5s0+ZzGyToHxz+LCThQrpp11wen5LTTcczGuTQP0zqXt4vLHdk5bjpOzYY89OQcOmaKTsxDcl6AU7OhHyPnlDOh9j4pR3eOJed7diw5B0")
			MSCBWRITE("7TOTC0J2c/YFs8IcT+R3xtx8cIjo0Oxldx+o2OON5/xnlPCgeqM/NPOtBWznhSIIkT1xbPOI18rnipnIXfj+aI04UZ3ckOV95up3tRj+vowzW7lf3xImOM6Bxd7znnSD4mcuRxxzztHJ5Dp3F2vqrZXzisBC8z/MzV1vp2BKefF6+No/MDTvyIL7dM87BEhGoNDm6rNh+c2uH9rDr")
			MSCBWRITE("8Wm87mWOahfaxsNLH2xSCM7SUJrkjNvsYVXQETv0UnTm8NiyDfawtU2Z4YDcby1nsZJTEBQqncEKEBVnNBPDchUvFmwdk+dbnp3Li12N7Dq66HhxAsECsZarZeWBXbyCxyzBddQ5HR/0Z1jHxvhTN1Hr3wV89pF1KZ7sf0biFcp2Ta5wHhao65w+z4/Bhj6Vysj2nxRp9A3Pk3/Bb")
			MSCBWRITE("FZIF6BLfJVP39e6D0ckdTJ9tx+FdEm8K2Og1/FaGjSrMaHRsDhP7Tp3c2drv3AmYX4KjX2PD4rhRiRkdHGWqHUduEjqVI3aaF7e4SQnVW6BTcyxzs+Uos+XwIQ3TOfHL9VUtLVYpOq00DMqIC+rO4eCIevOPB/aaVConfj/TOZhyJVQvJgD8tKGL3JRLNH25lD846UjlMNz9ocJ0q")
			MSCBWRITE("LiSO46OCruAmyEPscVGR5wYkqVyRIMJ0DvMcRsdqEh54OAhVh2/xS2VEwvVtqHXKmGvo1OFiscd3fcbUPfvLX9q2JvQgcCTUQOlKCTu9BJzj2Hf2ver4Hy0zxgJHWyWooas0wW+N8GBTmQ4DkKVn3PmnMyx2FmAI1twRB3kcMONicd3gyOh6zmY81mThXPQLDhQ89h14L2aMA8Pkv")
			MSCBWRITE("qaDr6U4PDgQClYy+MNbWEkHcZjV3TCsKBCx4ITdnY3fo5dCM7hV3Qw5Vie4fbghMGT5GEowEMneu7ty6kcCorpBJ4dhdhPX12zz4lLHR7fRLMI71k/9us5/m83Y85iExzTgc6vc/K+ixFm19FM1GGiuI7TjUTLcJg/4sy7cSKAFznvznKGM6u3Xb944NhuHASHsKs48UiJ3/2kMws")
			MSCBWRITE("Tcze+c1OyeXRM/0/Z9hzMhvicyry4gjNj78525BPOmzROfsNun3HY4PDl+I5YmmccOzhsfGeWLU1onifzEJ0uD9nDFZzH6GA7nR9zsDcpO2cxvgPnNNF5vj+cD4vGdMquOE/18+YzHMXEBU4JUnSy/u8v+w73w3HwdKRytuLkl5anFozrUFBQUFBQUFBMMvDKejc+1YdLb7dPK8Lw")
			MSCBWRITE("M555GRxl8zEc4QfnyJe18e/E+w6P1yRGce7PduKs4NQHqyZzDPfMuZlY4z0aLW9g/HznXYvP56rHVjttfbNYeuYZ/+CN8u+Z0/Lfdak8524Ep5YfnXO58ksPK/DfmXj8hNfPMr9WD65t5Qqce2+DUy/Q+efjQ1MuvJTFCE4roVhuVmWPtij4yrA8+2S1hA+o1NI6KfmyydWds+As6")
			MSCBWRITE("1KA4xhMlEru/E/5hUYnL6GmCu9XNVP+P1vg9cE8z6yHT2VlnjOoMf7B/Fyj0/JlDVNy51JGKkcUoVydY5tTjt44ehUd1qZ3bkSo5yo4DlMXz08Hx7He4RadBh3eO0V6R9xLDk6Zi6VtCynzsN8LvDGgQkeH/S7uVit0ykrdrdxq1e33MRzPPay9jvnsoX0JHx2/Bke3kntwYj4baF")
			MSCBWRITE("XQ+Dw6mM9tkdzJGmjJVv4G77BnW7zvq2LgMKZ+zdktd5JVsxv2C+7jv9hb8WDauWZL81Z8gvb+KrkzRHk464silXPJv/gZw5lNzKGgoKCgoKCgoDg//gfLNd/0:6E22")
			MSCBWRITE("^BY6,3,218^FT113,1590^BCN,,Y,N")
			MSCBWRITE("^FD>: "+cCodBarProd+"^FS")
			MSCBWRITE("^BY6,3,218^FT111,1103^BCN,,Y,N")
			MSCBWRITE("^FD>:"+AllTrim(Etq->C2_PRODUTO)+"^FS")
			MSCBWRITE("^FT119,1334^A0N,142,163^FH\^FDOrdem de Produ\87\C6o: "+AllTrim(Etq->C2_NUM)+"^FS")
			MSCBWRITE("^FO25,544^GB2289,0,24^FS")
			MSCBWRITE("^FT116,803^A0N,142,163^FH\^FDProduto:^FS")
			MSCBWRITE("^FT113,523^A0N,92,91^FH\^FD"+AllTrim(Etq->B1_DESC)+"^FS")
			MSCBWRITE("^PQ1,0,1,Y^XZ")*/


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
	u_InPutSX1(cPerg,"01","OP De?		 ","", "", "mv_ch1","C",6,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02","OP Ate?		 ","", "", "mv_ch2","C",6,0,0,"G","","","","","mv_par02")
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
