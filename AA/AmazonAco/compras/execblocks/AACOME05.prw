#include 'protheus.ch'
#include 'parmtype.ch'
#include 'tbiconn.ch'
#include 'rwmake.ch'

USER FUNCTION COLSA2
RETURN SPACE(10)



user function CTCOMP20(cEmpFil)

	Local aEmpFil 
	Local bWindowInit := { || __Execute( "u_CACOMP2E()" , "xxxxxxxxxxxxxxxxxxxx" , "u_CACOMP2E" , "SIGACOM" , "SIGACOM", 1 , .T. ) } 
	Local cEmp 
	Local cFil 
	Local cMod 
	Local cModName := "SIGACOM" 
	DEFAULT cEmpFil := "01;01" 

	aEmpFil := StrTokArr( cEmpFil , ";" ) 
	cEmp := aEmpFil[1] 
	cFil := aEmpFil[2] 

	SetModulo( @cModName , @cMod ) 

	PREPARE ENVIRONMENT EMPRESA( cEmp ) FILIAL ( cFil ) MODULO ( cMod ) USER 'FV' PASSWORD 'FVADHW'

	InitPublic() 
	SetsDefault() 
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
			cModName := "SIGACOM" 
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

Return Nil

User Function CACOMP2E()
	Private odGetDados := Nil
	SetFunName('MATA110')
	alert(funname())
	MATA120()

Return Nil




