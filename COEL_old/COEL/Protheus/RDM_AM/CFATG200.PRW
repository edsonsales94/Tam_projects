/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFATG200  ³ Autor ³ Carlos Nina           ³ Data ³24/04/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emite etiqueta de embalagem do faturamento avaliando       ³±±
±±³          ³ o peso fisico do produto versus peso informado na N.Fiscal.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Coelmatic/Manaus                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

User Function CFATG200()

Local   cArqTrab
Local   cAno,nDow,nSkip,nStop
Local   aStru    := {}
Local   xBitMap1 := "\ARQUIVOS\FOTOS\LGRL0301E.BMP" 
Local   xBitMap2 := "\ARQUIVOS\FOTOS\COEL_BAR1.BMP" 

Private oDlg,oLst,oMulti,oSerie,oNFiscal,oEmissao,oCliente,oTransp,oMunCli,oEstCli,oVolume,oEspecie,oPB,oPL,oDescri,oSQtyPeca,oQtyPeca,oTPB,oTPL,oPesoTara
Private oTBitmap1,oTBitmap2,oTBitmap3,oTBitmap4,oTBitmap5,oTBitmap6,oTBitmap7,oTBitmap8,oTBmp1,oTBmp2,oTBmp3,oBmpEmp
Private oGroup1,oGroup2,oGroup3,oGroup4,oGroup5,oGroup6,oGroup7,oGroup8,oGroup9,oGroup10,oGroup11,oGroup12,oGroup13
Private oCaptura,oSPesoProd,oPesoProd,oBProd,oEmbVol,oNumVol,oSPesoVol,oPesoVol,oSTtlPB,oSTtlPL,oSTtlPLP,oTtlPB,oTtlPL,oTtlPLP,oSSair,oSReimpr,oPesoPeca,oSTtlPP,oTtlPP
Private oFnt,oFnt2,oFnt3,oFnt3a,oFnt4,oFnt5,oFnt6,oFnt7,oFnt8,oFnt9,oFnt9a,oFnt9b,oFont24b,oPPLiqOpc,oPLiqOpc,oSInvoice,oPLst,oPVLst
Private cSerie,cNFiscal,dEmissao,cCliente,cTransp,cMunCli,cEstCli,nVolume,nSeqVol,nSeqAnt,cEspecie,nPB,nPL,cDescri,cQtyPeca,cPLiqOpc,cVolImp,mBarraOP,mBarraPV
Private nImpVol,nItemVol,nOpc,nEmbVol,nPBruto,nPLiqui,nPLq,nPeso,nPesoPeca,nPesoTara,nPLiqOpc,nOpcA,nQtdEmb,nQtdEtq,nEtqImp,nPrdImp,mQtdEtq,_nSaldo,nAIQty
Private nQtOpc1,nQtOpc2,nQtOpc3,nQtOpc4,nIEmb,nTQty
Private cCaptura,cPesoProd,cBProd,cNumVol,cPesoVol,cTTlPB,cTTlPL,cTTlPLP,cTTlPP,cVDEscri,cOPs,_cProd,_cFamilia,_cModelo,_cCodCli,_cPedCli,_cClNomCl,_cItem,_cDesc,cAI30
Private aCols,aHeader,aHeader2,aEmbOpc,aItens,aPedido,aItemPV,aPesagem,aOpcs,aVolume
Private lSair,lNFiscal,lSelPV,lBarraIT

Private mvLocal  := IIF(M->cNumEmp=="0301","02","01")    
Private _dDatRf  := CTOD("")
Private nPesagem := 0
Private lLooping := .T.
Private lPrtPV   := .F.
Private aPrtPV   := {}
Private oVd      := LoadBitmap( GetResources(), 'br_verde')
Private oVm      := LoadBitmap( GetResources(), 'br_vermelho')
Private lInverte := .F.
Private cMarca   := GetMark()
Private aCampos  := {}

Private cPerg  := "CFATG200  "

Validperg()

Pergunte(cPerg,.F.)

DEFINE FONT oFnt   NAME "Arial" Size 10,17             ///LARG. X ALT.
DEFINE FONT oFnt2  NAME "Arial" Size 10,11
DEFINE FONT oFnt3  NAME "Arial" Size 10,12
DEFINE FONT oFnt3a NAME "Arial" Size 8,16
DEFINE FONT oFnt3b NAME "Arial" Size 8,12
DEFINE FONT oFnt4  NAME "Arial" Size 10,34
DEFINE FONT oFnt4a NAME "Arial" Size 10,28
DEFINE FONT oFnt4b NAME "Arial" Size 8,34
DEFINE FONT oFnt5  NAME "Arial" Size 14,72
DEFINE FONT oFnt6  NAME "Arial" Size 9,12
DEFINE FONT oFnt7  NAME "Arial" Size 16,74
DEFINE FONT oFnt8  NAME "Arial" Size 12,14
DEFINE FONT oFnt9  NAME "Arial" Size 16,48
DEFINE FONT oFnt9a NAME "Arial" Size 11,40   
DEFINE FONT oFnt9b NAME "Arial" Size 12,54  

oFont24b := TFont():New( "Arial",,24,,.t.,,,,,.f. )

AADD(aStru,{"TB_OK"      , "C" , 02 , 0 } )
AADD(aStru,{"TB_ITEM"    , "C" , 04 , 0 } )
AADD(aStru,{"TB_NFISCAL" , "C" , 09 , 0 } )
AADD(aStru,{"TB_SERIE"   , "C" , 03 , 0 } )
AADD(aStru,{"TB_EMISSAO" , "D" , 08 , 0 } )
AADD(aStru,{"TB_VOLUME"  , "N" , 04 , 0 } )
AADD(aStru,{"TB_PESO"    , "N" , 08 , 2 } )
AADD(aStru,{"TB_VALOR"   , "N" , 14 , 2 } )
AADD(aStru,{"TB_CLIENTE" , "C" , 20 , 0 } )
AADD(aStru,{"TB_CFOP"    , "C" , 30 , 0 } )
AADD(aStru,{"TB_RECNO"   , "N" , 08 , 0 } )
cArqTrab := CriaTrab(aStru,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.F.,.F.)

aStru := {}
AADD(aStru,{"T2_OK"      , "C" , 02 , 0 } )
AADD(aStru,{"T2_PEDIDO"  , "C" , 06 , 0 } )
AADD(aStru,{"T2_ITEM"    , "C" , 02 , 0 } )
AADD(aStru,{"T2_PRODUTO" , "C" , 30 , 0 } )
AADD(aStru,{"T2_DESCRI"  , "C" , 30 , 0 } )
cArqTrab := CriaTrab(aStru,.T.)
cIndex   := CriaTrab(NIL,.F.)
cKey     := 'T2_PEDIDO+T2_ITEM+T2_PRODUTO'
dbUseArea(.T.,,cArqTrab,"TB2",.F.,.F.)
IndRegua("TB2",cIndex,cKey,,," Criando Indice ...   ")

////
////Montagem do numero da semana
////
dDatPri  := "01/01/"+SUBS(DTOC(ddatabase),7,2)  //DATA BASE DO SISTEMA
dDatPri  := CTOD(dDatPri)
cAno      := SUBS(DTOS(dDatPri),1,4)
nDow      := DOW(dDatPri)
nSkip     := IIF(nDow < 6,-1,1)
nStop     := IIF(nDow < 6,( nDow + (nDow-2) ) , 7 )
FOR nX:=nDOW TO nStop
    dDatPri += nSkip
NEXT

dbSelectArea("CCH")
dbSetOrder(1)
dbSelectArea("SA4")
dbSetOrder(1)
dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea("SA2")
dbSetOrder(1)
dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SC5")
dbSetOrder(1)
dbSelectArea("SC6")
dbSetOrder(1)
dbSelectArea("SD2")
dbSetOrder(3)

