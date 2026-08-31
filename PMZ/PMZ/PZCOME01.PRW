#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TOTVS.ch"

/*/{Protheus.doc}
Geração automática do código do produto

Formato:

ME = 1 + Processo(5) + Sequencial(5)
AI = 2 + Processo(5) + Sequencial(5)
SV = 3 + Processo(5) + Sequencial(5)
MC = 4 + Processo(5) + Sequencial(5)
/*/

User Function PZCOME01()

    Local cQuery    := ""
    Local cCodProd  := "1"+M->B1_PROC
    Local cSeq      := "00001"
    Local cProc     := ""
    Local cPrefixo  := ""
    Local aArea     := GetArea()

    //M->B1_COD     := ""
    //M->B1_XCODPMZ := ""

    //-------------------------------------------------
    // Define o prefixo conforme o tipo
    //-------------------------------------------------
    Do Case

        Case M->B1_TIPO == "ME"
            cPrefixo := "1"

        Case M->B1_TIPO == "AI"
            cPrefixo := "2"

        Case M->B1_TIPO == "SV"
            cPrefixo := "3"

        Case M->B1_TIPO == "MC"
            cPrefixo := "4"

        Otherwise
            RestArea(aArea)
            Return ""

    EndCase

    //-------------------------------------------------
    // O processo SEMPRE vem do campo B1_PROC
    //-------------------------------------------------
    cProc := StrZero( Val(AllTrim(M->B1_PROC)), 5 )

    //-------------------------------------------------
    // Busca o último código
    //-------------------------------------------------
    cQuery := " SELECT MAX(B1_COD) COD "
    cQuery += " FROM " + RetSQLName("SB1")
    cQuery += " WHERE D_E_L_E_T_ = '' "
    cQuery += " AND SUBSTR(B1_COD,1,1) = '" + cPrefixo + "' "
    cQuery += " AND SUBSTR(B1_COD,2,5) = '" + cProc + "' "

    dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"PROD",.F.,.T.)

    If !PROD->(EOF()) .And. !Empty(PROD->COD)

        cSeq := Right(AllTrim(PROD->COD),5)
        cSeq := StrZero(Val(cSeq)+1,5)

    Else

        cSeq := "00001"

    EndIf

    If Select("PROD") > 0
        PROD->(DbCloseArea())
    EndIf

    //-------------------------------------------------
    // Monta o código
    //-------------------------------------------------
    cCodProd := cPrefixo + cProc + cSeq

    //-------------------------------------------------
    // Atualiza os campos
    //-------------------------------------------------
    M->B1_COD := cCodProd

    // Se desejar gravar o código PMZ
    M->B1_XCODPMZ := M->B1_COD

	//MsgInfo("Gerado: " + cCodProd + CRLF + ;
    //    "Campo X: " + M->B1_XCODPMZ)

    RestArea(aArea)

Return cCodProd
