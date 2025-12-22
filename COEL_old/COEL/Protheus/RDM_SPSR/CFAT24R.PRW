#include "rwmake.ch"        
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Cfat24r()     

SetPrvt("NTAMANHO,NLIMITE,CTITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("ARETURN,NOMEPROG,CPERG,LCONTINUA,NLIN,WNREL")
SetPrvt("CSTRING,NLASTKEY,NPAG,_CTPPROD,_DDATA,_CCLISR")
SetPrvt("_CCLISP,_CCODSP,_CTIPSP,AREGS,I,J")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT24R  ³ Autor ³Ricardo Correa de Souza³ Data ³14/04/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao dos Pedidos para Separacao na Expedicao Sao Roque³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/


*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*---------------------------------------------------------------------------*

//mv_par01                Do Pedido N£mero                                   
//mv_par02                At‚ o Pedido N£mero                                

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Impressao do Relatorio                          *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

nTamanho  := "P"
nLimite   := 80 
cTitulo   := PADC( "Emissao de Pedidos", 74 )
cDesc1    := PADC( "Esta rotina imprime os pedidos de venda colocados, para separacao ", 74 )
cDesc2    := PADC( "na Expedicao - Sao Roque, facilitando a identificacao das reservas", 74 )
cDesc3    := PADC( "", 74 )
aReturn   := { "Especifico", 1, "Exped. Sao Roque", 1, 1, 1, "", 1 }
nomeprog  := "CFAT23R"
cPerg     := "FAT23R"
lContinua := .T.
nLin      := 0
wnrel     := "CFAT24R"
cString   := "SC5"
nLastKey  := 0
nPag      := 1

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

//ValidPerg()     //----> cria grupo de perguntas no sx1 caso nao exista

Pergunte( cPerg, .F. )

wnrel := SetPrint(cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

RptStatus({|| RunProc()})// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> RptStatus({|| Execute(RunProc)})
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SC6")                 // Pedidos de Venda
DbSetOrder(1)                       // Numero Pedido
SetRegua(LastRec())

DbSeek(xFilial("SC6")+mv_par01)

@ 00 , 00 PSAY AvalImp( nLimite )

Do While !Eof() .AND. SC6->C6_NUM <= mv_par02

    IncRegua() 
    
    If SC6->C6_ITEM < MV_PAR03 .OR. SC6->C6_ITEM > MV_PAR04
      DbSkip()
      Loop
    EndIf
    
    _cTpProd := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_TIPO")

    If _cTpProd == "PP"
        _cTipo := "PE"
    Else
        _cTipo := "PV"
    EndIf

    @ 01,00 PSAY Replic( "_", 132 )
    @ 02,02 PSAY "PV "+SC6->C6_NUM+" - "+SC6->C6_ITEM
    @ 02,55 PSAY "Semana: "
    @ 02,63 PSAY _cTipo
    @ 02,67 PSAY Str(SC6->C6_SEMANA,2,0)

    @ 04  ,  02 PSAY "Data Emissao :"
    _dData := Posicione("SC5",1,xFilial("SC5")+SC6->C6_NUM,"C5_EMISSAO")
    @ 04  ,  17 PSAY DTOC(_dData)
    @ 06  ,  02 PSAY "Cliente SR   :"
    @ 06  ,  17 PSAY SC5->C5_CLIENTE
    @ 06  ,  23 PSAY "/"
    @ 06  ,  24 PSAY SC5->C5_LOJACLI
    _cCliSr := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
    @ 06  ,  27 PSAY _cCliSr

    @ 08  ,  02 PSAY "Cliente SP   :"
    @ 08  ,  17 PSAY SC5->C5_CLCLISP
    @ 08  ,  23 PSAY "/"
    @ 08  ,  24 PSAY SC5->C5_CLLOJSP
    _cCliSp := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLCLISP+SC5->C5_CLLOJSP,"A1_NOME")
    _cCodSp := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLCLISP+SC5->C5_CLLOJSP,"A1_CLCLASI")
    _cTipSp := Posicione("SZ2",1,xFilial("SZ2")+_cCodSp,"Z2_CLDESC")

    @ 08  ,  27 PSAY Alltrim(_cCliSp)+" - "+Iif(Subs(_cTipSp,1,6) $ "INDUST/CONSUM","PRODUTOR","REVENDEDOR")

    @ 10  ,  02 PSAY SC6->C6_PRODUTO Picture "@R XX.XXX.XXX"
    @ 10  ,  17 PSAY Left(SC6->C6_DESCRI,22)
    @ 10  ,  40 PSAY SC6->C6_QTDVEN  Picture "@E 99,999.99"
    @ 10  ,  52 PSAY SC6->C6_UM
    @ 12  ,  53 PSAY "Data de Entrega: "
    @ 12  ,  70 PSAY Dtoc(SC6->C6_ENTREG)

    @ 13  ,  00 PSAY Replic( "_", 132 )
    @ 18  ,  00 PSAY " "

    SetPrc(0,0)

    DbSelectArea("SC6")
    DbSkip()
EndDo

If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()

Return

*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*

Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)

aRegs :={}

Aadd(aRegs,{cPerg,"01","Do Pedido               ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Ate o Pedido            ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
    If !DbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    EndIf
Next

Return

