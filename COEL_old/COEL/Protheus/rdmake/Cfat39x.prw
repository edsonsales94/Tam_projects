#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

User Function Cfat39x()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPERG,ESTRUTURA,CARQTRAB,_CADTES,CARQENT,CARQSAI")
SetPrvt("AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT39X  ³ Autor ³ADILSON M TAKESHIMA    ³ Data ³21/11/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Extrai dados p/Planejamento Comercial 2002                 ³±±
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
* Parametros Utilizados                                                     *
*                                                                           *
* mv_par01      ----> Data Inicial                                          *
* mv_par02      ----> Data Final                                            *
* mv_par03      ----> Tipo do Pedido ( Normal/ Todos )                      *
* mv_par04      ----> Contem os Tes                                         *                             
* mv_par05      ----> Complemento TES                                       *                             
* mv_par06      ----> Nome do Arquivo Dbf                                   *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

cPerg:= "FAT39N"

ValidPerg()     //----> cria grupos de perguntas no arquivo SX1

If !Pergunte(cPerg,.T.)
    Return
EndIf

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Estrutura do Arquivo a ser Exportado                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Estrutura := {}
Aadd(Estrutura,{ "RX"           ,"C",01,0 } )
Aadd(Estrutura,{ "EMISSAO"      ,"D",08,0 } )
Aadd(Estrutura,{ "PEDIDO"       ,"C",06,0 } )
Aadd(Estrutura,{ "CODIGO"       ,"C",08,0 } )
Aadd(Estrutura,{ "PRODUTO"      ,"C",30,0 } )
Aadd(Estrutura,{ "QTD"          ,"N",09,2 } )
Aadd(Estrutura,{ "UNIT"         ,"N",14,4 } )
Aadd(Estrutura,{ "TOTAL"        ,"N",12,2 } )
Aadd(Estrutura,{ "QTE"          ,"N",09,2 } )
Aadd(Estrutura,{ "TOTEN"        ,"N",12,2 } )
Aadd(Estrutura,{ "PRCLIS"       ,"N",12,2 } )
Aadd(Estrutura,{ "PRCMED"       ,"N",12,2 } )
Aadd(Estrutura,{ "VLRDESC"      ,"N",12,2 } )
Aadd(Estrutura,{ "CODFAM"       ,"C",04,0 } )
Aadd(Estrutura,{ "FAMILIA"      ,"C",20,0 } )
Aadd(Estrutura,{ "CODGRU"       ,"C",04,0 } )
Aadd(Estrutura,{ "GRUPO"        ,"C",20,0 } )
Aadd(Estrutura,{ "CODSUB"       ,"C",04,0 } )
Aadd(Estrutura,{ "SUBGRUPO"     ,"C",20,0 } )
Aadd(Estrutura,{ "CODCLI"       ,"C",08,0 } )
Aadd(Estrutura,{ "CLIENTE"      ,"C",40,0 } )
Aadd(Estrutura,{ "TIPOPMRDT"    ,"C",01,0 } )
Aadd(Estrutura,{ "TIPOFIS"      ,"C",01,0 } )
Aadd(Estrutura,{ "TIPOPMR"      ,"C",01,0 } )
Aadd(Estrutura,{ "MUNICIPIO"    ,"C",25,0 } )
Aadd(Estrutura,{ "UF"           ,"C",02,0 } )
Aadd(Estrutura,{ "CODVEN"       ,"C",06,0 } )
Aadd(Estrutura,{ "VENDEDOR"     ,"C",40,0 } )

cArqTrab := MV_PAR06+".DBF"
DbCreate(cArqTrab,Estrutura)
DbUseArea( .T., , cArqTrab,"TRB",.f.,.f.)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Exportacao de Dados - VBMC")// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Processa({||Execute(RunProc)},"Exportacao de Dados - VBMC")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SC5")
DbSetOrder(2)
DbSeek(xFilial("SC5")+Dtos(MV_PAR01),.t.)

ProcRegua(LastRec())

