#INCLUDE "rwmake.ch"
#Include "Protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATR02   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 01/02/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Lista de separação de pedidos de venda                     	¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦+---------------------------------------------------------------------------+¦¦
¦¦¦                          ALTERAÇÕES NO PROGRAMA 									¦¦¦
¦¦+-----------+------------+-------+------------------------------------------+¦¦ 
¦¦¦ Usuário   ¦ Marcio     ¦ Autor ¦ Diego Rafael         ¦ Data ¦   /02/2011 ¦¦¦
¦¦+-----------+------------+-------+------------------------------------------+¦¦
¦¦¦ Descriçäo ¦ Alteração da impressão para ficar em uma página 	         	¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦+---------------------------------------------------------------------------+¦¦
¦¦¦                          ALTERAÇÕES NO PROGRAMA 									¦¦¦
¦¦+-----------+------------+-------+------------------------------------------+¦¦ 
¦¦¦ Usuário   ¦ Marcio     ¦ Autor ¦ Diego Rafael         ¦ Data ¦   /02/2011 ¦¦¦
¦¦+-----------+------------+-------+------------------------------------------+¦¦
¦¦¦ Descriçäo ¦ Imprimir tanto com as informações do Orçamento do loja quanto +¦¦
¦¦¦           ¦ com as informações do pedido de venda de acordo com a escolha +¦¦
¦¦¦           ¦ do Usuário.                                                   +¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function AAFATR02(_cdPedido,_cdFilial)

	SetPrvt("ARETURN,NPAG,LI,TOTPAGINA,DESCPAGINA,TOTGERAL")
	SetPrvt("DESCITEM,DESCTOTAL,FORMA,NLASTKEY")

	Default _cdPedido := ""
	Default _cdFilial := ""

	Private _cdPed := _cdPedido
	Private _cdFil := _cdFilial

    Private lContinuo := .F.
	lSetPrint  := .F. //If( lSetPrint == Nil , .F., lSetPrint)

	titulo   := "IMPRESSAO DO PEDIDO"
	cDesc1   := PADC("Este programa ir  emitir um pedido",120)
	cDesc2   := ""
	cDesc3   := ""
	cString  := "SC5"
	aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
	wnrel    := "PEDIDO"
	Li       := 01
	nLastKey := 0
	cPerg    := Padr("AA_FATR01", Len(SX1->X1_GRUPO) )
	Private m_pag      := 01
	Private tamanho := "M"

	p_negrit_l := "E"
	p_reset    := "@"
	p_negrit_d := "F"

//If cPedido == Nil
	CriaSx1(cPerg)
	Pergunte(cPerg,.F.)
//Else
// cPerg    := ""
//  mv_par01 := cPedido
//Endif

	dbSelectArea("SC5")
	dbSetOrder(1)

//MaFisSave()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lSetPrint //.Or. __cUserID == "000103"  // Se for o DOLLAR
		wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,,.F.,"M",,,,"EPSON.DRV",.T.,.F.,"LPT1")
		lContinuo := .T.
	Elseif !Empty(_cdPedido)
		wnrel := SetPrint(cString,wnrel,     ,Titulo,cDesc1,cDesc2,cDesc3,.T.,,,"M")
		mv_par01 := _cdPedido
		mv_par02 := _cdPedido
		mv_par03 := 1
	//ALERT("1")
		mv_par04 := 1
		lContinuo := .F.
	else
		wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,,,"M")
		lContinuo := .F.
	Endif

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	aDriver := ReadDriver() //Instru;áo caveira do mestre Ronilton

	@ 00,000 PSAY &(aDriver[aReturn[4]+2]) // Complemento da instru;áo

	RptStatus({|| RunReport(lSetPrint) }, Titulo)

	Set Device To Screen
	If aReturn[5] == 1
		Set Printer TO
		dbcommitAll()
		ourspool(wnrel)
	Endif
	MS_FLUSH()

//MaFisRestore()

Return

//************************************************************************************

