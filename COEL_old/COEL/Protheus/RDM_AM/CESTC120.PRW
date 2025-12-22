/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CESTC120 ³ Autor ³ Carlos Nina           ³ Data ³ 28/08/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Consulta Amarracao Pedido de Venda x Ordem de Producao     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "protheus.ch"        
#include "rwmake.ch"        
#include "TOTVS.CH"
#include "TOPCONN.CH"
#include "font.ch"
#include "colors.ch"

User Function CESTC120()        

Local   nx

Private lSair       := .F.
Private nRotinas    := 0                                     ////Identificacao das sub-rotinas pra efeito dos refresh's dos objetos (hide() e show())
Private nItemP      := 1
Private nTamProd    := TamSX3("B1_COD")[1]
Private nQtdDec     := TamSX3("B9_QINI")[2]
Private nCusDec     := TamSX3("B9_VINI1")[2]
Private mvLocPad    := IIF(M->cNumEmp=="0301","02","01")    
Private cPictQtd    := X3Picture("B9_QINI")
Private cPictCus    := X3Picture("B9_VINI1")
Private cPedido     := SPACE(06)
Private mPedido     := cPedido
Private cCliente    := SPACE(40)
Private cParcial    := SPACE(03)
Private cAntecipado := SPACE(03)
Private cAtendente  := SPACE(20)
Private cObserv     := SPACE(100)
Private cDescri     := SPACE(60)
Private cAptOP      := "O.P.: "
Private Tabmes      := 'JANEIRO  FEVEREIROMARCO    ABRIL    MAIO     JUNHO    JULHO    AGOSTO   SETEMBRO OUTUBRO  NOVEMBRO DEZEMBRO '
Private aPVPrd      := {}
Private aRoteiro    := {}
Private aPedido     := {{"0","","",SPACE(12),SPACE(18),"","","","",""}}
Private aPrdPV      := {{"","","","",SPACE(26),SPACE(10)}}
Private aAptOP      := {{"","","","","","",SPACE(10),""}}
Private oDlg,oGroup01,oGroup02,oGroup03,oGroup04,oGroup05,oGroup06,oGroup07,oGroup7a,oGroup08,oGroup8a,oGroup09,oGroup10,oGroup11,oGroup12,oGroup13,oGroup14,oGroup15
Private oLst0,oLst1,oList2,oLst3,oLst4,oLst5,oLst6,oLst7,oLst8,oLst9,oLst10,oLst11,oLst12,oLst13,oLst14,oLst15,oMulti,oBtn1,oBtn2,oBtn3,oBtn4,oBtn5,oBtn6,oBtn7,oBtn8,oBtn9
Private oPedido,oCliente,oParcial,oAtencipado,oAtendente,oObserv,oDescri
Private oTBmp1,oTBmp2,oTBmp3,oTBmpAp1,oTBmpAp2,oTBmpAp3

Private oVd := LoadBitmap( GetResources(), 'br_verde')
Private oVm := LoadBitmap( GetResources(), 'br_vermelho')
Private oAz := LoadBitmap( GetResources(), 'br_azul')
Private oLr := LoadBitmap( GetResources(), 'br_laranja')
Private oPt := LoadBitmap( GetResources(), 'br_preto')

SET(1,"OFF")

