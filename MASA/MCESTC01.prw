#Include "Protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MCESTC01   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 16/05/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descrição ¦ Rotina para consulta dos apontamentos / endereçamentos        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MCESTC01()
	Local oDlg, aPosObj, aSize, oOk, oNo
	Local aCabec := {}
	Local cLinha := ""
	
	Private nInd
	Private cInd := CriaTrab( Nil ,.F.)
	
	PRIVATE aRotina := {	{"Pesquisar" ,"AxPesqui"  , 0 , 1},;
								{"Visualizar","A265Visual", 0 , 2} }
	PRIVATE cCadastro := OemToAnsi("Distribuição de Produtos")
	
	oOk    := LoadBitmap( GetResources(), "BR_VERDE" )
	oNo    := LoadBitmap( GetResources(), "BR_VERMELHO" )
	
	AAdd( aCabec , "" )
	cLinha := "{|| { Iif(SDA->DA_SALDO>0,oOk,oNo)"
	
	SX3->(dbSetOrder(1))
	SX3->(dbSeek("SDA",.F.))
	While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == "SDA"
		If SX3->X3_BROWSE == "S"
			AAdd( aCabec , Trim(X3Titulo()) )
			cLinha += ",SDA->" + Trim(SX3->X3_CAMPO)
		Endif
		SX3->(dbSkip())
	Enddo
	
	AAdd( aCabec , "Etiqueta" )
	cLinha += ",Posicione('SD3',3,XFILIAL('SD3')+SDA->DA_PRODUTO+SDA->DA_LOCAL+SDA->DA_NUMSEQ,'D3_XETIQUE')"
	AAdd( aCabec , "Quantidade" )
	cLinha += ",Posicione('SD3',3,XFILIAL('SD3')+SDA->DA_PRODUTO+SDA->DA_LOCAL+SDA->DA_NUMSEQ,'D3_QUANT')"
	
	cLinha += "} }"
	bLinha := &(cLinha)
	
	dbSelectArea("SDA")
	IndRegua("SDA",cInd,"DA_FILIAL+DTOS(DA_DATA)+DA_NUMSEQ",,,"Gerando indice temporario...") 
	nInd := RetIndex("SDA")
	dbSetOrder(nInd+1)
	dbGoBottom()
	
	PosObjetos(@aSize,@aPosObj)
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 TO aSize[6],aSize[5] PIXEL OF oMainWnd
	
	oLbx := TWBrowse():New( aPosObj[1,1],aPosObj[1,2],aPosObj[1,4],aPosObj[1,3]-aPosObj[1,1],bLinha,aCabec,,oDlg,;
									SDA->(IndexKey(nInd+1)),,,/*{|| Apertou() }*/,/*Selecionou*/,,/*oFont*/,,,,,,"SDA",.T.,,,,,)
	
	oLbx:SetFocus()
	
	SDA->(dbGoTop())
	oLbx:GoTop()
	oLbx:Refresh()
	
	DEFINE Timer oTimer Interval 1000 ACTION ( TmBrowse(oLbx,oTimer) ) Of GetWndDefault()
	oTimer:Activate()
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT ( EnchoiceBar(oDlg, {|| nOpcA:=1,If(nOpcA==1,oDlg:End(),) }, {|| oTimer:Deactivate(),nOpcA:=0,oDlg:End()} ) )
	
	RetIndex("SDA")
	FErase(cInd+OrdBagExt())
Return

Static Function TmBrowse(oObjBrow,oTimer)
	
	oTimer:Deactivate()
	
	oLbx:SetFocus()
	
	SDA->(dbGoBottom())
	oLbx:GoBottom()
	oLbx:Refresh()
	
	oTimer:Activate()
Return .T.

Static Function PosObjetos(aSize,aPosObj)
	Local aInfo
	Local aObjects := {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	//AAdd( aObjects, { 100, 040, .t., .f. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
Return
