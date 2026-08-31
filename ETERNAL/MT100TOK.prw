#Include "Protheus.ch"

User Function MT100TOK()

    Local cPedido      := ""
    Local cItemPed     := ""
    Local cCondPed     := ""
    Local cCondNF      := ""
    Local cCtrPed      := ""
    Local cCtrNF       := ""
    Local lRet         := .T.

    //====================================================
    // Primeiro item da nota
    //====================================================
    cPedido  := AllTrim(fGetCampo(aCols[1],"D1_PEDIDO"))
    cItemPed := AllTrim(fGetCampo(aCols[1],"D1_ITEMPC"))

    If Empty(cPedido)
        Return .T.
    EndIf

    //====================================================
    // Condição do Pedido
    //====================================================
    cCondPed := Posicione("SC7",1,xFilial("SC7")+cPedido+cItemPed,"C7_COND")

    //====================================================
    // Adiantamento do Pedido
    //====================================================
    If !Empty(cCondPed)
        cCtrPed := Posicione("SE4",1,xFilial("SE4")+cCondPed,"E4_CTRADT")
    EndIf

    //====================================================
    // Condição da Nota
    //====================================================
    cCondNF := M->F1_COND

    If !Empty(cCondNF)
        cCtrNF := Posicione("SE4",1,xFilial("SE4")+cCondNF,"E4_CTRADT")
    EndIf

    cCtrPed := AllTrim(cCtrPed)
    cCtrNF  := AllTrim(cCtrNF)

    //====================================================
    // Validação
    //====================================================

    // Pedido exige adiantamento
    If cCtrPed == "1" .And. cCtrNF <> "1"

        FWAlertError(;
            "A condição de pagamento da Nota deve ser de Adiantamento.",;
            "Condição de Pagamento")

        lRet := .F.

    EndIf

    // Pedido NÃO exige adiantamento
    If cCtrPed <> "1" .And. cCtrNF == "1"

        FWAlertError(;
            "A condição de pagamento da Nota não pode ser de Adiantamento.",;
            "Condição de Pagamento")
        lRet := .F.
    EndIf

Return lRet