/*
B1_PE     = Prazo
B1_TIPE   = Tipo do Prazo (H/D/M/A)
B1_QE     = Qty. p/embalagem
B1_EMIN   = Ponto de Pedido
B1_ESTSEG = Estoque de Seguranca
B1_LE     = Lote Economico
B1_LM     = Lote Minimo
*/
dbSelectArea("SA1")   ///Clientes
dbSetOrder(1)
*
dbSelectArea("SA2")   ///Fornecedores
dbSetOrder(1)
*
dbSelectArea("SB1")   ///Produtos
dbSetOrder(1)
*
dbSelectArea("SB2")   ///Saldo Fisico/Financeiro
dbSetOrder(1)
*
dbSelectArea("SBM")   ///Grupo
dbSetOrder(1)
*
dbSelectArea("SC5")   ///Pedido de Venda
dbSetOrder(1)
*
dbSelectArea("SZE")   ///Familia
dbSetOrder(1)
*
dbSelectArea("SH1")   ///Recursos
dbSetOrder(1)
*
dbSelectArea("SX5")   ///Tabelas
dbSetOrder(1)
*
DEFINE FONT oFnt   NAME "Arial" Size 10,17             ///LARG. X ALT.
DEFINE FONT oFnt2  NAME "Arial" Size 10,11
DEFINE FONT oFnt3  NAME "Arial" Size 10,12
DEFINE FONT oFnt3a NAME "Arial" Size 7,28     ///8,16
DEFINE FONT oFnt3b NAME "Arial" Size 7.2,26     ///8,16
DEFINE FONT oFnt3c NAME "Arial" Size 7,28     ///8,16
DEFINE FONT oFnt4  NAME "Arial" Size 10,34
DEFINE FONT oFnt5  NAME "Arial" Size 14,72
DEFINE FONT oFnt6  NAME "Arial" Size 9,12
DEFINE FONT oFnt7  NAME "Arial" Size 16,74
DEFINE FONT oFnt8  NAME "Arial" Size 12,14
DEFINE FONT oFnt9  NAME "Arial" Size 16,48
DEFINE FONT oFnt9a NAME "Arial" Size 11,40   
DEFINE FONT oFnt9b NAME "Arial" Size 12,54  

oFont24b := TFont():New( "Arial",,24,,.t.,,,,,.f. )

DEFINE MSDIALOG oDlg TITLE ":::... Consulta Pedido de Venda x Ordem de Produção ...:::" FROM 000, 000  TO 570, 1296 COLORS 0, 16777215 OF oMainWnd PIXEL
@ 003,003 GROUP oGroup01 TO 026,050  PROMPT "PEDIDO"                                    OF oDlg COLOR CLR_HBLUE   PIXEL
@ 003,052 GROUP oGroup02 TO 024,382  PROMPT "CLIENTE"                                   OF oDlg COLOR 0, 16777215 PIXEL  
@ 003,384 GROUP oGroup03 TO 024,420  PROMPT "PARCIAL?"                                  OF oDlg COLOR 0, 16777215 PIXEL
@ 003,422 GROUP oGroup04 TO 024,458  PROMPT "ANTEC.?"                                   OF oDlg COLOR 0, 16777215 PIXEL
@ 003,460 GROUP oGroup05 TO 024,578  PROMPT "ATENDENTE"                                 OF oDlg COLOR 0, 16777215 PIXEL

@ 010,004 MsGet oPedido             VAR cPedido     PICTURE "@!" F3 "SC5" SIZE 042,012 OF oDlg COLOR 0, 16777215 FONT oFnt3b PIXEL VALID f_PV()
@ 010,054 Say   oCliente            VAR cCliente                          SIZE 240,012 OF oDlg COLOR CLR_HBLUE   FONT oFnt3a PIXEL
@ 010,396 Say   oParcial            VAR cParcial                          SIZE 015,012 OF oDlg COLOR CLR_HBLUE   FONT oFnt3a PIXEL
@ 010,434 Say   oAtencipado         VAR cAntecipado                       SIZE 015,012 OF oDlg COLOR CLR_HBLUE   FONT oFnt3a PIXEL
@ 010,464 Say   oAtendente          VAR cAtendente                        SIZE 090,012 OF oDlg COLOR CLR_HBLUE   FONT oFnt3a PIXEL
@ 035,054 Say   oObserv             VAR cObserv                           SIZE 400,012 OF oDlg COLOR CLR_HBLUE   FONT oFnt3a PIXEL

////==============================================================================================================================================
@ 028,003 GROUP oGroup07 To 157,358  PROMPT "ITENS DO PEDIDO"                                                                    OF oDlg PIXEL  
@ 036,004 LISTBOX oLst1 Fields HEADER "","Item","Dt.Entrega","O.P.","Produto","Qty.Pedida","Saldo PV","Est.Expedição" SIZE 354, 104 OF oDlg PIXEL   
@ 140,006 SAY oDescri                VAR cDescri                          SIZE 100, 012 OF oDlg COLOR CLR_HBLUE   FONT oFnt3a PIXEL 

