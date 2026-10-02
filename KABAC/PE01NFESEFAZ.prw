//Bibliotecas
#Include "TOTVS.ch"
/*/ PROJETO AJUSTE GO LIVE NOTA DE SAIDA KTM/*/ 
//Faturamento - TAG automotiva- Notas Importadas (2418)
/*/{Protheus.doc} User Function PE01NFESEFAZ
Ponto de entrada antes da montagem dos dados da transmissão da NFE
@type  Function
@author Raphael Rage
@since 23/04/2024
@see https://centraldeatendimento.totvs.com/hc/pt-br/articles/4404432005655--Cross-Segmentos-Backoffice-Protheus-Doc-Eletr%C3%B4nicos-Ponto-de-entrada-no-NFESEFAZ-PE01NFESEFAZ
@obs Posições do Array:
    [01] = aProd
    [02] = cMensCli
    [03] = cMensFis
    [04] = aDest
    [05] = aNota
    [06] = aInfoItem
    [07] = aDupl
    [08] = aTransp
    [09] = aEntrega
    [10] = aRetirada
    [11] = aVeiculo
    [12] = aReboque
    [13] = aNfVincRur
    [14] = aEspVol
    [15] = aNfVinc
    [16] = aDetPag
    [17] = aObsCont
    [18] = aProcRef
    [19] = aMed
    [20] = aLote
/*/
 
