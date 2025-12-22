#INCLUDE "rwmake.ch"
#include "Protheus.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AALOJR02   ¦ Autor ¦                      ¦ Data ¦ 01/02/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Lista de separação de pedidos de venda                     	¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AALOJR05(lSetPrint,cPorta,cdExigOs,cdOrc,cdOrcTo,cdFilial,_wdrel)


SetPrvt("ARETURN,NPAG,LI,TOTPAGINA,DESCPAGINA,TOTGERAL")
SetPrvt("DESCITEM,DESCTOTAL,FORMA,NLASTKEY")

//lSetPrint  := If( lSetPrint == Nil , .F., lSetPrint)
Default lSetPrint  := .F.
Default cPOrta     := ""
Default cdExigOs   := ""
Default cdOrc      := ""
Default cdOrcTo    := cdOrc
Default cdFilial   := SL1->(xFilial("SL1"))
Default _wdRel     := ""

titulo   := "IMPRESSAO DO PEDIDO"
cDesc1   := PADC("Este programa ir  emitir um pedido",120)
cDesc2   := ""
cDesc3   := ""
cString  := "SC5"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
Li       := iIf(Type("LI") = "U",01,Li)
nLastKey := 0
cPerg    := Padr("AA_LOJR05", Len(SX1->X1_GRUPO) )
wnrel    := iIf(Empty(_wdRel),"AALOJR05"+CUSERNAME,_wdRel)

p_negrit_l := "E"
p_reset    := "@"
p_negrit_d := "F"

//If cPedido == Nil
CriaSx1(cPerg)
Pergunte(cPerg,!lSetPrint)

//Else
// cPerg    := ""
//  mv_par01 := cPedido
//Endif

dbSelectArea("SC5")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lSetPrint .And. !Empty(cPorta)
		wnrel := SetPrint(cString,wnRel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,,.F.,"P",,,,"EPSON.DRV",.T.,.F.,cPorta)
Else
		wnrel := SetPrint(cString,wnRel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,,,"P",,,,,.F.)
Endif

If lSetPrint
	mv_par01 := cdOrc
	mv_par02 := cdOrcTo
	mv_par03 := cdFilial
EndIf

If nLastKey == 27
	Return
Endif

If Empty(_wdrel)
	SetDefault(aReturn,cString)
	If nLastKey == 27
		Return
	Endif
	
	aDriver := ReadDriver() //Instru;áo caveira do mestre Ronilton	
	@ 00,000 PSAY &(aDriver[aReturn[4]+2]) // Complemento da instru;áo
EndIf

RptStatus({|| RunReport(lSetPrint,cdExigOs) }, Titulo)

If Empty(_wdrel)
//	Set Device To Screen
	If aReturn[5] == 1
		Set Printer To
		dbCommitAll()
		OurSpool(wnrel)
	EndIf
	MS_FLUSH()
EndIf


/*If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf
Ms_FLush()
Return(.T.)
  */
Return

//************************************************************************************

Static Function RunReport(lSetPrint,cdExigOs)

Local nCont   := 1
Local nMaxLin := 32