DO WHILE lLooping
	aPesagem  := {}
	aOpcM     := { {SPACE(30) , SPACE(20) , 0 , SPACE(10) , SPACE(60) } }
	aEmbOpc   := { {SPACE(3) , SPACE(30) , 0 , 0 , SPACE(60) } }
	aItens    := { {SPACE(2) , SPACE(30) , 0 , 0 , SPACE(60) , "" , "" , 0 , "0" } }
	aItemPV   := { {"0",SPACE(6),SPACE(2),SPACE(30),0,0,0,SPACE(60),0,"",0,""} }
	aBarraIT  := { {SPACE(75)} }
	aCols     := { {SPACE(6) , SPACE(40) , SPACE(30) } }
	aHeader   := {}
	aCampos   := {}
	aVolume   := {}
	*
	AADD(aHeader,{"NÚMERO    "      , "TB_NUM    " ,"@!             " ,06,0 , "ExecBlock('CFTXG200',.F.,.F.)" , "€€€€€€€€€€€€€€ ","C","TRB"})
	AADD(aHeader,{"C L I E N T E"   , "C7_NUMSC  " ,"@!             " ,40,0 , "                             " , "€€€€€€€€€€€€€€ ","C","SC7"})
	AADD(aHeader,{"DESTINO"         , "C7_NUMSC  " ,"@!             " ,30,0 , "                             " , "€€€€€€€€€€€€€€ ","C","SC7"})
	*
	AADD(aCampos , { "TB_OK"      , , "Ok"                  ,                  } )
	AADD(aCampos , { "TB_ITEM"    , , "Item"                ,                  } )
	AADD(aCampos , { "TB_NFISCAL" , , "N.Fiscal"            ,                  } )
	AADD(aCampos , { "TB_SERIE"   , , "Serie"               ,                  } )
	AADD(aCampos , { "TB_EMISSAO" , , "Dt.Emissão"          ,                  } )
	AADD(aCampos , { "TB_VOLUME"  , , "Volume"              , "@E 9999"        } )
	AADD(aCampos , { "TB_PESO"    , , "Peso"                , "@E 99999.99"    } )
	AADD(aCampos , { "TB_VALOR"   , , "Valor"               , "@E 9999999.99"  } )
	AADD(aCampos , { "TB_CLIENTE" , , "Cliente"             ,                  } )
	AADD(aCampos , { "TB_CFOP"    , , "Operação Fiscal"     ,                  } )

	cPedAnt    := SPACE(6)
	cSerie     := SPACE(3)
	cNFiscal   := SPACE(9)
	mSerie     := SPACE(3)
	mNFiscal   := SPACE(9)
	dEmissao   := SPACE(8)
	cCliente   := SPACE(40)
	cMunCli    := SPACE(20)
	cEstCli    := SPACE(2)
	cTransp    := SPACE(40)
	cColeta    := SPACE(6)
	cTranspc   := SPACE(6)
	cTranspct  := SPACE(30)
	cCodCli    := SPACE(6)
	cLojCli    := SPACE(2)
	nVolume    := 0
	nSeqVol    := 0
	nSeqAnt    := 0
	dEmissDe   := ddatabase
	dEmissAte  := ddatabase
	mdEmissDe  := CTOD("")
	mdEmissAte := CTOD("")
	cEspecie   := SPACE(15)
	cInvoice   := SPACE(10)
	cNReduz    := SPACE(20)
	cCountry   := "BRASIL"
	cPDescri   := SPACE(50)
	cVDescri   := SPACE(50)
	cVolImp    := " "
	_cItem     := ""
	_cDesc     := ""
	_cPedCli   := ""
	cOPs       := ""
	cPLiqOpc   := ""
	cAI30      := ""
	cVolFecha  := ""
	cBarraPV   := SPACE(6)
	mBarraPV   := cBarraPV
	cBarraCLI  := SPACE(20)
	cBarraOP   := SPACE(17)
	mBarraOP   := cBarraOP
	cBarraIT   := SPACE(94)
	cEmbCB     := SPACE(23)
	cEtqCodE   := ""
	cEtqDesc   := ""
	cEtqMod    := ""
	cEtqNF     := ""
	cEtqPed    := ""
	cEtqCodC   := ""
	cEtqQtd    := ""
	cEtqVol    := ""
	cEtqBar1   := ""
	cEtqBar2   := ""
	cLetra01   := cLetra02 := cLetra03 := cLetra04 := cLetra05 := cLetra06 := cLetra07 := cLetra08 := cLetra09 := cLetra10 := cLetra11 := cLetra12 := ""
	nImpVol    := 0
	nItemVol   := 0
	nPLiqOpc   := 0
	nPLq       := 0
	nPeso      := 0
	nPB        := 0
	nPL        := 0
	nPPB       := 0
	nPPL       := 0
	n          := 1
	nOpc       := 0
	nOpcA      := 0
	nTQty      := 0   ///Controla as leituras (codigo de barra) dos itens do pedido (aItemPV)
	nAIQty     := 0
	nQtdEmb    := 0
	nQtdEtq    := 0
	nEtqImp    := 0
	nPrdImp    := 0
	_nSaldo    := 0
	nCount     := 0
	nTtItem    := 0
	nTtVol     := 0
	nTtPeso    := 0
	nTtVlr     := 0
	lNFiscal   := .F.
	lSeqVol    := .F.
	lSair      := .F.
	lSelPV     := .F.
	lBarraIT   := .F.
	
	dbSelectArea("TRB")
	dbGoTop()
	//
	dbSelectArea("SC7")
	dbSetOrder(1)
	
	DEFINE MSDIALOG oDlg TITLE ":::... CONTROLE DE COLETA - EXPEDIÇÃO ...:::" FROM 000, 000  TO 516, 1010 COLORS 0, 16777215 PIXEL

	oTBar := TBar():New( oDlg,40,25,.T.,,,'tbar_coel',.F. )   

   @ 016, 002 GROUP oGroup1 TO 111, 261 PROMPT "NOTA FISCAL DE SAÍDA" 			  	                          OF oDlg COLOR 0, 16777215 PIXEL   
   @ 113, 002 GROUP oGroup3 TO 253, 261 PROMPT "ITENS DA NOTA FISCAL"   		  	                          OF oDlg COLOR 0, 16777215 PIXEL   
   @ 145, 263 GROUP oGroup4 TO 253, 504 PROMPT "EMBALAGEM / OPCIONAIS"          	                          OF oDlg COLOR 0, 16777215 PIXEL

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////NOTA FISCAL
   @ 024, 005 SAY   	oSSerie      PROMPT OemToAnsi("Série")            					   SIZE 025, 007 OF oDlg COLOR CLR_BLUE     PIXEL
   @ 024, 035 SAY   	oSNumero     PROMPT OemToAnsi("Número")           					   SIZE 025, 007 OF oDlg COLOR CLR_BLUE     PIXEL
   @ 031, 005 MSGET 	oSerie       VAR    cSerie       						  					SIZE 015, 010 OF oDlg COLORS 0, 16777215 PIXEL                    WHEN !lNFiscal
   @ 031, 035 MSGET 	oNFiscal     VAR    cNFiscal     						  					SIZE 045, 010 OF oDlg COLORS 0, 16777215 PIXEL VALID f_nfiscal2() WHEN !lNFiscal
   @ 024, 086 SAY   	oSCliente    PROMPT OemToAnsi("Razão Social do Destinatário") 	   SIZE 085, 007 OF oDlg COLORS 0, 16777215 PIXEL
   @ 031, 086 MSGET 	oCliente     VAR    cCliente     						  					SIZE 140, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
   @ 046, 005 SAY   	oSEmissao    PROMPT OemToAnsi("Data de Emissão")  					   SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL  
   @ 053, 005 MSGET 	oEmissao     VAR    dEmissao     						  					SIZE 045, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
   @ 046, 086 SAY   	oSMunCli     PROMPT OemToAnsi("Municipio")        						SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
   @ 053, 086 MSGET 	oMunCli      VAR    cMunCli      						  					SIZE 110, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
   @ 046, 210 SAY   	oSEstCli     PROMPT OemToAnsi("UF") 										SIZE 015, 007 OF oDlg COLORS 0, 16777215 PIXEL
   @ 053, 210 MSGET 	oEstCli      VAR    cEstCli      						  					SIZE 016, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

   @ 068, 005 SAY   	oSTransp     PROMPT OemToAnsi("Transportador")    						SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
   @ 075, 005 MSGET 	oTransp      VAR    cTransp      						  					SIZE 152, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
   @ 089, 005 SAY   	oSVolume     PROMPT OemToAnsi("Volume") 									SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
   @ 068, 163 SAY   	oSInvoice    PROMPT OemToAnsi("Commercial Invoice")  					SIZE 060, 007 OF oDlg COLOR  CLR_BLUE    PIXEL
   @ 075, 163 MSGET 	oInvoice     VAR    cInvoice Picture "@!"				  					SIZE 063, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN (!lNFiscal.AND.cEstCli == "EX") Valid f_invoice()
   @ 096, 005 MSGET 	oVolume      VAR    nVolume      						  					SIZE 025, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
   @ 089, 040 SAY   	oSEspecie    PROMPT OemToAnsi("Espécie")          						SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
   @ 096, 040 MSGET 	oEspecie     VAR    cEspecie     						  					SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
   @ 089, 111 SAY   	oSPB         PROMPT OemToAnsi("Peso Bruto")       						SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
   @ 096, 111 MSGET  oPB          VAR    nPB   Picture "@E 99999.999"	  					SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
   @ 089, 163 SAY    oSPL         PROMPT OemToAnsi("Peso Líquido")     						SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
   @ 096, 163 MSGET  oPL          VAR    nPL   Picture "@E 99999.999" 	  					SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
	
	@ 237, 006 Say    oDescri      VAR cDescri                     	Size 250, 018 PIXEL OF oDlg  FONT oFnt4   COLOR CLR_HBLUE  
	
	oLst := TCBrowse():New( 120 , 004, 255, 114,,{"","ITEM","PRODUTO","QUANT.","P.LIQUIDO","P.BRUTO"},{20,20,70,40,40,40},oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	

	oLst:SetArray(aItens)
	oLst:bChange := { || f_descpro(oLst:nAt,2) }  
	oLst:bLine   := { || { IIF(aItens[oLst:nAt,9]=="1",oVd,oVm)  , ;
								  aItens[oLst:nAt,1]  , ;
								  aItens[oLst:nAt,2]  , ;
							     aItens[oLst:nAt,3]  , ;
							     aItens[oLst:nAt,4]  , ;
							     aItens[oLst:nAt,8] } }
								
	oLst:lAdjustColsize := .F.

	oMulti := TCBrowse():New( 152 , 265, 236, 084,,{"TIPO","PRODUTO","QTDE.","PESO"},{40,60,40,40},oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	

	oMulti:SetArray(aEmbOpc)
	oMulti:bChange    := { || f_descpro(oMulti:nAt,3) }  
	oMulti:bldblclick := { || IIF(nOpc==5 , nil , f_editaitem(oMulti:nAt,1) ) }  	     ///Incluir     IIF(nOpc == 4 , f_editaitem(oMulti:nAt,1) , nil )
	oMulti:brClicked  := { || IIF(nOpc==5 , nil , f_editaitem(oMulti:nAt,2) ) }  	     ///Alterar     IIF(nOpc == 4 , f_editaitem(oMulti:nAt,2) , nil )
	oMulti:bLine      := { || { aEmbOpc[oMulti:nAt,1]  , ;
										 aEmbOpc[oMulti:nAt,2]  , ;
										 aEmbOpc[oMulti:nAt,3]  , ;
										 aEmbOpc[oMulti:nAt,4] } }
								
	oMulti:lAdjustColsize := .F.

	@ 237, 265 Say    oVDescri      VAR cVDescri                     	  		  Size 250, 018 OF oDlg PIXEL COLOR CLR_HBLUE FONT oFnt4 
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////PEDIDO DE VENDA
	////
   @ 016, 002 GROUP oGroupP1 TO 103, 261 PROMPT "PEDIDO DE VENDA"                			      OF oDlg COLOR 0, 16777215 PIXEL   
   @ 105, 002 GROUP oGroupP2 TO 253, 261 PROMPT "ITENS DO PEDIDO"                               OF oDlg COLOR 0, 16777215 PIXEL   
	
	@ 024, 005 TO 088,258 MULTILINE MODIFY  Object oPedido

	@ 089,005 Say   oPPLiqOpc       PROMPT OemToAnsi("Peso Líquido:")         Size 100,14  PIXEL OF oDlg  FONT  oFnt4a  COLOR CLR_HRED  
	@ 089,080 Say   oPLiqOpc        VAR    cPLiqOpc                           Size 090,14  PIXEL OF oDlg  FONT  oFnt4a  COLOR CLR_HRED  
	@ 237,006 Say   oPDescri        VAR    cPDescri                  	  		  Size 250,18  PIXEL OF oDlg  FONT  oFnt4   COLOR CLR_HBLUE
	
	oPLst := TCBrowse():New( 112 , 005, 254, 124,,{"","PEDIDO","ITEM","PRODUTO","QTD.PED/EMB","QTD.LIB.","P. LIQ.","P.BRUTO"},{20,30,18,60,40,35,35,35},oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	

	oPLst:SetArray(aItemPV)
	oPLst:bChange    := { || f_descpro(oPLst:nAt,1) }  
	oPLst:bldblclick := { || f_liberaitem(oPLst:nAt) }  	
	oPLst:bLine      := { || { IIF(aItemPV[oPLst:nAt,1]=="1",oVd,oVm)  , ;
								          aItemPV[oPLst:nAt,2]  , ;
							             aItemPV[oPLst:nAt,3]  , ;
							             aItemPV[oPLst:nAt,4]  , ;
							             aItemPV[oPLst:nAt,5]  , ;
							             aItemPV[oPLst:nAt,6]  , ;
							             aItemPV[oPLst:nAt,7]  , ;
											 aItemPV[oPLst:nAt,11] } }
								
	oPLst:lAdjustColsize := .F.

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////VIA COLETOR  
	////
   @ 016, 263 GROUP oGroupN1 TO 142, 504 PROMPT "LEITURA"                        			            OF oDlg COLOR 0, 16777215 PIXEL   
	@ 024,267 Say    oCBOP                PROMPT "Código de Barras (O.P)"                 Size 110,10  PIXEL OF oDlg  FONT oFnt3a   COLOR CLR_HBLUE 
   @ 032,267 MSGET  oBarraOP             VAR cBarraOP  						  					  Size 120,14  OF oDlg COLORS 0, 16777215 PIXEL FONT oFnt4 VALID f_barraop()
	@ 052,267 Say    oCBPV                PROMPT "Nro.Pedido"                             Size 080,10  PIXEL OF oDlg  FONT oFnt3a   COLOR CLR_HBLUE 
   @ 060,267 MSGET  oBarraPV             VAR cBarraPV  						  					  Size 060,14  OF oDlg COLORS 0, 16777215 PIXEL FONT oFnt4 VALID f_barrapv2()
	@ 082,267 Say    oCBIT                PROMPT "Item Pedido"                            Size 080,10  PIXEL OF oDlg  FONT oFnt3a   COLOR CLR_HBLUE 

	@ 089,005 Say    oPVolFecha           PROMPT OemToAnsi("Volume Fechado:")             Size 100,14  PIXEL OF oDlg  FONT  oFnt4a  COLOR CLR_HRED  
	@ 089,090 Say    oVolFecha            VAR    cVolFecha                                Size 080,14  PIXEL OF oDlg  FONT  oFnt4a  COLOR CLR_HBLUE 
	
	oBarraIT := tComboBox():New(089,267, {|u3|if(PCount()>0,cBarraIT := u3 , cBarraIT )} , aBarraIT,235,10,oDlg,,/*funcao*/,,,,.T.,oFnt4b,,,,,,,,'cBarraIT')    
	oBarraIT:bChange := { || f_barraIT(cBarraIT) } 
	oBarraIT:SetHeight(26)
	
	@ 110,267 Say    oCBCLI               PROMPT "Cliente"                                Size 080,10  PIXEL OF oDlg  FONT oFnt3a 
   @ 117,267 MSGET  oBarraCLI            VAR cBarraCLI  						  					  Size 234,14  OF oDlg COLORS 0, 16777215 PIXEL FONT oFnt4 WHEN .F.

	@ 091,200 BUTTON oBtn01               PROMPT "Exclui Leitura" 			                 SIZE 050,11  PIXEL OF oDlg Action Eval( { || f_excluileitura()	} )   
	
	oTBmpB1 := TBtnBmp2():New( 040, 930, 70, 30,'coel_abortar',,,,;
						{ || f_encervol() } , oDlg,'Finaliza a coleta do(s) Pedido(s)',,.F.,.F.)

	oTBmpB2 := TBtnBmp2():New( 070, 930, 70, 30,'coel_closevol',,,,;
						{ || f_fechavol() } , oDlg,'Efetua a pesagem do volume',,.F.,.F.)

	oTBmp4v := TBtnBmp2():New( 040, 930, 70, 30,'conf_coel',,,,;   
						{ || f_confvcol() }  , oDlg,'Confirma pesagem do Volume',,.F.,.F.)
						
	oTBmp5v := TBtnBmp2():New( 070, 930, 70, 30,'canc_coel',,,,;
						{ || f_cancvcol() } , oDlg,'Cancela pesagem do Volume',,.F.,.F.)

	oTBmpB3 := TBtnBmp2():New( 120, 930, 70, 30,'canc_coel',,,,;
						{ || f_cancelvol() } , oDlg,'Cancela processo de coleta do(s) Pedido(s)',,.F.,.F.)
						
	///==========================================================================================================================================================================
	@ 020,266 Say oSayBalanca          PROMPT "Balança"                                Size 060,18  PIXEL OF oDlg  FONT oFnt9a  COLOR CLR_HBLUE  
	@ 036,274 Say oSayCaptura          VAR    cCaptura                                 Size 060,18  PIXEL OF oDlg  FONT oFnt9a  COLOR CLR_HBLUE  
	@ 054,263 GROUP oGroup6 TO 055,504 PROMPT ""                                                          OF oDlg PIXEL             
	@ 033,441 Say oSReimpr             PROMPT "Imprimir"                               Size 070,24  PIXEL OF oDlg  FONT oFnt3a  COLOR CLR_HBLUE  
	@ 033,481 Say oSSair               PROMPT "Sair"                                   Size 040,24  PIXEL OF oDlg  FONT oFnt3a  COLOR CLR_HBLUE  

	///Captura Produto
	@ 019,263 GROUP oGroup5 TO 126,504 PROMPT ""                                                          OF oDlg PIXEL             
	@ 055,266 Say oSPesoProd           PROMPT "Peso Produto:"                          Size 080,24  PIXEL OF oDlg  FONT oFnt9b  COLOR CLR_HRED  
	@ 055,428 Say oPesoProd            VAR    cPesoProd                                Size 080,24  PIXEL OF oDlg  FONT oFnt9b  COLOR CLR_HRED  
	@ 090,266 Say oBProd               VAR    cBProd                                   Size 250,18  PIXEL OF oDlg  FONT oFnt4   COLOR CLR_HBLUE
	
	///==========================================================================================================================================================================
	///Captura Volume
	@ 019,263 GROUP oGroup7  TO 142,504 PROMPT ""                                                         OF oDlg  PIXEL             
	@ 055,266 GROUP oGroup8  TO 079,340 PROMPT "Peso Embalagem (Kg)"                                      OF oDlg  PIXEL
	@ 055,360 GROUP oGroup9  TO 079,431 PROMPT "Numeração Volume"                                         OF oDlg  PIXEL
	@ 020,266 GROUP oGroupCB TO 046,431 PROMPT "Embalagem (Código de Barras)"                             OF oDlg  PIXEL
	@ 027,268 MSGET oEmbCB              VAR    cEmbCB                                  Size 160,14        OF oDlg  PIXEL FONT oFnt4                    VALID f_embcb()
	@ 062,290 Say   oEmbVol             VAR    nEmbVol      Picture "@E 999.999"       Size 070,14  PIXEL OF oDlg  FONT  oFnt4  
	@ 062,385 Say   oNumVol             VAR    cNumVol                                 Size 070,14  PIXEL OF oDlg  FONT  oFnt4
	@ 082,263 GROUP oGroup10 TO 083,504 PROMPT ""                                                         OF oDlg  PIXEL             
	@ 082,266 Say   oSPesoVol           PROMPT "Peso Volume:"                          Size 080,24  PIXEL OF oDlg  FONT  oFnt9b  COLOR CLR_HRED  
	@ 082,428 Say   oPesoVol            VAR    cPesoVol                                Size 070,24  PIXEL OF oDlg  FONT  oFnt9b  COLOR CLR_HRED  
	@ 108,263 GROUP oGroup11 TO 109,504 PROMPT ""                                                         OF oDlg  PIXEL             
	@ 108,266 Say   oSTtlPB             PROMPT "Total Peso Bruto:"                     Size 080,16  PIXEL OF oDlg  FONT  oFnt4   COLOR CLR_HBLUE
	@ 108,438 Say   oTtlPB              VAR    cTtlPB                                  Size 070,16  PIXEL OF oDlg  FONT  oFnt4   COLOR CLR_HBLUE
	@ 125,266 Say   oSTtlPL             PROMPT "Total Peso Líquido:"                   Size 080,16  PIXEL OF oDlg  FONT  oFnt4   COLOR CLR_HBLUE
	@ 125,438 Say   oTtlPL              VAR    cTtlPL                                  Size 070,16  PIXEL OF oDlg  FONT  oFnt4   COLOR CLR_HBLUE
	///oPrinter := tComboBox():New(043,441,{|u3|if(PCount()>0,cPrinter := u3 , cPrinter )}, aPrt,45,10,oDlg,,/*funcao*/,,,,.T.,/*fonte*/,,,,,,,,'cPrinter')     

	///==========================================================================================================================================================================
	///Captura Contagem
	@ 055,266 GROUP oGroup12 TO 079,340 PROMPT "Peso Líquido da peça (Kg)"                                OF oDlg  PIXEL
	@ 055,360 GROUP oGroup13 TO 079,432 PROMPT "Peso Tara (Kg)"                                           OF oDlg  PIXEL
	@ 064,270 MsGet oPesoPeca           VAR    nPesoPeca    Picture "@E 999.999"       Size 010,10  PIXEL OF oDlg  FONT  oFnt4
	@ 064,364 MsGet oPesoTara           VAR    nPesoTara    Picture "@E 999.999"       Size 010,10  PIXEL OF oDlg  FONT  oFnt4
	@ 082,266 Say   oSQtyPeca           PROMPT "Quantidade de peças:"                  Size 120,22  PIXEL OF oDlg  FONT  oFnt9b  COLOR CLR_HRED  
	@ 082,428 Say   oQtyPeca            VAR    cQtyPeca                                Size 070,22  PIXEL OF oDlg  FONT  oFnt9b  COLOR CLR_HRED  
	@ 108,266 Say   oSTtlPP             PROMPT "Total de peças:"                       Size 080,16  PIXEL OF oDlg  FONT  oFnt4   COLOR CLR_HBLUE
	@ 108,438 Say   oTtlPP              VAR    cTtlPP                                  Size 070,16  PIXEL OF oDlg  FONT  oFnt4   COLOR CLR_HBLUE

	///==========================================================================================================================================================================
	///                                                               Etiqueta MetalFrio                                                                                         
	///==========================================================================================================================================================================
	@ 156,263 GROUP oGroupM2 TO 178,329   PROMPT "Qtde.Produto na Caixa"                           OF oDlg  PIXEL
	@ 156,335 GROUP oGroupM3 TO 178,391   PROMPT "Qtde. de Caixa(s)"                               OF oDlg  PIXEL
	@ 156,397 GROUP oGroupM5 TO 178,462   PROMPT "Numeração Volume"                                OF oDlg  PIXEL
	@ 164,270 MSGET oQtdEmb 		        VAR    nQtdEmb      PICTURE "@E 9999"		SIZE 030, 010 OF oDlg  PIXEL COLORS 0, 16777215 Font oFnt
	@ 164,342 MSGET oQtdEtq   	           VAR    nQtdEtq      PICTURE "@E 999"			SIZE 030, 010 OF oDlg  PIXEL COLORS 0, 16777215 Font oFnt Valid(_fVlDlg("QETQ")) 
	@ 164,401 MsGet oSeqVol               VAR    nSeqVol      Picture "@E 999"       Size 022, 010 OF oDlg  PIXEL                    FONT oFnt ///WHEN lSeqVol
	@ 164,431 MsGet oVolImp               VAR    cVolImp                             Size 026, 010 OF oDlg  PIXEL                    FONT oFnt WHEN .F.

   @ 179,263 GROUP oGroupM4 TO 253,504 PROMPT "OPCIONAIS"                                         OF oDlg  PIXEL 

	oOpcM := TCBrowse():New( 187 , 265, 236, 064,,{"COD.COEL","COD.CLIENTE","QTDE.","PEDIDO CLIENTE"},{60,50,40,50},oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	

	oOpcM:SetArray(aOpcM)
	oOpcM:bChange    := { || f_descpro(oOpcM:nAt,9) }  
	oOpcM:bldblclick := { || f_edtitem(oOpcM:nAt,1) }  	     ///Incluir
	oOpcM:brClicked  := { || f_edtitem(oOpcM:nAt,2) }  	     ///Alterar
	oOpcM:bLine      := { || { aOpcM[oOpcM:nAt,1] , ;
										aOpcM[oOpcM:nAt,2] , ;
										aOpcM[oOpcM:nAt,3] , ;
										aOpcM[oOpcM:nAt,4] } }
								
	oOpcM:lAdjustColsize := .F.
	
	oTBmp10 := TBtnBmp2():New( 314, 936, 70, 30,'conf_coel',,,,;                           ////38
						{ || f_etqmetal() }  , oDlg,'Impressão da etiqueta',,.F.,.F.)
						
	@ 019,283 GROUP  oGroupM6 TO 154,456   PROMPT ""                             OF oDlg  PIXEL
	@ 021,286 BITMAP oBmpEmp                                       SIZE 083,048  OF oDlg  PIXEL NOBORDER     ///63,40
	oBmpEmp:Load(,xBitMap1)

	@ 034,285 GROUP  oGroupM7 TO 036,454   PROMPT ""                             OF oDlg  PIXEL
	@ 038,295 GROUP  oGroupM8 TO 068,296   PROMPT ""                             OF oDlg  PIXEL
	@ 039,288 Say    oLetraC               PROMPT "C"              SIZE 010,007  OF oDlg  PIXEL 
	@ 045,288 Say    oLetraO               PROMPT "O"              SIZE 010,007  OF oDlg  PIXEL
	@ 051,288 Say    oLetraE               PROMPT "E"              SIZE 010,007  OF oDlg  PIXEL
	@ 057,288 Say    oLetraL               PROMPT "L"              SIZE 010,007  OF oDlg  PIXEL
	@ 039,298 Say    oEtqCodE              VAR    cEtqCodE         SIZE 180,010  OF oDlg  PIXEL FONT oFnt3a
	@ 048,298 Say    oEtqMod               VAR    cEtqMod          SIZE 180,010  OF oDlg  PIXEL FONT oFnt3a
	@ 057,298 Say    oEtqDesc              VAR    cEtqDesc         SIZE 240,010  OF oDlg  PIXEL FONT oFnt3a
	@ 069,285 GROUP  oGroupMC TO 071,454   PROMPT ""                             OF oDlg  PIXEL
	@ 073,295 GROUP  oGroupMD TO 144,296   PROMPT ""                             OF oDlg  PIXEL
	@ 075,288 Say    oLetra01              VAR    cLetra01         SIZE 010,007  OF oDlg  PIXEL
	@ 081,288 Say    oLetra02              VAR    cLetra02         SIZE 010,007  OF oDlg  PIXEL
	@ 087,288 Say    oLetra03              VAR    cLetra03         SIZE 010,007  OF oDlg  PIXEL
	@ 093,288 Say    oLetra04              VAR    cLetra04         SIZE 010,007  OF oDlg  PIXEL
	@ 099,288 Say    oLetra05              VAR    cLetra05         SIZE 010,007  OF oDlg  PIXEL
	@ 105,288 Say    oLetra06              VAR    cLetra06         SIZE 010,007  OF oDlg  PIXEL
	@ 111,288 Say    oLetra07              VAR    cLetra07         SIZE 010,007  OF oDlg  PIXEL
	@ 117,288 Say    oLetra08              VAR    cLetra08         SIZE 010,007  OF oDlg  PIXEL
	@ 123,288 Say    oLetra09              VAR    cLetra09         SIZE 010,007  OF oDlg  PIXEL
	@ 129,288 Say    oLetra10              VAR    cLetra10         SIZE 010,007  OF oDlg  PIXEL
	@ 135,288 Say    oLetra11              VAR    cLetra11         SIZE 010,007  OF oDlg  PIXEL
	@ 141,288 Say    oLetra12              VAR    cLetra12         SIZE 010,007  OF oDlg  PIXEL
	@ 075,298 Say    oEtqNF                VAR    cEtqNF           SIZE 120,010  OF oDlg  PIXEL FONT oFnt3a
	@ 084,298 Say    oEtqPed               VAR    cEtqPed          SIZE 120,010  OF oDlg  PIXEL FONT oFnt3a
	@ 093,298 Say    oEtqCodC              VAR    cEtqCodC         SIZE 120,010  OF oDlg  PIXEL FONT oFnt3a
	@ 102,298 Say    oEtqQtd               VAR    cEtqQtd          SIZE 120,010  OF oDlg  PIXEL FONT oFnt3a
	@ 111,298 Say    oEtqVol               VAR    cEtqVol          SIZE 120,010  OF oDlg  PIXEL FONT oFnt3a

	@ 124,327 BITMAP oBmpBar1 RESOURCE 'coel_op01.bmp'             SIZE 206,040  OF oDlg  PIXEL NOBORDER
	@ 144,361 Say    oEtqBar1              VAR    cEtqBar1         SIZE 100,007  OF oDlg  PIXEL
	oBmpBar1:lAutoSize := .T.	
	
	@ 075,417 BITMAP oBmpBar2                                      SIZE 032,082  OF oDlg  PIXEL NOBORDER
	oBmpBar2:Load(,xBitMap2)
	
	/////////                                                           FIM METALFRIO                                                          //////////

	///==========================================================================================================================================================================
	///                                                       Planilha de Coleta do Faturamento - Data-Entry                                                                                 
	///==========================================================================================================================================================================
   @ 016, 002 GROUP oGroupM9 TO 046, 320 PROMPT "PARAMETROS - COLETA"             			  	                 OF oDlg PIXEL COLOR 0, 16777215
   @ 016, 322 GROUP oGroupMA TO 046, 460 PROMPT "TOTALIZAÇÃO"                     			  	                 OF oDlg PIXEL COLOR 0, 16777215
   @ 048, 002 GROUP oGroupMB TO 253, 504 PROMPT "SELECIONAR NOTAS FISCAIS"        			  	                 OF oDlg PIXEL COLOR 0, 16777215
   @ 024, 005 SAY   oColet               PROMPT OemToAnsi("Coleta Nº")        					   SIZE 045, 007 OF oDlg PIXEL COLOR CLR_BLUE
   @ 024, 049 SAY   oEmisDe              PROMPT OemToAnsi("Emissão De")       					   SIZE 045, 007 OF oDlg PIXEL COLOR CLR_BLUE
   @ 024, 095 SAY   oEmisAte             PROMPT OemToAnsi("Emissão Até")      					   SIZE 045, 007 OF oDlg PIXEL COLOR CLR_BLUE     
   @ 024, 140 SAY   oTranspc             PROMPT OemToAnsi("Transportador")    					   SIZE 045, 007 OF oDlg PIXEL COLOR CLR_BLUE     
   @ 031, 005 SAY   oColeta              VAR    cColeta       	   Picture "@R 99/9999" 			SIZE 040, 012 OF oDlg PIXEL COLORS 0, 16777215 FONT  oFnt4a 
   @ 031, 049 MSGET oEmissDe             VAR    dEmissDe      						  						SIZE 040, 010 OF oDlg PIXEL COLORS 0, 16777215                    
   @ 031, 095 MSGET oEmissAte            VAR    dEmissAte     						  						SIZE 040, 010 OF oDlg PIXEL COLORS 0, 16777215 VALID f_seekcol()
   @ 031, 140 MSGET oTranspct            VAR    cTranspc      		Picture "@!"     F3 "SA4"  	SIZE 025, 010 OF oDlg PIXEL COLORS 0, 16777215 VALID f_transp()
   @ 030, 175 SAY   oTranspctd           VAR    cTranspct     	   Picture "@!"        				SIZE 150, 012 OF oDlg PIXEL COLORS 0, 16777215 FONT  oFnt3b
   @ 024, 325 SAY   oTtlVol              PROMPT OemToAnsi("Volume")           					   SIZE 040, 007 OF oDlg PIXEL COLOR CLR_BLUE     
   @ 024, 355 SAY   oTtlPeso             PROMPT OemToAnsi("Peso (Kg)")          					   SIZE 060, 007 OF oDlg PIXEL COLOR CLR_BLUE     
   @ 024, 401 SAY   oTtlVlr              PROMPT OemToAnsi("Valor (R$)")            					SIZE 070, 007 OF oDlg PIXEL COLOR CLR_BLUE     
   @ 031, 325 MSGET oTtVol               VAR    nTtVol        		Picture "@E 99999"				SIZE 025, 010 OF oDlg PIXEL COLORS 0, 16777215 WHEN .F.
   @ 031, 355 MSGET oTtPeso              VAR    nTtPeso       		Picture "@E 99999.99"      	SIZE 035, 010 OF oDlg PIXEL COLORS 0, 16777215 WHEN .F.
   @ 031, 401 MSGET oTtVlr               VAR    nTtVlr        		Picture "@E 99999,999.99"  	SIZE 055, 010 OF oDlg PIXEL COLORS 0, 16777215 WHEN .F.

	oMark := MsSelect():New("TRB","TB_OK",,aCampos,@lInverte,@cMarca,{056,005,250,502},,oDlg,,)
	oMark:oBrowse:bldblclick := { || f_Mark() }   

	oTBmp4c := TBtnBmp2():New( 030, 930, 70, 30,'conf_coel',,,,;   
						{ || Processa( {|| f_printcol() } ) } , oDlg,'Confirma Planilha de Coleta',,.F.,.F.)
	oTBmp5c := TBtnBmp2():New( 060, 930, 70, 30,'canc_coel',,,,;
						{ || ( lSair := .T. , nOpc := 0 , oDlg:End() ) } , oDlg,'Cancela Planilha de Coleta',,.F.,.F.)
	
	/////////=======================================           FIM - PLANILHA INTERNACAO            ===========================================//////////
	
	oTBmp1 := TBtnBmp2():New( 045, 710, 093, 053,'p_toledo' , , , ,; 
						{ || f_cappeso() } ,oDlg,'Captura peso',,.F.,.F.)
						
	oTBmp2 := TBtnBmp2():New( 030, 848, 093, 053,'print02' , , , ,;  
						{ || f_impretq() } ,oDlg,'Re-impressão da etiqueta atual',,.F.,.F.)
						
	oTBmp3 := TBtnBmp2():New( 038, 954, 040, 040,'btncansmall_ocean' , , , ,; 
						{ || f_captsair() } ,oDlg,'Encerra captura',,.F.,.F.)
	////////			
	oTBmp4 := TBtnBmp2():New( 040, 854, 70, 30,'conf_coel',,,,;   
						{ || f_confpv() }  , oDlg,'Confirma Pedido',,.F.,.F.)
						
	oTBmp5 := TBtnBmp2():New( 040, 930, 70, 30,'canc_coel',,,,;
						{ || f_cancpesag() } , oDlg,'Cancela pesagem dos Pedidos',,.F.,.F.)

	oTBmp8 := TBtnBmp2():New( 070, 930, 70, 30,'coel_abortar',,,,;
						{ || IIF(nOpc==4 , f_cancbalpv() , IIF(nOpc==9 , f_encermetal() , f_encernf() ) ) } , oDlg,'Encerra pesagem',,.F.,.F.)

	oTBmp9 := TBtnBmp2():New( 070, 854, 70, 30,'print02' , , , ,;  
						{ || f_prtetqpv() } ,  oDlg,'Impressão da Etiqueta',,.F.,.F.)
	////////										
	oTBmp6 := TBtnBmp2():New( 174, 360, 70, 30,'conf_coel',,,,;   
						{ || IIF(lSelPV , f_balancapv() , nil ) }  , oDlg,'Confirma Pedido e processa peso dos itens do Pedido',,.F.,.F.)               ///nOpc = 4
						
	oTBmp7 := TBtnBmp2():New( 174, 450, 70, 30,'canc_coel',,,,;
						{ || IIF(nOpc==9 , f_cancmetal() , f_cancpv() ) } , oDlg,'Cancela pesagem do Pedido',,.F.,.F.)
						
	///=================================================================================================
	
	oTBitmap1 := TBtnBmp2():New( 00, 00, 40, 70, 'S4WB008N' ,,,,;
						{ || Calculadora() }  ,oTBar,'Calculadora',,.F.,.F.)
	oTBitmapN := TBtnBmp2():New( 00, 00, 40, 70,'coel-colet01' , , , ,;
						{|| IIF(nOpc==0 , f_coletor() , nil ) }  ,oTBar,'Coleta seletiva pelo Produto via Codigo de Barras',,.F.,.F.)                  ///nOpc = 7
	oTBitmap2 := TBtnBmp2():New( 00, 00, 40, 70,'pedido' , , , ,;
						{|| IIF(nOpc==0 , f_pedido() , nil ) }  ,oTBar,'Coleta seletiva pelo Pedido de Venda',,.F.,.F.)                                ///nOpc = 1
	oTBitmap3 := TBtnBmp2():New( 00, 00, 40, 70,'prtetq' , , , ,;
						{|| IIF(nOpc==0 , f_nfiscal() , nil ) }  ,oTBar,'Imprime etiqueta de embalagem da Nota Fiscal faturada',,.F.,.F.)              ///nOpc = 5
	oTBitmap4 := TBtnBmp2():New( 00, 00, 40, 70,'altera' , , , ,;
						{|| IIF(nOpc==1.OR.nOpc==7 , f_pesoprod() , nil ) }  ,oTBar,'Obter peso do produto via balança',,.F.,.F.)                      ///nOpc = 3
	oTBitmap5 := TBtnBmp2():New( 00, 00, 40, 70,'balanca' , , , ,;
						{|| IIF(nOpc == 0 , f_contagem() , nil ) }  ,oTBar,'Contagem de peças por pesagem',,.F.,.F.)                                   ///nOpc = 2
	oTBitmapM := TBtnBmp2():New( 00, 00, 40, 70,'pmsprint' , , , ,;
						{|| IIF(nOpc==0 , f_metalfrio() , nil ) }  ,oTBar,'Imprime Etiqueta da Metalfrio',,.F.,.F.)   
	oTBitmap8 := TBtnBmp2():New( 00, 00, 40, 70,'pmsprint' , , , ,;
						{|| IIF(nOpc==0 , f_Etiqueta() , nil ) }  ,oTBar,'Imprime Etiqueta Padrao',,.F.,.F.)   //Rogerio						                                 ///nOpc = 9
	oTBitmap6 := TBtnBmp2():New( 00, 00, 40, 70,'parametros' , , , ,;                                                 //Rogerio
						{|| Pergunte(cPerg,.T.) }  ,oTBar,'Parametros',,.F.,.F.)
	oTBitmapP := TBtnBmp2():New( 00, 00, 40, 70,'pmsexcel' , , , ,;
						{|| IIF(nOpc==0.AND.nPesagem > 0 , f_printPV() , nil ) }  ,oTBar,'Imprime o(s) Pedido(s) processado(s) para Faturamento',,.F.,.F.)
	oTBitmapC := TBtnBmp2():New( 00, 00, 40, 70,'selectall' , , , ,;
						{|| IIF(nOpc == 0 , f_coleta() , nil ) }  ,oTBar,'Gera a Planilha de Internação',,.F.,.F.)
	oTBitmap7 := TBtnBmp2():New( 00, 00, 40, 70, 'button_exit' ,,,,;
						{ || f_saida() }  ,oTBar,'Sair',,.F.,.F.)
	
	////
	////Esconde objetos
	////
	oGroup1:Hide()
	oGroup3:Hide()
	oGroup4:Hide()
	oGroup5:Hide()
	oGroup6:Hide()
	oGroup7:Hide()
	oGroup8:Hide()
	oGroup9:Hide()
	oGroup10:Hide()
	oGroup11:Hide()
	oGroup12:Hide()
	oGroup13:Hide()
	oGroupP1:Hide()
	oGroupP2:Hide()
	oSSerie:Hide()
	oSerie:Hide()
	oSNumero:Hide()
	oNFiscal:Hide()
	oSCliente:Hide()
	oCliente:Hide()
	oSEmissao:Hide()
	oEmissao:Hide()
	oSMunCli:Hide()
	oMunCli:Hide()
	oSEstCli:Hide()
	oEstCli:Hide()
	oSTransp:Hide()
	oTransp:Hide()
	oSVolume:Hide()
	oVolume:Hide()
	oSEspecie:Hide()
	oEspecie:Hide()
	oSPB:Hide()
	oPB:Hide()
	oSPL:Hide()
	oPL:Hide()
	oDescri:Hide()
	oSayBalanca:Hide()
	oSayCaptura:Hide()
	oSSair:Hide()
	oSReimpr:Hide()
	oSPesoProd:Hide()
	oPesoProd:Hide()
	oPesoPeca:Hide()
	oPesoTara:Hide()
	oBProd:Hide()
	oEmbVol:Hide()
	oNumVol:Hide()
	oSPesoVol:Hide()
	oPesoVol:Hide()
	oSQtyPeca:Hide()
	oSInvoice:Hide()
	oInvoice:Hide()
	oQtyPeca:Hide()
	oSTtlPB:Hide()
	oTtlPB:Hide()
	oSTtlPL:Hide()
	oTtlPL:Hide()
	oSTtlPP:Hide()
	oTtlPP:Hide()
	oTBmp1:Hide()
	oTBmp2:Hide()
	oTBmp3:Hide()
	oTBmp4:Hide()
	oTBmp5:Hide()
	oTBmp6:Hide()
	oTBmp7:Hide()
	oTBmp8:Hide()
	oTBmp9:Hide()
	oMulti:Hide()
	oVDescri:Hide()
	oLst:Hide()
	oPedido:oBrowse:Hide()
	oPLst:Hide()
	oPDescri:Hide()
	oPPLiqOpc:Hide()
	oPLiqOpc:Hide()

	oGroupM2:Hide()
	oGroupM3:Hide()
	oGroupM4:Hide()
	oGroupM5:Hide()
	oQtdEmb:Hide()
	oQtdEtq:Hide()
	oVolImp:Hide()
	oSeqVol:Hide()
	oOpcM:Hide()
	oTBmp10:Hide()
	
	oGroupM9:Hide()
	oGroupMA:Hide()
	oGroupMB:Hide()
	oEmisDe:Hide()
	oEmisAte:Hide()
	oEmissDe:Hide()
	oEmissAte:Hide()
	oColet:Hide()
	oColeta:Hide()
	oTtlVol:Hide()
	oTtlPeso:Hide()
	oTtlVlr:Hide()
	oTtVol:Hide()
	oTtPeso:Hide()
	oTtVlr:Hide()
	oTranspc:Hide()
	oTranspct:Hide()
	oTranspctd:Hide()
	oMark:oBrowse:Hide()
	oTBmp4c:Hide()
	oTBmp5c:Hide()
	
	oGroupN1:Hide()
	oBtn01:Hide()
	oPVolFecha:Hide()
	oVolFecha:Hide()
	oCBOP:Hide()
	oCBPV:Hide()
	oCBIT:Hide()
	oCBCLI:Hide()
	oBarraOP:Hide()
	oBarraPV:Hide()
	oBarraIT:Hide()
	oBarraCLI:Hide()
	oTBmpB1:Hide()
	oTBmpB2:Hide()
	oTBmpB3:Hide()
	oTBmp4v:Hide()
	oTBmp5v:Hide()
	oGroupCB:Hide()
	oEmbCB:Hide()

	oGroupM6:Hide()
	oGroupM7:Hide()
	oGroupM8:Hide()
	oGroupMC:Hide()
	oGroupMD:Hide()
	oBmpEmp:Hide()
	oBmpBar1:Hide()
	oBmpBar2:Hide()
	oEtqCodE:Hide()
	oEtqDesc:Hide()
	oEtqMod:Hide()
	oEtqNF:Hide()
	oEtqPed:Hide()
	oEtqQtd:Hide()
	oEtqVol:Hide()
	oEtqBar1:Hide()
	oLetraC:Hide()
	oLetraO:Hide()
	oLetraE:Hide()
	oLetraL:Hide()
	oLetra01:Hide()
	oLetra02:Hide()
	oLetra03:Hide()
	oLetra04:Hide()
	oLetra05:Hide()
	oLetra06:Hide()
	oLetra07:Hide()
	oLetra08:Hide()
	oLetra09:Hide()
	oLetra10:Hide()
	oLetra11:Hide()
	oLetra12:Hide()
	
	ACTIVATE MSDIALOG oDlg CENTER VALID lSair
	
ENDDO	

TRB->(dbCloseArea())
TB2->(dbCloseArea())

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_saida()
//////////////////////////////////////////////////////////////////////////////////////////// 
Local nX := IIF(nOpc==0.OR.nOpc==2 , 1 , 0 )

IF ( nX == 0 )
	IF ( !lPrtPV .AND. nPesagem > 0 )
		nX := Aviso("Listagem do(s) Pedido(s)","Voce ainda NÃO imprimiu a listagem do(s) Pedido(s) p/Faturamento. Sair da rotina mesmo assim?",{"Sim","Não"},3)
	ENDIF	
ENDIF
	
IF ( nX == 1 )
	lSair    := .T.
	lLooping := .F.
	oDlg:End()
ENDIF

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_barraop()
//////////////////////////////////////////////////////////////////////////////////////////// 
Local cAI10,cOP
Local cBarraIPV
Local lResp

lBarraIT := .F.

IF ( !EMPTY(cBarraOP) )                    ///.AND. cBarraOP <> mBarraOP )
	IF ( LEFT(cBarraOP,2) <> "10" )
		cBarraOP := SPACE(17)
		oBarraOP:Refresh()
		Return(.F.)
	ENDIF
	cAI10     := SUBS(cBarraOP,1,2)	
	cOP       := SUBS(cBarraOP,3,8)+"001"
	cAI30     := SUBS(cBarraOP,11,2)
	nAIQty    := VAL(SUBS(cBarraOP,13,4))
	cBarraPV  := SPACE(6)
	mBarraPV  := cBarraPV
	cBarraCLI := SPACE(40)
	cBarraIT  := SPACE(75)
	aBarraIT  := {cBarraIT}

	SC2->(dbSeek(xFilial("SC2")+cOP))
	
	IF ( SC2->(EOF()) )
		MsgInfo("Ordem de Produção não encontrada.","Atenção")
		cBarraOP := SPACE(17)
	ELSE
		IF ( !EMPTY(SC2->C2_PEDIDO) )
			cBarraPV  := SC2->C2_PEDIDO
			cBarraIPV := SC2->C2_ITEMPV
			
			f_barrapv1(cBarraIPV)
			
			cBarraOP := SPACE(17)
		ELSE
			oBarraPV:Enable()
			oBarraIT:Enable()
			oBarraPV:SetFocus()
		ENDIF
	ENDIF
	oBarraIT:SetItems(aBarraIT)      ///LOOP
	oBarraIT:Refresh()               ///LOOP
	oBarraCLI:Refresh()              ///LOOP
	IF ( EMPTY(cBarraOP) )
		oBarraOP:SetFocus()
	ENDIF	
	mBarraOP := cBarraOP
ENDIF

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_barrapv1(cBarraIPV)
//////////////////////////////////////////////////////////////////////////////////////////// 
Local cCliente,cRazSoc,cDestino
Local nRecSC5,nQty
Local nZ      := ASCAN(aCols   , { |z| z[1] == cBarraPV } )
Local nW      := ASCAN(aItemPV , { |z| z[2]+z[3] == cBarraPV+cBarraIPV } )
Local cPedAnt := aCols[n,1]
Local lRsp    := .T.

IF ( !EMPTY(cBarraPV) )
	
	IF ( nW > 0 .AND. (aItemPV[nW,5]+aItemPV[nW,6]) == aItemPV[nW,9] )
		MsgStop("Numero de leituras maior que a quantidade do pedido.","Atenção")
		lRsp := .F.
	ENDIF

	nQty := IIF(nW > 0 , ( nAIQty + aItemPV[nw,5] + aItemPV[nW,6] ) , nAIQty ) 
	
	SC5->(dbSeek(xFilial("SC5")+cBarraPV))
	
	IF ( SC5->(EOF()) )
		MsgStop("Pedido de Venda não cadastrado.","Atenção")
		Return
	ELSE
		IF ( lRsp .AND. !EMPTY(cPedAnt) )   
			nRecSC5  := SC5->(RECNO())                                          ////Salva registro atual do SC5
			cCliente := ( SC5->C5_CLIENTE + SC5->C5_LOJACLI )
			SC5->(dbSeek(xFilial("SC5")+cPedAnt))
			IF ( cCliente <> SC5->(C5_CLIENTE+C5_LOJACLI) )
				MsgStop("Só é permitido vários pedidos para um mesmo Cliente.","Atenção")
				lRsp := .F.
			ENDIF
			SC5->(dbGoTo(nRecSC5))
		ENDIF	
		IF ( SC5->C5_TIPO $ "DB" )
			SA2->(dbSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJAENT))
			cRazSoc  := SA2->A2_NOME
			cDestino := RTRIM(SA2->A2_MUN)+IIF(SA2->A2_EST<>"EX"," / "+SA2->A2_EST , IIF(!EMPTY(SA2->A2_CLNPAIS)," / "+SA2->A2_CLNPAIS,"") )
		ELSE
			SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJAENT))
			cRazSoc  := SA1->A1_NOME
			cDestino := RTRIM(SA1->A1_MUN)+IIF(SA1->A1_EST<>"EX"," / "+SA1->A1_EST,"")
		ENDIF
		
		SC6->(dbSeek(xFilial("SC6")+cBarraPV+cBarraIPV))
		
		IF ( SC6->(EOF()) )
			MsgStop("Item do pedido não encontrado.","Atenção")
			cBarraIT := cBarraIPV+SPACE(73)
			aBarraIT := {cBarraIT}
			lRsp     := .F.
		ELSEIF ( lRsp .AND. nQty > SC6->C6_QTDVEN )
			MsgStop("Quantidade do lote, no código de barras, maior que a quantidade do pedido.","Atenção")
			lRsp     := .F.
			cBarraIT := SC6->C6_ITEM + " - " + SC6->C6_PRODUTO + LEFT(SC6->C6_DESCRI,40)
			aBarraIT := {cBarraIT}
		ENDIF

		cBarraCLI := cRazSoc
		
		IF ( lRsp )
			IF ( nTQty = 0 )
				oBtn01:Show()
			ENDIF
			IF ( EMPTY(aCols[1,1]) )
				aItemPV := {}
				nZ      := 1
			ENDIF
			IF ( nZ == 0 )
				AADD(aCols , { " " , " " , " " } )
				nZ := LEN(aCols)
			ENDIF
			aCols[nZ,1] := cBarraPV
			aCols[nZ,2] := cRazSoc
			aCols[nZ,3] := cDestino
			
			nQty  := IIF(cAI30=="30" , nAIQty , 1 )           ///Codigo de barras com AI 30: lendo a partir da etiqueta de caixa coletiva da produção. Caso contrario, etiqueta individual do produto.
			nTQty += nQty
			
			SB1->(dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))

			cBarraIT := SC6->C6_ITEM + " - " + SC6->C6_PRODUTO + LEFT(SB1->B1_DESC,40)
			aBarraIT := {cBarraIT}
			
			IF ( nW == 0 )
				AADD( aItemPV , { "1"              , ;
									   SC6->C6_NUM      , ;
									   SC6->C6_ITEM     , ;
									   SC6->C6_PRODUTO  , ;
									   0                , ;
									   0                , ;
									   SB1->B1_PESO     , ;
									   LEFT(SB1->B1_DESC,60) , ;
									   SC6->C6_QTDVEN        , ;
									   SC2->C2_NUM+SC2->C2_ITEM  , ;
										SB1->B1_PESBRU  , ;
										SB1->B1_COLOR } )
				nW := LEN(aItemPV)
			ENDIF
			
			aItemPV[nW,6] += nQty

			nPLiqOpc := ( nPLiqOpc + ROUND(aItemPV[nW,11]*nQty,2) )
			
			aSort(aItemPV,,, { |x,y| x[2]+x[3] < y[2]+y[3] } )

			cPLiqOpc := TRANSF(nPLiqOPc,"@E 9999.999")+" Kg"
			cPDescri := RTRIM(aItemPV[1,8])
			cPedAnt  := cBarraPV

			oPLst:SetArray(aItemPV)

			oPLst:bLine := {|| { IIF(aItemPV[oPLst:nAt,1]=="0",oVm,oVd) , ;
											 aItemPV[oPLst:nAt,2]  , ;
											 aItemPV[oPLst:nAt,3]  , ;
											 aItemPV[oPLst:nAt,4]  , ;
											 aItemPV[oPLst:nAt,5]  , ;
											 aItemPV[oPLst:nAt,6]  , ;
											 aItemPV[oPLst:nAt,7]  , ;
											 aItemPV[oPLst:nAt,11]} }

			oPLst:GoTop()
			oPLst:Refresh()
			oPedido:Refresh()
			oPDescri:Refresh()
			oPLiqOpc:Refresh()
		ENDIF
	ENDIF	
	
