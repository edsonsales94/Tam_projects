
/*/{Protheus.doc} MT103NAT

O ponto de entrada é chamado ao digitar a natureza no documento de entrada.

@type function
@author Honda Lock
@since 01/10/2017

@return Logico, Aceita ou não a natureza digitada.
/*/

User Function MT103NAT
Local cNat := SA2->A2_NATUREZ
Local lRet := .T.          // Customizações do usuário      

IF SE2->E2_PREFIXO="UZM"
SE2->E2_NATUREZ
Else
SA2->A2_NATUREZ
Endif
Return lRet