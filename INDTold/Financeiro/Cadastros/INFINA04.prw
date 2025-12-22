#Include "totvs.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ INFINA04   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 29/04/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cadastro de manutenção dos dados migrados para o MCT          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function INFINA04()
	Local aCores      := {	{"Z0_REGBLQ$'1'" ,"ENABLE" },;    // REGISTRO SEM ALTERAÇÃO
									{"Z0_REGBLQ$'2'" ,"BR_AMARELO"},; // REGISTRO ALTERADO
									{"Z0_REGBLQ$'34'","DISABLE"}}     // REGISTRO BLOQUEADO
	
	Private cCadastro := "Manutenção MCT"
	Private cAlias1   := "SZ0"
	Private cAlias2   := "SZ3"
	Private aRotina   := { 	{"Pesquisar"  ,"AxPesqui"     ,0,1} ,;
									{"Vis.FIN/COM","u_FIN04Inclui",0,2} ,;
									{"Despesa RH" ,"u_FIN04DespRH",0,3} ,;
									{"Alt.FIN/COM","u_FIN04Inclui",0,4} ,;
									{"Exc.FIN/COM","u_FIN04Inclui",0,5} ,;
									{"Alt.Projeto","u_FIN04AltPrj",0,6} ,;
									{"Legenda"    ,"u_FIN04Legend",0,7} }
	
	dbSelectArea(cAlias1)
	dbSetOrder(1)
	
	mBrowse( 6,1,22,75,cAlias1,,,,,,aCores)
	Set Filter To
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦FIN04Inclui ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 05/05/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Manutenção das despesas do MCT                                ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FIN04Inclui(cAlias, nRecNo, nOpc )
	Local nX, aPosObj, aSize, oBlq
	Local nOpcA     := 0
	Local oMainWnd  := Nil
	Local aAlter    := Nil
	Local aAltera   := {}
	Local aCab      := {}
	Local aButtons  := {}
	
	Private aTela   := {}
	Private aGets   := {}
	Private bCampo  := { |nField| Field(nField) }
	Private Inclui  := (nOpc == 3)
	Private Altera  := (nOpc == 4)
	Private cFilSZ3 := If( Inclui , (cAlias)->(XFILIAL(cAlias)), (cAlias)->Z0_FILIAL)
	Private aAcho   := { "Z3_NUMERO", "Z3_PREFIXO", "Z3_TIPO", "Z3_PARCELA", "Z3_CLIFOR", "Z3_LOJA", "Z3_FILORIG", "Z3_ROTINA", "Z3_CHAVE", "NOUSER"}
	
	Private oDlg, oGet, oDes, oRec, oSal, oTam, oRateio
	Private aHeader := {}
	Private aCols   := {}
	Private nPD     := 1
	Private nTotRec := 0
	Private nTotDes := 0
	Private cJustif := ""
	
	Private cProjeto := Space(TamSX3("CTT_CUSTO")[1])
	Private cCLVL    := Space(TamSX3("CTH_CLVL")[1])
	Private lAlterou := ((cAlias1)->Z0_REGBLQ $ "24")
	Private lDocBloq := ((cAlias1)->Z0_REGBLQ $ "34")
	
	// Posiciona nos detalhes do documento
	(cAlias2)->(dbSetOrder(2))
	If !(cAlias2)->(dbSeek((cAlias1)->(Z0_FILIAL+Z0_CHAVE)))
		Alert("Não foi possível localizar os detalhes desse documento !")
		Return
	Endif
	
	If Trim((cAlias2)->Z3_ROTINA) == "GPEM670"
		AAdd( aAcho , "Z3_ITEMCTA" )
	Endif
	
	// Ajusta o tamanho dos campos
	For nX:=1 To Len(aAcho)
		aAcho[nX] := PADR(aAcho[nX],Len(SX3->X3_CAMPO))
	Next
	
	//+----------------
	//| Monta os aCols
	//+----------------
	MontaaCols(@aAltera,Inclui,nOpc)
	
	//+----------------------------------
	//| Inicia as variaveis para Enchoice
	//+----------------------------------
	dbSelectArea(cAlias2)
	dbSetOrder(1)
	nRecNo := Recno()
	For nX:= 1 To FCount()
		M->&(Eval(bCampo,nX)) := If( Inclui , CriaVar(FieldName(nX),.T.), FieldGet(nX))
	Next nX
	
	//+----------------------------------
	//| Inicia as posições dos objetos
	//+----------------------------------
	PosObjetos(@aSize,@aPosObj,{{80,.F.},{100,.T.},{35,.F.}})
	
	RegToMemory("SE2",.F.,.T.)    // Carrega na memória o conteúdo do título a pagar
	
	aEval( aHeader , {|x| AAdd( aCab , Trim(x[1]) ) } )   // Monta o cabeçalho
	
	AAdd( aButtons,{"EXCEL" ,{|| GeraExcel(aCab,aCols)  },"Exporta Excel"})
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL
	
	EnChoice(cAlias2, nRecNo, nOpc,,,,aAcho,aPosObj[1],, 3,,,,oDlg)
	
	oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_FIN04LinOk()",,,.T.,aAlter,,,1000,,,,"u_FIN04DelIt()",oDlg)
	oGet:oBrowse:SetFocus()
	
	If Trim((cAlias2)->Z3_ROTINA) == "GPEM670"
		@ aPosObj[3,1]+00,aPosObj[3,2]+05 SAY "Colaborador:" COLOR CLR_HBLUE PIXEL OF oDlg
		@ aPosObj[3,1]+00,aPosObj[3,2]+40 SAY CTD->CTD_DESC01 PIXEL OF oDlg
	Else
		@ aPosObj[3,1]+00,aPosObj[3,2]+05 SAY "Fornecedor:" COLOR CLR_HBLUE PIXEL OF oDlg
		@ aPosObj[3,1]+00,aPosObj[3,2]+40 SAY SA2->A2_NOME PIXEL OF oDlg
	Endif
	
	@ aPosObj[3,1]+00,(aPosObj[3,4]-100) SAY "Total de Despesas:" COLOR CLR_HBLUE PIXEL OF oDlg
	@ aPosObj[3,1]+10,(aPosObj[3,4]-100) SAY "Total de Receitas:" COLOR CLR_HBLUE PIXEL OF oDlg
	@ aPosObj[3,1]+20,(aPosObj[3,4]-100) SAY "Saldo do Documento:" COLOR CLR_HBLUE PIXEL OF oDlg
	@ aPosObj[3,1]+30,(aPosObj[3,4]-100) SAY "Total de registros:" COLOR CLR_HBLUE PIXEL OF oDlg
	@ aPosObj[3,1]+00,(aPosObj[3,4]-050) SAY oDes VAR nTotDes Picture "@E 999,999,999.99" PIXEL OF oDlg
	@ aPosObj[3,1]+10,(aPosObj[3,4]-050) SAY oRec VAR nTotRec Picture "@E 999,999,999.99" PIXEL OF oDlg
	@ aPosObj[3,1]+20,(aPosObj[3,4]-050) SAY oSal VAR nTotDes-nTotRec Picture "@E 999,999,999.99" PIXEL OF oDlg
	@ aPosObj[3,1]+30,(aPosObj[3,4]-050) SAY oTam VAR Len(aCols) Picture "@E 999999" PIXEL OF oDlg
	
	@ aPosObj[3,1]+15,aPosObj[3,2]+005 SAY "Projeto:" PIXEL OF oDlg
	@ aPosObj[3,1]+15,aPosObj[3,2]+030 MSGET cProjeto F3 "CTT" VALID u_FIN04Valid() WHEN Inclui .Or. Altera PIXEL OF oDlg
	@ aPosObj[3,1]+15,aPosObj[3,2]+100 SAY "Classe MCT:" PIXEL OF oDlg
	@ aPosObj[3,1]+15,aPosObj[3,2]+135 MSGET cCLVL F3 "CTH" VALID u_FIN04Valid() WHEN Inclui .Or. Altera PIXEL OF oDlg
	@ aPosObj[3,1]+15,aPosObj[3,2]+205 Button oRateio Prompt "&Rateio" SIZE 60,15 ACTION (CarregaRateio((cAlias2)->Z3_ROTINA),oGet:oBrowse:SetFocus());
													WHEN Inclui .Or. Altera PIXEL OF oDlg
	
	@ aPosObj[3,1]+15,aPosObj[3,2]+300 Button oBtnOk Prompt "&Justificativa" SIZE 60,15 ACTION Justificativa() PIXEL OF oDlg
	
	@ aPosObj[3,1]+20,aPosObj[3,2]+395 CHECKBOX oBlq VAR lDocBloq PROMPT "Alteração concluída" PIXEL OF oDlg SIZE 100,08
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| nOpcA := If( nOpc == 2 .Or. nOpc == 5 .Or. Obrigatorio(aGets,aTela).And.;
                                                              u_FIN04TudOk(),1,0),;
                                                              If(nOpcA==1,oDlg:End(),) }, {||nOpcA:=0,oDlg:End()},,aButtons )
 	
 	If nOpc > 2
		If nOpcA == 1
			Begin Transaction
			FIN04Grava(nOpc,nRecNo,aAltera)
			End Transaction
		Endif
	Endif
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FIN04Legend¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 03/06/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Legenda da Tabela                                             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FIN04Legend( cAlias, nRecNo, nOpc )
	BRWLEGENDA(cCadastro,"Legenda - Base Paralela MCT",;
								{{"ENABLE"    ,"Registro Sem alteração"  },;
								{"BR_AMARELO","Registro alterado"   },;
								{"DISABLE"   ,"Registro bloqueado"}})
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FIN04DelIt ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 05/05/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar delecao dos itens                                     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FIN04DelIt()
	Local x
	Local lRet := .T.
	Local nDel := Len(aCols[1])
	
	If !Inclui .And. !Altera
		Return .F.
	Endif
	
	If nPD == 2 .And. aCols[n,nDel] // Na delecao da linha - 2a. passagem
	ElseIf nPD == 1
		If aCols[n,nDel] // Na recuperacao da linha - 1a. passagem
		Endif
	Endif
	nPD := If( nPD == 2 , 1, nPD + 1)
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FIN04Valid ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 05/05/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar os campos                                             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FIN04Valid()
	Local nX, nPCod, nPDes
	Local cVar := ReadVar()
	Local lRet := .T.
	
	If cVar == "M->Z3_VALOR"
		If lRet := Positivo()
			lAlterou := .T.
		Endif
	ElseIf cVar == "M->Z3_CONTAB"
		If lRet := Existcpo("CT1")
			lAlterou := .T.
		Endif
	ElseIf cVar == "M->Z3_CLVL"
		If lRet := Existcpo("CTH")
			lAlterou := .T.
		Endif
	ElseIf cVar == "M->Z3_CC"
		If lRet := Existcpo("CTT")
			lAlterou := .T.
		Endif
	ElseIf cVar == "M->Z3_ITEMCTA"
		If lRet := Existcpo("CTD")
			lAlterou := .T.
		Endif
	ElseIf cVar == "M->Z3_BANCO"
		If lRet := Vazio()
		ElseIf lRet := Existcpo("SA6")
			lAlterou := .T.
		Endif
	ElseIf cVar == "M->Z3_BENEF"
		If lRet := NaoVazio()
			lAlterou := .T.
		Endif
	ElseIf cVar == "M->Z3_VIAGEM"
		If lRet := Vazio()
		ElseIf lRet := Existcpo("SZ7")
			lAlterou := .T.
		Endif
	ElseIf cVar == "M->Z3_TREINAM"
		If lRet := Vazio()
		ElseIf lRet := Existcpo("SZ8")
			lAlterou := .T.
		Endif
	ElseIf cVar == "M->Z3_PRODUTO"
		If lRet := Texto()
			lAlterou := .T.
		Endif
	ElseIf cVar == "M->Z3_PRCOMP"
		If lRet := Vazio()
		ElseIf lRet := Existcpo("SC7")
			lAlterou := .T.
		Endif
	ElseIf cVar == "CPROJETO"
		If lRet := Vazio()
		ElseIf lRet := ExistCpo("CTT")
			If MsgYesNo("Confirma a alteração dos Projetos nos itens?")
				nPCod := AScan( aHeader , {|y| Trim(y[2]) == "Z3_CC"     } )
				nPDes := AScan( aHeader , {|y| Trim(y[2]) == "Z3_DESCCC" } )
				For nX:=1 To Len(aCols)
					aCols[nX,nPCod] := cProjeto
					aCols[nX,nPDes] := Posicione("CTT",1,XFILIAL("CTT")+cProjeto,"CTT_DESC01")
				Next
				cProjeto := Space(Len(cProjeto))
				lAlterou := .T.
				oGet:oBrowse:Refresh()
			Endif
		Endif
	ElseIf cVar == "CCLVL"
		If lRet := Vazio()
		ElseIf lRet := ExistCpo("CTH")
			If MsgYesNo("Confirma a alteração das Classes MCT nos itens?")
				nPCod := AScan( aHeader , {|y| Trim(y[2]) == "Z3_CLVL"   } )
				nPDes := AScan( aHeader , {|y| Trim(y[2]) == "Z3_DESCTH" } )
				For nX:=1 To Len(aCols)
					aCols[nX,nPCod] := cCLVL
					aCols[nX,nPDes] := Posicione("CTH",1,XFILIAL("CTH")+cCLVL,"CTH_DESC01")
				Next
				cCLVL    := Space(Len(cCLVL))
				lAlterou := .T.
				oGet:oBrowse:Refresh()
			Endif
		Endif
	Else
		lAlterou := .T.
	Endif
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FIN04LinOk ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 05/05/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar a linha do item                                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FIN04LinOk(nPos)
	Local nX
	
	If Inclui .Or. Altera
		nPos := If( nPos == Nil , n, nPos)
		For nX:=1 To Len(aCols[nPos])-1
			If !MaCheckCols(aHeader,aCols,nPos)
				Return .F.
			Endif
		Next
	Endif
	