ENDIF
				
Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_barrapv2()
//////////////////////////////////////////////////////////////////////////////////////////// 
Local cCliente,cRazSoc
Local nRecSC5
Local cPedAnt := aCols[n,1]
Local lRsp    := .T.

IF ( !EMPTY(cBarraPV) .AND. mBarraPV <> cBarraPV  )
	
	SC5->(dbSeek(xFilial("SC5")+cBarraPV))
	
	IF ( SC5->(EOF()) )
		MsgStop("Pedido de Venda não cadastrado.","Atenção")
		Return(.F.)
	ENDIF
	IF ( !EMPTY(cPedAnt) )   
		nRecSC5  := SC5->(RECNO())                                          ////Salva registro atual do SC5
		cCliente := ( SC5->C5_CLIENTE + SC5->C5_LOJACLI )
		SC5->(dbSeek(xFilial("SC5")+cPedAnt))
		IF ( cCliente <> SC5->(C5_CLIENTE+C5_LOJACLI) )
			MsgStop("Só é permitido vários pedidos para um mesmo Cliente.","Atenção")
			lRsp := .F.
		ENDIF
		SC5->(dbGoTo(nRecSC5))
	ENDIF	
	IF ( SC5->C5_TIPO $ "DB" )
		SA2->(dbSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJAENT))
		cRazSoc := SA2->A2_NOME
	ELSE
		SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJAENT))
		cRazSoc := SA1->A1_NOME
	ENDIF

	cBarraIT := SPACE(75)
	aBarraIT := {cBarraIT}
	IF ( lRsp )		
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial("SC6")+cBarraPV,.T.)		
		DO WHILE !EOF().AND.SC6->C6_FILIAL==xFilial("SC6").AND.SC6->C6_NUM==cBarraPV
			SB1->(dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
			AADD(aBarraIT , SC6->C6_ITEM + " - " + SC6->C6_PRODUTO + LEFT(SB1->B1_DESC,40) )
			dbSkip()
		ENDDO
	ENDIF
	mBarraPV  := cBarraPV
	cBarraCLI := cRazSoc		
	oBarraIT:SetItems(aBarraIT)
	oBarraIT:Refresh()
	oBarraCLI:Refresh()

	lBarraIT := .T.
	
ENDIF
				
Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_barraIT()
//////////////////////////////////////////////////////////////////////////////////////////// 
Local cCliente,cRazSoc,cDestino
Local cIPV := LEFT(cBarraIT,2)
Local nZ   := ASCAN(aCols   , { |z| z[1] == cBarraPV } )
Local nW   := ASCAN(aItemPV , { |z| z[2]+z[3] == cBarraPV+cIPV } )

IF ( !EMPTY(cBarraIT) .AND. lBarraIT )
	IF ( nW > 0 .AND. (aItemPV[nW,5]+aItemPV[nW,6]) == aItemPV[nW,9] )
		Return
	ENDIF
	IF ( SC5->C5_TIPO $ "DB" )
		SA2->(dbSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJAENT))
		cRazSoc  := SA2->A2_NOME
		cDestino := RTRIM(SA2->A2_MUN)+IIF(SA2->A2_EST<>"EX"," / "+SA2->A2_EST , IIF(!EMPTY(SA2->A2_CLNPAIS)," / "+SA2->A2_CLNPAIS,"") )
	ELSE
		SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJAENT))
		cRazSoc  := SA1->A1_NOME
		cDestino := RTRIM(SA1->A1_MUN)+IIF(SA1->A1_EST<>"EX"," / "+SA1->A1_EST,"")
	ENDIF
	IF ( EMPTY(aCols[1,1]) )
		aItemPV := {}
		nZ      := 1
	ENDIF
	IF ( nTQty = 0 )
		oBtn01:Show()
	ENDIF
	IF ( nZ == 0 )
		AADD(aCols , { " " , " " , " " } )
		nZ := LEN(aCols)
	ENDIF
	aCols[nZ,1] := cBarraPV
	aCols[nZ,2] := cRazSoc
	aCols[nZ,3] := cDestino
	
	nQty  := 1
	nTQty += 1
	
	SC6->(dbSeek(xFilial("SC6")+cBarraPV+cIPV))
	SB1->(dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))

	IF ( nW == 0 )
		AADD( aItemPV , { "1"             , ;
							  SC6->C6_NUM      , ;
							  SC6->C6_ITEM     , ;
							  SC6->C6_PRODUTO  , ;
							  0                , ;
							  0                , ;
							  SB1->B1_PESO     , ;
							  LEFT(SB1->B1_DESC,60) , ;
							  SC6->C6_QTDVEN        , ;
							  SPACE(08)  , ;
							  SB1->B1_PESBRU  , ;
							  SB1->B1_COLOR } )
		nW := LEN(aItemPV)
	ENDIF
	
	aItemPV[nW,6] += nQty

	nPLiqOpc := ( nPLiqOpc + ROUND(aItemPV[nW,11]*nQty,2) )
	
	aSort(aItemPV,,, { |x,y| x[2]+x[3] < y[2]+y[3] } )

	cPLiqOpc := TRANSF(nPLiqOPc,"@E 9999.999")+" Kg"
	cPDescri := RTRIM(aItemPV[1,8])
	cPedAnt  := cBarraPV

	oPLst:SetArray(aItemPV)

	oPLst:bLine := {|| { IIF(aItemPV[oPLst:nAt,1]=="0",oVm,oVd) , ;
								aItemPV[oPLst:nAt,2]  , ;
								aItemPV[oPLst:nAt,3]  , ;
								aItemPV[oPLst:nAt,4]  , ;
								aItemPV[oPLst:nAt,5]  , ;
								aItemPV[oPLst:nAt,6]  , ;
								aItemPV[oPLst:nAt,7]  , ;
								aItemPV[oPLst:nAt,11] } }

	oPLst:GoTop()
	oPLst:Refresh()
	oPedido:Refresh()
	oPDescri:Refresh()
	oPLiqOpc:Refresh()

	oBarraIT:Select(1)
	cBarraIT := aBarraIT[1]
	oBarraIT:Refresh()
	oBarraIT:SetFocus()
	
ENDIF

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_excluileitura()
//////////////////////////////////////////////////////////////////////////////////////////// 
Local lRsp := ( aItemPV[oPLst:nAt,6] > 0 )

IF ( lRsp )
	aItemPv[oPLst:nAt,6] -= 1
	nTQty -= 1
	
	IF ( nTQty = 0 )
		oBtn01:Hide()
	ENDIF
	
	oPLst:SetArray(aItemPV)
	oPLst:bLine      := { || { IIF(aItemPV[oPLst:nAt,1]=="1",oVd,oVm)  , ;
								          aItemPV[oPLst:nAt,2]  , ;
							             aItemPV[oPLst:nAt,3]  , ;
							             aItemPV[oPLst:nAt,4]  , ;
							             aItemPV[oPLst:nAt,5]  , ;
							             aItemPV[oPLst:nAt,6]  , ;
							             aItemPV[oPLst:nAt,7]  , ;
											 aItemPV[oPLst:nAt,11]} }
	oPLst:Refresh()	
	oBarraOP:SetFocus()
ENDIF

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_fechavol()
//////////////////////////////////////////////////////////////////////////////////////////// 
Local cMsg,mQtd
Local nX,nVolImp

IF ( nTQty = 0 )
	Return
ENDIF

nX := Aviso("Pesagem do Volume","Favor colocar o volume na balança para efetuar a pesagem.",{"Prosseguir","Cancelar"},3)

IF ( nX == 1 )

	nOpc := 77            ///Seta para não permitir pesagem do produto via balança.
	
	oGroupN1:Hide()
	oCBOP:Hide()
	oCBPV:Hide()
	oCBIT:Hide()
	oCBCLI:Hide()
	oBarraOP:Hide()
	oBarraPV:Hide()
	oBarraIT:Hide()
	oBarraCLI:Hide()
	oTBmpB1:Hide()
	oTBmpB2:Hide()
	oTBmpB3:Hide()
	oBtn01:Hide()

	////
	////Balança de pesagem (Volume)
	////
	nVolImp := 0
	
	AEVAL(aEmbOpc,{ |x| IIF(LEFT(x[1],1)=="E" , nVolImp += x[3] , nVolImp ) } )
	
	nImpVol  := IIF(nImpVol == 0 , nVolImp , ( nItemVol + nVolImp ) )
	nEmbVol  := IIF(LEFT(aEmbOpc[1,1],1)=="E".AND.aEmbOpc[1,3] > 0 , aEmbOpc[1,4] , 0 )
   nV       := IIF(nImpVol > 99 , 3 , 2 )
   cNumVol  := STRZERO(nItemVol,nV)+"/"+STRZERO(nImpVol,nV)
	cPesoVol := ""

	oGroup6:Show()
	oGroup7:Show()
	oGroup8:Show()
	oGroup9:Show()
	oGroup10:Show()
	oGroup11:Show()
	oSayBalanca:Show()
	oSayCaptura:Show()
	oEmbVol:Show()
	oNumVol:Show()
	oSPesoVol:Show()
	oPesoVol:Show()
	oSTtlPB:Show()
	oTtlPB:Show()
	oSTtlPL:Show()
	oTtlPL:Show()
	oTBmp1:Show()
	oTBmp4v:Show()
	oTBmp5v:Show()

	////
	////Exibe data-entry de Embalagem/Opcionais
	////
	oGroup4:Show()
	oMulti:Show()
	oVDescri:Show()
	
ENDIF

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_confvcol()
//////////////////////////////////////////////////////////////////////////////////////////// 
Local nW
Local lFlag := .F.
Local nZ    := 2

IF ( EMPTY(cPesoVol) )
	nZ := Aviso("Pesagem do Volume","Não foi efetuado a pesagem do volume."+CHR(13)+CHR(10)+"O que voce deseja fazer, então?"+CHR(13)+CHR(10)+"Confirmar = Sair sem pesar"+CHR(13)+CHR(10)+"Retornar = Efetuar uma pesagem",{"Confirmar","Retornar"},3)
	IF ( nZ == 2 )
		Return
	ENDIF
	nZ := IIF(EMPTY(cPesoVol) , 1 , 2 )
ENDIF
////
////Salva os itens do volume para posterior impressao da etiqueta de codigo de barras
////
IF ( nZ == 2 )
	nW := ( LEN(aVolume) + 1 )
	FOR nZ:=1 TO LEN(aItemPV)
		 IF ( aItemPV[nZ,6] > 0 )
			 AADD(aVolume , { STRZERO(nItemVol,4) , ;               ///Nro.Volume
									"01"                , ;               ///Pedido de Venda
									aItemPV[nZ,2]       , ;               ///Nro.Pedido
									aItemPV[nZ,3]       , ;               ///Item Pedido
									aItemPV[nZ,4]       , ;               ///Produto
									aItemPV[nZ,6]       , ;               ///Qtde
									aItemPV[nZ,8]       , ;               ///Descricao
									nPeso  } )                            ///Peso Bruto do Volume
			 aItemPV[nZ,5] += aItemPV[nZ,6]
			 aItemPV[nZ,6] := 0
		 ENDIF
	NEXT
	FOR nZ:=1 TO LEN(aEmbOpc)
		 IF ( LEFT(aEmbOpc[nZ,1],1) == "O" .AND. aEmbOpc[nZ,3] > 0 )		 
			 AADD(aVolume , { STRZERO(nItemVol,4) , ; 
									"02"                , ;               ///Pedido de Venda
									"ZZZZZZ"            , ;
									STRZERO(nZ,2)       , ;
									aEmbOpc[nZ,2]       , ;
									aEmbOpc[nZ,3]       , ;
									aEmbOpc[nZ,5]       , ;
									aEmbOpc[nZ,4]  } )
			 aEmbOpc[nZ,3] := 0
			 lFlag := .T.
		 ENDIF
	NEXT
	IF ( aEmbOpc[nIEmb,3] > 0 )
		AADD(aVolume , { STRZERO(nItemVol,4) , ; 
							  "03"                , ;                  ///Embalagem
							  "ZZZZZZ"            , ;
							  STRZERO(nIEmb,2)    , ;
							  aEmbOpc[nIEmb,2]    , ;
							  aEmbOpc[nIEmb,3]    , ;                  ///Qtde. (uma unidade)
							  aEmbOpc[nIEmb,5]    , ;
							  aEmbOpc[nIEmb,4] } )

		f_etqvolume(nW)                                          ///Imprime a etiqueta dos itens do pedido para o volume atual
							  
	   aEmbOpc[nIEmb,3] := 0					  
		lFlag := .T.
		
	ENDIF
	

	IF ( lFlag )
		FOR nZ:=1 TO LEN(aPesagem)
			 IF ( aPesagem[nZ,1] > 0 )
				 aPesagem[nZ,4] := "*"
			 ENDIF	 
		NEXT
		
		oMulti:SetArray(aEmbOpc)

		oMulti:bLine := {|| { aEmbOpc[oMulti:nAt,1]  , ;
									 aEmbOpc[oMulti:nAt,2]  , ;
									 aEmbOpc[oMulti:nAt,3]  , ;
									 aEmbOpc[oMulti:nAt,4] } }
		oMulti:GoTop()
		oMulti:Refresh()
		
	ENDIF

	nTQty     := 0
	cVolFecha := cNumVol
	
ENDIF

cBarraPV  := SPACE(6)
mBarraPV  := cBarraPV
cBarraCLI := SPACE(20)
cBarraOP  := SPACE(17)
mBarraOP  := cBarraOP
cBarraIT  := SPACE(94)
cPesoVol  := ""

////
////Balança de pesagem (Volume)
////
oGroup6:Hide()
oGroup7:Hide()
oGroup8:Hide()
oGroup9:Hide()
oGroup10:Hide()
oGroup11:Hide()
oSayBalanca:Hide()
oSayCaptura:Hide()
oEmbVol:Hide()
oNumVol:Hide()
oSPesoVol:Hide()
oPesoVol:Hide()
oSTtlPB:Hide()
oTtlPB:Hide()
oSTtlPL:Hide()
oTtlPL:Hide()
oTBmp1:Hide()
oTBmp4v:Hide()
oTBmp5v:Hide()

////
////Exibe data-entry de Embalagem/Opcionais
////
oGroup4:Hide()
oMulti:Hide()
oVDescri:Hide()

////
////Coletor
////
oGroupN1:Show()
oCBOP:Show()
oCBPV:Show()
oCBIT:Show()
oCBCLI:Show()
oBarraOP:Show()
oBarraPV:Show()
oBarraIT:Show()
oBarraCLI:Show()
oTBmpB1:Show()
oTBmpB2:Show()
oTBmpB3:Show()
oPVolFecha:Show()
oVolFecha:Show()

oBarraPV:Disable()
oBarraIT:Disable()
oBarraCLI:Disable()

oBarraOP:SetFocus()

nOpc := 7              ///Retorna opção da rotina, quando da opção de fechamento setada para 77.

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_cancvcol()
//////////////////////////////////////////////////////////////////////////////////////////// 
Local lRsp  
Local nV    := 9999
Local	cPict := "@E 999,999.999"

IF ( LEN(aPesagem) > 0 )
	nV := 0
	AEVAL(aPesagem , { |x| IIF(x[4]=="*" , nV += 1 , nV ) } )                       //??????ERROR
ENDIF	

IF ( nItemVol > nV )

	lRsp := MsgBox("Confirma o cancelamento dessa pesagem?","Escolha a opção","YESNO")

	IF ( lRsp )

		nPLiqui -= aPesagem[nItemVol,2] 
		nPBruto -= aPesagem[nItemVol,1] 
	
		nItemVol--

		nPeso    := IIF(nItemVol > 0 , aPesagem[nItemVol,1] , 0 )
		nPLq     := IIF(nItemVol > 0 , aPesagem[nItemVol,2] , 0 )
		nV       := IIF(nImpVol > 99 , 3 , 2 )
		cNumVol  := STRZERO(nItemVol,nV)+"/"+STRZERO(nImpVol,nV)
		cPesoVol := IIF(nItemVol > 0 , Transform(nPeso,cPict) + " Kg" , "" )
		
		IF ( nPBruto > 0 )			
			cTtlPB := Transform(nPBruto,cPict) + " Kg"
			cTtlPL := Transform(nPLiqui,cPict) + " Kg"
		ELSE
			cTtlPB  := ""
			cTtlPL  := ""
		ENDIF
		oNumVol:Refresh()
		oPesoVol:Refresh()
		oTtlPB:Refresh()
		oTtlPL:Refresh()
	
	ENDIF
ENDIF

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_encervol()
//////////////////////////////////////////////////////////////////////////////////////////// 
Local lRsp := .T.

IF ( !EMPTY(aItemPV[1,2]) )

	lRsp := MsgBox("Deseja finalizar a coleta deste Volume?","Escolha a opção","YESNO")

ENDIF	
IF ( lRsp )

	IF ( nImpVol > 0 )
		f_confpvcol()                                          ////Grava Peso/Volume/Embalagem/Opcionais no Pedido de Venda
	ENDIF	
	
	f_limpacol()
	
ENDIF

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_cancelvol()
//////////////////////////////////////////////////////////////////////////////////////////// 
Local lRsp := .T.

IF ( !EMPTY(cVolFecha) )

	lRsp := MsgBox("Tem certeza de que deseja Cancelar esse processo de coleta?","Escolha a opção","YESNO")

ENDIF	
IF ( lRsp )
	f_limpacol()
ENDIF

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_limpacol()
//////////////////////////////////////////////////////////////////////////////////////////// 
	
oPedido:oBrowse:nOpc := 3                                 ////2=Visualizar; 3=Alterar
oPedido:nMax := 999                                       ////Permite inserir linhas

oGroup4:Hide()
oGroupN1:Hide()
oCBOP:Hide()
oCBPV:Hide()
oCBIT:Hide()
oCBCLI:Hide()
oBarraOP:Hide()
oBarraPV:Hide()
oBarraIT:Hide()
oBarraCLI:Hide()
oTBmpB1:Hide()
oTBmpB2:Hide()
oTBmpB3:Hide()
oMulti:Hide()
oVDescri:Hide()
oPVolFecha:Hide()
oVolFecha:Hide()
oBtn01:Hide()

cVolFecha := ""
cNumVol  := "00/00"
cBarraPV  := SPACE(6)
mBarraPV  := cBarraPV
cBarraCLI := SPACE(20)
cBarraOP  := SPACE(17)
mBarraOP  := cBarraOP
cBarraIT  := SPACE(75)
cPLiqOpc  := ""
nOpc      := 0
nPLiqOpc  := 0
nVolume   := 0
aEmbOpc   := { {SPACE(3) , SPACE(30) , 0 , 0 , SPACE(60) } }
aItemPV   := { {"0",SPACE(6),SPACE(2),SPACE(30),0,0,0,SPACE(60),0,"",0,""} }
aCols     := { {SPACE(6) , SPACE(40) , SPACE(30) } }
aBarraIT  := {cBarraIT}

oTBmp8:Hide()
oTBmp9:Hide()
oGroupP1:Hide()
oGroupP2:Hide()
oPedido:oBrowse:Hide()
oPLst:Hide()
oPDescri:Hide()
oPPLiqOpc:Hide()
oPLiqOpc:Hide()
oPedido:oBrowse:Refresh()

