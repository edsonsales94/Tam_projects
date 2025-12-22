#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "JPEG.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CApt_Oper4³ Autor ³ Carlos                ³ Data ³27/03/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Recebimento da OP pela Expedicao                           ³±±
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
User Function CApt_Op4()

Local dData1 := GETMV('MV_ULMES')
Local dData2 := GETMV('MV_DBLQMOV')

Private cSetor,cOperI,cOperF
Private lEmProcesso
Private oEdit0,oEdit1,oEdit2,oEdit3,oEdit4,oEdit5,oEdit6,oEmissao,oEntrega,oDtEntrega,oQuantS,oQuantG,oQtyR,oQtyJR
Private oGroup1,oGroup2,oGroup3
Private oBold
Private oTBitMap1,oTBitMap2,oTBar
Private oCracha,oOperac,oUsuario,oOperacao,oRecurso,oNumero,oNOP,oProdDesc,oProduto,oDescri,oObs,oObserv
Private oQtdPed,oQtyPed,oQty,oData,oHorario,oHora

// Variaveis Private da Funcao
Private _oDlg				// Dialog Principal
Private _nHRes 	  := oMainWnd:nClientWidth
Private _cTheme	  := Alltrim(GetTheme())
Private _lMdiChild  := SetMdiChild()
Private _lSair      := .F.
Private _cOp        := ""
Private _cProd      := ""
Private _cCod       := ""
Private _cDesc      := ""
Private _cObs       := ""
Private _cAlmox     := ""
Private _dDatPrf    := CTOD("")
Private _nQtde      := 0
Private n_QtyE      := 0
Private _nQuant     := 0
Private _nQuje      := 0
Private cHora       := LEFT(STRTRAN(FwTimeUF()[2],":",""),4)
Private cRecurso    := ""
Private cEdit0      := Space(9)
Private cEdit1      := Space(13)
Private cEdit6      := Space(10)
Private lEmProcesso := .F.
Private cEdit5      := ""
Private cEdit2      := 0
Private dEmissao    := ddatabase
Private cSetor      := "01"
Private dDatFech    := IIF(dData2 > dData1 , dData2 , dData1 )
							 
DEFINE FONT 	oBold NAME "Times New Roman"	SIZE 0,  18 BOLD  
DEFINE FONT 	oFnt  NAME "Arial"				SIZE 0, -16 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt4 NAME "Arial"				SIZE 0, -20 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt3 NAME "Arial"				SIZE 0, -18 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt2 NAME "Arial"				SIZE 0, -14 BOLD	// "Times New Roman" Menor

dbSelectArea("SX5")   ///Tabelas
dbSetOrder(1)
*
///aRet := FwTimeUF("AM")                              ///aRet[1] = 20140227  ; aRet[2] = 17:32:33

DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Expedição: Recebimento de OP's") FROM 000,000 TO 360,518 COLORS 0, 16777215 PIXEL

oTBar := TBar():New( _oDlg,40,25,.T.,,,'tbar2_coel',.F. )   ///40,25

@ 015, 001 GROUP oGroup1 TO 083, 260 PROMPT "PARAMETROS COD.BARRAS"    						  OF _oDlg COLOR 0, 16777215 PIXEL
@ 087, 001 GROUP oGroup2 TO 173, 260 PROMPT "ORDEM DE PRODUÇÃO"        						  OF _oDlg COLOR 0, 16777215 PIXEL
@ 015, 001 GROUP oGroup3 TO 083, 260 PROMPT "RECEBIMENTO"              						  OF _oDlg COLOR 0, 16777215 PIXEL