Return .T.

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FIN04TudOk ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 05/05/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar todas as linhas dos itens                             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FIN04TudOk()
	Local x
	Local cGer := ""
	Local nDel := Len(aCols[1])
	Local nCnt := 0
	Local lRet := .T.
	
	For x:=1 To Len(aCols)
		If !(lRet := u_FIN04LinOk(x))
			Exit
		Endif
	Next
	
	If lRet
		// Conta o número de itens deletados
		aEval( aCols , {|x| nCnt += If( x[nDel] , 1, 0) } )
		
		If lRet := (nCnt <> Len(aCols))
		Else
			If Inclui
				Aviso( "INVÁLIDO", "Favor adicionar pelo menos um item válido ao INCLUIR !", {"Ok"} )
			Else
				Aviso( "INVÁLIDO", "Não podem ser excluídos todos os itens. Utilize a opção EXCLUIR !", {"Ok"} )
			Endif
		Endif
	Endif
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FIN04Grava ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 05/05/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Grava os dados da lista de presentes                          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦ Parâmetro ¦ nOpc     -> Tipo da função (inclui,altera,exclui)             ¦¦¦
|¦¦           ¦ nRecNo   -> Numero do registro a ser gravado                  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function FIN04Grava(nOpc,nRecNo,aAltera)
	Local nX, nY, cSeek
	Local nPDel := Len(aCols[1])
	
	// Atualiza o saldo do documento
	RecLock(cAlias1,.F.)
	(cAlias1)->Z0_VALOR  := nTotDes - nTotRec
	
	If (cAlias1)->Z0_REGBLQ $ "13"
		(cAlias1)->Z0_REGBLQ := If( lDocBloq .And. lAlterou , "4", If( lAlterou , "2", If( lDocBloq , "3", "1")))
	ElseIf (cAlias1)->Z0_REGBLQ $ "24"
		(cAlias1)->Z0_REGBLQ := If( lDocBloq , "4", "2")
	Endif
	MsUnLock()
	
	// Atualiza os itens do documento
	For nX:=1 To Len(aCols)
		
		If nX <= Len(aAltera)
			(cAlias2)->(dbGoTo(aAltera[nX]))   // Posiciona no registro
		Endif
		
		GravaItem(nX,nX>Len(aAltera),nOpc == 5 .Or. aCols[nX,nPDel])
	Next
	
	For nX:=Len(aCols)+1 To Len(aAltera)
		(cAlias2)->(dbGoTo(aAltera[nX]))   // Posiciona no registro
		GravaItem(nX,.F.,.T.)    // Exclui os itens restantes
	Next
	
	If !Empty(cJustif)
		cSeek := (cAlias2)->Z3_FILORIG
		
		If Trim((cAlias2)->Z3_ROTINA) == "FINA050" .Or. Empty(SD1->D1_PRCOMP)
			cSeek += "4"+M->E2_NUM+M->E2_PREFIXO+M->E2_FORNECE+M->E2_LOJA
		Else
			cSeek += "1"+SD1->D1_PRCOMP
		Endif
		
		SZ4->(dbSetOrder(1))
		If SZ4->(dbSeek(cSeek))
			RecLock("SZ4",.F.)
		Else
			RecLock("SZ4",.T.)
			SZ4->Z4_FILIAL := (cAlias2)->Z3_FILORIG
			If Trim((cAlias2)->Z3_ROTINA) == "FINA050" .Or. Empty(SD1->D1_PRCOMP)
				SZ4->Z4_TIPO    := "4"
				SZ4->Z4_NUM     := M->E2_NUM
				SZ4->Z4_PREFIXO := M->E2_PREFIXO
				SZ4->Z4_FORNECE := M->E2_FORNECE
				SZ4->Z4_LOJA    := M->E2_LOJA
			Else
				SZ4->Z4_TIPO    := "1"
				SZ4->Z4_NUM     := SD1->D1_PRCOMP
			Endif
		Endif
		SZ4->Z4_JUSTIFI := cJustif
		MsUnLock()
	Endif
	
Return