oLst1:SetArray(aPedido)
oLst1:bChange := { || f_Lst1(oLst1:nAt) }  
oLst1:bLine := {|| { IIF(aPedido[oLst1:nAt,1]=="0",oVm,IIF(aPedido[oLst1:nAt,1]=="1",oVd,oPt)) , ;
							aPedido[oLst1:nAt,2] , ;
							aPedido[oLst1:nAt,3] , ;
							aPedido[oLst1:nAt,4] , ;
							aPedido[oLst1:nAt,5] , ;
							aPedido[oLst1:nAt,6] , ;
							aPedido[oLst1:nAt,7] , ;
							aPedido[oLst1:nAt,8] } }
								
oLst1:lAdjustColsize := .F.

@ 160,003 GROUP oGroup08 To 284,358  PROMPT "PRODUTO x PEDIDO"                   OF oDlg PIXEL  
@ 167,004 LISTBOX oLst2  Fields HEADER "Pedido","Item","Dt.Entrega","Saldo","C L I E N T E","O.P." SIZE 354, 116 OF oDlg PIXEL   

oLst2:SetArray(aPrdPV)
oLst2:bLine := {|| { aPrdPV[oLst2:nAt,1] , ;
							aPrdPV[oLst2:nAt,2] , ;
							aPrdPV[oLst2:nAt,3] , ;
							aPrdPV[oLst2:nAt,4] , ;
							aPrdPV[oLst2:nAt,5] , ;
							aPrdPV[oLst2:nAt,6] } }								
oLst2:lAdjustColsize := .F.

@ 028,361 GROUP oGroup09 To 157,650  PROMPT "Acompanhamento de Apontamento de Produção"         OF oDlg PIXEL    
@ 036,363 SAY oAptOP           VAR cAptOP                                         SIZE 160,012  OF oDlg COLOR CLR_HRED   FONT oFnt3a PIXEL 
@ 033,560 SAY oLegApt          PROMPT "Legenda:"                                  Size 040,009  OF oDlg Color CLR_BLACK  PIXEL 
@ 040,560 GROUP oGrpApt  TO 041,582  PROMPT ""                                                  OF oDlg PIXEL        
  
oTBmpAp1:= TBitmap():Create(oDlg,033,585,14,14,,'br_vermelho',.T.,,,.F.,.F.,,,.F.,,.T.,,.F.)	   
oTBmpAp1:lAutoSize := .T.
@ 033,594 Say oLegAp1          PROMPT "Aguardando"                                  Size 040,009  Color CLR_BLACK  PIXEL OF oDlg  
oTBmpAp2 := TBitmap():Create(oDlg,042,585,14,14,,'br_laranja',.T.,,,.F.,.F.,,,.F.,,.T.,,.F.)	 
oTBmpAp2:lAutoSize := .T.
@ 042,594 Say oLegAp2          PROMPT "Parcial"                                     Size 040,009  Color CLR_BLACK  PIXEL OF oDlg  
oTBmpAp3 := TBitmap():Create(oDlg,042,626,14,14,,'br_verde',.T.,,,.F.,.F.,,,.F.,,.T.,,.F.)
oTBmpAp3:lAutoSize := .T.
@ 042,635 Say oLegAp3          PROMPT "OK"                                          Size 040,009  Color CLR_BLACK  PIXEL OF oDlg 

@ 050,362 LISTBOX oLst4 Fields HEADER "","Operação","Qtd.(Entrada)","Qtd.(Saída)","Dt.Inicial","Dt.Final"  SIZE 287, 091 OF oDlg PIXEL  

oLst4:SetArray(aAptOP)
oLst4:bLine := { || { IIF(aAptOP[oLst4:nAt,8]=="0",oVm,IIF(aAptOP[oLst4:nAt,8]=="1",oLr,oVd)) , ;
								  aAptOP[oLst4:nAt,2] , ;
								  aAptOP[oLst4:nAt,3] , ;
								  aAptOP[oLst4:nAt,4] , ;
								  aAptOP[oLst4:nAt,5] , ;
								  aAptOP[oLst4:nAt,6] } }
oLst4:lAdjustColsize := .F.

@ 004,580 BUTTON oBtn6a  PROMPT "Sair"           			   SIZE 070, 011 PIXEL OF oDlg Action Eval( { || lSair := .T. , oDlg:End()	} )
	
ACTIVATE MSDIALOG oDlg CENTER VALID lSair

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_PV()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local nx
Local cMsgSped,cOP1,cOP2,cProduto,cLocal
Local lPedInval := .F.
Local lRsp      := .T.