_cadtes := mv_par04 + mv_par05
While Eof() == .f. .And. Dtos(SC5->C5_EMISSAO) <= Dtos(MV_PAR02)

    IncProc("Selecionando Pedido "+SC5->C5_NUM+" "+SC5->C5_CLNOMCL)

    //----> filtrando somente pedidos normais
    If MV_PAR03 == 1
        If SC5->C5_TIPO #"N"
            DbSkip()
            Loop
        EndIf
    EndIf

    DbSelectArea("SC6")
    DbSetOrder(1)
    DbSeek(xFilial("SC6")+SC5->C5_NUM)

    While SC6->C6_NUM == SC5->C5_NUM

        //----> filtrando somente intervalo de tes informado no parametro
        If ! SC6->C6_TES $ Alltrim(_cadtes)
            DbSkip()
            Loop
        EndIf                 

        DbSelectArea("TRB")
        RecLock("TRB",.t.)
          TRB->EMISSAO  := SC5->C5_EMISSAO
          TRB->PEDIDO   := SC6->C6_NUM   
          TRB->CODIGO   := SC6->C6_PRODUTO
          TRB->PRODUTO  := SC6->C6_DESCRI
          TRB->QTD      := SC6->C6_QTDVEN
          TRB->UNIT     := SC6->C6_PRCVEN
          TRB->TOTAL    := SC6->C6_VALOR 
          TRB->QTE      := SC6->C6_QTDENT
          TRB->TOTEN    := SC6->C6_VALOR 
          TRB->PRCMED   := TRB->TOTAL / TRB->QTD
          TRB->PRCLIS   := SC6->C6_PRUNIT
          TRB->VLRDESC  := 100 - ( (TRB->UNIT / TRB->PRCLIS) * 100 )
          TRB->CODSUB   := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_GRUPO")
          TRB->SUBGRUPO := Posicione("SZG",1,xFilial("SZG")+TRB->CODSUB,"ZG_DESC")
          TRB->CODFAM   := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_CLCFAM")
          TRB->FAMILIA  := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_CLDFAM")
          TRB->CODGRU   := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_CLCGRP")
          TRB->GRUPO    := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_CLDGRP")
          TRB->CODCLI   := SC5->C5_CLIENTE+SC5->C5_LOJACLI
          TRB->CLIENTE  := Posicione("SA1",1,xFilial("SA1")+TRB->CODCLI,"A1_NOME")
          TRB->TIPOPMRDT:= Posicione("SA1",1,xFilial("SA1")+TRB->CODCLI,"A1_CLASCLI")
          TRB->TIPOFIS  := Posicione("SA1",1,xFilial("SA1")+TRB->CODCLI,"A1_TIPO")
          TRB->TIPOPMR  := Subs(Posicione("SA1",1,xFilial("SA1")+TRB->CODCLI,"A1_CLCLASI"),1,1)
          TRB->MUNICIPIO:= Posicione("SA1",1,xFilial("SA1")+TRB->CODCLI,"A1_MUN")
          TRB->UF       := Posicione("SA1",1,xFilial("SA1")+TRB->CODCLI,"A1_EST")
          TRB->CODVEN   := Posicione("SA1",1,xFilial("SA1")+TRB->CODCLI,"A1_VEND")
          TRB->VENDEDOR := Posicione("SA3",1,xFilial("SA3")+TRB->CODVEN,"A3_NOME")
          IF  !EMPTY(SC6->C6_BLQ)
               TRB->RX   := "X"
          ENDIF
        MsUnLock()

        DbSelectArea("SC6")
        DbSkip()
    EndDo

    DbSelectArea("SC5")
    DbSkip()
EndDo

DbSelectArea("TRB")
DbCloseArea()

cArqEnt := cArqTrab
cArqSai :="C:\DADOSOBS\"+cArqTrab

Copy File (cArqEnt) to (cArqSai)

Ferase(cArqEnt)

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
    aRegs := {}
    aadd(aRegs,{cPerg,'01','Da Emissao     ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Ate Emissao    ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Tipo do Pedido ? ','mv_ch3','N',01, 0, 2,'C', '', 'mv_par03','Normais','','','Todos','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Contem os Tes  ? ','mv_ch4','C',30, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'05','Complem.TES    ? ','mv_ch5','C',30, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'06','Nome do Arquivo? ','mv_ch6','C',08, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})

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

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim da Funcao ValidPerg                                                   *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02
