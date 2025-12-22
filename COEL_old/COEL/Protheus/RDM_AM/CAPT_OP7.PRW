#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "JPEG.CH"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ CApt_Op7  ≥ Autor ≥ Carlos Nina           ≥ Data ≥10/12/14 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥ Gera etiqueta de identificacao da OP para entregue na      ≥±±
±±≥          ≥ Expedicao.                                                 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ Especifico Coelmatic/Manaus - Embalagem                    ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒ¬ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Analista Resp.≥  Data  ≥ Bops ≥ Manutencao Efetuada                    ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥              ≥  /  /  ≥      ≥                                        ≥±±
±±≥              ≥  /  /  ≥      ≥                                        ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function CApt_Op7()

Local cLogo  := FisxLogo("1")
Local cNullo := Space(6)
Local aUsers := AllUsers()
Local aGrp

Private oVd  := LoadBitmap( GetResources(), 'br_verde')
Private oVm  := LoadBitmap( GetResources(), 'br_vermelho')
Private oAm  := LoadBitmap( GetResources(), 'br_amarelo')

Private oEdit0,oEdit1,oEdit2,oEdit5,oEdit6,oEdit7,oEdit10,oEmissao
Private oGroup1,oGroup2,oGroup3,oGroup4,oGroup5,oGroup6,oGroup7,oGroup8,oGroup9,oGroupA,oGroupB,oTBar,oButton
Private oBrowse,oLbl5,oBold,oQtyEmb,oQtdEmb,oQtyEtq,oQtdEtq
Private oBrowse
Private oTBitMap1,oTBitMap2,oTBitMap3,oTBitMap4,oTBmp1,oTBmp2,oTBmp3,oTBmp4,oTBmp5
Private oTBmp01,oTBmp02,oTBmp03,oTBmp04,oTBmp05,oTBmp06,oTBmp07,oTBmp08,oTBmpOk1,oTBmpOk2,oTBmpOk3,oTBmpOk4,oTBmpOk5,oTBmpOk6,oTBmpOk7,oTBmpOk8
Private oCracha,oOperac,oUsuario,oOperacao,oRecurso,oNumero,oNOP,oProdDesc,oProduto,oDescri,oObs,oObserv,oAlmox,oLocal
Private oQtdPed,oQtyPed,oQtdEnt,oQtyEnt,oQtdSdo,oQtySdo,oSequen,oQty,oData,oHorario,oHora,oCentro,oCTrab,oNullo
Private oRot01,oRot02,oRot03,oRot04,oRot05,oRot06,oRot07,oRot08

Private cSetor,cOperI,cOperF

Private lAdmin
Private lEncerrada := .F.
Private cPerg      := "CAPTOP7   "
Private cEdit0     := Space(9)
Private cEdit1		 := Space(8)
Private cEdit5		 := Space(2)
Private cEdit6		 := Space(10)
Private nQtdEmb    := 0
Private nQtdEtq    := 0
Private mQtdEtq    := 0

Private cSetor     := "01"
Private cOperI     := ""
Private cOperF     := "" 
Private cRot01     := ""
Private cRot02     := ""
Private cRot03     := ""
Private cRot04     := ""
Private cRot05     := ""
Private cRot06     := ""
Private cRot07     := ""
Private cRot08     := ""

Private _cOp	    := Space(11)
Private _nQuant	 := 0
Private _cProd	    := Space(30)
Private _cCod	    := Space(30)
Private _cDesc     := Space(200)
Private _cObs      := Space(40)
Private _cUm	    := Space(2)
Private _cAlmox	 := Space(2)
Private _nQtde     := 0
Private _nQuje     := 0
Private _nSaldo    := 0
Private nEtqImp    := 0
Private nPrdImp    := 0

Private _xOpc	    := 1
Private nTimeOut   := 120000
Private dEmissao   := ddatabase
Private _cPV       := ""
Private _cLote     := ""
Private _cCliente  := ""
Private _cFamilia  := ""
Private _cModelo   := ""
Private _cPesoOk   := ""
Private _dDatRf    := CTOD("")

Private aRet  := FwTimeUF("AM",,.T.)                              ///aRet[1] = 20140227  ; aRet[2] = 17:32:33
		
Private cHora := aRet[2]

Private nQtOper01
Private _oDlg				// Dialog Principal
Private _nHRes 		:= oMainWnd:nClientWidth
Private _cTheme		:= Alltrim(GetTheme())
Private _lMdiChild	:= SetMdiChild()
Private lEmProcesso  := .F.
Private lSaida       := .F.
Private aEntSai      := {"       ","ENTRADA","SAIDA  "}
Private aCols        := { {"2","","","",0,"","",0,""} }

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

////
////Verifica se o usuario faz parte do Grupo de usuarios para executar esta rotina
////
nX     := ASCAN(aUsers , { |x| x[1,1] == M->__cUserID } )
aGrp   := ACLONE(aUsers[nX,1,10])
nW     := ASCAN(aGrp , "000000" )                              ////Grupo Administradores
lAdmin := ( nW > 0 )
								  
