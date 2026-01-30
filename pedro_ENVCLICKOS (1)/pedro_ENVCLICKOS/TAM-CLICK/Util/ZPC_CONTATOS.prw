#Include "Protheus.ch"
#Include "Totvs.ch"

/*/{Protheus.doc} ZPC_CONTATOS
    Vincula Contatos (AC8) ao Projeto (ZPC) na tabela ZP8
    - Esquerda: contatos do cliente (AC8 ENTIDA='SA1')
    - Direita : vínculos do projeto (ZP8) com Grupo/Ordem (Clicksign)
/*/
User Function ZPC_CONTATOS()
    Local aArea     := GetArea()
    Local cRDD      := ""
    Local oDlg      := NIL
    Local oBrwL     := NIL
    Local oBrwR     := NIL
    Local cProj     := ""
    Local cA1       := ""
    Local cLoja     := "01"
    Local aDisp     := {}     // AC8: {CodCon, Nome, Email}
    Local aVinc     := {}     // ZP8: {CodCon, Nome, Email, Grupo, Ordem}
    Local nW        := 0
    Local nH        := 0
    Local nL        := 0
    Local nT        := 0
    Local lOrderOn  := .F.
    Local lFromAx   := .F.

    // Ambiente minimo exigido em algumas 050
    If Type("cEmpAnt") == "U" ; Private cEmpAnt := "01" ; EndIf
    If Type("cFilAnt") == "U" ; Private cFilAnt := "01" ; EndIf
    If Type("cAcesso") == "U" ; Private cAcesso := ""   ; EndIf

    cRDD := Upper(RddName())
    If cRDD <> "TOPCONN"
        RddSetDefault("TOPCONN")
        DbSetDriver   ("TOPCONN")
    EndIf

    // Detecta projeto/cliente da ZPC aberta (AxCadastro)
    If Select("ZPC") > 0 .and. ! ZPC->(EoF())
        If FieldPos("ZPC_COD")  > 0 ; cProj := AllTrim(ZPC->ZPC_COD)  ; EndIf
        If FieldPos("ZPC_ACOD") > 0 ; cA1   := AllTrim(ZPC->ZPC_ACOD) ; EndIf
        If FieldPos("ZPC_ALOJ") > 0 ; cLoja := AllTrim(ZPC->ZPC_ALOJ) ; EndIf
        lFromAx := !( Empty(cProj) .or. Empty(cA1) )
    EndIf

    // Se nao veio do AxCadastro, pergunta
    If ! lFromAx
        If ! MsgYesNo("Projeto/Cliente não detectados. Informar manualmente?")
            RestArea(aArea)
            Return
        EndIf
        cProj := Space(12)
        cA1   := Space(14)
        cLoja := "01"
        If ! MsGet( , , "Informe o Projeto (ZPC_COD):", @cProj )
            RestArea(aArea)
            Return
        EndIf
        If ! MsGet( , , "Informe o Cliente (A1_COD):", @cA1 )
            RestArea(aArea)
            Return
        EndIf
        MsGet( , , "Informe a Loja (A1_LOJA) [opcional]:", @cLoja )
        cProj := AllTrim(cProj)
        cA1   := AllTrim(cA1)
        cLoja := AllTrim(cLoja)
    EndIf

    // Carrega listas
    aDisp := _ZP8_LoadAC8(cA1, cLoja)
    aVinc := _ZP8_LoadZP8(cProj)

    // UI
    nW := 1000 ; nH := 560 ; nL := 0 ; nT := 0
    DEFINE MSDIALOG oDlg TITLE "Contatos do Projeto " + cProj FROM nT, nL TO nH, nW PIXEL
    @ 006, 010 SAY "Contatos do cliente (AC8)"      SIZE 220,12 PIXEL OF oDlg
    @ 006, 520 SAY "Vinculados ao projeto (ZP8)"    SIZE 220,12 PIXEL OF oDlg

    oBrwL := TCBrowse():New( 020, 010, 470, 480, , ;
                             {"Contato","Nome","E-mail"}, {90,230,230}, oDlg )
    oBrwL:SetArray(aDisp)
    oBrwL:bLine := {|| _ZP8_Line(aDisp, oBrwL) }

    oBrwR := TCBrowse():New( 020, 520, 970, 480, , ;
                             {"Contato","Nome","E-mail","Grupo","Ordem"}, {90,230,230,80,80}, oDlg )
    oBrwR:SetArray(aVinc)
    oBrwR:bLine := {|| _ZP8_LineV(aVinc, oBrwR) }

    @ 240, 490 BUTTON ">>" SIZE 24,20 PIXEL OF oDlg ;
        ACTION ( _ZP8_Vincular(cProj,cA1,cLoja,@aDisp,@aVinc,oBrwL,oBrwR), ;
                 aVinc := _ZP8_LoadZP8(cProj), oBrwR:SetArray(aVinc), oBrwR:Refresh() )

    @ 270, 490 BUTTON "<<" SIZE 24,20 PIXEL OF oDlg ;
        ACTION ( _ZP8_Desvincular(cProj,@aVinc,oBrwR), ;
                 aVinc := _ZP8_LoadZP8(cProj), oBrwR:SetArray(aVinc), oBrwR:Refresh() )

    @ 510, 520 CHECKBOX lOrderOn PROMPT "Ativar ordenação de assinaturas (grupo/ordem)" SIZE 420,14 PIXEL OF oDlg
    @ 510, 920 BUTTON "Editar..." SIZE 60,18 PIXEL OF oDlg ;
        ACTION ( _ZP8_EditOrd(cProj,@aVinc,oBrwR,lOrderOn), ;
                 aVinc := _ZP8_LoadZP8(cProj), oBrwR:SetArray(aVinc), oBrwR:Refresh() )

    @ 510, 010 BUTTON "Fechar" SIZE 60,18 PIXEL OF oDlg ACTION oDlg:End()
    ACTIVATE MSDIALOG oDlg CENTERED

    RestArea(aArea)