Static Function GravaItem(nX,lNovo,lDel)
	Local nY
	
	If !(lNovo .And. lDel)   // Se não for um novo registro deletado
		RecLock(cAlias2,lNovo)
		If lDel
			dbDelete()
		Else
			// Grava o cabeçalho
			For nY := 1 To Len(aAcho)
				If FieldPos(aAcho[nY]) > 0
					FieldPut(FieldPos(aAcho[nY]),M->&(aAcho[nY]))
				Endif
			Next
			// Grava os itens
			For nY := 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[nY,2])),aCols[nX,nY])
			Next nY
			(cAlias2)->Z3_REGBLQ := (cAlias1)->Z0_REGBLQ
		Endif
		MsUnLock()
	Endif
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MontaaCols ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 05/05/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria a variavel vetor aCols                                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function MontaaCols(aAltera,lNovo,nOpc)
	Local nCols, nUsado, nX
	Local nIndex := (cAlias2)->(IndexOrd())
	Local nRecno := (cAlias2)->(Recno())
	Local cSeek  := (cAlias2)->(Z3_FILORIG+Z3_CHAVE)
	
	//+--------------
	//| Monta o aHeader
	//+--------------
	CriaHeader()
	
	//+--------------
	//| Monta o aCols com os dados referentes os ITENS
	//+--------------
	nCols  := 0
	nUsado := Len(aHeader)
	
	If !lNovo .Or. nOpc == 6
		dbSelectArea(cAlias2)
		dbSetOrder(3)
		dbSeek(cSeek,.T.)
		While !Eof() .And. cSeek == (cAlias2)->(Z3_FILORIG+Z3_CHAVE)
			
			If (cAlias2)->Z3_RECPAG == "R"
				nTotRec += (cAlias2)->Z3_VALOR
			Else
				nTotDes += (cAlias2)->Z3_VALOR
			Endif
			
			aAdd(aCols,Array(nUsado+1))
			nCols ++
			
			For nX := 1 To nUsado
				If ( aHeader[nX][10] != "V")
					aCols[nCols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
				Endif
			Next nX
			aCols[nCols][nUsado+1] := .F.
			
			If nOpc <> 6   // Se não for cópia
				AAdd( aAltera , Recno() )  // Adiciona o registro do item
			Endif
			
			dbSkip()
		Enddo
		(cAlias2)->(dbSetOrder(nIndex))
		(cAlias2)->(dbGoTo(nRecno))
	Endif
	
	If Empty(aCols)  // Caso nao tenha itens
		//+--------------
		//| Monta o aCols com uma linha em branco
		//+--------------
		aColsBlank(cAlias2,@aCols,nUsado)
	Endif
	
	// Posiciona nas tabelas relacionadas ao documento conforme origem
	If Trim((cAlias2)->Z3_ROTINA) == "FINA050"
		// Posiciona no título a pagar
		SE2->(dbSetOrder(1))
		SE2->(dbSeek(SZ3->(Z3_FILORIG+Z3_PREFIXO+Z3_NUMERO+Z3_PARCELA+Z3_TIPO+Z3_CLIFOR+Z3_LOJA)))
		
		// Posiciona no fornecedor
		SA2->(dbSetOrder(1))
		SA2->(dbSeek(SZ3->(Z3_FILORIG+Z3_CLIFOR+Z3_LOJA)))
	ElseIf Trim((cAlias2)->Z3_ROTINA) == "MATA100"
		// Posiciona no documento de entrada
		SF1->(dbSetOrder(1))
		SF1->(dbSeek(SZ3->(Z3_FILORIG+Z3_NUMERO+Z3_PREFIXO+Z3_CLIFOR+Z3_LOJA)))
		SD1->(dbSetOrder(1))
		SD1->(dbSeek(SZ3->(Z3_FILORIG+Z3_NUMERO+Z3_PREFIXO+Z3_CLIFOR+Z3_LOJA)))
		
		// Posiciona no título a pagar
		SE2->(dbSetOrder(1))
		SE2->(dbSeek(SZ3->(Z3_FILORIG+Z3_PREFIXO+Z3_NUMERO+Z3_PARCELA+Z3_TIPO+Z3_CLIFOR+Z3_LOJA)))
		
		// Posiciona no fornecedor
		SA2->(dbSetOrder(1))
		SA2->(dbSeek(SZ3->(Z3_FILORIG+Z3_CLIFOR+Z3_LOJA)))
	ElseIf Trim((cAlias2)->Z3_ROTINA) == "GPEM670"
		// Posiciona no colaborador
		CTD->(dbSetOrder(1))
		CTD->(dbSeek(XFILIAL("CTD")+SZ3->Z3_ITEMCTA))
	Endif
	
Return .T.

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CriaHeader ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 05/05/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria a variavel vetor aHeader                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CriaHeader()
	
	// Cria aHeader com os dados dos itens
	SX3->(dbSetOrder(1))
	SX3->(dbSeek(cAlias2,.T.))
	While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == cAlias2
		If Trim(SX3->X3_CAMPO) == "Z3_FILIAL" .Or. X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. AScan(aAcho,SX3->X3_CAMPO) == 0
			aAdd(aHeader,{ Trim(X3Titulo()), ;
								SX3->X3_CAMPO   , ;
								SX3->X3_PICTURE , ;
								SX3->X3_TAMANHO , ;
								SX3->X3_DECIMAL , ;
								SX3->X3_VALID   , ;
								SX3->X3_USADO   , ;
								SX3->X3_TIPO    , ;
								SX3->X3_F3      , ;
								SX3->X3_CONTEXT , ;
								SX3->X3_CBOX    , ;
								SX3->X3_RELACAO } )
		Endif
		SX3->(dbSkip())
	Enddo
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ aColsBlank ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 05/05/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria array de itens em branco                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function aColsBlank(cAlias,aArray,nUsado)
	Local nRet := Len(aArray) + 1
	
	aAdd(aArray,Array(nUsado+1))
	nUsado := 0
	
	// Cria aHeader com os dados dos itens
	SX3->(dbSetOrder(1))
	SX3->(dbSeek(cAlias,.T.))
	While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == cAlias
		
		If Trim(SX3->X3_CAMPO) == "Z3_FILIAL" .Or. X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. AScan(aAcho,SX3->X3_CAMPO) == 0
			nUsado++
			aArray[nRet][nUsado] := CriaVar(Trim(SX3->X3_CAMPO),.T.)
		Endif
		aArray[nRet][nUsado+1] := .F.
		
		SX3->(dbSkip())
	Enddo
	
Return nRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦CarregaRatei¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 08/05/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Exibe tela para digitação do novo rateio                      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CarregaRateio(cOrigem,aItens,oObj,nItem)
	Local nTam, nPos, nX, nY, nZ, nAux, aAux, aTot, aTam, aDesp, nSaldo, aLinha, nIni, nFim
	Local nTotDes := 0
	Local nTotRec := 0
	Local nTotHor := 0
	Local aCampos := {}
	
	Pergunte("FIN050",.F.)  // Carrega as perguntas padrões do financeiro
	mv_par04 := 2    // Não contabiliza
	
	If Trim(cOrigem) == "GPEM670"
		RegToMemory("SE2",.T.,.T.)    // Carrega na memória o conteúdo do título a pagar para compatibilização
		
		If nItem == Nil   // Se item não foi informado
			aEval( aItens , {|x| nTotDes += x[3], nTotRec += x[4], nTotHor += x[5] } )
		Else
			// Atribui os valores do item
			nTotDes := aItens[nItem,3]
			nTotRec := aItens[nItem,4]
			nTotHor := aItens[nItem,5]
		Endif
		
		M->E2_VALOR   := M->E2_SALDO := If( nTotDes > 0 , nTotDes, nTotRec)
		M->E2_FORNECE := CTD->CTD_ITEM
	Endif
	
	Private cLote
	Private nQtdTot := 0   //Utilizado no Rateio Externo do SIGACTB.
	
	F050EscRat("511","FINA050",cLote)   // Exibe tela para seleção do rateio
	
	Pergunte(PADR("INFINA04",Len(SX1->X1_GRUPO)),.F.)   // Restaura as perguntas da rotina
	
	If Select("TMP") == 0 .Or. TMP->(Bof() .And. Eof()) .Or. TMP->(RecCount() == 1 .And. CTJ_VALOR == 0)
		If Select("TMP") > 0
			TMP->(__dbZap())
		Endif
		Return
	Endif
	
	If Trim(cOrigem) $ "FINA050,MATA100"   // Origem do Financeiro ou Compras
		// Carrega os campos que terão conteúdo atualizado pelo rateio selecionado
		AAdd( aCampos , { "Z3_FILIAL" , 0, {|| M->Z3_FILORIG   }})
		AAdd( aCampos , { "Z3_RECPAG" , 0, {|| "P"             }})
		AAdd( aCampos , { "Z3_CONTAB" , 0, {|| TMP->CTJ_DEBITO }})
		AAdd( aCampos , { "Z3_DESCT1" , 0, {|| Posicione("CT1",1,XFILIAL("CT1")+TMP->CTJ_DEBITO,"CT1_DESC01") }})
		AAdd( aCampos , { "Z3_VALOR"  , 0, {|| TMP->CTJ_VALOR  }})
		AAdd( aCampos , { "Z3_CC"     , 0, {|| TMP->CTJ_CCD    }})
		AAdd( aCampos , { "Z3_DESCCC" , 0, {|| Posicione("CTT",1,XFILIAL("CTT")+TMP->CTJ_CCD,"CTT_DESC01") }})
		AAdd( aCampos , { "Z3_ITEMCTA", 0, {|| TMP->CTJ_ITEMD  }})
		AAdd( aCampos , { "Z3_CLVL"   , 0, {|| TMP->CTJ_CLVLDB }})
		AAdd( aCampos , { "Z3_DESCTH" , 0, {|| Posicione("CTH",1,XFILIAL("CTH")+TMP->CTJ_CLVLDB,"CTH_DESC01") }})
		AAdd( aCampos , { "Z3_XTPORH" , 0, {|| Posicione("CT1",1,XFILIAL("CT1")+TMP->CTJ_DEBITO,"CT1_XTPORH") }})
		
		// Carrega os campos que terão o conteúdo padrão da tela gravado
		For nX:=1 To Len(aHeader)
			If AScan( aCampos , {|x| x[1] == Trim(aHeader[nX,2]) } ) == 0
				AAdd( aCampos , { Trim(aHeader[nX,2]), 0, &("{|| "+ConteudoPadrao(Trim(aHeader[nX,2]))+" }") } )
			Endif
		Next
		
		// Pesquisa a posição dos campos na tela
		For nX:=1 To Len(aCampos)
			aCampos[nX,2] := AScan( aHeader , {|y| Trim(y[2]) == aCampos[nX,1] } )
		Next
		
		aCols   := {}
		nTotDes := 0
		nTotRec := 0
		
		// Atualiza os itens com o conteúdo do rateio selecionado
		TMP->(dbGoTop())
		While !TMP->(Eof())
			
			//+--------------
			//| Monta o aCols com uma linha em branco
			//+--------------
			nTam := aColsBlank(cAlias2,@aCols,Len(aHeader))
			
			For nX:=1 To Len(aCampos)
				If aCampos[nX,2] > 0
					aCols[nTam,aCampos[nX,2]] := Eval(aCampos[nX,3])
				Endif
			Next
			
			nTotDes += TMP->CTJ_VALOR
			
			TMP->(dbSkip())
		Enddo
		
		// Atualiza os objetos da tela
		oGet:oBrowse:Refresh()
		oDes:Refresh()
		oRec:Refresh()
		oSal:Refresh()
		oTam:Refresh()
	Else
		If TMP->(RecCount()) > 1   // Se foi selecionado mais de um projeto
			aAux  := {}
			nY    := 1
			aDesp := {}
			aTot  := { 0, 0, 0}
			aTam  := { TamSX3("Z3_VALOR")[2], TamSX3("Z3_VALOR")[2], TamSX3("Z3_VALHOR")[2]}
			
			If nItem == Nil   // Se o item não foi informado
				nIni := 1
				// Elimina todos os itens do array
				ADel(aItens,Len(aItens))
				aSize(aItens,0)   // Redimensiona esvaziando o array
			Else
				cProjeto := aItens[nItem,1]
				nIni := nItem
				// Elimina somente o item posicionado do array
				ADel(aItens,nItem)
				aSize(aItens,Len(aItens)-1)   // Redimensiona com um item a menos
			Endif
			
			// Atualiza os projetos com o conteúdo do rateio selecionado
			TMP->(dbGoTop())
			While !TMP->(Eof())
				
				aLinha := {	TMP->CTJ_CCD,;
								Posicione("CTT",1,XFILIAL("CTT")+TMP->CTJ_CCD,"CTT_DESC01"),;
								If( M->E2_VALOR == nTotDes , TMP->CTJ_VALOR, Round(TMP->CTJ_PERCEN * nTotDes / 100,aTam[1])),;
								If( M->E2_VALOR == nTotRec , TMP->CTJ_VALOR, Round(TMP->CTJ_PERCEN * nTotRec / 100,aTam[2])),;
								Round(TMP->CTJ_PERCEN * nTotHor / 100,aTam[3]),;
								TMP->CTJ_CCD}
										
				If nItem == Nil
					AAdd( aItens , aClone(aLinha) )
					nTam := Len(aItens)
				Else
					ASize( aItens , Len(aItens) + 1 )   // Aumenta o tamanho do vetor
					AIns( aItens , nItem )   // Insere um novo elemento na posição do antigo elemento
					nTam := nItem    // Ajusta posição onde será adicionado o novo elemento
					aItens[nTam] := aClone(aLinha)   // Atribui o novo elemento
					nItem++         // Anda a posição para inserir na ordem correta
				Endif
				
				aTot[1] += aItens[nTam,3]
				aTot[2] += aItens[nTam,4]
				aTot[3] += aItens[nTam,5]
				
				TMP->(dbSkip())
			Enddo
			
			nFim := nTam  // Atribui a última posição adicionada ao array
			
			// Ajusta a diferença de centavos no último item adicionado
			aItens[nTam,3] += nTotDes - aTot[1]
			aItens[nTam,4] += nTotRec - aTot[2]
			aItens[nTam,5] += nTotHor - aTot[3]
			
			// Retira todas as despesas vinculadas aos projetos
			While nY <= Len(aProjeto)
				// Caso o projeto pertença ao colaborador e seja o mesmo projeto selecionado
				If aProjeto[nY,1] == cColaborador .And. (nItem == Nil .Or. aProjeto[nY,2] == cProjeto)
					For nX:=1 To Len(aProjeto[nY,3])
						AAdd( aDesp , aClone(aProjeto[nY,3][nX]) )
					Next
					
					// Elimina o item do colaborador pois o mesmo será reconfigurado abaixo
					aDel(aProjeto,nY)
					aSize(aProjeto,Len(aProjeto)-1)
					nY--  // Retroage a posição para não perder o próximo item
				Endif
				nY++
			Enddo
			
			// Processa a redistribuição das despesas (3) e receitas (4) entre os novos projetos selecionados
			For nZ:=3 To 4
				nY := 1
				For nX:=nIni To nFim
					If aItens[nX,nZ] > 0    // Se existir saldo
						nSaldo := aItens[nX,nZ]
						
						// Adiciona o novo projeto para o colaborador
						If (nTam := AScan( aProjeto , {|x| x[1]+x[2] == cColaborador+aItens[nX,1] } )) == 0
							AAdd( aProjeto , { cColaborador, aItens[nX,1], {}} )
							nTam := Len(aProjeto)
						Endif
						
						// Caso o valor da despesa seja menor que o valor (total) do projeto, então essa despesas será agregada a esse projeto
						While nY <= Len(aDesp) .And. aDesp[nY,nZ+2] <= nSaldo
							If aDesp[nY,nZ+2] > 0
								aDesp[nY,10] := .T.        // Define como novo registro
								AAdd( aProjeto[nTam,3] , aClone(aDesp[nY]) )
								nSaldo -= aDesp[nY,nZ+2]   // Abate o saldo do projeto atual
							Endif
							nY++   // Avança para a próxima despesa
						Enddo
						
						// Caso ainda tenha saldo, agrega o restante ao projeto e despesas atuais
						If nSaldo > 0 .And. nY <= Len(aDesp)
							nAux := aDesp[nY,nZ+2]     // Salva o valor atual da despesa
							aDesp[nY,nZ+2] := nSaldo   // Como o valor da despesa é maior que o saldo, atualiza então o saldo para o item
							aDesp[nY,10]   := .T.      // Define como novo registro
							AAdd( aProjeto[nTam,3] , aClone(aDesp[nY]) )
							aDesp[nY,nZ+2] := nAux - nSaldo   // Atualiza o valor da despesa com a diferença do valor anterior pelo saldo
						Endif
					Endif
				Next
			Next
		Else
			If (nTam := AScan( aProjeto , {|x| x[1]+x[2] == cColaborador+aItens[nItem,6] } )) > 0
				aProjeto[nTam,2] := TMP->CTJ_CCD
				If nItem == Nil   // Se o item não foi informado
					aEval( aItens , {|x| x[1] := x[6] := TMP->CTJ_CCD } )
				Else
					aItens[nItem,1] := aItens[nItem,6] := TMP->CTJ_CCD
				Endif
			Endif
		Endif
		
		oObj:Refresh()
	Endif
	
	TMP->(__dbZap())
	
	lAlterou := .T.   // Ajusta o status do documento para Alterado
	
	MsgInfo("Rateio atualizado com sucesso !")
	
Return

Static Function ConteudoPadrao(cCampo)
	Local nX, nPos
	Local nPC  := AScan( aHeader , {|x| Trim(x[2]) == cCampo } )
	Local aRep := {}
	Local cRet := ""
	
	// Calcula o conteúdo que tem mais ocorrência para o campo e o define como o conteúdo de todos os itens recriados
	If nPC > 0 .And. !Empty(aCols)
		For nX:=1 To Len(aCols)
			nPos := AScan( aRep , {|x| x[1] == aCols[nX,nPC] } )
			If nPos == 0
				AAdd( aRep , { aCols[nX,nPC], 0})
				nPos := Len(aRep)
			Endif
			aRep[nPos,2]++
		Next
		
		ASort(aRep,,,{|x,y| x[2] > y[2] .And. x[1] < y[1] } )
		
		cRet := aRep[1,1]
		
		If ValType(cRet) == "D"
			cRet := "Ctod('"+Dtoc(cRet)+"')"
		ElseIf ValType(cRet) == "N"
			cRet := LTrim(Str(cRet,10,2))
		Else
			cRet := "'"+cRet+"'"
		Endif
	Endif
	
Return cRet

Static Function Justificativa()
	Local oDlg, oJustific, oPanel1, nLin
	Local cJustific := cJustif
	Local oFontCou  := TFont():New("Courier New",9,15,.T.,.F.,5,.T.,5,.F.,.F.)   
	Local nTamDoc   := TamSX3("E2_NUM")[1]
	
	If Trim((cAlias2)->Z3_ROTINA) <> "GPEM670"
		If Empty(cJustific)
			If Trim((cAlias2)->Z3_ROTINA) == "FINA050"
				cJustific := (cAlias2)->(u_INObjJust(Z3_FILORIG,"4",Z3_NUMERO+Z3_PREFIXO+Z3_CLIFOR+Z3_LOJA,.F.))
			Else
				If !Empty(SD1->D1_PRCOMP)
					cJustific := u_INObjJust((cAlias2)->Z3_FILORIG,"1",PADR(SD1->D1_PRCOMP,nTamDoc),.F.)
				Else
					cJustific := u_INObjJust((cAlias2)->Z3_FILORIG,"4",SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM),.F.)
					If Empty(cJustific)
						cJustific := u_INObjJust((cAlias2)->Z3_FILORIG,"4",SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+Space(Len(D1_ITEM))),.F.)
					Endif
				Endif
			Endif
		Endif
		
		DEFINE MSDIALOG oDlg TITLE cCadastro+" - Descrição Detalhada" From 0,0 TO 34,81 OF oMainWnd
		oDlg:lEscClose := .F.

		//DADOS DO TITULO
		oPanel1 := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,10,225,.f.,.f. )
		oPanel1:Align := CONTROL_ALIGN_BOTTOM
		
		@ 05,006 SAY "Prefixo"      PIXEL OF oPanel1
		@ 05,036 GET M->E2_PREFIXO  PIXEL OF oPanel1 WHEN .F.
		@ 05,106 SAY "Numero"       PIXEL OF oPanel1
		@ 05,136 GET M->E2_NUM      PIXEL OF oPanel1 WHEN .F.
		@ 20,006 SAY "Fornecedor"   PIXEL OF oPanel1
		@ 20,036 GET M->E2_FORNECE  PIXEL OF oPanel1 WHEN .F.
		@ 20,076 GET M->E2_LOJA     PIXEL OF oPanel1 WHEN .F.
		@ 20,106 SAY "Nome"         PIXEL OF oPanel1
		@ 20,136 GET M->E2_NOMFOR   PIXEL OF oPanel1 WHEN .F.
				
		nLin := 40
		@ nLin,002 To nLin+180,318 PROMPT "Descrição Detalhada" PIXEL OF oPanel1
		@ nLin+9,006 SAY "Justificativa" PIXEL OF oPanel1
		
		If Inclui .Or. Altera
			@ nLin+19,006 GET oJustific       VAR cJustific SIZE 308,155 PIXEL OF oPanel1 MEMO
		Else
			@ nLin+19,006 GET oJustific       VAR cJustific SIZE 308,155 PIXEL OF oPanel1 MEMO READONLY
		Endif
		
		oJustific:oFont := oFontCou
		
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| If(Inclui.Or.Altera,(cJustif:=cJustific,lAlterou:=.T.),), oDlg:End() }, {|| oDlg:End() })
	Else
		MsgAlert("Não existe justificativa para despesas com origem do RH !")
	Endif
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦FIN04DespRH ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 20/05/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Manutenção das despesas do MCT - RH                           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FIN04DespRH(cAlias, nRecNo, nOpc )
	Local oFunc, aFunc, oDlg, cQry, nX, nY, nZ, nPos, aTotal, nR
	Local cPerg  := PADR("INFINA04",Len(SX1->X1_GRUPO))
	Local aCabec := {"Colaborador","Nome"}
	Local bExibe := {|a,b| ExibeColabor(a,@b) }
	Local aCopia := {}
	Local nTam   := SZ3->(FCount())
	
	Private cColaborador, cProjeto, xCampo1, xCampo2, xCampo3, oRateio
	Private aColabor := {}
	Private aProjeto := {}
	
	Valid1Perg(cPerg)
	If Pergunte(cPerg,.T.)
		xCampo1 := mv_par01
		xCampo2 := mv_par02
		xCampo3 := 0
		
		MsgRun("Aguarde. Filtrando registros...","",{|| aFunc := QryDespesaRH() })
		
		If ShowListBox(aFunc,{"Data de","Data até"},aCabec,bExibe,.F.,{||.T.})
			Begin Transaction
			
			For nX:=1 To Len(aColabor)
				// Totaliza por projeto, caso tenha se repetido o mesmo projeto após a alteração
				aTotal := {}
				For nY:=1 To Len(aColabor[nX,2])
					// Pesquisa por Colaborador + Projeto (lido)
					nPos := AScan( aProjeto , {|x| x[1]+x[2] == aColabor[nX,1]+aColabor[nX,2][nY,6] } )
					If nPos > 0
						nPos := AScan( aTotal , {|x| x[1] == aColabor[nX,2][nY,6] } )
						If nPos == 0
							AAdd( aTotal , { aColabor[nX,2][nY,6], 0} )
							nPos := Len(aTotal)
						Endif
						aTotal[nPos,2] += aColabor[nX,2][nY,5]
					Endif
				Next
				
				For nY:=1 To Len(aColabor[nX,2])
					nPos := AScan( aProjeto , {|x| x[1]+x[2] == aColabor[nX,1]+aColabor[nX,2][nY,1] } )
					If nPos > 0
						For nZ:=1 To Len(aProjeto[nPos,3])
							SZ3->(dbGoTo(aProjeto[nPos,3][nZ,8]))
							
							If aProjeto[nPos,3][nZ,10]   // Se é um novo registro
								If (nReg := AScan( aCopia , {|x| x[nTam+1] == aProjeto[nPos,3][nZ,8] } )) == 0   // Caso não tenha encontrado o registro no vetor
									// Efetua uma cópia do regitro para gravar os novos registros
									AAdd( aCopia , {} )
									nReg := Len(aCopia)
									For nR:=1 To nTam
										AAdd( aCopia[nReg] , SZ3->(FieldGet(nR)) )
									Next
									AAdd( aCopia[nReg] , SZ3->(Recno()) )
									
									// Exclui o registro usado para a cópia
									RecLock("SZ3",.F.)
									dbDelete()
									MsUnLock()
								Endif
								
								// Atualiza os campos do novo registro
								RecLock("SZ3",.T.)
								For nR:=1 To nTam
									FieldPut( nR , aCopia[nReg,nR] )
								Next
							Else
								RecLock("SZ3",.F.)
							Endif
							SZ3->Z3_CC     := aColabor[nX,2][nY,6]
							SZ3->Z3_DESCCC := aColabor[nX,2][nY,2]
							SZ3->Z3_ATIVO  := If( aProjeto[nPos,3][nZ,9] , "S", "N")
							SZ3->Z3_VALHOR := aTotal[AScan(aTotal,{|x|x[1]==aColabor[nX,2][nY,6]}),2]  //aColabor[nX,2][nY,5]
							
							If SZ3->Z3_RECPAG == "P"
								SZ3->Z3_VALOR := aProjeto[nPos,3][nZ,5]    // Valor da Despesa
							Else
								SZ3->Z3_VALOR := aProjeto[nPos,3][nZ,6]    // Valor da Receita
							Endif
							MsUnLock()
						Next
					Endif
				Next
			Next
			
			End Transaction
		Endif
	Endif
	
