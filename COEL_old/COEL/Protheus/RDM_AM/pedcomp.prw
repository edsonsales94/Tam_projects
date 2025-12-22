/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CCOMG010 º Autor ³ Carlos Nina        º Data ³  03/02/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Geracao do Pedido de Compra a partir do BD Guardian        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "protheus.ch"
#include "rwmake.ch"
#include "font.ch"
#include "totvs.ch"
#Include "TOPCONN.CH"
//#include "totvsweb.ch" 
//#include "tbiconn.ch" 

User Function pedcomp()

Private oPeso,oPesoIni,oPesoFin,oPesoLiq,oProduto,oFornece,oLoja,oTransp,oDesc,oPlaca,oEmissao,oPedido,oDesTran,oStatus,oRazSoc,oPrint,oObserv
Private oDlg,oMainWnd,oButton1,oButton2,oButton3,oButton4,oButton5,oGroup0,oGroup1,oGroup2,oTBitmap1,oTBitmap2,oTBitmap3,oTBitmap4,oTBitmap5,oTBitmap6,oTBitmap7,oTBar

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MV_PAR01 := 1
MV_PAR02 := 2

Private lSair     := .F.
Private lTicket   := .F.
Private lHistPed  := .F.
Private lGrvPed   := .F.
Private cPedido   := Space(6)
Private dEmissao  := MsDate()
Private mEmissao  := dEmissao
Private cStatus   := "Efetuar pesagem...  "+space(31)
Private cPeso     := space(12)
Private nPesoIni  := 0
Private nPesoFin  := 0
Private nPesoLiq  := 0
Private n_PesoI   := 0
Private n_PesoF   := 0
Private n_PesoL   := 0
Private n_PesoLC  := 0
Private c_Status  := " "
Private c_Chave   := SPACE(8)
Private c_Sequen  := SPACE(6)
Private c_HoraI   := SPACE(8)
Private c_HoraF   := SPACE(8)
Private cTransp   := Space(4)
Private cDesTran  := Space(40)
Private cPlaca    := Space(7)
Private mPlaca    := Space(7)
Private cFornece  := Space(6)
Private cLoja     := Space(02)
Private cRazSoc   := Space(40)
Private cProduto  := Space(15)
Private cDesc     := Space(30)   
Private cObserv   := Space(40)
Private cPerg     := "CCOMG010  "
Private cMarca    := GetMark()

//ValidPerg()

//pergunte(cPerg,.F.)
*
dbSelectArea("SA2")
dbSetOrder(1)
*
dbSelectArea("SB1")
dbSetOrder(1)
*
dbSelectArea("SA4")
dbSetOrder(1)
*
dbSelectArea("SA5")
dbSetOrder(2)
*
DEFINE FONT oFnt  NAME "Arial" Size 10,17             ///LARG. X ALT.
DEFINE FONT oFnt2 NAME "Arial" Size 10,11
DEFINE FONT oFnt3 NAME "Arial" Size 10,12
DEFINE FONT oFnt4 NAME "Arial" Size 10,34
DEFINE FONT oFnt5 NAME "Arial" Size 12,66
DEFINE FONT oFnt6 NAME "Arial" Size 9,12

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE OemToAnsi("Balança :: Pedido de Compra") From 000,000 To 16,095 OF oMainWnd

///@ 017, 000 GROUP oGroup0 TO 019, 378 PROMPT ""                                               OF oDlg PIXEL                    
@ 021, 002 GROUP oGroup1 TO 121, 374 PROMPT "Dados do Pedido"                                OF oDlg PIXEL                    
@ 075, 205 GROUP oGroup1 TO 099, 370 PROMPT "Observação"                                     OF oDlg PIXEL                    
@ 030,006 Say OemToAnsi("Placa do Veiculo")                                      Size 42,7   PIXEL OF oDlg
@ 030,056 Say OemToAnsi("Data Emissão")                                          Size 38,7   PIXEL OF oDlg
@ 030,205 Say OemToAnsi("Num.Pedido")                                            Size 40,7   PIXEL OF oDlg
@ 030,240 Say OemToAnsi("Status")                                                Size 16,7   PIXEL OF oDlg
@ 052,006 Say OemToAnsi("Transportador")                                         Size 38,7   PIXEL OF oDlg
@ 052,205 Say OemToAnsi("Pesagem Inicial (Kg)")                                  Size 50,7   PIXEL OF oDlg
@ 052,264 Say OemToAnsi("Pesagem Final (Kg)")                                    Size 47,7   PIXEL OF oDlg
@ 052,320 Say OemToAnsi("Peso Liquido (Kg)")                                     Size 50,7   PIXEL OF oDlg
@ 075,006 Say OemToAnsi("Fornecedor")                                            Size 30,7   PIXEL OF oDlg
@ 075,043 Say OemToAnsi("Loja")                                                  Size 13,7   PIXEL OF oDlg
@ 075,062 Say OemToAnsi("Razão Social")                                          Size 34,7   PIXEL OF oDlg
@ 097,006 Say OemToAnsi("Produto")                                               Size 20,7   PIXEL OF oDlg
@ 097,062 Say OemToAnsi("Descrição")                                             Size 26,7   PIXEL OF oDlg
@ 037,006 MsGet oPlaca        Var cPlaca                Picture "@R !!!-9999"    Size 30,10  OF oDlg PIXEL  VALID f_Placa()
@ 037,056 MsGet oEmissao      Var dEmissao                                       Size 35,10  OF oDlg PIXEL  VALID f_Emissao()
//@ 026,140 Say oPeso  VAR cPeso                                                   Size 80,34  PIXEL OF oDlg                       FONT oFnt5  COLOR 32768,0    
@ 037,205 MsGet oPedido       Var cPedido                                        Size 27,10  OF oDlg PIXEL                       WHEN .F.       
@ 037,240 Say   oStatus       Var cStatus                                        Size 130,12 PIXEL OF oDlg                       FONT oFnt6  COLOR 16711680,0
@ 060,006 MsGet oTransp       Var cTransp               F3 "SA4"                 Size 25,10  OF oDlg PIXEL                       WHEN .F.      
@ 060,039 MsGet oDesTran      Var cDesTran                                       Size 100,10 OF oDlg PIXEL                       WHEN .F.
@ 060,205 MsGet oPesoIni      Var nPesoIni              Picture "@E 9999999.9"   Size 40,10  OF oDlg PIXEL                       WHEN .F.
@ 060,264 MsGet oPesoFin      Var nPesoFin              Picture "@E 9999999.9"   Size 40,10  OF oDlg PIXEL                       WHEN .F.
@ 060,320 MsGet oPesoLiq      Var nPesoLiq              Picture "@E 9999999.9"   Size 40,10  OF oDlg PIXEL                       WHEN .F.
@ 082,006 MsGet oFornece      Var cFornece              F3 "SA2"                 Size 30,10  OF oDlg PIXEL                       WHEN .F.      
@ 082,043 MsGet oLoja         Var cLoja                                          Size 12,10  OF oDlg PIXEL                       WHEN .F.      
@ 082,062 MsGet oRazSoc       Var cRazSoc                                        Size 125,10 OF oDlg PIXEL                       WHEN .F.
@ 083,209 MsGet oObserv       Var cObserv                                        Size 160,10 OF oDlg PIXEL                      
@ 104,006 MsGet oProduto      Var cProduto              F3 "SB1"                 Size 50,10  OF oDlg PIXEL                       WHEN .F.      
@ 104,062 MsGet oDesc         Var cDesc                                          Size 125,10 OF oDlg PIXEL                       WHEN .F.

