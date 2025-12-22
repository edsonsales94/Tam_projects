#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"  
#Include "AP5MAIL.CH"


User Function AACOMMG01()
  Local   cMotivo  := ""
  Private cUsu     := ""
                        
  fEnvMail()

Return 

***********************************************************************************                
Static Function fEnvMail()
  Local cAccount  := ""
  Local cServer   := ""
  Local cPass     := ""
  Local cMsg      := ""
  Local cEmail	  := "" 
  Local cTitulo	  := ""
  Local cMens	  := ""
  Local nQtde     := 0                                  
   
  cTitulo	  := "ICLUSÃO DE PEDIDO DE COMPRAS"
   
  cAccount := GetMv("MV_EMCONTA") // protheus@amazonaco.com.br //
  cServer  := GetMv("MV_RELSERV") // SMTP.AMAZONACO.COM.BR
  cPass    := GetMv("MV_EMSENHA") // protheus 
  
//  SC1->(DbSetOrder(1))
//  SC1->(DbSeek(xFilial("SC1") + SC7->C7_NUM + SC7->C7_ITEM))   
  
  cMsg := ' <html> '
  cMsg += '   <head> '
  cMsg += '     <title>'+cTitulo+'</title> '                                                                                  
  cMsg += '   </head>'
  cMsg += '   <body> '
  cMsg += '     <br>O Pedido de Compras número ' + SC7->C7_NUM + ' acaba de ser incluído no sistema pelo usuário ' + ALLTRIM(SC1->C1_SOLICIT) + ' <br>'
  cMsg += '     <br>Este pedidos foi originado do processo de cotação número ' + SC7->C7_NUMCOT + ' <br>'
  cMsg += '     <br>Aguardando liberação do grupo de aprovação ' + GetMv("MV_PCAPROV")  + ' <br>'
  cMsg += '     <br> '
  cMsg += '     <br>     
  cMsg += '   </body>'
  cMsg += ' </html>'
  
  CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass RESULT lResult
  //- Se a conexao com o SMPT esta ok
  If lResult                                 
	cSubject := cTitulo
    SEND MAIL FROM cAccount;
              TO cEmail  ;
         SUBJECT cSubject;
         BODY cMsg
                
     qout("Email receptor: " + cEmail)

  EndIf
   DISCONNECT SMTP SERVER
Return     
