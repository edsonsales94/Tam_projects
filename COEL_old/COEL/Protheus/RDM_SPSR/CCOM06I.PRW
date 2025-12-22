#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/09/02

User Function Ccom06i()        // incluido pelo assistente de conversao do AP6 IDE em 12/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CALIAS,_NORDER,_NRECNO,_CPROD,_NVUNIT,_CPEDIDO")
SetPrvt("_CTES,NPOS,_CITEMPC,_C7ORD,_NMOED,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CCOM06I  ³ Autor ³ RICARDO CORREA SOUZA  ³ Data ³ 18/01/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ MOSTRA AO USUARIO NO MOMENTO DA DIGITACAO NF ENTRADA SE O  ³±±
±±³          ³ PEDIDO DE COMPRA FOI NEGOCIADO EM DOLAR OU NAO.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para COEL                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

_cAlias := Alias()
_nOrder := IndexOrd()
_nRecno := Recno()
_cProd  := ""
_nVunit := 0
_cPedido:= Space(6)
_cTes   := Space(3)
NPOS:=ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_COD"})
_cProd:=aCols[n,npos]

NPOS:=ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_PEDIDO"})
_cPedido :=aCols[n,npos]

NPOS:=ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_ITEMPC"})
_cItemPC :=aCols[n,npos]

NPOS:=ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_TES"})
_cTes:=aCols[n,npos]

DbSelectArea("SC7")
_C7Ord:= IndexOrd()

DbSetOrder(4)
If DbSeek(xFilial("SC7")+_cProd+_cPedido+_cItemPC)
    _nMoed := SC7->C7_MOEDA
	 IF SC7->C7_QTDACLA = 0     ///Coelmatic: 31/05/12 - Quando nao for Pre-nota.
	 
		If _nMoed == 2 .Or. _nMoed == 4 .Or. _nMoed == 5 .Or. _nMoed == 6 .Or. _nMoed == 7 .Or. _nMoed == 8 .Or. _nMoed == 9
			MsgBox("Pedido Negociado em "+Iif(_nMoed == 2,"Dolar ",Iif(_nMoed == 4,"Marco Alemao ",Iif(_nMoed == 5,"Lira Italiana ",Iif(_nMoed == 6,"Franco Suico ",Iif(_nMoed == 7,"Franco Frances ",Iif(_nMoed == 8,"Yene ","Euro "))))))+", pressione < ENTER > no campo Preco Unitario para que o sistema converta o preco de acordo com a data de emissao da nota","CONVERSAO PRECO","ALERT")
		EndIf
		
	 ENDIF	
EndIf
DbSetOrder(_C7Ord)
DbSelectArea(_cAlias)
DbSetOrder(_nOrder)
DbGoTo(_nRecno)

// Substituido pelo assistente de conversao do AP6 IDE em 12/09/02 ==> __RETURN(_cTes)
Return(_cTes)        // incluido pelo assistente de conversao do AP6 IDE em 12/09/02
