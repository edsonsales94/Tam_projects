#include 'TBICONN.ch'  
#include "TOTVS.CH"
#include "RPTDEF.CH"
#include "fwprintsetup.ch"
#Include 'ParmType.ch'

User Function SEPARACAO(cEmpFil)
	Local aEmpFil 
	Local bWindowInit := { || __Execute( "u_AAACDC01()" , "xxxxxxxxxxxxxxxxxxxx" , "AAACDC01" , "SIGAFAT" , "SIGAFAT", 1 , .T. ) } 
	Local cEmp 
	Local cFil 
	Local cMod 
	Local cModName := "SIGAFAT" 
	DEFAULT cEmpFil := "01;01" 

	aEmpFil := StrTokArr( cEmpFil , ";" ) 
	cEmp := aEmpFil[1] 
	cFil := aEmpFil[2] 

	SetModulo( @cModName , @cMod ) 

	PREPARE ENVIRONMENT EMPRESA( cEmp ) FILIAL ( cFil ) MODULO ( cMod ) USER 'arlindo.neto' PASSWORD '123456'

	//InitPublic() 
	//SetsDefault() 
	SetModulo( @cModName , @cMod ) 

	DEFINE WINDOW oMainWnd FROM 001,001 TO 400,500 TITLE OemToAnsi( FunName() ) 

	ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT ( Eval( bWindowInit ) , oMainWnd:End() ) 
	RESET ENVIRONMENT 
Return( NIL ) 

/*/ Funcao: SetModulo Data: 30/04/2011 Autor: Marinaldo de Jesus Descricao: Setar o Modulo em Execucao Sintaxe: SetModulo( @cModName , @cMod ) /*/ 

Static Function SetModulo( cModName , cMod )
	Local aRetModName := RetModName( .T. ) 
	Local cSvcModulo 
	Local nSvnModulo 
	IF ( Type("nModulo") == "U" ) 
		_SetOwnerPrvt( "nModulo" , 0 ) 
	Else 
		nSvnModulo := nModulo 
	EndIF 
	cModName := Upper( AllTrim( cModName ) ) 
	IF ( nModulo <> aScan( aRetModName , { |x| Upper( AllTrim( x[2] ) ) == cModName } ) ) 
		nModulo := aScan( aRetModName , { |x| Upper( AllTrim( x[2] ) ) == cModName } ) 
		IF ( nModulo == 0 ) 
			cModName := "SIGAFAT" 
			nModulo := aScan( aRetModName , { |x| Upper( AllTrim( x[2] ) ) == cModName } ) 
		EndIF 
	EndIF 
	IF ( Type("cModulo") == "U" ) 
		_SetOwnerPrvt( "cModulo" , "" ) 
	Else 
		cSvcModulo := cModulo 
	EndIF 

	cMod := SubStr( cModName , 5 ) 
	IF ( cModulo <> cMod ) 
		cModulo := cMod 
	EndIF 
Return( { cSvcModulo , nSvnModulo } )


