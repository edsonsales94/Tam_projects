#include "Protheus.ch"
#include "AP5MAIL.ch" 
#include "tbiconn.ch"
/*__________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+----------------------+-------------+---------------+¦
¦¦¦ Programa  ¦AAFINW01 | Autor ¦ ADRIANO LIMA | Data | 31/05/12    ¦
¦¦+-----------+----------------------+-------------+---------------+¦
¦¦¦ Descrição:| Envia email ao Financeiro de caso de devolução      ¦
¦¦¦             com bordero. 									              ¦
¦¦+------------+----------------------+-------------+---------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAFINW01(cNotaDev,cNotaOri, cwNomeCli, cwValor )
Local cHtml       := ""
Local cAccount    := ""
Local cServer     := ""
Local cPass       := ""
Local cAssunto    := "FINANCEIRO - " + cwNomeCli
Local nSaldo      := 0 
Local cCliLj      := ""
Local nSalPto     := 0
Local nYPTOTAL    := 0
Local cEmail      := Alltrim(GetMv('MV_XMAILFI'))
Local aArea  := GetArea()
Private cCliema   := ""             

cHtml += Xcabec(cNotaDev,cNotaOri, cwNomeCli, cwValor )

cAccount := GetMv('MV_RELACNT')// Conta de Envio de Relatorios por e-mail do acr//
cServer  := GetMv('MV_RELSERV')// IP do Servidor de e-mails //'smtp.microsiga.com.br'//
cPass    := GetMv('MV_RELPSW') // Senha da Conta de e-mail

LjMsgRun('* Conectando com o servidor SMTP: ' + cServer)
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass RESULT lResult

If lResult
	ljMsgRun('Enviando email para o Financeiro'+Chr(13)+StrTran(cEmail,',',Chr(13)),'Aguarde...')	//ljMsgRun('Enviando email para o Financeiro'+Chr(13)+StrTran(cEmail,',',Chr(13)),'Aguarde...')
	SEND MAIL FROM cAccount  TO cEmail SUBJECT cAssunto BODY cHtml
	DISCONNECT SMTP SERVER
ELSE
	GET MAIL ERROR CERROR
EndIf  

RestArea(aArea)

Return .T.



Static Function Xcabec(cNotaDev,cNotaOri, cwNomeCli, cwValor)

Local cHtml       := ""
Local cNomeCli    := ""
Local cLimitad    := CHR(13) + CHR(10)

cHtml :=  '<table style="width:680px; font-family:Verdana, Arial, Helvetica, sans-serif; color:#343434; font-size:13px; text-align:justify;"  width="100%" border="0" cellspacing="6" cellpadding="6">'
cHtml +=  '  <tr >'
cHtml +=  '    	<td width="407"  valign="middle">'
cHtml +=  '   Senhores(as), <u> </u></td>'
cHtml +=  '</td>'
cHtml +=  '</tr>'
cHtml +=  '<tr>'
cHtml +=  '<td colspan="2" height="30">&nbsp;'
cHtml +=  '</td>'
cHtml +=  '</tr>'
cHtml +=  '<tr>'
cHtml +=  '<td colspan="2">'
cHtml +=  '<p> Foi gerada uma nota fiscal de devolução ('+cNotaDev+') , sendo que a mesma encontra-se em bordero. <br />'      
cHtml +=  '<p> Nota Fiscal Original ('+cNotaOri+'). <br />'                                                                    
cHtml +=  '<p> Cliente: '+cwNomeCli+' <br />'      
cHtml +=  '<p> Valor: '+Transform(cwValor, "@E 9,999,999,999.99" )+' <br />'      
cHtml +=  '</td>'
cHtml +=  '</tr>'

cHtml +=  '<br/>'

cHtml +=  '<table cellpadding="2" style="font-family:Verdana, Arial, Helvetica, sans-serif; color:#343434; font-size:12px; text-align:justify;" width="100%">'

Return cHtml