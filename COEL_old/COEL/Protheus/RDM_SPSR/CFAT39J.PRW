#include "rwmake.ch"      

User Function Cfat39j()   

SetPrvt("CPERG,LEND,ESTRUTURA,CARQTRAB,_CADTES,CARQENT")
SetPrvt("CARQSAI,AREGS,I,J,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT39J  ³ Autor ³Adilson                ³ Data ³29/10/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Exporta Dados s/faturamento p/calculo comissoes            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Parametros Utilizados                                                     *
*                                                                           *
* mv_par01      ----> Data Inicial                                          *
* mv_par02      ----> Data Final                                            *
* mv_par03      ----> Tipo do Notas  ( Normal/ Todos )                      *
* mv_par04      ----> Contem os Tes                                         *                             
* mv_par05      ----> Complemento TES                                       *                             
* mv_par06      ----> Nome do Arquivo Dbf                                   *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

cPerg:= "FAT39J"
lEnd := .t.

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
Aadd(Estrutura,{ "TES"          ,"C",03,0 } )
Aadd(Estrutura,{ "NPV"          ,"C",06,0 } )
Aadd(Estrutura,{ "ID"           ,"C",06,0 } )
Aadd(Estrutura,{ "EMISSAO"      ,"D",08,0 } )
Aadd(Estrutura,{ "CODIGO"       ,"C",08,0 } )
Aadd(Estrutura,{ "QTD"          ,"N",09,2 } )
Aadd(Estrutura,{ "UNIT"         ,"N",14,4 } )
Aadd(Estrutura,{ "TOTAL"        ,"N",12,2 } )
Aadd(Estrutura,{ "CLIENTE"      ,"C",40,0 } )
Aadd(Estrutura,{ "NOTA"         ,"C",06,0 } )
Aadd(Estrutura,{ "PRCLIS"       ,"N",12,2 } )
Aadd(Estrutura,{ "QTDDEV"       ,"N",12,2 } )
Aadd(Estrutura,{ "PERDESC"      ,"N",12,4 } )
Aadd(Estrutura,{ "VENDEDOR"     ,"C",40,0 } )
Aadd(Estrutura,{ "CODCLI"       ,"C",08,0 } )

cArqTrab := MV_PAR06+".DBF"
DbCreate(cArqTrab,Estrutura)
DbUseArea( .T., , cArqTrab,"TRB",.f.,.f.)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({|lEnd|RunProc()},"Exportacao de Dados Comissoes",.t.)// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({|lEnd|Execute(RunProc)},"Exportacao de Dados Comissoes",.t.)
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SF2")
dbOrderNickName("SF26")

DbSeek(xFilial("SF2")+Dtos(MV_PAR01),.t.)

ProcRegua(LastRec())

_cadtes := mv_par04 + mv_par05

While Eof() == .f. .And. SF2->F2_FILIAL == xFilial("SF2") .And. Dtos(SF2->F2_EMISSAO) <= Dtos(MV_PAR02)

    IncProc("Selecionando Notas  "+SF2->F2_DOC)

    //----> filtrando somente NOTAS   normais
    If MV_PAR03 == 1
        If SF2->F2_TIPO #"N"
            DbSkip()
            Loop
        EndIf
    EndIf

    DbSelectArea("SD2")
    DbSetOrder(3)
    DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)

    While SD2->D2_DOC+SD2->D2_SERIE == SF2->F2_DOC+SF2->F2_SERIE

        //----> filtrando somente intervalo de tes informado no parametro
        If ! SD2->D2_TES $ Alltrim(_cadtes)
            DbSkip()
            Loop
        EndIf

        DbSelectArea("TRB")
        RecLock("TRB",.t.)
          TRB->EMISSAO  := SD2->D2_EMISSAO
          TRB->NOTA     := SD2->D2_DOC    
          TRB->NPV      := SD2->D2_PEDIDO
          TRB->CODIGO   := SD2->D2_COD     
          TRB->QTD      := SD2->D2_QUANT 
          TRB->UNIT     := SD2->D2_PRCVEN
          TRB->TOTAL    := SD2->D2_TOTAL 
          TRB->TES      := SD2->D2_TES    
          TRB->PRCLIS   := SD2->D2_PRUNIT
          TRB->PERDESC  := 1 - (SD2->D2_PRCVEN / SD2->D2_PRUNIT)
          TRB->QTDDEV   := SD2->D2_QTDEDEV
          TRB->CODCLI   := SD2->D2_CLIENTE+SD2->D2_LOJA    
          TRB->CLIENTE  := Posicione("SA1",1,xFilial("SA1")+TRB->CODCLI,"A1_NOME")
          TRB->ID       := Posicione("SA1",1,xFilial("SA1")+TRB->CODCLI,"A1_VEND")
          TRB->VENDEDOR := Posicione("SA3",1,xFilial("SA3")+TRB->ID,"A3_NOME")
        MsUnLock()

        DbSelectArea("SD2")
        DbSkip()
    EndDo

    DbSelectArea("SF2")
    DbSkip()
EndDo

DbSelectArea("TRB")
DbCloseArea()

cArqEnt := cArqTrab
cArqSai :="\EXP\FAT\"+cArqTrab

Copy File (cArqEnt) to (cArqSai)

Ferase(cArqEnt)

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
    aadd(aRegs,{cPerg,'01','Da Emissao     ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Ate Emissao    ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Tipo do Nota   ? ','mv_ch3','N',01, 0, 2,'C', '', 'mv_par03','Normais','','','Todos','','','','','','','','','','',''})
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

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim da Funcao ValidPerg                                                   *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*