User Function AACOME05()
	//	User Function CACOMP01(ogetDados)

	Local aButtons := {}

	Local bKeyF4 := SetKey( VK_F4)
	Local bKeyF6 := SetKey( VK_F6)

	Local bKeyF2 := SetKey( VK_F2)
	Local bKeyF3 := SetKey( VK_F3)
	Local bKeyM := SetKey(26)
	Local aCoors := {}

	Local aArea  := {}//GetArea()
	
	Private _cdFun  := FunName()
	
	If Type("cAcesso") = "U"
		Prepare Environment Empresa '01' Filial '01' Tables "SB1,SBM,SB2,SD3,SD1,SD2"

		Private CA120FORN := "07"
		Private CA120LOJ  := "01"
	Else
	    if _cdFun == "MATA121"
			If !MaFisFound("NF")
				Help("  ",1,"A120CAB") // Campos obrigatorios do cabecalho nao preenchidos.
				return
			EndIf
		EndIf
	EndIf       
	
	aArea  := GetArea()
	
	DEFINE FONT oFnt3 NAME "MS Sans Serif" SIZE 0, -9 BOLD

	Private lChange := .T.
	Private _lMarkAll := .T.

	Private odGrupo := Nil
	Private cdGrupo := ""
	Private adGrupo := GetGrp()

	Private odSeg   := Nil
	Private cdSeg   := ""
	Private adSeg   := {}

	Private odForn  := Nil
	Private cdForn  := ""
	Private adForn  := {}

	Private odFab   := Nil
	Private cdFab   := ""
	Private adFab   := GetFab()

	Private odBlq   := Nil
	Private cdBlq   := ""
	Private adBlq   := {}

	Private odInu   := Nil
	Private cdInu   := ""
	Private adInu   := {}

	Private odPesq := Nil
	Private cdPesq := Space(30)
	
	Private nSaldo := 0 
	Private oSaldo := Nil
	Private cTextHtml :=""
	
	Private adMarcados := {}

	Private _xdDados := {}
	Private _xdCabec := {}
	Private _odBrw    := Nil	

	Private aViewNF
	Private aRecSD1	

	aAdd(adSeg,"Nao")
	aAdd(adSeg,"Sim")

	aAdd(adForn,"Sim")
	aAdd(adForn,"Nao")

	aAdd(adBlq,"Sim")
	aAdd(adBlq,"Nao")

	aAdd(adInu,"Sim")
	aAdd(adInu,"Nao")

	//Local aCabColT := 
	//{" ","Codigo","Descrição","Fabricante","Cos. Med.","Est. Seg.","Est. Disp.","UM","Quant. Ped.","Peso","Saldo Peso","Referencia","Seg. UM"}

	aAdd(_xdCabec, {"Codigo"         ,  {|| _xdDados[_odBrw:at()][03] } , "C" , "@!" , 1, 12 , 0} )	
	aAdd(_xdCabec, {"Descricao"      ,  {|| _xdDados[_odBrw:at()][04] } , "C" , "@!" , 1, 25 , 0} )
	aAdd(_xdCabec, {"Desc.Especif"   ,  {|| _xdDados[_odBrw:at()][13] } , "C" , "@!" , 2, 10 , 2} )
	aAdd(_xdCabec, {"Fabricante"     ,  {|| _xdDados[_odBrw:at()][05] } , "C" , "@!" , 1, 12 , 0} )	
	aAdd(_xdCabec, {"Cons. Med."     ,  {|| _xdDados[_odBrw:at()][06] } , "N" , "@e 999,999,999.99" , 2, 08 , 2} )
	aAdd(_xdCabec, {"Est. Seg."      ,  {|| _xdDados[_odBrw:at()][07] } , "N" , "@e 999,999,999.99" , 2, 08 , 2} )
	aAdd(_xdCabec, {"Est. Disp"      ,  {|| _xdDados[_odBrw:at()][08] } , "N" , "@e 999,999,999.99" , 2, 08 , 2} )
	aAdd(_xdCabec, {"UM"             ,  {|| _xdDados[_odBrw:at()][09] } , "C" , "@!"                , 1, 04 , 0} )
	aAdd(_xdCabec, {"Qt Pedido"      ,  {|| _xdDados[_odBrw:at()][10] } , "N" , "@e 999,999,999.99" , 2, 08 , 2} )
	aAdd(_xdCabec, {"Seg.Um"         ,  {|| _xdDados[_odBrw:at()][14] } , "N" , "@e 999,999,999.99" , 2, 10 , 2} )
	aAdd(_xdCabec, {"NCM"            ,  {|| _xdDados[_odBrw:at()][11] } , "C" , "@!" , 1, 12 , 0} )	
	//aAdd(_xdCabec, {"Saldo Peso"     ,  {|| _xdDados[_odBrw:at()][12] } , "N" , "@e 999,999,999.99" , 2, 10 , 2} )	


	SetKEY(VK_F6,{|| _MarkAll()    })
	SetKEY(VK_F2,{|| u_AACOME5A() })
	SetKEY(VK_F3,{|| u_CACOMP2B() })
	SetKEY(VK_F4,{|| u_CACOMP2C() })

	aCoors := FwGetDialogSize()

	odLayer := FwLayer():New()

	odJanela := TDialog():New(aCoors[01],aCoors[01],aCoors[03],aCoors[04]*90/100,'Filtro ',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	odLayer:init(odJanela,.F.)

	odLayer:AddLine('LIN_TOP',30)
	odLayer:AddLine('LIN_BOTTOM',55)
	odLayer:AddLine('LIN_RODAPE',10)

	odLayer:addCollumn('COL_FULL',60,,'LIN_TOP')
	odLayer:addCollumn('COL_FULL2',40,,'LIN_TOP')
	
	odLayer:addCollumn('COL_FULL',100,,'LIN_BOTTOM')
	odLayer:addCollumn('COL_FULL',100,,'LIN_RODAPE')
	odLayer:AddWindow('COL_FULL','WIN_FULL','Filtros',100,.F.,,,'LIN_TOP')
	odLayer:AddWindow('COL_FULL2','WIN_FULL','Dados Estoque',1,.F.,,,'LIN_TOP')
	
	odLayer:AddWindow('COL_FULL','WIN_FULL','Itens',100,.F.,,,'LIN_BOTTOM')

	odFiltro := odLayer:GetWinPanel('COL_FULL','WIN_FULL','LIN_TOP')
	odEstoque:= odLayer:GetWinPanel('COL_FULL2','WIN_FULL','LIN_TOP')
	
	odItens  := odLayer:GetWinPanel('COL_FULL','WIN_FULL','LIN_BOTTOM')
	odRodape := odLayer:GetColPanel('COL_FULL','LIN_RODAPE')



	//odGrupo
	odFab   := TComboBox():New(01,001,{|u|if(PCount()>0,cdFab  :=u,cdFab  )}, adFab   ,100,20,odFiltro ,,{|| },,,,.T.,,,,,,,,,'cdFab' ,"Fabricante"     ,1)
	odGrupo := TComboBox():New(25,001,{|u|if(PCount()>0,cdGrupo:=u,cdGrupo)}, adGrupo ,100,20,odFiltro ,,{|| },,,,.T.,,,,,,,,,'cdGrupo',"Grupo"          ,1)
	odSeg   := TComboBox():New(01,110,{|u|if(PCount()>0,cdSeg  :=u,cdSeg  )}, adSeg   ,100,20,odFiltro ,,{|| },,,,.T.,,,,,,,,,'cdSeg'  ,"Somente Est Seguranca ?",1)

	//odInu   := TComboBox():New(01,220,{|u|if(PCount()>0,cdInu  :=u,cdInu  )}, adInu   ,100,20,odFiltro ,,{|| },,,,.T.,,,,,,,,,'cdInu'  ,"Filtra Inativos?",1)

	odBlq   := TComboBox():New(25,110,{|u|if(PCount()>0,cdBlq  :=u,cdBlq  )}, adForn  ,100,20,odFiltro ,,{|| },,,,.T.,,,,,,,,,'cdBlq' ,"Filtra Bloqueados ?" ,1)

	odPesq  := TGet():New( 25,220,{|u|if(PCount()>0,cdPesq  :=u ,cdPesq  )},odFiltro,100,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"cdPesq",,,,,,,"Pesquisa",1 )


	lHtml := .T.                      
	oLbSald2 := TSay():New(01,01,{||cTextHtml},odEstoque,,oFnt3,,,,.T.,,,400,300,,,,,,lHtml)
	//oLbSaldo:= TSay():New(01,001,{||'Saldo'} 	 ,odEstoque,,oFnt3,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)   
	//oLbSald2:= TSay():New(01,025,{||nSaldo} 	 ,odEstoque, "@E 999,999,999.99",oFnt3,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)   

	
	odBtn := SButton():New( 001,300,17,{|| MsgRun("Pesquisando Aguarde","Pesquisa", {|| _doFilter()} ) },odFiltro,.T.,,) 

	_odBrw := FWBrowse():New(odItens)
	_odBrw:SetDataArray()	
	_odBrw:DisableReport()
	_odBrw:AddMarkColumns(  { || iif(_xdDados[_odBrw:At()][01],"LBOK","LBNO" ) }, {|| _Mark() } ,{|| _MarkAll() } )
	_odBrw:AddStatusColumns( { || If(_xdDados[_odBrw:At()][02],"BR_VERDE","BR_VERMELHO")  } , {|| }   )
	_odBrw:SetDoubleClick({|| _Mark() })
	_odBrw:SetColumns(_xdCabec)
	_odBrw:SetArray(_xdDados)
	//_odBrw:SetChange({|| MsgRun("Atualizando o estoque do item...","Dados estoque",{|| u_FAtuaEst() }) })

	_odBrw:Activate()

	@001, 065 Say " F2 - Consumo Mensais"   SIZE 70,7 OF odRodape PIXEL RIGHT COLOR CLR_BLUE FONT oFnt3
	@001, 125 Say " F3 - Ultimas Nf's "     SIZE 70,7 OF odRodape PIXEL RIGHT COLOR CLR_BLUE FONT oFnt3
	@001, 185 Say " F4 - Estoque "          SIZE 70,7 OF odRodape PIXEL RIGHT COLOR CLR_BLUE FONT oFnt3
	@001, 275 Say " F6 - (Des)Marcar Todos" SIZE 70,7 OF odRodape PIXEL RIGHT COLOR CLR_BLUE FONT oFnt3

	/*
	@ 015,170 Say "Grupo"  Size 35,8 Of oDialog Pixel Font oFnt3
	@ 015,210 MSCOMBOBOX oGrp VAR _cdGrp ITEMS _adGrp SIZE 100,50 On Change lChange:= .T. Of odFiltro PIXEL

	@ 028,15 Say "Filtra Est. Seg."  Size 45,8 Of oDialog Pixel Font oFnt3
	@ 028,75 MSCOMBOBOX oSeg VAR _cdSeg ITEMS _adSeg SIZE 75,50  On Change lChange:= .T. of odFiltro PIXEL
	*/

	baction := EnchoiceBar(odJanela,{|| Processa({|| _doPedido()},"Exportando Itens, Aguarde... "),odJanela:End() },{|| odJanela:End()},,aButtons ) 
	odJanela:Activate(,,,.T.,/*Validacao para nao fechar a tela*/ ,, {|| odJanela:lEscClose := .F. }/*, EnchoiceBar(odJanela,{|| Processa({|| _doPedido()},"Exportando Itens, Aguarde... "),odJanela:End() },{|| odJanela:End()},,aButtons )  }/*, EnchoiceBar(odJanela,{|| Processa({|| _doPedido()},"Exportando Itens, Aguarde... "),odJanela:End() },{|| odJanela:End()},,aButtons ) )*/  )

Return Nil

Static Function _doPedido()
	Local nPosProd  := aScan(aHeader,{|x| x[02] = "C7_PRODUTO"})
	Local nPosQuant := aScan(aHeader,{|x| x[02] = "C7_QUANT"})
	Local nPosCodTab:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_CODTAB"})
	Local nPosLocal := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_LOCAL" })
	Local nPosPrc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRECO"})
	Local nPosDsc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_VLDESC"})
	Local nPosTotal	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_TOTAL"})
	Local nPosItem 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_ITEM" })

	Local nPosAt    := 0

	If _cdFun == "MATA110"

		nPosProd  := aScan(aHeader,{|x| x[02] = "C1_PRODUTO"})
		nPosQuant := aScan(aHeader,{|x| x[02] = "C1_QUANT"})

		nPosCodTab:= 0 //aScan(aHeader,{|x| AllTrim(x[2]) == "C1_CODTAB"})
		nPosPrc	  := 0 //aScan(aHeader,{|x| AllTrim(x[2]) == "C1_PRECO"})
		nPosDsc	  := 0 //aScan(aHeader,{|x| AllTrim(x[2]) == "C1_VLDESC"})
		nPosTotal := 0 //aScan(aHeader,{|x| AllTrim(x[2]) == "C1_TOTAL"})

	EndIf

	If _cdFun == "MATA105"

		nPosProd  := aScan(aHeader,{|x| x[02] = "CP_PRODUTO"})
		nPosQuant := aScan(aHeader,{|x| x[02] = "CP_QUANT"})

		nPosCodTab:= 0 //aScan(aHeader,{|x| AllTrim(x[2]) == "C1_CODTAB"})
		nPosPrc	  := 0 //aScan(aHeader,{|x| AllTrim(x[2]) == "C1_PRECO"})
		nPosDsc	  := 0 //aScan(aHeader,{|x| AllTrim(x[2]) == "C1_VLDESC"})
		nPosTotal := 0 //aScan(aHeader,{|x| AllTrim(x[2]) == "C1_TOTAL"})

	EndIf

	ProcRegua(Len(adMarcados))

	For _xdI := 01 to Len(adMarcados)
		IncProc()
		If N = 1 .And. Empty(aCols[N,nPosProd])   	// Primeria linha do Acols e sem produtos
			nTam 	:= N
		Else
			If Empty(Acols[N,nPosProd])    			// Já existe uma linha em branco no Acols sem produto, será aproveitada
				nTam 	:= Len(Acols)
				lAADD   := .F.
			Else                              			// Será craida uma nova linha no Acols para o produto escolhido
				nTam 	:= Len(Acols)+1
				lAADD   := .T.
			EndIf
			N:= nTam
		EndIf

		If N > 1
			If lAADD     								// Adiciona uma nova linha no Acols
				Aadd(aCols, Array(len(aHeader)+1) )           // Cria uma nova linha no Acols
			EndIf

			For c:=1 To len(aHeader)
				if !Right(Alltrim(aHeader[c,2]),6) $ "ALI_WT/REC_WT/"
					If aHeader[c,8] $ "C/N/D/M"
						aCols[nTam,c]:= CriaVar(aHeader[c,2],.T.)
					Else
						aCols[nTam,c]:= .F.
					Endif
				EndIf
			Next
			aCols[nTam,len(aHeader)+1] := .F.
		EndIf

		For nY := 1 to Len(aHeader)
			If _cdFun == "MATA121"
				If Trim(aHeader[nY][2]) == "C7_ITEM"
					If N > 1
						aCols[Len(aCols)][nY] := Soma1(aCols[n-1][nY] ) 
					else	
						aCols[Len(aCols)][nY] := StrZero(n,Len(SC7->C7_ITEM))
					endif
				Elseif Trim(aHeader[nY][2]) == "C7_ALI_WT"
					aCols[Len(aCols)][nY]  := "SC7"
				ElseIf Trim(aHeader[nY][2])=="C7_REC_WT"
					aCols[Len(aCols)][nY]  := 0
				Else
					aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2],(aHeader[nY][10] <> "V") )
					
			EndIf
				
			Elseif _cdFun == "MATA110"

				If Trim(aHeader[nY][2]) == "C1_ITEM"
					aCols[Len(aCols)][nY] := StrZero(n,Len(SC7->C7_ITEM))
				Elseif Trim(aHeader[nY][2]) == "C1_ALI_WT"
					aCols[Len(aCols)][nY]  := "SC1"
				ElseIf Trim(aHeader[nY][2])=="C1_REC_WT"
					aCols[Len(aCols)][nY]  := 0
				Else
					aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2],(aHeader[nY][10] <> "V") )
			EndIf
			
			Elseif _cdFun == "MATA105"

				If Trim(aHeader[nY][2]) == "CP_ITEM"
					aCols[Len(aCols)][nY] := StrZero(n,Len(SC7->C7_ITEM))
				Elseif Trim(aHeader[nY][2]) == "CP_ALI_WT"
					aCols[Len(aCols)][nY]  := "SCP"
				ElseIf Trim(aHeader[nY][2])=="CP_REC_WT"
					aCols[Len(aCols)][nY]  := 0
				Else
					aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2],(aHeader[nY][10] <> "V") )
			EndIf


			
			aCols[Len(aCols)][Len(aHeader)+1] := .F.
		ENDIF
		
		Next nY 
						
		//aCols[nTam,n_ColItem] 		:= StrZero(nTam,4)
		//aCols[nTam,nPosItem]  := StrZero(nTam,04)
		aCols[nTam,nPosProd]  := adMarcados[_xdI][03]
		aCols[nTam,nPosQuant] := If(adMarcados[_xdI][10] == 0,1,adMarcados[_xdI][10])				
		
		If _cdFun == "MATA121"
		
			ndPreco := Round(GetPrcCom(adMarcados[_xdI][03]),2)
			aCols[nTam,nPosLocal] := Posicione('SB1',1,xFilial('SB1') + adMarcados[_xdI][03],'B1_LOCPAD')
			aCols[nTam,nPosPrc]   := ndPreco
			aCols[nTam,nPosTotal] := ndPreco * aCols[nTam,nPosQuant]
			
		
			MaFisAdd(aCols[n][nPosProd],"",aCols[n][nPosQuant],aCols[n][nPosPrc],aCols[n][nPosDsc],"","",,0,0,0,0,aCols[n][nPosTotal])
			A120Produto(aCols[nTam,nPosProd])
	    ElseIf _cdFun == "MATA110"
	        n := nTam
	        M->C1_PRODUTO := aCols[nTam,nPosProd]
	        A110Produto(aCols[nTam,nPosProd])
		EndIf
			
		
		For nheader := 1 to Len(aHeader)
			If ExistTrigger(aHeader[nheader,02]) // verifica se existe trigger para este campo
				RunTrigger(2,n,nil,,aHeader[nheader,02])
			Endif
		Next

	Next

	If Type("odGetDados")=="O" .And. Len(adMarcados) > 01 //.And. odGetDados:oMother:lNewLine
		odGetDados:oMother:lNewLine := .F.
		odGetDados:Refresh()   
		//odGetDados:Refresh()
	EndIf

