#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ RSFATA02   ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 13/09/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cadastro de Tabela de comissão.                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function RSFATA02()
	Local aCores      := Nil
	
	Private cCadastro := "Tabela de Comissão"
	Private cAlias1   := "PC0"
	Private cAlias2   := "PC1"    
	Private cFilPC0   := (cAlias1)->(xFilial(cAlias1))
	Private cFilPC1   := (cAlias2)->(xFilial(cAlias2))
	Private aRotina   := { 	{"Pesquisar"   ,"AxPesqui"     ,0,1} ,;
									{"Visualizar"  ,"u_FATA02Inclui",0,2} ,;
									{"Incluir"     ,"u_FATA02Inclui",0,3} ,;
									{"Alterar"     ,"u_FATA02Inclui",0,4} ,;
									{"Excluir"     ,"u_FATA02Inclui",0,5} ,;
									{"C&opiar"     ,"u_FATA02Inclui",0,6}}
	
	dbSelectArea(cAlias1)
  	dbSetOrder(1)
	
	mBrowse( 6,1,22,75,cAlias1,,,,,,aCores)
   Set Filter To
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦FATA02Inclui¦ Autor ¦ Orismar Silva        ¦ Data ¦ 13/09/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Inclui Vendas Especiais                                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FATA02Inclui(cAlias, nRecNo, nOpc )
	Local nX, aPosObj, aPosFol, aSize, aPosSub, aPosGet
	Local nOpcA      := 0
	Local oMainWnd   := Nil
	//Local oFolder    := Nil
	Local aCopia     := { "PC0_CODTAB", "PC0_DESCRI"}    // Itens do cabeçalho a não serem copiados
   Local aAltera    := {}
	Private aPasta   := {}
	Private nPM      := 0
	Private oDlg
	Private cTpVend  := ""
	Private aHeader  := {}
	Private aCols    := {}	
	Private aTela    := {}
	Private aGets    := {}
	Private bCampo   := { |nField| Field(nField) }
	Private Inclui   := (nOpc == 3 .Or. nOpc == 6)
	Private Altera   := (nOpc == 4)
	
	//+----------------------------------
	//| Inicia as variaveis para Enchoice
	//+----------------------------------
	dbSelectArea(cAlias1)
	dbSetOrder(1)
	dbGoTo(nRecNo)
	For nX:= 1 To FCount()
		// Inicializa vazio caso seja inclusão ou na cópia somente alguns campos
		If nOpc == 3 .Or. (nOpc == 6 .And. AScan( aCopia , Trim(FieldName(nX)) ) > 0)
			M->&(Eval(bCampo,nX)) := CriaVar(FieldName(nX),.T.)
		Else
			M->&(Eval(bCampo,nX)) := FieldGet(nX)
		Endif
	Next nX
	
	//+----------------
	//| Monta os aCols
	//+----------------
	MontaaCols(@aAltera,Inclui,nOpc)
	

	//+----------------------------------
	//| Inicia as posições dos objetos
	//+----------------------------------
	PosObjetos(@aSize,@aPosObj,@aPosFol,@aPosSub,@aPosGet)
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 TO aSize[6],aSize[5] PIXEL OF oMainWnd
	
	EnChoice(cAlias, nRecNo, nOpc,,,,,aPosObj[1],, 3,,,,oDlg)
	
	oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_FATA02LinOk()",,"+PC1_ITEM",.T.,,,,,,,,"u_FATA02DelIt()",oDlg)

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| nOpcA := If( Obrigatorio(aGets,aTela).And.u_FATA02TudOk(),1,0),;
																					  If(nOpcA==1,oDlg:End(),) }, {||nOpcA:=0,oDlg:End()} )
	
	If nOpc > 2
		If nOpca == 1
			Begin Transaction
			FATA02Grava(nOpc,nRecNo,aAltera)
			End Transaction
			
			If Inclui   // Atualiza o semáforo
				ConfirmSX8()
			Endif
		ElseIf Inclui  // Se for Inclusão
			RollBackSX8()
		Endif
	Endif
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATA02DelIt¦ Autor ¦ Orismar Silva        ¦ Data ¦ 13/09/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar delecao dos itens                                     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FATA02DelIt(aCols,cTipo)
	Local nDel := Len(aCols[1])
	Local lRet := .T. //(cTipo <> "M")
	
	If lRet .And. aCols[n,nDel] // Na recuperacao da linha - 1a. passagem
		lRet := !JaExiste(aCols[n,1],aCols)
	Endif
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATA02Valid¦ Autor ¦ Orismar Silva        ¦ Data ¦ 13/09/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar os campos das Vendas Especiais                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FATA02Valid()
	Local nPIni, nPFim, nPAnt, nPPrx
	Local cVar := Trim(Upper(ReadVar()))
	Local lRet := .T.
	
	If cVar == "M->PC1_INI"
		If lRet := Positivo()
			nPAnt := LinhaAnt(aHeader,aCols,n,-1)
			If n <> nPAnt   // Se encontrou uma outra linha
				nPFim := AScan( aHeader , {|x| Trim(x[2]) == "PC1_FIM" })
				If lRet := (nPAnt == 0 .Or. M->PC1_INI > aCols[nPAnt,nPFim])
					If !Empty(aCols[n,nPFim])  // Se o percentual final foi informado
						If lRet := (M->PC1_INI <= aCols[n,nPFim])
						Else
							Alert("Conteúdo não pode ser maior que o conteúdo final !")
						Endif
					Endif
				Else
					Alert("Conteúdo não pode ser menor que o conteúdo final da linha acima !")
				Endif
			Endif
		Endif
	ElseIf cVar == "M->PC1_FIM"
		If lRet := Positivo()
			nPPrx := LinhaAnt(aHeader,aCols,n,1)
			If n <> nPPrx   // Se encontrou uma outra linha
				nPIni := AScan( aHeader , {|x| Trim(x[2]) == "PC1_INI" })
				If lRet := (nPPrx > Len(aCols) .Or. M->PC1_FIM < aCols[nPPrx,nPIni])
					If lRet := (M->PC1_FIM >= aCols[n,nPIni])
					Else
						Alert("Conteúdo não pode ser menor que o conteúdo inicial !")
					Endif
				Else
					Alert("Conteúdo não pode ser maior que o conteúdo inicial da linha abaixo !")
				Endif
			Endif
		Endif
	ElseIf cVar == "M->PC1_COMIS"
		lRet := Positivo()
	Endif
	
