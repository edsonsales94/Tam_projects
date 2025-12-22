#include "rwmake.ch"        

User Function Cest15i()     


SetPrvt("_CARQEST,_NCUSTOUNIT,_NCUSTOITEM,_NCUSTOTOTAL,_CINDEST,_CCHAEST")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CEST15I  ³ Autor ³Ricardo Correa de Souza³ Data ³11/07/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Custo Standard para Cadastro de Produtos              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Processamento                                     *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
_cPath       := "\SYSTEM\"
_cArqEst     := _cPath+"CUSTOS.DBF"
_nCustoUnit  := 0   //----> custo unitario do componente
_nCustoItem  := 0   //----> 
_nCustoTotal := 0
                                           
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos e indices utilizados no processamento                            *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SB1")     // Produtos       
DbSetOrder(1)           // Filial + Codigo                           

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Inicio do Processamento                                                   *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Atualiza Custo Standard Produtos")
Return

Static Function RunProc()

//DbUseArea(.T.,__cRdd,_cArqEst,"EST",IF(.T. .OR. .F., !.F., NIL), .F. )
DbUseArea(.T.,,_cArqEst,"EST", NIL, .F. )

_cIndEst := CriaTrab(Nil,.f.)
_cChaEst := "EST->COD"

IndRegua("EST",_cIndEst,_cChaEst,,,"Selecionando Custos Standard")
//----> Indexando por PRODUTO

DbSelectArea("EST")
DbGoTop()
ProcRegua(LastRec())

Do While Eof() == .f.

    IncProc("Processando Produto "+EST->COD)

    DbSelectArea("SB1")
    If DbSeek(xFilial("SB1")+EST->COD)
        RecLock("SB1",.f.)
          SB1->B1_CUSTD  := EST->PRECO
        MsUnLock()
    EndIf

    DbSelectArea("EST")
    DbSkip()
EndDo

DbSelectArea("EST")
DbCloseArea("EST")

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

/*
Observacoes:

NOME DO ARQUIVO: N:\SIGA\SIGAADV\CUSTO.DBF

ESTRUTURA DO ARQUIVO

CAMPO   TIPO    TAMANHO     DECIMAL
COD     C       15          0
PRECO   N       11          4

*/
