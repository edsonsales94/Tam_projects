#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ INFINR06 º Autor ³ Ener Fredes        º Data ³  29/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório para conferencia de PA 						  º±±
±±º          ³ 										                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ INDT                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function INFINR06
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Posição de PA's "
Local titulo        := "Posição das PA's"
Local nLin          := 80
Local Cabec1        := ""
Local Cabec2        := ""
Local aOrd          := {}
Local cPerg         := PADR("INFINR06",Len(SX1->X1_GRUPO))

Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "INFINR06" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private m_pag       := 01
Private wnrel       := "INFINR06" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SE2"

ValidPerg(cPerg)
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
//         1   2          3         4          5   6      7    8                              9               10    11           12        13                  14
Cabec1 := "Fil Conta      C.Custo   Emissao    Pre Nr.PA  Parc Fornecedor                     Pedido          Valor Moed         Saldo     Nro. DI             Observação"
//         99/99/9999  XXXXXX-X   XXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXX  XXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  999,999,999.99
//         000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111
//         000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901

Processa({|| ExecProc(Cabec1,Cabec2,Titulo,nLin) }, "Filtrando dados")
Return

Static Function ExecProc(Cabec1,Cabec2,Titulo,nLin)
   Local cQry, cArq, cInd, cKey
   Local aStru := SE2->( dbStruct() )
   Local cAlias := Alias()
   Private nCol01 := 0
   Private nCol02 := nCol01 + 4
   Private nCol03 := nCol02 + 11
   Private nCol04 := nCol03 + 10
   Private nCol05 := nCol04 + 11
   Private nCol06 := nCol05 + 4
   Private nCol07 := nCol06 + 7
   Private nCol08 := nCol07 + 5
   Private nCol09 := nCol08 + 31
   Private nCol10 := nCol09 + 7
   Private nCol11 := nCol10 + 15
   Private nCol12 := nCol11 + 3
   Private nCol13 := nCol12 + 20
   Private nCol14 := nCol13 + 20

   cQry := " SELECT E2_FILIAL,E2_NATUREZ,E2_CC,E2_EMISSAO,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_NOMFOR,E2_FORNECE,E2_LOJA,E2_MOEDA,E2_TXMOEDA,E2_VALOR,E2_NROREQ,E2_VIAGEM,E2_SALDO,E2_PEDIDO FROM "+RetSqlName("SE2")+" SE2"
   cQry += " WHERE E2_TIPO = 'PA'
   cQry += " AND E2_FILIAL >= '"+MV_PAR01+"' AND E2_FILIAL <= '"+MV_PAR02+"'
   cQry += " AND E2_EMISSAO >= '"+Dtos(MV_PAR03)+"' AND E2_EMISSAO <= '"+Dtos(MV_PAR04)+"'
   cQry += " AND E2_FORNECE >= '"+MV_PAR05+"' AND E2_FORNECE <= '"+MV_PAR06+"'
   cQry += " AND E2_NATUREZ >= '"+MV_PAR16+"' AND E2_FORNECE <= '"+MV_PAR17+"'
   cQry += " AND E2_PEDIDO BETWEEN '"+mv_par14+"' AND '"+mv_par15+"'
   cQry += " AND SE2.D_E_L_E_T_ <> '*'
   cQry += " ORDER BY E2_FILIAL,E2_EMISSAO

   dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)
   TCSetField("TMP","E2_EMISSAO","D",8,0)	
   If MV_PAR12 == 2
	   RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	 Else  
	   Processa({|| RunExcel()},Titulo)
   EndIf	 
Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  01/12/06   º±±
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
   Local cFornece := ""     
   Local lPrimeiro := .T.
   Local aDirf 
   Local nSaldo := 0
   Local nValor := 0    
   Local nMovim := 0    
   
   dbSelectArea("TMP")
   dbGoTop()
   SetRegua(RecCount())  
   nTotal := 0
   nTotal1 := 0
   While !TMP->(EOF())
     If lAbortPrint
       @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
       Exit
     Endif
     If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
       nLin := 8
     Endif
     If MV_PAR11 == 2
       If TMP->E2_VALOR == TMP->E2_SALDO
         TMP->(DbSkip()) 
         Loop
       EndIf	
     ElseIf MV_PAR11 == 3
       If TMP->E2_VALOR <> TMP->E2_SALDO
         TMP->(DbSkip()) 
         Loop
       EndIf	
     EndIf
	 If !fDetalhe(nLin,TMP->E2_FILIAL,TMP->E2_PREFIXO,TMP->E2_NUM,TMP->E2_FORNECE,TMP->E2_LOJA,TMP->E2_PARCELA,TMP->E2_MOEDA,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,TMP->E2_TXMOEDA,.T.,TMP->E2_PEDIDO)
        TMP->(DbSkip()) 
        Loop
     EndIf	
     nMovim := fMovPA(TMP->E2_MOEDA)
     @nLin,nCol01 PSAY TMP->E2_FILIAL
     @nLin,nCol02 PSAY TMP->E2_NATUREZ
     @nLin,nCol03 PSAY TMP->E2_CC
     @nLin,nCol04 PSAY Dtoc(TMP->E2_EMISSAO)
     @nLin,nCol05 PSAY TMP->E2_PREFIXO
     @nLin,nCol06 PSAY TMP->E2_NUM
     @nLin,nCol07 PSAY TMP->E2_PARCELA
     @nLin,nCol08 PSAY TMP->E2_NOMFOR
     @nLin,nCol09 PSAY TMP->E2_PEDIDO
     If TMP->E2_MOEDA == 1
	     @nLin,nCol10 PSAY Transform(TMP->E2_VALOR,"@E 999,999,999.99")
	     @nLin,nCol11 PSAY '1'
	     @nLin,nCol12 PSAY Transform(TMP->E2_VALOR - nMovim,"@E 999,999,999.99")
	     nValor += TMP->E2_VALOR
	     nSaldo += TMP->E2_VALOR - nMovim
     Else
	     if MV_PAR13 == 1
		     @nLin,nCol10 PSAY Transform(TMP->E2_VALOR*TMP->E2_TXMOEDA,"@E 999,999,999.99")
		     @nLin,nCol11 PSAY '1'
		     @nLin,nCol12 PSAY Transform((TMP->E2_VALOR*TMP->E2_TXMOEDA) - nMovim,"@E 999,999,999.99")
		     nValor += TMP->E2_VALOR*TMP->E2_TXMOEDA
		     nSaldo += (TMP->E2_VALOR*TMP->E2_TXMOEDA) - nMovim
	     Else
		     @nLin,nCol10 PSAY Transform(TMP->E2_VALOR,"@E 999,999,999.99")
		     @nLin,nCol11 PSAY Alltrim(Str(TMP->E2_MOEDA))
		     @nLin,nCol12 PSAY Transform(TMP->E2_VALOR - nMovim,"@E 999,999,999.99")
		     nValor += TMP->E2_VALOR
		     nSaldo += TMP->E2_VALOR - nMovim
	     EndIf
	  EndIf 
     nLin++                  

     nLin := fDetalhe(nLin,TMP->E2_FILIAL,TMP->E2_PREFIXO,TMP->E2_NUM,TMP->E2_FORNECE,TMP->E2_LOJA,TMP->E2_PARCELA,TMP->E2_MOEDA,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,TMP->E2_TXMOEDA,.F.,TMP->E2_PEDIDO)
     If !Empty(TMP->E2_PEDIDO)
       	If MV_PAR11 <> 2 .AND. TMP->E2_SALDO <> 0
        	nLin := fPedido(nLin,TMP->E2_FILIAL,TMP->E2_PREFIXO,TMP->E2_NUM,TMP->E2_FORNECE,TMP->E2_LOJA,TMP->E2_PARCELA,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,TMP->E2_PEDIDO,TMP->E2_TXMOEDA)
       	EndIf
     EndIf  
     @nLin,00 PSAY replicate("-",220)
	  nLin++                  
     TMP->(DbSkip()) 
   EndDo
   nLin++                  
   @nLin,nCol09 PSAY "Total:"
   @nLin,nCol10 PSAY Transform(nValor,"@E 999,999,999.99")
   @nLin,nCol11 PSAY ""
   @nLin,nCol12 PSAY Transform(nSaldo,"@E 999,999,999.99")

   DbSelectArea("TMP")
   dbCloseArea()

   If aReturn[5]==1
      dbCommitAll()
      SET PRINTER TO
      OurSpool(wnrel)
   Endif
   MS_FLUSH()
