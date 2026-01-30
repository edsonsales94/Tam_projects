#INCLUDE "Protheus.ch"
#INCLUDE "Totvs.ch"
 
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MCESTP02   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 04/06/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Apontamento de Produção pela leitura da etiqueta              ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MCESTP02()
	Local nLin    := 5
	Local oFonte  := TFont():New("Arial", 10, 25, .T., .T., 5, .T., 5, .T., .F.)
	Local oFontX  := TFont():New("Arial", 20, 45, .T., .T., 5, .T., 5, .T., .F.)
	Local cAux    := " "
	Local aCampos := {}
	
	AAdd( aCampos , { "D3_OP"     , "", , .F.} )   // 1
	AAdd( aCampos , { "D3_XETIQUE", "", , .F.} )   // 2
	AAdd( aCampos , { "D3_COD"    , "", , .F.} )   // 3
	AAdd( aCampos , { "D3_UM"     , "", , .F.} )   // 4
	AAdd( aCampos , { "D3_LOCAL"  , "", , .F.} )   // 5
	AAdd( aCampos , { "D3_DESCRI" , "", , .F.} )   // 6
	AAdd( aCampos , { "D3_EMISSAO", "", , .T.} )   // 7
	AAdd( aCampos , { "D3_QUANT"  , "", , .F.} )   // 8
	AAdd( aCampos , { "D3_DOC"    , "", , .F.} )   // 9
	AAdd( aCampos , { "D3_LOTECTL", "", , .F.} )   // 10
	AAdd( aCampos , { "D3_XHORA"  , "", , .F.} )   // 11
	AAdd( aCampos , { "D3_PARCTOT", "", , .F.} )   // 12
	
	SX3->(dbSetOrder(2))
	aEval( aCampos , {|x| SX3->(dbSeek(x[1])), x[2] := X3Titulo() } )
	
	Private oDlg, cEtiqueta, oOk, oErro
	Private cStatus := Space(30)
	Private nOpcA   := 0
	Private lRetorno:= .T. // Add Anizio Cunha 27/11/2024
	
	While nOpcA == 0
		nLin  := 5
		nOpcA := 1
		
		// Inicializa as variáveis para a próxima leitura
		aEval( aCampos , {|x| M->&( x[1] ) := CriaVar(x[1],x[4]) } )
		
		SetVariaveis(@aCampos)
		
		DEFINE MSDIALOG oDlg TITLE "Apontamento de Produção" FROM 0, 30 TO 35,105 OF oMainWnd // PIXEL
		
		@ 0,0 MSPANEL oPanelT PROMPT "" SIZE 10,265 OF oDlg CENTERED LOWERED //"Botoes"
		oPanelT:Align := CONTROL_ALIGN_BOTTOM
		
		@ nLin, 020 SAY "Etiqueta: " SIZE 100,15 PIXEL OF oPanelT FONT oFonte COLOR CLR_HBLUE
		@ nLin, 070 MSGET oEtiqueta VAR cEtiqueta  Picture "@!" Valid PesqEtiqueta(@cEtiqueta,@aCampos) SIZE 180,15 PIXEL OF oPanelT FONT oFonte
				
		nLin += 20   // 25
		@ nLin,005 TO nLin+185,295 LABEL "Informações da Etiqueta" PIXEL OF oPanelT
		nLin += 13   // 38
		
		@ nLin,010 SAY aCampos[ 1,2] SIZE 150,20 PIXEL OF oPanelT FONT oFonte COLOR CLR_HBLUE
		@ nLin,210 SAY aCampos[ 2,2] SIZE 060,20 PIXEL OF oPanelT FONT oFonte COLOR CLR_HBLUE
		nLin += 15   // 53
		@ nLin,010 SAY aCampos[ 1,3] VAR M->D3_OP       PIXEL OF oPanelT FONT oFonte COLOR CLR_HRED
		@ nLin,210 SAY aCampos[ 2,3] VAR M->D3_XETIQUE  PIXEL OF oPanelT FONT oFonte COLOR CLR_HRED
		nLin += 20   // 73
		@ nLin,010 SAY aCampos[ 3,2] SIZE 100,20 PIXEL OF oPanelT FONT oFonte COLOR CLR_HBLUE
		@ nLin,110 SAY aCampos[ 4,2] SIZE 060,20 PIXEL OF oPanelT FONT oFonte COLOR CLR_HBLUE
		@ nLin,210 SAY aCampos[ 5,2] SIZE 060,20 PIXEL OF oPanelT FONT oFonte COLOR CLR_HBLUE
		nLin += 15   // 53
		@ nLin,010 SAY aCampos[ 3,3] VAR M->D3_COD    PIXEL OF oPanelT FONT oFonte COLOR CLR_HRED
		@ nLin,110 SAY aCampos[ 4,3] VAR M->D3_UM     PIXEL OF oPanelT FONT oFonte COLOR CLR_HRED
		@ nLin,210 SAY aCampos[ 5,3] VAR M->D3_LOCAL  PIXEL OF oPanelT FONT oFonte COLOR CLR_HRED
		nLin += 20   // 73
		@ nLin,010 SAY aCampos[ 6,2] SIZE 100,20 PIXEL OF oPanelT FONT oFonte COLOR CLR_HBLUE
		nLin += 15   // 88
		@ nLin,010 SAY aCampos[ 6,3] VAR M->D3_DESCRI PIXEL OF oPanelT FONT oFonte COLOR CLR_HRED
		nLin += 20   // 108
		@ nLin,010 SAY aCampos[ 7,2] SIZE 100,20 PIXEL OF oPanelT FONT oFonte COLOR CLR_HBLUE
		@ nLin,210 SAY aCampos[ 8,2] SIZE 100,20 PIXEL OF oPanelT FONT oFonte COLOR CLR_HBLUE
		nLin += 15   // 123
		@ nLin,010 SAY aCampos[ 7,3] VAR M->D3_EMISSAO PIXEL OF oPanelT FONT oFonte COLOR CLR_HRED
		@ nLin,210 SAY aCampos[ 8,3] VAR M->D3_QUANT  Picture "@E 999,999,999.99" PIXEL OF oPanelT FONT oFonte COLOR CLR_HRED
		nLin += 20   // 143
		@ nLin,010 SAY aCampos[ 9,2] SIZE 100,20 PIXEL OF oPanelT FONT oFonte COLOR CLR_HBLUE
		@ nLin,210 SAY aCampos[10,2] SIZE 100,20 PIXEL OF oPanelT FONT oFonte COLOR CLR_HBLUE
		nLin += 15   // 158
		@ nLin,010 SAY aCampos[ 9,3] VAR M->D3_DOC      PIXEL OF oPanelT FONT oFonte COLOR CLR_HRED
	   	@ nLin,210 SAY aCampos[10,3] VAR M->D3_LOTECTL  PIXEL OF oPanelT FONT oFonte COLOR CLR_HRED
		nLin += 20   // 143
		@ nLin,005 TO nLin+40,295 LABEL "Status" PIXEL OF oPanelT //FONT oFonte
		nLin += 11   // 191
		@ nLin,010 SAY oOk   VAR cStatus SIZE 300,20 PIXEL OF oPanelT FONT oFontX COLOR CLR_HBLUE
		@ nLin,010 SAY oErro VAR cStatus SIZE 300,20 PIXEL OF oPanelT FONT oFontX COLOR CLR_HRED
		
		oOk:Hide()
		oErro:Hide()
		
		@ 500, 070 MSGET cAux
		
		ACTIVATE MSDIALOG oDlg CENTERED
	Enddo
	
