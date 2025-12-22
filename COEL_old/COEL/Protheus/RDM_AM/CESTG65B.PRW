/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CESTG65B ³ Autor ³ Carlos Nina           ³ Data ³ 14/05/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gera OP via Vendas - Customizado COELMATIC-MAO             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PCP                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
O campo C6_OP e' utilizado para gravar o status de amarracao entre o Pedido de Venda e a Ordem de Producao.
O campo pode ser gravado com os seguintes valores:
' '  - Pedido de Venda sem amarracao com Ordem de Producao.
'01' - Pedido de Venda que gerou Ordem de Producao.
'02' - Pedido de Venda que era ' ' e foi liberado.
'03' - Pedido de Venda que era '01' e foi liberado.
'04' - Pedido de Venda que foi marcado para geracao de Ordem de Producao mas foi bloqueado pela avaliacao de credito da rotina de avaliacao de credito da Ordem de Producao.
'05' - Pedido de Venda que nao gerou Ordem de Producao pois havia saldo disponivel em estoque. O Pedido de Venda ja comprometeu o saldo necessario.
'06' - Pedido de Venda que era '05' e foi liberado. 
'07' - Liberacao de credito efetuada / Estoque pendente/bloqueada
'08' - Liberacao de estoque efetuada ( item 01 )
/*/
#include "protheus.ch"        
#include "rwmake.ch"        
#include "TOTVS.CH"
#include "TOPCONN.CH"
#include "font.ch"
#include "colors.ch"

User Function CESTG65B()        

Local   nx
Local   cArqTrab
Local   aCores
Local   aStru := {}

IF ( M->cNumEmp <> "0301" )
	Return
ENDIF

Private cPedido,mPedido,cCliente,cParcial,cAntecipado,cAtendente,cDescri,mMsgPed
Private aPVPrd,aPrdPV,aEmpenho
Private lSair
Private nSX8Len
Private lLoop       := .T.
Private nTamProd    := TamSX3("B1_COD")[1]
Private nQtdDec     := TamSX3("B9_QINI")[2]
Private nCusDec     := TamSX3("B9_VINI1")[2]
Private mvLocPad    := IIF(M->cNumEmp=="0301","02","01")    
Private cPictQtd    := X3Picture("B9_QINI")
Private cPictCus    := X3Picture("B9_VINI1")
Private cNumOP      := SPACE(6)
Private cCadastro1  := "Status: EMPENHO"
Private cCadastro2  := "Status: PEDIDO"
Private Tabmes      := 'JANEIRO  FEVEREIROMARCO    ABRIL    MAIO     JUNHO    JULHO    AGOSTO   SETEMBRO OUTUBRO  NOVEMBRO DEZEMBRO '
Private aPedidos    := {{"","","","","","",""}}
Private aLegendEmp  := {}
Private aLegendPed  := {}
Private lInverte    := .F.
Private cMarca      := GetMark()
Private aCampos     := {}

Private oDlg,oGroup01,oGroup02,oGroup03,oGroup04,oGroup05,oGroup06,oGroup07,oGroup7a,oGroup08,oGroup8a,oGroup09,oGroup10
Private oLst0,oLst1,oList2,oLst3,oLst4,oLst5,oLst6,oLst7,oLst8,oLst9,oLst10,oMark,oBtn1,oBtn2,oBtn3,oBtn4,oBtn5
Private oPedido,oCliente,oParcial,oAntecipado,oAtendente,oObserv,oDescri
Private oTBmp1,oTBmp2,oTBmp3,oTBmpAp1,oTBmpAp2,oTBmpAp3

Private oVd := LoadBitmap( GetResources(), 'br_verde')
Private oVm := LoadBitmap( GetResources(), 'br_vermelho')
Private oAz := LoadBitmap( GetResources(), 'br_azul')
Private oAm := LoadBitmap( GetResources(), 'br_amarelo')
Private oPt := LoadBitmap( GetResources(), 'br_preto')
Private oLr := LoadBitmap( GetResources(), 'br_laranja')

Aadd(aLegendEmp, {"BR_VERDE"    , "Disponível"      } ) 
Aadd(aLegendEmp, {"BR_AMARELO"  , "Falta"           } )	
Aadd(aLegendEmp, {"BR_VERMELHO" , "Indisponível"    } ) 

Aadd(aLegendPed, {"BR_VERDE"    , "Liberado para gerar OP"  } ) 
Aadd(aLegendPed, {"BR_VERMELHO" , "OP já gerada ou bloqueado para gerar"    } ) 

aCores := {}
aAdd(aCores,{"TRB->TB_STATUS == '0'","BR_VERDE" })
aAdd(aCores,{"TRB->TB_STATUS <> '0'","BR_VERMELHO"})

SET(1,"OFF")

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
dbSelectArea("SC2")   ///Ordem de Produção
dbSetOrder(1)
*
dbSelectArea("SC5")   ///Pedido de Venda
dbSetOrder(1)
*
dbSelectArea("SC6")   ///Itens do Pedido de Venda
dbSetOrder(1)
*
dbSelectArea("SX5")   ///Tabelas
dbSetOrder(1)
*
AADD(aStru,{"TB_OK"      , "C" , 02 , 0 } )
AADD(aStru,{"TB_ITEM"    , "C" , 02 , 0 } )
AADD(aStru,{"TB_EMISSAO" , "D" , 08 , 0 } )
AADD(aStru,{"TB_ENTREGA" , "D" , 08 , 0 } )
AADD(aStru,{"TB_OP1"     , "C" , 13 , 0 } )
AADD(aStru,{"TB_OP2"     , "C" , 13 , 0 } )
AADD(aStru,{"TB_PRODUTO" , "C" , nTamProd , 0 } )
AADD(aStru,{"TB_SALDO"   , "N" , 08 , 0 } )
AADD(aStru,{"TB_QTDEMP"  , "N" , 08 , 0 } )
AADD(aStru,{"TB_QATU"    , "N" , 10 , 0 } )
AADD(aStru,{"TB_DESCRI"  , "C" , 80 , 0 } )
AADD(aStru,{"TB_STATUS"  , "C" , 01 , 0 } )
AADD(aStru,{"TB_BLQ"     , "C" , 02 , 0 } )
AADD(aStru,{"TB_STOP"    , "C" , 02 , 0 } )
AADD(aStru,{"TB_RECNO"   , "N" , 08 , 0 } )
cArqTrab := CriaTrab(aStru,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.F.,.F.)

AADD(aCampos , { "TB_OK"      , , "Ok"                  ,                  } )
AADD(aCampos , { "TB_ITEM"    , , "Item"                ,                  } )
AADD(aCampos , { "TB_EMISSAO" , , "Emissão"             ,                  } )
AADD(aCampos , { "TB_ENTREGA" , , "Entrega"             ,                  } )
AADD(aCampos , { "TB_PRODUTO" , , "Produto"             ,                  } )
AADD(aCampos , { "TB_SALDO"   , , "Saldo PV"            , "@E 999999"      } )
AADD(aCampos , { "TB_QATU"    , , "Sdo.Estoq."          , "@E 9999999"     } )
AADD(aCampos , { "TB_BLQ"     , , "Blq"                 ,                  } )

DEFINE FONT oFnt   NAME "Arial" Size 10,17             ///LARG. X ALT.
DEFINE FONT oFnt2  NAME "Arial" Size 10,11
DEFINE FONT oFnt3  NAME "Arial" Size 10,12
DEFINE FONT oFnt3a NAME "Arial" Size 7,28     ///8,16
DEFINE FONT oFnt3b NAME "Arial" Size 7.2,26     ///8,16
DEFINE FONT oFnt3c NAME "Arial" Size 7,20     ///8,16
DEFINE FONT oFnt4  NAME "Arial" Size 10,34
DEFINE FONT oFnt5  NAME "Arial" Size 14,72
DEFINE FONT oFnt6  NAME "Arial" Size 9,12
DEFINE FONT oFnt7  NAME "Arial" Size 16,74
DEFINE FONT oFnt8  NAME "Arial" Size 12,14
DEFINE FONT oFnt9  NAME "Arial" Size 16,48
DEFINE FONT oFnt9a NAME "Arial" Size 11,40   
DEFINE FONT oFnt9b NAME "Arial" Size 12,54  

oFont24b := TFont():New( "Arial",,24,,.t.,,,,,.f. )

DO WHILE lLoop
	lSair       := .F.
	cPedido     := SPACE(06)
	mPedido     := cPedido
	cCliente    := SPACE(40)
	cParcial    := SPACE(03)
	cAntecipado := SPACE(03)
	cAtendente  := SPACE(20)
	cDescri     := SPACE(60)
	cOPDesc     := SPACE(40)
	mMsgPed     := SPACE(70)
	nMarked     := 0
	aPVPrd      := {}
	aPrdPV      := {{"","","","","","",SPACE(10),SPACE(10),SPACE(10)}}
	aEmpenho    := {{"","","",0,"",0,0,0,"","","",""}}
	aOPE        := {{"","","","","","",""}}
	aOPS        := {{"","","","","",""}}

	dbSelectArea("TRB")
	dbGoTop()

	DEFINE MSDIALOG oDlg TITLE ":::... Seleção de Pedidos para Gerar Ordem de Produção por Venda ...:::" FROM 000, 000  TO 550, 1296 COLORS 0, 16777215 OF oMainWnd PIXEL

	@ 003,003 GROUP oGroup01 TO 027,050  PROMPT "PEDIDO"                                    OF oDlg COLOR CLR_HBLUE   PIXEL
	@ 003,052 GROUP oGroup02 TO 024,242  PROMPT "CLIENTE"                                   OF oDlg COLOR 0, 16777215 PIXEL  
	@ 003,244 GROUP oGroup03 TO 024,280  PROMPT "PARCIAL?"                                  OF oDlg COLOR 0, 16777215 PIXEL
	@ 003,282 GROUP oGroup04 TO 024,316  PROMPT "ANTEC.?"                                   OF oDlg COLOR 0, 16777215 PIXEL
	@ 003,318 GROUP oGroup05 TO 024,398  PROMPT "ATENDENTE"                                 OF oDlg COLOR 0, 16777215 PIXEL

	@ 010,005 MsGet oPedido             VAR cPedido     PICTURE "@!" F3 "SC5" SIZE 042,012 OF oDlg COLOR 0, 16777215 FONT oFnt3b PIXEL VALID f_PV()
	@ 010,054 Say   oCliente            VAR cCliente                          SIZE 160,012 OF oDlg COLOR CLR_HBLUE   FONT oFnt3a PIXEL
	@ 010,256 Say   oParcial            VAR cParcial                          SIZE 017,012 OF oDlg COLOR CLR_HBLUE   FONT oFnt3a PIXEL
	@ 010,290 Say   oAntecipado         VAR cAntecipado                       SIZE 017,012 OF oDlg COLOR CLR_HBLUE   FONT oFnt3a PIXEL
	@ 010,321 Say   oAtendente          VAR cAtendente                        SIZE 090,012 OF oDlg COLOR CLR_HBLUE   FONT oFnt3a PIXEL

	////==============================================================================================================================================
	@ 030,003 GROUP oGroup06 To 157,358  PROMPT "ITENS DO PEDIDO"                          OF oDlg PIXEL  
	oMark := MsSelect():New("TRB","TB_OK",,aCampos,@lInverte,@cMarca,{038,005,142,356},,oDlg,,,aCores)
	oMark:oBrowse:bldblclick := { || f_Mark() }   
	oMark:oBrowse:bChange := { || f_empenho() }    

	@ 144,006 SAY oDescri                VAR cDescri                          SIZE 240, 012 OF oDlg COLOR CLR_HBLUE   FONT oFnt3a PIXEL 

	@ 160,003 GROUP oGroup07 To 274,358  PROMPT "COMPONENTES"                                 OF oDlg PIXEL  
	oLst8 := TCBrowse():New( 167 , 005, 350, 104,,{'','Componente','Descrição','Quant.','UM','Empenho','Est.Dispon.','Saldo OP'},{20,40,120,40,20,40,40,30},oDlg,,,,,{||},,,,,,"Legenda",.F.,,.T.,,.F.,,, )	

	oLst8:SetArray(aEmpenho)
	oLst8:bChange    := { || f_ordprod(oLst8:nAt) }  	
	oLst8:bldblclick := { || f_analiseprod(oLst8:nAt) }
	oLst8:bLine      := { || { IIF(aEmpenho[oLst8:nAt,1]=="0" , oVm , IIF(aEmpenho[oLst8:nAt,1]=="1" , oVd , oAm ) ) , ;
											 aEmpenho[oLst8:nAt,2] , ;
											 aEmpenho[oLst8:nAt,3] , ;
											 aEmpenho[oLst8:nAt,4] , ;
											 aEmpenho[oLst8:nAt,5] , ;
											 aEmpenho[oLst8:nAt,6] , ;
											 aEmpenho[oLst8:nAt,7] , ;
											 aEmpenho[oLst8:nAt,8] } }								
	oLst8:lAdjustColsize := .F.

	@ 001,401 GROUP oGroup09 To 030,528  PROMPT "Mensagem do Pedido"                                OF oDlg PIXEL    
	@ 008,403 Get oMemo                  Var    mMsgPed MEMO                          Size 122,020  OF oDlg PIXEL WHEN .F.

	@ 030,360 GROUP oGroup10 To 157,647  PROMPT "OP's de Empenho"                                   OF oDlg PIXEL  
	@ 144,362 SAY oOPDesc                VAR cOPDesc                                  SIZE 210,012  OF oDlg COLOR CLR_HBLUE   FONT oFnt3a PIXEL 

	oLst10 := TCBrowse():New( 038 , 362, 282, 104,,{'','O.P.','Produto','Quant.','Data','Pedido/It','Cliente'},{20,35,40,30,30,40,60},oDlg,,,,,{||},,,,,,"Legenda",.F.,,.T.,,.F.,,, )	

	oLst10:SetArray(aOPE)
	oLst10:bLine := {|| { IIF(aOPE[oLst10:nAt,1]=="0" , oVm , oVd ) , ;
								 aOPE[oLst10:nAt,2] , ;
								 aOPE[oLst10:nAt,3] , ;
								 aOPE[oLst10:nAt,4] , ;
								 aOPE[oLst10:nAt,5] , ;
								 aOPE[oLst10:nAt,6] , ;
								 aOPE[oLst10:nAt,7] } }								
	oLst10:lAdjustColsize := .F.

	@ 160,360 GROUP oGroup11 To 274,647  PROMPT "Saldo de OP"                                       OF oDlg PIXEL  

	oLst11 := TCBrowse():New( 167 , 362, 282, 104,,{'','O.P.','Produto','Quant.','Data','Observação'},{20,35,40,30,30,60},oDlg,,,,,{||},,,,,,"Legenda",.F.,,.T.,,.F.,,, )	

	oLst11:SetArray(aOPS)
	oLst11:bLine := {|| { IIF(aOPS[oLst11:nAt,1]=="0" , oVm , oVd ) , ;
								 aOPS[oLst11:nAt,2] , ;
								 aOPS[oLst11:nAt,3] , ;
								 aOPS[oLst11:nAt,4] , ;
								 aOPS[oLst11:nAt,5] , ;
								 aOPS[oLst11:nAt,6] } }								
	oLst11:lAdjustColsize := .F.
	
	@ 004,532 BUTTON oBtn1   PROMPT "Legenda Pedido"            SIZE 054, 013 PIXEL OF oDlg Action f_legendPed()
	@ 004,593 BUTTON oBtn2   PROMPT "Legenda Estrutura"         SIZE 054, 013 PIXEL OF oDlg Action f_legendEmp()
	@ 018,532 BUTTON oBtn3   PROMPT "Gera O.P"       			   SIZE 054, 013 PIXEL OF oDlg Action f_processa()
	@ 018,593 BUTTON oBtn4   PROMPT "Sair"                      SIZE 054, 013 PIXEL OF oDlg Action f_saida()
		
	ACTIVATE MSDIALOG oDlg CENTER VALID lSair

ENDDO
	
TRB->(dbCloseArea())

dbSelectArea("SC2")
dbSetOrder(1)
dbSeek(xFilial("SC2")+cNumOP,.T.)

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_saida()
///////////////////////////////////////////////////////////////////////////////////////////////////////
Local lRsp := .T.

IF ( !EMPTY(aPedidos[1,2]) )
	lRsp := MsgBox("Existe Pedido(s) selecionado(s) para gerar OP. Deseja abandonar a rotina assim mesmo?","Escolha a opção","YESNO")	
ENDIF
IF ( lRsp )
	lSair := .T.
	lLoop := .F.
	oDlg:End()
ENDIF

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_LegendEmp()
///////////////////////////////////////////////////////////////////////////////////////////////////////

BrwLegenda(cCadastro1,"Legenda:",aLegendEmp) 

Return(.T.)

///////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_LegendPed()
///////////////////////////////////////////////////////////////////////////////////////////////////////

BrwLegenda(cCadastro2,"Legenda:",aLegendPed) 

Return(.T.)

/////////////////////////////////////////////////////////////////////////////////
Static Function f_selpv(nItem)
/////////////////////////////////////////////////////////////////////////////////
Local cStatus := IIF(aPedidos[nItem,1]=="1" , "0" , "1" )

aPedidos[nItem,1] := cStatus

oLst10:bLine := {|| { IIF(aPedidos[oLst10:nAt,1]=="0" , oVm , oVd ) , ;
							 aPedidos[oLst10:nAt,2] , ;
							 aPedidos[oLst10:nAt,3] , ;
							 aPedidos[oLst10:nAt,4] , ;
							 aPedidos[oLst10:nAt,5] , ;
							 aPedidos[oLst10:nAt,6] , ;
							 aPedidos[oLst10:nAt,7] } }								
oLst10:Refresh()

Return

/////////////////////////////////////////////////////////////////////////////////
Static Function f_Mark()
/////////////////////////////////////////////////////////////////////////////////
Local nX
Local lResp := ( !EMPTY(TRB->TB_PRODUTO) )

IF ( lResp .AND. TRB->TB_STATUS == "0" )
	RecLock("TRB",.F.)
	IF ( IsMark("TB_OK") )
		TRB->TB_OK := " "
		nMarked -= 1
	ELSE
		TRB->TB_OK := cMarca
		nMarked += 1
	ENDIF
	MsUnlock()
	oMark:oBrowse:Refresh()	
ENDIF

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_PV()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local nx,nSaldo
Local lEncerr
Local cMsgSped,cOP1,cOP2,cProduto,cLocal,cStatus
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
		ELSEIF ( !EMPTY(SC5->C5_BLQ) )
		   MsgStop("Pedido bloqueado para Faturamento.","Atenção")
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
			mMsgPed     := RTRIM(SC5->C5_CLMSPED)
			
			dbSelectArea("TRB")
			__dbZap()

			dbSelectArea("SC6")
			dbSetOrder(1)
			dbSeek(xFilial("SC6")+SC5->C5_NUM,.T.)
			DO WHILE !EOF().AND.C6_FILIAL==xFilial("SC6").AND.C6_NUM==SC5->C5_NUM
				SB1->(dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
				SB2->(dbSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL))
				lPedInval := ( SB1->B1_TIPO <> "PA" )
				IF ( !lPedInval )
					IF ( SC6->C6_CF $ "5101 /5102 /5107 /5901 /5949 /6101 /6107 /6102 /6401 /6949 /7101 /7102 /7107 /7949" )
						IF ( SC6->C6_CF $ "5949 /6949 /7949 " )
							cMsgSped  := UPPER(SC5->C5_CLMSPED)
							lPedInval := AT("TRIANGULAR" , cMsgSped ) == 0
						ENDIF
					ENDIF					
				ENDIF
				
				cProduto := SC6->C6_PRODUTO
				cLocal   := SC6->C6_LOCAL
				lEncerr  := IIF(SC6->( C6_QTDVEN - C6_QTDENT ) > 0 , .F. , .T. )
				IF ( !lEncerr )
					cOP1     := IIF(EMPTY(SC6->C6_NUMOP) , " " , SC6->C6_NUMOP+"."+SC6->C6_ITEMOP+".001" )
					cOP2     := IIF(EMPTY(SC6->C6_NUMOP) , " " , SC6->C6_NUMOP+SC6->C6_ITEMOP+"001  " )
					cStatus  := IIF(lPedInval .OR. SC6->C6_QTDEMP > 0  .OR. !EMPTY(SC6->C6_OP) .OR. !EMPTY(SC6->C6_BLQ) .OR. lEncerr , "1" , "0" ) 
					
					RecLock("TRB",.T.)
					TRB->TB_OK      := ""
					TRB->TB_ITEM    := SC6->C6_ITEM
					TRB->TB_EMISSAO := SC5->C5_EMISSAO
					TRB->TB_ENTREGA := SC6->C6_ENTREG
					TRB->TB_OP1     := cOP1
					TRB->TB_OP2     := cOP2
					TRB->TB_PRODUTO := SC6->C6_PRODUTO
					TRB->TB_SALDO   := SC6->(C6_QTDVEN - C6_QTDENT) 
					TRB->TB_QTDEMP  := SC6->C6_QTDEMP
					TRB->TB_QATU    := SB2->B2_QATU
					TRB->TB_DESCRI  := SC6->C6_DESCRI
					TRB->TB_STATUS  := cStatus
					TRB->TB_BLQ     := IIF(!EMPTY(SC6->C6_BLQ) , SC6->C6_BLQ , SC6->C6_OP )
					TRB->TB_STOP    := SC6->C6_OP
					TRB->TB_RECNO   := SC6->(RECNO())
					MsUnlock()
				ENDIF
				
				dbSelectArea("SC6")
				dbSkip()
			ENDDO

			IF ( LEN(aPVPrd) > 0 )
				aSort(aPVPrd ,,,{|x,y| x[1]+x[11]+x[2]+x[3] < y[1]+y[11]+y[2]+y[3] } )
			ENDIF
			
			dbSelectArea("TRB")
			dbGoTop()
			///oMark:oBrowse:aColSizes[5] := 40                                     
			///oMark:oBrowse:aColSizes[6] := 70                                     
			oMark:oBrowse:GoTop()
			oMark:oBrowse:Refresh()

			f_empenho()
			
		ENDIF		
	ENDIF
ENDIF

Return(lRsp)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_empenho()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local nX,nSdoOP,nEmpenho
Local cOP1,cOP2,cStatus

IF ( !EMPTY(TRB->TB_PRODUTO) )
	aPrdPV   := {}
	aEmpenho := {}
	dbSelectArea("SG1")
	dbSetOrder(1)
	dbSeek(xFilial("SG1")+TRB->TB_PRODUTO,.T.)
	DO WHILE !EOF().AND.SG1->G1_FILIAL==xFilial("SG1").AND.SG1->G1_COD==TRB->TB_PRODUTO
		IF ( SG1->G1_INI <= ddatabase .AND. SG1->G1_FIM >= ddatabase )
			SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))
			SB2->(dbSeek(xFilial("SB2")+SG1->G1_COMP+SB1->B1_LOCPAD))
			
			cQry := "SELECT SUM(C2_QUANT-C2_QUJE) C2_SALDO FROM "+RetSqlName("SC2")+" "
			cQry += "WHERE D_E_L_E_T_ = ' ' AND C2_FILIAL = '"+xFilial("SC2")+"' "
			cQry += "AND C2_DATRF = ' ' AND C2_PRODUTO = '"+SG1->G1_COMP+"' "
			
			cQry := ChangeQuery(cQry)

			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)
			
			nSdoOP := TMP->C2_SALDO
			
			TMP->(dbCloseArea())
			
			//Inkey(0.5)
				
			IF ( SB1->B1_MSBLQL <> "1" )
				////
				////Verifica se existe empenho para OP's prevista
				////
				nEmpenho := 0
				cQry := "SELECT SUM(D4_QUANT) D4_SALDO FROM "+RetSqlName("SD4")
				cQry += " WHERE D_E_L_E_T_ = ' ' AND D4_FILIAL = '"+xFilial("SD4")+"'"
				cQry += " AND D4_QUANT > 0"
				cQry += " AND D4_COD = '"+SG1->G1_COMP+"' "
				
				cQry := ChangeQuery(cQry)

				dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)
				
				nEmpenho := TMP->D4_SALDO
				
				TMP->(dbCloseArea())				

				//Inkey(0.5)
				
				nPerda  := ( ( 1 / ( 100 - SG1->G1_PERDA ) ) * 100 )   //formula da microsiga
				nQtde   := ( SG1->G1_QUANT * TRB->TB_SALDO )
				nQtde   := IIF(SG1->G1_PERDA > 0 , ( nQtde * nPerda ) , nQtde )
				nQtde   := ROUND(nQtde,2)
				nDisp   := ( SB2->B2_QATU - nEmpenho )
				cStatus := IIF(nDisp > 0 , IIF( ( nDisp - nQtde ) > 0 , "1" , "2" ) , "0" )
				
				AADD(aEmpenho , { cStatus               , ;            //1
										SG1->G1_COMP          , ;            //2
										LEFT(SB1->B1_DESC,50) , ;            //3
										nQtde                 , ;            //4
										SB1->B1_UM            , ;            //5
										nEmpenho              , ;            //6
										nDisp                 , ;            //7
										nSdoOP } )                           //8
				
			ENDIF
			
			dbSelectArea("SG1")
			
		ENDIF
		dbSkip()
	ENDDO
	
	IF ( LEN(aEmpenho) == 0 )
		aEmpenho := {{"","","",0,"",0,0,0,"","","",""}}
	ENDIF

	oLst8:SetArray(aEmpenho)
	oLst8:bLine := {|| { IIF(aEmpenho[oLst8:nAt,1]=="0" , oVm , IIF(aEmpenho[oLst8:nAt,1]=="1" , oVd , oAm ) ) , ;
								aEmpenho[oLst8:nAt,2] , ;
								aEmpenho[oLst8:nAt,3] , ;
								aEmpenho[oLst8:nAt,4] , ;
								aEmpenho[oLst8:nAt,5] , ;
								aEmpenho[oLst8:nAt,6] , ;
								aEmpenho[oLst8:nAt,7] , ;
								aEmpenho[oLst8:nAt,8] } }								
									
	oLst8:GoTop()
	oLst8:Refresh()
	
	f_ordprod(1)
	
ENDIF
cDescri := TRB->TB_DESCRI
oDescri:Refresh()

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_ordprod(nItem)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local cQry
Local iw := 0
Local	xProduto := aEmpenho[nItem,2]

///
///Exibe as OPs de Empenho conforme item da estrutura, caso houver.
///
aOPE := {}
IF ( aEmpenho[nItem,6] > 0 )
	cQry := "SELECT D4_OP FROM "+RetSqlName("SD4")
	cQry += " WHERE D_E_L_E_T_ = ' ' AND D4_FILIAL = '"+xFilial("SD4")+"'"
	cQry += " AND D4_QUANT > 0 "
	cQry += " AND D4_COD = '"+xProduto+"' "
	cQry += "GROUP BY D4_OP "
	
	cQry := ChangeQuery(cQry)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)
	
	dbSelectArea("TMP")
	dbGoTop()
	DO WHILE !EOF()
		SC2->(dbSeek(xFilial("SC2")+TMP->D4_OP))
		SC5->(dbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
		SC6->(dbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV))
		AADD(aOPE , { SC2->C2_TPOP                      , ;
						  SC2->C2_NUM+"."+SC2->C2_ITEM      , ;
						  SC2->C2_PRODUTO                   , ;
						  SC2->(C2_QUANT-C2_QUJE)           , ;
						  SC2->C2_DATPRF                    , ;
						  IIF(EMPTY(SC2->C2_PEDIDO) , " " , SC2->C2_PEDIDO+"/"+SC2->C2_ITEMPV ) , ;
						  SC5->C5_CLNOMCL                   , ;
						  LEFT(SC6->C6_DESCRI,40) } )
		dbSkip()
	ENDDO
	
	TMP->(dbCloseArea())

	//Inkey(0.5)
	
ENDIF

cOPDesc := IIF(iw > 0 , aOPE[1,8] , SPACE(40) )
oOPDesc:Refresh()

IF ( LEN(aOPE) == 0 )
	aOPE := {{"","","","","","","",""}}
ENDIF
oLst10:SetArray(aOPE)
oLst10:bLine := {|| { IIF(aOPE[oLst10:nAt,1]=="P" , oAm , oVd ) , ;
							 aOPE[oLst10:nAt,2] , ;
							 aOPE[oLst10:nAt,3] , ;
							 aOPE[oLst10:nAt,4] , ;
							 aOPE[oLst10:nAt,5] , ;
							 aOPE[oLst10:nAt,6] , ;
							 aOPE[oLst10:nAt,7] } }								
oLst10:GoTop()
oLst10:Refresh()
	
///
///Exibe as OPs geradas referente ao item da estrutura, caso houver.
///
aOPS := {}
IF ( aEmpenho[nItem,8] > 0 )
	cQry := "SELECT C2_TPOP,C2_PRODUTO,C2_NUM,C2_ITEM,C2_SEQUEN,C2_DATPRF,C2_OBS,(C2_QUANT-C2_QUJE) C2_SALDO FROM "+RetSqlName("SC2")
	cQry += " WHERE D_E_L_E_T_ = ' ' AND C2_FILIAL = '"+xFilial("SC2")+"' "
	cQry += " AND C2_DATRF = ' ' AND C2_PRODUTO = '"+xProduto+"' "
	
	cQry := ChangeQuery(cQry)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)
	
	dbSelectArea("TMP")
	dbGoTop()
	DO WHILE !EOF()
		SB1->(dbSeek(xFilial("SB1")+TMP->C2_PRODUTO))
		AADD(aOPS  , { TMP->C2_TPOP                  , ;
							TMP->C2_NUM+"."+TMP->C2_ITEM  , ;
							TMP->C2_PRODUTO               , ;
							TMP->C2_SALDO                 , ;
							STOD(TMP->C2_DATPRF)          , ;
							TMP->C2_OBS } )
		dbSkip()					
	ENDDO
	
	TMP->(dbCloseArea())
	
ENDIF
IF ( LEN(aOPS) == 0 )
	aOPS := {{"","","","","","","",""}}
ENDIF
oLst11:SetArray(aOPS)
oLst11:bLine := {|| { IIF(aOPS[oLst11:nAt,1]=="P" , oAm , oVd ) , ;
							 aOPS[oLst11:nAt,2] , ;
							 aOPS[oLst11:nAt,3] , ;
							 aOPS[oLst11:nAt,4] , ;
							 aOPS[oLst11:nAt,5] , ;
							 aOPS[oLst11:nAt,6] } }								
oLst11:GoTop()
oLst11:Refresh()

dbSelectArea("TRB")
	
Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_processa()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local oDlgOP,oGroup,oOPNova,oOPAtual
Local   nX,nW
Local   nOPcB   := 0
Local   cOPNova := mNumOP := SPACE(6)
Private aSav651 := Array(24)

///
///Busca a ultima numeração da OP
///
dbSelectArea("SC2")
nSX8Len := GetSX8Len() 
cNumOP  := GetSX8Num("SC2","C2_NUM")
mNumOP  := cNumOP

/*			
dbSelectArea("SC2")
dbSetOrder(1)
dbSeek(xFilial("SC2")+"ZZZZZZ",.T.)
dbSkip(-1)

cNumOP := IIF(BOF() , "000001" , SOMA1(SC2->C2_NUM) )
*/
nW := Aviso("Gera O.P por Pedido","Gerando OP a partir do número "+RTRIM(cNumOP)+".",{"Confirma","Cancela","Novo Núm."},3)

