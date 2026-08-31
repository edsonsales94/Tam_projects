#Include "rwmake.ch"

/*___________________________________________________________________________________
¦ Função    ¦ PLETQR10   ¦ Autor ¦ Wilson Guedes            ¦ Data ¦ 06/05/2021     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Impressão da Etiqueta da Namaspet Amarela                             ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLETQR10(cNumOP,cSeq)
	Local oDlg
	Local cPerg := "PLETQR10"

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
Static Function EtqPel01b ()
	Local cQry

cQry := "SELECT SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN AS C2_OP,C2_XNOME, SC2.C2_PRODUTO, SC2.C2_EMISSAO,SB1.B1_DESC, SB1.B1_COD,SB1.B1_CODBAR, SB1.B1_CHASSIS,SB1.B1_COR, SC2.C2_QUANT, SC2.C2_YSLDIMP,SB1.B1_X_DTOP,SB1.B1_XENROLL,SC2.C2_NUM,"
	cQry += " SC2.C2_DATRF,ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),SB1.B1_XETIQUE)),'')B1_XETIQUE,ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),SB1.B1_AVISO)),'')B1_AVISO,SB1.B1_XACL,SB1.B1_XMODELO,SB1.B1_XCOMPRI,SB1.B1_XALTURA,"
	cQry += " SB1.B1_XLARGUR,SB1.B1_XEMPRES,SB1.B1_XJUNCAO,SB1.B1_XINMETR,SC2.C2_XCARGA,SB1.B1_XURL,SB1.B1_XEMP,SUBSTRING(SZ4.Z4_CPRODUC,12,18),SZ4.*,SB1.*,"
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
	cQry += " INNER JOIN " + RetSQLName("SZ4") + " SZ4 ON SZ4.D_E_L_E_T_ = ' ' AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN = SUBSTRING(SZ4.Z4_CPRODUC,1,11) AND SZ4.D_E_L_E_T_ = '' "
	cQry += " WHERE SC2.D_E_L_E_T_ = ' '"
	cQry += " AND B1_XSETOR = 'NAMASPET'"
	cQry += " AND SC2.C2_FILIAL = '" + SC2->(xFilial("SC2")) + "' "
	cQry += " AND SZ4.Z4_CPRODUC BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
	cQry += " ORDER BY SZ4.Z4_CPRODUC, SC2.C2_PRODUTO"
	

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
/*
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
*/
	SB1->(dbSetOrder(1))
	SC2->(dbSetOrder(6))

	While !Etq->(Eof()) .And. lOk

		SB1->(dbSeek(xFilial("SB1")+Etq->C2_PRODUTO))
		FimRegistro := Etq->C2_QUANT - Etq->C2_YSLDIMP
		//For nX:=1 To mv_par02
		For nX := 1 To 1
