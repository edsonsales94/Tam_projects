#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#include "ap5mail.ch"

#DEFINE APSWDET_USER_PWD			aPswDet[01][03]

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CESTG770  ³ Autor ³ Carlos Nina           ³ Data ³28/01/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Baixa de material via solicitaçao avulsa ou da Produção.   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Coelmatic/Manaus                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Definido com  Brandao/Teddy em 26/01/2015                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CESTG770()

Local aGrp
Local _aArea := GetArea()
Local cLogo  := FisxLogo("1")
Local cNullo := " "
Local aUsers := FWSFAllUsers()

Private _oDlg		      	                         	// Dialog Principal
Private lBrowse,lEmProcesso,lAdmin,lSenha
Private aMovimen,aCols,aEmpenho
Private cProduto,cProdDest,cPrd,cDesc,cUm,cTipo,cAlmox,cAPassw,cAUser,cANome,cASenha,cSSolic,cOP,mOP,cObs,cDocumen,cItem,cAutoriza
Private cMatric,cUsuario,cSenAtu,cOpcoes
Private nQuant,nTpMov,nTipoM,nCusto
Private dEmissao

Private lLooping := .T.
Private lSaida   := .F.
Private aRet     := FwTimeUF("AM")                              ///aRet[1] = 20140227  ; aRet[2] = 17:32:33		
Private cHora    := LEFT(STRTRAN(aRet[2],":",""),4)
Private cPerg    := PADR("CESTG770",10)
Private mvLocPad := IIF(M->cNumEmp=="0301","02","01")   
Private aMovimen := {}
Private aTpMov   := {}
Private aTipoM   := {"Entrada","Saída"}
Private aTpMovE  := {"Acerto Estoque"     , ;   //1
							"Reposição Filial"   , ;   //2
							"Compl. N.Fiscal"    , ;   //3
							"Entrada Valorizada" , ;   //4
							"Outras Entradas"}         //5
							
Private aTpMovS  := {"Reposição Filial"   , ;   //1
							"Scrap"              , ;   //2
							"Defeito"            , ;   //3
							"Falta/Rep.Estoque"  , ;   //4
							"Transf.Produto"     , ;   //5
							"Compl. N.Fiscal"    , ;   //6
							"Acerto Estoque"     , ;   //7
							"Transf.Devol. NF"   , ;   //8
							"Outras Saidas"}           //9

Private oVd  := LoadBitmap( GetResources(), 'br_verde')
Private oVm  := LoadBitmap( GetResources(), 'br_vermelho')

AADD(aMovimen, {"(ACE)","003","DE0","Acerto Estoque"} )
AADD(aMovimen, {"(RPM)","030","DE0","Reposição Filial"} )
AADD(aMovimen, {"(CNF)","100","DE0","Compl. N.Fiscal"} )
AADD(aMovimen, {"(EVL)","001","DE6","Entrada Valorizada"} )
AADD(aMovimen, {"(OUE)","101","DE0","Outras Entradas"} )
AADD(aMovimen, {"(RPS)","600","RE0","Reposição Filial"} )       ///REP
AADD(aMovimen, {"(SCR)","507","RE0","Scrap"} )
AADD(aMovimen, {"(DEF)","507","RE0","Defeito"} )
AADD(aMovimen, {"(FLT)","702","RE0","Falta"} )
AADD(aMovimen, {"(TRF)","999","RE4","Transf.Produto"} )
AADD(aMovimen, {"(SNF)","602","RE0","Compl. N.Fiscal"} )
AADD(aMovimen, {"(ACS)","601","RE0","Acerto Estoque"} )
AADD(aMovimen, {"(DNF)","999","RE4","Transf.Devol. NF"} )
AADD(aMovimen, {"(OUS)","505","RE0","Outras Saidas"} )      ///OUT

DEFINE FONT 	oBold NAME "Times New Roman"	SIZE 0,  18 BOLD  
DEFINE FONT 	oFnt  NAME "Arial"				SIZE 0, -16 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt4 NAME "Arial"				SIZE 0, -20 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt3 NAME "Arial"				SIZE 0, -18 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt2 NAME "Arial"				SIZE 0, -14 BOLD	// "Times New Roman" Menor
DEFINE FONT 	oFnt5 NAME "Arial"				SIZE 0, -26 BOLD	// "Times New Roman" Maior

ValidPerg()

Pergunte(cPerg,.F.)

dbSelectArea("SX5")   ///Tabelas
dbSetOrder(1)
*
dbSelectArea("SB2")
dbSetOrder(1)
*
////
////Verifica se o usuario faz parte do Grupo de usuarios para executar esta rotina
////
nX     := ASCAN(aUsers , { |x| x[2] == M->__cUserID } )
aGrp   := ACLONE(aUsers[nX])
nW     := ASCAN(aGrp , "000000" )                              ////Grupo Administradores
lAdmin := ( nW > 0 )     ///( M->__cUserID == "000000" )