oBarraIT:SetItems(aBarraIT)
oBarraIT:Refresh()

oPLst:SetArray(aItemPV)

oPLst:bLine := {|| { IIF(aItemPV[oPLst:nAt,1]=="0",oVm,oVd) , ;
							aItemPV[oPLst:nAt,2]  , ;
							aItemPV[oPLst:nAt,3]  , ;
							aItemPV[oPLst:nAt,4]  , ;
							aItemPV[oPLst:nAt,5]  , ;
							aItemPV[oPLst:nAt,6]  , ;
							aItemPV[oPLst:nAt,7]  , ;
							aItemPV[oPLst:nAt,11]} }

oPLst:Refresh()

oMulti:SetArray(aEmbOpc)

oMulti:bLine := {|| { aEmbOpc[oMulti:nAt,1] , ;
							 aEmbOpc[oMulti:nAt,2]  , ;
							 aEmbOpc[oMulti:nAt,3]  , ;
							 aEmbOpc[oMulti:nAt,4] } }
oMulti:Refresh()

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_confpvcol()
//////////////////////////////////////////////////////////////////////////////////////////// 
Local cTipo
Local nX 
Local cCodEmbs := ""
Local cCodOpcs := ""
Local cQtdEmbs := ""
Local cQtdOpcs := ""

nPesagem++

FOR nX:=1 TO LEN(aVolume)
	 IF ( aVolume[nX,2] == "03" )                                   ////Embalagem
		 cTipo    := "3"
		 cCodEmbs += aVolume[nX,5]                                   ////Codigo da embalagem
		 cQtdEmbs += STRZERO(aVolume[nX,6],3)                        ////Qtde. da embalagem
		 cQtdEmbs += STRZERO( (aVolume[nX,8]*1000) , 4)              ////Peso da embalagem
		 
	 ELSEIF ( aVolume[nX,2] == "02" )                               ////Opcionais
		 cTipo    := "2"
		 cCodOpcs += aVolume[nX,5]                                   ////Codigo do opcional (cabo,sonda...)
		 cQtdOpcs += STRZERO(aVolume[nX,6],4)                        ////Qtde. do opcional
		 cQtdOpcs += STRZERO( (aVolume[nX,8]*1000) , 3)              ////Peso do opcional
	 ELSE
		 cTipo := "1"                                                ////Pedido de Venda
	 ENDIF	 
		 
	 AADD(aPrtPV  , { STRZERO(nPesagem,3) , ;                ////1.Sequencia      
							cTipo          	  , ;                ////2.Tipo
							aVolume[nX,3]  	  , ;                ////3.Numero do Pedido
							aVolume[nX,4]  	  , ;                ////4.Item do Pedido
							aVolume[nX,5]  	  , ;                ////5.Codigo do Produto
							aVolume[nX,7]  	  , ;                ////6.Descricao do Produto
							aVolume[nX,6]  	  , ;                ////7.Qtde.Liberada para faturamento
							nItemVol       	  , ;                ////8.Volume
							nPBruto        	  , ;                ////9.Peso Bruto
							nPLiqui  } )                      	   ////10.Peso Liquido
		 
NEXT

////
////Grava Volume/Peso/Opcionais/Embalagem no Pedido de Venda
////
aSort(aCols,,, { |x,y| x[1] < y[1] } )
FOR nX:=1 TO LEN(aCols)
	 dbSelectArea("SC5")
	 dbSetOrder(1)
	 dbSeek(xFilial("SC5")+aCols[nX,1])
	 IF ( !EOF().AND.C5_FILIAL==xFilial("SC5").AND.C5_NUM==aCols[nX,1] )
		 RecLock("SC5",.F.)
		 SC5->C5_VOLUME1 := IIF(nX==1 , nItemVol , 0  )
		 SC5->C5_PESOL   := IIF(nX==1 , nPLiqui  , 0  )
		 SC5->C5_PBRUTO  := IIF(nX==1 , nPBruto  , 0  )
		 SC5->C5_CLCEMBS := IIF(nX==1 , cCodEmbs , "" )
		 SC5->C5_CLQEMBS := IIF(nX==1 , cQtdEmbs , "" )
		 SC5->C5_CLCOPCS := IIF(nX==1 , cCodOpcs , "" )
		 SC5->C5_CLQOPCS := IIF(nX==1 , cQtdOpcs , "" )
		 MsUnlock()
	 ENDIF
NEXT

MsgInfo("Pesagem efetuada com sucesso!!!","Parabéns")

lPrtPV := IIF(lPrtPV , .F. , lPrtPV )                          ////Caso tenha sido impresso a listagem e depois inclua mais pedidos

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_pedido()
//////////////////////////////////////////////////////////////////////////////////////////// 

oTBmp6:Show()
oTBmp7:Show()
oGroupP1:Show()
oGroupP2:Show()
oPedido:oBrowse:Show()
oPLst:Show()
oPDescri:Show()
oPedido:oBrowse:Refresh()
oPedido:oBrowse:SetFocus()

nOpc  := 1
nOpcA := nOpc

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_coletor()
//////////////////////////////////////////////////////////////////////////////////////////// 

nTQty    := 0
nPBruto  := 0
nPLiqui  := 0
cCaptura := "Volume"
cTtlPB   := ""
cTtlPL   := ""

nImpVol  := 0
nItemVol := 0
nOpc     := 7
nOpcA    := nOpc
aVolume  := {}

////
////Exibe data-entry do Pedido
////
oGroupN1:Show()
oCBOP:Show()
oCBPV:Show()
oCBIT:Show()
oCBCLI:Show()
oBarraOP:Show()
oBarraPV:Show()
oBarraIT:Show()
oBarraCLI:Show()
oTBmpB1:Show()
oTBmpB2:Show()
oTBmpB3:Show()

oGroupP1:Show()
oGroupP2:Show()
oPLst:Show()
oPedido:oBrowse:Show()
oPedido:oBrowse:nOpc := 2                                ////Altera pra somente visualizar
oPedido:nMax := oPedido:oBrowse:nLen                     ////Nao permite inserir linhas
oPDescri:Show()

oBarraPV:Disable()
oBarraIT:Disable()
oBarraCLI:Disable()

oPedido:oBrowse:Refresh()
oBarraOP:SetFocus()

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_nfiscal()
//////////////////////////////////////////////////////////////////////////////////////////// 

oGroup1:Show()
oGroup3:Show()
oSSerie:Show()
oSerie:Show()
oSNumero:Show()
oNFiscal:Show()
oSCliente:Show()
oSEmissao:Show()
oCliente:Show()
oEmissao:Show()
oSMunCli:Show()
oMunCli:Show()
oSEstCli:Show()
oEstCli:Show()
oSTransp:Show()
oTransp:Show()
oSVolume:Show()
oSInvoice:Show()
oInvoice:Show()
oVolume:Show()
oSEspecie:Show()
oEspecie:Show()
oSPB:Show()
oPB:Show()
oSPL:Show()
oPL:Show()
oLst:Show()
oDescri:Show()
oLst:Refresh()
oSerie:SetFocus()

nOpc  := 5
nOpcA := nOpc

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_balancapv()
//////////////////////////////////////////////////////////////////////////////////////////// 
Local nX

nOpc := 4

nItemVol := 0
nEmbVol  := 0
nPBruto  := 0
nPLiqui  := 0
cCaptura := "Volume"
nImpVol  := 0          
cNumVol  := "00/00"
cPesoVol := ""
cTtlPB   := ""
cTtlPL   := ""

oPedido:oBrowse:nOpc := 2                                ////Altera pra somente visualizar
oPedido:nMax := oPedido:oBrowse:nLen                     ////Nao permite inserir linhas
///oPedido:oBrowse:lReadOnly := .T.                      ////Desabilita o objeto (:Disable())

oTBmp6:Hide()
oTBmp7:Hide()

////
////Exibe objetos
////
oGroup4:Show()
oMulti:Show()
oGroup6:Show()
oGroup7:Show()
oGroup8:Show()
oGroup9:Show()
oGroup10:Show()
oGroup11:Show()
oVDescri:Show()
oSayBalanca:Show()
oSayCaptura:Show()
oEmbVol:Show()
oNumVol:Show()
oSPesoVol:Show()
oPesoVol:Show()
oSTtlPB:Show()
oTtlPB:Show()
oSTtlPL:Show()
oTtlPL:Show()
oTBmp1:Show()
oTBmp4:Show()
oTBmp5:Show()
oTBmp8:Show()
oTBmp9:Show()

SC5->(dbSeek(xFilial("SC5")+aCols[1,1]))
IF ( SC5->C5_TIPO == 'N' )
	SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	cNReduz  := SA1->A1_NREDUZ
	cCodPais := SA1->A1_CODPAIS