Return Nil

Static Function SetInf(oLbx,nLin,nQuant)

	Local nPosQtd   := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_QUANT"})
	Local nPosQtd2  := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_QTSEGUM"})
	Local ndPreco := Round(1,2)

	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial('SB1')+oLbx:AARRAY[nLin,02]))

	For nX := 1 To Len(aHeader)
		Do Case
			Case Trim(aHeader[nX][2]) == "C7_PRODUTO"
			aCols[n][nX] := oLbx:AARRAY[nLin,02]
			Case Trim(aHeader[nX][2]) == "C7_NUMSC"
			aCols[n][nX] := Space(TamSx3("C1_NUM")[01])
			Case Trim(aHeader[nX][2]) == "C7_ITEMSC"
			aCols[n][nX] := Space(TamSx3("C1_ITEM")[01])
			Case Trim(aHeader[nX][2]) == "C7_LOCAL"
			aCols[n][nX] := SB1->B1_LOCPAD
			Case Trim(aHeader[nX][2]) $ "C7_QUANT#C7_QTDSOL"
			aCols[n][nX] := nQuant
			Case Trim(aHeader[nX][2]) == "C7_PRECO"
			aCols[n][nX] := ndPreco
			Case Trim(aHeader[nX][2]) == "C7_TOTAL"
			aCols[n][nX] := ndPreco * nQuant
			Case Trim(aHeader[nX][2]) == "C7_DESCRI"
			aCols[n][nX] := SB1->B1_DESC			
			Case Trim(aHeader[nX][2]) == "C7_OBS"
			aCols[n][nX] := Space(TamSx3("C1_OBS")[01])//SubStr(SC1->C1_OBS,1,Len(aCols[n][nX]))
			Case Trim(aHeader[nX][2]) == "C7_UM"
			aCols[n][nX] := SB1->B1_UM
			Case Trim(aHeader[nX][2]) == "C7_SEGUM"
			aCols[n][nX] := SB1->B1_SEGUM
			Case Trim(aHeader[nX][2]) == "C7_QTSEGUM"
			aCols[n][nX] := ConvUm(SB1->B1_COD,aCols[n][nPosQtd],aCols[n][nPosQtd2],2)
			Case Trim(aHeader[nX][2]) == "C7_DATPRF"
			aCols[n][nX] := dDataBase
			Case Trim(aHeader[nX][2]) == "C7_CC"
			aCols[n][nX] := Space(TamSx3("C7_CC")[01])
			Case Trim(aHeader[nX][2]) == "C7_ITEMCTA"
			aCols[n][nX] := Space(TamSx3("C7_ITEMCTA")[01])
			Case Trim(aHeader[nX][2]) == "C7_CONTA"
			aCols[n][nX] := Space(TamSx3("C7_CONTA")[01])
			Case Trim(aHeader[nX][2]) == "C7_GRUPCOM"
			aCols[n][nX] := Space(TamSx3("C7_GRUPCOM")[01])
			Case Trim(aHeader[nX][2]) == "C7_CLVL"
			aCols[n][nX] := SB1->B1_CLVL
			Case Trim(aHeader[nX][2]) == "C7_SEQMRP"
			aCols[n][nX] := Space(TamSx3("C7_SEQMRP")[01])
			Case Trim(aHeader[nX][2]) == "C7_OP"
			aCols[n][nX] := Space(TamSx3("C7_OP")[01])
		EndCase
	Next nX
