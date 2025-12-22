#include "Protheus.ch"
#include "TOTVS.ch"
#include "RwMake.ch"

User Function AAFKE01(_cdFilial,_cdOrcamento,_cLocal)

	Local cFilAux
	Local _cChave 
	Local cPerg          := Padr("AAFK01",Len(SX1->X1_GRUPO))
	Local lLibRes        := GetMV("MV_XLIBRES",.F.,.F.)
	
	Local adRegC6   := {}
	Local nDr
	Local _ndPos
	Local xC9Upd 
	
	Default _cdFilial    := ""
	Default _cdOrcamento := ""
	
	Private  cTable      := ""
	Private lMsErroAuto  := .F.
	
	_ldPerg := Empty(_cdOrcamento) .Or. Empty(_cdFilial)
	
	Createperg(cPerg)
	Pergunte(cPerg,_ldPerg)
	
	If _ldPerg
		_cdOrcamento := mv_par01
		_cdFilial    := mv_par02
	EndIf
	
	cTable := GetInf(_cdFilial,_cdOrcamento)
	
	_cdFilterSC5 := SC5->(DBFilter () )
	_cdFilterSC6 := SC6->(DBFilter () )
	_cdFilterSL2 := SL2->(DBFilter () )
	
	SC5->(dbClearFilter())
	SC6->(dbClearFilter())
	SL2->(dbClearFilter())
	
	SB1->(dbSetOrder(1))
	SC6->(dbSetOrder(1))
	SC5->(dbSetOrder(1))
	SL2->(dbSetOrder(1))
	SF4->(dbSetOrder(1))
	SA1->(dbSetOrder(1))
	
	//criado
	_aQry := {}
	_cQry := ""
	//Williams Messa - 17/12/2020 - Eliminação de um caixa.
    //cAlmTra := GetMV("MV_XALMCTR") //Situação Anterior 18/01/2021 - Williams Messa

	IF fwCodEmp() == "01" 

		If  _cLocal=="03"
			cAlmTra := "10"
		_cdFilial:="03"
		ElseIf  _cLocal=="04" 
		cAlmTra := "22"
		_cdFilial:="04"
		Else
		cAlmTra := "24"
		_cdFilial:="02"
		EndIf 
	Else 
		cAlmTra := "01"
		_cdFilial:="03"
	EndIf 
	//Williams Messa - 17/12/2020 - Eliminação de um caixa.
			

	//Begin Transaction
	xC9Upd := ""
	While !(cTable)->(Eof())
		
		if SC5->(dbSeek( (cTable)->(L1_FILIAL + L1_PEDRES) ) )
			//AlteraPedido(SC5->C5_FILIAL,SC5->C5_NUM,.F.)  // Estorna o pedido liberado pelo sistema
			
			aCabPed := {}
			SA1->(dbSetOrder(1))
			SA1->(dbSeek( xFilial("SA1") + SC5->(C5_CLIENTE + C5_LOJACLI)  ))
			
			For _ndPos := 1 to SC5->(fCount())
				lDeleta := .F.
				
				If SC5->(FieldName(_ndPos)) == "C5_CONDPAG"
					_cFormDel := SuperGetMv("MV_XFORMLJ",.F.,"BO")
					_cChave   := ((cTable)->L1_FILRES + (cTable)->L1_ORCRES)
					
					SL4->(dbSeek(_cChave,.T.))
					While !SL4->(Eof()) .And. _cChave == SL4->(L4_FILIAL + L4_NUM)
						lDeleta := If( lDeleta , .T., Alltrim(SL4->L4_FORMA) $ _cFormDel)
						SL4->(dbSkip())
					Enddo
					
					If (cTable)->L1_CONDPG != 'CN' .And. lDeleta
						Aadd(aCabPed,{ SC5->(FieldName(_ndPos)) ,  (cTable)->L1_CONDPG , NIL })
						_cCond := (cTable)->L1_CONDPG
					Elseif lDeleta
						_cCOnd := AAGETCON()
						Aadd(aCabPed,{ SC5->(FieldName(_ndPos)) ,  _cCOnd  , NIL })
					else
						Aadd(aCabPed,{ SC5->(FieldName(_ndPos)) ,  SC5->&(FieldName(_ndPos))			, NIL })
						_cCond := SC5->&(FieldName(_ndPos))
					ENdIf
					
				Elseif SC5->(FieldName(_ndPos)) == "C5_COMIS1"
					Aadd(aCabPed,{ SC5->(FieldName(_ndPos)) ,  iIf(lDeleta,0,(cTable)->L1_COMIS)			, NIL })
				Elseif SC5->(FieldName(_ndPos)) == "C5_XORCRES"
					Aadd(aCabPed,{ SC5->(FieldName(_ndPos)) ,  _cdOrcamento  			, NIL })
				Elseif SC5->(FieldName(_ndPos)) == "C5_XNOMCLI"
					Aadd(aCabPed,{ SC5->(FieldName(_ndPos)) ,  SA1->A1_NOME  			, NIL })
				elseif SC5->(FieldName(_ndPos)) == "C5_XFILRES"
					Aadd(aCabPed,{ SC5->(FieldName(_ndPos)) ,  _cdFilial              , NIL })
				elseif SC5->(FieldName(_ndPos)) == "C5_TPFRETE"
					Aadd(aCabPed,{ SC5->(FieldName(_ndPos)) ,  "C"                    , NIL })
				Else
					Aadd(aCabPed,{ SC5->(FieldName(_ndPos)) ,  SC5->&(FieldName(_ndPos))	, NIL })
				EndIF
			Next
			
			_cQry := ''
			If Empty(_cQry)
				_cQry += " Update " + RetSqlNAme("SC5")
				_cQry += " Set "
			EndIf
			
			_nTam := Len(_cQry)
			
			If SC5->(FieldPos("C5_CONDPAG")) > 0
				_cQry += iIf( _nTam != Len(_cQry), "," , "" ) + " C5_CONDPAG = '" + _cCond + "' "  //criado
			EndIf
			If SC5->(FieldPos("C5_COMIS1")) > 0
				_cQry +=  iIf( _nTam != Len(_cQry), "," , "") + " C5_COMIS1 = " +	Str(iIf(lDeleta,0,(cTable)->L1_COMIS) )//criado
			EndIf
			
			If SC5->(FieldPos("C5_XORCRES")) > 0
				_cQry += iIf( _nTam != Len(_cQry), "," ,"" ) + " C5_XORCRES = '" + _cdOrcamento + "'"
			EndIf
			If SC5->(FieldPos("C5_XNOMCLI")) > 0
				_cQry += iIf( _nTam != Len(_cQry), "," ,"" ) + " C5_XNOMCLI = '" + SA1->A1_NOME + "'"
			EndIf
			If SC5->(FieldPos("C5_XFILRES")) > 0
				_cQry += iIf( _nTam != Len(_cQry), "," ,"" ) + " C5_XFILRES = '" + _cdFilial + "'"
			EndIf
			If SC5->(FieldPos("C5_TPFRETE")) > 0
				_cQry += iIf( _nTam != Len(_cQry), "," ,"" ) + " C5_TPFRETE = 'C'"
			EndIf
			
			If _nTam != Len(_cQry)
				_cQry += " Where C5_NUM = '" + SC5->C5_NUM + "'"
				_cQry += " And C5_FILIAL = '" + SC5->C5_FILIAL + "'"
			EndIf
			
			If !Empty(_cQry )
				aAdd(_aQry,_cQry)
				_cQry := ""
			EndIf
			
			SC6->(dbSeek(SC5->(C5_FILIAL + C5_NUM)))
			_cChave := SC5->(C5_FILIAL + C5_NUM)
			
			aItensPed := {}
			cFilAux   := cFilAnt
			
			//cAlmTra := GetMV("MV_XALMCTR") //Situação Anterior 18/01/2021 - Williams Messa
			/*
			If _cLocal=="03"
				cAlmTra := "10"
			ElseIf _cLocal=="04" 
				cAlmTra := "22"
			Else
				cAlmTra := "25"
			EndIf 
			*/
			//Williams Messa - 17/12/2020 - Eliminação de um caixa.
			
			//alert('Filial'+cFilAnt)
			//alert('Almoxarifado'+cAlmTra)
			
			// Efetua acerto para buscar o almoxarifado de trânsito da filial do pedido
			cFilAnt := SC6->C6_FILIAL			
			cFilAnt := cFilAux
			
			While !SC6->(EOF()) .And. SC6->(C6_FILIAL + C6_NUM) == _cChave
				aLinhaPed := {}
				If Empty(_cQry)
					_cQry += " Update " + RetSqlNAme("SC6")
					_cQry += " Set "
					xC9Upd := " Update " + RetSqlNAme("SC9") + " Set "
				EndIf
				_aRet := GetTes()
				
				// Posiciona no cadastro de produtos
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial('SB1') + SC6->C6_PRODUTO))
				
				// Posiciona no cadastro de TES
				SF4->(dbSetOrder(1))
				SF4->(dbSeek(xFilial('SF4') + _aRet[01]))
				
				_cQry += " C6_TES = '" + _aRet[01] + "',"
				_cQry += " C6_CF  = '" + iIf(SA1->A1_EST = "EX","7",Iif(SA1->A1_EST!="AM","6","5") )  + SubSTr( SF4->F4_CF,2,3) +  "', "
				_cQry += " C6_QTDLIB = " + If( lLibRes , LTrim(Str(SC6->C6_QTDVEN)), "0") + ", "
				_cQry += " C6_CLASFIS = '" + Trim(SB1->B1_ORIGEM)+Trim(SF4->F4_SITTRIB) + "' "
				
				// Se não forem esses campos
				If !(Trim(SB1->B1_GRUPO) $ "26,28,23,24,25")
					// Se não forem esses PRODUTOS DO GRUPO 63
					If !(Trim(SB1->B1_COD) $ "63000001,63000002,63000003,63000004,63000024,63000025,63000026,63000027,63000028")
							_cQry += ", C6_LOCAL = '" + cAlmTra + "' "
							xC9Upd += " C9_LOCAL = '" + cAlmTra + "' "
						Else 
						   _cQry += ", C6_LOCAL = '14' "
						   xC9Upd += " C9_LOCAL = '14' "
					Endif
				Endif
				
				For _ndPos := 1 to SC6->(fCount())
					
					If SC6->(FieldName(_ndPos)) = "C6_TES"
						_aRet := GetTes()
						If Len(_aRet) != 0
							Aadd(aLinhaPed,{ "C6_TES" ,  _aRet[01]			,NIL })
							Aadd(aLinhaPed,{ "C6_CF"  ,  iIf(SA1->A1_EST = "EX","7",Iif(SA1->A1_EST!="AM","6","5") )  + SubSTr( SF4->F4_CF ,2,3), NIL })
						EndIf
						
					elseIf SC6->(FieldName(_ndPos)) = "C6_CLASFIS"
						Aadd(aLinhaPed,{ "C6_CLASFIS", Trim(SB1->B1_ORIGEM)+Trim(SF4->F4_SITTRIB) ,NIL })
					elseIf SC6->(FieldName(_ndPos)) = "C6_QTDLIB"
						Aadd(aLinhaPed,{ SC6->(FieldName(_ndPos)) , If( lLibRes , SC6->C6_QTDVEN - SC6->C6_QTDENT, 0), NIL })
					elseIf SC6->(FieldName(_ndPos)) == "C6_LOCAL"
						// Se não forem esses campos
						If !(Trim(SB1->B1_GRUPO) $ "26,28,23,24,25") .And.;  // Se não forem esses PRODUTOS DO GRUPO 63
							!(Trim(SB1->B1_COD) $ "63000001,63000002,63000003,63000004,63000024,63000025,63000026,63000027,63000028")
							Aadd(aLinhaPed,{ SC6->(FieldName(_ndPos)) , cAlmTra, NIL })
						Else
