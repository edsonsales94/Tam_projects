#INCLUDE "rwmake.ch"
#include "Protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INCOME01  ºAutor  ³Ener Fredes         º Data ³  30/07/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para o preenchimento do Follow-UP do Pedido de compra º±±
±±º          ³ e ataualização da tabela de SZD                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COMPRAS - PE MA120BUT - PEDIDO DE COMPRA                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function INCOME01(lIncComp,dData)
	Local oFont1   := TFont():New("Arial",,16,.T.,.T.)  
	Local oFont2   := TFont():New("Arial",,13,.F.,.T.)  
	Local cLin  := 20
	Local cPedido  := CA120NUM                                       
	Local cFornece := CA120FORN+CA120LOJ
	Local cNomeFor := Posicione("SA2",1,xFilial("SA2")+cFornece,"A2_NOME")
	
	Local aHeaderb := aHeader
	Local aColsb   := aCols
	
	Private lNoPrazo := .T.
	Private dDataEmis := DA120EMIS
	Private nItens  := 0               
	Private ctipo                 
	Private cConhe     := Space(50)                                                          
	Private dDatae     := sToD("  /  /  ")
	Private dDatac     := sToD("  /  /  ")
	Private dDatar     := sToD("  /  /  ")
	Private dDataef    := sToD("  /  /  ")
	Private dDataec    := sToD("  /  /  ")   
	Private dDataEnv   := sToD("  /  /  ")
	Private cDiasd,oDiasd
	Private cInvoi     := Space(50)
	Private cDi        := Space(50)
	Private cStatusP   := Space(10)
	Private cComprador := Space(50)
	Private cLeadTime,oLeadTime
	Private aStaP      := {"Aprovado","Reprovado"}
	Private aAlt       := {}
	Private cStatc,oStatc
	Private oDatac
	Private aHeader := {}
	Private aCols   := {}      
	Private nUsado  := 0
	Private oDlg                       
	Private dDataPrv := dData
	Private lExist_comp := .T.
	Private cAlias := "SC7"//ALIAS()
	cDiasd := 0
	   
	IIf(SC7->C7_TIPO==1,cTipo:="PC",cTipo:="AE")
	nItens := Tam(cPedido)