IF ( nW <> 2 .AND. nMarked > 0 )

	IF ( nW == 3 )
	
		DEFINE MSDIALOG oDlgOP TITLE ":::... NOVO NUMERO DE OP ...:::" FROM 000, 000  TO 110, 430 COLORS 0, 16777215 PIXEL

		@ 001,001 GROUP oGroup TO 054,211 PROMPT ""   		  	                             OF oDlgOP PIXEL COLOR 0, 16777215
		@ 005,004 Say OemToAnsi("Número OP Atual")	                          Size 100,8  OF oDlgOP PIXEL COLOR CLR_HBLUE
		@ 013,004 MsGet oOPAtual           VAR cNumOP                          Size 30,8   OF oDlgOP PIXEL COLOR CLR_HBLUE WHEN .F.
		@ 030,004 Say OemToAnsi("Novo Número OP")                              Size 100,8  OF oDlgOP PIXEL COLOR CLR_HBLUE
		@ 038,004 MsGet oOPNova            VAR cOPNova    Picture "@!"         Size 30,10  OF oDlgOP PIXEL 

		DEFINE SBUTTON FROM 006,183 TYPE 1 ACTION ( nOpcB := 1 , oDlgOP:End() ) ENABLE OF oDlgOP
		DEFINE SBUTTON FROM 023,183 TYPE 2 ACTION ( nOpcB := 2 , oDlgOP:End() ) ENABLE OF oDlgOP

		ACTIVATE MSDIALOG oDlgOP CENTER VALID nOpcB <> 0

		IF ( nOpcB == 1 )
			cNumOP := cOPNova
		ENDIF
		
	ENDIF
	
	////
	////Marca Pedido na base para processamento de Gerar Ordem de Producao
	////
	dbSelectArea("TRB")
	dbGoTop()
	DO WHILE !EOF()
		IF ( IsMark("TB_OK") )
			dbSelectArea("SC6")
			dbGoTo(TRB->TB_RECNO)
			RecLock("SC6",.F.)
			SC6->C6_PROGRAM := "G65B"
			SC6->C6_OK      := cMarca
			MsUnlock()
			dbSelectArea("TRB")
		ENDIF
		TRB->(dbSkip())
	ENDDO
	
	Private cOp    := "" 
	Private cSeqC2 := "000"
	
	inclui := .T.
	cOP    := "04/07/"+Space(Len(SC6->C6_OP))

	Pergunte("MTA651    ",.F.)
	For ni := 1 to 24
		aSav651[ni] := &("mv_par"+StrZero(ni,2))
		IF ( ni == 13 )
			aSav651[ni] := cNumOP
		ENDIF
	Next ni

	Pergunte("MTA650    ",.F.)

	If (ExistTemplate('MA650FIL'))
		cFilA650 := ExecTemplate('MA650FIL',.F.,.F.)
	EndIf

	If (ExistBlock('MA650FIL'))
		cFilA650 := ExecBlock('MA650FIL',.F.,.F.)
	EndIf
	
	cCondicao := "RTRIM(C6_PROGRAM) == 'G65B' "
	
	Processa( { |lEnd| A650GeraOP(@lEnd,"SC6","C6_OK",SC6->(RECNO()),cMarca,lInverte)},OemToAnsi("Geração de OP's por Pedido"),OemToAnsi("Gerando O.P - Coel..."),.F.) 

	////
	////Libera filtro do Pedido de Vendas
	////	
	dbSelectArea("SC2")
	RetIndex("SC2")
	dbClearFilter()		
	
	IF ( cNumOP > mNumOP )
		EvalTrigger()
		Do While ( GetSX8Len() > nSX8Len )
			ConFirmSX8()
		EndDo
	ELSE
		While ( GetSX8Len() > nSX8Len )
			RollBackSX8()
		EndDo	
	ENDIF	
		
	////
	////Libera filtro do Pedido de Vendas
	////
	dbSelectArea("SC6")
	RetIndex("SC6")
	dbClearFilter()		
	////
	////Limpa campo do filtro anterior
	////
	dbSelectArea("TRB")
	dbGoTop()
	DO WHILE !EOF()
		IF ( IsMark("TB_OK") )
			dbSelectArea("SC6")
			dbGoTo(TRB->TB_RECNO)
			RecLock("SC6",.F.)
			SC6->C6_PROGRAM := " "
			MsUnlock()
			dbSelectArea("TRB")
		ENDIF
		TRB->(dbSkip())
	ENDDO
	
	__dbZap()
	
	lSair := .T.
	oDlg:End()
	
