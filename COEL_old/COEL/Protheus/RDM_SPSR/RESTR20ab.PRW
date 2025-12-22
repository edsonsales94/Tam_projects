#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "JPEG.CH"   


User Function EtiqEven()

SetPrvt("CPERG,_CPORTA,CINDEXSB1,DINDEXSB1,CCONDICAO,_SALIAS")
SetPrvt("AREGS,I,J,")

/*
-----------------------------------------------------------------------------
|  rdmake    | restr20  | Autor | FERNANDO AMORIM       | Data | 25.11.10   |
-----------------------------------------------------------------------------
|  Descricao | Rotina de impressao de etiquetas com codigo de Barras        |
|            | COM LOGOTIPO                                   		        |
-----------------------------------------------------------------------------
|  ALTERADO:                                                                |
-----------------------------------------------------------------------------

MV_PAR01 = CODIGO DO PRODUTO,C,15
MV_PAR02 = QUANTIDADE DE ETIQUETAS,N
MV_PAR03 = NUMERO DA OP,C,6
MV_PAR04 = ITEM DA OP
MV_PAR05 = PORTA DA IMPRESSORA,N,1
*/

Private cPerg := "RESTR20"  // Nome da Pergunte

/*IF ( M->cNumEmp == "0301" )
	f_etqmanaus()                          ///Carlos: 09/04/2015
ELSE*/
	IF ! Pergunte(cPerg,.T.)               // Pergunta no SX1
		Return
	Endif
                            
	Processa({|| _EtiQC() })
//ENDIF

Return

//-----------------------------------------------------------------------------

Static Function _EtiQC()

cIndexSB1 := CriaTrab(nil,.f.)
DbSelectArea("SB1")
dIndexSB1 :="B1_COD"
cCondicao :="B1_FILIAL = '"+xFilial("SB1")+"' .AND. "
cCondicao := cCondicao + 'B1_COD     == "'+ mv_par01 +'" '

IndRegua("SB1",cIndexSB1,dIndexSB1,,cCondicao,"Selecionando Produtos..." )
SB1->(DBGoTop())

If  mv_par05 == 1
	MSCBPRINTER("S600","LPT1",,,.f.,,,,)
ElseIf mv_par05 == 2
	MSCBPRINTER("S300","COM1:9600,N,8,0",Nil,42) //Seta tipo de impressora no padrao ZPL  42
EndIf

MSCBCHKStatus(.f.)
//MSCBLOADGRF("LOGO.GRF") //Carrega o logotipo para impressora
MSCBLOADGRF("\ARQUIVOS\FOTOS\COEL.GRF")
//Seta Impressora (Zebra)

ProcRegua(SB1->(RecCount()))

