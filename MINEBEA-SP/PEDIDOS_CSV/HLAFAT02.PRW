#include "Protheus.CH"
#INCLUDE "RWMAKE.CH"
#include "TopConn.ch"


#DEFINE CGETFILE_TYPE GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE

//Posições do Array
Static nPosCodigo := 1 //Coluna A no Excel
Static nPosSubst1 := 2 //Coluna B no Excel
Static nPosSubst2 := 3 //Coluna C no Excel
Static nPosQuntid := 4 //Coluna D no Excel

/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ HLAFAT02  ¦ Autor ¦Edson Sales        	  ¦ Data ¦ 24/11/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦           ¦ Gera tela para carregar dados do arquivo CSV e informações    ¦¦¦
¦¦¦           ¦ do pedido.                                                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/

User function HLAFAT02()

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
						StrTran(cLinAtu,';;',';N/A;')
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
						cCodNS   := aLinha[nPosCodigo]
						cSubs1   := aLinha[nPosSubst1]
						cSubs2   := aLinha[nPosSubst2]
						nQuant   := VAL(aLinha[nPosQuntid])
						CFORNCE:= '000099'
						CTES:= '189'
						NN := 0

						// PERCORRER OS TRES PRODUTOS NS;SUNSTRATO;SUBSTRATO

						aProds := {}
						for NN := 1 to 3
							nPosAcols++
							aDados := {}
							// primeiro produto, NS
							if NN == nPosCodigo
								CLOCAL:= '03'

								cItem := Soma1(cItem)
								nPrcVen := Posicione('SB1',1,xfilial('SB1')+aLinha[nPosCodigo],'B1_PRV1')

								aAdd(aDados, {"C6_ITEM",	cItem,							Nil})
								aAdd(aDados, {"C6_PRODUTO",	aLinha[nPosCodigo],				Nil})
								aAdd(aDados, {"C6_QTDVEN",	nQuant,							Nil})
								aAdd(aDados, {"C6_PRCVEN",	nPrcVen,						Nil})
								aAdd(aDados, {"C6_QTDLIB",	nQuant,							Nil})
								aAdd(aDados, {"C6_TES",		"585",							Nil})
								aAdd(aDados, {"C6_PRUNIT",	nPrcVen,						Nil})
								// aAdd(aDados, {"C6_NFFATUR",	'',							Nil})
								// aAdd(aDados, {"C6_NFSERIE",	'',							Nil})
								// aAdd(aDados, {"C6_ITEMFAT",	'',							Nil})
								aAdd(aDados, {"C6_IDENTB6",	CriaVar("C6_IDENTB6",	.F.),	Nil})
								aAdd(aDados, {"C6_NFORI",	CriaVar("C6_NFORI",		.F.),	Nil})
								aAdd(aDados, {"C6_SERIORI",	CriaVar("C6_SERIORI",	.F.),	Nil})
								aAdd(aDados, {"C6_ITEMORI",	CriaVar("C6_ITEMORI",	.F.),	Nil})
								aAdd(aDados, {"C6_ZZIDEXP",		" ",						Nil})
								aAdd(aDados, {"C6_PROGRAM",	"HLAFAT02",						Nil})

								AADD(aItens, aDados)  // todos os itens venda e devolção
							else
								cProd := iif(NN==nPosSubst1,aLinha[nPosSubst1],aLinha[nPosSubst2])
								xQuantEstrut := QTDESTRUT(cProd,aLinha[nPosCodigo]) //Posicione('SG1',1,XFILIAL('SG1')+aLinha[nPosCodigo]+cProd,'G1_QUANT')
								aAdd(aProds, {cProd, xQuantEstrut})
							endif
						next NN

						For nI := 1 To Len(aProds)

							cAliasDoc  := GetNextAlias()
							CLOCAL:= '87'

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
								AND D1_COD =%exp:aProds[nI,1]%
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
								HAVING (SD1.D1_QUANT - ISNULL(SUM(SD2.D2_QUANT), 0)) > %EXP:(APRODS[NI,2]*NQUANT)%
								ORDER BY D1_DOC
							
							ENDSQL

							aDados	:=	{}
							aDadosX	:=	{}
							
							(cAliasDoc)->(DbGoTop())
							if !(cAliasDoc)->(EoF())
								cItem	:=	Soma1(cItem)
								// DocsPoder3(cDoc, cSerie, cCliFor, cLoja, cProduto, cItem, nQuantidad, cComp, cP3Serie, cP3Tes, cP3Local, dP3DtCor, aItens)

								while !(cAliasDoc)->(EoF())
									aPoder3	:=	DocsPoder3(	(cAliasDoc)->D1_DOC ,;
										(cAliasDoc)->D1_SERIE					,;
										(cAliasDoc)->D1_FORNECE					,;
										(cAliasDoc)->D1_LOJA					,;
										(cAliasDoc)->D1_COD						,;
										(cAliasDoc)->D1_ITEM					,;
										(APRODS[NI,2]*NQUANT)	,;
										aProds[nI, 01],,,,,aItens,(cAliasDoc)->RESERVADO)

									// SE RETORNA VAZIO A NOTA DA VEZ FOI ULTILIZADA TODA, PULA PARA A PROXIMA
									If empty(aPoder3)
										(cAliasDoc)->(DbSkip())
										LOOP
									EndIf

									// se não hover saldo suficiente < vai retornar a vantidade restante > se tiver saldo retorna zero.
									// se retorna zero é por que já encontro uma nota com saldo de poder 3º para refenciar, encerra o laço.
									nJ := Len(aPoder3)
									if aPoder3[nJ, 8] == 0
										Exit
									endif
									(cAliasDoc)->(DbSkip())
								enddO
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
									cItem := CVALTOCHAR(VAL(cItem)-1) // VOLTA O ITEM
									FWALERTWARNING('Saldo insuficiente para o item '+aProds[nI, 01] +', todo o saldo existente já foi consumido.','Atenção !!!')
									LOOP
								EndIf

								If nJ > 0 .And. aPoder3[nJ, 8] == 0
									aAdd(aDados, {"C6_ITEM",	cItem,							Nil})
									aAdd(aDados, {"C6_PRODUTO",	aProds[nI, 01],					Nil})
									aAdd(aDados, {"C6_QTDVEN",	0,								Nil})
									aAdd(aDados, {"C6_PRCVEN",	0,								Nil})
									aAdd(aDados, {"C6_QTDLIB",	0,								Nil})
									aAdd(aDados, {"C6_TES",		"586",							Nil})
									aAdd(aDados, {"C6_PRUNIT",	0,								Nil})
									// aAdd(aDados, {"C6_NFFATUR",	SD2->D2_DOC,					Nil})
									// aAdd(aDados, {"C6_NFSERIE",	SD2->D2_SERIE,					Nil})
									// aAdd(aDados, {"C6_ITEMFAT",	SD2->D2_ITEM,					Nil})
									aAdd(aDados, {"C6_IDENTB6",	CriaVar("C6_IDENTB6",	.F.),	Nil})
									aAdd(aDados, {"C6_NFORI",	CriaVar("C6_NFORI",		.F.),	Nil})
									aAdd(aDados, {"C6_SERIORI",	CriaVar("C6_SERIORI",	.F.),	Nil})
									aAdd(aDados, {"C6_ITEMORI",	CriaVar("C6_ITEMORI",	.F.),	Nil})
									aAdd(aDados, {"C6_ZZIDEXP",		"ABD",						Nil}) // ADD Luciano Lamberti - 07-02-2019 - Filial ABD para retorno
									aAdd(aDados, {"C6_PROGRAM",	"HLAFAT02",						Nil})

									&&	Clonagem das LINHA ORIGINAL para cada Doc. de Entrada utilizado para atender o Ped. Venda [Transferencia].
									For nJ := 1 To Len(aPoder3)
										aDadosX	:=	aClone(aDados)
										If nJ > 1					&&	Somente Linhas CLONADAS
											cItem := Soma1(cItem, Len(CriaVar("C6_ITEM")) )
											aAdd(aItens, aDadosX)
											aDados[aScan(aDados, {|x| x[1] == "C6_ITEM"}), 2] := cItem
										EndIf

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
									aPoder3	:= {}
								endif,
							endif
							(cAliasDoc)->(DbCloseArea())
						NEXT nI
					EndIf
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
	Local	nI			:=	0
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
	cQuery	+=	"		B6_ESTOQUE = 'S' AND SB6.D_E_L_E_T_ = ' ' AND "					+ CRLF
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
			nQuantidad	-=	nSaldoDoc							&& Abate a qtde desejada do saldo disponível	
			nResto		:=	nSaldoDoc - (nQuantidad * -1)		&& Carrega o resto caso a qtde a devolver seja maior que a disponível ou a própria qtde se for suficiente

			aAdd(aRetorno, {	(cTabelaSQL)->B6_DOC					,;
								(cTabelaSQL)->B6_SERIE					,;
								(cTabelaSQL)->B6_IDENT					,;
								(cTabelaSQL)->D1_ITEM					,;
								IIf(nQuantidad > 0, nSaldoDoc, nResto)	,;
								(cTabelaSQL)->B6_PRUNIT					,;
								(cTabelaSQL)->B6_PRODUTO				,;
								0										})
			If nQuantidad <= 0
				Exit											&& Caso conseguiu atender, abandona o laço
			EndIf
		EndIf
		(cTabelaSQL)->(DbSkip())
	EndDo

	If nQuantidad > 0	&&	Saldo de Terceiro em Nosso Poder INSUFICIENTE.
		If Len(aRetorno) > 0
			aRetorno[Len(aRetorno), 5] += nQuantidad
			aRetorno[Len(aRetorno), 8] := nQuantidad
		EndIf
	EndIf

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

