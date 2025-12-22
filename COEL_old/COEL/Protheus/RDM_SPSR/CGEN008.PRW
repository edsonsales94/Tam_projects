#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function CGEN008()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPATH,CEMP,CEXT,AESTRUT,CARQTRB,CINDEX")
SetPrvt("CCHAVE,CALIAS,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CGEN008  ³ Autor ³Ricardo Correa de Souza³ Data ³26/09/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Arquivo para Controle de Uso dos Produtos nas Tabelas ³±±
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

cPath   := "\SIGA\DADOSADV\"
cEmp    := cEmpAnt+"0"
cExt    := ".DBF"
aEstrut := {}
cArqTrb := "PRODALIA" + ".DBF"

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Aadd(aEstrut,{ "CODIGO"     ,"C",15,0 } )
Aadd(aEstrut,{ "DESC"       ,"C",30,0 } )
Aadd(aEstrut,{ "ALIAS01"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS02"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS03"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS04"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS05"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS06"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS07"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS08"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS09"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS10"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS11"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS12"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS13"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS14"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS15"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS16"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS17"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS18"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS19"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS20"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS21"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS22"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS23"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS24"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS25"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS26"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS27"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS28"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS29"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS30"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS31"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS32"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS33"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS34"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS35"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS36"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS37"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS38"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS39"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS40"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS41"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS42"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS43"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS44"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS45"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS46"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS47"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS48"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS49"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS50"    ,"C",03,0 } )
Aadd(aEstrut,{ "ALIAS51"    ,"C",03,0 } )

DbCreate(cArqTrb, aEstrut)
DbUseArea(.T.,,cArqTrb,"TRB",.F.,.F.)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({|| RunProc()},"Gerando Arquivo dos Produtos em Uso")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({|| Execute(RunProc)},"Gerando Arquivo dos Produtos em Uso")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("TRB")
cIndex := CriaTrab(Nil,.f.)
cChave := "TRB->CODIGO"

IndRegua("TRB",cIndex,cChave,,,"Indexando Arquivo por Codigo")

DbSelectArea("SB1")
DbSetOrder(1)
DbGoTop()

//----> Amarracao Produto x Fornecedor
DbSelectArea("SA5")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SA5->A5_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SA5->A5_PRODUTO)
            RecLock("TRB",.f.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS01  :=  "SA5"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS01  :=  "SA5"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SA5")
    DbSkip()
Enddo

//----> Amarracao Produto x Cliente
DbSelectArea("SA7")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SA7->A7_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SA7->A7_PRODUTO)
            RecLock("TRB",.f.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS02  :=  "SA7"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS02  :=  "SA7"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SA7")
    DbSkip()
Enddo

//----> Amarracao Produto x Versao
cAlias := "SAC"
If File(cPath+cAlias+cEmp+cExt)
    DbUseArea(.T.,,cPath+cAlias+cEmp+cExt,cAlias,.F.,.F.)

    DbSelectArea("SAC")
    DbSetOrder(0)
    DbGoTop()
    ProcRegua(Reccount())

    While !Eof()

        IncProc("Atualizando Arquivo : "+Alias())
    
        DbSelectArea("SB1")
        //----> verificando se o produto existe no SB1
        If DbSeek(xfilial("SB1")+SAC->AC_PRODUTO)
            DbSelectArea("TRB")
            //----> verificando se o produto ja esta gravado no arquivo gerado
            If DbSeek(SAC->AC_PRODUTO)
                RecLock("TRB",.f.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS03  :=  "SAC"
                DbUnLock()
            Else
                RecLock("TRB",.t.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS03  :=  "SAC"
                DbUnLock()
            EndIf
        Endif
        DbSelectArea("SAC")
        DbSkip()
    Enddo
    DbCloseArea(cAlias)
Endif

//----> Cadastro de Solicitantes
cAlias := "SAI"
If File(cPath+cAlias+cEmp+cExt)
    DbUseArea(.T.,,cPath+cAlias+cEmp+cExt,cAlias,.F.,.F.)

    DbSelectArea("SAI")
    DbSetOrder(0)
    DbGoTop()
    ProcRegua(Reccount())

    While !Eof()

        IncProc("Atualizando Arquivo : "+Alias())
    
        DbSelectArea("SB1")
        //----> verificando se o produto existe no SB1
        If DbSeek(xfilial("SB1")+SAI->AI_PRODUTO)
            DbSelectArea("TRB")
            //----> verificando se o produto ja esta gravado no arquivo gerado
            If DbSeek(SAI->AI_PRODUTO)
                RecLock("TRB",.f.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS04  :=  "SAI"
                DbUnLock()
            Else
                RecLock("TRB",.t.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS04  :=  "SAI"
                DbUnLock()
            EndIf
        Endif
        DbSelectArea("SAI")
        DbSkip()
    Enddo
    DbCloseArea(cAlias)
Endif

//----> Posicao de Estoques             
DbSelectArea("SB2")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SB2->B2_COD)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SB2->B2_COD)
            RecLock("TRB",.f.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS05  :=  "SB2"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS05  :=  "SB2"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SB2")
    DbSkip()
Enddo

//----> Demandas
DbSelectArea("SB3")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SB3->B3_COD)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SB3->B3_COD)
            RecLock("TRB",.f.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS06  :=  "SB3"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS06  :=  "SB3"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SB3")
    DbSkip()
Enddo

//----> Referencias de Grade do Produto
DbSelectArea("SB4")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SB4->B4_COD)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SB4->B4_COD)
            RecLock("TRB",.f.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS07  :=  "SB4"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS07  :=  "SB4"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SB4")
    DbSkip()
Enddo

//----> Dados Adicionais de Produtos
DbSelectArea("SB5")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SB5->B5_COD)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SB5->B5_COD)
            RecLock("TRB",.f.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS08  :=  "SB5"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS08  :=  "SB5"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SB5")
    DbSkip()
Enddo

//----> Estoque em Poder De/Em Terceiros
DbSelectArea("SB6")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SB6->B6_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SB6->B6_PRODUTO)
            RecLock("TRB",.f.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS09  :=  "SB6"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS09  :=  "SB6"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SB6")
    DbSkip()
Enddo

//----> Inventario
cAlias := "SB7"
If File(cPath+cAlias+cEmp+cExt)
    DbUseArea(.T.,,cPath+cAlias+cEmp+cExt,cAlias,.F.,.F.)

    DbSelectArea("SB7")
    DbSetOrder(0)
    DbGoTop()
    ProcRegua(Reccount())

    While !Eof()

        IncProc("Atualizando Arquivo : "+Alias())
    
        DbSelectArea("SB1")
        //----> verificando se o produto existe no SB1
        If DbSeek(xfilial("SB1")+SB7->B7_COD)
            DbSelectArea("TRB")
            //----> verificando se o produto ja esta gravado no arquivo gerado
            If DbSeek(SB7->B7_COD)
                RecLock("TRB",.f.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS10  :=  "SB7"
                DbUnLock()
            Else
                RecLock("TRB",.t.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS10  :=  "SB7"
                DbUnLock()
            EndIf
        Endif
        DbSelectArea("SB7")
        DbSkip()
    Enddo
    DbCloseArea(cAlias)
Endif

//----> Controle de Lotes
DbSelectArea("SB8")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SB8->B8_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SB8->B8_PRODUTO)
            RecLock("TRB",.f.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS11  :=  "SB8"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS11  :=  "SB8"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SB8")
    DbSkip()
Enddo

//----> Saldos Iniciais
DbSelectArea("SB9")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SB9->B9_COD)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SB9->B9_COD)
            RecLock("TRB",.f.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS12  :=  "SB9"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS12  :=  "SB9"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SB9")
    DbSkip()
Enddo

//----> Perdas por Ordem de Producao
cAlias := "SBC"
If File(cPath+cAlias+cEmp+cExt)
    DbUseArea(.T.,,cPath+cAlias+cEmp+cExt,cAlias,.F.,.F.)

    DbSelectArea("SBC")
    DbSetOrder(0)
    DbGoTop()
    ProcRegua(Reccount())

    While !Eof()

        IncProc("Atualizando Arquivo : "+Alias())
    
        DbSelectArea("SB1")
        //----> verificando se o produto existe no SB1
        If DbSeek(xfilial("SB1")+SBC->BC_PRODUTO)
            DbSelectArea("TRB")
            //----> verificando se o produto ja esta gravado no arquivo gerado
            If DbSeek(SBC->BC_PRODUTO)
                RecLock("TRB",.f.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS13  :=  "SBC"
                DbUnLock()
            Else
                RecLock("TRB",.t.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS13  :=  "SBC"
                DbUnLock()
            EndIf
        Endif
        DbSelectArea("SBC")
        DbSkip()
    Enddo
    DbCloseArea(cAlias)
Endif

//----> Estoques por Lote Fifo
cAlias := "SBD"
If File(cPath+cAlias+cEmp+cExt)
    DbUseArea(.T.,,cPath+cAlias+cEmp+cExt,cAlias,.F.,.F.)

    DbSelectArea("SBD")
    DbSetOrder(0)
    DbGoTop()
    ProcRegua(Reccount())

    While !Eof()

        IncProc("Atualizando Arquivo : "+Alias())
    
        DbSelectArea("SB1")
        //----> verificando se o produto existe no SB1
        If DbSeek(xfilial("SB1")+SBD->BD_PRODUTO)
            DbSelectArea("TRB")
            //----> verificando se o produto ja esta gravado no arquivo gerado
            If DbSeek(SBD->BD_PRODUTO)
                RecLock("TRB",.f.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS14  :=  "SBD"
                DbUnLock()
            Else
                RecLock("TRB",.t.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS14  :=  "SBD"
                DbUnLock()
            EndIf
        Endif
        DbSelectArea("SBD")
        DbSkip()
    Enddo
    DbCloseArea(cAlias)
Endif

//----> Estoques por Localizacao Fisica
cAlias := "SBF"
If File(cPath+cAlias+cEmp+cExt)
    DbUseArea(.T.,,cPath+cAlias+cEmp+cExt,cAlias,.F.,.F.)

    DbSelectArea("SBF")
    DbSetOrder(0)
    DbGoTop()
    ProcRegua(Reccount())

    While !Eof()

        IncProc("Atualizando Arquivo : "+Alias())
    
        DbSelectArea("SB1")
        //----> verificando se o produto existe no SB1
        If DbSeek(xfilial("SB1")+SBF->BF_PRODUTO)
            DbSelectArea("TRB")
            //----> verificando se o produto ja esta gravado no arquivo gerado
            If DbSeek(SBF->BF_PRODUTO)
                RecLock("TRB",.f.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS15  :=  "SBF"
                DbUnLock()
            Else
                RecLock("TRB",.t.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS15  :=  "SBF"
                DbUnLock()
            EndIf
        Endif
        DbSelectArea("SBF")
        DbSkip()
    Enddo
    DbCloseArea(cAlias)
Endif

//----> Sugestao de Orcamento
DbSelectArea("SBG")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SBG->BG_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SBG->BG_PRODUTO)
            RecLock("TRB",.f.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS16  :=  "SBG"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS16  :=  "SBG"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SBG")
    DbSkip()
Enddo

//----> Itens de Sugestao de Orcamento
DbSelectArea("SBH")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SBH->BH_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SBH->BH_PRODUTO)
            RecLock("TRB",.f.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS17  :=  "SBH"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS17  :=  "SBH"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SBH")
    DbSkip()
Enddo

//----> Produtos x Precos
cAlias := "SBI"
If File(cPath+cAlias+cEmp+cExt)
    DbUseArea(.T.,,cPath+cAlias+cEmp+cExt,cAlias,.F.,.F.)

    DbSelectArea("SBI")
    DbSetOrder(0)
    DbGoTop()
    ProcRegua(Reccount())

    While !Eof()

        IncProc("Atualizando Arquivo : "+Alias())
    
        DbSelectArea("SB1")
        //----> verificando se o produto existe no SB1
        If DbSeek(xfilial("SB1")+SBI->BI_COD)
            DbSelectArea("TRB")
            //----> verificando se o produto ja esta gravado no arquivo gerado
            If DbSeek(SBI->BI_COD)
                RecLock("TRB",.f.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS18  :=  "SBI"
                DbUnLock()
            Else
                RecLock("TRB",.t.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS18  :=  "SBI"
                DbUnLock()
            EndIf
        Endif
        DbSelectArea("SBI")
        DbSkip()
    Enddo
    DbCloseArea(cAlias)
Endif

//----> Reservas para Faturamento
DbSelectArea("SC0")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SC0->C0_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SC0->C0_PRODUTO)
            RecLock("TRB",.f.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS19  :=  "SC0"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS19  :=  "SC0"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SC0")
    DbSkip()
Enddo

//----> Solicitacao de Compras
DbSelectArea("SC1")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SC1->C1_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SC1->C1_PRODUTO)
            RecLock("TRB",.f.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS20  :=  "SC1"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS20  :=  "SC1"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SC1")
    DbSkip()
Enddo

//----> Ordens de Producao
DbSelectArea("SC2")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SC2->C2_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SC2->C2_PRODUTO)
            RecLock("TRB",.f.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS21  :=  "SC2"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS21  :=  "SC2"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SC2")
    DbSkip()
Enddo

//----> Contratos de Parceria
DbSelectArea("SC3")
DbSetOrder(0)
DbGoTop()

ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SC3->C3_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SC3->C3_PRODUTO)
            RecLock("TRB",.f.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS22  :=  "SC3"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS22  :=  "SC3"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SC3")
    DbSkip()
Enddo

//----> Previsoes de Vendas
DbSelectArea("SC4")
DbSetOrder(0)
DbGoTop()

ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SC4->C4_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SC4->C4_PRODUTO)
            RecLock("TRB",.f.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS23  :=  "SC4"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS23  :=  "SC4"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SC4")
    DbSkip()
Enddo

//----> Itens de Pedido de Vendas
DbSelectArea("SC6")
DbSetOrder(0)
DbGoTop()

ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SC6->C6_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SC6->C6_PRODUTO)
            RecLock("TRB",.f.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS24  :=  "SC6"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS24  :=  "SC6"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SC6")
    DbSkip()
Enddo

//----> Pedidos de Compras
DbSelectArea("SC7")
DbSetOrder(0)
DbGoTop()

ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SC7->C7_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SC7->C7_PRODUTO)
            RecLock("TRB",.f.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS25  :=  "SC7"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS25  :=  "SC7"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SC7")
    DbSkip()
Enddo

//----> Cotacoes
DbSelectArea("SC8")
DbSetOrder(0)
DbGoTop()

ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SC8->C8_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SC8->C8_PRODUTO)
            RecLock("TRB",.f.)
              TRB->ALIAS26  :=  "SC8"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS26  :=  "SC8"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SC8")
    DbSkip()
Enddo

//----> Pedidos de Vendas Liberados
DbSelectArea("SC9")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SC9->C9_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SC9->C9_PRODUTO)
            RecLock("TRB",.f.)
              TRB->ALIAS27  :=  "SC9"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS27  :=  "SC9"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SC9")
    DbSkip()
Enddo

//----> Encerramento de Cotacoes
cAlias := "SCE"
If File(cPath+cAlias+cEmp+cExt)
    DbUseArea(.T.,,cPath+cAlias+cEmp+cExt,cAlias,.F.,.F.)

    DbSelectArea("SCE")
    DbSetOrder(0)
    DbGoTop()
    ProcRegua(Reccount())

    While !Eof()

        IncProc("Atualizando Arquivo : "+Alias())
    
        DbSelectArea("SB1")
        //----> verificando se o produto existe no SB1
        If DbSeek(xfilial("SB1")+SCE->CE_PRODUTO)
            DbSelectArea("TRB")
            //----> verificando se o produto ja esta gravado no arquivo gerado
            If DbSeek(SCE->CE_PRODUTO)
                RecLock("TRB",.f.)
                  TRB->ALIAS28  :=  "SCE"
                DbUnLock()
            Else
                RecLock("TRB",.t.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS28  :=  "SCE"
                DbUnLock()
            EndIf
        Endif
        DbSelectArea("SCE")
        DbSkip()
    Enddo
    DbCloseArea(cAlias)
Endif

//----> Itens de Orcamento Sugestao
cAlias := "SCL"
If File(cPath+cAlias+cEmp+cExt)
    DbUseArea(.T.,,cPath+cAlias+cEmp+cExt,cAlias,.F.,.F.)

    DbSelectArea("SCL")
    DbSetOrder(0)
    DbGoTop()
    ProcRegua(Reccount())

    While !Eof()

        IncProc("Atualizando Arquivo : "+Alias())
    
        DbSelectArea("SB1")
        //----> verificando se o produto existe no SB1
        If DbSeek(xfilial("SB1")+SCL->CL_PRODUTO)
            DbSelectArea("TRB")
            //----> verificando se o produto ja esta gravado no arquivo gerado
            If DbSeek(SCL->CL_PRODUTO)
                RecLock("TRB",.f.)
                  TRB->ALIAS29  :=  "SCL"
                DbUnLock()
            Else
                RecLock("TRB",.t.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS29  :=  "SCL"
                DbUnLock()
            EndIf
        Endif
        DbSelectArea("SCL")
        DbSkip()
    Enddo
    DbCloseArea(cAlias)
Endif

//----> Solicitacoes ao Almoxarifado
DbSelectArea("SCP")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SCP->CP_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SCP->CP_PRODUTO)
            RecLock("TRB",.f.)
              TRB->ALIAS30  :=  "SCP"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS30  :=  "SCP"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SCP")
    DbSkip()
Enddo

//----> Pre-Requisicoes
DbSelectArea("SCQ")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SCQ->CQ_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SCQ->CQ_PRODUTO)
            RecLock("TRB",.f.)
              TRB->ALIAS31  :=  "SCQ"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS31  :=  "SCQ"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SCQ")
    DbSkip()
Enddo

//----> Itens de Entrada Nota Fiscal
DbSelectArea("SD1")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SD1->D1_COD)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SD1->D1_COD)
            RecLock("TRB",.f.)
              TRB->ALIAS32  :=  "SD1"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS32  :=  "SD1"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SD1")
    DbSkip()
Enddo

//----> Itens de Saida Nota Fiscal
DbSelectArea("SD2")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SD2->D2_COD)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SD2->D2_COD)
            RecLock("TRB",.f.)
              TRB->ALIAS33  :=  "SD2"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS33  :=  "SD2"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SD2")
    DbSkip()
Enddo

//----> Movimentos Internos
DbSelectArea("SD3")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SD3->D3_COD)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SD3->D3_COD)
            RecLock("TRB",.f.)
              TRB->ALIAS34  :=  "SD3"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS34  :=  "SD3"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SD3")
    DbSkip()
Enddo

//----> Empenhos
DbSelectArea("SD4")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SD4->D4_COD)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SD4->D4_COD)
            RecLock("TRB",.f.)
              TRB->ALIAS35  :=  "SD4"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS35  :=  "SD4"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SD4")
    DbSkip()
Enddo

//----> Requisicoes por Lote
DbSelectArea("SD5")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SD5->D5_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SD5->D5_PRODUTO)
            RecLock("TRB",.f.)
              TRB->ALIAS36  :=  "SD5"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS36  :=  "SD5"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SD5")
    DbSkip()
Enddo

//----> Itens do Contrato
cAlias := "SD6"
If File(cPath+cAlias+cEmp+cExt)
    DbUseArea(.T.,,cPath+cAlias+cEmp+cExt,cAlias,.F.,.F.)

    DbSelectArea("SD6")
    DbSetOrder(0)
    DbGoTop()
    ProcRegua(Reccount())

    While !Eof()

        IncProc("Atualizando Arquivo : "+Alias())
    
        DbSelectArea("SB1")
        //----> verificando se o produto existe no SB1
        If DbSeek(xfilial("SB1")+SD6->D6_PRODUTO)
            DbSelectArea("TRB")
            //----> verificando se o produto ja esta gravado no arquivo gerado
            If DbSeek(SD6->D6_PRODUTO)
                RecLock("TRB",.f.)
                  TRB->ALIAS37  :=  "SD6"
                DbUnLock()
            Else
                RecLock("TRB",.t.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS37  :=  "SD6"
                DbUnLock()
            EndIf
        Endif
        DbSelectArea("SD6")
        DbSkip()
    Enddo
    DbCloseArea(cAlias)
Endif

//----> Transferencias para CQ
DbSelectArea("SD7")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SD7->D7_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SD7->D7_PRODUTO)
            RecLock("TRB",.f.)
              TRB->ALIAS38  :=  "SD7"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS38  :=  "SD7"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SD7")
    DbSkip()
Enddo

//----> Movimentos Fifo
cAlias := "SD8"
If File(cPath+cAlias+cEmp+cExt)
    DbUseArea(.T.,,cPath+cAlias+cEmp+cExt,cAlias,.F.,.F.)

    DbSelectArea("SD8")
    DbSetOrder(0)
    DbGoTop()
    ProcRegua(Reccount())

    While !Eof()

        IncProc("Atualizando Arquivo : "+Alias())
    
        DbSelectArea("SB1")
        //----> verificando se o produto existe no SB1
        If DbSeek(xfilial("SB1")+SD8->D8_PRODUTO)
            DbSelectArea("TRB")
            //----> verificando se o produto ja esta gravado no arquivo gerado
            If DbSeek(SD8->D8_PRODUTO)
                RecLock("TRB",.f.)
                  TRB->ALIAS39  :=  "SD8"
                DbUnLock()
            Else
                RecLock("TRB",.t.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS39  :=  "SD8"
                DbUnLock()
            EndIf
        Endif
        DbSelectArea("SD8")
        DbSkip()
    Enddo
    DbCloseArea(cAlias)
Endif

//----> Saldos a Distribuir (Localizacao Fisica)
DbSelectArea("SDA")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SDA->DA_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SDA->DA_PRODUTO)
            RecLock("TRB",.f.)
              TRB->ALIAS40  :=  "SDA"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS40  :=  "SDA"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SDA")
    DbSkip()
Enddo

//----> Movimento de Distribuicao (Localizacao Fisica)
DbSelectArea("SDB")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SDB->DB_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SDB->DB_PRODUTO)
            RecLock("TRB",.f.)
              TRB->ALIAS41  :=  "SDB"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS41  :=  "SDB"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SDB")
    DbSkip()
