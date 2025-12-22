#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  RESUMO    ¦ Autor ¦ 				      ¦ Data ¦ 			  ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Relatorio de Resumo de Caixa                                  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦                 ø
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function RESUMOW()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "RESUMO DE CAIXA - "+SM0->M0_FILIAL
Local nLin           := 01
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "RESU"+SM0->M0_CODFIL // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RESU"+SM0->M0_CODFIL // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg        := Padr("RESU"+SM0->M0_CODFIL,10)
Private cString      := "SE1"
Private _aTipo       := {}




/*
SX5->(dbSetOrder(1))
SX5->(dbseek(  xFilial('SX5') + '24') )
cCHave := xFilial('SX5') + '24'

While cChave == SX5->X5_FILIAL + SX5->X5_TABELA
  aAdd(_aTipo,{SX5->X5_CHAVE,0,SX5->X5_DESCRI})
  SX5->(dbSkip())
EndDo
*/
//Tratativa Code Analysis - acesso ao dicionário SX5 - Kodigos - 11/07/2023
aTipos:= FwGetSX5("24")
For i:= 1 to len(aTipos)
	aAdd(_aTipo,{aTipos[i,3],0,aTipos[i,4]})
Next

aAdd(_aTipo,{"OU",0,"OUTROS PAGAMENTOS"})

//CriaSx1()
Pergunte(cPerg,.F.)
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

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local cFilia := xFilial("SE1")
Local cDATA  := DTOS(MV_PAR01)

Private nDinheiro := 0
Private nChequeAv := 0
Private nChequePr := 0
Private nCCAura   := 0
Private nCCDebito := 0
Private nCC		  := 0
Private nCD		  := 0
Private nCR       := 0
Private nCCVisa   := 0
Private nCCVisaParc:= 0
Private nCCMaster := 0
Private nCCMastParc := 0
Private nCCAmeric := 0
Private nCCDinner := 0
Private nCCVisaEl := 0
Private nCCRedeSh := 0
Private nCCCheque := 0
Private nBolBanco := 0
Private nPrCusteio:= 0
Private nDevolVenda := 0
Private nDepConta := 0
Private nCarteira := 0
Private nSaldo    := 0
Private nDuplicat := 0
Private nSalIni   := 0
Private nCrediari := 0
Private nEmpenho  := 0
Private nChequeLi := 0
Private nBoletoLi := 0
Private nTransfer := 0
Private nTransCX  := 0
Private nTransPix  := 0
Private nEntrada  := 0
Private nSaida    := 0
Private nSaidV    := 0
Private nOutrosPg := 0
Private nSemClien := 0
Private nTotNotas := 0
Private nTotPix   := 0
Private nTotDesco := 0
Private nTotCredi := 0
Private nTotTroca := 0
Private nTotDvCR  := 0
Private nTotDvRS  := 0
Private vDVCR	  := {}
Private vDVRS	  := {}
Private vCRED	  := {}
Private nTotBrind := 0
Private nTotConsu := 0
Private nTotBruto := 0
Private nSubTotal := 0
Private nTotLiqui := 0
Private nTotApoli := 0
Private cMinApoli := ""
Private cMaxApoli := ""
Private nDevCC    := 0
Private nDevCD    := 0

DbSelectArea("SA6")
DbSetOrder(1)

DbSelectArea("SE8")
DbSetOrder(1)

PegaResumo()

//nTotLiqui := nDinheiro + nChequeAv + nChequePr + nCCVisa   + nCCMaster + nCCAmeric + nCCDinner + nCCVisaEl+(nCC+nCD)+nCR
nTotLiqui := 0
aEval(_aTipo,{|x| nTotLiqui += x[02]})
//nTotLiqui += nOutrosPg + nCCRedeSh + nCCCheque + nBolBanco +nPRCusteio + nDepConta + nDevolVenda + nCarteira + nDuplicat + nCrediari + nEmpenho + nCCDebito +  nCCAura + nChequeLi + nBoletoLi
nTotLiqui += nSemClien + nTotCredi

nTotBruto := nTotLiqui+nTotDvRS+nTotDesco+nTotCredi

nSubTotal := nTotBruto-nTotDesco

nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1

