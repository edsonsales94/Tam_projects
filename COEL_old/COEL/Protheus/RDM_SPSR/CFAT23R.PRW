#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function Cfat23r()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CDESC1,CDESC2,CDESC3,LABORTPRINT,AORD,LIMITE")
SetPrvt("TAMANHO,NTIPO,ARETURN,NLASTKEY,NOMEPROG,CPERG")
SetPrvt("TITULO,NLIN,CSTRING,CBTXT,CBCONT,CONTFL")
SetPrvt("M_PAG,CABEC1,CABEC2,WNREL,_ATEMP,_CCHAVE")
SetPrvt("_CARQTEMP,_CINDTMP,_APROD,_CDESCRICAO,_NQTDE,_NQTDS")
SetPrvt("AREGS,_AALIAS,_I,_J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT23R  ³   Adalberto Moreno Batista    ³ Data ³17.04.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera relatorio estatistico de entradas e saidas de produtos³±±
±±³          ³ em um intervalo de data, sendo escolhido a quebra por grupo³±±
±±³          ³ ou familia de produtos.                                    ³±±
±±³          ³ Serao escolhidos os Tipos de saidas e tipos de entrada a   ³±±
±±³          ³ serem considerados no processamento do relatorio           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico COEL                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
cDesc1      := ""
cDesc1      := cDesc1 + "Gera relatorio estatistico de entradas e saidas de produtos "
cDesc1      := cDesc1 + "acabados em um intervalo de filial e data, sendo escolhido "
cDesc1      := cDesc1 + "a quebra por grupo ou familia de produtos. "
cDesc1      := cDesc1 + "Serao escolhidos os Tipos de saidas e tipos de entrada a "
cDesc1      := cDesc1 + "serem considerados no processamento do relatorio. "
cDesc2      := ""
cDesc3      := ""
lAbortPrint := .F.
aOrd        := {}
limite      := 80
tamanho     := "P"
nTipo       := 18
aReturn     := { "Zebrado", 1, "Administraçäo", 1, 2, 1, "", 1}
nLastKey    := 0
nomeprog    := "CFAT23R"
cPerg       := "CFAT23"
titulo      := "Entradas/Saidas por Grupo/Familia"
nLin        := 80
cString     := "SD1"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para impressao do cabecalho e rodape           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt     := Space(10)
cbcont    := 0
CONTFL    := 1
m_pag     := 1
Cabec1    := "                                   Entradas no       Saidas no        Saldo no"
Cabec2    :=        "   Descricao                    Periodo         Periodo         Periodo"
//             XXXX     xxxxxxxxxxxxxxxxxxxx  999.999.999,99  999.999.999,99  999.999.999,99
//             123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 12
//                      1         2         3         4         5         6         7         8         9         0         1         2         3  

ValidPerg()
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,nomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.f.,Tamanho,,.F.)
If nLastKey == 27
   Return
Endif

if mv_par07 == 1
   Cabec2 := "Grupo  "+Cabec2
else
   Cabec2 := "Familia"+Cabec2
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({|| GeraCurva()},"Gerando estatistica de Entrada e Saidas de Produtos")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({|| Execute(GeraCurva)},"Gerando estatistica de Entrada e Saidas de Produtos")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Impressao                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| ImprRel()},Titulo)// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> RptStatus({|| Execute(ImprRel)},Titulo)
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __Return()
Return        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao³  GeraCurva   ³ Por: Adalberto Moreno Batista ³ Data ³17.04.2001³±±
±±ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function GeraCurva
Static Function GeraCurva()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo Temporaraio  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aTemp := {}
aAdd(_aTemp,{"FAMILIA  ","C",04,0})
aAdd(_aTemp,{"DESCRICAO","C",20,0})
aAdd(_aTemp,{"QTDEE    ","N",12,2})
aAdd(_aTemp,{"QTDES    ","N",12,2})
_cChave   := "FAMILIA+DESCRICAO"
_cArqTemp := CriaTrab(_aTemp,.t.)
_cIndTmp  := CriaTrab(nil,.f.)

