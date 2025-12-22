#INCLUDE "rwmake.ch"

User Function RES_RLOC()
Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2     := "de acordo com os parametros informados pelo usuario."
Local cDesc3     := "Resumo de Caixa Receber no Local "
Local cPict      := ""
Local titulo     := "Resumo de Caixa Receber no Local "
Local nLin       := 80
Local Cabec1     := "Tp Orcam    Pref. Num. Vencimento       Valor  Parc.    Cliente                     Caixa              F. Pagamento"
Local Cabec2     := ""
Local aOrd       := {}
Local cPerg      := Padr("RLOC"+SM0->M0_CODFIL,Len(SX1->X1_GRUPO))

Private limite   := 132
Private tamanho  := "M"
Private nomeprog := "RLOC"+SM0->M0_CODFIL // Coloque aqui o nome do programa para impressao no cabecalho
Private nLin     := 70
Private nTipo    := 15
Private aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey := 0
Private m_pag    := 01
Private wnrel    := "RLOC"+SM0->M0_CODFIL // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString  := "SE1"

ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
	Return
Endif

dbSelectArea("SE1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  10/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local aDbf, cArq, cInd, cQry,  bImp, nPDESC, nPRCTAB, nPICM, cSIMBCOM, cNumSer, cCondPG, cNaturez
Local cData    := DTOS(MV_PAR01)
Local vTitulo  := {}
Local nValTOT  := 0 
Local nValTOTGer:= 0
Local nValCR   := 0
Local cCX1     := If( Empty(MV_PAR02) , "ZZZ", MV_PAR02)
Local cCX2     := If( Empty(MV_PAR03) , "ZZZ", MV_PAR03)
//Local cCX3     := If( Empty(MV_PAR04) , "ZZZ", MV_PAR04)
//Local cCX4     := If( Empty(MV_PAR05) , "ZZZ", MV_PAR05)
//Local cCX5     := If( Empty(MV_PAR06) , "ZZZ", MV_PAR06)

		Private aDriver := ReadDriver()
		
		DbSelectArea("SE1")
		DbSetOrder(1)
		
		DbSelectArea("SA1")
		DbSetOrder(1)
		
		DbSelectArea("SA3")
		DbSetOrder(1)
		
		DbSelectArea("SA6")
		DbSetOrder(1)
		
		DbSelectArea("SL1")
		DbSetOrder(2)
		
		/*********************************************************************************************************/
		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		@ nLin, 00 PSAY "Data de Fechamento : "+ DTOC(MV_PAR01)
		nLin := nLin + 2
		
		AAdd( vTitulo , " LISTA DOS RECEBIMENTOS DO DIA - RECEBER NO LOCAL")
		
		cQry := "SELECT E1_TIPO, E1_NUM, E1_PREFIXO, E1_PARCELA, E1_VENCREA, E1_CLIENTE, E1_LOJA, E1_VALOR, E1_VLRREAL, E1_PORTADO, E1_VEND1, L1_NUM, L1_DOC, L1_SERIE, E1_NATUREZ, E1_DTRECEB"
		cQry += " FROM "+RetSQLName("SE1")+" E1, "+RetSQLName("SL1")+" L1 "
		cQry += " WHERE E1_DTRECEB = '"+Dtos(MV_par01)+"' AND "
		cQry += " E1.D_E_L_E_T_ <> '*' AND L1.D_E_L_E_T_ <> '*' AND "
		cQry += " (E1_NUM = L1_DOC OR E1_NUM = L1_DOCPED) AND (E1_PREFIXO = L1_SERIE OR E1_PREFIXO = L1_SERPED) AND "
		cQry += " E1_ORIGEM  IN ('LOJA010','LOJA701') AND "
		cQry += " E1_TIPO NOT IN ('NCC') AND "
		cQry += " (E1_PORTADO IN ("
		cQry += " '"+cCX1+"','"+cCX2+"')"+"  OR E1_BCORIG IN ('"+cCX1+"','"+cCX2+"') )"

		cQry += " ORDER BY E1_NATUREZ, E1_TIPO, L1_NUM, E1_PREFIXO, E1_NUM, E1_PARCELA "
		
		dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRE", .T., .F. )
		dbSelectArea("TRE")
		dbGoTop()
		
		While !EOF()
			
			cNaturez := E1_NATUREZ
			nValTot:= 0
			nValor := 0
			
			If nLin > 60  // Salto de Página. Neste caso o formulario tem 60 linhas...
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
			Endif
			
			While !EOF() .And. E1_NATUREZ == cNaturez
				
				SA1->(DbSeek(xFilial("SA1")+TRE->(E1_CLIENTE+E1_LOJA)))
				SA3->(DbSeek(xFilial("SA3")+TRE->E1_VEND1))
				SA6->(DbSeek(xFilial("SA6")+TRE->E1_PORTADO))
				SE1->(DbSeek(xFilial("SE1")+TRE->E1_PREFIXO+TRE->E1_NUM))
				
				If Alltrim(E1_TIPO) $ "CC"
					
					cNum := L1_NUM
					nValCC := 0
					nNumPar:= 0
					
					While !EOF() .And. E1_NATUREZ == cNaturez .And. L1_NUM == cNum
						
						nValCC  += E1_VLRREAL
						nNumPar += 1
						TRE->(DbSkip())
						
					EndDo
					lSkip := .F.
					nValor := nValCC
					
				Else
					nValor :=  E1_VALOR
					lSkip := .T.
				Endif
				
				@nLin,000 PSAY IIf(Alltrim(E1_TIPO) $ "CC", SE1->E1_TIPO,TRE->E1_TIPO)
				@nLin,004 PSAY IIf(Alltrim(E1_TIPO) $ "CC", cNum,TRE->L1_NUM)
				@nLin,012 PSAY IIf(Alltrim(E1_TIPO) $ "CC", SE1->E1_PREFIXO, TRE->E1_PREFIXO)
				@nLin,016 PSAY IIf(Alltrim(E1_TIPO) $ "CC", SE1->E1_NUM,TRE->E1_NUM)
				@nLin,026 PSAY IIf(Alltrim(E1_TIPO) $ "CC", SE1->E1_VENCREA,DTOC(STOD(TRE->E1_VENCREA)))
				@nLin,035 PSAY Transform(nValor,"@E 9,999,999.99")
				@nLin,048 PSAY IIf(Alltrim(E1_TIPO) $ "CC",nNumPar,E1_PARCELA)
				@nLin,053 PSAY IIf(Alltrim(E1_TIPO) $ "CC", SE1->E1_CLIENTE+" / "+SE1->E1_LOJA,TRE->E1_CLIENTE+" / "+TRE->E1_LOJA)
				@nLin,065 PSAY Left(SA1->A1_NOME,15)
				@nLin,082 PSAY IIf(Alltrim(E1_TIPO) $ "CC", SE1->E1_PORTADO,TRE->E1_PORTADO)
				@nLin,087 PSAY Left(SA6->A6_NOME,15)
				@nLin,104 PSAY IIf(Alltrim(E1_TIPO) $ "CC", SE1->E1_NATUREZ,TRE->E1_NATUREZ)
//				@nLin,PCol()+1 PSAY Left(SA3->A3_NOME,15)
				
				nLin := nLin + 1 // Avanca a linha de impressao
				
				If nLin > 60  // Salto de Página. Neste caso o formulario tem 60 linhas...
					nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
				Endif
				
				nValTot += nValor

				If lSkip
					dbSkip()
				Endif
			EndDo
			
			@nLin,010 PSAY "Sub-Valor : "
			@nLin,033 PSAY Transform(nVALTOT,"@E 999,999,999.99")

			nLin    	:= nLin + 2 // Avanca a linha de impressao
			nValTotGer 	+= nValTot
			
		Enddo
		
		nLin:= nLin + 1
		@nLin,020 PSAY "Valor do Fechamento           : "
		@nLin,078 PSAY Transform(nVALTOTGER,"@E 999,999,999.99")
		
		nLin:= nLin + 2
//		@nLin,020 PSAY "Valor de Creditos/Trocas no Dia: "
//		@nLin,078 PSAY Transform(nVALCR,"@E 999,999,999.99")
		
		dbCloseArea()
		If aReturn[5]==1
			dbCommitAll()
			SET PRINTER TO
			OurSpool(wnrel)
		Endif
		MS_FLUSH()
		Return()
		
		/*_______________________________________________________________________________
		¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
		¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
		¦¦¦ Função    ¦ ValidPerg  ¦ Autor ¦ Alidio   S. Ribeiro  ¦ Data ¦ 17/11/2006 ¦¦¦
		¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
		¦¦¦ Descriçäo ¦ Generico function                                             ¦¦¦
		¦¦+-----------+---------------------------------------------------------------+¦¦
		¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
		¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
		Static Function ValidPerg(cPerg)
		PutSX1(cPerg,"01","Data "    ,"Data "    ,"Data "   ,"mv_ch1","D",8,0,0,"G","","   ","","","mv_par01")
		PutSX1(cPerg,"02","1o Caixa ","1o Caixa ","1o Caixa","mv_ch2","C",3,0,0,"G","","SA6","","","mv_par02")
		PutSX1(cPerg,"03","2o Caixa" ,"2o Caixa ","2o Caixa","mv_ch3","C",3,0,0,"G","","SA6","","","mv_par03")
//		PutSX1(cPerg,"04","3o Caixa" ,"3o Caixa ","3o Caixa","mv_ch4","C",3,0,0,"G","","SA6","","","mv_par04") 
//		PutSX1(cPerg,"05","4o Caixa" ,"4o Caixa ","4o Caixa","mv_ch5","C",3,0,0,"G","","SA6","","","mv_par05") 
//		PutSX1(cPerg,"06","5o Caixa" ,"5o Caixa ","5o Caixa","mv_ch6","C",3,0,0,"G","","SA6","","","mv_par06")
		Return
