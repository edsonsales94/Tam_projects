#include "Protheus.ch"
#include "Ap5mail.ch"
#include "TBICONN.ch"

User Function AAFATW01()
  Prepare environment Empresa '01' Filial '01' Tables 'SZE'
  
  aEmails := _GetHtml()
  For nI := 1 to Len(aEmails)
    SendMail("Notas Pendentes Email " + Alltrim(Str(nI))+ " de " + alltrim(Str(Len(aEmails))),GetMv("MV_XMAILR1")+";"+GetMv("MV_XMAILR2"),aEmails[nI])
  Next
  
Return Nil

Static Function SendMail(cTitulo,cEmail,cMsg)
//Static Function EnvEmail(cTitulo, cEmail, cMsg)

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
      lRet:= Mailauth("usuario",alltrim(cPass))
    Else
      lRet:= .T.
    Endif
    If lRet
      cSubject:= cTitulo
      SEND MAIL FROM cAccount   ;
                TO cEmail;
                SUBJECT cSubject ;
                BODY Alltrim(cMsg)
       DISCONNECT SMTP SERVER
    EndIf  
  EndIf


Return

Return _lSend

Static Function _GetTable()

  Local _cHtm := ""
  Local _cTab := ""
  Local _aHtml:= {}
 
  Private aLeg  :=  { {"P"  , "Pré-Romaneio"},;
                      {"R"  , "Romaneio"    },;
                      {"B"  , "Vem Buscar"    },;
                      {"E"  , "Entregue"},;
                      {"V"  , "Nova Entrega"  },;
                      {"N"  , "Endereco não Encontrado"},;
                      {"F"  , "Local Fechado"},;
                      {"D"  , "Devolucao"},;
                      {"S"  , "Venda Estornada"} , ;
                      {" "  , "Aberto" } }
/*
aLegenda := {{"ENABLE"     , "Em aberto"},;
				 {"BR_PINK"    , "Pré-Romaneio"},; 	
				 {"BR_AMARELO" , "Romaneio"    },;
				 {"BR_VERMELHO", "Entregue"    },;
				 {"BR_LARANJA" , "Nova Entrega"},;
				 {"BR_CINZA"   , "Vem Buscar"  },; 	 	
  				 {"BR_AZUL"    , "Endereç   o não encontrado"},;
				 {"BR_PRETO"   , "Venda com Devolução"},; 
				 {"BR_MARROM"  , "Venda Estornada do Romaneio"},;
				 {"BR_BRANCO"  , "Local Fechado"}}
*/
  _cTab := _GetDate()
  While !(_cTab)->(Eof())
     
     _cChave := (_cTab)->ZE_STATUS
     
     _cHtml := ""
     _cHtm  := '<html><body>'                
     
     _cStyle :=' style="border-collapse: collapse; border: 2px solid #EE0000;"
	   If Len(Alltrim(_cChave)) == 0
			_cHtml += Chr(13) + Chr(10) + '<table border = 1 style="border-collapse: collapse;	border: 2px solid 	#EE0000;	font: normal 80%/140% arial, helvetica, sans-serif;	color: #555;	background: #fff;">
			_cHtml += Chr(13) + Chr(10) + '<caption style="padding: 0 0 .5em 0;text-align: left;	font-size: 1.2em;	font-weight: bold;	text-transform: uppercase;	color: #00008B;	background: transparent;" > NOTAS SEM ROMANEIO </caption>
			_cHtml += Chr(13) + Chr(10) + '<thead style="border: 2px solid #EE0000; text-align: left;	font-size: 1.0em;	font-weight: bold;	color: #00688B;	background: transparent;">
			_cHtml += Chr(13) + Chr(10) + " <tr>
			_cHtml += Chr(13) + Chr(10) +    "<th " + _cStyle + " align ='center' class='head'> Nota Fiscal </th>
			_cHtml += Chr(13) + Chr(10) +    "<th " + _cStyle + " align ='center' class='head'> Cliente  </th>
			_cHtml += Chr(13) + Chr(10) +    "<th " + _cStyle + " align ='center' class='head'> Data Venda </th>
			_cHtml += Chr(13) + Chr(10) +    "<th " + _cStyle + " align ='center' class='head'> Valor </th>
			_cHtml += Chr(13) + Chr(10) +    "<th " + _cStyle + " align ='center' class='head'> Peso </th>
			_cHtml += Chr(13) + Chr(10) +  "</tr>
			_cHtml += Chr(13) + Chr(10) + "</thead>
			_cHtml += Chr(13) + Chr(10) + '<tbody style="border: 1px dotted #EE0000; 	vertical-align: top;	text-align: left;">
		Else
			_cHtml += Chr(13) + Chr(10) + '<table border = 1 style="border-collapse: collapse;	border: 2px solid 	#EE0000;	font: normal 80%/140% arial, helvetica, sans-serif;	color: #555;	background: #fff;">
			_cHtml += Chr(13) + Chr(10) + '<caption style="padding: 0 0 .5em 0;text-align: left;	font-size: 1.2em;	font-weight: bold;	text-transform: uppercase;	color: #00008B;	background: transparent;" >' + aLeg[aScan(aLeg,{|x| x[01] == _cChave})][02] + ' </caption> '
			_cHtml += Chr(13) + Chr(10) + '<thead style="border: 2px solid #EE0000; text-align: left;	font-size: 1.0em;	font-weight: bold;	color: #00688B;	background: transparent;">
			_cHtml += Chr(13) + Chr(10) +        "<tr>
			_cHtml += Chr(13) + Chr(10) +  	     "<th " + _cStyle + " align ='center' rowspan=2 class='head'> Romaneio     </th>
			_cHtml += Chr(13) + Chr(10) +   		  "<th " + _cStyle + " align ='center' rowspan=2 class='head'> Motorista    </th>
			_cHtml += Chr(13) + Chr(10) +   		  "<th " + _cStyle + " align ='center' rowspan=2 class='head'> Placa        </th>