Private nwTam := 132
Private cTable:= ""
Private _ndTotDesc := 0
Private _ndTotIcms := 0
cTable := fTabTmp(cdExigOs)
While !(cTable)->(EOF())
	//Li := 001
	
	DbSelectArea("SL1")
	SL1->(DbSetOrder(1))
	
	If SL1->(DbSeek((cTable)->(L1_FILIAL + L1_NUM)))
		
		SC5->(dbSetOrder(1))
		SC5->(dbSeek((cTable)->(L1_FILIAL + L1_PEDRES) ))
		
		nPag       := 1
		Cabec1() //Imprime o cabecalho do pedido
		Cabec2() //Cabecalho de Venda
		TotPagina  := 0
		DescPagina := 0
		
		nTotal1    := 0
		nTotal2    := 0
		nTotal3    := 0
		nTotal4    := 0
		
		TotGeral   := 0
		DescTotal  := 0
		_ndTotIcms := 0
		cChave := (cTable)->(L1_FILIAL + L1_NUM + BM_XEXIGOS )
		_ndTotDesc := 0
		While (cTable)->(!Eof()) .And. cChave == (cTable)->(L1_FILIAL + L1_NUM + BM_XEXIGOS )
			SF4->(dbSetOrder(1))
		    SF4->(dbSeek(xFilial('SF4')+(cTable)->L2_TES))

			DbSelectArea("SB1")
			DbSetOrder(1)
			If SB1->(DbSeek(xFilial("SB1")+(cTable)->L2_PRODUTO))
              
				nPrcUnit  := (cTable)->L2_VLRITEM / (cTable)->L2_QUANT
				nTotal    := (cTable)->L2_VLRITEM
				_ndQtSeg  := convUm(SB1->B1_COD, (cTable)->L2_QUANT,0,2)
				_ndTotIcms+= iIF(SF4->F4_INCSOL == 'S', (cTable)->L2_ICMSRET ,0)
				
				_cdDescr := SB1->B1_ESPECIF
				
				@ li,02  PSay SubStr(SB1->B1_COD,1,10)
				@ li,13  Psay SubStr(_cdDescr,1,50)
				
				@ li,74 - 11  Psay (cTable)->L2_UM
				@ li,79 - 13  PSay Transform( (cTable)->L2_QUANT,"@E   999,999.99")
				
				@ li,091 - 11 Psay SB1->B1_SEGUM
				@ li,096 - 13 PSay Alltrim( Transform(_ndQtSeg ,"@E   999,999.99")  )
				
				@ li,95 	 PSay Alltrim(Transform(nPrcUnit      ,PesqPict("SL2","L2_VRUNIT",18,2) )  )
				
				@ li,108  PSay Alltrim(Transform(nTotal        ,PesqPict("SL2","L2_VLRITEM",18,2) ) )
				
				//@ li,120 PSay (cTable)->(L1_PEDRES + '/' + L1_FILIAL)
				
				li := li + 1
				_cdDescr := SubStr(_cdDescr,51,50)
				While !EMpty(_cdDescr)
				   @ li,13  Psay SubStr(_cdDescr,1,50)
				     li := li + 1
				     _cdDescr := SubStr(_cdDescr,51,50)
				EndDo
				
				nTotal1  += (cTable)->L2_QUANT * SB1->B1_PESO
				nTotal2  += _ndQtSeg
				nTotal3  += nPrcUnit
				nTotal4  += nTotal
				_ndTotDesc += (cTable)->L2_VALDESC
				
			Endif
			/*
			@ 27,108 PSay "LINHA 27"
			@ 28,108 PSay "LINHA 28"
			@ 29,108 PSay "LINHA 29"
			@ 30,108 PSay "LINHA 30"
			@ 31,108 PSay "LINHA 31"
			@ 32,108 PSay "LINHA 32"
			@ 33,108 PSay "LINHA 33"
			*/
			(cTable)->(DbSkip())
		EndDo
		Geral()
		RodapeForm()
		nLiBack := li
		nPag := (int(nLiBack / nMaxLin) + 1)
		
		while(li <= nMaxLin * nPag  + (nPag - 1)*1/* nCont*/ )
			@ li,108 PSay ""
			li++
		EndDo
		nCont++
	EndIf
Enddo

(cTable)->(dbCloseArea())

//@ li,01 PSay Chr(18)

Return
***************************************************************************************
Static Function Cabec1()

// li:=01

@ li,000 PSay Chr(15)+" "
@ li,001 PSay Replicate("-",nwTam)
li++
@ li,001 PSay PADC(ALLTRIM(SM0->M0_NOMECOM),nwTam); li := li + 1
// @ li,001 Psay PADC(SM0->M0_ENDENT,nwTam); li := li + 1
// @ li,001 Psay PADC("Fone: "+SM0->M0_TEL+" Fax: "+SM0->M0_FAX,nwTam); li := li + 1
// @ li,001 Psay PADC(" CEP.: "+Transform(SM0->M0_CEPENT,"@R 99.999-999")+" - "+Alltrim(SM0->M0_CIDENT)+"-"+SM0->M0_ESTENT,nwTam); li := li +1
// @ li,001 Psay PADC("CNPJ.: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+" - IE.: "+SM0->M0_INSC,nwTam); li := li + 1
@ li,001 PSay PADC("LISTA DE SEPARACAO DO ORCAMENTO "+ SL1->L1_NUM+ " * DOC PED "+ SL1->L1_DOCPED+ "     Data Emissao :" +DTOC(SL1->L1_EMISSAO)+" - "+Time(),nwTam)
li := li + 1
@ li,001 PSay Replicate("-",nwTam)
li := li + 1
Return
***************************************************************************************

Static Function Cabec2()

SA1->(DbSetOrder(1))
SA1->(DbSeek(XFILIAL()+(cTable)->L1_CLIENTE+(cTable)->L1_LOJA))
SE4->(DbSetOrder(1))
SE4->(DbSeek(XFILIAL()+SC5->C5_CONDPAG))
SA3->(DbSetOrder(1))
SA3->(DbSeek(XFILIAL()+(cTable)->L1_VEND))

