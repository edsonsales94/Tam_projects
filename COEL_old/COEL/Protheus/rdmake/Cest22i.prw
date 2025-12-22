#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

User Function Cest22i()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_DDATAF,_DDATA,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CEST22I  ³ Autor ³Ricardo Correa de Souza³ Data ³15/05/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Acerta Custo Medio das Movimentacoes Internas              ³±±
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
Processa({||RunProc()},"Acerta Custo de Movimentacoes Internas")// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Processa({||Execute(RunProc)},"Acerta Custo de Movimentacoes Internas")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function RunProc
Static Function RunProc()

_dDataf:= GetMv("MV_ULMES")    //----> data ultima virada de saldos
_dData := _dDataf + 1

//----> acerta custo das movimentacoes internas Sao Paulo

DbSelectArea("SD3")
DbSetOrder(6)
ProcRegua(LastRec())

DbSeek("01"+Dtos(_dData),.t.)

While Eof() == .f. .And. SD3->D3_FILIAL == "01"

    IncProc(SD3->D3_FILIAL+" Acertando Mov. Internas "+SD3->D3_COD)

       DbSelectArea("SD3")
       Reclock("SD3",.F.)
         SD3->D3_CUSTO1 := 0
         SD3->D3_CUSTO2 := 0
         SD3->D3_CUSTO3 := 0
         SD3->D3_CUSTO4 := 0
         SD3->D3_CUSTO5 := 0
       MsUnlock()
    dbSkip()
Enddo

//----> acerta custo das movimentacoes internas Sao Roque

DbSelectArea("SD3")
DbSetOrder(6)
ProcRegua(LastRec())

DbSeek("02"+Dtos(_dData),.t.)

While Eof() == .f. .And. SD3->D3_FILIAL == "02"

    IncProc(SD3->D3_FILIAL+" Acertando Mov. Internas "+SD3->D3_COD)

       DbSelectArea("SD3")
       Reclock("SD3",.F.)
         SD3->D3_CUSTO1 := 0
         SD3->D3_CUSTO2 := 0
         SD3->D3_CUSTO3 := 0
         SD3->D3_CUSTO4 := 0
         SD3->D3_CUSTO5 := 0
       MsUnlock()
    dbSkip()
Enddo

Return
