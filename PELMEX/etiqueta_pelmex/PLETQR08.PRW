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
	Local cCodEtiqueta, cCodBarExp, cSeqB1, nX
	Local cLinha   := Array(16)
	Local cLinhaAviso   := Array(6)
	Local _cAux    := ""
	Local _cAviso  := ""
	Local _cModelo := ""
	Local nP       := 0
	Local nP1      := 0
	Local FimRegistro :=0
	Local cMaxCOD	:= "0000000001"
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

			If (Select("QCB0")!=0)
				fCloseArea("QCB0")
			EndIf
			cQuery:= " SELECT MAX(CB0_CODETI) AS MAXETI"
			cQuery+= " FROM "+RetSqlName("CB0")+" CB0"

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QCB0",.F.,.T.)
				
			DbSelectArea("QCB0")
			QCB0->(DbGoTop())
			If !QCB0->(Eof())
				cMaxCOD:= StrZero((Val(AllTrim(QCB0->MAXETI))+1),10)
			EndIf
			fCloseArea("QCB0")

			cCodBarExp  := Etq->C2_PRODUTO + Etq->B1_COR + cSeqB1
			cCodProd  	:= Etq->B1_COD
			cCodBar 	:= Etq->B1_CODBAR
			// cCodEtiqueta := Etq->C2_OP + cSeqB1
			cCodEtiqueta := cMaxCOD

			// cCodEtiqueta := Etq->C2_OP + cSeqB1
			// cCodBarExp  := Etq->C2_PRODUTO + Etq->B1_COR + cSeqB1

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
			EndIf
			*/

			_cModelo := Etq->B1_XMODELO

			//MsCbPrinter("ZM400","LPT1",,,.F.,,,,)
			/*
			If (!(AllTrim(Etq->B1_AVISO) == "") .or. (AllTrim(Etq->B1_XETIQUE) == "")).and. (!(AllTrim(Etq->B1_XEMPRES) == "CAPA PROTETORA ANTIESTATICA") .or. !(AllTrim(Etq->B1_XEMPRES) == "CAPA PROTETORA TOPER ANTIESTATICA"))
			MsCbPrinter("ZM600","LPT2",,,.F.,,,,)
			else
			MsCbPrinter("ZM400","LPT1",,,.F.,,,,)
			endif

			MsCbChkStatus(.F.)
			MsCbBegin( 1, 6)                                                       
			*/  
DbSelectArea('SB1')
dbSetOrder(1)
SB1->(DBSEEK(XFILIAL('SB1')+Etq->B1_COD))

if nX > 1
	cMaxCOD := Soma1(cMaxCOD)
endif

fGravaCB0(cMaxCOD,cCodProd,'',1,Etq->C2_OP)

//COLCHÃO COM A ETIQUETA SEM AVISO



MsCbPrinter("ZM400","LPT1",,,.F.,,,,)
MsCbChkStatus(.F.)
MsCbBegin( 1, 6)

