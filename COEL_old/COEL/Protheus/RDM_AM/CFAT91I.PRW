#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function Cfat91i()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

If !SM0->M0_CODIGO != "03"
    MsgBox("Atencao Sr(a) "+Subs(cUsuario,7,15)+" esta rotina somente podera ser executada na empresa 01. Por favor, acesse o sistema na empresa correta.","Acesso nao Permitido","Stop")
    Return
EndIf

Processa({||RunProc()},"Selecionando Registros Pedidos Vendas")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({||Execute(RunProc)},"Selecionando Registros Pedidos Vendas")
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

DBUSEAREA(.T.,"TOPCONN","SC6010","SC6010",.T.)
TcCanOpen("SC6010","SC60101")
ORDLISTADD("SC60101")

DbSelectArea("SC6")
_cChavC6:= "C6_NUM"
_cFiltC6:= "EMPTY(C6_X_NFGER) .AND. !EMPTY(C6_NOTA)"
_cIndSC6:= CriaTrab(Nil,.f.)
IndRegua("SC6",_cIndSC6,_cChavC6,,_cFiltC6,"Selecionando Registros...")

ProcRegua(LastRec())

While !Eof()

    IncProc("Processando Pedido "+SC6->C6_NUM)

    DbSelectArea("SC6010")
    DbSeek(xFilial("SC6")+SC6->C6_NUM+SC6->C6_ITEM)
    If Found()

       RecLock("SC6010",.f.)
       SC6010->C6_QTDENT:= SC6->C6_QTDENT
       SC6010->C6_NOTA	:= SC6->C6_NOTA
       SC6010->C6_SERIE := SC6->C6_SERIE
       SC6010->C6_DATFAT:= SC6->C6_DATFAT
       msunlock()

    EndIf                                    

    DbSelectArea("SC6")
    RecLock("SC6",.f.)
    SC6->C6_X_NFGER:= "S"
    msunlock()

    DbSkip()

EndDo

DbCloseArea("SC6010")
DbSelectArea("SC6")
retindex()
Ferase(_cTempSC6+".idx")

Return
