#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

#DEFINE IMP_SPOOL 2


CLASS odSerasa

	METHOD New() CONSTRUCTOR
	METHOD Consulta() 

ENDCLASS

//-----------------------------------------------------------------
METHOD New() CLASS odSerasa

Return

METHOD Consulta() Class odSerasa

Return 



User Function odSerasa

	//Prepare Environment Empresa '01' Filial '01' Tables 'SA1'
    
    
	_cdUrl := "\Serasa\Conexao\IntegrationService.wsdl"
	oWsdl := Nil
	oWsdl := TWsdlManager():New()			 

	xRet := oWsdl:ParseFile( _cdUrl ) 
	If xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	Endif
	cSoap := ' <ns1:Authentication xmlns:ns1="http://service.integration.ds.com/" SOAP-ENV:actor="http://schemas.xmlsoap.org/soap/actor/next" SOAP-ENV:mustUnderstand="0">
	cSoap += ' YWljb25zdW1lckZpbmFuY2U6NDQxajZqazBnNjdu
	cSoap += ' </ns1:Authentication>

	oWsdl:SetWssHeader( cSoap )

	xRet := oWsdl:SetOperation("invokeIntegrationServiceFromSTS")
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	Endif
	xRet := oWsdl:SetValue(0, "<![CDATA[" + getXml() + "]]>")
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	Endif

	//_cdReturn := oWsdl:invokeIntegrationServiceFromSTS(getXml())
	oWsdl:cSSLCACertFile := "\SERASA\CERTS\SERASA_NEW.pem"
	_xdSoap := oWsdl:GetSoapMsg()
	MemoWrite('serasa-soap.xml',_xdSoap )
	_xdSoap := Strtran(_xdSoap,"<arg0",'<arg0 xmlns="" ')
	_xdName := '\Serasa\Request\serasa-soap_'+ SA1->A1_COD + DTOS(date()) + '.xml'
	MemoWrite(_xdName,_xdSoap )

	conout( oWsdl:GetWsdlDoc() )
	xRet := oWsdl:SendSoapMsg(_xdSoap)
	if xRet == .F.	
		conout( "Erro: " + oWsdl:cError )
		conout( "FaultCode: " + oWsdl:cFaultCode )
		conout( "FaultSubCode: " + oWsdl:cFaultSubCode )
		conout( "FaultString: " + oWsdl:cFaultString )
		conout( "FaultActor: " + oWsdl:cFaultActor )
		Alert("ERROR : " + oWsdl:cError)
		Return
	endif

	//Pega a mensagem de resposta
	_xdRespXml := oWsdl:GetSoapResponse()
	MemoWrite('serasa-soap-response.xml' , EncodeUtf8(_xdRespXml) )
	_xdName := '\Serasa\Response\serasa-soap-response_'+ SA1->A1_COD + DTOS(date()) + '.xml'

	MemoWrite(_xdName , _xdRespXml )
	If FunName() == "FINC010"
		u__doResponse(_xdName)
	EndIf
	//Aviso('XML RESPOSTA',_xdRespXml,{'OK'},3)  

	//oSerasa := WSIntegrationServiceService():New()
	//oSerasa:cArg0 := getXml()
	//oSerasa:invokeIntegrationServiceFromSTS()
	//Aviso('',oSerasa:cReturn,{'OK'},3)

Return _xdRespXml

