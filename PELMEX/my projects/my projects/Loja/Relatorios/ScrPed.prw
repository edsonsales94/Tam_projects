#INCLUDE "RWMAKE.CH"

User Function SCRPED()
	Local nOrcam
	Local sTexto                      
	Local nCheques
	Local nCartao
	Local nConveni
	Local nVales
	Local nFinanc
	Local nCredito		:= 0
	Local nOutros
	Local cQuant 		:= ""
	Local cVrUnit		:= ""
	Local cDesconto		:= ""
	Local cVlrItem		:= ""
	Local nVlrIcmsRet	:= 0			// Valor do icms retido (Substituicao tributaria) 
	Local mvDocped 		:= Getmv("MV_LOJAPED") 

	SX5->(dbSetOrder(1))
	SX5->(dbSeek(xFilial("SX5")+"01"+mvDocped))

	sTexto:= ALLTRIM(SM0->M0_NOMECOM)+Chr(13)+Chr(10)  
	sTexto:= sTexto+'CNPJ:'+SM0->M0_CGC+'/'+ALLTRIM(SM0->M0_INSC)+Chr(13)+Chr(10)
	sTexto:= sTexto+ALLTRIM(SM0->M0_ENDCOB)+', '+ALLTRIM(SM0->M0_BAIRCOB)+', '+ALLTRIM(SM0->M0_CIDENT)+Chr(13)+Chr(10)
	sTexto:= sTexto+Chr(13)+Chr(10)
	sTexto:= sTexto+'-----------------------------------------------'+Chr(13)+Chr(10) 
	IF empty(SL1->L1_DOCPED)
		sTexto:= sTexto+DTOC(SL1->L1_EMISNF)+' '+SL1->L1_HORA+' DOC: '+STRZERO(VAL(ALLTRIM(SX5->X5_DESCRI))-1,9)+'/'+SX5->X5_CHAVE+Chr(13)+Chr(10)     
	ELSE
		sTexto:= sTexto+DTOC(SL1->L1_EMISNF)+' '+SL1->L1_HORA+' PEDIDO: '+SL1->L1_DOCPED+'/'+SL1->L1_SERPED+Chr(13)+Chr(10)
	ENDIF
	sTexto:= sTexto+Chr(13)+Chr(10)
	sTexto:= sTexto+'Codigo         Descricao'+Chr(13)+Chr(10)
	sTexto:= sTexto+ 'Qtd             VlrUnit                 VlrTot'+Chr(13)+Chr(10)
	sTexto:= sTexto+'-----------------------------------------------'+Chr(13)+Chr(10)

	nOrcam		:= SL1->L1_NUM
	nDinheir	:= SL1->L1_DINHEIR
	nCheques	:= SL1->L1_CHEQUES
	nCartao 	:= SL1->L1_CARTAO
	nConveni	:= SL1->L1_CONVENI
	nVales  	:= SL1->L1_VALES  	
	nFinanc		:= SL1->L1_FINANC
	nCredito	:= SL1->L1_CREDITO
	nOutros		:= SL1->L1_OUTROS

	dbSelectArea("SL2")
	dbSetOrder(1)  
	dbSeek(xFilial("SL2") + nOrcam)

	While !SL2->(Eof()) .AND. SL2->L2_FILIAL + SL2->L2_NUM == cFilAnt + nOrcam
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Faz o tratamento do valor do ICMS ret.                       �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		If SL2->(FieldPos("L2_ICMSRET")) > 0 
			nVlrIcmsRet	:= SL2->L2_ICMSRET
		Endif

		cQuant 		:= StrZero(SL2->L2_QUANT, 8, 3)
		cVrUnit		:= Str(((SL2->L2_QUANT * SL2->L2_PRCTAB) + SL2->L2_VALIPI + nVlrIcmsRet) / SL2->L2_QUANT, 15, 2)
		cDesconto	:= Str(SL2->L2_VALDESC, TamSx3("L2_VALDESC")[1], TamSx3("L2_VALDESC")[2])
		cVlrItem	:= Str(Val(cVrUnit) * SL2->L2_QUANT, 15, 2)
		sTexto		:= sTexto + SubStr(IIF(!EMPTY(Posicione("SB1",1,xFilial("SB1")+SL2->L2_PRODUTO,"B1_CODBAR")),Posicione("SB1",1,xFilial("SB1")+SL2->L2_PRODUTO,"B1_CODBAR"),SL2->L2_PRODUTO),1,15) + SL2->L2_DESCRI + Chr(13) + Chr(10)
		sTexto		:= sTexto + cQuant + '  ' + cVrUnit + '      ' + cVlrItem + Chr(13) + Chr(10)
		If SL2->L2_VALDESC > 0 
			sTexto	:= sTexto + 'Desconto no Item:              ' + Str(SL2->L2_VALDESC, 15, 2) + Chr(13) + Chr(10)
		EndIf
		SL2->(DbSkip())
	Enddo                      

	If SL1->L1_DESCONTO > 0
		sTexto	:= sTexto + 'Desconto no Total:             ' + Str(SL1->L1_DESCONTO, 15, 2) + Chr(13) + Chr(10)
	EndIf                                                                              
	If SL1->L1_JUROS > 0
		sTexto	:= sTexto + 'Acrescimo no Total:            ' + Transform(SL1->L1_JUROS, "@R 99.99%") + Chr(13) + Chr(10)
	EndIf

	sTexto	:= sTexto + '-----------------------------------------------' + Chr(13) + Chr(10)
	sTexto	:= sTexto + 'TOTAL                         ' + Str(SL1->L1_VLRLIQ+nCredito, 15, 2) + Chr(13) + Chr(10)

	If nDinheir > 0 
		sTexto := sTexto + 'DINHEIRO' + '                       ' + Str(nDinheir, 15, 2) + Chr(13) + Chr(10)
	EndIf
	If nCheques > 0 
		sTexto := sTexto + 'CHEQUE' + '                         ' + Str(nCheques, 15, 2) + Chr(13) + Chr(10)
	EndIf
	If nCartao > 0 
		sTexto := sTexto + 'CARTAO' + '                          ' + Str(nCartao, 15, 2) + Chr(13) + Chr(10)
	EndIf
	If nConveni > 0 
		sTexto := sTexto + 'CONVENIO' + '                        ' + Str(nConveni, 15, 2) + Chr(13) + Chr(10)
	EndIf
	If nVales > 0 
		sTexto := sTexto + 'VALES' + '                           ' + Str(nVales, 15, 2) + Chr(13) + Chr(10)
	EndIf
	If nFinanc > 0 
		sTexto := sTexto + 'FINANCIADO' + '                      ' + Str(nFinanc, 15, 2) + Chr(13) + Chr(10)
	EndIf  
	If nCredito > 0
		sTexto := sTexto + 'CREDITO ' + '                       ' + Str(nCredito, 15, 2) + Chr(13) + Chr(10)
	EndIf			

	sTexto := sTexto + '-----------------------------------------------' + Chr(13) + Chr(10)  + Chr(13) + Chr(10)

	sTexto := sTexto +'Vendedor: '+ALLTRIM(SL1->L1_VEND)+' - '+ALLTRIM(Posicione("SA3",1,xFilial("SA3")+SL1->L1_VEND,"A3_NREDUZ"))+ Chr(13) + Chr(10)  
	sTexto := sTexto +'Cliente: '+ALLTRIM(SL1->L1_CLIENTE)+'/'+SL1->L1_LOJA+' - '+ALLTRIM(Posicione("SA1",1,xFilial("SA1")+SL1->(L1_CLIENTE+L1_LOJA),"A1_NOME"))+ Chr(13) + Chr(10)

	sTexto := sTexto + Chr(13) + Chr(10)  + Chr(13) + Chr(10)  + Chr(13) + Chr(10) 
	sTexto := sTexto + Chr(13) + Chr(10)  + Chr(13) + Chr(10)+ '-----------------------------------------------' 

Return sTexto