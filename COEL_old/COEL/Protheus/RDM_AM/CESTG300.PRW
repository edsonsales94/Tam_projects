/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFATG300  ³ Autor ³ Carlos Nina           ³ Data ³11/02/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emite etiqueta de embalagem de materiais - Almoxarifado    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Coelmatic/Manaus                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

User Function CESTG300()

Local   cArqTrab,cIndex,cKey
Local   aStru     := {}
Local   lInverte  := .F.
Local   cMarca    := GetMark()
Local   aCampos   := {}

Private oDlg,oLst,oMark,oSerie,oNFiscal,oEmissao,oEntrada,oFornece,oMunFor,oEstFor
Private oTBitmap1,oTBitmap2,oTBmp1,oTBmp2
Private oGroup1,oGroup2,oGroup3,oGroup4,oGroup5,oGroup6,oGroup7,oGroup8,oGroup9
Private oFnt,oFnt2,oFnt3,oFnt3a,oFnt4,oFnt5,oFnt6,oFnt7,oFnt8,oFnt9,oFnt9a,oFnt9b,oFont24b
Private cSerie,cNFiscal,dEmissao,dEntrada,cFornece,cInvoice,cMunFor,cEstFor
Private nQtdEmb,nQtdEtq,nEtqImp,nPrdImp,mQtdEtq,_nSaldo
Private _cProd,_cFamilia,_cModelo,_cPedido,_cItemPC,_cDesc
Private aItens,aLocaliz
Private lSair,lNFiscal

Private mvLocal  := IIF(M->cNumEmp=="0301","02","01")    
Private lLooping := .T.
Private oVd      := LoadBitmap( GetResources(), 'br_verde')
Private oVm      := LoadBitmap( GetResources(), 'br_vermelho')

DEFINE FONT oFnt   NAME "Arial" Size 10,17             ///LARG. X ALT.
DEFINE FONT oFnt2  NAME "Arial" Size 10,11
DEFINE FONT oFnt3  NAME "Arial" Size 10,12
DEFINE FONT oFnt3a NAME "Arial" Size 8,16
DEFINE FONT oFnt4  NAME "Arial" Size 10,34
DEFINE FONT oFnt4a NAME "Arial" Size 10,28
DEFINE FONT oFnt5  NAME "Arial" Size 14,72
DEFINE FONT oFnt6  NAME "Arial" Size 9,12
DEFINE FONT oFnt7  NAME "Arial" Size 16,74
DEFINE FONT oFnt8  NAME "Arial" Size 12,14
DEFINE FONT oFnt9  NAME "Arial" Size 16,48
DEFINE FONT oFnt9a NAME "Arial" Size 11,40   
DEFINE FONT oFnt9b NAME "Arial" Size 12,54  
DEFINE FONT oFnt4b NAME "Arial" SIZE 0,-20 BOLD	// "Times New Roman" Maior

oFont24b := TFont():New( "Arial",,24,,.t.,,,,,.f. )

dbSelectArea("CCH")
dbSetOrder(1)
dbSelectArea("SD1")
dbSetOrder(1)
dbSelectArea("SF1")
dbSetOrder(1)
dbSelectArea("SA2")
dbSetOrder(1)
dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SBE")
dbSetOrder(1)
dbSelectArea("SBF")
dbSetOrder(2)                   /////BF_FILIAL, BF_PRODUTO, BF_LOCAL, BF_LOTECTL, BF_NUMLOTE, BF_PRIOR, BF_LOCALIZ, BF_NUMSERI
dbSelectArea("SC7")
dbSetOrder(1)

AADD(aStru,{"TB_OK"      , "C" , 02 , 0 } )
AADD(aStru,{"TB_LOCALIZ" , "C" , 15 , 0 } )
AADD(aStru,{"TB_LOCAL"   , "C" , 02 , 0 } )
AADD(aStru,{"TB_PRODUTO" , "C" , 30 , 0 } )
AADD(aStru,{"TB_DESCRI"  , "C" , 30 , 0 } )
AADD(aStru,{"TB_QUANT"   , "N" , 11 , 0 } )
AADD(aStru,{"TB_DATA"    , "D" , 08 , 0 } )
cArqTrab := CriaTrab(aStru,.T.)
cIndex   := CriaTrab(NIL,.F.)
cKey     := 'TB_LOCALIZ'
dbUseArea(.T.,,cArqTrab,"TRB",.F.,.F.)
IndRegua("TRB",cIndex,cKey,,," Criando Indice ...   ")
*
aCampos:= {{ "TB_OK"       ,, ""             ,      } ,;			
			  { "TB_LOCALIZ"	,, "Localização"  ,"@!"  } ,;
			  { "TB_DESCRI"	,, "Descrição"    ,"@!"  } ,;			
			  { "TB_QUANT"		,, "Quantidade"   ,"@E 9999,999"} ,;			
			  { "TB_DATA"		,, "Data", } }