MSCBWRITE("CT~~CD,~CC^~CT~")
MSCBWRITE("^XA")
MSCBWRITE("~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2~SD25^JUS^LRN^CI0^XZ")
MSCBWRITE("^XA")
MSCBWRITE("^MMT")
MSCBWRITE("^PW2362")
MSCBWRITE("^LL1890")
MSCBWRITE("^LS0")
MSCBWRITE("^FO1700,87^GFA,6417,20922,66,:Z64:eJztXM1q5MiWjlSO4JIJYhqs/V27QA/ghESG9l4G6X2C6k1TBX4GUd6YNCQNs0lSYIp5ElErYQqtk6JI5nznREihX7vwvUPP4LBTliKU0hdfnDh/IVmpXln92a8ZbVrpydPC9FVNWdxt2x")
MSCBWRITE("THXBXFUSuPNsui2KllQX91QZXrI1U8KG5S6sNRrem3OPaunmXJIqON8rMsxp5a4K+ivdRPqYJuT9uYgeCXzuiU6FyfFX0qFZzrCnulV3/1zpr26qD2aKtVgHYV1To4q6f6rPsYcKMsbdEwhlgwEDC6PZpwKjBwRZeHQvqMvQMxUhyWRe7yUORoOuJUTTxwRQ9DhjtLxxeysTyEqVDEGAWDVHR4qOta13ajsAEPchjUK9pWXItTSxCDij6G64yBpAZNn4eUm3BqHEpFl4fjusiLLx+KP4ocmy8b2kAePE94+FjQ5mFdaOIhX+PsTVcgQqL+Oot93LndLDDmIg/cd6oFhgQY+rK7PalzSTJw/njWK5KCMqA9yIPyzqfgTDsRVZSoiFARnEkoOgKBEb7GTX0II6Phw5iOEvBAsupLRYjBofP9rlBuSAZyCAD3/ovsQR5oeuTgQfNmyVJBxGByFD0eehjMRtGtYlDAGNQMhohGu8RAB7X2sOfV/83yQJNBQx5oc0dHdQnRCeqoRkOXB+l92sOAW6qGB4MhG+Xh+IF4wBwoqOf3oOCe5YFalKGAKFIyOz4fqRaNIzKZDHgg0fN7PIxigH6ALqjQO5aM+hvrB1WfFKYBDf/dWXio6LzorFb1AANmQ9znYQG11eUh5ek64AE6ElqBeciFh9xIgMhDw8OBJGKUB9EKfR58vmuHhyQcw0CD/KxEF1h5+MjyEFDPe/JQsUQM5IEV4+/ZYF6EEMseD6MYNscdOrkuzMg384K0ourNC+LquGaj0cGQwBywVqC/jn6AFmj1g/DgZwKqcwXSD4rkYAUlEIh+MJuzUqwfnmhD7aQfSD1AP5BIdDCkDQbZQDwgoFlqeMBYJayjUsYQ93QU6QelpPfH4ugVO7IMNOpkL467HSh4tBV06hI6c1eM8rCwahqa2O5ljr3IRKWO2Qsof0hBay/azV3XXmBnxF5YHlqb1exlYi8am5WqMQwND3rDJhP+AuaK17ObB1GpY3bT8tDY7rjZy9h/yJS13dZ/iLs8iDywHiDZh7ZoPAniofEfSuaBRCEa+A+pwQD/RbUuS8sDg8yUxeD3zKa6JDdJ7XIPs4PGebdDJ+E27aisdp6tkFNXD+RTPaj38l7ey0tl0Wj/bOKE6dAnYI23pw05RzAOojL3lVhIzQqhUnsyH1COVPWg6GSPTShfwWdlwKEFbhOKaohJIcBK408qAUXCznTIKjQxJpSvsObwikMLTH8+IpVJ6hCeAqoPbCPgW9DGVokJtRhMZCWKCooIGFLBwNWwlVlqMWSK47GEtavwUHMXNXiAISjBAx1ElVR/N3uWh/orERDUlcODdJEtoURUbDgNhph5QH2DIbYYGh6kixwxrNlUgAcyHei0YQT1nw0PXLUuDi4PdLPQYrgVokOLIWEegGKIwfBw3p1PW3Icqi37Cvp8gul4OuvtKaK2avuT3Ivop3e+q8909GNH/iY5mfRhrwN3JWp5jEOJ5GifeYhx54VgSFsXhs5kYbEChJ5j4MkYHsDDRsQCPFBvabc4iGQc1RfjThphEbEwGMIEllkw8JUZQwIMquGBJ0/MkUiDwcqDjqpaZgFZxe9UIfJQQQpQ/Z3bNE8XiUQwVeq6lQe4ygn3lTH4HQxcDR8yUcrlIbvp8oAOHpmHAzuK4IEI+HAUjtiH5OnS8nA/4MFgwEgLhtTBAKGNDQaZuOTztjzs6hN1cFtviYAnZCDgP+/regtmop8RyUMluQfyHyQSITK+EX9WHqjLDYZsHEPKWsSEODw3GYMzL0Z4+K+CJcTwAE/KhllMAMINd16M8HCbuTwok5pRRkfB8+zoB9aSkXiLRh4qUgatPJAibcJNCJAiz1M7+iHu8CDykGSZw4PJETU8ID0SOzxoiZ86PPzV4QEKNDc8QB6QoslbHlj5ht15ESatauAON6F/CICCweoHuI0n9XSCfiBlEJxZP1RPZ")
MSCBWRITE("9IP1EJVTyelKbyAPGxPn6AfPNIcZasfuPv9uZlwskOZjYpVRz80ilXmBauFvn7460NxsNWsJAwPMi+WRl02GKwyYh2VCAY/a3SUbGKrHxLBkLT6AfHmJ5iC3Q6zpBJ5CCAPe2y4bUXCYPRDJfYDX3hoMHC3jF1yMEgozsr8ZsBDEkpSinkQe1EUJpJgHpbF4QOO1nbj6snWhhoMPhtIE9SIzUoWgkGE1m/mRco8hNlvocXAPASY9VuKIhBJlMZ/OFNHKa7wkK0MOMKAfuDMFTGh9z85q2kwLExqkqMr6z+YjpqMqdUPBoMoT+EBXfEQQsnU566BB8Ud5RlxxAlHV0/y/HF5UOysCJCkgyE2bk3W+i2MIWkxrHawBLAHlxTPqBXHkbucQpnLh9UOjXAV6IQc1Qhxdg+XD4h0dvQFJ9KJ7c5/qEH5vdm8l/fy/7Tot16gv4LjlhXSDJihmKd0lPPEpT9crTxOUHj9FRy3hEZLID0rqUkoD2iK2FgyTlRORGIoMALiIKgaCciSlSgyUfAblKxocOw1VazGbjGQnbYYzOpSPMgCuYWNAi/p8GoNewtkJA7iN+ilTVjlczzwPQRDaDHASil3hSuZvEJwPp/LiDZkGZCAJG8BTgNSldh6vIBBzadZDMkQQyYYJFt1zcHIJA/HR7gLpLHR7Q33Hst9mre5WeGybsMoButFAEMs908GGPrZ0Q4PNXwDRN8KQSUcBk5Lat7jlb76Y12uptNhPlKPDYaswRBzUNxgmPw+m1DxrsFDzhw8YpGP8/gb4eGPYjdzBevCOhjYo05w8zCxidyZK5AnuSXv+hmRBPnaJAX1HfFwrpC5fKq8muWhl6AdwWDyETH33E8Fg5+GzYrn9FAYHiQbi2Ud6vZnpGQp/FgeN+2KZ/4ihoTdhQbDTepgGK6udniAUog4L0MbloA7SVljpatq9MM0Eb7Lwy3fucXgm8jbnyPC5eG+OKL3S+LhHv7kAVlrWdmZUZTuWNwKBnT8mvMABoNxq6Z4IHkgJxHO0fn5x08sYEAAStIaAa9y8gLnp/N58gquTN5mDYbYxRDzMtscDwczL+4hBVAYmiVjc3w0PCi1meWh0Q+3kEQJ7GKjPe3Kr/86/VDRj6SpkIsoZUG8XJF+0EE9eQXf0VENhpi1lSyomIWeV+hJshc5eODgEivguTwYcJQF8RkeHF2dOBh8wWBWdpI5PYlIIjKRBH6eEG0QHbSP2tqsgn6fxRA3GGK5c4shbpZ3pnlw7GZe8I9ZBqeNJ4EYPxsxi0F1MHBwaTQ0w0vMas4UD1jlNP5DFZWggOLLmhd9kXzglG7ACcyJ4mc2wWAxxLyjDAZun/VhVuJB8Ta/1LucYxr4UV/Yn/LMAzPTV3ixLP6TNuEbLmBcSf2mS7yX9/JeXlWgDt5UWCW9qVAE8cai344B5uFN5V+AAebhTeXvwMOIPPz2a7B4PcL9edb6z12vbvanz4O4Bv7E/dKXeTjmfAVvvMsUYX14SR6sZ7AYQ8CNA5J68tBEkvuRkefG1bw8tA7SCBOmcZ4HJ5gdsiAUsbM1LQ+O5hmCsC396o5+0O0VvL4e+GEb9zP6oeOjjY7EYJzSLg+5e4V+f9tG9yuHjjx0XdWeSDiNLkXXHXnohZFdkXAaXZH42JGHuHuF7mi4jc53Fi4PfTdx2RX/UYoo9nKuN/CWJ2hwW/D0WqsfBtH03tECp/EWirkcHvoX6BDR5WjRIAsdHobesktE3m36YGs3jjyMBA0Ohl7LwtaGjjzkwys4sjLkSBTG3uFheAGHiCFAMz6OfhgLGpZTNFDxdl/wx9EP8cgV1BQNTVk4+kGPnfA0oji6SFr9MB5CWoCTAabf8jCe7rNETAaY69ZejJ+wmCPJgLRjrsfPqGdbWWIMhqkodhah4sEyPOQTZ6wnZUVKYy8muV7MIhQMrB8mE22eqzk+8Spfp9n6DzMJR2cohu8aSKJ/0zgNnXJps")
MSCBWRITE("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:586C")
MSCBWRITE("^FO150,59^GFA,3813,20355,59,:Z64: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:3B0C")
MSCBWRITE("^BY10,3,390^FT94,1665^BCN,,Y,N")
MSCBWRITE("^FD>:"+cCodEtiqueta+"^FS")
MSCBWRITE("^FT58,744^A0N,117,115^FH\^FDPRODUTO: "+AllTrim(Etq->C2_PRODUTO)+"^FS")
MSCBWRITE("^FT63,963^A0N,117,115^FH\^FDINFORMA\80\E5ES:^FS")
MSCBWRITE("^FT821,961^A0N,117,115^FH\^FD"+AllTrim(Etq->C2_OBS)+"^FS")
MSCBWRITE("^FT90,1249^A0N,100,98^FH\^FDORDEM DE PRODU\80\C7O: "+AllTrim(Etq->C2_NUM)+"^FS")
MSCBWRITE("^FT57,538^A0N,100,98^FH\^FD"+AllTrim(Etq->B1_DESC)+"^FS")
MSCBWRITE("^FO0,551^GB2347,19,19^FS")
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
			MSCBWRITE("^FD>: "+cCodEtiqueta+"^FS")
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
				// GravaSZ4(cCodEtiqueta,cCodBarExp)
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


