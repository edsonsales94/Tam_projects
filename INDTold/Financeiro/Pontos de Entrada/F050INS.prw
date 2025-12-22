#Include "rwmake.ch"

User Function F050INS()
   Local cCusto, cClvl, cItem, cViagem, cTreina, cNat
   Local cAlias  := Alias()
   Local nRegSE2 := SE2->(Recno())

   SE2->(dbGoTo(ParamIXB))

   cCusto  := SE2->E2_CC   //Gravar dados no titulos de impostos -adelson
   cClvl   := SE2->E2_CLVL
   cItem   := SE2->E2_ITEMCTA
   cViagem := SE2->E2_VIAGEM
   cTreina := SE2->E2_TREINAM

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Alterado por Reinaldo em 23-08-06 para diferenciar a natureza do INSS de PF e PJ  ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   SA2->(DbSetOrder(1))
   SA2->(dbSeek(xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA)))

   If SA2->A2_TIPO == "F"
      cNat:= GetMv("MV_INSSPF")
   Else
      cNat:= GetMv("MV_INSS")
   Endif           

   SE2->(dbGoTo(nRegSE2))
   
   RecLock("SE2",.F.)
   SE2->E2_CC      := cCusto
   SE2->E2_CLVL    := cClvl
   SE2->E2_ITEMCTA := cItem
   SE2->E2_VIAGEM  := cViagem
   SE2->E2_TREINAM := cTreina
   SE2->E2_NATUREZ := StrTran(cNat,'"',"")
   MsUnLock()
   dbSelectArea(cAlias)

Return nRegSE2
