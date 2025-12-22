#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWEVENTVIEWCONSTS.CH"
#INCLUDE "FWADAPTEREAI.CH"
/*_______________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ FunÁ?o    ¶ AAFATE13   ¶ Autor ¶ WILLIAMS MESSA       ¶ Data ¶ 24/09/2019 ¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ DescriÁ?o ¶ ExecBlocks para tratar os itens que são vendidos por Peças    ¶¶¶
¶¶+-----------+---------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ*/ 

//Quantidade Por Peça
User Function Fat13xQt()

Local nRet  := 0

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1") + TMP1->CK_PRODUTO)

If EMPTY(SB1->B1_PARCEI)
    //MessageBox("Este item não pode ser realizada venda por peça!","Fat13xQtd",16)
    nRet  := 0
    TMP1->CK_XQTDVEN := 0
Else
    nRet := Round(TMP1->CK_XQTDVEN * SB1->B1_CONV,2)
    //TMP1->CK_QTDVEN := Round(TMP1->CK_XQTDVEN * SB1->B1_CONV,2)
EndIf

Return(nRet)

//Refaz o Preço Unitário por Peça
User Function Fat13xPr()

Local nRet  := 0

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1") + TMP1->CK_PRODUTO)

If EMPTY(SB1->B1_PARCEI)
    //MessageBox("Este item não pode ser realizada venda por peça!","Fat13xPrc",16)
    nRet  := 0
    TMP1->CK_XPRCVEN := 0
Else
    nRet := NoRound(((TMP1->CK_XPRCVEN * TMP1->CK_XQTDVEN)/TMP1->CK_QTDVEN),6)
    //TMP1->CK_QTDVEN := Round(TMP1->CK_XQTDVEN * SB1->B1_CONV,2)
EndIf

Return(nRet)

//Recalcula o Valor Total por Peça
User Function Fat13xVl()

Local nRet  := 0

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1") + TMP1->CK_PRODUTO)

If EMPTY(SB1->B1_PARCEI)
    nRet  := 0
    TMP1->CK_XPRCVEN := 0
Else
    nRet := NoRound((((TMP1->CK_XPRCVEN * TMP1->CK_XQTDVEN)/TMP1->CK_QTDVEN)*TMP1->CK_QTDVEN),6)
    //TMP1->CK_QTDVEN := Round(TMP1->CK_XQTDVEN * SB1->B1_CONV,2)
EndIf
                 
Return(nRet)


//Tratamento no SC6, valor por peça
//Refaz o Preço Unitário por Peça
User Function FT13C6Pr()

Local nRet      := 0
Local nPosCod   := AScan(aHeader, { |x| Alltrim(x[2]) == 'C6_PRODUTO'})
Local nPosPrc   := AScan(aHeader, { |x| Alltrim(x[2]) == 'C6_XPRCVEN'})
Local nPosXPrc  := AScan(aHeader, { |x| Alltrim(x[2]) == 'C6_XPRCVEN'})
Local nPosXSeg  := AScan(aHeader, { |x| Alltrim(x[2]) == 'C6_UNSVEN'})
Local nPosXQtd  := AScan(aHeader, { |x| Alltrim(x[2]) == 'C6_QTDVEN'})

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1") + aCols[n,nPosCod])

If EMPTY(SB1->B1_PARCEI)
    //MessageBox("Este item não pode ser realizada venda por peça!","Fat13xPrc",16)
    nRet  := 0
    aCols[n,nPosPrc] := 0
Else
    nRet := NoRound(((aCols[n,nPosXPrc] * aCols[n,nPosXSeg] )/aCols[n,nPosXQtd]),6)
    //TMP1->CK_QTDVEN := Round(TMP1->CK_XQTDVEN * SB1->B1_CONV,2)
EndIf

Return(nRet)

//Tratamento no SC6, valor por peça
//Refaz o Preço Unitário por Peça
User Function FT13C6VL()

Local nRet      := 0
Local nPosCod   := AScan(aHeader, { |x| Alltrim(x[2]) == 'C6_PRODUTO'})
Local nPosPrc   := AScan(aHeader, { |x| Alltrim(x[2]) == 'C6_XPRCVEN'})
Local nPosXPrc  := AScan(aHeader, { |x| Alltrim(x[2]) == 'C6_XPRCVEN'})
Local nPosXSeg  := AScan(aHeader, { |x| Alltrim(x[2]) == 'C6_UNSVEN'})
Local nPosXQtd  := AScan(aHeader, { |x| Alltrim(x[2]) == 'C6_QTDVEN'})

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1") + aCols[n,nPosCod])

If EMPTY(SB1->B1_PARCEI)
    //MessageBox("Este item não pode ser realizada venda por peça!","Fat13xPrc",16)
    nRet  := 0
    aCols[n,nPosPrc] := 0
Else
    nRet := NoRound((((aCols[n,nPosXPrc] * aCols[n,nPosXSeg])/aCols[n,nPosXQtd])*aCols[n,nPosXQtd]),6)
    //TMP1->CK_QTDVEN := Round(TMP1->CK_XQTDVEN * SB1->B1_CONV,2)
EndIf

Return(nRet)