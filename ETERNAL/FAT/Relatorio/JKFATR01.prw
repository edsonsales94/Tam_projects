#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TBiCONN.CH"

/*_________________________________________________________________________________
* ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦*
* +------------+--------------------+--------------------+----------------------+¦*
* ¦ Program    ¦ JKFATR01           ¦ Author                ¦ Matheus Vinícius  ¦¦*
* +------------+--------------------+--------------------+----------------------+¦*
* ¦ Description¦ Impressão Orçamento de Venda/Pedido de Venda                   ¦¦*
* +------------+--------------------+--------------------+----------------------+¦*
* ¦ Date       ¦ 06/09/2019         ¦ Last Modified time ¦  11/10/2019          ¦¦*
* +------------+--------------------+--------------------+----------------------+¦*
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function JKFATR01()
	
	MsgRun("Gerando relatório...","Aguarde...",{|| GetReport() })
	
Return

Static Function GetReport()
	Local cFileName
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
	lOrcamento := .T.
	If lFaturamento
		cFileName       := "PED_"+Dtos(MSDate())+StrTran(Time(),":","")
		aDados := GetPedido()
		cTitulo := "Pedido"
	ElseIf lOrcamento
		cFileName       := "ORC_"+Dtos(MSDate())+StrTran(Time(),":","")
		aDados := GetOrcamento()
		cTitulo := "Proposta"
	EndIf
	
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
		oPrinter:SayBitmap( 30, 45, "\system\lgmid01.png" , 290, 190)
		
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

Static Function GetOrcamento()

	Local aDados := {}

	BeginSQL Alias "TMPQRY"

		SELECT
			SCJ.CJ_FILIAL AS FILIAL,
			SCJ.CJ_NUM AS NUM,

			CASE
				WHEN TRIM(SCJ.CJ_EMISSAO) IS NOT NULL
				THEN TO_CHAR(
					TO_DATE(SCJ.CJ_EMISSAO, 'YYYYMMDD'),
					'DD/MM/YYYY'
				)
				ELSE ' '
			END AS DTEMIS,

			CASE
				WHEN TRIM(SCJ.CJ_EMISSAO) IS NOT NULL
				THEN TO_CHAR(
					TO_DATE(SCJ.CJ_EMISSAO, 'YYYYMMDD'),
					'DD/MM/YYYY'
				)
				ELSE ' '
			END AS DTENTR,

			CASE
				WHEN TRIM(SCJ.CJ_VALIDA) IS NOT NULL
				THEN TO_CHAR(
					TO_DATE(SCJ.CJ_VALIDA, 'YYYYMMDD'),
					'DD/MM/YYYY'
				)
				ELSE ' '
			END AS DTVALD,

			SA3.A3_NOME AS VENDNOM,
			SA3.A3_COD AS VENDCOD,
			SE4.E4_DESCRI AS CONDPAG,
			SA3.A3_TEL AS VENDTEL,
			RTRIM(SA3.A3_EMAIL) AS EMAIL,

			CASE
				WHEN TRIM(SCJ.CJ_PROSPE) IS NOT NULL
				THEN SUS.US_NOME
				ELSE SA1.A1_NOME
			END AS CLIENTE, //,A1_NOME AS CLIENTE

			CASE
				WHEN TRIM(SCJ.CJ_PROSPE) IS NOT NULL
				THEN SUS.US_NREDUZ
				ELSE SA1.A1_NREDUZ
			END AS NREDUZ, //,A1_NREDUZ

			CASE
				WHEN TRIM(SCJ.CJ_PROSPE) IS NOT NULL
				THEN SUS.US_CGC
				ELSE SA1.A1_CGC
			END AS CNPJ, //,A1_CGC

			CASE
				WHEN TRIM(SCJ.CJ_PROSPE) IS NOT NULL
				THEN SUS.US_END
				ELSE SA1.A1_END
			END AS CLIEND, //,A1_END

			CASE
				WHEN TRIM(SCJ.CJ_PROSPE) IS NOT NULL
				THEN SUS.US_BAIRRO
				ELSE SA1.A1_BAIRRO
			END AS CLIBAI, //,A1_BAIRRO

			CASE
				WHEN TRIM(SCJ.CJ_PROSPE) IS NOT NULL
				THEN SUS.US_CEP
				ELSE SA1.A1_CEP
			END AS CLICEP, //,A1_CEP

			CASE
				WHEN TRIM(SCJ.CJ_PROSPE) IS NOT NULL
				THEN RTRIM(SUS.US_MUN) || '-' || RTRIM(SUS.US_EST)
				ELSE RTRIM(SA1.A1_MUN) || '-' || RTRIM(SA1.A1_EST)
			END AS CLIMUN, //,RTRIM(A1_MUN)+'-'+RTRIM(A1_EST) AS CLIMUN

			CASE
				WHEN TRIM(SCJ.CJ_PROSPE) IS NOT NULL
				THEN SUS.US_TEL
				ELSE SA1.A1_TEL
			END AS CLITEL, //,A1_TEL

			CASE
				WHEN TRIM(SCJ.CJ_PROSPE) IS NOT NULL
				THEN SUS.US_INSCR
				ELSE SA1.A1_INSCR
			END AS CLIIEST, //,A1_INSCR

			RTRIM(SCK.CK_PRODUTO) AS PRODUTO,
			RTRIM(SB1.B1_DESC) AS DESCRICAO,

			// ,CK_XCODCLI AS CODCLI
			SCJ.CJ_CLIENTE AS CODCLI,

			SB1.B1_POSIPI AS NCM,
			SCK.CK_QTDVEN AS QTD,
			SCK.CK_UM AS UM,

			SCK.CK_PRCVEN
				+ ROUND(
					SCK.CK_VALDESC / NULLIF(SCK.CK_QTDVEN, 0),
					2
				) AS PRCUNIT,

			ROUND(
				SCK.CK_VALDESC / NULLIF(SCK.CK_QTDVEN, 0),
				2
			) AS VALDESC,

			CASE
				WHEN TRIM(SCK.CK_ENTREG) IS NOT NULL
				THEN TO_CHAR(
					TO_DATE(SCK.CK_ENTREG, 'YYYYMMDD'),
					'DD/MM/YYYY'
				)
				ELSE ' '
			END AS ENTREG,

			SCK.CK_VALOR AS PRCTOT,
			RTRIM(SCK.CK_OBS) AS OBSERVACAO,

			SUM(NVL(SCK.CK_VALOR, 0)) OVER (
				PARTITION BY SCK.CK_FILIAL, SCK.CK_NUM
			) AS TOTAL,

			SCK.CK_ITEM AS SEQ,

			// ,CJ_XSETOR AS XSETOR
			// ,CJ_XCONT AS XCONTATO
			'' AS XCONTATO,
			' ' AS SETOR,
			SA1.A1_EMAIL AS XEMAIL,
			SA1.A1_CONTATO AS CONTATO,

			RTRIM(SA4.A4_COD)
				|| '-'
				|| RTRIM(SA4.A4_NOME) AS XTRANSP,

			CASE
				WHEN TRIM(SCJ.CJ_VALIDA) IS NOT NULL
				THEN TO_CHAR(
					TO_DATE(SCJ.CJ_VALIDA, 'YYYYMMDD'),
					'DD/MM/YYYY'
				)
				ELSE ' '
			END AS VALIDADE,

			0 AS IMPOSTOS, //CJ_XIMPOST
			0 AS ADICIONAIS, //,CJ_XADICIO
			' ' AS GARANTIA, //CJ_XGARANT
			' ' AS TELCEL, //CJ_XTELCEL

			CASE
				WHEN SCJ.CJ_TPFRETE = 'C' THEN 'CIF'
				WHEN SCJ.CJ_TPFRETE = 'F' THEN 'FOB'
				WHEN SCJ.CJ_TPFRETE = 'T' THEN 'POR CONTA DE TERCEIROS'
				WHEN SCJ.CJ_TPFRETE = 'R' THEN 'POR CONTA DO REMETENTE'
				WHEN SCJ.CJ_TPFRETE = 'D' THEN 'POR CONTA DO DESTINATARIO'
				WHEN SCJ.CJ_TPFRETE = 'S' THEN 'SEM FRETE'
				ELSE 'NÃO INFORMADO'
			END AS TPFRETE,

			RTRIM(SE4.E4_DESCRI)
				|| '-'
				|| NVL(RTRIM(SX5.X5_DESCRI), ' ') AS CDPGO,

			// ,LTRIM(RTRIM(CONVERT(VARCHAR(2040),CONVERT(VARBINARY(2040),CJ_XOBS)))) AS MSGGERAL
			'Mensagem Geral para o orçamento- criar campo CJ_XOBS' AS MSGGERAL

		FROM %table:SCJ% SCJ

		LEFT JOIN %table:SCK% SCK
			ON SCK.CK_FILIAL = SCJ.CJ_FILIAL
			AND SCK.CK_NUM = SCJ.CJ_NUM
			AND SCK.%notDel%

		LEFT JOIN %table:SB1% SB1
			ON SB1.B1_FILIAL = %xfilial:SB1%
			AND SB1.B1_COD = SCK.CK_PRODUTO
			AND SB1.%notDel%

		LEFT JOIN %table:SA3% SA3
			ON SA3.A3_FILIAL = %xfilial:SA3%
			AND SA3.A3_COD = SCJ.CJ_XVEND
			AND SA3.%notDel%
			//ALTERADO POR CLAUDIO EM 20230117

		LEFT JOIN %table:SA1% SA1
			ON SA1.A1_FILIAL = %xfilial:SA1%
			AND SA1.A1_COD = SCJ.CJ_CLIENTE
			AND SA1.A1_LOJA = SCJ.CJ_LOJA
			AND SA1.%notDel%

		LEFT JOIN %table:SUS% SUS
			ON SUS.US_FILIAL = %xfilial:SUS%
			AND SUS.US_COD = SCJ.CJ_PROSPE
			AND SUS.US_LOJA = SCJ.CJ_LOJPRO
			AND SUS.%notDel%

		LEFT JOIN %table:SE4% SE4
			ON SE4.E4_FILIAL = %xfilial:SE4%
			AND SE4.E4_CODIGO = SCJ.CJ_CONDPAG
			AND SE4.%notDel%

		LEFT JOIN %table:SX5% SX5
			ON SX5.X5_FILIAL = %xfilial:SX5%
			AND SX5.X5_TABELA = '24'
			AND SX5.X5_CHAVE = SE4.E4_FORMA
			AND SX5.%notDel%

		LEFT JOIN %table:SA4% SA4
			ON SA4.A4_FILIAL = %xfilial:SA4%
			AND SA4.A4_COD = SCJ.CJ_XTRANSP
			AND SA4.%notDel%

		WHERE SCJ.%notDel%
			AND SCJ.CJ_FILIAL = %xfilial:SCJ%
			AND SCJ.CJ_NUM = %Exp:AllTrim(SCJ->CJ_NUM)%

	EndSql

	While !TMPQRY->(EOF())
		aAdd(aDados,{TMPQRY->SEQ}) //1
		aAdd(aDados[len(aDados)],TMPQRY->FILIAL) //2
		aAdd(aDados[len(aDados)],TMPQRY->NUM) //3
		aAdd(aDados[len(aDados)],TMPQRY->DTEMIS) //4
		aAdd(aDados[len(aDados)],TMPQRY->DTENTR) //5
		aAdd(aDados[len(aDados)],TMPQRY->DTVALD) //6
		aAdd(aDados[len(aDados)],TMPQRY->VENDNOM) //7
		aAdd(aDados[len(aDados)],TMPQRY->VENDCOD) //8
		aAdd(aDados[len(aDados)],TMPQRY->CONDPAG) //9
		aAdd(aDados[len(aDados)],TMPQRY->VENDTEL) //10
		aAdd(aDados[len(aDados)],TMPQRY->EMAIL) //11
		aAdd(aDados[len(aDados)],TMPQRY->CLIENTE) //12
		aAdd(aDados[len(aDados)],TMPQRY->CNPJ) //13
		aAdd(aDados[len(aDados)],TMPQRY->CLIEND) //14
		aAdd(aDados[len(aDados)],TMPQRY->CLIBAI) //15
		aAdd(aDados[len(aDados)],TMPQRY->CLICEP) //16
		aAdd(aDados[len(aDados)],TMPQRY->CLIMUN) //17
		aAdd(aDados[len(aDados)],TMPQRY->CLITEL) //18
		aAdd(aDados[len(aDados)],TMPQRY->CLIIEST) //19
		aAdd(aDados[len(aDados)],TMPQRY->PRODUTO) //20
		aAdd(aDados[len(aDados)],TMPQRY->DESCRICAO) //21
		aAdd(aDados[len(aDados)],TMPQRY->CODCLI) //22
		aAdd(aDados[len(aDados)],TMPQRY->NCM) //23
		aAdd(aDados[len(aDados)],TMPQRY->QTD) //24
		aAdd(aDados[len(aDados)],TMPQRY->UM) //25
		aAdd(aDados[len(aDados)],TMPQRY->PRCUNIT) //26
		aAdd(aDados[len(aDados)],TMPQRY->VALDESC) //27
		aAdd(aDados[len(aDados)],TMPQRY->ENTREG) //28
		aAdd(aDados[len(aDados)],TMPQRY->PRCTOT) //29
		aAdd(aDados[len(aDados)],TMPQRY->OBSERVACAO) //30
		aAdd(aDados[len(aDados)],TMPQRY->TOTAL) //31
		aAdd(aDados[len(aDados)],TMPQRY->SEQ) //32
		aAdd(aDados[len(aDados)],TMPQRY->TPFRETE) //33
		aAdd(aDados[len(aDados)],TMPQRY->CDPGO) //34
		aAdd(aDados[len(aDados)],TMPQRY->MSGGERAL) //35
		aAdd(aDados[len(aDados)],TMPQRY->NREDUZ) //36
		aAdd(aDados[len(aDados)],TMPQRY->SETOR) //37
		aAdd(aDados[len(aDados)],TMPQRY->XEMAIL) //38
		aAdd(aDados[len(aDados)],TMPQRY->XCONTATO) //39
		aAdd(aDados[len(aDados)],TMPQRY->XTRANSP) //40
		aAdd(aDados[len(aDados)],TMPQRY->VALIDADE) //41
		//aAdd(aDados[len(aDados)],TMPQRY->XOBS)
		aAdd(aDados[len(aDados)],TMPQRY->IMPOSTOS) //42
		aAdd(aDados[len(aDados)],TMPQRY->ADICIONAIS) //43
		aAdd(aDados[len(aDados)],TMPQRY->GARANTIA) //44
		aAdd(aDados[len(aDados)],TMPQRY->TELCEL) //45
		TMPQRY->(DbSkip())
	End

	TMPQRY->(DbCloseArea())

Return aDados

Static Function GetPedido()

	Local aDados := {}

	BeginSQL Alias "TMPQRY"

		SELECT
			SC5.C5_FILIAL AS FILIAL,
			SC5.C5_NUM AS NUM,

			CASE
				WHEN TRIM(SC5.C5_EMISSAO) IS NOT NULL
				THEN TO_CHAR(
					TO_DATE(SC5.C5_EMISSAO, 'YYYYMMDD'),
					'DD/MM/YYYY'
				)
				ELSE ' '
			END AS DTEMIS,

			CASE
				WHEN TRIM(SC5.C5_EMISSAO) IS NOT NULL
				THEN TO_CHAR(
					TO_DATE(SC5.C5_EMISSAO, 'YYYYMMDD'),
					'DD/MM/YYYY'
				)
				ELSE ' '
			END AS DTENTR,
			CASE
				WHEN TRIM(SC6.C6_ENTREG) IS NOT NULL
				THEN TO_CHAR(
					TO_DATE(SC6.C6_ENTREG, 'YYYYMMDD'),
					'DD/MM/YYYY'
				)
				ELSE ' '
			END AS ENTREG,

			CASE
				WHEN TRIM(SC5.C5_EMISSAO) IS NOT NULL
				THEN TO_CHAR(
					TO_DATE(SC5.C5_EMISSAO, 'YYYYMMDD'),
					'DD/MM/YYYY'
				)
				ELSE ' '
			END AS DTVALD,

			SA3.A3_NOME AS VENDNOM,
			SC5.C5_VEND1 AS VENDCOD,
			SC5.C5_TRANSP AS XTRANSP,
			SE4.E4_DESCRI AS CONDPAG,
			SA3.A3_TEL AS VENDTEL,
			RTRIM(SA3.A3_EMAIL) AS EMAIL,
			SA1.A1_COD AS CODCLI,
			SA1.A1_NOME AS CLIENTE,
			SA1.A1_NREDUZ AS NREDUZ,
			SA1.A1_CGC AS CNPJ,
			SA1.A1_END AS CLIEND,
			SA1.A1_BAIRRO AS CLIBAI,
			SA1.A1_CEP AS CLICEP,
			'' AS SETOR,
			SA1.A1_EMAIL AS XEMAIL,
			SA1.A1_CONTATO AS XCONTATO,
			RTRIM(SA1.A1_MUN) || '-' || RTRIM(SA1.A1_EST) AS CLIMUN,
			SA1.A1_TEL AS CLITEL,
			SA1.A1_INSCR AS CLIIEST,
			RTRIM(SC6.C6_PRODUTO) AS PRODUTO,
			RTRIM(SB1.B1_DESC) AS DESCRICAO,
			SC6.C6_QTDVEN AS QTD,
			SC6.C6_UM AS UM,
			SC6.C6_PRCVEN AS PRCUNIT,
			SC6.C6_VALOR AS PRCTOT,
			SUM(NVL(SC6.C6_VALOR, 0)) OVER (
				PARTITION BY SC6.C6_FILIAL, SC6.C6_NUM
			) AS TOTAL,
			' ' AS OBSERVACAO,
			SC6.C6_ITEM AS SEQ,
			SB1.B1_POSIPI AS NCM,

			CASE
				WHEN SC5.C5_TPFRETE = 'C' THEN 'CIF'
				WHEN SC5.C5_TPFRETE = 'F' THEN 'FOB'
				WHEN SC5.C5_TPFRETE = 'T' THEN 'POR CONTA DE TERCEIROS'
				WHEN SC5.C5_TPFRETE = 'R' THEN 'POR CONTA DO REMETENTE'
				WHEN SC5.C5_TPFRETE = 'D' THEN 'POR CONTA DO DESTINATARIO'
				WHEN SC5.C5_TPFRETE = 'S' THEN 'SEM FRETE'
				ELSE 'NÃO INFORMADO'
			END AS TPFRETE,

			RTRIM(SE4.E4_DESCRI)
				|| '-'
				|| NVL(RTRIM(SX5.X5_DESCRI), ' ') AS CDPGO,

			 NVL(
				RTRIM(
					DBMS_LOB.SUBSTR(SC5.C5_MENNOTA, 2000, 1)
					),
					' '
				) AS MSGGERAL

		FROM %table:SC5% SC5

		LEFT JOIN %table:SC6% SC6
			ON SC6.C6_FILIAL = SC5.C5_FILIAL
			AND SC6.C6_NUM = SC5.C5_NUM
			AND SC6.%notDel%

		LEFT JOIN %table:SB1% SB1
			ON SB1.B1_FILIAL = %xfilial:SB1%
			AND SB1.B1_COD = SC6.C6_PRODUTO
			AND SB1.%notDel%

		LEFT JOIN %table:SA3% SA3
			ON SA3.A3_FILIAL = %xfilial:SA3%
			AND SA3.A3_COD = SC5.C5_VEND1
			AND SA3.%notDel%

		LEFT JOIN %table:SA1% SA1
			ON SA1.A1_FILIAL = %xfilial:SA1%
			AND SA1.A1_COD = SC5.C5_CLIENTE
			AND SA1.A1_LOJA = SC5.C5_LOJACLI
			AND SA1.%notDel%

		LEFT JOIN %table:SE4% SE4
			ON SE4.E4_FILIAL = %xfilial:SE4%
			AND SE4.E4_CODIGO = SC5.C5_CONDPAG
			AND SE4.%notDel%

		LEFT JOIN %table:SX5% SX5
			ON SX5.X5_FILIAL = %xfilial:SX5%
			AND SX5.X5_TABELA = '24'
			AND SX5.X5_CHAVE = SE4.E4_FORMA
			AND SX5.%notDel%

		WHERE SC5.%notDel%
			AND SC5.C5_FILIAL = %xfilial:SC5%
			AND SC5.C5_NUM = %Exp:AllTrim(SC5->C5_NUM)%

	EndSql

	While !TMPQRY->(EOF())

		aAdd(aDados,{TMPQRY->SEQ}) //1
		aAdd(aDados[len(aDados)],TMPQRY->FILIAL) //2
		aAdd(aDados[len(aDados)],TMPQRY->NUM) //3
		aAdd(aDados[len(aDados)],TMPQRY->DTEMIS) //4
		aAdd(aDados[len(aDados)],TMPQRY->DTENTR) //5
		aAdd(aDados[len(aDados)],TMPQRY->DTVALD) //6
		aAdd(aDados[len(aDados)],TMPQRY->VENDNOM) //7
		aAdd(aDados[len(aDados)],TMPQRY->VENDCOD) //8
		aAdd(aDados[len(aDados)],TMPQRY->CONDPAG) //9
		aAdd(aDados[len(aDados)],TMPQRY->VENDTEL) //10
		aAdd(aDados[len(aDados)],TMPQRY->EMAIL) //11
		aAdd(aDados[len(aDados)],TMPQRY->CLIENTE) //12
		aAdd(aDados[len(aDados)],TMPQRY->CNPJ) //13
		aAdd(aDados[len(aDados)],TMPQRY->CLIEND) //14
		aAdd(aDados[len(aDados)],TMPQRY->CLIBAI) //15
		aAdd(aDados[len(aDados)],TMPQRY->CLICEP) //16
		aAdd(aDados[len(aDados)],TMPQRY->CLIMUN) //17
		aAdd(aDados[len(aDados)],TMPQRY->CLITEL) //18
		aAdd(aDados[len(aDados)],TMPQRY->CLIIEST) //19
		aAdd(aDados[len(aDados)],TMPQRY->PRODUTO) //20
		aAdd(aDados[len(aDados)],TMPQRY->DESCRICAO) //21
		aAdd(aDados[len(aDados)],TMPQRY->CODCLI) //22
		aAdd(aDados[len(aDados)],TMPQRY->NCM) //23
		aAdd(aDados[len(aDados)],TMPQRY->QTD) //24
		aAdd(aDados[len(aDados)],TMPQRY->UM) //25
		aAdd(aDados[len(aDados)],TMPQRY->PRCUNIT) //26
		aAdd(aDados[len(aDados)],TMPQRY->PRCUNIT) //27
		aAdd(aDados[len(aDados)],TMPQRY->ENTREG) //28
		aAdd(aDados[len(aDados)],TMPQRY->PRCTOT) //29
		aAdd(aDados[len(aDados)],TMPQRY->OBSERVACAO) //30
		aAdd(aDados[len(aDados)],TMPQRY->TOTAL) //31
		aAdd(aDados[len(aDados)],TMPQRY->SEQ) //32
		aAdd(aDados[len(aDados)],TMPQRY->TPFRETE) //33
		aAdd(aDados[len(aDados)],TMPQRY->CDPGO) //34
		aAdd(aDados[len(aDados)],TMPQRY->MSGGERAL) //35
		aAdd(aDados[len(aDados)],TMPQRY->NREDUZ) //36
		aAdd(aDados[len(aDados)],TMPQRY->SETOR) //37
		aAdd(aDados[len(aDados)],TMPQRY->XEMAIL) //38
		aAdd(aDados[len(aDados)],TMPQRY->XCONTATO) //39
		aAdd(aDados[len(aDados)],TMPQRY->XTRANSP) //40
		aAdd(aDados[len(aDados)],''/*TMPQRY->VALIDADE*/) //41
		//aAdd(aDados[len(aDados)],TMPQRY->XOBS)
		aAdd(aDados[len(aDados)], 0/*TMPQRY->IMPOSTOS*/) //42
		aAdd(aDados[len(aDados)], 0/*TMPQRY->ADICIONAIS*/) //43
		aAdd(aDados[len(aDados)], ''/*TMPQRY->GARANTIA*/) //44
		aAdd(aDados[len(aDados)], '' /*TMPQRY->TELCEL*/) //45
		TMPQRY->(DbSkip())

	End

	TMPQRY->(DbCloseArea())

Return aDados
