#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                                         `
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CAptPrd ³ Autor ³ Rogerio Oliveira      ³ Data ³27/Set/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Apontamento de Producao Via Leitura De Cod. De Barras.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Coel                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Captprd()

//Variaveis Locais da Funcao
Local _aArea	:= GetArea()
Private cEdit1	:= Space(50)
Private cEdit2	:= 0 
Private cEdit3	:= 0
Private cEdit4	:= ""
Private _cOp	:= Space(11)
Private _nQuant	:= 0  
Private _nPerda := 0
Private _cProd	:= Space(40)

Private _cUm	:= Space(3)
Private _cAlmox	:= Space(2) 
Private _cParcTot := Space(1)
Private oEdit1
Private oEdit2
Private oEdit3
Private oEdit4
Private _xOpc	:= 9

// Variaveis Private da Funcao
Private _oDlg				// Dialog Principal
Private INCLUI := .F.	// (na Enchoice) .T. Traz registro para Inclusao / .F. Traz registro para Alteracao/Visualizacao
Private _nHRes 		:= oMainWnd:nClientWidth
Private _cTheme		:= Alltrim(GetTheme())
Private _lMdiChild	:= SetMdiChild()


//DEFINE FONT 	oBold NAME "Times New Roman"	SIZE 0,  20
DEFINE FONT 	oFnt  NAME "Arial"				SIZE 0, -16 BOLD	// "Times New Roman" Maior
DEFINE FONT 	oFnt2 NAME "Arial"				SIZE 0, -14 BOLD	// "Times New Roman" Menor

While _xOpc <> 2
	
	// Esvazia variavel Do Cod Barras
	cEdit1 := Space(50)
	
	DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Apontamento De OPs Por Cód. Barras") FROM C(236),C(303) TO C(534),C(839) PIXEL
	
	// Cria as Groups do Sistema
	@ C(002),C(003) TO C(053),C(267) LABEL "  Entrada Dados  " PIXEL OF _oDlg
	@ C(055),C(003) TO C(130),C(266) LABEL "  Informações Apontamento  " PIXEL OF _oDlg
	
	// Cria Componentes Padroes do Sistema
	
	@ C(012),C(010) Say "Cod. Barras" 				Size C(029),C(008) Color CLR_BLACK 				PIXEL OF _oDlg
	@ C(011),C(042) MsGet oEdit1 Var cEdit1 		Size C(217),C(009) Color CLR_BLACK 				PIXEL OF _oDlg Valid(_fVlDlg("CBAR",cEdit1)) When oEdit1:Refresh()
	
	@ C(026),C(010) Say "Quantidade:" 				Size C(031),C(008) Color CLR_BLACK 				PIXEL OF _oDlg
	@ C(025),C(042) MsGet oEdit2 Var cEdit2 		Size C(060),C(009) Color CLR_BLACK 				PIXEL OF _oDlg When !Empty(cEdit1) Valid(_fVlDlg("QTDE",cEdit2)) Picture PesqPict("SC2","C2_QUANT")

	@ C(026),C(160) Say "Perda:" 		    		Size C(031),C(008) Color CLR_BLACK 				PIXEL OF _oDlg
	@ C(025),C(190) MsGet oEdit3 Var cEdit3 		Size C(060),C(009) Color CLR_BLACK 				PIXEL OF _oDlg When !Empty(cEdit1) Valid(_fVlDlg("PERDA",cEdit3)) Picture PesqPict("SD3","D3_PERDA")
 
	@ C(040),C(010) Say "Parc/Total:" 				Size C(031),C(008) Color CLR_BLACK 				PIXEL OF _oDlg
	@ C(039),C(042) Say _cParcTot       			Size C(040),C(008) Color CLR_BLACK Font oFnt	PIXEL OF _oDlg

	@ C(065),C(010) Say "Ordem Producao:" 			Size C(070),C(008) Color CLR_BLACK Font oFnt	PIXEL OF _oDlg
	@ C(065),C(080) Say _cOp		 				Size C(070),C(008) Color CLR_HRED  Font oFnt	PIXEL OF _oDlg
	@ C(065),C(160) Say "Quantidade:" 				Size C(070),C(008) Color CLR_BLACK Font oFnt	PIXEL OF _oDlg
	@ C(065),C(210) Say _nQuant		 				Size C(070),C(008) Color CLR_HRED  Font oFnt	PIXEL OF _oDlg Picture PesqPict("SC2","C2_QUANT")
	@ C(080),C(010) Say "Produto:" 					Size C(070),C(008) Color CLR_BLACK Font oFnt	PIXEL OF _oDlg
	@ C(080),C(080) Say _cProd				 		Size C(200),C(008) Color CLR_BLACK Font oFnt2	PIXEL OF _oDlg
	@ C(095),C(010) Say "Un. Medida:" 				Size C(070),C(008) Color CLR_BLACK Font oFnt	PIXEL OF _oDlg
	@ C(095),C(080) Say _cUm	 					Size C(040),C(008) Color CLR_BLACK Font oFnt	PIXEL OF _oDlg
	@ C(110),C(010) Say "Almox:" 			   		Size C(070),C(008) Color CLR_BLACK Font oFnt	PIXEL OF _oDlg
	@ C(110),C(080) Say _cAlmox 			  		Size C(040),C(008) Color CLR_BLACK Font oFnt	PIXEL OF _oDlg
	
	@ C(137),C(010) Say "Específico " + Capital(Alltrim(SM0->M0_NOMECOM))	Size C(200),C(008) Color CLR_GRAY  Font oFnt	PIXEL OF _oDlg
	
	DEFINE SBUTTON FROM C(135),C(204) TYPE 1 ENABLE OF _oDlg Action Eval( { || _xOpc := 1, _oDlg:End()	} )
	DEFINE SBUTTON FROM C(135),C(238) TYPE 2 ENABLE OF _oDlg Action Eval( { || _xOpc := 2, _oDlg:End()	} )
	
	ACTIVATE MSDIALOG _oDlg CENTERED
	
	/*
	Color CLR_HBLUE
	Color CLR_HRED
	Color CLR_BLACK
	*/
	
	// Se confirmar, grava dados
	If _xOpc == 1
		MsgRun("Aguarde... Apontando OP... ",,{|| _fExecAp(cEdit1,cEdit2,cEdit3)})
	EndIf
