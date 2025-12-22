#Include "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MTA105OK   ¦ Autor ¦ Jhonatan S. Lobato   ¦ Data ¦ 12/06/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Confirma a gravação da solicitação ao almoxarifado            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function MTA105OK()

Local lRet := .T.
Local nUserIndex := 0
Local nOsIndex := 0
Local nObsIndex := 0
Local i := 0
Local cCodUser := ""
Local cNumOs := ""
Local cObs := ""

// Localizando os índices dos cabeçalhos
nUserIndex := aScan(aHeader, {|x| AllTrim(x[2]) == "CP_USER"})
nOsIndex := aScan(aHeader, {|x| AllTrim(x[2]) == "CP_XNUMOS"})
nObsIndex := aScan(aHeader, {|x| AllTrim(x[2]) == "CP_XOBS"})

//If nUserIndex > 0 .AND. nOsIndex > 0 .AND. nObsIndex > 0
    For i := 1 To Len(ACOLS)
        // Acessando os valores no array ACOLS
        cCodUser := ACOLS[i][nUserIndex]
        cNumOs := ACOLS[i][nOsIndex]
        cObs := ACOLS[i][nObsIndex]

        If cCodUser <> __cUserID  // Valida se o usuario logado é o mesmo que criou a solicitacao
            lRet := .F.
            MsgInfo("Usuario Nao Autorizado a Alterar Essa Solicitacao", "Validacao de Usuario")
            Exit
        ElseIf AllTrim(cNumOs) == "999" .AND. Empty(cObs)  // Valida se o usuario preencheu a observacao caso a OS seja 999
            lRet := .F.
            MsgInfo("Favor preencher campo observacao", "Linha " + Alltrim(Str(i)))
            Exit
        Else
            lRet := .T.
            If i == Len(aCols)
                If Inclui
                MsgInfo("Solicitacao Incluida com Sucesso", "Validacao de Usuario")
                Else
                MsgInfo("Solicitacao Alterada com Sucesso", "Validacao de Usuario")
                EndIf
            EndIf        
        EndIf
    Next
//Else
//    lRet := .F.
//    MsgInfo("Erro ao localizar indices dos cabeçalhos", "Erro")
//EndIf

Return (lRet)
