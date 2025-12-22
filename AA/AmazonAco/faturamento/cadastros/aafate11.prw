#include "rwmake.ch"        
#include "protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATE11   ¦ Autor ¦ Wladimir Vieira      ¦ Data ¦ 26/12/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Este programa irá realizar ateração de campos do Pedido dw   ¦¦¦
¦¦¦  (cont.)  ¦ Vendas, conforme parametros                                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Alterações

¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function AAFATE11()
	Local cLinok 	:= "Allwaystrue"
	Local cTudook 	:= "Allwaystrue"
	Local nOpce 	:= 4 	//define modo de alteração para a enchoice
	Local nOpcg 	:= 4 	//define modo de alteração para o grid
	Local cFieldok 	:= "Allwaystrue"
	Local lRet 		:= .T.
	Local cMensagem := ""
	Local lVirtual  := .T. 	//Mostra campos virtuais se houver
	Local nFreeze	:= 0	
	Local nAlturaEnc:= 400	//Altura da Enchoice

	Private cCadastro	:= "Pedido de Venda"	
	Private aCols 		:= {}
	Private aHeader 	:= {}
	Private aCpoEnchoice:= {}
	Private aAltEnchoice:= {}    //{"C5_CLIENTE","C5_CONDPAG","C5_TPFRETE","C5_MENNOTA"}
	Private cTitulo
	Private cAlias1 	:= "SC5"
	Private cAlias2 	:= "SC6"

	// Verifica se o pedido já está liberado
	If !Empty(SC5->C5_NOTA).Or.(SC5->C5_LIBEROK=='E' .And. Empty(SC5->C5_BLQ))
		MsgStop("Este pedido está encerrado!")
	Else
		RegToMemory("SC5",.F.)
		RegToMemory("SC6",.F.)

		DefineCabec()
		DefineaCols(nOpcg)

		//        lRet:=Modelo3(cCadastro,cAlias1,cAlias2,aCpoEnchoice,cLinok,cTudook,nOpce,nOpcg,cFieldok,lVirtual,,aAltenchoice,nFreeze,,,nAlturaEnc)
		lRet:=Modelo3(cCadastro,cAlias1,cAlias2,aCpoEnchoice,cLinok,cTudook,nOpce,nOpcg,cFieldok,lVirtual,,,nFreeze,,,nAlturaEnc)

		//retornará como true se clicar no botao confirmar
		if lRet
			cMensagem += "Esta rotina tem a finalidade de salvar alguns campos no PEDIDO DE VENDA LIBERADO"+CRLF+CRLF
			cMensagem += "APENAS os campos abaixo SERÃO SALVOS:"+CRLF+CRLF

			cMensagem += "Cabeçalho: "+CRLF
			cMensagem += "Não será permitido alterações "+CRLF+CRLF

			cMensagem += "Itens:"+CRLF
			cMensagem += "Armazém, TES e CFOP"+CRLF+CRLF

			if MsgYesNo(cMensagem+"CONFIRMA ALTERAÇÃO DOS DADOS ?", cCadastro)
				Processa({||Gravar()},cCadastro,"Alterando os dados, aguarde...")
			endif

			// Elimina liberação de pedido SC9
			dbSelectArea("SC9")
			dbSetOrder(1)
			//dbSeek(xFilial("SC9")+SC6->C6_NUM)
			/*
			While !((SC9)->(eof()) .and. SC9->C9_PEDIDO == SC6->C6_NUM
				If Reclock("SC9", .F.)
					dbDelete()
					msUnlock()
				Endif
				dbSkip()
			Enddo*/
			

			SC9->(DbSeek(FWxFilial('SC9')+SC6->C6_NUM))
			While  (!SC9->(Eof())) .AND. SC9->(C9_FILIAL+C9_PEDIDO) == FWxFilial('SC9')+SC6->(C6_NUM) .AND. EMPTY(SC9->C9_OK)
				SC9->(a460Estorna(.T.))
				SC9->(DbSkip())
			EndDo

			// Elimina liberação de pedido SC6
			dbSelectArea("SC6")
			_mped := SC6->C6_NUM
			dbSeek(xFilial()+_mPed)
			While !eof() .and. C6_NUM == _mped
				If Reclock("SC6", .F.)
					C6_QTDLIB  := 0 
					C6_QTDLIB2 := 0 
					C6_QTDEMP  := 0 
					C6_QTDEMP2 := 0
					msUnlock() 
				Endif
				dbSkip()
			Enddo

			// Elimina liberação de pedido SC5
			dbSelectArea("SC5")
			If Reclock("SC5",.F.)
				C5_LIBEROK := ""
				C5_BLQ := ""
				msUnlock()
			Endif

		else
			RollbackSx8()
		endif

	Endif

