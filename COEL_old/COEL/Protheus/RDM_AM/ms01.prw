#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"

#DEFINE ID "Admin"
#DEFINE SENHA "123"

web function ms01()

//A função é executada quando é chamada através do browser.

return h_ms01()

web function ms02()
	//Verifica se é a primeira vez q usuário faz login.
	conout( ID, SENHA )

	if empty( HttpSession->Usuario )
		//Verifica se os campos foram preenchidos.
		if empty( HttpPost->txt_Nome ) .And. empty( HttpPost->txt_Senha)
			return "Nome e Senha não informados!!"       
		endif

		//Verifica usuário e senha.
		if HttpPost->txt_Nome != ID 
			return "Usuário Inválido!!"       
		endif
		if HttpPost->txt_Senha != SENHA
			return "Senha Inválida!!"
		endif
		//Seta o nome do usuario.
		HttpSession->Usuario := HttpPost->txt_Nome
	endif

return h_ms02()

web function ms03() 
	//Verifica se a Sesssion já foi iniciada.
	if empty( HttpSession->Contador )
		HttpSession->Contador := 1
	//caso tenha sido, incrementa o contador.
	else
		HttpSession->Contador++
	endif
return h_ms03()