dbUseArea(.t.,,_cArqTemp,"TMP")
dbSelectArea("TMP")
IndRegua("TMP",_cIndTmp,_cChave,,,"Criando Indice...")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona os dbsetorder's ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD1")
dbSetOrder(6)

dbSelectArea("SD2")
dbSetOrder(5)

dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SZD")
dbSetOrder(1)

dbSelectArea("SZE")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializando variaveis p/ processamento de relatorio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD1")
ProcRegua(Reccount())

dbSelectArea("SM0")
dbSeek(cEmpAnt+mv_par01,.T.)
do while !eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= mv_par02

   // notas de entrada
   dbSelectArea("SD1")
   dbSeek(SM0->M0_CODFIL+dtos(mv_par03),.T.)
   Do while !Eof() .And. SD1->D1_FILIAL == SM0->M0_CODFIL .and. dtos(SD1->D1_DTDIGIT) <= dtos(mv_par04)

      IncProc()

      //Considerando somente os TES indicados no parametro mv_par05
      If !SD1->D1_TES $ AllTrim(mv_par05)
         dbSkip()
         Loop
      EndIf

      _aProd := GetAdvFVal("SB1",{"B1_TIPO","B1_CLCGRP","B1_CLCFAM"},xFilial("SB1")+SD1->D1_COD,1)
      //Considerar somente produtos acabados
      If _aProd[1] <> "PA"
         dbSkip()
         Loop
      EndIf

      dbSelectArea("TMP")
      if !dbSeek(iif(mv_par07==1,_aProd[2],_aProd[3]))
         RecLock("TMP",.T.)
         if mv_par07 == 1
            _cDescricao    := GetAdvFVal("SZD","ZD_DESCR",xFilial("SZD")+_aProd[2],1,"")
            TMP->FAMILIA   := _aProd[2]
            TMP->DESCRICAO := iif(empty(_cDescricao),"NAO DEFINIDO",_cDescricao)
         else
            _cDescricao    := GetAdvFVal("SZE","ZE_DESCRIC",xFilial("SZE")+_aProd[3],1,"")
            TMP->FAMILIA   := _aProd[3]
            TMP->DESCRICAO := iif(empty(_cDescricao),"NAO DEFINIDO",_cDescricao)
         endif
      else
         RecLock("TMP",.F.)
      endif
      TMP->QTDEE := TMP->QTDEE + SD1->D1_QUANT
      MsUnlock()

      dbSelectArea("SD1")
      dbSkip()
   enddo

   //notas de saida
   dbSelectArea("SD2")
   dbSeek(SM0->M0_CODFIL+dtos(mv_par03),.T.)
   Do while !Eof() .And. SD2->D2_FILIAL == SM0->M0_CODFIL .and. dtos(SD2->D2_EMISSAO) <= dtos(mv_par04)

      IncProc()

      //Considerando somente os TES indicados no parametro mv_par06
      If !SD2->D2_TES $ AllTrim(mv_par06)
         dbSkip()
         Loop
      EndIf

      _aProd := GetAdvFVal("SB1",{"B1_TIPO","B1_CLCGRP","B1_CLCFAM"},xFilial("SB1")+SD2->D2_COD,1)
      //Considerar somente produtos acabados
      If _aProd[1] <> "PA"
         dbSkip()
         Loop
      EndIf

      dbSelectArea("TMP")
      if !dbSeek(iif(mv_par07==1,_aProd[2],_aProd[3]))
         RecLock("TMP",.T.)
         if mv_par07 == 1
            _cDescricao    := GetAdvFVal("SZD","ZD_DESCR",xFilial("SZD")+_aProd[2],1,"")
            TMP->FAMILIA   := _aProd[2]
            TMP->DESCRICAO := iif(empty(_cDescricao),"NAO DEFINIDO",_cDescricao)
         else
            _cDescricao    := GetAdvFVal("SZE","ZE_DESCRIC",xFilial("SZE")+_aProd[3],1,"")
            TMP->FAMILIA   := _aProd[3]
            TMP->DESCRICAO := iif(empty(_cDescricao),"NAO DEFINIDO",_cDescricao)
         endif
      else
         RecLock("TMP",.F.)
      endif
      TMP->QTDES := TMP->QTDES + SD2->D2_QUANT
      MsUnlock()

      dbSelectArea("SD2")
      dbSkip()
   enddo

   dbSelectArea("SM0")
   dbSkip()