@ nLin,001 PSAY "RESUMO FINANCEIRO NA DATA :       "+DTOC(MV_PAR01)+"   ("+mv_par02+","+mv_par03+","+mv_par04+","+mv_par05+","+mv_par06+")"
nLin := nLin + 2
@ nLin,001 PSAY "TOTAL BRUTO EM NOTAS - DIA: "+Transform(nTotBruto,"@E 999,999,999.99") ; nLin += 1
@ nLin,001 PSAY "DESCONTOS CONCEDIDOS - DIA: "+Transform(nTotDesco,"@E 999,999,999.99") ; nLin += 1
//		@ nLin,001 PSAY "TROCAS                    : "+Transform(nTotTroca,"@E 999,999,999.99") ; nLin += 2
@ nLin,001 PSAY repli("-",130) ; nLin++
@ nLin,001 PSAY "SUB-TOTAL                 : "+Transform(nSubTotal,"@E 999,999,999.99") ; nLin += 1
@ nLin,001 PSAY repli("-",130) ; nLin+=1

If nTotCredi <> 0
	@ nLin,001 PSAY "CREDITOS UTILIZADOS/TROCAS: "; nLin++
	For I:=1 to Len(vCRED)
		If nLin > 50
			nLin := Cabec(Titulo,Cabec1,PADC(Cabec2,200),NomeProg,Tamanho,nTipo) + 1
		EndIf
		
		@ nLin,001 PSAY vCRED[I][1]+" - "+Transform(vCRED[I][2],"@E 999,999,999.99"); nLin ++
	Next
	@ nLin,009 PSAY "TOTAL: "+Transform(nTotCredi,"@E 999,999,999.99") ; nLin += 1
	
	
Endif

If nTotDvRS <> 0
	@ nLin,001 PSAY "DEVOL. EM DINHEIRO NO DIA : " ; nLin ++
	
	For I:=1 to Len(vDVRS)
		If nLin > 50
			nLin := Cabec(Titulo,Cabec1,PADC(Cabec2,200),NomeProg,Tamanho,nTipo) + 1
		EndIf
		@ nLin,001 PSAY "NFE: "+Substr(vDVRS[I][1],1,12)+" - "+Transform(vDVRS[I][2],"@E 999,999,999.99")+;
		" - NF ORIG: "+vDVRS[I][4]; nLin ++
	Next
	@ nLin,009 PSAY "TOTAL: "+Transform(nTotDvRS,"@E 999,999,999.99") ; nLin += 1
	
EndIf

@ nLin,001 PSAY repli("-",130) ; nLin++
@ nLin,001 PSAY "TOTAL LIQUIDO             : "+Transform(nTotLiqui,"@E 999,999,999.99") ; nLin += 1
@ nLin,001 PSAY repli("-",130) ; nLin += 1

If nTotDvCR <> 0
	
	@ nLin,001 PSAY "MOVIM. QUE GERARAM CREDITO: " ; nLin += 2
	For I:=1 to Len(vDVCR)
		If nLin > 50
			nLin := Cabec(Titulo,Cabec1,PADC(Cabec2,200),NomeProg,Tamanho,nTipo) + 1
		EndIf
		@ nLin,001 PSAY "NFE: "+Substr(vDVCR[I][1],1,12)+" - "+Transform(vDVCR[I][2],"@E 999,999,999.99")+" - "+vDVCR[I][3]+; 
		" - NF ORIG: "+vDVCR[I][4];nLin ++
	Next
	@ nLin,009 PSAY "TOTAL: "+Transform(nTotDvCR,"@E 999,999,999.99") ; nLin += 1
	
EndIf

If nTotBrind <> 0
	@ nlin,001 PSAY "BRINDES                   : "+Transform(nTotBrind,"@E 999,999,999.99") ; nLin += 1
Endif
If nTotConsu <> 0
	@ nlin,001 PSAY "CONSUMOS                  : "+Transform(nTotConsu,"@E 999,999,999.99") ; nLin += 1
Endif
nLin++
@ nLin,001 PSAY "NUMERO DE NOTAS EMITIDAS  : "+Transform(nTotNotas,"@E 999999,999,999")    ; nLin += 2

@ nLin,001 PSAY repli("-",130) ; nLin++
@ nLin,001 PSAY PADC("T E S O U R A R I A:",80)  ; nLin++
@ nLin,001 PSAY repli("-",130) ; nLin++

If nSalIni   <> 0
	@ nlin,001 PSAY "   SALDO ANTERIOR         : "+Transform(nSalIni  ,"@E 999,999,999.99") ; nLin += 1
Endif

If nEntrada  <> 0
	@ nlin,001 PSAY " + ENTRADA NO CAIXA       : "+Transform(nEntrada ,"@E 999,999,999.99") ; nLin += 1
Endif

nDinheiro := _aTipo[aScan(_aTipo,{|x| Upper(Alltrim(x[01]))==Upper(Alltrim("R$")) })][02]

