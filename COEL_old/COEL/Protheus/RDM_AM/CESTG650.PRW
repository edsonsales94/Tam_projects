/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CESTG650 º Autor ³ Carlos Nina        º Data ³  19/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Gera Ordem de Producao a partir de Planilha Eletronica     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#DEFINE CGETFILE_TYPE GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE

User Function CESTG650()

Local   aStru
Local   cNumOP
Local   opDlg,oMark,oPlanilha
Local   lInverte := .F.
Local   cMarca   := GetMark()
Local   aCampos  := {}

Private aSav651   := Array(24)
Private lSair     := .F.
Private lProcess  := .F.
Private cPlanilha := SPACE(150)
Private mPlanilha := cPlanilha
Private nTotItens := 0
Private nOpcA     := 0
Private mvLocal   := IIF(M->cNumEmp=="0301","02","01")
Private aC6OP     := {}

aStru := {}
AADD(aStru,{"TB_OK"      , "C" , 02 , 0 } )
AADD(aStru,{"TB_NUM"     , "C" , 06 , 0 } )
AADD(aStru,{"TB_ITEM"    , "C" , 02 , 0 } )
AADD(aStru,{"TB_ENTREG"  , "D" , 08 , 0 } )
AADD(aStru,{"TB_PRODUTO" , "C" , 30 , 0 } )
AADD(aStru,{"TB_DESCRI"  , "C" , 50 , 0 } )
AADD(aStru,{"TB_SDOSC6"  , "N" , 12 , 0 } )
AADD(aStru,{"TB_SDOSB2"  , "N" , 12 , 0 } )
AADD(aStru,{"TB_SDOPLA"  , "N" , 12 , 0 } )
AADD(aStru,{"TB_CLIENTE" , "C" , 06 , 0 } )
AADD(aStru,{"TB_LOJA"    , "C" , 02 , 0 } )
AADD(aStru,{"TB_CLNOMCL" , "C" , 20 , 0 } )
AADD(aStru,{"TB_CLPARC"  , "C" , 01 , 0 } )
AADD(aStru,{"TB_CLANTE"  , "C" , 01 , 0 } )
AADD(aStru,{"TB_CLATEND" , "C" , 20 , 0 } )
AADD(aStru,{"TB_OBSERV"  , "C" , 30 , 0 } )
AADD(aStru,{"TB_OBS2"    , "C" , 02 , 0 } )
AADD(aStru,{"TB_PROGRAM" , "C" , 10 , 0 } )
AADD(aStru,{"TB_RECNO"   , "N" , 07 , 0 } )
cCriaTrab := CriaTrab(aStru,.T.)
dbUseArea(.T.,,cCriaTrab,"TRB",.F.,.F.)
*
AADD(aCampos , { "TB_OK"      ,  , "Ok"           , } )
AADD(aCampos , { "TB_NUM"     ,  , "Pedido"       , } )
AADD(aCampos , { "TB_ITEM"    ,  , "Item"         , } )
AADD(aCampos , { "TB_ENTREG"  ,  , "Dt.Entrega"   , } )
AADD(aCampos , { "TB_PRODUTO" ,  , "Produto"      , } )
AADD(aCampos , { "TB_DESCRI"  ,  , "Descrição"    , } )
AADD(aCampos , { "TB_SDOPLA"  ,  , "Qtde.Planilha"  , "@E 999999" } )
AADD(aCampos , { "TB_SDOSC6"  ,  , "Saldo Pedido"   , "@E 999999" } )
AADD(aCampos , { "TB_SDOSB2"  ,  , "Saldo Fisico"   , "@E 999999" } )
AADD(aCampos , { "TB_CLNOMCL" ,  , "Cliente"      , } )
AADD(aCampos , { "TB_CLPARC"  ,  , "Parcial?"     , } )
AADD(aCampos , { "TB_CLANTE"  ,  , "Antecipado?"  , } )
AADD(aCampos , { "TB_CLATEND" ,  , "Atendente"    , } )
AADD(aCampos , { "TB_OBSERV"  ,  , "Observação"   , } )
*
AADD(aC6OP , { "01" , "OP já foi gerada              " } )
AADD(aC6OP , { "02" , "Pedido Liberado p/Fat. sem OP " } )
AADD(aC6OP , { "03" , "Pedido Liberado p/Faturamento " } )
AADD(aC6OP , { "04" , "Pedido c/Bloqueio de Crédito  " } )
AADD(aC6OP , { "05" , "Produto Disponivel em Estoque " } )
AADD(aC6OP , { "06" , "Pedido Liberado p/Faturamento " } )
AADD(aC6OP , { "07" , "Pedido c/Bloqueio de Estoque  " } )
AADD(aC6OP , { "08" , "Pedido Liberado p/Faturamento " } )

///Pergunte("MTA651    ",.T.)

