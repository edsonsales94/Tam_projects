#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ INCTBA02   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 10/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cadastro de Rateios Externos                                  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function INCTBA02()
	Local aCores := { { "CTJ_XSTATU=' '", "DISABLE"},; // RATEIO PENDENTE
							{ "CTJ_XSTATU='S'", "ENABLE" }}  // RATEIO FINALIZADO
	
	Private nPIte, nPDeb, nPMCT, nPTpo, nPVal, nPPer, nPRat, nPRes, nPDel
	Private cCadastro := "Rateios Externos"
	Private cAlias1   := "CTJ"
	Private aPos      := { 15, 02, 065, 375}
	Private aRotina   := {	{"Pesquisar" ,"AxPesqui"     ,0,1} ,;
									{"Visualizar","u_CTB02Rateio",0,2} ,;
									{"Incluir"   ,"u_CTB02Rateio",0,3} ,;
									{"Alterar"   ,"u_CTB02Rateio",0,4} ,;
									{"Excluir"   ,"u_CTB02Rateio",0,5} ,;
									{"Copiar"    ,"u_CTB02Rateio",0,6} ,;
									{"Legenda"   ,"u_CTB02Legend",0,7} }
	
	dbSelectArea(cAlias1)
	dbSetOrder(1)
	
	mBrowse( 6,1,22,75,cAlias1,,,,,,aCores)
	Set Filter To
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦CTB02Rateio ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 10/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Inclui Rateios Externos                                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function CTB02Rateio(cAlias, nRecNo, nOpc )
	Local nX, aSize, aPosObj
	Local nOpcA     := 0
	Local oMainWnd  := Nil
	Local oFolder   := Nil
	Local aCabec    := { "CTJ_RATEIO", "CTJ_DESC", "CTJ_XTOTAL"}
	Local aAlter    := { "CTJ_DEBITO", "CTJ_CLVLDB", "CTJ_XTIPO", "CTJ_VALOR", "CTJ_XRATVA"}
	Local vCampos   := { "CTJ_SEQUEN", "CTJ_DEBITO", "CTJ_CLVLDB", "CTJ_XTIPO", "CTJ_VALOR", "CTJ_PERCEN", "CTJ_XRATVA", "CTJ_XTOTAL"}
	Local aField    := {}
	
	Private oDlg    := Nil
	Private oGet    := Nil
	Private aHeader := {}
	Private aCols   := {}
	Private aRateio := {}
	Private bCampo  := { |nField| Field(nField) }
	Private nOpcMen := nOpc
	Private Inclui  := (nOpcMen == 3 .Or. nOpcMen == 6)
	Private Altera  := (nOpcMen == 4)
	Private nPD     := 1
	Private nTotRes := 0
	Private oTotRes := Nil
	Private cFilSZ1 := SZ1->(XFILIAL("SZ1"))
	Private aTela   := {}
	Private aGets   := {}
	
	//+----------------------------------
	//| Inicia as variaveis para Enchoice
	//+----------------------------------
	dbSelectArea(cAlias1)
	dbSetOrder(1)
	dbGoTo(nRecNo)
	For nX:= 1 To FCount()
		M->&(Eval(bCampo,nX)) := If( Inclui , CriaVar(FieldName(nX),.T.), FieldGet(nX))
	Next nX
	
	//+----------------
	//| Monta os aCols
	//+----------------
	M->CTJ_RATEIO := If( Inclui , GETSX8NUM("CTJ", "CTJ_RATEIO"), CTJ->CTJ_RATEIO)
	M->CTJ_DESC   := If( Inclui , CriaVar("CTJ_DESC")  , CTJ->CTJ_DESC)
	M->CTJ_XTOTAL := MontaaCols(vCampos,aCabec,@aField)
	
	aHeader[nPIte,1] := "Item"      // Atribui descrição para a coluna Item
	aHeader[nPRes,1] := "Restante"  // Atribui descrição para a coluna Restante
	
	SetKey( 116 , {|| RateioItem(cAlias, nRecNo) })  // Habilita a tecla de atalho F5 (Detalhes do Rateio)
	
	PosObjetos(@aSize,@aPosObj)
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],0 TO aSize[6],aSize[5] PIXEL OF oMainWnd
	
	oEnc := Msmget():New(,,nOpc,,,,aCabec,aPosObj[1],Nil,3,,,,oDlg,,.T.,,,,,aField,,,.F.)
	
	oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcMen,"u_CTB02LinOk(,.F.,1)",,"+CTJ_SEQUEN",.T.,aAlter,,,9999,,,,"u_CTB02DelIt(1)",oDlg)
	
	@ aPosObj[3,1],aPosObj[3,4] - 100 SAY "Valor Restante"  PIXEL OF oDlg COLOR CLR_HBLUE
	@ aPosObj[3,1],aPosObj[3,4] - 060 GET nTotRes SIZE 60,20 PICTURE "@E 99,999,999.99" OBJECT oTotRes WHEN .F.
	
	If nOpcMen == 4  // Se for alteração
		oGet:oBrowse:SetFocus()
	Endif
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| nOpcA := If( CTB02TudOk(1),1,0),;
																						If(nOpcA==1,oDlg:End(),) }, {||nOpcA:=0,oDlg:End()},,;
																						{{"S4WB013N",{|| RateioItem(cAlias, nRecNo) },"Detalhes Rateio - F5","Rateio"}} )
	
	If nOpca == 1 .And. nOpcMen <> 2  // Se não for visualizar
		Begin Transaction
		CTB02Grava(nRecNo)
		
		If INCLUI
			ConfirmSX8()
		Endif
		End Transaction
	Else
		(cAlias1)->(dbGoTo(nRecNo))  // Posiciona no registro de origem
		
		If INCLUI
			RollBackSX8()
		EndIf
	Endif
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CTB02Legend¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 16/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Legenda do rateio                                             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function CTB02Legend( cAlias, nRecNo, nOpc )
	BRWLEGENDA(cCadastro,"Legenda - Rateios Externos",;
								{{"ENABLE" , "Concluído"},;
								{"DISABLE", "Pendente" }})
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CTB02Grava ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 12/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Grava os dados do rateio externo                              ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CTB02Grava(nRecNo)
	Local x, y
	Local nRec  := 0
	Local nItem := 0
	Local aItem := {}
	Local cItem := StrZero(0,Len(CTJ->CTJ_SEQUEN))
	
	If nOpcMen == 3 .Or. nOpcMen == 6  // Se for Inclusão ou Cópia
		For x:=1 To Len(aRateio)
			If !aCols[aRateio[x,1],nPDel]   // Se o item não está deletado
				For y:=1 To Len(aRateio[x,2])
					If !aRateio[x,2][y,5]     // Se o item não está deletado
						RecLock("CTJ",.T.)
						CTJ->CTJ_FILIAL := xFilial("CTJ")
						CTJ->CTJ_RATEIO := M->CTJ_RATEIO
						CTJ->CTJ_SEQUEN := (cItem:=Soma1(cItem))
						CTJ->CTJ_DESC   := M->CTJ_DESC
						CTJ->CTJ_MOEDLC := "01"
						CTJ->CTJ_TPSALD := "1"
						CTJ->CTJ_DEBITO := aCols[aRateio[x,1],nPDeb]
						CTJ->CTJ_CLVLDB := aCols[aRateio[x,1],nPMCT]
						CTJ->CTJ_XTIPO  := aCols[aRateio[x,1],nPTpo]
						CTJ->CTJ_XRATVA := aCols[aRateio[x,1],nPRat]
						CTJ->CTJ_ITEMD  := aRateio[x,3]
						CTJ->CTJ_CCD    := aRateio[x,2][y,2]
						CTJ->CTJ_VALOR  := aRateio[x,2][y,3]
						CTJ->CTJ_PERCEN := aRateio[x,2][y,4] * 100
						CTJ->CTJ_XTOTAL := M->CTJ_XTOTAL
						CTJ->CTJ_XSTATU := If( nTotRes > 0 , " ", "S")
						CTJ->CTJ_XTOTDI := aCols[aRateio[x,1],nPVal]    // Valor Digitado
						MsUnLock()
						nRec := If( nRec == 0 , CTJ->(Recno()), nRec)
					Endif
				Next
			Endif
		Next
		CTJ->(dbGoTo(nRec))  // Posiciona no 1o registro gravado
	ElseIf nOpcMen == 4  // Se for Alteração
		
		// Na alteração apaga todos os registros do rateio
		For x:=1 To Len(aRateio)
			For y:=1 To Len(aRateio[x,2])
				If aRateio[x,2][y,1] > 0   // Se tem registro válido
					CTJ->(dbGoTo(aRateio[x,2][y,1]))  // Posiciona no registro do CTJ
					If aCols[aRateio[x,1],nPDel] .Or. aRateio[x,4] .Or. aRateio[x,2][y,5]   // Se o item estiver deletado
						RecLock("CTJ",.F.)
						dbDelete()                        // Deleta registro
						MsUnLock()
					Else
						// Guarda os registros a serem alterados
						AAdd( aItem , { CTJ->CTJ_SEQUEN, CTJ->(Recno()) } )
					Endif
				Endif
			Next
		Next
		
		// Ordena o vetor de registros por Sequência
		ASort( aItem ,,, {|x,y| x[1] < y[1] } )
		
		// Grava todos os registros ativos
		For x:=1 To Len(aRateio)
			For y:=1 To Len(aRateio[x,2])
				
				If aCols[aRateio[x,1],nPDel] .Or. aRateio[x,4] .Or. aRateio[x,2][y,5]   // Se o item estiver deletado
					Loop
				Endif
				
				cItem := Soma1(cItem)
				nItem++
				
				If nItem <= Len(aItem)
					CTJ->(dbGoTo(aItem[nItem,2]))  // Posiciona no registro válido
					RecLock("CTJ",.F.)  // Altera registro no CTJ
				Else
					RecLock("CTJ",.T.)  // Inclui novo registro no CTJ
					CTJ->CTJ_FILIAL := xFilial("CTJ")
					CTJ->CTJ_RATEIO := M->CTJ_RATEIO
					CTJ->CTJ_DESC   := M->CTJ_DESC
					CTJ->CTJ_MOEDLC := "01"
					CTJ->CTJ_TPSALD := "1"
				Endif
				CTJ->CTJ_SEQUEN := cItem
				CTJ->CTJ_DEBITO := aCols[aRateio[x,1],nPDeb]
				CTJ->CTJ_CLVLDB := aCols[aRateio[x,1],nPMCT]
				CTJ->CTJ_XTIPO  := aCols[aRateio[x,1],nPTpo]
				CTJ->CTJ_XRATVA := aCols[aRateio[x,1],nPRat]
				CTJ->CTJ_ITEMD  := aRateio[x,3]
				CTJ->CTJ_CCD    := aRateio[x,2][y,2]
				CTJ->CTJ_VALOR  := aRateio[x,2][y,3]
				CTJ->CTJ_PERCEN := aRateio[x,2][y,4] * 100
				CTJ->CTJ_XTOTAL := M->CTJ_XTOTAL
				CTJ->CTJ_XSTATU := If( nTotRes > 0 , " ", "S")
				CTJ->CTJ_XTOTDI := aCols[aRateio[x,1],nPVal]    // Valor Digitado
				MsUnLock()
				
				nRec := If( nRec == 0 , CTJ->(Recno()), nRec)
			Next
		Next
		CTJ->(dbGoTo(nRec))  // Posiciona no registro origem
	ElseIf nOpcMen == 5  // Se for Exclusão
		For x:=1 To Len(aRateio)
			For y:=1 To Len(aRateio[x,2])
				CTJ->(dbGoTo(aRateio[x,2][y,1]))  // Posiciona no registro do CTJ
				RecLock("CTJ",.F.)
				dbDelete()                        // Deleta registro
				MsUnLock()
			Next
		Next
	Endif
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CTB02LinOk ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 10/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar a linha do item                                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function CTB02LinOk(nPos,lRateio,nOpcVal)
	Local x
	Local lRet := .T.
	
	nPos := If( nPos == Nil , n, nPos)
	
	If nOpcVal == 1  // Se leitura do MsGetDados principal
		If !aCols[nPos,nPDel]  // Se não está deletado
			If lRet := NaoVazio(aCols[nPos,nPDeb]) .And. NaoVazio(aCols[nPos,nPMCT]) .And. NaoVazio(aCols[nPos,nPVal]) .And.;
				NaoVazio(aCols[nPos,nPTpo]) .And. NaoVazio(aCols[nPos,nPPer]) .And. NaoVazio(aCols[nPos,nPRat])
				If lRateio  // Valida se foi definido rateio para o item
					// Pesquisa o item do aCols no vetor do rateio
					If AScan( aRateio , {|x| nPos == x[1] }) == 0
						lRet := .F.
						Aviso( "INVÁLIDO", "Não foi definido rateio para o item "+aCols[nPos,nPIte]+" !", {"Ok"} )
					Endif
				ElseIf AScan( aRateio , {|x| nPos == x[1] }) == 0  // Pesquisa rateio para o item
					RateioItem("CTJ",CTJ->(Recno()))  // Na validação da linha, abre tela para digitação do rateio
				Endif
			Endif
		Endif
	ElseIf !aCols[nPos,5]   // Se não tiver deletado
		lRet := NaoVazio(aCols[nPos,3])   // Verifica se foi digitado o valor da linha
	Endif
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CTB02TudOk ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 10/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar todas as linhas dos itens                             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CTB02TudOk(nOpcVal)
	Local x
	Local lRet := .T.
	
	For x:=1 To Len(aCols)
		If !(lRet := u_CTB02LinOk(x,.T.,nOpcVal))
			Exit
		Endif
	Next
	
