#Include "Protheus.ch"
#Include "Tbiconn.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MGFATP03   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 01/02/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Processa a exclusão dos documentos fiscais de saída integrados¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MGFATP03()
	Local aSays    := {}             
	Local aButtons := {}
	Local cPerg    := "MGFATP03"
	Local nOpcA    := 0
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	AADD(aSays, "Esta rotina fará a exclusão dos documentos fiscais gerados via" )
	AADD(aSays, "importação do sistema legado." )
	
	cCadastro := "Exclusão dos Documentos Fiscais de Saída"
	
	aAdd( aButtons, { 5, .T., {|x| Pergunte(cPerg,.T.)    }} )
	aAdd( aButtons, { 1, .T., {|x| nOpcA := 1, oDlg:End() }} )
	aAdd( aButtons, { 2, .T., {|x| nOpcA := 2, oDlg:End() }} )
	
	FormBatch( cCadastro, aSays, aButtons )
	
	If nOpcA == 1
		Processa( {|| GravaDados() } , "Exclusão dos Documentos Fiscais")
	Endif

Return

Static Function GravaDados()
	Local aRegSD2, aRegSE1, aRegSE2, cPedido, nOpcX, lOk, cFilAtu, cID
	Local aArea   := GetArea()
	Local cTmp    := GetNextAlias()
	Local nConta  := 0
	Local cUsrAux := __cUserID
	
	BeginSQL Alias cTmp
		SELECT SF2.R_E_C_N_O_ AS F2_RECNO
		FROM %Table:SF2% SF2
		WHERE SF2.%NotDel%
		AND SF2.F2_FILIAL = %Exp:XFILIAL("SF2")%
		AND SF2.F2_EMISSAO >= %Exp:DtoS(mv_par01)%
		AND SF2.F2_EMISSAO <= %Exp:DtoS(mv_par02)%
		AND SF2.F2_DOC >= %Exp:mv_par03%
		AND SF2.F2_DOC <= %Exp:mv_par04%
		AND SF2.F2_SERIE >= %Exp:mv_par05%
		AND SF2.F2_SERIE <= %Exp:mv_par06%
		ORDER BY SF2.F2_FILIAL, SF2.F2_DOC, SF2.F2_SERIE
	EndSQL
	
	If (cTmp)->(Bof()) .And. (cTmp)->(Eof())
		FWAlertWarning("Não existem documentos fiscais para o período informado !")
	Else
		ProcRegua( (cTmp)->(RecCount()) )
		While !(cTmp)->(Eof())
			
			IncProc()
			
			SF2->(dbSetOrder(1))
			SF2->(dbGoTo((cTmp)->F2_RECNO))    // Posiciona no registro
			
			SD2->(dbSetOrder(3))
			SD2->(dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE))
			
			dDataBase := SF2->F2_EMISSAO   // Atualiza com a data da baixa
			//cFilAnt   := SF2->F2_FILIAL
			cNumNF    := SF2->F2_DOC
			cSerNF    := SF2->F2_SERIE

			//FWSM0Util():setSM0PositionBycFilAnt()    // Posiciona no registro da tabela de empresas (SM0)
			
			lMsErroAuto := .F.
			lMSHelpAuto := .T.
			
			If SD2->D2_ORIGLAN == "LO"
				ConfiguraUsuario("000046")   // Usuário CAIXA
				
				SL1->(dbSetOrder(2))    // L1_FILIAL+L1_SERIE+L1_DOC+L1_PDV
				If SL1->(dbSeek(SF2->F2_FILIAL+SF2->F2_SERIE+SF2->F2_DOC))
					cFilAtu := SL1->L1_FILIAL
					cID     := AllTrim(SL1->L1_XID)
					cTipTef := LjGetStation("LG_TIPTEF")			// Tipo do TEf
					nOpcX   := 2
					
					BeginTran()
					
					FWMsgRun(Nil, {|oSay| LJ140Exc( "SL1", SL1->(Recno()), nOpcX, , .T., SL1->L1_FILIAL, SL1->L1_NUM ) }, "Integração com o CONTROL", "Excluindo Documento "+cNumNF+" / "+cSerNF+"...")
					
					If !lMsErroAuto
						FWMsgRun(Nil, {|oSay| LJ140Exc( "SL1", SL1->(Recno()), nOpcX, , .T., SL1->L1_FILIAL, SL1->L1_NUM ) }, "Integração com o CONTROL", "Excluindo Orçamento "+SL1->L1_FILIAL+" / "+SL1->L1_NUM+"...")
					Endif
					
					If lMsErroAuto
						DisarmTransaction()
					Else
						If !Empty(cID)   // Caso tenha ID
							If Len(cID) < 20
								SZ6->(dbSetOrder(1))    // Z6_FILIAL+Z6_NUM
								If SZ6->(dbSeek(cFilAtu+cID))
									RecLock("SZ6",.F.)
									SZ6->Z6_STATUS := "1"    // Grava como pendente
									MsUnLock()
								Endif
							Else
								SZ4->(dbSetOrder(1))    // Z4_FILIAL+Z4_ID
								If SZ4->(dbSeek(cFilAtu+cID))
									RecLock("SZ4",.F.)
									SZ4->Z4_STATUS := "1"    // Grava como pendente
									MsUnLock()
								Endif
							Endif
						Endif
						
						EndTran()
					Endif
				Endif
			Else
				ConfiguraUsuario("000000")   // Usuário ADMIN
				
				aRegSD2 := {}
				aRegSE1 := {}
				aRegSE2 := {}
				cPedido := SD2->D2_FILIAL+SD2->D2_PEDIDO
				
				BeginTran()
				
				dbSelectArea("SE1")
				dbSetOrder(1)
				dbSeek(XFILIAL("SE1")+SF2->F2_SERIE+SF2->F2_DOC,.T.)
				While !lMsErroAuto .And. !Eof() .And. XFILIAL("SE1")+SF2->F2_SERIE+SF2->F2_DOC == E1_FILIAL+E1_PREFIXO+E1_NUM
					
					If Trim(SE1->E1_TIPO) == "R$" .And. !Empty(SE1->E1_BAIXA)    // Processa a baixa automática
						CancBaixaSE1()
					Endif
					
					RecLock("SE1",.F.)
					SE1->E1_CLIENTE := SF2->F2_CLIENTE
					SE1->E1_LOJA	:= SF2->F2_LOJA
					SE1->E1_TIPO 	:= "NF "   // Volta o tipo normal da NF
					MsUnLock()
					
					SE1->(dbSkip())
				Enddo
				
				// Efetua o processamento da atualização dos cadastros
				If lOk := !lMsErroAuto .And. MaCanDelF2("SF2",SF2->(RecNo()),@aRegSD2,@aRegSE1,@aRegSE2,,.T.,.T.)
					FWMsgRun(Nil, {|oSay| MaDelNFS(aRegSD2, aRegSE1, aRegSE2, .F., .F., .T., .F.) }, "Integração com o CONTROL", "Excluindo Documento "+cNumNF+" / "+cSerNF+"...")
					
					SF2->(dbSetOrder(1))
					If lOk := !SF2->(dbSeek(XFILIAL("SF2")+cNumNF+cSerNF))
						CancelaPedido(cPedido)
						lOk := !lMsErroAuto
					Else
						cError := "Nao foi possivel excluir o Documento Fiscal: " + SF2->F2_DOC + " / " + SF2->F2_sERIE
					Endif
				EndIf
				
				If lOk
					EndTran()
				Else
					DisarmTransaction()
				Endif
			Endif
			
			If lMsErroAuto
				MostraErro()
				
				If !FWAlertYesNo("Continua o processo de exclusão dos documentos fiscais ?")
					Exit
				Endif
			Else
				nConta++
			Endif
			
			(cTmp)->(dbSkip())
		Enddo
		
		ConfiguraUsuario(cUsrAux)   // Usuário LOGADO
		
		If nConta > 0
			FWAlertSuccess("Foram excluídas "+LTrim(cValToChar(nConta))+" notas com sucesso !")
		Endif
	Endif
	(cTmp)->(dbCloseArea())
	RestArea(aArea)
 