@ 024, 004 SAY   oCracha		PROMPT  "Crachá"                 					SIZE 080, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt
@ 024, 125 SAY   oUsuario  	PROMPT  "Usuário"                					SIZE 040, 009 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt
@ 033, 004 MSGET oEdit0 		VAR     cEdit0    PASSWORD       					SIZE 040, 014 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt4  Valid(_fVlDlg("MATR",cEdit0)) 
@ 033, 125 MSGET oEdit6 		VAR     cEdit6    PICTURE "@!"   					SIZE 090, 014 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt4  WHEN (cSetor=="01")
@ 053, 004 SAY   oOperacao	   PROMPT  "Operação"                					SIZE 090, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt
@ 063, 004 MSGET oEdit1 		VAR     cEdit1    PICTURE "@R XXXXXX99999.99"	SIZE 090, 014 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt4  VALID (_fVlDlg("CBAR",cEdit1))

@ 094, 004 SAY   oNumero		PROMPT  "Número"                 					SIZE 060, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 102, 004 SAY   oNOP   		VAR     _cOP      PICTURE "@R XXXXXX.99.999"		SIZE 080, 012 OF _oDlg COLOR  CLR_HRED    PIXEL  Font oFnt4
@ 094, 196 SAY   oQuantS   	PROMPT  "Quantidade"             					SIZE 060, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 102, 196 SAY   oQuantG		VAR     _nQtde    PICTURE "@E 9999,999"     		SIZE 060, 012 OF _oDlg COLOR  CLR_HRED    PIXEL  Font oFnt4
@ 116, 004 SAY   oProdDesc		PROMPT  "Produto / Descrição"   	 					SIZE 120, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 125, 004 SAY   oProduto 		VAR     _cProd                   					SIZE 130, 014 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4
@ 140, 004 SAY   oDescri		VAR     _cDesc                   					SIZE 240, 014 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt
@ 116, 196 SAY   oEntrega 		PROMPT  "Data de Entrega"       	 					SIZE 120, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 125, 196 SAY   oDtEntrega	VAR     _dDatPrf                 					SIZE 130, 014 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4
@ 153, 004 SAY   oObserv		PROMPT  "Observação"             					SIZE 060, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 162, 004 SAY   oObs   		VAR     _cObs                    					SIZE 240, 012 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt2

@ 024, 004 SAY   oData  		PROMPT  "Data"                     					SIZE 050, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL  Font oFnt          ///320
@ 053, 004 SAY   oQty   		PROMPT  "Quantidade"             					SIZE 070, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL  Font oFnt          ///247
@ 053, 090 SAY   oHorario		PROMPT  "Hora"                   					SIZE 020, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL  Font oFnt
@ 053, 176 SAY   oQtyR   		PROMPT  "Qtde. já Recebida"   					   SIZE 100, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL  Font oFnt
@ 033, 004 MSGET oEmissao		VAR     dEmissao                 					SIZE 060, 014 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt4 Valid(_fVlDlg("DEMIS",dEmissao))
@ 063, 004 MSGET oEdit2 		VAR     cEdit2    PICTURE "@E 99,999"				SIZE 035, 014 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt4 Valid(_fVlDlg("QTDE",cEdit2))     
@ 063, 090 MSGET oHora  		VAR     cHora     PICTURE "@R 99:99"				SIZE 020, 014 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt4 
@ 063, 176 MSGET oQtyJR 		VAR     n_QtyE    PICTURE "@E 99,999"  			SIZE 020, 014 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt4 WHEN .F.

oTBitmap3 := TBtnBmp2():New( 043, 346, 70, 30,'conf_coel',,,,;
					{ || f_Confirma() }  ,_oDlg,'Confirma Recebimento',,.F.,.F.)
oTBitmap4 := TBtnBmp2():New( 043, 440, 70, 30,'canc_coel',,,,;
					{ || f_Cancela() }  ,_oDlg,'Cancela Recebimento',,.F.,.F.)
						
oTBitmap1 := TBtnBmp2():New( 00, 00, 40, 70, 'S4WB008N' ,,,,;
					{ || Calculadora() }  ,oTBar,'Calculadora',,.F.,.F.)
oTBitmap2 := TBtnBmp2():New( 00, 00, 40, 70, 'button_exit' ,,,,;
					{ || f_Saida() }  ,oTBar,'Sair',,.F.,.F.)

