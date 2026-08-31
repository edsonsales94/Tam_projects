#Include "rwmake.ch" 
#include "fileio.ch"

/*___________________________________________________________________________________
¦ Função    ¦ PLETQR01   ¦ Autor ¦ Stan Lee Lopes           ¦ Data ¦ 22/01/2019     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Impressão da Etiqueta da Pelmex (producao)                            ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLETQR07(cNumOP,cSeq)
	Local oDlg
	Local cPerg := "PLETQR07"

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


	cQry := "SELECT * "
	cQry += " FROM " + RetSQLName("SB1") + " SB1"
	cQry += " WHERE BE_LOCAL = '" + mv_par01 + "' " 
	cQry += " AND BE_LOCALIZ BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "' "
	cQry += " AND D_E_L_E_T_ = ''  "


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
	Local nHandle  := "" 
	Local cPorta   := "\\PCP3\ZM600"
	Local XEMP 	   := ""
	Local cPath    := GetSrvProfString("Startpath","")  //GetTempPath() //
	Local cEOL     := chr(13)+chr(10)
	Local cCodEmp  := FWCodEmp()			
	Local nP       := 0
	Local nP1      := 0
	Local FimRegistro :=0
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

		//For nX:=1 To mv_par02
		For nX := 1 To mv_par04

			cPesq    := ";"
			nP       := 1
			_cAux    := AllTrim(Etq->BE_DESCRIC)
			_cAviso  := AllTrim(Etq->BE_DESCRIC)

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
			/*
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

			//PELMEX
			if cCodEmp = '10'

				MSCBWRITE("CT~~CD,~CC^~CT~")
				MSCBWRITE("^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2~SD23^JUS^LRN^CI0^XZ")
				MSCBWRITE("^XA")
				MSCBWRITE("^MMT")
				MSCBWRITE("^PW2362")
				MSCBWRITE("^LL1890")
				MSCBWRITE("^LS0")
				MSCBWRITE("^FO192,128^GFA,36608,36608,00088,:Z64:")
				MSCBWRITE("eJzsXU1v20iaLkkhoraAlg2Yl82hB8nNWrSBPQ3sQSwD9p0GqF+TQ7htYFpwgPg+hx2OfdFQgGXkZJAN0XPLYv6EO3vRKAMr2L0IZMDa963iR/GjKEpyJxPAryK5yCpSjx49evhWscgQ8hiP8RiP8RiP8TWjTR8+bmG/Su/ho4t43YcP47fE+43x23IePh75FfA+6vdRvwLeb43fR")
				MSCBWRITE("/0+6lfE+63x+6jfR/2KeL81fh/1+6hfEe+3xu+jfh/1K+L91vh91O+/ln59iG9Kv7Ovy2+kX0eiRSdT54SL2fX/svoNvi6/S/uvvVC+q+lXOayEd1l+g9HH34RfjdSq4V3SWwf1FwvbrMJvZbxL8jsxW78NvxXalOqX+WzstXHBoiNfXH4o/Wo9tRJeCb+zwBqCWK1RQK8oK1DPZf")
				MSCBWRITE("/ORrBkWS6uWoXfLtTo+IItdGinc3IJPI+OjniDEryxr6YfNiF7zoCQg3HddaBQp9dtd/DMNUkD68juBOoy21TRr0YIe2OAyhDUeprS09QewRJsp2Ld0vwG9D1UBSYxWoEBiyYh7qc2nWwEhkF2PdhuZDbJ7gr8wnsiOKIyvFgAvF1YwlKI97gEr0y/ZMdseMaOUb8ivmOTPaP1qeU")
				MSCBWRITE("PWjaxzJZdtyzH6Jiybcv4JVtE0UmN1BCvTlSGV9vSyDZRNLJJeoC45LNK/aG/Mfg+6O/0N+77wG/zqt+eA78tD0veBui3P5rIti3hV0ch6PjVM7yoBsYvvtQ0tDQmkBK8xRY6Jgd2/QakWvfq1IWC2bhuO4PWdZ1OGnbDdajh3rSW919AqBMApDO8SK3C9NtVe1qIVy3HW0zRP2tB")
				MSCBWRITE("YMwb8IL6nT+dTZ+iflt37fv5qdeAFobrna/AL0B6IuLVOb+AFz4H4i1xwhL9zhuOf/Gp4diGTRznU8O3Wteo37tnvlf3GuC+RkdqwSX8MkhIIOiVF5grbHG8UOqVWaGc33kD8lxQ7MwYGwFlSp03+/3W+x9osIH6nQ2IjN5SfpVCvGp1vMX+C4p1neuW6xgvQb9ma+i61/ht3B444")
				MSCBWRITE("zr6GXrz7vL+q6Xxqjm8q/kvKBY8GBRLgV9K776HA94nhvdlEABeg4w8Q+otJfym8XYL+NVLvVum35uG4wyv4YXpF5zWHn5q+5PW7b5jM/36jve7xmr6PU7pgVnZVvJ7gypZplbC72ewhjPQb9Af92czLJwz/739gcLvDVK02YjOZZnaAv2SUn9Qelop3mIL/aUBOgV+bTIG/V6")
				MSCBWRITE("DET+F/GHSMtuujf7r2qce/nkY/+0m/ouHkOX5DT7XZuC/p5H/tqnX/nTO/Hc2b8zBf+//M4AjyfL8hsc3XXZ8W4RXol+P2HB8qzvw5UP+AG583fjUcgBvwx8Av75vG469gn57mC9A2tCF/GFzaxvTBTAJzB9UyB9qJ1u4YgX9zoyDSfveGA02gr5l/UJcI8wfyHjQnrP8AdSxP")
				MSCBWRITE("L/4ngqmZQpmZEqYn2l8Cf1B6Zb7gyz/NbAK0sjWFSa78DzA/Lc1xiWW/2LdavmvypJKPQSHJszzXzXCqy7PL50Qw4UX4gYGT87RjSffU4A5xuPFFaySdTDK+BXy9QhvmK+TXoRXsmlp/uuZkB945gvfubi4cKawZHcce9+xSMf3rOcWr1tev8xdWWeYZ+i1kF8QcE+PVq3Ab6L")
				MSCBWRITE("k5avK+F0nSvzXTY2QifIUhbq8/66PV0ZegPwFyVIQ/Q1CYmfB1+BXol+fPXgpWub/hGVZfBV+83QjpYlwS3T9JfSbFmh6dBeWnXjk1xFbL++/a+OV8xkwDoXx3iCImA5Kh4G/jH79WLZpaeaFKpNutP4L8StRZH51ak2Qb/CF/DclWJdTlV4rGHNcDbSmN/7y+q1wiqJ0my/kv")
				MSCBWRITE("64fx9S2bAcetuNYQz+nWtuyhlg/dJzpMFzn1eMGD8FvPMgjZMNSf5jdRxHQ+zgLm81wPbzS+6uwekSno1C/3oaMXxIFf0cWajKOE6/jOSYL7G3E1Wm8kSidsRG1PsDEl8euS+qhu97F+z0YR6W6bzZCNx7UZfqNt1MSbEo5Xhw2ibdWi/kNYrxtGmMbUSPspQUJ3vHnuAj5MOc")
				MSCBWRITE("3MCFfXsDvcng5TJ2k+U30a8d4607M7wsHlngkeJ15UjTJPt8ayhL9xo1JCm9tAV6+By2DV+S3SZqwptncgI5Fkz/a1Ih0edcM10GfIyo13UGT7WE2b24Ei/glS/DbDT9Pl2R+b7HqEv3WM/rlEa8jbqJfYL3huNSFv3W6SL/L8CvFK/JrsQDF3pE+j0S/sG7QN0nTMIgL+uXVZ")
				MSCBWRITE("zOQRgBpWyCOplXgt7fIH0IdpEbTsKWo3wY331v41RNmxtT1Qb+hr4JSfXzeEccjLd7URd12HDzDQV5J9VuL3k40J4Ffla3vIl41qg6BivLN8tsPxxPe10G/kecK+iXQYW6+hifoN9osoO+bLciLJ+S7JI/I8luMN+FXwCuSWcvIIaffxpA58S3q14/y3th/TXIAKt0Hnp0x34z")
				MSCBWRITE("57jUKHFY+lea/y/CbbMaZTe0oq9/v7vHv/S3qN+G3LvB7R14DlaBfvhkkxChgKJmknaRp1fh9Uo5XJ7yHryY7yuq3xgtMv36UMwj+uw/PV/AEtbaipMK/IaDpqUGeebL8dzV+e8KvTsZvSM9Gol+a0S8B/ZKUfmd9WJg3mzSJB9Evk66eGjxJ6Rfyh3A814j0y7ptwG/kvwfhE")
				MSCBWRITE("/xXOPVmggPfkIYvzX9X8odQwKk8L8cvP0KJ+qU5/VJBvywmxIBtxbHKB9GvBG+x/4JGWdHJ+G+oX/BfXo9VHkHT2BfS4wfjF7JOYYXs+NYH/23yw9cbmX7Dehe3QwGnJvXkjm/HLLrJ8a0m0298+AuPGKlJSFn9xllBnCvU3ZT/Qg687zL/DQNlDMTX/VQPLstv8fG4kN/oyIw")
				MSCBWRITE("Vm9mR1Sy/Md4k/03pd8x0zfQbRhsdYm5ATSm/hXgL9RuGEhKs5vAuyH9l/hvxixY8RwcW+3fr8xvhVXJ4s/kvPlj+y0Oq3yZmw9yGg2azXYlfJYW3TL9KuGEtj7dcv1Tiv5EesIIaJH0mTsavkvq9LdQvO0eAf1QRr6jfEDH233hxQ+a/YezCZpBisBSCDsYyfvUjCP0Y3/GIx")
				MSCBWRITE("bFMv094fS/UA0LVFTFTTumX+5mFXstLQ5n/bkQtedcNO3H2zqXMf7e2NuGxhe+4xUPGbw3bYbWAVxXxFuS/kGhNknQgxW+s3x8EuWLv85xS7/1Uwq/Yo0nWFvKrJpvx00U4We2oSL+Y/8ajuGY9HtNl/bec/z4TRolR7NCJe/dHuzx/yOBddHzrhUI/OdqU6Pc7nsIGNMofAir")
				MSCBWRITE("zX8EQAgOMBbj3jZurh+RXD395J10tbpnJH+KymQwmSPLfJFvA/AE7cf93sVeePyzJL+YPuJ803oL8FwRcOf+lyDfBTtzMe/unpfRb6L8C3m7Yq9fSekjpN0p6zWQwTBh/QP2G/vtD4rYDwHsLDvzuj3+iD6nfcEYl+MNh3LIw/2VcxsVi/w39ATt8pnGKFkE/uw/qD+xorOdGM")
				MSCBWRITE("tP5b6JfPzqVAf7LymykjGt43wZ/iE50eDjIBha87z3vVNAvc+LNTaSPefJm1n+ZV6th+ss6cSeCQlL++11cnoSpsIX6DUvA74yNP4B+o+PFiN5D123E+sc0oreU3/iAG5eKjsfhOfyS8QfHifyXe210wHWj0gHn9zXU7SfjZyz7ha0HYgeujN+18Rb4A43zX2MXkwMW7dB/AzF")
				MSCBWRITE("/IJh14PiOZ5D7eIAnza9ehFdZhFfnSHPjUTL/DeOpE5VaJhvb2U/lv5hKEJxICclHZ9H4QzFeRSvCi3NNlF7BeJ/Ib9LHjfPfNsWsmJUmzH8pHz9rhhkwtpzxLZKtb1fE20uNp5JwC/n4b5LFxvwm+t3HWb9TONjZdVc8f8Fy35F7E+fJy+oXTwCxZwpvlKuXja/n9YvnL8KSO")
				MSCBWRITE("z8LgkkzCKYGjfRr1CF5aIBuZ9CJM6Tj6wV4kyy+J0TSv4j7biXnLy7iGb3+h+dhOM5FWOI9tCG0Gzp2VL17A58Yt/JB0rF7Z/hdJbS4rynld6XAGVS8NEhm+92ujzfpunWL9ZuezyCP1LVwOE0Nux+4jfz82wqhJTvQZP6wQgTzeAczL5mNtj6/Al7s9gl417j+GNIKE4ceQt3")
				MSCBWRITE("G8n0A/XYLJ/mtz2+fFM2hXJtfyRzrtP+uEO/Y9vH1nA+mX62Q3rX5xYuJimZLrM1vN23LIt51rp/3wR32k+uRYwGvy6+eHYgS8K7FL3zcoGCCz7r8SuSQ0W92BnDZIxqRgHTt4eef6aRYDuvxO2MDxoVVa/LblW0t6td3lg44Fken4dKxJr8yelP8VrgsPhNBv9l0fwt+y/GK4")
				MSCBWRITE("l0q7giRXAC3Hr+axB3W1C+qVzKBfS1+w1FUGd5IvxfLKnhCSDLjTK5f6eR5WXSlchD5DYyNYq6k9IJ6K1wfq0vfXBJ6yXcj6Nc26ss4MJ/t03EWzv+VHaqk0S3ZQOD3nwY543N+FxLLG8Gvrdh8c/wuBVgrk76gX+iHEeis2RWEy0SLl4x0ZC3S/C4FONsDzeEN+f3cJ83msLp")
				MSCBWRITE("6B02y4Va4PoD3eCubRbe0sahftt9OFd9FnX7Axr6sRZbf6nhL5ZDyBxP3a1jlE9N50xn1AFFD3kL0X7IM4AVqF/3X4zt+UXphRShgzyxTb9p/Nb7fShJmX4Zajjc+vnl9Nk622IZnFMRb2i51fNOrA+4uaCfmv4475Tte6MN8cC26GGNx/luZYW0BvZn8YWowCZ8tJHiCDd2q/")
				MSCBWRITE("CajYhXYLRe6qF/HiUZ168KFQ0VatpiTlKncyLxxyHApd7xR+ZeQ5hclzOY/NEdUdukVnlqGxIGUq/w2S1TEcAl73cWfKD/+EEqY7LjigBqOk8VXYlihxssiy28vGT2VIa5kexl+A2bDTMVNK9/jYNcNDVj1sLw/kuM3Gdg9LoFSCW9m/IFZK8bzIT/rJsjY96e8NjlPV02/IsG")
				MSCBWRITE("FX3lFC8nql8WgyQgmTTa5TAxvEE3vWRB5fmMGi3xC70oqCvHG/ssuGYoUyp1iZ5SI0rqI1ibtK/lvHjCpCSSfFK2sxC+7vA10Oe0ne+732XnMQd+I1mxEWl6SX0HEPI6OjrrCZ6jQDynQLw+TSKNe1L6CfrMU52IxXHn/eNCPrq8gJHxyZ66SX5T1j3UZ2koJHMNb6KDW7yT77")
				MSCBWRITE("dBy6y3RLw+tcLdqFbil4w88m4gjnJsmvSVXRX6LOa6aziPe4vFf9F7LzO53Z8F1xwv1W8hx9d5dGb+M40GfSxgvKjqzKnG7mN8sw9VHgkT95n0U/1LbsvA85o4VrS4flVis3yhCsFuVwfbk/Aa02GGrXte5iN9VQ67f9aIKv6viXTQ+ufy48Fe9/6/jVL2xakX/XRvvCvwlUaz")
				MSCBWRITE("or6LfwsvoF9/792vrd5X4EvoNPdRZ5LCp8uLx34fHu5w045iVNPmC+vWTMQdfeA0FHcv3Y7j8tfU7TW6KOvPSy/fW1dQK3TgYUW9Eg+G02J3z/OrH6Y6xfpSUj3pxnc7+9RRJLzrvv+OnJr9RCSjzHfy92fmJMnVT1/np1buBy6cHj1vu9b5DL39F2Y5zLpznV1dwyikPnC2tq")
				MSCBWRITE("8Isop4Wz0Bldzvq1SS3Ws7z+/ntwGWyvKfBPKCzyY8/hbcrCegt/d9JwHt5QYvOX1J6+iv1iwaMC/hV9PSAj9oV8MZwAS+uL8Ob1q996r3Asxiu73i4fNMx4+k5d6/eRUWv5tzt+87lrxmJy/Wr9FJprohXy+M96RVGnt/gnJ6m+N6dxPzNX39kvoCa7dPJAaXDf1T2B34l27a")
				MSCBWRITE("uo0S1EC9XtaYeH6Oc9W2mDcbvEej4OMdy3n/HP/un46FtwWOIl6+Mdy8ca2wNMf293v9oWbYDta5rHpgH9ujyL5YzdYbDCv4LeLvayZPNbaXW1TZxjq2ubiuHXMvHh93tze3NJ2pvs7epHiu1E01VDg9zHY8ifoO/TTzvbGBZw7uJRT/vvAnGV2fWAPn9r/vJZGwP7H+/otevb")
				MSCBWRITE("15+HF3eTd23f5/kTisV6Rfw6qoCOLoa/KSAX62nKBrD+6Sn6XpX34ZNtG1NV47hI22rWl7Eef16p87fLrxnnZu9FxefbvZ9u2PaO53TD94rEO3GcHBjT6ydjuO827ve27m8NO29/Q+DKv4LeA853sMQ76aqKCcM77Z6om93NxHv5tamXqvVDuV4c/r97zf3b0dzdzSdz8cz0O/")
				MSCBWRITE("NdHY+RS8O3rrzz/ZkGuxSOv63+cud0fAf3h8O5pNK/tA7rOmKgPdo87innOgRv2r3GB1ER35Bv/AZtPyPrsB/f3ZPL+3zXftg9+LaPnDHu7/8x757fgFFMGBnPu6YzrgD7Tau93bdy7/Yvz+4/muV/BdA1Hoiv/pmr6cyfsEUTnpbXXYrze0aw3tyIseb1e/PF8Gfkd8Pn+Zj9")
				MSCBWRITE("Af7gL794AUupZd0Tt9MxnBwC8Zv5y/P6eWd94c/f8ibRCG/ymFKv4iX6wGcA7TM8UILxm9V/doNq3Nn73XmoN+733f8+XNzvGGBfvdAtJfOwB/Od/A+fp2huXcxvLjzdob/Y1bwX72mqeHvjSBeTeluq4gdRcvwagoUscV2rQe/N1U9rKTfN9Zo4o3bk6tdazIZ0fmPg/HZFej")
				MSCBWRITE("3JYh2SCf0fHI1bkP+MJr8eDY8m3g/nv+9mn5ZSnB8BBi7yC8sd3Wly67FgyI8D/VjpPiod6SSQ6g/7hbjTfmvbVk++C94L9rv0MUbwzMrHu+67six3BEuOjbUDK0rvGAEHmvlv2rFdhJ+eaqQv+fWDPO0GbuvXJhDhAlwwK4hWsSvNPQl4Bb334T/38Jz4m5cODHCd1InNHi5S")
				MSCBWRITE("v7wIFHQvwjwLlGMUE5rxDVfvE/fbi68od8K8yf/HwAA//+jwL3ohSeoEwcJzf3wLhsMrAdyfsO5kOD9jzkIQcfwff/vH9IZiP9h4fkPWQgeuBAxGqz/xePe4TZ+Rg4YwPEzssBo+CLcO5p+R9MvinuHWPgOtfQ7CkbBKBgFo2AUjAJiAQC3Kx95:7CC3")
				MSCBWRITE("^BY11,3,224^FT146,1310^BCN,,Y,N")
				MSCBWRITE("^FD>:"+AllTrim(Etq->BE_LOCALIZ)+"^FS")
				MSCBWRITE("^FT146,1553^A0N,133,156^FH\^FD"+AllTrim(Etq->BE_DESCRIC)+"^FS")
				MSCBWRITE("^FT151,1045^A0N,142,165^FH\^FDEndere\87o: "+AllTrim(Etq->BE_LOCALIZ)+"^FS")
				MSCBWRITE("^FT149,864^A0N,133,156^FH\^FDArmazem:"+AllTrim(Etq->BE_LOCAL)+"^FS")
				MSCBWRITE("^PQ1,0,1,Y^XZ")


			else
				//AMAZON

				MSCBWRITE("CT~~CD,~CC^~CT~")
				MSCBWRITE("^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2~SD23^JUS^LRN^CI0^XZ")
				MSCBWRITE("^XA")
				MSCBWRITE("^MMT")
				MSCBWRITE("^PW2362")
				MSCBWRITE("^LL1890")
				MSCBWRITE("^LS0")
				MSCBWRITE("^FO160,0^GFA,62208,62208,00108,:Z64:")
				MSCBWRITE("eJzs2bFxgzAYgFHnKCgzAqN4pUwQezRGYYSUFDkrl5gAQSksjAko76voXoHuR0KHgyRJWr4X1t29su7uVLNYG7BaFovFYrFYLBaLtWBFYLFYLBaLxcrHqlgsFivZCiwWi8VisVgsFovFyswKrAWs9c7mLBaLxWKxWCwWi3VDJYvF")
				MSCBWRITE("2rfVRFbJSuwSWUdWYqG+Av1/tuJx/9uytdqJVbGSrfrb6tb8KmuDxfpZNHtZrPWtslvzrPkdB6vfA7yzEq12YlWsmdZwlx1YyVZPsFjbsUpWYs/hFyucWSwWi/VlvbFYLBaLtXmriawzK6GnkTVcurFS")
				MSCBWRITE("+nxf1yNrxVrACqzZVhNZj569uVtrfL/ysk4ja7jsYKVa8ey9sFirWw1rMWuYvSwWa49WvJ9nsf7Oym2/wdqNVYSRVbNYLBZrYnWPrP9tfQAAAP//7Z1NkqQqEIAxXLhrL1AxXqN2XKnfBdQ")
				MSCBWRITE("+wbuSu74GL/oC9s6FUbz8A9TSrp/p6YgBMjqqLIT8HMEkQcj5YRa/ZhBWYTMrs36a1ZDmkQ/JF60z60GKXbKGwCL5tl4sQlZnN3LAWpzMLBE0CQMtQHmERY9C92gMiyhZrpJM9SjLqmqZL11Wc60iSP81K8iQNOsrDTs")
				MSCBWRITE("+wIHc1/LjYzVfYlDEn5fuSt/MPyTHuln0Ydbxvu1IWXcUNY+yTEKs5ipXr34d3exm4XoWzhF9pc9qvrbIQxKstRV1/bewXJwtVqZOMMS80ONBjM6KnXUsztVtrjt+1uoe+y2uzbDHgoLAauSasCvrqGW3K9b")
				MSCBWRITE("+1cfMCnfXLFJdWApOK8fA6ulSMIHUaAR0wyLzBpcAq+GUjetTuTeFXLwZJdUVbHpfPdioeSxUzWolonqInOUa/HYY41mrjj+wELC4js7usVxTmONm8a/rWR79n12yJIf+cDkxWfMhGBKxHlcsmeOU0nGz")
				MSCBWRITE("+muWYU2azzlW6aJIzSH2EbHe512WtIcxs76JVe")
				MSCBWRITE("+zCitPj0ZjBEpaSW2FBSdLZ9ZatPOoY4dVJMAqDlgTqcMaGkl1K6ncKdKFNI4FaS1ZqkNWnwDrykbVExcsJmJpZkFqLSzlvTpidQO2/B1Wt7DzsbLcXOaWNbAphxpqSXUrqfXEV3jFwr9rFis3kbM8bpUPmza2VGaBamrr8FEwa1")
				MSCBWRITE("qyagLV7jHxoregiFkom2RU3TCrHuRTCVYprrVNfdV2VV87/4DYWUpMCB")
				MSCBWRITE("+WrtdByuTsRemfDiIvbS9emzaBtWvQE2DBLe4rtsRLFldWYBklQ9YDFnkVpjucPIybxYJPOw1ZsUdCFhkNZFEq6SNLvPaj4HvGczdrKgUWCjmgqAMNBHVexKLUma9i488jy74fmYkUWXzHpZr0x8hQ61nsny/nAZD1XHDTWFlcRs")
				MSCBWRITE("wFTaA455SIbnbK+Asj1nNBdiNliVbptipxqCQVWj43fj7Bnzzc1JkVWIa")
				MSCBWRITE("+nPvkWJwKleVm9nCmrwgd2t6YKFmWGATouYglgyNJXbwnCo6VDNkzK7D894tLQpYctkqcLPaZiPKinpVYWVmyZMmSJcu3S7leBvR6kE1/R0CzqFjGH1X2LUz1NKuX6yETegKL9Vm4vKNYXWFirHatBj2n4F5WS/2LY5zfqP3yDxy")
				MSCBWRITE("3J88KKvntQn+T1UtWT06ahUObMDikIqVv6EcsWj3onH0yNX+Odfo7WGGSon6A5f//1vJtSpv1DzTd88n94sGi77SOWPPqZNnrtFmvZ7AAv8uqTMqscqzhXj/KMhuWmu9jVT/KKn+OZV7U79aXOiXN6hWwfK9/p")
				MSCBWRITE("+1l1kJH85Y2a24Di30A9+uQRfmDD9BvR1LJsZpxwXrKF+2VW4iWLKtf1NADYyKvPXUWgwJLrdZHHLHw7cN6bH6P7LHC2b+XdS3tXbmeeXeYDitLlixZsmTJkiVLlixZsmTJkiVLlixZfkhk1f3gfsu2hn3hd5nrN5S")
				MSCBWRITE("+7Clk4hlm/+YzclbFc")
				MSCBWRITE("+v3vJbwlBssv8suGZZpl/mfYTlxqg9XqsbLoqg89TCrM4acKuxMOw8pVpXFfUoTbTvU1pb23Y7a9nouLBzMeLqhF22WAtDNlSmm8lLZT/sxVpB22mCjZYHquZuQpUtrTW1BGdThReO5bpC9Xhg8oLSDfbPNSKEigYXqHGuCssRq/n2HTCVckx3m6mNMgmVHzEL1BRUD2iEfFEdroqkaKeBMPRW2vKgZg39Uph6AaLSp")
				MSCBWRITE("aeEWZKLYNMzCNTAT6uiAtX4uYmVBq9XColhRrSo/cWccrsGAez7NRMQ/DIOErf2CpgaXHGlV0PPgyjILM03lJ+4Dna+C+UXKUi2W4fpasDAKxR0sXniwYMGDEVhuB3fkrArbMLEK61i0oEW79Rtr1sRdnmPxOWRJm5cnQFhlGiyDdmCSZ59Ngka+9nZDUegesBvcnC/ObuD37FiQPKsZDIloYrvxkQaL")
				MSCBWRITE("+vkBSmMHJf0XpmHFYB8kLOy/Rqw9tNXYfwHL91+YCXwAchissKj/gm4uARbFnbioF1VezhwexdA4iaJDQUM+ye7s6lKV+AvyVwYyvSpDi99om41RWPYEv85gSE7FAGMi+0Z+VJUCaylhad+fl1hZSt/Oklk35JxZWbL8hfI/ZpjwvA==:D386")
				MSCBWRITE("^BY11,3,224^FT146,1310^BCN,,Y,N")
				MSCBWRITE("^FD>:"+AllTrim(Etq->BE_LOCALIZ)+"^FS")
				MSCBWRITE("^FT146,1553^A0N,133,156^FH\^FD"+AllTrim(Etq->BE_DESCRIC)+"^FS")
				MSCBWRITE("^FT151,1045^A0N,142,165^FH\^FDEndere\87o: "+AllTrim(Etq->BE_LOCALIZ)+"^FS")
				MSCBWRITE("^FT149,864^A0N,133,156^FH\^FDArmazem:"+AllTrim(Etq->BE_LOCAL)+"^FS")
				MSCBWRITE("^PQ1,0,1,Y^XZ")


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

/*_______________________________________________________________________________
¦ Função    ¦ ValidPerg  ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 23/11/2006 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Criação das Perguntas SX1                                         ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidPerg(cPerg)
	u_InPutSX1(cPerg,"01","Armazem?		 	 ","", "", "mv_ch1","C",2,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02","Endereço?	 	 ","", "", "mv_ch2","C",17,0,0,"G","","SBE","","","mv_par02")
	u_InPutSX1(cPerg,"03","Endereço?	 	 ","", "", "mv_ch3","C",17,0,0,"G","","SBE","","","mv_par03")
	u_InPutSX1(cPerg,"04","Quantidade?	 	 ","", "", "mv_ch4","N",4,0,0,"G","","","","","mv_par04")
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
