#include "Protheus.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ LJ720PROX  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 19/06/2008 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada de validação de troca da 1a pasta            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function LJ720PROX()
 Local oPsw    := Nil 
 Local lRet    := .F.
 Local oFont1  := TFont():New("Courier New",,-14,.T.,.T.)
 Local cPswFol := Space(06)
 Local cCodUsr := Space(06)
 Local cNomUsr := Space(Len(cUserName))
                         
	
	If ParamIXB[2] <> 2   
		Return .T.
	EndIf 
	
   cUsuLib := cNomUsr  // Inicializa usuário com espaços vazios

   DEFINE MSDIALOG oPsw TITLE "Troca / Devolução" From 12,10 To 24 ,38 OF oMainWnd

	   @ 10,005 SAY "Codigo..:" PIXEL OF oPsw
	   @ 10,035 MSGET cCodUsr   SIZE 40,10 PIXEL OF oPsw FONT oFont1 F3 "USR" Valid ChkUsuario(cCodUsr,@cNomUsr)
	
	   @ 30,005 SAY "Usuário.:" PIXEL OF oPsw
	   @ 30,035 MSGET cNomUsr   SIZE 70,10 PIXEL OF oPsw FONT oFont1 WHEN .F.
	
	   @ 50,005 SAY "Senha...:" PIXEL OF oPsw
	   @ 50,035 GET cPswFol PASSWORD SIZE 30,10 PIXEL OF oPsw FONT oFont1 WHEN !Empty(cCodUsr) Valid (ChkSenha(cCodUsr,cPswFol) )
	
	   @ 70,20 BUTTON oBut1 PROMPT "&Ok"      SIZE 30,12 OF oPsw PIXEL;
	                        Action If( lRet := ChkSenha(cCodUsr,cPswFol) , (oPsw:End(),cUsuLib:=cNomUsr), )
	   @ 70,60 BUTTON oBut2 PROMPT "&Cancela" SIZE 30,12 OF oPsw PIXEL;
	                        Action (oPsw:End(),lRet := .F.)
	
   ACTIVATE MSDIALOG oPsw CENTERED
//lRet := .F.
Return lRet                 

//**************************************************************************************************************************

Static Function ChkUsuario(cCodUsr,cNome)
   Local lwRet := .F.     
   
   If Empty(cCodUsr) 
     Return .T.
   EndIf 
   
   SX5->(dbSetOrder(1))
   PswOrder(1)

   If lRet := (PswSeek(cCodUsr))
   	If cCodUsr $ GetMv("MV_XUSUDEV")
   	 		cNome := RetCodUsr(cCodUsr)
   	 		lwRet := .T.
   	 	Else 
   	 		Alert("Usuário não possui acesso a esta operação. Contacte o administrador do sistema !")
      EndIf 
   Else
      Alert("Usuário não encontrado no protheus!")
   Endif

Return lwRet


Static Function ChkSenha(cCodUsr,cPassWord)
   Local lRet := .T.

   PswOrder(1)
   PswSeek(cCodUsr)

   If !(lRet := PswName(cPassWord))
      Alert("Senha Inválida. Contacte o administrador do sistema !")
   Endif

Return(lRet)

//***************************************************************************************************************************
Static Function RetCodUsr(cCodUsr)
   Local aUser, cUserAnt

   PswOrder(1)               // (1) Codigo , (2) Nome
   PswSeek(Alltrim(cCodUsr)) // Pesquisa usuário
   aUser := PswRet(1)        // Retorna Matriz com detalhes, acessos do Usuário
   cUserAnt := aUser[1][2]   // Retorna codigo do usuário [1] ou o Nome [2]

Return(cUserAnt)
