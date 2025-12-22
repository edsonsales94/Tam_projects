#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Cfat25r()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AESTRU1,_CTEMP1,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN")
SetPrvt("M_PAG,_NTOTQTD,_NTOTFAT,_NTOTRES,_NTOTSAL,_NTQTD")
SetPrvt("_NTFAT,_NTRES,_NTSAL,CQUEBRA,CQUEBRA1,CQUEBRA2")
SetPrvt("CQUEBRA3,CQUEBRA4,CQUEBRA5,_CINDEX,_CCHAVE,_CFILTRO")
SetPrvt("_CTEXTO,_CNOMECLI,_CTIPOCLI,_CDESCPRO,_NQTDSALDO,_NQTDRES")
SetPrvt("CTITADD1,CTITADD2,CABEC1,CABEC2,REGUA1,REGUA2")
SetPrvt("_LFLAG,_CPEDLINHA,_CAUXPRO,_DAUXDAT,_CAUXPED,_CAUXCLI")
SetPrvt("_NAUXSEM,AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT25R  ³ Autor ³Ricardo Correa de Souza³ Data ³27/04/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Pedidos de Vendas em Aberto por Tipo de Cliente ³±±
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
#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 03/09/02 ==>     #DEFINE PSAY SAY
#ENDIF
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SA1")         //----> Cadastro de Clientes
DbSetOrder(1)               //----> Codigo + Loja

DbSelectArea("SA3")         //----> Cadastro de Vendedores
DbSetOrder(1)               //----> Codigo

DbSelectArea("SB1")         //----> Cadastro de Produtos
DbSetOrder(1)               //----> Codigo

DbSelectArea("SC5")         //----> Cabecalho de Pedidos de Vendas
DbSetOrder(2)               //----> Data de Emissao + Pedido

DbSelectArea("SC6")         //----> Itens de Pedidos de Vendas
DbSetOrder(1)               //----> Pedido + Item

DbSelectArea("SC0")         //----> Controle de Reservas de Pedidos de Vendas
DbSetOrder(3)               //----> Pedido + Item + Produto + Local + Reserva

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

aEstru1 :={}
AADD(aEstru1,{"PROD"    ,"C",15,0})
AADD(aEstru1,{"DESCR"   ,"C",30,0})
AADD(aEstru1,{"PEDIDO"  ,"C",06,0})
AADD(aEstru1,{"ITEMPV"  ,"C",02,0})
AADD(aEstru1,{"EMISSAO" ,"D",08,0})
AADD(aEstru1,{"ENTREGA" ,"D",08,0})
AADD(aEstru1,{"SEMANA"  ,"N",02,0})
AADD(aEstru1,{"QUANT"   ,"N",09,2})
AADD(aEstru1,{"QTDFAT"  ,"N",09,2})
AADD(aEstru1,{"QTDRES"  ,"N",09,2})
AADD(aEstru1,{"QTDSAL"  ,"N",09,2})
AADD(aEstru1,{"CLIENTE" ,"C",06,0})
AADD(aEstru1,{"LOJA"    ,"C",02,0})
AADD(aEstru1,{"NOMEC"   ,"C",40,0})
AADD(aEstru1,{"TPCLI"   ,"C",01,0})
_cTemp1 := CriaTrab( aEstru1, .T. )  
//dbUseArea(.T.,__cRdd,_cTemp1,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )
dbUseArea(.T.,,_cTemp1,"TRB", NIL, .F. )

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "CFAT25R"
cDesc1    := "Emissao dos pedidos de em aberto considerando a"
cDesc2    := "reserva, conforme parametros selecionados.     "
cDesc3    := " "
cString   := "SC6"
lEnd      := .F.
tamanho   := "M"
limite    := 132
titulo    := "Pedidos de Vendas em Aberto"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "CFAT25R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT25R"
nLin	  := 9
m_pag     := 1
_nTotQtd  := 0
_nTotFat  := 0
_nTotRes  := 0
_nTotSal  := 0
_nTQtd    := 0
_nTFat    := 0
_nTRes    := 0
_nTSal    := 0
cQuebra  := ""
cQuebra1 := CTOD(SPAC(8))
cQuebra2 := ""
cQuebra3 := ""
cQuebra4 := 0
cQuebra5 := CTOD(SPAC(8))

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Da Data        ?                                          *
* mv_par02  ----> Ate a Data     ?                                          *
* mv_par03  ----> Do Pedido      ?                                          *
* mv_par04  ----> Ate o Pedido   ?                                          *
* mv_par05  ----> Do Cliente     ?                                          *
* mv_par06  ----> Da Loja        ?                                          *
* mv_par07  ----> Ate o Cliente  ?                                          *
* mv_par08  ----> Ate Loja       ?                                          *
* mv_par09  ----> Do Produto     ?                                          *
* mv_par10  ----> Ate o Produto  ?                                          *
* mv_par11  ----> Tipo do Cliente? (Distrib/Revend/Produtor/Consum/Todos)   *
* mv_par12  ----> Indexado por   ? (Entrega/Pedido/Produto/Cliente/Semana)  *
* mv_par13  ----> Da Semana      ?                                          *
* mv_par14  ----> Ate a Semana   ?                                          *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

ValidPerg()     //----> Atualiza o arquivo de perguntas SX1

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
   DbSelectArea("TRB")
   DbCloseArea("TRB")
   Set Filter To
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   DbSelectArea("TRB")
   DbCloseArea("TRB")
   Set Filter to
   Return
Endif

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Filtrando Dados ...")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({||Execute(RunProc)},"Filtrando Dados ...")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

If mv_par12 == 1
    _cIndex := CriaTrab(Nil,.f.)
    _cChave := "C6_FILIAL+DTOS(C6_ENTREG)+C6_NUM+C6_ITEM+C6_PRODUTO+C6_CLCLISP+C6_CLLOJSP"
    _cFiltro:= "C6_FILIAL == SM0->M0_CODFIL"
    _cTexto := "Data de Entrega"
ElseIf mv_par12 == 2
    _cIndex := CriaTrab(Nil,.f.)
    _cChave := "C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO+DTOS(C6_ENTREG)+C6_CLCLISP+C6_CLLOJSP"
    _cFiltro:= "C6_FILIAL == SM0->M0_CODFIL"
    _cTexto := "Pedido"
ElseIf mv_par12 == 3
    _cIndex := CriaTrab(Nil,.f.)
    _cChave := "C6_FILIAL+C6_PRODUTO+C6_NUM+C6_ITEM+DTOS(C6_ENTREG)+C6_CLCLISP+C6_CLLOJSP"
    _cFiltro:= "C6_FILIAL == SM0->M0_CODFIL"
    _cTexto := "Produto"
ElseIf mv_par12 == 4
    _cIndex := CriaTrab(Nil,.f.)
    _cChave := "C6_FILIAL+C6_CLCLISP+C6_CLLOJSP+C6_PRODUTO+C6_NUM+C6_ITEM+DTOS(C6_ENTREG)"
    _cFiltro:= "C6_FILIAL == SM0->M0_CODFIL"
    _cTexto := "Cliente"
Else
    _cIndex := CriaTrab(Nil,.f.)
    _cChave := "C6_FILIAL+STR(C6_SEMANA)+C6_NUM+C6_ITEM+C6_PRODUTO+C6_CLCLISP+C6_CLLOJSP"
    _cFiltro:= "C6_FILIAL == SM0->M0_CODFIL"
    _cTexto := "Semana"
EndIf

DbSelectArea("SC6")
IndRegua("SC6",_cIndex,_cChave,_cFiltro,,"Indexando por "+_cTexto)

ProcRegua(RecCount())
DbSeek(xFilial("SC6"))//"02")
Do While !Eof() .And. SC6->C6_FILIAL == xFilial("SC6")//"02"
                                          
    IncProc("Selecionando Dados do Pedido: "+SC6->C6_NUM)

    //----> filtrando intervalo de datas definido nos parametros
    If SC6->C6_SEMANA < mv_par13 .Or. SC6->C6_SEMANA > mv_par14
        DbSkip()
        Loop
    EndIf

    //----> filtrando intervalo de datas definido nos parametros
    If SC6->C6_ENTREG < mv_par01 .Or. SC6->C6_ENTREG > mv_par02
        DbSkip()
        Loop
    EndIf

    //----> filtrando intervalo de pedidos definido nos parametros
    If SC6->C6_NUM < mv_par03 .Or. SC6->C6_NUM > mv_par04
        DbSkip()
        Loop
    EndIf

    //----> filtrando intervalo de clientes definido nos parametros
    If SC6->C6_CLCLISP+SC6->C6_CLLOJSP < mv_par05+mv_par06 .Or. SC6->C6_CLCLISP+SC6->C6_CLLOJSP > mv_par07+mv_par08
        DbSkip()
        Loop
    EndIf

    //----> filtrando intervalo de produtos definido nos parametros
    If SC6->C6_PRODUTO < mv_par09 .Or. SC6->C6_PRODUTO > mv_par10
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SA1")
    DbSeek(xFilial("SA1")+SC6->C6_CLCLISP+SC6->C6_CLLOJSP)
    _cNomeCli := SA1->A1_NOME
    _cTipoCli := SA1->A1_CLASCLI

    //----> filtrando intervalo de classificacao do cliente definido nos parametros
    If mv_par11 == 1
    ElseIf mv_par11 == 2 .And. !_cTipoCli $ "D/R"
        DbSelectArea("SC6")
        DbSkip()
        Loop
    ElseIf mv_par11 == 3 .And. !_cTipoCli $ "P/C"
        DbSelectArea("SC6")
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SB1")
    DbSeek(xFilial("SB1")+SC6->C6_PRODUTO)
    _cDescPro := SB1->B1_DESC

    _nQtdSaldo := SC6->C6_QTDENT - SC6->C6_QTDVEN

    //----> filtrando somente pedidos que possuem saldo em aberto
    If _nQtdSaldo == 0
        DbSelectArea("SC6")
        DbSkip()
        Loop
    EndIf

    //----> verificando se existe vinculo da reserva no pedido
    If !Empty(SC6->C6_RESERVA)
        DbSelectArea("SC0")
        If DbSeek(xFilial("SC0")+SC6->C6_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO)
            _nQtdRes := SC0->C0_QTDORIG
        Else
            _nQtdRes := 0
        EndIf
    Else
        DbSelectArea("SC0")
        If DbSeek(xFilial("SC0")+SC6->C6_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO)
            _nQtdRes := SC0->C0_QUANT
        Else
            _nQtdRes := 0
        EndIf
    EndIf

    DbSelectArea("SC5")
    DbSetOrder(1)
    DbSeek(xFilial("SC5")+SC6->C6_NUM)

    DbSelectArea("TRB")
    RecLock("TRB",.t.)
      TRB->DESCR    :=      _cDescPro
      TRB->ITEMPV   :=      SC6->C6_ITEM
      TRB->EMISSAO  :=      SC5->C5_EMISSAO
      TRB->QUANT    :=      SC6->C6_QTDVEN
      TRB->QTDFAT   :=      SC6->C6_QTDENT
      TRB->QTDRES   :=      _nQtdRes
      TRB->QTDSAL   :=      (SC6->C6_QTDVEN - SC6->C6_QTDENT - _nQtdRes)
      TRB->LOJA     :=      SC6->C6_CLLOJSP
      TRB->NOMEC    :=      _cNomeCli
      TRB->TPCLI    :=      _cTipoCli
      TRB->ENTREGA  :=      SC6->C6_ENTREG
      TRB->PEDIDO   :=      SC6->C6_NUM
      TRB->PROD     :=      SC6->C6_PRODUTO
      TRB->CLIENTE  :=      SC6->C6_CLCLISP
      TRB->SEMANA   :=      SC6->C6_SEMANA

    MsUnLock()

    DbSelectArea("SC6")
    DbSkip()
EndDo

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

#IFDEF WINDOWS
    RptStatus({|| Imprime()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>     RptStatus({|| Execute(Imprime)},titulo)
#ELSE
    Imprime()
#ENDIF


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function Imprime
Static Function Imprime()


cTitAdd1:= Iif(mv_par11 == 1," - TODOS OS CLIENTES",Iif(mv_par11 == 2," - CLIENTES DISTRIB/REVEND"," - CLIENTES PRODUT/CONSUM"))
cTitAdd2:= Iif(mv_par12 == 1," - POR DATA ENTREGA",Iif(mv_par12 == 2," - POR PEDIDO",Iif(mv_par12 == 3," - POR PRODUTO",Iif(mv_par12 == 4," - POR CLIENTE"," - POR SEMANA"))))

cabec1  := "SEM NUMERO IT DATA DE  CODIGO    NOME DO       TP CODIGO     DESCRICAO             QUANT     QUANT     QUANT       QUANT    DATA DE "
cabec2  := "    PEDIDO    ENTREGA  CLIENTE   CLIENTE       CL PRODUTO    PRODUTO               PEDIDA    FATURADA  RESERVADA   PENDENTE EMISSAO "

//regua1:= "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012"
//regua2:= "         10        20        30        40        50        60        70        80        90       100       110       120       130  "
titulo  := titulo + cTitAdd1 + cTitAdd2

DbSelectArea("TRB")
DbGoTop()
SetRegua(Lastrec())

@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
_lFlag:=.f.
_cPedLinha := TRB->PEDIDO
Do While !Eof()

    IncRegua()

    //----> quebra por semana
    If cQuebra4 <> TRB->SEMANA
       cQuebra4 := TRB->SEMANA
    Else
       cQuebra4 := 0
    Endif
    @ nLin, 00 Psay cQuebra4   Picture "@Z 99"
    cQuebra4 := TRB->SEMANA

    //----> quebra por pedido
    If cQuebra <> TRB->PEDIDO
       cQuebra := TRB->PEDIDO
    Else
       cQuebra := spac(6)
    Endif
    @ nLin, Pcol()+2 Psay cQuebra
    @ nLin, Pcol()   Psay "/"+TRB->ITEMPV

    cQuebra := TRB->PEDIDO

    //----> quebra por entrega
    If cQuebra1 <> TRB->ENTREGA
       cQuebra1 := TRB->ENTREGA
    Else
       cQuebra1 := spac(8)
    Endif
    @ nLin, Pcol()+1 Psay cQuebra1
    cQuebra1 := TRB->ENTREGA

    //----> quebra por cliente
    If cQuebra2 <> TRB->CLIENTE
       cQuebra2 := TRB->CLIENTE
    Else
       cQuebra2 := SPAC(24)
    Endif

    If !empty(cQuebra2)
       @ nLin, Pcol()+1 Psay TRB->CLIENTE+"/"+TRB->LOJA
       @ nLin, Pcol()+1 Psay Left(TRB->NOMEC,13)
       If mv_par11 == 1
           @ nLin, Pcol()+1 Psay TRB->TPCLI
       Else
           @ nLin, Pcol()+1 Psay " "
       EndIf
    Else
       @ nLin, Pcol()+2 Psay cQuebra2
    Endif
    cQuebra2 := TRB->CLIENTE

    //----> quebra por produto
    If cQuebra3 <> TRB->PROD
       cQuebra3 := TRB->PROD
    Else
       cQuebra3 := ""
    Endif

    If !empty(cQuebra3)
       @ nLin, Pcol()+2 Psay TRB->PROD                Picture "@R 99.999.999"
       @ nLin, Pcol()+1 Psay Left(TRB->DESCR,17)//17
    Endif

    If empty(cQuebra3)
        @ nLin, Pcol()+29 Psay Space(1)
        @ nLin, Pcol()+1 Psay TRB->QUANT                  Picture "@E 999,999.99"
        @ nLin, Pcol()+2 Psay TRB->QTDFAT                 Picture "@E 999,999.99"
        @ nLin, Pcol()+1 Psay TRB->QTDRES                 Picture "@E 999,999.99"
        @ nLin, Pcol()+1 Psay (TRB->QUANT-TRB->QTDFAT-TRB->QTDRES) Picture "@E 999,999.99"
    Else
        @ nLin, Pcol()+1 Psay TRB->QUANT                  Picture "@E 999,999.99"
        @ nLin, Pcol()+2 Psay TRB->QTDFAT                 Picture "@E 999,999.99"
        @ nLin, Pcol()+1 Psay TRB->QTDRES                 Picture "@E 999,999.99"
        @ nLin, Pcol()+1 Psay (TRB->QUANT-TRB->QTDFAT-TRB->QTDRES) Picture "@E 999,999.99"
    EndIf

    cQuebra3 := TRB->PROD

    //----> quebra por emissao
    If cQuebra5 <> TRB->EMISSAO
       cQuebra5 := TRB->EMISSAO
    Else
       cQuebra5 := SPAC(8)
    Endif
    @ nLin, Pcol()+1 Psay cQuebra5
    cQuebra5 := TRB->EMISSAO

    nLin := nLin + 1

    //----> totaliza o relatorio
    _nTotQtd := _nTotQtd + TRB->QUANT
    _nTotFat := _nTotFat + TRB->QTDFAT
    _nTotRes := _nTotRes + TRB->QTDRES
    _nTotSal := _nTotSal + (TRB->QUANT - TRB->QTDFAT - TRB->QTDRES)

    _nTQtd := _nTQtd + TRB->QUANT
    _nTFat := _nTFat + TRB->QTDFAT
    _nTRes := _nTRes + TRB->QTDRES
    _nTSal := _nTSal + (TRB->QUANT - TRB->QTDFAT - TRB->QTDRES)

    _cAuxPro := TRB->PROD  
    _dAuxDat := TRB->ENTREGA
    _cAuxPed := TRB->PEDIDO
    _cAuxCli := TRB->CLIENTE+LOJA
    _nAuxSem := TRB->SEMANA
    _cPedLinha := TRB->PEDIDO

    DbSkip()

    //----> separa pedidos imprimindo uma linha                                                   C
    If TRB->PEDIDO #_cPedLinha
        @ nLin, 000 Psay Repli("-",limite)
        nLin := nLin + 1
    EndIf

    //----> totaliza por data de entrega
    If TRB->ENTREGA #_dAuxDat .And. mv_par12 == 1
        nLin := nLin + 1
        @ nLin, 000 Psay "Total do Dia     ----> "
        @ nLin, 023 Psay Dtoc(_dAuxDat)
        @ nLin, 079 Psay _nTQtd                      Picture "@E 999,999.99"
        @ nLin, 091 Psay _nTFat                      Picture "@E 999,999.99"
        @ nLin, 102 Psay _nTRes                      Picture "@E 999,999.99"
        @ nLin, 113 Psay _nTSal                      Picture "@E 999,999.99"
        nLin := nLin + 1
        @ nLin, 000 Psay Replicate("-",limite)
        nLin := nLin + 1
        _nTQtd := 0
        _nTFat := 0
        _nTRes := 0
        _nTSal := 0
        cQuebra  := ""
        cQuebra1 := CTOD(SPAC(8))
        cQuebra2 := ""
        cQuebra3 := ""
        cQuebra4 := 0
        cQuebra5 := CTOD(SPAC(8))
    EndIf

    //----> totaliza por pedido
    If TRB->PEDIDO #_cAuxPed .And. mv_par12 == 2
        nLin := nLin + 1
        @ nLin, 000 Psay "Total do Pedido  ----> "
        @ nLin, 023 Psay _cAuxPed
        @ nLin, 079 Psay _nTQtd                      Picture "@E 999,999.99"
        @ nLin, 091 Psay _nTFat                      Picture "@E 999,999.99"
        @ nLin, 102 Psay _nTRes                      Picture "@E 999,999.99"
        @ nLin, 113 Psay _nTSal                      Picture "@E 999,999.99"
        nLin := nLin + 1
        @ nLin, 000 Psay Replicate("-",limite)
        nLin := nLin + 1
        _nTQtd := 0
        _nTFat := 0
        _nTRes := 0
        _nTSal := 0
        cQuebra  := ""
        cQuebra1 := CTOD(SPAC(8))
        cQuebra2 := ""
        cQuebra3 := ""
        cQuebra4 := 0
        cQuebra5 := CTOD(SPAC(8))
    EndIf

    //----> totaliza por produto
    If TRB->PROD #_cAuxPro .And. mv_par12 == 3
        nLin := nLin + 1
        @ nLin, 000 Psay "Total do Produto ----> "
        @ nLin, 023 Psay _cAuxPro                    Picture "@R 99.999.999"
        @ nLin, 079 Psay _nTQtd                      Picture "@E 999,999.99"
        @ nLin, 091 Psay _nTFat                      Picture "@E 999,999.99"
        @ nLin, 102 Psay _nTRes                      Picture "@E 999,999.99"
        @ nLin, 113 Psay _nTSal                      Picture "@E 999,999.99"
        nLin := nLin + 1
        @ nLin, 000 Psay Replicate("-",limite)
        nLin := nLin + 1
        _nTQtd := 0
        _nTFat := 0
        _nTRes := 0
        _nTSal := 0
        cQuebra  := ""
        cQuebra1 := CTOD(SPAC(8))
        cQuebra2 := ""
        cQuebra3 := ""
        cQuebra4 := 0
        cQuebra5 := CTOD(SPAC(8))
    EndIf

    //----> totaliza por cliente
    If TRB->CLIENTE+TRB->LOJA #_cAuxCli .And. mv_par12 == 4
        nLin := nLin + 1
        @ nLin, 000 Psay "Total do Cliente ----> "
        @ nLin, 023 Psay _cAuxCli
        @ nLin, 079 Psay _nTQtd                      Picture "@E 999,999.99"
        @ nLin, 091 Psay _nTFat                      Picture "@E 999,999.99"
        @ nLin, 102 Psay _nTRes                      Picture "@E 999,999.99"
        @ nLin, 113 Psay _nTSal                      Picture "@E 999,999.99"
        nLin := nLin + 1
        @ nLin, 000 Psay Replicate("-",limite)
        nLin := nLin + 1
        _nTQtd := 0
        _nTFat := 0
        _nTRes := 0
        _nTSal := 0
        cQuebra  := ""
        cQuebra1 := CTOD(SPAC(8))
        cQuebra2 := ""
        cQuebra3 := ""
        cQuebra4 := 0
        cQuebra5 := CTOD(SPAC(8))
    EndIf

    //----> totaliza por semana 
    If TRB->SEMANA #_nAuxSem .And. mv_par12 == 5
        nLin := nLin + 1
        @ nLin, 000 Psay "Total da Semana  ----> "
        @ nLin, 023 Psay Str(_nAuxSem)
        @ nLin, 079 Psay _nTQtd                      Picture "@E 999,999.99"
        @ nLin, 091 Psay _nTFat                      Picture "@E 999,999.99"
        @ nLin, 102 Psay _nTRes                      Picture "@E 999,999.99"
        @ nLin, 113 Psay _nTSal                      Picture "@E 999,999.99"
        nLin := nLin + 1
        @ nLin, 000 Psay Replicate("-",limite)
        nLin := nLin + 1
        _nTQtd := 0
        _nTFat := 0
        _nTRes := 0
        _nTSal := 0
        cQuebra  := ""
        cQuebra1 := CTOD(SPAC(8))
        cQuebra2 := ""
        cQuebra3 := ""
        cQuebra4 := 0
        cQuebra5 := CTOD(SPAC(8))
    EndIf

    If nLin > 59
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	nLin := 9
    Endif
EndDo

//----> totaliza total geral do relatorio
nLin := nLin + 1
@ nLin, 000 Psay Replicate("-",limite)
nLin := nLin + 1
@ nLin, 000 Psay "Total Geral ---->"
@ nLin, 079 Psay _nTotQtd   Picture "@E 999,999.99"
@ nLin, 091 Psay _nTotFat   Picture "@E 999,999.99"
@ nLin, 102 Psay _nTotRes   Picture "@E 999,999.99"
@ nLin, 113 Psay _nTotSal   Picture "@E 999,999.99"

Roda(cbCont,"Pedidos",tamanho)

Set Device to Screen

If aReturn[5] == 1 
	Set Printer TO
    dbCommitAll()
    OurSpool(wnrel)
Endif

DbSelectArea("SC6")
RetIndex("SC6")

DbSelectArea("TRB")
DbCloseArea("TRB")
Ferase(_cTemp1+".dbf")
Ferase(_cTemp1+".idx")
Ferase(_cTemp1+".mem")

MS_FLUSH()

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)

    aRegs := {}

    aadd(aRegs,{cPerg,'01','Da Entrega     ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Ate a Entrega  ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Do Pedido      ? ','mv_ch3','C',06, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Ate o Pedido   ? ','mv_ch4','C',06, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'05','Do Cliente     ? ','mv_ch5','C',06, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'06','Da Loja        ? ','mv_ch6','C',02, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'07','Ate o Cliente  ? ','mv_ch7','C',06, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'08','Ate a Loja     ? ','mv_ch8','C',02, 0, 0,'G', '', 'mv_par08','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'09','Do Produto     ? ','mv_ch9','C',15, 0, 0,'G', '', 'mv_par09','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'10','Ate o Produto  ? ','mv_cha','C',15, 0, 0,'G', '', 'mv_par10','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'11','Tipo de Cliente? ','mv_chb','N',01, 0, 0,'C', '', 'mv_par11','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'12','Indexado por   ? ','mv_chc','N',01, 0, 0,'C', '', 'mv_par12','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'13','Da Semana      ? ','mv_chd','N',02, 0, 0,'G', '', 'mv_par13','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'14','Ate a Semana   ? ','mv_che','N',02, 0, 0,'G', '', 'mv_par14','','','','','','','','','','','','','','',''})

    For i:=1 to Len(aRegs)
	Dbseek(cPerg+StrZero(i,2))
	If found() == .f.
	    RecLock("SX1",.t.)
	    For j:=1 to Fcount()
		FieldPut(j,aRegs[i,j])
	    Next
	    MsUnLock()
	EndIf
    Next
EndIf

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Retorna para sua Chamada (CFAT25R)                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