Return

Static Function CancelaPedido(cNumPed)
	Local aArrSC5 := {}
	Local aArrSC6 := {}
	
	// Apaga os dados do pedido de venda gerados pelo Loja
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek(cNumPed)
		aArrSC5 := {{ "C5_FILIAL"  , SC5->C5_FILIAL  , Nil}, ;
					{ "C5_NUM"     , SC5->C5_NUM     , Nil}, ;
					{ "C5_TIPO"    , SC5->C5_TIPO    , Nil}, ;
					{ "C5_CLIENTE" , SC5->C5_CLIENTE , Nil}, ;
					{ "C5_LOJACLI" , SC5->C5_LOJACLI , Nil}, ;
					{ "C5_LOJAENT" , SC5->C5_LOJAENT , Nil}, ;
					{ "C5_EMISSAO" , SC5->C5_EMISSAO , Nil}, ;
					{ "C5_CONDPAG" , SC5->C5_CONDPAG , Nil}, ;
					{ "C5_MOEDA"   , SC5->C5_MOEDA   , Nil}, ;
					{ "C5_TIPOCLI" , SC5->C5_TIPOCLI , Nil}, ;
					{ "C5_VEND1"   , SC5->C5_VEND1   , Nil}}
		
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(SC5->(C5_FILIAL+C5_NUM),.T.)
		While !Eof() .And. SC5->(C5_FILIAL+C5_NUM) == C6_FILIAL+C6_NUM
			
			aAdd(aArrSC6, { { "C6_FILIAL"  , SC6->C6_FILIAL      , Nil},;
							{ "C6_NUM"     , SC6->C6_NUM         , Nil},;
							{ "C6_ITEM"    , SC6->C6_ITEM        , Nil},;
							{ "C6_PRODUTO" , SC6->C6_PRODUTO     , Nil},;
							{ "C6_QTDVEN"  , SC6->C6_QTDVEN      , Nil},;
							{ "C6_PRUNIT"  , SC6->C6_PRUNIT      , Nil},;
							{ "C6_PRCVEN"  , SC6->C6_PRCVEN      , Nil},;
							{ "C6_VALOR"   , SC6->C6_VALOR       , Nil},;
							{ "C6_ENTREG"  , SC6->C6_ENTREG      , Nil},;
							{ "C6_UM"      , SC6->C6_UM          , Nil},;
							{ "C6_TES"     , SC6->C6_TES         , Nil},;
							{ "C6_CF"      , SC6->C6_CF          , Nil},;
							{ "C6_LOCAL"   , SC6->C6_LOCAL       , Nil},;
							{ "C6_CLI"     , SC6->C6_CLI         , Nil},;
							{ "C6_LOJA"    , SC6->C6_LOJA        , Nil},;
							{ "C6_QTDLIB"  , 0                   , Nil}})
			
			dbSkip()
		Enddo
		
		MSExecAuto({|x,y,Z| Mata410(x,y,Z)}, aArrSC5, aArrSC6, 4)   // Altera o pedido de venda
		
		If !lMsErroAuto
			MSExecAuto({|x,y,Z| Mata410(x,y,Z)}, aArrSC5, aArrSC6, 5)   // Exclui o pedido de venda
		Endif
	Endif
	
