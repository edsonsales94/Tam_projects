#INCLUDE "protheus.ch"
#INCLUDE "totvs.ch"

/*/{Protheus.doc} MT120ISC
BUSCA CAMPO CUSTOMIZADO DA SOLICITAÇÃO DE COMPRA AO VINCULAR A MESMA AO PEDIDO DE COMPRA.
@type function
@version 1.0 
@author Gildeir Pereira - gildeir.pereira@totvs.com.br
@since 05/02/2025
/*/
User Function MT120ISC()

	Local nPosPed1 := aScan(aHeader, {|x| Trim(x[2]) == "C7_QUANT"})
	Local nPosPed2 := aScan(aHeader, {|x| Trim(x[2]) == "C7_PRECO"})
	Local nPosPed3 := aScan(aHeader, {|x| Trim(x[2]) == "C7_TOTAL"})
	Local nPosPed4 := aScan(aHeader, {|x| Trim(x[2]) == "C7_XOF"})
	
 /* Guilherme - 15.01.26
    Campo customizado para ser impresso no SmartView,
    pois o padrão replica todas as observações na impressão do último item*/
	Local nPosPed5 := aScan(aHeader, {|x| Trim(x[2]) == "C7_XOBSREL"})

/* Guilherme - 15.01.26
   Campos a serem preenchidos no pedido de compras conforme solicitação de compras*/
    CA120FORN := SC1->C1_FORNECE
	CA120LOJ  := SC1->C1_LOJA
	ACOLS[n, nPosPed1] := SC1->C1_QUANT
	ACOLS[n, nPosPed2] := SC1->C1_VUNIT
	ACOLS[n, nPosPed3] := ROUND(SC1->C1_QUANT * SC1->C1_VUNIT,2)
	ACOLS[n, nPosPed4] := SC1->C1_XOF
	ACOLS[n, nPosPed5] := SC1->C1_OBS

Return .T.

