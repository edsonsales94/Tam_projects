#Include "Protheus.ch"

User Function CTABAIXA(_cdTp)
	
	Local _ndValor := 0
	Local _adSE5   := SE5->(getArea())	
	
	Default _cdTp := "0"
	
	
	If _cdTp == "CLI"
		// Baixa a Receber Cliente Credito: 112010001
		_ndValor := BAIXACLI() // BAIXA de CLIENTE
	ElseIf _cdTp == "BNDES"
		// BAIXA a RECEBER BNDES CREDITO: 113010002
		_ndValor := BAIXABNDES() // BAIXA CARTAO BNDES
	EndIf
	
	SE5->(RestArea(_adSE5))
Return _ndValor



/******************************************************************************************************
// IIF(ALLTRIM(SE5->E5_TIPODOC)$"LJ/NCC/RA" 
       .OR. ALLTRIM(SE5->E5_TIPO)$"CC/CD/NCC/RA/CH/CT/DC/RE/FI" .OR.
        ALLTRIM(SE5->E5_MOTBX)$"FUN",
        0,SE5->E5_VALOR-SE5->E5_VLJUROS-SE5->E5_VLMULTA+SE5->E5_VLDESCO)
// Retirado do Lancamento Padrão 520-020 e Colocado no Programa Para Efetuar
Validação da Vendas Efetuas por BNDES
// Criado para Corrigir a Contabilização pois Titulos gerados pelo FATURAMENTO
estavam contabilizando Na CONTA de Cliente "112010001"
// Trazido o LANPAD para este programa para checar a
CONDICAO de PAGAMENTO UTILIZADA (178)
E Assim Validar Se Deve Ser Contabilizado na Conta de Credito "112010001"
Caso Contrario Retorna ZERO
******************************************************************************************************/
Static Function BAIXACLI()
	
	Local _cdCond  := SuperGetMv("MV_XBNDES",.F.,"178") //Condição de Pagamento Referente a Vendas pelo BNDES
	_ndValor := 0
	
	If ALLTRIM(SE5->E5_TIPODOC)$"LJ/NCC/RA" .OR.;
	   ALLTRIM(SE5->E5_TIPO)$"CC/CD/NCC/RA/CH/CT/DC/RE/FI" .OR.;
	   ALLTRIM(SE5->E5_MOTBX)$"FUN"
		_ndValor := 0
	Else
		_ndValor := SE5->E5_VALOR-SE5->E5_VLJUROS-SE5->E5_VLMULTA+SE5->E5_VLDESCO
		
		SE1->(dbSetOrder(1))
		If SE1->(dbSeek(SE5->E5_FILIAL + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO ))
		
			SF2->(dbGoTop())
			SF2->(dbSetOrder(1))
			
			If SF2->(dbSeek( SE1->E1_FILORIG + SE1->E1_NUM + SE1->E1_PREFIXO ))
				_ndValor := iIf( SF2->F2_COND == _cdCond , 0 , _ndValor)
			EndIf
		EndIf
		
	EndIf
Return _ndValor



/******************************************************************************************************
// IIF(ALLTRIM(SE5->E5_TIPODOC)$"LJ/NCC/RA",0,IIF( ALLTRIM(SE5->E5_TIPO)$"FI",SE5->E5_VALOR-SE5->E5_VLJUROS-SE5->E5_VLMULTA+SE5->E5_VLDESCO,0))
// Retirado do Lancamento Padrão 520-024 e Colocado no Programa Para Efetuar
   Validação da Vendas Finalizadas Pelo Faturamento para Considerar o BNDES
   Pois Não estavam caindo nesta Conta de Credito : 113010002
// Trazido o LANPAD para este programa para checar a
   CONDICAO de PAGAMENTO UTILIZADA (178)
   E Assim Validar Se Deve Ser Contabilizado na Conta de Credito "113010002"
******************************************************************************************************/
Static Function BAIXABNDES()
	
	Local _cdCond  := SuperGetMv("MV_XBNDES",.F.,"178") //Condição de Pagamento Referente a Vendas pelo BNDES
	_ndValor := 0
	
	If Alltrim(SE5->E5_TIPODOC)$"LJ/NCC/RA"
		_ndValor := 0
	else
		If Alltrim(SE5->E5_TIPO)$"FI"
			_ndValor := SE5->E5_VALOR-SE5->E5_VLJUROS-SE5->E5_VLMULTA+SE5->E5_VLDESCO
		Else
		    _ndValor := SE5->E5_VALOR-SE5->E5_VLJUROS-SE5->E5_VLMULTA+SE5->E5_VLDESCO
		    		    
			SF2->(dbGoTop())
			SF2->(dbSetOrder(1))
			
			If SF2->(dbSeek( SE5->E5_FILORIG + SE5->E5_NUMERO + SE5->E5_PREFIXO ))
				_ndValor := iIf( SF2->F2_COND == _cdCond , _ndValor , 0)
			Else
			    _ndValor := 0
			EndIf
			
		EndIF
	EndIf
Return _ndValor