// 	***********************************
// Static Function CargaArray(cArq)
// 	***********************************
// 	Local cLinha     := ""
// 	Local nLin       := 1
// 	Local nTotLin    := 0
// 	Local cFile      := cArq // Caminho+nome do arquivo .CSV
// 	Local nHandle    := 0
// 	Local nLinTit    := 3    //Não considerar o cabeçalho do arquivo .CSV
// 	Local nPreco     := 0
// 	Local nItem      := 1
// 	Local nTot       := 0
// 	Local nPreco     := 0
// 	Local nEstrutura := 0
// 	Local nUsado	 := 0
// 	Local nQtd       := 1
// 	Local cItem      := strzero(1,TamSX3("C6_ITEM")[1])
// 	// Local nUsado     := Len(aHeader)
// 	// Local aExport    := aClone(aDados)
// 	// Private _cod     := AScan(aHeader,{|x|AllTrim(x[2])=="C6_PRODUTO"})
// 	// Private _Descri  := AScan(aHeader,{|x|AllTrim(x[2])=="C6_DESCRI"})
// 	// Private _Um      := AScan(aHeader,{|x|AllTrim(x[2])=="C6_UM"})
// 	// Private _Qtd     := AScan(aHeader,{|x|AllTrim(x[2])=="C6_QTDVEN"})
// 	// Private _Local   := AScan(aHeader,{|x|AllTrim(x[2])=="C6_LOCAL"})
// 	// Private _Prcven  := AScan(aHeader,{|x|AllTrim(x[2])=="C6_PRCVEN"})
// 	// Private _valor   := AScan(aHeader,{|x|AllTrim(x[2])=="C6_VALOR"})
// 	// Private _tes     := AScan(aHeader,{|x|AllTrim(x[2])=="C6_TES"})
// 	// Private _cf      := AScan(aHeader,{|x|AllTrim(x[2])=="C6_CF"})

