#include "Protheus.ch"
#Include "AP5MAIL.CH"
#include 'tbiconn.ch'

User Function MA415END()

	Local cModelo  := "\web\Modelos\orcamentos-incluidos.html"
	Local odEmail := Nil
	
	if Type("cAcesso") == "U"
       Prepare Environment Empresa '01' Filial '01'
       _ndOpc := 01
	   _xdOpc := 01
	   
	   SCJ->(dbSetOrder(1))
	   SCJ->(dbSeek(xFilial('SCJ') + '007159'))
    Else
      _ndOpc := PARAMIXB[01]
	  _xdOpc := PARAMIXB[02]
    EndIf	
	
	aSCJ := SCJ->(getArea())
	aSCK := SCK->(getArea())
	

	if _xdOpc == 01 .And. (_ndOpc == 01) // Inclusao

		cEmail := iIF(SuperGetMv("MV_XUSRORC",.T.),Getmv("MV_XUSRORC"), "" )

		SA3->(dbSetOrder(1))
		SA3->(dbSeek(xFilial('SA3') + SCJ->CJ_VEND1  ))

		If SA3->(FieldPos('A3_XEMAIL')) > 0
			cEmail += IiF(Len(Alltrim(cEmail)) > 0,";"+SA3->A3_XEMAIL,SA3->A3_XEMAIL)
		EndIf

		If SA3->(FieldPos('A3_EMAIL')) > 0
			cEmail += IiF(Len(Alltrim(cEmail)) > 0,";"+SA3->A3_EMAIL,SA3->A3_EMAIL)
		EndIf

		_odEmail:= odEmail():New(cModelo)
		_odEmail:ValByName('numero',SCJ->CJ_NUM)
		_odEmail:ValByName('codigo',SCJ->CJ_VEND1)
		_odEmail:ValByName('nome',Posicione('SA3',1,xFilial('SA3') + SCJ->CJ_VEND1,'A3_NOME' ))

		SCK->(dbSetOrder(1))
		SCK->(dbSeek(xFilial('SCK') + SCJ->CJ_NUM ))
        nItens := 0
        nSoma  := 0
        
		While !SCK->(Eof()) .And. SCK->CK_FILIAL+SCK->CK_NUM == SCK->(xFilial('SCK')) + SCJ->CJ_NUM
            _odEmail:AddRegister({SCK->CK_PRODUTO,SCK->CK_DESCRI, SCK->CK_QTDVEN, SCK->CK_PRCVEN,SCK->CK_VALOR })
            
			/*
			_odEmail:addByname( {"it.Produto","it.Descricao","it.Quantidade","it.Unitario","it.Total"},;
			                     {SCK->CK_PRODUTO,;
			                      SCK->CK_DESCRI,;
			                      Transform(SCK->CK_QTDVEN,"@E 999,999,999.99"),;
			                      Transform(SCK->CK_PRCVEN,"@E 999,999,999.99"),;
			                      Transform(SCK->CK_VALOR,"@E 999,999,999.99") } )
		    */
			                      
			nItens++
			nSoma += SCK->CK_VALOR
			SCK->(dbSkip())
		EndDo
		_odEmail:ValByName('CONTADOR',Transform(nItens,"@E 999,999,999") )
		_odEmail:ValByName('TOTAL', Transform(nSoma,"@E 999,999,999.99") )

		_odEmail:SetTo(cEmail)
		_odEmail:SetAssunto("Novo Orcamento incluido")

		_xdRet := _odEmail:ConectServer()
		If !Empty(_xdRet)
			If !isBlind()
				Aviso('',_xdRet,{'OK'})
			Else
				Conout(_xdRet)
			EndIf
		Endif

		If Empty(_xdRet)
			_xdRet := _odEmail:SendMail()
			If !Empty(_xdRet)
				If !isBlind()
					Aviso('',_xdRet,{'OK'})
				Else
					Conout(_xdRet)
				EndIf
			EndIf
		EndIf

		/*
		//alert(cEmail)
		cMsg := ' <html> '
		cMsg += '   <head> '
		cMsg += '     <title> Inclusao de Orcamento de Venda </title> '                                                                                  
		cMsg += '   </head>'
		cMsg += '   <body > '
		cMsg += '     <br> Orcamento de venda Incluido : ' + SCJ->CJ_NUM  +  ' <br><br> '
		cMsg += '     <br> Vendedor : ' + SCJ->CJ_VEND1 + '-' +  Posicione('SA3',1,xFilial('SA3') + SCJ->CJ_VEND1,'A3_NOME' )  +  ' <br><br> '
		cMsg += '     <br>   ' 
		cMsg += '     <table>'
		cMsg += '      <thead>'
		cMsg += '      <tr>'
		cMsg += '      <th> Produto </th>
		cMsg += '      <th> Descricao </th>
		cMsg += '      <th> Quantidade </th>
		cMsg += '      <th> Unitario </th>
		cMsg += '      <th> Total </th>
		cMsg += '      </tr>'
		cMsg += '      </thead>'     
		cMsg += '     </table>'
		cMsg += '   </body>'
		cMsg += ' </html>'

		EnvEmail("Inclusao de Orcamento de Venda",cEmail,cMsg)  
		*/

	EndIf
Return Nil

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
