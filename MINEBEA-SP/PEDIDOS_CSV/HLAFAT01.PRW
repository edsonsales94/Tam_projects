#include "Protheus.ch"
#include "TopConn.ch"

/*/{protheus.doc}HLAFAT01
Geracao Automatica de Ped. Venda de Retorno de Remessa p/ Industrializacao.
@author Fabricio M Vieira     
@since 09/04/10
/*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ HLAFAT01 ³ Autor ³ Fabricio M Vieira     ³ Data ³ 09/04/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Geracao Automatica de Ped. Venda de Retorno de Remessa p/  ³±±
±±³          ³ Industrializacao.                                          ³±±
±±³          ³ Especifico para transacoes Honda Lock -> Honda             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÅÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function HLAFAT01(cDoc, cSerie, cCliente, cLoja)
	Local	lRetorno	:=	.T.

	MsgRun(FunDesc(), "Avaliando base de dados. Aguarde...",{|| lRetorno := HLAFAT1A(cDoc, cSerie, cCliente, cLoja) })
Return(lRetorno)

Static Function HLAFAT1A(cDoc, cSerie, cCliente, cLoja)
	Local	aAliasATU	:= GetArea()
	Local	aAliasSX1	:= SX1->(GetArea())
	Local	aAliasSC5	:= SC5->(GetArea())
	Local	aAliasSC6	:= SC6->(GetArea())
	Local	aAliasSC9	:= SC9->(GetArea())
	Local	aAliasSF2	:= SF2->(GetArea())
	Local	aAliasSD2	:= SD2->(GetArea())
	Local	aAliasSB1	:= SB1->(GetArea())
	Local	aAliasSB6	:= SB6->(GetArea())
	Local	aAliasSG1	:= SG1->(GetArea())
	Local	lRetorno	:= .T.
	Local	lProcessar	:= .T.
	Local	cPerg		:= "HLAFAT01"
	Local	cPedido		:= CriaVar("C5_NUM", .F.)
	Local	aCabecalho	:= {}
	Local	aItens		:= {}
	Local	aLinha		:= {}
	Local	aLinhaX		:= {}
	Local	cItem		:= CriaVar("C6_ITEM",		.F.)
	Local	nTamItem	:= Len(cItem)
	Local	aPoder3		:= {}
	Local	aEstru		:= {}
	Local	aProds		:= {}
	Local	cQuery		:= ""
	Local	cP3Local	:= GetMv("ZZ_P3LOCAL",, "85;86")
	Local	nQtdVen		:= 0
	Local	nPrcVen		:= 0
	Local	nValor		:= 0
	Local	nI			:= 0
	Local	nJ			:= 0
	Local	nPos		:= 0
	Local	nQtdItem	:= 0
	Local	cCodProd	:= ""
	Local	cTexto		:= ""
	Local	cNomArqLog	:= ""

	Private nEstru		:= 0
	Private lMsHelpAuto	:= .T.
	Private lMsErroAuto	:= .F.
	//Private Estrut2		:= 0

	Default	cDoc		:= CriaVar("F2_DOC",		.F.)
	Default	cSerie		:= CriaVar("F2_SERIE",		.F.)
	Default	cCliente	:= CriaVar("F2_CLIENTE",	.F.)
	Default	cLoja		:= CriaVar("F2_LOJA",		.F.)

	ValidPerg(cPerg)

	If Empty(AllTrim(cDoc + cSerie + cCliente + cLoja))
		If Pergunte(cPerg, .T.)
			cDoc		:= MV_PAR01
			cSerie		:= MV_PAR02
			cCliente	:= MV_PAR03
			cLoja		:= MV_PAR04
		Else
			lProcessar	:= .F.
		EndIf
	EndIf

	If lProcessar .And. !NFJaUsado(cDoc, cSerie, cCliente, cLoja)
		Begin Transaction
			aCabecalho	:= {}
			aItens		:= {}
			aLinha		:= {}
			aLinhaX		:= {}
			cPedido		:= GetSXENum("SC5", "C5_NUM")
			RollBackSX8()

			aAdd(aCabecalho, {"C5_NUM",			cPedido,			NIL})
			aAdd(aCabecalho, {"C5_TIPO",		"N",				NIL})
			aAdd(aCabecalho, {"C5_CLIENTE",		cCliente,			NIL})
			aAdd(aCabecalho, {"C5_LOJACLI",		cLoja,				NIL})
			aAdd(aCabecalho, {"C5_TIPOCLI",		"F",				NIL})

			cItem	:=	StrZero(0, nTamItem)

			lProcessar := .T.
			SD2->(dbSetOrder(3))							&& D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA + D2_COD + D2_ITEM
			SD2->(dbSeek(xFilial("SD2") + cDoc + cSerie + cCliente + cLoja))
			Do While !SD2->(Eof()) .And. SD2->(D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA) == xFilial("SD2") + cDoc + cSerie + cCliente + cLoja
				SB1->(DbSetOrder(1))							&& B1_FILIAL + B1_COD
				aProds := {}

				&& Busca a Estrutura do Produto para pegar os produtos componentes
				&& A função Estrut retorna um array com as seguintes informações:
				&&		nEstru, cCodigo, cComponente, nQuantItem, cTrt, cGrOpc, cOpc, Recno()    
				&&       01			02		03				04		05		06	07		08	
				nEstru	:= 0				&&	//NÃO REMOVER - Controla recursividade na funcao Estrut2()
				cwTable := Nil 
				aEstru	:= Estrut2(SD2->D2_COD, 1, nil, @cwTable)
				dbSelectArea("ESTRUT")
				dbSetOrder(0)
				DBGOTOP()
				
				While ( !EOF() ) 
				
					cCodProd	:= ESTRUT->COMP //aEstru[nI, 03]
					nQtdItem	:= ESTRUT->QUANT //aEstru[nI, 04]

					If aScan(aProds, {|x| x[01] == cCodProd}) == 0
						SB1->(DbSeek(xFilial("SB1") + cCodProd))
						//If SB1->B1_LOCPAD $ cP3Local
						//Alterado para Controle de Poder de 3o. - Sr. Adilson Teixeira - ESTOQUE = 03/12/14				 
						//If SB1->B1_LOCPAD $ cP3Local					 
						If SB1->B1_XLOCAL $ cP3Local					
							aAdd(aProds, {cCodProd, nQtdItem})
						EndIf
					EndIf
					dbSelectArea("ESTRUT")
					DBSKIP()
					
				End
				FimEstrut2(NIL, cwTable)
			//	aEstru	:= Estrut2(SD2->D2_COD, 1)
			//	For nI := 1 To Len(aEstru)
			//		cCodProd	:= aEstru[nI, 03]
			//		nQtdItem	:= aEstru[nI, 04]
			//
			//		If aScan(aProds, {|x| x[01] == cCodProd}) == 0
			//			SB1->(DbSeek(xFilial("SB1") + cCodProd))
			//			//If SB1->B1_LOCPAD $ cP3Local
			//			//Alterado para Controle de Poder de 3o. - Sr. Adilson Teixeira - ESTOQUE = 03/12/14				 
			//			//If SB1->B1_LOCPAD $ cP3Local					 
			//			If SB1->B1_XLOCAL $ cP3Local					
			//				aAdd(aProds, {cCodProd, nQtdItem})
			//			EndIf
			//		EndIf
			//	Next nI

				For nI := 1 To Len(aProds)

					aLinha	:=	{}
					aLinhaX	:=	{}
					cItem	:=	Soma1(cItem)

					//DocsPoder3(cDoc, cSerie, cCliFor, cLoja, cProduto, cItem, nQuantidad, cComp, cP3Serie, cP3Tes, cP3Local, dP3DtCor, aItens)

					aPoder3	:=	DocsPoder3(	SD2->D2_DOC						,;
											SD2->D2_SERIE					,;
											SD2->D2_CLIENTE					,;
											SD2->D2_LOJA					,; 											
											SD2->D2_COD						,;											
											SD2->D2_ITEM					,;
											SD2->D2_QUANT * aProds[nI, 02]	,;
											aProds[nI, 01],,,,,aItens		)
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

					nJ := Len(aPoder3)
					If nJ > 0 .And. aPoder3[nJ, 8] == 0 
						aAdd(aLinha, {"C6_ITEM",	cItem,							Nil})
						aAdd(aLinha, {"C6_PRODUTO",	aProds[nI, 01],					Nil})
						aAdd(aLinha, {"C6_QTDVEN",	0,								Nil})
						aAdd(aLinha, {"C6_PRCVEN",	0,								Nil})
						aAdd(aLinha, {"C6_QTDLIB",	0,								Nil})
						aAdd(aLinha, {"C6_TES",		"586",							Nil})
						aAdd(aLinha, {"C6_PRUNIT",	0,								Nil})
						aAdd(aLinha, {"C6_NFFATUR",	SD2->D2_DOC,					Nil})
						aAdd(aLinha, {"C6_NFSERIE",	SD2->D2_SERIE,					Nil})
						aAdd(aLinha, {"C6_ITEMFAT",	SD2->D2_ITEM,					Nil})
						aAdd(aLinha, {"C6_IDENTB6",	CriaVar("C6_IDENTB6",	.F.),	Nil})
						aAdd(aLinha, {"C6_NFORI",	CriaVar("C6_NFORI",		.F.),	Nil})
						aAdd(aLinha, {"C6_SERIORI",	CriaVar("C6_SERIORI",	.F.),	Nil})
						aAdd(aLinha, {"C6_ITEMORI",	CriaVar("C6_ITEMORI",	.F.),	Nil})
						aAdd(aLinha, {"C6_ZZIDEXP",		"ABD",						Nil}) // ADD Luciano Lamberti - 07-02-2019 - Filial ABD para retorno
						aAdd(aLinha, {"C6_PROGRAM",	"HLAFAT01",						Nil})
	
						&&	Clonagem das LINHA ORIGINAL para cada Doc. de Entrada utilizado para atender o Ped. Venda [Transferencia].
						For nJ := 1 To Len(aPoder3)
							aLinhaX	:=	aClone(aLinha)
							If nJ > 1					&&	Somente Linhas CLONADAS
								cItem := Soma1(cItem, Len(CriaVar("C6_ITEM")) )
								aAdd(aItens, aLinhaX)
								aLinha[aScan(aLinha, {|x| x[1] == "C6_ITEM"}), 2] := cItem
							EndIf
	
							&&	Preenchendo/Sobrescrevendo os dados de acordo com o Doc. de Entrada utilizado para atender o Ped. Venda [Transferencia].
							nQtdVen := aPoder3[nJ, 05]
							nPrcVen := a410Arred(aPoder3[nJ, 06], "C6_PRCVEN")
	
							aLinha[aScan(aLinha, {|x| AllTrim(x[01]) == "C6_QTDVEN" }), 02] := nQtdVen
							aLinha[aScan(aLinha, {|x| AllTrim(x[01]) == "C6_PRCVEN" }), 02] := nPrcVen
							aLinha[aScan(aLinha, {|x| AllTrim(x[01]) == "C6_QTDLIB" }), 02] := nQtdVen
							aLinha[aScan(aLinha, {|x| AllTrim(x[01]) == "C6_NFORI"  }), 02] := aPoder3[nJ, 01]
							aLinha[aScan(aLinha, {|x| AllTrim(x[01]) == "C6_SERIORI"}), 02] := aPoder3[nJ, 02]
							aLinha[aScan(aLinha, {|x| AllTrim(x[01]) == "C6_ITEMORI"}), 02] := aPoder3[nJ, 04]
							aLinha[aScan(aLinha, {|x| AllTrim(x[01]) == "C6_IDENTB6"}), 02] := aPoder3[nJ, 03]
							aLinha[aScan(aLinha, {|x| AllTrim(x[01]) == "C6_PRUNIT" }), 02] := nPrcVen
						Next nJ
	
						aAdd(aItens, aLinha)
					Else
						lProcessar := .F.
						cTexto := "HLAFAT01 - Saldo de poder de terceiros insuficiente para realizar o retorno - Mov.de " + DToC(dDataBase)			+ CRLF
						cTexto += "===============================================================================================                "	+ CRLF
						cTexto += "Itens que deveriam compor o PV de retorno:                                                                     "	+ CRLF
						cTexto += "Item   Produto            Quantidade    Disponível         Falta   NF.Original   Série Original   Item Original"	+ CRLF
						cTexto += "---------------------------------------------------------------------------------------------------------------"	+ CRLF

						nPos := 0
						For nJ := 1 To Len(aItens)
							nPos ++
							cTexto += StrZero(nPos, 02)																								+ Space(05)
							cTexto += aItens[nJ, 02, 02]																							+ Space(03)
							cTexto += Transform(aItens[nJ, 03, 02],					PesqPict("SD2", "D2_QUANT"))									+ Space(03)
							cTexto += Transform(aItens[nJ, 03, 02],					PesqPict("SD2", "D2_QUANT"))									+ Space(03)
							cTexto += Transform(0,									PesqPict("SD2", "D2_QUANT"))									+ Space(03)
							cTexto += aItens[nJ, 12, 02]																							+ Space(05)
					   		cTexto += aItens[nJ, 13, 02]																							+ Space(14)
							cTexto += aItens[nJ, 14, 02]																							+ CRLF
						Next nJ
						
						For nJ := 1 To Len(aPoder3)
							nPos ++
							cTexto += StrZero(nPos, 02)																								+ Space(05)
							cTexto += aPoder3[nJ, 07]																								+ Space(03)
							cTexto += Transform(aPoder3[nJ, 05],					PesqPict("SD2", "D2_QUANT"))									+ Space(03)
							cTexto += Transform(aPoder3[nJ, 05] - aPoder3[nJ, 08],	PesqPict("SD2", "D2_QUANT"))									+ Space(03)
							cTexto += Transform(aPoder3[nJ, 08],					PesqPict("SD2", "D2_QUANT"))									+ Space(03)
							cTexto += aPoder3[nJ, 01]																								+ Space(05)
							cTexto += aPoder3[nJ, 02]																								+ Space(14)
							cTexto += aPoder3[nJ, 04]																								+ CRLF
						Next nJ
						cNomArqLog	:= "\HLAFAT01_" + DToS(Date()) + "_" +  StrTran(Time(), ":", "") + ".Log"

						MemoWrite(cNomArqLog, cTexto)   
											
						cTexto := "Saldo de poder de terceiros insuficiente para realizar o retorno:"												+ CRLF
						If Len(aPoder3) > 0 .And. Len(aItens) > 0
						   cTexto += "Item...............................: " + StrZero(Len(aItens) + Len(aPoder3), 03)									+ CRLF
						   cTexto += "Produto.........................: " + aPoder3[Len(aPoder3), 07]													+ CRLF
						   cTexto += "Quantidade faltante......: " + Transform(aPoder3[Len(aPoder3), 08], PesqPict("SD2", "D2_QUANT"))					+ CRLF + CRLF
						   cTexto += "Arquivo gerado.............: " + cNomArqLog																		+ CRLF           
						Endif
						Alert(cTexto)
						Exit
					EndIf
				Next nI

				SD2->(dbSkip())
			EndDo

			RestArea(aAliasSD2)

			If lProcessar
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
			Else
				DisarmTransaction()
			EndIf
		End Transaction
	Else
		MsgInfo("NENHUMA ação foi realizada", FunDesc())
	EndIf

	RestArea(aAliasSG1)
	RestArea(aAliasSB6)
	RestArea(aAliasSB1)
	RestArea(aAliasSD2)
	RestArea(aAliasSF2)
	RestArea(aAliasSC9)
	RestArea(aAliasSC6)
	RestArea(aAliasSC5)
	RestArea(aAliasSX1)
	RestArea(aAliasATU)
Return(lRetorno)

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

Static Function DocsPoder3(cDoc, cSerie, cCliFor, cLoja, cProduto, cItem, nQuantidad, cComp, cP3Serie, cP3Tes, cP3Local, dP3DtCor, aItens)
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
	cQuery	+=	"	D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_ITEM, D2_COD, D2_QUANT, "	+ CRLF
	cQuery	+=	"	D1_ITEM, "															+ CRLF
	cQuery	+=	"	SB1_PA.B1_REVATU, "													+ CRLF
	cQuery	+=	"	SB1.B1_DESC, SB1.B1_TS "											+ CRLF
	cQuery	+=	"FROM "																	+ CRLF
	cQuery	+=	"	"							+ RetSQLName("SD2")	+ " SD2 "			+ CRLF
	cQuery	+=	"	INNER JOIN "				+ RetSQLName("SB6")	+ " SB6 ON "		+ CRLF
	cQuery	+=	"		B6_FILIAL   = '"		+ xFilial("SB6")	+ "' AND "			+ CRLF
	cQuery	+=	"		B6_PRODUTO  = '"		+ cComp				+ "' AND "			+ CRLF
  //	cQuery	+=	"		B6_EMISSAO >= '"		+ dP3DtCor			+ "' AND "			+ CRLF
  	cQuery	+=	"		B6_EMISSAO >= '20150925' AND "			+ CRLF               //vfv 22/10/15       // ALTERADO Sr. Douglas para controle das novas nf-s
	cQuery	+=	"		B6_LOCAL IN "			+ cP3Local			+ " AND "			+ CRLF

	//If cCliFor = '000002' .AND. cLoja = '2 ' 	             
	   //cQuery	+=	"		B6_SERIE IN "			+ cSerie 		 	+ " AND "			+ CRLF
	//Else
	   cQuery	+=	"		B6_SERIE IN "			+ cP3Serie			+ " AND "			+ CRLF 
	//Endif
	
	cQuery	+=	"		B6_CLIFOR = D2_CLIENTE AND B6_LOJA = D2_LOJA AND "				+ CRLF
	cQuery	+=	"		B6_PODER3 = 'R' AND B6_TIPO = 'D' AND B6_SALDO > 0 AND "		+ CRLF  // inclusao de tratativa para nao utilizar nf sem saldo - Sr Adilson Teixeira 03/12/14
	cQuery	+=	"		B6_ESTOQUE = 'S' AND SB6.D_E_L_E_T_ = ' ' AND "					+ CRLF
	cQuery	+=	"		B6_ATEND <> 'S' AND B6_SALDO <= B6_QUANT"  						+ CRLF
	cQuery	+=	"	INNER JOIN "				+ RetSQLName("SB1")	+ " SB1 ON "		+ CRLF
	cQuery	+=	"		B1_FILIAL = '"			+ xFilial("SB1")	+ "' AND "			+ CRLF
	cQuery	+=	"		B1_COD = B6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "					+ CRLF
	cQuery	+=	"	INNER JOIN "				+ RetSQLName("SB1")	+ " SB1_PA ON "		+ CRLF
	cQuery	+=	"		SB1_PA.B1_FILIAL = '"	+ xFilial("SB1")	+"' AND "			+ CRLF
	cQuery	+=	"		SB1_PA.B1_COD = D2_COD AND SB1_PA.D_E_L_E_T_  = ' ' "			+ CRLF
	cQuery	+=	"	INNER JOIN "				+ RetSQLName("SD1")	+ " SD1 ON "		+ CRLF
	cQuery	+=	"		D1_FILIAL = '"			+ xFilial("SD1")	+ "' AND "			+ CRLF
	cQuery	+=	"		D1_IDENTB6 = B6_IDENT AND SD1.D_E_L_E_T_  = ' ' "				+ CRLF
	cQuery	+=	"WHERE "																+ CRLF
	cQuery	+=	"	D2_FILIAL = '"				+ xFilial("SD2")	+ "' AND "			+ CRLF
	cQuery	+=	"	D2_DOC = '"					+ cDoc				+ "' AND "			+ CRLF
	cQuery	+=	"	D2_SERIE = '"				+ cSerie			+ "' AND "			+ CRLF
	cQuery	+=	"	D2_CLIENTE = '"				+ cCliFor			+ "' AND "			+ CRLF
	cQuery	+=	"	D2_LOJA = '"				+ cLoja				+ "' AND "			+ CRLF
	cQuery	+=	"	D2_COD = '"					+ cProduto			+ "' AND "			+ CRLF
	cQuery	+=	"	D2_ITEM = '"				+ cItem				+ "' AND "			+ CRLF
	cQuery	+=	"	D2_TES IN "					+ cP3Tes			+ "  AND "			+ CRLF
	cQuery	+=	"	SD2.D_E_L_E_T_ = ' ' "												+ CRLF
	cQuery	+=	"ORDER BY "																+ CRLF
	cQuery	+=	"	B6_FILIAL, B6_EMISSAO, B6_DOC, B6_SERIE, D1_ITEM "					+ CRLF

	MemoWrite("\HLAFAT01_P3.sql", cQuery)
	
	TcQuery cQuery Alias (cTabelaSQL) New

	TcSetField(cTabelaSQL, "B6_EMISSAO",	"D"														)
	TcSetField(cTabelaSQL, "B6_SALDO",		"N", TamSx3("B6_SALDO")[1],		TamSx3("B6_SALDO")[2]	)
	TcSetField(cTabelaSQL, "B6_QULIB",		"N", TamSx3("B6_QULIB")[1],		TamSx3("B6_QULIB")[2]	)
	TcSetField(cTabelaSQL, "B6_PRUNIT",		"N", TamSx3("B6_PRUNIT")[1],	TamSx3("B6_PRUNIT")[2]	)
	TcSetField(cTabelaSQL, "D2_QUANT",		"N", TamSx3("D2_QUANT")[1],		TamSx3("D2_QUANT")[2]	)

	(cTabelaSQL)->(DbGoTop())
	Do While !(cTabelaSQL)->(Eof())		
		&& Verifica a qtde disponível para devolução
		nSaldoDoc	:=	(cTabelaSQL)->B6_SALDO - (cTabelaSQL)->B6_QULIB - DescUsado((cTabelaSQL)->B6_DOC, (cTabelaSQL)->B6_SERIE, (cTabelaSQL)->D1_ITEM, (cTabelaSQL)->B6_IDENT, aItens)
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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NFJaUsado³ Autor ³ Fabricio M Vieira     ³ Data ³ 24/04/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ TOTVS IP Campinas³Contato ³ cps.fabriciom@totvs.com.br     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Subtracao da quantidade JA CONSUMIDA neste Ped. Venda, para³±±
±±³          ³ ESTE Documento de Poder 3o.                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÅÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function NFJaUsado(cDoc, cSerie, cCliente, cLoja)
	Local	aAliasATU	:=	GetArea()
	Local	aAliasSC6	:=	SC6->(	GetArea())
	Local	cTabelaSQL	:=	"TSC601"
	Local	lRetorno	:=	.F.
	Local	cQuery		:=	""

	cQuery	:=	"Select "											+ CRLF
	cQuery	+=	"	C6_NUM "										+ CRLF
	cQuery	+=	"From "												+ CRLF
	cQuery	+=	"	"				+RetSQLName("SC6")+	" SC6 "		+ CRLF
	cQuery	+=	"Where "											+ CRLF
	cQuery	+=	"	C6_FILIAL  = '"	+xFilial("SC6")+	"' And "	+ CRLF
	cQuery	+=	"	C6_NFFATUR = '"	+cDoc+				"' And "	+ CRLF
	cQuery	+=	"	C6_NFSERIE = '"	+cSerie+			"' And "	+ CRLF
	cQuery	+=	"	C6_CLI     = '"	+cCliente+			"' And "	+ CRLF
	cQuery	+=	"	C6_LOJA    = '"	+cLoja+				"' And "	+ CRLF
	cQuery	+=	"	SC6.D_E_L_E_T_ = ' ' "							+ CRLF
	cQuery	+=	"Order By "											+ CRLF
	cQuery	+=	"	C6_FILIAL, "									+ CRLF
	cQuery	+=	"	C6_NUM "										+ CRLF

	MemoWrite("\HLAFAT01_PV.sql", cQuery)

	TcQuery cQuery Alias (cTabelaSQL) New

	If !(cTabelaSQL)->(Eof())
		lRetorno	:=	.T.
		MsgStop("Nota Fiscal informada JA UTILIZADO no Ped. Venda de Retorno de Remessa p/ Industrializacao ["+(cTabelaSQL)->C6_NUM+"].", FunDesc())
	EndIf

	(cTabelaSQL)->(DbCloseArea())

	RestArea(aAliasSC6)
	RestArea(aAliasATU)
Return(lRetorno)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ValidPerg ³ Autor ³ Fabricio M Vieira     ³ Data ³ 11/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Validacao do Grupo de Perguntas [SX1] utilizado pela rotina³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValidPerg(cPerg)
	Local lRetorno := .T.

	PutSx1(cPerg,"01","Nota Fiscal ?",	"Nota Fiscal ?",	"Nota Fiscal ?",	"mv_ch1","C",09,0,0,"G","",""/*SA1*/,	"018"	,"","MV_PAR01","","","","","","","","","","","","","")
	PutSx1(cPerg,"02","Serie ?",		"Serie ?",			"Serie ?",			"mv_ch2","C",03,0,0,"C","",""/*SA1*/,	""		,"","MV_PAR02","","","","","","","","","","","","","")
	PutSx1(cPerg,"03","Cliente ?",		"Cliente ?",		"Cliente ?",		"mv_ch2","C",06,0,0,"C","","SA1",		"001"	,"","MV_PAR03","","","","","","","","","","","","","")
	PutSx1(cPerg,"04","Loja ?",			"Loja ?",			"Loja ?",			"mv_ch2","C",02,0,0,"C","",""/*SA1*/,	"002"	,"","MV_PAR04","","","","","","","","","","","","","")
Return(lRetorno)
