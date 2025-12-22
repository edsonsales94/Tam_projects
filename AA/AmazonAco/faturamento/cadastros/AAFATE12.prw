#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"
#INCLUDE "APWIZARD.CH"

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥AAFATE12  ∫ Autor ≥ Wladimir Vieira    ∫ Data ≥  27/03/2019 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ mbrowse certificado de qualidade                           ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP6 IDE                                                    ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
Alteracoes:

/*/

user function AAFATE12()

	//  DeclaraÁ„o de vari·veis utilizadas no programa
	private cString, aRotina, aCores, cCadastro
	private cPerg   :='RFATA03   '
	private _nFiltro:=''
	Private cCadastro := "CERTIFICADO DE QUALIDADE"
	//public _nPosVend:=.T.

	// Valida perguntas no SX1, caso n„o exista cria as perguntas
	//ValidaPerguntas()

	// Pergunta no SX1
	//if !pergunte(cPerg,.T.)
	//	return
	//end

    dbSelectArea("SD2")
    dbSetOrder(3)
    dbGotop()    
    dbSeek(xFilial("SD2"))
	cString := 'SD2'
	aIndex := {}

	/*
	// O bloco abaixo define e executa o filtro de acordo com a tela de parametros

	// Preparacao para validacao da data do cliente ou data de entrega
	_mParFAT := GETMV("MV_YUSRFAT")
	_mCodusr := __cUserID

	// Verifica se considera faturados
	If MV_PAR10 == 2  // nao considera
	// Abaixo: Se usuario nao for do Faturamento usa data do cliente (C6_SUGENTR), caso contrario C6_ENTREGA
	If !_mCodusr$_mParFAT
	cFiltro := "C6_QTDVEN > C6_QTDENT .AND. C6_SUGENTR >= ctod('"+DTOC(MV_PAR01)+"') .AND. C6_SUGENTR <= ctod('"+dtoc(MV_PAR02)+"') "//Expressao do Filtro
	Else
	cFiltro := "C6_QTDVEN > C6_QTDENT .AND. C6_ENTREG >= ctod('"+DTOC(MV_PAR01)+"') .AND. C6_ENTREG <= ctod('"+dtoc(MV_PAR02)+"') "//Expressao do Filtro
	Endif
	Else     // Considera faturados
	If !_mCodusr$_mParFAT
	cFiltro := "C6_SUGENTR >= ctod('"+DTOC(MV_PAR01)+"') .AND. C6_SUGENTR <= ctod('"+dtoc(MV_PAR02)+"') "//Expressao do Filtro
	Else
	cFiltro := "C6_ENTREG >= ctod('"+DTOC(MV_PAR01)+"') .AND. C6_ENTREG <= ctod('"+dtoc(MV_PAR02)+"') "//Expressao do Filtro
	Endif

	Endif

	cFiltro += ".AND. C6_CLI >= '"+MV_PAR03+"' .AND. C6_CLI <= '"+MV_PAR05+"' "
	cFiltro += ".AND. C6_LOJA >= '"+MV_PAR04+"' .AND. C6_LOJA <= '"+MV_PAR06+"' "
	cFiltro += ".AND. C6_YOBRA >= '"+MV_PAR07+"' .AND. C6_YOBRA <= '"+MV_PAR08+"' "

	// Implementado Filtro para desconsiderar residuos - by Wlad 07/09/2013
	If MV_PAR09 == 2
	cFiltro += ".AND. trim(C6_BLQ) <> 'R' "
	Endif

	cFiltro += ".AND. C6_QTDVEN-C6_QTDENT >= 5  "

	Private bFiltraBrw := { || FilBrowse( "SC6" , @aIndex , @cFiltro ) } //Determina a Expressao do Filtro
	Eval( bFiltraBrw )    //Efetiva o Filtro antes da Chamada a mBrowse
	*/

	// Define as OpÁıes e os programas que ser„o chamados pelas mesmas
	Private aRotina := {{'PESQUISAR ','AxPesqui',0,1},;
	{'LEGENDA   ','U_Legenda()',0,5 },;
	{'Preenche Certificado ','U_mAtuCQ()',0,4},;
	{'Imprime Certificado  ','U_AAFATR18()',0,3}}

	// Define os campos do mBrowse

	//{"Produto        "  ,"substr(C6_DESCRI,1,15)" ,""}
	//{"Obra      "     	,"Substr(C6_YDESCOB,1,10)",""}

	//_mtermo := IIF(Posicione('SB1',1,xFilial('Sb1')+C6_PRODUTO,'B1_GRUPO') $ '1001,0201',  SUBSTR(Posicione('Sb1',1,xFilial('Sb1')+C6_PRODUTO,'B1_DESC'),29,15), C6_DESCRI)

	Private aCampos := {;
	{"Nota Fiscal"     	,"D2_DOC",""},;
	{"Serie"     	    ,"D2_SERIE",""},;
	{"Certificado"     	,"D2_XNOCQ",""},;
	{"Bitola Size"     	,"D2_XBITOLA",""},;
	{"Lote Corrida"     ,"D2_XLOTEC" ,""},;
	{"Quantidade KG"    ,"Transform(D2_XQTDCOR, '@E 99,999.99')" ,""},;
	{"Massa Linear"     ,"Transform(D2_XMLK    , '@E 99.999')" ,""},;
	{"LE"  	            ,"Transform(D2_XLE     , '@E 99,999.999')" ,""},;
	{"LR"  		        ,"Transform(D2_XLR     , '@E 99,999.999')" ,""},;
	{"LR/LE"   		    ,"Transform(D2_XLRLE   , '@E 99,999.999')" ,""},;
	{"Along"   		    ,"Transform(D2_XALONG  , '@E 999.999')" ,""}}
	

	//  	{"Produto        "  ,"IIF((Posicione('SB1',1,xFilial('Sb1')+C6_PRODUTO,'B1_TIPO') $ 'PA,AF') .AND. (Posicione('SB1',1,xFilial('Sb1')+C6_PRODUTO,'B1_YTCOM') <> '1') ,  SUBSTR(Posicione('Sb1',1,xFilial('Sb1')+C6_PRODUTO,'B1_DESC'),29,15), C6_DESCRI)" ,""},;

	// Define os Semaforos
	private aCores  := {;
	{"!EMPTY(D2_XNOCQ)","DISABLE"},; 	// VERMELHO - PREENCHIDO
	{"EMPTY(D2_XNOCQ)" ,"ENABLE"}}      // VERDE - NAO PREENCHIDO

	// Define as legendas
	private aLegenda:= {; 
	{'BR_VERMELHO','Preenchido'	},;
	{'BR_VERDE'   ,'N„o Preenchido'}}

	//dbselectarea('SL1')
	//dbsetfilter({||SL1->L1_EMISSAO>=MV_PAR01 .and. SL1->L1_EMISSAO<=MV_PAR02 .and. SL1->L1_FILIAL==cFilAnt},"SL1->L1_EMISSAO>=MV_PAR01 .and. SL1->L1_EMISSAO<=MV_PAR02 .and. SL1->L1_FILIAL==cFilAnt")

	// Executa filtro de acordo com os parametros informados

	mBrowse(6,1,22,75,cString,aCampos,,,,,aCores)
	//EndFilBrw( "SRA" , @aIndex ) //Finaliza o Filtro
