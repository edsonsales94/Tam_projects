#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "JPEG.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CApt_Oper ³ Autor ³ Carlos Nina           ³ Data ³20/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Apontamento de Producao Via Leitura De Cod. De Barras.     ³±±
±±³          ³ por operacao                                               ³±±
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
User Function CApt_Op2()

Local _aArea := GetArea()
Local dData1 := GETMV('MV_ULMES')
Local dData2 := GETMV('MV_DBLQMOV')
Local cLogo  := FisxLogo("1")
Local cNullo := " "

Private oVd  := LoadBitmap( GetResources(), 'br_verde')
Private oVm  := LoadBitmap( GetResources(), 'br_vermelho')
Private oAm  := LoadBitmap( GetResources(), 'br_amarelo')

Private oEdit0,oEdit1,oEdit2,oEdit5,oEdit6,oEdit7,oEdit10,oEmissao
Private oGroup1,oGroup2,oGroup3,oGroup4,oGroup5,oGroup6,oGroup7,oGroup8,oGroup9,oGroupA,oGroupB,oTBar,oButton,oTimer,oEmpC
Private oAviso1,oAviso2,oAviso3,oCodigo,oCodPro,oDescC,oDescG,oSdoEstC,oSdoEstG,oEstDispC,oEstDispG,oEstEmpC,oEstEmpG,o_UMC,o_UMG,o_TipoC,o_TipoG
Private oLbl5,oBold,oNullo2
Private oBrowse,oEmpenho,oAptH
Private oTBitMap1,oTBitMap2,oTBitMap3,oTBitMap4,oTBmp1,oTBmp2,oTBmp3,oTBmp4,oTBmp5
Private oTBmp01,oTBmp02,oTBmp03,oTBmp04,oTBmp05,oTBmp06,oTBmp07,oTBmp08,oTBmpOk1,oTBmpOk2,oTBmpOk3,oTBmpOk4,oTBmpOk5,oTBmpOk6,oTBmpOk7,oTBmpOk8
Private oCracha,oOperac,oUsuario,oOperacao,oRecurso,oNumero,oNOP,oProdDesc,oProduto,oDescri,oObs,oObserv,oAlmox,oLocal
Private oQtdPed,oQtyPed,oQtdEnt,oQtyEnt,oQtdSdo,oQtySdo,oSequen,oQty,oData,oHorario,oHora,oCTrab,oNullo,oOP2
Private oRot01,oRot02,oRot03,oRot04,oRot05,oRot06,oRot07,oRot08

Private cSetor,cOperI,cOperF,cOperacao,dUltApt

Private nConsulta  := 0                                ///Seleção das telas: 0=Apontamento;1=Consulta Estoque;2=Empenho;3=Historico Apontamento Produto
Private lEstNeg 	 := ( GETMV("MV_ESTNEG") == "N" )
Private dDatIni    := ( GETMV('MV_ULMES') + 1 )
Private dDatFin    := LastDay(dDatIni)
Private mvLocPad   := IIF(M->cNumEmp=="0301","02","01")    
Private mvRecurso  := "050"                                                         ///Codigo Recurso Expediçao Manaus
Private lEncerrada := .F.
Private cEdit0     := Space(9)
Private cEdit1		 := Space(8)
Private cEdit2		 := 0
Private cEdit4		 := ""
Private cEdit5		 := Space(2)
Private cEdit6		 := Space(10)
Private cEdit7		 := Space(6)
Private cEdit8		 := Space(5)
Private cEdit9		 := Space(5)
Private cEdit10	 := Space(7)
Private cEdit11	 := 0
Private cEdit12    := "00"
Private cOperacao  := ""

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

Private _cTpLinha  := Space(1)
Private _cOp	    := Space(11)
Private cOP2       := Space(11)
Private cCTrab     := Space(25)
Private _nQuant	 := 0
Private _cProd	    := Space(60)
Private _cCod	    := Space(30)
Private _cDesc     := Space(200)
Private _cObs      := Space(40)
Private _cUm	    := Space(2)
Private _cAlmox	 := Space(2)
Private _nQtde     := 0
Private _nQuje     := 0
Private _nSaldo    := 0
Private cCodPro    := Space(30)
Private mCodPro    := cCodPro
Private cDescric   := Space(60)
Private c_UM       := Space(2)
Private c_Tipo     := Space(2)
Private nSdoEst    := 0
Private nEstDisp   := 0
Private nEstEmp    := 0
Private cNullo2    := " "

Private _nAviso    := 0
Private _cAviso1   := SPACE(80)
Private _cAviso2   := SPACE(80)
Private _cAviso3   := SPACE(80)
Private _xOpc	    := 1
Private dDatFech   := IIF(dData2 > dData1 , dData2 , dData1 )
Private nTimeOut   := 120000
Private dEmissao   := ddatabase
Private mdEmissao  := ddatabase

Private aRet  := FwTimeUF("AM",,.T.)                              ///aRet[1] = 20140227  ; aRet[2] = 17:32:33
		
Private cHora := aRet[2]

Private nQtOper01
Private _oDlg				// Dialog Principal
Private INCLUI       := .F.	// (na Enchoice) .T. Traz registro para Inclusao / .F. Traz registro para Alteracao/Visualizacao
Private _nHRes 		:= oMainWnd:nClientWidth
Private _cTheme		:= Alltrim(GetTheme())
Private _lMdiChild	:= SetMdiChild()
Private lEmProcesso  := .F.
Private lSaida       := .F.
Private aEntSai      := {"       ","ENTRADA","SAIDA  "}
Private aEmpenho     := { {"","","","",0,0,0} }
Private aApth        := { {"","","",0,""} }
Private aEmpC        := { {SPACE(8),SPACE(13),0,0,SPACE(30),SPACE(60)} }
Private aCols        := { {"2","","","",0,"","",0,""} }
Private aHeader      := {}

Private aMsg      	:= { {" " , ""} , ;
								  {"Falta selecionar o tipo de apontamento: Entrada / Saida."          , ""} , ;
								  {" "                                                                 , ""} , ;
								  {"Ordem de Produção inválida para apontamento."                      , "Favor contactar o responsavel pela abertura da OP"} , ;
								  {"Operação de Entrada para este roteiro já foi efetuado."            , "Favor verificar a operação correta!"} , ;
								  {"Operação anterior ainda não foi fechada (Qty.Saída) ou quantidade" , "informada nesta operação é maior que a qtde.da operação anterior."} , ;
								  {"Falta fazer o fechamento (Apontamento de Saída) nesta Operação."   , "Favor verificar o histórico de apontamento."} , ;
								  {"A Separação de Materiais ainda não foi Apontada."                  , ""} , ;
								  {"Quantidade informada é maior que a quantidade produzida"           , "na operação anterior."} , ;
								  {"Quantidade parcial NÃO permitida para esta Operação."              , ""} , ;
								  {"O.P já se encontra ENCERRADA"                                      , ""} , ;   
								  {"Não existe quantidade suficiente em estoque para atender"          , "esta requisição."} , ;
								  {"Usuário sem permissão para apontar esta Operação."                 , ""} , ;
								  {"Operação Sem Saldo para apontamento!"                              , ""} , ;
								  {"Não é permitido apontamento parcial."                              , "Favor verificar a quantidade de entrada desta operação"} , ;
								  {"Não existe apontamento de Entrada para esta quantidade!"           , "Favor apontar a operação de entrada."} , ;
								  {"Não existe apontamento de Entrada para esta operação!"             , "Favor obedecer a sequencia ou roteiro de operação p/apontamento."} , ;
								  {"Capacidade de Entrada desta Operação já está totalizada."          , ""} , ;
								  {"Operação de Entrada NÃO apontada!"                                 , ""} , ;
								  {"Operação de Saida NÃO apontada!"                                   , ""} , ;
								  {"Corrija o erro apresentado."                                       , ""} , ;
								  {"Quantidade informada inválida: Menor ou igual a 0 (zero)."         , ""} , ;
								  {"Não é permitido a Data de Apontamento anterior a Data do Ultimo"   , "Fechamento de Estoque."} , ;
								  {"Usuário SEM PERMISSÃO para apontar esta Operação."                 , ""} }

AADD(aHeader,{"Componente"                       , "C7_NUMSC  " ,"@!               " ,30,0, "                               ","€€€€€€€€€€€€€€ ","C"," "," "})
AADD(aHeader,{"Descrição"                        , "C7_NUMSC  " ,"@!               " ,40,0, "                               ","€€€€€€€€€€€€€€ ","C"," "," "})
AADD(aHeader,{"Tipo"                             , "C7_NUMSC  " ,"@!               " ,02,0, "                               ","€€€€€€€€€€€€€€ ","C"," "," "})
AADD(aHeader,{"U.M."                             , "C7_NUMSC  " ,"@!               " ,02,0, "                               ","€€€€€€€€€€€€€€ ","C"," "," "})
AADD(aHeader,{"Local"                            , "C7_NUMSC  " ,"@!               " ,02,0, "                               ","€€€€€€€€€€€€€€ ","C"," "," "})
AADD(aHeader,{"Qtde.OP"                          , "C7_NUMSC  " ,"@E 99999999.99   " ,12,2, "                               ","€€€€€€€€€€€€€€ ","N"," "," "})
AADD(aHeader,{"Qtde.Paga"                        , "B2_QFIM   " ,"@E 99999999.99   " ,12,2, "ExecBlock('CAPT_SCP',.F.,.F.)  ","€€€€€€€€€€€€€€ ","N"," "," "})
								  
DEFINE FONT 	oBold NAME "Times New Roman"	SIZE 0,  18 BOLD  
DEFINE FONT 	oFnt  NAME "Arial"				SIZE 0, -16 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt4 NAME "Arial"				SIZE 0, -20 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt3 NAME "Arial"				SIZE 0, -18 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt2 NAME "Arial"				SIZE 0, -14 BOLD	// "Times New Roman" Menor

oFnt12 := TFont():New('Courier new',,-12,.T.)

dbSelectArea("SB1")   ///Produtos
dbSetOrder(1)
*
dbSelectArea("SB2")   ///Estoque
dbSetOrder(1)
*
dbSelectArea("SH1")   ///Recursos
dbSetOrder(1)
*
dbSelectArea("SX5")   ///Tabelas
dbSetOrder(1)
		
DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Apontamento De OP's Por Operação") FROM 000,000 TO 526,984 COLORS 0, 16777215 PIXEL

oTBar := TBar():New( _oDlg,40,25,.T.,,,'tbar_coel',.F. )   ///40,25

oTimer := TTimer():New(nTimeOut,{|| f_timer() },_oDlg)	

@ 015, 002 GROUP oGroup1 TO 083, 241 PROMPT OemToAnsi("IDENTIFICAÇÃO")    						  OF _oDlg COLOR 0, 16777215 PIXEL
@ 015, 109 GROUP oGroup2 TO 075, 490 PROMPT OemToAnsi("ORDEM DE PRODUÇÃO")						  OF _oDlg COLOR 0, 16777215 PIXEL
@ 015, 002 GROUP oGroup7 TO 256, 106 PROMPT OemToAnsi("OPERAÇÃO")        						  OF _oDlg COLOR 0, 16777215 PIXEL
@ 015, 109 GROUP oGroup3 TO 075, 490 PROMPT OemToAnsi("DADOS DA OPERAÇÃO")						  OF _oDlg COLOR 0, 16777215 PIXEL
@ 077, 109 GROUP oGroup4 TO 220, 490 PROMPT OemToAnsi("HISTÓRICO DE APONTAMENTO")			  OF _oDlg COLOR 0, 16777215 PIXEL
@ 222, 109 GROUP oGroup5 TO 256, 490 PROMPT OemToAnsi("MENSAGEM")         						  OF _oDlg COLOR 0, 16777215 PIXEL	
@ 18.5,302 GROUP oGroup6 TO 060, 303 PROMPT ""                         						  	  OF _oDlg COLOR 0, 16777215 PIXEL	

@ 024, 004 SAY   oCracha		PROMPT  OemToAnsi("Crachá")        					SIZE 080, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt
@ 024, 125 SAY   oUsuario  	PROMPT  OemToAnsi("Usuário")       					SIZE 040, 009 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt
@ 033, 004 MSGET oEdit0 		VAR     cEdit0    PASSWORD       					SIZE 040, 014 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt4  Valid(_fVlDlg("MATR",cEdit0))
@ 033, 125 MSGET oEdit6 		VAR     cEdit6    PICTURE "@!"   					SIZE 090, 014 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt4  WHEN (cSetor=="01")
@ 053, 004 SAY   oOperacao	   PROMPT  OemToAnsi("Ordem de Produção")				SIZE 090, 009 OF _oDlg COLORS 16744448, 16777215 PIXEL Font oFnt
@ 063, 004 MSGET oEdit1 		VAR     cEdit1    PICTURE "@R XXXXXX.XX"       	SIZE 060, 014 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt4  VALID (_fVlDlg("CBAR",cEdit1))
@ 069, 076 MSGET oNullo 		VAR     cNullo                               	SIZE 001, 004 OF _oDlg COLORS 0, 16777215 PIXEL                     