IF ( !EMPTY(cPedido) .AND. cPedido <> mPedido )
	
	SC5->(dbSeek(xFilial("SC5")+cPedido))
	IF SC5->(EOF())
		MsgAlert("Pedido não cadastrado.","Atenção")
		cPedido := mPedido
		lRsp    := .F.
		oPedido:Refresh()
	ELSE
		IF ( SC5->C5_TIPO $ "BDCI" )
			MsgAlert("Pedido não permitido para consulta.","Tipo: Beneficiamento/Devolução")
			cPedido := mPedido
			lRsp    := .F.
			oPedido:Refresh()
		///ELSEIF ( SC5->C5_LIBEROK == "S" )
		///	MsgAlert("Pedido já foi atendido totalmente.","Atenção")
		///	cPedido := mPedido
		///	lRsp    := .F.
		///	oPedido:Refresh()
		ELSE	
			SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			mPedido     := cPedido
			cCliente    := RTRIM(SA1->A1_NOME)
			cParcial    := IIF(SC5->C5_CLPARC=="S" , "SIM" , "NÃO" )
			cAntecipado := IIF(SC5->C5_CLANTE=="S" , "SIM" , "NÃO" )
			cAtendente  := SC5->C5_CLATEND
			cObserv     := RTRIM(SC5->C5_CLMSPED)
			aPedido     := {}
			aRoteiro    := {}
			aPVPrd      := {}
			
			dbSelectArea("SC6")
			dbSetOrder(1)
			dbSeek(xFilial("SC6")+SC5->C5_NUM,.T.)
			DO WHILE !EOF().AND.C6_FILIAL==xFilial("SC6").AND.C6_NUM==SC5->C5_NUM
				SB1->(dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
				SB2->(dbSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL))
				lPedInval := ( SB1->B1_TIPO <> "PA" )
				IF ( !lPedInval )
					IF ( SC6->C6_CF $ "5101 /5102 /5107 /5901 /5911 /5949 /6101 /6107 /6102 /6401 /6949 /7101 /7102 /7107 " )
						IF ( SC6->C6_CF $ "5949 /6949 " )
							cMsgSped  := UPPER(SC5->C5_CLMSPED)
							lPedInval := AT("TRIANGULAR" , cMsgSped ) == 0
						ENDIF
					ENDIF					
				ENDIF
				cOP1     := IIF(EMPTY(SC6->C6_NUMOP) , " " , SC6->C6_NUMOP+"."+SC6->C6_ITEMOP+".001" )
				cOP2     := IIF(EMPTY(SC6->C6_NUMOP) , " " , SC6->C6_NUMOP+SC6->C6_ITEMOP+"001  " )
				cStatus  := IIF(lPedInval , "2" , IIF(SC6->C6_QTDVEN > SC6->C6_QTDENT , "1" , "0" ) )
				cProduto := SC6->C6_PRODUTO
				cLocal   := SC6->C6_LOCAL
				AADD(aPedido  , { cStatus           , ;
										SC6->C6_ITEM      , ;
										DTOC(SC6->C6_ENTREG) , ;
										cOP1                 , ;
										SC6->C6_PRODUTO      , ;
										SC6->C6_QTDVEN       , ;
										SC6->(C6_QTDVEN-C6_QTDENT) , ;
										SB2->B2_QATU         , ;
										cOP2                 , ;
										SC6->C6_DESCRI } )
				////
				////Roteiro de Operacoes
				////
				IF ( SB1->B1_TIPO $ "PA/PI" )
					nx := ASCAN(aPVPrd , { |x| x[1]==cProduto } )
					IF ( nx == 0 )
						////
						////Amarracao Produto x Pedido
						////
						cQry := "SELECT * "
						cQry += "FROM "+RetSqlName("SC5")+" C5,"+RetSqlName("SC6")+" C6,"+RetSqlName("SA1")+" A1 "
						cQry += "WHERE C5.D_E_L_E_T_ = ' ' AND C6.D_E_L_E_T_ = ' ' AND A1.D_E_L_E_T_ = ' ' "
						cQry += "AND   C5_FILIAL = '"+xFilial("SC5")+"' AND C6_FILIAL = '"+xFilial("SC6")+"' AND A1_FILIAL = '"+xFilial("SA1")+"' "
						cQry += "AND   C6_PRODUTO = '"+cProduto+"' AND C6_QTDVEN > C6_QTDENT "
						cQry += "AND   C6_LOCAL  = '"+cLocal+"' "
						cQry += "AND   C6_CF IN ('5101','5102','5107','5911','5949','6101','6102','6107','6401','6911','6949','7101','7102','7107','7911') "     ///6151???
						cQry += "AND   C5_NUM = C6_NUM "
						cQry += "AND   C5_TIPO = 'N' "
						///cQry += "AND   C5_BLQ = ' ' "
						cQry += "AND   A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI "
						cQry += "ORDER BY C6_NUM,C6_ITEM "

						cQry := ChangeQuery(cQry)

						dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)

						TcSetField("TMP","C6_ENTREG","D",08,0)

						dbSelectArea("TMP")
						dbGoTop()
						DO WHILE !EOF()
							nSaldo := TMP->(C6_QTDVEN - C6_QTDENT)
							AADD(aPVPrd , { cProduto        , ;
												 TMP->C6_NUM     , ;
												 TMP->C6_ITEM    , ;
												 DTOC(TMP->C6_ENTREG)  , ;
												 nSaldo          , ;
												 TMP->C5_CLNOMCL , ;
												 TMP->C6_NUMOP   , ;
												 TMP->C6_ITEMOP  , ;
												 TMP->C6_QTDVEN  , ;
												 TMP->C6_QTDENT  , ;
												 DTOS(TMP->C6_ENTREG) } )
							dbSkip()
						ENDDO
						TMP->(dbCloseArea())
					ENDIF
				ENDIF
				////
				////
				////
				dbSelectArea("SC6")
				dbSkip()
			ENDDO
			IF ( LEN(aPVPrd) > 0 )
				aSort(aPVPrd ,,,{|x,y| x[1]+x[11]+x[2]+x[3] < y[1]+y[11]+y[2]+y[3] } )
			ENDIF
			
			oLst1:SetArray(aPedido)
			oLst1:bLine := {|| { IIF(aPedido[oLst1:nAt,1]=="0",oVm,IIF(aPedido[oLst1:nAt,1]=="1",oVd,oPt)) , ;
										aPedido[oLst1:nAt,2] , ;
										aPedido[oLst1:nAt,3] , ;
										aPedido[oLst1:nAt,4] , ;
										aPedido[oLst1:nAt,5] , ;
										aPedido[oLst1:nAt,6] , ;
										aPedido[oLst1:nAt,7] , ;
										aPedido[oLst1:nAt,8] } }
											
			oLst1:GoTop()
			oLst1:Refresh()
			
			
		ENDIF		
	ENDIF
