
User Function FTVD7002()
   adArea := getArea()
   _adSF2 := SF2->(getArea())
   
   If paramIxb[1] == 2 // Finalização da Venda
       
      SF2->(dbSetOrder(1))
      If SF2->(dbSeek(xFilial() + SL1->L1_DOC + SL1->L1_SERIE))
         u_AAFATE03("S") // Chamar a Tela com Peso e Especie
      EndIf   
   EndIf
   
   SF2->(_adSF2)
   RestArea(adArea)
Return u_LJ7002()