If nDinheiro <> 0
	@ nlin,001 PSAY " + VENDAS EM DINHEIRO     : "+Transform(nDinheiro,"@E 999,999,999.99") ; nLin += 1
Endif

If nSaida    <> 0
	@ nlin,001 PSAY " - SAIDA DO CAIXA         : "+Transform(nSaida   ,"@E 999,999,999.99") ; nLin += 1
Endif

If nTransCX  <> 0
	@ nlin,001 PSAY " - TRANSF. DE CAIXA       : "+Transform(nTransCX ,"@E 999,999,999.99") ; nLin += 1
Endif


If nSaidV   <> 0
	@ nlin,001 PSAY " - DEVOLUCAO R$           : "+Transform(nSaidV  ,"@E 999,999,999.99") ; nLin += 1
Endif 


@ nlin,030 PSAY   " ---------------------"; nLin += 1
@ nlin,001 PSAY   " = DINHEIRO NO CAIXA      : "+Transform((nSalIni+nEntrada+nDinheiro)-(nSaida+nTransCX+nSaidV),"@E 999,999,999.99") ; nLin += 2
//@ nlin,001 PSAY   " = DINHEIRO NO CAIXA      : "+Transform((nDinheiro)-(nSaidV),"@E 999,999,999.99") ; nLin += 2

If nTotCredi <> 0
	@ nlin,001 PSAY " CREDITOS                 : "+Transform(nTotCredi,"@E 999,999,999.99") ; nLin += 1
Endif

//nTotPix := _aTipo[aScan(_aTipo,{|x| Upper(Alltrim(x[01]))==Upper(Alltrim("PI")) })][02]

/*
If nTotPix   <> 0
	@ nlin,001 PSAY " VALOR VENDA PIX          : "+Transform(nTotPix  ,"@E 999,999,999.99") ; nLin += 1
Endif
*/

If nTransPix  <> 0
	@ nlin,001 PSAY " TRANSF.  PIX             : "+Transform(nTransPix ,"@E 999,999,999.99") ; nLin += 1
Endif

For _nDro := 1 TO Len(_aTipo)
  If _aTipo[_nDro][02] <> 0 .And. _aTipo[_nDro][01] != "R$"
    	@ nlin,001 PSAY " " + Padr(_aTipo[_nDro][03],25) + ": " + Transform(_aTipo[_nDro][02],"@E 999,999,999.99") 
    	  nLin += 1
  Endif
Next

If nSemClien > 0
	@ nlin,001 PSAY " RECEBIMENTO DIVERSOS     : "+Transform(nSemClien,"@E 999,999,999.99") ; nLin += 1
Endif
   

// weR        

If nDevCD <> 0 .Or. nDevCC <> 0                                                                       
   nLin++
	@ nlin,001 PSAY "DEVOLUÇÕES / ESTORNOS "  ; nLin += 1      
	If nDevCC > 0 
	   @ nlin,001 PSAY "  -CARTÃO DE CRÉDITO      : "+Transform(nDevCC,"@E 999,999,999.99") ; nLin += 1
   Endif
	If nDevCD > 0 
	   @ nlin,001 PSAY "  -CARTÃO DE DÉBITO       : "+Transform(nDevCD,"@E 999,999,999.99") ; nLin += 1    
   Endif
EndIf 


If nLin < 50
	nLin := 50
Endif
@ nlin,001 PSAY " __________________          __________________          __________________" ; nLin++
@ nLin,001 PSAY "       CAIXA                      GERENTE                     DIRETORIA    "

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return

Static Function PegaResumo()
Local cQry, nPerc, nValDev
Local cCX1    := If( Empty(MV_PAR02) , "ZZZ", MV_PAR02)
Local cCX2    := If( Empty(MV_PAR03) , "ZZZ", MV_PAR03)
Local cCX3    := If( Empty(MV_PAR04) , "ZZZ", MV_PAR04)
Local cCX4    := If( Empty(MV_PAR05) , "ZZZ", MV_PAR05)
Local cCX5    := If( Empty(MV_PAR06) , "ZZZ", MV_PAR06)

Local cFilSD2 := XFILIAL("SD2")
Local cFilSL4 := XFILIAL("SL4")
Local cFilSE5 := XFILIAL("SE5")

