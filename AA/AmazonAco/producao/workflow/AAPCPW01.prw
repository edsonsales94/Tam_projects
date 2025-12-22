#Include 'Protheus.ch'
#include 'TBICONN.ch'

User Function AAPCPW01(_Op,_nQtd)

	Local _cMailTo :=  ""
	Local _cOp := ''
        
    Default _Op := ''
    Default _nQtd := 0
    
	If type("cAcesso") = "U"
		Prepare Environment Empresa "01" Filial "01" Tables "SC2"
	else
		_cOP := iIf( Empty(_Op), SC2->(C2_NUM + C2_ITEM + C2_SEQUEN),_Op)
		_cMailTo := SuperGetMv("MV_MAILEXP",.F.,"francisco@amazonaco.com.br")
	EndIf       
    
	EnvEmail("OP ENCERRADA", _cMailTo, AAHTML(_cOp,_nQtd) )
//	alert('Concluido')
Return

Static Function AAHTML(_cOp,_nQtd)
	Local _cHtml := ""
	Local _cTbl  := ""
	
    Default _nQtd := 0
    
	_cTbl := GetTable(_cOp)

	_cHtml += ' <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"> '
	_cHtml += ' <html>

	_cHtml += AAStyle()

	_cHtml += ' <head>

	_cHtml += ' <meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">
	_cHtml += ' <title>Op Encerradas</title>


	_cHtml += ' </head>
	_cHtml += ' <body>

	_cHtml += ' Produto : ' + (_cTbl)->TB_PRODUTO + ' <br>
	_cHtml += ' Descricao: ' + (_cTbl)->TB_DESC + ' <br>

	_cHtml += ' O.P: ' + (_cTbl)->TB_OP + '  <br>
	_cHtml += ' Qtd. Produzido: ' + Transform( If(_nQtd = 0,(_cTbl)->TB_PRODUZIDO,_nQtd) ,"@E 999,999,999.99") + ' <br>

	_cHtml += ' <br>

	_cHtml += ' <!-- <table style="text-align: left; width: 100%;" border="1" cellpadding="2" cellspacing="2"> -->
	_cHtml += ' <table border="1">
	_cHtml += ' <caption> Lista dos Pedidos de Venda em Aberto para este Produto </caption>
	_cHtml += '   <thead>
	_cHtml += GetLineTbl("head",{'Filial','Pedido','Cliente / Loja','Nome','Qtd. Faturar','Dt. Emissao'})
	_cHtml += '   </thead>
	_cHtml += '     <tbody>

	While !(_cTbl)->(Eof())
		_cHtml += GetLineTbl("body",{(_cTbl)->TB_FILIAL,(_cTbl)->TB_PEDIDO,(_cTbl)->TB_CLIENTE,(_cTbl)->TB_NOME,Transform( (_cTbl)->TB_FATURA,"@E 999,999,999.99"), DTOC((_cTbl)->TB_EMISSAO) })
		(_cTbl)->(dbSkip())
	EndDo

	_cHtml += '     </tbody>
	_cHtml += '   </table>
	_cHtml += '   <br>
	_cHtml += '   </body></html>

Return _cHtml

Static Function GetLineTbl(_cClass,_aDado)
	Local _cTable := ''

	_cTable += ' <tr> '
	_cTable += '   <td style="vertical-align: top;" class="' + _cClass + '">'+ _aDado[01] +' </td>'
	_cTable += '   <td style="vertical-align: top; width: 094px;" class="' + _cClass + '">'+ _aDado[02] +' </td> '
	_cTable += '   <td style="vertical-align: top; width: 114px;" class="' + _cClass + '">'+ _aDado[03] +'</td> '
	_cTable += '   <td style="vertical-align: top; width: 379px;" class="' + _cClass + '">'+ _aDado[04] +'</td> '
	_cTable += '   <td style="vertical-align: top; width: 194px;" class="' + _cClass + '">'+ _aDado[05] +'</td> '
	_cTable += '   <td style="vertical-align: top; width: 125px;" class="' + _cClass + '">'+ _aDado[06] +'</td> '
	_cTable += ' </tr> '

Return  _cTable

Static Function AAStyle()
	Local _cStyle := ''

	_cStyle += "<style type='text/css'>
	_cStyle += "         body {
	_cStyle += " 				text-align: left;
		_cStyle += " 				font-size: 1.2em;
		_cStyle += " 				font-weight: bold;
		_cStyle += " 				color: #00008B;
		_cStyle += " 				background: transparent;}

	_cStyle += " 				font {
	_cStyle += " 				     ext-align: left;
		_cStyle += " 				  color: #555;
		_cStyle += " 				  background: transparent;		}

	_cStyle += "        table {
	_cStyle += " 			    border-collapse: collapse;
		_cStyle += " 				border: 2px solid 	#EE0000;
		_cStyle += " 				font: normal 80%/140% arial, helvetica, sans-serif;
		_cStyle += " 				color: #555;
		_cStyle += " 				background: #fff;}

	_cStyle += " 			  td, th {
	_cStyle += " 				border: 1px dotted #FF8C69;
		_cStyle += " 				padding: .6em;}
	_cStyle += " 			  tr {
	_cStyle += " 				border: 1px solid #FF8C69;
		_cStyle += " 				padding: .6em;}

	_cStyle += " 		      caption {padding: 0 0 .5em 0;
		_cStyle += " 				text-align: left;
		_cStyle += " 				font-size: 1.2em;
		_cStyle += " 				font-weight: bold;
		_cStyle += " 				text-transform: uppercase;
		_cStyle += " 				color: #00008B;
		_cStyle += " 				background: transparent;}

	_cStyle += "    thead th,thead td {border: 2px solid #EE0000;
		_cStyle += " 				text-align: left;
		_cStyle += " 				font-size: 1.0em;
		_cStyle += " 				font-weight: bold;
		_cStyle += " 				color: #00688B;
		_cStyle += " 				background: transparent;}

	_cStyle += " 	tfoot td {border: 2px solid #EE0000;}

	_cStyle += "    tbody th, tbody td, tbody td {
	_cStyle += " 			    border: 1px dotted #EE0000;
		_cStyle += " 			    vertical-align: top;
		_cStyle += " 				text-align: left;}

	_cStyle += " 			  tbody th {white-space: nowrap; }

	_cStyle += " </style>

