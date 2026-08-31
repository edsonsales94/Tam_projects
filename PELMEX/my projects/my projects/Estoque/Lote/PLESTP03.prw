
#INCLUDE "Protheus.ch"

Static __cDocTransf := ""

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ PLESTP03   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 20/08/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Processa a leitura física das mercadorias de entrada          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLESTP03()
	Local oDlg, cSeek, aCabec
	Local oFont1 := TFont():New("Courier New", 8.5,15,.T.,.T.,,,15)
	Local oFont2 := TFont():New("Courier New", 7.5,15,.T.,.T.,,,15)
	Local oOk    := LoadBitmap( GetResources(), "LBOK" )
	Local oNo    := LoadBitmap( GetResources(), "LBNO" )
	Local nOpcA  := 0
	Local lTudoLido := .F.
		
	Private oEmi, oFor, oDoc, oSer, oLbx1, oLbx2, oCbx
	Private cCadastro := "Entrada Física de Mercadorias"
	Private cNumNota  := Space(TamSX3("F1_DOC"  )[1])
	Private cSerNota  := Space(TamSX3("F1_SERIE")[1])
	Private nQtdBarra := 0
	Private vItens    := {}
	Private vVolumes  := {}
	Private aVolItem  := {}
	Private dEmissao  := Ctod("")
	Private cFornece  := Space(TamSX3("F1_FORNECE")[1])
	Private cItem     := ""
	Private nQuant    := 0
	Private nMult     := 1
	Private cProduto  := ""
	Private cDescri   := ""
	Private lDigita   := .T.
	Private aAltera   := {}
	Private cTMSai    := GetMV("MV_XTMSAI",.F.,"501")   // TM de saída
	Private cTMEnt    := GetMV("MV_XTMENT",.F.,"101")   // TM de entrada
	Private cPictQtd  := X3Picture("D3_QUANT")
	Private lCheck    := .F.
	
	// Verifica se os TM existem na base
	SF5->(dbSetOrder(1))
	If !SF5->(dbSeek(XFILIAL("SF5")+cTMSai)) .Or. !SF5->(dbSeek(XFILIAL("SF5")+cTMEnt))
		Alert("Os tipos de movimentação de saída ("+cTMSai+") ou de entrada ("+cTMEnt+") não existem na base !")
		Return
	Endif
	
	aCabec := { "Item", "Produto", "Descrição", "UM", "Quantidade", "Qtd.Fisica"}
	
	AAdd( vItens   , SD1->({ Space(Len(D1_ITEM)), Space(Len(D1_COD)), Space(50), Space(Len(D1_UM)), 0, 0, Space(Len(D1_NUMSEQ)), lCheck}) )
	AAdd( vVolumes , { lCheck, Space(03), Space(Len(SD1->(D1_NUMSEQ+D1_ITEM))+3), 0} )
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From 9,0 TO 46,125 OF oMainWnd
	
	@ 010,005 SAY "Nota Fiscal"          SIZE 40,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
	@ 009,055 MSGET oDoc   VAR cNumNota  Picture "@!" F3 "SF1NFE" VALID BuscaNota(@cSeek,@lTudoLido) SIZE 60,10 PIXEL OF oDlg FONT oFont2 WHEN lDigita
	@ 010,125 SAY "Serie"                SIZE 60,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
	@ 009,155 MSGET oSer   VAR cSerNota  Picture "@!" /*VALID CodigoBarras()*/ SIZE 20,10 PIXEL OF oDlg FONT oFont2 WHEN lDigita
	@ 010,190 SAY "Emissão"              SIZE 60,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
	@ 010,225 SAY oEmi     VAR dEmissao  Picture "@!" SIZE 40,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HRED
	@ 010,265 SAY "Fornecedor"           SIZE 60,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
	@ 010,310 SAY oFor     VAR cFornece  Picture "@!" SIZE 120,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HRED
	
	oLbx1 := TWBrowse():New(025,002,460,110,,aCabec,,oDlg,,,,{|| MostraItem() },,,oFont1,,,,,,,.T.)
	
	oLbx1:SetArray( vItens )
	oLbx1:bLine := {|| {	vItens[oLbx1:nAt,1],;
								vItens[oLbx1:nAt,2],;
								vItens[oLbx1:nAt,3],;
								vItens[oLbx1:nAt,4],;
								Transform(vItens[oLbx1:nAt,5],cPictQtd),;
								Transform(vItens[oLbx1:nAt,6],cPictQtd) } }
	
	@ 139,005 SAY "Item"  SIZE 20,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
	@ 139,030 SAY oIte VAR cItem SIZE 150,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HRED
	
	@ 139,313 SAY "Quantidade"  SIZE 40,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
	@ 137,358 MSGET oQtd   VAR nQuant  Picture cPictQtd VALID Vazio() .Or. Positivo() SIZE 75,10 PIXEL OF oDlg FONT oFont2 WHEN !lTudoLido
	
	@ 139,435 SAY "X"  SIZE 10,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
	@ 137,443 MSGET oMul   VAR nMult  Picture "@E 999" VALID AddQuantidade() SIZE 20,10 PIXEL OF oDlg FONT oFont2 WHEN !lTudoLido
	
	@ 152,002 LISTBOX oLbx2 VAR cVar2 FIELDS HEADER "","Volume","Lote","Quantidade" SIZE 460,100 OF oDlg PIXEL FONT oFont1 ;
	ON dblClick( vVolumes[oLbx2:nAt,1]:=!vVolumes[oLbx2:nAt,1] )
		
	oLbx2:SetArray( vVolumes )
	oLbx2:bLine := {|| { Iif(vVolumes[oLbx2:nAt,1],oOk,oNo), vVolumes[oLbx2:nAt,2], vVolumes[oLbx2:nAt,3], Transform(vVolumes[oLbx2:nAt,4],cPictQtd) } }
	
	DEFINE SBUTTON FROM 153,466 TYPE 3 ENABLE ACTION ApagaVolume() OF oDlg WHEN !lDigita .And. !lTudoLido
	DEFINE SBUTTON FROM 168,466 TYPE 6 ENABLE ACTION ImprimeVolume() OF oDlg WHEN !lDigita
	
	@ 257,005 CHECKBOX oCbx VAR lCheck PROMPT "Marcar / Desmarcar" SIZE 60,15 OF oDlg PIXEL ON;
	CLICK (aEval(vVolumes,{|x|x[1]:=lCheck}), oLbx2:Refresh(), vItens[oLbx1:nAt,8]:=lCheck) WHEN !lDigita
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| nOpcA:=1, oDlg:End() },{|| oDlg:End() })
	
	If nOpcA == 1 .And. !lTudoLido
		Gravacao(cSeek)
	Endif
		
