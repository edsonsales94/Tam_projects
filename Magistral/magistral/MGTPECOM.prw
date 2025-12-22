#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#include "ap5mail.ch"

#define PAD_LEFT          0
#define PAD_RIGHT         1
#define PAD_CENTE         2

#DEFINE IMP_SPOOL 2

#DEFINE VBOX       080
#DEFINE HMARGEM    030
#DEFINE VMARGEM    030

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TRPPECOM   ³ Autor ³ TOTVS TRP           ³ Data ³ 18/10/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pedido de Compras e Autorizacao de Entrega- Grafico        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaCOM                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data  	³Solic.³  Motivo da Alteracao 			          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß


=====================
CRIAR CAMPOS
===========================================================================================================================================
Campo:     Tp Tam/Dec Cont. Propr	Titulo	        Lista Opcao  Help Uso InicPad Formato Obg  Brw  VldUser   F3  Ini.Brw
-------------------------------------------------------------------------------------------------------------------------------------------
C7_X_TPFRE C   01/00  R     A     Tp Frete Com   C=CIF;F=FOB       S                        S
C7_X_TRANS C   06/00  R     A     Transp Compr                     S                        S    (1)       SA4

(1) vazio() .or. existcpo("SA4")                                                                                                    

==========================
CRIAR PARAMETROS
==========================
Nome Var    Tipo  Descricao                                                            Exemplo
-----------------------------------------------------------------------------------------------
MV_X_LOGPV  C     INforme o arquivo do logo                                            logo.bmp
MV_X_TRPEC  C     Informe se os dados do Cabeçalho serão da filial logada ou           L
                  filial de entrega. Ex: L=Logada E=Entrega 


*/
User Function MGTPECOM(cAlias,nReg,nOpc)
	Local aArea     := GetArea()
	Local cTitulo   := "Emissao dos Pedidos de Compras ou Autorizacoes de Entrega"
	Local lRet      := .F.

	LOCAL cPathTmp  := GETTEMPPATH()
	LOCAL cNumPed   := ""
	LOCAL cAnexos   := ""

	PUBLIC cChaveSA2 := ""

	Default cAlias	:= 'SC7' 		//paramixb[1]
	Default nReg	:= RECNO() 		//paramixb[2]
	Default nOpc	:= 1  			//paramixb[3]

	PRIVATE lAuto    := (nReg!=Nil)
	PRIVATE cFilSC7		:= xFilial("SC7")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomArq := "com_" + Alltrim(SC7->C7_NUM) + ".pdf"
	cNumPed := Alltrim(SC7->C7_NUM)

//Exclui arquivo ja gerado anteriormente
	FErase(cPathTmp + cNomArq)

	oPrn   := FWMSPrinter():New(cNomArq, IMP_PDF, .F., cPathTmp, .T.)
	oPrn:SetResolution(78) //Tamanho estipulado para a Danfe
	oPrn:SetLandScape()//oPrn:SetPortrait()
	oPrn:SetPaperSize(DMPAPER_A4)
	oPrn:SetMargin(60,60,60,60)
	oPrn:nDevice := IMP_PDF