oNumero:Hide()
oNOP:Hide()
oProdDesc:Hide()
oProduto:Hide()
oDescri:Hide()
oObserv:Hide()
oObs:Hide()
oData:Hide()
oQty:Hide()
oHorario:Hide()
oEdit2:Hide()
oHora:Hide()
oEmissao:Hide()
oEntrega:Hide()
oDtEntrega:Hide()
oQuantS:Hide()
oQuantG:Hide()
oQtyR:Hide()
oQtyJR:Hide()
oGroup2:Hide()
oGroup3:Hide()
oTBitmap3:Hide()
oTBitmap4:Hide()
oEdit1:Disable()	
oEdit0:SetFocus()

ACTIVATE MSDIALOG _oDlg CENTER Valid _lSair
	
Return

///////////////////////////////////////////////////////////
Static Function f_Cancela()
///////////////////////////////////////////////////////////
Local lRsp

lRsp := MsgBox("Confirma o Cancelamento desse apontamento?","Escolha a opção","YESNO")

IF ( lRsp )
	cEdit0      := Space(9)
	cEdit1      := Space(13)
	cEdit6      := Space(10)
	cSetor      := "01"
	_nQuje      := 0
	n_QtyE      := 0
	cEdit2      := 0
	lEmProcesso := .F.
	
	oNumero:Hide()
	oNOP:Hide()
	oProdDesc:Hide()
	oProduto:Hide()
	oDescri:Hide()
	oObserv:Hide()
	oObs:Hide()
	oData:Hide()
	oQty:Hide()
	oHorario:Hide()
	oEmissao:Hide()
	oEdit2:Hide()
	oHora:Hide()
	oEntrega:Hide()
	oDtEntrega:Hide()
	oQuantS:Hide()
	oQuantG:Hide()	
	oGroup2:Hide()
	oGroup3:Hide()
	oTBitmap3:Hide()
	oTBitmap4:Hide()
	oQtyR:Hide()
	oQtyJR:Hide()
	oGroup1:Show()
	oCracha:Show()
	oUsuario:Show()
	oOperacao:Show()
	oEdit0:Show()
	oEdit1:Show()
	oEdit6:Show()
	oEdit0:Enable()
	oEdit1:Disable()
	oEdit0:SetFocus()

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
	_lSair := .T.
	_oDlg:End()
ENDIF

Return(lRsp)

/////////////////////////////////////////////////////////////////////////////
Static Function f_Confirma()
/////////////////////////////////////////////////////////////////////////////
Local xEdit1   := LEFT(cEdit1,11) + "  "        
Local lLiberOk := .T.
Local lCredito := .F.
Local lEstoque := .F.
Local cPedVen  := SC2->C2_PEDIDO
Local cItmVen  := SC2->C2_ITEMPV
Local cProdVen := SC2->C2_PRODUTO

IF ( cEdit2 ==  0 )
	MsgStop("Falta informar a quantidade.","Atenção")
	Return(.F.)
ENDIF
IF ( EMPTY(dEmissao) )
	MsgStop("Falta informar a data de recebimento.","Atenção")
	Return(.F.)
ENDIF

cHora := IIF(EMPTY(cHora) , LEFT(STRTRAN(FwTimeUF()[2],":",""),4) , cHora )