Return

Static Function BuscaNota(cSeek,lTudoLido)
	Local nX
	Local nLido := 0
	Local lRet  := ExistCpo("SF1",cNumNota+cSerNota)
	
	If lRet
		cSeek := SF1->(XFILIAL("SF1"))+cNumNota+cSerNota
		
		SF1->(dbSetOrder(1))
		If SF1->(F1_FILIAL+F1_DOC+F1_SERIE) <> cSeek
			SF1->(dbSeek(cSeek))   // Posiciona na nota fiscal de entrada
		Endif
		
		cSeek := SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
		
		ZeraVetor(@vItens)   // Elimina todos os itens da tela
		
		// Posiciona no cadastro de fornecedores
		SA2->(dbSetOrder(1))
		SA2->(dbSeek(XFILIAL("SA2")+SF1->(F1_FORNECE+F1_LOJA)))
		
		aVolItem := {}
		
		// Carrega os itens da nota fiscal de entrada
		SD1->(dbSetOrder(1))
		SD1->(dbSeek(cSeek,.T.))
		While !SD1->(Eof()) .And. cSeek == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
			AAdd( vItens , SD1->({ D1_ITEM, D1_COD, PADR(Posicione("SB1",1,XFILIAL("SB1")+D1_COD,"B1_DESC"),50), D1_UM, D1_QUANT, 0, D1_NUMSEQ, lCheck}) )
			SD1->(dbSkip())
		Enddo
		
		ASort( vItens ,,, {|x,y| x[1] < y[1] } )   // Ordena por item
		
		For nX:=1 To Len(vItens)
			// Pesquisa os volumes do item
			SZ6->(dbSetOrder(1))
			If SZ6->(dbSeek(cSeek+vItens[nX,1],.T.))
				
				nLido := 1    // Altera status para item já em processo de leitura
				
				AAdd( aVolItem , { nX, {}, SZ6->Z6_PRODUTO} )    // Adiciona o item
				
				While !SZ6->(Eof()) .And. cSeek+vItens[nX,1] == SZ6->(Z6_FILIAL+Z6_DOC+Z6_SERIE+Z6_FORNECE+Z6_LOJA+Z6_ITEM)
					
					AAdd( aVolItem[Len(aVolItem),2] , { lCheck, SZ6->Z6_VOLUME, SZ6->Z6_LOTECTL, SZ6->Z6_QUANT} )    // Adiciona os volumes do item
					vItens[nX,6] += SZ6->Z6_QUANT
					AAdd( aAltera  , SZ6->(Recno()) )   // Adiciona o item gravado na base
					
					If SZ6->Z6_LOTEOK <> "S"   // Se ainda não foi transferido
						nLido := 0    // Retorna ao status para ser processado
					ElseIf nLido <> 0
						nLido := 3    // Atualiza status como todos processados
					Endif
					
					SZ6->(dbSkip())
				Enddo
			Endif
		Next
		
		dEmissao := SF1->F1_DTDIGIT
		cFornece := SA2->(A2_COD+" - "+A2_LOJA+" - "+A2_NOME)
		
		oEmi:Refresh()
		oFor:Refresh()
		oLbx1:Refresh()
		
		MostraItem()
		
		If !Empty(aVolItem)
			DigitaNota()   // Define se abre a nota para digitação
		Endif
		
		If lTudoLido := (nLido == 3)
			MsgAlert("Essa nota já foi transferida !")
		Endif
	Endif
	