/*
	If !ALTERA .And. Len(Alltrim(SC7->C7_CONTRA)) = 0
		MsgBox("Confirme a Inclusao e Altere, Por Favor")
		Return
	EndIf
*/	
	CriaHeader()	  
	MontaCols()
	CarregaCols(cPedido)                                  
	Preenche(cPedido)   	  
	      
	aAdd(aAlt,"ZD_DATA")
	aAdd(aAlt,"ZD_DESC")
	    
	If Empty(dDataEnv)
		dDataEnv   := sToD("  /  /  ")
	EndIf            
	    
	Define MsDialog oDlg Title "Follow Up PO" From 000,000 To 500,650 Pixel
	      
	@cLin,010 SAY OemToAnsi("Pedido - " + cPedido) PIXEL OF oDlg FONT oFont1 
	@cLin,190 SAY OemToAnsi("Data de Entrega Prevista - "+Dtoc(dDataPrv)) PIXEL OF oDlg FONT oFont1 
	cLin += 13
	@cLin,010 SAY OemToAnsi("Fornecedor - "+cNomeFor) PIXEL OF oDlg FONT oFont1 
	cLin += 13
	If Empty(cComprador) .Or. lIncComp
		@cLin+5,010 Say "Comprador" Size 100,7 of oDlg Pixel
		@cLin,080 MsGet cComprador Size 100,10 f3 "SY12" valid fValCompr()oF oDlg Pixel                                 
	Else
		@cLin,010 SAY OemToAnsi("Comprador - "+cComprador) PIXEL OF oDlg FONT oFont1 
		lExist_comp := .F.
	EndIf  
	@cLin+5,190 Say "Data de Envio" Size 100,7 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
	@cLin,265 MsGet dDataEnv Size 45,10 of oDlg  valid fValDatas()  Pixel Picture "@E 99/99/9999"
	cLin += 13
	
	@cLin+5,010 Say "Invoice" Size 100,7 of oDlg Pixel 
	@cLin,080 MsGet cInvoi Size 100,10 of oDlg Pixel 
	@cLin+5,190 Say "Data de Entrega Fornecedor" Size 100,7 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
	@cLin,265 MsGet dDataef Size 45,10 of oDlg valid fValDatas() Pixel Picture "@E 99/99/9999"                           
	cLin += 13
	
	@cLin+5,010 Say "Conhecimento" Size 100,7 of oDlg Pixel
	@cLin,080 MsGet cConhe Size 100,10 oF oDlg Pixel 
	@cLin+5,190 Say "Data de Embarque" Size 100,7 of oDlg Pixel 
	@cLin,265 MSGET dDatae SIZE 45,10 OF oDlg PIXEL PICTURE "@E  99/99/9999" 
	cLin += 13
	      
	@cLin+5,010 Say "Data de chegada" Size 100,7  OF oDlg Pixel
	@cLin,080 MsGet dDatac Size 45,10 of oDlg  Pixel Picture "@E 99/99/9999" 
	cLin += 13
	
	@cLin+5,010 Say "DI" Size 100,7 of oDlg Pixel
	@cLin,080 MsGet    cDi Size 100,10 of oDlg Pixel
	@cLin+5,190 Say "Recebimento" Size 100,7 of oDlg Pixel 
	@cLin,265 MsGet dDatar Size 45,10 of oDlg Pixel Picture "@E 99/99/9999"                           
	cLin += 13
	      
	@cLin+5,010 Say "Entrega do Compras" Size 100,7 PIXEL OF oDlg FONT oFont2 COLOR CLR_HBLUE
	@cLin,080 MsGet oDatac Var dDataec Size 45,10 of oDlg valid fValDatas() Pixel Picture "@E 99/99/9999"                           
	@cLin+5,190 Say "Avaliação"  Size 100,7 of oDlg Pixel
	@cLin,265 MSCOMBOBOX cStatusP ItemS aStaP SIZE 45,50 OF oDlg PIXEL
	cLin += 23
	      
	@cLin,010 Say "Status de Entrega" Size 100,7 of oDlg Pixel
	If lNoPrazo
		@cLin,080 SAY oStatc var OemToAnsi(cStatc) PIXEL OF oDlg FONT oFont1 COLOR CLR_HBLUE
	Else
		@cLin,080 SAY oStatc var OemToAnsi(cStatc) PIXEL OF oDlg FONT oFont1 COLOR CLR_HRED
	EndIf
	@cLin,190 Say "Tempo em dias Decorridos"  Size 100,7 of oDlg Pixel
	
	@cLin,265 SAY oDiasd var OemToAnsi(Alltrim(Str(cDiasd))) PIXEL OF oDlg FONT oFont1 COLOR CLR_HBLUE
	cLin += 13
	
	@cLin,010 Say "Lead Time Fornecedor"  Size 100,7 of oDlg Pixel
	@cLin,080 SAY oLeadTime var OemToAnsi(Alltrim(Str(cLeadTime))+" dias") PIXEL OF oDlg FONT oFont1 COLOR CLR_HBLUE
	    	  
	//oGet := MsGetDados():New(170,010,240,310,4,,,"+ZD_ITEM" , .T., aAlt , , , 700, , , , , oDlg)
 	oGet := MsNewGetDados():New(170,010,240,310,GD_INSERT + GD_UPDATE + GD_DELETE,,,"+ZD_ITEM" ,aAlt , , 700, , , , oDlg,aHeader,aCols)
	
	If !Empty(cComprador)
		aButtons    := {{"BMPUSER",{|| IncComp() },"Comprador","Comprador"}}
	Else
		aButtons    := {}
	EndIf  
	
	Activate MsDialog oDlg on Init;            
	EnchoiceBar(oDlg,{||nOpcA:=1,Iif(Salva(cPedido,dDataPrv),{oDlg:End()},nOpcA:=0)},{||oDlg:End()},,aButtons) Centered   