// Acumula os descontos de credito
cQry := "SELECT L1_DOC, L1_SERIE, L1_CLIENTE, L1_LOJA, L1_CREDITO, L1_DOC, L1_SERIE, L1_DOCPED, L1_SERPED FROM "+RetSQLName("SL1")+" WHERE "
cQry += "L1_EMISSAO = '"+Dtos(mv_par01)+"' AND L1_FILIAL = '"+XFILIAL("SL1")+"' AND D_E_L_E_T_ <> '*' AND "
cQry += "L1_TIPO IN ('V','P') AND L1_CREDITO <> 0 AND "
cQry += "L1_OPERADO IN ("
cQry += "'"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"','"+cCX5+"')"

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
While !Eof()
	dbSelectArea("SE5")
	dbSetOrder(7)
	
	If !Empty(TRB->L1_DOC)
		If dbSeek(cFilSE5+TRB->(L1_SERIE+L1_DOC+"1 "+"CR "+L1_CLIENTE+L1_LOJA))
			nTotCredi += TRB->L1_CREDITO
		Endif
		
		nPos := ASCAN(vCRED,{|x|x[1] == TRB->L1_DOC+TRB->L1_SERIE})
		If nPos > 0
			vCRED[nPos][2] += TRB->L1_CREDITO
		Else
			AADD(vCRED,{TRB->L1_DOC+TRB->L1_SERIE, TRB->L1_CREDITO})
		Endif
		
		
	Else
		If dbSeek(cFilSE5+TRB->(L1_SERPED+L1_DOCPED+"1 "+"CR "+L1_CLIENTE+L1_LOJA))
			nTotCredi += TRB->L1_CREDITO
		Endif
		
		nPos := ASCAN(vCRED,{|x|x[1] == TRB->L1_DOCPED+TRB->L1_SERPED})
		If nPos > 0
			vCRED[nPos][2] += TRB->L1_CREDITO
		Else
			AADD(vCRED,{TRB->L1_DOCPED+TRB->L1_SERPED, TRB->L1_CREDITO})
		Endif
		
	EndIf
	
	
	dbSelectArea("TRB")
	dbSkip()
Enddo
dbCloseArea()

// Acumula por forma de pagamento o total de cada venda efetuada
cQry := "SELECT L1_CLIENTE, L1_LOJA, L1_SERIE, L1_DOC, L4_FORMA, L4_DATA, L4_VALOR, L4_ADMINIS, L1_DOCPED "
cQry += "FROM "+RetSQLName("SL1")+" A, "+RetSQLName("SL4")+" B WHERE "
cQry += "L1_EMISNF = '"+Dtos(mv_par01)+"' AND (L1_DOC <> '' OR L1_DOCPED <> '')  AND A.D_E_L_E_T_ <> '*' AND "
cQry += "B.D_E_L_E_T_ <> '*' AND L1_FILIAL = L4_FILIAL AND L1_NUM = L4_NUM AND (L1_TIPO = 'V' OR L1_TIPO = 'P') AND "
cQry += "L1_OPERADO IN ("
cQry += "'"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"','"+cCX5+"')"

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )

TcSetField("TRB" , "L4_DATA", "D", 8, 0)  // Formata para tipo Data

dbSelectArea("TRB")
dbGoTop()
While !Eof()
	
	If Empty(TRB->L1_DOCPED)  // Verifica se é um Pedido de Venda (Loja)
		// Posiciona nos Itens da Nota Fiscal de Saida
		SD2->(dbSetOrder(3))
		If SD2->(dbSeek(cFilSD2+TRB->(L1_DOC+L1_SERIE+L1_CLIENTE+L1_LOJA)))
			// Acumula por Forma de Pagamento
			SomaForma(SubStr(TRB->L4_FORMA,1,2),TRB->L4_DATA,SubStr(TRB->L4_ADMINIS,1,3),TRB->L4_VALOR,TRB->L4_VALOR,1)
			
		EndIf
		
	Else
		SomaForma(SubStr(TRB->L4_FORMA,1,2),TRB->L4_DATA,SubStr(TRB->L4_ADMINIS,1,3),TRB->L4_VALOR,TRB->L4_VALOR,1)
	EndIf
	
	dbSkip()
Enddo
dbCloseArea()

// Soma o total de notas emitidas
cQry := "SELECT ISNULL(COUNT(*),0)TOTAL FROM "+RetSQLName("SF2")+" SF2 "
cQry += "INNER JOIN "+RetSQLName("SL1")+" SL1 ON L1_DOC = F2_DOC AND L1_SERIE = F2_SERIE AND "
cQry += "F2_CLIENTE = L1_CLIENTE AND F2_LOJA = L1_LOJA AND SL1.D_E_L_E_T_<> '*' "
cQry += "WHERE F2_FILIAL = '"+XFILIAL("SF2")+"' AND F2_EMISSAO = '"+Dtos(mv_par01)+"' AND F2_TIPO ='N' AND "
cQry += "SF2.D_E_L_E_T_ <> '*' AND "
cQry += "L1_OPERADO IN ("
cQry += "'"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"','"+cCX5+"')"

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
nTotNotas += TOTAL
dbCloseArea()