Return lRet

Static Function MostraItem()
   Local nPos := AScan( aVolItem , {|x| x[1] == oLbx1:nAt } )    // Pesquisa os volumes digitados do item
	
	ZeraVetor(@vVolumes)   // Elimina todos os itens da tela
	
	lCheck := vItens[oLbx1:nAt,8]    // Atualiza o check do item
	oCbx:Refresh()
	
	If nPos == 0   // Se não achou
		AAdd( vVolumes , { lCheck, Space(03), Space(Len(SD1->(D1_NUMSEQ+D1_ITEM))+3), 0} )
	Else
		// Adiciona os volumes armazenados para exibição
		aEval( aVolItem[nPos,2] , {|x| AAdd( vVolumes , aClone(x) ) } )
		
		aEval( vVolumes , {|x| x[1] := lCheck } )    // Atualiza o check dos volumes
	Endif
	
	cItem := vItens[oLbx1:nAt,1]+" - "+Trim(vItens[oLbx1:nAt,2])+" - "+Trim(vItens[oLbx1:nAt,3])
	
	oIte:Refresh()
	oLbx2:Refresh()
	
Return

Static Function AddQuantidade()
   Local nPos := AScan( aVolItem , {|x| x[1] == oLbx1:nAt } )    // Pesquisa os volumes digitados do item
	Local lRet := .F.  //Vazio()
	
	If lRet
		//oLbx2:SetFocus()
	ElseIf (lRet := Positivo()) .And. nQuant > 0
		For nX:=1 To nMult
			// Zera o vetor de volumes caso não tenha sido digitado nenhum ainda
			If Len(vVolumes) == 1 .And. Empty(vVolumes[1,2])
				ZeraVetor(@vVolumes)   // Elimina todos os itens da tela
			Endif
	
			// Adiciona o volume digitado
			AAdd( vVolumes , { lCheck, StrZero(Len(vVolumes)+1,3), vItens[oLbx1:nAt,7]+vItens[oLbx1:nAt,1]+StrZero(Len(vVolumes)+1,3), nQuant} )
			
			// Salva o volume no vetor por item
			If nPos == 0
				AAdd( aVolItem , { oLbx1:nAt, , vItens[oLbx1:nAt,2]} )
				nPos := Len(aVolItem)
			Endif
			aVolItem[nPos,2] := aClone(vVolumes)
			vItens[oLbx1:nAt,6] += nQuant
			
			// Passa para o próximo item caso tenha sido concluída a leitura
			//If vItens[oLbx1:nAt,6] >= vItens[oLbx1:nAt,5] .And. oLbx1:nAt < Len(vItens)
			//	oLbx1:nAt++
			//	MostraItem()   // Atualiza os objetos em tela
			//Endif
		Next
		
		oLbx2:Refresh()
		
		oLbx1:Refresh()
		
		nQuant := 0
		nMult  := 1
		oQtd:SetFocus()
		
		DigitaNota()   // Define se abre a nota para digitação
	Endif
	
