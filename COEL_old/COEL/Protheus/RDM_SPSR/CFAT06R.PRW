#include "rwmake.ch"     

User Function Cfat06r()

SetPrvt("DINICIAL,CGRUPO,CDESC,ATOTAISP,ATOTAISA,ATOTGERAL")
SetPrvt("NTAMANHO,NLIMITE,CTITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CBCONT,ARETURN,NOMEPROG,CPERG,LCONTINUA,NLIN")
SetPrvt("WNREL,CSTRING,NLASTKEY,M_PAG,LABORTPRINT,CABEC1")
SetPrvt("CABEC2,AESTRUT,CNOMEARQ,CINDEX,CCHAVE,_TOTALGERAL")
SetPrvt("_NTOTPERC,AREGS,I,J,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT06R  ³ Autor ³Ricardo Correa de Souza³ Data ³24/10/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio Estatistica Vendas x Faturamento por Grupo       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Uso da Diretoria                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Rogerio Batist³12/07/02³InclusÆo de uma coluna com percentual          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas nos Parametros                                       *
*                                                                           *
* mv_par01                Da Emissao        ?                               *
* mv_par02                Ate a Emissao     ?                               *
* mv_par03                Inicio Acumulado  ?                               *
* mv_par04                Do Cliente        ?                               *
* mv_par05                Ate o Cliente     ?                               *
* mv_par06                Do Vendedor       ?                               *
* mv_par07                Ate o Vendedor    ?                               *
* mv_par08                Tes de Vendas     ?                               *
* mv_par09                Tes de Vendas 1   ?                                                                            *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Processamento                                     *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

dInicial    := mv_par01
cGrupo      := Space(05)              // grupo acumulador
cDesc       := Space(25)              // descricao do grupo
aTotaisP    := { 0, 0 }               // quantidade pedido e quantidade faturada - periodo
aTotaisA    := { 0, 0 }               // quantidade pedido e quantidade faturada - acumulado
aTotGeral   := { 0, 0, 0, 0 }         // quantidade total geral
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

nTamanho    := "M"
nLimite     := 132
cTitulo     := "Estatistica Vendas x Faturamento por Grupo"
cDesc1      := "Este programa emitira relatorio estatistico"
cDesc2      := "vendas X faturamento"
cDesc3      := ""
cbCont      := 0
aReturn     := { "Especial", 1, "Administracao", 1, 1, 1, "", 1 }
nomeprog    := "CFAT06R" 
cPerg       := "FAT06R"
lContinua   := .t.
nLin        := 7
wnrel       := "CFAT06R"
cString     := "SC5"
nLastKey    := 0
m_Pag       := 1
lAbortPrint := .f.
cabec1      := "GRUPO   DESCRICAO                  QTD VEN           QTD FAT           QTD VEN ACUM                    %     "
cabec2      := ""

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

aEstrut  := {{"TMP_GRUPO","C",05,0},; 
             {"TMP_DESC" ,"C",20,0},;
             {"TMP_QTDP" ,"N",12,2},;
             {"TMP_QTDA" ,"N",12,2},;
             {"TMP_FP"   ,"C",01,0}}

cNomeArq := CriaTrab( aEstrut, .t. )
DbUseArea( .T., , cNomeArq, "TRB", .T., .F. )   

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos Utilizados no Processamento                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SB1")                 //----> Produtos
DbSetOrder(1)                       //----> Codigo

DbSelectArea("SC5")                 //----> Pedidos de Venda
DbSetOrder(2)                       //----> Data Emissao + Numero Pedido

DbSelectArea("SC6")                 //----> Itens dos Pedidos
DbSetOrder(1)                       //----> Numero Pedido + Item + Produto

DbSelectArea("SD2")                 //----> Itens das Notas de Saida
DbSetOrder(3)                       //----> Nota + Serie + Cliente + Loja + Produto

DbSelectArea("SF2")                 //----> Cabe‡alho de Notas Fiscais Saida
//DbSetOrder(6)                       //----> Emissao + Nota + Serie
dbOrderNickName("SF26")

DbSelectArea("SZG")                 //----> Cadastro de Grupos
DbSetOrder(1)                       //----> Codigo

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

//ValidPerg()

Pergunte( cPerg, .f. )

wnrel := SetPrint( cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3, .F. )

If nLastKey == 27
   DbSelectArea("TRB")
   DbCloseArea("TRB")
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   DbSelectArea("TRB")
   DbCloseArea("TRB")
   Return
Endif

RptStatus({|| Imprime()})// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> RptStatus({|| Execute(Imprime)})
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function Imprime
Static Function Imprime()

//----> busca as quantidades vendidas
dInicial := mv_par03

DbSelectArea("SC5")
DbSetOrder(2)
If !DbSeek(xFilial("SC5")+Dtos(dInicial))
    Do While dInicial <= mv_par02
        dInicial := dInicial + 1
        If DbSeek(xFilial("SC5") + Dtos(dInicial))
            Exit
        EndIf
    EndDo
EndIf

SetRegua(LastRec())

Do While !Eof() .And. SC5->C5_EMISSAO <= mv_par02 .And. !lAbortPrint

    IncRegua()

    //----> filtrando apenas intervalo de clientes selecionado nos parametros
    If SC5->C5_CLIENTE < mv_par04 .OR. SC5->C5_CLIENTE > mv_par05
        DbSkip()
        Loop
    EndIf

    //----> filtrando apenas intervalo de vendedores selecionado nos parametros
    If SC5->C5_VEND1 < mv_par06 .OR. SC5->C5_VEND1 > mv_par07
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SC6")
    DbSeek( xFilial("SC6") + SC5->C5_NUM )

    Do While SC6->C6_NUM == SC5->C5_NUM

        //----> filtrando apenas os tes selecionado nos parametros
        If !SC6->C6_TES $Alltrim(mv_par08+mv_par09)
            DbSkip()
            Loop
        EndIf

        DbSelectArea("SB1")
        DbSeek( xFilial("SB1") + SC6->C6_PRODUTO )

        DbSelectArea("SZG")
        DbSeek( xFilial("SZG") + SB1->B1_GRUPO )

        DbSelectArea("TRB")
        RecLock( "TRB", .t. )
          TRB->TMP_GRUPO  :=   SB1->B1_GRUPO
          TRB->TMP_DESC   :=   SZG->ZG_DESC

          If SC5->C5_EMISSAO < mv_par01
              TRB->TMP_QTDP   :=   0
          Else
              TRB->TMP_QTDP   :=   SC6->C6_QTDVEN
          EndIf

          TRB->TMP_QTDA   :=   SC6->C6_QTDVEN
          TRB->TMP_FP     :=   "P"
        MsUnLock()

        DbSelectArea("SC6")
        DbSkip()
    EndDo

    DbSelectArea("SC5")
    DbSkip()
EndDo

//----> busca as quantidades faturadas
dInicial := mv_par03

DbSelectArea("SF2")
//DbSetOrder(6)
dbOrderNickName("SF26")

If !DbSeek( xFilial("SF2") + Dtos(dInicial) )
    Do While dInicial <= mv_par02
        dInicial := dInicial + 1
        If DbSeek( xFilial("SF2") + Dtos(dInicial) )
            Exit
        EndIf
    EndDo
EndIf

Do While !Eof() .AND. SF2->F2_EMISSAO <= mv_par02 .And. !lAbortPrint

    IncRegua()

    //----> filtrando apenas intervalo de clientes selecionado nos parametros
    If SF2->F2_CLIENTE < mv_par04 .OR. SF2->F2_CLIENTE > mv_par05
        DbSkip()
        Loop
    EndIf

    //----> filtrando apenas intervalo de vendedores selecionado nos parametros
    If SF2->F2_VEND1 < mv_par06 .OR. SF2->F2_VEND1 > mv_par07
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SD2")
    DbSeek( xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE )

    Do While SD2->D2_DOC == SF2->F2_DOC
      
        //----> filtrando apenas os tes selecionado nos parametros
        If !SD2->D2_TES $mv_par08
            DbSkip()
            Loop
        EndIf

        DbSelectArea("SB1")
        DbSeek( xFilial("SB1") + SD2->D2_COD )

        DbSelectArea("SZG")
        DbSeek( xFilial("SZG") + SB1->B1_GRUPO )

        DbSelectArea("TRB")
        RecLock( "TRB", .t. )
          TRB->TMP_GRUPO  :=   SB1->B1_GRUPO
          TRB->TMP_DESC   :=   SZG->ZG_DESC

          If SF2->F2_EMISSAO < mv_par01
              TRB->TMP_QTDP   :=   0
          Else
              TRB->TMP_QTDP   :=   SD2->D2_QUANT
          EndIf

          TRB->TMP_QTDA   :=   SD2->D2_QUANT 
          TRB->TMP_FP     :=   "F"
        MsUnLock()

        DbSelectArea("SD2")
        DbSkip()
    EndDo

    DbSelectArea("SF2")
    DbSkip()
EndDo

//----> Impressao do Relatorio
DbSelectArea("TRB")

cIndex := CriaTrab(Nil,.f.)
cChave := "TRB->TMP_DESC + TRB->TMP_GRUPO"

IndRegua( "TRB", cIndex, cChave, , , "Armazenando Total Geral..." )

SetRegua( LastRec() )
DbGoTop()

_TotalGeral := 0

Do While !Eof()

       IncRegua()

        If TRB->TMP_FP == "P"
            _TotalGeral := _TotalGeral + TRB->TMP_QTDA
        EndIf 

        DbSelectArea("TRB")
        DbSkip()
EndDo

fErase( cNomeArq+".idx" )


//----> Impressao do Relatorio
DbSelectArea("TRB")

cIndex := CriaTrab(Nil,.f.)
cChave := "TRB->TMP_DESC + TRB->TMP_GRUPO"

IndRegua( "TRB", cIndex, cChave, , , "Preparando para Imprimir..." )

@ nLin, 000 PSAY AvalImp( nLimite )

Cabec(cTitulo,Cabec1,Cabec2,nomeprog,nTamanho,15)

_nTotPerc:= 0

SetRegua( LastRec() )
DbGoTop()

Do While !Eof()

    cGrupo  := TRB->TMP_GRUPO
    cDesc   := TRB->TMP_DESC    
    aTotaisP := { 0, 0 }         
    aTotaisA := { 0, 0 }         

    Do While TRB->TMP_GRUPO == cGrupo

        IncRegua()

        If TRB->TMP_FP == "P"
            aTotaisP[1]  := aTotaisP[1]  + TRB->TMP_QTDP
            aTotaisA[1]  := aTotaisA[1]  + TRB->TMP_QTDA
            aTotGeral[1] := aTotGeral[1] + TRB->TMP_QTDP
            aTotGeral[3] := aTotGeral[3] + TRB->TMP_QTDA
            aTotaisA[2]  := aTotaisA[1]  / _TotalGeral *100

        ElseIf TRB->TMP_FP == "F"
            aTotaisP[2]  := aTotaisP[2]  + TRB->TMP_QTDP
//            aTotaisA[2]  := aTotaisA[2]  + TRB->TMP_QTDA
            aTotGeral[2] := aTotGeral[2] + TRB->TMP_QTDP
        EndIf 

        DbSelectArea("TRB")
        DbSkip()
    EndDo

    _nTotPerc    := _nTotPerc + aTotaisA[2]


    @ nLin, 000       PSAY cGrupo
    @ nLin, Pcol()+04 PSAY cDesc

    //----> quantidade pedido no periodo
    If aTotaisP[1] > 0
        @ nLin, Pcol()+01 PSAY aTotaisP[1]          Picture"@E 9,999,999.99"
    Else                         
        @ nLin, Pcol()+01 PSAY 0                    Picture"@E 9,999,999.99"         
    EndIf

    //----> quantidade faturada no periodo
    If aTotaisP[2] > 0
        @ nLin, Pcol()+06 PSAY aTotaisP[2]          Picture"@E 9,999,999.99"
    Else                                
        @ nLin, Pcol()+06 PSAY 0                    Picture"@E 9,999,999.99"
    EndIf

    //----> quantidade pedido acumulado 
    If aTotaisA[1] > 0
        @ nLin, Pcol()+11 PSAY aTotaisA[1]          Picture"@E 9,999,999.99"
    Else                         
        @ nLin, Pcol()+11 PSAY 0                    Picture"@E 9,999,999.99"         
    EndIf

    //----> percentual 
    If aTotaisA[2] > 0
        @ nLin, Pcol()+11 PSAY aTotaisA[2]          Picture"@E 9,999,999.99"
    Else                                
        @ nLin, Pcol()+11 PSAY 0                    Picture"@E 9,999,999.99"
    EndIf

    nLin := nLin + 1

    @ nLin , 000  PSAY Replicate( "-", nLimite )

    nLin := nLin + 1

    If nLin > 60
        Cabec(cTitulo,Cabec1,Cabec2,nomeprog,nTamanho,15)
        nLin := 7
    EndIf

EndDo

nLin := nLin + 1

@ nLin, 000 PSAY "(*) Total Geral->"

//----> quantidade total pedido no periodo
If aTotGeral[1] > 0
    @ nLin, 030       PSAY aTotGeral[1]          Picture"@E 9,999,999.99"
Else                         
    @ nLin, 030       PSAY 0                     Picture"@E 9,999,999.99"         
EndIf

//----> quantidade total faturada no periodo
If aTotGeral[2] > 0
    @ nLin, Pcol()+06 PSAY aTotGeral[2]          Picture"@E 9,999,999.99"
Else                                
    @ nLin, Pcol()+06 PSAY 0                     Picture"@E 9,999,999.99"
EndIf

//----> quantidade total pedido acumulado 
If aTotGeral[3] > 0
    @ nLin, Pcol()+11 PSAY aTotGeral[3]          Picture"@E 9,999,999.99"
Else                         
    @ nLin, Pcol()+11 PSAY 0                     Picture"@E 9,999,999.99"         
EndIf
//----> percentual
If _nTotPerc > 0
    @ nLin, Pcol()+11 PSAY    _nTotPerc          Picture"@E 9,999,999.99"
Else                                
    @ nLin, Pcol()+11 PSAY 0                     Picture"@E 9,999,999.99"
EndIf

nLin := nLin + 2

@ nLin, 000 PSAY PADC("(*) Os Totais sÆo em Quantidades (Unidades) de Pe‡as e nÆo em Valores (R$)",132)

Roda(CbCont,"Estatistica","M")

DbSelectArea("TRB")     
DbCloseArea("TRB")

fErase( cNomeArq+".dbf" )
fErase( cNomeArq+".idx" )
fErase( cNomeArq+".mem" )

If aReturn[5] == 1
   Set Printer To
   OurSpool(wnrel)
EndIf

Ms_Flush()

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

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

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)

aRegs :={}

Aadd(aRegs,{cPerg,"01","Da Emissao              ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Ate a Emissao           ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Inicio Acumulado        ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Do Cliente              ?","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Ate o Cliente           ?","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Do Vendedor             ?","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","Ate o Vendedor          ?","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"08","Tes de Vendas           ?","mv_ch8","C",30,0,0,"G","","mv_par08","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"09","Tes de Vendas Complem   ?","mv_ch9","C",30,0,0,"G","","mv_par09","","","","","","","","","","","","","","",""})

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

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim da Funcao                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