Enddo
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __Return()
Return        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao³  Imprime     ³ Por: Adalberto Moreno Batista ³ Data ³20.07.2000³±±
±±ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ImprRel
Static Function ImprRel()

dbSelectArea("SM0")
dbGoTop()

dbSelectArea("TMP")
dbGoTop()
if eof()
   MsgBox("Nao existem dados a serem apresentados!","Atencao","INFO")
else

   SetRegua(Reccount())
   _nQtdE := 0
   _nQtdS := 0
   do while !eof()

      if nlin > 54
         nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
         nlin := nlin + 2
      endif

      IncRegua()

      @ nLin,001 PSAY TMP->FAMILIA
      @ nLin,010 PSAY TMP->DESCRICAO
      @ nLin,032 PSAY TMP->QTDEE            Picture "@E 999,999,999.99"
      @ nLin,048 PSAY TMP->QTDES            Picture "@E 999,999,999.99"
      @ nLin,064 PSAY TMP->(QTDEE-QTDES)    Picture "@E 999,999,999.99"

      _nQtdE := _nQtdE + TMP->QTDEE
      _nQtdS := _nQtdS + TMP->QTDES

      nlin := nlin + 1
      dbSkip()

   enddo

   nlin := nlin + 1
   @ nLin,000 PSAY "Total Geral"
   @ nLin,032 PSAY _nQTDE          Picture "@E 999,999,999.99"
   @ nLin,048 PSAY _nQTDS          Picture "@E 999,999,999.99"
   @ nLin,064 PSAY _nQTDE-_nQTDS   Picture "@E 999,999,999.99"

   Roda(CbCont,CbTxt,tamanho)

   Set device to screen
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Chama o Spool de Impressao para impressoes em Disco                        ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If aReturn[5] == 1
      Set Printer To
      dbCommitAll()
      OurSpool(wnrel)
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Libera o relatorio para Spool da Rede                                      ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   MS_FLUSH()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Fim do Programa                                              ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apagando arquivo temporario e retornando ao alias corrente                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TMP")
dbCloseArea()
If File(_cArqTemp+".DBF")
   Ferase(_cArqTemp+".DBF")
   Ferase(_cIndTmp+OrdBagExt())
EndIf
dbSelectArea("SD1")

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __Return(.t.)
Return(.t.)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao³  ValidPerg   ³ Por: Adalberto Moreno Batista ³ Data ³20.07.2000³±±
±±ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ValidPerg
Static Function ValidPerg()
aRegs   := {}
_aAlias := GetArea()

dbSelectArea("SX1")
dbSetOrder(1)

aAdd(aRegs,{cPerg,"01","Da Filial          ?","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","_M0"})
aAdd(aRegs,{cPerg,"02","Ate a Filial       ?","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","_M0"})
aAdd(aRegs,{cPerg,"03","Da Data Emissao    ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate a Data Emissao ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Tipos de Entrada   ?","mv_ch5","C",30,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Tipos de Saida     ?","mv_ch6","C",30,0,0,"G","","mv_par06","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Emite por          ?","mv_ch7","N",01,0,0,"C","","mv_par07","Grupo","","","Familia","","","","","","","","","","",""})

For _i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[_i,2])
        RecLock("SX1",.T.)
        For _j:=1 to FCount()
            If _j <= Len(aRegs[_i])
                FieldPut(_j,aRegs[_i,_j])
            Endif
        Next
        MsUnlock()
    Endif
Next
RestArea(_aAlias)
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __Return()
Return        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