Return

Static Function ExibeColabor(aLinha,aTitulo)
	Local aProj, nPos, nX, nY, aAux
	Local aCabec := {"Projeto","Descrição"}
	Local bExibe := {|a,b| ExibeProjeto(a,b) }
	Local bValid := {|nHoras| nHoras == 180 .Or. MsgYesNo("O total não está batendo 180h, confirma assim mesmo?") }
	Local xBack1 := xCampo1
	Local xBack2 := xCampo2
	Local xBack3 := xCampo3
	
	Private aBack := {}
	
	cColaborador := aLinha[1]
	
	// Atualiza os dados a serem exibidos em tela
	xCampo1 := aLinha[6]           // Matricula do colaborador
	xCampo2 := PADR(aLinha[2],30)  // Nome do colaborador
	xCampo3 := aLinha[5]           // Horas do colaborador
	
	If (nPos := AScan( aColabor , {|x| x[1] == cColaborador } )) == 0
		AAdd( aColabor , { cColaborador, {}} )
		nPos := Len(aColabor)
		
		MsgRun("Aguarde. Filtrando registros...","",{|| aProj := QryDespesaRH(cColaborador) })
		
		For nX:=1 To Len(aProj)
			MsgRun("Aguarde. Filtrando registros...","",{|| aAux := QryDespesaRH(cColaborador,aProj[nX,1]) })
			
			AAdd( aProjeto , { cColaborador, aProj[nX,1], aClone(aAux)} )  // Atualiza o vetor de projetos por colaborador
		Next
		
		aColabor[nPos,2] := aClone(aProj)   // Salva os projetos aglutinados do colaborador
	Else
		aProj := aClone(aColabor[nPos,2])   // Restaura os projetos aglutinados do colaborador para manutenção
	Endif
	
	aBack := aClone(aProjeto)   // Salva a variável antes da alteração
	
	If ShowListBox(@aProj,aTitulo,aCabec,bExibe,.T.,bValid)
		aColabor[nPos,2] := aClone(aProj)   // Salva os projetos aglutinados após manutenção
		ValRefresh(aProj,@aLinha[3],@aLinha[4],@aLinha[5])
	Else
		aProjeto := aClone(aBack)   // Restaura o backup do aProjetos
	Endif
	
	// Restaura os dados exibidos em tela anterior
	xCampo1 := xBack1
	xCampo2 := xBack2
	xCampo3 := xBack3