@ 022, 111 SAY   oNumero		PROMPT  OemToAnsi("Número")        					SIZE 060, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 022, 307 SAY   oQtdPed		PROMPT  "Quant. Pedida:"          					SIZE 070, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 022, 385 SAY   oQtyPed		VAR     _nQtde    PICTURE "@E 99,999" 				SIZE 030, 012 OF _oDlg COLOR  CLR_HRED    PIXEL  Font oFnt
@ 030, 111 SAY   oNOP   		VAR     _cOP      PICTURE "@R XXXXXX.XX.999"		SIZE 080, 012 OF _oDlg COLOR  CLR_HRED    PIXEL  Font oFnt4
@ 036, 307 SAY   oQtdEnt  		PROMPT  "Quant. Produzida:"      					SIZE 070, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 036, 385 SAY   oQtyEnt 		VAR     _nQuje    PICTURE "@E 99,999"				SIZE 030, 012 OF _oDlg COLOR  CLR_HRED    PIXEL  Font oFnt
@ 044, 111 SAY   oProdDesc		PROMPT  OemToAnsi("Produto / Descrição")			SIZE 120, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 049, 307 SAY   oQtdSdo		PROMPT  "Quant. a Produzir:"     					SIZE 070, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 049, 385 SAY   oQtySdo		VAR     _nSaldo   PICTURE "@E 99,999"				SIZE 030, 012 OF _oDlg COLOR  CLR_HRED    PIXEL  Font oFnt
@ 053, 111 SAY   oProduto 		VAR     _cProd                   					SIZE 130, 014 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4
@ 065, 111 SAY   oDescri		VAR     _cDesc                   					SIZE 240, 014 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt

@ 229,111 Say oAviso1         Var OemToAnsi(_cAviso1)                         Size 300,009  Color CLR_BLUE   Font oFnt2 PIXEL OF _oDlg
@ 238,111 Say oAviso2         Var OemToAnsi(_cAviso2)                         Size 300,009  Color CLR_BLUE   Font oFnt2 PIXEL OF _oDlg
@ 247,111 Say oAviso3         Var OemToAnsi(_cAviso3)                         Size 300,009  Color CLR_BLUE   Font oFnt2 PIXEL OF _oDlg
 
@ 023, 111 SAY   oOperac 		PROMPT  OemToAnsi("Operação:")     					SIZE 040, 009 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt
@ 023, 159 SAY   oEdit5 		VAR     cOperacao                					SIZE 150, 014 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4
@ 023, 306 SAY   oOP2   		VAR     cOP2                                 	SIZE 100, 014 OF _oDlg COLOR  CLR_HRED    PIXEL  Font oFnt4
@ 035, 111 SAY   oSequen		PROMPT  OemToAnsi("Sequência:")    					SIZE 044, 009 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt
@ 035, 306 SAY   oCTrab 		VAR     cCTrab                               	SIZE 100, 014 OF _oDlg COLOR  CLR_HRED    PIXEL  Font oFnt4
@ 035, 159 SAY   oEdit10		VAR     cEdit10                  					SIZE 050, 012 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4
@ 047, 111 SAY   oData  		PROMPT  "Data"                   					SIZE 020, 009 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt          ///320
@ 047, 204 SAY   oQty   		PROMPT  "Quantidade"             					SIZE 055, 009 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt          ///247
@ 047, 274 SAY   oHorario		PROMPT  "Hora"                   					SIZE 020, 009 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt
@ 056, 111 MSGET oEmissao		VAR     dEmissao                 					SIZE 060, 014 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt4 Valid(_fVlDlg("DEMIS",dEmissao)) WHEN lEmProcesso
@ 056, 204 MSGET oEdit2 		VAR     cEdit2    PICTURE "@E 99,999"				SIZE 035, 014 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt4 Valid(_fVlDlg("QTDE",cEdit2))    WHEN lEmProcesso
@ 056, 274 MSGET oHora  		VAR     cHora                       				SIZE 020, 014 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt4 WHEN .F.

DEFINE SBUTTON oButton FROM 065,190 TYPE 2 ENABLE OF _oDlg Action Eval( { || f_cancela() } )

oTBitmap3 := TBtnBmp2():New( 070, 0904, 70, 30,'conf_coel',,,,;   
					{ || f_confirma() }  ,_oDlg,'Confirma apontamento',,.F.,.F.)
oTBitmap4 := TBtnBmp2():New( 038, 0904, 70, 30,'canc_coel',,,,;
					{ || f_cancela() } , _oDlg,'Cancela apontamento',,.F.,.F.)
oTBitmap5 := TBtnBmp2():New( 089, 0904, 70, 30,'coel_empenho',,,,;
					{ || f_empenho() } , _oDlg,'Itens da Ordem de Produção',,.F.,.F.)
oTBitmap6 := TBtnBmp2():New( 120, 0904, 70, 30,'coel_aptop',,,,;
					{ || f_aptop() } , _oDlg,'Histórico de apontamento: Produção Realizada',,.F.,.F.)

oBrowse := TCBrowse():New( 84 , 111, 377, 134,,{'','OPER.','DT.ENTRADA','HR.ENTRADA','QTD.ENTRADA','DT.SAIDA','HR.SAIDA','QTD.SAIDA','OPERADOR'},{20,26,36,38,42,30,34,34,50},_oDlg,,,,,{||},,,,,,"Legenda",.F.,,.T.,,.F.,,, )	

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
///oBrowse:lAdjustColsize := .F.
///oBrowse:Refresh()

oTBitmap1 := TBtnBmp2():New( 00, 00, 40, 70, 'S4WB008N' ,,,,;
					{ || Calculadora() }  ,oTBar,'Calculadora',,.F.,.F.)
oTBitmap7 := TBtnBmp2():New( 00, 00, 40, 70, 'S4WB007N' ,,,,;
					{ || f_consestoq() }  ,oTBar,'Consulta Saldo em Estoque',,.F.,.F.)
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
					{ || _fVlDlg("CBAROPER","01") }  ,_oDlg,,,.T.,.T.)
oTBmp02 := TBtnBmp2():New( 115, 002, 196, 40,'coel_op02',,,,;
					{ || _fVlDlg("CBAROPER","02") } , _oDlg,,,.T.,.T.)
oTBmp03 := TBtnBmp2():New( 172, 004, 196, 40,'coel_op03',,,,;
					{ || _fVlDlg("CBAROPER","03") }  ,_oDlg,,,.T.,.T.)
oTBmp04 := TBtnBmp2():New( 227, 004, 196, 40,'coel_op04',,,,;
					{ || _fVlDlg("CBAROPER","04") } , _oDlg,,,.T.,.T.)
oTBmp05 := TBtnBmp2():New( 282, 004, 196, 40,'coel_op05',,,,;
					{ || _fVlDlg("CBAROPER","05") }  ,_oDlg,,,.T.,.T.)
oTBmp06 := TBtnBmp2():New( 336, 004, 196, 40,'coel_op06',,,,;
					{ || _fVlDlg("CBAROPER","06") } , _oDlg,,,.T.,.T.)
oTBmp07 := TBtnBmp2():New( 392, 004, 196, 40,'coel_op07',,,,;
					{ || _fVlDlg("CBAROPER","07") }  ,_oDlg,,,.T.,.T.)
oTBmp08 := TBtnBmp2():New( 449, 004, 196, 40,'coel_op08',,,,;
					{ || _fVlDlg("CBAROPER","08") } , _oDlg,,,.T.,.T.)
					
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////                 C O N S U L T A S
////

@ 077, 109 GROUP oGroup8 TO 256, 490 PROMPT OemToAnsi("COMPONENTE")       						  OF _oDlg COLOR 0, 16777215 PIXEL
@ 077, 109 GROUP oGroup9 TO 256, 490 PROMPT OemToAnsi("PRODUÇÃO REALIZADA DO PRODUTO")		  OF _oDlg COLOR 0, 16777215 PIXEL
@ 015, 002 GROUP oGroupA TO 114, 490 PROMPT OemToAnsi("CONSULTA SALDO EM ESTOQUE")			  OF _oDlg COLOR 0, 16777215 PIXEL
@ 120, 002 GROUP oGroupB TO 256, 490 PROMPT OemToAnsi("DETALHE DO EMPENHO")       			  OF _oDlg COLOR 0, 16777215 PIXEL

@ 023, 004 SAY   oCodigo		PROMPT  OemToAnsi("Código")        					SIZE 060, 010 OF _oDlg COLOR  CLR_HBLUE   PIXEL  Font oFnt
@ 032, 004 MSGET oCodPro		VAR     cCodPro   PICTURE "@!"    F3 "SB1"  		SIZE 150, 010 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt4 VALID f_produto()
@ 034, 156 MSGET oNullo2		VAR     cNullo2                              	SIZE 001, 001 OF _oDlg COLORS 0, 16777215 PIXEL                     
@ 050, 004 SAY   oDescC   		PROMPT  OemToAnsi("Descrição")						SIZE 120, 010 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 060, 004 MSGET oDescG 		VAR     cDescric                 					SIZE 360, 014 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4 WHEN .F.
@ 050, 370 SAY   o_UMC    		PROMPT  OemToAnsi("U.M.")     						SIZE 030, 010 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 060, 370 MSGET o_UMG  		VAR     c_UM                     					SIZE 020, 014 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4 WHEN .F.
@ 050, 404 SAY   o_TipoC  		PROMPT  OemToAnsi("Tipo")     						SIZE 030, 010 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 060, 404 MSGET o_TipoG		VAR     c_Tipo                   					SIZE 020, 014 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4 WHEN .F.

@ 082, 004 SAY   oSdoEstC 		PROMPT  "Saldo Atual"                     		SIZE 080, 010 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4
@ 094, 004 MSGET oSdoEstG  	VAR     nSdoEst   PICTURE "@E 999999,999"  		SIZE 080, 014 OF _oDlg COLOR  CLR_HRED    PIXEL  Font oFnt4 WHEN .F.
@ 082, 120 SAY   oEstEmpC 		PROMPT  "Empenho"                         		SIZE 070, 012 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4
@ 094, 120 MSGET oEstEmpG  	VAR     nEstEmp   PICTURE "@E 999999,999"  		SIZE 080, 014 OF _oDlg COLOR  CLR_HRED    PIXEL  Font oFnt4 WHEN .F.
@ 082, 230 SAY   oEstDispC		PROMPT  "Estoque Disponível"              		SIZE 120, 012 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4
@ 094, 230 MSGET oEstDispG 	VAR     nEstDisp  PICTURE "@E 999999,999"  		SIZE 110, 014 OF _oDlg COLOR  CLR_HRED    PIXEL  Font oFnt4 WHEN .F.