oTBar := TBar():New( oDlg,40,45,.T.,,,,.F. ) 

oTBitmap1 := TBtnBmp2():New( 00, 00, 35, 25,"p_pesagem" , , , ,;
                IIF(EMPTY(cPeso) , {|| f_cappeso("P") } , {||nil} ) ,oTBar,'Captura peso',,.F.,.F.)
oTBitmap2 := TBtnBmp2():New( 00, 00, 35, 25, 'p_cancela' ,,,,;
               {|| f_cancela() }  ,oTBar,'Cancela pesagem',,.F.,.F.)
oTBitmap3 := TBtnBmp2():New( 00, 00, 35, 25, 'button_ok1' ,,,,;
               {|| f_pesagem() }  ,oTBar,'Confirma pesagem',,.F.,.F.)
oTBitmap4 := TBtnBmp2():New( 00, 00, 35, 25, 'button_print' ,,,,;
               {|| f_ticket() }  ,oTBar,'Emite ticket',,.F.,.F.)
oTBitmap5 := TBtnBmp2():New( 00, 00, 35, 25, 'button_cfg2' ,,,,;
               {|| Pergunte(cPerg,.T.) }  ,oTBar,'Parametros',,.F.,.F.)
oTBitmap6 := TBtnBmp2():New( 00, 00, 35, 25, 'button_exit' ,,,,;
               {|| lSair := .T. , oDlg:End() }  ,oTBar,'Sair',,.F.,.F.)

				
/*
oTBitmap1 := TBitmap():New(002,004,12,12,,"\system\p_pesagem.bmp",.T.,oDlg,;
                IIF(EMPTY(cPeso) , {|| f_cappeso("P") } , {||nil} ) ,,.F.,.F.,,,.F.,,.T.,,.F.)
oTBitmap1:lAutoSize := .T.  
//oTBitmap2 := TBitmap():New(002,034,12,12,,"\system\p_sai.bmp",.T.,oDlg,;
//                IIF(EMPTY(cPeso) , {|| f_cappeso("F","P") } , {||nil} ) ,,.F.,.F.,,,.F.,,.T.,,.F.)
//oTBitmap2:lAutoSize := .T.  
oTBitmap7 := TBitmap():New(002,068,12,12,,"\system\p_cancela.bmp",.T.,oDlg,;   
                {|| f_cancela() },,.F.,.F.,,,.F.,,.T.,,.F.)
oTBitmap7:lAutoSize := .T.  
oTBitmap3 := TBitmap():New(002,088,12,12,,"\system\button_ok1.bmp",.T.,oDlg,;   
                {|| f_pesagem() } ,,.F.,.F.,,,.F.,,.T.,,.F.)
                ///IIF(!EMPTY(cPeso) , {|| f_pesagem() } , {||nil} ) ,,.F.,.F.,,,.F.,,.T.,,.F.)
oTBitmap3:lAutoSize := .T.  
oTBitmap4 := TBitmap():New(002,116,12,12,,"\system\button_print.bmp",.T.,oDlg,;
                {|| f_ticket() } ,,.F.,.F.,,,.F.,,.T.,,.F.)
                ///IIF(!EMPTY(cPlaca).AND.!EMPTY(dEmissao) , {|| f_ticket() } , {||nil} ) ,,.F.,.F.,,,.F.,,.T.,,.F.)
oTBitmap4:lAutoSize := .T.  
oTBitmap5 := TBitmap():New(002,142,12,12,,"\system\button_cfg2.bmp",.T.,oDlg,;
                {|| nil },,.F.,.F.,,,.F.,,.T.,,.F.)
oTBitmap5:lAutoSize := .T.  
oTBitmap6 := TBitmap():New(002,168,12,12,,"\system\button_exit.bmp",.T.,oDlg,;   
                {|| Close(oDlg) },,.F.,.F.,,,.F.,,.T.,,.F.)
oTBitmap6:lAutoSize := .T.  
*/

Activate Dialog oDlg CENTER Valid lSair

Return

///////////////////////////////////////
Static Function f_Cancela()
///////////////////////////////////////
Local lRsp := .T.

	IF ( !EMPTY(cPeso) )
		
		lRsp := IIF(lGrvPed , .T. , MsgYesNo("Existe uma confirmação de pesagem a ser efetuada. Deseja descartar essa pesagem?","Escolha a opção") )
		
		IF ( lRsp )
		   cPlaca   := space(7)
			mPlaca   := cPlaca
			dEmissao := MsDate()
			mEmissao := dEmissao
			cPeso    := space(15)
			cPedido  := space(6)
         cFornece := Space(6)
         cLoja    := Space(02)
         cRazSoc  := Space(40)
         cProduto := Space(15)
         cDesc    := Space(30)
			cTransp  := Space(4)
			cDesTran := Space(40)
			cObserv  := Space(40)
			nPesoIni := 0
			nPesoFin := 0
			nPesoLiq := 0
			lHistPed := .F.
			lGrvPed  := .F.
			cStatus  := "Efetuar pesagem...  "+space(31)
			oPlaca:SetFocus()
			oStatus:Refresh()
		ENDIF
	ENDIF