Return lRet .And. If( nOpcVal == 1 , If( Inclui , ExistChav("CTJ",M->CTJ_RATEIO), .T.) .And. NaoVazio(M->CTJ_DESC) .And. Positivo(M->CTJ_XTOTAL), .T.)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CTB02Valid ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 10/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar os campos dos rateios externos                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function CTB02Valid(nOpcVal)
	Local x, cPerg1
	Local lTudo := .T.
	Local nTot  := 0
	Local nRes  := 0
	Local cVar  := Upper(Trim(ReadVar()))
	Local lRet  := .T.
	
	If nOpcVal == 1  // Se está validando a 1a tela
		If cVar == "M->CTJ_RATEIO"
			lRet := ExistChav("CTJ") .And. FreeForUse("CTJ",M->CTJ_RATEIO,.F.)
		ElseIf cVar == "M->CTJ_DEBITO"
			If lRet := ExistCpo("CT1") .And. ValidaConta(M->CTJ_DEBITO,"1",,,.T.)
				// Se encontrou a mesma ocorrência para os campos da chave do item
				If AScan( aCols , {|x| x[nPDeb]+x[nPMCT]+x[nPTpo]+x[nPRat] == M->CTJ_DEBITO+aCols[n,nPMCT]+aCols[n,nPTpo]+aCols[n,nPRat] } ) > 0
					lRet := ExistChav("SX5","01")
				Endif
			Endif
		ElseIf cVar == "M->CTJ_CLVLDB"
			If lRet := ExistCpo("CTH")
				// Se encontrou a mesma ocorrência para os campos da chave do item
				If AScan( aCols , {|x| x[nPDeb]+x[nPMCT]+x[nPTpo]+x[nPRat] == aCols[n,nPDeb]+M->CTJ_CLVLDB+aCols[n,nPTpo]+aCols[n,nPRat] } ) > 0
					lRet := ExistChav("SX5","01")
				Endif
			Endif
		ElseIf cVar == "M->CTJ_VALOR"
			If lRet := Positivo()
				aEval( aCols , {|x| If( !x[nPDel] , nTot += x[nPVal], ) })
				
				If lRet := ((nTot + If( aCols[n,nPDel] , 0, M->CTJ_VALOR - aCols[n,nPVal])) <= M->CTJ_XTOTAL)
					If lRet := M->CTJ_VALOR >= TotRateado(n)
						aCols[n,nPVal] := M->CTJ_VALOR
						aCols[n,nPRes] := M->CTJ_VALOR - TotRateado(n)
						
						nTotRes := M->CTJ_XTOTAL
						// Data: 17-03-2025 | Autor: Julio C. Ribeiro
						// Modif: Alterado a quantidade de casas decimais de 5 -> 9 na funçao ROUND 
						aEval( aCols , {|x| If( !x[nPDel] , (nTotRes := nTotRes - x[nPVal] + x[nPRes], x[nPPer] := Round(x[nPVal]/M->CTJ_XTOTAL,9)), ) })
						oTotRes:Refresh()
					Else
						Aviso( "INVÁLIDO", "Valor não pode ser inferior ao total já rateado para esse item !", {"Ok"} )
					Endif
				Else
					Aviso( "INVÁLIDO", "Valor ultrapassa o limite do rateio !", {"Ok"} )
				Endif
			Endif
		ElseIf cVar == "M->CTJ_XTOTAL"
			If lRet := NaoVazio() .And. Positivo()
				aEval( aCols , {|x| If( !x[nPDel] , (nTot += x[nPVal], nRes += x[nPRes]), ) })
				If lRet := M->CTJ_XTOTAL >= nTot
					nTotRes := M->CTJ_XTOTAL - nTot + nRes
				Else
					Aviso( "INVÁLIDO", "Valor não pode ser inferior ao total dos itens do rateio !", {"Ok"} )
				Endif
			Endif
		ElseIf cVar == "M->CTJ_XTIPO"
			// Pesquisa se já existe rateio par o item
			If lRet := AScan( aRateio , {|x| n == x[1] }) == 0
				// Se encontrou a mesma ocorrência para os campos da chave do item
				If AScan( aCols , {|x| x[nPDeb]+x[nPMCT]+x[nPTpo]+x[nPRat] == aCols[n,nPDeb]+aCols[n,nPMCT]+M->CTJ_XTIPO+aCols[n,nPRat] } ) > 0
					lRet := ExistChav("SX5","01")
				Endif
			ElseIf Altera
				Aviso( "INVÁLIDO", "Não é permitida alteração pois já existe rateio para esse item !", {"Ok"} )
			ElseIf lRet := MsgYesNo("Já existe rateio definido para esse item, caso a origem seja alterada esses dados serão perdidos. Confirma ?")
				// Exclui os itens do rateio
				While (x := AScan( aRateio , {|x| n == x[1] })) > 0
					ADel( aRateio , x )
					aSize( aRateio , Len(aRateio) - 1 )
				Enddo
				//RateioItem("CTJ",CTJ->(Recno()))  // Na validação da linha, abre tela para digitação do rateio
			Endif
		ElseIf cVar == "M->CTJ_XRATVA"
			// Pesquisa se já existe rateio par o item
			If lRet := AScan( aRateio , {|x| n == x[1] }) == 0
				// Se encontrou a mesma ocorrência para os campos da chave do item
				If AScan( aCols , {|x| x[nPDeb]+x[nPMCT]+x[nPTpo]+x[nPRat] == aCols[n,nPDeb]+aCols[n,nPMCT]+aCols[n,nPTpo]+M->CTJ_XRATVA } ) > 0
					lRet := ExistChav("SX5","01")
				Endif
			Else
				Aviso( "INVÁLIDO", "Não é permitida alteração pois já existe rateio para esse item !", {"Ok"} )
			Endif
		Endif
	Else
		If cVar == "M->CTJ_VALOR"
			aEval( aCols , {|x| If( !x[5] , nTot += x[3], ) })
			
			nTot += If( aCols[n,5] , 0, M->CTJ_VALOR - aCols[n,3])  // Atribui o conteúdo digitado menos o que havia antes
			
			If lRet := (nTot <= aColBkp[nBkp,nPVal])
				nValRest := aColBkp[nBkp,nPVal] - nTot
				
				aCols[n,3] := M->CTJ_VALOR  // Atribui o valor digitado
				
				// Calcula o percentual de cada item
				nTot := 0
				// Data: 17-03-2025 | Autor: Julio C. Ribeiro
				// Modif: Alterado a quantidade de casas decimais de 5 -> 9 na funçao ROUND 
				aEval( aCols , {|x| If( !x[5] , (x[4] := Round(x[3]/M->CTJ_XTOTAL,9), nTot += x[4], lTudo := (lTudo .And. x[4] > 0)), ) })
				
				If nValRest == 0   // Se já foram digitados todos os valores
					aCols[n,4] += aColBkp[nBkp,nPPer] - nTot
				Endif
				
				oRat:Refresh()
				oValRest:Refresh()
			Else
				Aviso( "INVÁLIDO", "Valor ultrapassa o limite do rateio !", {"Ok"} )
			Endif
		ElseIf cVar == "M->CTJ_ITEMD"
			If lRet := ExistCpo("CTD")
				cPerg1 := PADR("INCTBA0201",Len(SX1->X1_GRUPO))
				Valid1Perg(cPerg1)
				Pergunte(cPerg1,.F.)
				
				CTD->(dbSetOrder(1))
				CTD->(dbSeek(xFilial("CTD")+M->CTJ_ITEMD))
				
				SZ1->(dbSetOrder(2))
				If SZ1->(dbSeek(XFILIAL("SZ1")+M->CTJ_ITEMD+Dtos(mv_par01))) .And.;
					mv_par02 == 3 .Or. CTD->CTD_DEPTO == "3" .Or. Str(mv_par02,1) == CTD->CTD_DEPTO
					aCols[n,2] := Posicione("CTD",1,XFILIAL("CTD")+M->CTJ_ITEMD,"CTD_DESC01")
				Else
					Aviso( "INVÁLIDO", "Matrícula não está cadastrada no SIATA !", {"Ok"} )
				Endif
			Endif
		ElseIf cVar == "M->CTJ_CCD"
			If lRet := ExistCpo("CTT")
				aCols[n,2] := Posicione("CTT",1,XFILIAL("CTT")+M->CTJ_CCD,"CTT_DESC01")
			Endif
		Endif
	Endif
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CTB02DelIt ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 12/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Valida deleção dos itens                                      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function CTB02DelIt(nOpcVal)
	Local x, nTot
	Local lRet := .T.
	
	// Se não for inclusão, cópia ou alteração
	If !Inclui .And. !Altera
		Return .F.
	Endif
	
	If nPD == 1    // 1a. passagem
		If nOpcVal == 1  // Se está validando a 1a tela
			If aCols[n,nPDel] // Na recuperacao da linha - 1a. passagem
				nTot := aCols[n,nPVal]
				For x:=1 To Len(aCols)
					If x <> n .And. !aCols[x,nPDel]
						// Se existe um item igual
						If aCols[x,nPDeb]+aCols[x,nPMCT]+aCols[x,nPTpo]+aCols[x,nPRat] == aCols[n,nPDeb]+aCols[n,nPMCT]+aCols[n,nPTpo]+aCols[n,nPRat]
							If lRet := ExistChav("SX5","01")
								Exit
							Endif
						Else
							nTot := aCols[x,nPVal]
						Endif
					Endif
				Next
				// Se o valor do item somado aos demais ultrapassa o limite
				If lRet := lRet .And. nTot <= M->CTJ_XTOTAL
					nTotRes := nTotRes - aCols[n,nPVal] + aCols[n,nPRes]
					oTotRes:Refresh()
				Else
					Aviso( "INVÁLIDO", "Valor ultrapassa o limite do rateio !", {"Ok"} )
				Endif
			Else
				nTotRes := nTotRes + aCols[n,nPVal] - aCols[n,nPRes]
				oTotRes:Refresh()
			Endif
		Else
			If aCols[n,5] // Na recuperacao da linha
				nTot := aCols[n,3]
				aEval( aCols , {|x| If( !x[5] , nTot += x[3], ) })
				
				If lRet := (nTot <= aColBkp[nBkp,nPVal])
					nValRest -= aCols[n,3]   // Soma o valor do item
					
					If nValRest == 0   // Se já foram digitados todos os valores
						nTot := aCols[n,4]
						aEval( aCols , {|x| If( !x[5] , nTot += x[4], ) })
						aCols[n,4] += aColBkp[nBkp,nPPer] - nTot
					Endif
					
					oValRest:Refresh()
				Else
					Aviso( "INVÁLIDO", "Valor ultrapassa o limite do rateio !", {"Ok"} )
				Endif
			Else
				nValRest += aCols[n,3]   // Subtrai o valor do item
				oValRest:Refresh()
			Endif
		Endif
	Endif
	nPD := If( nPD == 2 , 1, nPD + 1)
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MontaaCols ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 10/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria a variavel vetor aCols                                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function MontaaCols(vCampos,aCabec,aField)
	Local nCols, nUsado, nX, cRateio, nPos, nRecno, nIndex, nPMat
	Local nRet := 0
	
	//+--------------
	//| Monta o aHeader
	//+--------------
	CriaHeader(vCampos,1,aCabec,@aField)
	
	//+--------------
	//| Monta o aCols com os dados referentes os ITENS DA PROMOÇÃO
	//+--------------
	nCols  := 0
	nUsado := Len(aHeader)
	
	nPIte := AScan( aHeader , {|x| Trim(x[2]) == "CTJ_SEQUEN" })
	nPDeb := AScan( aHeader , {|x| Trim(x[2]) == "CTJ_DEBITO" })
	nPMCT := AScan( aHeader , {|x| Trim(x[2]) == "CTJ_CLVLDB" })
	nPTpo := AScan( aHeader , {|x| Trim(x[2]) == "CTJ_XTIPO"  })
	nPVal := AScan( aHeader , {|x| Trim(x[2]) == "CTJ_VALOR"  })
	nPPer := AScan( aHeader , {|x| Trim(x[2]) == "CTJ_PERCEN" })
	nPRat := AScan( aHeader , {|x| Trim(x[2]) == "CTJ_XRATVA" })
	nPRes := AScan( aHeader , {|x| Trim(x[2]) == "CTJ_XTOTAL" })
	nPDel := nUsado + 1
	
	If nOpcMen <> 3   // Se não for inclusão
		cRateio := CTJ->(CTJ_FILIAL+CTJ_RATEIO)
		nRecno  := CTJ->(Recno())
		nIndex  := CTJ->(IndexOrd())
		nRet    := CTJ->CTJ_XTOTAL
		nTotRes := nRet
		dbSelectArea(cAlias1)
		dbSetOrder(1)
		dbSeek(cRateio,.T.)
		While !Eof() .And. cRateio == CTJ->(CTJ_FILIAL+CTJ_RATEIO)
			
			nPos := AScan( aCols , {|x| x[nPDeb]+x[nPMCT]+x[nPTpo]+x[nPRat] == CTJ->(CTJ_DEBITO+CTJ_CLVLDB+CTJ_XTIPO+CTJ_XRATVA) })
			If nPos == 0
				AAdd( aCols , Array(nUsado+1) )
				nPos := Len(aCols)
				
				aCols[nPos,nPIte] := StrZero(nPos,Len(CTJ->CTJ_SEQUEN))
				aCols[nPos,nPDeb] := CTJ->CTJ_DEBITO
				aCols[nPos,nPMCT] := CTJ->CTJ_CLVLDB
				aCols[nPos,nPTpo] := CTJ->CTJ_XTIPO
				aCols[nPos,nPVal] := 0
				aCols[nPos,nPPer] := 0
				aCols[nPos,nPRat] := CTJ->CTJ_XRATVA
				aCols[nPos,nPVal] := CTJ->CTJ_XTOTDI    // Valor digitado
				aCols[nPos,nPRes] := aCols[nPos,nPVal]
				aCols[nPos,nPDel] := .F.
			Endif
			aCols[nPos,nPRes] -= CTJ->CTJ_VALOR
			// Data: 17-03-2025 | Autor: Julio C. Ribeiro
			// Modif: Alterado a quantidade de casas decimais de 5 -> 9 na funç2ao ROUND 
			aCols[nPos,nPPer] := Round(aCols[nPos,nPVal] / nRet,9)
			
			nTotRes -= CTJ->CTJ_VALOR
			
			// Adiciona o registro do item do rateio
			If CTJ->CTJ_XTIPO == "1"   // Se for por Colaborador
				// Acumula os valores rateados pelo SIATA numa única linha por Colaborador
				nPMat := AScan( aRateio , {|x| x[1] == nPos .And. x[3] == CTJ->CTJ_ITEMD })
				If nPMat == 0
					AAdd( aRateio , { nPos, {}, CTJ->CTJ_ITEMD, .F.} )
					nPMat := Len(aRateio)
				Endif
			Else
				AAdd( aRateio , { nPos,  {}, CTJ->CTJ_ITEMD, .F.} )
				nPMat := Len(aRateio)
			Endif
			
			// Adiciona os registro que compõem a linha
			AAdd( aRateio[nPMat,2] , { If(nOpcMen<>6,Recno(),0), CTJ->CTJ_CCD, CTJ->CTJ_VALOR, CTJ->CTJ_PERCEN / 100, .F.} )
			
			dbSkip()
		Enddo
		dbSetOrder(nIndex)
		dbGoTo(nRecno)
	Endif
	
	If Empty(aCols)  // Caso nao tenha itens na promoção
		//+--------------
		//| Monta o aCols com uma linha em branco
		//+--------------
		aColsBlank("CTJ",@aCols,vCampos,nUsado)
		
		aCols[1,nPIte] := StrZero(1,Len(CTJ->CTJ_SEQUEN))
	Endif
	
