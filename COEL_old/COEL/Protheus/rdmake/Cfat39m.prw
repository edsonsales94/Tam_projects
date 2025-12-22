#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

User Function Cfat39m()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

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
±±³Programa  ³ CFAT39I  ³ Autor ³ADILSON                ³ Data ³24/10/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ EXP DADOS PV X NOTA POR VENDEDOR                           ³±±
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
* mv_par06      ----> Codigo do Vendedor                                    *
* mv_par07      ----> Nome do Arquivo Dbf                                   *
*                                                                       *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

cPerg:= "FAT39M"

ValidPerg()     //----> cria grupos de perguntas no arquivo SX1

Pergunte(cPerg,.T.)               

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Estrutura do Arquivo a ser Exportado                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Estrutura := {}

Aadd(Estrutura,{ "EMP"          ,"C",02,0 } )
Aadd(Estrutura,{ "EMISSAO"      ,"D",08,0 } )
Aadd(Estrutura,{ "PEDIDO"       ,"C",06,0 } )
Aadd(Estrutura,{ "CODIGO"       ,"C",08,0 } )
Aadd(Estrutura,{ "QTD"          ,"N",09,2 } )
Aadd(Estrutura,{ "CODVEN"       ,"C",06,0 } )
Aadd(Estrutura,{ "VENDEDOR"     ,"C",40,0 } )
Aadd(Estrutura,{ "NOTAFIS"      ,"C",06,0 } )
Aadd(Estrutura,{ "DTFATUR"      ,"D",08,0 } )
Aadd(Estrutura,{ "CODCLI"       ,"C",08,0 } )
Aadd(Estrutura,{ "CLIENTE"      ,"C",30,0 } )


cArqTrab := MV_PAR07+".DBF"
DbCreate(cArqTrab,Estrutura)
DbUseArea( .T., , cArqTrab,"TRB",.f.,.f.)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Exportacao de Dados")// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Processa({||Execute(RunProc)},"Exportacao de Dados")
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

    //----> filtrando VENDEDOR
    If MV_PAR06 <> SC5->C5_VEND1
            DbSkip()
            Loop
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
          TRB->EMP      := SC6->C6_FILIAL
          TRB->EMISSAO  := SC5->C5_EMISSAO
          IF  !EMPTY(SC6->C6_NOTA)
              TRB->DTFATUR  := SC6->C6_DATFAT
          ENDIF
          TRB->PEDIDO   := SC6->C6_NUM   
          TRB->NOTAFIS  := SC6->C6_NOTA   
          TRB->CODIGO   := SC6->C6_PRODUTO
          TRB->QTD      := SC6->C6_QTDVEN
          TRB->CODCLI   := SC5->C5_CLIENTE+SC5->C5_LOJACLI
          TRB->CLIENTE  := Posicione("SA1",1,xFilial("SA1")+TRB->CODCLI,"A1_NOME")
          IF  !EMPTY(SC5->C5_VEND1)
               TRB->CODVEN   := SC5->C5_VEND1
               TRB->VENDEDOR := Posicione("SA3",1,xFilial("SA3")+TRB->CODVEN,"A3_NOME")
            ELSE
               TRB->CODVEN   := Posicione("SA1",1,xFilial("SA1")+TRB->CODCLI,"A1_VEND")
               TRB->VENDEDOR := Posicione("SA3",1,xFilial("SA3")+TRB->CODVEN,"A3_NOME")
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
cArqSai :="N:\SIGA\SIGAADV\EXP\FAT\"+cArqTrab

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
    aadd(aRegs,{cPerg,'06','Codigo Vendedor? ','mv_ch6','C',06, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','','SA3'})
    aadd(aRegs,{cPerg,'07','Nome do Arquivo? ','mv_ch7','C',08, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','',''})

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