Static Function RunReport(lSetPrint)

	Local nCont        := 1
	Local nMaxLin      := 32
	Local cPorta       := iIF(lSetPrint,"LPT1","")
	Private _ndTotDesc := 0
	Private nwTam      := 132
	Private _ndTotIcms := 0

	Li := 001
    
    //("","","","aafatr02","M",18)
    
	fTabTmp()
	While !TRB->(EOF())
	//Li := 001admin
	
		DbSelectArea("SC5")
		DbSetOrder(1)
		lSkip := .F.
		If DbSeek(SC5->(Xfilial())+TRB->C5_NUM)
	
	   // Para Imprimir a Lista de separacao do orcamento Referente ao Pedido Quando o Mesmo Existir e a Prioridade for Orcamento
			If !Empty(SC5->C5_ORCRES) .And. mv_par04 = 1
				SL1->(dBSetOrder(1))
				If SL1->(dbSeek(SC5->(C5_FILIAL + C5_ORCRES) ))
					u_AALOJR02(!lSetPrint,cPorta,"",SL1->L1_ORCRES,SL1->L1_ORCRES,SL1->L1_FILRES,wnrel,.T.)
				EndIf
				TRB->(dbSkip())
				LOOP
			EndIf
		// Powered by DXRCOVRB
		
			If SC5->C5_TIPO <> "N"
				Return
			Endif

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
		
			aProd := aClone(U_AAGETFIS())
		
			DbSelectArea("SC6")
			DbSetOrder(1)
			DbSeek(Xfilial()+TRB->C5_NUM)
		
			SC9->(dbSetOrder(1))
			_ndTotDesc := 0
			While SC6->(!Eof()) .And. SC6->C6_NUM == TRB->C5_NUM
			                            
				If SC6->C6_QTDVEN <= SC6->C6_QTDENT
					SC6->(dbSkip())
					Loop
				EndIf
			
				DbSelectArea("SB1")
				DbSetOrder(1)
			
				If SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
				// WERMESON 19/05/11 - SOLICITADO POR GERENTE ALEXSANDRO (TOTVS)
					_ndQtdLib1 := SC6->C6_QTDVEN - SC6->C6_QTDENT //SC9->C9_QTDLIB
					_ndQtdLib2 := SC6->C6_UNSVEN - SC6->C6_QTDENT2 //SC9->C9_QTDLIB2
				
					nPrcUnit := If( SC6->C6_DESCONT == 0 , SC6->C6_PRCVEN, iIf(SC6->C6_PRUNIT==0, (SC6->C6_VALOR + SC6->C6_VALDESC) / SC6->C6_QTDVEN,SC6->C6_PRUNIT) )
					nTotal := nPrcUnit * _ndQtdLib1
				
					SC9->(dbSeek(xFilial('SC9') + SC6->(C6_NUM + C6_ITEM)))
				
				
					@ li,02  PSay SubStr(SB1->B1_COD,1,15)
					@ li,21  Psay SubStr(SB1->B1_ESPECIF,1,50)
				
					@ li,74  Psay SC6->C6_UM
					@ li,79  PSay Transform(_ndQtdLib1,"@E   999,999.99")
				
					@ li,091 Psay SC6->C6_SEGUM
					@ li,096 PSay Alltrim( Transform(_ndQtdLib2,"@E   999,999.99") )
				
					@ li,110 PSay Alltrim( Transform(nPrcUnit      ,PesqPict("SL2","L2_VRUNIT",18,2)) )
					@ li,120 PSay Alltrim( Transform(nTotal        ,PesqPict("SL2","L2_VLRITEM",18,2)) )
				
					li := li + 1
				
					nTotal1    += _ndQtdLib1 * SB1->B1_PESO//SC6->C6_QTDLIB
					nTotal2    += _ndQtdLib2//SC6->C6_QTDLIB2
					nTotal3    += nPrcUnit
					nTotal4    += nTotal - SC6->C6_VALDESC
					_ndTotDesc += SC6->C6_VALDESC
					For nI := 1 to Len(aProd)
						If SC6->C6_PRODUTO == aProd[nI]
							_nX := nI
						EndIf
					Next
				
					If _nX > 0
						_ndTotIcms += MaFisRet(_nX,"IT_VALSOL")
					EndIf
				Endif
			
			    if li > 70
			    	//Cabec("","","","aafatr02","M",18)
			    	If !lContinuo
				    	@ li,002 PSay "Continua na proxima pagina -----------------> "
				    	Li := 001
				    	@ li,002 PSay " <----------------- Continuação "
				    	Li := 003
				    	Cabec1() //Imprime o cabecalho do pedido
				    	Cabec2() //Cabecalho de Venda
			    	EndIF
			    	
			    EndIf
				SC6->(DbSkip())
			EndDo
		
			For nI := 1 to Len(aProd)
				MaFisDel(nI,.T.)
			Next
			MaFisWrite(1)
			MaFisEnd()

			Geral()
			RodapeForm()
			nLiBack := li
			nPag := (int(nLiBack / nMaxLin) + 1)
		
			TRB->(dbSkip())
			lSkip := .T.
			If !(TRB->(EOF()))
				while(li <= nMaxLin * nPag  + (nPag - 1)*1/* nCont*/ )
				@ li,108 PSay ""
				li++
			EndDo
		EndIf
		nCont++
	EndIf
	If !lSkip
		TRB->(dbSkip())
	EndIf
