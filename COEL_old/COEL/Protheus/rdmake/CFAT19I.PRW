#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 05/11/02

User Function CFAT19I()        // incluido pelo assistente de conversao do AP6 IDE em 05/11/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,NMIDIA,CBTXT")
SetPrvt("CBCONT,NORDEM,TAMANHO,NLIMITE,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,WNREL,CPERG,CSTRING,XPEDIDOS,NLIN")
SetPrvt("I,XITENS,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT19I  ³ Autor ³Ricardo Correa de Souza³ Data ³03.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Rotina que verifica a posicao do cliente selecionado nos    ³±±
±±³          ³parametros (Rotina chamada no CFAT18I.PRW)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Coel Controles Eletricos Ltda                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// *** mv_par01 - data de emissao de
// *** mv_par02 - data de emissao ate'
// *** mv_par03 - 1 => todos os itens / 2 => Somente Itens com saldo
// ***

DbSelectArea("SC6")             // Itens Pedidos Venda
DbSetOrder(5)                   // Cod. Cliente + Loja

If !DbSeek( xFilial("SC6")+SA1->A1_COD+SA1->A1_LOJA )
	MsgBox( "Nao ha pedidos colocados para este cliente.", "Mensagem" )
	DbSelectArea("SA1")
	Return
EndIf

Titulo := PadC(OemToAnsi("Posicao de Pedidos do Cliente"),74)
cDesc1 := PadC(OemToAnsi("Este programa ira emitir a Posi‡„o do Cliente Selecionado"),74)
cDesc2 := PadC(OemToAnsi(""),74)
cDesc3 := PadC(OemToAnsi(""),74)

nMidia := 1
cbTxt   := ""
cbCont	:= ""
nOrdem 	:= 0
Tamanho   := "P"
nLimite   := 132
aReturn   := { "Especial", 1,"Depto Comercial", 2, nMidia, 1,"", 1 }
NomeProg  := "CLPOSIX"
nLastKey  := 0
wnrel     := "FAT19I"
cPerg     := "CLPOSX"
cString   := "SC6"

If Pergunte( cPerg, .T. ) == .F.
	Return
Endif

wnrel := SetPrint(cString,wnrel,"",Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault( aReturn , cString )

If nLastKey == 27
	Return
EndIf

RptStatus({|| _CLPOSIX()})// Substituido pelo assistente de conversao do AP6 IDE em 05/11/02 ==>        RptStatus({|| Execute(_CLPOSIX)})

DbSelectArea("SA1")
// Substituido pelo assistente de conversao do AP6 IDE em 05/11/02 ==> __Return( .T. )
Return( .T. )        // incluido pelo assistente de conversao do AP6 IDE em 05/11/02

*****************************************************************************
*****************************************************************************
// Substituido pelo assistente de conversao do AP6 IDE em 05/11/02 ==> Function _CLPOSIX
Static Function _CLPOSIX()

SetRegua((mv_par02-mv_par01)*3)
xPEDIDOS := {}

DbSelectArea("SB1")             // Produtos
DbSetOrder(1)                   // Codigo

DbSelectArea("SC5")             // Pedidos de Venda
DbSetOrder(1)                   // Numero do Pedido

DbSelectArea("SC6")             // Itens Pedidos Venda
DbSetOrder(5)                   // Cod. Cliente + Loja

DbSeek( xFilial("SC6")+SA1->A1_COD+SA1->A1_LOJA,.T. )

Do While !Eof() .AND. SC6->C6_FILIAL==xFilial("SC6") .AND. SC6->C6_CLI==SA1->A1_COD .AND. SC6->C6_LOJA==SA1->A1_LOJA
	
	IncRegua()
	
	// ** Verifica se a data de emissao do pedido esta' entre os parametros 1 e 2
	
	DbSelectArea("SC5")
	If !DbSeek( xFilial("SC5")+SC6->C6_NUM ) .OR. SC5->C5_EMISSAO < mv_par01 .OR. SC5->C5_EMISSAO > mv_par02
		DbSelectArea("SC6")
		DbSkip()
		Loop
	EndIf
	
	// ** Cria uma array com os pedidos do cliente sem repetir o numero
	
	If Ascan( xPEDIDOS, SC6->C6_NUM ) == 0
		Aadd( xPEDIDOS, SC6->C6_NUM )
	EndIf
	
	DbSelectArea("SC6")
	DbSkip()
	
EndDo

// ** array de pedidos em ordem ascendente

ASort( xPEDIDOS )

// ** Inicio da Impressao

@ 00, 00 PSAY AvalImp( nLimite )
@ 01, 00 PSAY "POSICAO DE PEDIDOS DO CLIENTE  " + Iif( mv_par03==1, "", "- Pedidos Pendentes" )
@ 01, 99 PSAY "DATA: " + DTOC( Date() )
@ 02, 00 PSAY "CFAT19I - "+RTRIM(SM0->M0_NOME)+"/"+SM0->M0_FILIAL
@ 04, 00 PSAY SA1->A1_COD + " - " + SA1->A1_LOJA + " - " + SA1->A1_NOME

@ 05, 00 PSAY Replic("-",125)
//               ..........1.........2.........3.........4.........5.........6.........7.........8.........9.........10........11........12....
//               0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
@ 06  , 00 PSAY "N/PEDIDO PED.CLIENTE  EMISSAO   ENTREGA  CODIGO           DESCRICAO           QTD PEDIDO     QTD FAT   NF         DATA NF"
@ 07  , 00 PSAY Replic("-",125)
nLin := 08

DbSelectArea("SC6")       // Itens dos Pedidos
DbSetOrder(12)             // Numero Pedido + Codigo Produto (Indice Especifico)

SetRegua( Len(xPEDIDOS) )

For i := 1 To Len( xPEDIDOS )
	
	IncRegua()
	
	DbSelectArea("SC5")
	DbSeek( xFilial("SC5")+xPEDIDOS[i] )
	
	DbSelectArea("SC6")
	DbSeek( xFilial("SC6")+xPEDIDOS[i],.T. )
	xItens := .F.
	
	Do While !Eof() .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM == xPEDIDOS[i]
		
		// ** Verifica se o item corresponde a pergunta 03
		
		If mv_par03==2 .AND. SC6->C6_QTDVEN - SC6->C6_QTDENT <= 0
			DbSkip()
			Loop
		EndIf
		
		If nLin == 1
			@ nLin, 00 PSAY Replic("-",125)
			//               ..........1.........2.........3.........4.........5.........6.........7.........8.........9.........10........11........12....
			//               0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
			@ 02  , 00 PSAY "N/PEDIDO PED.CLIENTE  EMISSAO   ENTREGA  CODIGO           DESCRICAO           QTD PEDIDO     QTD FAT   NF         DATA NF"
			@ 03  , 00 PSAY Replic("-",125)
			nLin := 04
		ElseIf nLin > 58
			nLin := 1
			Loop
		EndIf
		
		DbSelectArea("SB1")
		DbSeek( xFilial("SB1") + SC6->C6_PRODUTO )
		
		@ nLin, 00 PSAY SC6->C6_NUM
		@ nLin, 09 PSAY SC5->C5_CLPEDCL
		@ nLin, 22 PSAY SC5->C5_EMISSAO
		@ nLin, 32 PSAY SC6->C6_ENTREG
		@ nLin, 41 PSAY LEFT(SC6->C6_PRODUTO,16)               ///Picture"@R 99.999.999"
		@ nLin, 58 PSAY Subst( SB1->B1_DESC, 1, 20 )
		@ nLin, 78 PSAY SC6->C6_QTDVEN                Picture"@E 999,999.99"
		@ nLin, 90 PSAY SC6->C6_QTDENT                Picture"@E 999,999.99"
		@ nLin,103 PSAY SC6->C6_NOTA
		@ nLin,114 PSAY Iif( Empty(SC6->C6_DATFAT), "", SC6->C6_DATFAT )
		
		xItens := .T.
		nLin := nLin + 1
		
		DbSelectArea("SC6")
		DbSkip()
		
	EndDo
	
	If xItens == .T.
		nLin := nLin + 1
	EndIf
	
Next

@ nLin, 00 PSAY Replic("-",125)
nLin := nLin + 1
@ nLin, 00 PSAY "FIM DO RELATORIO"
nLin := nLin + 1
@ nLin, 00 PSAY Replic("-",125)

nLin := 0
@ nLin, 00 PSAY ""
SetPrc(0,0)

DbSelectArea("SC6")       // Itens dos Pedidos
DbSetOrder(1)		  // Numero Pedido + Codigo Produto (Indice Especifico)

Set device to Screen

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return
*****************************************************************************
*****************************************************************************