return

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Funcao    ≥ mAtuCom  ∫ Autor ≥ Wladimir Vieira    ∫ Data ≥  17/07/13   ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
// Tela de AtualizaÁ„o pelo setor Comercial
Alteracoes:
/*/

// Rotina para UtilizaÁ„o do setor comercial - LiberaÁ„o para LogÌstica
user function mAtuCQ()

	// Posiciona SC5
	dbSelectArea("SF2")
	dbSetOrder(1)
	dbSeek(xFilial()+SD2->D2_DOC+SD2->D2_SERIE)

	dbSelectArea("SD2")

	If !empty(SD2->D2_XNOCQ)
		_mCert   := SD2->D2_XNOCQ								// No Certificado
	Else
		_mCert   := _mCalccq()
	Endif

	_mNf     := SD2->D2_DOC+"/"+SD2->D2_SERIE				// Nota Fiscal
	_mNomcli := POSICIONE("SA1",1,xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA,"A1_NOME") // Nome do cliente
	_mBitola := SD2->D2_XBITOLA								// Bitola
	_mLoteCor:= SD2->D2_XLOTEC								// Lote corrida
	_mQTDCOR := SD2->D2_XQTDCOR								// Quantidade corrida
	_mMlk    := SD2->D2_XMLK								// Massa Linear KG
	_mLE     := SD2->D2_XLE									// LE
	_mLR 	 := SD2->D2_XLR									// LR
	_mLRLE   := SD2->D2_XLRLE								// LR LE
	_mAlong  := SD2->D2_XALONG								// Along

	//Colocar ValidaÁ„o para Dados da logistica. Se preenchido nao pode mais alterar

	@ 100,075 To 370,645 Dialog oDialogo Title OemToAnsi("Dados Certificado de Qualidade NF mo.: "+SD2->D2_DOC+"/"+SD2->D2_SERIE)
	@ 010,015 Say OemToAnsi("Nota Fiscal/Serie")  		Size 045,20
	@ 010,150 Say OemToAnsi("CERTIFICADO No.")   	    Size 045,20
	@ 030,015 Say OemToAnsi("Cliente")  			    Size 045,20
	@ 050,015 Say OemToAnsi("Bitola / SIZE") 			Size 060,20
	@ 050,150 Say OemToAnsi("Lote / Corrida ")   	    Size 045,20
	@ 070,015 Say OemToAnsi("Quantidade KG  ")   	    Size 045,20
	@ 070,150 Say OemToAnsi("M. Lin KG/m ")   	    	Size 045,20
	@ 090,015 Say OemToAnsi("LE (Mpa)  ")   	    	Size 045,20
	@ 090,150 Say OemToAnsi("LR (Mpa)  ")   	    	Size 045,20
	@ 110,015 Say OemToAnsi("LR / LE  ")   	    		Size 045,20
	@ 110,150 Say OemToAnsi("Along (%) ")   	    	Size 045,20

	//@ 010,150 line 050,0200
	//@ 050,015 Say OemToAnsi("Data de envio")      	Size 045,20

	@ 010,065 SAY _mNf
	@ 010,200 SAY _mCert   
	@ 030,065 SAY _mNomcli  
	@ 050,065 GET _mBitola	PICTURE "99.99" 			Size 050,50	// Bitola
	@ 050,200 GET _mLoteCor	PICTURE "99999999999"		Size 050,50	// Lote corrida
	@ 070,065 GET _mQTDCOR 	PICTURE "@E 99,999,999.999"	Size 050,50	// Quantidade corrida
	@ 070,200 GET _mMlk     PICTURE "@E 999.999" 		Size 050,50	// Massa Linear KG
	@ 090,065 GET _mLE      PICTURE "@E 9,999.999" 		Size 050,50	// LE
	@ 090,200 GET _mLR 	    PICTURE "@E 9,999.999"		Size 050,50	// LR
	@ 110,065 GET _mLRLE    PICTURE "@E 9,99,999.999" 	Size 050,50	// LR LE
	@ 110,200 GET _mAlong   PICTURE "@E 999.999"  		Size 050,50	// Along

	//@ 050,065 Get _Data3                          	Size 050,50
	@ 120,20  BmpButton Type 01 Action _AtuPedCom()
	@ 120,90  BmpButton Type 02 Action Close(oDialogo)

	Activate Dialog oDialogo CENTERED

Return


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Funcao    ≥_atuPedcom∫ Autor ≥ Wladimir Vieira    ∫ Data ≥  17/07/13   ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
// Funcao para AtualizaÁ„o dos dados do setor comercial
// Aqui libera o Pedido para o setor de Logistica
Alteracoes:
/*/

