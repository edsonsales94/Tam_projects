#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function Cest02i()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CARQESTRU,_CINDESTR,_CCHAESTR,")

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±³ Programa   ³ CEST02I  ³ Autor ³Ricardo Correa de Souza³ Data ³01/06/2000³±
±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±³ Funcao     ³ Importacao das estruturas dos produtos baseando-se pelo    ³±
±³            ³ arquivo ESTRUSGF.DBF criado pelo Sr. Fernando (SISTEMA SGF)³±
±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±³ Uso        ³ Especifico Coel Controles Eletricos Ltda (Sao Roque)       ³±
±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis utilizadas no processamento                                     *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_cArqEstru := "ESTRUSGF.DBF"
//----> Arquivo que contem as estruturas dos produtos no sistema SGF

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos e indices utilizados no processamento                            *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SG1")     // Estrutura de Produtos
DbSetOrder(1)           // Filial + Codigo + Componente + Sequencia

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Inicio do processamento                                                   *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Atualiza Estrutura")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({||Execute(RunProc)},"Atualiza Estrutura")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

//DbUseArea(.T.,__cRdd,_cArqEstru,"ESTR",IF(.T. .OR. .F., !.F., NIL), .F. )
DbUseArea(.T.,,_cArqEstru,"ESTR", NIL, .F. )

_cIndESTR := CriaTrab(Nil,.f.)
_cChaESTR := "ESTR->ID_PRODUTO"
IndRegua("ESTR",_cIndESTR,_cChaESTR,,,"Selecionando Registros SGF (Fernando) ...")
//----> Indexando por PRODUTO PAI

DbSelectArea("ESTR")
DbGoTop()
ProcRegua(LastRec())
Do While Eof() == .f.

    IncProc("Processando Produto "+Subs(ESTR->ID_PRODUTO,1,2)+"0"+Subs(ESTR->ID_PRODUTO,3,2)+"0"+Subs(ESTR->ID_PRODUTO,5,2))

    DbSelectArea("SG1")
    RecLock("SG1",.t.)
      _field->G1_FILIAL     :=      xFilial("SG1")
      _field->G1_COD        :=      Subs(ESTR->ID_PRODUTO,1,2)+"0"+Subs(ESTR->ID_PRODUTO,3,2)+"0"+Subs(ESTR->ID_PRODUTO,5,2)
      _field->G1_COMP       :=      Subs(ESTR->ID_PRODU,1,2)+"0"+Subs(ESTR->ID_PRODU,3,2)+"0"+Subs(ESTR->ID_PRODU,5,2)
      _field->G1_QUANT      :=      ESTR->QTDE_ITEM
      _field->G1_INI        :=      dDataBase
      _field->G1_FIM        :=      dDataBase + 365
      _field->G1_FIXVAR     :=      "V"
      _field->G1_REVFIM     :=      "ZZZ"
      _field->G1_OBSERV     :=      ESTR->LOCAL
    MsUnLock()
    DbSelectArea("ESTR")
    DbSkip()
EndDo

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

*---------------------------------------------------------------------------*
* Fim                                                                       *
*---------------------------------------------------------------------------*
//----> Para a gravacao no Siga foi inserido (zero) antes da 3¦ posicao, antes
//----> da 5¦ posicao da codificacao do sistema SGF (6 caracteres), ou seja,
//----> no Siga a codificacao esta com (8 caracteres).