// Soma o total de notas emitidaS PIX
cQry := "SELECT ISNULL(SUM(F2_VALBRUT),0)TOTAL FROM "+RetSQLName("SF2")+" SF2 "
cQry += "INNER JOIN "+RetSQLName("SL1")+" SL1 ON L1_DOC = F2_DOC AND L1_SERIE = F2_SERIE AND "
cQry += "F2_CLIENTE = L1_CLIENTE AND F2_LOJA = L1_LOJA AND SL1.D_E_L_E_T_<> '*' "
cQry += "WHERE F2_FILIAL = '"+XFILIAL("SF2")+"' AND F2_EMISSAO = '"+Dtos(mv_par01)+"' AND F2_TIPO ='N' AND L1_FORMPG = 'PI' AND  "
cQry += "SF2.D_E_L_E_T_ <> '*' AND "
cQry += "L1_OPERADO IN ("
cQry += "'"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"','"+cCX5+"')"

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
nTotPix += TOTAL
dbCloseArea()


// Soma o total dos descontos concedidos
cQry := "SELECT ISNULL(SUM(F2_DESCONT),0)TOTAL FROM "+RetSQLName("SF2")+" SF2, "+RetSQLName("SL1")+" SL1 "
cQry += "WHERE F2_FILIAL = '"+XFILIAL("SF2")+"' AND F2_EMISSAO = '"+Dtos(mv_par01)+"' AND F2_TIPO ='N' AND "
cQry += "SF2.D_E_L_E_T_ <> '*' AND SL1.D_E_L_E_T_ <> '*' AND F2_FILIAL = L1_FILIAL AND F2_DOC = L1_DOC AND "
cQry += "F2_SERIE = L1_SERIE AND F2_CLIENTE = L1_CLIENTE AND F2_LOJA = L1_LOJA AND "
cQry += "L1_OPERADO IN ("
cQry += "'"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"','"+cCX5+"')"

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
nTotDesco += TOTAL
dbCloseArea()

// Soma o total das trocas e devolucoes
cQry := "SELECT D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_TOTAL, D1_VALDESC, D1_NFORI, D1_SERIORI, L1_NUM, L1_VLRLIQ, L1_VALMERC, L1_DOC, L1_SERIE, L1_DOCPED, L1_SERPED "
cQry += "FROM "+RetSQLName("SD1")+" A, "+RetSQLName("SL1")+" B "
cQry += "WHERE A.D_E_L_E_T_=' ' AND B.D_E_L_E_T_=' ' AND D1_FILIAL=L1_FILIAL AND D1_TES = '132' AND "
cQry += "D1_NFORI=L1_DOC AND D1_SERIORI=L1_SERIE AND D1_TIPO='D' AND D1_DTDIGIT = '"+Dtos(mv_par01)+"' AND "
cQry += "L1_TIPO = 'V' AND D1_FILIAL = '"+XFILIAL("SD1")+"' AND "
cQry += "SUBSTRING(D1_NUMCQ,1,3) IN ('"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"','"+cCX5+"') AND D1_LOCAL = '01'"


dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )

dbSelectArea("TRB")
dbGoTop()
While !TRB->(EOF())
	
	If PesqDevTrc() == "T"
		nTotDvCr += TRB->D1_TOTAL - TRB->D1_VALDESC
		
		nPos := ASCAN(vDVCR,{|x|x[1] == TRB->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)})
		If nPos > 0
			vDVCR[nPos][2] += TRB->D1_TOTAL
		Else
			AADD(vDVCR,{TRB->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA), D1_TOTAL,"TROCA    ",TRB->(D1_NFORI+"/"+D1_SERIORI)})
		Endif                          
		
	ElseIf  PesqDevTrc() == "D"
		nTotDvCr += TRB->D1_TOTAL - TRB->D1_VALDESC
		
		nPos := ASCAN(vDVCR,{|x|x[1] == TRB->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)})
		If nPos > 0
			vDVCR[nPos][2] += TRB->D1_TOTAL
		Else
			AADD(vDVCR,{TRB->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA), D1_TOTAL,"DEVOLUÇÃO",TRB->(D1_NFORI+"/"+D1_SERIORI)})
		Endif
		
	ElseIf  PesqDevTrc() == "R"
		nTotDvRS += TRB->D1_TOTAL - TRB->D1_VALDESC
		
		nPos := ASCAN(vDVRS,{|x|x[1] == TRB->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)})
		
		If nPos > 0
			vDVRS[nPos][2] += TRB->D1_TOTAL
		Else
			AADD(vDVRS,{TRB->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA), D1_TOTAL,"R$", TRB->(D1_NFORI+"/"+D1_SERIORI)})
		Endif
		
	Endif
	
	TRB->(dbSkip())
	