ELSE

	dbSelectArea("SC2")
	
	While ( GetSX8Len() > nSX8Len )
		RollBackSX8()
	EndDo
	
	dbSelectArea("TRB")
	
ENDIF

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_analiseprod(nItem)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local   oCodigo,oProduto,oDesc,oTp
Local   oDlgAN,oGroup1,oGroup2
Local   oQtde,oQtdProd,oSaldo
Local   lContinua := ( !EMPTY(aEmpenho[nItem,2]) )
Local   cProduto  := aEmpenho[nItem,2]
Local   nQtdProd  := IIF(lContinua , aEmpenho[nItem,4] , 0 )

IF ( lContinua )
	Private oDescri,oTipo,oSaldoEst
	Private aEstru,aComps
	Private mProduto  := SPACE(30)
	Private cDescri   := ""
	Private cTipo     := ""
	Private nSaldoEst := 0
	Private mQtdProd  := 0

	f_qtdprod(cProduto,nQtdProd,0)
	
   DEFINE MSDIALOG oDlgAN TITLE ":::... Análise de Produção ...:::" FROM 000, 000  TO 450, 1000 COLORS 0, 16777215 PIXEL

   @ 001, 000 GROUP oGroup1 TO 051, 337 PROMPT "Produto"     														  OF oDlgAN COLOR 0, 16777215  PIXEL
   @ 053, 001 GROUP oGroup2 TO 223, 501 PROMPT "Componentes" 														  OF oDlgAN COLOR 0, 16777215  PIXEL
   @ 007, 003 SAY   oCodigo             PROMPT "Código"                          			SIZE 030, 008 OF oDlgAN COLOR  CLR_HBLUE   PIXEL
   @ 014, 003 MSGET oProduto            VAR    cProduto      PICTURE "@!"        F3 "SB1"	SIZE 090, 011 OF oDlgAN COLORS 0, 16777215 PIXEL VALID ExistCpo("SB1",cProduto)
   @ 007, 100 SAY   oDesc               PROMPT "Descrição"        								SIZE 035, 007 OF oDlgAN COLORS 0, 16777215 PIXEL
   @ 014, 100 MSGET oDescri             VAR    cDescri            								SIZE 200, 010 OF oDlgAN COLORS 0, 16777215 PIXEL WHEN .F.
   @ 007, 310 SAY   oTp                 PROMPT "Tipo"             								SIZE 012, 007 OF oDlgAN COLORS 0, 16777215 PIXEL
   @ 014, 310 MSGET oTipo               VAR    cTipo              								SIZE 012, 011 OF oDlgAN COLORS 0, 16777215 PIXEL WHEN .F.
   @ 028, 003 SAY   oQtde               PROMPT "Qtde. a Produzir" 								SIZE 050, 007 OF oDlgAN COLORS 0, 16777215 PIXEL
   @ 035, 003 MSGET oQtdProd            VAR    nQtdProd      PICTURE "@E 999999"      		SIZE 030, 011 OF oDlgAN COLORS 0, 16777215 PIXEL VALID Processa( { || f_qtdprod(cProduto,nQtdProd,1) , "Aguarde..." } )
   @ 028, 100 SAY   oSaldo              PROMPT "Saldo em Estoque" 								SIZE 055, 007 OF oDlgAN COLORS 0, 16777215 PIXEL
   @ 035, 100 MSGET oSaldoEst           VAR    nSaldoEst     PICTURE "@E 9999999" 			SIZE 035, 011 OF oDlgAN COLORS 0, 16777215 PIXEL WHEN .F.

	oLst0 := TCBrowse():New( 060 , 003, 496, 160,,{'','Nível','Componente','Descrição','Freq.Uso','Qty.Consumo','UM','Saldo Atual','Empenho','Est.Dispon.','Reserva(P.C)','Reserva(O.P)','Nec.Atz','Nec.15D','Nec.30D','Nec.60D','Nec.120D','Nec.240D','Nec.360D'},{20,30,60,110,30,40,18,36,30,38,40,40,30,30,30,30,30,30,30},oDlgAN,,,,,{||},,,,,,"Legenda",.F.,,.T.,,.F.,,, )	

	oLst0:SetArray(aComps)
	oLst0:bLine := { || { IIF(aComps[oLst0:nAt,1]=="0" , oVm , oVd ) , ;
									  aComps[oLst0:nAt,2]  , ;
									  aComps[oLst0:nAt,3]  , ;
									  aComps[oLst0:nAt,4]  , ;
									  aComps[oLst0:nAt,5]  , ;
									  aComps[oLst0:nAt,6]  , ;
									  aComps[oLst0:nAt,7]  , ;
									  aComps[oLst0:nAt,8]  , ;
									  aComps[oLst0:nAt,9]  , ;
									  aComps[oLst0:nAt,10] , ;
									  aComps[oLst0:nAt,11] , ;
									  aComps[oLst0:nAt,12] , ;
									  aComps[oLst0:nAt,13] , ;
									  aComps[oLst0:nAt,14] , ;
									  aComps[oLst0:nAt,15] , ;
									  aComps[oLst0:nAt,16] , ;
									  aComps[oLst0:nAt,17] , ;
									  aComps[oLst0:nAt,18] , ;									  
									  aComps[oLst0:nAt,19] } }								
	oLst0:lAdjustColsize := .F.
	
   ACTIVATE MSDIALOG oDlgAN CENTERED
		
