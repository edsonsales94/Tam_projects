#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MCFATP05   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 09/03/2021 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Processa a autenticação do Pré-Embarque                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MCFATP05()
Local aPosObj, aSize, nLin
Local oFont1 := TFont():New("Courier New", 8.5,15,.T.,.T.,,,15)
Local oFont2 := TFont():New("Courier New", 7.5,15,.T.,.T.,,,15)
Local oFont3 := TFont():New("Courier New",  12,20,.T.,.T.,,,15)
Local nOpcA  := 0

Private cCadastro := "Pré-Embarque de Mercadorias"

Private oLbx, oLdo, oDlg, oChave, oPedN, cVar, oNF, oSr, oProd, oSS1, oSS2

Private lIsCOALI := .F.
Private cProduto := ""
Private cCOALI   := ""
Private nQtdCOAL := 0
Private cProdCli := ""
Private cChaveNF := Space(TamSX3("Z4_CHAVE"  )[1]+10)
Private cEtqCOAL := Space(TamSX3("Z4_ETQCOAL")[1]+10)
Private cEtqProd := Space(TamSX3("Z4_ETQCOAL")[1]+10)
Private cNumEtq  := ""
Private cNota    := ""
Private cSerie   := ""
Private aNota    := {}
Private vItens   := {}
Private aItensNF := {}
Private nTotNota := 0
Private nQtdLido := 0
Private nTotRes  := 0
Private lBoreo   := .F.
Private aTxtSung := {"",""}
Private aNFLida  := {}
Private cBoreo   := GetMV("MV_XCLIPOS",.F.,"L4527E,L4527F,L45281")    // Cliente POSITIVO
Private cPath    := "\System\"
Private cFileEmb := cPath + "\PRE_" + __cUserID + ".emb"
Private cEOL     := CHR(13)+CHR(10)
Private aBaseINF := { CriaVar("B1_COD",.F.), 0, 0, 0}
Private aBaseLdo := {CriaVar("B1_COD",.F.), CriaVar("B1_DESC",.F.), CriaVar("Z1_KANBAN",.F.), CriaVar("D3_XETIQUE",.F.), CriaVar("Z4_DATAFAB",.F.), 0, CriaVar("F2_DOC",.F.),;
					CriaVar("F2_SERIE",.F.), CriaVar("Z4_COALI",.F.), CriaVar("Z4_CHAVE",.F.), CriaVar("Z4_ETQPROD",.F.), CriaVar("Z4_ETQCOAL",.F.), CriaVar("D3_OP",.F.),;
					CriaVar("Z4_DATLEI",.F.), CriaVar("Z4_HORLEI",.F.)}

// Cria o diretório que armazena as planilhas de cálculos
If !ExistDir(cPath)
	MakeDir(cPath)
Endif

AAdd( vItens , aClone(aBaseLdo) )
AAdd( aItensNF , aClone(aBaseINF) )

PosObjetos(@aSize,@aPosObj)

