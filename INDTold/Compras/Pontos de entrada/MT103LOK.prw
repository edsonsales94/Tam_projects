#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MT103LOK   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 12/08/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ P.E. de validação dos rateios da N.F. de Entrada              ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MT103LOK()
   //Local cVar  := ReadVar()
   Local nPCtb := AScan( aHeader , {|x| Trim(x[2]) == "DE_CONTA" })
   Local nPCLV := AScan( aHeader , {|x| Trim(x[2]) == "DE_CLVL"  })
   Local lRet  := .T.

   // Se foi preenchida a conta contábil
   If lRet .And. !Empty(aCols[n,nPCtb])
      // Posiciona na conta contábil
      CT1->(dbSetOrder(1))
      CT1->(dbSeek(XFILIAL("CT1")+aCols[n,nPCtb]))

      // Se a conta pertencer ao grupo de despesas do MCT
      If CT1->CT1_XMCT == "S"
         If !(lRet := (Trim(aCols[n,nPCLV]) == Trim(CT1->CT1_GRUPO)))
            Aviso('Atenção',"Classe MCT diferente do Grupo Contábil ("+Trim(CT1->CT1_GRUPO)+") !",{'2'},2)
         Endif
      Endif
   Endif

Return lRet