DEFINE FONT 	oBold NAME "Times New Roman"	SIZE 0,  18 BOLD  
DEFINE FONT 	oFnt  NAME "Arial"				SIZE 0, -16 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt4 NAME "Arial"				SIZE 0, -20 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt3 NAME "Arial"				SIZE 0, -18 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt2 NAME "Arial"				SIZE 0, -14 BOLD	// "Times New Roman" Menor

oFnt12 := TFont():New('Courier new',,-12,.T.)

dbSelectArea("SB1")   ///Produtos
dbSetOrder(1)
*
dbSelectArea("SH1")   ///Recursos
dbSetOrder(1)
*
dbSelectArea("SX5")   ///Tabelas
dbSetOrder(1)
		
ValidPerg()

pergunte(cPerg,.F.)
		
DEFINE MSDIALOG _oDlg TITLE OemtoAnsi(":::... Gera Etiqueta de IdentificaÁ„o de OP's produzida PADRAO IMBERA ...:::") FROM 000,000 TO 526,984 COLORS 0, 16777215 PIXEL

oTBar := TBar():New( _oDlg,40,25,.T.,,,'tbar_coel',.F. )   ///40,25

@ 015, 002 GROUP oGroup1 TO 046, 106 PROMPT OemToAnsi("ORDEM DE PRODU«√O")						  OF _oDlg COLOR 0, 16777215 PIXEL
@ 015, 002 GROUP oGroup7 TO 256, 106 PROMPT OemToAnsi("OPERA«√O")        						  OF _oDlg COLOR 0, 16777215 PIXEL
@ 015, 109 GROUP oGroup5 TO 049, 270 PROMPT OemToAnsi("PARAMETROS DE IMPRESS√O")  			  OF _oDlg COLOR 0, 16777215 PIXEL	
@ 015, 272 GROUP oGroup3 TO 049, 490 PROMPT ""                                    			  OF _oDlg COLOR 0, 16777215 PIXEL	
@ 051, 109 GROUP oGroup2 TO 111, 490 PROMPT OemToAnsi("ORDEM DE PRODU«√O")						  OF _oDlg COLOR 0, 16777215 PIXEL
@ 113, 109 GROUP oGroup4 TO 256, 490 PROMPT OemToAnsi("HIST”RICO DE APONTAMENTO")			  OF _oDlg COLOR 0, 16777215 PIXEL
@ 54.5,302 GROUP oGroup6 TO 096, 303 PROMPT ""                         						  	  OF _oDlg COLOR 0, 16777215 PIXEL	

@ 024, 004 MSGET oEdit1 		VAR     cEdit1    PICTURE "@R XXXXXX.XX"       	SIZE 060, 014 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt4  VALID (_fVlDlg("CBAR",cEdit1))
@ 030, 076 MSGET oNullo 		VAR     cNullo    PASSWORD                   	SIZE 001, 004 OF _oDlg COLORS 0, 16777215 PIXEL                     

@ 058, 111 SAY   oNumero		PROMPT  OemToAnsi("N˙mero")        					SIZE 060, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 058, 307 SAY   oQtdPed		PROMPT  "Quant. Pedida:"          					SIZE 070, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 058, 385 SAY   oQtyPed		VAR     _nQtde    PICTURE "@E 99,999" 				SIZE 030, 012 OF _oDlg COLOR  CLR_HRED    PIXEL  Font oFnt
@ 066, 111 SAY   oNOP   		VAR     _cOP      PICTURE "@R XXXXXX.99.999"		SIZE 080, 012 OF _oDlg COLOR  CLR_HRED    PIXEL  Font oFnt4
@ 072, 307 SAY   oQtdEnt  		PROMPT  "Quant. Produzida:"      					SIZE 070, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 072, 385 SAY   oQtyEnt 		VAR     _nQuje    PICTURE "@E 99,999"				SIZE 030, 012 OF _oDlg COLOR  CLR_HRED    PIXEL  Font oFnt
@ 080, 111 SAY   oProdDesc		PROMPT  OemToAnsi("Produto / DescriÁ„o")			SIZE 120, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 089, 111 SAY   oProduto 		VAR     _cProd                   					SIZE 130, 014 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4
@ 101, 111 SAY   oDescri		VAR     _cDesc                   					SIZE 240, 014 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt

@ 022, 111 SAY   oQtyEmb		PROMPT  "Qtde. Produto na Caixa" 					SIZE 110, 009 OF _oDlg COLOR CLR_HBLUE    PIXEL  Font oFnt2
@ 022, 206 SAY   oQtyEtq      PROMPT  "Qtde. de Caixa(s)"      					SIZE 100, 009 OF _oDlg COLOR CLR_HBLUE    PIXEL  Font oFnt2
@ 031, 141 MSGET oQtdEmb 		VAR     nQtdEmb   PICTURE "@E 9999"					SIZE 030, 012 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt3 Valid(_fVlDlg("QEMB",nQtdEmb))
@ 031, 220 MSGET oQtdEtq   	VAR     nQtdEtq   PICTURE "@E 999"					SIZE 030, 012 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt3 Valid(_fVlDlg("QETQ",nQtdEtq)) 

