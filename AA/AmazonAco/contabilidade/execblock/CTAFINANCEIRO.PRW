#Include 'Protheus.ch'
User Function CTAFINANCEIRO()
	Local _ndValor := 0
	Local _adSF2   := SF2->(getArea())
    
	If Alltrim(SE1->E1_ORIGEM) $ "FATA701/LOJA701"
	
		SF2->(dbGoTop())
		SF2->(dbSetOrder(1))
		
		If !SF2->(dbSeek( SE1->E1_FILORIG + SE1->E1_NUM + SE1->E1_PREFIXO )) //.And. lContab
			_ndValor := iIf(SE1->E1_VALOR < SE1->E1_VLRREAL, SE1->E1_VLRREAL , SE1->E1_VALOR )
		EndIf
	
	EndIf

	RestArea(_adSF2)
Return _ndValor


User Function CTACOMPENSACAO()
	Local _ndValor := 0
	Local _adSF2   := SF2->(getArea())
    
    If ALLTRIM(SE5->E5_TIPO)$"NCC"
		SE1->(dBSetOrder(1))
		If SE1->(dbSeek( xFilial('SE1') + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO ))
			If Alltrim(SE1->E1_ORIGEM) $ "MATA460/FATA701/LOJA701"
		
				SF2->(dbGoTop())
				SF2->(dbSetOrder(1))
			
				If SF2->(dbSeek( SE1->E1_FILORIG + SE1->E1_NUM + SE1->E1_PREFIXO )) //.And. lContab
					_ndValor := SE5->E5_VALOR
				EndIf
			EndIF		
		EndIf
	Else 
	   _ndValor := SE5->E5_VALOR
    EndIf
    
	RestArea(_adSF2)
Return _ndValor
