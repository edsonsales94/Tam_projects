#Include "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MT110CON   ¦ Autor ¦ Jhonatan S. Lobato   ¦ Data ¦ 12/06/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Continua ou interrompe o processo de gravação da SC           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/



User Function MT110CON()

Local lGrava  := .T.
//Paramixb[1] = Numero da SC
//Paramixb[2] = Solicitante
//Paramixb[3] = Data da SC
//Paramixb[4] = Centro de Custo
//Paramixb[5] = Unidade Requisitante
//Paramixb[6] = Codigo do Comprador

    If  ALLTRIM(PARAMIXB[2]) <> PswChave(RetCodUsr())   // Valida se o usuario logado é o mesmo que criou a solicitacao     

    lGrava := .F.
    MsgInfo("Usuario Nao Autorizado a Gravar Essa Solicitacao","Validacao de Usuario")

    Else
    lGrava := .T.
    MsgInfo("Solicitacao Gravada com Sucesso","Validacao de Usuario")
    
    Endif

Return ( lGrava ) 
