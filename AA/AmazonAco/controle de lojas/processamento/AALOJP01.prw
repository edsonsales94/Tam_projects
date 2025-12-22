#include 'protheus.ch'
#include 'parmtype.ch'

user function AALOJP01()

	_adEmp  := {"01","05"}
	_xdESql := "" 
	For ndEmp := 01 To Len(_adEmp)

		RPcSetType(3)
		RpcSetEnv(_adEmp[ndEmp],"01")//,,,,,)

		_xdSql := " " 
		_xdSql += " Select '" + _adEmp[ndEmp] + "' EMPRESA,L1_VEND,A3_NOME,A3_EMAIL,L1_FILIAL,L1_NUM,L1_EMISSAO,L1_DTLIM,L1_CLIENTE,L1_LOJA,A1_NOME,L1_VLRTOT "
		_xdSql += " 	From " + RetSqlName('SL1') + " L1 with(Nolock)
		_xdSql += " LEFT OUTER JOIN " + RetSqlName('SA1') + " ON A1_COD = L1_CLIENTE AND A1_LOJA = L1_LOJA
		_xdSql += " Inner JOIN " + RetSqlName('SA3') + " ON A3_COD = L1_VEND 
		_xdSql += " Where (L1_DOC = ' ' AND L1_DOCPED = ' ')
		_xdSql += " And convert(date,L1_DTLIM) > convert(date,getdate())
		_xdSql += " And L1_CLIENTE NOT IN('001190','049293','001187','021139','001189','020955','001188','001243')"

		If Len(Alltrim(_xdESql)) > 0
			_xdESql += " Union All "
		EndIf
		_xdESql += _xdSql

		If Len(_adEmp) != ndEmp
			RpcClearEnv()
		EndIf

	Next

	//_xdSql += " Union

	//cModelo  := "\web\Modelos\orcamentos-pendentes.html"

	xTab := getNextAlias()
	If Len(Alltrim(_xdESql)) > 0
		_xdESql += " ORDER BY L1_VEND,L1_EMISSAO "       
		dbUseArea(.T.,"TOPCONN",tcGenQry(,,_xdESql),xTab,.T.,.T.)

		cModelo  := "\web\Modelos\orcamentos-pendentes-geral.html"
		_odGeral := odEmail():New(cModelo)
        _xdGeral := 0
		cModelo  := "\web\Modelos\orcamentos-pendentes.html"
		_ldDados := .F.
		While !(xTab)->(Eof())
			xVend :=  (xTab)->L1_VEND
			xEmail := (xTab)->A3_EMAIL
			//xEmail := 'diego.fael@gmail.com;ulysses@amazonaco.com.br'

			_ldDados := .T.

			_odEmail := odEmail():New(cModelo)
			_odEmail:ValByName("codigo",(xTab)->L1_VEND)
			_odEmail:ValByName("nome"  ,(xTab)->A3_NOME)

			_xdItens := 0        
			_xdSoma := 0

			While !(xTab)->(Eof()) .And. (xTab)->L1_VEND == xVend
				aItem := {}
				aAdd(aItem, (xTab)->EMPRESA)
				aAdd(aItem, (xTab)->L1_FILIAL)
				aAdd(aItem, (xTab)->L1_NUM)
				aAdd(aItem, DTOC(STOD((xTab)->L1_EMISSAO)))
				aAdd(aItem, DTOC(STOD((xTab)->L1_DTLIM)))
				aAdd(aItem, (xTab)->L1_CLIENTE)
				aAdd(aItem, (xTab)->L1_LOJA)
				aAdd(aItem, (xTab)->A1_NOME)
				aAdd(aItem, Transform( (xTab)->L1_VLRTOT ,"@E 999,999,999.99"  ))

				_odEmail:addByName( {"it.Empresa","it.Filial","it.Orcamento","it.Emissao","it.Validade","it.Cliente","it.Loja","it.Nome","it.Valor"} ,;
									aItem)				
				_xdSoma += (xTab)->L1_VLRTOT
				(xTab)->(dbSkip())
				_xdItens++
			EndDo
			_odEmail:ValByName("CONTADOR", transform(_xdItens,"@E 999,999,999.99") )
			_odEmail:ValByName("TOTAL", transform(_xdSoma,"@E 999,999,999.99") )
			_odEmail:SetAssunto("Orçamentos Pendente de Faturamento")
			_xdGeral += _xdSoma
			_odGeral:addByName({"DADOS"},{ _odEmail:GetHtml() } )

			_odEmail:setTo( xEmail )

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
		EndDo
		_odGeral:ValByName("TOTAL", transform(_xdGeral,"@E 999,999,999.99") )
		_odGeral:SetAssunto("Orçamentos Pendentes Geral")
		if !_ldDados 
			_odGeral:addByName({"DADOS"},{ "Sem Dados a Exibir" } )
		EndIf
		_odGeral:setTo( "herivelton.garcias@amazonaco.com.br;sergio@amazonaco.com.br;francisco@amazonaco.com.br;diego.ramos@fvncional.com.br" )
		_xdRet := _odGeral:ConectServer()
		If !Empty(_xdRet)
			Aviso('',_xdRet,{'OK'})
		Endif

		If Empty(_xdRet)
			_xdRet := _odGeral:SendMail()
			If !Empty(_xdRet)
				Aviso('',_xdRet,{'OK'})
			EndIf
		EndIf
	EndIf

return Nil