//	aHeader := aHeaderb
//	aCols   := aColsb
Return Nil


 

Static Function IncComp()
	Local  nOpc := 0, cPswFol := Space(14), lRet := .T.
	Local oFont1  := TFont():New("Courier New",,-14,.T.,.T.)
	Private oPsw
	
	DEFINE MSDIALOG oPsw TITLE "Comprador já informado !!" From 8,70 To 15,110 OF oMainWnd
	@ 05,005 SAY "Digite a Senha para Libera a alteração do Comprador " PIXEL OF oPsw
	@ 15,035 GET cPswFol PASSWORD SIZE 50,10 PIXEL OF oPsw FONT oFont1
	@ 35,010 BUTTON oBut1 PROMPT "&Ok" SIZE 30,12 OF oPsw PIXEL Action IIF(fValidaSenha(cPswFol),(nOpc:=1,oPsw:End()),nOpc:=0)
	@ 35,040 BUTTON oBut2 PROMPT "&Cancela" SIZE 30,12 OF oPsw PIXEL Action (nOpc:=0,oPsw:End())
	ACTIVATE MSDIALOG oPsw
	
Return



Static Function fValidaSenha(cSenha)
	If Alltrim(cSenha) <> "1972"
		Alert("Senha Invalida!!")
		Return  .F.
	EndIf   
	oDlg:End()
	u_INCOME01(.T.,dDataPrv)
Return .t.


Static Function Preenche(cPedido)           
	If (nItens <> 0)
		SZD->(DbSelectArea("SZD")) 
		SZD->(DbSetOrder(2))
		SZD->(DbSeek(xFilial("SZD")+cPedido))       
		cPedido    := SZD->ZD_Pedido 
		cData      := (SZD->ZD_DatEntF)
		cInvoi     := SZD->ZD_Invoice 
		cConhe     := SZD->ZD_Conhec  
		dDatae     := (SZD->ZD_DatEmb)
		dDatac     := (SZD->ZD_DatChe)
		cDi        := (SZD->ZD_DI)
		dDatar     := (SZD->ZD_DatRec)
		cStatusP   := SZD->ZD_Status  
		dDataef    := SZD->ZD_Dataef 
		dDataec    := SZD->ZD_Dataec 
		cComprador := AllTrim(SZD->ZD_Comp)+" - "+Posicione("SY1",1,xFilial("SY1")+SZD->ZD_Comp,"Y1_NOME")
		dDataEnv   := SZD->ZD_DATENV
		if (IIf(Empty(dDataec),Date(),dDataec) > IIf(Empty(dDataPrv),Date(),dDataPrv))
			lNoPrazo := .F.
			cStatc := "Fora do Prazo"  
		Else       
			lNoPrazo := .T.
			cStatc := "No Prazo"
		EndIf                       
	EndIf
	cDiasd     := IIf(Empty(dDataec),Date(),dDataec) - dDataEmis
	cLeadTime  := (IIf(Empty(dDataef),Date(),dDataef) - IIf(Empty(dDataEnv),Date(),dDataEnv))
Return Nil


Static Function CriaHeader()
	SX3->(DbSelectArea("SX3"))
	SX3->(DbSetOrder(1))
	SX3->(DbSeek("SZD"))
	While( !SX3->(EOF()) .And. (Trim(SX3->X3_Arquivo)=="SZD"))
		If(Trim(SX3->X3_Campo)=="ZD_ITEM").Or.(Trim(SX3->X3_Campo)=="ZD_DATA").Or.(Trim(SX3->X3_Campo)=="ZD_DESC")
			aAdd(aHeader,{ Trim(X3Titulo()), ;  //1  Titulo do Campo
							SX3->X3_CAMPO   , ;  //2  Nome do Campo
							SX3->X3_PICTURE , ;  //3  Picture Campo 
							SX3->X3_TAMANHO , ;  //4  Tamanho do Campo
							SX3->X3_DECIMAL , ;  //5  Casas decimais 
							SX3->X3_VALID   , ;  //6  Validacao do campo SX3->X3_VALID
							SX3->X3_USADO   , ;  //7  Usado ou naum
							SX3->X3_TIPO    , ;  //8  Tipo do campo
							SX3->X3_ARQUIVO , ;  //9  Arquivo                	               
							SX3->X3_CONTEXT } )  //10 Visualizar ou alterar
			nUsado++      
		EndIF
		SX3->(DbSkip())
	End  