ENDIF

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_qtdprod(cProduto,nQtdProd,nOpc)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local nEmp,nOP,nOC,nQtde,nDisp,nSldEst
Local cNivel,cStatus
Local nX      := 1
Local nQty    := IIF(nQtdProd == 0 , 1 , nQtdProd )
Local	aSalAlm := CalcEst(cProduto,mvLocPad,dDataBase+1)

IF ( nOpc == 0 .OR. cProduto <> mProduto .OR. nQtdProd <> mQtdProd )

	SB1->(dbSeek(xFilial("SB1")+cProduto))

	cDescri   := LEFT(SB1->B1_DESC,50)
	cTipo     := SB1->B1_UM	
	nSaldoEst := aSalAlm[1]
	aComps    := {}
	aEstru    := {}

	f_explode(cProduto)

	DO WHILE nX <= LEN(aEstru)
		nNecAtrz  := nNec015D := nNec030D := nNec060D := nNec120D := nNec240D := nNec360D := 0
		nCons030D := nCons060D := nCons120D := nCons240D := nCons360D := 0
		
		nNivel := VAL(aEstru[nX,3])
		cNivel := ( nNivel + 1 )
		cNivel := IIF(nNivel > 1 , SPACE(nNivel-1) , "") + STRZERO(cNivel,3)
		
		SB1->(dbSeek(xFilial("SB1")+aEstru[nX,1]))

		////
		////Verifica se existe empenho para OP's prevista
		////
		nEmp := 0
		cQry := "SELECT SUM(D4_QUANT) D4_SALDO FROM "+RetSqlName("SD4")
		cQry += " WHERE D_E_L_E_T_ = ' ' AND D4_FILIAL = '"+xFilial("SD4")+"'"
		cQry += " AND D4_QUANT > 0"
		cQry += " AND D4_COD = '"+aEstru[nX,1]+"' "
		
		cQry := ChangeQuery(cQry)

		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP1', .T., .T.)
		
		nEmp := TMP1->D4_SALDO
		
		TMP1->(dbCloseArea())				
		
		cQry := "SELECT SUM(C2_QUANT-C2_QUJE) C2_SALDO FROM "+RetSqlName("SC2")+" "
		cQry += "WHERE D_E_L_E_T_ = ' ' AND C2_FILIAL = '"+xFilial("SC2")+"' "
		cQry += "AND C2_DATRF = ' ' AND C2_PRODUTO = '"+aEstru[nX,1]+"' "
		
		cQry := ChangeQuery(cQry)

		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP2', .T., .T.)
		
		nOP := TMP2->C2_SALDO
		
		TMP2->(dbCloseArea())

		cQry := "SELECT SUM(C7_QUANT-C7_QUJE) C7_SALDO FROM "+RetSqlName("SC7")+" "
		cQry += "WHERE D_E_L_E_T_ = ' ' AND C7_FILIAL = '"+xFilial("SC7")+"' "
		cQry += "AND C7_QUANT > C7_QUJE AND C7_ENCER = ' ' AND C7_RESIDUO = ' ' AND C7_PRODUTO = '"+aEstru[nX,1]+"' "
		
		cQry := ChangeQuery(cQry)

		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP3', .T., .T.)
		
		nOC := TMP3->C7_SALDO
		
		TMP3->(dbCloseArea())
		
		////
		////Calculo da necessidade do PI, de acordo com a carteira de venda
		////
		IF ( SB1->B1_TIPO == 'PI' )
			cQry := "SELECT C6_ENTREG,SUM(C6_QTDVEN-C6_QTDENT) C6_SALDO FROM "+RetSqlName("SG1")+" G1,"+RetSqlName("SC6")+" C6,"+RetSqlName("SC5")+" C5 "
			cQry += "WHERE G1.D_E_L_E_T_ = ' ' AND G1_FILIAL = '"+xFilial("SG1")+"' AND G1_FIM >= '"+DTOS(ddatabase)+"' AND G1_COMP = '"+aEstru[nX,1]+"' "			
			cQry += "AND C6.D_E_L_E_T_ = ' ' AND C6_FILIAL = '"+xFilial("SC6")+"' "
			cQry += "AND C6_QTDVEN > C6_QTDENT AND C6_PRODUTO = G1_COD AND C6_BLQ = ' ' "
			cQry += "AND ( C6_CF IN ('5101','6101','7101','5102','5107','5911','6102','6401','7102','7107') OR ( C6_CF IN ('5949','6949','7949') AND C5_CLMSPED LIKE '%TRIANGULAR%' ) ) "
			cQry += "AND C5.D_E_L_E_T_ = ' ' AND C5_FILIAL = '"+xFilial("SC5")+"' AND C5_NUM = C6_NUM "
			cQry += "GROUP BY C6_ENTREG "
			
			cQry := ChangeQuery(cQry)

			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP4', .T., .T.)
			
			TcSetField("TMP4","C6_ENTREG","D",8,0)			

			dbSelectArea("TMP4")
			dbGoTop()
			DO WHILE !EOF()
				IF ( TMP4->C6_ENTREG < ddatabase )
					nNecAtrz += TMP4->C6_SALDO
				ELSE
					IF ( TMP4->C6_ENTREG  <= DaySum(ddatabase , 15) )
						nNec015D += TMP4->C6_SALDO
					ELSEIF ( TMP4->C6_ENTREG <= DaySum(ddatabase , 30) )
						nNec030D += TMP4->C6_SALDO
					ELSEIF ( TMP4->C6_ENTREG <= DaySum(ddatabase , 60) )
						nNec060D += TMP4->C6_SALDO
					ELSEIF ( TMP4->C6_ENTREG <= DaySum(ddatabase , 120) )
						nNec120D += TMP4->C6_SALDO
					ELSEIF ( TMP4->C6_ENTREG <= DaySum(ddatabase , 240) )
						nNec240D += TMP4->C6_SALDO
					ELSEIF ( TMP4->C6_ENTREG <= DaySum(ddatabase , 360) )
						nNec360D += TMP4->C6_SALDO
					ENDIF	
				ENDIF
				dbSkip()
			ENDDO
			
			TMP4->(dbCloseArea())
			
		ENDIF

		aSalAlm := CalcEst(aEstru[nX,1],mvLocPad,dDataBase+1)
		
		nSldEst := aSalAlm[1]
		nPerda  := ( ( 1 / ( 100 - aEstru[nX,4] ) ) * 100 )                      //formula da microsiga
		nQtde   := ( aEstru[nX,2] * nQty )
		nQtde   := IIF(aEstru[nX,4] > 0 , ( nQtde * nPerda ) , nQtde )
		nQtde   := ROUND(nQtde,2)
		nDisp   := ( nSldEst - nEmp - nQtde )
		cStatus := IIF(nDisp >= 0 , "1" , "0" )
		
		AADD(aComps , { cStatus      , ;
							 cNivel       , ;
							 aEstru[nX,1] , ;
							 LEFT(SB1->B1_DESC,40) , ;
							 aEstru[nX,2] , ;
							 nQtde        , ;
							 SB1->B1_UM   , ;
							 nSldEst      , ;
							 nEmp         , ;
							 nDisp        , ;
							 nOC          , ;
							 nOP          , ;
							 nNecAtrz     , ;
							 nNec015D     , ;
							 nNec030D     , ;
							 nNec060D     , ;
							 nNec120D     , ;
							 nNec240D     , ;
							 nNec360D } )
							 
		nX++
		
	ENDDO
	IF ( LEN(aComps) = 0 )
		aComps := {{"0","","","","","","","","","","","","","","","","","",""}}
	ENDIF
	IF ( nOpc == 1 )
		oLst0:SetArray(aComps)
		oLst0:bLine := { || { IIF(aComps[oLst0:nAt,1]=="0" , oVm , oVd ) , ;
										  aComps[oLst0:nAt,2]  , ;
										  aComps[oLst0:nAt,3]  , ;
										  aComps[oLst0:nAt,4]  , ;
										  aComps[oLst0:nAt,5]  , ;
										  aComps[oLst0:nAt,6]  , ;
										  aComps[oLst0:nAt,7]  , ;
										  aComps[oLst0:nAt,8]  , ;
										  aComps[oLst0:nAt,9]  , ;
										  aComps[oLst0:nAt,10] , ;
										  aComps[oLst0:nAt,11] , ;
										  aComps[oLst0:nAt,12] , ;
										  aComps[oLst0:nAt,13] , ;
										  aComps[oLst0:nAt,14] , ;
										  aComps[oLst0:nAt,15] , ;
										  aComps[oLst0:nAt,16] , ;
										  aComps[oLst0:nAt,17] , ;
										  aComps[oLst0:nAt,18] , ;
										  aComps[oLst0:nAt,19] } }								
		oLst0:lAdjustColsize := .F.
		
		oLst0:Refresh()
		oDescri:Refresh()
		oTipo:Refresh()
		oSaldoEst:Refresh()
	ENDIF
	mProduto := cProduto
	mQtdProd := nQtdProd
ENDIF
	
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_explode(cProduto)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
LOCAL nRegi

dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xFilial("SG1")+cProduto)

While !Eof() .And. G1_FILIAL+G1_COD == xFilial("SG1")+cProduto

	nRegi:=Recno()

	IF ( G1_INI > ddatabase .OR. G1_FIM < ddatabase )   //Solicitacao da Persi (Coelmatic) pra deixar igual a rotina de estrutura simples
      dbSkip()
      Loop
   ENDIF

	nProcura:=aScan(aEstru,{|nn| nn[1]==G1_COMP})
	If nProcura  = 0
		AADD(aEstru,{G1_COMP,G1_QUANT,G1_NIV,G1_PERDA})
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe sub-estrutura                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nRecno:=Recno()
	If dbSeek(xFilial("SG1")+G1_COMP,.F.)
		f_explode(G1_COD)
	Else
		dbGoto(nRecno)
		nProcura:=aScan(aEstru,{|nn| nn[1]==G1_COMP})
		If nProcura  = 0
			AADD(aEstru,{G1_COMP,G1_QUANT,G1_NIV,G1_PERDA})
		EndIf
	Endif

	dbGoto(nRegi)
	dbSkip()

Enddo

Return //(aEstru)
