#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function At450grv()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CALIAS,_NORDER,_NRECNO,I,CROT,_CNFE")
SetPrvt("_DDATA,J,CROT1,_NNUMPED,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AT450GRV ³ Autor ³RICARDO CORREA DE SOUZA³ Data ³14/02/2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ VERIFICA SE ESTA SENDO SELECIONADO A OPCAO DE EFETIVACAO DO ³±±
±±³Descri‡…o ³ ORCAMENTO TECNICO E GRAVA OS DADOS DA NOTA DE ENTRADA NA    ³±±
±±³          ³ ORDEM DE SERVICO.  *** P O N T O   D E   E N T R A D A ***  ³±±
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
    If cRot $ "AT400EFET" // Botao de Efetivacao do Orcamento Tecnico
        DbSelectArea("AB3")
        _cNFE := AB3->AB3_CLNFE
        _dData:= AB3->AB3_CLDATA

        DbSelectArea("AB6")
        RecLock(_cAlias,.F.)
        AB6->AB6_CLNFE := _cNFE
        AB6->AB6_CLDATA:= _dData
        MsUnLock()
    EndIf
    i := i + 1
    cRot := UPPER(AllTrim(ProcName(i)))
EndDo

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Verifica se o botao de efeticacao foi a opcao escolhida pelo usuario       *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

j:=0
cRot1:= UPPER(AllTrim(ProcName(j)))
While !Empty(cRot1)
    If cRot1 $ "AT450EFET" // Botao de Efetivacao p/Pedido de Venda
        _nNumPed:= Val(GetSX8Num("SC5"))-1
        MsgBox("Atencao Sr.(a)"+SubStr(cUsuario,7,15)+", o pedido gerado pelo Astec e: "+Str(_nNumPed),"NUMERO DO PEDIDO DE VENDA","ALERT")
    EndIf
    j := j + 1
    cRot1:= UPPER(AllTrim(ProcName(j)))
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