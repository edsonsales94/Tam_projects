#include 'totvs.ch'

#define CONTENT  "CONTENT"
#define POSITION "POSITION"

User Function odEmail()
	TakeFile("\web\Modelos\orcamentos-incluidos.html")
Return Nil

CLASS odEmail

	Data _cdFile
	Data _cdHtml
	Data _cdReplace

	Data _cdAssunto
	Data _cdFrom
	Data _cdTo
	Data _cdCC
	Data _cdCCo
	Data oMail
	Data oMensagem

	Data _cdServer
	Data _ndPorta
	Data _cdUser
	Data _cdConta
	Data _cdPass

	Data _ldAuth
	Data _ldSSl
	Data _ldTLS
	Data _ndTimeOut
	Data _ldConect
	Data _nCont

	Data aFilesAttach 

	Data aItensTable
	Data aItensChange 

	METHOD New(xdFile) CONSTRUCTOR
	Method ValByName(_xdTag,xdValor)
	Method addByName(_adTag,_adValor)
	Method AddRegister(_adValor)
	Method getReplace(_adTag)
	Method setFile(_xdFile)

	Method SetHtml()
	Method getHtml()
	Method getFile()
	Method LoadModelo(_cdFile)

	Method setAssunto( xdAssunto )
	MEthod setFrom(_xdFrom)
	MEthod setTo(_xdTo)
	MEthod setCc(_xdCc)
	MEthod setCco(_xdCco)

	Method SetServer(xdServer,_xdPorta)
	Method SetAccount(xdUser,xdConta,xdPass)
	Method SetSSL(_xdSSl)
	Method SetTLS(_xdTls)
	Method SetAuth(_xdAuth)
	Method SetTimeOut(_xdTimeOut)
	METHOD SendMail()
	Method SetBody(xBody)
	Method SetAttach(xFiles)

	Method ConectServer()
	Method DisConectServer()

ENDCLASS

//-----------------------------------------------------------------
METHOD New(_xdFile) CLASS odEmail

	Default _xdFile := ""

	Self:_cdFile    := _xdFile
	Self:_cdReplace := ""
	Self:_cdHtml    := Self:LoadModelo(Self:_cdFile)

	Self:oMail      := TMailManager():New()
	Self:oMensagem  := TMailMessage():New()

	Self:_cdUser    := SuperGetMv("MV_RELAUSR",.F.,"")
	Self:_cdConta   := SuperGetMv("MV_RELACNT" ,.F.,"")
	Self:_cdServer  := SuperGetMv("MV_RELSERV" ,.F.,"")
	Self:_cdPass    := SuperGetMv("MV_RELAPSW" ,.F.,"")
	Self:_ldAuth    := SuperGetMv("MV_RELAUTH" ,.F., .T.)
	Self:_ldSSl     := SuperGetMv("MV_RELSSL" ,.F., .F.)
	Self:_ldTLS     := SuperGetMv("MV_RELTLS" ,.F., .F.)
	Self:_ldConect  := .F.
	Self:_ndPorta   := Val( SubStr(Self:_cdServer,at(":",Self:_cdServer) + 1 ) )
	Self:_cdServer  := SubStr(Self:_cdServer,1,at(":",Self:_cdServer) - 1 )

	Self:_ndPorta      := iIf(Self:_ndPorta == 0,25,Self:_ndPorta)
	Self:_ndTimeOut    := 60
	Self:aFilesAttach := {}
	//Self:aItensChange := {}
	Self:aItensTable := {}

Return Self

