#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function ccon08i()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CCON08I  ³ Autor ³Ricardo Correa de Souza³ Data ³09/03/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ajuste da Contabilidade 2001                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Ajuste Contabilidade 2001")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({||Execute(RunProc)},"Ajuste Contabilidade 2001")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SI3")
DbSetOrder(1)
ProcRegua(LastRec())

While Eof() == .f.

    IncProc("Acertando Saldos do Centro de Custo "+Alltrim(SI3->I3_CUSTO))

    RecLock("SI3",.f.)
      SI3->I3_DEB01   :=   SI3->I3_DEB13
      SI3->I3_CRE01   :=   SI3->I3_CRE13
      SI3->I3_DEB02   :=   SI3->I3_DEB14
      SI3->I3_CRE02   :=   SI3->I3_CRE14
      SI3->I3_DEB03   :=   SI3->I3_DEB15
      SI3->I3_CRE03   :=   SI3->I3_CRE15
      SI3->I3_DEB04   :=   SI3->I3_DEB16
      SI3->I3_CRE04   :=   SI3->I3_CRE16
      SI3->I3_DEB05   :=   SI3->I3_DEB17
      SI3->I3_CRE05   :=   SI3->I3_CRE17
      SI3->I3_DEB06   :=   0
      SI3->I3_CRE06   :=   0
      SI3->I3_DEB07   :=   0
      SI3->I3_CRE07   :=   0
      SI3->I3_DEB08   :=   0
      SI3->I3_CRE08   :=   0
      SI3->I3_DEB09   :=   0
      SI3->I3_CRE09   :=   0
      SI3->I3_DEB10   :=   0
      SI3->I3_CRE10   :=   0
      SI3->I3_DEB11   :=   0
      SI3->I3_CRE11   :=   0
      SI3->I3_DEB12   :=   0
      SI3->I3_CRE12   :=   0
      SI3->I3_DEB13   :=   0
      SI3->I3_CRE13   :=   0
      SI3->I3_DEB14   :=   0
      SI3->I3_CRE14   :=   0
      SI3->I3_DEB15   :=   0
      SI3->I3_CRE15   :=   0
      SI3->I3_DEB16   :=   0
      SI3->I3_CRE16   :=   0
      SI3->I3_DEB17   :=   0
      SI3->I3_CRE17   :=   0

    MsUnLock()
    DbSkip()
EndDo

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim                                                                       *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