EndDo
dbCloseArea()

// Soma o total das transferencias
cQry := "SELECT ISNULL(SUM(D2_TOTAL),0)TOTAL FROM "+RetSQLName("SD2")+" SD2, "+RetSQLName("SL1")+" SL1 "
cQry += "WHERE D2_FILIAL = '"+XFILIAL("SD2")+"' AND D2_EMISSAO = '"+Dtos(mv_par01)+"' AND D2_TIPO ='N' AND "
cQry += "SD2.D_E_L_E_T_ <> '*' AND SL1.D_E_L_E_T_ <> '*' AND D2_FILIAL = L1_FILIAL AND D2_DOC = L1_DOC AND "
cQry += "D2_SERIE = L1_SERIE AND D2_CLIENTE = L1_CLIENTE AND D2_LOJA = L1_LOJA AND D2_LOCAL = '01' AND D2_TES IN ('502','536','548') "
cQry += "AND D2_CLIENTE LIKE 'RAM0%'" // AND L1_OPERADO IN ('"+cCX1+"','"+cCX2+"','"+cCX3+"')"

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRE", .T., .F. )
nTransfer += TOTAL
dbCloseArea()

PegaSaldo(cCX1,cCX2,cCX3,cCX4,cCX5)

nSalIni += nSaldo

//Total de Entradas do Caixa
cQry1 := "SELECT ISNULL(SUM(E5_VALOR),0)ENTRADA FROM "+RetSQLName("SE5")
cQry1 += " WHERE E5_DATA = '"+Dtos(MV_par01)+"' "
cQry1 += " AND ((E5_RECPAG='R' AND E5_TIPODOC ='TR') OR (E5_RECPAG='R' AND E5_TIPODOC IN ('','VL','ES'))) AND "
cQry1 += " E5_HISTOR <> 'Estorno de transferencia.                              ' AND "
cQry1 += " E5_SITUACA <> 'C' AND "
cQry1 += " D_E_L_E_T_ <> '*' AND "
cQry1 += " E5_BANCO IN ("
cQry1 += " '"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"','"+cCX5+"')"

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry1)), "TRB", .T., .F. )
nEntrada += ENTRADA
dbCloseArea()

//Total de Saidas do Caixa - TRANSFERÊNCIAS
cQry2 := "SELECT ISNULL(SUM(E5_VALOR),0)SAIDA FROM "+RetSQLName("SE5")
cQry2 += " WHERE E5_DATA = '"+Dtos(MV_par01)+"' "
cQry2 += " AND E5_RECPAG='P' AND E5_TIPODOC ='TR'  AND "
cQry2 += " E5_HISTOR <> 'Estorno de transferencia.                              ' AND "
cQry2 += " E5_NATUREZ <> 'DEV./TROCA' AND "
cQry2 += " E5_NATUREZ <> 'OUTROS    ' AND "
cQry2 += " E5_SITUACA <> 'C' AND "
cQry2 += " E5_NATUREZ = 'SANGRIA' AND "
cQry2 += " D_E_L_E_T_ <> '*' AND "
cQry2 += " E5_BANCO IN ( "
cQry2 += "'"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"','"+cCX5+"')"

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry2)), "TRB", .T., .F. )
nTransCX += SAIDA
dbCloseArea()


//Total de Saidas do Caixa - TRANSFERÊNCIAS PIX
cQry2 := "SELECT ISNULL(SUM(E5_VALOR),0)SAIDA FROM "+RetSQLName("SE5")
cQry2 += " WHERE E5_DATA = '"+Dtos(MV_par01)+"' "
cQry2 += " AND E5_RECPAG='P' AND E5_TIPODOC ='TR'  AND "
cQry2 += " E5_HISTOR <> 'Estorno de transferencia.                              ' AND "
cQry2 += " E5_NATUREZ <> 'DEV./TROCA' AND "
cQry2 += " E5_NATUREZ <> 'OUTROS    ' AND "
cQry2 += " E5_SITUACA <> 'C' AND "
cQry2 += " E5_NATUREZ = 'PIX' AND "
cQry2 += " D_E_L_E_T_ <> '*' AND "
cQry2 += " E5_BANCO IN ( "
cQry2 += "'"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"','"+cCX5+"')"

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry2)), "TRB", .T., .F. )
nTransPix += SAIDA
dbCloseArea()


