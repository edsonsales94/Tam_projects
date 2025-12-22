#Include "rwmake.ch"
#include "Protheus.ch"

/*/
---------------------------------------------------------------------------------------------------------------------------------------------------
Ponto Entrada executado após a gravação da Venda Assistida
OBJETIVO 1: Chamada da função de impressão do Orçamento
OBJETIVO 2: Gravar a Taxa de Permanência e/ou Taxa de Juros
OBJETIVO 3: Emitir a Nota Fiscal para Cupom
OBJETIVO 4: Emitir o Recibo PILOTO
OBJETIVO 5: Baixar no automaticamente Contas a Receber os Tipos - CD, CR e DV
OBJETIVO 6: Eliminar o novo Orçamento gerado pela reserva  - F O R A   D E  U S O
OBJETIVO 7: Gravar o número do Orçamento no Contas a receber
OBJETIVO 8: Calcular o Desconto para clientes PRODUTORES RURAIS
OBJETIVO 9: Realizar a Mov. Interna entre Almoxarifados devido a Transferência entre Loja e gerar o Pedido de Venda - PV
-----------------------------------------------------------------------------------------------------------------------------------------------------
/*/
User Function LJ7002()

Local cMensagem :=""
Local nCount    := 0

	If FunName() == 'RPC'
		Return Nil 
	EndIf
	nIndSL1 := SL1->(IndexOrd())	
	
	If FieldPos("L1_XRESERV") > 0
		If SL1->L1_XRESERV =="03"
			cMensagem:="IND.-SILVES"
		ElseIf SL1->L1_XRESERV =="04"
			cMensagem:="IND.-ALVORADA"
		ElseIf SL1->L1_XRESERV =="07"
			cMensagem:="IND.-SUCATA"
		EndIf
	EndIf

	conout("Vai tentar posicionar no orçamento para escrever o nome do Cliente!")
	SL1->(dbSetOrder(1))
	If SL1->(dbSeek(xFilial("SL1")+M->LQ_NUM))
		//Alterado por Williams Messa - 15/01/2021
		//SL1->(RecLock("SL1",.F.))
		RecLock("SL1",.F.)
			SL1->L1_NOMCLI  := Posicione("SA1",1,xFilial('SA1') + SL1->L1_CLIENTE + SL1->L1_LOJA,"A1_NOME" )
			SL1->L1_EMISSAO := dDataBase
		If SL1->L1_JUROS > 0 .AND. paramIxb[1] == 1
		    //ALERT("AJUSTANDO")
			SL1->L1_JUROS   := round((SL1->L1_XJUROS ) / (SL1->L1_VALMERC - SL1->L1_DESCONT), 8) * 100
		    SL1->L1_VLRJUR  := (SL1->L1_XJUROS ) //(SL1->L1_VLRTOT) *  (SL1->L1_JUROS / 100) 
			SL1->L1_VLRLIQ  := (SL1->L1_VALMERC ) + SL1->L1_VLRJUR - SL1->L1_DESCONT
			SL1->L1_VALBRUT := (SL1->L1_VALMERC ) + SL1->L1_VLRJUR - SL1->L1_DESCONT
		EndIf 
		//SL1->(MsUnlock())
		MsUnlock()
	EndIf
	//                  //  .------------------------.
	If paramIxb[1] == 1 // |     Orçamento - <F4>     |
		//              //  '------------------------'
		SA1->(DbSeek(xFilial("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA))
		If SA1->A1_TIPO == "L" .And. SubStr(SLF->LF_ACESSO,3,1) == "N"
			u_AtDescItm() // Calcula o Percentual de Desconto no Item quando o cliente for Produtor Rural e NAO for CAIXA - FUNCOES GENERICAS.PRW
		EndIf

		_cArea := GetArea()
		//   .---------------------------------------------------------.
		//  |     Verifica se o pedido é para entrega em outra loja     |
		//   '---------------------------------------------------------'
		If (SL2->L2_ENTBRAS <> SM0->M0_CODFIL) .and. !Empty(SL2->L2_ENTBRAS)
			RecLock("SL1",.F.)
			SL1->L1_RESERVA := "S"
			MsUnLock()

			dbSelectArea("SL2")
			dbSetOrder(1)
			dbSeek(xFilial()+SL2->L2_NUM)

			While !Eof() .and. L2_FILIAL + L2_NUM == SL1->L1_FILIAL + SL1->L1_NUM
				RecLock("SL2",.F.)
				SL2->L2_LOJARES := Posicione("SLJ", 3, xFilial("SLJ")+SM0->M0_CODIGO+SL2->L2_ENTBRAS, "LJ_CODIGO")
				SL2->L2_ENTREGA := "3"
				SL2->L2_RESERVA := "000000"
				SL2->L2_FILRES  := SL2->L2_ENTBRAS
				dbSkip()
			End

		EndIf
		//Alteração
		//If Len(PARAMIXB) = 1
			if Aviso('Atencao','Deseja imprimir orçamento?',{'Sim','Nao'},2) == 01
				u_ORCBRAS(SL1->L1_NUM)
			EndIf	
		//EndIf

		conout('TESTANDO : ' + SL1->L1_XBLQORC)
		if !EMPTY(SL1->L1_XBLQORC)
			aBloqueio := {}
			conout('salvando')
			aAdd(aBloqueio,{"Z3_FILIAL",SL1->L1_FILIAL})
			aAdd(aBloqueio,{"Z3_VENDA",SL1->L1_NUM})
			aAdd(aBloqueio,{"Z3_TIPO","1"})
			aAdd(aBloqueio,{"Z3_CLIENTE",SL1->L1_CLIENTE})
			aAdd(aBloqueio,{"Z3_LOJA",SL1->L1_LOJA })
			aAdd(aBloqueio,{"Z3_TIPOCLI",SL1->L1_TIPOCLI})
			aAdd(aBloqueio,{"Z3_VEND",SL1->L1_VEND})
			aAdd(aBloqueio,{"Z3_EMISSAO",SL1->L1_EMISSAO})
			aAdd(aBloqueio,{"Z3_ENDENT",SL1->L1_ENDENT})
			aAdd(aBloqueio,{"Z3_BAIRROE",SL1->L1_BAIRROE})
			aAdd(aBloqueio,{"Z3_MUNE",SL1->L1_MUNE})
			aAdd(aBloqueio,{"Z3_ESTE",SL1->L1_ESTE})
			aAdd(aBloqueio,{"Z3_DESCONT",SL1->L1_DESCONT})
			aAdd(aBloqueio,{"Z3_PESOL",SL1->L1_PLIQUI})
			aAdd(aBloqueio,{"Z3_PESOB",SL1->L1_PBRUTO})
			aAdd(aBloqueio,{"Z3_FONEENT",SL1->L1_FONEENT})
			aAdd(aBloqueio,{"Z3_OBS1",SL1->L1_OBSENT1})
			aAdd(aBloqueio,{"Z3_OBS2",SL1->L1_OBSENT2})
			aAdd(aBloqueio,{"Z3_BLOQUEI",SL1->L1_XBLQORC})
			aAdd(aBloqueio,{"Z3_NOMCLI",Posicione('SA1',1,xFilial("SA1") +SL1->(L1_CLIENTE  + L1_LOJA),"A1_NOME") })

			If ExistBlock("AALJ05GRV")
				u_AALJ05GRV(aBloqueio)
			else
				conout('nao foi ')
			EndIf

		EndIf
		//U_AALOJE04()
		RestArea(_cArea)
		//                   //  .--------------------.
	ElseIf paramIxb[1] == 2 // |     Venda - <F5>     |
		//                   //  '--------------------'
		Conout("*********************************************************RECIBO DO ORCAMENTO:"+SL1->L1_NUM)
		nRecSL1 := SL1->(RecNo())
		//
		//If Len(PARAMIXB) = 1 //VERIFICA SEGUNDA PASSAGEM DO PE. WILLIAMS MESSA

			If SL1->L1_ENTBRAS == SubStr(cNumEmp,3,2) // Imprime o Controle de Entrega se o orçamento for da própria LOJA
				If GetMV("MV_ENTLJ") == "S"           // Parâmetro que define se será impresso a Lista de Separação
					u_REntLJ()                        // somente quando é da mesma loja
				EndIf
			EndIf
			//Imprimindo Chapa Cortada
			//u_AALOJR11(.T.,"LPT4","",SL1->L1_NUM,SL1->L1_NUM,SL1->L1_FILIAL,,"00;01;02",01)
			If Aviso('Atencao','Deseja imprimir Lista de separacão ? ',{'Sim','Nao'},2) == 01
				u_Orcamen(,.T.,.F.)
				//u_Orcamen(,.F., .F.)			
				//u_AALOJR11(.T.,"LPT3","",SL1->L1_NUM,SL1->L1_NUM,SL1->L1_FILIAL,,"",)
			EndIf

			If MsgYesNo(" Deseja emitir Recibo? - VENDA")
				Conout("***************************************************RECIBO DO ORCAMENTO:"+SL1->L1_NUM)
				u_AARECIBO(SL1->L1_NUM,2)                         // Recibo Customizado
			EndIf

			If ! Empty(SL1->L1_NUMCFIS) // Se for a impressão de Cupom Fiscal
				u_REC_ENT() // Imprime o Recibo de Entrega no ECF
				If MsgYesNo(" Deseja emitir Nota Fiscal para Cupom ? ")
					LOJR130()                                           // Nota Fiscal para Cupom
				EndIf
			EndIf

			If cEmpAnt$"05#06" /*.Or. cEmpAnt=="01"*/ //apenas empresa 05 que ira ter na 
				AddEntrega("V")// Função que adiciona a venda no Controle de Entrega - Geração de Romaneio
			Endif
			Conout("2...")
			If FindFunction("u_AAFATE14")
  		 		u_AAFATE14(SL1->L1_SERIE,SL1->L1_DOC)
			EndIf 
		//EndIf
		//Checa se o Titulo Gerado e do TIPO BOLETO para enviar via email
	    SL1->(dbSetOrder(nIndSL1))
		SL1->(DbGoto(nRecSL1))

	ElseIf ParamIxb[1] == 3                      // Comprovante de Venda <F5>
		Conout("*********************************************************RECIBO DO ORCAMENTO"+SL1->L1_NUM)
		nCount++
		nRecSL1 := SL1->(RecNo())
		Conout(nCount)

		SL1->(dbGoto(nRecSL1))
		//16/08/19 - Verificação do fonte, OK! Impressão do Recibo - Williams Messa
		//If Len(PARAMIXB) = 1 //VERIFICA SEGUNDA PASSAGEM DO PE.
			If MsgYesNo(" Deseja emitir Recibo? - COMPROVANTE VENDA ")
				Conout("*********************************************************RECIBO DO ORCAMENTO"+SL1->L1_NUM)
				u_AARECIBO(SL1->L1_NUM,2)                         // Recibo Customizado
				Conout("3...")
			EndIf
		//EndIf
		lChapa := .F.
		lOutros := .F.

		Conout(Posicione("SB1",1,xFilial("SB1")+SL2->L2_PRODUTO,"B1_GRUPO"))
	    //Verifica se tem cchapa ou outros produtos.
		If fTabTmp(01)
			Conout("Tem Chapa")
			lChapa := .T.
		EndIf
		If 	fTabTmp(02)
			Conout("Não Tem Chapa")
			lOutros := .T.
		EndIf	

		If SL1->L1_ENTREGA == "S"
			
			_cFormDel := SuperGetMv("MV_XFORMLJ",.F.,"BO")
			lDeleta := .F.
			SL4->(dbSetOrder(1))
			SL4->(dbSeek(SL1->L1_FILIAL + SL1->L1_NUM) )
			_cdForma := SL4->L4_FORMA
			SL4->( DBEVAL({|| lDeleta := iIf( !(Alltrim(SL4->L4_FORMA) $ _cFormDel),.T.,lDeleta) },  {||SL4->(L4_FILIAL + L4_NUM) = SL1->L1_FILRES + SL1->L1_ORCRES}, {||SL4->(L4_FILIAL + L4_NUM) = SL1->L1_FILRES + SL1->L1_ORCRES}, , , ))

			If _cdForma $ _cFormDel .And. M->LQ_ENTREGA = 'S'
				aEval(aPgtos,{|x| lDeleta := iIF( (Alltrim(x[03]) $ _cFormDel) ,.T.,lDeleta) } ,2 )
				If lDeleta
					Aviso('Atencao',' Formas de Pagamentos Divergentes na Venda',{'OK'},1)
					lRet := .F.
				EndIf
			EndIf

		Endif
		//K4HVDQ9TJ96CRX9C9G68RQ2D3
		//Por Diego em 11/02/11
		if VReserva(SL1->L1_NUM)
			CONOUT('RESERVA')
			//if Aviso("Atencao","Deseja Enviar Lista de separação para Industria - "+ cMensagem + " 2 ?",{"Sim","Nao"}) == 01
				If ExistBlock("AALOJR11")
					If lOutros
						//Alert("Outros Produtos - lista de separação 01")
						If Aviso("Atencao","Deseja imprimir a lista de separação para entrega ao CLIENTE ?",{"Sim","Nao"}) == 01
							u_AALOJR11(.F.,"","",SL1->L1_NUM,SL1->L1_NUM,SL1->L1_FILIAL,,"",02)
						Endif
						
						//Alert("Outros Produtos - lista de separação 02")
						If Aviso("Atencao","Deseja imprimir a lista de separação para o FATURAMENTO ?",{"Sim","Nao"}) == 01
							u_AALOJR11(.F.,"","",SL1->L1_NUM,SL1->L1_NUM,SL1->L1_FILIAL,,"",02)
						Endif

					EndIf
					//u_AALOJR02(.T.,"LPT3","",SL1->L1_NUM)			  
					//Imprimindo Tudo Menos Chapa Cortada
					/* impressão chapa cortada*/
					If lChapa
						//Alert("Chapa - lista de separação")
						If Aviso("Atencao","Deseja imprimir a lista de separação para corte na INDÚSTRIA ?",{"Sim","Nao"}) == 01
						    u_AALOJR11(.F.,"","",SL1->L1_NUM,SL1->L1_NUM,SL1->L1_FILIAL,,"00;01;02",01)
						Endif
					EndIf
				else
					Aviso("Atencao","Rotina 'AALOJR11' não Encontrada no Repositorio, Favor Entrar em contato com o Administrador do sistema",{"Ok"},2)
				EndIf
			//EndIf
			If ExistBlock("AAFKE01")
				_adArea := GetARea()
				CONOUT('FAKE CHAMANDO')
				//U_AAFKE01(SL1->L1_FILIAL,SL1->L1_NUM) //Situação Anterior. - 18/01/2021
				U_AAFKE01(SL1->L1_FILIAL,SL1->L1_NUM,SL1->L1_XRESERV)//Alteração Williams Messsa 17/12/2020 - Eliminar um caixa
				CONOUT('FAKE CHAMADO')
				RestArea(_adArea)
			EndIf

			_cFormDel := SuperGetMv("MV_XFORMLJ",.F.,"BO")
			lDeleta := .F.
			SL4->(dbSetORder(1))
			SL4->(dbSeek(SL1->L1_FILIAL + SL1->L1_NUM) )
			SL4->( DBEVAL({|| lDeleta := iIf( Alltrim(SL4->L4_FORMA) $ _cFormDel,.T.,.F.) },  {||SL4->(L4_FILIAL + L4_NUM) = SL1->L1_FILIAL + SL1->L1_NUM}, {||SL4->(L4_FILIAL + L4_NUM) = SL1->L1_FILIAL + SL1->L1_NUM}, , , ))
			If lDeleta .And. ExistBlock('AADELFIN')
				If !Empty(SL1->L1_DOCPED)
					u_AADELFIN(xFilial('SE1'),SL1->L1_SERPED,SL1->L1_DOCPED,iIf(SL1->L1_ENTREGA = 'S', SL1->L1_VEND,'') )
				else
					u_AADELFIN(xFilial('SE1'),SL1->L1_SERIE,SL1->L1_DOC    ,iIf(SL1->L1_ENTREGA = 'S', SL1->L1_VEND,'') )
				EndIf
			EndIf

			cTable := VReserva(SL1->L1_NUM,"2")
			SC5->(dbSetOrder(1))
			While !(cTable)->(EOF())
				If SC5->(dbSeek( (cTable)->(L1_FILIAL + L1_PEDRES)  ) )
					If ExistBlock("M410RLIB")
						ExecBlock("M410RLIB",.F.,.F.,{})
					EndIf
				EndIf
				(cTable)->(dbSkip())
			EndDo
		EndIF
	Endif
Return()
//  .----------------------------------------------------------------------------------------------------------------------------
// |     Função que adiciona a venda no Controle de Entrega - Geração de Romaneio - _cTipo: "V" - Venda; "R" - Venda com Reserva
//  '----------------------------------------------------------------------------------------------------------------------------
Static Function AddEntrega( _cTipo)
	//-------------------------------------------------------------------------------------------------------------------------------------------
	// Função que adiciona a venda no Controle de Entrega - Geração de Romaneio
	DbSelectArea("SZE")
	DbSetOrder(8)   // Orçamento

	lInclui := .T.
	nSeq    := 0

	nPLiqui := 0
	nPBruto := 0
	SL2->(dbGoTop())
	SL2->(dbSetOrder(1))    
	SL2->(dbSeek(xFilial('SL2') + SL1->L1_NUM))
	SB1->(dbSetORder(1))
	While !SL2->(EOf()) .And. SL2->L2_FILIAL == SL1->L1_FILIAL .And. SL2->L2_NUM == SL1->L1_NUM
		If SB1->(dbSeek(xFilial('SB1') + SL2->L2_PRODUTO))
			nPLiqui += SB1->B1_PESO * SL2->L2_QUANT
			nPBruto += SB1->B1_PESBRU * SL2->L2_QUANT
		EndIF
		SL2->(dbSkip())
	EndDo
	If SZE->(DbSeek(xFilial("SZE")+SL1->L1_NUM))

		Do While !SZE->(Eof()) .And. SL1->(L1_FILIAL+L1_NUM) == SZE->(ZE_FILIAL+ZE_ORCAMEN)

			If Empty(SZE->ZE_ROMAN) //.or. SZE->ZE_STATUS $ "E#N#F#D"
				lInclui := .F.
				MsgAlert("Orçamento já está relacionado no CONTROLE DE ENTREGA !!!","ATENÇÃO")
			Endif

			nSeq++
			SZE->(DbSkip())
		EndDo

	Endif

	If lInclui

		nSeq++

		Begin Transaction

			RecLock("SZE",.T.)
			SZE->ZE_FILIAL	:= xFilial("SZE")
			SZE->ZE_ORCAMEN := SL1->L1_NUM
			SZE->ZE_SEQ     := StrZero(nSeq,3)
			SZE->ZE_DOC 	:= Iif(!Empty(SL1->L1_DOC),SL1->L1_DOC  ,SL1->L1_DOCPED)
			SZE->ZE_SERIE	:= Iif(!Empty(SL1->L1_DOC),SL1->L1_SERIE,SL1->L1_SERPED)
			SZE->ZE_VALOR   := SL2->L2_VLRITEM
			SZE->ZE_DTVENDA := SL1->L1_EMISSAO
			SZE->ZE_VEND    := SL1->L1_VEND
			SZE->ZE_CLIENTE := SL1->L1_CLIENTE
			SZE->ZE_LOJACLI	:= SL1->L1_LOJA
			SZE->ZE_NOMCLI  := Posicione("SA1", 1, xFilial("SA1")+SL1->L1_CLIENTE + SL1->L1_LOJA, "A1_NOME")
			SZE->ZE_BAIRRO  := SL1->L1_BAIRROE
			SZE->ZE_PLIQUI  := nPLiqui
			SZE->ZE_Pbruto  := nPBruto
			SZE->ZE_ORIGEM  := "LOJA710"
			SZE->ZE_FILORIG := FwCodFil()
			If SZE->(FieldPos('ZE_EMPORIG')) > 0 .And. .T.
				SZE->ZE_EMPORIG := FwCodEmp()
			EndIf
			MsUnLock()
			u_AALOGE01(SZE->ZE_ROMAN,SZE->ZE_DOC,SZE->ZE_SERIE, "Inclusao dos Registros")
		End Transaction

	Endif

Return

Static Function VReserva(_cdOrcamento,_cdRet)

	Local cQry      := ""
	Local cTable    := GetNextALias()
	Local _ldReserv := .F.
	Local _adARea   := getArea()

	Default  _cdRet := "1"
	Default _cdOrcamento := ""

	cQry += " select L1.*,L2.*,BM_XEXIGOS from " + RetSqlName("SL2") + "  L2
	cQry += "   Left Outer Join " + RetSqlName("SL1") + " L1  on L1_ORCRES = L2_NUM and L1_FILRES = L2_FILIAL
	cQry += "   Left Outer Join " + RetSqlName("SL2") + " L2B on L2B.L2_NUM = L1.L1_NUM and L1.L1_FILIAL = L2B.L2_FILIAL and L2B.L2_PRODUTO = L2.L2_PRODUTO
	cQry += "   Left Outer Join (select * From " + RetSqlName("SB1") + "  where D_E_L_E_T_='') SB1 on SB1.B1_COD = L2B.L2_PRODUTO
	cQry += "   Left Outer Join (select * From " + RetSqlName("SBM") + "  where D_E_L_E_T_='') SBM on SBM.BM_GRUPO = SB1.B1_GRUPO
	cQry += " Where L2.D_E_L_E_T_ = '' and L1.D_E_L_E_T_ = '' And L2B.D_E_L_E_T_ = ''
	cQry += " And L2.L2_NUM = '" + _cdOrcamento +  "'
	cQry += " ORDER BY L2.L2_FILIAL,L2.L2_NUM,BM_XEXIGOS,L2_PRODUTO

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),cTable,.T.,.T.)


	if _cdRet = "1"
		_ldReserv := !(cTable)->(EOF())
		(cTable)->(dbCloseArea())
	elseif _cdRet = "2"
		_ldReserv := cTable
	EndIf
	RestArea(_adArea)

	Return _ldReserv


*----------------------------------------------------------------------------------------------*
Static Function fTabTmp(_xdOpc)
*----------------------------------------------------------------------------------------------*
// Função que soma a quantidade de produtos com Orcamentos em abertos e NAO vencidos

	Local cTable := GetNextAlias()
	Local cArea  := GetArea()
	Local cQry2  := ""
	Local lRet  := .F.

	cQry2 +=   " select L1.*,L2.*,BM_XEXIGOS from " + RetSqlName("SL2") + "  L2
	cQry2 +=   "   Left Outer Join " + RetSqlName("SL1") + " L1 on L1_NUM = L2_NUM and L1_FILIAL = L2_FILIAL and L1.D_E_L_E_T_ = '' "
	cQry2 +=   "   Left Outer Join " + RetSqlName("SL1") + " L1B on L1B.L1_NUM = L1.L1_ORCRES and L1.L1_FILRES = L1B.L1_FILIAL And L1B.D_E_L_E_T_ = ''
	cQry2 +=   "   Left Outer Join (Select * From " + RetSqlName("SB1") + " where D_E_L_E_T_='') SB1 on SB1.B1_COD = L2.L2_PRODUTO
	cQry2 +=   "   Left Outer Join (Select * From " + RetSqlName("SBM") + " where D_E_L_E_T_='') SBM on SBM.BM_GRUPO = SB1.B1_GRUPO
	cQry2 +=   " Where L2.D_E_L_E_T_ = '' "
	cQry2 +=   " And L1.L1_ORCRES BetWeen '" + SL1->L1_NUM + "' And '" + SL1->L1_NUM + "'
	cQry2 +=   " And L1.L1_FILRES = '" + SL1->L1_FILIAL + "'"

	If _xdOpc == 01
		cQry2 +=   " And ( B1_GRUPO IN ('23','24','25','26','27','28') "
	Elseif _xdOpc == 02
		cQry2 +=   " And Not ( B1_GRUPO IN ('23','24','25','26','27','28') "
	Else
		cQry2 += " And ( 01 = 01 "
	EndIf


	cQry2 +=   " ) "

	cQry2 +=   " Order By BM_XEXIGOS,L1.L1_FILIAL,L1.L1_PEDRES,L2.L2_NUM,L2_PRODUTO

	//aviso('',cqry2,{'Ok'},3)
	conout(cQry2)
	Memowrite('teste.SQL',cQry2)

	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry2)), cTable, .T., .F. )
	lRet := !(cTable)->(Eof())

Return lRet