Return
                          

Static Function fDetalhe(nLin,cFil,cPrefixo,cTitulo,cFornece,cLoja,cParcela,nMoeda,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,nTxmoeda,lMontaSQL,cPedido)
	Local cQuery := ""
	Local cNroDI
	Local nValor := 0
	If lMontaSQL
		cQuery := " SELECT A2_CONTA,E5_DATA,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_MOTBX,E5_CLIFOR,E5_LOJA,E5_VALOR,E5_VLMOED2,E5_TXMOEDA,E5_SEQ,COUNT(*)_ FROM "+RetSqlName("SE5")+" SE5"
		cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON A2_FILIAL = E5_FILIAL AND A2_COD = E5_CLIFOR AND A2_LOJA = E5_LOJA AND SA2.D_E_L_E_T_ = ''"
		cQuery += " WHERE SE5.D_E_L_E_T_ = '' AND E5_FILIAL = '"+cFil+"' 
		cQuery += " AND 
		cQuery += " ( 
		cQuery += "  ((E5_TIPODOC = 'CP' OR E5_TIPODOC = 'ES') AND E5_MOTBX = 'CMP' AND E5_DOCUMEN LIKE ('"+cPrefixo+cTitulo+cParcela+"PA%'))
		cQuery += "   OR 
		cQuery += " ( E5_TIPO = 'PA' AND (E5_TIPODOC = 'BA' OR E5_TIPODOC = 'ES') AND (E5_MOTBX = 'DAC' OR E5_MOTBX = 'DEB') AND E5_NUMERO = '"+cTitulo+"' AND E5_PREFIXO = '"+cPrefixo+"' AND E5_PARCELA = '"+cParcela+"')
		cQuery += "   OR 
		cQuery += " ( E5_TIPO = 'DP' AND E5_TIPODOC = 'VL'  AND E5_MOTBX = 'DEB' AND E5_NUMERO = '"+cTitulo+"' AND E5_PREFIXO = '"+cPrefixo+"' AND E5_PARCELA = '"+cParcela+"')
		cQuery += " )
		cQuery += " AND E5_CLIFOR = '"+cFornece+"' AND E5_LOJA = '"+cLoja+"'
	 	cQuery += " AND E5_DATA BETWEEN '"+Dtos(mv_par09)+"' AND '"+Dtos(mv_par10)+"'
		cQuery += " GROUP BY A2_CONTA,E5_DATA,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_MOTBX,E5_CLIFOR,E5_LOJA,E5_VALOR,E5_VLMOED2,E5_TXMOEDA,E5_SEQ
		cQuery += " HAVING COUNT(*) = 1
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"DETLH",.T.,.T.)
		TCSetField("DETLH","E5_DATA","D",8,0)
		If DETLH->(Eof())
			If MV_PAR11 = 1
				Return .T. 
			Else
				DbSelectArea("DETLH")
				dbCloseArea()
				Return .F. 
			EndIf
		Else	
			Return .T. 
		EndIf
	Else
		DETLH->(DbGotop())
		If !DETLH->(Eof())
			While !DETLH->(Eof())	 
			cNroDI := ""
				If nMoeda == 1
					nValor := DETLH->E5_VALOR
				Else  
					If MV_PAR13 == 1
						nValor := (DETLH->E5_VLMOED2 * DETLH->E5_TXMOEDA)
					Else
						nValor := DETLH->E5_VLMOED2
					EndIf	
				EndIf 

				If MV_PAR12 == 1
					cLinha := Chr(9)
					cLinha += DETLH->A2_CONTA+Chr(9)
					cLinha += Chr(9)
					cLinha += Dtoc(DETLH->E5_DATA)+Chr(9)
					cLinha += DETLH->E5_PREFIXO+Chr(9) 
					cLinha += DETLH->E5_NUMERO+Chr(9)
					cLinha += DETLH->E5_PARCELA+Chr(9)
					If DETLH->E5_MOTBX == "DAC"
						cLinha += "D-A-R-C-A-O"+Chr(9)
						cLinha += Alltrim(Str(Round(nValor,2)))+Chr(9)
					Else
						cLinha += Alltrim(Str(Round(nValor,2)))+Chr(9)
					EndIf  
					If DETLH->E5_MOTBX <> "DAC"
						cLinha += Chr(9)+Chr(9)
					EndIf  
					cLinha += chr(13)+chr(10)
					fWrite(nHdl,cLinha,Len(cLinha))
				Else
		  			If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 8
					Endif
					@nLin,nCol02 PSAY DETLH->A2_CONTA
					@nLin,nCol04 PSAY Dtoc(DETLH->E5_DATA)
					@nLin,nCol05 PSAY DETLH->E5_PREFIXO
					@nLin,nCol06 PSAY DETLH->E5_NUMERO
					@nLin,nCol07 PSAY DETLH->E5_PARCELA
					If DETLH->E5_MOTBX == "DAC"
						@nLin,nCol08 PSAY "D-A-R-C-A-O" 
					Else
					EndIf 
					@nLin,nCol10 PSAY Transform(nValor,"@E 999,999,999.99")
					if MV_PAR13 == 1
	    	        	@nLin,nCol11 PSAY '1'
	    			Else 
	    			EndIf
					If DETLH->E5_MOTBX <> "DAC"
					EndIf  
					nLin++                  
				EndIf  
				DETLH->(DbSkip())
			End
		EndIf  
		DbSelectArea("DETLH")
		dbCloseArea()
	EndIf
