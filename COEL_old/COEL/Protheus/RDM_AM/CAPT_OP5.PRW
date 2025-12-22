#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#include "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CApt_Op5  ³ Autor ³ Carlos Nina           ³ Data ³19/09/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Solicitacao de Material para a Producao por O.P.           ³±±
±±³          ³ Somente em casos de: Scrape/Falta/Troca                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Coelmatic/Manaus                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CApt_Op5()

Local _aArea := GetArea()
Local cLogo  := FisxLogo("1")
Local cNullo := " "

Private oVd  := LoadBitmap( GetResources(), 'br_verde')
Private oVm  := LoadBitmap( GetResources(), 'br_vermelho')
Private oAm  := LoadBitmap( GetResources(), 'br_amarelo')

Private cmServer  := GETMV("MV_WFSMTP")
Private cmAccount := GETMV("MV_WFMAIL")
Private cmPassw   := GETMV("MV_RELPSW")

Private cSetor     := "01"
Private _cOp	    := Space(11)
Private _nQuant	 := 0
Private _nQtde     := 0
Private _nQuje     := 0
Private _nSaldo    := 0
Private _cProd	    := Space(40)
Private _cCod	    := Space(30)
Private _cDesc     := Space(30)
Private _cUm	    := Space(3)
Private _cAlmox	 := Space(2)
Private _cCentro   := Space(1)
Private _cObs      := Space(1)
Private aCols      := { {"0","",SPACE(20),0,0} }
Private aTroca     := { {"0","","",SPACE(20),0,0} }

Private oMatricula,oOP,oUsuario,oSayuser
Private oGroup1,oGroup2,oGroup3,oGroup4,oGroup5,oGroup6,oTBar,oButton,oBrowse,oTroca,oSdo,oSaldo
Private oLbl5,oBold,oLegVm,oLegAz,oLegAm
Private oCodDe,oPrdDe,oDescDe,oQtdDe,oQtyDe
Private oTBitMap,oTBitMap1,oTBitMap2,oTBmp1,oTBmp2,oTBmp3,oTBmp4,oTBmp5,oTBmpVm,oTBmpAz,oTBmpAm
Private oCracha,oOperacao,oRecurso,oNumero,oNOP,oProdDesc,oProduto,oDescri,oObs,oObserv,oAlmox,oLocal
Private oQtdPed,oQtyPed,oQtdEnt,oQtyEnt,oQtdSdo,oQtySdo,oSequen,oQty,oCentro,oCTrab,oNullo

// Variaveis Private da Funcao
Private _oDlg				// Dialog Principal
Private _nHRes 		:= oMainWnd:nClientWidth
Private _cTheme		:= Alltrim(GetTheme())
Private _lMdiChild	:= SetMdiChild()
Private cMatricula   := Space(9)
Private cOP          := Space(8)
Private cSolicitante := Space(10)
Private cPrdDe       := Space(30)
Private cDescDe      := Space(30)
Private nQtyDe       := 0
Private lEmProcesso  := .F.
Private aRet         := FwTimeUF("AM")                              ///aRet[1] = 20140227  ; aRet[2] = 17:32:33		
Private cHora        := LEFT(STRTRAN(aRet[2],":",""),4)

DEFINE FONT 	oBold NAME "Times New Roman"	SIZE 0,  18 BOLD  
DEFINE FONT 	oFnt  NAME "Arial"				SIZE 0, -16 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt4 NAME "Arial"				SIZE 0, -20 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt3 NAME "Arial"				SIZE 0, -18 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt2 NAME "Arial"				SIZE 0, -14 BOLD	// "Times New Roman" Menor