While nOpcA == 0
	nLin := 0

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 TO aSize[6],1110 PIXEL OF oMainWnd
	
	@ aPosObj[1,1]+nLin+00,aPosObj[1,2]+000 SAY "Nota"                                SIZE 040,10 PIXEL OF oDlg FONT oFont3 COLOR CLR_HBLUE
	@ aPosObj[1,1]+nLin+00,aPosObj[1,2]+035 SAY oNF VAR cNota                         SIZE 070,10 PIXEL OF oDlg FONT oFont3 COLOR CLR_HRED
	@ aPosObj[1,1]+nLin+00,aPosObj[1,2]+115 SAY "Série"                               SIZE 040,10 PIXEL OF oDlg FONT oFont3 COLOR CLR_HBLUE
	@ aPosObj[1,1]+nLin+00,aPosObj[1,2]+165 SAY oSr VAR cSerie                        SIZE 040,10 PIXEL OF oDlg FONT oFont3 COLOR CLR_HRED
	nLin += 15
	@ aPosObj[1,1]+nLin+00,aPosObj[1,2] SAY "Chave da NF"                             SIZE 100,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
	@ aPosObj[1,1]+nLin+10,aPosObj[1,2] MSGET oChave  VAR cChaveNF Picture "@!" VALID ChaveNota()          SIZE 200,10 PIXEL OF oDlg FONT oFont2 WHEN lBoreo .Or. Empty(cChaveNF)
	
	@ aPosObj[1,1]+nLin+10,aPosObj[1,2]+215 SAY oSS1  VAR aTxtSung[1] SIZE 60,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
	@ aPosObj[1,1]+nLin+20,aPosObj[1,2]+215 SAY oSS2  VAR aTxtSung[2] SIZE 60,90 PIXEL OF oDlg FONT oFont2 COLOR CLR_HRED
	
	nLin += 25
	@ aPosObj[1,1]+nLin+00,aPosObj[1,2] SAY "Etiqueta COALI"                          SIZE 100,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
	@ aPosObj[1,1]+nLin+10,aPosObj[1,2] MSGET oCOAL   VAR cEtqCOAL  Picture "@!"                           SIZE 200,10 PIXEL OF oDlg FONT oFont2 WHEN .F.
	nLin += 25
	@ aPosObj[1,1]+nLin+00,aPosObj[1,2] SAY "Etiqueta Produção"                       SIZE 100,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
	@ aPosObj[1,1]+nLin+10,aPosObj[1,2] MSGET oProd   VAR cEtqProd  Picture "@!" VALID Producao(cEtqProd)  SIZE 200,10 PIXEL OF oDlg FONT oFont2
	
	@ aPosObj[2,1],aPosObj[2,2] LISTBOX oLbx VAR cVar FIELDS HEADER	"Produto",;
																	"Descrição",;
																	"Kanban",;
																	"Etiqueta",;
																	"Fabricação",;
																	"Quantidade",;
																	"Nota",;
																	"Serie" SIZE 550,aPosObj[2,3]-aPosObj[2,1] OF oDlg PIXEL FONT oFont1
	oLbx:SetArray( vItens )
	
	oLbx:bLine := {|| { vItens[oLbx:nAt,1],;
						vItens[oLbx:nAt,2],;
						vItens[oLbx:nAt,3],;
						vItens[oLbx:nAt,4],;
						vItens[oLbx:nAt,5],;
						Transform(vItens[oLbx:nAt,6],"@E 999,999.99"),;
						vItens[oLbx:nAt,7],;
						vItens[oLbx:nAt,8] } }
	
	@ aPosObj[1,1],aPosObj[1,2]+347 LISTBOX oLdo VAR cVar FIELDS HEADER	"Produto",;
																		"Quantidade",;
																		"Lidos",;
																		"Restam" SIZE 200,aPosObj[1,3]-aPosObj[1,1] OF oDlg PIXEL FONT oFont1
	
	oLdo:SetArray( aItensNF )
	
	oLdo:bLine := {|| {	aItensNF[oLdo:nAt,1],;
						Transform(aItensNF[oLdo:nAt,2],"@E 99999"),;
						Transform(aItensNF[oLdo:nAt,3],"@E 99999"),;
						Transform(aItensNF[oLdo:nAt,4],"@E 99999") } }
	
	@ aPosObj[3,1],aPosObj[3,2]+005 SAY "Quantidade"                            SIZE  80,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
	@ aPosObj[3,1],aPosObj[3,2]+055 SAY oTot VAR nTotNota Picture "@E 99999999" SIZE 120,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
	
	@ aPosObj[3,1],aPosObj[3,2]+205 SAY "Quant. Lidas"                          SIZE  80,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_GREEN
	@ aPosObj[3,1],aPosObj[3,2]+255 SAY oLid VAR nQtdLido Picture "@E 99999999" SIZE 120,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_GREEN
	
	@ aPosObj[3,1],aPosObj[3,2]+405 SAY "Quant. Restante"                       SIZE  80,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HRED
	@ aPosObj[3,1],aPosObj[3,2]+455 SAY oRes VAR nTotRes  Picture "@E 99999999" SIZE 120,10 PIXEL OF oDlg FONT oFont2 COLOR CLR_HRED
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT (EnchoiceBar(oDlg,{|| nOpcA:=0 },{|| nOpcA:=1,If(FechaEmbarque(@nOpcA),oDlg:End(),) }), Processa( {|| RestLeitura() } , "Restaurando Leitura..."), oProd:SetFocus())

Enddo

Return nOpcA == 1

Static Function FechaEmbarque(nOpcA)
	Local lRet := .T.
	
	If Len(vItens) > 1 .Or. !Empty(vItens[1,1])
		If nOpcA == 1    // Se Cancelou
			lRet := FWAlertYesNo("<strong><font face='Arial' size=3 color=RED>Ao sair a leitura já realizada será perdida! Confirma ?</font></strong>","Pré-Embarque de Notas")
		Endif
	Endif
	
