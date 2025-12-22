#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include "TBICONN.ch"
#include 'fileio.ch'

user function OPS_APONTAMENTO()	

	//RpcSetType(3)
	Local xRet
	RpcSetEnv('01','01')
	//cdRecurso := "TUBO4"
	
	//_xReturn := _GetOPS(cdRecurso)
	
	_xdJson := '{ "NumeroOP":"19D33301001" , "UserName":"Administrator","Quantidade":420}'
	xRet := _SetApontamento(_xdJson)

	//cReturn := FWJsonSerialize(_xReturn,.F.,.F.)
return

Static Function _SetApontamento(cdJson)

	Local _lRet 	:= .T. 
	Local nPerc 	:= GetMv("MV_PERCPRM")
	Local _xdMessage 		:= ""
	Local _enter	:= Chr(13)+Chr(10)
	Local odApontamento 	:= Nil
	
	Conout("NOVA VERSÃO********************************************************************")
	If FWJsonDeserialize(cdJson,@odApontamento)

		//cdUserName := If(,odApontamento:cdUsername,"")
		_lRet := ValType("odApontamento:Username")=="C"
		If !_lRet
			_cdMessage := "Tag UserName é obrigatória  no Json"
			u_AAFVNX01("General",_cdMessage)
		EndIf

		_lRet := ValType("odApontamento:Quantidade")=="N"
		If !_lRet
			_cdMessage := "Tag Quantidade é obrigatória  no Json"
			u_AAFVNX01(odApontamento:Username,_cdMessage)
		EndIf

		_lRet := ValType("odApontamento:NumeroOp")=="C"
		If !_lRet
			_cdMessage := "Tag NumeroOp é obrigatória  no Json"
			u_AAFVNX01(odApontamento:Username,_cdMessage)
		EndIf

		If _lRet
			u_AAFVNX01(odApontamento:Username,' Validando Quantidade [' + Alltrim(Str(odApontamento:Quantidade)) + ']')
			//_lRet :=
			_lRet := odApontamento:Quantidade > 0
			if !_lRet
				_xdMessage := " Quantidade Deve ser Superior a 0 " + _enter
				u_AAFVNX01(odApontamento:Username,_xdMessage)	          
			EndIf
		EndIf

		If _lRet
			u_AAFVNX01(odApontamento:Username,' Validando Numero da  OP [' + Alltrim(odApontamento:NumeroOP) + ']')
			_lRet := !Empty(odApontamento:NumeroOp)       
			if !_lRet
				_xdMessage += " Numero da OP e Obrigatório" + _enter
			EndIf
		EndIf

		If _lRet                 
			u_AAFVNX01(odApontamento:Username,' Validando se a OP [' + odApontamento:NumeroOP + '] esta Completa com as 11 posições')
			_lRet := Len(odApontamento:NumeroOp) == 11
			If !_lRet
				_xdMessage += "OP deve ser preenchida com 11 caracteres" + _enter
			EndIf
		EndIf

		if _lRet

			SC2->(dbSetOrder(1))
			u_AAFVNX01(odApontamento:Username,' VALIDANDO SE A OP [' + odApontamento:NumeroOP + '] Existe no SC2' )
			If !SC2->(dbSeek(xFilial('SC2') + odApontamento:NumeroOP ))
				_xdMessage := 'OP [' + odApontamento:NumeroOP + '] não Encontrada na Base de Dados '
				_lRet := .F.
			EndIf
		EndIf

		If _lRet
			u_AAFVNX01(odApontamento:Username,'VALIDANDO SE A OP [' + odApontamento:NumeroOP + '] Esta Suspensa' )
			If SC2->C2_STATUS == "U"
				_xdMessage := 'OP [' + odApontamento:NumeroOP + '] Suspensa, Operação não será efetuada '			  
				_lRet := .F.
			EndIf
		EndIf
		nQtdMaior := 0
		If _lRet
			u_AAFVNX01(odApontamento:Username,'VALIDANDO SE A OP [' + odApontamento:NumeroOP + '] Possui Saldo para apontamento' )
			/*Alteração arlindo*/
			nTotal := SC2->C2_QUANT- SC2->C2_QUJE
			If nTotal<0
				If nPerc >0 
					nTotal := Abs(nTotal)+odApontamento:Quantidade
					If nTotal > SC2->C2_QUANT*(nPerc/100)
						_xdMessage := "Quantidade [" + Alltrim(Str(odApontamento:Quantidade)) + "] Informada para Apontamento Superior ao Saldo Restante"
						_lRet := .F.
					Else
						nQtdMaior := odApontamento:Quantidade
					EndIf
				Else
					_xdMessage := "Quantidade [" + Alltrim(Str(odApontamento:Quantidade)) + "] Informada para Apontamento Superior ao Saldo Restante"
					_lRet := .F.
				EndIf
			ElseIf  odApontamento:Quantidade > nTotal  
				If nPerc > 0
					If Abs(Abs(nTotal)- odApontamento:Quantidade) > SC2->C2_QUANT*(nPerc/100) 
						_xdMessage := "Quantidade [" + Alltrim(Str(odApontamento:Quantidade)) + "] Informada para Apontamento Superior ao Saldo Restante"
						_lRet := .F.
					Else
						nQtdMaior := Abs( Abs(nTotal)- odApontamento:Quantidade )
					EndIf
				Else
					_xdMessage := "Quantidade [" + Alltrim(Str(odApontamento:Quantidade)) + "] Informada para Apontamento Superior ao Saldo Restante"
					_lRet := .F.
				EndIf
			/*Else
				nQtdMaior := Abs(odApontamento:Quantidade-(SC2->C2_QUANT- SC2->C2_QUJE))*/
			EndIf
		EndIf
		
		_dEmissao := Date()
		If _lRet
			u_AAFVNX01(odApontamento:Username,'Iniciando Apontamento de Produção para OP [' + odApontamento:NumeroOp + '] ' )

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial('SB1') + SC2->C2_PRODUTO ))

			aMata250      :={}

			_cdHora := Time()

			cUserName := odApontamento:Username
			ndQtd := odApontamento:Quantidade
			cdOP  := odApontamento:NumeroOP

			aAdd(aMata250,{"D3_TM"  	 ,"001"		            ,NIL})
			aAdd(aMata250,{"D3_COD"		,SC2->C2_PRODUTO	    ,NIL})
			aAdd(aMata250,{"D3_UM"		,SB1->B1_UM			    ,NIL})
			aAdd(aMata250,{"D3_QUANT"  	,ndQtd    			    ,NIL})
			aAdd(aMata250,{"D3_OP"     	,cdOP                   ,NIL})
			aAdd(aMata250,{"D3_LOCAL"  	,SC2->C2_LOCAL		    ,NIL})
			aAdd(aMata250,{"D3_EMISSAO"	,_dEmissao  		    ,NIL})
			//aAdd(aMata250,{"D3_CC"		,SB1->B1_CC		    ,NIL})
			aAdd(aMata250,{"D3_USUARIO"	,cUserName ,NIL})

			If SD3->(FIeldPos("D3_XDATA")) > 0
				aAdd(aMata250,{"D3_XDATA"	,Date()         ,NIL})
			EndIf
			if SD3->(FieldPos("D3_XHORA")) > 0
				aAdd(aMata250,{"D3_XHORA"	,_cdHora	    ,NIL})
			EndIf

			If SB1->B1_RASTRO == "L" .And. GetMv("MV_RASTRO") == "S"
				aAdd(aMata250,{"D3_LOTECTL"	,Left(Dtos(_dEmissao),6) ,NIL})
				aAdd(aMata250,{"D3_DTVALID" ,_dEmissao + 60			 ,NIL})
			EndIf
			If nQtdMaior>0
				aAdd(aMata250,{"D3_QTMAIOR" , nQtdMaior ,NIL})
				aAdd(aMata250,{"D3_PARCTOT" , "P" ,NIL})
			EndIf

			Private lMsErroAuto := .F.
			_adSC2 := SC2->(getArea())
			u_AAFVNX01(cUserName,'Iniciando Rotina Automatica de apontamento para a OP[' + odApontamento:NumeroOP + '] ' )

			MSExecAuto({|x, y| mata250(x, y)},aMata250, 3 )
			SC2->(restArea(_adSC2))
			u_AAFVNX01(cUserName,'Retorno da Rotina Automatica de apontamento para a OP[' + odApontamento:NumeroOP + '] ' )

			If lMsErroAuto
				_xdErro :=  Mostraerro("\system","")
				conout(_xdErro)
				_lRet := .F.

				_xdId := u_AAFVNX01(odApontamento:Username,'ERRO no apontamento para a OP[' + odApontamento:NumeroOP + '] [' + _xdErro + ']' )//,.T.,.T.)
				
				_xdMessage := u_MDResumeErro(_xdErro)	       
			Else
				u_AAFVNX01(odApontamento:Username,'Apontamento para a OP[' + odApontamento:NumeroOP + '] Efetuado com Sucesso' )
			EndIf	
		EndIf
		if _lRet
			_xdSD3 := " Select TOP 1 * From " + RetSqlName('SD3') + " D3 "
			_xdSD3 += "  Where D3.D_E_L_E_T_ = ' ' "
			_xdSD3 += "    And D3_OP    = '" + odApontamento:NumeroOP + "' "  
			_xdSD3 += "    And D3_XDATA = '" + Dtos(_dEmissao)   + "' "
			_xdSD3 += "    And D3_XHORA = '" + _cdHora + "' "
			_xdSD3 += "    And D3_COD = '" + SC2->C2_PRODUTO  + "'"
			_xdSD3 += "    Order By R_E_C_N_O_ DESC

