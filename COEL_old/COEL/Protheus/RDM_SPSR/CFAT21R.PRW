#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Cfat21r()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NTAMANHO,NLIMITE,CTITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("ARETURN,NOMEPROG,CPERG,LCONTINUA,NLIN,WNREL")
SetPrvt("CSTRING,NLASTKEY,LABORTPRINT,_CNUMPED,_NPEDSOL,_NPEDENT")
SetPrvt("_NITEMSOL,_NITEMENT,_NACUPED,_NACUENT,_NCOUNT,_CARQIND")
SetPrvt("_CCHAVE,_CFILTRO,_NSALPED,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT21R  ³ Autor ³   Adilson / Ricardo   ³ Data ³22/09/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio do Indice de Atraso de Entrega IAE               ³±±
±±³          ³ para Pedidos de Vendas - S¢ do tipo PA e somente Vendas    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Coel Controles Eletricos Ltda                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Obs       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 03/09/02 ==>     #DEFINE PSAY SAY
#ENDIF

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis utilizadas no relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

nTamanho  := "P"
nLimite   := 80
cTitulo   := PADC( "Indice Atraso Entrega Pedidos de Venda", 74 )
cDesc1    := PADC( "Este programa emitir  o Indice de Atraso de Entrega dos Pedidos de", 74 )
cDesc2    := PADC( "Vendas                                  ", 74 )
cDesc3    := PADC( "", 74 )
aReturn   := { "Especial", 1, "Diretoria Coel", 1, 1, 1, "", 1 }
nomeprog  := "CFAT21R" 
cPerg     := "AMFT01"
lContinua := .T.
nLin      := 0
wnrel     := "CFAT21R"
cString   := "SC6"
nLastKey  := 0
lAbortPrint := .F.

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis utilizadas no processamento                                     *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_cNumPed  := Space(6)   //----> Guarda o numero do pedido atual
_nPedSol  := 0          //----> Numero de pedidos solicitados
_nPedEnt  := 0          //----> Numero de pedidos entregues
_nItemSol := 0          //----> Numero de itens solicitados
_nItemEnt := 0          //----> Numero de itens entregues
_nAcuPed  := 0          //----> Controle de itens entregues por pedido
_nAcuEnt  := 0          //----> Acumulador de itens entregues 
_nCount   := 0          //----> Incrementador da regua de processamento

Pergunte( cPerg, .F. )

wnrel := SetPrint( cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3, .F. )

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

#IFDEF WINDOWS
    RptStatus({|| IMPCLREL01()})// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>     RptStatus({|| Execute(IMPCLREL01)})
#ELSE
    IMPCLREL01()
#ENDIF

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function IMPCLREL01
Static Function IMPCLREL01()

Processa({||RunProc()},"Selecionando Registros Pedidos Vendas")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({||Execute(RunProc)},"Selecionando Registros Pedidos Vendas")
Return(nil)	   // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SC6")                 // Itens dos Pedidos

_cArqInd :=  CriaTrab(Nil,.f.)
_cChave  := "C6_NUM + C6_ITEM + DTOS(C6_ENTREG) "
_cFiltro := "DTOS(C6_ENTREG) >= DTOS(MV_PAR01) .AND. DTOS(C6_ENTREG) <= DTOS(MV_PAR02)"

IndRegua("SC6",_cArqInd,_cChave,,_cFiltro,"Buscando Registros: "+Dtoc(mv_par01)+" "+Dtoc(mv_par02))

While Eof() == .f.
    _nCount := _nCount + 1
    DbSkip()
End

DbGoTop()

@ nLin, 000 PSAY AvalImp( nLimite )
ProcRegua( _nCount )
While Eof() == .f. .And. SC6->C6_FILIAL == xFilial("SC6")

    IncProc("Calculando Dados Pedido:  "+SC6->C6_NUM)

    If !SC6->C6_TES $mv_par03
        DbSkip()
        Loop
    EndIf
    
    _nPedSol := _nPedSol + 1

    _cNumPed := SC6->C6_NUM
    While SC6->C6_NUM == _cNumPed
        _nSalPed := SC6->C6_QTDVEN - SC6->C6_QTDENT
        _nAcuPed := _nAcuPed + _nSalPed
        If _nSalPed > 0
            _nItemSol := _nItemSol + 1
        Else
            _nItemSol := _nItemSol + 1
            _nItemEnt := _nItemEnt + 1
        EndIf
        DbSkip()
    EndDo

    _nAcuEnt := _nAcuPed
    _nAcuPed := 0

    If _nAcuEnt == 0
        _nPedEnt := _nPedEnt + 1
    EndIf

Enddo

@ 01, 01 psay "*******************************************************************************"
@ 02, 01 psay "* COEL CONTROLES ELETRICOS LTDA                                      " + DtoC(Date())+" *"
@ 03, 01 psay "*                                                                    " + Time()+" *"  
@ 04, 01 psay "* CFAT21R - APURACAO DE INDICES DE ATRASO DE ENTREGA DE PEDIDOS DE VENDAS     *"
@ 05, 01 psay "*                                                                             *"
@ 06, 01 psay "* PERIODO DE ENTREGA: " + SUBSTR(dtos(mv_par01),7,2) + "/" + SUBSTR(dtos(mv_par01),5,2) + "/" + SUBSTR(dtos(mv_par01),1,4)
@ 06, 34 psay "a "+ SUBSTR(dtos(mv_par02),7,2) + "/" + SUBSTR(dtos(mv_par02),5,2) + "/" + SUBSTR(dtos(mv_par02),1,4)
@ 06, 79 psay "*"
@ 07, 01 psay "*******************************************************************************"
@ 10, 01 psay "   Quantidade de Pedidos Solicitados.: " + Str(_nPedSol)
@ 11, 01 psay "   Quantidade de Pedidos Atendidos...: " + Str(_nPedEnt)
@ 12, 01 psay "   Quantidade de Itens solicitados...: " + Str(_nItemSol)
@ 13, 01 psay "   Quantidade de Itens Entregues.....: " + Str(_nItemEnt)
@ 16, 01 psay "   ************************** FIM DO RELATORIO *******************************"

If aReturn[5] == 1
   Set Printer TO
   ourspool(wnrel)
Endif

MS_FLUSH()

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