// ----------------------------------------------
// Define para salvar o PDF
// ----------------------------------------------
	oPrn:cPathPDF := cPathTmp

	RptStatus({|| lRet := RunReport(cTitulo,cAlias,nReg,nOpc) },cTitulo)

	If !lRet
		MsgStop("Nenhum registro encontrado para impressão", "Impressao Pedido Compra")

	Else
		oPrn:Preview()//Visualiza antes de imprimir

		cListMail := Alltrim(Posicione("SA2",1,cChaveSA2,"A2_EMAIL"))
		cAnexos   := oPrn:cPathPDF+cNomArq


		PswOrder(1)
		PswSeek(__CUSERID,.T.)
		aUsuario  := PSWRET(1)
		cMailUser := Alltrim(aUsuario[1][14])

		cAssunto  := AllTrim(SM0->M0_NOMECOM) + " - PEDIDO COMPRA: " + cNumPed
		cMensagem := "Segue Pedido de Compra anexo."+ "<BR>"+;
			"<BR>"+;
			"Favor confirmar o recebimento e aceite do mesmo." + "<BR>"+;
			"<BR>"+;
			"Contato: "+ AllTrim(aUsuario[1][4]) + "<BR>"+;
			"Email:" +  cMailUser + "<BR>"+;
			"<BR>"+;
			"<BR>"+;
			"<BR>"+;
			AllTrim(SM0->M0_NOMECOM) +"<BR>" +;
			Alltrim(SM0->M0_ENDCOB) + "<BR>" +;
			Alltrim(SM0->M0_CIDCOB) + "/" + UPPER(alltrim(SM0->M0_ESTCOB)) + "<BR>" +;
			"CEP:" + TRANSFORM(SM0->M0_CEPCOB,"@R 99999-999") +"<BR>"+;
			"Fone: " + Alltrim(SM0->M0_TEL) +"<BR><BR>"+; //"       e-mail: " + cEmail +"<BR>" +;
			"CNPJ: " + transform(SM0->M0_CGC,"@R 99.999.999/9999-99") + "<BR> I.E.:" + SM0->M0_INSC

		//            MailTo    Cc        Bcc                                       From          MostraTela
		//  If U_NewSMail(cListMail,cMailUser,cMailUser,cAssunto,cMensagem,cAnexos,,,,,,cMailUser,,,,,.T.)
		//   HS_MsgInf("E-mail(s) enviado(s) com sucesso","Confirmação","Envio E-mail")
		//  EndIf
	EndIf

	FreeObj(oPrn)
	oPrn := Nil

	RestArea(aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RunReport ºAutor  ³Daniel Peixoto      º Data ³  13/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de impressao                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunReport(cTitulo,cAlias,nReg,nOpc)
	Local aRecnoSave  	:= {}
	Local aPedido     	:= {}
	Local aPedMail    	:= {}

	Local cNumSC7    	:= Len(SC7->C7_NUM)
	Local cFiltro    	:= ""
	Local cCondBus   	:= ""
	Local cMensagem  	:= ""
	Local cVar       	:= ""

	Local nRecnoSC7  	:= 0
	Local nX         	:= 0
	Local nVias      	:= 0
	Local nLinObs    	:= 0
	Local nOrder     	:= 1
	Local lImpri     	:= .F.
	Local lPrimeiraUnid := .F.
	Local lSegundaUnid	:= .F.
	Local nCont	      	:= 0
	LOCAL aPergs 		:= {}

	Private cEmailForn  := ""
	Private lLiber      := .F.
	Private lNewAlc	  	:= .F.
	Private cDescPro  	:= ""
	Private cOPCC     	:= ""
	Private	nVlUnitSC7	:= 0
	Private nValTotSC7	:= 0

	Private cObs01    	:= ""
	Private cObs02    	:= ""
	Private cObs03    	:= ""
	Private cObs04    	:= ""
	Private cBitmap 	:= R110ALogo()
	Private cLogo     	:= GetSrvProfString('Startpath','') + cBitmap

	Private nLinI      := 000
	Private nCol       := 000
	Private nSalto     := 010
	Private oFont06	   := TFontEx():New(oPrn,"Courier New",06,06,.F.,.T.,.F.)//
	Private oFont06n   := TFontEx():New(oPrn,"Courier New",06,06,.T.,.T.,.F.)//Negrito
	Private oFont07	   := TFontEx():New(oPrn,"Courier New",07,07,.F.,.T.,.F.)//
	Private oFont07n   := TFontEx():New(oPrn,"Courier New",07,07,.T.,.T.,.F.)//Negrito
	Private oFont08	   := TFontEx():New(oPrn,"Courier New",08,08,.F.,.T.,.F.)//
	Private oFont08n   := TFontEx():New(oPrn,"Courier New",08,08,.T.,.T.,.F.)//Negrito
	Private oFont09	   := TFontEx():New(oPrn,"Courier New",09,09,.F.,.T.,.F.)//
	Private oFont09n   := TFontEx():New(oPrn,"Courier New",09,09,.T.,.T.,.F.)//Negrito
	Private oFont10	   := TFontEx():New(oPrn,"Courier New",10,10,.F.,.T.,.F.)//
	PRIVATE oFont10N   := TFontEx():New(oPrn,"Courier New",10,10,.T.,.T.,.F.)//Negrito
	Private oFont11n   := TFontEx():New(oPrn,"Courier New",11,11,.T.,.T.,.F.)//Negrito
	Private oFont12    := TFontEx():New(oPrn,"Courier New",12,12,.F.,.T.,.F.)//
	Private oFont12n   := TFontEx():New(oPrn,"Courier New",12,12,.T.,.T.,.F.)//Negrito
	Private oFont16n   := TFontEx():New(oPrn,"Courier New",16,16,.T.,.T.,.F.)//Negrito
	Private oBrush     := TBrush():New( , RGB( 200, 200, 200 ) )  // Cinza

	Private m_pag      := 0
	Private nVia       := 0
	Private nPagina    := 0

	Private nLinMax   := 600  // 3168 / 10 = 316 linhas
	Private nColMax   := 920  // 2400 / 4  = 600 colunas
	Private nItens1P  := 23 //Nro de produtos 1 pagina
	Private nItens2P  := 54 //Nro de produtos 2 pagina em diante
	Private nTotItens := 0, nNroItens := 0

	Private cRegra    := SuperGetMV("MV_ARRPEDC",.F.,"")
	Private nTamTot       := TamSX3("C7_PRECO")[2]

	If Type("lPedido") != "L"
		lPedido := .F.
	Endif


	aAdd(aPergs,{3,"Imprimir na: ",1,{'1° Unid de medida','2° Unid de medida'},100,'',.F.})


	If ParamBox(aPergs, "Informe os parâmetros")
		if MV_PAR01==1
			lPrimeiraUnid := .T.
		elseif MV_PAR01==2
			lSegundaUnid := .T.
		EndIF
	EndIf

	dbSelectArea("SC7")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01               Do Pedido                             ³
//³ mv_par02               Ate o Pedido                          ³
//³ mv_par03               A partir da data de emissao           ³
//³ mv_par04               Ate a data de emissao                 ³
//³ mv_par05               Somente os Novos                      ³
//³ mv_par06               Campo Descricao do Produto      	     ³
//³ mv_par07               Unidade de Medida:Primaria ou Secund. ³
//³ mv_par08               Imprime ? Pedido Compra ou Aut. Entreg³
//³ mv_par09               Numero de vias                        ³
//³ mv_par10               Pedidos ? Liberados Bloqueados Ambos  ³
//³ mv_par11               Impr. SC's Firmes, Previstas ou Ambas ³
//³ mv_par12               Qual a Moeda ?                        ³
//³ mv_par13               Endereco de Entrega                   ³
//³ mv_par14               todas ou em aberto ou atendidos       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If lAuto
		Pergunte("MTR110",.F.)
		dbSelectArea("SC7")
		//dbGoto(nReg)
		mv_par01 := SC7->C7_NUM
		mv_par02 := SC7->C7_NUM
		mv_par03 := SC7->C7_EMISSAO
		mv_par04 := SC7->C7_EMISSAO
		mv_par08 := 1
		mv_par09 := 1
	Else
		Pergunte("MTR110",.T.)
	EndIf

	If lPedido
		mv_par12 := MAX(SC7->C7_MOEDA,1)
	Endif

	If SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3
		If ( cPaisLoc$"ARG|POR|EUA" )
			cCondBus := "1"+StrZero(Val(mv_par01),6)
			nOrder	 := 10
		Else
			cCondBus := mv_par01
			nOrder	 := 1
		EndIf
	Else
		cCondBus := "2"+StrZero(Val(mv_par01),6)
		nOrder	 := 10
	EndIf

	If mv_par14 == 2
		cFiltro := "SC7->C7_QUANT-SC7->C7_QUJE <= 0 .Or. !EMPTY(SC7->C7_RESIDUO)"
	Elseif mv_par14 == 3
		cFiltro := "SC7->C7_QUANT > SC7->C7_QUJE"
	EndIf

	dbSelectArea("SC7")
	dbSetOrder(nOrder)
	dbSeek(xFilial("SC7")+cCondBus,.T.)

	cNumSC7 := SC7->C7_NUM

	While !SC7->(Eof()) .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM >= mv_par01 .And. SC7->C7_NUM <= mv_par02

		// (SC7->C7_CONAPRO <> "B" .And. mv_par10 == 2) .Or.;
			// (SC7->C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
			If (SC7->C7_EMITIDO == "S" .And. mv_par05 == 1) .Or.;
				((SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)) .Or.;
				((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3) .And. mv_par08 == 2) .Or.;
				(SC7->C7_TIPO == 2 .And. (mv_par08 == 1 .OR. mv_par08 == 3)) .Or. !MtrAValOP(mv_par11, "SC7") .Or.;
				(SC7->C7_QUANT > SC7->C7_QUJE .And. mv_par14 == 3) .Or.;
				((SC7->C7_QUANT - SC7->C7_QUJE <= 0 .Or. !Empty(SC7->C7_RESIDUO)) .And. mv_par14 == 2 )

			dbSelectArea("SC7")
			dbSkip()
			Loop
		Endif

		MaFisEnd()
		&("StaticCall(MATR110, R110FIniPC, SC7->C7_NUM,,,cFiltro)") //R110FIniPC(SC7->C7_NUM,,,cFiltro)
		If !Empty(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_EMAIL"))
			cEmailForn := (Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_EMAIL"))
		Endif

		cObs01    := " "
		cObs02    := " "
		cObs03    := " "
		cObs04    := " "
		cObse01    := "-APOS FATURAMENTO ENVIAR COPIA DA NOTA FISCAL E BOLETO POR EMAIL: CONTAS.PAGAR@MAGISTRAL.COM.BR "
		cObse02    := "-PROIBIDO A NEGOCIACAO DE TITULO DECORRENTE DESTE NEGOCIO JURIDICO EM FACTORINGS E SIMILARES. "
		cObse03    := "-HONORARIO DE RECEBIMENTO DE MERCADORIAS DE SEGUNDA A QUINTA-FEIRA DE 08:00HS AS 16:00HS E NA SEXTA-FEIRA DE 08:00HS A 15:00HS. "
		cObse04    := "-EMISSÃO DE NOTAS FISCAIS DE SERVICOS ATE DIA 25 DE CADA MES. "
		cObse05    := "-RECEBIMENTO E FATURAMENTO DE MERCADORIAS ATE DIA 27 DE CADA MES. "
		cObse06    := "-NUMERO DA ORDEM DE COMPRAS DEVE VIR DESCRITO NA NOTA FISCAL OBRIGATORIAMENTE. "
		cObsPed   := " "

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Roda a impressao conforme o numero de vias informado no mv_par09 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAreaOld  := GetArea()
		For nVias := 1 to mv_par09
			RestArea(aAreaOld)
			nVia := nVias
			nPagina  := 1
			nPrinted := 0
			nLPrinted:= 0
			nLinI    := 0
			nTotal   := 0
			nTotMerc := 0
			nDescProd:= 0
			nLinObs  := 0
			nRecnoSC7:= SC7->(Recno())
			cNumSC7  := SC7->C7_NUM
			aPedido  := {SC7->C7_FILIAL,SC7->C7_NUM,SC7->C7_EMISSAO,SC7->C7_FORNECE,SC7->C7_LOJA,SC7->C7_TIPO}
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Dispara a cabec especifica do relatorio.                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrn:EndPage()
			oPrn:StartPage()

			CabecPCxAE()

			CabecItens()

			IncLin(09)

			nTotItens := 0
			While !SC7->(Eof()) .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM == cNumSC7
				//  (SC7->C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
					// 		(SC7->C7_CONAPRO <> "B" .And. mv_par10 == 2) .Or.;
					If	(SC7->C7_EMITIDO == "S" .And. mv_par05 == 1) .Or.;
						((SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)) .Or.;
						((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3) .And. mv_par08 == 2) .Or.;
						(SC7->C7_TIPO == 2 .And. (mv_par08 == 1 .OR. mv_par08 == 3)) .Or. !MtrAValOP(mv_par11, "SC7") .Or.;
						(SC7->C7_QUANT > SC7->C7_QUJE .And. mv_par14 == 3) .Or.;
						((SC7->C7_QUANT - SC7->C7_QUJE <= 0 .Or. !Empty(SC7->C7_RESIDUO)) .And. mv_par14 == 2 )
					dbSelectArea("SC7")
					dbSkip()
					Loop
				Endif

				nTotal += SC7->C7_TOTAL
				nTotItens++

				dbSelectArea("SC7")
				dbSkip()
			EndDo
			RestArea(aAreaOld)

			nNroItens := nTotItens

			While !SC7->(Eof()) .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM == cNumSC7
				// (SC7->C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
					// 	SC7->C7_CONAPRO <> "B" .And. mv_par10 == 2) .Or.;

				If 	(SC7->C7_EMITIDO == "S" .And. mv_par05 == 1) .Or.;
						((SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)) .Or.;
						((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3) .And. mv_par08 == 2) .Or.;
						(SC7->C7_TIPO == 2 .And. (mv_par08 == 1 .OR. mv_par08 == 3)) .Or. !MtrAValOP(mv_par11, "SC7") .Or.;
						(SC7->C7_QUANT > SC7->C7_QUJE .And. mv_par14 == 3) .Or.;
						((SC7->C7_QUANT - SC7->C7_QUJE <= 0 .Or. !Empty(SC7->C7_RESIDUO)) .And. mv_par14 == 2 )
					dbSelectArea("SC7")
					dbSkip()
					Loop
				Endif

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Salva os Recnos do SC7 no aRecnoSave para marcar reimpressao.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Ascan(aRecnoSave,SC7->(Recno())) == 0
					AADD(aRecnoSave,SC7->(Recno()))
				Endif

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializa o descricao do Produto conf. parametro digitado.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cDescPro :=  ""
				If Empty(mv_par06)
					mv_par06 := "B1_DESC"
				EndIf

				If AllTrim(mv_par06) == "B1_DESC"
					SB1->(dbSetOrder(1))
					SB1->(dbSeek( xFilial("SB1") + SC7->C7_PRODUTO ))
					cDescPro := SB1->B1_DESC
				ElseIf AllTrim(mv_par06) == "B5_CEME"
					SB5->(dbSetOrder(1))
					If SB5->(dbSeek( xFilial("SB5") + SC7->C7_PRODUTO ))
						cDescPro := SB5->B5_CEME
					EndIf
				ElseIf AllTrim(mv_par06) == "C7_DESCRI"
					cDescPro := SC7->C7_DESCRI
				EndIf

				If Empty(cDescPro)
					SB1->(dbSetOrder(1))
					SB1->(dbSeek( xFilial("SB1") + SC7->C7_PRODUTO ))
					cDescPro := SB1->B1_DESC
				EndIf

				SA5->(dbSetOrder(1))
				If SA5->(dbSeek(xFilial("SA5")+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO)) .And. !Empty(SA5->A5_CODPRF)
					cDescPro := ALLTRIM(cDescPro) + " ("+Alltrim(SA5->A5_CODPRF)+")"
				EndIf

				If SC7->C7_DESC1 != 0 .Or. SC7->C7_DESC2 != 0 .Or. SC7->C7_DESC3 != 0
					nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
				Else
					nDescProd+=SC7->C7_VLDESC
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializacao da Observacao do Pedido.                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cObs := SC7->C7_OBS
				If !Empty(cObs) .And. nLinObs < 5
					nLinObs++
					cVar:="cObs"+StrZero(nLinObs,2)
					Eval(MemVarBlock(cVar),cObs)
				Endif

				/*
				If !Empty(SC7->C7_OBSPEDI)
					For nCont := 1 to MLCount(SC7->C7_OBSPEDI, 83)
						If !Empty(MemoLine(SC7->C7_OBSPEDI, 83, nCont))
							cObsPed += IIF(!Empty(cObsPed), "  ", "") + MemoLine(SC7->C7_OBSPEDI, 83, nCont)
						EndIf 
					Next
				EndIf
				*/	
				nTxMoeda   := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil)
				nValTotSC7 := xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda)

				nTotMerc   := MaFisRet(,"NF_TOTAL")

				// nVlUnitSC7 := xMoeda((SC7->C7_TOTAL/SC7->C7_QUANT),SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda)
				nVlUnitSC7 := xMoeda((SC7->C7_PRECO),SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda)
				nVlSegUnitSC7 := xMoeda((SC7->C7_TOTAL/SC7->C7_QUANT) * (C7_QUANT / SC7->C7_QTSEGUM ),SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda)

				If mv_par08 == 2 //AE
					If !Empty(SC7->C7_OP)
						cOPCC := "OP " + " " + SC7->C7_OP
					ElseIf !Empty(SC7->C7_CC)
						cOPCC := "CC " + " " + SC7->C7_CC
					EndIf
				EndIf

				cCodPro := AllTrim(SC7->C7_PRODUTO)
				/*
					Alterado por Edson Sales
					Para MAgitral.
					Data 30/12/2024
				*/
				// se for primeira ou segunda unidade de medida
				If lPrimeiraUnid
					cUnd := SC7->C7_UM
					cQuant := Transform(SC7->C7_QUANT, "@E 9,999,999.99")
					nVlrUnitario := Transform(nVlUnitSC7, "@E 999,999,999.99")
					nVlrTotal := Transform(nValTotSC7, "@E 999,999,999.99")
				elseif lSegundaUnid
					cUnd := SC7->C7_SEGUM
					cQuant := Transform(SC7->C7_QTSEGUM, "@E 9,999,999.99")
					nVlrUnitario := Transform(nVlSegUnitSC7, "@E 999,999,999.99")//Transform(nVlUnitSC7, "@E 999,999,999.99")
					nVlrTotal := Transform(nValTotSC7, "@E 999,999,999.99")

					if Empty(cUnd)
						FWAlertWarning('O Produto ' +cCodPro+ ' não possui 2° unidade de medida','Atenção!!! Não imprimir')
						Return
					endif
				EndIF

				//{"Item", "Produto", "Descrição","UM", "Quantidade", "Valor Unitario", "Valor Total","Dt. Faturamento" ,"Dt. Entr." , "OC"}
				ImpDet({SC7->C7_ITEM, SUBSTR(cCodPro, 1, 16), SUBSTR(cDescPro,1,60), cUnd, cQuant,nVlrUnitario, nVlrTotal,;
					DTOC(SC7->C7_EMISSAO),DTOC(SC7->C7_DATPRF), IIf(mv_par08 == 1, SC7->C7_NUMSC, cOPCC)}, oFont09:oFont,, 010)
				IncLin(09, "I")
				nPrinted ++
				nLPrinted++

				cDescPro := SUBSTR(cDescPro,61)
				cCodPro  := SUBSTR(cCodPro,17)
				While !Empty(cDescPro) .Or. !Empty(cCodPro)
					ImpDet({"", SUBSTR(cCodPro, 1, 16), SUBSTR(cDescPro,1,60), "", "", "","", "", "", "", ""}, oFont09:oFont,, 010)
					IncLin(09, "I")
					nLPrinted ++
					cDescPro := SUBSTR(cDescPro,61)
					cCodPro  := SUBSTR(cCodPro,17)
				EndDo

				cMensagem:= Alltrim(Formula(SC7->C7_MSG))
				If !Empty(cMensagem)
					ImpDet({"", "", cMensagem, "", "", "","", "", "", "", ""}, oFont09:oFont,, 010)
					IncLin(09, "I")
					nLPrinted++
				Endif

				//Se Itens couber 1 pagina imprime rodape
				If nPagina == 1
					If nLPrinted >= nItens1P .Or. nPrinted >= nNroItens
						For nCont := nLPrinted+1 To nItens1P
							ImpDet({"", "", "", "", "", "","", "", "", "", ""}, oFont09:oFont,, 010)
							IncLin(09, "I")
							nLPrinted++
						Next

						oPrn:Line(nLinI+002,nCol, nLinI+002, nColMax-050)

						nTotItens -= nPrinted
						nPrinted  := 0
						nLPrinted := 0

						ImpRodaPe()
						oPrn:EndPage()

						If nTotItens > 0
							oPrn:StartPage()
							nLinI := 0
							nPagina++
							CabecPCxAE()
							CabecItens()
							IncLin(09)
						EndIf
					EndIf

				ElseIf nLPrinted >= nItens2P
					nTotItens -= nItens2P
					nPrinted  := 0
					nLPrinted := 0
				EndIf

				lImpri  := .T.
				dbSelectArea("SC7")
				dbSkip()
			EndDo

			SC7->(dbGoto(nRecnoSC7))
		Next nVias

		If nPagina > 1 .And. nTotItens <= nItens2P
			For nCont := nLPrinted+1 To nItens2P
				ImpDet({"", "", "", "", "", "","", "", "", "", ""}, oFont09:oFont,, 010)
				IncLin(09, "I")
			Next
			oPrn:Line(nLinI+002,nCol, nLinI+002, nColMax-050)
		EndIf

		MaFisEnd()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava no SC7 as Reemissoes e atualiza o Flag de impressao.   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SC7")
		If Len(aRecnoSave) > 0
			For nX :=1 to Len(aRecnoSave)
				dbGoto(aRecnoSave[nX])
				RecLock("SC7",.F.)
				SC7->C7_QTDREEM := (SC7->C7_QTDREEM + 1)
				SC7->C7_EMITIDO := "S"
				MsUnLock()
			Next nX
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Reposiciona o SC7 com base no ultimo elemento do aRecnoSave. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbGoto(aRecnoSave[Len(aRecnoSave)])
		Endif

		Aadd(aPedMail,aPedido)

		aRecnoSave := {}

		dbSelectArea("SC7")
		dbSkip()

	EndDo

	dbSelectArea("SC7")
	dbClearFilter()
	dbSetOrder(1)


Return(nNroItens>0)

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³CabecPCxAE³ Autor ³Daniel Peixoto         ³Data  ³13/12/2011³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Emissao do Pedido de Compras / Autorizacao de Entrega      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ CabecPCxAE(ExpO1,ExpO2,ExpN1,ExpN2)                        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                             	              ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³Nenhum                                                      ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CabecPCxAE()
	Local cMoeda := IIf( mv_par12 < 10 , Str(mv_par12,1) , Str(mv_par12,2) )

	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA))

 /*If nPagina > 1
  oPrn:Say(nLinI, nCol, " - continuacao",oFont08:oFont)
 EndIf */  
 
 cChaveSA2 := xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA
 
 //cLogo := lower(GetPvProfString(GetEnvServer(), "STARTPATH", "ADS", GetADV97())) + "lglr01.bmp"  
 aDadEmpC := RDadEmp()
  
 oPrn:Box(nLinI, nCol    , nLinI+100, nCol+310)
 oPrn:Box(nLinI, nCol+315, nLinI+100, nColMax-50)

 If !Empty(cLogo)
  oPrn:SayBitmap(nLinI+010, nCol+040, cLogo, 120, 030)
 EndIf 
 
 IncLin(16)
 oPrn:Say(nLinI, nCol+320, If( mv_par08 == 1 , ("P E D I D O  D E  C O M P R A S"), ("A U T O R I Z A C A O  D E  E N T R E G A") ) + " - " + GetMV("MV_MOEDA"+cMoeda),oFont10N:oFont)
 oPrn:Say(nLinI, nColMax-250, If( mv_par08 == 1 , SC7->C7_NUM, SC7->C7_NUMSC + "/" + SC7->C7_NUM ) + " / Pag. " + Ltrim(Str(nPagina,2)),oFont10N:oFont)

 IncLin(10)
 oPrn:Say(nLinI, nCol+320   , "Data Emissao: " + DTOC(SC7->C7_EMISSAO),oFont10:oFont)
 oPrn:Say(nLinI, nColMax-250, If( SC7->C7_QTDREEM > 0, Str(SC7->C7_QTDREEM+1,2) , "1" ) + "a.Emissao " + Str(nVia,2) + "a.VIA",oFont10:oFont)
 IncLin(10)
 oPrn:Say(nLinI, nCol+320, "Razão Social:" + ALLTRIM(SA2->A2_NOME) + "  "+" Codigo:"+SA2->A2_COD+" "+"Loja:"+SA2->A2_LOJA ,oFont10N:oFont)
 IncLin(10)
 oPrn:Say(nLinI, nCol+320, "CNPJ:"+Transform(SA2->A2_CGC,PesqPict("SA2","A2_CGC")),oFont10N:oFont)
 IncLin(10)
 oPrn:Say(nLinI, nCol+320, "Endereco:" + ALLTRIM(SA2->A2_END)+"  "+"Bairro:"+SA2->A2_BAIRRO,oFont10:oFont)
 IncLin(10)
 oPrn:Say(nLinI, nCol+005, "Empresa:" + Substr(aDadEmpC[01],1,43),oFont10:oFont)
 oPrn:Say(nLinI, nCol+320, "Municipio:"+SA2->A2_MUN+"   "+"Estado:"+SA2->A2_EST+"  "+"CEP:"+SA2->A2_CEP)
 IncLin(10) 
 oPrn:Say(nLinI, nCol+005, "Endereco:" + aDadEmpC[02],oFont10:oFont)
 oPrn:Say(nLinI, nCol+320, "Fone:" + "("+Substr(SA2->A2_DDD,1,3)+") "+Substr(SA2->A2_TEL,1,15) + " "+"FAX:"+"("+Substr(SA2->A2_DDD,1,3)+") "+SubStr(SA2->A2_FAX,1,15)+" "+If( cPaisLoc$"ARG|POR|EUA",space(11) , "Ins. Estad.:" )+If( cPaisLoc$"ARG|POR|EUA",space(18), SA2->A2_INSCR ),oFont10:oFont)
 IncLin(10)
 oPrn:Say(nLinI, nCol+005, Trans(aDadEmpC[03],PesqPict("SA2","A2_CEP"))+Space(2)+"Cidade:" + AllTrim(aDadEmpC[04])+Space(2)+"UF:" + aDadEmpC[05],oFont10:oFont)
 oPrn:Say(nLinI, nCol+320, "Contato:" + AllTrim(SC7->C7_CONTATO)  +Space(10)+ "E-Mail:" + AllTrim(cEmailForn),oFont10:oFont) 
  

 //If !Empty(SA2->A2_X_NUMBC) 
 //   oPrn:Say(nLinI, nCol+598, "Banco: " +  AllTrim(SA2->A2_X_NUMBC) + " Agencia: " + AllTrim(SA2->A2_AGENCIA) + " Conta: " + AllTrim(SA2->A2_NUMCON),oFont10N:oFont)
