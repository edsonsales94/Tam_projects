/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFATG310  ³ Autor ³ Carlos Nina           ³ Data ³26/11/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualizacao de saldo por endereço.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Coelmatic/Manaus (Almoxarifado/Expedicao)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

User Function CESTG310()

Local   aAreas := GetArea()

Private oDlg,oLst,oMark,oSerie,oNFiscal,oEmissao,oEntrada,oFornece,oMunFor,oEstFor
Private oTBitmap1,oTBitmap2,oTBmp1,oTBmp2
Private oGroup1,oGroup2,oGroup3,oGroup4,oGroup5,oGroup6,oGroup7,oGroup8,oGroup9
Private oFnt,oFnt2,oFnt3,oFnt3a,oFnt4,oFnt5,oFnt6,oFnt7,oFnt8,oFnt9,oFnt9a,oFnt9b,oFont24b
Private cSerie,cNFiscal,dEmissao,dEntrada,cFornece,cInvoice,cMunFor,cEstFor
Private nQtdEmb,nQtdEtq,nEtqImp,nPrdImp,mQtdEtq,_nSaldo
Private _cProd,_cFamilia,_cModelo,_cPedido,_cItemPC,_cDesc
Private aItens,aLocaliz
Private lSair,lNFiscal

Private mvLocal   := IIF(M->cNumEmp=="0301","02","01")    
Private cCadastro := "Tipo de Movimento"
Private aLegenda  := {}
Private lLooping  := .T.
Private oVd       := LoadBitmap( GetResources(), 'br_verde')
Private oVm       := LoadBitmap( GetResources(), 'br_vermelho')
Private oAz       := LoadBitmap( GetResources(), 'br_azul')
Private oLr       := LoadBitmap( GetResources(), 'br_laranja')
Private oAm       := LoadBitmap( GetResources(), 'br_amarelo')
Private oCz       := LoadBitmap( GetResources(), 'br_cinza')

Private cPerg  := "CESTG310  "

Validperg(1)

Pergunte(cPerg,.F.)

Aadd(aLegenda, {"ENABLE"     , "Nota Fiscal"                 } ) 
Aadd(aLegenda, {"BR_AMARELO" , "Mov.Interno - Produção"      } )	
Aadd(aLegenda, {"BR_AZUL"    , "Mov.Interno - Ajuste"        } ) 
Aadd(aLegenda, {"BR_LARANJA" , "Mov.Interno - Desmanche"     } )	
Aadd(aLegenda, {"BR_CINZA"   , "Mov.Interno - Transferencia" } ) 
Aadd(aLegenda, {"DISABLE"    , ""                            } ) 

DEFINE FONT oFnt   NAME "Arial" Size 10,17             ///LARG. X ALT.
DEFINE FONT oFnt2  NAME "Arial" Size 10,11
DEFINE FONT oFnt3  NAME "Arial" Size 10,12
DEFINE FONT oFnt3a NAME "Arial" Size 8,16
DEFINE FONT oFnt3b NAME "Arial" Size 8,24
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

dbSelectArea("SD1")
dbSetOrder(1)
dbSelectArea("SF1")
dbSetOrder(1)
dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea("SA2")
dbSetOrder(1)
dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SB2")
dbSetOrder(1)
dbSelectArea("SBE")
dbSetOrder(1)
dbSelectArea("SBF")
dbSetOrder(1)                   /////BF_FILIAL, BF_PRODUTO, BF_LOCAL, BF_LOTECTL, BF_NUMLOTE, BF_PRIOR, BF_LOCALIZ, BF_NUMSERI
dbSelectArea("SD2")
dbSetOrder(1)
dbSelectArea("SF2")
dbSetOrder(1)

