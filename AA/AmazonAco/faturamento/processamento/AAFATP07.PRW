#include "Protheus.ch"

/*
Se Retorno For True o Pedido esta Bloqueado
*/

User Function AAFATP07(_cFilial,_cPedido)
	Local cQuery := ""
	Local _cTbl  := GetNextAlias()
	Local lRet   := .F.
	
	SC5->(dbSetORder(1))
	SC5->(dbseek(_cFilial + _cPedido))
	
	// Se não for um pedido de venda com reserva
	If Empty(SC5->C5_XORCRES)
		SA1->(dbSetOrder(1) )
		SA1->(dbSeek(xFilial('SA1') + SC5->(C5_CLIENTE + C5_LOJACLI) ))
		
		If lRet := (SA1->A1_RISCO != 'A')
			cQuery += " Select * From " + RetSqlName("SC9")
			cQuery += " Where D_E_L_E_T_ = '' AND C9_BLCRED  != '' "
			cQuery += " And C9_PEDIDO = '" + _cPedido + "'"
			cQuery += " And C9_FILIAL = '" + _cFilial + "'
			cQuery += " And C9_NFISCAL = ''
			
			dbUseArea( .t., "TopConn", TCGenQry(,,ChangeQuery(cQuery)), _cTbl , .F., .F. )
			
			lRet := !(_cTbl)->(EOF())
			(_cTbl)->(dbCloseArea(_cTbl) )
			
			If lRet
				Aviso('Atencao','Pedido Encontra-se Bloqueado por Credito, Verifique com o Setor Financeiro',{'OK'},1)
			EndIf
		Endif
	Endif
	
Return lRet
/*powered by DXRCOVRB*/