static function _AtuPedCom()

	close(oDialogo)  // Fecha janela de digitaÁ„o do comercial

	// Atualiza SF2
	dbSelectArea('SF2')
	If RecLock("SF2",.f.)
		Replace SF2->F2_XNOCQ   WITH _mCert
		mSunlock()
	Endif

	// Retorna para SD2 e atualiza
	dbSelectArea("SD2")
	if Reclock("SD2",.f.)
	    Replace SD2->D2_XNOCQ   WITH  _mCert
		Replace SD2->D2_XBITOLA	with	_mBitola 	 
		Replace SD2->D2_XLOTEC	with	_mLoteCor	 
		Replace SD2->D2_XQTDCOR	with	_Mqtdcor	 
		Replace SD2->D2_XMLK	with	_mMlk    	 
		Replace SD2->D2_XLE		with	_mLE     	 
		Replace SD2->D2_XLR		with	_mLR 	     
		Replace SD2->D2_XLRLE	with	_mLRLE  	 
		Replace SD2->D2_XALONG	with	_mAlong 	  
		msUnlock()
	Endif


Return


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Funcao    ≥ Legenda  ∫ Autor ≥ Wladimir Vieira    ∫ Data ≥  17/07/13   ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
// Funcao para Montar Legendas coloridas
Alteracoes:
/*/

user function Legenda()

	brwlegenda('Status Pedidos de Venda','Legenda',aLegenda)
return

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Funcao    ≥ ValidaPerguntas  ∫ Autor ≥ Wladimir Vieira    ∫ Data ≥  17/07/13   ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
// Funcao para Validar SX1 - adiciona perguntas se n„o estiver cadastrada
Alteracoes:
/*/

