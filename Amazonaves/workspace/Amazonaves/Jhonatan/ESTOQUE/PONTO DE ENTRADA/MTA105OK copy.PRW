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

Local lRet     := .T.
Local cCodUser := (ACOLS[][aScan(aHeader,{|x| AllTrim(x[2]) == "CP_USER"})])   //14
Local cNumOs   := (ACOLS[][aScan(aHeader,{|x| AllTrim(x[2]) == "CP_XNUMOS"})]) //7
Local cObs     := (ACOLS[][aScan(aHeader,{|x| AllTrim(x[2]) == "CP_XOBS"})])   //9

    If  cCodUser <>  __cUserID   // Valida se o usuario logado é o mesmo que criou a solicitacao     

    lRet := .F.
    MsgInfo("Usuario Nao Autorizado a Alterar Essa Solicitacao","Validacao de Usuario")


    ElseIf ALLTRIM(cNumOs) == "999" .AND. Empty(cObs) // Valida se o usuario preencheu a observacao caso a OS seja 999      

    lRet := .F.
    MsgInfo("Favor preencher campo observacao","Validacao de Usuario")

    Else
    lRet := .T.
        If Inclui
            MsgInfo("Solicitacao Incluida com Sucesso","Validacao de Usuario")
        Else
            MsgInfo("Solicitacao Alterada com Sucesso","Validacao de Usuario")
        EndIf    
    Endif 

Return ( lRet )