DO WHILE lLooping
	aAEnder  := {}       ///Copia de aEnder, caso cancelamento da operacao
	aBEnder  := {}       ///Copia de aEnder, no momento da operacao de endereçamento
	aEntra   := { { "0" , SPACE(3) , SPACE(9) , CTOD("") , 0 , SPACE(20) } }
	aSaida   := { { "0" , SPACE(3) , SPACE(9) , CTOD("") , 0 , SPACE(20) } }
	aEnder   := { { "0" , SPACE(2) , SPACE(15) , 0 , SPACE(30) , SPACE(8) , SPACE(15) , 0 } }
	cProduto := SPACE(31)
	mProduto := SPACE(31)
	cDesc    := SPACE(40)
	cTipo    := SPACE(02)
	cAlmox   := SPACE(02)
	cUM      := SPACE(02)
	cResEmp  := "Empenho"
	cGetLoc1 := cGetLoc2 := cGetLoc3 := cGetLoc4 := cGetLoc5 := cGetLoc6 := cGetLoc7 := cGetLoc8 := cGetLoc9 := SPACE(15)
	nGetQty1 := nGetQty2 := nGetQty3 := nGetQty4 := nGetQty5 := nGetQty6 := nGetQty7 := nGetQty8 := nGetQty9 := 0
	nOpcA    := 0
	nSdoEst  := 0
	nSdoEmp  := 0
	nSdoDisp := 0
	nTpOper  := 0
	lSair    := .F.
	lIncProc := .F.
	lProduto := .F.
	
	DEFINE MSDIALOG oDlg TITLE OEMTOANSI(":::... MANUTENÇÃO DE SALDOS DE ESTOQUE POR ENDEREÇO ...:::") FROM 000, 000  TO 428, 1022 COLORS 0, 16777215 PIXEL

	oTBar := TBar():New( oDlg,40,25,.T.,,,'tbar_coel',.F. )   

   @ 016, 002 GROUP oGroup1 TO 206, 277 PROMPT "PRODUTO"                		  	                    OF oDlg COLOR 0, 16777215 PIXEL   
   @ 075, 005 GROUP oGroup2 TO 137, 276 PROMPT "ENTRADA ULTIMOS 6 MESES"       		  	              OF oDlg COLOR 0, 16777215 PIXEL   
   @ 141, 005 GROUP oGroup3 TO 203, 276 PROMPT "SAIDA ULTIMOS 6 MESES"         		  	              OF oDlg COLOR 0, 16777215 PIXEL   
   @ 016, 279 GROUP oGroup4 TO 206, 510 PROMPT "SALDOS DE ESTOQUE"              	                    OF oDlg COLOR 0, 16777215 PIXEL
   @ 024, 281 GROUP oGroup5 TO 060, 506 PROMPT "SALDO GERAL"                    	                    OF oDlg COLOR 0, 16777215 PIXEL
   @ 064, 281 GROUP oGroup6 TO 203, 506 PROMPT "SALDO P/ENDEREÇO"               	                    OF oDlg COLOR 0, 16777215 PIXEL

   @ 024, 005 SAY   	oCodigo      PROMPT OemToAnsi("Código")           					   SIZE 050, 014 OF oDlg COLOR  CLR_BLUE    PIXEL FONT oFnt 
   @ 033, 005 MSGET 	oProduto     VAR cProduto     			Picture "@!"   F3 "SB1" 	SIZE 130, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFnt4a VALID f_produto() WHEN !lIncProc
   @ 049, 005 SAY   	oDescri      PROMPT OemToAnsi("Descrição")        					   SIZE 050, 014 OF oDlg COLORS 0, 16777215 PIXEL FONT oFnt 
   @ 058, 005 MSGET 	oDesc        VAR    cDesc     						  						SIZE 220, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFnt4a WHEN .F.
   @ 049, 230 SAY   	oTp          PROMPT OemToAnsi("Tipo")             					   SIZE 045, 014 OF oDlg COLORS 0, 16777215 PIXEL FONT oFnt 
   @ 058, 230 MSGET 	oTipo        VAR    cTipo     						  						SIZE 010, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFnt3b WHEN .F.
   @ 049, 256 SAY   	oUN          PROMPT OemToAnsi("U.M")              					   SIZE 025, 014 OF oDlg COLORS 0, 16777215 PIXEL FONT oFnt 
   @ 058, 256 MSGET 	oUM          VAR    cUM                	            				SIZE 010, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFnt3b WHEN .F.

   @ 032, 283 SAY   	oFisico      PROMPT OemToAnsi("Físico")           					   SIZE 050, 014 OF oDlg COLORS 0, 16777215 PIXEL FONT oFnt 
   @ 041, 283 MSGET 	oSdoEst      VAR    nSdoEst            Picture "@E 99999999.99"	SIZE 070, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFnt4a WHEN .F.
   @ 032, 358 SAY   	oResEmp      VAR    cResEmp                       					   SIZE 045, 014 OF oDlg COLORS 0, 16777215 PIXEL FONT oFnt 
   @ 041, 358 MSGET 	oSdoEmp      VAR    nSdoEmp            Picture "@E 99999999.99"	SIZE 070, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFnt3b WHEN .F.
   @ 032, 434 SAY   	oDispon      PROMPT OemToAnsi("Disponível")       					   SIZE 055, 014 OF oDlg COLORS 0, 16777215 PIXEL FONT oFnt 
   @ 041, 434 MSGET 	oSdoDisp     VAR    nSdoDisp           Picture "@E 99999999.99"	SIZE 070, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFnt3b WHEN .F.
	
	oEntra := TCBrowse():New( 083 , 008, 266, 052,,{"!","C.F.","DOCUMENTO","DATA","QUANT.","FORNECEDOR"},{20,25,40,40,40,50},oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	

	oEntra:SetArray(aEntra)
	oEntra:bLine := { || { IIF(aEntra[oEntra:nAt,1]=="0",oVm,IIF(aEntra[oEntra:nAt,1]=="1",oVd,IIF(aEntra[oEntra:nAt,1]=="2",oAm,IIF(aEntra[oEntra:nAt,1]=="3",oAz,oLr)))) , ;
								  aEntra[oEntra:nAt,2]  , ;
							     aEntra[oEntra:nAt,3]  , ;
								  aEntra[oEntra:nAt,4]  , ;
								  TRANSF(aEntra[oEntra:nAt,5],"@E 99999,999.99")  , ;
							     aEntra[oEntra:nAt,6] } }
								
	oEntra:lAdjustColsize := .F.

	oSaida := TCBrowse():New( 149 , 008, 266, 052,,{"!","C.F.","DOCUMENTO","DATA","QUANT.","CLIENTE"},{20,25,40,40,40,50},oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	

	oSaida:SetArray(aSaida)
	oSaida:bLine := { || { IIF(aSaida[oSaida:nAt,1]=="0",oVm,IIF(aSaida[oSaida:nAt,1]=="1",oVd,IIF(aSaida[oSaida:nAt,1]=="2",oAm,IIF(aSaida[oSaida:nAt,1]=="3",oAz,oLr)))) , ;
								  aSaida[oSaida:nAt,2]  , ;
							     aSaida[oSaida:nAt,3]  , ;
								  aSaida[oSaida:nAt,4]  , ;
								  TRANSF(aSaida[oSaida:nAt,5],"@E 99999,999.99")  , ;
							     aSaida[oSaida:nAt,6] } }
								
	oSaida:lAdjustColsize := .F.

	oEnder := TCBrowse():New( 086 , 283, 221, 116,,{"","ALMOX","LOCALIZAÇÃO","QUANT.","DATA"},{20,40,60,60,40},oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	//86,283,221,116
	
	oEnder:SetArray(aEnder)
	oEnder:bLine := {|| { IIF(aEnder[oEnder:nAt,1]=="0",oVm,oVd) , ;
								 aEnder[oEnder:nAt,2] , ;
								 aEnder[oEnder:nAt,3] , ;
								 TRANSF(aEnder[oEnder:nAt,4],"@E 99999,999.99") , ;
								 aEnder[oEnder:nAt,6] } }
	
	oEnder:lAdjustColsize := .F.
	
   @ 096.5, 331 MSGET 	oGetLoc1     VAR    cGetLoc1           Picture "@!"	           F3 "SBE"   SIZE 060.0, 06 OF oDlg COLORS 0, 16777215 PIXEL  VALID f_310Ender(1)
   @ 096.5, 392 MSGET 	oGetQty1     VAR    nGetQty1           Picture "@E 99999999.99"	          SIZE 061.0, 06 OF oDlg COLORS 0, 16777215 PIXEL  VALID f_310Ender(2)
   @ 105.0, 331 MSGET 	oGetLoc2     VAR    cGetLoc2           Picture "@!"	           F3 "SBE"   SIZE 060.0, 06 OF oDlg COLORS 0, 16777215 PIXEL  VALID f_310Ender(1)
   @ 105.0, 392 MSGET 	oGetQty2     VAR    nGetQty2           Picture "@E 99999999.99"	          SIZE 061.0, 06 OF oDlg COLORS 0, 16777215 PIXEL  VALID f_310Ender(2)
   @ 113.5, 331 MSGET 	oGetLoc3     VAR    cGetLoc3           Picture "@!"	           F3 "SBE"   SIZE 060.0, 06 OF oDlg COLORS 0, 16777215 PIXEL  VALID f_310Ender(1)
   @ 113.5, 392 MSGET 	oGetQty3     VAR    nGetQty3           Picture "@E 99999999.99"	          SIZE 061.0, 06 OF oDlg COLORS 0, 16777215 PIXEL  VALID f_310Ender(2)
   @ 122.0, 331 MSGET 	oGetLoc4     VAR    cGetLoc4           Picture "@!"	           F3 "SBE"   SIZE 060.0, 06 OF oDlg COLORS 0, 16777215 PIXEL  VALID f_310Ender(1)
   @ 122.0, 392 MSGET 	oGetQty4     VAR    nGetQty4           Picture "@E 99999999.99"	          SIZE 061.0, 06 OF oDlg COLORS 0, 16777215 PIXEL  VALID f_310Ender(2)
   @ 130.5, 331 MSGET 	oGetLoc5     VAR    cGetLoc5           Picture "@!"	           F3 "SBE"   SIZE 060.0, 06 OF oDlg COLORS 0, 16777215 PIXEL  VALID f_310Ender(1)
   @ 130.5, 392 MSGET 	oGetQty5     VAR    nGetQty5           Picture "@E 99999999.99"	          SIZE 061.0, 06 OF oDlg COLORS 0, 16777215 PIXEL  VALID f_310Ender(2)
   @ 139.0, 331 MSGET 	oGetLoc6     VAR    cGetLoc6           Picture "@!"	           F3 "SBE"   SIZE 060.0, 06 OF oDlg COLORS 0, 16777215 PIXEL  VALID f_310Ender(1)
   @ 139.0, 392 MSGET 	oGetQty6     VAR    nGetQty6           Picture "@E 99999999.99"	          SIZE 061.0, 06 OF oDlg COLORS 0, 16777215 PIXEL  VALID f_310Ender(2)
   @ 147.5, 331 MSGET 	oGetLoc7     VAR    cGetLoc7           Picture "@!"	           F3 "SBE"   SIZE 060.0, 06 OF oDlg COLORS 0, 16777215 PIXEL  VALID f_310Ender(1)
   @ 147.5, 392 MSGET 	oGetQty7     VAR    nGetQty7           Picture "@E 99999999.99"	          SIZE 061.0, 06 OF oDlg COLORS 0, 16777215 PIXEL  VALID f_310Ender(2)
   @ 156.0, 331 MSGET 	oGetLoc8     VAR    cGetLoc8           Picture "@!"	           F3 "SBE"   SIZE 060.0, 06 OF oDlg COLORS 0, 16777215 PIXEL  VALID f_310Ender(1)
   @ 156.0, 392 MSGET 	oGetQty8     VAR    nGetQty8           Picture "@E 99999999.99"	          SIZE 061.0, 06 OF oDlg COLORS 0, 16777215 PIXEL  VALID f_310Ender(2)
   @ 164.5, 331 MSGET 	oGetLoc9     VAR    cGetLoc9           Picture "@!"	           F3 "SBE"   SIZE 060.0, 06 OF oDlg COLORS 0, 16777215 PIXEL  VALID f_310Ender(1)
   @ 164.5, 392 MSGET 	oGetQty9     VAR    nGetQty9           Picture "@E 99999999.99"	          SIZE 061.0, 06 OF oDlg COLORS 0, 16777215 PIXEL  VALID f_310Ender(2)

	@ 072,285 Button oBtn01 PROMPT OemToAnsi("Inclui")   Size 30,12  OF oDlg PIXEL  Action IIF(!lProduto, nil , f_310Manut(1) ) 
	@ 072,317 Button oBtn02 PROMPT OemToAnsi("Altera")   Size 30,12  OF oDlg PIXEL  Action IIF(!lProduto, nil , f_310Manut(2) )
	@ 072,317 Button oBtn05 PROMPT OemToAnsi("Localiz.") Size 30,12  OF oDlg PIXEL  Action IIF(!lProduto, nil , f_310Manut(3) )
	@ 072,349 Button oBtn06 PROMPT OemToAnsi("Adiciona") Size 30,12  OF oDlg PIXEL  Action IIF(!lProduto, nil , f_310Manut(4) )
	@ 072,381 Button oBtn07 PROMPT OemToAnsi("Subtrai")  Size 30,12  OF oDlg PIXEL  Action IIF(!lProduto, nil , f_310Manut(5) )
	@ 072,440 Button oBtn03 PROMPT OemToAnsi("Confirma") Size 30,12  OF oDlg PIXEL  Action IIF(!lProduto, nil , f_confirma()  )
	@ 072,472 Button oBtn04 PROMPT OemToAnsi("Cancela")  Size 30,12  OF oDlg PIXEL  Action IIF(!lProduto, nil , f_cancela() ) 
	
	oGetLoc1:Hide()
	oGetQty1:Hide()
	oGetLoc2:Hide()
	oGetQty2:Hide()
	oGetLoc3:Hide()
	oGetQty3:Hide()
	oGetLoc4:Hide()
	oGetQty4:Hide()
	oGetLoc5:Hide()
	oGetQty5:Hide()
	oGetLoc6:Hide()
	oGetQty6:Hide()
	oGetLoc7:Hide()
	oGetQty7:Hide()
	oGetLoc8:Hide()
	oGetQty8:Hide()
	oGetLoc9:Hide()
	oGetQty9:Hide()
	oBtn05:Hide()
	oBtn06:Hide()
	oBtn07:Hide()
	///oNullo:Hide()
	
	///=================================================================================================	
	oTBitmap1 := TBtnBmp2():New( 00, 00, 40, 70, 'S4WB008N' ,,,,;
						{ || Calculadora() }  ,oTBar,'Calculadora',,.F.,.F.)
	oTBitmap2 := TBtnBmp2():New( 00, 00, 40, 70,'pmsinfo' , , , ,;
						{|| f_legenda() }  ,oTBar,'Legenda de movimento de estoque',,.F.,.F.)
	oTBitmap3 := TBtnBmp2():New( 00, 00, 40, 70,'parametros' , , , ,;
						{|| Pergunte(cPerg,.T.) }  ,oTBar,'Parametros',,.F.,.F.)
	oTBitmap4 := TBtnBmp2():New( 00, 00, 40, 70,'pmsexcel' , , , ,;
							{|| f_prtender() }  ,oTBar,'Impressão dos produtos endereçados',,.F.,.F.)					
	oTBitmap5 := TBtnBmp2():New( 00, 00, 40, 70, 'button_exit' ,,,,;
						{ || f_saida() }  ,oTBar,'Sair',,.F.,.F.)

	ACTIVATE MSDIALOG oDlg CENTER VALID lSair
	
ENDDO	

RestArea(aAreas)

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_saida()
//////////////////////////////////////////////////////////////////////////////////////////// 
Local lRsp := .T.
	
IF ( lIncProc )
	lRsp := MsgBox("Alteração pendente de confirmação. Deseja sair sem confirmar?","Escolha a opção","YESNO")
ENDIF	
IF ( lRsp )
	lSair    := .T.
	lLooping := .F.
	oDlg:End()
ENDIF	

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_legenda()
///////////////////////////////////////////////////////////////////////////////////////////////////////

BrwLegenda(cCadastro,"Legenda Entrada/Saida",aLegenda) 

Return(.T.)

//////////////////////////////////////////////////////////////////////////////
Static Function f_produto()
//////////////////////////////////////////////////////////////////////////////
Local cQry
Local dDatIni  := MonthSub(ddatabase,6)
Local xProduto := PADR(cProduto,30)
Local lRsp     := .T.

IF ( !EMPTY(cProduto) .AND. cProduto <> mProduto )
	
	SB1->(dbSeek(xFilial("SB1")+xProduto))
	
	IF SB1->(EOF())
		MsgStop("Código do produto não cadastrado.","Código inválido")
		lRsp    := .F.
		
	ELSE
	
		SB2->(dbSeek(xFilial("SB2")+xProduto+SB1->B1_LOCPAD))

		lProduto := .T.
		mProduto := cProduto
		cDesc    := LEFT(SB1->B1_DESC,40)
		cUM      := SB1->B1_UM
		cTipo    := SB1->B1_TIPO
		cAlmox   := SB1->B1_LOCPAD
		nSdoEst  := SB2->B2_QATU		
		nSdoEmp  := ( SB2->B2_QEMP + SB2->B2_RESERVA )
		nSdoDisp := ( nSdoEst - nSdoEmp )
		cResEmp  := IIF(SB1->B1_TIPO=="PA" , "Reserva" , "Empenho" )
		aEntra   := {}
		aSaida   := {}

		IF ( mv_par01 == 1 )
			////
			////Ultimas compras
			////
			cQry := "SELECT TOP 3 D1_FORNECE,D1_LOJA,D1_DOC,D1_DTDIGIT,D1_QUANT,D1_CF,A2_NREDUZ FROM "+RetSqlName("SD1")+" D1,"+RetSqlName("SF4")+" F4,"+RetSqlName("SA2")+" A2"
			cQry += " WHERE D1_FILIAL = '"+xFilial("SD1")+"'"
			cQry += " AND   D1_COD = '"+xProduto+"'"
			cQry += " AND   D1_QUANT > 0"
			cQry += " AND   D1_TIPO = 'N'"
			cQry += " AND   D1_DTDIGIT >= '"+DTOS(dDatIni)+"' "
			cQry += " AND   SUBSTRING(D1_CF,2,3) IN ('101','102','107','901')"
			cQry += " AND   D1_LOCAL = '"+SB1->B1_LOCPAD+"'"
			cQry += " AND   F4_CODIGO = D1_TES"
			cQry += " AND   F4_ESTOQUE = 'S'"
			cQry += " AND   ( F4_DUPLIC = 'S' OR D1_CF IN ('3101','3102','3107','1901') )"
			cQry += " AND   A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA"
			cQry += " AND   D1.D_E_L_E_T_ = ' ' AND F4.D_E_L_E_T_ = ' ' AND A2.D_E_L_E_T_ = ' '"
			cQry += " ORDER BY D1_DTDIGIT DESC,A2_NREDUZ "

			cQry := ChangeQuery(cQry)

			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

			TcSetField("TMP","D1_DTDIGIT","D",08,0)

			dbSelectArea("TMP")
			dbGoTop()
			DO WHILE !EOF()
				AADD(aEntra , { "1" , TRANSF(TMP->D1_CF,"@R 9.9999") , TMP->D1_DOC , TMP->D1_DTDIGIT , TMP->D1_QUANT , TMP->A2_NREDUZ } )
				dbSkip()
			ENDDO
			TMP->(dbCloseArea())

			Inkey(1)

			IF ( LEN(aEntra) < 3 )
				/////
				/////Ultimo movimento de entrada
				/////
				nW   := ( 3 - LEN(aEntra) )			
				cQry := "SELECT TOP "+STR(nW,1)+" D3_DOC,D3_EMISSAO,D3_QUANT,D3_CF FROM "+RetSqlName("SD3")
				cQry += " WHERE D_E_L_E_T_ = ' '"
				cQry += " AND   D3_FILIAL  =  '"+xFilial("SD3")+"'"
				cQry += " AND   D3_COD     =  '"+xProduto+"'"
				cQry += " AND   D3_ESTORNO =  ' '"
				cQry += " AND   D3_EMISSAO >= '"+DTOS(dDatIni)+"'"
				cQry += " AND   D3_CF IN ('PR0','DE0','DE4','DE6','DE7')"
				cQry += " ORDER BY D3_EMISSAO DESC,D3_CF DESC "

				cQry := ChangeQuery(cQry)

				dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)
				
				TcSetField("TMP","D3_EMISSAO","D",08,0)

				dbSelectArea("TMP")
				dbGoTop()
				DO WHILE !EOF().AND. LEN(aEntra) < 3
					AADD(aEntra , { IIF(TMP->D3_CF=="PR0","2",IIF(TMP->D3_CF=="DE4","5",IIF(TMP->D3_CF $ "DE0/DE6","3","4"))) , ;
										 TMP->D3_CF      , ;
										 TMP->D3_DOC     , ;
										 TMP->D3_EMISSAO , ;
										 TMP->D3_QUANT   , ;
										 "COELMATIC"  } )
					dbSkip()
				ENDDO
				TMP->(dbCloseArea())

				Inkey(1)
				
			ENDIF
		ENDIF	
		
		IF ( mv_par02 == 1 )
			/////
			/////Ultima Venda
			/////
			cQry := "SELECT TOP 3 D2_CLIENTE,D2_LOJA,D2_DOC,D2_QUANT,D2_EMISSAO,D2_CF,A1_NREDUZ FROM "+RetSqlName("SD2")+" D2,"+RetSqlName("SA1")+" A1,"+RetSqlName("SF4")+" F4"
			cQry += " WHERE D2.D_E_L_E_T_ = ' ' AND A1.D_E_L_E_T_ = ' ' AND F4.D_E_L_E_T_ = ' '"
			cQry += " AND   D2_FILIAL  =  '"+xFilial("SD2")+"'"
			cQry += " AND   D2_COD     =  '"+xProduto+"'"
			cQry += " AND   D2_EMISSAO >= '"+DTOS(dDatIni)+"'"
			cQry += " AND   D2_TIPO = 'N' "
			cQry += " AND   D2_CF IN ('5101','5102','5107','5122','6101','6102','6107','6122','6401','7101','7102','7107')"
			cQry += " AND   F4_CODIGO = D2_TES"
			cQry += " AND   F4_ESTOQUE = 'S'"
			cQry += " AND   A1_COD+A1_LOJA = D2_CLIENTE+D2_LOJA"
			cQry += " ORDER BY D2_EMISSAO DESC,D2_DOC "

			cQry := ChangeQuery(cQry)

			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)
			
			TcSetField("TMP","D2_EMISSAO","D",08,0)
			
			dbSelectArea("TMP")
			dbGoTop()
			DO WHILE !EOF()
				AADD(aSaida , { "1" , TRANSF(TMP->D2_CF,"@R 9.9999") , TMP->D2_DOC , TMP->D2_EMISSAO , TMP->D2_QUANT , TMP->A1_NREDUZ } )
				dbSkip()
			ENDDO
			TMP->(dbCloseArea())

			Inkey(1)
			
			IF ( LEN(aSaida) < 3 )
				/////
				/////Ultimo movimento de saida
				/////
				nW   := ( 3 - LEN(aSaida) )
				cQry := "SELECT TOP "+STR(nW,1)+" D3_DOC,D3_EMISSAO,D3_QUANT,D3_CF FROM "+RetSqlName("SD3")
				cQry += " WHERE D_E_L_E_T_ = ' '"
				cQry += " AND   D3_FILIAL  =  '"+xFilial("SD3")+"'"
				cQry += " AND   D3_COD     =  '"+xProduto+"'"
				cQry += " AND   D3_ESTORNO =  ' '"
				cQry += " AND   D3_EMISSAO >= '"+DTOS(dDatIni)+"'"
				cQry += " AND   D3_CF IN ('RE4','RE1','RE2','RE0','RE6','RE7')"
				cQry += " ORDER BY D3_EMISSAO DESC,D3_CF "

				cQry := ChangeQuery(cQry)

				dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)
				
				TcSetField("TMP","D3_EMISSAO","D",08,0)

				dbSelectArea("TMP")
				dbGoTop()
				DO WHILE !EOF() .AND. LEN(aSaida) < 3
					AADD(aSaida , { IIF(TMP->D3_CF=="RE4","5",IIF(TMP->D3_CF $ "RE0/RE1/RE2/RE6","3","4")) , ;
										 TMP->D3_CF      , ;
										 TMP->D3_DOC     , ;
										 TMP->D3_EMISSAO , ;
										 TMP->D3_QUANT   , ;
										 "COELMATIC" } )
					dbSkip()
				ENDDO
				TMP->(dbCloseArea())

				Inkey(1)
				
			ENDIF
		ENDIF	
		
		IF ( LEN(aEntra) == 0 )
			aEntra := { { "0" , SPACE(5) , SPACE(9) , CTOD("") , 0 , SPACE(20) } }
		ENDIF
		IF ( LEN(aEntra) == 0 )
			aSaida := { { "0" , SPACE(5) , SPACE(9) , CTOD("") , 0 , SPACE(20) } }
		ENDIF
		
		////
		////Saldo por endereço
		////
		cQry := "SELECT * FROM "+RetSqlName("SBF")+" BF,"+RetSqlName("SBE")+" BE "
		cQry += "WHERE BF.D_E_L_E_T_ = ' ' AND BE.D_E_L_E_T_ = ' ' "
		cQry += "AND BF_FILIAL = '"+xFilial("SBF")+"' AND BE_FILIAL = '"+xFilial("SBE")+"' "
		cQry += "AND BF_LOCAL = '"+SB2->B2_LOCAL+"' "
		cQry += "AND BF_PRODUTO = '"+xProduto+"' "
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
			AADD(aEnder , { "0"                   , ;
								 TMP->BF_LOCAL         , ;
								 TMP->BF_LOCALIZ       , ;
								 TMP->BF_QUANT         , ;
								 TMP->BE_DESCRIC       , ;
								 DTOC(TMP->BF_DATAVEN) , ;
								 TMP->BF_LOCALIZ       , ;
								 TMP->BF_QUANT  } )
			dbSkip()
		ENDDO

		TMP->(dbCloseArea())
		
		IF ( LEN(aEnder) = 0 )
			aEnder := { { "0" , SPACE(2) , SPACE(15) , 0 , SPACE(30) , SPACE(8) , SPACE(15) , 0 } }
		ENDIF

		aAEnder := ACLONE(aEnder)
		
		f_checksdoend()                                                          ///Checa o saldo fisico (SB2) com o saldo por endereço (SBF)
		
		oEntra:SetArray(aEntra)
		oEntra:bLine := { || { IIF(aEntra[oEntra:nAt,1]=="0",oVm,IIF(aEntra[oEntra:nAt,1]=="1",oVd,IIF(aEntra[oEntra:nAt,1]=="2",oAm,IIF(aEntra[oEntra:nAt,1]=="3",oAz,oLr)))) , ;
									  aEntra[oEntra:nAt,2]  , ;
									  aEntra[oEntra:nAt,3]  , ;
									  aEntra[oEntra:nAt,4]  , ;
									  TRANSF(aEntra[oEntra:nAt,5],"@E 99999,999.99")  , ;
									  aEntra[oEntra:nAt,6] } }
									
		oEntra:lAdjustColsize := .F.
		oEntra:Refresh()

		oSaida:SetArray(aSaida)
		oSaida:bLine := { || { IIF(aSaida[oSaida:nAt,1]=="0",oVm,IIF(aSaida[oSaida:nAt,1]=="1",oVd,IIF(aSaida[oSaida:nAt,1]=="2",oAm,IIF(aSaida[oSaida:nAt,1]=="3",oAz,oLr)))) , ;
									  aSaida[oSaida:nAt,2]  , ;
									  aSaida[oSaida:nAt,3]  , ;
									  aSaida[oSaida:nAt,4]  , ;
									  TRANSF(aSaida[oSaida:nAt,5],"@E 99999,999.99")  , ;
									  aSaida[oSaida:nAt,6] } }
									
		oSaida:lAdjustColsize := .F.
		oSaida:Refresh()
		
	   oResEmp:cCaption := IIF(cTipo=="PA","Reserva","Empenho")
	   oResEmp:Refresh()
		
		oSdoEst:Refresh()
		oSdoEmp:Refresh()
		oSdoDisp:Refresh()
		
		IF ( SB1->B1_TIPO == "PI".AND.LEFT(SB1->B1_COD,2) == "33" )
			oBtn02:Hide()
			oBtn05:Show()
			oBtn06:Show()
			oBtn07:Show()
		ENDIF
		
	ENDIF
	
