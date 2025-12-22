#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function Cest03i()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CPROD,_CARQEST,_CINDEST,_CCHAEST,")

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±³ Programa   ³ CEST03I  ³ Autor ³Ricardo Correa de Souza³ Data ³05/06/2000³±
±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±³ Funcao     ³ Importacao de saldos iniciais dos produtos baseando-se pelo³±
±³            ³ arquivo ESTOQSGF.DBF criado pelo Sr. Fernando (SISTEMA SGF)³±
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

_cProd   := Space(8) //----> Armazena codigo do produto
_cArqEst := "ESTOQSGF.DBF" //----> Arquivo que contem
                                           //----> os saldos iniciais
                                           //----> dos produtos (SGF)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos e indices utilizados no processamento                            *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SB1")     // Cadastro de Produtos
DbSetOrder(1)           // Filial + Codigo

DbSelectArea("SB9")     // Saldos Iniciais
DbSetOrder(1)           // Filial + Codigo                           

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Inicio do processamento                                                   *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Atualiza Saldos Iniciais")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({||Execute(RunProc)},"Atualiza Saldos Iniciais")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

//DbUseArea(.T.,__cRdd,_cArqEst,"EST",IF(.T. .OR. .F., !.F., NIL), .F. )
DbUseArea(.T.,,_cArqEst,"EST", NIL, .F. )

_cIndEst := CriaTrab(Nil,.f.)
_cChaEst := "EST->CODIGO_PRO"

IndRegua("EST",_cIndEst,_cChaEst,,,"Selecionando Saldos Iniciais SGF...")
//----> Indexando por PRODUTO

DbSelectArea("EST")
DbGoTop()
ProcRegua(LastRec())
Do While Eof() == .f.
    _cProd := Subs(EST->CODIGO_PRO,1,2)+"0"+Subs(EST->CODIGO_PRO,3,2)+"0"+Subs(EST->CODIGO_PRO,5,2)

    IncProc("Processando Produto "+_cProd)

    DbSelectArea("SB1")
    If DbSeek(xFilial("SB1")+_cProd)
       // RecLock("SB1",.f.)
       //   _field->B1_PESO       :=      EST->PESO
       // MsUnLock()

        DbSelectArea("SB9")
        RecLock("SB9",.t.)
          _field->B9_FILIAL     :=      xFilial("SB9")
          _field->B9_COD        :=      SB1->B1_COD
          _field->B9_LOCAL      :=      SB1->B1_LOCPAD
          _field->B9_QINI       :=      EST->QTDE_DISPO
          _field->B9_QISEGUM    :=      (EST->QTDE_DISPO * SB1->B1_CONV)
          _field->B9_VINI1      :=      Round((EST->QTDE_DISPO * EST->VALOR),4)
        MsUnLock()
    Else
        DbSelectArea("SB9")
        RecLock("SB9",.t.)
          _field->B9_FILIAL     :=      xFilial("SB9")
          _field->B9_COD        :=      _cProd
          _field->B9_LOCAL      :=      "01"
          _field->B9_QINI       :=      EST->QTDE_DISPO
          _field->B9_QISEGUM    :=      EST->QTDE_DISPO 
          _field->B9_VINI1      :=      Round((EST->QTDE_DISPO * EST->VALOR),4)
        MsUnLock()
    EndIf

    DbSelectArea("EST")
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