Static Function fGravaCB0(_cCodEtiqueta,cCodProd,_cCodBar,nQtd,cOPE)
/***********************************************
*
*
****/

	dbSelectArea("CB0")
	If RecLock("CB0",.T.)
		Replace CB0_FILIAL	With xFilial("CB0"),;
				CB0_CODETI	With _cCodEtiqueta,;
				CB0_DTNASC	With dDataBase,;
				CB0_CODPRO	With cCodProd,;
				CB0_QTDE	With nQtd,;
				CB0_LOCAL	With AllTrim(SB1->B1_LOCPAD),;
				CB0_LOCALI	With AllTrim(SB1->B1_LOCALIZ),;
				CB0_CODET2	With _cCodBar,;
				CB0_TIPO	With '01',;
				CB0_USUARI	With __cUserId,;
				CB0_OP		With cOPE
		CB0->(MsUnLock())
				// CB0_STSTF 	With '',;
				// CB0_ZHORA	With TIME(),;
				// CB0_ZTIPO	With cTP,;
				// CB0_STSTF 	With IIF(SM0->M0_CODIGO=="01".AND.SB1->B1_TIPO="PI".AND.SB1->B1_GRUPO<>"3001","0"," "),;

		// aAdd(aRecCB0,CB0->(RecNo()))
	EndIf
Return()


Static Function fCloseArea(pParTabe)
/***********************************************
* Funcao para verificar se existe tabela e exclui-la
*
****/
	If (Select(pParTabe)!= 0)
		dbSelectArea(pParTabe)
		(pParTabe)->(dbCloseArea())
		If File(pParTabe+GetDBExtension())
			FErase(pParTabe+GetDBExtension())
		EndIf
	EndIf
Return()
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