oEmpenho := TCBrowse():New( 84 , 111, 377, 170,,{'CODIGO','DESCRIÇÃO','TIPO','UM','QTD.EMP','SDO.ESTOQUE','EST.DISPONIVEL'},{55,80,15,15,30,45,40},_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	

oEmpenho:SetArray(aEmpenho)

oEmpenho:bLine := {|| {aEmpenho[oEmpenho:nAt,1] , ;
							  aEmpenho[oEmpenho:nAt,2] , ;
							  aEmpenho[oEmpenho:nAt,3] , ;
							  aEmpenho[oEmpenho:nAt,4] , ;
							  aEmpenho[oEmpenho:nAt,5] , ;
							  aEmpenho[oEmpenho:nAt,6] , ;
							  aEmpenho[oEmpenho:nAt,7] } }
///oEmpenho:lAdjustColsize := .F.
///oEmpenho:Refresh()

oAptH := TCBrowse():New( 084 , 111, 254, 170,,{'DATA','HORA','O.P.','QTDE.','OPERADOR'},{40,40,50,40,60},_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	

oAptH:SetArray(aAptH)

oAptH:bLine := {|| { aAptH[oAptH:nAt,1] , ;
							aAptH[oAptH:nAt,2] , ;
							aAptH[oAptH:nAt,3] , ;
							aAptH[oAptH:nAt,4] , ;
							aAptH[oAptH:nAt,5] } }
oAptH:lAdjustColsize := .F.
oAptH:Refresh()

oEmpC := TCBrowse():New( 128 , 004, 483, 126,,{'DATA','O.P.','QTDE.ORIGINAL','SALDO','USADO EM...','DESCRIÇÃO'},{40,60,50,50,60,90},_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	

oEmpC:SetArray(aEmpC)

oEmpC:bLine := {|| { aEmpC[oEmpC:nAt,1] , ;
							aEmpC[oEmpC:nAt,2] , ;
							aEmpC[oEmpC:nAt,3] , ;
							aEmpC[oEmpC:nAt,4] , ;
							aEmpC[oEmpC:nAt,5] , ;
							aEmpC[oEmpC:nAt,6] } }
oEmpC:lAdjustColsize := .F.
oEmpC:Refresh()
					
/////
/////Oculta objetos
/////
f_Hide()

oEdit0:SetFocus()	
oEdit1:Disable()
oNullo:Disable()
oButton:Hide()

ACTIVATE MSDIALOG _oDlg CENTER Valid lSaida
	
RestArea(_aArea)

Return

///////////////////////////////////////////////////////////
Static Function f_Saida()
///////////////////////////////////////////////////////////
Local lRsp := lEmProcesso

IF ( lRsp )

	lRsp := MsgBox("Deseja realmente sair da Rotina?","Escolha a opção","YESNO")
	
ENDIF

IF ( lRsp .OR. !lEmProcesso )
	lSaida := .T.
	_oDlg:End()
ENDIF

Return(lRsp)

///////////////////////////////////////////////////////////
Static Function f_timer()
///////////////////////////////////////////////////////////
Local _nX,_nW

oTimer:DeActivate()

_xOpc  := 2

dEmissao  := ddatabase
mdEmissao := ddatabase

f_Hide()

_cAviso1 	:= ""
_cAviso2 	:= ""
_cAviso3 	:= ""
_nAviso     := 0
cSetor      := "01"
cEdit0      := SPACE(9)
cEdit6      := SPACE(10)
cEdit1      := SPACE(8)
lEmProcesso := .F.

oGroup1:Show()
oCracha:Show()
oUsuario:Show()
oEdit0:Show()
oEdit6:Show()
oOperacao:Show()
oEdit1:Show()

oNullo:Show()
oNullo:Disable()
oEdit1:Disable()
oEdit0:Enable()
oEdit0:SetFocus()
oAviso1:Refresh()
oAviso2:Refresh()
oAviso3:Refresh()

FOR _nX:=1 TO 8
	 _nW := ASCAN(aCols , { |xy| xy[2]==STRZERO(_nX,2) } )			
	 IF ( _nW > 0 )
		 cRtr := "oTBmp"+aCols[_nW,2]+":Enable()"
		 &cRtr
	 ENDIF
NEXT

Return

///////////////////////////////////////////////////////////
Static Function f_confirma()
///////////////////////////////////////////////////////////
Local _xOper,ix,nx,xx,_nW,_nX,nQty
Local _cTLin
Local xHora
Local lEncer
Local _nEncer := 0

MsgRun("Aguarde... Apontando OP... ",,{ || _fExecAp1(cEdit1,cEdit2) } )

IF _xOpc > 1
	_nAviso  := 1
	_cAviso1 := "ATENÇÃO!!!  "+IIF(LEFT(cEdit10,1)=="E" , aMsg[19,1] , aMsg[20,1] )
	_cAviso2 := aMsg[_xOpc,1]
	_cAviso3 := aMsg[_xOpc,2]
ELSEIF ( _xOpc == 1 )
	////
	////Atualiza browse do Historico de Apontamento
	////
	xx     := ASCAN(aCols , { |x| x[2]+x[13] == cEdit5+"99" } )              ////Primeiro item da operacao selecionada
	nQty   := aCols[xx,11]                                                   ////Salva o saldo da operacao: qty.OP (C2_QUANT) - qty.saida (H6_X_QTS) 
	_cTLin := aCols[xx,14]                                                   ////A ser definido tratamento dessa informacao pra nao fazer critica de saldo em estoque

	_xOper := STRZERO( ( VAL(cEdit5) + 1 ) , 2 )                             ////Primeiro item da operacao seguinte
	_xOpc  := ASCAN(aCols , { |x| x[2] == _xOper } )                         ////Pesquisa na tabela a operacao seguinte
	_xOpc  := IIF(_xOpc==0 , LEN(aCols) , ( _xOpc - 1 ) )                    ////Se nao encontrar, pega o ultimo item da operacao selecionada. senao, pega o item anterior da operacao selecionada
	lEncer := ( aCols[_xOpc,5] == aCols[_xOpc,8] .AND. aCols[_xOpc,5] > 0 )  ////Verifica se Qty. de Entrada e Saida sao iguais como criterio pra incluir novo item
	cSq1   := aCols[_xOpc,12]        	                                     ////Salva a ultima sequencia de apontamento da operacao selecionada (Ex.: 03.1,03.2,...03c...)
	cSq2   := Soma1(cSq1,2)	                                                 ////Sequencia de apontamento de uma mesma operacao.
	
	IF ( LEFT(cEdit10,1) == "E" )                                            ////Operacao de Entrada
		IF ( lEncer )
			aCols[_xOpc,13] := "00"
			AADD(aCols , { "3"               , ;
								LEFT(cOperacao,2) , ;
								DTOC(dEmissao)    , ;
								cHora             , ;
								cEdit2            , ;
								DTOC(dEmissao)    , ;
								SPACE(5)          , ;
								0                 , ;
								cEdit6            , ;
								cOperacao         , ;
								nQty              , ;
								cSq2              , ;
								"99"              , ;
								_cTLin } )

			aSort(aCols,,, { |x,y| x[2]+x[12] < y[2]+y[12] } )
			
		ELSE
			aCols[_xOpc,3] := DTOC(dEmissao)
			aCols[_xOpc,4] := cHora
			aCols[_xOpc,5] := cEdit2
			aCols[_xOpc,6] := DTOC(dEmissao)
			aCols[_xOpc,9] := cEdit6
		ENDIF
	ELSE
		nQty -= cEdit2
		///nQty := ( nQty + nQtyE - cEdit2 )
		IF ( RTRIM(cEdit7) $ "010/070/040/080" )
			IF ( nQty > 0 )
				xHora        := aCols[xx,4]
				xData        := aCols[xx,3]
				aCols[xx,3]  := DTOC(dEmissao)
				aCols[xx,4]  := cHora
				aCols[xx,12] := cSq2
				aCols[xx,13] := "99"
				aCols[xx,5]  -= cEdit2
				aCols[xx,6]  := DTOC(dEmissao)
				
				AADD(aCols , { "3"               , ;
									LEFT(cOperacao,2) , ;
									xData             , ;     //DTOC(dEmissao)    , ;
									xHora             , ;
									cEdit2            , ;
									DTOC(dEmissao)    , ;
									cHora             , ;
									cEdit2            , ;
									cEdit6            , ;
									cOperacao         , ;
									nQty              , ;
									cSq1              , ;
									"00"              , ;
									_cTLin } )

				aSort(aCols,,, { |x,y| x[2]+x[12] < y[2]+y[12] } )

			ELSE
				aCols[xx,6] := DTOC(dEmissao)
				aCols[xx,7] := cHora
				aCols[xx,8] += cEdit2
				aCols[xx,9] := cEdit6
			ENDIF
		ELSE
			aCols[_xOpc,6] := DTOC(dEmissao)
			aCols[_xOpc,7] := cHora
			aCols[_xOpc,8] += cEdit2
			aCols[_xOpc,9] := cEdit6
		ENDIF
	ENDIF

	IF ( cEdit5 == cEdit12 )
		IF ( !RTRIM(cEdit7) $ "010/070/040/080" )
			IF ( LEFT(cEdit10,1) == "E" )
				_nQuje  += cEdit2
				_nSaldo := ( _nQtde - _nQuje )
			ENDIF
		ELSE	
			IF ( LEFT(cEdit10,1) == "S" )
				_nQuje  += cEdit2
				_nSaldo := ( _nQtde - _nQuje )
			ENDIF
		ENDIF
	ENDIF
	
	////
	////Atualiza status do historico de apontamento da operacao selecionada
	////
	xx := ASCAN(aCols , { |x| x[2] == cEdit5 } )                                ////Primeiro item da operacao selecionada
	DO WHILE xx<=LEN(aCols).AND.aCols[xx,2]==cEdit5
		aCols[xx,1]  := IIF(nQty = 0 , "1" , "3" )
		aCols[xx,11] := nQty
		xx++
	ENDDO
	
	IF ( nQty = 0 )
		cRtr := "oTBmpOk"+RIGHT(cEdit5,1)+":Show()"
		&cRtr
		cRtr := "oTBmp"+cEdit5+":Disable()"
		&cRtr		
	ENDIF	

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
	
	oGroup3:Hide()
	oQtyEnt:Refresh()
	oQtySdo:Refresh()
	oOperac:Hide()
	oOP2:Hide()
	oCTrab:Hide()
	oEdit5:Hide()
	oSequen:Hide()
	oEdit10:Hide()
	oQty:Hide()
	oData:Hide()
	oHorario:Hide()
	oEdit2:Hide()
	oEmissao:Hide()
	oHora:Hide()
	oTBitmap3:Hide()	
	oBrowse:Refresh()

	oGroup2:Show()
	oGroup6:Show()
	oNumero:Show()
	oQtdPed:Show()
	oQtyPed:Show()
	oNOP:Show()
	oQtdEnt:Show()
	oQtyEnt:Show()
	oProdDesc:Show()
	oQtdSdo:Show()
	oQtySdo:Show()
	oProduto:Show()
	oDescri:Show()

	oTBitmap5:Show()
	oTBitmap6:Show()
	
	lEmProcesso := .F.
	
	FOR _nX:=1 TO 8
		 _nW := ASCAN(aCols , { |xy| xy[2]==STRZERO(_nX,2) } )			
		 IF ( _nW > 0 )
			 IF ( aCols[_nW,1] <> "1" )
				 cRtr := "oTBmp"+aCols[_nW,2]+":Enable()"         ////Habilita botao codigo de barra, desabilitado no momento da digitacao da operacao
				 &cRtr
			 ELSE
				 _nEncer += 1                                     ////Para verificar se a OP foi encerrada
			 ENDIF			 
		 ENDIF
	NEXT
	
	////
	////Verifica se a OP foi encerrada
	////
	
	IF ( cEdit12 == STRZERO(_nEncer,2) )                       ////OP encerrada

		_nAviso     := 2
		_cAviso3    := "                    *** ORDEM DE PRODUÇÃO ENCERRADA ***" 
		
	ENDIF
	
	oTimer:Activate()
			
ENDIF

Return

///////////////////////////////////////////////////////////
Static Function f_Cancela()
///////////////////////////////////////////////////////////
Local lRsp := lEmProcesso
Local _nX,_nW

IF ( nConsulta > 0 )
	
	DO CASE
		CASE nConsulta == 1
		
				lEmprocesso := .F.				
				cCodPro  	:= Space(30)
				mCodPro  	:= cCodPro
				cDescric 	:= Space(60)
				c_UM     	:= Space(2)
				c_Tipo   	:= Space(2)
				nSdoEst  	:= 0
				nEstEmp  	:= 0
				nEstDisp 	:= 0
				cNullo2  	:= " "
				aEmpC    	:= { {SPACE(8),SPACE(13),0,0,SPACE(30),SPACE(60)} }
				
				oGroupA:Hide()
				oGroupB:Hide()
				oEmpC:Hide()
				oCodigo:Hide()
				oCodPro:Hide()
				oDescC:Hide()
				oDescG:Hide()
				oSdoEstC:Hide()
				oSdoEstG:Hide()
				oEstDispC:Hide()
				oEstDispG:Hide()
				oEstEmpC:Hide()
				oEstEmpG:Hide()
				o_UMC:Hide()
				o_UMG:Hide()
				o_TipoC:Hide()
				o_TipoG:Hide()
				oNullo2:Hide()
				oTBitmap4:Hide()
				
				oGroup1:Show()
				oCracha:Show()
				oUsuario:Show()
				oEdit0:Show()
				oEdit6:Show()
				oOperacao:Show()
				oEdit1:Show()
				oNullo:Show()
				
				oEmpC:SetArray(aEmpC)

				oEmpC:bLine := {|| { aEmpC[oEmpC:nAt,1] , ;
											aEmpC[oEmpC:nAt,2] , ;
											aEmpC[oEmpC:nAt,3] , ;
											aEmpC[oEmpC:nAt,4] , ;
											aEmpC[oEmpC:nAt,5] , ;
											aEmpC[oEmpC:nAt,6] } }
				oEmpC:lAdjustColsize := .F.
				oEmpC:Refresh()			
				oEdit0:SetFocus()

		CASE nConsulta == 2
		
				oGroup8:Hide()
				oEmpenho:Hide()
				
				oGroup4:Show()
				oGroup5:Show()
				oBrowse:Show()
				oTBitmap5:Show()
				oTBitmap6:Show()
				oAviso1:Show()
				oAviso2:Show()
				oAviso3:Show()

		OTHERWISE
				oGroup9:Hide()
				oAptH:Hide()
				
				oGroup4:Show()
				oGroup5:Show()
				oBrowse:Show()
				oTBitmap5:Show()
				oTBitmap6:Show()
				oAviso1:Show()
				oAviso2:Show()
				oAviso3:Show()

	ENDCASE	

	nConsulta := 0
		
	Return
	
ENDIF

IF ( lEmProcesso )

	////
	////Habilita botao de codigo de barra
	////
	FOR _nX:=1 TO 8
		 _nW := ASCAN(aCols , { |xy| xy[2]==STRZERO(_nX,2) } )			
		 IF ( _nW > 0 .AND. aCols[_nW,1] <> "1" )
			 cRtr := "oTBmp"+aCols[_nW,2]+":Enable()"
			 &cRtr			 
		 ENDIF
	NEXT

	oOperac:Hide()
	oOP2:Hide()
	oCTrab:Hide()
	oEdit5:Hide()
	oSequen:Hide()
	oEdit10:Hide()
	oQty:Hide()
	oData:Hide()
	oHorario:Hide()
	oEdit2:Hide()
	oEmissao:Hide()
	oHora:Hide()
	oTBitmap3:Hide()	
	oGroup3:Hide()
	
	oGroup2:Show()
	oGroup6:Show()
	oNumero:Show()
	oQtdPed:Show()
	oQtyPed:Show()
	oNOP:Show()
	oQtdEnt:Show()
	oQtyEnt:Show()
	oProdDesc:Show()
	oQtdSdo:Show()
	oQtySdo:Show()
	oProduto:Show()
	oDescri:Show()
	
	oTBitmap5:Show()
	oTBitmap6:Show()

	lEmProcesso := .F.
	
ELSE
	
	f_Hide()

	cSetor := "01"
	cEdit0 := SPACE(9)
	cEdit6 := SPACE(10)
	cEdit1 := SPACE(8)

	////
	////Habilita botao de codigo de barra
	////
	FOR _nX:=1 TO 8
		 _nW := ASCAN(aCols , { |xy| xy[2]==STRZERO(_nX,2) } )			
		 IF ( _nW > 0 )
			 cRtr := "oTBmp"+aCols[_nW,2]+":Enable()"
			 &cRtr
			 
			 cRtr  := "cRot"+aCols[_nW,2]
			 &cRtr := ""
			 
		 ENDIF
	NEXT
	
	oGroup1:Show()
	oCracha:Show()
	oUsuario:Show()
	oEdit0:Show()
	oEdit6:Show()
	oOperacao:Show()
	oEdit1:Show()
	
	oNullo:Show()
	oNullo:Disable()
	oEdit1:Disable()
	oEdit0:Enable()

ENDIF

_cAviso1	:= ""
_cAviso2	:= ""
_cAviso3	:= ""
_nAviso  := 0

oAviso1:Refresh()
oAviso2:Refresh()
oAviso3:Refresh()

oEdit0:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ _fExecAp º Autor ³ Eduardo Alberti    º Data ³ 24/Aug/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa MsExecAuto Para Apontamento De Producao.           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _fExecAp1(cEdit1,cEdit2)
/////////////////////////////////////////////////////////////////////////////
Local   _nX,_nZ
Local   dData,cTime1,cTime2
Local   lNegEncontra := .F.
Local   _cArea       := GetArea()
Local   xEdit10      := LEFT(cEdit10,1)                       ///Carlos: 29/11/13
Local   xEdit1       := ( cEdit1 + "  " )                     ///Carlos: 29/11/13
Private cObserva     := ""

_xOpc := 2                                                    ///Carlos: 29/11/13

IF ( cEdit2 <= 0 )
	_xOpc := 22
	///MsgStop("Quantidade informada inválida: Menor ou igual a 0 (zero).","Atenção")
	Return
ENDIF

////
////Verifica a sequencia da operacao a ser apontada
////
IF ( cEdit5 < cOperI .OR. cEdit5 > cOperF )
	_xOpc := 24
	///MsgStop("Usuário sem permissão para apontar esta Operação.","Operação")
	Return
ENDIF

cTime1 := LEFT(FwTimeUF("AM",,.T.)[2],5)                                         ////Assume a hora do sistema

DbSelectArea("SC2")
DbSetOrder(1)       
DbSeek(xFilial("SC2") + Substr(cEdit1,1,11))

If xEdit10 == "E"
	
	////
	////Verifica se já houve apontamento de entrada para a operacao 01.
	////  Carlos: 27/03/13
	////
	dbSelectArea("SH6")
	dbSetOrder(1)
	dbSeek(xFilial("SH6")+xEdit1,.T.)
	IF ( !EOF().AND.SH6->H6_FILIAL==xFilial("SH6").AND.RTRIM(SH6->H6_OP)==RTRIM(xEdit1) )
		IF ( cEdit5=="01" )
			_xOpc := 5
			///MsgStop("Operação de Entrada para este roteiro já foi efetuado. Favor verificar a operação correta!","Operação NÃO efetuada")
			Return
		ENDIF
	ENDIF

	////
	////Verifica se a O.P nasceu Firme ou Prevista. Se Firme, retorna msg de erro.
	////Verifica se já houve apontamento da primeira operacao
	
	IF ( SC2->C2_TPOP=="F" )
		IF ( cEdit5=="01" )
			_xOpc := 4
			///MsgStop("Ordem de Produção inválida para apontamento. Favor contactar o responsavel pela abertura da OP","Tipo da OP Firme")
			Return
		ENDIF
	ELSEIF ( cEdit5<>"01" )
		_xOpc := 8
		///MsgStop("A Separação de Materiais ainda não foi Apontada.","Apontamento NÃO permitido")
		Return
	ENDIF
		
	////
	////Verifica se já houve saida na operacao anterior. Caso contrario, nao deixa apontar a entrada da proxima operacao.
	////  Carlos: 27/03/13
	////
	n_QtyA := 0          ///Qty da operacao anterior
	n_QtyE := 0          ///Qty da operacao atual - Entrada
	n_QtyS := 0          ///Qty da operacao atual - Saida
	If cEdit5<>"01"
		xcOperacao := STRZERO( ( Val(cEdit5) - 1 ) , 2 )
		dbSelectArea("SH6")
		dbSetOrder(3)
		dbSeek(xFilial("SH6")+SC2->C2_PRODUTO+xEdit1,.T.)
		DO WHILE !EOF().AND.H6_FILIAL==xFilial("SH6").AND.H6_PRODUTO==SC2->C2_PRODUTO.AND.H6_OP==xEdit1
			IF ( SH6->H6_OPERAC==xcOperacao )
				n_QtyA += SH6->H6_X_QTS
			ELSEIF ( SH6->H6_OPERAC==cEdit5 )				
				n_QtyE += SH6->H6_X_QTE
				n_QtyS += SH6->H6_X_QTS
			ENDIF	
			dbSkip()
		ENDDO	
		
		IF ( cEdit2 > n_QtyA )
			_xOpc := 6
			///MsgStop("Operação anterior ainda não foi fechada (Ap.Saída) ou quantidade informada para esta operação é maior que a quantidade da operação anterior.","Apontamento NÃO permitido!")
			Return
		ENDIF
		
		IF ( ( cEdit2 + n_QtyS ) > n_QtyA )
			_xOpc := 9
			///MsgStop("Quantidade informada é maior que a quantidade produzida na operação anterior.","Apontamento NÃO permitido!")
			Return
		ENDIF
		
	EndIf
	xnQty2 := ( n_QtyE - n_QtyS )
	*
	DbSelectArea("SC2")
	DbSetOrder(1)         ///C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD
	If dbSeek(xFilial("SC2") + Substr(cEdit1,1,11))

		////
		////Verifica se a qty informada for diferente do total da OP para a operacao 01
		////
		If cEdit5=="01"
			IF ( cEdit2 < SC2->C2_QUANT )
				_xOpc := 10
				///MsgStop("Quantidade parcial NÃO permitida para esta Operação.","Quantidade")
				Return
			ENDIF
			IF ( Chk_SdoEst(cEdit2,cEdit2,SC2->C2_PRODUTO,xEdit1) )
				lNegEncontra := MSGBOX("Itens negativos encontrado. Mesmo assim, libera esta OP para Produção?","Escolha a opção","YESNO")
				IF ( !lNegEncontra )
					_xOpc := 12
					Return
				ENDIF
			ENDIF
			If SC2->C2_TPOP=="P"           ///Torna Firme pra poder apontar a Entrada da primeira operacao (01).
				RecLock("SC2",.f.)
				SC2->C2_TPOP := "F"
				MsUnLock()
			EndIf
		Endif
		*		
		DbSelectArea("SB1")
		DbSetOrder(1)
		MsSeek(xFilial("SB1") + SC2->C2_PRODUTO )
		
		_cOp		:= Substr(cEdit1,1,11)
		_cUm		:= SC2->C2_UM
		_cAlmox	:= SC2->C2_LOCAL
		_cCod    := SC2->C2_PRODUTO
		
		nOpc        := 3
		lMsErroAuto := .F.		
		lErroQ      := .F.
		_cTM        := "400"                                      ////SuperGetMv("CO_TMPRDA",.F.,"002")
		dDBase      := ddatabase
		dData       := dEmissao
		ddatabase   := dEmissao
		cHora       := cTime1
		cEdit9      := ""
		
		dbSelectArea("SH6")
		dbSetOrder(1)
		
		////
		////Quando o Recurso for 010,070,040,080(SMD,COB,LASER,BASE LIG.), na ultima operacao, baixa automatica.
		////Caso contrario, gera somente o SH6 e a baixa automatica acontecera na saida.
		////
		IF ( cEdit5 <> cEdit12 .OR. !RTRIM(cEdit7) $ "010/070/040/080" )
			
			///IF ( _cTpLinha == "I" )                                   ////FECHAMENTO/TESTE/CALIBRACAO - EVITAR CRITICA EFETUADA PELO MSEXECAUTO()             
			///ENDIF
			aVetor := {}
						
			aVetor := { {"H6_OP"	    , xEdit1 , NIL } , ;  
			{"H6_OPERAC"  ,cEdit5    , NIL } , ;
			{"H6_PRODUTO" ,_cCod     , NIL } , ;
			{"H6_RECURSO" ,cEdit7    , NIL } , ;
			{"H6_DTAPONT" ,dData     , NIL } , ;
			{"H6_DTPROD"  ,dData     , NIL } , ;
			{"H6_DATAINI" ,dData     , NIL } , ;
			{"H6_HORAINI" ,cHora     , NIL } , ;
			{"H6_DATAFIN" ,dData     , NIL } , ;
			{"H6_HORAFIN" ,cEdit9    , NIL } , ;
			{"H6_PT"      ,cEdit4    , NIL } , ;
			{"H6_LOCAL"   ,_cAlmox   , NIL } , ;
			{"H6_OPERADO" ,cEdit6    , NIL } , ;
			{"H6_X_ES"    ,xEdit10   , NIL } , ;
			{"H6_X_QTE"   ,cEdit2    , NIL } , ;
			{"H6_OBSERVA" ,cObserva  , NIL } , ;
			{"H6_QTDPROD" ,cEdit2    , NIL } }
			
			//		{"H6_TEMPO"   ,cEdit9-cEdit8,NIL},;
						
			MSExecAuto({|x| mata681(x)},aVetor)                         //// inclusão
		
			ddatabase := dDBase
			
		ELSE
			IF ( nQtOper01 > cEdit2 )
				_nX := ASCAN(aCols , { |xx| xx[2] == cEdit5 } )
				_nZ := 0
				DO WHILE _nX <= LEN(aCols).AND.aCols[_nX,2]==cEdit5 
					_nZ := ( _nZ + aCols[_nX,8] )
					_nX++
				ENDDO
				IF ( ( nQtOper01 - _nZ ) > cEdit2 )   //( _nZ > 1 .OR. nQtOper01 > cEdit2 )
					_xOpc := 10
					///MsgStop("Quantidade parcial NÃO permitida para esta Operação.")
					Return
				ENDIF	
			ENDIF
			IF ( !EMPTY(SC2->C2_DATRF) .OR.  n_QtyS == SC2->C2_QUANT )
				lErroQ := .T.
				///Help(' ',1,'A680OPTOT')
				///MsgInfo("Operação de Entrada NÃO apontada!","Atenção")
				IF ( !EMPTY(SC2->C2_DATRF) )
					_xOpc := 11
					///MsgStop("O.P já se encontra encerrada.")
				ELSE
					_xOpc := 18
					///MsgStop("Capacidade de Entrada desta Operação já está totalizada.")
				ENDIF
			ELSE
				
				RecLock("SH6",.T.)
				SH6->H6_FILIAL  := xFilial("SH6")
				SH6->H6_OP      := xEdit1   
				SH6->H6_OPERAC  := cEdit5
				SH6->H6_PRODUTO := _cCod
				SH6->H6_RECURSO := cEdit7
				SH6->H6_DTAPONT := dData 
				SH6->H6_DATAINI := dData 
				SH6->H6_HORAINI := cHora
				SH6->H6_DATAFIN := dData 
				SH6->H6_HORAFIN := ""
				SH6->H6_PT      := "T"        /////
				SH6->H6_TEMPO   := "000:00"
				SH6->H6_DESDOBR := "000"
				SH6->H6_TIPO    := "P"
				SH6->H6_DTPROD  := dData 
				SH6->H6_TIPOTEM := 1
				SH6->H6_LOCAL   := _cAlmox
				SH6->H6_X_ES    := xEdit10
				SH6->H6_QTDPROD := cEdit2
				SH6->H6_X_QTE   := cEdit2
				SH6->H6_OPERADO := cEdit6            
				MsUnLock()
				
			ENDIF
			
		ENDIF
		
		If SC2->C2_TPOP == "F" .and. cEdit5=="01"      ///Retorna pra Prevista pra na proxima operacao ficar como Firme.
			RecLock("SC2",.F.)
			SC2->C2_TPOP := "P"
			MsUnLock()
		EndIf
				
		If lMsErroAuto
			Mostraerro() 
			_xOpc := 21
			///MsgInfo("Operação de Entrada NÃO apontada!","Atenção")
			Return
		EndIf	
		If lErroQ 
			_xOpc := 21
			Return
    		///MsgInfo("Operação de Entrada Não apontada!","Atenção")			
		Endif
		
	EndIf
	
Else

	////
	////Verifica se a qty informada for diferente do total da OP para a operacao 01
	////
	If EMPTY(SC2->C2_DATRF).AND.cEdit5=="01".AND.cEdit2 < SC2->C2_QUANT
		_xOpc := 10
		///MsgStop("Quantidade parcial NÃO permitida para esta Operação.","Quantidade")
		Return
	Endif
			
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1") + SC2->C2_PRODUTO )
	
	_cOp		:= Substr(cEdit1,1,11)
	_cUm		:= SC2->C2_UM
	_cAlmox	:= SC2->C2_LOCAL
	_cCod    := SC2->C2_PRODUTO

	///cTime2 := STRZERO(SomaHoras(cTime1,"00:01") , 5 , 2 )       ///Soma 1minuto pra evitar problemas na funcao MsExecauto(mata681)
	///cHora  := STRTRAN(cTime2,".",":")                           ///Carlos - 19/02/2015 --> Retirei pois estava havendo muito erro em funcao de apontamento unico para toda a OP.

	dData       := dEmissao
	cEdit9      := cTime1                                          ///Carlos - 19/02/2015  :::  cHora
	nOpc        := 3
	lMsErroAuto := .F.
	
	IF ( cEdit5 == cEdit12 .AND. RTRIM(cEdit7) $ "010/040/070/080" )    ///SMD,LASER,COB E BASE LIG. (somente duas operacoes)

		IF ( !EMPTY(SC2->C2_DATRF) )
			///Help(' ',1,'A680OPTOT')
			_xOpc := 11
			///MsgStop("OP se encontra encerrada. Operação de Saida NÃO apontada!","Atenção")
			Return
		ENDIF

		DbSelectArea("SH6")
		DbOrderNickName("SH605")                           // Produto-OP-Operacao-Entrada e Saida (H6_X_ES)
		DbSeek(xFilial("SH6")+_cCod+xEdit1+cEdit5+"E")                              
		If !Eof() 
			If cEdit2 > SH6->H6_X_QTE
				_xOpc := 14
				aMsg[14,2] := "Qtde. superior em "+LTRIM(STR( ( cEdit2 - SH6->H6_X_QTE ) )) + " unidade(s)"
				///MsgStop("Operação Sem Saldo para apontamento! OP "+SH6->H6_OP+CHR(13)+CHR(10)+" Operação "+SH6->H6_OPERAC+" Qtd superior em "+str(cEdit2 - H6_X_QTE)+" Unidade(s)","Atenção")
				Return
			Endif	
		Else
			_xOpc := 16
			///MsgStop("Não existe apontamento de entrada para esta quantidade!"+CHR(13)+CHR(10)+"Favor apontar a operação de entrada.","Atenção")
			Return
		EndIf
		
		_nRecNo := SH6->(RECNO())
		cEdit6  := IIF(!EMPTY(cEdit6).AND.cEdit6 <> SH6->H6_OPERADO , cEdit6 , SH6->H6_OPERADO )
		_nQts   := Iif(SH6->H6_X_QTA > 0 , SH6->H6_X_QTS   + cEdit2 , cEdit2 )
		_nQte   := SH6->H6_X_QTE
		_nQta   := SH6->H6_X_QTA + 1
		_dDIni  := SH6->H6_DATAINI
		_cHIni  := SH6->H6_HORAINI
		
		dDBase    := ddatabase
		dDatabase := dData

		////
		////A alteracao do numero da OP no SH6 é pra nao gerar duplicidade porque a gravacao se dá pela rotina automatica via msexecauto()
		////Se nao der nenhum erro, posiciona nesse registro alterado e deleta.
		////Se der erro no msexecauto(), altera novamente o numero da OP (sem o XX).
		////
		RecLock("SH6",.F.)
		SH6->H6_OP  := RTRIM(xEdit1)+"XX"
		dbCommit()
		MsUnlock()
		dbSkip()
		
		aVetor := { {"H6_OP"	     ,xEdit1  ,NIL} , ;    
						{"H6_OPERAC"  ,cEdit5  ,NIL} , ;
						{"H6_PRODUTO" ,_cCod   ,NIL} , ;
						{"H6_RECURSO" ,cEdit7  ,NIL} , ;
						{"H6_DTAPONT" ,dData   ,NIL} , ;
						{"H6_DTPROD"  ,dData   ,NIL} , ;
						{"H6_DATAINI" ,_dDIni  ,NIL} , ;
						{"H6_HORAINI" ,_cHIni  ,NIL} , ;
						{"H6_DATAFIN" ,dData   ,NIL} , ;
						{"H6_HORAFIN" ,cEdit9  ,NIL} , ;
						{"H6_PT"      ,cEdit4  ,NIL} , ;   
						{"H6_LOCAL"   ,_cAlmox ,NIL} , ;
						{"H6_OPERADO" ,cEdit6  ,NIL} , ;
						{"H6_X_ES"    ,"S"     ,NIL} , ;
						{"H6_X_QTA"   ,_nQta   ,NIL} , ;
						{"H6_X_QTS"   ,cEdit2  ,NIL} , ;
						{"H6_X_QTE"   ,cEdit2  ,NIL} , ;
						{"H6_QTDPROD" ,cEdit2  ,NIL} }
		
		/*		{"H6_TEMPO"   ,cEdit9-cEdit8,NIL},; */
		
		MSExecAuto({|x| mata681(x)},aVetor)  // inclusão

		ddatabase := dDBase
		
		If lMsErroAuto
			Mostraerro()
			_xOpc := 21
			///MsgInfo("Operação de Saida NÃO apontada!","Atenção")
			dbSelectArea("SH6")
			dbGoTo(_nRecNo)
			RecLock("SH6",.F.)
			SH6->H6_OP  := xEdit1                                    ///volta o numero da op correta sem o XX no final.
			MsUnlock()
			Return
		Else
			////
			////Atualiza registro com saldo ou deleta o mesmo quando saldo fechado
			////Ex.: OP.  DATA INI   HORA INI    QTY.ENTR.    DATA FIN    HORA FIN    QTY.SAI       
			////     02   01/12/14   07:15               8       -           -              0        <---- suponha que seja o registro de saldo e que será feito uma baixa de 5, na linha abaixo
			////     02   01/12/14   07:15               5    01/12/14    07:42             5        <---- grava um novo registro pelo MSEXECAUTO() e atualiza se ficar com saldo ou deleta sem saldo
			////     02   01/12/14   07:42               3       -           -              0        <---- essa linha é a atualizacao da primeira linha acima (pq tem saldo). Agora vamos baixar 2 na data 14/12/14.
			////     02   14/12/14   07:42               2    14/12/14    08:15             2        <---- vai ficar ainda com saldo de 1 que será atualizado na linha de cima.
			////     02   14/12/14   08:15               1       -           -              0        <---- atualizacao do registro referente a linha 3. 
			////     02   14/12/14   08:15               1    14/12/14    08:20             1        <---- operacao encerrada, excluindo a linha acima.
			////
			_nSaldo := ( _nQte - cEdit2 )
			IF ( _nSaldo > 0 )
			
				dbSelectArea("SH6")
				dbGoTo(_nRecNo)
				RecLock("SH6",.F.)
				SH6->H6_OP       := xEdit1
				SH6->H6_QTDPROD  := _nSaldo
				SH6->H6_X_QTE    := _nSaldo
				SH6->H6_DATAINI  := dData
				SH6->H6_DATAFIN  := dData
				SH6->H6_HORAINI  := cEdit9
				SH6->H6_DTPROD   := dData
				SH6->H6_DTAPONT  := dData
				
			ELSE
				////
				////Deleta a OP com o XX no final
				////
				dbSelectArea("SH6")
				dbGoTo(_nRecNo)
				RecLock("SH6",.F.)
				dbDelete()
			ENDIF
			MsUnlock()
			
    		///MsgInfo("Operação de Saida apontada!","Atenção")
			
		Endif
		
	ELSE
	
		DbSelectArea("SH6")
		DbOrderNickName("SH605") // Produto-OP-Operacao-Entrada e Saida
		If DbSeek(xFilial("SH6") + _cCod+xEdit1+cEdit5+"E")                               ///Carlos: 27/03/2013
			If cEdit2 <= H6_X_QTE                                                         ///???? 05/12/2013
				RecLock("SH6",.F.)
				SH6->H6_HORAFIN := cHora
				SH6->H6_DATAFIN := dData 
				SH6->H6_DTAPONT := dData                                                   ///Carlos: 01/12/14
				SH6->H6_DTPROD  := dData                                                   ///Carlos: 01/12/14
				SH6->H6_X_ES    := xEdit10
				SH6->H6_QTDPROD := Iif(H6_X_QTA > 0 , H6_QTDPROD + cEdit2 , cEdit2 )
				SH6->H6_X_QTS   := Iif(H6_X_QTA > 0 , H6_X_QTS   + cEdit2 , cEdit2 )
				SH6->H6_QTDPERD := cEdit11
				SH6->H6_X_QTA   := SH6->H6_X_QTA + 1                    ///Numero de vezes que a OP foi apontada na saida da operacao
				///SH6->H6_OPERADO := cEdit6                            ///Carlos - 27/03/13
				IF ( !EMPTY(cEdit6).AND.cEdit6<>SH6->H6_OPERADO )       ///Carlos - 27/03/13
					SH6->H6_OPERADO := cEdit6                            ///Carlos - 27/03/13
				ENDIF	
				MsUnLock()
				////
				////Atualiza Empenho e torna a OP Firme quando a Operação for 01 - Carlos: 27/03/13
				////
				If SC2->C2_TPOP == "P" .and. cEdit5=="01"               ///Quando a OP for prevista, primeira operacao e saida 
				
					f_AtualEmpenho()
					
				Endif
				///MsgInfo("Operação de Saida apontada!","Atenção")
			Else
				_xOpc := 14
				aMsg[14,2] := "Qtde. superior em "+LTRIM(STR( ( cEdit2 - SH6->H6_X_QTE ) )) + " unidade(s)"
				///MsgStop("1-Operação Sem Saldo para apontamento! OP "+SH6->H6_OP+CHR(13)+CHR(10)+" Operação "+SH6->H6_OPERAC+" Qtd superior em "+str(cEdit2-H6_X_QTE)+" Unidade(s)","Atenção")
				Return
			EndIf

		Else
			
			If DbSeek(xFilial("SH6") + _cCod+xEdit1+cEdit5)                                                          ///Carlos: 27/03/2013
				n_Ctd := 0
				Do While !EOF() .And. _cCod+xEdit1+cEdit5==SH6->(H6_PRODUTO+H6_OP+H6_OPERAC)                            ///Carlos: 27/03/2013
					If H6_QTDPROD < H6_X_QTE
						
						If H6_QTDPROD + cEdit2 <= H6_X_QTE
							RecLock("SH6",.f.)
							SH6->H6_HORAFIN := cHora
							SH6->H6_DATAFIN := dData 
							SH6->H6_DTAPONT := dData                                                   ///Carlos: 01/12/14
							SH6->H6_DTPROD  := dData                                                   ///Carlos: 01/12/14
							SH6->H6_X_ES    := xEdit10
							SH6->H6_QTDPROD := Iif(H6_X_QTA > 0 , H6_QTDPROD + cEdit2 , cEdit2 )
							SH6->H6_X_QTS   := Iif(H6_X_QTA > 0 , H6_X_QTS   + cEdit2 , cEdit2 )
							SH6->H6_QTDPERD := cEdit11
							SH6->H6_X_QTA   := SH6->H6_X_QTA + 1                                    ///Numero de vezes que a OP foi apontada na saida da operacao
							///SH6->H6_OPERADO := cEdit6                                            ///Carlos - 27/03/13
							IF ( !EMPTY(cEdit6).AND.cEdit6<>SH6->H6_OPERADO )                       ///Carlos - 27/03/13
								SH6->H6_OPERADO := cEdit6                                            ///Carlos - 27/03/13
							ENDIF	
							MsUnLock()
							////
							////Atualiza Empenho e torna a OP Firme quando a Operação for 01 - Carlos: 27/03/13
							////
							If SC2->C2_TPOP == "P" .and. cEdit5=="01"                              // Quando a OP for prevista, primeira operacao e saida 
							
								f_AtualEmpenho()
								
							Endif
							n_Ctd := 0
							///MsgInfo("Operação de Saldo apontada!","Atenção")
						Else					
							_xOpc := 14
							aMsg[14,2] := "Qtde. superior em "+LTRIM(STR( ( SH6->H6_QTDPROD + cEdit2 - SH6->H6_X_QTE ) )) + " unidade(s)"
							///MsgStop("2-Operação Sem Saldo para apontamento! OP "+SH6->H6_OP+CHR(13)+CHR(10)+" Operacao "+SH6->H6_OPERAC+" Qtd superior em "+str(H6_QTDPROD+cEdit2-(H6_X_QTE))+" Unidade(s)","Atenção")
							Return
						EndIf
					Else
						n_Ctd++
					EndIf
					dbskip()
				EndDo
				If n_Ctd > 0      ///Carlos: 27/03/13
					_xOpc := 14
					aMsg[14,2] := ""
					///MsgStop("Operação Sem Saldo para apontamento! OP "+SH6->H6_OP+" Operacao "+cEdit5,"Atenção")
					Return
				EndIf		
			Else
				_xOpc := 17
				///MsgStop("Não existe apontamento de Entrada para esta operação!"+CHR(13)+CHR(10)+"Favor obedecer a sequencia ou roteiro de operação para apontamento.","Atenção")
				Return
			EndIf
			
		EndIf
	
	ENDIF
	
EndIf

RestArea(_cArea)

_xOpc := 1                                  

_cAviso1 := "PARABÉNS!!!  Operação de "+IIF(xEdit10=="E","Entrada","Saída")+" apontada com sucesso."
_cAviso2 := "O.P.: "+xEdit1+"        Operação: "+cEdit5+"           Qtde: "+TRANSF(cEdit2,"@E 99999")
_cAviso3 := ""

Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_AtualEmpenho()
//////////////////////////////////////////////////////////////////////////////
Local oMulti

dbSelectArea("SB1")
dbSetOrder(1)
*
RecLock("SC2",.f.)
SC2->C2_TPOP := "F"
MsUnLock()
*
dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD)
While !Eof() .And. D4_FILIAL+D4_OP == xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD
	
	DbSelectArea("SB2")
	DbSetOrder(1)
	IF dbSeek(xFilial("SB2")+SD4->D4_COD+SD4->D4_LOCAL)
		RecLock("SB2",.f.)
		SB2->B2_QEMP    := SB2->B2_QEMP + SD4->D4_QTDEORI
		SB2->B2_QEMPPRE := SB2->B2_QEMPPRE - SD4->D4_QTDEORI
		MsUnLock()		
	EndIf
	
	dbSelectArea("SD4")
	dbSkip()
EndDo
		
Return

//////////////////////////////////////////////////
Static Function CAPT_SCP()                                                 ////ALTERAR PARA USER
//////////////////////////////////////////////////
Local lRsp  := .T.
Local cVar  := ReadVar()

IF ( M->B2_QFIM > aCols[n,6] )
	MsgStop("Quantidade informada maior que a quantidade da OP.","Atenção")
	lRsp := .F.
ENDIF

Return(lRsp)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ _fVlDlg  º Autor ³ Carlos Nina        º Data ³ 14/Out/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao Da Digitacao Dos Dados Da Dialog.                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _fVlDlg(_cTipo,_xConteudo)

Local nEstDsp
Local cEdt5
Local _aArea := GetArea()
Local _lRet	 := .t. 
Local _nX    := 0

_cAviso1 := " "
_cAviso2 := " "
_cAviso3 := " "

Do Case
	Case Upper(Alltrim(_cTipo)) == "CBAROPER"

			IF ( nConsulta > 0 )
				Return
			ENDIF

			IF ( _xConteudo <> "01" )
				cEdt5 := STRZERO(VAL(_xConteudo)-1,2)
				_nX   := ASCAN(aCols , { |xy| xy[2]==cEdt5 } )			
				IF ( ( aCols[_nX,5] + aCols[_nX,8] ) = 0 )
					MsgStop("Operação anterior ("+cEdt5+") ainda não iniciada.","Sequencia de apontamento")
					Return
				ENDIF
			ENDIF
			
			oGroup2:Hide()
			oGroup6:Hide()
			oNumero:Hide()
			oQtdPed:Hide()
			oQtyPed:Hide()
			oNOP:Hide()
			oQtdEnt:Hide()
			oQtyEnt:Hide()
			oProdDesc:Hide()
			oQtdSdo:Hide()
			oQtySdo:Hide()
			oProduto:Hide()
			oDescri:Hide()
			oTBitmap5:Hide()
			oTBitmap6:Hide()
	
			oGroup3:Show()
			oOperac:Show()
			oOP2:Show()
			oCTrab:Show()
			oEdit5:Show()
			oSequen:Show()
			oEdit10:Show()
			oQty:Show()
			oData:Show()
			oHorario:Show()
			oEdit2:Show()
			oEmissao:Show()
			oHora:Show()
			oTBitmap3:Show()

			cEdit5      := _xConteudo
			_nX         := ASCAN(aCols , { |xy| xy[2]+xy[13]==cEdit5+"99" } )			
			cEdit10     := IIF(aCols[_nX,5]==aCols[_nX,8] , "ENTRADA", "SAIDA" )					
			_nX         := ASCAN(aCols , { |xy| xy[2] == cEdit5 } )			
			cOperacao   := aCols[_nX,10]
			_cTpLinha   := aCols[_nX,14]
			//dEmissao    := ddatabase
			//mdEmissao   := dEmissao
			cEdit2      := 0
			cHora       := LEFT(FwTimeUF("AM",,.T.)[2],5)			
			lEmProcesso := .T.						

			FOR _nX:=1 TO 8
				 _nW := ASCAN(aCols , { |xy| xy[2]==STRZERO(_nX,2) } )			
				 IF ( _nW > 0 .AND. aCols[_nW,1] <> "1" )                                        ///aCols[n,1] = "1" = Disable()
					 cRtr := "oTBmp"+aCols[_nW,2]+":Disable()"
					 &cRtr
				 ENDIF
			NEXT

			oEdit2:SetFocus()			
			If oTimer:lActive
				oTimer:DeActivate()
			EndIf
			
	Case Upper(Alltrim(_cTipo)) == "CBAR"
		
		If ( Empty(_xConteudo) )
			IF ( cSetor <> "01" )
				oEdit1:SetFocus()
			ENDIF	
			Return(.T.)
		Else	
			x_Barra := SUBS(_xConteudo,1,1)+SUBS(_xConteudo,8,1)
			IF ( x_Barra == "99".AND.LEN(RTRIM(_xConteudo))==8 )
				cEdit1 := space(8)
				_lRet  := .f.
				oEdit1:Refresh()
			ELSE
				_xConteudo := _xConteudo+"001"
				DbSelectArea("SC2")
				DbSetOrder(1)                                      ///C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD
				dbSeek(xFilial("SC2") + _xConteudo)
				If !EOF()	
					_cOP	    := _xConteudo
					cOP2      := "O.P.: "+TRANSF(_cOP,"@R XXXXXX.XX.999")
					cEdit1    := _xConteudo
					nQtOper01 := SC2->C2_QUANT
					dUltApt   := CTOD("")

					////
					////Monta Historico de Operacao e os codigo de barra de cada operacao
					////
					aCols := {}
					aOper := {}
					DbSelectArea("SG2")
					DbSetOrder(3)
					DbSeek(xFilial("SG2")+SC2->C2_PRODUTO,.T.) 
					DO WHILE !EOF().AND.G2_FILIAL==xFilial("SG2").AND.G2_PRODUTO==SC2->C2_PRODUTO
						IF ( SG2->G2_CODIGO == "01" .AND. RTRIM(SG2->G2_RECURSO) <> mvRecurso )
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
											
							cEdit7 := SG2->G2_RECURSO
							cRtr   := "cRot"+RTRIM(SG2->G2_OPERAC)
							&cRtr  := "( ) "+RTRIM(SG2->G2_OPERAC)+"-"+RTRIM(SG2->G2_DESCRI)
						ENDIF	
						cEdit12 := SG2->G2_OPERAC
						dbSkip()
					ENDDO	

					////
					////Extrai itens do empenho da OP
					aEmpenho := {}
					dbSelectArea("SD4")
					dbSetOrder(2)
					dbSeek(xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,.T.)
					Do While !Eof() .And. D4_FILIAL+RTRIM(D4_OP) == xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
						
						SB2->(dbSeek(xFilial("SB2")+SD4->D4_COD+SD4->D4_LOCAL))
						SB1->(dbSeek(xFilial("SB1")+SD4->D4_COD))

						nEstDsp := ( SB2->B2_QATU - SB2->B2_QEMP )
						
						AADD(aEmpenho , { RTRIM(SD4->D4_COD)    , ;
												LEFT(SB1->B1_DESC,40) , ;
												SB1->B1_TIPO          , ;
												SB1->B1_UM            , ;
												SD4->D4_QTDEORI       , ;
												SB2->B2_QATU          , ;
												nEstDsp               , ;
												SD4->D4_LOCAL } )
						
						dbSkip()
					EndDo
					
					dbSelectArea("SH6")
					dbSetOrder(1)
					dbSeek(xFilial("SH6")+_cOP,.T.)
					DO WHILE !EOF().AND.H6_FILIAL==xFilial("SH6").AND.RTRIM(H6_OP)==RTRIM(_cOP)
						xcOperacao := SH6->H6_OPERAC
						xcOperador := SH6->H6_OPERADO
						xcRecurso  := SH6->H6_RECURSO
						xdDataIni  := SPACE(8)
						xcHoraIni  := SPACE(8)
						xcHoraFin  := SPACE(8)
						xn         := "0"
						DO WHILE !EOF().AND.H6_FILIAL==xFilial("SH6").AND.RTRIM(H6_OP)==RTRIM(_cOP).AND.H6_OPERAC==xcOperacao
							IF ( xcOperacao <> "99" .AND. xcRecurso <> mvRecurso )
								dUltApt   := IIF(SH6->H6_DTPROD > dUltApt , SH6->H6_DTPROD , dUltApt )
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

					lEncer := ( !EMPTY(SC2->C2_DATRF).AND.RTRIM(cEdit7) $ "010/040/070/080" ) 
					ix     := 1
					xw     := 0
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
							cLegenda := IIF(lEncer.OR.nQty == 0 , "1" ,IIF(( nQtyE + nQtyS ) == 0 , "2" , "3" ) )
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

						IF ( !EMPTY(SC2->C2_DATRF) )
							IF ( SC2->C2_QUANT > SC2->C2_QUJE )
								_cAviso2 := "                        *** ORDEM DE PRODUÇÃO ENCERRADA PARCIALMENTE ***"
							ELSE
								_cAviso2 := "                        *** ORDEM DE PRODUÇÃO ENCERRADA TOTALMENTE ***"
							ENDIF
						ENDIF																							
						
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
					
					f_Show()
					
					oTBitmap5:Show()
					oTBitmap6:Show()
					
					oGroup1:Hide()
					oCracha:Hide()
					oUsuario:Hide()
					oEdit0:Hide()
					oEdit6:Hide()
					oOperacao:Hide()
					oEdit1:Hide()
																				
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
					SH1->(dbSeek(xFilial("SH1")+cEdit7))
					
					_nQtde  := SC2->C2_QUANT
					_nQuje  := SC2->C2_QUJE
					_nSaldo := ( _nQtde - _nQuje )
					_cProd  := Alltrim(SC2->C2_PRODUTO) 
					_cDesc  := LEFT(SB1->B1_DESC,50)
					cCTrab  := "C.T.: "+RTRIM(SH1->H1_DESCRI)
					
					If ( !EMPTY(_cAviso2) )   
						_nAviso  := 2
					Else
						cSetor    := "00"
						dEmissao  := ddatabase
						mdEmissao := dEmissao
						oEmissao:SetFocus()
					EndIf
					
					oNullo:Hide()
					oEdit1:Disable()			
					oButton:Hide()

				Else
					MsgStop("Ordem de Produção NÃO Encontrada!","Atenção")
					_lRet := .f.
				EndIf
			ENDIF
		EndIf
		
	Case Upper(Alltrim(_cTipo)) == "QTDE"
		
		_nQuant := IIf(_xConteudo > 0,_xConteudo,_nQuant)
		
		oEdit2:Refresh()
		_oDlg:Refresh()

	Case Upper(Alltrim(_cTipo)) == "DEMIS"
		
		If _xConteudo <= dDatFech
			_lRet    := .F.
			MsgStop("Não é permitido a Data de Apontamento anterior a Data do Ultimo Fechamento de Estoque.","Atenção!")
			dEmissao := mdEmissao
			oEmissao:Refresh()
		Else
			IF ( cEdit5 <> "01" )
				_xOper := STRZERO( ( VAL(cEdit5) + 1 ) , 2 )
				_nX    := ASCAN(aCols , { |x| x[2] == _xOper } )
				_nW    := IIF(_nX==0 , LEN(aCols) , ( _nX - 1 ) )
				_nX    := IIF(aCols[_nW,1]=="2" , ( _nW - 1 ) , _nW )
				_dData := IIF(EMPTY(aCols[_nX,6]) , CTOD(aCols[_nX,3]) , CTOD(aCols[_nX,6]) )
			ELSE
				_nW    := 1
				_dData := IIF(EMPTY(aCols[1,3]) , _xConteudo , CTOD(aCols[1,3]) )
			ENDIF
			If ( _xConteudo < _dData )    
				_lRet := .F.
				IF ( _nX == _nW )
					MsgStop("Data informada ("+DTOC(dEmissao)+") inferior a ultima data de apontamento desta operação.","Atenção")
				ELSE
					MsgStop("Data informada ("+DTOC(dEmissao)+") inferior a ultima data da operação anterior.","Atenção")
				ENDIF
				dEmissao := mdEmissao
				oEmissao:Refresh()
			Else
				mdEmissao := dEmissao
			EndIf
			/*
			xData := LastDay((dDatFech+1))
			If _xConteudo > (xData+5)
				_cAviso1 := "Atenção!!!!"
				_cAviso3 := "A Data de Apontamento que vc está informando está fora do mes"
				_cAviso4 := "atual de movimento."
			EndIf
			*/
		EndIf
		
	Case Upper(Alltrim(_cTipo)) == "MATR"
		
		IF ( !EMPTY(_xConteudo) )
			
			x_Barra := SUBS(_xConteudo,1,1)+SUBS(_xConteudo,8,1)
		
			_xConteudo := IIF(x_Barra == "99" , SUBSTRING(_xConteudo,2,6) , _xConteudo )
			_xConteudo := STRZERO( VAL(ALLTRIM(_xConteudo)) , 6 )
			
			dbSelectArea("SX5")
			dbSetOrder(1)
			dbSeek(xFilial("SX5")+"Z@"+_xConteudo)
			IF ( SX5->(EOF()) )
				IF ( x_Barra <> "99" )
					MsgStop("Erro de leitura no Codigo de Barras do Crachá.")
				ELSE	
					MsgStop("Usuário não autorizado para executar esta rotina.","Atenção")
				ENDIF	
				_lRet := .f.
			ELSE	
				cSetor := SUBS(SX5->X5_DESCRI,1,2)
				cOperI := SUBS(SX5->X5_DESCRI,3,2)
				cOperF := SUBS(SX5->X5_DESCRI,6,2)
				cEdit6 := SUBS(SX5->X5_DESCRI,8,10)
				/////
				/////Oculta objetos quando a operacao anterior foi executada com sucesso
				/////
				IF ( _nAviso == 2 )
					
					f_Hide()
					
				ENDIF	
				If oTimer:lActive
					oTimer:DeActivate()
				EndIf
				oEdit0:Disable()
				oEdit1:Enable()
				oNullo:Enable()
				oButton:Show()
				oEdit1:SetFocus()
			ENDIF
			
		ENDIF
		
EndCase

RestArea(_aArea)

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

//////////////////////////////////////////////////////////////////////////////
Static Function Chk_SdoEst(_nxQuant,_nSdoOP,_cProduto,_cEdit1)
//////////////////////////////////////////////////////////////////////////////
Local cPT     := IIF(_nxQuant < _nSdoOP , "P" , "T" )
Local	aSaldo  := {}
Local	aErros  := {}
Local aReqsOK := {}
Local lRet    := .F.
Local lVer116 := (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.))  > 11)

