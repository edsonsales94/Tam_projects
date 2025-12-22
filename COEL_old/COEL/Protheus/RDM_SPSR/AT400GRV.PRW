#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function At400grv()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CALIAS,_NORDER,_NRECNO,I,CROT,_CNFE")
SetPrvt("_DDATA,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AT400GRV ³ Autor ³RICARDO CORREA DE SOUZA³ Data ³14/02/2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ VERIFICA SE ESTA SENDO SELECIONADO A OPCAO DE EFETIVACAO DO ³±±
±±³Descri‡…o ³ CHAMADO TECNICO E GRAVA OS DADOS DA NOTA DE ENTRADA NO ORCA-³±±
±±³          ³ MENTO TECNICO.   *** P O N T O   D E   E N T R A D A ***    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESPECIFICO COEL CONTROLES ELETRICOS LTDA                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Guardando a area, indice e registro corrente                               *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

_cAlias:= Alias()
_nOrder:= IndexOrd()
_nRecno:= Recno()

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Verifica se o botao de efeticacao foi a opcao escolhida pelo usuario       *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

i := 0
cRot := UPPER(AllTrim(ProcName(i)))
While !Empty(cRot)
    If cRot $ "AT300EFET" // Botao de Efetivacao do Chamado Tecnico
        DbSelectArea("AB1")
        _cNFE := AB1->AB1_CLNFE
        _dData:= AB1->AB1_CLDATA

        DbSelectArea("AB3")
        //DbSetOrder(_nOrder)
        //DbGoTo(_nRecno)
        RecLock("AB3",.F.)
        AB3->AB3_CLNFE := _cNFE
        AB3->AB3_CLDATA:= _dData
        MsUnLock()
    EndIf
    i := i + 1
    cRot := UPPER(AllTrim(ProcName(i)))
EndDo

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Retornando a area, indice e registro antes das manipulacoes                *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

DbSelectArea(_cAlias)
DbSetOrder(_nOrder)
DbGoTo(_nRecno)

*----------------------------------------------------------------------------*
* Fim                                                                        *
*----------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