ENDIF

Return(lRsp)

///////////////////////////////////////////////////////////
Static Function f_checksdoend()
///////////////////////////////////////////////////////////
Local nSdo := 0

AEVAL(aEnder,{ |x| ( nSdo += x[4] ) } )
AEVAL(aEnder,{ |x| x[1] := IIF(nSdo <> nSdoEst , "0" , "1" ) } )

oEnder:SetArray(aEnder)
oEnder:bLine := {|| { IIF(aEnder[oEnder:nAt,1]=="0",oVm,oVd) , ;
							 aEnder[oEnder:nAt,2] , ;
							 aEnder[oEnder:nAt,3] , ;
							 TRANSF(aEnder[oEnder:nAt,4],"@E 99999,999.99") , ;
							 aEnder[oEnder:nAt,6] } }

oEnder:lAdjustColsize := .F.
oEnder:Refresh()

Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_310Manut(nOper)
//////////////////////////////////////////////////////////////////////////////
////nOper: 1 = Incluir ; 2 = Alterar ; 3 = Altera Localizacao ; 4 = Adiciona qty ; 5 = Subtrai qty
Local xLocal,xQtde,xLoc,cQty,cFocus
Local nItem := oEnder:nAt
Local nRow  := IIF(nOper == 1 .AND. !EMPTY(aEnder[oEnder:nAt,3]) , ( LEN(aEnder)+1 ) , oEnder:nRowPos )