return Nil

Static Function _MarkAll()
	For  _xdK := 01 To Len(_xdDados)
		_Mark(_lMarkAll,_xdK)//_xdDados[_xdK][01] := _lMarkAll
	Next
	_lMarkAll := !_lMarkAll
	_odBrw:Refresh()
Return

Static Function _Mark(lMark,nLine)
	lCont := .T.

	Default lMark := Nil
	Default nLine := _odBrw:At()

	If !_xdDados[nLine][02] //Posicione('SB1',1,xFilial('SB1') + _xdDados[_odBrw:At()][2],'B1_MSBLQL') = '1'
		//Aviso('Atenção','Produto encontra-se Bloqueado',{'Ok'})
		lCont := .F.     
	EndIf

	If lCont
		_xdDados[nLine][01] := If(ValType(lMark) == "L",lMark,!_xdDados[nLine][01])
		If _xdDados[nLine][01]

			If ValType(lMark) != "L"
				nQuant := AAGETQTD()
				_xdDados[nLine][10] := nQuant
				_xdDados[nLine][12] := nQuant * _xdDados[nLine][11]
				_odBrw:Refresh()
			EndIf

			aAdd(adMarcados,aClone(_xdDados[nLine]))
		Else
			xPos := aScan(adMarcados,{|x| x[03] == _xdDados[nLine][03]})
			if xPos > 0
				nTam := Len(adMarcados)
				aDel(adMarcados,xPos)
				aSize(adMarcados,nTam - 01)
			EndIf
		EndIf
	EndIf
