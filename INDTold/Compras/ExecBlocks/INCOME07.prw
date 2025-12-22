#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ INCOME07   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 12/08/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Execblock para validação dos dados da N.F. de Entrada         ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function INCOME07()
   Local cVar  := ReadVar()
   Local nPVia := AScan( aHeader , {|x| Trim(x[2]) == "D1_VIAGEM"  })
   Local nPTre := AScan( aHeader , {|x| Trim(x[2]) == "D1_TREINAM" })
   Local nPCLV := AScan( aHeader , {|x| Trim(x[2]) == "D1_CLVL"    })
   Local nPCtb := AScan( aHeader , {|x| Trim(x[2]) == "D1_CONTA"   })
   Local lRet  := .T.

   If cVar == "M->D1_CONTA"
      // Posiciona na conta contábil
      CT1->(dbSetOrder(1))
      CT1->(dbSeek(XFILIAL("CT1")+M->D1_CONTA))

      // Preenche a classe MCT com  o grupo contábil
      aCols[n,nPCLV] := PADR(Trim(CT1->CT1_GRUPO),Len(aCols[n,nPCLV]))
   ElseIf cVar == "M->D1_VIAGEM"
      If lRet := ExistCpo("SZ7")
         aCols[n,nPTre] := Space(Len(aCols[n,nPTre]))
         aCols[n,nPCLV] := PADR("006",Len(aCols[n,nPCLV]))
      Endif
   ElseIf cVar == "M->D1_TREINAM"
      If lRet := ExistCpo("SZ8")
         aCols[n,nPVia] := Space(Len(aCols[n,nPVia]))
         aCols[n,nPCLV] := PADR("007",Len(aCols[n,nPCLV]))
      Endif
   ElseIf cVar == "M->D1_CLVL"
      // Se foi preenchida a conta contábil
      If !Empty(aCols[n,nPCtb])
         // Posiciona na conta contábil
         CT1->(dbSetOrder(1))
         CT1->(dbSeek(XFILIAL("CT1")+aCols[n,nPCtb]))

         // Se a conta pertencer ao grupo de despesas do MCT
         If CT1->CT1_XMCT == "S"
            If !(lRet := (Trim(M->D1_CLVL) == Trim(CT1->CT1_GRUPO)))
               MsgAlert("Classe MCT diferente do Grupo Contábil ("+Trim(CT1->CT1_GRUPO)+") !","Atenção")
            Endif
         Endif
      Endif
   ElseIf cVar == "M->DE_CONTA"
      nPCLV := AScan( aHeader , {|x| Trim(x[2]) == "DE_CLVL" })

      // Posiciona na conta contábil
      CT1->(dbSetOrder(1))
      CT1->(dbSeek(XFILIAL("CT1")+M->DE_CONTA))

      // Preenche a classe MCT com  o grupo contábil
      aCols[n,nPCLV] := PADR(Trim(CT1->CT1_GRUPO),Len(aCols[n,nPCLV]))
   ElseIf cVar == "M->DE_CLVL"
      nPCtb := AScan( aHeader , {|x| Trim(x[2]) == "DE_CONTA" })

      // Se foi preenchida a conta contábil
      If !Empty(aCols[n,nPCtb])
         // Posiciona na conta contábil
         CT1->(dbSetOrder(1))
         CT1->(dbSeek(XFILIAL("CT1")+aCols[n,nPCtb]))

         // Se a conta pertencer ao grupo de despesas do MCT
         If CT1->CT1_XMCT == "S"
            If !(lRet := (Trim(M->DE_CLVL) == Trim(CT1->CT1_GRUPO)))
               MsgAlert("Classe MCT diferente do Grupo Contábil ("+Trim(CT1->CT1_GRUPO)+") !","Atenção")
            Endif
         Endif
      Endif
   Endif

Return lRet