dbSelectArea("SX5")   ///Tabelas
dbSetOrder(1)
*
	DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Solicitação de Materiais para o Almoxarifado") FROM 000,000 TO 420,1080 COLORS 0, 16777215 PIXEL

	oTBar := TBar():New( _oDlg,40,25,.T.,,,'tbar_coel',.F. )   ///40,25
	
   @ 015, 001 GROUP oGroup1 TO 083, 271 PROMPT "IDENTIFICAÇÃO"            						  OF _oDlg COLOR 0, 16777215 PIXEL 
   @ 015, 001 GROUP oGroup2 TO 043, 271 PROMPT "ORDEM DE PRODUÇÃO"        						  OF _oDlg COLOR 0, 16777215 PIXEL
   @ 015, 274 GROUP oGroup3 TO 203, 541 PROMPT "SOLICITAÇÃO DE TROCA"      		  			  OF _oDlg COLOR 0, 16777215 PIXEL 
   @ 045, 001 GROUP oGroup4 TO 178, 271 PROMPT "SOLICITAÇÃO DE SCRAPE / FALTA"    			  OF _oDlg COLOR 16744448, 16777215 PIXEL 
   @ 183, 001 GROUP oGroup5 TO 203, 127 PROMPT "Legenda"                 						  OF _oDlg COLOR 0, 16777215 PIXEL	

	oTBmpVm := TBitmap():Create(_oDlg,192,003,14,14,,'br_vermelho',.T.,,,.F.,.F.,,,.F.,,.T.,,.F.) 
	oTBmpVm:lAutoSize := .T.
	@ 192,011 Say oLegVm           PROMPT "À solicitar"                                 Size 040,009  Color CLR_BLACK  PIXEL OF _oDlg 
	oTBmpAm := TBitmap():Create(_oDlg,192,051,14,14,,'br_amarelo',.T.,,,.F.,.F.,,,.F.,,.T.,,.F.)	
	oTBmpAm:lAutoSize := .T.
	@ 192,059 Say oLegAm           PROMPT "Scrape"                                      Size 030,009  Color CLR_BLACK  PIXEL OF _oDlg 
	oTBmpVd := TBitmap():Create(_oDlg,192,095,14,14,,'br_verde',.T.,,,.F.,.F.,,,.F.,,.T.,,.F.) 
	oTBmpVd:lAutoSize := .T.
	@ 192,103 Say oLegVd          PROMPT "Falta"                                        Size 030,009  Color CLR_BLACK  PIXEL OF _oDlg 
	
   @ 024, 004 SAY   oCracha		PROMPT  "Crachá"                 							SIZE 080, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt
   @ 024, 095 SAY   oSayuser  	PROMPT  "Usuário"                							SIZE 040, 009 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt
   @ 033, 004 MSGET oMatricula   VAR     cMatricula    PASSWORD     							SIZE 040, 014 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt4  Valid(_fVlDlg("MATR",cMatricula)) ///When EMPTY(cEdit1)
   @ 033, 095 MSGET oUsuario		VAR     cSolicitante  PICTURE "@!" 							SIZE 090, 014 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt4  WHEN cSetor=="01"

   @ 053, 004 SAY   oOperacao	   PROMPT  "Número da O.P"           							SIZE 090, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt
   @ 063, 004 MSGET oOP    		VAR     cOP           PICTURE "@R XXXXXX.XX"   			SIZE 070, 014 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt4  VALID (_fVlDlg("CBAR",cOP))
   @ 069, 076 MSGET oNullo 		VAR     cNullo                               			SIZE 001, 004 OF _oDlg COLORS 0, 16777215 PIXEL                     

   @ 022, 004 SAY   oNumero		PROMPT  "Número"                 					      SIZE 060, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
   @ 031, 004 SAY   oNOP   		VAR     _cOP          PICTURE "@R XXXXXX.99.999"		SIZE 080, 012 OF _oDlg COLOR  CLR_HRED    PIXEL  Font oFnt4
   @ 022, 085 SAY   oProdDesc		PROMPT  "Produto"              	 							SIZE 034, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
   @ 022, 230 SAY   oSdo     		PROMPT  "Saldo"                	 							SIZE 030, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
   @ 031, 085 SAY   oProduto 		VAR     _cProd                   							SIZE 130, 014 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4
   @ 031, 230 SAY   oSaldo 		VAR     _nSaldo       PICTURE "@E 999999"   				SIZE 070, 012 OF _oDlg COLOR  CLR_HRED    PIXEL  Font oFnt4
	
	DEFINE SBUTTON oButton FROM 065,159 TYPE 2 ENABLE OF _oDlg Action Eval( { || f_cancela()	} )
	
	oTBitmap3 := TBtnBmp2():New( 370, 362, 70, 30,'conf_coel',,,,;                
						{ || f_solicita() }  ,_oDlg,'Confirma solicitação',,.F.,.F.)
	oTBitmap4 := TBtnBmp2():New( 370, 452, 70, 30,'canc_coel',,,,;     
						{ || f_Cancela() } , _oDlg,'Cancela solicitação',,.F.,.F.)
	
   @ 053,003 LISTBOX oBrowse Fields HEADER "","Componente","Descrição","Quantidade" 	SIZE 266, 123 OF _oDlg PIXEL  
	
   oBrowse:SetArray(aCols)
	oBrowse:bldblclick := { || f_SelList() }  	
	oBrowse:bLine := {|| { IIF(aCols[oBrowse:nAt,1]=="0",oVm,IIF(aCols[oBrowse:nAt,1]=="1",oAm,oVd)) , ;
								  aCols[oBrowse:nAt,2] , ;
   	                    aCols[oBrowse:nAt,3] , ;
								  aCols[oBrowse:nAt,4] } }
	oBrowse:lAdjustColsize := .F.
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//// TROCA
	////
   @ 063, 276 GROUP oGroup6 TO 196, 539 PROMPT "TROCA"                   						  OF _oDlg COLOR 0, 16777215 PIXEL

   @ 022, 279 SAY   oCodDe 		PROMPT  "Código"                 				SIZE 030, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt2
   @ 030, 279 MSGET oPrdDe       VAR     cPrdDe      Picture "@!"   F3 "SB1"	SIZE 130, 010 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt  Valid f_produto(cPrdDe,1)
	@ 022, 450 SAY   oQtdDe       PROMPT  "Quantidade"             				SIZE 050, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt2
	@ 030, 450 MSGET oQtyDe       VAR     nQtyDe      Picture "@E 999999.99"	SIZE 060, 010 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt  Valid nQtyDe >= 0
   @ 044, 279 MSGET oDescDe      VAR     cDescDe     Picture "@!"   				SIZE 260, 010 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt  WHEN .F.

   @ 070,278 LISTBOX oTroca Fields HEADER "","Deste","Por este","Descrição","Quantidade" SIZE 260, 124 OF _oDlg PIXEL 
	
   oTroca:SetArray(aTroca)
	oTroca:bldblclick := { || f_SelTroca() }  	
	oTroca:bLine := {|| { IIF(aTroca[oTroca:nAt,1]=="0",oVm,oVd) , ;
									  aTroca[oTroca:nAt,2] , ;
									  aTroca[oTroca:nAt,3] , ;
									  aTroca[oTroca:nAt,4] , ;
									  aTroca[oTroca:nAt,5] } }
	oTroca:lAdjustColsize := .F.
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	oTBitmap1 := TBtnBmp2():New( 00, 00, 40, 70, 'S4WB008N' ,,,,;
						{ || Calculadora() }  ,oTBar,'Calculadora',,.F.,.F.)
	oTBitmap2 := TBtnBmp2():New( 00, 00, 40, 70, 'button_exit' ,,,,;
						{ || IIF(!lEmProcesso , f_Saida() , nil ) }  ,oTBar,'Sair',,.F.,.F.)
						
	f_Hide()
	
	oMatricula:SetFocus()
	oOP:Disable()
	oNullo:Disable()
	
	ACTIVATE MSDIALOG _oDlg CENTER 
	
