#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
/*/{protheus.doc}MT160WF
Ponto de entrada na cotacao de compras para envio de workflow
@author Honda Lock
/*/

  User Function MT160WF()
    RecLock("SC8",.F.)
  SC8->C8_USER := Substring(cUsuario,7,15)                         
  MsUnlock() 
  MandaMail()


  Return
        
//---------------------------------------------------------------------------------------------------------------------------------------------------------------  
  
  Static Function MANDAMAIL()
  
  lConectou       := .F.
  lEnviado        := .F.
  cDe             := ""
  c_Senha         := ""
  cSerMail        := GETMV("MV_RELSERV")  
  _cAnexo         := ""   
  
  _xx             := 0
  mCorpo          := "" 
  cAssunto        := "WORKFLOW LIBERAÇAO DE PEDIDO DE COMPRA - LIBERAR PEDIDO - COD:"+SC8->C8_NUMPED
  cPara			  := "V.VENDEMIATTI@HONDALOCK-SP.COM.BR"  //getmv("MV_PROVCAD")
  cCC             := ""  
  cDe := GETMV("MV_RELACNT")
  c_Senha := GETMV("MV_RELAPSW")
                          
  Do While !lConectou

     CONNECT SMTP SERVER cSerMail ACCOUNT cde PASSWORD c_Senha Result lConectou
  Enddo
        
  If ! MailAuth(cDe,c_Senha)
     MsgBox("Conta de e-mail nao autenticada!","Autenticação","ALERT")
     Return
  Endif         

  cLin := MontaHtml()                              

  Do While !lEnviado

     SEND MAIL       FROM       cDe ;
                     TO         cPara ;
                     CC         cCC ;
                     SUBJECT    cAssunto ;
                     BODY       cLin;     
                     ATTACHMENT _cAnexo;
                     RESULT     lEnviado

  Enddo

  DISCONNECT SMTP SERVER

  If lConectou .AND. lEnviado
//     MsgAlert("OK - E-mail enviado com sucesso !")
  Else
     MsgAlert("Erro - E-mail nao enviado ! Contate o Administrador !")

 //    GET MAIL ERROR cError
 //    MsgInfo(cError,OemToAnsi("ERRO"))

  Endif

  Return
           
//---------------------------------------------------------------------------------------------------------------------------------------------------------------  
  
  Static Function MontaHtml()

  cHtml := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
  cHtml += '<html xmlns="http://www.w3.org/1999/xhtml"> '
  cHtml += '<head> '
  cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
  cHtml += '<title>Untitled Document</title> '
  cHtml += '<style type="text/css"> '
  cHtml += '<!-- '
  cHtml += '.style1 { '
  cHtml += '	font-family: Arial, Helvetica, sans-serif;'
  cHtml += '	font-size: 14px;'
  cHtml += '} '
  cHtml += '--> '
  cHtml += '</style> '
  cHtml += '</head> '
  cHtml += '<body> '                                         
  cHtml += '<p class="style1">PEDIDO: '+Alltrim(SC8->C8_NUMPED)+'</p> '
  cHtml += '<p class="style1">Usu&aacute;rio: '+Substring(cUsuario,7,15)+'</p> '
  cHtml += '<p class="style1">Em: '+dtoc(dDatabase)+' - '+Time()+' </p> '
  cHtml += '<p class="style1">OBS: Este pedido encontra-se bloqueado para uso at&eacute; a aprova&ccedil;&atilde;o.</p> '
  cHtml += '<p class="style1">&nbsp; </p> '
  cHtml += '<p class="style1">&nbsp;</p> '
  cHtml += '</body> '
  cHtml += '</html> '
                 
  Return(cHtml)   
  
//---------------------------------------------------------------------------------------------------------------------------------------------------------------  