dbSelectArea("SB1")
dbSetOrder(1)
*
dbSelectArea("SB2")
dbSetOrder(1)
*
dbSelectArea("SC5")
dbSetOrder(1)
*
dbSelectArea("SC6")
dbSetOrder(1)
*
dbSelectArea("TRB")
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 065,000 To 636,1157 Dialog opDlg Title OemToAnsi("Gera Ordem de Produção via Planilha Eletrônica")
@ 001,003 To 030,506 Title OemToAnsi("Parametros")
@ 036,003 To 264,567 Title OemToAnsi("Pedidos a processar")  
@ 008,005 Say OemToAnsi("Nome da Planilha")                                Size 51,7
@ 016,005 Get cPlanilha                     Picture "@!"                   Size 300,10  Object oPlanilha Valid MsAguarde({||fl_PedXls(cMarca,oMark)},'Extraindo itens do Pedido de Vendas','Aguarde...')
@ 008,325 Say OemToAnsi("OP Inicial")                                      Size 41,7
@ 016,325 Get cNumOP                        Picture "@!"                   Size 50,10  

oMark := MsSelect():New("TRB","TB_OK",,aCampos,@lInverte,@cMarca,{044,006,262,564},,opDlg) 
oMark:bMark := { || fl_markk(cMarca) }     

@ 005,512 Button OemToAnsi("Confirma _Pedidos")                               Size 55,12 Action ( nOpcA := 1 , lSair := .T. , opDlg:End() )
@ 025,512 Button OemToAnsi("Cance_la Pedidos")                                Size 55,12 Action fl_Cancela(opDlg)                  

Activate Dialog opDlg CENTER Valid lSair

