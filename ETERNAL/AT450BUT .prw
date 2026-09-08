#Include "Protheus.ch"

/*/{Protheus.doc} TC450ROT
Adiciona opção ao menu externo da rotina TECA450.
@type User Function
/*/
User Function TC450ROT()

    Local aRotAdic := {}

    AAdd(aRotAdic, {;
        "Imprimir OS",;
        "U_ETNIMPOS()",;
        0,;
        4})

Return aRotAdic