PRIVATE l680  := .F.,l681:=.T.,l682:=.F.,l250 := .F.,l240 := .F.,l241 := .F.
	
	Sdo_Estoq(_nxQuant,cPT,_cProduto,_cEdit1,@aSaldo,@aReqsOK,,,0,dEmissao)
	
	If Len(aSaldo) > 0
		aErros := {}
		For ni := 1 to Len(aSaldo)
				If QtdComp(aSaldo[ni][3]) < QtdComp(0) 
					cMens  := OemToAnsi("Sem Saldo em Estoque")
					cQuant := Transf(aSaldo[ni][3],"@E 999999.99")
					AADD(aErros,{LEFT(aSaldo[ni][1],20),aSaldo[ni][2],cQuant,cMens})
					cObserva += IIF(!EMPTY(cObserva),";","") + RTRIM(aSaldo[ni][1])
				EndIf
		Next ni
		If Len(aErros) > 0
			lRet := F_ESTNEG(aErros)
		EndIf
	EndIf
	
Return(lRet)	

/////////////////////////////////////////////
Static Function F_ESTNEG(aErros)
/////////////////////////////////////////////
Local oDlg, oList, oGroup

DEFINE MSDIALOG oDlg TITLE "SC000990.LOG" FROM 0,0 To 22,70 OF oMainWnd