While  ! SB1->(eof())
	
	IncProc("Imprimindo Etiqueta...")
	
	_cData1:= DTOS(dDatabase)
	_cData1:= Substr(_cData1,5,2)+Substr(_cData1,3,2)
	*94...240VCA*RESERVATORIO*
	_cDesc := IIF(RTRIM(SB1->B1_COD)=="NI35HB--P----" , "CONTROLE NIVEL ELETR.NI35*94...240VCA*BOMBA* ",IIF(!EMPTY(SB1->B1_X_DESCC),SB1->B1_X_DESCC,SB1->B1_DESC))         ///Carlos: 01/11/2012 - ATE DEFINIR CAMPO NO CAD.
	_cDesc := IIF(RTRIM(SB1->B1_COD)=="NI35HR--P----" , "CONTROLE NIVEL ELETR.NI35*94...240VCA*RESERVATORIO* ",_cDesc)        ///Carlos: 01/11/2012 - ATE DEFINIR CAMPO NO CAD.
	
	If  mv_par05 == 1  //ZEBRA Z4
	
		 If mv_par06 == 2
			 _cDesc := mv_par07
		 EndIf
		 
		 If mv_par08 == 2
			_dData := mv_par09
		 Else
			_dData := alltrim(STR(Month(dDataBase)))+ "/" + ALLTRIM(STR(YEAR(dDataBase)))
		 EndIf  
		 
		MSCBBEGIN(mv_par02/2,2) //Inicio da Imagem da Etiqueta //PASSA QUANTIDADE, VELOCIDADE, TAMANHO
		MSCBWRITE("^LH08,16^FS")
	   
		MSCBGRAFIC(0.8,0.5,"COEL") //COLOQUEI O LOGO EM SP ANDRE 22/07/16 
		//MSCBSAY(9.5,0.5,","P","D","18,10")//0.75   12  
		//1a. COLUNA                                           `
		MSCBSAY(0.8,9.55,SUBSTR(ALLTRIM(_cDesc),1,40),"N","B","19,10")//DESCRICAO
		MSCBSAY(0.8,13.55, alltrim(MV_PAR01),"N","B","18,10")//7   3.0                                       //CODIGO DO PRODUTO CHUMBADO P TESTE
		MSCBSAY(0.8,17.55,alltrim(MV_PAR03+"/"+MV_PAR04),"N","B","18,10")//7     30                                      //NUMERO DA OP CHUMBADO P TESTE
		MSCBSAY(0.8,21.55,_dData,"N","B","18,10")//7  3.0            //MES:ANO
		MSCBSAYBAR(20,13.75,AllTrim("7895113" + ALLTRIM(SB1->B1_CODBAR)),"N","E",6,.f.,.t.,.f.,,2,1,.F.)   //4
		
		//2a. COLUNA

		MSCBGRAFIC(52.0,0.5,"COEL")    //53
		//MSCBGRAFIC(0.5,0.5,"COEL") //COLOQUEI O LOGO EM SP ANDRE 22/07/16
		MSCBSAY(52.5,9.55,SUBSTR(ALLTRIM(_cDesc),1,40),"N","B","18,10")//0.75     62                                //DESCRICAO2 DO PRODUTO
		MSCBSAY(52.5,13.55, alltrim(MV_PAR01),"N","B","18,10")//7      53                                     //CODIGO DO PRODUTO CHUMBADO P TESTE
		MSCBSAY(52.5,17.55,alltrim(MV_PAR03+"/"+MV_PAR04),"N","B","18,10")//7    80                                       //NUMERO DA OP CHUMBADO P TESTE
		MSCBSAY(52.5,21.55,_dData,"N","B","18,10")//7  3.0            //MES:ANO
		MSCBSAYBAR(70,13.55,AllTrim("7895113" + ALLTRIM(SB1->B1_CODBAR)),"N","E",6,.f.,.t.,.f.,,2,1,.F.)   //55
		
		MSCBEND() //Fim da Imagem da Etiqueta
		
	Else
		MSGBOX("PARAMETRO NÃO PERMITIDO")
	EndIf
	
	SB1->(DbSkip())
End
//MSCBCLOSEPRINTER()

dbSelectArea("SB1")
RetIndex("SB1")
Ferase(cIndexSB1+OrdBagExt())
Return

///////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_etqmanaus()
///////////////////////////////////////////////////////////////////////////////////////////////
Local cLogo  := FisxLogo("1")
Local cNullo := SPACE(6)

Private oVd  := LoadBitmap( GetResources(), 'br_verde')
Private oVm  := LoadBitmap( GetResources(), 'br_vermelho')
Private oAm  := LoadBitmap( GetResources(), 'br_amarelo')

Private oGroup1,oGroup2,oGroup3,oEdit1,oTBar,oPrtImp,oPorta
Private oTBitMap1,oTBitMap2,oTBitMap3,oTBitMap4,oTBmp1,oTBmp2,oTBmp3,oTBmp4,oTBmp5
Private oTBmp01,oTBmp02,oTBmp03,oTBmp04,oTBmp05,oTBmp06,oTBmp07,oTBmp08
Private oNumero,oNOP,oProdDesc,oProduto,oDescri
Private oQtdEtq,oQtyEtq,oQtdOP,oQtyOP,oNullo
Private oRot01,oRot02,oRot03,oRot04,oRot05,oRot06,oRot07,oRot08

