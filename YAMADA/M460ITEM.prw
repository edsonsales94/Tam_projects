#Include "Protheus.ch"

User Function M460ITEM()

    Local aArea   := GetArea()
    Local aHeader := {}
    Local aCols   := {}
    Local aNovo   := {}
    Local nI      := 0
    Local nPos    := 0
    Local cChave  := ""

    Local nCod    := 0
    Local nQuant  := 0
    Local nTotal  := 0
    Local nPrcven := 0
    Local nTes    := 0
    Local nCf     := 0
    Local nUm     := 0
    Local nLocal  := 0
    Local nPedido := 0
    Local nItemPv := 0
    Local nLote   := 0
    Local nItem   := 0

    If ValType(PARAMIXB) <> "A"
        RestArea(aArea)
        Return PARAMIXB
    EndIf

    If Len(PARAMIXB) < 2
        RestArea(aArea)
        Return PARAMIXB
    EndIf

    aHeader := PARAMIXB[1]
    aCols   := PARAMIXB[2]

    If Empty(aCols)
        RestArea(aArea)
        Return PARAMIXB
    EndIf

    nCod    := XPosCampo(aHeader,"D2_COD")
    nQuant  := XPosCampo(aHeader,"D2_QUANT")
    nTotal  := XPosCampo(aHeader,"D2_TOTAL")
    nPrcven := XPosCampo(aHeader,"D2_PRCVEN")
    nTes    := XPosCampo(aHeader,"D2_TES")
    nCf     := XPosCampo(aHeader,"D2_CF")
    nUm     := XPosCampo(aHeader,"D2_UM")
    nLocal  := XPosCampo(aHeader,"D2_LOCAL")
    nPedido := XPosCampo(aHeader,"D2_PEDIDO")
    nItemPv := XPosCampo(aHeader,"D2_ITEMPV")
    nLote   := XPosCampo(aHeader,"D2_LOTECTL")
    nItem   := XPosCampo(aHeader,"D2_ITEM")

    If nCod == 0 .Or. ;
       nQuant == 0 .Or. ;
       nTotal == 0

        RestArea(aArea)
        Return PARAMIXB

    EndIf

    For nI := 1 To Len(aCols)

        If Empty(aCols[nI])
            Loop
        EndIf

        If Empty(aCols[nI][nCod])
            Loop
        EndIf

        cChave := ;
            PadR(AllTrim(aCols[nI][nCod]),15) + "|" + ;
            PadR(IIf(nTes    > 0, AllTrim(aCols[nI][nTes])   ,""),5)  + "|" + ;
            PadR(IIf(nCf     > 0, AllTrim(aCols[nI][nCf])    ,""),10) + "|" + ;
            PadR(IIf(nUm     > 0, AllTrim(aCols[nI][nUm])    ,""),5)  + "|" + ;
            PadR(IIf(nLocal  > 0, AllTrim(aCols[nI][nLocal]) ,""),5)  + "|" + ;
            PadR(IIf(nPedido > 0, AllTrim(aCols[nI][nPedido]),""),15) + "|" + ;
            PadR(IIf(nItemPv > 0, AllTrim(aCols[nI][nItemPv]),""),6)  + "|" + ;
            Str(IIf(nPrcven > 0, aCols[nI][nPrcven],0),18,6)

        nPos := AScan(aNovo,{|x| x[1] == cChave })

        If nPos == 0

            AAdd(aNovo,{ cChave , AClone(aCols[nI]) })

            If nLote > 0
                aNovo[Len(aNovo)][2][nLote] := "DIVERSOS"
            EndIf

        Else

            aNovo[nPos][2][nQuant] += aCols[nI][nQuant]
            aNovo[nPos][2][nTotal] += aCols[nI][nTotal]

            If nLote > 0
                aNovo[nPos][2][nLote] := "DIVERSOS"
            EndIf

        EndIf

    Next

    aCols := {}

    For nI := 1 To Len(aNovo)

        AAdd(aCols,aNovo[nI][2])

        If nItem > 0
            aCols[nI][nItem] := StrZero(nI,2)
        EndIf

    Next

    PARAMIXB[2] := aCols

    RestArea(aArea)

Return PARAMIXB

Static Function XPosCampo(aHeader,cCampo)

    Local nX := 0

    For nX := 1 To Len(aHeader)

        If Upper(AllTrim(aHeader[nX][2])) == Upper(AllTrim(cCampo))
            Return nX
        EndIf

    Next

Return 0
