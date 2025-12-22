#include "RwMake.ch"
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT160WF   ºAutor  ³Diego Rafael        º Data ³  23/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE executado após a cofirmaçao da analise de Cotaçao e     º±±
±±º          ³ será usado para:                                           º±±
±±º          ³ * Executar a rotina INCOME05.prw para mostrta a tela para  º±±
±±º          ³   a digitação da Justificativa do fornecedor exclusivo     º±±
±±º          ³ * Executar a rotina INCOME04.prw para mostrar a tela para  º±±
±±º          ³   a gravação dos anexos                                    º±±
±±º          ³ * Executar a rotina INCOME02.prw                           º±±
±±º          ³   para mostrar a tela de Objetivo e Justificativa          º±±
±±º          ³ * Altera o grupo de aprovação do Pedido conforme o o grupo º±±
±±º          ³   de aprovação vinculado ao campos CTT_APROV do cadastro   º±±
±±º          ³   de Centro de Custo. Essa rotina regravará o grupo de     º±±
±±º          ³   aprovação.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COMPRA - Analise de Cotação                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT160WF(cCodigo)
	Local cNumCot   := SC8->C8_NUM
	Local aPedido   := fPedido(cNumCot)   // Retorna os pedidos da cotação
	Local cNumSC    := SC8->C8_NUMSC
	Local cJustific := ""
	Local cAlias    := ALIAS()
	Local lFornExcl := fForExc(cNumCot)   // Verifica se tem apenas 1 fornecedor na cotação
	Local x 
	// Posiciona na justificativa da solicitação de compras
	SZ6->(dbSetOrder(1))
	If SZ6->(dbSeek(xFilial("SZ6")+"2"+cNumSC))
		cJustific := SZ6->Z6_JUSTIFI
	EndIf
	
	For x := 1 to Len(aPedido)
		/*Mostra tela de Objetivo e Justificativa*/
		QOUT("1 - Pedido: "+aPedido[x]+" Incluindo Objetivo Justificativa")
		U_INCOME02("Justificativa da Compra","1","",aPedido[x],"","","",.T.,.T.,"",cJustific,.T.,{.F.,'','',"",""})
		/*Mostra tela de Anexo*/
		QOUT("2 - Pedido: "+aPedido[x]+" Incluindo Anexo")
		U_INCOME04("2",aPedido[x],.T.,.T.,"",.T.,{})
		
		/*Mostra tela de fornecedor exclusivo*/
		If lFornExcl
			U_INCOME02("Justificativa do Fornecedor Exclusivo","E","",aPedido[x],"","","",.T.,.T.,"","",.T.,{.F.,'','',"",""})
		EndIf
		
		/*Altera o grupo de aprovação dos pedidos de Compra*/
		QOUT("3 - Pedido: "+aPedido[x]+" Incluindo Aprovadores")
		fGravaSCR(aPedido[x],cNumSC)
		DbSelectArea(cAlias)
		
		QOUT("4 - Pedido: "+aPedido[x]+" Enviando Email para aprovadores")
		u_INEnviaEmail(SC8->C8_FILIAL,aPedido[x],cNumSC,1,"")   // Envia e-mail para os aprovadores
		QOUT("5 - Pedido: "+aPedido[x]+" Finalizando Pedido")
	Next
	
Return