@ 022, 274 SAY   oEtqImp		PROMPT  "Etiqueta(s) Impressa(s)"					SIZE 110, 009 OF _oDlg COLOR CLR_HBLUE    PIXEL  Font oFnt2
@ 034, 274 SAY   oPrdImp      PROMPT  "Quantidade de Produto(s)" 					SIZE 110, 009 OF _oDlg COLOR CLR_HBLUE    PIXEL  Font oFnt2
@ 022, 380 SAY   oEtqImpQ		VAR     nEtqImp   PICTURE "@E 9999"					SIZE 030, 012 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt3 
@ 034, 380 SAY   oPrdImpQ  	VAR     nPrdImp   PICTURE "@E 9999"					SIZE 030, 012 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt3 

oTBitmap3 := TBtnBmp2():New( 038, 0824, 70, 30,'conf_coel',,,,;   
					{ || f_confirma() }  ,_oDlg,'Confirma a impress„o da Etiqueta',,.F.,.F.)
oTBitmap4 := TBtnBmp2():New( 038, 0904, 70, 30,'coel_abortar',,,,;
					{ || f_cancela() } , _oDlg,'Encerra a impress„o da(s) Etiqueta(s)',,.F.,.F.)

oBrowse := TCBrowse():New( 120 , 111, 377, 134,,{'','OPER.','DT.ENTRADA','HR.ENTRADA','QTD.ENTRADA','DT.SAIDA','HR.SAIDA','QTD.SAIDA','OPERADOR'},{20,26,36,38,42,30,34,34,50},_oDlg,,,,,{||},,,,,,"Legenda",.F.,,.T.,,.F.,,, )	

oBrowse:SetArray(aCols)

oBrowse:bLine := {|| { IIF(aCols[oBrowse:nAt,1]=="1",oVd,IIF(aCols[oBrowse:nAt,1]=="2",oVm,oAm)) , ;
							  aCols[oBrowse:nAt,2] , ;
							  aCols[oBrowse:nAt,3] , ;
							  aCols[oBrowse:nAt,4] , ;
							  aCols[oBrowse:nAt,5] , ;
							  aCols[oBrowse:nAt,6] , ;
							  aCols[oBrowse:nAt,7] , ;
							  aCols[oBrowse:nAt,8] , ;
							  aCols[oBrowse:nAt,9] } }

oTBitmap1 := TBtnBmp2():New( 00, 00, 40, 70, 'S4WB008N' ,,,,;
					{ || Calculadora() }  ,oTBar,'Calculadora',,.F.,.F.)
oTBitmap5 := TBtnBmp2():New( 00, 00, 40, 70, 'parametros' ,,,,;
               {|| f_Parametros(.T.) }  ,oTBar,'Parametros',,.F.,.F.)
oTBitmap2 := TBtnBmp2():New( 00, 00, 40, 70, 'button_exit' ,,,,;
					{ || f_Saida() }  ,oTBar,'Sair',,.F.,.F.)
					
@ 023, 005 SAY   oRot01		VAR     cRot01                                         			SIZE 100, 009 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt12
@ 050, 005 SAY   oRot02		VAR     cRot02                                   					SIZE 100, 009 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt12
@ 078, 005 SAY   oRot03		VAR     cRot03                                         			SIZE 100, 009 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt12
@ 106, 005 SAY   oRot04		VAR     cRot04                                   					SIZE 100, 009 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt12
@ 134, 005 SAY   oRot05		VAR     cRot05                                         			SIZE 100, 009 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt12
@ 161, 005 SAY   oRot06		VAR     cRot06                                   					SIZE 100, 009 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt12
@ 189, 005 SAY   oRot07		VAR     cRot07                                         			SIZE 100, 009 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt12
@ 217, 005 SAY   oRot08		VAR     cRot08                                   					SIZE 100, 009 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt12

oTBmp01 := TBtnBmp2():New( 060, 002, 196, 40,'coel_op01',,,,;
					{ || nil }  ,_oDlg,,,.T.,.T.)
oTBmp02 := TBtnBmp2():New( 115, 002, 196, 40,'coel_op02',,,,;
					{ || nil } , _oDlg,,,.T.,.T.)
oTBmp03 := TBtnBmp2():New( 172, 004, 196, 40,'coel_op03',,,,;
					{ || nil }  ,_oDlg,,,.T.,.T.)
oTBmp04 := TBtnBmp2():New( 227, 004, 196, 40,'coel_op04',,,,;
					{ || nil } , _oDlg,,,.T.,.T.)
oTBmp05 := TBtnBmp2():New( 282, 004, 196, 40,'coel_op05',,,,;
					{ || nil }  ,_oDlg,,,.T.,.T.)