Return


//////////////////////////////////////////////////////////////////////////////
Static Function f_Hide()
//////////////////////////////////////////////////////////////////////////////

oGroup2:Hide()
oGroup3:Hide()
oGroup4:Hide()
oGroup5:Hide()
oGroup6:Hide()
oBrowse:Hide()
oTroca:Hide()
oNumero:Hide()
oNOP:Hide()
oProdDesc:Hide()
oProduto:Hide()
oSdo:Hide()
oSaldo:Hide()
oButton:Hide()
oTBitmap3:Hide()
oTBitmap4:Hide()
oTBmpVm:Hide()
oTBmpVd:Hide()
oTBmpAm:Hide()
oLegVm:Hide()
oLegVd:Hide()
oLegAm:Hide()
oCodDe:Hide()
oPrdDe:Hide()
oDescDe:Hide()
oQtdDe:Hide()
oQtyDe:Hide()

Return
	
//////////////////////////////////////////////////////////////////////////////
Static Function f_Show()
//////////////////////////////////////////////////////////////////////////////

oGroup1:Hide()
oOperacao:Hide()
oSayuser:Hide()
oUsuario:Hide()
oMatricula:Hide()
oCracha:Hide()
oOP:Hide()
oNullo:Hide()
oButton:Hide()

oGroup2:Show()
oGroup3:Show()
oGroup4:Show()
oNumero:Show()
oNOP:Show()
oProdDesc:Show()
oProduto:Show()
oSdo:Show()
oSaldo:Show()
oTBitmap3:Show()
oTBitmap4:Show()
oGroup5:Show()
oBrowse:Show()
oTBmpVm:Show()
oTBmpVd:Show()
oTBmpAm:Show()
oLegVm:Show()
oLegVd:Show()
oLegAm:Show()

oTroca:Show()
oGroup6:Show()
oCodDe:Show()
oPrdDe:Show()
oDescDe:Show()
oQtdDe:Show()
oQtyDe:Show()

Return	

//////////////////////////////////////////////////////////////////////////////
Static Function f_SelList()    
//////////////////////////////////////////////////////////////////////////////
Local oDlgD
Local nX
Local aSolic    := {"Scrape","Falta"}
Local cTpSolic  := "Scrape"
Local xcProduto := RTRIM(aCols[oBrowse:nAt,2])+" - "+LEFT(aCols[oBrowse:nAt,3],40)
Local xnQty     := aCols[oBrowse:nAt,4]
Local xnQtOri   := aCols[oBrowse:nAt,5]
Local nOpcA     := 0

@ 252,632 To 344,954 Dialog oDlgD Title OemToAnsi("Quantidade Solicitada")

