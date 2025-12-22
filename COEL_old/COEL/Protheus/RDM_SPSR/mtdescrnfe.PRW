User Function MTDESCRNFE()  

//ALERT("TESTE")
     
cDescr:="" 

dbSelectArea("SE1")
dbSetOrder(2)
If dbSeek(xFilial("SE1")+PARAMIXB[3]+PARAMIXB[4]+PARAMIXB[2]+PARAMIXB[1])
   cDescr := (" MAO-DE-OBRA,   VENCIMENTO: "+dtoc(SE1->E1_VENCREA))
EndIf

Return(cDescr)