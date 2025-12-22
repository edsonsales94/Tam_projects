#Include 'Protheus.ch'
#Include 'Rwmake.ch'
#Include 'TOTVS.ch'
#Include 'ACDA100.ch'
#DEFINE ENTER Chr(13) + Chr(10)

Static cPA2_COD
Static nAcao := 0

/*/{Protheus.doc} AASEPA01

@author Arlindo Neto
@since 19/01/2018
@version 1.0		

@return ${return}, ${return_description}

@description

long_description

@example

(examples)

@see (links_or_references)

/*/
User Function AASEPXXX()
    MsApp():New("SIGAEST")
    oApp:CreateEnv()
    //PtSetTheme("SUNSET")
    //u_AAFINR01("1","000046348",,.T.) 
    //u_AAFINR01()
    //Define o programa de inicialização 
    oApp:cStartProg    := 'u_AASEPA01'
 
    //Seta Atributos 
    __lInternet := .T.
    
    oApp:Activate()

Return 

Static Function ModelDef()
	Local oStruPA1 := FWFormStruct( 1, 'PA1' )
	Local oStruPA2 := FWFormStruct( 1, 'PA2' )
	Local oModel   := Nil

	oModel := MPFormModel():New('MAASEPA01' )
	
	oModel:AddFields( 'PA1MASTER', /*cOwner*/, oStruPA1)
	oModel:GetModel( 'PA1MASTER' ):SetDescription( 'Dados de Ordem de Carregamento' )
	oModel:SetPrimaryKey( {} )
	//oModel:AddFields( 'PA2DETAIL', /*cOwner*/, oStruSL1)
	oModel:AddGrid( 'PA2GRID', 'PA1MASTER', oStruPA2)
	oModel:GetModel( 'PA2GRID' ):SetDescription( 'Itens da Ordem de Carregamento' )

	oModel:SetRelation('PA2GRID', { { 'PA1_FILIAL', 'PA2_FILIAL' }, { 'PA1_NUM', 'PA2_NUM'} }, "PA2_FILIAL+PA2_NUM+PA2_ITEM" )

Return oModel

Static Function ViewDef()
    Local oView 
    Local oModel
	Local oStruPA2
	Local oStruPA1

	oStruPA1 := FWFormStruct( 2, 'PA1' ,{|cCampo|  !Alltrim(cCampo)$""})
	oStruPA2 := FWFormStruct( 2, 'PA2' ,{|cCampo|  !Alltrim(cCampo)$""})
	oModel   := FWLoadModel( 'AASEPA01' )

	oView :=  FWFormView():New()
	oView:SetModel( oModel )
	
	oView:AddField( 'VIEW_PA1', oStruPA1, 'PA1MASTER' )
	//oView:AddGRID( 'VIEW_SC2', oStruD1, 'MGRIDSC2' )
	oView:AddGRID( 'VIEW_PA2', oStruPA2, 'PA2GRID' )
	oView:AddIncrementField( 'VIEW_PA2', 'PA2_ITEM' )
	//STRZERO(LEN(ACOLS),2)
	oView:CreateHorizontalBox( 'TELA' , 40 )
	oView:CreateHorizontalBox( 'GRID' , 60 )
	
	oView:SetOwnerView( 'VIEW_PA1', 'TELA' )
	oView:SetOwnerView( 'VIEW_PA2', 'GRID' )

	oView:EnableTitleView('VIEW_PA2')

Return oView

User Function AASEPA01()
	Private cCadastro	:= "Ordem de Carregamento"
	Private cAlias		:= "PA1"
	Private cAlias1     := "PA2"
	Private nTotal    	:= 0
	Private aRotina   	:= {{"Pesquisar" 				,"AxPesqui"     ,0,1} ,;
	{"Visualizar"				,"u_ASE01Vis"	,0,2} ,;
	{"Incluir"   				,"u_ASE01Inc"	,0,3} ,;
	{"Alterar"   				,"u_ASE01Alt"	,0,4} ,;
	{"Excluir"   				,"u_ASE01Vis"	,0,5} ,;
	{"Legenda"   				,"u_ASEP01Leg"	,0,6} ,;
	{"Imprimir"  				,"u_AAFATR03"	,0,7} ,;
	{"Ger. Separacao"  			,"u_fGrava"		,0,8} ,;
	{"Comprovante de Entrega"  	,"u_AAASEPM"	,0,9} ,;
	{"Observacao Pedido"  	    ,"u_SepObserv"	,0,10},;
	{"Estornar Separação"  	    ,"u_FEstornaLista",0,11 },;
	{"Finalizar Ordem"  	    ,"u_FinalOrd"	,0,12}}

	Private aCores  := {{"PA1_STATUS=='1'","BR_AMARELO"},; //Pre carregamento
	{"PA1_STATUS=='2'","BR_VERDE"},;     //Em Separação
	{"PA1_STATUS=='3'","BR_VERMELHO"},;	//Sep. Finalizada
	{"PA1_STATUS=='4'","BR_AZUL"}}   	//Sep. Nao Iniciada


	dbSelectArea(cAlias)
	dbSetOrder(1)

	mBrowse( 6,1,22,75,cAlias,,,,,,aCores)

Return
User Function AAASEPM( )
	U_AAACDR01("", "", , , ,.F.,PA1->PA1_NUM)
Return Nil

User Function SepObserv()
	Local cPedido := PA1->PA1_PEDIDO
	SC5->(DbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5")+cPedido))

	fwObserv(cPedido)

Return 

User Function FinalOrd()
If PA1->PA1_STATUS=="3"
	Aviso(FunName(),"Ordem de separação já finalizada!",{"OK"})
Else
	PA2->(DbSetOrder(1))
	If PA2->(DbSeek(xFilial("PA2")+PA1->PA1_NUM))
		If PA2->PA2_LOCAL=="14"
			Aviso(FunName(),"Ordens para o armazém 14 não podem ser finalizadas utlizando esta rotina!",{"OK"})
		EndIf
	Else
		RecLock("PA1",.F.)
			PA1->PA1_STATUS := "3"
		MsUnlock()
	EndIf
EndIf

Return 

Static Function fwObserv(cPedido)
	Private mInf1	:= SC5->C5_OBSENT1
	Private mInf2	:= SC5->C5_OBSENT2
	//mInf3	:= M->C5_XOBS3

	@ 96,100 To 300,550 Dialog oMen Title "Observações Pedido de Venda " + SC5->C5_NUM

	@ 010,010 Say "Obs. Ent. 1: "
	@ 010,045 Get mInf1 Size 147,90  WHEN .F.


	@ 025,010 Say "Obs. Ent. 2: "
	@ 025,045 Get mInf2 Size 147,90 

	@ 050,180 BmpButton Type 1 Action (u_AAAOBSSE(),oMen:End())
	Activate Dialog oMen

Return

User Function AAAOBSSE()

	RecLock("SC5",.F.)
	SC5->C5_OBSENT1  := mInf1
	SC5->C5_OBSENT2  := mInf2
	MsUnlock()
Return


User Function ASE01Inc(cAlias, nRecNo, nOpc )
	Local nX        	:= 0
	Local nOpcA     	:= 0
	Local oMainWnd  	:= Nil
	Private aAltera   	:= {}
	Private cCadastro 	:="Ordem de Carregamento"
	Private oDlg    	:= Nil
	Private oGet    	:= Nil
	Private aTela   	:= {}
	Private aGets   	:= {}
	Private aHeader 	:= {}
	Private aCols   	:= {}
	Private bCampo  	:= { |nField| Field(nField) }
	Private Inclui  	:= .F.
	Private Altera  	:= .T.
	Private nPD     	:= 1
	Private cFilPA2   	:= (cAlias1)->(xFilial(cAlias1))
	Private aSize
	Private aPosObj
	Private lNovo 		:= (nOpc==3)
	Private oEnch       := Nil


	nTotal := 0 

	// Inicia as variaveis para Enchoice
	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbGoTo(nRecNo)

	Set Key VK_F4 TO ShowF4()

	RegToMemory("PA1",.T.)

	//Pega a próxima numeração da tabela de regra de comissão
	M->PA1_NUM := GetSX8Num("PA1","PA1_NUM")
	//Função para capturar as dimensões da tela
	PosObjetos(@aSize,@aPosObj)

	// Monta os aCols
	MontaaCols(@aAltera,nOpc==3,cAlias1)


	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	EnChoice(cAlias, nRecNo, nOpc,,,,,{aPosObj[1,1]+30,aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]},, 3,,,,oDlg)

	oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_ASE01LinOk()","AlwaysTrue","+PA2_ITEM",.T.,,,,999,,,, "u_ASE01DelOk()",oDlg)

	//	MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita, nOpc,;							cLinOk,cTudoOk,cIniCpos,aAlterGDa,nFreeze,nMax,cFieldOk, cSuperDel,;							cDelOk, oDLG, aHeader, aCols)
	@ aPosObj[3,1],(aPosObj[3,4]*0.77) SAY "Total Já Carregado:" COLOR CLR_HBLUE 
	@ aPosObj[3,1],(aPosObj[3,4]*0.77)+55 MSGET oEnch Var nTotal Picture PesqPict("PA2","PA2_QUANT")  SIZE 70, 10 OF oDlg PIXEL WHEN .F.

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| nOpcA :=If( Obrigatorio(aGets,aTela) .And. u_ASE01TudOk(),1,0),If(nOpcA==1,oDlg:End(),) }, {||nOpcA:=0,oDlg:End()} )

	//Caso confirme
	If nOpcA == 1
		Begin Transaction
			ASE01Grava(nOpc,nRecNo)
		End Transaction
	Else
		RollBackSX8()
	EndIf

	SC5->(MsUnLock())
Return



User Function ASE01Alt(cAlias, nRecNo, nOpc )
	Local nX        	:= 0
	Local nOpcA     	:= 0
	Local oMainWnd  	:= Nil
	Private aAltera   	:= {}
	Private cCadastro 	:="Ordem de Carregamento"
	Private cAlias1 	:= "PA2"
	Private oDlg    	:= Nil
	Private oGet    	:= Nil
	Private aTela   	:= {}
	Private aGets   	:= {}
	Private aHeader 	:= {}
	Private aCols   	:= {}
	Private bCampo  	:= { |nField| Field(nField) }
	Private Inclui  	:= .F.
	Private Altera  	:= .T.
	Private nPD     	:= 1
	Private cFilPA2   	:= (cAlias1)->(xFilial(cAlias1))
	Private aSize
	Private aPosObj
	Private lNovo 		:= (nOpc==3)
	Private oEnch       := Nil


	nTotal := 0 
	// Inicia as variaveis para Enchoice
	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbGoTo(nRecNo)

	If PA1->PA1_STATUS!="1"
		Aviso(FunName(),"Só é permitido Alteração para Ordens que estão com o Status de Pré-Carregamento!",{"OK"})
		Return
	EndIf

	Set Key VK_F4 TO ShowF4()

	For nX:= 1 To FCount()
		M->&(Eval(bCampo,nX)) := FieldGet(nX)
	Next nX
	/*
	M->PA3_CODREG := PA3_CODREG
	M->PA3_DESC   := PA3_DESC
	M->PA3_DTVAL  := PA3_DTVAL*/

	//Função para capturar as dimensões da tela
	PosObjetos(@aSize,@aPosObj)

	// Monta os aCols
	MontaaCols(aAltera,nOpc==3,cAlias1)
	SC5->(dbSetOrder(1))
	SC5->(dbSeek(xFilial("SC5")+PA1->PA1_PEDIDO))

	If !RecLock("SC5", .F.)
	   Aviso(FunName(),"O Pedido "+SC5->C5_NUM+" Está Bloqueado para Uso Selecione Outro",{"OK"})
	   Return
	EndIf

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	EnChoice(cAlias, nRecNo, nOpc,,,,,{aPosObj[1,1]+30,aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]},, 3,,,,oDlg)


	oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_ASE01LinOk()","AlwaysTrue",,.T.,,,,999,,,,"u_ASE01DelOk()",)
	//oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_ASE01LinOk()","AlwaysTrue","+PA2_ITEM",.T.,,,,999,,,, "u_ASE01DelOk()",)
	@ aPosObj[3,1],(aPosObj[3,4]*0.77) SAY "Total Já Carregado:" COLOR CLR_HBLUE 
	@ aPosObj[3,1],(aPosObj[3,4]*0.77)+55 MSGET oEnch Var nTotal Picture PesqPict("PA2","PA2_QUANT")  SIZE 70, 10 OF oDlg PIXEL WHEN .F.

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| nOpcA :=If( Obrigatorio(aGets,aTela),1,0),If(nOpcA==1,oDlg:End(),) }, {||nOpcA:=0,oDlg:End()} )

	//Caso confirme
	If nOpcA == 1
		Begin Transaction
			ASE01Grava(nOpc,nRecNo,aAltera)
		End Transaction
	EndIf
	SC5->(MsUnlock())
Return

User Function ASE01Vis(cAlias, nRecNo, nOpc )
	Local nX        	:= 0
	Local nOpcA     	:= 0
	Local oMainWnd  	:= Nil
	Private aAltera   	:= {}
	Private cCadastro 	:="Ordem de Carregamento"
	Private cAlias1 	:= "PA2"
	Private oDlg    	:= Nil
	Private oGet    	:= Nil
	Private aTela   	:= {}
	Private aGets   	:= {}
	Private aHeader 	:= {}
	Private aCols   	:= {}
	Private bCampo  	:= { |nField| Field(nField) }
	Private Inclui  	:= .F.
	Private Altera  	:= .T.
	Private nPD     	:= 1
	Private cFilPA2   	:= (cAlias1)->(xFilial(cAlias1))
	Private aSize
	Private aPosObj
	Private lNovo 		:= (nOpc==3)
	Private oEnch       := Nil


	If nOpc == 5 
		If PA1->PA1_STATUS!="1"
			Aviso(FunName(),"Só é permitido a Exclusão para Ordens que estão com o Status de Pré-Carregamento!",{"OK"})
			Return
		EndIf
	EndIf

	nTotal := 0 
	// Inicia as variaveis para Enchoice
	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbGoTo(nRecNo)

	For nX:= 1 To FCount()
		M->&(Eval(bCampo,nX)) := CriaVar(FieldName(nX),.T.)
	Next nX


	//Função para capturar as dimensões da tela
	PosObjetos(@aSize,@aPosObj)

	// Monta os aCols
	MontaaCols(@aAltera,nOpc==3,calias1)


	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	EnChoice(cAlias, nRecNo, nOpc,,,,,{aPosObj[1,1]+30,aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]},, 3,,,,oDlg)

	oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_ASE01LinOk()",,,.T.,,,,999,,,,,)
	@ aPosObj[3,1],(aPosObj[3,4]*0.77) SAY "Total Já Carregado:" COLOR CLR_HBLUE 
	@ aPosObj[3,1],(aPosObj[3,4]*0.77)+55 MSGET oEnch Var nTotal Picture PesqPict("PA2","PA2_QUANT")  SIZE 70, 10 OF oDlg PIXEL WHEN .F.

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| nOpcA :=1,If(nOpcA==1,oDlg:End(),) }, {||nOpcA:=0,oDlg:End()} )

	//Caso confirme
	If nOpcA == 1 .And. nOpc == 5
		Begin Transaction

			ASE01Grava(nOpc,nRecNo,aAltera)
		End Transaction
	EndIf