End
@ li,01 PSay Chr(18)
TRB->(dbCloseArea())
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
	@ li,001 PSay PADC("LISTA DE SEPARACAO DO PEDIDO " + SC5->C5_FILIAL + "/" + SC5->C5_NUM + "       Data Emissao :" +DTOC(SC5->C5_EMISSAO)+" - "+Time(),nwTam)
	li := li + 1
	@ li,001 PSay Replicate("-",nwTam)
	li := li + 1
Return
***************************************************************************************

Static Function Cabec2()

	SA1->(DbSetOrder(1))
	SA1->(DbSeek(XFILIAL()+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	SE4->(DbSetOrder(1))
	SE4->(DbSeek(XFILIAL()+SC5->C5_CONDPAG))
	SA3->(DbSetOrder(1))
	SA3->(DbSeek(XFILIAL()+SC5->C5_VEND1))

	cFormPag := SL1->L1_FORMPG
	cDescPag := Posicione("SX5",1,XFILIAL("SX5")+"24"+cFormPag,"X5_DESCRI")

//  li := 08

	@ li,001 PSay "Cliente  : "+AllTrim(SA1->A1_NOME) + "  ( " + AllTrim(SA1->A1_NREDUZ) + " )"
	@ li,066 PSay "Codigo   : "+AllTrim(SA1->A1_COD) + Space(1) + SA1->A1_LOJA; li := li + 1

	@ li,001 PSay "Endereco : "+Alltrim(Left(SA1->A1_END,50))
	@ li,066 PSay "Bairro   : "+AllTrim(SA1->A1_BAIRRO); li := li + 1

	@ li,001 PSay "End. Ent.: "+Alltrim(Left(SC5->C5_ENDENT,50))
	@ li,066 PSay "Bairro Ent.: "+AllTrim(SC5->C5_BAIRROE); li := li + 1

	@ li,001 PSAY AllTrim ( "Munic./UF: "+ If( Empty(SC5->C5_MUNE), AllTrim(SA1->A1_MUN), SC5->C5_MUNE)  + " - " +If( Empty(SC5->C5_ESTE), AllTrim(SA1->A1_EST), SC5->C5_ESTE)  )
	@ li,044 PSAY AllTrim("Receptor: " + AllTrim(SC5->C5_RECENT) )
	li := li + 1
	@ li,001 PSAY "I.E. : " + SA1->A1_INSCR
	li := li + 1
	@ li,001 PSAY AllTrim("Referência: " + AllTrim(SC5->C5_REFEREN) )
	li++

	@ li,001 PSay AllTrim("Telefone : "+If ( EmPty(SC5->C5_FONEENT), AllTrim(SA1->A1_TEL), AllTrim(SC5->C5_FONEENT) ) )
	@ li,033 PSay AllTrim("Fax : "+SA1->A1_FAX )
	@ li,066 Psay AllTrim("CNPF/CPF : "+AllTrim(SA1->A1_CGC))
	@ li,099 Psay AllTrim("Entrega: " + If( SC5->C5_ENTREGA == "S", "SIM", "NÃO" ))

	li:=li+1

	@ li,001 PSay "C. Pagto :  " + If(ALLTRIM(SC5->C5_CONDPAG) == "CN","COND. NEGOCIADA",SC5->C5_CONDPAG + " - " + AllTrim(SE4->E4_DESCRI))
	@ li,066 PSay "Vendedor: "+AllTrim(SA3->A3_COD)+" - "+AllTrim(SA3->A3_NREDUZ)
	@ li,099 PSAY "Receb. Local:" + If( SC5->C5_RECLOC == "S", "SIM", "NÃO" )

	li := li + 1

	@ li,001 PSay "Observacoes: "
	@ li,015 PSay SC5->C5_OBSENT1 ; li++
	@ li,015 PSay SC5->C5_OBSENT2 ; li++

//Impressão dos Itens
	@ li,01 PSay Replicate("-",nwTam); li := li + 1
	@ li,01 PSay "  PRODUTO           DESCRICAO                                            1.UM  QTD 1.UM   2.UM   QTD 2.UM    PRC UNI   TOTAL "

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
//   @ li,01 PSay Chr(18)

Return

Static Function Geral()
	Local cQry

	li++
	@ li,01 PSay Replicate("-",nwTam) ; li := li + 1

	@ li,01 PSay "Peso Total : "+AllTrim(Transform(nTotal1,"@E 999,999.99"))
//   @ li,33 PSay "Total Quant 2. UM: "+AllTrim(Transform(nTotal2,"@E 999,999.99"))
	@ li,27 PSay "Total Valor Unit : "+AllTrim(Transform(nTotal3,"@E 999,999.99"))
	@ li,60 PSay "Desconto : "        + AllTrim(Transform(_ndTotDesc,"@E 999,999.99"))
	@ li,78 PSay "ICMS Retido : " +  AllTrim(Transform(_ndTotIcms,"@E 999,999.99"))
	@ li,99 PSay "Total Pedido : "	 +AllTrim(Transform(nTotal4 + _ndTotIcms ,"@E 999,999,999,999.99"))

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

	PutSX1(cPerg,"01","Pedido de ?","","","mv_ch1","C",06,0,0,"G","","SC5","","","mv_par01")
	PutSX1(cPerg,"02","Pedido até?","","","mv_ch2","C",06,0,0,"G","","SC5","","","mv_par02")
	PutSX1(cPerg,"03","Pedido ?","",""   ,"mv_ch3","N",01,0,0,"C","","   ","","","mv_par03","Faturado","","","","Nao Faturado","","","Ambos","")
	PutSX1(cPerg,"04","Considera?","",""   ,"mv_ch4","N",01,0,0,"C","","   ","","","mv_par04","Orcamento","","","","Pedido","","","     ","")
Return Nil

*----------------------------------------------------------------------------------------------*
Static Function fTabTmp()
*----------------------------------------------------------------------------------------------*
// Função que soma a quantidade de produtos com Orcamentos em abertos e NAO vencidos

	Local cArea := GetArea()

	cQry2 := " SELECT DISTINCT C5_NUM" //, C5_CLIENTE, C5_LOJACLI, A1_NOME, B1_COD, B1_ESPECIF, "
//  cQry2 +=        " C6_UM , C6_QTDVEN , C6_SEGUM,C6_UNSVEN, C6_PRCVEN, C6_VALOR,  "
//  cQry2 +=        " C5_RECENT,C5_ENDENT,C5_FONEENT,C5_OBSENT1 ,C5_OBSENT1,C5_BAIRROE,"
//  cQry2 +=        " C5_MUNE,C5_ESTE,C5_REFEREN ,C5_RECLOC,C5_ENTREGA, C6_QTDENT"

	cQry2 +=   " FROM "+RetSQLName("SC5") + " A "

	cQry2 +=  " INNER JOIN " + RetSQLName("SC6")+" B "
	cQry2 +=     " ON C5_NUM     = C6_NUM "
	cQry2 +=    " AND C5_FILIAL  = C6_FILIAL "
	cQry2 +=    " AND B.D_E_L_E_T_ = ' ' "
	cQry2 +=     "AND B.C6_BLQ <> 'R' "

	cQry2 +=  " INNER JOIN " + RetSQLName("SB1")+" C "
	cQry2 +=     " ON B1_COD     = C6_PRODUTO "
	cQry2 +=    " AND B1_FILIAL  = '" + xFilial("SB1") + "'"
	cQry2 +=    " AND C.D_E_L_E_T_ = ' ' "

	cQry2 +=  " INNER JOIN " + RetSQLName("SA1")+" D "
	cQry2 +=     " ON A1_COD     = C5_CLIENTE "
	cQry2 +=    " AND A1_FILIAL  = '" + xFilial("SA1") + "'"
	cQry2 +=    " AND D.D_E_L_E_T_ = ' ' "

	cQry2 +=  " WHERE A.D_E_L_E_T_ = ' ' "
	cQry2 +=    " AND C5_FILIAL  = '" + xFilial("SC5") + "' "
	cQry2 +=    " AND C5_NUM BETWEEN '" + mv_par01 + "' AND '" +mv_par02+ "'"

	If mv_par03 = 1
	//cQry2 +=    " AND C5_NOTA != ''"
		cQry2 +=    " AND C6_QTDENT < C6_QTDVEN"
	elseif mv_par03 = 2
		cQry2 +=    " AND C5_NOTA = ''"
		cQry2 +=    " AND C6_QTDENT <> C6_QTDVEN"
	EndIf
	If !empty(_cdFIl)
		cQry2 +=    " And C5_FILIAL = '" + _cdFil + "'
	EndIf

	MemoWrite("AAFATR02.sql",cQry2)

	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry2)), "TRB", .T., .F. )