Return nLin

Static Function fPedido(nLin,cFil,cPrefixo,cTitulo,cFornece,cLoja,cParcela,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,cPedido,nTxmoeda)
	Local cQuery := ""
	Local cNroDI  
	Local nSaldo2
	
   cQuery := " SELECT E2_FILIAL,E2_EMISSAO,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_NOMFOR,E2_FORNECE,E2_LOJA,E2_MOEDA,F1_TXMOEDA,E2_SALDO,D1_NODI,E2_VALOR,SUM(D1_TOTAL) D1_TOTAL FROM "+RetSqlName("SE2")+" SE2"
   cQuery += " INNER JOIN SF1010 SF1 ON F1_FILIAL = E2_FILIAL AND F1_FORNECE = E2_FORNECE AND F1_LOJA = E2_LOJA AND F1_DOC = E2_NUM AND F1_SERIE = E2_PREFIXO AND SF1.D_E_L_E_T_ = ' ' 
   cQuery += " LEFT JOIN SD1010 SD1 ON D1_FILIAL = E2_FILIAL AND D1_FORNECE = E2_FORNECE AND D1_LOJA = E2_LOJA AND D1_DOC = E2_NUM AND D1_SERIE = E2_PREFIXO AND SD1.D_E_L_E_T_ = ' ' 
   cQuery += " WHERE SE2.D_E_L_E_T_ <> '*'
   cQuery += " AND E2_FILIAL = '"+cFil+"'
   cQuery += " AND E2_FORNECE = '"+cFornece+"' 
   cQuery += " AND E2_LOJA = '"+cLoja+"' 
   cQuery += " AND D1_PEDIDO = '"+cPedido+"'  
   //cQuery += " AND E2_PEDIDO BETWEEN '"+mv_par14+"' AND '"+mv_par15+"'
   cQuery += " AND E2_SALDO > 0
   cQuery += " GROUP BY E2_FILIAL,E2_EMISSAO,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_NOMFOR,E2_FORNECE,E2_LOJA,E2_MOEDA,F1_TXMOEDA,E2_SALDO,D1_NODI,E2_VALOR
   cQuery += " ORDER BY E2_FILIAL,E2_EMISSAO

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"DETLH",.T.,.T.)
	TCSetField("DETLH","E2_EMISSAO","D",8,0)
	If !DETLH->(Eof())
		While !DETLH->(Eof()) 
				             
			nSaldo2 := (DETLH->D1_TOTAL / DETLH->E2_VALOR) * DETLH->E2_SALDO   
			If MV_PAR13 == 1
			   nSaldo2 := nSaldo2 * nTxmoeda
			Endif
			
			cNroDI := ""
			
			If MV_PAR12 == 1
				cLinha := Chr(9)
				cLinha += Chr(9)
				cLinha += Chr(9)
				cLinha += Dtoc(DETLH->E2_EMISSAO)+Chr(9)
				cLinha += DETLH->E2_PREFIXO+Chr(9) 
				cLinha += DETLH->E2_NUM+Chr(9)
				cLinha += nParcela+Chr(9)
				cLinha += Chr(9)
				cLinha += Alltrim(Str(nSaldo2))+Chr(9)
				cLinha += Chr(9)
				cLinha += Chr(9)
				cLinha += "DI - "+DETLH->D1_NODI+Chr(9)
				cLinha += "VALOR NÃO COMPENSADO"+Chr(9)
				cLinha += chr(13)+chr(10)
				fWrite(nHdl,cLinha,Len(cLinha))
			Else
	  			If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif  
								
				@nLin,nCol04 PSAY Dtoc(DETLH->E2_EMISSAO)
				@nLin,nCol05 PSAY DETLH->E2_PREFIXO
				@nLin,nCol06 PSAY DETLH->E2_NUM
				@nLin,nCol07 PSAY DETLH->E2_PARCELA
				@nLin,nCol10 PSAY Transform(nSaldo2,"@E 999,999,999.99")
				@nLin,nCol13 PSAY "DI - "+DETLH->D1_NODI
				@nLin,nCol14 PSAY "VALOR NÃO COMPENSADO"
				nLin++                  
			EndIf  
			DETLH->(DbSkip())
		End
	EndIf  
	DbSelectArea("DETLH")
	dbCloseArea()