IF ( nRow = 10 .OR. ( nOper > 3 .AND. EMPTY(aEnder[oEnder:nAt,3]) ) )            ///Até 9 endereço por produto ou quando for PI e, inicialmente, nao ter endereço para as opcoes de adicionar/subtrair.
	Return
ENDIF

aBEnder := ACLONE(aEnder)
xLocal  := "cGetLoc"+STR(nRow,1)
xQtde   := "nGetQty"+STR(nRow,1)
cLoc    := "oGetLoc"+STR(nRow,1)+":Show()"
cQty    := "oGetQty"+STR(nRow,1)+":Show()"
cFocus  := "oGetLoc"+STR(nRow,1)+":SetFocus()"

IF ( nOper == 1 .OR. EMPTY(aEnder[oEnder:nAt,3]) )
	IF ( !EMPTY(aEnder[oEnder:nAt,3]) )
		AADD(aEnder , { "0"             , ;
							 cAlmox          , ;
							 SPACE(15)       , ;
							 0               , ;
							 SPACE(25)       , ;
							 DTOC(ddatabase) , ;
							 SPACE(15)       , ;
							 0         } )
	ELSE
		aEnder[oEnder:nAt,2] := cAlmox
	ENDIF

	oEnder:SetArray(aEnder)
	oEnder:bLine := {|| { IIF(aEnder[oEnder:nAt,1]=="0",oVm,oVd) , ;
								 aEnder[oEnder:nAt,2] , ;
								 aEnder[oEnder:nAt,3] , ;
								 TRANSF(aEnder[oEnder:nAt,4],"@E 99999,999.99") , ;								 
								 aEnder[oEnder:nAt,6] } }

	oEnder:lAdjustColsize := .F.
	IF ( nOper == 1 )
		oEnder:GoBottom()
		nItem := LEN(aEnder)
	ENDIF	
	oEnder:Refresh()

