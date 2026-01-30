
#Include "Protheus.ch"
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} PROJ_CONTATOS
    Segunda tela (MVC) para vincular Contatos (AC8) ao Projeto (AF8) na ZP8
    - Implementado com MPFormModel + FWFormView (sem TCBrowse)
    - Dois grids: à esquerda AC8 (contatos do cliente) e à direita ZP8 (vinculados ao projeto)
    - Botões na barra: Vincular, Desvincular, Editar Ordem
    - Sem criatividade: 100% padrão do MVC conforme TDN (AddGrid com bLoad, AddUserButton, GetValue/SetValue)
    - Parâmetros aceitos: (cProj, cA1, cLoja)
/*/
User Function PROJ_CONTATOS(cProjIn, cA1In, cLojaIn)
    Local aArea := GetArea()

    // Guardamos o contexto para os bLoads/ações
    Private _cProj := ""
    Private _cA1   := ""
    Private _cLoja := ""

    If PCount() >= 2 .and. !Empty(cProjIn) .and. !Empty(cA1In)
        _cProj := AllTrim(cProjIn)
        _cA1   := AllTrim(cA1In)
        _cLoja := IIf(PCount() >= 3 .and. !Empty(cLojaIn), AllTrim(cLojaIn), "01")
    ElseIf Select("AF8") > 0 .and. Used()
        _cProj := AllTrim(IIf(FieldPos("AF8_PROJET")>0, AF8->AF8_PROJET, ""))
        _cA1   := AllTrim(IIf(FieldPos("AF8_CLIENT")>0, AF8->AF8_CLIENT, ""))
        _cLoja := AllTrim(IIf(FieldPos("AF8_LOJA")  >0, AF8->AF8_LOJA  , "01"))
    Else
        // fallback simples (sem firula): pergunta e segue
        MsGet( , , "Informe o Código do Projeto:", @_cProj )
        MsGet( , , "Informe o Cliente (A1_COD):", @_cA1 )
        MsGet( , , "Informe a Loja (A1_LOJA):",   @_cLoja )
        _cProj := AllTrim(_cProj) ; _cA1 := AllTrim(_cA1) ; _cLoja := AllTrim(_cLoja)
    EndIf

    // Executa a View MVC
    FWExecView("Contatos do Projeto " + _cProj, "VIEWDEF.PROJ_CONT_MVC", MODEL_OPERATION_UPDATE, , {|| .T.})

    RestArea(aArea)
Return

/*--------------------------------------------------------------------------*
 *  MODEL
 *--------------------------------------------------------------------------*/