Private cEdit1		 := Space(8)
Private nQtdEtq    := 0
Private cPrtImp    := "LPT1"
Private cRot01     := ""
Private cRot02     := ""
Private cRot03     := ""
Private cRot04     := ""
Private cRot05     := ""
Private cRot06     := ""
Private cRot07     := ""
Private cRot08     := ""

Private _cOp	    := Space(11)
Private _cCod      := Space(30)
Private _cDescCC   := Space(50)
Private _cProd	    := Space(60)
Private _cDesc     := Space(50)
Private _nQtde     := 0
Private aPrtImp    := { "LPT1" , "COM1" } 
Private aEmpenho   := {{SPACE(30),SPACE(30),0,SPACE(2)}}

Private _xOpc	    := 1
Private nTimeOut   := 120000

Private _oDlg				                       // Dialog Principal
Private _nHRes 		:= oMainWnd:nClientWidth
Private _cTheme		:= Alltrim(GetTheme())
Private _lMdiChild	:= SetMdiChild()
Private lEmProcesso  := .F.
Private lSaida       := .F.

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
		
///DEFINE MSDIALOG _oDlg TITLE OemtoAnsi(":::... Etiqueta de Produto ...:::") FROM 000,000 TO 526,1100 COLORS 0, 16777215 PIXEL    <--- Tela grande
DEFINE MSDIALOG _oDlg TITLE OemtoAnsi(":::... Etiqueta de Produto ...:::") FROM 000,000 TO 526,984 COLORS 0, 16777215 PIXEL     //Tela da Estacao Cod.Barra

oTBar := TBar():New( _oDlg,40,25,.T.,,,'tbar_coel',.F. )   ///40,25

oTimer := TTimer():New(nTimeOut,{|| f_cancela() },_oDlg)	

@ 015, 002 GROUP oGroup1 TO 110, 163 PROMPT OemToAnsi("PARAMETROS")        					  OF _oDlg COLOR 0, 16777215 PIXEL
@ 015, 166 GROUP oGroup2 TO 256, 266 PROMPT OemToAnsi("OPERAÇÃO")        						  OF _oDlg COLOR 0, 16777215 PIXEL
@ 015, 269 GROUP oGroup3 TO 075, 492 PROMPT OemToAnsi("ORDEM DE PRODUÇÃO")        			  OF _oDlg COLOR 0, 16777215 PIXEL	
@ 077, 269 GROUP oGroup4 TO 256, 492 PROMPT OemToAnsi("ITENS DA O.P.")            			  OF _oDlg COLOR 0, 16777215 PIXEL	

@ 024, 006 SAY   oNumOP 		PROMPT  OemToAnsi("Ordem de Produção")				SIZE 110, 009 OF _oDlg COLOR  CLR_HBLUE   PIXEL  Font oFnt
@ 034, 006 MSGET oEdit1 		VAR     cEdit1    PICTURE "@R XXXXXX.XX"       	SIZE 060, 014 OF _oDlg COLORS 0, 16777215 PIXEL        Font oFnt4  VALID f_cbar(cEdit1)
@ 040, 078 MSGET oNullo 		VAR     cNullo    PASSWORD                   	SIZE 001, 001 OF _oDlg COLORS 0, 16777215 PIXEL                     

@ 054, 006 SAY   oQtyEtq		PROMPT  "Qtde. Etiquetas"        					SIZE 110, 009 OF _oDlg COLOR CLR_HBLUE    PIXEL  Font oFnt
@ 064, 006 MSGET oQtdEtq 		VAR     nQtdEtq   PICTURE "@E 9999"					SIZE 030, 012 OF _oDlg COLORS 0, 16777215 PIXEL  Font oFnt3

@ 054, 094 SAY      oPorta 	PROMPT  "Porta Impressora"       					SIZE 110, 009 OF _oDlg COLOR CLR_HBLUE    PIXEL  Font oFnt
oPrtImp := tComboBox():New(064,094,{|u3|if(PCount()>0,cPrtImp := u3 , cPrtImp )}, aPrtImp,45,10,_oDlg,,/*funcao*/,,,,.T.,/*fonte*/,,,,,,,,'cPrtImp')     
///@ 058, 100 ComboBox cPrtImp   Items aPrtImp                                   Size 070, 021 OF _oDlg PIXEL