//			_xsTbl := GetNextAlias()

			_xsTbl := MPSysOpenQuery(_xdSD3)

			conout('SE HÁ REGISTROS NA DATA E HORA DO APONTAMENTO DE PRODUÇÃO')
			u_AAFVNX01(odApontamento:Username,'Procurando Apontamento de Producao para a OP[' + odApontamento:NumeroOp + '] Efetuado! ' )
			ConOut(!(_xsTbl)->(EOF()))
			If !(_xsTbl)->(EOF())		    
				_xdNumSeq := (_xsTbl)->D3_NUMSEQ
				__nRecSD3 := (_xsTbl)->R_E_C_N_O_

				u_AAFVNX01(odApontamento:Username,'NUMSEQ ENCONTRADO [' + _xdNumSeq + '] ' )
				u_AAFVNX01(odApontamento:Username,'RECNO ENCONTRADO [' + Str(__nRecSD3) + '] ' )

				//Conout('[NUMSEQ ENCONTRADO ]' + _xdNumSeq)
				//Conout('[RECNO ENCONTRADO ]' + Str(__nRecSD3) )
				u_AAFVNX01(odApontamento:Username,'POSICIONANDO NO APONTAMENTO DE PRODUCAO EFETUADO ' )
				SD3->(dbGoTo(__nRecSD3))
				_adCb0 := {}
				aAdd(_adCb0,SC2->C2_PRODUTO)
				aAdd(_adCb0,odApontamento:Quantidade  )
				aAdd(_adCb0,__cUserId)
				aAdd(_adCb0,Nil)//DOC
				aAdd(_adCb0,Nil)//Serie
				aAdd(_adCb0,Nil)//fornece
				aAdd(_adCb0,Nil)//Loja
				aAdd(_adCb0,Nil)//Pedido
				aAdd(_adCb0,Nil)//Endereco
				aAdd(_adCb0,SC2->C2_LOCAL)//Local
				aAdd(_adCb0,odApontamento:NumeroOP)
				aAdd(_adCb0, _xdNumSeq )
				aAdd(_adCb0,Nil)
				aAdd(_adCb0,Nil)
				aAdd(_adCb0,Nil)
				aAdd(_adCb0,Left(DTOS(Date()),6) )
				aAdd(_adCb0,"")
				aAdd(_adCb0,Date() + SB1->B1_PRVALID)
				aAdd(_adCb0,""/*SB1->B1_CC*/)
				aAdd(_adCb0,Nil) //LocOri
				aAdd(_adCb0,Nil)
				aAdd(_adCb0,Nil)//OpReq
				aAdd(_adCb0,Nil)//NumSeri
				aAdd(_adCb0,"SD3")//Origem
				aAdd(_adCb0,Nil)//cItNFe
				u_AAFVNX01(odApontamento:Username,'GERANDO ETIQUETA PARA A OP [' + odApontamento:NumeroOp + ']' )
				//ConOut('GERANDO ETIQUETA [' + time() + ']')
				_xdCodBar  := CBGrvEti('01',_adCB0)
				If Empty(SC2->C2_XPEDIDO)
					//::cdCliente := ""
				Else
					SC5->(dBSetOrder(1))
					If SC5->(dbSeek(xFilial('SC5') + SC2->C2_XPEDIDO) )
						// ::cdCliente := SC5->C5_CLIENTE + '-'+SC5->C5_LOJA + ' ' + Posicione('SA1',1,xFilial() + SC5->C5_CLIENTE + SC5->C5_LOJA,'A1_NOME')
					EndIf
				EndIf 			
				//conout(::cdCodBar)			
				If Empty(_xdCodBar)
					_lRet := .F.				
					_xdMessage := "Codigo de Barra Não Gerado por motivo Desconhecido!"
					u_AAFVNX01(odApontamento:Username,_xdMessage )
					//SetSoapFault("APONTAMENTO","[17] ID:(" + _xdId + ") Codigo de barra não Gerado por Motivo desconhecido" )
				Else
				    CB0->(DbSetOrder(1))
				    CB0->(dbSeek(xFilial('CB0') + _xdCodBar))
				    _xdMessage := '[OK]{ "Produto":"' + SC2->C2_PRODUTO + '","OP":"' + odApontamento:NumeroOP + '","Etiqueta":"'+_xdCodBar+'", "Data":" '+ Dtoc(_dEmissao) + '","Hora":"' + _cdHora + '", "Lote":"' + CB0->CB0_LOTE + '" ' + '}'
					u_AAFVNX01(odApontamento:Username,'CODIGO DE ETIQUETA[' + _xdCodBar + '] GERADO PARA O APONTAMENTO DA OP [' + odApontamento:NumeroOp + ']' )
				EndIf
			Else
				_lRet := .F.
				_xdMessage := "MOVIMENTAÇÃO NÃO ENCONTRADA, ETIQUETA NÃO GERADA"
				u_AAFVNX01(odApontamento:Username,'MOVIMENTAÇÃO NÃO ENCONTRADA PARA A OP [' + odApontamento:NumeroOp + '], ETIQUETA NÃO GERADA' )			 
			EndIf
		EndIf	

	EndIf
	