Return

// -------- helpers de linha (seguros para array vazio) --------
Static Function _ZP8_Line(aData, oBrw)
    Local n := oBrw:nAt
    If Len(aData) == 0 .or. n <= 0 .or. n > Len(aData)
        Return {"","",""}
    EndIf
Return { aData[n,1], aData[n,2], aData[n,3] }

Static Function _ZP8_LineV(aData, oBrw)
    Local n := oBrw:nAt
    If Len(aData) == 0 .or. n <= 0 .or. n > Len(aData)
        Return {"","","",0,0}
    EndIf
Return { aData[n,1], aData[n,2], aData[n,3], aData[n,4], aData[n,5] }

// -------- leitura AC8 / AC9 (opcional) --------
Static Function _ZP8_LoadAC8(cA1, cLoja)
    Local aRet     := {}
    Local lOpen8   := .F.
    Local lOpen9   := .F.
    Local aAC9     := {}      // {CodCon, Nome, Email}
    Local cEnt     := "SA1"
    Local cCodCon  := ""
    Local cNm      := ""
    Local cEm      := ""

    // tenta carregar nomes/emails da AC9 (se existir na base)
    BEGIN SEQUENCE
        dbUseArea(.T., "TOPCONN", "", "AC9", .F., .F.)
        lOpen9 := .T.
        AC9->( dbGoTop() )
        While ! AC9->(EoF())
            cCodCon := AllTrim( IIf(FieldPos("AC9_CODCON")>0, AC9->( FieldGet(FieldPos("AC9_CODCON")) ), "" ) )
            cNm     := AllTrim( IIf(FieldPos("AC9_NOME")  >0, AC9->( FieldGet(FieldPos("AC9_NOME"))   ), "" ) )
            cEm     := AllTrim( IIf(FieldPos("AC9_EMAIL") >0, AC9->( FieldGet(FieldPos("AC9_EMAIL"))  ), "" ) )
            AAdd(aAC9, { cCodCon, cNm, cEm })
            AC9->( dbSkip() )
        EndDo
    RECOVER
        // ignora se nao existir
    END SEQUENCE

    // AC8
    BEGIN SEQUENCE
        dbUseArea(.T., "TOPCONN", "", "AC8", .F., .F.)
        lOpen8 := .T.
        AC8->( dbGoTop() )
        While ! AC8->(EoF())
            If AC8->(Deleted()) == .F. .and. ;
               AllTrim(IIf(FieldPos("AC8_ENTIDA")>0, AC8->AC8_ENTIDA, "")) == cEnt .and. ;
               AllTrim(IIf(FieldPos("AC8_CODENT")>0, AC8->AC8_CODENT, "")) == cA1
                cCodCon := AllTrim(IIf(FieldPos("AC8_CODCON")>0, AC8->AC8_CODCON, ""))
                // procura dados na aAC9
                cNm := ""
                cEm := ""
                _FindAC9(aAC9, cCodCon, @cNm, @cEm)
                AAdd(aRet, { cCodCon, cNm, cEm })
            EndIf
            AC8->( dbSkip() )
        EndDo
    RECOVER
        aRet := {}
    END SEQUENCE

    If lOpen9 ; AC9->( dbCloseArea() ) ; EndIf
    If lOpen8 ; AC8->( dbCloseArea() ) ; EndIf

    // Ordena por Nome (se vazio, pelo Código)
    ASort(aRet,,,{|x,y| IIf(Empty(x[2]) .and. Empty(y[2]), x[1] < y[1], ;
                       IIf(Empty(x[2]) , .T., IIf(Empty(y[2]), .F., x[2] < y[2])) )})