Return

Static Function MontaaCols(aAltera,lNovo,cAlias1)
	Local nCols, nUsado, nX
	Local nPosVlr	:= 0
	Local nPosSld   := 0
	Local aCampos 	:= {}
	//Monta o aHeader
	CriaHeader(lNovo)

	AAdd( aCampos , { "PA2_DESC"	, 	{|| SB1->B1_DESC          					 	  	    }} )
	AAdd( aCampos , { "PA2_XSALDO"	, 	{|| u_AASEPA1S()                                        }} )	
	AAdd( aCampos , { "PA2_ESTAT"	, 	{|| CalcEst(SB1->B1_COD,"14",dDatabase+1)[1]			}} )
	AAdd( aCampos , { "PA2_ESTSEP"	, 	{|| u_FSaldSepIt(SB1->B1_COD)							}} )

	nPosVlr := aScan(aHeader,{|x| Trim(x[2])=="PA2_QUANT"})
	nPosSld := aScan(aHeader,{|x| Trim(x[2])=="PA2_SALDO"})
	// Monta o aCols com os dados referentes a tabela de comissão
	nCols  := 0
	nUsado := Len(aHeader)

	If !lNovo
		dbSelectArea(cAlias1)
		//PA1_FILIAL + PA1_NUM
		(cAlias1)->(dbSetOrder(3))
		(cAlias1)->(DbSeek(xFilial(cAlias1)+(cAlias)->PA1_NUM))

		While (cAlias1)->(!Eof()) .And. (cAlias1)->(PA2_FILIAL+PA2_NUM)==(cAlias)->(PA1_FILIAL+PA1_NUM)

			aAdd(aCols,Array(nUsado+1))
			nCols ++
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+(cAlias1)->PA2_COD))
			For nX := 1 To nUsado
				nPos := AScan( aCampos , {|x| x[1] == Trim(aHeader[nX,2]) } )
				If ( aHeader[nX][10] != "V")
					M->&(aHeader[nX,2]) := aCols[nCols,nX] := (cAlias1)->(FieldGet(FieldPos(aHeader[nX,2]))) 				
				Else
					aCols[nCols][nX] := Iif(Alltrim(aHeader[nX,2])$"PA2_DESC/PA2_ESTAT/PA2_ESTSEP/PA2_XSALDO",Eval(aCampos[nPos,2]),(cAlias1)->(FieldGet(FieldPos(aHeader[nX,2]))))
				Endif
			Next nX
			aCols[nCols][nUsado+1] := .F.

			AAdd( aAltera , (cAlias1)->(Recno()) )
			(calias1)->(dbSkip())
		Enddo
	Else


	EndIf

	If Empty(aCols)  // Caso nao tenha itens no Alias
		// Monta o aCols com uma linha em branco
		aColsBlank(cAlias1,@aCols,nUsado)
	Else
		For nX:=1 To Len(aCols)
			nTotal += aCols[nX,nPosVlr]
		Next nX
	Endif

Return .T.

Static Function aColsBlank(cAlias1,aArray,nUsado)
    Local _nI

	aArray := {}
	aAdd(aArray,Array(nUsado+1))
	nUsado := 0
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(calias1)
	/*
	For _nI :=  1 To Len(aHeader)
	   If FieldPos(aHeader[_nI][02]) > 0
	   Else 
	      aArray[1][_nI] := 0
	   EndIf
	Next
	*/
	While !Eof() .And. SX3->X3_ARQUIVO == cAlias1	    
		If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
			nUsado++
			aArray[1][nUsado] := CriaVar(Trim(SX3->X3_CAMPO),.T.)
		Endif
		dbSkip()
	Enddo
	aArray[1][nUsado+1] := .F.

Return


//----------------------------------------------------------
/*/{Protheus.doc} CriaHeader
Função para preencher a variável aHeader para montagem do cabeçalho do aCols
@param Não se aplica
@return Não se aplica
@since 19/01/2018
@author Arlindo Neto
@owner Amazon Aço

/*/
//----------------------------------------------------------

Static Function CriaHeader()
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(calias1)
	While ( !Eof() .And. SX3->X3_ARQUIVO == calias1 )
		If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
			aAdd(aHeader,{ Trim(X3Titulo()), ;
			SX3->X3_CAMPO   , ;
			SX3->X3_PICTURE , ;
			SX3->X3_TAMANHO , ;
			SX3->X3_DECIMAL , ;
			"u_ASE01Valid()", ;
			SX3->X3_USADO   , ;
			SX3->X3_TIPO    , ;
			SX3->X3_ARQUIVO , ;
			SX3->X3_CONTEXT } )
		Endif
		dbSkip()
	Enddo

Return

User Function AASEPA1S(xPed,xCod,xIg)
    Local xQry := ""

	xQry += " Select Sum(PA2_QUANT) PA2_QUANT From " + RetSqlName("PA2") + " PA2 "
	xQry += "  Inner Join " + RetSqlName("PA1") + " PA1 on PA1_FILIAL='"+xFilial("PA1")+"' And PA1_NUM = PA2_NUM And PA1_PEDIDO = '" + PA1->PA1_PEDIDO + "' ANd PA1.D_E_L_E_T_ = '' "
	xQry += " Where PA2_FILIAL = '" + xFilial("PA2") + "'"
	xQry += " And PA2_COD = '" + PA2->PA2_COD + "'"
	xQry += " And PA2_ITEMPD = '" + PA2->PA2_ITEMPD + "'"
	xQry += " And PA2_NUM != '" + PA1->PA1_NUM + "'"
	xQry += " And PA2.D_E_L_E_T_ = ' '"
    
	xTbl := MpSysOpenQuery(xQry)
	xValor := (xTbl)->PA2_QUANT

Return PA2->PA2_QTDORI - xValor

//----------------------------------------------------------
/*/{Protheus.doc} ASSE01Grava
Função para fazer a gravação dos dados na tabela PA1 - Ordem de Carregamento
@param nOpc - Opção de alteração
@return Não se aplica
@since 19/01/2018
@author Arlindo Neto
@owner Amazon Aço

/*/
//----------------------------------------------------------
User Function ASE01Valid()
	Local nPosSLd	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_SALDO"})
	Local nPosXSLd	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_XSALDO"})
	Local nPosQTO	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_QTDORI"})
	Local nPosVlr	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_QUANT"})
	Local nPosCod	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_COD"})
	Local lRet		:= .T.
	Local nDel := Len(aHeader) + 1

	nTotal := 0
	If ReadVar()=="M->PA2_COD"
		If CalcEst(M->PA2_COD,"14",dDatabase)[1]<=0
			Aviso(FunName(),"O produto não possui Saldo em estoque suficiente para este Carregamento!",{"OK"})
			lRet := .F.
		EndIf
	ElseIf ReadVar()=="M->PA2_QUANT"
		If CalcEst(aCols[n,nPosCod],"14",dDatabase)[1]<=0
			Aviso(FunName(),"O produto não possui Saldo em estoque suficiente para este Carregamento!",{"OK"})
			lRet := .F.
		ElseIf aCols[n,nPosXSLd] < M->PA2_QUANT
		    Aviso(FunName(),"Saldo insuficiente para este Carregamento!",{"OK"})
			lRet := .F.
		Else
		   aCols[n,nPosSLd]:=aCols[n,nPosXSLd] - M->PA2_QUANT 
		/*
		ElseIf M->PA2_QUANT>aCols[n,nPosSLd] 
			If M->PA2_QUANT<=(aCols[n,nPosSLd]+aCols[n,nPosVlr])
				//aCols[n,nPosSLd]:=aCols[n,nPosQTO]-M->PA2_QUANT
				aCols[n,nPosSLd]:=aCols[n,nPosXSLd] - M->PA2_QUANT //aCols[n,nPosQTO]-M->PA2_QUANT
			Else	
				Aviso(FunName(),"Saldo insuficiente para este Carregamento!",{"OK"})
				lRet := .F.
			EndIf
		Else
			If M->PA2_QUANT>aCols[n,nPosVlr]
				aCols[n,nPosSLd]:=(aCols[n,nPosSLd]-(M->PA2_QUANT-aCols[n,nPosVlr]))
			ElseIf M->PA2_QUANT<aCols[n,nPosVlr] 
				If aCols[n,nPosVlr]==aCols[n,nPosSLd]
					aCols[n,nPosSLd]:=aCols[n,nPosSLd]-M->PA2_QUANT
				Else
					aCols[n,nPosSLd]:=aCols[n,nPosSLd]+(aCols[n,nPosVlr]-M->PA2_QUANT)
				EndIf
			EndIf
		*/
		EndIf
		For nX:=1 To Len(aCols)
			If !aCols[nX,nDel]
				If nX==n
					nTotal+= M->PA2_QUANT
				Else
					nTotal += aCols[nX,nPosVlr]
				EndIf
			EndIf
		Next nX
		oEnch:Refresh()
		//aTela[6]
	EndIf


Return lRet

//----------------------------------------------------------
/*/{Protheus.doc} ASSE01Grava
Função para fazer a gravação dos dados na tabela PA1 - Ordem de Carregamento
@param nOpc - Opção de alteração
@return Não se aplica
@since 19/01/2018
@author Arlindo Neto
@owner Amazon Aço

/*/
//----------------------------------------------------------

Static Function ASE01Grava(nOpc,nRecno,aAltera)
	Local nX, nY, x, nDel
    Local xdPos := 0


	//Se for inclusão
	If nOpc == 3

		//Grava os dados do cabeçalho da ordem de carregamento	
		dbSelectArea(cAlias)

		RecLock(cAlias,.T.)
		For nX := 1 To FCount()
			If "FILIAL" $ FieldName(nX)
				FieldPut(nX,xFilial(cAlias))
			Else
				FieldPut(nX,M->&(Eval(bCampo,nX)))
			Endif
		Next nX
		(cAlias)->PA1_STATUS := "1"
		MsUnLock()


		nDel := Len(aHeader) + 1
		dbSelectArea(cAlias1)
		(calias1)->(dbSetOrder(1))

		//Percorre os itens da tela para fazer as operações
		For nX := 1 To Len(aCols)
			//Verifica se está sendo feita uma deleção
			If !aCols[nX][nDel]
				(cAlias1)->(dbSetOrder(1))

				//Faz a gravação dos dados
				RecLock(cAlias1,.T.)

				(cAlias1)->PA2_FILIAL := xFilial(cAlias1)
				For nY := 1 To Len(aHeader)
					xdPos := FieldPos(Trim(aHeader[nY,2]))
				    If xdPos > 0
					   FieldPut(FieldPos(Trim(aHeader[nY,2])),aCols[nX,nY])
					EndIf
				Next nY

				(cAlias1)->PA2_NUM := M->PA1_NUM
				(cAlias1)->PA2_DATA 	:= dDataBase
				MsUnLock()
			Endif
		Next nX
		ConfirmSX8()
		u_fGrava()
	ElseIf nOpc == 4
		//Grava os dados referente a ordem de carregamento
		dbSelectArea(cAlias)
		dbGoTo(nRecNo)
		RecLock(cAlias,.F.)
		For nX := 1 To FCount()
			If "FILIAL" $ FieldName(nX)
				FieldPut(nX,xFilial(cAlias))
			Else
				FieldPut(nX,M->&(Eval(bCampo,nX)))
			Endif
		Next nX
		MsUnLock()

		//Grava os dados referente aos itens da regra de comissão
		nDel := Len(aHeader) + 1
		dbSelectArea(cAlias1)
		dbSetOrder(1)
		For nX := 1 To Len(aCols)
			// Caso os itens adicionados à mais estejam deletados, então ignora
			If Empty(aCols[nX,1]) .Or. (nX>Len(aAltera) .And. aCols[nX,nDel])
				Loop
			Endif

			//Verifica se é um novo Registro
			If nX <= Len(aAltera)
				dbGoTo(aAltera[nX])  // Posiciona no registro da Posicao
				RecLock(cAlias1,.F.)
			Else
				RecLock(cAlias1,.T.)
				PA2->PA2_FILIAL := xFilial("PA2")
				PA2->PA2_DATA 	:= dDataBase
			Endif

			//Verifica se o item atual esetá excluído
			If aCols[nX,nDel]
				dbDelete()
			Else
				For nY := 1 To Len(aHeader)
					xdPos := FieldPos(Trim(aHeader[nY,2]))
				    If xdPos > 0
					   FieldPut(FieldPos(Trim(aHeader[nY,2])),aCols[nX,nY])
					EndIf
					//FieldPut( FieldPos(Trim(aHeader[nY,2])) , aCols[nX,nY] )
				Next
				PA2->PA2_NUM := M->PA1_NUM				
			Endif

			MsUnLock()

		Next nX

		//Se for exclusão
	ElseIf nOpc == 5
		// Exclui os dados do cabeçalho 
		If MsgNoYes("Tem certeza que deseja excluir a Ordem de Carregamento?")
			dbSelectArea(cAlias)
			dbGoTo(nRecNo)

			RecLock(cAlias,.F.)
			dbDelete()
			MsUnLock()
			//Exclui os dados referente aos itens da regra de comissão
			dbSelectArea(cAlias1)
			dbSetOrder(1)
			For nX := 1 To Len(aCols)

				If !Empty(aCols[nX,2])
					dbGoTo(aAltera[nX])  // Posiciona no registro da Posicao
					RecLock(cAlias1,.F.)
					dbDelete()
					MsUnLock()
				Endif

			Next nX
		Endif
	EndIf
Return