DO WHILE lLooping
	lBrowse      := .F.
	lEmProcesso  := .F.
	lSenha       := .F.
	aCols 	 := { {"0","0001","","","","","","","","","","","","",0} }
	aTpMov    := ACLONE(aTpMovE)
	aEmpenho  := {}
	cAUser    := IIF(lAdmin , M->__cUserId , Space(8) )
	cANome    := IIF(lAdmin , M->cUserName , Space(15) )
	cASenha   := IIF(lAdmin , "9999" , Space(4) )
	cProdDest := Space(30)
	cProduto  := Space(30)
	cPrd      := Space(130)
	cDesc     := Space(70)
	cUm	    := Space(2)
	cTipo     := Space(2)
	cAlmox	 := Space(2)
	cSSolic   := space(15)
	cOP       := Space(8)
	mOP       := Space(8)
	cObs      := Space(30)
	cAutoriza := Space(1)
	cMatric   := SPACE(6)
	cUsuario  := SPACE(10)
	nCusto    := 0
	nQuant    := 0
	nTpMov    := 1
	nTipoM    := 1
	dEmissao  := ddatabase
	cDocumen  := Space(9)
	cItem     := "0000"
	cOpcoes   := Space(2)
	cSenAtu   := Space(4)

	DEFINE MSDIALOG _oDlg TITLE OemtoAnsi(":::... Movimentação Interna de Materiais ...:::") FROM 000,000 TO 510,984 COLORS 0, 16777215 PIXEL  

	oTBar := TBar():New( _oDlg,40,25,.T.,,,'tbar_coel',.F. )   

	@ 015, 001 GROUP oGroup1 TO 050, 236 PROMPT "IDENTIFICAÇÃO"            						  			  OF _oDlg COLOR  0, 16777215 		 PIXEL 
	@ 015, 246 GROUP oGroup2 TO 050, 436 PROMPT "SOLICITANTE"              						  			  OF _oDlg COLOR  0, 16777215 		 PIXEL
	@ 053, 072 GROUP oGroup3 TO 144, 490 PROMPT "MOVIMENTO"                 		  			  			  OF _oDlg COLOR  0, 16777215 		 PIXEL 
	@ 053, 001 GROUP oGroup4 TO 250, 071 PROMPT "TIPO MOVIMENTO"            		  			  			  OF _oDlg COLOR  16744448, 16777215 PIXEL 
	@ 146, 072 GROUP oGroup5 TO 250, 490 PROMPT "ITENS"                            			  			  OF _oDlg COLOR  0, 16777215 		 PIXEL 

	@ 024, 004 SAY   oASUser		PROMPT  "Usuário"                							SIZE 080, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt2
	@ 024, 072 SAY   oASNome   	PROMPT  "Nome"                   							SIZE 040, 009 OF _oDlg COLORS        0, 16777215 PIXEL Font oFnt2
	@ 024, 186 SAY   oASSenha  	PROMPT  "Senha"                  							SIZE 040, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt2
	@ 033, 004 MSGET oAGUser      VAR     cAUser        PICTURE "@R 999999999"				SIZE 040, 010 OF _oDlg COLORS        0, 16777215 PIXEL Font oFnt3  Valid(_fVlDlg("MATR",cAUser))
	@ 033, 072 MSGET oAGNome   	VAR     cANome                     							SIZE 104, 010 OF _oDlg COLORS        0, 16777215 PIXEL Font oFnt   WHEN .F.
	@ 033, 186 MSGET oAGSenha  	VAR     cASenha       PICTURE "@R 9999"     PASSWORD	SIZE 040, 010 OF _oDlg COLORS        0, 16777215 PIXEL Font oFnt   Valid(_fVlDlg("APASSW",cASenha))

	@ 024, 250 SAY   oSSSolic		PROMPT  "Nome"                   							SIZE 080, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt2
	@ 033, 250 MSGET oSGSolic  	VAR     cSSolic       PICTURE "@!" 							SIZE 090, 010 OF _oDlg COLORS 0, 16777215 		 PIXEL Font oFnt   Valid(_fVlDlg("SOLIC",cSSolic))
	@ 024, 360 SAY   oDocto   	   PROMPT  "Documento"               							SIZE 070, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt2  
	@ 033, 360 MSGET oDocumen 		VAR     cDocumen      PICTURE "@!"             			SIZE 070, 010 OF _oDlg COLORS 0, 16777215 		 PIXEL Font oFnt   Valid(_fVlDlg("DOCTO",cDocumen))
	
	oTipoM := TRadMenu():New (061,004,aTipoM,,_oDlg,,,,,,,,062,022,,,,.T.)
	oTipoM:bchange := {|| _fVlDlg("TMOV1",nTipoM) } 
	oTipoM:bSetGet := {|um|Iif (PCount()==0,nTipoM,nTipoM:=um)} 

	@ 081, 003 SAY  oSeparador	   PROMPT  "--------------------------"						SIZE 070, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt2
	
	oTpMov := TRadMenu():New (092,004,aTpMov,,_oDlg,,,,,,,,062,022,,,,.T.)
	oTpMov:bchange := {|| _fVlDlg("TMOV2",nTpMov) } 
	oTpMov:bSetGet := {|uv|Iif (PCount()==0,nTpMov,nTpMov:=uv)} 

	@ 061, 075 SAY   oDtEmiss 	   PROMPT  "Data de Emissão"         							SIZE 090, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt2
	@ 070, 075 MSGET oEmissao 		VAR     dEmissao                               			SIZE 060, 010 OF _oDlg COLORS 0, 16777215 		 PIXEL Font oFnt   VALID (_fVlDlg("EMISS",dEmissao))
	@ 061, 150 SAY   oNumOP   	   PROMPT  "Ordem de Produção"       							SIZE 090, 009 OF _oDlg COLORS 0, 16777215 		 PIXEL Font oFnt2
	@ 070, 150 MSGET oOP    		VAR     cOP           PICTURE "@R XXXXXX-XX"   			SIZE 070, 010 OF _oDlg COLORS 0, 16777215 		 PIXEL Font oFnt   VALID (_fVlDlg("OP",cOP))
	@ 061, 240 SAY   oCodigo		PROMPT  "Produto"                							SIZE 030, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt2
	@ 070, 240 MSGET oProduto     VAR     cProduto      Picture "@!"   F3 "SB1"			SIZE 120, 010 OF _oDlg COLORS 0, 16777215 		 PIXEL Font oFnt   VALID (_fVlDlg("PROD",cProduto))
	@ 060, 435 SAY   oItm   		PROMPT  "Item"                   							SIZE 030, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt3
	@ 070, 435 MSGET oItem    		VAR     cItem                                  			SIZE 004, 014 OF _oDlg COLORS 0, 16777215 		 PIXEL Font oFnt4  WHEN .F.

	@ 061, 150 SAY   oCodOri		PROMPT  "Produto Origem"         							SIZE 090, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt2
	@ 070, 150 MSGET oProdOri     VAR     cProduto      Picture "@!"   F3 "SB1"			SIZE 120, 010 OF _oDlg COLORS 0, 16777215 		 PIXEL Font oFnt   VALID (_fVlDlg("PROD",cProduto))
	@ 061, 280 SAY   oCodDest		PROMPT  "Produto Destino"        							SIZE 090, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt2
	@ 070, 280 MSGET oProdDest    VAR     cProdDest     Picture "@!"   F3 "SB1"			SIZE 120, 010 OF _oDlg COLORS 0, 16777215 		 PIXEL Font oFnt   VALID (_fVlDlg("PRODD",cProdDest))

	oPrd := tComboBox():New(70,240,{ |u| iif(PCount() > 0 , cPrd:=u , cPrd ) },aEmpenho,110,21,_oDlg,,{ || _fVldlg("PRD",cPrd) },,,,.T.,oFnt,,,,,,,,'cPrd')	
	oPrd:SetHeight(24)

	@ 088, 075 SAY   oDescri		PROMPT  "Descrição do Produto"   							SIZE 100, 009 OF _oDlg COLORS 0, 16777215 PIXEL 		 Font oFnt2
	@ 088, 406 SAY   oLocal 		PROMPT  "Almox"                  							SIZE 030, 009 OF _oDlg COLOR  CLR_HBLUE   PIXEL 		 Font oFnt2
	@ 088, 435 SAY   oTp    		PROMPT  "Tipo"                   							SIZE 030, 009 OF _oDlg COLORS 0, 16777215 PIXEL 		 Font oFnt2
	@ 088, 464 SAY   oUN    		PROMPT  "U.M"                    							SIZE 030, 009 OF _oDlg COLORS 0, 16777215 PIXEL 		 Font oFnt2
	@ 097, 075 MSGET oDesc        VAR     cDesc       Picture "@!"   							SIZE 322, 010 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt  WHEN .F.
	@ 097, 406 MSGET oAlmox       VAR     cAlmox      Picture "@!"   							SIZE 020, 010 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt  VALID (_fVlDlg("ALMX",cAlmox))
	@ 097, 435 MSGET oTipo        VAR     cTipo       Picture "@!"   							SIZE 020, 010 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt  WHEN .F.
	@ 097, 464 MSGET oUM          VAR     cUM         Picture "@!"   							SIZE 020, 010 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt  WHEN .F.

	@ 112, 075 SAY   oQtde    		PROMPT  "Quantidade"           	 							SIZE 050, 014 OF _oDlg COLOR  CLR_HBLUE   PIXEL  		 Font oFnt3
	@ 122, 075 MSGET oQuant   		VAR     nQuant        PICTURE "@E 9999999.99"			SIZE 080, 012 OF _oDlg COLOR  CLR_HRED    PIXEL  		 Font oFnt5 VALID (_fVlDlg("QTDE",nQuant))
	@ 115, 174 SAY   oCst      	PROMPT  "Custo (R$)"       					            SIZE 080, 009 OF _oDlg COLOR  CLR_HBLUE   PIXEL  		 Font oFnt2
	@ 123, 174 MSGET oCusto    	VAR     nCusto        PICTURE "@E 999999.9999"  		SIZE 064, 010 OF _oDlg COLOR  CLR_BLACK   PIXEL  		 Font oFnt
	@ 115, 254 SAY   oMtv      	PROMPT  "Observação"             					      SIZE 070, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  		 Font oFnt2
	@ 123, 254 MSGET oMotivo		VAR     cObs          PICTURE "@!"              		SIZE 150, 010 OF _oDlg COLOR  CLR_HBLUE   PIXEL  		 Font oFnt2
		
	oTBitmap5 := TBtnBmp2():New( 030, 914, 70, 30,'conf_coel',,,,;      
						{ || f_confitem() }  ,_oDlg,OemToAnsi('Confirma a requisição do item'),,.F.,.F.)
	oTBitmap6 := TBtnBmp2():New( 064, 914, 70, 30,'canc_coel',,,,;   
						{ || f_cancitem() } , _oDlg,OemToAnsi('Cancela a requisição do item'),,.F.,.F.)

	oBrowse := TCBrowse():New( 153 , 075, 413, 93,,{"","Item","Componente","Descrição","Quantidade","O.P","Tipo"},{10,18,60,120,40,50,40},_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	

	oBrowse:SetArray(aCols)
	oBrowse:bldblclick := { || f_SelList(oBrowse:nAt) }  	
	oBrowse:bLine := {|| { IIF(aCols[oBrowse:nAt,1]=="1",oVd,oVm) , ;
								  aCols[oBrowse:nAt,2] , ;
								  aCols[oBrowse:nAt,3] , ;
								  aCols[oBrowse:nAt,4] , ;
								  aCols[oBrowse:nAt,5] , ;
								  aCols[oBrowse:nAt,6] , ;
								  aCols[oBrowse:nAt,7] } }
	oBrowse:lAdjustColsize := .F.

	oTBitmap1 := TBtnBmp2():New( 00, 00, 40, 70, 'S4WB008N' ,,,,;
						{ || Calculadora() }  ,oTBar,'Calculadora',,.F.,.F.)
	oTBitmap2 := TBtnBmp2():New( 00, 00, 40, 70, 'ok' ,,,,;
						{ || f_baixareq() }  ,oTBar,'Confirma a baixa do documento',,.F.,.F.)
	oTBitmap3 := TBtnBmp2():New( 00, 00, 40, 70, 'cancel' ,,,,;
						{ || f_cancreq() }  ,oTBar,'Cancela a baixa do documento',,.F.,.F.)
	oTBitmap4 := TBtnBmp2():New( 00, 00, 40, 70,'pmsexcel' , , , ,;
							{|| f_prtmov() }  ,oTBar,'Impressão do movimento interno',,.F.,.F.)					
	oTBitmap8 := TBtnBmp2():New( 00, 00, 40, 70,'cadeado' , , , ,;
							{|| IIF(lSenha , U_CPWD770(lAdmin,cMatric,cUsuario,0) , nil ) }  ,oTBar,'Senhas',,.F.,.F.)					
	oTBitmap7 := TBtnBmp2():New( 00, 00, 40, 70, 'button_exit' ,,,,;
						{ || f_Saida() }  ,oTBar,'Sair',,.F.,.F.)

	IF ( lAdmin )
		lSenha    := .T.
		cItem     := "0001"
		cAutoriza := "Z"
		cDocumen  := Space(9)
		cDocumen	 := IIf(Empty(cDocumen),NextNumero("SD3",2,"D3_DOC",.T.),cDocumen)
		cDocumen	 := A261RetINV(cDocumen)	
		
		oCodOri:Hide()
		oCodDest:Hide()
		oProdOri:Hide()
		oProdDest:Hide()
		oPrd:Hide()
		
		oDocumen:Refresh()

		oTipoM:Disable()
		oTpMov:Disable()
		oEmissao:Disable()
		oOP:Disable()
		oProduto:Disable()
		oAlmox:Disable()
		oQuant:Disable()
		oMotivo:Disable()		
		oAGUser:Disable()
		oAGSenha:Disable()
		oSGSolic:SetFocus()

	ELSE
						
		f_Hide()

		oAGUser:SetFocus()
	
	ENDIF
	
	oCusto:Disable()
	oDocumen:Disable()
	
	ACTIVATE MSDIALOG _oDlg CENTER VALID lSaida

ENDDO
	
Return

///////////////////////////////////////////////////////////
Static Function f_Saida()
///////////////////////////////////////////////////////////
Local lRsp := .T.

IF ( !EMPTY(aCols[1,3]) )

	lRsp := MsgBox("Deseja realmente sair da Rotina?","Escolha a opção","YESNO")
	
ENDIF

IF ( lRsp )
	lSaida   := .T.
	lLooping := .F.
	_oDlg:End()
ENDIF

Return(lRsp)

//////////////////////////////////////////////////////////////////////////////
Static Function f_Hide()
//////////////////////////////////////////////////////////////////////////////

oGroup2:Hide()
oGroup3:Hide()
oGroup4:Hide()
oGroup5:Hide()
oBrowse:Hide()
oSSSolic:Hide()
oSGSolic:Hide()
oDocto:Hide()
oDocumen:Hide()
oProduto:Hide()
oCodigo:Hide()
oCodOri:Hide()
oCodDest:Hide()
oProdOri:Hide()
oProdDest:Hide()
oPrd:Hide()
oAlmox:Hide()
oLocal:Hide()
oSeparador:Hide()
oTipoM:Hide()
oTpMov:Hide()
oTBitmap5:Hide()
oTBitmap6:Hide()
oDtEmiss:Hide()
oEmissao:Hide()
oNumOP:Hide()
oOP:Hide()
oDescri:Hide()
oTp:Hide()
oUN:Hide()
oDesc:Hide()
oTipo:Hide()
oUM:Hide()
oItm:Hide()
oItem:Hide()
oQtde:Hide()
oQuant:Hide()
oCst:Hide()
oCusto:Hide()
oMtv:Hide()
oMotivo:Hide()

Return
	
//////////////////////////////////////////////////////////////////////////////
Static Function f_Show()
//////////////////////////////////////////////////////////////////////////////

oGroup2:Show()
oGroup3:Show()
oGroup4:Show()
oGroup5:Show()
oBrowse:Show()
oSSSolic:Show()
oSGSolic:Show()
oDocto:Show()
oDocumen:Show()
oProduto:Show()
oCodigo:Show()
oLocal:Show()
oAlmox:Show()
oSeparador:Show()
oTipoM:Show()
oTpMov:Show()
oDtEmiss:Show()
oEmissao:Show()
oNumOP:Show()
oOP:Show()
oDescri:Show()
oTp:Show()
oUN:Show()
oDesc:Show()
oTipo:Show()
oUM:Show()
oItm:Show()
oItem:Show()
oQtde:Show()
oQuant:Show()
oCst:Show()
oCusto:Show()
oMtv:Show()
oMotivo:Show()

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_ssenhas()
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local osDlg,oGroup1,oGroup2,oGroup3,oMatr,oUser,oSenha1,oSenha2,oSenha3,oButton1,oButton2
Local oSenAtu,oSenNew,oSenConf
Local cDig,cTexto,cCredenc
Local nX,nLenP
Local lRsp     := .T.
Local lTrue    := .T.
Local nOpc     := 0
Local nSeq     := 0
Local aBaixa   := {"Parcial","Total"}
Local cSenAtu  := SPACE(4)
Local cSenNew  := SPACE(4)
Local cSenConf := SPACE(4)

Private oMatric,oUsuario,oProcesso,oBaixa
Private oCheck1,oCheck2,oCheck3,oCheck4,oCheck5,oCheck6
Private lCheck1 := lCheck2 := lCheck3 := lCheck4 := lCheck5 := lCheck6 := .F.
Private nBaixa  := 1

IF ( lAdmin )
	cMatric  := SPACE(6)
	cUsuario := SPACE(10)
ENDIF

DO WHILE lTrue

	DEFINE MSDIALOG osDlg TITLE ":::... SENHAS ...:::" FROM 000, 000  TO 370, 412 COLORS 0, 16777215 PIXEL

	oTBar := TBar():New( osDlg,40,25,.T.,,,,.F. )   

	@ 025, 003 GROUP oGroup1 TO 165, 203 PROMPT ""                               	                        OF osDlg COLOR  0, 16777215 PIXEL
	@ 029, 007 SAY   oMatr               PROMPT "Matrícula"                    	          SIZE 050, 010 OF osDlg COLORS 0, 16777215 PIXEL FONT oFnt3
	@ 045, 007 SAY   oUser               PROMPT "Nome do Usuário"              	          SIZE 090, 010 OF osDlg COLORS 0, 16777215 PIXEL FONT oFnt3
	@ 061, 007 SAY   oSenha1             PROMPT "Senha Atual"                  	          SIZE 060, 010 OF osDlg COLOR CLR_HBLUE    PIXEL FONT oFnt3
	@ 077, 007 SAY   oSenha2             PROMPT "Nova Senha"                   	          SIZE 060, 010 OF osDlg COLOR CLR_HBLUE    PIXEL FONT oFnt3
	@ 075, 061 SAY   oAster01            PROMPT "*"                            	          SIZE 004, 006 OF osDlg COLOR CLR_HRED     PIXEL FONT oFnt3
	@ 093, 007 SAY   oSenha3             PROMPT "Confirmar Nova Senha"         	          SIZE 120, 010 OF osDlg COLOR CLR_HBLUE    PIXEL FONT oFnt
	@ 090, 095 SAY   oAster02            PROMPT "*"                            	          SIZE 004, 006 OF osDlg COLOR CLR_HRED     PIXEL FONT oFnt3
	@ 029, 109 MSGET oMatric             VAR    cMatric      Picture "@R 999999"	          SIZE 050, 010 OF osDlg COLORS 0, 16777215 PIXEL FONT oFnt3 VALID f_matric(1)
	@ 045, 109 MSGET oUsuario            VAR    cUsuario		Picture "@!"		 	          SIZE 090, 010 OF osDlg COLORS 0, 16777215 PIXEL FONT oFnt3
	@ 061, 109 MSGET oSenAtu             VAR    cSenAtu		Picture "@R 9999" 	PASSWORD  SIZE 050, 010 OF osDlg COLORS 0, 16777215 PIXEL FONT oFnt3
	@ 077, 109 MSGET oSenNew             VAR    cSenNew 		Picture "@R 9999" 	PASSWORD  SIZE 050, 010 OF osDlg COLORS 0, 16777215 PIXEL FONT oFnt3
	@ 093, 109 MSGET oSenConf            VAR    cSenConf 	   Picture "@R 9999" 	PASSWORD  SIZE 050, 010 OF osDlg COLORS 0, 16777215 PIXEL FONT oFnt3
	 
	@ 168, 060 BUTTON oButton1 PROMPT "Finalizar" SIZE 060, 014 OF osDlg PIXEL FONT oFnt3 Action (nOpc := 1 , osDlg:End() )
	@ 168, 136 BUTTON oButton2 PROMPT "Cancelar"  SIZE 060, 014 OF osDlg PIXEL FONT oFnt3 Action (nOpc := 2 , lTrue := .F. , osDlg:End() )

	IF ( !lAdmin )
		@ 013, 004 SAY   oProcesso PROMPT "Alterar Senha"  SIZE 100, 010 OF osDlg COLORS 0, 16777215 PIXEL FONT oFnt3
		@ 110, 007 GROUP oGroup2 TO 161, 200 PROMPT "(*)"                                                                                OF osDlg COLOR  CLR_HRED    PIXEL
		@ 117, 010 SAY   oCrit01             PROMPT "- A senha não pode ser sequencial (Ex.: 123... 6789...)."                      SIZE 360, 010 OF osDlg COLORS 0, 16777215 PIXEL
		@ 125, 010 SAY   oCrit02             PROMPT "- A senha não pode ter mais que 2 digitos repetidos (Ex.: 111... 555...)."     SIZE 360, 010 OF osDlg COLORS 0, 16777215 PIXEL
		@ 133, 010 SAY   oCrit03             PROMPT "- A senha não pode ser igual a matrícula do funcionário.)"                     SIZE 360, 010 OF osDlg COLORS 0, 16777215 PIXEL
		@ 141, 010 SAY   oCrit04             PROMPT "- A senha não pode ter menos que 4 dígitos (Ex.: 47  ; 652)."                  SIZE 360, 010 OF osDlg COLORS 0, 16777215 PIXEL
		
		oMatric:Disable()
		oUsuario:Disable()
		
	ELSE
		oAster01:Hide()
		oAster02:Hide()
		oSenha1:Hide()
		oSenha2:Hide()
		oSenha3:Hide()
		oSenAtu:Hide()
		oSenNew:Hide()
		oSenConf:Hide()

		@ 013, 004 SAY      oProcesso           PROMPT "Incluir Usuário"  SIZE 100, 010 OF osDlg COLORS 0, 16777215 PIXEL FONT oFnt3
		@ 061, 007 GROUP    oGroup2 TO 163, 200 PROMPT "ROTINAS"                        OF osDlg COLOR  0, 16777215 PIXEL
		@ 140, 010 GROUP    oGroup3 TO 160, 100 PROMPT "(*)"                            OF osDlg COLOR  CLR_HRED    PIXEL
		oCheck1 := TCheckBox():New(068,010,'Mov.Interno - Entrada'      , {|u1|if(PCount()>0,lCheck1:=u1,lCheck1)},osDlg, 100,007,,,,,,,,.T.,,,)	
		oCheck2 := TCheckBox():New(077,010,'Mov.Interno - Saída'        , {|u2|if(PCount()>0,lCheck2:=u2,lCheck2)},osDlg, 100,007,,,,,,,,.T.,,,)	
		@ 075, 066 SAY      oAster01            PROMPT "*"            	   SIZE 004, 006 OF osDlg COLOR CLR_HRED     PIXEL FONT oFnt3
		oCheck3 := TCheckBox():New(086,010,'Separação Material'         , {|u3|if(PCount()>0,lCheck3:=u3,lCheck3)},osDlg, 100,007,,,,,,,,.T.,,,)	
		oCheck4 := TCheckBox():New(095,010,'Apontamento Produção'       , {|u4|if(PCount()>0,lCheck4:=u4,lCheck4)},osDlg, 100,007,,,,,,,,.T.,,,)	
		oCheck5 := TCheckBox():New(104,010,'Estorno Apont.Produção'     , {|u5|if(PCount()>0,lCheck5:=u5,lCheck5)},osDlg, 100,007,,,,,,,,.T.,,,)	
		oCheck6 := TCheckBox():New(113,010,'Etiqueta Embalagem Produção', {|u6|if(PCount()>0,lCheck6:=u6,lCheck6)},osDlg, 100,007,,,,,,,,.T.,,,)	

		oBaixa := TRadMenu():New (148,014,aBaixa,,osDlg,,,,,,,,090,020,,,,.T.)
		oBaixa:bSetGet := {|ub|Iif (PCount()==0,nBaixa,nBaixa:=ub)} 
		oBaixa:lHoriz  := .T.
		
	ENDIF

	ACTIVATE MSDIALOG osDlg CENTERED VALID nOpc <> 0

	IF ( nOpc == 1 )
		IF ( lAdmin )
			cSenConf := RIGHT(cMatric,4)
			lTrue    := .F.			
		ELSE
			nLenP	:= Len(RTRIM(cSenConf))
			IF ( nLenP < 4 )
				cSenConf := "SIZE"
			EndIF
			IF ( cSenConf <> "SIZE" )
				aSenhas := {}
				For nX := 1 TO nLenP
					cDig := SubStr( cSenConf , nX , 1 )
					IF ( Empty( StrTran(cSenConf,cDig,"") ) ) 
						cSenConf := "EQUA"
						Exit
					EndIF
					AADD(aSenhas , VAL(cDig) )
				Next
				IF ( cSenConf <> "EQUA" )
					For nX := nLenP TO 1 STEP -1
						IF ( nX > 2 )
							IF ( Empty( StrTran(Substring(cSenConf,(nX-2),3),Str(aSenhas[nX],1),"") ) ) 
								cSenConf := "EQUA"
								Exit
							EndIF
						ENDIF
					Next	
					IF ( cSenConf <> "EQUA" )
						nX := 0
						IF ( aSenhas[1] < aSenhas[2] )
							aEval( aSenhas , { |x,y| IIF( ( y == 1 ) .or. ( ( x - nX ) <>  1 ) , nX := x , ( ++nSeq , nX := x ) ) } )
						Else
							aEval( aSenhas , { |x,y| IIF( ( y == 1 ) .or. ( ( x - nX ) <> -1 ) , nX := x , ( ++nSeq , nX := x ) ) } )
						EndIF
						IF ( nSeq == (nLenP - 1) )
							cSenConf := "SEQU"				
						ELSEIF ( cSenConf == RIGHT(cMatric,4) )
							cSenConf := "MATR"
						EndIF
					ENDIF	
				EndIF
			EndIF
			
			lTrue := ( cSenConf $ "EQUA/SIZE/MATR/SEQU" ) 
			
			IF ( !lTrue )
				cPassword := Embaralha(LEFT(SRA->RA_SENHA,4),1)
				lTrue     := !( cPassword == cSenAtu )
				cSenConf  := IIF(lTrue , "SENA" , cSenConf )
				IF ( !lTrue .AND. cSenConf <> cSenNew )
					cSenConf := "DIFE"
					lTrue    := .T.
				ENDIF	
			ENDIF
		ENDIF
		IF ( !lTrue )
			dbSelectArea("SRA")
			IF ( ! RecLock("SRA",.F.) )
			   MsgStop("No momento, não é possível gravar a nova senha. Tente mais tarde.","Atenção")
			ELSE	
				SRA->RA_SENHA := Embaralha(cSenConf,0)
			ENDIF
			MsUnlock()
			
			IF ( SX5->(EOF()) )
				RecLock("SX5",.T.)
				SX5->X5_FILIAL := xFilial("SX5")
				SX5->X5_TABELA := "Z@"
				SX5->X5_CHAVE  := cMatric
				cTexto         := "01"
			ELSE
				RecLock("SX5",.F.)
				cTexto := LEFT(SX5->X5_DESCRI,2)
			ENDIF
			IF ( lAdmin )
				cCredenc := IIF(lCheck1 , "S" , "N" )                   ///Movimento de Entrada
				cCredenc += IIF(lCheck2 , "S" , "N" )                   ///Movimento de Saida
				cCredenc += IIF(lCheck3 , "S" , "N" )                   ///Apontamento Sep.Materiais
				cCredenc += IIF(lCheck4 , "S" , "N" )                   ///Apontamento de Produção
				cCredenc += IIF(lCheck5 , "S" , "N" )                   ///Estorno de Apontamento de Produção
				cCredenc += IIF(lCheck6 , "S" , "N" )                   ///Etiqueta Embalagem de Produção
				cCredenc += "NNNNNNNNN"
				cTexto   += IIF(!lCheck3.AND.!lCheck4 , "00-00" , IIF(lCheck3.AND.lCheck4 , "01-08" , IIF(lCheck3 , "01-01" , "02-08") ) )
				cTexto   += Embaralha(cSenConf,0)
				cTexto   += "##"
				cTexto   += cCredenc
				cTexto   += cUsuario
				IF ( lCheck2 )
					cTexto := STUFF(cTexto,5,1,IIF(nBaixa==1 , "R" , "Z" ) )
				ENDIF	
				
				SX5->X5_DESCRI := cTexto
				
			ELSE
			
				SX5->X5_DESCRI := STUFF(SX5->X5_DESCRI , 8 , 4 , Embaralha(cSenConf,0) )
				
			ENDIF
			
			MsUnlock()
			
			dbCommitAll()
			
		ELSE
			IF ( cSenConf == "SENA" )
				MsgStop("Senha Atual inválida","Atenção")
			ELSEIF ( cSenConf == 'SEQU' )
				MsgStop("A Senha não pode conter mais que 2 digitos sequenciais.","Atenção")
			ELSEIF ( cSenConf == "DIFE" )
				MsgStop("Nova senha não bate com senha a confirmar.","Atenção")
			ELSEIF ( cSenConf == "EQUA" )
				MsgStop("Não pode existir mais de 2 digitos sequencial e iguais na senha.","Atenção")
			ElseIF ( cSenConf == "SIZE" )
				MsgStop("O número de caracteres da senha é menor que 4.","Atenção")	
			ElseIF ( cSenConf == "MATR" )
				MsgStop("A Senha não pode ser igual a Matricula.","Atenção")	
			EndIF
			cSenConf := SPACE(4)
		ENDIF
	ENDIF
	
ENDDO

Return( IIF( nOpc==1 , .T. , .F. ) )

/////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_mmatric(nOpcB)
/////////////////////////////////////////////////////////////////////////////////////////////////////////
Local nX
Local cCredenc
Local lRsp := .T.

IF ( !EMPTY(cMatric) .AND. nOpcB == 1 )
	dbSelectArea("SRA")
	dbSetOrder(1)
	dbSeek(xFilial("SRA")+cMatric)
	IF ( SRA->(EOF()) )
		MsgStop("Matrícula não cadastrada.","Atenção")
		lRsp := .F.
	ELSE
		dbSelectArea("SX5")
		dbSetOrder(1)
		dbSeek(xFilial("SX5")+"Z@"+cMatric)
		IF ( SX5->(!EOF()) )
			cUsuario := SUBS(SX5->X5_DESCRI,29,10)
			cCredenc := SUBS(SX5->X5_DESCRI,14,15)
			lCheck1  := ( SUBS(cCredenc,1,1) == "S" )
			lCheck2  := ( SUBS(cCredenc,2,1) == "S" )
			lCheck3  := ( SUBS(cCredenc,3,1) == "S" )
			lCheck4  := ( SUBS(cCredenc,4,1) == "S" )
			lCheck5  := ( SUBS(cCredenc,5,1) == "S" )
			lCheck6  := ( SUBS(cCredenc,6,1) == "S" )
			nBaixa   := IIF(SUBS(SX5->X5_DESCRI,5,1)=="Z",2,1)

			oUsuario:Disable()
			oMatric:Disable()
			oProcesso:cCaption := "Alterar Credenciais"
			oProcesso:Refresh()
			oCheck1:CtrlRefresh()
			oCheck2:CtrlRefresh()
			oCheck3:CtrlRefresh()
			oCheck4:CtrlRefresh()
			oCheck5:CtrlRefresh()
			oCheck6:CtrlRefresh()
			oBaixa:Refresh()
			
		ELSE	
			nX       := AT(" ",SRA->RA_NOME)
			cUsuario := PADR( LEFT(SRA->RA_NOME,(nX-1)) , 10 )
		ENDIF	
		oUsuario:Refresh()
	ENDIF	
ENDIF

Return(lRsp)

//////////////////////////////////////////////////////////////////////////////
Static Function f_sellist(nItem)
//////////////////////////////////////////////////////////////////////////////
Local lRsp    := .T.
Local _nTipoM := VAL(SUBS(aCols[nItem,7],1,1))
Local _nTpMov := VAL(SUBS(aCols[nItem,7],2,1))

cProduto := aCols[nItem,3]

SB1->(dbSeek(xFilial("SB1")+cProduto))

cDesc       := aCols[nItem,4]
cUm	      := aCols[nItem,8]
cTipo       := aCols[nItem,9]
cAlmox	   := aCols[nItem,10]
cObs        := aCols[nItem,11]
nQuant      := aCols[nItem,5]
nCusto      := aCols[nItem,15]
cItem       := aCols[nItem,2]
lBrowse     := .T.
lEmProcesso := .T.

IF ( _nTipoM <> nTipoM )
	aTpMov        := IIF(_nTipoM==2 , ACLONE(aTpMovS) , ACLONE(aTpMovE) )
	oTpMov:aItems := IIF(_nTipoM==2 , ACLONE(aTpMovS) , ACLONE(aTpMovE) )
	oTipoM:SetOption(_nTipoM)
	oTipoM:Refresh()
ENDIF
oTpMov:SetOption(_nTpMov)
oTpMov:Refresh()

nTipoM := _nTipoM
nTpMOv := _nTpMov
IF ( nTipoM == 1 )	
	IF ( nTpMov == 4 )
		oCusto:Enable()
	ENDIF
	cOP := SPACE(8)
	oOP:Disable()
	oPrd:Hide()                        ///Produto em ComboBox
	oProduto:Show()
	IF ( oCodOri:lActive )
		oCodOri:Hide()
		oProdOri:Hide()
		oCodDest:Hide()
		oProdDest:Hide()
		lBrowse := .T.
		oCodigo:Show()
		lBrowse := .T.
		oNumOP:Show()
		lBrowse := .T.
		oProduto:Show()
		lBrowse := .T.
		oOP:Show()
		
		cProdDest := Space(30)
	ENDIF				
ELSE
	DO CASE
		CASE nTpMov == 1
			
			cOP := SPACE(8)
			oOP:Disable()
			oPrd:Hide()                        ///Produto em ComboBox
			oProduto:Show()
			
		CASE nTpMov == 5

			cProdDest := aCols[nItem,14]

			oCodigo:Hide()
			oProduto:Hide()
			oNumOP:Hide()
			oPrd:Hide()
			oOP:Hide()
			oCodOri:Show()
			oProdOri:Show()
			oCodDest:Show()
			oProdDest:Show()		
			
		OTHERWISE

			cOP       := IIF(EMPTY(aCols[nItem,6]) , SPACE(8) , STRTRAN(aCols[nItem,6],"-","") )
			aEmpenho  := aCols[nItem,12]

			IF ( !EMPTY(cOP) )
				cPrd := aCols[nItem,13]
				nX   := ASCAN(aEmpenho , cPrd )
				nX   := IIF(nX > 0 , nX , 1 )
				oProduto:Hide()
				oPrd:Show()
				oPrd:SetItems(aEmpenho) 
				oPrd:Select( nX )
				oOP:Enable()
			ELSE
				oPrd:Hide()
				oProduto:Show()
			ENDIF
			
	ENDCASE	
ENDIF
	
oEmissao:SetFocus()	
	
Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_confitem()
//////////////////////////////////////////////////////////////////////////////
Local nX
Local lRsp := lEmProcesso

IF ( lRsp )
	IF ( EMPTY(dEmissao).OR.EMPTY(cProduto).OR.EMPTY(cAlmox) )
		MsgStop("Falta preenchimento de campos obrigatórios","Atenção")
		Return
	ENDIF

	nX := ASCAN(aCols , { |x| x[2]==cItem } )
	
	IF ( nX == 0 .OR. EMPTY(aCols[nX,3]) )
		IF ( nQuant == 0 )
			MsgStop("Falta informar a quantidade para esta requisição.","Atenção")
			Return
		ELSEIF ( nTipoM == 2 )
			SB2->(dbSeek(xFilial("SB2")+cProduto+IIF(nTpMov==8,"60",cAlmox)))
			IF ( SB2->B2_QATU < nQuant )
			   MsgStop("Saldo insuficiente em estoque para atender esta requisição.","Atenção")
			   Return
		   ENDIF		  
		ENDIF
	ENDIF

	cTpMov := STR(nTipoM,1)+STR(nTpMov,1)+"-"+aTpMov[nTpMov]
	xOP    := IIF(EMPTY(cOP) , SPACE(9) , TRANSF(cOP,"@R XXXXXX-XX") )
	
	IF ( nX == 0 )		
		AADD( aCols , { "1"              , ;
							 cItem            , ;
							 cProduto         , ;
							 cDesc            , ;
							 nQuant           , ;
							 xOP              , ;
							 cTpMov           , ;
							 cUM              , ;
							 cTipo            , ;
							 cAlmox           , ;
							 cObs             , ;
							 aEmpenho         , ;
							 cPrd             , ;
							 cProdDest        , ;
							 nCusto } )
							 
	ELSE
		aCols[nX,1]  := IIF(nQuant > 0 , "1" , "0" )
		aCols[nX,3]  := cProduto
		aCols[nX,4]  := cDesc
		aCols[nX,5]  := nQuant
		aCols[nX,6]  := xOP
		aCols[nX,7]  := cTpMov
		aCols[nX,8]  := cUM
		aCols[nX,9]  := cTipo
		aCols[nX,10] := cAlmox
		aCols[nX,11] := cObs
		aCols[nX,12] := aEmpenho
		aCols[nX,13] := cPrd
		aCols[nX,14] := cProdDest
		aCols[nX,15] := nCusto
		
		cItem := STRZERO(LEN(aCols),4)
		
	ENDIF

	cItem := Soma1(cItem,4)
	
	IF ( !EMPTY(cProdDest) )
		nTpMov    := 1
		cProdDest := Space(30)
		oCodOri:Hide()
		oProdOri:Hide()
		oCodDest:Hide()
		oProdDest:Hide()
		oCodigo:Show()
		oProduto:Show()
		oNumOP:Show()
		oOP:Show()			
		oOP:Disable()
	ENDIF
	
	cProduto  := Space(30)
	cDesc     := Space(70)
	cUm	    := Space(2)
	cTipo     := Space(2)
	cAlmox	 := Space(2)
	cPrd      := cProduto + Space(100)
	cOP       := Space(8)
	mOP       := Space(8)
	nQuant    := 0
	nCusto    := 0
	
	lEmProcesso  := .F.
	
	IF ( nTpMov == 8 )
		oTipoM:Disable()
		oTpMov:Disable()
		oDocumen:Disable()
	ENDIF
	
	oBrowse:SetArray(aCols)
	oBrowse:bLine := {|| { IIF(aCols[oBrowse:nAt,1]=="1",oVd,oVm) , ;
								  aCols[oBrowse:nAt,2] , ;
								  aCols[oBrowse:nAt,3] , ;
								  aCols[oBrowse:nAt,4] , ;
								  aCols[oBrowse:nAt,5] , ;
								  aCols[oBrowse:nAt,6] , ;
								  aCols[oBrowse:nAt,7] } }
	oBrowse:lAdjustColsize := .F.
	oBrowse:Refresh()
			
	oEmissao:SetFocus()	
	
ENDIF

Return

///////////////////////////////////////////////////////////
Static Function f_cancitem()
///////////////////////////////////////////////////////////
Local nX
Local lRsp := .T. 

IF ( lRsp )
	
	nX := ASCAN(aCols , { |x| x[2]==cItem } )
	
	IF ( nX > 0 .AND. !EMPTY(aCols[nX,3]) )
		cItem := STRZERO(LEN(aCols),4)
		cItem := Soma1(cItem,4)
	ENDIF

	IF ( oProdOri:lActive )
		oCodOri:Hide()
		oProdOri:Hide()
		oCodDest:Hide()
		oProdDest:Hide()
		oCodigo:Show()
		oProduto:Show()
		oNumOP:Show()
		oOP:Show()			
	ENDIF
	
	///oDocumen:Disable()
   ///oSGSolic:Enable()
	oOP:Disable()
	oPrd:Hide()
	oProduto:Show()

	aEmpenho  := {}	
	cProdDest := Space(30)
	cPrd      := Space(130)
	cProduto  := Space(30)
	cDesc     := Space(70)
	cUm	    := Space(2)
	cTipo     := Space(2)
	cAlmox	 := Space(2)
	cOP       := Space(8)
	mOP       := Space(8)
	cObs      := Space(30)
	nQuant    := 0
	nCusto    := 0

	lEmProcesso  := .F.
	
	IF ( nTpMov <> 8 .OR. EMPTY(aCols[1,3]) )
		IF ( EMPTY(aCols[1,3]) )
			nCusto   := 0
			cDocumen := Space(9)
			cDocumen	:= IIf(Empty(cDocumen),NextNumero("SD3",2,"D3_DOC",.T.),cDocumen)
			cDocumen	:= A261RetINV(cDocumen)			
			oDocumen:Disable()
			oDocumen:Refresh()
			oCusto:Refresh()
		ENDIF
		nTpMov        := 1
		nTipoM        := 1	
		aTpMov        := ACLONE(aTpMovE)
		oTpMov:aItems := ACLONE(aTpMovE)
		oTipoM:SetOption(nTipoM)
		oTipoM:Refresh()
		oTpMov:SetOption(nTpMov)
		oTpMov:Refresh()		
	ENDIF
	
	oBrowse:SetArray(aCols)
	oBrowse:bLine := {|| { IIF(aCols[oBrowse:nAt,1]=="1",oVd,oVm) , ;
								  aCols[oBrowse:nAt,2] , ;
								  aCols[oBrowse:nAt,3] , ;
								  aCols[oBrowse:nAt,4] , ;
								  aCols[oBrowse:nAt,5] , ;
								  aCols[oBrowse:nAt,6] , ;
								  aCols[oBrowse:nAt,7] } }
	
	oEmissao:SetFocus()	
	
ENDIF

Return

///////////////////////////////////////////////////////////
Static Function f_cancreq()
///////////////////////////////////////////////////////////
Local nX
Local lRsp := !EMPTY(aCols[1,3])              ///Se já houver movimentacao para solicitar a confirmacao do cancelamento

IF ( lRsp )
	
	lRsp := MsgBox("Confirma o cancelamento deste Documento?","Escolha a opção","YESNO")
	
	IF ( !lRsp )
		Return
	ENDIF

ENDIF
	
lSaida := .T.

_oDlg:End()

Return

/////////////////////////////////////////////////////////////////////////////
Static Function f_baixareq()
/////////////////////////////////////////////////////////////////////////////
Local nX,nZ,nCM1,nVAtu,nTpMov1,nTpMov2
Local cNumSeq,cTpMov,cLocDest
Local lRsp := !EMPTY(aCols[1,3])              ///Se já houver movimentacao para solicitar a confirmacao da baixa

IF ( lRsp )
	
	lRsp := MsgBox("Confirma a baixa deste Documento?","Escolha a opção","YESNO")
	
	IF ( !lRsp )
		Return
	ENDIF

ELSE
	Return
ENDIF

FOR nX:=1 TO LEN(aCols)
	 IF ( aCols[nX,1] == "1" )
		 		 
		 nCm1     := aCols[nX,15]     ////( SB2->B2_VATU1 / SB2->B2_QATU )
		 nVatu    := IIF(nTpMov1==1.AND.nTpMov2==4 , nCm1 , ROUND( ( nCm1 * aCols[nX,5] ) , 4 ) )
		 nTpMov1  := VAL(LEFT(aCols[nX,7],1))                                                                 ///1=Entrada; 2=Saida
		 nTpMov2  := VAL(SUBS(aCols[nX,7],2,1))                                                               ///Tipo do movimento
		 nTpMov2  := IIF(nTpMov1==2, ( nTpMov2 + 5 ) , nTpMov2 )
		 nVatu    := IIF(nTpMov2==10 , aCols[nX,15] , nVatu )                                                 ///Transferencia de produto
		 cLocDest := IIF(nTpMov2==13 , "60" , aCols[nX,10] )                                                  ///60 = Local das devolucoes de NF

		 dbSelectArea("SD3")
	 	 cNumSeq := ProxNum()

		 SB1->(dbSeek(xFilial("SB1")+aCols[nX,3]))		 
		 SB2->(DbSeek(xFilial("SB2")+aCols[nX,3]+cLocDest))
	
/*	
		Begin Transaction
		a241Grava(cAlias,nOpcao,@lChangeDoc)
		// Processa Gatilhos
		EvalTrigger()
		If __lSX8
			ConfirmSX8()
		EndIf
		End Transaction

*/		
		 RecLock("SD3",.T.)
		 SD3->D3_FILIAL  := xFilial("SD3")
		 SD3->D3_TM      := aMovimen[nTpMov2,2]
		 SD3->D3_CF      := aMovimen[nTpMov2,3]
		 SD3->D3_COD     := aCols[nX,3]
		 SD3->D3_QUANT   := aCols[nX,5]
		 SD3->D3_CUSTO1  := nVatu
		 SD3->D3_LOCAL   := cLocDest
		 SD3->D3_DOC     := cDocumen
		 SD3->D3_EMISSAO := dEmissao
		 SD3->D3_USUARIO := cANome
		 SD3->D3_CHAVE   := "E0"
		 SD3->D3_NUMSEQ  := cNumSeq
		 SD3->D3_UM      := SB1->B1_UM
		 SD3->D3_TIPO    := SB1->B1_TIPO
		 SD3->D3_GRUPO   := SB1->B1_GRUPO
		 SD3->D3_CONTA   := SB1->B1_CONTA
		 SD3->D3_CC      := SB1->B1_CC
		 SD3->D3_X_OBS   := aCols[nX,11]
		 SD3->D3_X_OBS2  := aMovimen[nTpMov2,1]+"OP:"+aCols[nX,6]+" - SOL: "+cSSolic
		 MsUnLock()

		 ////
		 ////Atualiza saldo fisico/financeiro
		 ////
		 RecLock("SB2",.F.)
		 IF ( nTpMov1 == 1 )
			 SB2->B2_QATU  := ( SB2->B2_QATU + aCols[nX,5] )
			 SB2->B2_VATU1 := ( SB2->B2_VATU1 + nVAtu )
		 ELSE
			 SB2->B2_QATU  := ( SB2->B2_QATU - aCols[nX,5] )
			 SB2->B2_VATU1 := ( SB2->B2_VATU1 - nVAtu )
			 IF ( dEmissao > SB2->B2_USAI )
				SB2->B2_USAI  := dEmissao
			 ENDIF
		 ENDIF
		 MsUnlock()
		 
		 IF ( STR(nTpMov2,2) $ "10,13" )                                    ////Transferencia - Entrada ou Devol.NF
			 
			 IF ( nTpMov2 == 10 )
				SB1->(dbSeek(xFilial("SB1")+aCols[nX,14]))		 
				SB2->(DbSeek(xFilial("SB2")+aCols[nX,14]+aCols[nX,10]))
			 ELSE
				SB2->(DbSeek(xFilial("SB2")+aCols[nX,3]+aCols[nX,10]))
			 ENDIF
			 
			 RecLock("SD3",.T.)
			 SD3->D3_FILIAL  := xFilial("SD3")
			 SD3->D3_TM      := "499"
			 SD3->D3_CF      := "DE4"
			 SD3->D3_COD     := IIF(nTpMov2==10 , aCols[nX,14] , aCols[nX,3] )
			 SD3->D3_QUANT   := aCols[nX,5]
			 SD3->D3_CUSTO1  := nVatu
			 SD3->D3_LOCAL   := aCols[nX,10]
			 SD3->D3_DOC     := cDocumen
			 SD3->D3_EMISSAO := dEmissao
			 SD3->D3_USUARIO := cANome
			 SD3->D3_CHAVE   := "E9"
			 SD3->D3_NUMSEQ  := cNumSeq
			 SD3->D3_UM      := SB1->B1_UM
			 SD3->D3_TIPO    := SB1->B1_TIPO
			 SD3->D3_GRUPO   := SB1->B1_GRUPO
			 SD3->D3_CONTA   := SB1->B1_CONTA
			 SD3->D3_CC      := SB1->B1_CC
			 SD3->D3_X_OBS   := aCols[nX,11]
			 SD3->D3_X_OBS2  := aMovimen[nTpMov2,1]+"OP:"+aCols[nX,6]+" - SOL: "+cSSolic
			 MsUnLock()

			 ////
			 ////Atualiza saldo fisico/financeiro
			 ////
			 RecLock("SB2",.F.)
			 SB2->B2_QATU  := ( SB2->B2_QATU + aCols[nX,5] )
			 SB2->B2_VATU1 := ( SB2->B2_VATU1 + nVAtu )
			 MsUnlock()
			 
		 ENDIF
		 
		 dbCommitAll()
		 
		 Inkey(1)
		 
	 ENDIF
NEXT

MsgInfo("Documento processado com sucesso!!!","Documento No. "+cDocumen)

///
///Limpa a tela para digitacao de um novo documento
///
aCols[1,3] := " "

f_cancreq()

Return

///////////////////////////////////////////////////////////
Static Function f_prtmov()
///////////////////////////////////////////////////////////
Local cProduto,cAno,cExt,dxData
Local fArq
Local mLinDet,cLinDet,c_Solic,c_OP,c_Tp
Local aLinhas,aRows
Local nW
Local nCtd       := 0
Local oExcel     := FWMSEXCEL():New()
Local cWorkSheet := "MOV.INTERNO"
Local oExcelApp

Pergunte(cPerg,.T.)

cRelato := "CESTG770"

cLinDet := "M O V I M E N T A Ç Ã O     I N T E R N A     D E     M A T E R I A L"

oExcel:AddworkSheet(cWorkSheet)
oExcel:AddTable (cWorkSheet,cLinDet)
oExcel:AddColumn(cWorkSheet,cLinDet,"EMISSÃO",1,4)
oExcel:AddColumn(cWorkSheet,cLinDet,"PRODUTO",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"DESCRIÇÃO",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"QUANT.",3,2)
oExcel:AddColumn(cWorkSheet,cLinDet,"UM",2,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"TIPO MOV.",1,1)                                      ///Alinhamento da coluna [3] - ( 1-Left,2-Center,3-Right )
oExcel:AddColumn(cWorkSheet,cLinDet,"C.F",1,1)                                            ///Codigo de formatação  [2] - ( 1-General,2-Number,3-Monetário,4-DateTime )
oExcel:AddColumn(cWorkSheet,cLinDet,"DOCUMENTO",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"O.P",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"OBSERVAÇÃO",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"SOLICITANTE",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"OPERADOR",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"CUSTO MEDIO",1,1)
*********************************************
////
////Filtra movimento de acordo com os parametros informados
////
cQry := "SELECT D3_TM,D3_CF,D3_EMISSAO,D3_DOC,D3_OP,D3_NUMSEQ,D3_IDENT,D3_USUARIO,D3_COD,D3_QUANT,D3_UM,D3_X_OBS,D3_X_OBS2,D3_CHAVE,B1_DESC,D3_CUSTO1"
cQry += " FROM "+RetSqlName("SD3")+" D3,"+RetSqlName("SB1")+" B1"
cQry += " WHERE D3.D_E_L_E_T_ = ' ' AND B1.D_E_L_E_T_ = ' '"
cQry += " AND D3_FILIAL  = '"+xFilial("SD3")+"'"
cQry += " AND D3_ESTORNO = ' '"
cQry += " AND D3_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQry += " AND D3_DOC     BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
cQry += " AND D3_COD     BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
cQry += " AND LEFT(D3_X_OBS2,5) IN ('(ACE)','(RPM)','(CNF)','(EVL)','(OUE)','(RPS)','(SCR)','(DEF)','(FLT)','(TRF)','(SNF)','(OUS)','(ACS)','(DNF)')"
cQry += " AND B1_FILIAL  = '"+xFilial("SB1")+"'"
cQry += " AND B1_COD     = D3_COD"
cQry += " ORDER BY D3_DOC,D3_COD,D3_CF "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

TcSetField("TMP","D3_EMISSAO","D",08,0)

dbSelectArea("TMP")
dbGoTop()
ProcRegua(RECCOUNT())
Do While !Eof()
	nW      := AT("SOL:" , TMP->D3_X_OBS2)
	c_Tp    := LEFT(TMP->D3_X_OBS2,5)
	c_OP    := SUBS(TMP->D3_X_OBS2,9,9)
	c_Solic := SUBS(TMP->D3_X_OBS2,(nW+5),15)
	nW      := ASCAN(aMovimen , { |x| x[1] == c_Tp } )
	aRows   := { DTOC(TMP->D3_EMISSAO) , ;
					 TMP->D3_COD           , ;
					 LEFT(TMP->B1_DESC,70) , ;
					 TMP->D3_QUANT         , ;
					 TMP->D3_UM            , ;
					 aMovimen[nW,4]        , ;
					 TMP->D3_CF            , ;
					 TMP->D3_DOC           , ;
					 c_OP                  , ;
					 TMP->D3_X_OBS         , ;
					 c_Solic               , ;
					 TMP->D3_USUARIO,;
					 TMP->D3_CUSTO1 }
	
	oExcel:AddRow(cWorkSheet,cLinDet,aRows)

	dbSkip()
			
Enddo
oExcel:Activate()
oExcel:GetXMLFile("C:\RELATO\"+cRelato)
oExcel:DeActivate()

TMP->(dbCloseArea())

///
///Abre o Excel
///

If ! ApOleClient( 'MsExcel' )                                                 //Verifica se o Excel esta instalado
	MsgStop( 'MsExcel nao instalado' )
	Return
EndIf

oExcelApp := MsExcel():New()                                                  // Cria um objeto para o uso do Excel
oExcelApp:WorkBooks:Open("C:\Relato\"+cRelato)               						// Atribui à propriedade WorkBooks do Excel
oExcelApp:SetVisible(.T.)                                                     // Abre o Excel com o arquivo criado exibido na Primeira planilha.
oExcelApp:Destroy()                                                           //Encerra o processo do gerenciador de tarefas

MS_FLUSH()

Return

////////////////////////////////////////////////////////////////////////////////////
Static Function _fVlDlg(_cTipo,_xConteudo)
////////////////////////////////////////////////////////////////////////////////////
Local CPNUM,x_Barra,x_OP
Local _lRet	 := .t. 
Local _nX    := 0

IF ( lBrowse )
	lBrowse := .F.
	Return
ENDIF
	
Do Case
	Case Upper(Alltrim(_cTipo)) == "OP"

		If ( !Empty(_xConteudo) )
		
			_xConteudo := RTRIM(_xConteudo)+"001"
			
			DbSelectArea("SC2")
			DbSetOrder(1)                                      ///C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD
			dbSeek(xFilial("SC2")+_xConteudo)
			If !EOF()	
				IF ( SC2->C2_TPOP == "P" )
					MsgStop("Esta Ordem de Produção se encontra Prevista.","Não permitido")
					Return(.F.)
				ENDIF
								
				IF ( mOP <> _xConteudo )
					////
					////Extrai componentes da OP selecionada
					////
					aEmpenho := {SPACE(130)}
					dbSelectArea("SD4")
					dbSetOrder(2)
					dbSeek(xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,.T.)
					Do While !Eof() .And. D4_FILIAL+RTRIM(D4_OP) == xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
						
						SB1->(dbSeek(xFilial("SB1")+SD4->D4_COD))

						AADD(aEmpenho , SD4->D4_COD           + ;
											 SPACE(30)             + ;
											 LEFT(SB1->B1_DESC,70) + ;
											 SB1->B1_TIPO          + ;
											 SB1->B1_UM            + ;
											 STRZERO(SD4->D4_QTDEORI*100,12) + ;
											 SD4->D4_LOCAL )
						
						dbSkip()
					EndDo
					
					mOP   := _xConteudo
					cPrd  := Space(130)
					cDesc := SPACE(70)
					cTipo := SPACE(2)
					cUM   := SPACE(2)		
					
					lBrowse := .T.
					oPrd:SetItems(aEmpenho) 
					
					oPrd:SetFocus()
					
				ENDIF
				oProduto:Hide()
				oPrd:Show()

			Else
				MsgStop("Ordem de Produção NÃO Encontrada!","Atenção")
				_lRet := .f.
			EndIf
			
		Else

			IF  ( oPrd:lActive )    ///( !oProduto:lActive )
				cProduto := SPACE(30)
				cDesc    := SPACE(70)
				cTipo    := SPACE(2)
				cUM      := SPACE(2)		
				cAlmox   := SPACE(2)
				oPrd:Hide()
				//////lBrowse := .T.
				oProduto:Show()
			ENDIF
			oProduto:SetFocus()
			
		EndIf

	Case Upper(Alltrim(_cTipo)) == "PROD"                               ////Quando nao houver OP informada, digita o codigo do produto para consistencia

		IF ( !EMPTY(_xConteudo) )
			
			SB1->(dbSeek(xFilial("SB1")+_xConteudo))
			
			IF ( SB1->(EOF()) )
				MsgStop("Produto não cadastrado.","Atenção")
				Return(.F.)
			ELSE
				cDesc    := SUBS(SB1->B1_DESC,1,70)
				cTipo    := SB1->B1_TIPO
				cUM      := SB1->B1_UM
				cAlmox   := mvLocPad
				
				SB2->(dbSeek(xFilial("SB2")+_xConteudo+mvLocPad))
				
				nCusto := SB2->B2_CM1
				
			ENDIF

		ELSE
			cDesc  := SPACE(70)
			cTipo  := SPACE(2)
			cUM    := SPACE(2)		
			cAlmox := SPACE(2)
			nQuant := 0
			nCusto := 0

		ENDIF	
		
		lEmProcesso := !EMPTY(_xConteudo)
		
	Case Upper(Alltrim(_cTipo)) == "PRODD"                            /////Quando for transferencia entre produtos, digita produto destino para consistencia

		IF ( !EMPTY(cProdDest) )
			
			SB1->(dbSeek(xFilial("SB1")+cProdDest))
			
			IF ( SB1->(EOF()) )
				MsgStop("Produto não cadastrado.","Atenção")		
				Return(.F.)
			ELSEIF ( cProduto == cProdDest )
				MsgStop("Não é permitido transferencia para o mesmo codigo de origem.","Atenção")
				Return(.F.)
			ENDIF

		ENDIF	
		
	Case Upper(Alltrim(_cTipo)) == "PRD"                              ////Quando houver OP, seleciona pelo combobox
	
		IF ( EMPTY(_xConteudo) )
			cProduto := SPACE(30)
			cDesc    := SPACE(70)
			cTipo    := SPACE(2)
			cUM      := SPACE(2)
			cAlmox   := SPACE(2)
			nQuant   := 0
			nQtdOri  := 0
			nCusto   := 0
						
		ELSE
			cProduto := SUBS(_xConteudo,1,30)
			cDesc    := SUBS(_xConteudo,61,70)
			cTipo    := SUBS(_xConteudo,131,2)
			cUM      := SUBS(_xConteudo,133,2)
			cAlmox   := SUBS(_xConteudo,147,2)
			nQtdOri  := ( VAL(SUBS(_xConteudo,135,12)) / 12 )
			
			lBrowse := .T.
			oProduto:SetFocus()
			
		ENDIF

		SB2->(dbSeek(xFilial("SB2")+cProduto+cAlmox))
		
		nCusto := SB2->B2_CM1
		
		lEmProcesso := !EMPTY(_xConteudo)
		
	Case Upper(Alltrim(_cTipo)) == "QTDE"                                         ////Check da quantidade informada

		IF ( _xConteudo <> 0 )
  	      ///aSaldo := CalcEst(cProduto,mvLocPad)
			
			IF ( _xConteudo < 0 )
				MsgStop("Quantidade invalida para movimentação.","Valor Negativo")
				Return(.F.)
			ENDIF
			
			IF ( nTpMov <> 8 .AND. EMPTY(cAlmox) )
				MsgStop("Falta informar o Almoxarifado.","Atenção")
				Return(.F.)
			ENDIF
			
			SB2->(dbSeek(xFilial("SB2")+cProduto+IIF(nTpMov==8,"60",cAlmox)))
		  			
		   IF ( nTipoM == 2 .AND. SB2->B2_QATU < _xConteudo )
			   MsgStop("Saldo insuficiente em estoque para atender esta requisição.","Atenção")
			   Return(.F.)
		   ENDIF		  
			
			nCusto := SB2->B2_CM1

		ENDIF	

	Case Upper(Alltrim(_cTipo)) == "ALMX"

		SB2->(dbSeek(xFilial("SB2")+cProduto+_xConteudo))
		
		nCusto := SB2->B2_CM1
		
		oCusto:Refresh()
	
	Case Upper(Alltrim(_cTipo)) == "SOLIC"
		
		cSSolic := IIF( !EMPTY(_xConteudo) , _xConteudo , cANome )
		
		oTBitmap5:Show()
		oTBitmap6:Show()
		oSGSolic:Disable()
		oTipoM:Enable()
		oTpMov:Enable()
		oEmissao:Enable()
		oProduto:Enable()
		oAlmox:Enable()
		oQuant:Enable()
		oMotivo:Enable()	
		oSGSolic:Refresh()
		oEmissao:SetFocus()

	Case Upper(Alltrim(_cTipo)) == "TMOV1"                                           ////Seleciona o Movimento: Entrada - Saida
	
		IF ( oDocumen:lActive )                ///lVisible
			nCusto   := 0
			cDocumen := Space(9)
			cDocumen	:= IIf(Empty(cDocumen),NextNumero("SD3",2,"D3_DOC",.T.),cDocumen)
			cDocumen	:= A261RetINV(cDocumen)				
			oDocumen:Disable()
			oDocumen:Refresh()
			oCusto:Refresh()
		ENDIF

		IF ( oCusto:lActive )
			oCusto:Disable()
		ENDIF

		IF ( oCodOri:lActive )                ///lVisible
			oCodOri:Hide()
			oProdOri:Hide()
			oCodDest:Hide()
			oProdDest:Hide()
			oCodigo:Show()
			oNumOP:Show()
			//lBrowse := .T.
			oProduto:Show()
			//lBrowse := .T.
			oOP:Show()
			
			cProdDest := Space(30)
		ENDIF				
		
	   //lBrowse := .T.
		nTpMov  := 1
		aTpMov  := IIF(_xConteudo == 1 , ACLONE(aTpMovE) , ACLONE(aTpMovS) )
		oTpMov:aItems := ACLONE(aTpMov)
	   oTpMov:SetOption(nTpMov)
		IF ( _xConteudo == 2 )
			IF ( mvLocPad == "01" )
				oTpMov:EnableItem( 8, .F. )
			ELSEIF ( cAutoriza == "R" )
				oTpMov:EnableItem( 6, .F. )
				oTpMov:EnableItem( 7, .F. )
				oTpMov:EnableItem( 8, .F. )
			ENDIF	
		ENDIF	
		
	   //lBrowse := .T.
		//oEmissao:SetFocus()
		//_fVlDlg("TMOV2",nTpMov)
		oTpMov:Refresh()
		oTpMov:SetFocus()
		
	Case Upper(Alltrim(_cTipo)) == "TMOV2"                                           ////Selecionando o tipo do movimento
	
		IF ( oDocumen:lActive )                ///lVisible
			nCusto   := 0
			cDocumen := Space(9)
			cDocumen	:= IIf(Empty(cDocumen),NextNumero("SD3",2,"D3_DOC",.T.),cDocumen)
			cDocumen	:= A261RetINV(cDocumen)				
			oDocumen:Disable()
			oDocumen:Refresh()
			oCusto:Refresh()
		ENDIF
	
		IF ( nTipoM == 2 .AND. _xConteudo == 5 )
			oCodigo:Hide()
			oPrd:Hide()
			oProduto:Hide()
			oNumOP:Hide()
			oOP:Hide()
			oCodOri:Show()
			oProdOri:Show()
			oCodDest:Show()
			oProdDest:Show()
		ELSE	
			IF ( oCodOri:lActive )                ///lVisible
				oCodOri:Hide()
				oProdOri:Hide()
				oCodDest:Hide()
				oProdDest:Hide()
				oCodigo:Show()
				oNumOP:Show()
				lBrowse := .T.
				oProduto:Show()
				lBrowse := .T.
				oOP:Show()
				
				cProdDest := Space(30)
			ENDIF	
			IF ( nTipoM == 1 )
				IF ( _xConteudo == 4 )
					oCusto:Enable()
					lBrowse := .T.
				ELSEIF ( oCusto:lActive )
					oCusto:Disable()
				ENDIF
			
			ELSE
				IF ( _xConteudo == 8 )
					IF ( !EMPTY(aCols[1,3]) .AND. LEFT(cDocumen,3) <> "NFD" )
						Return(.F.)
					ENDIF
					cDocumen := "NFD      "
					cProduto := SPACE(30)
					cDesc    := SPACE(70)
					cTipo    := SPACE(2)
					cUM      := SPACE(2)
					cAlmox   := SPACE(2)
					nQuant   := 0
					nQtdOri  := 0
					nCusto   := 0
					oDocumen:Enable()
					oDocumen:Refresh()
					oDocumen:SetFocus()
					lBrowse := .T.
					Return
				ENDIF
				lBrowse  := .T.
				IF ( !STR(_xConteudo,1) $ "234" )
					cOP      := SPACE(8)		
					mOP      := cOP
					aEmpenho := {SPACE(130)}
					oPrd:SetItems(aEmpenho) 
					oOP:Disable()
					oPrd:Hide()
					lBrowse := .T.
					oProduto:Show()
				ELSE
					oOP:Enable()
				ENDIF
			ENDIF
		ENDIF

		oEmissao:SetFocus()

	Case Upper(Alltrim(_cTipo)) == "DOCTO"
		IF ( LEN(RTRIM(_xConteudo)) < 9 .OR. LEFT(_xConteudo,3) <> "NFD" )
			MsgStop("Favor informar: NFD + os ultimos 6 digitos da Nota Fiscal.","Atenção")
			Return
		ENDIF
		
	Case Upper(Alltrim(_cTipo)) == "MATR"
	
		IF ( !EMPTY(_xConteudo) )
			x_Barra    := SUBS(_xConteudo,1,1)+SUBS(_xConteudo,8,1)
			_xConteudo := IIF(x_Barra == "99" , SUBSTRING(_xConteudo,2,6) , STRZERO( VAL(ALLTRIM(_xConteudo)) , 6 ) )

			dbSelectArea("SRA")
			dbSetOrder(1)
			dbSeek(xFilial("SRA")+_xConteudo)
			IF ( SRA->(EOF()) )
				MsgStop("Matrícula não existe no Cadastro de Funcionários.","Atenção")
				Return(.F.)
			ENDIF
			_xConteudo := STRZERO( VAL(ALLTRIM(_xConteudo)) , 6 )
			dbSelectArea("SX5")
			dbSetOrder(1)
			dbSeek(xFilial("SX5")+"Z@"+_xConteudo)
			IF ( SX5->(EOF()) )
				IF ( x_Barra <> "99" )
					MsgStop("Erro de leitura no Codigo de Barras do Crachá.")
				ELSE	
					MsgStop("Usuário não autorizado para executar esta rotina. Solicitar cadastramento.","Atenção")
				ENDIF	
				_lRet := .f.	
			ELSE
				cANome    := SUBS(SX5->X5_DESCRI,29,10)
				cUsuario  := cANome
				cMatric   := _xConteudo
				cAutoriza := SUBS(SX5->X5_DESCRI,5,1)     ///Tipo de operação a ser executada: R=Baixa Almoxarifado; P=Consulta Alter.PV; T=R+P; W=T+Estorno Apt.; Z=Tudo (Admin)
				cOpcoes   := SUBS(SX5->X5_DESCRI,14,15)   ///Pos.1=Mov.Entrada;Pos.2=Mov.Saida;Pos.3=Sep.Mat.;Pos.4=Apont.Prod.;Pos.5=Estorno Prod.;Pos.6=Apont.Embalagem
				cOpcoes   := LEFT(cOpcoes,2)
				IF ( cOpcoes $ "NN" )
					MsgStop(OemToAnsi("Usuário ")+RTRIM(cANome)+OemToAnsi(" sem permissão para executar esta rotina."),OemToAnsi("Atenção"))
					Return(.F.)
				ENDIF
			
				cAUser  := PADR(_xConteudo,8)
				cAPassw := SUBSTRING(SX5->X5_DESCRI,8,4)
				cAPassw := Embaralha(cAPassw,1)
				cSenAtu := cAPassw
				cASenha := IIF(lAdmin , cAPassw , SPACE(4) )
				oAGSenha:SetFocus()
			ENDIF
		ENDIF

	Case Upper(Alltrim(_cTipo)) == "APASSW"
		
		IF ( !EMPTY(_xConteudo) )
			IF ( _xConteudo <> cAPassw )
				MsgStop(OemToAnsi("Usuário ")+RTRIM(cANome)+OemToAnsi(" sem permissão para executar esta rotina."),OemToAnsi("Senha Não Confere!"))
				_lRet := .f.
			ELSE
				IF ( cAPassw == SUBS(cAUser,3,4) )
				
					IF ( ! U_CPWD770(.F.,cMatric,cUsuario,1) )               ////Obriga o usuario a alterar a senha inicial criada pelo Administrador (senha = matricula)
						cASenha := SPACE(4)
						oAGSenha:Refresh()
						oAGUser:SetFocus()
						Return(.F.)
					ENDIF
					
				ENDIF
				///
				///Nro. do documento 
				///
				cItem    := "0001"
				cDocumen := Space(9)
				cDocumen	:= IIf(Empty(cDocumen),NextNumero("SD3",2,"D3_DOC",.T.),cDocumen)
				cDocumen	:= A261RetINV(cDocumen)	
				
				f_show()
				
				IF ( SUBS(cOpcoes,1,1) == "N" )                                                     ///Movimento Interno - Entrada
					oTipoM:EnableItem( 1, .F. )
					nTipoM  := 2
					nTpMov  := 1
					aTpMov  := ACLONE(aTpMovS)
					oTpMov:aItems := ACLONE(aTpMov)
					oTpMov:SetOption(nTpMov)
					IF ( mvLocPad == "01" )
						oTpMov:EnableItem( 8, .F. )
					ELSEIF ( cAutoriza == "R" )
						oTpMov:EnableItem( 6, .F. )
						oTpMov:EnableItem( 7, .F. )
						oTpMov:EnableItem( 8, .F. )
					ENDIF	
					_fVlDlg("TMOV2",nTpMov)
					oTpMov:Refresh()
				ENDIF
				IF ( SUBS(cOpcoes,2,1) == "N" )                                                     ///Movimento Interno - Saida
					oTipoM:EnableItem( 2, .F. )
				ENDIF
				oDocumen:Refresh()				
				oTipoM:Disable()
				oTpMov:Disable()
				oEmissao:Disable()
				oOP:Disable()
				oProduto:Disable()
				oAlmox:Disable()
				oQuant:Disable()
				oMotivo:Disable()		
				
				oAGUser:Disable()
				oAGSenha:Disable()
				oSGSolic:SetFocus()
				
				lSenha := .T.

			ENDIF
		ENDIF
		
EndCase

Return(_lRet)

***************************
Static Function ValidPerg()
***************************
Local aRegs
Local i,j

DbSelectArea("SX1")
DbSetOrder(1)
aRegs :={} //Grupo|Ordem| Pegunt                         | perspa | pereng | VariaVL  | tipo| Tamanho|Decimal| Presel| GSC | Valid         |   var01   | Def01              | DefSPA1 | DefEng1 | CNT01 | var02 | Def02           | DefSPA2 | DefEng2 | CNT02 | var03 | Def03           | DefSPA3 | DefEng3 | CNT03 | var04 | Def04      | DefSPA4 | DefEng4 | CNT04 | var05 | Def05 | DefSPA5 | DefEng5 | CNT05 | F3    | GRPSX5 |
aAdd(aRegs,{ cPerg,"01" , "Da Data de Emissão          ?",   ""   ,  ""    , "mv_ch1" , "D" ,   08   ,   0   ,   0   , "G" , "          "  , "mv_par01", "                " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "        " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
aAdd(aRegs,{ cPerg,"02" , "Até a Data de Emissão       ?",   ""   ,  ""    , "mv_ch2" , "D" ,   08   ,   0   ,   0   , "G" , "          "  , "mv_par02", "                " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "        " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
aAdd(aRegs,{ cPerg,"03" , "Do Documento                ?",   ""   ,  ""    , "mv_ch3" , "C" ,   09   ,   0   ,   0   , "G" , "          "  , "mv_par03", "                " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "        " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
aAdd(aRegs,{ cPerg,"04" , "Até o Documento             ?",   ""   ,  ""    , "mv_ch4" , "C" ,   09   ,   0   ,   0   , "G" , "          "  , "mv_par04", "                " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "        " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
aAdd(aRegs,{ cPerg,"05" , "Do Produto                  ?",   ""   ,  ""    , "mv_ch5" , "C" ,   30   ,   0   ,   0   , "G" , "          "  , "mv_par05", "                " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "        " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "SB1" , "    " })
aAdd(aRegs,{ cPerg,"06" , "Até o Produto               ?",   ""   ,  ""    , "mv_ch6" , "C" ,   30   ,   0   ,   0   , "G" , "          "  , "mv_par06", "                " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "        " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "SB1" , "    " })

For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function CPWD770(lAdmin,cMatric,cUsuario,nOpcB)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local osDlg,oGroup1,oGroup2,oGroup3,oMatr,oUser,oSenha1,oSenha2,oSenha3,oButton1,oButton2
Local oSenAtu,oSenNew,oSenConf
Local cDig,cTexto,cCredenc
Local nX,nLenP
Local lRsp     := .T.
Local lTrue    := .T.
Local nOpc     := 0
Local nSeq     := 0
Local aBaixa   := {"Parcial","Total"}
Local cSenAtu  := IIF(nOpcB==0 , SPACE(4) , cAPassw )
Local cSenNew  := SPACE(4)
Local cSenConf := SPACE(4)

Private oMatric,oUsuario,oProcesso,oBaixa
Private oCheck1,oCheck2,oCheck3,oCheck4,oCheck5,oCheck6
Private lCheck1 := lCheck2 := lCheck3 := lCheck4 := lCheck5 := lCheck6 := lCheck7 := lCheck8 := .F.
Private nBaixa  := 1
Private nOpcao  := 2            ///0=Novo usuario;1=Altera Credencial do usuario;2=Alterar senha

DEFAULT lAdmin  := .T.

IF ( lAdmin )
	cMatric  := SPACE(6)
	cUsuario := SPACE(10)
ENDIF

DO WHILE lTrue

	DEFINE MSDIALOG osDlg TITLE ":::... SENHAS ...:::" FROM 000, 000  TO 370, 472 COLORS 0, 16777215 PIXEL

	oTBar := TBar():New( osDlg,40,25,.T.,,,,.F. )   

	@  0, -25 BITMAP oBmp RESNAME "PROJETOAP" oF osDlg SIZE 55, 1000 NOBORDER WHEN .F. PIXEL
	
	@ 025, 033 GROUP oGroup1 TO 165, 233 PROMPT ""                               	                        OF osDlg COLOR  0, 16777215 PIXEL
	@ 029, 037 SAY   oMatr               PROMPT "Matrícula"                    	          SIZE 050, 010 OF osDlg COLORS 0, 16777215 PIXEL FONT oFnt3
	@ 045, 037 SAY   oUser               PROMPT "Nome do Usuário"              	          SIZE 090, 010 OF osDlg COLORS 0, 16777215 PIXEL FONT oFnt3
	@ 061, 037 SAY   oSenha1             PROMPT "Senha Atual"                  	          SIZE 060, 010 OF osDlg COLOR CLR_HBLUE    PIXEL FONT oFnt3
	@ 077, 037 SAY   oSenha2             PROMPT "Nova Senha"                   	          SIZE 060, 010 OF osDlg COLOR CLR_HBLUE    PIXEL FONT oFnt3
	@ 075, 091 SAY   oAster01            PROMPT "*"                            	          SIZE 004, 006 OF osDlg COLOR CLR_HRED     PIXEL FONT oFnt3
	@ 093, 037 SAY   oSenha3             PROMPT "Confirmar Nova Senha"         	          SIZE 120, 010 OF osDlg COLOR CLR_HBLUE    PIXEL FONT oFnt
	@ 090, 125 SAY   oAster02            PROMPT "*"                            	          SIZE 004, 006 OF osDlg COLOR CLR_HRED     PIXEL FONT oFnt3
	@ 029, 139 MSGET oMatric             VAR    cMatric      Picture "@R 999999"	          SIZE 050, 010 OF osDlg COLORS 0, 16777215 PIXEL FONT oFnt3 VALID f_matric(cMatric,@cUsuario)
	@ 045, 139 MSGET oUsuario            VAR    cUsuario		Picture "@!"		 	          SIZE 090, 010 OF osDlg COLORS 0, 16777215 PIXEL FONT oFnt3
	@ 061, 139 MSGET oSenAtu             VAR    cSenAtu		Picture "@R 9999" 	PASSWORD  SIZE 050, 010 OF osDlg COLORS 0, 16777215 PIXEL FONT oFnt3 WHEN nOpcB==0
	@ 077, 139 MSGET oSenNew             VAR    cSenNew 		Picture "@R 9999" 	PASSWORD  SIZE 050, 010 OF osDlg COLORS 0, 16777215 PIXEL FONT oFnt3
	@ 093, 139 MSGET oSenConf            VAR    cSenConf 	   Picture "@R 9999" 	PASSWORD  SIZE 050, 010 OF osDlg COLORS 0, 16777215 PIXEL FONT oFnt3
	 
	@ 168, 090 BUTTON oButton1 PROMPT "Finalizar" SIZE 060, 014 OF osDlg PIXEL FONT oFnt3 Action (nOpc := 1 , osDlg:End() )
	@ 168, 166 BUTTON oButton2 PROMPT "Cancelar"  SIZE 060, 014 OF osDlg PIXEL FONT oFnt3 Action (nOpc := 2 , lTrue := .F. , osDlg:End() )

	IF ( !lAdmin )
		@ 013, 034 SAY   oProcesso PROMPT "Alterar Senha"  SIZE 100, 010 OF osDlg COLORS 0, 16777215 PIXEL FONT oFnt3
		@ 110, 037 GROUP oGroup2 TO 161, 230 PROMPT "(*)"                                                                                OF osDlg COLOR  CLR_HRED    PIXEL
		@ 117, 040 SAY   oCrit01             PROMPT "- A senha não pode ser sequencial (Ex.: 123... 6789...)."                      SIZE 360, 010 OF osDlg COLORS 0, 16777215 PIXEL
		@ 125, 040 SAY   oCrit02             PROMPT "- A senha não pode ter mais que 2 digitos repetidos (Ex.: 111... 555...)."     SIZE 360, 010 OF osDlg COLORS 0, 16777215 PIXEL
		@ 133, 040 SAY   oCrit03             PROMPT "- A senha não pode ser igual a matrícula do funcionário.)"                     SIZE 360, 010 OF osDlg COLORS 0, 16777215 PIXEL
		@ 141, 040 SAY   oCrit04             PROMPT "- A senha não pode ter menos que 4 dígitos (Ex.: 47  ; 652)."                  SIZE 360, 010 OF osDlg COLORS 0, 16777215 PIXEL
		
		oMatric:Disable()
		oUsuario:Disable()
		
	ELSE
		oAster01:Hide()
		oAster02:Hide()
		oSenha1:Hide()
		oSenha2:Hide()
		oSenha3:Hide()
		oSenAtu:Hide()
		oSenNew:Hide()
		oSenConf:Hide()

		@ 013, 034 SAY      oProcesso           PROMPT "Incluir Usuário"  SIZE 100, 010 OF osDlg COLORS 0, 16777215 PIXEL FONT oFnt3
		@ 061, 037 GROUP    oGroup2 TO 163, 230 PROMPT "ROTINAS"                        OF osDlg COLOR  0, 16777215 PIXEL
		@ 140, 040 GROUP    oGroup3 TO 160, 130 PROMPT "(*)"                            OF osDlg COLOR  CLR_HRED    PIXEL
		oCheck1 := TCheckBox():New(068,040,'Mov.Interno - Entrada'      , {|u1|if(PCount()>0,lCheck1:=u1,lCheck1)},osDlg, 100,007,,,,,,,,.T.,,,)	
		oCheck2 := TCheckBox():New(077,040,'Mov.Interno - Saída'        , {|u2|if(PCount()>0,lCheck2:=u2,lCheck2)},osDlg, 100,007,,,,,,,,.T.,,,)	
		@ 075, 096 SAY      oAster01            PROMPT "*"            	   SIZE 004, 006 OF osDlg COLOR CLR_HRED     PIXEL FONT oFnt3
		oCheck3 := TCheckBox():New(086,040,'Separação Material'         , {|u3|if(PCount()>0,lCheck3:=u3,lCheck3)},osDlg, 100,007,,,,,,,,.T.,,,)	
		oCheck4 := TCheckBox():New(095,040,'Apontamento Produção'       , {|u4|if(PCount()>0,lCheck4:=u4,lCheck4)},osDlg, 100,007,,,,,,,,.T.,,,)	
		oCheck5 := TCheckBox():New(104,040,'Estorno Apont.Produção'     , {|u5|if(PCount()>0,lCheck5:=u5,lCheck5)},osDlg, 100,007,,,,,,,,.T.,,,)	
		oCheck6 := TCheckBox():New(113,040,'Etiqueta Embalagem Produção', {|u6|if(PCount()>0,lCheck6:=u6,lCheck6)},osDlg, 100,007,,,,,,,,.T.,,,)	
		oCheck7 := TCheckBox():New(122,040,'Solicitação de Conserto'    , {|u7|if(PCount()>0,lCheck7:=u7,lCheck7)},osDlg, 100,007,,,,,,,,.T.,,,)	
		oCheck8 := TCheckBox():New(131,040,'Baixa Solic. de Conserto'   , {|u8|if(PCount()>0,lCheck8:=u8,lCheck8)},osDlg, 100,007,,,,,,,,.T.,,,)	

		oBaixa := TRadMenu():New (148,044,aBaixa,,osDlg,,,,,,,,090,020,,,,.T.)
		oBaixa:bSetGet := {|ub|Iif (PCount()==0,nBaixa,nBaixa:=ub)} 
		oBaixa:lHoriz  := .T.
		
	ENDIF

	ACTIVATE MSDIALOG osDlg CENTERED VALID nOpc <> 0

	IF ( nOpc == 1 )
		IF ( EMPTY(cMatric) )
			MsgStop("Falta informar a Matricula do Funcionario.","Atenção")
		ELSEIF ( EMPTY(cUsuario) )
			MsgStop("Falta informar o Nome do Funcionario.","Atenção")
		ELSE
			lTrue := .F.
			IF ( nOpcao == 0 )
				cSenConf := RIGHT(cMatric,4)
				lTrue    := .F.			
			ELSEIF ( nOpcao == 2 )
				IF ( nOpcB == 0 )
					cPassword := Embaralha(LEFT(SRA->RA_SENHA,4),1)
					lTrue     := !( cPassword == cSenAtu )
				ENDIF	
				cSenConf := IIF(lTrue , "SENA" , cSenConf )
				IF ( cSenConf <> "SENA" )
					nLenP	:= Len(RTRIM(cSenConf))
					IF ( nLenP < 4 )
						cSenConf := "SIZE"
					EndIF
					IF ( cSenConf <> "SIZE" )
						aSenhas := {}
						For nX := 1 TO nLenP
							cDig := SubStr( cSenConf , nX , 1 )
							IF ( Empty( StrTran(cSenConf,cDig,"") ) ) 
								cSenConf := "EQUA"
								Exit
							EndIF
							AADD(aSenhas , VAL(cDig) )
						Next
						IF ( cSenConf <> "EQUA" )
							For nX := nLenP TO 1 STEP -1
								IF ( nX > 2 )
									IF ( Empty( StrTran(Substring(cSenConf,(nX-2),3),Str(aSenhas[nX],1),"") ) ) 
										cSenConf := "EQUA"
										Exit
									EndIF
								ENDIF
							Next	
							IF ( cSenConf <> "EQUA" )
								nX := 0
								IF ( aSenhas[1] < aSenhas[2] )
									aEval( aSenhas , { |x,y| IIF( ( y == 1 ) .or. ( ( x - nX ) <>  1 ) , nX := x , ( ++nSeq , nX := x ) ) } )
								Else
									aEval( aSenhas , { |x,y| IIF( ( y == 1 ) .or. ( ( x - nX ) <> -1 ) , nX := x , ( ++nSeq , nX := x ) ) } )
								EndIF
								IF ( nSeq == (nLenP - 1) )
									cSenConf := "SEQU"				
								ELSEIF ( cSenConf == RIGHT(cMatric,4) )
									cSenConf := "MATR"
								EndIF
							ENDIF	
						EndIF
					EndIF
				ENDIF
				
				lTrue := ( cSenConf $ "SENA/EQUA/SIZE/MATR/SEQU" ) 
				
				IF ( !lTrue .AND. cSenConf <> cSenNew )
					cSenConf := "DIFE"
					lTrue    := .T.
				ENDIF	
			ENDIF
			IF ( !lTrue )
				IF ( nOpcao <> 1 )
					dbSelectArea("SRA")
					IF ( ! RecLock("SRA",.F.) )
						MsgStop("No momento, não é possível gravar a nova senha. Tente mais tarde.","Atenção")
					ELSE	
						SRA->RA_SENHA := Embaralha(cSenConf,0)
					ENDIF
					MsUnlock()
	
					dbSelectArea("SX5")
					dbSetOrder(1)
					dbSeek(xFilial("SX5")+"Z@"+cMatric)	
					IF ( SX5->(EOF()) )
						RecLock("SX5",.T.)
						SX5->X5_FILIAL := xFilial("SX5")
						SX5->X5_TABELA := "Z@"
						SX5->X5_CHAVE  := cMatric
						cTexto         := "01"
					ELSE
						RecLock("SX5",.F.)
						cTexto := LEFT(SX5->X5_DESCRI,2)
					ENDIF
				ENDIF
				IF ( lAdmin )
					IF ( nOpcao == 1 )
						dbSelectArea("SX5")
						RecLock("SX5",.F.)
						cTexto := LEFT(SX5->X5_DESCRI,2)
					ENDIF
					cCredenc := IIF(lCheck1 , "S" , "N" )                   ///Movimento de Entrada
					cCredenc += IIF(lCheck2 , "S" , "N" )                   ///Movimento de Saida
					cCredenc += IIF(lCheck3 , "S" , "N" )                   ///Apontamento Sep.Materiais
					cCredenc += IIF(lCheck4 , "S" , "N" )                   ///Apontamento de Produção
					cCredenc += IIF(lCheck5 , "S" , "N" )                   ///Estorno de Apontamento de Produção
					cCredenc += IIF(lCheck6 , "S" , "N" )                   ///Etiqueta Embalagem de Produção
					cCredenc += IIF(lCheck7 , "S" , "N" )                   ///Solicitacao de conserto
					cCredenc += IIF(lCheck8 , "S" , "N" )                   ///Baixa da solicitacao de conserto
					cCredenc += "NNNNNNN"
					cTexto   += IIF(!lCheck3.AND.!lCheck4 , "00-00" , IIF(lCheck3.AND.lCheck4 , "01-08" , IIF(lCheck3 , "01-01" , "02-08") ) )
					cTexto   += Embaralha(cSenConf,0)
					cTexto   += "##"
					cTexto   += cCredenc
					cTexto   += cUsuario
					IF ( lCheck2 )
						cTexto := STUFF(cTexto,5,1,IIF(nBaixa==1 , "R" , "Z" ) )
					ENDIF	
					
					SX5->X5_DESCRI := cTexto
					
				ELSE
				
					SX5->X5_DESCRI := STUFF(SX5->X5_DESCRI , 8 , 4 , Embaralha(cSenConf,0) )
					
				ENDIF
				
				MsUnlock()
				
				dbCommitAll()
				
			ELSE
				IF ( cSenConf == "SENA" )
					MsgStop("Senha Atual inválida","Atenção")
				ELSEIF ( cSenConf == 'SEQU' )
					MsgStop("A Senha não pode conter mais que 2 digitos sequenciais.","Atenção")
				ELSEIF ( cSenConf == "DIFE" )
					MsgStop("Nova senha não bate com senha a confirmar.","Atenção")
				ELSEIF ( cSenConf == "EQUA" )
					MsgStop("Não pode existir mais de 2 digitos sequencial e iguais na senha.","Atenção")
				ElseIF ( cSenConf == "SIZE" )
					MsgStop("O número de caracteres da senha é menor que 4.","Atenção")	
				ElseIF ( cSenConf == "MATR" )
					MsgStop("A Senha não pode ser igual a Matricula.","Atenção")	
				EndIF
				cSenConf := SPACE(4)
			ENDIF
		ENDIF
	ENDIF
	
ENDDO

IF ( nOpcB == 0 )
	Return
ELSE	
	Return( IIF( nOpc==1 , .T. , .F. ) )
ENDIF
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_matric(mMatric,cUsuario)
/////////////////////////////////////////////////////////////////////////////////////////////////////////
Local nX
Local cCredenc
Local lRsp := .T.

IF ( !EMPTY(mMatric) )
	dbSelectArea("SRA")
	dbSetOrder(1)
	dbSeek(xFilial("SRA")+mMatric)
	IF ( SRA->(EOF()) )
		MsgStop("Matrícula não cadastrada.","Atenção")
		lRsp := .F.
	ELSE
		dbSelectArea("SX5")
		dbSetOrder(1)
		dbSeek(xFilial("SX5")+"Z@"+mMatric)
		IF ( SX5->(!EOF()) )
			cUsuario := SUBS(SX5->X5_DESCRI,29,10)
			cCredenc := SUBS(SX5->X5_DESCRI,14,15)
			lCheck1  := ( SUBS(cCredenc,1,1) == "S" )
			lCheck2  := ( SUBS(cCredenc,2,1) == "S" )
			lCheck3  := ( SUBS(cCredenc,3,1) == "S" )
			lCheck4  := ( SUBS(cCredenc,4,1) == "S" )
			lCheck5  := ( SUBS(cCredenc,5,1) == "S" )
			lCheck6  := ( SUBS(cCredenc,6,1) == "S" )
			lCheck7  := ( SUBS(cCredenc,7,1) == "S" )
			lCheck8  := ( SUBS(cCredenc,8,1) == "S" )
			nBaixa   := IIF(SUBS(SX5->X5_DESCRI,5,1)=="Z",2,1)
			nOpcao   := 1

			oUsuario:Disable()
			oMatric:Disable()
			oProcesso:cCaption := "Alterar Credenciais"
			oProcesso:Refresh()
			oCheck1:CtrlRefresh()
			oCheck2:CtrlRefresh()
			oCheck3:CtrlRefresh()
			oCheck4:CtrlRefresh()
			oCheck5:CtrlRefresh()
			oCheck6:CtrlRefresh()
			oCheck7:CtrlRefresh()
			oCheck8:CtrlRefresh()
			oBaixa:Refresh()
			
		ELSE	
			nX       := AT(" ",SRA->RA_NOME)
			cUsuario := PADR( LEFT(SRA->RA_NOME,(nX-1)) , 10 )
			nOpcao   := 0
		ENDIF	
		oUsuario:Refresh()
	ENDIF	
ENDIF

Return(lRsp)