Return aRet

Static Function _FindAC9(aAC9, cCodCon, cNm, cEm)
    Local i := 0
    For i := 1 To Len(aAC9)
        If aAC9[i,1] == cCodCon
            cNm := aAC9[i,2]
            cEm := aAC9[i,3]
            Exit
        EndIf
    Next
Return

// -------- leitura / gravação ZP8 --------
Static Function _ZP8_LoadZP8(cProj)
    Local aRet   := {}
    Local lOpen  := .F.
    Local cFil   := xFilial("ZP8")

    BEGIN SEQUENCE
        dbUseArea(.T., "TOPCONN", "", "ZP8", .F., .F.)
        lOpen := .T.

        BEGIN SEQUENCE
            ZP8->( dbSetOrder(2) ) // por projeto
            ZP8->( dbSeek( cFil + cProj ) )
            While ! ZP8->(EoF()) .and. ZP8->ZP8_FILIAL == cFil .and. ZP8->ZP8_COD == cProj .and. ZP8->(Deleted()) == .F.
                AAdd(aRet, { AllTrim(ZP8->ZP8_CONTID), ;
                             AllTrim(IIf(FieldPos("ZP8_NOME") >0, ZP8->ZP8_NOME , "")), ;
                             AllTrim(IIf(FieldPos("ZP8_EMAIL")>0, ZP8->ZP8_EMAIL, "")), ;
                             IIf(FieldPos("ZP8_GRUPO")>0 .and. !Empty(ZP8->ZP8_GRUPO), ZP8->ZP8_GRUPO, 0), ;
                             IIf(FieldPos("ZP8_ORDEM")>0 .and. !Empty(ZP8->ZP8_ORDEM), ZP8->ZP8_ORDEM, 0) })
                ZP8->( dbSkip() )
            EndDo
        RECOVER
            ZP8->( dbGoTop() )
            While ! ZP8->(EoF())
                If ZP8->(Deleted()) == .F. .and. ZP8->ZP8_FILIAL == cFil .and. ZP8->ZP8_COD == cProj
                    AAdd(aRet, { AllTrim(ZP8->ZP8_CONTID), ;
                                 AllTrim(IIf(FieldPos("ZP8_NOME") >0, ZP8->ZP8_NOME , "")), ;
                                 AllTrim(IIf(FieldPos("ZP8_EMAIL")>0, ZP8->ZP8_EMAIL, "")), ;
                                 IIf(FieldPos("ZP8_GRUPO")>0 .and. !Empty(ZP8->ZP8_GRUPO), ZP8->ZP8_GRUPO, 0), ;
                                 IIf(FieldPos("ZP8_ORDEM")>0 .and. !Empty(ZP8->ZP8_ORDEM), ZP8->ZP8_ORDEM, 0) })
                EndIf
                ZP8->( dbSkip() )
            EndDo
        END SEQUENCE
    RECOVER
        aRet := {}
    END SEQUENCE

    If lOpen ; ZP8->( dbCloseArea() ) ; EndIf

    ASort(aRet,,,{|x,y| StrZero(x[4],2)+StrZero(x[5],4) < StrZero(y[4],2)+StrZero(y[5],4) })
Return aRet

