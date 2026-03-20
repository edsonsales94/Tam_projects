#include "Protheus.CH"
#INCLUDE "RWMAKE.CH"
#include "TopConn.ch"


#DEFINE CGETFILE_TYPE GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE

//Posições do Array
Static nPosCodigo := 1 //Coluna A no Excel
Static nPosQuntid := 2 //Coluna B no Excel

/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ HLAFAT03  ¦ Autor ¦Edson Sales        	  ¦ Data ¦ 24/11/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦           ¦ Gera tela para carregar dados do arquivo CSV e informações    ¦¦¦
¦¦¦           ¦ do pedido.                                                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/

User function HLAFAT03()

	Local aArea         := GetArea()
	Private cCliente    := Space(6)
	Private cLoja      := Space(2)
	Private cCond      := Space(3)
	Private cTipo       := "Pedido (*.CSV)        | *.CSV | "
	Private cTipo       := cTipo + "Todos os Arquivos (*.csv)   | *.csv     "
	Private mvpar01     := Space(30)
	Private cxPath      := ""
	Private cCaminho    := Space(100)
	Private oPed
	RpcSetEnv('01','01')

	@ 275,235 To 496,880 Dialog oPed Title OemToAnsi("Gerar os Itens do pedido de venda")
	@ 5,2  To 41,292 Title OemToAnsi("ARQUIVO:")
	@ 45,2 To 74,90 Title OemToAnsi("CLIENTE:")
	@ 45,100 To 74,160 Title OemToAnsi("LOJA:")
	@ 45,180 To 74,240 Title OemToAnsi("COND PAGTO:")
	@ 75,2 To 79,311
	@ 20,10   MSGET cCaminho Size 204,10   PIXEL of oPed WHEN .F.
	@ 57,7    MSGET cCliente F3 "SA1" Size 76,10  OF oPed PIXEL  VALID(PesqCli())
	@ 57,107  MSGET cLoja    F3 "SA1" Size 48,10  OF oPed PIXEL  //VALID(PesqCli())
	@ 57,187  MSGET cCond    F3 "SE4" Size 48,10  OF oPed PIXEL  VALID(PesqCond())

	@ 18,224 Button OemToAnsi("Carregar arquivo CSV") Size 60,16 Action HLAPROC()
	@ 85,175 Button OemToAnsi("Gerar Itens")          Size 55,20 Action HLAGRVITEM()
	@ 85,250 Button OemToAnsi("Fechar")               Size 55,20 Action Close(oPed)

	Activate Dialog oPed  CENTERED

	RestArea(aArea)
	*
Return


/*/
	+-------------------------------------------------------------------------------+
	¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
	¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
	¦¦¦ Programa  ¦ HLAPROC    ¦ Autor ¦Edson Sales        	  ¦ Data ¦ 24/11/2025 ¦¦¦
	¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
	¦¦¦           ¦ Rotina para exibir a pasta d arquivo CSV.                     ¦¦¦
	¦¦¦           ¦                                                               ¦¦¦
	¦¦+-----------+---------------------------------------------------------------+¦¦
	¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
	+-------------------------------------------------------------------------------+
/*/

Static Function HLAPROC()

	cArq := ( cxPath + RTRIM(mvpar01) + ".csv" )
	lArq := .T.

	IF ( !FILE(cArq) )
		lArq := .F.
		cArq := cGetFile( cTipo,"Selecione arquivo...",1  , cxPath , .T. , CGETFILE_TYPE )
		If Empty(cArq).AND.Empty(mvpar01)
			Aviso("Cancelada a Seleção!","Você cancelou a seleção do arquivo.",{"Ok"})
		Endif
	ENDIF
	IF ( !EMPTY(cArq) )
		cCaminho := cArq
		oPed:Refresh()
	ENDIF

Return(.T.)

	*****************************
Static Function PesqCli()
	*****************************

	IF !Empty(cCliente)
		DBSelectArea("SA1")
		DBSetOrder(1)
		if !DBSeek(xFilial("SA1")+cCliente)
			MsgStop("Cliente não cadastrado !!!")
			Return (.F.)
		Endif
		cLoja := SA1->A1_LOJA
	ENDIF


