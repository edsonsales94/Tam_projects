#INCLUDE "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAESTR03   ¦ Autor ¦ ADRIANO LIMA         ¦ Data ¦ 13/03/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Relatório de Puxadas por Produto		                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAESTR03(cProd, aItems)
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatório de Puxadas por Produto "
Local titulo         := "Relatório de Puxadas por Produto"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local aOrd           := {}
Local cPerg          := ""

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "AAFATR03" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private m_pag        := 01
Private wnrel        := "AAFATR03" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := "SB1"

SB1->(dbSetOrder(1))

If Empty(aItems) .Or. Len(aItems) == 1 .And. Empty(aItems[1,1])
	MsgAlert("Não existem dados a imprimir !")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel, ,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Cabec1 := "Produto: " + AllTrim(cProd)+" - "+Posicione("SB1",1,XFILIAL("SB1")+cProd,"B1_DESC")
Cabec2 := "Pack-List        Nota    Serie       Quant NF   Quant Puxada  Saldo Transito          Valor  Fornecedor"
		//   xxxxxxxxxxxxxxx  xxxxxxxxx-xxx  99,999,999.99  99,999,999.99  999,999,999.99  99,999,999.99  xxxxxx - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
		//   000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111
		//   000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233
		//   012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,aItems) },Titulo)

Return


/*/
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,aItems)
	Local x
	Local nTotal := 0
	
	SetRegua(RecCount())
	
	For x:=1 To Len(aItems)
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 60
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1 //gera a folha com o cabecalho
		Endif
		
		@nLin,000      PSAY aItems[x][2]
		@nLin,PCol()+2 PSAY aItems[x][3]+" "+aItems[x][4]
		@nLin,PCol()+2 PSAY Transform(aItems[x][5],"@E 99,999,999.99")
		@nLin,PCol()+2 PSAY Transform(aItems[x][6],"@E 99,999,999.99")
		@nLin,PCol()+2 PSAY Transform(aItems[x][7],"@E 999,999,999.99")
		@nLin,PCol()+2 PSAY Transform(aItems[x][10],"@E 99,999,999.99")
		@nLin,PCol()+2 PSAY aItems[x][9]+" - "+PADR(Posicione("SA2",1,XFILIAL("SA2")+aItems[x][9]+aItems[x][8],"A2_NOME"),30)
		nLin++
		
		nTotal += aItems[x][10]
	Next
	If nTotal > 0
		nLin++
		@nLin,061      PSAY PADR("Total",14)
		@nLin,PCol()+2 PSAY Transform(nTotal,"@E 999,999,999.99")
		nLin++
		@nLin,000      PSAY __PrtThinLine()
	Endif
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return