DO WHILE lLooping
	aItens   := { { "0" , SPACE(4) , SPACE(30) , 0 , SPACE(2) , SPACE(6) , SPACE(4) , SPACE(6) , SPACE(60) , 0 , 0 , 0 } }
	aEnder   := { { SPACE(2) , SPACE(15) , SPACE(30) , 0 , SPACE(8) } }
	cSerie   := SPACE(3)
	cNFiscal := SPACE(9)
	mSerie   := SPACE(3)
	mNFiscal := SPACE(9)
	dEmissao := SPACE(8)
	dEntrada := SPACE(8)
	cFornece := SPACE(40)
	cMunFor  := SPACE(20)
	cEstFor  := SPACE(2)
	cInvoice := SPACE(13)
	cLocaliz := SPACE(15)
	cDescLcz := " "
	cNReduz  := " "
	_cItem   := " "
	_cDesc   := " "
	_cUM     := " "
	cCodPro  := Space(30)
	mCodPro  := cCodPro
	cDescric := Space(60)
	c_UM     := Space(2)
	c_Tipo   := Space(2)	
	nSdoEst  := 0
	nEstDisp := 0
	nEstEmp  := 0
	nQtdEmb  := 0
	nQtdEtq  := 0
	nEtqImp  := 0
	nPrdImp  := 0
	_nSaldo  := 0
	nOpcA    := 0
	lNFiscal := .F.
	lSair    := .F.
	
	dbSelectArea("TRB")
	
	DEFINE MSDIALOG oDlg TITLE ":::... ETIQUETA DE IDENTIFICAÇÃO DE MATERIAIS ...:::" FROM 000, 000  TO 508, 1010 COLORS 0, 16777215 PIXEL

	oTBar := TBar():New( oDlg,40,25,.T.,,,'tbar_coel',.F. )   

   @ 016, 002 GROUP oGroup1 TO 090, 261 PROMPT "NOTA FISCAL DE ENTRADA" 		  	                    OF oDlg COLOR 0, 16777215 PIXEL   
   @ 092, 002 GROUP oGroup2 TO 252, 261 PROMPT "ITENS DA NOTA FISCAL"   		  	                    OF oDlg COLOR 0, 16777215 PIXEL   
   @ 100, 263 GROUP oGroup3 TO 252, 504 PROMPT "LOCALIZAÇÃO ATUAL DO MATERIAL"  	                    OF oDlg COLOR 0, 16777215 PIXEL

   @ 024, 005 SAY   	oPref        PROMPT OemToAnsi("Série")            					   SIZE 025, 007 OF oDlg COLOR CLR_BLUE     PIXEL
   @ 024, 035 SAY   	oNF          PROMPT OemToAnsi("Número")           					   SIZE 025, 007 OF oDlg COLOR CLR_BLUE     PIXEL
   @ 031, 005 MSGET 	oSerie       VAR cSerie       						  						SIZE 015, 010 OF oDlg COLORS 0, 16777215 PIXEL                   		  WHEN !lNFiscal
   @ 031, 035 MSGET 	oNFiscal     VAR cNFiscal     						  						SIZE 045, 010 OF oDlg COLORS 0, 16777215 PIXEL VALID f_nfiscal(cMarca) WHEN !lNFiscal
   @ 024, 086 SAY   	oRazSoc      PROMPT OemToAnsi("Razão Social do Fornecedor")   	   SIZE 085, 007 OF oDlg COLORS 0, 16777215 PIXEL
   @ 031, 086 MSGET 	oFornece     VAR cFornece     						  					   SIZE 140, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
   @ 046, 005 SAY   	oDEmiss      PROMPT OemToAnsi("Data de Emissão")  					   SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL  
   @ 053, 005 MSGET 	oEmissao     VAR dEmissao     						  						SIZE 045, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
   @ 046, 065 SAY   	oDEntr       PROMPT OemToAnsi("Data de Entrada")  					   SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL  
   @ 053, 065 MSGET 	oEntrada     VAR dEntrada     						  						SIZE 045, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
   @ 046, 130 SAY   	oDI          PROMPT OemToAnsi("D.I.")             					   SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL  
   @ 053, 130 MSGET 	oInvoice     VAR cInvoice              	            				SIZE 065, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
   @ 068, 005 SAY   	oMun         PROMPT OemToAnsi("Municipio")        						SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
   @ 075, 005 MSGET 	oMunFor      VAR cMunFor      						  						SIZE 110, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
   @ 068, 130 SAY    oUF          PROMPT OemToAnsi("UF") 										SIZE 015, 007 OF oDlg COLORS 0, 16777215 PIXEL
   @ 075, 130 MSGET 	oEstFor      VAR cEstFor      						  						SIZE 015, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

	oLst := TCBrowse():New( 099 , 004, 255, 149,,{"","ITEM","PRODUTO","QUANT.","U.M","PEDIDO","ITEM-PC","SEQUENCIAL"},{20,20,30,30,20,30,30,20},oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	

	oLst:SetArray(aItens)
	oLst:bChange := { || f_descpro(oLst:nAt,cMarca,1) }  
	oLst:bLine   := { || { IIF(aItens[oLst:nAt,1]=="1",oVd,oVm) , ;
								  aItens[oLst:nAt,2]  , ;
							     aItens[oLst:nAt,3]  , ;
								  aItens[oLst:nAt,4]  , ;
							     aItens[oLst:nAt,5]  , ;
								  aItens[oLst:nAt,6]  , ;
								  aItens[oLst:nAt,7]  , ;
							     aItens[oLst:nAt,8] } }
								
	oLst:lAdjustColsize := .F.

	oMark := MsSelect():New("TRB","TB_OK",,aCampos,@lInverte,@cMarca,{107,265,248,502},,oDlg)
	//oMark:oBrowse:bldblclick := { || f_Mark(cMarca) }   
	//oMark:oBrowse:bChange := { || IIF(!lFirst , nil , f_SelForn(0) ) }     
	
	@ 019,263 GROUP oGroup4  TO 098,504 PROMPT ""                                               OF oDlg  PIXEL             
	@ 020,266 Say   ocItem              VAR    _cItem                             Size 160,14   OF oDlg  PIXEL          FONT oFnt4   COLOR CLR_HBLUE  
	@ 036,266 Say   ocDesc              VAR    _cDesc                             Size 280,14   OF oDlg  PIXEL          FONT oFnt4   COLOR CLR_HBLUE  
	@ 054,263 GROUP oGroup5  TO 055,504 PROMPT ""                                               OF oDlg  PIXEL             
	@ 057,266 Say   oLocal              PROMPT "Localização"                                    OF oDlg  PIXEL
	@ 064,266 MSGET oLocaliz		      VAR     cLocaliz  PICTURE "@!"   F3 "SBE"	SIZE 080, 009 OF oDlg COLORS 0, 16777215 PIXEL  Font oFnt3 Valid(_fVlDlg("LOCALIZ"))
	@ 064,350 MSGET oDescLcz		      VAR     cDescLcz  PICTURE "@!"           	SIZE 154, 009 OF oDlg COLORS 0, 16777215 PIXEL  Font oFnt3 WHEN .F.
	@ 076,266 Say   oQEtq               PROMPT "Qtde. Etiqueta(s)"                SIZE 070, 010 OF oDlg  PIXEL
	@ 076,320 Say   oQEmb               PROMPT "Qtde. do Produto"                 SIZE 070, 010 OF oDlg  PIXEL
	@ 083,266 MSGET oQtdEtq   	      	VAR     nQtdEtq   PICTURE "@E 999"			SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL  Font oFnt3 Valid(_fVlDlg("QETQ")) 
	@ 083,320 MSGET oQtdEmb 		      VAR     nQtdEmb   PICTURE "@E 9999"	      SIZE 034, 010 OF oDlg COLORS 0, 16777215 PIXEL  Font oFnt3 Valid(_fVlDlg("QEMB"))

	@ 079, 384 SAY   oEtqImp		PROMPT  "Etiq.Impressas"         					SIZE 080, 014 OF oDlg COLOR CLR_HBLUE    PIXEL  Font oFnt2
	@ 091, 384 SAY   oPrdImp      PROMPT  "Qtde.Produtos"            					SIZE 080, 014 OF oDlg COLOR CLR_HBLUE    PIXEL  Font oFnt2
	@ 079, 470 SAY   oEtqImpQ		VAR     nEtqImp   PICTURE "@E 999999"				SIZE 030, 012 OF oDlg COLORS 0, 16777215 PIXEL  Font oFnt3 
	@ 091, 470 SAY   oPrdImpQ  	VAR     nPrdImp   PICTURE "@E 999999"				SIZE 030, 012 OF oDlg COLORS 0, 16777215 PIXEL  Font oFnt3 
		
	oTBmp1 := TBtnBmp2():New( 038, 930, 70, 30,'conf_coel',,,,;   
						{ || f_prtetq(oLst:nAt,cMarca) }  , oDlg,'Impressão da etiqueta',,.F.,.F.)
	
	oTBmp2 := TBtnBmp2():New( 070, 930, 70, 30,'coel_abortar',,,,;
						{ || f_cancela() } , oDlg,'Encerra impressão',,.F.,.F.)
						
	oTBmp3 := TBtnBmp2():New( 038, 0904, 70, 30,'canc_coel',,,,;
					{ || ( lSair := .T. , oDlg:End() ) } , oDlg,'Cancela consulta',,.F.,.F.)
						

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////                 C O N S U L T A
	////
	@ 015, 002 GROUP oGroupA TO 114, 490 PROMPT OemToAnsi("CONSULTA ENDEREÇAMENTO DE MATERIAL") OF oDlg COLOR 0, 16777215 PIXEL
	@ 120, 002 GROUP oGroupB TO 252, 490 PROMPT OemToAnsi("LOCALIZAÇÃO")              			  OF oDlg COLOR 0, 16777215 PIXEL

	@ 023, 004 SAY   oCodigo		PROMPT  OemToAnsi("Código do Produto")				SIZE 090, 010 OF oDlg COLOR  CLR_HBLUE   PIXEL  Font oFnt
	@ 032, 004 MSGET oCodPro		VAR     cCodPro   PICTURE "@!"    F3 "SB1"  		SIZE 150, 010 OF oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt4b VALID f_produto()
	@ 051, 004 SAY   oDescC   		PROMPT  OemToAnsi("Descrição")						SIZE 080, 010 OF oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
	@ 060, 004 MSGET oDescG 		VAR     cDescric                 					SIZE 410, 014 OF oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4b WHEN .F.
	@ 051, 420 SAY   o_UMC    		PROMPT  OemToAnsi("U.M.")     						SIZE 030, 010 OF oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
	@ 060, 420 MSGET o_UMG  		VAR     c_UM                     					SIZE 020, 014 OF oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4b WHEN .F.
	@ 051, 454 SAY   o_TipoC  		PROMPT  OemToAnsi("Tipo")     						SIZE 030, 010 OF oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
	@ 060, 454 MSGET o_TipoG		VAR     c_Tipo                   					SIZE 020, 014 OF oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4b WHEN .F.

	@ 082, 004 SAY   oSdoEstC 		PROMPT  "Saldo Atual"                     		SIZE 080, 010 OF oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4b
	@ 094, 004 MSGET oSdoEstG  	VAR     nSdoEst   PICTURE "@E 999999,999"  		SIZE 080, 014 OF oDlg COLOR  CLR_HRED    PIXEL  Font oFnt4b WHEN .F.
	@ 082, 120 SAY   oEstEmpC 		PROMPT  "Empenho"                         		SIZE 070, 012 OF oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4b
	@ 094, 120 MSGET oEstEmpG  	VAR     nEstEmp   PICTURE "@E 999999,999"  		SIZE 080, 014 OF oDlg COLOR  CLR_HRED    PIXEL  Font oFnt4b WHEN .F.
	@ 082, 230 SAY   oEstDispC		PROMPT  "Estoque Disponível"              		SIZE 120, 012 OF oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4b
	@ 094, 230 MSGET oEstDispG 	VAR     nEstDisp  PICTURE "@E 999999,999"  		SIZE 110, 014 OF oDlg COLOR  CLR_HRED    PIXEL  Font oFnt4b WHEN .F.

	oEnder := TCBrowse():New( 128 , 004, 483, 122,,{'LOCAL','ENDEREÇO','DESCRIÇÃO','QUANTIDADE','DATA'},{40,70,90,50,50},oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	

	oEnder:SetArray(aEnder)

	oEnder:bLine := {|| { aEnder[oEnder:nAt,1] , ;
								 aEnder[oEnder:nAt,2] , ;
								 aEnder[oEnder:nAt,3] , ;
								 aEnder[oEnder:nAt,4] , ;
								 aEnder[oEnder:nAt,5] } }
						
	///=================================================================================================	
	oTBitmap1 := TBtnBmp2():New( 00, 00, 40, 70, 'S4WB008N' ,,,,;
						{ || Calculadora() }  ,oTBar,'Calculadora',,.F.,.F.)
	oTBitmap2 := TBtnBmp2():New( 00, 00, 40, 70,'vernota' , , , ,;
						{|| IIF(nOpcA==0 , f_localiza() , nil ) }  ,oTBar,'Consulta localização',,.F.,.F.)
	oTBitmap3 := TBtnBmp2():New( 00, 00, 40, 70, 'button_exit' ,,,,;
						{ || f_saida() }  ,oTBar,'Sair',,.F.,.F.)
	
	////
	////Esconde objetos
	////
	oGroup3:Hide()
	oGroup4:Hide()
	oGroup5:Hide()
	oTBmp1:Hide()
	oTBmp2:Hide()
	oTBmp3:Hide()
	oMark:oBrowse:Hide()
	ocItem:Hide()
	ocDesc:Hide()
	oLocal:Hide()
	oLocaliz:Hide()
	oDescLcz:Hide()
	oQEmb:Hide()
	oQEtq:Hide()
	oQtdEtq:Hide()
	oQtdEmb:Hide()
	oEtqImp:Hide()
	oPrdImp:Hide()
	oEtqImpQ:Hide()
	oPrdImpQ:Hide()
	oGroupA:Hide()
	oGroupB:Hide()
	oCodigo:Hide()
	oCodPro:Hide()
	oDescC:Hide()
	oDescG:Hide()
	o_UMC:Hide()
	o_UMG:Hide()
	o_TipoC:Hide()
	o_TipoG:Hide()
	oSdoEstC:Hide()
	oSdoEstG:Hide()
	oEstEmpC:Hide()
	oEstEmpG:Hide()
	oEstDispC:Hide()
	oEstDispG:Hide()
	oEnder:Hide()
	
	
	ACTIVATE MSDIALOG oDlg CENTER VALID lSair
	
ENDDO	

TRB->(dbCloseArea())

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_saida()
//////////////////////////////////////////////////////////////////////////////////////////// 
	
IF ( !lNFiscal )
	lSair    := .T.
	lLooping := .F.
	oDlg:End()
ENDIF

Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_localiza()
//////////////////////////////////////////////////////////////////////////////

IF ( lNFiscal )
	Return
ENDIF

nOpcA := 1

oGroup1:Hide()
oGroup2:Hide()
oPref:Hide()
oSerie:Hide()
oNF:Hide()
oNFiscal:Hide()
oRazSoc:Hide()
oFornece:Hide()
oDEmiss:Hide()
oEmissao:Hide()
oDEntr:Hide()
oEntrada:Hide()
oDI:Hide()
oInvoice:Hide()
oMun:Hide()
oMunFor:Hide()
oUF:Hide()
oEstFor:Hide()
oLst:Hide()

oGroupA:Show()
oGroupB:Show()
oTBmp3:Show()
oCodigo:Show()
oCodPro:Show()
oDescC:Show()
oDescG:Show()
oSdoEstC:Show()
oSdoEstG:Show()
oEstDispC:Show()
oEstDispG:Show()
oEstEmpC:Show()
oEstEmpG:Show()
o_UMC:Show()
o_UMG:Show()
o_TipoC:Show()
o_TipoG:Show()
oEnder:Show()
oCodPro:SetFocus()

Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_produto()
//////////////////////////////////////////////////////////////////////////////
Local cQry
Local lRsp := .T.

IF ( !EMPTY(cCodPro) .AND. cCodPro <> mCodPro )
	
	SB1->(dbSeek(xFilial("SB1")+cCodPro))
	
	IF SB1->(EOF())
		MsgStop("Código do produto não cadastrado.","Código inválido")
		lRsp    := .F.
		
	ELSE
	
		SB2->(dbSeek(xFilial("SB2")+cCodPro+mvLocal))

		mCodPro  := cCodPro
		cDescric := LEFT(SB1->B1_DESC,76)
		c_UM     := SB1->B1_UM
		c_Tipo   := SB1->B1_TIPO
		nSdoEst  := SB2->B2_QATU
		nEstEmp  := ( SB2->B2_QEMP + SB2->B2_RESERVA )
		nEstDisp := ( nSdoEst - nEstEmp )
		
		cQry := "SELECT * FROM "+RetSqlName("SBF")+" BF,"+RetSqlName("SBE")+" BE "
		cQry += "WHERE BF.D_E_L_E_T_ = ' ' AND BE.D_E_L_E_T_ = ' ' "
		cQry += "AND BF_FILIAL = '"+xFilial("SBF")+"' AND BE_FILIAL = '"+xFilial("SBE")+"' "
		cQry += "AND BF_LOCAL = '"+mvLocal+"' "
		cQry += "AND BF_PRODUTO = '"+cCodPro+"' "
		cQry += "AND BF_QUANT > 0 "
		cQry += "AND BE_LOCAL = BF_LOCAL "
		cQry += "AND BE_LOCALIZ = BF_LOCALIZ "
		cQry += "ORDER BY BF_LOCALIZ "

		cQry := ChangeQuery(cQry)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMP",.T.,.T.)

		TcSetField("TMP","BF_DATAVEN","D",08,0)

		aEnder := {}
		dbSelectArea("TMP")
		dbGoTop()
		DO WHILE !EOF()
			AADD(aEnder , { TMP->BF_LOCAL         , ;
								 TMP->BF_LOCALIZ       , ;
								 TMP->BE_DESCRIC       , ;
								 TMP->BF_QUANT         , ;
								 DTOC(TMP->BF_DATAVEN) } )
			dbSkip()
		ENDDO

		TMP->(dbCloseArea())
		
		IF ( LEN(aEnder) = 0 )
			aEnder := { { SPACE(2) , SPACE(15) , SPACE(30) , 0 , SPACE(8) } }
		ENDIF

		oEnder:SetArray(aEnder)
		oEnder:bLine := {|| { aEnder[oEnder:nAt,1] , ;
									 aEnder[oEnder:nAt,2] , ;
									 aEnder[oEnder:nAt,3] , ;
									 aEnder[oEnder:nAt,4] , ;
									 aEnder[oEnder:nAt,5] } }
		
		oEnder:lAdjustColsize := .F.
		oEnder:Refresh()
		
		oDescG:Refresh()
		oSdoEstG:Refresh()
		oEstDispG:Refresh()

	ENDIF
	
ENDIF

Return(lRsp)

///////////////////////////////////////////////////////////
Static Function f_prtetq(nItem,cMarca)
///////////////////////////////////////////////////////////
Local nX,nQtdImp
Local nQuant  := ( nQtdEtq * nQtdEmb )
Local cQtdEmb := TRANSF(nQtdEmb,"@E 9999")+ " "+_cUM
Local cEmbQtd := STRZERO( nQtdEmb , 4 )
Local cAviso  := IIF(nQtdEtq > 1 , "As etiquetas foram impressas corretamente?" , "A etiqueta foi impressa corretamente?" ) + CHR(13)+CHR(10) + "Se não, favor reimprimir somente as etiquetas com defeito."
Local cDI     := IIF(cEstFor == "EX" , "D.I: "+cInvoice , "PEDIDO: "+_cPedido+"/"+_cItemPC )
Local _mProd  := RTRIM(_cProd)
Local nLarg   := IIF(LEN(_mProd) < 16 , 2 , 1 )
Local nBarr   := IIF(LEN(_mProd) < 16 , 1 , 3 )

dbSelectArea("SBF")
dbSetOrder(1)                ////BF_FILIAL, BF_LOCAL, BF_LOCALIZ, BF_PRODUTO, BF_NUMSERI, BF_LOTECTL, BF_NUMLOTE

IF ( nQuant > 0 )

	MSCBPRINTER("S600","LPT1",,,.f.,,,,)
	MSCBCHKSTATUS(.F.)

	MSCBLOADGRF("\ARQUIVOS\FOTOS\COEL-L3T.GRF")

	MSCBBEGIN(nQtdEtq,4) 
	MSCBWRITE("^LH08,16^FS") 
	
	MSCBGRAFIC(21.0,0.25,"COEL-L3T")

	MSCBSAY(21.0,11.85,"CODIGO: "+_cProd,"P","D","40,06")
	MSCBSAY(21.0,16.35,_cDesc,"P","D","40,06")
	MSCBSAY(21.0,20.85,"ENDERECO: "+cLocaliz,"P","D","40,06")
	MSCBLINEH(21.0,25.0,65,3)

	MSCBSAY(21.0,26.85,"FORNECEDOR: "+cNReduz,"P","D","40,06")
	MSCBSAY(21.0,31.50,"N.FISCAL: "+cSerie+cNFiscal,"P","D","40,06")
	MSCBSAY(21.0,36.55,cDI,"P","D","40,06")
	MSCBSAY(21.0,42.0,"QTDE.: "+cQtdEmb,"P","D","40,06")

	MSCBSAYBAR(72.0,32.0,cEmbQtd,"B","C",8,.f.,.t.,.f.,"C",2,1,.F.)  

	MSCBSAYBAR(23.5,55.0,_mProd,"N","C",8,.f.,.t.,.f.,"B",nLarg,nBarr,.F.) 
	
	/*
	MSCBGRAFIC(1.0,0.25,"COEL-L3T")

	MSCBSAY(1.5,11.85,"CODIGO: "+_cProd,"P","D","40,06")
	MSCBSAY(1.5,16.35,_cDesc,"P","D","40,06")
	MSCBSAY(1.5,20.85,"ENDERECO: "+cLocaliz,"P","D","40,06")
	MSCBLINEH(1.5,25.0,59,3)

	MSCBSAY(1.5,26.85,"FORNECEDOR: "+cNReduz,"P","D","40,06")
	MSCBSAY(1.5,31.50,"N.FISCAL: "+cSerie+cNFiscal,"P","D","40,06")
	MSCBSAY(1.5,36.55,cDI,"P","D","40,06")
	MSCBSAY(1.5,42.0,"QTDE.: "+cQtdEmb,"P","D","40,06")

	MSCBSAYBAR(47.0,32.0,cEmbQtd,"B","C",8,.f.,.t.,.f.,"C",2,1,.F.)  

	MSCBSAYBAR(4.0,49.0,_mProd,"N","C",8,.f.,.t.,.f.,"B",nLarg,nBarr,.F.) 
	*/
	MSCBEND()
	MSCBClosePrinter()

	nX := Aviso("Impressão da Etiqueta" , cAviso , {"Sim","Não"} , 3 )

	IF ( nX == 2 )
		mQtdEtq := nQtdEtq
		Return
	ENDIF

	nQEtqAnt := IIF(mQtdEtq == 0 , 0 , ( nQtdEmb * ABS( mQtdEtq - nQtdEtq ) ) )
	mQtdEtq  := IIF(mQtdEtq == 0 , 0 , ( mQtdEtq - nQtdEtq ) )
	_nSaldo  := ( _nSaldo - nQEtqAnt - nQuant )
	nEtqImp  := ( nEtqImp + mQtdEtq + nQtdEtq )
	nQtdImp  := ( ( mQtdEtq + nQtdEtq ) * nQtdEmb ) 
	nPrdImp  := ( nPrdImp + nQtdImp )
	nQuant   := IIF(mQtdEtq > 0 , nQtdImp , nQuant )

	aItens[nItem,10] := _nSaldo
	aItens[nItem,11] := nEtqImp
	aItens[nItem,12] := nPrdImp
	
	IF ( !EMPTY(cLocaliz) )
		SBF->(dbSeek(xFilial("SBF")+mvLocal+cLocaliz+_cProd))
		IF ( SBF->(EOF()) )
			RecLock("SBF",.T.)
			SBF->BF_FILIAL  := xFilial("SBF")
			SBF->BF_LOCAL   := mvLocal
			SBF->BF_PRODUTO := _cProd
			SBF->BF_LOCALIZ := cLocaliz	
			SBF->BF_QUANT   := nQuant
		ELSE
			RecLock("SBF",.F.)
			SBF->BF_QUANT := IIF(SBF->BF_DATAVEN <> dEntrada , nQuant , ( SBF->BF_QUANT + nQuant ) )
		ENDIF	
		SBF->BF_DATAVEN := dEntrada
		MsUnlock()
	ENDIF

ENDIF

dbSelectArea("TRB")
dbGoTop()
DO WHILE !EOF()
	SBF->(dbSeek(xFilial("SBF")+TRB->TB_LOCAL+TRB->TB_LOCALIZ+TRB->TB_PRODUTO))
	IF ( !EMPTY(TRB->TB_OK) )
		IF ( TRB->TB_LOCALIZ == cLocaliz )
			IF ( SBF->(EOF()) )
				RecLock("SBF",.T.)
				SBF->BF_FILIAL  := xFilial("SBF")
				SBF->BF_LOCAL   := TRB->TB_LOCAL
				SBF->BF_PRODUTO := TRB->TB_PRODUTO
				SBF->BF_LOCALIZ := TRB->TB_LOCALIZ
				SBF->BF_QUANT   := nQuant
				SBF->BF_DATAVEN := dEntrada
			ELSE
				RecLock("SBF",.F.)
				SBF->BF_QUANT   := IIF(dEntrada <> SBF->BF_DATAVEN , nQuant , ( SBF->BF_QUANT + nQuant ) )
				SBF->BF_DATAVEN := dEntrada
			ENDIF
			MsUnlock()
		ENDIF
	ELSEIF ( SBF->(!EOF()) )
		IF ( SBF->BF_LOCALIZ <> cLocaliz )
			RecLock("SBF",.F.)
			dbDelete()		
			MsUnLock()
		ENDIF	
		IF ( aItens[nItem,12] > 0 )
			aItens[nItem,10] += SBF->BF_QUANT 
			aItens[nItem,12] -= SBF->BF_QUANT
			aItens[nItem,11] := IIF(aItens[nItem,12] == 0 , 0 , aItens[nItem,11] )
		ENDIF	
	ENDIF
	dbSelectArea("TRB")
	dbSkip()
ENDDO	

dbSelectArea("SBF")
dbSetOrder(2)                       ////BF_FILIAL, BF_PRODUTO, BF_LOCAL, BF_LOTECTL, BF_NUMLOTE, BF_PRIOR, BF_LOCALIZ, BF_NUMSERI

f_descpro(nItem,cMarca,0)           ////Refresh no browse de localizacao do material

aItens[nItem,1] := IIF(aItens[nItem,10] == 0 , "1" , "0" )

oLst:SetArray(aItens)
oLst:bLine   := { || { IIF(aItens[oLst:nAt,1]=="1",oVd,oVm) , ;
							  aItens[oLst:nAt,2]  , ;
							  aItens[oLst:nAt,3]  , ;
							  aItens[oLst:nAt,4]  , ;
							  aItens[oLst:nAt,5]  , ;
							  aItens[oLst:nAt,6]  , ;
							  aItens[oLst:nAt,7]  , ;
							  aItens[oLst:nAt,8] } }

oLst:Refresh()
	
dbSelectArea("TRB")
dbGoTop()
oMark:oBrowse:GoTop()
oMark:oBrowse:Refresh()

nQtdEmb := 0
nQtdEtq := 0
mQtdEtq := 0

oEtqImpQ:Refresh()
oPrdImpQ:Refresh()
	
Return

///////////////////////////////////////////////////////////////////////
Static Function f_descpro(nItem,cMarca,nOpc)
///////////////////////////////////////////////////////////////////////
Local aSalAtu

SB1->(dbSeek(xFilial("SB1")+aItens[nItem,3]))
SC7->(dbSeek(xFilial("SC7")+aItens[nItem,6]+aItens[nItem,7]))

cLocaliz := SPACE(15)
cDescLcz := " "
mQtdEtq  := 0
nQtdEmb  := 0
nQtdEtq  := 0
_cProd   := aItens[nItem,3]
_cItem   := "ITEM "+aItens[nItem,2]+" - "+_cProd
_cDesc   := LEFT(SB1->B1_DESC,40)
_cUM     := aItens[nItem,5]
_cPedido := RTRIM(SC7->C7_NUM)
_cItemPC := SC7->C7_ITEM  	
aSalAtu  := CalcEst(_cProd,mvLocal,ddatabase)         ///aSalAtu[1]=B2_QATU,aSalAtu[2]=B2_VATU1 - Saldo referente a data informada - 1 dia. Ex.: 19/02/15, pega o saldo até 18/02/15.

IF ( nOpc <> 0 )
	_nSaldo := aItens[nItem,10]
	nEtqImp := aItens[nItem,11]
	nPrdImp := aItens[nItem,12]
ENDIF

dbSelectArea("TRB")
__dbZap()

dbSelectArea("SBF")
dbSeek(xFilial("SBF")+_cProd+mvLocal,.T.)
DO WHILE !EOF().AND.BF_FILIAL==xFilial("SBF").AND.BF_PRODUTO==_cProd.AND.BF_LOCAL==mvLocal
	SBE->(dbSeek(xFilial("SBE")+mvLocal+SBF->BF_LOCALIZ))
	
	RecLock("TRB",.T.)
	TRB->TB_OK      := IIF(SBF->BF_QUANT > 0 , cMarca , " " )
	TRB->TB_LOCALIZ := SBF->BF_LOCALIZ
	TRB->TB_DESCRI  := SBE->BE_DESCRIC
	TRB->TB_PRODUTO := SBF->BF_PRODUTO
	TRB->TB_LOCAL   := SBF->BF_LOCAL
	TRB->TB_QUANT   := SBF->BF_QUANT
	TRB->TB_DATA    := SBF->BF_DATAVEN
	MsUnlock()
	
	dbSelectArea("SBF")
	dbSkip()
ENDDO

dbSelectArea("TRB")
dbGoTop()

oMark:oBrowse:Refresh()
oLocaliz:Refresh()
oDescLcz:Refresh()
ocItem:Refresh()
ocDesc:Refresh()
oQtdEmb:Refresh()
oQtdEtq:Refresh()
oEtqImpQ:Refresh()
oPrdImpQ:Refresh()

Return

///////////////////////////////////////////////////////////////////////
Static Function f_nfiscal(cMarca)
///////////////////////////////////////////////////////////////////////
Local cQry,cCodEmbs,cCodOpcs,cQtdEmbs,cQtdOpcs
Local nQtde,nPeso,nX,nW,nV
Local lRsp := .T.

IF ( cSerie+cNFiscal <> mSerie+mNFiscal )

	cQry := "SELECT * FROM "+RetSqlName("SD1")+" D1,"+RetSqlName("SF1")+" F1"
	cQry += " WHERE F1.D_E_L_E_T_ = ' ' AND D1.D_E_L_E_T_ = ' '"
	cQry += " AND F1_FILIAL  = '"+xFilial("SF1")+"'"
	cQry += " AND F1_ESPECIE = 'SPED'"
	cQry += " AND F1_TIPO    = 'N'"
	cQry += " AND F1_SERIE   = '"+cSerie+"'"
   cQry += " AND F1_DOC     = '"+cNFiscal+"'"
	cQry += " AND D1_FILIAL  = '"+xFilial("SD1")+"'"
	cQry += " AND D1_FORNECE = F1_FORNECE"
	cQry += " AND D1_LOJA    = F1_LOJA"
	cQry += " AND D1_SERIE   = F1_SERIE"
	cQry += " AND D1_DOC     = F1_DOC"
	cQry += " AND D1_EMISSAO = F1_EMISSAO"
	cQry += " AND D1_CF IN ('1101','1102','1124','2101','2102','2124','3101','3102')"
	cQry += " ORDER BY D1_ITEM "
	
	cQry := ChangeQuery(cQry)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

	TcSetField("TMP","F1_EMISSAO","D",08,0)
	TcSetField("TMP","F1_DTDIGIT","D",08,0)
	TcSetField("TMP","D1_QUANT" ,"N",13,02)
	
	dbSelectArea("TMP")
	dbGoTop()
	IF ( !EOF() )
		SA2->(dbSeek(xFilial("SA2")+TMP->F1_FORNECE+TMP->F1_LOJA))
		cFornece := SA2->A2_NOME
		cMunFor  := SA2->A2_MUN
		cNReduz  := SA2->A2_NREDUZ
		cEstado  := SA2->A2_EST
		cCodPais := SA2->A2_CODPAIS
		CCH->(dbSeek(xFilial("CCH")+cCodPais))
		cCountry := RTRIM(CCH->CCH_PAIS)
		dEmissao := TMP->F1_EMISSAO
		cEstFor  := TMP->F1_EST
		dEntrada := TMP->F1_DTDIGIT
		
		nX := AT("/",TMP->F1_OBSNFE4)
		IF ( nX == 0 )
			cInvoice := SUBS(TMP->F1_OBSNFE4,4,12)            
		ELSE
			cInvoice := SUBS(TMP->F1_OBSNFE4 , ( nX-2 ) , 12 )
		ENDIF
		
		aItens  := {}
		
		DO WHILE !EOF()
			SC7->(dbSeek(xFilial("SC7")+TMP->D1_PEDIDO+TMP->D1_ITEMPC))
			SB1->(dbSeek(xFilial("SB1")+TMP->D1_COD))
			
			AADD( aItens , { "0"              , ;
								  TMP->D1_ITEM     , ;
								  TMP->D1_COD      , ;
								  TMP->D1_QUANT    , ;
								  TMP->D1_UM       , ;
								  TMP->D1_PEDIDO   , ;
								  TMP->D1_ITEMPC   , ;
								  TMP->D1_NUMSEQ   , ;
								  SB1->B1_DESC     , ;
								  TMP->D1_QUANT    , ;
								  0                , ;
								  0 } )

			dbSkip()
			
		ENDDO

		mSerie   := cSerie
		mNFiscal := cNFiscal

		oLst:SetArray(aItens)
		oLst:bLine   := { || { IIF(aItens[oLst:nAt,1]=="1",oVd,oVm) , ;
									  aItens[oLst:nAt,2]  , ;
									  aItens[oLst:nAt,3]  , ;
									  aItens[oLst:nAt,4]  , ;
									  aItens[oLst:nAt,5]  , ;
									  aItens[oLst:nAt,6]  , ;
									  aItens[oLst:nAt,7]  , ;
									  aItens[oLst:nAt,8] } }
		
		oLst:Refresh()
				
	ELSE
		MsgStop("Não foi encontrado a Serie/N.Fiscal ["+cSerie+cNFiscal+"] informada.","Atenção")
		lRsp := .F.
		IF ( !EMPTY(cSerie+cNFiscal) )
			cSerie   := SPACE(3)
			cNFiscal := SPACE(9)
		ENDIF
	ENDIF

	TMP->(dbCloseArea())
	
	IF ( !EMPTY(cEstFor) )
		////
		////Re-exibe objetos
		////
		oGroup3:Show()
		oGroup4:Show()
		oGroup5:Show()
		oTBmp1:Show()
		oTBmp2:Show()
		oMark:oBrowse:Show()
		ocItem:Show()
		ocDesc:Show()
		oLocal:Show()
		oLocaliz:Show()
		oDescLcz:Show()
		oQEmb:Show()
		oQEtq:Show()
		oQtdEtq:Show()
		oQtdEmb:Show()
		oEtqImp:Show()
		oPrdImp:Show()
		oEtqImpQ:Show()
		oPrdImpQ:Show()
		oLocaliz:SetFocus()

		lNFiscal := .T.

		f_descpro(1,cMarca,1)
		
	ENDIF	
	
ENDIF

Return(lRsp)

///////////////////////////////////////////////////////////////////////
Static Function f_cancela()        
///////////////////////////////////////////////////////////////////////

lSair := .T.

oDlg:End()
			
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////Validacao Da Digitacao Dos Dados Da Dialog. 
////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function _fVlDlg(_cTipo)

Do Case

	Case _cTipo == "QEMB"
			If ( ( nQtdEmb * nQtdEtq ) > _nSaldo )
				MsgAlert("A soma da(s) quantidade(s) informada ultrapassa a quantidade faturada. Certifique-se dos valores informado antes de imprimir.","Atenção")
			EndIf

	Case _cTipo == "QETQ"
			If ( ( nQtdEtq * nQtdEmb ) > _nSaldo )
				MsgAlert("A soma da(s) quantidade(s) informada ultrapassa a quantidade faturada. Certifique-se dos valores informado antes de imprimir.","Atenção")
			EndIf

	Case _cTipo == "LOCALIZ"
	
			IF ( !EMPTY(cLocaliz) )
				SBE->(dbSeek(xFilial("SBE")+mvLocal+cLocaliz))
				If ( SBE->(EOF()) )
					Help(' ',1,"REGNOIS")
					Return(.F.)	
				EndIf
				cDescLcz := SBE->BE_DESCRIC
			ELSE
				cDescLcz := " "
			ENDIF
			
EndCase

Return