cFormPag := SL1->L1_FORMPG
cDescPag := Posicione("SX5",1,XFILIAL("SX5")+"24"+cFormPag,"X5_DESCRI")

//  li := 08

@ li,001 PSay "Cliente  : "+AllTrim(SA1->A1_NOME) + "  ( " + AllTrim(SA1->A1_NREDUZ) + " )"
@ li,072 PSay "Codigo   : "+AllTrim(SA1->A1_COD) + Space(1) + SA1->A1_LOJA; li := li + 1

@ li,001 PSay "Endereco : "+Alltrim(Left(SA1->A1_END,50))
@ li,072 PSay "Bairro   : "+AllTrim(SA1->A1_BAIRRO); li := li + 1

@ li,001 PSay "End. Ent.: "+Alltrim(Left((cTable)->L1_ENDENT,50))
@ li,072 PSay "Bairro Ent.: "+AllTrim((cTable)->L1_BAIRROE); li := li + 1

@ li,001 PSAY AllTrim ( "Munic./UF: "+ If( Empty((cTable)->L1_MUNE), AllTrim(SA1->A1_MUN), (cTable)->L1_MUNE)  + " - " + If( Empty((cTable)->L1_ESTE), AllTrim(SA1->A1_EST), (cTable)->L1_ESTE)  )
@ li,044 PSAY AllTrim("Receptor: " + AllTrim((cTable)->L1_RECENT) )
li++
@ li,001 PSAY "I.E. : " + SA1->A1_INSCR
li := li + 1
@ li,001 PSAY AllTrim("Referência: " + AllTrim((cTable)->L1_REFEREN) ) //; li := li + 1
li++

@ li,001 PSay AllTrim("Telefone : "+If ( EmPty((cTable)->L1_FONEENT), AllTrim(SA1->A1_TEL), AllTrim((cTable)->L1_FONEENT) ) )
@ li,033 PSay AllTrim("Fax : "+SA1->A1_FAX )
@ li,072 Psay AllTrim("CNPF/CPF : "+AllTrim(SA1->A1_CGC))
@ li,103 Psay AllTrim("Entrega: " + If( (cTable)->L1_ENTREGA == "S", "SIM", "NAO" ))

li:=li+1
aPagtos := GetForm((cTable)->L1_FILIAL,(cTable)->L1_NUM)
For nK := 1 To Len(aPagtos)
  _cPgto := aPagtos[nK] + iIF(nK!=Len(aPagtos),'/','')
Next

/*If Alltrim((cTable)->L1_CONDPG) = "CN" .And. Len(aPagtos) != 0	
  @ li,001 PSay "C. Pagto :  " + _cPgto 
  li++
else */
  @ li,001 PSay "C. Pagto :  " +  Alltrim((cTable)->L1_CONDPG + ' - ' + Posicione('SE4',1,xFilial('SE4') + (cTable)->L1_CONDPG ,'E4_DESCRI'))   +iIF(Len(Alltrim(_cPgto))!=0, "     (" + _cPgto + ")","")
//EndIf
li++
@ li,001 PSay "Vendedor: "+AllTrim(SA3->A3_COD)+" - "+AllTrim(SA3->A3_NREDUZ)
li++
@ li,001 PSay "Observacoes: "
@ li,015 PSay (cTable)->L1_OBSENT1 ; li++
@ li,015 PSay (cTable)->L1_OBSENT2 ; li++

If !Empty( (cTable)->L1_XNUMOS)
   @ li,001 PSay p_negrit_l + "ORDEM DE SERVICO: " + (cTable)->L1_XNUMOS + p_negrit_d 
     li++
EndIf

iF SL1->(FieldPos("L1_OBSENT3")) > 0
   @ li,015 PSay (cTable)->L1_OBSENT3 ; li++
EndIf

If SL1->(FieldPos("L1_OBSENT4")) > 0
  @ li,015 PSay (cTable)->L1_OBSENT4 ; li++
EndIf

If SL1->L1_RECLOC == "S"
li := li + 1
@ li,034 PSAY p_negrit_l + " *****    R E C E B E R     N O     L O C A L    *****" + p_negrit_d
EndIf
li := li + 1
//@ li,001 PSay "Orcamento: " + SL1->L1_NUM
//Impressão dos Itens
@ li,01 PSay Replicate("-",nwTam); li := li + 1
//   @ li,01 PSay "  PRODUTO           DESCRICAO                                            1.UM  QTD 1.UM   2.UM   QTD 2.UM    PRC UNI   TOTAL "

