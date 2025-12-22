#include "rwmake.ch"        

User Function Cest16i()     

SetPrvt("_DDATA,_AESTRUTURA,CPERG,CARQTRAB,CARQENT,CARQSAI")
SetPrvt("AREGS,I,J,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CEST16I  ³ Autor ³Ricardo Correa de Souza³ Data ³18/07/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Arquivo Saldos Estoques Inventariados                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo Correa³18/04/02³Insercao de Alguns Campos Conforme Observacao  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Processamento                                     *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_dData      := GetMv("MV_ULMES")
_aEstrutura := {}

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Parametros Utilizados                                                     *
*                                                                           *
* mv_par01      ----> Nome do Arquivo DBF                                   *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

cPerg:= "EST16I"

ValidPerg()     //----> cria grupos de perguntas no arquivo SX1

//----> verifica se o usuario cancelou a execucao
If ! Pergunte(cPerg,.t.)
    Return
EndIf

Aadd(_aEstrutura,{ "CODIGO"       ,"C",08,0 } )
Aadd(_aEstrutura,{ "PRODUTO"      ,"C",30,0 } )
Aadd(_aEstrutura,{ "QUANT"        ,"N",12,2 } )
Aadd(_aEstrutura,{ "CUSMED"       ,"N",12,4 } )
Aadd(_aEstrutura,{ "TOTMED"       ,"N",12,2 } )
Aadd(_aEstrutura,{ "CUSSTD"       ,"N",12,4 } )
Aadd(_aEstrutura,{ "TOTSTD"       ,"N",12,4 } )
// Campos abaixo adicionados em 18/04/2002 solicitado por Andreia - Sao Roque
Aadd(_aEstrutura,{ "STATUS"       ,"C",01,0 } )
Aadd(_aEstrutura,{ "TIPO"         ,"C",02,0 } )
Aadd(_aEstrutura,{ "UNIDADE"      ,"C",02,0 } )
Aadd(_aEstrutura,{ "ALMOX"        ,"C",02,0 } )


cArqTrab := MV_PAR01+".DBF"

DbCreate(cArqTrab,_aEstrutura)

//DbUseArea(.T.,__cRdd,cArqTrab,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )
DbUseArea(.T.,,cArqTrab,"TRB", NIL, .F. )

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos e indices utilizados no processamento                            *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SB1")     // Produtos         
DbSetOrder(1)           // Filial + Codigo 

DbSelectArea("SB9")     // Saldos Iniciais
DbSetOrder(1)           // Filial + Codigo + Local + Data                          

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Inicio do Processamento                                                   *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Atualiza Planilha Inventario")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({||Execute(RunProc)},"Atualiza Planilha Inventario")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SB9")
DbSeek(xFilial("SB9"))

ProcRegua(LastRec())

Do While Eof() == .f. .And. SB9->B9_FILIAL == xFilial("SB9")

    IncProc("Processando Produto "+SB9->B9_COD)

    //----> filtrando somente saldos do ultimo fechamento de estoque
    If Dtos(SB9->B9_DATA) < Dtos(_dData) .Or. Dtos(SB9->B9_DATA) > Dtos(_dData)
        DbSkip()
        Loop
    EndIf

    //----> filtrando somente produtos com saldo diferente de zero
    If SB9->B9_QINI ==  0
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SB1")
    DbSeek(xFilial("SB1")+SB9->B9_COD)

    //----> verificando se o inventario refere-se a Sao Paulo
//    If SM0->M0_CODFIL == "01"
//        //----> filtrando somente produtos acabados
//        If !SB1->B1_TIPO $"PA/PP" 
//            DbSelectArea("SB9")
//            DbSkip()
//            Loop
//        EndIf
//    EndIf

    DbSelectArea("TRB")
    RecLock("TRB",.t.)
      TRB->CODIGO   :=  SB9->B9_COD
      TRB->PRODUTO  :=  SB1->B1_DESC
      TRB->QUANT    :=  SB9->B9_QINI
      TRB->CUSMED   :=  (SB9->B9_VINI1 / SB9->B9_QINI)
      TRB->TOTMED   :=  SB9->B9_VINI1
      TRB->CUSSTD   :=  Iif(SB9->B9_QINI == 0,0,SB1->B1_CUSTD)
      TRB->TOTSTD   :=  Iif(SB9->B9_QINI == 0,0,(SB9->B9_QINI * SB1->B1_CUSTD))
      // Campos abaixo adicionados em 18/04/2002 solicitado por Andreia - Sao Roque
      TRB->STATUS   :=  SB1->B1_CLSTATU
      TRB->TIPO     :=  SB1->B1_TIPO
      TRB->UNIDADE  :=  SB1->B1_UM
      TRB->ALMOX    :=  SB9->B9_LOCAL

    MsUnLock()

    DbSelectArea("SB9")
    DbSkip()
EndDo

DbSelectArea("TRB")
DbCloseArea()

If SM0->M0_CODFIL == "01"
    cArqEnt := cArqTrab
    //cArqSai :="N:\CLAUDINE\INVENT\"+cArqTrab
    cArqSai :="\EXP\"+cArqTrab
Else
    cArqEnt := cArqTrab
    cArqSai :="\EXP\"+cArqTrab
EndIf

Copy File (cArqEnt) to (cArqSai)

Ferase(cArqEnt)

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
    aRegs := {}
    aadd(aRegs,{cPerg,'01','Nome do Arquivo? ','mv_ch1','C',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})

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
