/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CFATBLQPVº Autor ³ Carlos Nina        º Data ³  03/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Rotina para Bloquear Pedido de Vendas por Liberacao de     º±±
±±º          ³ Regras.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#Include "rwmake.ch"

/////////////////////////////////////////////////////////////
User Function CFATBLQPV()
/////////////////////////////////////////////////////////////
Private oMulti,oPedido,oStatus
Private cPedido  := Space(6)
Private dEmissao := CTOD("")
Private cCliente := Space(40)
Private cVendor  := Space(20)
Private cAtenden := Space(20)
Private cStatus  := "Digite o numero do pedido.                           "
Private n        := 1
Private lSair    := .F.
Private lPedido  := .F.
Private aCols    := {{Space(2),Space(30),Space(30),Space(2),0,0,0,0,0}}
Private aHeader  := {}

AADD(aHeader,{"Item"             , "TB_ITEM   " ,"@!                 " ,02,0 , "   " , "€€€€€€€","C","TRB"})             
AADD(aHeader,{"Produto"          , "TB_PRODUTO" ,"@!                 " ,30,0, "    " , "€€€€€€€","C","TRB"})
AADD(aHeader,{"Descrição"        , "TB_DESCRI " ,"@!                 " ,30,0, "    " , "€€€€€€€","C","TRB"})
AADD(aHeader,{"U.M."             , "TB_UM     " ,"@!                 " ,02,0, "    " , "€€€€€€€","C","TRB"})
AADD(aHeader,{"Qty.Pedida"       , "TB_QTDVEN " ,"@E 99999           " ,05,0, "    " , "€€€€€€€","N","TRB"})
AADD(aHeader,{"Qty.Entregue"     , "TB_QTDENT " ,"@E 99999           " ,05,0, "    " , "€€€€€€€","N","TRB"})
AADD(aHeader,{"Qty.Empenhada"    , "TB_QTDEMP " ,"@E 99999           " ,05,0, "    " , "€€€€€€€","N","TRB"})
AADD(aHeader,{"Prc.Unit."        , "TB_PRCVEN " ,"@E 99999,999.9999  " ,13,4, "    " , "€€€€€€€","N","TRB"})
AADD(aHeader,{"Total"            , "TB_VALOR  " ,"@E 999999,999.99   " ,12,2, "    " , "€€€€€€€","N","TRB"})

dbSelectArea("SA1")
dbSetOrder(1)
*
dbSelectArea("SA2")
dbSetOrder(1)
*
dbSelectArea("SA3")
dbSetOrder(1)
*
dbSelectArea("SC6")
dbSetOrder(1)
*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 065,000 To 377,920 Dialog oDlg Title OemToAnsi("Bloquear Pedido de Vendas")
@ 002,003 To 059,456 Title OemToAnsi("Dados do Pedido")
@ 006,395 To 059,396
@ 007,173 To 029,340 Title OemToAnsi("Status")      ///130  -  290
@ 062,003 To 152,456 Title OemToAnsi("Itens do Pedido")
@ 010,008 Say OemToAnsi("Num.Pedido")                      Size 030,008
@ 010,065 Say OemToAnsi("Data Emissão")                    Size 035,008
@ 035,008 Say OemToAnsi("Cliente")                         Size 017,008
@ 035,173 Say OemToAnsi("Vendedor")                        Size 025,008
@ 035,291 Say OemToAnsi("Atendente")                       Size 030,008
@ 015,175 Say cStatus                                      Size 150,010                   Object oStatus
@ 019,008 Get cPedido  Picture "@!"                        Size 035,010  Valid f_Pedido() Object oPedido
@ 019,065 Get dEmissao                                     Size 045,010  When .F.
@ 044,008 Get cCliente Picture "@!"                        Size 150,010  When .F.
@ 044,173 Get cVendor  Picture "@!"                        Size 100,010  When .F.
@ 044,291 Get cAtenden Picture "@!"                        Size 100,010  When .F.

@ 070,007 TO 148,450 MULTILINE  Object oMulti      

@ 009,400 Button OemToAnsi("_Bloqueia Pedido")             Size 50,13 Action f_Bloqueio()
@ 025,400 Button OemToAnsi("_Cancela")                     Size 50,13 Action f_Cancela()
@ 041,400 Button OemToAnsi("_Sair")                        Size 50,13 Action f_Sair()

Activate Dialog oDlg Center Valid lSair

Return

///////////////////////////////////////////////////////////////////////
Static Function f_Sair()
///////////////////////////////////////////////////////////////////////

IF ( lPedido )
	
	lSair := MsgBox("Deseja mesmo abandonar a rotina de bloqueio?","Escolha a opção","YESNO")
	