User Function PE01NFESEFAZ()
	Local nX, cSeek
	Local aArea      := FWGetArea()
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
	Local aProcRef   := PARAMIXB[18]
	Local aMed       := PARAMIXB[19]
	Local aLote      := PARAMIXB[20]
	Local aRetorno   := {}
	// Local cUF_Suframa:= Alltrim(GetMv("BJ_SUFR_UF",.F.,"AM;AP;RR"))//UF para mensagem da Suframa 
	// Local cTS_Suframa:= Alltrim(GetMv("BJ_SUFR_TS",.F.,"701"))//Tipo de Saida (TES) para mensagem da Suframa 
	// Local cTS_Alienac:= Alltrim(GetMv("BJ_MSG_ALI",.F.,"501#503#504#502#529#537#538#530#596#600"))//Tipo de Saida (TES) para mensagem de Alienação 
	// Local cTS_41_2019:= Alltrim(GetMv("BJ_41_2029",.F.,"501#503#504#502#529#537#538#530#596#600"))//TES Decreto ICMS 41/2019
	
	If aNota[4] == "1"
	
		//Posiciona no cadastro do Cliente/Fornecedor
		if Alltrim(SF2->F2_Tipo) $ "D/B"
			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA))
		else
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
			
			// IF 	SA1->(FieldPos(A1_XEMAIL)) > 0 				
			// 	//AJUSTE DO EMAIL PARA O COMPLEMENTAR
			// 	aDest[16] := ALLTRIM(StrTran(aDest[16],",",";"))+ ";" +ALLTRIM(SA1->A1_XEMAIL)
			// ENDIF 

		endif 
		
	
		//Percorre os itens da nota
		For nX := 1 to Len(aProd)
			// Posiciona no cadastro do produto
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(XFILIAL("SB1")+aProd[nX,2]))
			
			//Posiciona no Item do vetor aProd para verificar informações do item da nota
			SD2->(DbSetOrder(3))
			If SD2->(DbSeek(xfilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+aProd[nX,2]+aInfoItem[nX,4]))

				// SC5->(DbSetOrder(1))
				// If SC5->(dbSeek(xFilial("SC5")  + SD2->D2_PEDIDO )) .and. nX == 1 .And. SC5->C5_FILIAL =='03' .AND. !Empty(SC5->C5_XPEDORI)
				// 	//cMensCli := "PEDIDO_SUPORTE: " + Alltrim(str(val(SC5->C5_NUM))) + (SC5->C5_XVERSAO)   + ' ' + cMensCli + ' '+ (SC5->C5_XPEDORI)
				// 	//cMensCli := "PEDIDO_SUPORTE: " + Alltrim(SF2->F2_ORDSEP)   + ' ' + cMensCli + ' '+ ALLTRIM(SC5->C5_XPEDORI) + ' .'
				// 	If !findfunction("U_BJFTP12C") 
				// 		cMensCli := "PEDIDO_SUPORTE: " + Alltrim(SF2->F2_XCONFSE)   + ' ' + cMensCli + ' '+ ALLTRIM(SC5->C5_XPEDORI) + ' .'
				// 	else 
				// 		cMensCli := "PEDIDO_SUPORTE: " + cValToChar(GetDtoVal(SF2->F2_XCONFSE))   + ' ' + cMensCli + ' '+ U_BJFTP12C(SF2->F2_FILIAL,SF2->F2_XCONFSE,!Empty(SC5->C5_XORDSEP)) + ' .'
				// 	Endif 
				// Endif
				
				/*  JÁ ESTAVA DESATIVADO  ANTES DE COLOCAR NO RPO KABAC/PE01NFESEFAZ.PRW  
				// If nX == 1 .And. SD2->D2_FILIAL =='01' .AND. Alltrim(SD2->D2_TES) $ cTS_41_2019 //'501#504#502#529#530'   // ICMS N 41/2019  Necessário verificar parâmetro, visto que não tem regra fixa.
				// 	cMensCli += " NFE EMITIDA NOS TERMOS DO CONVENIO ICMS N 41/2019.  MERC PRODUZIDA NA ZONA "
				// 	cMensCli += "FRANCA DE MANAUS. RESOLUCAO DE SUFRAMA 268 DE 12.12.2023 MODALIDADE DE"
				// 	cMensCli += " INTERNACAO DCI MENSAL. IPI ISENTO CONFORME ART 81 DECRETO 7212/2010" 
				// 	cMensCli += " BASE PIS-ST :" + Alltrim(Transform(SD2->D2_BASIMP6,"@E 999,999,999.99")) + " VALOR PIS: "  +Alltrim(Transform(SD2->D2_VALIMP6,"@E 999,999,999.99"))+ " BASE COFINS-ST: " +Alltrim(Transform(SD2->D2_BASIMP5,"@E 999,999,999.99"))+ " VALOR COFINS: "+ Alltrim(Transform(SD2->D2_VALIMP5,"@E 999,999,999.99"))
				// EnDIF*/ 

				/*/ Mensagem Decreto 41/2019 - Suframa /*/
				// If nX == 1 .And. SD2->D2_FILIAL =='01' .AND. (Alltrim(SD2->D2_TES) $ cTS_41_2019 .or. ( Alltrim(SD2->D2_EST)$ cUF_Suframa .and. Alltrim(SD2->D2_TES) $ cTS_Suframa))  .and. !( Alltrim(SF2->F2_TIPO) $ "D/B")  
					// cMensCli += iif( !Empty(SA1->A1_SUFRAMA) , "CADASTRO SUFRAMA: "+SA1->A1_SUFRAMA+"." ,"")
					// cMensCli += " NFE EMITIDA NOS TERMOS DO CONVENIO ICMS N 41/2019. MERC PRODUZIDA NA ZONA"
					// cMensCli += "FRANCA DE MANAUS. RESOLUCAO DE SUFRAMA 268 DE 12.12.2023 MODALIDADE DE"
					// cMensCli += " INTERNACAO DCI MENSAL. IPI ISENTO CONFORME ART 81 DECRETO 7212/2010 "
					// If FWCodEmp() != "02"
					// 	cMensCli += "BASE PIS-ST:"+Alltrim(Transform(SF2->F2_BASEPS3,"@E 999,999,999.99"))+"  VALOR PIS: "+Alltrim(Transform(SF2->F2_VALPS3,"@E 999,999,999.99"))+"  BASE COFINS-ST:"+Alltrim(Transform(SF2->F2_BASECF3,"@E 999,999,999.99"))+" VALOR COFINS: "+Alltrim(Transform(SF2->F2_VALCF3,"@E 999,999,999.99"))+" "
					// Endif 
					// If !Empty(SA1->A1_MENSAGE) .and. !( SA1->(Formula(A1_MENSAGE)) $ cMensCli )
					// 	cMensCli += SA1->(Formula(A1_MENSAGE))
					// ENDIF 
				// EnDIF
				//Se empresa 02 ktm imprime Base de PIS e Confins para todas as Filiais se existir 
				// If FWCodEmp() == "02" .and. nX == 1 
					// cMensCli += iif(!Empty(SF2->F2_BASEPS3) ," BASE PIS-ST:"	+Alltrim(Transform(SF2->F2_BASEPS3	,"@E 999,999,999.99")),'')
					// cMensCli += iif(!Empty(SF2->F2_VALPS3)  ," VALOR PIS-ST: "  	+Alltrim(Transform(SF2->F2_VALPS3	,"@E 999,999,999.99")),'')
					// cMensCli += iif(!Empty(SF2->F2_BASECF3) ," BASE COFINS-ST:"	+Alltrim(Transform(SF2->F2_BASECF3	,"@E 999,999,999.99")),'')
					// cMensCli += iif(!Empty(SF2->F2_VALCF3)  ," VALOR COFINS-ST: "	+Alltrim(Transform(SF2->F2_VALCF3	,"@E 999,999,999.99")),'')
				// EndIf

				// If FWCodEmp() == "01" .and. nX == 1 .And. SD2->D2_FILIAL == '01' .AND. Alltrim(SD2->D2_TES) $ cTS_Alienac //(SD2->D2_TES == '501' .OR. SD2->D2_TES == '504') //MV_ALIENAÇÃO  
				// 	cMensCli += " ALIENADA A FINANCEIRA ALFA S.A. "
				// EndIf

				// If FWCodEmp() == "02" .and. nX == 1 .AND. Alltrim(SD2->D2_TES) $ cTS_Alienac //(SD2->D2_TES == '501' .OR. SD2->D2_TES == '504') //MV_ALIENAÇÃO  
				// 	cMensCli += " ALIENADA AO BANCO SANTANDER S.A. "
				// EndIf

				
				// If nX == 1 .And. SD2->D2_FILIAL =='01' .AND. SB1->B1_TIPO == 'PA' 
				// 	cMensCli += iif(Empty(SB1->B1_DCRE),""," DCR-e: " + SB1->B1_DCRE )
				// EnDIF

				// If  nX == 1 .And. SD2->D2_FILIAL <> '01' .AND. SD2->D2_TES $ '501#510#596#597#511' .AND. SB1->B1_TIPO == 'ME' 
				// 	if FWCodEmp() == "01" //Geração apenas para grupo de empesa Bajaj 
				// 		cMensCli += " Merc.retirada Armazém SUPPLOG ARMAZENS GERAIS E ENTREP -Rod. Presidente Castelo Branco,1100 - Bairro Jd. Maria Cristina - Barueri-SP - CNPJ 26.295.146/0002-86 - I.E 206.553.059.17 . "
				// 	Endif 
				// 	IF SD2->D2_TES $ '501#510#597#511'
				// 		cMensCli += " Imposto Recolhido por substituicao Tributaria conf. Protoc.ICMS 41/2008. "
				// 	Endif
				// EnDIF
				
				//Se empresa 02 ktm Mensagem de Endereço de Entrega 
				// If FWCodEmp() == "02" .and. nX == 1 .and. !Empty(SA1->A1_ENDENT)
				// 	cMensCli += " LOCAL DE ENTREGA: "+Alltrim(SA1->A1_ENDENT)
				// 	cMensCli += iif(Empty(SA1->A1_COMPENT),'',", "+Alltrim(SA1->A1_COMPENT))
				// 	cMensCli += iif(Empty(SA1->A1_BAIRROE),'', ", BAIRRO: "+Alltrim(SA1->A1_BAIRROE))
				// 	cMensCli += iif(Empty(SA1->A1_MUNE)   ,'', Alltrim(SA1->A1_MUNE))
				// 	cMensCli += iif(Empty(SA1->A1_ESTE)   ,'', " - "+Alltrim(SA1->A1_ESTE))
				// 	cMensCli += iif(Empty(SA1->A1_CEPE)   ,'', ", CEP: "+Alltrim(SA1->A1_CEPE))
				// Endif 

				IF SB1->B1_XTEMCM == "S"
					DbSelectArea("CD9")
					DbSetOrder(1) 	//CD9_FILIAL+CD9_TPMOV+CD9_SERIE+CD9_DOC+CD9_CLIFOR+CD9_LOJA+CD9_ITEM+CD9_COD                                                                                             
						If  Msseek (xFilial()+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA+ PADR(SD2->D2_ITEM,TamSX3("CD9_ITEM")[1]) + SC6->C6_PRODUTO)
					  		aProd[nX,25] += " CHASSI:" + ALLTRIM(CD9->CD9_CHASSI)+ "," + " MOTOR :" + ALLTRIM(CD9->CD9_NMOTOR) + "," + " COR: " + ALLTRIM(CD9->CD9_DSCCOR) + ","+ " COMBUSTIVEL: GASOLINA" + ","+ " RENAVAM: " + ALLTRIM(CD9->CD9_CODMOD) + "," + " POTENCIA: " + ALLTRIM(CD9->CD9_POTENC) + "," + " CILINDRADA: " + ALLTRIM(CD9->CD9_CILIND) + ","+ " ANO FAB:" + Alltrim(Transform(CD9->CD9_ANOFAB,"@E 9999")) + "," + " ANO MOD: " + Alltrim(Transform(CD9->CD9_ANOMOD,"@E 9999"))
						ENDIF 
				ENDIF
				
			Endif
		Next
	Else
		// If !(SF1->F1_TIPO $ "DB")
		// 	SA2->(DbSetOrder(1))
		// 	SA2->(DbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA))
		// Else
		// 	SA1->(DbSetOrder(1))
		// 	SA1->(DbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA))
		// Endif
		
		// cMensCli := AllTrim(cMensCli)
		// If !Empty(SF1->F1_XTPMAN)
		// 	cMensCli += " Tipo do Manifesto " + AllTrim(SF1->F1_XTPMAN)
		// Endif
		// If !Empty(SF1->F1_XMANIFE)
		// 	cMensCli += " Numero do Manifesto " + AllTrim(SF1->F1_XMANIFE)
		// Endif
		// If !Empty(SF1->F1_XRECINT)
		// 	cMensCli += " Recinto Aduaneiro " + AllTrim(SF1->F1_XRECINT)
		// Endif
		// If !Empty(SF1->F1_XARMAZE)
		// 	cMensCli += " Armazem " + AllTrim(SF1->F1_XARMAZE)
		// Endif
		// If !Empty(SF1->F1_XEMBALA)
		// 	cMensCli += " Embalagem " + AllTrim(SF1->F1_XEMBALA)
		// Endif
		// If !Empty(SF1->F1_XQTDVOL)
		// 	cMensCli += " Quantidade " + LTrim(Transform(SF1->F1_XQTDVOL,X3Picture("F1_XQTDVOL")))
		// Endif
		// If !Empty(SF1->F1_XPESBRU)
		// 	cMensCli += " Peso Bruto " + LTrim(Transform(SF1->F1_XPESBRU,X3Picture("F1_XPESBRU"))) + " Kg"
		// Endif
		// If !Empty(SF1->F1_XPESLIQ)
		// 	cMensCli += " Peso Liquido " + LTrim(Transform(SF1->F1_XPESLIQ,X3Picture("F1_XPESLIQ"))) + " Kg"
		// Endif
		
		// nVII   := 0
		// nAFRMM := 0
		// nSISCO := 0
		// cSeek  := XFILIAL("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
		// SD1->(dbSetOrder(1))
		// SD1->(dbSeek(cSeek,.T.))
		// While !SD1->(Eof()) .And. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == cSeek
		// 	If SD1->(FieldPos("D1_AFRMIMP")) > 0
		// 		nAFRMM += SD1->D1_AFRMIMP
		// 	Endif
		// 	If SD1->(FieldPos("D1_XII")) > 0
		// 		nVII += SD1->D1_XII
		// 	Endif
		// 	If SD1->(FieldPos("D1_XSISCOM")) > 0
		// 		nSISCO += SD1->D1_XSISCOM
		// 	Endif
		// 	SD1->(dbSkip())
		// Enddo
		// SD1->(dbSkip(-1))
		
		// if SD1->D1_FILIAL == "01" //  VERIFICAR COM GOIS CONDIÇÃO 
		// 	cMensCli += " IPI ISENTO,D.L. 288/67, art. 3º e seu § 1º, art. 7º,II;, isenção do imposto de importação, D.L. 288/67, art. 3º, § 1º; Suspensão do PIS e da COFINS Lei nº 10.865/04, art. 14-A;Lei nº 10.925/04. art. 6º."
		// ENDif 

		// If !Empty(SF1->F1_XDI)
		// 	cMensCli += ", DI " + AllTrim(SF1->F1_XDI)
		// 	If !Empty(SF1->F1_XDTDI)
		// 		cMensCli += " " + DtoC(SF1->F1_XDTDI)
		// 	Endif
		// Endif
		// If nVII > 0
		// 	cMensCli += ", II R$ " + LTrim(Transform(nVII,"@E 999,999,999.99"))
		// Endif
		// If SF1->F1_VALIPI > 0
		// 	cMensCli += ", IPI R$ " + LTrim(Transform(SF1->F1_VALIPI,"@E 999,999,999.99"))
		// Endif
		// If SF1->F1_VALIMP6 > 0
		// 	cMensCli += ", PIS R$ " + LTrim(Transform(SF1->F1_VALIMP6,"@E 999,999,999.99"))
		// Endif
		// If SF1->F1_VALIMP5 > 0
		// 	cMensCli += ", COFINS R$ " + LTrim(Transform(SF1->F1_VALIMP5,"@E 999,999,999.99"))
		// Endif
		// If nAFRMM
		// 	cMensCli += ", AFRMM R$ " + LTrim(Transform(nAFRMM,"@E 999,999,999.99"))
		// Endif
		// If nSISCO > 0
		// 	cMensCli += ", SISCOMEX R$ " + LTrim(Transform(nSISCO,"@E 999,999,999.99"))
		// Endif
		// If !Empty(SF1->F1_VALICM)
		// 	cMensCli += ", ICMS R$ " + LTrim(Transform(SF1->F1_VALICM,"@E 999,999,999.99"))
		// Endif

		/*Retorno de notas de moto sem TAG automotiva e sem rastreio (Chamado 1180)	
		Ajusta Descrição do Item com informações da CD9 para NFe de Entrada*/
		if SF1->F1_FORMUL=="S" 
			AjtItem(@aProd,aInfoItem,"E")
		Endif 

	Endif
	
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
	aadd(aRetorno,aProcRef)
	aadd(aRetorno,aMed)
	aadd(aRetorno,aLote)
	
	FWRestArea(aArea)

