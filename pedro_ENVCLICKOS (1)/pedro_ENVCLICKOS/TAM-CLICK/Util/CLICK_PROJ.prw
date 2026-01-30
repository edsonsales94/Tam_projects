#Include "Protheus.ch"
#Include "Totvs.ch"

/*/{Protheus.doc} CLICK_PROJ
    Cadastro de Projetos (ZPC) - PADRÃO PROTHEUS via AxCadastro
    Executar: U_CLICK_PROJ
/*/
User Function CLICK_PROJ()
    Local cAlias := "ZPC"
    // Abre a tela padrão (toolbar CRUD + grid) baseada no dicionário
    AxCadastro(cAlias)
Return