//----------------------------------------------------------
/*/{Protheus.doc} ASE01LinOk
Função para validação de linha da Função MsGetDados.
@param não se aplica
@return lRet - Retorna se a linha pode ser inserida ou não no aCols
@since 16/12/2014
@author Arlindo Neto
@owner Amazon aço

/*/
//----------------------------------------------------------

User Function ASE01LinOk(nPos)
	Local nDel    := Len(aCols[1])
	Local nPProd  := aScan(aHeader,{|x| AllTrim(x[2])=="PA2_COD"})
	Local nPFilia := aScan(aHeader,{|x| AllTrim(x[2])=="PA2_FILIAL"})
	Local nPosVlr := aScan(aHeader,{|x| AllTrim(x[2])=="PA2_QUANT"})
	Local nPosLoc := aScan(aHeader,{|x| AllTrim(x[2])=="PA2_LOCAL"})
	Local lRet 	  := .T.

	If Inclui .Or. Altera
		nPos := If( nPos == Nil , n, nPos)
		If !aCols[nPos,nDel]
			For nX:=1 To Len(aCols[nPos])-1				
				If X3Obrigat( AllTrim(aHeader[nX,2]) ) .And. Empty(aCols[nPos,nX])
					Help(1," ","OBRIGAT")
					Return .F.
				Endif			
			Next
		Endif
	Endif

	/*For nCntFor := 1 To Len(aCols)
	If ( nCntFor != n .And. !aCols[nCntFor][nDel])
	If ( aCols[n][nPProd] == aCols[nCntFor][nPProd]) .And. (aCols[n][nPFilia]==xFilial("PA2"))
	Alert("Já existe regra de comissão para esse item: "+Alltrim(aCols[nCntFor][nPProd]))
	lRet:=.F.
	EndIf
	EndIF
	Next*/
Return(lRet)


User Function ASE01TudOk()
	Local nDel    := Len(aCols[1])
	Local lRet := .T.

	For x:=1 To Len(aCols)
		If !(lRet := u_ASE01LinOk(x))
			Exit
		Endif
	Next
Return(lRet)


//----------------------------------------------------------
/*/{Protheus.doc} PosObjetos
@param aSize - Vetor passado por parâmetro que ira identificar o tamanho da tela de acordo com
a sua resolução.
@param aPosObj - Vetor passado por parâmetro que irá conter a informação dos objetos divididos
na tela.
@return não possui
@since 19/01/2018
@author Arlindo Neto
@owner Amazon Aço

/*/
//----------------------------------------------------------

Static Function PosObjetos(aSize,aPosObj)
	Local aInfo
	Local aObjects := {}

	// Faz o calculo automatico de dimensoes de objetos     
	aSize := MsAdvSize(.F.,.F.)

	//AAdd( aObjects, { 100 , 083, .T. , .F.} )
	AAdd( aObjects, { 100 , 130, .T. , .F. } )
	AAdd( aObjects, { 100 , 100, .T. , .T. } )
	AAdd( aObjects, { 100 , 010, .T. , .F. } )


	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

Return

User Function AASEP01F3()
	Local oDlgACE
	Local oLbx1                                                               // Listbox
	Local nPosLbx := 0                                                        // Posicao do List
	Local aItems  := {}                                                       // Array com os itens
	Local nPos    := 0                                                        // Posicao no array
	Local lRet    := .F.                                                      // Retorno da funcao
	Local cVar    := ReadVar()
	Local cAlias  := Alias()
	Local bOk       := {|| lRet:= .T.,nPos := oLbx1:nAt,oDlgACE:End()}
	Local bCancel   := {|| lRet:= .F.,oDlgACE:End()}
	Local nPosIpd	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_ITEMPD"})
	Local nPosCod	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_COD"})
	Local nPosQOri	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_QTDORI"})
	Local nPosQtd	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_QUANT"})
	Local nPosIte	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_ITEM"})
	Local nPosSld	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_SALDO"})
	Local nPosLoc	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_LOCAL"})
	Local nPosQtd	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_QUANT"})
	Local nPosAtu	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_ESTAT"})
	Local nPosDes	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_DESC"})
	Local nSalTel   := 0
	Local nTotLi	:= 1  
	Local nDel 		:= Len(aHeader) + 1
	Local lAchou 	:= .F.


	If Empty(M->PA1_PEDIDO)
		Aviso(FunName(),"Informe um pedido de vendas válido no cabeçalho da ordem de carregamento!",{"OK"})
		Return 
	EndIf

	CursorWait()

	u_FDados(M->PA1_PEDIDO)

	While !CRG->(Eof())
		nSalTel := 0
		//AEval( aCols, { |x| Iif( (!x[nDel] .And. x[nPosCod]==CRG->C6_PRODUTO ),lAchou := .T.,lAchou:= .F.) } )
		lAchou := .F.
		For nX :=1 To Len(aCols)
			If !aCols[nX,nDel]
				If aCols[nX,nPosCod]==CRG->C6_PRODUTO
					lAchou := .T.
					Exit
				EndIf
			EndIf
		Next nX
		If !lAchou
			AEval( aCols, { |x| Iif( (!x[nDel] .And. x[nPosCod]==CRG->C6_PRODUTO .And. x[nPosIpd]==CRG->C6_ITEM),nSalTel += x[nPosQtd],0) } )
			If CRG->PA2_SALDO-nSalTel>0
				Aadd( aItems , {CRG->C6_FILIAL, CRG->C6_ITEM, CRG->C6_PRODUTO, CRG->C6_DESCRI, CRG->C6_QTDVEN, (CRG->PA2_SALDO-nSalTel), CRG->C6_LOCAL,CRG->FATURADO} )
			EndIf
		EndIF
		CRG->(dbSkip())
	Enddo
	dbCloseArea()
	dbSelectArea(cAlias)

	If Empty(aItems)
		Aadd(aItems,{	Space(TamSX3("C6_FILIAL")[1]), Space(TamSX3("C6_ITEM")[1]),Space(TamSX3("C6_PRODUTO")[1]),Space(TamSX3("C6_DESCRI")[1]);
		, 0,0,Space(TamSX3("C6_LOCAL")[1]),0})
	Endif

	CursorArrow()

	DEFINE MSDIALOG oDlgACE FROM  30,003 TO 360,900 TITLE "Itens dos Pedidos de Venda com saldo para carregamento" PIXEL

	@ 30,01 LISTBOX oLbx1 VAR nPosLbx FIELDS HEADER ;
	"Filial",;
	"Item",;
	"Produto",;
	"Descricao",;
	"Quantidade",;
	"Saldo a Carregar",;
	"Local",;
	"Já Faturado",;
	SIZE 450,120 OF oDlgACE PIXEL NOSCROLL
	oLbx1:SetArray(aItems)
	oLbx1:bLine:={|| {aItems[oLbx1:nAt,1],;
	aItems[oLbx1:nAt,2],;
	aItems[oLbx1:nAt,3],;
	aItems[oLbx1:nAt,4],;
	Transform(aItems[oLbx1:nAt,5],PesqPict("SC6","C6_QTDVEN")),;
	Transform(aItems[oLbx1:nAt,6],PesqPict("SC6","C6_QTDVEN")),;
	aItems[oLbx1:nAt,7],;
	Transform(aItems[oLbx1:nAt,8],PesqPict("SC6","C6_QTDVEN")) }}

	oLbx1:BlDblClick := {||(lRet:= .T.,nPos:= oLbx1:nAt, oDlgACE:End())}
	oLbx1:Refresh()

	ACTIVATE MSDIALOG oDlgACE ON INIT EnchoiceBar(oDlgACE,bOk,bCancel) CENTERED

	If lRet .And. nPos > 0 .And. nPos <= Len(aItems)
		&(cVar)     		:= aItems[nPos,3]
		cPA2_COD			:= aItems[nPos,3]
		aCols[n,nPosIpd] 	:= aItems[nPos,2]  
		aCols[n,nPosQOri]	:= aItems[nPos,5]
		aCols[n,nPosSld]	:= aItems[nPos,6]
		aCols[n,nPosLoc]	:= aItems[nPos,7]
		aCols[n,nPosQtd]	:= aItems[nPos,6]
		aCols[n,nPosAtu] 	:= CalcEst(aItems[nPos,3],"14",dDatabase+1)[1]
		aCols[n,nPosDes] 	:= Posicione("SB1",1,xFilial("SB1")+aItems[nPos,3],"B1_DESC")
		/*nPeso       := BuscaPeso(cZE_TICKET1)   // Busca o peso no Guardian
		nPesoB      := BuscaPeso2(cZE_TICKET1,"F")*/
		nTotal	+=	aItems[nPos,6]
		oEnch:Refresh()
	Endif

Return lRet


User Function AASEP01RetVal()
Return cPA2_COD

User Function AASEP01ValPd()
	Local lRet := .T.
	//Local oModel := FwModelActive()
	Local nUsado:= Len(aCols[1])-1
	

	SC5->(DbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5") +  M->PA1_PEDIDO  ))

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE))


	If !Empty(SC5->C5_NOTA) .Or. SC5->C5_LIBEROK=='E' .And. Empty(SC5->C5_BLQ)
		Aviso(FunName(),"O Pedido "+SC5->C5_NUM+" Está encerrado e não pode mais ser gerado para ordem",{"OK"})
		lRet := .F.
	Else
	    If !RecLock("SC5", .F.)
		   Aviso(FunName(),"O Pedido "+SC5->C5_NUM+" Está Bloqueado para Uso Selecione Outro",{"OK"})
		   lRet := .F.
		Else
			M->PA1_CLIENT 	:= SA1->A1_COD
			M->PA1_LOJA		:= SA1->A1_LOJA
			M->PA1_NOME 	:= SA1->A1_NOME
			M->PA1_EST 		:= SA1->A1_EST
			M->PA1_MUN 		:= SA1->A1_MUN
			M->PA1_VEND		:= SC5->C5_VEND1
			//Só dá a opção de carregar todos os itens quando for inclusão
			If lNovo		    
				aCols := {}
				aColsBlank(cAlias1,@aCols,nUsado)
				//If MsgNoYes("Deseja Carregar todos os itens do Pedido de vendas selecionado?","Itens Pedido de Vendas")
				Processa({|| FCarreItens(M->PA1_PEDIDO)},"Exportando Itens, Aguarde... ")
				/*Else
				EndIf*/
				oGet:Refresh()			
			EndIf
		EndIF
	EndIf
Return lRet

/// MVC

Static Function FCarreItens(cPedido)
	Local nTam     	:= 1
	Local nTot		:= 0
	Local aColsAux := {}
	Local nPItem	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_ITEM"})
	Local nPItPd	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_ITEMPD"})
	Local nPosCod	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_COD"})
	Local nPosQtO	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_QTDORI"})
	Local nPosSld	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_SALDO"})
	Local nPosLoc	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_LOCAL"})
	Local nPosQtd	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_QUANT"})
	Local nPosAtu	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_ESTAT"})
	Local nPosDes	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_DESC"})
	Local nPosITsld	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_ESTSEP"})
	Local nPosxSald	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_XSALDO"})
	Local nPosEnds	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_XLOCAL"})
	Local nPosLot   := aScan(aHeader,{|x| Trim(x[2])=="PA2_XLOTE"})
	Local nPosvLot  := aScan(aHeader,{|x| Trim(x[2])=="PA2_XDTVAL"})
               	               	        
	Local nUsado	:= Len(aCols[1])-1
	Local nTotCar	:= 0
	Local nxMax     := 0
	Local nxSaldo   := 0

	aCols := {}
	aColsBlank(cAlias1,@aCols,nUsado)

	//Incrementa o total de itens na regua de processamento
	bAcao:= {|| nTot++ }
	dbEval(bAcao,,{||!SC6->(Eof()) .and. SC6->C6_NUM == cPedido},,,.T.)

	ProcRegua(nTot)
	SC6->(DbSetOrder(1))
	SC6->(DbSeek(xFilial("SC6")+cPedido))


	While !SC6->(Eof()) .And. SC6->(C6_FILIAL+C6_NUM) == (xFilial("SC6")+cPedido)
		IncProc() 
		u_FDados(SC6->C6_NUM,SC6->C6_PRODUTO,SC6->C6_ITEM)
		If CRG->PA2_SALDO>0
			// 
			If Len(aCols) > 1 .And. (Empty(aCols[Len(aCols),nPosCod]) .Or. aCols[Len(aCols),nUsado+1])
				aColsAux := aClone(aCols[Len(aCols)])
			Endif

			/* Preenche o aCols utilizando os registros em brancos ou deletados caso haja, ou incluido mais itens */
			While !(Empty(aCols[nTam,nPosCod]) .Or. aCols[nTam,nUsado+1])
				nTam++
				If nTam > Len(aCols)
					Aadd(aCols, Array(nUsado+1) )
				Endif
			Enddo

			SX3->(dbSetOrder(2))
			For c:=1 To Len(aHeader)
				If SX3->(dbSeek(aHeader[c,2]))
					If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
						aCols[nTam][c] := CriaVar(Trim(SX3->X3_CAMPO),.T.)
					Endif
				Endif
			Next
			//1)BF_PRODUTO  2)BF_LOCALIZ 3)BF_LOTECTL 4)B8_DTVALID 5)BF_QUANT
			If SuperGetMv("MV_XSEPEND")
				axSaldos := fSaldos(SC6->C6_PRODUTO,CRG->C6_LOCAL)
			Else
				axSaldos := {}
			Endif

			//sem endereços 
			If Empty(axSaldos)
				aCols[nTam][nPosxSald] := CRG->PA2_SALDO
				aCols[nTam,nUsado+1]   := .F.
				aCols[nTam][nPItem]    := StrZero(nTam,Len(PA2->PA2_ITEM))
				aCols[nTam][nPosCod]   := SC6->C6_PRODUTO
				aCols[nTam][nPItPd]    := SC6->C6_ITEM
				aCols[nTam][nPosQtO]   := SC6->C6_QTDVEN
				aCols[nTam][nPosLoc]   := CRG->C6_LOCAL
				aCols[nTam][nPosQtd]   := CRG->PA2_SALDO
				aCols[nTam][nPosSld]   := 0
				aCols[nTam][nPosAtu]   := CalcEst(SC6->C6_PRODUTO,"14",dDatabase)[1]
				aCols[nTam][nPosDes]   := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_DESC")  
				aCols[nTam][nPosITsld] := u_FSaldSepIt(SB1->B1_COD)   

			Else
				nxMax   := 0
				nxSaldo := CRG->PA2_SALDO
				aEval( axSaldos , {|x| nxMax += x[5] })
				nX      := 1

				While nxSaldo > 0
					//dentro do axsaldos
					If nX <= len(axSaldos)

						aCols[nTam,nUsado+1]   := .F.
						aCols[nTam][nPItem]    := StrZero(nTam,Len(PA2->PA2_ITEM))
						aCols[nTam][nPosCod]   := SC6->C6_PRODUTO
						aCols[nTam][nPItPd]    := SC6->C6_ITEM
						aCols[nTam][nPosQtO]   := SC6->C6_QTDVEN
						aCols[nTam][nPosxSald] := nxSaldo
						aCols[nTam][nPosLoc]   := CRG->C6_LOCAL
						aCols[nTam][nPosQtd]   := axSaldos[nx][5]
						aCols[nTam][nPosSld]   := 0
						aCols[nTam][nPosAtu]   := CalcEst(SC6->C6_PRODUTO,"14",dDatabase)[1]
						aCols[nTam][nPosDes]   := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_DESC")  
						aCols[nTam][nPosITsld] := u_FSaldSepIt(SB1->B1_COD)  
						aCols[nTam][nPosEnds]  := axSaldos[nx][2]
						If !Empty(axSaldos[1][3])
							aCols[nTam][nPosLot]   := axSaldos[nx][3]
							aCols[nTam][nPosvLot]  := axSaldos[nx][4]
						EndIf	

						nxSaldo := nxSaldo - axSaldos[nx][5]
					//força a saida 
					Else

						aCols[nTam,nUsado+1]   := .F.
						aCols[nTam][nPItem]    := StrZero(nTam,Len(PA2->PA2_ITEM))
						aCols[nTam][nPosCod]   := SC6->C6_PRODUTO
						aCols[nTam][nPItPd]    := SC6->C6_ITEM
						aCols[nTam][nPosQtO]   := SC6->C6_QTDVEN
						aCols[nTam][nPosLoc]   := CRG->C6_LOCAL
						aCols[nTam][nPosQtd]   := nxSaldo 
						aCols[nTam][nPosSld]   := 0
						aCols[nTam][nPosAtu]   := CalcEst(SC6->C6_PRODUTO,"14",dDatabase)[1]
						aCols[nTam][nPosDes]   := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_DESC")  
						aCols[nTam][nPosITsld] := u_FSaldSepIt(SB1->B1_COD)  
						//aCols[nTam][nPosEnds]  := axSaldos[nx][2]
						//If !Empty(axSaldos[1][3])
						//	aCols[nTam][nPosLot]   := axSaldos[nx][3]
						//	aCols[nTam][nPosvLot]  := axSaldos[nx][4]
						//EndIf	
					
						nxSaldo := 0

					EndIf

					
					If nxSaldo > 0
						nUsado	:= Len(aCols[1])-1
						nX += 1

						/* Preenche o aCols utilizando os registros em brancos ou deletados caso haja, ou incluido mais itens */
						While !(Empty(aCols[nTam,nPosCod]) .Or. aCols[nTam,nUsado+1])
							nTam++
							If nTam > Len(aCols)
								Aadd(aCols, Array(nUsado+1) )
							Endif
						Enddo

						SX3->(dbSetOrder(2))
						For c:=1 To Len(aHeader)
							If SX3->(dbSeek(aHeader[c,2]))
								If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
									aCols[nTam][c] := CriaVar(Trim(SX3->X3_CAMPO),.T.)
								Endif
							Endif
						Next
					EndIf	

				EndDo

			EndIf                                                                                 
		EndIf
		nTotal+=CRG->PA2_SALDO

		DbCloseArea()

		SC6->(DbSkip())
	EndDo
	oEnch:Refresh()