Static Function ModelDef()
    Local oModel     As Object
    Local oStrCab    As Object
    Local oStrAC8    As Object
    Local oStrZP8    As Object

    // Blocos de carga (sem criatividade, padrão TDN: bLoad recebendo (oSubModel, lCopy))
    Local bLoad := {|oSubModel, lCopy| _MVC_bLoad(oSubModel, lCopy)}

    // --- Cabeçalho fake (carrega apenas os parâmetros do contexto) ---
    oStrCab := FWFormModelStruct():New()
    oStrCab:AddTable( '' , { 'PRJ','A1','LOJA','ORDERON' }, "Cabeçalho" , {|| ''} )
    oStrCab:AddField( "Projeto" , "Projeto" , "PRJ"    , "C" , 20 , 0 , , , {}, .T., , .T., .F., .T. )
    oStrCab:AddField( "Cliente" , "Cliente" , "A1"     , "C" , 10 , 0 , , , {}, .T., , .T., .F., .T. )
    oStrCab:AddField( "Loja"    , "Loja"    , "LOJA"   , "C" ,  3 , 0 , , , {}, .T., , .T., .F., .T. )
    oStrCab:AddField( "Ordenar" , "Ativar ordenação (ClickSign)" , "ORDERON", "L" , 1 , 0 , , , {}, .F., , .F., .F., .F. )

    // --- Grid AC8 (contatos do cliente) ---
    oStrAC8 := FWFormModelStruct():New()
    oStrAC8:AddTable( '' , { 'CONTID','NOME','EMAIL' } , "AC8 Contatos" , {|| ''} )
    oStrAC8:AddField( "ID"    , "Código do contato" , "CONTID" , "C" , 30 , 0 )
    oStrAC8:AddField( "Nome"  , "Nome do contato"   , "NOME"   , "C" , 60 , 0 )
    oStrAC8:AddField( "E-mail", "E-mail"            , "EMAIL"  , "C" , 80 , 0 )

    // --- Grid ZP8 (contatos vinculados ao projeto) ---
    oStrZP8 := FWFormModelStruct():New()
    oStrZP8:AddTable( '' , { 'CONTID','NOME','EMAIL','GRUPO','ORDEM' } , "ZP8 Vinculados" , {|| ''} )
    oStrZP8:AddField( "ID"    , "Código do contato" , "CONTID" , "C" , 30 , 0 , , , {}, .T. )
    oStrZP8:AddField( "Nome"  , "Nome do contato"   , "NOME"   , "C" , 60 , 0 )
    oStrZP8:AddField( "E-mail", "E-mail"            , "EMAIL"  , "C" , 80 , 0 )
    oStrZP8:AddField( "Grupo" , "Grupo ClickSign"   , "GRUPO"  , "N" ,  4 , 0 )
    oStrZP8:AddField( "Ordem" , "Ordem"             , "ORDEM"  , "N" ,  6 , 0 )

    // --- Cria o Model ---
    oModel := MPFormModel():New( "PROJ_CONT_MVC" )

    // Primeiro submodelo SEMPRE é Fields
    oModel:AddFields( "CAB" , , oStrCab , , , bLoad )
    // Grids
    oModel:AddGrid  ( "AC8GRID" , "CAB" , oStrAC8 , , , , , bLoad )
    oModel:AddGrid  ( "ZP8GRID" , "CAB" , oStrZP8 , , , , , bLoad )

    // Descrição
    oModel:SetDescription( "Vínculo de Contatos por Projeto" )
    oModel:GetModel("CAB"):SetDescription("Parâmetros")
    oModel:GetModel("AC8GRID"):SetDescription("Contatos do Cliente (AC8)")
    oModel:GetModel("ZP8GRID"):SetDescription("Vinculados ao Projeto (ZP8)")

Return oModel

/*--------------------------------------------------------------------------*
 *  VIEW
 *--------------------------------------------------------------------------*/