Return


Static Function DefineCabec()
	Local aSC6		:= {"C6_ITEM","C6_PRODUTO","C6_DESCRI","C6_LOCAL","C6_TES","C6_CF","C6_PEDCLI", 'C6_CLASFIS'}
	Local nUsado
	aHeader		:= {}
	aCpoEnchoice:= {}

	nUsado:=0

	//Monta a enchoice
	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	dbseek(cAlias1)
	while SX3->(!eof()) .AND. X3_ARQUIVO == cAlias1
		IF X3USO(X3_USADO) .AND. CNIVEL >= X3_NIVEL
			AADD(ACPOENCHOICE,X3_CAMPO)
		endif
		dbskip()
	enddo

	//Monta o aHeader do grid conforme os campos definidos no array aSC6 (apenas os campos que deseja)
	//Caso contrário, se quiser todos os campos é necessário trocar o "For" por While, para que este faça a leitura de toda a tabela
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	aHeader:={}
	For nX := 1 to Len(aSC6)
		If SX3->(DbSeek(aSC6[nX]))
			If X3USO(X3_USADO).And.cNivel>=X3_NIVEL 
				nUsado:=nUsado+1
				Aadd(aHeader, {TRIM(X3_TITULO), X3_CAMPO , X3_PICTURE, X3_TAMANHO, X3_DECIMAL,X3_VALID, X3_USADO  , X3_TIPO   , X3_ARQUIVO, X3_CONTEXT})
			Endif
		Endif
	Next nX


Return

//Insere o conteudo no aCols do grid
Static function DefineaCols(nOpc)
	Local nQtdcpo 	:= 0
	Local i			:= 0
	Local nCols 	:= 0
	nQtdcpo 		:= len(aHeader)
	aCols			:= {}

	dbselectarea(cAlias2)
	dbsetorder(1)
	dbseek(xfilial()+SC5->C5_NUM)
	while .not. eof() .and. SC6->C6_FILIAL == xfilial() .and. SC6->C6_NUM==SC5->C5_NUM
		aAdd(aCols,array(nQtdcpo+1))
		nCols++
		for i:= 1 to nQtdcpo
			if aHeader[i,10] <> "V"
				aCols[nCols,i] := Fieldget(Fieldpos(aHeader[i,2]))
			else
				aCols[nCols,i] := Criavar(aHeader[i,2],.T.)
			endif
		next i
		aCols[nCols,nQtdcpo+1] := .F.
		dbselectarea(cAlias2)
		dbskip()
	enddo
Return


//Gravar o conteudo dos campos
Static Function Gravar()
	Local bcampo := { |nfield| field(nfield) }
	Local i:= 0
	Local y:= 0
	Local nitem := 0
	Local nItem 	:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_ITEM"})
	Local nProduto 	:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_PRODUTO"})
	Local nPosCpo
	Local nCpo
	Local nI
	Local cCamposSC5	:= "C5_CLIENTE|C5_CONDPAG|C5_TPFRETE|C5_MENNOTA|" 
	Local cCamposSC6	:= "C6_LOCAL|C6_TES|C6_CF|C6_CLASFIS|" 


	Begin Transaction

		//Gravando dados da enchoice
		/*/
		dbselectarea(cAlias1)
		Reclock(cAlias1,.F.)	 
		for i:= 1 to fcount()
		incproc()
		if "FILIAL" $ FIELDNAME(i)
		Fieldput(i,xfilial(cAlias1))
		else
		//Grava apenas os campos contidos na variavel cCamposSC5
		If ( FieldName(i) $ cCamposSC5 )
		Fieldput(i,M->(EVAL(bcampo,i)))
		Endif
		endif
		next i		 
		Msunlock()
		/*/
		//Gravando dados do grid
		dbSelectArea("SC6")
		SC6->(dbSetOrder(1))	
		For nI := 1 To Len(aCols)
			If !(aCols[nI, Len(aHeader)+1])
				If SC6->(dbSeek( xFilial("SC6")+M->C5_NUM+aCols[nI,nItem]+aCols[nI,nProduto] ))
					RecLock("SC6",.F.)
					For nCpo := 1 to fCount()
						//Grava apenas os campos contidos na variavel $cCamposSC6
						If (FieldName(nCpo)$cCamposSC6)
							nPosCpo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim(FieldName(nCpo))})
							If nPosCpo > 0
								FieldPut(nCpo,aCols[nI,nPosCpo])
							EndIf
						Endif
					Next nCpo
					SC6->(MsUnLock())
				Endif
			Endif
		Next nI

	End Transaction

Return