//Total de Saidas do Caixa - PAGAMENTOS
cQry2 := "SELECT ISNULL(SUM(E5_VALOR),0)SAIDA FROM "+RetSQLName("SE5")
cQry2 += " WHERE E5_DATA = '"+Dtos(MV_par01)+"' "
//cQry2 += " AND E5_RECPAG='P' AND E5_TIPODOC IN ('','VL','ES','LJ') AND 
//Alterado para evitar deletar registro no SE5, Estornos de cancelamentos
//estavam sendo registrados como saída de Caixa. Obs: Conceito! Williams Messa 21/06/19
cQry2 += " AND E5_RECPAG='P' AND E5_TIPODOC IN ('','VL','LJ') AND "
cQry2 += " E5_HISTOR <> 'Estorno de transferencia.                              ' AND "
cQry2 += " E5_NATUREZ <> 'DEV./TROCA' AND "
cQry2 += " E5_NATUREZ <> 'OUTROS    ' AND "
cQry2 += " E5_SITUACA <> 'C' AND "  
cQry2 += " E5_TIPO NOT IN ('CR','NCC') AND "  
cQry2 += " D_E_L_E_T_ <> '*' AND "  
cQry2 += " E5_BANCO IN ( "
cQry2 += "'"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"','"+cCX5+"')"

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry2)), "TRB", .T., .F. )
nSaida += SAIDA
dbCloseArea()

//Total de Saidas por Devoluções
cQry2 := "SELECT ISNULL(SUM(E5_VALOR),0)SAIDV FROM "+RetSQLName("SE5")
cQry2 += " WHERE E5_DATA = '"+Dtos(MV_par01)+"' "
cQry2 += " AND ((E5_RECPAG='P' AND E5_TIPODOC ='TR') OR (E5_RECPAG='P' AND E5_TIPODOC IN ('','VL','ES','LJ') )) AND "
cQry2 += " E5_HISTOR <> 'Estorno de transferencia.                              ' AND "
cQry2 += " E5_NATUREZ IN ('DEVOLUCAO','32001','31002','21002','21001','') AND E5_TIPO  = 'NCC' AND "
cQry2 += " E5_SITUACA <> 'C' AND "
cQry2 += " D_E_L_E_T_ <> '*' AND "
cQry2 += " E5_BANCO IN ( "
cQry2 += "'"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"','"+cCX5+"')"

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry2)), "TRB", .T., .F. )
nSaidV += SAIDV
dbCloseArea()

nDevCC := fwDevolCC("CC", cCX1, cCX2, cCX3, cCX4, cCX5)    
nDevCD := fwDevolCC("CD", cCX1, cCX2, cCX3, cCX4, cCX5)

Return

Static Function SomaForma(cTipo,dVencto,cCodCli,nValor,nVlrReal,nSinal)

_nPos := aScan(_aTipo,{|x| Upper(Alltrim(x[01]))==Upper(Alltrim(cTipo)) })
If _nPos > 0
   _aTipo[_nPos][02] += (nValor * nSinal)
elseiF Empty(cCodCli)
    nSemClien += (nValor * nSinal)
Else
   _aTipo[Len(_aTipo)][02] := (nValor * nSinal)
EndIf


Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PesqDevTrc ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 23/05/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Pesquisa troca ou devolucao para a venda                      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PesqDevTrc()
Local nReg
Local cAlias := Alias()
Local cBusca := XFILIAL("SE5")+TRB->D1_SERIE+TRB->D1_DOC+"1 "//+"NCC"+D1_FORNECE+D1_LOJA
Local cRet   := ""

dbSelectArea("SE5")
dbSetOrder(7)