Return 

Static Function _doFilter()
	cQry := ""
	nSaldo := 0
	If lChange
		_xdDados := {}
		cQry += " Select * " 
		cQry += "  From " + RetSqlName('SB1') + " SB1"

		/*
		If odForn:nAt == 01
		//cQry += "   Inner Join " + RetSqlName('SA5') + " A5 WITH(NOLOCK) ON A5.D_E_L_E_T_ = '' And A5_PRODUTO = B1_COD And A5_FORNECE = '" + CA120FORN + "' AND A5_LOJA = '" + CA120LOJ + "'"
		cQry += " Inner Join ( 
		cQry += " SELECT DISTINCT AIB_CODPRO FROM " + RetSqlName('AIA') + " AIA WITH(NOLOCK) 
		cQry += "   INNER JOIN " + RetSqlName("AIB") + " AIB WITH(NOLOCK) ON AIB_CODTAB = AIA_CODTAB AND AIB.D_E_L_E_T_ = ' ' AND '" + DTOS(dDataBase) + "' > AIB_DATVIG 
		cQry += " WHERE AIA.D_E_L_E_T_ = ' ' 
		cQry += "   AND AIA_CODFOR = '" + CA120FORN + "' "
		cQry += "   AND AIA_LOJFOR = '" + CA120LOJ  + "' " 
		cQry += "   AND '" + DTOS(dDataBase) + "' BETWEEN AIA_DATDE AND AIA_DATATE  )B ON AIB_CODPRO = B1_COD "	  
		EndIf
		*/   
		cQry += "  Where SB1.D_E_L_E_T_ = ''"
		If odFab:nAt != 01
			cQry += " And B1_FABRIC = '" + Alltrim(cdFab) + "' "
		EndIf	

		If odGrupo:nAt != 1
			cQry += "  And B1_GRUPO  = '" + Alltrim(SubStr(cdGrupo,1,at('-',cdGrupo) - 1)) + "'"
		EndIf

		If odBlq:nAt == 1
			cQry += " And B1_MSBLQL != '1' "
		EndIf

		If odSeg:nAt == 2
			cQry += "  And B1_ESTSEG > 0 And B1_ESTSEG >= (select SUM(B2_QATU) from " + RetSqlName('SB2') + " B2 WHERE B2.D_E_L_E_T_ = '' AND B2_COD = B1_COD) "
		EndIf
