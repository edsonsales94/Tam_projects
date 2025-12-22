#include "ap5mail.ch"
#include "Protheus.Ch"
#include "TopConn.Ch"
#include "TBIConn.Ch"

/*/{protheus.doc}Rhemail

Envio de Mensagens individuais para colaboradores HLS   

@author Luciano Lamberti
@since 30/07/2020

*/

User Function Rhemail()

	Local aArea			:= GetArea()
	Local aAreaSRA		:= SRA->(GetArea())
	Local cMailDest   	:= "" //"lucianolamberti@gmail.com"
	Local cAssunto    	:= ""//"COMUNICADO RH em: "+ Dtoc(Date()) +" Ás "+ SubStr(Time(), 1, 5) 
	Local cMensagem	  	:= ""	
	Local cQuery		:= ""
	Local cAliasQry		:= GetNextAlias()
	Local cPula     	:= CHR(13) + CHR(10)

	If ValidPerg()

		cQuery := "SELECT "
		cQuery += "		SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NOME, SRA.RA_SERVICO, SRA.RA_EMAIL "
		cQuery += "FROM "+ RetSqlTab("SRA") +" "
		cQuery += "WHERE "
		cQuery += "		"+ RetSqlDel("SRA") +" "
		cQuery += "		AND "+ RetSqlFil("SRA") +" "
		cQuery += "		AND SRA.RA_MAT BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' "
		cQuery += "		AND SRA.RA_SITFOLH <> 'D' "
		cQuery := ChangeQuery(cQuery)

		MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)

		While !(cAliasQry)->(Eof())

			//cMailDest	:= AllTrim((cAliasQry)->RA_EMAIL)
			cMailDest	:= 'lucianolamberti@gmail.com'
			cAssunto    := "COMUNICADO RH em: "+ Dtoc(Date()) +" Ás "+ SubStr(Time(), 1, 5) + " USUARIO E SENHA" 
			cMensagem	:= AllTrim((cAliasQry)->RA_SERVICO) +cPula+cPula
			cMensagem 	+= "Acesso a Pesquisa de Clima Organizacional 2020"+cPula+cPula
			cMensagem 	+= "https://pesquisa.gptw.com.br/375362"+cPula+cPula

			SendMail(cMailDest, cAssunto, cMensagem)

			(cAliasQry)->(DbSkip())

		EndDo

		(cAliasQry)->(DbCloseArea())

 	EndIf 

	RestArea(aAreaSRA)
	RestArea(aArea)

Return Nil

Static Function ValidPerg()

	Local aRet		:= {}
	Local aParamBox	:= {}
	Local lRet 		:= .F.
		
	aAdd(aParamBox,{1, "Matricula de",  Space(TamSX3("RA_MAT")[1]), "", "", "SRA", "", 40, .F.})	// MV_PAR01
	aAdd(aParamBox,{1, "Matricula até", Space(TamSX3("RA_MAT")[1]), "", "", "SRA", "", 40, .F.})	// MV_PAR02	
	
	If ParamBox(aParamBox, "HLRHMAIL", @aRet,,,,,,, "HLRHMAIL", .T., .T.)
		lRet := .t.
	EndIf

Return lRet

Static Function SendMail(cMailDest, cAssunto, cMensagem)
	
	Local lConnect   	:= .F.
	Local lEnv        	:= .F.
	Local lFim        	:= .F.
	Local lAuth			:= GetMv("MV_RELAUTH")
	Local cMailServer 	:= GETMV("MV_RELSERV") 
	Local cMailContX  	:= GETMV("MV_RELACNT")
	Local cMailSenha  	:= GETMV("MV_RELAPSW") 

	CONNECT SMTP SERVER cMailServer ACCOUNT cMailContX PASSWORD cMailSenha RESULT lConnect

	IF lAuth
		MailAuth(cMailContX, cMailSenha)
	EndIF

	If lConnect  // testa se a conexÃ£o foi feita com sucesso

		SEND MAIL FROM cMailContX TO cMailDest SUBJECT cAssunto BODY cMensagem RESULT lEnv
		
		//MsgAlert("Email enviado")
		ConOut("Email enviado ["+ cMailDest +"]")

	Endif

	If !lEnv
		
		GET MAIL ERROR cErro

		ConOut("Email nao enviado ["+ cMailDest +"]")

	EndIf

	DISCONNECT SMTP SERVER RESULT lFim

Return Nil