@ li,02  PSay "PRODUTO"
@ li,12  Psay "DESCRICAO"

@ li,74 - 13  Psay "1.UM "
@ li,79 - 11  PSay "QTD 1.UM"

@ li,091 - 12 Psay "2.UM"
@ li,096 - 11 PSay "QTD 2.UM"

@ li,108 - 12 PSay "PRC UNI"
@ li,120 - 12 PSay "TOTAL"

//@ li,132 - 12 PSay "Pedido"

//                        1         2         3         4         5         6         7         8         9        10        11        12
//               123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//               99999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX 99,999  999,999.99  9,999.99  99.9 999,999.99  X
li := li + 1
@ li,01 Psay Replicate("-",nwTam)
li := li + 1

Return

Static Function RodapeForm()

@ li,01 Psay Replicate("-",nwTam); li := li +1
@ li,01 PSay PADC("CONFIRA O MATERIAL NO ATO DE ENTREGA, NAO ACEITAMOS RECLAMACOES POSTERIORES",nwTam)
li := li + 1
@ li,01 Psay Replicate("-",nwTam); li := li +1
@ li,01       PSay "EMISSAO: " +DTOC(SL1->L1_EMISSAO)
@ li,PCol()+1 PSay "ENTREGAR ATE: " + DTOC(SL1->L1_DTLIM)
@ li,PCol()+1 PSay "RECEBI:    /    /  "
@ li,PCol()+1 PSay "ASS. CLIENTE:_________________________________ "
@ li,PCol()+3 PSay "ORCAMENTO: " + SL1->L1_NUM ; li := li + 1

//   @ li,01 PSay Chr(18)

Return

Static Function Geral()
Local cQry

li++
@ li,01 PSay Replicate("-",nwTam) ; li := li + 1

@ li,01 PSay "Peso Total: " + AllTrim(Transform(nTotal1,"@E 999,999.99"))
//@ li,33 PSay "Total Quant 2. UM: "+AllTrim(Transform(nTotal2,"@E 999,999.99"))
@ li,27 PSay "Total Valor Unit : " + AllTrim(Transform(nTotal3,"@E 999,999.99"))
@ li,60 PSay "Desconto : " + AllTrim(Transform(_ndTotDesc,"@E 999,999.99"))
@ li,78 PSay "ICMS Retido : " +  AllTrim(Transform(_ndTotIcms,"@E 999,999.99"))
@ li,99 PSay "Total Orcamento : " + AllTrim(Transform(nTotal4 + _ndTotIcms,"@E 999,999.99"))

// li := li + 1

//@ li,01 PSay Replicate("-",nwTam) ; li := li + 1

Col    := 1
QtdCol := 1
nItem  := 1

dbCloseArea()
dbSelectArea("SC5")

li++
Return

*----------------------------------------------------------------------------------------------*
Static Function CriaSx1(cPerg)
*----------------------------------------------------------------------------------------------*

PutSX1(cPerg,"01","Orcamento De?","","","mv_ch1","C",06,0,0,"G","","SL1","","","mv_par01")
PutSX1(cPerg,"02","Orcamento Ate?","","","mv_ch2","C",06,0,0,"G","","SL1","","","mv_par02")
PutSX1(cPerg,"03","Filial ?","",""      ,"mv_ch3","C",02,0,0,"G","","   ","","","mv_par03")

Return Nil

*----------------------------------------------------------------------------------------------*
Static Function fTabTmp(cdExigOs)
*----------------------------------------------------------------------------------------------*
// Função que soma a quantidade de produtos com Orcamentos em abertos e NAO vencidos

Local cTable := GetNextAlias()
Local cArea  := GetArea()
Local cQry2  := ""