User Function AAACDC01()
	Local lRet        	:= .T.
	Local cArea       	:= GetArea()
	Local aButtons 		:= {}

	Private oDlgxy    	:= Nil
	Private _oBrowCabec := Nil
	Private _oBrowIt   	:= Nil
	Private _oBrowEtq   := Nil
	Private _OBROWSC9   := Nil

	Private _xdSepCabec := {}
	Private _xdItCabec  := {}
	Private _xdEtCabec  := {}
	Private _xdSC9Cabec := {}

	Private _xSepDados := {}	
	Private _xItDados  := {}
	Private _xEtiq     := {}
	Private _xSC9      := {}

	Private aCoors     := FwGetDialogSize()
	


	aAdd(_xdSepCabec, {"Num. Ordem"     ,  {|| _xSepDados[_oBrowCabec:at()][02] } , "C" , "@!" , 1, 8 , 0} )
	aAdd(_xdSepCabec, {"Num. Pedido"   	,  {|| _xSepDados[_oBrowCabec:at()][03] } , "C" , "@!" , 1, 8 , 0} )
	aAdd(_xdSepCabec, {"Dt. Emissao"   	,  {|| _xSepDados[_oBrowCabec:at()][04] } , "D" , "@!" , 1, 8 , 0} )
	aAdd(_xdSepCabec, {"Cliente"  		,  {|| _xSepDados[_oBrowCabec:at()][05] } , "C" , "@!" , 1, 20 , 0} )
	aAdd(_xdSepCabec, {"Operador"  		,  {|| _xSepDados[_oBrowCabec:at()][06] } , "C" , "@!" , 1, 8 , 0} )
	
	aAdd(_xdItCabec, {"Item"     		,  {|| _xItDados[_oBrowIt:at()][02] } , "C" , "@!" , 1, 8 , 0} )
	aAdd(_xdItCabec, {"Produto"   		,  {|| _xItDados[_oBrowIt:at()][03] } , "C" , "@!" , 1, 7 , 0} )
	aAdd(_xdItCabec, {"Descricao"      	,  {|| _xItDados[_oBrowIt:at()][04] } , "C" , "@!" , 1, 20 , 0} )
	aAdd(_xdItCabec, {"Qtd."   			,  {|| _xItDados[_oBrowIt:at()][05] } , "N" , "@R 999,999,999.99" , 2, 6 , 2} )
	aAdd(_xdItCabec, {"Saldo"   		,  {|| _xItDados[_oBrowIt:at()][06] } , "N" , "@R 999,999,999.99" , 2, 6 , 2} )


	aAdd(_xdEtCabec, {"Etiqueta"    	,  {|| _xEtiq[_oBrowEtq:at()][02] } , "C" , "@!" , 1, 8 , 0} )
	aAdd(_xdEtCabec, {"Endereço"   		,  {|| _xEtiq[_oBrowEtq:at()][03] } , "C" , "@!" , 1, 8 , 0} )
	aAdd(_xdEtCabec, {"Quantidade"  	,  {|| _xEtiq[_oBrowEtq:at()][04] } , "N" , "@e 999,999,999.99" , 2, 6 , 2} )
	aAdd(_xdEtCabec, {"Lote"         	,  {|| _xEtiq[_oBrowEtq:at()][05] } , "C" , "@!" , 1, 8 , 0} )
	aAdd(_xdEtCabec, {"Operador"        ,  {|| _xEtiq[_oBrowEtq:at()][06] } , "C" , "@!" , 1, 8 , 0} )


	aAdd(_xdSC9Cabec, {"Dt. Liberacao"  ,  {|| _xSC9[_oBrowSC9:at()][01] } , "D" , "@!" , 1, 8 , 0} )
	aAdd(_xdSC9Cabec, {"Produto"       	,  {|| _xSC9[_oBrowSC9:at()][02] } , "C" , "@!" , 1, 7 , 0} )
	aAdd(_xdSC9Cabec, {"Qtd. Liberada" 	,  {|| _xSC9[_oBrowSC9:at()][03] } , "N" , "@R 999,999,999.99" , 2, 6 , 2} )
	aAdd(_xdSC9Cabec, {"Armazem"  		,  {|| _xSC9[_oBrowSC9:at()][04] } , "C" , "@!" , 2, 6 , 2} )
	aAdd(_xdSC9Cabec, {"Lote"         	,  {|| _xSC9[_oBrowSC9:at()][05] } , "C" , "@!" , 1, 8 , 0} )
	aAdd(_xdSC9Cabec, {"Nota Fiscal"    ,  {|| _xSC9[_oBrowSC9:at()][06] } , "C" , "@!" , 1, 9 , 0} )



	Processa( {|| FCarrega() },"Processa","Aguarde, carregando os dados ..." )

	oDlgxy := TDialog():New(aCoors[1],aCoors[2],aCoors[3],aCoors[4],"Acompanhamento Ordem Separação",,,,nOr(WS_VISIBLE,WS_POPUP),,,,,.T.,,,,,,)

	Define Timer oTimer Interval 60000 Action AtuGrid() of oDlgxy
	oTimer:Activate()

	oLayer := FWLayer():new()
	oLayer:Init(oDlgxy,.F.)

	oLayer:AddLine("ALL",100,.T.)

	oLayer:addCollumn("LEFT",25,,'ALL')
	oLayer:addCollumn("MIDDLE",25,,'ALL')
	oLayer:addCollumn("RIGHT",25,,'ALL')
	oLayer:addCollumn("TWORIGHT",25,,'ALL')

	oLayer:AddWindow("LEFT",'WIN_FULL','Ordem de Separação	',100,.F.,,,'ALL')
	oLayer:AddWindow("MIDDLE",'WIN_FULL','Itens da Ordem de Separação		',100,.F.,,,'ALL')
	oLayer:AddWindow("RIGHT",'WIN_FULL','Etiquetas lidas 		',100,.F.,,,'ALL')
	oLayer:AddWindow("TWORIGHT",'WIN_FULL','Saldo Liberado 		',100,.F.,,,'ALL')

	_odLeft	 		:= oLayer:getWinPanel('LEFT'	,'WIN_FULL','ALL')
	_odMiddle		:= oLayer:getWinPanel('MIDDLE' ,'WIN_FULL','ALL')
	_odRight 		:= oLayer:getWinPanel('RIGHT' 	,'WIN_FULL','ALL')
	_odTwoRight 	:= oLayer:getWinPanel('TWORIGHT' 	,'WIN_FULL','ALL')

	_oPLeft 		:= TPanel():Create(_odLeft,01,01,"",,,,,,10,10)
	_oPLeft:Align	:= CONTROL_ALIGN_ALLCLIENT

	_oPMiddle 		:= TPanel():Create(_odMiddle,01,01,"",,,,,,10,10)
	_oPMiddle:Align := CONTROL_ALIGN_ALLCLIENT

	_oPRight 		:= TPanel():Create(_odRight,01,01,"",,,,,,10,10)
	_oPRight:Align 	:= CONTROL_ALIGN_ALLCLIENT

	_oPTwoRight 		:= TPanel():Create(_odTwoRight,01,01,"",,,,,,10,10)
	_oPTwoRight:Align 	:= CONTROL_ALIGN_ALLCLIENT


	_oBrowCabec := FWBrowse():New(_oPLeft)
	_oBrowCabec:SetDataArray()
	_oBrowCabec:DisableReport() 
	_oBrowCabec:DisableConfig()
	_oBrowCabec:AddStatusColumns( { || If(_xSepDados[_oBrowCabec:At()][01] =="1","BR_AMARELO",If(_xSepDados[_oBrowCabec:At()][01] =="2" ,"BR_VERDE",iIf(_xSepDados[_oBrowCabec:At()][01] == "3","BR_VERMELHO",iIf(_xSepDados[_oBrowCabec:At()][01] == "4","BR_AZUL",iIf(_xSepDados[_oBrowCabec:At()][01] == "5","BR_PINK",   )   ))))  } , {|| }   )
	_oBrowCabec:SetColumns(_xdSepCabec)
	_oBrowCabec:SetArray(_xSepDados)
	_oBrowCabec:SetChange({|| AtuaItem() } )
	//_oBrowCabec:SetSeek(.T.)
	 

	_oBrowCabec:Activate()

	_oBrowIt := FWBrowse():New(_oPMiddle)
	_oBrowIt:SetDataArray()
	_oBrowIt:DisableReport()
	_oBrowIt:DisableConfig()
	_oBrowIt:AddStatusColumns( { || If(_xItDados[_oBrowIt:At()][01] == "1" ,"BR_VERMELHO","BR_VERDE")  } , {|| }   )
	_oBrowIt:SetColumns(_xdItCabec)
	_oBrowIt:SetArray(_xItDados)
	_oBrowIt:SetChange({|| AtuaEtiq(),AtuaSC9() } ) 

	_oBrowIt:Activate()

	_oBrowEtq := FWBrowse():New(_oPRight)
	_oBrowEtq:SetDataArray()
	_oBrowEtq:DisableReport()
	_oBrowEtq:DisableConfig()
	_oBrowEtq:AddStatusColumns( { || If(!Empty(_xEtiq[_oBrowEtq:At()][01]),"BR_VERMELHO","BR_VERDE")  } , {|| }   )
	_oBrowEtq:SetColumns(_xdEtCabec)
	_oBrowEtq:SetArray(_xEtiq)

	_oBrowEtq:Activate()


	_oBrowSC9 := FWBrowse():New(_oPTwoRight)
	_oBrowSC9:SetDataArray()
	_oBrowSC9:DisableReport()
	_oBrowSC9:DisableConfig()
	_oBrowSC9:SetColumns(_xdSC9Cabec)
	_oBrowSC9:SetArray(_xSC9)

	_oBrowSC9:Activate()


	//bAction := EnchoiceBar(oDlgxy,{|| LjMsgRun(OemToAnsi("Aguarde, Concluindo a conferÃªncia do KANBAN..."),,{|| _doConfere(),oDlgxy:End()}) },{|| _doCancel(),oDlgxy:End()},,aButtons)
	oDlgxy:Activate(,,,.T.,{|| },,{|| } )