Static Function ViewDef()
    Local oModel := FWLoadModel( "PROJ_CONT_MVC" )
    Local oView  := FWFormView():New()
    Local oStrCabV := FWFormViewStruct():New()
    Local oStrAC8V := FWFormStruct( 2, "" )
    Local oStrZP8V := FWFormStruct( 2, "" )

    // Estrutura da View deve repetir os IDs do Model
    oStrCabV:AddField( "PRJ"    , "1" , "Projeto" , "Projeto" , , "Get" )
    oStrCabV:AddField( "A1"     , "2" , "Cliente" , "Cliente" , , "Get" )
    oStrCabV:AddField( "LOJA"   , "3" , "Loja"    , "Loja"    , , "Get" )
    oStrCabV:AddField( "ORDERON", "4" , "Ativar ordenação (ClickSign)" , "Ordenar" , , "Check" )

    // Grids na view: colunas simples baseadas nos IDs do Model
    oStrAC8V:AddField( "CONTID" , "Código" , "CONTID" , "C" , 30 )
    oStrAC8V:AddField( "NOME"   , "Nome"   , "NOME"   , "C" , 60 )
    oStrAC8V:AddField( "EMAIL"  , "E-mail" , "EMAIL"  , "C" , 60 )

    oStrZP8V:AddField( "CONTID" , "Código" , "CONTID" , "C" , 30 )
    oStrZP8V:AddField( "NOME"   , "Nome"   , "NOME"   , "C" , 60 )
    oStrZP8V:AddField( "EMAIL"  , "E-mail" , "EMAIL"  , "C" , 60 )
    oStrZP8V:AddField( "GRUPO"  , "Grupo"  , "GRUPO"  , "N" ,  4 )
    oStrZP8V:AddField( "ORDEM"  , "Ordem"  , "ORDEM"  , "N" ,  6 )

    // Montagem da View
    oView:SetModel( oModel )
    oView:AddField( "CAB"   , oStrCabV , "CAB" )
    oView:AddGrid ( "AC8V"  , oStrAC8V , "AC8GRID" )
    oView:AddGrid ( "ZP8V"  , oStrZP8V , "ZP8GRID" )

    // Layout: cabeçalho 10%, grids lado a lado 45% / 45%
    oView:CreateHorizontalBox( "TOP" , 10 )
    oView:CreateHorizontalBox( "MID" , 90 )

    oView:SetOwnerView( "CAB"  , "TOP" )
    oView:SetOwnerView( "AC8V" , "MID" )
    oView:SetOwnerView( "ZP8V" , "MID" )

    // Títulos
    oView:EnableTitleView( "AC8V" , "Contatos do Cliente (AC8)" )
    oView:EnableTitleView( "ZP8V" , "Vinculados ao Projeto (ZP8)" )

    // Botões de ação (barra da View)
    oView:AddUserButton( "Vincular"     , "CLIPS" , {|| _MVC_UI_Vincular() } , "Vincular contato selecionado (AC8) ao projeto" , , { MODEL_OPERATION_UPDATE , MODEL_OPERATION_VIEW } )
    oView:AddUserButton( "Desvincular"  , "CLIPS" , {|| _MVC_UI_Desvincular() } , "Desvincular contato selecionado (ZP8)" , , { MODEL_OPERATION_UPDATE , MODEL_OPERATION_VIEW } )
    oView:AddUserButton( "Editar Ordem" , "CLIPS" , {|| _MVC_UI_EditOrd() } , "Editar Grupo/Ordem do contato (ZP8)" , , { MODEL_OPERATION_UPDATE , MODEL_OPERATION_VIEW } )

    oView:SetDescription( "Contatos do Projeto" )

Return oView

/*--------------------------------------------------------------------------*
 *  LOADs do Model (padrão TDN: retornar array)
 *--------------------------------------------------------------------------*/
Static Function _MVC_bLoad(oSubModel, lCopy)
    Local aRet := {}
    Local cId  := oSubModel:GetId()

    Do Case
    Case cId == "CAB"
        aAdd(aRet, { _cProj, _cA1, _cLoja, .F. })  // valores
        aAdd(aRet, 1)                               // recno (dummy)
    Case cId == "AC8GRID"
        aRet := _MVC_LoadAC8(_cA1, _cLoja)
    Case cId == "ZP8GRID"
        aRet := _MVC_LoadZP8(_cProj)
    Otherwise
        aRet := {}
    EndCase
Return aRet

/*--------------------------------------------------------------------------*
 *  AÇÕES DE UI (botões da View)
 *--------------------------------------------------------------------------*/
Static Function _MVC_UI_Vincular()
    Local oModel  := FWModelActive()
    Local oView   := FWViewActive()
    Local oAC8    := oModel:GetModel("AC8GRID")
    Local cId := "", cNm := "", cEm := ""

    // Pega a linha ativa do grid AC8
    cId := oAC8:GetValue("CONTID")
    cNm := oAC8:GetValue("NOME")
    cEm := oAC8:GetValue("EMAIL")

    If Empty(cId)
        MsgAlert("Selecione um contato no grid da esquerda (AC8).", "AC8")
        Return
    EndIf

    If _MVC_Vincular(_cProj, _cA1, _cLoja, cId, cNm, cEm)
        _MVC_RefreshZP8()
        oView:Refresh()
    EndIf