Return

// Baixa AUTOMATICA do Contas a Receber quando for DINHEIRO
Static Function CancBaixaSE1()
	Local nX, cSeekSE5, aVet
	Local aArea   := SE1->(GetArea())
	Local cFilAux := cFilAnt
	Local dDatAux := dDataBase
	
	Private aBaixaSE5 := {}
	
	// Pesquisa o registro das baixas para o título
	Sel070Baixa( "VL /V2 /BA /RA /CP /LJ /"+MV_CRNEG,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,,,SE1->E1_CLIENTE,SE1->E1_LOJA,,,,)
	
	For nX:=1 To Len(aBaixaSE5)
		cSeekSE5 := SE5->(XFILIAL("SE5"))+aBaixaSE5[nX,25]+aBaixaSE5[nX,1]+PADR(aBaixaSE5[nX,2],Len(SE5->E5_NUMERO))+aBaixaSE5[nX,3]+aBaixaSE5[nX,4]+DtoS(aBaixaSE5[nX,7])+aBaixaSE5[nX,5]+aBaixaSE5[nX,6]+aBaixaSE5[nX,9]
		
		SE5->(dbSetOrder(2))    // E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DTOS(E5_DATA)+E5_CLIFOR+E5_LOJA+E5_SEQ
		If SE5->(dbSeek(cSeekSE5))
			cFilAnt   := SE1->E1_FILIAL  // Posiciona na filial do título
			dDataBase := SE5->E5_DATA
			aVet      := {}
			
			aAdd( aVet, { "E1_PREFIXO"   , SE1->E1_PREFIXO  , Nil } )
			aAdd( aVet, { "E1_NUM"       , SE1->E1_NUM      , Nil } )
			aAdd( aVet, { "E1_PARCELA"   , SE1->E1_PARCELA  , Nil } )
			aAdd( aVet, { "E1_TIPO"      , SE1->E1_TIPO     , Nil } )
			aAdd( aVet, { "E1_CLIENTE"   , SE1->E1_CLIENTE  , Nil } )
			aAdd( aVet, { "E1_LOJA"      , SE1->E1_LOJA     , Nil } )
			aAdd( aVet, { "AUTMOTBX"     , SE5->E5_MOTBX    , Nil } )
			aAdd( aVet, { "AUTJUROS"     , 0                , Nil,.T.} )
			aAdd( aVet, { "AUTMULTA"     , 0                , Nil,.T.} )
			aAdd( aVet, { "AUTDESCONT"   , 0                , Nil } )
			aAdd( aVet, { "AUTBANCO"     , SE5->E5_BANCO    , Nil } )
			aAdd( aVet, { "AUTAGENCIA"   , SE5->E5_AGENCIA  , Nil } )
			aAdd( aVet, { "AUTCONTA"     , SE5->E5_CONTA    , Nil } )
			aAdd( aVet, { "AUTDTBAIXA"   , dDataBase        , Nil } )
			aAdd( aVet, { "AUTDTCREDITO" , dDataBase        , Nil } )
			aAdd( aVet, { "AUT_HIST"     , "RECEBIMENTO A VISTA" , Nil} )
			aAdd( aVet, { "AUTVALREC"    , SE5->E5_VALOR    , Nil } )
				
			MsExecAuto({|x,y| FINA070(x,y) } , aVet, 5)
			
			cFilAnt   := cFilAux  // Restaura a filial do título
			dDataBase := dDatAux  // Restaura a data-base do sistema
			
			If lMsErroAuto
				AutoGrLog( "Data.........: " + DtoC(Date()) )
				AutoGrLog( "Hora.........: " + Time() )
				AutoGrLog( "Aonde........: Baixa CR " )
				AutoGrLog( "Ordem........: " + SE1->E1_NUM + SE1->E1_PREFIXO + SE1->E1_PARCELA)
				
				Exit
			Endif
		Endif
	Next
	
	SE1->(RestArea(aArea))