Return

Static Function ExibeProjeto(aLinha,aTitulo)
	Local oScreen, oLbx, cLbx, nPos, oDes, oRec, oChk, aSize, aPosObj
	Local aLine    := {}
	Local nTotDes  := 0
	Local nTotRec  := 0
	Local xBack1   := xCampo1
	Local xBack2   := xCampo2
	Local xBack3   := xCampo3
	Local oSim     := LoadBitmap( GetResources(), "BR_VERDE" )
	Local oNao     := LoadBitmap( GetResources(), "BR_VERMELHO" )
	Local lCheck   := .F.
	Local nOpcA    := 0
	Local aButtons := {}
	
	cProjeto := aLinha[1]
	
	// Atualiza os dados a serem exibidos em tela
	xCampo1 := aLinha[6]   // Codigo do Projeto
	xCampo2 := aLinha[2]   // Descrição do Projeto
	xCampo3 := aLinha[5]   // Horas do Projeto
	
	If (nPos := AScan( aProjeto , {|x| x[1]+x[2] == cColaborador+cProjeto } )) == 0
		AAdd( aProjeto , { cColaborador, cProjeto, {}} )
		nPos := Len(aProjeto)
		
		MsgRun("Aguarde. Filtrando registros...","",{|| aLine := QryDespesaRH(cColaborador,cProjeto) })
		
		aProjeto[nPos,3] := aClone(aLine)
	Else
		aLine := aClone(aProjeto[nPos,3])
	Endif
	
	If !Empty(aLine)
		
		aEval( aLine , {|x| nTotDes += If( x[9] , x[5], 0), nTotRec += If( x[9] , x[6], 0), lCheck := If( lCheck , .T., x[9]) } )
		
		//+----------------------------------
		//| Inicia as posições dos objetos
		//+----------------------------------
		PosObjetos(@aSize,@aPosObj,{{20,.F.},{100,.T.},{10,.F.}})
		
		AAdd( aButtons,{"EXCEL" ,{|| GeraExcel(oLbx:aHeaders,oLbx:aArray)  },"Exporta Excel"})
		
		DEFINE MSDIALOG oScreen TITLE "Despesas de RH" FROM aSize[7],0 TO aSize[6],aSize[5] PIXEL OF oMainWnd
				
		@ aPosObj[1,1]+02,aPosObj[1,2]+005 SAY aTitulo[1]  PIXEL OF oScreen
		@ aPosObj[1,1]+00,aPosObj[1,2]+030 MSGET xCampo1  F3 "CTT" VALID ValidCTT() PIXEL OF oScreen
		@ aPosObj[1,1]+02,aPosObj[1,2]+095 SAY aTitulo[2]  PIXEL OF oScreen
		@ aPosObj[1,1]+00,aPosObj[1,2]+130 MSGET xCampo2   PIXEL OF oScreen WHEN .F.
		
		@ aPosObj[1,1]+02,aPosObj[1,2]+395 SAY "Horas"  PIXEL OF oScreen
		@ aPosObj[1,1]+00,aPosObj[1,2]+420 MSGET xCampo3 Picture "@E 99999.99"  VALID Positivo() PIXEL OF oScreen
		
		@ aPosObj[2,1],aPosObj[2,2] LISTBOX oLbx VAR cLbx Fields HEADER "","Data","Conta","Beneficiário","Filial","Despesa","Receita" ;
		SIZE aPosObj[2,4],aPosObj[2,3] - aPosObj[2,1] OF oScreen PIXEL
		
		oLbx:SetArray(aLine)
		oLbx:bLine := {||{Iif( aLine[oLbx:nAt,9],oSim,oNao),;
								aLine[oLbx:nAt,1],;
								aLine[oLbx:nAt,2],;
								aLine[oLbx:nAt,3],;
								aLine[oLbx:nAt,4],;
								Transform(aLine[oLbx:nAt,5],"@E 999,999,999.99"),;
								Transform(aLine[oLbx:nAt,6],"@E 999,999,999.99")}}
		oLbx:bLDblClick := {|| aLine[oLbx:nAt][9] := !aLine[oLbx:nAt][9],;
										nTotDes += aLine[oLbx:nAt][5] * If( aLine[oLbx:nAt][9] , 1, -1),;
										nTotRec += aLine[oLbx:nAt][6] * If( aLine[oLbx:nAt][9] , 1, -1),;
										oDes:Refresh(), oRec:Refresh() }
		
		@ aPosObj[3,1],aPosObj[3,2] CHECKBOX oChk VAR lCheck PROMPT "Apagar / Recuperar" ON ;
										CLICK (Marcacao(lCheck,@aLine,@oLbx),;
										nTotDes := 0, nTotRec := 0,;
										aEval( aLine , {|x| nTotDes += If( x[9] , x[5], 0), nTotRec += If( x[9] , x[6], 0) } ),;
										oDes:Refresh(), oRec:Refresh()) PIXEL OF oScreen SIZE 100,08
		@ aPosObj[3,1]+00,aPosObj[3,2]+110 SAY "Total de Despesas" PIXEL OF oScreen COLOR CLR_HBLUE
		@ aPosObj[3,1]+00,aPosObj[3,2]+160 SAY oDes VAR nTotDes Picture "@E 999,999,999.99" PIXEL OF oScreen COLOR CLR_HRED
		@ aPosObj[3,1]+00,aPosObj[3,2]+310 SAY "Total de Receitas" PIXEL OF oScreen COLOR CLR_HBLUE
		@ aPosObj[3,1]+00,aPosObj[3,2]+360 SAY oRec VAR nTotRec Picture "@E 999,999,999.99" PIXEL OF oScreen COLOR CLR_HRED
		
		ACTIVATE MSDIALOG oScreen CENTERED ON INIT EnchoiceBar(oScreen, {|| nOpcA := 1, oScreen:End() }, {|| nOpcA:=0, oScreen:End() },,aButtons )
		
		If nOpcA == 1
			// Salva o novo projeto
			aLinha[6] := xCampo1   // Código do Projeto
			aLinha[2] := xCampo2   // Descrição do Projeto
			aLinha[5] := xCampo3   // Horas do Projeto
			aLinha[3] := nTotDes   // Total de despesas
			aLinha[4] := nTotRec   // Total de receitas
			aProjeto[nPos,3] := aClone(aLine)   // Salva as novas configurações do projeto
		Endif
	Endif
	
	// Restaura os dados exibidos em tela anterior
	xCampo1 := xBack1
	xCampo2 := xBack2
	xCampo3 := xBack3
	