// EndIf
 
 IncLin(10)
 oPrn:Say(nLinI, nCol+005, "CNPJ:" + Transform(aDadEmpC[06],PesqPict("SA2","A2_CGC")),oFont12N:oFont,,,)
 oPrn:Say(nLinI, nCol+200, "Tel:" + aDadEmpC[07] ,oFont10:oFont) 
 IncLin(10)
// oPrn:Say(nLinI, nCol+005, "Tel:" + SM0->M0_TEL + Space(2) + "FAX:" + SM0->M0_FAX,oFont10:oFont)
/*
  oPrn:Say(nLinI, nCol+320, "Fone Empresa Repres.: " + AllTrim(SA2->A2_TELEREP) + "      Fone Repres.: " + AllTrim(SA2->A2_FONEREP),oFont10:oFont)
 IncLin(10)
 oPrn:Say(nLinI, nCol+005, "CNPJ/CPF:" + Transform(SM0->M0_CGC,PesqPict("SA2","A2_CGC")) + IIf(cPaisLoc == "BRA", " IE:" + InscrEst(), ""),oFont10:oFont)
 oPrn:Say(nLinI, nCol+320, "Cel Repres.: " + AllTrim(SA2->A2_CELREP) + "               E-Mail Repres.: " + AllTrim(SA2->A2_EMAILRP),oFont10:oFont)
 IncLin(10)
*/
Return

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ChkPergUs ³ Autor ³ Nereu Humberto Junior ³ Data ³21/09/07  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Funcao para buscar as perguntas que o usuario nao pode     ³±±
	±±³          ³ alterar para impressao de relatorios direto do browse      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ ChkPergUs(ExpC1,ExpC2,ExpC3)                               ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1 := Id do usuario                                     ³±±
	±±³          ³ ExpC2 := Grupo de perguntas                                ³±±
	±±³          ³ ExpC2 := Numero da sequencia da pergunta                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MatR110                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ChkPergUs(cUserId,cGrupo,cSeq)

	Local aArea  := GetArea()
	Local cRet   := Nil
	Local cParam := "MV_PAR"+cSeq

	dbSelectArea("SXK")
	dbSetOrder(2)
	If dbSeek("U"+cUserId+cGrupo+cSeq)
		If ValType(&cParam) == "C"
			cRet := AllTrim(SXK->XK_CONTEUD)
		ElseIf 	ValType(&cParam) == "N"
			cRet := Val(AllTrim(SXK->XK_CONTEUD))
		ElseIf 	ValType(&cParam) == "D"
			cRet := CTOD((AllTrim(SXK->XK_CONTEUD)))
		Endif
	Endif

	RestArea(aArea)