@ 001,002 TO 042,161
@ 004,005 SAY  xcProduto                                SIZE 210,007 COLOR CLR_HBLUE
@ 015,005 SAY "Tipo:"                                   SIZE 030,008
@ 014,035 COMBOBOX cTpSolic    ITEMS aSolic             SIZE 050,050
@ 029,005 SAY "Quantidade:"                             SIZE 030,008
@ 028,035 GET xnQty            Picture "@E 999999.99"   SIZE 040,010 VALID f_qtde(xnQty,xnQtOri)

@ 028,095 BmpButton Type 1 Action ( nOpcA := 1 , oDlgD:End() )
@ 028,132 BmpButton Type 2 Action ( nOpcA := 2 , oDlgD:End() )
	
Activate Dialog oDlgD CENTER VALID nOpcA <> 0

IF ( nOpcA == 1 )
	
	IF ( xnQty > 0 )
		nX := ASCAN(aSolic , cTpSolic )
		aCols[oBrowse:nAt,1] := STR(nX,1)
	ELSE	
		aCols[oBrowse:nAt,1] := "0"
	ENDIF
	aCols[oBrowse:nAt,4] := xnQty

	oBrowse:SetArray(aCols)
	oBrowse:bLine := {|| { IIF(aCols[oBrowse:nAt,1]=="0",oVm,IIF(aCols[oBrowse:nAt,1]=="1",oAm,oVd)) , ;
										aCols[oBrowse:nAt,2]               , ;
										aCols[oBrowse:nAt,3]               , ;
										aCols[oBrowse:nAt,4] } }
	oBrowse:Refresh()

ENDIF

Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_SelTroca()    
//////////////////////////////////////////////////////////////////////////////
Local nX  
Local lResp
Local lTroca  := ( !EMPTY(cPrdDe).AND.nQtyDe > 0 )    ////Informado codigo e qty do produto a ser trocado
Local lSelect := ( aTroca[oTroca:nAt,1] == "1" )           ////Item marcado para troca

IF ( nQtyDe <= 0 .OR. EMPTY(cPrdDe) )                      ////Nem codigo nem qty informado
	IF ( aTroca[oTroca:nAt,1] == "0" )                      ////Se o item ainda nao foi marcado, entao retorna
		Return
	ENDIF	
ENDIF	

IF ( lTroca )                                      
	IF ( lSelect )
		IF ( aTroca[oTroca:nAt,2] <> cPrdDe )             ////Mas, o novo codigo informado é diferente do codigo do item marcado: exibe aviso
			nX := Aviso("Seleção de Troca","Item já selecionado para troca."+CHR(13)+CHR(10)+"Certifique-se da troca.",{"Continuar","Cancelar"},3)
			IF ( nX == 2 )
				Return
			ENDIF
		ENDIF
	ELSE
		nX := ASCAN(aTroca , { |x| x[2] == cPrdDe } )     ////Verifica se o produto para troca já foi informado
		IF ( nX > 0 )
			MsgStop("Produto para troca já foi informado.","Atenção")
			Return
		ENDIF
	ENDIF
ELSEIF ( EMPTY(cPrdDe) .AND. lSelect )                  ////Se o codigo do produto para troca estiver em branco, entao preenche ambos codigo e qty... 
																		  ////... (do produto a ser trocado) para posterior alteracao de qty ou codigo
	cPrdDe  := aTroca[oTroca:nAt,2]
	cDescDe := aTroca[oTroca:nAt,4]
	nQtyDe  := aTroca[oTroca:nAt,5]
	oPrdDe:Refresh()
	oDescDe:Refresh()
	oQtyDe:Refresh()
	oQtyDe:SetFocus()
	Return
ELSEIF ( cPrdDe <> aTroca[oTroca:nAt,2] )               ////Codigo informado com qty igual a 0 e codigo do item marcado diferente, nada faz
	oQtyDe:SetFocus()
	Return
ENDIF

lResp := f_qtde(nQtyDe,aTroca[oTroca:nAt,6])

IF ( lResp )

	IF ( lTroca )    
		aTroca[oTroca:nAt,1] := "1"
		aTroca[oTroca:nAt,2] := cPrdDe
		aTroca[oTroca:nAt,5] := nQtyDe
		cPrdDe  := SPACE(30)
		cDescDe := SPACE(40)
		nQtyDe  := 0
		oPrdDe:Refresh()
		oDescDe:Refresh()
		oQtyDe:Refresh()
	ELSE	
		aTroca[oTroca:nAt,1] := "0"
		aTroca[oTroca:nAt,2] := SPACE(30)
		aTroca[oTroca:nAt,5] := 0
	ENDIF
		
	oTroca:bLine := {|| { IIF(aTroca[oTroca:nAt,1]=="0",oVm,oVd) , ;
									  aTroca[oTroca:nAt,2] , ;
									  aTroca[oTroca:nAt,3] , ;
									  aTroca[oTroca:nAt,4] , ;
									  aTroca[oTroca:nAt,5] } }

	oTroca:Refresh()