ELSE
	SA2->(dbSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	cNReduz  := SA2->A2_NREDUZ
	cCodPais := SA2->A2_CODPAIS
ENDIF

CCH->(dbSeek(xFilial("CCH")+cCodPais))

cCountry := RTRIM(CCH->CCH_PAIS)

dbSelectArea("TB2")
__dbZap()

FOR nX:=1 TO LEN(aCols)
	 IF ( aItemPV[nX,1] <> "0" )
		 RecLock("TB2",.T.)
		 TB2->T2_OK      := cMarca
		 TB2->T2_PEDIDO  := aItemPV[nX,2]
		 TB2->T2_ITEM    := aItemPV[nX,3]
		 TB2->T2_PRODUTO := aItemPV[nX,4]
		 TB2->T2_DESCRI  := aItemPV[nX,8]
		 MsUnlock()
	 ENDIF
NEXT

Return


///////////////////////////////////////////////////////////
Static Function f_metalfrio()
///////////////////////////////////////////////////////////

oTBmp7:Show()
oGroup1:Show()
oGroup3:Show()
oSSerie:Show()
oSerie:Show()
oSNumero:Show()
oNFiscal:Show()
oSCliente:Show()
oSEmissao:Show()
oCliente:Show()
oEmissao:Show()
oSMunCli:Show()
oMunCli:Show()
oSEstCli:Show()
oEstCli:Show()
oSTransp:Show()
oTransp:Show()
oSVolume:Show()
oVolume:Show()
oSEspecie:Show()
oEspecie:Show()
oSPB:Show()
oPB:Show()
oSPL:Show()
oPL:Show()
oLst:Show()
oDescri:Show()
oLst:Refresh()
oSerie:SetFocus()

nOpc  := 9
nOpcA := nOpc

Return

///////////////////////////////////////////////////////////
Static Function f_Etiqueta()
///////////////////////////////////////////////////////////

oTBmp7:Show()
oGroup1:Show()
oGroup3:Show()
oSSerie:Show()
oSerie:Show()
oSNumero:Show()
oNFiscal:Show()
oSCliente:Show()
oSEmissao:Show()
oCliente:Show()
oEmissao:Show()
oSMunCli:Show()
oMunCli:Show()
oSEstCli:Show()
oEstCli:Show()
oSTransp:Show()
oTransp:Show()
oSVolume:Show()
oVolume:Show()
oSEspecie:Show()
oEspecie:Show()
oSPB:Show()
oPB:Show()
oSPL:Show()
oPL:Show()
oLst:Show()
oDescri:Show()
oLst:Refresh()
oSerie:SetFocus()

nOpc  := 9
nOpcA := nOpc

Return

///////////////////////////////////////////////////////////
Static Function f_showetqmetal()
///////////////////////////////////////////////////////////
Local nX

oGroupM6:Show()
oGroupM7:Show()
oGroupM8:Show()
oGroupMC:Show()
oGroupMD:Show()
oBmpEmp:Show()
oEtqCodE:Show()
oEtqDesc:Show()
oEtqMod:Show()
oEtqNF:Show()
oEtqPed:Show()
oEtqQtd:Show()
oEtqVol:Show()
oEtqBar1:Show()
oLetraC:Show()
oLetraO:Show()
oLetraE:Show()
oLetraL:Show()
oLetra01:Show()
oLetra02:Show()
oLetra03:Show()
oLetra04:Show()
oLetra05:Show()
oLetra06:Show()
oLetra07:Show()
oLetra08:Show()
oLetra09:Show()
oLetra10:Show()
oLetra11:Show()
oLetra12:Show()

SB1->(dbSeek(xFilial("SB1")+aItens[1,2]))
SC5->(dbSeek(xFilial("SC5")+aItens[1,6]))
SC6->(dbSeek(xFilial("SC6")+aItens[1,6]+aItens[1,7]))

nX := AT(" ",SC5->C5_CLNOMCL)

_cClNomCl := LEFT(SC5->C5_CLNOMCL,nX)

nX := 1
DO WHILE !EMPTY(SUBS(_cClNomCl,nX,1))
	cCampo  := "cLetra"+STRZERO(nX,2)
	&cCampo := SUBS(_cClNomCl,nX,1)
	cCampo  := "oLetra"+STRZERO(nX,2)+":Refresh()
	&cCampo
	nX++
	IF ( nX > 12 )
		_cClNomCl := SPACE(30)
	ENDIF
ENDDO

lSeqVol   := .F.
cVolImp   := "/ "+STRZERO(nVolume,3)
nSeqVol   := 1
nSeqAnt   := 1
cVDescri  := " "
mQtdEtq   := 0
nQtdEmb   := 0
nQtdEtq   := 0
nEtqImp   := 0
nPrdImp   := 0

//oTBmp8:Show()
oTBmp10:Show()			
oGroupM2:Show()
oGroupM3:Show()
oGroupM4:Show()
oGroupM5:Show()
oQtdEmb:Show()
oQtdEtq:Show()
oVolImp:Show()
oSeqVol:Show()
oOpcM:Show()
oVDescri:Show()

f_etqbarmetal("I",1)

oQtdEmb:SetFocus()

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_etqbarmetal(cItem,nItem)        ///cItem = I(tens da nota fical) ; O(pcionais)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
Local xPedCli
Local xCodCli
Local xCodigo := IIF(cItem=="I",aItens[nItem,2],aOpcM[nItem,1])
Local xPedido := IIF(cItem=="I",aItens[nItem,6],aOpcM[nItem,4])
Local xItem   := IIF(cItem=="I",aItens[nItem,7],"00")
Local xQtde   := IIF(cItem=="I",aItens[nItem,3],aOpcM[nItem,3])

SB1->(dbSeek(xFilial("SB1")+xCodigo))
SC5->(dbSeek(xFilial("SC5")+xPedido))
SC6->(dbSeek(xFilial("SC6")+xPedido+xItem))

IF ( cItem == "I" )
	_cPedCli  := IIF(EMPTY(SC6->C6_PEDCLI) , RTRIM(SC5->C5_CLPEDCL) , RTRIM(SC6->C6_PEDCLI) )
	_cCodCli  := SC6->C6_X_PROD	
	_cClNomCl := SC5->C5_CLNOMCL
ELSE
	_cPedCli := RTRIM(xPedido)
	_cCodCli := RTRIM(aOpcM[nItem,2])
ENDIF	
_cProd    := xCodigo
_cModelo  := LEFT(SB1->B1_DESC,40)
_cFamilia := SB1->B1_CLDFAM
cEtqBar2  := _cPedCli
cEtqBar1  := RTRIM(SC6->C6_X_PROD)
cEtqCodE  := "CODIGO: "+xCodigo
cEtqDesc  := _cModelo
cEtqMod   := "MODELO: "+_cFamilia
cEtqPed   := "PEDIDO:   "+_cPedCli
cEtqCodC  := "CODIGO:  "+_cCodCli
cEtqQtd   := "QTDE.:    "+TRANSF(xQtde,"@E 99999")
cEtqNF    := "N.FISCAL: "+cSerie+" "+cNFiscal
cEtqVol   := "VOLUME:  "+STRZERO(nSeqVol,3)+"/"+STRZERO(nVolume,3)
cEtqBar2  := IIF( AT("." , cEtqBar2 ) > 0 , STRTRAN(cEtqBar2,".","") , cEtqBar2 )
cEtqBar2  := IIF( AT("-" , cEtqBar2 ) > 0 , STRTRAN(cEtqBar2,"-","") , cEtqBar2 )
cEtqBar2  := IIF( AT(" " , cEtqBar2 ) > 0 , STRTRAN(cEtqBar2," ","") , cEtqBar2 )

oEtqCodE:Refresh()
oEtqMod:Refresh()
oEtqDesc:Refresh()
oEtqNF:Refresh()
oEtqPed:Refresh()
oEtqCodC:Refresh()
oEtqQtd:Refresh()
oEtqVol:Refresh()
oEtqBar1:Refresh()

IF ( !EMPTY(cEtqBar1) )
	oBmpBar1:Show()
ENDIF
IF ( !EMPTY(cEtqBar2) )
	oBmpBar2:Show()
ENDIF

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_cancpesag()
//////////////////////////////////////////////////////////////////////////////////////////// 
Local nV
Local	cPict := "@E 999,999.999"
Local lRsp  := ( nItemVol > 0 )

IF ( lRsp )

	lRsp := MsgBox("Confirma o cancelamento dessa pesagem?","Escolha a opção","YESNO")

	IF ( lRsp )

		nPLiqui -= aPesagem[nItemVol,2] 
		nPBruto -= aPesagem[nItemVol,1] 
	
		nItemVol--

		nPeso    := IIF(nItemVol > 0 , aPesagem[nItemVol,1] , 0 )
		nPLq     := IIF(nItemVol > 0 , aPesagem[nItemVol,2] , 0 )
		nEmbVol  := IIF(nItemVol > 0 , aPesagem[nItemVol,3] , 0 )

	   nV       := IIF(nImpVol > 99 , 3 , 2 )
	   cNumVol  := STRZERO(nItemVol,nV)+"/"+STRZERO(nImpVol,nV)
		
		cPesoVol := Transform(nPeso,cPict) + " Kg"
		cTtlPB   := Transform(nPBruto,cPict) + " Kg"
		cTtlPL   := Transform(nPLiqui,cPict) + " Kg"

		oEmbVol:Refresh()
		oNumVol:Refresh()
		oPesoVol:Refresh()
		oTtlPB:Refresh()
		oTtlPL:Refresh()
	
	ENDIF
ENDIF

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_confpv()
//////////////////////////////////////////////////////////////////////////////////////////// 
Local nX       := 1
Local cCodEmbs := ""
Local cCodOpcs := ""
Local cQtdEmbs := ""
Local cQtdOpcs := ""
Local aPeds    := ACLONE(aCols)

IF ( nItemVol = 0 )
	MsgStop("Não foi efetuada nenhuma pesagem. Se desejar cancelar o processo, então clique no botão [Encerrar]","Atenção")
	Return
ENDIF

nPesagem++

FOR nX:=1 TO LEN(aEmbOpc)
	 IF ( LEFT(aEmbOpc[nX,1],1) == "E" )
		 cCodEmbs += aEmbOpc[nX,2]                                   ////Codigo da embalagem
		 cQtdEmbs += STRZERO(aEmbOpc[nX,3],3)                        ////Qtde. da embalagem
		 cQtdEmbs += STRZERO( (aEmbOpc[nX,4]*1000) , 4)              ////Peso da embalagem
	 ELSE
		 cCodOpcs += aEmbOpc[nX,2]                                   ////Codigo do opcional (cabo,sonda...)
		 cQtdOpcs += STRZERO(aEmbOpc[nX,3],4)                        ////Qtde. do opcional
		 cQtdOpcs += STRZERO( (aEmbOpc[nX,4]*1000) , 3)              ////Peso do opcional
		 
		 IF ( aEmbOpc[nX,3] > 0 )
		 
			 AADD(aPrtPV  , { STRZERO(nPesagem,3) , ;                
			                  "2"            	  , ;                
									""             	  , ;                ////Numero do Pedido
									""             	  , ;                ////Item do Pedido
									aEmbOpc[nX,2]  	  , ;                ////Codigo do Produto
									aEmbOpc[nX,5]  	  , ;                ////Descricao do Produto
									aEmbOpc[nX,3]  	  , ;                ////Qtde.Liberada para faturamento
									nItemVol       	  , ;                ////Volume
									nPBruto        	  , ;                ////Peso Bruto
									nPLiqui  } )                      	   ////Peso Liquido
		 
		 ENDIF
		 
	 ENDIF
NEXT
IF ( EMPTY(cCodEmbs) )
	MsgStop("É necessário que seja informado pelo menos um tipo de Embalagem.","Atenção")
	Return
ENDIF

////
////Grava Volume/Peso/Opcionais/Embalagem no Pedido de Venda
////
aSort(aPeds,,, { |x,y| x[1] < y[1] } )
FOR nX:=1 TO LEN(aCols)
	 dbSelectArea("SC5")
	 dbSetOrder(1)
	 dbSeek(xFilial("SC5")+aPeds[nX,1])
	 IF ( !EOF().AND.C5_FILIAL==xFilial("SC5").AND.C5_NUM==aPeds[nX,1] )
		 RecLock("SC5",.F.)
		 SC5->C5_VOLUME1 := IIF(nX==1 , nItemVol , 0  )
		 SC5->C5_PESOL   := IIF(nX==1 , nPLiqui  , 0  )
		 SC5->C5_PBRUTO  := IIF(nX==1 , nPBruto  , 0  )
		 SC5->C5_CLCEMBS := IIF(nX==1 , cCodEmbs , "" )
		 SC5->C5_CLQEMBS := IIF(nX==1 , cQtdEmbs , "" )
		 SC5->C5_CLCOPCS := IIF(nX==1 , cCodOpcs , "" )
		 SC5->C5_CLQOPCS := IIF(nX==1 , cQtdOpcs , "" )
		 MsUnlock()
	 ENDIF
NEXT

////
////Salva Pedido para impressao e posterior entrega para faturamento
////
FOR nX:=1 TO LEN(aItemPV)
	 IF ( aItemPV[nX,6] > 0 )
	 
		 AADD(aPrtPV  , { STRZERO(nPesagem,3) , ;                
		                  "1"            	  , ;                
		                  aItemPV[nX,2]  	  , ;                ////Numero do Pedido
								aItemPV[nX,3]  	  , ;                ////Item do Pedido
								aItemPV[nX,4]  	  , ;                ////Codigo do Produto
								aItemPV[nX,8]  	  , ;                ////Descricao do Produto
								aItemPV[nX,6]  	  , ;                ////Qtde.Liberada para faturamento
								nItemVol       	  , ;                ////Volume
								nPBruto        	  , ;                ////Peso Bruto
								nPLiqui  } )        		               ////Peso Liquido
	 
	 ENDIF
NEXT
	 
MsgInfo("Pesagem efetuada com sucesso!!!","Parabéns")

lPrtPV := IIF(lPrtPV , .F. , lPrtPV )                          ////Caso tenha sido impresso a listagem e depois inclua mais pedidos

////
////Encerra a pesagem atual
////
lSair := .T.
oDlg:End()

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_cancpv()
//////////////////////////////////////////////////////////////////////////////////////////// 

////
////Fecha pesagem do produto
////
oGroup5:Hide()
oGroup6:Hide()
oSayBalanca:Hide()
oSayCaptura:Hide()
oSPesoProd:Hide()
oPesoProd:Hide()
oBProd:Hide()
oSSair:Hide()
oTBmp1:Hide()
oTBmp3:Hide()

cPesoProd := ""
cBProd    := ""

////
////Fecha pesagem do pedido
////
cPLiqOpc := ""
nOpc     := 0
nPLiqOpc := 0
nVolume  := 0
nImpVol  := 0
aItemPV  := { {"0",SPACE(6),SPACE(2),SPACE(30),0,0,0,SPACE(60),0,"",0,""} }
aCols    := { {SPACE(6) , SPACE(40) , SPACE(30) } }

oTBmp6:Hide()
oTBmp7:Hide()
oTBmp8:Hide()
oTBmp9:Hide()
oGroupP1:Hide()
oGroupP2:Hide()
oPedido:oBrowse:Hide()
oPLst:Hide()
oPDescri:Hide()
oPPLiqOpc:Hide()
oPLiqOpc:Hide()
oPedido:oBrowse:Refresh()

oPLst:SetArray(aItemPV)

oPLst:bLine := {|| { IIF(aItemPV[oPLst:nAt,1]=="0",oVm,oVd) , ;
							aItemPV[oPLst:nAt,2]  , ;
							aItemPV[oPLst:nAt,3]  , ;
							aItemPV[oPLst:nAt,4]  , ;
							aItemPV[oPLst:nAt,5]  , ;
							aItemPV[oPLst:nAt,6]  , ;
							aItemPV[oPLst:nAt,7]  , ;
							aItemPV[oPLst:nAt,11]} }

oPLst:Refresh()

Return

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_cancbalpv()
//////////////////////////////////////////////////////////////////////////////////////////// 
Local lRsp := MsgBox("Confirma o cancelamento de pesagem?","Escolha a opção","YESNO")

IF ( lRsp )

	lSair := .T.
	oDlg:End()
	
ENDIF

Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_liberaitem(nItem)    
//////////////////////////////////////////////////////////////////////////////
Local oDlgD
Local nX
Local xcProduto := RTRIM(aItemPV[nItem,4])+" - "+aItemPV[nItem,8]
Local xnQty     := IIF(aItemPV[nItem,6] > 0 , aItemPV[nItem,6] , aItemPV[nItem,5] )
Local xnQtySdo  := aItemPV[nItem,5]
Local xnPeso    := aItemPV[nItem,7]
Local xnQtyAnt  := ROUND(aItemPV[nItem,6]*xnPeso,2)
Local nOpcB     := 0

IF ( nOpc <> 1 )
	Return
ENDIF

@ 065,000 To 150,418 Dialog oDlgD Title OemToAnsi("Quantidade a Liberar")
@ 001,001 To 041,211
@ 006,004 Say OemToAnsi(xcProduto)                            Size 145,8  COLOR CLR_HBLUE
@ 017,004 Say OemToAnsi("Quantidade")                         Size 30,8

@ 025,004 Get xnQty                   Picture "@E 99999" Size 45,10  VALID ( xnQty >= 0 .AND. xnQty <= xnQtySdo )

@ 006,183 BmpButton Type 1 Action ( nOpcB := 1 , oDlgD:End() )
@ 023,183 BmpButton Type 2 Action ( nOpcB := 2 , oDlgD:End() )

Activate Dialog oDlgD CENTER VALID nOpcB <> 0

IF ( nOpcB == 1 )

	nPLiqOpc := ( nPLiqOpc - xnQtyAnt + (ROUND(xnQty*xnPeso,2)) )
	cPLiqOpc := TRANSF(nPLiqOPc,"@E 9999.999")+" Kg"
	aItemPV[oPLst:nAt,1] := IIF(xnQty > 0 , "1" , "0" )
	aItemPV[oPLst:nAt,6] := xnQty
	nX     := ASCAN(aItemPV , { |z| z[1]=="1" } )
	lSelPV := ( nX > 0 )

	oPLst:SetArray(aItemPV)

	oPLst:bLine := {|| { IIF(aItemPV[oPLst:nAt,1]=="0",oVm,oVd) , ;
								aItemPV[oPLst:nAt,2]  , ;
								aItemPV[oPLst:nAt,3]  , ;
								aItemPV[oPLst:nAt,4]  , ;
								aItemPV[oPLst:nAt,5]  , ;
								aItemPV[oPLst:nAt,6]  , ;
								aItemPV[oPLst:nAt,7]  , ;
								aItemPV[oPLst:nAt,11]} }

	oPLst:Refresh()
	oPLiqOpc:Refresh()

ENDIF

Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_editaitem(nItem,nOper)             
//////////////////////////////////////////////////////////////////////////////
////nOper: 1 = Incluir ; 2 = Alterar
Local oDlgD
Local xcTipo,xcProduto
Local xnQty,xnQtyAnt,xnPesoAnt,nV,nVolImp
Local aTipo   := { SPACE(10) , "EMBALAGEM " , "OPCIONAIS " } 
Local nOpcB   := 0
Local nLenVol := LEN(aEmbOpc)

Private oxcDescri,oxnPeso
Private xcDescri 
Private xnPeso

nOper     := IIF(EMPTY(aEmbOpc[nItem,2]) , 2 , nOper )
xcTipo    := IIF(nOper==1 , SPACE(10) , aEmbOpc[nItem,1] )
xcProduto := IIF(nOper==1 , SPACE(30) , aEmbOpc[nItem,2] )
xnQty     := IIF(nOper==1 , 0         , aEmbOpc[nItem,3] )
xnPeso    := IIF(nOper==1 , 0         , aEmbOpc[nItem,4] )
cATipo    := xcTipo
xnAQty    := xnQty
xnPesoAnt := xnPeso
xnQtyAnt  := ROUND(xnQty*xnPeso,2)

SB1->(dbSeek(xFilial("SB1")+xcProduto))
xcDescri := LEFT(SB1->B1_DESC,60)
xnPeso   := IIF(xnPeso <= 0 , SB1->B1_PESBRU , xnPeso )

DEFINE MSDIALOG oDlgD TITLE ":::... EMBALAGEM / OPCIONAIS ...:::" FROM 000, 000  TO 170, 430 COLORS 0, 16777215 PIXEL

@ 001,001 GROUP oGrpD01 TO 081,211 PROMPT ""   		  	                                        OF oDlgD PIXEL COLOR 0, 16777215
@ 005,004 Say oxcDescri            VAR xcDescri	                                  Size 145,8  OF oDlgD PIXEL COLOR CLR_HRED
@ 017,004 Say OemToAnsi("Tipo")                                                   Size 30,8   OF oDlgD PIXEL COLOR CLR_HBLUE
@ 025,004 ComboBox xcTipo    Items aTipo                                          Size 70,21  OF oDlgD PIXEL
@ 039,004 Say OemToAnsi("Produto")                                                Size 30,8   OF oDlgD PIXEL COLOR CLR_HBLUE
@ 047,004 MsGet oxcProduto         VAR xcProduto    Picture "@!"        F3 "SB1"  Size 80,10  OF oDlgD PIXEL VALID f_produto(xcProduto,nOper)
@ 059,004 Say OemToAnsi("Quantidade")                                             Size 30,8   OF oDlgD PIXEL COLOR CLR_HBLUE
@ 067,004 MsGet oxnQty             VAR xnQty        Picture "@E 99999"            Size 45,10  OF oDlgD PIXEL VALID xnQty >= 0
@ 059,074 Say OemToAnsi("Peso Liq.")                                              Size 30,8   OF oDlgD PIXEL COLOR CLR_HBLUE
@ 067,074 MsGet oxnPeso            VAR xnPeso       Picture "@E 999.999"          Size 45,10  OF oDlgD PIXEL VALID xnPeso >= 0 

DEFINE SBUTTON FROM 006,183 TYPE 1 ACTION ( nOpcB := 1 , oDlgD:End() ) ENABLE OF oDlgD
DEFINE SBUTTON FROM 023,183 TYPE 2 ACTION ( nOpcB := 2 , oDlgD:End() ) ENABLE OF oDlgD

ACTIVATE MSDIALOG oDlgD CENTER VALID nOpcB <> 0

IF ( nOpcB == 1 )

	nOpcB := ASCAN(aTipo , xcTipo )
	
	IF ( nOpcB == 1 )
		MsgAlert("Tipo do Produto não selecionado. Favor corrigir.","Atenção")
		Return
	ENDIF
	IF ( EMPTY(xcProduto) )
		MsgStop("Produto não informado. Favor corrigir.","Atenção")
		Return
	ENDIF
	
	IF ( nOper == 1 )
		AADD(aEmbOpc , { SPACE(10) , SPACE(30) , 0 , 0 , SPACE(60) } )
		nItem := LEN(aEmbOpc)
	ENDIF
	aEmbOpc[nItem,1] := aTipo[nOpcB]
	aEmbOpc[nItem,2] := xcProduto
	aEmbOpc[nItem,3] := xnQty
	aEmbOpc[nItem,4] := xnPeso
	aEmbOpc[nItem,5] := xcDescri

	IF ( nOpc <> 7 )                                                        	///7=Rotina do Coletor		
		
		xnAQty := IIF(LEFT(cATipo,1)=="E" , xnAQty , 0 )
		
		IF ( LEFT(xcTipo,1)=="O" )
			nImpVol  := ( nImpVol - xnAQty )
			xnQtyAnt := IIF(LEFT(cATipo,1)=="E" , 0 , xnQtyAnt )
			nPLiqOpc := ( nPLiqOpc - xnQtyAnt + (ROUND(xnQty*xnPeso,2)) )
		ELSEIF ( LEFT(xcTipo,1)=="E" )
			nImpVol  := ( nImpVol - xnAQty + xnQty )
			nPLiqOpc := ( nPLiqOpc - xnQtyAnt )
		ENDIF	
		nV       := IIF(nImpVol > 99 , 3 , 2 )
		cNumVol  := STRZERO(nItemVol,nV)+"/"+STRZERO(nImpVol,nV)
		cPLiqOpc := TRANSF(nPLiqOPc,"@E 9999.999")+" Kg"
		IF ( LEFT(aEmbOpc[1,1],1) == "E" )
			nEmbVol := aEmbOpc[1,4]
		ENDIF
		
		////
		////Verifica se o codigo é opcional pra gravar como item de pedido, pra sair na selecao de etiqueta
		////Exclui se foi selecionado como opcional e foi alterado pra embalagem
		////
		dbSelectArea("TB2")
		dbSeek(Space(8)+xcProduto)
		IF ( EOF() )
			IF ( LEFT(xcTipo,1) == "O" )
				RecLock("TB2",.T.)
				TB2->T2_PRODUTO := xcProduto
				TB2->T2_DESCRI  := xcDescri
				MsUnlock()
			ENDIF
		ELSEIF ( LEFT(xcTipo,1)	== "E" ) 
			RecLock("TB2",.F.)
			dbDelete()
			MsUnlock()
		ENDIF
		
		oPLiqOpc:Refresh()
		oEmbVol:Refresh()
		oNumVol:Refresh()

	ELSE
		IF ( LEFT(cATipo,1) <> LEFT(xcTipo,1) )
			nEmbVol := 0
		ENDIF
		IF ( LEFT(xcTipo,1) == "E" )

			nVolImp := 0
			
			AEVAL(aEmbOpc,{ |x| IIF(LEFT(x[1],1)=="E" , nVolImp += x[3] , nVolImp ) } )
			
			nImpVol  := IIF(nImpVol == 0 , nVolImp , ( nItemVol + nVolImp ) )
			nEmbVol  := IIF(LEFT(aEmbOpc[1,1],1)=="E".AND.aEmbOpc[1,3] > 0 , aEmbOpc[1,4] , 0 )
			nV       := IIF(nImpVol > 99 , 3 , 2 )
			cNumVol  := STRZERO(nItemVol,nV)+"/"+STRZERO(nImpVol,nV)
			oNumVol:Refresh()
			
		ENDIF
	ENDIF
	
	oMulti:SetArray(aEmbOpc)

	oMulti:bLine := {|| { aEmbOpc[oMulti:nAt,1] , ;
								 aEmbOpc[oMulti:nAt,2]  , ;
								 aEmbOpc[oMulti:nAt,3]  , ;
								 aEmbOpc[oMulti:nAt,4] } }
	oMulti:GoTop()
	oMulti:Refresh()
	
	SB1->(dbSeek(xFilial("SB1")+aEmbOpc[1,2]))
	cVDescri := LEFT(SB1->B1_DESC,40)
	oVDescri:Refresh()

ENDIF

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_edtitem(nItem,nOper)                             ////METALFRIO////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local oDlgD
Local xmProduto,xcProduto,xcPedido
Local xnQty
Local nOpcB := 0

Private oxcDescri,oxnPeso
Private xcDescri 

nOper     := IIF(EMPTY(aOpcM[nItem,1]) , 2 , nOper )
xcProduto := IIF(nOper==1 , SPACE(30) , aOpcM[nItem,1] )
xmProduto := IIF(nOper==1 , SPACE(20) , aOpcM[nItem,2] )
xnQty     := IIF(nOper==1 , 0         , aOpcM[nItem,3] )
xcPedido  := IIF(nOper==1 , SPACE(10) , aOpcM[nItem,4] )

SB1->(dbSeek(xFilial("SB1")+xcProduto))
xcDescri := LEFT(SB1->B1_DESC,60)

@ 065,000 To 230,422 Dialog oDlgD Title OemToAnsi("Opcionais (cabos,sondas,etc.)")
@ 001,001 To 081,211
@ 005,004 Say xcDescri				                                  Size 145,8  COLOR CLR_HRED   Object oxcDescri
@ 017,004 Say OemToAnsi("Código Coel")                             Size 50,8   COLOR CLR_HBLUE
@ 025,004 Get xcProduto               Picture "@!"       F3 "SB1"  Size 80,10  VALID f_produto(xcProduto,nOper)
@ 039,004 Say OemToAnsi("Código Cliente")                          Size 50,8   COLOR CLR_HBLUE
@ 047,004 Get xmProduto               Picture "@!"                 Size 80,10  
@ 059,004 Say OemToAnsi("Quantidade")                              Size 30,8   COLOR CLR_HBLUE
@ 067,004 Get xnQty                   Picture "@E 99999"           Size 45,10  VALID xnQty >= 0 Object oxnPeso
@ 059,074 Say OemToAnsi("Pedido Cliente")                          Size 60,8   COLOR CLR_HBLUE
@ 067,074 Get xcPedido                Picture "@!"                 Size 45,10  

@ 006,183 BmpButton Type 1 Action ( nOpcB := 1 , oDlgD:End() )
@ 023,183 BmpButton Type 2 Action ( nOpcB := 2 , oDlgD:End() )

Activate Dialog oDlgD CENTER VALID nOpcB <> 0

IF ( nOpcB == 1 )

	IF ( EMPTY(xcProduto) )
		MsgStop("Produto não informado. Favor corrigir.","Atenção")
		Return
	ENDIF
	
	IF ( nOper == 1 )
		AADD(aOpcM , { SPACE(30) , SPACE(20) , 0 , SPACE(10) , SPACE(60) } )
		nItem := LEN(aOpcM)
	ENDIF
	aOpcM[nItem,1] := xcProduto   
	aOpcM[nItem,2] := xmProduto
	aOpcM[nItem,3] := xnQty
	aOpcM[nItem,4] := xcPedido
	aOpcM[nItem,5] := xcDescri

	oOpcM:SetArray(aOpcM)

	oOpcM:bLine := {|| { aOpcM[oOpcM:nAt,1] , ;
								aOpcM[oOpcM:nAt,2]  , ;
								aOpcM[oOpcM:nAt,3]  , ;
								aOpcM[oOpcM:nAt,4] } }

	oOpcM:Refresh()
	oOpcM:GoPosition(nItem)
	
	cVDescri := xcDescri
	oVDescri:Refresh()
	
	f_descpro(nItem,9)

ENDIF

Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_produto(cProduto,nOper)    
//////////////////////////////////////////////////////////////////////////////
Local nX
Local lRsp := .T.

IF ( !EMPTY(cProduto) )
   nX := IIF(nOper==2 , 0 , ASCAN(aEmbOpc , { |x| x[2]==cProduto } ))
   IF ( nX > 0 )
	   MsgStop("Produto já inserido. Altere a quantidade, se for o caso.","Atenção")
	   lRsp := .F.
   ENDIF
	IF ( lRsp )
	   SB1->(dbSeek(xFilial("SB1")+cProduto))
	   IF ( SB1->(EOF()) )
		   MsgStop("Produto não cadastrado.","Atenção")
		   lRsp := .F.
	   ELSE			  
			xnPeso   := SB1->B1_PESBRU
		   xcDescri := RTRIM(LEFT(SB1->B1_DESC,60))
			oxnPeso:Refresh()
	   ENDIF
   ENDIF

ENDIF

Return(lRsp)

//////////////////////////////////////////////////////////////////////////////////////////// 
Static Function f_selpedido(nItem)
//////////////////////////////////////////////////////////////////////////////////////////// 
Local lRsp    := .T.
Local cPedido := aPedido[nItem,1] 

IF ( !EMPTY(cPedido) )

ENDIF

Return(lRsp)

///////////////////////////////////////////////////////////////////////
Static Function f_descpro(nItem,nObj)
///////////////////////////////////////////////////////////////////////
////nObj - 1 = Pedido de Venda; 2 = N.Fiscal ; 3 - Opcionais ; 9 - Opcionais Metalfrio

IF ( nObj == 2 )
	cDescri := RTRIM(aItens[nItem,5])
	oDescri:Refresh()
ELSEIF ( nObj == 3 )
	IF ( LEFT(aEmbOpc[nItem,1],1) == "E" )
		nEmbVol := 0
		IF ( aEmbOpc[nItem,3] > 0 )
			nIEmb   := nItem
			nEmbVol := aEmbOpc[nItem,4]
		ENDIF	
		oEmbVol:Refresh()
	ENDIF
	cVDescri := RTRIM(aEmbOpc[nItem,5])
	oVDescri:Refresh()
ELSEIF ( nObj == 9 )
	cVDescri := RTRIM(aOpcM[nItem,5])
	oVDescri:Refresh()
ELSEIF ( nObj == 1 )	
	cPDescri := RTRIM(aItemPV[nItem,8])
	oPDescri:Refresh()
ENDIF

IF ( nOpc == 3 )
	cPesoProd := ""
	oPesoProd:Refresh()
ELSEIF nOpc == 9 

	mQtdEtq   := 0
	nQtdEmb   := 0
	nQtdEtq   := 0
	nEtqImp   := 0
	nPrdImp   := 0

	IF ( nObj == 9 )
		SB1->(dbSeek(xFilial("SB1")+aOpcM[nItem,1]))

		_nSaldo   := aOpcM[nItem,3]
		_cProd    := aOpcM[nItem,1]
		_cItem    := aOpcM[nItem,1]
		_cPedCli  := aOpcM[nItem,4]
		_cCodCli  := aOpcM[nItem,2]	
		
		f_etqbarmetal("O",nItem)
		
	ELSE
		SB1->(dbSeek(xFilial("SB1")+aItens[nItem,2]))
		SC6->(dbSeek(xFilial("SC6")+aItens[nItem,6]+aItens[nItem,7]))
		
		_nSaldo   := aItens[nItem,3]
		_cProd    := aItens[nItem,2]
		_cItem    := "ITEM "+aItens[nItem,1]+" - "+_cProd
		_cPedCli  := RTRIM(SC6->C6_PEDCLI)
		_cCodCli  := SC6->C6_X_PROD	
		
		f_etqbarmetal("I",nItem)
		
	ENDIF
	_cFamilia := SB1->B1_CLDFAM
	_cDesc    := LEFT(SB1->B1_DESC,40)
	_cModelo  := LEFT(SB1->B1_DESC,40)
	
	oQtdEmb:Refresh()
	oQtdEtq:Refresh()
	//oEtqImpQ:Refresh()
	//oPrdImpQ:Refresh()
ENDIF

Return

///////////////////////////////////////////////////////////////////////
Static Function f_nnfiscal2()
///////////////////////////////////////////////////////////////////////
Local cQry,cCodEmbs,cCodOpcs,cQtdEmbs,cQtdOpcs,cAtuPeso
Local nQtde,nPeso,nX,nW,nV
Local lRsp := .T.

IF ( cSerie+cNFiscal <> mSerie+mNFiscal )

	cQry := "SELECT * FROM "+RetSqlName("SD2")+" D2,"+RetSqlName("SF2")+" F2"
	cQry += " WHERE F2.D_E_L_E_T_ = ' ' AND D2.D_E_L_E_T_ = ' '"
	cQry += " AND F2_FILIAL  = '"+xFilial("SF2")+"'"
	cQry += " AND F2_ESPECIE = 'SPED'"
	cQry += " AND F2_SERIE   = '"+cSerie+"'"
   cQry += " AND F2_DOC     = '"+cNFiscal+"'"
	cQry += " AND D2_FILIAL  = '"+xFilial("SD2")+"'"
	cQry += " AND D2_SERIE   = F2_SERIE"
	cQry += " AND D2_DOC     = F2_DOC"
	cQry += " AND D2_EMISSAO = F2_EMISSAO"
	cQry += " ORDER BY D2_ITEM "
	
	cQry := ChangeQuery(cQry)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

	TcSetField("TMP","F2_EMISSAO","D",08,0)
	TcSetField("TMP","F2_PBRUTO" ,"N",09,03)
	TcSetField("TMP","F2_PLIQUI" ,"N",09,03)
	
	dbSelectArea("TMP")
	dbGoTop()
	IF ( !EOF() )
		IF ( TMP->F2_TIPO == 'N' )
			SA1->(dbSeek(xFilial("SA1")+TMP->F2_CLIENTE+TMP->F2_LOJA))
			cCliente := SA1->A1_NOME
			cMunCli  := SA1->A1_MUN
			cNReduz  := SA1->A1_NREDUZ
			cEstado  := SA1->A1_EST
			cCodPais := SA1->A1_CODPAIS
		ELSE
			SA2->(dbSeek(xFilial("SA2")+TMP->F2_CLIENTE+TMP->F2_LOJA))
			cCliente := SA2->A2_NOME
			cMunCli  := SA2->A2_MUN
			cNReduz  := SA2->A2_NREDUZ
			cEstado  := SA2->A2_EST
			cCodPais := SA2->A2_CODPAIS
		ENDIF
		cTransp := SPACE(40)
		IF ( !EMPTY(TMP->F2_TRANSP) )
			SA4->(dbSeek(xFilial("SA4")+TMP->F2_TRANSP))
			cTransp := SA4->A4_NOME
		ENDIF
		CCH->(dbSeek(xFilial("CCH")+cCodPais))
		cCountry := RTRIM(CCH->CCH_PAIS)
		dEmissao := TMP->F2_EMISSAO
		cEstCli  := TMP->F2_EST
		nVolume  := TMP->F2_VOLUME1
		cEspecie := TMP->F2_ESPECI1
		nPB      := TMP->F2_PBRUTO
		nPL      := TMP->F2_PLIQUI
		cCodEmbs := ""
		cCodOpcs := ""
		cQtdEmbs := ""
		cQtdOpcs := ""
		cOPs     := ""
		
		aItens  := {}
		aEmbOpc := {}		
		
		DO WHILE !EOF()
			SC5->(dbSeek(xFilial("SC5")+TMP->D2_PEDIDO))
			SC6->(dbSeek(xFilial("SC6")+TMP->D2_PEDIDO+TMP->D2_ITEMPV))
			SB1->(dbSeek(xFilial("SB1")+TMP->D2_COD))
			
			IF ( EMPTY(cCodEmbs) )
				cCodEmbs := SC5->C5_CLCEMBS + SPACE(30)
				cQtdEmbs := SC5->C5_CLQEMBS + SPACE(07)
			ENDIF
			IF ( EMPTY(cCodOpcs) )
				cCodOpcs := SC5->C5_CLCOPCS + SPACE(30)
				cQtdOpcs := SC5->C5_CLQOPCS + SPACE(07)
			ENDIF			
			
			IF ( !EMPTY(SC6->C6_NUMOP) )
				cOPs := ( cOPs + IIF(!EMPTY(cOPs) , ",'" , "('" ) + SC6->C6_NUMOP+SC6->C6_ITEMOP+"001'" )            ///Para verificar se os opcionais (sonda,cabos,etc) já estao na estrutura de produto
			ENDIF	
			cAtuPeso := IIF(LEFT(SB1->B1_COLOR,2)=="VD" , "1" , "0" )
			
			AADD( aItens , { TMP->D2_ITEM     , ;
								  TMP->D2_COD      , ;
								  TMP->D2_QUANT    , ;
								  SB1->B1_PESO     , ;
								  LEFT(SB1->B1_DESC,60) , ;
								  TMP->D2_PEDIDO   , ;
								  TMP->D2_ITEMPV   , ;
								  SB1->B1_PESBRU   , ;
								  cAtuPeso } )

			dbSkip()
			
		ENDDO
		cOps := IIF(!EMPTY(cOps) , cOps + ")" , cOps )
		
		IF ( !EMPTY(cCodEmbs) )
			nX := 1
			nW := 1
			DO WHILE !EMPTY(SUBS(cCodEmbs,nX,30))
				SB1->(dbSeek(xFilial("SB1")+SUBS(cCodEmbs,nX,30)))
				nQtde := VAL(SUBS(cQtdEmbs,nW,3))
				nPeso := ( VAL(SUBS(cQtdEmbs,nW+3,4)) / 1000 )
				AADD(aEmbOpc , { "EMBALAGEM"          , ;
									  SUBS(cCodEmbs,nX,30) , ;
									  nQtde                , ;
									  nPeso                , ;
									  LEFT(SB1->B1_DESC,60) } )
				nX += 30
				nW += 7
			ENDDO
		ENDIF
		IF ( !EMPTY(cCodOpcs) )
			nX := 1
			nW := 1
			DO WHILE !EMPTY(SUBS(cCodOpcs,nX,30))
				SB1->(dbSeek(xFilial("SB1")+SUBS(cCodOpcs,nX,30)))
				nQtde := VAL(SUBS(cQtdOpcs,nW,4))
				nPeso := ( VAL(SUBS(cQtdOpcs,nW+4,3)) / 1000 )
				AADD(aEmbOpc , { "OPCIONAIS"           , ;
									  SUBS(cCodOpcs,nX,30) , ;
									  nQtde                , ;
									  nPeso                , ;
									  LEFT(SB1->B1_DESC,60) } )
				nX += 30
				nW += 7
			ENDDO
		ELSE
			aEmbOpc := { {SPACE(3) , SPACE(30) , 0 , 0 , SPACE(60) } }
		ENDIF
		
		mSerie   := cSerie
		mNFiscal := cNFiscal
		cDescri  := aItens[1,5]

		oLst:SetArray(aItens)

		oLst:bLine   := { || { IIF(aItens[oLst:nAt,9]=="1",oVd,oVm)  , ;
									  aItens[oLst:nAt,1]  , ;
									  aItens[oLst:nAt,2]  , ;
									  aItens[oLst:nAt,3]  , ;
									  aItens[oLst:nAt,4]  , ;
									  aItens[oLst:nAt,8] } }
		
		IF ( nOpc == 5 )
			oMulti:SetArray(aEmbOpc)

			oMulti:bLine := {|| { aEmbOpc[oMulti:nAt,1]  , ;
										 aEmbOpc[oMulti:nAt,2]  , ;
										 aEmbOpc[oMulti:nAt,3]  , ;
										 aEmbOpc[oMulti:nAt,4] } }

			oMulti:GoTop()
			oMulti:Refresh()
			oMulti:SetFocus()
			
		ENDIF
		oLst:Refresh()
		oDescri:Refresh()
				
	ELSE
		MsgStop("Não foi encontrado a Serie/N.Fiscal informada.","Atenção")
		lRsp := .F.
		IF ( !EMPTY(cSerie+cNFiscal) )
			cSerie   := mSerie
			cNFiscal := mNFiscal
		ENDIF
	ENDIF

	TMP->(dbCloseArea())
	
	IF ( !EMPTY(cEstCli) )
		IF ( cEstCli <> "EX" )
			
			IF ( nOpc == 5 )                                                       ////NOTA FISCAL
				nItemVol := 0
				nEmbVol  := 0
				nPBruto  := 0
				nPLiqui  := 0
				cCaptura := "Volume"
				nImpVol  := nVolume 
				cPesoVol := ""
				cTtlPB   := ""
				cTtlPL   := ""
				nV       := IIF(nImpVol > 99 , 3 , 2 )
				cNumVol  := STRZERO(nItemVol,nV)+"/"+STRZERO(nImpVol,nV)
				IF ( LEFT(aEmbOpc[1,1],1) == "E" )
					nEmbVol := aEmbOpc[1,4]
				ENDIF
				
				////
				////Exibe objetos
				////				
				oGroup4:Show()
				oMulti:Show()
				oGroup7:Show()
				oGroup8:Show()
				oGroup9:Show()
				oGroup10:Show()
				oGroup11:Show()
				oVDescri:Show()
				oSayBalanca:Show()
				oSayCaptura:Show()
				oEmbVol:Show()
				oNumVol:Show()
				oSPesoVol:Show()
				oPesoVol:Show()
				oSTtlPB:Show()
				oTtlPB:Show()
				oSTtlPL:Show()
				oTtlPL:Show()
				oTBmp1:Show()
				oTBmp2:Show()
				oTBmp5:Show()
				oEmbVol:Refresh()
			ENDIF
			
			////
			////Objetos/variaveis comum
			////
			lNFiscal := .T.
			oGroup6:Show()
			oTBmp8:Show()
			oTBmp10:Show()			
			
		ELSE
			oInvoice:SetFocus()		
		ENDIF

		IF ( nOpc == 9 )
		
			SB1->(dbSeek(xFilial("SB1")+aItens[1,2]))
			SC5->(dbSeek(xFilial("SC5")+aItens[1,6]))
			SC6->(dbSeek(xFilial("SC6")+aItens[1,6]+aItens[1,7]))
			
			lSeqVol   := .F.
			cVolImp   := "/ "+STRZERO(nVolume,3)
			nSeqVol   := 1
			nSeqAnt   := 1
			cVDescri  := " "
			mQtdEtq   := 0
			nQtdEmb   := 0
			nQtdEtq   := 0
			nEtqImp   := 0
			nPrdImp   := 0
			_nSaldo   := aItens[1,3]
			_cItem    := "ITEM "+aItens[1,1]+" - "+aItens[1,2]
			_cProd    := aItens[1,2]
			_cDesc    := LEFT(aItens[1,5],40)
			_cModelo  := LEFT(SB1->B1_DESC,40)
			_cFamilia := SB1->B1_CLDFAM
			_cPedCli  := RTRIM(SC6->C6_PEDCLI)
			_cCodCli  := SC6->C6_X_PROD	
			_cClNomCl := SC5->C5_CLNOMCL
			
			oTBmp7:Hide()
			oTBmp8:Show()
			oTBmp10:Show()			
			oGroupM2:Show()
			oGroupM3:Show()
			oGroupM4:Show()
			oGroupM5:Show()
			oQtdEmb:Show()
			oQtdEtq:Show()
			//oEtqImp:Show()
			//oPrdImp:Show()
			//oEtqImpQ:Show()
			//oPrdImpQ:Show()
			oVolImp:Show()
			oSeqVol:Show()
			oOpcM:Show()
			oVDescri:Show()
			
			oQtdEmb:SetFocus()
		ENDIF
		
	ENDIF	
	
ENDIF

Return(lRsp)

///////////////////////////////////////////////////////////////////////
Static Function f_nfiscal2()
///////////////////////////////////////////////////////////////////////
Local cQry,cCodEmbs,cCodOpcs,cQtdEmbs,cQtdOpcs,cAtuPeso
Local nQtde,nPeso,nX,nW,nV
Local lRsp := .T.

IF ( cSerie+cNFiscal <> mSerie+mNFiscal )

	cQry := "SELECT * FROM "+RetSqlName("SD2")+" D2,"+RetSqlName("SF2")+" F2"
	cQry += " WHERE F2.D_E_L_E_T_ = ' ' AND D2.D_E_L_E_T_ = ' '"
	cQry += " AND F2_FILIAL  = '"+xFilial("SF2")+"'"
	cQry += " AND F2_ESPECIE = 'SPED'"
	cQry += " AND F2_SERIE   = '"+cSerie+"'"
   cQry += " AND F2_DOC     = '"+cNFiscal+"'"
	cQry += " AND D2_FILIAL  = '"+xFilial("SD2")+"'"
	cQry += " AND D2_SERIE   = F2_SERIE"
	cQry += " AND D2_DOC     = F2_DOC"
	cQry += " AND D2_EMISSAO = F2_EMISSAO"
	cQry += " ORDER BY D2_ITEM "
	
	cQry := ChangeQuery(cQry)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

	TcSetField("TMP","F2_EMISSAO","D",08,0)
	TcSetField("TMP","F2_PBRUTO" ,"N",09,03)
	TcSetField("TMP","F2_PLIQUI" ,"N",09,03)
	
	dbSelectArea("TMP")
	dbGoTop()
	IF ( !EOF() )
		IF ( TMP->F2_TIPO == 'N' )
			SA1->(dbSeek(xFilial("SA1")+TMP->F2_CLIENTE+TMP->F2_LOJA))
			cCliente := SA1->A1_NOME
			cMunCli  := SA1->A1_MUN
			cNReduz  := SA1->A1_NREDUZ
			cEstado  := SA1->A1_EST
			cCodPais := SA1->A1_CODPAIS
		ELSE
			SA2->(dbSeek(xFilial("SA2")+TMP->F2_CLIENTE+TMP->F2_LOJA))
			cCliente := SA2->A2_NOME
			cMunCli  := SA2->A2_MUN
			cNReduz  := SA2->A2_NREDUZ
			cEstado  := SA2->A2_EST
			cCodPais := SA2->A2_CODPAIS
		ENDIF
		cTransp := SPACE(40)
		IF ( !EMPTY(TMP->F2_TRANSP) )
			SA4->(dbSeek(xFilial("SA4")+TMP->F2_TRANSP))
			cTransp := SA4->A4_NOME
		ENDIF
		CCH->(dbSeek(xFilial("CCH")+cCodPais))
		cCountry := RTRIM(CCH->CCH_PAIS)
		dEmissao := TMP->F2_EMISSAO
		cEstCli  := TMP->F2_EST
		nVolume  := TMP->F2_VOLUME1
		cEspecie := TMP->F2_ESPECI1
		nPB      := TMP->F2_PBRUTO
		nPL      := TMP->F2_PLIQUI
		cCodCli  := TMP->F2_CLIENTE
		cLojCli  := TMP->F2_LOJA
		cCodEmbs := ""
		cCodOpcs := ""
		cQtdEmbs := ""
		cQtdOpcs := ""
		cOPs     := ""
		
		aItens  := {}
		aEmbOpc := {}		
		
		DO WHILE !EOF()
			SC5->(dbSeek(xFilial("SC5")+TMP->D2_PEDIDO))
			SC6->(dbSeek(xFilial("SC6")+TMP->D2_PEDIDO+TMP->D2_ITEMPV))
			SB1->(dbSeek(xFilial("SB1")+TMP->D2_COD))
			
			IF ( EMPTY(cCodEmbs) )
				cCodEmbs := SC5->C5_CLCEMBS + SPACE(30)
				cQtdEmbs := SC5->C5_CLQEMBS + SPACE(07)
			ENDIF
			IF ( EMPTY(cCodOpcs) )
				cCodOpcs := SC5->C5_CLCOPCS + SPACE(30)
				cQtdOpcs := SC5->C5_CLQOPCS + SPACE(07)
			ENDIF			
			
			IF ( !EMPTY(SC6->C6_NUMOP) )
				cOPs := ( cOPs + IIF(!EMPTY(cOPs) , ",'" , "('" ) + SC6->C6_NUMOP+SC6->C6_ITEMOP+"001'" )            ///Para verificar se os opcionais (sonda,cabos,etc) já estao na estrutura de produto
			ENDIF	
			cAtuPeso := IIF(LEFT(SB1->B1_COLOR,2)=="VD" , "1" , "0" )
			
			AADD( aItens , { TMP->D2_ITEM     , ;
								  TMP->D2_COD      , ;
								  TMP->D2_QUANT    , ;
								  SB1->B1_PESO     , ;
								  LEFT(SB1->B1_DESC,60) , ;
								  TMP->D2_PEDIDO   , ;
								  TMP->D2_ITEMPV   , ;
								  SB1->B1_PESBRU   , ;
								  cAtuPeso } )

			dbSkip()
			
		ENDDO
		cOps := IIF(!EMPTY(cOps) , cOps + ")" , cOps )
		
		IF ( !EMPTY(cCodEmbs) )
			nX := 1
			nW := 1
			DO WHILE !EMPTY(SUBS(cCodEmbs,nX,30))
				SB1->(dbSeek(xFilial("SB1")+SUBS(cCodEmbs,nX,30)))
				nQtde := VAL(SUBS(cQtdEmbs,nW,3))
				nPeso := ( VAL(SUBS(cQtdEmbs,nW+3,4)) / 1000 )
				AADD(aEmbOpc , { "EMBALAGEM"          , ;
									  SUBS(cCodEmbs,nX,30) , ;
									  nQtde                , ;
									  nPeso                , ;
									  LEFT(SB1->B1_DESC,60) } )
				nX += 30
				nW += 7
			ENDDO
		ENDIF
		IF ( !EMPTY(cCodOpcs) )
			nX := 1
			nW := 1
			DO WHILE !EMPTY(SUBS(cCodOpcs,nX,30))
				SB1->(dbSeek(xFilial("SB1")+SUBS(cCodOpcs,nX,30)))
				nQtde := VAL(SUBS(cQtdOpcs,nW,4))
				nPeso := ( VAL(SUBS(cQtdOpcs,nW+4,3)) / 1000 )
				AADD(aEmbOpc , { "OPCIONAIS"           , ;
									  SUBS(cCodOpcs,nX,30) , ;
									  nQtde                , ;
									  nPeso                , ;
									  LEFT(SB1->B1_DESC,60) } )
				nX += 30
				nW += 7
			ENDDO
		ELSE
			aEmbOpc := { {SPACE(3) , SPACE(30) , 0 , 0 , SPACE(60) } }
		ENDIF
		
		mSerie   := cSerie
		mNFiscal := cNFiscal
		cDescri  := aItens[1,5]

		oLst:SetArray(aItens)

		oLst:bLine   := { || { IIF(aItens[oLst:nAt,9]=="1",oVd,oVm)  , ;
									  aItens[oLst:nAt,1]  , ;
									  aItens[oLst:nAt,2]  , ;
									  aItens[oLst:nAt,3]  , ;
									  aItens[oLst:nAt,4]  , ;
									  aItens[oLst:nAt,8] } }
		
		IF ( nOpc == 5 )
			oMulti:SetArray(aEmbOpc)

			oMulti:bLine := {|| { aEmbOpc[oMulti:nAt,1]  , ;
										 aEmbOpc[oMulti:nAt,2]  , ;
										 aEmbOpc[oMulti:nAt,3]  , ;
										 aEmbOpc[oMulti:nAt,4] } }

			oMulti:GoTop()
			oMulti:Refresh()
			oMulti:SetFocus()
			
		ENDIF
		oLst:Refresh()
		oDescri:Refresh()
				
	ELSE
		MsgStop("Não foi encontrado a Serie/N.Fiscal informada.","Atenção")
		lRsp := .F.
		IF ( !EMPTY(cSerie+cNFiscal) )
			cSerie   := mSerie
			cNFiscal := mNFiscal
		ENDIF
	ENDIF

	TMP->(dbCloseArea())
	
	IF ( !EMPTY(cEstCli) )
		IF ( cEstCli <> "EX" )
			
			IF ( nOpc == 5 )                                                       ////NOTA FISCAL
				nItemVol := 0
				nEmbVol  := 0
				nPBruto  := 0
				nPLiqui  := 0
				nVolDe   := 0
				cCaptura := "Volume"
				nImpVol  := nVolume 
				cPesoVol := ""
				cTtlPB   := ""
				cTtlPL   := ""
				nV       := IIF(nImpVol > 99 , 3 , 2 )
				cNumVol  := STRZERO(nItemVol,nV)+"/"+STRZERO(nImpVol,nV)
				IF ( LEFT(aEmbOpc[1,1],1) == "E" )
					nEmbVol := aEmbOpc[1,4]
				ENDIF
				
				////
				////Exibe objetos
				////				
				oGroupCB:Show()
				oGroup4:Show()
				oMulti:Show()
				oGroup7:Show()
				//oGroup8:Show()
				oGroup9:Show()
				oGroup10:Show()
				//oGroup11:Show()
				oVDescri:Show()
				//oSayBalanca:Show()
				//oSayCaptura:Show()
				//oEmbVol:Show()
				oNumVol:Show()
				//oSPesoVol:Show()
				//oPesoVol:Show()
				//oSTtlPB:Show()
				//oTtlPB:Show()
				//oSTtlPL:Show()
				//oTtlPL:Show()
				//oTBmp1:Show()
				//oTBmp2:Show()
				//oTBmp5:Show()
				oEmbCB:Show()
				oGroup6:Show()
				oTBmp8:Show()
				oEmbVol:Refresh()
			ENDIF
			
			////
			////Objetos/variaveis comum
			////
			lNFiscal := .T.
			//oTBmp10:Show()			
			
		ELSE
			oInvoice:SetFocus()		
		ENDIF

		IF ( nOpc == 9 )                                                        ////Etiqueta MetalFrio

			f_showetqmetal()
			
		ENDIF
		
	ENDIF	
	
ENDIF

Return(lRsp)

///////////////////////////////////////////////////////////////////////
Static Function f_invoice()
///////////////////////////////////////////////////////////////////////

lNFiscal := .T.
nItemVol := 0
nEmbVol  := 0
nPBruto  := 0
nPLiqui  := 0
cCaptura := "Volume"
nImpVol  := nVolume
cPesoVol := ""
cTtlPB   := ""
cTtlPL   := ""
nV       := IIF(nImpVol > 99 , 3 , 2 )
cNumVol  := STRZERO(nItemVol,nV)+"/"+STRZERO(nImpVol,nV)

////
////Exibe objetos
////
oGroupCB:Show()
oGroup4:Show()
oMulti:Show()
oGroup6:Show()
oGroup7:Show()
//oGroup8:Show()
oGroup9:Show()
oGroup10:Show()
//oGroup11:Show()
oVDescri:Show()
//oSayBalanca:Show()
//oSayCaptura:Show()
//oEmbVol:Show()
oNumVol:Show()
//oSPesoVol:Show()
//oPesoVol:Show()
//oSTtlPB:Show()
//oTtlPB:Show()
//oSTtlPL:Show()
//oTtlPL:Show()
//oTBmp1:Show()
//oTBmp2:Show()
//oTBmp5:Show()
oTBmp8:Show()
oEmbCB:Show()
oEmbVol:Refresh()

Return

///////////////////////////////////////////////////////////////////////
Static Function f_embcb()
///////////////////////////////////////////////////////////////////////
Local lRsp
Local cQry
Local nX       := AT("/",cNumVol)
Local cxObs    := ""
Local cxAI     := SUBS(cEmbCB,1,2)
Local cxPedido := SUBS(cEmbCB,3,6)
Local cxItemPV := SUBS(cEmbCB,9,2)
Local nxVolCB  := VAL(SUBS(cEmbCB,11,4))
Local nxVolNF  := VAL(LEFT(nX-1))

IF ( cxAI <> "10" )
	MsgStop("Código de Barras inválido.","Identificador de Aplicação")
	Return(.F.)
ENDIF

/*
cQry := "SELECT D2_DOC,D2_SERIE FROM "+RetSqlName("SD2")
cQry += " WHERE D_E_L_E_T_ = ' '"
cQry += " AND D2_FILIAL  = '"+xFilial("SD2")+"'"
cQry += " AND D2_DOC     = '"+cNFiscal+"'"
cQry += " AND D2_SERIE   = '"+cSerie+"'"
cQry += " AND D2_CLIENTE = '"+cCodCli+"'"
cQry += " AND D2_LOJA    = '"+cLojCli+"'"
cQry += " AND D2_PEDIDO  = '"+cxPedido+"'"
cQry += " AND D2_ITEMPV  = '"+cxItemPV+"' "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

lRsp := ( TMP->(D2_SERIE+D2_DOC) == cSerie+cNFiscal )

TMP->(dbCloseArea()
*/

nX := ASCAN(aItens , { |z| z[6]+z[7] == cxPedido+cxItemPV } )

IF ( nX == 0 )
	MsgStop("Código de Barras inválido.","Pedido x N.Fiscal")
	Return(.F.)
ENDIF

IF ( nxVolCB > (nxVolNF+1) )
	MsgStop("Leitura do Volume fora de sequencia.","Atenção")
	Return(.F.)
ELSEIF ( nxVolCB <= nxVolNF )
	MsgStop("Leitura do Volume já foi lido.","Atenção")
	Return(.F.)
ENDIF

nItemVol++
nX       := IIF(nImpVol > 99 , 3 , 2 )
cNumVol  := STRZERO(nItemVol,nV)+"/"+STRZERO(nImpVol,nV)

oNumVol:Refresh()

Return

///////////////////////////////////////////////////////////////////////
Static Function f_pesoprod()
///////////////////////////////////////////////////////////////////////
Local cxDescric := IIF(!EMPTY(aItemPV[oPLst:nAt,2]) , aItemPV[oPLst:nAt,8] , "" )

IF ( EMPTY(aItemPV[1,2]) )
	Return
ENDIF

IF ( nOpc == 7 )
	////
	////Esconde data-entry do Pedido
	////
	oGroupN1:Hide()
	oCBOP:Hide()
	oCBPV:Hide()
	oCBIT:Hide()
	oCBCLI:Hide()
	oBarraOP:Hide()
	oBarraPV:Hide()
	oBarraIT:Hide()
	oBarraCLI:Hide()
	oTBmpB1:Hide()
	oTBmpB2:Hide()
	oTBmpB3:Hide()
	//oTBmp4v:Hide()
	//oTBmp5v:Hide()
	oPVolFecha:Hide()
	oVolFecha:Hide()
	oBtn01:Hide()
ENDIF
nOpc := 3

cCaptura  := "Produto"
cPesoProd := ""
cBProd    := cxDescric

////
////Exibe objetos
////
oGroup5:Show()
oGroup6:Show()
oSayBalanca:Show()
oSayCaptura:Show()
oSSair:Show()
oSPesoProd:Show()
oPesoProd:Show()
oBProd:Show()
oTBmp1:Show()
oTBmp3:Show()

Return

///////////////////////////////////////////////////////////////////////
Static Function f_contagem()
///////////////////////////////////////////////////////////////////////
nOpc      := 2
nPesoPeca := 0
nPesoTara := 0
nPBruto   := 0
cCaptura  := "Contagem"
cQtyPeca  := ""
cTtlPP    := ""

////
////Exibe objetos
////
oGroup5:Show()
oGroup6:Show()
oGroup10:Show()
oGroup11:Show()
oGroup12:Show()
oGroup13:Show()
oSayBalanca:Show()
oSayCaptura:Show()
oSSair:Show()
oPesoPeca:Show()
oPesoTara:Show()
oSQtyPeca:Show()
oQtyPeca:Show()
oSTtlPP:Show()
oTtlPP:Show()
oTBmp1:Show()
oTBmp3:Show()

Return

///////////////////////////////////////////////////////////////////////
Static Function f_cappeso()
///////////////////////////////////////////////////////////////////////
Local lRead,nX,nV,nxPeso
Local cPict
Local cPeso    := ""
Local nHdll    := 0
Local nVezes   := 200
Local cPesoCap := ""

IF ( nOpc == 77 )
	IF ( nEmbVol = 0 )               ///!EMPTY(cPesoVol) .OR. 
		Return
	ENDIF	
ENDIF

c_Serial := RTRIM(mv_par01)                      ////Configuracao serial da balanca: Ex.: COM3:4800,p,7,1
*
IF MSOpenPort(nHdll,c_Serial)    

	Do While nVezes > 0

		MSRead(nHdll,@cPesoCap)   

		If Len(cPesoCap) >= 18    
			exit
		Endif
		
		nVezes --
		
	Enddo
	
	MsClosePort(nHdll)      // Fechando porta

	cPeso := Substr(cPesoCap, 5, 6 )
	
Else
   MsgStop("Não foi possível conectar a porta especificada." + chr(13) +"Verifique se o cabo da balança está conectado" + chr(13) + chr(13) + c_Serial)
	Return
EndIf
*
//nCount++
//cPeso := IIF(nCount==1,"0690",IIF(nCount==2,"0460",IIF(nCount==3,"0460","3100")))

nxPeso := Val(cPeso)/100
IF ( nxPeso <= 0 )
	Return
ENDIF	

DO CASE
	CASE nOpc == 3

		  cPesoProd := Transform(nxPeso,"@E 99.999") + " Kg"		
		  oPesoProd:Refresh()
	
			nX := Aviso("Peso do Produto","Pra qual tipo de Peso foi efetuado essa pesagem?",{"Bruto","Líquido","Cancela"},3)
			
			IF ( nX < 3 )
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek(xFilial("SB1")+aItemPV[oPLst:nAt,4])
				
				IF ( !EOF() )
					RecLock("SB1",.F.)
					IF ( nX == 1 )
						SB1->B1_PESBRU        := nxPeso
						aItemPV[oPLst:nAt,11] := nxPeso
					ELSE	
						SB1->B1_PESO         := nxPeso
						aItemPV[oPLst:nAt,7] := nxPeso
					ENDIF	
					MsUnlock()

					oPLst:SetArray(aItemPV)

					oPLst:bLine := {|| { IIF(aItemPV[oPLst:nAt,1]=="0",oVm,oVd) , ;
												aItemPV[oPLst:nAt,2]  , ;
												aItemPV[oPLst:nAt,3]  , ;
												aItemPV[oPLst:nAt,4]  , ;
												aItemPV[oPLst:nAt,5]  , ;
												aItemPV[oPLst:nAt,6]  , ;
												aItemPV[oPLst:nAt,7]  , ;
												aItemPV[oPLst:nAt,11] } }

					oPLst:Refresh()
					
				ENDIF
			ENDIF	
					
	CASE nOpc == 4                                           ////Peso do volume no Pedido de Venda
	
		  nItemVol++

		  IF ( nItemVol == 1 )
			  aPesagem := {}
		  ELSEIF ( nItemVol > nImpVol )
			  nItemVol--
			  Return
		  ENDIF
		  /*
		  IF ( aItemPv[1,2] == "049386" )
			  nxPeso := IIF(nItemVol < 4 , 63.965 , 93.965 )
		  ELSEIF ( aItemPV[1,2] == "049640" )
		     nxPeso := 9.465 
		  ELSE
			  nxPeso := 25.299
		  ENDIF
		  */
		  nPeso   := nxPeso
		  cPict   := "@E 999,999.999"
		  nPLq    := ( nPeso - nEmbVol )
		  nPLiqui += nPLq
		  nPBruto += nPeso

		  nV       := IIF(nImpVol > 99 , 3 , 2 )
		  cNumVol  := STRZERO(nItemVol,nV)+"/"+STRZERO(nImpVol,nV)
		  
		  cPesoVol := Transform(nPeso,cPict) + " Kg"
		  cTtlPB   := Transform(nPBruto,cPict) + " Kg"
		  cTtlPL   := Transform(nPLiqui,cPict) + " Kg"
		  
		  IF ( nItemVol > LEN(aPesagem) )
			  AADD(aPesagem , { nPeso , nPLq , nEmbVol , "" } )       ////Pra efeito de cancelamento da pesagem
		  ELSE
			  aPesagem[nItemVol,1] := nPeso
			  aPesagem[nItemVol,2] := nPLq
			  aPesagem[nItemVol,3] := nEmbVol
		  ENDIF

		  oNumVol:Refresh()
		  oPesoVol:Refresh()
		  oTtlPB:Refresh()
		  oTtlPL:Refresh()

	CASE nOpc == 77                                           ////Peso do volume no Pedido de Venda (Coletor)
	
		  nItemVol++

		  IF ( nItemVol == 1 )
			  aPesagem := {}
		  ELSEIF ( nItemVol > nImpVol )
			  nItemVol--
			  Return
		  ENDIF
		  /*
		  IF ( aItemPv[1,2] == "049386" )
			  nxPeso := IIF(nItemVol < 4 , 63.965 , 93.965 )
		  ELSEIF ( aItemPV[1,2] == "049640" )
		     nxPeso := 9.465 
		  ELSE
			  nxPeso := 25.299
		  ENDIF
		  */
		  nPeso   := nxPeso
		  cPict   := "@E 999,999.999"
		  nPLq    := ( nPeso - nEmbVol )
		  nPLiqui += nPLq
		  nPBruto += nPeso

		  nV       := IIF(nImpVol > 99 , 3 , 2 )
		  cNumVol  := STRZERO(nItemVol,nV)+"/"+STRZERO(nImpVol,nV)
		  
		  cPesoVol := Transform(nPeso,cPict) + " Kg"
		  cTtlPB   := Transform(nPBruto,cPict) + " Kg"
		  cTtlPL   := Transform(nPLiqui,cPict) + " Kg"
		  
		  ///nV := ASCAN(aPesagem , { |z| z[1]==STRZERO(nItemVol,4) } )
		  IF ( nItemVol > LEN(aPesagem) )   ///nV == 0 )
			  AADD(aPesagem , { nPeso , nPLq , nEmbVol , "" } )                             ////Pra efeito de cancelamento da pesagem
		  ELSE
			  aPesagem[nItemVol,1] := nPeso
			  aPesagem[nItemVol,2] := nPLq
			  aPesagem[nItemVol,3] := nEmbVol
		  ENDIF

		  oNumVol:Refresh()
		  oPesoVol:Refresh()
		  oTtlPB:Refresh()
		  oTtlPL:Refresh()
		  		  
	CASE nOpc == 5

		  nItemVol++

		  IF ( nItemVol == 1 )
			  aPesagem := {}
		  ELSEIF ( nItemVol > nImpVol )
			  nItemVol--
			  Return
		  ENDIF
		  //nxPeso  := IIF(nItemVol==1 , 9.32 , 7.02 )
		  cPict   := "@E 999,999.999"
		  nPeso   := nxPeso 
		  nPLq    := ( nPeso - nEmbVol )
		  nPLiqui += nPLq
		  nPBruto += nPeso

		  nV      := IIF(nImpVol > 99 , 3 , 2 )
		  cNumVol := STRZERO(nItemVol,nV)+"/"+STRZERO(nImpVol,nV)

		  cPesoVol := Transform(nPeso,cPict) + " Kg"
		  cTtlPB   := Transform(nPBruto,cPict) + " Kg"
		  cTtlPL   := Transform(nPLiqui,cPict) + " Kg"

		  IF ( nItemVol > LEN(aPesagem) )
			  AADD(aPesagem , { nPeso , nPLq , nEmbVol , "" } )                      ////Pra efeito de cancelamento da pesagem
		  ELSE
			  aPesagem[nItemVol,1] := nPeso
			  aPesagem[nItemVol,2] := nPLq
			  aPesagem[nItemVol,3] := nEmbVol
		  ENDIF
		  
		  oNumVol:Refresh()
		  oPesoVol:Refresh()
		  oTtlPB:Refresh()
		  oTtlPL:Refresh()
		  
		  f_impretq()		                                                  ////Imprime etiqueta

	CASE nOpc == 2
	
		  cPict   := "@E 99999,999"
		  nxPeso  := INT( ( nPeso - nPesoTara)  / nPesoPeca )
		  nPBruto += nxPeso

		  cQtyPeca := Transform(nxPeso,cPict) + " Pç"
		  cTtlPP   := Transform(nPBruto,cPict) + " Pç"

		  //oPesoPeca:Refresh()
		  //oPesoTara:Refresh()
		  oQtyPeca:Refresh()
		  oTtlPP:Refresh()
		  
ENDCASE
		
Return

///////////////////////////////////////////////////////////////////////
Static Function f_cancmetal()        
///////////////////////////////////////////////////////////////////////

lSair := .T.

oDlg:End()
			
Return

///////////////////////////////////////////////////////////////////////
Static Function f_encernf()        
///////////////////////////////////////////////////////////////////////
Local nX,nZ,nQtde
Local lBaixa
Local cNumSeq,cQry,cProduto
//Local aOPs       := {}
//Local cDocumento := "CE"+RIGHT(cNFiscal,7)

/*
///A baixa de opcionais/embalagem ocorre na separacao dos pedidos para faturamento
IF ( EMPTY(cOPs) )
	aOPs := {SPACE(30)}
ELSE	
	////
	////Cria array com os componentes da ordem de producao dos itens da nota fiscal, caso tenha.
	////Para verificar se, caso tenha opcionais, existe no empenho da ordem de producao.
	////Caso exista, nao baixa do estoque. Caso contrario, baixa do estoque.
	////
	cQry := "SELECT DISTINCT(D4_COD) D4COD FROM "+RetSqlName("SD4")
	cQry += " WHERE D_E_L_E_T_ = ' '"
	cQry += " AND D4_FILIAL  = '"+xFilial("SD4")+"'"
	cQry += " AND D4_OP IN "+cOPs
	cQry += " ORDER BY D4_COD "
	
	cQry := ChangeQuery(cQry)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

	dbSelectArea("TMP")
	dbGoTop()
	DO WHILE !EOF()
		AADD(aOPs , TMP->D4COD )
		dbSkip()
	ENDDO
	TMP->(dbCloseArea())		
ENDIF

dbSelectArea("SD3")
dbSetOrder(2)
FOR nX:=1 TO LEN(aEmbOpc)
	 cProduto := aEmbOpc[nX,2]
	 nQtde    := aEmbOpc[nX,3]
	 
	 IF ( !EMPTY(cProduto) .AND. nQtde > 0 )
		 dbSeek(xFilial("SD3")+cDocumento+cProduto)
		 IF ( SD3->(D3_FILIAL+SD3->D3_DOC+SD3->D3_COD) <> (xFilial("SD3")+cDocumento+cProduto) .OR. SD3->D3_ESTORNO=="S" )
			 
			 IF ( LEFT(aEmbOpc[nX,1],1) == "E" )
				 lBaixa := .T.
			 ELSE
				 nZ     := ASCAN(aOPs , cProduto )              ////Opcionais
				 lBaixa := ( nZ = 0 )                           ////nZ = 0, baixa estoque, ou seja, nao existe o(s) opcional(is) informado na estrutura.
			 ENDIF
			 
			 IF ( lBaixa )
			 
				 SB1->(dbSeek(xFilial("SB1")+cProduto))
				 
				 dbSelectArea("SB2")
				 dbSetOrder(1)
				 dbSeek(xFilial("SB2")+cProduto+mvLocal)
				 IF ( EOF() )
					 RecLock("SB2",.T.)
					 SB2->B2_FILIAL := xFilial("SB2")
					 SB2->B2_COD    := cProduto
					 SB2->B2_LOCAL  := mvLocal
					 B2VATU1        := 0
				 ELSE
					 B2VATU1 := ROUND(nQtde * SB2->B2_CM1 , 4 )
					 RecLock("SB2",.F.)
				 ENDIF
				 SB2->B2_QATU  := ( SB2->B2_QATU - nQtde )
				 SB2->B2_VATU1 := ( SB2->B2_VATU1 - B2VATU1 )
				 SB2->B2_USAI  := ddatabase
				 MsUnlock()
				 
				 cNumSeq := ProxNum()
				 
				 dbSelectArea("SD3")
				 RecLock("SD3",.T.)
				 SD3->D3_FILIAL  := xFilial("SD3")
				 SD3->D3_COD     := cProduto
				 SD3->D3_NUMSEQ  := cNumSeq
				 SD3->D3_TM      := "508"  
				 SD3->D3_CF      := "RE0"
				 SD3->D3_QUANT   := nQtde
				 SD3->D3_CUSTO1  := B2VATU1
				 SD3->D3_LOCAL   := mvLocal
				 SD3->D3_DOC     := cDocumento
				 SD3->D3_UM      := SB1->B1_UM
				 SD3->D3_EMISSAO := ddatabase
				 SD3->D3_TIPO    := SB1->B1_TIPO
				 SD3->D3_CHAVE   := "E0"
				 SD3->D3_GRUPO   := SB1->B1_GRUPO
				 SD3->D3_CONTA   := SB1->B1_CONTA
				 SD3->D3_CC      := SB1->B1_CC
				 SD3->D3_USUARIO := M->cUserName
				 SD3->D3_X_OBS   := "REF.NF."+cNFiscal+"/"+RTRIM(cSerie)
				 MsUnlock()
			 
			 ENDIF
			 
		 ENDIF
		 
	  ENDIF
NEXT	
*/
lSair := .T.

oDlg:End()
			
Return

///////////////////////////////////////////////////////////////////////
Static Function f_captsair()
///////////////////////////////////////////////////////////////////////

oGroup5:Hide()
oGroup6:Hide()
oSayBalanca:Hide()
oSayCaptura:Hide()
oSSair:Hide()
oTBmp1:Hide()
oTBmp3:Hide()

IF ( nOpc == 2 )
	nOpc := 0
	oGroup10:Hide()
	oGroup11:Hide()
	oGroup12:Hide()
	oGroup13:Hide()
	oPesoPeca:Hide()
	oPesoTara:Hide()
	oSQtyPeca:Hide()
	oQtyPeca:Hide()
	oSTtlPP:Hide()
	oTtlPP:Hide()

ELSE	

	nOpc := nOpcA		

	oSPesoProd:Hide()
	oPesoProd:Hide()
	oBProd:Hide()
	
	IF ( nOpc == 7 )
		oGroupN1:Show()
		oCBOP:Show()
		oCBPV:Show()
		oCBIT:Show()
		oCBCLI:Show()
		oBarraOP:Show()
		oBarraPV:Show()
		oBarraIT:Show()
		oBarraCLI:Show()
		oTBmpB1:Show()
		oTBmpB2:Show()
		oTBmpB3:Show()
		//oTBmp4v:Show()
		//oTBmp5v:Show()
		IF ( !EMPTY(cVolFecha) )
			oPVolFecha:Show()
			oVolFecha:Show()
		ENDIF
		IF ( nTQty > 0 )
			oBtn01:Show()
		ENDIF	
		
	ENDIF

ENDIF	
			
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
			///If ( ( nQtdEtq * nQtdEmb ) > _nSaldo )
				///MsgAlert("A soma da(s) quantidade(s) informada ultrapassa a quantidade faturada. Certifique-se dos valores informado antes de imprimir.","Atenção")
			///EndIf
			If ( ( nQtdEtq + nSeqVol - 1 ) > nVolume )
				MsgAlert("A quantidade informada ultrapassa a quantidade do Volume.","Atenção")
			EndIf
			
EndCase

Return

//////////////////////////////////////////////////
User Function CFTXG200()
//////////////////////////////////////////////////
Local nW,nZ,nRecSC5
Local cRazSoc,cDestino,cCliente
Local lRsp     := .T.
Local lRefresh := .F.
Local cVar     := ReadVar()
Local nX       := n
Local nPAnt    := 0
Local nPAtu    := 0
Local cxPedAnt := aCols[n,1]

DO CASE
   CASE cVar == "M->TB_NUM"
			IF ( M->TB_NUM <> aCols[n,1] )
				IF ( EMPTY(M->TB_NUM) .AND. !EMPTY(cxPedAnt) )
					IF ( LEN(aCols) == 1 )
						Return(.F.)
					ENDIF	
					ADEL(aCols,n)
					ASIZE(aCols,( LEN(aCols) - 1 ) )
					n--
					*
					nW := 0
					FOR nZ:=LEN(aItemPV) TO 1 STEP -1
						 IF ( aItemPV[nZ,2]==cxPedAnt )
							 nW++
							 ADEL(aItemPV,nZ)
						 ENDIF
					NEXT
					IF ( nW > 0 )
						lRefresh := .T.
						cPedAnt  := IIF(cPedAnt==cxPedAnt , aCols[n,1] , cPedAnt )
						ASIZE(aItemPV,( LEN(aItemPV) - nW ) )
					ENDIF					
				ELSE
					SC5->(dbSeek(xFilial("SC5")+M->TB_NUM))
					IF ( SC5->(EOF()) )
						MsgStop("Pedido não cadastrado.","Atenção")
						lRsp := .F.
					ELSE
						///IF ( SC5->C5_BLQ == "1" )
						///	MsgStop("Pedido se encontra Bloqueado por Regra.","Atenção")
						///	Return(.F.)
						///ENDIF
						///IF ( SC5->C5_LIBEROK == "S" )
						///	MsgStop("Pedido encerrado.","Atenção")
						///	Return(.F.)
						///ENDIF
						IF ( !EMPTY(cPedAnt) .AND. LEN(aCols) > 1 )
							nRecSC5  := SC5->(RECNO())                                          ////Salva registro atual do SC5
							cCliente := ( SC5->C5_CLIENTE + SC5->C5_LOJACLI )
							SC5->(dbSeek(xFilial("SC5")+cPedAnt))
							IF ( cCliente <> SC5->(C5_CLIENTE+C5_LOJACLI) )
								MsgStop("Só é permitido vários pedidos para um mesmo Cliente.","Atenção")
								Return(.F.)
							ENDIF
							SC5->(dbGoTo(nRecSC5))
						ENDIF	
						IF ( SC5->C5_TIPO $ "DB" )
							SA2->(dbSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJAENT))
							cRazSoc  := SA2->A2_NOME
							cDestino := RTRIM(SA2->A2_MUN)+IIF(SA2->A2_EST<>"EX"," / "+SA2->A2_EST , IIF(!EMPTY(SA2->A2_CLNPAIS)," / "+SA2->A2_CLNPAIS,"") )
						ELSE
							SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJAENT))
							cRazSoc  := SA1->A1_NOME
							cDestino := RTRIM(SA1->A1_MUN)+IIF(SA1->A1_EST<>"EX"," / "+SA1->A1_EST,"")
						ENDIF
						IF ( EMPTY(aCols[1,2]) )
							oPPLiqOpc:Show()
							oPLiqOpc:Show()
						ENDIF
						aCols[n,2] := cRazSoc
						aCols[n,3] := cDestino
						nW         := 0
						
						IF ( EMPTY(aItemPV[1,2]) )
							aItemPV := {}
						ELSEIF ( !EMPTY(cxPedAnt) )
							FOR nZ:=LEN(aItemPV) TO 1 STEP -1
								 IF ( aItemPV[nZ,2]==cxPedAnt )
									 nW++
									 ADEL(aItemPV,nZ)
								 ENDIF
							NEXT
							IF ( nW > 0 )
								ASIZE(aItemPV,( LEN(aItemPV) - nW ) )
							ENDIF
						ENDIF 
						
						dbSelectArea("SC6")
						dbSetOrder(1)
						dbSeek(xFilial("SC6")+SC5->C5_NUM,.T.)
						DO WHILE !EOF().AND.C6_FILIAL==xFilial("SC6").AND.C6_NUM==SC5->C5_NUM
							IF ( SC6->C6_QTDVEN > SC6->C6_QTDENT )
								SB1->(dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
								AADD( aItemPV , { "0"             , ;
													  SC6->C6_NUM      , ;
													  SC6->C6_ITEM     , ;
													  SC6->C6_PRODUTO  , ;
													  (SC6->C6_QTDVEN - SC6->C6_QTDENT) , ;
													  0                , ;
													  SB1->B1_PESO     , ;
													  LEFT(SB1->B1_DESC,60) , ;
													  SC6->C6_QTDVEN  , ;
													  SPACE(08)  , ;
													  SB1->B1_PESBRU , ;
													  SB1->B1_COLOR } )
							ENDIF
							dbSkip()
						ENDDO

						cPedAnt  := M->TB_NUM
						lRefresh := .T.
						
					ENDIF	
				
				ENDIF

				IF ( lRefresh )
				
					aSort(aItemPV,,, { |x,y| x[2]+x[3] < y[2]+y[3] } )
					
					oPLst:SetArray(aItemPV)

					oPLst:bLine := {|| { IIF(aItemPV[oPLst:nAt,1]=="0",oVm,oVd) , ;
												aItemPV[oPLst:nAt,2]  , ;
												aItemPV[oPLst:nAt,3]  , ;
												aItemPV[oPLst:nAt,4]  , ;
												aItemPV[oPLst:nAt,5]  , ;
												aItemPV[oPLst:nAt,6]  , ;
												aItemPV[oPLst:nAt,7]  , ;
												aItemPV[oPLst:nAt,11] } }
				
					oPLst:Refresh()
					oPedido:Refresh()
					cPDescri := RTRIM(aItemPV[1,8])
					oPDescri:Refresh()

				ENDIF
				
			ENDIF
	
ENDCASE	

Return(lRsp)

//////////////////////////////////////////////////////////////////////////////
Static Function f_printPV()
//////////////////////////////////////////////////////////////////////////////
Local cProduto,cAno,cExt,cxPedido,dxData
Local fArq
Local mLinDet,cLinDet,c_Solic,c_OP,c_Tp
Local aLinhas,aRows
Local nW         := 1
Local nCtd       := 0
Local oExcel     := FWMSEXCEL():New()
Local cWorkSheet := "PEDIDOS"
Local oExcelApp

lRsp := ( LEN(aPrtPV) > 0 )

IF ( !lRsp )
	Return
ENDIF

cRelato := "CFATG200"

cLinDet := "P E D I D O S      P A R A      F A T U R A M E N T O"

oExcel:AddworkSheet(cWorkSheet)
oExcel:AddTable (cWorkSheet,cLinDet)
oExcel:AddColumn(cWorkSheet,cLinDet,"NOTA FISCAL",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"VOLUME",1,2)
oExcel:AddColumn(cWorkSheet,cLinDet,"PESO BRUTO",1,2)
oExcel:AddColumn(cWorkSheet,cLinDet,"PESO LIQ.",1,2)
oExcel:AddColumn(cWorkSheet,cLinDet,"C L I E N T E",1,1)                                      ///Alinhamento da coluna [3] - ( 1-Left,2-Center,3-Right )
oExcel:AddColumn(cWorkSheet,cLinDet,"PEDIDO",1,1)                                             ///Codigo de formatação  [2] - ( 1-General,2-Number,3-Monetário,4-DateTime )
oExcel:AddColumn(cWorkSheet,cLinDet,"PRODUTO",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"DESCRIÇÃO",1,1)
oExcel:AddColumn(cWorkSheet,cLinDet,"QUANT.",3,2)
oExcel:AddColumn(cWorkSheet,cLinDet,"O B S E R V A Ç Ã O",1,1)
*********************************************

aSort(aPrtPV,,, { |x,y| x[1]+x[2]+x[3]+x[4] < y[1]+y[2]+y[3]+y[4] } )

DO WHILE nW <= LEN(aPrtPV)

	SC5->(dbSeek(xFilial("SC5")+aPrtPV[nW,3]))

	cNomCl := SC5->C5_CLNOMCL
	cItem  := aPrtPV[nW,1]
	nVol   := aPrtPV[nW,8]
	nPB    := aPrtPV[nW,9]
	nPL    := aPrtPV[nW,10]
	aRows  := {}	
	
	DO WHILE nW <= LEN(aPrtPV) .AND. aPrtPV[nW,1]==cItem

		IF ( aPrtPV[nW,2] <> "3" )                                      ///3=Embalagem

			cxPedido := IIF(aPrtPV[nW,2] == "2" , "OPCIONAL" , aPrtPV[nW,3]+"-"+aPrtPV[nW,4] )
			
			aRows   := { "[                    ]"  , ;
							 nVol                      , ;
							 nPB                       , ;
							 nPL                       , ;
							 cNomCl                    , ;
							 cxPedido                  , ;
							 aPrtPV[nW,5]              , ;
							 aPrtPV[nW,6]              , ;
							 aPrtPV[nW,7]              , ;
							 "[                                                                      ]"  }
			
			oExcel:AddRow(cWorkSheet,cLinDet,aRows)

			nVol := nPB := nPL := 0
			
			IF ( !EMPTY(cNomCl) )
				cNomCl := ""
			ENDIF
			
		ENDIF
		
		nW++
		
	ENDDO	

	aRows := {"","","","","","","","","",""}
	
	oExcel:AddRow(cWorkSheet,cLinDet,aRows)
			
ENDDO
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

lPrtPV := .T.

MS_FLUSH()

Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_coleta()
//////////////////////////////////////////////////////////////////////////////
Local cQry
Local xColet1,xColet2
Local cColet1 := SUBS(DTOS(ddatabase),3,2)
////
////Busca a ultima numeracao da coleta
////

cQry := "SELECT TOP 1 F2_CCOLETA "
cQry += "FROM "+RetSqlName("SF2")+" "
cQry += "WHERE D_E_L_E_T_ = ' ' "
cQry += "AND F2_FILIAL  = '"+xFilial("SF2")+"' "
cQry += "AND F2_CCOLETA <> ' ' "
cQry += "ORDER BY F2_CCOLETA DESC "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'CLT', .T., .T.)

