#Include "protheus.ch"

/*______________________________________________________________________________
¦ Programa  ¦ PLESTP02   ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 18/03/2008 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Apontamento de produção via leitura do código de barras           ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLESTP02()
	Local oPanelT
	Local nOpcA   := 0
	Local bOk     := {||nOpcA:=1,oDlg:End()}
	Local bCancel := {||nOpcA:=0,oDlg:End()}

	Private oLeitor, mLeitor := Space(18)
	Private oDlg    := Nil
	Private oGet    := Nil
	Private aCols   :={}
	Private aHeader := {}
	Private aQtd    := {}
	Private aRotina := {		{"Leitura do Coletor","u_Leitura",0,1},;
	{"Leitura do Coletor","u_Leitura",0,2},;
	{"Leitura do Coletor","u_Leitura",0,3},;
	{"Leitura do Coletor","u_Leitura",0,4}}

	PlEstP2a()// Cria Header e aCols

	/*
	DEFINE MSDIALOG oDlg TITLE "Apontamento por Coletor" FROM 008,025  TO 036,105  PIXEL OF oMainWnd

	@ 0,0 MSPANEL oPanelT PROMPT "" SIZE 10,241 OF oDlg CENTERED LOWERED //"Botoes"
	oPanelT:Align := CONTROL_ALIGN_BOTTOM

	@ 05, 2 TO 110,315 LABEL "Apontamento de OP's " PIXEL OF oPanelT
	@ 15, 020 SAY "Leitura : "       SIZE 100,7 PIXEL OF oPanelT
	@ 15, 050 MSGET	oLeitor  Var mLeitor 	PICTURE "@!" Valid PlEstP2c() SIZE 090,07 PIXEL OF oPanelT
	*/

	DEFINE MSDIALOG oDlg TITLE "Apontamento por Coletor"  From 0,0 TO 470,1100 PIXEL OF oMainWnd


	@ 0,3 MSPANEL oPanelT PROMPT "" SIZE 35,410 OF oDlg CENTERED LOWERED //"Botoes"
	oPanelT:Align := CONTROL_ALIGN_ALLCLIENT//BOTTOM
	@ 15, 5 TO 40,550 LABEL "Apontamento de OP's " OF oPanelT PIXEL
	@ 24, 006 SAY "Leitura : "       SIZE 70,7 PIXEL OF oPanelT
	@ 23, 050 MSGET	oLeitor  Var mLeitor 	PICTURE "@!" Valid PlEstP2c() SIZE 070,07 PIXEL OF oPanelT

	oGet:= MSGetDados():New(40,5,200,550,4,"U_TITLOK()","U_TITudOk()" ,,.T.,,,,800,,,,,oPanelT)

	oGet:oBrowse:bChange := {|| GetAlt(oGet:oBrowse) }
	oGet:oBrowse:bSetGet := {|| GetAlt(oGet:oBrowse) }
	GetAlt(oGet:oBrowse)

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) centered

	If nOpcA = 1
		Processa({||PlEstP2b(), "Processando..."})
	EndIf

Return

