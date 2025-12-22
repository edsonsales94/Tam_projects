User Function GP650CPO
  Local nReg, nInd, cAlias
  
  Local aArea := GEtARea()

  cAlias := Alias()

  Pergunte("GPM650",.F.)

  DbSelectArea("RC0")
  nReg := Recno()
  nInd := IndexOrd()
  DbSetOrder(1)
  DbSeek(xFilial("RC0")+RC1->RC1_CODTIT)

  DbSelectArea("RC1")
  RecLock("RC1",.F.)
  RC1->RC1_DATARQ := SubStr(MV_PAR12,3,4)+If( RC1_TIPO $ "131,132" , "13", SubStr(MV_PAR12,1,2))
  RC1->RC1_VERBAS := RC0->RC0_VERBAS
  RC1->RC1_PARFOL := mv_par01+mv_par02+mv_par03+mv_par04+mv_par05+mv_par06
  RC1->RC1_CLVL   := Posicione("SRA",1,XFILIAL("SRA")+RC1->RC1_MAT,"RA_CLVL")
  RC1->RC1_FILTRF := If( Empty(RC0->RC0_FILTRF) , ".T.", RC0->RC0_FILTRF)
  RC1->RC1_FILTRV := If( Empty(RC0->RC0_FILTRV) , ".T.", RC0->RC0_FILTRV)
  MsUnlock()

  //dbSelectArea("RC0")
  //dbSetOrder(nInd)
  //dbGoTo(nReg)
  //dbSelectArea(cAlias)
  RestArea(aArea)
Return