IF ( !EMPTY(CLT->F2_CCOLETA) )
	xColet1 := SUBS(CLT->F2_CCOLETA,1,2)
	xColet2 := IIF(xColet1<>cColet1 , 1 , ( VAL(SUBS(CLT->F2_CCOLETA,3,4)) + 1 ) )
ELSE
	xColet2 := 1
ENDIF	
cColeta := cColet1 + STRZERO(xColet2,4)

CLT->(dbCloseArea())

oGroupM9:Show()
oGroupMA:Show()
oGroupMB:Show()
oEmisDe:Show()
oEmisAte:Show()
oEmissDe:Show()
oEmissAte:Show()
oColet:Show()
oColeta:Show()
oTtlVol:Show()
oTtlPeso:Show()
oTtlVlr:Show()
oTtVol:Show()
oTtPeso:Show()
oTtVlr:Show()
oTranspc:Show()
oTranspct:Show()
oTranspctd:Show()
oMark:oBrowse:Show()
oTBmp4c:Show()
oTBmp5c:Show()

oEmissDe:SetFocus()

nOpc  := 8
nOpcA := nOpc

Return

//////////////////////////////////////////////////////////
Static Function f_Transp()
//////////////////////////////////////////////////////////
Local lRsp := .T.

IF ( !EMPTY(cTranspc) )
	
	SA4->(dbSeek(xFilial("SA4")+cTranspc))
	IF ( SA4->(EOF()) )
		Help(" ",1,"REGNOIS",,,4,1)		
		lRsp := .F.
	ELSE
		cTranspct := RTRIM(SA4->A4_NOME)
		oTranspctd:Refresh()
	ENDIF
