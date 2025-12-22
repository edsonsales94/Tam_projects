#Include 'Protheus.ch'
#Include 'TBICONN.ch'

User Function AAFATX98(_xdAuto,_xdFile)

    Default _xdAuto    := .F.
	Default _xdFile    := Space(400)
    
	Private _ldAuto    := _xdAuto
	Private _cdArquivo := iIf( _ldAuto,_xdFile ,Space(400))
	Private _adEmp := FwLoadSM0()
	Private lAviso := .T.
	
	PRIVATE cNumOrc   := getLastOrc()
	Private _adFormas := {}
	Private _cdXml    := " "
	
	aAdd(_adFormas , {"01","Dinhero","R$"} )
	aAdd(_adFormas , {"02","CHEQUE" ,"CH"} )
	aAdd(_adFormas , {"03","CARTAO CREDITO", "CC"} )
	aAdd(_adFormas , {"04","CARTAO DEBITO" , "CD"} )
	aAdd(_adFormas , {"05","CREDITO LOJA"  , "CR"} )
	aAdd(_adFormas , {"10","VALE ALIMENTACAO",""} )
	aAdd(_adFormas , {"11","VALE REFEICAO"   ,""} )
	aAdd(_adFormas , {"12","VALE PRESENTE"   ,""} )
	aAdd(_adFormas , {"13","COMBUSTIVEL"     ,""} )
	aAdd(_adFormas , {"99","OUTROS"          ,""} )
	
	Private _cdFile := ""
	PRivate _cdDir  := ""
	if getXmls()
	   Processa( {|| ChecaDir( _cdDir,_cdFile) } ,"Processando Xmls's Encontrados")
	EndIf
	
Return Nil

Static Function getLastOrc()

    _cdQry :=  ' select isNull(MAX(L1_NUM),"I00000") ORC from ' + RetSqlName('SL1')
	_cdQry +=  "  Where Left(L1_NUM,1) = 'I' "
	_cdtbl := getNextAlias()
	dbUseArea(.F., "TOPCONN", tcGenQry(,,_cdQry), _cdtbl , .T., .F.)
	_cdNumOrc := (_cdTbl)->ORC
	(_cdTbl)->(dbCloseArea(_cdTbl))
	
Return _cdNumOrc 

Static Function getXmls( )
    
	If !_ldAuto .Or. (Empty(_cdFile) .And. _ldAuto)
	
		DEFINE MSDIALOG oDlg TITLE "Importação Notas Fiscais" From 0,0 To 200,600 Pixel
		nOpc := 00
	    iF !SUPERGETMV("MV_XAFATX08",.T.)
   			CreateParm()
		EndIf
	
		_cdFile := Padr(Getmv('MV_XAFATX08'),400)//IiF( ALLTRIM(Getmv('MV_XACOMP11')) == 'XX', Padr(Getmv('MV_XACOMP04'),400) , SPACE(400) )
		_cdDir  := Padr(Getmv('MV_XBFATX08'),400)//IiF( ALLTRIM(Getmv('MV_XBCOMP11')) == 'XX', Padr(Getmv('MV_XBCOMP04'),400) , SPACE(400) )

		@ 05,07 SAY " Arquivo para Importação:" SIZE 100,80 PIXEL OF oDlg
		@ 15,07 MSGET _cdFile PICTURE "@!" SIZE 250, 10 PIXEL OF oDlg  F3 'XMLFIL'
		
		If !_ldAuto // So Aparece quando não e Automatica
			@ 30,07 SAY " Diretorio para Importação:" SIZE 100,80 PIXEL OF oDlg
			@ 45,05 MSGET _cdDir  PICTURE "@!" SIZE 250, 10 PIXEL OF oDlg  F3 'XMLDIR'
		EndIf
		@ 60,050 BUTTON "Importar" SIZE 40,12 PIXEL OF oDlg ACTION (nOpc:=1,oDlg:End())
		@ 60,110 BUTTON "Cancelar" SIZE 40,12 PIXEL OF oDlg ACTION (nOpc:=0,oDlg:End())

		ACTIVATE MSDIALOG oDlg CENTERED
	Else
		nOpc := 01
	EndIf

