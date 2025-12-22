#Include "rwmake.ch"

User Function F050COF()
   Local cCusto, cClvl, cItem, cViagem, cTreina
   Local cAlias  := Alias()
   Local nRegSE2 := SE2->(Recno())

   SE2->(dbGoTo(ParamIXB))

   cCusto  := SE2->E2_CC   //Gravar dados no titulos de impostos -adelson
   cClvl   := SE2->E2_CLVL
   cItem   := SE2->E2_ITEMCTA
   cViagem := SE2->E2_VIAGEM
   cTreina := SE2->E2_TREINAM

   SE2->(dbGoTo(nRegSE2))

   RecLock("SE2",.F.)
   SE2->E2_CC      := cCusto
   SE2->E2_CLVL    := cClvl
   SE2->E2_ITEMCTA := cItem
   SE2->E2_VIAGEM  := cViagem
   SE2->E2_TREINAM := cTreina
   MsUnLock()
   dbSelectArea(cAlias)

Return nRegSE2