Static Function _ZP8_Vincular(cProj,cA1,cLoja, aDisp, aVinc, oBrwL, oBrwR)
    Local nL      := oBrwL:nAt
    Local cFil    := xFilial("ZP8")
    Local cId     := ""
    Local cNm     := ""
    Local cEm     := ""
    Local lLocked := .F.

    If nL <= 0 .or. nL > Len(aDisp)
        Return
    EndIf

    cId := aDisp[nL,1]
    cNm := aDisp[nL,2]
    cEm := aDisp[nL,3]

    dbUseArea(.T., "TOPCONN", "", "ZP8", .F., .F.)

    BEGIN SEQUENCE
        ZP8->( dbSetOrder(1) )
    RECOVER
    END SEQUENCE

    If ZP8->( dbSeek( cFil + cProj + cId ) )
        MsgAlert("Contato já vinculado ao projeto.", "ZP8")
        ZP8->( dbCloseArea() )
        Return
    EndIf

    lLocked := RecLock("ZP8", .T.)
    If lLocked
        ZP8->ZP8_FILIAL := cFil
        ZP8->ZP8_COD    := PadR(cProj,  Len(ZP8->ZP8_COD   ))
        If FieldPos("ZP8_A1COD") > 0 ; ZP8->ZP8_A1COD  := PadR(cA1 , Len(ZP8->ZP8_A1COD )) ; EndIf
        If FieldPos("ZP8_A1LOJA")> 0 ; ZP8->ZP8_A1LOJA := PadR(cLoja,Len(ZP8->ZP8_A1LOJA)) ; EndIf
        ZP8->ZP8_CONTID := PadR(cId ,  Len(ZP8->ZP8_CONTID ))
        If FieldPos("ZP8_NOME")  > 0 ; ZP8->ZP8_NOME   := PadR(cNm , Len(ZP8->ZP8_NOME  )) ; EndIf
        If FieldPos("ZP8_EMAIL") > 0 ; ZP8->ZP8_EMAIL  := PadR(cEm , Len(ZP8->ZP8_EMAIL )) ; EndIf
        If FieldPos("ZP8_GRUPO") > 0 ; ZP8->ZP8_GRUPO  := 0 ; EndIf
        If FieldPos("ZP8_ORDEM") > 0 ; ZP8->ZP8_ORDEM  := 0 ; EndIf
        MsUnlock()
        MsgInfo("Vinculado.", "ZP8")
    Else
        MsgStop("Não foi possível bloquear ZP8 para incluir.", "ZP8")
    EndIf

    ZP8->( dbCloseArea() )
Return

Static Function _ZP8_Desvincular(cProj, aVinc, oBrwR)
    Local nR      := oBrwR:nAt
    Local cFil    := xFilial("ZP8")
    Local cId     := ""
    Local lLocked := .F.

    If nR <= 0 .or. nR > Len(aVinc)
        Return
    EndIf

    cId := aVinc[nR,1]

    dbUseArea(.T., "TOPCONN", "", "ZP8", .F., .F.)

    BEGIN SEQUENCE
        ZP8->( dbSetOrder(1) )
    RECOVER
    END SEQUENCE

    If ZP8->( dbSeek( cFil + cProj + cId ) )
        lLocked := RecLock("ZP8", .F.)
        If lLocked
            ZP8->( dbDelete() )
            MsUnlock()
            MsgInfo("Desvinculado.", "ZP8")
        Else
            MsgStop("Não foi possível bloquear ZP8 para excluir.", "ZP8")
        EndIf
    Else
        MsgAlert("Registro não encontrado.", "ZP8")
    EndIf

    ZP8->( dbCloseArea() )
Return

Static Function _ZP8_EditOrd(cProj, aVinc, oBrwR, lOrderOn)
    Local nR      := oBrwR:nAt
    Local cFil    := xFilial("ZP8")
    Local cId     := ""
    Local nG      := 0
    Local nO      := 0
    Local lLocked := .F.
    Local lOk     := .F.

    If ! lOrderOn
        MsgAlert("Ative a ordenação para editar Grupo/Ordem.", "ZP8")
        Return
    EndIf

    If nR <= 0 .or. nR > Len(aVinc)
        Return
    EndIf

    cId := aVinc[nR,1]
    nG  := aVinc[nR,4]
    nO  := aVinc[nR,5]

    If ! MsGet( , , "Grupo (Clicksign):", @nG )
        Return
    EndIf
    If ! MsGet( , , "Ordem:", @nO )
        Return
    EndIf

    dbUseArea(.T., "TOPCONN", "", "ZP8", .F., .F.)

    BEGIN SEQUENCE
        ZP8->( dbSetOrder(1) )
    RECOVER
    END SEQUENCE

    If ZP8->( dbSeek( cFil + cProj + cId ) )
        lLocked := RecLock("ZP8", .F.)
        If lLocked
            If FieldPos("ZP8_GRUPO")>0 ; ZP8->ZP8_GRUPO := nG ; EndIf
            If FieldPos("ZP8_ORDEM")>0 ; ZP8->ZP8_ORDEM := nO ; EndIf
            MsUnlock()
            lOk := .T.
        EndIf
    EndIf

    ZP8->( dbCloseArea() )

    If lOk
        MsgInfo("Atualizado.", "ZP8")
    EndIf
Return