Return

Static Function _MVC_UI_Desvincular()
    Local oModel  := FWModelActive()
    Local oView   := FWViewActive()
    Local oZP8    := oModel:GetModel("ZP8GRID")
    Local cId := ""

    cId := oZP8:GetValue("CONTID")
    If Empty(cId)
        MsgAlert("Selecione um contato no grid da direita (ZP8).", "ZP8")
        Return
    EndIf

    If _MVC_Desvincular(_cProj, cId)
        _MVC_RefreshZP8()
        oView:Refresh()
    EndIf
Return

Static Function _MVC_UI_EditOrd()
    Local oModel   := FWModelActive()
    Local oView    := FWViewActive()
    Local oCab     := oModel:GetModel("CAB")
    Local lOrderOn := oCab:GetValue("ORDERON")
    Local oZP8     := oModel:GetModel("ZP8GRID")
    Local cId := ""
    Local nG  := 0
    Local nO  := 0

    If ! lOrderOn
        MsgAlert("Ative a opção 'Ordenar' no cabeçalho para editar Grupo/Ordem.", "ZP8")
        Return
    EndIf

    cId := oZP8:GetValue("CONTID")
    If Empty(cId)
        MsgAlert("Selecione um contato no grid da direita (ZP8).", "ZP8")
        Return
    EndIf

    nG := oZP8:GetValue("GRUPO")
    nO := oZP8:GetValue("ORDEM")

    If ! MsGet( , , "Grupo (ClickSign):", @nG ) ; Return ; EndIf
    If ! MsGet( , , "Ordem:"            , @nO ) ; Return ; EndIf

    If _MVC_EditOrd(_cProj, cId, nG, nO)
        _MVC_RefreshZP8()
        oView:Refresh()
    EndIf
Return

/*--------------------------------------------------------------------------*
 *  REFRESH do Grid ZP8 (recarrega pelo resultado do Load)
 *--------------------------------------------------------------------------*/
Static Function _MVC_RefreshZP8()
    Local oModel := FWModelActive()
    Local oZP8   := oModel:GetModel("ZP8GRID")
    Local aData  := _MVC_LoadZP8(_cProj)
    Local nI

    If oZP8:CanClearData()
        oZP8:ClearData()
    EndIf

    For nI := 1 To Len(aData)
        oZP8:AddLine()
        oZP8:GoLine(nI)
        oZP8:LoadValue("CONTID", aData[nI,2][1])
        oZP8:LoadValue("NOME"  , aData[nI,2][2])
        oZP8:LoadValue("EMAIL" , aData[nI,2][3])
        oZP8:LoadValue("GRUPO" , aData[nI,2][4])
        oZP8:LoadValue("ORDEM" , aData[nI,2][5])
    Next
Return

/*--------------------------------------------------------------------------*
 *  ACESSO AOS DADOS (mesma lógica usada na versão TCBrowse)
 *--------------------------------------------------------------------------*/
Static Function _MVC_LoadAC8(cA1, cLoja)
    Local aRet := {}
    Local cEnt := "SA1"
    Local cCodCon := "", cNm := "", cEm := ""

    If _MVC_OpenAlias("AC8")
        AC8->( dbGoTop() )
        While ! AC8->(EoF())
            If AC8->(Deleted()) == .F. .and. ;
               AllTrim(IIf(FieldPos("AC8_ENTIDA")>0, AC8->AC8_ENTIDA, "")) == cEnt .and. ;
               AllTrim(IIf(FieldPos("AC8_CODENT")>0, AC8->AC8_CODENT, "")) == cA1
                cCodCon := AllTrim(IIf(FieldPos("AC8_CODCON")>0, AC8->AC8_CODCON, ""))
                cNm := _MVC_GetFieldVal( {"AC8_NOME","AC8_NOMCON","AC8_NOMCLI"} )
                cEm := _MVC_GetFieldVal( {"AC8_EMAIL","AC8_MAIL"} )
                aAdd(aRet, { 0, { cCodCon, cNm, cEm } })
            EndIf
            AC8->( dbSkip() )
        EndDo
        AC8->( dbCloseArea() )
    EndIf

    ASort(aRet,,,{|x,y| IIf(Empty(x[2,2]) .and. Empty(y[2,2]), x[2,1] < y[2,1], ;
                       IIf(Empty(x[2,2]) , .T., IIf(Empty(y[2,2]), .F., x[2,2] < y[2,2])) )})