@ 022, 271 SAY   oNumero		PROMPT  OemToAnsi("Número")        					SIZE 060, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 030, 271 SAY   oNOP   		VAR     _cOP      PICTURE "@R XXXXXX.XX.999"		SIZE 080, 012 OF _oDlg COLOR  CLR_HRED    PIXEL  Font oFnt4
@ 022, 440 SAY   oQtdOP  		PROMPT  "Quantidade"              					SIZE 070, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 030, 450 SAY   oQtyOP 		VAR     _nQtde    PICTURE "@E 99,999" 				SIZE 030, 012 OF _oDlg COLOR  CLR_HRED    PIXEL  Font oFnt
@ 044, 271 SAY   oProdDesc		PROMPT  OemToAnsi("Produto / Descrição")			SIZE 120, 009 OF _oDlg COLOR  CLR_BLACK   PIXEL  Font oFnt
@ 053, 271 SAY   oProduto 		VAR     _cProd                   					SIZE 130, 014 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt4
@ 065, 271 SAY   oDescri		VAR     _cDesc                   					SIZE 240, 014 OF _oDlg COLOR  CLR_BLUE    PIXEL  Font oFnt


oTBitmap1 := TBtnBmp2():New( 00, 00, 40, 70, 'S4WB008N' ,,,,;
					{ || Calculadora() }  ,oTBar,'Calculadora',,.F.,.F.)
oTBitmap2 := TBtnBmp2():New( 00, 00, 40, 70, 'button_exit' ,,,,;
					{ || ( lSaida := .T. , _oDlg:End() ) }  ,oTBar,'Sair',,.F.,.F.)
oTBitmap3 := TBtnBmp2():New( 184, 0090, 70, 30,'conf_coel',,,,;   
					{ || f_confirma() }  ,_oDlg,'Confirma a impressão da Etiqueta',,.F.,.F.)
oTBitmap4 := TBtnBmp2():New( 184, 0190, 70, 30,'coel_abortar',,,,;
					{ || f_cancela() } , _oDlg,'Encerra a impressão da(s) Etiqueta(s)',,.F.,.F.)					

@ 023, 169 SAY   oRot01		VAR     cRot01                                         			SIZE 100, 009 OF _oDlg COLOR CLR_HBLUE  PIXEL  Font oFnt12
@ 050, 169 SAY   oRot02		VAR     cRot02                                   					SIZE 100, 009 OF _oDlg COLOR CLR_HBLUE  PIXEL  Font oFnt12
@ 078, 169 SAY   oRot03		VAR     cRot03                                         			SIZE 100, 009 OF _oDlg COLOR CLR_HBLUE  PIXEL  Font oFnt12
@ 106, 169 SAY   oRot04		VAR     cRot04                                   					SIZE 100, 009 OF _oDlg COLOR CLR_HBLUE  PIXEL  Font oFnt12
@ 134, 169 SAY   oRot05		VAR     cRot05                                         			SIZE 100, 009 OF _oDlg COLOR CLR_HBLUE  PIXEL  Font oFnt12
@ 161, 169 SAY   oRot06		VAR     cRot06                                   					SIZE 100, 009 OF _oDlg COLOR CLR_HBLUE  PIXEL  Font oFnt12
@ 189, 169 SAY   oRot07		VAR     cRot07                                         			SIZE 100, 009 OF _oDlg COLOR CLR_HBLUE  PIXEL  Font oFnt12
@ 217, 169 SAY   oRot08		VAR     cRot08                                   					SIZE 100, 009 OF _oDlg COLOR CLR_HBLUE  PIXEL  Font oFnt12

oTBmp01 := TBtnBmp2():New( 060, 326, 196, 40,'coel_op01',,,,;
					{ || nil }  ,_oDlg,,,.T.,.T.)
