#Include "Protheus.ch"
/*
+-----------------------------------------------------------------------------+
|Programa  : Tributos                                                         |
|Descrição : Função única para o Sispag ITAU                                  |
+-----------------------------------------------------------------------------+
|Autor     : ANDRE                                 |                          |
|Observacao:                  31/03/2010                                      |
+-----------------------------------------------------------------------------+
*/
User Function TribItau()

Local  _cRetorno  := ""

		
		//  Dados DARF e SIMPLES
		If (SEA->EA_MODELO == "16" .or. SEA->EA_MODELO == "18")
			
			
			// Posicao 018 a 019: Identificacao do Tributo 02-Darf 03-Darf Simples
			_cRetorno := If(SEA->EA_MODELO=="18","03","02")
			
			
			// Posicao 020 a 023: Codigo da Receita
			_cRetorno +=  Strzero(Val(SE2->E2_CRECEIT),4)
			
			
			// Posicao 024 a 024: Tp Inscricao  1-CPF /  2-CNPJ
			_cRetorno += "2"
			
			
			// Posicao 025 a 038: N Inscricao  //--- CNPJ/CPF do Contribuinte
			_cRetorno += Subs(SM0->M0_CGC,1,14)
			
			
			// Posicao 039 a 046: Periodo Apuracao
			_cRetorno += GravaData(SE2->E2_E_APUR,.F.,5)
			
			
			// Posicao 047 a 063: Referencia
			_cRetorno += Repl("0",17)
			
			
			// Posicao 064 a 077: Valor Principal
			_cRetorno += Strzero(SE2->E2_SALDO*100,14)
			
			
			// Posicao 078 a 091: Multa
			_cRetorno += STRZERO(SE2->E2_ACRESC*100,14)
			
			
			// Posicao 092 a 105: Juros
			_cRetorno += STRZERO(0,14)
			
			
			// Posicao 106 a 119: Valor Total (Principal + Multa + Juros)
			_cRetorno += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14)
			
			
			// Posicao 120 a 127: Data Vencimento
			_cRetorno += GravaData(SE2->E2_VENCTO,.F.,5)
			
			
			// Posicao 128 a 135: Data Pagamento
			_cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)
			
			
			// Posicao 136 a 165: Compl.Registro
			_cRetorno += Space(30)
			
			
			// Posicao 166 a 195: Nome do Contribuinte
			_cRetorno += Subs(SM0->M0_NOMECOM,1,30)
			
			
			//--- Mensagem ALERTA que está sem periodo de apuração
			If Empty(SE2->E2_E_APUR)
				
				MsgAlert('Tributo sem Data de Apuracao. Informe o campo Per.Apuracao no titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')
				
		EndIf
			
			
			
			
			// Dados GPS-------------------------------------------------------------
		Elseif SEA->EA_MODELO == "17"
			
			// Posicao 018 a 019: Identificacao do Tributo 01-GPS
			_cRetorno := "01"
			                                                                         
			
			// Posicao 020 a 023: Codigo Pagamento
			_cRetorno +=  Strzero(Val(SE2->E2_CRECEIT),4)
			
			
			// Posicao 024 a 029: Competencia
			_cRetorno += Subs(SE2->E2_DCOMPET,1,2) + Subs(SE2->E2_DCOMPET,4,4)
			
			
			// Posicao 030 a 043: N Identificacao  //--- CNPJ/CPF do Contribuinte
			_cRetorno += Strzero(Val(SM0->M0_CGC),14)
			
			
			// Posicao 044 a 057: Valor Principal (Valor Titulo - Outras Entidades)
			_cRetorno += Strzero((SE2->E2_SALDO-SE2->E2_E_VLENT)*100,14)
			
			// Posicao 058 a 071: Valor Outras Entidades
			_cRetorno += Strzero(SE2->E2_E_VLENT*100,14)
			
			// Posicao 072 a 085: Multa
			_cRetorno += Strzero(SE2->E2_ACRESC*100,14)
			
			// Posicao 086 a 099: Valor Total (Principal + Multa)
			_cRetorno += Strzero((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14)
			
			// Posicao 100 a 107: Data Vencimento
			_cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)
			
			// Posicao 108 a 115: Compl.Registro
			_cRetorno += Space(8)
			
			// Posicao 116 a 165: Informacoes Complementares
			_cRetorno += Space(50)
			
			
			// Posicao 166 a 195: Nome do Contribuinte
			_cRetorno += Subs(SM0->M0_NOMECOM,1,30)
			
			
			//--- Mensagem ALERTA que está sem periodo de apuração
			If Empty(SE2->E2_DCOMPET)
				
				MsgAlert('Tributo sem Competencia. Informe o campo Competencia no titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')
				
		EndIf
			
			
			
			// Dados Gare-Icms-SP-----------------------------------------------------
		Elseif SEA->EA_MODELO == "22"
			
			// Posicao 018 a 019: Identificacao do Tributo
			_cRetorno := "05"
			
			
			// Posicao 020 a 023: Codigo Pagamento
			_cRetorno +=  Strzero(Val(SE2->E2_CRECEIT),4)
			
			
			// Posicao 024 a 024: Tp Inscricao  1-CPF /  2-CNPJ
			_cRetorno += "2"
			
			
			// Posicao 025 a 038: N Inscricao Cnpj
			_cRetorno += Subs(SM0->M0_CGC,1,14)
			
			
			// Posicao 039 a 050: N Inscricao Estadual
			_cRetorno += Strzero(Val(SM0->M0_INSC),14)
			
			
			// Posicao 051 a 063: Divida ativa
			_cRetorno += Repl("0",13)
			
			
			// Posicao 064 a 069: Mes/Ano referencia
			_cRetorno += STRZERO(MONTH(SE2->E2_E_APUR),2) + STRZERO(YEAR(SE2->E2_E_APUR),4)
			
			
			//Posicao 070 a 082:Numero parcelado/notificacao
			_cRetorno += Repl("0",13)
			
			
			//Posicao 083 a 096: Valor da Receita
			_cRetorno += Strzero(SE2->E2_SALDO*100,14)
			
			
			// Posicao 097 a 110: Valor juros
			_cRetorno += Repl("0",14)
			
			
			// Posicao 111 a 124: Multa
			_cRetorno += Strzero(SE2->E2_ACRESC*100,14)
			
			
			// Posicao 125 a 138: Valor do pagamento
			_cRetorno += Strzero((SE2->E2_SALDO-SE2->E2_ACRESC)*100,14)
			
			
			// Posicao 139 a 146: Data Vencimento DDMMAAAA
			_cRetorno += GravaData(SE2->E2_VENCTO,.F.,5)
			
			
			// Posicao 147 a 154: Data pagamento DDMMAAAA
			_cRetorno += GravaData(SE2->E2_VENCTO,.F.,5)
			
			
			//Posicao 155 a 165:Compl.registro
			_cRetorno += SPACE(11)
			
			
			//Posicao 166 a 195:Nome contribuinte
			_cRetorno += SUBS(SM0->M0_NOMECOM,1,30)
			
			
		EndIf
   

return(_cRetorno)