Return(lRsp)

///////////////////////////////////////
Static Function f_Placa()
///////////////////////////////////////
Local lRsp := .T.

IF ( cPlaca <> mPlaca )
	IF ( !EMPTY(cPeso) )
		
		lRsp := IIF(lGrvPed , .T. , MsgYesNo("Existe uma confirmação de pesagem a ser efetuada. Deseja descartar essa pesagem?","Escolha a opção") )
		
		IF ( lRsp )
			cPeso    := space(15)
			cPedido  := space(6)
         cFornece := Space(6)
         cLoja    := Space(02)
         cRazSoc  := Space(40)
         cProduto := Space(15)
         cDesc    := Space(30)
			cTransp  := Space(4)
			cDesTran := Space(40)
			cObserv  := Space(40)
			nPesoIni := 0
			nPesoFin := 0
			nPesoLiq := 0
			lHistPed := .F.
			lGrvPed  := .F.
			cStatus  := "Efetuar pesagem...  "+space(31)
			oStatus:Refresh()
		ENDIF
	ENDIF
	IF ( lRsp )
		mPlaca := cPlaca
	ENDIF
ENDIF

Return(lRsp)

///////////////////////////////////////
Static Function f_Emissao()
///////////////////////////////////////
Local lRsp := .T.

IF ( dEmissao <> mEmissao )
	IF ( !EMPTY(cPeso) )

		lRsp := IIF(lGrvPed , .T. , MsgYesNo("Existe uma confirmação de pesagem a ser efetuada. Deseja descartar essa pesagem?","Escolha a opção") )
		
		IF ( lRsp )
			cPeso    := space(15)
			cPedido  := space(6)
         cFornece := Space(6)
         cLoja    := Space(02)
         cRazSoc  := Space(40)
         cProduto := Space(15)
         cDesc    := Space(30)
			cTransp  := Space(4)
			cDesTran := Space(40)
			cObserv  := Space(40)
			nPesoIni := 0
			nPesoFin := 0
			nPesoLiq := 0
			lHistPed := .F.
			lGrvPed  := .F.
			cStatus  := "Efetuar pesagem...  "+space(31) 
			oStatus:Refresh()		
		ENDIF
	ENDIF
	IF ( lRsp )
		mEmissao := dEmissao
	ENDIF	
ENDIF

Return(lRsp)

///////////////////////////////////////
Static Function f_Pesagem()
///////////////////////////////////////
Local lRsp
                
IF ( EMPTY(cPeso) )
	MsgStop("** Falta capturar o peso.")
   Return
ENDIF
   
IF ( EMPTY(cPlaca).OR.EMPTY(dEmissao) ) 
	MsgStop("** Falta o preenchimento de Placa e/ou Dt.Emissão.")
	Return
ELSEIF ( LEFT(cStatus,1) == "1" )
	MsgStop("-- Confirmação somente na 2a. pesagem.")
	Return
ELSEIF ( lGrvPed ) 
	Return
ENDIF

lRsp := MsgYesNo("Confirma a pesagem?","Escolha a opção")
		
IF ( lRsp )
	SA2->(dbSeek(xFilial("SA2")+cFornece+cLoja))
	SA4->(dbSeek(xFilial("SA4")+cTransp))
	SA5->(dbSeek(xFilial("SA5")+cProduto+cFornece+cLoja))
	SB1->(dbSeek(xFilial("SB1")+cProduto))
	
	nPreco := IIF(SA5->(!EOF()).AND.SA5->A5_YPRECO > 0 , SA5->A5_YPRECO , SB1->B1_CUSTD )

	IF ( nPreco <= 0 )
		MsgStop("** Pedido não pode ser gerado. Falta cadastrar preço para o Produto/Fornecedor.")
		Return	
	ENDIF
	
	////
	////Grava Historico de Pedido (SCY)
	////
	lRsp := f_GravaPC1("I",nil,n_PesoI,n_PesoF,n_PesoL,n_PesoLC,nPreco)        ///1a. Pesagem
	IF ( lRsp )
		MsgStop("** Não foi possivel efetuar o processo de gerar o Historico de Pedido (Seq.0001) no Protheus. Favor comunicar ao Responsavel de T.I antes de continuar.")
	ELSE
		lRsp := f_GravaPC1("F",cPedido,n_PesoI,n_PesoF,n_PesoL,n_PesoLC,nPreco)    ///2a. Pesagem
		IF ( lRsp )
			MsgStop("** Não foi possivel efetuar o processo de gerar o Historico de Pedido (Seq.0002) no Protheus. Favor comunicar ao Responsavel de T.I antes de continuar.")
		ENDIF	
	ENDIF	
	IF ( !lRsp )
		////
		////Grava Pedido de Compra
		////
		lRsp := f_GravaPC2(cPedido,n_PesoI,n_PesoF,n_PesoL,n_PesoLC,nPreco)
		IF ( lRsp )
			MsgStop("** Não foi possivel efetuar o processo de gerar o Pedido de Compra no Protheus. Favor comunicar ao Responsavel de T.I antes de continuar.")
		ELSE
			lGrvPed := .T.
			cStatus := "Emitir Ticket ou efetuar nova pesagem.  "+space(11)  
			oStatus:Refresh()
		ENDIF
	ENDIF	
ENDIF	

Return

///////////////////////////////////////
Static Function f_Ticket()
///////////////////////////////////////
Local lRsp 

IF ( EMPTY(cPlaca) .OR. EMPTY(dEmissao) )
	MsgInfo("-- Falta informar Placa ou Data Emissão.")
	Return
ENDIF	

lRsp := IIF(EMPTY(cPeso) , f_cappeso("T") , .T. )

