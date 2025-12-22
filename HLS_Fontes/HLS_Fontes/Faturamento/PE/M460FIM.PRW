#include "rwmake.ch"

/*/{protheus.doc}M460FIM
Utilizado na Geracao da Nota Fiscal de Saida
- Ponto de entrada disparado na geracao da nota de saida.
Tem por objetivo abrir tela para que o usuario informe os dados adicionais da nota: transportadora, redespacho, placa, nome do motorista, peso liquido, peso bruto, volume
especie, marca, dt saida e Hr saida (estes campos serao gravados no SF2). O calculo do peso liquido e calculado     ³±±
automaticamente atraves da formula: D2_QUANT*B1_PESO.
O programa tambem abrira uma tela mostrando as mensagens padrao informados no produto, tes e pedido de vendas. Estas mensagens poderao ser alteradas, ou inserida uma nova linha por mensagem. Todas as mensagens informadas serao gravadas
no arquivo SZZ (mensagens por nota) 
@author Fabricio M Vieira
@since 22/07/08
/*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M460FIM  ³ Autor ³ Fabricio M Vieira     ³ Data ³ 22/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Microsiga Campin ³Contato ³ cps.fabriciom@microsiga.com.br ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³- Utilizado na Geracao da Nota Fiscal de Saida              ³±±
±±³          ³- Ponto de entrada disparado na geracao da nota de saida.   ³±±
±±³          ³Tem por objetivo abrir tela para que o usuario informe      ³±±
±±³          ³os dados adicionais da nota: transportadora, redespacho,    ³±±
±±³          ³placa, nome do motorista, peso liquido, peso bruto, volume  ³±±
±±³          ³especie, marca, dt saida e Hr saida (estes campos serao     ³±±
±±³          ³gravados no SF2). O calculo do peso liquido e calculado     ³±±
±±³          ³automaticamente atraves da formula: D2_QUANT*B1_PESO        ³±±
±±³          ³O programa tambem abrira uma tela mostrando as mensagens    ³±±
±±³          ³padrao informados no produto, tes e pedido de vendas. Estas ³±±
±±³          ³mensagens poderao ser alteradas, ou inserida uma nova linha ³±±
±±³          ³por mensagem. Todas as mensagens informadas serao gravadas  ³±±
±±³          ³no arquivo SZZ (mensagens por nota)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MP10 MSSQL                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function M460FIM()

Local _aArea	:= GetArea()			// Inicializa array para capturar Area de Trabalho desconhecida
Local _aAreaSB1	:= SB1->(GetArea())	// Inicializa array para capturar Area de Trabalho SB1
Local _aAreaSF2 := SF2->(GetArea())	// Inicializa array para capturar Area de Trabalho SF2
Local _aAreaSD2	:= SD2->(GetArea())	// Inicializa array para capturar Area de Trabalho SD2
Local _aAreaSA1	:= SA1->(GetArea())	// Inicializa array para capturar Area de Trabalho SA1
Local _aAreaSA2	:= SA2->(GetArea())	// Inicializa array para capturar Area de Trabalho SA2
Local _aAreaSC5	:= SC5->(GetArea())	// Inicializa array para capturar Area de Trabalho SC5
Local _aAreaSF4	:= SF4->(GetArea())	// Inicializa array para capturar Area de Trabalho SF4
Local _cNome    := ""
Local _cDoc     := SF2->F2_DOC
Local _cSerie   := SF2->F2_SERIE
Local _nQtd     := SF2->F2_VOLUME1
Local _nPBruto  := 0
Local _nPLiqui  := 0
Local _cTransp  := ""
Local _cCodRed  := ""
Local _cEspec   := ""
Local _cNomeRed := space(30)
Local _cPlaca   := space(08)
Local _cMarca   := space(20)
Local _cMens    := ""
Local _cMens1   := space(03)
Local _cMens2   := space(03)
Local _dDtSaida := dDataBase
Local _cHrSaida := Time()
//Local _cEspec   := "" 
Local _cLocEmb  := "" 
Local _cUFEmb   := ""
//Local lSair     := .t.
Local _nRecD2   := 0
Local cZZTelM460:=	GetMv("ZZ_TELM460",,"S")	//	Habilitar interface de dados adicionais no ponto de entrada M460FIM.
//Local cZZTelM460:=	GetMv("ZZ_TELM460",,"N")	//	Habilitar interface de dados adicionais no ponto de entrada M460FIM.

Private aCod[8]					// Inicializa array com 8 elementos para os codigos das mensagens.
Private aMsg[8]					// Inicializa array com 8 elementos para os textos das mensagens.
Private lMsg   := .t.
Private nVar   := 0
Private cMsg   := ""
Private cCod   := ""
Private cLin1  := ""
Private cLin2  := ""
Private _lFecha:= .f.

aFill(aCod, space(003))			// Inicializa cada um dos 8 elementos do array com o tamanho para os codigos das mensagens.
aFill(aMsg, space(500))			// Inicializa cada um dos 8 elementos do array com o tamanho para os textos das mensagens.


If cZZTelM460=="S"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona SD2 - itens da nota fiscal                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD2")
	dbSetOrder(3)                 //filial,doc,serie,cliente,loja,cod
	dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE)
	_nRecD2 := SD2->(Recno())
	
	dbSelectArea("SF4")
	dbSeek(xFilial("SF4")+SD2->D2_TES)
	
	dbSelectArea("SC5")
	dbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
	
	If SF2->F2_TIPO == "D" .OR. SF2->F2_TIPO == "B" //nf de devolucao/remessa->fornecedor
		dbSelectArea("SA2")
		dbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		_cNome := SubStr(SA2->A2_NOME,1,30)
	Else
		dbSelectArea("SA1")
		dbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		_cNome := SubStr(SA1->A1_NOME,1,30)
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calcula Peso Liquido da Nota de Saida a partir do peso cadastrado no produto³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nPLiqui := SC5->C5_PESOL
	If _nPLiqui == 0
		dbSelectArea("SD2")
		While SD2->(!Eof()) .and. SD2->D2_FILIAL == SF2->F2_FILIAL .and. SD2->D2_DOC == SF2->F2_DOC .and.;
			SD2->D2_SERIE == SF2->F2_SERIE
			
			//Acumular o Peso Liquido
			_nPLiqui := _nPLiqui + (SD2->D2_PESO*SD2->D2_QUANT)
			
			dbSelectArea("SD2")
			SD2->(dbSkip())
		EndDo
	EndIf
	
	dbSelectArea("SD2")
	DbGoTo(_nRecD2)
	
	dbSelectArea("SF2")
	
	_cDoc      := SF2->F2_DOC
	_cSerie    := SF2->F2_SERIE
	_nQtd      := SF2->F2_VOLUME1
	_nPBruto   := SC5->C5_PBRUTO
	_cTransp   := SC5->C5_TRANSP
	_cCodRed   := SC5->C5_REDESP
	_cEspec    := SC5->C5_ESPECI1 
	
	If Empty(_cEspec)
		_cEspec	:=	PadR("CAIXA(S)", Len(_cEspec))
	EndIf
	    //vfv
 	_cNomeRed  := space(30)
	_cPlaca    := space(08)
	_cMarca    := space(20)
	_cMens     := ""
	_cMens1    := space(03)
	_cMens2    := space(03)
	_dDtSaida  := dDataBase
	_cHrSaida  := Time()  
	_cLocEmb   := space(20)
	_cUFEmb    := space(02)  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se necessario alterar as informacoes abaixo                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 150,10 to 420,580 DIALOG JanelaNF TITLE "Digite as Informacaes Necessarias"
	
	@ 012,010 SAY "NOTA FISCAL: "+SF2->F2_DOC	size 80,10
	@ 012,100 SAY "CLIENTE: "+_cNome            size 120,10
	@ 032,010 SAY "Cod. Transp.: "
	@ 032,115 SAY "Redesp: "
	@ 032,205 SAY "Placa: "
	@ 052,010 SAY "Peso Liquido: "
	@ 052,115 SAY "Peso Bruto: "
	@ 072,010 SAY "Qtd: "
	@ 072,115 SAY "Especie: "
	@ 072,205 SAY "Marca: "
	@ 092,010 SAY "Data Saida: "
	//@ 092,115 SAY "Hora: "
	@ 112,010 SAY "Loc. Emb.: "
	@ 112,115 SAY "UF Emb.: "
	
	@ 032,050 GET _cTransp  PICTURE "@!" Valid .t. F3 "SA4" size 40, 10
	@ 032,150 GET _cCodRed  PICTURE "@!" Valid .t. F3 "SA4" size 40, 10
	@ 032,230 GET _cPlaca   PICTURE "@!"                    size 40, 10
	@ 052,050 GET _nPLiqui  PICTURE "@E 99,999.9999"        size 40, 10		//alterado Luciano Lamberti - 21-09-2020 para 4 casas decimais
	@ 052,150 GET _nPBruto  PICTURE "@E 99,999.9999"        size 40, 10		//alterado Luciano Lamberti - 21-09-2020 para 4 casas decimais
	@ 072,050 GET _nQtd     PICTURE "@E 999"                size 40, 10
	@ 072,150 GET _cEspec                                   size 40, 10
	@ 072,230 GET _cMarca   PICTURE "@!15"                  size 40, 10
	@ 092,050 GET _dDtSaida PICTURE "99/99/99"              size 40, 10
	//@ 092,150 GET _cHrSaida PICTURE "99:99:99"              size 40, 10   
	@ 112,050 GET _cLocEmb                                  size 40, 10   
	@ 112,150 GET _cUFEmb                                   size 20, 10
	
	@ 112,230 BMPBUTTON TYPE 1 ACTION Close(JanelaNF)
	ACTIVATE DIALOG JanelaNF CENTERED
	 //vfv
	dbSelectArea("SC5")
	If SC5->(!Eof())
		RecLock("SC5",.f.)
		SC5->C5_TRANSP  := _cTransp
		SC5->C5_REDESP  := _cCodRed
		MsUnLock()
	EndIf
	
  	dbSelectArea("SF2")
	RecLock("SF2", .F.)
	SF2->F2_TRANSP  := _cTransp
	SF2->F2_REDESP  := _cCodRed
	SF2->F2_PLIQUI  := _nPLiqui
	SF2->F2_PBRUTO  := _nPBruto
	SF2->F2_VOLUME1 := _nQtd
	SF2->F2_ESPECI1 := _cEspec
	SF2->F2_ZZMARCA := _cMarca
	SF2->F2_ZZPLACA := _cPlaca
	SF2->F2_ZZDTSAI := _dDtSaida
	//SF2->F2_ZZHRSAI := _cHrSaida   
	SF2->F2_ZZEMB   := _cLocEmb
	SF2->F2_ZZUFEMB := _cUFEmb
	MsUnLock()
EndIf //vfv

CarregaMsg()					// Recupera as mensagens informadas no TES / Produto / Pedido.
CadMen()						// Informacao das Mensagens.

RestArea(_aAreaSF2)
RestArea(_aAreaSD2)
RestArea(_aAreaSA1)
RestArea(_aAreaSA2)
RestArea(_aAreaSC5)
RestArea(_aAreaSB1)
RestArea(_aAreaSF4)
RestArea(_aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CadMen    ³ Autor ³ Fabricio M Vieira     ³ Data ³ 22/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao Utilizado p/ Grava‡ao de Mensagens N.F. de Entrada  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MP10 MSSQL                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CadMen ()

// Declaracao de variaveis:
_lFecha := .t.
@ 127, 015 To 182, 605 Dialog oDlg1 Title OemToAnsi ("Digitacao das mensagems da Nota Fiscal de Saida")
@ 005, 010 Get aCod [1] Picture "@!"  F3 "SM4" Valid ValidMsg ("1")
@ 005, 040 Get aCod [2] Picture "@!"  F3 "SM4" Valid ValidMsg ("2")
@ 005, 070 Get aCod [3] Picture "@!"  F3 "SM4" Valid ValidMsg ("3")
@ 005, 100 Get aCod [4] Picture "@!"  F3 "SM4" Valid ValidMsg ("4")
@ 005, 130 Get aCod [5] Picture "@!"  F3 "SM4" Valid ValidMsg ("5")
@ 005, 160 Get aCod [6] Picture "@!"  F3 "SM4" Valid ValidMsg ("6")
@ 005, 190 Get aCod [7] Picture "@!"  F3 "SM4" Valid ValidMsg ("7")
@ 005, 220 Get aCod [8] Picture "@!"  F3 "SM4" Valid ValidMsg ("8")

@ 01,260 BMPBUTTON TYPE 11 ACTION Edmen (nVar)
@ 15,260 BMPBUTTON TYPE  1 ACTION GravMen ()
Activate Dialog oDlg1

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ValidMsg  ³ Autor ³ Fabricio M Vieira     ³ Data ³ 22/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao Utilizado p/ Direcionar / Edi‡ao de Mensagens.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MP10 MSSQL                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValidMsg (cVar)

nVar := Val(cVar)
lMsg := .T.
ChkMsg(nVar)

Return (lMsg)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ChkMsg    ³ Autor ³ Fabricio M Vieira     ³ Data ³ 22/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao Utilizado p/ Verifica‡ao se existe a mensagem.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MP10 MSSQL                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ChkMsg (nVar)

If !Empty (aCod [nVar])
	If Empty (Formula (aCod [nVar]))
		MsgBox ("Mensagem nao cadastrada, ou com conteudo vazio." + chr (13) + "Verifique o Cadastro de Mensagens.", "Atencao !!!", "STOP")
		lMsg := .F.
	EndIf
EndIf
Return (.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Edmen     ³ Autor ³ Fabricio M Vieira     ³ Data ³ 22/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao Utilizado p/ Editar as Mensagens N.F. de Saida.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MP10 MSSQL                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Edmen (nVar)

If !empty(aCod [nVar])
	if empty(aMsg [nVar])
		cCod  := aCod [nVar]
		cMsg  := Formula (cCod) + Space (500 - Len (Formula (cCod)))
		
		cLin1 := Substr (cMsg, 001, 250)
		cLin2 := Substr (cMsg, 251, 250)
	else
		cLin1 := PadR (Substr (aMsg [nVar], 001, 250), 250, " ")
		cLin2 := PadR (Substr (aMsg [nVar], 251, 250), 250, " ")
	endif
	
	@ 200, 010 To 295,580 Dialog oDlg2 Title OemToAnsi ("Edicao de Mensagens")
	@ 010, 002 Say OemToAnsi ("Lin1")
	@ 024, 002 Say OemToAnsi ("Lin2")
	@ 010, 015 Get cLin1 Valid .T. SIZE 210, 040
	@ 024, 015 Get cLin2 Valid .T. SIZE 210, 040
	@ 010, 235 BMPBUTTON TYPE 01 ACTION MontaMsg ()
	@ 024, 235 BMPBUTTON TYPE 02 ACTION LimpaMsg ()
	Activate Dialog oDlg2
Else
	MsgStop ("Codigo da mensagem esta em branco.")
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MontaMsg  ³ Autor ³ Fabricio M Vieira     ³ Data ³ 22/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao Utilizado p/ Concatenar Mensagens.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MP10 MSSQL                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MontaMsg ()

aMsg [nVar] := alltrim (cLin1) + " " + alltrim (cLin2)	//
Close (oDlg2)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³LimpaMsg  ³ Autor ³ Fabricio M Vieira     ³ Data ³ 22/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao Utilizado p/ Limpar Mensagens.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MP10 MSSQL                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function LimpaMsg ()

aMsg[nVar] := space(500)
Close(oDlg2)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GravMen   ³ Autor ³ Fabricio M Vieira     ³ Data ³ 22/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao Utilizado p/ Gravacao de Mensagens N.F. de Saida.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MP10 MSSQL                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GravMen ()

Local _nLinGrv :=  nK := _nX := _nSeq := 0
Local _cTexto  := space (500)

For nK := 1 To 8
	If !Empty(aCod[nK])
		_cTexto	:= Alltrim(Formula(aCod[nK]))
		
		If !Empty(aMsg[nK])
			_cTexto	:= Alltrim(aMsg[nK])
		Endif
		
		_nLinGrv := MlCount(_cTexto, 250)
		
		dbSelectArea ("SZZ")
		for _nX := 1 to _nLinGrv
			_nSeq ++
			RecLock("SZZ", .T.)
			SZZ->ZZ_FILIAL	:= xFilial("SZZ")
			SZZ->ZZ_TIPODOC	:= "S"							// Nota Fiscal de Saida
			SZZ->ZZ_DOC		:= SF2->F2_DOC
			SZZ->ZZ_SERIE	:= SF2->F2_SERIE
			SZZ->ZZ_CLIFOR	:= SF2->F2_CLIENTE
			SZZ->ZZ_LOJA	:= SF2->F2_LOJA
			SZZ->ZZ_SEQMENS	:= StrZero(_nSeq, 2)
			SZZ->ZZ_CODMENS	:= aCod[nK]
			SZZ->ZZ_TXTMENS := MemoLine(_cTexto, 250, _nX)
			MsUnlock()
		Next
	Endif
Next
If _lFecha
	Close(oDlg1)
endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CarregaMsg³ Autor ³ Fabricio M Vieira     ³ Data ³ 22/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao Utilizado p/ Recuperar e Permitir a edicao de       ³±±
±±³          ³ mensagens informadas no TES, nos Produtos e no Pedido.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MP10 MSSQL                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CarregaMsg ()

Local _nCont    := 1		// Variavel para controlar o limite de mensagens a ser exibida na tela de selecao.
Local _aNFOri   := {}
//Local _cResto	:= ""
//Local _cVlr   := ""
Local _cTotal 	:= ""
//Local _nReg   := _nResto := 0
Local _cEmissao := ""
Local _cChave   := space(11)
Local _cQtdLib  := _cUnid  := _cSCMen := ""
Local _cMens := ""
Local _nI 		:= 0

SC5->(dbSetOrder (1))

dbSelectArea("SD2")
dbSetOrder (3)
dbSeek (xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)

Do While ! eof () .and. SD2->D2_FILIAL == SF2->F2_FILIAL .and.;
	SD2->D2_DOC    == SF2->F2_DOC .and.;
	SD2->D2_SERIE  == SF2->F2_SERIE .and.;
	SD2->D2_CLIENTE == SF2->F2_CLIENTE .and.;
	SD2->D2_LOJA   == SF2->F2_LOJA
	
	// Recupera Mensagem Padrao no Pedido de Venda.
	SC5->(dbSeek (xFilial ("SC5") + SD2->D2_PEDIDO))
	_nTem := aScan (aCod, SC5->C5_MENPAD)
	if _nTem == 0
		if _nCont <= 8
			aCod [_nCont] := SC5->C5_MENPAD
			_nCont := _nCont + 1
		endif
	endif
	
	// Recupera Mensagem Padrao no Produto.
	SB1->(dbSeek (xFilial ("SB1") + SD2->D2_COD))
	_nTem := aScan (aCod, SB1->B1_ZZMEN1)
	if _nTem == 0
		if _nCont <= 8
			aCod [_nCont] := SB1->B1_ZZMEN1
			_nCont := _nCont + 1
		endif
	endif
	
	// Recupera Mensagem Padrao no TES (3 mensagens).
	SF4->(dbSeek (xFilial ("SF4") + SD2->D2_TES))
	_nTem := aScan (aCod, SF4->F4_ZZMEN1)
	if _nTem == 0
		if _nCont <= 8
			aCod [_nCont] := SF4->F4_ZZMEN1
			_nCont := _nCont + 1
		endif
	endif
	
	_nTem := aScan (aCod, SF4->F4_ZZMEN2)
	if _nTem == 0
		if _nCont <= 8
			aCod [_nCont] := SF4->F4_ZZMEN2
			_nCont := _nCont + 1
		endif
	endif
	
	_nTem := aScan (aCod, SF4->F4_ZZMEN3)
	if _nTem == 0
		if _nCont <= 8
			aCod [_nCont] := SF4->F4_ZZMEN3
			_nCont := _nCont + 1
		endif
	endif
	
	If !Empty(SD2->D2_NFORI)
		_cQtdLib := _cUnid := _cSCMen := ""
		
		//Posiciona no SC6 - Pedido Venda para buscar o conteudo do campo
		//C6_RKMEN (nome produto+num cliente PS), especifico do Cliente - RMK
		dbSelectArea("SC6")
		dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
		If Found()
			_cUnid   := SC6->C6_UM
			_cSCMen := ""  //espaco para mensagem do item ou complemento da descricao
		EndIf
		
		//Posiciona no SC9 - Pedido Liberados para verificar a Qtd liberada
		//do Produto, que devera ser informada na mensagem de retorno de benefic.
		
		dbSelectArea("SC9")
		dbSeek(xFilial("SC9")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
		If Found()
			Do While !eof() .and. SC9->C9_PEDIDO==SD2->D2_PEDIDO .and. SC9->C9_ITEM == SD2->D2_ITEMPV
				If SC9->C9_NFISCAL+SC9->C9_SERIENF == SD2->D2_DOC+SD2->D2_SERIE
					_cQtdLib := Transform(SC9->C9_QTDLIB,'@E 99,999.99')
				EndIf
				dbSkip()
			EndDo
		EndIf
		
		//Posiciona no SF1/SD1 - NF Entrada - dados da nota fiscal original
		dbSelectArea("SF1")
		dbSeek(xFilial("SF1")+SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA)
		
		_cTotal   := Transform(SD2->D2_TOTAL,"@E 999,999,999.99")
		_cEmissao := SubStr(DtoS(SF1->F1_EMISSAO),7,2)+'/'+;
		SubStr(DtoS(SF1->F1_EMISSAO),5,2)+'/'+;
		SubStr(DtoS(SF1->F1_EMISSAO),1,4)
		
		//Adiciona em Array dados referente a NF
		_cChave := SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_ITEMORI
		nP  := ASCAN(_aNFori,{|X|Substr(X[1],1,11)==_cChave} )
		
		If nP == 0
			AADD(_aNFOri,{ SD2->D2_NFORI   ,;            //1a. NF Original
			SD2->D2_SERIORI ,;            //2a. Serie NF Original
			SD2->D2_ITEMORI ,;            //3a. Item NF Original
			_cTotal         ,;            //4a. Total
			_cEmissao       ,;            //5a. Data Emissao NF Original
			_cSCMen        ,;             //6a. Mensagem - SC6
			_cQtdLib        ,;            //7a. Qtd Liberada - SC9
			_cUnid  } )                   //8a. Unidade Medida - SC6
		EndIf
		
		dbSelectArea("SD2")
		
	EndIf
	SD2->(dbSkip ())
EndDo

If Len(_aNFori) >= 1
	For _nI := 1 To LEn (_aNFori)
		_cMens := _cMens+If(!Empty(_aNFori[_nI,6]),_aNFori[_nI,6]+" - ","")+;
		"referente s/ NF "+_aNFori[_nI,1]+" de "+_aNFori[_nI,5]+;
		" no valor de R$"+_aNFori[_nI,4]+" ("+_aNFori[_nI,7]+;
		" "+_aNFori[_nI,8]+"), "
	Next
EndIf

Return