Return lRet

Static Function ChaveNota()
	Local lRet := .T.
	
	If !Vazio()
		SF2->(dbOrderNickName("CHVNFE"))
		If lRet := SF2->(dbSeek(XFILIAL("SF2")+cChaveNF))
			SZ4->(dbSetOrder(1))
			If lRet := !SZ4->(dbSeek(XFILIAL("SZ4")+Trim(cChaveNF)))
				cNota  := SF2->F2_DOC
				cSerie := SF2->F2_SERIE
				
				oNF:Refresh()
				oSr:Refresh()
				
				CarregaNota(SF2->F2_DOC+SF2->F2_SERIE)
			Else
				lBoreo := (SF2->F2_CLIENTE $ cBoreo)    // Cliente POSITIVO
				
				// Adiciona a nota fiscal lida
				AAdd( aNFLida , { SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA, lBoreo})
				
				FWAlertWarning("Essa chave de nota já foi lida no sistema !")
				
				ImprimeEtq()
				
				lBoreo   := .F.
				cChaveNF := Space(Len(cChaveNF))
				oChave:Refresh()
			Endif
		Else
			FWAlertError("Essa chave de nota não existe no sistema !")
		Endif
	Endif

Return lRet

Static Function Producao(cEtiqueta)
	Local cPrd, cEtq, nQtd, cOP, lFechou, nPos, nX, cProdCli, nQuant
	Local dFab := CtoD("")
	Local aKan := {}
	
	If Vazio()
		Return .T.
	Endif
	
	// Caso esteja lendo uma etiqueta COALI
	If !Empty(cEtiqueta) .And. Len(AllTrim(cEtiqueta)) > TamSX3("Z4_ETQPROD")[1]
		cEtqCOAL := cEtiqueta
		oCOAL:Refresh()
		
		cProdCli := PADR(SubStr(cEtiqueta, 1,25),TamSX3("A7_CODCLI")[1])
		
		SA7->(dbSetOrder(3))
		If SA7->(dbSeek(XFILIAL("SA7")+SF2->F2_CLIENTE+SF2->F2_LOJA+cProdCli))
			cProduto := SA7->A7_PRODUTO
		Else
			FWAlertError("O produto "+FormaTexto(cProdCli)+" não está cadastrado na tabela Produto x Cliente !")
			Return .F.
		Endif
		
		// Posiciona na Etiqueta produzida
		SD3->(dbOrderNickName("ETIQUETA"))
		SD3->(dbSeek(XFILIAL("SD3")+SubStr(cEtiqueta,26,8)))
		
		// Montagem da etiqueta de produção com base na etiqueta COALI
		cCOALI   := SubStr(cEtiqueta,39,6)
		cOP      := SD3->D3_OP
		cEtqProd := PADR(PADR(cProduto,16) + SubStr(cEtiqueta,26,8) + SubStr(cEtiqueta,34,5) + "00" + PADR(cOP,TamSX3("C2_NUM")[1]) ,TamSX3("Z4_ETQCOAL")[1]+10)
		oProd:Refresh()
		
		//Return .F.
		
		cEtiqueta := cEtqProd
	Endif
	
	cPrd := PADR(cEtiqueta,TamSX3("D3_COD")[1])
	cEtq := SubStr(cEtiqueta,17,TamSX3("D3_XETIQUE")[1])
	nQtd := Val(SubStr(cEtiqueta,25,7)) / 100
	cOP  := SubStr(cEtiqueta,32,TamSX3("C2_NUM")[1]    )
	
	If Vazio(cEtiqueta)
		Return .F.
	ElseIf AScan( vItens , {|x| x[1]+x[4]+x[9] == cPrd+cEtq+cCOALI } ) > 0
		FWAlertError("Essa etiqueta já foi lida !")
		Return .F.
	ElseIf !PassouBarreira(cEtq,cPrd,nQtd,cOP,@dFab)
		Return .F.
	Endif
	
	cProduto := cPrd
	cNumEtq  := cEtq
	nQuant   := nQtd
	nPos     := AScan( aNota , {|x| x[3] == cProduto .And. x[8] > 0 } )
	
	While nPos > 0 .And. nPos <= Len(aNota) .And. aNota[nPos,3] == cProduto .And. nQuant > 0
		If aNota[nPos,8] > 0
			nQtd := If( nQuant <= aNota[nPos,8] , nQuant, aNota[nPos,8])
			
			//             1         2                                                     3              4        5     6     7              8              9       10             11         12        13   14      15
			AAdd( aKan , { cProduto, Posicione("SB1",1,XFILIAL("SB1")+cProduto,"B1_DESC"), aNota[nPos,4], cNumEtq, dFab, nQtd, aNota[nPos,1], aNota[nPos,2], cCOALI, aNota[nPos,9], cEtiqueta, cEtqCOAL, cOP, Date(), Time()} )
			nQuant -= nQtd
			aNota[nPos,8] -= nQtd
			nQtdLido += nQtd
		Endif
		
		nPos++
	Enddo
	
	If nQuant > 0
		FWAlertError("O produto "+FormaTexto(cProduto)+" não possui quantidade suficiente para embarque !")
		Return .F.
	Endif
	
	If Len(vItens) == 1 .And. Empty(vItens[1,1])
		aSize(vItens,0)
	Endif
	
	For nX:=1 To Len(aKan)
		AAdd( vItens , aClone(aKan[nX]) )   // Adiciona os itens lidos
		
		// Atualiza o saldo do item na tela
		nPos := AScan( aItensNF , {|x| x[1] == aKan[nX,1] })
		If nPos > 0
			aItensNF[nPos,4] -= aKan[nX,6]
			aItensNF[nPos,3] := aItensNF[nPos,2] - aItensNF[nPos,4]
		Endif
	Next
	
	nTotRes  := nTotNota - nQtdLido
	cEtqProd := Space(Len(cEtqProd))
	
	cEtqCOAL := Space(Len(cEtqCOAL))
	cCOALI   := Space(Len(cCOALI))
	oCOAL:Refresh()
	
	oLdo:Refresh()
	oLbx:Refresh()
	oLid:Refresh()
	oRes:Refresh()
	oProd:Refresh()
	
	lFechou := (AScan( aNota , {|x| x[8] > 0 } ) == 0)
	
	If lFechou
		For nX:=1 To Len(vItens)
			RecLock("SZ4",.T.)
			SZ4->Z4_FILIAL  := XFILIAL("SZ4")
			SZ4->Z4_PRODUTO := vItens[nX,1]
			SZ4->Z4_KANBAN  := vItens[nX,3]
			SZ4->Z4_QUANT   := vItens[nX,6]
			SZ4->Z4_DOC     := vItens[nX,7]
			SZ4->Z4_SERIE   := vItens[nX,8]
			SZ4->Z4_ETIQUET := vItens[nX,4]
			SZ4->Z4_DATAFAB := vItens[nX,5]
			SZ4->Z4_COALI   := vItens[nX,9]
			SZ4->Z4_CHAVE   := vItens[nX,10]
			
			SZ4->Z4_ETQPROD := vItens[nX,11]
			SZ4->Z4_ETQCOAL := vItens[nX,12]
			SZ4->Z4_OP      := vItens[nX,13]
			
			SZ4->Z4_USRLEI  := __cUserID
			SZ4->Z4_DATLEI  := vItens[nX,14]
			SZ4->Z4_HORLEI  := vItens[nX,15]
			MsUnLock()
		Next
		
		FWAlertSuccess("Todos os itens da nota "+FormaTexto(SF2->F2_DOC+" / "+SF2->F2_SERIE,"BLUE")+" foram lidos!","Pré-Embarque de Notas")
		
		ImprimeEtq()
		
		aNota    := {}
		aTxtSung := {"",""}
		cNota    := Space(Len(cNota))
		cSerie   := Space(Len(cSerie))
		cChaveNF := Space(Len(cChaveNF))
		nTotNota := 0
		nQtdLido := 0
		nTotRes  := nTotNota - nQtdLido
		
		oNF:Refresh()
		oSr:Refresh()
		oTot:Refresh()
		oLid:Refresh()
		oRes:Refresh()
		oSS1:Refresh()
		oSS2:Refresh()
		
		aSize(vItens,0)
		AAdd( vItens , aClone(aBaseLdo) )
		
		oLbx:Refresh()
		
		aSize(aItensNF,0)
		AAdd( aItensNF , aClone(aBaseINF) )
		oLdo:Refresh()
		
		ApagaLeitura()
		
		oChave:SetFocus()
	Else
		SalvaLeitura()
		
		oProd:SetFocus()
	Endif
	
