#Include "Rwmake.ch"

/*
Função que valida a natureza financeira, na inclusão do contas a pagar, 
onde as natureza que são sintéicas não podem receber lançamentos
*/
User function INFINE02()
   Local lRet := .T.
   Local cVar := ReadVar()


   If cVar == "M->E2_NATUREZ"
      SED->(dbsetorder(1))
      If lRet := SED->(dbseek(xFilial("SED")+M->E2_NATUREZ))
         If lRet := (SED->ED_TCONTA == "2")  // Se for Analítico
            // Posiciona na conta contábil
            CT1->(dbSetOrder(1))
            CT1->(dbSeek(XFILIAL("CT1")+SED->ED_CONTAB))

            // Preenche a classe MCT com  o grupo contábil
            M->E2_CLVL := PADR(Trim(CT1->CT1_GRUPO),Len(M->E2_CLVL))
         Else
            MsgAlert("Natureza sintética NÃO pode receber lançamentos ","Atenção")
         Endif
      Endif
   ElseIf cVar == "M->E2_VIAGEM"
      If lRet := ExistCpo("SZ7")
         M->E2_TREINAM := Space(Len(M->E2_TREINAM))
         M->E2_CLVL    := PADR("006",Len(M->E2_CLVL))
      Endif
   ElseIf cVar == "M->E2_TREINAM"
      If lRet := ExistCpo("SZ8")
         M->E2_VIAGEM := Space(Len(M->E2_VIAGEM))
         M->E2_CLVL   := PADR("007",Len(M->E2_CLVL))
      Endif
   ElseIf cVar == "M->E2_CLVL"
      // Se foi preenchida a natureza
      If !Empty(M->E2_NATUREZ)
         // Posiciona na natureza
         SED->(dbsetorder(1))
         SED->(dbseek(xFilial("SED")+M->E2_NATUREZ))
         // Posiciona na conta contábil
         CT1->(dbSetOrder(1))
         CT1->(dbSeek(XFILIAL("CT1")+SED->ED_CONTAB))

         // Se a conta pertencer ao grupo de despesas do MCT
         If CT1->CT1_XMCT == "S"
            If !(lRet := (Trim(M->E2_CLVL) == Trim(CT1->CT1_GRUPO)))
               MsgAlert("Classe MCT diferente do Grupo Contábil ("+Trim(CT1->CT1_GRUPO)+") !","Atenção")
            Endif
         Endif
      Endif
   Endif

Return lRet