Return lRet

Static Function ApagaVolume()
	Local aAux := aClone(vVolumes)
	Local nCnt := 0
	Local nPos := oLbx2:nAt
	
	If vItens[oLbx1:nAt,6] > 0
		aEval( vVolumes , {|x| If(x[1],nCnt++,) } )   // Conta o número de itens marcados
		
		If MsgYesNo("Confirma exclusão do"+If( nCnt > 0 , "s volumes marcados", " volume "+vVolumes[nPos,2])+"?")
			If nCnt > 0
				nPos := 0
				aEval( aAux , {|x| nPos++, ApagaItem(@nPos) } )
			Else
				vVolumes[nPos,1] := .T.
				ApagaItem(nPos)
			Endif
			
			nPos := 0
			MsgRun("Os volumes foram recalculados...","Aguarde...",{|| aEval(vVolumes,{|x| nPos++,x[2]:=StrZero(nPos,Len(SZ6->Z6_VOLUME)) }), Sleep(1000) })
			
			oLbx1:Refresh()
			oLbx2:Refresh()
		Endif
	Else
		MsgAlert("Não existem volumes a serem excluídos !")
	Endif
	
Return

Static Function ApagaItem(nPos)
	If nPos <= Len(vVolumes) .And. vVolumes[nPos,1]     // Se está marcado para deleção
		vItens[oLbx1:nAt,6] -= vVolumes[nPos,4]   // Atualiza a quantidade total já lida
		
		ADel(vVolumes,nPos)
		ASize(vVolumes,Len(vVolumes)-1)
		
		If Empty(vVolumes)   // Adiciona item vazio
			AAdd( vVolumes , { lCheck, Space(03), Space(Len(SD1->(D1_NUMSEQ+D1_ITEM))+3), 0} )
		Endif
		
		aVolItem[AScan( aVolItem , {|x| x[1] == oLbx1:nAt } ),2] := aClone(vVolumes)   // Atualiza o vetor de volumes dos itens
		
		If nPos >= Len(vVolumes)   // Caso tenha sido excluído o último item, ajusta a posição lógica do cursor
			oLbx2:nAt := Len(vVolumes)
		Endif
		
		nPos--   // Retroage a posição para permanecer no mesmo item
	Endif
Return

Static Function DigitaNota()
	If lDigita   // Após informar a 1a quantidade, não permite mais mudar a nota
		lDigita := .F.
		oDoc:Refresh()
		oSer:Refresh()
	Endif
Return

Static Function ZeraVetor(aVetor)
	While !Empty(aVetor)
		ADel(aVetor,Len(aVetor))
		ASize(aVetor,Len(aVetor)-1)
	Enddo
Return