Return nRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CriaHeader ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 10/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria a variavel vetor aHeader                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CriaHeader(vCampos,nOpcVal,aCabec,aField)
	Local nX
	Local aCompl := { .T., .F., .F.}
	
	// Cria aHeader com os dados do Rateio
	SX3->(dbSetOrder(2))
	
	If nOpcVal == 1
		For nX:=1 To Len(aCabec)
			If SX3->(dbSeek(aCabec[nX]))
				aAdd(aField,{	Trim(X3Titulo()), ;
									SX3->X3_CAMPO    , ;
									SX3->X3_TIPO     , ;
									SX3->X3_TAMANHO  , ;
									SX3->X3_DECIMAL  , ;
									SX3->X3_PICTURE  , ;
									{|| &("u_CTB02Valid("+Str(nOpcVal,1)+")") }, ;
									VerByte(SX3->X3_RESERV,7) .Or. (SubStr(Bin2Str(SX3->X3_OBRIGAT),1,1) == "x"), ;   // Obrigatório
									SX3->X3_NIVEL    , ;
									SX3->X3_RELACAO  , ;
									SX3->X3_F3       , ;   // F3
									SX3->X3_WHEN     , ;   // When
									aCompl[nX]       , ;   // Visual
									.F.              , ;   // Chave
									AllTrim(X3CBox()), ;
									Val(SX3->X3_FOLDER), ;
									.F.              , ;
									SX3->X3_PICTVAR  , ;
									SX3->X3_TRIGGER  } )
			Endif
		Next
	Endif
	
	For nX:=1 To Len(vCampos)
		If SX3->(dbSeek(vCampos[nX]))
			If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
				
				aAdd(aHeader,{ Trim(X3Titulo()), ;
									SX3->X3_CAMPO   , ;
									SX3->X3_PICTURE , ;
									SX3->X3_TAMANHO , ;
									SX3->X3_DECIMAL , ;
									"u_CTB02Valid("+Str(nOpcVal,1)+")", ;
									SX3->X3_USADO   , ;
									SX3->X3_TIPO    , ;
									SX3->X3_F3      , ;
									SX3->X3_CONTEXT , ;
									SX3->X3_CBOX    , ;
									SX3->X3_RELACAO } )
				
			Endif
		Endif
	Next
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ aColsBlank ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 10/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria array de itens em branco                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function aColsBlank(cAlias,aArray,vCampos,nUsado)
	Local x 	
	aArray := {}
	aAdd(aArray,Array(nUsado+1))
	nUsado := 0
	
	SX3->(dbSetOrder(2))
	
	For x:=1 To Len(vCampos)
		If SX3->(dbSeek(vCampos[x]))
			If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
				nUsado++
				aArray[1][nUsado] := CriaVar(Trim(SX3->X3_CAMPO),.T.)
			Endif
		Endif
		aArray[1][nUsado+1] := .F.
	Next
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ RateioItem ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 10/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Exibe tela de rateio do item                                  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function RateioItem(cAlias, nRecNo)
	Local nPos, x, y
	Local nRes  := aCols[n,nPRes]
	Local cTab  := If( aCols[n,nPTpo] == "1" , "CTD", "CTT")
	Local cVar  := Upper(Trim(ReadVar()))
	Local aItem := {}
	
	If cVar $ "M->CTJ_RATEIO,M->CTJ_DESC,M->CTJ_XTOTAL"
		Return
	Endif
	
	SetKey( 116 , {|| Nil })  // Desabilita a tecla de atalho F5 (Detalhes do Rateio)
	
	If aCols[n,nPDel]
		Aviso( "INVÁLIDO", "Rateio não pode ser acessado pois o item "+aCols[n,nPIte]+" está deletado !", {"Ok"} )
	ElseIf Empty(aCols[n,nPDeb]) .Or. Empty(aCols[n,nPMCT]) .Or. Empty(aCols[n,nPTpo]) .Or. Empty(aCols[n,nPVal]) .Or. Empty(aCols[n,nPPer]) .Or.;
		Empty(aCols[n,nPRat])
		Aviso( "INVÁLIDO", "É necessário definir todos os campos obrigatórios !", {"Ok"} )
	Else
		Private aColBkp, aHeaBkp, nBkp, nPDBkp
		
		// Salva as variáveis de uso do MSGetDados
		aColBkp := aClone(aCols)
		aHeaBkp := aClone(aHeader)
		nBkp    := n
		nPDBkp  := nPD
		aCols   := {}
		
		For x:=1 To Len(aRateio)
			// Se encontrou definição de rateio para o item do aCols
			If n == aRateio[x,1]
				AAdd( aCols , { "", "", 0, 0, .F.})
				nPos := Len(aCols)
				aCols[nPos,1] := If( cTab == "CTD" , aRateio[x,3], aRateio[x,2][1,2])
				aCols[nPos,2] := PADR(Posicione(cTab,1,XFILIAL(cTab)+aCols[nPos,1],cTab+"_DESC01"),30)
				aCols[nPos,5] := aRateio[x,4]   // Status de deleção
				
				// Acumula os valores e percentuais
				aEval( aRateio[x,2] , {|y| If( !y[5] , (aCols[nPos,3] += y[3], aCols[nPos,4] += y[4]), ) } )
				
				AAdd( aItem , x )  // Guarda a linha do aRateio que o aCols se refere
			Endif
		Next
		
		If Empty(aCols)  // Se não encontrou definição
			AAdd( aCols , { CriaVar(If( cTab == "CTD", "CTJ_ITEMD", "CTJ_CCD")), Space(30), 0, 0, .F.})
		Endif
		
		nRes := CTB02Detalhe(aItem)  // Se rateio for diferente
		
		// Restaura as variáveis de uso do MSGetDados
		aCols   := aClone(aColBkp)
		aHeader := aClone(aHeaBkp)
		n       := nBkp
		nPD     := nPDBkp
		
		aCols[n,nPRes] := nRes   // Atribui o valor restante calculado
		
		// Atualiza o restante a ratear
		nTotRes := M->CTJ_XTOTAL
		aEval( aCols , {|x| If( !x[nPDel] , nTotRes := nTotRes - x[nPVal] + x[nPRes], ) })
		oTotRes:Refresh()
	Endif
	
	SetKey( 116 , {|| RateioItem(cAlias, nRecNo) })  // Habilita a tecla de atalho F5 (Detalhes do Rateio)
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦CTB02Detalhe¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 12/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Tela para definição de rateio diferente valor                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CTB02Detalhe(aItem)
	Local oDlgRat, x, vCampos, nPos, nMaxIt, nBkRest, nReg
	Local aAlter := {}
	Local nOpcA  := 0
	Local nTot   := 0
	Local aRatV  := RetSx3Box( Posicione("SX3", 2, "CTJ_XRATVA", "X3CBox()" ),,, 1 )
	Local cTab   := If( aColBkp[nBkp,nPTpo] == "1" , "CTD", "CTT")
	Local vLegen := If( cTab == "CTD" , { "Colaborador - F4", "Colabor."}, { "C. Custo - F4", "C. Custo"})
	Local aBotao := {}
	Local cPerg1 := PADR("INCTBA0201",Len(SX1->X1_GRUPO))
	
	Private oRat, oValRest
	Private aHeader  := {}
	Private nValRest := aColBkp[nBkp,nPVal]
	
	// Se não for Visualizar ou Excluir
	If nOpcMen <> 2 .And. nOpcMen <> 5
		SetKey( 115 , {|| AdicNovos(cPerg1,aColBkp[nBkp,nPRat]=="I") })  // Habilita a tecla de atalho F4 (Novos Itens)
		
		// Adiciona botões auxiliares
		AAdd( aBotao , {"BMPINCLUIR",{|| AdicNovos(cPerg1,aColBkp[nBkp,nPRat]=="I") },vLegen[1],vLegen[2]} )
	Endif
	
	If cTab == "CTD"
		AAdd( aBotao , {"BMPGROUP"  ,{|| RateioSiata() },"SIATA - F6","SIATA"} )
		
		SetKey( 117 , {|| RateioSiata() })  // Habilita a tecla de atalho F6 (Detalhes do SIATA)
	Endif
	
	If cTab == "CTD"   // Se rateio for por Colaborador
		Pergunte(cPerg1,.F.)
		vCampos := { "CTJ_ITEMD", "CTD_DESC01", "CTJ_VALOR", "CTJ_PERCEN"}
	Else
		vCampos := { "CTJ_CCD"  , "CTT_DESC01", "CTJ_VALOR", "CTJ_PERCEN"}
	Endif
	
	//+--------------
	//| Monta o aHeader
	//+--------------
	CriaHeader(vCampos,2)
	
	If cTab == "CTD"   // Se rateio for por Colaborador
		aHeader[1,1] := "Matricula"
		aHeader[2,1] := "Nome"
	Else
		aHeader[1,1] := "C.Custo"
	Endif
	
	// Se não tiver nenhum detalhe informado
	If Len(aCols) == 1 .And. Empty(aCols[1,1])
		If !AdicNovos(cPerg1,aColBkp[nBkp,nPRat]=="I")
			Return aColBkp[nBkp,nPRes]
		Endif
	Endif
	
	// Subtrai do valor restante os valores já digitados
	aEval( aCols , {|x| If( !x[5] , nTot += x[3], ) })
	nValRest -= nTot
	nBkRest  := nValRest    // Salva o valor a ratear
	
	If aColBkp[nBkp,nPRat] == "D"   // Se permite digitar campos, caso o seja rateio de diferentes valores
		aAlter := { vCampos[1], vCampos[3] }
		nMaxIt := 9999
	Else
		nMaxIt := Len(aCols)   // Não permite inclur mais itens para valores rateados iguais
	Endif
	
	nPD := 1   // Inicializa variável de controle da deleção
	
	DEFINE MSDIALOG oDlgRat TITLE "Detalhes do Rateio" From 9,0 TO 42,80 OF oMainWnd
	
	@ 15,005 SAY Trim(aHeaBkp[1,1]) COLOR CLR_HBLUE
	@ 15,020 GET Trim(aColBkp[nBkp,1]) SIZE 30,20 WHEN .F.
	
	@ 15,055 SAY Trim(aHeaBkp[2,1]) COLOR CLR_HBLUE
	@ 15,090 GET Trim(aColBkp[nBkp,2]) SIZE 40,20 WHEN .F.
	
	@ 15,140 SAY Trim(aHeaBkp[3,1]) COLOR CLR_HBLUE
	@ 15,180 GET Trim(aColBkp[nBkp,3]) SIZE 40,20 WHEN .F.
	
	@ 15,230 SAY Trim(aHeaBkp[7,1]) COLOR CLR_HBLUE
	@ 15,265 GET Trim(aRatV[AScan(aRatV,{|x| x[2] == aColBkp[nBkp,7]}),3]) SIZE 40,20 WHEN .F.
	
	oRat := MSGetDados():New(30,05,210,310,nOpcMen,"u_CTB02LinOk(,,2)",,,.T.,aAlter,,,nMaxIt,,,,"u_CTB02DelIt(2)")
	
	@ 220,005 SAY "Valor Despesa: "
	@ 220,045 GET aColBkp[nBkp,nPVal] SIZE 60,20 PICTURE "@E 99,999,999.99" OBJECT oValRat WHEN .F.
	
	@ 220,210 SAY "Valor Restante: "
	@ 220,250 GET nValRest SIZE 60,20 PICTURE "@E 99,999,999.99" OBJECT oValRest WHEN .F.
	
	ACTIVATE MSDIALOG oDlgRat CENTERED ON INIT EnchoiceBar(oDlgRat, {|| If( CTB02TudOk(2) ,;
																								If( nValRest == 0 .Or.;
																								MsgYesNo("O valor distribuído não corresponde ao valor da despesa. Confirma ?") ,;
																								(nOpcA := 1, oDlgRat:End()), ),) },;
																								{||nOpcA:=0,oDlgRat:End()},, aBotao )
	If nOpcA == 1
		For x:=1 To Len(aCols)
			
			If x <= Len(aItem)  // Se o item do aCols for menor ou igual aos itens já existentes
				nPos := aItem[x]
				nReg := aRateio[nPos,2][1,1]
				aRateio[nPos,2] := {}  // Zera o vetor para atribuição dos dados informados na tela
			ElseIf aCols[x,5]  // Se estiver deletado
				Loop
			Else
				AAdd( aRateio , { nBkp, {}, CriaVar("CTD_ITEM"), .F.} )
				nPos := Len(aRateio)
				nReg := 0
			Endif
			
			If cTab == "CTD"                   // Se for por Colaborador
				aRateio[nPos,3] := aCols[x,1]
				
				// Pesquisa o rateio para o colaborador
				NoSIATA(aRateio[nPos,3],mv_par01,aCols[x,3],aCols[x,4],@aRateio[nPos,2])
			Else
				// Atribui Centro de Custo (Projeto)
				AAdd( aRateio[nPos,2] , { nReg, aCols[x,1], aCols[x,3], aCols[x,4], .F.} )
				
				aRateio[nPos,3] := CriaVar("CTD_ITEM")
			Endif
			aRateio[nPos,4] := aCols[x,5]      // Atribui Status de Deleção
			
			// Se não encontrou nenhum rateio no SIATA
			If Empty(aRateio[nPos,2])
				AAdd( aRateio[nPos,2] , { nReg, Space(TamSX3("Z1_CC")[1]), 0, 0, .T.} )
			Endif
		Next
	Else
		nValRest := nBkRest                   // Se cancelado, restaura o valor a ratear
	Endif
	
	SetKey( 115 , {|| Nil })  // Desabilita a tecla de atalho F4 (Novos Itens)
	SetKey( 117 , {|| Nil })  // Desabilita a tecla de atalho F6 (Detalhes do SIATA)
	