Static Function fGravaSCR(cNumPC,cNumSC)
   Local nLimAnt := 0
	Local cQry    := ""
	Local nValor  := 0
	Local cAlias  := ALIAS()
	Local lAprov  := .T.
	Local cNivel  := StrZero(0,TamSX3("CR_NIVEL")[1])
	Local cGrpInf := "900001"    // Grupo padrão de informática
	Local cFilSAL := SAL->(XFILIAL("SAL"))
	Local cFilSAK := SAK->(XFILIAL("SAK"))
	
	// Na alteração do grupo, exclui as alçadas cadastradas para o pedido de compra
	cQry := "DELETE "+RetSqlName("SCR")
	cQry += " WHERE D_E_L_E_T_ = ' '"
	cQry += " AND CR_FILIAL = '"+xFilial("SCR")+"'"
	cQry += " AND CR_NUM = '"+cNumPC+"'"
	TCSQLEXEC(cQry)
	
	// Filtra os itens do pedido de compra
	cQry := "SELECT SC7.*, SC1.*, B1_TE FROM "+RetSqlName("SC7")+ " SC7"
	cQry += " INNER JOIN "+RetSqlName("SC1")+" SC1 ON C1_FILIAL = C7_FILIAL AND C7_NUMSC = C1_NUM AND C7_ITEMSC = C1_ITEM AND SC1.D_E_L_E_T_ = ' '"
	cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_COD = C7_PRODUTO AND SB1.D_E_L_E_T_ = ' '"
	cQry += " WHERE SC7.D_E_L_E_T_ = ' '"
	cQry += " AND C7_FILIAL = '"+xFilial("SC7")+"'"
	cQry += " AND C7_NUM = '"+cNumPC+"'"
	cQry += " ORDER BY C7_FILIAL, C7_ITEM"
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMPSC7",.T.,.T.)
	While !TMPSC7->(Eof())
		
		// Posiciona no item do pedido de compra
		SC7->(DbSetOrder(1))
		If SC7->(DbSeek(TMPSC7->(C7_FILIAL+C7_NUM+C7_ITEM)))
			// Atualiza o pedido de compra com os dados da solicitação
			RecLock("SC7",.F.)
			SC7->C7_APROV   := Posicione("CTT",1,xFilial("CTT")+TMPSC7->C1_CCAPRV,"CTT_APROV")
			SC7->C7_CONAPRO := "B"
			SC7->C7_DATPRF  := CTOD("")
			SC7->C7_DESCCLV := TMPSC7->C1_DESCCLV
			SC7->C7_DESCCC  := TMPSC7->C1_DESCCC
			SC7->C7_DESCCTB := TMPSC7->C1_DESCCTB
			SC7->C7_GERENT  := TMPSC7->C1_GERENTE
			SC7->C7_NOME    := TMPSC7->C1_NOME
			SC7->C7_DETALH  := Posicione("SC1",1,xFilial("SC1")+TMPSC7->(C1_NUM+C1_ITEM),"C1_DETALH")
			SC7->C7_TES     := TMPSC7->B1_TE
			MsUnLock()
		EndIf
		nValor += TMPSC7->(C7_TOTAL * If( C7_MOEDA <> 1 , C7_TXMOEDA, 1))
		
		TMPSC7->(DbSkip())
	Enddo
	dbSelectArea("TMPSC7")
	dbCloseArea()
	dbSelectArea(cAlias)
	
	// Posiciona na solicitação de compras
	SC1->(DbSetOrder(1))
	If SC1->(DbSeek(xFilial("SC1")+cNumSC))
		// Posiciona no centro de custo de aprovação
		CTT->(DbsetOrder(1))
		CTT->(DbSeek(xFilial("CTT")+SC1->C1_CCAPRV))
		
		// Percorre a tabela de grupo de aprovadores de acordo com o grupo do centro de custo
		SAL->(DbSetOrder(2))
		SAL->(DbSeek(cFilSAL+CTT->CTT_APROV,.T.))
		While !SAL->(Eof()) .And. SAL->(AL_FILIAL+AL_COD) == cFilSAL+CTT->CTT_APROV
			
			// Se for produto de informática e não tiver analisando o grupo de informática
			If lAprov .And. SC1->C1_PROINF == "S" .And. SAL->AL_COD <> cGrpInf
				// Inclui o gerente de informatica na aprovação pois é obrigatória a aprovação do mesmo
				AprovaExtra(SAL->AL_FILIAL+cGrpInf,cNumPC,@cNivel,nValor)
				lAprov := .F.
			Endif
			
			// Posiciona no usuário aprovador
			SAK->(dbSeek(cFilSAK+SAL->AL_APROV))
			
			// O gerente, controller e pay sempre entram na aprovação ou
			// O Valor for acima do limite máximo ou
			// Se está dentro do limite de cada aprovador
			If SAL->AL_CATAPRV $ "GDONPCT" .AND. (nValor > SAK->AK_LIMMAX .Or. (nValor >= nLimAnt .And. nValor <= SAK->AK_LIMMAX) .Or. SAL->AL_AUTOLIM == 'N')
				// Inclui controle de alçadas para o grupo de aprovação
				IncluiAlcada(cNumPC,SAL->AL_USER,@cNivel,SAL->AL_APROV,nValor)
			Endif
			nLimAnt := SAK->AK_LIMMAX
			
			SAL->(DbSkip())
		Enddo
	EndIf
	dbSelectArea(cAlias)
	
