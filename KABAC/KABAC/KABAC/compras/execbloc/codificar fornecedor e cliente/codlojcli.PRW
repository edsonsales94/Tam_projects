#include "Protheus.ch"
#INCLUDE "TopConn.ch"

/*
Programa : codloj2
Autor    : Totvs
Data     : 26/12/19

Descrição:
  Preenche o campo A1_LOJA a partir do CNPJ (A1_CGC).
  A loja deve ser SEMPRE os dígitos 11 e 12 do CNPJ.
  Caso já exista a mesma loja para o mesmo cliente (A1_COD),
  gera a próxima loja sequencial.
*/

User Function codloj2()
    Local nCount     := 0
    Local cCod       := M->A1_COD
    Local nRecNo     := M->(Recno())
    Local aAreaSA1   := M->(GetArea())
    Local cCodLoj    := ""
    Local cCgc       := ""

    // Garante que cCgc exista
    If Type("cCgc") == "U"
        cCgc := M->A1_CGC
    Else
        cCgc := cCgc
    EndIf

    If inclui

        If Empty(M->A1_COD)
            cCodLoj := "  "
        Else

            DbSelectArea("SA1")
            DbSetOrder(1)

            // Estrangeiro ? loja sempre 01
            If M->A1_TIPO == "X"
                cCodLoj := StrZero(1, TamSX3("A1_LOJA")[1])

            Else

                // Pessoa Jurídica com CNPJ
                If M->A1_PESSOA == "J" .AND. !Empty(cCgc)

                    // Loja padrão = dígitos 11 e 12 do CNPJ
                    cCodLoj := SubStr(cCgc, 11, 2)

                    // Se já existir loja igual para o mesmo cliente, gera sequência
                    If SA1->(MsSeek(xFilial("SA1") + M->A1_COD + cCodLoj))
                        cCodLoj := SeqLojSA1(M->A1_COD)
                    EndIf

                Else
                    // Pessoa física ? loja 01
                    cCodLoj := StrZero(1, TamSX3("A1_LOJA")[1])
                EndIf

            EndIf
        EndIf

        If Empty(cCodLoj)
            MsgStop("Falha ao gerar código da loja do cliente!", ;
                    "Erro Código Loja Cliente")
        EndIf

    EndIf

    RestArea(aAreaSA1)

Return cCodLoj


/*----------------------------------------------------------
  SeqLojSA1()
  Gera a próxima loja sequencial para o mesmo cliente.
-----------------------------------------------------------*/
Static Function SeqLojSA1(cCodCli)

    Local cRet     := ""
    Local _cQry    := ""
    Local _nNum    := 0
    Local nTamAux  := TamSX3("A1_LOJA")[1]

    _cQry := " SELECT MAX(A1_LOJA) LOJA "
    _cQry += " FROM " + RetSqlName("SA1") + " SA1 "
    _cQry += " WHERE D_E_L_E_T_ <> '*' "
    _cQry += "   AND A1_COD = '" + cCodCli + "' "

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
