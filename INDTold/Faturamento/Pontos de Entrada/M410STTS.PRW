#include "rwmake.ch"
/*_____________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+--------------------------+¦¦
¦¦¦ Função    ¦ M410STTS   ¦                              ¦ Data ¦ 01/10/2007               ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+--------------------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada para validar o pedido de venda.                            ¦¦¦
¦¦+-----------+-----------------------------------------------------------------------------+¦¦
¦¦¦ Retorno   ¦ Nenhum                                                                      ¦¦¦
¦¦+-----------+-----------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function M410STTS

Local cPedido  := SC5->C5_NUM // Numero do Pedido de Vendas
Local cAlias   := Alias()     // Alias atual
Local nRecNo   := Recno()     // Registro em que o ponteiro esta posicionado
Local nIndex   := IndexOrd()  // Indice atual
Local lRet     := .F.
Local cViagem  := ""
Local cTreinam := ""
Local cCopia   := ""

Private cObjetiv := ""
Private oDlgPed  := NIL
Private lContinua:= .T. // Variavel utilizada para checar se o botao Salvar foi clicado

If Type("c_Pedido") == "U" // Se variavel nao existir declara, senao atribui somente valor
	Private c_Pedido:= ""
Endif

If !(inclui .Or. altera)
	RETURN
Endif
//  .---------------------------------------------------------------------------------------.
// |     Caso seja uma copia de pedido pega o detalhamento da receita do pedido original     |
//  '---------------------------------------------------------------------------------------'
If !Empty(c_Pedido)
	dbSelectArea("SZ6")                    //  .---------------------------.
	dbSetOrder(1)                          // |     Filial + Tipo + Num     |
	If dbSeek(xFilial("SZ6")+"6"+c_Pedido) //  '---------------------------'
		cObjetiv:= SZ6->Z6_OBJETIV
		c_Pedido:= ""
		lret:= .t.
	Endif
Endif

If !lret
   //  .-------------------------------.
	// |     Detalhamento da Receita     |
	//  '-------------------------------'
	dbSelectArea("SZ6")                   //  .---------------------------.
	dbSetOrder(1)                         // |     Filial + Tipo + Num     |
	If dbSeek(xFilial("SZ6")+"6"+cPedido) //  '---------------------------'
		cObjetiv:= SZ6->Z6_OBJETIV
		c_Pedido:= ""
		lret:= .t.
	Endif
Endif

If !lret
   //  .-------------------------------.
	// |     Item do pedido de venda     |
	//  '-------------------------------'
	DbSelectArea("SC6")
	DbSetOrder(1)
	If DbSeek(xFilial("SC6")+cPedido)
		cViagem  := SC6->C6_VIAGEM
		cTreinam := SC6->C6_TREINAM
	Endif
Endif
//  .-------------------.
// |     Treinamento     |
//  '-------------------'
If !lret .and. !Empty(cTreinam)
	If dbSeek(XFILIAL("SZ6")+"5"+cTreinam)
		cObjetiv:= SZ6->Z6_OBJETIV
		lret:= .t.
	Endif
Endif
//  .--------------.
// |     Viagem     |
//  '--------------'
If !lret .and. !Empty(cViagem)
	If dbSeek(XFILIAL("SZ6")+"3"+cViagem)
		cObjetiv:= SZ6->Z6_OBJETIV
	Endif
Endif

While lContinua
   //  .---------------------------------------------------.
	// |     Cria a tela solicitando os dados dos campos     |
	//  '---------------------------------------------------'
	@ 116,090 TO 616,407 DIALOG oDlgPed TITLE "Detalhamento da Receita"
	@ 003,002 TO 030,150
	@ 012,008 Say OemToAnsi("Detalhamento da Receita do Pedido "+ Alltrim(cPedido))
	@ 045,002 Get cObjetiv   Size 120,080+80  MEMO                 Object oMemo
	
	@ 220,010 Button OemToAnsi("_Salvar")         Size 36,16 Action FRSalva(cPedido)
	Activate Dialog oDlgPed Centered
End

dbSelectArea(cAlias)
dbSetOrder(nIndex)
dbGoto(nRecno)

Return
//
//
//
Static Function FRSalva(cPedido)
If !Empty(cObjetiv)
	Close(oDlgPed)
	dbSelectArea("SZ6")
	dbSetOrder(1) //Filial + Tipo + Num
	If dbSeek(xFilial("SZ6")+"6"+cPedido)
		RecLock("SZ6",.F.)
	Else
		RecLock("SZ6",.T.)
	EndIf
	SZ6->Z6_FILIAL  := xFilial()
	SZ6->Z6_TIPO    := "6"
	SZ6->Z6_NUM     := cPedido
	SZ6->Z6_OBJETIV := cObjetiv
	MsUnlock()
	lContinua := .F.
Else
	If Empty(cObjetiv)
		Alert("É obrigatório o preenchimento do campo de detalhamento da receita.")
	Endif
Endif
Return
//
//
//
Static function Valida()
Local nLin := 0
Local cStr :=" "
Local i 
If Len(AllTrim(cObjetiv))<>0
	nLin := MlCount(cObjetiv,43)
	For i:= 1 to nLin
		cStr += MemoLine(cObjetiv,43,i,,.F.)
	Next
	cObjetiv := cStr
EndIf
Return 