ENDIF

Return

///////////////////////////////////////////////////////////
Static Function f_Cancela()
///////////////////////////////////////////////////////////
Local lRsp := .T.

IF ( lEmProcesso )
	lRsp := MsgBox("Confirma o Cancelamento dessa solicitação?","Escolha a opção","YESNO")
ENDIF

IF ( lRsp )
	
	oGroup1:Show()
	oOperacao:Show()
	oSayuser:Show()
	oUsuario:Show()
	oMatricula:Show()
	oCracha:Show()
	oOP:Show()
	oButton:Hide()
	oNullo:Show()
	oNullo:Disable()
	oMatricula:Enable()
	oOP:Disable()
	oTBitmap3:Enable()
		
	f_hide()
	
	lEmProcesso  := .F.
	aTroca       := { {"0","","",SPACE(20),0} }
	aCols        := { {"0","",SPACE(20),0} }
	cMatricula   := SPACE(9)
	cSolicitante := SPACE(10)
	cOP          := SPACE(8)
	cSetor       := "01"
	cPrdDe       := SPACE(30)
	cDescDe      := SPACE(40)
	nQtyDe       := 0
	
	oMatricula:SetFocus()	
	
ENDIF

Return

///////////////////////////////////////////////////////////
Static Function f_Saida()
///////////////////////////////////////////////////////////
Local lRsp := lEmProcesso

IF ( lRsp )

	lRsp := MsgBox("Deseja realmente sair da Rotina?","Escolha a opção","YESNO")
	
ENDIF

IF ( lRsp .OR. !lEmProcesso )
	_oDlg:End()
ENDIF

Return(lRsp)

/////////////////////////////////////////////////////////////////////////////
Static Function f_solicita()
/////////////////////////////////////////////////////////////////////////////
Local dData,cTime1,cTime2
Local lResp
Local cHora     := LEFT(FwTimeUF("AM")[2],5)                      ////Assume a hora do sistema
Local cMark     := GETMARK()
Local nZ        := 0
Local CPNUM     := NextNumero("SCP",1,"CP_NUM",.T.)
Local cmSubject := "Solicitação de Material - Nº. "+CPNUM
Local aItens    := {{"TIPO    ","ITEM ","PRODUTO                  ","DESCRIÇÃO                     ","QUANTIDADE","UM ","DESTE PRODUTO"}}

FOR nX:=1 TO LEN(aCols)
	 IF ( aCols[nX,1] <> "0" )
		 
		 nZ++
		 
		 SB1->(dbSeek(xFilial("SB1")+aCols[nX,2]))
		 
		 RecLock("SCP",.T.)
		 SCP->CP_FILIAL  := xFilial("SCP")
		 SCP->CP_NUM     := CPNUM
		 SCP->CP_ITEM    := STRZERO(nZ,2)
		 SCP->CP_EMISSAO := Date()
		 SCP->CP_DATPRF  := Date()
		 SCP->CP_CLORIG  := "P"
		 SCP->CP_CLTPSOL := IIF(aCols[nX,1]=="1" , "S" , "F" )
		 SCP->CP_PREREQU := "S"
		 SCP->CP_PRODUTO := aCols[nX,2]
		 SCP->CP_UM      := SB1->B1_UM
		 SCP->CP_QUANT   := aCols[nX,4]
		 SCP->CP_LOCAL   := aCols[nX,6]
		 SCP->CP_CONTA   := SB1->B1_CONTA
		 SCP->CP_DESCRI  := SB1->B1_DESC
		 SCP->CP_SOLICIT := cSolicitante
		 SCP->CP_OK      := cMark
		 SCP->CP_OP      := _cOP
		 SCP->CP_RATEIO  := "2"
		 SCP->CP_CLHORAS := cHora
		 MsUnlock()
		 
		 cTipo := IIF(SCP->CP_CLTPSOL=="F","FALTA","SCRAPE")
		 
		 AADD(aItens , { cTipo            , ;
							  SCP->CP_ITEM     , ;
							  SCP->CP_PRODUTO  , ;
							  SCP->CP_DESCRI   , ;
							  TRANSF(SCP->CP_QUANT,"@E 99999") , ;
							  SCP->CP_UM       , ;
							  SCP->CP_OBS } )
	 ENDIF
NEXT