Return(cRet)

Static Function IncLin(nTamFont, cTipo)
	Default nTamFont := 008
	Default cTipo    := ""

	If nLinI + nTamFont > nLinMax
		If cTipo == "I"
			nLinI += nTamFont
			oPrn:Line(nLinI+001,nCol, nLinI+001, nColMax-050)
		EndIf

		oPrn:EndPage()
		oPrn:StartPage()
		nLinI := 0
		nPagina++
		CabecPCxAE()

		If cTipo == "I"
			CabecItens()
		EndIf
	EndIf

	nLinI += nTamFont

Return()

/*
Alterado por Edson Sales
Para MAgitral.
Data 30/12/2024
*/

Static Function CabecItens()

	If mv_par08 == 1 //Pedido Compras
		ImpDet({"Item", "Produto", "Descrição","UM", "Quantidade", "Valor Unitario", "Valor Total",  "Dt. Faturam.","Dt. prev. Ent.", "OC"}, oFont08N:oFont, .T., 008)
	Else
		ImpDet({"Item", "Produto", "Descrição","UM", "Quantidade", "Valor Unitario",  "Valor Total", "Dt. Entr.", "Num OP ou CC"}, oFont08N:oFont, .T., 008)
	EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpDet    ºAutor  ³Daniel Peixoto      º Data ³  13/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime grid de Itens                                       º±±