//							Aadd(aLinhaPed,{ SC6->(FieldName(_ndPos)) , SC6->C6_LOCAL      , NIL }) /// ALLECKS 18/07/13
							If SC6->C6_LOCAL == "01"
									Aadd(aLinhaPed,{ SC6->(FieldName(_ndPos)) , "14"         , NIL }) /// ALLECKS 18/07/13
								Else 
            					Aadd(aLinhaPed,{ SC6->(FieldName(_ndPos)) , SC6->C6_LOCAL, NIL }) /// ALLECKS 18/07/13
 							EndIf 
						Endif
					elseIf SC6->(FieldName(_ndPos)) == "C6_PRUNIT"
						// Pesquisa o preço de tabela do item para forçar sua gravação
						SL2->(dbSeek((cTable)->(L1_FILIAL+L1_NUM),.T.))
						While !SL2->(Eof()) .And. (cTable)->(L1_FILIAL+L1_NUM) == SL2->(L2_FILIAL+L2_NUM)
							If SL2->(L2_ITEM+L2_PRODUTO) == SC6->(C6_ITEM+C6_PRODUTO)
								Aadd(aLinhaPed,{ SC6->(FieldName(_ndPos)) , SL2->L2_PRCTAB  , NIL })
								Exit  // Se encontrou o item, sai do loop
							Endif
							SL2->(dbSkip())
						Enddo
					elseIf !SC6->(FieldName(_ndPos)) $ "C6_IPIDEV/C6_BLQ/C6_LOCALIZ/C6_CODFAB/C6_LOJAFA/C6_TPCONTR/C6_ITCONTR/ C6_GEROUPV/C6_PROJPMS/C6_EDTPMS/C6_TASKPMS/C6_TRT/C6_REGWMS/C6_PROJET/C6_ITPROJ/C6_POTENCI/C6_LICITA/C6_FETAB/C6_FUNRURA/C6_CF/C6_SEGUM/C6_TPOP/C6_PEDCOM"
					
					EndIf

				Next
				Aadd(aItensPed, aLinhaPed)
				
				_cQry += " WHere C6_PRODUTO = '" + SC6->C6_PRODUTO + "'"
				_cQry += " And C6_ITEM = '" + SC6->C6_ITEM + "'"
				_cQry += " And C6_NUM = '" + SC6->C6_NUM + "'"
				_cQry += " And C6_FILIAL = '" + SC6->C6_FILIAL + "'"
				
				xC9Upd += " WHere C9_PRODUTO = '" + SC6->C6_PRODUTO + "'"
				xC9Upd += " And C9_ITEM = '" + SC6->C6_ITEM + "'"
				xC9Upd += " And C9_PEDIDO = '" + SC6->C6_NUM + "'"
				xC9Upd += " And C9_FILIAL = '" + SC6->C6_FILIAL + "'"
				
				If !Empty(_cQry )
					aAdd(_aQry,_cQry)
					aAdd(_aQry,xC9Upd)
					_cQry := ""
					xC9Upd := ""
				EndIf
				
				SC6->(dbSkip())
			EndDo
			
			cFilAnt := (cTable)->L1_FILIAL
			cFilAnt := cFilAux
			//conout('FAKE Alterando ' + (cTable)->L1_PEDRES)
			//If lMsErroAuto
				//DisarmTransaction()//Alterado - Williams Messa - Adicionado o Disarm, pois apesar de dar o update, estava ficando um processo fantasma na base.
				//conout('Deu Erro e disarmou a transação! Mas entra no Update') //Alterado - Williams Messa
				//Mostraerro() //- Alterado - Williams Messa
				//Aviso("Atencao","Deseja Forcar a Alteracao das Informações?",{"Sim"}) //Alterado - Williams Messa
			_cdSave := ""
			For nDr := 1 to Len(_aQry)
				_cdSave += " Item: " + Alltrim(Str(nDr)) +;
			       Chr(13) + Chr(10) + _aQry[nDr] +;
			       Chr(13) + Chr(10)	
				tcSqlExec(_aQry[nDr])
		    Next
			memowrite("\01FAKE\"+ _cdFilial + _cdOrcamento+".sql", _cdSave ) 			
			//EndIf
		EndIf
		(cTable)->(dbskip())
	EndDo

	//End Transaction
	
Return Nil

Static Function GetInf(_cdFilial,_cdOrcamento)
	Local cTable := GetNextAlias()
	Local cQry   := ""
	
	Default _cdFilial    := ""
	Default _cdOrcamento := ""
	
	cQry += "SELECT DISTINCT SL1.*"
	cQry += " FROM "+RetSqlName("SL2")+" SL2"
	cQry += " LEFT OUTER JOIN "+RetSqlName("SL1")+" SL1 ON SL1.L1_ORCRES = SL2.L2_NUM AND SL1.L1_FILRES = SL2.L2_FILIAL"
	cQry += " WHERE SL2.D_E_L_E_T_ = ' ' AND SL1.D_E_L_E_T_ = ' '"
	cQry += " AND SL2.L2_NUM = '" + _cdOrcamento + "'"
	cQry += " AND SL2.L2_FILIAL = '" + _cdFilial + "'"
	cQry += " AND SL1.L1_PEDRES <> ' '"
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),cTable,.T.,.T.)
	
	TCSetField( cTable, "L1_EMISSAO", "D",8,0)
	