Return 



User Function FDados(cPedido,cProduto,cItem)
	Local cQry := ""
	If Select("CRG")>0
		CRG->(DbCloseArea("CRG"))
	EndIf
	cQry+="  SELECT * FROM (																									" + ENTER
	cQry+="  SELECT C6_FILIAL,C6_PRODUTO,C6_ITEM,SC6.C6_DESCRI,C6_QTDVEN,C6_LOCAL,C6_CLI,C6_LOJA,SEP.PA2_QUANT,					" + ENTER                              
	cQry+="  CASE WHEN C6_QTDVEN<=ISNULL(PA2_QUANT,0)                                                                           " + ENTER                               
	cQry+="  THEN 0																												" + ENTER
	cQry+="  	ELSE																											" + ENTER
	cQry+="  		CASE WHEN  ISNULL(SC6.C6_QTDENT,0)>=SC6.C6_QTDVEN                                                           " + ENTER         	                                                          
	cQry+="  			THEN 0																									" + ENTER
	cQry+="  		ELSE                                                                                                        " + ENTER                         
	cQry+="  			CASE WHEN ISNULL(SC6.C6_QTDENT,0)<SC6.C6_QTDVEN                                                         " + ENTER                                                                  
	cQry+="  				THEN																								" + ENTER		 
	cQry+="  					CASE WHEN ISNULL(PA2_QUANT,0)>ISNULL(SC6.C6_QTDENT,0)											" + ENTER
	cQry+="  					THEN																							" + ENTER
	cQry+="  						SC6.C6_QTDVEN-ISNULL(PA2_QUANT,0)															" + ENTER
	cQry+="  					ELSE																							" + ENTER
	cQry+="  						SC6.C6_QTDVEN-ISNULL(SC6.C6_QTDENT,0)														" + ENTER
	cQry+="  					END																								" + ENTER
	cQry+="  				ELSE																								" + ENTER
	cQry+="  					C6_QTDVEN-ISNULL(PA2_QUANT,0)																	" + ENTER										
	cQry+="  			END																										" + ENTER
	cQry+="  		END																											" + ENTER		
	cQry+="  END AS PA2_SALDO,ISNULL(SC6.C6_QTDENT,0) AS FATURADO                                                                                   " + ENTER
	cQry+="  FROM "+RetSQLName("SC6")+" SC6                                                                                                          " + ENTER  
	cQry+=" LEFT JOIN                                                                                                                                " + ENTER  
	cQry+=" 	(                                                                                                                                    " + ENTER  
	cQry+=" 		SELECT PA2_FILIAL,PA1.PA1_PEDIDO,PA2_COD,PA2_ITEMPD,SUM(PA2.PA2_QUANT) AS PA2_QUANT FROM "+RetSQLName("PA2")+" PA2               " + ENTER  
	cQry+=" 		INNER JOIN "+RetSQLName("PA1")+" PA1                                                                                             " + ENTER  
	cQry+=" 		ON PA1.D_E_L_E_T_=''                                                                                                             " + ENTER  
	cQry+=" 		AND PA1.PA1_FILIAL=PA2.PA2_FILIAL                                                                                                " + ENTER  
	cQry+=" 		AND PA1.PA1_NUM=PA2.PA2_NUM                                                                                                      " + ENTER  
	cQry+=" 		WHERE PA2.D_E_L_E_T_=''                                                                                                          " + ENTER  
	cQry+=" 		GROUP BY PA2_FILIAL,PA1.PA1_PEDIDO,PA2_COD,PA2_ITEMPD                                                                            " + ENTER  
	cQry+=" 	) AS SEP                                                                                                                             " + ENTER  
	cQry+=" 	ON SEP.PA2_FILIAL=SC6.C6_FILIAL                                                                                                      " + ENTER  
	cQry+=" 	AND SEP.PA1_PEDIDO=SC6.C6_NUM                                                                                                        " + ENTER  
	cQry+=" 	AND SEP.PA2_COD=SC6.C6_PRODUTO                                                                                                       " + ENTER  
	cQry+=" 	AND SEP.PA2_ITEMPD=SC6.C6_ITEM                                                                                                       " + ENTER                                                                                                          
	cQry+=" WHERE SC6.D_E_L_E_T_=''  AND SC6.C6_FILIAL='"+xFilial("SC6")+"' " + ENTER  
	cQry+=" AND SC6.C6_NUM='"+cPedido+"' " + ENTER
	//cQry+=" AND PA2.PA2_SALDO>0                                                                                                     " + ENTER  

	If !Empty(cProduto)
		cQry+=" AND SC6.C6_PRODUTO='"+cProduto+"' " + ENTER
		cQry+=" AND SC6.C6_ITEM='"+cItem+"' " + ENTER
	EndIf
	cQry+="  ) AS ORDENS  " + ENTER
	cQry+=" WHERE PA2_SALDO>0 " + ENTER
	cQry+=" ORDER BY ORDENS.C6_ITEM " + ENTER
	Memowrite('AASEPA01.SQL',cQry)
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "CRG", .T., .F. )

Return 

User Function ASEP01Leg()
	Local aLegenda :={  { "BR_VERMELHO"   , "Sep. Finalizada" },;
	{ "BR_VERDE"	  	, "Em Separacao"  },;
	{ "BR_AMARELO"	  	, "Pre Carregamento"  },;
	{ "BR_AZUL"	  		, "Separacao Nao iniciada"  }}
	BrwLegenda("Status", "Legenda", aLegenda)	
Return




User Function fGrava()

	Processa( { || GeraOSepPedido() } )
Return