Return(.T.)

	*****************************
Static Function PesqCond()
	*****************************

	IF !Empty(cCond)
		DBSelectArea("SE4")
		DBSetOrder(1)
		if !DBSeek(xFilial("SE4")+cCond)
			MsgStop("Condicao de pagamento não cadastrada !!!")
			Return (.F.)
		Endif
	ENDIF
Return(.T.)


	******************************
Static function HLAGRVITEM()
	******************************
	Local n:=1
	Local nTot          := 0
	Local aCab          := {}
	Local aProdEst      := {}
	Local lEnd          := .T.
	Local cNum          := ""
	Private aItem       := {}
	Private aItens      := {}
	Private lMsErroAuto := .F.
	Private aLogP	    := {}
	Private aDados      := {}   //Armazena os dados do aquivo .CSV
	*
	if Empty(cCaminho)
		Alert("Necessário informar o arquivo! ")
		Return .F.
	endif

	if Empty(cCliente)
		Alert("Necessário informar o Cliente! ")
		Return .F.
	endif
	*
	ProcOK()
	Close(oPed)
Return

	************************
Static Function ProcOK()
	************************
	cArqx     := cCaminho
	lArq      := .T.
	*
	IF Len(aDados) = 0
		*
		IF ( !EMPTY(cArqx) )
			Processa( {|| CargaArray(cArqx)})
		ENDIF
	ELSE
		Aviso("ATENÇÃO","Arquivo já processado.",{"Ok"})
	ENDIF
Return(.T.)