Method ConectServer() CLASS odEmail

	Self:oMail:SetUseSSL(Self:_ldSSl)
	Self:oMail:SetUseTLS(Self:_ldTls)

	If nRet := Self:oMail:Init("" , Self:_cdServer,Self:_cdConta,Self:_cdPass,0 ,Self:_ndPorta) != 0
		_xdRet := Self:oMail:GetErrorString(nRet)
	Else
		_xdRet := ""
	EndIF

	//Definindo o TimeOut para 60
	If Empty(_xdRet)
		nRet := Self:oMail:SetSmtpTimeOut( Self:_ndTimeOut )
		If nRet != 0
			_xdRet := "[TIMEOUT][ERROR] -> "  + Self:oMail:GetErrorString(nRet)
		EndIf
	EndIf

	If Empty(_xdRet)
		nRet := Self:oMail:SmtpConnect()
		If nRet != 0
			_xdRet := "[CONECT][ERROR] " + Self:oMail:GetErrorString(nRet)
		EndIf
	Endif

	If Empty(_xdRet) .And. Self:_ldAuth
		nRet := Self:oMail:SMTPAuth(Self:_cdConta, Self:_cdPass)
		If nRet != 0
			_xdRet := "[AUTH] FAIL TRY with ACCOUNT() and PASS()" + Chr(13) + Chr(10)
			_xdRet += "[AUTH][ERROR] " + Self:oMail:GetErrorString(nRet) + Chr(13) + Chr(10)
			_xdRet +=  Chr(13) + Chr(10)
			_xdRet +=  Chr(13) + Chr(10)
			_xdRet += "[AUTH] TRY with USER() and PASS()" + Chr(13) + Chr(10)
			// try with user and pass
			nRet := Self:oMail:SMTPAuth(Self:_cdUser, Self:_cdPass)
			If nRet != 0
				_xdRet += "[AUTH] FAIL TRY with USER() and PASS()"  + Chr(13) + Chr(10)
				_xdRet += "[AUTH][ERROR] " +  Self:oMail:GetErrorString(nRet)
			else
				_xdRet := ""
			Endif

		Endif
	Endif
	IF Empty(_xdRet)
		Self:_ldConect := .T.
	Else
		Self:_ldConect := .F.
	EndIf
Return _xdRet

Method DisConectServer() CLASS odEmail
	Local _xdRet := ""
	If Self:_ldConect
		nRet := Self:oMail:SmtpDisconnect()
		If nRet != 0		
			_xdRet += "[DISCONNECT] Fail smtp disconnecting ... "
			_xdRet += "[DISCONNECT][ERROR] " + oMail:GetErrorString(nRet)
		Else
			Self:_ldConect := .F.
		EndIf
	EndIF
Return _xdRet