oTBmp06 := TBtnBmp2():New( 336, 004, 196, 40,'coel_op06',,,,;
					{ || nil } , _oDlg,,,.T.,.T.)
oTBmp07 := TBtnBmp2():New( 392, 004, 196, 40,'coel_op07',,,,;
					{ || nil }  ,_oDlg,,,.T.,.T.)
oTBmp08 := TBtnBmp2():New( 449, 004, 196, 40,'coel_op08',,,,;
					{ || nil } , _oDlg,,,.T.,.T.)
					
oTBmpOk1 := TBitmap():New(20,007,24,24,'ok',,.T.,_oDlg,;
	  {||},,.F.,.F.,,,.F.,,.T.,,.F.)
oTBmpOk1:lAutoSize := .T.
oTBmpOk2 := TBitmap():New(47,007,24,24,'ok',,.T.,_oDlg,;
	  {||},,.F.,.F.,,,.F.,,.T.,,.F.)
oTBmpOk2:lAutoSize := .T.
oTBmpOk3 := TBitmap():New(75,007,24,24,'ok',,.T.,_oDlg,;
	  {||},,.F.,.F.,,,.F.,,.T.,,.F.)
oTBmpOk3:lAutoSize := .T.
oTBmpOk4 := TBitmap():New(103,007,24,24,'ok',,.T.,_oDlg,;
	  {||},,.F.,.F.,,,.F.,,.T.,,.F.)
oTBmpOk4:lAutoSize := .T.
oTBmpOk5 := TBitmap():New(131,007,24,24,'ok',,.T.,_oDlg,;
	  {||},,.F.,.F.,,,.F.,,.T.,,.F.)
oTBmpOk5:lAutoSize := .T.
oTBmpOk6 := TBitmap():New(158,007,24,24,'ok',,.T.,_oDlg,;
	  {||},,.F.,.F.,,,.F.,,.T.,,.F.)
oTBmpOk6:lAutoSize := .T.
oTBmpOk7 := TBitmap():New(186,007,24,24,'ok',,.T.,_oDlg,;
	  {||},,.F.,.F.,,,.F.,,.T.,,.F.)
oTBmpOk7:lAutoSize := .T.
oTBmpOk8 := TBitmap():New(214,007,24,24,'ok',,.T.,_oDlg,;
	  {||},,.F.,.F.,,,.F.,,.T.,,.F.)
oTBmpOk8:lAutoSize := .T.

/////
/////Oculta objetos
/////
f_Hide()

ACTIVATE MSDIALOG _oDlg CENTER Valid lSaida
	
Return

///////////////////////////////////////////////////////////
Static Function f_Saida()
///////////////////////////////////////////////////////////
Local lRsp := lEmProcesso

IF ( lRsp )

	lRsp := MsgBox("Deseja realmente sair da Rotina?","Escolha a opÁ„o","YESNO")
	
ENDIF

IF ( lRsp .OR. !lEmProcesso )
	lSaida := .T.
	_oDlg:End()
ENDIF

Return(lRsp)

///////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_parametros(lParam)
///////////////////////////////////////////////////////////////////////////////////////////////////////

//IF ( lAdmin )
	Pergunte(cPerg,lParam)
//ENDIF

Return

///////////////////////////////////////////////////////////
Static Function f_confirma()
///////////////////////////////////////////////////////////
Local nX
Local nColI   := mv_par01
Local cQtdEmb := IIF(nQtdEmb < 10 , STRZERO(nQtdEmb,2) , TRANSF(nQtdEmb,"@E 9999") )
Local cOP1    := LEFT(_cOP,8)
Local cBarra  := cOP1+STRZERO(nQtdEmb,4)
Local cAviso  := IIF(nQtdEtq > 1 , "As etiquetas foram impressas corretamente?" , "A etiqueta foi impressa corretamente?" ) + CHR(13)+CHR(10) + "Se n„o, favor reimprimir somente as etiquetas com defeito."
Local aCBarra := {{"10",cOP1},{"30",STRZERO(nQtdEmb,4)}}
//Local cBarra  := "(10)"+cOP1+"(30)"+STRZERO(nQtdEmb,4)


IF ( mv_par02==1 )
	MSCBPRINTER("S600","LPT1",,,.f.,,,,)
	MSCBCHKSTATUS(.F.)
	
	MSCBLOADGRF("\ARQUIVOS\FOTOS\COEL-L3T.GRF")
	
	MSCBBEGIN(nQtdEtq,4) 
	MSCBWRITE("^LH08,16^FS")