// 	// nUsado  := Len(aHeader)
// //abre o arquivo csv
// 	nHandle := Ft_Fuse(cFile)
// 	If nHandle == -1
// 		Return aDados
// 	EndIf
// 	Ft_FGoTop()
// 	nLinTot := FT_FLastRec()
// 	ProcRegua(nLinTot)

// //Pula as linhas de cabeçalho
// 	While nLinTit > 0 .AND. !Ft_FEof()
// 		Ft_FSkip()
// 		nLinTit--
// 	EndDo

// //percorre todas linhas do arquivo csv
// 	Do While !Ft_FEof()
// 		//exibe a linha a ser lida
// 		IncProc("Carregando Linha "+AllTrim(Str(nLin))+" de "+AllTrim(Str(nLinTot)))
// 		nLin++
// 		//le a linha
// 		cLinha := Ft_FReadLn()
// 		//verifica se a linha está em branco, se estiver pula
// 		If Empty(AllTrim(StrTran(cLinha,';',''))) .or. Len(AllTrim(StrTran(cLinha,';',''))) < 11
// 			Ft_FSkip()
// 			Loop
// 		EndIf
// 		//transforma as aspas duplas em aspas simples
// 		cLinha := StrTran(cLinha,'"',"'")
// 		cLinha += ";"+StrZero(nItem,4)
// 		cLinha := '{"'+cLinha+'"}'

// 		//adiciona o cLinha no array trocando o delimitador ; por , para ser reconhecido como elementos de um array
// 		cLinha := StrTran(cLinha,';','","')
// 		nPos := aScan(aDados, {|x| x[2] == &cLinha[2] })
// 		if nPos = 0
// 			aAdd(aDados,&cLinha)
// 		else
// 			aDados[nPos,7] := LTRIM(STR(VAL(aDados[nPos,7])+VAL(&cLinha[7])))
// 		endif

