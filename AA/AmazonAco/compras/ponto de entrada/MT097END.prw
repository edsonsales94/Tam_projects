#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"  
#Include "AP5MAIL.CH"
 /*
ParamIXB = {cDocto,cTipo,nOpc} onde :
cDocto == Numero do Documento
cTipo == Tipo do Documento "PC" "AE" "CP"
Quando o ponto é acionado pela rotina de Liberação e Superior:
nOpc == 1 --> Cancela
nOpc == 2 --> Libera
nOpc == 3 --> Bloqueia

Quando o ponto é acionado pela rotina de Transf. Superior
nOpc == 1 --> Transfere
nOpc == 2 --> Cancela
Obs.: Para esta rotina, caso não exista o superior cadastrado, a variável será
enviada como Nil. Deve ser tratado no ponto de entrada.
*/


User Function MT097END()
	Local lRet      := .T.  
	Local lContinua := .F.    
	Local cDocto    := PARAMIXB[1] 
	Local cTipoDoc  := PARAMIXB[2]
	Local nOpcao    := PARAMIXB[3] 
	
	SC7->(DbSetOrder(1))
  	SC7->(DbSeek(xFilial("SC7") + Alltrim(cDocto))) 
	SAL->(DbSetOrder(1))
  	SAL->(DbSeek(xFilial("SAL") + Alltrim(SC7->C7_APROV)))	
	SCR->(DBCloseArea())
		
	IF Alltrim(STR(nOpcao)) == "2" //libera
	    SCR->(DbSetOrder(2))     
  		SCR->(DbSeek(xFilial("SCR")+"PC"+ALLTRIM(cDocto)))    		
		While Alltrim(SCR->CR_NUM) == Alltrim(cDocto)
  			If Alltrim(SCR->CR_STATUS) == "02"
		    	lContinua := .T.		    	
		    EndIf 		  
		    SCR->(DbSkip())   
    	End
  		
  		If lContinua
  			U_AACOME02()
  		Else
  			U_LibEmail(ALLTRIM(cDocto))	
  		EndIf  					
	ENDIF
    
Return lRet

*****************************************************************************************************************

//retorna o email avisando que o pedido ja está liberado.
User Function LibEmail(cDocto)
  Local lRet 	  := .T.
  Local cTitulo	  := "Pedido de compras liberado"  
  Local cMsg      := ""
  Private cEmail    := "" 
         
  SC7->(DbSetOrder(1))
  SC7->(DbSeek(xFilial("SC7") + Alltrim(cDocto))) 
   
  cEmail := Alltrim(UsrRetMail(SC7->C7_USER))   

  cMsg := ' <html> '
  cMsg += '   <head> '
  cMsg += '     <title>'+cTitulo+'</title> '                                                                                  
  cMsg += '   </head>'
  cMsg += '   <body > '
  cMsg += '     <br>O pedido de compras ' + Alltrim(cDocto) +  ' já foi liberado pelos aprovadores  <br><br> '
  cMsg += '     <br>     
  cMsg += '   </body>'
  cMsg += ' </html>'
  
  EnvEmail(cTitulo,cEmail,cMsg)  

Return lRet 


Static Function EnvEmail(cTitulo, cEmail, cMsg)

  Local cAccount := GetMv("MV_EMCONTA") // protheus@amazonaco.com.br //
  Local cServer  := GetMv("MV_RELSERV") // SMTP.AMAZONACO.COM.BR
  Local cPass    := GetMv("MV_EMSENHA") // protheus 
 
  /*
  Local cAccount  := "jean.vicente@totvs.com.br"
  Local cServer   := "smtp.amazonaco.com.br"
  Local cPass     := "flamengo2011" 
  */
  
  CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass RESULT lResult 
  
  If lResult
    If GetMv("MV_RELAUTH") //lRelauth
      lRet:= Mailauth("",alltrim(cPass))
    Else
      lRet:= .T.
    Endif
    If lRet
      cSubject:= cTitulo
      SEND MAIL FROM cAccount   ;
                TO cEmail;
                SUBJECT cSubject ;
                BODY cMsg
       DISCONNECT SMTP SERVER
    EndIf  
  EndIf


Return