@ 001,002 GROUP oGroup TO 158,238                                             OF oDlg PIXEL
@ 008,006 Say OemToAnsi("HELP: MA240NEGAT")                       Size 55,8   OF oDlg PIXEL
@ 018,006 Say OemToAnsi("Não existe quantidade suficiente em")    Size 90,7   OF oDlg PIXEL
@ 026,006 Say OemToAnsi("estoque para atender esta requisição.")  Size 110,7  OF oDlg PIXEL
@ 046,006 Say OemToAnsi("Itens Sem Saldo [Estoque - Empenho]")    Size 110,8  OF oDlg PIXEL
@ 145,006 Say OemToAnsi("Processo Inválido")                      Size 45,8   OF oDlg PIXEL

@ 056,006 LISTBOX oList VAR cVar Fields HEADER OemToAnsi("Produto"),OemToAnsi("Local"),OemToAnsi("Saldo"),OemToAnsi("Ocorrencia") SIZE 230,85    OF oDlg PIXEL
oList:SetArray(aErros)
oList:bLine := { || {aErros[oList:nAT][1],aErros[oList:nAT][2],aErros[oList:nAT][3],aErros[oList:nAT][4]}}

DEFINE SBUTTON FROM 005,241  TYPE 1 ACTION (oDlg:End()) ENABLE OF oDlg PIXEL
DEFINE SBUTTON FROM 023,241  TYPE 2 DISABLE OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg Center

