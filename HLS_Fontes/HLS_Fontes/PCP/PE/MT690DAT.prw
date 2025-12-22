/*/{Protheus.doc} MT690DAT

Valida apontamento de producao

@type function
@author Honda Lock
@since 01/10/2017

@return Logico, Se continua ou nao.

@history 01/10/2017, Valida o poder de terceiros.
/*/

User Function MT690DAT()

Local cOP := PARAMIXB[1]
Local dDtIni := PARAMIXB[2]
Local dDtFim := PARAMIXB[3]

Local aRet		:= {}       //-- Customizações do usuário                   
 
    Aadd(aRet, {dDATPRI, dDATPRF})
 
 Return aRet
