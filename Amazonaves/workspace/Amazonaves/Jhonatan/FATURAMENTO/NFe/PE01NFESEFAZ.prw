#Include "rwmake.ch"
#Include "protheus.ch"

//----------------------------------------------------------
/*/{Protheus.doc} PE01NFESEFAZ
Ponto de Entrada no momento da gera  o da transmi  o da documento de sa da para a SEFAZ
@param n o possui
@return n o possui
@since 20/06/2014
@author Arlindo Neto
@project Implanta  o FormaPack
/*/
//----------------------------------------------------------
//                                                                               */

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
	Local AdetPag    := PARAMIXB[16]
	Local aObsCont   := PARAMIXB[17]
	Local aRetorno   := {}
	Local aArea      := GetArea()
	Local nX
	Local aAreaSd2   := SD2->(GetArea())
	Local aAreaSc6   := SC6->(GetArea())
	//Local cPedidos   := "N m.Pedido(s): "
	
	//Valida se   uma nota de Saida
	If aNota[4] == "1"
		/*If !(SF2->F2_TIPO $ "DB")
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
			
			aDest[2] := Trim(SA1->A1_COD) + " - " + Trim(SA1->A1_NOME) + " (" + Trim(SA1->A1_NREDUZ) + ")"
		Else
			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA))
			
			aDest[2] := Trim(SA2->A2_COD) + " - " + Trim(SA2->A2_NOME) + " (" + Trim(SA2->A2_NREDUZ) + ")"
		Endif*/
		
		//Percorre os itens da nota
		For nX := 1 to Len(aProd)
			// Posiciona no cadastro do produto
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(XFILIAL("SB1")+aProd[nX,2]))
			
			aProd[nX,25] := AllTrim(aProd[nX,25])
			
			//Posiciona no Item do vetor aProd para verificar informa  es do item da nota
			SD2->(DbSetOrder(3))
			If SD2->(DbSeek(xfilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+aProd[nX,2]+aInfoItem[nX,4]))
				// Posiciona no Pedido de Venda
				SC5->(DbSetOrder(1))
				SC5->(dbSeek(xFilial("SC5") + SD2->D2_PEDIDO ))
				
				// Posiciona no Cadastro do TES
				SF4->(DbSetOrder(1))
				SF4->(dbSeek(xFilial("SF4") + SD2->D2_TES ))
				
				// Posiciona no Item do Pedido de Venda
				SC6->(DbSetOrder(2))
				If SC6->(dbSeek(xFilial("SC6") + SD2->D2_COD + SD2->D2_PEDIDO + SD2->D2_ITEMPV ))
					//aProd[nX,25] += AddConteudo(aProd[nX,25],If( Empty( SC6->C6_PEDCLI ) , "", "PED.C: " + Trim(SC6->C6_PEDCLI )), ", " ) //Claudio franca 2020/02/03
					//aProd[nX,25] += AddConteudo(aProd[nX,25],If( Empty( SC6->C6_XLINPED ) , "", "ITEM.P.C: " + Trim(SC6->C6_XLINPED )), ", " ) //Claudio franca 2020/02/03
				Endif

				// Posiciona no Configurador de Tributos
				F2D->(DbSetOrder(2))
				If F2D->(dbSeek(xFilial("F2D") + SD2->D2_IDTRIB ))
					While xFilial("F2D") == F2D->F2D_FILIAL .AND. F2D->F2D_IDREL == SD2->D2_IDTRIB
					//aProd[nX,25] += AddConteudo(aProd[nX,25],If( Empty( SC6->C6_PEDCLI ) , "", "PED.C: " + Trim(SC6->C6_PEDCLI )), ", " ) //Claudio franca 2020/02/03
					//aProd[nX,25] += AddConteudo(aProd[nX,25],If( Empty( SC6->C6_XLINPED ) , "", "ITEM.P.C: " + Trim(SC6->C6_XLINPED )), ", " ) //Claudio franca 2020/02/03
						F2D->(DbSkip())
					enddo
				Endif

				//cPedidos := SD2->D2_PEDIDO
				
				
				If !Empty(SB1->B1_XPARTNU)                                           // Codigo Partnumber
					aProd[nX,25] += " (Partnumber: "+AllTrim(SB1->B1_XPARTNU)+")"
				Endif
				
	
				/*aProd[nX,25] += AddConteudo(aProd[nX,25],If( Empty( SB1->B1_XONU    ) , "", "ONU: " + LTrim(Str(SB1->B1_XONU))), ", " )
				aProd[nX,25] += AddConteudo(aProd[nX,25],If( Empty( SB1->B1_XRISCO  ) , "", "N.RISCO: " + LTrim(Str(SB1->B1_XRISCO))), ", " )
				aProd[nX,25] += AddConteudo(aProd[nX,25],If( Empty( SB1->B1_XCLARIS ) , "", "CLAS RISCO: " + Trim(SB1->B1_XCLARIS)), ", " )
				aProd[nX,25] += AddConteudo(aProd[nX,25],If( Empty( SB1->B1_XGREMBA ) , "", "GRP EMB: " + Trim(SB1->B1_XGREMBA)), ", " )
				aProd[nX,25] += AddConteudo(aProd[nX,25],If( Empty( SD2->D2_LOTECTL ) , "", "LOTE: " + Trim(SD2->D2_LOTECTL)), ", " )
				aProd[nX,25] += AddConteudo(aProd[nX,25],If( Empty( SD2->D2_DTVALID ) , "", "VALIDADE: " + DtoC(SD2->D2_DTVALID)), ", " )
				aProd[nX,25] += AddConteudo(aProd[nX,25],If( Empty( SD2->D2_XDTFABL ) , "", "DT FABRIC: " + DtoC(SD2->D2_XDTFABL)), ", " )*/
			Endif
			
		Next nX
		
		
		
		//Faz a impress o da mensagem da nota
		/*cMensCli +=" || "+ AllTrim(SF2->F2_XMSGNF) +" || "
		cMensCli += "||"+" EM CUMPRIMENTO AO DISPOSTO DO DECRETO 96044/88, EM SEU ARTIGO 22/11 CERTIFICAMOS QUE O (S) PRODUTO (S) ESTA (AO) ADEQUADAMENTE ACONDICIONADO (S) PARA SUPORTAR (EM) OS RISCOS NORMAIS DE CARREGAMENTO, TRANSPORTE E CARREGAMENTO. INSTRUCAO NORMATIVA RFB N  1.009/2010" +"||"
		cMensCli += AddConteudo(cMensCli," Vendedor: " + Trim(SF2->F2_VEND1) + "-" + Trim(Posicione("SA3",1,XFILIAL("SA3")+SF2->F2_VEND1,"A3_NOME")))
		cMensCli += AddConteudo(cMensCli,If( Empty(SF2->F2_XISTQ)  , "", " ISTQ: " + Trim(SF2->F2_XISTQ)))
		cMensCli += AddConteudo(cMensCli,If( Empty(SF2->F2_XLACRE) , "", " LACRE: " + Trim(SF2->F2_XLACRE)))
		cMensCli +=" Pedido de Venda : "+cPedidos*/
		
	EndIf

	//Valida se é uma nota de Entrada
	If aNota[4] == "0"

		//Percorre os itens da nota
		For nX := 1 to Len(aProd)
			// Posiciona no cadastro do produto
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(XFILIAL("SB1")+aProd[nX,2]))
			
			aProd[nX,25] := AllTrim(aProd[nX,25])
			
			//Posiciona no Item do vetor aProd para verificar informa  es do item da nota
			SD1->(DbSetOrder(1))
			If SD1->(DbSeek(xfilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+aProd[nX,2]+aInfoItem[nX,4]))
				
				// Posiciona no Cadastro do TES
				SF4->(DbSetOrder(1))
				SF4->(dbSeek(xFilial("SF4") + SD1->D1_TES ))

				// Posiciona no Configurador de Tributos
				F2D->(DbSetOrder(2))
				If F2D->(dbSeek(xFilial("F2D") + SD1->D1_IDTRIB ))
					While xFilial("F2D") == F2D->F2D_FILIAL .AND. F2D->F2D_IDREL == SD1->D1_IDTRIB
											F2D->(DbSkip())
					enddo
				Endif				
				
				If !Empty(SB1->B1_XPARTNU) // Codigo Partnumber
					aProd[nX,25] += " (Partnumber: "+AllTrim(SB1->B1_XPARTNU)+")"
				Endif

			Endif
			
		Next nX

		If !Empty(SF1->F1_XNDI)
			cMensCli += " (DI: "+AllTrim(SF1->F1_XNDI)+")"
		Endif
				
	EndIf
	
	aadd(aRetorno,aProd)
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
	aadd(aRetorno,AdetPag)
	aadd(aRetorno,aObsCont)
	
	RestArea(aArea)
	RestArea(aAreaSd2)
	RestArea(aAreaSc6)
	
RETURN aRetorno

/*Static Function AddConteudo(cString,cConteudo,cSepara)
	Default cSepara := " - "
Return If( Empty(cString) .Or. Empty(cConteudo) , "", cSepara) + AllTrim(cConteudo)*/