Return nValRest

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ NoSIATA    ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 20/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Busca o rateiodo colaborador no SIATA                         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function NoSIATA(cMat,dData,nVal,nPer,aVet)
	Local y
	Local nCC  := 0
	Local nTot := 0
	
	SZ1->(DbSetOrder(2))
	SZ1->(DbSeek(cFilSZ1+cMat+Dtos(dData),.T.))
	While !SZ1->(Eof()) .And. SZ1->(Z1_FILIAL+Z1_MAT+DTOS(Z1_DATA)) == cFilSZ1+cMat+Dtos(dData)
		nCC++
		If nCC > Len(aVet)
			AAdd( aVet , { 0, "", 0, 0, .F.} )
			nCC := Len(aVet)
		Endif
		// Data: 17-03-2025 | Autor: Julio C. Ribeiro
		// Modif: Alterado a quantidade de casas decimais de 5 -> 9 na funç2ao ROUND 
		aVet[nCC] := { aVet[nCC,1], SZ1->Z1_CC, 0, Round(SZ1->Z1_PERC * nPer,9), .F.}
		nTot += aVet[nCC,4]
		SZ1->(dbSkip())
	Enddo
	
	If nCC > 0
		// Calcula a diferença de percentual no último item
		aVet[nCC,4] += nPer - nTot
		
		// Recalcula os valores de todos os itens
		nTot := 0
		For y:=1 To Len(aVet)
			If y <= nCC
				aVet[y,3] := Round(nVal * (aVet[y,4] / nPer),2)
				nTot += aVet[y,3]
			Else  // Se itens ultrapassou o máximo encontrado
				aVet[y,5] := .T.  // Deleta os itens não contidos no rateio
			Endif
		Next
		
		// Calcula a diferença de valor no último item
		aVet[nCC,3] += nVal - nTot
	Endif
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AdicNovos  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 12/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Exibe tela para inclusão de novos colaboradores               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function AdicNovos(cPerg1,lIgual)
	Local cArq, cInd
	Local cAlias  := Alias()
	Local cTab    := If( aColBkp[nBkp,nPTpo] == "1" , "CTD", "CTT")
	Local aCpoBrw := {}
	Local aStruct := CTD->(dbStruct())
	Local cFilCTT := CTT->(XFILIAL("CTT"))
	Local nOpcA   := 0
	Local cBusca  := Space(30)
	
	Local oDlg, oBtn1, oBtn2, oBusca, nLin
	Local cMarca  := "x"
	Local nMarca  := 0
	Local cTmp    := "TMP"
	Local nTot    := 0
	Local nPer    := 0
	Local cCbx    := space(30)
	Local aCbx    := {"Código", "Descrição"}
	Local oCbx    := Nil
	Local x
	Private oMark  := Nil
	Private vColor := { CLR_GREEN, CLR_HBLUE, CLR_HRED}
	
	SetKey( 115 , {|| Nil })  // Desabilita a tecla de atalho F4 (Novos Itens)
	
	// Cria tabela temporária para marcação dos itens
	AAdd( aStruct , { "CTD_VALRAT", "N", 14, 2} )  // Adiciona campo para valor do rateio
	cArq := CriaTrab(aStruct,.T.)
	cInd := Criatrab(Nil,.F.)
	
	Use &cArq Alias TMP New Exclusive
	IndRegua("TMP", cInd, "CTD_ITEM",,, "Aguarde selecionando registros....")
	
	If cTab == "CTD"  // Se rateio for por Colaborador
		Valid1Perg(cPerg1)
		If Pergunte(cPerg1,.T.)
			SZ1->(dbSetOrder(1))
			If SZ1->(dbSeek(cFilSZ1+Dtos(mv_par01)))
				
				While !SZ1->(Eof()) .And. cFilSZ1 == SZ1->Z1_FILIAL .And. SZ1->Z1_DATA == mv_par01
					
					IncProc()
					
					// Filtra pela selecao de 1=Colaborador, 2=Estagiario, 3=Todos. Verifica também se o registro já não existe na tela
					If (mv_par03 == 3 .Or. SZ1->Z1_FUNCAO == Str(mv_par03,1)) .And. AScan( aCols , {|x| x[1] == SZ1->Z1_MAT }) == 0
						//- Verificando se o colaborador esta no SIATA e o filtro por departamento
						If CTD->(DbSeek(xFilial("CTD")+SZ1->Z1_MAT))
							If !TMP->(dbSeek(CTD->CTD_ITEM)) .And. (mv_par02 == 3 .Or. CTD->CTD_DEPTO == "3" .Or. Str(mv_par02,1) == CTD->CTD_DEPTO)
								RecLock("TMP",.T.)
								For x:=1 To CTD->(FCount())
									FieldPut( x , CTD->(FieldGet(x)) )
								Next
								TMP->CTD_OK := " "
								MsunLock()
							Endif
						Endif
					Endif
					
					SZ1->(DbSkip())
				Enddo
			Else
				Aviso( "INVÁLIDO", "Não foi encontrado rateio do SIATA nesta data !", {"Ok"} )
			Endif
		Endif
	Else
		CTT->(dbSetOrder(1))
		CTT->(dbSeek(cFilCTT,.T.))
		While !CTT->(Eof()) .And. cFilCTT == CTT->CTT_FILIAL
			// Se for Analitico e não tiver bloqueado
			If CTT->CTT_CLASSE == "2" .And. CTT->CTT_BLOQ <> "1
				// Se o centro de custo não existe no rateio
				If AScan( aCols , {|x| x[1] == CTT->CTT_CUSTO }) == 0
					RecLock("TMP",.T.)
					TMP->CTD_ITEM   := CTT->CTT_CUSTO
					TMP->CTD_DESC01 := CTT->CTT_DESC01
					TMP->CTD_OK     := " "
					MsunLock()
				Endif
			Endif
			CTT->(dbSkip())
		Enddo
	Endif
	
	dbSelectArea("TMP")
	dbClearIndex()
	FErase(cInd+OrdBagExt())
	
	IndRegua("TMP", cInd, "CTD_ITEM",,, "Aguarde selecionando registros....")
	
	If !TMP->(Eof()) .And. !TMP->(Bof())
		dbGoTop()
		
		// Adiciona os campos a serem exibidos no Browsed de Seleção
		aAdd( aCpoBrw, { "CTD_OK"    ,, ""          , "@!" } )
		aAdd( aCpoBrw, { "CTD_ITEM"  ,, If( cTab=="CTD", "Matricula", "C. Custo" ) , "@!" } )
		aAdd( aCpoBrw, { "CTD_DESC01",, If( cTab=="CTD", "Nome"     , "Descrição") , "@!" } )
		aAdd( aCpoBrw, { "CTD_VALRAT",, "Valor", "@E 999,999.99" } )
		
		DEFINE MSDIALOG oDlg TITLE "Seleção de "+If(cTab=="CTD","Colaboradores","Centro Custos") FROM 00,00 TO 407,530 PIXEL
		
		@ 05,05 SAY "Ordenar"
		@ 05,30 MSCOMBOBOX oCbx VAR cCbx ITEMS aCbx SIZE 075, 65 OF oDlg PIXEL ON CHANGE fValCombo(cInd, cCbx)
		
		@ 20,05 SAY "Pesquisar"
		@ 20,30 GET cBusca SIZE 120,20 PICTURE "@!" VALID BuscaItem(@oMark,@cBusca, cCbx) OBJECT oBusca
		
		oMark:= MsSelect():New( cTmp, "CTD_OK",,aCpoBrw,, cMarca, { 035, 005, 185, 260 } ,,, )
		
		oMark:oBrowse:Refresh()
		oMark:bAval               := {|| (Marcar(cTmp,cMarca,@nMarca,@nTot,.F.,lIgual), oMarca:Refresh(), oTotal:Refresh(), oTotMark:Refresh(),;
													oMark:oBrowse:Refresh() ) }
		oMark:oBrowse:lHasMark    := .T.
		oMark:oBrowse:lCanAllMark := .T.
		oMark:oBrowse:bAllMark    := {|| ( MarcaTudo(cTmp,cMarca,@nMarca,@nTot,lIgual), oMarca:Refresh(), oTotal:Refresh(), oTotMark:Refresh(),;
													oMark:oBrowse:Refresh(.T.) ) }
		
		@ 190,005 SAY "Marcados: " OBJECT oTotMark COLOR vColor[1]
		@ 190,035 GET nMarca SIZE 30,20 PICTURE "@E 999999" OBJECT oMarca WHEN .F.
		@ 190,070 GET nTot   SIZE 60,20 PICTURE "@E 9,999,999.99" OBJECT oTotal WHEN .F.
		
		DEFINE SBUTTON oBtn1 FROM 190,140 TYPE 1 ACTION If( nMarca > 0 , (nOpcA := 1,oDlg:End()), Alert("Não foi marcado nenhum item !")) ENABLE
		DEFINE SBUTTON oBtn2 FROM 190,170 TYPE 2 ACTION (nOpcA := 0,oDlg:End()) ENABLE
		
		oMark:oBrowse:SetFocus()
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
		If nOpcA == 1 .And. nMarca > 0
			nTot := 0
			TMP->(dbGoTop())
			While !TMP->(Eof())
				If !Empty(CTD_OK)   // Se o item foi marcado
					nTot += TMP->CTD_VALRAT
					If Len(aCols) > 1 .Or. !Empty(aCols[1,1])  // Identifica se o 1o item está preenchido
						aAdd(aCols,Array(Len(aHeader)+1))
					Endif
					nLin := Len(aCols)
					aCols[nLin,1] := TMP->CTD_ITEM
					aCols[nLin,2] := TMP->CTD_DESC01
					aCols[nLin,3] := TMP->CTD_VALRAT
					// Data: 17-03-2025 | Autor: Julio C. Ribeiro
					// Modif: Alterado a quantidade de casas decimais de 5 -> 9 na funç2ao ROUND 
					aCols[nLin,4] := Round(aCols[nLin,3]/M->CTJ_XTOTAL,9)
					aCols[nLin,5] := (nTot > nValRest)
				Endif
				TMP->(dbSkip())
			Enddo
			
			If lIgual
				// Recalcula o valor
				nMarca := Len(aCols)
				// Data: 17-03-2025 | Autor: Julio C. Ribeiro
				// Modif: Alterado a quantidade de casas decimais de 5 -> 9 na funç2ao ROUND 
				aEval( aCols , {|x| x[3] := Round(aColBkp[nBkp,nPVal]/nMarca,2), x[4] := Round(x[3]/M->CTJ_XTOTAL,9), nTot += x[3], nPer += x[4] } )
				
				// Acerta a diferença de decimal no último item
				aCols[nMarca,3] += aColBkp[nBkp,nPVal] - nTot
				aCols[nMarca,4] += aColBkp[nBkp,nPPer] - nPer
			Endif
			
			aSort(aCols,,,{|x,y| x[2] < y[2] })
		Endif
	Endif
	TMP->(dbCloseArea())
	FErase(cArq+GetDBExtension())
	FErase(cInd+OrdBagExt())
	dbSelectArea(cAlias)
	
	SetKey( 115 , {|| AdicNovos(aColBkp[nBkp,nPRat]=="I") })  // Habilita a tecla de atalho F4 (Novos Itens)
	