ENDIF
	
oEnder:Disable()        ///Browse de endereçamento
oBtn01:Disable()        ///Inclui
oBtn03:Disable()        ///Confirma
oBtn04:Disable()		   ///Cancela

DO CASE
	CASE nOper < 3 
		&cLoc
		&cQty
		&xLocal := aEnder[nItem,3]
		&xQtde  := aEnder[nItem,4]
		&cFocus
		
		oBtn02:Disable()        ///Altera
		
	OTHERWISE
		IF ( nOper == 3 )
			&cLoc
			&xLocal := aEnder[nItem,3]
		ELSE
			cFocus := "oGetQty"+STR(nRow,1)+":SetFocus()"
			&cQty
			&xQtde := 0 
		ENDIF
		&cFocus
		
		oBtn05:Disable()        ///Localizacao
		oBtn06:Disable()        ///Adciona
		oBtn07:Disable()		   ///Subtrai
		
ENDCASE	

nTpOper  := nOper
lIncProc := .T.

Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_310Ender(nOpc)
//////////////////////////////////////////////////////////////////////////////
Local oLoc,oQty,nQty,xLocal,mLocal
Local nQtde
Local nX   := nZ := nSdoAnt := 0
Local lRsp := .T.
Local nRow := oEnder:nRowPos
Local cLoc := "cGetLoc"+STR(nRow,1)
Local oLoc := "oGetLoc"+STR(nRow,1)

