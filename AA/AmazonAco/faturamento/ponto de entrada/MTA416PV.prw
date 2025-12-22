#include "Protheus.ch"

User Function MTA416PV()

    Local aArea  := GetArea()
    Local nAux   := PARAMIXB
    Local _cdPrd := " "

    nPosUm   := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XESPECI'})
    nPosCd   := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_PRODUTO'})
    nPosdce  := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XDCRE'})
    nPosXPrc := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_XPRCVEN'})
    nPosXqtd := AScan(_aHeader, { |x| Alltrim(x[2]) == 'C6_UNSVEN'})

    _aCols[nAux,nPosdce]  := POSICIONE("SB1",1,XFILIAL("SB1")+_aCols[nAux,nPosCd],"B1_XDCRE")
     //Alert("Passou " + Str(nAux) +"-"+ SCK->CK_PRODUTO )
    _aCols[nAux,nPosXPrc] := SCK->CK_XPRCVEN
    _aCols[nAux,nPosXqtd] := SCK->CK_XQTDVEN

    _aCols[nAux,nPosUm] := POSICIONE("SB1", 1, XFILIAL("SB1")+_cdPrd, "B1_ESPECIF")

    _cdPrd := _aCols[nAux,nPosCd]

//FRANCHICO
    M->C5_XNOMCLI       := POSICIONE("SA1", 1, XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI, "A1_NOME")
    IF SC5->(FieldPos("C5_XCOTCLI")) > 0
        M->C5_COTCLI        := M->CJ_COTCLI
        M->C5_MENNOTA       := Alltrim(M->CJ_MENNOTA) + " ORC. - " + M->CJ_COTCLI
        M->C5_XCOTCLI        := Alltrim(M->CJ_XCOTCLI)
    ENDIF

    _aCols[nAux,nPosUm] := POSICIONE("SB1", 1, XFILIAL("SB1")+_cdPrd, "B1_ESPECIF")

    RestArea(aArea)

Return Nil