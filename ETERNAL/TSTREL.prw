#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TBiCONN.CH"

User Function TSTREL()
	Local cFileName       := "ORC_"+Dtos(MSDate())+StrTran(Time(),":","")
	Local cPathInServer   := GetTempPath()
	Local lAdjustToLegacy := .T.
	Local lDisableSetup   := .T.
	Local lTReport        := .F.
	Local lServer         := .T.
	Local lPDFAsPNG       := .T.
	Local lRaw            := .F.
	Local lViewPDF        := .T.
	Local nQtdCopy        := 1
	Local oPrinter
	Local aSize           := {}
	Local nHeight         := 75
	Local nWidght         := 90
	Local nLinha          := 0
	Local nColuna         := 0
	Local nEspacoLin      := 0
	Local aDados          := {}
	Local nFrom           := 0
	Local lFaturamento    := (Alltrim(FunName()) == "MATA410")
	Local lOrcamento      := (Alltrim(FunName()) $ "MATA416/MATA415/FATA600/FATA300/FATA320")
	Local nTamMsg         := 0
	Local nPosMsg         := 1
	Local cTitulo         := ""
	local nI, nJ

	// If lFaturamento
	// 	aDados := GetPedido()
	// 	cTitulo := "Pedido"
	// ElseIf lOrcamento
	// 	aDados := GetOrcamento()
	// 	cTitulo := "Proposta"
	// EndIf

	aAdd(aDados,{'0001'}) //1
	aAdd(aDados[len(aDados)],'01') //2
	aAdd(aDados[len(aDados)],'000001') //3
	aAdd(aDados[len(aDados)],'01/02/2026') //4
	aAdd(aDados[len(aDados)],'01/02/2026') //5
	aAdd(aDados[len(aDados)],'01/02/2026') //6
	aAdd(aDados[len(aDados)],'Vendedor Exemplo') //7
	aAdd(aDados[len(aDados)],'VEN001') //8
	aAdd(aDados[len(aDados)],'Condição de Pagamento') //9
	aAdd(aDados[len(aDados)],'(11) 1234-5678') //10
	aAdd(aDados[len(aDados)],'vendedor@exemplo.com') //11
	aAdd(aDados[len(aDados)],'Cliente Exemplo') //12
	aAdd(aDados[len(aDados)],'0010025698000114') //13
	aAdd(aDados[len(aDados)],'Endereço do Cliente') //14
	aAdd(aDados[len(aDados)],'Bairro do Cliente') //15
	aAdd(aDados[len(aDados)],'CEP do Cliente') //16
	aAdd(aDados[len(aDados)],'Município/Estado') //17
	aAdd(aDados[len(aDados)],'(11) 9876-5432') //18
	aAdd(aDados[len(aDados)],'AMAZONAS') //19
	aAdd(aDados[len(aDados)],'Produto Exemplo') //20
	aAdd(aDados[len(aDados)],'Descrição do Produto') //21
	aAdd(aDados[len(aDados)],'CODCLI001') //22
	aAdd(aDados[len(aDados)],'NCM001') //23
	aAdd(aDados[len(aDados)], 100) //24
	aAdd(aDados[len(aDados)],'UN') //25
	aAdd(aDados[len(aDados)], 0.51) //26
	aAdd(aDados[len(aDados)], 0) //27
	aAdd(aDados[len(aDados)],'05/02/2026') //28
	aAdd(aDados[len(aDados)],100*0.51) //29
	aAdd(aDados[len(aDados)],'Observação do Pedido') //30
	aAdd(aDados[len(aDados)],100*0.51) //31
	aAdd(aDados[len(aDados)],'001') //32
	aAdd(aDados[len(aDados)],'Frete por Conta do Remetente') //33
	aAdd(aDados[len(aDados)],'COND001') //34
	aAdd(aDados[len(aDados)],'TESTE DE IMPRESSÃO') //35
	aAdd(aDados[len(aDados)],'Nome do Representante') //36
	aAdd(aDados[len(aDados)],'PRODÇÃO') //37
	aAdd(aDados[len(aDados)],'vendedor@exemplo.com') //38
	aAdd(aDados[len(aDados)],'Contato do Representante') //39
	aAdd(aDados[len(aDados)],'Transportadora Exemplo') //40
	aAdd(aDados[len(aDados)],'01/02/2026') //41
	//aAdd(aDados[len(aDados)],TMPQRY->XOBS)
	aAdd(aDados[len(aDados)], 2) //42
	aAdd(aDados[len(aDados)], 0) //43
	aAdd(aDados[len(aDados)],'GARANTIA001') //44
	aAdd(aDados[len(aDados)],'(11) 9876-5432') //45

	oPrinter := FWMSPrinter():New(cFileName,IMP_PDF,lAdjustToLegacy,cPathInServer,lDisableSetup,lTReport,,/*alltrim(cPrinter)*/,lServer,lPDFAsPNG,lRaw,lViewPDF,nQtdCopy)

	oTFont10   := TFont():New('ARIAL',,-10,.F.)
	oTFont16   := TFont():New('ARIAL',,-16,.T.)
	oTFont16_2 := TFont():New('ARIAL',,-16,.T.)
	oTFont12   := TFont():New('ARIAL',,-12,.T.)
	oTFont12_2 := TFont():New('ARIAL',,-12,.T.)

	oTFont16:Bold := .T.
	oTFont12:Bold := .T.

	aAdd(aSize,oPrinter:PaperSize()) //Retorna o tamanho do papel.
	aAdd(aSize,oPrinter:nHorzSize()) //Retorno largura da página.
	aAdd(aSize,oPrinter:nVertSize()) //Retorno altura da página.
	aAdd(aSize,oPrinter:nHorzRes())  //Retorna a resolução horizontal da impressora configurada.
	aAdd(aSize,oPrinter:nVertRes())  //Retorna a resolução vertical da impressora configurada.
	aAdd(aSize,oPrinter:nLogPixelX())//Retorna a resolução vertical, em pixels, da impressora configurada.
	aAdd(aSize,oPrinter:nLogPixelY())//Retorna a resolução horizontal, em pixels, da impressora configurada.

	While nFrom < len(aDados)

		oPrinter:StartPage()

		//insere box ao redor da página
		nHeight := oPrinter:NPAGEHEIGHT
		nWidght := oPrinter:NPAGEWIDTH

		nHeight := nHeight-(nHeight*0.05)
		nWidght := nWidght-(nWidght*0.015)

		oPrinter:Box(nHeight,nWidght,20,20)

		//seção 1 -  dados empresa
		nLinha  := 70
		nColuna := 400
		nEspacoLin := 25

		oPrinter:Say( nLinha, nColuna, ALLTRIM(SM0->M0_NOMECOM),oTFont16)
		oPrinter:SayBitmap( 20, 100, "\system\lgmid01.png" ,  75, 65)

		nLinha += nEspacoLin*2
		oPrinter:Say( nLinha, nColuna, "CNPJ: " + Transform(SM0->M0_CGC, "@R 99.999.999/9999-99") + Space(8) + Transform(SM0->M0_INSC, "@R 99.999.999-99"), oTFont12)

		nLinha += nEspacoLin*2
		oPrinter:Say( nLinha, nColuna, AllTrim(SM0->M0_ENDCOB)+" - "+AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+" - "+SM0->M0_ESTCOB, oTFont12)

		nLinha += nEspacoLin*2
		oPrinter:Say( nLinha, nColuna, "CEP: "+Transform(SM0->M0_CEPCOB,"@R 99999-999")+" - "+"Fone/Fax: "+SM0->M0_TEL, oTFont12)

		//seção 2 - cabecalho orçamento/pedido

		nLinha  := 70
		nColuna := 1700
		nEspacoLin := 30

		oPrinter:Say( nLinha, nColuna, cTitulo+" "+aDados[1,3],oTFont16)

		nLinha += nEspacoLin
		//oPrinter:Say( nLinha, nColuna, "Previsão de entrega: "+aDados[1,5],oTFont12)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, "Emitida em: "+aDados[1,4],oTFont12)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, "Vendedor: "+alltrim(aDados[1,7]),oTFont12)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, "E-mail: "+alltrim(aDados[1,11]),oTFont12)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, "Telefone: "+alltrim(aDados[1,10]),oTFont12)

		//cria linha horizontal
		nLinha += nEspacoLin
		oPrinter:Line(nLinha , 20 , nLinha, nWidght)

		//cria linha vertical
		oPrinter:Line(20, nColuna-10 , nLinha, nColuna-10)

		//seção 3 - dados cliente

		nLinha  := 270
		nColuna := 210
		nEspacoLin := 40

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, "DESTINATÁRIO",oTFont16)

		nLinha += nEspacoLin
		oPrinter:Line(nLinha , 20 , nLinha, nWidght)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, "Nome/Razão Social",oTFont12)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, aDados[1,12],oTFont16_2)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, "Nome Fantasia",oTFont12)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, rtrim(aDados[1,36]),oTFont12_2)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, "Município-UF",oTFont12)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, rtrim(aDados[1,17]),oTFont12_2)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, "Fone/Fax",oTFont12)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, rtrim(aDados[1,18]),oTFont12_2)

		nColuna := 900
		nLinha  -= (nEspacoLin*5)

		oPrinter:Say( nLinha, nColuna, "Endereço",oTFont12)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, rtrim(aDados[1,14])+" - "+rtrim(aDados[1,15]),oTFont12_2)


		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, "E-mail",oTFont12)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, rtrim(aDados[1,38]),oTFont12_2)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, "Setor",oTFont12)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, rtrim(aDados[1,37]),oTFont12_2)

		nColuna := 1800
		nLinha  -= (nEspacoLin*7)

		oPrinter:Say( nLinha, nColuna, "CPF/CNPJ",oTFont12)
		oPrinter:Say( nLinha, nColuna+240, "Insc. Est.",oTFont12)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, rtrim(aDados[1,13]),oTFont12_2)
		oPrinter:Say( nLinha, nColuna+240, rtrim(aDados[1,19]),oTFont12_2)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, "CEP: ",oTFont12)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, rtrim(aDados[1,16]),oTFont12_2)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, "Tel/Cel Contato",oTFont12)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, rtrim(aDados[1,45]),oTFont12_2)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, "Contato",oTFont12)

		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, rtrim(aDados[1,39]),oTFont12_2)


		nLinha += nEspacoLin
		oPrinter:Line(nLinha , 20 , nLinha, nWidght)

		//seção 4 - dados produto

		nColuna := 210
		nEspacoLin := 25

		nLinha += (nEspacoLin*2)
		oPrinter:Say( nLinha, nColuna, "DADOS PRODUTO(S)",oTFont16)

		nLinha += nEspacoLin
		oPrinter:Line(nLinha , 20 , nLinha, nWidght)

		nColuna := 105
		nLinha += nEspacoLin
		oPrinter:Say( nLinha, nColuna, "Código",oTFont12)

		nColuna := 250
		oPrinter:Say( nLinha, nColuna, "Descrição",oTFont12)

		nColuna := 1000
		oPrinter:Say( nLinha, nColuna, "Cod.Cliente",oTFont12)

		nColuna := 1230
		oPrinter:Say( nLinha, nColuna, "Ncm",oTFont12)

		nColuna := 1430
		oPrinter:Say( nLinha, nColuna, "Qtd",oTFont12)

		nColuna := 1550
		oPrinter:Say( nLinha, nColuna, "UM",oTFont12)

		nColuna := 1680
		oPrinter:Say( nLinha, nColuna, "Dt. Entrega",oTFont12)

		nColuna := 1880
		oPrinter:Say( nLinha, nColuna, "Vlr. Unit.",oTFont12)

		nColuna := 2050
		oPrinter:Say( nLinha, nColuna, "Vlr. Desc.",oTFont12)

		nColuna := 2250
		oPrinter:Say( nLinha, nColuna, "Total",oTFont12)

		//informa os itens existentes

		For nI := 1 to Iif(len(aDados)>10,10,len(aDados))

			nFrom += 1
			//alert(nFrom)
			If nFrom > len(aDados)
				exit
			EndIf

			nLin   := MLCount(rtrim(aDados[nFrom,21]),40)

			For nJ:=1 To nLin
				nLinha += (nEspacoLin*2.0)
				If nJ == 1
					//oPrinter:Say( nLinha, 50  , cvaltochar(aDados[nFrom,26])+"-" , oTFont10)
					oPrinter:Say( nLinha, 105 , rtrim(aDados[nFrom,20])     , oTFont12_2)
				Endif
				oPrinter:Say( nLinha, 270 , MemoLine(rtrim(aDados[nFrom,21]),40,nJ)     , oTFont12_2)
				If nJ == 1
					oPrinter:Say( nLinha, 1000, cvaltochar(aDados[nFrom,22])                     , oTFont12_2)
					oPrinter:Say( nLinha, 1200, cvaltochar(aDados[nFrom,23])                     , oTFont12_2)
					oPrinter:Say( nLinha, 1375, trim(Transform(aDados[nFrom,24],"@R 999,999.99")), oTFont12_2)//QTD
					oPrinter:Say( nLinha, 1550, cvaltochar(aDados[nFrom,25])                     , oTFont12_2) //UM
					oPrinter:Say( nLinha, 2035, trim(Transform(aDados[nFrom,27],"@E 999,999.99")), oTFont12_2) //VALDESC
					oPrinter:Say( nLinha, 1680, trim(aDados[nFrom,28])                           , oTFont12_2) //ENTREG
					oPrinter:Say( nLinha, 1870, trim(Transform(aDados[nFrom,26],"@E 999,999.99")), oTFont12_2) //PRCUNIT
					oPrinter:Say( nLinha, 2190, trim(Transform(aDados[nFrom,29],"@E 999,999,999.99")), oTFont12_2) //PRCTOT
				Endif
			Next nJ

			nLinha += (nEspacoLin*1.5)
			oPrinter:Say( nLinha, 200, "Obs.: -->",oTFont12)

			nColuna := 600
			oPrinter:Say( nLinha, nColuna, ""+cvaltochar(aDados[nFrom,30]),oTFont12_2)
		/*	
			nColuna := 900
			oPrinter:Say( nLinha, nColuna, "ICMS ST: "+cvaltochar(aDados[nFrom,34]),oTFont12)
						
			nLinha += nEspacoLin
			oPrinter:Say( nLinha, 200, "Observações -->",oTFont12)
			nColuna := 600
			oPrinter:Say( nLinha, nColuna, rtrim(aDados[nFrom,32]),oTFont12)
			*/
			nLinha += nEspacoLin
		Next nI

		If nLinha >= 2800 .and. nFrom < len(aDados)
			loop
		Endif

		//seção 6 - Mensagem Fixa

		nLinha += nEspacoLin
		nLinha += nEspacoLin
		oPrinter:Say( nLinha, 1300, "Adicionais -->",oTFont16)

		nColuna := 1700
		oPrinter:Say( nLinha, nColuna, Transform(aDados[1,43],"@E 999,999,999.99"),oTFont16)


		//seção 5 - Mensagem Fixa

		nLinha += nEspacoLin
		nLinha += nEspacoLin
		oPrinter:Say( nLinha, 1300, "Total Geral -->",oTFont16)

		nColuna := 1800
		oPrinter:Say( nLinha, nColuna, Transform((aDados[1,31] + (aDados[1,43])),"@E 999,999,999.99"),oTFont16)


		nLinha += (nEspacoLin*2.0)

		nLinha += nEspacoLin
		oPrinter:Line(nLinha , 20 , nLinha, nWidght)

		nColuna := 110

		nTamMsg := len(ltrim(rtrim(aDados[1,32])))

		nLinha += nEspacoLin
		If nTamMsg > 120
			nPosMsg := 1
			While nTamMsg > 120
				nLinha += nEspacoLin
				//	oPrinter:Say( nLinha, nColuna, SubStr(aDados[1,32],nPosMsg,120),oTFont12_2)

				nPosMsg += 120
				nTamMsg -= 120
			Enddo
		EndIf

		//	nLinha += nEspacoLin
		//	oPrinter:Say( nLinha, nColuna, SubStr(aDados[1,32],nPosMsg,120),oTFont12_2)

		//nLinha += nEspacoLin*2
		//oPrinter:Say( nLinha, nColuna := 110,cTitulo+"  com validade até "+rtrim(aDados[1,6])+".",oTFont16)

		nLinha += nEspacoLin*2
		oPrinter:Say( nLinha, nColuna, "Frete: "+alltrim(aDados[1,33]),oTFont12)

		nLinha += nEspacoLin*2
		oPrinter:Say( nLinha, nColuna, "Transportadora: "+alltrim(aDados[1,40]),oTFont12)

		nLinha += nEspacoLin*2
		oPrinter:Say( nLinha, nColuna, "Orçamento Valido até: "+alltrim(aDados[1,41]),oTFont12)

		nLinha += nEspacoLin*2
		oPrinter:Say( nLinha, nColuna, "Cond. Pgto: "+alltrim(aDados[1,9]),oTFont12)

		nLinha += nEspacoLin*2
		oPrinter:Say( nLinha, nColuna, "Observação: "+alltrim(aDados[1,35]),oTFont12)

		nLinha += nEspacoLin*2
		oPrinter:Say( nLinha, nColuna, "Impostos: "+alltrim(aDados[1,42]),oTFont12)

		nLinha += nEspacoLin*2
		oPrinter:Say( nLinha, nColuna, "Garantia: "+alltrim(aDados[1,44]),oTFont12)



		nLinha += nEspacoLin *20
		oPrinter:Say( nLinha, nColuna, ("_________________________________________________________________,________/__________________/________"),oTFont12)

		nLinha += nEspacoLin*2
		oPrinter:Say( nLinha, nColuna, rtrim(aDados[1,12]),oTFont12_2)

		//	nLinha += nEspacoLin*10
		//	oPrinter:SayBitmap( nLinha, nColuna, "\system\pbtotvs.png" , 420, 080)

		oPrinter:SayBitmap( 2820, 1700, "\system\pbtotvs.png" , 420, 080)

		oPrinter:EndPage()
	Enddo

	oPrinter:cPathPDF:= cPathInServer

	oPrinter:Preview()

Return