DO CASE
   CASE nOpc == 1 
		  xLocal := &cLoc
		  mLocal := aEnder[oEnder:nAt,3]
		  
		  IF ( !EMPTY(xLocal) )
		  
			  SBE->(dbSeek(xFilial("SBE")+aEnder[oEnder:nAt,2]+xLocal))
			  
			  IF ( SBE->(EOF()) )
				  MsgStop("Código não cadastrado.","Localização")
				  lRsp := .F.
			  ELSE
			  
				  AEVAL(aEnder,{ |x| nX++ , IIF(nX<>oEnder:nAt.AND.x[3]==xLocal , nZ += 1 , nZ ) } )      ///Verifica a duplicidade de localizacao.
				  
				  IF ( nZ > 0 )
					  MsgStop("Localização informada já existe.","Atenção")
					  &cLoc := aEnder[oEnder:nAt,3]
					  &(oLoc+":Refresh()")
					  Return(.F.)
				  ENDIF
				  
				  IF ( nTpOper == 3 )                                                                    ///Opcao "Localizacao" para PI
				  
					  oLoc += ":Hide()"
					  aEnder[oEnder:nAt,3] := xLocal
					  aEnder[oEnder:nAt,6] := DTOC(ddatabase)
					  
					  &oLoc
					  
					  IF ( xLocal <> mLocal )
						  f_checksdoend()
					  ENDIF
					  
					  oEnder:SetFocus()
					  oBtn01:Enable()
					  oBtn03:Enable()
					  oBtn04:Enable()
					  oBtn05:Enable()
					  oBtn06:Enable()
					  oBtn07:Enable()
					  
				  ENDIF
			  ENDIF
		  ENDIF	  
		  
	CASE nOpc == 2 
		  nQty  := "nGetQty"+STR(nRow,1)
		  oQty  := "oGetQty"+STR(nRow,1)+":Hide()"

		  IF ( &nQty < 0 )
			  MsgStop("Valor não pode ser negativo.","Quantidade")
			  Return(.F.)
		  ENDIF
		  
		  IF ( nTpOper < 3 )
			  oLoc := "oGetLoc"+STR(nRow,1)+":Hide()"

			  IF ( &cLoc <> aEnder[oEnder:nAt,3] .OR. &nQty <> aEnder[oEnder:nAt,4] )

				  aEnder[oEnder:nAt,3] := &cLoc
				  aEnder[oEnder:nAt,4] := &nQty
				  aEnder[oEnder:nAt,6] := DTOC(ddatabase)
				  
				  IF ( nTpOper == 1 )
					  aEnder[oEnder:nAt,5] := SBE->BE_DESCRIC
				  ENDIF

			  ENDIF

			  IF ( EMPTY(&cLoc) )
				  aEnder := ACLONE(aBEnder)
			  ENDIF

			  &oLoc
			  
			  oBtn02:Enable()
			  			  
		  ELSE

			  IF ( nTpOper == 5 ) 
				  nQtde := ( aEnder[oEnder:nAt,4] - &nQty )
				  IF ( nQtde < 0 )
					  MsgStop("Quantidade não poder ficar negativa.","Atenção")
					  &nQty := 0
					  oQty  := "oGetQty"+STR(nRow,1)+":Refresh()"
					  &oQty
					  Return(.F.)
				  ENDIF
			  ENDIF	  
			  
			  nQtde := IIF(nTpOper == 4 , &nQty , ( &nQty * (-1) ) )
			  aEnder[oEnder:nAt,4] += nQtde
			  aEnder[oEnder:nAt,6] := DTOC(ddatabase)
		  
			  oBtn05:Enable()
			  oBtn06:Enable()
			  oBtn07:Enable()
			  
		  ENDIF


		  &oQty

		  oEnder:Enable()
		  oBtn01:Enable()
		  oBtn03:Enable()
		  oBtn04:Enable()			

		  f_checksdoend()
		  
		  oEnder:SetFocus()
				  
