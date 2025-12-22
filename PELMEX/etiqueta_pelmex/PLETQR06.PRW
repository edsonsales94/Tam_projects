#Include "rwmake.ch"
#include "fileio.ch"

/*___________________________________________________________________________________
¦ Função    ¦ PLETQR01   ¦ Autor ¦ Stan Lee Lopes           ¦ Data ¦ 22/01/2019     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Impressão da Etiqueta produto no armazem Pelmex (producao)            ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLETQR06(cNumOP,cSeq)
	Local oDlg
	Local cPerg := "PLETQR06"

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
	RptStatus({|| EtqPel01c(cSeq)}, "Aguarde...", "Imprimindo Etiquetas....")
	
Return Nil

/*________________________________________________________________________________
¦ Função    ¦ EtqPel01b  ¦ Autor   | Stan Lee Lopes          ¦ Data ¦ 22/01/2019 ¦
+-----------+------------+---------+-------------------------+------+------------+
¦ Descriçäo ¦ Montagem da query para leitura das OP's abertas                    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function EtqPel01b()
	Local cQry
	
	cQry := " SELECT SB1.*,CONVERT(VARCHAR,GETDATE(),103) DATAPROD "
	cQry += " FROM " + RetSQLName("SB1") + " SB1 "
	cQry += " WHERE B1_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQry += " AND D_E_L_E_T_ = ''"
	cQry += " ORDER BY B1_COD"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,ChangeQuery(cQry)), "ETQ", .T., .T.)

Return Nil

/*________________________________________________________________________________
¦ Função    ¦ EtqPel01c  ¦ Revisão | Stan Lee Lopes          ¦ Data ¦ 22/01/2019 ¦
+-----------+------------+---------+-------------------------+------+------------+
¦ Descriçäo ¦ Impressão das Etiquetas.                                           ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function EtqPel01c(cSeq)
	// Local cCodBarProd
	// Local cCodBarExp
	// Local  cSeqB1
	Local nX
	Local cMaxCOD,_cCodBar,cOPE
	Local nAtual := 0
    Local nTotal := 0
	// Local cLinha   := Array(16)
	// Local cLinhaAviso   := Array(6)
	Local _cAux    := ""
	Local _cAviso  := ""
	// Local _cModelo := ""
	// Local nHandle  := "" 
	// Local cPorta   := "\\PCP3\ZM600"
	// Local XEMP 	   := ""
	// Local cPath    := GetSrvProfString("Startpath","")  //GetTempPath() //
	// Local cEOL     := chr(13)+chr(10)
	Local cCodEmp  := FWCodEmp()			
	Local nP       := 0
	// Local nP1      := 0
	// Local FimRegistro :=0
	//	Local cPorta   := "LPT1"
	Local lOk      := .T.
	Local cLogo    := "~DG001.GRF,09216,048,,:::::::::::::::J080H080H080H080H080H080H080H080H080H080H080H080H080H080H080,"+;
	"H080H080H080H080H080H080H080H080,,M03FjGF,L037FjGF80,L07FjHFA8,L0jKF8,K02FjJFC,L0jKFC,K03FjJFE,K07FjKF,"+;
	"::K0jMF80,K07FjKF80,K0jMF,K0jMF80,J08FjLFC0,K0jMFC0,::::::::::::::J08FjLFC0,K0jMFC0,:::K0gHFBFRF87FKFEC0M03FQFEFMFCB7FMFC0,"+;
	"K0SF80020H020FFE0H020H023FE23FL"+;
	"F80020H0200FE0H020H021FFBFMF9FNFC0,K0SF80M01FC0N07C01FLFP07E0N07A03FKFE05FMFC0,"+;
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
	"L0jKF8,M06,M0C8jH80,,::::::::::~DG002.GRF,02944,092,nYF8,:::::::,:::::::::::::::::::::::";

	Etq->(dbGotop())
	/*
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

While !Etq->(Eof()) .And. lOk

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

	nTotal := mv_par03
	SetRegua(nTotal)

	//For nX:=1 To mv_par02
	For nX := 1 To nTotal
		//Incrementa a mensagem na régua
		nAtual++
		IncRegua()

		cPesq    := ";"
		nP       := 1
		_cAux    := AllTrim(Etq->B1_DESC)
		_cAviso  := AllTrim(Etq->B1_DESC)

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
		_DESC := _cAux

		DbSelectArea('SB1')
		dbSetOrder(1)
		SB1->(DBSEEK(XFILIAL('SB1')+Etq->B1_COD))

		if nX > 1
			cMaxCOD := Soma1(cMaxCOD)
		endif

	    //GRAVA NA CB0
		fGravaCB0(cMaxCOD,Etq->B1_COD,_DESC,mv_par04,cOPE)
		//_cAux    := "Espuma convencional 100% Poliuretano Flexível Classificação: Simples;Uso: Geral;"
		//"Espuma convencional D-20Kg/m³ 9cm;"+
		//"Revestimento; Tecido plano jacquard78% Poliéster e 22% Polipropileno 115g/m²com tratamento Ultra Fresh em matelassê;"+
		//"Espuma convencional D-18Kg/m³;"+
		//"TNT (Tecido nao tecido);"+
		//"Garantia da Espuma: 1 ano;"+
		//"Garantia de outros materiais: 6 meses;"

			/*For I := 1 To 16 Step 1
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

		MsCbPrinter("ZM400C","LPT1",,,.F.,,,,)
		MsCbChkStatus(.F.)
		MsCbBegin( 1, 6)

		if cCodEmp = '10'

			MSCBWRITE("CT~~CD,~CC^~CT~")
			MSCBWRITE("^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2~SD15^JUS^LRN^CI0^XZ")
			MSCBWRITE("^XA")
			MSCBWRITE("^MMT")
			MSCBWRITE("^PW2362")
			MSCBWRITE("^LL1890")
			MSCBWRITE("^LS0")
			MSCBWRITE("^FO160,32^GFA,38272,38272,00092,:Z64:")
			MSCBWRITE("eJzsXU1r40gaLqVtPBiG7cAan8I0fRp83uuwCiT0cRKI1pc1Ou51D93k0l5p+9TktD/B9Mn4V3hgf4AbYqYXUmgOA3vNwUZ9sKJ93/qWrJIUxXFm2FQSu1QqqR8/fvTorVclNSGPV4L00crXwezRy")
			MSCBWRITE("nScPFp5VNy/V75H9NHKl8fE/Xvl+1nf++X7Wd/75ftZ3/vl+1nf++X7Wd/75ftZ3/vl+1nf++X7Wd/75ftZ3/vl+1nf++X7Wd/75ftZ3/vl+/9K3/HT891Q39HvUd81t3nWdwHuJnzXZLwZ7g/TOp")
			MSCBWRITE("s107dH62zWSN9TQmrhbsL3W/e8zmaN+K6LW+qbbv3oQsWfLKszZ0yNtZYtm+Ku1a0J3+vAq9OtGe7Bp1rdSoR63ototDz0l1Ef/DqCxcijdDmK6GGP0rXneT9HWGuib8ZqiJLozlgN/mazCQAKDxj")
			MSCBWRITE("psIQ1K24r30FwgawuvSBOh9jgwSL8roI08YZpgLjjwBs24nvCVEzIwWxyIBfhdzLg1VcEPtekTOkl/n1LyNEoIeQwuXVAxdewmJJxMj+iC+IcJS7se7QgxL6DEtwhIV0ERjjuED8BoAwBPSHf4AvB")
			MSCBWRITE("FzvhJfoGYJ3076RF/FUHFs9gMSZBOu+nsMc2ria+2yL9JnxbcE8GHG0N3FZ9R6R35kSkfUF6f38By7g4In4071+Tngtrep5HHX/RbqJvchAiuinpMtyki4uAvzuBKkIOP8zEuvvyvXLTzXHgAsHD1")
			MSCBWRITE("Zs0gMU7N0C+h7cvAr4mTo+DzWkDvj8BRjJAYRwgNrU4GcDilFWhZTYtwW3175WTbJwx+SENe4sXSXJNkhvHJ2M67y2c8Veg/oeEUmd8027g3wiWfE+wglW2yD7GIOyKKr6V4bby/RZEfTwmQfxrB/")
			MSCBWRITE("WNf5zv/qIT/8O9dP8MnZzLpNOAbwT6IYs75Hwj7lDg7lpRl+l78SKiP/3ViaLr9sLBRUo/g77pvD//llLXJ9/hMdCP7JG4Xd8M6BRxkwxuznfYrYHbyvfiDYxqNq00fd9Grm8Zr+7JiTuc/5jGc9/")
			MSCBWRITE("1vGHgukPrDsr4RkiIe6pwz5iJSNzcVMrOO1b7XXwLot+0k+SmffsioQuoUXRA0psfJeDiUHMS8O9eA/8Os7jZYg43QXO07qCMbyA4XrXTeIN8xwvGN+6wP3+TpsA34I7hZGQnvDbuYr5LCS/RdyeK")
			MSCBWRITE("/BtQ9k0bpb7o4KCS4z6KormPfNMlnIEa6BvRfdrCDfruGvqGUMUeGlbwvTkBjbfBv5m+Y27ngm+2ZeI28W8mDqufCB/ssm/Ehtvq3yBoevyeQLQN+qYUNf7TGOOTHiifuty/PfD4hv7NcE9L/KQct")
			MSCBWRITE("5XvVSdOXdO/Y+nf15347iRA/x6343G7Id9F5x3g+0Cfd0pxW/V97dAbOCv2ICAB745gkYr4ZIFrwL/BuZ2IOk38m4izOT/PT9Rpv6vP89Ny3Ha+TyEKGbuXQDDj+zi94+FKH6S+caEKgfhpkDgN+A")
			MSCBWRITE("aUAJAcsLjq9esBvon4BCyFzOR5voa+t8p7iK6dhPTWBAISzxuT4QL4Bn33b50RDDAxHkxIAGHMQ+LvLntR8XdXhbDkqmn8DZF3J/4F4++3sIvv5rCYkiCY9+9Iq6Xib7dJfMJja4Q8YC8q/n6t4+9")
			MSCBWRITE("B0/gbRzUQdpNDHOqQIzg1fheREcSDbLxD5Xin30DfnO+pGI0x0rss/h7wNUR8Cd0mfK9PPJDwxamPQ0svwMUUfmF8uXbh/R1rvCgZ2ZeN5wkfVg4Y9QO2iPYy4Gs+4Sea1YpPTOdldbp+2YP3s8NR")
			MSCBWRITE("kpyfe6P1WW+UeuNkOaZLWJN45x40vjzccf6kZqmVP8E+1pS3PRf+VPnvyHjVSxGrZdfdW98Px13N93aPQL/GJanZp8l/K6kCc0ZTEql8IfuNrPb95PqOBbtBrqmqPI2+IyHjKFoqQUdS3lSKvEzhT")
			MSCBWRITE("359JzYYzgi6fOO96JtmpImaprqdCmemSSYzLntIrfPab8e/Na+a9ZzC41j0iVXfvenbrtWKq5WW1U+q76DWF6K+CrP3E/i3qXZKC9tpqqqprhutu9J3qHZjxIcG3xnFBpeixEGcXvqSxyC+jOWKte")
			MSCBWRITE("xymQYQH4oeJ/6u+TZw6x0a+o6u1c1fbUpV3fEXpC09W98fhlG46kExWch6LMm3hfqe6i15hocVHEx2t3scYBQuypXZo5DvdOXKzjCMdMWC6wQb8kb0SIjLfjD7ky5EjZDhBhb5jlbktJBvA9VgZtQ")
			MSCBWRITE("rcXenKgyfmLi1f9OV3nJk8D3+QtrSmw2+k4WufyEOd3waAt9F+n4Ibjk6Dm186y2Hqa4D3x3BZqJb+/FcVlt92DLgh8ecdKr47hbjNlrzuLtyFwZuw7+1vsmRwffoC+nILgZuavB9g1tEvMPRskLf")
			MSCBWRITE("Ftw2vlV6c0Ls+hY/rg/6FvV2sHENfUuBD0Hf+I5L/j9cOATQ6Ve46W75NnHrHZr+vSLO+SGWM4LXLV+yH6eXfCVt2YU4h4d8TR/0zXsQGIEC98zn/0WMdEo17hp+wsb+Qt5GGiirb6HNDfFTovN+G")
			MSCBWRITE("6XZBFtdEqRoIHPiG5uSS3wnhrxzfB/ISndmANBuMeMYB6wpNKiVPGfSKVl99yJWvqC+nZQvRPSLznETJ4oAb3TD9O2LDilqHR08Atw6Wsnq24bb4NvE3dXbEqKuhVv4Fhfbv6K+dd7P9G/ge+4i36")
			MSCBWRITE("hvxXd858IxEKdvXTfQIUo9vhVAG99CIBmZ5PTd4977BfXtyHiEMn1zB8fWORmD5A9B0yPeg8J7CGso0k5t+m7OdyFuu75VgJfRd3w5z+sbh0C/Eie4jF3SMSLzXfE9UZMnjP1l9C1yfVzf2ocN/3Y")
			MSCBWRITE("o6HsETahvte2SgoP/AVpB5ToY35W+pyKZaDTl/PuN5ts9VryZ/i317UJ8ov3kMn2PDr4hrm/sb1d8z8TVNbMpp+/E0LeOM0z/ZvoGyfeFvtUaWHUDJ1ejaVf65kLJzv7J6Ts29G34Sca/C/Sdstkq")
			MSCBWRITE("EES2jd3tyr+FUCbmJ9nSt/BvP0Kn5u6c82+q9S39m7JsORwUiw41yq70zXGHWdwZvk89Vi5YfHLCymmw5d+C74XoccJcP3HdTroOzAFmnu8Blu/N8/zArm8VFPBV8KkHGdwZfatypCPWEfq3TBZqf")
			MSCBWRITE("R/q+JsfCSAUEcfXj0+6dr51fDLLe/c23y3Z+0cdfw+DrH8b+hYFnT4GgbfSGIqNbxtui75ViIVlsnXJpDr+/kNW39TQt+Ibh55M4NSu74fwPd26RJX1bxlzo39DqM3Kj1v+LfXNexARyWxkDF7F96")
			MSCBWRITE("AYdzHfRK7L4y7W90jr+1u7f0u+ma5TrKRGeFJjfFmX7xnJC7xY32DDasOh3b95aaHrx8Ed4Q+vWZ/KEKUa96CmvvlFNyiqc7G+MSOiqLf7t+y9Bn2D4xMHL9kvD6NifX8M2c8VovjIS4l/f4N9P4Z")
			MSCBWRITE("X6lNjv3Cqehf5N056dWW9xL91b6ZvPBaCePnWL+TbEOh94xNOP7x3D17L7YriE6nkbHyy7d8yGMHMOKMfnGX810OvLD6x4p7WwH11IPdSGH9jkfFJHKRW/xbbcnZdwgR+95d3f7OcL4tx14hPZuJg")
			MSCBWRITE("mA1eycnhhfG3dGoVf1v8W2zL9UxID8wniv6oAvfC+KQJ31NhPrMBUbgz/q34xtBOtW/cQj9ZENOtb13Xx0Hm3dvh+l58d83WYtwTNjsCQ5TXCndW39p+pb6pGF8W+ffIcOtbcB5m5X86X+5a3yGf7")
			MSCBWRITE("zGYdb8v5JsYfNeJv41tQd7tAAeZ8cXb/+5a3zxBBJ/wgzLwrL5V+BwxJYtrlVb/NralmDSH8eVRhHdD7FbfU4X740z1zujbuFlBzQvM+De24vjyPfNvuW2M3xXE7AGGKMsLf8f65kNiPkNI4Zb6pk")
			MSCBWRITE("LfOtIWZ5UR+rescj9BfeP1BtED/XrOhpYsfyLtu0zf4nx5xc6jvJo/X6pTqpgoG+L6K7W/Yn2jfwtQPvAt6j7qO9b6lrjhLPlvjGniBcTgqfrSTNyTLG4VfUx1tTiu6lrybFb/VtHH6Iusdorjbxx")
			MSCBWRITE("norwjjHCMXZToWwVWGrclHmTT3sS8XzOvmdG3wbeMxMkxjHd4XO4ej13hJ+/hUFgQHa2DvJHmAAeZaohZopP74P5UiNsSnxhXFsZfFfVjzALO2ZAzc30H6yO80rmw578rcJPvbbhDIZDQkv8OsvoW")
			MSCBWRITE("wXirBXyL0g7cdmzkv2Xpo3uLQ0Re6Lk33wPswXyk1vWGrL6jUn07I7ySOXdG9Ib0Is33d5ErLP6ayCuZ9fRtHpeYIPmIlHKOJW41tpzar6eZ/u2KDU+DjSuuVHZSTHlfnwZBAJWF7OH6Gy7vOE1Oj")
			MSCBWRITE("H1k+X5dgLurcWtIQhPyk2l5WK5fJslhX/v3oSjnfV0/4nNQRvAGMchn2cxSKaMl5sFB/EeF+m5c2KROWS3mu3FJiIpmVsb9aru5Pq9tJMO3GWM0LKh0dWQ4xfpuXCbEiGAM3Lvg2yUyVIlxBu1O+S")
			MSCBWRITE("aGi3zQzbu4f56is4u0YOrpO493gduQd7Z9B3yvUN6xJFyXXeCebGUGBe4d6JvNDC+YY7ULfYc23A/mO75Djy/azS74tsik3v3ziaUPa0vZPWrpmqr5g3LTHeCe2O4V2IG+r9lF+cfRNyHZRIrG/XB")
			MSCBWRITE("9E2IMNE2ZP1zfH623Zki+6z1BZqsEcXDtqvR4rjyc7624ReMeG+ptYN2M7qPilY+KO1D0NKE8jlekZbtD7cG4rUdlRt91HtmTK+DaISEdy9oH69tm3jOT78DCWkVxrfJ+MN8Tq5vk9H3fH9hmwWKT")
			MSCBWRITE("x7l/x65ug++4EeUxIcQm7wfzXYpb6Dta9proG+n2bRsqfU9Kbtiyl7BEJppv15idVrvgxe0az+OY1HpkT76Q0vsBpb7njsWFSwvB2IRaVircJb5QCrvkST/qfBmS1pDdnBBY+TNKjHN88EtqOfb+J")
			MSCBWRITE("u57A5+U0q39G/bt9CKV864jbjZhvM7zfR4Dt6QL8yUnJQ/rKShr2OTUr3E/IMuGDOwginBVbKL1zRJSR8Y9OaU/0C19SXhW0Ba5Z3Hfj/Gqr0jx/StPB/K0U3WJ4/SCGOPKUr4nMpV2L9ilz99S/i")
			MSCBWRITE("2yfSVyzZZldIa4k5LDQccnMm1WF/akUlg6PjnjOe5aTwJD03kLvU+Csk7G+VJm+0qxZGGXfzs6PsEHPWHB+4krC02W7NspjdoN3PcjfFoDt2QMdHrB9932axC+bvHIpOxYyF7fqU/4pxoHQ2Z8+Zn")
			MSCBWRITE("vW/p4TrnGLcX8Rh7HLz8EMvG3BN6thD2t0y8znuc3OLhuxsYLJbzBflURTTYeVJnuQTGSe8HO3X8pLyH0xom4qVL5uVYyvC+JUndxXJ7XdwZ4KaZJvQMhlz9ZnQiN58+c5i2vKZ/QZH/wSSHfXLY7")
			MSCBWRITE("wz3KSDJayp23R1vOzG8pjig3HmdEK0p+fKmvndmR1/WdrXxVciFETk6Hhfpe8os9x35l5Lg93gkV8mI0k7qw8/nvlCZnctdinpQ2aF4T34gzSihNSkvBOE0DL+C83gEg+m6RFqvpeC18FEdG4cC2P")
			MSCBWRITE("AD86jCmcHxJjFLIdc3nmZoqjXIaRyv32AzviPu5p9pHUXWkXpw/MShnJQxzLTVQF/INf6BxJmKU8smJmPVwceIScXPaaVAo/Tp8G7yy8uo1lFdmSx26i/PfSbJ+SUoKv4uhLK9i0zf7J8t2XTf0su")
			MSCBWRITE("a/L7iQW9s7bp1W8FzO9zblZqkbo1vz3+d2tntBvSFo+fN9CktN1KXXGzx1f6W8K5Mtn17WY7sqX9VYIhz3OCksTKTLs61dM1Ov8O0KfYt/uAB39x64bXxzd157Jy0l8laLTz2umyivyg++yir7dXn")
			MSCBWRITE("vHG6bvkU4Aqa99PisB8+j98qv1Ml/T6XQ74OZbWjXtyzv5LS12sKuyfdDivX6pRl5Z4VP8bJORV68Wt8PxV3Nd+PytM+vqi6V+e/HwL0Lvi372OfzTyqsmZpduMqxNPDvh+K+H985S4mDsgeG7VXf")
			MSCBWRITE("Vf4cGbUo4g7/W9D31kySsi8E1z3R8/Dy/p1kfFj/iRaapIl2afXyG/DvuCL80KuD7ab98Z3Td2Spa0n/rBZGKqNST99TYk6kw5cwNBoOZlfqv5zAO9euYP3E9tHzfK89nQCPE1iZeMaMwHfepfdOs")
			MSCBWRITE("gvtax/e3m19ZRa+pwfGf/XCqh+MJ8FD9cMnYy1CLsGd8++kvxgxiS7h7z+40rno44xYOkrG9KZP//mTCFCSxSj55Yck+Xw7TsamrK3+Pf0fAAAA///tXc9r40YU9gpCwkDpSeTSEJOT0V+xgQod24")
			MSCBWRITE("CHuexUPbT3Ldjry06luIca33LoXfgk9FesD2avHrBIF6pqA+3dBQdT8HT6nhTbiqXU8XbJbmkmPxjPvMOnT5/evBnPPBk9chv3+nxfjjtY8U224d4gS+3rm81SqHM8LjwS+3k+tnnWe7kS9uxTjds")
			MSCBWRITE("05ewuJ17GHW1MH7vFBmN96iKC66njdQ3uxL2h7wQY5fmSSZrnGzzn+0mc5ANjupegqONM1r/sJU/5ZSon7h1evKRvo5BDayvuLAfHne8QKvF9qMedthdD0N1mtE1dTwqmmWqzGC1t7cWx58YeY1o5")
			MSCBWRITE("6ql3zeSs7XoUG7b6EwNvvjUYDAI8DN+wbnBb+StgatiVnZIH/EaImgE7KxpEJ+VZfsl/m0pyymMaU8EAPU8uhJlQBU0gcv0k5XEsoM5hnvkk+VLEXE4o1zSB2dA2/w18Bw1C/LofEKPXOMBt9SRoN")
			MSCBWRITE("Ixc5gAS/MsBGPSjsAu4+13ogGeZVKxOVOh7JpgzoXaTObIFE8ph071u8X08yKP15/POcOhxymw2Vz+I3zrO63jGHPXCtcu7fqr4bljwrPkRGYQNkukEoQU57pNoEFp1y0Dn6J8EYAT6hk/diplnWd")
			MSCBWRITE("/puOlKyYeTI/vNZ8dJcsH3ZPPYlPwIeseUD6XbpOYINH5BX7nmEPTtyNS076XvoNHPcQcZbj+s+T2y5DuIAsBNEHfo1wG3jzcGcFcsBpX4Zvp5S8u2N/rL/Va8dD099OwR89gfAlObTNv6atFutTs")
			MSCBWRITE("jMJ123sINAX/i2Pp1xSarKr7r8Fvkuw4gkdoV38GJ1c0+YGMwsE78glsv4N7032Yyfp7I74Rc8NGfz46UuhBXUmlTCqirn830amFORTICGU/ptMmVnAnnVJ072+Nv9Cf1qMh3NwoAN8n5hn/QCk8u")
			MSCBWRITE("8h0QxA3+BPnuVuAu63v8zZJv9RI0PfSugNxDKY7x/QKm/n1hzrz5yJurGXv7wtVxxveP9+MbRpbb+kbcBko5wkT8A7gg9DJRGOa4d9B3cj7J9P2ra795doz++1S66SHoG932UTpM9iY8HoG/nhy9+")
			MSCBWRITE("uqTBPU9TH9y7hOfhCQkPcAdEr+X6duqBQc9w2+Q7JQ5ME1Co+9nA2lgwe0JSK0XkXvo+3pv5ijXnnp2y7XHLXDKp217RkHGgtmeVq4+1V8sGLMhMBHu155Nz8Aw/t61y0Fh1XgZkn7Gdz1/Li0jsO")
			MSCBWRITE("Avxw0xCeIe4AuyQOgZbgv9YBXuDf8dUyoEOmtKOZWUqgTPV1IBdXYGZiI5U1xDt1BnHA0ZGqLB9vg7BO6iruWjnmsZ3zXw4TXwKQ0jDwx9GHJ8HCl7VoTv/PDrcEEHUcVq1ibf82Vgsoo41gaX2Uc")
			MSCBWRITE("vD1vWKWPnuC25KkDZJf6uePT+sZTXT7Ivbi6LqZCXiZDjZR1q6Sr2xp/qL+p3mV/2d8Vd4mmui1R3vDXlrEh/Bb//hu9dS2n9JM//ivF1kq7nj0huYcGwEGtnVTwxvzkQPPj6SaZXlPA8l/q6ec30")
			MSCBWRITE("/Lb9B+B7Q9/pUuLL7SfrZPaFvpvE4Fi7LG9UeRd974z7Hjp91/IB8iO/l/IRrQ9+PHyX/Pf7K4/6rsD9qO+H5ftR3w/L939V33du1/gfl78B/96HAg==:A6BD")

			MSCBWRITE("^BY11,3,224^FT158,800^BCN,,Y,N")
			MSCBWRITE("^FD>:"+AllTrim(cMaxCOD)+"^FS")
			// MSCBWRITE("^BY11,3,224^FT158,871^BCN,,Y,N")
			// MSCBWRITE("^FD>:"+AllTrim(Etq->B1_COD)+"^FS")
			// MSCBWRITE("^FT160,973^A0N,142,163^FH\^FDCod.Produto Interno:^FS")
			MSCBWRITE("^FT173,1130^A0N,125,141^FH\^FD"+AllTrim(Etq->B1_COD)+"^FS")
			MSCBWRITE("^FT171,1287^A0N,108,112^FH\^FD"+AllTrim(Etq->B1_DESC)+"^FS")
			MSCBWRITE("^FT176,1483^A0N,125,141^FH\^FDQUANTIDADE: "+cValToChar(mv_par04)+"^FS")
			MSCBWRITE("^FT1096,1840^A0N,108,112^FH\^FDDATA IMPRES.: "+AllTrim(Etq->DATAPROD)+"^FS")
			// MSCBWRITE("^FT173,1130^A0N,125,141^FH\^FDDESCRI\80\C7O:^FS")
			// MSCBWRITE("^FT160,596^A0N,142,163^FH\^FDCod.Produto Interno:^FS")
			MSCBWRITE("^PQ1,0,1,Y^XZ")

				/*
				MSCBWRITE("CT~~CD,~CC^~CT~")
				MSCBWRITE("^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2~SD23^JUS^LRN^CI0^XZ")
				MSCBWRITE("^XA")
				MSCBWRITE("^MMT")
				MSCBWRITE("^PW2362")
				MSCBWRITE("^LL1890")
				MSCBWRITE("^LS0")
				MSCBWRITE("^FO160,96^GFA,33792,33792,00088,:Z64:")
				MSCBWRITE("eJzsXc9v20iaLUkhoraAlgyYl82hB8nNWrSBPQ3sQSwD9p0GqL8mh3DbwLTgAPF9Djsc+6KhAMvIySAboueWxfwT7sxFowysYPYikAFrv6+KP4oii6IkJ54M/CmSi6wi9fT09PhVscgQ8hhfMpr0/uMG9qt07z86iNe9/zC+JN5vjN+Gc//xyK+A91G/j/oV8H5r/D7q91G/It5vj")
				MSCBWRITE("d9H/T7qV8T7rfH7qN9H/Yp4vzV+H/X7qF8R77fG76N+/7X060N8U/qdPiy/kX4diRaduTonXJxf/y+r3+Bh+V3af+2F8l1Nv8pBKbzL8hsMP34RfjVSKYd3SW/tV18sbLMKv6XxLsnv2Gx8GX5LtCnUL/PZ2GvjgkWHvrh8X/rVumopvBJ+p4E1ALFaw4BeUlagnsv+nQ5hybJcXL")
				MSCBWRITE("UKvx2o0fEFW+jQTufkEngeHh7yBgV4Y19NP2xCdp0+IfujqutAoUqvmm7/mWuSGtaRnTHUzW1TRr8aIeyNASpDUOlqSldTuwRLsJ2KdUvzG9D3UBWYxGgEBiyahLifmnS8ERgG2fFgu6FZJzsr8AvvieCIyvBiAfB2YAlLId6jArwy/ZJts+YZ20b1kviOTXaNxqeG32/YxDIbdtW")
				MSCBWRITE("yHKNtyrYt4pdsEkUnFVJBvDpRGV5tUyNbRNFIi3QBccFnlfpDb6P/fdDb7m3c9YDf+mWvOQN+Gx6WvA3Qb284lm1bwK+OQtDxq2d4UQ2MX3ypaGhpTCAFePMtdET27eo1SLXqVakLBbN21XT6jasqHdfsmutQw71uLO+/gFAnAEhneJFahem3o3a1EK9ajDefon9UgsCY1eAF9")
				MSCBWRITE("Tt7Op08Rf02bpt3sxOvBi0M1ztbgV+A9ETEq3N+AS98DsRb4IQF+p3VHP/8U82xDZs4zqeabzWuUL+3z3yv6tXAfY221IIL+GWQkEDQKy8wV9jkeKHULbJCOb+zGuS5oNipMTICypQ6q/d6jfc/0GAD9TvtExm9hfwquXjV8njz/RcU6zpXDdcxXoJ+zcbAda/w27jZd0ZV9DP")
				MSCBWRITE("05p3l/VdL41UzeFfzX1AseDAolgK/lN5+Dwe8TwzvyyAAvAYZeobUWwr4TePt5PCrF3q3TL/XNccZXMEL0y84rT341PTHjZs9x2b69R3vN7XV9HuU0gOzss3k9wZVskytgN/PYA2noN+gN+pNp1g4Y/578wOF3xukaNMhnckytQX6JYX+oHS1Qrz5FvpLDXQK/NpkBPq9AiN+C")
				MSCBWRITE("vnDuGE2XRv917VPPPxzP/7bSfwXDyHL8xt8rkzBf08i/21Sr/npjPnvdFabgf/e/XcAR5Ll+Q2Pb7rs+LYIr0S/HrHh+FZ14MuH/AHc+Kr2qeEA3prfB3593zYcewX9djFfgLShA/lDa3ML0wUwCcwfVMgfKsebuGIF/U6N/XHzzhj2N4KeZf1CXCPMH8io35yx/AHUsTy/+J4")
				MSCBWRITE("KpmUKZmRKmJ9pfAn9QekU+4Ms/zWwCtLIxiUmu/Dcx/y3McIllv9i3Wr5r8qSSj0EhybM8181wqsuzy8dE8OFF+IGBk/O0Y3H31OAOcLjxSWsknUwivgV8vUIb5ivk26EV7JpYf7rmZAfeOYL3zk/P3cmsGS3HXvPsUjb96znFq9bXr/MXVlnmGfolZBfEHBXj1atwG+i5OWri")
				MSCBWRITE("vhdJwr8102NkInyFIW6vP+uj1dGXoD8BclSEP0NQmKnwUPwK9Gvzx68FC3zf8KyLB6E3yzdSGki3AJdfw39pgWaHt2FZSce+XXE1sv779p45XwGjENhvDcIIqaDwmHgr6NfP5ZtWppZocqkG63/SvxKFJldnVoTZBt8Jf9NCdblVKXXCsYcVwOt6Y2/vn5LnKIo3OYr+a/rxzG")
				MSCBWRITE("xLduBh+041sDPqNa2rAHWDxxnMgjXedW4wX3wGw/yCNmw1B+md1EE9C7OwqZTXA+v9O4yrB7SyTDUr7ch45dEwd+RhZqM48TreI7JAnsbcXUabyRKZ2RErfcx8eWx45Jq6K638X73R1Gp6pu10I37VZl+4+2UBJtSjBeHTeKt1Xx+gxhvk8bYhtQIe2lBgnf0OS5CPsz5DUzIl")
				MSCBWRITE("xfwuxxeDlMnaX4T/dox3qoT8/vCgSUeCV5nlhRNsse3hrJEv3FjksJbWYCX70GbwyvyWyd1WFOvb0DHos4fTWpEuryth+ugzxGV6m6/zvYwndU3gkX8kiX47YSfp0Pmfm+x6hL9Vuf0yyNeR9xEv8B6zXGpC3+rdJF+l+FXilfk12IBir0lPR6JfmFdv2eSumEQF/TLq0+nII0")
				MSCBWRITE("A0rZAHE0rwW93kT+EOkiNpmFLUb81br438KsnzIyp64N+Q18Fpfr4vCWORxq8qYu6bTt4hoO8kuq3Er2daE4Cvypb30G8alQdAhXlO89vLxxPeF8F/UaeK+iXQIe5/hqeoN9os4C+rzcgLx6T75I8Yp7ffLwJvwJekczKnBwy+q0NmBPfoH79KO+N/dck+6DSPeDZGfHNmO9eo")
				MSCBWRITE("cBh5VNp/rsMv8lmnNnUjub1+90d/r27Qf0m/FYFfm/Ja6AS9Ms3g4QYBQwlkzSTNK0cv0+K8eqE9/DVZEfz+q3wAtOvH+UMgv/uwfMVPEGtjSip8K8JaHpikGeeLP9djd+u8KuT8RvSs5Hol87pl4B+SUq/0x4szOp1msS96JdJV08NnqT0C/lDOJ5rRPpl3TbgN/Lf/fAJ/iu")
				MSCBWRITE("cejPBga9JzZfmvyv5QyjgVJ6X4ZcfoUT90ox+qaBfFmNiwLbiWOW96FeCN99/QaOs6Mz5b6hf8F9ej1UeQdPYE9Lje+MXsk5hhez41gP/rfPD1xuZfsN6F7dDAacm9WSOb0csOsnxrSLTb3z4C48YqUlI8/qNs4I4V6i6Kf+FHHjPZf4bBsoYiK/6qR7cPL/5x+NcfqMjM1a05")
				MSCBWRITE("kdW5/mN8Sb5b0q/I6Zrpt8wmugQMwNqCvnNxZur3zCUkGA1g3dB/ivz34hftOAZOrDYv1uf3wivksE7n//ig+W/PKT6rWM2zG04qNebpfhVUniL9KuEG1ayeIv1SyX+G+kBK6hB0mfiZPwqqd/bQv2ycwT4RxXxivoNEWP/jRc3ZP4bxg5sBikGSyFofyTjVz+E0I/wHQ9ZHMn")
				MSCBWRITE("0+4TXd0M9IFRdETPllH65n1notbw0kPnvRtSSd92wE2dvX8j8d3OzBY9NfMdNHjJ+K9gOqwW8qog3J/+FRGucpAMpfmP9/iDIFXufZ5R67ycSfsUeTbI2l1812YyfLsLJaod5+sX8Nx7FNavxmC7rv2X895kwSoxih07cu9/bxfnDHN5Fx7duKPTjw5ZEv9/xFDagUf4QUJn/C")
				MSCBWRITE("oYQGGAswL1vXF/eJ796+Ms77mhxy7n8IS6byWCCJP9NsgXMH7AT93/nu8X5w5L8Yv6A+0njzcl/QcCl81+KfBPsxE29t39YSr+5/ivg7YS9ei2th5R+o6TXTAbDhPEH1G/ovz8kbtsHvDfgwO9+/wd6n/oNZ1SCPxzELXPzX8ZlXMz339AfsMNnGidoEfSze6/+wI7GemYkM53")
				MSCBWRITE("/Jvr1o1MZ4L+szEbKuIb3bPCH6ESHh4NsYMF73vN2Cf0yJ261kD7mya15/2VerYbpL+vEHQsKSfnvd3F5HKbCFuo3LAG/Uzb+APqNjhdDegddtyHrH9OI3kJ+4wNuXMo7Hofn8AvGHxwn8l/utdEB141K+5zf11C3l4yfsewXtu6LHbgiftfGm+MPNM5/jR1MDlg0Q/8NxPyBY")
				MSCBWRITE("NaB4zueQe7iAZ40v3oeXmURXp0jzYxHyfw3jKdOVGqYbGxnL5X/YipBcCIlJB/tReMP+XgVLQ8vzjVRujnjfSK/SR83zn+bFLNiVhoz/6V8/KweZsDYcsq3SLa+WRFvNzWeSsIt5OO/SRYb85vodw9n/U7gYGdXXfH8Bct9h+51nCcvq188AcSeKbxRrl40vp7VL56/CEvu7DQ")
				MSCBWRITE("IxvUgmBg00q9RheShBrqdQifOkI6v5+BNsviuEEn/Iu67FZy/OI9n9PofnofhOOdhiffQBtBu4NhR9c41fGLcygdJx+49x+8qocV9TSm/KwXOoOKlfjLb72Z9vEnXrZOv3/R8BnmkroXDaWrY/cBt5OffVggt2YEm84cVIpjFO5h6yWy09fkV8GK3T8C7xvXHkFaYOPQQ6jaW7")
				MSCBWRITE("z3ot5M7yW99fnskbw7l2vxK5lin/XeFeMe2j6/nvDf9arn0rs0vXkyUN1tibX47aVsW8a5z/bwP7rCXXI8cC3hdfvX5gSgB71r8wscNcib4rMuvRA5z+p2fAVz0iEYkIF27//lnOsmXw3r8TtmAcW7Vmvx2ZFuL+vWdpQOOxdFpuHSsya+M3hS/JS6Ln4ugV6+7X4LfYryieJe")
				MSCBWRITE("KW0IkF8Ctx68mcYc19YvqlUxgX4vfcBRVhjfS7/myCh4Tksw4k+tXOnleFh2pHER+A2MjnyspvaDeEtfH6tI3l4Re8N0I+rWN6jIOzGf7tJ2F839lhyppdAo2EPj9h0FO+ZzfhcTyRvBryzffDL9LAdaKpC/oF/phBDprdgnhMtHiJSNtWYs0v0sBnu+BZvCG/H7ukXp9UF69/")
				MSCBWRITE("TrZcEtcH8B7vKXNolPYWNQv22+7jO+iTj9gY1/WYp7f8ngL5ZDyBxP3a1jFE9N50yn1AFFN3kL0X7IM4AVqF/3X4zt+UXhhRShgzyxSb9p/Nb7fUhJmX4ZajDc+vnk9Nk622IanFMRb2C51fNPLA+4saCfmv4474Tte6MN8cC26GGNx/luaYW0BvXP5w8RgEj5dSPAYG7pl+U1")
				MSCBWRITE("GxUqwWyx0Ub+OE43qVoULh/K0bDEnKVK5MffGIcOF3PFGxV9Cml+UMJv/UB9S2aVXeGoZEgdSrPKbeaIihgvY6yz+RNnxh1DCZNsVB9RwnCy+EsMKNV4U8/x2k9FTGeJStjfHb8BsmKm4bmV7HOy6oT6rHhT3RzL8JgO7RwVQSuGdG39g1orxfMDPugky9v0Jr03O05XTr0hw7")
				MSCBWRITE("lde0kLm9cuiX2cEkzqbXCaG14+m9yyILL8xg3k+oXckFbl4Y/9llwxFCuVOsT1MRGmdR2uT9qX8NwuYVASSj/NWluKXXd4Gupz0kj33euw8Zr9nRGs2Ii0vya8gYh6Hh4cd4TOU6Ifk6JeHSaRRzWtfQr/zFGdiMVx5/7jfi66vICR8cmcuk18U9Y91GdpSCRzDm+ug1m8k+23")
				MSCBWRITE("TYust0C8PLXe3ahm4heMPPJuII5ybJr0lV0l+8zkum84j3vzxX/Rey5zf7/aC644X6jeX4/K9uyJ+Gcf9HpcwXlR0apXidjG/8wyXHwkS9Zv1UfxLbcvC85jbVrS6eFRisX6jCMFulgbblfMb0HyHLXtd5yJ+Vw25fteLMvyuinfR+OTy48IPev9fxyl7Y9WS/rs23hX4SyJf0")
				MSCBWRITE("Q+i39zL6Bff+/eh9btKfA39hh7qLHLYVHnx+O/9411OmnFMC5p8Rf36yZiDL7yGgo7l+zFcfmj9TpKbok699PKddTmxQjcOhtQb0mAwyXfnLL/6UbpjrB8m5cNuXKezf11F0ovO+u/oqclvVALKfAd/r7d/okzd1HV+evWu7/LpwaOGe7Xn0ItfUbajjAtn+dUVnHLKA2dL66o")
				MSCBWRITE("wi6irxTNQ2d2OuhXJrZaz/H5+23eZLO9oMAvodPzjT+HtSgJ6Q/85DngvL2jQ2UtKT36lft6AcQ6/ip4e8FE7At4YLuDF9UV40/q1T7wXeBbD9R0Pl6/bZjw95/bVu6joVZzbPd+5+HVO4nL9Kt1Umivi1bJ4j7u5keU3OKMnKb53xjF/s9cfmS+gZnt0vE/p4O+l/YFfybal6")
				MSCBWRITE("yhRLcTLVa2pR0coZ32LaYPxewg6PsqwnPXf0c/+yWhgW/AY4OUro51zxxpZA0x/r/Y+WpbtQK3rmvvmvj28+JPlTJzBoIT/At6OdvyktaVUOloL59jq6pZywLV8dNDZam21nqjdVrelHimVY01VDg4yHY88foO/jD3vtG9Zg9uxRT9vvwlGl6dWH/n9n7vxeGT37f+8pFevr19")
				MSCBWRITE("+HF7cTty3fx1nTivl6Rfw6qoCODoa/KSAX62rKBrD+6Sr6XpH34JNtC1NV47gI22pWlbEWf16J85fzr1n7evdF+efrvd8u23a2+2TD94rEO3GoH9tj63ttuO8273a3b64MO3dvQ/9Mv4LeA843oMQb0tVlGOGd0s91rc6LcTb2mzplUrlQI43o9//fXP3djhzh5PZbDQF/V5Pp")
				MSCBWRITE("mcT9OLgrTv7bI8nwQ6lo/+YvdweDv7u/W5/Ni7lD92Diq4IeA9bR13lWI/4VTtH6CA68gv6hc+gZX90Of77s3tyYZ/t2Ps751f2vjva+eW/9tyzcyiCATuzUdt0Rm1ot3G1u+Ne/Mn+7f7Vn8vkvwCi0hX51Vvdrsr4BVM47m522K00tyoM7/GxHO+8fn8+D/6I/H74NBuhP9j")
				MSCBWRITE("79O0HL3ApvaAz+mY8goNbMHo7e3lGL2693/3xQ9YkcvlVDlL6RbxcD+AcoGWOF1owfsvq165Z7Vt7tz0D/d7+tu3PnpujDQv0uwuivXD6/mC2jffxaw/M3fPB+a23PfibWcJ/9Yqmhr83gng1pbOlInYULcOrKVDEFluVLvzeVPWglH7fWMOxN2qOL3es8XhIZz/2R6eXoN+XI")
				MSCBWRITE("NoBHdOz8eWoCfnDcPzj6eB07P149tdy+mUpwdEhYOwgv7Dc0ZUOuxYPivA80I+Q4sPuoUoOoP6ok4835b+2Zfngv+C9aL8DF28Mz6x4tOO6Q8dyh7jo2FAzsC7xghF4rJX/qiXbSfjlqUL2nltTzNOm7L5yYQ4RJsABu4ZoEb/S0JeAm99/E/5/C8+Ju3HhxAjfSZ3Q4OUy+cO")
				MSCBWRITE("9RE7/IsC7RDFCOa0R13zxLn27ufCGfg91/7NYyCGbbtxli2IIC368yOml2UGIr8jvNAiEeyDSiM9AXBWTy9d9gfm/BXj/3cbPVokHHD9bKR75TfD+u+n3/wEAAP//G2zhO5p+R9MvsntHAW0BAPsTH3k=:D151")
				MSCBWRITE("^BY11,3,224^FT187,1010^BCN,,Y,N")
				MSCBWRITE("^FD>:"+AllTrim(Etq->B1_COD)+"^FS")
				MSCBWRITE("^FT193,1493^A0N,108,112^FH\^FD"+AllTrim(Etq->B1_DESC)+"^FS")
				MSCBWRITE("^FT195,1277^A0N,125,141^FH\^FDDESCRI\80\C7O:^FS")
				MSCBWRITE("^FT195,1683^A0N,125,141^FH\^FDQUANTIDADE: "+cValToChar(mv_par04)+" ^FS")
				MSCBWRITE("^FT186,728^A0N,142,163^FH\^FDCod.Produto Interno:^FS")
				MSCBWRITE("^PQ1,0,1,Y^XZ")*/
			else

				MSCBWRITE("CT~~CD,~CC^~CT~")
				MSCBWRITE("^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2~SD15^JUS^LRN^CI0^XZ")
				MSCBWRITE("^XA")
				MSCBWRITE("^MMT")
				MSCBWRITE("^PW2362")
				MSCBWRITE("^LL1890")
				MSCBWRITE("^LS0")
				MSCBWRITE("^FO160,32^GFA,56576,56576,00104,:Z64:")
				MSCBWRITE("eJzs3EGOgjAYhmGIybDTI3CUXmlugEfrUXoEliyMnUhpoYAFcUAs77ewpqF9In/SElCThBBCdp8fnEXJZGROhYOzoaNxcHBwcHBwcHBwhhE4ODg4ODg4OH5SjYOD84ajcHBwcHBwcHBwcHBwPulccJY")
				MSCBWRITE("6WzA4ODg4ODg4ODg4h3AKHByc3Tqna9+xPThBp+w7+Xc7d9Nod99F48xxtPSdDGeW09an6cHBWdEZrKM4R3TyO86S6NZRfg9O0DH7aetkOK847jmg+HanwsH5mJNqnBkRI06zQuDg4OBs56zwz0I4OD")
				MSCBWRITE("g4OG87euBInKlkHce2ONMRdtoUZ6mjInGSvrPm+hars/a+EIfzmNU5rgdnliO7zsXJOAdz7DucZY7ye3BwcHbkyK6zwXqNs28nwcFZ17l0nKrtwcHBwdnaUTg4qzlV1xE4B3QKbZez1DU4odR1aGKAq")
				MSCBWRITE("nXq/M/XByNyCt3LuKPfLVU0TlEP688UdnTpfmN3SCe3w7IXnbsbej2gcxrO7tLdf4ZOm9uOnDwwfrifPsmMExePE6qMiTRO3Zgrk1CeVSk2Z3Lgi86znSIyZ7o89vnCXGe8QFE5g2NUch6vonOacebi")
				MSCBWRITE("7bd+zcuiP0/5Ccc7BfbTnr0mla4RMn8c9+gQuln0rFM3fgWU5/wBAAD//+2dTXLsJhCAUWnBztpmMRWu4R1XyRHeAVKS5gQ5gq+ina9B1buAvNOCEuk/GDQ/nkmcOBNEV401Fqg/LBpoIWgXxdnc1TH")
				MSCBWRITE("CpyucbkEOKlqpfA6uRUV9ztmOLdlalcI4J5cib1nDlOPiAa56xS8UPWBAHRYvGqh0WYAUswPOsK0YllYyCC4eUkycOUVewAsHqhmz7WXaM8Mui2PlPip1lkk420PMhipFLR6G9Qon9jPrd3LE2M5y")
				MSCBWRITE("wDUfIQMItV2t3AU0LTEvvH0DdXfnnDTeFMu5HMrNbJkTcs4cOWhkIeP8sVzltKmplsZhu77khJFV9oQzHwvDtXC8fCgLcI7hKof7gCI5+jrHK1bZ08EcmTNqzokHHS+Cvq9XWKpbnKlYzkV/0HrW0")
				MSCBWRITE("3KNBOaAJQvHKSkHcwYqwCXHnPrr7+LIUL5sM7SO7QnGMzKthtJ9bJz2goMJFxyb/w2lcdLvY5bDOFbJHO0bbIdUB8xRGacjDkC2gfTay/KXxlEXzRU5hjlwAJVRM9UBUyOH68esm/oZ4kBaOAcFq0")
				MSCBWRITE("kujgaJnBmpVtLJSsnK8/4N/fhhSpw7e1xK4yhQIhaecRClThx6YPyEgxWz3ok1VBqHBG/uO/WhK3NWFZgTRKs8ReZ+yIiVBhwdHpuO/0YOinaiAG9FrxbmkAkhg5/ucn8UOeGKf7AzDvuioA77uOH")
				MSCBWRITE("d0RmdOJtpFnpuRKS9fIraHUeJSuTgtBRy7EQnlxSCktXS/AFy9O45jSzhXYSjyNKZA2NCG+dBJyVhYrnCKmeJB+REr4MrrVlTyEYsQEMjsMzzPSunE05gDo1qTm5mNk/eJN+JOe3uOZOoVId4Cjji")
				MSCBWRITE("KWniUBXpIA+5t17i7IxTpUqVKlX+Z7L9XwH6Ri775QjVRXBeM0y2gnLIp58OWf4umHWTkCfug0MOyIljkwssv13j4NNQlzw3dPj2yTlppm8n7bc4oLk5cean4izpYU7J4hPt7nB+xR994qz/Fufw5")
				MSCBWRITE("JwucbrHOcmRP8BF++O8gK6X1P3zxfc4PhWJEqAx7JCj8Q3wlzj5w+ZuOD1o/fEXOe6Mo90zcXw7fvG+qR1yfqgDcKLmx/o3fyoSJ/g9cszbicPjaUq8waG3532WYO6/0CqP08aFO+rv+W+Y8PseOW")
				MSCBWRITE("7bAzzox49PycGJ7t8yjtpsLr3BwRfI69WE3XAu5aF34vqhXLviVKlSpUqVKlWqVKlSpUqVKlWqVKki0vLqmzTn1H2yE4nDVNDM+GniNL6TieswXIzFMBbNMbys/aG5OlYZPuVoJ1OppXOOX+REiZw")
				MSCBWRITE("bmr6NM9LOEN+NWiK2qCZ4DrAQfBMCBwkIYbF+CG1YdBhtWLuAOTt8uTDxTrjFjN1kZhveVgtpvpWt86VyZmV/hgk5DlNDcN1iKFCAXsJRNt9q4kDCx6rwJHAop3AwaiBxfG89sCDNm+PiS+bA7Ya8")
				MSCBWRITE("yGlXZd6wqqbW4ZtKS4EChgn3zwEcPpMZ9eSbpV1xm6H2L2Tsvplx3wFxoH8zo20hTYIMlMpRw0cQzs+ZzBzMNzjcW2hD+FhUz/tPmwWLYwJW5aR6VAslmomDtcmcALUMHEwzx1A0pwFdUj8Zh0JV3")
				MSCBWRITE("eU06xnHrCfOuO1SC+Mcmlns2sb6odUENr533nJGpTIOjkjMEbvGQCCJo/4LDoyn0I0Th9bvQAsDde1sYzsljsZ2Shwb2ynG/OgjBy6CE8PkmCPttGgOduqrogEhjgsh0HgKnX3i4LgAKlvMCoMsct")
				MSCBWRITE("K4ABwcT+HEFNjeeFwIPq2HKo+D6y7ADwEH5J3W9lID9eyqGQdeWa9+wa/zq0U/HpIxxswLJMBX7N+ayeHCn/lVDUeMGeAOlHZAP6Qpl7MRe/30Py6lcbQrjPM9mOI4VapUqVKlSpXnlT8BMlZJaw=")
				MSCBWRITE("=:E3C6")

				MSCBWRITE("^BY11,3,224^FT171,1058^BCN,,Y,N")
				MSCBWRITE("^FD>:"+AllTrim(Etq->B1_COD)+"^FS")
				MSCBWRITE("^FT1093,1841^A0N,108,112^FH\^FDDATA IMPRES.: "+AllTrim(Etq->DATAPROD)+"^FS")
				MSCBWRITE("^FT176,1628^A0N,108,112^FH\^FDQUANTIDADE: "+cValToChar(mv_par04)+" ^FS")
				MSCBWRITE("^FT181,1473^A0N,108,112^FH\^FD"+AllTrim(Etq->B1_DESC)+"^FS")
				MSCBWRITE("^FT172,1317^A0N,125,141^FH\^FDDESCRI\80\C7O:^FS")
				MSCBWRITE("^FT156,786^A0N,142,163^FH\^FDCod.Produto Interno:^FS")
				MSCBWRITE("^PQ1,0,1,Y^XZ")

				/*
				MSCBWRITE("CT~~CD,~CC^~CT~")
				MSCBWRITE("^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2~SD23^JUS^LRN^CI0^XZ")
				MSCBWRITE("^XA")
				MSCBWRITE("^MMT")
				MSCBWRITE("^PW2362")
				MSCBWRITE("^LL1890")
				MSCBWRITE("^LS0")
				MSCBWRITE("^FO160,0^GFA,62208,62208,00108,:Z64:")
				MSCBWRITE("eJzs2bFxgzAYgFHnKCgzAqN4pUwQezRGYYSUFDkrl5gAQSksjAko76voXoHuR0KHgyRJWr4X1t29su7uVLNYG7BaFovFYrFYLBaLtWBFYLFYLBaLxcrHqlgsFivZCiwWi8VisVgsFovFyswKrAWs9c7mLBaLxWKxWCwWi3VDJYvF2rfVRFbJSuwSWUdWYqG+Av1/tuJx/9uytdqJV")
				MSCBWRITE("bGSrfrb6tb8KmuDxfpZNHtZrPWtslvzrPkdB6vfA7yzEq12YlWsmdZwlx1YyVZPsFjbsUpWYs/hFyucWSwWi/VlvbFYLBaLtXmriawzK6GnkTVcurFS+nxf1yNrxVrACqzZVhNZj569uVtrfL/ysk4ja7jsYKVa8ey9sFirWw1rMWuYvSwWa49WvJ9nsf7Oym2/wdqNVYSRVbNYLB")
				MSCBWRITE("ZrYnWPrP9tfQAAAP//7Z1NkqQqEIAxXLhrL1AxXqN2XKnfBdQ+wbuSu74GL/oC9s6FUbz8A9TSrp/p6YgBMjqqLIT8HMEkQcj5YRa/ZhBWYTMrs36a1ZDmkQ/JF60z60GKXbKGwCL5tl4sQlZnN3LAWpzMLBE0CQMtQHmERY9C92gMiyhZrpJM9SjLqmqZL11Wc60iSP81K8iQNOs")
				MSCBWRITE("rDTs+wIHc1/LjYzVfYlDEn5fuSt/MPyTHuln0Ydbxvu1IWXcUNY+yTEKs5ipXr34d3exm4XoWzhF9pc9qvrbIQxKstRV1/bewXJwtVqZOMMS80ONBjM6KnXUsztVtrjt+1uoe+y2uzbDHgoLAauSasCvrqGW3K9b+1cfMCnfXLFJdWApOK8fA6ulSMIHUaAR0wyLzBpcAq+GUjetT")
				MSCBWRITE("uTeFXLwZJdUVbHpfPdioeSxUzWolonqInOUa/HYY41mrjj+wELC4js7usVxTmONm8a/rWR79n12yJIf+cDkxWfMhGBKxHlcsmeOU0nGz+muWYU2azzlW6aJIzSH2EbHe512WtIcxs76JVe+zCitPj0ZjBEpaSW2FBSdLZ9ZatPOoY4dVJMAqDlgTqcMaGkl1K6ncKdKFNI4FaS1Zq")
				MSCBWRITE("kNWnwDrykbVExcsJmJpZkFqLSzlvTpidQO2/B1Wt7DzsbLcXOaWNbAphxpqSXUrqfXEV3jFwr9rFis3kbM8bpUPmza2VGaBamrr8FEwa1qyagLV7jHxoregiFkom2RU3TCrHuRTCVYprrVNfdV2VV87/4DYWUpMCB+WrtdByuTsRemfDiIvbS9emzaBtWvQE2DBLe4rtsRLFldWYB")
				MSCBWRITE("klQ9YDFnkVpjucPIybxYJPOw1ZsUdCFhkNZFEq6SNLvPaj4HvGczdrKgUWCjmgqAMNBHVexKLUma9i488jy74fmYkUWXzHpZr0x8hQ61nsny/nAZD1XHDTWFlcRswFTaA455SIbnbK+Asj1nNBdiNliVbptipxqCQVWj43fj7Bnzzc1JkVWIa+nPvkWJwKleVm9nCmrwgd2t6YKFm")
				MSCBWRITE("WGATouYglgyNJXbwnCo6VDNkzK7D894tLQpYctkqcLPaZiPKinpVYWVmyZMmSJcu3S7leBvR6kE1/R0CzqFjGH1X2LUz1NKuX6yETegKL9Vm4vKNYXWFirHatBj2n4F5WS/2LY5zfqP3yDxy3J88KKvntQn+T1UtWT06ahUObMDikIqVv6EcsWj3onH0yNX+Odfo7WGGSon6A5f//")
				MSCBWRITE("1vJtSpv1DzTd88n94sGi77SOWPPqZNnrtFmvZ7AAv8uqTMqscqzhXj/KMhuWmu9jVT/KKn+OZV7U79aXOiXN6hWwfK9/p+1l1kJH85Y2a24Di30A9+uQRfmDD9BvR1LJsZpxwXrKF+2VW4iWLKtf1NADYyKvPXUWgwJLrdZHHLHw7cN6bH6P7LHC2b+XdS3tXbmeeXeYDitLlixZs")
				MSCBWRITE("mTJkiVLlixZsmTJkiVLlixZfkhk1f3gfsu2hn3hd5nrN5S+7Clk4hlm/+YzclbFc+v3vJbwlBssv8suGZZpl/mfYTlxqg9XqsbLoqg89TCrM4acKuxMOw8pVpXFfUoTbTvU1pb23Y7a9nouLBzMeLqhF22WAtDNlSmm8lLZT/sxVpB22mCjZYHquZuQpUtrTW1BGdThReO5bpC9Xh")
				MSCBWRITE("g8oLSDfbPNSKEigYXqHGuCssRq/n2HTCVckx3m6mNMgmVHzEL1BRUD2iEfFEdroqkaKeBMPRW2vKgZg39Uph6AaLSpaeEWZKLYNMzCNTAT6uiAtX4uYmVBq9XColhRrSo/cWccrsGAez7NRMQ/DIOErf2CpgaXHGlV0PPgyjILM03lJ+4Dna+C+UXKUi2W4fpasDAKxR0sXniwYMG")
				MSCBWRITE("DEVhuB3fkrArbMLEK61i0oEW79Rtr1sRdnmPxOWRJm5cnQFhlGiyDdmCSZ59Ngka+9nZDUegesBvcnC/ObuD37FiQPKsZDIloYrvxkQaL+vkBSmMHJf0XpmHFYB8kLOy/Rqw9tNXYfwHL91+YCXwAchissKj/gm4uARbFnbioF1VezhwexdA4iaJDQUM+ye7s6lKV+AvyVwYyvSpD")
				MSCBWRITE("i99om41RWPYEv85gSE7FAGMi+0Z+VJUCaylhad+fl1hZSt/Oklk35JxZWbL8hfI/ZpjwvA==:D386")
				MSCBWRITE("^BY11,3,224^FT234,1058^BCN,,Y,N")
				MSCBWRITE("^FD>:"+AllTrim(Etq->B1_COD)+"^FS")
				MSCBWRITE("^FT240,1540^A0N,108,112^FH\^FD"+AllTrim(Etq->B1_DESC)+"^FS")
				MSCBWRITE("^FT195,1683^A0N,125,141^FH\^FDQUANTIDADE: "+cValToChar(mv_par04)+" ^FS")
				MSCBWRITE("^FT242,1324^A0N,125,141^FH\^FDDESCRI\80\C7O:^FS")
				MSCBWRITE("^FT233,775^A0N,142,163^FH\^FDCod.Produto Interno:^FS")
				MSCBWRITE("^PQ1,0,1,Y^XZ")*/
			endif 

			MsCbEnd()
			MsCbClosePrinter()

			/*
			If cSeq == Nil   // Se sequência não foi informada
			If SC2->(dbSeek(xFilial("SC2")+Etq->(C2_OP+C2_PRODUTO)))
			RecLock("SC2",.F.)
			SC2->C2_YSLDIMP := SC2->C2_YSLDIMP + 1
			MsUnLock()
			Endif

			GravaSZ4(cCodBarProd,cCodBarExp)
			Endif
			*/
		Next nX

		Etq->(dbSkip())
	Enddo
	Etq->(dbCloseArea())

