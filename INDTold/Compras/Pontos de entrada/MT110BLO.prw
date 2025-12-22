#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT110BLO ºAutor  ³ Ronilton O. Barros º Data ³  03.08.2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE usado após a confirmação da aprovação da solicitação    º±±
±±º          ³ O mesmo será usado para liberar somente se os aprovadores  º±±
±±º          ³ foram cadastrados corretamente.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT110BLO
   Local cMens, cEmail
   Local lRet := .T.
   Local cNum := SC1->(C1_FILIAL+C1_NUM)
   Local aTab := { "SC1", "SY1", Alias()}

   If ParamIXB[1] <> 1   // Se a aprovação não foi confirmada
      Return lRet
   Endif

   aTab := u_SalvaRest(aTab)

   If mv_par02 == 1   // Se aprovação for por SC
      SC1->(dbSetOrder(1))
      SC1->(dbSeek(cNum,.T.))
      While lRet .And. !SC1->(Eof()) .And. cNum == SC1->(C1_FILIAL+C1_NUM)
         lRet := !Empty(SC1->C1_CODCOMP)  // Se não foi informado o comprador
         SC1->(dbSkip())
      Enddo
   Else               // Se aprovação for por item
      lRet := !Empty(SC1->C1_CODCOMP)  // Se não foi informado o comprador
   Endif

   If lRet
      SY1->(dbSetOrder(1))
      SY1->(dbSeek(XFILIAL("SY1")+SC1->C1_CODCOMP))

      cEmail := If( !Empty(SY1->Y1_EMAIL) , AllTrim(SY1->Y1_EMAIL)+";", "")
      cEmail += AllTrim(UsrRetMail(SC1->C1_USER))
		SAJ->(DbSetOrder(1))
		SAJ->(DbSeek(xFilial("SAJ")+"CONTRO"))
		While !SAJ->(Eof()) .And. SAJ->AJ_GRCOM == "CONTRO"
			cEmail += IIf(Empty(cEmail),"",";")+AllTrim(UsrRetMail(SAJ->AJ_USER))
			SAJ->(DbSkip())
		End                  
                 
      If !Empty(cEmail)
         MsgRun("Enviando para e-mail aos usuários ","",{|| INSendMail(cEmail) })
      Else
         Alert("Favor definir os emails do comprador "+AllTrim(SY1->Y1_NOME)+" e usuário da solicitação "+AllTrim(UsrRetName(SC1->C1_USER))+" !")
      Endif
   Else
      Alert("Favor definir um comprador para a Solicitação !")
   Endif

   u_SalvaRest(aTab,.F.)

Return lRet

Static Function INSendMail(cEmail)
   Local cMens := ""
	cMens := '<html>
	cMens += '<head>
	cMens += '<meta http-equiv="Content-Language" content="en-us">
	cMens += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
	cMens += '<title>Solicitação de Compra</title>
	cMens += u_INCOMWST(.F.)
	cMens += '</head>
	cMens += '<form method="POST" action="">
	cMens += '<body>
	cMens += "<P>A solicitação "+SC1->C1_NUM+", filial "+NomeFilial(SC1->C1_FILIAL)+" foi enviada para o negociador: "+AllTrim(SY1->Y1_NOME)+" </p>" 
	cMens += U_INCOMW02(SC1->C1_FILIAL,SC1->C1_NUM)
	cMens += '</body>
	cMens += '</form>
	cMens += "</html> 

   u_INMEMAIL("Solicitação enviada para o negociador",cMens,cEmail)
Return

Static Function NomeFilial(cFil)
   Local cRet := ""

   If cFil == "01"
      cRet := "Manaus"
   ElseIf cFil == "02"
      cRet := "Brasilia"
   ElseIf cFil == "03"
      cRet := "Recife"
   ElseIf cFil == "04"
      cRet := "São Paulo"
   EndIf

Return cRet