Return !lMsErroAuto

Static Function ConfiguraUsuario(cID)
	
	If __cUserID <> cID
		__cUserID := cID    // Define usuário apto a incluir pedido de compras
		
		PswOrder(1)           // (1) Codigo , (2) Nome
		If PswSeek(__cUserID) // Pesquisa usuário
			cUserName := PswRet(1)[1][2]    // Retorna codigo do usuário [1] ou o Nome [2]
		Endif
	Endif
	
Return

Static Function ValidPerg(cPerg)
	Local nTam := TamSX3("F2_DOC")[1]
	
	u_MGPutSx1(cPerg,"01",PADR("Da Emissao     " ,29)+"?","","","mv_ch1","D",   8,0,0,"G","","   ","","","mv_par01")
	u_MGPutSx1(cPerg,"02",PADR("Ate a Emissao  " ,29)+"?","","","mv_ch2","D",   8,0,0,"G","","   ","","","mv_par02")
	u_MGPutSx1(cPerg,"03",PADR("Do Documento   " ,29)+"?","","","mv_ch3","C",nTam,0,0,"G","","   ","","","mv_par03")
	u_MGPutSx1(cPerg,"04",PADR("Ate o Documento" ,29)+"?","","","mv_ch4","C",nTam,0,0,"G","","   ","","","mv_par04")
	u_MGPutSx1(cPerg,"05",PADR("Da Serie       " ,29)+"?","","","mv_ch5","C",   3,0,0,"G","","   ","","","mv_par05")
	u_MGPutSx1(cPerg,"06",PADR("Ate a Serie    " ,29)+"?","","","mv_ch6","C",   3,0,0,"G","","   ","","","mv_par06")
	
Return
