#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³XmlNFeSef ³ Autor ³ Edson Sales         ³   Data ³02.06.2025³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Apontamento de produção, pela etiqueta QRCode.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/
// NOPC ==1  -- CHAMADA DO GATILHO NA D3_QRCODE
// NOPC ==2  -- CHAMADA DO GATILHO NA D3_OP ___ para validar a qtd e assumir sempre da etiqueta.
User Function MASAPOQR(NOPC)
	Local cQrCode := M->D3_QRCODE
	Local cSeq 	 	:= ''
	Local nQuantEtq := 0
	Local cOrdProd  := ''
	Local cUn 		:= ''
	Local cLoc 		:= ''
	Local _cQr 		:= cQrCode
	Local xRet 		:= ''
	//'762003M6 M011M1  NH883P       360BIHR-202B30/04/25939599\5]8/24'

	if funName()== "MATA250"  // só executa para rotina de apontamento simples

		// Esses caracters compoem os codigos QRcodes, eles precisam está contidos no campo D3_QRCODE
		if !('[' $ cQrCode) .and. !(']' $ cQrCode) .and. !(';' $ cQrCode)
			if NOPC == 1 // Disparou no campo d3_qrcode para d3_op
				FwalertWarning('Este campo é exclusivo para leitura de QrCode...','Atenção')
				return xRet
			elseif NOPC == 2 //disparou no campo D3_OP para D3_QUANT
				xRet := M->D3_QUANT
				return xRet
			endif
			M->D3_QRCODE := SPACE(75)

		endif

		// atualiza variavel tirando a parte do cliente
		if Len(Alltrim(cQrCode))>45
			cQrCode := SubStr(cQrCode,31)
		endif

		cProd 	:= substr(cQrCode,1,15)  // codigo do produto

		// atualiza variavel tirando o codigo do produto
		cQrCode := SubStr(cQrCode,16)   // Sequencia
		cSeq := Alltrim(substr(cQrCode,at('[',cQrCode )+1))

		// atualiza variavel tirando a sequencia
		cQrCode := Alltrim(substr(cQrCode,1,at(cSeq,cQrCode)-2))
		nQuantEtq := val(substr(cQrCode,at(']',cQrCode)+1))  // quantidade etiqueta
		cQuant := substr(cQrCode,at(']',cQrCode))

		// atualiza variavel retirando a quatidade.
		cQrCode := Alltrim(substr(cQrCode,1,at(cQuant,cQrCode)-1))
		cOrdProd := substr(cQrCode,-6) + '01001'  // Ordem de produção

		cUn 		:= POSICIONE('SB1',1,xFilial('SD3')+cProd,'B1_UM')
		cTipo 		:= POSICIONE('SB1',1,xFilial('SD3')+cProd,'B1_TIPO')
		cDesc 		:= POSICIONE('SB1',1,xFilial('SD3')+cProd,'B1_DESC')

		cConta 		:= POSICIONE('SB1',1,xFilial('SD3')+cProd,'B1_CONTA')
		cCCusto 	:= POSICIONE('SB1',1,xFilial('SD3')+cProd,'B1_CC')
		nQtdOP 		:= POSICIONE('SC2',1,xFilial('SC2')+cOrdProd,'C2_QUANT') // quantidade original da OP
		nQtdproduz	:= POSICIONE('SC2',1,xFilial('SC2')+cOrdProd,'C2_QUJE')  // quantidade já produzida

		nSaldo := nQtdOP-nQtdproduz  // Saldo aproduzir

		if cTipo == 'PA'
			cLoc := '03'
		elseif cTipo == 'PP'
			cLoc := '99'
		endif

		// acionar o gatilho na QRcode, para buscar todas as informações
		if NOPC == 1

			// Procurar por etiquetas apontadas para verificar se a etique bipada ja foi apontada.
			dbSetOrder(1)
			CSEEK := xFilial('SD3')+SUBSTR(cOrdProd+SPACE(10),1,14)+cProd
			if SD3->(dbseek(CSEEK))
				while !SD3->(Eof()) .and. CSEEK == SD3->(D3_FILIAL+D3_OP+D3_COD)
					if _cQr == SD3->D3_QRCODE
						FwalertWarning('Está etiqueta ja foi apontada...','Atenção !!!')
						cOrdProd :=  SPACE(14)
						M->D3_QRCODE :=  SPACE(75)
						Return cOrdProd
					EndIf
					SD3->(DbSkip())
				EndDo
			EndIf

			M->D3_TM 	  := '001'
			M->D3_SEQUENC := cSeq
			M->D3_COD 	  := cProd
			M->D3_DESCRI  := cDesc
			M->D3_QUANT   := nQuantEtq
			M->D3_UM 	  := cUn
			M->D3_LOCAL   := cLoc
			M->D3_CONTA   := cConta
			M->D3_CC	  := cCCusto
			M->D3_DOC	  := substr(cOrdProd,1,8)

			//se o apontamento é parcial ou total.
			if nQuantEtq >= nSaldo
				M->D3_PARCTOT := 'T'
			else
				M->D3_PARCTOT := 'P'
			endif

			xRet := cOrdProd
		else // acionar o gatilho na OP, para confirmar a quantidade igual ao que está na etiqueta.
			if !nQuantEtq == M->D3_QUANT
				xRet := nQuantEtq
			Else			
				xRet := M->D3_QUANT
			endif

			//se o apontamento é parcial ou total.
			if nQuantEtq >= nSaldo
				M->D3_PARCTOT := 'T'
			else
				M->D3_PARCTOT := 'P'
			endif
		endif

		Return xRet
	endif

Return
