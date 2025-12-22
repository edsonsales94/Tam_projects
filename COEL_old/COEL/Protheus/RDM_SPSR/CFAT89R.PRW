#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Cfat89r()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AESTRU1,_CTEMP1,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN")
SetPrvt("M_PAG,CNUMPED,CABEC1,CABEC2,CINDEX,CCHAVE")
SetPrvt("AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT89R  ³ Autor ³Ricardo Correa de Souza³ Data ³18/07/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Transferencias de Sao Roque para Sao Paulo      ³±±
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

DbSelectArea("SC6")         //----> Itens dos Pedidos de Vendas
DbSetOrder(1)               //----> Filial + Numero 

DbSelectArea("SD2")         //----> Itens das Notas de Saidas
DbSetOrder(5)               //----> Filial + Emissao

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

aEstru1 :={}
AADD(aEstru1,{"PVSP"    ,"C",06,0})
AADD(aEstru1,{"ITSP"    ,"C",02,0})
AADD(aEstru1,{"CODPRO"  ,"C",15,0})
AADD(aEstru1,{"QTDE"    ,"N",09,2})
AADD(aEstru1,{"SALDO"   ,"N",09,2})
AADD(aEstru1,{"PVSRQ"   ,"C",06,0})
AADD(aEstru1,{"CODCLI"  ,"C",06,0})
AADD(aEstru1,{"LOJA"    ,"C",02,0})

_cTemp1 := CriaTrab( aEstru1, .T. )  
//dbUseArea(.T.,__cRdd,_cTemp1,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )
dbUseArea(.T.,,_cTemp1,"TRB", NIL, .F. )

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "CFAT89R"
cDesc1    := "Pedidos Transferidos por Sao Roque"
cDesc2    := " "
cDesc3    := " "
cString   := "SD2"
lEnd      := .F.
tamanho   := "P"
limite    := 80
titulo    := "Relacao Transferencias de Sao Roque"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "CFAT89R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT89R"
nLin      := 7
m_pag     := 1
cNumped   := Space(6)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Da  Dt.Emissao ?                                          *
* mv_par02  ----> Ate Dt.Emissao ?                                          *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

ValidPerg()     //----> Atualiza o arquivo de perguntas SX1

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
    Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

cabec1  := Padc("REFERENTE AO PERIODO DE: "+DTOC(MV_PAR01)+" A "+DTOC(MV_PAR02),80)
cabec2  := ""

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Transferencias do Periodo "+Dtoc(mv_par01)+" - "+Dtoc(mv_par02))// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({||Execute(RunProc)},"Transferencias do Periodo "+Dtoc(mv_par01)+" - "+Dtoc(mv_par02))
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SD2")
DbSetOrder(5)
ProcRegua(RecCount())

DbSeek("02"+Dtos(mv_par01),.t.)

While Eof() == .f. .And. Dtos(SD2->D2_EMISSAO) <= Dtos(mv_par02)

    IncProc("Selecionando Dados da Nota "+SD2->D2_DOC+"/"+SD2->D2_SERIE)

    //----> filtrando somente datas selecionadas nos parametros
    If Dtos(SD2->D2_EMISSAO) < Dtos(mv_par01) .Or. Dtos(SD2->D2_EMISSAO) > Dtos(mv_par02)
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SC6")
    DbSetOrder(1)
    If DbSeek("02"+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
        If Empty(SC6->C6_CLPEDSP)
            DbSelectArea("SD2")
            DbSkip()
            Loop
        EndIf

        DbSelectArea("TRB")
        RecLock("TRB",.T.)
          TRB->PVSP     := SC6->C6_CLPEDSP
          TRB->ITSP     := SC6->C6_CLITPSP
          TRB->CODPRO   := SD2->D2_COD
          TRB->QTDE     := SD2->D2_QUANT
          TRB->SALDO    := SC6->C6_QTDVEN - SC6->C6_QTDENT
          TRB->PVSRQ    := SC6->C6_NUM
          TRB->CODCLI   := SC6->C6_CLCLISP
          TRB->LOJA     := SC6->C6_CLLOJSP
        MsUnLock()
    EndIf

    DbSelectArea("SD2")
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

DbSelectArea("TRB")
cIndex := CriaTrab(Nil,.f.)
cChave := "PVSP + ITSP"

IndRegua("TRB",cIndex,cChave,,,"Indice Temporario")

DbGoTop()
SetRegua(LastRec())

@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)

@ nLin, 000 PSAY "PEDIDO  COD.CLIENTE  NOME CLIENTE"
nLin := nLin + 1

cNumPed := TRB->PVSP

While Eof() == .f.

    IncRegua()

    ImpCab() //----> impressao dos dados do cliente

    While TRB->PVSP == cNumPed

        @ nLin, 000       PSAY TRB->ITSP        
        @ nLin, Pcol()+1  PSAY TRB->CODPRO                           Picture"@R 99.999.999"
        @ nLin, Pcol()+1  PSAY Posicione("SB1",1,xFilial("SB1")+TRB->CODPRO,"B1_DESC")
	@ nLin, Pcol()+2   PSAY TRB->QTDE			     Picture "@E 999,999.99"
	@ nLin, Pcol()+6  PSAY TRB->SALDO			     Picture "@E 999,999.99"
        @ nLin, Pcol()+2  PSAY TRB->PVSRQ     
        nLin := nLin + 1
        If nLin > 58                            
            @ nLin, 000 Psay Replicate(" ",54)+"Continua na Proxima Pagina"
            cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
            nLin := 07
            @ nLin, 000 PSAY "PEDIDO  COD.CLIENTE  NOME CLIENTE"
            nLin := nLin + 1
            ImpCab()
        Endif

        DbSkip()
    EndDo

    @ nLin, 000 PSAY Replicate("-",limite)
    nLin := nLin + 2

    cNumPed := TRB->PVSP

EndDo

nLin := nLin + 1
@ nLin, 000 PSAY Replicate("-",limite)
nLin := nLin + 1
@ nLin, 000 Psay Replicate(" ",62)+"Final do Relatorio"

Roda(cbCont,"Transferencia",tamanho)

Set Device to Screen

If aReturn[5] == 1 
	Set Printer TO
    dbCommitAll()
    OurSpool(wnrel)
Endif

DbSelectArea("TRB")
DbCloseArea("TRB")
//Ferase(_cTemp1+".dbf")

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
    aadd(aRegs,{cPerg,'01','Da  Dt.Emissao ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Ate Dt.Emissao ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})

    For i:=1 to len(aRegs)
        Dbseek(cPerg+strzero(i,2))
        If found() == .f.
            RecLock("SX1",.t.)
            For j:=1 to fcount()
                FieldPut(j,aRegs[i,j])
            Next
            MsUnLock()
        EndIf
    Next
EndIf

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ImpCab
Static Function ImpCab()

If nLin > 58
    @ nLin, 000 Psay Replicate(" ",54)+"Continua na Proxima Pagina"
    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
    nLin := 07
    @ nLin, 000 PSAY "PEDIDO  COD.CLIENTE  NOME CLIENTE"
    nLin := nLin + 1
Endif

@ nLin, 000       PSAY TRB->PVSP      
@ nLin, Pcol()+2  PSAY TRB->CODCLI      
@ nLin, Pcol()    PSAY "/"
@ nLin, Pcol()    PSAY TRB->LOJA       
@ nLin, Pcol()+4  PSAY Posicione("SA1",1,xFilial("SA1")+TRB->CODCLI+TRB->LOJA,"A1_NOME")

nLin := nLin + 2
  
@nLin, 000        PSAY "IT PRODUTO    DESCRICAO DO PRODUTO           QUANTIDADE          SALDO    PV SRQ"
nLin := nLin + 2
/*
@ nLin, 000       PSAY SC6->C6_CLITPSP
@ nLin, Pcol()+1  PSAY SD2->D2_COD                      Picture"@R 99.999.999"
@ nLin, Pcol()+1  PSAY Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_DESC")
@ nLin, Pcol()    PSAY SD2->D2_QUANT                    Picture "@E999,999.99"
@ nLin, Pcol()+2  PSAY SC6->C6_QTDVEN - SC6->C6_QTDENT  Picture "@E999,999.99"
@ nLin, Pcol()+4  PSAY SD2->D2_PEDIDO
nLin := nLin + 1

*/

Return