Method SendMail() CLASS odEmail
	Local _xdRet := ""
	Local xI
	

	If Empty(_xdRet)
		Self:oMensagem:Clear()
		Self:oMensagem:cFrom    := Self:_cdConta
		Self:oMensagem:cTo      := Self:_cdTo
		Self:oMensagem:cCC      := Self:_cdCC
		//Self:oMensagem:cCo     := Self:_cdCCo

		Self:oMensagem:cSubject:= Self:_cdAssunto
		Self:oMensagem:cBody := Self:getHtml()
		For xI := 01 To Len(Self:aFilesAttach)
		   if File(Self:aFilesAttach[xI])
		      sxx := Self:oMensagem:AttachFile(Self:aFilesAttach[xI])
		      if sxx < 0
			     ConOut('errou')
			  Else
				//adiciona uma tag informando que é um attach e o nome do arq
				xx := StrToKArr(Self:aFilesAttach[xI] , "\")				
				xxx := xx[len(xx)]
    			//Self:oMensagem:AddAtthTag( 'Content-Disposition: attachment; filename='+xxx)
			  Endif
		   EndIf
		Next
		nRet := Self:oMensagem:Send(Self:oMail)
		If nRet != 0
			_xdRet := "[SEND] Fail to send message"  + CHr(13) + CHr(10)
			_xdRet += "[SEND][ERROR] " + Self:oMail:GetErrorString(nRet)
		Else			
			_xdDis := Self:DisConectServer()
			_xdRet := "[SEND] Sucess to send message"
			If !Empty(_xdDis)
				_xdRet += " but " + Chr(13) + Chr(10) + _xdDis
			EndIf
		EndIf

	EndIf
Return _xdRet


Method SetSSL(_xdSSl) CLASS odEmail
	Self:_ldSSl := _xdSSl
Return
Method SetTLS(_xdTls) Class odEmail
	Self:_ldTls := _xdTls
Return 
Method SetAuth(_xdAuth) CLASS odEmail
	Self:_ldAuth := _xdAuth
Return

Method SetServer(xdServer,xdPorta) CLASS odEmail
	Self:_cdServer := xdServer
	Self:_ndPorta  := xdPorta
Return
Method SetAccount(xdUser,xdUser,xdPass) CLASS odEmail
	Self:_cdUSer := xdUSer
	Self:_cdConta := xdConta
	Self:_cdPass  := xdPass
Return

Method SetTimeOut(_xdTimeOut) CLASS odEmail
	Self:_ndTimeOut := _xdTimeOut
Return Nil

Method setAssunto(xdAssunto) CLASS odEmail
	SELF:_cdAssunto := xdAssunto
REturn

MEthod setFrom(_xdFrom) CLASS odEmail
	Self:_cdFrom := _xdFrom
Return

MEthod setTo(_xdTo) CLASS odEmail
	Self:_cdTo := _xdTo
Return

Method setCc(_xdCc) CLASS odEmail
	SELF:_cdCc := _xdCc
REturn

Method SetCco(_xdCco) CLASS odEmail
	Self:_cdCCo := _xdCco
Return

Method SetBody(xdBody) Class odEmail
   Self:_cdHtml := xdBody
Return 

Method SetAttach(xFiles) Class odEmail
    Self:aFilesAttach := {}
    if ValType(xFiles) == "C"
       aAdd(Self:aFilesAttach,xFiles)
	Elseif ValType(xFiles) == "A"
	   Self:aFilesAttach := aClone(xFiles)
	EndIf
Return

Method setFile(_xdFile) CLASS odEmail
	Self:_cdFile := _xdFile
	Self:_cdHtml := Self:LoadModelo(Self:_cdFile)
	Self:_cdReplace := ''
Return

Method getFile() CLASS odEmail
Return Self:_cdFile := _xdFile

Method ValByName(_xdTag,_xdValor) CLASS odEmail
	Self:_cdHtml := StrTran(Self:_cdHtml,"!"+_xdTag+"!",_xdValor)
	Self:_cdHtml := StrTran(Self:_cdHtml,"%"+_xdTag+"%",_xdValor)
Return

Method AddRegister(_adValor) Class odEmail

	Local aLinha := {}
	Local _xdItens := Len(Self:aItensTable)
	Local xPos   := Len(Self:aItensChange)
	Local _xdJ   := 00
	Local nResto

	nResto := _xdItens % xPos + 1
	//If nResto == 0 
	xdTr := Self:aItensChange[nResto][01]
	For _xdJ := 01 To Len(Self:aItensChange[xPos][02])
		xColuna := Self:aItensChange[xPos][02][_xdJ]
		If _xdJ <= Len(_adValor)
			xdTr := StrTran(xdTr,"%"+xColuna+"%", iIF(ValType(_adValor[_xdJ]) == "N", Transform(_adValor[_xdJ],"@E 999,999,999.99"), _adValor[_xdJ] )  )
		Else 
			xdTr := StrTran(xdTr,"%"+xColuna+"%", " " )
		EndIf
	Next
    aAdd(Self:aItensTable,xdTr)
    aPos := GetTagInformation('tbody',Self:_cdHtml,,,POSITION)
    Self:_cdHtml := SubStr(Self:_cdHtml,1,aPos[02] - 9) + xdTr + SubStr(Self:_cdHtml,aPos[02] - 9)
	//aAdd(Self:aItensTable,_adValor)

Return

Method addByName(_adTag,_adValor) CLASS odEmail
    
    Local _xdItens := Len(Self:aItensTable)
	Local xPos := Len(Self:aItensChange)
	
	For _xdJ := 01 To Len(Self:aItensChange[xPos][02])
		xColuna := Self:aItensChange[xPos][02][_xdJ]
		xdPPos := aScan(_adTag,{|x| x == xColuna})
		If xdPPos > 0//_xdJ <= Len(_adValor)
			xdTr := StrTran(xdTr,"%"+xColuna+"%", iIF(ValType(_adValor[xdPPos]) == "N", Transform(_adValor[xdPPos],"@E 999,999,999.99"), _adValor[xdPPos] )  )
		Else 
			xdTr := StrTran(xdTr,"%"+xColuna+"%", " " )
		EndIf
	Next
	
	aAdd(Self:aItensTable,xdTr)
    aPos := GetTagInformation('tbody',Self:_cdHtml,,,POSITION)
    Self:_cdHtml := SubStr(Self:_cdHtml,1,aPos[02] - 9) + xdTr + SubStr(Self:_cdHtml,aPos[02] - 9)
    
	/*
	If Empty(Self:_cdReplace)
		Self:_cdReplace := Self:getReplace(_adTag)
	EndIf
	_cdNewLine := Self:_cdReplace

	For nI := 1 To Len(_adTag)
		_cdNewLine := StrTran(_cdNewLine,"%"+_adTag[nI]+"%", iIF(ValType(_adValor[nI]) == "N", Transform(_adValor[nI],"@E 999,999,999.99"), _adValor[nI] )  )  
		_cdNewLine := StrTran(_cdNewLine,"!"+_adTag[nI]+"!", iIF(ValType(_adValor[nI]) == "N", Transform(_adValor[nI],"@E 999,999,999.99"), _adValor[nI] )  )
	Next
	Self:_cdHtml := StrTRan(Self:_cdHtml,Self:_cdReplace, _cdNewLine + Chr(13) + Chr(10) + Self:_cdReplace)
	*/
Return

Method getReplace(_adTag) CLASS odEmail

	_ndPos := at(_adTag[01], Self:_cdHtml)
	_ndPos2 := at(_adTag[Len(_adTag)], Self:_cdHtml)
	_ldContinua := .T.

	While _ndPos > 01 .And. _ldContinua
		If SubStr(Self:_cdHtml,_ndPos,3) == '<tr' //.Or. SubStr(Self:_cdHtml,_ndPos,3) == '<td'
			_ndRep := _ndPos
			_ldContinua := .F.
		EndIf
		_ndPos--
	EndDo

	_ndMax := Len(Self:_cdHtml)
	_ldContinua := .T.

	While _ndPos < _ndMax .And. _ldContinua
		If SubStr(Self:_cdHtml,_ndPos,5) == '</tr>' //.Or. SubStr(Self:_cdHtml,_ndPos,5) == '</td>'
			_ndRep2 := _ndPos
			_ldContinua := .F.
		EndIf
		_ndPos++
	EndDo

	_cdReplace := SubStr(Self:_cdHtml,_ndRep,_ndRep2 - _ndRep + 5)

Return _cdReplace

Method getHtml() CLASS odEmail
	_xdHtml := StrTran(Self:_cdHtml,Self:_cdReplace,"")
Return _xdHtml

Method setHtml(_xdHtml) CLASS odEmail
	Self:_cdHtml := _xdHtml
Return Nil

Method LoadModelo(_cdFile) Class odEmail
	_xdHtml := ""

	If File(_cdFile)
		_ndHdl := FT_FUSE(_cdFile)

		FT_FGOTOP()
		While !FT_FEOF()
			_cdLine := FT_FReadLn()
			_xdHtml += _cdLine
			FT_FSKIP()
		EndDo
		FT_FUSE()

	EndIf
	Self:aItensChange := getItensTable(_xdHtml)

	For _xdW := 01 To Len(Self:aItensChange)
		_xdHtml := StrTran(_xdHtml,Self:aItensChange[_xdW][01],"")
	Next

Return _xdHtml


/*Statics Function inerentes a Classe Nao Sao Visiveis*/
/*
Static Function TakeFile(_cdFile)
_cdHtml := ""

If File(_cdFile)
_ndHdl := FT_FUSE(_cdFile)

FT_FGOTOP()
While !FT_FEOF()
_cdLine := FT_FReadLn()
_cdHtml += _cdLine
FT_FSKIP()
EndDo
FT_FUSE()

EndIf
Self:aItensTable := getItensTable(_cdHtml)

Return _cdHtml
*/
Static Function GetTagInformation(xdTag,xdHtml,nPosIni,nPosFim,xReturn)
	Local xdContent   := ""

	Local nPosInicial := 0
	Local nPosFinal   := 0

	Default xdTag     := ""
	Default xdHtml    := ""
	Default nPosIni   := 01
	Default nPosFim   := Len(xdHtml)
	Default xReturn   := CONTENT

	If !Empty(xdTag)

		xdHtml := SubStr(xdHtml,nPosIni,nPosFim)


		nPosInicial := At("<"+xdTag,xdHtml)
		nPosFinal   := At("</" + xdTag + ">",xdHtml) 
		If nPosInicial == 0           
			xdContent := ''
			ConOut('[GetTag] ERROR Initial Position not Found')  
		EndIf

		If nPosFinal == 0
			xdContent := ''
			ConOut('[GetTag] ERROR Final Position not Found')
		EndIf
		nPosFinal += Len(xdTag) + 03
		xdContent := SubStr(xdHtml,nPosInicial,nPosFinal - nPosInicial )
	Else
		xdContent := ''
		ConOut('[GetTag] TAG not informed')
	EndIf

	//Tratamento para quando quiser pesar as posicao da TAG e não o Conteudo
	If xReturn == POSITION
		xdContent := {nPosInicial,nPosFinal}
	EndIf

Return xdContent

Static Function GetTagArr(xdTag,xdHtml,nPosIni,nPosFim)

	Local adTag       := {}

	Default xdTag     := ""
	Default xdHtml    := ""
	Default nPosIni   := 01
	Default nPosFim   := Len(xdHtml)

	xdHtml := SubStr(xdHtml,nPosIni,nPosFim)
	lExecute := .T.

	While Len(xdHtml) > 0 .And. lExecute
		aPos := GetTagInformation(xdTag,xdHtml,,,POSITION)
		If aPos[01] > 0 .And. aPos[02] > 0
			aAdd(adTag, SubStr(xdHtml,aPos[01],aPos[02] - aPos[01]) )
		Else
			lExecute := .F.
		EndIf

		If aPos[02] + 1 < Len(xdHtml)
			xdHtml := SubStr(xdHtml,aPos[02] + 1)
		EndIf

	EndDo

Return adTag

Static Function getItensTable(_xdHtml)
	Local adTags      := {}
	Local adTag       := {}
	Local nPosInicial := 0 
	Local nPosFinal   := 0
	Local xColuna     := ""
	Local aColunas    := {}

	Default _xdHtml := ""

	cdBody := GetTagInformation("tbody",_xdHtml)

	If !Empty(cdBody)
		adTags := GetTagArr('tr',cdBody)
		For _xdW := 01 To Len(adTags)

			adTds := GetTagArr('td',adTags[_xdW])
			aColunas := {}
			For _xdJ := 01 To Len(adTds)
				xColuna := adTds[_xdJ]
				While "%"$xColuna
					nPosI := At("%", xColuna)
					xColuna := SubStr(xColuna,nPosI+1)
					nPosF := At("%", xColuna)
					xColuna := SubStr(xColuna,1,nPosF-1)
					aAdd(aColunas,xColuna )
				EndDo
			Next

			xdTr := adTags[_xdW]
			adTags[_xdW] := {xdTr, aClone(aColunas) }

		Next

	EndIf

Return adTags