Return aRet

Static Function _MVC_LoadZP8(cProj)
    Local aRet   := {}
    Local cFil   := xFilial("ZP8")
    Local lHasOrd:= .F.

    If _MVC_OpenAlias("ZP8")
        BEGIN SEQUENCE
            ZP8->( dbSetOrder(1) )
            lHasOrd := .T.
        RECOVER
            lHasOrd := .F.
        END SEQUENCE

        If lHasOrd
            ZP8->( dbSeek( cFil + cProj ) )
            While ! ZP8->(EoF()) .and. ZP8->ZP8_FILIAL == cFil .and. ZP8->ZP8_COD == cProj .and. ZP8->(Deleted()) == .F.
                aAdd(aRet, { 0, { ;
                    AllTrim(ZP8->ZP8_CONTID), ;
                    AllTrim(IIf(FieldPos("ZP8_NOME") >0, ZP8->ZP8_NOME , "")), ;
                    AllTrim(IIf(FieldPos("ZP8_EMAIL")>0, ZP8->ZP8_EMAIL, "")), ;
                    IIf(FieldPos("ZP8_GRUPO")>0 .and. !Empty(ZP8->ZP8_GRUPO), ZP8->ZP8_GRUPO, 0), ;
                    IIf(FieldPos("ZP8_ORDEM")>0 .and. !Empty(ZP8->ZP8_ORDEM), ZP8->ZP8_ORDEM, 0) } } )
                ZP8->( dbSkip() )
            EndDo
        EndIf

        ZP8->( dbCloseArea() )
    EndIf

    ASort(aRet,,,{|x,y| StrZero(x[2,4],2)+StrZero(x[2,5],4) < StrZero(y[2,4],2)+StrZero(y[2,5],4) })
Return aRet

Static Function _MVC_Vincular(cProj,cA1,cLoja,cId,cNm,cEm)
    Local cFil := xFilial("ZP8")
    Local lDup := .F.
    Local lOk  := .F.
    Local nDummy := 0

    If Empty(cId)
        Return .F.
    EndIf

    If _MVC_OpenAlias("ZP8")
        lDup := _MVC_FindInZP8(cProj, cId, cFil, @nDummy)
        If lDup
            MsgInfo("Contato já vinculado ao projeto.", "ZP8")
        Else
            If RecLock("ZP8", .T.)
                If FieldPos("ZP8_FILIAL")>0 ; ZP8->ZP8_FILIAL := cFil  ; EndIf
                If FieldPos("ZP8_COD")   >0 ; ZP8->ZP8_COD    := cProj ; EndIf
                If FieldPos("ZP8_CONTID")>0 ; ZP8->ZP8_CONTID := cId   ; EndIf
                If FieldPos("ZP8_NOME")  >0 ; ZP8->ZP8_NOME   := cNm   ; EndIf
                If FieldPos("ZP8_EMAIL") >0 ; ZP8->ZP8_EMAIL  := cEm   ; EndIf
                If FieldPos("ZP8_GRUPO") >0 ; ZP8->ZP8_GRUPO  := 0     ; EndIf
                If FieldPos("ZP8_ORDEM") >0 ; ZP8->ZP8_ORDEM  := 0     ; EndIf
                MsUnLock()
                lOk := .T.
            EndIf
        EndIf
        ZP8->( dbCloseArea() )
    EndIf

    If lOk ; MsgInfo("Vinculado.", "ZP8") ; EndIf
Return lOk

