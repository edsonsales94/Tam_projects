#INCLUDE "PROTHEUS.CH"
#INCLUDE "LOJC030.CH"

#DEFINE P_TROCO            1         
#DEFINE P_PAGAMENTOS       2
#DEFINE P_RECEBIMENTOS     3
#DEFINE P_SANG_DINHEIRO    4
#DEFINE P_SANG_CHEQUE      5
#DEFINE P_SANG_CARTAO      6
#DEFINE P_SANG_VALE        7
#DEFINE P_SANG_CONVENIO    8
#DEFINE P_SANG_FINANCIADO  9
#DEFINE P_SANG_DEBAUTO    10
#DEFINE P_SANG_OUTROS     11
#DEFINE P_TRANSF_ORIGEM   12
#DEFINE P_TRANSF_DESTINO  13 
#DEFINE P_VEND_DINHEIRO   14
#DEFINE P_VEND_CHEQUE     15
#DEFINE P_VEND_CARTAO     16
#DEFINE P_VEND_VALE       17
#DEFINE P_VEND_CONVENIO   18
#DEFINE P_VEND_FINANCIADO 19
#DEFINE P_VEND_DEBAUTO    20
#DEFINE P_VEND_CREDITO    21
#DEFINE P_VEND_OUTROS     22
#DEFINE P_DEVOLUCAO       23
#DEFINE P_SANG_IMPOSTOS   24
#DEFINE P_VEND_ESTACIO    25
#DEFINE P_VEND_SERVICO    26
#DEFINE P_VEND_BOLETO     27
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criada mais uma posicao no Array p/ Troco de saida³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#DEFINE P_TROCO_SAIDA     28
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Aumentado o tamanho do array aCaxixa de 26 p/ 27  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#DEFINE P_MAXDEFINE       28

Static oSaldFinal
Static oTrocoSaida
Static oTotCre
Static oTotDeb
Static oTroco

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ LOJC030	³ Autor ³ Cesar Valadao         ³ Data ³ 28/01/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Resumo do Caixa                      					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ LOJC030()									              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGALOJA 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteração |          |Autora | Solange Zanardi       ³ Data ³ 15/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³BOPS      | Foram acrescentados, ào Resumo de Caixa, contadores de     ³±±
±±³67822     | documentos por forma de pgto, o qual será exibido em tela  ³±±
±±³          | e também impresso em relatório.                			  ³±±
±±³          | Esta contagem contempla somente a parte de créditos.       ³±±
±±³          | O intuito da alteração é de facilitar a conferência de     ³±±
±±³          | documentos no fechamento de caixa.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteração |          |Autor  | Andre Veiga           ³ Data ³ 02/09/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Della Via | Alteracao do resumo de caixa para considerar as NCCs que   ³±±
±±³          | foram utilizadas para baixar os titulos na rotina de       ³±±
±±³          | recebimento de titulos (LOJXREC). Somente serao considera- ³±±
±±³          | dos os titulos que forem NCC com E5_MOEDA = "CR", que e' o ³±±
±±³          | que foi gravado na compensacao pelo LOJXREC                ³±±
±±³          |                                                            ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMADOR³ BOPS ³ DATA   ³  DESCRICAO                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Adrianne F.|87206 |04/11/05|Implementação da busca pelo campo L1_EMISNF³±± 
±±³			  |      |        |ao inves de L1_EMISSAO, para que funcione  ³±± 
±±³			  |      |        |eh necessaria a criacao do seguinte indice ³±± 
±±³			  |      |        |no SL1:                                    ³±± 
±±³			  |      |        | - Ordem: A                                ³±± 
±±³			  |      |        |Chave:L1_FILIAL+L1_OPERADOR+DtoS(L1_EMISNF)³±± 
±±³Geronimo   |95262 |17/03/06|Implementada permicao para o modulo Gestao ³±± 
±±³           |      |        |Hospitalar acessar a rotina Resumo de Caixa³±± 
±±³Thiago H.  |95738 |24/03/06|Implementada a melhoria para visualizar    ³±± 
±±³           |      |        |os valores de Troco de Saida quando o      ³±± 
±±³           |      |        |parametro MV_LJTROCO esteja igual a .T. e  ³±± 
±±³           |      |        |tenha sido efetuado vendas pagas em CHEQUE ³±± 
±±³           |      |        |e com valores do CHEQUE maiores que o da   ³±± 
±±³           |      |        |venda.                                     ³±± 
±±³Norbert Jr |100116|24/05/06|Ajuste na rotina IncAvalForma, que nao con-³±±
±±³           |      |        ³siderava o tamanho aValForma. Ajuste do    ³±±
±±³           |      |        ³vetor aDDown de acordo com o aValForma.    ³±±
±±³           |      |        ³Troca de variaveis Private por Local.      ³±±
±±ºDolis      ³102631³07/08/06³Tratamento de troco para a demonstracao do º±±
±±º           ³      ³        ³relatorio                                  º±±
±±³Machima    |104993|31/08/06|O credito de venda,utilizado para compensar³±±
±±³           |      |        ³NCC e o valor da NCC gerada,nao deve somar ³±±
±±³			  |      |        |no totalizador de credito porque e um valor³±±
±±³           |      |        ³que ja havia entrado no Caixa. Este valor  ³±±
±±³           |      |        ³e gravado em L1_CREDITO e no SE1			  ³±±
±±ºDanilo Cal.³106742³26/09/06³Alterado o tamanho da coluna final de 1600 º±±
±±º           ³      ³        ³para 1750. Necessario devido a Impressoras º±±
±±º           ³      ³        ³Matriciais.                                º±±
±±³Mauro S.   ³123586³02/05/07³Alterada a validacao para a exibicao do    ³±± 
±±³           ³      ³        ³recebimento do resumo de caixa.            ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Conforme conversa com o Fernando Machima e Julio, foi retirado todo o   ³
//³ tratamento de Localizacoes, pois o LOJC031 substitui o LOJC030.         ³
//³ Cesar Valadao - 28/01/03                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function AALOJC030()

Local oDlg											// Objeto
Local oFnt											// Fonte
Local oFnt2											// Fonte 2
Local oFnt3											// Fonte 3
Local oGroup										// Grupo de impressao
Local cMV_LJTROCO   := SuperGetMv("MV_LJTROCO") 	// Determina se utiliza troco para diferentes formas de Pagamento												
Local nTrocoSaida   := 0							// Somatoria dos trocos de saida						

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Substituicao de variaveis³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³De:Variavel³Tipo    ³Programa    ³Para:Variavel³Tipo  ³Programa    ³Data      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´±±
±±³aCaixa     |Private |LOJC030.PRX |aCaixa       |Local |LOJC030.PRX |24/05/2006³±± 
±±³nTroco     |Private |LOJC030.PRX |nTroco       |Local |LOJC030.PRX |24/05/2006³±± 
±±³nTotCredito|Private |LOJC030.PRX |nTotCredito  |Local |LOJC030.PRX |24/05/2006³±± 
±±³aTotDebito |Private |LOJC030.PRX |nTotDebito   |Local |LOJC030.PRX |24/05/2006³±± 
±±³nSaldFinal |Private |LOJC030.PRX |nSaldFinal   |Local |LOJC030.PRX |24/05/2006³±± 
±±³nEstac     |Private |LOJC030.PRX |nEstac       |Local |LOJC030.PRX |24/05/2006³±± 
±±³nGorjeta   |Private |LOJC030.PRX |nGorjeta     |Local |LOJC030.PRX |24/05/2006³±± 
±±³oMovVen    |Private |LOJC030.PRX |oMovVen      |Local |LOJC030.PRX |24/05/2006³±± 
±±³oMovSan    |Private |LOJC030.PRX |oMovSan      |Local |LOJC030.PRX |24/05/2006³±± 
±±³aDadosVen  |Private |LOJC030.PRX |aDadosVen    |Local |LOJC030.PRX |24/05/2006³±± 
±±³aSinal     |Private |LOJC030.PRX |aSinal       |Local |LOJC030.PRX |24/05/2006³±± 
±±³aDDown     |Private |LOJC030.PRX |aDDown       |Local |LOJC030.PRX |24/05/2006³±± 
±±³aContFina  |Private |LOJC030.PRX |aContFina    |Local |LOJC030.PRX |24/05/2006³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Local aCaixa
Local nTroco                                 					// Valor da entrada de troco
Local nTotCredito                            					// Total de creditos
Local nTotDebito                             					// Total de debitos
Local nSaldFinal                             					// Saldo final do Caixa
Local nEstac                                 					// Valor referente ao estacionamento (restaurante)
Local nGorjeta                               					// Valor referente a gorjeta (restaurante)
Local nVlrCred  := 0                         					// Valor do credito utilizado na compensacao da NCC
Local oMovVen													// Movimento da venda
Local oMovSan													// Movimento
Local aDadosVen := {{"",0}}, aDadosSan := {{"",0}}				// Arrays - 1)Descricao 2)Valor 3)Qtde Finalizações
Local aSinal  	:= { "+", "+", "+", "+", "+", "", "+", "+" }	// Array com as sinais realizados
Local aDDown  	:= Array( 8 )  	 								// Contem o 2o. nivel das opcoes: Cartao de Credito, Vales, Convenio, Financiado, Cartao de Debito e Devolucao
Local aContFina := { 0 , 0 , 0 , 0 , ;
                     0 , 0 , 0 , 0 , ;
                     0 , 0 }         							// Contadores utilizados nos tipos de finalizações 
Local aHelpPor  := {}											// Help em Portugues
Local aHelpEng  := {}                     						// Help em Ingles
Local aHelpEsp  := {}											// Help em Espanhol
Local cPerg     := "LJC030"        								// Codigo da pergunta
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se lSomaCred igual a .T. deve somar o credito de venda no totalizador de³
//³ credito do Resumo de Caixa 												³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lSomaCred := .T.             								// Controla se considera o credito de venda, valor da NCC gerada e o utilizado na compensacao da NCC, no totalizador

