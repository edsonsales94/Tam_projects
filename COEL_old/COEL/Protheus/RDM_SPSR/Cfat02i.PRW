#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function Cfat02i()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_AAREA,_CRET,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT02I  ³ Autor ³ROSIMEIRE GOES         ³ Data ³21.07.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³GATILHO PARA CALCULO DO PRECO UNITARIO NAS MOEDAS 06 E 07   ³±±
±±³          ³COM BASE NAS ALTERACOES DE PRECOS REALIZADAS NA TABELA 01 E ³±±
±±³          ³02,SENDO QUE AS ALTERACOES DA 01 REFLETEM NA 07 E A 02 NA 02³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Foram criados os parametros MV_CLCON17 E MV_CLCON26 para   ³±±
±±³          ³ guardar as porcentagens de conversao da tabela 01 para a 07³±±
±±³          ³ Esta rotina sera disparada por gatilhos no B1_PRV1/B5_PRV2 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Geral                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

_aArea := {Alias(),IndexOrd(),Recno()}

if ALLTRIM(SX7->X7_CAMPO) == "B1_PRV1"    // Verifica se o gatilho foi desparado para preco 01 ou 02

   dbSelectArea("SB5")
   dbSetOrder(1)
   dbSeek(XFILIAL()+SB1->B1_COD)
   if eof() == .t.
      MSGBOX("Entrar em contato com o CPD pois o produto nao tem preco minimo definido","VALIDACAO DO PRODUTO EM OUTRAS TABELAS","STOP")
   else   
      reclock("SB5",.F.)
      _field->B5_PRV7:= (M->B1_PRV1*GETMV("MV_CLCON17"))/100
      dbcommit()
      MSGBOX("O PRECO MINIMO DO PRODUTO E' "+TRANS(SB5->B5_PRV7,PESQPICT("SB5","B5_PRV7")),"Preco Atualizado na Tabela de Preco Minimo","ALERT")
   endif
   msunlock()
   _cret:= M->B1_PRV1
else
   reclock("SB5",.F.)
   _field->B5_PRV6:= (M->B5_PRV2*GETMV("MV_CLCON26"))/100
   dbcommit()
   MSGBOX("O PRECO MINIMO DO PRODUTO E' "+TRANS(SB5->B5_PRV6,PESQPICT("SB5","B5_PRV6")),"Preco Atualizado na Tabela de Preco Minimo","ALERT")
   msunlock()
   _cret:= SB5->B5_PRV6
endif

dbSelectArea(_aArea[1])
dbSetOrder(_aArea[2])
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __return(_cret)
Return(_cret)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