ENDIF

Return(lRsp)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_Lst1(xnItem)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local nx
Local cOP1,cOP2

IF ( aPedido[xnItem,1]<>"2".AND.!EMPTY(aPedido[xnItem,5]) )
	aPrdPV := {}
	nx     := ASCAN(aPVPrd , { |x| x[1] == aPedido[xnItem,5] } )
	DO WHILE nx > 0 .AND. nx <= LEN(aPVPrd).AND.aPVPrd[nx,1]==aPedido[xnItem,5]
		IF ( ( aPVPrd[nx,2]+aPVPrd[nx,3] ) <> ( cPedido + aPedido[xnItem,2] ) )
			cOP1 := IIF(EMPTY(aPVPrd[nx,7]) , " " , aPVPrd[nx,7]+"."+aPVPrd[nx,8]+".001" )
			cOP2 := IIF(EMPTY(aPVPrd[nx,7]) , " " , aPVPrd[nx,7]+aPVPrd[nx,8]+"001" )
			AADD(aPrdPV , { aPVPrd[nx,2]  , ;
							    aPVPrd[nx,3]  , ;
							    aPVPrd[nx,4]  , ;
							    aPVPrd[nx,5]  , ;
							    aPVPrd[nx,6]  , ;
							    cOP1          , ;
							    cOP2 } ) 
		ENDIF				  
		nx++
	ENDDO
	IF ( LEN(aPrdPV) == 0 )
		aPrdPV := {{"","","","",SPACE(26),SPACE(10)}}
	ENDIF

	oLst2:SetArray(aPrdPV)
	oLst2:bLine := {|| { aPrdPV[oLst2:nAt,1] , ;
								aPrdPV[oLst2:nAt,2] , ;
								aPrdPV[oLst2:nAt,3] , ;
								aPrdPV[oLst2:nAt,4] , ;
								aPrdPV[oLst2:nAt,5] , ;
								aPrdPV[oLst2:nAt,6] } }
									
	oLst2:GoTop()
	oLst2:Refresh()
	
	f_aptproducao(aPedido[xnItem,5],aPedido[xnItem,4],aPedido[xnItem,9])
			
