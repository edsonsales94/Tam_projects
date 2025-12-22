#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

User Function CEST21I()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_DDATAF,_DDATA,NFLAG,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CEST21I  ³ Autor ³Ricardo Correa de Souza³ Data ³08/05/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Acerta Custo Medio das Transferencias Apos Fechamento Mes  ³±±
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
Processa({||RunProc()},"Acerta Custo de Entradas")// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Processa({||Execute(RunProc)},"Acerta Custo de Entradas")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function RunProc
Static Function RunProc()

_dDataf      := GetMv("MV_ULMES")    //----> data ultima virada de saldos
_dData       := _dDataf + 1

//----> acerta custo de entradas em Sao Paulo

DbSelectArea("SD1")
DbSetOrder(6)
ProcRegua(LastRec())

DbSeek("01"+Dtos(_dData),.t.)

nFlag := 0

While Eof() == .f. .And. SD1->D1_FILIAL == "01"

    IncProc(SD1->D1_FILIAL+" Acertando Entradas "+SD1->D1_COD)

    DbSelectArea("SF4")
    DbSetOrder(1)
    DbSeek(xFilial("SF4")+SD1->D1_TES)

    If ! SF4->F4_ESTOQUE == "S"
        dbSelectArea("SD1")
        dbSkip()
        Loop
    EndIf

    Reclock("SD1",.F.)
      If nFlag == 0
        alert("fui na 02")
        nFlag:= 1
      EndIf
      SD1->D1_CUSTO :=  SD1->D1_QUANT * (SD1->D1_VUNIT * INT((SD1->D1_PICM / 100) - 1))
      SD1->D1_CUSTO2:= 0
      SD1->D1_CUSTO3:= 0
      SD1->D1_CUSTO4:= 0
      SD1->D1_CUSTO5:= 0
    MsUnlock()
    DbSelectArea("SD1")
    DbSkip()
Enddo

//----> acerta custo de entradas em Sao Roque

DbSelectArea("SD1")
DbSetOrder(6)
ProcRegua(LastRec())

DbSeek("02"+Dtos(_dData),.t.)

nFlag := 0

While Eof() == .f. .And. SD1->D1_FILIAL == "02"

    IncProc(SD1->D1_FILIAL+" Acertando Entradas "+SD1->D1_COD)

    DbSelectArea("SF4")
    DbSetOrder(1)
    DbSeek(xFilial("SF4")+SD1->D1_TES)

    If ! SF4->F4_ESTOQUE == "S"
        dbSelectArea("SD1")
        dbSkip()
        Loop
    EndIf

    Reclock("SD1",.F.)
      If nFlag == 0
        alert("fui na 02")
        nFlag:= 1
      EndIf
      SD1->D1_CUSTO :=  SD1->D1_QUANT * (SD1->D1_VUNIT * INT((SD1->D1_PICM / 100) - 1))
      SD1->D1_CUSTO2:= 0
      SD1->D1_CUSTO3:= 0
      SD1->D1_CUSTO4:= 0
      SD1->D1_CUSTO5:= 0
    MsUnlock()
    DbSelectArea("SD1")
    DbSkip()
Enddo

Return