Return Nil


Static Function MontaCols()  
Local nI       
	Aadd(aCols,Array(nUsado+1))
	For nI := 1 To nUsado
		aCols[1][nI] := CriaVar(Trim(aHeader[nI][2]),.T.)                                             
	Next               
	aCols[1][nUsado+1] := .F.                                                           
	aCols[1][1] := "001"
Return .T.

Static Function CarregaCols(cPedido)   
	Local nTam := nItens                                       
	Local cItem := 1
	If nTam <> 0   
		SZD->(DbSelectArea("SZD"))                  
		SZD->(DbSetOrder(2))
		SZD->(DbGoTop())           
		If SZD->(DbSeek(xFilial("SZD")+cPedido))       
			While SZD->ZD_FILIAL == xFilial("SZD") .And. SZD->ZD_PEDIDO == cPedido
				If Len(aCols) < cItem
					Aadd(aCols,Array(nUsado+1))
				EndIf
				aCols[cItem][1] := StrZero(cItem,3)
				aCols[cItem][2] := (SZD->ZD_DATA)         // 900016     000083      0000000241
				aCols[cItem][3] := Posicione("SZD",1,XFILIAL("SZD")+SZD->ZD_PEDIDO+SZD->ZD_ITEM,"ZD_DESC")
				aCols[cItem][nUsado+1] := .F.                                                           
				cItem++
				SZD->(DbSkip())
			End
		Else
			aCols[1][1] := "001"
			aCols[1][2] := Date()
			aCols[1][3] := ""
		EndIf	
	EndIf  
Return Nil