Return

Static Function FCarrega()
	Local cQuery := ""

	cQuery +=" SELECT "
	cQuery +=" CASE WHEN (PA1_STATUS='3' AND CB7_NOTA <>'') THEN '5' "
	cQuery +=" ELSE "
	cQuery +=" PA1_STATUS "
	cQuery +=" END PA1_STAT,* " 			
	cQuery +=" FROM "+RetSQLName("PA1")+" (NOLOCK)  PA1 "
	cQuery +=" LEFT JOIN "+RetSQLName("CB7")+" (NOLOCK) CB7 ON "
	cQuery +=" CB7.D_E_L_E_T_='' AND PA1_NUM=CB7_ORDSEP "
	cQuery +=" WHERE PA1.D_E_L_E_T_=''  "
	cQuery +=" ORDER BY PA1_NUM "

	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQuery)), "CRG", .T., .F. )

	While !CRG->(Eof())
		aAdd(_xSepDados,{CRG->PA1_STAT,CRG->PA1_NUM,CRG->PA1_PEDIDO,StoD(CRG->PA1_EMISSAO),Posicione("SA1",1,xFilial("SA1")+CRG->PA1_CLIENT,"A1_NOME"),CRG->CB7_CODOPE})	
		CRG->(DbSkip())
	EndDo
	CRG->(DbCloseArea("CRG"))
