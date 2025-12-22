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
±±³Programa  ³ CApt_Op6 ³ Autor ³ Carlos Nina           ³ Data ³25/09/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Baixa de solicitacao de material e na falta de pagamento   ³±±
±±³          ³ pelo Almoxarifado                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Coelmatic/Manaus                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CApt_Op6()

Local _aArea := GetArea()
Local cLogo  := FisxLogo("1")
Local cNullo := " "

Private oVd  := LoadBitmap( GetResources(), 'br_verde')
Private oVm  := LoadBitmap( GetResources(), 'br_vermelho')
Private oAm  := LoadBitmap( GetResources(), 'br_amarelo')
Private oPt  := LoadBitmap( GetResources(), 'br_preto')

Private cmServer  := GETMV("MV_WFSMTP")
Private cmAccount := GETMV("MV_WFMAIL")
Private cmPassw   := GETMV("MV_RELPSW")

Private cSetor     := "01"
Private aCols      := { {"0","","","","","","","","",SPACE(20),0,0,0,""} }
Private aOrigem    := { {"A","ALMOXARIFADO" } , {"P",OEMTOANSI("PRODUÇÃO")} , {"T","ASS.TECNICA"} , {"R",OEMTOANSI("REVISÃO")} }
Private aTpSolic   := { {"F","FALTA"} , {"S","SCRAPE"} , {"T","TROCA"} }

Private oCracha,oMatricula,oSolicitante,oUser
Private oGroup1,oGroup2,oTBar,oBrowse
Private oLbl5,oBold,oLegVm,oLegAz,oLegAm,oLegPt
Private oTBitMap,oTBitMap1,oTBitMap2,oTBmp1,oTBmp2,oTBmp3,oTBmp4,oTBmp5,oTBmpVm,oTBmpAz,oTBmpAm

