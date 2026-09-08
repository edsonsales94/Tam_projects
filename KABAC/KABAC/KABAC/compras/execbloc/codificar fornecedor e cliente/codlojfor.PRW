#include "Protheus.ch"
#INCLUDE "TopConn.ch"

/*
Programa : codloj
Autor    : Totvs
Data     : 26/12/19

Descrição:
  Preenche o campo A2_LOJA a partir do CNPJ (A2_CGC).
  A loja deve ser SEMPRE os dígitos 11 e 12 do CNPJ.
  Caso já exista a mesma loja para o mesmo fornecedor (A2_COD),
  gera a próxima loja sequencial.
*/

User Function codloj()
    Local lRet       := .T.
    Local nCount     := 0
    Local cTipo      := M->A2_TIPO
    Local nRecNo     := SA2->( Recno() )
    Local aAreaSA2   := SA2->(GetArea())
    Local cCodLoj    := ""
    Local cCgc       := ""

    // Garante que cCgc exista
    If Type("cCgc") == "U"
        cCgc := M->A2_CGC
    Else
        cCgc := cCgc
    EndIf

    DbSelectArea("SA2")
    SA2->(DbSetOrder(1))

    If inclui

        // Pessoa Jurídica ? usa dígitos 11 e 12 do CNPJ
        If M->A2_TIPO == "J" .AND. !Empty(cCgc)

            // Loja padrão = dígitos 11 e 12
            cCodLoj := SubStr(cCgc, 11, 2)

            // Se já existir loja igual para o mesmo fornecedor, gera sequência
            If SA2->(MsSeek(xFilial("SA2") + M->A2_COD + cCodLoj))
                cCodLoj := SeqLojSA2(M->A2_COD)
            EndIf

        Else
            // Pessoa física ou sem CNPJ ? loja 01
            cCodLoj := StrZero(1, TamSX3("A2_LOJA")[1])
        EndIf

        If Empty(cCodLoj)
            MsgStop("Falha ao gerar código da loja do fornecedor!", ;
                    "Erro Código Loja")
        EndIf

    EndIf

    RestArea(aAreaSA2)

Return cCodLoj


/*----------------------------------------------------------
  SeqLojSA2()
  Gera a próxima loja sequencial para o mesmo fornecedor.
-----------------------------------------------------------*/
Static Function SeqLojSA2(cCodForn)

    Local cRet     := ""
    Local _cQry    := ""
    Local _nNum    := 0
    Local nTamAux  := TamSX3("A2_LOJA")[1]

    _cQry := " SELECT MAX(A2_LOJA) LOJA "
    _cQry += " FROM " + RetSqlName("SA2") + " SA2 "
    _cQry += " WHERE D_E_L_E_T_ <> '*' "
    _cQry += "   AND A2_COD = '" + cCodForn + "' "

    _cQry := ChangeQuery(_cQry)

    If Select("QUERY") > 0
        QUERY->(DbCloseArea())
    EndIf

    TCQUERY _cQry NEW ALIAS "QUERY"

    DbSelectArea("QUERY")
    QUERY->(DbGoTop())

    _nNum := Val(QUERY->LOJA) + 1

    QUERY->(DbCloseArea())

    cRet := StrZero(_nNum, nTamAux)

Return cRet