Enddo

//----> Composicao do Empenho
cAlias := "SDC"
If File(cPath+cAlias+cEmp+cExt)
    DbUseArea(.T.,,cPath+cAlias+cEmp+cExt,cAlias,.F.,.F.)

    DbSelectArea("SDC")
    DbSetOrder(0)
    DbGoTop()
    ProcRegua(Reccount())

    While !Eof()

        IncProc("Atualizando Arquivo : "+Alias())
    
        DbSelectArea("SB1")
        //----> verificando se o produto existe no SB1
        If DbSeek(xfilial("SB1")+SDC->DC_PRODUTO)
            DbSelectArea("TRB")
            //----> verificando se o produto ja esta gravado no arquivo gerado
            If DbSeek(SDC->DC_PRODUTO)
                RecLock("TRB",.f.)
                  TRB->ALIAS42  :=  "SDC"
                DbUnLock()
            Else
                RecLock("TRB",.t.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS42  :=  "SDC"
                DbUnLock()
            EndIf
        Endif
        DbSelectArea("SDC")
        DbSkip()
    Enddo
    DbCloseArea(cAlias)
Endif

//----> Bloqueios de Lotes
DbSelectArea("SDD")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SDD->DD_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SDD->DD_PRODUTO)
            RecLock("TRB",.f.)
              TRB->ALIAS43  :=  "SDD"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS43  :=  "SDD"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SDD")
    DbSkip()
