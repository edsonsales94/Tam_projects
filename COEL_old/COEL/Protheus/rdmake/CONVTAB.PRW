* CONVTAB.PRW

user function convtab()

_nItemLP:= 1
dbselectArea("SB1")
dbGoTop() 
While !Eof()

   IncProc(OEMtoAnsi("Processando produto " + SB1->B1_COD))

   if empty(SB1->B1_PRV1)
      dbskip()
      loop
   endif

   dbSelectArea("DA1")
   RecLock("DA1",.T.)
   DA1->DA1_FILIAL	   := xFilial("DA1")
   DA1->DA1_ITEM	   := StrZero(_nItemLP,4)
   DA1->DA1_CODTAB	   := "1"
   DA1->DA1_CODPRO	   := SB1->B1_COD
   DA1->DA1_PRCVEN	   := SB1->PRV1
   DA1->DA1_ATIVO	   := "1"
   DA1->DA1_TPOPER	   := "4"
   DA1->DA1_QTDLOT	   := 999999.99
   DA1->DA1_INDLOT	   := "000000000999999.99"
   DA1->DA1_MOEDA	   := 1
   MsUnLock()

   _nitemLP := _nitemLP + 1

   dbSelectArea("SB1")
   dbSkip()

EndDo
