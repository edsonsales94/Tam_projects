#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"  
#Include "AP5MAIL.CH"


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ INGCTP02   ¦ Autor ¦ Jean Vicente         ¦ Data ¦ 01/02/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de envio de e-mail alertando para contratos com        ¦¦¦
¦¦¦ vingência expirando                                                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function INGCTP02()
   Local cFil := ""
	Private aAuxItens 	:= {}

 	Prepare environment empresa "01" filial "01"  tables "CN9"
                        
  	U_PesqContrato() 
  
  	While !YYY->(EOF())                                                             
		
		If ALLTRIM(YYY->CN9_FILIAL) == "01"
			cFil := "Manaus"
		Elseif ALLTRIM(YYY->CN9_FILIAL) == "02"
			cFil := "Brasilia"
		Elseif ALLTRIM(YYY->CN9_FILIAL) == "03"
			cFil := "Recife"
		Elseif ALLTRIM(YYY->CN9_FILIAL) == "04"
			cFil := "Sao Paulo"
		EndIf	
			
		aAdd(aAuxItens, {cFil                     ,; // 01 - filial 
                  	  YYY->CN9_NUMERO          ,; // 02 - numero do contrato
                  	  YYY->CN9_DESCRI          ,; // 03 - descrição    
  							  YYY->CN9_DTINIC          ,; // 04 - data inicial 
                  	  YYY->CN9_DTFIM           ,; // 05 - data final
                       YYY->DIAS_RESTANTE   		}) // 06 - dias restantes                                                                          
    	YYY->(dbSkip())
  	End 
  
  	If Len(aAuxItens) > 0
     	U_SendEmail()
  	EndIf 
  	YYY->(dbCloseArea())
Return  

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦PesqContrato¦ Autor ¦ Jean Vicente         ¦ Data ¦ 01/02/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina para consultar os contratos pendentes para envio de    ¦¦¦
¦¦¦           ¦ alerta.                                                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PesqContrato()
	Local cQry   := ""  
	Local aArea  := getArea()
  
  	dbSelectArea("CN9") 
  	cAlerta := iif( Type("CN9->CN9_XALERT") = "U","40","A.CN9_XALERT")
  
  	cQry := " SELECT A.CN9_FILIAL, A.CN9_NUMERO, A.CN9_DESCRI, A.CN9_DTINIC," + cAlerta + ", A.CN9_DTFIM, DATEDIFF ( DAY , CONVERT(varchar, getdate(),112), A.CN9_DTFIM ) AS DIAS_RESTANTE " 
  	cQry += "   FROM "+RetSqlName("CN9")+" A  "
  	cQry += "  WHERE A.D_E_L_E_T_ <> '*'       "
  	cQry += "    AND A.CN9_SITUAC = '05'        "
  	cQry += "    AND DATEDIFF ( DAY , CONVERT(varchar, getdate(),112), A.CN9_DTFIM ) < " + cAlerta
  	cQry += "    AND DATEDIFF ( DAY , CONVERT(varchar, getdate(),112), A.CN9_DTFIM ) >= 0 "
 	cQry += " ORDER BY DIAS_RESTANTE, A.CN9_NUMERO"
 	
  	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"YYY",.T.,.T.)
	  
  	RestArea(aArea)
Return  

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ SendEmail  ¦ Autor ¦ Jean Vicente         ¦ Data ¦ 01/02/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de configuração e envio de e-mail                      ¦¦¦
¦¦¦           ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function SendEmail()
	Local cAccount  := ""
	Local cServer   := ""
	Local cPass     := ""
	Local cMsg      := ""
	Local cTitulo	:= ""
	Local cMens	   := ""
    Local i 
  	cTitulo	  := "ALERTA DE CONTRATOS COM VIGÊNCIA EXPIRANDO "
   
  	cAccount := GetMv("MV_RELACNT") // "erp@indt.org.br" //   // Conta de Envio de Relatorios por e-mail do acr
  	cServer  := GetMv("MV_RELSERV") // IP do Servidor de e-mails //mns.indt.org
  	cPass    := GetMv("MV_RELPSW")  // Senha da Conta de e-mail //está em branco
  	cEmail   := GetMv("MV_RELDEST") // destinatarios cadstrados //daniel.rejman@indt.org.br, ext-alberto.andrade@nokia.com
  
  
  	cMsg := ' <html> '
  	cMsg += '   <head> '
  	cMsg += '     <title>'+cTitulo+'</title> '                                                                                  
  	cMsg += '   </head>'
  	cMsg += '   <body > '
  	cMsg += '     <br>Contratos Pendentes: '
  	cMsg += '     <br><br>
  	cMsg += '     <table border="2" width="100%" id="table3"> '
  	cMsg +=          MontaTab("<b>Filial</b>"    ,;
                            "<b>Contrato</b>"     ,;
                            "<b>Fornecedor</b>"   ,;
                            "<b>Data Inicial</b>" ,;
                            "<b>Data Final</b>"   ,;
                            "<b>Restante</b>"     ,1)
       
  	For i:= 1 to len(aAuxItens) 
   	cText04 := SubStr(aAuxItens[i][04],7,2)+"/"+SubStr(aAuxItens[i][04],5,2)+"/"+SubStr(aAuxItens[i][04],1,4)
   	cText05 := SubStr(aAuxItens[i][05],7,2)+"/"+SubStr(aAuxItens[i][05],5,2)+"/"+SubStr(aAuxItens[i][05],1,4)
    	cMsg    +=  MontaTab(aAuxItens[i][01],;
                         	aAuxItens[i][02],;
                         	aAuxItens[i][03],;
                         	cText04,;
                         	cText05,;
                         	AllTrim(Str(aAuxItens[i][06])),2)                        
  	Next i                 
  	cMsg += '     </table> 
  	cMsg += '     <br>     
  	cMsg += '   </body>'
  	cMsg += ' </html>'
  
  	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass RESULT lResult
  
  	If lResult // Se a conexao com o SMPT esta ok                                
		cSubject := cTitulo
    	SEND MAIL FROM cAccount;
      			 TO cEmail  ;
         		 SUBJECT cSubject;
         		 BODY cMsg                
     	qout("Email receptor: " + cEmail)     
  	EndIf
   DISCONNECT SMTP SERVER
Return     

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MontaTab   ¦ Autor ¦ Jean Vicente         ¦ Data ¦ 01/02/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de configuração da tabela no corpo do e-mail           ¦¦¦
¦¦¦           ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function MontaTab(cText01,cText02,cText03,cText04,cText05,cText06,nTipo)
  Local cHTML := ""
  
  cHTML += '<tr>'
  cHTML += ' 			<td width="10%" align="' +Iif(nTipo == 2,"Left"  ,"Center")+'"><font size=2pt>'+cText01+'</font></td>  
  cHTML += ' 			<td width="15%" align="' +Iif(nTipo == 2,"Center","Center")+'"><font size=2pt>'+cText02+'</font></td>  
  cHTML += ' 			<td width="45%" align="' +Iif(nTipo == 2,"Left"  ,"Center")+'"><font size=2pt>'+cText03+'</font></td>
  cHTML += ' 			<td width="10%" align="' +Iif(nTipo == 2,"Center","Center")+'"><font size=2pt>'+cText04+'</font></td>   
  cHTML += ' 			<td width="10%" align="' +Iif(nTipo == 2,"Center","Center")+'"><font size=2pt>'+cText05+'</font></td>
  cHTML += ' 			<td width="10%" align="' +Iif(nTipo == 2,"Center","Center")+'"><font size=2pt>'+cText06+'</font></td>  
  cHTML += '</tr>'
Return cHTML

