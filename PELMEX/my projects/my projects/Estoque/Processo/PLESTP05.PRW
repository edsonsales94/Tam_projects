#Include "protheus.ch"

/*______________________________________________________________________________
¦ Programa  ¦ PLESTP05   ¦ Autor ¦ STAN LEE           ¦ Data ¦ 16/07/2019       ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Apontamento de produção via leitura do código de barras           ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLESTP05()
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
Static Function TITLOK(nPos)

Return .T.

/*_______________________________________________________________________________
¦ Função    ¦ TITudOk     ¦ Autor ¦ Ulisses Junior          ¦ Data ¦ 05/03/2008 ¦
+-----------+-------------+-------+-------------------------+------+------------+
¦ Descriçäo ¦ Validação na confirmação do browse                                ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function TITudOk

Return .T.

/*_______________________________________________________________________________
¦ Função    ¦ PlEstP2b    ¦ Autor ¦ STAN LEE          ¦ Data ¦ 17/07/2019       ¦
+-----------+-------------+-------+-------------------------+------+------------+
¦ Descriçäo ¦ Gravação do apontamento da OP                                     ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PlEstP2b
	Local nX, cParc, nSaldo
	Local xOP := cOP
	Private lMsHelpAuto := .T. // se .t. direciona as mensagens de help para o arq. de log
	Private lMsErroAuto := .F. //necessario a criacao, pois sera atualizado quando houver alguma incosistencia nos parametros


	Begin Transaction

		SB1->(dbSetOrder(1))

		SC2->(dbSetOrder(6))
		SC2->(dbSeek(xFilial("SC2")+cOP))
		SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))


		cParc := If(SC2->C2_QUJE < (SC2->C2_QUANT-1),"P","T")

		aMata250 :={{ "D3_FILIAL", xFilial("SD3"), NIL},;
		{ "D3_TM"    , "001"         , NIL},;
		{"D3_COD"    , SB1->B1_COD   , NIL},;
		{"D3_UM"     , SB1->B1_UM    , NIL},;
		{"D3_QUANT"  , 1  , NIL},;
		{"D3_OP"     , cOP  , NIL},;
		{'AUTEXPLODE', 'S'           , NIL},;
		{"D3_LOCAL"  , SC2->C2_LOCAL , NIL},;
		{"D3_DOC"    , GetSxeNum("SD3","D3_DOC"), NIL},;
		{"D3_EMISSAO", dDataBase     , NIL},;
		{"D3_CC"     , SC2->C2_CC    , NIL},;
		{"D3_XSEQUEN", cSeqB1  , NIL},;
		{"D3_PARCTOT", cParc         , NIL}}
		MSExecAuto({|x,y| mata250(x,y)},aMata250,3)

		If lMsErroAuto
			Mostraerro()
			DisarmTransaction()                     
			break
			Return               	
		else                   
			nSaldo := SC2->C2_QUANT-SC2->C2_QUJE

			Reclock("SZ1",.T.)
			SZ1->Z1_FILIAL	 := xFilial("SZ1")
			SZ1->Z1_OP		 := xOP
			SZ1->Z1_CHASSIS  := cSeqB1
			SZ1->Z1_DTAPONT  := ddatabase
			SZ1->Z1_HRAPONT  := Time()
			SZ1->Z1_HOST     := ALLTRIM(GetComputerName())
			SZ1->Z1_USER     := cUserName
			SZ1->(MsUnlock())

			If (nSaldo) == 0
				Reclock("SC2",.F.)
				SC2->C2_DATRF := ddatabase
				SC2->(MsUnlock())
			EndIf
		EndIf                	
	End Transaction	
Return

/*_______________________________________________________________________________
¦ Função    ¦ PLESTP2c    ¦ Autor ¦ STAN LEE          ¦ Data ¦ 17/07/2019       ¦
+-----------+-------------+-------+-------------------------+------+------------+
¦ Descriçäo ¦ Valida leitura do código de barras                                ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PlEstP2c()
	Local cProduto, nSaldo, nPos
	Local nQtd   := 1
	Local lRsp   := .F.   
	Private cOP    := SubStr(mLeitor,1,11)
	Private cSeqB1 := PADR(AllTrim(SubStr(mLeitor,12,Len(mLeitor))),6)

	If Empty(mLeitor)
		oLeitor:SetFocus()
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
		if !SZ1->(dbSeek(xFilial("SZ1")+cOP+cSeqB1))
			Reclock("SZ1",.T.)
			SZ1->Z1_FILIAL	 := xFilial("SZ1")
			SZ1->Z1_OP		 := cOP
			SZ1->Z1_CHASSIS  := cSeqB1
			SZ1->Z1_DTAPONT  := ddatabase
			SZ1->Z1_HRAPONT  := Time()
			SZ1->Z1_HOST     := ALLTRIM(GetComputerName())
			SZ1->Z1_USER     := cUserName
			SZ1->(MsUnlock())
		EndIf
		Aviso("Atenção","Ordem de produção encerrada !", {"Ok"})
	ElseIf SZ1->(dbSeek(xFilial("SZ1")+cOP+cSeqB1))
		Aviso("Atenção","Apontamento já realizado em "+dtoc(SZ1->Z1_DTAPONT)+" !!!", {"Ok"})
	Else
		SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
		nSaldo := SC2->C2_QUANT-SC2->C2_QUJE

		If !(SZ1->Z1_OP+SZ1->Z1_CHASSIS == cOP+cSeqB1)		
			If lRsp := (nSaldo > 0)
				Processa({||PlEstP2b(), "Processando..."}) 
			Else
				Aviso("Atenção","Saldo da OP já atendido!", {"Ok"})  
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