/*
		If odInu:nAt == 1
			cQry += "  And B1_GRUPO!= 'INAT' "
		EndIf
*/
		If !Empty(cdPesq)
			cQry += "  And(B1_DESC    Like '%" + Alltrim(cdPesq) + "%'"
			cQry += "   Or B1_ESPECIF Like '%" + Alltrim(cdPesq) + "%'"
			cQry += "   Or B1_COD Like '%" + Alltrim(cdPesq) + "%')"
			
		EndIf
		cQry += " Order by B1_DESC"

		xTbl := MpSysOpenQuery(cQry)
		_lMarkAll := .T.
		While !(xTbl)->(Eof())

			SB2->(dbSetORder(1))
			SB2->(dbSeek(xFilial('SB2') + (xTbl)->B1_COD + (xTbl)->B1_LOCPAD  ))

			aLinha := {}
			aAdd(aLinha, aScan(adMarcados,{|x| x[03] == (xTbl)->B1_COD } ) > 0 )
			aAdd(aLinha, (xTbl)->B1_MSBLQL!='1' )
			aAdd(aLinha, (xTbl)->B1_COD )	
			aAdd(aLinha, (xTbl)->B1_DESC )
			aAdd(aLinha, (xTbl)->B1_FABRIC )
			aAdd(aLinha, GetB3((xTbl)->B1_COD))
			aAdd(aLinha, (xTbl)->B1_ESTSEG)
			aAdd(aLinha, SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QEMP) )
			aAdd(aLinha, (xTbl)->B1_UM )
			aAdd(aLinha, 0 )
			aAdd(aLinha, (xTbl)->B1_PESO )
			aAdd(aLinha, 0 )
			aAdd(aLinha, (xTbl)->B1_ESPECIF  )
			aAdd(aLinha, (xTbl)->B1_SEGUM    )

			//aAdd(aLinha, (xTbl)->)
			aAdd(_xdDados, aLinha)

			(xTbl)->(dbSkip())
		EndDo
		_odBrw:SetArray(_xdDados)
		_odBrw:Goto(1,.T.)
		if Len(_xdDados)>0
			cProduto := _xdDados[_odBrw:nAt][03] 
			//cTextHtml := u_FMontHtml(cProduto)
		EndIf
		oLbSald2:Refresh()
		
		_odBrw:Refresh()
	EndIf