IF ( lRsp )
	IF ( c_Status == "F" )
		MsAguarde( { || fp_Ticket("R") } , "Imprimindo Ticket..." )
	ELSE
		MsgStop("Pesagem ainda não concluida p/o veiculo na data informada ou parametros de placa/emissão invalidos.")
	ENDIF
ELSE
	MsgInfo("** Problema ocorrido na emissão do Ticket. Favor comunicar ao responsavel de T.I.")
ENDIF	

Return

////////////////////////////////////////////////////////
Static Function f_cappeso(x_Opcao)
////////////////////////////////////////////////////////
Local mError,lQuery
Local nError    := 0
Local aTempor   := {}
Local lFlagPeso := ( mv_par01 == 1 .AND. x_Opcao == "P" ).OR.( mv_par02 == 1 .AND. x_Opcao == "T" )         
         
			IF ( EMPTY(cPlaca) .OR. EMPTY(dEmissao) )
				MsgInfo("-- Falta informar Placa ou Data Emissão.")
				Return
			ENDIF
			
			SET CENTURY ON
			x_Emissao := DTOC(dEmissao)
			SET CENTURY OFF
			/*
			IF ( !lFlagPeso )
				cQuery := "SELECT TOP 1 tick_pesoinicial PESOINI,tick_pesofinal PESOFIM,tick_pesoliquido PESOLIQ,tick_liquidocorrigido PESOLC,tick_sequencial SEQUENC,"
			ELSE
				cQuery := "SELECT tick_pesoinicial PESOINI,tick_pesofinal PESOFIM,tick_pesoliquido PESOLIQ,tick_liquidocorrigido PESOLC,tick_sequencial SEQUENC,"
			ENDIF
			cQuery += "tick_status TSTATUS,tick_chave CHAVE,CONVERT(CHAR(10),tick_dthrpesoinicial,108) HORAI,CONVERT(CHAR(10),tick_dthrpesofinal,108) HORAF,"
			cQuery += "tick_memoobs OBSERV,tick_codtransportadora TRANSP,tick_codemissor FORNECE,tick_coditem PRODUTO,"
			cQuery += "tick_razsoctrans DESTRAN,tick_razsocemissor RAZSOC,tick_descricaoitem DESCITEM"
			cQuery += " FROM GUARDIANTESTE.DBO.REGTICK"    
			cQuery += " WHERE tick_placacarreta = '"+cPlaca+"'"
			cQuery += " AND tick_balpesoinicial = 'B_ENTRADA'"                            ////B_ENTRADA = Recebimento; B_SAIDA = Faturamento
			//cQuery += " AND LEFT(CAST(tick_dthrpesoinicial as varchar),11) = 'Feb 25 2012'"
			cQuery += " AND CONVERT(CHAR(10),tick_dthrpesoinicial,103) = '"+x_Emissao+"'"
			cQuery += " AND tick_status IN ('I','F')"  
			cQuery += " ORDER BY tick_chave DESC "
			
			nError := TCSQLEXEC(cQuery)			
			*/
			IF ( nError == 0 )
				/*
				cQry := ChangeQuery(cQuery)

				dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)
			
				TcSetField("TMP","PESOINI","N",11,0)
				TcSetField("TMP","PESOFIM","N",11,0)
				TcSetField("TMP","PESOLIQ","N",11,0)
				TcSetField("TMP","PESOLC","N",11,0)
				TcSetField("TMP","CHAVE","N",8,0)
				
				dbSelectArea("TMP")
				dbGoTop()
				DO WHILE !EOF()
					AADD(aTempor , {  RTRIM(TMP->TSTATUS)            , ;
											TMP->PESOINI                   , ;
											TMP->PESOFIM                   , ;
											TMP->PESOLIQ                   , ;
											TMP->PESOLC                    , ;
											TMP->HORAI                     , ;
											TMP->HORAF                     , ;
											TMP->SEQUENC                   , ;
											TMP->OBSERV                    , ;
											SUBS(TMP->FORNECE,2,6)         , ; 
											LEFT(TMP->TRANSP,6)            , ;
											LEFT(TMP->PRODUTO,9)+space(6)  , ;
											TMP->RAZSOC                    , ;
											TMP->DESTRAN                   , ;
											TMP->DESCITEM                  , ;
											TMP->CHAVE    } )
					dbSkip()
				ENDDO
				TMP->(dbCloseArea())
				*/
					AADD(aTempor , {  "F"                            , ;
											13480                          , ;
											10360                          , ;
											3120                           , ;
											3120                           , ;
											"06:40:12"                       , ;
											"08:00:36"                       , ;
											"050362"                       , ;
											"TESTE"                        , ;
											"000433"                       , ; 
											"001"                          , ;
											"RS---06068"                   , ;
											"FORNECEDOR TESTE"             , ;
											"LOCAL"                        , ;
											"PLACA DE CIRCUITO"            , ;
											586890        } )
					AADD(aTempor , {  "F"                            , ;
											12480                          , ;
											10360                          , ;
											2120                           , ;
											2120                           , ;
											"12:40:12"                       , ;
											"14:00:36"                       , ;
											"050366"                       , ;
											"TESTE"                        , ;
											"000433"                       , ; 
											"001"                          , ;
											"RS---06068"                   , ;
											"FORNECEDOR TESTE"             , ;
											"LOCAL"                        , ;
											"PLACA DE CIRCUITO"            , ;
											586895        } )
					AADD(aTempor , {  "F"                            , ;
											10380                          , ;
											8050                           , ;
											2070                           , ;
											2070                           , ;
											"16:52:12"                       , ;
											"18:02:38"                       , ;
											"050366"                       , ;
											"TESTE"                        , ;
											"000433"                       , ; 
											"001"                          , ;
											"RS---06068"                   , ;
											"FORNECEDOR TESTE"             , ;
											"LOCAL"                        , ;
											"PLACA DE CIRCUITO"            , ;
											586905        } )
				nIt := LEN(aTempor)       
				
				IF ( lFlagPeso.AND.nIt > 1 )
					nIt := f_SelSequenc(aTempor)       ///Seleciona a sequencia da pesagem na data informada
				ENDIF
				
				c_Status  := aTempor[nIt,1]
				n_PesoI   := aTempor[nIt,2]
				n_PesoF   := aTempor[nIt,3]
				n_PesoL   := aTempor[nIt,4]
				n_PesoLC  := aTempor[nIt,5]
				c_HoraI   := aTempor[nIt,6]
				c_HoraF   := aTempor[nIt,7]
				c_Sequen  := aTempor[nIt,8]       
				c_Observ  := aTempor[nIt,9]
				c_Fornece := aTempor[nIt,10]
				c_Transp  := aTempor[nIt,11]
				c_Produto := aTempor[nIt,12]
				c_RazSoc  := aTempor[nIt,13]
				c_DesTran := aTempor[nIt,14]
				c_Desc    := aTempor[nIt,15]
				n_Chave   := aTempor[nIt,16]		
				c_Chave   := STRZERO(n_Chave,8)
				
				SA2->(dbSeek(xFilial("SA2")+c_Fornece))
				SB1->(dbSeek(xFilial("SB1")+c_Produto))
				SA4->(dbSeek(xFilial("SA4")+c_Transp))
				
				lQuery := .T.
				*
				IF ( SA2->(EOF()) )
					MsgStop("** Código Fornecedor não cadastrado.")
					lQuery := .F.
				ENDIF
				IF ( SB1->(EOF()) )
					MsgStop("** Código Produto não cadastrado.")
					lQuery := .F.
				ENDIF
				IF ( SA4->(EOF()) )
					MsgStop("** Código Transportador não cadastrado.")
					lQuery := .F.
				ENDIF  
				
				nPesoIni := n_PesoI
				nPesoFin := n_PesoF
				nPesoLiq := n_PesoLC
				cTransp  := c_Transp
				cFornece := c_Fornece
				cProduto := c_Produto
				cObserv  := c_Observ
				cRazSoc  := c_Razsoc
				cDesTran := c_DesTran
				cDesc    := c_Desc				
				cLoja    := SA2->A2_LOJA
				
				IF ( !c_Status $ "IF" )
					cStatus := "Pesagem não efetuada p/o veiculo na data informada."
					lQuery  := .F.
				ENDIF	
				IF ( x_Opcao == "P" .AND. lQuery )                       ///Pesagem

					IF ( c_Status == "I" )
						cPeso    := TRANSF(n_PesoI,"@E 99999.9")
						nPesoIni := n_PesoI
						cStatus  := "1a. Pesagem."+space(39)
					ELSE	
						////
						////Verifica se já tem pedido gerado
						////
						dbSelectArea("SCY")
						dbSetOrder(16)                                           ///Criar indice: CY_EMISSAO+CY_YPLACA+CY_YCHAVE
						dbSeek(xFilial("SCY")+DTOS(dEmissao)+cPlaca+c_chave)
						lHistPed := SCY->(!EOF())
						cPeso    := TRANSF(n_PesoF,"@E 99999.9")
						*
						IF ( lHistPed )
							lGrvPed  := .T.
							cPedido  := SCY->CY_NUM        
							cStatus  := "Pesagem já concluida! Emissão do Ticket liberada.  "
						ELSE
							cStatus  := "2a. Pesagem... Confirmar pesagem.                  "
						ENDIF
					ENDIF	
				ENDIF
			ELSE
				
				lQuery := .F.
				mError := TcSqlError()
				
				nx := AT("(" , mError )
				IF ( nx = 0 )
					MsgStop("** Server: Sintaxe incorreta... ")
				ELSE
					cError := "Server: Msg" + SUBS(mError,8,(nx-7))
					nx     := AT("Line" , mError )
					mError := SUBS(mError,nx,100)
					nx     := AT("(" , mError )
					cError := cError + "... " + LEFT(mError,nx-1)
					MsgStop(cError)					
				ENDIF
			
			ENDIF

