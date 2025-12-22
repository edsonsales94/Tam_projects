#Include "rwmake.ch"

User Function M521CDEL()
	/*---------------------------------------------------------------------------------------------------------------------------------------------------
	Este ponto pertence à rotina de exclusão de notas fiscais, MATA521().
	Está localizado na rotina que verifica se uma nota pode ou não ser excluída, MACANDELNF2. Permite que o usuário faça uma verificação adicional.
	OBJETIVO 1: Verificar se é uma NF de Transferência, desta forma, não pode ser excluída devido a NF de Entrada na Filial solicitante
	----------------------------------------------------------------------------------------------------------------------------------------------------*/

	DbSelectArea("SC5")
	DbSetorder(1)

	DbSelectArea("SA1")
	DbSetorder(1)

	DbSelectArea("SD2")
	nIndSD2  := IndexOrd()
	nRecSD2  := RecNo()
	DbSetorder(3)

	lRet := .T.

	SF1->(dbSetOrder(1))
	If SF1->(DbSeek(SF2->F2_FILDEST+SF2->F2_DOC+SF2->f2_SERIE+SF2->F2_FORDES+SF2->F2_LOJADES+SF2->F2_FORMDES)) .And. !EMPTY (SF2->F2_FORDES)
		_xdCabec:= {}
		aadd(_xdCabec,{"F1_FILIAL", SF1->F1_FILIAL , Nil})
		aadd(_xdCabec,{"F1_TIPO" , SF1->F1_TIPO , Nil})
		aadd(_xdCabec,{"F1_FORMUL" ,SF1->F1_FORMUL , Nil})
		aadd(_xdCabec,{"F1_DOC" , SF1->F1_DOC , Nil})
		aadd(_xdCabec,{"F1_SERIE" , SF1->F1_SERIE , Nil})		
		aadd(_xdCabec,{"F1_FORNECE" , SF1->F1_FORNECE, Nil})
		aadd(_xdCabec,{"F1_LOJA" , SF1->F1_LOJA, Nil})
		aadd(_xdCabec,{"F1_ESPECIE" , SF1->F1_ESPECIE , Nil})		
		aadd(_xdCabec,{"F1_STATUS" , SF1->F1_STATUS , Nil})

		SD1->(dbSetOrder(1))
		lSD1 := SD1->(dbSeek(SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
		//Alert(lSD1)
		adItens := {}		
		While  SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ==;
		SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA

			adXLinha := {}
			aadd(adXLinha,{"D1_FILIAL" , SD1->D1_FILIAL , Nil})
			aadd(adXLinha,{"D1_COD"    , SD1->D1_COD , Nil})
			aadd(adXLinha,{"D1_ITEM"   , SD1->D1_ITEM , Nil})
			aadd(adXLinha,{"D1_QUANT"  , SD1->D1_QUANT , Nil})
			aadd(adXLinha,{"D1_VUNIT"  , SD1->D1_VUNIT , Nil})
			aadd(adXLinha,{"D1_TOTAL"  , SD1->D1_TOTAL , Nil})
			aadd(adXLinha,{"D1_TES"    , SD1->D1_TES , Nil})								
			aAdd(adItens,adXLinha)  
			SD1->(dbSkip())
		Enddo
		
		Private lMsErroAuto := .F.
		Private lMsHelpAuto := .T.
		SF1->(dbGoTop())
		SD1->(dbGoTop())
		cFilBkp := cFilAnt
		cFilAnt := SF2->F2_FILDEST
		
		MsgRun("Excluindo Nf de Entrada",,{|| MATA103(_xdCabec,adItens,5) } ) //ExpN1 - Opção desejada: 3-Inclusão; 4-Alteração ; 5-Exclusão
		
		cFilAnt := cFilBkp
		If !lMsErroAuto
			ConOut("Excluido com sucesso! ")
			Alert("Excluido com Sucesso")
			//Alert("Nf De Entrada")
		Else
			Alert("Não foi possivel excluir a NF de Entrada, Portanto não será possível excluir a de Saida")
			MostraErro()
			lRet := .F.
			ConOut("Erro na Exclusão!")
		EndIf

	EndIf
	
	/*
	//Desabilitado por  Diego em 21/06/2018
	//Haja Vista que os campos A1_FORBRAS e A1_LOJBRAS nao sao preenchidos
	
	If SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE))

		If SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO))     			  // Pesquisa o Pedido de Venda

			SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))  //Posiciona no cliente para buscar o Código do Fornecedor que está Loja da PILOTO pertence

			If SF1->(DbSeek(SC5->C5_FILSOL+SF2->F2_DOC+SF2->F2_SERIE+SA1->A1_FORBRAS+SA1->A1_LOJBRAS))  	// Pesquisa na Filial que recebeu a NF de Transferência
				Aviso("Atenção","Nota Fiscal de Transferência não pode ser excluída, pois já existe Nota Fiscal de Entrada na Loja solicitante !!!",{"OK"},2)
				lRet := .F.
			EndIf

		EndIf

	EndIf
	*/

	SD2->(DbSetOrder(nIndSD2))
	SD2->(DbGoto(nRecSD2))

Return(lRet)