±±º          ³                                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
Alterado por Edson Sales
Para MAgitral.
Data 30/12/2024
*/
Static Function ImpDet(aValores, oFontImp, lZebrado, nSalto)
	Default lZebrado := .F.
	Default nSalto   := 008

	If lZebrado
		Zebrado()
	EndIf

	oPrn:Line(nLinI, nCol    , nLinI+nSalto, nCol    ) 	//01
	oPrn:Line(nLinI, nCol+030, nLinI+nSalto, nCol+030)  //02
	oPrn:Line(nLinI, nCol+112, nLinI+nSalto, nCol+112)	//03
	oPrn:Line(nLinI, nCol+390, nLinI+nSalto, nCol+390)	//04
	// oPrn:Line(nLinI, nCol+430, nLinI+nSalto, nCol+430)	//05
	// oPrn:Line(nLinI, nCol+510, nLinI+nSalto, nCol+510)	//06
	oPrn:Line(nLinI, nCol+590, nLinI+nSalto, nCol+590)	//07
	oPrn:Line(nLinI, nCol+670, nLinI+nSalto, nCol+670) 	//08
	oPrn:Line(nLinI, nCol+740, nLinI+nSalto, nCol+740)	//09
	oPrn:Line(nLinI, nCol+820, nLinI+nSalto, nCol+820)	//10
	// oPrn:Line(nLinI, nCol+870, nLinI+nSalto, nCol+870)
	oPrn:Line(nLinI, nColMax-50, nLinI+nSalto, nColMax-50)

	oPrn:Say(nLinI+nSalto, nCol+005, AllTrim(aValores[01]),oFontImp)	//01
	oPrn:Say(nLinI+nSalto, nCol+035, AllTrim(aValores[02]),oFontImp)	//02
	oPrn:Say(nLinI+nSalto, nCol+115, AllTrim(aValores[03]),oFontImp)	//03
	oPrn:Say(nLinI+nSalto, nCol+395, AllTrim(aValores[04]),oFontImp)	//04
	oPrn:Say(nLinI+nSalto, nCol+435, aValores[05],oFontImp)				//05
	oPrn:Say(nLinI+nSalto, nCol+515, aValores[06],oFontImp)				//06
	If lZebrado
		oPrn:Say(nLinI+nSalto, nCol+595, aValores[07],oFontImp)	//07
	Else
		oPrn:Say(nLinI+nSalto, nCol+605, aValores[07],oFontImp)	//07
	EndIF

	oPrn:Say(nLinI+nSalto, nCol+675, aValores[08],oFontImp)						//08 DT FAT
	oPrn:Say(nLinI+nSalto, nCol+745, AllTrim(aValores[09]),oFont11N:oFont,,,)	//09 DT ENTR
	oPrn:Say(nLinI+nSalto, nCol+825, AllTrim(aValores[10]),oFontImp)			//10 OC