User Function _doResponse(_xdXml)


	Private xdValues := DefineValues()

	Default _xdXml := "\Serasa\Response\serasa-soap-response.xml"
	cError := ""
	cWarning := ""
	ldAct := Empty(_xdXml)
	_odXml := XmlParserFile(_xdXml, "_", @cError, @cWarning )
	If _odXml == Nil      
		MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
		Return ""
	EndIf

	ldCont := .F.
	//_odXml:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_INVOKEINTEGRATIONSERVICEFROMSTSRESPONSE:_RETURN:TEXT
	cError := ""
	cWarning := ""
	_xdXml := EncodeUtf8( _odXml:_SOAP_ENVELOPE:_SOAP_BODY:_NS2_INVOKEINTEGRATIONSERVICEFROMSTSRESPONSE:_RETURN:TEXT )
	//MemoWrite('\Serasa\Request\serasa-soap21.xml',_xdXml)
	//MemoWrite('\Serasa\Request\')
	_odXml := XmlParser(EncodeUtf8(_xdXml), "_", @cError, @cWarning )
	If _odXml == Nil      
		MsgStop("Falha ao gerar Objeto XML de Retorno : "+cError+" / "+cWarning)
		Return ""
	EndIf
	If Type("_odXml:_DecisionResponse:_DerivedVariables") == "O"
		oDerived := _odXml:_DecisionResponse:_DerivedVariables
		ldCont := .T.        
	Else
		oDerived := Nil
	EndIf

	If oDerived != Nil
		If ValType(oDerived:_DerivedVariable) == "A"
			axItens := oDerived:_DerivedVariable
		Else
			axItens := {}
		EndIf
	Else
		axItens := {}
	EndIf

	For _xdL := 01 To Len(axItens)
		oItem := axItens[_xdL]
		_xdPos := aScan(xdValues,{|x| Upper(x[01]) == Upper(oItem:_NAME:TEXT) })
		If _xdPos > 0
			xdValues[_xdPos][02] := oItem:_VALUE:TEXT 
		EndIf 
	Next

	u__DOPRSEA()

	aCoors := FwGetDialogSize()
	//aCoors := {010,010,650,1100}
	If ldCont    
		Private odDlg := TDialog():New(aCoors[01],aCoors[01],aCoors[03],aCoors[04],'Avaliação',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

		_oLayer := FwLayer():New()
		_oLayer:Init(odDlg,.F.,.T.)
		_oLayer:AddLine('UP',40)
		_oLayer:AddLine('MIDDLE',55)
		_oLayer:AddLine('DOWN',05)

		_oLayer:AddColumn('ALL' ,085,,'UP')
		_oLayer:AddColumn('ALL' ,100,,'MIDDLE')
		_oLayer:AddColumn('ALL' ,100,,'DOWN')

		//oLayer:AddColumn('ALL' ,80,,'UP')
		_oLayer:AddColumn('ALL2' ,15,,'UP')

		_oUp      := _oLayer:GetColPanel('ALL' ,'UP' )
		_oUp2     := _oLayer:GetColPanel('ALL2','UP' )

		_oMiddle  := _oLayer:GetColPanel('ALL','MIDDLE')
		_oDown    := _oLayer:GetColPanel('ALL','DOWN'  )
		//oSize := FwDefSize():New( .T.)
		_adCabec := {}

		aAdd(_adCabec,{ "Faixa"                             , {|| _aBrowse[oBrowse:At()][02] }  , 'C' ,  '@!' , 1 , 10, 0 ,,,,,,  })
		aAdd(_adCabec,{ "Quantidade de falência/concordata" , {|| _aBrowse[oBrowse:At()][03] }  , 'C' ,  '@!' , 1 , 10, 0 ,,,,,,  })
		aAdd(_adCabec,{ "Quantidade de cheque sem fundo"    , {|| _aBrowse[oBrowse:At()][04] }  , 'C' ,  '@!' , 1 , 10, 0 ,,,,,,  })
		aAdd(_adCabec,{ "Quantidade de Refin"   		    , {|| _aBrowse[oBrowse:At()][05] }  , 'C' ,  '@!' , 1 , 10, 0 ,,,,,,  })
		aAdd(_adCabec,{ "Cesta de eventos "  			    , {|| _aBrowse[oBrowse:At()][06] }  , 'C' ,  '@!' , 1 , 10, 0 ,,,,,,  })

		oScr := TScrollBox():New(_oUp,_oUp:nTop + 10 ,_oUp:nLeft + 10, 16 * aCoors[03]/100  , 42*aCoors[04]/100   ,.T.,.T.,.T.)

		nLin := 10
		nCol := 10
		_xdValues := xdValues
		nLimite   := 37*aCoors[04]/100
		_aBrowse := {}
		For _xdK := 01 To Len(_xdValues) - 02

			If _xdValues[_xdK][02]!= Nil .And. _xdValues[_xdK][04] == 2

				For _xdF := 01 To Len(_adCabec)
					If Left(_xdValues[_xdk][03],len(_adCabec[_xdF][01])) == _adCabec[_xdF][01]
						_xdPos := aScan(_aBrowse,{|x| x[02] == Right(_xdValues[_xdk][03],1)})
						If _xdPos == 0
							aLin := {}
							aAdd(aLin,Nil)//1
							aAdd(aLin,Right(_xdValues[_xdk][03],1) )//2
							aAdd(aLin,"")//3
							aAdd(aLin,"")//4
							aAdd(aLin,"")//5
							aAdd(aLin,"")//6
							aAdd(_aBrowse,aLin)
							_xdPos := Len(_aBrowse)
						EndIf
						_aBrowse[_xdPos][_xdF + 01] := _xdValues[_xdk][02]
					EndIf 
				Next

			EndIf

			If _xdValues[_xdK][02]!= Nil .And. _xdValues[_xdK][04] == 1

				nTam := iIf( Len(Rtrim( _xdValues[_xdK][02]))*3 > Len(Rtrim(_xdValues[_xdK][03]))*3 , Len(Rtrim(_xdValues[_xdK][02]))*3 , Len(Rtrim(_xdValues[_xdK][03]))*3 ) 
				nTam := iIf(nTam < 40,40,nTam)


				if nCol + nTam > nLimite
					If nCol + nTam - nLimite <= 20
						nTam :=  nLimite - nCol
					Else
						nLin += 30
						nCol := 10 
					EndIf         	    
				EndIf

				SetPrvt(_xdValues[_xdK][01])
				SetPrvt("o"+_xdValues[_xdK][01])

				&(_xdValues[_xdK][01] + " :=  '"  + _xdValues[_xdK][02] + "'")

				cComand := "TSay():New( nLin,nCol,{|| '" + _xdValues[_xdK][03] + "'},oScr,,,, ,,.T.," + Str(CLR_RED) + "," + Str(CLR_WHITE) + "," + Str(nTam) + ",20)" 
				&(cComand)
				cComand := "o"+_xdValues[_xdK][01] + ":= TGet():New( nLin + 10,nCol,{|| '" + _xdValues[_xdK][02] + "' },oScr,nTam,009,'@!',,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,," + _xdValues[_xdK][01] + ",,,, )"
				&(cComand)
				//TGet():New( nLin + 10,nCol,{|| &(_xdValues[_xdK][01]) },oScr,nTam,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,_xdValues[_xdK][01] ,,,, )

				nCol += nTam + 10
			EndIf
		Next

		//oTGet1 := TGet():New( 01,01,{||cTGet1},oDlg,096,009,;"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet1,,,, )

		oBrowse := FWBrowse():New()
		oBrowse:SetDataArray()
		//oBrowse:AddStatusColumns(  { || _aCores[aScan(_aCores,{|x| &(x[01]) })][02] }, {||} )
		oBrowse:SetColumns(_adCabec)		
		oBrowse:SetArray(_aBrowse)	
		//oBrowse:SetBlkBackColor( {|| iIf( _aBrowse[oBrowse:At()][12] > _aBrowse[oBrowse:At()][11]  , CLR_YELLOW ,  )  } )
		//oBrowse:Refresh()
		//oBrowse:BLDBLCLICK :=
		//oBrowse:SetDoubleClick(   {||  _dblClick()  }  )
		oBrowse:setOwner(_oMiddle )
		oBrowse:Activate()

		// ativa diálogo centralizado 
		odDlg:Activate(,,,.T.,{|| .T.},,{|| } )
	ELse
		AViso('ERRO',_xdXml,{'OK'},3)
	EndIf
Return 


Static Function DefineValues()
	_xdValues := {}


	aAdd(_xdValues,{"riskScore"		  ,Nil,"RiskScore"         ,1})	
	aAdd(_xdValues,{"Detail_Comm1_301",Nil,"RiskScore"         ,1})                       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_302",Nil,"Tempo de Fundação" ,1})                 //Tempo de Fundação
	aAdd(_xdValues,{"Detail_Comm1_303",Nil,"Alerta em Negocios",1})                //Alerta em Negocios
	aAdd(_xdValues,{"Detail_Comm1_304",Nil,"Limite atual para clientes ativos",1}) //Limite atual para clientes ativos
	aAdd(_xdValues,{"Detail_Comm1_305",Nil,"Limite excedido para clientes ativos",1}) //Limite excedido para clientes ativos
	aAdd(_xdValues,{"Detail_Comm1_306",Nil,"Faturamento Presumido",1})                //Faturamento Presumido

	aAdd(_xdValues,{"Detail_Comm1_311",Nil,"Detalhamento de PEFIN",1}) //Detalhamento de PEFIN
	aAdd(_xdValues,{"Detail_Comm1_312",Nil,"Detalhamento de REFIN",1}) //Detalhamento de REFIN
	aAdd(_xdValues,{"Detail_Comm1_313",Nil,"Detalhamento de PROTESTO",1}) //Detalhamento de PROTESTO
	aAdd(_xdValues,{"Detail_Comm1_314",Nil,"Detalhamento de CONCORDATE/FALENCIA",1}) //Detalhamento de CONCORDATE/FALENCIA
	aAdd(_xdValues,{"Detail_Comm1_315",Nil,"Detalhamento de Ações",1}) //Detalhamento de Ações
	aAdd(_xdValues,{"Detail_Comm1_316",Nil,"Detalhamento de CCF"  ,1})   //Detalhamento de CCF
	aAdd(_xdValues,{"xDetail_Comm1_320",Nil,"PEFIN|REFIN"  ,1})   //Detalhamento de CCF
	aAdd(_xdValues,{"R412protesto",Nil,"Total Protesto"  ,1})   //Detalhamento de CCF
	
	aAdd(_xdValues,{"Detail_Comm1_102",Nil,"Verificação de Alerta em negócios",1})       //Verificação de Alerta em Negócios
	aAdd(_xdValues,{"Detail_Comm1_103",Nil,"Status do CNPJ na Receita"        ,1})       //Status do CNPJ na Receita
	aAdd(_xdValues,{"Detail_Comm1_104",Nil,"Status do CNPJ no Sintegra"       ,1})       //Status do CNPJ no Sintegra

	aAdd(_xdValues,{"Detail_Comm1_11",Nil,"Quantidade de falência/concordata na faixa 1",2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_12",Nil,"Quantidade de cheque sem fundo faixa 1",2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_13",Nil,"Quantidade de Refin faixa 1"           ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_14",Nil,"Cesta de eventos faixa 1"              ,2})       //RiskScore

	aAdd(_xdValues,{"Detail_Comm1_21",Nil,"Quantidade de falência/concordata na faixa 2",2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_22",Nil,"Quantidade de cheque sem fundo faixa 2"      ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_23",Nil,"Quantidade de Refin faixa 2"                 ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_24",Nil,"Cesta de eventos faixa 2"                    ,2})       //RiskScore

	aAdd(_xdValues,{"Detail_Comm1_31",Nil,"Quantidade de falência/concordata na faixa 3",2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_32",Nil,"Quantidade de cheque sem fundo faixa 3"      ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_33",Nil,"Quantidade de Refin faixa 3"                 ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_34",Nil,"Cesta de eventos faixa 3"                    ,2})       //RiskScore


	aAdd(_xdValues,{"Detail_Comm1_41",Nil,"Quantidade de falência/concordata na faixa 4",2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_42",Nil,"Quantidade de cheque sem fundo faixa 4"      ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_43",Nil,"Quantidade de Refin faixa 4"                 ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_44",Nil,"Cesta de eventos faixa 4"                    ,2})       //RiskScore


	aAdd(_xdValues,{"Detail_Comm1_51",Nil,"Quantidade de falência/concordata na faixa 5",2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_52",Nil,"Quantidade de cheque sem fundo faixa 5"      ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_53",Nil,"Quantidade de Refin faixa 5"                 ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_54",Nil,"Cesta de eventos faixa 5"                    ,2})       //RiskScore

	aAdd(_xdValues,{"Detail_Comm1_61",Nil,"Quantidade de falência/concordata na faixa 6",2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_62",Nil,"Quantidade de cheque sem fundo faixa 6"      ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_63",Nil,"Quantidade de Refin faixa 6"                 ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_64",Nil,"Cesta de eventos faixa 6"                    ,2})       //RiskScore

	aAdd(_xdValues,{"Detail_Comm1_001",Nil,"Decisão Aprovado"                           ,1})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_002",Nil,"Limite Concedido|Erro no cálculo 1"         ,1})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_003",Nil,"Prazo para o credito concedido de acordo com tabela de score ",1})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_004",Nil,"Decisão Reprovado"                          ,1})       //RiskScore

	aAdd(_xdValues,{"Detail_Comm1_201",Nil,"Status CNPJ| Ativo" ,1})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_202",Nil,"Sintegra|Habilitado",1})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_204",Nil,"Empresa inadimplente na carteira da amazon aço",1})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_205",Nil,"Alerta em negócios" ,1})       //RiskScore   

	aAdd(_xdValues,{"Detail_Comm1_211",Nil,"Quantidade de falência/concordata na faixa 1",2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_212",Nil,"Quantidade de cheque sem fundo faixa 1"      ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_213",Nil,"Quantidade de Refin faixa 1"                 ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_214",Nil,"Cesta de eventos faixa 1"                    ,2})       //RiskScore

	aAdd(_xdValues,{"Detail_Comm1_221",Nil,"Quantidade de falência/concordata na faixa 2",2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_222",Nil,"Quantidade de cheque sem fundo faixa 2"      ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_223",Nil,"Quantidade de Refin faixa 2"                 ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_224",Nil,"Cesta de eventos faixa 2"                    ,2})       //RiskScore

	aAdd(_xdValues,{"Detail_Comm1_331",Nil,"Quantidade de falência/concordata na faixa 3",2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_332",Nil,"Quantidade de cheque sem fundo faixa 3"      ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_333",Nil,"Quantidade de Refin faixa 3"                 ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_334",Nil,"Cesta de eventos faixa 3"                    ,2})       //RiskScore


	aAdd(_xdValues,{"Detail_Comm1_441",Nil,"Quantidade de falência/concordata na faixa 4",2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_442",Nil,"Quantidade de cheque sem fundo faixa 4"      ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_443",Nil,"Quantidade de Refin faixa 4"                 ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_444",Nil,"Cesta de eventos faixa 4"                    ,2})       //RiskScore

	aAdd(_xdValues,{"Detail_Comm1_551",Nil,"Quantidade de falência/concordata na faixa 5",2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_552",Nil,"Quantidade de cheque sem fundo faixa 5"      ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_553",Nil,"Quantidade de Refin faixa 5"                 ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_554",Nil,"Cesta de eventos faixa 5"                    ,2})       //RiskScore

	aAdd(_xdValues,{"Detail_Comm1_661",Nil,"Quantidade de falência/concordata na faixa 6",2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_662",Nil,"Quantidade de cheque sem fundo faixa 6"      ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_663",Nil,"Quantidade de Refin faixa 6"                 ,2})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_664",Nil,"Cesta de eventos faixa 6"                    ,2})          //RiskScore

	aAdd(_xdValues,{"Detail_Comm1_009",Nil,"Decisão Reprovado"    ,1})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_005",Nil,"Decisão Aprovado"     ,1})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_006",Nil,"Limite Nova Consulta" ,1})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_007",Nil,"Prazo"                ,1})       //RiskScore

	aAdd(_xdValues,{"Detail_Comm1_401",Nil,"Faixa de Score Rating " ,1})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_403",Nil,"Faturamento Anual" ,1})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_402",Nil,"PRINAD"            ,1})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_404",Nil,"Parecer Contábil"  ,1})       //RiskScore

	aAdd(_xdValues,{"Detail_Comm1_451",Nil,"Faixa de Score Rating " ,1})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_453",Nil,"Faturamento Anual" ,1})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_452",Nil,"PRINAD"            ,1})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_454",Nil,"Parecer Contábil"  ,1})       //RiskScore

	aAdd(_xdValues,{"Detail_Comm1_011",Nil,"Recusado por blacklist ou sinalização de inadimplencia" ,1})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_012",Nil,"Documento em blacklist"                                 ,1})       //RiskScore
	aAdd(_xdValues,{"Detail_Comm1_013",Nil,"Empresa com sinalização de inadimplência Blacklist"     ,1})       //RiskScore      

Return _xdValues 


Static Function _procXml(_xXml)

	//_xdBkp := _xXml
	/*
	_lLoop := .T.
	nLvl := 01
	adCount := {}
	While _lLoop

	If _xXml:DOMHasChildNode()	     
	_xXml:DOMChildNode()
	nLvl++	     
	aAdd(adCount,{0,0} )
	adCount[nLvl][02] := _xXml:DOMChildCount()	     
	Else
	If "fx:"$_xXml:cText
	//_xXml:cText := &(StrTran(_xXml:cText,"fx:","&") )
	_xXml:DomSetNode("",&(StrTran(StrTran(_xXml:cText,"fx:",""),"'",'"')))
	//_xXml:cText := 
	EndIf
	EndIf	  

	EndDo


	If _xXml:DOMHasChildNode()       
	_xdTam := _xXml:DOMChildCount()
	For _xdC := 01 To _xdTam
	_xXml:DOMChildNode()
	_procXml(_xXml)
	_xXml:DOMNextNode()            
	Next
	_xXml:DOMParentNode()
	Else
	If "fx:"$_xXml:cText
	//_xXml:cText := &(StrTran(_xXml:cText,"fx:","&") )
	_xXml:DomSetNode("",&(StrTran(StrTran(_xXml:cText,"fx:",""),"'",'"')))
	//_xXml:cText := 
	EndIf
	EndIf
	*/

Return _xXml

Static Function getXml( lReadFile )
	_cdXml := ' '
	lReadFile := .T.
	if lReadFile
		_oXml := TXmlManager():New()
		_oXml:ParseFile("soap-request.xml.ini")
		_xdXml := _oXml:Save2String()

		While 'fx:['$_xdXml
			nPos := At("fx:[",_xdXml)
			nEnd   := At("]",_xdXml,nPos)
			nMenor := At("<",_xdXml,nPos)

			iF nEnd == 0 .Or. nEnd > nMenor
				Alert('Erro na Estrutura do Arquivo de Configuração, Favor Contactar Setor de TI')
				Return ""
			Else
				_xdStr := SubStr(_xdXml,nPos+4,nEnd - (nPos + 04) )
				xdNewXml := Left(_xdXml,nPos - 1)
				xdNewXml += &(StrTran( _xdStr ,"'",'"'))
				xdNewXml += SubStr(_xdXml,nEnd + 1)
				_xdXml := xdNewXml 		        
			EndIf		     

		EndDo

		//_oXml := _procXml(_oXml)
		//_oXml:Save2File( 'file_teste.xml' )
		_cdXml := _xdXml
		//aviso('',_oXml:Save2String(),{''})
	EndIf
	if !lReadFile
		_cdXml += Chr(13) + Chr(10) +' <![CDATA[<?xml version="1.0" encoding="ISO-8859-1"?>
		_cdXml += Chr(13) + Chr(10) + ' <UDecideRequest>
		_cdXml += Chr(13) + Chr(10) +' <CustomerRequestID></CustomerRequestID>
		_cdXml += Chr(13) + Chr(10) +' <RequestType>CREATE</RequestType>
		_cdXml += Chr(13) + Chr(10) +' <SystemInfoDateTimeOverride/>
		_cdXml += Chr(13) + Chr(10) +' <CaseType>2</CaseType>
		_cdXml += Chr(13) + Chr(10) +' <Portal>STS</Portal>
		_cdXml += Chr(13) + Chr(10) +' <UserId>ai_sts</UserId>
		_cdXml += Chr(13) + Chr(10) +' <uSelect/>
		_cdXml += Chr(13) + Chr(10) +' <CBListOfSimilars/>
		_cdXml += Chr(13) + Chr(10) +' <ApplicationType>1</ApplicationType>
		_cdXml += Chr(13) + Chr(10) +' <SecLenderName/>
		_cdXml += Chr(13) + Chr(10) +' <ApplicationHeader>
		_cdXml += Chr(13) + Chr(10) +' <Active/>
		_cdXml += Chr(13) + Chr(10) +' <App_status/>
		_cdXml += Chr(13) + Chr(10) +' <App_version/>
		_cdXml += Chr(13) + Chr(10) +' <Optout/>
		_cdXml += Chr(13) + Chr(10) +' <SourceLenderID>ai</SourceLenderID>
		_cdXml += Chr(13) + Chr(10) +' <SourceDealerID/>
		_cdXml += Chr(13) + Chr(10) +' <SourceAppID>STSTEST005</SourceAppID>
		_cdXml += Chr(13) + Chr(10) +' <LenderDealerID>1</LenderDealerID>
		_cdXml += Chr(13) + Chr(10) +' <DealerData>
		_cdXml += Chr(13) + Chr(10) +' <AccountNo /> 
		_cdXml += Chr(13) + Chr(10) +' <BankName /> 
		_cdXml += Chr(13) + Chr(10) +' <BankNo /> 
		_cdXml += Chr(13) + Chr(10) +' <BillingSystemId /> 
		_cdXml += Chr(13) + Chr(10) +' <BondExpiryDate /> 
		_cdXml += Chr(13) + Chr(10) +' <BranchManager /> 
		_cdXml += Chr(13) + Chr(10) +' <CapitalAmountVariance>0</CapitalAmountVariance> 
		_cdXml += Chr(13) + Chr(10) +' <CapitalAmountVarianceOver>0</CapitalAmountVarianceOver> 
		_cdXml += Chr(13) + Chr(10) +' <CreditAnalyst /> 
		_cdXml += Chr(13) + Chr(10) +' <SalesRep /> 
		_cdXml += Chr(13) + Chr(10) +' <FundingAnalyst /> 
		_cdXml += Chr(13) + Chr(10) +' <DealerEndDate /> 
		_cdXml += Chr(13) + Chr(10) +' <DealerStartDate /> 
		_cdXml += Chr(13) + Chr(10) +' <Addresses>
		_cdXml += Chr(13) + Chr(10) +' <Address>
		_cdXml += Chr(13) + Chr(10) +' <CivicNumber>22</CivicNumber> 
		_cdXml += Chr(13) + Chr(10) +' <StreetName>34</StreetName> 
		_cdXml += Chr(13) + Chr(10) +' <SuiteNumber /> 
		_cdXml += Chr(13) + Chr(10) +' <StreetDirection />
		_cdXml += Chr(13) + Chr(10) +' <City>Baltimore</City>
		_cdXml += Chr(13) + Chr(10) +' <County />
		_cdXml += Chr(13) + Chr(10) +' <Country>United States</Country> 
		_cdXml += Chr(13) + Chr(10) +' <PostalCode>90123</PostalCode> 
		_cdXml += Chr(13) + Chr(10) +' <State>Florida</State> 
		_cdXml += Chr(13) + Chr(10) +' <HomePhone />
		_cdXml += Chr(13) + Chr(10) +' <BusinessPhone />
		_cdXml += Chr(13) + Chr(10) +' </Address>
		_cdXml += Chr(13) + Chr(10) +' </Addresses>
		_cdXml += Chr(13) + Chr(10) +' <FederalTaxId>13-4141567</FederalTaxId> 
		_cdXml += Chr(13) + Chr(10) +' <LegalName>Dealer</LegalName> 
		_cdXml += Chr(13) + Chr(10) +' <LicenseExpiry /> 
		_cdXml += Chr(13) + Chr(10) +' <LicenseNo /> 
		_cdXml += Chr(13) + Chr(10) +' <RegionId>74</RegionId> 
		_cdXml += Chr(13) + Chr(10) +' <RepStartDate /> 
		_cdXml += Chr(13) + Chr(10) +' <ReserveAmount /> 
		_cdXml += Chr(13) + Chr(10) +' <ReservePercent>10</ReservePercent> 
		_cdXml += Chr(13) + Chr(10) +' <ServiceAreaId>10</ServiceAreaId> 
		_cdXml += Chr(13) + Chr(10) +' <TitleFloat>5</TitleFloat> 
		_cdXml += Chr(13) + Chr(10) +' <TitleFloatCurrent /> 
		_cdXml += Chr(13) + Chr(10) +' <TransitNo /> 
		_cdXml += Chr(13) + Chr(10) +' <Contacts>
		_cdXml += Chr(13) + Chr(10) +' <Contact>
		_cdXml += Chr(13) + Chr(10) +' <Type>1</Type> 
		_cdXml += Chr(13) + Chr(10) +' <Name>Joao da Silva</Name>
		_cdXml += Chr(13) + Chr(10) +' <Title>Gerente</Title>
		_cdXml += Chr(13) + Chr(10) +' <Address>
		_cdXml += Chr(13) + Chr(10) +' <CivicNumber>12</CivicNumber> 
		_cdXml += Chr(13) + Chr(10) +' <StreetName>34</StreetName> 
		_cdXml += Chr(13) + Chr(10) +' <SuiteNumber /> 
		_cdXml += Chr(13) + Chr(10) +' <StreetDirection />
		_cdXml += Chr(13) + Chr(10) +' <City>Baltimore</City>
		_cdXml += Chr(13) + Chr(10) +' <County />
		_cdXml += Chr(13) + Chr(10) +' <Country>United States</Country> 
		_cdXml += Chr(13) + Chr(10) +' <PostalCode>90123</PostalCode> 
		_cdXml += Chr(13) + Chr(10) +' <State>Florida</State> 
		_cdXml += Chr(13) + Chr(10) +' <HomePhone />
		_cdXml += Chr(13) + Chr(10) +' <BusinessPhone />
		_cdXml += Chr(13) + Chr(10) +' </Address>
		_cdXml += Chr(13) + Chr(10) +' </Contact>
		_cdXml += Chr(13) + Chr(10) +' </Contacts>
		_cdXml += Chr(13) + Chr(10) +' </DealerData>
		_cdXml += Chr(13) + Chr(10) +' <DealerState>FL</DealerState>
		_cdXml += Chr(13) + Chr(10) +' <LenderAppID/>
		_cdXml += Chr(13) + Chr(10) +' <RequestDate>2014-01-20 10:37:32.0</RequestDate>
		_cdXml += Chr(13) + Chr(10) +' <CreditType/>
		_cdXml += Chr(13) + Chr(10) +' <App_Type/>
		_cdXml += Chr(13) + Chr(10) +' <Product_Type/>
		_cdXml += Chr(13) + Chr(10) +' <Payment_Call>NO</Payment_Call>
		_cdXml += Chr(13) + Chr(10) +' <CustomerCreditType/>
		_cdXml += Chr(13) + Chr(10) +' <LoanType/>
		_cdXml += Chr(13) + Chr(10) +' <username/>
		_cdXml += Chr(13) + Chr(10) +' <SpotInd/>
		_cdXml += Chr(13) + Chr(10) +' <AppStateType>newapplication</AppStateType>
		_cdXml += Chr(13) + Chr(10) +' <regb/>
		_cdXml += Chr(13) + Chr(10) +' <ComuState/>
		_cdXml += Chr(13) + Chr(10) +' <Swap/>
		_cdXml += Chr(13) + Chr(10) +' <CosignerInt/>
		_cdXml += Chr(13) + Chr(10) +' <ProgramId>124</ProgramId>
		_cdXml += Chr(13) + Chr(10) +' <ProgramName>NO PROGRAM</ProgramName>
		_cdXml += Chr(13) + Chr(10) +' <ProgramProductId>279</ProgramProductId>
		_cdXml += Chr(13) + Chr(10) +' <ProgramProductName>DEFAULT PRODUCT</ProgramProductName>
		_cdXml += Chr(13) + Chr(10) +' <ProgramProductType>ANY</ProgramProductType>
		_cdXml += Chr(13) + Chr(10) +' <ProgramTierId>362</ProgramTierId>
		_cdXml += Chr(13) + Chr(10) +' <ProgramTierName>NO TIER</ProgramTierName>
		_cdXml += Chr(13) + Chr(10) +' <DealerId>11302</DealerId>
		_cdXml += Chr(13) + Chr(10) +' <DealerName>STS Dealer</DealerName>
		_cdXml += Chr(13) + Chr(10) +' <SalesChannelId>38</SalesChannelId>
		_cdXml += Chr(13) + Chr(10) +' <SalesChannelName>DEFAULT CHANNEL</SalesChannelName>
		_cdXml += Chr(13) + Chr(10) +' <SalesChannelEnforceRelationship>true</SalesChannelEnforceRelationship>
		_cdXml += Chr(13) + Chr(10) +' </ApplicationHeader>
		_cdXml += Chr(13) + Chr(10) +' <CreditBureauData>
		_cdXml += Chr(13) + Chr(10) +' <Common>
		_cdXml += Chr(13) + Chr(10) +' <Commercial>
		_cdXml += Chr(13) + Chr(10) +' <Subjects>
		_cdXml += Chr(13) + Chr(10) +' <Subject>
		_cdXml += Chr(13) + Chr(10) +' <Id>0</Id>
		_cdXml += Chr(13) + Chr(10) +' <Type>Primary Applicant</Type>
		_cdXml += Chr(13) + Chr(10) +' <Relation>OTHER</Relation>
		_cdXml += Chr(13) + Chr(10) +' <ApplicantOrder>1</ApplicantOrder>
		_cdXml += Chr(13) + Chr(10) +' <BestMatch>Y</BestMatch>
		_cdXml += Chr(13) + Chr(10) +' <CompanyIdentifier/>
		_cdXml += Chr(13) + Chr(10) +' <CompanyInfo>
		_cdXml += Chr(13) + Chr(10) +' <LegalName>Application</LegalName>
		_cdXml += Chr(13) + Chr(10) +' <OperatingName>ABC</OperatingName>
		_cdXml += Chr(13) + Chr(10) +' <InternalParentEntityId/>
		_cdXml += Chr(13) + Chr(10) +' <InternalEntityId/>
		_cdXml += Chr(13) + Chr(10) +' <ExternalParentEntityId/>
		_cdXml += Chr(13) + Chr(10) +' <ExternalEntityId/>
		_cdXml += Chr(13) + Chr(10) +' <Website>abc.com</Website>
		_cdXml += Chr(13) + Chr(10) +' <Email/>
		_cdXml += Chr(13) + Chr(10) +' <NatureOfBusiness>services</NatureOfBusiness>
		_cdXml += Chr(13) + Chr(10) +' <CompanyTaxName/>
		_cdXml += Chr(13) + Chr(10) +' <OwnerName/>
		_cdXml += Chr(13) + Chr(10) +' <FoundationDate>2012-10-10</FoundationDate>
		_cdXml += Chr(13) + Chr(10) +' </CompanyInfo>
		_cdXml += Chr(13) + Chr(10) +' <Addresses>
		_cdXml += Chr(13) + Chr(10) +' <CommercialAddress>
		_cdXml += Chr(13) + Chr(10) +' <BusinessPhone>7423423437</BusinessPhone>
		_cdXml += Chr(13) + Chr(10) +' <Address>
		_cdXml += Chr(13) + Chr(10) +' <CaseCreditApplicantAddressId>0</CaseCreditApplicantAddressId>
		_cdXml += Chr(13) + Chr(10) +' <AddressType>Work</AddressType>
		_cdXml += Chr(13) + Chr(10) +' <Attention/>
		_cdXml += Chr(13) + Chr(10) +' <Solicit/>
		_cdXml += Chr(13) + Chr(10) +' <SuiteNumber>201</SuiteNumber>
		_cdXml += Chr(13) + Chr(10) +' <CivicNumber>23</CivicNumber>
		_cdXml += Chr(13) + Chr(10) +' <StreetName>kingkong</StreetName>
		_cdXml += Chr(13) + Chr(10) +' <StreetType/>
		_cdXml += Chr(13) + Chr(10) +' <StreetDirection>north</StreetDirection>
		_cdXml += Chr(13) + Chr(10) +' <POBox/>
		_cdXml += Chr(13) + Chr(10) +' <CivicAddress/>
		_cdXml += Chr(13) + Chr(10) +' <RRNo/>
		_cdXml += Chr(13) + Chr(10) +' <LotNo/>
		_cdXml += Chr(13) + Chr(10) +' <Concession/>
		_cdXml += Chr(13) + Chr(10) +' <City>toronto</City>
		_cdXml += Chr(13) + Chr(10) +' <County>florida</County>
		_cdXml += Chr(13) + Chr(10) +' <ProvinceCode>AL</ProvinceCode>
		_cdXml += Chr(13) + Chr(10) +' <PostalCode>34432-4234</PostalCode>
		_cdXml += Chr(13) + Chr(10) +' <CountryCode>United States</CountryCode>
		_cdXml += Chr(13) + Chr(10) +' <LengthOfResidenceYears>4</LengthOfResidenceYears>
		_cdXml += Chr(13) + Chr(10) +' <LengthOfResidenceMonths>3</LengthOfResidenceMonths>
		_cdXml += Chr(13) + Chr(10) +' <LengthOfResidence>51</LengthOfResidence>
		_cdXml += Chr(13) + Chr(10) +' <ResidentialStatus>Rent</ResidentialStatus>
		_cdXml += Chr(13) + Chr(10) +' <MonthlyPayment>0.0</MonthlyPayment>
		_cdXml += Chr(13) + Chr(10) +' <LandlordName/>
		_cdXml += Chr(13) + Chr(10) +' <LandlordAddress/>
		_cdXml += Chr(13) + Chr(10) +' <MortgageHolder/>
		_cdXml += Chr(13) + Chr(10) +' <TypeOfHousing/>
		_cdXml += Chr(13) + Chr(10) +' <Status/>
		_cdXml += Chr(13) + Chr(10) +' <Complement/>
		_cdXml += Chr(13) + Chr(10) +' <Neighborhood/>
		_cdXml += Chr(13) + Chr(10) +' <SocialClass/>
		_cdXml += Chr(13) + Chr(10) +' <PropertyType/>
		_cdXml += Chr(13) + Chr(10) +' <AddressCategory>STREET</AddressCategory>
		_cdXml += Chr(13) + Chr(10) +' </Address>
		_cdXml += Chr(13) + Chr(10) +' <PropertyManagementOperator>
		_cdXml += Chr(13) + Chr(10) +' <FirstName>Regression</FirstName>
		_cdXml += Chr(13) + Chr(10) +' <LastName>Bharathi</LastName>
		_cdXml += Chr(13) + Chr(10) +' <Address>
		_cdXml += Chr(13) + Chr(10) +' <CaseCreditApplicantAddressId>0</CaseCreditApplicantAddressId>
		_cdXml += Chr(13) + Chr(10) +' <AddressType>Work</AddressType>
		_cdXml += Chr(13) + Chr(10) +' <Attention/>
		_cdXml += Chr(13) + Chr(10) +' <Solicit/>
		_cdXml += Chr(13) + Chr(10) +' <SuiteNumber/>
		_cdXml += Chr(13) + Chr(10) +' <CivicNumber/>
		_cdXml += Chr(13) + Chr(10) +' <StreetName/>
		_cdXml += Chr(13) + Chr(10) +' <StreetType/>
		_cdXml += Chr(13) + Chr(10) +' <StreetDirection/>
		_cdXml += Chr(13) + Chr(10) +' <POBox/>
		_cdXml += Chr(13) + Chr(10) +' <CivicAddress/>
		_cdXml += Chr(13) + Chr(10) +' <RRNo/>
		_cdXml += Chr(13) + Chr(10) +' <LotNo/>
		_cdXml += Chr(13) + Chr(10) +' <Concession/>
		_cdXml += Chr(13) + Chr(10) +' <City/>
		_cdXml += Chr(13) + Chr(10) +' <County/>
		_cdXml += Chr(13) + Chr(10) +' <ProvinceCode>AB</ProvinceCode>
		_cdXml += Chr(13) + Chr(10) +' <PostalCode/>
		_cdXml += Chr(13) + Chr(10) +' <CountryCode>Canada</CountryCode>
		_cdXml += Chr(13) + Chr(10) +' <LengthOfResidenceYears>0</LengthOfResidenceYears>
		_cdXml += Chr(13) + Chr(10) +' <LengthOfResidenceMonths>0</LengthOfResidenceMonths>
		_cdXml += Chr(13) + Chr(10) +' <LandlordName/>
		_cdXml += Chr(13) + Chr(10) +' <LandlordAddress/>
		_cdXml += Chr(13) + Chr(10) +' <MortgageHolder/>
		_cdXml += Chr(13) + Chr(10) +' <TypeOfHousing/>
		_cdXml += Chr(13) + Chr(10) +' <Status/>
		_cdXml += Chr(13) + Chr(10) +' <Type>Aeroporto</Type>
		_cdXml += Chr(13) + Chr(10) +' <Complement/>
		_cdXml += Chr(13) + Chr(10) +' <Neighborhood/>
		_cdXml += Chr(13) + Chr(10) +' <SocialClass/>
		_cdXml += Chr(13) + Chr(10) +' <PropertyType/>
		_cdXml += Chr(13) + Chr(10) +' <AddressCategory/>
		_cdXml += Chr(13) + Chr(10) +' </Address>
		_cdXml += Chr(13) + Chr(10) +' </PropertyManagementOperator>
		_cdXml += Chr(13) + Chr(10) +' </CommercialAddress>
		_cdXml += Chr(13) + Chr(10) +' </Addresses>
		_cdXml += Chr(13) + Chr(10) +' <CompanyStructure>
		_cdXml += Chr(13) + Chr(10) +' <BusinessStructure>Propertiership</BusinessStructure>
		_cdXml += Chr(13) + Chr(10) +' <DurationInBusinessYears>2</DurationInBusinessYears>
		_cdXml += Chr(13) + Chr(10) +' <DurationInBusinessMonths>1</DurationInBusinessMonths>
		_cdXml += Chr(13) + Chr(10) +' <Industry/>
		_cdXml += Chr(13) + Chr(10) +' <BusinessClass/>
		_cdXml += Chr(13) + Chr(10) +' <SIC/>
		_cdXml += Chr(13) + Chr(10) +' <SIC_ID/>
		_cdXml += Chr(13) + Chr(10) +' <TAX_ID/>
		_cdXml += Chr(13) + Chr(10) +' <FederalTaxId>006777845000174</FederalTaxId>
		_cdXml += Chr(13) + Chr(10) +' <RegId/>
		_cdXml += Chr(13) + Chr(10) +' <Jurisdiction/>
		_cdXml += Chr(13) + Chr(10) +' <BusinessPeaks/>
		//_cdXml += Chr(13) + Chr(10) +' <StatementCreator>CFA</StatementCreator>
		_cdXml += Chr(13) + Chr(10) +' <StatementCreator>Noticed</StatementCreator>
		_cdXml += Chr(13) + Chr(10) +' <DateOfIncorporation>2012-10-10</DateOfIncorporation>
		_cdXml += Chr(13) + Chr(10) +' <FiscalYearEnd>2015-10-10</FiscalYearEnd>
		_cdXml += Chr(13) + Chr(10) +' <BusinessStartDate>2012-10-10</BusinessStartDate>
		_cdXml += Chr(13) + Chr(10) +' <NoOfEmployees>40</NoOfEmployees>
		_cdXml += Chr(13) + Chr(10) +' <Unionized>false</Unionized>
		_cdXml += Chr(13) + Chr(10) +' <CompanyType/>
		_cdXml += Chr(13) + Chr(10) +' </CompanyStructure>
		_cdXml += Chr(13) + Chr(10) +' <PrincipalShareholderInfoList>
		_cdXml += Chr(13) + Chr(10) +' <PrincipalShareholderInfo>
		_cdXml += Chr(13) + Chr(10) +' <Type/>
		_cdXml += Chr(13) + Chr(10) +' <Position/>
		_cdXml += Chr(13) + Chr(10) +' <Title/>
		_cdXml += Chr(13) + Chr(10) +' <FirstName/>
		_cdXml += Chr(13) + Chr(10) +' <MiddleName/>
		_cdXml += Chr(13) + Chr(10) +' <LastName/>
		_cdXml += Chr(13) + Chr(10) +' <Suffix>JR</Suffix>
		_cdXml += Chr(13) + Chr(10) +' <PercentHeld>0.0</PercentHeld>
		_cdXml += Chr(13) + Chr(10) +' <PhoneNumber/>
		_cdXml += Chr(13) + Chr(10) +' <DateOfBirth>1987-09-09</DateOfBirth>
		_cdXml += Chr(13) + Chr(10) +' <SocialSecurityNumber/>
		_cdXml += Chr(13) + Chr(10) +' <IdType/>
		_cdXml += Chr(13) + Chr(10) +' <IdNumber/>
		_cdXml += Chr(13) + Chr(10) +' <ContactName/>
		_cdXml += Chr(13) + Chr(10) +' <YearsOfOwnership>2</YearsOfOwnership>
		_cdXml += Chr(13) + Chr(10) +' <MonthsOfOwnership>2</MonthsOfOwnership>
		_cdXml += Chr(13) + Chr(10) +' <CompanyPartnershipType/>
		_cdXml += Chr(13) + Chr(10) +' </PrincipalShareholderInfo>
		_cdXml += Chr(13) + Chr(10) +' </PrincipalShareholderInfoList>
		_cdXml += Chr(13) + Chr(10) +' <CommercialContactInfoList>
		_cdXml += Chr(13) + Chr(10) +' <ComercialContactInfo>
		_cdXml += Chr(13) + Chr(10) +' <AgentType>Business Manager</AgentType>
		_cdXml += Chr(13) + Chr(10) +' <ContactTitle/>
		_cdXml += Chr(13) + Chr(10) +' <Salutation>mr</Salutation>
		_cdXml += Chr(13) + Chr(10) +' <FirstName>test</FirstName>
		_cdXml += Chr(13) + Chr(10) +' <LastName>kong</LastName>
		_cdXml += Chr(13) + Chr(10) +' <MiddleName>kng</MiddleName>
		_cdXml += Chr(13) + Chr(10) +' <CellPhone/>
		_cdXml += Chr(13) + Chr(10) +' <WorkPhone/>
		_cdXml += Chr(13) + Chr(10) +' <Email/>
		_cdXml += Chr(13) + Chr(10) +' <Fax/>
		_cdXml += Chr(13) + Chr(10) +' </ComercialContactInfo>
		_cdXml += Chr(13) + Chr(10) +' </CommercialContactInfoList>
		_cdXml += Chr(13) + Chr(10) +' <ReferenceList/>
		_cdXml += Chr(13) + Chr(10) +' <TopCompetitorCustomerInfoList/>
		_cdXml += Chr(13) + Chr(10) +' <RelatedCompanyInfoList/>
		_cdXml += Chr(13) + Chr(10) +' <BankInfo>
		_cdXml += Chr(13) + Chr(10) +' <BankName/>
		_cdXml += Chr(13) + Chr(10) +' <BankNumber/>
		_cdXml += Chr(13) + Chr(10) +' <BranchNumber/>
		_cdXml += Chr(13) + Chr(10) +' <AccountNo/>
		_cdXml += Chr(13) + Chr(10) +' <TransitNo/>
		_cdXml += Chr(13) + Chr(10) +' <AccountHolderFirstName/>
		_cdXml += Chr(13) + Chr(10) +' <AccountHolderLastName/>
		_cdXml += Chr(13) + Chr(10) +' <AccountBalance>0.0</AccountBalance>
		_cdXml += Chr(13) + Chr(10) +' <DurationYears>3</DurationYears>
		_cdXml += Chr(13) + Chr(10) +' <DurationMonths>2</DurationMonths>
		_cdXml += Chr(13) + Chr(10) +' <Country/>
		_cdXml += Chr(13) + Chr(10) +' <Province/>
		_cdXml += Chr(13) + Chr(10) +' <ContactPhoneNumber/>
		_cdXml += Chr(13) + Chr(10) +' <ContactFaxNumber/>
		_cdXml += Chr(13) + Chr(10) +' <ContactEmail/>
		_cdXml += Chr(13) + Chr(10) +' <BankReference/>
		_cdXml += Chr(13) + Chr(10) +' </BankInfo>
		_cdXml += Chr(13) + Chr(10) +' <FinancialDisclosureList/>
		_cdXml += Chr(13) + Chr(10) +' </Subject>
		_cdXml += Chr(13) + Chr(10) +' </Subjects>
		_cdXml += Chr(13) + Chr(10) +' </Commercial>
		_cdXml += Chr(13) + Chr(10) +' </Common>
		_cdXml += Chr(13) + Chr(10) +' <EquifaxCommercial>
		_cdXml += Chr(13) + Chr(10) +' <Customer>
		_cdXml += Chr(13) + Chr(10) +' <SecurityCode/>
		_cdXml += Chr(13) + Chr(10) +' <CustomerNumber/>
		_cdXml += Chr(13) + Chr(10) +' <CustomerCode/>
		_cdXml += Chr(13) + Chr(10) +' </Customer>
		_cdXml += Chr(13) + Chr(10) +' </EquifaxCommercial>
		_cdXml += Chr(13) + Chr(10) +' <DandB>
		_cdXml += Chr(13) + Chr(10) +' <DandBID/>
		_cdXml += Chr(13) + Chr(10) +' <DandBPassWord/>
		_cdXml += Chr(13) + Chr(10) +' <DandBToolKtid/>
		_cdXml += Chr(13) + Chr(10) +' <DandBToolKtPwd/>
		_cdXml += Chr(13) + Chr(10) +' </DandB>
		_cdXml += Chr(13) + Chr(10) +' <FullRefresh/>
		_cdXml += Chr(13) + Chr(10) +' <PreCreditCheck>N</PreCreditCheck>
		_cdXml += Chr(13) + Chr(10) +' <PostCreditCheck>N</PostCreditCheck>
		_cdXml += Chr(13) + Chr(10) +' <PullNewCBReport>NO</PullNewCBReport>
		_cdXml += Chr(13) + Chr(10) +' <BypassInternalDataSources>N</BypassInternalDataSources>
		_cdXml += Chr(13) + Chr(10) +' <CBDataSourceID/>
		_cdXml += Chr(13) + Chr(10) +' <ForceManualReview>N</ForceManualReview>
		_cdXml += Chr(13) + Chr(10) +' <OverrideTierId>NO</OverrideTierId>
		_cdXml += Chr(13) + Chr(10) +' </CreditBureauData>
		_cdXml += Chr(13) + Chr(10) +' <AdditionalIncomes/>
		_cdXml += Chr(13) + Chr(10) +' <AssetLiabs/>
		_cdXml += Chr(13) + Chr(10) +' <Asset>
		_cdXml += Chr(13) + Chr(10) +' <TypeId/>
		_cdXml += Chr(13) + Chr(10) +' <Auto>
		_cdXml += Chr(13) + Chr(10) +' <Type/>
		_cdXml += Chr(13) + Chr(10) +' <Trade>false</Trade>
		_cdXml += Chr(13) + Chr(10) +' <CertifiedUsed/>
		_cdXml += Chr(13) + Chr(10) +' <StockNo/>
		_cdXml += Chr(13) + Chr(10) +' <VIN/>
		_cdXml += Chr(13) + Chr(10) +' <Condition/>
		_cdXml += Chr(13) + Chr(10) +' <RateSheetCondition/>
		_cdXml += Chr(13) + Chr(10) +' <Make/>
		_cdXml += Chr(13) + Chr(10) +' <Model/>
		_cdXml += Chr(13) + Chr(10) +' <Series/>
		_cdXml += Chr(13) + Chr(10) +' <BodyStyle/>
		_cdXml += Chr(13) + Chr(10) +' <Trim/>
		_cdXml += Chr(13) + Chr(10) +' <Category/>
		_cdXml += Chr(13) + Chr(10) +' <PriceType/>
		_cdXml += Chr(13) + Chr(10) +' <ZipCode/>
		_cdXml += Chr(13) + Chr(10) +' <Color/>
		_cdXml += Chr(13) + Chr(10) +' <Mileage/>
		_cdXml += Chr(13) + Chr(10) +' <Includes/>
		_cdXml += Chr(13) + Chr(10) +' <ChromeStyleId/>
		_cdXml += Chr(13) + Chr(10) +' <ChromeMake/>
		_cdXml += Chr(13) + Chr(10) +' <ChromeModel/>
		_cdXml += Chr(13) + Chr(10) +' <ChromeTrim/>
		_cdXml += Chr(13) + Chr(10) +' <OtherMake/>
		_cdXml += Chr(13) + Chr(10) +' <OtherModel/>
		_cdXml += Chr(13) + Chr(10) +' <OtherTrim/>
		_cdXml += Chr(13) + Chr(10) +' <Options/>
		_cdXml += Chr(13) + Chr(10) +' <OtherOptions/>
		_cdXml += Chr(13) + Chr(10) +' <VehicleSourceDesc/>
		_cdXml += Chr(13) + Chr(10) +' <BookoutOptions/>
		_cdXml += Chr(13) + Chr(10) +' <ChromeOptions/>
		_cdXml += Chr(13) + Chr(10) +' <ChromeOptionCode/>
		_cdXml += Chr(13) + Chr(10) +' <ChromeOptionDesc/>
		_cdXml += Chr(13) + Chr(10) +' <UVC/>
		_cdXml += Chr(13) + Chr(10) +' <VINUVC/>
		_cdXml += Chr(13) + Chr(10) +' <LastReportedOdometerDate/>
		_cdXml += Chr(13) + Chr(10) +' <LastReportedOdometer/>
		_cdXml += Chr(13) + Chr(10) +' <NoBrandedTitle/>
		_cdXml += Chr(13) + Chr(10) +' <NoSalvage/>
		_cdXml += Chr(13) + Chr(10) +' <NoFrameDamage/>
		_cdXml += Chr(13) + Chr(10) +' <IntendedUse/>
		_cdXml += Chr(13) + Chr(10) +' </Auto>
		_cdXml += Chr(13) + Chr(10) +' <RVSelection>
		_cdXml += Chr(13) + Chr(10) +' <Condition/>
		_cdXml += Chr(13) + Chr(10) +' <Year/>
		_cdXml += Chr(13) + Chr(10) +' <Make/>
		_cdXml += Chr(13) + Chr(10) +' <Model/>
		_cdXml += Chr(13) + Chr(10) +' <SerialNumber/>
		_cdXml += Chr(13) + Chr(10) +' <Type/>
		_cdXml += Chr(13) + Chr(10) +' <Size/>
		_cdXml += Chr(13) + Chr(10) +' <EngineSize/>
		_cdXml += Chr(13) + Chr(10) +' <CSAANSINumber/>
		_cdXml += Chr(13) + Chr(10) +' </RVSelection>
		_cdXml += Chr(13) + Chr(10) +' <MarineSelection>
		_cdXml += Chr(13) + Chr(10) +' <Condition/>
		_cdXml += Chr(13) + Chr(10) +' <Year/>
		_cdXml += Chr(13) + Chr(10) +' <Make/>
		_cdXml += Chr(13) + Chr(10) +' <Model/>
		_cdXml += Chr(13) + Chr(10) +' <SerialNumber/>
		_cdXml += Chr(13) + Chr(10) +' <Type/>
		_cdXml += Chr(13) + Chr(10) +' <Size/>
		_cdXml += Chr(13) + Chr(10) +' <BoatDeck/>
		_cdXml += Chr(13) + Chr(10) +' <BoatHull/>
		_cdXml += Chr(13) + Chr(10) +' <Interior/>
		_cdXml += Chr(13) + Chr(10) +' <Tonnage/>
		_cdXml += Chr(13) + Chr(10) +' <TrailerSelection>
		_cdXml += Chr(13) + Chr(10) +' <TrailerCondition/>
		_cdXml += Chr(13) + Chr(10) +' <TrailerYear/>
		_cdXml += Chr(13) + Chr(10) +' <TrailerMake/>
		_cdXml += Chr(13) + Chr(10) +' <TrailerModel/>
		_cdXml += Chr(13) + Chr(10) +' <TrailerSize/>
		_cdXml += Chr(13) + Chr(10) +' <TrailerSerialNumber/>
		_cdXml += Chr(13) + Chr(10) +' </TrailerSelection>
		_cdXml += Chr(13) + Chr(10) +' </MarineSelection>
		_cdXml += Chr(13) + Chr(10) +' <LeisureSelection>
		_cdXml += Chr(13) + Chr(10) +' <Condition/>
		_cdXml += Chr(13) + Chr(10) +' <Year/>
		_cdXml += Chr(13) + Chr(10) +' <Make/>
		_cdXml += Chr(13) + Chr(10) +' <Model/>
		_cdXml += Chr(13) + Chr(10) +' <SerialNumber/>
		_cdXml += Chr(13) + Chr(10) +' <Type/>
		_cdXml += Chr(13) + Chr(10) +' <LengthSize/>
		_cdXml += Chr(13) + Chr(10) +' <EngineSize/>
		_cdXml += Chr(13) + Chr(10) +' <TrailerSelection>
		_cdXml += Chr(13) + Chr(10) +' <TrailerCondition/>
		_cdXml += Chr(13) + Chr(10) +' <TrailerYear/>
		_cdXml += Chr(13) + Chr(10) +' <TrailerMake/>
		_cdXml += Chr(13) + Chr(10) +' <TrailerModel/>
		_cdXml += Chr(13) + Chr(10) +' <TrailerSize/>
		_cdXml += Chr(13) + Chr(10) +' <TrailerSerialNumber/>
		_cdXml += Chr(13) + Chr(10) +' </TrailerSelection>
		_cdXml += Chr(13) + Chr(10) +' </LeisureSelection>
		_cdXml += Chr(13) + Chr(10) +' </Asset>
		_cdXml += Chr(13) + Chr(10) +' <Valuations/>
		_cdXml += Chr(13) + Chr(10) +' <Valuation_Options/>
		_cdXml += Chr(13) + Chr(10) +' <TradeIns/>
		_cdXml += Chr(13) + Chr(10) +' <LoanStructure>
		_cdXml += Chr(13) + Chr(10) +' <StateExemptReason/>
		_cdXml += Chr(13) + Chr(10) +' <CountyExemptReason/>
		_cdXml += Chr(13) + Chr(10) +' <CityExemptReason/>
		_cdXml += Chr(13) + Chr(10) +' <LoanType/>
		_cdXml += Chr(13) + Chr(10) +' <LoanSubType/>
		_cdXml += Chr(13) + Chr(10) +' </LoanStructure>
		_cdXml += Chr(13) + Chr(10) +' <Telco/>
		_cdXml += Chr(13) + Chr(10) +' <FinanceData>
		_cdXml += Chr(13) + Chr(10) +' <Term>36</Term>
		_cdXml += Chr(13) + Chr(10) +' <UsedCarBook/>
		_cdXml += Chr(13) + Chr(10) +' <WholesaleSource/>
		_cdXml += Chr(13) + Chr(10) +' <RetailSource/>
		_cdXml += Chr(13) + Chr(10) +' <InterestRate>12.0</InterestRate>
		_cdXml += Chr(13) + Chr(10) +' <Frequency>Monthly</Frequency>
		_cdXml += Chr(13) + Chr(10) +' <Program/>
		_cdXml += Chr(13) + Chr(10) +' <RequestedAmount>40000.0</RequestedAmount>
		_cdXml += Chr(13) + Chr(10) +' <AdditionalFinanceDetails/>
		_cdXml += Chr(13) + Chr(10) +' <EffectiveDateOfLoan>2014-10-10</EffectiveDateOfLoan>
		_cdXml += Chr(13) + Chr(10) +' <DateOfFirstPayment>2014-10-10</DateOfFirstPayment>
		_cdXml += Chr(13) + Chr(10) +' <CreditCardNumber>373392135921013</CreditCardNumber>
		_cdXml += Chr(13) + Chr(10) +' <CreditCardLimit>500.0</CreditCardLimit>
		_cdXml += Chr(13) + Chr(10) +' <RiskRating>abcd</RiskRating>
		_cdXml += Chr(13) + Chr(10) +' <HouseholdIncome>4000.0</HouseholdIncome>
		_cdXml += Chr(13) + Chr(10) +' <ProfittoDealerCalculation>
		_cdXml += Chr(13) + Chr(10) +' <CashFromCustomer>0</CashFromCustomer>
		_cdXml += Chr(13) + Chr(10) +' <AdvanceFromLender>0</AdvanceFromLender>
		_cdXml += Chr(13) + Chr(10) +' <WarrantyCost>0</WarrantyCost>
		_cdXml += Chr(13) + Chr(10) +' <Taxes>0</Taxes>
		_cdXml += Chr(13) + Chr(10) +' <LicenseFee>0</LicenseFee>
		_cdXml += Chr(13) + Chr(10) +' <NetCashReceived>0</NetCashReceived>
		_cdXml += Chr(13) + Chr(10) +' <CostOfVehicle>0</CostOfVehicle>
		_cdXml += Chr(13) + Chr(10) +' <UpfrontProfit>0</UpfrontProfit>
		_cdXml += Chr(13) + Chr(10) +' <TotalRepaymentAmount>0</TotalRepaymentAmount>
		_cdXml += Chr(13) + Chr(10) +' <LenderReserve>0</LenderReserve>
		_cdXml += Chr(13) + Chr(10) +' <AmountEligibleParticipation>0</AmountEligibleParticipation>
		_cdXml += Chr(13) + Chr(10) +' <DealeParticipationRate>0</DealeParticipationRate>
		_cdXml += Chr(13) + Chr(10) +' <TotalPotentialParticipation>0</TotalPotentialParticipation>
		_cdXml += Chr(13) + Chr(10) +' </ProfittoDealerCalculation>
		_cdXml += Chr(13) + Chr(10) +' </FinanceData>
		_cdXml += Chr(13) + Chr(10) +' <Comments/>
		_cdXml += Chr(13) + Chr(10) +' <DTNComments/>
		_cdXml += Chr(13) + Chr(10) +' <CustomFields/>
		_cdXml += Chr(13) + Chr(10) +' </UDecideRequest>
		_cdXml += Chr(13) + Chr(10) +' ]]>

	EndIf

Return _cdXml


user function getPEMInfo()
	Local cFile := "\serasa\certs\serasa.pem"
	Local aRet := {}

	aRet := PEMInfo( cFile )
	varinfo( "PEM", aRet )
Return


Static Function getConteudo(cTbl,cCpo)
	_xxRet := ""
	If (cTbl)->(FieldPos(cCpo)) > 0
		_xxRet := (cTbl)->&(cCpo)
		If ValType(_xxRet) == "N"
			_xxRet := Str(_xxRet)
		ElseIf ValType(_xxRet) == "D"
			_xxRet := DTOS(_xxRet)
		EndIf
	Else
		Alert('Arquivo Com Erro Na Estrutura , CAMPO:' + cCpo + " Nao Encontrado")    
	EndIf
Return _xxRet


User Function _DOPRSEA()

	lAdjustToLegacy := .F. 
	lDisableSetup  := .T.
    lTeste := .F.
    if lTeste 
    	xdValues := {}
    EndIf
	//Private oPrinter := TMSPrinter():New("ORCAMENTO.REL")//, IMP_PDF, lAdjustToLegacy, , lDisableSetup)
	
	oPrinter := FWMSPrinter():New("SERASA", IMP_PDF,.F.) //, lAdjustToLegacy, "c:\diego\", lDisableSetup)	

	PRIVATE oFont10N   := TFontEx():New(oPrinter,"Times New Roman",08,08,.T.,.T.,.F.)// 1
	PRIVATE oFont07N   := TFontEx():New(oPrinter,"Times New Roman",06,06,.T.,.T.,.F.)// 2
	PRIVATE oFont07    := TFontEx():New(oPrinter,"Times New Roman",06,06,.F.,.T.,.F.)// 3
	PRIVATE oFont08    := TFontEx():New(oPrinter,"Times New Roman",07,07,.F.,.T.,.F.)// 4
	PRIVATE oFont08N   := TFontEx():New(oPrinter,"Times New Roman",06,06,.T.,.T.,.F.)// 5
	PRIVATE oFont09N   := TFontEx():New(oPrinter,"Times New Roman",08,08,.T.,.T.,.F.)// 6
	PRIVATE oFont09    := TFontEx():New(oPrinter,"Times New Roman",08,08,.F.,.T.,.F.)// 7
	PRIVATE oFont10    := TFontEx():New(oPrinter,"Times New Roman",09,09,.F.,.T.,.F.)// 8
	PRIVATE oFont11    := TFontEx():New(oPrinter,"Times New Roman",10,10,.F.,.T.,.F.)// 9
	PRIVATE oFont12    := TFontEx():New(oPrinter,"Times New Roman",11,11,.F.,.T.,.F.)// 10
	PRIVATE oFont11N   := TFontEx():New(oPrinter,"Times New Roman",10,10,.T.,.T.,.F.)// 11
	PRIVATE oFont18N   := TFontEx():New(oPrinter,"Times New Roman",17,17,.T.,.T.,.F.)// 12 
	PRIVATE OFONT12N   := TFontEx():New(oPrinter,"Times New Roman",11,11,.T.,.T.,.F.)// 12
	PRIVATE OFONT14N   := TFontEx():New(oPrinter,"Times New Roman",13,13,.T.,.T.,.F.)// 12
	PRIVATE OFONT22N   := TFontEx():New(oPrinter,"Times New Roman",21,21,.T.,.T.,.F.)// 12 
       
    //oPrinter:cPathPDF := "C:\diego\"
    //oPrinter:cPathPrint := "C:\diego\"
	//oPrinter:Setup()
    //oPrinter:SetResolution(78) //Tamanho estipulado para a Danfe
    oPrinter:SetPortrait()
    oPrinter:SetPaperSize(DMPAPER_A4)
    oPrinter:SetMargin(60,60,60,60)
    
	Private PixelX := oPrinter:nLogPixelX()
	Private PixelY := oPrinter:nLogPixelY()

	Private nHPage := oprinter:nHorzRes()
	nHPage := 550   
	//nHPage *= (300/PixelX)
	//nHPage -= 30 
	Private nVPage := oprinter:nVertRes()
	nVPage := 765
	//nVPage *= (300/PixelY)
	//nVPage -= 80        

	Private cObs1:= Space(60)
	Private cObs2:= Space(60)
	Private cOrcamento := Space(06)  
	Private nPesoTotal := 0
	Private _ndTotDesc := 0
	//Private cPerg := Padr("SERADA",Len(SX1->X1_GRUPO))
	nSpace := 050
	nLine  := 040
	nCol1  := 016

	//oPrinter:Box( nLine,nCol1, nLine + nSpace * 2 , 2000 ,10)
	//nLine += 20
	oPrinter:StartPage()
	oPrinter:Say( nLine + 05, nCol1 + 250, "SERASA S.A. - Relato | Consulta CNPJ" , OFONT11N:oFont,,CLR_GRAY)//, 1400, CLR_HRED)
	oPrinter:Say( nLine + 25, nCol1 + 250, "RELATO" , OFONT18N:oFont,,CLR_BLUE)//, 1400, CLR_HRED)	
	oPrinter:SayBitmap( nLine , nCol1, "serasa.png", 200, 35)
	
	nLine += 45
	//oPrinter:Box( nLine + 10 ,nCol1, nLine + 10 + nSpace * 2 , 2000)
	oPrinter:Box( nLine - 10, nCol1 - 06, nLine+90 - 15, nHPage, "-6")

	//oPrinter:Say(nLine,nCol1,SA1->A1_NOME, OFONT22N:oFont ,)///*xCor*/,,3)
	
	//oFont1 := TFont():New( "Courier New", , -18, .T.)
	//oPrinter:SetFont(oFont1)
	//oPrinter:Say( nLine, nCol1, SA1->A1_NOME , oFont1)//, 1400, CLR_HRED)
	oPrinter:Say( nLine + 05, nCol1, SA1->A1_NOME , OFONT22N:oFont,,CLR_GRAY)//, 1400, CLR_HRED)
	
	nLine += 15
	oPrinter:Say(nLine,nCol1,"CNPJ: " + Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"), OFONT12N:oFont,,)///*xCor*/,,3)
	oPrinter:Say(nLine,nCol1 + 400,DTOC(Date()) + "  " + Time(), OFONT14N:oFont,)///*xCor*/,,3)

	_xdPos := Ascan(xdValues,{ |x| Upper(x[01])=="RISKSCORE" })
	If _xdPos > 0
	   _xdRiskScore := xdValues[_xdPos][02]
	Else
		_xdPos := Ascan(xdValues,{ |x| Upper(x[01])=="Detail_Comm1_306" })
		If _xdPos > 0
		   _xdLim := at("|",xdValues[_xdPos][02])
		   _xdRiskScore := Substr(xdValues[_xdPos][02],_xdLim+1)
		Else
		  _xdRiskScore := "ERRO" 		   
		EndIf
	EndIf
	
	If _xdRiskScore == "-1.0"
	   _xdRiskScore := " DEFAULT "
	EndIf
	
	_xdPos := Ascan(xdValues,{ |x| x[01]=="Detail_Comm1_306" })
	If _xdPos > 0
	   _xdLim := at("|",xdValues[_xdPos][02])
	   ndFaturamento := substr(xdValues[_xdPos][02],_xdLim+1)
	   ndFaturamento := Val(ndFaturamento)
	   //If(ValType(xdValues[_xdPos][02]) == "C", Val(xdValues[_xdPos][02]), xdValues[_xdPos][02] )
	Else
	    ndFaturamento := 99999 
	EndIf
    ndLimite := 99999999
    
    nLine += 20
    oPrinter:Say(nLine,nCol1 + 001,"PONTUAÇÃO PRINAD: " , OFONT12N:oFont,,CLR_BLUE)///*xCor*/,,3)
    oPrinter:Say(nLine,nCol1 + 100,_xdRiskScore  	    , OFONT12N:oFont,,CLR_BLUE)///*xCor*/,,3)
    //oPrinter:Say(nLine,nCol1,"Sugestão de limite: " , OFONT12N:oFont,,CLR_BLUE)///*xCor*/,,3)
    //oPrinter:Say(nLine,nCol1 + 100, transform(ndLimite,"@E 999,999,999,999.99") , OFONT14N:oFont,,CLR_GRAY)
    
    oPrinter:Say(nLine,nCol1 + 200,"Faturamento Presumido: " , OFONT12N:oFont,,CLR_BLUE)///*xCor*/,,3)
    oPrinter:Say(nLine,nCol1 + 300, transform(ndFaturamento,"@E 999,999,999,999,999.99") , OFONT14N:oFont,,CLR_GRAY)
    
    nLine += 25
    _ldSocios := .F.
    If _ldSocios
       _xdSocios := {}
       
       //aAdd(_xdSocios,{"987.431.802-30","Diego Rafael de Oliveira Ramos","01/01/2000","Brasil",100,100})
       //If Len()
       For _xdK := 01 To Len(_xdSocios)
         If _xdK  == 01         
         	oPrinter:Say(nLine,nCol1 + 480,"% Capital " , OFONT10N:oFont,,)///*xCor*/,,3)            
            nLine+= 15
            oPrinter:Say(nLine,nCol1 + 005,"CPF/CNPJ " , OFONT10N:oFont,,)///*xCor*/,,3)
            oPrinter:Say(nLine,nCol1 + 080,"Nome"      , OFONT10N:oFont,,)///*xCor*/,,3)
            oPrinter:Say(nLine,nCol1 + 285,"Entrada"   , OFONT10N:oFont,,)///*xCor*/,,3)
            oPrinter:Say(nLine,nCol1 + 365,"Nacionalidade" , OFONT10N:oFont,,)///*xCor*/,,3)            
            oPrinter:Say(nLine,nCol1 + 445,"Votante " , OFONT10N:oFont,,)///*xCor*/,,3)
            oPrinter:Say(nLine,nCol1 + 525,"Total  "  , OFONT10N:oFont,,)///*xCor*/,,3)
            nLine+= 15
         EndIf
           oPrinter:Say(nLine,nCol1 + 005,_xdSocios[_xdK][01] , OFONT10N:oFont,,CLR_BLUE)///*xCor*/,,3)
           oPrinter:Say(nLine,nCol1 + 080,_xdSocios[_xdK][02] , OFONT10N:oFont,,CLR_BLUE)///*xCor*/,,3)
           oPrinter:Say(nLine,nCol1 + 285,_xdSocios[_xdK][03] , OFONT10N:oFont,,CLR_BLUE)///*xCor*/,,3)
           oPrinter:Say(nLine,nCol1 + 365,_xdSocios[_xdK][04] , OFONT10N:oFont,,CLR_BLUE)///*xCor*/,,3)            
           oPrinter:Say(nLine,nCol1 + 445,Transform( _xdSocios[_xdK][05],"@E 999.99 ") , OFONT10N:oFont,,CLR_BLUE)///*xCor*/,,3)
           oPrinter:Say(nLine,nCol1 + 525,Transform( _xdSocios[_xdK][06],"@E 999.99 ") , OFONT10N:oFont,,CLR_BLUE)///*xCor*/,,3)
           nLine+= 15
       Next
    Else
       nLine+= 45
    EndIf
    nLine += 15
    
    _xdPos := Ascan(xdValues,{ |x| x[01]=="Detail_Comm1_311" })
    iF _xdPos > 0
     	_xdPefin := xdValues[_xdPos][02]
    Else
        _xdPefin := ""
        if lTeste
        	_xdPefin := "PEFIN|QUANTIDADE TOTAL: 8. VALOR TOTAL: 11660. DETALHAMENTO: DATA: WED SEP 30  CDT 2015. ORIGEM: WURTH DO BR. VALOR: 386 // DATA: TUE MAR 10  CDT 2015. ORIGEM: ARTEK. VALOR: 3148 // DATA: SUN FEB 22  CST 2015. ORIGEM: ARTEK. VALOR: 1829 // DATA: SUN FEB 08  CST 2015. ORIGEM: ARTEK. VALOR: 3148 // DATA: FRI JAN 09  CST 2015. ORIGEM: ARTEK. VALOR: 3149 //"
        EndiF
    EndIf
    _xdPos := Ascan(xdValues,{ |x| x[01]=="Detail_Comm1_312" })
    iF _xdPos > 0
     	_xdRefin := xdValues[_xdPos][02]
    Else
        _xdRefin := ""
        if lTeste
        	_xdRefin := "REFIN|QUANTIDADE TOTAL: 1. VALOR TOTAL: 3872. DETALHAMENTO: DATA: MON NOV 30  CST 2015. ORIGEM: CEF. VALOR: 3872 // "
        EndIf
    EndIf
    
    _xdPos := Ascan(xdValues,{ |x| x[01]=="Detail_Comm1_313" })
    iF _xdPos > 0
     	_xdProtesto := xdValues[_xdPos][02]
    Else
        _xdProtesto := ""
        if lTeste
        	_xdProtesto := "PROTESTO|QUANTIDADE TOTAL: 29. VALOR TOTAL: 5993. DETALHAMENTO: DATA: WED JAN 06  CST 2016. VALOR: 984 // DATA: THU DEC 17  CST 2015. VALOR: 502 // DATA: FRI DEC 11  CST 2015. VALOR: 1874 // DATA: FRI DEC 11  CST 2015. VALOR: 1106 // DATA: THU NOV 19  CST 2015. VALOR: 1527 //"
        EndIf
    EndIf
    
    _xdPos := Ascan(xdValues,{ |x| x[01]=="Detail_Comm1_316" })
    iF _xdPos > 0
     	_xdCCF := xdValues[_xdPos][02]
    Else
        _xdCCF := ""        
    EndIf
    
    _xdPos := Ascan(xdValues,{ |x| x[01]=="Detail_Comm1_315" })
    iF _xdPos > 0
     	_xdAcoes := xdValues[_xdPos][02]
    Else
        _xdAcoes := ""        
    EndIf
    //_xdRefin := "REFIN|QUANTIDADE TOTAL: 1. VALOR TOTAL: 3872. DETALHAMENTO: DATA: MON NOV 30  CST 2015. ORIGEM: CEF. VALOR: 3872 // "
    //_xdProtesto := "PROTESTO|QUANTIDADE TOTAL: 29. VALOR TOTAL: 5993. DETALHAMENTO: DATA: WED JAN 06  CST 2016. VALOR: 984 // DATA: THU DEC 17  CST 2015. VALOR: 502 // DATA: FRI DEC 11  CST 2015. VALOR: 1874 // DATA: FRI DEC 11  CST 2015. VALOR: 1106 // DATA: THU NOV 19  CST 2015. VALOR: 1527 //"
    //_xdCCF := ""
    _ldAnot := .T.
    if _ldAnot 
        _xdAnot := {}
        _xdPos := Ascan(xdValues,{ |x| x[01]=="xDetail_Comm1_320" })
        If _xdPos > 0 
        	_xdVVVV := Upper(xdValues[_xdPos][02])
        
	        __Pefin1 := At("VLR PEFIN:", _xdVVVV ) + Len("VLR PEFIN:") 
	        __Pefin2 := At("QTD REFIN:", _xdVVVV )
	        __Refin1 := At("VLR REFIN:", _xdVVVV ) + Len("VLR REFIN:") 
	        
	        _xStr1 := Val(SubStr(_xdVVVV, __Pefin1, __Pefin2 - __Pefin1))
	        _xStr2 := Val(SubStr(_xdVVVV, __Refin1))
        else
            _xStr1 := -1
            _xStr2 := -1	        
        EndIf

        _xdRet := _desmonta(Upper(_xdPefin))
        if _xStr1 != -1
           _xdRet[02] := _xStr1
        Endif        
        aAdd(_xdAnot,{"PEFIN", _xdRet[01],_xdRet[02],_xdRet[03] , aClone( _xdRet[04] )  }  )
        
        _xdRet := _desmonta(Upper(_xdRefin))
        
        if _xStr2 != -1
           _xdRet[02] := _xStr2
        Endif
        aAdd(_xdAnot,{"REFIN", _xdRet[01],_xdRet[02],_xdRet[03] , aClone( _xdRet[04] )  }  )
        
        _xdRet := _desmontaP(Upper(_xdProtesto))        
        _xdPos := Ascan(xdValues,{ |x| x[01]=="R412protesto" })        
        If _xdPos > 0
        	_xdRet[02] := Val(xdValues[_xdPos][02])
        EndIf
        aAdd(_xdAnot,{"PROTESTO", _xdRet[01],_xdRet[02],_xdRet[03] , aClone( _xdRet[04] )  }  )
        
        
        _xdRet := _desmontaP(Upper(_xdCCF))        
        aAdd(_xdAnot,{"CHEQUE SEM FUNDO", _xdRet[01],_xdRet[02],_xdRet[03] , aClone( _xdRet[04] )  }  )
        _xdRet := _desmontaP(Upper(_xdAcoes))
        aAdd(_xdAnot,{"AÇÕES", _xdRet[01],_xdRet[02],_xdRet[03] , aClone( _xdRet[04] )  }  )
        For _xdK := 01 To Len(_xdAnot)
        	If _xdK == 01
        		oPrinter:Say(nLine,nCol1 + 005,"Anotações Financeiras" , OFONT10N:oFont,,)///*xCor*/,,3)
        		oPrinter:Say(nLine,nCol1 + 200,"Quantidade"            , OFONT10N:oFont,,)///*xCor*/,,3)
        		oPrinter:Say(nLine,nCol1 + 300,"Valor"   		       , OFONT10N:oFont,,)///*xCor*/,,3)
        		oPrinter:Say(nLine,nCol1 + 350,"Data da Ultima" 	   , OFONT10N:oFont,,)///*xCor*/,,3)
        		nLine+= 15
        	EndIf
        	if 	_xdAnot[_xdK][02] != 0        	
	        	oPrinter:Say(nLine,nCol1 + 005,_xdAnot[_xdK][01] , OFONT10N:oFont,,)///*xCor*/,,3)
	        	oPrinter:Say(nLine,nCol1 + 200,Transform( _xdAnot[_xdK][02],"@E 999,999,999")      , OFONT10N:oFont,,CLR_BLUE)///*xCor*/,,3)
	        	oPrinter:Say(nLine,nCol1 + 300,Transform( _xdAnot[_xdK][03],"@E 999,999,999.99")   , OFONT10N:oFont,,CLR_BLUE)///*xCor*/,,3)
	        	oPrinter:Say(nLine,nCol1 + 350,_xdAnot[_xdK][04] 			, OFONT10N:oFont,,CLR_BLUE)///*xCor*/,,3)
	        Else
	        	oPrinter:Say(nLine,nCol1 + 005,_xdAnot[_xdK][01] , OFONT10N:oFont,,)///*xCor*/,,3)
	        	oPrinter:Say(nLine,nCol1 + 200," == NADA CONSTA PARA O CLIENTE CONSULTADO ==" , OFONT10N:oFont,,CLR_BLUE)///*xCor*/,,3)	        	
        	EndIf
        	nLine+= 15
	    Next
    EndIf
    
    _ldPend := .t.
    _xdLin := 01
    If _ldPend .And. _xdAnot[_xdLin][02] > 0
       
       nLine+= 15
 	   oPrinter:Say(nLine,nCol1 + 100," PENDENCIAS FINANCEIRAS (Ate Cinco Ultimas)" , OFONT14N:oFont,,CLR_GRAY)///*xCor*/,,3) 	   
 	   oPrinter:Say(nLine,nCol1 + 400," Total de Ocorrencias : " + Transform(_xdAnot[_xdLin][02],"@E 999,999,999")  , OFONT10N:oFont,,CLR_BLUE)///*xCor*/,,3)
 	    	    	     	   
 	   oPrinter:Box( nLine + 05 , nCol1 - 06, nLine + 05 + 15*( Len(_xdAnot[_xdLin][05]) + 01) , nHPage, "-6")
 	   nLine += 15
 	   For _xdI := 01 To Len(_xdAnot[_xdLin][05])
	 	   If _xdI == 01
	 	       oPrinter:Box( nLine + 05, nCol1 - 06, nLine + 05, nHPage, "-6")
		       oPrinter:Say(nLine,nCol1 + 005," Data ", OFONT10N:oFont  ,,)///,,3)
			   oPrinter:Say(nLine,nCol1 + 105," Origem ", OFONT10N:oFont,,)
			   oPrinter:Say(nLine,nCol1 + 305," Valor ", OFONT10N:oFont ,,)
			   nLine+=15			   
	       EndIf
		   oPrinter:Say(nLine,nCol1 + 105,_xdAnot[_xdLin][05][_xdI][02], OFONT10:oFont,,CLR_BLUE)
	       oPrinter:Say(nLine,nCol1 + 005,DTOC(_xdAnot[_xdLin][05][_xdI][01]), OFONT10:oFont  ,,CLR_BLUE)///,,3)
		   oPrinter:Say(nLine,nCol1 + 305,Transform( _xdAnot[_xdLin][05][_xdI][03],"@e 999,999,999.99"), OFONT10:oFont ,,CLR_BLUE)
		   nLine+=15
       Next
    EndIf
    
    _ldRefin := .t.
    _xdLin := 02
    If _ldRefin .And. _xdAnot[_xdLin][02] > 0
       
       nLine+= 15
 	   oPrinter:Say(nLine,nCol1 + 100," REFIN (OCORRÊNCIAS MAIS RECENTES - ATÉ CINCO) " , OFONT14N:oFont,,CLR_GRAY)///*xCor*/,,3) 	   
 	   oPrinter:Say(nLine,nCol1 + 400," Total de Ocorrencias : " + Transform(_xdAnot[_xdLin][02],"@E 999,999,999")  , OFONT10N:oFont,,CLR_BLUE)///*xCor*/,,3)
 	   
 	   oPrinter:Box( nLine + 05 , nCol1 - 06, nLine + 05 + 15*( Len(_xdAnot[_xdLin][05]) + 01) , nHPage, "-6") 	   
 	   nLine += 15
 	   For _xdI := 01 To Len(_xdAnot[_xdLin][05])
	 	   If _xdI == 01
	 	   	   oPrinter:Box( nLine + 05, nCol1 - 06, nLine + 05, nHPage, "-6")
		       oPrinter:Say(nLine,nCol1 + 005," Data ", OFONT10N:oFont  ,,)///,,3)
			   oPrinter:Say(nLine,nCol1 + 105," Origem ", OFONT10N:oFont,,)
			   oPrinter:Say(nLine,nCol1 + 305," Valor ", OFONT10N:oFont ,,)
			   nLine+=15
	       EndIf
	       oPrinter:Say(nLine,nCol1 + 005,DTOC(_xdAnot[_xdLin][05][_xdI][01]), OFONT10:oFont  ,,CLR_BLUE)///,,3)
		   oPrinter:Say(nLine,nCol1 + 105,_xdAnot[_xdLin][05][_xdI][02], OFONT10:oFont,,CLR_BLUE)
		   oPrinter:Say(nLine,nCol1 + 305,Transform( _xdAnot[_xdLin][05][_xdI][03],"@e 999,999,999.99"), OFONT10:oFont ,,CLR_BLUE)
		   nLine+=15
       Next
    EndIf
    
    
     _ldProtesto := .T.
    _xdLin := 03
    If _ldProtesto .And. _xdAnot[_xdLin][02] > 0
           
       nLine+= 15
 	   oPrinter:Say(nLine,nCol1 + 100," PROTESTOS (OCORRÊNCIAS MAIS RECENTES - ATÉ CINCO) " , OFONT14N:oFont,,CLR_GRAY)///*xCor*/,,3) 	   
 	   oPrinter:Say(nLine,nCol1 + 400," Total de Ocorrencias : " + Transform(_xdAnot[_xdLin][02],"@E 999,999,999")  , OFONT10N:oFont,,CLR_BLUE)///*xCor*/,,3)
 	   
 	   oPrinter:Box( nLine + 05 , nCol1 - 06, nLine + 05 + 15*( Len(_xdAnot[_xdLin][05]) + 01) , nHPage, "-6") 	   
 	   nLine += 15
 	   For _xdI := 01 To Len(_xdAnot[_xdLin][05])
	 	   If _xdI == 01
	 	   	   oPrinter:Box( nLine + 05, nCol1 - 06, nLine + 05, nHPage, "-6")
		       oPrinter:Say(nLine,nCol1 + 005," Data ", OFONT10N:oFont  ,,)///,,3)			   
			   oPrinter:Say(nLine,nCol1 + 305," Valor ", OFONT10N:oFont ,,)
			   nLine+=15
	       EndIf
	       oPrinter:Say(nLine,nCol1 + 005,DTOC(_xdAnot[_xdLin][05][_xdI][01]), OFONT10:oFont  ,,CLR_BLUE)///,,3)		   
		   oPrinter:Say(nLine,nCol1 + 305,Transform( _xdAnot[_xdLin][05][_xdI][02],"@e 999,999,999.99"), OFONT10:oFont ,,CLR_BLUE)
		   nLine+=15
       Next
    EndIf
    
    _ldCCF := .T.
    _xdLin := 04
    If _ldCCF .And. _xdAnot[_xdLin][02] > 0
           
       nLine+= 15
 	   oPrinter:Say(nLine,nCol1 + 100," CHEQUES SEM FUNDO (OCORRÊNCIAS MAIS RECENTES - ATÉ CINCO) " , OFONT14N:oFont,,CLR_GRAY)///*xCor*/,,3) 	   
 	   oPrinter:Say(nLine,nCol1 + 400," Total de Ocorrencias : " + Transform(_xdAnot[_xdLin][02],"@E 999,999,999")  , OFONT10N:oFont,,CLR_BLUE)///*xCor*/,,3)
 	   
 	   oPrinter:Box( nLine + 05 , nCol1 - 06, nLine + 05 + 15*( Len(_xdAnot[_xdLin][05]) + 01) , nHPage, "-6") 	   
 	   nLine += 15
 	   For _xdI := 01 To Len(_xdAnot[_xdLin][05])
	 	   If _xdI == 01
	 	   	   oPrinter:Box( nLine + 05, nCol1 - 06, nLine + 05, nHPage, "-6")
		       oPrinter:Say(nLine,nCol1 + 005," Data ", OFONT10N:oFont  ,,)///,,3)
			   //oPrinter:Say(nLine,nCol1 + 105," Origem ", OFONT10N:oFont,,)
			   oPrinter:Say(nLine,nCol1 + 305," Valor ", OFONT10N:oFont ,,)
			   nLine+=15
	       EndIf
	       oPrinter:Say(nLine,nCol1 + 005,DTOC(_xdAnot[_xdLin][05][_xdI][01]), OFONT10:oFont  ,,CLR_BLUE)///,,3)
		   //oPrinter:Say(nLine,nCol1 + 105,_xdAnot[_xdLin][05][_xdI][02], OFONT10:oFont,,CLR_BLUE)
		   oPrinter:Say(nLine,nCol1 + 305,Transform( _xdAnot[_xdLin][05][_xdI][02],"@e 999,999,999.99"), OFONT10:oFont ,,CLR_BLUE)
		   nLine+=15
       Next
    EndIf
    
    
    _ldAcoes := .T.
    _xdLin := 05
    If _ldAcoes .And. _xdAnot[_xdLin][02] > 0
           
       nLine+= 15
 	   oPrinter:Say(nLine,nCol1 + 100," DETALHAMENTO DE AÇÕES (OCORRÊNCIAS MAIS RECENTES - ATÉ CINCO) " , OFONT14N:oFont,,CLR_GRAY)///*xCor*/,,3) 	   
 	   oPrinter:Say(nLine,nCol1 + 400," Total de Ocorrencias : " + Transform(_xdAnot[_xdLin][02],"@E 999,999,999")  , OFONT10N:oFont,,CLR_BLUE)///*xCor*/,,3)
 	   
 	   oPrinter:Box( nLine + 05 , nCol1 - 06, nLine + 05 + 15*( Len(_xdAnot[_xdLin][05]) + 01) , nHPage, "-6") 	   
 	   nLine += 15
 	   For _xdI := 01 To Len(_xdAnot[_xdLin][05])
	 	   If _xdI == 01
	 	   	   oPrinter:Box( nLine + 05, nCol1 - 06, nLine + 05, nHPage, "-6")
		       oPrinter:Say(nLine,nCol1 + 005," Data ", OFONT10N:oFont  ,,)///,,3)
			   //oPrinter:Say(nLine,nCol1 + 105," Origem ", OFONT10N:oFont,,)
			   oPrinter:Say(nLine,nCol1 + 305," Valor ", OFONT10N:oFont ,,)
			   nLine+=15
	       EndIf
	       oPrinter:Say(nLine,nCol1 + 005,DTOC(_xdAnot[_xdLin][05][_xdI][01]), OFONT10:oFont  ,,CLR_BLUE)///,,3)
		   //oPrinter:Say(nLine,nCol1 + 105,_xdAnot[_xdLin][05][_xdI][02], OFONT10:oFont,,CLR_BLUE)
		   oPrinter:Say(nLine,nCol1 + 305,Transform( _xdAnot[_xdLin][05][_xdI][02],"@e 999,999,999.99"), OFONT10:oFont ,,CLR_BLUE)
		   nLine+=15
       Next
    EndIf
    
    //nLine += 15
    //oPrinter:Say(nLine,nCol1 + 005,"PEFIN" , OFONT10N:oFont,,)///*xCor*/,,3)
        
    /*
	nLine += 80
	oPrinter:Say(nLine,nCol1,"PEFIN (OCORRÊNCIAS MAIS RECENTES - ATÉ CINCO)", OFONT14N:oFont ,),,3)    

	//Detail_Comm1_312
	_xdPos := Ascan(xdValues,{ |x| x[01]=="Detail_Comm1_311" })
	_xdRet := _desmonta(xdValues[_xdPos][02])

	If Len(Rtrim(xdValues[_xdPos][02])) == 0
		nLine += 80
		oPrinter:Say(nLine,nCol1, "Nada Consta" , OFONT11N:oFont ,)//,,3)
	Else
		_xdIni    := At("|", xdValues[_xdPos][02] )
		_xdDet    := At("Detalhamento", xdValues[_xdPos][02] )

		nLine += 60
		oPrinter:Say(nLine,nCol1, SubStr(xdValues[_xdPos][02],_xdIni + 1,_xdDet - _xdIni) , OFONT11N:oFont ,)//xCor,,3)


		nLine += 90
		oPrinter:Say(nLine,050," Data ", OFONT12N:oFont  ,)///,,3)
		oPrinter:Say(nLine,500," Origem ", OFONT12N:oFont,)
		oPrinter:Say(nLine,1200," Valor ", OFONT12N:oFont ,)    
		nLine += 90

		For _xdK := 01 To Len(_xdRet)
			oPrinter:Say(nLine,050, DTOC( _xdRet[_xdK][01]) , OFONT12:oFont ,)///*xCor,,3)
			oPrinter:Say(nLine,500,_xdRet[_xdK][02], OFONT12:oFont ,)///*xCor,,3)
			oPrinter:Say(nLine,1200,Transform( _xdRet[_xdK][03],"@E 999,999,999.99"), OFONT12:oFont ,)///*xCor,,3)
			nLine += 60
		Next
	EndIf

	nLine += 80
	oPrinter:Say(nLine,nCol1,"REFIN (OCORRÊNCIAS MAIS RECENTES - ATÉ CINCO)", OFONT14N:oFont ,)///*xCor,,3)

	_xdPos := Ascan(xdValues,{ |x| x[01]=="Detail_Comm1_312" })    
	_xdRet := _desmonta(xdValues[_xdPos][02])
	If Len(Rtrim(xdValues[_xdPos][02])) == 0
		nLine += 80
		oPrinter:Say(nLine,nCol1, "Nada Consta" , OFONT11N:oFont ,)///*xCor,3)
	Else
		nLine += 90
		oPrinter:Say(nLine,050," Data "  , OFONT12N:oFont,)///*xCor,,3)
		oPrinter:Say(nLine,00," Origem ", OFONT12N:oFont,)
		oPrinter:Say(nLine,1200," Valor " , OFONT12N:oFont,)    
		nLine += 90

		For _xdK := 01 To Len(_xdRet)
			oPrinter:Say(nLine,050, DTOC( _xdRet[_xdK][01]) , OFONT12:oFont ,)///*xCor,,3)
			oPrinter:Say(nLine,500,_xdRet[_xdK][02], OFONT12:oFont ,)///*xCor,,3)
			oPrinter:Say(nLine,1200,Transform( _xdRet[_xdK][03],"@E 999,999,999.99"), OFONT12:oFont ,)///*xCor,,3)
			nLine += 60
		Next
	EndIf

	nLine += 80
	oPrinter:Say(nLine,nCol1,"PROTESTOS (OCORRÊNCIAS MAIS RECENTES - ATÉ 5) ", OFONT14N:oFont ,)///*xCor,,3)	
	_xdPos := Ascan(xdValues,{ |x| x[01]=="Detail_Comm1_313" })
	_xdRet := _desmontaP(xdValues[_xdPos][02])

	If Len(Rtrim(xdValues[_xdPos][02])) == 0
		nLine += 80
		oPrinter:Say(nLine,nCol1, "Nada Consta" , OFONT11N:oFont ,)///*xCor,3)
	Else
		//Detail_Comm1_312


		_xdIni    := At("|", xdValues[_xdPos][02] )
		_xdDet    := At("Detalhamento", xdValues[_xdPos][02] )

		nLine += 60
		oPrinter:Say(nLine,nCol1, SubStr(xdValues[_xdPos][02],_xdIni + 1,_xdDet - _xdIni) , OFONT11N:oFont ,)///*xCor,,3)	

		nLine += 90
		oPrinter:Say(nLine,050," Data "  , OFONT12N:oFont ,)///*xCor,,3)
		//oPrinter:Say(nLine,200," Origem ", OFONT12N:oFont ,)
		oPrinter:Say(nLine,900," Valor " , OFONT12N:oFont ,)    
		nLine += 90

		For _xdK := 01 To Len(_xdRet)
			oPrinter:Say(nLine,050, DTOC( _xdRet[_xdK][01]) , OFONT12:oFont ,)///*xCor/,,3)
			//oPrinter:Say(nLine,200,_xdRet[_xdK][02], OFONT12:oFont ,)///*xCor*,,3)
			oPrinter:Say(nLine,900,Transform( _xdRet[_xdK][02],"@E 999,999,999.99"), OFONT12:oFont ,)///*xCor*,,3)
			nLine += 60
		Next
	EndIf


	nLine += 80
	oPrinter:Say(nLine,nCol1,"CHEQUE SEM FUNDO  ", OFONT14N:oFont ,)///*xCor*,,3)    
	_xdRet := _desmontaP(xdValues[_xdPos][02])

	//Detail_Comm1_312
	_xdPos := Ascan(xdValues,{ |x| x[01]=="Detail_Comm1_316" })
	If Len(Rtrim(xdValues[_xdPos][02])) == 0
	    nLine += 80
		oPrinter:Say(nLine,nCol1, "Nada Consta" , OFONT11N:oFont ,)///*xCor*,,3)
	Else
		_xdIni    := At("|", xdValues[_xdPos][02] )
		_xdDet    := At("Detalhamento", xdValues[_xdPos][02] )

		nLine += 60
		oPrinter:Say(nLine,nCol1, SubStr(xdValues[_xdPos][02],_xdIni + 1,_xdDet - _xdIni - 1) , OFONT11N:oFont ,)///*xCor,,3)

		_xdRet := _desmontaP(xdValues[_xdPos][02])

		nLine += 90
		oPrinter:Say(nLine,050," Data "  , OFONT12N:oFont ,)///*xCor,,3)
		//oPrinter:Say(nLine,200," Origem ", OFONT12N:oFont ,)
		oPrinter:Say(nLine,800," Valor " , OFONT12N:oFont ,)    
		nLine += 90

		For _xdK := 01 To Len(_xdRet)
			oPrinter:Say(nLine,050, DTOC( _xdRet[_xdK][01]) , OFONT12:oFont ,)///*xCor,,3)
			//oPrinter:Say(nLine,200,_xdRet[_xdK][02], OFONT12:oFont ,)///*xCor/,,3)
			oPrinter:Say(nLine,900,Transform( _xdRet[_xdK][02],"@E 999,999,999.99"), OFONT12:oFont ,)///*xCor*,,3)
			nLine += 60
		Next
	EndiF
    */
	//nLine += 100
	//oPrint:Say( nLine,nCol1,SA1->A1_NOME,oFont07n,1400,CLR_HRED )

	oPrinter:Preview()

Return Nil

Static Function _desmonta(_xdValor)
	_xdReturn := {}
	if Len(_xdValor) == 0
	   Return {0,0,DTOC(STOD("")),{}} 
	EndIf
	_xdDet    := At("DETALHAMENTO",_xdValor)
	_xdResult := Substr(_xdValor,_xdDet+Len("Detalhamento:"))
	_ydValue := StrToKArr2(_xdResult,"//")

    _ydBefore := Substr(_xdValor,7,_xdDet - 07)
    _xdQtd    := At("QUANTIDADE TOTAL:",_ydBefore)
    _xdVlt    := At("VALOR TOTAL:",_ydBefore)
    _ydTotal  := Alltrim(SubStr(_ydBefore,18, _xdVlt - _xdQtd))
    _ydTotal  := If( SubStr(_ydTotal,Len(_ydTotal),1) == ".",SubStr(_ydTotal,1,Len(_ydTotal)-1) ,_ydTotal)
    _ydValor  := Alltrim(Substr(_ydBefore,_xdVlt + Len("VALOR TOTAL:") ) )
    _ydValor  := If( SubStr(_ydValor,Len(_ydTotal),1) == ".",SubStr(_ydValor,1,Len(_ydValor)-1) ,_ydValor)
    _ydValor  := If( Len(_ydValor) > 0, val(_ydValor),0)
    _ydTotal  := If( Len(_ydTotal) > 0, val(_ydTotal),0)
    _xdDate := STOD("")
    
	For _xdL := 01 To Len(_ydValue)
		If Len(Rtrim(_ydValue[_xdL])) > 0
			_xdIni := At("DATA:",_ydValue[_xdL]) + Len("Data:")
			_xdFim := At("ORIGEM:",_ydValue[_xdL])
			_xdRes := Alltrim(SubStr(alltrim(SubStr(_ydValue[_xdL],7,30 - Len("Origem:"))),4))
			_cdMonth := getMonth( Upper( Left(_xdRes,3))  )
			_cdDay   := SubStr(_xdRes,5,2)
			_cdYear  := Right( StrTran(_xdRes,".","") , 4)
			_xdDate := STOD(_cdYear + _cdMonth + _cdDay)

			_xdIni := _xdFim + Len("Origem:")
			_xdFim := At("VALOR:",_ydValue[_xdL])
			_xdOrigem := SubStr(_ydValue[_xdL],_xdIni,_xdFim - _xdIni)
			_xdIni := _xdFim + Len("Valor:")
			_xdValor := Val( SubStr(_ydValue[_xdL],_xdIni) )
			aLin := {}
			aAdd(aLin,_xdDate)
			aAdd(aLin,_xdOrigem)
			aAdd(aLin,_xdValor)

			aAdd(_xdReturn,aLin)
		EndIf    
	Next

Return {_ydTotal,_ydValor,DTOC(_xdDate),_xdReturn}


Static Function _desmontaP(_xdValor)
	_xdReturn := {}
	if Len(_xdValor) == 0
	   Return {0,0,DTOC(STOD("")),{}} 
	EndIf
	_xdDet    := At("DETALHAMENTO",_xdValor)
	_xdResult := Substr(_xdValor,_xdDet+Len("Detalhamento:"))
	_ydValue := StrToKArr2(_xdResult,"//")

	_ydBefore := Substr(_xdValor,10,_xdDet - 10)
    _xdQtd    := At("QUANTIDADE TOTAL:",_ydBefore)
    _xdVlt    := At("VALOR TOTAL:",_ydBefore)
    _ydTotal  := Alltrim(SubStr(_ydBefore,18, _xdVlt - 18 - _xdQtd ))
    _ydTotal  := If( SubStr(_ydTotal,Len(_ydTotal),1) == ".",SubStr(_ydTotal,1,Len(_ydTotal)-1) ,_ydTotal)
    _ydValor  := Alltrim(Substr(_ydBefore,_xdVlt + Len("VALOR TOTAL:") ) )
    _ydValor  := If( SubStr(_ydValor,Len(_ydTotal),1) == ".",SubStr(_ydValor,1,Len(_ydValor)-1) ,_ydValor)
    _ydValor  := If( Len(_ydValor) > 0, val(_ydValor),0)
    _ydTotal  := If( Len(_ydTotal) > 0, val(_ydTotal),0)
    
    _xdDate := STOD("")
	For _xdL := 01 To Len(_ydValue)

		If Len(Rtrim(_ydValue[_xdL])) > 0
			_xdIni := At("DATA:",_ydValue[_xdL]) + Len("Data:")
			_xdFim := At("VALOR:",_ydValue[_xdL])
			_xdRes := Alltrim(SubStr(alltrim(SubStr(_ydValue[_xdL],7,_xdFim - 07 )),4))
			_cdMonth := getMonth( Upper( Left(_xdRes,3))  )
			_cdDay   := SubStr(_xdRes,5,2)
			_cdYear  := Right( StrTran(_xdRes,".","") , 4)
			_xdDate := STOD(_cdYear + _cdMonth + _cdDay)

			_xdIni := _xdFim + Len("Valor:")
			_xdValor := Val( SubStr(_ydValue[_xdL],_xdIni) )
			aLin := {}
			aAdd(aLin,_xdDate)
			//aAdd(aLin,_xdOrigem)
			aAdd(aLin,_xdValor)

			aAdd(_xdReturn,aLin)
		EndIf    
	Next

Return {_ydTotal,_ydValor,DTOC(_xdDate),_xdReturn}

Static Function getMonth(_xdMonth)
	cdRet := ""
	do Case 
		Case Upper(_xdMonth)=="JAN"
		cdRet := "01"
		Case Upper(_xdMonth)=="FEB"
		cdRet := "02"
		Case Upper(_xdMonth)=="MAR"
		cdRet := "03"
		Case Upper(_xdMonth)=="APR"
		cdRet := "04"
		Case Upper(_xdMonth)=="MAY"
		cdRet := "05"
		Case Upper(_xdMonth)=="JUN"
		cdRet := "06"
		Case Upper(_xdMonth)=="JUL"
		cdRet := "07"
		Case Upper(_xdMonth)=="AUG"
		cdRet := "08"
		Case Upper(_xdMonth)=="SEP"
		cdRet := "09"
		Case Upper(_xdMonth)=="OCT"
		cdRet := "10"
		Case Upper(_xdMonth)=="NOV"
		cdRet := "11"
		Case Upper(_xdMonth)=="DEC"
		cdRet := "12"
	EndCase
Return cdRet