Enddo

//----> Estrutura de Produtos
DbSelectArea("SG1")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SG1->G1_COD)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SG1->G1_COD)
            RecLock("TRB",.f.)
              TRB->ALIAS44  :=  "SG1"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS44  :=  "SG1"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SG1")
    DbSkip()
Enddo

//----> Roteiro de Operacoes
DbSelectArea("SG2")
DbSetOrder(0)
DbGoTop()
ProcRegua(Reccount())

While !Eof()

    IncProc("Atualizando Arquivo : "+Alias())

    DbSelectArea("SB1")
    //----> verificando se o produto existe no SB1
    If DbSeek(xfilial("SB1")+SG2->G2_PRODUTO)
        DbSelectArea("TRB")
        //----> verificando se o produto ja esta gravado no arquivo gerado
        If DbSeek(SG2->G2_PRODUTO)
            RecLock("TRB",.f.)
              TRB->ALIAS45  :=  "SG2"
            DbUnLock()
        Else
            RecLock("TRB",.t.)
              TRB->CODIGO   :=  SB1->B1_COD
              TRB->DESC     :=  SB1->B1_DESC
              TRB->ALIAS45  :=  "SG2"
            DbUnLock()
        EndIf
    Endif
    DbSelectArea("SG2")
    DbSkip()