Return

Static Function AprovaExtra(cSeek,cNumPC,cNivel,nValor)
	Local aSAL := SAL->({IndexOrd(),Recno()})
	
	// Pesquisa o usuario gerente do grupo
	SAL->(dbSetOrder(1))
	SAL->(dbSeek(cSeek,.T.))
	While !SAL->(Eof()) .And. cSeek == SAL->(AL_FILIAL+AL_COD)
		If SAL->AL_CATAPRV == "G"   // Se encontrou o gerente do grupo
			// Inclui aprovação extra para o controle de alçadas
			IncluiAlcada(cNumPC,SAL->AL_USER,@cNivel,SAL->AL_APROV,nValor)
			Exit
		Endif
		SAL->(dbSkip())
	Enddo
	
	// Restaura configurações da tabela
	SAL->(dbSetOrder(aSAL[1]))
	SAL->(dbGoTo(aSAL[2]))
	
Return

Static Function IncluiAlcada(cNumPC,cUser,cNivel,cAprov,nValor)
	RecLock("SCR",.T.)
	SCR->CR_FILIAL := xFilial("SCR")
	SCR->CR_NUM    := cNumPC
	SCR->CR_USER   := cUser
	SCR->CR_NIVEL  := cNivel := Soma1(cNivel) //SAL->AL_NIVEL
	SCR->CR_APROV  := cAprov
	
	If SCR->CR_NIVEL == "01"   // Se for o 1o nível
		SCR->CR_STATUS := "02"  // Aguardando liberação do usuário
	Else
		SCR->CR_STATUS := "01"  // Bloqueado pelo sistema
	EndIf
	
	SCR->CR_TOTAL   := nValor
	SCR->CR_EMISSAO := Date()  // Data da alçada
	SCR->CR_MOEDA   := 1       // Moeda Real
	SCR->CR_TIPO    := "PC"    // Pedido de compra
	MsUnLock()
Return

Static Function fForExc(cNumCot)
	Local cQry
	Local nCont  := 0
	Local cAlias := ALIAS()
	
	// Conta o número de fornecedores existentes na cotação
	cQry := "SELECT COUNT(*) AS TOTAL FROM ("
	cQry += "SELECT C8_NUM,C8_FORNECE,C8_LOJA FROM "+RetSqlName("SC8")
	cQry += " WHERE D_E_L_E_T_ = ' '"
	cQry += " AND C8_FILIAL = '"+xFilial("SC8")+"'"
	cQry += " AND C8_NUM = '"+cNumCot+"'"
	cQry += " GROUP BY C8_NUM,C8_FORNECE,C8_LOJA) SC8"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMPCOTA",.T.,.T.)
	nCont := TOTAL
	dbCloseArea()
	dbSelectArea(cAlias)
	
Return nCont <= 1

Static Function fPedido(cNumCot)
	Local cQry
	Local aPedido := {}
	Local cAlias  := ALIAS()
	
	// Filtra os pedidos de compras existentes na cotação
	cQry := "SELECT C8_NUMPED FROM "+RetSqlName("SC8")
	cQry += " WHERE D_E_L_E_T_ = ''"
	cQry += " AND C8_FILIAL = '"+xFilial("SC8")+"'"
	cQry += " AND C8_NUM = '"+cNumCot+"'"
	cQry += " AND C8_NUMPED <> 'XXXXXX'"
	cQry += " GROUP BY C8_NUMPED"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMPCOTA",.T.,.T.)
	While !TMPCOTA->(Eof())
		AAdd(aPedido,TMPCOTA->C8_NUMPED)
		TMPCOTA->(DbSkip())
	Enddo
	dbCloseArea()
	dbSelectArea(cAlias)
	
Return aPedido