ENDIF
cDescri := aPedido[xnItem,10]
oDescri:Refresh()

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_aptproducao(xcProduto,xcOP1,xcOP2)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local nx,nz,nxSaldo
Local xnQtd  := 0
Local xcOper := ""

cAptOP := ""
aAptOP := {}
IF ( !EMPTY(xcOP1) )
	dbSelectArea("SG2")
	dbSetOrder(3)
	dbSeek(xFilial("SG2")+xcProduto,.T.)
	DO WHILE !EOF().AND.G2_FILIAL==xFilial("SG2").AND.G2_PRODUTO==xcProduto
		IF ( SG2->G2_CODIGO == "01" )
			AADD(aAptOP  , { SG2->G2_OPERAC  , ;
								  SG2->G2_OPERAC+" - "+SG2->G2_DESCRI  , ;
								  0               , ;
								  0               , ;
								  SPACE(8)        , ;
								  SPACE(8)        , ;
								  SPACE(10)       , ;
								  "0"             , ;
								  SG2->G2_RECURSO } )
		ENDIF
		dbSkip()
	ENDDO
	
	dbSelectArea("SH6")
	dbSetOrder(1)
	dbSeek(xFilial("SH6")+xcOP2,.T.)
	DO WHILE !EOF().AND.H6_FILIAL==xFilial("SH6").AND.RTRIM(H6_OP)==RTRIM(xcOP2)
		IF ( SH6->H6_OPERAC == "99" )
			dbSkip()
		ELSE	
			xcOper := SH6->H6_OPERAC
			xnQtd  := IIF(xcOper=="01" , SH6->H6_X_QTE , xnQtd )	
			nZ     := ASCAN(aAptOP , { |x| x[1]==xcOper } )
			DO WHILE !EOF().AND.H6_FILIAL==xFilial("SH6").AND.RTRIM(H6_OP)==RTRIM(xcOP2).AND.H6_OPERAC==xcOper
				aAptOP[nZ,5] := DTOC(SH6->H6_DATAINI)   
				aAptOP[nZ,6] := IIF(SH6->H6_X_QTS > 0 , SH6->H6_DATAFIN , aAptOP[nx,6] )
				aAptOP[nZ,7] := SH6->H6_OPERADO
				aAptOP[nZ,3] += SH6->H6_X_QTE
				aAptOP[nZ,4] += SH6->H6_X_QTS
				dbSkip()
			ENDDO
			nxSaldo := ( xnQtd - aAptOP[nZ,3] )
			IF ( ( aAptOP[nZ,3] + aAptOP[nZ,4] ) > 0 )
				aAptOP[nZ,8] := IIF(nxSaldo > 0 , "1" , IIF(aAptOP[nz,3]==aAptOP[nZ,4] , "2" , "1" ) )
			ENDIF	
		ENDIF
	ENDDO
	cAptOP := "O.P.: "+xcOP1+IIF(EMPTY(xcOper) , "  (PREVISTA)" , "" )

ELSE	
	aAptOP := {{"","","","","","",SPACE(10),""}}
ENDIF

oLst4:SetArray(aAptOP)
oLst4:bLine := {|| { IIF(aAptOP[oLst4:nAt,8]=="0",oVm,IIF(aAptOP[oLst4:nAt,8]=="1",oLr,oVd)) , ;
								 aAptOP[oLst4:nAt,2] , ;
								 aAptOP[oLst4:nAt,3] , ;
								 aAptOP[oLst4:nAt,4] , ;
								 aAptOP[oLst4:nAt,5] , ;
								 aAptOP[oLst4:nAt,6] } }
								
oLst4:GoTop()
oLst4:Refresh()
oAptOP:Refresh()

Return