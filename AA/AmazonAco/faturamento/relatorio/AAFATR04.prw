#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATR02   ¦ Autor ¦                      ¦ Data ¦ 01/02/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Comprovante de Entrega do pedidos de venda                  	¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAFATR04(_cdPedido,_cdFilial,_cdOrcamento,_cdFilialO,lSetPrint,lBloc)

	SetPrvt("ARETURN,NPAG,LI,TOTPAGINA,DESCPAGINA,TOTGERAL")
	SetPrvt("DESCITEM,DESCTOTAL,FORMA,NLASTKEY	")

	Default _cdPedido    := ""
	Default _cdFilial    := ""
	Default _cdOrcamento := ""
	Default _cdFilialO   := ""
	Default lSetPrint    := .F.
	Default lBloc        := .F.// Nao Imprimir os Itens BLoqueados por Padrao a Pedido do Adelson

	Private _cdPed  := _cdPedido
	Private _cdFil  := _cdFilial
	Private _cdOrc  := _cdOrcamento
	Private _cdFilO := _cdFilialO

	Private _lBlock := lBloc
	lSetPrint  := .F. //If( lSetPrint == Nil , .F., lSetPrint)

	titulo   := "IMPRESSAO DO COMPROVANTE"
	cDesc1   := PADC("Este programa ira emitir Comprovante de Venda do Pedido",120)
	cDesc2   := ""
	cDesc3   := ""
	cString  := "SC5"
	aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
	wnrel    := "AAFATR04"
	Li       := 01
	nLastKey := 0
	cPerg    := Padr("AA_FATR04", Len(SX1->X1_GRUPO) )

	p_negrit_l := "E"
	p_reset    := "@"
	p_negrit_d := "F"


	CriaSx1(cPerg)
	Pergunte(cPerg,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// lSetPrint := .T.
	If lSetPrint //.Or. __cUserID == "000103"  // Se for o DOLLAR
		wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,,.F.,"P",,,,"EPSON.DRV",.T.,.F.,"LPT1")
		/*
		wnrel := SetPrint (cString, ; // Alias
		wnrel, ; // Sugestao de nome de arquivo para gerar em disco
		cPerg, ; // Parametros
		@titulo, ; // Titulo do relatorio
		cDesc1, ; // Descricao 1
		cDesc2, ; // Descricao 2
		cDesc3, ; // Descricao 3
		.F., ; // .T. = usa dicionario
		aOrd, ; // Array de ordenacoes para o usuario selecionar
		.T., ; // .T. = comprimido
		tamanho, ; // P/M/G
		NIL, ; // ? (desconhecido)
		.F., ; // .T. = usa filtro
		NIL, ; // lCrystal
		NIL, ; // Nome driver. Ex.: "EPSON.DRV"
		.T., ; // .T. = NAO mostra interface para usuario
		.T., ; // lServer
		NIL)    // cPortToPrint (como usar?)
		*/
	Elseif !Empty(_cdPedido) .Or. !Empty(_cdOrcamento)
		//   wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,,.F.,"M"    ,,.T.)
		wnrel := SetPrint(cString,wnrel,     ,Titulo,cDesc1,cDesc2,cDesc3,.T.,,,"P")
		mv_par01 := iIf( Empty(_cdOrcamento) ,'      ',_cdOrcamento)
		mv_par02 := iIf( Empty(_cdOrcamento) ,'zzzzzz',_cdOrcamento)
		mv_par03 := iIf( Empty(_cdPedido)    ,'      ',_cdPedido)
		mv_par04 := iIf( Empty(_cdPedido)    ,'zzzzzz',_cdPedido)
	else
		wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,,,"P")
		_cdFilO := mv_par05
		_cdFil  := mv_par06
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


Return

//************************************************************************************