//	MSCBGRAFIC(nColI+1.0,0.30,"COEL-L3T")   //1.0,0.25   (+3.0)                                                      //LOGOTIPO 
	
	//MSCBSAY(nColI+50.75,8.25,_cPesoOk,"P","D","46,04")
	MSCBSAY(nColI+1.5,11.85,"CODIGO: "+_cProd,"P","D","40,06")     //"P","D","40,06")
	MSCBSAY(nColI+1.5,16.35,"MODELO: "+_cFamilia,"P","D","40,06")   //"P","D","40,06")
	MSCBSAY(nColI+1.5,20.85,_cModelo,"P","D","40,06")
	MSCBLINEH(nColI+1.5,24.85,65,3)
	MSCBSAY(nColI+1.5,25.85,"O.P.: "+TRANSF(cOP1,"@R XXXXXX.XX"),"P","D","46,10")
	MSCBSAY(nColI+42.75,25.85,"QTY.: "+cQtdEmb,"P","D","46,04")
	MSCBSAY(nColI+1.5,32.5,"DATA: "+DTOC(_dDatRf),"P","D","28,08")
	MSCBSAY(nColI+39.0,32.5,"LOTE: "+_cLote,"P","D","28,08")
	MSCBLINEH(nColI+1.5,36.55,65,3)
	
	MSCBSAY(nColI+1.5,37.55,"P.V.: "+_cPV,"P","D","46,10")
	MSCBSAY(nColI+1.5,44.0,"CLIENTE: "+_cCliente,"P","D","46,04")
	MSCBLINEH(nColI+1.5,50.05,65,3)
	MSCBSAY(nColI+1.5,51.55,"EXPEDICAO:","P","D","40,06") 
	//MSCBSAYBAR(19.0,52.40,aCBarra,"N","C",6,.f.,.f.,.f.,"C",2,1,.F.)  
	//MSCBSAYBAR(nColI+19.0,52.40,_cProd,"N","C",6,.f.,.t.,.f.,,2,1,.F.)
	MSCBSAYBAR(nColI+5,56.40,alltrim(SB1->B1_COD),"N","C",6,.f.,.t.,.f.,,3,2,.F.)  //
 	
ELSE 
	MSCBPRINTER("SM400","LPT1",,,.f.,,,,)
	MSCBCHKSTATUS(.F.)               
	
	MSCBLOADGRF("\ARQUIVOS\FOTOS\COEL-L3T.GRF")
	                      
	MSCBBEGIN(nQtdEtq,4) 
	MSCBWRITE("^LH08,16^FS")
	MSCBGRAFIC(nColI+1.0,0.30,"COEL-L3T")   //1.0,0.25   (+3.0)                                                      //LOGOTIPO 
	
	//MSCBSAY(nColI+67.75,11.30,_cPesoOk,"N","B","28,10")
	MSCBSAY(nColI+1.5,17.00,"CODIGO: "+_cProd,"N","B","40,18")     //"P","D","40,06")
	MSCBSAY(nColI+1.5,27.00,"MODELO: "+_cFamilia,"N","B","40,20")   //"P","D","40,06")
	MSCBSAY(nColI+1.5,37.00,_cModelo,"N","B","44,16")
	MSCBLINEH(nColI+1.5,47.00,165,3)                         
	MSCBSAY(nColI+1.5,49.00,"O.P.: "+TRANSF(cOP1,"@R XXXXXX.XX"),"N","B","46,20")
	MSCBSAY(nColI+88.00,49.00,"QTY.: "+cQtdEmb,"N","B","46,20")
	MSCBSAY(nColI+1.5,58.5,"DATA: "+DTOC(_dDatRf),"N","B","30,16")
	MSCBSAY(nColI+87.0,58.5,"LOTE: "+_cLote,"N","B","30,16")
	MSCBLINEH(nColI+1.5,66.00,165,3)
	
	MSCBSAY(nColI+1.5,68.00,"P.V.: "+_cPV,"N","B","46,20")
	MSCBSAY(nColI+1.5,78.0,"CLIENTE: "+_cCliente,"N","B","46,20")
	MSCBLINEH(nColI+1.5,88.00,165,3)
	MSCBSAY(nColI+1.5,90.00,"EXPEDICAO:","N","B","30,18") 
	//MSCBSAYBAR(19.0,52.40,aCBarra,"N","MB07",6,.f.,.f.,.f.,"C",2,1,.F.)  
	//MSCBSAYBAR(nColI+40,98.00,_cProd,"N","C",6,.f.,.t.,.f.,,3,2,.F.) 
	MSCBSAYBAR(nColI+20,102,alltrim(SB1->B1_COD),"N","C",16,.f.,.t.,.f.,,3,2,.F.)  
	 
	
ENDIF

MSCBEND()
MSCBClosePrinter()

nX := 1     ////Aviso("Impress„o da Etiqueta" , cAviso , {"Sim","N„o"} , 3 )

IF ( nX == 2 )
	mQtdEtq := nQtdEtq
	Return
ENDIF

nQEtqAnt := IIF(mQtdEtq == 0 , 0 , ( nQtdEmb * ABS( mQtdEtq - nQtdEtq ) ) )
mQtdEtq  := IIF(mQtdEtq == 0 , 0 , ( mQtdEtq - nQtdEtq ) )
_nSaldo  := ( _nSaldo - nQEtqAnt - ( nQtdEmb * nQtdEtq ) )
nEtqImp  := ( nEtqImp + mQtdEtq + nQtdEtq )
nPrdImp  := ( nPrdImp + ( ( mQtdEtq + nQtdEtq ) * nQtdEmb ) )

