#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GQREENTR  ºAutor  ³Ener Fredes         º Data ³  07.12.10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE executado após a confirmação da inclusão do Documento   º±±
±±º          ³ de Entrada. Será usado para:                               º±±
±±º          ³ * Atualizar os títulos de impostos coms os dados do Centro º±±
±±º          ³   de Custo, Classe MCT, Funcionário, Viagem e Treinamento  º±±
±±º          ³ * Mostra a tela de Objetivo e Justificativa com dados      º±±
±±º          ³   digitados no pedido de compra e gravar uma nova chave na º±±
±±º          ³   tabela SZ6 para o documento de entrada.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COMPRAS - Documento de Entrada                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GQREENTR()
	Local cNatpj, cNatpf, cCC, cITEM, cCLVL, cViag, cTrein, cBuscaIR, cBuscaPIS, cBuscaCOF, cBuscaINS, cBuscaISS, nReg, nInd, lret
	Local cForPd  := SubStr(GetMv("MV_UNIAO"),1,Len(SE2->E2_FORNECE))   //Fornecedor dos titulos de impostos
	Local cInss   := SubStr(GetMv("MV_FORINSS"),1,Len(SE2->E2_FORNECE)) //Fornecedor dos titulos de impostos de INSS
	Local cIss    := SubStr(GetMv("MV_MUNIC"),1,Len(SE2->E2_FORNECE))   //Fornecedor dos titulos de impostos de ISS
	Local cBusca  := SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
	Local lPedido := .F.
	
	SDE->(DbSetOrder(1))
	SD1->(DbSetOrder(1))
	SD1->(dbSeek(cBusca))
	
	If SD1->D1_RATEIO == '1'     // 1-sim 2 -nao
		cCC   := SDE->DE_CC
		cITEM := SDE->DE_ITEMCTA
		cCLVL := SDE->DE_CLVL   	
	Elseif SD1->D1_RATEIO == '2' 
		cCC   := SD1->D1_CC
		cITEM := SD1->D1_ITEMCTA
		cCLVL := SD1->D1_CLVL
		cViag := SD1->D1_VIAGEM
		cTrein:= SD1->D1_TREINAM
	EndIf
	
	nReg := SD1->(Recno())

	While !SD1->(Eof()) .And. cBusca == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)

		RecLock("SD1",.F.)
		SD1->D1_PRCOMP := If( Empty(SD1->D1_PRCOMP) , SD1->D1_PEDIDO, SD1->D1_PRCOMP)
		MsUnLock()
		
		lPedido := If( lPedido , .T., !Empty(SD1->D1_PRCOMP))

		SD1->(dbSkip())
	Enddo
	
	/*Mostra tela de Objetivo e Justificativa*/
	If !lPedido .And. SF1->F1_TIPO == "N"   // Caso não tenha pedido no item
	  	u_INCOME02("Justificativa da Compra","4",SF1->F1_SERIE,SF1->F1_DOC,SF1->F1_FORNECE,SF1->F1_LOJA,"",.T.,.T.,"","",.T.,{.F.,'','',"",""})
 	EndIf

	cBusca := SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC

	dbSelectArea("SE2")
	dbSetOrder(6)
	If dbSeek(XFILIAL("SE2")+cBusca)
		While !Eof() .And. E2_FILIAL == xFilial("SE2") .And. cBusca == E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM//Pesquisa o titulo principal para gravar as alteracoes
			nReg   := Recno()
			nInd   := IndexOrd()
			RecLock("SE2",.F.)
			SE2->E2_CC      := cCC
			SE2->E2_ITEMCTA := cITEM
			SE2->E2_CLVL    := cCLVL
			SE2->E2_VIAGEM  := cViag
			SE2->E2_TREINAM := cTrein	
			SE2->E2_DATAAGE := iIf( Empty(SE2->E2_DATAAGE), SE2->E2_VENCREA, SE2->E2_DATAAGE ) 
			SE2->E2_TXMOEDA := SF1->F1_TXMOEDA				  
			MsUnLock()
				
			//gravar centro de custo nos titulos dos impostos
			dbSetOrder(1)
			cBuscaIR  := E2_PREFIXO+E2_NUM+E2_PARCIR+"TX "+cForPd+Space(Len(E2_FORNECE)-Len(cForpd))
			cBuscaPIS := E2_PREFIXO+E2_NUM+E2_PARCPIS+"TX "+cForPd+Space(Len(E2_FORNECE)-Len(cForpd)) 
			cBuscaCOF := E2_PREFIXO+E2_NUM+E2_PARCCOF+"TX "+cForPd+Space(Len(E2_FORNECE)-Len(cForpd))
			cBuscaCSL := E2_PREFIXO+E2_NUM+E2_PARCSLL+"TX "+cForPd+Space(Len(E2_FORNECE)-Len(cForpd))
			cBuscaINS := E2_PREFIXO+E2_NUM+E2_PARCINS+"INS"+cInss+Space(Len(E2_FORNECE)-Len(cForpd))
			cBuscaISS := E2_PREFIXO+E2_NUM+E2_PARCISS+"ISS"+cIss+Space(Len(E2_FORNECE)-Len(cForpd))
				
			If dbSeek(XFILIAL("SE2")+cBuscaIR) //Pesquisa o titulo referente ao IR
				RecLock("SE2",.F.)
				SE2->E2_CC      := cCC
				SE2->E2_CLVL    := cCLVL
				SE2->E2_ITEMCTA := cITEM
				SE2->E2_VIAGEM  := cViag
				SE2->E2_TREINAM := cTrein                   
				SE2->E2_DATAAGE := iIf( Empty(SE2->E2_DATAAGE), SE2->E2_VENCREA, SE2->E2_DATAAGE ) 				  
				MsUnLock()
			Endif	 
				
			If dbSeek(XFILIAL("SE2")+cBuscaPIS) //Pesquisa o titulo referente ao Pis
				RecLock("SE2",.F.)
				SE2->E2_CC      := cCC
				SE2->E2_CLVL    := cCLVL
				SE2->E2_ITEMCTA := cITEM
				SE2->E2_VIAGEM  := cViag
				SE2->E2_TREINAM := cTrein                      
				SE2->E2_DATAAGE := iIf( Empty(SE2->E2_DATAAGE), SE2->E2_VENCREA, SE2->E2_DATAAGE ) 				  
				MsUnLock()
			Endif
					
			If dbSeek(XFILIAL("SE2")+cBuscaCOF) //Pesquisa o titulo referente ao Cofins
				RecLock("SE2",.F.)
				SE2->E2_CC      := cCC
				SE2->E2_CLVL    := cCLVL
				SE2->E2_ITEMCTA := cITEM
				SE2->E2_VIAGEM  := cViag
				SE2->E2_TREINAM := cTrein                      
				SE2->E2_DATAAGE := iIf( Empty(SE2->E2_DATAAGE), SE2->E2_VENCREA, SE2->E2_DATAAGE ) 				  
				MsUnLock()
			Endif
					
			If dbSeek(XFILIAL("SE2")+cBuscaCSL) //Pesquisa o titulo referente ao CSLL
				RecLock("SE2",.F.)
				SE2->E2_CC      := cCC
				SE2->E2_CLVL    := cCLVL
				SE2->E2_ITEMCTA := cITEM
				SE2->E2_VIAGEM  := cViag
				SE2->E2_TREINAM := cTrein                      
				SE2->E2_DATAAGE := iIf( Empty(SE2->E2_DATAAGE), SE2->E2_VENCREA, SE2->E2_DATAAGE ) 				  
				MsUnLock()
			Endif
				
			If dbSeek(XFILIAL("SE2")+cBuscaINS) //Pesquisa o titulo referente ao INSS
				RecLock("SE2",.F.)
				SE2->E2_CC      := cCC
				SE2->E2_CLVL    := cCLVL
				SE2->E2_ITEMCTA := cITEM
				SE2->E2_VIAGEM  := cViag
				SE2->E2_TREINAM := cTrein                      
				SE2->E2_DATAAGE := iIf( Empty(SE2->E2_DATAAGE), SE2->E2_VENCREA, SE2->E2_DATAAGE ) 				  
				MsUnLock()
			Endif
			    
			If dbSeek(XFILIAL("SE2")+cBuscaISS) //Pesquisa o titulo referente ao IR
				RecLock("SE2",.F.)
				SE2->E2_CC      := cCC
				SE2->E2_CLVL    := cCLVL
				SE2->E2_ITEMCTA := cITEM
				SE2->E2_VIAGEM  := cViag
				SE2->E2_TREINAM := cTrein                      
				SE2->E2_DATAAGE := iIf( Empty(SE2->E2_DATAAGE), SE2->E2_VENCREA, SE2->E2_DATAAGE )
				MsUnLock()                                     
			Endif
			dbSetOrder(nInd)
			dbGoTo(nReg)
			Dbskip()
		Enddo
	EndIf                 
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(XFILIAL("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
	If A2_TIPO == "F" //Se o fornecedor for pessoa fisica
		cForPd := SubStr(GetMv("MV_UNIAO"),1,Len(SE2->E2_FORNECE)) //Fornecedor dos titulos de impostos
		cNatpj := SubStr(StrTran(GetMv("MV_IRF" ),'"',''),1,Len(SE2->E2_NATUREZ)) //Natureza padrao do IR
		cNatpf := SubStr(StrTran(GetMv("MV_IRFF"),'"',''),1,Len(SE2->E2_NATUREZ)) //Natureza do IR para Pessoa fisica
		cBusca := SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC
		dbSelectArea("SE2")
		dbSetOrder(6)
		If dbSeek(XFILIAL("SE2")+cBusca) //Pesquisa o titulo principal para pegar a parcela do IR (E2_PARCIR)
			cBusca := E2_PREFIXO+E2_NUM+E2_PARCIR+"TX "+cForPd+Space(Len(E2_FORNECE)-Len(cForpd))
			dbSetOrder(1)
			If dbSeek(XFILIAL("SE2")+cBusca) //Pesquisa o titulo referente ao IR
				If E2_NATUREZ == cNatpj+Space(Len(E2_NATUREZ)-Len(cNatpj)) //Verifica se a natureza eh a do IR
					RecLock("SE2",.F.)
					SE2->E2_NATUREZ := cNatpf+Space(Len(E2_NATUREZ)-Len(cNatpf))
					MsUnLock()
				Endif
			Endif
		Endif
	Endif
	
	
	
Return
