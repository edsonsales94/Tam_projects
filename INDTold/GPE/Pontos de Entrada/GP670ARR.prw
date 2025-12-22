#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ GP670ARR  | Autor ¦ Ronilton O. Barros     ¦ Data ¦ 27/02/2007¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada de envio de campos criados pelo usuario      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function GP670ARR()
   Local vRet := {}

   RC0->(DbSetOrder(1))
   If RC0->(DbSeek(xFilial("RC0")+RC1->RC1_CODTIT))
      AAdd( vRet , { "E2_CC"     , RC1->RC1_CC    , Nil})
      AAdd( vRet , { "E2_HIST"   , "Pg " + Alltrim(RC0->RC0_DESCRI)+" de " +;
                                   MesExtenso(Val(SubStr(RC1->RC1_DATARQ,5,2)))+"/"+SubStr(RC1->RC1_DATARQ,1,4), Nil})
      AAdd( vRet , { "E2_DATARQ" , RC1->RC1_DATARQ, Nil })
      AAdd( vRet , { "E2_VERBAS" , RC0->RC0_VERBAS, Nil })
      AAdd( vRet , { "E2_ITEMCTA", RC1->RC1_MAT   , Nil })
      AAdd( vRet , { "E2_AGRUPA" , RC0->RC0_AGRUPA, Nil })  //If( !Empty(RC1->RC1_MAT) , "4", If( !Empty(RC1->RC1_CC) , "2", "1"))
      AAdd( vRet , { "E2_PARFOL" , RC1->RC1_PARFOL, Nil })
      AAdd( vRet , { "E2_CODTIT" , RC1->RC1_CODTIT, Nil })
      AAdd( vRet , { "E2_CLVL"   , RC1->RC1_CLVL  , Nil })
      AAdd( vRet , { "E2_BUSCAI" , RC1->RC1_DTBUSI, Nil })
      AAdd( vRet , { "E2_BUSCAF" , RC1->RC1_DTBUSF, Nil })
      AAdd( vRet , { "E2_FILFOL" , RC1->RC1_FILTRF, Nil })
      AAdd( vRet , { "E2_FILTRV" , RC1->RC1_FILTRV, Nil })
   Endif

Return(vRet)
