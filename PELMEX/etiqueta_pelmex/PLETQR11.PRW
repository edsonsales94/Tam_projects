#Include "rwmake.ch"

/*___________________________________________________________________________________
¦ Função    ¦ PLETQR10   ¦ Autor ¦ Wilson Guedes            ¦ Data ¦ 06/05/2021     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Impressão da Etiqueta da Namaspet Laranja                             ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLETQR11(cNumOP,cSeq)
	Local oDlg
	Local cPerg := "PLETQR11"

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
/*________________________________________________________________________________
¦ Função    ¦ EtqPel01b  ¦ Autor   | Stan Lee Lopes          ¦ Data ¦ 22/01/2019 ¦
+-----------+------------+---------+-------------------------+------+------------+
¦ Descriçäo ¦ Montagem da query para leitura das OP's abertas                    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function EtqPel01b
	Local cQry

	cQry := "SELECT SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN AS C2_OP,C2_XNOME, SC2.C2_PRODUTO, SC2.C2_EMISSAO,SB1.B1_DESC, SB1.B1_COD,SB1.B1_CODBAR, SB1.B1_CHASSIS,SB1.B1_COR, SC2.C2_QUANT, SC2.C2_YSLDIMP,SB1.B1_X_DTOP,SB1.B1_XENROLL,SC2.C2_NUM,"
	cQry += " SC2.C2_DATRF,ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),SB1.B1_XETIQUE)),'')B1_XETIQUE,ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),SB1.B1_AVISO)),'')B1_AVISO,SB1.B1_XACL,SB1.B1_XMODELO,SB1.B1_XCOMPRI,SB1.B1_XALTURA,"
	cQry += " SB1.B1_XLARGUR,SB1.B1_XEMPRES,SB1.B1_XJUNCAO,SB1.B1_XINMETR,SC2.C2_XCARGA,SB1.B1_XURL,SB1.B1_XEMP,SB1.*, "
	cQry += " CASE WHEN SB1.B1_XEMP = '1' THEN 'PROBEL'  "
	cQry += " 	   WHEN SB1.B1_XEMP = '2' THEN 'PELMEX'  "
	cQry += " 	   WHEN SB1.B1_XEMP = '3' THEN 'SONOFLEX'  "
	cQry += " 	   WHEN SB1.B1_XEMP = '4' THEN 'POLISHOP' "
	cQry += " 	   WHEN SB1.B1_XEMP = '5' THEN 'KING STAR' "
	cQry += " 	   WHEN SB1.B1_XEMP = '6' THEN 'INOVAR' "
	cQry += " 	   WHEN SB1.B1_XEMP = '7' THEN 'NAMASPET' "
	cQry += "	   WHEN SB1.B1_XEMP = '8' THEN 'COL.CAIXA' "
	cQry += " ELSE 'SEM FABRICANTE'	END EMPRESA "
	cQry += " FROM " + RetSQLName("SC2") + " SC2"
	cQry += " INNER JOIN " + RetSQLName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = SC2.C2_PRODUTO"
	cQry += " WHERE SC2.D_E_L_E_T_ = ' '"
	cQry += " AND B1_XSETOR = 'NAMASPET'"
	cQry += " AND SC2.C2_FILIAL = '" + SC2->(xFilial("SC2")) + "'"
	cQry += " AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
	cQry += " ORDER BY SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_PRODUTO"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,ChangeQuery(cQry)), "ETQ", .T., .T.)

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
		If nQuant = 0
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
			_cAux    := AllTrim(Etq->B1_XETIQUE)
			_cAviso  := AllTrim(Etq->B1_AVISO)

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

			if !(AllTrim(Etq->B1_AVISO) == "")
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

			_cModelo := Etq->B1_XMODELO

			MsCbPrinter("ZM400","LPT1",,,.F.,,,,)
			MsCbChkStatus(.F.)
			MsCbBegin( 1, 6)

			MSCBWRITE("CT~~CD,~CC^~CT")
			MSCBWRITE("^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD"+mv_par03+"^JUS^LRN^CI0^XZ")
			MSCBWRITE("^XA")
			MSCBWRITE("^MMT")
			MSCBWRITE("^PW2244")
			MSCBWRITE("^LL2717")
			MSCBWRITE("^LS0")
			MSCBWRITE("^BY9,3,343^FT612,2375^BCB,,Y,N")
			if AllTrim(Etq->B1_CODBAR) == ""
				MSCBWRITE("^FD>:"+AllTrim(Etq->B1_COD)+"^FS")
			else
				MSCBWRITE("^FD>:"+AllTrim(Etq->B1_CODBAR)+"^FS")
			endIf

			MSCBWRITE("^FT1416,1457^A0B,83,88^FH\^FDCod: "+AllTrim(Etq->B1_COD)+" ^FS")
			MSCBWRITE("^FT1419,2375^A0B,83,86^FH\^FDOP: "+AllTrim(cCodBarProd)+"^FS")
			MSCBWRITE("^FT999,2375^A0B,83,86^FH\^FDMedidas^FS")
			MSCBWRITE("^FT1162,2375^A0B,117,122^FH\^FDFabricante: "+Etq->EMPRESA+"^FS")

			If(AllTrim(Etq->B1_X_DTOP))== ""
				MSCBWRITE("^FT1280,2371^A0B,83,86^FH\^FDData de Fabrica\87\C6o: "+DtoC(StoD(Etq->C2_EMISSAO))+"^FS")
			else
				MSCBWRITE("^FT1280,2371^A0B,83,86^FH\^FDData de Fabrica\87\C6o: "+DtoC(StoD(Etq->B1_X_DTOP))+"^FS")
			endif
			MSCBWRITE("^FT221,2407^A0B,100,79^FH\^FD"+AllTrim(Etq->B1_DESC)+"^FS")
			MSCBWRITE("^FT1007,2071^A0B,109,115^FH\^FD"+AllTrim(Etq->B1_XACL)+"^FS")
			MSCBWRITE("^FT822,2385^A0B,117,112^FH\^FD"+AllTrim(Etq->B1_XMODELO)+"^FS")
			MSCBWRITE("^FT1538,2383^A0B,83,86^FH\^FD"+cLinha[1]+"^FS")
			MSCBWRITE("^FT1642,2383^A0B,83,86^FH\^FD"+cLinha[2]+"^FS")
			MSCBWRITE("^FT1746,2383^A0B,83,86^FH\^FD"+cLinha[3]+"^FS")
			MSCBWRITE("^FT1849,2383^A0B,83,86^FH\^FD"+cLinha[4]+"^FS")
			MSCBWRITE("^FT1951,2374^A0B,83,86^FH\^FD"+cLinha[5]+"^FS")
			MSCBWRITE("^FT2055,2374^A0B,83,86^FH\^FD"+cLinha[6]+"^FS")
			MSCBWRITE("^FT921,893^BQN,2,10")
			IF AllTrim(Etq->B1_XURL) == ""
				MSCBWRITE("^FH\^FDLA,WWW.PELMEX.COM.BR^FS")
			ELSE
				MSCBWRITE("^FH\^FDLA,"+AllTrim(Etq->B1_XURL)+"^FS")
			ENDIF
			MSCBWRITE("^PQ1,0,1,Y^XZ")

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
	u_InPutSX1(cPerg,"01","OP De?		 ","", "", "mv_ch1","C",11,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02","OP Ate?		 ","", "", "mv_ch2","C",11,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03","Escuridão?	 ","", "", "mv_ch3","C",2,0,0,"G","","","","","mv_par03")
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