IF ( nOpcA == 1 )
	dbSelectArea("SC2")
	dbSetOrder(1)
	dbSeek(xFilial("SC2")+"ZZZZZZ",.T.)
	dbSkip(-1)

	cNumOP := IIF(BOF() , "000001" , SOMA1(SC2->C2_NUM) )

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
			SC6->C6_PROGRAM := "G650"
			SC6->C6_OK      := cMarca
			MsUnlock()
			dbSelectArea("TRB")
		ENDIF
		dbSkip()
	ENDDO
	Private cOp    := "" 
	Private cSeqC2 := "000"
	
	inclui := .T.
	cOP    := "04/07/"+Space(Len(SC6->C6_OP))
	//Salvar variaveis existentes
	Pergunte("MTA651    ",.F.)
	For ni := 1 to 24
		aSav651[ni] := &("mv_par"+StrZero(ni,2))
		IF ( ni == 13 )
			aSav651[ni] := cNumOP
		ENDIF
	Next ni
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existencia de indice no SC6                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("MTA650    ",.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Execblock a ser executado antes da Indregua                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (ExistTemplate('MA650FIL'))
		cFilA650 := ExecTemplate('MA650FIL',.F.,.F.)
	EndIf

	If (ExistBlock('MA650FIL'))
		cFilA650 := ExecBlock('MA650FIL',.F.,.F.)
	EndIf
	
	cCondicao := "RTRIM(C6_PROGRAM) == 'G650' "
	
	Processa({|lEnd| A650GeraOP(@lEnd,"SC6","C6_OK",SC6->(RECNO()),cMarca,lInverte)},OemToAnsi("Geração de OP's"),OemToAnsi("Gerando OP's..."),.F.) 

	////
	////Libera filtro do Pedido de Vendas
	////
	dbSelectArea("SC6")
	RetIndex("SC6")
	dbClearFilter()		

	dbSelectArea("TRB")
	dbGoTop()
	DO WHILE !EOF()
		IF ( IsMark("TB_OK") )
			dbSelectArea("SC6")
			dbGoTo(TRB->TB_RECNO)
			RecLock("SC6",.F.)
			SC6->C6_PROGRAM := TRB->TB_PROGRAM
			MsUnlock()
			dbSelectArea("TRB")
		ENDIF
		dbSkip()
	ENDDO
	
ENDIF

TRB->(dbCloseArea())

Return

//////////////////////////////////////////////////////
Static Function fl_markk(cMarca)
//////////////////////////////////////////////////////
Local xMarca := TRB->TB_OK
Local lMark  := IsMark("TB_OK")
Local lRsp   := .F.

IF ( !EMPTY(TRB->TB_NUM) )
	IF ( lMark )
		IF ( TRB->TB_OBS2 == "00" )
			lRsp := .T.
			nTotItens++
		ENDIF
	ELSE
		IF ( TRB->TB_OBS2 == "00" )
			lRsp := .T.
			nTotItens--
		ENDIF	
	ENDIF	
	RecLock("TRB",.F.)
	TRB->TB_OK := IIF(!lRsp , IIF(lMark , "" , cMarca ) , xMarca )
	MsUnlock()
ENDIF

Return(lRsp)

////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fl_Cancela(opDlg)
////////////////////////////////////////////////////////////////////////////////////////////////////////
Local lRsp := .T.

IF ( lProcess )
	lRsp := MsgBox("Deseja realmente cancelar o processo de Gerar OP via Planilha?","Escolha a opção","YESNO")
ENDIF

IF ( lRsp )
	lSair := .T.
	opDlg:End()
ENDIF

Return(lRsp)

/////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fl_PedXls(cMarca,oMark)
/////////////////////////////////////////////////////////////////////////////////////////////////////////
Local cxLinha,cxPedido,cxItem,cxCodigo,cxDescri
Local nxQuant,nxPrcME,nxPrcBR,nxTotal,nZ
Local nxSeq     := 0
Local cQuebra   := Chr(13) + Chr(10)
Local nMaskDef	 := 1 								// Mascara .TXT
Local cTipo     := "Marcação (*.CSV)        | *.CSV | "
Local cTipo     := cTipo + "Todos os Arquivos (*.*)   | *.*     "
Local cxPath    := "C:\"
Local cArq      := cPlanilha

IF ( EMPTY(cArq).OR.cArq<>mPlanilha )
	
	IF ( !FILE(cArq) )
		cArq := cGetFile( cTipo,"Selecione arquivo...",@nMaskDef    , cxPath , .T. , CGETFILE_TYPE )
	ENDIF
	cPlanilha := cArq
	mPlanilha := cArq
	IF ( EMPTY(cPlanilha) )
		Return
	ENDIF

	aArqTemp := U_CCONVCSV("1" , RTRIM(cArq) , "PVENDAS.txt" , "TempPV.txt" )

	IF ( !EMPTY(aArqTemp[1]) )
      ///PEDIDO;ITEM;CODIGO                        ;QUANTIDADE
		dbSelectArea("TRB")
		dbGoTop()
		IF ( !EOF() )
			 __dbZap()
		ENDIF
		
		Ft_fuse(aArqTemp[1])
		ft_fgotop()
		ProcRegua(500)
		DO WHILE !ft_feof()
			cxLinha  := StrTran(ft_freadln(), cQuebra, "")
			cxPedido := SUBS(cxLinha,1,6)
			cxItem   := SUBS(cxLinha,7,2)
			cxCodigo := SUBS(cxLinha,9,30)
			nxQuant  := VAL( SUBS(cxLinha,39,10) )
			
			IF ( !EMPTY(cxCodigo) )
				SC5->(dbSeek(xFilial("SC5")+cxPedido))
				SC6->(dbSeek(xFilial("SC6")+cxPedido+cxItem+cxCodigo))
				SB1->(dbSeek(xFilial("SB1")+cxCodigo))
				SB2->(dbSeek(xFilial("SB2")+cxCodigo+mvLocal))
				
				aObserv := {"","00"}
				IF ( SC5->(EOF()) )
					aObserv := { "** Pedido não cadastrado." , "99" }
				ELSEIF ( SC6->(EOF()) )
					aObserv := { "** Pedido/Item não cadastrado." , "99" }
				ELSEIF ( ( SC6->C6_QTDVEN - SC6->C6_QTDENT ) <= 0 )
					aObserv := { "** Pedido já atendido." , "99" }
				ELSEIF ( SC5->C5_BLQ == "1" )
					aObserv := { "-- Pedido Bloqueado por Regra." , "00" }
				ENDIF	
				IF ( aObserv[2]=="00" )
					nZ := ASCAN(aC6OP , { |xx| xx[1] == SC6->C6_OP } )
					IF ( nZ > 0 )
						aObserv := { aC6OP[nZ,2] , "99" }
					ENDIF
				ENDIF
				
				RecLock("TRB",.T.)
				TRB->TB_OK      := IIF(aObserv[2]=="00" , cMarca , " " )
				TRB->TB_NUM     := cxPedido
				TRB->TB_ITEM    := cxItem
				TRB->TB_PRODUTO := cxCodigo
				TRB->TB_DESCRI  := SC6->C6_DESCRI
				TRB->TB_ENTREG  := SC6->C6_ENTREG
				TRB->TB_SDOPLA  := nxQuant
				TRB->TB_CLIENTE := SC6->C6_CLI
				TRB->TB_LOJA    := SC6->C6_LOJA
				TRB->TB_CLNOMCL := SC5->C5_CLNOMCL
				TRB->TB_CLPARC  := SC5->C5_CLPARC
				TRB->TB_CLATEND := SC5->C5_CLATEND
				TRB->TB_CLANTE  := SC5->C5_CLANTE
				TRB->TB_SDOSB2  := SB2->B2_QATU
				TRB->TB_SDOSC6  := ( SC6->C6_QTDVEN - SC6->C6_QTDENT )
				TRB->TB_OBSERV  := aObserv[1]
				TRB->TB_OBS2    := aObserv[2]
				TRB->TB_RECNO   := SC6->(RECNO())
				MsUnlock()

				nTotItens := IIF(aObserv[2]=="99" , nTotItens , ( nTotItens + 1 ) )
				
			ENDIF
			ft_fskip()
		ENDDO	
		ft_fuse()
	
		oMark:oBrowse:Refresh()
		oMark:oBrowse:GoTop()
		oMark:oBrowse:SetFocus()
		
		lProcess := .T. 
		
	ENDIF
	
ENDIF	

Return