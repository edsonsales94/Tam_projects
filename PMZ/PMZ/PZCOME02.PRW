#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TOTVS.ch"

/*/{Protheus.doc}
    Prenchimento do fornecedor padrão no caso de tipo <> ME

    ME = 1 + B1_PROC
    AI = 2 + MV_XPMZFOR
    SV = 3 + MV_XPMZFOR
    MC = 4 + MV_XPMZFOR
/*/

User Function PZCOME02()

    // Limpa o código atual
    

    If M->B1_TIPO <> "ME"
        Return AllTrim(SuperGetMV("MV_XPMZFOR", .F., ""))
        U_PZCOME01()
    EndIf

Return ""