Return


Static Function AtuaItem()
	Local cQuery := ""
	_xItDados := {}

	cQuery +=" SELECT * FROM "+RetSQLName("CB8")+" (NOLOCK) CB8 "
	cQuery +=" WHERE CB8.D_E_L_E_T_=''  "
	cQuery +=" AND CB8.CB8_ORDSEP='"+_xSepDados[_oBrowCabec:At()][02]+"' "
	cQuery +=" ORDER BY CB8_ITEM "

	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQuery)), "CRG", .T., .F. )

	While !CRG->(Eof())
		aAdd(_xItDados,{If(CRG->CB8_SALDOS>0,"2","1"),CRG->CB8_ITEM,CRG->CB8_PROD,Posicione("SB1",1,xFilial("SB1")+CRG->CB8_PROD,"B1_DESC"),CRG->CB8_QTDORI,CRG->CB8_SALDOS})	
		CRG->(DbSkip())
	EndDo

	CRG->(DbCloseArea("CRG"))
	If Valtype(_oBrowIt)<>"U"
		_oBrowIt:SetArray(_xItDados)
		_oBrowIt:Refresh()
	EndIf
	AtuaEtiq()
	AtuaSC9()

Return

Static Function AtuaEtiq()
	Local cQuery := ""
	_xEtiq := {}
	If Len(_xItDados)>0
		If ValTYPE(_oBrowIt)=="U"
			nPos := 1
		Else
			nPos := _oBrowIt:At()
		EndIf

		cQuery +=" SELECT * FROM "+RetSQLName("CB9")+" (NOLOCK) CB9 "
		cQuery +=" WHERE CB9.D_E_L_E_T_=''  "
		cQuery +=" AND CB9.CB9_ORDSEP='"+_xSepDados[_oBrowCabec:At()][02]+"' "
		cQuery +=" AND CB9.CB9_PROD='"+_xItDados[nPos][03]+"' "
		cQuery +=" AND CB9.CB9_ITESEP='"+_xItDados[nPos][02]+"' "
		cQuery +=" ORDER BY CB9_CODETI "

		dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQuery)), "CRG", .T., .F. )

		While !CRG->(Eof())
			aAdd(_xEtiq,{"2",CRG->CB9_CODETI,CRG->CB9_LCALIZ,CRG->CB9_QTESEP,CRG->CB9_LOTECT,CRG->CB9_CODSEP})	
			CRG->(DbSkip())
		EndDo
		CRG->(DbCloseArea("CRG"))
		If Valtype(_oBrowEtq)<>"U"
			_oBrowEtq:SetArray(_xEtiq)
			_oBrowEtq:Refresh()
		EndIf
	EndIf
Return

Static Function AtuaSC9()
	Local cQuery := ""
	_xSC9 := {}
	If Len(_xItDados)>0  

		If _xSepDados[_oBrowCabec:At()][01]$"3/5"
			If ValTYPE(_oBrowIt)=="U"
				nPos := 1
			Else
				nPos := _oBrowIt:At()
			EndIf

			cQuery +=" SELECT * FROM "+RetSQLName("SC9")+" (NOLOCK) SC9 "
			cQuery +=" WHERE SC9.D_E_L_E_T_=''  "
			cQuery +=" AND SC9.C9_ORDSEP='"+_xSepDados[_oBrowCabec:At()][02]+"' "
			cQuery +=" AND SC9.C9_PRODUTO='"+_xItDados[nPos][03]+"' "
			cQuery +=" ORDER BY C9_PRODUTO "

			dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQuery)), "CRG", .T., .F. )

			While !CRG->(Eof())
				aAdd(_xSC9,{StoD(CRG->C9_DATALIB),CRG->C9_PRODUTO,CRG->C9_QTDLIB,CRG->C9_LOCAL,CRG->C9_LOTECTL,CRG->C9_NFISCAL})	
				CRG->(DbSkip())
			EndDo
			CRG->(DbCloseArea("CRG"))
		EndIf
		If Valtype(_oBrowSC9)<>"U"
			_oBrowSC9:SetArray(_xSC9)
			_oBrowSC9:Refresh()
		EndIf
	EndIf
Return
Static Function AtuGrid()

	Processa( {|| FCarrega() },"Processa","Aguarde atualizando o Grid..." )// Substituido pelo assistente de conversao do AP5 IDE em 12/01/01 ==> Processa( {|| Execute(RefrDlg) } )

Return