/*
cQry2 +=   " select L1.*,L2.*,BM_XEXIGOS from " + RetSqlName("SL2") + "  L2
cQry2 +=   "   Left Outer Join " + RetSqlName("SL1") + " L1 on L1_NUM = L2_NUM and L1_FILIAL = L2_FILIAL
cQry2 +=   "   Left Outer Join " + RetSqlName("SL2") + " L2B on L2B.L2_NUM = L1.L1_NUM and L1.L1_FILIAL = L2B.L2_FILIAL and L2B.L2_PRODUTO = L2.L2_PRODUTO
cQry2 +=   "   Left Outer Join (Select * From " + RetSqlName("SB1") + " where D_E_L_E_T_='') SB1 on SB1.B1_COD = L2B.L2_PRODUTO
cQry2 +=   "   Left Outer Join (Select * From " + RetSqlName("SBM") + " where D_E_L_E_T_='') SBM on SBM.BM_GRUPO = SB1.B1_GRUPO
cQry2 +=   " Where L2.D_E_L_E_T_ = '' and L1.D_E_L_E_T_ = '' And L2B.D_E_L_E_T_ = ''
cQry2 +=   " And L2.L2_NUM BetWeen '" + mv_par01 + "' And '" + mv_par02 + "'
cQry2 +=   " And L2.L2_FILIAL = '" + mv_par03 + "'
*/

cQry2 +=   " select L1.*,L2.*,BM_XEXIGOS from " + RetSqlName("SL2") + "  L2
cQry2 +=   "   Left Outer Join " + RetSqlName("SL1") + " (NOLOCK) L1 on L1_NUM = L2_NUM and L1_FILIAL = L2_FILIAL and L1.D_E_L_E_T_ = '' "
cQry2 +=   "   Left Outer Join " + RetSqlName("SL1") + " (NOLOCK) L1B on L1B.L1_NUM = L1.L1_NUM and L1.L1_FILIAL = L1B.L1_FILIAL And L1B.D_E_L_E_T_ = ''
//cQry2 +=   "   Left Outer Join (Select * From " + RetSqlName("SB1") + " where D_E_L_E_T_='') SB1 on SB1.B1_COD = L2.L2_PRODUTO
cQry2 +=   "   Left Outer Join " + RetSqlName("SB1") + " (NOLOCK) SB1 ON SB1.D_E_L_E_T_='' AND SB1.B1_COD = L2.L2_PRODUTO "
//cQry2 +=   "   Left Outer Join (Select * From " + RetSqlName("SBM") + " where D_E_L_E_T_='') SBM on SBM.BM_GRUPO = SB1.B1_GRUPO
cQry2 +=   "   Left Outer Join " + RetSqlName("SBM") + " (NOLOCK) SBM ON SBM.D_E_L_E_T_='' AND SBM.BM_GRUPO = SB1.B1_GRUPO	"
cQry2 +=   " Where L2.D_E_L_E_T_ = '' " 
cQry2 +=   " And L2.L2_NUM BetWeen '" + mv_par01 + "' And '" + mv_par02 + "'
cQry2 +=   " And L2.L2_FILIAL = '" + mv_par03 + "'

If cdExigOs = 'S'
	cQry2 +=   " And BM_XEXIGOS = 'S'"
elseif cdExigOs = 'N'
	cQry2 +=   " And BM_XEXIGOS != 'S'"
EndIf

cQry2 +=   " Order By BM_XEXIGOS,L1.L1_FILIAL,L2.L2_NUM,L2_PRODUTO

//aviso('',cqry2,{'Ok'},3)

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry2)), cTable, .T., .F. )

Return cTable

Static Function GetForm(_cdFilial,_cdOrcamento)
Local _cdForm  := ""
Local _adForm  := {}
Local _adForma := {}

SL4->(dBSetOrder(1))

If SL4->(dbSeek(_cdFilial + _cdOrcamento))
	
	While(!SL4->(EOF()) .And. (_cdFilial + _cdOrcamento) == SL4->(L4_FILIAL + L4_NUM)  )
		_ndPos := iIf( Len(_adForm) !=0, aScan(_adForm,{|x| x[01] == SL4->L4_FORMA} ),0)
		If _ndPos > 0
			_adForm[_ndPos][02] += SL4->L4_VALOR
			_adForm[_ndPos][03] += 1
		else
			aAdd(_adForm,{SL4->L4_FORMA,SL4->L4_VALOR,1})
		Endif
		SL4->(dbSkip())
	EndDo
	
	_adForma := {""}
	_ndItem  := 01
	For nI := 1 to Len(_adForm)
		_cdForm := iIf(Empty(_adForma[_ndItem]),"","/") + Alltrim(Transform(_adForm[nI][02],"@E 999,999,999.99")) + " " + Alltrim(Str(_adForm[nI][03]) + "x" + Alltrim(_adForm[nI][01]) )
		If Len(_adForma[_ndItem]) + Len(_cdForm) + iIf(Empty(_adForma[_ndItem]),0,1) >= 132
			_ndItem++
		EndIf
		_adForma[_ndItem] += _cdForm
	Next
Else
	_adForma := {""}
EndiF

Return _adForma