// 		//aAdd(aDados, &cLinha)
// 		nItem  += 1
// 		//passa para a próxima linha
// 		FT_FSkip()
// 		//
// 	EndDo

// //libera o arquivo CSV
// 	FT_FUse()

// //Exclui o arquivo csv
// 	If File(cFile)
// 		//FErase(cFile)
// 	EndIf
// 	*
// 	IF ( LEN(aDados) > 0 )
// 		ProcRegua(Len(aDados))
// 		cItem    := "01"
// 		nProduto := 0
//    /*
//    FOR ix:=1 TO LEN(aDados)
//        if !EMPTY(aDados[ix,2])          
//           dbSelectArea("SB1")            
//           dbSetOrder(1)
//           if !(dbSeek(xFilial("SB1")+aDados[ix,2])) .or. SB1->B1_MSBLQL == "1"   
//              aAdd( aLogP, {aDados[ix,1],aDados[ix,2],aDados[ix,7],0})	
//           endif
//        else
//           aAdd( aLogP, {aDados[ix,1],aDados[ix,2],aDados[ix,7],0})	
//        endif
//    NEXT
//    */
// 		//if Len(aLogP) = 0
// 		// FOR ix:=1 TO LEN(aDados)
// 		// 	*
// 		// 	if !EMPTY(aDados[ix,2])
// 		// 		IncProc("Carregando Produto :"+aDados[ix,2])
// 		// 		SF4->(dbSetOrder(1))
// 		// 		SF4->(dbSeek(XFILIAL("SF4")+cTes))
// 		// 		dbSelectArea("SB1")
// 		// 		dbSetOrder(1)
// 		// 		if dbSeek(xFilial("SB1")+aDados[ix,2])  .and. SB1->B1_MSBLQL == "2"
// 		// 			cItem  := Soma1(cItem)
// 		// 			aDados[n,_cod]    := aDados[ix,2]
// 		// 			aDados[n,_Descri] := SB1->B1_DESC
// 		// 			aDados[n,_Um]     := SB1->B1_UM
// 		// 			aDados[n,_Qtd]    := VAL(aDados[ix,7])
// 		// 			aDados[n,_Local]  := cLocal //SB1->B1_LOCPAD
// 		// 			aDados[n,_Prcven] := SB1->B1_UPRC
// 		// 			if SB1->B1_UPRC = 0
// 		// 				aAdd( aLogP, {aDados[ix,1],aDados[ix,2],aDados[ix,7],SB1->B1_UPRC})
// 		// 			endif
// 		// 			aDados[n,_valor]  := ROUND(SB1->B1_UPRC*VAL(aDados[ix,7]),2)
// 		// 			aDados[n,_tes]    := cTes
// 		// 			aDados[n,_cf]     := SF4->F4_CF
// 		// 			nProduto++
// 		// 			*
// 		// 			//Inseri nova linha.
// 		// 			if nProduto < LEN(aDados)
// 		// 				if !Empty(aDados[nproduto+1,3])
// 		// 					//   1 ,2 , 3, 4,5,6,7,8,9 ,10,11,12,13,14,15,16,  17     ,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102
// 		// 					//aadd(aDados,{cItem,'','','',0,0,0,0,'',0,'','',0,'','', 0,dDataBase, 0, 0,'', 0,'','', 0,'',0 ,'','','',0,'','','','','',ctod(' / / '),'','','','','','','F','','','','','',0,'','','','','',dDataBase,'',0,0,0,'','','','2','','','','',0,'','','',ctod(' / / '),0,0,'','','','','','','','','','','',ctod(' / / '),'','1','','','','','','','','1','',0,'','SC6',0,.F.})
// 		// 					//aadd(aDados,{cItem,'','','',0,0,0,0,'',0,'','',0,'','', 0,dDataBase, 0, 0,'', 0,'','', 0,'',0 ,'','','',0,'','','','','',ctod(' / / '),'','','','','','','F','','','','','',0,'','','','','',dDataBase,'',0,0,0,'','','','','','','2','','','','',0,'','','',ctod(' / / '),0,0,'','','','','','','','','','','',ctod(' / / '),'','1','','','','','','','','1','',0,'','SC6',0,.F.})
// 		// 					//Montagem do aDados
// 		// 					AADD(aDados,Array(LEN(aHeader)+1))
// 		// 					aDados[LEN(aDados),LEN(aHeader)+1]:=.F.
// 		// 					For i := 1 to LEN(aHeader)
// 		// 						If !alltrim(aHeader[i,2]) $ 'C6_ALI_WT|C6_REC_WT|C6_ITEM'
// 		// 							aDados[LEN(aDados),i]:=CriaVar(aHeader[i,2])
// 		// 						ElseIf aHeader[i,2] == "C6_ALI_WT"
// 		// 							aDados[LEN(aDados),i]:= "SC6"
// 		// 						ElseIf aHeader[i,2] == "C6_REC_WT"
// 		// 							aDados[LEN(aDados),i]:= 0
// 		// 						ElseIf alltrim(aHeader[i,2]) == "C6_ITEM"
// 		// 							aDados[LEN(aDados),i]:= cItem
// 		// 						EndIf
// 		// 					Next
// 		// 					n++
// 		// 				endif
// 		// 			endif
// 		// 		else
// 		// 			aAdd( aLogP, {aDados[ix,1],aDados[ix,2],aDados[ix,7],0})
// 		// 			nProduto++
// 		// 		endif
// 		// 	endif
// 		// NEXT
// 		// n := 1
// 		//endif
// 	ENDIF
// 	*
// 	if Len(aLogP) > 0
// 		MsgAlert("Favor verificar o relatório!","Erro no CSV")
// 		HLAPEDIMP()
// 	else
// 		Aviso("Importação","Total de produto importados : "+ALLTRIM(TRANSFORM(nProduto,"@E 9999")),{"OK"})
// 	endif
// 	*
// Return aDados