Return(.T.)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Sdo_Estoq(nQuantBx,cParcTot,cProduto,cOP,aSaldo,aReqsOk,aBaixaComp,aChkBaixaC,nPerc,dEmissao)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local cApropri
Local nRecSB1,nRecSC2, nQtdUsada, nLen, nx
Local cAlias	  := Alias()
Local cEstNeg	  := GetMV("MV_ESTNEG"	)
Local cLocProc	  := GetMV("MV_LOCPROC"	)
Local cIndNeg	  := GetMV("MV_INDNEG"	)
Local cBxProp	  := GetMv("MV_BXPROP"	)
Local aArray	  := {}
Local nIndice	  := 1
Local i		  	  := 0
Local z			  := 0
Local w			  := 0
Local xi		     := 0
Local zi		     := 0
Local nSD4       := 0
Local nQtSD4     := 0
Local nQtBaixa   := 0
Local cProdSD4   := ''
Local cTrtSD4    := ''
Local cOPOrigin  := "zzzzzzzzzzzzz"
Local aProdsSD4  := {{}}
Local aArraySD4  := {{}}
Local dmEmissao  := LastDay(dEmissao)

If cIndNeg == "E"
	cIndNeg := cEstNeg
EndIf

dbSelectArea("SB1")
nRecSB1 := RECNO()
*
dbSelectArea("SC2")
nRecSC2 := RECNO()