/*
			If cSeq == Nil
				RecLock("SB1",.F.)
				SB1->B1_CHASSIS := cSeqB1 := Soma1(SB1->B1_CHASSIS,6)
				MsUnLock()
			Else
				cSeqB1 := cSeq
			Endif
*/
			cCodBarProd := Etq->Z4_CPRODUC
			cCodBarExp  := Etq->C2_PRODUTO + Etq->B1_COR+SUBSTR(Etq->Z4_CPRODUC,12,7)
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

			MSCBWRITE("CT~~CD,~CC^~CT~")
			MSCBWRITE("^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD"+mv_par03+"^JUS^LRN^CI0^XZ")
			MSCBWRITE("^XA")
			MSCBWRITE("^MMT")
			MSCBWRITE("^PW1417")
			MSCBWRITE("^LL3874")
			MSCBWRITE("^LS0")
			MSCBWRITE("^FO64,32^GFA,174080,174080,00160,:Z64:")
			MSCBWRITE("eJzs3MFtg0AUBmEjDhxdAqVQGinNpVBCjjlE2VhWnMTEoDhz2H+jmQq+CwLeWzgczMzMzMzMzP5jfXmuTdhNH2sqpTZht3RfKeVU27BXuK8/+5IvkHTfePa91UbslO6bz77yVFuxnT7WxbfUVmwX7uuKPtJw8b3UZmzWhi/3BpLuG")
			MSCBWRITE("/Wh2vDlPuGn+4o+1Icv9g0p3NfrQ119r7UhG+ljHfWhrr7UEWq6b9KH0sdqxrfUltwv3Vf0oT59oROscN+gD6WP1Y4vcwKoj5XuG/WhvnyZK+p036wPpY+lj9WQb6ltuVe4ryv6SPpYLfkSNzT6WOm+oz6UPtZ3X+IGSR9r0ofSx9")
			MSCBWRITE("LHuvGdamt+lu4r+lD6WPpYTfkCj0DrY+lj6UP1+lC3vrwBjD5Wuu+oD6WPpY+lj9WWL+8ETLpv1ofSx2rMt9T2rNPH0sfSxwr3dUUfSR9LH6s1X9onoum+QR9KH0sfSx9LH0sfSx9r7Uv7xUC6b9SH0sfSx1r70hYg+kCLvr83rWX")
			MSCBWRITE("6Hmm+z9P3i94BAAD//+ydPZbcIAzHx4/CTd6jTRWukBtwpdyArXIuH8VH2HKrdRZ/jUESiKxn1zD6dx7b8LMBIUB4bki7EL4SEY1D+Ji6OJ8i8YSPIyd8n5FZUAasnK+wg+HqfAuJnwrSwlcu6znWSNh4fkj48ro4X79VvkXCVyjj")
			MSCBWRITE("MV72Qy18RZojDob98EfUGQtfRt66jMEvwleisHV4aeEr0MX5PEy8CHjk++4dPlfnswiCET6u+gn5CMiFPvF4dT6DLuE74eNJAeM8ywgfT1fn0/gKrxI+nizxiSYrfCxNxCcItfBxpCj/WAkfR478wpoTPoYuztfR8UvCx1BP73/qh")
			MSCBWRITE("S8vQy//Vcy32u7xkWSLUm/H1cp3Hxw/lO2W6H29hC+r/+I7LmE/YvPA4c/hder7sLpSvinQY9B2JYyvqpPPhAmcF74N4aa0ja2SL96+fE4JG5DqqpfW+Mz22t2Eni8XWq6rkrXHCt/5fPNPr4fTn+1EHKS6K5l0jXzq+NI3C/4Kzr")
			MSCBWRITE("BFFu5yYmTcWxWf/+3v/RAEQw1FdHjU6/aUfca21shn78c/bkhvUrbYbpN8tz5tujrhO51viutEXAOHAjyH4rEH1nXyxTdHbbDABMYP1UXHWbnq+Px83G8ym1kvXDyNPNCKyGxlNfIh5Wf+p3JvDStOrySR+vgMtVi8XOSLh+kNdlR")
			MSCBWRITE("r6vmtzAjfyXwOz96+7ee5xsuS7VSlrcCvuvnGbLYs47X0Ovi5nj6FXNgA358gXw5fl2wEhllLauTL3cOb78gUIbOWVMfX5TO3rKrtKOOySCctjPB9I1/HcY6wkPBAhuVide3xqY7jwWQ9lJ7lBzXIR7o4R6l061hSYbiATfLhLnaU")
			MSCBWRITE("eTad5MrqLtsgX581rT3H+rJ6YOEj9Y18hjN+tBw/rUW+rIfqrd+YTUUDP0jDh2qSz2ZMl2YNATrA556Eb9pENALm4MfFT/kcfHY6ajz8vt7qrTMD78MKhX5Qhzyv8H01X7we/nqHWvsVw5z9fko+N8V639NZaR1zCSdeymiB7+bSf")
			MSCBWRITE("IBumhvDnfrtxhp/Yjwdcl99fEnTkIqkWvWS2JEQ84X1oG+eL1xfNiQjC89nHvEN4BItfGfzjXSCbs79eAGKx41n1CGfgXw/m+LTW8ketBf56/2AG2Kkw7wQvrLyvQKfSfDZCekagq1AakIe4cn4yM6TmBQNPl6lPsWHXVIZHxr/st")
			MSCBWRITE("1P7RQ/PBL6sRRCSvguxNfxLJvj278W+W7k4KbnBf0oqhYgapNvhJctJ3h+u+VH4IW2FnM92+EjPsMDlV45DSKyW+SjliV0QVBroh0FEML39Xxw2WSRZferJlFR1fSkfB1/2JiagLHN8ym8HE3B1xoSK6dTig+5y1bHR6y7u7J9C8Q")
			MSCBWRITE("ZE2aWL98q+ZD3zJ5U9iKqyA0418L3DXyo+edFI+35El11/LGmJvnQ8BZLNklMhuCLXdfwCBsfVciHxr/ye9+FA+eLh1hN8mHxm8xNC5s6ct9MZMrGNvnA+EEXbtx3KF88hDnMD/mpVOH7Gj6kA2GEPIdJDNivsRG98zlPgfQfIP65")
			MSCBWRITE("Bj6ksWZ3nXEEfKB9fWEuRWzesEo+2FnkI2I5AuPOjW/f4D60wWfjKxOLIgUC7W7js8L3pXxgqo+xo4Ih0C+t8Qf91Bifildi3Bl/AQOHqHaPZ1wFOim4P7QGvniyhR5vlwgOUVc+3/lO76ohPhNaeno+qkQWpLLwzf9vYN9hraqXL")
			MSCBWRITE("xpHs3a6MPiiVLo9tHaYTQ3itxvhewSfN9uHw3P+oQuksvbqc17qgw/0z9XyhT2wOsU7hUZ0idddRhOeD1nXqZUvCMJA3juueTGKuhQO8Rc+s3B/oCETZ65SvmCmjun9bW7cgJ79BwAA///snU2WqygUgM1x4NAlsIW3gmYrvYyaae")
			MSCBWRITE("8sS3EJNXTgKTvABe4fJqe7qk4EM3ivNAhfjgL3X0XFNxClHGbJplkBTstn0QpdNG7guLUcml/4MVLFD3xw3myui4vvl/huaCaSnqc7+hEIJSs5uqlGnZxdTrJwfL2QwE7L575Z0p8zOl/g8z2t/n/1aZAmnJC/OsDogzvgk1+r73g")
			MSCBWRITE("SPpN2ENLzDfeA8g9suq8FZUqaSEIqW3TleD7LRJwT83VpJxjw94xvEa3dIBqfdBmOvl+D+bhfTKu/exY+u6cnd8NXoMGz/d2gTnTnljSRjP5MTFrwP/zi+z0+990/c9f9IU8O44tXki1ai1OSyfDwnO6Yj2fPnpmvC/uB40M90xIU")
			MSCBWRITE("8UqaSan5+eTWCmSZ71Py2TPzmT3qz4jPEj6zxaa4i+Elvt73nn1pU0i9rocP8j1oz1aNuKCDa3yj4iQA7XxDfCy77dR8XqQ75gOSnvWgSNCjsjwDH0wtjW+/+H6QL+QL0ieH891DQwqk8HHJM2pduVSR+exEivy5+fzXM02S3DU+l")
			MSCBWRITE("get8Wna0dzhd4oofKX3b52Fzxe5tJSPDA3SvmWqzyt8oC89Hg3QB4APd3V2Pi1fX+PjGrnk64V2CWa/0fF9Jr6uLj7jv56f8A2c5xU+kFsefLC6Bz5SUqL0fr+L75v4bi/xCXle8oms+2ilcatrEEpr5PMtqEak8Al9UvIJE3Z0yY")
			MSCBWRITE("e4znutfKIOscrHRRPBJ43P0Vnt+MDPFedLbjSdn29k5mQq/4FR4imfND5HtdLxgJ//XiMfD5pS+ERZI6lfWs43YD4s/2C+VPrm4vsxPu7WU/Qjy3EkXzlE3fMg/QCrqlXwcYvIC3yG9ycD0lOokFdNkX6K+YYa+chuEpx6bGuV+7G")
			MSCBWRITE("ITMyzLqBVzMfmB7U/m10aNySfG0ecWQhf/okIxtTBRw6J/8PzjZxP7MdGjGATcLifaNbRuKWL78f5uMcJ87krH3wjWxSlE/zxE0Z0Ng8Z+AaVb6qAj3ucyM3znT/uFVUBWBxsDLpDWgDaTwSfqZuP3O/eC+ecj/bnv3fDIz60n3DT")
			MSCBWRITE("P+LLry2tig+tN6PGR+uHBRX7Tvnsrs4H4MvoVfCJxfae/h5DULCcD/ko95/5iE7DjUu5//Hi+3k+4dfDHhQnrJqdPUHjF7KnmvT4IT6DtU1e9LR2PlzUHPhm0mD6yuJm0BDDUeYjeR6cL+/etko+YoxYFcvotOYmQ7q7iI+aTCRfp")
			MSCBWRITE("KmUj71khyfdO5NRauKmxxwbxo6otimlxUiz18F3Z2d6wif25wGSiXzTHd3K9HIZuiAp0vZ88f0anx6Mi/nF/pxNCuQ9TWOGxpcU+fo6+J6k9iT+j8jnOgM+uzNhB6DzSVUAXlrii3bQ2C6EUW1h6J0pA2F8voDO7DhMKdMEX7KDJn")
			MSCBWRITE("ty5stWvmBkXunJAp+5+H6R71nqYBrsI/LNXfTQJK9lsMiEroyQZxlvDPWYWuDr2WAgWg0Q1wGRc2EEC+l4rEcj+Hyf+VU3DfJBXEJ40m8wgheFZBVpGhrzOGiJz4Svb8vjn78834r53Gmv58zxpC3E4YePr58ZfsFQCR93/tEPKD0")
			MSCBWRITE("3v344CJuVcXg/qJND7uHk3Y0qBkN8DmYOq9HF90Z8Q+KLQtRnFwPPyYw1SqmMLK/6LWOOeYUN8EH8bu/5/PwFPrNF1YmU3MVZ2emTQvPB1B4SJvYq+PqX+O7o98yMj8h7g5Zcnfj8LV0h9LMJPpBT8vW94CPFMXYRp9iledSlqlsu")
			MSCBWRITE("lbRvhK+jpSayZWgG0xLOCxX1d+PZ+H9oanzWzsX3Bnx+3/CL/hLab5nT85HsNKsWgsqh5HCxe2Tb4HPT1M+0BeSWyNdlvty5jHMKH9AD0jo4eCGmKb4N+Aznw6lnplA6JFYgigulM6HuzfCFJ3nkfEu8v5lvKhTHinXYsql/X9rgc")
			MSCBWRITE("7vpuK9uEfk79Ez4Hs97n68fS6WTgskexTlO+37xvQufy8iJ61p2FthFuG72YukzG+yriY+/Jbxuvq8cpISCB5aOlRSgcTGMb3Wr4NwaX8/4/uRUELswz9XR20d9shnREurhW57w3fYvk+5cvoMPPhqaYMrTI0iAE6Joim+d9qxBUL")
			MSCBWRITE("58sU9lL3bkbj3O8rv4folPBNczvtmZYBIfiny2K3FluadPF67ShZjPNsVn9mQxTq2BD479KAeeioHxjU3xDSC/4Vvo+AY6Smn36IKp39zJcUN8XR/VmbyCOD42ykFH3En97XzTW/MljSE3lnwHt1c6+aeLryo+HoTQGp8JHaHQcsF")
			MSCBWRITE("34ESTJVpMJXzP5D/Yf9eo0cyYj+0fx3wrO26KL3AZKb/gz+EEaZlvgh6Gcd/6GfOl+WLIzdf4eAmyi+9d+HT9cqWpK05iP+rq4nOfnKwT+NDF06GCJPhsLXzP7H8PPrOr9tMb2TKO7H+djGP+Fv/qGfhcz3aPcUSUj9ufD0SYJvmS")
			MSCBWRITE("/T4XYf9P/g+F73viXy6+/883Iv9WNnIrfPZoBWyS70/gWx+TrV/8Geo/l3VC5lf5viW+7t35fH2VcCeK8Qfo+unAhC/4TFN8G/Ap8UNzal2KH2qXL8UPzaX4KzJJbHmFFnyvxbdffD/LB5HeX3GeivhOUh/nQMRqkw9eqoT0IML3S")
			MSCBWRITE("VTOrhD/rPO9lh/17nxP8hdE/LiMvyfv7bHFHaRNvvi2MJ9fFtovjI/E39+KIqDM450uvjfgQ/lRX4wvvh+PWWF0I0K1fIf5l4RPz8+j1XK0/LwCn2mALxZNyfmNY+YD+x/N+N0LImq1fMf1VaB4wS3NDyg9NN0TH8kPVfKnS3yv1Q")
			MSCBWRITE("c5OZ/hGjfOP4el+bHp5vzpvrBCX3xvySf8D7G+ReBLlQI2z+lOTroRRqlDUgXfk/pNWf7/iCdC0mrX5a3XYD41hbVZvrS/FOoPbdDJlpoWRECFz7bAF/vt/wUAAP//7J1NlqMgEID15b1xme3suMLcwKvMScYczaN4hCx70a+dCCL")
			MSCBWRITE("1B1Y6ne6A1Ko1WHy2CkVRFF6/RTOea523cX6utWsWP7nD8vnu9J/nsy6Pyf5N8q+5k3yzgwifKr9o5XuMby//JNu3tAP59cLmloCPbwZyLD6wA9WZTpI3zkrZnOIzaOy2lay9ZOILjaIqP3V2fHAr59tDofv7LPEIAcU6QVcFw0fQ")
			MSCBWRITE("wHvgw/DBHSqXl5rlA7tx9ABl+0TC+gR2icynys+fHR/0ly2fiqFP6/ZwwxlbxQfhM4IJXfl+hk9ITxpw+luXYD9RWCDsOGzr3fQHPuwSjPOZIvhIYw/nCzY++IQxn+tEMR/af+FgfOh4MV6k/T/gJYPnB3xn3gNLfF2RfKDwA/vPj")
			MSCBWRITE("Afh4/tHIb7Zvuw9et07om8NLcbrZ6lVKTk9lPsPVr7H+CZ42CPNC9/+/mCDrQGv76VVHodvBEcumTxRLaTst/dxRWcmXOYwfKidsnGxTPVA9fXx/RtTfJsBWBAfbuc7l4mRXGKoPj6pxXZdKZgPXUn5roILTrV/LelvRT7F/uKV7z")
			MSCBWRITE("E+Oh0g8Kn2d+ZN4uUQfP0O3wgX9WyFJnKC4TALplC+EzXesR7Lx/pbztcyPvrExUmvU/Z8fnCT4qMmtsDH8huwIWaZfND/KfG1a4jfLp+h7z8dYla+n+AzO3zdykeNJcbH46hJAyhHxeTO5wxEWJvER5MriHy0fnMAPuuZwC29xNc")
			MSCBWRITE("wY4Tx8fo7fEaYX222EIRc+Wznq+LDQBIf7YBJl1win4vMxD2lYP8Jxgjn66mR2OKbqnzfz7e0fu3llOAzPjM86Uw5H49jwANXme+cM9+aUQFbGiIf29JS4uNOmcL5zOzzDkb5Ql4Q2Jgxe7Ah6/TWM1BVgXzz6uRElgZ2BoW8IPCR")
			MSCBWRITE("Mv9fQ9fprRcDVbL90mbMd/aWc5wvVDqAyvh43ZUYyRnMJ0ZtV77n8fX+vIG/o34gNGqwBeT+LJkPdsncwZU7Xzf7/z+6NsIHk6fIIbWGUUNVRuZbB2g58pntNGrcyHr8KZz3pYZZ5OtYCwe/o6E4vmGjQpZui/kusLxf9CG5koUvA")
			MSCBWRITE("PBFU69kywc3E4GWbpQP5CsId4NoGEHwu3axq0zlew5fD14jNJKxKyt9IfhJbuHKoqUkuMj96KBxfqqy+OAFbDLUy5k4o53IZfmUeeA7RY2AXPnQTnyxzvEmf9GRVSavz1++OO4CXIn74vhu7fZ1Swohrxi6V3hQoudbXgweBbIWqX")
			MSCBWRITE("xP4FuuGKftMB3hoRV2l57PmhRF8REjqU8n51bzkXra9Ys2S1sbs2qz5DO4OxTivT8h/C5X+8eu9+Hjp0XaPPkG3GMI8d6fEH6Xju9kXyZ5VJ8nH0vyMHxFA82DOh2f8/7TqO7K9zw+Fi8qrfi7X5gWt07TzY4J46ds+Xr6vSYs1Du")
			MSCBWRITE("EaXGh++6f0YojpDz52JmIe/NOYVH3nm9cDuR3SDT9X5yP28tL0/DnYT7WwFi+U7BiLmXwCSU/1cB0I68MHds8CT566yRa6ZXv6/kEGBphsCfQyxXXYvk2v9YsWcEZ8kn5E+4corMlZpuWd3z81vgUc0KvlS/fxMrdN0SXjTn7CC/o")
			MSCBWRITE("+A3YLeIoIkM+sbMV//lRMRG+ntz6jQ/cCotDz5NPVH5Obd/LJPY2dHw1BBhX8nU3awRM5ftKPrGpi2ceFiTeWhLHBOaTpBS+6Ax3ROko/2JwZSXyRZxVRhz/ycI9fV46bKRYPqm2jPkiD4doTkqis+6PwCcVtFMiOrzUq3CufD/MR")
			MSCBWRITE("4PpQUmliZ9sKgfGl9TFp9ZfnS/2cFCyxpSku2pD+o8dyZEvQjEre5A+aSq2KD/Lkfio8ZvQqCjmipbHx+MwvbT0TmQZ9EP59O6ua5HKl6h82i/C+KLvxKDpghc77PpbhVckH1sMjcvG0rhdQRm1p4alziqbzzmTSOU+KvEjXuRQfD")
			MSCBWRITE("yMFerjTYxZ+fwkM3zYlY/I4OofOR2S919avkvleyW+TsThosND8fvl8KWKD/ts773a01Ugn7w4MYiINILNFt/0rupWUa40vlbAuwDu5epBOZCPm+rl8gktsjs/hAOjHIEkTPXK91N8YR2UkwlUF1bLq3qQlClcLl/T/JXooMw6E5U")
			MSCBWRITE("vqT4Gn08bE1Wf2AcbSKsZSOXHp3gye4/vFH3yUFSrIuiQ7PX59p/MfrSs0ZgwsYkWJJUvKk/jM7t8Sw+yU2T/LbZSIp8iWHbYbwF1i4YK5Bv5SmgmZr8L1oUsl8d3EvdHo4XmvRZGo6Xh8Yn58/FlHDG9b01iHsTovCCV79v5eo1d")
			MSCBWRITE("FE+5EH6/FMi34/9bRDf6XlrAhKpe6eTKkG9KX6GMI+Kpt6GYxOiqbD51HNs5MQRt0w+/8j2TL91tG63mVDaY+C9E+PrVV+cTnXK2mD1/ntULGdbkpRf2g50l005B5MYnDb6jLtO0mEj5Qa+kDL7lSf0HAAD//+zdW3LiMBCFYVJ+4")
			MSCBWRITE("DFL0FK8NHtpXopWMkyZANalJbc4OGqnzl95SJga+CjjG8hi+1FfBxIO7VhinXaIVj6/inWfcHjiIl7DdUjh68KvN4yvP5X3QN8Bvnxyhig1rzJewf9d35jsGpONX9tMK+lze6R+ibjz+baZYO9N7971dm95y+vxVZ/mnso3BAsx/g")
			MSCBWRITE("bP4aYfevhKGrCw3cve2ex0Pt8luMW9t1DjxtwXDAb19P2yL9/oo5NfySux4qmL86Nb92VrnAd5a8JC/ql6tHtKX7rT/MTUYZd8P/5srvwf+fs/rPviQYjKMxlV0vGg/3u+cFFAm2apdDnXnv9I3xG+YA3+wLyOQs973/uw56y+55r")
			MSCBWRITE("jD9Elj7OU/7X8ErDu+62qE2sN9O1We3T69nOVIxjF958fHn1YtdEgE337VcaJ0adoKu6B43fPemXdV94DX+nTVHx8R58m676xdIo00aepNPXmdiJPX63s2ygebe9aH/MmgTbrvuCrIqNG+nRd5RXkRp8u6z55yOhAn7ZRIjj6tIlT")
			MSCBWRITE("8k30qbvle5DwozD6dlp3tXN8k6NPn3XfV/YCjD5FpG+vKd0CjqFv7oMKsu5bt3bJKHb6Wkq2MI6+ttaT8X/RX/S1ZN0XjirNhsjMPWGPrPvuW7zl/ms2QHLuKvvJuu9xPrT9Rl9bpfGfHxtgCmbdVx7FTZ8q677i5LT06RIvBaKvI")
			MSCBWRITE("fqw5OtJPz5E/O3oQ1tnjUuV9LVFHxZ9WPRhpccx9LV1Np/vDUqiD4s+LOu+9ETd9/ak0YdFHxZ9WPRhJb65tyeNPizrPoMf70fRhxX7+l7dI0UfFn1Y9GHRh0Uf1kAfVOzrP/o+jT4s674LfVj0YdGHdSrf0luTRx+Wdd9IH1Tk64")
			MSCBWRITE("0Rog+LPiz6sL7pgwp99t7eoA+NPqwv+qDow6IPK/T53hgh675wBIzvbZGiDyvwzb0tUvRh0Ydl3efog9p8di4+D6MP60of1Pl8/wEAAP//7d3BDcIwEAVREAWkhJSS1iiNUlIKMquQC85lDvuR5skFzM3yaqNkHfuYsy/t49piH2Q")
			MSCBWRITE("f8+3bu0t+s49J79uOvu6QCfsY+5jFPiTh16FX7GPS+44V/MDl2A/7GPsg+5i1+l7dHTP/0Zc5vRrsY9L7asIWOh262Ufd7UOqb+/OmErvqxWEZ3fFXHrfah/yiL5+7cOSX0dDet8W/Doa0vskSeLeMyppBA==:14D0")
			MSCBWRITE("^FO1088,1696^GFA,17920,17920,00040,:Z64:")
			MSCBWRITE("eJztXM2LI2d6f6vK02UkR5VDwLDetMzsxYxhes8zZtSBYfeY3YPJJTD3GZjdw4KDbawaG5ZhDJM/IVrnIiSj7qPoMd1yEnJMHEggh5hUchLqpqSFPhQ9alWer/ezpLb/gLw72zNSP/3rXz3v8/2+slKNFY9glbxyeP1mU4RW9OsPf")
			MSCBWRITE("/1XNa98hwyu5PWr1ycnI/zfK5S7uwuvtgvkovUOubi0C+Tiza7f6+N1i11yY7tyleyCC/BuXTcERprffGL5HZWN59xovHXX4KXVGw25K5EbTR6MZOXJ1V5DThQF+kst3mETb6H5LXPDr5N3dvOr1Y148rygv9l9rb94Nz/Am2VGf9")
			MSCBWRITE("k/7eZXFh2jv4Mb9FcXicGLGvsRnYjcyWiYsP2d5EodDHbwA/0VkcFr2ovDr1I32J/Dr1I96x8/DeWs/qbqvra/0D/gh63+1irb5W9AxvK7UB3rv/6CH7b81irdhbcAaxO50WiCX8j+tuFZ/V1rJ/4BfqWKhF9rOBzu5lcrpe3P/Bp")
			MSCBWRITE("Z5+Ox1d+YXqP+MvPjDX4e3hsPHz705F68ePHc8Fvm6u4O/dnFeL3d8S8WOYp797T9NZcYRkQ43d14Jr4gr/2d/Bx/A5x0J17P0R/IGfsL16MfxKMM0XL3N5conWfLpXHgqJ7B137t4UXN/Y3rAXw9c+xvNBADRLlTLZfhj6Su/cEv")
			MSCBWRITE("iAy/T7XcA+RzWpZzy2+glNHf3CgETadXE8uQH7xeaTkwtUF0Pn6t5UBvAzFAkEsG5nE5oGQO3kwMEOT+3KgFeBRRuXw528rvgZbDn19F9SrA6wteZdR3+tXVcQSuoOXA7gBP7C8pLJ7qA57Scqw/NmjIbzMt15qrThWV847Pb8L87")
			MSCBWRITE("uZaLl2pDPDqf/X0p/EMPdWewp9ofHbk6+991t+JkctWKrkUUg08S0+1CqTYw6hs+IHcXc5vo9HQwVuhf6224KUO3rGKpyq+8u1P3dP2t3HwLnE/HfsDvG5oz60K/6jM9w+0Sj/+JRVCwoZ6/iF4yq72UGVTgHnt+S9nEFcOKplHiJ")
			MSCBWRITE("f9AF68rMsC/3Hl8dsP4wvZH/7jU/tabcFDeyO8O+Y11n33JP6ZcO9srXlt8bLafAPi8cDlS/FZ8zuwv7tf145YwK9+VOhvHIwhhIxsfqP8IfqLqtj4OcaX6Pvvv//PLXjRysaDdj1v5DfNL8nVBy4pfMjK4K0NXurWB7exOPDzr7E")
			MSCBWRITE("/pTo78CIX7xdKveXoYYX8bPy7UGJ/X760eBJftvL74veOHOjpOHr16tWJeT3V+nvRuREP/0X+9rkj1yrRdSeTic1vKEf++yLk5zy6i/fsn61cDHZ2LP9+96Cg+k9p+wv5abCMMsdK4+W/dPW3KUWuPdhUyA81yfEvzZ19S+oC9+HP")
			MSCBWRITE("VPYMnBjrU4MXzdRvrdy4UPGgNVLZ4HyC+hvAm5x/ITzbSNnFemDVXavuMzC9hN1F8sc6LYxcB/ygV/UWav8PYHpYPyuTP66+tHK9Nf4fqPURL/Lweo4PLwqp/x5/NT7Pwf5QbsH1X3xlxCLUV30NVtL/xwbeLVuudSSdLVQ5Wkzym")
			MSCBWRITE("MJK1KxferWSeq2fVL08Inez+des99Edzs/HV2rcHr6fJ5x2m/VLHzVZd9eH6jozeLcaeEm5AAO56IB02anu5gm5b0fql9yxlxUWVxijr7OVxpN6KLX2Ep+cgeRFB5R40jkGfifIt8P5F3bNt791BnL97qoPeMbdsB+0eMBD8JYvVx")
			MSCBWRITE("Pgh+4r9R+w9v2N8eo/4n44eHsPrD2j/6oLlHsy/p8xvEb3fZ/118nybfzqbxHPuBvgZQavvVwuK+A3f1M9Lb9dgj5RbiL8kkLjRR9++OGvItrfbv1szeaj6/E9VZnnpXx7fnV2pe6Nn2Hrge674PpvT839hrXmrojwChfvg7c8ObK")
			MSCBWRITE("/9iaagz4LJe4B/FT20hVjfsk6KhgvMnhv+3hu/zEAOenfOiqZNPkJ9EybH+Ipv5+x+SNBfonhF3sNcBTgpRbvU9VYkBGhcj4BuT3T//r5w8gd+niq2a8yyTlQy9Xu/lLj4X4otbtfpeLgCaaOBLNve9z0X3rI9U48O5DA/oPknmJq")
			MSCBWRITE("S5bK49cyWLChBq9u4Bn9HYygPihFDvwD9/mO6X8TE5+p/9iJl5r9pf7jQjHKMqcNvWv4nQ0creVm6tXnOUJP46V2voH9h9JWBikD//m+1l9m2l/uPzReL8CrjfqSEuu/pRS2GP+UVAcY/6qOi0f5nOQg/rl46crgxac55F+0NnwF8")
			MSCBWRITE("Q8btntif2lu5kNc72p73o1H/Yfxj0nAz4YDKO5Ty6+2z3uGz9s3eO1jlUwx3Y5of1l/Zv6SlQ4e9x9r2V+N93e0H2Z7sb6fs/7A/jD+Mb/lhPb3NPfwtL1cs70gXsb2omsR7j/K2199pR7z6EVJ9Uf2164sXnqpAv8AvE3m23Nrgf")
			MSCBWRITE("oj+3uKpVWM1TPq76XvH7Qfhl/VwNMKTCafvzpm+/vk1VnB/gv6m7zv+y/bC+P9938pg7fOwvyL9kf8HuMTJsLvouPHF9+eI4N3GeCpq9GrgWkzejnFP7C/4ztgf3umrKannCk9Bepy/AO8VTeYRzyQOTj9kiXY34zeK/D9jjNv6jn")
			MSCBWRITE("9R1QbvKIX4FH/kSgifQD2B9Ug+u/gPs6vvoodDPhGl9JkVAsePivi3bJVooqx/+jGmHbbJfIrKL7kyK9tyzUhmWAa7xJeQXgUd1R35sudQ+eMTfBZTvn3Dhji46D+owXWW3HrJnhrxnPTG7rA8iX47wPMHzGWzx2eocI3soEWy+pL")
			MSCBWRITE("AOmCQvv19YrrDUTvB/E5g8pPjbOjCeSP10OuX9rjIcbF3J3H4jwnuu7+EfGeVVwPZTzjRTyT37C/jOb7RameziPMbxfIbxYxv5bRNMXnqlt8hnOTFeOl9UzwcBbA24b9bzS9V2zUx8MI+GH9twf7zPnXxHu25+oR4tXfkhIRT+YIt")
			MSCBWRITE("wpjBugfUXUX+JXLZ8gPAswe7jPya5vxVVT/Bfhb1f8W8eqVweO+v292A+LdO8fRZPz3E9Ubj1F/eOwx4TmC3Q2cH3TBf/vPNmguFdf3EAQJz5mXxDQfWpYvSmzliBfI0Quav2h/g/iSYrz/wtgf5mONZ/0jHqrWVC3GL0aYisfYf4")
			MSCBWRITE("AuJlQXuvMXjYcJOdJ4aqPnHC4/2MNJSRt5gPkXDVD4OXKAAyG1Vyc0NCG8ahteMsQRVu+bNu3Q65z734mew1i59cO/hBA9S+nNVPrzXgOvBaVtpdrDNr2Zof4u6HlL//wt7H81XmjP8Vl9NbVPj3YH8ea+Evsz5wtb8MBgurOo75+")
			MSCBWRITE("/xdSfP3/+nOscsTtoRzgung6beFIPMR7GwNw5T0E9TWHfNjnWf2OZ/6VD8Gvv/A3xLrE+mFm8Qt0iQ4R+1Zwf8fwAh6iUf4lfQbvpn78lH3300W8VkXTw8DG3nb/BpkzVx6PRmOZ/xxAQc0gieToIzrfqmiMU42FDTH1747yMSud+")
			MSCBWRITE("XZL9oQFOcuzbOwO/HNf1fe9a/xP0lkLc2dj66s6dO+/i70XHus92BxHmPsh55296P0ijfQ7SG6ozbnnnb6w/jDOYP+bcekCghwiC+7vJAzysgxI9aacyJPLO38z8BeQ6ZznZHTrGu5CZ4a+DIsBTn/HMk/BmrFT8nb79KSrJNwtpj")
			MSCBWRITE("VjOO38z/D5TOmd6eD8N5CDkZWZywAOjc5SLQ7wNRIOZ4K0snl5v4oKvrRI84sULsj+ZtU1cOVpuPVnXejbWa8ihf4zA/tDfRmYWGJ6//cl3gf1JcOy7cuAJHZn/kX/wyUyTH9d/AV7d5Id6O8ZkO7X+SxNUbEZcuY3U96ub8VrLvC")
			MSCBWRITE("P++5vlkv2XJrwhv3rG/HL1ISzBm5GyXLn4pOgcK5LDrk3x2S/Jnfh4BfA7PDyU1zvxyqrjxEnmxxPzYD5OsyGzduEl4wnoT90Z0KuDnPVHr0h/ph6v679dISq9qh28iPD+WuuvXL6Eqr5mR106/Mh/lT4vS67r5Uq9zckic/FSql9")
			MSCBWRITE("s/l2A/96jrBtfjcX+EK+D9mfql6TCre3W4hshXn+m8eaTcoXzoArLKm1/+N390u1Xk6pbr9ielW8vPa9/S4b3wV3HWLrEr8dnuZ383YevZ7+3eCniXQOerl8Erx/0lzixWubQJz0tNxL/yD9o/mf7ywongLXKKlNf6V4T5382Pk8V")
			MSCBWRITE("6G8Bdqc+PvrDUOwPAbD/nbv9b38FUQ7iS/+S5k0SD1LcIifezxXO/zA+l9Uz4YfxhfqjzUsHD+s1wiuilY1X1B+llwbvPdUaQDAFP35y+sWQ/XdA6kMtmn4V1q3vhF+t+cmEHPdXeYv4PS2v5jY+S30/d8WY3yOjv9ycmwXzq/L2z")
			MSCBWRITE("6A+xdM7tD+K03L/oHG+v9H9hxTigmfmdc+fw8tlvZGSL5bwous/x9/WOklKfUrbm4X1H1nbOSXd5PU4l/xLIwRPjn6OQbR/6ImsKxeTt4rN3WX/vWD1Nc7fCk0qMvWGqkM8On9bUNUHHkJ9B9aD4f0Dzm/ahrsaLwnx4I0NmGWu6M")
			MSCBWRITE("1Y6iu1t42fjX+R1Fc8UfT4qTibuj8Heiuwq2vO/6zRquB81ZdrzRUnYahSpT6V81VfDmIcPa/JR7k5n/ZW/I2cf4y4/0Be5v5LHOKt3XrXnO97/C54fmXyr3LuHzjz4uTS56erIi8+KzpCp/nzEzoyYvPT9w/c+0jZpc/PxTMNP+9")
			MSCBWRITE("vXRM/vGJGkfqZ8Gt79fhK88uV9Ecar1n/Qcz7GOMK2N9USRSE+Fy6eAX+9R3gsY9AkJHzmXRt4x/bWwu+fFZCkksw+kVfML/2VSfA6/KljSrAs/FZ+rRPUGnt86Oczt8SySLZwKufczmOz/T51i2NN7PzxOVyQ1UCvjiV/jdNRH8e")
			MSCBWRITE("v7UcmmEKYrxU9OfW93TdIMUv8NRjPn9L5f5L4z5clysqxlMGT6ngPtwpV1TwV4TRLzPnb6a+58Xlhjyvi/d2YR4Y1Xw+rq9U6/V4jvUM/sC4YX+3UE7HZ8wf1975grHnu+gP5B+yvxfe/N4osG/iaZ9rjrWHZ9bHeN9gcWLt72vQo")
			MSCBWRITE("z3/UA5eof3jP77X86EGXqTj80JR5oi4kGmcf3C8c/232oqXjGugRTW9+O/UOf94L9GykdzfUGoLXrRK9X7E5fNTmVFJ/zt3+FXmwo++X2LxCgfPnk/HQ9WZMj+UA/sboP5G+v7BBx7ew4cPD7fgOfcZeP6y2WyuOD5H6M2an3sej/")
			MSCBWRITE("MX7z7DzDvf6vypyA1N/BN9DiR70Pmb6rxn8FJ7vhDgoZwUHK35m63KO3+b+fz+5cfxe+sX8rxn9WbK9sc/556/Id4/yPs6nm7jh+fJb+j9xYAMb8rklar6PYdfy8WzK7LH095+8PzFrgS9NhX9pbnaVxbvMsTT55dgL7+T9/X8wOB")
			MSCBWRITE("hpNHnl2ph7h9s5Wfui27M+UdiVXybzo+wtzT3Tw/ocmCw+jwHc/HUofnuc5pdkVyujvJoqZS5f6pawyac6ierBt629eQLPN+nBL7j/NLF2+zCm+hH+s2L6ojPt/T5tCuWmhGpxVMWz9S72Wu9HZ98fiznb2SPYH+xcx7a4/J2tg1v")
			MSCBWRITE("T80MHt2/ijcQmp9+Dvwi4jfR9lf48TlCUAev18Sjeg8cdubqT98/sHhcj3ZpfnATHuQziCj7aISO/u42+CX1v9U438X5xha8wt4/oPh3toD6b3N0Lvzu6fsHFg/n4+78hevoBj8oTuFPuTiV+o/1t9/kt6J6EnFvxIPgl3ytzvP2R")
			MSCBWRITE("PIH8Ws39Ed40g9avLTJr4L6NLrA+ZrkD3y3I/xeLF6GeJ9twUtVoeNLawr1czTFRo3zB9mf1H/u/F7wlIen6yvn/uRcdfBcBvhJ/uBdJ34te79TziuQH9vFRltRkH+hr5xGX5vCm/UXNfxXn1/q+/y78Lg+WOYt4HVG9Qu9vbU+WP")
			MSCBWRITE("H+YrmmcZvxYIHTlsXVZqTiBXiKXChZNO7f96UeqjDrVhqv38B7gAXfBKvmDjpJJLM/5mdiI5oa339eIZ6cJ5v7sc75ZRvDM3S7K/UOth4Jz/74/m5Wn5n6L8X00RUnvgGPxpoZktxfbpZ8f0Pf31VqprxF8aW7imqN15XnDeRoHna")
			MSCBWRITE("vAHLJK3pD3z8tXClIsbcOlXo0Uzfg9QrORyP1lPIH72pH+Fm83qxP8+I15pk+4B2yFkK88xHl3+hEPcnx/saYvpWK/Rm8qH5dW7we1wdb8KLyiuf3C+aX8HB8L+Sn5wUYDxy8JMRLxnj0gVdQ1WPiR7M/zsBb8czzbseD+gUPqIkf")
			MSCBWRITE("dJlc/8nHuFy8pOIjIhOvav5WaC/J6D7LmfqZIkAc2h/g5Ur43YQXz/dZbqHjH6dP4kdjBcFbCZ5b36vm/CWZ/gRe3r79M+g/8OQjOeFqaxHOX1YhP8brB3hxhfwgbi74W5HLr4FXmwAbyROGeMn0ndy/v/Y1/f0knF9dP/r+V159y")
			MSCBWRITE("v94FPIr5fzN1M8cYDDDuZ/H8edNPBPD1Q33Y4T2537+iAPMPTn/nezGOzR4ys4Tm/Uzt8L7or+1h2eX3GfVeLaPqk19Kvob07cy1l+WO3Lb8GSemGo5fF6wYFOIJnK40GF+3yh/GX3yebfGi1a+WGz1fsKjhA7b39yXS80lfLn/LH")
			MSCBWRITE("jOAf8BPu2+sKJ8V1l+zvSqi293zUNHoibGe2Dl7h8pShfShMj9cdGfc72Ypkz98H474zn0FKlpYu638/m58MusHB0b+59Xc/Dc+IL6Oh+0JuY1GWAnuH/A+wk/au2v3oYXY3mK8/bS6I8MsBPk32TdpeNoU7/U+qgm8F+Mf279In6")
			MSCBWRITE("bhf5bMZ4K8Lqh/847IDeXK4/cull+Lt7bDbxiG960xfz05/jk8yA/IfuLRxYvvQnv3z1+fL6g9UemyP57ZH4386vNDQKdnxhvkxZabpj9Lx71Jo7+cF7J8/ursZGr6f5B0XXwLjVe9J2Zl8j9g6UT/8gAsYBxPx9g4pW1Z7KRfh3M")
			MSCBWRITE("Syj+3eEkrDjxItXH3H8E98c9fyPbJLw95d0fr3Acrn8vJg4l+aPxeQgvHnh4rlylktf6oAj1h4WBmb94+kvMpTiNR/nSkZP+/EgHpqRkBwn5hUuf99QBv3DJ/YM4/PzHVjy51uB/HgdX29gZ6W8m1yTS4PM9eOHKx+N6KD0M8Lp84")
			MSCBWRITE("qtYf1AC0l955H7+A1dPqhaDJ/Xf5peFJ3dXh2cmVuj6b3Pky/VMTiK87zRe1/vsFB536BkRFX7HPAHMcTrordrHW5n6+dCXKzf6uUh/q+bny34AL1jnXxp+fH+j8fk3Xtf2Xh7j9bbjlW3X/vADSdv5rUO8mvF+ngR4ieGHne9UXX")
			MSCBWRITE("H/YeexN+PZ+a7G8/Q3l/43mQX2EjxvJf1qw57L5ER/PhkVN5TzD2e+y8urrwDPzA/svInxytLJH+Vczw9CfwvxugbPl1tw0FNif0OZv/wgXq9uxJeAH+tv8iP51Tv4WTnW3/k4jH834qWh/uyQkvR3LvO/LN/2OQyLJwvz0e92yJH")
			MSCBWRITE("9ncr8Gazvb34Mnlqnq11ypV2Yfwc/Cq+3a4Ya/Pc3bH1wA17zv72xk9//rxvX/wEFiwLk:489A")
			MSCBWRITE("^FO11,3207^GB1404,660,35^FS")
			MSCBWRITE("^FT161,3182^A0B,108,91^FH\^FD"+AllTrim(Etq->B1_DESC)+"^FS")
			MSCBWRITE("^FT302,3178^A0B,67,64^FH\^FD"+cLinha[1]+"^FS")
			MSCBWRITE("^FT386,3178^A0B,67,64^FH\^FD"+cLinha[2]+"^FS")
			MSCBWRITE("^FT469,3178^A0B,67,64^FH\^FD"+cLinha[3]+"^FS")
			MSCBWRITE("^FT553,3178^A0B,67,64^FH\^FD"+cLinha[4]+"^FS")
			MSCBWRITE("^FT637,3178^A0B,67,64^FH\^FD"+cLinha[5]+"^FS")
			MSCBWRITE("^FT721,3178^A0B,67,64^FH\^FD"+cLinha[6]+"^FS")
			MSCBWRITE("^FT1066,2202^A0B,67,67^FH\^FDFabricante: "+Etq->EMPRESA+"^FS")
			MSCBWRITE("^BY5,3,189^FT976,3173^BCB,,Y,N")
			if AllTrim(Etq->B1_CODBAR) == ""
				MSCBWRITE("^FD>:"+AllTrim(Etq->B1_COD)+"^FS")
			else
				MSCBWRITE("^FD>:"+AllTrim(Etq->B1_CODBAR)+"^FS")
			endIf

			MSCBWRITE("^FT817,2188^A0B,50,52^FH\^FD"+AllTrim(Etq->B1_XMODELO)+"^FS")
			MSCBWRITE("^FT1091,3176^A0B,50,52^FH\^FD"+AllTrim(Etq->B1_COD)+"^FS")
			MSCBWRITE("^FT1260,3171^A0B,58,62^FH\^FDMedidas:"+AllTrim(Etq->B1_XACL)+"^FS")
			If(AllTrim(Etq->B1_X_DTOP))== ""
				MSCBWRITE("^FT1345,3169^A0B,67,62^FH\^FDData de Fabrica\87\C6o: "+DtoC(StoD(Etq->C2_EMISSAO))+"^FS")
			else
				MSCBWRITE("^FT1345,3169^A0B,67,62^FH\^FDData de Fabrica\87\C6o: "+DtoC(StoD(Etq->B1_X_DTOP))+"^FS")
			endif
			MSCBWRITE("^FT1066,1541^A0B,50,50^FH\^FDFEITO NO BRASIL^FS")
			MSCBWRITE("^FT1182,3172^A0B,67,64^FH\^FDOP:"+AllTrim(cCodBarProd)+"^FS")
			MSCBWRITE("^FT1099,1546^BQN,2,10")			
			IF AllTrim(Etq->B1_XURL) == ""
				MSCBWRITE("^FH\^FDLA,WWW.PELMEX.COM.BR^FS")
			ELSE
				MSCBWRITE("^FH\^FDLA,"+AllTrim(Etq->B1_XURL)+"^FS")
			ENDIF
			MSCBWRITE("^FT107,3651^A0N,267,259^FH\^FD"+Etq->EMPRESA+"^FS")
			MSCBWRITE("^PQ1,0,1,Y^XZ")
			MsCbEnd()
			MsCbClosePrinter()
			
			
			GravaSZ4(cCodBarProd)
		
		Next nX
		Etq->(dbSkip())
	Enddo
	Etq->(dbCloseArea())

Return .T.


Static Function GravaSZ4(cProds)
	Local _Area := GetArea()

	SZ4->(DbSetorder(1))
    IF SZ4->( dbSeek(xFilial("SZ4")+cProds))
		
		RecLock("SZ4",.F.)
		SZ4->Z4_NUMERO  := SZ4->Z4_NUMERO+1
		SZ4->(dbcommit())
		SZ4->(MsUnLock())
		SZ4->(DBSKIP())
    	
ENDIF

	RestArea(_Area)

Return .T.

/*_______________________________________________________________________________
¦ Função    ¦ ValidPerg  ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 23/11/2006 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Criação das Perguntas SX1                                         ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidPerg(cPerg)
	u_InPutSX1(cPerg,"01","OP De?		 ","", "", "mv_ch1","C",17,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02","OP Ate?		 ","", "", "mv_ch2","C",17,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03","Escuridão?	 ","", "", "mv_ch3","C",2,0,0,"G","","","","","mv_par03")
Return Nil
