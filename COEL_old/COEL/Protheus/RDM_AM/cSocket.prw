#INCLUDE "PROTHEUS.CH"
#include "totvs.ch"
#include "rwmake.ch"

#DEFINE MSECONDS_WAIT 5000

Static __cCRLF	:= CRLF

/*/
	Funcao: tSocketCSample
	Autor:	Marinaldo de Jesus
	Data:	23/10/2011
	Uso:	Exemplo de Uso da Classe tSocketClient
	Para maiores referencias aos Protocolos HTTP consulte: http://www.w3.org/
/*/
User Function cSocketTst()

	Local nVarNameL			:= SetVarNameLen( 20 )

	Local atSocketC			:= {}

    Local lGetError			:= .F.

	Local ctSocketSend
	Local ctSocketReceive

	Local ntSocketReset
	Local ntSocketConnected
	
	Local ntSocketSend
	Local ntSocketReceive

	//Instanciamos um objeto do tipo Socket Client
	Local otSocketC	:= tSocketClient():New()

	Local oVarInfo
	
	//Obtemos os Metodos da Classe
	atSocketC	:= ClassMethArray( otSocketC )
	lGetError	:= ( aScan( atSocketC , { |aMeth| aMeth[1] == "GETERROR" } ) > 0 )
	oVarInfo	:= tVarInfo():New( atSocketC , "tSocketClient::Methods" )

	//Apresentamos, usando tVarInfo, tSocketClient no Browser
	oVarInfo:Save( .T. , .T. )
	oVarInfo:Show()

	BEGIN SEQUENCE

		//Tentamos efetuar a Conexao a live.sysinternals.com aguardando n milisegundos
		ntSocketConnected	:= otSocketC:Connect( 80 , "live.sysinternals.com" , MSECONDS_WAIT )
	    //Verificamos se a conexao foi efetuada com sucesso
		IF !( otSocketC:IsConnected() ) //ntSocketConnected == 0 OK
			IF ( lGetError )
				ConOut( otSocketC:GetError() ) 
			EndIF	
			ConOut( "" , "tSocketClient" , "" , "Sem Resposta a requisicao" , "" )
			BREAK
		EndIF

	    //Elaboramos a Mensagem a ser enviada
	    ctSocketSend := "GET"
	    ctSocketSend += " "
	    ctSocketSend += "http://live.sysinternals.com"
	    ctSocketSend += __cCRLF
		ctSocketSend += "HTTP/1.0"
		ctSocketSend += __cCRLF
		ctSocketSend += "From:"
		ctSocketSend += " "
		ctSocketSend += "tsocketclient@sample.com"
		ctSocketSend += __cCRLF
		ctSocketSend += "User-Agent: tSocketClient/1.0"
		ctSocketSend += __cCRLF
		ctSocketSend += __cCRLF

		//Enviamos uma Mensagem
		ntSocketSend := otSocketC:Send( ctSocketSend )
		//Se a mensagem foi totalmente enviada
		IF ( ntSocketSend == Len( ctSocketSend ) )
			//Tentamos Obter a Resposta aguardando por n milisegundos
			ntSocketReceive := otSocketC:Receive( @ctSocketReceive , MSECONDS_WAIT )
			//Se Obtive alguma Resposta
			IF ( ntSocketReceive > 0 )
				//Direcionamo-a para o Console do Server
				ConOut( "" , ctSocketReceive , "" )
				//Usamos tVarInfo para apresentar o conteudo no Browser
				oVarInfo:Reset( ctSocketReceive , "HTTP_tSocketMsg" , .T. , .F. )
				oVarInfo:Save( .T. , .T. )
				oVarInfo:Show()
			Else
				IF ( lGetError )
					ConOut( otSocketC:GetError() ) 
				EndIF	
				ConOut( "" , "tSocketClient" , "" , "Sem Resposta a requisicao" , "" )
			EndIF
		Else
			IF ( lGetError )
				ConOut( otSocketC:GetError() ) 
			EndIF	
			ConOut( "" , "tSocketClient" , "" , "Problemas no Enviamos da Mensagem" , "" )
		EndIF
	
		//Verificamos se ainda esta Conectado
		IF !( otSocketC:IsConnected() )
			//Tentamos Nova Conexao
			ntSocketReset 		:= otSocketC:ReSet() //ntSocketReset == 0 OK
			ntSocketConnected	:= otSocketC:Connect( 80 , "live.sysinternals.com" , MSECONDS_WAIT )		
		EndIF
		//Se permanecemos conectado ou reconectou
		IF !( otSocketC:IsConnected() ) //ntSocketConnected == 0 OK
			IF ( lGetError )
				ConOut( otSocketC:GetError() ) 
			EndIF	
			ConOut( "" , "tSocketClient" , "" , "Sem Resposta a requisicao" , "" )
			BREAK
		EndIF
	
	   	//Elaboramos a nova Mensagem a ser enviada
	    ctSocketSend := "GET"
	    ctSocketSend += " "
	    ctSocketSend += "http://live.sysinternals.com/About_This_Site.txt"
	    ctSocketSend += __cCRLF
		ctSocketSend += "HTTP/1.0"
		ctSocketSend += __cCRLF
		ctSocketSend += "From:"
		ctSocketSend += " "
		ctSocketSend += "tsocketclient@sample.com"
		ctSocketSend += __cCRLF
		ctSocketSend += "User-Agent: tSocketClient/1.0"
		ctSocketSend += __cCRLF
		ctSocketSend += __cCRLF

		//Enviamos a nova Mensagem
		ntSocketSend := otSocketC:Send( ctSocketSend )
		//Se a mensagem foi totalmente enviada
		IF ( ntSocketSend == Len( ctSocketSend ) )
			//Tentamos Obter a Resposta aguardando por n milisegundos
			ntSocketReceive := otSocketC:Receive( @ctSocketReceive , MSECONDS_WAIT )
			//Se Obtive alguma Resposta
			IF ( ntSocketReceive > 0 )
				//Direcionamo-a para o Console do Server
				ConOut( "" , ctSocketReceive , "" )
				//Usamos tVarInfo para apresentar o conteudo no Browser
				oVarInfo:Reset( ctSocketReceive , "HTTP_tSocketMsg" , .T. , .F. )
				oVarInfo:Save( .T. , .T. )
				oVarInfo:Show()
			Else
				IF ( lGetError )
					ConOut( otSocketC:GetError() ) 
				EndIF	
				ConOut( "" , "tSocketClient" , "" , "Sem Resposta a requisicao" , "" )
			EndIF
		Else
			IF ( lGetError )
				ConOut( otSocketC:GetError() ) 
			EndIF	
			ConOut( "" , "tSocketClient" , "" , "Problemas no Enviamos da Mensagem" , "" )
		EndIF

	END SEQUENCE

	//Encerramos tVarInfo
	oVarInfo:Close( .T. , .F. )
	oVarInfo 	:= NIL

	//Encerramos a Conexao
	otSocketC:CloseConnection()
	otSocketC	:= NIL

	SetVarNameLen( nVarNameL )

Return( KillApp( .T. ) )