Static Function RunReport(lSetPrint)

	Local nCont   := 1
	Local nMaxLin := 32
	Local aRelImp    := MaFisRelImp("MT100",{"SF2","SD2"})
	Local aFisGet    := Nil
	Local aFisGetSC5 := Nil

	FisGetInit(@aFisGet,@aFisGetSC5)

	Private nwTam := 132
	Private cTable:= ""
	Private _ndTotIcms := 0
	Private _ndTotDesc := 0
	Li := 001

	aRet := fTabTmp()
	cTable := aRet[02]
	if !aRet[01]
		While (cTable)->(!EOF())

			SL1->(DbSetOrder(1))
			SC5->(DbSetOrder(1))

			SL1->(DbSeek((cTable)->(L2_FILIAL + L2_NUM) )  )
			SC5->(dbSeek((cTable)->(L1_FILIAL + L1_PEDRES) ))

			lExec := .F.
			If ExistBlock('AAFATP07')
				lExec := u_AAFATP07(SC5->C5_FILIAL,SC5->C5_NUM)
			EndIf
			If lExec
				(cTable)->(dbSkip())
				Loop
			EndIf

			aItemPed := {}

			MaFisIni(SC5->C5_CLIENTE    ,;							// 1-Codigo Cliente/Fornecedor
			SC5->C5_LOJACLI    ,;			// 2-Loja do Cliente/Fornecedor
			IIf(SC5->C5_TIPO$'DB',"F","C"),;	// 3-C:Cliente , F:Fornecedor
			SC5->C5_TIPO,;				// 4-Tipo da NF
			SC5->C5_TIPOCLI,;			// 5-Tipo do Cliente/Fornecedor
			aRelImp,;							// 6-Relacao de Impostos que suportados no arquivo
			,;						   			// 7-Tipo de complemento
			,;									// 8-Permite Incluir Impostos no Rodape .T./.F.
			"SB1",;							// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
			"MATA461")							// 10-Nome da rotina que esta utilizando a funcao

			dbSelectArea('SC5')
			For nY := 1 to Len(aFisGetSC5)
				If !Empty(&(aFisGetSC5[ny][2]))
					If aFisGetSC5[ny][1] == "NF_SUFRAMA"
						MaFisAlt(aFisGetSC5[ny][1],Iif(&(aFisGetSC5[ny][2]) == "1",.T.,.F.),Len(aItemPed),.T.)
					Else
						MaFisAlt(aFisGetSC5[ny][1],&(aFisGetSC5[ny][2]),Len(aItemPed),.T.)
					Endif
				EndIf
			Next nY

			nPag       := 1
			Cabec1(.F.) //Imprime o cabecalho do pedido
			Cabec2(.F.) //Cabecalho de Venda

			TotPagina  := 0
			DescPagina := 0

			nTotal1    := 0
			nTotal2    := 0
			nTotal3    := 0
			nTotal4    := 0
			nTotal5    := (SC6->C6_QTDVEN * SC6->C6_PRCVEN)

			TotGeral   := 0
			DescTotal  := 0

			//aProd := aClone(u_AAGETFIS(.T.))

			//tudo que esta na SC9, que nao esta bloqueado

			SC9->(dbSetOrder(1))
			cChave := (cTable)->(L2_FILIAL + L2_NUM + L1_PEDRES)

			While (cTable)->(!Eof()) .And. cChave == (cTable)->(L2_FILIAL + L2_NUM + L1_PEDRES)

				DbSelectArea("SB1")
				SB1->(DbSetOrder(1))

				If SB1->(DbSeek(xFilial("SB1")+(cTable)->L2_PRODUTO))

					SC6->(dbSetOrder(1))
					_ldSC6 := SC6->(dbSeek(xFilial('SC6') +SC5->C5_NUM + (cTable)->C6_ITEM + SB1->B1_COD ))

					_ndQtdLib1 := (cTable)->C9_QTDLIB
					_ndQtdLib2 := (cTable)->C9_QTDLIB2
					_cdDescr := SB1->B1_ESPECIF

					nPrcUnit := (cTable)->L2_VRUNIT //If( SC6->C6_DESCONT == 0 , SC6->C6_PRCVEN, SC6->C6_PRUNIT)
					nTotal := nPrcUnit * _ndQtdLib1

					nAcresFin := A410Arred( nPrcUnit * SC5->C5_ACRSFIN/100,"D2_PRCVEN")
					nTotal    += A410Arred( _ndQtdLib1 *nAcresFin,"D2_TOTAL")
					nDesconto := A410Arred(nPrcUnit*_ndQtdLib1,"D2_DESCON")-nTotal

					MaFisAdd( SB1->B1_COD        ,; 	  // 1-Codigo do Produto ( Obrigatorio )
					SC6->C6_TES ,;		  // 2-Codigo do TES ( Opcional )
					_ndQtdLib1          ,;		  // 3-Quantidade ( Obrigatorio )
					nPrcUnit              ,;		  // 4-Preco Unitario ( Obrigatorio )
					nDesconto           ,;       // 5-Valor do Desconto ( Opcional )
					""                  ,;		                  // 6-Numero da NF Original ( Devolucao/Benef )
					""                  ,;		                  // 7-Serie da NF Original ( Devolucao/Benef )
					0                   ,;			          // 8-RecNo da NF Original no arq SD1/SD2
					0                   ,;							  // 9-Valor do Frete do Item ( Opcional )
					0                   ,;							  // 10-Valor da Despesa do item ( Opcional )
					0                   ,;            				  // 11-Valor do Seguro do item ( Opcional )
					0                   ,;							  // 12-Valor do Frete Autonomo ( Opcional )
					nTotal              ,;// 13-Valor da Mercadoria ( Obrigatorio )
					0,;							  // 14-Valor da Embalagem ( Opiconal )
					0,;		     				  // 15-RecNo do SB1
					0) 							  // 16-RecNo do SF4
					aadd(aItemPed,	SC6->C6_PRODUTO )

					if _ldSC6
						dbSelectArea('SC6')
						For nY := 1 to Len(aFisGet)
							If !Empty(&(aFisGet[ny][2]))
								MaFisAlt(aFisGet[ny][1],&(aFisGet[ny][2]),Len(aItemPed))
							EndIf
						Next nY
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Calculo do ISS                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SF4->(dbSetOrder(1))
					SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))
					If ( SC5->C5_INCISS == "N" .And. SC5->C5_TIPO == "N")
						If ( SF4->F4_ISS=="S" )
							nTotal    := a410Arred(nTotal/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
							//nValMerc  := a410Arred(nValMerc/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
							MaFisAlt("IT_PRCUNI" ,nTotal,Len(aItemPed))
							MaFisAlt("IT_VALMERC",nTotal,Len(aItemPed))
						EndIf
					EndIf

					MaFisAlt("IT_PESO"   ,_ndQtdLib1*SB1->B1_PESO,Len(aItemPed))
					MaFisAlt("IT_PRCUNI" ,nPrcUnit,Len(aItemPed))
					MaFisAlt("IT_VALMERC",nTotal,Len(aItemPed))

					//nTotal := nPrcUnit * _ndQtdLib1

					@ li,002  PSay SubStr(SB1->B1_COD,1,15)
					//@ li,012  Psay SubStr(SB1->B1_ESPECIF,1,50)
					@ li,012  Psay SubStr(_cdDescr,1,50)

					@ li,076  Psay (cTable)->L2_UM
					@ li,079  PSay Transform(_ndQtdLib1,"@E   999,999.99")

					@ li,093  Psay SB1->B1_SEGUM
					@ li,096  PSay Transform(_ndQtdLib2,"@E   999,999.99")

					@ li,105  PSay Transform(nPrcUnit      ,PesqPict("SL2","L2_VRUNIT",18,2))
					@ li,118  PSay Transform(nTotal        ,PesqPict("SL2","L2_VLRITEM",18,2))

					//			   @ li,132 - 12 PSay "Pedido"

					li := li + 1
					_cdDescr := SubStr(_cdDescr,51,50)
					While !EMpty(_cdDescr)
						@ li,012  Psay SubStr(_cdDescr,1,50)
						li := li + 1
						_cdDescr := SubStr(_cdDescr,51,50)
					EndDo
					nTotal1  += SB1->B1_PESO * _ndQtdLib1 //_ndQtdLib1 //SC6->C6_QTDLIB
					nTotal2  += _ndQtdLib2//SC6->C6_QTDLIB2
					nTotal3  += nPrcUnit
					nTotal4  += nTotal
					nTotal5  += (SC6->C6_QTDVEN * SC6->C6_PRCVEN)
					
					_nX := 0
					/*
					For nI := 1 to Len(aProd)
					If Alltrim(SB1->B1_COD) == Alltrim(aProd[nI])
					_nX := nI
					EndIf
					Next
					*/
					If _nX > 0
						_ndTotIcms += MaFisRet(_nX,"IT_VALSOL")
						//alert( aProd[_nX] + str( MaFisRet(_nX,"IT_VALSOL") ) )
						//alert( _ndTotIcms)
					EndIf
				Endif

				(cTable)->(DbSkip())
			EndDo

			MaFisAlt("NF_FRETE"   ,SC5->C5_FRETE)
			MaFisAlt("NF_SEGURO"  ,SC5->C5_SEGURO)
			MaFisAlt("NF_AUTONOMO",SC5->C5_FRETAUT)
			MaFisAlt("NF_DESPESA" ,SC5->C5_DESPESA)

			If SC5->C5_DESCONT > 0
				MaFisAlt("NF_DESCONTO",Min(MaFisRet(,"NF_VALMERC")-0.01,SC5->C5_DESCONT+MaFisRet(,"NF_DESCONTO")))
			EndIf

			If SC5->C5_PDESCAB > 0
				MaFisAlt("NF_DESCONTO",A410Arred(MaFisRet(,"NF_VALMERC")*SC5->C5_PDESCAB/100,"C6_VALOR")+MaFisRet(,"NF_DESCONTO"))
			EndIf
			_ndTotIcms := MaFisRet(,"NF_VALSOL")
			MaFisEnd()
			Geral()
			RodapeForm()
			nLiBack := li
			nPag := (int(nLiBack / nMaxLin) + 1)
			If !(cTable)->(EOF())
				while(li <= nMaxLin * nPag  + (nPag - 1)*1/* nCont*/ )
					@ li,108 PSay ""
					li++
				EndDo
				nCont++
			EndIf

		End
	Else
		While !(cTable)->(EOF())
			SL1->(DbSetOrder(1))
			SC5->(DbSetOrder(1))

			SL1->(DbSeek((cTable)->(L2_FILIAL + L2_NUM) )  )
			SC5->(dbSeek((cTable)->(L1_FILIAL + L1_PEDRES) ))

			MaFisIni(SC5->C5_CLIENTE   ,;							// 1-Codigo Cliente/Fornecedor
			SC5->C5_LOJACLI,;			// 2-Loja do Cliente/Fornecedor
			IIf(SC5->C5_TIPO$'DB',"F","C"),;	// 3-C:Cliente , F:Fornecedor
			SC5->C5_TIPO,;				// 4-Tipo da NF
			SC5->C5_TIPOCLI,;			// 5-Tipo do Cliente/Fornecedor
			aRelImp,;							// 6-Relacao de Impostos que suportados no arquivo
			,;						   			// 7-Tipo de complemento
			,;									// 8-Permite Incluir Impostos no Rodape .T./.F.
			"SB1",;							// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
			"MATA461")							// 10-Nome da rotina que esta utilizando a funcao

			nPag       := 1
			Cabec1(.T.) //Imprime o cabecalho do pedido
			Cabec2(.T.) //Cabecalho de Venda
			TotPagina  := 0
			DescPagina := 0

			nTotal1    := 0
			nTotal2    := 0
			nTotal3    := 0
			nTotal4    := 0
			nTotal5    := (SC6->C6_QTDVEN * SC6->C6_PRCVEN)

			TotGeral   := 0
			DescTotal  := 0

			//tudo que esta na SC9, que nao esta bloqueado
			//aProd := aClone(u_AAGETFIS(.T.))

			SC9->(dbSetOrder(1))
			cChave := (cTable)->(L2_FILIAL + L2_NUM + L1_PEDRES)

			While (cTable)->(!Eof()) .And. cChave == (cTable)->(L2_FILIAL + L2_NUM + L1_PEDRES)

				DbSelectArea("SB1")
				SB1->(DbSetOrder(1))

				If SB1->(DbSeek(xFilial("SB1")+(cTable)->L2_PRODUTO))
					_ndQtdLib1 := (cTable)->C9_QTDLIB
					_ndQtdLib2 := (cTable)->C9_QTDLIB2

					nPrcUnit := (cTable)->L2_VLRITEM / _ndQtdLib1
					nTotal   := (cTable)->L2_VLRITEM
					_ndQtSeg := convUm(SB1->B1_COD, _ndQtdLib1,0,2)

					nPrcUnit := (cTable)->L2_VRUNIT //If( SC6->C6_DESCONT == 0 , SC6->C6_PRCVEN, SC6->C6_PRUNIT)
					nTotal := nPrcUnit * _ndQtdLib1

					nAcresFin := A410Arred( nPrcUnit * SC5->C5_ACRSFIN/100,"D2_PRCVEN")
					nTotal    += A410Arred( _ndQtdLib1 *nAcresFin,"D2_TOTAL")
					nDesconto := A410Arred(nPrcLista*_ndQtdLib1,"D2_DESCON")-nTotal

					MaFisAdd( SB1->B1_COD        ,; 	  // 1-Codigo do Produto ( Obrigatorio )
					SC6->C6_TES ,;		  // 2-Codigo do TES ( Opcional )
					_ndQtdLib1          ,;		  // 3-Quantidade ( Obrigatorio )
					nPrcUnit              ,;		  // 4-Preco Unitario ( Obrigatorio )
					nDesconto           ,;       // 5-Valor do Desconto ( Opcional )
					""                  ,;		                  // 6-Numero da NF Original ( Devolucao/Benef )
					""                  ,;		                  // 7-Serie da NF Original ( Devolucao/Benef )
					0                   ,;			          // 8-RecNo da NF Original no arq SD1/SD2
					0                   ,;							  // 9-Valor do Frete do Item ( Opcional )
					0                   ,;							  // 10-Valor da Despesa do item ( Opcional )
					0                   ,;            				  // 11-Valor do Seguro do item ( Opcional )
					0                   ,;							  // 12-Valor do Frete Autonomo ( Opcional )
					nTotal              ,;// 13-Valor da Mercadoria ( Obrigatorio )
					0,;							  // 14-Valor da Embalagem ( Opiconal )
					0,;		     				  // 15-RecNo do SB1
					0) 							  // 16-RecNo do SF4
					aadd(aItemPed,	SC6->C6_PRODUTO )

					if _ldSC6
						dbSelectArea('SC6')
						For nY := 1 to Len(aFisGet)
							If !Empty(&(aFisGet[ny][2]))
								MaFisAlt(aFisGet[ny][1],&(aFisGet[ny][2]),Len(aItemPed))
							EndIf
						Next nY
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Calculo do ISS                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SF4->(dbSetOrder(1))
					SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))
					If ( SC5->C5_INCISS == "N" .And. SC5->C5_TIPO == "N")
						If ( SF4->F4_ISS=="S" )
							nTotal    := a410Arred(nTotal/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
							//nValMerc  := a410Arred(nValMerc/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
							MaFisAlt("IT_PRCUNI" ,nTotal,Len(aItemPed))
							MaFisAlt("IT_VALMERC",nTotal,Len(aItemPed))
						EndIf
					EndIf

					MaFisAlt("IT_PESO"   ,_ndQtdLib1*SB1->B1_PESO,Len(aItemPed))
					MaFisAlt("IT_PRCUNI" ,nPrcUnit,Len(aItemPed))
					MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))

					@ li,02  PSay SubStr(SB1->B1_COD,1,10)
					@ li,13  Psay SubStr(SB1->B1_ESPECIF,1,50)

					@ li,74 - 11  Psay (cTable)->L2_UM
					@ li,79 - 13  PSay Transform( _ndQtdLib1,"@E   999,999.99")

					@ li,091 - 11 Psay SB1->B1_SEGUM
					@ li,096 - 13 PSay Transform(_ndQtdLib2 ,"@E   999,999.99")

					@ li,108 - 15 PSay Transform(nPrcUnit      ,"@E   999,999.99")
					@ li,120 - 18 PSay Transform(nTotal        ,"@E 9,999,999.99")
					cCred := iIf((cTable)->C9_BLCRED = "*","*",iIF( !Empty( (cTable)->C9_BLCRED),"CRED",""))
					cEst  := iIf((cTable)->C9_BLEST = "*","*",iIF( !Empty( (cTable)->C9_BLEST),"EST","") )
					@ li,132 - 12 PSay  cCred + iIf( !Empty(cCred) .And. !Empty(cEst)  .And. (cCred != '*') ,"/","") + cEst

					li := li + 1

					nTotal1  += SB1->B1_PESO * _ndQtdLib1//_ndQtdLib1 //SC6->C6_QTDLIB
					nTotal2  += _ndQtdLib2//SC6->C6_QTDLIB2
					nTotal3  += (cTable)->L2_VLRITEM
					nTotal4  += nTotal
					nTotal5  += (SC6->C6_QTDVEN * SC6->C6_PRCVEN)

					_ndTotDesc += SC6->C6_VALDESC
					_nX := 0
					/*
					For nI := 1 to Len(aProd)
					If Alltrim(SB1->B1_COD) == Alltrim(aProd[nI])
					_nX := nI
					EndIf
					Next
					*/
					If _nX > 0
						_ndTotIcms += MaFisRet(_nX,"IT_VALSOL")
					EndIf
				EndIf
				(cTable)->(dbSkip())
			EndDo

			MaFisAlt("NF_FRETE"   ,SC5->C5_FRETE)
			MaFisAlt("NF_SEGURO"  ,SC5->C5_SEGURO)
			MaFisAlt("NF_AUTONOMO",SC5->C5_FRETAUT)
			MaFisAlt("NF_DESPESA" ,SC5->C5_DESPESA)

			If SC5->C5_DESCONT > 0
				MaFisAlt("NF_DESCONTO",Min(MaFisRet(,"NF_VALMERC")-0.01,SC5->C5_DESCONT+MaFisRet(,"NF_DESCONTO")))
			EndIf

			If SC5->C5_PDESCAB > 0
				MaFisAlt("NF_DESCONTO",A410Arred(MaFisRet(,"NF_VALMERC")*SC5->C5_PDESCAB/100,"C6_VALOR")+MaFisRet(,"NF_DESCONTO"))
			EndIf
			_ndTotIcms := MaFisRet(,"NF_VALSOL")
			MaFisEnd()
			/*
			For nI := 1 to Len(aProd)
			MaFisDel(nI,.T.)
			Next
			MaFisWrite(1)

			MaFisEnd()
			*/

			nLiBack := li
			nPag := (int(nLiBack / nMaxLin) + 1)
			If !(cTable)->(EOF())
				while(li <= nMaxLin * nPag  + (nPag - 1)*1 )
					@ li,108 PSay ""
					li++
				EndDo
				nCont++
			EndIf
		EndDo

	EndIf

	(cTable)->(dbCloseArea())

	Return
	***************************************************************************************