FOR nX:=1 TO LEN(aTroca)
	 IF ( aTroca[nX,1] <> "0".AND.!EMPTY(aTroca[nX,2]) )
		 
		 SB1->(dbSeek(xFilial("SB1")+aTroca[nX,3]))
		 
		 nZ++
		 
		 RecLock("SCP",.T.)
		 SCP->CP_FILIAL  := xFilial("SCP")
		 SCP->CP_NUM     := CPNUM
		 SCP->CP_ITEM    := STRZERO(nZ,2)
		 SCP->CP_EMISSAO := Date()
		 SCP->CP_DATPRF  := Date()
		 SCP->CP_CLORIG  := "P"
		 SCP->CP_CLTPSOL := "T"
		 SCP->CP_PREREQU := "S"
		 SCP->CP_CLPRDTR := aTroca[nX,2]
		 SCP->CP_PRODUTO := aTroca[nX,3]
		 SCP->CP_UM      := SB1->B1_UM
		 SCP->CP_QUANT   := aTroca[nX,5]
		 SCP->CP_LOCAL   := aTroca[nX,7]
		 SCP->CP_CONTA   := SB1->B1_CONTA
		 SCP->CP_DESCRI  := SB1->B1_DESC
		 SCP->CP_SOLICIT := cSolicitante
		 SCP->CP_OK      := cMark
		 SCP->CP_OP      := _cOP
		 SCP->CP_RATEIO  := "2"
		 SCP->CP_CLHORAS := cHora
		 MsUnlock()

		 AADD(aItens , { "TROCA"          , ;
							  SCP->CP_ITEM     , ;
							  SCP->CP_PRODUTO  , ;
							  SCP->CP_DESCRI   , ;
							  TRANSF(SCP->CP_QUANT,"@E 99999") , ;
							  SCP->CP_UM       , ;
							  SCP->CP_CLPRDTR } )
		 
	 ENDIF
NEXT

lResp := f_email(aItens,cmSubject)

IF ( lResp )
	nX := Aviso("Solicitação No. "+CPNUM,"Solicitação gerada com sucesso e enviada, via e-mail, ao Almoxarifado.",{"Ok"},3)
ELSE
	nX := Aviso("Solicitação No. "+CPNUM,"Solicitação gerada com sucesso!!!"+CHR(13)+CHR(10)+"Não foi possivel enviar e-mail para o Almoxarifado. Favor avisar.",{"Ok"},3)
ENDIF

lEmProcesso := .F.

f_cancela()

Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_produto(cProduto,nOpc)
//////////////////////////////////////////////////////////////////////////////
Local lRsp := .T.

IF ( !EMPTY(cProduto) )
	
	SB1->(dbSeek(xFilial("SB1")+cProduto))
	
	IF ( !EMPTY(cProduto).AND.EOF() )
		lRsp := .F.
	ENDIF
	
ELSE

	SB1->(dbSeek(xFilial("SB1")+"???????????"))
	
ENDIF	

IF ( nOpc == 1 )
	cDescDe := LEFT(SB1->B1_DESC,30)
ELSE
	cDescPor := LEFT(SB1->B1_DESC,30)
ENDIF
	
Return(lRsp)

//////////////////////////////////////////////////////////////////////////////
Static Function f_qtde(nQty,nQtOri)
//////////////////////////////////////////////////////////////////////////////
Local lRsp := .T.

IF ( nQty < 0 )
	lRsp := .F.
ELSE
	IF ( nQty > nQtOri )
		MsgStop("Não é permitido solicitação da quantidade acima da quantidade original da OP.","Atenção")
		lRsp := .F.
	ENDIF
ENDIF	

Return(lRsp)

//////////////////////////////////////////////////////////////////////////////
Static Function f_Empenho()
//////////////////////////////////////////////////////////////////////////////

IF ( EMPTY(aCols[1,2]) )
	aCols  := {}
	aTroca := {}
	dbSelectArea("SD4")
	dbSetOrder(2)
	dbSeek(xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD)
	Do While !Eof() .And. D4_FILIAL+D4_OP == xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD
		IF ( SD4->D4_QUANT > 0 )
			SB1->(dbSeek(xFilial("SB1")+SD4->D4_COD))
			
			AADD(aCols , { "0"         , ;
								SD4->D4_COD , ;
								LEFT(SB1->B1_DESC,50) , ;
								0           , ;
								SD4->D4_QTDEORI  , ;
								SD4->D4_LOCAL   } )

			AADD(aTroca , { "0"         , ;
								 SPACE(30)   , ;
								 SD4->D4_COD , ;
								 LEFT(SB1->B1_DESC,30) , ;
								 0           , ;
								 SD4->D4_QTDEORI , ;
								 SD4->D4_LOCAL   } )
								
		ENDIF
		dbSkip()
	EndDo

	IF ( LEN(aCols) == 0 )
		oTBitmap3:Disable()
	ENDIF
	
	oBrowse:SetArray(aCols)

	oBrowse:bLine := {|| { IIF(aCols[oBrowse:nAt,1]=="0",oVm,IIF(aCols[oBrowse:nAt,1]=="1",oVd,oAm)) , ;
								  aCols[oBrowse:nAt,2] , ;
								  aCols[oBrowse:nAt,3] , ;
								  aCols[oBrowse:nAt,4] } }
	oBrowse:lAdjustColsize := .F.
	oBrowse:Refresh()
	
   oTroca:SetArray(aTroca)
	oTroca:bldblclick := { || f_SelTroca() }  	
	oTroca:bLine := {|| { IIF(aTroca[oTroca:nAt,1]=="0",oVm,oVd) , ;
									  aTroca[oTroca:nAt,2] , ;
									  aTroca[oTroca:nAt,3] , ;
									  aTroca[oTroca:nAt,4] , ;
									  aTroca[oTroca:nAt,5] } }
	oTroca:Refresh()
	