If dbSeek(cBusca,.T.)  // Pesquisa na Tabela SE5
	
	While !Eof() .And. cBusca == SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA) //+E5_TIPO+E5_CLIFOR+E5_LOJA
		
		If SE5->E5_DATA == MV_PAR01
			
			If SE5->E5_TIPO == "NCC"  //Crédito utilizados
				If !Empty(SE5->E5_DOCUMEN) .And. dbSeek(SE5->E5_FILIAL+SubStr(SE5->E5_DOCUMEN,1,13)) //+E5_CLIFOR+E5_LOJA)
					dbSelectArea("SL1")
					dbSetOrder(2)
					If dbSeek(XFILIAL("SL1")+SE5->E5_PREFIXO+SE5->E5_NUMERO)
						cRet := "T"
						Exit
					Endif
					dbSelectArea("SE5")
				Endif
			ElseIf Alltrim(SE5->E5_TIPO) == "R$"
				If SE5->E5_NATUREZ == "DEV./TROCA"  // Devoluções em Dinheiro
					cRet := "R"
				EndIf
			EndIf
			
		Endif
		
		SE5->(dbSkip())
		
	Enddo
	
Else
	// Pesquisa as NCC geradas por Devoluções
	If SE1->(dbSeek(cBusca+"NCC",.T.))  // Pesquisa na Tabela SE1
		cRet := "D"
	EndIf
	
EndIf

dbSelectArea(cAlias)
Return(cRet)

Static Function CriaSx1()
U_PIPutSx1(cPerg,"01","Data "    ,"Data "    ,"Data "   ,"mv_ch1","D",8,0,0,"G","","","","","mv_par01")
U_PIPutSx1(cPerg,"02","1o Caixa ","1o Caixa ","1o Caixa","mv_ch2","C",3,0,0,"G","","SA6","","","mv_par02")
U_PIPutSx1(cPerg,"03","2o Caixa" ,"2o Caixa ","2o Caixa","mv_ch3","C",3,0,0,"G","","SA6","","","mv_par03")
U_PIPutSx1(cPerg,"04","3o Caixa" ,"3o Caixa ","3o Caixa","mv_ch4","C",3,0,0,"G","","SA6","","","mv_par04")
U_PIPutSx1(cPerg,"05","4o Caixa" ,"4o Caixa ","4o Caixa","mv_ch5","C",3,0,0,"G","","SA6","","","mv_par05")
U_PIPutSx1(cPerg,"06","5o Caixa" ,"5o Caixa ","5o Caixa","mv_ch6","C",3,0,0,"G","","SA6","","","mv_par06")
Return Nil

Static Function PegaSaldo(cCX1,cCX2,cCX3,cCX4,cCX5)

DbSelectArea("SE8")
DbSetOrder(1)

For I:=1 to 5
	
	Do Case
		Case I == 1
			cBanco := cCX1+".    "+".         "
		Case I = 2
			cBanco := cCX2+".    "+".        "
		Case I = 3
			cBanco := cCX3+".    "+".         "
		Case I = 4
			cBanco := cCX4+".    "+".         "
		Case I = 5
			cBanco := cCX5+".    "+".         "
	EndCase
	
	SE8->(DbSeek(xFilial()+cBanco+Dtos(mv_par01),.T.))
	SE8->(DbSkip(-1))
	
	If SE8->(E8_FILIAL+E8_BANCO+E8_AGENCIA+E8_CONTA) == xFilial("SE8")+cBanco
		nSaldo += E8_SALATUA
	EndIf
	
Next

Return


Static Function fwDevolCC(nTipo,cCX1,cCX2,cCX3,cCX4,cCX5)
 Local nVAlor := 0 
 
	cQry2 := "SELECT ISNULL(SUM(E1_VALOR),0) AS DEVCC " 
	cQry2 +=   "FROM "+RetSQLName("SE5") + " A "
	cQry2 +=  "INNER JOIN "+RetSQLName("SE1") + " B "
	cQry2 +=     "ON B.D_E_L_E_T_ = '' AND SUBSTRING(E5_DOCUMEN,1,3) = E1_PREFIXO "
	cQry2 +=    "AND SUBSTRING(E5_DOCUMEN,4,9) = E1_NUM "
	cQry2 +=  "WHERE A.D_E_L_E_T_ = '' "
	cQry2 +=    "AND E5_MOTBX = 'CMP' AND E5_FILORIG = '"+SM0->M0_CODFIL+ "'
	cQry2 +=    "AND E5_TIPO = '"+nTipo+"' "
	cQry2 +=    "AND E1_TIPO = 'NCC' "
	cQry2 +=    "AND E1_PORTADO IN ( '"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"','"+cCX5+"')"
	cQry2 +=    "AND E5_DATA = '"+Dtos(MV_par01)+"' "

	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry2)), "TRB", .T., .F. )
	nValor += DEVCC
	dbCloseArea()
		
Return nValor 