Return nOpcA == 1

Static Function Marcacao(lCheck,aItem,oItem)
	aEval( aItem , {|x| x[9] := lCheck })
	oItem:Refresh()
Return .T.

Static Function ShowListBox(aLine,aTitulo,aCampos,bBlock,lHoras,bValid)
	Local oScreen, oLbx, cLbx, oDes, oRec, oHor, nTotDes, nTotRec, nTotHor, aSize, aPosObj
	Local nOpcA    := 0
	Local aButtons := {}
	
	If !Empty(aLine)
		
		ValRefresh(aLine,@nTotDes,@nTotRec,@nTotHor,@oDes,@oRec,@oHor)
		
		//+----------------------------------
		//| Inicia as posições dos objetos
		//+----------------------------------
		PosObjetos(@aSize,@aPosObj,{{20,.F.},{100,.T.},{10,.F.}})
		
		AAdd( aButtons,{"EXCEL" ,{|| GeraExcel(oLbx:aHeaders,oLbx:aArray)  },"Exporta Excel"})
		
		DEFINE MSDIALOG oScreen TITLE "Despesas de RH" FROM aSize[7],0 TO aSize[6],aSize[5] PIXEL OF oMainWnd
				
		@ aPosObj[1,1]+02,aPosObj[1,2]+005 SAY aTitulo[1]  PIXEL OF oScreen
		@ aPosObj[1,1]+00,aPosObj[1,2]+005+(Len(AllTrim(aTitulo[1]))*5) MSGET xCampo1   PIXEL OF oScreen WHEN .F.
		@ aPosObj[1,1]+02,aPosObj[1,2]+125 SAY aTitulo[2]  PIXEL OF oScreen
		@ aPosObj[1,1]+00,aPosObj[1,2]+125+(Len(AllTrim(aTitulo[2]))*5) MSGET xCampo2   PIXEL OF oScreen WHEN .F.
		
		@ aPosObj[2,1],aPosObj[2,2] LISTBOX oLbx VAR cLbx Fields HEADER aCampos[1],aCampos[2],"Despesas","Receitas","Horas" ;
		SIZE aPosObj[2,4],aPosObj[2,3] - aPosObj[2,1];
		OF oScreen PIXEL ON DBLCLICK(Eval(bBlock,@aLine[oLbx:nAt],aCampos),ValRefresh(aLine,@nTotDes,@nTotRec,@nTotHor,@oDes,@oRec,@oHor))
		
		oLbx:SetArray(aLine)
		oLbx:bLine := {||{aLine[oLbx:nAt,6],;
								aLine[oLbx:nAt,2],;
								Transform(aLine[oLbx:nAt,3],"@E 999,999,999.99"),;
								Transform(aLine[oLbx:nAt,4],"@E 999,999,999.99"),;
								Transform(aLine[oLbx:nAt,5],"@E 99999.99")}}
		
		@ aPosObj[3,1]+00,aPosObj[3,2]+110 SAY "Total de Despesas" PIXEL OF oScreen COLOR CLR_HBLUE
		@ aPosObj[3,1]+00,aPosObj[3,2]+160 SAY oDes VAR nTotDes Picture "@E 999,999,999.99" PIXEL OF oScreen COLOR CLR_HRED
		@ aPosObj[3,1]+00,aPosObj[3,2]+310 SAY "Total de Receitas" PIXEL OF oScreen COLOR CLR_HBLUE
		@ aPosObj[3,1]+00,aPosObj[3,2]+360 SAY oRec VAR nTotRec Picture "@E 999,999,999.99" PIXEL OF oScreen COLOR CLR_HRED
		
		If lHoras
			@ aPosObj[1,1]+02,aPosObj[1,2]+410 Button oRateio Prompt "&Rateio" SIZE 60,15 ACTION;
															(CarregaRateio("GPEM670",@aLine,@oLbx,oLbx:nAt),oLbx:SetFocus()) PIXEL OF oScreen
			
			@ aPosObj[3,1]+00,aPosObj[3,2]+510 SAY "Total de Horas" PIXEL OF oScreen COLOR CLR_HBLUE
			@ aPosObj[3,1]+00,aPosObj[3,2]+560 SAY oHor VAR nTotHor Picture "@E 99999.99" PIXEL OF oScreen COLOR CLR_HRED
		Endif
		
		ACTIVATE MSDIALOG oScreen CENTERED ON INIT EnchoiceBar(oScreen,{|| If(Eval(bValid,nTotHor),(nOpcA:=1, oScreen:End()),) },;
																							{|| nOpcA:=0, oScreen:End() },,aButtons )
	Endif
	
