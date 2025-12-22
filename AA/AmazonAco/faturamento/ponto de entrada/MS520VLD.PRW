#include "RWMAKE.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MS520VLD   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 12/09/2008 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descricao ¦ Ponto de Entrada de validação da exclusão da N. F. de Saída.  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MS520VLD()
	Local aDados
	Local _cFormDel := SuperGetMv("MV_XFORMLJ",.F.,"BO")
	Local bWhile    := {|| SL4->(L4_FILIAL+L4_NUM) == SL1->(L1_FILRES+L1_ORCRES) }
	Local lRet      := .T.
	
	// Posiciona nos itens da nota fiscal
	SD2->(dbSetOrder(3))
	SD2->(dbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE),.T.))
	While !SD2->(Eof()) .And. SF2->(F2_FILIAL+F2_SERIE+F2_DOC) == SD2->(D2_FILIAL+D2_SERIE+D2_DOC)
		
		// Posiciona no pedido de venda
		SC5->(dbSetOrder(1))
		If !SC5->(dbSeek(SD2->(D2_FILIAL+D2_PEDIDO)))
			// Caso não encontre o pedido de venda
			SD2->(dbSkip())
			Loop
		Endif
		
		//Historico
		aDados := {}
		aAdd(aDados,{"Z5_PEDIDO" , SC5->C5_NUM                 })
		aAdd(aDados,{"Z5_PRODUTO", SD2->D2_COD                 })
		aAdd(aDados,{"Z5_DATA"   , dDataBase                   })
		aAdd(aDados,{"Z5_HORA"   , SubStr(Time(),1,5)          })
		aAdd(aDados,{"Z5_USER"   , cUserName                   })
		aAdd(aDados,{"Z5_OP"     , ""                          })
		aAdd(aDados,{"Z5_OBS"    , "EXCLUSAO DA NOTA DO PEDIDO"})
		aAdd(aDados,{"Z5_STATUS" , "1"                         })
		aAdd(aDados,{"Z5_ENTREGA", CTOD("  /  /  ")            })
		
		If ExistBlock("AALOGE02")
			u_AALOGE02(aDados)
		EndIf
		//Fim Historico
		
		// Posiciona no orçamento
		SL1->(dbSetOrder(1))
		SL1->(dbSeek(SC5->(C5_FILIAL+C5_ORCRES)))
		
		// Posiciona nas parcelas do orçamento
		SL4->(dbSetOrder(1))
		SL4->(dbSeek(SL1->(L1_FILRES+L1_ORCRES)))
		
		lDeleta := .F.
		_cForma := SL4->L4_FORMA
		
		SL4->(DBEVAL({|| lDeleta := If( (Alltrim(SL4->L4_FORMA) $ _cFormDel),.T.,lDeleta) },bWhile,bWhile,,,))
		
		If lDeleta
			_cTipo := Padr(_cForma,Len(SE1->E1_TIPO))
			
			// Posiciona no contas a receber
			SE1->(dbSetOrder(1))
			SE1->(dbSeek(xFilial("SE1")+SF2->(F2_SERIE+F2_DOC),.T.))
			While !SE1->(Eof()) .And. xFilial("SE1")+SF2->(F2_SERIE+F2_DOC) == SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM)
				RecLock("SE1",.F.)
				SE1->E1_TIPO := "NF"
				MsUnLock()
				SE1->(dbSkip())
			EndDo
		EndIf
		
		SD2->(dbSkip())
	EndDo
	
	// Posiciona no cadastro do cliente
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(XFILIAL("SA1")+SF2->(F2_CLIENTE+F2_LOJA)))
	
	SZE->(dbSetOrder(4))
	If SZE->(dbSeek(XFILIAL("SZE")+SF2->(F2_DOC+F2_SERIE)))
		// Não processa para série 6
		If Trim(SF2->F2_SERIE) <> "6"
			If lRet := fTabTmp()
				If Empty(SZE->ZE_ROMAN)
					RecLock("SZE", .F.)
						u_AALOGE01(SZE->ZE_ROMAN,SZE->ZE_DOC,SZE->ZE_SERIE, "Exclusão dos Registros")
						dbDelete()
					MsUnLock()
				EndIf 
			ElseIf lRet := ("05477207" $ SA1->A1_CGC)  // Não exibe mensagem se o cliente for AMAZON AÇO (transferência)
			
			Else
				MsgStop("Esta nota não pode ser excluída, pois encontra-se em romaneio!")
			EndIf
		EndIf
	EndIf 	
Return lRet

//*********************************************************************************************************
Static Function fTabTmp()
	Local cAlias := Alias()
	Local cQry   := ""
	Local nRecno := 0
	
	cQry := "SELECT ISNULL(R_E_C_N_O_,0) AS ZE_RECNO "
	cQry += " FROM "+RetSQLName("SZE")+" A "
	cQry += " WHERE A.D_E_L_E_T_ = ' '"
	cQry += " AND ZE_FILIAL = '" + xFilial("SZE") + "' "
	cQry += " AND ( ZE_ROMAN  = ' ' "
	cQry += " OR    ZE_STATUS IN  ( 'D', 'S' ) ) "

	cQry += " AND ZE_DOC    = '"+SF2->F2_DOC +"' "
	cQry += " AND ZE_SERIE  = '"+SF2->F2_SERIE  +"' "
	cQry += "ORDER BY ZE_BAIRRO"
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "WWW", .T., .F. )
	nRecno := ZE_RECNO
	WWW->(dbCloseArea())
	dbSelectArea(cAlias)
	
	// Se encontrou registro válido
	If nRecno > 0
		SZE->(dbSetOrder(1))
		SZE->(dbGOto(nRecno))
	Endif
	
Return nRecno > 0

/*----------------------------------------------------------------------------------||
||       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||      AAAA       LL         LL         EE         CC        KK    KK   SS         ||
||     AA  AA      LL         LL         EE        CC         KK  KK     SS         ||
||    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   ||
||   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  ||
||  AA        AA   LL         LL         EE         CC        KK    KK          SS  ||
|| AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||----------------------------------------------------------------------------------*/