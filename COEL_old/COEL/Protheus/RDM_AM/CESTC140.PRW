/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CESTC140 ³ Autor ³ Carlos Nina           ³ Data ³ 10/03/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Consulta Faturamento Diario de Produção                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturamento                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#Include "rwmake.ch"        
#Include "protheus.ch"
#Include "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#Include "TOPCONN.CH"
#include 'MSGRAPHI.CH'
#define GRP_LINE      1
#define GRP_AREA      2
#define GRP_POINT     3
#define GRP_BAR       4
#define GRP_PYRAMID   5
#define GRP_CILINDER  6
#define GRP_HBAR      7
#define GRP_HPYRAMID  8
#define GRP_HCILINDER 9
#define GRP_PIE       10
#define GRP_SHAPES    11
#define GRP_FASTLINE  12
#define GRP_ARROWS    13
#define GRP_GANTT     14
#define GRP_BUBBLE    15

User Function CESTC140()

Local aStru := {}
Local cArqTrab,cIndex,cKey
Local oGroup1,oGroup2,oTBitmap1,oTBitmap2

Private oDlg,oLst,oGraphic,oDataDe,oDataAte
Private aFatur
Private cDescri  := SPACE(30)
Private nOpcA    := 0
Private nSerie   := 0
Private dDataDe  := CTOD("")
Private dDataAte := CTOD("")
Private mDataDe  := CTOD("")
Private mDataAte := CTOD("")
Private aItens   := {}
Private aDets    := {{"0",SPACE(9),SPACE(8),SPACE(30),0,0,SPACE(9),SPACE(9),SPACE(25),SPACE(25),SPACE(25)}}
Private aTabmes  := 'JANEIRO  FEVEREIROMARCO    ABRIL    MAIO     JUNHO    JULHO    AGOSTO   SETEMBRO OUTUBRO  NOVEMBRO DEZEMBRO '

Private oVd  := LoadBitmap( GetResources(), 'br_verde')
Private oVm  := LoadBitmap( GetResources(), 'br_vermelho')
Private oAm  := LoadBitmap( GetResources(), 'br_amarelo')

AADD(aItens , {"LOCAL",0,0,0,"0%",0,0,0} )  
AADD(aItens , {"NACIONAL",0,0,0,"0%",0,0,0} )
AADD(aItens , {"EXPORTAÇÃO",0,0,0,"0%",0,0,0} )
AADD(aItens , {"T O T A L",0,0,0,"0%",0,0,0} )
			
DEFINE FONT oBold NAME "Times New Roman"	SIZE 0,  18 BOLD  
DEFINE FONT oFnt  NAME "Arial"				SIZE 0, -16 BOLD	// "Times New Roman" Maior
DEFINE FONT oFnt4 NAME "Arial"				SIZE 0, -20 BOLD	// "Times New Roman" Maior
DEFINE FONT oFnt3 NAME "Arial"				SIZE 0, -18 BOLD	// "Times New Roman" Maior
DEFINE FONT oFnt2 NAME "Arial"				SIZE 0, -14 BOLD	// "Times New Roman" Menor
DEFINE FONT oFnt5 NAME "Arial"				SIZE 0, -26 BOLD	// "Times New Roman" Maior
			
DEFINE MSDIALOG oDlg TITLE ":::... Consulta Faturamento Diário ...:::" FROM 000, 000  TO 510, 1264 COLORS 0, 16777215 PIXEL

oTBar := TBar():New( oDlg,40,25,.T.,,,'tbar_coel',.F. )   

@ 016, 002 GROUP oGroup1 TO 046, 261 PROMPT "PERIODO"              			  	                    OF oDlg COLOR  0, 16777215 PIXEL   
@ 048, 002 GROUP oGroup2 TO 126, 261 PROMPT "RESUMO"               			  	                    OF oDlg COLOR  0, 16777215 PIXEL   
@ 016, 263 GROUP oGroup3 TO 236, 631 PROMPT "DETALHE DO FATURAMENTO"			  	                    OF oDlg COLOR  0, 16777215 PIXEL   
@ 030, 005 SAY   	                   OemToAnsi("A Partir")         					   SIZE 040, 009 OF oDlg COLOR  0, 16777215 PIXEL FONT oFnt2
@ 022, 035 SAY   	                   OemToAnsi("De")               					   SIZE 025, 009 OF oDlg COLOR  0, 16777215 PIXEL FONT oFnt2
@ 022, 105 SAY   	                   OemToAnsi("Até")              					   SIZE 025, 009 OF oDlg COLOR  0, 16777215 PIXEL FONT oFnt2
@ 030, 035 MSGET oDataDe             VAR    dDataDe      						  			SIZE 060, 010 OF oDlg COLOR  0, 16777215 PIXEL FONT oFnt2
@ 030, 105 MSGET oDataAte            VAR    dDataAte     						  			SIZE 060, 010 OF oDlg COLOR  0, 16777215 PIXEL FONT oFnt2 VALID Processa( { || f_periodo() } , "Aguarde..." )