Static Function GeraOSepPedido()
	Local nI
	Local cCodOpe
	Local aRecSC9	:= {}
	Local aOrdSep	:= {}
	Local cArm		:= Space(Tamsx3("B1_LOCPAD")[1])
	Local cPedido	:= Space(6)
	Local cCliente	:= Space(6)
	Local cLoja		:= Space(2)
	Local cCondPag	:= Space(3)
	Local cLojaEnt	:= Space(2)
	Local cAgreg	:= Space(4)
	Local cOrdSep	:= Space(4)
	Local cTipExp	:= ""
	Local nPos      := 0
	Local nMaxItens	:= GETMV("MV_NUMITEN")			//Numero maximo de itens por nota (neste caso por ordem de separacao)- by Erike
	Local lConsNumIt:= SuperGetMV("MV_CBCNITE",.F.,.T.) //Parametro que indica se deve ou nao considerar o conteudo do MV_NUMITEN
	Local lFilItens	:= ExistBlock("ACDA100I")  //Ponto de Entrada para filtrar o processamento dos itens selecionados
	Local lLocOrdSep:= .F.
	Private aLogOS	:= {}
	nMaxItens := If(Empty(nMaxItens),99,nMaxItens)

	// analisar a pergunta '00-Separacao,01-Separacao/Embalagem,02-Embalagem,03-Gera Nota,04-Imp.Nota,05-Imp.Volume,06-embarque,07-Aglutina Pedido,08-Aglutina Local,09-Pre-Separacao'
	cTipExp := "00*" // Separacao Simples


	/*Ponto de entrada, permite que o usuário realize o processamento conforme suas particularidades.*/
	If	ExistBlock("ACD100VG")
		If ! ExecBlock("ACD100VG",.F.,.F.,)
			Return
		EndIf		
	EndIf

	//ProcRegua( SC9->( LastRec() ), "oook" )
	//cCodOpe

	SC5->(DbSetOrder(1))
	SC6->(DbSetOrder(1))
	CB7->(DbSetOrder(2))
	CB8->(DbSetOrder(7))
	PA2->(DbSeek(xFilial("PA2")+PA1->PA1_NUM))
	ProcRegua( PA2->( LastRec() ), "oook" )

	cArm := PA2->PA2_LOCAL

	While !PA2->(Eof()) .And. xFilial("PA2")+PA1->PA1_NUM == PA2->(PA2_FILIAL+PA2_NUM)
		//pesquisa se este item tem saldo a separar, caso tenha, nao gera ordem de separacao
		/*If CB8->(DbSeek(xFilial('CB8')+PA1->PA1_PEDIDO+PA2->PA2_ITEM+PadR("01",TamSx3("C9_SEQUEN")[1])+PA2->PA2_COD)) .and. CB8->CB8_SALDOS > 0
		//Grava o historico das geracoes:
		aadd(aLogOS,{"2","Pedido",PA1->PA1_PEDIDO,PA1->PA1_CLIENT,PA1->PA1_LOJA,PA2->PA2_ITEM,PA2->PA2_COD,PA2->PA2_LOCAL,"Existe saldo a separar deste item","NAO_GEROU_OS"}) //"Pedido"###"Existe saldo a separar deste item"
		PA2->(DbSkip())
		IncProc()
		Loop
		EndIf*/

		If ! SC5->(DbSeek(xFilial('SC5')+PA1->PA1_PEDIDO))
			// neste caso a base tem sc9 e nao tem sc5, problema de incosistencia de base
			//Grava o historico das geracoes:
			aadd(aLogOS,{"2","Pedido",PA1->PA1_PEDIDO,PA1->PA1_CLIENT,PA1->PA1_LOJA,PA2->PA2_ITEM,PA2->PA2_COD,PA2->PA2_LOCAL,"pedido","Inconsistencia de base (SC5 x SC9)"}) //"Pedido"###"Inconsistencia de base (SC5 x SC9)"
			PA2->(DbSkip())
			IncProc()
			Loop
		EndIf
		If ! SC6->(DbSeek(xFilial("SC6")+PA1->PA1_PEDIDO+PA2->PA2_ITEMPD+PA2->PA2_COD))
			// neste caso a base tem sc9,sc5 e nao tem sc6,, problema de incosistencia de base
			//Grava o historico das geracoes:
			aadd(aLogOS,{"2","Pedido",PA1->PA1_PEDIDO,PA1->PA1_CLIENT,PA1->PA1_LOJA,PA2->PA2_ITEM,PA2->PA2_COD,PA2->PA2_LOCAL,"Inconsistencia de base (SC6 x SC9)","NAO_GEROU_OS"}) //"Pedido"###"Inconsistencia de base (SC6 x SC9)"
			PA2->(DbSkip())
			IncProc()
			Loop
		EndIf
		If !Empty(SC5->C5_NOTA) .Or. SC5->C5_LIBEROK=='E' .And. Empty(SC5->C5_BLQ)

			// neste caso a base tem sc9,sc5 e nao tem sc6,, problema de incosistencia de base
			//Grava o historico das geracoes:
			aadd(aLogOS,{"2","Pedido",PA1->PA1_PEDIDO,PA1->PA1_CLIENT,PA1->PA1_LOJA,PA2->PA2_ITEM,PA2->PA2_COD,PA2->PA2_LOCAL,"O Pedido "+SC5->C5_NUM+" Está encerrado e não pode mais ser gerado para ordem","NAO_GEROU_OS"}) //"Pedido"###"Inconsistencia de base (SC6 x SC9)"
			PA2->(DbSkip())
			IncProc()
			Loop
		EndIf



		cPedido	 := PA1->PA1_PEDIDO
		cCliente := SC6->C6_CLI
		cLoja    := SC6->C6_LOJA
		cCondPag := SC5->C5_CONDPAG
		cLojaEnt := SC5->C5_LOJAENT
		cAgreg   := SC9->C9_AGREG

		lLocOrdSep := .F.
		If CB7->(DbSeek(xFilial("CB7")+cPedido+cArm+" "+cCliente+cLoja+cCondPag+cLojaEnt+cAgreg))
			While CB7->(!Eof() .and. CB7_FILIAL+CB7_PEDIDO+CB7_LOCAL+CB7_STATUS+CB7_CLIENT+CB7_LOJA+CB7_COND+CB7_LOJENT+CB7_AGREG==;
			xFilial("CB7")+cPedido+cArm+" "+cCliente+cLoja+cCondPag+cLojaEnt+cAgreg)
				If Ascan(aOrdSep, CB7->CB7_ORDSEP) > 0			
					lLocOrdSep := .T.
					Exit
				EndIf
				CB7->(DbSkip())
			EndDo
		EndIf

		If !lLocOrdSep .or. (("03*" $ cTipExp) .and. !("09*" $ cTipExp) .and.  CB7->CB7_NUMITE >=nMaxItens)

			cOrdSep := CB_SXESXF("CB7","CB7_ORDSEP",,1)
			ConfirmSX8()

			CB7->(RecLock( "CB7",.T.))
			CB7->CB7_FILIAL := xFilial( "CB7" )
			CB7->CB7_ORDSEP := PA1->PA1_NUM
			CB7->CB7_PEDIDO := cPedido
			CB7->CB7_CLIENT := cCliente
			CB7->CB7_LOJA   := cLoja
			CB7->CB7_COND   := cCondPag
			CB7->CB7_LOJENT := cLojaEnt
			CB7->CB7_LOCAL  := cArm
			CB7->CB7_DTEMIS := dDataBase
			CB7->CB7_HREMIS := Time()
			CB7->CB7_STATUS := " "
			//CB7->CB7_CODOPE := cCodOpe
			CB7->CB7_PRIORI := "1"
			CB7->CB7_ORIGEM := "1"
			CB7->CB7_TIPEXP := cTipExp
			CB7->CB7_TRANSP := SC5->C5_TRANSP
			CB7->CB7_AGREG  := cAgreg 
			If	ExistBlock("A100CABE")
				ExecBlock("A100CABE",.F.,.F.)
			EndIf
			CB7->(MsUnlock())

			aadd(aOrdSep,CB7->CB7_ORDSEP)
		EndIf
		//Grava o historico das geracoes:
		nPos := Ascan(aLogOS,{|x| x[01]+x[02]+x[03]+x[04]+x[05]+x[10] == ("1"+"Pedido"+PA1->(PA1_PEDIDO+PA1_CLIENT+PA1_LOJA)+CB7->CB7_ORDSEP)})
		If nPos == 0
			aadd(aLogOS,{"1","Pedido",PA1->PA1_PEDIDO,PA1->PA1_CLIENT,PA1->PA1_LOJA,"","",cArm,"",CB7->CB7_ORDSEP}) //"Pedido"
		Endif

		iF !SuperGetMv("MV_XSEPEND") 
			CB8->(RecLock("CB8",.T.))
			CB8->CB8_FILIAL := xFilial("CB8")
			CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
			CB8->CB8_ITEM   := PA2->PA2_ITEM
			CB8->CB8_XITPED := PA2->PA2_ITEMPD
			CB8->CB8_PEDIDO := PA1->PA1_PEDIDO
			CB8->CB8_PROD   := PA2->PA2_COD
			CB8->CB8_LOCAL  := PA2->PA2_LOCAL
			CB8->CB8_QTDORI := PA2->PA2_QUANT
			If "09*" $ cTipExp
				CB8->CB8_SLDPRE := PA2->PA2_QUANT
			EndIf
			CB8->CB8_SALDOS := PA2->PA2_QUANT
			CB8->CB8_LCALIZ := ""
			CB8->CB8_NUMSER := ""
			CB8->CB8_SEQUEN := PadR("01",TamSx3("C9_SEQUEN")[1])
			CB8->CB8_LOTECT := ""
			CB8->CB8_NUMLOT := ""
			CB8->CB8_CFLOTE := If("10*" $ cTipExp,"1","2")
			CB8->CB8_TIPSEP := If("09*" $ cTipExp,"1"," ")
			CB8->CB8_XULTRA := "N"
			CB8->CB8_ULQTD := "N"
			If	ExistBlock("ACD100GI")
				ExecBlock("ACD100GI",.F.,.F.)
			EndIf
			CB8->(MsUnLock())

		ELSE

			iF CB8->(DbSeek(xFilial("CB8")+CB7->CB7_ORDSEP+PA2->PA2_LOCAL+'               '+PA2->PA2_COD+'                    '))
				CB8->(RecLock("CB8",.F.))
				CB8->CB8_QTDORI += PA2->PA2_QUANT
				If "09*" $ cTipExp
					CB8->CB8_SLDPRE += PA2->PA2_QUANT
				EndIf
				CB8->CB8_SALDOS += PA2->PA2_QUANT
				CB8->(MsUnLock())
			Else
				CB8->(RecLock("CB8",.T.))
				CB8->CB8_FILIAL := xFilial("CB8")
				CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
				CB8->CB8_ITEM   := PA2->PA2_ITEM
				CB8->CB8_XITPED := PA2->PA2_ITEMPD
				CB8->CB8_PEDIDO := PA1->PA1_PEDIDO
				CB8->CB8_PROD   := PA2->PA2_COD
				CB8->CB8_LOCAL  := PA2->PA2_LOCAL
				CB8->CB8_QTDORI := PA2->PA2_QUANT
				If "09*" $ cTipExp
					CB8->CB8_SLDPRE := PA2->PA2_QUANT
				EndIf
				CB8->CB8_SALDOS := PA2->PA2_QUANT
				CB8->CB8_LCALIZ := ""
				CB8->CB8_NUMSER := ""
				CB8->CB8_SEQUEN := PadR("01",TamSx3("C9_SEQUEN")[1])
				CB8->CB8_LOTECT := ""
				CB8->CB8_NUMLOT := ""
				CB8->CB8_CFLOTE := If("10*" $ cTipExp,"1","2")
				CB8->CB8_TIPSEP := If("09*" $ cTipExp,"1"," ")
				CB8->CB8_XULTRA := "N"
				CB8->CB8_ULQTD := "N"
				If	ExistBlock("ACD100GI")
					ExecBlock("ACD100GI",.F.,.F.)
				EndIf
				CB8->(MsUnLock())
			EndIf
		eNDIF

		//Atualizacao do controle do numero de itens a serem impressos
		RecLock("CB7",.F.)
		CB7->CB7_NUMITE++
		CB7->(MsUnLock())

		//aadd(aRecSC9,{SC9->(Recno()),CB7->CB7_ORDSEP})
		IncProc()
		PA2->( dbSkip() )
	EndDo

	CB7->(DbSetOrder(1))
	For nI := 1 to len(aOrdSep)
		CB7->(DbSeek(xFilial("CB7")+aOrdSep[nI]))
		CB7->(RecLock("CB7"))
		CB7->CB7_STATUS := "0"  // nao iniciado
		CB7->(MsUnlock())
		If	ExistBlock("ACDA100F")
			ExecBlock("ACDA100F",.F.,.F.,{aOrdSep[nI]})
		EndIf
	Next


	PA1->(RecLock("PA1"))
	PA1->PA1_STATUS := "4"
	PA1->(MsUnlock())

	If !Empty(aLogOS)
		LogACDA100()
	Endif
Return


Static Function LogACDA100()
	Local i, j, k
	Local cChaveAtu, cPedCli, cOPAtual

	//Cabecalho do Log de processamento:
	AutoGRLog(Replicate("=",75))
	AutoGRLog(STR0083) //"                         I N F O R M A T I V O"
	AutoGRLog(STR0084) //"               H I S T O R I C O   D A S   G E R A C O E S"

	//Detalhes do Log de processamento:
	AutoGRLog(Replicate("=",75))
	AutoGRLog(STR0085) //"I T E N S   P R O C E S S A D O S :"
	AutoGRLog(Replicate("=",75))
	If aLogOS[1,2] == STR0041 //"Pedido"
		aLogOS := aSort(aLogOS,,,{|x,y| x[01]+x[10]+x[03]+x[04]+x[05]+x[06]+x[07]+x[08]<y[01]+y[10]+y[03]+y[04]+y[05]+y[06]+y[07]+y[08]})
		// Status Ord.Sep(1=Gerou;2=Nao Gerou) + Ordem Separacao + Pedido + Cliente + Loja + Item + Produto + Local
		cChaveAtu := ""
		cPedCli   := ""
		For i:=1 to len(aLogOs)
			If aLogOs[i,10] <> cChaveAtu .OR. (aLogOs[i,03]+aLogOs[i,04] <> cPedCli)
				If !Empty(cChaveAtu)
					AutoGRLog(Replicate("-",75))
				Endif
				j:=0
				k:=i  //Armazena o conteudo do contador do laco logico principal (i) pois o "For" j altera o valor de i;
				cChaveAtu := aLogOs[i,10]
				For j:=k to len(aLogOs)
					If aLogOs[j,10] <> cChaveAtu
						Exit
					Endif
					If Empty(aLogOs[j,08]) //Aglutina Armazem
						AutoGRLog(STR0086+aLogOs[j,03]+STR0087+aLogOs[j,04]+"-"+aLogOs[j,05]) //"Pedido: "###" - Cliente: "
					Else
						AutoGRLog(STR0086+aLogOs[j,03]+STR0087+aLogOs[j,04]+"-"+aLogOs[j,05]+STR0088+aLogOs[j,08]) //"Pedido: "###" - Cliente: "###" - Local: "
					Endif
					cPedCli := aLogOs[j,03]+aLogOs[j,04]
					If aLogOs[j,10] == "NAO_GEROU_OS"
						Exit
					Endif
					i:=j
				Next
				AutoGRLog(STR0058+If(aLogOs[i,01]=="1",aLogOs[i,10],STR0089)) //"Ordem de Separacao: "###"N A O  G E R A D A"
				If aLogOs[i,01] == "2"  //Ordem Sep. NAO gerada
					AutoGRLog(STR0090) //"Motivo: "
				Endif
			Endif
			If aLogOs[i,01] == "2"  //Ordem Sep. NAO gerada
				AutoGRLog(STR0091+aLogOs[i,06]+STR0092+AllTrim(aLogOs[i,07])+STR0088+aLogOs[i,08]+" ---> "+aLogOs[i,09]) //"Item: "###" - Produto: "###" - Local: "
			Endif
		Next
	Elseif aLogOS[1,2] == STR0046 //"Nota"
		aLogOS := aSort(aLogOS,,,{|x,y| x[01]+x[08]+x[03]+x[04]+x[05]+x[06]<y[01]+y[08]+y[03]+y[04]+y[05]+y[06]})
		// Status Ord.Sep(1=Gerou;2=Nao Gerou) + Ordem Separacao + Nota + Serie + Cliente + Loja
		cChaveAtu := ""
		For i:=1 to len(aLogOs)
			If aLogOs[i,08] <> cChaveAtu
				If !Empty(cChaveAtu)
					AutoGRLog(Replicate("-",75))
				Endif
				cChaveAtu := aLogOs[i,08]
				AutoGRLog(STR0093+aLogOs[i,3]+"/"+aLogOs[i,04]+STR0087+aLogOs[i,05]+"-"+aLogOs[i,06]) //"Nota: "###" - Cliente: "
				AutoGRLog(STR0058+If(aLogOs[i,01]=="1",aLogOs[i,08],STR0089)) //"Ordem de Separacao: "###"N A O  G E R A D A"
				If aLogOs[i,01] == "2"  //Ordem Sep. NAO gerada
					AutoGRLog(STR0090) //"Motivo: "
				Endif
			Endif
		Next
	Else  //Ordem de Producao
		aLogOS := aSort(aLogOS,,,{|x,y| x[01]+x[07]+x[03]+x[04]<y[01]+y[07]+y[03]+y[04]})
		// Status Ord.Sep(1=Gerou;2=Nao Gerou) + Ordem Separacao + Ordem Producao + Produto
		cChaveAtu := ""
		cOPAtual  := ""
		For i:=1 to len(aLogOs)
			If aLogOs[i,07] <> cChaveAtu .OR. aLogOs[i,03] <> cOPAtual
				If !Empty(cChaveAtu)
					AutoGRLog(Replicate("-",75) )
				Endif
				j:=0
				k:=i  //Armazena o conteudo do contador do laco logico principal (i) pois o "For" j altera o valor de i;
				cChaveAtu := aLogOs[i,07]
				For j:=k to len(aLogOs)
					If aLogOs[j,07] <> cChaveAtu
						Exit
					Endif
					If Empty(aLogOs[j,05]) //Aglutina Armazem
						AutoGRLog(STR0064+aLogOs[i,03]) //"Ordem de Producao: "
					Else
						AutoGRLog(STR0064+aLogOs[i,03]+STR0088+aLogOs[j,05]) //"Ordem de Producao: "###" - Local: "
					Endif
					cOPAtual := aLogOs[j,03]
					If aLogOs[j,07] == "NAO_GEROU_OS"
						Exit
					Endif
					i:=j
				Next
				AutoGRLog(STR0058+If(aLogOs[i,01]=="1",aLogOs[i,07],STR0089)) //"Ordem de Separacao: "###"N A O  G E R A D A"
				If aLogOs[i,01] == "2"  //Ordem Sep. NAO gerada
					AutoGRLog(STR0090) //"Motivo: "
				Endif
			Endif
			If aLogOs[i,01] == "2"  //Ordem Sep. NAO gerada
				AutoGRLog(" ---> "+aLogOs[i,06])
			Endif
		Next
	Endif
	MostraErro()
Return


User Function ASE01DelOk()
	Local lRet := .T.
	Local nPosVlr := aScan(aHeader,{|x| Trim(x[2])=="PA2_QUANT"})
	Local nDel := Len(aHeader) + 1

	nAcao++

	If nAcao==2
		nAcao := 0 
		If aCols[n,nDel]
			nTotal -= aCols[n,nPosVlr]
		Else
			nTotal += aCols[n,nPosVlr]
		Endif
		oEnch:Refresh()	
	EndIf



Return lRet


