#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  



USER FUNCTION PLFATE09()

Local _cProduto   := ""
Local _cLocal     := ""
Local _nQtdAtu    := 0
Local _nQtdPedido := 0

nPosProduto := AScan(aHeader,{|x| AllTrim(x[2]) == 'C6_PRODUTO'})
nPosLocal   := AScan(aHeader,{|x| AllTrim(x[2]) == 'C6_LOCAL'})

_cProduto := aCols[N, nPosProduto]
_cLocal   := aCols[N, nPosLocal]

If _cLocal = "80"
    _nQtdAtu    := Posicione("SB2",1,XFILIAL("SB2") + _cProduto + _cLocal, "B2_QATU")
    _nQtdPedido := Posicione("SB2",1,XFILIAL("SB2") + _cProduto + _cLocal, "B2_QPEDVEN")
    If _nQtdAtu <= _nQtdPedido
        Alert("Saldo Insuficiente para esta operacao de brinde.")
        Alert("Voce nao pode escolher este produto pois o mesmo nao possui mais saldo liberado.")
        Alert("Duvidas, posicione o cursor no campo quantidade e aperte a tecla enter e na sequencia aperte a tecla F4 para consultar o sado disponivel no armazem 80.")
        Alert("Atencao! Caseo voce nao informe o armazem 80 como brinde, e salve o pedido em outro armazem, havera penalidades para o infrator.")
        _cLocal := "20"
    EndIf
EndIf

Return _cLocal