Return

// Imprime preenchimento da linha
Static Function Zebrado(nTamFont, nColIni)
	Default nTamFont := 0
	Default nColIni  := nCol
	oPrn:FillRect({nLinI-nTamFont, nColIni, nLinI+nSalto, nColMax-050}, oBrush )
Return(Nil)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpRodaPe ºAutor  ³Danile Peixotoo     º Data ³  14/14/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do RodaPe                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpRodaPe()
	Local nY	:= 0
	Local nX	:= 0
	Local nCont	:= 0
	Local aAprovador:={}

	//Linha inicial do rodape
	nLinI := 330

	oPrn:Box(nLinI, nCol, nLinI+018, nColMax-50)
	IncLin(12)
	oPrn:Say(nLinI, nCol+010, "D E S C O N T O S -->" + " " + ;
		TransForm(SC7->C7_DESC1,"999.99" ) + " %    " + ;
		TransForm(SC7->C7_DESC2,"999.99" ) + " %    " + ;
		TransForm(SC7->C7_DESC3,"999.99" ) + " %    " + ;
		TransForm(xMoeda(nDescProd,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , PesqPict("SC7","C7_VLDESC",14, MV_PAR12) ),oFont09:oFont)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o Arquivo de Empresa SM0.                          ³
	//³ Imprime endereco de entrega do SM0 somente se o MV_PAR13 =" "³
	//³ e o Local de Cobranca :                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SM0->(dbSetOrder(1))
	nRecnoSM0 := SM0->(Recno())
	SM0->(dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT))

	oPrn:Box(nLinI+003, nCol, nLinI+30, nColMax-50)
	IncLin(12)
	If Empty(MV_PAR13) //"Local de Entrega  : "
		oPrn:Say(nLinI, nCol+010, "Local de Entrega  : " + SM0->M0_ENDENT+"  "+SM0->M0_CIDENT+"  - "+SM0->M0_ESTENT+" - "+"CEP :"+" "+Trans(Alltrim(SM0->M0_CEPENT),PesqPict("SA2","A2_CEP")),oFont09:oFont)
	Else
		oPrn:Say(nLinI, nCol+010, "Local de Entrega  : " + mv_par13, oFont09:oFont)
	Endif
	SM0->(dbGoto(nRecnoSM0))
	IncLin(12)
	oPrn:Say(nLinI, nCol+010, "Local de Cobranca : " + SM0->M0_ENDCOB+"  "+SM0->M0_CIDCOB+"  - "+SM0->M0_ESTCOB+" - "+"CEP :"+" "+Trans(Alltrim(SM0->M0_CEPCOB),PesqPict("SA2","A2_CEP")), oFont09:oFont)

	SE4->(dbSetOrder(1))
	SE4->(dbSeek(xFilial("SE4")+SC7->C7_COND))

	oPrn:Box(nLinI+006, nCol    , nLinI+30, 405)
	oPrn:Box(nLinI+006, nCol+405, nLinI+30, nCol+500)
	oPrn:Box(nLinI+006, nCol+500, nLinI+30, nColMax-50)
	IncLin(14)
	oPrn:Say(nLinI    , nCol+010, "Condição de Pagto "+SubStr(SE4->E4_COND,1,40), oFont12N:oFont,,,) //- Alexandre Campos - 08/04/2015

	oPrn:Say(nLinI    , nCol+410, "Data de Emissao", oFont09:oFont)
	oPrn:Say(nLinI    , nCol+550, "Total das Mercadorias : " +" "+ Transform(xMoeda(nTotal,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotal,14,MsDecimais(MV_PAR12)) ), oFont09:oFont)
	IncLin(12)
	oPrn:Say(nLinI    , nCol+010, SubStr(SE4->E4_DESCRI,1,34),  oFont12N:oFont,,,)  //- Alexandre Campos - 08/04/2015

	oPrn:Say(nLinI    , nCol+410, dtoc(SC7->C7_EMISSAO), oFont09:oFont)
	If cPaisLoc<>"BRA"
		aValIVA := MaFisRet(,"NF_VALIMP")
		nValIVA :=0
		If !Empty(aValIVA)
			For nY:=1 to Len(aValIVA)
				nValIVA+=aValIVA[nY]
			Next nY
		EndIf
		oPrn:Say(nLinI, nCol+550, "Total dos Impostos:    "+ "   " + ; //"Total dos Impostos:    "
		Transform(xMoeda(nValIVA,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nValIVA,14,MsDecimais(MV_PAR12)) ), oFont09:oFont)
	Else
		oPrn:Say(nLinI, nCol+550, "Total com Impostos:    "+ "  " + ; //"Total com Impostos:    "
		Transform(xMoeda(nTotMerc,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotMerc,14,MsDecimais(MV_PAR12)) ), oFont09:oFont)
	Endif

	oPrn:Box(nLinI+004, nCol    , nLinI+45, 500)//Reajuste
	oPrn:Box(nLinI+004, nCol+500, nLinI+45, 698) //// 435
	oPrn:Box(nLinI+004, nCol+698, nLinI+45, nColMax-50) ////653
	IncLin(12)

	nTotIpi	  := MaFisRet(,'NF_VALIPI')
	nTotIcms  := MaFisRet(,'NF_VALICM')
	nTotDesp  := MaFisRet(,'NF_DESPESA')
	nTotFrete := MaFisRet(,'NF_FRETE')
	nTotSeguro:= MaFisRet(,'NF_SEGURO')
	nTotalNF  := MaFisRet(,'NF_TOTAL')

	If cPaisLoc == "BRA"
		oPrn:Say(nLinI, nCol+510, "IPI      :" + Transform(xMoeda(nTotIPI ,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotIpi ,14,MsDecimais(MV_PAR12))), oFont09:oFont)
		oPrn:Say(nLinI, nCol+710, "ICMS     :" + Transform(xMoeda(nTotIcms,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotIcms,14,MsDecimais(MV_PAR12))), oFont09:oFont)
	EndIf
	IncLin(12)
	SM4->(dbSetOrder(1))

	//19/10/2017 - Carlos Bazani - Ajuste para os dados do transportador sair no local em destaque.