ELSE
	lSair := .T.
ENDIF
IF ( lSair )
	oDlg:End()
ENDIF

Return

///////////////////////////////////////////////////////////////////////
Static Function f_Cancela()
///////////////////////////////////////////////////////////////////////
Local lResp := .T.

IF ( lPedido )
	
	lResp := MsgBox("Deseja mesmo cancelar esse bloqueio?","Escolha a opção","YESNO")
		
ENDIF

IF ( lResp )

	lPedido  := .F.
	cPedido  := Space(6)
	oStatus:cCaption  := "Digite o numero do pedido.                           "
	cCliente := Space(40)
	dEmissao := CTOD("")
	cVendor  := Space(20)
	cAtenden := Space(20)
	n        := 1
	aCols    := {{Space(2),Space(30),Space(30),Space(2),0,0,0,0,0}}
	oPedido:Enable()
	oStatus:Refresh()
	oMulti:Refresh()
	oPedido:SetFocus()
	oDlg:Refresh()
	
ENDIF

Return

///////////////////////////////////////////////////////////////////////
Static Function f_Pedido()
///////////////////////////////////////////////////////////////////////
Local lResp := .T.

IF ( !EMPTY(cPedido) )
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xFilial("SC5")+cPedido)
	IF ( EOF() )
		lResp := .F.
		MsgStop("Pedido de Venda não encontrado!. Favor informar outro.","Numero do Pedido")
	ELSE
		SA3->(dbSeek(xFilial("SA3")+SC5->C5_VEND1))
		IF ( SC5->C5_TIPO $ "DB" )
			SA2->(dbSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			cCliente := SA2->A2_NOME
		ELSE
			SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			cCliente := SA1->A1_NOME
		ENDIF
		dEmissao := SC5->C5_EMISSAO
		cVendor  := SA3->A3_NREDUZ
		cAtenden := SC5->C5_CLATEND
		IF ( !EMPTY(SC5->C5_BLQ) )
			oStatus:cCaption  := "Pedido já se encontra bloqueado.                     "
		ELSEIF ( SC5->C5_LIBEROK == "S" )
			oStatus:cCaption  := "Bloqueio não permitido: Pedido já atendido.          "			
		ELSE
			oStatus:cCaption  := "PEDIDO PRONTO PARA BLOQUEIO.                         "			
			lPedido := .T.
		ENDIF
		aCols := {}
		dbSelectArea("SC6")
		dbSeek(xFilial("SC6")+SC5->C5_NUM,.T.)
		DO WHILE !EOF().AND.C6_FILIAL==xFilial("SC6").AND.C6_NUM==SC5->C5_NUM
			AADD( aCols , { SC6->C6_ITEM    , ;
								 SC6->C6_PRODUTO , ;
								 LEFT(SC6->C6_DESCRI,30)  , ;
								 SC6->C6_UM      , ;
								 SC6->C6_QTDVEN  , ;
								 SC6->C6_QTDENT  , ;
								 SC6->C6_QTDEMP  , ;
								 SC6->C6_PRCVEN  , ;
								 SC6->C6_VALOR   } )
			IF ( lPedido.AND.SC6->(C6_QTDENT + C6_QTDEMP) > 0 )
				oStatus:cCaption := "Bloqueio não permitido: Entrega parcial ou Empenhado."		
				lPedido  := .T.
			ENDIF
			dbSkip()
		ENDDO
		oPedido:Disable()
		oStatus:Refresh()
		oMulti:Refresh()
		oDlg:Refresh()
	ENDIF
ENDIF

Return(lResp)

///////////////////////////////////////////////////////////////////////
Static Function f_Bloqueio()
///////////////////////////////////////////////////////////////////////
Local lResp := .T.

IF ( !lPedido )
	MsgInfo("Solicitação não permitida. Favor ver o status do pedido.","Atenção")
	Return(.F.)
ENDIF

lResp := MsgBox("Confirma o bloqueio desse pedido?","Escolha a opção","YESNO")

IF ( lResp )
	RecLock("SC5",.F.)
	SC5->C5_BLQ := "1"
	MsUnlock()
	
	MsgInfo("Pedido bloqueado com sucesso!","Bloqueio")
	
	lPedido  := .F.
	cPedido  := Space(6)
	oStatus:cCaption  := "Digite o numero do pedido.                           "
	cCliente := Space(40)
	dEmissao := CTOD("")
	cVendor  := Space(20)
	cAtenden := Space(20)
	n        := 1
	aCols    := {{Space(2),Space(30),Space(30),Space(2),0,0,0,0,0}}
	oPedido:Enable()
	oStatus:Refresh()
	oMulti:Refresh()
	oDlg:Refresh()
ENDIF

Return(lResp)