Static Function Salva(cPedido,cData)
	Local cQuery 
	Local lDetalhe := .F.
    Local cEmail := ""
    Local lComp := .F.
	Local cMens := ""
	Local cNomeComp := ""
	Local i
	
	cQuery := " SELECT COUNT(*) COMPRAD
	cQuery += " FROM "+RetSqlName("SZD")+" SZD
	cQuery += " WHERE ZD_FILIAL = '"+xFilial("SZD")+"' AND ZD_PEDIDO = '"+cPedido+"' AND ZD_COMP = ''
	dbUseArea(.T.,"TOPCONN",TCGenQry(,	,ChangeQuery(cQuery)),"FOLLOWUP",.F.,.T.)
	
	If FOLLOWUP->COMPRAD	== 0
		lComp := .T.
	EndIf

	DbSelectArea("FOLLOWUP")
	DbCloseArea("FOLLOWUP")
	
	
	cQuery := " DELETE "+RetSqlName("SZD")
	cQuery += " WHERE ZD_FILIAL = '"+xFilial("SZD")+"' AND ZD_PEDIDO = '"+cPedido+"' 
	TCSQLEXEC(cQuery)
   
   aHeader := aClone(oGet:aHeader)
	aCols   := aClone(oGet:aCols)
	
	SZD->(DbSetOrder(1))
	SZD->(DbGoTop())
	For i := 1 To Len(aCols)
		If !aCols[i][4] 
			lDetalhe := .T.
			SZD->(RecLock("SZD",.T.))
			SZD->ZD_Filial  := xFilial("SZD")
			SZD->ZD_Pedido  := cPedido
			SZD->ZD_DatEntF := cData
			SZD->ZD_Invoice := cInvoi
			SZD->ZD_Conhec  := cConhe
			SZD->ZD_DatEmb  := dDatae
			SZD->ZD_DatChe  := dDatac
			SZD->ZD_DI      := cDi
			SZD->ZD_DatRec  := dDatar
			SZD->ZD_TemDia  := Iif(Empty(cDiasD),"",Alltrim(Str(cDiasD)))
			SZD->ZD_StaEnt  := cStatc
			SZD->ZD_Status  := cStatusP
			SZD->ZD_Item    := aCols[i][1]
			SZD->ZD_Data    := aCols[i][2]
			SZD->ZD_Desc    := aCols[i][3]          
			SZD->ZD_Dataef  := dDataef
			SZD->ZD_Dataec  := dDataec
			SZD->ZD_Comp    := SubStr(cComprador,1,3)
			SZD->ZD_DatEnv  := dDataEnv                               
			SZD->(MsUnlock()) 
		EndIf
	Next               
	If !lDetalhe
		SZD->(RecLock("SZD",.T.))
		SZD->ZD_Filial  := xFilial("SZD")
		SZD->ZD_Pedido  := cPedido
		SZD->ZD_DatEntF := cData
		SZD->ZD_Invoice := cInvoi
		SZD->ZD_Conhec  := cConhe
		SZD->ZD_DatEmb  := dDatae
		SZD->ZD_DatChe  := dDatac
		SZD->ZD_DI      := cDi
		SZD->ZD_DatRec  := dDatar
		SZD->ZD_TemDia  := Iif(Empty(cDiasD),"",Alltrim(Str(cDiasD)))
		SZD->ZD_StaEnt  := cStatc
		SZD->ZD_Status  := cStatusP
		SZD->ZD_Dataef  := dDataef
		SZD->ZD_Dataec  := dDataec
		SZD->ZD_Comp    := SubStr(cComprador,1,3)
		SZD->ZD_DatEnv  := dDataEnv                               
		SZD->(MsUnlock()) 
	EndIf       
	If lComp .And. !Empty(cComprador) .And. lExist_comp
		cEmail     := Posicione("SY1",1,xFilial("SY1")+SubStr(cComprador,1,3),"Y1_EMAIL")
		cNomeComp := Posicione("SY1",1,xFilial("SY1")+SubStr(cComprador,1,3),"Y1_NOME")
		cMens := "O Pedido de Compra alocado para "+Alltrim(cNomeComp)+" como comprador(a)"
	   cMens += u_INCOMW03(xFilial("SC7"),cPedido)

		u_INMEMAIL("O Pedido de Compra alocado para "+Alltrim(cNomeComp)+" como comprador(a)",cMens,cEmail)

	EndIf
	n := 1        
	DbSelectArea("SC7")
Return .T.                                                                                                          

Static Function Tam(cPedido)                                                         
	Local Retorno
	Local cQry := ""
	cQry += " Select Count(*) As count From " + RetSqlName("SZD")
	cQry += " As SZD "                                    
	cQry += " Where ZD_PEDIDO = '" + cPedido + "' "
	cQry += " And D_E_L_E_T_ <> '*'"
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "cont", .T., .F. )
	DbSelectArea("Tab")                 
	Retorno := cont->count
	cont->(DbCloseArea())
Return Retorno
           

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida as Data da Tela de Follow-Up³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fValDatas()
	cLeadTime  := (IIf(Empty(dDataef),Date(),dDataef) - IIf(Empty(dDataEnv),Date(),dDataEnv))
	cDiasd     := IIf(Empty(dDataec),Date(),dDataec) - dDataEmis
	if (IIf(Empty(dDataec),Date(),dDataec) > IIf(Empty(dDataPrv),Date(),dDataPrv))
		lNoPrazo := .F.
		cStatc := "Fora do Prazo"  
	Else       
		lNoPrazo := .T.
		cStatc := "No Prazo"
	EndIf                       
	
	oDiasd:Refresh()             
	oLeadTime:Refresh()             
	oStatc:Refresh()
	oDlg:Refresh()             
Return .T.                                    


Static Function fValCompr()
	SY1->(DbSetOrder(1))
	If !SY1->(DbSeek(xFilial("SY1")+Left(cComprador,3)))
		Alert("Comprador não cadatrado!!")
		Return  .F.  
	EndIf
Return  .T.