Static Function CargaArray(cArqOri)
	Local aArea1      := GetArea()
	Local cArqLog    := "zImpCSV_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
	Local nTotLinhas := 0
	Local cLinAtu    := ""
	Local nLinhaAtu  := 0
	Local nPosAcols  := 0
	Local aLinha     := {}
	Local aDados     := {}
	Local oArquivo
	Local aLinhas
	// Local aDadosX := {}
	Local aPoder3 := {}
	Local aProds  := {}
	Local aItTer  := {}
	Local NN := 0
	Local nJ := 0
	Local nZ := 0
	Local nI := 0
	Local cCodNS   	:= ""
	Local cSubs1   	:= ""
	Local nQuant    := ""
	Local cSubs2  	:= ""
	Local cAliasDoc	:= ''
	Local cItem		:= '00'

	Private cDirLog    := GetTempPath() + "x_importacao\"
	Private cLog       := ""

	//Se a pasta de log não existir, cria ela
	If ! ExistDir(cDirLog)
		MakeDir(cDirLog)
	EndIf

	//Definindo o arquivo a ser lido
	oArquivo := FWFileReader():New(cArqOri)

	//Se o arquivo pode ser aberto
	If (oArquivo:Open())

		//Se não for fim do arquivo
		If ! (oArquivo:EoF())

			//Definindo o tamanho da régua
			aLinhas := oArquivo:GetAllLines()
			nTotLinhas := Len(aLinhas)
			ProcRegua(nTotLinhas)

			//Método GoTop não funciona (dependendo da versão da LIB), deve fechar e abrir novamente o arquivo
			oArquivo:Close()
			oArquivo := FWFileReader():New(cArqOri)
			oArquivo:Open()
			Begin Transaction
				cPedido		:= GetSXENum("SC5", "C5_NUM")
				RollBackSX8()
				aCabecalho  := {}
				aItens 		:= {}
				aAdd(aCabecalho, {"C5_NUM",			cPedido,			NIL})
				aAdd(aCabecalho, {"C5_TIPO",		"N",				NIL})
				aAdd(aCabecalho, {"C5_CLIENTE",		cCliente,			NIL})
				aAdd(aCabecalho, {"C5_LOJACLI",		cLoja,				NIL})
				aAdd(aCabecalho, {"C5_TIPOCLI",		"F",				NIL})
				aAdd(aCabecalho, {"C5_CONDPAG",		cCond,				NIL})

				//Enquanto tiver linhas
				While (oArquivo:HasLine())

					//Incrementa na tela a mensagem
					nLinhaAtu++
					IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")

					//Pegando a linha atual e transformando em array
					cLinAtu := oArquivo:GetLine()

					// caso algum substrato não exista, coloca N/A para manter o array aLinha com as 4 posições.
					iF ";;" $ cLinAtu
						cLinAtu := StrTran(cLinAtu,';;',';N/A;')
						aLinha  := StrTokArr(cLinAtu, ";")
					else
						aLinha  := StrTokArr(cLinAtu, ";")
						// caso o substrato entre como no array com uma string vazia
						NPOS := AScan( aLinha , {|x| ALLTrim(x) == "" })

						if NPOS > 0
							aLinha[NPOS] := 'N/A'
						endif
					endif

					// aLinha  := StrTokArr(cLinAtu, ";")

					//Se não for o cabeçalho (encontrar o texto "Código" na linha atual)
					If ! "ns" $ Lower(cLinAtu);
							.OR. ! "substrato" $ Lower(cLinAtu);
							.OR. ! "quant" $ Lower(cLinAtu)
						//Zera as variaveis

						nEstru	:= 0				&&	//NÃO REMOVER - Controla recursividade na funcao Estrut2()
						cwTable := Nil

						//Zera as variaveis
						nQuant   := VAL(aLinha[nPosQuntid])
						CFORNCE:= '000099'
						CTES:= '196'
						// PERCORRER OS TRES PRODUTOS NS;SUNSTRATO;SUBSTRATO

						nPosAcols++
						aDados := {}
						// primeiro produto, NS
						DBSelectArea('SB1')
						SB1->(DBSetOrder(1))
						// if NN == nPosCodigo
						if SB1->(msSeek(xfilial('SB1')+aLinha[nPosCodigo]))

							CLOCAL:= SB1->B1_LOCPAD
							cAliasDoc  := GetNextAlias()

							BEGINSQL alias cAliasDoc

							SELECT D1_DOC,
									D1_IDENTB6,
									D1_SERIE,
									D1_ITEM,
									D1_FORNECE,
									D1_LOJA,
									D2_CLIENTE,
									D1_EMISSAO,
									D1_COD,
									D1_VUNIT,
									D1_QUANT,
									SUM(D2_QUANT) D2_QUANT,
									(D1_QUANT - ISNULL(SUM(SD2.D2_QUANT), 0)) AS Saldo,
									isnull(SC6Q.QTD_RES_PED,0)  AS RESERVADO
								FROM SD1010 SD1
								LEFT JOIN SD2010 SD2 ON D1_DOC=D2_NFORI
								AND D1_SERIE = D2_SERIORI
								AND D1_ITEM=D2_ITEMORI
								AND D1_COD=D2_COD
								AND D1_FORNECE = D2_CLIENTE
								AND SD2.D_E_L_E_T_ = ' '
								AND D1_IDENTB6=D2_IDENTB6
								AND D2_LOJA  = SD1.D1_LOJA

								LEFT JOIN (
									SELECT
										C6_NFORI,
										C6_SERIORI,
										C6_ITEMORI,
										C6_PRODUTO,
										SUM(C6_QTDVEN) AS QTD_RES_PED
									FROM SC6010
									WHERE D_E_L_E_T_ = ' ' AND C6_DATFAT =''
									GROUP BY
										C6_NFORI,
										C6_SERIORI,
										C6_ITEMORI,
										C6_PRODUTO
								) SC6Q
									ON SC6Q.C6_NFORI  = SD1.D1_DOC
								AND SC6Q.C6_SERIORI = SD1.D1_SERIE
								AND SC6Q.C6_PRODUTO = SD1.D1_COD
								AND SC6Q.C6_ITEMORI = SD1.D1_ITEM
								WHERE D1_FORNECE=%EXP:CFORNCE%
								AND D1_COD =%exp:aLinha[nPosCodigo]%
								AND D1_TES =%EXP:CTES%
								AND D1_LOCAL =%EXP:CLOCAL%
								AND SD1.D_E_L_E_T_ = ' '
								GROUP BY D1_DOC,
										D1_IDENTB6,
										D1_SERIE,
										D1_ITEM,
										D1_FORNECE,
										D1_LOJA,
										D1_EMISSAO,
										D1_COD,
										D1_QUANT,
										D2_CLIENTE,
										D1_VUNIT,
										SC6Q.QTD_RES_PED,
										SC6Q.C6_PRODUTO
								HAVING (SD1.D1_QUANT - ISNULL(SUM(SD2.D2_QUANT), 0)) > 0
								ORDER BY D1_DOC
							
							ENDSQL

							aDados	:=	{}
							aDadosX	:=	{}

							(cAliasDoc)->(DbGoTop())
							if !(cAliasDoc)->(EoF())
								// DocsPoder3(cDoc, cSerie, cCliFor, cLoja, cProduto, cItem, nQuantidad, cComp, cP3Serie, cP3Tes, cP3Local, dP3DtCor, aItens)
								while !(cAliasDoc)->(EoF())
									// cItem	:=	Soma1(cItem	)
									// enquanto não referenciar toda a quantidade, ate zerar a diferenca
									while cItem=='00' .or. NQUANT > 0
										aPoder3 :=	DocsPoder3((cAliasDoc)->D1_DOC ,;
											(cAliasDoc)->D1_SERIE					,;
											(cAliasDoc)->D1_FORNECE					,;
											(cAliasDoc)->D1_LOJA					,;
											(cAliasDoc)->D1_COD						,;
											(cAliasDoc)->D1_ITEM					,;
											NQUANT	,;
											aLinha[nPosCodigo],,,,,aItens,(cAliasDoc)->RESERVADO)

										// SE RETORNA VAZIO A NOTA DA VEZ FOI ULTILIZADA TODA, PULA PARA A PROXIMA
										nJ := Len(aPoder3)
										If empty(aPoder3)
											(cAliasDoc)->(DbSkip())
											LOOP
										else
											NQUANT :=  aPoder3[nJ, 8]
										EndIf

										// se não hover saldo suficiente < vai retornar a vantidade restante > se tiver saldo retorna zero.
										// se retorna zero é por que já encontro uma nota com saldo de poder 3º para refenciar, encerra o laço.
										// if aPoder3[nJ, 8] == 0
										// 	Exit
										// endif

										&&	Clonagem das LINHA ORIGINAL para cada Doc. de Entrada utilizado para atender o Ped. Venda [Transferencia].
										If nJ > 0
											For nJ := 1 To Len(aPoder3)
												cItem	:=	Soma1(cItem	)
												aAdd(aDados, {"C6_ITEM",	cItem,							Nil})
												aAdd(aDados, {"C6_PRODUTO",	aLinha[nPosCodigo],				Nil})
												aAdd(aDados, {"C6_QTDVEN",	0,								Nil})
												aAdd(aDados, {"C6_PRCVEN",	0,								Nil})
												aAdd(aDados, {"C6_QTDLIB",	0,								Nil})
												aAdd(aDados, {"C6_TES",		"522",							Nil})
												aAdd(aDados, {"C6_PRUNIT",	0,								Nil})
												aAdd(aDados, {"C6_IDENTB6",	CriaVar("C6_IDENTB6",	.F.),	Nil})
												aAdd(aDados, {"C6_NFORI",	CriaVar("C6_NFORI",		.F.),	Nil})
												aAdd(aDados, {"C6_SERIORI",	CriaVar("C6_SERIORI",	.F.),	Nil})
												aAdd(aDados, {"C6_ITEMORI",	CriaVar("C6_ITEMORI",	.F.),	Nil})
												aAdd(aDados, {"C6_ZZIDEXP",		"ABD",						Nil}) // ADD Luciano Lamberti - 07-02-2019 - Filial ABD para retorno
												aAdd(aDados, {"C6_PROGRAM",	"HLAFAT03",						Nil})

												// aDadosX	:=	aClone(aDados)
												// If nJ > 1					&&	Somente Linhas CLONADAS
												// 	cItem := Soma1(cItem, Len(CriaVar("C6_ITEM")) )
												// 	aAdd(aItens, aDadosX)
												// 	aDados[aScan(aDados, {|x| x[1] == "C6_ITEM"}), 2] := cItem
												// EndIf

												&&	Preenchendo/Sobrescrevendo os dados de acordo com o Doc. de Entrada utilizado para atender o Ped. Venda [Transferencia].
												nQtdVen := aPoder3[nJ, 05]
												nPrcVen := a410Arred(aPoder3[nJ, 06], "C6_PRCVEN")

												aDados[aScan(aDados, {|x| AllTrim(x[01]) == "C6_QTDVEN" }), 02] := nQtdVen
												aDados[aScan(aDados, {|x| AllTrim(x[01]) == "C6_PRCVEN" }), 02] := nPrcVen
												aDados[aScan(aDados, {|x| AllTrim(x[01]) == "C6_QTDLIB" }), 02] := nQtdVen
												aDados[aScan(aDados, {|x| AllTrim(x[01]) == "C6_NFORI"  }), 02] := aPoder3[nJ, 01]
												aDados[aScan(aDados, {|x| AllTrim(x[01]) == "C6_SERIORI"}), 02] := aPoder3[nJ, 02]
												aDados[aScan(aDados, {|x| AllTrim(x[01]) == "C6_ITEMORI"}), 02] := aPoder3[nJ, 04]
												aDados[aScan(aDados, {|x| AllTrim(x[01]) == "C6_IDENTB6"}), 02] := aPoder3[nJ, 03]
												aDados[aScan(aDados, {|x| AllTrim(x[01]) == "C6_PRUNIT" }), 02] := nPrcVen
											Next nJ

											AADD(aItens, aDados)  // todos os itens venda e devolção
											// aPoder3	:= {}
										endif
									EndDo
									(cAliasDoc)->(DbSkip())
								EndDo
								&& Conteudo de aPoder3
								&&
								&& 1 - Documento
								&& 2 - Serie
								&& 3 - Ident. SB6
								&& 4 - No. Item
								&& 5 - Quantidade
								&& 6 - Prc.Unitario
								&& 7 - Produto
								&& 8 - Qtde que falta para atender a necessidade?

								// SE RETORNA VAZIO NÃO EXISTE MAIS NOTA PARA COM SALDO EM PODER DE TERCEIRO PARA ESSE ITEM, o item não entrarar mais no pedido.
								If empty(aPoder3)
									// cItem := CVALTOCHAR(VAL(cItem)-1) // VOLTA O ITEM
									FWALERTWARNING('Saldo insuficiente para o item '+aLinha[nPosCodigo] +', todo o saldo existente já foi consumido.','Atenção !!!')
									LOOP
								EndIf

							endif
							(cAliasDoc)->(DbCloseArea())
						EndIf
					endif
				EndDo

				lMsHelpAuto	:=	.T.
				lMsErroAuto	:=	.F.

				If !Empty(aItens)
					Processa({|| MSExecAuto({|x, y, z| MATA410(x, y, z)}, aCabecalho, aItens, 3)}, "Gerando Ped Venda Remessa P/ Ind [" + cPedido + "]. Aguarde...")

					If lMsErroAuto
						Mostraerro()
						DisarmTransaction()
					Else
						MsgInfo("Ped. Venda de Retorno de Remessa p/ Industrializacao GERADO: [" + cPedido + "].", FunDesc())
					EndIf
				Else
					MsgStop("Nota Fiscal INVALIDA. NENHUM Ped. Venda de Retorno de Remessa p/ Industrializacao foi GERADO.", FunDesc())
				EndIf

				//Se tiver log, mostra ele
				If ! Empty(cLog)
					cLog := "Processamento finalizado, abaixo as mensagens de log: " + CRLF + cLog
					MemoWrite(cDirLog + cArqLog, cLog)
					ShellExecute("OPEN", cArqLog, "", cDirLog, 1)
				EndIf
			End Transaction
		Else
			MsgStop("Arquivo não tem conteúdo!", "Atenção")
		EndIf

		//Fecha o arquivo
		oArquivo:Close()
	Else
		MsgStop("Arquivo não pode ser aberto!", "Atenção")
	EndIf

	RestArea(aArea1)
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³DocsPoder3³ Autor ³ Fabricio M Vieira     ³ Data ³ 09/04/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ TOTVS IP Campinas³Contato ³ cps.fabriciom@totvs.com.br     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna Documento/Serie/Ident com Saldo Disponivel em Poder³±±
±±³          ³ de Terceiro para uso em Ped. Venda de Retorno de Remessa p/³±±
±±³          ³ Industrializacao.                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÅÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function DocsPoder3(cDoc, cSerie, cCliFor, cLoja, cProduto, cItem, nQuantidad, cComp, cP3Serie, cP3Tes, cP3Local, dP3DtCor, aItens,nReserva)
	Local	aAliasATU	:=	GetArea()
	Local	aAliasSB6	:=	SB6->(GetArea())
	Local	cQuery		:=	""
	Local	cAtuEst		:=	POSICIONE('SF4',1,XFILIAL('SF4')+'196','F4_ESTOQUE')
	Local	aRetorno	:=	{}
	Local	nSaldoDoc	:=	0
	Local	nResto		:=	0
	Local	cTabelaSQL	:=	"TSB601"

	Default	cP3Serie	:=	FormatIn(	GetMv("ZZ_P3SERIE",,	"7  ;4  ;2  ;0  ;"), ";")
	Default	cP3Tes		:=	FormatIn(	GetMv("ZZ_P3TES",,		"585;558;620"), ";")
	Default	cP3Local	:=	FormatIn(	GetMv("ZZ_P3LOCAL",,	"85;86"), ";")
	Default	dP3DtCor	:=				GetMv("ZZ_P3DTCOR",,	DtoS(CtoD("25/09/15")))



	cQuery	:=	"SELECT "																+ CRLF
	cQuery	+=	"	B6_TPCF, B6_TIPO, B6_PODER3, B6_EMISSAO, B6_PRODUTO, B6_LOCAL, "	+ CRLF
	cQuery	+=	"	B6_SALDO, B6_QULIB, B6_DOC, B6_SERIE, B6_PRUNIT, B6_IDENT, "		+ CRLF
	cQuery	+=	"	D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_ITEM, D1_COD, D1_QUANT, "	+ CRLF														+ CRLF
	cQuery	+=	"	SB1_PA.B1_REVATU, "													+ CRLF
	cQuery	+=	"	SB1.B1_DESC, SB1.B1_TS "											+ CRLF
	cQuery	+=	"FROM "																	+ CRLF
	cQuery	+=	"	"							+ RetSQLName("SD1")	+ " SD1 "			+ CRLF
	cQuery	+=	"	INNER JOIN "				+ RetSQLName("SB6")	+ " SB6 ON "		+ CRLF
	cQuery	+=	"		B6_FILIAL   = '"		+ xFilial("SB6")	+ "' AND "			+ CRLF
	cQuery	+=	"		B6_DOC  = D1_DOC AND "			+ CRLF
	cQuery	+=	"		B6_PRODUTO  = D1_COD AND "			+ CRLF
  //	cQuery	+=	"		B6_EMISSAO >= '"		+ dP3DtCor			+ "' AND "			+ CRLF
  	cQuery	+=	"		B6_EMISSAO = D1_EMISSAO AND "			+ CRLF               //vfv 22/10/15       // ALTERADO Sr. Douglas para controle das novas nf-s
	cQuery	+=	"		B6_LOCAL = D1_LOCAL AND "			+ CRLF

	//If cCliFor = '000002' .AND. cLoja = '2 ' 	             
	   //cQuery	+=	"		B6_SERIE IN "			+ cSerie 		 	+ " AND "			+ CRLF
	//Else
	   cQuery	+=	"		B6_SERIE = D1_SERIE AND "			+ CRLF 
	//Endif
	
	cQuery	+=	"		B6_CLIFOR = D1_FORNECE AND B6_LOJA = D1_LOJA AND "				+ CRLF
	cQuery	+=	"		B6_PODER3 = 'R' AND B6_TIPO = 'D' AND B6_SALDO > 0 AND "		+ CRLF  // inclusao de tratativa para nao utilizar nf sem saldo - Sr Adilson Teixeira 03/12/14
	cQuery	+=	"		B6_ESTOQUE = '"+cAtuEst+"' AND SB6.D_E_L_E_T_ = ' ' AND "		+ CRLF
	cQuery	+=	"		B6_ATEND <> 'S' AND B6_SALDO <= B6_QUANT"  						+ CRLF
	cQuery	+=	"	INNER JOIN "				+ RetSQLName("SB1")	+ " SB1 ON "		+ CRLF
	cQuery	+=	"		B1_FILIAL = '"			+ xFilial("SB1")	+ "' AND "			+ CRLF
	cQuery	+=	"		B1_COD = B6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "					+ CRLF
	cQuery	+=	"	INNER JOIN "				+ RetSQLName("SB1")	+ " SB1_PA ON "		+ CRLF
	cQuery	+=	"		SB1_PA.B1_FILIAL = '"	+ xFilial("SB1")	+"' AND "			+ CRLF
	cQuery	+=	"		SB1_PA.B1_COD = D1_COD AND SB1_PA.D_E_L_E_T_  = ' ' "			+ CRLF
	cQuery	+=	"WHERE "																+ CRLF
	cQuery	+=	"	D1_FILIAL = '"				+ xFilial("SD1")	+ "' AND "			+ CRLF
	cQuery	+=	"	D1_DOC = '"					+ cDoc				+ "' AND "			+ CRLF
	cQuery	+=	"	D1_SERIE = '"				+ cSerie			+ "' AND "			+ CRLF
	cQuery	+=	"	D1_FORNECE = '"				+ cCliFor			+ "' AND "			+ CRLF
	cQuery	+=	"	D1_LOJA = '"				+ cLoja				+ "' AND "			+ CRLF
	cQuery	+=	"	D1_COD = '"					+ cProduto			+ "' AND "			+ CRLF
	cQuery	+=	"	D1_ITEM = '"				+ cItem				+ "' AND "			+ CRLF
	// cQuery	+=	"	D1_TES IN "					+ cP3Tes			+ "  AND "			+ CRLF
	cQuery	+=	"	SD1.D_E_L_E_T_ = ' ' "												+ CRLF
	cQuery	+=	"ORDER BY "																+ CRLF
	cQuery	+=	"	B6_FILIAL, B6_EMISSAO, B6_DOC, B6_SERIE, D1_ITEM "					+ CRLF

	MemoWrite("\HLAFAT01_P3.sql", cQuery)
	
	TcQuery cQuery Alias (cTabelaSQL) New

	TcSetField(cTabelaSQL, "B6_EMISSAO",	"D"														)
	TcSetField(cTabelaSQL, "B6_SALDO",		"N", TamSx3("B6_SALDO")[1],		TamSx3("B6_SALDO")[2]	)
	TcSetField(cTabelaSQL, "B6_QULIB",		"N", TamSx3("B6_QULIB")[1],		TamSx3("B6_QULIB")[2]	)
	TcSetField(cTabelaSQL, "B6_PRUNIT",		"N", TamSx3("B6_PRUNIT")[1],	TamSx3("B6_PRUNIT")[2]	)
	TcSetField(cTabelaSQL, "D1_QUANT",		"N", TamSx3("D1_QUANT")[1],		TamSx3("D1_QUANT")[2]	)

	(cTabelaSQL)->(DbGoTop())
	Do While !(cTabelaSQL)->(Eof())		
		&& Verifica a qtde disponível para devolução
		nSaldoDoc	:=	(cTabelaSQL)->B6_SALDO - (cTabelaSQL)->B6_QULIB - DescUsado((cTabelaSQL)->B6_DOC, (cTabelaSQL)->B6_SERIE, (cTabelaSQL)->D1_ITEM, (cTabelaSQL)->B6_IDENT, aItens)
		nSaldoDoc -= nReserva									&&	Abate qtde reservada em outro pedido EM Aberto e não faturado.?
		If nSaldoDoc > 0										&&	HA Saldo no Doc.?
			nDif	:=	 nQuantidad - nSaldoDoc					&& Carrega a diferenca caso a qtde a devolver seja maior que a disponível ou a própria qtde se for suficiente
			// nResto	:=	 nSaldoDoc - nQuantidad					&& Carrega o resto caso a qtde a devolver seja maior que a disponível ou a própria qtde se for suficiente
			// nSaldoDoc -= nQuantidad								&& Abate a qtde desejada do saldo disponível	
			// nResto	:=	nSaldoDoc - (nQuantidad * -1)			&& Carrega o resto caso a qtde a devolver seja maior que a disponível ou a própria qtde se for suficiente

			aAdd(aRetorno, {	(cTabelaSQL)->B6_DOC							  ,;
								(cTabelaSQL)->B6_SERIE							  ,;
								(cTabelaSQL)->B6_IDENT							  ,;
								(cTabelaSQL)->D1_ITEM							  ,;
								IIf(nQuantidad < nSaldoDoc, nQuantidad, nSaldoDoc),;
								(cTabelaSQL)->B6_PRUNIT							  ,;
								(cTabelaSQL)->B6_PRODUTO						  ,;
								iif(nDif > 0,nDif,0)											})
			If nQuantidad <= 0
				Exit											&& Caso conseguiu atender, abandona o laço
			EndIf
		EndIf
		(cTabelaSQL)->(DbSkip())
	EndDo

	// If nQuantidad > 0	&&	Saldo de Terceiro em Nosso Poder INSUFICIENTE.
	// 	If Len(aRetorno) > 0
	// 		aRetorno[Len(aRetorno), 5] += nQuantidad
	// 		aRetorno[Len(aRetorno), 8] := nQuantidad
	// 	EndIf
	// EndIf

	(cTabelaSQL)->(DbCloseArea())

	RestArea(aAliasSB6)
	RestArea(aAliasATU)