/*_______________________________________________________________________________
¦ Função    ¦ PLESTP2a    ¦ Autor ¦ Ulisses Junior          ¦ Data ¦ 05/03/2008 ¦
+-----------+-------------+-------+-------------------------+------+------------+
¦ Descriçäo ¦ Montagem da Matriz aHeader - Cabeçalho do Browse                  ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PlEstP2a()

	aadd(aHeader,{"OP        "  ,"WKOP"   ,"@!",11,0,"","" ,"C","  "," "})//OP
	aadd(aHeader,{"Produto   "  ,"WKCOD"  ,"@!",15,0,"","" ,"C","  "," "})//Produto
	aadd(aHeader,{"Chassis   "  ,"WKCHS"  ,"@!",06,0,"","" ,"C","  "," "})//Produto
	aadd(aHeader,{"Qtd. OP   "  ,"WKQTDO" ,"@!",18,6,"","" ,"N","  "," "})//Quantidade OP
	aadd(aHeader,{"Saldo OP  "  ,"WKSLDO" ,"@!",18,6,"","" ,"N","  "," "})//Saldo OP
	aadd(aHeader,{"Qtd. Lida "  ,"WKQTDL" ,"@!",18,6,"","" ,"N","  "," "})//Quantidade Lida
	aadd(aHeader,{"Saldo     "  ,"WKSLD"  ,"@!",18,6,"","" ,"N","  "," "})//Saldo

Return

/*_______________________________________________________________________________
¦ Função    ¦ GetAlt      ¦ Autor ¦ Ulisses Junior          ¦ Data ¦ 05/03/2008 ¦
+-----------+-------------+-------+-------------------------+------+------------+
¦ Descriçäo ¦ Atualiza browse informando apenas o campo editável                ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function GetAlt(oGet)
	Local vVar := {}

	oGet:aAlter := {}
	oGet:oMother:aAlter := {}

	If Len(aCols) > 0
		vVar := {}
		oGet:aAlter := vVar
		oGet:oMother:aAlter := vVar
	Endif

Return

/*_______________________________________________________________________________
¦ Função    ¦ TITLOK      ¦ Autor ¦ Ulisses Junior          ¦ Data ¦ 05/03/2008 ¦
+-----------+-------------+-------+-------------------------+------+------------+
¦ Descriçäo ¦ Validação da linha do browse                                      ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function TITLOK(nPos)

	nPos := If( nPos == Nil , n, nPos)

	If !aCols[n][08] .And. aCols[n][06] < aCols[n][05]
		Aviso("Atencao","Não há saldo suficiente para o apontamento dessa OP!!!", {"Ok"})
		Return .F.
	EndIf

Return .T.

/*_______________________________________________________________________________
¦ Função    ¦ TITudOk     ¦ Autor ¦ Ulisses Junior          ¦ Data ¦ 05/03/2008 ¦
+-----------+-------------+-------+-------------------------+------+------------+
¦ Descriçäo ¦ Validação na confirmação do browse                                ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function TITudOk
	Local nX

	For nX:=1 To Len(aCols)
		If !U_TITLOK(nX)
			Return .F.
		EndIf
	Next nX

Return .T.

/*_______________________________________________________________________________
¦ Função    ¦ PlEstP2b    ¦ Autor ¦ Ulisses Junior          ¦ Data ¦ 05/03/2008 ¦
+-----------+-------------+-------+-------------------------+------+------------+
¦ Descriçäo ¦ Gravação do apontamento da OP                                     ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PlEstP2b
	Local nX, cParc

	Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help para o arq. de log
	Private lMsErroAuto := .f. //necessario a criacao, pois sera atualizado quando houver alguma incosistencia nos parametros

	Begin Transaction

		SB1->(dbSetOrder(1))

		For nX:=1 To Len(aCols)

			If !Empty(aCols[nX][1])
				SC2->(dbSetOrder(6))
				SC2->(dbSeek(xFilial("SC2")+aCols[nX][1]+aCols[nX][2]))
				SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))

				Reclock("SZ1",.T.)
				SZ1->Z1_FILIAL	 := xFilial("SZ1")
				SZ1->Z1_OP		 := aCols[nX][1]
				SZ1->Z1_CHASSIS  := aCols[nX][3]
				SZ1->Z1_DTAPONT  := ddatabase
				SZ1->Z1_HRAPONT  := Time()
				SZ1->Z1_HOST     := ALLTRIM(GetComputerName())
				SZ1->Z1_USER     := cUserName
				SZ1->(MsUnlock())

				cParc := If(aCols[nX][7] > 0,"P","T")

				aMata250 :={{ "D3_FILIAL", xFilial("SD3"), NIL},;
				{ "D3_TM"    , "001"         , NIL},;
				{"D3_COD"    , SB1->B1_COD   , NIL},;
				{"D3_UM"     , SB1->B1_UM    , NIL},;
				{"D3_QUANT"  , aCols[nX][6]  , NIL},;
				{"D3_OP"     , aCols[nX][1]  , NIL},;
				{'AUTEXPLODE', 'S'           , NIL},;
				{"D3_LOCAL"  , SC2->C2_LOCAL , NIL},;
				{"D3_DOC"    , GetSxeNum("SD3","D3_DOC"), NIL},;
				{"D3_EMISSAO", dDataBase     , NIL},;
				{"D3_CC"     , SC2->C2_CC    , NIL},;
				{"D3_XSEQUEN", aCols[nX][3]  , NIL},;
				{"D3_PARCTOT", cParc         , NIL}}

				MSExecAuto({|x,y| mata250(x,y)},aMata250,3)

				If lMsErroAuto
					DisarmTransaction()
					break
				EndIf
			EndIf
		Next nX

	End Transaction

	If lMsErroAuto
		/*
		Se estiver em uma aplicao normal e ocorrer alguma incosistencia nos parametros passados,mostrar na tela o log informando qual coluna teve a incosistencia.
		*/
		Mostraerro()
		Return
	EndIf

