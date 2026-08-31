#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

//ExecBlock para validar o preço de tabela do produto (Seq. 01)
User Function VALPRECO()
Local nPreco   := 0

_nPosPrcTabela := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRUNIT"})
_nPosPreco     := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRCVEN"})
_nPosDesc1     := aScan(aHeader,{|x| Alltrim(x[2]) == "C5_DESC1"})
_nPosDesc2     := aScan(aHeader,{|x| Alltrim(x[2]) == "C5_DESC2"})
_nPosDesc3     := aScan(aHeader,{|x| Alltrim(x[2]) == "C5_DESC3"})
_nPosDesc4     := aScan(aHeader,{|x| Alltrim(x[2]) == "C5_DESC4"})
nPreco         := aCols[n,_nPosPreco]

If aCols[n,_nPosPrcTabela] > 0
  If aCols[n,_nPosPreco] < aCols[n,_nPosPrcTabela] //.AND. POSICIONE('SB1',1,xFilial('SB1')+ SC6->C6_PRODUTO,'B1_TIPO') $ "PA/PC"
    //nPreco := aCols[n,_nPosPrcTabela]-(aCols[n,_nPosPrcTabela]*aHeader[n,_nPosDesc1])-(aCols[n,_nPosPrcTabela]*aHeader[n,_nPosDesc2])-(aCols[n,_nPosPrcTabela]*aHeader[n,_nPosDesc3])-(aCols[n,_nPosPrcTabela]*aHeader[n,_nPosDesc4])
    nPreco := aCols[n,_nPosPrcTabela]-(aCols[n,_nPosPrcTabela]*M->C5_DESC1/100)
    nPreco := nPreco - (nPreco * M->C5_DESC2/100)
    nPreco := nPreco - (nPreco * M->C5_DESC3/100)
    nPreco := nPreco - (nPreco * M->C5_DESC4/100)
  Else
    nPreco := aCols[n,_nPosPreco]
  EndIf
//else
    
Endif
If M->C5_XORCRES <> ""
    Return nPreco
else
    Return
EndIf

//ExecBlock para validar o Total calculado do produto (Seq. 02)
User Function VALTOTAL()
Local nTotal := 0
_nPosPrcTabela := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRUNIT"})
_nPosPreco     := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRCVEN"})
_nPosQtd       := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_QTDVEN"})
    If aCols[n,_nPosPrcTabela] > 0
        If aCols[n,_nPosPreco] < aCols[n,_nPosPrcTabela] //.AND. POSICIONE('SB1',1,xFilial('SB1')+ SC6->C6_PRODUTO,'B1_TIPO') $ "PA/PC"
            nTotal := aCols[n,_nPosQtd] * aCols[n,_nPosPreco]
        Else
            nTotal := aCols[n,_nPosPreco]
        ENDIF
    ElseIf aCols[n,_nPosPrcTabela] > 0 .AND. aCols[n,_nPosPreco] > 0
            nTotal := aCols[n,_nPosQtd] * aCols[n,_nPosPreco]
    else
        nTotal := aCols[n,_nPosQtd] * aCols[n,_nPosPreco]
    endif
If M->C5_XORCRES <> ""
    Return nTotal
else
    Return
EndIf