// Variaveis Private da Funcao
Private _oDlg				// Dialog Principal
Private _nHRes 		:= oMainWnd:nClientWidth
Private _cTheme		:= Alltrim(GetTheme())
Private _lMdiChild	:= SetMdiChild()
Private cMatricula   := Space(9)
Private cSolicitante := Space(10)
Private cDesComp     := Space(60)
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
dbSelectArea("SB1")   ///Produto
dbSetOrder(1)
*
dbSelectArea("SB2")   ///Produto
dbSetOrder(1)
*
dbSelectArea("SC2")   ///Ordem de Producao
dbSetOrder(1)
*
dbSelectArea("SD4")   ///Empenho          
dbSetOrder(2)
*
	DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Baixa de Solicitação de Material - Almoxarifado") FROM 000,000 TO 480,980 COLORS 0, 16777215 PIXEL

	oTBar := TBar():New( _oDlg,40,25,.T.,,,'tbar_coel',.F. )   ///40,25
	
   @ 015, 001 GROUP oGroup1 TO 050, 200 PROMPT OemToAnsi("IDENTIFICAÇÃO") 						  OF _oDlg COLOR 0, 16777215 PIXEL 
   @ 052, 001 GROUP oGroup2 TO 234, 491 PROMPT "ITENS"                            			  OF _oDlg COLOR 16744448, 16777215 PIXEL 
   @ 015, 205 GROUP oGroup3 TO 050, 360 PROMPT "Legenda"                 						  OF _oDlg COLOR 0, 16777215 PIXEL	

	oTBmpVm := TBitmap():Create(_oDlg,024,208,14,14,,'br_vermelho',.T.,,,.F.,.F.,,,.F.,,.T.,,.F.)	   
	oTBmpVm:lAutoSize := .T.
	@ 024,217 Say oLegVm           PROMPT OemToAnsi("Aguardando baixa")                 Size 070,009  Color CLR_BLACK  PIXEL OF _oDlg
	oTBmpPt := TBitmap():Create(_oDlg,024,290,14,14,,'br_preto',.T.,,,.F.,.F.,,,.F.,,.T.,,.F.)	 
	oTBmpPt:lAutoSize := .T.
	@ 024,299 Say oLegPt           PROMPT OemToAnsi("Baixa não autorizada")             Size 080,009  Color CLR_BLACK  PIXEL OF _oDlg  
	oTBmpAm := TBitmap():Create(_oDlg,036,208,14,14,,'br_amarelo',.T.,,,.F.,.F.,,,.F.,,.T.,,.F.)
	oTBmpAm:lAutoSize := .T.
	@ 036,217 Say oLegAm           PROMPT "Baixa parcial"                               Size 040,009  Color CLR_BLACK  PIXEL OF _oDlg 
	oTBmpVd := TBitmap():Create(_oDlg,036,290,14,14,,'br_verde',.T.,,,.F.,.F.,,,.F.,,.T.,,.F.)
	oTBmpVd:lAutoSize := .T.
	@ 036,299 Say oLegVd           PROMPT "Baixa total"                                 Size 040,009  Color CLR_BLACK  PIXEL OF _oDlg 
	
   @ 022, 004 SAY   oCracha		 PROMPT  OemToAnsi("Crachá")        					   SIZE 080, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt
   @ 022, 095 SAY   oUser     	 PROMPT  OemToAnsi("Usuário")       					   SIZE 040, 009 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt
   @ 031, 004 MSGET oMatricula    VAR     cMatricula           PASSWORD       			SIZE 040, 014 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt4  Valid _fVlDlg(cMatricula)
   @ 031, 095 MSGET oSolicitante	 VAR     cSolicitante         PICTURE "@!"   			SIZE 090, 014 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt4  WHEN cSetor=="01"

	oTBitmap3 := TBtnBmp2():New( 026, 904, 70, 30,'conf_coel',,,,;      
						{ || f_solicita() }  ,_oDlg,OemToAnsi('Confirma solicitação'),,.F.,.F.)
	oTBitmap4 := TBtnBmp2():New( 060, 904, 70, 30,'canc_coel',,,,;   
						{ || f_Cancela() } , _oDlg,OemToAnsi('Cancela solicitação'),,.F.,.F.)
	
   @ 222, 004 SAY   oDesComp		 VAR cDesComp                       					   SIZE 280, 009 OF _oDlg COLOR CLR_HBLUE           PIXEL Font oFnt3
	oBrowse := TCBrowse():New( 60 , 03, 486, 160,,{'','Origem','Tipo','Nr.Solic.','Item','Solicitante','O.P.','Produto','Componente','Qtd.Emp.','Qtd.Solic.','Qtd. a Baixar'},{20,30,30,30,15,30,30,30,30,30,30,30},_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	
	
   oBrowse:SetArray(aCols)
	oBrowse:bChange    := { || f_descric(oBrowse:nAt) }  
	oBrowse:bldblclick := { || f_SelList() }  	
	oBrowse:bLine := {|| { IIF(aCols[oBrowse:nAt,1]=="0",oVm,IIF(aCols[oBrowse:nAt,1]=="1",oAm,IIF(aCols[oBrowse:nAt,1]=="2",oVd,oPt))) , ;
								  aCols[oBrowse:nAt,2]  , ;
   	                    aCols[oBrowse:nAt,3]  , ;
								  aCols[oBrowse:nAt,4]  , ;
   	                    aCols[oBrowse:nAt,5]  , ;
								  aCols[oBrowse:nAt,6]  , ;
   	                    aCols[oBrowse:nAt,7]  , ;
								  aCols[oBrowse:nAt,8]  , ;
   	                    aCols[oBrowse:nAt,9]  , ;
   	                    aCols[oBrowse:nAt,11] , ;
   	                    aCols[oBrowse:nAt,12] , ;
								  aCols[oBrowse:nAt,13] } }
	oBrowse:lAdjustColsize := .F.
	
	oTBitmap1 := TBtnBmp2():New( 00, 00, 40, 70, 'S4WB008N' ,,,,;
						{ || Calculadora() }  ,oTBar,'Calculadora',,.F.,.F.)
	oTBitmap2 := TBtnBmp2():New( 00, 00, 40, 70, 'button_exit' ,,,,;
						{ || IIF(!lEmProcesso , f_Saida() , nil ) }  ,oTBar,'Sair',,.F.,.F.)
						
	f_Hide()
	
	oMatricula:SetFocus()
	
	ACTIVATE MSDIALOG _oDlg CENTER 
	
Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_Hide()
//////////////////////////////////////////////////////////////////////////////

oGroup2:Hide()
oGroup3:Hide()
oBrowse:Hide()
oTBitmap3:Hide()
oTBitmap4:Hide()
oTBmpVm:Hide()
oTBmpVd:Hide()
oTBmpAm:Hide()
oTBmpPt:Hide()
oLegVm:Hide()
oLegVd:Hide()
oLegAm:Hide()
oLegPt:Hide()

Return
	
//////////////////////////////////////////////////////////////////////////////
Static Function f_Show()
//////////////////////////////////////////////////////////////////////////////

oGroup2:Show()
oGroup3:Show()
oTBitmap3:Show()
oTBitmap4:Show()
oBrowse:Show()
oTBmpVm:Show()
oTBmpVd:Show()
oTBmpAm:Show()
oTBmpPt:Show()
oLegVm:Show()
oLegVd:Show()
oLegAm:Show()
oLegPt:Show()

Return	

//////////////////////////////////////////////////////////////////////////////
Static Function f_descric(nItem)    
//////////////////////////////////////////////////////////////////////////////

cDesComp := aCols[nItem,10] 
oDesComp:Refresh()

Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_SelList()    
//////////////////////////////////////////////////////////////////////////////
Local oDlgD
Local nX
Local aOperacao := {"Baixar","Desfazer",OemToAnsi("Não autorizar")}
Local cOperacao := "Baixar"
Local cObserv   := aCols[oBrowse:nAt,14]
Local xcProduto := RTRIM(aCols[oBrowse:nAt,9])+" - "+aCols[oBrowse:nAt,10]
Local xnQty     := IIF(aCols[oBrowse:nAt,13] > 0 , aCols[oBrowse:nAt,13] , aCols[oBrowse:nAt,12] )
Local xnQtySol  := aCols[oBrowse:nAt,12]
Local nOpcA     := 0

@ 065,000 To 190,418 Dialog oDlgD Title OemToAnsi("Operação da Baixa")
@ 001,001 To 061,211
@ 006,004 Say OemToAnsi(xcProduto)                            Size 145,8  COLOR CLR_HBLUE
@ 017,004 Say OemToAnsi("Operação")                           Size 25,8
@ 017,104 Say OemToAnsi("Quantidade")                         Size 30,8
@ 038,004 Say OemToAnsi("Observação")                         Size 32,8

@ 025,004 ComboBox cOperacao Items aOperacao                  Size 80,21
@ 025,104 Get xnQty                   Picture "@E 9999999.99" Size 45,10  VALID xnQty >= 0
@ 046,004 Get cObserv                 Picture "@!"            Size 145,10

@ 006,183 BmpButton Type 1 Action ( nOpcA := 1 , oDlgD:End() )
@ 023,183 BmpButton Type 2 Action ( nOpcA := 2 , oDlgD:End() )

Activate Dialog oDlgD CENTER VALID nOpcA <> 0

IF ( nOpcA == 1 )

	nX := ASCAN(aOperacao , cOperacao )
	
	IF ( nX == 1 )
		IF ( xnQty > 0 )
			aCols[oBrowse:nAt,1] := IIF(xnQty >= xnQtySol , "2" , "1" )
		ELSE
			xnQty := 0
		ENDIF	
	ELSE	
		aCols[oBrowse:nAt,1] := IIF(nX==2,"0","3")
		xnQty   := 0
		cObserv := IIF(nX==2,SPACE(30),cObserv)
	ENDIF
	aCols[oBrowse:nAt,13] := xnQty
	aCols[oBrowse:nAt,14] := cObserv

	oBrowse:SetArray(aCols)
	oBrowse:bLine := {|| { IIF(aCols[oBrowse:nAt,1]=="0",oVm,IIF(aCols[oBrowse:nAt,1]=="1",oAm,IIF(aCols[oBrowse:nAt,1]=="2",oVd,oPt))) , ;
										aCols[oBrowse:nAt,2]  , ;
										aCols[oBrowse:nAt,3]  , ;
									   aCols[oBrowse:nAt,4]  , ;
									   aCols[oBrowse:nAt,5]  , ;
									   aCols[oBrowse:nAt,6]  , ;
									   aCols[oBrowse:nAt,7]  , ;
									   aCols[oBrowse:nAt,8]  , ;
									   aCols[oBrowse:nAt,9]  , ;
									   aCols[oBrowse:nAt,11] , ;
									   aCols[oBrowse:nAt,12] , ;
										aCols[oBrowse:nAt,13] } }
	oBrowse:Refresh()

ENDIF

Return

///////////////////////////////////////////////////////////
Static Function f_Cancela()
///////////////////////////////////////////////////////////
Local lRsp

lRsp := MsgBox(OemToAnsi("Confirma o Cancelamento dessa rotina?"),OemToAnsi("Escolha a opção"),"YESNO")

IF ( lRsp )
	
	oMatricula:Enable()
	oTBitmap3:Enable()
		
	f_hide()
	
	lEmProcesso  := .F.
	aCols        := { {"0","","","","","","","","",SPACE(20),0,0,0,""} }
	cMatricula   := SPACE(9)
	cSolicitante := SPACE(10)
	cSetor       := "01"
	cDesComp     := SPACE(60)

	oDesComp:Refresh()
	oMatricula:SetFocus()	
	
ENDIF

Return

///////////////////////////////////////////////////////////
Static Function f_Saida()
///////////////////////////////////////////////////////////
Local lRsp := lEmProcesso

IF ( lRsp )

	lRsp := MsgBox("Deseja realmente sair da Rotina?",OemToAnsi("Escolha a opção"),"YESNO")
	
ENDIF

IF ( lRsp .OR. !lEmProcesso )
	_oDlg:End()
ENDIF

Return(lRsp)

//////////////////////////////////////////////////////////////////////////////
Static Function f_chkbaixa()
//////////////////////////////////////////////////////////////////////////////
Local cQry,cLegenda
Local nX,nZ

IF ( EMPTY(aCols[1,2]) )
	aCols  := {}
	aTroca := {}

	cQry := "SELECT * FROM "+RetSqlName("SCP")+" "
	cQry += "WHERE D_E_L_E_T_ = ' ' "
	cQry += "AND   CP_FILIAL = '"+xFilial("SCP")+"' "
	cQry += "AND   CP_STATUS = ' ' "
	cQry += "AND   CP_CLORIG <> ' ' " 
	cQry += "ORDER BY CP_NUM,CP_ITEM "

	cQry := ChangeQuery(cQry)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

	TcSetField("TMP","CP_EMISSAO","D",08,0)
	TcSetField("TMP","CP_DATPRF","D",08,0)
	
	dbSelectArea("TMP")
	dbGoTop()
	Do While !Eof()
			
		nX := ASCAN(aOrigem  , { |x| x[1] == TMP->CP_CLORIG } )
		nZ := ASCAN(aTpSolic , { |x| x[1] == TMP->CP_CLTPSOL } )
		
		SC2->(dbSeek(xFilial("SC2")+TMP->CP_OP))
		
		SD4->(dbSeek(xFilial("SD4")+TMP->CP_OP+TMP->CP_PRODUTO+TMP->CP_LOCAL))
		
		cLegenda := IIF(TMP->CP_QUJE > 0 , "1" , "0" )
		
		AADD(aCols , { cLegenda          , ;
							aOrigem[nX,2]     , ;
							aTpSolic[nZ,2]    , ;
							TMP->CP_NUM       , ;
							TMP->CP_ITEM      , ;
							TMP->CP_SOLICIT   , ;
							TMP->CP_OP        , ;
							SC2->C2_PRODUTO   , ;
							TMP->CP_PRODUTO   , ;
							TMP->CP_DESCRI    , ;
							SD4->D4_QTDEORI   , ;
							TMP->CP_QUANT     , ;
							0                 , ;
							TMP->CP_OBS       , ;
							TMP->CP_CLPRDTR   , ;
							TMP->R_E_C_N_O_   , ;
							TMP->CP_LOCAL     , ;
							TMP->CP_DATPRF } )

		dbSkip()
	EndDo

	TMP->(dbCloseArea())
	
	IF ( LEN(aCols) == 0 )
		aCols := { {"0","","","","","","","","",SPACE(20),0,0,0,""} }
		oTBitmap3:Disable()
	ENDIF
	
	oBrowse:SetArray(aCols)

	oBrowse:bLine := {|| { IIF(aCols[oBrowse:nAt,1]=="0",oVm,IIF(aCols[oBrowse:nAt,1]=="1",oAm,oVd)) , ;
								  aCols[oBrowse:nAt,2]  , ;
								  aCols[oBrowse:nAt,3]  , ;
								  aCols[oBrowse:nAt,4]  , ;
								  aCols[oBrowse:nAt,5]  , ;
								  aCols[oBrowse:nAt,6]  , ;
								  aCols[oBrowse:nAt,7]  , ;
								  aCols[oBrowse:nAt,8]  , ;
								  aCols[oBrowse:nAt,9]  , ;
								  aCols[oBrowse:nAt,11] , ;
								  aCols[oBrowse:nAt,12] , ;
								  aCols[oBrowse:nAt,13] } }
	oBrowse:lAdjustColsize := .F.
	oBrowse:Refresh()
	cDesComp := aCols[1,10] 
	oDesComp:Refresh()
	
ENDIF
	
Return

/////////////////////////////////////////////////////////////////////////////
Static Function f_solicita()
/////////////////////////////////////////////////////////////////////////////
Local dData,cTime1,cTime2
Local lResp
Local nX,nY,nZ,nRecNo

////
////Assume a hora do sistema
////
cHora := LEFT(FwTimeUF("AM")[2],5)

FOR nX:=1 TO LEN(aCols)
	 IF ( aCols[nX,1] <> "0" )
		 nRecNo := aCols[nX,16]
		 dbSelectArea("SCP")
		 dbGoTo(nRecNo)
		 IF ( aCols[nX,1] == "3" )                           ////Solicitacao nao autorizada
			 RecLock("SCP",.F.)
			 SCP->CP_STATUS := "E"
			 SCP->CP_OBS    := aCols[nX,14]
			 SCP->CP_DATPRF := ddatabase
			 MsUnlock()
		 ELSE
			 DO CASE
				 CASE ( aCols[nX,2]=="ALMOXARIFADO" .OR. aCols[nX,3] == "TROCA" )
						RecLock("SCP",.F.)
						SCP->CP_QUJE += aCols[nX,13]
						IF ( SCP->CP_QUJE >= SCP->CP_QUANT )
							SCP->CP_STATUS := "E"
						ENDIF
						SCP->CP_OBS    := aCols[nX,14]
						SCP->CP_DATPRF := ddatabase
						MsUnlock()
				 OTHERWISE

						SB1->(dbSeek(xFilial("SB1")+aCols[nX,9]))
						SB2->(dbSeek(xFilial("SB2")+aCols[nX,9]+aCols[nX,17]))

						RecLock("SCP",.F.)
						SCP->CP_QUJE += aCols[nX,13]
						IF ( SCP->CP_QUJE >= SCP->CP_QUANT )
							SCP->CP_STATUS := "E"
						ENDIF
						SCP->CP_OBS    := aCols[nX,14]
						SCP->CP_DATPRF := ddatabase
						MsUnlock()
						
						////
						////Gera requisicao do material: Scrape ou Falta
						////
						DbselectArea("SD3")
						cNumSeq := ProxNum()
						nCusto  := ROUND(aCols[nX,13] * SB2->B2_CM1 , 4)

						RecLock("SD3",.T.)
						SD3->D3_FILIAL  := xFilial("SD3")
						SD3->D3_NUMSEQ  := cNumSeq
						SD3->D3_TM      := IIF(aCols[nX,3]=="SCRAPE","507","702")
						SD3->D3_CF      := "RE0"
						SD3->D3_COD     := aCols[nX,9]
						SD3->D3_QUANT   := aCols[nX,13]
						SD3->D3_CUSTO1  := nCusto
						SD3->D3_LOCAL   := aCols[nX,17]
						SD3->D3_DOC     := aCols[nX,4]+aCols[nX,5]
						SD3->D3_UM      := SB1->B1_UM
						SD3->D3_EMISSAO := ddatabase
						SD3->D3_TIPO    := SB1->B1_TIPO
						SD3->D3_CHAVE   := "E0"
						SD3->D3_GRUPO   := SB1->B1_GRUPO
						SD3->D3_CONTA   := SB1->B1_CONTA
						SD3->D3_CC      := SB1->B1_CC
						SD3->D3_USUARIO := M->cUserName
						SD3->D3_X_OBS   := aCols[nX,14]
						MsUnLock()
						
						/*
						////
						////Gera Baixa da solicitacao do material: Scrape ou Falta
						////
						DbselectArea("SCQ")
						RecLock("SCQ",.T.)
						SCQ->CQ_FILIAL  := xFilial("SCQ")
						SCQ->CQ_NUMREQ  := cNumSeq
						SCQ->CQ_NUM     := aCols[nX,4]
						SCQ->CQ_NUMSQ   := "01"
						SCQ->CQ_ITEM    := aCols[nX,5]
						SCQ->CQ_PRODUTO := aCols[nX,9]
						SCQ->CQ_QUANT   := aCols[nX,13]
						SCQ->CQ_QTDISP  := 0           
						SCQ->CQ_DESCRI  := SB1->B1_DESC
						SCQ->CQ_LOCAL   := aCols[nX,17]
						SCQ->CQ_UM      := SB1->B1_UM
						SCQ->CQ_CONTA   := SB1->B1_CONTA
						SCQ->CQ_CC      := SB1->B1_CC
						MsUnLock()
						*/
						
			 ENDCASE	 
		 ENDIF
	 ENDIF
NEXT

MsgInfo("Baixa efetuada com sucesso!!!","Aten‡„o")

cDesComp := SPACE(60)
oDesComp:Refresh()
oMatricula:Enable()
oTBitmap3:Enable()
	
f_hide()

lEmProcesso  := .F.
aCols        := { {"0","","","","","","","","",SPACE(20),0,0,0,""} }
cMatricula   := SPACE(9)
cSolicitante := SPACE(10)
cSetor       := "01"

oMatricula:SetFocus()	

Return

////////////////////////////////////////////////////////////////////////////////////
Static Function _fVlDlg(_xConteudo)
////////////////////////////////////////////////////////////////////////////////////
Local cAutoriza,CPNUM,x_Barra
Local _lRet	 := .t. 
Local _nX    := 0

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

		f_chkbaixa()         ///Extrai os itens para baixa

		f_Show()            ///Re-exibe objetos
		
		cSetor      := "00"
		lEmProcesso := .T.
		
		oMatricula:Disable()
		
	ENDIF
ENDIF
		
Return(_lRet)