Return(lQuery)

////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_GravaPC1(x_Pesagem,x_NumPC,x_PesoI,x_PesoF,x_PesoL,x_PesoLC,x_Preco)
////////////////////////////////////////////////////////////////////////////////////////////////////
Local lMsError := .T.
Local aItem   := {}
Local x_Peso  := IIF(x_Pesagem=="I" , x_PesoI , x_PesoF )
Local nTotal  := Round(x_Preco * x_Peso , 2 )
Local nValIcm := Round((SB1->B1_PICM/100) * nTotal , 2 )
Local nSX8Len := GetSX8Len() 

IF ( x_Pesagem == "I" )
	cNumPC   := GetSXENum("SC7","C7_NUM")
	c_Versao := "0001"
ELSE
   cNumPC   := x_NumPC	
	c_Versao := "0002"
ENDIF	

Begin Transaction

		RecLock("SCY",.T.)
      SCY->CY_FILIAL    :=	 xFilial("SCY") 	
	 	SCY->CY_NUM 		:= cNumPC				
	 	SCY->CY_ITEM 		:= "0001"
		SCY->CY_PRODUTO 	:= cProduto        	
		SCY->CY_DESCRI 	:= SB1->B1_DESC      
		SCY->CY_UM 		   := SB1->B1_UM        
		SCY->CY_QUANT 	   := x_Peso
		SCY->CY_PRECO 	   := x_Preco
		SCY->CY_TIPO 	   := 1.0  					
		SCY->CY_TOTAL 		:= nTotal	         
		SCY->CY_DATPRF 	:= MsDate()			
		SCY->CY_EMISSAO 	:= dEmissao	         
		SCY->CY_LOCAL 		:= SB1->B1_LOCPAD  	
		SCY->CY_FORNECE   := cFornece				
		SCY->CY_LOJA 		:= cLoja					
		SCY->CY_CONTA     := SB1->B1_CONTA     
		SCY->CY_CONTATO   := SA2->A2_CONTATO   
		SCY->CY_OBS       := cObserv
		SCY->CY_CC        := SB1->B1_CC          
		SCY->CY_COND      := SA2->A2_COND      
		SCY->CY_FILENT    := xFilial("SCY")    
		SCY->CY_EMITIDO   := "S"               
		SCY->CY_TPFRETE   := SA4->A4_YTPFRET
		SCY->CY_IPIBRUT   := "B"               
		SCY->CY_FLUXO     := "S"               
		SCY->CY_CONAPRO   := "L"               
		SCY->CY_USER      := __cUserId
		SCY->CY_MOEDA     := 1                 
		SCY->CY_TXMOEDA   := 1.0               
		SCY->CY_PICM      := SB1->B1_PICM      
		SCY->CY_VALICM    := nValIcm           
		SCY->CY_BASEICM   := nTotal            
		SCY->CY_PENDEN    := "N"               
		SCY->CY_VERSAO    := c_Versao  
		SCY->CY_SEQUEN    := c_Versao
		SCY->CY_YPLACA    := cPlaca            
		SCY->CY_YCHAVE    := c_Chave           
		SCY->CY_YSEQUEN   := c_Sequen
		SCY->CY_YTRANSP   := cTransp           
		MsUnlock()
		
		lMsError := .F.
		
		IF ( x_Pesagem == "I" )
		
			EvalTrigger()
			
			dbSelectArea("SC7")
			
			While ( GetSX8Len() > nSX8Len )
					ConFirmSX8()
			EndDo
			
			cPedido := cNumPC
			
		ENDIF
		