oTBmp02 := TBtnBmp2():New( 115, 326, 196, 40,'coel_op02',,,,;
					{ || nil } , _oDlg,,,.T.,.T.)
oTBmp03 := TBtnBmp2():New( 172, 328, 196, 40,'coel_op03',,,,;
					{ || nil }  ,_oDlg,,,.T.,.T.)
oTBmp04 := TBtnBmp2():New( 227, 328, 196, 40,'coel_op04',,,,;
					{ || nil } , _oDlg,,,.T.,.T.)
oTBmp05 := TBtnBmp2():New( 282, 328, 196, 40,'coel_op05',,,,;
					{ || nil }  ,_oDlg,,,.T.,.T.)
oTBmp06 := TBtnBmp2():New( 336, 328, 196, 40,'coel_op06',,,,;
					{ || nil } , _oDlg,,,.T.,.T.)
oTBmp07 := TBtnBmp2():New( 392, 328, 196, 40,'coel_op07',,,,;
					{ || nil }  ,_oDlg,,,.T.,.T.)
oTBmp08 := TBtnBmp2():New( 449, 328, 196, 40,'coel_op08',,,,;
					{ || nil } , _oDlg,,,.T.,.T.)
		
///oBrowse := TCBrowse():New( 084 , 271, 273, 170,,{'Item','Componente','Descrição','Quant.','U.M.'},{60,130,30,20},_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	   <--- Tela Grande
oBrowse := TCBrowse():New( 084 , 271, 218, 170,,{'Componente','Descrição','Quant.','U.M.'},{56,110,30,20},_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )	

oBrowse:SetArray(aEmpenho)

oBrowse:bLine := {|| { aEmpenho[oBrowse:nAt,1] , ;
							  aEmpenho[oBrowse:nAt,2] , ;
							  aEmpenho[oBrowse:nAt,3] , ;
							  aEmpenho[oBrowse:nAt,4] } }

/////
/////Oculta objetos
/////
f_Hide()
oQtdEtq:Disable()
oPrtImp:Disable()
oTimer:DeActivate()

ACTIVATE MSDIALOG _oDlg CENTER Valid lSaida
	
Return

///////////////////////////////////////////////////////////
Static Function f_cancela()
///////////////////////////////////////////////////////////

oTimer:DeActivate()
	
f_Hide()

cEdit1  := SPACE(8)
nQtdEtq := 0
cPrtImp := "LPT1"

oEdit1:Enable()
oNullo:Show()
oQtdEtq:Disable()
oPrtImp:Disable()
oEdit1:SetFocus()

Return

///////////////////////////////////////////////////////////
Static Function f_confirma()
///////////////////////////////////////////////////////////
Local mv_par01 := SB1->B1_COD
Local mv_par05 := ASCAN(aPrtImp , cPrtImp )
Local mv_par03 := LEFT(cEdit1,6)
Local mv_par04 := SUBS(cEdit1,7,2)
Local	_cData1:= DTOS(dDatabase)

IF ( nQtdEtq <= 0 )
	MsgStop("Quantidade inválida.","Valor Negativo")
	Return
ENDIF

///
_cDesc  := IIF(RTRIM(SB1->B1_COD)=="NI35HB--P----" , "CONTROLE NIVEL ELETR.NI35*94...240VCA*BOMBA* ",IIF(!EMPTY(SB1->B1_X_DESCC), SB1->B1_X_DESCC , SB1->B1_DESC ) )         ///Carlos: 01/11/2012 - ATE DEFINIR CAMPO NO CAD.

_cDesc  := IIF(RTRIM(SB1->B1_COD)=="NI35HR--P----" , "CONTROLE NIVEL ELETR.NI35*94...240VCA*RESERVATORIO* ",_cDesc)        ///Carlos: 01/11/2012 - ATE DEFINIR CAMPO NO CAD.

_cData1 := Substr(_cData1,5,2)+Substr(_cData1,3,2)

If  mv_par05 == 1
	MSCBPRINTER("S600","LPT1",,,.f.,,,,)