oLst := TCBrowse():New( 056 , 004, 255, 064,,{"","Venda (R$)","Amostra (R$)","Forecast (R$)","Progresso"},{40,50,40,50,30},oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	

oLst:SetArray(aItens)
oLst:bLine   := { || { aItens[oLst:nAt,1]  , ;
							  aItens[oLst:nAt,2]  , ;
							  aItens[oLst:nAt,3]  , ;
							  aItens[oLst:nAt,4]  , ;
							  aItens[oLst:nAt,5] } }
							
oLst:lAdjustColsize := .F.

oVda := TCBrowse():New( 024 , 265, 362, 208,,{"","N.Fiscal","Emissão","Produto","Qtde.","Valor (R$)","Pedido","O.P.","Cliente","Operação"},{20,36,34,36,30,40,34,34,30,45},oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	

oVda:SetArray(aDets)
oVda:bChange := { || f_descpro(oVda:nAt) }  
oVda:bLine   := { || { IIF(aDets[oVda:nAt,1]=="0",oVm,IIF(aDets[oVda:nAt,1]=="1",oVd,oAm))  , ;
							  aDets[oVda:nAt,2]  , ;
							  aDets[oVda:nAt,3]  , ;
							  aDets[oVda:nAt,4]  , ;
							  aDets[oVda:nAt,5]  , ;
							  aDets[oVda:nAt,6]  , ;
							  aDets[oVda:nAt,7]  , ;
							  aDets[oVda:nAt,8]  , ;
							  aDets[oVda:nAt,9]  , ;
							  aDets[oVda:nAt,10] } }
							
oVda:lAdjustColsize := .T.

@ 240, 265 Say    oDescri      VAR cDescri                     	Size 250, 018 PIXEL OF oDlg  FONT oFnt4   COLOR CLR_HBLUE  

oGraphic := TMSGraphic():New( 130,000,oDlg,,,RGB(239,239,239),264,120)

oGraphic:SetTitle('Vendas', , CLR_BLACK, A_LEFTJUST, GRP_TITLE )
oGraphic:SetMargins(2,6,6,6)
oGraphic:SetGradient(GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE)
oGraphic:SetLegenProp(GRP_SCRRIGHT, CLR_HGRAY, GRP_AUTO,.F.)

nSerie := oGraphic:CreateSerie( 4 )
oGraphic:l3D := .T. // Grafico em 3D 
oGraphic:lAxisVisib := .T. // Mostra os eixos
// Itens do Grafico
oGraphic:Add(nSerie, aItens[1,2], aItens[1,1], CLR_BLUE )
oGraphic:Add(nSerie, aItens[2,2], aItens[2,1], CLR_GREEN )
oGraphic:Add(nSerie, aItens[3,2], aItens[3,1], CLR_RED )

oTBitmap1 := TBtnBmp2():New( 00, 00, 40, 70, 'S4WB008N' ,,,,;
					{ || Calculadora() }  ,oTBar,'Calculadora',,.F.,.F.)
oTBitmap2 := TBtnBmp2():New( 00, 00, 40, 70, 'button_exit' ,,,,;
					{ || ( nOpcA := 1 , oDlg:End() ) }  ,oTBar,'Sair',,.F.,.F.)

					
ACTIVATE MSDIALOG oDlg CENTERED Valid nOpcA > 0

	
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_periodo()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local nX,nMes,nPercent
Local cMesExt
Local lRsp

IF ( !EMPTY(dDataDe).AND.!EMPTY(dDataAte) )
	IF ( LEFT(DTOS(dDataAte),6) <> LEFT(DTOS(dDataDe),6) )
		MsgInfo("Data final ultrapassa o periodo de 1 (hum) mês.","Atenção")
		Return(.F.)
	ENDIF
	IF ( dDataAte <> mDataAte .OR. dDataDe <> mDataDe )
	
		FOR nX:=1 TO 4
			 aItens[nX,6] := aItens[nX,7] := aItens[nX,8] := 0
			 aItens[nX,5] := "0%"
		NEXT
		
		f_procforcast()       ///Extrai a carteira do periodo (atendidos e nao-atendidos)
		
		f_procfatur()         ///Extrai o faturamento do periodo
		
		FOR nX:=1 TO 3
			 nPercent     := ( aItens[nX,6] / aItens[nX,8] )
			 nPercent     := ROUND(nPercent*100,1)
			 aItens[4,6]  += aItens[nX,6]
			 aItens[4,7]  += aItens[nX,7]
			 aItens[4,8]  += aItens[nX,8]
			 aItens[nX,2] := TRANSF(aItens[nX,6],"@E 999,999,999.99")
			 aItens[nX,3] := TRANSF(aItens[nX,7],"@E 999,999,999.99")
			 aItens[nX,4] := TRANSF(aItens[nX,8],"@E 999,999,999.99")
			 aItens[nX,5] := TRANSF(nPercent,"@E 999.9") + "%"
		NEXT	 
		nPercent    := ( aItens[4,6] / aItens[4,8] )
		nPercent    := ROUND(nPercent*100,1)
		aItens[4,5] := TRANSF(nPercent,"@E 999.9") + "%"
		aItens[4,2] := TRANSF(aItens[4,6],"@E 999,999,999.99")
		aItens[4,3] := TRANSF(aItens[4,7],"@E 999,999,999.99")
		aItens[4,4] := TRANSF(aItens[4,8],"@E 999,999,999.99")
		
		mDataDe  := dDataDe
		mDataAte := dDataAte
		nMes     := MONTH(dDataAte)
		cMesExt  := LEFT(Subs(aTabmes,(nMes*9)-8,9),3)+'/'+STR(YEAR(dDataAte),4)	
		
		oLst:aHeaders[1] := cMesExt
		oLst:SetArray(aItens)
		oLst:bLine   := { || { aItens[oLst:nAt,1]  , ;
									  aItens[oLst:nAt,2]  , ;
									  aItens[oLst:nAt,3]  , ;
									  aItens[oLst:nAt,4]  , ;
									  aItens[oLst:nAt,5] } }
									
		oLst:lAdjustColsize := .T.
		oLst:Refresh()

		oGraphic:Destroy()

		oGraphic := TMSGraphic():New( 130,000,oDlg,,,RGB(239,239,239),264,120)
		oGraphic:SetTitle('Vendas', , CLR_BLACK, A_LEFTJUST, GRP_TITLE )
		oGraphic:SetMargins(2,6,6,6)
		oGraphic:SetGradient(GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE)
		oGraphic:SetLegenProp(GRP_SCRRIGHT, CLR_HGRAY, GRP_AUTO,.F.)
		
		nSerie              := oGraphic:CreateSerie( 4 )
		oGraphic:l3D        := .T. // Grafico em 3D 
		oGraphic:lAxisVisib := .T. // Mostra os eixos
		// Itens do Grafico
		FOR nX:=1 TO LEN(aFatur)
			 oGraphic:Add(nSerie, aFatur[nX,2], aFatur[nX,1], CLR_BLUE )
		NEXT
		
	ENDIF
ENDIF

Return

///////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_procforcast()
///////////////////////////////////////////////////////////////////////////////////////////////////
Local cQry
Local nCF
Local dDataFin := LastDay(dDataDe)
Local mvLocal  := IIF(M->cNumEmp=="0301", "02" , "01" )

cQry := "SELECT LEFT(C6_CF,1) C6_CF,SUM(C6_VALOR) C6_VALOR"
cQry += " FROM "+RetSqlName("SC6")+" C6,"+RetSqlName("SF4")+" F4"
cQry += " WHERE C6.D_E_L_E_T_ = ' ' AND C6_FILIAL = '"+xFilial("SC6")+"'"
cQry += " AND C6_ENTREG BETWEEN '"+DTOS(dDataDe)+"' AND '"+DTOS(dDataFin)+"'"
cQry += " AND C6_CF IN ('5101','5102','5107','5109','5401','5405','6101','6102','6107','6109','6122','6401','6405','7101','7102','7107')"
cQry += " AND F4.D_E_L_E_T_ = ' ' AND F4_CODIGO = C6_TES AND F4_DUPLIC = 'S'"
cQry += " GROUP BY LEFT(C6_CF,1)"
cQry += " ORDER BY LEFT(C6_CF,1) "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'FCT', .T., .T.)

dbSelectArea("FCT")
dbGoTop()
DO WHILE !EOF()
	
	IncProc()
	
	nCF           := VAL(IIF(FCT->C6_CF=="5","1",IIF(FCT->C6_CF=="6","2","3")))
	aItens[nCF,8] += FCT->C6_VALOR
	
	dbSkip()
	
ENDDO

FCT->(dbCloseArea()) 

Return

///////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_procfatur()
///////////////////////////////////////////////////////////////////////////////////////////////////
Local cQry,cCF,cAAMM,cAnoMes,cTpOper,cOperaco,mvPar03
Local nSeton,nQuant,nVlrFatur
Local lAmostra,lCancelada
Local mvLocal := IIF(M->cNumEmp=="0301", "02" , "01" )

aFatur := {}
aDets  := {}

dbSelectArea("SD1")
dbSetOrder(7)
*
dbSelectArea("SD2")
dbSetOrder(3)
*
dbSelectArea("SF4")
dbSetOrder(1)
*
dbSelectArea("SC5")
dbSetOrder(1)
*
////
////
////
////IF ( !EMPTY(mv_par03) )
////	cQry += " AND ( D2_CF IN ('5101','5102','5107','5109','5401','5405','6101','6102','6107','6109','6122','6401','6405','7101','7102','7107') OR D2_TES IN "+mvPar03+" )"
////ELSE
cQry := "SELECT D2_DOC,D2_ITEM,D2_CF,D2_EMISSAO,D2_COD,D2_PEDIDO,D2_ITEMPV,C6_DESCRI,C6_NUMOP,C6_ITEMOP,D2_QUANT,D2_TOTAL,C6_NUM,C6_ITEM"
cQry += " FROM "+RetSqlName("SD2")+" D2,"+RetSqlName("SC6")+" C6,"+RetSqlName("SF2")+" F2"
cQry += " WHERE F2.D_E_L_E_T_ = ' ' AND F2_FILIAL = '"+xFilial("SF2")+"'"
cQry += " AND F2_EMISSAO BETWEEN '"+DTOS(dDataDe)+"' AND '"+DTOS(dDataAte)+"'"
cQry += " AND D2.D_E_L_E_T_ = ' ' AND D2_FILIAL = '"+xFilial("SD2")+"' AND D2_LOCAL = '"+mvLocal+"'"
cQry += " AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA AND D2_EMISSAO = F2_EMISSAO"
cQry += " AND ( ( F2_DUPL <> ' ' AND D2_CF IN ('5101','5102','5107','5109','5401','5405','6101','6102','6107','6109','6122','6401','6405','7101','7102','7107') ) OR D2_CF IN ('5911','6911','7911') )"
cQry += " AND C6.D_E_L_E_T_ = ' ' AND C6_FILIAL = '"+xFilial("SC6")+"' AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV"
cQry += " ORDER BY D2_EMISSAO,D2_DOC,D2_ITEM "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TRB', .T., .T.)

dbSelectArea("TRB")
dbGoTop()
DO WHILE !EOF()
	
	IncProc()
		
	SC5->(dbSeek(xFilial("SC5")+TRB->D2_PEDIDO))
	
	nQuant     := TRB->D2_QUANT
	nVlrFatur  := TRB->D2_TOTAL
	cCF        := IIF(LEFT(TRB->D2_CF,1)=="5","1",IIF(LEFT(TRB->D2_CF,1)=="6","2","3"))
	lAmostra   := ( RTRIM(TRB->D2_CF) $ "5911,6911,7911" )
	lCancelada := .F.
	
	///
	///Verifica se houve cancelamento de nota
	///
	dbSelectArea("SD1")
	dbSeek(xFilial("SD1")+TRB->D2_COD,.T.)
	DO WHILE !EOF().AND.SD1->D1_FILIAL==xFilial("SD1").AND.D1_COD==TRB->D2_COD
		cAnoMes := LEFT(DTOS(SD1->D1_DTDIGIT),6)
		IF ( cAnoMes == LEFT(TRB->D2_EMISSAO,6) .AND. SD1->D1_TIPO == 'D' )
			IF ( SD1->D1_NFORI==TRB->D2_DOC .AND. SD1->D1_ITEMORI == TRB->D2_ITEM )
				SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
				IF ( SF4->F4_ESTOQUE == 'S' )
					////
					////Verifica se é nota cancelada de faturamento
					////
					nSeton := 10
					IF ( SD1->D1_CF $ '1201 ,2201 ,2410 ,3201 ' )
						IF ( LEFT(SD1->D1_CF,1) == cCF )
							SF1->(dbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO))
							cCGCCli := SUBS(SF1->F1_CHVNFE,7,14)
							lCGCCli := ( SM0->M0_CGC <> cCGCCli )
							dbSelectArea("SD2")
							dbSeek(xFilial("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEMORI)
							IF ( !EOF() )
								cAAMM  := LEFT(DTOS(SD2->D2_EMISSAO),6)
								nSeton := IIF(lCGCCli , 30 , IIF(cAnoMes == cAAMM , 20 , nSeton ) )
							ENDIF
							dbSelectArea("SD1")
						ENDIF
					ENDIF
					IF ( nSeton == 20 )                                ////Cancelamento de Faturamento
						nQuant     -= SD1->D1_QUANT
						nVlrFatur  -= ( SD1->D1_TOTAL - SD1->D1_VALDESC )
						lCancelada := .T.
					ENDIF
				ENDIF
			ENDIF
		ENDIF
		dbSkip()
	ENDDO
	
	cCF           := VAL(cCF)
	aItens[cCF,6] := IIF(!lAmostra , ( aItens[cCF,6] + nVlrFatur ) , aItens[cCF,6] )
	aItens[cCF,7] := IIF(lAmostra  , ( aItens[cCF,7] + nVlrFatur ) , aItens[cCF,7] )
	
	nX := ASCAN(aFatur , { |z| z[1] == RIGHT(TRB->D2_EMISSAO,2) } )
	
	IF ( nX == 0 )
		AADD(aFatur , { RIGHT(TRB->D2_EMISSAO,2) , nVlrFatur } )
	ELSE
		aFatur[nX,2] += nVlrFatur
	ENDIF
	
	///
	///Monta array dos itens faturado
	///
	cTpOper   := IIF(cCF==1,"LOCAL",IIF(cCF==2,"NACIONAL","EXPORTAÇÃO"))
	cOperacao := IIF(TRB->D2_CF $ "5911 /6911 /7911" , "AMOSTRA " , "VENDA " ) + cTpOper
	
	AADD(aDets , { IIF(lCancelada , "0" , "1" ) , ;            ///1
						TRB->D2_DOC                  , ;            ///2
						STOD(TRB->D2_EMISSAO)        , ;            ///3
						TRB->D2_COD                  , ;            ///4
						TRB->D2_QUANT                , ;            ///5
						TRB->D2_TOTAL                , ;            ///6
						TRB->D2_PEDIDO+"-"+TRB->D2_ITEMPV , ;       ///7
						TRB->C6_NUMOP +"."+TRB->C6_ITEMOP , ;       ///8
						SC5->C5_CLNOMCL , ;                         ///9
						cOperacao       , ;                         ///10
						TRB->C6_DESCRI  } )                         ///11
						
	dbSelectArea("TRB")
	dbSkip()
	
ENDDO

TRB->(dbCloseArea())

oVda:SetArray(aDets)
oVda:bLine   := { || { IIF(aDets[oVda:nAt,1]=="0",oVm,IIF(aDets[oVda:nAt,1]=="1",oVd,oAm))  , ;
							  aDets[oVda:nAt,2]  , ;
							  aDets[oVda:nAt,3]  , ;
							  aDets[oVda:nAt,4]  , ;
							  aDets[oVda:nAt,5]  , ;
							  aDets[oVda:nAt,6]  , ;
							  aDets[oVda:nAt,7]  , ;
							  aDets[oVda:nAt,8]  , ;
							  aDets[oVda:nAt,9]  , ;
							  aDets[oVda:nAt,10] } }
							
oVda:lAdjustColsize := .T.
oVda:Refresh()
oVda:SetFocus()

cDescri := RTRIM(aDets[1,11])
oDescri:Refresh()

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_descpro(nItem)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

IF ( LEN(aDets) > 0 )
	cDescri := RTRIM(aDets[nItem,11])
	oDescri:Refresh()
ENDIF

Return