Static Function Cabec1(lBlock)

	// li:=01
	Default lBlock := .F.

	@ li,000 PSay Chr(15)+" "
	@ li,001 PSay Replicate("-",nwTam)
	li++
	@ li,001 PSay p_negrit_l + PADC(ALLTRIM(SM0->M0_NOMECOM),nwTam); li := li + 1
	If lBlock
		@ li,001 PSay p_negrit_l + PADC("ITENS BLOQUEADOS DO PEDIDO " + SC5->C5_FILIAL + "/" + SC5->C5_NUM + "       Data Emissao :" +DTOC(SC5->C5_EMISSAO)+" - "+Time(),nwTam)
	else
		@ li,001 PSay p_negrit_l + PADC("COMPROVANTE DE ENTREGA DO PEDIDO " + SC5->C5_FILIAL + "/" + SC5->C5_NUM + "       Data Emissao :" +DTOC(SC5->C5_EMISSAO)+" - "+Time(),nwTam)
	EndIf
	li := li + 1
	@ li,001 PSay p_negrit_d + Replicate("-",nwTam)
	li := li + 1
	Return
	***************************************************************************************

Static Function Cabec2(lBlock)

	If SC5->C5_TIPO $ "N,C,P,I"

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
		@ li,072 PSay "Codigo   : "+AllTrim(SA1->A1_COD) + Space(1) + SA1->A1_LOJA; li := li + 1

		@ li,001 PSay "Endereco : "+Alltrim(Left(SA1->A1_END,50))
		@ li,072 PSay "Bairro   : "+AllTrim(SA1->A1_BAIRRO); li := li + 1

		@ li,001 PSay "End. Ent.: "+Alltrim(Left(SC5->C5_ENDENT,50))
		@ li,072 PSay "Bairro Ent.: "+AllTrim(SC5->C5_BAIRROE); li := li + 1

		@ li,001 PSAY AllTrim ( "Munic./UF: "+ If( Empty(SC5->C5_MUNE), AllTrim(SA1->A1_MUN), SC5->C5_MUNE)  + " - " +If( Empty(SC5->C5_ESTE), AllTrim(SA1->A1_EST), SC5->C5_ESTE)  )
		@ li,044 PSAY AllTrim("Receptor: " + AllTrim(SC5->C5_RECENT) )
		li := li + 1
		@ li,001 PSAY "I.E. : " + SA1->A1_INSCR
		li := li + 1
		@ li,001 PSAY AllTrim("Referência: " + AllTrim(SC5->C5_REFEREN) ) //; li := li + 1

		li++

		@ li,001 PSay AllTrim("Telefone : "+If ( EmPty(SC5->C5_FONEENT), AllTrim(SA1->A1_TEL), AllTrim(SC5->C5_FONEENT) ) )
		@ li,033 PSay AllTrim("Fax : "+SA1->A1_FAX )
		@ li,072 Psay AllTrim("CNPF/CPF : "+AllTrim(SA1->A1_CGC))
		@ li,099 Psay AllTrim("Entrega: " + If( SC5->C5_ENTREGA == "S", "SIM", "NÃO" ))

		li:=li+1

		@ li,001 PSay "C. Pagto :  " + If(ALLTRIM(SC5->C5_CONDPAG) == "CN","COND. NEGOCIADA",SC5->C5_CONDPAG + " - " + AllTrim(SE4->E4_DESCRI))
		@ li,066 PSay "Vendedor: "+AllTrim(SA3->A3_COD)+" - "+AllTrim(SA3->A3_NREDUZ)
		@ li,099 PSAY "Receb. Local:" + If( SC5->C5_RECLOC == "S", "SIM", "NÃO" )

		li := li + 1

		@ li,001 PSay "Observacoes:"
		@ li,015 PSay SC5->C5_OBSENT1 ; li++
		@ li,015 PSay SC5->C5_OBSENT2 ; li++

	Else

		SA2->(DbSetOrder(1))
		SA2->(DbSeek(XFILIAL()+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		SE4->(DbSetOrder(1))
		SE4->(DbSeek(XFILIAL()+SC5->C5_CONDPAG))
		SA3->(DbSetOrder(1))
		SA3->(DbSeek(XFILIAL()+SC5->C5_VEND1))

		cFormPag := SL1->L1_FORMPG
		cDescPag := Posicione("SX5",1,XFILIAL("SX5")+"24"+cFormPag,"X5_DESCRI")

		//  li := 08

		@ li,001 PSay "Cliente  : "+AllTrim(SA2->A2_NOME) + "  ( " + AllTrim(SA2->A2_NREDUZ) + " )"
		@ li,072 PSay "Codigo   : "+AllTrim(SA2->A2_COD) + Space(1) + SA2->A2_LOJA; li := li + 1

		@ li,001 PSay "Endereco : "+Alltrim(Left(SA2->A2_END,50))
		@ li,072 PSay "Bairro   : "+AllTrim(SA2->A2_BAIRRO); li := li + 1

		@ li,001 PSay "End. Ent.: "+Alltrim(Left(SC5->C5_ENDENT,50))
		@ li,072 PSay "Bairro Ent.: "+AllTrim(SC5->C5_BAIRROE); li := li + 1

		@ li,001 PSAY AllTrim ( "Munic./UF: "+ If( Empty(SC5->C5_MUNE), AllTrim(SA2->A2_MUN), SC5->C5_MUNE)  + " - " +If( Empty(SC5->C5_ESTE), AllTrim(SA2->A2_EST), SC5->C5_ESTE)  )
		@ li,044 PSAY AllTrim("Receptor: " + AllTrim(SC5->C5_RECENT) )
		li := li + 1
		@ li,001 PSAY "I.E. : " + SA2->A2_INSCR
		li := li + 1
		@ li,001 PSAY AllTrim("Referência: " + AllTrim(SC5->C5_REFEREN) ) //; li := li + 1

		li++

		@ li,001 PSay AllTrim("Telefone : "+If ( EmPty(SC5->C5_FONEENT), AllTrim(SA2->A2_TEL), AllTrim(SC5->C5_FONEENT) ) )
		@ li,033 PSay AllTrim("Fax : "+SA2->A2_FAX )
		@ li,072 Psay AllTrim("CNPF/CPF : "+AllTrim(SA2->A2_CGC))
		@ li,099 Psay AllTrim("Entrega: " + If( SC5->C5_ENTREGA == "S", "SIM", "NÃO" ))

		li:=li+1

	End If

	aPagtos := GetForm(SL1->L1_FILIAL,SL1->L1_NUM)

	/*
	if Len(aPagtos) > 0
	aeval(apagtos,{|x| alert(x) })
	EndIf
	*/

	For nK := 1 To Len(aPagtos)
		@ li,001 PSay iIf(nK==1,"C. Pagto :  ","            ") + aPagtos[nK]
		//li++
	Next

	IF Len(aPagtos) == 0
		@ li,001 PSay "C. Pagto :  " + SC5->C5_CONDPAG + Posicione("SE4",1,xFilial("SE4") + SC5->C5_CONDPAG,'E4_DESCRI')
	EndIf

	@ li,044 PSay "Vendedor: "+AllTrim(SA3->A3_COD)+" - "+AllTrim(SA3->A3_NREDUZ)
	@ li,099 PSAY "Receb. Local:" + If( SC5->C5_RECLOC == "S", "SIM", "NAO" )

	li := li + 1

	@ li,001 PSay "Orcamento : "  + SL1->L1_NUM
	li++
	@ li,001 PSay "Observacoes: "
	@ li,015 PSay iIf(Empty(SC5->C5_OBSENT1),(cTable)->L1_OBSENT1,SC5->C5_OBSENT1) ; li++
	@ li,015 PSay iIf(Empty(SC5->C5_OBSENT2),(cTable)->L1_OBSENT2,SC5->C5_OBSENT2) ; li++

	//Impressão dos Itens
	@ li,01 PSay Replicate("-",nwTam); li := li + 1
	//@ li,01 PSay "  PRODUTO           DESCRICAO                                            1.UM  QTD 1.UM   2.UM   QTD 2.UM    PRC UNI   TOTAL "

	If lBlock
		@ li,02  PSay "PRODUTO"
		@ li,12  Psay "DESCRICAO"

		@ li,74 - 15  Psay "1.UM "
		@ li,79 - 08  PSay "QTD 1.UM"

		@ li,091 - 12 Psay "2.UM"
		@ li,096 - 11 PSay "QTD 2.UM"

		@ li,108 - 12 PSay "PRC UNI"
		@ li,120 - 12 PSay "TOTAL"

		@ li,132 - 12 PSay "BLOQUEIO"
	else
		@ li,02  PSay "PRODUTO"
		@ li,12  Psay "DESCRICAO"

		@ li,76  Psay "1.UM "
		@ li,79  PSay "QTD 1.UM"

		@ li,091 Psay "2.UM"
		@ li,096 PSay "QTD 2.UM"

		@ li,108 PSay "PRC UNI"
		@ li,120 PSay "TOTAL"

	EndIf

	//   @ li,132 - 12 PSay "Pedido"

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
	li := li + 4
	//   @ li,01 PSay Chr(18)

	@ li,01 Psay Replicate("-",30); li := li +1
	@ li,10 PSay "Resp. Liberação"


Return

Static Function Geral()
	Local cQry

	li++
	@ li,01 PSay Replicate("-",nwTam) ; li := li + 1

	@ li,01 PSay "Peso Total       : "+AllTrim(Transform(nTotal1,"@E 999,999.99"))
	// 	@ li,33 PSay "Total Quant 2. UM: "+AllTrim(Transform(nTotal2,"@E 999,999.99"))s
	@ li,50 PSay "Total Valor Unit : "+AllTrim(Transform(nTotal3,"@E 999,999.99"))

	//ALERT(MaFisRet(, "NF_VALSOL"))

	@ li,78 PSay "ICMS Retido : " +  AllTrim(Transform(_ndTotIcms,"@E 999,999.99"))
	//@ li,99 PSay "Total Pedido : "	 +AllTrim(Transform(nTotal4 + _ndTotIcms,"@E 999,999.99"))
	@ li,99 PSay "Total Pedido : "	 +AllTrim(Transform(nTotal5,"@E 999,999.99"))



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
	Local aTam := {}
	aAdd(aTam,{TamSx3("L1_NUM")[01],TamSx3("L1_NUM")[02]})
	aAdd(aTam,{TamSx3("C5_NUM")[01],TamSx3("C5_NUM")[02]})

	PutSX1(cPerg,"01","Orcamento de?" ,"","","mv_ch1","C",aTam[01][01],aTam[01][02],0,"G","","SC5","","","mv_par01")
	PutSX1(cPerg,"02","Orcamento Ate?","","","mv_ch2","C",aTam[01][01],aTam[01][02],0,"G","","SC5","","","mv_par02")
	PutSX1(cPerg,"03","Pedido de ?"   ,"","","mv_ch3","C",aTam[02][01],aTam[02][02],0,"G","","SC5","","","mv_par03")
	PutSX1(cPerg,"04","Pedido até?"   ,"","","mv_ch4","C",aTam[02][01],aTam[02][02],0,"G","","SC5","","","mv_par04")
	PutSX1(cPerg,"05","Filial Orc?"   ,"","","mv_ch5","C",02,0,0,"G","","   ","","","mv_par05")
	PutSX1(cPerg,"06","Filial Ped?"   ,"","","mv_ch6","C",02,0,0,"G","","   ","","","mv_par06")

	//PutSX1(cPerg,"03","Pedido ?","",""   ,"mv_ch3","N",01,0,0,"C","","   ","","","mv_par03","Faturado","","","","Nao Faturado","","","Ambos","")

	Return Nil

	*----------------------------------------------------------------------------------------------*
Static Function fTabTmp()
	*----------------------------------------------------------------------------------------------*
	// Função que soma a quantidade de produtos com Orcamentos em abertos e NAO vencidos

	Local cTable := GetNextAlias()
	Local cArea  := GetArea()
	Local cQry   := ""
	Local lBlock := .F.


	cQry += " select L1.L1_PEDRES,C6_ITEM,C6_QTDVEN,L1.*,L2.*,BM_XEXIGOS, C9_BLOQUEI ,
	cQry += "       isNull(C9_QTDLIB,0)C9_QTDLIB ,IsnUll(C9_QTDLIB2,0) C9_QTDLIB2,
	cQry += "       IsNull(C9_BLCRED,'*') C9_BLCRED,isNull(C9_BLEST,'*') C9_BLEST
	cQry += " from " + RetSqlName("SL2") + "  L2
	cQry += "     Left Outer Join " + RetSqlName("SL1") + " (NOLOCK) L1  on L1_ORCRES = L2_NUM and L1_FILRES = L2_FILIAL
	cQry += "     Left Outer Join " + RetSqlName("SL2") + " (NOLOCK) L2B on L2B.L2_NUM = L1.L1_NUM and L1.L1_FILIAL = L2B.L2_FILIAL and L2B.L2_PRODUTO = L2.L2_PRODUTO And L2B.L2_QUANT = L2.L2_QUANT "
	cQry += "     Left Outer Join " + RetSqlName("SB1") + " (NOLOCK) SB1 on SB1.D_E_L_E_T_='' AND SB1.B1_COD = L2B.L2_PRODUTO
	cQry += "     Left Outer Join " + RetSqlName("SBM") + " (NOLOCK) SBM on SBM.D_E_L_E_T_='' AND SBM.BM_GRUPO = SB1.B1_GRUPO
	cQry += "     Left Outer Join " + RetSqlName("SC6") + " (NOLOCK) C6  on  C6.D_E_L_E_T_='' AND C6.C6_PRODUTO = L2.L2_PRODUTO AND C6.C6_NUM = L1.L1_PEDRES and C6.C6_QTDVEN = L2.L2_QUANT "
	cQry += "     Left Outer Join " + RetSqlName("SC9") + " (NOLOCK) C9  on  C9.D_E_L_E_T_='' AND C9.C9_NUMSEQ = '' AND C9.C9_PRODUTO = C6.C6_PRODUTO And C6.C6_NUM = C9.C9_PEDIDO And C6.C6_ITEM = C9.C9_ITEM
	cQry += "  Where L2.D_E_L_E_T_ = '' and L1.D_E_L_E_T_ = '' And L2B.D_E_L_E_T_ = ''

	If Empty(mv_par01) .And. Empty(mv_par02)
	else
		cQry += "       And L2.L2_NUM BetWeen '" + mv_par01 + "' And '" + mv_par02 + "'
	Endif
	If Empty(mv_par03) .And. Empty(mv_par04)
	else
		cQry += "       And L1.L1_PEDRES BetWeen '" + mv_par03 + "' And '" + mv_par04 + "'
	EndIf
	If !empty(_cdFil)
		cQry += " And L1.L1_FILIAL = '" + _cdFil + "' "
	EndIf
	If !empty(_cdFilO)
		cQry += " And L2.L2_FILIAL = '" + _cdFilO + "' "
	EndIf
	//  cQry += "       And L2.L2_FILIAL  = '" + SL2->(xFilial()) + "'
	cQry += "       And (C9.C9_PEDIDO is Not null
	cQry += "         And (C9.C9_BLCRED  != ''
	cQry += "         Or  C9.C9_BLEST   != ''
	cQry += "         Or  C9.C9_BLOQUEI != '') )
	cQry += "    ORDER BY L1.L1_FILIAL,L1.L1_PEDRES,L2.L2_NUM,L2_PRODUTO

	MEMOWRIT('AAFATR04.SQL',cQry)

	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), cTable , .T., .F. )

	If !(cTable)->(EOF()) .And. _lBlock
		lBlock := _lBlock
	else
		(cTable)->(dbCLoseARea(cTable))

		If _lBlock
			cQry := StrTran(cQry,"!=","=")
			cQry := StrTran(cQry,"And (C9.C9_BLCRED  != ''","Or (C9.C9_BLCRED  != ''")
			cQry := StrTran(cQry,"Or  C9.C9_BLEST   != ''","And C9.C9_BLEST   != ''")
			cQry := StrTran(cQry,"Or  C9.C9_BLOQUEI != ''","And C9.C9_BLOQUEI != ''")
		Else
			cQry := StrTran(cQry,"And (C9.C9_BLCRED  != ''","")
			cQry := StrTran(cQry,"Or  C9.C9_BLEST   != ''" ,"")
			cQry := StrTran(cQry,"Or  C9.C9_BLOQUEI != '')" ,"")
		EndIF

		//qlqr erro de impressao com informacoes erradas descomentar as linhas abaixo 

		//cQry := StrTran(cQry,"is null","is Not Null")
		//cQry := StrTran(cQry,"Or","And")

		MEMOWRIT('AAFATR04.SQL',cQry)

		dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), cTable , .T., .F. )
		If (cTable)->(EOF())
			(cTable)->(dbCLoseARea(cTable))
			cQry := ""
			cQry += "  select C5_FILIAL L1_FILIAL,C5_NUM L1_PEDRES,'' L2_FILIAL ,C6_ITEM,'' L2_NUM,
			cQry += "       C6_PRODUTO L2_PRODUTO,C6_UM L2_UM,C6_PRCVEN L2_VRUNIT,C6_VALOR L2_VLRITEM,'' L1_OBSENT1,'' L1_OBSENT2,
			cQry += "       isNull(C9_QTDLIB,0)C9_QTDLIB ,IsnUll(C9_QTDLIB2,0) C9_QTDLIB2,C6_QTDVEN,BM_XEXIGOS,
			cQry += "       IsNull(C9_BLCRED,'*') C9_BLCRED,isNull(C9_BLEST,'*') C9_BLEST,C9_BLOQUEI  from " + RetSqlName("SC5") + " C5
			cQry += "    Left Outer Join " + RetSqlName("SC6") + " (NOLOCK)  C6 on   C6.D_E_L_E_T_=''  AND C6.C6_NUM = C5_NUM AND C6.C6_FILIAL = C5_FILIAL "
			cQry += "    Left Outer Join " + RetSqlName("SB1") + " (NOLOCK) SB1 on  SB1.D_E_L_E_T_=''  AND SB1.B1_COD = C6.C6_PRODUTO "
			cQry += "    Left Outer Join " + RetSqlName("SBM") + " (NOLOCK) SBM on  SBM.D_E_L_E_T_=''  AND SBM.BM_GRUPO = SB1.B1_GRUPO "
			cQry += "    Left Outer Join " + RetSqlName("SC9") + " (NOLOCK)  C9 on   C9.D_E_L_E_T_=''  AND C9_NUMSEQ = '' AND C9.C9_PRODUTO = C6.C6_PRODUTO And C6.C6_NUM = C9.C9_PEDIDO And C6.C6_ITEM = C9.C9_ITEM
			cQry += "    Where C5.D_E_L_E_T_ = ''
			cQry += "    And C5.C5_NUM BetWeen '" + mv_par03 + "' And '" + mv_par04 + "'
			cQry += "    And C5.C5_FILIAL = '" + _cdFil + "'
			cQry += "      And (C9.C9_PEDIDO is Not null
			cQry += "        And (C9.C9_BLCRED  != ''
			cQry += "        Or C9.C9_BLEST   != ''
			cQry += "        OR C9.C9_BLOQUEI != '') )
			cQry += "  ORDER BY C5.C5_FILIAL,C5.C5_NUM,C6_PRODUTO

			MEMOWRIT('AAFATR04.SQL',cQry)
			dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), cTable , .T., .F. )
			If !(cTable)->(EOF()) .And. _lBlock
				lBlock := _lBlock
			else
				(cTable)->(dbCLoseARea(cTable))

				If _lBlock
					cQry := StrTran(cQry,"!=","=")
					cQry := StrTran(cQry,"And (C9.C9_BLCRED  != ''","Or (C9.C9_BLCRED  != ''")
					cQry := StrTran(cQry,"Or C9.C9_BLEST   != ''","And C9.C9_BLEST   != ''")
					cQry := StrTran(cQry,"OR C9.C9_BLOQUEI != ''","And C9.C9_BLOQUEI != ''")
				Else
					cQry := StrTran(cQry,"And (C9.C9_BLCRED  != ''","")
					cQry := StrTran(cQry,"Or C9.C9_BLEST   != ''" ,"")
					cQry := StrTran(cQry,"OR C9.C9_BLOQUEI != '')" ,"")
				EndIF
				//cQry := StrTran(cQry,"is null","is Not Null")
				//cQry := StrTran(cQry,"Or","And")

				MEMOWRIT('AAFATR04.SQL',cQry)
				dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), cTable , .T., .F. )
			EndIf

		EndIf
	EndIF

Return {lBlock,cTable}


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
		_adForma := {}
	EndiF

Return _adForma

Static Function getFis()

Return Nil

Static Function FisGetInit(aFisGet,aFisGetSC5)

	Local cValid      := ""
	Local cReferencia := ""
	Local nPosIni     := 0
	Local nLen        := 0

	If aFisGet == Nil
		aFisGet	:= {}
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
	EndIf

	If aFisGetSC5 == Nil
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
	EndIf
	MaFisEnd()
Return(.T.)





/* powered by DXRCOVRB*/