ENDCASE	

Return(lRsp)

//////////////////////////////////////////////////////////////////////////////
Static Function f_confirma()
//////////////////////////////////////////////////////////////////////////////
Local nX
Local xProduto := PADR(cProduto,30)
Local lRsp     := IIF(!lIncProc , .F. , MsgBox("Confirma a atualização de endereçamento do produto?","Escolha a opção","YESNO") )

IF ( lRsp )
	dbSelectArea("SBF")
	FOR nX:=1 TO LEN(aEnder)
		 IF ( EMPTY(aEnder[nX,7]) )
			 IF ( aEnder[nX,4] > 0 )
				 RecLock("SBF",.T.)
				 SBF->BF_FILIAL  := xFilial("SBF")
				 SBF->BF_LOCAL   := aEnder[nX,2]
				 SBF->BF_LOCALIZ := aEnder[nX,3]
				 SBF->BF_QUANT   := aEnder[nX,4]
				 SBF->BF_DATAVEN := ddatabase
				 SBF->BF_PRODUTO := xProduto
				 MsUnlock()
			 ENDIF
		 ELSEIF ( aEnder[nX,3] <> aEnder[nX,7] .OR. aEnder[nX,4] <> aEnder[nX,8] )	 
			 SBF->(dbSeek(xFilial("SBF")+aEnder[nX,2]+aEnder[nX,7]+xProduto))
			 IF ( SBF->(!EOF()) )
				 RecLock("SBF",.F.)
	 			 IF ( aEnder[nX,4] > 0 )
					 SBF->BF_LOCALIZ := aEnder[nX,3]
					 SBF->BF_QUANT   := aEnder[nX,4]
					 SBF->BF_DATAVEN := ddatabase
				 ELSE
					 SBF->BF_QUANT := 0
					 dbDelete()
				 ENDIF
				 MsUnlock()
			 ENDIF	 			 
		 ENDIF
	NEXT
	lSair := .T.
	oDlg:End()
ENDIF

Return

///////////////////////////////////////////////////////////////////////
Static Function f_cancela()        
///////////////////////////////////////////////////////////////////////
Local lRsp := IIF(!lIncProc , .F. , MsgBox("Confirma cancelamento do endereçamento do produto?","Escolha a opção","YESNO") )

IF ( lRsp )

	aEnder := ACLONE(aAEnder)
	
	f_checksdoend()
	
ENDIF
			
lIncProc := .F.
lProduto := .T.

Return

///////////////////////////////////////////////////////////
Static Function f_prtender()
///////////////////////////////////////////////////////////
Local	xProduto,xDescri,xTipo,xLocal,xQAtu,xUM
Local fArq
Local cLinDet,mProduto
Local aRows
Local nW,nReserva,nSdoDisp
Local oExcel     := FWMSEXCEL():New()
Local cWorkSheet := "LOCALIZACAO"
Local oExcelApp

cPerg := "CESTG310A "

Validperg(2)

Pergunte(cPerg,.T.)

cRelato := "CESTG310"

cLinDet := "LISTA DE ENDEREÇAMENTO"

