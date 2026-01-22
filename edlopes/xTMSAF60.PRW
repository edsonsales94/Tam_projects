User Function TMSAF60()
	Local aParam     := PARAMIXB
	Local xRet       := .T.
	Local oObj       := ''
	Local cIdPonto   := ''
	Local cIdModel   := ''
	Local lIsGrid    := .F.
	// Local nLinha     := 0
	// Local nQtdLinhas := 0
	// Local cMsg       := ''
	// Local cClasse := ''
	Local nOper := aParam[1]:GetOperation()

	If aParam <> NIL
		// If lIsGrid
		// 	nQtdLinhas := oObj:GetQtdLine()
		// 	nLinha     := oObj:nLine
		// EndIf
		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]
		lIsGrid    := ( Len( aParam ) > 3 )
		If cIdPonto == 'FORMCOMMITTTSPOS' // AQUI EXCLUI e inclui
			if nOper == 3  .and. cIdModel == 'MdFieldDTQ'// se for inclusão e gravar o movimento da viagem integra
				U_ELOBJP01(1)
			ElseIf nOper == 5 .and. cIdModel == 'MdFieldDTQ'// se for exclusao.
				if !EMPTY(DTQ->DTQ_XCODVG)
					U_ELOBJP01(4)
				endif
			endif
		EndIf

		// 	If     cIdPonto == 'MODELPOS'
		// 		cMsg := 'Chamada na validação total do modelo (MODELPOS).'
		// 		cMsg += 'ID ' + cIdModel
		// 		 CALETA := ''
		// 		// If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
		// 		// 	Help( ,, 'Help',, 'O MODELPOS retornou .F.', 1, 0 )
		// 		// EndIf

		// 	ElseIf cIdPonto == 'FORMPOS'
		// 		 CALETA := ''

		// 	ElseIf cIdPonto == 'FORMLINEPRE'
		// 		 CALETA := ''
		// 		// If aParam[5] == 'DELETE'
		// 		// 	cMsg := 'Chamada na pre validação da linha do formulário (FORMLINEPRE).'
		// 		// 	cMsg += 'Onde esta se tentando deletar uma linha'
		// 		// 	cMsg += 'É um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) +;
			// 			// 		' linha(s).'
		// 		// 	cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha     ) )
		// 		// 	cMsg += 'ID ' + cIdModel

		// 		// 	If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
		// 		// 		Help( ,, 'Help',, 'O FORMLINEPRE retornou .F.', 1, 0 )
		// 		// 	EndIf
		// 		// EndIf

		// 	ElseIf cIdPonto == 'FORMLINEPOS'
		// 		 CALETA := ''
		// 		// cMsg := 'Chamada na validação da linha do formulário (FORMLINEPOS).'
		// 		// cMsg += 'ID ' + cIdModel
		// 		// cMsg += 'É um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ;
			// 			// 	' linha(s).'
		// 		// cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha     ) )

		// 		// If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
		// 		// 	Help( ,, 'Help',, 'O FORMLINEPOS retornou .F.', 1, 0 )
		// 		// EndIf

		// 	ElseIf cIdPonto == 'MODELCOMMITTTS' // AQUI EXCLUI e inclui
		// 		ApMsgInfo('Chamada apos a gravação total do modelo e dentro da transação (MODELCOMMITTTS).'   + 'ID ' + cIdModel )
		//         CALETA := ''

		// *	ElseIf cIdPonto == 'MODELCOMMITNTTS' // AQUI EXCLUI e inclui
		// 		ApMsgInfo('Chamada apos a gravação total do modelo e fora da transação (MODELCOMMITNTTS).'   + 'ID ' + cIdModel)
		//         CALETA := ''
		// 		//ElseIf cIdPonto == 'FORMCOMMITTTSPRE'

		// 	ElseIf cIdPonto == 'FORMCOMMITTTSPOS' // AQUI EXCLUI e inclui
		// 		ApMsgInfo('Chamada apos a gravação da tabela do formulário (FORMCOMMITTTSPOS).'   + 'ID ' + cIdModel)
		//         CALETA := ''
		// 	ElseIf cIdPonto == 'MODELCANCEL'
		// 		cMsg := 'Chamada no Botão Cancelar (MODELCANCEL).'   + 'Deseja Realmente Sair ?'
		//         CALETA := ''

		// 		// If !( xRet := ApMsgYesNo( cMsg ) )
		// 		// 	Help( ,, 'Help',, 'O MODELCANCEL retornou .F.', 1, 0 )
		// 		// EndIf

		// 	ElseIf cIdPonto == 'BUTTONBAR'
		// 		ApMsgInfo('Adicionando Botao na Barra de Botoes (BUTTONBAR).'   + 'ID ' + cIdModel )
		// 		xRet := { {'Salvar', 'SALVAR', { || Alert( 'Salvou' ) }, 'Este botao Salva' } }

		// 	EndIf

	EndIf

Return xRet