Return aRetorno



//Imprementa dados adicionais na descrição do items da Nfe com informações da CD9 
Static Function AjtItem(aProd,aInfoItem,cTpMov)
Local nX := 0

		For nX := 1 to Len(aProd)
			// Posiciona no cadastro do produto
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(XFILIAL("SB1")+aProd[nX,2]))
			if cTpMov ="S"
				//Posiciona no Item do vetor aProd para verificar informações do item da nota
				SD2->(DbSetOrder(3))
				If SD2->(DbSeek(xfilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+aProd[nX,2]+aInfoItem[nX,4]))
					IF SB1->B1_XTEMCM == "S"
						DbSelectArea("CD9")
						DbSetOrder(1) 	//CD9_FILIAL+CD9_TPMOV+CD9_SERIE+CD9_DOC+CD9_CLIFOR+CD9_LOJA+CD9_ITEM+CD9_COD                                                                                             
							If  Msseek (xFilial()+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA+ PADR(SD2->D2_ITEM,TamSX3("CD9_ITEM")[1]) + aProd[nX,2] )
								aProd[nX,25] += " CHASSI:" + ALLTRIM(CD9->CD9_CHASSI)+ "," + " MOTOR :" + ALLTRIM(CD9->CD9_NMOTOR) + "," + " COR: " + ALLTRIM(CD9->CD9_DSCCOR) + ","+ " COMBUSTIVEL: GASOLINA" + ","+ " RENAVAM: " + ALLTRIM(CD9->CD9_CODMOD) + "," + " POTENCIA: " + ALLTRIM(CD9->CD9_POTENC) + "," + " CILINDRADA: " + ALLTRIM(CD9->CD9_CILIND) + ","+ " ANO FAB:" + Alltrim(Transform(CD9->CD9_ANOFAB,"@E 9999")) + "," + " ANO MOD: " + Alltrim(Transform(CD9->CD9_ANOMOD,"@E 9999"))
							ENDIF 
					ENDIF
				Endif
			else 
				//Posiciona no Item do vetor aProd para verificar informações do item da nota
				SD1->(DbSetOrder(1))//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
				If SD1->(DbSeek(xfilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+aProd[nX,2]+aInfoItem[nX,4]))
					IF SB1->B1_XTEMCM == "S"
						DbSelectArea("CD9")
						DbSetOrder(1) 	//CD9_FILIAL+CD9_TPMOV+CD9_SERIE+CD9_DOC+CD9_CLIFOR+CD9_LOJA+CD9_ITEM+CD9_COD                                                                                             
							If  Msseek (xFilial()+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA+ PADR(SD1->D1_ITEM,TamSX3("CD9_ITEM")[1]) + aProd[nX,2] )
								aProd[nX,25] += " CHASSI:" + ALLTRIM(CD9->CD9_CHASSI)+ "," + " MOTOR :" + ALLTRIM(CD9->CD9_NMOTOR) + "," + " COR: " + ALLTRIM(CD9->CD9_DSCCOR) + ","+ " COMBUSTIVEL: GASOLINA" + ","+ " RENAVAM: " + ALLTRIM(CD9->CD9_CODMOD) + "," + " POTENCIA: " + ALLTRIM(CD9->CD9_POTENC) + "," + " CILINDRADA: " + ALLTRIM(CD9->CD9_CILIND) + ","+ " ANO FAB:" + Alltrim(Transform(CD9->CD9_ANOFAB,"@E 9999")) + "," + " ANO MOD: " + Alltrim(Transform(CD9->CD9_ANOMOD,"@E 9999"))
							ENDIF 
					ENDIF
					
				Endif
			Endif 
		Next

Return nil 