Return nOpcA == 1

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ BuscaItem  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 13/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Posiciona no registro da tabela temporária de seleção         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function BuscaItem(oMark,cBusca, cCbx )
	TMP->(dbSeek(AllTrim(cBusca),.T.))
	cBusca := iIf(cCbx == "Código", Space(30), Space(30))
	oMark:oBrowse:SetFocus()
	oMark:oBrowse:Refresh()
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MarcaTudo  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 13/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Permite a marcação de todos os itens da tabela de seleção     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function MarcaTudo(cAlias,cMarca,nMarca,nTot,lIgual)
	Local nReg  := (cAlias)->(Recno())
	Local lTudo := (nMarca <> (cAlias)->(RecCount()))   // Identifica se todos os itens estão marcados
	
	// Se nem todos os itens estiverem marcados, então marca tudo. Senão, desmarca tudo
	nMarca := If( lTudo , 0, nMarca)
	nTot   := If( lTudo , 0, nTot  )
	
	dbSelectArea(cAlias)
	dbGoTop()
	While !Eof()
		Marcar(cAlias,cMarca,@nMarca,@nTot,lTudo,lIgual)
		dbSkip()
	Enddo
	dbGoTo(nReg)
	
Return .T.

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ Marcar     ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 13/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Permite a marcação de um item específico da tabela de seleção ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Marcar(cAlias,cMarca,nMarca,nTot,lTudo,lIgual)
	Local nValor := 0
	
	RecLock(cAlias,.F.)
	(cAlias)->CTD_OK := If( lTudo .Or. Empty(CTD_OK) , cMarca, Space(Len(CTD_OK)))
	
	If Empty((cAlias)->CTD_OK)
		nMarca--
		nTot -= (cAlias)->CTD_VALRAT
	Else
		If lIgual .Or. lTudo .Or. ValorDif((cAlias)->CTD_DESC01,@nValor)   // Se foi confirmado o valor
			nMarca++
			nTot += nValor
		Else
			(cAlias)->CTD_OK := Space(Len(CTD_OK))
		Endif
	Endif
	(cAlias)->CTD_VALRAT := nValor
	MsUnLock()
	
	nMarca := If( nMarca < 0, 0, nMarca)
	nTot   := If( nTot   < 0, 0, nTot  )
	
	If nTot < aColBkp[nBkp,nPVal]
		@ 190,005 SAY "Marcados: " OBJECT oTotMark COLOR vColor[1]
	ElseIf nTot > aColBkp[nBkp,nPVal]
		@ 190,005 SAY "Marcados: " OBJECT oTotMark COLOR vColor[3]
	Else
		@ 190,005 SAY "Marcados: " OBJECT oTotMark COLOR vColor[2]
	Endif
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Rotina    ¦ ValorDif   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 08/09/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Efetua leitura do valor do rateio diferente                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValorDif(cTitulo,nValor)
	Local oVal
	Local nOpc := 0
	
	DEFINE MSDIALOG oVal TITLE AllTrim(cTitulo) From 8,70 To 11,99 OF oMainWnd
	
	@ 05,005 SAY "Valor"  PIXEL OF oVal
	@ 05,030 GET nValor Picture "@E 999,999.99" VALID If( NaoVazio(nValor) .And. Positivo(nValor), (nOpc:=1,oVal:End(),.T.), .F.) SIZE 60,10 PIXEL OF oVal
	
	@ 30,010 BUTTON oBut1 PROMPT "&Ok" SIZE 30,12 OF oVal PIXEL ACTION (nOpc:=1,oVal:End())
	
	ACTIVATE MSDIALOG oVal CENTERED
	
	If nOpc <> 1   // Caso tenha sido cancelado
		nValor := 0
	Endif
	