End Transaction

Return(lMsError)                                                                                    

//////////////////////////////////////////////////////////////////////////////////////////
Static Function f_GravaPC2(c_NumPC,x_PesoI,x_PesoF,x_PesoL,x_PesoLC,x_Preco)
//////////////////////////////////////////////////////////////////////////////////////////
Local lMsError := .T.
Local nTotal   := Round(x_Preco * x_PesoLC , 2 )
Local nValIcm  := Round((SB1->B1_PICM/100) * nTotal , 2 )

		Begin Transaction

				RecLock("SC7",.T.)
				SC7->C7_FILIAL    := xFilial("SC7")
				SC7->C7_NUM       := c_NumPC
				SC7->C7_ITEM      := "0001"
				SC7->C7_TIPO      := 1
				SC7->C7_EMISSAO   := dEmissao
				SC7->C7_DATPRF    := MsDate()
				SC7->C7_FORNECE   := cFornece
				SC7->C7_LOJA      := cLoja
				SC7->C7_PRODUTO   := cProduto
				SC7->C7_QUANT     := x_PesoLC
				SC7->C7_PRECO     := x_Preco
				SC7->C7_TOTAL     := nTotal
				SC7->C7_DESCRI    := SB1->B1_DESC
				SC7->C7_UM        := SB1->B1_UM
				SC7->C7_LOCAL     := SB1->B1_LOCPAD
				SC7->C7_COND      := SA2->A2_COND
				SC7->C7_CONTA     := SB1->B1_CONTA
				SC7->C7_CONTATO   := SA2->A2_CONTATO  
				SC7->C7_OBS       := cObserv
				SC7->C7_FILENT    := xFilial("SC7")
				SC7->C7_MOEDA     := 1
				SC7->C7_TXMOEDA   := 1.0
				SC7->C7_FLUXO     := "S"
				SC7->C7_TPFRETE   := SA4->A4_YTPFRET
				SC7->C7_CONAPRO   := "L"
				SC7->C7_CC        := SB1->B1_CC
				SC7->C7_PICM      := SB1->B1_PICM      
				SC7->C7_VALICM    := nValIcm           
				SC7->C7_BASEICM   := nTotal            
				SC7->C7_PENDEN    := "N"               
				SC7->C7_USER      := __cUserID
				SC7->C7_YPLACA    := cPlaca            
				SC7->C7_YCHAVE    := c_Chave
				SC7->C7_YSEQUEN   := c_Sequen
				SC7->C7_YTRANSP   := cTransp 
				SC7->C7_YPESOI    := x_PesoI
				SC7->C7_YPESOF    := x_PesoF
				SC7->C7_YPESOLC   := x_PesoLC				
				MsUnlock()

				lMsError := .F.
				
		End Transaction
				
Return(lMsError)

////////////////////////////////////////////////////////////
Static Function f_SelSequenc(aTempor)
////////////////////////////////////////////////////////////
Local   lSelPeso := .F.
Local   aStru    := {}
Local   aCampos  := {}
Local   lInverte := .F.
Private nInd     := 0

AADD(aStru,{"TB_OK"        , "C" , 02 , 0 } )
AADD(aStru,{"TB_PLACA"     , "C" , 07 , 0 } )
AADD(aStru,{"TB_EMISSAO"   , "D" , 08 , 0 } )
AADD(aStru,{"TB_HORAI"     , "C" , 08 , 0 } )
AADD(aStru,{"TB_SEQUENC"   , "C" , 06 , 0 } )
AADD(aStru,{"TB_PEDIDO"    , "C" , 06 , 0 } )
AADD(aStru,{"TB_INDICE"    , "N" , 02 , 0 } )
cArqTrab := CriaTrab(aStru,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.F.,.F.)
*
AADD(aCampos , { "TB_OK"       ,  , "Ok"         } )
AADD(aCampos , { "TB_PLACA"    ,  , "Placa"      } )
AADD(aCampos , { "TB_EMISSAO"  ,  , "Emissão"    } )
AADD(aCampos , { "TB_HORAI"    ,  , "Hora Ini"   } )
AADD(aCampos , { "TB_SEQUENC"  ,  , "Sequencia"  } )
AADD(aCampos , { "TB_PEDIDO"   ,  , "N/Pedido"   } )
*
dbSelectArea("SCY")
dbSetOrder(16)
*
dbSelectArea("TRB")
FOR ix:=1 TO LEN(aTempor)
	 nx_Chave := aTempor[ix,16]		
	 cx_Chave := STRZERO(nx_Chave,8)
	 SCY->(dbSeek(xFilial("SCY")+DTOS(dEmissao)+cPlaca+cx_Chave))
	 RecLock("TRB",.T.)
	 TRB->TB_PLACA    := cPlaca
	 TRB->TB_EMISSAO  := dEmissao
	 TRB->TB_HORAI    := aTempor[ix,6]
	 TRB->TB_SEQUENC  := aTempor[ix,8]
	 TRB->TB_PEDIDO   := SCY->CY_NUM
	 TRB->TB_INDICE   := IX
	 MsUnlock()
