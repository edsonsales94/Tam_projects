
/*/{Protheus.doc} SC6EXP

Chamada de relatorio em Crystal.

@type function
@author Honda Lock
@since 01/10/2017

/*/

Static Function SC6EXP()
  Local _cPerg := "RELSC6"
  
  If Pergunte(_cPerg,.T.)  
  CALLCRYS("RELSC6",mv_par01,mv_par02,)
  EndIf
Return 	