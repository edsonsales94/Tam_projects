#Include "totvs.ch"

User Function LJ7009()
/*---------------------------------------------------------------------------------------------------------------------------------------------------
Ponto de entrada para validar a troca das formas de pagamentos quando o usuário for CAIXA
OBJETIVO 1: Chamada na troca das formas de pagamentos na Venda Assistida.
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/

Local cLibCaixa    	:= GETMV("MV_XCXLIB")   // Caixa liberado 
Local aParams := iIf( PARAMIXB<>nil, aClone(PARAMIXB), {} )
Local aParcResul := iIf( Len(aParams) > 0, aParams[1], {} )
// dados originais do pagamento
Local aParcAlter := iIf( Len(aParams) > 1, aParams[2], {} ) //

lRet := .T.

If nNCCUsada = 0 // Variavel Padrao do Sistema que determinada o valor usado de NCC na Venda Assistida
	
	If SubStr(SLF->LF_ACESSO,3,1) == "S" .And. (!Alltrim(ParamIxb[2][3]) $ "Dinheiro#Cheque#Cartao de debito" .and. Alltrim(__cUserID ) <> cLibCaixa .or. ParamIxb[2][1] <> dDataBase )
		MsgAlert("Usuário CAIXA somente poderá alterar formas de pagamentos (R$, CD e CH) !","ATENÇÃO !!!")
		lRet := .F.
	Endif
	
EndIf

Return(lRet)
