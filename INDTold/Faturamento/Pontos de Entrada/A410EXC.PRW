#Include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ A410EXC  ºAutor  ³ Reinaldo Magalhaes º Data ³  01/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E para excluir detalhamento da receita                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ .T. ou .F.                                                 º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A410EXC

Local cAlias  := Alias()          //Alias atual
Local nRecNo  := Recno()          //Registro em que o ponteiro esta posicionado
Local nIndex  := IndexOrd()       //Indice atual
dbSelectArea("SZ6")
dbSetOrder(1) //Filial + Tipo + Num
If dbSeek(xFilial("SZ6")+"6"+SC5->C5_NUM)
	RecLock("SZ6",.F.)
	DELETE
	MsUnlock()
EndIf
dbSelectArea(cAlias)
dbSetOrder(nIndex)
dbGoto(nRecno)

Return .T.
