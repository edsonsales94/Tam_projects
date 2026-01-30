#Include "Protheus.ch"
#Include "TOTVS.ch"
#include "TbiConn.ch"

/*/{Protheus.doc} MAKEZPC_NOENV
    Confere/cria o fisico da tabela ZPC a partir do dicionario (SX2/SX3/SX5)
    Nao usa GetMV nem RpcSetEnv (compatível com 12.1.050).
    Executar como: U_MAKEZPC_NOENV
/*/
User Function MAKEZPC_NOENV()
Local lOK := .F.
     PREPARE ENVIRONMENT EMPRESA '05' FILIAL '01'

 

    // 1) Fecha se estiver aberta
    If Select("ZP8") > 0
       ( "ZP8" )->( dbCloseArea() )
    EndIf

    // 2) Tenta criar pelo dicionário (forma oficial)
    lOK := ChkFile("ZP8")       // cria físico e índices se faltarem

    // 3) Se ainda não materializou, força o "primeiro acesso"
    //    (em muitas builds isso já dispara a criação)
    If ! lOK
       // tenta abrir sob demanda; algumas instalações criam aqui
       BEGIN SEQUENCE
           dbUseArea(.T., , , "ZP8", .F., .F.)
           ( "ZP8" )->( dbCloseArea() )
           lOK := .T.
       RECOVER
           lOK := .F.
       END SEQUENCE
    EndIf

    // 4) Último recurso em ambientes com sufixo (ex.: 050)
    If ! lOK
       // só use se seu sufixo for 050 (como SA1050 sugere)
       lOK := CheckFile("ZP8", "ZP8050")
    EndIf

    If lOK
       MsgInfo("ZP8 criada/validada com sucesso.", "MAKEZPC_NOENV")
    Else
       MsgStop("Não deu: revise SX2/SX3/SX5 (ordem primária, campos) e DBAccess.", "MAKEZPC_NOENV")
    EndIf
    RESET ENVIRONMENT
Return