Return _xdMessage


Static Function _GetNextOPS(cdRecurso)
	Default cdRecurso := ""
Return 
Static Function _GetOPS(cdRecurso,nSkip)

	Default cdRecurso := ""
	Default nSKip := 0

	_xdReturn := {}

	_xQry := ""
	_xQry += " Select " 
	_xQry += " C2_NUM+C2_ITEM+C2_SEQUEN NUMERO, "
	If SC2->(FieldPos("C2_XPEDIDO")) > 0
		_xQry += "   C2_XPEDIDO PEDIDO ,
	Else
		_xQry += "   ' ' PEDIDO , 
	EndIf
	_xQry += "   C2_PRODUTO PRODUTO, "
	_xQry += "   C2_RECURSO RECURSO, "
	_xQry += "   C2_OBS     OBS    , "
	_xQry += "   LEFT(C2_EMISSAO,6) LOTE,
	_xQry += "   B1_ESPECIF   DESCRICAO "
	_xQry += " From " + RetSqlName('SC2') + " C2 With(nolock) "
	_xQry += "  Left Outer Join " + RetSqlName('SB1') + " B1 With(nolock) ON B1_COD = C2_PRODUTO "
	_xQry += "  Where C2.D_E_L_E_T_ = ' ' "
	_xQry += "    And C2_STATUS = 'N' "
	//If lAtivo
	//   _xQry += "    And C2_STATUS != 'U' "
	//Else
	//  _xQry += "    And C2_STATUS = 'N' "
	//EndIf
	_xQry += "    And C2_DATRF= ' ' " 
	_xQry += "    And C2_EMISSAO >= '20160101'"
	_xQry += "    And C2_FILIAL = '01' "
	_xQry += "    AND C2_RECURSO <>'' "
	_xQry += "    And C2_PRODUTO NOT IN('PRDCCORTE1') "   
	_xQry += "    And Left(C2_PRODUTO,2) Not In ('12')  "

	If !EMpty(cdRecurso)
		_xQry += " And C2_RECURSO = '" + cdRecurso + "'"
	EndIf
	_xQry += " Order By C2_XSEQUEN,C2_NUM "
	if nSKip > 0
	   _xQry += " OFFSET ("+Alltrim(Str(nSkip))+") ROWS FETCH NEXT (100) ROWS ONLY
	EndIf
