#Include "rwmake.ch"
#Include "protheus.ch"
#include "prtopdef.ch"

/*/{Protheus.doc} PE01NFESEFAZ
	Ponto de Entrada no momento da geração da transmição da documento de saída para a SEFAZ
	@param não possui
	@return não possui
	@since 15/03/2024
/*/
User Function PE01NFESEFAZ()
	Local aProd      := PARAMIXB[1]
	Local cMensCli   := PARAMIXB[2]
	Local cMensFis   := PARAMIXB[3]
	Local aDest      := PARAMIXB[4]
	Local aNota      := PARAMIXB[5]
	Local aInfoItem  := PARAMIXB[6]
	Local aDupl      := PARAMIXB[7]
	Local aTransp    := PARAMIXB[8]
	Local aEntrega   := PARAMIXB[9]
	Local aRetirada  := PARAMIXB[10]
	Local aVeiculo   := PARAMIXB[11]
	Local aReboque   := PARAMIXB[12]
	Local aNfVincRur := PARAMIXB[13]
	Local aEspVol    := PARAMIXB[14]
	Local aNfVinc    := PARAMIXB[15]
	Local aDetPag    := PARAMIXB[16]
	Local aObsCont   := PARAMIXB[17]
	Local aRetorno   := {}
	Local aArea      := GetArea()
	Local nX, nPos
	Local aAreaSd2   := SD2->(GetArea())
	Local aAreaSc6   := SC6->(GetArea())
	Local aItensAglu := aClone(aProd)
	Local nSeqItem   := 0

	/*
	Inicializa variáveis locais de arrays para armazenar dados fiscais e comerciais de produtos.
	Este trecho verifica se a variável global 'aMulti' existe e, se existir, atribui seus elementos
	aos arrays locais correspondentes. Caso contrário, cria arrays vazios com tamanho igual ao número
	de produtos em 'aProd'.

	Arrays inicializados:
	- aICMS: Dados de ICMS (Imposto sobre Circulação de Mercadorias e Serviços)
	- aICMSST: ICMS Substituição Tributária
	- aIPI: IPI (Imposto sobre Produtos Industrializados)
	- aPIS: PIS (Programa de Integração Social)
	- aPISST: PIS Substituição Tributária
	- aCOFINS: COFINS (Contribuição para Financiamento da Seguridade Social)
	- aCOFINSST: COFINS Substituição Tributária
	- aISSQN: ISS/QN (Imposto Sobre Serviços)
	- aCST: CST (Código de Situação Tributária)
	- aMed: Medidas/Unidades de medida
	- aArma: Armazenamento/Depósitos
	- aveicProd: Veículos de Produto
	- aDI: Declaração de Importação
	- aAdi: Informações Adicionais de DI
	- aExp: Informações de Exportação
	- aPisAlqZ: PIS com Alíquota Zero
	- aCofAlqZ: COFINS com Alíquota Zero
	- aAnfI: Informações de ANFIS
	- aComb: Combustíveis
	- aCsosn: CSOSN (Código de Situação da Operação no Simples Nacional)
	- aPedCom: Pedidos de Compra
	- aICMSZFM: ICMS Zona Franca de Manaus
	- aFCI: FCI (Fiscal de Crédito do Importador)
	- aAgrPis: Agregados de PIS
	- aAgrCofins: Agregados de COFINS
	- aICMUFDest: ICMS UF Destino
	- aIPIDevol: IPI Devolução
	- aItemVinc: Itens Vinculados
	- aLote: Informações de Lotes
	- aIBSCBS: Informações IBSCBS
	*/
	Local aICMS      := If( Type("aMulti") <> "U", aMulti[01], AFill(Array(Len(aProd)),{}))
	Local aICMSST    := If( Type("aMulti") <> "U", aMulti[02], AFill(Array(Len(aProd)),{}))
	Local aIPI       := If( Type("aMulti") <> "U", aMulti[03], AFill(Array(Len(aProd)),{}))
	Local aPIS       := If( Type("aMulti") <> "U", aMulti[04], AFill(Array(Len(aProd)),{}))
	Local aPISST     := If( Type("aMulti") <> "U", aMulti[05], AFill(Array(Len(aProd)),{}))
	Local aCOFINS    := If( Type("aMulti") <> "U", aMulti[06], AFill(Array(Len(aProd)),{}))
	Local aCOFINSST  := If( Type("aMulti") <> "U", aMulti[07], AFill(Array(Len(aProd)),{}))
	Local aISSQN     := If( Type("aMulti") <> "U", aMulti[08], AFill(Array(Len(aProd)),{}))
	Local aCST       := If( Type("aMulti") <> "U", aMulti[09], AFill(Array(Len(aProd)),{}))
	Local aMed       := If( Type("aMulti") <> "U", aMulti[10], AFill(Array(Len(aProd)),{}))
	Local aArma      := If( Type("aMulti") <> "U", aMulti[11], AFill(Array(Len(aProd)),{}))
	Local aveicProd  := If( Type("aMulti") <> "U", aMulti[12], AFill(Array(Len(aProd)),{}))
	Local aDI        := If( Type("aMulti") <> "U", aMulti[13], AFill(Array(Len(aProd)),{}))
	Local aAdi       := If( Type("aMulti") <> "U", aMulti[14], AFill(Array(Len(aProd)),{}))
	Local aExp       := If( Type("aMulti") <> "U", aMulti[15], AFill(Array(Len(aProd)),{}))
	Local aPisAlqZ   := If( Type("aMulti") <> "U", aMulti[16], AFill(Array(Len(aProd)),{}))
	Local aCofAlqZ   := If( Type("aMulti") <> "U", aMulti[17], AFill(Array(Len(aProd)),{}))
	Local aAnfI      := If( Type("aMulti") <> "U", aMulti[18], AFill(Array(Len(aProd)),{}))
	Local aComb      := If( Type("aMulti") <> "U", aMulti[19], AFill(Array(Len(aProd)),{}))
	Local aCsosn     := If( Type("aMulti") <> "U", aMulti[20], AFill(Array(Len(aProd)),{}))
	Local aPedCom    := If( Type("aMulti") <> "U", aMulti[21], AFill(Array(Len(aProd)),{}))
	Local aICMSZFM   := If( Type("aMulti") <> "U", aMulti[22], AFill(Array(Len(aProd)),{}))
	Local aFCI       := If( Type("aMulti") <> "U", aMulti[23], AFill(Array(Len(aProd)),{}))
	Local aAgrPis    := If( Type("aMulti") <> "U", aMulti[24], AFill(Array(Len(aProd)),{}))
	Local aAgrCofins := If( Type("aMulti") <> "U", aMulti[25], AFill(Array(Len(aProd)),{}))
	Local aICMUFDest := If( Type("aMulti") <> "U", aMulti[26], AFill(Array(Len(aProd)),{}))
	Local aIPIDevol  := If( Type("aMulti") <> "U", aMulti[27], AFill(Array(Len(aProd)),{}))
	Local aItemVinc  := If( Type("aMulti") <> "U", aMulti[28], AFill(Array(Len(aProd)),{}))
	Local aLote      := If( Type("aMulti") <> "U", aMulti[29], AFill(Array(Len(aProd)),{}))

	Local aICMSAglu   := aClone(aICMS)
	Local aPISAglu    := aClone(aPIS)
	Local aCOFINSAglu := aClone(aCOFINS)
	Local aCSTAglu    := aClone(aCST)
	Local aPISAAglu   := aClone(aPisAlqZ)
	Local aCOFAAglu   := aClone(aCofAlqZ)
	Local aCsosnAglu  := aClone(aCsosn)
	Local aPedComAglu := aClone(aPedCom)
	Local aAgrPisAglu := aClone(aAgrPis)
	Local aAgrCofAglu := aClone(aAgrCofins)

	//Valida se é uma nota de Saida
	If aNota[4] == "1" .and. SF2->F2_TIPO == "N"
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))

		aItensAglu  := {}
		aICMSAglu   := {}
		aPISAglu    := {}
		aCOFINSAglu := {}
		aCSTAglu    := {}
		aPISAAglu   := {}
		aCOFAAglu   := {}
		aCsosnAglu  := {}
		aAgrPisAglu := {}
		aAgrCofAglu := {}

		//Percorre os itens da nota
		For nX := 1 To Len(aProd)
			// Posiciona no cadastro do produto
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(XFILIAL("SB1")+aProd[nX,2]))

			//Posiciona no Item do vetor aProd para verificar informações do item da nota
			SD2->(DbSetOrder(3))
			If SD2->(DbSeek(xfilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+aProd[nX,2]+aInfoItem[nX,4]))
				SF4->(DbSetOrder(1))
				SF4->(dbSeek(xFilial("SF4") + SD2->D2_TES ))

				SC6->(DbSetOrder(2))
				If SC6->(dbSeek(xFilial("SC6") + SD2->D2_COD + SD2->D2_PEDIDO + SD2->D2_ITEMPV ))

					aProd[nX,4] := ""
					aProd[nX,4] += AddConteudo(aProd[nX,4],If( Empty(SC6->C6_DESCRI) , SB1->B1_DESC, SC6->C6_DESCRI))

					aProd[nX][16] := SD2->D2_PRCVEN    // Atribui preço gravado na nota fiscal
					//Realiza a aglutinaçao dos itens com o mesmo codigo de produto, mesmo cfop, mesma TES, mesmo percentual de ICM e mesmo preço unitario
					// x[02] = Codigo do produto
					// x[07] = CFOP
					// x[27] = TES
					// x[33] = % ICMS
					// x[16] = Valor unitário
					nPos := AScan(aItensAglu, {|x|x[04] == aProd[nX][04] .And. x[07] == aProd[nX][07] .And. x[27] == aProd[nX][27] .And.;
						x[33] == aProd[nX][33] .And. x[16] == aProd[nX][16] })
					If nPos > 0
						//Realiza as somas do item encontrado
						aItensAglu[nPos][09] += aProd[nX][09] //Quantidade
						aItensAglu[nPos][10] += aProd[nX][10] //Total
						aItensAglu[nPos][12] += aProd[nX][12] //Qtd B5_CONVDIP
						aItensAglu[nPos][13] += aProd[nX][13] //Frete
						aItensAglu[nPos][14] += aProd[nX][14] //Seguro
						aItensAglu[nPos][15] += aProd[nX][15] //Desconto
						aItensAglu[nPos][30] += aProd[nX][30] //Total Imposto carga tributaria
						aItensAglu[nPos][31] += aProd[nX][31] //Desconto Zona Franca PIS
						aItensAglu[nPos][32] += aProd[nX][32] //Desconto Zona Franca CONFINS
						aItensAglu[nPos][35] += aProd[nX][35] //Total carga tributária Federal
						aItensAglu[nPos][36] += aProd[nX][36] //Total carga tributária Estadual
						aItensAglu[nPos][37] += aProd[nX][37] //Total carga tributária Municipal

						If !Empty(aICMSAglu[nPos])
							aICMSAglu[nPos][5] += aICMS[nX][5]     //Base de Cálculo do ICMS
							aICMSAglu[nPos][7] += aICMS[nX][7]     //Valor do ICMS
							aICMSAglu[nPos][9] += aICMS[nX][9]     //Quantidade tributada
						Endif

						If !Empty(aPISAglu[nPos])
							aPISAglu[nPos][2] += aPIS[nX][2]     //Base de Cálculo do PIS
							aPISAglu[nPos][4] += aPIS[nX][4]     //Valor do PIS
							aPISAglu[nPos][5] += aPIS[nX][5]     //Quantidade tributada
						Endif

						If !Empty(aCOFINSAglu[nPos])
							aCOFINSAglu[nPos][2] += aCOFINS[nX][2]     //Base de Cálculo do PIS
							aCOFINSAglu[nPos][4] += aCOFINS[nX][4]     //Valor do PIS
							aCOFINSAglu[nPos][5] += aCOFINS[nX][5]     //Quantidade tributada
						Endif

					Else
						//Para reorganizar a numeraçao dos itens
						nSeqItem := Len(aItensAglu)

						AAdd(aItensAglu,aProd[nX])

						//Para reorganizar a numeraçao dos itens
						nPos := Len(aItensAglu)
						aItensAglu[nPos][1] := nSeqItem + 1

						// Aglutina as demais variáveis de controle dos itens
						AAdd( aICMSAglu   , aICMS[nX]     )
						AAdd( aPISAglu    , aPIS[nX]      )
						AAdd( aCOFINSAglu , aCOFINS[nX]   )
						AAdd( aCSTAglu    , aCST[nX]      )
						AAdd( aPISAAglu   , aPisAlqZ[nX]  )
						AAdd( aCOFAAglu   , aCofAlqZ[nX]  )
						AAdd( aCsosnAglu  , aCsosn[nX]    )
						AAdd( aAgrPisAglu , aAgrPis[nX]   )
						AAdd( aAgrCofAglu , aAgrCofins[nX])
					EndIf
				Endif
			Endif
		Next nX

	Else
		For nX := 1 to Len(aProd)
			// Posiciona no cadastro do produto
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(XFILIAL("SB1")+aProd[nX,2]))

			SD1->(DbSetOrder(1))
			If SD1->(DbSeek(XFILIAL("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+aProd[nX,2]+aInfoItem[nX,4]))
			Endif

		Next nX
	EndIf

	aadd(aRetorno,aItensAglu)
	aadd(aRetorno,cMensCli)
	aadd(aRetorno,cMensFis)
	aadd(aRetorno,aDest)
	aadd(aRetorno,aNota)
	aadd(aRetorno,aInfoItem)
	aadd(aRetorno,aDupl)
	aadd(aRetorno,aTransp)
	aadd(aRetorno,aEntrega)
	aadd(aRetorno,aRetirada)
	aadd(aRetorno,aVeiculo)
	aadd(aRetorno,aReboque)
	aadd(aRetorno,aNfVincRur)
	aadd(aRetorno,aEspVol)
	aadd(aRetorno,aNfVinc)
	aadd(aRetorno,aDetPag)
	aadd(aRetorno,aObsCont)

	If Type("aMulti") <> "U"
		aMulti := {}
		AAdd( aMulti , aICMSAglu   )
		AAdd( aMulti , aICMSST     )
		AAdd( aMulti , aIPI        )
		AAdd( aMulti , aPISAglu    )
		AAdd( aMulti , aPISST      )
		AAdd( aMulti , aCOFINSAglu )
		AAdd( aMulti , aCOFINSST   )
		AAdd( aMulti , aISSQN      )
		AAdd( aMulti , aCSTAglu    )
		AAdd( aMulti , aMed        )
		AAdd( aMulti , aArma       )
		AAdd( aMulti , aveicProd   )
		AAdd( aMulti , aDI         )
		AAdd( aMulti , aAdi        )
		AAdd( aMulti , aExp        )
		AAdd( aMulti , aPISAAglu   )
		AAdd( aMulti , aCOFAAglu   )
		AAdd( aMulti , aAnfI       )
		AAdd( aMulti , aComb       )
		AAdd( aMulti , aCsosnAglu  )
		AAdd( aMulti , aPedComAglu )
		AAdd( aMulti , aICMSZFM    )
		AAdd( aMulti , aFCI        )
		AAdd( aMulti , aAgrPisAglu )
		AAdd( aMulti , aAgrCofAglu )
		AAdd( aMulti , aICMUFDest  )
		AAdd( aMulti , aIPIDevol   )
		AAdd( aMulti , aItemVinc   )
		AAdd( aMulti , aLote       )
	Endif

	RestArea(aArea)
	RestArea(aAreaSd2)
	RestArea(aAreaSc6)

RETURN aRetorno

Static Function AddConteudo(cString,cConteudo,cSepara)
	Default cSepara := " - "
Return If( Empty(cString) .Or. Empty(cConteudo) , "", cSepara) + AllTrim(cConteudo)