Return nLin


Static Function RunExcel()
  Local oExcelApp                           
  Local nPos                  
  Local cArqTxt   := "C:\Temp\INFINR06.xls"
  Local nLin := 0
  Local nSaldo := 0
  Local nValor := 0
  Private nHdl       := fCreate(cArqTxt)
  Private cLinha     := ""

  cLinha := "Filial"+Chr(9)
  cLinha += "Conta"+Chr(9)
  cLinha += "C.Custo"+Chr(9)
  cLinha += "Emissao"+Chr(9)
  cLinha += "Prefixo"+Chr(9) 
  cLinha += "Nro.PA"+Chr(9)
  cLinha += "Parcela"+Chr(9)
  cLinha += "Fornecedor"+Chr(9)
  cLinha += "Valor"+Chr(9)
  cLinha += "Moeda"+Chr(9)
  cLinha += "Saldo"+Chr(9)
  cLinha += "Nro DI"+Chr(9)
  cLinha += "Observação"+Chr(9)
  cLinha += chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha))

	dbSelectArea("TMP")
	dbGoTop()
	ProcRegua(RecCount())  
	While !TMP->(EOF())
		IncProc()
       If MV_PAR11 == 2
         If TMP->E2_VALOR == TMP->E2_SALDO
           TMP->(DbSkip()) 
           Loop
         EndIf	
       ElseIf MV_PAR11 == 3
         If TMP->E2_VALOR <> TMP->E2_SALDO
           TMP->(DbSkip()) 
           Loop
         EndIf	
       EndIf
		cLinha := TMP->E2_FILIAL+Chr(9)
		cLinha += TMP->E2_NATUREZ+Chr(9)
		cLinha += TMP->E2_CC+Chr(9)
		cLinha += Dtoc(TMP->E2_EMISSAO)+Chr(9)
		cLinha += TMP->E2_PREFIXO+Chr(9) 
		cLinha += TMP->E2_NUM+Chr(9)
		cLinha += TMP->E2_PARCELA+Chr(9)
		cLinha += TMP->E2_NOMFOR+Chr(9)
		cLinha += Alltrim(Str(TMP->E2_VALOR))+Chr(9)
		if MV_PAR13 == 1
		cLinha += '1'
		else 
			cLinha += Alltrim(Str(TMP->E2_MOEDA))+Chr(9)
		endif
		cLinha += Alltrim(Str(TMP->E2_SALDO))+Chr(9)
		cLinha += chr(13)+chr(10)
	     nValor += TMP->E2_VALOR
      nSaldo += TMP->E2_SALDO
		fWrite(nHdl,cLinha,Len(cLinha))
		nLin := fDetalhe(nLin,TMP->E2_FILIAL,TMP->E2_PREFIXO,TMP->E2_NUM,TMP->E2_FORNECE,TMP->E2_LOJA,TMP->E2_PARCELA,TMP->E2_MOEDA)
		If !Empty(TMP->E2_PEDIDO)
			If MV_PAR11 <> 2
				nLin := fPedido(nLin,TMP->E2_FILIAL,TMP->E2_PREFIXO,TMP->E2_NUM,TMP->E2_FORNECE,TMP->E2_LOJA,TMP->E2_PARCELA,"","","","",0,"",TMP->E2_PEDIDO)
			EndIf  
		EndIf  
		TMP->(DbSkip()) 
	EndDo
	cLinha := Chr(9)+Chr(9)+Chr(9)+Chr(9)+Chr(9)+Chr(9)+Chr(9)
	cLinha += "Total"+Chr(9)
	cLinha += Alltrim(Str(nValor))+Chr(9)
	cLinha += Chr(9)
	cLinha += Alltrim(Str(nSaldo))+Chr(9)
	cLinha += chr(13)+chr(10)
	fWrite(nHdl,cLinha,Len(cLinha))

	DbSelectArea("TMP")
	dbCloseArea()
	fClose(nHdl)     
	If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
		MsgStop( 'MsExcel nao instalado' ) 
		Return
	EndIf  
	oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
  oExcelApp:WorkBooks:Open(cArqTxt) 
  oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.  