//	SELECT *



	_xTbl := MpSysOpenQuery(_xQry)
	Memowrite("DIEGO.SQL",_xQry)
	While !(_xTbl)->(Eof())

		oOP := XOP():New( (_xTbl)->NUMERO )		
		aAdd(_xdReturn, oOp )

		(_xTbl)->(dbSkip())
	EndDo
    cReturn := FWJsonSerialize(_xdReturn,.F.,.F.)
Return cReturn

WSRESTFUL OPS DESCRIPTION "Serviço de Apontamento de Producao"

WSDATA count AS INTEGER
WSDATA cdNumOP    AS string

WSMETHOD GET DESCRIPTION "Retornar as OPS!" WSSYNTAX "/OPS || /OPS/{Url}/{Recurso}"
WSMETHOD Put DESCRIPTION "Retornar as OPS!" WSSYNTAX "/OPS || /OPS/{NumeroOP}"

End WsRestful

WsMethod Get WSRECEIVE cdRecurso WSSERVICE OPS

	Local lRecurso := .F.
	Local lNext := .F.
    
	::SetContentType("application/json")
	//conout(ldOk)

	If Len(::aURLParms) > 0
		If Upper(::aURLParms[01]) == Upper("GetOpByRecurso")
			lRecurso := .T.
			cdRecurso := If(Len(::aURLParms) >=2 ,::aURLParms[02],"")
		ElseIf Upper(::aURLParms[01]) == Upper("GetNextByRecurso")
		    lRecurso := .F.
			cdRecurso := If(Len(::aURLParms) >=2 ,::aURLParms[02],"")
			lNext := .T.
		ElseIf Upper(::aURLParms[01]) == Upper("STATUS")
		    cdRecurso := "NNN"
		Else
			cdRecurso := ::aURLParms[01]
		EndIf
	EndIf

	ConOut(cdRecurso)
	If lRecurso
		cReturn := _GetOPS(cdRecurso)//FWJsonSerialize(_xReturn,.F.,.F.)
		::SetResponse(EncodeUtf8(cReturn))
	ElseIf lNext	     
         cReturn := _GetOPS(cdRecurso,1)//FWJsonSerialize(_xReturn,.F.,.F.)
		::SetResponse(EncodeUtf8(cReturn))
	ElseIf Empty(cdRecurso)
		cReturn := _GetOPS(cdRecurso)//FWJsonSerialize(_xReturn,.F.,.F.)
		::SetResponse(EncodeUtf8(cReturn))
	Else
		SC2->(dbSetOrder(1))
		If SC2->(dbSeek(xFilial('SC2') + cdRecurso))
			//oOP := XOP():New( (_xTbl)->NUMERO)
			oOP := XOP():New( SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN )
			cReturn := FWJsonSerialize(oOP,.F.,.F.)
			::SetResponse(EncodeUtf8(cReturn))
		Else
			SetRestFault(400,"Op Não Encontrada")
		EndIf	
	EndIf