Static Function Gravacao(cSeek)
	Local nX, nY, nPos, nQuant, aDocum
	Local cLote   := AllTrim(SF1->F1_DOC)+AllTrim(SF1->F1_SERIE)
	Local aDocTrf := {"","",""}
	Local aTransf := {}
	Local aSaidas := {}
	Local aEntrad := {}
	Local aSaldo  := {}
	Local lTransf := .F.
	Local lPrint  := .F.
	
	Begin Transaction
	
		SZ6->(dbSetOrder(1))
		For nX:=1 To Len(aVolItem)
			For nY:=1 To Len(aVolItem[nX,2])
				If SZ6->(dbSeek(cSeek+vItens[aVolItem[nX,1],1]+aVolItem[nX,2][nY,2]))
					RecLock("SZ6",.F.)
				Else
					RecLock("SZ6",.T.)
					SZ6->Z6_FILIAL  := SF1->F1_FILIAL
					SZ6->Z6_DOC     := SF1->F1_DOC
					SZ6->Z6_SERIE   := SF1->F1_SERIE
					SZ6->Z6_FORNECE := SF1->F1_FORNECE
					SZ6->Z6_LOJA    := SF1->F1_LOJA
					SZ6->Z6_ITEM    := vItens[aVolItem[nX,1],1]
					SZ6->Z6_PRODUTO := aVolItem[nX,3]
					SZ6->Z6_VOLUME  := aVolItem[nX,2][nY,2]
					SZ6->Z6_LOTEOK  := "N"
				Endif
				SZ6->Z6_LOTECTL := vItens[aVolItem[nX,1],7]+SZ6->(Z6_ITEM+Z6_VOLUME)
				SZ6->Z6_QUANT   := aVolItem[nX,2][nY,4]
				MsUnLock()
				
				lTransf := If( lTransf , .T., SZ6->Z6_LOTEOK <> "S")
				
				// Elimina os itens alterados na gravação
				If (nPos := AScan( aAltera , SZ6->(Recno()) )) > 0
					ADel(aAltera,nPos)
					ASize(aAltera,Len(aAltera)-1)
				Endif
			Next
		Next
		
		// Exclui os registros não alterados na base
		For nX:=1 To Len(aAltera)
			SZ6->(dbGoTo(aAltera[nX]))   // Posiciona no registro
			RecLock("SZ6",.F.)
			dbDelete()
			MsUnLock()
		Next
		
	End Transaction
	
	If lTransf .And. MsgYesNo("Leitura gravada com sucesso. Deseja processar o acerto do Lote?")   // Se tem itens a serem transferidos de lote
		Private lMsErroAuto := .F.
		
		//Cabecalho a Incluir
		aAuto := {}
		aAdd( aAuto , { "", dDataBase})  //Cabecalho
		
		// Posiciona no item da nota fiscal
		SD1->(dbSetOrder(1))
		SD1->(dbSeek(cSeek,.T.))
		While !SD1->(Eof()) .And. cSeek == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
				
			// Adiciona o item para processar o cálculo do saldo do mesmo
			AAdd( aSaldo , { SD1->D1_ITEM, SD1->D1_COD, SD1->(Recno()), "", SD1->D1_QUANT})
			nPos := Len(aSaldo)
			
			// Processa as transferências de lotes dos itens
			SZ6->(dbSeek(cSeek+SD1->D1_ITEM,.T.))
			While !SZ6->(Eof()) .And. cSeek+SD1->D1_ITEM == SZ6->(Z6_FILIAL+Z6_DOC+Z6_SERIE+Z6_FORNECE+Z6_LOJA+Z6_ITEM)
				
				// Ignora os itens já processados e os itens sem lote
				If SZ6->Z6_LOTEOK == "S" .Or. Empty(SD1->D1_LOTECTL) .Or. SD1->D1_COD <> SZ6->Z6_PRODUTO
					SZ6->(dbSkip())
					Loop
				Endif
				
				// Efetuada o cálculo de saldo a ser ajustado para o item
				If SZ6->Z6_QUANT <= aSaldo[nPos,5]
					nQuant := SZ6->Z6_QUANT
				Else
					nQuant := aSaldo[nPos,5]
					
					If !Empty(aSaldo[nPos,4])    // Se o lote já foi definido
						// Adiciona novo item para armazenar a quantidade excedente
						AAdd( aSaldo , { SD1->D1_ITEM, SD1->D1_COD, SD1->(Recno()), "", 0})
						nPos := Len(aSaldo)
					Endif
					aSaldo[nPos,4] := SZ6->Z6_LOTECTL
				Endif
				aSaldo[nPos,5] -= SZ6->Z6_QUANT
				
				AAdd( aTransf , SZ6->(Recno()) )   // Adiciona o item para gravar o flag de transferido
				
				If nQuant <= 0    // Se a quantidade a ser movimentada for negativa, então esse item não será de transferência
					SZ6->(dbSkip())
					Loop
				Endif
				
				// Posiciona no cadastro do produto
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(XFILIAL("SB1")+SD1->D1_COD))
				
				//Itens a Incluir
				aItem := {}
				aAdd( aItem, SD1->D1_COD         ) // D3_COD
				aAdd( aItem, SB1->B1_DESC        ) // D3_DESCRI
				aAdd( aItem, SB1->B1_UM          ) // D3_UM
				aAdd( aItem, SD1->D1_LOCAL       ) // D3_LOCAL
				aAdd( aItem, ""                  ) // D3_LOCALIZ
				aAdd( aItem, SD1->D1_COD         ) // D3_COD
				aAdd( aItem, SB1->B1_DESC        ) // D3_DESCRI
				aAdd( aItem, SB1->B1_UM          ) // D3_UM
				aAdd( aItem, SD1->D1_LOCAL       ) // D3_LOCAL
				aAdd( aItem, ""                  ) // D3_LOCALIZ
				aAdd( aItem, ""                  ) // D3_NUMSERI
				aAdd( aItem, SD1->D1_LOTECTL     ) // D3_LOTECTL
				aAdd( aItem, ""                  ) // D3_NUMLOTE
				aAdd( aItem, Ctod("")            ) // D3_DTVALID (Lote)
				aAdd( aItem, 0                   ) // D3_POTENCI
				aAdd( aItem, nQuant              ) // D3_QUANT
				aAdd( aItem, 0                   ) // D3_QTSEGUM
				aAdd( aItem, ""                  ) // D3_ESTORNO
				aAdd( aItem, ""                  ) // D3_NUMSEQ
				aAdd( aItem, SZ6->Z6_LOTECTL     ) // D3_LOTECTL
				aAdd( aItem, Ctod("")            ) // D3_DTVALID (Lote)
				aAdd( aItem, ""                  ) // D3_ITEMGRD
				aAdd(aAuto,aItem)
				
				SZ6->(dbSkip())
			Enddo
			
			SD1->(dbSkip())
		Enddo
		
		BeginTran()
		
		MsgRun("Processando transferência de lotes","Etiqueta de Lote",{|| MSExecAuto({|x,y| MATA261(x,y)},aAuto, 3) })
		
		If !lMsErroAuto
			aDocTrf[1] := __cDocTransf    // Atualiza o documento de transferência
			
			// Processa o ajuste de saldo para os itens
			For nX:=1 To Len(aSaldo)
				SD1->(dbGoTo(aSaldo[nX,3]))   // Posiciona no item da NF
				
				If aSaldo[nX,5] > 0    // Se tiver sobrando
					AAdd(aSaidas, {{ "D3_COD"    , SD1->D1_COD      , NIL},;
										{ "D3_LOCAL"  , SD1->D1_LOCAL    , NIL},;
										{ "D3_QUANT"  , aSaldo[nX,5]     , NIL},;
										{ "D3_UM"     , SD1->D1_UM       , NIL},;
										{ "D3_LOTECTL", SD1->D1_LOTECTL  , NIL}})
					
				ElseIf aSaldo[nX,5] < 0    // Se tiver faltando
					AAdd(aEntrad, {{ "D3_COD"    , SD1->D1_COD      , NIL},;
										{ "D3_LOCAL"  , SD1->D1_LOCAL    , NIL},;
										{ "D3_QUANT"  , Abs(aSaldo[nX,5]), NIL},;
										{ "D3_UM"     , SD1->D1_UM       , NIL},;
										{ "D3_LOTECTL", aSaldo[nX,4]     , NIL}})
				Endif
			Next
			
			If !Empty(aSaidas)
				MsgRun("Processando saídas de lotes","Etiqueta de Lote",{|| GravaMovimento(cTMSai,aSaidas) })
				aDocTrf[2] := __cDocTransf    // Atualiza o documento de saídas
			Endif
			
			If !lMsErroAuto .And. !Empty(aEntrad)
				MsgRun("Processando entradas de lotes","Etiqueta de Lote",{|| GravaMovimento(cTMEnt,aEntrad) })
				aDocTrf[3] := __cDocTransf    // Atualiza o documento de entradas
			Endif
		EndIf
		
		If lMsErroAuto
			DisarmTransaction()
			MostraErro()
		Else
			// Atualiza os registros como processados
			For nX:=1 To Len(aTransf)
				SZ6->(dbGoTo(aTransf[nX]))   // Posiciona no registro
				RecLock("SZ6",.F.)
				SZ6->Z6_LOTEOK := "S"
				//SZ6->Z6_DOCTRF := aDocTrf[1]
				MsUnLock()
			Next
			
			EndTran()
			
			lPrint := .T.
		Endif
	Endif
	
	If lPrint .And. MsgYesNo("Deseja imprimir as etiquetas de lotes ?")
		u_PLESTET5(SF1->({F1_FORNECE,F1_FORNECE,F1_DOC,F1_DOC,F1_SERIE,F1_SERIE,2,Replicate(" ",Len(SD1->D1_ITEM)),Replicate("Z",Len(SD1->D1_ITEM)),;
						Replicate(" ",Len(SZ6->Z6_VOLUME)),Replicate("Z",Len(SZ6->Z6_VOLUME))}))
	Endif
	
