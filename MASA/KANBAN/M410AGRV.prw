#Include "Protheus.ch"
#Include "Rwmake.ch"

/*_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+------------------------+-------------------+¦¦
¦¦¦ Programa  ¦ M410AGRV   ¦ Autor ¦ Ronilton O. Barros     ¦ Data ¦ 01/11/2018 ¦¦¦
¦¦+-----------+------------+-------+------------------------+-------------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada após gravação do documento de saída            ¦¦¦
¦¦+-----------+-----------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function M410AGRV()
// Local nCntItens := 0
// Local nEncer := 0
	
	If ParamIXB[1] == 3   // Se for Exclusão
		// Processa os itens para estorno da entrega do kanban
		SC6->(dbSetOrder(1))
		SC6->(dbSeek(XFILIAL("SC6")+M->C5_NUM,.T.))
		While !SC6->(Eof()) .And. XFILIAL("SC6")+M->C5_NUM == SC6->C6_FILIAL+SC6->C6_NUM
			
			// Posiciona no registro do kanban
			SZ1->(dbSetOrder(1))    // Z1_FILIAL+Z1_CLIENTE+Z1_LOJA+Z1_PRODUTO+DTOS(Z1_DATENT)+Z1_HORENT+Z1_SETENT+Z1_KANBAN
			If SZ1->(dbSeek(XFILIAL("SZ1")+M->C5_CLIENTE+M->C5_LOJACLI+SC6->C6_PRODUTO+DtoS(SC6->C6_ENTREG)+SC6->C6_XHORENT+SC6->C6_XSETENT+SC6->C6_XKANBAN))
				// Atualiza a quantidade entregue do kanban
				RecLock("SZ1",.F.)
				SZ1->Z1_QTDENT := Max(0, SZ1->Z1_QTDENT - SC6->C6_QTDVEN)
				MsUnLock()
			Endif

			// Processa os itens para estorno da entrega da careteira.
			// Edson Pedro - 12/03/2026
			SZX->(dbSetOrder(1))
			// ZX_FILIAL+ZX_CLIENTE+ZX_LOJA+ZX_PERIODO+ZX_CODMASA+ZX_DATA 
			IF SZX->(dbSeek(XFILIAL("SZX")+M->C5_CLIENTE+M->C5_LOJACLI+left(DtoS(SC6->C6_ENTREG),6)+SC6->C6_PRODUTO+DtoS(SC6->C6_ENTREG)))
			DBSelectArea('SZX')
				RecLock("SZX",.F.)
				SZX->ZX_QTDENT := Max(0, SZX->ZX_QTDENT - SC6->C6_QTDVEN)
				SZX->ZX_SALDO  := SZX->ZX_SALDO + SC6->C6_QTDVEN
				MsUnLock()
			EndIf

			// // contar itens do pedido
			// nCntItens++

			// if SC6->C6_QTDENT >= SC6->C6_QTDVEN
			// 	// itens encerrado.
			// 	nEncer++
			// endif

			// // Forçar o encerramento do pedido
			// if nCntItens == nEncer
			// 	M->C5_NOTA := SC6->C6_NOTA
			// 	M->C5_SERIE := SC6->C6_SERIE
			// endif
			
			SC6->(dbSkip())
		Enddo
	Endif
	
Return