//-- Validacoes
	If nOpc == 1
		If Empty(_cdFile) .And. Empty(_cdDir)
			MsgInfo("Nenhum Arquivo/Diretorio selecionado!.","Atenção!!")
			lRet := .F.
		Else
		    //Putmv('MV_XAFATX08',_cdFile)
		    Putmv('MV_XBFATX08',_cdDir)	
			lRet := .T.
		EndIf
	Else
		lRet := .F.
	EndIf
		
Return lRet

Static Function ChecaDir(xdPath,xdFile)

	Local _adProcess := {}
	Local _adFiles := {}
	Local cError   := ""
	Local cWarning := ""
	Default xdFile := ""
	Default xdPath := ""
	Private _cdFile := xdFile
    Private _cdPath := xdPath
	_cdPath := Alltrim(_cdPath)
	
	If !Empty(_cdPath)
		_cdPath  += iIf(Right(Alltrim(_cdPath),1) != '\','\','')
		_adFiles := Directory(alltrim(_cdPath)+"*.xml")
	EndIf
    
	If !Empty(_cdFile)
		aAdd(_adFiles,{_cdFile})
	EndIf

	ProcRegua(Len(_adFiles))

	For _ndI:=1 to Len(_adFiles)
	
		_ldErro := .F.
		_cdFile := ALLTRIM(_adFiles[_ndI][1])
	
		fHandle := FT_FUSE(_cdPath + _cdFile)
		FT_FGOTOP()
		_cdXml := ""
		While !FT_FEOF()
			_cdXml += FT_FREADLN()
			FT_FSKIP()
		EndDo
		FT_FUSE()
		
		oXML := XmlParser(_cdXml, "_", @cError, @cWarning )
	
		If !Empty(cError) .Or.  !Empty(cWarning)
			aAdd(_adProcess, {_cdFile , oXML,_ldErro}  )
			_xdMensagem := ""
			_ldErro := .T.
		EndIf
	 
		If !_ldErro
		    cNumOrc := Soma1(cNumOrc)
			_adRet := aClone( ChecaXml(oXML) )			
		EndIf
	  
		IncProc()
	Next
	IF Len(_adProcess) == 0
		aAdd(_adProcess, { .F. ,.F.,"" , "" , "" , Nil , "", {}  ,"" , {{},{}}  } )
	EndIf
Return _adProcess


Static Function ChecaXml(oXml)
	Local _ldRet := .T.
	Local _cdRet := ' '
	Local oRet   := Nil

	Private oNfe      := IIf(Type("oXML:_NFEPROC")=="U",	Nil ,	oXML:_NFEPROC)
	Private oNF       := iIf(Type("oNFe:_NFe") == 'U', Nil, oNFe:_NFe)
	Private oEmitente := iIF(Type("oNF:_InfNfe:_Emit") == 'U', Nil,oNF:_InfNfe:_Emit)
	Private oIdent    := iIF(Type("oNF:_InfNfe:_IDE") == 'U', Nil,oNF:_InfNfe:_IDE)
	Private oDestino  := iIF(Type("oNF:_InfNfe:_Dest") == 'U', Nil,oNF:_InfNfe:_Dest)
	Private oTotal    := iIF(Type("oNF:_InfNfe:_Total") == 'U', Nil,oNF:_InfNfe:_Total)
	Private oTransp   := iIF(Type("oNF:_InfNfe:_Transp") == 'U', Nil,oNF:_InfNfe:_Transp)
	Private oDet      := iIF(Type("oNF:_InfNfe:_Det") == 'U', Nil,oNF:_InfNfe:_Det)
    Private _cHoraEmi := ""
	Private _cdCgc    := ""
	Private _cdSerie  := ""
	Private _cdDoc    := ""
	Private _cdCvh    := ""
	
	If (_ldRet := oNf == Nil )
		_cdRet := 'XML em Formato Invalido, Arquivo Não se Refere a Uma NF-e'
	ElseIf  (oEmitente == Nil)
		_cdRet := 'XML em Formato Invalido, Dados do Emitente não Encontrado'
	ElseIf (oIdent == Nil)
		_cdRet := 'XML em Formato Invalido, Dados Referente aos Detalhes da Nota Não Encontrados'
	ElseIf (oDet == Nil)
		_cdRet := 'XML em Formato Invalido, Dados dos Produtos da Nota não Encontrados'
	EndIf
	_ldRet := Empty(_cdRet)
	oRet   := iIf(_ldRet,oNf,Nil)
	_cdCvh := iIf(_ldRet,oNfe:_PROTNFE:_INFPROT:_CHNFE:TEXT,'')        
    
    ProcessaXml(oNfe:_NFE,_cdCvh)
    
Return _ldRet

Static Function ProcessaXml(_xdNfe,_cdCvh)
	
	Private _odNfe := _xdNfe
	
	_cdCnpj   := iIf(type("_odNfe:_InfNfe:_Emit:_CNPJ:TEXT") != "U", _odNfe:_InfNfe:_Emit:_CNPJ:TEXT,"")
	_cdInsc   := iIf(type("_odNfe:_InfNfe:_Emit:_IE:TEXT")   != "U", _odNfe:_InfNfe:_Emit:_IE:TEXT,"")
	_cdDoc    := iIf(Type("_odNfe:_InfNfe:_IDE:_NNF:TEXT")   != "U", StrZero(Val(_odNfe:_InfNfe:_IDE:_NNF:TEXT),9),"")
	_cdSerie  := iIf(Type("_odNfe:_InfNfe:_IDE:_SERIE:TEXT") != "U", _odNfe:_InfNfe:_IDE:_SERIE:TEXT,"")
	_cdCgc    := iIf(Type("_odNfe:_InfNfe:_DEST:_CNPJ:TEXT") != "U", _odNfe:_InfNfe:_DEST:_CNPJ:TEXT,iIf(Type("_odNfe:_InfNfe:_DEST:_CPF:TEXT") != "U", _odNfe:_InfNfe:_DEST:_CPF:TEXT,""))
	 
	_dEmissao := Stod(Left(iIf(Type("_odNfe:_InfNfe:_IDE:_dhEmi:TEXT") != "U" , StrTran(_odNfe:_InfNfe:_IDE:_dhEmi:TEXT,"-"),""),8) )
	_cHoraEmi := SubString( iIf(Type("_odNfe:_InfNfe:_IDE:_dhEmi:TEXT") != "U" , StrTran(_odNfe:_InfNfe:_IDE:_dhEmi:TEXT,"-"),""),10,08)
	_cdNome   := iIf(Type("_odNfe:_InfNfe:_EMIT:_XNOME:TEXT") != "U" , _odNfe:_InfNfe:_EMIT:_XNOME:TEXT,"")
	_ndDesc   := IiF(tYPE("_odNfe:_InfNfe:_Total:_ICMSTOT:_VDESC:TEXT") != "U", Val(_odNfe:_InfNfe:_Total:_ICMSTOT:_VDESC:TEXT) ,0)
	_ndTotal  := iIf(Type("_odNfe:_InfNfe:_Total:_ICMSTOT:_VNF:TEXT")   != "U", Val(_odNfe:_InfNfe:_Total:_ICMSTOT:_VNF:TEXT)   ,0)
	_ndMerc   := iIf(Type("_odNfe:_InfNfe:_Total:_ICMSTOT:_VPROD:TEXT") != "U", Val(_odNfe:_InfNfe:_Total:_ICMSTOT:_VPROD:TEXT) ,0)
	_ndfrete  := iIf(Type("_odNfe:_InfNfe:_Total:_ICMSTOT:_VFRETE:TEXT") != "U", Val(_odNfe:_InfNfe:_Total:_ICMSTOT:_VFRETE:TEXT) ,0)
	_ndSeguro := iIf(Type("_odNfe:_InfNfe:_Total:_ICMSTOT:_VSEG:TEXT") != "U", Val(_odNfe:_InfNfe:_Total:_ICMSTOT:_VSEG:TEXT) ,0)
	
	_cdBairro := iIf(Type("_odNfe:_InfNfe:_DEST:_EnderDest:_xBairro:TEXT") != "U" , _odNfe:_InfNfe:_DEST:_EnderDest:_xBairro:TEXT,"")
    
	_xdPag    := iIf(Type("_odNfe:_InfNfe:_Pag") != "U",_odNfe:_InfNfe:_Pag,"")
	
   _ndPos := aScan(_adEmp, {|x| x[01] == FwCodEmp() .And. x[02] == FwCodFil() }  )
	If _ndPos > 0
		If _cdCnpj != _adEmp[_ndPos][18]
			If lAviso
				Aviso('Atenção', "Este XML é da Filial:   ("+  _cdBairro  +")" + Chr(13) + Chr(10) + ;
					   " CNPJ:  ("+  _cdCnpj  +")" + Chr(13) + Chr(10) +;
					   "Só e Permitido Importar XML da Filial Logada ", {"OK"})
			Else
				_xdMensagem += " Este XML é da Filial:   ("+  _cdBairro  +")" + Chr(13) + Chr(10) + ;
					           " CNPJ:  ("+  _cdCnpj  +")" + Chr(13) + Chr(10) +;
					           " Só e Permitido Importar XML da Filial Logada "
			EndiF
			Return .F.
		EndIf
	Else
		MsFinal()
	EndIf
	
	
	SA1->(dbSetOrder(3))
	If !SA1->(dbSeek(xFilial('SA1')+ALLTRIM(_cdCgc)))
	    //CreateCliente(_cdCgc)
	    SA1->(dbSetOrder(1))
	    SA1->(dbSeek(xFilial('SA1') + getMv("MV_CLIPAD") ))
	    /*
		If lAviso
			Aviso('Atencao','O Cliente : ' + _cdNome + Chr(13) + Chr(10) + ;
				' de CNPJ: '+ transform(_cdCgc,"@R 99.999.999/9999-99") + Chr(13) + Chr(10) + ;
				" Nao Encontra na Base, Necessario Cadastra-lo! ",{'OK'} , 3)
		Else
			If !Empty(_xdMensagem)
				_xdMensagem += Chr(13) + Chr(10) + Chr(13) + Chr(10)
			EndIf
			_xdMensagem := ' O Cliente : ' + _cdNome + Chr(13) + Chr(10) + ;
				' de CNPJ: '+ transform(_cdCgc,"@R 99.999.999/9999-99") + Chr(13) + Chr(10) + ;
				" Nao Encontra na Base, Necessario Cadastra-lo! "
		EndIf
		*/
		//Return .F.
		
	EndIf
	
	dDatabase := _dEmissao
	
	
	nDinheiro := 0
    nCheque   := 0
	nCartaoC  := 0
	nCartaoD  := 0
	nCredito  := 0
	nOutros   := 0

	if ValType(_xdPag) == "O"

	   _xdForma  := Alltrim(_xdPag:_tPag:TEXT)
	   _xdValor  := _xdPag:_vPag:TEXT
	   
	   nDinheiro := iIf(_xdForma == _adFormas[01][01] , Val(_xdValor) , 0)
	   nCheque   := iIf(_xdForma == _adFormas[02][01] , Val(_xdValor) , 0)
	   nCartaoC  := iIf(_xdForma == _adFormas[03][01] , Val(_xdValor) , 0)
	   nCartaoD  := iIf(_xdForma == _adFormas[04][01] , Val(_xdValor) , 0)
	   nCredito  := iIf(_xdForma == _adFormas[05][01] , Val(_xdValor) , 0)
	   nOutros   := iIf(_xdForma == _adFormas[10][01] , Val(_xdValor) , 0)
	   
	ElseIf ValType(_xdPag) == "A"

	   For _ndX := 1 To Len(_xdPag)
	       _xdForma  := Alltrim(_xdPag[_ndX]:_tPag:TEXT)
	       _xdValor  := _xdPag[_ndX]:_vPag:TEXT
	       
		   
	       nDinheiro += iIf(_xdForma == _adFormas[01][01] , Val(_xdValor) , 0)
		   nCheque   += iIf(_xdForma == _adFormas[02][01] , Val(_xdValor) , 0)
		   nCartaoC  += iIf(_xdForma == _adFormas[03][01] , Val(_xdValor) , 0)
	       nCartaoD  += iIf(_xdForma == _adFormas[04][01] , Val(_xdValor) , 0)
		   nCredito  += iIf(_xdForma == _adFormas[05][01] , Val(_xdValor) , 0)
	       nOutros   += iIf(_xdForma == _adFormas[10][01] , Val(_xdValor) , 0)
	   Next

	EndIf
	
	_aCab:= {    {"LQ_NUM"    , cNumOrc           ,NIL},;
	             {"LQ_VEND"   , "000099"          ,NIL},;
				 {"LQ_COMIS"  , 0                  ,NIL},;
				 {"LQ_CLIENTE", SA1->A1_COD        ,NIL},;
				 {"LQ_LOJA"   , SA1->A1_LOJA       ,NIL},;
				 {"LQ_TIPOCLI", SA1->A1_TIPO       ,NIL},;
				 {"LQ_VLRTOT" , _ndMerc            ,NIL},;
				 {"LQ_DESCONT", 0                  ,NIL},;
				 {"LQ_VLRLIQ" , _ndMerc            ,NIL},;
				 {"LQ_NROPCLI", "        "         ,NIL},;
				 {"LQ_DTLIM"  , dDatabase          ,NIL},;
				 {"LQ_DINHEIR", nDinheiro          ,NIL},;
				 {"LQ_CARTAO" , nCartaoC + nCartaoD,NIL},;
				 {"LQ_CHEQUES", nCheque            ,NIL},;
				 {"LQ_OUTROS" , nOutros            ,NIL},;
				 {"LQ_FINANC" , nCredito           ,NIL},;
				 {"LQ_EMISSAO", dDatabase          ,NIL},;
				 {"LQ_NUMCFIS", _cdDoc             ,NIL},;				 
				 {"LQ_VLRDEBI", 0                  ,NIL},;
				 {"LQ_HORA"   , ""                 ,NIL},;
				 {"LQ_NUMMOV" , "1"                ,NIL} }
			
			
	_aItem := {}
	
	If Type("_odNfe:_INFNFE:_DET") == "O"
	   oProd := _odNfe:_INFNFE:_DET:_Prod
	   
	   cProduto := oProd:_cProd:TEXT
	   nQuant   := Val( oProd:_qCom:TEXT )
	   cUM      := oProd:_uCom:TEXT
	   nVDesc   := iIf(Type("oProd:_vDesc:TEXT") != "U",Val( oProd:_vDesc:TEXT  ),0)
	   nVProd   := Val( oProd:_vProd:TEXT  )
	   nVUnit   := Round(nVProd / nQuant ,2 )
	   nDesc    := Round(nVDesc / nVProd * 100,2)
	   
	   
	aAdd(_aItem,{ {"LR_ITEM"   , StrZero(01,2)      ,NIL},;
				  {"LR_PRODUTO", cProduto           ,NIL},;
				  {"LR_QUANT"  , nQuant             ,NIL},;
				  {"LR_VRUNIT" , nVUnit             ,NIL},;
				  {"LR_VLRITEM", nVProd             ,NIL},;
				  {"LR_UM"     , cUM                ,NIL},;				  
				  {"LR_VALDESC",    nVDesc          ,NIL},;
				  {"LR_DOC"    ,   _cdDoc           ,NIL},;
				  {"LR_SERIE"  ,   _cdSerie         ,NIL},;
				  {"LR_PDV"    ,   "0001"           ,NIL},;
				  {"LR_TABELA" ,   "1"              ,NIL},;
				  {"LR_DESCPRO",    0               ,NIL},;
				  {"LR_FILIAL" ,   xFilial("SLR")   ,NIL},;
				  {"LR_VEND"   ,   "000099"         ,NIL} })
	ElseIf Type("_odNfe:_INFNFE:_DET") == "A"
	    For _xdI := 01 To Len(_odNfe:_INFNFE:_DET)
		    oProd := _odNfe:_INFNFE:_DET[_xdI]:_Prod
	   
		    cProduto := oProd:_cProd:TEXT
	        nQuant   := Val( oProd:_qCom:TEXT )
	        cUM      := oProd:_uCom:TEXT
	        nVDesc   := iIf(Type("oProd:_vDesc:TEXT") != "U",Val( oProd:_vDesc:TEXT  ),0)
	        
	        nVProd   := Val( oProd:_vProd:TEXT  )
	        nVUnit   := Round(nVProd / nQuant ,2 )
	        nDesc    := Round(nVDesc / nVProd * 100,4)
	   
	   
	        aAdd(_aItem,{ {"LR_ITEM"   , StrZero(_xdI,2)    ,NIL},;
			              {"LR_PRODUTO", cProduto           ,NIL},;
						  {"LR_QUANT"  , nQuant             ,NIL},;
				          {"LR_VRUNIT" , nVUnit             ,NIL},;
				          {"LR_VLRITEM", nVProd             ,NIL},;
				          {"LR_UM"     , cUM                ,NIL},;				          
				          {"LR_VALDESC",    nVDesc          ,NIL},;				          
				          {"LR_DOC"    ,   _cdDoc           ,NIL},;
				          {"LR_SERIE"  ,   _cdSerie         ,NIL},;
				          {"LR_PDV"    ,   "0001"           ,NIL},;
				          {"LR_TABELA" ,   "1"              ,NIL},;
				          {"LR_DESCPRO",    0               ,NIL},;
				          {"LR_FILIAL" ,   xFilial("SLR")   ,NIL},;
				          {"LR_VEND"   ,   "000099"         ,NIL} })
	    Next
	EndIf
	
	_aParcela := {}
	
	If nDinheiro > 0
	aAdd(_aParcela,{{"L4_DATA"   , dDatabase        ,NIL},;
				    {"L4_VALOR"  , nDinheiro        ,NIL},;
					{"L4_FORMA"  , "R$            " ,NIL},;
					{"L4_ADMINIS", "              " ,NIL},;
					{"L4_FORMAID", "C"              ,NIL},;
					{"L4_MOEDA"  , 0                ,NIL}} )
    EndIf
	
	If nCheque > 0	   
	   aAdd(_aParcela,{{"L4_DATA"   ,dDatabase          ,NIL},;
				       {"L4_VALOR"  ,nCheque            ,NIL},;
					   {"L4_FORMA"  ,"CH"               ,NIL},;
					   {"L4_ADMINIS", "001 "    ,NIL},;
					   {"L4_FORMAID", "C "              ,NIL},;    
					   {"L4_MOEDA"  , 0                 ,NIL}}) 	   	  
    EndIf
	
	If nCartaoC > 0	   
	   aAdd(_aParcela,{{"L4_DATA"   ,dDatabase          ,NIL},;
				       {"L4_VALOR"  ,nCartaoC           ,NIL},;
					   {"L4_FORMA"  ,"CC"               ,NIL},;
					   {"L4_ADMINIS", "500 - ADMRECOVERY CC",NIL},;
					   {"L4_FORMAID", "C "              ,NIL},;
					   {"L4_MOEDA"  , 0                 ,NIL}})
	EndIf
	
	If nCartaoD > 0	   
	   aAdd(_aParcela,{{"L4_DATA"   , dDatabase         ,NIL},;
				       {"L4_VALOR"  , nCartaoD          ,NIL},;
					   {"L4_FORMA"  , "CD"              ,NIL},;
					   {"L4_ADMINIS", "501 - ADMRECOVERY CD",NIL},;
					   {"L4_FORMAID", "C "              ,NIL},;
					   {"L4_MOEDA"  , 0                 ,NIL}})    
	EndIf
	
	If nCredito > 0	   
	   aAdd(_aParcela,{{"L4_DATA"   ,dDatabase          ,NIL},;
				       {"L4_VALOR"  ,nCredito           ,NIL},;
					   {"L4_FORMA"  ,"BO"               ,NIL},;
					   {"L4_ADMINIS", "009 - BOLETO"    ,NIL},;
					   {"L4_FORMAID", "C "              ,NIL},;
					   {"L4_MOEDA"  , 0                 ,NIL}})
	EndIf
	
	If nOutros > 0	   
	   aAdd(_aParcela,{{"L4_DATA"   ,dDatabase          ,NIL},;
				       {"L4_VALOR"  ,nOutros            ,NIL},;
					   {"L4_FORMA"  ,"CN"               ,NIL},;
					   {"L4_ADMINIS", "            "    ,NIL},;
					   {"L4_FORMAID", "C "              ,NIL},;
					   {"L4_MOEDA"  , 0                 ,NIL}})
	EndIf
    Private lMsHelpAuto := .T. // Variavel de controle interno do ExecAuto
	Private lMsErroAuto := .F. // Variavel que informa a ocorrência de erros no ExecAuto
		
	SetFunName("LOJA701")
	Private Inclui := .T.
	
	MSExecAuto({|a,b,c,d,e,f,g,h| Loja701(a,b,c,d,e,f,g,h)},.F.,3,"","",{},_aCab,_aItem ,_aParcela)
	_cdSucess := _cdPath + "Sucesso"
	_cdErro   := _cdPath + "Erro"
	
	If !ExistDir(_cdSucess)
	   MakeDir(_cdSucess)	   
	EndIf
	_cdSucess = Alltrim(_cdSucess) + "\" 
	
	If !ExistDir(_cdErro)
	   MakeDir(_cdErro)	   
	EndIf
	_cdErro = Alltrim(_cdErro) + "\"
		
	If lMsErroAuto 
	    //Alert("Erro no ExecAuto")
	    MOSTRAERRO()         
		DisarmTransaction() 
		// Libera sequencial 
		RollBackSx8() 
		_ldOK := .F.
		
		_xdFile := StrTokArr(_cdFile,"\")
		_xdFile := _xdFile[Len(_xdFile)]
		fRename(_cdPath + _cdFile , _cdErro + _xdFile )
	Else
	    //Alert("Sucesso na execução do ExecAuto")
		_ldOK := .T.
		
		_xdFile := StrTokArr(_cdFile,"\")
		_xdFile := _xdFile[Len(_xdFile)]
		fRename(_cdPath + _cdFile , _cdSucess + _xdFile )
	EndIf
	If _ldOk 
	   SL1->(dbSetOrder(1))
	   SL1->(dbSeek(xFilial('SL1') + cNumOrc))	   
	   SL1->(RecLock("SL1",.F.))	   
		   SL1->L1_DOC    := _cdDoc
		   SL1->L1_SERIE  := _cdSerie
		   SL1->L1_PDV    := iIf( _cdSerie == '101',"0003","0004")
		   SL1->L1_OPERADO:= iIf( _cdSerie == '101',"C42","C53")
		   SL1->L1_SITUA  := 'RX'
		   SL1->L1_STORC  := " "
		   SL1->L1_CONDPG := "CN"
		   SL1->L1_IMPRIME:= "5S"
		   SL1->L1_HORA   := _cHoraEmi
		   SL1->L1_TPFRET := "F"
		   SL1->L1_CGCCLI := _cdCgc
		   SL1->L1_KEYNFCE:= _cdCvh	   
	   SL1->(MsUnlock())
    	   	   	   
	EndIf
		
Return _ldOk



Static Function FormatXml(__cdXml,_cdTp)
   _xdXml  := " "
   _xdNfe  := '<NFe xmlns="http://www.portalfiscal.inf.br/nfe"> '
   _xdXml  := __cdXml
   _xdPos1 := At(_xdXml,"<NFe>")
   //_xdXml  := Replace(__cdXml,"<NFe>",_xdNfe)   
   _xdPos2 := At(_xdXml,"</infNFe>")
   _xdXml  := SubString(_xdXml,_xdPos1,_xdPos2 - _xdPos1 + 9)
   
   if _cdTp == "ERP"
      _xdXml := "</NFe>"
   ElseIf _cdTp == "SIG"
       _xdPos1 := At(Upper(__cdXml),Upper("<Signature") )
	   _xdPos2 := At(Upper(__cdXml),Upper("</Signature>") )
	   	   
      _xdXml += SubString(__cdXml,_xdPos1,_xdPos2 - _xdPos1 + 12)
   EndIf
   
Return _xdXml 


Static Function CreateParm()

	SX6->(RecLock('SX6',.T.))
	SX6->X6_FIL := cFilAnt
	SX6->X6_VAR := 'MV_XAFATX08'
	SX6->X6_TIPO := 'C'
	SX6->X6_DESCRIC := 'Define o Valor do Ultimo Arquivo Importado'
	SX6->X6_PROPRI := 'U'
	SX6->(MsUnlock())


	SX6->(RecLock('SX6',.T.))
	SX6->X6_FIL := cFilAnt
	SX6->X6_VAR := 'MV_XBFATX08'
	SX6->X6_TIPO := 'C'
	SX6->X6_DESCRIC := 'Define o Valor do Ultimo Diretorio Importado'
	SX6->X6_PROPRI := 'U'
	SX6->(MsUnlock())
	Return

/*	
User Function LJ7014()
	   aPgto := PARAMIXB[04]
	    
Return .F.
*/



User function RepositArq()
Local cEntry
Local cFile

Prepare environment Empresa '01' FILIAL '01'

aEval(GetResArray('*.BMP'),{|x|Resource2File(x,"\images\"+x)})
/*	
cEntry := 'BR_VERMELHO_OCEAN.bmp'
cFile  := '\images\BR_VERMELHO.bmp'
lExtractt := Resource2File(cEntry,cFile)
 If lExtractt
      alert('Extração realizada')
 Else
      alert('Extração nao realizada')
      
 EndIf
*/
Return
