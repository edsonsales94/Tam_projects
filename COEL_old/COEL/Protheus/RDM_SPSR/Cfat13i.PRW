#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function Cfat13i()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CALIAS,_NORDER,_NRECNO,_CTES,NPOS,_CCLIENTE")
SetPrvt("_CLOJA,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT13I  ³ Autor ³ RICARDO CORREA SOUZA  ³ Data ³ 16/02/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ MOSTRA AO USUARIO NO MOMENTO DA DIGITACAO DO TES NO PEDIDO ³±±
±±³          ³ DE VENDA SE O CLIENTE PERTENCE A ZONA FRANCA DE MANAUS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ESPECIFICO PARA COEL CONTROLES ELETRICOS LTDA              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

_cAlias := Alias()
_nOrder := IndexOrd()
_nRecno := Recno()
_cTes   := Space(3)

NPOS :=ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="C6_TES"})
_cTes:=aCols[n,npos]

DbSelectArea("SC5")
_cCliente:= M->C5_CLIENTE
_cLoja   := M->C5_LOJACLI

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+_cCliente+_cLoja)
If !Empty(SA1->A1_SUFRAMA)
    If SA1->A1_TIPO == "F"
        MsgBox(Alltrim(SubStr(cUsuario,7,15))+", o cliente "+LEFT(SA1->A1_NREDUZ,10)+" pertence a Zona Franca de Manaus, porem trata-se de um Consumidor Final. Certifique-se que o TES esta correto, ou seja, nao deve calcular o desconto de 7%","ZONA FRANCA DE MANAUS - SEM DESCONTO","Alert")
        MsgBox("Atencao "+Alltrim(SubStr(cUsuario,7,15))+": verifique se o preco de venda ja esta com o desconto de icms de 7%, caso positivo favor digitar os precos sem o desconto de icms, pois o sistema dara' o desconto na emissao da nota","DESCONTO 7% ICMS","Alert")
    Else
        MsgBox(Alltrim(SubStr(cUsuario,7,15))+", o cliente "+LEFT(SA1->A1_NREDUZ,10)+" pertence a Zona Franca de Manaus. Certifique-se que o TES esta correto, ou seja, deve calcular o desconto de 7%","ZONA FRANCA DE MANAUS - COM DESCONTO","Alert")
        MsgBox("Atencao "+Alltrim(SubStr(cUsuario,7,15))+": verifique se o preco de venda ja esta com o desconto de icms de 7%, caso positivo favor digitar os precos sem o desconto de icms, pois o sistema dara' o desconto na emissao da nota","DESCONTO 7% ICMS","Alert")
    EndIf
EndIf

DbSelectArea(_cAlias)
DbSetOrder(_nOrder)
DbGoTo(_nRecno)

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __RETURN(_cTes)
Return(_cTes)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
