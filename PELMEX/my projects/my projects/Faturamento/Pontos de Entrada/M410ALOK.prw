User Function M410ALOK()
Local lRet := .T.
Local cNum := SC5->C5_NUM
Local cCliente := SC5->C5_CLIENTE
Local nRegistro := 0

if cCliente $ "000028"
	lRet := .T.
endif

BeginSql Alias "KKK"
	
SELECT PED_NUM
FROM PED (NOLOCK) 
WHERE PED_NUM = %Exp:cNum%
AND PED_STATUS != 'C'
GROUP BY PED_NUM
EndSql

nRegistro := Contar("KKK","!Eof()")

KKK->(DbGoTop())

If (nRegistro > 0)
		Alert("Pedido já em produção. Por favor, não incluir ou alterar o(s) código(s) do(s) produto(s) ou a(s) quantdiade sem comunicar ao PCP ANTES.")
		lRet := .T.
ENDIF

KKK->(dbClosearea())

Return lRet

//114588,114589,114590,114592,114594