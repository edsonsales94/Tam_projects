#Include "rwmake.ch"
#Include "Protheus.ch"
#include "topconn.ch"  


/*_____________________________________________________________________________
¦ Função    ¦ M651DPC    ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 16/12/2011 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Validação ao Firmar OP   													¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MA650TOK

	Local cFuncao := Upper(Alltrim(FunName()))
	Local lRet := .T.
	Local cAlias := Alias()
	Local cTexto :=""
	Local cOP := SC2->(C2_NUM + C2_ITEM + C2_SEQUEN) 
	Local cCodProd := M->C2_PRODUTO                  
	Local nQTD := M->C2_QUANT
	Private oFont, oMemo, oConf

	BeginSql Alias "TSD4"

		SELECT G1_COD,G1_COMP,(G1_QUANT*%Exp:nQTD%) QUANT,B2_QATU-0,B2_QATU-(G1_QUANT*%Exp:nQTD%) DISPONIVEL
		FROM %Table:SG1% SG1 (NOLOCK)
		INNER JOIN %Table:SC2% SC2 (NOLOCK) ON G1_COD = C2_PRODUTO AND SC2.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB2% SB2 (NOLOCK) ON G1_COMP = B2_COD AND SB2.D_E_L_E_T_ = ''
		WHERE G1_COD = %Exp:cCodProd%
		AND B2_LOCAL = '10'
		AND C2_DATRF = ''
		AND SG1.D_E_L_E_T_ = ''
		AND B2_FILIAL = '01'
		AND G1_COMP NOT LIKE 'MOD%'
		GROUP BY G1_COD,G1_COMP,B2_QATU,G1_QUANT,C2_QUANT
		ORDER BY G1_COMP

	EndSql

	lRet := TSD4->(Eof())

	TSD4->(dbGoTop())

	While !TSD4->(Eof())
		cTexto += "Comp.: " + TSD4->G1_COMP + " Qtd. Necessaria : " + str(TSD4->QUANT,15,4) + " Qtd. Disponível : " + str(TSD4->DISPONIVEL,15,4)+chr(13)+chr(10)
		TSD4->(dbSkip())
	End

	TSD4->(dbCloseArea())

	If !lRet

		Aviso("Atencao","Existe(m) componente(s) sem saldo suficiente para produção!",{"OK"})
		oFont:= TFont():New("ARIAL BLACK",07,15)

		@ 000,000 To 300,600 Dialog oDlgMemo Title "Log de Apontamento"
		@ 001,003 Get cTexto  Size 300,130  MEMO Object oMemo When .F.
		oMemo:oFont:=oFont

		@ 135,270 BmpButton Type 1 Action CLOSE(oDLGMEMO) Object oConf

		Activate Dialog oDlgMemo CENTERED On Init (oMemo:SetFocus())
	End If

	dbSelectArea(cAlias)

Return lRet
