#Include "rwmake.ch"

User Function LJ010SNF()
/*---------------------------------------------------------------------------------------------------------------------------------------------------
Ponto de entrada executado após a Confirmação da Série da Nota Fiscal.
OBJETIVO 1: Não permitir a geração da Nota Fiscal de Saída quando o cliente for CLIENTE PADRÃO
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/
lRet := .T.

Do Case
	Case AllTrim(Funname()) == "LOJR130"   // Quando for a Rotina NOTA FISCAL PARA CUPOM
		cCliente	:= SF2->F2_CLIENTE
	Case AllTrim(Funname()) == "LOJA701"   // Quando for a Rotina NOTA FISCAL PARA CUPOM
		cCliente	:= SL1->L1_CLIENTE
EndCase

If cCliente == GETMV("MV_CLIPAD")   													// Verifica se a Venda é para CLIENTE PADRÃO
	MSGALERT("Nota Fiscal não pode ser gerada para CLIENTE PADRÃO !!!", "ATENÇÃO")
	lRet := .F.
Endif

Return(lRet)