Return
   
Static Function PesqEtiqueta(cEtiqueta,aCampos)
	Local aVetor
	Local cTMPro := GetMV("MV_XTMPRO",.F.,"001")   // TM de Produção
	Local nPasso := 0
	Local cETQ:= cEtiqueta
	
	cStatus := Space(Len(cStatus))
	nOpcA   := 0
	
	If Empty(cEtiqueta)
		Return .F.
	Endif
	
	Private lMsHelpAuto := .F. // se .t. direciona as mensagens de help para o arq. de log
	Private lMsErroAuto := .F. // necessario a criacao, pois sera atualizado quando houver alguma incosistencia nos parametros
	Private lPerdInf    := SuperGetMV("MV_PERDINF",.F.,.F.)
	Private lUsaSegUm   := .T.
	
	SX3->(dbSetOrder(2))
	If !SX3->(dbSeek("B1_SEGUM")) .Or. !X3USO(SX3->X3_USADO)
		If !SX3->(dbSeek("B2_SEGUM")) .Or. !X3USO(SX3->X3_USADO)
			lUsaSegUm := .F.
		Endif
	EndIf
	
	l240  := .F.
	l241  := .F.
	l242  := .F.
	l250  := .T.
	l185  := .F.
	aGets := {}
	
	lRetorno:=u_MCESTE02(cEtiqueta)  // lRetorno Add Anizio Cunha 27/11/2024
	If lRetorno
		If !lMsErroAuto
			If Empty(M->D3_OP)
				RefVariaveis(@aCampos)
				Return .F.
			Endif
			
			// Processa o apontamento da produção
			aVetor := {}
			AAdd( aVetor , { "D3_FILIAL"  , xFilial("SD3")  , Nil} )
			AAdd( aVetor , { "D3_TM"      , cTMPro          , Nil} )
			AAdd( aVetor , { "D3_CF"      , "PR0"           , Nil} )
			AAdd( aVetor , { "D3_COD"     , M->D3_COD       , Nil} )
			AAdd( aVetor , { "D3_UM"      , M->D3_UM        , Nil} )
			AAdd( aVetor , { "D3_QUANT"   , M->D3_QUANT     , Nil} )
			AAdd( aVetor , { "D3_CONTA"   , Space(20)       , Nil} )
			AAdd( aVetor , { "D3_OP"      , PADR(M->D3_OP,Len(SD3->D3_OP )) , Nil} )
			AAdd( aVetor , { "D3_LOCAL"   , M->D3_LOCAL     , Nil} )
			AAdd( aVetor , { "D3_DOC"     , M->D3_DOC       , Nil} )
			AAdd( aVetor , { "D3_EMISSAO" , M->D3_EMISSAO   , Nil} )
			AAdd( aVetor , { "D3_XETIQUE" , M->D3_XETIQUE   , Nil} )
			AAdd( aVetor , { "D3_XHORA"   , M->D3_XHORA     , Nil} )
			
			If Rastro(M->D3_COD)
				AAdd( aVetor , { "D3_LOTECTL" , M->D3_LOTECTL   , Nil} )
			Endif
			
			AAdd( aVetor , { "D3_PARCTOT" , M->D3_PARCTOT   , Nil} )
			
			cStatus := PADR("LEITURA VÁLIDA",Len(cStatus))
			
			oOk:Show()
			oErro:Hide()
			
			SetVariaveis(@aCampos,.F.)   // Atualiza conteúdos
			RefVariaveis(@aCampos)
			
			SetFunName("MATA250")
			
			BeginTran()
			
			MsgRun("  Apontando produção para a etiqueta " + AllTrim(SubStr(cETQ,17,TamSX3("D3_XETIQUE")[1])),"Aguarde...", {|| MSExecAuto({|x,y,Z| MATA250(x,y) }, aVetor, 3) })
		Endif
	Else // Add Anizio Cunha 27/11/2024
		nOpcA  := 1 // Add Anizio Cunha 27/11/2024
		If !lRetorno // Add Anizio Cunha 27/11/2024
			cEtiqueta:= "" // Add Anizio Cunha 27/11/2024
			cEtiqueta:= Space(40) // Add Anizio Cunha 27/11/2024
			oEtiqueta:Refresh() // Add Anizio Cunha 27/11/2024
			oEtiqueta:SetFocus() // Add Anizio Cunha 27/11/2024
		EndIf // Add Anizio Cunha 27/11/2024
		Return  // Add Anizio Cunha 27/11/2024
	EndIf 
	
	If lMsErroAuto
		cStatus := PADR("ERRO NO APONTAMENTO",Len(cStatus))
		
		oOk:Hide()
		oErro:Show()
		
		DisarmTransaction()
		MostraErro()
		
		RefVariaveis(@aCampos)
		
		MsgRun(" Analisando etiqueta ","Aguarde...", {|| Sleep(1) })
		
		Sleep(2000)
		
		SetVariaveis(@aCampos)
		RefVariaveis(@aCampos)
		
		nPasso := 1
		nOpcA  := 1
	Else
		nPasso := 2
		
		EndTran()
		
		oDlg:End()
	Endif

	//If Empty(cStatus) .or. cStatus

	if cEtiqueta <> ''
		cStatus := PADR("ETIQUETA NÃO EXISTE / JA LIDA ",Len(cStatus))
	endif
	
Return nPasso == 2

Static Function SetVariaveis(aCampos,lLimpa)
	
	If lLimpa == Nil .Or. lLimpa
		cEtiqueta  := CriaVar("D3_XCODBAR",.F.)
		cStatus    := Space(30)
		
		aEval( aCampos , {|x| M->&( x[1] ) := CriaVar(x[1],x[4]) } )
	Else
		cEtiqueta  := M->D3_XCODBAR
	Endif
	
Return

Static Function RefVariaveis(aCampos)
	oEtiqueta:Refresh()
	oOk:Refresh()
	oErro:Refresh()
	aEval( aCampos , {|x| If( ValType(x[3]) == "O" , x[3]:Refresh(), ) } )
Return