Return nOpc == 1

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ TotRateado ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 16/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Soma os valores já rateados para o item                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function TotRateado(nPos)
	Local x, y
	Local nRet := 0
	
	For x:=1 To Len(aRateio)
		// Se o rateio não estiver deletado
		If !aRateio[x,4] .And. aRateio[x,1] == nPos
			aEval( aRateio[x,2] , {|y| If( !y[5] , nRet += y[3], ) } )
		Endif
	Next
	
Return nRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ RateioSiata¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 18/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Exibe o valor do colaborador rateado pelo SIATA               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function RateioSiata()
	Local oSia, oBtn1, oItem, cItem, x, y
	Local nTot  := 0
	Local aAux  := {}
	Local aItem := {}
	
	SetKey( 117 , {|| Nil })  // Desabilita a tecla de atalho F6 (Detalhes do SIATA)
	
	// Pesquisa o rateio para o colaborador
	NoSIATA(aCols[n,1],mv_par01,aCols[n,3],aCols[n,4],@aAux)
	
	// Adiciona os itens do SIATA para o colaborador
	aEval( aAux , {|y| AAdd( aItem , { y[2], y[3], y[4]} ) })
	
	// Se ainda não foi gravado no aRateio, pesquisa no aRateio
	If Empty(aItem)
		// Pesquisa o detalhe do SIATA nos rateios já gravados
		For x:=1 To Len(aRateio)
			// Se for a mesma do rateio e mesma matrícula
			If nBkp == aRateio[x,1] .And. aCols[n,1] == aRateio[x,3]
				// Adiciona os itens do SIATA para o colaborador
				aEval( aRateio[x,2] , {|y| AAdd( aItem , { y[2], y[3], y[4]} ) })
			Endif
		Next
	Endif
	
	DEFINE MSDIALOG oSia TITLE "Detalhes do SIATA" From 9,0 TO 32,40 OF oMainWnd
	
	@ 05,005 SAY Trim(aHeader[1,1]) COLOR CLR_HBLUE
	@ 05,030 GET Trim(aCols[n,1]) SIZE 25,20 WHEN .F.
	@ 05,060 SAY Trim(aHeader[2,1]) COLOR CLR_HBLUE
	@ 05,080 GET Trim(aCols[n,2]) SIZE 70,20 WHEN .F.
	
	@ 20,005 LISTBOX oItem VAR cItem Fields HEADER "Projeto","Valor", "%" SIZE 150,130 PIXEL OF oSia
	
	oItem:SetArray(aItem)
	oItem:bLine := { || { aItem[oItem:nAt,1], Transform(aItem[oItem:nAt,2],"@E 999,999.99"), Transform(aItem[oItem:nAt,3],"@E 99.99999")}}
	
	DEFINE SBUTTON oBtn1 FROM 155,70 TYPE 1 ACTION oSia:End() ENABLE
	
	ACTIVATE MSDIALOG oSia CENTERED
	
	SetKey( 117 , {|| RateioSiata() })  // Habilita a tecla de atalho F6 (Detalhes do SIATA)