Static Function _MVC_Desvincular(cProj, cId)
    Local cFil := xFilial("ZP8")
    Local lOk  := .F.
    Local nRec := 0
    Local lFound := .F.

    If Empty(cId)
        Return .F.
    EndIf

    If _MVC_OpenAlias("ZP8")
        lFound := _MVC_FindInZP8(cProj, cId, cFil, @nRec)
        If lFound
            ZP8->( dbGoto(nRec) )
            If RecLock("ZP8", .F.)
                ZP8->( DbDelete() )
                MsUnLock()
                lOk := .T.
            EndIf
        EndIf
        ZP8->( dbCloseArea() )
    EndIf

    If lOk ; MsgInfo("Desvinculado.", "ZP8") ; EndIf
Return lOk

Static Function _MVC_EditOrd(cProj, cId, nG, nO)
    Local cFil := xFilial("ZP8")
    Local lOk  := .F.
    Local nRec := 0
    Local lFound := .F.
    Local lLocked := .F.

    If Empty(cId)
        Return .F.
    EndIf

    If _MVC_OpenAlias("ZP8")
        lFound := _MVC_FindInZP8(cProj, cId, cFil, @nRec)
        If lFound
            ZP8->( dbGoto(nRec) )
            lLocked := RecLock("ZP8", .F.)
            If lLocked
                If FieldPos("ZP8_GRUPO")>0 ; ZP8->ZP8_GRUPO := nG ; EndIf
                If FieldPos("ZP8_ORDEM")>0 ; ZP8->ZP8_ORDEM := nO ; EndIf
                MsUnlock()
                lOk := .T.
            EndIf
        EndIf
        ZP8->( dbCloseArea() )
    EndIf

    If lOk ; MsgInfo("Atualizado.", "ZP8") ; EndIf
Return lOk

Static Function _MVC_FindInZP8(cProj, cId, cFil, nRecnoOut)
    Local lFound := .F.
    Local lHasOrd:= .F.

    BEGIN SEQUENCE
        ZP8->( dbSetOrder(1) )
        lHasOrd := .T.
    RECOVER
        lHasOrd := .F.
    END SEQUENCE

    If lHasOrd
        ZP8->( dbSeek( cFil + cProj ) )
        While ! ZP8->(EoF()) .and. ZP8->ZP8_FILIAL == cFil .and. ZP8->ZP8_COD == cProj
            If AllTrim(ZP8->ZP8_CONTID) == cId .and. ZP8->(Deleted()) == .F.
                nRecnoOut := ZP8->( Recno() )
                lFound := .T.
                Exit
            EndIf
            ZP8->( dbSkip() )
        EndDo
    Else
        ZP8->( dbGoTop() )
        While ! ZP8->(EoF())
            If ZP8->(Deleted()) == .F. .and. ZP8->ZP8_FILIAL == cFil .and. ;
               ZP8->ZP8_COD == cProj .and. AllTrim(ZP8->ZP8_CONTID) == cId
                nRecnoOut := ZP8->( Recno() )
                lFound := .T.
                Exit
            EndIf
            ZP8->( dbSkip() )
        EndDo
    EndIf
Return lFound

Static Function _MVC_GetFieldVal(aTryIds)
    Local nI := 0
    Local x  := ""
    For nI := 1 To Len(aTryIds)
        If FieldPos(aTryIds[nI]) > 0
            x := Field->( FieldGet(FieldPos(aTryIds[nI])) )
            Exit
        EndIf
    Next
Return AllTrim(x)

Static Function _MVC_OpenAlias(cAlias)
    Local lOk := .F.
    Local cPhys := RetSqlName(cAlias)
    If Empty(cPhys)
        Return .F.
    EndIf
    BEGIN SEQUENCE
        dbUseArea(.T., "TOPCONN", cPhys, cAlias, .F., .F.)
        lOk := Used()
    RECOVER
        lOk := .F.
    END SEQUENCE
Return lOk
