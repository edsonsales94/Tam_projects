#Include "Protheus.ch"
#include "rwmake.ch"  // incluido pelo assistente de conversao do AP6 IDE em 09/04/03

User Function Etqcol2()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetPrvt("LCOND,MOP,MCODPRO,MDESCRI,MCHASSIS")
	SetPrvt("NQUANT_C2,CONTAETQ,LPROBLEMA,LVOLTA,NREG,NAUX")
	SetPrvt("NO_CHASSIS,MLINHA,MCODIGO,MCODIGO1,MNOCAR,X")
	SetPrvt("LCONF,MCONF,CSENHA,CTEXTO,VUSU,CSENGRV")
	SetPrvt("MNROETIQ,MCOR,I,CPROC,NPOS,LRET,MTABELA")

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³ ETQPEL   ³ Autor ³ Jucimar Souza         ³ Data ³ 25/11/97 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Gera Etiqueta de Codigo de Barras para Imp. Termica        ³±±
	±±³          ³ Gravando os codigo que foram gerados para emissao de relat.³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Generico                              alteracao: 07/04/98  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	PegaSenha()

	lCond := .T.
	mCodPro   := Space(15)
	mDescri   := Space(40)

	While lCond

		mOp       := Space(11)
		mNroEtiq  := 0
		nQUANT_C2 := 0
		lRet      := .F.

		@ 0,0 TO 250,475 DIALOG oECol TITLE "Impressao de Etiquetas - Colchao"

		@ 10,005 Say "O.P:"
		@ 30,005 Say "Cod. Produto   "
		@ 45,005 Say "Descricao "
		@ 65,005 Say "Quantidade"
		@ 85,005 Say "N. de Etiquetas "

		@ 10,055 GET mOP          Picture "@!" F3 "SC2" Valid ValidaOP() SIZE 60,15
		@ 30,055 GET mCodPro      Picture "@!" WHEN .F. SIZE 60,15
		@ 45,055 GET mDescri      Picture "@!" WHEN .F. SIZE 120,15
		@ 65,055 GET nQuant_C2    Picture "@E 999,999,999" WHEN .F. SIZE 30,15
		@ 85,055 GET mNroEtiq     Picture "@E 9999" Valid fValEtq()

		@ 100,070 BMPBUTTON TYPE 01 ACTION Confir()
		@ 100,145 BMPBUTTON TYPE 02 ACTION Fechar()

		ACTIVATE DIALOG oECol CENTER

	End

Return

Static Function fValEtq()
	Local nQtd := 0, lRet := .T.

	If mNroEtiq < 1
		Alert("Quantidade de Estiquetas Invalidas !")
		lRet := .F.
	Endif

Return lRet


Static Function ValidaOP

	Local lRet := .F.

	SC2->(dbSetOrder(1))

	If ExistCpo("SC2",mOP)
		lRet := .T.
		SC2->(dbSeek(xFilial()+mOP))
		mCodPro := SC2->C2_Produto
		mDescri := Posicione("SB1",1,XFILIAL("SB1")+mCodPro,"B1_DESC")
		nQuant_C2 := SC2->C2_Quant - SC2->C2_QUJE
	Endif

Return(lRet)

Static Function Confir()
	ContaEtq := 1

	Imprime()

	Close(oECol)
Return

Static Function Fechar()

	lCond := .F.
	Close(oECol)

Return

Static Function PegaSenha()
	Local i, x

	cTexto  := MemoRead("SIGAPSS.SPF")
	vUsu    := "EDER           " + "0000"
	cSenGrv := ""
	For i:=1 To 2
		cProc  := ""
		For x:=Len(vUsu) To 1 Step -1
			cProc := cProc + Chr(Asc(SubStr(vUsu,x,1))+120)
		Next
		nPos := At(cProc,cTexto)
		nPos := nPos + 54
		For x:=nPos To nPos-5 Step -1
			cSenGrv := cSenGrv + Chr(Asc(SubStr(cTexto,x,1))-120)
		Next
		IIf( i == 1 , cSenGrv := cSenGrv + "#", )
	Next
Return

Static Function Imprime()
	Local cPorta := ""

	cPorta := "COM2:9600,n,8,2"
	MsCbPrinter("ALLEGRO",cPorta,,,.F.,,,,)
	MsCbChkStatus(.F.)

	While ContaEtq <= mNroEtiq
		// Incrementa o No. do Chassis e Imprime

		No_Chassis := Soma1(SB1->B1_CHASSIS, 6)

		RecLock("SB1",.F.)
		SB1->B1_CHASSIS := No_Chassis
		SB1->(MsUnLock())

		MsCbBegin(1,6,118)

		mCod1 := "Prod: " + mOp+" "+AllTrim(mCodPro)
		mCod2 := mOp+mCodPro

		MsCbSay(05,15,mCod1,"B","4","01","01")       //6
		MsCbSayBar(28,00,mCod2,"B","A",20,.F.,.F.,.F.,,5,1.5,.F.,.F.,"1",.T.)

		//	If (ContaEtq+1) <= mNroEtiq

		//No_Chassis := Soma1(SB1->B1_CHASSIS, 6)
		RecLock("SB1",.F.)
		SB1->B1_CHASSIS := No_Chassis
		SB1->(MsUnLock())

		mCod1 := "Exp: " + AllTrim(mCodPro)+" "+SB1->B1_Cor+" "+SB1->B1_Chassis
		mCod2 := mCodPro+SB1->B1_Cor+SB1->B1_Chassis

		MsCbSay(35,15,mCod1,"B","4","01","01")       //6
		MsCbSayBar(58,00,mCod2,"B","A",20,.F.,.F.,.F.,,6,1.5,.F.,.F.,"1",.T.)

		//		ContaEtq++
		/*		
		No_Chassis := Soma1(SB1->B1_CHASSIS, 6)
		RecLock("SB1",.F.)
		SB1->B1_CHASSIS := No_Chassis
		SB1->(MsUnLock())

		mCod1 := mOp+" "+AllTrim(mCodPro)+" "+SB1->B1_Cor+" "+SB1->B1_Chassis
		mCod2 := mOp+" "+mCodPro+SB1->B1_Cor+SB1->B1_Chassis

		MsCbSay(35,15,mCod1,"B","4","01","01")       //6
		MsCbSayBar(58,00,mCod2,"B","A",20,.F.,.F.,.F.,,3,1.5,.F.,.F.,"1",.T.)

		ContaEtq++
		*/
		//	Endif

		MsCbEnd()

		ContaEtq++
	Enddo

	MsCbClosePrinter()
Return
