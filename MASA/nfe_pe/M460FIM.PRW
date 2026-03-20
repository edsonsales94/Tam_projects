#INCLUDE 'PROTHEUS.CH'
#INCLUDE "FWMVCDEF.CH"

//*****************************************************************************
// Ponto de entrada M460FIM - Gravação da NF saida
// Este P.E. é chamado após a gravação da NF de Saída e fora da transação.
//#Par01    - PARAMIXB[1] - Número da NF
//#Par02    - PARAMIXB[2] - Série da NF
//#Par03    - PARAMIXB[3] - Cliente/fornecedor da NF
//#Par03    - PARAMIXB[4] - Loja da NF
//*Return   - Sem nenhuma retorno
//*****************************************************************************


/*
Edson Sales  -  12/03/2026
ponto de entrada para forçar o encerramento do pedido, caso tenha faturado inteiro.
solução paliativa para um erro em que alguns pedidos estavam ficando em abertos 
mesmo faturado toda a quantidade de todos os itens.

o ponto de entrada chama no final de prep. doc MATA460 apos a nota ser gravada.
verifico o item da nota se foi faturado o tanto do pedido.
ao final se todos os item considerados encerrados forem igual o a quantidade de item da nota encerra o pedido.
*/
User Function M460FIM()

	Local cNumNFS   := PARAMIXB[1] // Número da NF
	Local cSerieNFS := PARAMIXB[2] // Série da NF
	Local cClieFor  := PARAMIXB[3] // Cliente/fornecedor da NF
	Local cLoja     := PARAMIXB[4] // Loja da NF
	Local nCntItens := 0
	Local nEncer := 0

	SD2->(dbSetOrder(3))
	SD2->(dbSeek(XFILIAL("SD2")+cNumNFS+cSerieNFS+cClieFor+cLoja))

	While !SD2->(Eof()) .And. (XFILIAL("SD2")+cNumNFS+cSerieNFS+cClieFor+cLoja) == (SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)

		SC6->(dbSetOrder(1))
		SC6->(dbSeek(XFILIAL("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD))

		// contar itens do pedido
		nCntItens++

		if SC6->C6_QTDVEN >= SD2->D2_QUANT
			// itens encerrado.
			nEncer++

			if Empty(SC6->C6_NOTA)
				RecLock('SC6' , .F.)
				SC6->C6_NOTA := SD2->D2_DOC
				SC6->C6_SERIE := SD2->D2_SERIE
				SC6->(MsUnLock())
			endif
		endif

		SD2->(dbSkip())
	Enddo

	// Forçar o encerramento do pedido
	if nCntItens == nEncer .AND. nEncer > 0
		if Empty(SC5->C5_NOTA)
			SC5->C5_NOTA  := SD2->D2_DOC
			SC5->C5_SERIE := SD2->D2_SERIE
		endif
	endif
Return