static function ValidaPerguntas()
	private aRegs := {}
	private i,j

	dbselectarea('SX1')
	dbsetorder(1)

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aadd(aRegs,{cPerg,'01','Data inicial ?'	,'Data inicial ?','Data inicial ?','MV_CH1','D',08,00,0,'G','','MV_PAR01',"","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,'02','Data final ?'	,'Data final ?'	 ,'Data final ?'  ,'MV_CH2','D',08,00,0,'G','','MV_PAR02',"","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,'03','Do Cliente ?'	,'Do cliente ?'	 ,'Do Cliente ?'  ,'MV_CH3','C',06,00,0,'G','','MV_PAR03',"","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,'04','Da Loja    ?'	,'Ate Cliente?'	 ,'Ate Cliente?'  ,'MV_CH4','C',06,00,0,'G','','MV_PAR04',"","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,'05','Ate Cliente?'	,'Da Obra    ?'	 ,'Da Obra    ?'  ,'MV_CH5','C',02,00,0,'G','','MV_PAR05',"","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,'06','Ate Loja   ?'	,'Ate a Obra ?'	 ,'Ate a Obra ?'  ,'MV_CH6','C',02,00,0,'G','','MV_PAR06',"","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,'07','Da Obra    ?'	,'Da Obra    ?'	 ,'Da Obra    ?'  ,'MV_CH7','C',02,00,0,'G','','MV_PAR07',"","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,'08','Ate a Obra ?'	,'Ate a Obra ?'	 ,'Ate a Obra ?'  ,'MV_CH8','C',02,00,0,'G','','MV_PAR08',"","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,'09','Considera Residuos ?'	,'Considera Residuos ?'	 ,'Considera Residuos ?'  ,'MV_CH9','N',01,00,0,'C','','MV_PAR09',"Sim","Sim","Sim","","","N„o","N„o","N„o","","","","","",""})
	aadd(aRegs,{cPerg,'10','Considera Faturados?'	,'Considera Faturados?'	 ,'Considera Faturados?'  ,'MV_CHA','N',01,00,0,'C','','MV_PAR10',"Sim","Sim","Sim","","","N„o","N„o","N„o","","","","","",""})

	for i:=1 to len(aRegs)
		if !dbseek(cPerg+aRegs[i,2])
			recLock('SX1',.T.)

			for j:=1 to fcount()
				if j <= len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				endif
			next

			msunlock()
		endif
	next
return


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕ±±±±±±±±ª±±
±±∫Funcao    ≥ Gera No CQ       ∫ Autor ≥ Wladimir Vieira    ∫ Data ≥  01/04/2019 ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ

Alteracoes:
/*/

static function _mCalccq()
	cQry := " "
	cQry += "SELECT MAX(LEFT(D2_XNOCQ,6)) AS NUMCQ"
	cQry += " FROM "+RetSQLName("SD2")+" WHERE D_E_L_E_T_ = ' ' "  
	//cQry +=" AND A2_COD NOT IN ('UNIAO', 'MUNIC', 'INPS' , 'FOL001', 'ESTADO','INPS01') "
	cQry += " AND D2_XNOCQ < 'A' "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)

	//cRet := STRZERO(val(Soma1(alltrim(str(TMP->C2_NUM)))),6) //STRZERO(Alltrim(Soma1(TMP->C2_NUM)),6) //Soma1(TMP->C2_NUM)
	cRet := strzero(val(TMP->NUMCQ)+1,6) +"/" + SUBSTR(DTOS(DDATABASE),3,2)

	TMP->(dbCloseArea())

Return cRet