Return .T.


WsMethod Put WSRECEIVE cdRecurso WSSERVICE OPS
    
	::SetContentType("application/json")

	cBody := ::GetContent()
	conout(cBody)
	_xdReturn := _SetApontamento(cBody)

	If !Empty(_xdReturn)
	    Conout(_xdReturn)
	    Conout(Left(_xdReturn,4))
	    If Left(_xdReturn,4) == "[OK]"
	        ::SetResponse(EncodeUtf8(SubStr(_xdReturn,5) ) )
	    Else
		    SetRestFault(400,_xdReturn)
			Return .F.
		EndIf
	EndIf

Return .T.

User Function AAFVNX01(_xId,_xdMsg,lSZ6,lEmail)

	Default _xId   := "D02" 
	Default _xdMsg := "Testando se essa bagaca funciona mesmo"
	Default lSZ6   := .F.
	Default lEmail := .F.

	If Type("cAcesso") = "U"
		RpcSetType(3)
		RpcSetEnv( "01","01")//, "Administrador", " ", "EST", "WEBEPDM" , , , , ,  )
	EndIf

	_xdId := ""
	xdata := Date()
	xHora := Time()
	If lSZ6		
		_xdId := GetSXEnum("SZ6","Z6_ID")
		SZ6->(RecLock('SZ6',.T.))
		SZ6->Z6_FILIAL := xFilial('SZ6')
		SZ6->Z6_USUARIO:= _xId
		SZ6->Z6_ID     := _xdId
		SZ6->Z6_MSGM   := _xdMsg
		SZ6->Z6_DATA   := xData
		SZ6->Z6_HORA   := xHora
		SZ6->(msUnlock())
		ConfirmSX8()
	EndIf

	If lEmail
		cModelo  := "\web\Modelos\erro-map-integracao.html"
		xEmail := SuperGetMv("MV_XMAPIN",.F.,"romulo@amazonaco.com.br;francisco@amazonaco.com.br;antonio.carlos@amazonaco.com.br")
		_odEmail := odEmail():New(cModelo)
		_odEmail:ValByName("xdID",_xdId )
		_odEmail:ValByName("xdOperador",_xId )
		_odEmail:ValByName("xdData",DTOC(xData) )
		_odEmail:ValByName("xdHora", xHora )
		_odEmail:ValByName("xdMsgm", _xdMsg )
		_odEmail:SetAssunto("Erro integracao MAP x Protheus ID: " + _xdId)
		_odEmail:setTo( xEmail + "; diego.fael@gmail.com")
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

	EndIf

	If ValType(_xdMsg) == "N"
		_xdMsg := Alltrim(Str(_xdMsg))
	ElseIf ValType(_xdMsg) == "L"
		_xdMsg := If(_xdMsg,"True","False")
	EndIf

	_xdName := "\_fvncional\logs\"+_xId+"-"+DTOS(Date())+".log"

	If !ExistDir("\_fvncional")
		MakeDir("\_fvncional")
	EndIf

	If ExistDir("\_fvncional")
		If !ExistDir("\_fvncional\logs")
			MakeDir("\_fvncional\logs")
		EndIf       
	EndIf

	ConOut("[" + Time() + "]" + ' Checando Arquivo: ' + _xdName )
	If !File(_xdName)
		ConOut("[" + Time() + "]" + ' Tentando Criar Arquivo: ' + _xdName )
		nHdl := fCreate(_xdName)
	Else
		ConOut("[" + Time() + "]" + ' Tentando Abrir o Arquivo: ' + _xdName )
		nHdl := fOpen(_xdName , FO_READWRITE + FO_SHARED )       
	EndIf

	If nHdl == -1
		ConOut("[" + Time() + "]" + 'Erro de abertura : FERROR '+str(ferror(),4))
	Else
		// Vai para o Final do Arquivo
		_xdPrint := "[" + Time() + "] - " + _xdMsg + Chr(13) + Chr(10)
		nLength := FSEEK(nHdl, 0, FS_END)
		FWrite(nHdl, _xdPrint ) // Insere texto no arquivo

		ConOut( _xdPrint )

	EndIf

	//_ConOut("Testando se essa bagaca funciona mesmo")
	FClose(nHdl)    