Else
	MSCBPRINTER("S300","COM1:9600,N,8,0",Nil,42) //Seta tipo de impressora no padrao ZPL  42
EndIf

MSCBCHKStatus(.f.)
MSCBLOADGRF("\ARQUIVOS\FOTOS\COEL.GRF")

MSCBBEGIN(nQtdEtq/2,2) //Inicio da Imagem da Etiqueta //PASSA QUANTIDADE, VELOCIDADE, TAMANHO
MSCBWRITE("^LH08,16^FS")

//1a. COLUNA                                           `
MSCBGRAFIC(0.5,0.5,"COEL")   //3.0                                                                    //LOGOTIPO
MSCBSAY(9.5,0.5,SUBSTR(ALLTRIM(_cDesc),1,25),"P","D","18,10")//0.75   12                                  //DESCRICAO1 DO PRODUTO
MSCBSAY(9.5,3.5,SUBSTR(ALLTRIM(_cDesc),26,25),"P","D","18,10")//0.75  12                                   //DESCRICAO2 DO PRODUTO
MSCBSAY(0.5,6.3, alltrim(MV_PAR01),"N","D","18,10")//7   3.0                                       //CODIGO DO PRODUTO CHUMBADO P TESTE
MSCBSAY(30.5,6.3,alltrim(MV_PAR03+"/"+MV_PAR04),"N","D","18,10")//7     30                                      //NUMERO DA OP CHUMBADO P TESTE
//		MSCBSAY(0.5,9.3,alltrim(STR(Month(dDataBase)))+ "/" + ALLTRIM(STR(YEAR(dDataBase))),"N","D","18,10")//7  3.0            //MES:ANO
MSCBSAYBAR(1.5,12.55,AllTrim("7895113" + ALLTRIM(SB1->B1_CODBAR)),"N","E",4,.f.,.t.,.f.,,2,1,.F.)   //4
MSCBSAYBAR(27.5,12.55,alltrim(_cData1),"N","C",6,.f.,.t.,.f.,,2,1,.F.) //30  //monta codigo de barras 9,25CHUMBADO P TESTE

//2a. COLUNA
MSCBGRAFIC(50.0,0.5,"COEL")    //53                                                                    //LOGOTIPO
MSCBSAY(59.0,0.5,SUBSTR(ALLTRIM(_cDesc),1,25),"P","D","18,10")//0.75      62                               //DESCRICAO1 DO PRODUTO
MSCBSAY(59.0,3.5,SUBSTR(ALLTRIM(_cDesc),26,25),"P","D","18,10")//0.75     62                                //DESCRICAO2 DO PRODUTO
MSCBSAY(50.0,6.3, alltrim(MV_PAR01),"N","D","18,10")//7      53                                     //CODIGO DO PRODUTO CHUMBADO P TESTE
MSCBSAY(80.0,6.3,alltrim(MV_PAR03+"/"+MV_PAR04),"N","D","18,10")//7    80                                       //NUMERO DA OP CHUMBADO P TESTE
//		MSCBSAY(50.5,9.3,alltrim(STR(Month(dDataBase)))+ "/" + ALLTRIM(STR(YEAR(dDataBase))),"N","D","18,10")//7     53          //MES:ANO
MSCBSAYBAR(52.0,12.55,AllTrim("7895113" + ALLTRIM(SB1->B1_CODBAR)),"N","E",6,.f.,.t.,.f.,,2,1,.F.)   //55
MSCBSAYBAR(78.0,12.55,alltrim(_cData1),"N","C",6,.f.,.t.,.f.,,2,1,.F.) //81  //monta codigo de barras 9,25CHUMBADO P TESTE

MSCBEND() //Fim da Imagem da Etiqueta
MSCBClosePrinter()
		
Return

///////////////////////////////////////////////////////////
Static Function f_hide()
///////////////////////////////////////////////////////////

