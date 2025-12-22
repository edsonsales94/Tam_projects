#INCLUDE "rwmake.ch"
#include "Protheus.ch"

/*________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+----------------------+¦¦
¦¦¦ Programa  ¦ SF1100I    ¦ Autor ¦ Arlindo Neto         ¦ Data ¦ 14/06/2012           ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+----------------------+¦¦
¦¦¦ Descriçäo ¦ Função para Liberação Automatica dos itens do Pedido de venda na Filial ¦¦¦
¦¦¦           ¦ De Destino da Tranferencia                                              ¦¦¦
¦¦+-----------+-------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function SF1100I()
Return Nil
// acabado
	//Local nX, nY, nQuant, nQtdLib, nQtdVen
	//Local cAlias     := alias()
	//Local aPedidos   := {}
	//Local __aPedidos := u_FATP01Ped()
	
	// Caso não tenha itens válidos já definidos
	If __aPedidos == Nil .Or. Empty(__aPedidos)
		cQry := "SELECT SC6.C6_FILIAL, SC6.C6_NUM, SC6.C6_ITEM, SC6.C6_DESCRI, SC6.C6_VALOR, (SC6.C6_QTDVEN - SC6.C6_QTDENT) AS C6_LIBERA,"
		cQry += " SC6.R_E_C_N_O_ AS C6_RECNO, SD1.D1_QUANT"
		cQry += " FROM "+RetSQLName("SD1")+" SD1"
		cQry += " INNER JOIN "+RetSQLName("SC6")+" SC6 ON SC6.D_E_L_E_T_ = ' '"
		cQry += " AND SD1.D1_FILIAL = SC6.C6_FILIAL"
		cQry += " AND SD1.D1_COD = SC6.C6_PRODUTO"
		cQry += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT"
		cQry += " WHERE SD1.D_E_L_E_T_ = ' '"
		cQry += " AND SD1.D1_FILIAL = '"+SF1->F1_FILIAL+"'"
		cQry += " AND SD1.D1_DOC = '"+SF1->F1_DOC+"'"
		cQry += " AND SD1.D1_SERIE = '"+SF1->F1_SERIE+"'"
		cQry += " AND SD1.D1_FORNECE = '"+SF1->F1_FORNECE+"'"
		cQry += " AND SD1.D1_LOJA = '"+SF1->F1_LOJA+"'"
		cQry += " AND SD1.D1_CF = '1906'"
		cQry += " ORDER BY SC6.C6_NUM, SC6.C6_ITEM"
	
		dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TKT", .T., .F. )
		While !Eof()
			Aadd(aPedidos,{ .F., C6_NUM, C6_DESCRI, C6_VALOR, C6_LIBERA, C6_RECNO, Liberados(C6_FILIAL+C6_NUM+C6_ITEM), D1_QUANT})
			dbSkip()
		Enddo
		dbCloseArea()
		dbSelectArea(cAlias)
	Else
		SC6->(dbSetOrder(1))
		
		// Efetua vinculo dos itens dos pedidos selecionados com os itens gerados na nota fiscal de entrada
		SD1->(dbSetOrder(1))
		SD1->(dbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA),.T.))
		While !SD1->(Eof()) .And. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
			// Para cada item da nota, percorre os pedidos usados para gerar a mesma para liberar a quantidade automaticamente
			nQuant := SD1->D1_QUANT
			For nX:=1 To Len(__aPedidos)
				If __aPedidos[nX,1]   // Se o item foi selecionado
					// Percorre os itens do pedido de venda
					For nY:=1 To Len(__aPedidos[nX,4])
						//Se o produto for o mesmo e ainda tiver quantidade disponível
						If __aPedidos[nX,4][nY,3] == SD1->D1_COD .And. __aPedidos[nX,4][nY,4] > __aPedidos[nX,4][nY,5]
							// Posiciona no item do pedido de venda
							SC6->(dbSeek(__aPedidos[nX,4][nY,1]+__aPedidos[nX,2]+__aPedidos[nX,4][nY,2]))							
							// atribui o Lote que entrou na D1 para o pedido de Venda respectivo
							// Modificado por Diego em 27/12/2016
							SC6->(RecLock('SC6',.F.))
							   SC6->C6_LOTECTL := SD1->D1_LOTECTL
							   SC6->C6_DTVALID := SD1->D1_DTVALID
							   SC6->C6_LOCALIZ := "DEPFEC"
							SC6->(MsUnlock())
							//Fim
							
							nQtdVen := SC6->(C6_QTDVEN - C6_QTDENT)   // Saldo do pedido
							
							// Caso a quantidade transferida for maior que o saldo do pedido
							If nQuant > nQtdVen
								nQtdLib := nQtdVen
							Else
								nQtdLib := nQuant
							Endif
							
							// Atualiza as quantidade já utilizadas
							nQuant -= nQtdLib
							__aPedidos[nX,4][nY,5] := nQtdLib
							
							Aadd(aPedidos,SC6->({ .T., C6_NUM, C6_DESCRI, C6_VALOR, nQtdLib, Recno(), Liberados(C6_FILIAL+C6_NUM+C6_ITEM)}))
							
							If nQuant <= 0   // Se já foi consumido o saldo
								Exit
							Endif
						Endif
					Next
					If nQuant <= 0   // Se já foi consumido o saldo
						Exit
					Endif
				Endif
			Next
			SD1->(dbSkip())
		Enddo
	Endif
	
	If !Empty(aPedidos)
		TelaPed(aPedidos)
	Endif
	
Return  

/*________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+----------------------+¦¦
¦¦¦ Programa  ¦ Liberados  ¦ Autor ¦ Arlindo Neto         ¦ Data ¦ 22/06/2012           ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+----------------------+¦¦
¦¦¦ Descriçäo ¦ Função para buscar os itens já liberados para o item do pedido          ¦¦¦
¦¦+-----------+-------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Liberados(cKey)
	Local aLib := {}
	
	// Pesquisa as liberações bloqueadas para o item
	SC9->(dbSetOrder(1))
	SC9->(dbSeek(cKey,.T.))
	While !SC9->(Eof()) .And. cKey == SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM)
		If !Empty(SC9->C9_BLEST) .Or. !Empty(SC9->C9_BLCRED)
			AAdd( aLib , SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO) )
		Endif
		SC9->(dbSkip())
	Enddo
	
Return aClone(aLib)

/*________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+----------------------+¦¦
¦¦¦ Programa  ¦ telaPed    ¦ Autor ¦ Arlindo Neto         ¦ Data ¦ 14/06/2012           ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+----------------------+¦¦
¦¦¦ Descriçäo ¦ Função para Montar a tela do pedidos em aberto na filial de destino     ¦¦¦
¦¦+-----------+-------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function TelaPed(aPedidos)
	Local oDlgACE, oLbx1
	Local oOk  := LoadBitmap( GetResources(), "LBOK" )
	Local oNo  := LoadBitmap( GetResources(), "LBNO" )
	Local nOpc := 0
	
	DEFINE MSDIALOG oDlgACE FROM  30,003 TO 260,600 TITLE "Pedidos" PIXEL
	
	@ 03,10 LISTBOX oLbx1 VAR nPosLbx FIELDS HEADER " ",;
																	"Pedido",;
																	"Descrição",;
																	"Valor",;
																	"Quantidade",;
	SIZE 283,80 OF oDlgACE  PIXEL ON dblClick(aPedidos[oLbx1:nAt][1]:=!aPedidos[oLbx1:nAt][1], oLbx1:Refresh())
	
	oLbx1:SetArray(aPedidos)
	oLbx1:bLine := {|| { IIF(aPedidos[oLbx1:nAt,1],oOk,oNo),;
								aPedidos[oLbx1:nAt,2],;
								aPedidos[oLbx1:nAt,3],;
								aPedidos[oLbx1:nAt,4],;
								aPedidos[oLbx1:nAt,5] }}
	
	DEFINE SBUTTON FROM 88,175 TYPE 1 ENABLE OF oDlgACE ACTION (nOpc:= 1, oDlgACE:End())
	
	ACTIVATE MSDIALOG oDlgACE CENTERED
	
	If nOpc == 1
		LiberPedido(aPedidos)
	EndIf
Return

/*________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+----------------------+¦¦
¦¦¦ Programa  ¦LiberPedido ¦ Autor ¦ Arlindo Neto         ¦ Data ¦ 14/06/2012           ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+----------------------+¦¦
¦¦¦ Descriçäo ¦ Função para Liberação Automatica dos itens do Pedido de venda na Filial ¦¦¦
¦¦¦           ¦ De Destino da Tranferencia                                              ¦¦¦
¦¦+-----------+-------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function LiberPedido(aPedidos)
	Local nX
	
	lCredito := .T.
	lEstoque := .T.
	lLiber   := .T.
	lTransf  := .F.
	lAvEst   := (GetMv("MV_ESTNEG") <> "S")
	
	//Percorre Todos os itens selecionados no List Box
	For nX:=1 to Len(aPedidos)  
		If aPedidos[nX,1]  // Se foi marcado
			// Posiciona no pedido de venda
			SC5->(dbSetOrder(1))
			If SC5->(DbSeek(xFilial("SC5")+aPedidos[nX,2]))
				
				// Estorna os itens bloqueados
				For nY:=1 To Len(aPedidos[nX,7])
					SC9->(dbSetOrder(1))
					If SC9->(dbSeek(aPedidos[nX,7][nY]))
						a460Estorna()
					Endif
				Next
				
				SC6->(dbGoTo(aPedidos[nX,6]))  // Posicina no registro do item
				
				//Executa a Rotina padrão para efetuar a liberação por item
				Begin Transaction
					MaLibDoFat(aPedidos[nX,6],aPedidos[nX,5],@lCredito,@lEstoque,.F.,lAvEst,lLiber,lTransf)
				End Transaction
			Endif
		Endif
	Next
Return