Return _xdId

User Function SPFCLOSE()

SPF_CLOSE("SIGAPSS.SPF")

Return( Nil )

User Function MDResumeErro(cErro)
	Local nPos, cLinha
	Local cAux   := cErro
	Local lCopia := .T.
	Local cRet   := ""
	
	While (nPos := At(Chr(13)+Chr(10),cErro)) > 0   // Procura a quebra de linha na variável
		cLinha := SubStr(cErro,1,nPos-1)   // Copia a linha do erro
		qout(clinha)
		If !("HELP:" $ cLinha)
			If !("Sua senha" $ cLinha)   // Não processa essas linhas
				If "Tabela " $ cLinha  // Ao encontrar essa referência, então pára a cópia pois o erro já foi todo copiado
					lCopia := .F.
				ElseIf "Invalido"  $ cLinha   // Ao encontrar essa referência, então encontrou a causa do erro
					cRet += " " + AllTrim(cLinha)   // Copia as partes relevantes do erro
					Exit   // Sai pois o erro já foi todo lido
				Endif
				
				If lCopia
					cRet += " " + AllTrim(cLinha)   // Copia as partes relevantes do erro
				Endif
			Endif
		EndIf
		
		cErro := SubStr(cErro,nPos+2,Len(cErro))  // Apaga a linha da variavel
	Enddo
	
	If Empty(cRet)   // Caso não tenha definida mensagem válida
		cRet := AllTrim(StrTran(StrTran(Upper(cAux),Chr(13)+Chr(10),""),"HELP:",""))
	Endif
	
Return cRet
