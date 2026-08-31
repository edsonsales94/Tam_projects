#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ PMLOJE02   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 29/03/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descrição ¦ Rotina de geração do pedido de tranferencia                   ¦¦¦ 
¦¦¦ Descr  ¦ Rotina de geração do pedido de tranferencia                   	  ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PMLOJE02()
	Local x, y, nX, cNumPed, aLinha, nSaveSX8, nCusto, cMenNota, nTotal
	Local cAlias  := Alias()
	Local cFilAux := cFilAnt
	Local cFilInd := "01"                  // Filial da indústria
	Local cItem   := StrZero(0,Len(SC6->C6_ITEM))
	Local aCabec  := {}
	Local aItens  := {}
	Local nDiaEnt := GetMv("MV_XDIAENT")
	Local nDecPrc := TamSX3("C6_PRCVEN")[2]
	Local nDecTot := TamSX3("C6_VALOR")[2]
	Local aRegs   := {}
	Local cTES    := ""

	// Identifica se existe a filial destino como cliente
	SA1->(dbSetOrder(1))
	If !SA1->(dbSeek(XFILIAL("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA))
		Return
	Endif     

	//cTES := IIF(!EMPTY(SA1->A1_INSCR) .AND. ALLTRIM(SA1->A1_INSCR) <> "ISENTO","518","819")

	IF(SA1->A1_EST != "AM")
		IF(ALLTRIM(SA1->A1_INSCR) == "ISENTO" .OR. EMPTY(ALLTRIM(SA1->A1_INSCR)))
			cTES:= "720"
		ELSE
			cTES:= "895"	
		ENDIf
	ELSEif (SL1->L1_XCD!='1')
		cTES:= "721"
	ELSE		
		cTES:= "724"
	ENDIF

	cTesaux:= cTes


	SB1->(dbSetOrder(1))
	SB2->(dbSetOrder(1))
	SF4->(dbSetOrder(1))
	DA1->(dbSetOrder(1))

	IF FunName() $ "FATA701,LOJA701"
		SL1->(dbSetOrder(1))
		SL1->(dbSeek(SL1->(L1_FILRES+L1_ORCRES)))
	EndIF

	// Pesquisa os itens marcados para reserva
	SL2->(dbSetOrder(1))
	SL2->(dbSeek(SL1->(L1_FILIAL+L1_NUM),.T.))

	While !SL2->(Eof()) .And. SL1->(L1_FILIAL+L1_NUM) == SL2->(L2_FILIAL+L2_NUM)
		QOUT("ENTROU WHILE")
		SF4->(dbSeek(XFILIAL("SF4")+cTES))

		If !Empty(SL2->L2_LOJARES) .And. SF4->F4_ESTOQUE == "S"
			QOUT("LOJA RESERVA !=  E F4_ESTOQUE = S")
			// Posiciona no produto
			SB1->(dbSeek(XFILIAL("SB1")+SL2->L2_PRODUTO))
			DA1->(dbSeek(Xfilial("DA1")+"012"+SL2->L2_PRODUTO))

			nCusto := 0
			// Pesquisa saldo em estoque para busca do custo médio 
			If DA1->DA1_XPROMO == "S" .AND.	 SB2->(dbSeek(cFilInd+SB1->(B1_COD+B1_LOCPAD)))
				nCusto := SB2->B2_CM1
				cTes   := "801"

			Else
				nCusto := SL2->L2_VRUNIT
			EndIf
			IF(SL1->L1_XCD == "1")
				RecLock("SL2",.F.)
				SL2->L2_TES = "724"
				SL2->L2_LOCAL = "15"
			MsUnlock()
			ENDIF


			nCusto := Round(nCusto,nDecPrc)  // Acerta os decimais conforme campo do preço unitário
			nTotal := Round(SL2->L2_QUANT * nCusto,nDecTot)
			_DataE := (dDataBase + nDiaEnt) 
			QOUT(DTOC(_DataE))
			QOUT("ITENS")
			// Adiciona os itens do pedido de venda
			aLinha := {}
			AAdd( aLinha , { "C6_ITEM"   , cItem:=Soma1(cItem) , Nil})
			AAdd( aLinha , { "C6_PRODUTO", SL2->L2_PRODUTO     , Nil})
			AAdd( aLinha , { "C6_QTDVEN" , SL2->L2_QUANT       , Nil})
			AAdd( aLinha , { "C6_PRCVEN" , nCusto		       , Nil})
			AAdd( aLinha , { "C6_VALOR"  , nTotal              , Nil})

/*
			IF(SL1->L1_XCD == "1")
				AAdd( aLinha , { "C6_TES"    , "724"                , Nil})
				AAdd( aLinha , { "C6_LOCAL"  ,"15"      , Nil})
			ELSE
			*/
				AAdd( aLinha , { "C6_TES"    , cTES                , Nil})
				AAdd( aLinha , { "C6_LOCAL"  , SL2->L2_LOCAL       , Nil})

			AAdd( aLinha , { "C6_CLI"    , SA1->A1_COD         , Nil})
			AAdd( aLinha , { "C6_LOJA"   , SA1->A1_LOJA        , Nil})
			AAdd( aLinha , { "C6_DESCRI" , SB1->B1_DESC        , Nil})
			AAdd( aLinha , { "C6_PRUNIT" , nCusto 		       , Nil})
			AAdd( aLinha , { "C6_ENTREG" , SL2->L2_FDTENTR     , Nil})		      
			AAdd( aLinha , { "C6_XFILRES", SL2->L2_FILRES	   , Nil})  // Filial que efetuou a reserva
			AAdd( aLinha , { "C6_XORCRES", SL2->L2_ORCRES      , Nil})  // Orçamento com reserva
			AAdd(aItens,aLinha)

			AAdd(aRegs , SL2->(Recno()) )   // Guarda registro para gravação do pedido de venda
		Endif
		cTes := cTesaux
		SL2->(dbSkip())
	Enddo
	QOUT("FORA WHILE")
	// Se encontrou itens em reserva
	If !Empty(aItens)
		cFilAnt := cFilInd   // Atualiza para filial de destino do pedido

		// Variavel que controla numeracao
		nSaveSX8 := GetSx8Len()
		QOUT("Tem Item")
		// Calcula o próximo número de pedido
		//cNumPed := GetSxeNum("XC5","C5_NUM",cFilAnt+"NUMLOJA")
		cNumPed := GetSxeNum("SC5","C5_NUM",cFilAnt+"NUMLOJA")
		ConfirmSX8()
		
		//RollBAckSx8()

		cMenNota := "CLIENTE: "+SL1->L1_CLIENTE+" - PEDIDO CLIENTE: "+PedReserva()
		QOUT("Pedido: "+cNumPed)
		// Adiciona o cabeçalho do pedido de venda
		AAdd( aCabec , { "C5_NUM"    , cNumPed                      , Nil})
		AAdd( aCabec , { "C5_TIPO"   , "N"                          , Nil})
		AAdd( aCabec , { "C5_CLIENTE", SA1->A1_COD                  , Nil})
		AAdd( aCabec , { "C5_LOJACLI", SA1->A1_LOJA                 , Nil})
		AAdd( aCabec , { "C5_LOJAENT", SA1->A1_LOJA                 , Nil})
		AAdd( aCabec , { "C5_CONDPAG", "001"                        , Nil})
		AAdd( aCabec , { "C5_VEND1"  , SL1->L1_VEND                 , Nil})
		//		AAdd( aCabec , { "C5_VEND2"  , SL1->L1_VEND                 , Nil})
		AAdd( aCabec , { "C5_MENNOTA", SL1->L1_XMENNOT              , Nil})
		AAdd( aCabec , { "C5_XFILRES", SL1->L1_FILIAL               , Nil})  // Filial que efetuou a reserva
		AAdd( aCabec , { "C5_XORCRES", SL1->L1_NUM                  , Nil})  // Orçamento com reserva
		AAdd( aCabec , { "C5_OBS1"   , SubStr(SL1->L1_XOBS,1,50)    , Nil})
		AAdd( aCabec , { "C5_OBS2"   , SubStr(SL1->L1_XOBS,51,100)  , Nil})
		AAdd( aCabec , { "C5_OBS3"   , SubStr(SL1->L1_XOBS,101,150) , Nil})

		// Inclusao do pedido
		lMsErroAuto := .F.
		lMSHelpAuto := .T.
		MSExecAuto({|x,y,Z| Mata410(x,y,Z)}, aCabec, aItens, 3)

		// Checa erro de rotina automatica
		If lMsErroAuto     			
			QOUT("ERRO AO INCLUIR O PEDIDO")
			Mostraerro()
			DisarmTransaction()
		Else
			// Confirma SX8
			While ( GetSx8Len() > nSaveSX8 )
				ConfirmSX8()
			Enddo

			// Atualiza os itens com o número do pedido de venda
			/*For nX:=1 To Len(aRegs)
			RecLock("SL2",.F.)
			SL2->L2_XPDTRAN := cNumPed
			MsUnLock()
			Next*/
		Endif  

		cFilAnt := cFilAux   // Restaura filial logada
	Endif
	QOUT("ERRO AO INCLUIR O PEDIDO")
	dbSelectArea(cAlias)

Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PedReserva ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 29/03/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descrição ¦ Rotina de busca do pedido de venda do cliente                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PedReserva()
	Local cAlias := Alias()
	Local cRet   := ""

	cQry := "SELECT L1_PEDRES"
	cQry += " FROM "+RetSQLName("SL1")
	cQry += " WHERE D_E_L_E_T_ = ' '"
	cQry += " AND L1_ORCRES = '"+SL1->L1_NUM+"'"
	cQry += " AND L1_FILRES = '"+SL1->L1_FILIAL+"'"

	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "PEDRES", .T., .F. )
	cRet := L1_PEDRES
	dbCloseArea()
	dbSelectArea(cAlias)

Return cRet
