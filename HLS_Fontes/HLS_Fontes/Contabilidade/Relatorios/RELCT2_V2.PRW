Static Function CT2CUSTO()
  Local _cPerg := "RELCT2"
  
  If Pergunte(_cPerg,.T.)  
  CALLCRYS("RELCT2",mv_par01,mv_par02,mv_par03)
  EndIf
Return 	