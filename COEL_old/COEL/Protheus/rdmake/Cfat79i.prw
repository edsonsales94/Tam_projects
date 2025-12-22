#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

User Function Cfat79i()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPERG,ESTRUTURA,CARQTRAB,NTOTPV,NFLAG,CARQENT")
SetPrvt("CARQSAI,AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT79I  ³ Autor ³Adilson M. Takeshima   ³ Data ³31/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Arq.DBF c/dados de PV por Operador/Tes de vendas p/   ³±±
±±³          ³ estat¡stica da Gerencia de Vendas                          ³±±
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

cPerg:= "FAT39I"

ValidPerg()     //----> cria grupos de perguntas no arquivo SX1

If !Pergunte(cPerg,.t.)
// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==>     __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02
EndIf

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Estrutura do Arquivo a ser Exportado                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Estrutura := {}
Aadd(Estrutura,{ "ATENDE"       ,"C",20,0 } )
Aadd(Estrutura,{ "EMISSAO"      ,"D",08,0 } )
Aadd(Estrutura,{ "PEDIDO"       ,"C",06,0 } )
Aadd(Estrutura,{ "CLIENTE"      ,"C",30,0 } )
Aadd(Estrutura,{ "VALOR"        ,"N",12,2 } )

cArqTrab := MV_PAR06+".DBF"
DbCreate(cArqTrab,Estrutura)
DbUseArea( .T., , cArqTrab,"TRB",.f.,.f.)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Gerando Arquivo")// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Processa({||Execute(RunProc)},"Gerando Arquivo")
// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SC5")
DbSetOrder(2)
DbSeek(xFilial("SC5")+Dtos(MV_PAR01),.t.)

ProcRegua(LastRec())

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

    nTotPv := 0
    nFlag  := 0

    While SC6->C6_NUM == SC5->C5_NUM

        //----> filtrando somente intervalo de tes informado no parametro
        If ! SC6->C6_TES $ Alltrim(mv_par04+mv_par05)
            DbSkip()
            Loop
        EndIf

        nTotPv := nTotPv + SC6->C6_VALOR

        If nFlag == 0
            DbSelectArea("TRB")
            RecLock("TRB",.t.)
              TRB->ATENDE   := SC5->C5_CLATEND
              TRB->EMISSAO  := SC5->C5_EMISSAO
              TRB->PEDIDO   := SC5->C5_NUM   
              TRB->CLIENTE  := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
              TRB->VALOR    := nTotPv
            MsUnLock()
            nFlag := 1
        Else
            DbSelectArea("TRB")
            RecLock("TRB",.f.)
              TRB->VALOR    := nTotPv
            MsUnLock()
        EndIf

        DbSelectArea("SC6")
        DbSkip()
  
    EndDo

    DbSelectArea("SC5")
    DbSkip()
EndDo

DbSelectArea("TRB")
DbCloseArea()

cArqEnt := cArqTrab
cArqSai :="C:\"+cArqTrab

Copy File (cArqEnt) to (cArqSai)

Ferase(cArqEnt)

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

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

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim da Funcao ValidPerg                                                   *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
