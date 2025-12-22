#include "rwmake.ch"        

User Function Cfat27i()     

SetPrvt("CPERG,_CARQENT1,_CARQSAI1,_CARQENT2,_CARQSAI2,_CARQENT3")
SetPrvt("_CARQSAI3,_CARQENT4,_CARQSAI4,_CARQENT5,_CARQSAI5,SA1")
SetPrvt("CARQTRAB1,SB1,CARQTRAB2,SA4,CARQTRAB3,SF4")
SetPrvt("CARQTRAB4,SE4,CARQTRAB5,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CLFTEXP  ³ Autor ³ Adilson Takeshima     ³ Data ³ 02/02/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de Exportacao de Cadastro de Clientes, Produtos,  ³±±
±±³          ³ Transportadoras, Cond.Pagamento e TES para Representantes  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico - COEL                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a Tela de Dialogo                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPerg:= "EXPCAD"
Pergunte(cPerg,.T.)               // Pergunta no SX1
@ 130,120 TO 310,550 DIALOG oDlg TITLE OemToAnsi("Exportacao de Cadastros")
@ 09, 05 TO 64, 210
@ 25, 40 SAY OemToAnsi("O objetivo deste programa e exportar os Cadastros")
@ 35, 40 SAY OemToAnsi("de Clientes,Produtos,Transp,Cond.Pagto e TES de  ")
@ 45, 40 SAY OemToAnsi("acordo com os parametros selecionados.           ")
@ 70,148 BMPBUTTON TYPE 1 ACTION INICIOExp()// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> @ 70,148 BMPBUTTON TYPE 1 ACTION Execute(INICIOExp)
@ 70,176 BMPBUTTON TYPE 2 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED
Close(oDlg)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ INICIOExp³ Autor ³ Adilson Takeshima     ³ Data ³ 02/02/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exporta os Cadastro de Clientes                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico - COEL                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function INICIOExp
Static Function INICIOExp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o Arquivo de Trabalho a ser exportado                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fCriaTRB()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exporta os Cadastro de Clientes                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa( {|| GRAVATR1() }, "Exportando Cadastro Clientes " )// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa( {|| Execute(GRAVATR1) }, "Exportando Cadastro Clientes " )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exporta os Cadastro de Produtos                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa( {|| GRAVATR2() }, "Exportando Cadastro Produtos " )// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa( {|| Execute(GRAVATR2) }, "Exportando Cadastro Produtos " )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exporta os Cadastro de Transportadoras                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa( {|| GRAVATR3() }, "Exportando Cad.de Transportadoras" )// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa( {|| Execute(GRAVATR3) }, "Exportando Cad.de Transportadoras" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exporta os Cadastro de TES                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa( {|| GRAVATR4() }, "Exportando Cadastro de TES" )// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa( {|| Execute(GRAVATR4) }, "Exportando Cadastro de TES" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exporta os Cadastro de Condicoes de Pagamento                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa( {|| GRAVATR5() }, "Exportando Cad.Cond.de Pagamentos " )// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa( {|| Execute(GRAVATR5) }, "Exportando Cad.Cond.de Pagamentos " )
Close(oDlg)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fGravaTRs ³ Autor ³ Adilson Takeshima     ³ Data ³ 02/02/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exporta cadastros                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico - COEL                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exporta Cadastro de Clientes                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function GRAVATR1
Static Function GRAVATR1()
DbSelectArea("SA1")
DbSetOrder(1)
DbGoTop()
ProcRegua( LastRec() )
While !Eof() .AND. MV_PAR03 == 1
    if MV_PAR01 <> SA1->A1_VEND
        DbSkip()
        Loop
    EndIf

    IncProc()
    DbSelectArea("TRB1")
    reclock("TRB1",.t.)
    TRB1->A1_COD      := SA1->A1_COD
    TRB1->A1_LOJA     := SA1->A1_LOJA
    TRB1->A1_NOME     := SA1->A1_NOME
    TRB1->A1_NREDUZ   := SA1->A1_NREDUZ
    TRB1->A1_DESC     := SA1->A1_DESC
    TRB1->A1_CGC      := SA1->A1_CGC
    TRB1->A1_INSCR    := SA1->A1_INSCR
    TRB1->A1_END      := SA1->A1_END
    TRB1->A1_BAIRRO   := SA1->A1_BAIRRO
    TRB1->A1_MUN      := SA1->A1_MUN
    TRB1->A1_EST      := SA1->A1_EST
    TRB1->A1_CEP      := SA1->A1_CEP
    TRB1->A1_TEL      := SA1->A1_TEL
    TRB1->A1_CLTELEF  := SA1->A1_CLTELEF
    TRB1->A1_FAX      := SA1->A1_FAX
    TRB1->A1_TELEX    := SA1->A1_TELEX
    TRB1->A1_VEND     := SA1->A1_VEND
    TRB1->A1_ENDCOB   := SA1->A1_ENDCOB
    TRB1->A1_BAIRROC  := SA1->A1_BAIRROC
    TRB1->A1_CLTELCB  := SA1->A1_CLTELCB
    TRB1->A1_CLFAXCB  := SA1->A1_CLFAXCB
    TRB1->A1_MUNC     := SA1->A1_MUNC
    TRB1->A1_ESTC     := SA1->A1_ESTC
    TRB1->A1_CEPC     := SA1->A1_CEPC
    TRB1->A1_ENDENT   := SA1->A1_ENDENT
    TRB1->A1_BAIRROE  := SA1->A1_BAIRROE
    TRB1->A1_MUNE     := SA1->A1_MUNE
    TRB1->A1_ESTE     := SA1->A1_ESTE
    TRB1->A1_CEPE     := SA1->A1_CEPE
    TRB1->A1_CLCGCEN  := SA1->A1_CLCGCEN
    TRB1->A1_CLIEENT  := SA1->A1_CLIEENT
    TRB1->A1_CONTATO  := SA1->A1_CONTATO
    TRB1->A1_REGIAO   := SA1->A1_REGIAO
    TRB1->A1_COND     := SA1->A1_COND
    TRB1->A1_TRANSP   := SA1->A1_TRANSP
    TRB1->A1_RISCO    := SA1->A1_RISCO
    TRB1->A1_TABELA   := SA1->A1_TABELA
    TRB1->A1_BCO1     := SA1->A1_BCO1
    TRB1->A1_EMAIL    := SA1->A1_EMAIL
    TRB1->A1_OBSERV   := SA1->A1_OBSERV
    TRB1->A1_DTATUALIZ:= DDATABASE
    MsUnlock()
    DbSelectArea("SA1")
    DbSkip()
Enddo

If MV_PAR03 == 1
    DbSelectArea("TRB1")
    DbCloseArea()
    
    //Copia o arquivo para o diretorio de exportacao

    _cArqEnt1:= cArqtrab1
    _cArqSai1:="\EXP\CADASTRO\"+cArqtrab1
    copy file (_cArqEnt1) to (_cArqSai1)
    ferase(_cArqEnt1)
EndIf
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exporta Cadastro de Produtos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function GRAVATR2
Static Function GRAVATR2()
DbSelectArea("SB1")
DbSetOrder(1)
DbGoTop()
ProcRegua( LastRec() )
While ! Eof() .And. MV_PAR02 == 1
    If SB1->B1_CLSTATU <> "A"
        DbSkip()
        Loop
    Else
        If SB1->B1_TIPO <> "PA"
            DbSkip()
            Loop
        EndIF
    EndIf
    IncProc()
    DbSelectArea("SB5")
    DbSetOrder(1)
    DbSeek(xFilial("SB5")+SB1->B1_COD)
    DbSelectarea("TRB2")
    reclock("TRB2",.t.)
    TRB2->B1_COD      := SB1->B1_COD
    TRB2->B1_CLSTATU  := SB1->B1_CLSTATU
    TRB2->B1_DESC     := SB1->B1_DESC
    TRB2->B1_PE       := SB1->B1_PE  
    TRB2->B1_CLPEVEN  := SB1->B1_CLPEVEN
    TRB2->B5_CEME     := SB5->B5_CEME
    TRB2->B1_PICM     := SB1->B1_PICM
    TRB2->B1_IPI      := SB1->B1_IPI
    TRB2->B1_POSIPI   := SB1->B1_POSIPI
    TRB2->B1_UM       := SB1->B1_UM
    TRB2->B1_PRV1     := SB1->B1_PRV1
    TRB2->B1_PMIN     := SB1->B1_PRV1
    TRB2->B1_DTATUALIZ:= DDATABASE  
    MsUnlock()
    DbSelectArea("SB1")
    DbSkip()
Enddo
If MV_PAR02 == 1
    DbSelectArea("TRB2")
    DbCloseArea()

    //Copia o arquivo para o diretorio de exportacao

    _cArqEnt2:= cArqtrab2
    _cArqSai2:="\EXP\CADASTRO\"+cArqtrab2
    copy file (_cArqEnt2) to (_cArqSai2)
    ferase(_cArqEnt2)
EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exporta Cadastro de Transportadoras                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function GRAVATR3
Static Function GRAVATR3()
DbSelectArea("SA4")
DbSetOrder(1)
DbGoTop()
ProcRegua( LastRec() )
While ! Eof() .And. MV_PAR04 == 1
    DbSelectarea("TRB3")
    Incproc()
    reclock("TRB3",.t.)
    TRB3->A4_COD      := SA4->A4_COD
    TRB3->A4_NOME     := SA4->A4_NOME
    TRB3->A4_NREDUZ   := SA4->A4_NREDUZ
    TRB3->A4_VIA      := SA4->A4_VIA
    TRB3->A4_END      := SA4->A4_END
    TRB3->A4_CLBAIRR  := SA4->A4_CLBAIRR
    TRB3->A4_MUN      := SA4->A4_MUN
    TRB3->A4_CEP      := SA4->A4_CEP
    TRB3->A4_EST      := SA4->A4_EST
    TRB3->A4_CGC      := SA4->A4_CGC
    TRB3->A4_TEL      := SA4->A4_TEL
    TRB3->A4_CLTEL1   := SA4->A4_CLTEL1
    TRB3->A4_CLFAX    := SA4->A4_CLFAX
    TRB3->A4_TELEX    := SA4->A4_TELEX
    TRB3->A4_CONTATO  := SA4->A4_CONTATO
    TRB3->A4_INSEST   := SA4->A4_INSEST
    TRB3->A4_EMAIL    := SA4->A4_EMAIL
    TRB3->A4_HPAGE    := SA4->A4_HPAGE
    TRB3->A4_DTATUALIZ:= DDATABASE
    MsUnlock()
    DbSelectArea("SA4")
    DbSkip()
Enddo
If MV_PAR04 == 1
    DbSelectArea("TRB3")
    DbCloseArea()

    //Copia o arquivo para o diretorio de exportacao

    _cArqEnt3:= cArqtrab3
    _cArqSai3:="\EXP\CADASTRO\"+cArqtrab3
    copy file (_cArqEnt3) to (_cArqSai3)
    ferase(_cArqEnt3)
EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exporta Cadastro de TES                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function GRAVATR4
Static Function GRAVATR4()
DbSelectArea("SF4")
DbSetOrder(1)
DbGoTop()
ProcRegua( LastRec() )
While ! Eof() .AND. MV_PAR06 == 1
    If SF4->F4_TIPO <> "S"
        DbSkip()
        Loop
    EndIF
    DbSelectarea("TRB4")
    Incproc()
    reclock("TRB4",.t.)
    TRB4->F4_CODIGO   := SF4->F4_CODIGO
    TRB4->F4_CLFINA   := SF4->F4_CLFINA
    TRB4->F4_TIPO     := SF4->F4_TIPO
    TRB4->F4_ICM      := SF4->F4_ICM
    TRB4->F4_IPI      := SF4->F4_IPI
    TRB4->F4_CREDICM  := SF4->F4_CREDICM
    TRB4->F4_CREDIPI  := SF4->F4_CREDIPI
    TRB4->F4_DUPLIC   := SF4->F4_DUPLIC
    TRB4->F4_ESTOQUE  := SF4->F4_ESTOQUE
    TRB4->F4_CF       := SF4->F4_CF
    TRB4->F4_TEXTO    := SF4->F4_TEXTO  
    TRB4->F4_DTATUALIZ:= DDATABASE
    MsUnlock()
    DbSelectArea("SF4")
    DbSkip()
Enddo
If MV_PAR06 == 1
    DbSelectArea("TRB4")
    DbCloseArea()

    //Copia o arquivo para o diretorio de exportacao

    _cArqEnt4:= cArqtrab4
    _cArqSai4:="\EXP\CADASTRO\"+cArqtrab4
    copy file (_cArqEnt4) to (_cArqSai4)
    ferase(_cArqEnt4)
EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exporta Cadastro Condicoes de Pagamentos                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function GRAVATR5
Static Function GRAVATR5()
DbSelectArea("SE4")
DbSetOrder(1)
DbGoTop()
ProcRegua( LastRec() )
While ! Eof() .AND. MV_PAR05 == 1
    If SE4->E4_CODIGO > "499"
        DbSkip()
        Loop
    EndIF
    DbSelectarea("TRB5")
    Incproc() 
    reclock("TRB5",.t.)
    TRB5->E4_CODIGO   := SE4->E4_CODIGO
    TRB5->E4_DESCRI   := SE4->E4_DESCRI
    TRB5->E4_IPI      := SE4->E4_IPI    
    TRB5->E4_ACRSFIN  := SE4->E4_ACRSFIN
    TRB5->E4_DTATUALIZ:= DDATABASE
    MsUnlock()
    DbSelectArea("SE4")
    DbSkip()
Enddo
If MV_PAR05 == 1
    DbSelectArea("TRB5")
    DbCloseArea()

    //Copia o arquivo para o diretorio de exportacao

    _cArqEnt5:= cArqtrab5
    _cArqSai5:="\EXP\CADASTRO\"+cArqtrab5
    copy file (_cArqEnt5) to (_cArqSai5)
    ferase(_cArqEnt5)
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FCriaTRB ³ Autor ³ Adilson Takeshima     ³ Data ³ 02/02/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cria arquivo que sera exportado                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FCriaTRB()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ COEL                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function fCriaTRB
Static Function fCriaTRB()
DbSelectArea("SA3")
DbSetOrder(1)
Dbseek(xFilial("SA3")+MV_PAR01)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Cadastro de Clientes                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR03 == 1
    sa1 := {}
    Aadd(sa1,{ "A1_COD"       ,"C",06,0 } )
    Aadd(sa1,{ "A1_LOJA"      ,"C",02,0 } )
    Aadd(sa1,{ "A1_NOME"      ,"C",40,0 } )
    Aadd(sa1,{ "A1_NREDUZ"    ,"C",20,0 } )
    Aadd(sa1,{ "A1_DESC"      ,"N",05,2 } )
    Aadd(sa1,{ "A1_CGC"       ,"C",14,0 } )
    Aadd(sa1,{ "A1_INSCR"     ,"C",20,0 } )
    Aadd(sa1,{ "A1_END"       ,"C",50,0 } )
    Aadd(sa1,{ "A1_BAIRRO"    ,"C",20,0 } )
    Aadd(sa1,{ "A1_MUN"       ,"C",25,0 } )
    Aadd(sa1,{ "A1_EST"       ,"C",02,0 } )
    Aadd(sa1,{ "A1_CEP"       ,"C",08,0 } )
    Aadd(sa1,{ "A1_TEL"       ,"C",15,0 } )
    Aadd(sa1,{ "A1_CLTELEF"   ,"C",15,0 } )
    Aadd(sa1,{ "A1_FAX"       ,"C",15,0 } )
    Aadd(sa1,{ "A1_TELEX"     ,"C",10,0 } )
    Aadd(sa1,{ "A1_ENDCOB"    ,"C",50,0 } )
    Aadd(sa1,{ "A1_BAIRROC"   ,"C",20,0 } )
    Aadd(sa1,{ "A1_CLTELCB"   ,"C",15,0 } )
    Aadd(sa1,{ "A1_CLFAXCB"   ,"C",15,0 } )
    Aadd(sa1,{ "A1_MUNC"      ,"C",25,0 } )
    Aadd(sa1,{ "A1_ESTC"      ,"C",02,0 } )
    Aadd(sa1,{ "A1_CEPC"      ,"C",08,0 } )
    Aadd(sa1,{ "A1_ENDENT"    ,"C",50,0 } )
    Aadd(sa1,{ "A1_BAIRROE"   ,"C",20,0 } )
    Aadd(sa1,{ "A1_MUNE"      ,"C",25,0 } )
    Aadd(sa1,{ "A1_ESTE"      ,"C",02,0 } )
    Aadd(sa1,{ "A1_CEPE"      ,"C",08,0 } )
    Aadd(sa1,{ "A1_CLCGCEN"   ,"C",14,0 } )
    Aadd(sa1,{ "A1_CLIEENT"   ,"C",18,0 } )
    Aadd(sa1,{ "A1_CONTATO"   ,"C",15,0 } )
    Aadd(sa1,{ "A1_VEND"      ,"C",06,0 } )
    Aadd(sa1,{ "A1_REGIAO"    ,"C",03,0 } )
    Aadd(sa1,{ "A1_COND"      ,"C",03,0 } )
    Aadd(sa1,{ "A1_TRANSP"    ,"C",06,0 } )
    Aadd(sa1,{ "A1_RISCO"     ,"C",01,0 } )
    Aadd(sa1,{ "A1_TABELA"    ,"C",01,0 } )
    Aadd(sa1,{ "A1_BCO1"      ,"C",03,0 } )
    Aadd(sa1,{ "A1_EMAIL"     ,"C",30,0 } )
    Aadd(sa1,{ "A1_OBSERV"    ,"C",40,0 } )
    Aadd(sa1,{ "A1_DTATUALIZ" ,"D",08,0 } )

    cArqTrab1 := "ICL_"+SA3->A3_PRFX+".DBF"
    DbCreate(cArqTrab1,sa1)
    DbUseArea( .T., , cArqTrab1,"TRB1",.f.,.f.)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Cadastro de Produtos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR02 == 1
    sb1:= {}
    Aadd(sb1,{ "B1_COD"       ,"C",15,0 } )
    Aadd(sb1,{ "B1_PE "       ,"N",03,0 } )
    Aadd(sb1,{ "B1_CLPEVEN"   ,"N",03,0 } )
    Aadd(sb1,{ "B1_COD"       ,"C",15,0 } )
    Aadd(sb1,{ "B1_CLSTATU"   ,"C",01,0 } )
    Aadd(sb1,{ "B1_DESC"      ,"C",30,0 } )
    Aadd(sb1,{ "B5_CEME"      ,"C",200,0 } )
    Aadd(sb1,{ "B1_PICM"      ,"N",05,2 } )
    Aadd(sb1,{ "B1_IPI"       ,"N",05,2 } )
    Aadd(sb1,{ "B1_POSIPI"    ,"C",10,0 } )
    Aadd(sb1,{ "B1_UM"        ,"C",02,0 } )
    Aadd(sb1,{ "B1_PRV1"      ,"N",14,4 } )
    Aadd(sb1,{ "B1_PMIN"      ,"N",14,4 } )
    Aadd(sb1,{ "B1_DTATUALIZ" ,"D",08,0 } )

    cArqTrab2 := "ICD_PROD"+".DBF"
    DbCreate(cArqTrab2,sb1)
    DbUseArea( .T., , cArqTrab2,"TRB2",.f.,.f.)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Cadastro de Transportadoras                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR04 == 1
    sa4 := {}
    Aadd(sa4,{ "A4_COD"       ,"C",06,0 } )
    Aadd(sa4,{ "A4_NOME"      ,"C",40,0 } )
    Aadd(sa4,{ "A4_NREDUZ"    ,"C",20,0 } )
    Aadd(sa4,{ "A4_VIA"       ,"C",15,0 } )
    Aadd(sa4,{ "A4_END"       ,"C",40,0 } )
    Aadd(sa4,{ "A4_CLBAIRR"   ,"C",15,0 } )
    Aadd(sa4,{ "A4_MUN"       ,"C",15,0 } )
    Aadd(sa4,{ "A4_CEP"       ,"C",08,0 } )
    Aadd(sa4,{ "A4_EST"       ,"C",02,0 } )
    Aadd(sa4,{ "A4_CGC"       ,"C",14,0 } )
    Aadd(sa4,{ "A4_TEL"       ,"C",15,0 } )
    Aadd(sa4,{ "A4_CLTEL1"    ,"C",15,0 } )
    Aadd(sa4,{ "A4_CLFAX"     ,"C",15,0 } )
    Aadd(sa4,{ "A4_TELEX"     ,"C",10,0 } )
    Aadd(sa4,{ "A4_CONTATO"   ,"C",15,0 } )
    Aadd(sa4,{ "A4_INSEST"    ,"C",15,0 } )
    Aadd(sa4,{ "A4_EMAIL"     ,"C",30,0 } )
    Aadd(sa4,{ "A4_HPAGE"     ,"C",30,0 } )
    Aadd(sa4,{ "A4_DTATUALIZ" ,"D",08,0 } )

    cArqTrab3 := "ICD_TRAN"+".DBF"
    DbCreate(cArqTrab3,sa4)
    DbUseArea( .T., , cArqTrab3,"TRB3",.f.,.f.)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Cadastro de TES                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR06 == 1
    sf4 := {}
    Aadd(sf4,{ "F4_CODIGO"    ,"C",03,0 } )
    Aadd(sf4,{ "F4_CLFINA"    ,"C",50,0 } )
    Aadd(sf4,{ "F4_TIPO"      ,"C",01,0 } )
    Aadd(sf4,{ "F4_ICM"       ,"C",01,0 } )
    Aadd(sf4,{ "F4_IPI"       ,"C",01,0 } )
    Aadd(sf4,{ "F4_CREDICM"   ,"C",01,0 } )
    Aadd(sf4,{ "F4_CREDIPI"   ,"C",01,0 } )
    Aadd(sf4,{ "F4_DUPLIC"    ,"C",01,0 } )
    Aadd(sf4,{ "F4_ESTOQUE"   ,"C",01,0 } )
    Aadd(sf4,{ "F4_CF"        ,"C",04,0 } )
    Aadd(sf4,{ "F4_TEXTO"     ,"C",20,0 } )
    Aadd(sf4,{ "F4_DTATUALIZ" ,"D",08,0 } )

    cArqTrab4 := "ICD_CTES"+".DBF"
    DbCreate(cArqTrab4,sf4)
    DbUseArea( .T., , cArqTrab4,"TRB4",.f.,.f.)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Condicao de Pagamento                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR05 == 1
    se4 := {}
    Aadd(se4,{ "E4_CODIGO"    ,"C",03,0 } )
    Aadd(se4,{ "E4_DESCRI"    ,"C",15,0 } )
    Aadd(se4,{ "E4_IPI"       ,"C",01,0 } )
    Aadd(se4,{ "E4_ACRSFIN"   ,"N",06,0 } )
    Aadd(se4,{ "E4_DTATUALIZ" ,"D",08,0 } )
    
    cArqTrab5 := "ICD_CNPG"+".DBF"
    DbCreate(cArqTrab5,se4)
    DbUseArea( .T., , cArqTrab5,"TRB5",.f.,.f.)
EndIf
Return
