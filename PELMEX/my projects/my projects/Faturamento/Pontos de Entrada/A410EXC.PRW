User Function A410EXC()
Local LRet := .T.
Local cNum := M->C5_NUM
Local nRegistro := 0

BeginSql Alias "KKK"

SELECT PED_NUM
FROM PED (NOLOCK) 
WHERE PED_NUM = %Exp:cNum%
AND PED_STATUS != 'C'
GROUP BY PED_NUM

EndSql

nRegistro := Contar("KKK","!Eof()")
KKK->(DbGoTop())     
If nRegistro > 0
	lRet := .F.
	Alert("Pedido já em produção. Por favor, entre em contato com o setor de PCP.")
EndIf
KKK->(dbClosearea())

Return lRet