//			_cHtml += Chr(13) + Chr(10) +   		  "<th " + _cStyle + " align ='center' rowspan=2 class='head'> Data Saida   </th>
//			_cHtml += Chr(13) + Chr(10) +   		  "<th " + _cStyle + " align ='center' rowspan=2 class='head'> Peso Balanca </th>
			_cHtml += Chr(13) + Chr(10) +   		  "<th " + _cStyle + " align ='center' rowspan=2 class='head'> Peso Nota    </th>
			_cHtml += Chr(13) + Chr(10) +   		  "<th " + _cStyle + " align ='center' rowspan=2 class='head'> Ajudante 1   </th>
			_cHtml += Chr(13) + Chr(10) +   		  "<th " + _cStyle + " align ='center' rowspan=2 class='head'> Ajudante 2   </th>
			_cHtml += Chr(13) + Chr(10) +   		  "<th " + _cStyle + " align ='center' rowspan=2 class='head'> Observacoes  </th>
			
			_cHtml += Chr(13) + Chr(10) +   		  "<th " + _cStyle + " align ='center' colspan=5 class='head'> Notas  </th>
			
			_cHtml += Chr(13) + Chr(10) +   	  "</tr>
			_cHtml += Chr(13) + Chr(10) +   	   "<tr>
			_cHtml += Chr(13) + Chr(10) +   	      "<th " + _cStyle + " align ='center' class='head'> Nota Fiscal </th>
			_cHtml += Chr(13) + Chr(10) +   	      "<th " + _cStyle + " align ='center' class='head'> Cliente  </th>
			_cHtml += Chr(13) + Chr(10) +   			"<th " + _cStyle + " align ='center' class='head'> Data Venda </th>
			_cHtml += Chr(13) + Chr(10) +   			"<th " + _cStyle + " align ='center' class='head'> Status </th>
			_cHtml += Chr(13) + Chr(10) +   			"<th " + _cStyle + " align ='center' class='head'> Valor </th>
			_cHtml += Chr(13) + Chr(10) +   	  "</tr>
			_cHtml += Chr(13) + Chr(10) +    "</thead>
				
			_cHtml += Chr(13) + Chr(10) +    '<tbody style="border: 1px dotted #EE0000; 	vertical-align: top;	text-align: left;">
 	  EndIf

     While _cChave = (_cTab)->ZE_STATUS          
          _cChave2 := (_cTab)->(ZE_STATUS + ZE_ROMAN)
          
          If Len(Alltrim(_cChave)) == 0 

			    While ( _cChave2 = (_cTab)->(ZE_STATUS + ZE_ROMAN)  )
			      
			      _cHtml += Chr(13) + Chr(10) +    "<tr>      
 			      _cHtml += Chr(13) + Chr(10) +      "<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' class='head'> " + (_cTab)->ZE_DOC + "/" + (_cTab)->ZE_SERIE + " </th>		
 			      _cHtml += Chr(13) + Chr(10) +      "<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' class='head'> " + (_cTab)->ZE_NOMCLI +  " </th>		
			      _cHtml += Chr(13) + Chr(10) +      "<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' class='head'> " + DTOC((_cTab)->ZE_DTVENDA) + " </th>	    	 
			      _cHtml += Chr(13) + Chr(10) +      "<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' class='head'> " + Transform((_cTab)->ZE_VALOR,"@E 999,999,999.99")+ " </th>	    	 
			      _cHtml += Chr(13) + Chr(10) +      "<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' class='head'> " + Transform((_cTab)->ZE_PLIQUI,"@E 999,999,999.99")+ " </th>
			      _cHtml += Chr(13) + Chr(10) +    "</tr>	
			      
			      (_cTab)->(dbSkip())
			   EndDo
			   _cHtml += Chr(13) + Chr(10) +  "</tbody>
		    else
		    		       
				 _cHtml += Chr(13) + Chr(10) +   "<tr>        
				 _cHtml += Chr(13) + Chr(10) +  	  "<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' rowspan=_nReply class='head'> " + (_cTab)->ZE_ROMAN   + " </th>
				 _cHtml += Chr(13) + Chr(10) +     "<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' rowspan=_nReply class='head'> " + (_cTab)->ZE_NOMOTOR + " </th>
				 _cHtml += Chr(13) + Chr(10) +     "<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' rowspan=_nReply class='head'> " + (_cTab)->ZE_PLACA   + " </th>