oGroup2:Hide()
oGroup3:Hide()
oGroup4:Hide()
oNumero:Hide()
oNOP:Hide()
oQtdOP:Hide()
oQtyOP:Hide()
oProdDesc:Hide()
oProduto:Hide()
oDescri:Hide()
oTBitmap3:Hide()
oTBitmap4:Hide()
oTBmp01:Hide()
oTBmp02:Hide()
oTBmp03:Hide()
oTBmp04:Hide()
oTBmp05:Hide()
oTBmp06:Hide()
oTBmp07:Hide()
oTBmp08:Hide()
oRot01:Hide()
oRot02:Hide()
oRot03:Hide()
oRot04:Hide()
oRot05:Hide()
oRot06:Hide()
oRot07:Hide()
oRot08:Hide()
oBrowse:Hide()

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////Validacao Da Digitacao Dos Dados Da Dialog. 
////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function f_cbar(_xConteudo)

Local aOper
Local _lRet	 := .t. 
Local _nX    := 0

If ( !Empty(_xConteudo) )
	cEdit1     := _xConteudo
	_xConteudo += "001"
	_cOP	     := _xConteudo
	DbSelectArea("SC2")
	DbSetOrder(1)                                      ///C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD
	dbSeek(xFilial("SC2") + _xConteudo)
	If !EOF()	
		cNullo   := SPACE(6)
		nQtdEtq  := 0
		aEmpenho := {}
		dbSelectArea("SD4")
		dbSetOrder(2)
		dbSeek(xFilial("SD4")+_xConteudo,.T.)
		DO WHILE !EOF().AND.D4_FILIAL==xFilial("SD4").AND.RTRIM(D4_OP)==_xConteudo
			SB1->(dbSeek(xFilial("SB1")+SD4->D4_COD))
			_nX++
			AADD(aEmpenho , { SD4->D4_COD           , ;
									LEFT(SB1->B1_DESC,30) , ;
									SD4->D4_QTDEORI       , ;
									SB1->B1_UM } )
			dbSkip()
		ENDDO	

		SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
		
		_nQtde := SC2->C2_QUANT
		_cProd := Alltrim(SC2->C2_PRODUTO) 
		_cDesc := LEFT(SB1->B1_DESC,50)
		
		////
		////Monta os codigo de barra de cada operacao
		////
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
				&cRtr   := RTRIM(SG2->G2_OPERAC)+"-"+RTRIM(SG2->G2_DESCRI)
			ENDIF	
			dbSkip()
		ENDDO	

		ix := 1
		DO WHILE ix <= LEN(aOper)
			////
			////Exibe codigo de barras + Roteiro
			////
			cOpr := aOper[ix,1]						
			cRtr := "oTBmp"+cOpr+":Show()"                 ///CODIGO DE BARRAS
			&cRtr
			cRtr := "oTBmp"+cOpr+":Refresh()"
			&cRtr						
			
			cRtr  := "oRot"+cOpr+":Show()"                 ///ROTEIRO
			&cRtr
			ix++
		ENDDO
		
		/////
		/////Re-exibe objetos
		/////
		
		oEdit1:Disable()
		oNullo:Hide()
		oQtdEtq:Enable()
		oPrtImp:Enable()

		oGroup2:Show()
		oGroup3:Show()
		oGroup4:Show()
		oNumero:Show()
		oNOP:Show()
		oQtdOP:Show()
		oQtyOP:Show()
		oProdDesc:Show()
		oProduto:Show()
		oDescri:Show()
		oTBitmap3:Show()
		oTBitmap4:Show()
		oBrowse:Show()

		oBrowse:SetArray(aEmpenho)

		oBrowse:bLine := {|| { aEmpenho[oBrowse:nAt,1] , ;
									  aEmpenho[oBrowse:nAt,2] , ;
									  aEmpenho[oBrowse:nAt,3] , ;
									  aEmpenho[oBrowse:nAt,4] } }
		oBrowse:lAdjustColsize := .F.
		oBrowse:Refresh()
		
		///oQtdEtq:SetFocus()
		oTimer:Activate()

	Else
		MsgStop("Ordem de Produção NÃO Encontrada!","Atenção")
		_lRet := .f.
	EndIf
ENDIF

Return(_lRet)