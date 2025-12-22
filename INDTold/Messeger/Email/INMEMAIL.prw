#INCLUDE "Rwmake.ch"
#include "ap5mail.ch"

User Function INMEMAIL(cTitulo,cMens,cEmail)
	Local cMsg
	Local cAccount := GetMv("MV_RELACNT")  //Conta de Envio de Relatorios por e-mail
	Local cServer  := GetMv("MV_RELSERV")  // IP do Servidor de e-mails
	Local cPass    := GetMv("MV_RELPSW")   // Senha da Conta de e-mail
	Local cErro    := ""
	Local lResult  := .F.
	
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass RESULT lResult
	
	//- Se a conexao com o SMPT esta ok e se existe autenticacao para envio valida pela funcao MAILAUTH
	If lResult .And. (!GetMv("MV_RELAUTH") .Or. Mailauth("anbandei",alltrim(cPass)))
		qout(Dtoc(Date())+Time()+" Email - "+cTitulo)
		qout("enviando para"+cEmail)
		
		cMsg := '  <html>'
		cMsg += '<head>'
		cMsg += '<title>'+cTitulo+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += cMens
		cMsg += '</body>'
		cMsg += '</html>'
		
		SEND MAIL	FROM cAccount;
						TO cEmail;
						SUBJECT cTitulo;
						BODY cMsg;
						RESULT lResult
		
		GET MAIL ERROR cErro
	EndIf
	
	DISCONNECT SMTP SERVER
	
	If !lResult
		MsgAlert(If(Empty(cErro),"Ocorreu um erro no envio do e-mail!",cErro))
	Endif
	
Return lResult