SC2->(dbSeek(xFilial("SC2")+cOP))

If nQuantBx > 0
	If cBxProp == "S" .And. cParcTot == "P"
		nIndice := Min(1,nQuantBx / SC2->C2_QUANT)
	EndIf

	dbSelectArea("SD4")
	dbSetOrder(2)
	dbSeek(xFilial("SD4")+cOp,.T.)
	Do While !EOF() .And. D4_FILIAL==xFilial("SD4") .And. RTRIM(D4_OP)==RTRIM(cOp)

		SB1->(dbSeek(xFilial("SB1")+SD4->D4_COD))

		cApropri :=	IIf(SB1->B1_APROPRI == "I" , "2" , "1" )
		cLocReq  := IIf(cApropri == "2" , cLocProc , SD4->D4_LOCAL )

		nLen := Len(aProdsSD4)
		If Len(aProdsSD4[nLen]) > 4095
			AADD(aProdsSD4,{})
		EndIf
		
		For i:=1 to Len(aProdsSD4)
			nSD4 := ASCAN(aProdsSD4[i],{ |x| x[1] == SD4->D4_COD .And. x[3] == SD4->D4_TRT})
			If nSD4 <> 0
				aProdsSD4[i,nSD4,2] += A250PotMax(SD4->D4_COD,0,Calc_QtOri(SD4->D4_QTDEORI,nIndice,cParcTot,SD4->D4_QUANT),2)
				Exit
			EndIf
		Next i
		If nSD4 == 0
			AADD(aProdsSD4[Len(aProdsSD4)],{ SD4->D4_COD , ;
			                                 A250PotMax(SD4->D4_COD,0,Calc_QtOri(SD4->D4_QTDEORI,nIndice,cParcTot,SD4->D4_QUANT),2) , ;
														SD4->D4_TRT , ;
														0 } )
		EndIf
		If QtdComp(SD4->D4_QUANT,.T.) = QtdComp(0,.T.)
			dbSelectArea("SD4")
			dbSkip()
			Loop
		EndIf
		nLen := Len(aArraySD4)
		If Len(aArraySD4[nLen]) > 4095
			AADD(aArraySD4,{})
		EndIf
		AADD(aArraySD4[Len(aArraySD4)] , ;
		    { SD4->(RECNO()),;			                      //1
			   nIndice,;					                      //2
			   SD4->D4_COD,;				                      //3
			   SD4->D4_LOCAL,;			                      //4
			   SD4->D4_TRT,;				                      //5
			   SD4->D4_OPORIG,;           	                //6
			   A250PotMax(SD4->D4_COD,0,SD4->D4_QUANT,2),;	 //7
			   DTOS(SD4->D4_DTVALID),;	                      //8
			   SD4->D4_LOTECTL,;			                      //9
			   SD4->D4_NUMLOTE,;			                      //10
			   SD4->D4_OP,;				                      //11
			   A250PotMax(SD4->D4_COD,0,SD4->D4_QTDEORI,2),; //12
			   0  ,;                                         //13 
			   0  } )	                                     //14
				
		dbSelectArea("SD4")
		dbSkip()
	EndDo
	
	For i:=1 to Len(aArraySD4)
		For z:=1 to Len(aArraySD4[i])
			If Empty(aArraySD4[i,z,6])
				aArraySD4[i,z,6] := cOPOrigin
			EndIf
		Next 
		
		ASORT(aArraySD4[i],,,{ |x,y| x[3]+x[4]+x[5]+x[6]+x[8]+x[9]+x[10] < y[3]+y[4]+y[5]+y[6]+y[8]+y[9]+y[10]})
		
		For z:=1 to Len(aArraySD4[i])
			If aArraySD4[i,z,6] == cOPOrigin
				aArraySD4[i,z,6] := Space(Len(aArraySD4[i,z,6]))
			EndIf
		Next 
	Next 

	For i:=1 to Len(aArraySD4)
		For z:=1 to Len(aArraySD4[i])
			If !(aArraySD4[i,z,3]+aArraySD4[i,z,5] == cProdSD4+cTrtSD4)
				For w:=1 to Len(aProdsSD4)
					nSD4 := ASCAN(aProdsSD4[w],{ |x| x[1] == aArraySD4[i,z,3] .And. x[3] == aArraySD4[i,z,5]})
					If nSD4 <> 0
						nQtSD4 := aProdsSD4[w,nSD4,2]
						Exit
					EndIf
				Next 
				cProdSD4 := aArraySD4[i,z,3]
				cTrtSD4  := aArraySD4[i,z,5]
			EndIf
			If QtdComp(nQtSD4,.T.) <> QtdComp(0,.T.)
				nQTBaixa  := Min(QtdComp(nQtSD4),QtdComp(aArraySD4[i,z,7]))
				If QtdComp(nQtBaixa) < QtdComp(aArraySD4[i,z,7])
					aArraySD4[i,z,2] := nQtBaixa / aArraySD4[i,z,7]
				Else
					aArraySD4[i,z,2] := 1
				EndIf
				nQtSD4 -= nQtBaixa
			Else
				aArraySD4[i,z,2] := 0
			EndIf
		Next 
	Next i
	///
	///Check SALDO.           
	///
	For i:=1 to Len(aArraySD4)
		For w:= 1 to Len(aArraySD4[i])
			If aArraySD4[i,w,2] != 0
				nQtSD4 := A250PotOrg(aArraySD4[i,w,3],aArraySD4[i,w,14],Calc_QtOri(aArraySD4[i,w,2],aArraySD4[i,w,7]),2)
				SB2->(dbSeek(xFilial("SB2")+aArraySD4[i,w,3]+aArraySD4[i,w,4]))
				SB1->(dbSeek(xFilial("SB1")+aArraySD4[i,w,3]))
				cApropri := IIf(SB1->B1_APROPRI == "I","2","1")
				nx       := Ascan(aReqsOK,{|x| x[1] == aArraySD4[i,w,3] .And. x[2] == aArraySD4[i,w,4]})
				If nx == 0
					nQtdUsada := 0
					AADD(aReqsOk,{aArraySD4[i,w,3],aArraySD4[i,w,4],nQtSD4})
				Else
					nQtdUsada     := aReqsOk[nx,3]
					aReqsOk[nx,3] += nQtSD4
				EndIf
				///If ( cIndNeg == "N" .And. cApropri == "2") .Or. (cEstNeg == "N" .And. cApropri == "1" )       ///Carlos: 13/05/2014
					nx := Ascan(aSaldo,{|x| x[1] == aArraySD4[i,w,3] .And. x[2] == aArraySD4[i,w,4]})
					If nx == 0
						nSdoMov := SaldoMov(Nil,.F.,Nil,Nil,Nil,Nil,Nil,dmEmissao)
						nQtSD4  += SB2->B2_QEMP                                                                    ///Carlos: 13/05/2014
						AADD(aSaldo,{aArraySD4[i,w,3],aArraySD4[i,w,4],(nSdoMov - nQtSD4 - nQtdUsada),0,0,"S",aArraySD4[i,w,9],aArraySD4[i,w,10]})
					Else
						aSaldo[nx,3] -= nQtSD4
					EndIf
				///EndIf
			EndIf
		Next 
	Next 