ENDIF

Return(lRsp)

//////////////////////////////////////////////////////////////////////////////
Static Function f_seekcol()
//////////////////////////////////////////////////////////////////////////////
Local cOrde,cCond,cQuery,cQry

IF ( mdEmissDe <> dEmissDe .OR. mdEmissAte <> dEmissAte )
	mdEmissDe  := dEmissDe
	mdEmissAte := dEmissAte
	nTtItem    := 0
	nTtVol     := 0
	nTtPeso    := 0
	nTtVlr     := 0
	
	dbSelectArea("TRB")
	__dbZap()
	
	cOrde  := " ORDER BY F2_EMISSAO,F2_DOC " 
	cCond  := " WHERE A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' "
	cCond  := cCond + "AND F2_FILIAL = '"+xFilial("SF2")+"' "
	cCond  := cCond + "AND F2_EMISSAO >= '"+Dtos(dEmissDe)+"' AND F2_EMISSAO <= '"+Dtos(dEmissAte)+"' "
	cCond  := cCond + "AND F2_TIPO = 'N' "
	cCond  := cCond + "AND F2_EST <> 'AM' "
	cCond  := cCond + "AND F2_CHVNFE <> ' ' "
	cCond  := cCond + "AND F2_CCOLETA = ' ' "
	cCond  := cCond + "AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA "
			
	cQuery := "SELECT F2_EMISSAO,F2_CLIENTE,F2_LOJA,F2_DOC,F2_SERIE,F2_VOLUME1,F2_PBRUTO,F2_VALBRUT,F2_EST,A.R_E_C_N_O_ F2_RECNO,A1_NREDUZ" 
	cQuery += " FROM "+RetSqlName("SF2")+" A,"+RetSqlName("SA1")+" B" + cCond + cOrde
			
	cQry := ChangeQuery(cQuery)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

	TcSetField("TMP","F2_EMISSAO","D",8,0)
	TcSetField("TMP","F2_RECNO","N",8,0)

	dbSelectArea("TMP")
	dbGoTop()
	DO WHILE !EOF()
		SD2->(dbSeek(xFilial("SD2")+TMP->F2_DOC+TMP->F2_SERIE+TMP->F2_CLIENTE+TMP->F2_LOJA))
		SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))

		nTtItem++
		nTtVol  += TMP->F2_VOLUME1
		nTtPeso += TMP->F2_PBRUTO
		nTtVlr  += TMP->F2_VALBRUT
		
		RecLock("TRB",.T.)
		TRB->TB_OK       := cMarca
		TRB->TB_ITEM     := STRZERO(nTtItem,4)
		TRB->TB_NFISCAL  := TMP->F2_DOC
		TRB->TB_SERIE    := TMP->F2_SERIE
		TRB->TB_EMISSAO  := TMP->F2_EMISSAO
		TRB->TB_VOLUME   := TMP->F2_VOLUME1
		TRB->TB_PESO     := TMP->F2_PBRUTO
		TRB->TB_VALOR    := TMP->F2_VALBRUT
		TRB->TB_CLIENTE  := TMP->A1_NREDUZ
		TRB->TB_CFOP     := SF4->F4_TEXTO
		TRB->TB_RECNO    := TMP->F2_RECNO
		MsUnlock()
		
		dbSelectArea("TMP")
		dbSkip()
		
	ENDDO
	
	TMP->(dbCloseArea())
	
	dbSelectArea("TRB")
	dbGoTop()
	oMark:oBrowse:GoTop()
	oMark:oBrowse:Refresh()
	
ENDIF

Return

/////////////////////////////////////////////////////////////////////////////////
Static Function f_Mark()
/////////////////////////////////////////////////////////////////////////////////
Local nX

IF ( TRB->(!EOF()) )
	RecLock("TRB",.F.)
	IF ( IsMark("TB_OK") )
		TRB->TB_OK := " "
		nTtVol  -= TRB->TB_VOLUME
		nTtPeso -= TRB->TB_PESO
		nTtVlr  -= TRB->TB_VALOR
	ELSE
		TRB->TB_OK := cMarca
		nTtVol  += TRB->TB_VOLUME
		nTtPeso += TRB->TB_PESO
		nTtVlr  += TRB->TB_VALOR
	ENDIF
	MsUnlock()
	oTtVol:Refresh()
	oTtPeso:Refresh()
	oTtVlr:Refresh()
	oMark:oBrowse:Refresh()	
ENDIF

Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_printcol()
//////////////////////////////////////////////////////////////////////////////
Local mLinDet,mData
Local nX   := 0
Local nVol := 0
Local nVlr := 0
Local nPso := 0
Local fArq := fCreate("C:\RELATO\Coleta diaria.txt")     

SET CENTURY ON
mData := DTOC(ddatabase)
SET CENTURY OFF

mLinDet := "|CB|COLETA DIARIA - PERIODO DE "+DTOC(mdEmissDe)+" A "+DTOC(mdEmissAte)+"|"+SUBS(cColeta,3,4)+"  |"+mData+"|"+STRZERO(nTtItem,4)+"|"+cTranspct
nx      := LEN(RTRIM(mLinDet))
mLinDet += SPACE(115-nx)
mLinDet += "|"+Chr(13)+Chr(10)
FWrite(fArq,mLinDet)
*
mLinDet := "|CB|ITEM |NOTA FISCAL |VOLUME |VALOR         |PESO     |                                                           |"   
mLinDet += Chr(13)+Chr(10)
mLinDet += "|CB|=====|============|=======|==============|=========|===========================================================|"                        
       ///      9999  999999999    99999   9999999999.99  99999.99  99/99/99                 
mLinDet += Chr(13)+Chr(10)                          ///                                                                                                999999.99  9999999999.99  9999.99.99                           
FWrite(fArq,mLinDet)

nX := 0
dbSelectArea("TRB")
dbGoTop()
DO WHILE !EOF()
	IF ( !EMPTY(TRB->TB_OK) )
		nVol += TRB->TB_VOLUME
		nVlr += TRB->TB_VALOR
		nPso += TRB->TB_PESO
		nX++
		///
		///Grava linha Detalhe
		///
		mLinDet := "|DT|"+STRZERO(nX,4)+" "                                              
		mLinDet += "|"+TRB->TB_NFISCAL+"   "                                                 
		mLinDet += "|"+STRZERO(TRB->TB_VOLUME,5)+"  "                                                 
		mLinDet += "|"+STRTRAN(TRANSFORM(TRB->TB_VALOR,"@E 9999999999.99"),",",".")+" "               
		mLinDet += "|"+STRTRAN(TRANSFORM(TRB->TB_PESO,"@E 99999.99"),",",".")+" "
		mLinDet += "|"+" "+TRB->TB_CLIENTE+Chr(13)+Chr(10)
		FWrite(fArq,mLinDet)
		
		dbSelectArea("SF2")
		dbGoTo(TRB->TB_RECNO)
		RecLock("SF2",.F.)
		SF2->F2_CCOLETA := cColeta
		SF2->F2_CDATCOL := ddatabase
		MsUnlock()
		
		dbSelectArea("TRB")
	ENDIF
   dbSkip()
ENDDO
				
mLinDet := "|TT|     |            "
mLinDet += "|"+STRZERO(nVol,5)+"  "                                                 
mLinDet += "|"+STRTRAN(TRANSFORM(nVlr,"@E 9999999999.99"),",",".")+" "               
mLinDet += "|"+STRTRAN(TRANSFORM(nPso,"@E 99999.99"),",",".")+" "
mLinDet += "|"+Chr(13)+Chr(10)
FWrite(fArq,mLinDet)
*
mLinDet := "|FIM|"
mLinDet += Chr(13)+Chr(10)
FWrite(fArq,mLinDet)

fClose(fArq)

Inkey(2)

///
///Abre o Excel
///

If ! ApOleClient( 'MsExcel' )                                                 //Verifica se o Excel esta instalado
	MsgStop( 'MsExcel não instalado' )
	Return
EndIf

oExcelApp := MsExcel():New()                                                  // Cria um objeto para o uso do Excel
oExcelApp:WorkBooks:Open("C:\Relato\Coleta\Coleta.xls")               			// Atribui à propriedade WorkBooks do Excel
oExcelApp:SetVisible(.T.)                                                     // Abre o Excel com o arquivo criado exibido na Primeira planilha.
oExcelApp:Destroy()                                                           //Encerra o processo do gerenciador de tarefas

MS_FLUSH()

nOpc  := 0
lSair := .T.

oDlg:End()

Return

///////////////////////////////////////////////////////////////////////
Static Function f_impretq()
///////////////////////////////////////////////////////////////////////
Local nV      := IIF(nImpVol > 99 , 3 , 2 )
Local cPesoB  := TRANSF(nPeso,"@E 99.99")+"Kg"
Local cGrsWei := STRZERO( ( nPeso * 100 ) , 6 )
Local cAI     := "33"
Local aCBarra := {{cAI,"02"+cGrsWei}}
Local cCDPL   := "(3302)"+cGrsWei
Local cNumVol := STRZERO(nItemVol,nV)+"/"+STRZERO(nImpVol,nV)

IF ( nEmbVol <= 0 )
	MsgStop("Falta informar o peso da embalagem.","Atenção")
	Return
ENDIF

MSCBPRINTER("S600","LPT1",,,.f.,,,,)
MSCBCHKSTATUS(.F.)

MSCBLOADGRF("\ARQUIVOS\FOTOS\COEL-L3T.GRF")

MSCBBEGIN(1,4) 
MSCBWRITE("^LH08,16^FS") 
MSCBGRAFIC(1.0,0.25,"COEL-L3T")   //1.0,0.25                                                               //LOGOTIPO 