Enddo

//----> Composicao Seletiva do Produto
cAlias := "SG4"
If File(cPath+cAlias+cEmp+cExt)
    DbUseArea(.T.,,cPath+cAlias+cEmp+cExt,cAlias,.F.,.F.)

    DbSelectArea("SG4")
    DbSetOrder(0)
    DbGoTop()
    ProcRegua(Reccount())

    While !Eof()

        IncProc("Atualizando Arquivo : "+Alias())
    
        DbSelectArea("SB1")
        //----> verificando se o produto existe no SB1
        If DbSeek(xfilial("SB1")+SG4->G4_CODIGO)
            DbSelectArea("TRB")
            //----> verificando se o produto ja esta gravado no arquivo gerado
            If DbSeek(SG4->G4_CODIGO)
                RecLock("TRB",.f.)
                  TRB->ALIAS46  :=  "SG4"
                DbUnLock()
            Else
                RecLock("TRB",.t.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS46  :=  "SG4"
                DbUnLock()
            EndIf
        Endif
        DbSelectArea("SG4")
        DbSkip()
    Enddo
    DbCloseArea(cAlias)
Endif

//----> Revisoes de Estruturas
cAlias := "SG5"
If File(cPath+cAlias+cEmp+cExt)
    DbUseArea(.T.,,cPath+cAlias+cEmp+cExt,cAlias,.F.,.F.)

    DbSelectArea("SG5")
    DbSetOrder(0)
    DbGoTop()
    ProcRegua(Reccount())

    While !Eof()

        IncProc("Atualizando Arquivo : "+Alias())
    
        DbSelectArea("SB1")
        //----> verificando se o produto existe no SB1
        If DbSeek(xfilial("SB1")+SG5->G5_PRODUTO)
            DbSelectArea("TRB")
            //----> verificando se o produto ja esta gravado no arquivo gerado
            If DbSeek(SG5->G5_PRODUTO)
                RecLock("TRB",.f.)
                  TRB->ALIAS47  :=  "SG5"
                DbUnLock()
            Else
                RecLock("TRB",.t.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS47  :=  "SG5"
                DbUnLock()
            EndIf
        Endif
        DbSelectArea("SG5")
        DbSkip()
    Enddo
    DbCloseArea(cAlias)
Endif

//----> Recursos e Ferramentas por Operacao
cAlias := "SH3"
If File(cPath+cAlias+cEmp+cExt)
    DbUseArea(.T.,,cPath+cAlias+cEmp+cExt,cAlias,.F.,.F.)

    DbSelectArea("SH3")
    DbSetOrder(0)
    DbGoTop()
    ProcRegua(Reccount())

    While !Eof()

        IncProc("Atualizando Arquivo : "+Alias())
    
        DbSelectArea("SB1")
        //----> verificando se o produto existe no SB1
        If DbSeek(xfilial("SB1")+SH3->H3_PRODUTO)
            DbSelectArea("TRB")
            //----> verificando se o produto ja esta gravado no arquivo gerado
            If DbSeek(SH3->H3_PRODUTO)
                RecLock("TRB",.f.)
                  TRB->ALIAS48  :=  "SH3"
                DbUnLock()
            Else
                RecLock("TRB",.t.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS48  :=  "SH3"
                DbUnLock()
            EndIf
        Endif
        DbSelectArea("SH3")
        DbSkip()
    Enddo
    DbCloseArea(cAlias)
Endif

//----> Movimentacao da Producao
cAlias := "SH6"
If File(cPath+cAlias+cEmp+cExt)
    DbUseArea(.T.,,cPath+cAlias+cEmp+cExt,cAlias,.F.,.F.)

    DbSelectArea("SH6")
    DbSetOrder(0)
    DbGoTop()
    ProcRegua(Reccount())

    While !Eof()

        IncProc("Atualizando Arquivo : "+Alias())
    
        DbSelectArea("SB1")
        //----> verificando se o produto existe no SB1
        If DbSeek(xfilial("SB1")+SH6->H6_PRODUTO)
            DbSelectArea("TRB")
            //----> verificando se o produto ja esta gravado no arquivo gerado
            If DbSeek(SH6->H6_PRODUTO)
                RecLock("TRB",.f.)
                  TRB->ALIAS49  :=  "SH6"
                DbUnLock()
            Else
                RecLock("TRB",.t.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS49  :=  "SH6"
                DbUnLock()
            EndIf
        Endif
        DbSelectArea("SH6")
        DbSkip()
    Enddo
    DbCloseArea(cAlias)
Endif

//----> Plano Mestre de Producao
cAlias := "SH8"
If File(cPath+cAlias+cEmp+cExt)
    DbUseArea(.T.,,cPath+cAlias+cEmp+cExt,cAlias,.F.,.F.)

    DbSelectArea("SH8")
    DbSetOrder(0)
    DbGoTop()
    ProcRegua(Reccount())

    While !Eof()

        IncProc("Atualizando Arquivo : "+Alias())
    
        DbSelectArea("SB1")
        //----> verificando se o produto existe no SB1
        If DbSeek(xfilial("SB1")+SH8->H8_PRODUTO)
            DbSelectArea("TRB")
            //----> verificando se o produto ja esta gravado no arquivo gerado
            If DbSeek(SH8->H8_PRODUTO)
                RecLock("TRB",.f.)
                  TRB->ALIAS50  :=  "SH8"
                DbUnLock()
            Else
                RecLock("TRB",.t.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS50  :=  "SH8"
                DbUnLock()
            EndIf
        Endif
        DbSelectArea("SH8")
        DbSkip()
    Enddo
    DbCloseArea(cAlias)
Endif

//----> Ferramentas Sacramentadas
cAlias := "SHE"
If File(cPath+cAlias+cEmp+cExt)
    DbUseArea(.T.,,cPath+cAlias+cEmp+cExt,cAlias,.F.,.F.)

    DbSelectArea("SHE")
    DbSetOrder(0)
    DbGoTop()
    ProcRegua(Reccount())

    While !Eof()

        IncProc("Atualizando Arquivo : "+Alias())
    
        DbSelectArea("SB1")
        //----> verificando se o produto existe no SB1
        If DbSeek(xfilial("SB1")+SHE->HE_PRODUTO)
            DbSelectArea("TRB")
            //----> verificando se o produto ja esta gravado no arquivo gerado
            If DbSeek(SHE->HE_PRODUTO)
                RecLock("TRB",.f.)
                  TRB->ALIAS51  :=  "SHE"
                DbUnLock()
            Else
                RecLock("TRB",.t.)
                  TRB->CODIGO   :=  SB1->B1_COD
                  TRB->DESC     :=  SB1->B1_DESC
                  TRB->ALIAS51  :=  "SHE"
                DbUnLock()
            EndIf
        Endif
        DbSelectArea("SHE")
        DbSkip()
    Enddo
    DbCloseArea(cAlias)
Endif

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