//   IF SC7->(FieldPos("C7_X_TRANS"))>0 .And. !EMPTY(SC7->C7_X_TRANS)
	DbSelectArea("SA4")
	DbSetOrder(1)
	//  DbSeek(xFilial("SA4") + SC7->C7_X_TRANS)
	oPrn:Say(nLinI-10   , nCol+010, "Transportador:                      " /*+ alltrim(PADR(SA4->A4_NOME, 40)) +*/+ " Contato: " /*+ alltrim(PADR(SA4->A4_CONTATO, 13))*/,oFont08:oFont,,,)
	oPrn:Say(nLinI   , nCol+010, "Fone: XX XXXXX-XXXX" /*+ AllTrim(SUBSTR(SA4->A4_DDD, 1, 2)) + " " + AllTrim(SUBSTR(SA4->A4_TEL, 1, 10))*/,oFont08:oFont,,,)
//   ENDIF

   /*If SM4->(dbSeek(xFilial("SM4")+SC7->C7_REAJUST))
      oPrn:Say(nLinI, nCol+010, "Reajuste :" + " " + SC7->C7_REAJUST + " " + SM4->M4_DESCR, oFont09:oFont)    
   Else
      oPrn:Say(nLinI   , nCol+010, "ATENÇÃO: NÃO EFETUAREMOS PAGAMENTO DE TITULOS",oFont12N:oFont,,,) 
      oPrn:Say(nLinI+10, nCol+010, "         NEGOCIADOS COM TERCEIROS.           ",oFont12N:oFont,,,)
   EndIf
 	*/				
	oPrn:Say(nLinI, nCol+510, "Frete    :" + Transform(xMoeda(nTotFrete,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotFrete,14,MsDecimais(MV_PAR12))), oFont09:oFont)
	oPrn:Say(nLinI, nCol+710, "Despesas :" + Transform(xMoeda(nTotDesp ,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotDesp ,14,MsDecimais(MV_PAR12))), oFont09:oFont)
	IncLin(12)

//   IF SC7->(FieldPos("C7_X_TPFRE"))>0
	oPrn:Say(nLinI, nCol+510, "Tp Frete :  " /*+IIF(SC7->C7_X_TPFRE == "C", "CIF", IIF(SC7->C7_X_TPFRE == "F", "FOB", ""))*/, oFont09:oFont)
//   ENDIF

	oPrn:Say(nLinI, nCol+710, "SEGURO   :" + Transform(xMoeda(nTotSeguro,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotSeguro,14,MsDecimais(MV_PAR12))), oFont09:oFont)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializar campos de Observacoes.                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Empty(cObs02)
		If Len(cObs01) > 83
			cObs := cObs01
			cObs01 := Substr(cObs,1,83)
			For nX := 2 To 4
				cVar  := "cObs"+StrZero(nX,2)
				&cVar := Substr(cObs,(83*(nX-1))+1,83)
			Next nX
		EndIf
	Else
		cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<83,Len(cObs01),83))
		cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<83,Len(cObs01),83))
		cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<83,Len(cObs01),83))
		cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<83,Len(cObs01),83))
	EndIf

	If !Empty(cObsPed)
		For nCont := 1 To 4
			If Empty(&("cObs"+StrZero(nCont,2)))
				&("cObs"+StrZero(nCont,2)) := Substr(AllTrim(cObsPed),1,IIf(Len(cObsPed)<83,Len(cObsPed),83))
				Exit
			EndIf
		Next
	EndIf

	cComprador:= ""
	cAlter	  := ""
	cAprov	  := ""
	lNewAlc	  := .F.
	lLiber 	  := .F.

	dbSelectArea("SC7")
	If !Empty(SC7->C7_APROV)

		cTipoSC7:= IIF((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3),"PC","AE")
		lNewAlc := .T.
		cComprador := UsrFullName(SC7->C7_USER)
		If SC7->C7_CONAPRO != "B"
			lLiber := .T.
		EndIf
		/*
		Alterado por Edson Sales
		Para MAgitral.
		Data 30/12/2024
		*/
		dbSelectArea("SCR")
		dbSetOrder(1)
		dbSeek(xFilial("SCR")+cTipoSC7+SC7->C7_NUM)
		While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM) == xFilial("SCR")+Alltrim(SC7->C7_NUM) .And. SCR->CR_TIPO == cTipoSC7
			Aadd(aAprovador,{AllTrim(UsrFullName(SCR->CR_USER)),;
				iif(SCR->CR_STATUS=="03","Ok DIA: " + DTOC(CR_DATALIB) + " HORA: " + SCR->CR_XHRLIB,;
				iif(SCR->CR_STATUS=="04","BLQ",;
				iif(SCR->CR_STATUS=="05","##","??")));
				})
			dbSelectArea("SCR")
			dbSkip()
		Enddo
		If !Empty(SC7->C7_GRUPCOM)
			dbSelectArea("SAJ")
			dbSetOrder(1)
			dbSeek(xFilial("SAJ")+SC7->C7_GRUPCOM)
			While !Eof() .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
				If SAJ->AJ_USER != SC7->C7_USER
					cAlter += AllTrim(UsrFullName(SAJ->AJ_USER))+"/"
				EndIf
				dbSelectArea("SAJ")
				dbSkip()
			EndDo
		EndIf
	EndIf
	/*
	Alterado por Edson Sales
	Para MAgitral.
	Data 30/12/2024
	*/
	oPrn:Box(nLinI-5, nCol    , nLinI+080, 500) //Observacoes
	oPrn:Box(nLinI+009, nCol+500, nLinI+045, nColMax-50)//Total Geral
	If !lNewAlc //Tem Alcada pendente
		oPrn:Box(nLinI+045, nCol+500, nLinI+150, nCol+653)//Liberacao Pedido
		oPrn:Box(nLinI+045, nCol+653, nLinI+150, nColMax-50)//Obs Frete

		oPrn:Box(nLinI+080, nCol    , nLinI+150, nCol+145)//comprador
		oPrn:Box(nLinI+080, nCol+145, nLinI+150, nCol+290)//Gerencia
		oPrn:Box(nLinI+080, nCol+290, nLinI+150, nCol+500)//Diretoria

	Else
		oPrn:Box(nLinI+045, nCol+500, nLinI+080, nCol+698)//Status Pedido
		oPrn:Box(nLinI+045, nCol+698, nLinI+080, nColMax-50)//Obs Frete
		oPrn:Box(nLinI+080, nCol    , nLinI+150, nColMax-50)

	EndIf
	oPrn:Box(nLinI+0150, nCol, nLinI+170, nColMax-50)//Nota
	IncLin(12)

	oPrn:Say(nLinI-5, nCol+010, "Observacoes: " , oFont09:oFont)
  /*
  IF SC7->(FieldPos("C7_X_TRANS"))>0
		 DbSelectArea("SA4")
		 DbSetOrder(1)
		 DbSeek(xFilial("SA4") + SC7->C7_X_TRANS)
         oPrn:Say(nLinI, nCol+445, "Transp.: " + PADR(SA4->A4_NREDUZ, 35) + " Contato: " + PADR(SA4->A4_CONTATO, 13) + " Fone: " + AllTrim(SUBSTR(SA4->A4_TEL, 1, 10)), oFont09:oFont)
  ENDIF                                                                    
  */
	IncLin(12)
	oPrn:Say(nLinI, nCol+010, cObse01,  oFont06:oFont)
	oPrn:Say(nLinI+10, nCol+010, cObse02, oFont06:oFont)
	oPrn:Say(nLinI+20, nCol+010, cObse03, oFont06:oFont)
	oPrn:Say(nLinI+30, nCol+010, cObse04, oFont06:oFont)
	oPrn:Say(nLinI+40, nCol+010, cObse05, oFont06:oFont)
	oPrn:Say(nLinI+50, nCol+010, cObse06, oFont06:oFont)
	IncLin(12)
	If !lNewAlc
		oPrn:Say(nLinI, nCol+730, "Total Geral :" + Transform(xMoeda(nTotalNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotalNF,14,MsDecimais(MV_PAR12))), oFont09N:oFont)
	Else
		If lLiber
			oPrn:Say(nLinI, nCol+730, "Total Geral :" + Transform(xMoeda(nTotalNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotalNF,14,MsDecimais(MV_PAR12))), oFont09N:oFont)
		Else
			oPrn:Say(nLinI, nCol+730, "Total Geral :" + Transform(xMoeda(nTotalNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotalNF,14,MsDecimais(MV_PAR12))), oFont09N:oFont)
			// oPrn:Say(nLinI, nCol+630, "Total Geral :" + If((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3)," P E D I D O   B L O Q U E A D O ","AUTORIZACAO DE ENTREGA BLOQUEADA"), oFont09N:oFont)
		EndIf
	EndIf
	IncLin(12)
	If !AllTrim(cObs02) $ AlLtrim(cObs01)
		oPrn:Say(nLinI, nCol+010, cObs02, oFont09:oFont)
	EndIf
	IncLin(12)
	If !AllTrim(cObs03) $ AlLtrim(cObs01)+AllTrim(cObs02)
		oPrn:Say(nLinI, nCol+010, cObs03, oFont09:oFont)
	EndIf
	If !lNewAlc
		oPrn:Say(nLinI, nCol+510, If((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3),"Liberacao do Pedido","Liber. Autorizacao "), oFont09:oFont)
	Else
		oPrn:Say(nLinI, nCol+510, If((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3), If( lLiber , "      P E D I D O   L I B E R A D O" , "     P E D I D O   B L O Q U E A D O " ) , If( lLiber , "AUTORIZACAO DE ENTREGA LIBERADA    " , "AUTORIZACAO DE ENTREGA BLOQUEADA   " ) ), oFont09:oFont)
	EndIf
	oPrn:Say(nLinI, nCol+708, "Obs. do Frete: " + If( SC7->C7_TPFRETE $ "F","FOB",If(SC7->C7_TPFRETE $ "C","CIF"," " )), oFont09:oFont)
	IncLin(12)
	If !AllTrim(cObs04) $ Alltrim(cObs01)+AllTrim(cObs02)+AllTrim(cObs03)
		oPrn:Say(nLinI, nCol+010, cObs04, oFont09:oFont)
	EndIf

	If !lNewAlc
		IncLin(12)
		IncLin(12)
		oPrn:Say(nLinI, nCol+020, "Comprador", oFont09:oFont)
		oPrn:Say(nLinI, nCol+155, "Gerencia", oFont09:oFont)
		oPrn:Say(nLinI, nCol+300, "Diretoria", oFont09:oFont)
		IncLin(12)
		IncLin(12)
		IncLin(12)
		oPrn:Say(nLinI, nCol+020, Replic("_",19), oFont09:oFont)
		oPrn:Say(nLinI, nCol+155, Replic("_",19), oFont09:oFont)
		oPrn:Say(nLinI, nCol+300, Replic("_",30), oFont09:oFont)
		oPrn:Say(nLinI, nCol+510, Replic("_",20), oFont09:oFont)

		IncLin(12)
		IncLin(12)
		IncLin(08)

	Else
		IncLin(12)