Return nOpcA == 1

Static Function ValRefresh(aLine,nTotDes,nTotRec,nTotHor,oDes,oRec,oHor)
	nTotDes := 0
	nTotRec := 0
	nTotHor := 0
	
	aEval( aLine , {|x| nTotDes += x[3], nTotRec += x[4], nTotHor += x[5] } )
	
	If oDes <> Nil
		oDes:Refresh()
	Endif
	If oRec <> Nil
		oRec:Refresh()
	Endif
	If oHor <> Nil
		oHor:Refresh()
	Endif
	
Return

Static Function ValidCTT()
	Local lRet := ExistCpo("CTT")
	
	If lRet
		xCampo2 := Posicione("CTT",1,XFILIAL("CTT")+xCampo1,"CTT_DESC01")
	Endif
	
Return lRet

Static Function QryDespesaRH(cItemD,cCC)
	Local nX, nTam
	Local dIni   := LastDay(mv_par01)
	Local nMeses := 1
	Local cQry   := "SELECT "
	Local cTab   := GetNextAlias()
	Local aRet   := {}
	
	// Calcula a quantidade de meses
	While dIni < LastDay(mv_par02)
		nMeses++
		dIni := LastDay(dIni + 1)
	Enddo
	
	cNivel := If( cNivel == Nil , "I", cNivel)
	
	If cItemD == Nil   // Caso não tenha sido informado o item contábil, agrupa por ITEM
		cQry += "SZ3.Z3_ITEMCTA, CTD.CTD_DESC01,"
		cQry += " SUM(CASE WHEN SZ3.Z3_RECPAG = 'P' AND SZ3.Z3_ATIVO <> 'N' THEN SZ3.Z3_VALOR ELSE 0 END) AS Z3_VALPAG,"
		cQry += " SUM(CASE WHEN SZ3.Z3_RECPAG = 'R' AND SZ3.Z3_ATIVO <> 'N' THEN SZ3.Z3_VALOR ELSE 0 END) AS Z3_VALREC,"
		cQry += " (SELECT SUM(TMP.Z3_VALHOR) AS Z3_VALHOR"
		cQry += "  FROM (SELECT TMP.Z3_CC, AVG(TMP.Z3_VALHOR) AS Z3_VALHOR"
		cQry += cFiltroSZ3("TMP")
		cQry += " AND TMP.Z3_ATIVO <> 'N'"
		cQry += " AND TMP.Z3_ITEMCTA = SZ3.Z3_ITEMCTA"
		cQry += " GROUP BY TMP.Z3_CC) TMP) AS Z3_VALHOR"
	ElseIf cCC == Nil   // Caso não tenha sido informado o centro de custo, agrupa por CC
		cQry += "SZ3.Z3_CC, SZ3.Z3_DESCCC,"
		cQry += " SUM(CASE WHEN SZ3.Z3_RECPAG = 'P' AND SZ3.Z3_ATIVO <> 'N' THEN SZ3.Z3_VALOR ELSE 0 END) AS Z3_VALPAG,"
		cQry += " SUM(CASE WHEN SZ3.Z3_RECPAG = 'R' AND SZ3.Z3_ATIVO <> 'N' THEN SZ3.Z3_VALOR ELSE 0 END) AS Z3_VALREC,"
		cQry += " AVG(SZ3.Z3_VALHOR) AS Z3_VALHOR"
	Else
		cQry += "SZ3.*, SZ3.R_E_C_N_O_ AS Z3_RECNO"
	Endif
	
	cQry += cFiltroSZ3("SZ3",cItemD,cCC)
	
	If cItemD == Nil   // Caso não tenha sido informado o item contábil, agrupa por ITEM + CC
		cQry += " GROUP BY SZ3.Z3_ITEMCTA, CTD.CTD_DESC01"
		cQry += " ORDER BY SZ3.Z3_ITEMCTA"
	ElseIf cCC == Nil   // Caso não tenha sido informado o centro de custo, agrupa por CC
		cQry += " GROUP BY SZ3.Z3_CC, SZ3.Z3_DESCCC"
		cQry += " ORDER BY SZ3.Z3_CC"
	Else
		cQry += " ORDER BY SZ3.Z3_ITEMCTA, SZ3.Z3_CC, SZ3.Z3_DTDISPO"
	Endif
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), cTab, .T., .F. )
	
	If !(cTab)->(Bof() .And. Eof())
		(cTab)->(dbGoTop())
		While !(cTab)->(Eof())
			
			If cItemD == Nil   // Caso não tenha sido informado o item contábil
				AAdd( aRet , (cTab)->({ Z3_ITEMCTA, CTD_DESC01, Z3_VALPAG, Z3_VALREC, StaticCall(INFINP07,CalcTempo,Z3_ITEMCTA,,nMeses,Z3_VALHOR), Z3_ITEMCTA}) )
			ElseIf cCC == Nil   // Caso não tenha sido informado o centro de custo
				AAdd( aRet , (cTab)->({ Z3_CC, Z3_DESCCC, Z3_VALPAG, Z3_VALREC, StaticCall(INFINP07,CalcTempo,cItemD,Z3_CC,nMeses,Z3_VALHOR), Z3_CC}) )
			Else
				AAdd( aRet , (cTab)->({ Stod(Z3_DTDISPO), Z3_DESCT1, PADR(Z3_BENEF,30), U_NomeFilial(Z3_FILIAL),;
									If( Z3_RECPAG == "P" ,  Z3_VALOR, 0), If( Z3_RECPAG == "R" ,  Z3_VALOR, 0), Z3_MANUAL, Z3_RECNO, Z3_ATIVO<>"N", .F.}) )
			Endif
			
			(cTab)->(dbSkip())
		Enddo
	Else
		Alert("Não foram encontrados registros para o período informado!")
	Endif
	(cTab)->(dbCloseArea())
	
Return aRet