//				 _cHtml += Chr(13) + Chr(10) +     "<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' rowspan=_nReply class='head'> " + DTOC((_cTab)->ZE_DTSAIDA) + " </th>
//				 _cHtml += Chr(13) + Chr(10) +     "<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' rowspan=_nReply class='head'> " + Transform((_cTab)->ZE_PESO,"@E 999,999,999.99")    + " </th>
				 _cHtml += Chr(13) + Chr(10) +     "<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' rowspan=_nReply class='head'> " + Transform((_cTab)->ZE_PNOTAS,"@E 999,999,999.99")  + " </th>
				 _cHtml += Chr(13) + Chr(10) +     "<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' rowspan=_nReply class='head'> " + (_cTab)->ZE_AJUDA01 + " </th>
				 _cHtml += Chr(13) + Chr(10) +     "<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' rowspan=_nReply class='head'> " + (_cTab)->ZE_AJUDA02 + " </th>
				 _cHtml += Chr(13) + Chr(10) +     "<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' rowspan=_nReply class='head'> " + (_cTab)->ZE_OBSERV  + " </th>						  
						  
				 _cHtml += Chr(13) + Chr(10) +     "</tr>	 
				 
				 _nReply := 1
				 While ( _cChave2 = (_cTab)->(ZE_STATUS + ZE_ROMAN)  )
				   _cHtml += Chr(13) + Chr(10) +   	  "<tr>      
 			      _cHtml += Chr(13) + Chr(10) +   	         "<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' class='head'> " + (_cTab)->ZE_DOC + "/" + (_cTab)->ZE_SERIE + " </th>		
 			      _cHtml += Chr(13) + Chr(10) +   	         "<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' class='head'> " + (_cTab)->ZE_NOMCLI +  " </th>		
			      _cHtml += Chr(13) + Chr(10) +   				"<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' class='head'> " + DTOC((_cTab)->ZE_DTVENDA) + " </th>	    	 
			      _cHtml += Chr(13) + Chr(10) +   				"<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' class='head'> " + Transform((_cTab)->ZE_VALOR,"@E 999,999,999.99")+ " </th>	    	 
			      _cHtml += Chr(13) + Chr(10) +   				"<th " + StrTran(_cStyle,'solid','dotted') + " align ='center' class='head'> " + Transform((_cTab)->ZE_PNOTAS,"@E 999,999,999.99")+ " </th>
				   _cHtml += Chr(13) + Chr(10) +   	  "</tr>					   
				   
				   _nReply++
				   (_cTab)->(dbSkip())
			   EndDo
			     _cHtml := StrTran(_cHtml,"_nReply",Alltrim(str(_nReply)) )
			     
			     _cHtml += Chr(13) + Chr(10) +  "</tbody>
			     
          EndIf
        
     EndDo
      _cHtml += Chr(13) + Chr(10) +  '</table>
      
       If Len(_cHtm) + Len(_cHtml) > 300000
         
         aAdd(_aHtml,_cHtm + _cHtml + '</body></html>')
         _cHtm  := '<html><body>' 
         _cHtml := ''
       EndIf
     
  EndDo
  If Len(_cHtm)!= 12
     aAdd(_aHtml,_cHtm + _cHtml + '</body></html>')
  EndIf
Return _aHtml

Static Function _GetHtml()
Local _cHtml := ""
Local _aHtml := _GetTable()
/*
_cHtml := "<html>

_cHtml += Chr(13) + Chr(10) +  "<body>

_cHtml += Chr(13) + Chr(10) + _GetTable()

_cHtml += Chr(13) + Chr(10) +  "</body>
_cHtml += Chr(13) + Chr(10) + "</html>
*/
Return _aHtml


Static Function _GetDate()
Local _cQry := ""
Local _cTab := GetNextAlias()

_cQry += "  Select * ,( Select Sum(ZE_PLIQUI) from " + RetSqlName('SZE') + " A Where D_E_L_E_T_ = '' And A.ZE_ROMAN = ZE.ZE_ROMAN) ZE_PNOTAS from " + RetSqlName('SZE') + " ZE"
_cQry += Chr(13) + Chr(10) + "  Where D_E_L_E_T_ = ''
_cQry += Chr(13) + Chr(10) + "    And ( ZE_ROMAN = '' Or ZE_STATUS = 'P')
_cQry += Chr(13) + Chr(10) + "  Order By ZE_STATUS,ZE_DTSAIDA,ZE_ROMAN,ZE_DOC,ZE_SERIE

dbUseArea(.T.,"TOPCONN",tcGenQry(,,ChangeQUery(_cQry)),_cTab,.T.,.T.)
tcSetField(_cTab,"ZE_DTSAIDA","D",8)
tcSetField(_cTab,"ZE_DTVENDA","D",8)
Return _cTab