Return

Static Function GravaMovimento(cTM,aItens)
	Local aDocum := {	{ "D3_DOC"    , ""       , NIL},;
							{ "D3_TM"     , cTM      , NIL},;
							{ "D3_CC"     , ""       , NIL},;
							{ "D3_EMISSAO", dDataBase, NIL}}
	
	MSExecAuto({|x,y,z| MATA241(x,y,z)},aDocum,aItens,3)
	
Return

Static Function SetDocTransf(cDocTrf)
	__cDocTransf := cDocTrf
Return

Static Function ImprimeVolume()
	Local nX
	Local aImp := {}
	Local nCnt := 0
	
	aEval( vVolumes , {|x| If(x[1],nCnt++,) } )   // Conta o número de itens marcados
	
	If MsgYesNo("Confirma a impressão da(s) etiqueta(s) ?")
		If nCnt == 0    // Se não tem marcado, irá imprimir o volume posicionado
			AAdd( aImp , { vVolumes[oLbx2:nAt,2], vVolumes[oLbx2:nAt,2]} )
		ElseIf nCnt < Len(vVolumes)   // Se não foram marcados todos
			aEval( vVolumes , {|x| If( x[1] , AAdd( aImp , { x[2], x[2]} ), ) } )   // Adiciona somente os itens selecionados
		Else
			// Se foram marcados todos os volumes
			AAdd( aImp , { Replicate(" ",Len(SZ6->Z6_VOLUME)), Replicate("Z",Len(SZ6->Z6_VOLUME))} )
		Endif
		
		// Imprime as etiquetas
		aEval( aImp , {|x| u_PLESTET5(SF1->({F1_FORNECE,F1_FORNECE,F1_DOC,F1_DOC,F1_SERIE,F1_SERIE,2,vItens[oLbx1:nAt,1],vItens[oLbx1:nAt,1],x[1],x[2]})) } )
	Endif
	
Return