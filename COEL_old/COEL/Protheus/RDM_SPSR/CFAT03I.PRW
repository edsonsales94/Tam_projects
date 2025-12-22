#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function Cfat03i()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_AAREA,_CCOD,_CDESCR,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CFAT03I  ³ Autor ³RICARDO CORREA DE SOUZA³ Data ³19.01.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ GRAVA A NARRATIVA DO PRODUTO NO SB1 ATRAVES DA ALTERACAO NO ³±±
±±³Descri‡…o ³ SB5. ROTINA DISPARADA VIA GATILHO NO CAMPO B5_CEME.         ³±±
±±³          ³          *** G A T I L H O   E X E C B L O C K ***          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESPECIFICO COEL CONTROLES ELETRICOS LTDA                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Guardando a area, indice e registro corrente                               *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

_aArea := {Alias(),IndexOrd(),Recno()}

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Processamento                                                              *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

_cCod  := M->B5_COD
_cDescr:= M->B5_CEME

DbSelectArea("SB1")     // Cadastro de Produtos
DbSetOrder(1)           // Codigo do Produto

MsgBox(Alltrim(SubStr(cUsuario,7,15))+", o sistema atualizara a narrativa no arquivo SB1                                                         (Cadastro de Produtos)","NARRATIVA","Alert")
DbSeek(xFilial()+_cCod)
if Found()
	RecLock("SB1",.F.)
     SB1->B1_NARRA := M->B5_CEME
	MsUnlock()
endif

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Retornando a area, indice e registro antes das manipulacoes                *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

DbSelectArea(_aArea[1])
DbSetOrder(_aArea[2])

Return(_cDescr)        // Alterado por Rogerio Batista

*----------------------------------------------------------------------------*
* Fim                                                                        *
*----------------------------------------------------------------------------*