/*
// Estrutura do array aContFina
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³1 - CC - CARTAO DE CREDITO   ³
//³2 - VA - VALES               ³
//³3 - CO - CONVENIO            ³
//³4 - FI - FINANCIADO          ³
//³5 - CD - CARTAO DE DEBITO    ³
//³6 - CH - CHEQUE              ³
//³7 - OU - OUTROS              ³
//³8 - RC - RECEBIMENTO         ³
//³9 - RC - RECEB. DIVERSOS     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

If ExistBlock("LJ030DEV")
	aSinal  := { "+", "+", "+", "+", "+", "+", "+", "+"}
EndIf

// Protege rotina para que seja usada apenas no SIGALOJA / Front Loja
If !AmIIn(12,23,51)
	Return(NIL)
EndIf

AAdd(aHelpPor,"Define se considera o credito de venda ")
AAdd(aHelpPor,"no totalizador do Resumo de Caixa.")

AAdd(aHelpEng,"Define se considera o credito de venda ")
AAdd(aHelpEng,"no totalizador do Resumo de Caixa.")

AAdd(aHelpEsp,"Define se considera o credito de venda ")
AAdd(aHelpEsp,"no totalizador do Resumo de Caixa.")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pergunta que define se o valor referente ao credito utilizado na venda deve ser considerado no totalizador do ³
//³ Resumo de Caixa                                                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutSx1( cPerg      , "08"    , "Cons. cred. venda no total?" , "¿Cons. cred. venta en el total?", "Consider sale credit in total?" , ;
        "mv_ch8"   , "N"     , 1                             , 0                                , 1                                , ;
        "C"        , ""      , ""                            , ""                               , ""                               , ;
        "mv_par08" , "Sim"   , "Si"                          , "Yes"                            , ""                               , ;
        "Nao"      , "No"    , "No"                          , ""                               , ""                               , ;
        ""         , ""      , ""                            , ""                               , ""                               , ;
        ""         , ""      , aHelpPor                      , aHelpEng                         , aHelpEsp                         , ;
        ""         )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as perguntas selecionadas                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - De Data            ?                              ³
//³ mv_par02 - Ate Data           ?                              ³
//³ mv_par03 - De Caixa           ?                              ³
//³ mv_par04 - Ate Caixa          ?                              ³
//³ mv_par05 - De Filial          ?                              ³
//³ mv_par06 - Ate Filial         ?                              ³
//³ mv_par07 - Gerar em Crystal Report?                          ³
//³ mv_par08 - Cons. cred. venda no total?                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Pergunte(cPerg,.T.)
	Return(NIL)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|	A mensagem abaixo so sera apresentada caso o sistema nao	|
//|	esteja utilizando o troco para qualquer numerario           |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SuperGetMV( "MV_LJREST", ,.F. ) .OR. cMV_LJTROCO
	nWidth 	:= 690
	nHeight := 480
Else
	nWidth 	:= 690
	nHeight := 425
EndIf

lSomaCred  := (mv_par08 == 1)

nReg := SM0->(Recno())
nInd := SM0->(IndexOrd())

SM0->(dbSetOrder(1))
SM0->(dbSeek(SM0->M0_CODIGO+MV_PAR05))

// Resumo de Caixa
DEFINE MSDIALOG oDlg FROM 0.1,0.1 TO nHeight, nWidth TITLE Trim(STR0001)+" - "+Trim(SM0->M0_NOME)+" - "+Trim(SM0->M0_FILIAL) PIXEL OF oMainWnd  

SM0->(dbSetOrder(nInd))
SM0->(dbGoTo(nReg))

// Largura x Altura
DEFINE FONT oFnt	NAME "TIMES NEW ROMAN" SIZE 9,13 BOLD  
DEFINE FONT oFnt2	NAME "Arial" BOLD
DEFINE FONT oFnt3	NAME "Courier New" 
	
@ 001 , 004 TO 037, 290 LABEL "" OF oDlg  PIXEL

@ 005, 007 SAY STR0052  SIZE 60,10 OF oDlg PIXEL		// "De Data   :"
@ 005, 070 SAY MV_PAR01 SIZE 42,10 OF oDlg PIXEL RIGHT
@ 015, 007 SAY STR0053  SIZE 60,10 OF oDlg PIXEL		// "De Caixa  :"
@ 015, 070 SAY MV_PAR03 SIZE 42,10 OF oDlg PIXEL RIGHT
@ 025, 007 SAY STR0054  SIZE 60,10 OF oDlg PIXEL		// "De Filial :"
@ 025, 070 SAY MV_PAR05 SIZE 42,10 OF oDlg PIXEL RIGHT
@ 005, 170 SAY STR0055  SIZE 60,10 OF oDlg PIXEL		// "Ate Data   :"
@ 005, 240 SAY MV_PAR02 SIZE 42,10 OF oDlg PIXEL RIGHT
@ 015, 170 SAY STR0056  SIZE 60,10 OF oDlg PIXEL		// "Ate Caixa  :"
@ 015, 240 SAY MV_PAR04 SIZE 42,10 OF oDlg PIXEL RIGHT
@ 025, 170 SAY STR0057  SIZE 60,10 OF oDlg PIXEL		// "Ate Filial :"
@ 025, 240 SAY MV_PAR06 SIZE 42,10 OF oDlg PIXEL RIGHT
	                                                             
// Creditos (Vendas)
@ 040, 004 GROUP oGroup TO 183, 172 LABEL  STR0002  OF oDlg PIXEL 
oGroup:SetFont(oFnt2)

@ 046, 009 LISTBOX oMovVen FIELDS HEADER STR0060 SIZE 157, 108 ; //"Finalizadora - Vlr.Total - Qtd.Documentos"
    ON DBLCLICK	LJ030DDown(	oMovVen:nAt		, 1				, @nTrocoSaida	, @nTroco		,;
    						@nTotCredito	, @nTotDebito	, @nSaldFinal	, @nEstac  		,;
    						@nGorjeta		, @oMovVen		, @oMovSan		, @aDadosVen	,;
    						@aSinal			, @aDDown		, @aContFina	, @aCaixa		,;
    						@aDadosSan		, @nVlrCred     );
    OF oDlg PIXEL FONT oFnt3
     
// D‚bitos (Sangrias)
@ 040, 176 GROUP oGroup TO 183, 343 LABEL  STR0003  OF oDlg PIXEL 
oGroup:SetFont(oFnt2)

@ 046, 181 LISTBOX oMovSan FIELDS HEADER STR0061 SIZE 157, 108 ; //"Finalizadora - Vlr.Total"
    ON DBLCLICK	LJ030DDown(	oMovSan:nAt		, 2				, @nTrocoSaida	, @nTroco		,;
    						@nTotCredito	, @nTotDebito	, @nSaldFinal 	, @nEstac		,;
    						@nGorjeta		, @oMovVen		, @oMovSan		, @aDadosVen	,;
    						@aSinal			, @aDDown		, @aContFina	, @aCaixa		,;
    						@aDadosSan		, @nVlrCred     );
    OF oDlg PIXEL FONT oFnt3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seta Vetores de Dados de Credito / Debito para ListBox     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oMovVen:SetArray(aDadosVen)
oMovSan:SetArray(aDadosSan)
oMovVen:bLine := {|| {	aDadosVen[oMovVen:nAt][1] } }
oMovSan:bLine := {|| {	aDadosSan[oMovSan:nAt][1] } }

// Total de Cr‚ditos
@ 158, 004 GROUP oGroup TO 183, 172 LABEL STR0014 OF oDlg PIXEL  
oGroup:SetFont(oFnt2)

@ 169, 102 SAY oTotCre PROMPT nTotCredito SIZE 64, 10 OF oDlg;
	PIXEL RIGHT FONT oFnt COLOR CLR_HRED PICTURE "@E 999,999,999.99"

// Total de D‚bitos
@ 158, 176 GROUP oGroup TO 183, 343 LABEL STR0017 OF oDlg PIXEL
oGroup:SetFont(oFnt2)

@ 169, 273 SAY oTotDeb PROMPT nTotDebito SIZE 64, 10 OF oDlg;
	PIXEL RIGHT FONT oFnt COLOR CLR_HRED PICTURE "@E 999,999,999.99"

// Saldo Inicial
@ 185, 004 GROUP oGroup TO 210, 172 LABEL STR0005 OF oDlg PIXEL  
oGroup:SetFont(oFnt2)

@ 195, 102 SAY oTroco VAR nTroco SIZE 64, 10 OF oDlg PIXEL RIGHT FONT oFnt;
	COLOR CLR_HRED PICTURE "@E 999,999,999.99"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso o parametro MV_LJTROCO esteja como TRUE, mostra na tela os Trocos de Saida³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cMV_LJTROCO
	// Troco Saida
	@ 185, 176 GROUP oGroup TO 210, 343 LABEL STR0069 OF oDlg PIXEL //Troco Saida
	oGroup:SetFont(oFnt2)
	
	@ 195, 273 SAY oTrocoSaida PROMPT nTrocoSaida SIZE 64, 12 OF oDlg;
	PIXEL RIGHT FONT oFnt COLOR CLR_HRED PICTURE "@E 999,999,999.99"

	// Saldo Final
	@ 212, 176 GROUP oGroup TO 237, 343 LABEL STR0018 OF oDlg PIXEL
	oGroup:SetFont(oFnt2)
	
	@ 221, 273 SAY oSaldFinal PROMPT nSaldFinal SIZE 64, 12 OF oDlg;
	PIXEL RIGHT FONT oFnt COLOR CLR_HRED PICTURE "@E 999,999,999.99"    
Else
	// Saldo Final
	@ 185, 176 GROUP oGroup TO 210, 343 LABEL STR0018 OF oDlg PIXEL
	oGroup:SetFont(oFnt2)
	
	@ 195, 273 SAY oSaldFinal PROMPT nSaldFinal SIZE 64, 12 OF oDlg;
	PIXEL RIGHT FONT oFnt COLOR CLR_HRED PICTURE "@E 999,999,999.99"
Endif

If SuperGetMV( "MV_LJREST", , .F. )
	// Estacionamento
	@ 212, 004 GROUP oGroup TO 237, 172 LABEL STR0063 OF oDlg PIXEL //"Estacionamento"
	oGroup:SetFont( oFnt2 )
	
	@ 222, 102 SAY oEstac VAR nEstac SIZE 64, 10 OF oDlg PIXEL RIGHT FONT oFnt;
		COLOR CLR_HRED PICTURE "@E 999,999,999.99"
	
	// Gorjeta
	@ 212, 176 GROUP oGroup TO 237, 343 LABEL STR0064 OF oDlg PIXEL //"Gorjeta"
	oGroup:SetFont( oFnt2 )
	
	@ 222, 273 SAY oGorjeta VAR nGorjeta SIZE 64, 12 OF oDlg PIXEL RIGHT FONT oFnt ;
		COLOR CLR_HRED PICTURE "@E 999,999,999.99"
EndIf

@ 0.0, 73 BUTTON STR0019 SIZE 50,11 FONT oDlg:oFont ;
		  ACTION Lj030Imp(	cMV_LJTROCO	,nTrocoSaida	, aCaixa		,nTroco		,;
							nTotCredito	,nTotDebito		, nSaldFinal 	,aDadosVen	,;
							aDadosSan	) OF oDlg 	// Imprimir
		  
@ 1.2, 73 BUTTON STR0046 SIZE 50,11 FONT oDlg:oFont ;
          ACTION ExecBlock("LJ030ECF") WHEN (lFiscal.AND.ExistBlock("LJ030ECF")) OF oDlg 	// Imprimir ECF

@ 2.5, 73 BUTTON STR0020 SIZE 50,11 FONT oDlg:oFont ACTION oDlg:End() OF oDlg CANCEL		// Sair
	
// "Aguarde... Montando o Resumo de Caixa"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis 'oTrocoSaida' e 'nTrocoSaida' passadas como referencia, pois, serao alteradas no decorrer do programa.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ACTIVATE MSDIALOG oDlg ON INIT LJMsgRun(STR0058,,;
	{||LJ030Refresh( Nil		, @oTrocoSaida	, @nTrocoSaida	, cMV_LJTROCO	,;
					 @aCaixa	, @nTroco		, @nTotCredito	, @nTotDebito	,;
					 @nSaldFinal, @nEstac 		, @nGorjeta		, @oMovVen		,;
					 @oMovSan	, @aDadosVen	, @aSinal		, @aDDown		,;
					 @aContFina	, @aDadosSan    , @nVlrCred     , lSomaCred     )})

DbSelectArea("SL1")
dbSetOrder(1)

Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ LJ030Imp ³ Autor ³ Gustavo Henrique      ³ Data ³ 26/06/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao do Fechamento do Caixa        					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ LJ030Imp()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGALOJA 									              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LJ030Imp(	cMV_LJTROCO	,nTrocoSaida	,aCaixa			,nTroco		,;
					nTotCredito	,nTotDebito		,nSaldFinal		,aDadosVen	,;
					aDadosSan )
Local nColFim, nColIni, nLin, nI
Local lAberto
Local cPicture
Local oPrint, oFont

oFont  := TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)

oPrint := TMSPrinter():New( STR0023 )

If ! oPrint:IsPrinterActive()
	oPrint:Setup()	// Escolhe a impressora
Endif

If ! oPrint:IsPrinterActive()
	// "Resumo de Caixa" , "Não foi possível imprimir o Resumo de Caixa, pois não há nenhuma impressora conectada."
	Aviso(STR0001, STR0059, {"Ok"})
	Return(NIL)
EndIf
oPrint:SetPortrait()

nColIni  := 50		// Coluna inicial                      
nColFim  := 1750	// Coluna final
nSalto   := 40		// Salto de uma linha a outra

cPicture := PesqPict("SL1","L1_VLRTOT",18)

// Inicia a impressao da pagina
oPrint:StartPage()

nReg := SM0->(Recno())
nInd := SM0->(IndexOrd())

SM0->(dbSetOrder(1))
SM0->(dbSeek(SM0->M0_CODIGO+MV_PAR05))

// Imprime o cabecalho
oPrint:Say( 110, 100, PadC( Upper(STR0023)+" - "+Trim(SM0->M0_NOME)+" - "+Trim(SM0->M0_FILIAL), 65 ), oFont )

SM0->(dbSetOrder(nInd))
SM0->(dbGoTo(nReg))

oPrint:Line( 150, nColIni, 150, nColFim )

oPrint:Say( 170, 100, STR0052 + PadR(DToC(MV_PAR01),20) + " "  + STR0055 + DToC(MV_PAR02))		// "De Data   : " ### "Ate Data   : "
oPrint:Say( 210, 100, STR0053 + PadR(MV_PAR03,20) +       " "  + STR0056 + MV_PAR04)				// "De Caixa  : " ### "Ate Caixa  : "
oPrint:Say( 250, 100, STR0054 + PadR(MV_PAR05,20) +       " "  + STR0057 + MV_PAR06)				// "De Filial : " ### "Ate Filial : "

oPrint:Line( 300, nColIni, 300, nColFim )
oPrint:Say( 320, 100, STR0030 + Transform( nTroco, cPicture ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime Valores do Troco Saida           ³
//³Verifica se o parametro cMV_LJTROCO = .T.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cMv_LJTROCO
	oPrint:Line( 300, nColIni, 300, nColFim )
	oPrint:Say( 360, 100, STR0070 + Transform( nTrocoSaida , cPicture ) ) //"Troco Saída   .................................."	
Endif              

// Imprime os dados de venda
oPrint:Line( 400, nColIni, 400, nColFim )
oPrint:Say( 420, 100, STR0031 + Transform( nTotCredito, cPicture ) )

nLin := 470

For nI :=1 to len(aDadosVen)
	lAberto := (Left(aDadosVen[nI][1],1)=="-" .AND. aDadosVen[nI][2] <> 0)
	oPrint:Say( nLin, 100, padr(Left(aDadosVen[nI][1],23)+" "+;
		SubStr(aDadosVen[nI][1],Len(aDadosVen[nI][1])-5,6)+" ",48,;
		IIf(lAberto,"",".")) + IIf(lAberto, "", Transform(aDadosVen[nI][2], cPicture)))
	nLin += nSalto
Next nI      

// Imprime os dados de Sangria
nLin += nSalto
oPrint:Line( nLin, nColIni, nLin, nColFim )
nLin += nSalto
oPrint:Say( nLin, 100, STR0033 + Transform( nTotDebito, cPicture ) )
nLin += (nSalto + 10)

For nI :=1 to len(aDadosSan)
	oPrint:Say( nLin, 100, padr(Left(aDadosSan[nI][1],23)+" "+;
	Space(06)+" ",48,".")+Transform(aDadosSan[nI][2], cPicture))
	nLin += nSalto
Next nI

//Estacionamento e Gorjeta
If SuperGetMV( "MV_LJREST", , .F. )
	nLin += nSalto
	oPrint:Line( nLin, nColIni, nLin, nColFim )
	nLin += nSalto
	oPrint:Say( nLin, 100, STR0065 + Transform( aCaixa[P_VEND_ESTACIO], cPicture ) ) //"Estacionamento ................................."
	nLin += (nSalto + 10)
	oPrint:Say( nLin, 100, STR0066 + Transform( aCaixa[P_VEND_SERVICO], cPicture ) ) //"Gorjeta ........................................"
	nLin += (nSalto + 10)
EndIf

nLin += nSalto
oPrint:Line( nLin, nColIni, nLin, nColFim )
nLin += nSalto
oPrint:Say( nLin, 100, STR0034 + Transform( nSaldFinal, cPicture ) )
nLin += (nSalto + 10)

// Monta a borda de fora pois neste momento sabemos qual a linha final
oPrint:Line( 100, nColIni, 100, nColFim )
oPrint:Line( nLin, nColIni, nLin, nColFim )
oPrint:Line( 100, nColIni, nLin, nColIni )
oPrint:Line( 100, nColFim, nLin, nColFim )

oPrint:EndPage()

oPrint:Preview()

Return(NIL)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao	 ³MovimCaixa³ Autor ³ Cesar Valadao         ³ Data ³ 28/01/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³Carrega array com valores totais do caixa em uma data       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³MovimCaixa(ExpC1,ExpD1,ExpC2,ExpA1,ExpA2)                   ³±±
±±³          ³Caixa,Data Desejada,Opcao de troco,Drill Down e Cont.Financ.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGALOJA                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data   | BOPS  ³Manutencao Efetuada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luiz Couto³22/02/05³       ³Adicionado controle para os pagamentos para³±±
±±³          ³        ³       ³somente aceitar os docs VL caso a moeda nao³±±     
±±³          ³        ³       ³seja do tipo TC.                           ³±±
±±³Cleber M. ³02/06/05³82556  ³Tratamento na exibicao do valor recebido em³±±
±±³          ³        ³       ³dinheiro, verificando antes se houve troco ³±±
±±³Marcos R. ³07/07/05³83694  ³Adicionado visualizacao de vendas e NCC no ³±±
±±³          ³        ³       ³no total de Credito Cliente.         	  ³±±
±±³Andrea F. ³27/07/05³84193  ³Compatibilizacao do array aDDown com o     ³±±
±±³          ³        ³       ³array aValForma.                      	  ³±±
±±³Adrianne F³18/08/05³85231  ³Implementação do array aDDown[8] - detalhes³±±
±±³          ³        ³       ³do Drill Down do Recebimento.			  ³±±
±±³Marcos R. ³02/09/05³85345  ³Considerar na devolucao o ICMS Solidario.  ³±±
±±³Marcos R. ³12/09/05³DELLA  ³Alterado a função MovimCaixa para somente  ³±± 
±±³          ³        ³VIA    ³considerar as movimentacoes do SL4 onde o  ³±±
±±³          ³        ³       ³campo L4_ORIGEM = Empty                    ³±± 
±±³Hanna C   ³23/01/06³091495 ³Ao somar os recebimentos quando o TIPODOC  ³±±
±±³          ³        ³       ³for "VL",nao considerar o E5_TIPO"CC|R$|CH"³±±
±±³Marcos R. ³08/02/06³117893 ³Correcao do Error.Log no fechamento do     ³±± 
±±³          ³        ³       ³caixa quando havia recebimento de Titulos  ³±±
±±³          ³        ³       ³do tipo FI usando vale Compra              ³±±   
±±³Mauro S.  ³02/05/07³123586 ³Alterada a validacao para a exibicao do    ³±± 
±±³          ³        ³       ³recebimento do resumo de caixa.            ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MovimCaixa( cCaixa		, dDataMovto	, cMV_LJTROCO	, aDDown	,;
					 aContFina  , nVlrCred      , lSomaCred     )

Local nPos  		:= 0						// Posicao no array
Local bTab			:= 0						// Codeblock para alinhar os valores a direita
Local nI, nJ  		:= 0						// Variavel para auxiliar o FOR
Local aCaixa    	:= Array( P_MAXDEFINE )		// Array com os valores do caixa
Local aValForma 	:= {}						// Array que armazena os subitens dos itens do ListBox de Vendas
Local nSe5Valor 	:= 0						// Variavel que soma com o E5_VALOR
Local nForma		:= 0						// Numero da forma de pagamento: 1) Cartao de Credito, 2) Vales, 3) Convenio
												// 4) Financiado, 5) Cartao de Debito. Varia de acordo com o L4_FORMA
Local cDeFilSE5	    := ""						// Armazena a "filial De" que sera considerada no filtro do SE5
Local cAteFilSE5	:= ""						// Armazena a "filial Ate" que sera considerada no filtro do SE5
Local cDeFilSL1   	:= ""						// Armazena a "filial De" que sera considerada no filtro do SL1
Local cAteFilSL1 	:= ""						// Armazena a "filial Ate" que sera considerada no filtro do SL1
Local cDeFilSE1  	:= ""						// Armazena a "filial De" que sera considerada no filtro do SE1
Local cAteFilSE1   	:= ""						// Armazena a "filial Ate" que sera considerada no filtro do SE1
Local cDeFilSD1    	:= ""						// Armazena a "filial De" que sera considerada no filtro do SD1
Local cAteFilSD1    := ""						// Armazena a "filial Ate" que sera considerada no filtro do SD1
Local lUsaParam  	:= Empty(cCaixa)			// Valida se a variavel veio preenchida
Local aDev										// Array contendo as devolucoes
Local lLj030Dev  	:= ExistBlock("LJ030DEV")	// Variavel que verifica se existe ponto de entrada
Local lLJ030TES  	:= ExistBlock("LJ030TES")	// Variavel que verifica se existe ponto de entrada
Local lNivel     	:= .F.						// Verifica se explode nivel
Local aRet		 	:= {} 						// Recebe o retorno do ponto de entrada "LJ030TES"
Local aAux		 	:= {} 						// Array auxiliar com os valores por cada tipo de pagamento
Local cAlias     	:= Alias()					// Variavel que guarda o alias que esta aberto
Local nValPgtos  	:= 0						// Soma os pagamentos que existiram no caixa
Local lpTPAbISS  	:= ( SuperGetMV("MV_TPABISS", ,"1") == "2" )	// Verifica se existe desconto na duplicata quando cliente recolhe ISS
Local nParcelas  	:= 0						// Variavel com a quantidade de parcelas
Local nRestDiv   	:= 0						// Variavel com a somatoria do resto da divisao
Local nDinheiro  	:= 0						// Valor recebido em dinheiro   
Local aAuxRecebs    := {}						// Array auxiliar com o numero e parcela do SE5
Local nVezes 		:= 0						// Variavel com a quantidade de vezes
Local nIndice   	:= 5						// Define qual indice sera utilizado
Local nVlrTroco     := 0						// Define os valores dos Trocos a serem mostrados na tela de Resumo de Caixa

#IFDEF TOP
	Local cQuery								// Variavel que ira armazenar a query
#ELSE
	Local cNumero    := ""						// Numero do titulo
#ENDIF

DEFAULT aDDown      := Array(8)
DEFAULT nVlrCred    := 0
DEFAULT lSomaCred   := .T.

If Type("aContFina") <> "A"
	aContFina:= {0,0,0,0,0,0,0,0,0,0} 	// Contadores utilizados nos tipos de finalizacoes 
Endif

If lUsaParam
	cDeFilSE5  := If(Empty(xFilial("SE5")), "  ", MV_PAR05)	// Calcula a "De Filial" do SE5
	cAteFilSE5 := If(Empty(xFilial("SE5")), "  ", MV_PAR06)	// Calcula a "Ate Filial" do SE5
	cDeFilSL1  := If(Empty(xFilial("SL1")), "  ", MV_PAR05)	// Calcula a "De Filial" do SL1
	cAteFilSL1 := If(Empty(xFilial("SL1")), "  ", MV_PAR06)	// Calcula a "Ate Filial" do SL1
	cDeFilSE1  := If(Empty(xFilial("SE1")), "  ", MV_PAR05)	// Calcula a "De Filial" do SE1
	cAteFilSE1 := If(Empty(xFilial("SE1")), "  ", MV_PAR06)	// Calcula a "Ate Filial" do SE1
	cDeFilSD1  := If(Empty(xFilial("SD1")), "  ", MV_PAR05)	// Calcula a "De Filial" do SD1
	cAteFilSD1 := If(Empty(xFilial("SD1")), "  ", MV_PAR06)	// Calcula a "Ate Filial" do SD1
Else
	cDeFilSE5  := xFilial("SE5")
	cAteFilSE5 := xFilial("SE5")
	cDeFilSL1  := xFilial("SL1")
	cAteFilSL1 := xFilial("SL1")
	cDeFilSE1  := xFilial("SE1")
	cAteFilSE1 := xFilial("SE1")
	cDeFilSD1  := xFilial("SD1")
	cAteFilSD1 := xFilial("SD1")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Espacos para alinhar o valor a direita.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
bTab := { |x| Space( 21 - Len(x) ) }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa vetor que armazena os subitens dos itens do ListBox de Vendas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aDDown) > 0
	aValForma	:= Array( Len(aDDown) )
Else
	aValForma	:= Array(8)
Endif
		
For nI := 1 to Len( aDDown )
	aDDown[nI]    := {}
	aValForma[nI] := {}
Next nI	

For nI := 1 to Len( aCaixa )
	aCaixa[nI] := 0
Next nI
                 
If dDataMovto=Nil
	dDataMovto := dDataBase
Endif

cCaixa := SubStr( cCaixa, 1, 3 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Leitura do SE5 para considerar: Sangria, Troco e Movimenta-³
//³ ‡”es banc rias.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	cQuery := "SELECT SE5.E5_DATA , SE5.E5_VALOR  , SE5.E5_BANCO , SE5.E5_AGENCIA,"
	cQuery +=        "SE5.E5_CONTA, SE5.E5_PREFIXO, SE5.E5_NUMERO, SE5.E5_PARCELA,"
	cQuery +=        "SE5.E5_TIPO , SE5.E5_TIPODOC, SE5.E5_CLIFOR, SE5.E5_LOJA   ,"
	cQuery +=        "SE5.E5_SEQ  , SE5.E5_VENCTO , SE5.E5_MOEDA , SE5.E5_RECPAG"
	cQuery += " FROM " + RetSQLName("SE5") + " SE5"
	If lUsaParam
		cQuery += " WHERE SE5.E5_FILIAL BETWEEN '" + cDeFilSE5 + "' AND '" + cAteFilSE5 + "'"
		cQuery += " AND SE5.E5_DATA BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "'"
		cQuery += " AND SE5.E5_BANCO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"
	Else
		cQuery += " WHERE SE5.E5_FILIAL = '" + xFilial("SE5") + "'"
		cQuery += " AND SE5.E5_DATA = '" + DToS(dDataMovto) + "'"
		cQuery += " AND SE5.E5_BANCO = '" + cCaixa + "'"
	EndIf
	cQuery += " AND (SE5.E5_SITUACA <> 'C') AND (SE5.E5_MOEDA <> 'ES')"
	cQuery += " AND SE5.E5_TIPODOC <> 'LJ'"
	cQuery += " AND SE5.D_E_L_E_T_ = ' '"
	cQuery := ChangeQuery(cQuery)

	dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'SE5TMP', .F., .T.)
	TCSetField("SE5TMP", "E5_DATA", "D")
	TCSetField("SE5TMP", "E5_VENCTO", "D")

	While !EOF()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se tem cancelamento para este titulo.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If TemBxCanc( E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_CLIFOR + E5_LOJA + E5_SEQ )
			dbSkip()
			Loop
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera os titulos em NCC que foram utilizados para baixar titulos ³
		//³ na rotina de recebimento de titulos (LOJXREC), verificando se a      ³
		//³ moeda de baixa eh igual a "CR"                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If !( AllTrim( E5_TIPO ) == "NCC" .AND. AllTrim( E5_MOEDA ) == "CR" )
			If ( AllTrim( E5_TIPO ) $ ( MV_CRNEG + "/PA" ) ) .OR.  E5_VENCTO > E5_DATA
				dbSkip()
				Loop
			EndIf
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valores de Baixas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If E5_TIPODOC $ "DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL"
			dbSkip()
			Loop
		EndIf

		nSe5Valor := E5_VALOR
		
		If E5_TIPODOC == "TR"		.AND.	E5_MOEDA == "TC"	.AND.	E5_RECPAG == "R"	// => Saldo inicial
			aCaixa[P_TROCO]	+=	nSe5Valor

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pagamento -> Tipo de doc VL com moeda diferente de TC e recebimentos de titulos com NCC³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf ( E5_TIPODOC == "VL"	.AND.	E5_MOEDA <> "TC" )			.OR. 	Empty( E5_TIPODOC )	.OR. ;
				 E5_TIPODOC == "BL" .OR.  ( Alltrim(E5_TIPO) = "NCC"	.AND.	Alltrim(E5_MOEDA) = "CR" )
			If E5_RECPAG == "P"
				aCaixa[P_PAGAMENTOS] 	+= nSe5Valor

			ElseIf E5_RECPAG=="R"	.AND.	!( Alltrim( SE5->E5_TIPO )$"CH/R$/CC" )
				aCaixa[P_RECEBIMENTOS] 	+= nSe5Valor
				If aScan(aAuxRecebs, {|x| x == E5_NUMERO + E5_PARCELA}) == 0
					AAdd(aAuxRecebs, E5_NUMERO + E5_PARCELA)				
					aContFina[9]		+= 1
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Distribui os recebimentos por forma de pagamento, para fazer o DDown na tela. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If AllTrim( E5_MOEDA ) <> ""    
					nPgtoAux := AllTrim(Tabela("06",E5_MOEDA,.F.))
					nPos := aScan( aDDown[8], { |x| x[3] == E5_MOEDA } )
					If nPos <> 0
						aDDown[8][nPos][2] += E5_VALOR
						nVezes := Val( SubStr( aDDown[8][nPos][1], Len(aDDown[8][nPos][1] ), 1 ) ) + 1
						aDDown[8][nPos][1] := "  " + nPgtoAux + Space( 21 - Len( nPgtoAux ) ) + Transform(aDDown[8][nPos][2], "@E 9,999,999.99") + Space(5) + AllTrim( Str( nVezes ) )
					Else
						aAdd(aDDown[8],{"  " + nPgtoAux+ Space( 21 - Len( nPgtoAux ) ) + Transform( E5_VALOR, "@E 9,999,999.99" )+ Space(5) + "1", E5_VALOR, E5_MOEDA} )
					EndIf           

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Caso o pagamento tenha sido feito antes dessa melhoria e não tenha³
				//³forma de pagamento no SE5 sera incluido como "OUTROS"             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Else 
					nPgtoAux := "OUTROS"
					nPos := aScan( aDDown[8], { |x| x[3] == "OU" } )
					If nPos <> 0
						aDDown[8][nPos][2] += E5_VALOR
						nVezes := Val( SubStr( aDDown[8][nPos][1], Len(aDDown[8][nPos][1]), 1 ) ) + 1
						aDDown[8][nPos][1] := "  " + nPgtoAux + Space( 21 - Len( nPgtoAux ) ) + Transform(aDDown[8][nPos][2], "@E 9,999,999.99" ) + Space(5) + AllTrim( Str( nVezes ) )
					Else
						aAdd(aDDown[8],{"  " + nPgtoAux+ Space(21-Len(nPgtoAux))+Transform( E5_VALOR, "@E 9,999,999.99" )+ Space(5) +"1",E5_VALOR,"OU"})
					EndIf           
				EndIf								
			Endif

		ElseIf E5_TIPODOC $ "SG/TR/TE" .AND. E5_RECPAG == "P"
			If E5_MOEDA == SuperGetMv("MV_SIMB1")
				aCaixa[P_SANG_DINHEIRO]		+=	nSe5Valor
			ElseIf E5_MOEDA $ "C1,C2,C3,C4,C5,CH"
				aCaixa[P_SANG_CHEQUE]		+=	nSe5Valor
			ElseIf E5_MOEDA == "CC"
				aCaixa[P_SANG_CARTAO]		+=	nSe5Valor			
			ElseIf E5_MOEDA == "VL"
				aCaixa[P_SANG_VALE]			+=	nSe5Valor
			ElseIf E5_MOEDA == "CO"
				aCaixa[P_SANG_CONVENIO]		+=	nSe5Valor
			ElseIf E5_MOEDA == "FI"
				aCaixa[P_SANG_FINANCIADO]	+=	nSe5Valor
			ElseIf E5_MOEDA == "CD"
				aCaixa[P_SANG_DEBAUTO]		+=	nSe5Valor
			Else
				aCaixa[P_SANG_OUTROS]		+=	nSe5Valor
			Endif

		ElseIf E5_TIPODOC $ "TR/TE"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³O troco entrou como saldo inicial³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If E5_RECPAG == "R"	.AND.	E5_MOEDA <> "TC"
				aCaixa[P_TRANSF_DESTINO] += nSe5Valor
			Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Carrega o valor do Troco Final                                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Elseif (E5_TIPODOC == "VL" .AND. E5_MOEDA == "TC" .AND. E5_RECPAG == "P" .AND. cMV_LJTROCO )
			aCaixa[P_TROCO_SAIDA]	+=	nSe5Valor
		EndIf
		dbSkip()

	End
	DbSelectArea("SE5TMP")
	dbCloseArea()

#ELSE
	DbSelectArea( "SE5" )
	dbSetOrder( 1 )

	If lUsaParam
		DbSeek(cDeFilSE5 + DToS( MV_PAR01 ), .T. )			// Filial + Data
	Else
		DbSeek(xFilial() + DToS( dDataMovto ) + cCaixa )	// Filial + Data + Caixa
	EndIf

	While !EOF() .AND. ;
		E5_FILIAL >= cDeFilSE5	.AND.;
		E5_FILIAL <= cAteFilSE5	.AND.;
		If( lUsaParam, .T., DToS( E5_DATA ) + E5_BANCO == DToS( dDataMovto ) + cCaixa )

		If lUsaParam .AND. !(E5_DATA >= MV_PAR01 .AND.;
			 E5_DATA   <= MV_PAR02 .AND.;
			 E5_BANCO  >= MV_PAR03 .AND.;
			 E5_BANCO  <= MV_PAR04)
			dbSkip()
			Loop
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Estorno ou cancelado³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF E5_SITUACA == "C" .OR.  E5_MOEDA == "ES"
			dbSkip()
			Loop
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se tem cancelamento para este titulo.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If TemBxCanc( E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_CLIFOR + E5_LOJA + E5_SEQ )
			dbSkip()
			Loop
		EndIf  

		If ( AllTrim( E5_TIPO ) $ ( MV_CRNEG + "/PA" ) ) .OR.  E5_VENCTO > E5_DATA
			dbSkip()
			Loop
		Endif	

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Vendas a Vista, est  contido em L1_DINHEIRO³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If E5_TIPODOC == "LJ"
			dbSkip()
			Loop
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valores de Baixas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF E5_TIPODOC $ "DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL"
			dbSkip()
			Loop
		Endif

		nSe5Valor := E5_VALOR

		If E5_TIPODOC == "TR"	.AND.	SE5->E5_MOEDA == "TC"	.AND.	SE5->E5_RECPAG == "R"	// => Saldo inicial
			aCaixa[P_TROCO]	+= nSe5Valor

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pagamento -> Tipo de doc VL com moeda diferente de TC³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf ( E5_TIPODOC == "VL" .AND. E5_MOEDA <> "TC" )	.OR.  	Empty( SE5->E5_TIPODOC ) .OR.  E5_TIPODOC == "BL"
			If E5_RECPAG == "P"
				aCaixa[P_PAGAMENTOS] 	+= nSe5Valor

			ElseIf E5_RECPAG == "R"
				aCaixa[P_RECEBIMENTOS] 	+= nSe5Valor    

				If aScan(aAuxRecebs, {|x| x == E5_NUMERO + E5_PARCELA}) == 0
					AAdd(aAuxRecebs, E5_NUMERO + E5_PARCELA)				
					aContFina[9] += 1
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Distribui os recebimentos por forma de pagamento, para fazer o DDown na tela. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If AllTrim( E5_MOEDA ) <> ""    
					nPgtoAux := AllTrim(Tabela("06",E5_MOEDA,.F.))
					nPos := aScan( aDDown[8], { |x| x[3] == E5_MOEDA } )
					If nPos <> 0
						aDDown[8][nPos][2] += E5_VALOR
						nVezes := Val( SubStr( aDDown[8][nPos][1], Len( aDDown[8][nPos][1] ), 1 ) ) + 1
						aDDown[8][nPos][1] := "  " + nPgtoAux + Space( 21 - Len( nPgtoAux ) ) + Transform(aDDown[8][nPos][2], "@E 9,999,999.99") + Space(5) + AllTrim( Str( nVezes ) )
					Else
						aAdd(aDDown[8],{"  " + nPgtoAux+ Space( 21 - Len( nPgtoAux ) ) + Transform( E5_VALOR, "@E 9,999,999.99" ) + Space(5) + "1",E5_VALOR,E5_MOEDA} )
					EndIf           

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Caso o pagamento tenha sido feito antes dessa melhoria e não tenha³
				//³forma de pagamento no SE5 será incluido como "OUTROS"             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Else 
					nPgtoAux	:= "OUTROS"
					nPos		:= aScan( aDDown[8], { |x| x[3] == "OU" } )
					If nPos <> 0
						aDDown[8][nPos][2]	+= E5_VALOR
						nVezes := Val( SubStr( aDDown[8][nPos][1], Len( aDDown[8][nPos][1]), 1 ) ) + 1
						aDDown[8][nPos][1]	:= "  " + nPgtoAux + Space( 21 - Len( nPgtoAux ) ) + Transform(aDDown[8][nPos][2], "@E 9,999,999.99" ) + Space(5) + AllTrim( Str( nVezes ) )
					Else
						aAdd(aDDown[8],{"  " + nPgtoAux + Space( 21 - Len( nPgtoAux ) ) + Transform( E5_VALOR, "@E 9,999,999.99" )+ Space(5) + "1",E5_VALOR,"OU"} )
					EndIf           
				EndIf								
			Endif
		ElseIf E5_TIPODOC $ "SG/TR/TE"	.AND.	SE5->E5_RECPAG == "P"
			If E5_MOEDA == SuperGetMv("MV_SIMB1")
				aCaixa[P_SANG_DINHEIRO]		+=	nSe5Valor
			ElseIf E5_MOEDA $ "C1,C2,C3,C4,C5,CH"
				aCaixa[P_SANG_CHEQUE]		+=	nSe5Valor
			ElseIf E5_MOEDA == "CC"
				aCaixa[P_SANG_CARTAO]		+=	nSe5Valor			
			ElseIf E5_MOEDA == "VL"
				aCaixa[P_SANG_VALE]			+=	nSe5Valor
			ElseIf E5_MOEDA == "CO"
				aCaixa[P_SANG_CONVENIO]		+=	nSe5Valor
			ElseIf E5_MOEDA == "FI"
				aCaixa[P_SANG_FINANCIADO]	+=	nSe5Valor
			ElseIf E5_MOEDA == "CD"
				aCaixa[P_SANG_DEBAUTO]		+=	nSe5Valor
			Else
				aCaixa[P_SANG_OUTROS]		+=	nSe5Valor
			Endif

		ElseIf E5_TIPODOC $ "TR/TE"
			If E5_RECPAG == "R"	.AND.	SE5->E5_MOEDA <> "TC"	// O troco entrou como saldo inicial
				aCaixa[P_TRANSF_DESTINO]	+=	nSe5Valor
			Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Carrega o valor do Troco de Saida                                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Elseif (E5_TIPODOC == "VL" .AND. E5_MOEDA == "TC" .AND. E5_RECPAG == "P" .AND. cMV_LJTROCO )
			aCaixa[P_TROCO_SAIDA]	+=	nSe5Valor
		EndIf
		
		dbSkip()

	End
#ENDIF

If .T.
   cQry := "SELECT E1_FILORIG, E1_NUM, E1_PREFIXO, E1_CLIENTE, E1_LOJA, E1_TIPO, SUM(E1_VALOR) E1_VALOR, SUM(E1_ISS) E1_ISS, "
   cQry += " MAX(E1_EMISSAO) E1_EMISSAO, MAX(E1_VENCREA) E1_VENCREA"
   cQry += " FROM "+RetSQLName("SE1")+" SE1"
   cQry += " WHERE SE1.D_E_L_E_T_ = ' ' AND E1_ORIGEM = 'MATA460' AND E1_TIPO NOT IN ('ISS','TX ','INS','FGT')"
   cQry += " AND E1_FILORIG BETWEEN '" + cDeFilSL1 + "' AND '" + cAteFilSL1 + "'"
   cQry += " AND E1_EMISSAO BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "'"
   //cQry += " AND 'C09' >= '"+MV_PAR03+"' AND 'C09' <= '"+MV_PAR04+"'"
   cQry += " GROUP BY E1_FILORIG, E1_NUM, E1_PREFIXO, E1_CLIENTE, E1_LOJA, E1_TIPO"
   cQry += " ORDER BY E1_FILORIG, E1_NUM, E1_PREFIXO, E1_CLIENTE, E1_LOJA, E1_TIPO, E1_VENCREA"

   dbUseArea( .T., "TOPCONN", TCGenQry(,,ChangeQuery(cQry)), "SE1TMP", .F., .T.)

   TCSetField("SE1TMP","E1_EMISSAO", "D", 8, 0)
   TCSetField("SE1TMP","E1_VENCREA", "D", 8, 0)

   While !EOF()
      aAux  := AFill(Array(13),0)
      cNota := E1_FILORIG+E1_NUM+E1_PREFIXO+E1_CLIENTE+E1_LOJA
      While !EOF() .And. cNota == E1_FILORIG+E1_NUM+E1_PREFIXO+E1_CLIENTE+E1_LOJA

         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         //³Atribui a numeracao de acordo com a forma registrada no SE1³
         //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         Do Case			    
            Case RTrim( E1_TIPO ) = "CC"	// Cartao de credito: 1a. opcao do array aDDown/aValForma
               aAux[3] += E1_VALOR
            Case RTrim( E1_TIPO ) = "VA"	// Vales: 2a. opcao do array aDDown/aValForma
               aAux[4] += E1_VALOR
            Case RTrim( E1_TIPO ) = "CO"	// Convenio: 3a. opcao do array aDDown/aValForma
               aAux[5] += E1_VALOR
            Case RTrim( E1_TIPO ) = "FI"	// Financiado: 4a. opcao do array aDDown/aValForma
               aAux[6] += E1_VALOR
            Case RTrim( E1_TIPO ) = "CD"	// Cartao de Debito: 5a. array opcao do aDDown/aValForma
               aAux[7] += E1_VALOR
            Case RTrim( E1_TIPO ) = "CH"	// Cheque
               aAux[2] += E1_VALOR
            Case RTrim( E1_TIPO ) = "CR"	// Credito
               aAux[8] += E1_VALOR
            Case RTrim( E1_TIPO ) = "R$"	// Dinheiro
               aAux[1] += E1_VALOR
            Case RTrim( E1_TIPO ) = "BO"	// Boleto
               aAux[13] += E1_VALOR
            OtherWise                       // Nao eh nenhuma das foram de pagamento que tem administradora
               If E1_EMISSAO == E1_VENCREA
                  aAux[1] += E1_VALOR
               Else
                  aAux[6] += E1_VALOR
               Endif
         EndCase            

         dbSkip()
      Enddo

      aCaixa[P_VEND_DINHEIRO]   += aAux[1]
      aCaixa[P_VEND_CHEQUE]     += aAux[2]
      aCaixa[P_VEND_CARTAO]     += aAux[3]
      aCaixa[P_VEND_VALE]       += aAux[4]
      aCaixa[P_VEND_CONVENIO]   += aAux[5]
      aCaixa[P_VEND_FINANCIADO] += aAux[6]
      aCaixa[P_VEND_DEBAUTO]    += aAux[7]
      aCaixa[P_VEND_CREDITO]    += aAux[8]
      aCaixa[P_VEND_OUTROS]     += aAux[9]
      aCaixa[P_SANG_IMPOSTOS]   += aAux[10]
      aCaixa[P_VEND_ESTACIO]    += aAux[11]
      aCaixa[P_VEND_SERVICO]    += aAux[12]
      aCaixa[P_VEND_BOLETO]     += aAux[13]

      lNivel := .F.

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³Soh busca a administradora para as formas que podem ter administradora relacionada.³
      //³L1_CARTAO, L1_VALES, L1_CONVENI, L1_FINANC, L1_VLRDEBI                             ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If aAux[3]<>0 .OR.  aAux[4]<>0 .OR.  aAux[5]<>0 .OR.  aAux[6]<>0 .OR.  aAux[7]<>0 .OR.;
         aAux[2]<>0 .OR.  aAux[9]<>0 .OR.  aAux[13]<>0 // Foi adicionada mais esta linha em função da inclusao de contadores

         SD2->(dbSetOrder(3))
         SD2->(dbSeek(cNota))
         
         cQry := "SELECT CV_VALOR, CV_FORMAPG, CV_DESCFOR AS CV_ADMINIS, R_E_C_N_O_ AS CV_RECNO FROM "+RetSQLName("SCV")+" SCV "
         cQry += "WHERE D_E_L_E_T_ = ' ' AND CV_FILIAL = '"+SD2->D2_FILIAL+"' AND CV_PEDIDO = '"+SD2->D2_PEDIDO+"' "
         //cQry += "ORDER BY CV_DATA"

         dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMPSCV",.T.,.T.)
         dbGoTop()
         While !Eof()

            lNivel := .T.

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Atribui a numeracao de acordo com a forma registrada no SCV³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            Do Case
               Case RTrim( CV_FORMAPG ) = "CC"      // Cartao de credito: 1a. opcao do array aDDown/aValForma
                  nForma := 1
                  aContFina[1] += 1                 // Acumulando contador de cartão de crédito
               Case RTrim( CV_FORMAPG ) = "VA"      // Vales: 2a. opcao do array aDDown/aValForma
                  nForma := 2
                  aContFina[2] += 1                 // Acumulando contador de vales
               Case RTrim( CV_FORMAPG ) = "CO"      // Convenio: 3a. opcao do array aDDown/aValForma
                  nForma := 3
                  aContFina[3] += 1                 // Acumulando contador de convenios
               Case RTrim( CV_FORMAPG ) = "FI"      // Financiado: 4a. opcao do array aDDown/aValForma
                  nForma := 4
                  aContFina[4] += 1
               Case RTrim( CV_FORMAPG ) = "CD"      // Cartao de Debito: 5a. array opcao do aDDown/aValForma
                  nForma := 5
                  aContFina[5] += 1                 // Acumulando contador de cartão de debito
               Case RTrim( CV_FORMAPG ) = "CH"      // Cheque
                  nForma := 0
                  aContFina[6] += 1                 // Acumulando contador de cheques
               Case RTrim( CV_FORMAPG ) = "CR"      // Credito
                  nForma := 0
               Case RTrim( CV_FORMAPG ) = "R$"      // Dinheiro
                  nForma := 0
               Case RTrim( CV_FORMAPG ) = "BO"      // Boleto
                  nForma := 0
               OtherWise                            // Nao eh nenhuma das foram de pagamento que tem administradora
                  nForma := 0
                  aContFina[7] += 1                 // Acumulando contador de outras condições
            EndCase

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Se pertence a alguma forma de pagamento relacionada a administradora³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If nForma <> 0
               //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
               //³Seleciona o codigo da administradora³
               //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
               cCodAdm  := Left( CV_ADMINIS, 3 )

               SAE->( DBSetOrder( 1 ) )
               SAE->( DbSeek( xFilial( "SAE" ) + cCodAdm ) )

               cAdmCart := RTrim( Left( SAE->AE_DESC, 20 ) )
               nPos := aScan( aAux[ nForma ], { |x| x[1] == cCodAdm } )

               If nPos <> 0
                  aAux[nForma,nPos,3] += CV_VALOR
                  aAux[nForma,nPos,4] += 1
               Else
                  AAdd( aAux[ nForma ], { cCodAdm, cAdmCart, CV_VALOR, 1 } )
               EndIf
            EndIf

            dbSkip()
         Enddo
         dbCloseArea()
         dbSelectArea("SE1TMP")

      Endif

      If lNivel
         IncAvalForma(@aAux, @aValForma)
      EndIf

   Enddo
   dbCloseArea()
Endif

DbSelectArea("SL2")
dbSetOrder(1)

#IFDEF TOP

	cQuery := "SELECT SL1.L1_NUM    , SL1.L1_MOEDA  , SL1.L1_CONDPG , SL1.L1_FORMPG ," 
	cQuery +=        "SL1.L1_TXMOEDA, SL1.L1_DINHEIR, SL1.L1_CHEQUES, SL1.L1_CARTAO ,"
	cQuery +=        "SL1.L1_VALES  , SL1.L1_CONVENI, SL1.L1_FINANC , SL1.L1_VLRDEBI," 
	cQuery +=        "SL1.L1_CREDITO, SL1.L1_OUTROS , SL1.L1_VLRLIQ , SL1.L1_VALISS ,"
	cQuery +=        "SL1.L1_CLIENTE, SL1.L1_LOJA, SL1.L1_FILIAL"

	If SL1->(FieldPos( "L1_ABTOPCC" )) > 0
		cQuery += ", L1_ABTOPCC"
	EndIf
	
	If SuperGetMV("MV_LJREST", , .F.)
		cQuery += ", L1_ESTACIO, L1_SERVICO"
	EndIf

	cQuery += " FROM " + RetSQLName("SL1") + " SL1"

	If lUsaParam
		cQuery += " WHERE SL1.L1_FILIAL BETWEEN '" + cDeFilSL1 + "' AND '" + cAteFilSL1 + "'"
		cQuery += " AND SL1.L1_EMISNF BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "'"
		cQuery += " AND SL1.L1_OPERADO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"
	Else
		cQuery += " WHERE SL1.L1_FILIAL = '" + xFilial("SL1") + "'"
		cQuery += " AND SL1.L1_EMISNF = '" + DToS(dDataMovto) + "'"
		cQuery += " AND SL1.L1_OPERADO = '" + cCaixa + "'"
	EndIf
	cQuery += " AND (SL1.L1_TIPO <> '' OR (SL1.L1_TIPO = 'P' AND SL1.L1_DOCPED <> '')  "
	cQuery += " OR  (SL1.L1_TIPO = 'V' AND SL1.L1_DOC <> ''))
	cQuery += " AND SL1.D_E_L_E_T_ = ' '"
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'SL1TMP', .F., .T.)

	While !EOF()

		DbSelectArea( "SL2" )
		DbSeek( SL1TMP->(L1_FILIAL + L1_NUM) )
		
		DbSelectArea( "SL1TMP" )
			
		If FieldPos("L1_ABTOPCC") > 0 .AND. L1_ABTOPCC > 0
            
			nDinheiro := L1_DINHEIR
				
			nValPgtos := 0
			aAux      := {	nDinheiro , L1_CHEQUES, L1_CARTAO , L1_VALES  ,;
						   	L1_CONVENI, L1_FINANC , L1_VLRDEBI, L1_CREDITO,;
						   	L1_OUTROS, 0 }

			aEval(aAux, { |x| nValPgtos += x })

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se o valor de pagamentos for zero (abatimento de PIS/COFINS/CSLL    ³
			//³no valor total da venda) é somado o valor do abatimento no dinheiro.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( nValPgtos <= 0 )
				aAux[01] += L1_ABTOPCC
			EndIf
			aAdd(aAux, L1_ABTOPCC)			

		Else

			nDinheiro := L1_DINHEIR
			
			aAux := {	nDinheiro , L1_CHEQUES, L1_CARTAO , L1_VALES  , ;
			          	L1_CONVENI, L1_FINANC , L1_VLRDEBI, L1_CREDITO, ;
			          	L1_OUTROS , 0 }

		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso seja utilizado o sistema de Gestão de Restaurantes³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SuperGetMV("MV_LJREST", , .F.)
			AAdd( aAux, L1_ESTACIO )
			AAdd( aAux, L1_SERVICO )
		Else
			AAdd( aAux, 0 )
			AAdd( aAux, 0 )
		EndIf
		AAdd( aAux, 0 )
			
		// Acumula as vendas em boleto
		SL4->(dbSetOrder(1))
		SL4->(dbSeek(SL1TMP->(L1_FILIAL+L1_NUM),.T.))
		While !SL4->(Eof()) .And. SL4->(L4_FILIAL+L4_NUM) == SL1TMP->(L1_FILIAL+L1_NUM)
		   If RTrim(SL4->L4_FORMA) == "BO"
		      aAux[13] += SL4->L4_VALOR
		   Endif
		   SL4->(dbSkip())
		Enddo
		aAux[9] -= aAux[13]   // Diminui o boleto dos outros

		If ( Posicione("SA1",1,xFilial("SA1")+L1_CLIENTE+L1_LOJA,"SA1->A1_RECISS") == "1" .AND. ;
		     SuperGetMV("MV_DESCISS", , .F.) )

			aAux[10]  += L1_VALISS

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se o parâmetro MV_TPABISS for igual a 1, devo somar o valor do ISS nas parcelas.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ! lpTPAbISS

				nParcelas := 0
				nRestDiv  := 0
				nPos      := 0
			
				aEval(aAux, { |x, y| nParcelas += iIf( x > 0 .AND. y <> 10, 1, 0 ) })

				For nI := 1 To Len(aAux)
				
					If aAux[nI] > 0 .AND. nI <> 10
                                          
						nPos		:= iIf( nPos > 0, nPos, nI )
						aAux[nI]	+= Round(( aAux[10] / nParcelas ), 2)
						nRestDiv	+= Round(( aAux[10] / nParcelas ), 2)
						
					EndIf

				Next nI
				
				If nRestDiv <> aAux[10]
					aAux[nPos] -= ( aAux[10] - nRestDiv )
				EndIf
			
			EndIf
			
		EndIf
		
		If lLJ030TES
			aRet := ExecBlock("LJ030TES", .F., .F., {aAux, 1})
			If ValType(aRet) == "A"
				aAux := aRet
			EndIf
		EndIf
			
		aCaixa[P_VEND_DINHEIRO]		+= aAux[1]
		aCaixa[P_VEND_CHEQUE]		+= aAux[2]
		aCaixa[P_VEND_CARTAO]		+= aAux[3]
		aCaixa[P_VEND_VALE]			+= aAux[4]
		aCaixa[P_VEND_CONVENIO]		+= aAux[5]
		aCaixa[P_VEND_FINANCIADO]	+= aAux[6]
		aCaixa[P_VEND_DEBAUTO]		+= aAux[7]
		aCaixa[P_VEND_CREDITO]		+= aAux[8]
		aCaixa[P_VEND_OUTROS]		+= aAux[9]
		aCaixa[P_SANG_IMPOSTOS]		+= aAux[10]
		aCaixa[P_VEND_ESTACIO]		+= aAux[11]
		aCaixa[P_VEND_SERVICO]		+= aAux[12]
		aCaixa[P_VEND_BOLETO]		+= aAux[13]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se lSomaCred igual a .F. deve adicionar na variavel nVlrCred para que   ³
		//³ seja subtraida do totalizador de credito, uma vez que nao soma o credito³
		//³ de venda no totalizador 												³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If !lSomaCred
           nVlrCred                 += aAux[8]
		Endif
		
		lNivel := .F.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Soh busca a administradora para as formas que podem ter administradora relacionada.³
		//³L1_CARTAO, L1_VALES, L1_CONVENI, L1_FINANC, L1_VLRDEBI                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If aAux[3]<>0 .OR.  aAux[4]<>0 .OR.  aAux[5]<>0 .OR.  aAux[6]<>0 .OR.  aAux[7]<>0 .OR.  ;
  		   aAux[2]<>0 .OR.  aAux[9]<>0 .OR.  aAux[13]<>0 // Foi adicionada mais esta linha em função da inclusao de contadores
			
			lNivel := .T.
			
			DbSelectArea("SL4")
			dbSetOrder(1)
			SL4->( DbSeek( xFilial("SL4") + SL1TMP->L1_NUM ) )

			aAux := {{},{},{},{},{}}
			While SL4->( ! EoF() .AND. L4_NUM == SL1TMP->L1_NUM ) .AND. Empty(SL4->L4_ORIGEM)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atribui a numeracao de acordo com a forma registrada no SL4³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    	Do Case			    
					Case RTrim( SL4->L4_FORMA ) = "CC"		// Cartao de credito: 1a. opcao do array aDDown/aValForma
						nForma := 1
        				aContFina[1] += 1               	// Acumulando contador de cartão de crédito
					Case RTrim( SL4->L4_FORMA ) = "VA"		// Vales: 2a. opcao do array aDDown/aValForma
						nForma := 2	  
						aContFina[2] += 1					// Acumulando contador de vales
					Case RTrim( SL4->L4_FORMA ) = "CO"		// Convenio: 3a. opcao do array aDDown/aValForma
						nForma := 3					
						aContFina[3] += 1 			   	// Acumulando contador de convenios
					Case RTrim( SL4->L4_FORMA ) = "FI"		// Financiado: 4a. opcao do array aDDown/aValForma
						nForma := 4	  
						aContFina[4] += 1 								
					Case RTrim( SL4->L4_FORMA ) = "CD"		// Cartao de Debito: 5a. array opcao do aDDown/aValForma
						nForma := 5	  
						aContFina[5] += 1               	// Acumulando contador de cartão de debito
					Case RTrim( SL4->L4_FORMA ) = "CH"		// Cheque
						nForma := 0	
						aContFina[6] += 1 				// Acumulando contador de cheques
					Case RTrim( SL4->L4_FORMA ) = "CR"		// Credito
						nForma := 0	
					Case RTrim( SL4->L4_FORMA ) = "R$"		// Dinheiro
						nForma := 0							
					Case RTrim( SL4->L4_FORMA ) = "BO"		// Boleto
						nForma := 0							
					OtherWise       						// Nao eh nenhuma das foram de pagamento que tem administradora
						nForma := 0	
						aContFina[7] += 1					// Acumulando contador de outras condições
				EndCase            

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Se pertence a alguma forma de pagamento relacionada a administradora³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nForma <> 0

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Seleciona o codigo da administradora³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cCodAdm  := Left( SL4->L4_ADMINIS, 3 )

					SAE->( DBSetOrder( 1 ) )
					SAE->( DbSeek( xFilial( "SAE" ) + cCodAdm ) )

			    	cAdmCart := RTrim( Left( SAE->AE_DESC, 20 ) )

					nPos := aScan( aAux[ nForma ], { |x| x[1] == cCodAdm } )
				
					If nPos <> 0
						aAux[nForma,nPos,3] += SL4->L4_VALOR
						aAux[nForma,nPos,4] += 1
					Else
						AAdd( aAux[ nForma ], { cCodAdm, cAdmCart, SL4->L4_VALOR, 1 } )
					EndIf			

	            EndIf

		        SL4->( dbSkip() )

			End
			If lLJ030TES
				aRet := ExecBlock("LJ030TES", .F., .F., {aAux, 2})
				If ValType(aRet) == "A"
					aAux := aRet
				EndIf
			EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se existe vendas com NCC ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf aAux[8] <> 0
			aAux 	:= {{},{},{},{},{},{},{}}
			lNivel 	:= .T.
			aContFina[8] += 1
			AAdd( aAux[7], { "001",  STR0067 , L1_CREDITO, 1 } )
		Endif
		  
		If lNivel
			IncAvalForma(@aAux, @aValForma)
		EndIf

		DbSelectArea( "SL1TMP" )
		dbSkip()

	End
	DbSelectArea( "SL1TMP" )
	dbCloseArea()
#ELSE
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se foi criado o indice pela data limite³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SIX->( DbSetOrder( 1 ) )
	If SIX->( DbSeek( "SL1A" ) )
		If Upper(Alltrim( SIX->CHAVE )) == "L1_FILIAL+L1_OPERADO+DTOS(L1_EMISNF)"
			nIndice	:= 10           
		Else
			nIndice := 5
		Endif
	Endif

	DbSelectArea( "SL1" )
	dbSetOrder( nIndice )
	If lUsaParam
		DbSeek( cDeFilSL1, .T.)	// Filial
	Else
		DbSeek( xFilial() + cCaixa + DToS( dDataMovto ) )	// Filial + Caixa + Data
	EndIf
	While !EOF() .AND. ;
		L1_FILIAL  >= cDeFilSL1 .AND.;
		L1_FILIAL  <= cAteFilSL1 .AND.;
		If(lUsaParam, .T., If(nIndice == 10,DToS(L1_EMISNF)+L1_OPERADO == DToS(dDataMovto)+cCaixa,DToS(L1_EMISSAO)+L1_OPERADO == DToS(dDataMovto)+cCaixa))

		If lUsaParam .AND. !(L1_OPERADO >= MV_PAR03 .AND.;
			 L1_OPERADO <= MV_PAR04 .AND.;
			 If(nIndice == 10, L1_EMISNF >= MV_PAR01, L1_EMISSAO >= MV_PAR01) .AND.;
			 If(nIndice == 10, L1_EMISNF <= MV_PAR02, L1_EMISSAO <= MV_PAR02))
			dbSkip()
			Loop
		EndIf

		If Empty(L1_TIPO) .OR.  (L1_TIPO == "P" .AND. Empty(L1_DOCPED)) .OR.  (L1_TIPO=="V" .AND. Empty(L1_DOC))
			dbSkip()
			Loop
		EndIf

		DbSelectArea( "SL2" )
		DbSeek( SL1->(L1_FILIAL + L1_NUM) )
		DbSelectArea( "SL1" )

		If FieldPos("L1_ABTOPCC") > 0 .AND. L1_ABTOPCC > 0

			nDinheiro := L1_DINHEIR
			
			nValPgtos := 0
			aAux      := {	nDinheiro, L1_CHEQUES, L1_CARTAO , L1_VALES  , ;
			               L1_CONVENI, L1_FINANC , L1_VLRDEBI, L1_CREDITO, ;
			               L1_OUTROS, 0 }

			aEval(aAux, { |x| nValPgtos += x })

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se o valor de pagamentos for zero (abatimento de PIS/COFINS/CSLL    ³
			//³no valor total da venda) é somado o valor do abatimento no dinheiro.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( nValPgtos <= 0 )
				aAux[01] += L1_ABTOPCC
			EndIf

			aAdd(aAux, L1_ABTOPCC)			

		Else

			nDinheiro := L1_DINHEIR
			
			aAux := { 	nDinheiro , L1_CHEQUES, L1_CARTAO , L1_VALES  , ;
						L1_CONVENI, L1_FINANC , L1_VLRDEBI, L1_CREDITO, ;
						L1_OUTROS , 0 }

		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso seja utilizado o sistema de Gestão de Restaurantes³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SuperGetMV("MV_LJREST", , .F.)
			AAdd( aAux, L1_ESTACIO )
			AAdd( aAux, L1_SERVICO )
		Else
			AAdd( aAux, 0 )
			AAdd( aAux, 0 )
		EndIf		
		AAdd( aAux, 0 )
		
		// Acumula as vendas em boleto
		SL4->(dbSetOrder(1))
		SL4->(dbSeek(SL1->(L1_FILIAL+L1_NUM),.T.))
		While !SL4->(Eof()) .And. SL4->(L4_FILIAL+L4_NUM) == SL1->(L1_FILIAL+L1_NUM)
		   If RTrim(SL4->L4_FORMA) == "BO"
		      aAux[13] += SL4->L4_VALOR
		   Endif
		   SL4->(dbSkip())
		Enddo
		aAux[9] -= aAux[13]   // Diminui o boleto dos outros

		If ( Posicione("SA1",1,xFilial("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA,"SA1->A1_RECISS") == "1" .AND. ;
		     SuperGetMV("MV_DESCISS", , .F.) )
			
			aAux[10]  += L1_VALISS
			              
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se o parametro MV_TPABISS for igual a 1, devo somar o valor do ISS nas parcelas.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ! lpTPAbISS

				nParcelas := 0
				nRestDiv  := 0
				nPos      := 0

				aEval(aAux, { |x, y| nParcelas += iIf( x > 0 .AND. y <> 10, 1, 0 ) })

				For nI := 1 To Len(aAux)
				
					If aAux[nI] > 0 .AND. nI <> 10

						nPos     := iIf( nPos > 0, nPos, nI )
						aAux[nI] += Round(( aAux[10] / nParcelas ), 2)
						nRestDiv += Round(( aAux[10] / nParcelas ), 2)
						
					EndIf

				Next nI
				
				If nRestDiv <> aAux[10]
					aAux[nPos] -= ( aAux[10] - nRestDiv )
				EndIf
			
			EndIf			
			
		EndIf		

		If lLJ030TES
			aRet := ExecBlock("LJ030TES", .F., .F., {aAux, 1})
			If ValType(aRet) == "A"
				aAux := aRet
			EndIf
		EndIf
			
		aCaixa[P_VEND_DINHEIRO]   += aAux[1]
		aCaixa[P_VEND_CHEQUE]     += aAux[2]
		aCaixa[P_VEND_CARTAO]     += aAux[3]
		aCaixa[P_VEND_VALE]       += aAux[4]
		aCaixa[P_VEND_CONVENIO]   += aAux[5]
		aCaixa[P_VEND_FINANCIADO] += aAux[6]
		aCaixa[P_VEND_DEBAUTO]    += aAux[7]
		aCaixa[P_VEND_CREDITO]    += aAux[8]
		aCaixa[P_VEND_OUTROS]     += aAux[9]
		aCaixa[P_SANG_IMPOSTOS]   += aAux[10]		
		aCaixa[P_VEND_ESTACIO]    += aAux[11]
		aCaixa[P_VEND_SERVICO]    += aAux[12]		
		aCaixa[P_VEND_BOLETO]     += aAux[13]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se lSomaCred igual a .F. deve adicionar na variavel nVlrCred para que   ³
		//³ seja subtraida do totalizador de credito, uma vez que nao soma o credito³
		//³ de venda no totalizador 												³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
		If !lSomaCred
           nVlrCred               += aAux[8]
		Endif
		
		lNivel := .F.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Soh busca a administradora para as formas que podem ter administradora relacionada.³
		//³L1_CARTAO, L1_VALES, L1_CONVENI, L1_FINANC, L1_VLRDEBI                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aAux[3] <> 0 .OR.  aAux[4] <> 0	.OR.  aAux[5] <> 0	.OR.  aAux[6] <> 0	.OR. ; 
  		   aAux[7] <> 0 .OR.  aAux[2] <> 0 .OR.  aAux[9] <> 0 // Foi adicionada mais esta linha em função da inclusao de contadores

			lNivel 	:= .T.
			
			DbSelectArea( "SL4" )
			dbSetOrder( 1 )
			SL4->( DbSeek( xFilial("SL4") + SL1->L1_NUM ) )

			aAux := {{},{},{},{},{}}
			While SL4->( ! EoF() .AND. L4_NUM == SL1->L1_NUM ) .AND. Empty( SL4->L4_ORIGEM )

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atribui a numeracao de acordo com a forma registrada no SL4³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    	Do Case			    
					Case RTrim( SL4->L4_FORMA ) = "CC"		// Cartao de credito: 1a. opcao do array aDDown/aValForma
						nForma := 1
        				aContFina[1] += 1               	// Acumulando contador de cartão de crédito
					Case RTrim( SL4->L4_FORMA ) = "VA"		// Vales: 2a. opcao do array aDDown/aValForma
						nForma := 2	  
						aContFina[2] += 1					// Acumulando contador de vales
					Case RTrim( SL4->L4_FORMA ) = "CO"		// Convenio: 3a. opcao do array aDDown/aValForma
						nForma := 3					
						aContFina[3] += 1 			   	// Acumulando contador de convenios
					Case RTrim( SL4->L4_FORMA ) = "FI"		// Financiado: 4a. opcao do array aDDown/aValForma
						nForma := 4	  
						aContFina[4] += 1 								
					Case RTrim( SL4->L4_FORMA ) = "CD"		// Cartao de Debito: 5a. array opcao do aDDown/aValForma
						nForma := 5	  
						aContFina[5] += 1               	// Acumulando contador de cartão de debito
					Case RTrim( SL4->L4_FORMA ) = "CH"		// Cheque
						nForma := 0	
						aContFina[6] += 1 				// Acumulando contador de cheques
					Case RTrim( SL4->L4_FORMA ) = "CR"		// Credito
						nForma := 0	
					Case RTrim( SL4->L4_FORMA ) = "R$"		// Dinheiro
						nForma := 0							
					Case RTrim( SL4->L4_FORMA ) = "BO"		// Boleto
						nForma := 0							
					OtherWise       						// Nao eh nenhuma das foram de pagamento que tem administradora
						nForma := 0	
						aContFina[7] += 1					// Acumulando contador de outras condições
				EndCase            
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Se pertence a alguma forma de pagamento relacionada a administradora³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nForma <> 0

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Seleciona o codigo da administradora³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cCodAdm  := Left( SL4->L4_ADMINIS, 3 )
				
					SAE->( DBSetOrder( 1 ) )
					SAE->( DbSeek( xFilial( "SAE" ) + cCodAdm ) )
				
			    	cAdmCart := RTrim( Left( SAE->AE_DESC, 20 ) )
		        
					nPos := aScan( aAux[ nForma ], { |x| x[1] == cCodAdm } )
				
					If nPos <> 0
						aAux[nForma,nPos,3] += SL4->L4_VALOR
						aAux[nForma,nPos,4] += 1
					Else
						AAdd( aAux[ nForma ], { cCodAdm, cAdmCart, SL4->L4_VALOR, 1 } )
					EndIf

	            EndIf

		        SL4->( dbSkip() )

			End

			If lLJ030TES
				aRet := ExecBlock("LJ030TES", .F., .F., {aAux, 2})
				If ValType(aRet) == "A"
					aAux := aRet
				EndIf
			EndIf
        
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se existe vendas com NCC.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf aAux[8] <> 0	
			aAux 	:= {{},{},{},{},{},{},{}}
			lNivel 	:= .T.
			//nForma 	:= 7	
			aContFina[8] += 1
			AAdd( aAux[7], { "001",  STR0067 , L1_CREDITO, 1 } )			
		Endif
		
		If lNivel
			IncAvalForma(@aAux, @aValForma)
		EndIf

		DbSelectArea( "SL1" )
		dbSkip()

	End
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento das notas de credito (NCC)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	cQuery := "SELECT SUM(SE1.E1_SALDO) SUM_SALDO, Count(*) QTDE"
	cQuery += " FROM " + RetSQLName("SE1") + " SE1"
	If lUsaParam
		cQuery += " WHERE SE1.E1_FILORIG BETWEEN '" + cDeFilSE1 + "' AND '" + cAteFilSE1 + "'"
		cQuery += " AND SE1.E1_EMISSAO BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "'"
		cQuery += " AND SE1.E1_PORTADO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"
	Else
		cQuery += " WHERE SE1.E1_FILORIG = '" + xFilial("SE1") + "'"
		cQuery += " AND SE1.E1_EMISSAO = '" + DToS(dDataMovto) + "'"
		cQuery += " AND SE1.E1_PORTADO = '" + cCaixa + "'"
	EndIf
	cQuery += " AND SE1.E1_SALDO > 0"
	cQuery += " AND SE1.E1_TIPO = '"+MV_CRNEG+"'"
	cQuery += " AND SE1.D_E_L_E_T_ = ' '"
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'SE1TMP', .F., .T.)

	DbSelectArea("SE1TMP")
	If !EOF() .AND. SUM_SALDO > 0
		aCaixa[P_VEND_CREDITO] 	+= SUM_SALDO
		If !lSomaCred
           nVlrCred             += SUM_SALDO
		Endif				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Adiciona o saldo das NCCs na visualizacao dos Creditos de Vendas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		aAux := {{},{},{},{},{},{},{}}
		aContFina[8] += QTDE
		AAdd( aAux[7], { "002",  STR0068 , SUM_SALDO, QTDE} )
		IncAvalForma(@aAux, @aValForma)		
	EndIf
	dbCloseArea()
#ELSE
	DbSelectArea( "SE1" )
	dbSetOrder( 6 )

	If lUsaParam
		DbSeek(cDeFilSE1, .T. )	// Filial
	Else
		DbSeek(xFilial() + Dtos(dDataMovto))	// Filial + Data
	EndIf

	While !EOF() .AND. ;
		E1_FILORIG  >= cDeFilSE1 .AND.;
		E1_FILORIG  <= cAteFilSE1 .AND.;
		If(lUsaParam, .T., E1_EMISSAO == dDataMovto)
	
		If lUsaParam .AND. !(E1_EMISSAO >= MV_PAR01 .AND.;
			 E1_EMISSAO <= MV_PAR02)
			dbSkip()
			Loop
		EndIf

		If lUsaParam
			If (SE1->E1_PORTADOR >= MV_PAR03	.AND.;
				SE1->E1_PORTADOR <= MV_PAR04	.AND.;
				SE1->E1_SALDO > 0 .AND. E1_TIPO == MV_CRNEG )
				
				aCaixa[P_VEND_CREDITO] += SE1->E1_SALDO
				If !lSomaCred
		           nVlrCred            += SE1->E1_SALDO
				Endif								
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Adiciona o saldo das NCCs na visualizacao dos Creditos de Vendas³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
				aAux := {{},{},{},{},{},{},{}}
				aContFina[8] += 1
				AAdd( aAux[7], { "002",  STR0068 , E1_SALDO, 1 } )
				IncAvalForma(@aAux, @aValForma)			
			EndIf
		Else
			If SE1->E1_PORTADOR == cCaixa .AND. SE1->E1_SALDO > 0 .AND. E1_TIPO == MV_CRNEG
				aCaixa[P_VEND_CREDITO] += SE1->E1_SALDO
				If !lSomaCred
		           nVlrCred            += SE1->E1_SALDO
				Endif												
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Adiciona o saldo das NCCs na visualizacao dos Creditos de Vendas³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
				aAux := {{},{},{},{},{},{},{}}
				aContFina[8] += 1
				AAdd( aAux[7], { "002",  STR0068 , E1_SALDO, 1 } )
				IncAvalForma(@aAux, @aValForma)
			EndIf
		EndIf
		dbSkip()
	End
#ENDIF    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta array de subitens para o ListBox de vendas a partir do array ³
//³de valores por administradora e forma de pagamento.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nJ := 1 to Len( aValForma ) 

	If nJ > Len(aDDown)
		AAdd(aDDown,{})
	EndIf 
	
	For nI := 1 to Len( aValForma[ nJ ] )
		AAdd( aDDown[ nJ ], { "  " + ;
		                      aValForma[ nJ, nI, 2 ] + Eval( bTab, aValForma[ nJ, nI, 2 ] ) + ;
		                      Transform( aValForma[ nJ, nI, 3 ], "@E 9,999,999.99" ) + ;
		                      " " + ;
		                      Str(aValForma[ nJ, nI, 4 ] ,5) ,;
		                      aValForma[ nJ, nI, 3 ] } )
	Next nI
Next nJ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada LJ030DEV                                                    ³
//³Parametros:  Nenhum                                                          ³
//³Retorno:  Array contendo as linhas que deverao ser mostradas no drilldown    ³
//³do itens devolucoes.                                                         ³
//³                                                                             ³
//³Exemplo:  aDev := {{"   DINHEIRO                 1.000,00 ",1000},;          ³
//³                   {"   CHEQUE                     300,00 ", 300}}           ³
//³                                                                             ³
//³Observacoes:  Utilizado para retornar as formas de pagamento e valores       ³
//³das devolucoes, para que sejam impressos no Resumo de Caixa.                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lLj030Dev
	aDev := ExecBlock ("LJ030DEV",.F.,.F.)
	If ValType(aDev) == "A"
		nJ := 1
		For nJ := 1 to Len (aDev)
			AAdd(aDDown[ 6 ] , aClone(aDev[ nJ ]))
		Next nJ
		aCaixa[P_DEVOLUCAO] := 0
		aEval( aDev, {|x| aCaixa[P_DEVOLUCAO] += x[2] } )
	Endif
EndIf
   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Le o SD1 para determinar as devolucoes somente se não existir o ponto de entrada      ³
//³LJ030DEV. Se existir,o valor da devolucao sera a soma dos valores retornados pelo P.E.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lLj030Dev
#IFDEF TOP
	cQuery := "SELECT SUM(SD1.D1_TOTAL + SD1.D1_VALIPI + SD1.D1_ICMSRET - SD1.D1_VALDESC) DEVOLUCAO"
	cQuery += " FROM " + RetSQLName("SD1") + " SD1"
	If lUsaParam
		cQuery += " WHERE SD1.D1_FILIAL BETWEEN '" + cDeFilSD1 + "' AND '" + cAteFilSD1 + "'"
		cQuery += " AND SD1.D1_EMISSAO BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "'"
		If ! (AllTrim(Upper(TCGetDB())) $ "ORACLE_INFORMIX")
			cQuery += "  AND SUBSTRING(SD1.D1_NUMCQ,1,3) BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"
		Else
			cQuery += "  AND SUBSTR(SD1.D1_NUMCQ,1,3) BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"
		EndIf
	Else
		cQuery += " WHERE SD1.D1_FILIAL = '" + xFilial("SD1") + "'"
		cQuery += " AND SD1.D1_EMISSAO = '" + DToS(dDataMovto) + "'"
		If ! (AllTrim(Upper(TCGetDB())) $ "ORACLE_INFORMIX")
			cQuery += "  AND SUBSTRING(SD1.D1_NUMCQ,1,3) = '" + cCaixa + "'"
		Else
			cQuery += "  AND SUBSTR(SD1.D1_NUMCQ,1,3) = '" + cCaixa + "'"
		EndIf
	EndIf
	cQuery += " AND SD1.D1_TIPO = 'D'"
	cQuery += " AND SD1.D1_ORIGLAN = 'LO'"
	cQuery += " AND SD1.D_E_L_E_T_ = ' '"
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'SD1TMP', .F., .T.)

	aCaixa[P_DEVOLUCAO] += DEVOLUCAO
	dbCloseArea()

#ELSE
	DbSelectArea( "SD1" )
	dbSetOrder( 3 )

	If lUsaParam
		DbSeek(cDeFilSD1, .T. )	// Filial
	Else
		DbSeek(xFilial()+DToS(dDataMovto))
	EndIf

	While !EOF() .AND. ;
		D1_FILIAL  >= cDeFilSD1		.AND.;
		D1_FILIAL  <= cAteFilSD1	.AND.;
		If(lUsaParam, .T., D1_EMISSAO == dDataMovto)
	
		If	lUsaParam .AND. !(D1_EMISSAO >= MV_PAR01 .AND.;
			D1_EMISSAO <= MV_PAR02)
			dbSkip()
			Loop
		EndIf

		If SD1->D1_TIPO == "D" .AND. SD1->D1_ORIGLAN == "LO"
			If If(lUsaParam, Left(SD1->D1_NUMCQ,3) >= MV_PAR03 .AND. Left(SD1->D1_NUMCQ,3) <= MV_PAR04,;
							Substr(SD1->D1_NUMCQ,1,3) == cCaixa)
							
				aCaixa[P_DEVOLUCAO] += (SD1->D1_TOTAL + SD1->D1_VALIPI + SD1->D1_ICMSRET - SD1->D1_VALDESC)
			EndIf
			dbSkip()
			Loop
		EndIf

		DbSelectArea( "SD1" )
		dbSkip()

		While !Empty( cNumero ) .AND. cNumero == SD1->D1_SERIORI + SD1->D1_NFORI
			dbSkip()
		End
	End
#ENDIF
Endif

DbSelectArea( cAlias )

Return aCaixa

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao	  ³LJ030Refresh³ Autor ³ Cesar Valadao       ³ Data ³ 28/01/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³Executa refresh nos listbox								   ³±±	
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		  ³SIGALOJA                                                    ³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                       
Static Function LJ030Refresh(	nOpc		, oTrocoSaida	, nTrocoSaida	, cMV_LJTROCO	,;
					 	aCaixa		, nTroco 		, nTotCredito	, nTotDebito	,;
					 	nSaldFinal 	, nEstac 		, nGorjeta 		, oMovVen		,;
					 	oMovSan		, aDadosVen		, aSinal		, aDDown		,;
					 	aContFina	, aDadosSan     , nVlrCred      , lSomaCred     )
Local cCaixa := "   "
Local dDataMovto := dDataBase

#IFNDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se a data, caixa e filial forem a mesma, faz uma pesquisa mais rapida. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (MV_PAR01 == MV_PAR02) .AND. (MV_PAR03 == MV_PAR04) .AND. (MV_PAR05 == MV_PAR06)
		cCaixa     := MV_PAR03
		dDataMovto := MV_PAR01
	EndIf
#ENDIF

aCaixa := MovimCaixa( cCaixa	 , dDataMovto	, cMV_LJTROCO	, @aDDown ,;
					  @aContFina , @nVlrCred    , lSomaCred     )

// Alimenta Totalizadores / Arrays aDados...
Lj030Dados(	aCaixa	, nOpc			, Nil			, @nTrocoSaida	,;
		    @nTroco	, @nTotCredito	, @nTotDebito	, @nSaldFinal	,;
		    @nEstac	, @nGorjeta		, @aDadosVen	, @aSinal		,;
		    @aDDown	, @aContFina	, @aDadosSan	, nVlrCred      )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seta Vetores de Dados de Credito / Debito para ListBox     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oMovVen:SetArray(aDadosVen)
oMovVen:bLine := {|| {	aDadosVen[oMovVen:nAt][1] } }
oMovVen:Refresh()
oMovSan:SetArray(aDadosSan)
oMovSan:bLine := {|| {	aDadosSan[oMovSan:nAt][1] } }
oMovSan:Refresh()

oTotCre:Refresh()
oTotDeb:Refresh()
oSaldFinal:Refresh()
oTroco:Refresh()    


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso o parametro MV_LJTROCO esteja como TRUE, atualiza o objeto oTrocoSaida³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cMV_LJTROCO
	oTrocoSaida:Refresh()    
Endif

If SuperGetMV( "MV_LJREST", , .F. )
	oEstac:Refresh()
	oGorjeta:Refresh()
Endif

Return(NIL)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o	  ³ LJ030DDown ³ Autor ³ Cesar Valadao       ³ Data ³ 23/01/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³ Aumenta ou Diminui o nivel de detalhes nas formas de pagto ³±±	
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		  ³SIGALOJA                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LJ030DDown( nOpc		, nDados		, nTrocoSaida 	, nTroco	,;
					 nTotCredito, nTotDebito	, nSaldFinal 	, nEstac	,;
					 nGorjeta	, oMovVen		, oMovSan		, aDadosVen	,;
					 aSinal		, aDDown		, aContFina		, aCaixa	,;
					 aDadosSan	, nVlrCred      )
					  
// Alimenta Totalizadores / Arrays aDados...
Lj030Dados(	@aCaixa		, nOpc			, nDados		, @nTrocoSaida	,;
			@nTroco		, @nTotCredito	, @nTotDebito	, @nSaldFinal	,;
			@nEstac		, @nGorjeta		, @aDadosVen	, @aSinal		,;
			@aDDown		, @aContFina	, @aDadosSan	, nVlrCred      )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seta Vetores de Dados de Credito / Debito para ListBox     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oMovVen:SetArray(aDadosVen)
oMovVen:bLine := {|| { aDadosVen[oMovVen:nAt][1] }}
oMovVen:Refresh()
oMovSan:SetArray(aDadosSan)
oMovSan:bLine := {|| { aDadosSan[oMovSan:nAt][1] }}
oMovSan:Refresh()

Return(NIL)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao	  ³LJ030Dados³ Autor ³ Cesar Valadao         ³ Data ³ 28/01/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³Fun‡„o que alimenta totalizadores por referˆncia e          ³±±
±±³           ³vetores de Dados aDadosVen e aDadosSan a partir de 		   ³±±
±±³           ³aCaixa recebido como parƒmetro.							   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		  ³SIGALOJA                                                    ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista   ³ Data   | BOPS  ³Manutencao Efetuada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcos     ³07/07/05³83694  ³Adicionado visualizacao de vendas e NCC no ³±±
±±³           ³        ³       ³no total de Credito Cliente.         	   ³±±
±±³Adrianne   ³18/08/05³85231  ³Implementação da Linha de RECEBIMENTOS como³±±
±±³           ³        ³       ³tipo Drill Down.						   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Lj030Dados(aCaixa		, nOpcao		, nDados		, nTrocoSaida 	,;
					nTroco		, nTotCredito	, nTotDebito	, nSaldFinal	,;
					nEstac 		, nGorjeta		, aDadosVen		, aSinal		,;
					aDDown		, aContFina		, aDadosSan     , nVlrCred      )
Local aCaixaStr := {}     
Local nI        := 0 //variavel de LOOP
Local bTab
Local cOpcao    := ""
Local cOpcaoVen := ""	

nTrocoSaida := aCaixa[P_TROCO_SAIDA]
                  
bTab      := { |x| Space( 21 - Len(x) ) }
nTroco    := aCaixa[P_TROCO]			// Saldo Inicial
nEstac	  := aCaixa[P_VEND_ESTACIO]
nGorjeta  := aCaixa[P_VEND_SERVICO]

If nOpcao == NIL
	nOpcao    := 0
EndIf

If nOpcao <> 0                     
	If nDados = 1 
		cOpcao := aDadosVen[ nOpcao, 1 ]
	Else
		cOpcaoVen := aDadosSan[ nOpcao, 1 ]        
	EndIf
Else
	cOpcao := ""
	cOpcaoVen := ""	
EndIf	


aDadosSan := {} 
aDadosVen := {}       

// Cria vetor com os valores em string para formar a unica coluna
For nI := 1 to Len( aCaixa )
	AAdd( aCaixaStr, Transform( aCaixa[ nI ], "@E 9,999,999.99" ) )
Next nI

aadd(aDadosSan,{ "  " + STR0007 + Eval(bTab, STR0007) + aCaixaStr[P_SANG_DINHEIRO  ], aCaixa[P_SANG_DINHEIRO  ]})
aadd(aDadosSan,{ "  " + STR0008 + Eval(bTab, STR0008) + aCaixaStr[P_SANG_CHEQUE    ], aCaixa[P_SANG_CHEQUE    ]})
aadd(aDadosSan,{ "  " + STR0009 + Eval(bTab, STR0009) + aCaixaStr[P_SANG_CARTAO    ], aCaixa[P_SANG_CARTAO    ]})
aadd(aDadosSan,{ "  " + STR0015 + Eval(bTab, STR0015) + aCaixaStr[P_SANG_VALE      ], aCaixa[P_SANG_VALE      ]})
aadd(aDadosSan,{ "  " + STR0010 + Eval(bTab, STR0010) + aCaixaStr[P_SANG_CONVENIO  ], aCaixa[P_SANG_CONVENIO  ]})
aadd(aDadosSan,{ "  " + STR0012 + Eval(bTab, STR0012) + aCaixaStr[P_SANG_FINANCIADO], aCaixa[P_SANG_FINANCIADO]})
aadd(aDadosSan,{ "  " + STR0041 + Eval(bTab, STR0041) + aCaixaStr[P_SANG_DEBAUTO   ], aCaixa[P_SANG_DEBAUTO   ]})
aadd(aDadosSan,{ "  " + STR0013 + Eval(bTab, STR0013) + aCaixaStr[P_SANG_OUTROS    ], aCaixa[P_SANG_OUTROS    ]})
aadd(aDadosSan,{ "  " + STR0042 + Eval(bTab, STR0042) + aCaixaStr[P_PAGAMENTOS     ], aCaixa[P_PAGAMENTOS     ]})
aadd(aDadosSan,{ "  " + STR0043 + Eval(bTab, STR0043) + aCaixaStr[P_TRANSF_ORIGEM  ], aCaixa[P_TRANSF_ORIGEM  ]})
If ExistBlock("LJ030DEV")  
	TrataNivel( @aDadosSan				, STR0016				, cOpcaoVen	, 6			,;
				aCaixaStr[P_DEVOLUCAO]	, aCaixa[P_DEVOLUCAO]	, Len(aDDown[6]), @aSinal	,;
				@aDDown )
Else
	aadd(aDadosSan,{ "  " + STR0016 + Eval(bTab, STR0016) + aCaixaStr[P_DEVOLUCAO      ], aCaixa[P_DEVOLUCAO      ]})
EndIf

If SL1->(FieldPos("L1_ABTOPCC")) > 0
	AAdd( aDadosSan,{"  " + STR0062 + Eval(bTab, STR0062) + aCaixaStr[P_SANG_IMPOSTOS], aCaixa[P_SANG_IMPOSTOS]})//"Retenção de Impostos"
EndIf

nTotDebito := 	aCaixa[P_SANG_DINHEIRO ] + aCaixa[P_SANG_CHEQUE     ] + ;
				aCaixa[P_SANG_CARTAO   ] + aCaixa[P_SANG_VALE       ] + ;
				aCaixa[P_SANG_CONVENIO ] + aCaixa[P_SANG_FINANCIADO ] + ;
				aCaixa[P_SANG_DEBAUTO  ] + aCaixa[P_PAGAMENTOS      ] + ;
				aCaixa[P_TRANSF_ORIGEM ] + aCaixa[P_DEVOLUCAO       ] + ;
				aCaixa[P_SANG_OUTROS   ] + aCaixa[P_SANG_IMPOSTOS   ]

aadd(aDadosVen,{ "  " + STR0007 + Eval( bTab, STR0007 ) + aCaixaStr[P_VEND_DINHEIRO ] + " " + Space(05) 	   		, aCaixa[P_VEND_DINHEIRO] })
aadd(aDadosVen,{ "  " + STR0008 + Eval( bTab, STR0008 ) + aCaixaStr[P_VEND_CHEQUE   ] + " " + Str(aContFina[6],5)	, aCaixa[P_VEND_CHEQUE]   })

TrataNivel(	 @aDadosVen					, STR0009				, cOpcao		, 1		,;
			 aCaixaStr[P_VEND_CARTAO]	, aCaixa[P_VEND_CARTAO]	, aContFina[1]	, @aSinal,;
			 @aDDown )

TrataNivel( @aDadosVen					, STR0011				, cOpcao		, 2		,;
			 aCaixaStr[P_VEND_VALE]		, aCaixa[P_VEND_VALE]  	, aContFina[2]	, @aSinal,;
			 @aDDown )
			 
TrataNivel( @aDadosVen					, STR0010				, cOpcao		, 3		,;
			aCaixaStr[P_VEND_CONVENIO], aCaixa[P_VEND_CONVENIO]  	, aContFina[3], @aSinal,;
			@aDDown ) 

TrataNivel( @aDadosVen					, STR0012					, cOpcao		, 4		,;
			aCaixaStr[P_VEND_FINANCIADO], aCaixa[P_VEND_FINANCIADO], aContFina[4]	, @aSinal,;
			@aDDown )

TrataNivel( @aDadosVen					, STR0041				, cOpcao		, 5		,;
			aCaixaStr[P_VEND_DEBAUTO]	, aCaixa[P_VEND_DEBAUTO], aContFina[5]	, @aSinal,;
			@aDDown )

aadd(aDadosVen,{ "  " + STR0071 + Eval( bTab, STR0071 ) + aCaixaStr[P_VEND_BOLETO   ] + " " + Space(05)				, aCaixa[P_VEND_BOLETO]   })
aadd(aDadosVen,{ "  " + STR0013 + Eval( bTab, STR0013 ) + aCaixaStr[P_VEND_OUTROS   ] + " " + Str(aContFina[7],5)	, aCaixa[P_VEND_OUTROS]   })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adicionado a visualizacao  total de creditos aos clientes gerados pelas devolucoes e tambem pelas vendas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TrataNivel( @aDadosVen					, STR0045					, cOpcao		, 7		,;
			aCaixaStr[P_VEND_CREDITO]	, aCaixa[P_VEND_CREDITO]	, aContFina[8]	, @aSinal,;
			@aDDown)

aadd(aDadosVen,{ "  " + STR0043 + Eval( bTab, STR0043 ) + aCaixaStr[P_TRANSF_DESTINO] + " " + Space(05)		   	, aCaixa[P_TRANSF_DESTINO]})

TrataNivel( @aDadosVen					, STR0044					, cOpcao		, 8		,;
			aCaixaStr[P_RECEBIMENTOS]	, aCaixa[P_RECEBIMENTOS]	, aContFina[9]	, @aSinal,;
			@aDDown	)

nTotCredito :=	aCaixa[P_VEND_DINHEIRO ] + aCaixa[P_VEND_CHEQUE     ] + ;
				aCaixa[P_VEND_CARTAO   ] + aCaixa[P_VEND_VALE       ] + ;
				aCaixa[P_VEND_CONVENIO ] + aCaixa[P_VEND_FINANCIADO ] + ;
				aCaixa[P_VEND_DEBAUTO  ] + aCaixa[P_VEND_CREDITO    ] + ;
				aCaixa[P_VEND_OUTROS   ] + aCaixa[P_TRANSF_DESTINO  ] + ;
				aCaixa[P_RECEBIMENTOS  ] + aCaixa[P_VEND_BOLETO     ] - nVlrCred


nSaldFinal := nTroco + nTotCredito - nTotDebito - nTrocoSaida

Return(NIL)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³TrataNivel³ Autor ³ Gustavo Henrique      ³ Data ³ 26/06/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para tratar opcoes disponiveis para Drill-Down      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TrataNivel(ExpC0, ExpC1,ExpC2,ExpN3,ExpC4)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC0 = Array que irá receber valores                      ³±±
±±³          ³ ExpC1 = String a ser exibida no ListBox                    ³±±
±±³          ³ ExpC2 = Opcao selecionada com clique duplo                 ³±±
±±³          ³ ExpN3 = Opcao do drill down a ser tratada                  ³±±
±±³          ³ ExpC4 = String com o Valor atualizado da linha do listbox  ³±±
±±³          ³ ExpN5 = Valor atualizado da linha do listbox 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Vetores:                                                   ³±±
±±³          ³ aSinal - Vetor declarado na funcao principal que           ³±±
±±³          ³          armazena os sinais de "+" e "-" dos itens que     ³±±
±±³          ³          podem ter subitens. Este varia de acordo com o    ³±±
±±³          ³          estado do item: aberto ou fechado.                ³±±
±±³          ³ aDDown - Vetor declarado na funcao principal que           ³±±
±±³          ³          armazenao os subitens dos itens do LisBox que     ³±±
±±³          ³          podem ter variacao de estado: aberto ou fechado.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ LOJC030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TrataNivel(	aArr	, cString	, cDblClick	, nOpDrill	,;
							cValor	, nValor 	, nQtde		, aSinal 	,;
							aDDown	)

Local nI, bTab, cQtde
Default nQtde := 0   
cQtde := Str(nQtde,5)

// Espacos para alinhar a direita o valor no ListBox
bTab := { |x| Space( 21 - Len(x) ) }
                                                    
// Se a string passada estiver contida na opcao que foi selecionada com DblClick no ListBox
If cString $ cDblClick
	// Abre os subitens do item do ListBox se houverem
	If aSinal[nOpDrill] == "+" .AND. Len( aDDown[nOpDrill] ) > 0
		aSinal[nOpDrill] := "-"
		AAdd( aArr, { aSinal[nOpDrill] + " " + cString + Eval( bTab, cString ), nValor } )
		For nI := 1 to Len( aDDown[nOpDrill] )
			AAdd( aArr, aDDown[nOpDrill, nI] )
		Next nI	
	Else                                              
		// Se nao houverem subitens, reapresenta o item e muda apenas o sinal.
		If  aSinal[nOpDrill] == "+"
			aSinal[nOpDrill] := "-"
		Else                                                             
			aSinal[nOpDrill] := "+" 
		EndIf                       
		
		AAdd( aArr, { aSinal[nOpDrill] + " " + cString + Eval( bTab, cString ) + cValor + " " + cQtde , nValor } )
	EndIf
Else                                               
	// Se estiver aberto, reimprime os subitens
	If aSinal[nOpDrill] == "-" .AND. Len( aDDown[nOpDrill] ) > 0
		// Apenas mantem o que estava anteriormente no ListBox
		AAdd( aArr, { aSinal[nOpDrill] + " " + cString + Eval( bTab, cString ), nValor  } )
		For nI := 1 to Len( aDDown[nOpDrill] )
			AAdd( aArr, aDDown[nOpDrill, nI] )
		Next nI	
	Else	
		// Apenas mantem o que estava anteriormente no ListBox
		AAdd( aArr, { aSinal[nOpDrill] + " " + cString + Eval( bTab, cString ) + cValor + " " + cQtde , nValor } )
	EndIf
EndIf

Return( NIL )       

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³IncAvalFor³ Autor ³ Microsiga             ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para ajustar o nivel								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ IncAvalForma(ExpA1, ExpA2)								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ LOJC030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IncAvalForma(aAux, aValForma)
Local nI 	:= 0 // variavel de loop
Local nJ 	:= 0 // variavel de loop
Local nPos	:= 0
    
For nI := 1 To Len(aAux)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Compatibilizacao de tamanhos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nI > Len(aValForma)
		AAdd(aValForma,{})		
	EndIf

	If valtype(aAux[nI]) == "A" .Or. valtype(aAux[nI]) == "a"
		For nJ := 1 To Len(aAux[nI])
			nPos := aScan( aValForma[nI], { |x| x[1] == aAux[nI][nJ][1] } )
			If nPos<>0
				aValForma[nI,nPos,3] += aAux[nI][nJ][3]
				aValForma[nI,nPos,4] += aAux[nI][nJ][4]
			Else
				AAdd( aValForma[nI], AClone(aAux[nI][nJ]) )
			EndIf						
		Next nJ
	EndIf
Next nI
	
Return .T.