Return .T.


Static Function fGravaCB0(_cCodEtiqueta,cCodProd,cDescri,nQtd,cOPE)
/***************************************************/

	dbSelectArea("CB0")
	If RecLock("CB0",.T.)
		Replace CB0_FILIAL	With xFilial("CB0"),;
				CB0_CODETI	With _cCodEtiqueta,;
				CB0_DTNASC	With dDataBase,;
				CB0_CODPRO	With cCodProd,;
				CB0_QTDE	With VAL(nQtd),;
				CB0_LOCAL	With AllTrim(SB1->B1_LOCPAD),;
				CB0_LOCALI	With AllTrim(SB1->B1_LOCALIZ),;
				CB0_TIPO	With '01',;
				CB0_USUARI	With __cUserId
		CB0->(MsUnLock())

				// CB0_DESPRO	With cDescri,;
				// CB0_OP		With cOPE
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


/*_______________________________________________________________________________
¦ Função    ¦ ValidPerg  ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 23/11/2006 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Criação das Perguntas SX1                                         ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidPerg(cPerg)
	u_InPutSX1(cPerg,"01","Produto De?		 ","", "", "mv_ch1","C",14,0,0,"G","","SB1","","","mv_par01")
	u_InPutSX1(cPerg,"02","Produto Até?	 	 ","", "", "mv_ch2","C",14,0,0,"G","","SB1","","","mv_par02")
	u_InPutSX1(cPerg,"03","Quantidade impressa?	 	 ","", "", "mv_ch3","N",4,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04","Quantidade na caixa?	 	 ","", "", "mv_ch4","C",14,6,0,"G","","","","","mv_par04")
Return Nil