Return

// WERNMESON EM 02/09/10
Static Function fValCombo(cInd, cCbx)
	
	dbSelectArea("TMP")
	dbClearIndex()
	FErase(cInd+OrdBagExt())
	
	If cCbx == "Código"
		IndRegua("TMP", cInd, "CTD_ITEM",,, "Aguarde selecionando registros....")
	Else
		IndRegua("TMP", cInd, "CTD_DESC01",,, "Aguarde selecionando registros....")
	EndIf
	oMark:oBrowse:Refresh()
	
Return Nil

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PosObjetos ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 31/08/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Inicializa as dimensões da tela para posicionar os objetos    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PosObjetos(aSize,aPosObj)
	Local aInfo
	Local aObjects := {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	AAdd( aObjects, { 100, 040, .t., .f. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )
	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
Return

Static Function Valid1Perg(cPerg)
	u_INPutSX1(cPerg,"01",PADR("Data do SIATA        ",29)+"?","","","mv_ch1","D",08,0,0,"G","","   " ,"","","mv_par01")
	u_INPutSX1(cPerg,"02",PADR("Departamento         ",29)+"?","","","mv_ch2","N",01,0,0,"C","","   " ,"","","mv_par02",;
							"Administracao","","","","Projeto","","","Todos")
	u_INPutSX1(cPerg,"03",PADR("Funcao               ",29)+"?","","","mv_ch3","N",01,0,0,"C","","   " ,"","","mv_par03",;
							"Colaborador","","","","Estagiario","","","Todos")
Return
