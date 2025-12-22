#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function Cfat21i()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CALIAS,_INDEX,_NREC,_CTABPRC,_NPRCINI,_NPRCDESC")
SetPrvt("_NPRCMIN,_NPRCFIM,_NPRCRET,_NPRCALC8,_NPRCALC7,_NPRCALC6")
SetPrvt("_NPRCALC5,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT21I  ³ Autor ³Rosimeire Goes         ³ Data ³ 02/07/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gatilho para calculo do Preco de Venda no orcamento levando ³±±
±±³          ³em consideracao : Preco Unitario, Desconto Padrao, Alcada   ³±±
±±³          ³de Desconto do usuario e verificacao do Preco Minimo.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Desconto padrao e'trazido de tabela especifica do cliente  ³±±
±±³          ³ SZ2 que ja foi trazido por gatilho para o CJ_CLDESC        ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Orcamento de Venda                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
_cAlias:=Alias()
_Index :=IndexOrd()
_nRec  := Recno()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca o Preco Unitario de Tabela (_nPrcIni) e Calcula o Preco de Venda   ³
//³ (_nPrcDesc) de acordo com o Desconto Padrao do Cliente. Calcula tambem o ³
//³ Preco Minimo de Venda (_nPrcMin) que e verificado no SB5. Guarda o Preco ³
//³ de Venda digitado, caso haja alteracao (_nPrcFim).                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cTabPrc := M->CJ_TABELA
_nPrcIni := Round(TMP1->CK_PRUNIT,2)
_nPrcDesc:= Round(_nPrcIni - ((_nPrcIni * M->CJ_CLDESC)/100),2)
_nPrcMin := Round(posicione("SB5",1,xFilial()+SB1->B1_COD,iif(_cTabPrc=="2","B5_PRV6","B5_PRV7")),2)
_nPrcFim := Round(TMP1->CK_PRCVEN,2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico se o Preco de Venda digitado e menor do que o Preco Minimo.Caso ³
//³ verdadeiro, o gatilho retorna na variavel (_nPrcRet) o Preco Minimo.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
If _nPrcFim < _nPrcMin
    MsgBox(Alltrim(SubStr(cUsuario,7,15))+", o Prc Venda informado esta abaixo do Prc Minimo de Tabela. O sistema adotara o Preco Minimo como Preco de Venda","Validacao de Preco de Venda X Preco Minimo","Alert")
    _nPrcRet:= _nPrcMin
    TMP1->CK_VALOR  := Round(_nPrcRet*TMP1->CK_QTDVEN,2)
    TMP1->CK_DESCONT:= 100-((_nPrcRet/TMP1->CK_PRUNIT)*100)
    TMP1->CK_VALDESC:= Round(((TMP1->CK_PRUNIT*TMP1->CK_DESCONT)/100)*TMP1->CK_QTDVEN,2)
Else
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso o If anterior seja Falso, o gatilho retorna na variavel (_nPrcRet)  ³
//³ o Preco de Venda digitado (_nPrcFim).                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
    _nPrcRet:= _nPrcFim

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Verifico se o Preco Final de Venda e maior do que o Preco Unitario Tabela³
    //³ Caso verdadeiro, exibo mensagem de aviso ao usuario.                     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If _nPrcRet > TMP1->CK_PRUNIT
        MsgBox(Alltrim(SubStr(cUsuario,7,15))+", o Prc Venda informado esta acima do Prc Tabela. Verifique o preco informado.","Validacao de Preco de Venda X Preco de Tabela","Alert")
        TMP1->CK_VALOR  := Round(_nPrcRet*TMP1->CK_QTDVEN,2)
        TMP1->CK_DESCONT:= 0
        TMP1->CK_VALDESC:= 0
    Else
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Calculo o Preco de Venda Final de acordo com a Alcada para Descontos do  ³
        //³ usuario de acordo com o Nivel de Senha.                                  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If cNivel >= 8
            _nPrcAlc8:= _nPrcDesc * 0
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Verifico se o Preco de Venda digitado esta dentro da Alcada do usuario,  ³
            //³ Caso verdadeiro, considero o Preco Final de Retorno (_nPrcRet) igual ao  ³
            //³ ao Preco de Venda digitado (_nPrcFim), se nao o Preco Final de Retorno   ³
            //³ (_nPrcRet) sera igual ao Preco da Alcada do usuario (_nPrcAlc8).         ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If _nPrcRet < _nPrcAlc8 
                MsgBox(Alltrim(SubStr(cUsuario,7,15))+", o Prc Venda informado esta fora da sua Alcada. O sistema adotara o Preco de Venda de acordo com sua Alcada que e de 40%","Validacao de Preco de Venda X Alcada","Alert")
                _nPrcRet:= _nPrcAlc8
                TMP1->CK_VALOR  := Round(_nPrcRet*TMP1->CK_QTDVEN,2)
                TMP1->CK_DESCONT:= 100-((_nPrcRet/TMP1->CK_PRUNIT)*100)
                TMP1->CK_VALDESC:= Round(((TMP1->CK_PRUNIT*TMP1->CK_DESCONT)/100)*TMP1->CK_QTDVEN,2)
            EndIf
        ElseIf cNivel == 7
            _nPrcAlc7:= Round(_nPrcDesc * 0.80,2)
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Verifico se o Preco de Venda digitado esta dentro da Alcada do usuario,  ³
            //³ Caso verdadeiro, considero o Preco Final de Retorno (_nPrcRet) igual ao  ³
            //³ ao Preco de Venda digitado (_nPrcFim), se nao o Preco Final de Retorno   ³
            //³ (_nPrcRet) sera igual ao Preco da Alcada do usuario (_nPrcAlc7).         ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If _nPrcRet < _nPrcAlc7 .Or. _nPrcRet < _nPrcMin
                MsgBox(Alltrim(SubStr(cUsuario,7,15))+", o Prc Venda informado esta fora da sua Alcada. O sistema adotara o Preco de Venda de acordo com sua Alcada que e de 20%","Validacao de Preco de Venda X Alcada","Alert")
                _nPrcRet:= _nPrcAlc7
                TMP1->CK_VALOR  := Round(_nPrcRet*TMP1->CK_QTDVEN,2)
                TMP1->CK_DESCONT:= 100-((_nPrcRet/TMP1->CK_PRUNIT)*100)
                TMP1->CK_VALDESC:= Round(((TMP1->CK_PRUNIT*TMP1->CK_DESCONT)/100)*TMP1->CK_QTDVEN,2)
            EndIf
        ElseIf cNivel == 6
            _nPrcAlc6:= Round(_nPrcDesc * 0.90,2)
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Verifico se o Preco de Venda digitado esta dentro da Alcada do usuario,  ³
            //³ Caso verdadeiro, considero o Preco Final de Retorno (_nPrcRet) igual ao  ³
            //³ ao Preco de Venda digitado (_nPrcFim), se nao o Preco Final de Retorno   ³
            //³ (_nPrcRet) sera igual ao Preco da Alcada do usuario (_nPrcAlc6).         ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If _nPrcRet < _nPrcAlc6 .Or. _nPrcRet < _nPrcMin
                MsgBox(Alltrim(SubStr(cUsuario,7,15))+", o Prc Venda informado esta fora da sua Alcada. O sistema adotara o Preco de Venda de acordo com sua Alcada que e de 10%","Validacao de Preco de Venda X Alcada","Alert")
                _nPrcRet:= _nPrcAlc6
                TMP1->CK_VALOR  := Round(_nPrcRet*TMP1->CK_QTDVEN,2)
                TMP1->CK_DESCONT:= 100-((_nPrcRet/TMP1->CK_PRUNIT)*100)
                TMP1->CK_VALDESC:= Round(((TMP1->CK_PRUNIT*TMP1->CK_DESCONT)/100)*TMP1->CK_QTDVEN,2)
            EndIf
        Else
            _nPrcAlc5:= Round(_nPrcDesc * 0.95,2)
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Verifico se o Preco de Venda digitado esta dentro da Alcada do usuario,  ³
            //³ Caso verdadeiro, considero o Preco Final de Retorno (_nPrcRet) igual ao  ³
            //³ ao Preco de Venda digitado (_nPrcFim), se nao o Preco Final de Retorno   ³
            //³ (_nPrcRet) sera igual ao Preco da Alcada do usuario (_nPrcAlc5).         ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If _nPrcRet < _nPrcAlc5 .Or. _nPrcRet < _nPrcMin
                MsgBox(Alltrim(SubStr(cUsuario,7,15))+", o Prc Venda informado esta fora da sua Alcada. O sistema adotara o Preco de Venda de acordo com sua Alcada que e de 5%","Validacao de Preco de Venda X Alcada","Alert")
                _nPrcRet:= _nPrcAlc5
                TMP1->CK_VALOR  := Round(_nPrcRet*TMP1->CK_QTDVEN,2)
                TMP1->CK_DESCONT:= 100-((_nPrcRet/TMP1->CK_PRUNIT)*100)
                TMP1->CK_VALDESC:= Round(((TMP1->CK_PRUNIT*TMP1->CK_DESCONT)/100)*TMP1->CK_QTDVEN,2)
            EndIf
        EndIf
            TMP1->CK_VALOR  := Round(_nPrcRet*TMP1->CK_QTDVEN,2)
            TMP1->CK_DESCONT:= 100-((_nPrcRet/TMP1->CK_PRUNIT)*100)
            TMP1->CK_VALDESC:= Round(((TMP1->CK_PRUNIT*TMP1->CK_DESCONT)/100)*TMP1->CK_QTDVEN,2)
     EndIf
//EndIf

DbSelectArea(_cAlias)
DbSetOrder(_Index)
DbGoTo(_nRec)

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __Return(_nPrcRet)
Return(_nPrcRet)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