Return(aRetorno)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ DescUsado³ Autor ³ Fabricio M Vieira     ³ Data ³ 24/04/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ TOTVS IP Campinas³Contato ³ cps.fabriciom@totvs.com.br     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Subtracao da quantidade JA CONSUMIDA neste Ped. Venda, para³±±
±±³          ³ ESTE Documento de Poder 3o.                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÅÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function DescUsado(cDoc, cSerie, cItem, cIdent, aItens)
	Local nQtdJaUsad	:=	0
	Local nI			:=	0
	Local aLinha		:=	{}

	&& Subtracao da quantidade JA CONSUMIDA neste Ped. Venda, para ESTE Documento de Poder 3o.
	For nI := 1 To Len(aItens)
		aLinha := aClone(aItens[nI])
		If	cDoc	==	aLinha[aScan(aLinha, {|x| x[1] == "C6_NFORI"  }), 2] .And.;
			cSerie	==	aLinha[aScan(aLinha, {|x| x[1] == "C6_SERIORI"}), 2] .And.;
			cItem	==	aLinha[aScan(aLinha, {|x| x[1] == "C6_ITEMORI"}), 2] .And.;
			cIdent	==	aLinha[aScan(aLinha, {|x| x[1] == "C6_IDENTB6"}), 2]

			nQtdJaUsad	+=	aLinha[aScan(aLinha, {|X| X[1] == "C6_QTDLIB" }), 2]
		EndIf
	Next nI
Return(nQtdJaUsad)


/*/{Protheus.doc} QTDESTRUT
	(long_description)
	@type  Static Function
	@author user
	@since 17/11/2025
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function QTDESTRUT(_cComp,_cProd)

Local nQuant := 0
Local cAliasSg1 := GetNextAlias()

if SELECT(cAliasSg1) > 0
	(cAliasSg1)->(DbCloseArea())
endif

BEGINSQL alias cAliasSg1
select B.G1_COD, B.G1_COMP,B.G1_QUANT QUANT
FROM %TABLE:SG1% A
INNER JOIN %TABLE:SG1% B ON A.G1_COMP=B.G1_COD AND B.G1_COMP=%EXP:_cComp%
WHERE A.G1_COD = %EXP:_cProd%
ENDSQL

nQuant := (cAliasSg1)->(QUANT)
	
Return nQuant