Return Nil
Static Function GetGrp()
	Local aGrp   := {"<Todos>"}
	Local cTable := GetNextAlias()

	BeginSQL Alias cTable
	Select distinct (B1_GRUPO + ' - ' + IsNull(BM_DESC,'N/A')) B1_GRUPO from %Table:SB1% SB1
	Left OUter Join %Table:SBM% on BM_GRUPO = B1_GRUPO
	Where SB1.%notdel%
	Order by B1_GRUPO
	EndSql

	While !(cTable)->(Eof())
		If !Empty((cTable)->B1_GRUPO)
			aAdd(aGrp,(cTable)->B1_GRUPO)
		EndIF
		(cTable)->(dbSKip())
	EndDo
Return aGrp

Static Function GetB3(cProduto)
	Local nMeses := min( int((dDataBase - sTod('20100901') )/ 30) + 1,12)
	Local nMedia := 0

	SB3->(dbSetOrder(1))
	If SB3->(dbSeek(xFilial('SB3')+cProduto))
		For nI := 9 to 12
			nMedia += SB3->&("B3_Q"+StrZero(nI,2))
		Next
		For nI := 1 to nMeses - 4
			nMedia += SB3->&("B3_Q"+StrZero(nI,2))
		Next
	EndIf
	nMedia := nMedia / nMeses