//   oPrn:Say(nLinI, nCol+010, "Compradores Alternativos :"+" "+If( Len(cAlter) > 0 , Substr(cAlter,001,130) , " " ) +;
//                              If( Len(cAlter) > 130 , Substr(cAlter,131,130) , " " ), oFont09:oFont)
		IncLin(12)
		/*
		Alterado por Edson Sales
		Para MAgitral.
		Data 30/12/2024
		*/
		for nx := 1 to len(aAprovador)
			If nx % 2 == 0 //
				oPrn:Say(nLinI, nCol+440,"Aprovador: "+ aAprovador[nx,1] + " - " + aAprovador[nx,2] )
				IncLin(12)
			Else
				oPrn:Say(nLinI, nCol+010,"Aprovador: "+ aAprovador[nx,1] + " - " + aAprovador[nx,2] )
			EndIF
		next nx
		oPrn:Say(575, nCol+010, "Legendas da Aprovacao :  BLQ:Bloqueado|  Ok:Liberado|  ??:Aguar.Lib|  ##:Nivel Lib", oFont09:oFont)
	EndIf

	If SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3
		oPrn:Say(590, nCol+010, "NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras.", oFont09:oFont)
	Else
		oPrn:Say(590, nCol+010, "NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero da Autorizacao de Entrega.", oFont09:oFont)
	EndIf

Return()

Static Function RDadEmp()
// Local cFilImp := SuperGetMV("MV_X_TRPEC",, "")
	Local aDados  := {}
	cFilImp :='L'
	If cFilImp == "E" //Entrega
		SM0->(dbSetOrder(1))
		nRecnoSM0 := SM0->(Recno())
		SM0->(dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT))

		aDados := {SM0->M0_NOMECOM, SM0->M0_ENDENT, SM0->M0_CEPENT, SM0->M0_CIDENT, SM0->M0_ESTENT,;
			SM0->M0_CGC, SM0->M0_TEL}

		SM0->(dbGoto(nRecnoSM0))

	Else //Logada
		aDados := {SM0->M0_NOMECOM, SM0->M0_ENDENT, SM0->M0_CEPENT, SM0->M0_CIDENT, SM0->M0_ESTENT,;
			SM0->M0_CGC, SM0->M0_TEL}
	EndIf

Return(aDados)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³R110ALogo ³ Autor ³ Materiais             ³ Data ³08/01/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna string com o nome do arquivo bitmap de logotipo    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110A                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function R110ALogo()

	Local cRet := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se nao encontrar o arquivo com o codigo do grupo de empresas ³
//³ completo, retira os espacos em branco do codigo da empresa   ³
//³ para nova tentativa.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !File( cRet )
		cRet := "LGRL" + AllTrim(SM0->M0_CODIGO) + SM0->M0_CODFIL+".BMP" // Empresa+Filial
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se nao encontrar o arquivo com o codigo da filial completo,  ³
//³ retira os espacos em branco do codigo da filial para nova    ³
//³ tentativa.                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !File( cRet )
		cRet := "LGRL"+SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se ainda nao encontrar, retira os espacos em branco do codigo³
//³ da empresa e da filial simultaneamente para nova tentativa.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !File( cRet )
		cRet := "LGRL" + AllTrim(SM0->M0_CODIGO) + AllTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se nao encontrar o arquivo por filial, usa o logo padrao     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !File( cRet )
		cRet := "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
	EndIf

Return cRet
