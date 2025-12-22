#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 11/09/02

User Function Cqie01i()        // incluido pelo assistente de conversao do AP6 IDE em 11/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPERG,NDIASATRASO,ACAMPOS,CARQTRB,CARQSAI,NHLDSAI")
SetPrvt("XBUFFER,X,AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CQIE01I  ³ Autor ³Ricardo Correa de Souza³ Data ³26/10/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Arquivo Txt para Inspecao de Entrega - Laudo          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Campo Verificado B1_CLTPCQ                                 ³±±
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
* Variaveis Utilizadas no Processamento                                     *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

cPerg       := "QIE01I"
nDiasAtraso := 0

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Parametro                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// mv_par01             Da Data Digitacao     ?
// mv_par02             Ate a Data Digitacao  ?
// mv_par03             Nao Considerar os Tes ?

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos Utilizados no Processamento                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SB1")     //----> Cadastro de Produtos
DbSetOrder(1)           //----> Filial + Codigo

DbSelectArea("SC7")     //----> Pedido de Compras
DbSetOrder(1)           //----> Filial + Pedido + Item + Sequencia

DbSelectArea("SD1")     //----> Itens de Nota Fiscal de Entrada
DbSetOrder(6)           //----> Filial + Data de Digitacao + Sequencia

DbSelectArea("SF1")     //----> Cabecalho de Nota Fiscal de Entrada
DbSetOrder(1)           //----> Filial + Nota + Serie

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivo Temporario - Estrutura Arquivo Texto                              *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

aCampos := {}

Aadd(aCampos,{ "FORNEC","C",06,0 })
Aadd(aCampos,{ "LOJA  ","C",02,0 })
Aadd(aCampos,{ "PROD  ","C",15,0 })
Aadd(aCampos,{ "DTENTR","C",08,0 })
Aadd(aCampos,{ "HRENTR","C",05,0 })
Aadd(aCampos,{ "LOTE  ","C",15,0 })
Aadd(aCampos,{ "DOCENT","C",15,0 })
Aadd(aCampos,{ "TAMLOT","C",08,0 })
Aadd(aCampos,{ "TAMAMO","C",08,0 })
Aadd(aCampos,{ "NUMPED","C",10,0 })
Aadd(aCampos,{ "NUMNF ","C",12,0 })
Aadd(aCampos,{ "SERINF","C",03,0 })
Aadd(aCampos,{ "DTEMIS","C",08,0 })
Aadd(aCampos,{ "TIPDOC","C",06,0 })
Aadd(aCampos,{ "CERTIF","C",12,0 })
Aadd(aCampos,{ "ATRASO","C",04,0 })
Aadd(aCampos,{ "SOLIC ","C",06,0 })
Aadd(aCampos,{ "PRECO ","C",12,0 })
Aadd(aCampos,{ "EXCENT","C",01,0 })

cArqTrb :="CELER"+".DBF"

DbCreate(cArqTrb,aCampos)

//DbUseArea(.t.,__cRdd,cArqTrb,"TRB",If(.t. .Or. .f., !.f.,Nil), .f.)
DbUseArea(.t.,,cArqTrb,"TRB",Nil, .f.)

//----> se for filial sao paulo
If SM0->M0_CODFIL == "01"
    cArqSai := "ARQIMPSP"+".TXT"
Else
    cArqSai := "ARQIMPSR"+".TXT"
EndIf
Fcreate(cArqSai)

nHldSai := Fopen(cArqSai,1)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

ValidPerg()     //----> cria o grupo de perguntas no arquivo SX1

//----> verifica se o usuario cancelou o parametro
If ! Pergunte(cPerg,.t.)
// Substituido pelo assistente de conversao do AP6 IDE em 11/09/02 ==>     __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 11/09/02
EndIf

Processa({||GeraTxt()},"Arquivo Texto - Inspecao de Entrega")// Substituido pelo assistente de conversao do AP6 IDE em 11/09/02 ==> Processa({||Execute(GeraTxt)},"Arquivo Texto - Inspecao de Entrega")
// Substituido pelo assistente de conversao do AP6 IDE em 11/09/02 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 11/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 11/09/02 ==> Function GeraTxt
Static Function GeraTxt()

DbSelectArea("SD1")
DbSetOrder(6)
DbSeek(xFilial("SD1")+Dtos(mv_par01),.t.)

ProcRegua(LastRec())

While Eof() == .f.  .And. SD1->D1_FILIAL == xFilial("SD1") .And. SD1->D1_DTDIGIT <= mv_par02 

    IncProc("Selecionando Dados Nota Fiscal "+SD1->D1_DOC+"/"+SD1->D1_SERIE)

    If SD1->D1_DTDIGIT > mv_par02
        DbSelectArea("SD1")
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SB1")
    DbSeek(xFilial("SB1")+SD1->D1_COD)

    //----> verificando se o produto deve ser inspecionado
    If ! SB1->B1_CLTPCQ $ "Q"
        DbSelectArea("SD1")
        DbSkip()
        Loop
    EndIf

    //----> filtrando apenas o intervalo de tes selecionado nos parametros
    If ! SD1->D1_TES $ Alltrim(mv_par03)
        DbSelectArea("SD1")
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SF1")
    DbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)

    DbSelectArea("SC7")
    If DbSeek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC)
        nDiasAtraso := SD1->D1_DTDIGIT - SC7->C7_DATPRF
    Else
        nDiasAtraso := 0
    EndIf

    DbSelectArea("TRB")
    RecLock("TRB",.t.)
      TRB->FORNEC   :=  SD1->D1_FORNECE
      TRB->LOJA     :=  SD1->D1_LOJA
      TRB->PROD     :=  SD1->D1_COD
      TRB->DTENTR   :=  Dtos(SD1->D1_DTDIGIT)
      TRB->HRENTR   :=  SF1->F1_HORA
      TRB->LOTE     :=  SD1->D1_LOTEFOR
      TRB->DOCENT   :=  Space(15)
      TRB->TAMLOT   :=  StrZero(SD1->D1_QUANT,8)
      TRB->TAMAMO   :=  StrZero(SD1->D1_QUANT,8)
      TRB->NUMPED   :=  SD1->D1_PEDIDO
      TRB->NUMNF    :=  SD1->D1_DOC
      TRB->SERINF   :=  SD1->D1_SERIE
      TRB->DTEMIS   :=  Dtos(SD1->D1_EMISSAO)
      TRB->TIPDOC   :=  "NF    "
      TRB->CERTIF   :=  Space(12)
      TRB->ATRASO   :=  StrZero(nDiasAtraso,4)
      TRB->SOLIC    :=  Space(06)
      TRB->PRECO    :=  StrZero(SD1->D1_VUNIT,12)
      TRB->EXCENT   :=  "N"
    MsUnLock()

    //----> gravando dados no arquivo texto

    xBuffer := ""

    For x:= 1 to Fcount()
        xBuffer := xBuffer + FieldGet(x)
    Next x

    xBuffer := xBuffer+Chr(13)+Chr(10)
    Fwrite(nHldSai , xBuffer)

    DbSelectArea("SD1")
    DbSkip()

EndDo

Fclose(nHldSai)

DbSelectArea("TRB")
DbCloseArea("TRB")

Ferase(cArqTrb+".DBF")

MsgBox("Arquivo Texto Gerado com Sucesso","Informacao","Info")

// Substituido pelo assistente de conversao do AP6 IDE em 11/09/02 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 11/09/02

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Criacao do Grupo de Perguntas                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 11/09/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)

aRegs :={}

Aadd(aRegs,{cPerg,"01","Da Data de Digitacao    ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Ate a Data de Digitacao ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Considerar os Tes       ?","","","mv_ch3","C",30,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})

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

// Substituido pelo assistente de conversao do AP6 IDE em 11/09/02 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 11/09/02

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim da Funcao                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