NEXT
*
dbSelectArea("TRB")
dbGoTop()
*
DEFINE MSDIALOG oSelDlg TITLE "Seleciona pesagem" FROM 000, 000  TO 230, 590       COLORS 0, 16777215           PIXEL

@ 000, 002 GROUP  oGrpSel TO 116, 246 PROMPT "Seleção"                             OF oSelDlg PIXEL                    
@ 005, 250 BUTTON oBtnSel1            PROMPT "Confirma"              SIZE 042, 013 OF oSelDlg  Action ( lSelPeso := .T. , oSelDlg:End() )    PIXEL

oMark := MsSelect():New("TRB","TB_OK",,aCampos,@lInverte,@cMarca,{008,006,110,240})
oMark:oBrowse:bldblclick := { || f_ValidSel() }

ACTIVATE MSDIALOG osELDlg CENTERED Valid lSelPeso

nInd := IIF(nInd > 0 , nInd , 1 )

TRB->(dbCloseArea())

Return(nInd)

////////////////////////////////////////////////
Static Function f_ValidSel()
////////////////////////////////////////////////
Local _lRsp := .T.

IF ( EMPTY(TRB->TB_OK) )
	IF ( nInd > 0 )
		MsgInfo("-- Apenas um item pode ser selecionado. Para selecionar outro item, deve-se desmarcar o item marcado.")
		_lRsp := .F.
	ELSE
		RecLock("TRB",.F.)
		TRB->TB_OK := cMarca
		MsUnlock()
		nInd := TRB->TB_INDICE
	ENDIF
ELSE
	RecLock("TRB",.F.)
	TRB->TB_OK := " "
	MsUnlock()
	nInd := 0
ENDIF

Return(_lRsp)

////////////////////////////////////////////////////////////
Static Function fp_Ticket(x_Tp)
////////////////////////////////////////////////////////////
///
/// cm    = ( Pixel / Resolucao ) x 2,54       --> Resolucao = 300 DPI       para impressora
/// Pixel = ( Resolucao x cm ) / 2,54          --> Resolucao =  72 ou 96 DPI para monitor
///
Local xEmissaoI,xEmissaoF,xTicket,xPesoI,xPesoF,xPesoL
Local xFornece,xProduto,xTransp,xRazSoc,xCnpj
Local lEof
Local xBitMap   := "\SYSTEM\LGRL01.BMP"

////
////Verifica se foi gerado Pedido - 1a. pesagem
////
dbSelectArea("SCY")
dbSetOrder(16)                                          
dbSeek(xFilial("SCY")+DTOS(dEmissao)+cPlaca+c_chave)
lEof := SCY->(EOF())
*
IF ( !lEof )
	////
	////Verifica se foi gerado Pedido - 2a. pesagem
	////
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(xFilial("SC7")+SCY->CY_NUM)
	lEof := SC7->(EOF())
	IF ( !lEof )
		xFornece := cRazSoc   //Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")
		xProduto := cDesc     //Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_DESC")
		xTransp  := cDesTran  //Posicione("SA4",1,xFilial("SA4")+SC7->C7_YTRANSP,"A4_NOME")
		xObserv  := cObserv
	ELSE	
		MsgStop("** Falta informar a 2a. pesagem para o veiculo na data informada.")
		Return
  	ENDIF
ELSE	
	MsgStop("** Não foi encontrado nenhum pedido gerado para o veiculo na data informada.")
	Return
ENDIF

// Cria um novo objeto para impressao
oPrint := TMSPrinter():New("Ticket de Pesagem")

// Cria os objetos com as configuracoes das fontes
//                                              Negrito  Subl  Italico
oFont08  := TFont():New( "Times New Roman",,08,,.f.,,,,,.f.,.f. )
oFont08b := TFont():New( "Times New Roman",,08,,.t.,,,,,.f.,.f. )
oFont09  := TFont():New( "Times New Roman",,09,,.f.,,,,,.f.,.f. )
oFont10  := TFont():New( "Times New Roman",,10,,.f.,,,,,.f.,.f. )
oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,,.f.,.f. )
oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,,.f.,.f. )
oFont11  := TFont():New( "Times New Roman",,11,,.f.,,,,,.f.,.f. )
oFont11b := TFont():New( "Times New Roman",,11,,.t.,,,,,.f.,.f. )
oFont12  := TFont():New( "Times New Roman",,12,,.f.,,,,,.f.,.f. )
oFont12b := TFont():New( "Times New Roman",,12,,.t.,,,,,.f.,.f. )
oFont13b := TFont():New( "Times New Roman",,13,,.t.,,,,,.f.,.f. )
oFont14  := TFont():New( "Times New Roman",,14,,.f.,,,,,.f.,.f. )
oFont24b := TFont():New( "Times New Roman",,24,,.t.,,,,,.f.,.f. )

// Mostra a tela de Setup
oPrint:Setup()
   
// Inicia uma nova pagina
oPrint:StartPage()

// Imprime a inicializacao da impressora
//oPrn:Say(20,20," ",oFont12,100)

xFone := RTRIM(SM0->M0_TEL)
xFone := STRTRAN(xFone,"(","")
xFone := STRTRAN(xFone,")","")
xFone := STRTRAN(xFone,"-","")
xFone := STRTRAN(xFone," ","")
*
xFax := RTRIM(SM0->M0_FAX)
xFax := STRTRAN(xFax,"(","")
xFax := STRTRAN(xFax,")","")
xFax := STRTRAN(xFax,"-","")
xFax := STRTRAN(xFax," ","")
	
xRazSoc := RTRIM(SM0->M0_NOMECOM)
xEnder  := RTRIM(SM0->M0_ENDCOB) + " - " + RTRIM(SM0->M0_BAIRCOB) + " - " + RTRIM(SM0->M0_CIDCOB) + "/" + SM0->M0_ESTCOB
xFone   := "Fone / Fax: " + TRANSF(xFone,"@R (99)9999-9999") + IIF(!EMPTY(SM0->M0_FAX) , " / " + TRANSF(xFax,"@R (99)9999-9999") , "" )
xCnpj   := "C.N.P.J.: " + TRANSF(SM0->M0_CGC,"@R 99.999.999/9999-99")

