#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"  
#Include "AP5MAIL.CH"

User Function MT120F()
  Local lRet 	  := .T.
  Local cTitulo  := "Pedidos de compras com aprovação pendênte"  
  Local cMsg     := ""
  Local cAprov   := ""
  Local cSeekSC7 := ParamIXB
  Local cPedido  := SubStr(cSeekSC7,Len(SC7->C7_FILIAL)+1,Len(SC7->C7_NUM))

  Private aAuxItens := {}
  Private cEmail    := "" 
   
  If !(INCLUI .Or. ALTERA)
     Return lRet
  Endif

  SC7->(DbSetOrder(1))
  SC7->(DbSeek(cSeekSC7,.T.))

  RetEmail(@cEmail,@cAprov,cPedido)
  
  While !SC7->(EOF()) .AND. SC7->(C7_FILIAL+C7_NUM) == cSeekSC7
    
    aAdd(aAuxItens, {SC7->C7_ITEM            ,; 
                  	 SC7->C7_PRODUTO         ,; 
                  	 SC7->C7_DESCRI          ,;                                           	 
                  	 STR(SC7->C7_QUANT)      ,;
                  	 STR(SC7->C7_PRECO)      ,;                  	                   	 
                  	 STR(SC7->C7_TOTAL)      })
    SC7->(dbSkip())
  Enddo
  
  If Empty(aAuxItens)
     Return lRet
  Endif
  
  // E-mail para os aprovadores  
  cMsg := ' <html> '
  cMsg += '   <head> '
  cMsg += '     <title>'+cTitulo+'</title> '                                                                                  
  cMsg += '   </head>'
  cMsg += '   <body > '
  cMsg += '     <br>O pedido de compras ' + Alltrim(cPedido) +  ' está pendente de liberação para o aprovador: '+ cAprov + '. <br><br> '
  cMsg += '     <br>Detalhes do Pedido: '
  cMsg += '     <br><br>
  cMsg += '      <table border="2" width="100%" id="table3"> '
  cMsg +=          MontaTab("<b>Item</b>"   ,;
                            "<b>Código</b>"        ,;
                            "<b>Produto</b>"     ,;
                            "<b>Quantidade</b>"      ,;
                            "<b>Preço</b>"      ,;                            
                            "<b>Total</b>"      ,1)
       
  For i:= 1 to len(aAuxItens) 
    cMsg    +=  MontaTab(aAuxItens[i][01],;
                         aAuxItens[i][02],;
                         aAuxItens[i][03],;
				         aAuxItens[i][04],;
				         aAuxItens[i][05],;
                         aAuxItens[i][06],2)                         
  Next i                 
  cMsg += '     </table> 
  cMsg += '     <br>     
  cMsg += '   </body>'
  cMsg += ' </html>'
  
  EnvEmail(cTitulo,cEmail,cMsg)
  
Return lRet 

*****************************************************************************************************************
Static Function RetEmail(cEmail,cAprov,cPedido)
  Local cSeekSCR := SCR->(xFilial("SCR")) + "PC" + PADR(SC7->C7_NUM,Len(SCR->CR_NUM))

  SCR->(DbSetOrder(1))
  SCR->(DbSeek(cSeekSCR,.T.))
  While !SCR->(Eof()) .And. SCR->(CR_FILIAL+CR_TIPO+CR_NUM) == cSeekSCR
     If SCR->CR_STATUS == "02"
        SAL->(DbSetOrder(3))
        SAL->(DbSeek(xFilial("SAL") + Alltrim(SC7->C7_APROV) + Alltrim(SCR->CR_APROV)))

        cAprov += " " //Alltrim(SAL->AL_NOME) + " "
        cEmail += Alltrim(UsrRetMail(SCR->CR_USER))+";"
     EndIf
     SCR->(DbSkip())
  Enddo

  cEmail += Alltrim(UsrRetMail(SC7->C7_USER))                                                                                         

Return

*****************************************************************************************************************
Static Function MontaTab(cText01,cText02,cText03,cText04,cText05,cText06,nTipo)
  Local cHTML := ""
 
  cHTML += '<tr>'
  cHTML += ' 			<td width="10%" align="' +Iif(nTipo == 2,"Left"  ,"Center")+'"><font size=2pt>'+cText01+'</font></td>  
  cHTML += ' 			<td width="20%" align="' +Iif(nTipo == 2,"Left"  ,"Center")+'"><font size=2pt>'+cText02+'</font></td>
  cHTML += ' 			<td width="40%" align="' +Iif(nTipo == 2,"Left"  ,"Center")+'"><font size=2pt>'+cText03+'</font></td>   
  cHTML += ' 			<td width="10%" align="' +Iif(nTipo == 2,"Center","Center")+'"><font size=2pt>'+cText04+'</font></td>
  cHTML += ' 			<td width="10%" align="' +Iif(nTipo == 2,"Center","Center")+'"><font size=2pt>'+cText05+'</font></td>  
  cHTML += ' 			<td width="10%" align="' +Iif(nTipo == 2,"Center","Center")+'"><font size=2pt>'+cText06+'</font></td>
  cHTML += '</tr>'
Return cHTML

*****************************************************************************************************************
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
      lRet:= Mailauth("anbandei",alltrim(cPass))
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
