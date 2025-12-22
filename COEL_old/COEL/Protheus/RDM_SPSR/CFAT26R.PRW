#include "rwmake.ch"

User Function Cfat26r()

SetPrvt("AESTRU1,_CTEMP1,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN")
SetPrvt("M_PAG,_NTQTD,_NQTD,_CQUEBRA,_CINDEX,_CCHAVE")
SetPrvt("_CFILTRO,_CTEXTO,_NQTDSALDO,_NQTDRES,CABEC1,CABEC2")
SetPrvt("REGUA1,REGUA2,_C,ATOTAIS,_COL,NQTD")
SetPrvt("ASEMANA,I,AREGS,J,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT26R  ³ Autor ³Ricardo Correa de Souza³ Data ³27/04/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Pedidos de Vendas em Aberto por Tipo de Cliente ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ HAMILTON     ³10/05/01³ Adaptacao do CFAT25R                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

*---------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*

DbSelectArea("SA1")         //----> Cadastro de Clientes
DbSetOrder(1)               //----> Codigo + Loja

DbSelectArea("SA3")         //----> Cadastro de Vendedores
DbSetOrder(1)               //----> Codigo

DbSelectArea("SB1")         //----> Cadastro de Produtos
DbSetOrder(1)               //----> Codigo

DbSelectArea("SC5")         //----> Cabecalho de Pedidos de Vendas
DbSetOrder(2)               //----> Data de Emissao + Pedido

DbSelectArea("SC6")         //----> Itens de Pedidos de Vendas
DbSetOrder(1)               //----> Pedido + Item

DbSelectArea("SC0")         //----> Controle de Reservas de Pedidos de Vendas
DbSetOrder(3)               //----> Pedido + Item + Produto + Local + Reserva

*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*

aEstru1 :={}
AADD(aEstru1,{"PROD"    ,"C",15,0})
AADD(aEstru1,{"DESCR"   ,"C",30,0})
AADD(aEstru1,{"SEMANA"  ,"N",02,0})
AADD(aEstru1,{"QTDSAL"  ,"N",09,2})
AADD(aEstru1,{"DT"      ,"D",08,0})
AADD(aEstru1,{"PEDIDO"  ,"C",06,0})
_cTemp1 := CriaTrab( aEstru1, .T. )
dbUseArea(.T.,,_cTemp1,"TRB", NIL, .F. )

*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*

wnrel     := "CFAT26R"
cDesc1    := "Emissao dos pedidos de em aberto considerando a"
cDesc2    := "reserva, conforme parametros selecionados.     "
cDesc3    := " "
cString   := "SC6"
lEnd      := .F.
tamanho   := "M"
limite    := 132
titulo    := "Pedidos em Aberto - Acumulado por Semana"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "CFAT26R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT26R"
nLin      := 8
m_pag     := 1
_nTQtd    := 0
_nQtd     := 0
_cQuebra  := ""

*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Ate a Semana   ?                                          *
* mv_par02  ----> Do Produto     ?                                          *
* mv_par03  ----> Ate o Produto  ?                                          *
*                                                                           *
*---------------------------------------------------------------------------*

ValidPerg()     //----> Atualiza o arquivo de perguntas SX1

Pergunte(cPerg,.F.)


wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	DbSelectArea("TRB")
	DbCloseArea("TRB")
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	DbSelectArea("TRB")
	DbCloseArea("TRB")
	Set Filter to
	Return
Endif

*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*

If nLastKey <> 27
	Processa({||RunProc()},"Filtrando Dados ...")
endif

Return

Static Function RunProc()

_cIndex := CriaTrab(Nil,.f.)
_cChave := "C6_FILIAL+C6_PRODUTO"
_cFiltro:= "C6_FILIAL == SM0->M0_CODFIL"
_cTexto := "Produto"

DbSelectArea("SC6")
IndRegua("SC6",_cIndex,_cChave,_cFiltro,,"Indexando por "+_cTexto)
ProcRegua(RecCount())
DbSeek(xFilial("SC6"))//"02")
Do While !Eof() .And. SC6->C6_FILIAL == xFilial("SC6") //"02"
	
	IncProc("Selecionando Dados do Pedido: "+SC6->C6_NUM)
	
	//----> filtrando intervalo de datas definido nos parametros
	If SC6->C6_SEMANA > mv_par01
		DbSkip()
		Loop
	EndIf
	
	//----> filtrando intervalo de produtos definido nos parametros
	If SC6->C6_PRODUTO < mv_par02 .Or. SC6->C6_PRODUTO > mv_par03
		DbSkip()
		Loop
	EndIf
	
	_nQtdSaldo := SC6->C6_QTDVEN - SC6->C6_QTDENT
	
	//----> filtrando somente pedidos que possuem saldo em aberto
	If _nQtdSaldo <= 0
		DbSelectArea("SC6")
		DbSkip()
		Loop
	EndIf
	
	//----> verificando se existe vinculo da reserva no pedido
	If !Empty(SC6->C6_RESERVA)
		DbSelectArea("SC0")
		If DbSeek(xFilial("SC0")+SC6->C6_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO)
			_nQtdRes := SC0->C0_QTDORIG
		Else
			_nQtdRes := 0
		EndIf
	Else
		DbSelectArea("SC0")
		If DbSeek(xFilial("SC0")+SC6->C6_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO)
			_nQtdRes := SC0->C0_QUANT
		Else
			_nQtdRes := 0
		EndIf
	EndIf
	
	DbSelectArea("SC5")
	DbSetOrder(1)
	DbSeek(xFilial("SC5")+SC6->C6_NUM)
	
	DbSelectArea("TRB")
	RecLock("TRB",.t.)
	TRB->DESCR    := POSICIONE("SB1",1,XFILIAL("SB1")+SC6->C6_PRODUTO,"B1_DESC")
	TRB->QTDSAL   := (SC6->C6_QTDVEN - SC6->C6_QTDENT - _nQtdRes)
	TRB->PROD     := SC6->C6_PRODUTO
	TRB->SEMANA   := SC6->C6_SEMANA
	TRB->DT       := SC6->C6_ENTREG
	TRB->PEDIDO   := SC6->C6_NUM
	MsUnLock()
	
	DbSelectArea("SC6")
	DbSkip()
EndDo

*---------------------------------------------------------------------------*
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*

RptStatus({|| Imprime()},titulo)

Return

Static Function Imprime()

cabec1  := "CODIGO          DESCRICAO  "
cabec2  := "PRODUTO         PRODUTO"+STR(year(Ddatabase)) + "         "
//regua1:= "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012"
//regua2:= "         10        20        30        40        50        60        70        80        90       100       110       120       130  "

for _c := mv_par01-6 to mv_par01
	If _c > 0 .And. _c < mv_par01
		cabec2  := cabec2 + str(_c,2)+"         "
	Endif
	If _c == mv_par01
		cabec2  := cabec2 + str(_c,2)+"        "
	Endif
next

cabec2  := cabec2 + "TOTAL"

DbSelectArea("TRB")
DbGoTop()
SetRegua(Lastrec())

@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
atotais:={0,0,0,0,0,0,0,0,0}
nLin := nLin +1
Do While !Eof()
	_col:=32
	@ nLin, 000 Psay TRB->PROD   Picture "@R 99.999.999"
	@ nLin, 011 Psay subst(TRB->DESCR,1,20)
	_cQuebra := TRB->PROD
	
	nQtd := 0
	aSemana:={0,0,0,0,0,0,0,0}
	While !EOF() .AND. _cQuebra == TRB->PROD
		IncRegua()
		If STR(year(Ddatabase),4) == STR(year(trb->dt),4)
			If trb->semana == mv_par01
				aSemana[8] := aSemana[8] + trb->qtdsal
				aTotais[8] := aTotais[8] + trb->qtdsal
			ElseIf trb->semana == mv_par01-1
				aSemana[7] := aSemana[7] + trb->qtdsal
				aTotais[7] := aTotais[7] + trb->qtdsal
			ElseIf trb->semana == mv_par01-2
				aSemana[6] := aSemana[6] + trb->qtdsal
				aTotais[6] := aTotais[6] + trb->qtdsal
			ElseIf trb->semana == mv_par01-3
				aSemana[5] := aSemana[5] + trb->qtdsal
				aTotais[5] := aTotais[5] + trb->qtdsal
			ElseIf trb->semana == mv_par01-4
				aSemana[4] := aSemana[4] + trb->qtdsal
				aTotais[4] := aTotais[4] + trb->qtdsal
			ElseIf trb->semana == mv_par01-5
				aSemana[3] := aSemana[3] + trb->qtdsal
				aTotais[3] := aTotais[3] + trb->qtdsal
			ElseIf trb->semana <= mv_par01-6
				aSemana[2] := aSemana[2] + trb->qtdsal
				aTotais[2] := aTotais[2] + trb->qtdsal
			EndIf
		ElseIf STR(year(Ddatabase)+1,4) == STR(year(trb->dt),4)
			aSemana[1] := aSemana[1] + trb->qtdsal
			aTotais[1] := aTotais[1] + trb->qtdsal
		Endif
		aTotais[9] := aTotais[9] + trb->qtdsal
		DbSkip()
	EndDo
	
	
	
	For _c := 1 to 8
		@ nLin, _col Psay aSemana[_c] Picture "@E@Z 999,999.99"
		//MsgBox("SEM "+STR(_C)+" "+Str(aSemana[_c]))
		_col:=_col+11
	Next
	
	For i := 1 to 8
		nQtd := nQtd + aSemana[i]
	Next
	
	@ nLin, _col Psay nQtd Picture "@E@Z 9,999,999.99"
	nLin := nLin + 1
	@ nLin, 000  Psay Repl("-",limite)
	nLin := nLin + 1
	
	If nLin > 59
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		nLin := 9
	Endif
	
EndDo

//----> totaliza total geral do relatorio
cabec2  := "                       "+STR(year(Ddatabase)) + "         "
for _c := mv_par01-6 to mv_par01
	If _c > 0 .And. _c < mv_par01
		cabec2  := cabec2 + str(_c,2)+"         "
	Endif
	If _c == mv_par01
		cabec2  := cabec2 + str(_c,2)+"        "
	Endif
next

cabec2  := cabec2 + "TOTAL"

If nLin > 59
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	nLin := 9
Endif

nLin := nLin + 1
@ nLin, 000 Psay Replicate("-",limite)
nLin := nLin + 1
@ nLin, 000 Psay cabec2
nLin := nLin + 1
@ nLin, 000 Psay "Total Geral ---->"
_col:=32
for _c:=1 to 8
	@ nLin, _col Psay aTotais[_c] Picture "@E@Z 999,999.99"
	_col:=_col+11
next
@ nLin, _col Psay aTotais[9] Picture "@E@Z 9,999,999.99"
nLin := nLin + 1
@ nLin, 000 Psay Replicate("-",limite)

If nLin > 59
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	nLin := 9
Endif

Roda(cbCont,"Pedidos",tamanho)

Set Device to Screen

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

DbSelectArea("SC6")
DbGoTop()
RetIndex("SC6")

DbSelectArea("TRB")
DbCloseArea("TRB")
Ferase(_cTemp1+".dbf")
Ferase(_cTemp1+".idx")
Ferase(_cTemp1+".mem")

MS_FLUSH()

Return

*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*

Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
	
	aRegs := {}
	
	aadd(aRegs,{cPerg,'01','Ate a Semana      ? ',"","",'mv_ch1','N',02, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'02','Do Produto        ? ',"","",'mv_ch2','C',15, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'03','Ate o Produto     ? ',"","",'mv_ch3','C',15, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
	For i:=1 to Len(aRegs)
		Dbseek(cPerg+StrZero(i,2))
		If found() == .f.
			RecLock("SX1",.t.)
			For j:=1 to len(aRegs[1])
				FieldPut(j,aRegs[i,j])
			Next
			MsUnLock()
		EndIf
	Next
EndIf

Return(nil)

*---------------------------------------------------------------------------*
* Retorna para sua Chamada (CFAT26R)                                        *
*---------------------------------------------------------------------------*