ENDIF
	
Return

////////////////////////////////////////////////////////////////////////////////////
Static Function _fVlDlg(_cTipo,_xConteudo)
////////////////////////////////////////////////////////////////////////////////////
Local cAutoriza,CPNUM,x_Barra
Local CPQTD
Local _aArea := GetArea()
Local _lRet	 := .t. 
Local _nX    := 0

Do Case
	Case Upper(Alltrim(_cTipo)) == "CBAR"
		
		If ( Empty(_xConteudo) )
			IF ( cSetor <> "01" )
				oOP:SetFocus()
			ENDIF	
			Return(.T.)
		Else			
			x_Barra := SUBS(_xConteudo,1,1)+SUBS(_xConteudo,8,1)
			IF ( x_Barra == "99".AND.LEN(RTRIM(_xConteudo))==8 )
				cOP   := space(8)
				_lRet := .f.
				oOP:Refresh()
			ELSE
				_xConteudo := RTRIM(_xConteudo)+"001"
				
				DbSelectArea("SC2")
				DbSetOrder(1)                                      ///C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD
				dbSeek(xFilial("SC2")+_xConteudo)
				If !EOF()	
					IF ( SC2->C2_TPOP == "P" )
						MsgStop("Esta Ordem de Produção se encontra Prevista.","Não permitido")
						Return(.F.)
					ENDIF
					
					////
					////Verifica se existe pendencia de solicitacao para a OP informada
					////
					cQry := "SELECT CP_NUM,COUNT(*) CP_QTD FROM "+RetSqlName("SCP")+" "
					cQry += "WHERE D_E_L_E_T_ = ' ' "
					cQry += "AND   CP_FILIAL = '"+xFilial("SCP")+"' "
					cQry += "AND   CP_OP     = '"+_xConteudo+"' "
					cQry += "AND   CP_STATUS = ' ' "
					cQry += "AND   CP_CLORIG = 'P' " 
					cQry += "GROUP BY CP_NUM "

					cQry := ChangeQuery(cQry)

					dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)
					
					CPQTD := TMP->CP_QTD
					CPNUM := TMP->CP_NUM
					
					TMP->(dbCloseArea())
					
					IF ( CPQTD > 0 )
						Aviso("Solicitação No. "+CPNUM,"Solicitação pendente de baixa."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"Favor verificar junto ao Almoxarifado.",{"Abortar"},3)
						cOP := SPACE(8)
						oOP:Refresh()
						Return(.F.)
					ENDIF
					
					f_Empenho()         ///Extrai material empenhado

					f_Show()            ///Re-exibe objetos
					
					SB1->(dbSeek(xFilial("SB1") + SC2->C2_PRODUTO))
					*					
					_cOP    := _xConteudo
					_nSaldo := ( SC2->C2_QUANT - SC2->C2_QUJE )
					_nSaldo := IIF(_nSaldo > 0 .AND. !EMPTY(SC2->C2_DATRF) , 0 , _nSaldo )
					_cProd  := Alltrim(SC2->C2_PRODUTO) 
					
					lEmProcesso := .T.

				Else
					MsgStop("Ordem de Produção NÃO Encontrada!","Atenção")
					_lRet := .f.
				EndIf
			ENDIF
		EndIf
		
	Case Upper(Alltrim(_cTipo)) == "MATR"
		
		IF ( !EMPTY(_xConteudo) )
			x_Barra := SUBS(_xConteudo,1,1)+SUBS(_xConteudo,8,1)

			_xConteudo := IIF(x_Barra == "99" , SUBSTRING(_xConteudo,2,6) , _xConteudo )
			_xConteudo := STRZERO( VAL(ALLTRIM(_xConteudo)) , 6 )
			
			dbSelectArea("SX5")
			dbSetOrder(1)
			dbSeek(xFilial("SX5")+"Z@"+_xConteudo)
			IF ( SX5->(EOF()) )
				IF ( x_Barra <> "99" )
					MsgStop("Erro de leitura no Codigo de Barras do Crachá.")
				ELSE	
					MsgStop("Usuário não autorizado para executar esta rotina.","Atenção")
				ENDIF	
				_lRet := .f.
				
			ELSE	

				cAutoriza := SUBS(SX5->X5_DESCRI,5,1)
				IF ( cAutoriza<>"A" )
					cAutoriza := SUBS(SX5->X5_DESCRI,3,2)
					cAutoriza := IIF(cAutoriza<>"01","-",SUBS(SX5->X5_DESCRI,6,2))
					cAutoriza := IIF(cAutoriza<>"01","-",cAutoriza)
				ENDIF	
				cSolicitante := SUBS(SX5->X5_DESCRI,8,10)
				IF ( cAutoriza == "-" )
					MsgStop(OemToAnsi("Usuário ")+RTRIM(cSolicitante)+OemToAnsi(" sem permissão para executar esta Solicitação."),OemToAnsi("Atenção"))
					Return(.F.)
				ENDIF
			
				cSetor := "00"
				
				oMatricula:Disable()
				oOP:Enable()
				oNullo:Enable()
				oButton:Show()
				oOP:SetFocus()
			ENDIF
		ENDIF
		