Return lRet

Static Function LinhaAnt(aHeader,aCols,nPos,nStep)
	Local nX
	Local nPFxa := AScan( aHeader , {|x| Trim(x[2]) == "PC1_TIPO" })
	Local nPDel := Len(aCols[1])
	Local nRet  := nPos
	
	For nX:=nPos+nStep To 1 Step nStep
		If !aCols[nX,nPDel] .And. aCols[nX,nPFxa] == aCols[nPos,nPFxa]
			nRet := nX
			Exit
		Endif
	Next
	
Return nPos

Static Function JaExiste(cBusca,aCols)
	Local nX
	Local nDel := Len(aCols[1])
	Local lRet := .F.
	
	For nX:=1 To Len(aCols)
		If nX <> n .And. cBusca == aCols[nX,1] .And. !aCols[nX,nDel]
			lRet := !ExistChav("SX5","01")
			Exit
		Endif
	Next
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATA02LinOk ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 13/09/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar a linha do item                                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FATA02LinOk(nPos)
Return .T.

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATA02TudOk ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 13/09/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar todas as linhas dos itens                             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FATA02TudOk()
	Local nX, nY
	Local nPDel := Len(aCols[1])
	
	For nX:=1 To Len(aCols)
		
		If !aCols[nX,nPDel]
			For nY:=1 To Len(aCols[nX])-1
				If X3Obrigat( AllTrim(aHeader[nY,2]) ) .And. Empty(aCols[nX,nY])
					Help(1," ","OBRIGAT")
					Return .F.
				Endif
			Next
		Endif
	Next
	