EndIf
dbSelectArea("SB1")
dbGoTo(nRecSB1)
*
dbSelectArea("SC2")
dbGoTo(nRecSC2)

Return

//////////////////////////////////////////////////////////////////////////////
Static Function Calc_QtOri(nQtde, nIndice,cParcTot,nSaldo)
//////////////////////////////////////////////////////////////////////////////
Local nRetorno := Round(nQtde*nIndice,8)

If cParcTot == "T" .And. nSaldo > 0
	If ABS(nSaldo - nRetorno) <= 0.01
		nRetorno:=nSaldo
	EndIf
EndIf
Return(nRetorno)

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
oOP2:Hide()
oCTrab:Hide()
oQtdEnt:Hide()
oQtyEnt:Hide()
oProdDesc:Hide()
oQtdSdo:Hide()
oQtySdo:Hide()
oProduto:Hide()
oDescri:Hide()
oOperac:Hide()
oEdit5:Hide()
oSequen:Hide()
oEdit10:Hide()
oQty:Hide()
oData:Hide()
oHorario:Hide()
oEdit2:Hide()
oEmissao:Hide()
oHora:Hide()
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
oGroup8:Hide()
oGroup9:Hide()
oGroupA:Hide()
oGroupB:Hide()
oEmpC:Hide()
oEmpenho:Hide()
oAptH:Hide()
oCodigo:Hide()
oCodPro:Hide()
oDescC:Hide()
oDescG:Hide()
oSdoEstC:Hide()
oSdoEstG:Hide()
oEstDispC:Hide()
oEstDispG:Hide()
oEstEmpC:Hide()
oEstEmpG:Hide()
oTBitmap5:Hide()
oTBitmap6:Hide()
o_UMC:Hide()
o_UMG:Hide()
o_TipoC:Hide()
o_TipoG:Hide()
oNullo2:Hide()

Return
	
//////////////////////////////////////////////////////////////////////////////
Static Function f_Show()
//////////////////////////////////////////////////////////////////////////////

oGroup2:Show()
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
oQtdSdo:Show()
oQtySdo:Show()
oProduto:Show()
oDescri:Show()
oTBitmap4:Show()
oBrowse:Show()

Return	

//////////////////////////////////////////////////////////////////////////////
Static Function f_consestoq()
//////////////////////////////////////////////////////////////////////////////

IF ( !EMPTY(cEdit0) )
	Return
ENDIF

nConsulta := 1

oGroup1:Hide()
oCracha:Hide()
oUsuario:Hide()
oEdit0:Hide()
oEdit6:Hide()
oOperacao:Hide()
oEdit1:Hide()
oNullo:Hide()

oGroupA:Show()
oGroupB:Show()
oEmpC:Show()
oCodigo:Show()
oCodPro:Show()
oDescC:Show()
oDescG:Show()
oSdoEstC:Show()
oSdoEstG:Show()
oEstDispC:Show()
oEstDispG:Show()
oEstEmpC:Show()
oEstEmpG:Show()
o_UMC:Show()
o_UMG:Show()
o_TipoC:Show()
o_TipoG:Show()
oTBitmap4:Show()
oNullo2:Show()
oCodPro:SetFocus()

lEmprocesso := .T.

oTimer:Deactivate()

Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_produto()
//////////////////////////////////////////////////////////////////////////////
Local cQry
Local lRsp := .T.

IF ( !EMPTY(cCodPro) .AND. cCodPro <> mCodPro )
	
	SB1->(dbSeek(xFilial("SB1")+cCodPro))
	
	IF SB1->(EOF())
		MsgAlert("Código do produto não cadastrado.","Código inválido")
		cCodPro := mCodPro
		lRsp    := .F.
		oCodPro:Refresh()
		
	ELSE
	
		SB2->(dbSeek(xFilial("SB2")+cCodPro+mvLocPad))

		mCodPro  := cCodPro
		cDescric := LEFT(SB1->B1_DESC,60)
		c_UM     := SB1->B1_UM
		c_Tipo   := SB1->B1_TIPO
		nSdoEst  := SB2->B2_QATU
		nEstEmp  := ( SB2->B2_QEMP + SB2->B2_RESERVA )
		nEstDisp := ( SB2->B2_QATU - SB2->B2_QEMP )
		
		cQry := "SELECT C2_PRODUTO,B1_DESC,D4_COD,D4_DATA,D4_OP,D4_QTDEORI,D4_QUANT FROM "+RetSqlName("SD4")+" D4,"+RetSqlName("SC2")+" C2,"+RetSqlName("SB1")+" B1 "
		cQry += "WHERE D4.D_E_L_E_T_ = ' ' AND C2.D_E_L_E_T_ = ' ' AND B1.D_E_L_E_T_ = ' ' "
		cQry += "AND D4_FILIAL = '"+xFilial("SD4")+"' AND C2_FILIAL = '"+xFilial("SC2")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' "
		cQry += "AND D4_LOCAL = '"+mvLocPad+"' "
		cQry += "AND D4_COD = '"+cCodPro+"' "
		cQry += "AND D4_QUANT > 0 "
		cQry += "AND C2_NUM+C2_ITEM+C2_SEQUEN = D4_OP "
		cQry += "AND C2_TPOP = 'F' "
		cQry += "AND B1_COD = C2_PRODUTO "
		cQry += "ORDER BY D4_OP "

		cQry := ChangeQuery(cQry)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMP",.T.,.T.)

		TcSetField("TMP","D4_DATA","D",08,0)

		aEmpC := {}
		dbSelectArea("TMP")
		dbGoTop()
		DO WHILE !EOF()
			AADD(aEmpC , { DTOC(TMP->D4_DATA)    , ;
								TRANSF(TMP->D4_OP,"@R XXXXXX.XX.XXX") , ;
								TMP->D4_QTDEORI       , ;
								TMP->D4_QUANT         , ;
								TMP->C2_PRODUTO       , ;
								LEFT(TMP->B1_DESC,60) } )
			dbSkip()
		ENDDO

		TMP->(dbCloseArea())
		
		IF ( LEN(aEmpC) = 0 )
			aEmpC := { {SPACE(8),SPACE(13),0,0,SPACE(30),SPACE(60)} }
		ENDIF

		oEmpC:SetArray(aEmpC)

		oEmpC:bLine := {|| { aEmpC[oEmpC:nAt,1] , ;
									aEmpC[oEmpC:nAt,2] , ;
									aEmpC[oEmpC:nAt,3] , ;
									aEmpC[oEmpC:nAt,4] , ;
									aEmpC[oEmpC:nAt,5] , ;
									aEmpC[oEmpC:nAt,6] } }
		oEmpC:lAdjustColsize := .F.
		oEmpC:Refresh()
		
		oDescG:Refresh()
		oSdoEstG:Refresh()
		oEstDispG:Refresh()

	ENDIF
	
ENDIF

Return(lRsp)

//////////////////////////////////////////////////////////////////////////////
Static Function f_empenho()
//////////////////////////////////////////////////////////////////////////////
Local nX

///IF ( !lEmProcesso )
///	Return
///ENDIF

nConsulta := 2

FOR nX:=1 TO LEN(aEmpenho)
	 SB2->(dbSeek(xFilial("SB2")+PADR(aEmpenho[nX,1],30)+aEmpenho[nX,8]))
	 SB1->(dbSeek(xFilial("SB1")+PADR(aEmpenho[nX,1],30)))

	 aEmpenho[nX,6] := SB2->B2_QATU
	 aEmpenho[nX,7] := ( SB2->B2_QATU - SB2->B2_QEMP )
NEXT

oGroup4:Hide()
oGroup5:Hide()
oBrowse:Hide()
oTBitmap5:Hide()
oTBitmap6:Hide()
oAviso1:Hide()
oAviso2:Hide()
oAviso3:Hide()				

oGroup8:Show()
oEmpenho:Show()

oEmpenho:SetArray(aEmpenho)

oEmpenho:bLine := {|| {aEmpenho[oEmpenho:nAt,1] , ;
							  aEmpenho[oEmpenho:nAt,2] , ;
							  aEmpenho[oEmpenho:nAt,3] , ;
							  aEmpenho[oEmpenho:nAt,4] , ;
							  aEmpenho[oEmpenho:nAt,5] , ;
							  aEmpenho[oEmpenho:nAt,6] , ;
							  aEmpenho[oEmpenho:nAt,7] } }
oEmpenho:lAdjustColsize := .F.
oEmpenho:Refresh()

Return

//////////////////////////////////////////////////////////////////////////////
Static Function f_aptop()
//////////////////////////////////////////////////////////////////////////////
Local nX
Local cQry

///IF ( !lEmProcesso )
///	Return
///ENDIF

nConsulta := 3

cQry := "SELECT D3_COD,D3_EMISSAO,D3_OP,D3_QUANT,H6_HORAFIN,H6_OPERADO FROM "+RetSqlName("SD3")+" D3 "
cQry += "LEFT JOIN "+RetSqlName("SH6")+" H6 ON (H6.D_E_L_E_T_ = ' ' AND H6_FILIAL = '"+xFilial("SH6")+"' AND H6_OP = D3_OP AND H6_IDENT = D3_IDENT)"
cQry += "WHERE D3.D_E_L_E_T_ = ' ' AND D3_FILIAL = '"+xFilial("SD3")+"' "
cQry += "AND D3_ESTORNO = ' ' AND D3_LOCAL = '"+mvLocPad+"' "
cQry += "AND D3_EMISSAO > '"+DTOS(dDatIni)+"' "
cQry += "AND D3_CF = 'PR0' AND D3_COD = '"+_cProd+"' "

cQry := ChangeQuery(cQry)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMP",.T.,.T.)

TcSetField("TMP","D3_EMISSAO","D",08,0)

aAptH := {}
dbSelectArea("TMP")
dbGoTop()
DO WHILE !EOF()
	AADD(aAptH , { DTOC(TMP->D3_EMISSAO) , ;
						TMP->H6_HORAFIN       , ;
						TRANSF(TMP->D3_OP,"@R XXXXXX.XX.XXX") , ;
						TMP->D3_QUANT         , ;
						TMP->H6_OPERADO } )
	dbSkip()
ENDDO

TMP->(dbCloseArea())

oGroup4:Hide()
oGroup5:Hide()
oBrowse:Hide()
oTBitmap5:Hide()
oTBitmap6:Hide()
oAviso1:Hide()
oAviso2:Hide()
oAviso3:Hide()				

oGroup9:Show()
oAptH:Show()

oAptH:SetArray(aAptH)

oAptH:bLine := {|| { aAptH[oAptH:nAt,1] , ;
							aAptH[oAptH:nAt,2] , ;
							aAptH[oAptH:nAt,3] , ;
							aAptH[oAptH:nAt,4] , ;
							aAptH[oAptH:nAt,5] } }
oAptH:lAdjustColsize := .F.
oAptH:Refresh()

Return