Return

/*_______________________________________________________________________________
¦ Função    ¦ PLESTP2c    ¦ Autor ¦ Ulisses Junior          ¦ Data ¦ 05/03/2008 ¦
+-----------+-------------+-------+-------------------------+------+------------+
¦ Descriçäo ¦ Valida leitura do código de barras                                ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PlEstP2c()
	Local cProduto, nSaldo, nPos
	Local cOP    := SubStr(mLeitor,1,11)
	Local cSeqB1 := PADR(AllTrim(SubStr(mLeitor,12,Len(mLeitor))),6)
	Local nQtd   := 1
	Local lRsp   := .F.

	If Empty(mLeitor)
		Return .T.
	EndIf

	SC2->(dbSetOrder(6))
	SB1->(dbSetOrder(1))
	SZ1->(dbSetOrder(1))
	SZ4->(dbSetOrder(1))

	If !SC2->(dbSeek(xFilial("SC2")+cOp))
		Aviso("Atenção","Ordem de produção inexistente !", {"Ok"})
	ElseIf !SZ4->(dbSeek(XFILIAL("SZ4")+cOP+cSeqB1)) .And. !SZ4->(dbSeek(XFILIAL("SZ4")+cOP+" "+cSeqB1))
		Aviso("Atenção","Etiqueta não impressa !", {"Ok"})
	ElseIf !Empty(SC2->C2_DATRF)
		Aviso("Atenção","Ordem de produção encerrada !", {"Ok"})
	ElseIf SZ1->(dbSeek(xFilial("SZ1")+cOP+cSeqB1)) .Or. SZ1->(dbSeek(xFilial("SZ1")+cOP+" "+cSeqB1))
		Aviso("Atenção","Apontamento já realizado em "+dtoc(SZ1->Z1_DTAPONT)+" !!!", {"Ok"})
	Else
		SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
		nSaldo := SC2->C2_QUANT-SC2->C2_QUJE

		If Ascan(aCols,{|x| x[1] = cOP .and. x[3] = cSeqB1}) == 0

			If (nPos := Ascan(aQtd,{|x| x[1] = cOP})) = 0
				aadd( aQtd , { cOp, 0})
				nPos := Len(aQtd)
			EndIf
			aQtd[nPos][2] += nQtd

			If lRsp := (nSaldo - aQtd[nPos][2] >= 0)         
				//			If lRsp := (nSaldo - aQtd[nPos][2] <= 0)
				If n = 1  .And. Empty(aCols[n][1])
					aCols[n][1] := cOP
					aCols[n][2] := SB1->B1_COD
					aCols[n][3] := cSeqB1
					aCols[n][4] := SC2->C2_QUANT
					aCols[n][5] := nSaldo
					aCols[n][6] := nQtd
					aCols[n][7] := nSaldo - aQtd[nPos][2]
				Else
					AADD( aCols , { cOP, SB1->B1_COD, cSeqB1, SC2->C2_QUANT, nSaldo, nQtd, nSaldo-aQtd[nPos][2], .F.})
				End
			Else
				Aviso("Atenção","Saldo insuficiente para este apontamento !", {"Ok"})  
				aQtd[nPos][2] -= nQtd   //STAN LEE 12/06/2019
			EndIf
		Else
			Aviso("Atenção","Esta etiqueta já foi lida !", {"Ok"})
		EndIf
	EndIf

	mLeitor := Space(18)
	oLeitor:SetFocus()
	//oLeitor:Refresh()
	oGet:Refresh()
	oDlg:Refresh()

Return lRsp