/*/
	+-------------------------------------------------------------------------------+
	¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
	¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
	¦¦¦ Programa  ¦ HLAPEDIMP  ¦ Autor ¦Edson Sales        	  ¦ Data ¦ 24/11/2025 ¦¦¦
	¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
	¦¦¦ DESCRIÇÃO ¦ Relatorio de produtos com erro CSV.                           ¦¦¦
	¦¦+-----------+---------------------------------------------------------------+¦¦
	¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
	+-------------------------------------------------------------------------------+
/*/
// Static Function HLAPEDIMP()

// 	Private oReport, oSection1
// 	Private cPerg    := ""

// 	oReport := ReportDef()
// 	If !Empty(oReport:uParam)
// 		Pergunte(oReport:uParam,.F.)
// 	EndIf
// 	oReport:PrintDialog()

// Return

// //=================================================================================
// // relatorio de produtividade - formato personalizavel
// //=================================================================================
// Static Function ReportDef()

// 	Private cTitulo := 'Relação de produtos'


// 	oReport := TReport():New("HLAPEDIMP", cTitulo, cPerg , {|oReport| PrintReport(oReport)},"Emitirá Relatório com relação de produtos")

// 	oReport:SetPortrait()
// 	oReport:SetTotalInLine(.F.)
// 	oReport:ShowHeader()

// 	oSection1 := TRSection():New(oReport,"Produtos não cadastrados/sem preço - CSV",{""})
// 	oSection1:SetTotalInLine(.F.)

// 	TRCell():new(oSection1, "C_ITEM"    , "", "ITEM"                ,,10)
// 	TRCell():new(oSection1, "C_PROD"    , "", "PRODUTO"             ,,15)
// 	TRCell():new(oSection1, "C_DESC"    , "", "DESCRIÇÃO"           ,,35)
// 	TRCell():new(oSection1, "C_QTD"     , "", "QUANTIDADE"          ,,10)
// 	TRCell():new(oSection1, "C_PRC"     , "", "PREÇO"               ,,10)


// return (oReport)

// //=================================================================================
// // definicao para impressao do relatorio personalizado 
// //=================================================================================
// Static Function PrintReport(oReport)

// 	Local nReg
// 	Local lTitulo := .T.

// 	oSection1 := oReport:Section(1)

// 	oSection1:Init()
// 	oSection1:SetHeaderSection(.T.)

// 	oReport:SetMeter(Len(aLogP))


// 	For ix:=1 to Len(aLogP)

// 		If oReport:Cancel()
// 			Exit
// 		EndIf
// 		cDesc:=""
// 		oReport:IncMeter()
// 		oSection1:Cell("C_ITEM"):SetValue(aLogP[ix,1])
// 		oSection1:Cell("C_PROD"):SetValue(aLogP[ix,2])
// 		cDesc := Posicione("SB1",1,XFILIAL("SB1")+aLogP[ix,2],"B1_DESC")
// 		oSection1:Cell("C_DESC"):SetValue(iif(Empty(cDesc),"",cDesc))
// 		oSection1:Cell("C_QTD"):SetValue(aLogP[ix,3])
// 		oReport:SkipLine()
// 		oSection1:PrintLine()

// 	Next
// 	oSection1:Finish()

// Return