dbSelectArea("SH6")
dbSetOrder(1)		
RecLock("SH6",.T.)
SH6->H6_FILIAL  := xFilial("SH6")
SH6->H6_OP      := xEdit1          
SH6->H6_OPERAC  := cEdit5
SH6->H6_PRODUTO := _cCod
SH6->H6_RECURSO := cRecurso
SH6->H6_DTAPONT := dEmissao
SH6->H6_DATAINI := dEmissao
SH6->H6_HORAINI := TRANSF(cHora,"@R 99:99")
SH6->H6_DATAFIN := dEmissao
SH6->H6_HORAFIN := LEFT(FwTimeUF()[2],5)
SH6->H6_PT      := IIF( EMPTY(SC2->C2_DATRF).AND.SC2->C2_QUANT > SC2->C2_QUJE , "P" , "T" )
SH6->H6_TEMPO   := "000:00"
SH6->H6_DESDOBR := "000"
SH6->H6_TIPO    := "P"
SH6->H6_DTPROD  := dEmissao
SH6->H6_TIPOTEM := 1
SH6->H6_LOCAL   := _cAlmox
SH6->H6_X_ES    := "E"
SH6->H6_QTDPROD := cEdit2
SH6->H6_X_QTE   := cEdit2
SH6->H6_X_QTS   := cEdit2
SH6->H6_X_QTA   := 1
SH6->H6_OPERADO := cEdit6            
MsUnLock()

//////
//////Libera o item para faturamento. Somente na quantidade total do recebimento na expedicao.
//////
dbSelectArea("SF4")
dbSetOrder(1)
*
dbSelectArea("SC6")
dbSetOrder(1)
dbSeek(xFilial("SC6")+cPedVen+cItmVen+cProdVen)
IF (!EOF().AND.QTDCOMP(SC6->C6_QTDVEN) == QTDCOMP(cEdit2).AND.QTDCOMP(SC6->C6_QTDEMP) == 0 )
	nRecSC6 := SC6->(RECNO())    
	SC5->(dbSeek(xFilial("SC5")+SC6->C6_NUM))                                           ////Posiciona SC5
	IF ( EMPTY(SC5->C5_NOTA).AND.EMPTY(SC5->C5_LIBEROK).AND.EMPTY(SC5->C5_BLQ) )        ////Pedido em Aberto
		////
		////Verifica se os outros itens já foram liberados p/faturamento
		////
		Begin Transaction
				RecLock("SC6",.F.)
				If ( SC5->C5_TIPLIB=="1" )
					nQtdLib := cEdit2
					nQtdLib := MaLibDoFat(nRecSC6,nQtdLib,@lCredito,@lEstoque,.T.,.T.,.F.,.F.,NIL,NIL,NIL,NIL,NIL,NIL,0)
				EndIf
		End Transaction
		////
		////Verifica se os outros itens já foram liberados p/faturamento
		////
		dbSelectArea("SC6")
		dbSeek(xFilial("SC6")+cPedVen,.T.)
		DO WHILE !EOF().AND.SC6->C6_FILIAL==xFilial("SC6").AND.SC6->C6_NUM==cPedVen
			If ( SC6->C6_QTDVEN > SC6->C6_QTDEMP + SC6->C6_QTDENT .And. lLiberOk )
				lLiberOk := .F.
			EndIf              
			dbSkip()
		ENDDO
		*
		Begin Transaction
				If ( lLiberOk )                 
					dbSelectArea("SC5")
					RecLock("SC5",.F.)
					SC5->C5_LIBEROK := "S"       ////Marca Pedido como atendido
					MsUnlock()
				EndIf
		End Transaction
	ENDIF
ENDIF

MsgInfo("Operação efetuada com sucesso!!!","Atenção")

cEdit0      := Space(9)
cEdit1      := Space(13)
cEdit6      := Space(10)
cSetor      := "01"
_nQuje      := 0
n_QtyE      := 0
cEdit2      := 0
lEmProcesso := .F.

oNumero:Hide()
oNOP:Hide()
oProdDesc:Hide()
oProduto:Hide()
oDescri:Hide()
oObserv:Hide()
oObs:Hide()
oData:Hide()
oQty:Hide()
oHorario:Hide()
oEmissao:Hide()
oEdit2:Hide()
oHora:Hide()
oEntrega:Hide()
oDtEntrega:Hide()
oQuantS:Hide()
oQuantG:Hide()	
oQtyR:Hide()
oQtyJR:Hide()
oGroup2:Hide()
oGroup3:Hide()
oTBitmap3:Hide()
oTBitmap4:Hide()	
oGroup1:Show()
oCracha:Show()
oUsuario:Show()
oEdit0:Show()
oEdit1:Show()
oEdit6:Show()	
oEdit0:Enable()
oEdit1:Disable()
oEdit0:SetFocus()
		