MSCBSAY(1.5,11.85,"NOTA FISCAL: "+cNFiscal,"P","D","40,06")
MSCBSAY(1.5,16.35,"COMMERCIAL INVOICE: "+cInvoice,"P","D","40,06")
MSCBLINEH(1.5,20.35,59,3)
MSCBSAY(1.5,22.35,"VOLUME: "+cNumVol,"P","D","40,06")
MSCBSAY(1.5,27.0,"CUSTOMER/CLIENTE:","P","D","28,06")
MSCBSAY(1.5,30.35,cNReduz,"P","E","46,04")
MSCBLINEH(1.5,36.45,59,3)
MSCBSAY(1.5,37.35,"COUNTRY/PAIS:","P","D","30,06")
MSCBSAY(1.5,40.85,cCountry,"P","E","50,04")
MSCBLINEH(1.5,47.35,59,3)
MSCBSAY(1.5,48.85,"GROSS WEIGHT","P","D","20,06") 
MSCBSAY(1.5,51.35,"PESO BRUTO:","P","D","20,06") 
MSCBSAY(4.5,54.85,cPesoB,"P","E","35,06") 
MSCBSAYBAR(28.0,48.65,aCBarra,"N","MB07",6,.f.,.f.,.f.,"C",2,1,.F.)  
MSCBSAY(32.50,55.55,cCDPL,"P","D","20,06")

MSCBEND()
MSCBClosePrinter()

Return

///////////////////////////////////////////////////////////////////////
Static Function f_etqvolume(nY)
///////////////////////////////////////////////////////////////////////
Local nZ,nV,nSemana
Local cCBarra
Local aCBarra  
Local mPedido,mOP,mPedCli,mCodCli,mLote,mQtde,mProduto
Local mPBruto := TRANSF(aVolume[nY,8],"@E 99.99")+"Kg"
Local cVolume := aVolume[nY,1]
Local nColI   := mv_par02

SC5->(dbSeek(xFilial("SC5")+aVolume[nY,3]))
SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJAENT))

_dDatRf := ddatabase
nSemana := ( _dDatRf - dDatPri )
nSemana := ( INT((nSemana/7)) + 1 )
mLote   := STRZERO(nSemana,2)+STRZERO(DAY(_dDatRf),2)+SUBS(DTOS(_dDatRf),3,2)

MSCBPRINTER("S600","LPT1",,,.f.,,,,)

MSCBCHKSTATUS(.F.)

MSCBLOADGRF("\ARQUIVOS\FOTOS\COEL-L3T.GRF")

DO WHILE nY <= LEN(aVolume).AND.aVolume[nY,1]==cVolume
	IF ( aVolume[nY,2] $ "01,02" )
		nV := IIF(aVolume[nY,6] > 99 , 3 , 2 )
		IF ( aVolume[nY,2] == "01" )
			mPedido := aVolume[nY,3]+aVolume[nY,4]
			aCBarra := {{"10",mPedido+cVolume},{"30",STRZERO(aVolume[nY,6],4)}}
			cCBarra := "(10)"+mPedido+cVolume+"(30)"+STRZERO(aVolume[nY,6],4)
			
			SC6->(dbSeek(xFilial("SC6")+mPedido))
			
			mPedido  := TRANSF(mPedido , "@R XXXXXX.XX")
			mPedCli  := IIF(EMPTY(SC6->C6_PEDCLI) , "   ----" , RTRIM(SC6->C6_PEDCLI) )
			mCodCli  := IIF(EMPTY(SC6->C6_X_PROD) , "   ----" , RTRIM(SC6->C6_X_PROD) )
			mOP      := IIF(EMPTY(SC6->C6_NUMOP)  , "   ----" , SC6->C6_NUMOP+"."+SC6->C6_ITEMOP )
			mProduto := RTRIM(SC6->C6_PRODUTO)
		ELSE
			mPedCli  := "   ----"
			mCodCli  := "   ----"
			mOP      := "   ----"
			mProduto := aVolume[nY,5]
			mPedido  := ""
			FOR nZ:=1 TO LEN(aCols)
				 mPedido := aCols[nZ,1]+IIF(nZ<LEN(aCols),"/","")
			NEXT
			aCBarra := {{"10",LEFT(mPedido,6)+"00"},{"30",STRZERO(aVolume[nY,6],4)}}
			cCBarra := "(10)"+LEFT(mPedido,6)+"00(30)"+STRZERO(aVolume[nY,6],4)
		ENDIF
		mQtde := STRZERO(aVolume[nY,6],nV)
		
		MSCBBEGIN(1,4) 
		MSCBWRITE("^LH08,16^FS") 
		MSCBGRAFIC(nColI+2.0,1.5,"COEL-L3T")                                            //LOGOTIPO 

		/*
		  Layout antigo
		MSCBSAY(2.0,12.0,mProduto,"P","D","40,06")
		MSCBSAY(4.0,16.35,LEFT(aVolume[nY,7],44),"P","D","38,04")
		MSCBLINEH(2.0,20.35,70,3)
		MSCBLINEV(39.0,20.35,48,3)
		MSCBSAY(2.0,21.85,"PEDIDO COEL:","N","B","19,10")
		MSCBSAY(40.5,21.85,"PEDIDO CLIENTE:","N","B","19,10")
		MSCBSAY(4.0,25.0,mPedido,"P","D","45,06")
		MSCBSAY(42.5,25.0,mPedCli,"P","D","45,06")
		MSCBLINEH(2.0,30.75,70,3)
		MSCBSAY(2.0,31.85,"LOTE:","N","B","19,10")
		MSCBSAY(4.0,35.2,mLote,"P","D","44,06")
		MSCBSAY(40.5,31.85,"QTDE:","N","B","19,10")
		MSCBSAY(49.0,32.4,mQtde,"P","E","50,10")
		MSCBLINEH(2.0,39.0,70,3)
		MSCBSAY(2.0,40.0,"ORDEM DE PRODUCAO:","N","B","19,10")
		MSCBSAY(4.0,43.65,mOP,"P","D","44,06")
		MSCBSAY(40.5,40.0,"PESO BRUTO DO VOLUME:","N","B","19,10")
		MSCBSAY(42.5,43.65,mPBruto,"N","E","35,06")
		MSCBLINEH(2.0,47.85,70,3)
		MSCBSAY(2.0,48.85,"CLIENTE:","N","B","19,10") 
		MSCBSAY(4.0,51.3,RTRIM(SA1->A1_NREDUZ),"P","E","46,02") 
		MSCBLINEH(2.0,57.5,70,3)
		//IF ( aVolume[nY,2]=="01" )
			MSCBSAYBAR(18.0,58.6,aCBarra,"N","MB07",6.5,.f.,.f.,.f.,"C",2,1,.F.)  
			MSCBSAY(25.0,65.5,cCBarra,"N","B","19,10")
		//ENDIF	
		*/

		MSCBLINEV(nColI+50.5,0.0,11.25,7)
		MSCBLINEH(nColI+50.5,11.25,70.0,7)
		MSCBSAY(nColI+52.2,2.0,"Volume:","N","0","20,20")
		MSCBSAY(nColI+52.2,5.0,cVolume,"N","0","30,26")
		MSCBSAY(nColI+2.0,13.0,mProduto,"N","0","36,28")
		MSCBSAY(nColI+4.0,17.55,LEFT(aVolume[nY,7],44),"N","0","28,26")
		MSCBLINEH(nColI+2.0,21.35,70,3)
		MSCBLINEV(nColI+28.0,21.35,49,3)
		MSCBSAY(nColI+2.0,22.60,"PEDIDO COEL:","N","0","18,20")
		MSCBSAY(nColI+4.0,25.25,mPedido,"N","0","40,30")
		MSCBSAY(nColI+2.0,31.35,"PEDIDO CLIENTE:","N","0","18,20")
		MSCBSAY(nColI+4.0,34.7,mPedCli,"N","0","36,28")
		MSCBSAY(nColI+29.5,22.60,"QTDE:","N","0","18,20")
		MSCBSAY(nColI+33.0,25.25,mQtde,"N","0","44,36")
		MSCBLINEH(nColI+2.0,30.25,70,3)
		MSCBLINEH(nColI+2.0,40.0,70,3)
		MSCBSAY(nColI+2.0,41.0,"ORDEM DE PRODUCAO:","N","0","18,20")
		MSCBSAY(nColI+4.0,43.5,mOP,"N","0","40,30")
		MSCBSAY(nColI+29.5,41.0,"PESO BRUTO DO VOLUME:","N","0","18,20")
		MSCBSAY(nColI+31.5,43.5,mPBruto,"N","0","40,30")
		MSCBLINEH(nColI+2.0,48.85,70,3)
		MSCBSAY(nColI+2.0,49.85,"CLIENTE:","N","0","18,20") 
		MSCBSAY(nColI+4.0,52.3,RTRIM(SA1->A1_NREDUZ),"N","0","36,28") 
		MSCBLINEH(nColI+2.0,58.5,70,3)
		MSCBSAYBAR(nColI+15.0,60.0,aCBarra,"N","MB07",6.5,.f.,.f.,.f.,"C",2,1,.F.)  
		MSCBSAY(nColI+22.0,67.0,cCBarra,"N","0","18,20")
		
		MSCBEND()
		
	ENDIF
	
	nY++
	
ENDDO
MSCBClosePrinter()

Return

///////////////////////////////////////////////////////////////////////
Static Function f_prtetqpv()
///////////////////////////////////////////////////////////////////////
Local o_Dlg
Local nY       := 0
Local aStru    := {}
Local cPedido1 := ""
Local cPedido2 := ""
Local cPedido3 := ""
Local nV       := IIF(nImpVol > 99 , 3 , 2 )
Local cNumVol  := STRZERO(nItemVol,nV)
Local cPesoL   := TRANSF(nPLq,"@E 99.99")+"Kg"
Local cNetWei  := STRZERO( ( nPLq * 100 ) , 6 )
Local cAI      := "31"
Local aCBarra  := {{cAI,"02"+cNetWei}}
Local cCDPL    := "(3102)"+cNetWei
Local l_Sair   := .F.
Local _xPedido := "@@@@@@"

IF ( nEmbVol <= 0 )
	MsgStop("Falta informar o peso da embalagem.","Atenção")
	Return
ENDIF

/*
^XA
^LL200
^FX EXEMPLO 02 - CARLOS^FS
^FO60,10^ADN,18,10^FDCOELMATIC LTDA^FS
^FO10,60^BY3,,100^BEN,100,Y,N^FD789123456743^FS
^XZ
*/

aCampos := {}

AADD(aCampos , { "T2_OK"      , , "Ok"                  ,                  } )
AADD(aCampos , { "T2_PEDIDO"  , , "Pedido"              ,                  } )
AADD(aCampos , { "T2_ITEM"    , , "Item"                ,                  } )
AADD(aCampos , { "T2_PRODUTO" , , "Código"              ,                  } )
AADD(aCampos , { "T2_DESCRI"  , , "Descrição"           ,                  } )

dbSelectArea("TB2")
dbGoTop()

DEFINE MSDIALOG o_Dlg TITLE ":::... SELEÇÃO DOS PRODUTOS POR VOLUME ...:::" FROM 000, 000  TO 324, 790 COLORS 0, 16777215 PIXEL

o_Mark := MsSelect():New("TB2","T2_OK",,aCampos,@lInverte,@cMarca,{002,002,160,364},,o_Dlg,,)

@ 006,370 BmpButton Type 1 Action ( l_Sair := .T. , o_Dlg:End() )

ACTIVATE MSDIALOG o_Dlg CENTER VALID l_Sair
	
/*	
FOR nY:=1 TO LEN(aCols)
	 IF ( !EMPTY(aCols[nY,1]) )
		 IF ( nY < 4 )
			 cPedido1 += IIF(!EMPTY(cPedido1) , "/" , "" ) + aCols[nY,1] 
		 ELSEIF ( nY < 8 )
			 cPedido2 += IIF(!EMPTY(cPedido2) , "/" , "" ) + aCols[nY,1] 
		 ELSE
			 cPedido3 += IIF(!EMPTY(cPedido3) , "/" , "" ) + aCols[nY,1] 
		 ENDIF
	 ENDIF
NEXT
*/

dbSelectArea("TB2")
dbGoTop()
DO WHILE !EOF()
	IF ( !EMPTY(TB2->T2_OK) )
		IF ( TB2->T2_PEDIDO <> _xPedido )
			_xPedido := TB2->T2_PEDIDO
			nY++
			IF ( nY < 4 )
				cPedido1 += IIF(!EMPTY(cPedido1) , "/" , "" ) + TB2->T2_PEDIDO
			ELSEIF ( nY < 8 )
				cPedido2 += IIF(!EMPTY(cPedido2) , "/" , "" ) + TB2->T2_PEDIDO
			ELSE
				cPedido3 += IIF(!EMPTY(cPedido3) , "/" , "" ) + TB2->T2_PEDIDO
			ENDIF
		ENDIF
	ENDIF
	dbSkip()
ENDDO

///MSCBPRINTER("S4M","LPT1",,,.f.)
MSCBPRINTER("S600","LPT1",,,.f.,,,,)
///MSCBPRINTER("ZEBRA","LPT1:",NIL,,.F.,,,,,,.T.)

MSCBCHKSTATUS(.F.)

MSCBLOADGRF("\ARQUIVOS\FOTOS\COEL-L3T.GRF")

/*
A mais recente
MSCBBEGIN(1,4) 
MSCBWRITE("^LH08,16^FS") 
MSCBGRAFIC(1.0,0.25,"COEL-L3T")   //1.0,0.25                                                               //LOGOTIPO 

MSCBSAY(1.5,12.35,"SALES ORDER / ","P","D","40,06")
MSCBSAY(27.5,12.35,cPedido1,"P","D","40,06")
MSCBSAY(1.5,16.35,"PEDIDO DE VENDA:","P","D","40,06")
MSCBSAY(27.5,16.35,cPedido2,"P","D","40,06")
MSCBLINEH(1.5,20.35,59,3)
MSCBSAY(1.5,22.35,"NR. VOLUME: "+cNumVol,"P","D","40,06")
MSCBSAY(1.5,27.0,"CUSTOMER/CLIENTE:","P","D","28,06")
MSCBSAY(1.5,30.35,cNReduz,"P","E","46,04")
MSCBLINEH(1.5,36.45,59,3)
MSCBSAY(1.5,37.35,"COUNTRY/PAIS:","P","D","30,06")
MSCBSAY(1.5,40.85,cCountry,"P","E","50,04")
MSCBLINEH(1.5,47.35,59,3)
MSCBSAY(1.5,48.85,"NET WEIGHT","P","D","20,06") 
MSCBSAY(1.5,51.35,"PESO LIQUIDO:","P","D","20,06") 
MSCBSAY(4.5,54.85,cPesoL,"P","E","35,06") 
MSCBSAYBAR(28.0,48.65,aCBarra,"N","MB07",6,.f.,.f.,.f.,"C",2,1,.F.)  
MSCBSAY(32.50,55.55,cCDPL,"P","D","20,06")
*/

/*
MSCBSAY(1.5,12.35,"SALES ORDER / ","P","D","40,06")
MSCBSAY(27.5,12.35,cPedido1,"P","D","40,06")
MSCBSAY(1.5,16.35,"PEDIDO DE VENDA:","P","D","40,06")
MSCBSAY(27.5,16.35,cPedido2,"P","D","40,06")
MSCBLINEH(1.5,20.35,59,3)
MSCBSAY(1.5,22.35,"NR. VOLUME: "+cNumVol,"P","D","40,06")
MSCBSAY(1.5,27.0,"CUSTOMER/CLIENTE:","P","D","28,06")
MSCBSAY(1.5,30.35,cNReduz,"P","E","46,04")
MSCBLINEH(1.5,36.45,59,3)
MSCBSAY(1.5,37.35,"COUNTRY/PAIS:","P","D","30,06")
MSCBSAY(1.5,40.85,cCountry,"P","E","50,04")
MSCBLINEH(1.5,47.35,59,3)
MSCBSAY(1.5,48.85,"NET WEIGHT","P","D","20,06") 
MSCBSAY(1.5,51.35,"PESO LIQUIDO:","P","D","20,06") 
MSCBSAY(4.5,54.85,cPesoL,"P","E","35,06") 
MSCBSAYBAR(28.0,48.65,aCBarra,"N","MB07",6,.f.,.f.,.f.,"C",2,1,.F.)  
MSCBSAY(32.50,55.55,cCDPL,"P","D","20,06")
*/
MSCBEND()
MSCBClosePrinter()
/*
Parâmetros
      nXmm             = Posição X em Milímetros                        
      nYmm             = Posição Y em Milímetros                        
      cConteudo         = String a ser impressa                          
      cRotação          = String com o tipo de Rotação
      cTypePrt          = String com o Modelo de Código de Barras 
                   Zebra:     
                     2 - Interleaved 2 of 5
                     3 - Code 39
                     8 - EAN 8
                     E - EAN 13
                     U - UPC A
                     9 - UPC E
                     C - CODE 128
                   Allegro:
                     D - Interleaved 2 of 5
                     A - Code 39
                     G - EAN 8
                     F - EAN 13
                     B - UPC A
                     C - UPC E
                     E - CODE 128
                   Eltron:
                     2   - Interleaved 2 of 5
                     3   - Code 39
                     E80 - EAN 8
                     E30 - EAN 13
                     UA0 - UPC A
                     UE0 - UPC E
                     1   - CODE 128
                    
 [nAltura]        = Altura do código de Barras em Milímetros       
*[ lDigver]      = Imprime dígito de verificação               
 [lLinha]         = Imprime a linha de código                   
*[lLinBaixo]     = Imprime a linha de código acima das barras 
 [cSubSetIni]     = Utilizado no code128                           
 [nLargura]      = Largura da barra mais fina em pontos default 3
 [nRelacao]      = Relação entre as barras finas e grossas em pontos default 2
 [lCompacta]     = Compacta o código de barra                    
 [lSerial]     = Serializa o código                             
 [cIncr]        = Incrementa quando for serial positivo ou negativo
*[lZerosL]      = Coloca zeros a esquerda no numero serial       

*/
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_etqmetal()
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local lRsp
Local nX
Local _xClNomCl 
Local nColI    := mv_par02
Local cQtdEmb  := IIF(nQtdEmb < 10 , STRZERO(nQtdEmb,2) , TRANSF(nQtdEmb,"@E 9999") )
Local cAviso   := IIF(nQtdEtq > 1 , "As etiquetas foram impressas corretamente?" , "A etiqueta foi impressa corretamente?" ) + CHR(13)+CHR(10) + "Se não, favor reimprimir somente as etiquetas com defeito."
Local _xPedCli := IIF( AT("." , _cPedCli ) > 0 , STRTRAN(_cPedCli,".","") , _cPedCli )
Local _xCodCli := RTRIM(_cCodCli)
Local nY       := AT(" ",_cClNomCl)

_xPedCli  := IIF( AT("-" , _xPedCli ) > 0 , STRTRAN(_xPedCli,"-","") , _xPedCli )
_xPedCli  := IIF( AT(" " , _xPedCli ) > 0 , STRTRAN(_xPedCli," ","") , _xPedCli )
_xClNomCl := LEFT(_cClNomCl,(nY-1))
                     
IF ( mv_par03==1 )
	MSCBPRINTER("S600","LPT1",,,.f.,,,,)
	MSCBCHKSTATUS(.F.)
	
	MSCBLOADGRF("\ARQUIVOS\FOTOS\COEL-L3T.GRF")
	
	FOR nX:=1 TO nQtdEtq
		
		 MSCBBEGIN(1,4) 
		 MSCBWRITE("^LH08,16^FS") 
		 MSCBGRAFIC(1.0,0.25,"COEL-L3T") 
	
		 MSCBLINEV(3.5,11.80,24,3)
		 MSCBSAY(1.1,11.80,"C","N","E","22,04")
		 MSCBSAY(1.1,14.80,"O","N","E","22,04")
		 MSCBSAY(1.1,17.80,"E","N","E","22,04")
		 MSCBSAY(1.1,20.80,"L","N","E","22,04")
	
		 MSCBSAY(4.5,11.85,"CODIGO: "+_cProd,"N","D","40,06")
		 MSCBSAY(4.5,16.35,"MODELO: "+_cFamilia,"N","D","40,06")
		 MSCBSAY(4.5,20.85,_cModelo,"N","D","40,06")
		 MSCBLINEH(1.2,24.85,64,3)
	
		 MSCBLINEV(3.5,26.80,66,3)
		 nPosY := 26.8
		 nLen  := MIN(LEN(_xClNomCl),13)
		 FOR nY:=1 TO nLen
			  MSCBSAY(1.1,nPosY,SUBS(_xClNomCl,nY,1),"N","E","22,04")    ///22,04
			  nPosY += 3.2
		 NEXT
		 
		 cVolume := STRZERO(nSeqVol,3)+"/"+STRZERO(nVolume,3)
		 
		 MSCBSAY(4.5,26.85,"N.FISCAL: "+cSerie+cNFiscal,"P","D","40,06")
		 MSCBSAY(4.5,31.5,"PEDIDO: "+_cPedCli,"N","D","40,06")
		 MSCBSAY(4.5,36.55,"CODIGO: "+_cCodCli,"N","D","40,06")
		 MSCBSAY(4.5,42.0,"QTDE.: "+cQtdEmb,"N","D","40,06")
		 MSCBSAY(4.5,47.0,"VOLUME: "+cVolume,"N","D","40,06")
	
		 IF ( !EMPTY(_xPedCli) )
			 MSCBSAYBAR(52.0,29.0,_xPedCli,"B","C",8,.f.,.t.,.f.,"C",2,1,.f.)  
		 ENDIF	
		 IF ( !EMPTY(_xCodCli) )
			 MSCBSAYBAR(8.0,55.65,_xCodCli,"N","C",8,.f.,.t.,.f.,"B",2,1,.f.)  
		 ENDIF	
	
		 MSCBEND()
		 
		 nSeqVol++
		 
	NEXT
ELSE
	MSCBPRINTER("SM400","LPT1",,,.f.,,,,)
	MSCBCHKSTATUS(.F.)
	
	MSCBLOADGRF("\ARQUIVOS\FOTOS\COEL-L3T.GRF")
	             
	FOR nX:=1 TO nQtdEtq
		
		 MSCBBEGIN(1,4) 
		 MSCBWRITE("^LH08,16^FS") 
		 MSCBGRAFIC(nColI+1.0,1.00,"COEL-L3T")   //1.0,0.25   (+3.0)                                                      //LOGOTIPO 
	
	
		 MSCBLINEV(nColI+4.5,16.55,46.5,3)
		 MSCBSAY(nColI+1.1,17.00,"C","N","B","30,14")
		 MSCBSAY(nColI+1.1,25.00,"O","N","B","30,14")
		 MSCBSAY(nColI+1.1,32.00,"E","N","B","30,14")
		 MSCBSAY(nColI+1.1,39.00,"L","N","B","30,14")
	
		 MSCBSAY(nColI+6.5,17.00,"CODIGO: "+_cProd,"N","0","60,46")
		 MSCBSAY(nColI+6.5,27.00,"MODELO: "+_cFamilia,"N","0","60,46")
		 MSCBSAY(nColI+6.5,37.00,_cModelo,"N","0","60,30")
		 MSCBLINEH(nColI+1.0,47.00,164,3)
	
		 MSCBLINEV(nColI+4.5,48.50,130,3)
		 nPosY := 50.0
		 nLen  := MIN(LEN(_xClNomCl),13)
		 FOR nY:=1 TO nLen
			  MSCBSAY(nColI+1.1,nPosY,SUBS(_xClNomCl,nY,1),"N","B","30,14")    ///22,04
			  nPosY += 8.0
		 NEXT
		 
		 cVolume := STRZERO(nSeqVol,3)+"/"+STRZERO(nVolume,3)
		 
		 MSCBSAY(nColI+6.5,49.00,"N.FISCAL: "+cSerie+cNFiscal,"N","B","40,18")
		 MSCBSAY(nColI+6.5,59.0,"PEDIDO: "+_cPedCli,"N","B","40,18")
		 MSCBSAY(nColI+6.5,69.55,"CODIGO: "+_cCodCli,"N","B","40,18")
		 MSCBSAY(nColI+6.5,79.0,"QTDE.: "+cQtdEmb,"N","B","40,18")
		 MSCBSAY(nColI+6.5,89.0,"VOLUME: "+cVolume,"N","B","40,18")
	
		 IF ( !EMPTY(_xPedCli) )
			 MSCBSAYBAR(nColI+103.0,59.0,_xPedCli,"B","C",16,.f.,.t.,.f.,"C",3,1,.f.)  
		 ENDIF	
		 IF ( !EMPTY(_xCodCli) )
			 MSCBSAYBAR(nColI+22.0,110.00,_xCodCli,"N","C",16,.f.,.t.,.f.,"B",3,1,.f.)  
		 ENDIF	
	
		 MSCBEND()
		 
		 nSeqVol++
		 
	NEXT
ENDIF
	
MSCBClosePrinter()
/*
lRsp := MSGBOX(cAviso,"Impressão da Etiqueta","YESNO")    ///Aviso("Impressão da Etiqueta" , cAviso , {"Sim","Não"} , 3 )

IF ( !lRsp )
	lSeqVol := .T.
	nSeqAnt := nSeqVol
ELSE
	lSeqVol := .F.
	nSeqAnt := nSeqVol
ENDIF
*/
oSeqVol:Refresh()

Return

//////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
//////////////////////////////////////////////////////////////////////////////
   
   DbSelectArea("SX1")
   DbSetOrder(1)
   aRegs :={} //Grupo|Ordem| Pegunt                         | perspa | pereng | VariaVL  | tipo| Tamanho|Decimal| Presel| GSC | Valid         |   var01   | Def01              | DefSPA1 | DefEng1 | CNT01                | var02 | Def02           | DefSPA2 | DefEng2 | CNT02 | var03 | Def03           | DefSPA3 | DefEng3 | CNT03 | var04 | Def04 | DefSPA4 | DefEng4 | CNT04 | var05 | Def05 | DefSPA5 | DefEng5 | CNT05 | F3    | GRPSX5 |
   aAdd(aRegs,{ cPerg,"01" , "Porta serial                ?",   ""   ,  ""    , "mv_ch1" , "C" ,   17   ,   0   ,   0   , "G" , "          "  , "mv_par01", "                " , "     " , "     " , "COM3:9600,N,8,1   " , "   " , "             " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "SZE" , "    " })
   aAdd(aRegs,{ cPerg,"02" , "Coluna inicial              ?",   ""   ,  ""    , "mv_ch2" , "N" ,   02   ,   0   ,   0   , "G" , "          "  , "mv_par02", "                " , "     " , "     " , "0                 " , "   " , "             " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   aAdd(aRegs,{ cPerg,"03" , "Resolução Impressora        ?",   ""   ,  ""    , "mv_ch3" , "N" ,   01   ,   0   ,   1   , "C" , "          "  , "mv_par03", "203DPI          " , "     " , "     " , "                  " , "   " , "300DPI       " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
	
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