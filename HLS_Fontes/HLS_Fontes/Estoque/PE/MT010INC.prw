#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*/{protheus.doc}HSCHREFSAL
Envia e-mail na inclusao de um novo produto
@author HONDA LOCK
@since 
/*/



  User Function MT010INC()

  a_Area := GetArea("SB1")

  
  dbSelectArea("SB1")
     dbSetOrder(1)

  RestArea(a_Area)
                     

  If SB1->B1_TIPO = "PA"
	Return (.T.)	
	Endif
  
  a_Area := GetArea("SB1")

                    
  MandaMail()

  RestArea(a_Area)
     

  Return(.T.)
        
//---------------------------------------------------------------------------------------------------------------------------------------------------------------  
  
  Static Function MANDAMAIL()
  
  lConectou       := .F.
  lEnviado        := .F.
  cDe             := ""
  c_Senha         := ""
  cSerMail        := "200.170.82.151"   
  _cAnexo         := ""   
  _xx             := 0
  mCorpo          := "" 
  cAssunto        := "WORKFLOW SOLICITACAO DE IMDS - INCLUSÃO CADASTRO - COD:"+SB1->B1_COD
  cPara           := "l.lamberti@hondalock-sp.com.br"//space(100)
//  cPara			  := //GetMv("MV_PROVCAD")
  cCC             := ""  
 
  cDe := "sistema@hondalock-sp.com.br.com.br"

  c_Senha := "honr2x"
                          
  Do While !lConectou

     CONNECT SMTP SERVER cSerMail ACCOUNT cde PASSWORD c_Senha Result lConectou
     
     _xx += 1
     
     If _xx > 19 // Tenta 10 vezes
        Exit
     Endif

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

     _xx += 1
     
     If _xx > 19
        Exit
     Endif

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
  cHtml += '<p class="style1">Produto: '+Alltrim(SB1->B1_COD)+' - '+Alltrim(SB1->B1_DESCNF)+'</p> '
  cHtml += '<p class="style1">Usu&aacute;rio: '+Substring(cUsuario,7,15)+'</p> '
  cHtml += '<p class="style1">Em: '+dtoc(dDatabase)+' - '+Time()+' </p> '
  cHtml += '<p class="style1">OBS: Este produto esta disponivel para inclusao do cadastro IMDS</p> '
  cHtml += '<p class="style1">&nbsp; </p> '
  cHtml += '<p class="style1">&nbsp;</p> '
  cHtml += '</body> '
  cHtml += '</html> '
                 
  Return(cHtml)
  
//---------------------------------------------------------------------------------------------------------------------------------------------------------------  
