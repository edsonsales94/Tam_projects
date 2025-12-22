#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function Cfat91x()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPERG,X_ESPECIE,X_DTIPO,X_CDE,X_CTP,ESTRUT91")
SetPrvt("CARQTRAB,XTES,_CINDSF1,_CCHASF1,_CFILSF1,CARQENT")
SetPrvt("CARQSAI,AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT91X  ³ Autor ³Adilson M Takeshima    ³ Data ³15/03/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Exporta Dados de Compras                                   ³±±
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
* mv_par01      ----> Data Inicial                                          *
* mv_par02      ----> Data Final                                            *
* mv_par03      ----> Da Filial                                             *                             
* mv_par04      ----> Ate a Filial                                          *                             
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

cPerg:= "FAT91R"

ValidPerg()     //----> cria grupos de perguntas no arquivo SX1

Pergunte(cPerg,.T.)               

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Estrutura do Arquivo a ser Exportado                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
x_ESPECIE := SPACE(30)
x_DTIPO   := SPACE(20)
x_CDE     := " "
x_CTP     := " "
Estrut91 := {}
Aadd(Estrut91,{ "FILIAL"       ,"C",02,0 } ) // SF1- Filial       
Aadd(Estrut91,{ "TIPO"         ,"C",01,0 } ) // SF1- Tipo da Nota
Aadd(Estrut91,{ "DTIPO"        ,"C",20,0 } ) // SB1- DESC TIPO NF
Aadd(Estrut91,{ "CDESPE"       ,"C",01,0 } ) // SB1- Nat.do Produto
Aadd(Estrut91,{ "ESPECIE"      ,"C",30,0 } ) // SB1- DESCRICAO      
Aadd(Estrut91,{ "NOTA"         ,"C",06,0 } ) // SD1- NR NOTA
Aadd(Estrut91,{ "TES"          ,"C",03,0 } ) // SD1- TES
Aadd(Estrut91,{ "CFO"          ,"C",04,0 } ) // SD1- CFO         
Aadd(Estrut91,{ "TOTITEM"      ,"N",12,4 } ) // SD1- Total do Item
Aadd(Estrut91,{ "VITEMIP"      ,"N",12,4 } ) // SD1- Valor IPI
Aadd(Estrut91,{ "VITEMIC"      ,"N",12,4 } ) // SD1- Valor ICM
Aadd(Estrut91,{ "TOTFRT"       ,"N",12,4 } ) // SF1- Total do Frete
Aadd(Estrut91,{ "TOTDSP"       ,"N",12,4 } ) // SF1- Total Despesas
Aadd(Estrut91,{ "TOTNOT"       ,"N",12,4 } ) // SF1- Total Nota com IPI
Aadd(Estrut91,{ "TOTIPI"       ,"N",12,4 } ) // SF1- Total IPI da Nota
Aadd(Estrut91,{ "TOTICM"       ,"N",12,4 } ) // SF1- Total ICMS da Nota
Aadd(Estrut91,{ "DTDIGIT"      ,"D",08,0 } ) // SF1- Data de Digitacao 

cArqTrab := "COMPRAS.DBF"
DbCreate(cArqTrab,Estrut91)
DbUseArea( .T., , cArqTrab,"TRB",.f.,.f.)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
xTES :="001/002/003/004/007/008/009/014/015/018/020/021/022/023/025/026/030/034/038/040/041/043/087"


Processa({||RunProc()},"Exportacao das Notas de Compras")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({||Execute(RunProc)},"Exportacao das Notas de Compras")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SF1")

_cIndSF1 := CriaTrab(Nil,.f.)
_cChaSF1 := "SF1->F1_FILIAL+DTOS(SF1->F1_DTDIGIT)+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA"
_cFilSF1 := "Dtos(SF1->F1_DTDIGIT) >= Dtos(MV_PAR01) .And. Dtos(SF1->F1_DTDIGIT) <= Dtos(MV_PAR02)"
IndRegua("SF1",_cIndSF1,_cChaSF1,,_cFilSF1,"Selecionando Registros SF1 (Indice Temporario)")

ProcRegua(RecCount())

//DbSeek(MV_PAR03+Dtos(MV_PAR01),.t.)

While Eof() == .f. 

    IncProc("Selecionando Notas  "+SF1->F1_DOC)

    If SF1->F1_FILIAL < MV_PAR03 .OR. SF1->F1_FILIAL > MV_PAR04
        DbSkip()
        Loop
    EndIf

    /*
    If Dtos(SF1->F1_DTDIGIT) < Dtos(MV_PAR01) .OR. Dtos(SF1->F1_DTDIGIT) > Dtos(MV_PAR02)
        DbSkip()
        Loop
    EndIf
    */

    DbSelectArea("SD1")
    DbSetOrder(1)
    DbSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

    While SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

        //----> filtrando somente intervalo de tes informado no parametro
        If ! SD1->D1_TES $ Alltrim(xTES)
            DbSkip()
            Loop
        EndIf

        DbSelectArea("TRB")
        RecLock("TRB",.t.)
          TRB->FILIAL   := SF1->F1_FILIAL
          x_CTP         := SF1->F1_TIPO 
          TRB->NOTA     := SD1->D1_DOC
          TRB->TES      := SD1->D1_TES
          TRB->CFO      := SD1->D1_CF
          TRB->TOTITEM  := SD1->D1_TOTAL
          TRB->VITEMIP  := SD1->D1_VALIPI
          TRB->VITEMIC  := SD1->D1_VALICM
          TRB->TOTFRT   := SF1->F1_FRETE
          TRB->TOTDSP   := SF1->F1_DESPESA
          TRB->TOTNOT   := SF1->F1_VALBRUT
          TRB->TOTIPI   := SF1->F1_VALIPI
          TRB->TOTICM   := SF1->F1_VALICM
          TRB->DTDIGIT  := SF1->F1_DTDIGIT

          IF   x_CTP == "N"
               x_DTIPO := "NORMAL              "
          ENDIF
          IF   x_CTP == "C"
               x_DTIPO := "COMPLEMENTO PRECO   "
          ENDIF
          IF   x_CTP == "I"
               x_DTIPO := "COMPLEMENTO ICMS    "
          ENDIF
          IF   x_CTP == "P"
               x_DTIPO := "COMPLEMENTO IPI     "
          ENDIF
          IF   x_CTP == "B"
               x_DTIPO := "BENEFICIAMENTO      "
          ENDIF
          IF   x_CTP == "D"
               x_DTIPO := "DEVOLUCAO           "
          ENDIF

          TRB->DTIPO := x_DTIPO
          x_CDE         := Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_CLESPEC")
          IF   x_CDE == "1"
               x_ESPECIE := "Componentes Producao         "
          ENDIF
          IF   x_CDE == "2"
               x_ESPECIE := "Material Improdutivo         "
          ENDIF
          IF   x_CDE == "3"
               x_ESPECIE := "Produtos de Revenda Importado"
          ENDIF
          IF   x_CDE == "4"
               x_ESPECIE := "Produtos de Revenda Nacional "
          ENDIF
          IF   x_CDE == "5"
               x_ESPECIE := "Produtos Bxo Indice Nacional "
          ENDIF
          IF   x_CDE == "6"
               x_ESPECIE := "Produtos Import MO Nacional  "
          ENDIF
          IF   x_CDE == "7"
               x_ESPECIE := "Produtos Fabricados          "
          ENDIF
          IF   x_CDE == "9"
               x_ESPECIE := "Outros                       "
          ENDIF
          TRB->CDESPE   := x_CDE
          TRB->ESPECIE  := x_ESPECIE
          TRB->TIPO     := x_CTP
        MsUnLock()

        DbSelectArea("SD1")
        DbSkip()
    EndDo

    DbSelectArea("SF1")
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
    aadd(aRegs,{cPerg,'03','Da Filial      ? ','mv_ch3','C',02, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Ate a Filial   ? ','mv_ch4','C',02, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','',''})

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