EndCase

RestArea(_aArea)

Return(_lRet)

////////////////////////////////////////////////////
Static Function f_email(aItens,cmSubject)
////////////////////////////////////////////////////
Local cmServer  := GETMV("MV_RELSERV") 
Local cmAccount := GETMV("MV_RELACNT")
Local cmPassw   := GETMV("MV_RELAPSW") 
Local cLista    := ""
Local cEmpresa  := SM0->M0_CODIGO+SM0->M0_CODFIL
Local lConectou
Local lEnviado
Local lDesConect

cxPara := "carlos.nina@coel.com.br"
cxCC   := ""

cMensagem := "<html>"
cMensagem += "	<head>"
cMensagem += "		<title>" + "SOLICITAÇÃO DE MATERIAL" + "</title>"
cMensagem += "	</head>"
cMensagem += "	<body>"
cMensagem += '		<center><table border="0" width="85%">'

cMensagem += "		<tr><td><center><h3>" + cmSubject + "</h3></center></td></tr>"

cMensagem += "		<tr><td>"
cMensagem += '		<table border="0" width="100%">'

cMensagem += "		<tr>"
cMensagem += '		<td width="45%">'
cMensagem += "		<b> Ordem de Produção: " + _cOP + "</b>"
cMensagem += "		</td>"
cMensagem += "		<td>"
cMensagem += "		Solicitante: "+cSolicitante
cMensagem += "		</td>"
cMensagem += "		</tr>"

cMensagem += "		</table>"			
cMensagem += "		</td></tr>"

// espaco
//cMensagem += "	<tr><td>&nbsp;</td></tr>"

// regua horizontal
cMensagem += "		<tr><td>"
cMensagem += '		<hr width="100%">'
cMensagem += "		</td></tr>"

// espaco
//cMensagem += "		<tr><td>&nbsp;</td></tr>"

//////////////////////////////
// Lista de itens solicitados
//////////////////////////////			
cMensagem += "		<tr><td>"
cMensagem += "		<h4> ITENS DA SOLICITAÇÃO </h4>"
cMensagem += "		</td></tr>"

cMensagem += "<tr><td>"

cMensagem += MontaTabelaHTML(aItens, .T., "100%")

cMensagem += "		</td></tr>"

// espaco
cMensagem += "		<tr><td>&nbsp;</td></tr>"

// regua horizontal
cMensagem += "		<tr><td>"
cMensagem += '		<hr width="100%">'
cMensagem += "		</td></tr>"

// fim
cMensagem += "		</table></center>"
cMensagem += "	 </body>"
cMensagem += "</html>"			

CONNECT SMTP SERVER cmServer ;
		  ACCOUNT  cmAccount   ;
		  PASSWORD cmPassw     ;
		  Result lConectou

IF ( lConectou )

	lConectou := MailAuth(cmAccount, cmPassw)
	
	If !lConectou
		MsgAlert("[Error] Falha de conexão.")
		Return .F.
	Endif	

	SEND MAIL FROM cmAccount TO cxPara  ;
				 CC cxCC                   ;
				 SUBJECT cmSubject         ;
				 BODY cMensagem            ;
				 RESULT lEnviado
				 ////ATTACHMENT nil            ;

	IF ( !lEnviado )
		MsgAlert("** Falha ao enviar. Favor verificar se houve falha de conexão com a Internet. Se houve e normalizou, favor re-enviar a lista.")
		Return .F.
	ENDIF

ELSE
	///
	///Extrai o resultado envio
	///
	GET MAIL ERROR cmMsgErr
	///
	///Informa a mensagem de envio para o usuario
	///
	MsgAlert( "** Erro ao enviar o e-mail. Motivo: "+cmMsgErr )
	Return .F.
ENDIF
///
///Disconecta o servidor de SMTP
///
DISCONNECT SMTP SERVER Result lDesConect

Return .T.