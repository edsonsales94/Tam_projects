#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function Cest06i()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CARQEST,_CINDEST,_CCHAEST,AESTRU1,_CTEMP1,TITULO")
SetPrvt("CABEC1,CABEC2,CDESC1,CDESC2,CSTRING,ARETURN")
SetPrvt("WNREL,TAMANHO,LIMITE,M_PAG,CBCONT,LI")
SetPrvt("NITENS,")


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CEST06I  ³ Autor ³Ricardo Correa de Souza³ Data ³28.08.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Importacao Lote Minimo e Prazo de Entrega.                 ³±±
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
* Arquivos Utilizados no Processamento                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SB1")             //----> Cadastro de Produtos
DbSetOrder(1)                   //----> Codigo

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos Externos Utilizados no Processamento                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_cArqEst := "LMPE.DBF" //----> Arquivo que contem os lotes
                                       //----> minimos a serem importados

//DbUseArea(.T.,__cRdd,_cArqEst,"EST",IF(.T. .OR. .F., !.F., NIL), .F. )
DbUseArea(.T.,,_cArqEst,"EST", NIL, .F. )

_cIndEst := CriaTrab(Nil,.f.)
_cChaEst := "EST->CODIGO"

IndRegua("EST",_cIndEst,_cChaEst,,,"Selecionando Produtos !!!")
//----> Indexando por PRODUTO

aEstru1 := {{"CODIGO" ,"C",8 ,0} , {"LMINIMO" ,"N",9,0} , {"PRENTREGA" ,"N",9,0}}

_cTemp1 := CriaTrab( aEstru1, .T. )  // Arquivo onde sera' gravado os novos produtos importados
DbUseArea( .T., , _cTemp1  , "TRB", .F., .F. )

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Atualiza Lotes Minimos ")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({||Execute(RunProc)},"Atualiza Lotes Minimos ")
Return(nil)	   // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("EST")
DbGoTop()
ProcRegua(LastRec())

Do While Eof() == .f.

    IncProc("Processando Produto "+EST->CODIGO)

    DbSelectArea("SB1")
    If DbSeek(xFilial("SB1")+EST->CODIGO)
        RecLock("SB1",.f.)
          SB1->B1_TIPE   :=  "D"
          SB1->B1_PE     :=  EST->TEMPO_REP_
          SB1->B1_LM     :=  EST->LOTE_MIN
        MsUnLock()
    Else
        DbSelectArea("TRB")
        RecLock("TRB",.t.)
          TRB->CODIGO    :=  EST->CODIGO
          TRB->LMINIMO   :=  EST->LOTE_MIN
          TRB->PRENTREGA :=  EST->TEMPO_REP_
        MsUnLock()
    EndIf

    DbSelectArea("EST")
    DbSkip()
EndDo

Imprime()

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim                                                                       *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function Imprime
Static Function Imprime()
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

titulo := "  Produtos nao encontrados SIGA            "
cabec1 := "CODIGO    LOTE MINIMO    PRAZO ENTREGA  "
cabec2 := ""
cDesc1 := "Este Relatorio tem o Objetivo de Listar os Produtos    "
cDesc2 := "Cadastrados pela Importacao de Dados Complementares    "
cString:= "EST"
aReturn:= { "Especial", 1, "Administracao", 1, 1, 1,"", 1 }
wnrel  := "CEST06I"
Tamanho:= "P"
Limite := 80 
m_pag  := 1
wnrel  := SetPrint( cString,wnrel,"",Titulo,cDesc1,cDesc2,"    ",.F.,,.T.,Tamanho,,.F.)
cbCont := 00

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

li := 60
nItens := 0

DbSelectArea("TRB")
DbGoTop()

While !Eof()
    If li > 59
        cabec(titulo,cabec1,cabec2,wnrel,Tamanho,18)
        //li := 0 
    EndIf

    @ li , 000 PSAY TRB->CODIGO
    @ li , 011 PSAY TRB->LMINIMO
    @ li , 028 PSAY TRB->PRENTREGA 
    li:= li + 1
    @ li, 00 PSAY Replicate("-",Limite)
    li:= li + 1
    nItens := nItens + 1
    DbSkip()
EndDo

li:= li + 1
@ li , 000 PSAY "Total de Itens: "+Str(nItens)

Roda(CbCont,"PRODUTOS","P")

If aReturn[5] == 1
   Set Printer TO
   OurSpool(Wnrel)
Endif

MS_FLUSH()

DbSelectArea("TRB")
DbCloseArea()

DbSelectArea("EST")
DbCloseArea()

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Retorna para sua chamada (CEST06I)                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