xCarreta := TRANSF(cPlaca, "@R !!!-9999")
	
SET CENTURY ON
xEmissaoI := DTOC(dEmissao) + "  -  " + c_HoraI
xEmissaoF := DTOC(dEmissao) + "  -  " + c_HoraF
SET CENTURY OFF

xTicket := "TICKET DE PESAGEM:  " + c_Sequen
xPedido := "N/PEDIDO:  " + cPedido
xPesoI  := TRANSF(n_PesoI,"@E 99,999.9") + " Kg"
xPesoF  := TRANSF(n_PesoF,"@E 99,999.9") + " Kg"
xPesoL  := TRANSF(n_PesoL,"@E 99,999.9") + " Kg"  
xPesoLC := TRANSF(n_PesoLC,"@E 999,999.9") + " Kg"
xLiq    := STRZERO(n_PesoL,11)
xLiqC   := STRZERO(n_PesoLC,11)

oPrint:SetFont(oFont24b)
oPrint:SayBitMap(100,116,xBitMap,600,280)

oPrint:Say(140,860,xRazSoc,oFont13b ,140)
oPrint:Say(200,860,xEnder,oFont11 ,140)
oPrint:Say(250,860,xFone,oFont11 ,140)
oPrint:Say(300,860,xCnpj,oFont11 ,140)
oPrint:Say(420,120,xTicket,oFont12b ,100)
oPrint:Say(420,1100,xPedido,oFont12b ,100)
*
oPrint:Line(490,110,490,2300)
oPrint:Say(520,120,"Placa Carreta:" ,oFont11b ,110)
oPrint:Say(520,480,xCarreta,oFont12 ,100)
oPrint:Say(570,120,"Transportadora:" ,oFont11b ,110)
oPrint:Say(570,480,xTransp,oFont12 ,140)
oPrint:Say(620,120,"Cliente/Fornecedor:" ,oFont11b ,150)
oPrint:Say(620,480,xFornece,oFont12 ,140)
oPrint:Say(670,120,"Item:" ,oFont12 ,50)
oPrint:Say(670,480,xProduto,oFont12 ,140)
*
oPrint:Line(750,110,750,2300)
oPrint:Say(790,120,"Pesagem Inicial",oFont11b ,80)
oPrint:Say(790,1100,"Pesagem Final",oFont11b ,80)
oPrint:Say(850,120,"Data / Hora:" ,oFont11b ,100)
oPrint:Say(850,400,xEmissaoI,oFont12 ,140)
oPrint:Say(850,1100,"Data / Hora:" ,oFont11b ,100)
oPrint:Say(850,1360,xEmissaoF,oFont12 ,140)
oPrint:Say(906,120,"Peso Inicial:" ,oFont11b ,100)
oPrint:Say(906,400,xPesoI,oFont12 ,100)
oPrint:Say(906,1100,"Peso Final:" ,oFont11b ,100)
oPrint:Say(906,1360,xPesoF,oFont12 ,100)
*
oPrint:Line(1060,110,1060,2300)  //HOR
oPrint:Say(1090,120,"Dados Adicionais",oFont12b ,50)
oPrint:Say(1150,120,"Container:",oFont12b ,500)
oPrint:Say(1210,120,"Obs.:",oFont12b ,500)
oPrint:Say(1210,260,xObserv,oFont12 ,170)
*
oPrint:Line(1290,110,1290,2300)
oPrint:Box(1340,1580,1440,1920)        
oPrint:Say(1300,1580,"Peso Líquido",oFont11b ,80)
oPrint:Say(1364,1600,xPesoL,oFont14 ,80)
*                                       
IF ( xLiq <> xLiqC )
	oPrint:Box(1340,1950,1440,2290)        
	oPrint:Say(1300,1950,"Peso Líq.Corrigido",oFont11b ,80)
	oPrint:Say(1364,1970,xPesoLC,oFont14 ,80)
ENDIF	
*	
// Fecha a pagina
oPrint:EndPage()
oPrint:End()

// Mostra a tela de preview
oPrint:Print()    ///Preview()

Return

***************************
Static Function ValidPerg()
***************************
   _sAlias := Alias()
   DbSelectArea("SX1")
   DbSetOrder(1)
   aRegs :={} //Grupo|Ordem| Pegunt                         | perspa | pereng | VariaVL  | tipo| Tamanho|Decimal| Presel| GSC | Valid         |   var01   | Def01             | DefSPA1 | DefEng1 | CNT01 | var02 | Def02   | DefSPA2 | DefEng2 | CNT02 | var03 | Def03    | DefSPA3 | DefEng3 | CNT03 | var04 | Def04 | DefSPA4 | DefEng4 | CNT04 | var05 | Def05 | DefSPA5 | DefEng5 | CNT05 | F3    | GRPSX5 |
   aAdd(aRegs,{ cPerg,"01" , "Selecionar Pesagem          ?",   ""   ,  ""    , "mv_ch1" , "N" ,   01   ,   0   ,   2   , "C" , "          "  , "mv_par01", "Sim            " , "     " , "     " , "   " , "   " , "Não  " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   aAdd(aRegs,{ cPerg,"02" , "Selecionar Ticket           ?",   ""   ,  ""    , "mv_ch2" , "N" ,   01   ,   0   ,   2   , "C" , "          "  , "mv_par02", "Sim            " , "     " , "     " , "   " , "   " , "Não  " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   aAdd(aRegs,{ cPerg,"03" , "Nro. do IP                  ?",   ""   ,  ""    , "mv_ch3" , "C" ,   15   ,   0   ,   0   , "G" , "          "  , "mv_par03", "               " , "     " , "     " , "   " , "   " , "     " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   aAdd(aRegs,{ cPerg,"04" , "Porta                       ?",   ""   ,  ""    , "mv_ch4" , "C" ,   04   ,   0   ,   0   , "G" , "          "  , "mv_par04", "               " , "     " , "     " , "   " , "   " , "     " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
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
		dbSelectArea(_sAlias)
Return