Return Nil

User Function AAGETFIS(_ldLib)
	Local aProdutos := {}
	Local aFisGet	 := {}
    
    Default _ldLib := .F.

	RegToMemory( "SC5", .F., .F. )

	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SC6")
	While !Eof().And.X3_ARQUIVO=="SC6"
		cValid := UPPER(X3_VALID+X3_VLDUSER)
		If 'MAFISGET("'$cValid
			nPosIni 	:= AT('MAFISGET("',cValid)+10
			nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
			cReferencia := Substr(cValid,nPosIni,nLen)
			aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		If 'MAFISREF("'$cValid
			nPosIni		:= AT('MAFISREF("',cValid) + 10
			cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
			aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		dbSkip()
	EndDo
	aSort(aFisGet,,,{|x,y| x[3]<y[3]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca referencias no SC5                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aFisGetSC5	:= {}
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SC5")
	While !Eof().And.X3_ARQUIVO=="SC5"
		cValid := UPPER(X3_VALID+X3_VLDUSER)
		If 'MAFISGET("'$cValid
			nPosIni 	:= AT('MAFISGET("',cValid)+10
			nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
			cReferencia := Substr(cValid,nPosIni,nLen)
			aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		If 'MAFISREF("'$cValid
			nPosIni		:= AT('MAFISREF("',cValid) + 10
			cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
			aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		dbSkip()
	EndDo
	aSort(aFisGetSC5,,,{|x,y| x[3]<y[3]})

	aTransp := {"",""}
	SC6->(dbSetOrder(1))
	SC6->(DBSEEK( SC5->C5_FILIAL + SC5->C5_NUM  ))

	SA4->(dbSetOrder(1))
	If SA4->(dbSeek(xFilial("SA4")+SC5->C5_TRANSP))
		aTransp[01] := SA4->A4_EST
		aTransp[02] := Iif(SA4->(FieldPos("A4_TPTRANS")) > 0,SA4->A4_TPTRANS,"")
	Endif

	MaFisSave()
	MaFisEnd()
 	/*MaFisIni( SC5->C5_CLIENTE , 
	          SC5->C5_LOJACLI , 
			  IIf(SC5->C5_TIPO$'DB',"F","C")  , SC5->C5_TIPOCLI  ,;
		NIL           , NIL         , NIL  , .F. ,;
		"SB1"         , "MATA410"  , , , , , , , , aTransp )
   */
	MaFisIni(SC5->C5_CLIENTE                   ,;	// 1-Codigo Cliente/Fornecedor
			 SC5->C5_LOJACLI                   ,;	// 2-Loja do Cliente/Fornecedor
			 If(SC5->C5_TIPO$'DB',"F","C")     ,;	// 3-C:Cliente , F:Fornecedor
			 SC5->C5_TIPO                      ,;	// 4-Tipo da NF
			 SC5->C5_TIPOCLI                   ,;	// 5-Tipo do Cliente/Fornecedor
			 MaFisRelImp("MT100",{"SF2","SD2"}),;	// 6-Relacao de Impostos que suportados no arquivo
			                                   ,;	// 7-Tipo de complemento
			                                   ,;	// 8-Permite Incluir Impostos no Rodape .T./.F.
			"SB1"                              ,;	// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
			"MATA461"                           )	// 10-Nome da rotina que esta utilizando a funcao
   
	/*If Len(aFisGetSC5) > 0
		dbSelectArea("SC5")
		For nY := 1 to Len(aFisGetSC5)
			If !Empty(&("SC5->"+Alltrim(aFisGetSC5[ny][2])))
				MaFisAlt(aFisGetSC5[ny][1],&("SC5->"+Alltrim(aFisGetSC5[ny][2])),,.F.)
			EndIf
		Next nY
	Endif
    */
//Na argentina o calculo de impostos depende da serie.
	/*If cPaisLoc == 'ARG'
		SA1->(DbSetOrder(1))
		SA1->(MsSeek(xFilial()+IIf(!Empty(SC5->C5_CLIENT),SC5->C5_CLIENT,SC5->C5_CLIENTE)+SC5->C5_LOJAENT))
		MaFisAlt('NF_SERIENF',LocXTipSer('SA1',MVNOTAFIS))
	Endif
*/
	nTotDesc := 0
		          
	While SC5->(C5_FILIAL + C5_NUM) == SC6->(C6_FILIAL + C6_NUM)


		SB1->(dbSetOrder(1))
		If SB1->(MsSeek(xFilial("SB1")+SC6->C6_PRODUTO))
			nQtdPeso := SC6->C6_QTDVEN*SB1->B1_PESO
		else
			nQtdPeso  := 0
		EndIf

		SB2->(dbSetOrder(1))
		SB2->(MsSeek(xFilial("SB2")+SB1->B1_COD+SC6->C6_LOCAL))

		SF4->(dbSetOrder(1))
		SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES) )

		SC9->(dbSetOrder(1))
		
		_ndQtd := fwTabC9(SC6->C6_FILIAL, SC6->C6_NUM, SC6->C6_ITEM, SC6->C6_PRODUTO) 
		
		If !_ldLib .And. _ndQtd == 0 
			_ndQtd := SC6->C6_QTDVEN
		ElseIf _ndQtd == 0
		    SC6->(dbSkip())
		    Loop
		EndIf

		aAdd(aProdutos,SC6->C6_PRODUTO)
		MaFisAdd(SC6->C6_PRODUTO,;   	// 1-Codigo do Produto ( Obrigatorio )
		SC6->C6_TES,;	   	// 2-Codigo do TES ( Opcional )
		_ndQtd,;  	// 3-Quantidade ( Obrigatorio )
		SC6->C6_PRCVEN,;		  	// 4-Preco Unitario ( Obrigatorio )
		SC6->C6_VALDESC * _ndQtd / SC6->C6_QTDVEN,; 	// 5-Valor do Desconto ( Opcional )
		"",;	   			// 6-Numero da NF Original ( Devolucao/Benef )
		"",;				// 7-Serie da NF Original ( Devolucao/Benef )
		0,;					// 8-RecNo da NF Original no arq SD1/SD2
		0,;					// 9-Valor do Frete do Item ( Opcional )
		0,;					// 10-Valor da Despesa do item ( Opcional )
		0,;					// 11-Valor do Seguro do item ( Opcional )
		0,;					// 12-Valor do Frete Autonomo ( Opcional )
		_ndQtd * SC6->C6_PRCVEN,;			// 13-Valor da Mercadoria ( Obrigatorio )
		0,;					// 14-Valor da Embalagem ( Opiconal )
		,;					//
		,;					//
		SC6->C6_ITEM,;
		00,;					// Despesas nao tributadas - Portugal
		0)					// Tara - Portugal
							          
		MaFisAlt("IT_PESO",nQtdPeso,Len(aProdutos))
		SF4->(dbSetOrder(1))
		SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))
		If ( SC5->C5_INCISS == "N" .And. SC5->C5_TIPO == "N")
			If ( SF4->F4_ISS=="S" )
				nPrcLista := a410Arred(SC6->C6_PRUNIT/(1-(MaAliqISS(Len(aProdutos))/100)),"D2_PRCVEN")
				MaFisAlt("IT_PRCUNI",nPrcLista,nItem)
			EndIf
		EndIf
			
		nTotDesc += MaFisRet( Len(aProdutos) ,"IT_DESCONTO")

		SC6->(dbSkip())
	EndDo

	MaFisAlt("NF_FRETE",SC5->C5_FRETE)
	MaFisAlt("NF_VLR_FRT",SC5->C5_VLR_FRT)
	MaFisAlt("NF_SEGURO",SC5->C5_SEGURO)
	MaFisAlt("NF_AUTONOMO",SC5->C5_FRETAUT)
	MaFisAlt("NF_DESPESA",SC5->C5_DESPESA)
	If SC5->C5_DESCONT > 0
		MaFisAlt("NF_DESCONTO",Min(MaFisRet(,"NF_VALMERC")-0.01,nTotDesc+SC5->C5_DESCONT),/*nItem*/,/*lNoCabec*/,/*nItemNao*/,GetNewPar("MV_TPDPIND","1")=="2" )
	EndIf

	If SC5->C5_PDESCAB > 0
		MaFisAlt("NF_DESCONTO",A410Arred(MaFisRet(,"NF_VALMERC")*SC5->C5_PDESCAB/100,"C6_VALOR")+MaFisRet(,"NF_DESCONTO"))
	EndIf

	dbSelectArea("SC6")
	SC6->(dbSeek(SC5->(C5_FILIAL + C5_NUM) ))
	If Len(aFisGet) > 0
		nX := 0
		While SC5->(C5_FILIAL + C5_NUM) == SC6->(C6_FILIAL + C6_NUM)
			nX ++
			For nY := 1 to Len(aFisGet)
				If !Empty(  &(aFisGet[ny][2]) )
					MaFisAlt(aFisGet[ny][1],&(aFisGet[ny][2]),nX,.F.)
				Endif
			Next nX
			SC6->(dbSkip())
		EndDo
	EndIf

	MaFisWrite(1)