Return

/////////////////////////////////////////////////////////////////////////
Static Function _fVlDlg(_cTipo,_xConteudo)
/////////////////////////////////////////////////////////////////////////
Local xEdit1
Local _lRet	:= .t. 

Do Case
	Case Upper(Alltrim(_cTipo)) == "CBAR"
		
		If !Empty(_xConteudo)
			
			x_Barra := SUBS(_xConteudo,1,1)+SUBS(_xConteudo,8,1)
			IF ( x_Barra == "99".AND.LEN(RTRIM(_xConteudo))==8 )
				cEdit1 := space(13)
				_lRet  := .f.
				oEdit1:Refresh()
			ELSE		
				cEdit5 := Substring(_xConteudo,12,2)
				_cOP	 := Substring(_xConteudo,1,11)
				IF ( cEdit5 < cOperI .OR. cEdit5 > cOperF )
					MsgStop("Usuário sem permissão para apontar esta Operação.","Operação")
					Return(.F.)
				ENDIF
			
				DbSelectArea("SC2")
				DbSetOrder(1)                                     
				dbSeek(xFilial("SC2") + Substr(_xConteudo,1,11))
				If !EOF()	
					xEdit1 := _cOP + "  "
					////
					////Valida se foi digitado manualmente
					////
					IF ( cEdit5 <> "99" )
						MsgStop("Operação inválida. Favor usar o leitor de codigo de barras.","Atenção")
						Return(.F.)
					ENDIF
					////
					////Verifica se a OP está amarrada a um Pedido de Venda
					////
					IF ( EMPTY(SC2->C2_PEDIDO) )
						MsgStop("Não existe amarração de Pedido de Venda para esta O.P.","Atenção")
						Return(.F.)
					ENDIF
					////
					////Verifica se já houve entrada da producao no sistema
					////
					IF ( SC2->C2_QUJE <= 0 )
						MsgStop("Ainda não houve Apontamento de Produção para esta O.P.","Atenção")
						Return(.F.)
					ENDIF
					*
					n_QtyE := 0
					*
					dbSelectArea("SH6")
					dbSetOrder(3)
					dbSeek(xFilial("SH6")+SC2->C2_PRODUTO+xEdit1,.T.)
					DO WHILE !EOF().AND.H6_FILIAL==xFilial("SH6").AND.SH6->H6_PRODUTO==SC2->C2_PRODUTO.AND.SH6->H6_OP==xEdit1
						cRecurso := SH6->H6_RECURSO
						IF ( SH6->H6_OPERAC==cEdit5 )				
							n_QtyE += SH6->H6_X_QTE
						ENDIF	
						dbSkip()
					ENDDO	
					If ( n_QtyE == SC2->C2_QUJE )
						IF ( !EMPTY(SC2->C2_DATRF) )
							MsgStop("O Recebimento Total desta O.P. já foi efetuado.","Atenção")
						ELSE
							MsgStop("O Recebimento Parcial desta O.P. já foi efetuado.","Atenção")
						ENDIF	
						cEdit1 := space(13)
						_lRet  := .F.
					Else
						DbSelectArea("SB1")
						DbSetOrder(1)
						DbSeek(xFilial("SB1") + SC2->C2_PRODUTO )
						*					
						_cCod    := SC2->C2_PRODUTO
						_nQtde   := SC2->C2_QUANT
						_nQuje   := SC2->C2_QUJE
						_dDatPrf := SC2->C2_DATPRF
						_cProd   := Alltrim(SC2->C2_PRODUTO) 
						_cObs    := SC2->C2_OBS
						_cAlmox  := SC2->C2_LOCAL
						_cDesc   := LEFT(SB1->B1_DESC,50)
						cHora    := LEFT(STRTRAN(FwTimeUF()[2],":",""),4)
						
						oNumero:Show()
						oNOP:Show()
						oProdDesc:Show()
						oProduto:Show()
						oDescri:Show()
						oObserv:Show()
						oObs:Show()
						oData:Show()
						oQty:Show()
						oHorario:Show()
						oEmissao:Show()
						oEdit2:Show()
						oHora:Show()
						oEntrega:Show()
						oDtEntrega:Show()
						oQuantS:Show()
						oQuantG:Show()						
						oQtyR:Show()
						oQtyJR:Show()
						oGroup2:Show()
						oGroup3:Show()
						oTBitmap3:Show()
						oTBitmap4:Show()
						oGroup1:Hide()
						oCracha:Hide()
						oUsuario:Hide()
						oOperacao:Hide()
						oEdit0:Hide()
						oEdit1:Hide()
						oEdit6:Hide()
						oEmissao:SetFocus()
						lEmProcesso := .T.
					EndIf
										
				Else
					MsgStop("Ordem de Produção NÃO Encontrada!","Atenção")
					_lRet := .f.
				EndIf
			ENDIF
		EndIf
		
	Case Upper(Alltrim(_cTipo)) == "QTDE"
		
		_nQuant := IIf(_xConteudo > 0 , _xConteudo , 0 )

		IF ( _nQuant < 0 )
			MsgStop("Quantidade informada inválida: valor negativo.","Atenção")
			_lRet := .F.
		ELSEIF ( ( n_QtyE + _nQuant ) > _nQuje )
			IF ( n_QtyE > 0 )
				MsgStop("Quantidade informada excede a Quantidade Recebida x Quantidade Produzida por esta O.P.","Atenção")
			ELSE	
				MsgStop("Quantidade informada maior que a quantidade já produzida por esta O.P.","Atenção")
			ENDIF	
			_lRet := .F.
		ENDIF

	Case Upper(Alltrim(_cTipo)) == "DEMIS"
		/*
		If _xConteudo <= dDatFech
			_lRet := .F.
			MsgStop("Não é permitido a Data de Apontamento anterior a Data do Ultimo Fechamento de Estoque.","Atenção!")
		EndIf
		*/
	Case Upper(Alltrim(_cTipo)) == "MATR"
		
		x_Barra := SUBS(_xConteudo,1,1)+SUBS(_xConteudo,8,1)
		
		IF ( !EMPTY(x_Barra) )

			IF ( x_Barra <> "99" )
				MsgStop("Erro de leitura no Codigo de Barras do Crachá.")
				_lRet := .f.
			ELSE	
				_xConteudo := SUBSTRING(_xConteudo,2,6)				
				dbSelectArea("SX5")
				dbSetOrder(1)
				dbSeek(xFilial("SX5")+"Z@"+_xConteudo)
				IF ( SX5->(EOF()) )
					MsgStop("Usuário não autorizado para executar esta rotina.","Atenção")
					_lRet := .f.
				ELSE	
					cOperI := SUBS(SX5->X5_DESCRI,3,2)
					cOperF := SUBS(SX5->X5_DESCRI,6,2)
					cSetor := SUBS(SX5->X5_DESCRI,1,2)
					cEdit6 := SUBS(SX5->X5_DESCRI,8,10)

					oEdit0:Disable()
					oEdit1:Enable()
					oEdit1:SetFocus()
				ENDIF
			ENDIF
		ENDIF
		
EndCase

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()      ³ Autor ³ Norbert Waage Junior  ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolução horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C(nTam)

//Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor

Do Case
	Case _nHRes == 640	//Resolucao 640x480
		nTam *= 0.8
	Case _nHRes == 800	//Resolucao 800x600
		nTam *= 1
	OtherWise			//Resolucao 1024x768 e acima
		nTam *= 1.28
EndCase

If (_cTheme == "FLAT") .Or. _lMdiChild
	nTam *= 0.90
EndIf

Return Int(nTam)