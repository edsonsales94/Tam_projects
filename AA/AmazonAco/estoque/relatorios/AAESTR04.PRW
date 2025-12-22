#INCLUDE "rwmake.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAESTR04   ¦ Autor ¦ Nilson Neto          ¦ Data ¦ 19/03/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Relatório de Puxadas por Transportadora/Motorista             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAESTR04(cType, cItem, cDescItem, aItems)
	Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2  := "de acordo com os parametros informados pelo usuario."
	Local cDesc3  := "Relatório de Puxadas por " + cType
	Local titulo  := "Relatório de Puxadas por " + cType
	Local nLin    := 80
	Local aOrd 	  := {} 
	Local Cabec1  := ""
	Local Cabec2  := ""
	
	Private cString    := iif (cType = "Transportadora", "SA4", "SZF")	
	Private lEnd       := .F.
	Private m_pag      := 01
	Private tamanho    := "M"
	Private nTipo      := 15
	Private limite     := 132
	Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey   := 0
	Private nomeprog   := "AAFATR04"
	Private lAbortPrint:= .F.
	Private wnrel      := "AAFATR04"
	
	If Empty(aItems) .Or. Len(aItems) == 1 .And. Empty(aItems[1,1])
		MsgAlert("Não existem dados a imprimir !")
		Return
	Endif
	
	wnrel := SetPrint(cString,wnrel,,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)
	
	If (nLastKey == 27)
		Return Nil
	Endif
	
	SetDefault(aReturn,cString)
	
	If (nLastKey == 27)
		Return Nil
	Endif
	
	nTipo  := If(aReturn[4]==1,15,18)	
	Cabec1 := cType + ": "+AllTrim(cItem)+" - "+cDescItem
	Cabec2 := "Pack-List        Nota    Serie       Quant NF   Quant Puxada  Saldo Transito          Valor  Fornecedor"
			//   xxxxxxxxxxxxxxx  xxxxxxxxx-xxx  99,999,999.99  99,999,999.99  999,999,999.99  99,999,999.99  xxxxxx - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
			//   000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111
			//   000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233
			//   012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,aItems) },Titulo)
Return Nil

//-------------------------------------------------------------------
//-    No duplo Clique, mostra uma tela com todos os itens          -
//-      Desenvolvida por: Nilson Neto          Data: 24/03         -
//-------------------------------------------------------------------
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
Return Nil
//Sit laus Deo Patri, summo Christo decus, Spiritui Sancot tribus honor unus