Return             

Static Function fMovPA(nMoeda)
	Local nReturn := 0
	Local nValor      
	DETLH->(DbGotop())
	While !DETLH->(Eof())	 
		nValor := 0
		If nMoeda == 1
			nValor := DETLH->E5_VALOR
		Else  
			If MV_PAR13 == 1
				nValor := (DETLH->E5_VLMOED2 * DETLH->E5_TXMOEDA)
			Else
				nValor := DETLH->E5_VLMOED2
			EndIf	
		EndIf 
		nReturn += nValor
  		DETLH->(DbSkip())
	End
Return nReturn

Static Function ValidPerg(cPerg)
   u_INPutSX1(cPerg,"01","Da Filial                    ?","","","mv_ch1","C",02,0,0,"G","","   ","","","mv_par01")
   u_INPutSX1(cPerg,"02","Ate a Filial                 ?","","","mv_ch2","C",02,0,0,"G","","   ","","","mv_par02")
   u_INPutSX1(cPerg,"03","Da Emissao                   ?","","","mv_ch3","D",08,0,0,"G","","   ","","","mv_par03")
   u_INPutSX1(cPerg,"04","Ate Emissao                  ?","","","mv_ch4","D",08,0,0,"G","","   ","","","mv_par04")
   u_INPutSX1(cPerg,"05","Do Fornecedor                ?","","","mv_ch5","C",06,0,0,"G","","SA2","","","mv_par05")
   u_INPutSX1(cPerg,"06","Ate o Fornecedor             ?","","","mv_ch6","C",06,0,0,"G","","SA2","","","mv_par06")
   u_INPutSX1(cPerg,"07","Da Centro de Custo           ?","","","mv_ch7","C",09,0,0,"G","","CTT","","","mv_par07")
   u_INPutSX1(cPerg,"08","Ate Centro de Custo          ?","","","mv_ch8","C",09,0,0,"G","","CTT","","","mv_par08")
   u_INPutSX1(cPerg,"09","Da Dt. Compensacao           ?","","","mv_ch9","D",08,0,0,"G","","   ","","","mv_par09")
   u_INPutSX1(cPerg,"10","Ate Dt. Compensacao          ?","","","mv_cha","D",08,0,0,"G","","SA2","","","mv_par10")
   u_INPutSx1(cPerg,"11","Lista                        ?","","","mv_chb","N",01,0,0,"C","",""   ,"","","mv_par11","Ambos","Ambos","Ambos","","Somente Compensados","Somente Compensados","Somente Compensados","Não Compensados","Não Compensados","Não Compensados")
   u_INPutSx1(cPerg,"12","Gera em Excel                ?","","","mv_chc","N",01,0,0,"C","",""   ,"","","mv_par12","Sim","Sim","Sim","","Não","Não","Não","","","","","","","","","")
   u_INPutSx1(cPerg,"13","Converter Moeda              ?","","","mv_chc","N",01,0,0,"C","",""   ,"","","mv_par13","Sim","Sim","Sim","","Não","Não","Não","","","","","","","","","")
   u_INPutSX1(cPerg,"14","Do Pedido                    ?","","","mv_che","C",06,0,0,"G","","","","","mv_par14")
   u_INPutSX1(cPerg,"15","Ate o Pedido                 ?","","","mv_chf","C",06,0,0,"G","","","","","mv_par15")
   u_INPutSX1(cPerg,"16","Da Conta         ?","Da Conta         ?","Da Conta         ?","mv_chg","C",20,0,0,"G","","CT1","","","mv_par16")
   u_INPutSX1(cPerg,"17","Ate a Conta      ?","Ate a Conta      ?","Ate a Conta      ?","mv_chh","C",20,0,0,"G","","CT1","","","mv_par17")
Return