oExcel:AddworkSheet(cWorkSheet)
oExcel:AddTable (cWorkSheet,cLinDet)
oExcel:AddColumn(cWorkSheet,cLinDet,"PRODUTO",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"DESCRIÇÃO",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"TIPO",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"ALMOX",2,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"SDO.ESTOQ.",3,2)
oExcel:AddColumn(cWorkSheet,cLinDet,"EMP/RESERVA",3,2)                                      ///Alinhamento da coluna [3] - ( 1-Left,2-Center,3-Right )
oExcel:AddColumn(cWorkSheet,cLinDet,"EST.DISPON.",3,2)                                      ///Codigo de formatação  [2] - ( 1-General,2-Number,3-Monetário,4-DateTime )
oExcel:AddColumn(cWorkSheet,cLinDet,"UM",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"ENDEREÇO",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"QUANT.",3,2)
oExcel:AddColumn(cWorkSheet,cLinDet,"DATA",2,4)
****************************************************************
////
////Filtra movimento de acordo com os parametros informados
////
cQry := "SELECT B2_COD,B2_LOCAL,B2_QATU,B2_RESERVA,B2_QEMP,B1_NARRA,B1_TIPO,B1_UM,BF_LOCALIZ,BF_QUANT,BF_DATAVEN"
cQry += " FROM "+RetSqlName("SB2")+" B2,"+RetSqlName("SB1")+" B1,"+RetSqlName("SBF")+" BF"
cQry += " WHERE B2.D_E_L_E_T_ = ' ' AND B1.D_E_L_E_T_ = ' ' AND BF.D_E_L_E_T_ = ' '"
cQry += " AND B2_FILIAL  = '"+xFilial("SB2")+"'"
cQry += " AND B2_LOCAL   = B1_LOCPAD"
cQry += " AND B2_COD     BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
cQry += " AND B1_FILIAL  = '"+xFilial("SB1")+"'"
cQry += " AND B1_COD     = B2_COD"
cQry += " AND B1_TIPO    BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQry += " AND BF_PRODUTO = B2_COD"
cQry += " AND BF_LOCALIZ BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
cQry += " AND BF_LOCAL   = B2_LOCAL"
cQry += " ORDER BY BF_PRODUTO,BF_LOCALIZ "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

TcSetField("TMP","BF_DATAVEN","D",08,0)

dbSelectArea("TMP")
dbGoTop()
ProcRegua(RECCOUNT())
Do While !Eof()
	nReserva := (TMP->B2_QEMP + TMP->B2_RESERVA)
	nSdoDisp := (TMP->B2_QATU - nReserva)
	xProduto := TMP->B2_COD
	mProduto := xProduto
	xDescri  := LEFT(TMP->B1_NARRA,70)
	xTipo    := TMP->B1_TIPO
	xLocal   := TMP->B2_LOCAL
	xQAtu    := TMP->B2_QATU
	xUM      := TMP->B1_UM
	Do While !Eof().and.TMP->B2_COD==xProduto
		aRows  := {  mProduto              , ;
						 xDescri               , ;
						 xTipo                 , ;  
						 xLocal                , ;
						 xQAtu                 , ;
						 nReserva              , ;
						 nSdoDisp              , ;
						 xUM                   , ;
						 TMP->BF_LOCALIZ       , ;
						 TMP->BF_QUANT         , ;
						 TMP->BF_DATAVEN }
	
		oExcel:AddRow(cWorkSheet,cLinDet,aRows)

		IF ( !EMPTY(mProduto) )
			mProduto := SPACE(30)
			xDescri  := SPACE(70)
			xTipo    := SPACE(02)
			xLocal   := SPACE(02)
			xUM      := SPACE(02)
			xQAtu    := 0
			nReserva := 0
			nSdoDisp := 0
		ENDIF
		
		dbSkip()
	EndDo		
Enddo

TMP->(dbCloseArea())

oExcel:Activate()
oExcel:GetXMLFile("C:\RELATO\"+cRelato)
oExcel:DeActivate()

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

cPerg := "CESTG310  "

Pergunte(cPerg,.F.)

Return

//////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg(nOpc)
//////////////////////////////////////////////////////////////////////////////
Local aRegs
Local i,j,k

DbSelectArea("SX1")
DbSetOrder(1)
aRegs :={} 

IF ( nOpc == 1 )	
	          ///Grupo|Ordem| Pegunt                         | perspa | pereng | VariaVL  | tipo| Tamanho|Decimal| Presel| GSC | Valid         |   var01   | Def01              | DefSPA1 | DefEng1 | CNT01                | var02 | Def02           | DefSPA2 | DefEng2 | CNT02 | var03 | Def03           | DefSPA3 | DefEng3 | CNT03 | var04 | Def04 | DefSPA4 | DefEng4 | CNT04 | var05 | Def05 | DefSPA5 | DefEng5 | CNT05 | F3    | GRPSX5 |
	aAdd(aRegs,{ cPerg,"01" , "Filtra Movto. Entrada       ?",   ""   ,  ""    , "mv_ch1" , "N" ,   01   ,   0   ,   1   , "C" , "          "  , "mv_par01", "Sim             " , "     " , "     " , "                  " , "   " , "Não          " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
	aAdd(aRegs,{ cPerg,"02" , "Filtra Movto. Saida         ?",   ""   ,  ""    , "mv_ch2" , "N" ,   01   ,   0   ,   1   , "C" , "          "  , "mv_par02", "Sim             " , "     " , "     " , "                  " , "   " , "Não          " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   k := 1
ELSE
	aAdd(aRegs,{ cPerg,"01" , "Do Tipo do produto          ?",   ""   ,  ""    , "mv_ch1" , "C" ,   02   ,   0   ,   0   , "G" , "          "  , "mv_par01", "                    " , "     " , "     " , "                  " , "   " , "                    " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "        " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
	aAdd(aRegs,{ cPerg,"02" , "Até o Tipo do produto       ?",   ""   ,  ""    , "mv_ch2" , "C" ,   02   ,   0   ,   0   , "G" , "          "  , "mv_par02", "                    " , "     " , "     " , "ZZ                " , "   " , "                    " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "        " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
	aAdd(aRegs,{ cPerg,"03" , "Do Produto                  ?",   ""   ,  ""    , "mv_ch3" , "C" ,   30   ,   0   ,   0   , "G" , "          "  , "mv_par03", "                    " , "     " , "     " , "                  " , "   " , "                    " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "        " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "SB1" , "    " })
	aAdd(aRegs,{ cPerg,"04" , "Até o Produto               ?",   ""   ,  ""    , "mv_ch4" , "C" ,   30   ,   0   ,   0   , "G" , "          "  , "mv_par04", "                    " , "     " , "     " , "ZZZZZZZZZZZZZZZ   " , "   " , "                    " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "        " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "SB1" , "    " })
	aAdd(aRegs,{ cPerg,"05" , "Da Localização              ?",   ""   ,  ""    , "mv_ch5" , "C" ,   15   ,   0   ,   0   , "G" , "          "  , "mv_par05", "                    " , "     " , "     " , "                  " , "   " , "                    " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "        " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "SBE" , "    " })
	aAdd(aRegs,{ cPerg,"06" , "Até a Localização           ?",   ""   ,  ""    , "mv_ch6" , "C" ,   15   ,   0   ,   0   , "G" , "          "  , "mv_par06", "                    " , "     " , "     " , "ZZZZZZZZZZZZZZZ   " , "   " , "                    " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "        " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "SBE" , "    " })
	k := 3
ENDIF

For i:=k to Len(aRegs)
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