User Function FEstornaLista(cOrdem) 
	//If PA1->PA1_STATUS==""

	Processa({|| FApaga(PA1->PA1_NUM)},"Estornando a Ordem de separação, Aguarde... ")
	//EndIf
Return

Static Function FApaga(cOrdem) 

	Local lFound := .F.
	lMsErroAuto := .F.

	SD3->(dbSetOrder(2))
	If SD3->(dbSeek(XFILIAL("SD3")+cOrdem))
		While !SD3->(Eof()) .And. XFILIAL("SD3")+cOrdem == SD3->D3_FILIAL+Alltrim(SD3->D3_DOC)
			// Valida campos adicionais se são os mesmos da puxada
			If SD3->D3_ESTORNO<>'S'
				lFound := .T.
				Exit
			EndIF
			SD3->(dbSkip())
		Enddo	

		If lFound
			aAuto := {}	
			MSExecAuto({|x,y| `(x,y)},aAuto,6)

			If lMsErroAuto
				MostraErro()
				DisarmTransaction()
			EndIf	
		EndIf
	EndIf
	If !lMsErroAuto
		u_FDelRegSep(cOrdem)
	EndIf

Return

User Function FDelRegSep(cOrdem)
	Local cQry := ""


	CB9->(DbSetOrder(1))
	CB9->(MsSeek(xFilial("CB9")+cOrdem))

	While !CB9->(Eof()) .And. CB9->CB9_ORDSEP == cOrdem
		PA2->(DbSetOrder(5))
		PA2->(DbSeek(xFilial("PA2")+CB9->CB9_ORDSEP+CB9->CB9_ITESEP+CB9->CB9_PROD))


		SC9->(DbSetOrder(1))
		If SC9->(DbSeek(xFilial("SC9")+CB9->CB9_PEDIDO+PA2->PA2_ITEMPD))
			While !SC9->(Eof()) .And. xFilial("SC9")+CB9->CB9_PEDIDO+PA2->PA2_ITEMPD==xFilial("SC9")+SC9->C9_PEDIDO+SC9->C9_ITEM
				If SC9->C9_ORDSEP != cOrdem .And. SC9->C9_NFISCAL<>''
					SC9->(DbSkip())
					Loop
				EndIf	
				RecLock("SC9",.F.)
				SC9->C9_ORDSEP := ""
				MsUnlock()
				SC9->(a460Estorna())

				SC9->(DbSkip())
			EndDo
		EndIf
		CB9->(DbSkip())
	EndDo  

	cQry := " UPDATE "+RetSQLName("CB0")+" "
	cQry += " SET CB0_LOCAL=CB9.CB9_LOCAL,CB0_LOCALI=CB9.CB9_LCALIZ,CB0_LOTE=CB9.CB9_LOTECT "
	cQry += " FROM "+RetSQLName("CB0")+" CB0 "
	cQry += " INNER JOIN "+RetSQLName("CB9")+" CB9 ON "
	cQry += " CB9.D_E_L_E_T_='' "
	cQry += " AND CB9.CB9_CODETI=CB0.CB0_CODETI "
	cQry += " AND CB9.CB9_PROD=CB0.CB0_CODPRO "
	cQry += " AND CB9.CB9_ORDSEP='"+cOrdem+"' "
	cQry += " WHERE CB0.D_E_L_E_T_='' "
	TCSqlExec( cQry )

	cQry := " DELETE FROM "+RetSQLName("CB8")+" "
	cQry += " WHERE D_E_L_E_T_='' 				"
	cQry += " AND CB8_ORDSEP='"+cOrdem+"'		"
	TCSqlExec( cQry )

	cQry := " DELETE FROM "+RetSQLName("CB7")+" "
	cQry += " WHERE D_E_L_E_T_=''				"
	cQry += " AND CB7_ORDSEP='"+cOrdem+"'		"
	TCSqlExec( cQry )
	cQry := " UPDATE "+RetSQLName("CB9") +" 		"
	cQry += " SET D_E_L_E_T_='*'        		"
	cQry += " WHERE CB9_ORDSEP='"+cOrdem+"'		"
	TCSqlExec( cQry )
	cQry := " UPDATE "+RetSQLName("PA1")+"		"
	cQry += " SET PA1_STATUS='1'				"
	cQry += " WHERE PA1_NUM='"+cOrdem+"'			"
	TCSqlExec( cQry )
	cQry := " UPDATE "+RetSQLName("PA2")+"		"
	cQry += " SET PA2_QUANT=PA2_QTDORI			"
	cQry += " WHERE PA2_NUM='"+cOrdem+"'		"
	TCSqlExec( cQry )

	Aviso("Separação","Ordem de Separação estornada com sucesso!",{"OK"})

Return

User Function FSaldSepIt(cProduto) 
	Local cQuery := ""

	cQuery+=" SELECT ISNULL(SUM(CB8_SALDOS),0) AS SALDO FROM "+RetSQLName("CB8")+"	"
	cQuery+=" WHERE D_E_L_E_T_=''					"
	cQuery+=" AND CB8_SALDOS>0						"
	cQuery+=" AND CB8_PROD='"+cProduto+"'						"

	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQuery)), "TRB", .T., .F. )

	nSaldo:= TRB->SALDO

	TRB->(DbCloseArea("TRB"))
Return nSaldo



Static Function ShowF4(a,b,c)
Local nHdl := GetFocus()
Local nPosCod	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_COD"})
Local nPosQOri	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_QTDORI"})
Local nPosQtd	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_QUANT"})
Local nPosIte	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_ITEM"})
Local nPosSld	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_SALDO"})
Local nPosLoc	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_LOCAL"})
Local nPosQtd	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_QUANT"})
Local nPosAtu	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_ESTAT"})
Local nPosDes	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_DESC"})
Local nPosEnds	:= aScan(aHeader,{|x| Trim(x[2])=="PA2_XLOCAL"})
Local nPosDValid  := aScan(aHeader,{|x| Trim(x[2])=="PA2_XDTVAL"})
Local nPosLotCTL  := aScan(aHeader,{|x| Trim(x[2])=="PA2_XLOTE"})

If AllTrim(Upper(ReadVar())) $ 'M->PA2_COD'
	MaViewSB2(aCols[n,nPosCod])
ElseIf AllTrim(Upper(ReadVar())) $ 'M->PA2_XLOTE'
	F4PA2Lote(,,,   'SEPA', aCols[n,nPosCod],aCols[n,nPosLoc],NIL,aCols[n,nPosEnds],1,,,.F.)
ElseIf AllTrim(Upper(ReadVar())) == 'M->PA2_XLOCAL'
	//erro para a261 por que nao tem o campo de lote, data de validade
	F4PA2END(,,,   'SEPA', aCols[n,nPosCod], aCols[n,nPosLoc],, ReadVar(),.F.,,.F.) 
EndIf
SetFocus(nHdl)
Return NIL


Static Function F4PA2END( a, b, c, cProg, cProd, cLoc, nQtd, cReadVar, lEndOrig, cOP, lNumSerie)

LOCAL aArrayF4  :={}, aArrayF4NS:={}, nX, cVar
LOCAL cProduto  :="", nPosProd:=0, cLocal:="", nPosLocal:=0, nPosLocaliz:=0, nPosQuant:=0,nPosNumSer:=0,nPosSerie:=0,nPosQt2U:=0
LOCAL nQuant    := 0
LOCAL nQuantLoc := 0
LOCAL nQtLoc2U  := 0
LOCAL nEndereco
LOCAL cChave2
LOCAL cLocEnd  := ""
LOCAL lGetDados  := .F.
LOCAL aUsado     := {}
LOCAL nPosNumLote
LOCAL nPosLoteCtl
LOCAL lLote      := .F.
LOCAL cQuant, cQtSegU, nOAT
LOCAL lSaida     := .F.
LOCAL oDlg
LOCAL nOpcA      := 0
LOCAL aPosSBF 	 := {} 
LOCAL aArea		 :=GetArea()
LOCAL lShowNSeri := .F.
LOCAL cNumSeri   := CriaVar( "BF_NUMSERI", .F. ) 
Local cLoteCtl   := ""
Local cNumLote   := ""
LOCAL nNumSerie  := 0
LOCAL lSelLote   := (SuperGetMV("MV_SELLOTE") == "1")
Local lWmsNew    := SuperGetMV("MV_WMSNEW",.F.,.F.) .And. IntWMS()
Local lWms       := .F.
LOCAL nLoop      := 0
LOCAL dDtValid   := CTOD('  /  /  ')
LOCAL aAreaSB8   := SB8->(GetArea())
LOCAL aDelArrF4  := {}
LOCAL nPos 		 := 0
LOCAL lMTF4LOC   := ExistBlock("MTF4LOC")
LOCAL aArrayAux  := Nil 
LOCAL nHdl       := GetFocus()
LOCAL aSldEmp	 := {0,0}
LOCAL cCadastro  := ""
LOCAL nI		 := 0 
LOCAL lVldDtLote := SuperGetMV("MV_VLDLOTE",.F.,.T.)
Local nPosProd	 := aScan(aHeader,{|x| Trim(x[2])=="PA2_COD"})
Local nPosQOri	 := aScan(aHeader,{|x| Trim(x[2])=="PA2_QTDORI"})
Local nPosQuant	 := aScan(aHeader,{|x| Trim(x[2])=="PA2_QUANT"})
Local nPosIte	 := aScan(aHeader,{|x| Trim(x[2])=="PA2_ITEM"})
Local nPosSld	 := aScan(aHeader,{|x| Trim(x[2])=="PA2_SALDO"})
Local nPosLocal	 := aScan(aHeader,{|x| Trim(x[2])=="PA2_LOCAL"})
Local nPosQtd	 := aScan(aHeader,{|x| Trim(x[2])=="PA2_QUANT"})
Local nPosAtu	 := aScan(aHeader,{|x| Trim(x[2])=="PA2_ESTAT"})
Local nPosDes	 := aScan(aHeader,{|x| Trim(x[2])=="PA2_DESC"})
Local nPosLocaliz := aScan(aHeader,{|x| Trim(x[2])=="PA2_XLOCAL"})
Local nPosDValid  := aScan(aHeader,{|x| Trim(x[2])=="PA2_XDTVAL"})
Local nPosLoteCtl := aScan(aHeader,{|x| Trim(x[2])=="PA2_XLOTE"})


DEFAULT lNumSerie := .F.
DEFAULT lEndorig  := .T.
DEFAULT cOP := ""


nQtd := If( ValType( nQtd ) <> "N", 0, nQtd )

If cProg $ "SEPA"
	cProduto    := aCols[ n, nPosProd ]
	cLocal      := aCols[ n, nPosLocal ]
	cLoteCtl    := aCols[ n, nPosLoteCtl ]
	nQuant      := aCols[ n, nPosQuant ]
	cNumLote    := ""
	lGetDados := .T.
EndIf


If Localiza( cProduto,.T.) 
	If Rastro( cProduto )
		If !Empty( If( Rastro( cProduto, "S" ), cNumLote, cLoteCtl ) )
			lLote := .T.
		EndIf
	EndIf

	If lWmsNew .And. IntWMS(cProduto)
		lWms      := .T.
		oSaldoWMS := WMSDTCEstoqueEndereco():New()				
		aSaldo 	  := oSaldoWMS:GetSldEnd(cProduto,cLocal,,,,,1)
		
		If Rastro(cProduto,"S")
			aSaldo 	:= oSaldoWMS:GetSldEnd(cProduto,cLocal,,cLoteCtl,cNumLote,,1)	

		Else
			aSaldo 	:= oSaldoWMS:GetSldEnd(cProduto,cLocal,,cLoteCtl,,,1)	

		EndIf
		For nI := 1 To Len(aSaldo)
			aSaldo[nI,6] := TransForm(aSaldo[nI,6],PesqPict("D14","D14_QTDEST",13))
			aSaldo[nI,7] := TransForm(aSaldo[nI,7],PesqPict("D14","D14_QTDES2",13))
		Next nI
		aArrayF4 	:= Aclone(aSaldo)		
		If !Empty(aArrayF4)
			If !Empty(aArrayF4[1][5]) 		
				lShowNSeri := .T.		
			EndIf
		EndIf
	Else
		aPosSBF := SBF->(GetArea())
		dbSelectArea("SBF")
		cChave2 := xFilial( "SBF" ) + cProduto + cLocal
		cCompara:= "BF_FILIAL+BF_PRODUTO+BF_LOCAL"
		dbSetOrder(2)
		If lLote
			If Rastro(cProduto,"S")
				cCompara+="+BF_LOTECTL+BF_NUMLOTE"
				cChave2 +=cLoteCtl + cNumLote
			Else
				cCompara+="+BF_LOTECTL"
				cChave2 +=cLoteCtl
			EndIf
		EndIf
		dbSeek(cChave2)
		While !SBF->( Eof() ) .And. cChave2 == &(cCompara)
			If !Empty(cOP)
				aSldEmp := SldEmpOP(SBF->BF_PRODUTO,SBF->BF_LOCAL,SBF->BF_LOTECTL,SBF->BF_NUMLOTE,cOP,SBF->BF_LOCALIZ,SBF->BF_NUMSERI,"L")
			EndIf
			nSaldoLoc  := SBF->BF_QUANT - (SBF->BF_EMPENHO-aSldEmp[1]+AvalQtdPre("SBF",1))
			nSaldoLoc2 := SBF->BF_QTSEGUM - (SBF->BF_EMPEN2-aSldEmp[2]+AvalQtdPre("SBF",1,.T.))
			If QtdComp(nSaldoLoc) > QtdComp(0)
				nScan := AScan( aUsado, { |x| x[1] == SBF->BF_LOCALIZ .And. If(lLote,If(Rastro(cProduto,"S"),x[3]==SBF->BF_LOTECTL.And.x[4]==SBF->BF_NUMLOTE,x[3]==SBF->BF_LOTECTL),.T.) .And. x[5] == If(nPosNumSer>0,SBF->BF_NUMSERI,"")} )
				If nScan <> 0
					nSaldoLoc  -= aUsado[ nScan, 2 ]
					nSaldoLoc2 -= ConvUM(cProduto, aUsado[ nScan, 2 ], 0, 2)
				EndIf
			EndIf
			If nSaldoLoc > 0
				dDtValid   := CTOD('  /  /  ')
				If Rastro(cProduto)
					dbSelectArea("SB8")
					dbSetOrder(3)
					If dbSeek(xFilial("SB8")+cProduto+SBF->BF_LOCAL+SBF->BF_LOTECTL+If(Rastro(cProduto,"S"),SBF->BF_NUMLOTE,""))
						If lVldDtLote .And. SB8->B8_DATA > dDataBase
							dbSelectArea("SBF")
							SBF->( dbSkip() )
							Loop
						EndIf
						dDtValid:=B8_DTVALID
					EndIf
				EndIf
				dbSelectArea("SBF")
				AAdd(aArrayF4NS,{SBF->BF_LOCALIZ,SBF->BF_NUMSERI,TransForm(nSaldoLoc,PesqPict("SBF","BF_QUANT",13)),TransForm(nSaldoLoc2,PesqPict("SBF","BF_QUANT",13)),SBF->BF_LOTECTL,SBF->BF_NUMLOTE,dDtValid})
				AAdd(aArrayF4,{SBF->BF_LOCALIZ,TransForm(nSaldoLoc,PesqPict("SBF","BF_QUANT",13)),TransForm(nSaldoLoc2,PesqPict("SBF","BF_QUANT",13)),SBF->BF_LOTECTL,SBF->BF_NUMLOTE,dDtValid})
				If !Empty(SBF->BF_NUMSERI)
					lShowNSeri := .T.
				EndIf
			EndIf
			SBF->( dbSkip() )
		EndDo
		RestArea(aPosSBF)
	EndIf
	If lShowNSeri
		aArrayF4:=ACLONE(aArrayF4NS)
	EndIf
	If ExistBlock("MTVLDLOC")
		aDelArrF4 := ExecBlock("MTVLDLOC",.F.,.F.,ACLONE(aArrayF4))
		If ValType(aDelArrF4) == "A" .And. Len(aDelArrF4) > 0
			For nX := 1 To Len(aDelArrF4)
				If lShowNSeri
					nPos := aScan(aArrayF4,{|x| x[1] == aDelArrF4[nX][1] .And. x[2] == aDelArrF4[nX][2] .And. x[5] == aDelArrF4[nX][5] .And. x[6] == aDelArrF4[nX][6] .And. x[7] == aDelArrF4[nX][7]})
				Else
					nPos := aScan(aArrayF4,{|x| x[1] == aDelArrF4[nX][1] .And. x[4] == aDelArrF4[nX][4] .And. x[5] == aDelArrF4[nX][5] .And. x[6] == aDelArrF4[nX][6]})
				Endif
				If nPos > 0
					Adel(aArrayF4,nPos)
					ASize(aArrayF4,Len(aArrayF4)-1)
				Endif
			Next
		Endif
	EndIf
	If Len( aArrayF4 ) > 0

		If lMTF4LOC
			aArrayAux := ExecBlock('MTF4LOC', .F., .F., {aArrayF4})
			If ValType(aArrayAux) == 'A'  .And. Len(aArrayF4) == Len(aArrayAux)
				aArrayF4 := aClone(aArrayAux)
			EndIf
		EndIf
		
		nOpcA := 0
		cCadastro := OemToAnsi("Saldos por Localizacao")  //
		DEFINE MSDIALOG oDlg TITLE cCadastro From 09,0 To 33,75 OF oMainWnd
		@ 1.1,  .7  Say OemToAnsi("Produto :")  //
		@ 1  , 3.8  MSGet cProduto SIZE 150,10 When .F.
		If lShowNSeri
			@ 2.4,.7 LISTBOX oQual VAR cVar Fields HEADER OemToAnsi("Localizacao"),OemToAnsi("Numero de Serie"),OemToAnsi("Saldo"),OemToAnsi("Saldo 2aUM"),RetTitle("BF_LOTECTL"),RetTitle("BF_NUMLOTE"),RetTitle("B8_DTVALID") SIZE 285,140 ON DBLCLICK (nOpca := 1,oDlg:End()) //
		Else
			@ 2.4,.7 LISTBOX oQual VAR cVar Fields HEADER OemToAnsi("Localizacao"),OemToAnsi("Saldo"),OemToAnsi("Saldo 2aUM"),RetTitle("BF_LOTECTL"),RetTitle("BF_NUMLOTE"),RetTitle("B8_DTVALID") SIZE 285,140 ON DBLCLICK (nOpca := 1,oDlg:End()) //"Localizacao"###
		EndIf
	EndIf
	oQual:SetArray(aArrayF4)
	If lShowNSeri
		If lWms
			oQual:bLine:={ ||{aArrayF4[oQual:nAT,1],aArrayF4[oQual:nAT,2],aArrayF4[oQual:nAT,3],aArrayF4[oQual:nAT,4],aArrayF4[oQual:nAT,5],aArrayF4[oQual:nAT,6],aArrayF4[oQual:nAT,7],aArrayF4[oQual:nAT,8],aArrayF4[oQual:nAT,9]}}	
		Else
		oQual:bLine:={ ||{aArrayF4[oQual:nAT,1],aArrayF4[oQual:nAT,2],aArrayF4[oQual:nAT,3],aArrayF4[oQual:nAT,4],aArrayF4[oQual:nAT,5],aArrayF4[oQual:nAT,6],aArrayF4[oQual:nAT,7]}}
		EndIf
	Else
		If lWms
			oQual:bLine:={ ||{aArrayF4[oQual:nAT,1],aArrayF4[oQual:nAT,2],aArrayF4[oQual:nAT,3],aArrayF4[oQual:nAT,4],aArrayF4[oQual:nAT,6],aArrayF4[oQual:nAT,7],aArrayF4[oQual:nAT,8],aArrayF4[oQual:nAT,9]}}
		Else
		oQual:bLine:={ ||{aArrayF4[oQual:nAT,1],aArrayF4[oQual:nAT,2],aArrayF4[oQual:nAT,3],aArrayF4[oQual:nAT,4],aArrayF4[oQual:nAT,5],aArrayF4[oQual:nAT,6]}}
		EndIf
	EndIf
	DEFINE SBUTTON FROM 06  ,264  TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 18.5,264  TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg VALID (nOAT := oQual:nAT,.T.) CENTERED

	If nOpca == 1
		If lShowNSeri
			If lWms	          	
				cLocEnd := aArrayF4[ nOAT, 2 ]
				cNumSeri  := aArrayF4[ nOAT, 5 ]
				cLoteCtl  := aArrayF4[ nOAT, 3 ]
				cNUMLote  := aArrayF4[ nOAT, 4 ]
				dDtValid  := aArrayF4[ nOAT, 8 ]
				cQuant    := aArrayF4[ nOAT, 6 ]
			Else
				cLocEnd := aArrayF4[ nOAT, 1 ]
				cNumSeri  := aArrayF4[ nOAT, 2 ]
				cLoteCtl  := aArrayF4[ nOAT, 5 ]
				cNUMLote  := aArrayF4[ nOAT, 6 ]
				dDtValid  := aArrayF4[ nOAT, 7 ]
				cQuant    := aArrayF4[ nOAT, 3 ]
				cQuant    := StrTran( cQuant, ".", ""  )
				cQuant    := StrTran( cQuant, ",", "." )
				nQuantLoc := Val( cQuant )
			EndIf
		Else
			If lWms
				cLocEnd := aArrayF4[ nOAT, 2 ]
				cLoteCtl  := aArrayF4[ nOAT, 3 ]
				cNUMLote  := aArrayF4[ nOAT, 4 ]
				dDtValid  := aArrayF4[ nOAT, 8 ]
				cQuant    := aArrayF4[ nOAT, 6 ]
				cQtSegU   := aArrayF4[ nOAT, 7 ]
			Else
				cLocEnd := aArrayF4[ nOAT, 1 ]
				cLoteCtl  := aArrayF4[ nOAT, 4 ]
				cNUMLote  := aArrayF4[ nOAT, 5 ]
				dDtValid  := aArrayF4[ nOAT, 6 ]
				cQuant    := aArrayF4[ nOAT, 2 ]
				cQtSegU   := aArrayF4[ nOAT, 3 ]
			EndIf
			If UPPER(AllTrim(GetSrvProfString("PictFormat", ""))) == "AMERICAN"
			 	cQuant    := StrTran( cQuant, ",", ""  )
			 	cQtSegU   := StrTran( cQtSegU, ",", ""  )
				nQuantLoc :=  Val( cQuant )
			Else 
				cQuant    := StrTran( cQuant, ".", ""  )
				cQuant    := StrTran( cQuant, ",", "." )
				cQtSegU   := StrTran( cQtSegU, ".", ""  )
				cQtSegU   := StrTran( cQtSegU, ",", "." )
				nQuantLoc := Val( cQuant )
				nQtLoc2U  := Val( cQtSegU )
			EndIf
		EndIf
	EndIf
Else
	Help( " ", 1, "F4LOCALIZ" )
EndIf

	If !Empty(cLocEnd) .Or. !Empty(cNumSeri)

		aCols[n, nPosLocaliz] := cLocEnd
		aCols[n, nPosLoteCtl] := cLoteCtl
		aCols[n, nPosDValid] := dDtValid
		&cReadVar := cLocEnd
	
	EndIf
	
	RestArea(aAreaSB8)

RestArea(aArea)
SetFocus(nHdl)
Return .T.



Static Function fSaldos(cxProduto,cxLocal)
Local axRet  := {}
Local cxQry  := ""
Local cxArea := GetArea()

cxQry := " SELECT BF_PRODUTO, BF_LOCALIZ, BF_LOCAL, BF_QUANT, isnull(BF_LOTECTL,'') BF_LOTECTL, B8_SALDO, isnull(B8_DTVALID,'20001231') B8_DTVALID FROM "+RetSQLName("SBF") + " SBF (NOLOCK) "
cxQry += " LEFT JOIN "+RetSQLName("SB8") + " SB8 (NOLOCK) "
cxQry += " ON BF_PRODUTO = B8_PRODUTO AND BF_FILIAL = B8_FILIAL "
cxQry += " AND B8_LOCAL = BF_LOCAL AND B8_LOTECTL = BF_LOTECTL AND SB8.D_E_L_E_T_ = '' "
cxQry += " WHERE SBF.D_E_L_E_T_ = '' "
cxQry += " AND BF_QUANT > 0 "
cxQry += " AND BF_PRODUTO = '"+cxProduto+"' 
cxQry += " AND BF_LOCAL   =  '"+cxLocal+"' "
cxQry += " ORDER BY BF_LOTECTL, BF_LOCALIZ "

MPSysOpenQuery(cxQry,"CXSBFS")

If !CXSBFS->(Eof())
	aAdd(axRet,{CXSBFS->BF_PRODUTO,CXSBFS->BF_LOCALIZ,CXSBFS->BF_LOTECTL, stod(CXSBFS->B8_DTVALID), CXSBFS->BF_QUANT }) 
EndIf

RestArea(cxArea)

Return axRet


Static Function F4PA2Lote(	a		, b			, c			, cProg		,;
					cCod	, cLocal	, lParam	, cLocaliz	,;
					nLoteCtl, cOP		, lLoja		, lAtNumLote)
Local aStruSB8		:={} 
Local aArrayF4		:={}
Local aHeaderF4		:={}
Local nOpt1			:= 1
Local nX
Local cVar
Local cSeek
Local cWhile
Local nEndereco
Local cAlias		:= Alias()
Local nOrdem		:= IndexOrd()
Local nRec			:= RecNo()
Local nValA440		:= 0
Local nHdl			:= GetFocus()
Local cCpo
Local oDlg2
Local cCadastro
Local nOpca
Local cLoteAnt		:= ""
Local cLoteFor		:= ""
Local dDataVali		:= ""
Local dDataCria		:= ""
Local lAdd			:= .F.
Local nSalLote		:= 0
Local nSalLote2		:= 0
Local nPotencia		:= 0
Local nPos2			:= 7
Local nPos3			:= 5
Local nPos4			:= 9
Local nPos5			:= 10
Local nPos6			:= 11
Local nPos7			:= 12
Local nPos8			:= 13
Local aTamSX3		:= {}
Local nOAT
Local aCombo1		:= {"Lote","Validade","Lote Fornecedor"} 
Local aPosObj		:= {}
Local aObjects		:= {}
Local aSize			:= MsAdvSize(.F.)

Local cCombo1		:= ""
Local oCombo1
Local lRastro := Rastro(cCod,"S")						
Local aAreaSBF:={}  
Local cQuery    := ""
Local cAliasSB8 := "SB8"
Local nLoop     := 0 
Local aUsado     := {}
Local cLote241   := ''
Local cSLote241  := ''
Local lLote      := .F.
Local lSLote     := .F.
Local nPos       := 0
Local nPCod241   := 0
Local nPLoc241   := 0
Local nPLote241  := 0
Local nPSLote241 := 0
Local nQuant241  := 0
Local nPQuant241 := 0
Local nPCod261   := 0
Local nPLoc261   := 0
Local nPosLt261  := 0
Local nPSlote261 := 0
Local nQuant261  := 0
Local nPosQuant  := 0
Local nPosQtdLib := 0
Local nMultiplic := 1
Local lRet := .T.
Local lSelLote := (SuperGetMV("MV_SELLOTE") == "1")   
Local lMTF4Lote:= .T.
Local lExisteF4Lote := ExistBlock("F4LoteHeader")
Local cNumDoc  := ""
Local cSerie   := ""
Local cFornece := ""
Local cLoja    := ""
Local lEmpPrev := If(SuperGetMV("MV_QTDPREV")== "S",.T.,.F.)
Local nSaldoCons:=0
Local lVldDtLote := SuperGetMV("MV_VLDLOTE",.F.,.T.)
Local nPosLocaliz := aScan(aHeader,{|x| Trim(x[2])=="PA2_XLOCAL"})
Local nPosDValid  := aScan(aHeader,{|x| Trim(x[2])=="PA2_XDTVAL"})
Local nPosLoteCtl := aScan(aHeader,{|x| Trim(x[2])=="PA2_XLOTE"})


Default cLocaliz:= ""
Default cOP     := ""
Default nLoteCtl:= 1  
Default lLoja	:= .F.
Default lAtNumLote := .T.

If ExistBlock("MTF4LOTE")
	lMTF4Lote := ExecBlock("MTF4LOTE",.F.,.F.,{cProg})
	If Valtype(lMTF4Lote) <> "L"
		lMTF4Lote := .T.
	EndIf
EndIf

cCpo := ReadVar()
lParam := IIf(lParam== NIL, .T., lParam) 
SB1->(dbSetOrder(1))
SB1->(MsSeek(xFilial("SB1")+cCod))
lLote  := Rastro(cCod)
lSLote := Rastro(cCod, 'S')
If !lLote
	Help(" ",1,"NAORASTRO")
	Return nil
Endif
If !lRastro
	nPos2:=1;nPos3:=5;nPos4:=8;nPos5:=9;nPos6:=10;nPos7:=11;nPos8:=12
EndIf	

dbSelectArea("SB8")
dbSetOrder(1)
cSeek := cCod+cLocal
dbSeek(xFilial("SB8")+cSeek)
If !Found()
	HELP(" ",1,"F4LOTE")
	dbSelectArea(cAlias)
	dbSetOrder(nOrdem)
	dbGoto(nRec)
	Return nil
Endif

aTamSX3:=TamSX3(Substr(cCpo,4,3)+"QUANT")
If Empty(aTamSX3)
	aTamSX3:=TamSX3("B8_SALDO")
EndIf

If Localiza(cCod) .And. !Empty(cLocaliz)
	dbSelectArea("SB8")
	dbSetOrder(3)
	dbSelectArea("SBF")
	aAreaSBF:=GetArea()
	dbSetOrder(1)
	cSeek:=xFilial("SBF")+cLocal+cLocaliz+cCod
	dbSeek(cSeek)
	Do While !Eof() .And. cSeek == BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO
		If SB8->(dbSeek(xFilial("SB8")+SBF->BF_PRODUTO+SBF->BF_LOCAL+SBF->BF_LOTECTL+If(!Empty(SBF->BF_NUMLOTE),SBF->BF_NUMLOTE,"")))
			If lVldDtLote .And. SB8->B8_DATA > dDataBase
				SBF->(dbSkip())
				Loop
			EndIf		
			If !Empty(SBF->BF_NUMLOTE) .And. lRastro
				AADD(aArrayF4, F4LoteArray(cProg, lSLote, "SBF", "SBF", {SBF->BF_NUMLOTE,SBF->BF_PRODUTO,Str(SBFSaldo(),14,aTamSX3[2]),Str(SBFSaldo(,,,.T.),14,aTamSX3[2]),SB8->B8_DTVALID,SB8->B8_LOTEFOR,SBF->BF_LOTECTL,SB8->B8_DATA,SB8->B8_POTENCI,SBF->BF_LOCALIZ,SBF->BF_NUMSERI}))
			Else
				AADD(aArrayF4, F4LoteArray(cProg, lSLote, "SBF", "SBF", {SBF->BF_LOTECTL,SBF->BF_PRODUTO,Str(SBFSaldo(),14,aTamSX3[2]),Str(SBFSaldo(,,,.T.),14,aTamSX3[2]),SB8->B8_DTVALID,SB8->B8_LOTEFOR,SB8->B8_DATA,SB8->B8_POTENCI,SBF->BF_LOCALIZ,SBF->BF_NUMSERI}))
			EndIf
		EndIf
		dbSelectArea("SBF")
		dbSkip()
	EndDo
	RestArea(aAreaSBF)
ElseIf lSLote      
	SB8->( dbSetOrder( 1 ) ) 
	cAliasSB8 := GetNextAlias()
	
	aStruSB8 := SB8->( dbStruct() ) 
	
	cQuery := "SELECT * FROM " + RetSqlName( "SB8" ) + " SB8 "
	cQuery += "WHERE "
	cQuery += "B8_FILIAL='"  + xFilial( "SB8" )	+ "' AND " 
	cQuery += "B8_PRODUTO='" + cCod            	+ "' AND " 
	cQuery += "B8_LOCAL='"   + cLocal          	+ "' AND "
	cQuery += IIf(lVldDtLote,"B8_DATA <= '" + DTOS(dDataBase) 	+ "' AND ","")
	cQuery += "D_E_L_E_T_=' ' "
	cQuery += "ORDER BY " + SqlOrder( SB8->( IndexKey() ) ) 		
	
	cQuery := ChangeQuery( cQuery ) 
	
	dbUseArea( .t., "TOPCONN", TcGenQry( ,,cQuery ), cAliasSB8, .f., .t. )
	
	For nLoop := 1 To Len( aStruSB8 ) 			
		If aStruSB8[ nLoop, 2 ] <> "C" 
			TcSetField( cAliasSB8, aStruSB8[nLoop,1],	aStruSB8[nLoop,2],aStruSB8[nLoop,3],aStruSB8[nLoop,4])
		EndIf 		
	Next nLoop 		
		
	While !( cAliasSB8 )->(Eof()) .And. xFilial("SB8")+cSeek == ( cAliasSB8 )->B8_FILIAL+( cAliasSB8 )->B8_PRODUTO+( cAliasSB8 )->B8_LOCAL
		AADD(aArrayF4, F4LoteArray(cProg, lSLote, "SB8", cAliasSB8, {( cAliasSB8 )->B8_NUMLOTE, ( cAliasSB8 )->B8_PRODUTO, Str(SB8Saldo(NIL,NIL,NIL,NIL,cAliasSB8,lEmpPrev,.T.),14,aTamSX3[2]), Str(SB8Saldo(,,,.T.,cAliasSB8,lEmpPrev,.T.),14,aTamSX3[2]), ( cAliasSB8 )->B8_DTVALID, ( cAliasSB8 )->B8_LOTEFOR, ( cAliasSB8 )->B8_LOTECTL, ( cAliasSB8 )->B8_DATA,( cAliasSB8 )->B8_POTENCI}))
		( cAliasSB8 )->( dbSkip() ) 
	EndDo
	
	( cAliasSB8 )->( dbCloseArea() ) 
	dbSelectArea( "SB8" ) 

	
Else
	SB8->( dbSetOrder( 3 ) ) 
	cAliasSB8 := GetNextAlias()
	
	aStruSB8 := SB8->( dbStruct() ) 
	
	cQuery := "SELECT * FROM " + RetSqlName( "SB8" ) + " SB8 "
	cQuery += "WHERE "
	cQuery += "B8_FILIAL='"  + xFilial( "SB8" )	+ "' AND " 
	cQuery += "B8_PRODUTO='" + cCod            	+ "' AND " 
	cQuery += "B8_LOCAL='"   + cLocal          	+ "' AND "
	cQuery += IIf(lVldDtLote,"B8_DATA <= '" + DTOS(dDataBase) 	+ "' AND ","")
	cQuery += "D_E_L_E_T_=' ' "
	cQuery += "ORDER BY " + SqlOrder( SB8->( IndexKey() ) ) 		
	
	cQuery := ChangeQuery( cQuery ) 
	
	dbUseArea( .t., "TOPCONN", TcGenQry( ,,cQuery ), cAliasSB8, .f., .t. )
	
	For nLoop := 1 To Len( aStruSB8 ) 			
		If aStruSB8[ nLoop, 2 ] <> "C" 
			TcSetField( cAliasSB8, aStruSB8[nLoop,1],	aStruSB8[nLoop,2],aStruSB8[nLoop,3],aStruSB8[nLoop,4])
		EndIf 		
	Next nLoop 		
	                                            
	While !( cAliasSB8 )->( Eof()) .And. xFilial("SB8")+cSeek == ( cAliasSB8 )->B8_FILIAL+( cAliasSB8 )->B8_PRODUTO+( cAliasSB8 )->B8_LOCAL
		cLoteAnt:=( cAliasSB8 )->B8_LOTECTL
		cLoteFor:=( cAliasSB8 )->B8_LOTEFOR
		dDataVali:=( cAliasSB8 )->B8_DTVALID
		dDataCria:=( cAliasSB8 )->B8_DATA
		nPotencia:=( cAliasSB8 )->B8_POTENCI 
		cNumDoc  := ( cAliasSB8 )->B8_DOC
		cSerie   := ( cAliasSB8 )->B8_SERIE
		cFornece := ( cAliasSB8 )->B8_CLIFOR
		cLoja    := ( cAliasSB8 )->B8_LOJA

		lAdd	  :=.F.
		nSalLote  :=0
		nSalLote2 :=0
		While !( cAliasSB8 )->( Eof() ) .And. xFilial("SB8")+cSeek+cLoteAnt == ( cAliasSB8 )->B8_FILIAL+( cAliasSB8 )->B8_PRODUTO+( cAliasSB8 )->B8_LOCAL+( cAliasSB8 )->B8_LOTECTL
			nSalLote += SB8Saldo(NIL,NIL,NIL,NIL,cAliasSB8,lEmpPrev,.T.)
			nSalLote2+= SB8Saldo(,,,.T.,cAliasSB8,lEmpPrev,.T.)	
			( cAliasSB8 )->( dbSkip() )
		EndDo
		If QtdComp(nSalLote,.T.) > QtdComp(0,.T.)
			If (nPos:=aScan(aUsado, {|x| x[1] == cLoteAnt})) > 0
				nSalLote  += aUsado[nPos, 3]
				nSalLote2 += ConvUM(cCod, aUsado[nPos, 3], 0, 2)
			EndIf		
		EndIf	
		If QtdComp(nSalLote,.T.) > QtdComp(0,.T.) .Or. ((cProg == "A270" .And. !lParam) .Or. (cProg == "A685" .And. !lParam) .Or. ((cProg == "A240" .Or. cProg == "A241") .And. SF5->F5_TIPO == "D") .Or. (cProg == "A242" .And. cCpo == "M->D3_LOTECTL"))
			AADD(aArrayF4, F4LoteArray(cProg, lSLote, "", "", {cLoteAnt,cCod,Str(nSalLote,aTamSX3[1],aTamSX3[2]),Str(nSalLote2,aTamSX3[1],aTamSX3[2]), (dDataVali), cLoteFor, dDataCria,nPotencia,cNumDoc,cSerie,cFornece,cLoja}))
		EndIf
	EndDo
	
	( cAliasSB8 )->( dbCloseArea() ) 
	dbSelectArea( "SB8" ) 
	
EndIf

If ExistBlock("F4LOTIND")
	aRetPE:= ExecBlock("F4LOTIND",.F.,.F.,{aArrayF4})
	If ValType(aRetPE) == "A" .And. Len(aRetPE) > 0
		aArrayF4:= aClone(aRetPE)
	EndIf
EndIf 

If lMTF4Lote
	If !Empty(aArrayF4)
	
		AAdd( aObjects, { 100, 100, .t., .t.,.t. } )
		AAdd( aObjects, { 100, 30, .t., .f. } )
	
		aSize[ 3 ] -= 50
		aSize[ 4 ] -= 50 	
		
		aSize[ 5 ] -= 100
		aSize[ 6 ] -= 100
		
		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
		aPosObj := MsObjSize( aInfo, aObjects )
	
		cCadastro := OemToAnsi("Saldos por Lote")	
		nOpca := 0
	
		DEFINE MSDIALOG oDlg2 TITLE cCadastro From aSize[7],00 To  aSize[6],aSize[5] OF oMainWnd PIXEL	
		@ 7.1,.4 Say OemToAnsi("Pesquisa Por: ") 
		If lSLote
			aHeaderF4 := {"Sub-Lote","Produto","Saldo Atual","Saldo Atual 2aUM","Validade","Lote Fornecedor","Lote","Dt Emissao","Potencia","Nota Fiscal","Serie","Cliente/Fornecedor","Loja"} 
			aHeaderF4 := RetExecBlock("F4LoteHeader", {cProg, lSLote, aHeaderF4}, "A", aHeaderF4)
			
			If lExisteF4Lote  
				AjustaPosHeaderF4(aHeaderF4, @nPos2, @nPos3, @nPos4, @nPos5, @nPos6, @nPos7, @nPos8)
			EndIf
	        
	        oQual := VAR := cVar := TWBrowse():New( aPosObj[1][1], aPosObj[1][2], aPosObj[1][3], aPosObj[1][4],,aHeaderF4,,,,,,,{|nRow,nCol,nFlags|(nOpca := 1,oDlg2:End())},,,,,,, .F.,, .T.,, .F.,,, )    
			oQual:SetArray(aArrayF4)
			oQual:bLine := { || aArrayF4[oQual:nAT] }
		Else
			aHeaderF4 := {"Lote","Produto","Saldo Atual","Saldo Atual 2aUM","Validade","Lote Fornecedor","Dt Emissao","Potencia","Nota Fiscal","Serie","Cliente/Fornecedor","Loja"}//
			aHeaderF4 := RetExecBlock("F4LoteHeader", {cProg, lSLote, aHeaderF4}, "A", aHeaderF4)
			
			If lExisteF4Lote
				AjustaPosHeaderF4(aHeaderF4, @nPos2, @nPos3, @nPos4, @nPos5, @nPos6, @nPos7, @nPos8)
			EndIf
			
	        oQual := VAR := cVar := TWBrowse():New( aPosObj[1][1], aPosObj[1][2], aPosObj[1][3], aPosObj[1][4],,aHeaderF4,,,,,,,{|nRow,nCol,nFlags|(nOpca := 1,oDlg2:End())},,,,,,, .F.,, .T.,, .F.,,, )    
			oQual:SetArray(aArrayF4)
			oQual:bLine := { || aArrayF4[oQual:nAT] }
		EndIf
		@ aPosObj[2][1]+10,aPosObj[2][2] Say OemToAnsi("Pesquisa Por: ") PIXEL 
		@ aPosObj[2][1]+10,aPosObj[2][2]+50 MSCOMBOBOX oCombo1 VAR cCombo1 ITEMS aCombo1 SIZE 100,44  VALID F4LotePesq(cCombo1,aArrayF4,oQual,oCombo1) OF oDlg2 FONT oDlg2:oFont PIXEL
		
		DEFINE SBUTTON FROM aPosObj[2][1]+10 ,aPosObj[2][4]-58  TYPE 1 ACTION (nOpca := 1,oDlg2:End()) ENABLE OF oDlg2
		DEFINE SBUTTON FROM aPosObj[2][1]+10 ,aPosObj[2][4]-28   TYPE 2 ACTION oDlg2:End() ENABLE OF oDlg2
		
		ACTIVATE MSDIALOG oDlg2 VALID (nOAT := oQual:nAT,.t.) CENTERED
		
		If nOpca ==1

			&(ReadVar()) := aArrayF4[nOAT][nPos2]
			aCols[n, nPosLoteCtl]  := aArrayF4[nOAT][nPos2]
			aCols[n, nPosDValid]   := aArrayF4[nOAT][nPos3]

		EndIf
	Else
		HELP(" ",1,"F4LOTE")
	Endif 
EndIf	
dbSelectArea(cAlias)
dbSetOrder(nOrdem)
dbGoto(nRec)
SetFocus(nHdl)
Return Nil
