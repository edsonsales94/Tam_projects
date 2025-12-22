#Include "Protheus.ch"
#Include "TOTVS.ch"
#Include "FWMBrowse.ch"

User Function PROJ_LIST()
    Local oBrw := FWMBrowse():New()

    // Alias do browse (tabela de dados)
    oBrw:SetAlias("AF8")

    // Título
    oBrw:SetDescription("Projetos (AF8)")

    // oBrw:SetFilterDefault( ;
    //     "@" + ;
    //     "  D_E_L_E_T_ = '' " )
    oBrw:SetFilterDefault( ;
        "@" + ;
        "  D_E_L_E_T_ = '' " + ;
        " AND AF8_STATUS = '1'" )

    oBrw:SetUseFilter(.T.)

    oBrw:Activate()

Return

//------------------------------------------------------------------------------
// Menu 
//------------------------------------------------------------------------------
Static Function MenuDef()
    Local aRotina := {}

    aAdd(aRotina, { "Pesquisar", "PESQBRW", 0, 1, 0, NIL } )

    // Opção customizada: abre a tela de vínculos de contatos do projeto
    aAdd(aRotina, { "Contatos do Projeto", ;
                    "U_TAMPROJ(AF8->AF8_PROJET,AF8->AF8_CLIENT,AF8->AF8_LOJA,'PROJ',0)", ;
                    0, 2, 0, NIL } )

Return aRotina
