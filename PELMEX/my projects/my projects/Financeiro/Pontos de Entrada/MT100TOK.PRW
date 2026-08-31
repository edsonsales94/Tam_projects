#Include "rwmake.ch"
#Include "Protheus.ch"
#include "topconn.ch"  


/*_____________________________________________________________________________
¦ Função    ¦ MT100TOK     ¦ Autor ¦ Wilson Junior        ¦ Data ¦ 30/01/2020	  ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Validação ao incluir documento de entrada X Financeiro   		  ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function MT100TOK 


	Local cFuncao  := Upper(Alltrim(FunName()))
	Local lRet     := .T.
	Local cAlias   := Alias()
	Local cTexto    := "Título(s) Provisionado(s):"
	Local _cTitulos := ""
	Local _cLoja    := ""
	Local _cFornece := ""          
	Local _cDoc     := ""

	if (cFuncao == "MATA103" )

		_cLoja    := CLOJA
		_cFornece := CA100FOR          
		_cDoc     := CNFISCAL      


		Private oFont, oMemo, oConf

		BeginSql Alias "TSE2"


			SELECT E2_NUM,E2_PREFIXO,E2_FORNECE,E2_LOJA,E2_VENCTO,E2_SALDO,E2_TIPO 
			FROM %Table:SE2% (NOLOCK)
			WHERE E2_TIPO = 'PR'
			AND D_E_L_E_T_ = ''
			AND E2_SALDO > 0 
			AND E2_PREFIXO = 'FIN'
			//AND SUBSTRING(E2_VENCTO,1,6) = %Exp:dData% 
			AND E2_FORNECE = %Exp:_cFornece%
			AND E2_LOJA = %Exp:_cLoja%
			AND CAST (E2_NUM AS INT) = CAST(%Exp:_cDoc% AS INT)
			ORDER BY E2_VENCTO



		EndSql

		lRet := TSE2->(Eof())

		TSE2->(dbGoTop())

		While !TSE2->(Eof())
			_cTitulos += "Título: "+TSE2->E2_NUM +" Prefixo: "+TSE2->E2_PREFIXO+chr(13)+chr(10)
			TSE2->(dbSkip())
			lRET := .F.
		End

		TSE2->(dbCloseArea())

		If !lRet
			Aviso("Atencao","Os Seguinte(s) Título(s) esta(o) Provisionado(s) para este Fornecedor. Comunicar ao Setor de Contas a Pagar.",{"OK"})
			oFont:= TFont():New("ARIAL BLACK",07,15)

			@ 000,000 To 300,600 Dialog oDlgMemo Title "Título(s) Provisionado(s):"
			@ 001,003 Get _cTitulos  Size 300,230  MEMO Object oMemo When .F.
			oMemo:oFont:=oFont

			@ 135,270 BmpButton Type 1 Action CLOSE(oDLGMEMO) Object oConf

			Activate Dialog oDlgMemo CENTERED On Init (oMemo:SetFocus())	
		EndIf

		dbSelectArea(cAlias)



	ENDIF

return lRet

