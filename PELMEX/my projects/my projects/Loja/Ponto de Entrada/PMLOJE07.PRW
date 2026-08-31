`#Include "Rwmake.ch"
#Include "Protheus.ch"
#include "topconn.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ LJ140VLC   ¦ Autor ¦ Stan Lee Lopes   ¦ Data ¦ 01/04/2022 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada de exclusão da Orçamento/cupom no loja        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function LJ140VLC()
Local lRet := .T.
	
	If !(u_PMLOJE07())
		lRet := .F.
	EndIf
		
Retur lRet

User Function PMLOJE07()
Local lRet := .T.
Local Filial := xFilial('SL1')
Local cNum := M->L1_NUM
Local cCliente := M->L1_CLIENTE
//Local _cFilial := M->L1_FILIAL
Local nRegistro := 0

BeginSql Alias "KKK"

SELECT PED_NUM
FROM SL1100 SL1 (NOLOCK)
INNER JOIN SC5100 SC5 (NOLOCK) ON C5_XFILRES = L1_FILRES AND C5_XORCRES = L1_ORCRES AND SC5.D_E_L_E_T_ = ''
INNER JOIN PED (NOLOCK) ON PED_FILIAL = C5_FILIAL AND C5_NUM = PED_NUM
WHERE SL1.D_E_L_E_T_ =''
AND C5_XFILRES = %Exp:Filial%
AND C5_XORCRES = %Exp:cNum%

AND C5_CLIENTE = %Exp:cCliente% 
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