Return nMedia

Static Function GetFab()
	Local aFab   := {"<Todos>"}
	Local cTable := GetNextAlias()

	BeginSQL Alias cTable
	Select distinct B1_FABRIC from %Table:SB1% SB1
	Where SB1.%notdel%
	And Len(B1_FABRIC) != 0
	EndSql

	While !(cTable)->(Eof())
		aAdd(aFab,(cTable)->B1_FABRIC)
		(cTable)->(dbSKip())
	EndDo
Return aFab

Static Function AAGETQTD()

	Local nQuant  := -1

	Define Font oFnt3 Name "Ms Sans Serif" Bold

	while nQuant <= 0
		nQuant := 0
		Define Msdialog oDialog1 Title "Quantidade" From 190,110 to 300,370 Pixel STYLE nOR(WS_VISIBLE,WS_POPUP)
		@ 005,004 Say "Quantidade :" Size 220,10 Of oDialog1 Pixel Font oFnt3
		@ 005,050 Get nQuant         Size 50,10  Picture "@E 999,999.99" //Pixel of oSenhas

		@ 035,042 BmpButton Type 1 Action ( nRet := iIf(nQuant >= 0,oDialog1:End(),nil) )

		Activate Dialog oDialog1 Centered
	Enddo

Return nQuant

User function AACOME5A()    
	SetKEY(VK_F2,{||})
	SetKEY(VK_F3,{||})    
	SetKEY(VK_F6,{||})
	SetKEY(VK_F4,{||})

	MaComViewSm(_xdDados[_odBrw:nAt][03])

	SetKEY(VK_F2,{|| U_AACOME5A() })
	SetKEY(VK_F3,{|| U_CACOMP2B() })
	SetKEY(VK_F4,{|| u_CACOMP2C() })
	SetKEY(VK_F6,{|| _MarkAll()    })
return

User function CACOMP2B()
	SetKEY(VK_F2,{||})
	SetKEY(VK_F8,{||})
	SetKEY(VK_F6,{||})
	SetKEY(VK_F7,{||})


	MaFisSave()

	Private lRefresh	:= .T.
	Private Inclui		:= .F.
	Private Altera		:= .F.
	Private aViewSC8
	Private aViewSC7
	Private aViewNF
	Private aRecSD1

	aArea := GetArea()
	dbSelectArea('SB1')
	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial('SB1') + _xdDados[_odBrw:nAt][03] ))
		MaComViewNF(SB1->B1_COD,.T.)
	EndIf
	RestArea(aArea)

	MaFisEnd()
	//aRefImpos := MaFisRelImp('MT100',{"SC7"})
	//MaFisIni(ca120Forn,ca120Loj,"F","N",Nil, ,,.T.,,,,,,,)
	MaFisRestore()

	SetKEY(VK_F2,{|| U_AACOME5A() })
	SetKEY(VK_F8,{|| U_CACOMP2B() })
	SetKEY(VK_F7,{|| u_CACOMP2C() })
	SetKEY(VK_F6,{|| _MarkAll()    })
Return

User Function CACOMP2C()

	SetKey(13, {|| U_TELAEST(_xdDados[_odBrw:nAt][03] ) } ) 
	MaViewSB2(_xdDados[_odBrw:nAt][03] ) 
	SetKey(13, nil ) 
Return

Static FUnction GetPrcCom(cProduto)

	Local cQry   := ""
	Local nPreco := 0
	Local cTable := GetNextAlias()

	cQry += " SELECT top 1 * FROM " + RetSqlName("SD1")
	cQry += " WHERE D1_COD = '" + cProduto + "'
	cQry += " order by D1_DTDIGIT desc

	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial('SB1') + cProduto ))

	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), cTable, .T., .F. )
	nPreco := iIF(  (cTable)->(EOF()),SB1->B1_UPRC,(cTable)->D1_VUNIT)

	(cTable)->(dbCloseArea(cTable))

Return nPreco



User Function FAtuaEst()
Local cProduto

If Len(_xdDados)>0
	cProduto := _xdDados[_odBrw:nAt][03] 
	cTextHtml:=u_FMontHtml(cProduto)
	
	oLbSald2:Refresh()
EndIf
Return