Return cTable

Static function CreatePerg(cPerg)
	Local aTam := {}
	
	aAdd(aTam,{TamSx3("L1_NUM")[01],TamSx3("L1_NUM")[02]})
	aAdd(aTam,{TamSx3("L1_FILIAL")[01],TamSx3("L1_FILIAL")[02]})
	
	PutSX1(cPerg,"01","Orcamento ?" ,"","","mv_ch1","C",aTam[01][01],aTam[01][02],0,"G","","SL1","","","mv_par01")
	PutSX1(cPerg,"02","Filial Orc?","","" ,"mv_ch2","C",aTam[02][01],aTam[02][02],0,"G","","   ","","","mv_par02")
	
return

Static Function GetTEs()
	Local _lOk := .F.
	Local _aRet:= {}
	
	SB1->(dbSetORder(1))
	// Posiciona o Produto atual do aCols
	If SB1->(dbSeek(xFilial('SB1')+SC6->C6_PRODUTO))
		// Posiciona no Indice 1 da tabela de Cliente
		
		If SA1->(dbSeek(xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI))
			// Verificando se o Cliente e do Estado do Amazonas para verificar a regra do ESTTRIB
			if SA1->A1_EST = 'AM'
				//conout('dentro do estado')
				// Posiciona no indice 1 ta Tabela SZG
				SZG->(dbSetOrder(1))
				// Posiciona na primeira regra para o Produto caso exista alguma senao posicionara na regra do grupo
				If SZG->(dbSeek(xfilial('SZG') + PADR(SB1->B1_COD,Len(SZG->ZG_GRUPO))  ))
					//conout('PRODUTO')
					lExiste := .F.
					// Procurando regra para o Produto Valida caso exista alguma
					While xfilial('SZG') + PADR(SB1->B1_COD,Len(SZG->ZG_GRUPO)) == SZG->(ZG_FILIAL + ZG_GRUPO) .And. !lExiste
						// verifica se o Cliente esta na regra do TIPTRIP e ESTTRIB = 'D' referente a cliente de dentro do Estado
						lExiste := SA1->A1_XTRBSAI $ SZG->ZG_TIPTRIP .And. SZG->ZG_ESTTRIB = 'D'
						//conout('cliente - PRODUTO: ' )
						//conout( SA1->A1_NOME)
						//conout(lExiste)
						// caso nao esteja na regra vai para a proxima regra do produto
						IF !lExiste
							SZG->(dbSkip())
						EndIf
					EndDo
					// Caso nao encontre a regra por produto, pesquisa pelo grupo do produto
				ElseIf SZG->(dbSeek(xfilial('SZG') + PADR(SB1->B1_GRUPO,Len(SZG->ZG_GRUPO))  ))
					lExiste := .F.
					//CONOUT('PROCURANDO GRUPO DENTRO DO ESTADO')
					// Procurando regra para o Produto Valida caso exista alguma
					While xfilial('SZG') + PADR(SB1->B1_GRUPO,Len(SZG->ZG_GRUPO)) == SZG->(ZG_FILIAL + ZG_GRUPO) .And. !lExiste
						// verifica se o Cliente esta na regra do TIPTRIP e ESTTRIB = 'D' referente a cliente de dentro do Estado
						lExiste := SA1->A1_XTRBSAI $ SZG->ZG_TIPTRIP .And. SZG->ZG_ESTTRIB = 'D'
						//conout('cliente - PRODUTO: ' )
						//conout( SA1->A1_NOME)
						//conout(lExiste)
						// caso nao esteja na regra vai para a proxima regra do produto
						IF !lExiste
							SZG->(dbSkip())
						EndIf
					EndDo
				EndIf
				// Trata Caso o Cliente seja da Area de Livre Comercio
			elseiF SA1->A1_XLIVCOM
				//conout('LIVRE COMERCIO')
				SZG->(dbSetOrder(1))
				// Posiciona na primeira regra para o Produto caso exista alguma senao posicionara na regra do grupo
				If SZG->(dbSeek(xfilial('SZG') + PADR(SB1->B1_COD,Len(SZG->ZG_GRUPO) )))//Tratamento para o Codigo
					//CONOUT('PROCURANDO PRODUTO DENTRO LIVRE ')
					lExiste := .F.
					// Procurando regra para o Produto Valida caso exista alguma
					While xfilial('SZG') + PADR(SB1->B1_COD,Len(SZG->ZG_GRUPO)) == SZG->(ZG_FILIAL + ZG_GRUPO) .And. !lExiste
						// verifica se o Cliente esta na regra do TIPTRIP e ESTTRIB = 'L' referente a regra de clientes da area de Livre Comercio
						lExiste := SA1->A1_XTRBSAI $ SZG->ZG_TIPTRIP .And. SZG->ZG_ESTTRIB = 'L'
						//conout('cliente - PRODUTO: ' )
						//conout( SA1->A1_NOME)
						//conout(lExiste)
						IF !lExiste
							SZG->(dbSkip())
						EndIf
					EndDo
					// Posiciona na primeira regra para o Produto caso exista alguma senao posicionara na regra do grupo
				ElseIf SZG->(dbSeek(xfilial('SZG') + PADR(SB1->B1_GRUPO,Len(SZG->ZG_GRUPO))  ))
					//CONOUT('PROCURANDO GRUPO DENTRO LIVRE ')
					lExiste := .F.
					// Procurando regra para o Produto Valida caso exista alguma
					While xfilial('SZG') + PADR(SB1->B1_GRUPO,Len(SZG->ZG_GRUPO)) == SZG->(ZG_FILIAL + ZG_GRUPO) .And. !lExiste
						// verifica se o Cliente esta na regra do TIPTRIP e ESTTRIB = 'L' referente a regra de clientes da area de Livre Comercio
						lExiste := SA1->A1_XTRBSAI $ SZG->ZG_TIPTRIP .And. SZG->ZG_ESTTRIB = 'L'
						//conout('cliente - PRODUTO: ' )
						//conout( SA1->A1_NOME)
						//conout(lExiste)
						IF !lExiste
							SZG->(dbSkip())
						EndIf
					EndDo
				EndIf
				// referente a Clientes do exterior que nao estao na area de Livre COmercio
			else
				//CONOUT('FORA ')
				SZG->(dbSetOrder(1))
				// Posiciona na primeira regra para o Produto caso exista alguma senao posicionara na regra do grupo
				If SZG->(dbSeek(xfilial('SZG') + PADR(SB1->B1_COD,Len(SZG->ZG_GRUPO)) ))
					//CONOUT('PROCURANDO PROD FORA ')
					lExiste := .F.
					// Procurando regra para o Produto Valida caso exista alguma
					While xfilial('SZG') + PADR(SB1->B1_GRUPO,Len(SZG->ZG_GRUPO)) == SZG->(ZG_FILIAL + ZG_GRUPO) .And. !lExiste
						// verifica se o Cliente esta na regra do TIPTRIP e ESTTRIB = 'F' referente a regra de clientes Fora da area de Livre Comercio
						lExiste := SA1->A1_XTRBSAI $ SZG->ZG_TIPTRIP .And. SZG->ZG_ESTTRIB = 'F'
						//conout('cliente - PRODUTO: ' )
						//conout( SA1->A1_NOME)
						//conout(lExiste)
						IF !lExiste
							SZG->(dbSkip())
						EndIf
					EndDo
					// Posiciona na primeira regra para o Produto caso exista alguma senao posicionara na regra do grupo
				ElseIf SZG->(dbSeek(xfilial('SZG') +  PADR(SB1->B1_GRUPO,Len(SZG->ZG_GRUPO))  ))
					//CONOUT('PROCURANDO GRUPO FORA ')
					lExiste := .F.
					// Procurando regra para o Produto Valida caso exista alguma
					While xfilial('SZG') + PADR(SB1->B1_GRUPO,Len(SZG->ZG_GRUPO)) == SZG->(ZG_FILIAL + ZG_GRUPO) .And. !lExiste
						// verifica se o Cliente esta na regra do TIPTRIP e ESTTRIB = 'F' referente a regra de clientes Fora da area de Livre Comercio
						lExiste := SA1->A1_XTRBSAI $ SZG->ZG_TIPTRIP .And. SZG->ZG_ESTTRIB = 'F'
						//conout('cliente - PRODUTO: ' )
						//conout( SA1->A1_NOME)
						//conout(lExiste)
						IF !lExiste
							SZG->(dbSkip())
						EndIf
					EndDo
				EndIf
			EndIf
			//atualliza a Informacao do tes do Produto
			//CONOUT('TES DE SAIDA' + SZG->ZG_TES)
			//ConOut('VERIFICALOGO')
			//conout('End Of File')
			//conout(SZG->(EOF())  )
			
			if !SZG->(EOF())
				aAdd(_aRet,SZG->ZG_TES)
				aAdd(_aRet,Posicione('SF4',1,SF4->(xFilial('SF4')) + SZG->ZG_TES ,'F4_CF') )
				_lOk := .T.
			EndIf
		EndIf
	EndIf
	
Return _aRet

Static Function AAGETCON()
	Local nQuant  := Space(TamSx3('E4_CODIGO')[01])
	
	Define Font oFnt3 Name "Ms Sans Serif" Bold
	
	while !SE4->(dbSeek(xFilial('SE4') + nQuant))
		
		DEFINE MSDIALOG oDialog TITLE "Condicao de Pagamento do Pedido de Reserva" FROM 190,110 TO 300,370 PIXEL STYLE nOR(WS_VISIBLE,WS_POPUP)
		@ 005,004 SAY "Condicao :" SIZE 220,10 OF oDialog PIXEL Font oFnt3
		@ 005,050 MsGET nQuant     SIZE 50,10  F3 "SE4" PICTURE "@!" Pixel of oDialog
		
		@ 035,042 BMPBUTTON TYPE 1 ACTION( nRet := IIF(SE4->(dbSeek(xFilial('SE4') + nQuant)),oDialog:End(), NIL) )
		
		ACTIVATE DIALOG oDialog CENTERED
	Enddo
	
Return nQuant