Static Function cFiltroSZ3(cAlias,cItemD,cCC)
	Local cQry
	
	cAlias := If( cAlias == Nil , "SZ3", cAlias)
	
	cQry := " FROM "+RetSQLName("SZ3")+" "+cAlias
	cQry += " LEFT OUTER JOIN "+RetSQLName("CTD")+" CTD ON CTD.D_E_L_E_T_ = ' ' AND CTD_ITEM = "+cAlias+".Z3_ITEMCTA"
	cQry += " WHERE "+cAlias+".D_E_L_E_T_ = ' '"
	cQry += " AND "+cAlias+".Z3_CLVL = '001'"
	cQry += " AND "+cAlias+".Z3_DTDISPO >= '"+Dtos(mv_par01)+"'"
	cQry += " AND "+cAlias+".Z3_DTDISPO <= '"+Dtos(mv_par02)+"'"
	cQry += " AND "+cAlias+".Z3_CC >= '"+mv_par03+"'"
	cQry += " AND "+cAlias+".Z3_CC <= '"+mv_par04+"'"
	cQry += " AND "+cAlias+".Z3_FILIAL >= '"+mv_par05+"'"
	cQry += " AND "+cAlias+".Z3_FILIAL <= '"+mv_par06+"'"
	
	If cItemD <> Nil   // Caso tenha sido informado o item contábil, filtra por esse campo
		cQry += " AND "+cAlias+".Z3_ITEMCTA = '"+cItemD+"'"
	Endif
	If cCC <> Nil   // Caso tenha sido informado o centro de custo, filtra por esse campo
		cQry += " AND "+cAlias+".Z3_CC = '"+cCC+"'"
	Endif
	
Return cQry

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ GeraExcel  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 08/06/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Exporta os dados da tela para planilha em excel               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function GeraExcel(aCab,aItens)
	Local nX, nY, cFile, nHdl, cPath
	Local nQuant := Len(aCab)
	
	If ApOleClient( 'MsExcel' ) .And. MsgYesNo("Confirma a geração dos dados em Excel ?")  //Verifica se o Excel esta instalado
		cFile := GetNextAlias() + ".csv"
		
		If File(cFile)
			FErase(cFile)
		Endif
		
		nHdl := FCreate(cFile)   // Cria o arquivo CSV
		
		FWrite(nHdl, MontaLinha(aCab,nQuant) )   // Grava os dados do cabeçalho

		aEval( aItens , {|x| FWrite(nHdl, MontaLinha(x,nQuant) ) } )   // Grava os dados dos itens
		
		FClose(nHdl)   // Fecha o arquivo excel
		
		cPath := GetTempPath()
		
		If File(cPath+cFile)
			FErase(cPath+cFile)
		Endif
		
		CpyS2T(cFile, cPath, .T.)
		
		oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
		oExcelApp:WorkBooks:Open(cPath+StrTran(cFile,"\",""))
		oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.
		oExcelApp:Destroy()
	Endif
	
Return

Static Function MontaLinha(aItens,nQuant)
	Local nCnt := 0
	Local cRet := ""
	
	aEval( aItens , {|x| nCnt++, If(nCnt<=nQuant,cRet += If( Empty(cRet) , "", ";") + ConvValor(x), ) } )
	
Return cRet + Chr(13) + Chr(10)

Static Function ConvValor(xValor)
	Local cRet := ""
	
	Do Case
		Case ValType(xValor) == "N" ; cRet := LTrim(Str(xValor,10,2))
		Case ValType(xValor) == "D" ; cRet := Dtoc(xValor)
		Case ValType(xValor) == "C" ; cRet := AllTrim(xValor)
	EndCase
	
Return cRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PosObjetos ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 05/05/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Inicializa as dimensões da tela para posicionar os objetos    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PosObjetos(aSize,aPosObj,aDiv)
	Local aInfo
	Local aObjects := {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	aEval( aDiv , {|x| AAdd( aObjects, { 100, x[1], .t., x[2] } ) } )
	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦FIN04AltPrj ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 28/09/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Processa a alteração do projeto na base MCT                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FIN04AltPrj()
	Local cCadastro := OemtoAnsi("Alteração de Projeto da Base Paralela MCT")
	Local aSays     := {}
	Local aButtons  := {}
	Local nOpca     := 0
	Local cPerg     := Padr("FIN04PRJ",Len(SX1->X1_GRUPO) )
	
	Valid2Perg(cPerg)
	Pergunte(cPerg,.F.)
	
	AADD(aSays,OemToAnsi("Esta rotina irá alterar o projeto de todos os registros da base") )
	AADD(aSays,OemToAnsi("paralela MCT conforme filtro e projeto definido nos parâmetros.") )
	
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) }})
	AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }})
	AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )
	
	FormBatch( cCadastro, aSays, aButtons )
	
	If nOpca == 1
		Processa({|| AlteraProj() },"Processando alteração")
	EndIf
	
Return

Static Function AlteraProj()
	Local cQry, nRegs
	
	If NaoVazio(mv_par08) .And. ExistCpo("CTT",mv_par08)
		cQry := " FROM "+RetSQLTab("SZ3")
		cQry += " WHERE D_E_L_E_T_ = ' '"
		cQry += " AND SZ3.Z3_FILIAL >= '"+mv_par01+"'"
		cQry += " AND SZ3.Z3_FILIAL <= '"+mv_par02+"'"
		cQry += " AND SZ3.Z3_DTDISPO >= '"+Dtos(mv_par03)+"'"
		cQry += " AND SZ3.Z3_DTDISPO <= '"+Dtos(mv_par04)+"'"
		cQry += " AND SZ3.Z3_CLVL >= '"+mv_par05+"'"
		cQry += " AND SZ3.Z3_CLVL <= '"+mv_par06+"'"
		cQry += " AND SZ3.Z3_CC = '"+mv_par07+"'"
		cQry += " AND SZ3.Z3_REGBLQ NOT IN ('3','4')"
		
		dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery("SELECT COUNT(*) AS TOTREG"+cQry)), "TMPSZ3", .T., .F. )
		nRegs := TMPSZ3->TOTREG
		dbCloseArea()
		
		If nRegs > 0
			// Posiciona no centro de custo
			CTT->(dbSetOrder(1))
			CTT->(dbSeek(XFILIAL("CTT")+mv_par08))
			
			cQry := "UPDATE SZ3 SET SZ3.Z3_CC = '"+mv_par08+"', SZ3.Z3_DESCCC = '"+CTT->CTT_DESC01+"'" + cQry
			
			If TCSQLExec(cQry) < 0
				Alert("Ocorreu um erro na gravação da tabela SZ3: TCSQLError() - " + TCSQLError())
			Else
				MsgInfo("Alteração realizado com sucesso!"+Chr(13)+Chr(13)+"Total de registro(s) atualizado(s): "+LTrim(Str(nRegs)))
			Endif
		Else
			MsgAlert("Não existem registros a serem processados !")
		Endif
	Endif
	
Return

Static function Valid1Perg(cPerg)
	u_INPutSX1(cPerg,"01",PADR("Da Data      ",29)+"?","","","mv_ch1","D", 8,0,0,"G","","   ","","","mv_par01")
	u_INPutSX1(cPerg,"02",PADR("Ate a Data   ",29)+"?","","","mv_ch2","D", 8,0,0,"G","","   ","","","mv_par02")
	u_INPutSX1(cPerg,"03",PADR("Do Projeto   ",29)+"?","","","mv_ch3","C", 9,0,0,"G","","CTT","","","mv_par03")
	u_INPutSX1(cPerg,"04",PADR("Ate o Projeto",29)+"?","","","mv_ch4","C", 9,0,0,"G","","CTT","","","mv_par04")
	u_INPutSX1(cPerg,"05",PADR("Da Filial    ",29)+"?","","","mv_ch5","C", 2,0,0,"G","","   ","","","mv_par05")
	u_INPutSX1(cPerg,"06",PADR("Ate a Filial ",29)+"?","","","mv_ch6","C", 2,0,0,"G","","   ","","","mv_par06")
Return

Static function Valid2Perg(cPerg)
	u_INPutSX1(cPerg,"01",PADR("Da Filial       ",29)+"?","","","mv_ch1","C", 2,0,0,"G","","   ","","","mv_par01")
	u_INPutSX1(cPerg,"02",PADR("Ate a Filial    ",29)+"?","","","mv_ch2","C", 2,0,0,"G","","   ","","","mv_par02")
	u_INPutSX1(cPerg,"03",PADR("Da Data         ",29)+"?","","","mv_ch3","D", 8,0,0,"G","","   ","","","mv_par03")
	u_INPutSX1(cPerg,"04",PADR("Ate a Data      ",29)+"?","","","mv_ch4","D", 8,0,0,"G","","   ","","","mv_par04")
	u_INPutSX1(cPerg,"05",PADR("Da Classe MCT   ",29)+"?","","","mv_ch5","C", 9,0,0,"G","","CTH","","","mv_par05")
	u_INPutSX1(cPerg,"06",PADR("Ate a Classe MCT",29)+"?","","","mv_ch6","C", 9,0,0,"G","","CTH","","","mv_par06")
	u_INPutSX1(cPerg,"07",PADR("Projeto Origem  ",29)+"?","","","mv_ch7","C", 9,0,0,"G","","CTT","","","mv_par07")
	u_INPutSX1(cPerg,"08",PADR("Projeto Destino ",29)+"?","","","mv_ch8","C", 9,0,0,"G","","CTT","","","mv_par08")
Return