Return .T.

Static Function CarregaNota(cNF)
	Local nPos
	Local lRet := .T.
	
	If AScan( aNota , {|x| x[1]+x[2] == cNF} ) == 0
		If !Empty(aNFLida) .And. aNFLida[1,3]+aNFLida[1,4] <> SF2->F2_CLIENTE+SF2->F2_LOJA
			FWAlertError("O cliente dessa nota fiscal não é igual ao da primeira nota !")
			Return .F.
		Endif
		
		// Limpa a tabela para inserção dos itens
		If Len(aItensNF) == 1 .And. Empty(aItensNF[1,1])
			ASize(aItensNF,0)
		Endif
		
		// Armazena a nota que está sendo lida
		SD2->(dbSetOrder(3))
		SD2->(dbSeek(XFILIAL("SD2")+cNF,.T.))
		
		lBoreo := (SD2->D2_CLIENTE $ cBoreo)    // Cliente POSITIVO
		
		If lBoreo
			aTxtSung[1] := "Notas Fiscais:"
			aTxtSung[2] += If( Empty(aTxtSung[2]) , "", cEOL) + SD2->D2_DOC + " / " + SD2->D2_SERIE
			oSS1:Refresh()
			oSS2:Refresh()
		Endif
		
		While !SD2->(Eof()) .And. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE == XFILIAL("SD2")+cNF
			
			If Posicione("SF4",1,XFILIAL("SF4")+SD2->D2_TES,"F4_DUPLIC") == "S"    // Considera somente os CFOP's de venda
				SC6->(dbSetOrder(1))
				If SC6->(dbSeek(XFILIAL("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD))
					nPos := AScan( aNota , {|x| x[1]+x[2]+x[3]+x[4]+DtoS(x[5])+x[6]+x[7] == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_COD+SC6->C6_XKANBAN+DtoS(SC6->C6_ENTREG)+SC6->C6_XHORENT+SC6->C6_XSETENT } )
					If nPos == 0
						AAdd( aNota , { SD2->D2_DOC, SD2->D2_SERIE, SD2->D2_COD, SC6->C6_XKANBAN, SC6->C6_ENTREG, SC6->C6_XHORENT, SC6->C6_XSETENT, 0, SF2->F2_CHVNFE} )
						nPos := Len(aNota)
					Endif
					aNota[nPos,8] += SD2->D2_QUANT
				Endif
				
				// Acumula as quantidades por produto para identificação das quantidades lidas e restantes
				nPos := AScan( aItensNF , {|x| x[1] == SD2->D2_COD } )
				If nPos == 0
					AAdd( aItensNF , aClone(aBaseINF) )
					nPos := Len(aItensNF)
					aItensNF[nPos,1] := SD2->D2_COD
				Endif
				aItensNF[nPos,2] += SD2->D2_QUANT
				aItensNF[nPos,4] := aItensNF[nPos,2]
				
				nTotNota += SD2->D2_QUANT
			Endif
			
			SD2->(dbSkip())
		Enddo
		
		// Adiciona a nota fiscal lida
		AAdd( aNFLida , { SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA, lBoreo})
		
		nTotRes := nTotNota
		
		oLdo:Refresh()
		oTot:Refresh()
		oRes:Refresh()
	Endif
	
	If lRet := !Empty(aNota)
		ASort( aNota ,,, {|x,y| x[3]+DtoS(x[5])+x[4]+x[1]+x[2] < y[3]+DtoS(y[5])+y[4]+y[1]+y[2] } )  // Ordena por PRODUTO+ENTREGA+KANBAN+DOC+SERIE
	Else
		FWAlertError("Não existem itens válidos na Nota Fiscal informada !")
	Endif
	
Return lRet

Static Function EtiqLida(bChave,cSeek)
	Local nRet := 0
	
	AScan( vItens , {|x| If( x[4] == cSeek , nRet += x[6], ) } )  // Soma as quantidades lidas em tela
	
	cSeek := SZ4->(XFILIAL("SZ4")) + cSeek
	
	SZ4->(dbSetOrder(2))
	SZ4->(dbSeek(cSeek,.T.))
	While !SZ4->(Eof()) .And. SZ4->Z4_FILIAL+SZ4->Z4_ETIQUET == cSeek
		If Empty(SZ4->Z4_DATEST)   // Caso encontre um registro válido
			nRet += SZ4->Z4_QUANT
		Endif
		SZ4->(dbSkip())
	Enddo
	
	// Se estiver pesquisando pela etiqueta COALI
	//lRet := ( AScan( vItens , {|x| XFILIAL("SZ4")+PADR(x[11],nTam) == cSeek } ) > 0 )    // Pesquisa se a etiqueta já foi lida

Return nRet

Static Function PassouBarreira(cEtq,cPrd,nQtd,cOP,dFab)
	Local nTempo, nHoras, nDias
	Local lRet := .F.

	Default cOP := ""

	SD3->(dbOrderNickName("ETIQUETA"))
	If !SD3->(dbSeek(XFILIAL("SD3")+cEtq+cOP))
		FWAlertError("Essa etiqueta "+FormaTexto("("+Trim(cEtq)+")")+" não foi lida na produção !")
	ElseIf SD3->D3_COD <> cPrd
		FWAlertError("O produto dessa etiqueta não é o mesmo apontado na produção !")
	ElseIf nQtd > SD3->D3_QUANT
		FWAlertError("A quantidade dessa etiqueta é maior que o apontado na produção !")
	ElseIf AScan( aItensNF , {|x| x[1] == SD3->D3_COD }) == 0
		FWAlertError("O item dessa etiqueta não está cadastrada nessa nota !")
	ElseIf SD3->D3_QUANT <= EtiqLida({|| SZ4->Z4_FILIAL+SZ4->Z4_ETIQUET == cSeek },cEtq)	
		FWAlertError("Não há saldo para embarque para essa etiqueta de produção: " + Trim(cEtq))
	ElseIf Posicione("SB1",1,XFILIAL("SB1")+SD3->D3_COD,"B1_XCCURA") == "1"   // Se controla o tempo de cura
		nTempo := Posicione("SB1",1,XFILIAL("SB1")+SD3->D3_COD,"B1_XTCURA")
		nTempo := If( nTempo == 0 , 72, nTempo)
		nDias  := nTempo / 24
		
		If dDataBase > SD3->D3_EMISSAO
			nHoras := SomaHoras(SomaHoras(FormaHora(ElapTime(SD3->D3_XHORA+":00","00:00:00")),FormaHora(ElapTime("00:00:00",Time()))),;
						LTrim(Str((24 * (dDataBase - SD3->D3_EMISSAO - 1)),10))+".00")
		Else
			nHoras := Val(FormaHora(ElapTime(SD3->D3_XHORA,Time())))
		Endif
		
		If nHoras < nTempo
			FWAlertError("Produto não pode ser embarcado! <br /><br />"+;
					"Data prevista de embarque: "+FormaTexto(DtoC(SD3->D3_EMISSAO+nDias)+" "+SD3->D3_XHORA))
		Else
			lRet := .T.
		Endif
	Else
		lRet := .T.
	Endif
	
	If lRet
		dFab := SD3->D3_EMISSAO
	Endif

Return lRet

Static Function FormaTexto(cString,cColor)
	Default cColor = "RED"
Return "<strong><font face='Arial' size=3 color="+cColor+">"+AllTrim(cString)+"</font></strong>"

Static Function ImprimeEtq()
	Local nX
	Local cTpoEtq := If( lBoreo , "", "QRCODE")
	Local cPerg   := PADR("MCFATR0"+If( lBoreo , "4", "2"),Len(SX1->X1_GRUPO))
	
	If FWAlertYesNo("Deseja imprimir as etiquetas "+cTpoEtq+" da nota "+FormaTexto(SF2->F2_DOC+" / "+SF2->F2_SERIE,"BLUE")+" ?","Impressão de Etiquetas")
		Pergunte(cPerg,.F.)
		
		For nX:=1 To Len(aNFLida)
			mv_par01 := aNFLida[nX,1]
			mv_par02 := aNFLida[nX,2]
			
			If FWAlertYesNo("Deseja imprimir as etiquetas "+cTpoEtq+" da nota "+FormaTexto(SF2->F2_DOC+" / "+SF2->F2_SERIE,"BLUE")+" em 200 dpi ou 300 dpi ?","Impressão de Etiquetas")
				Pergunte(cPerg,.F.)

				For nX:=1 To Len(aNFLida)
						mv_par01 := aNFLida[nX,1]
						mv_par02 := aNFLida[nX,2]


						If aNFLida[nX,5]    // Cliente Positivo
							u_FATR04a()
						Else
							u_FATR02a()
						Endif
				Next
			Endif
		Next
	Endif
	
	aNFLida := {}


Return

Static Function FormaHora(cHora)
Return StrTran(PADR(cHora,5),":",".")

Static Function SalvaLeitura()
	Local nX, nY, cLinha
	Local cSep  := "~"
	Local cFile := CriaTrab( Nil , .F. ) + ".emb"
	Local nHdl  := FCreate(cFile)
	
	cLinha := "1"
	cLinha += cSep + cEtqCOAL
	cLinha += cSep + cEtqProd
	cLinha += cSep + StrTran(aTxtSung[1],cEOL,"³")
	cLinha += cSep + StrTran(aTxtSung[2],cEOL,"³")
	cLinha += cSep + cValToChar(lBoreo)
	cLinha += cSep + cValToChar(lIsCOALI)
	
	FWrite(nHdl,cLinha + Chr(13) + Chr(10))
	
	cLinha := "2"
	cLinha += cSep + cChaveNF
	cLinha += cSep + cNota
	cLinha += cSep + cSerie
	cLinha += cSep + cProduto
	cLinha += cSep + cProdCli
	cLinha += cSep + cCOALI
	cLinha += cSep + cValToChar(nQtdCOAL)
	cLinha += cSep + cNumEtq
	
	FWrite(nHdl,cLinha + Chr(13) + Chr(10))
	
	// Adiciona a grade de itens lidos e pendentes
	For nX:=1 To Len(aItensNF)
		cLinha := "3"
		For nY:=1 To Len(aItensNF[nX])
			cLinha += cSep + cValToChar(aItensNF[nX,nY])
		Next
		FWrite(nHdl,cLinha + Chr(13) + Chr(10))
	Next
	
	// Adiciona a grade de itens lidos e pendentes
	For nX:=1 To Len(vItens)
		cLinha := "4"
		For nY:=1 To Len(vItens[nX])
			cLinha += cSep + cValToChar(vItens[nX,nY])
		Next
		FWrite(nHdl,cLinha + Chr(13) + Chr(10))
	Next
	
	// Adiciona as notas adicionadas para leitura
	For nX:=1 To Len(aNota)
		cLinha := "5"
		For nY:=1 To Len(aNota[nX])
			cLinha += cSep + cValToChar(aNota[nX,nY])
		Next
		FWrite(nHdl,cLinha + Chr(13) + Chr(10))
	Next
	
	// Adiciona as notas adicionadas para embarque
	For nX:=1 To Len(aNFLida)
		cLinha := "6"
		For nY:=1 To Len(aNFLida[nX])
			cLinha += cSep + cValToChar(aNFLida[nX,nY])
		Next
		FWrite(nHdl,cLinha + Chr(13) + Chr(10))
	Next
	
	cLinha := "7"
	cLinha += cSep + cValToChar(nTotNota)
	cLinha += cSep + cValToChar(nQtdLido)
	cLinha += cSep + cValToChar(nTotRes)
	FWrite(nHdl,cLinha + Chr(13) + Chr(10))
	
	FClose(nHdl)
	
	ApagaLeitura()
	FRename(cFile,cFileEmb)
	
Return

Static Function RestLeitura()
	Local nHdl, cLinha, cTipo, aLinha, nX, aBase, nPos
	Local cSep := "~"
	Local aInf := { {}, {}, {}, {}, {}, {}, {}}
	
	If File(cFileEmb) .And. MsgYesNo("Existe leitura pendente de conclusão, deseja restaurá-la ?","Leitura de Embarque")
		nHdl := FT_FUSE(cFileEmb)
		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			
			IncProc()
			
			cLinha := AllTrim(FT_FREADLN())                // Captura a linha
			cTipo  := SubStr(cLinha,1,At(cSep,cLinha)-1)   // Pega o tipo
			nPos   := Val(cTipo)                           // Posição do tipo no array
			cLinha := SubStr(cLinha,At(cSep,cLinha)+1)     // Retira o tipo da linha
			aLinha := Separa(cLinha,cSep,.T.)              // Converte para vetor
			aBase  := {}
			
			If cTipo == "1"      // Variáveis de Controle 1
				aInf[nPos] := aClone(aLinha)
			ElseIf cTipo == "2"  // Variáveis de Controle 2
				aInf[nPos] := aClone(aLinha)
			ElseIf cTipo == "3"  // Itens da Nota Fiscal
				aBase := aClone(aBaseINF)
			ElseIf cTipo == "4"  // Itens Lidos
				aBase := aClone(aBaseLdo)
			ElseIf cTipo == "5"  // Notas Fiscais
				aBase := { "", "", "", "", CtoD(""), "", "", 0, ""}
			ElseIf cTipo == "6"  // Notas para Embarque
				aBase := { "", "", "", "", .T.}
			ElseIf cTipo == "7"  // Valores do Rodapé
				aInf[nPos] := aClone(aLinha)
			Endif
			
			If !Empty(aBase)
				// Converte os valores dos ITENS
				For nX:=1 To Len(aBase)
					aLinha[nX] := Converte(aLinha[nX],ValType(aBase[nX]))
				Next
				
				AAdd( aInf[nPos] , aClone(aLinha) )
			Endif
			
			FT_FSKIP()
		Enddo
		FT_FUSE()
		
		If !Empty(aInf[4])    // Caso tenha itens lidos
			cEtqCOAL    := aInf[1,1]
			cEtqProd    := aInf[1,2]
			aTxtSung[1] := StrTran(aInf[1,3],"³",cEOL)
			aTxtSung[2] := StrTran(aInf[1,4],"³",cEOL)
			lBoreo      := Converte(aInf[1,5],"L")
			lIsCOALI    := Converte(aInf[1,6],"L")
			
			cChaveNF    := aInf[2,1]
			cNota       := aInf[2,2]
			cSerie      := aInf[2,3]
			cProduto    := aInf[2,4]
			cProdCli    := aInf[2,5]
			cCOALI      := aInf[2,6]
			nQtdCOAL    := Val(aInf[2,7])
			cNumEtq     := aInf[2,8]
			
			ASize( aItensNF , 0 )
			For nX:=1 To Len(aInf[3])
				AAdd( aItensNF , aClone(aInf[3][nX]) )
			Next
			
			ASize( vItens , 0 )
			For nX:=1 To Len(aInf[4])
				AAdd( vItens , aClone(aInf[4][nX]) )
			Next
			
			ASize( aNota , 0 )
			For nX:=1 To Len(aInf[5])
				AAdd( aNota , aClone(aInf[5][nX]) )
			Next
			
			ASize( aNFLida , 0 )
			For nX:=1 To Len(aInf[6])
				AAdd( aNFLida , aClone(aInf[6][nX]) )
			Next
			
			nTotNota := Val(aInf[7,1])
			nQtdLido := Val(aInf[7,2])
			nTotRes  := Val(aInf[7,3])
			
			// Posiciona na nota fiscal
			SF2->(dbSetOrder(1))
			SF2->(dbSeek(XFILIAL("SF2")+aNFLida[Len(aNFLida),1]+aNFLida[Len(aNFLida),2]))
			
			// Posiciona no item da nota fiscal
			SD2->(dbSetOrder(3))
			SD2->(dbSeek(XFILIAL("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
			
			oNF:Refresh()
			oSr:Refresh()
			oChave:Refresh()
			oSS1:Refresh()
			oSS2:Refresh()
			oCOAL:Refresh()
			
			oLbx:Refresh()
			oLdo:Refresh()
			
			oTot:Refresh()
			oLid:Refresh()
			oRes:Refresh()
			
			oProd:SetFocus()
			oProd:Refresh()
		Else
			FErase(cFileEmb)
			FWAlertError("Não foi possível restaurar o arquivo de leitura !","Leitura de Pré-Embarques")
		Endif
	Else
		ApagaLeitura()
	Endif

Return

Static Function ApagaLeitura()
	If File(cFileEmb)
		FErase(cFileEmb)
	Endif
Return

Static Function Converte(cValor,cTipo)
	If cTipo == "N"
		cValor := Val(cValor)
	ElseIf cTipo == "D"
		cValor := CtoD(cValor)
	ElseIf cTipo == "L"
		cValor := (cValor == ".T.")
	Endif
Return cValor

Static Function PosObjetos(aSize,aPosObj)
	Local aInfo
	Local aObjects := {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	AAdd( aObjects, { 100, 100, .t., .f. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100,  10, .t., .f. } )
	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
Return