Return .T.

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATA02Grava ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 13/09/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Grava os dados da lista de presentes                          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦ Parâmetro ¦ nOpc     -> Tipo da função (inclui,altera,exclui)             ¦¦¦
|¦¦           ¦ nRecNo   -> Numero do registro a ser gravado                  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function FATA02Grava(nOpc,nRecNo,aAltera)
	Local nX
	

	GravaDet(nOpc,cAlias2,aAltera)   // Grava os dados da meta
	
	//+-----------------
	//| Se for inclusão ou alteração
	//+-----------------
	If Inclui .Or. Altera
		RecLock(cAlias1,Inclui)
		For nX := 1 To FCount()
			If "FILIAL" $ FieldName(nX)
				FieldPut(nX,XFILIAL(cAlias1))
			Else
				FieldPut(nX,M->&(Eval(bCampo,nX)))
			Endif
		Next nX
	Else
	   //+-----------------
		//| Se for exclusão
		//+-----------------
		RecLock(cAlias1,.F.)
		dbDelete()
	Endif
	MsUnLock()
	
Return

Static Function GravaDet(nOpc,cAlias,aAltera)
	Local nX, nY
	Local nPDel := Len(aHeader) + 1
	
	dbSelectArea(cAlias)
	
	For nX:=1 To Len(aCols)
		If nX <= Len(aAltera)
			
			dbGoTo(aAltera[nX])
			RecLock(cAlias,.F.)
			
			If nOpc == 5 .Or. aCols[nX,nPDel]   // Se estiver deletado
				dbDelete()
			Else
				For nY:=1 To Len(aHeader)
					 FieldPut(FieldPos(Trim(aHeader[nY,2])),aCols[nX,nY])
				Next
			Endif
		ElseIf nOpc == 5 .Or. aCols[nX,nPDel]   // Se estiver deletado
			Loop
		Else
			RecLock(cAlias,.T.)
			(cAlias)->PC1_FILIAL := XFILIAL(cAlias)
			(cAlias)->PC1_CODTAB := M->PC0_CODTAB
			For nY:=1 To Len(aHeader)
				 FieldPut(FieldPos(Trim(aHeader[nY,2])),aCols[nX,nY])
			Next
		Endif
		MsUnLock()
	Next
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MontaaCols ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 13/09/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria a variavel vetor aCols                                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function MontaaCols(aAltera,lNovo,nOpc)
	Local nCols, nUsado, nX
	
	//+--------------
	//| Monta o aHeader
	//+--------------
	CriaHeader()
	
	//+--------------
	//| Monta o aCols com os dados referentes os ITENS DA PROMOÇÃO
	//+--------------
	nCols  := 0
	nUsado := Len(aHeader)
	If !lNovo .Or. nOpc == 6
	
		dbSelectArea(cAlias2)
		dbSetOrder(1)
		dbSeek(cFilPC0+PC0->PC0_CODTAB,.T.)
		While !Eof() .And. cFilPC0+PC0->PC0_CODTAB == PC1_FILIAL+PC1_CODTAB
			
			aAdd(aCols,Array(nUsado+1))
			nCols ++
			
			For nX := 1 To nUsado
				If ( aHeader[nX][10] != "V")
					aCols[nCols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
				Else
					aCols[nCols][nX] := CriaVar(aHeader[nX][2],.T.)
				Endif
			Next nX
			aCols[nCols][nUsado+1] := .F.
			
			If nOpc <> 6   // Se não for cópia
				AAdd( aAltera , Recno() )  // Adiciona o registro do item
			Endif
			
			
			dbSkip()
		Enddo
	Endif
	
	If Empty(aCols)
		//+--------------
		//| Monta o aCols com uma linha em branco
		//+--------------
		aColsBlank("PC1",@aCols,nUsado)
	Endif
	
Return .T.

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CriaHeader ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 13/09/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria a variavel vetor aHeader                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CriaHeader()
	aHeader := u_HMCriaHeader(cAlias2,.T.,{"PC1_CODTAB"})
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ aColsBlank ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 13/09/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria array de itens em branco                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function aColsBlank(cAlias,aArray,nUsado)
	Local nX, nTam
	Local cCampos := cAlias+"_CODTAB"
	
	If !Empty(cCampos)
		aAdd(aArray,Array(nUsado+1))
		nTam := Len(aArray)
		
		nUsado := 0
		
		For nX:=1 To Len(nUsado)
			If Trim(aHeader[nX,2]) == "PC1_ITEM"
				aArray[nTam][nUsado] := StrZero(1,aHeader[nX,4])
			Else
				aArray[nTam][nUsado] := CriaVar(aHeader[nX,2],.T.)
			EndIf
		Next
		aArray[nTam][nUsado+1] := .F.
	Endif

Return


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PosObjetos ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 18/04/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Inicializa as dimensões da tela para posicionar os objetos    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PosObjetos(aSize,aPosObj,aPosFol,aPosSub,aPosGet)
	Local aInfo1, aInfo2, aInfo3
	Local aObjects := {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	
	// Divide a tela para os objetos ENCHOICE e FOLDER
	AAdd( aObjects, { 100, 080, .t., .f. } )  // ENCHOICE
	AAdd( aObjects, { 100, 100, .t., .t. } )  // FOLDER
	
	// Calcula as coordenadas no MSDIALOG para os objetos (ENCHOICE e FOLDER)
	aInfo1 := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo1, aObjects )
	
	// Calcula as coordenadas para o objeto (sub) FOLDER dentro do FOLDER(1)
	aInfo2 := { 0, aPosObj[2,2], aPosObj[2,4]-aPosObj[2,2]-aInfo1[1], aPosObj[2,3]-aPosObj[2,1], 3, 3 }
	aPosSub := MsObjSize( aInfo2, {{ 100, 100, .t., .t. }}, .T. )
	
	// Calcula as coordenadas no (sub) FOLDER(1) para o objeto MSGETDADOS
	aInfo3 := { 0, aPosSub[1,2], aPosSub[1,4]-aPosSub[1,2]-aInfo2[1], aPosSub[1,3]-aPosSub[1,1]-aInfo2[2], 3, 3 }
	aPosGet := MsObjSize( aInfo3, {{ 100, 100, .t., .t. }}, .T. )
	
Return

Static Function Valid1Perg(cPerg)
	u_HMPutSX1(cPerg,"01",PADR("Da Data       ",29)+"?","","","mv_ch1","D",08,0,0,"G","","   ","","","mv_par01")
	u_HMPutSX1(cPerg,"02",PADR("Ate a Data    ",29)+"?","","","mv_ch2","D",08,0,0,"G","","   ","","","mv_par02")
	u_HMPutSX1(cPerg,"03",PADR("Relatorio     ",29)+"?","","","mv_ch3","N",01,0,0,"C","","   ","","","mv_par03","Sintetico","","","","Analitico")
	u_HMPutSX1(cPerg,"04",PADR("Do Vendedor   ",29)+"?","","","mv_ch4","C",06,0,0,"G","","SA3","","","mv_par04")
	u_HMPutSX1(cPerg,"05",PADR("Ate o Vendedor",29)+"?","","","mv_ch5","C",06,0,0,"G","","SA3","","","mv_par05")
	u_HMPutSX1(cPerg,"06",PADR("Comissao sobre",29)+"?","","","mv_ch6","N",01,0,0,"C","","   ","","","mv_par06","Vendas","","","","Metas","","","Ambas")
Return

Static Function Valid2Perg(cPerg)
	u_HMPutSX1(cPerg,"01",PADR("Da Data       ",29)+"?","","","mv_ch1","D",08,0,0,"G","","      ","","","mv_par01")
	u_HMPutSX1(cPerg,"02",PADR("Ate a Data    ",29)+"?","","","mv_ch2","D",08,0,0,"G","","      ","","","mv_par02")
	u_HMPutSX1(cPerg,"03",PADR("Do Vendedor   ",29)+"?","","","mv_ch3","C",06,0,0,"G","","SA3   ","","","mv_par03")
	u_HMPutSX1(cPerg,"04",PADR("Ate o Vendedor",29)+"?","","","mv_ch4","C",06,0,0,"G","","SA3   ","","","mv_par04")
	u_HMPutSX1(cPerg,"05",PADR("Comissao sobre",29)+"?","","","mv_ch5","N",01,0,0,"C","","      ","","","mv_par05","Vendas","","","","Metas","","","Ambas")
	u_HMPutSX1(cPerg,"06",PADR("Da Comissao   ",29)+"?","","","mv_ch6","C",04,0,0,"G","","PC1_CO","","","mv_par03")
	u_HMPutSX1(cPerg,"07",PADR("Ate a Comissao",29)+"?","","","mv_ch7","C",04,0,0,"G","","PC1_CO","","","mv_par04")
Return

Static Function Valid3Perg(cPerg)
	u_HMPutSX1(cPerg,"01",PADR("Imprime comissao",29)+"?","","","mv_ch1","N",01,0,0,"C","","   ","","","mv_par01","Gravada","","","","Recalcula")
Return
