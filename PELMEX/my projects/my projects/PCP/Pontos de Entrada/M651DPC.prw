#Include "rwmake.ch"
#Include "Protheus.ch"
#include "topconn.ch"

/*_____________________________________________________________________________
¦ Função    ¦ M651DPC    ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 16/12/2011 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Validação ao Firmar OP   													¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function M651DPC

	Local cFuncao := Upper(Alltrim(FunName()))
	Local lRet := .T.
	Local cAlias := Alias()
	Local cTexto :=""
	Local cOP := SC2->(C2_NUM + C2_ITEM + C2_SEQUEN)
	Private oFont, oMemo, oConf

	BeginSql Alias "TSD4"

		Select D4_COD, D4_LOCAL, D4_QTDEORI, D4_QUANT, Saldo
		From %Table:SD4% D4

		Inner Join
		(Select B2_COD, B2_LOCAL, (B2_QATU - B2_QEMP) As Saldo
		From %Table:SB2%
		Where %notdel%
		And B2_FILIAL = %xFilial:SB2%
		) B2
		On D4_COD = B2_COD
		And D4_LOCAL = B2_LOCAL

		Where %notdel%
		And D4_FILIAL = %xFilial:SD4%
		And D4_OP = %Exp:cOP%
		And LEFT(D4_COD, 3) <> 'MOD'

		And D4_QUANT > Saldo

	EndSql

	lRet := TSD4->(Eof())

	TSD4->(dbGoTop())

	While !TSD4->(Eof())
		cTexto += "Comp.: " + TSD4->D4_COD + " Qtd. Necessaria : " + str(TSD4->D4_QUANT,15,4) + " Qtd. Disponível : " + str(TSD4->Saldo,15,4)+chr(13)+chr(10)
		TSD4->(dbSkip())
	End

	TSD4->(dbCloseArea())

	If !lRet

		Aviso("Atencao","Existe(m) componente(s) sem saldo suficiente para produção!",{"OK"})
		oFont:= TFont():New("ARIAL BLACK",07,15)

		@ 000,000 To 300,500 Dialog oDlgMemo Title "Log de Apontamento"
		@ 001,003 Get cTexto  Size 240,130  MEMO Object oMemo When .F.
		oMemo:oFont:=oFont

		@ 140,170 BmpButton Type 1 Action CLOSE(oDLGMEMO) Object oConf

		Activate Dialog oDlgMemo CENTERED On Init (oMemo:SetFocus())

	EndIf

	dbSelectArea(cAlias)

Return lRet
