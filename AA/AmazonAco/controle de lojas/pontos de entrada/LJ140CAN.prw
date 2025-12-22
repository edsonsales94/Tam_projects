#Include "rwmake.ch"
#include 'totvs.ch'
#include 'protheus.ch'

/*---------------------------------------------------------------------------------------------------------------------------------------------------
Ponto de entrada executado antes da exclusão da Nota Fiscal / Cupom Fiscal
OBJETIVO 1: Permitir ou não a exclusão da Nota Fiscal / Cupom Fiscal por usuário
OBJETIVO 2: Analisar se a venda possui Romaneio de Entrega
OBJETIVO 3: Analisar se a venda possui um PV para transferência entre Lojas
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/
User Function LJ140CAN()
	Local nIndSA6 := SA6->(IndexOrd())
	Local nRecSA6 := SA6->(RecNo())
	Local lRet    := .T.
	Local aSF3    := SF3->(getArea())
	PRIVATE  _cMotivo :=""
  	
	// INCLUIDO POR DIEGO - GRAVA MOTIVO DO CANCELAMENTO - 28/06/2018
	// Descomentar aqui embaixo quando Criar os Campos no SF3 
	
	
	_cMotivo := infmotivo()

	//DbSelectArea("SF3")
	//nIndSF3 := IndexOrd()
	//nRecSF3 := RecNo()	
	SF3->(DbSetOrder(5)) // Código do Usuário
	SF3->(dbGoTop())
	ConOut('Procurando Livro Fiscal')    
	If SF3->(DbSeek(xFilial("SF3")+SL1->(L1_SERIE+L1_DOC+L1_CLIENTE+L1_LOJA)))
	   ConOut('Achei Livro Fiscal')
	   ConOut('Varrendo todos os Itens SF3')	
		Do While !SF3->(Eof()) .And. SL1->(L1_FILIAL+L1_SERIE+L1_DOC+L1_CLIENTE+L1_LOJA) == SF3->(F3_FILIAL+F3_SERIE+F3_NFISCAL+F3_CLIEFOR+F3_LOJA)
		    ConOut('Alterando os Itens')
			Begin Transaction
			SF3->(RecLock("SF3",.F.))
			
			If SF3->(FieldPos("F3_XOPERA")) > 0
			   ConOut('Salvando Operador') 
			   SF3->F3_XOPERA	:= SL1->L1_OPERADO
			EndIf''
			If SF3->(FieldPos("F3_XFORPG")) > 0
			   ConOut('Salvando Forma Pagamento') 
			   SF3->F3_XFORPG	:= SL1->L1_FORMPG
			EndIf
			If SF3->(FieldPos("F3_XMOTIVO")) > 0
			   ConOut('Salvando Motivo Cancelamento')
			   SF3->F3_XMOTIVO	:= _cMotivo 
			   Alert (_cMotivo)
			Endif
			
			SF3->(MsUnLock())
			End Transaction
			
			SF3->(DbSkip())
			
		EndDo
		
	EndIf
    

	SF3->(RestArea(aSF3))

	SA6->(DbSetOrder(4)) // Código do Usuário
	If SA6->(DbSeek(xFilial("SA6")+__cUserID))  // Usuário do Sistema
		If Empty(SL1->L1_NUMCFIS) 				// Nota Fiscal
			If ! SA6->A6_EXCLNF $ "F#A"  			// Verifica se o usuário pode excluir Nota Fiscal - F=Nota Fiscal; A=Ambos
				MsgAlert("Usuário sem permissão para excluir NOTA FISCAL !!!", "ATENÇÃO")
				lRet := .F.
			EndIf
		Else  // Cupom Fiscal
			If ! SA6->A6_EXCLNF $ "C#A"			// Verifica se o usuário pode excluir Cupom Fiscal - C=Cupom Fiscal; A=Ambos
				MsgAlert("Usuário sem permissão para excluir CUPOM FISCAL !!!", "ATENÇÃO")
				lRet := .F.
			EndIf
		EndIf
	EndIf
	
	SA6->(DbSetOrder(nIndSA6))
	SA6->(DbGoTo(nRecSA6))
	
	If lRet .And. !Empty(SL1->L1_PEDRES)   // Número do pedido de venda referente a Transferência entre almoxarifados
		lRet := ExcPedido()                 // Verifica se o Orçamento está vinculado a um PV devido a transferência
	Endif
	
	// Se estiver excluindo uma venda com reserva e a data da venda for diferente da data-base
	If lRet .And. !Empty(SL1->L1_DOCPED) .And. SL1->L1_EMISNF <> dDataBase
		// Pesquisa as parcelas da venda
		SL4->(dbSetOrder(1))
		SL4->(dbSeek(SL1->(L1_FILIAL+L1_NUM),.T.))
		While !SL4->(Eof()) .And. SL1->(L1_FILIAL+L1_NUM) == SL4->(L4_FILIAL+L4_NUM)
			If !(Trim(SL4->L4_FORMA) $ GetMV("MV_XFORMLJ"))
				lRet := .F.
				MsgAlert("Não é permitida a exclusão dessa venda, Para ressarcimento do cliente favor entrar em contato com o Financeiro!", "ATENÇÃO")
				Exit
			Endif
			SL4->(dbSkip())
		Enddo
	Endif
	If lRet
		If !Empty(SL1->L1_DOCPED)
			cNota 	:= SL1->L1_DOCPED
			cSerie 	:= SL1->L1_SERPED
		Else
			cNota	:= SL1->L1_DOC
			cSerie	:= SL1->L1_SERIE

			lRet := ExcRomaneio(cNota,cSerie)
		EndIf

		If !Empty(cNota) .And. !Empty(cSerie) .And. lRet
			u_FWorkCanc(cNota,SL1->L1_CLIENTE, SL1->L1_VLRTOT,cSerie,SL1->L1_NUM,SL1->L1_LOJA,SL1->L1_FORMPG)
		EndIf 
	EndIf
	
Return lRet

static Function ExcRomaneio(_xdDoc,_xdSer)
    lRetorno = .F.

	SZE->(dbSetOrder(4))
	If SZE->(dbSeek(XFILIAL("SZE") + _xdDoc + _xdSer ) )
		// Não processa para série 6		
		If lRet := fTabTmp(_xdDoc,_xdSer)
			If Empty(SZE->ZE_ROMAN)
				RecLock("SZE", .F.)
					u_AALOGE01(SZE->ZE_ROMAN,SZE->ZE_DOC,SZE->ZE_SERIE, "Exclusão dos Registros")
					dbDelete()
				MsUnLock()
				lRetorno  = .T.
			EndIf 
		//ElseIf lRet := ("05477207" $ SA1->A1_CGC)  // Não exibe mensagem se o cliente for AMAZON AÇO (transferência)
		
		Else
			MsgStop("Esta nota não pode ser excluída, pois encontra-se em romaneio!")
		EndIf		
	EndIf 

Return lRetorno

Static Function fTabTmp(_xdDoc,_xdSer)
	Local cAlias := Alias()
	Local cQry   := ""
	Local nRecno := 0
	
	cQry := "SELECT ISNULL(R_E_C_N_O_,0) AS ZE_RECNO "
	cQry += " FROM "+RetSQLName("SZE")+" A "
	cQry += " WHERE A.D_E_L_E_T_ = ' '"
	cQry += " AND ZE_FILIAL = '" + xFilial("SZE") + "' "
	cQry += " AND ( ZE_ROMAN  = ' ' "
	cQry += " OR    ZE_STATUS IN  ( 'D', 'S' ) ) "

	cQry += " AND ZE_DOC    = '"+ _xdDoc +"' "
	cQry += " AND ZE_SERIE  = '"+ _xdSer  +"' "
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

Static Function ExcPedido()
	Local lRetPV  := .T.
	
	SC5->(DbSetOrder(5)) // Filial+Orçamento Loja
	If SC5->(DbSeek(SL1->L1_ENTBRAS+SL1->L1_NUM))
		If !Empty(SC5->C5_NOTA)   // Há Nota Fiscal Gerada para  PV
			Aviso("Alerta","Há um Pedido de Venda para transferência com Nota Fiscal "+SC5->C5_NOTA+"/"+SC5->C5_SERIE+" !!!",{"OK"},2)
			lRetPV := .F.
		EndIf
	EndIf
	
Return lRetPV

//PERMITE A DIGITAÇÃO DO MOTIVO DO CANCELAMENTO
Static Function infMotivo()

	Local cMotivo := Space(TamSX3("F3_XMOTIVO")[01])
    
	Define Font oFnt3 Name "Ms Sans Serif" Bold

	Define Msdialog oDialog Title "Motivo do Cancelamento" From 190,110 to 250,370 Pixel// STYLE nOR(WS_VISIBLE,WS_POPUP)
             
	@ 005,004 Say "Motivo:" Size 220,10 Of oDialog Pixel Font oFnt3
	@ 005,050 Get cMotivo   Picture "@!"   Size 200,10  Pixel of oDialog Valid !Empty(cMotivo)

	@ 020,042 BmpButton Type 1 Action ( iIF(!Empty(cMotivo),oDialog:End(),Nil) )

	Activate Dialog oDialog Centered
    
Return _cMotivo