Return _cStyle

Static Function GetTable(_cOp)
	Local _cTbl := GetNextAlias()
	Local _cQry := ""

	_cQry += " Select C2_NUM+C2_ITEM+C2_SEQUEN TB_OP,B1_ESPECIF TB_DESC, C2_PRODUTO TB_PRODUTO,A1_NOME TB_NOME,
	_cQry += "      C9_FILIAL TB_FILIAL, C9_PEDIDO TB_PEDIDO, C9_CLIENTE +'/' + C9_LOJA TB_CLIENTE, C9_QTDLIB TB_FATURA,
	_cQry += "      C5_EMISSAO TB_EMISSAO,C2_QUANT TB_PRODUZIDO
	_cQry += " from " + RetSqlName('SC2') + " C2
	_cQry += " Left Outer Join " + RetSqlName('SC9') + " C9 on C9.D_E_L_E_T_ = '' And C9_NFISCAL = '' And C9_PRODUTO = C2_PRODUTO " //AND C9_PEDIDO = C2_XPEDIDO
	_cQry += " Left Outer Join " + RetSqlName('SC5') + " C5 on C5.D_E_L_E_T_ = '' And C5_NUM = C9_PEDIDO And C5_FILIAL = C9_FILIAL " //AND C2_XPEDIDO = C5_NUM
	_cQry += " Left Outer Join " + RetSqlName('SA1') + " A1 ON A1.D_E_L_E_T_ = '' And A1_COD = C9_CLIENTE And A1_LOJA = C9_LOJA
	_cQry += " Left Outer Join " + RetSqlName('SB1') + " B1 on B1.D_E_L_E_T_ = '' And B1_COD = C2_PRODUTO
	_cQry += " Where C2.D_E_L_E_T_ = ''
	_cQry += " and C2_NUM+C2_ITEM+C2_SEQUEN = '" + _cOp + "'
	_cQry += " And C2_FILIAL = '" + xFilial('SC2') + "'
	_cQry += " Order by TB_FILIAL,TB_PEDIDO

	dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),_cTbl,.T.,.T.)
	tcSetField(_cTbl,"TB_EMISSAO","D",8,0)
Return _cTbl

Static Function EnvEmail(cTitulo, cEmail, cMsg)
    
    Local nPos      := At(':',GetMv("MV_RELSERV"))
	Local cAccount := GetMv("MV_EMCONTA") // protheus@amazonaco.com.br //
	Local cServer  := GetMv("MV_RELSERV") // SMTP.AMAZONACO.COM.BR
	Local cPass    := GetMv("MV_EMSENHA") // protheus

/*	Local oMail    := tMailManager():New()
	Local nRet     := 0
    
    if nPos > 0		   
	   nPorta  := Val(SubStr(cServer,nPos + 1,Len(cServer)))
	   cServer := SubStr(cServer,1,nPos - 1)  
	EndIf
	
	oMessage := tMailMessage():new()
    oMessage:clear()
    oMessage:cFrom    := cAccount
    oMessage:cTo      := cEmail
    oMessage:cCC      := ""
    oMessage:cBCC     := ""
    oMessage:cSubject := cTitulo
    oMessage:cBody    := cMsg

    oMail:SetUseTLS(.T.)
       
	oMail:Init("", cServer, cAccount, cPass, ,nPorta)
	nret := oMail:SetSMTPTimeout(120) //1 min
   	
	nret := oMail:SMTPConnect()
	
	If nRet != 0
		conout(oMail:GetErrorString(nret))
		return 
	Endif
	
	If GetMv("MV_RELAUTH") 
	   nRet := oMail:SMTPAuth( SubStr(cAccount,1,at("@",cAccount) - 1 ) , cPass)
	   If nRet != 0
		  conout(oMail:GetErrorString(nRet))
		  return 
	   Endif
    EndIf 	
	
    nRet := oMessage:Send( oMail )
    If nRet != 0		
		conout( oMail:GetErrorString(nret) )
		Return .F.
	EndIf

	nRet := oMail:SmtpDisconnect()
	If nRet != 0
		conout(oMail:GetErrorString(nret))
		return 
	Endif
  */ //WERMESON 

	
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