nQtdEmb := 0
nQtdEtq := 0
mQtdEtq := 0

oEtqImpQ:Refresh()
oPrdImpQ:Refresh()
	
Return

///////////////////////////////////////////////////////////
Static Function f_Cancela()
///////////////////////////////////////////////////////////
Local lRsp := lEmProcesso
Local _nX,_nW

IF ( lEmProcesso )

	lEmProcesso := .F.
	
ENDIF
	
f_Hide()

cEdit1  := SPACE(8)
nQtdEmb := 0
nQtdEtq := 0
mQtdEtq := 0
nEtqImp := 0
nPrdImp := 0

oGroup1:Show()
oEdit1:Show()
oNullo:Show()
oEdit1:SetFocus()

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////Validacao Da Digitacao Dos Dados Da Dialog. 
////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function _fVlDlg(_cTipo,_xConteudo)

Local cEdt5
Local _lRet	  := .t. 
Local _nX     := 0
Local dDatIni := FirstDay(ddatabase)

Do Case
	Case Upper(Alltrim(_cTipo)) == "QEMB"
			/*
			If ( ( _xConteudo * nQtdEtq ) > _nSaldo )
				MsgAlert("A soma da(s) quantidade(s) informada ultrapassa a quantidade produzida. Certifique-se dos valores informado antes de imprimir.","AtenÁ„o")
			EndIf
			*/
	Case Upper(Alltrim(_cTipo)) == "QETQ"
			/*
			If ( ( _xConteudo * nQtdEmb ) > _nSaldo )
				MsgAlert("A soma da(s) quantidade(s) informada ultrapassa a quantidade produzida. Certifique-se dos valores informado antes de imprimir.","AtenÁ„o")
			EndIf
			*/
	Case Upper(Alltrim(_cTipo)) == "CBAR"
		
		If ( !Empty(_xConteudo) )
			_xConteudo := _xConteudo+"001"
			DbSelectArea("SC2")
			DbSetOrder(1)                                      ///C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD
			dbSeek(xFilial("SC2") + _xConteudo)
			If !EOF()	
				_cOP	    := _xConteudo
				cEdit1    := _xConteudo
				nQtOper01 := SC2->C2_QUANT
				_nQuje    := SC2->C2_QUJE
				_nSaldo   := IIF(EMPTY(SC2->C2_DATRF) , SC2->C2_QUANT , SC2->C2_QUJE )
				
				SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
				SC5->(dbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
				
				_cPV      := IIF(!EMPTY(SC2->C2_PEDIDO) , SC2->C2_PEDIDO + "-" + SC2->C2_ITEMPV , "" )
				_cCliente := SC5->C5_CLNOMCL
				_cFamilia := SB1->B1_CLDFAM
				_cModelo  := LEFT(SB1->B1_DESC,40)
				_cPesoOk  := IIF(EMPTY(SB1->B1_COLOR) , "**" , "" )
				_dDatRf   := IIF(EMPTY(SC2->C2_DATRF).OR.SC2->C2_DATRF < dDatIni , ddatabase , SC2->C2_DATRF )
				nSemana   := ( _dDatRf - dDatPri )
				nSemana   := ( INT((nSemana/7)) + 1 )
				_cLote    := STRZERO(nSemana,2)+STRZERO(DAY(_dDatRf),2)+SUBS(DTOS(_dDatRf),3,2)
				
				////
				////Monta Historico de Operacao e os codigo de barra de cada operacao
				////
				aCols := {}
				aOper := {}
				DbSelectArea("SG2")
				DbSetOrder(3)
				DbSeek(xFilial("SG2")+SC2->C2_PRODUTO,.T.) 
				DO WHILE !EOF().AND.G2_FILIAL==xFilial("SG2").AND.G2_PRODUTO==SC2->C2_PRODUTO
					IF ( SG2->G2_CODIGO == "01" )
						AADD(aOper , { SG2->G2_OPERAC  , ;
											"1"				 , ;
											SG2->G2_DESCRI  , ;
											0.00            , ;
											0.00            , ;
											SPACE(8)        , ;
											SPACE(8)        , ;
											SPACE(8)        , ;
											SPACE(8)        , ;
											SPACE(15)       , ;
											SPACE(1)        , ;
											SG2->G2_TPLINHA } )
											
						cEdit7  := SG2->G2_RECURSO
						cEdit12 := SG2->G2_OPERAC
						cRtr    := "cRot"+RTRIM(SG2->G2_OPERAC)
						&cRtr   := "( ) "+RTRIM(SG2->G2_OPERAC)+"-"+RTRIM(SG2->G2_DESCRI)
					ENDIF	
					dbSkip()
				ENDDO	

				dbSelectArea("SH6")
				dbSetOrder(1)
				dbSeek(xFilial("SH6")+_cOP,.T.)
				DO WHILE !EOF().AND.H6_FILIAL==xFilial("SH6").AND.RTRIM(H6_OP)==RTRIM(_cOP)
					xcOperacao := SH6->H6_OPERAC
					xcOperador := SH6->H6_OPERADO
					xdDataIni  := SPACE(8)
					xcHoraIni  := SPACE(8)
					xcHoraFin  := SPACE(8)
					xn         := "0"
					DO WHILE !EOF().AND.H6_FILIAL==xFilial("SH6").AND.RTRIM(H6_OP)==RTRIM(_cOP).AND.H6_OPERAC==xcOperacao
						IF ( xcOperacao <> "99" )
							xdDataIni := DTOC(SH6->H6_DATAINI)   
							xcHoraIni := SH6->H6_HORAINI         
							xdDataFin := DTOC(SH6->H6_DATAFIN)
							xcHoraFin := SH6->H6_HORAFIN
							
							xn := SOMA1(xn,1)
							iw := ASCAN(aOper , { |xy| xy[1]+xy[2] == xcOperacao+xn } )
							IF ( iw = 0 )
								iw := ASCAN(aOper , { |xy| xy[1] == xcOperacao } )
								AADD(aOper , { xcOperacao   , ;
													xn  			 , ;
													aOper[iw,3]  , ;
													0.00         , ;
													0.00         , ;
													SPACE(8)     , ;
													SPACE(8)     , ;
													SPACE(8)     , ;
													SPACE(8)     , ;
													SPACE(15)    , ;
													SPACE(1)     , ;
													aOper[iw,12] } )
								iw := LEN(aOper)
							ENDIF
							aOper[iw,4]  := SH6->H6_X_QTE 
							aOper[iw,5]  := SH6->H6_X_QTS 
							aOper[iw,6]  := xdDataIni                     
							aOper[iw,7]  := xcHoraIni                      
							aOper[iw,8]  := xdDataFin                      
							aOper[iw,9]  := xcHoraFin                      
							aOper[iw,10] := SH6->H6_OPERADO
							aOper[iw,11] := SH6->H6_PT
						ENDIF
						dbSkip()
					ENDDO	
				ENDDO

				aSort(aOper,,, { |x,y| x[1]+x[2] < y[1]+y[2] } )

				lEncer := .T.
				ix     := 1
				DO WHILE ix<=LEN(aOper)
					nQtyE := 0
					nQtyS := 0
					cOpr  := aOper[ix,1]						
					xx    := ix
					DO WHILE ix<=LEN(aOper).AND.aOper[ix,1]==cOpr
						nQtyE += aOper[ix,4]
						nQtyS += aOper[ix,5]
						ix++
					ENDDO
					nQty := ( nQtOper01 - nQtyS )
					nXX  := 0
					DO WHILE xx < ix
						cLegenda := IIF(nQty == 0 , "1" ,IIF(( nQtyE + nQtyS ) == 0 , "2" , "3" ) )
						lEncer   := ( cLegenda == "1" )
						nXX++
						AADD(aCols , { cLegenda        , ; 
											aOper[xx,1]     , ; 
											aOper[xx,6]     , ; 
											aOper[xx,7]     , ; 
											aOper[xx,4]     , ;
											aOper[xx,8]     , ;
											aOper[xx,9]     , ;
											aOper[xx,5]     , ;
											aOper[xx,10]    , ;
											aOper[xx,1]+" - "+RTRIM(aOper[xx,3]) , ;
											nQty            , ;
											STRZERO(nXX,2)  , ;
											"00"            , ;
											aOper[xx,12] } )
						xx++
					ENDDO	
					aCols[xx-1,13] := "99"
					////
					////Exibe codigo de barras + Roteiro
					////
					cRtr := "oTBmp"+cOpr+":Show()"                 ///CODIGO DE BARRAS
					&cRtr
					cRtr := "oTBmp"+cOpr+":Refresh()"
					&cRtr						
					
					cRtr  := "oRot"+cOpr+":Show()"                 ///ROTEIRO
					&cRtr
					
					IF ( aCols[ix-1,1] == "1" )
						cRtr := "oTBmpOk"+RIGHT(cOpr,1)+":Show()"
						&cRtr
						cRtr := "oTBmp"+cOpr+":Disable()"
						&cRtr
					ENDIF	
				ENDDO
				
				/////
				/////Re-exibe objetos
				/////
				
				oGroup1:Hide()
				oEdit1:Hide()
				oNullo:Hide()

				f_Show()
																							
				oBrowse:SetArray(aCols)

				oBrowse:bLine := {|| { IIF(aCols[oBrowse:nAt,1]=="1",oVd,IIF(aCols[oBrowse:nAt,1]=="2",oVm,oAm)) , ;
											  aCols[oBrowse:nAt,2] , ;
											  aCols[oBrowse:nAt,3] , ;
											  aCols[oBrowse:nAt,4] , ;
											  aCols[oBrowse:nAt,5] , ;
											  aCols[oBrowse:nAt,6] , ;
											  aCols[oBrowse:nAt,7] , ;
											  aCols[oBrowse:nAt,8] , ;
											  aCols[oBrowse:nAt,9] } }
				oBrowse:lAdjustColsize := .F.
				oBrowse:Refresh()
				
				DbSelectArea("SB1")
				DbSetOrder(1)
				MsSeek(xFilial("SB1") + SC2->C2_PRODUTO )
				*					
				_nQtde  := SC2->C2_QUANT
				///_nQuje  := IIF(EMPTY(SC2->C2_DATRF) , SC2->C2_QUANT , SC2->C2_QUJE )
				_cProd  := Alltrim(SC2->C2_PRODUTO) 
				_cDesc  := LEFT(SB1->B1_DESC,50)
				
			Else
				MsgStop("Ordem de ProduÁ„o N√O Encontrada!","AtenÁ„o")
				_lRet := .f.
			EndIf
		ENDIF
		
EndCase

Return(_lRet)

//////////////////////////////////////////////////////////////////////////////
Static Function f_Hide()
//////////////////////////////////////////////////////////////////////////////

oGroup2:Hide()
oGroup3:Hide()
oGroup4:Hide()
oGroup5:Hide()
oGroup6:Hide()	
oGroup7:Hide()	
oNumero:Hide()
oQtdPed:Hide()
oQtyPed:Hide()
oNOP:Hide()
oQtdEnt:Hide()
oQtyEnt:Hide()
oProdDesc:Hide()
oProduto:Hide()
oDescri:Hide()
oTBitmap3:Hide()
oTBitmap4:Hide()
oBrowse:Hide()
oTBmp01:Hide()
oTBmp02:Hide()
oTBmp03:Hide()
oTBmp04:Hide()
oTBmp05:Hide()
oTBmp06:Hide()
oTBmp07:Hide()
oTBmp08:Hide()
oTBmpOk1:Hide()
oTBmpOk2:Hide()
oTBmpOk3:Hide()
oTBmpOk4:Hide()
oTBmpOk5:Hide()
oTBmpOk6:Hide()
oTBmpOk7:Hide()
oTBmpOk8:Hide()
oRot01:Hide()
oRot02:Hide()
oRot03:Hide()
oRot04:Hide()
oRot05:Hide()
oRot06:Hide()
oRot07:Hide()
oRot08:Hide()
oQtyEmb:Hide()
oQtdEmb:Hide()
oQtyEtq:Hide()
oQtdEtq:Hide()
oEtqImp:Hide()
oPrdImp:Hide()
oEtqImpQ:Hide()
oPrdImpQ:Hide()

Return
	
//////////////////////////////////////////////////////////////////////////////
Static Function f_Show()
//////////////////////////////////////////////////////////////////////////////

oGroup2:Show()
oGroup3:Show()
oGroup4:Show()
oGroup5:Show()
oGroup6:Show()	
oGroup7:Show()	
oNumero:Show()
oQtdPed:Show()
oQtyPed:Show()
oNOP:Show()
oQtdEnt:Show()
oQtyEnt:Show()
oProdDesc:Show()
oProduto:Show()
oDescri:Show()
oTBitmap3:Show()
oTBitmap4:Show()
oBrowse:Show()
oQtyEmb:Show()
oQtdEmb:Show()
oQtyEtq:Show()
oQtdEtq:Show()
oEtqImp:Show()
oPrdImp:Show()
oEtqImpQ:Show()
oPrdImpQ:Show()

Return	

***************************
Static Function ValidPerg()
***************************
Local i
Local j 

DbSelectArea("SX1")
DbSetOrder(1)
aRegs := {} //Grupo|Ordem| Pegunt                        | perspa | pereng | VariaVL  | tipo| Tamanho|Decimal| Presel| GSC | Valid         |   var01   | Def01             | DefSPA1 | DefEng1 | CNT01               | var02 | Def02     | DefSPA2 | DefEng2 | CNT02 | var03 | Def03    | DefSPA3 | DefEng3 | CNT03 | var04 | Def04 | DefSPA4 | DefEng4 | CNT04 | var05 | Def05 | DefSPA5 | DefEng5 | CNT05 | F3    | GRPSX5 |
aAdd(aRegs,{ cPerg,"01" , "Coluna inicial              ?",   ""   ,  ""    , "mv_ch1" , "N" ,   02   ,   0   ,   0   , "G" , "          "  , "mv_par01", "               " , "     " , "     " , "0                " , "   " , "       " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
aAdd(aRegs,{ cPerg,"02" , "ResoluÁ„o da Impressora     ?",   ""   ,  ""    , "mv_ch2" , "N" ,   01   ,   0   ,   1   , "C" , "          "  , "mv_par02", "203DPI         " , "     " , "     " , "                 " , "   " , "300DPI " , "     " , "     " , "   " , "   " , "      " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })

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