Return aProdutos                                                                      

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ fwTabC9    ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 26/08/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ tabela temporária com os itens liberados do Pedido            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fwTabC9(cwFil, cwNum, cwItem, cwProd ) 
 Local cQry    := ""
 Local nRet    := 0
	
	cQry := " SELECT ISNULL( SUM(SC9.C9_QTDLIB), 0) AS C9_QUANT"
	cQry +=   " FROM "+RetSQLName("SC9")+" AS SC9 (NOLOCK) "
	cQry +=  " WHERE SC9.D_E_L_E_T_ = ''             "
	cQry +=    " AND SC9.C9_FILIAL  = '"+ cwFil  +"' "
	cQry +=    " AND SC9.C9_PEDIDO  = '"+ cwNum  +"' "
	cQry +=    " AND SC9.C9_ITEM    = '"+ cwItem +"' "
	cQry +=    " AND SC9.C9_PRODUTO = '"+ cwProd +"' "
 	cQry +=    " AND SC9.C9_NUMSEQ  = ''             "
 	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TEMP1",.T.,.T.)
	             
	nRet := TEMP1->C9_QUANT

	TEMP1->(dbCloseArea())
		
Return nRet



/*----------------------------------------------------------------------------------||
||       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||      AAAA       LL         LL         EE         CC        KK    KK   SS         ||
||     AA  AA      LL         LL         EE        CC         KK  KK     SS         ||
||    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   ||
||   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  ||
||  AA        AA   LL         LL         EE         CC        KK    KK          SS  ||
|| AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||----------------------------------------------------------------------------------*/