EndDo

RestArea(_aArea)

Return()
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
Static Function _fExecAp(cEdit1,cEdit2,cEdit3)

Local _cArea := GetArea()

DbSelectArea("SC2")
DbSetOrder(1) // C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD
If MsSeek(xFilial("SC2") + Substr(cEdit1,1,11))
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	MsSeek(xFilial("SB1") + SC2->C2_PRODUTO )
	
	_cOp		:= Substr(cEdit1,1,11)
	_cUm		:= SC2->C2_UM
	_cAlmox		:= SC2->C2_LOCAL    
	_cParcTot   := SC2->C2_PARCTOT
	
	nOpc := 3
	lMsErroAuto := .F.
	
	_cTM := "400" //SuperGetMv("CO_TMPRDA",.F.,"002")
	
	aTes:={;
	{"D3_TM"     	, _cTM		,Nil},;
	{"D3_OP"  		, _cOp		,Nil},;
	{"D3_PERDA"  	, cEdit3	,Nil},; 
	{"D3_PARCTOT"  	, cEdit4	,Nil},;
	{"D3_QUANT"  	,_nQuant    ,Nil}}
	
	MSExecAuto({|x,y| Mata250(x,y)},aTes,nOpc)
	
	If lMsErroAuto
		MostraErro()
	EndIf
EndIf

RestArea(_cArea)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ _fVlDlg  º Autor ³ Eduardo Alberti    º Data ³ 24/Aug/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao Da Digitacao Dos Dados Da Dialog.                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _fVlDlg(_cTipo,_xConteudo)

Local _aArea 	:= GetArea()
Local _lRet		:= .t.

Do Case
	Case Upper(Alltrim(_cTipo)) == "CBAR"
		
		DbSelectArea("SC2")
		DbSetOrder(1) // C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD
		If MsSeek(xFilial("SC2") + Substr(_xConteudo,1,11))
			
			DbSelectArea("SB1")
			DbSetOrder(1)
			MsSeek(xFilial("SB1") + SC2->C2_PRODUTO )
			
			_cOp		:= Substr(_xConteudo,1,11)
			_nQuant		:= Val(Substr(_xConteudo,12,20)) / 100
			_cProd		:= Alltrim(SC2->C2_PRODUTO) + " - " + Alltrim(SB1->B1_DESC)
			_cUm		:= SC2->C2_UM
			_cAlmox		:= SC2->C2_LOCAL          
			_cParcTot   := SC2->C2_PARCTOT
			
			_oDlg:Refresh()
			
		Else
			MsgInfo("Ordem De Produção Não Encontrada!","Atenção")
			_lRet := .f.
		EndIf
		
	Case Upper(Alltrim(_cTipo)) == "QTDE"
		
		_nQuant := IIf(_xConteudo > 0,_xConteudo,_nQuant)
		
		oEdit2:Refresh()
		_oDlg:Refresh()
		
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
