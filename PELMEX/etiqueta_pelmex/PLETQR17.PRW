#Include "rwmake.ch"

/*___________________________________________________________________________________
¦ Função    ¦ PLETQR01   ¦ Autor ¦ Stan Lee Lopes           ¦ Data ¦ 22/01/2019     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Impressão da Etiqueta da Pelmex (producao)                            ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLETQR17(cNumOP,cSeq)
	Local oDlg
	Local cPerg := PADR("PLETQR17",Len(SX1->X1_GRUPO))

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

	cQry := "SELECT SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN AS C2_OP,SC2.C2_XNOME,*"
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
	Local cLinhaObs := Array(30)
	Local _cAux    := ""
	Local _cAviso  := ""
	Local _cModelo := ""
	Local _cObs  := ""
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

	/*If cSeq == Nil   // Se sequência não foi informada
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
	Endif*/

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
			_cObs    := AllTrim(Etq->C2_XNOME)
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
			EndIf

			if !(AllTrim(Etq->C2_XNOME) == "")
				cPesq    := ";"
				nP1       := 1
				//_cAviso    := Etq->B1_AVISO

				_cObs    := STRTRAN(_cObs,"ã","\C6")
				_cObs    := STRTRAN(_cObs,"á","\A0")
				_cObs    := STRTRAN(_cObs,"â","\83")
				_cObs    := STRTRAN(_cObs,"Á","\B5")
				_cObs    := STRTRAN(_cObs,"Â","\B6")
				_cObs    := STRTRAN(_cObs,"Ã","\C7")
				_cObs    := STRTRAN(_cObs,"é","\82")
				_cObs    := STRTRAN(_cObs,"ê","\88")
				_cObs    := STRTRAN(_cObs,"É","\90")
				_cObs    := STRTRAN(_cObs,"Ê","\D2")
				_cObs    := STRTRAN(_cObs,"ó","\A2")
				_cObs    := STRTRAN(_cObs,"ô","\93")
				_cObs    := STRTRAN(_cObs,"õ","\E4")
				_cObs    := STRTRAN(_cObs,"Ó","\E3")
				_cObs    := STRTRAN(_cObs,"Ô","\E2")
				_cObs    := STRTRAN(_cObs,"Õ","\E5")
				_cObs    := STRTRAN(_cObs,"ú","\A3")
				_cObs    := STRTRAN(_cObs,"Ú","\E9")
				_cObs    := STRTRAN(_cObs,"í","\A1")
				_cObs    := STRTRAN(_cObs,"ç","\87")
				_cObs    := STRTRAN(_cObs,"Ç","\80")
				_cObs    := STRTRAN(_cObs,"²","\FD")
				_cObs    := STRTRAN(_cObs,"³","\FC")
			EndIf
			For I := 1 To 3 Step 1
				cLinhaObs[I]  := SubStr(_cObs,nP1,AT(cPesq,_cObs)-1)
				nP1 := AT(cPesq,_cObs) + 1
				_cObs := SubStr(_cObs,nP1)
				nP1 := 1
			Next
			
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
			MSCBWRITE("^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2~SD15^JUS^LRN^CI0^XZ")
			MSCBWRITE("^XA")
			MSCBWRITE("^MMT")
			MSCBWRITE("^PW2362")
			MSCBWRITE("^LL1890")
			MSCBWRITE("^LS0")
			MSCBWRITE("^FO64,0^GFA,16640,16640,00052,:Z64:")
			MSCBWRITE("eJztms9r4+gZx99XkWKhKZ4xWI0pNqPOSbhLSKGF0C7bN8XevXUc0LuZgsPmT1DAZnpIqSZDafDS/Rcq0osRSzvHHpVDmEuhnsMwlxlweyq9NAOz9LSkz/O+cizHssavls3OLn6SOLLkRx999Tzv8/6QCVnZyla2spWtbGUr+/qMvsuc4B3mFPApxGE3xCmAKcSJ1X3WinAK+BThrMU3w7kpPaX4")
			MSCBWRITE("hjgFfN5pPQU4t26Io33XOAV8bo/UfYrEpwinPL4ZjhXcDKeInrtF9MTqPu9yfIrk2/2YEMbUfMoFOIXio8phhPwCOFVFt82x2udxTIV67qg4BYT8KFDjoJ7fAcdT5KAeR8WnI/UocUIZH1PFx5N5rcpRbT800WOrOAXqeowOE/HhTMEpJOSDMSFNBRfUg3nNFXyQ87NAjWN0ZL6pcLRQ5psKx5Yc")
			MSCBWRITE("qspBPScqHJ8w1fhYwPkAOFGowJnoUeT8HDjD4OvlTOITKXLuFtDTDNQ4PGk/fUWO0BMu71NIz1DWaxU9G56sO0rxGRaIj5foWd5F6MHxgVJ8JMdQ0hOJeq0pxWfC6Szvg3qwXg8VOFz2PwZX6ICaBfXcxvgo6GlO4jNc3qfvMXJ/xIQetiwH9FiKejgkWkkxPlGkrIfucTGfU4oPcmDeqKlwEj1K")
			MSCBWRITE("8RlIjpIeDoUNOG3eW54j9IwL6VGKT1P9vkEesJuLT6ymB+OzpsRhVOiB+4btiC3p9ZXio1h3LNX47KnHR+RBXDA+Ch3QYCDywFqKg+FocZ7kG+d97rVabBlMM8k3C/+/1WilYiNG6pGbyySdFkWRzDfgRMO3zBl0vQ2n3UvpwXd7nLVbrYUErRkldsURb5oLCzdNrl/qAZ/J+x2+MFCmOOlA/E05")
			MSCBWRITE("g2hwDP+CDIcWBqMvTtvv96We9mQP7uRZg4V7Ucpm9KAN7zlzHiktSXwCzLe0zcXJTJ0ziAZJ3Zmx65IMjMrengxOm7cmeS1ssv9akOQpT6PpRafXexPgadqDVuypkMSm65bTozOKICjDa43l2rqyuIepTzARm34f2wqb50DwWi04zh+mx9uYZuGswLl12CTdJ2Zn3f255wuV2Q9FQ2vu7s+vk1vp")
			MSCBWRITE("EHHu2XPZNP+8xOCpnLOymkfGeryWUm1nNfmM5yV2SpA1mD+e+YxlcCUIwtNhRP5Mx2vp51nJ0TbvTzlZerI4qRuXref3sNd+JbDJYZpKRy2zteM+bTYHU4kAjYfJrXV4I5bFKKOlyzfkk/+9wUW4hDNTfq4SVhO/0qz/jsnmX8e4aOVMrifVgmy+KzduQz6LW0Zh9GZf0C/pEamL5REiEm7mSpOq")
			MSCBWRITE("DJ0oxB9uGQ3hXQi5bZIfTDgnadUMmgcXQ4FPoK4x0oZScAHDhANoQ/sM9vlMFECe2RWVBQd/n8AlhrdQ3qbkaE7G5yt34M7EZEP8lnyMagOba2NEOxW7U1m0uFgLE472N2ypFr7AxDsLIUzXYaLgk9JYcN7HO7gP4YobF6SjL+6AiDPGtYNyTMouSvkeDhPcce66Ij30cc2lEZN6HTlVjFXNp7k9")
			MSCBWRITE("aghndIkZEBekWGJNNTStHA5kmd9j/Ih1Y3IE6dDF9UR20O2K+MhPZFxbuE30GnFDsr0egJot5LjlfD2xR+wu2YqJD5y6yGe/tkHy9GiBSUyThCF5AqlWSzhruZzS+T7xbBof0C8gIzyxPnpQN0b5nDIx18k4JGPIha2EQ+JczuWXpF6isU8vL2PqIwfiQ1/ncazg08Bcexw45AQaSwiKoCyYxM3j")
			MSCBWRITE("3IWBaLf0EfON57xDfSY4XXKUx3kP75x2TJw10A4cmW+kmcepQzOo06fAYdSHqtAQekgjj7MNl1+DwuZC8dmGqmBh97AtlpUWGkzfxl3SJz3IgiMYiEA92GB1YuQ90tgS4ficuFAbXU002HXI87XxYhdsJ/4D8j6plUEbFroRSKqR3PYTQEt1QdU2lDsLe4ttKNi13PV/PF/viByxoy4hv7r/sMd+")
			MSCBWRITE("y9+wLtS3t3Ig8FgNrGhMbl2GoCeXg0v9HWjRNWjUpcblBdm4HOG1KT03UXvCkJhewOcdM5b8TZ/OsewPfjtM9M3GtLsRU1RdLVBOzjEqv4FEoYDikJAk30gqcXkw95GgHPuIgQ1uaYM8DmszPG8LBeg9knzDym7H8K/EPJblNBYjakumsjPhuGJzwZdF6MhAJQ155dhixKivJjofGmfrCQUnaTBX")
			MSCBWRITE("HEfsWfDlCnohZghVGQl/wvmJ4Bpe9kqCk5xMy+I42Zw74j5VcaCY0sPkZj1bj5lu+1ccqVDLrgvtVgU5HjOu9OD7A6lnPVuPvOb5++bisewbR/VKR+ixr/TIDbFJ81ZgzMw80LLT22h38PptmQf+hFPFTokYNHNlUZO3SRPXP+WY+ExwIYcykVnPR1d60EdOwBa2H8HBwU6aox2L12wPnTFR0OTU")
			MSCBWRITE("AZE7uGV4uBfqAct2E3b9GaPKM8eVrexbb6LlpNeqp9vplQVGVvZNGGVM9DKiYkszWNIVYS8Evy14yeobFlTLbNu4EPU4PS+AYu2RhIP76yQmD2YAY5zqzHzlmuK8MbUT+wc37WMw/ftiQ09edWLErKeXpDCjo+t1qOczetZJ03KCJkxPtVALm5+Rcvjn49BpfnoM0yHYcaxtll0tMtOrSgZpVCu7")
			MSCBWRITE("R8Zon8b0wt4jpV1+9qzP/1SKu9QeNbjeaPCdL+6k5ydrwWPLeTQwHQdGa6YbBuaTR8emczowXZjUueHxwDWdx5+ZKb2E/nPn48MXrNfvP2Xc88+Y3z//R/fw7Gm367c/tp/xD3tVv23sx2lB/woGzjHMd09PieY6YeA4wWAT/mq1EDjBL4FzEGnuOO1zuOPtviBVu78zspGzVTn7o7cbnD+o16lX")
			MSCBWRITE("eYZ6dveNB79J+9wTHMcdBqE1dILAcR8Nhj8EjukSywy0gWU6J5qZDpD+07Z3+FSv9g9039YPzkHZ+d91oadqePaz9odG1f/I6NbT8QkjqxlE5fG9QagNQU8T7tvQ+c9g/d9D0BPFnzdPDk7/0kw/V7dfv6g22q8au9zwSw9+fMYar88evzx8+Af78CX1av3nL/cah09f/folm/rgOogF6QST+oDg")
			MSCBWRITE("D2R4EOA6T+CKXHNwEBSYKQzklOeVWM9gvM1gQLDDjN32jtfhbYP1qFflOz2vynZ4p5fiSHOu71jCFB4ufiXOd83YN30BK1vZyla20P4P8eEWxw==:3590")
			
			MSCBWRITE("^BY8,3,427^FT94,1702^BCN,,Y,N")
			MSCBWRITE("^FD>:"+cCodBarProd+"^FS")
			MSCBWRITE("^FT1209,602^A0N,100,98^FH\^FDADICIONAL INFORMA\80\E5ES:^FS")
			MSCBWRITE("^FT1210,726^A0N,92,91^FH\^FD"+cLinhaObs[1]+"^FS")
			MSCBWRITE("^FT1210,843^A0N,92,91^FH\^FD"+cLinhaObs[2]+"^FS")
			MSCBWRITE("^FT1210,960^A0N,92,91^FH\^FD"+cLinhaObs[3]+"^FS")
			MSCBWRITE("^BY9,3,426^FT95,1037^BCN,,Y,N")
			MSCBWRITE("^FD>:"+AllTrim(Etq->C2_PRODUTO)+"^FS")
			MSCBWRITE("^FT90,1249^A0N,100,98^FH\^FDORDEM DE PRODU\80\C7O: "+AllTrim(Etq->C2_NUM)+"^FS")
			MSCBWRITE("^FT103,581^A0N,100,98^FH\^FDPRODUTO LAMINADO^FS")
			MSCBWRITE("^FT53,418^A0N,100,98^FH\^FD"+AllTrim(Etq->B1_DESC)+"^FS")
			MSCBWRITE("^FO0,431^GB2347,0,19^FS")
			MSCBWRITE("^PQ1,0,1,Y^XZ")


	
			MsCbEnd()
			MsCbClosePrinter()



			/*If cSeq == Nil   // Se sequência não foi informada
				If SC2->(dbSeek(xFilial("SC2")+Etq->(C2_OP+C2_PRODUTO)))
					RecLock("SC2",.F.)
					SC2->C2_YSLDIMP := SC2->C2_YSLDIMP + 1
					MsUnLock()
				Endif
				GravaSZ4(cCodBarProd,cCodBarExp)
			Endif*/
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
	u_InPutSX1(cPerg,"03","Obs:(1)		 ","", "", "mv_ch3","C",15,0,0,"G","","","","","mv_par03")
	
Return Nil

/*Static Function GravaSZ4(cProds,cExpeds)
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
	MsUnLock()*/

	RestArea(_Area)

Return .T.