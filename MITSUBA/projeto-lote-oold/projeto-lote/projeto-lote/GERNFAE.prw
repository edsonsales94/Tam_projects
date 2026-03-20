#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ GERNFAE    ¦ Autor ¦ Totvs                ¦ Data ¦ 14/06/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Geração de nota de saída para armazém externo com base na     ¦¦¦
¦¦¦           ¦ nota principal de importação CFOP 3101                        ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function GERNFAE()
	If SF1->F1_TIPO == "N"   // Se for nota normal de entrada 
		MsgRun("Incluindo pedido de venda armazenagem Externa. Aguarde...",,{|| IncluiPedido() } )
	Endif
Return

Static Function IncluiPedido()
	Local nTotal, aCabec, nSaveSX8, aLinha
	Local cPedido   := ""
	Local cNumPv    := "" 
	Local aItem     := {}
	Local cItem     := StrZero(0,Len(SC6->C6_ITEM))

	// Processa leitura dos itens gravados na nota
	SD1->(dbSetOrder(1))
	SD1->(dbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA),.T.))
	While !SD1->(Eof()) .And. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
		
		If Alltrim(SD1->D1_CF) $ "1101|3101|2101" 
			// Posiciona no produto
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(XFILIAL("SB1")+SD1->D1_COD))
						
			nTotal := A410Arred(SD1->D1_VUNIT * SD1->D1_QUANT,"C6_VALOR")
			
			// Adiciona os dados do item do pedido
			aLinha := {}
			AAdd( aLinha, { "C6_ITEM"    , cItem:=Soma1(cItem) , Nil} )
			AAdd( aLinha, { "C6_PRODUTO" , SD1->D1_COD         , Nil} )
			AAdd( aLinha, { "C6_LOCAL"   , "19"                , Nil} )
			AAdd( aLinha, { "C6_UM"      , SD1->D1_UM          , Nil} )
			AAdd( aLinha, { "C6_TES"     , "633"               , Nil} )
			AAdd( aLinha, { "C6_CLI"     , "11663 "            , Nil} )
			AAdd( aLinha, { "C6_LOJA"    , "01"                , Nil} )
			AAdd( aLinha, { "C6_QTDVEN"  , SD1->D1_QUANT       , Nil} )
			AAdd( aLinha, { "C6_PRUNIT"  , SD1->D1_VUNIT       , Nil} )
			AAdd( aLinha, { "C6_PRCVEN"  , SD1->D1_VUNIT       , Nil} )
			AAdd( aLinha, { "C6_VALOR"   , nTotal              , Nil} )
			AAdd( aLinha, { "C6_VALDESC" , SD1->D1_VALDESC     , Nil} )
			if !empty(SD1->D1_LOTECTL)
				AAdd( aLinha, { "C6_LOTECTL" , SD1->D1_LOTECTL     , Nil} ) 
				AAdd( aLinha, { "C6_DTVALID" , SD1->D1_DTVALID     , Nil} ) 
			endif
			if SB1->B1_RASTRO  == 'S'
				AAdd( aLinha, { "C6_LOCALIZ" , 'PADRAO'       , Nil} ) 
			endif
			
			aAdd( aItem, aLinha )
		Else
		 FWAlertWarning('A CFOP definida para gerar pedido por essa rotina deve ser CFOP: 3101, ajuste a CFOP e tente novamente.', 	'erro CFOP')
			Return .F.
		EndIf
	SD1->(dbSkip())
	
	Enddo
	
	// Posiciona no pedido de venda
	SC5->(dbSetOrder(1))
	SC5->(dbSeek(XFILIAL("SC5")+cPedido))
	
	// Variavel que controla numeracao
	nSaveSX8 := GetSx8Len()
	
	// Cabecalho do pedido
	cPedido := GetSxeNum("SC5","C5_NUM")
	cNumPv  := cPedido
	RollBAckSx8()
	
	// Adiciona os dados do cabeçalho do pedido
	aCabec := {}
	AAdd( aCabec , { "C5_NUM"    , cPedido        , Nil})
	AAdd( aCabec , { "C5_TIPO"   , "B"            , Nil})
	AAdd( aCabec , { "C5_CLIENTE", "11663 "       , Nil})
	AAdd( aCabec , { "C5_LOJACLI", "01"           , Nil})
	AAdd( aCabec , { "C5_LOJAENT", "01"           , Nil})
	AAdd( aCabec , { "C5_ORCRES" , SC5->C5_ORCRES , Nil})
	AAdd( aCabec , { "C5_TPFRETE", "S"            , Nil})
	AAdd( aCabec , { "C5_DESCONT", SC5->C5_DESCONT, Nil}) 
	AAdd( aCabec , { "C5_CONDPAG" , "001"         , Nil}) 
	AAdd( aCabec , { "C5_MENNOTA" , Alltrim(SC5->C5_MENNOTA), Nil})
	
	lMsErroAuto := .F.
	lMSHelpAuto := .T.
	
	SetFunName("MATA410")   // Define como sendo a rotina MATA410
	
	// Inclusao do pedido
	MATA410(aCabec,aItem,3)
	
	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
	Else

	MsgInfo("Pedido: "+cNumPv+" referente a remessa para armazém externo foi gerado com sucesso!","Informativo")
		
		// Confirma SX8
		While ( GetSx8Len() > nSaveSX8 )
			ConfirmSX8()
		Enddo
		

		// Liberacao de pedido
		//Ma410LbNfs(2,@aPvlNfs,@aBloqueio)
		
		// Checa itens liberados
		//Ma410LbNfs(1,@aPvlNfs,@aBloqueio)


	Endif
	
	SetFunName("MATA103")   // Define como sendo a rotina MATA103
Return


