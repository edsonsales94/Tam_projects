/*---------------------------------------------------------------*
 | P.E chamado na libeeração de documento por alcada de aprovacao |
 | Exec. quando nOperacao=1 (Aprovar) nOperacao=2 (Estornar)      |
 *---------------------------------------------------------------*/
User Function MT094END()
	// Local aParam    := ParamIXB
	Local cNumDoc   := alltrim(ParamIXB[1])
	Local cTipoDoc  := ParamIXB[2]
	Local nOperacao := ParamIXB[3]
	Local XFil   	:= ParamIXB[4]

	if nOperacao == 1
		if cTipoDoc == 'PC'
			U_fnGerarTit(cNumDoc,XFil)
		endif
	endif

Return

/*---------------------------------------------------------------*
 | Incluisão do título provisório gerado na aprovação             |
 | Executado quando nOperacao == 1 (Aprovar)                      |
 *---------------------------------------------------------------*/
User Function FnGerarTit(_cDoc,_cFil)
	Local aAreaAnt := GetArea()
	Local aVetSE2  := {}
	Local lMsErroAuto := .F.

	// Localiza o pedido
	DbSelectArea("SC7")
	SC7->(DbSetOrder(1)) // Ajuste para índice correto (ex: por filial+num)
	If SC7->(DbSeek(_cFil + _cDoc))

		// Verifica se é OLUC e condição de pagamento com adiantamento
		If SC7->C7_XTIPO == "SA" .And. SC7->C7_COND <> "" .and. SC7->C7_XTPDOC == 'O'

			DbSelectArea("SE4")
			SE4->(DbSetOrder(1)) // Ajuste para índice correto (ex: por cond)
			If SE4->(DbSeek(xFilial('SE4')+SC7->C7_COND)) .And. SE4->E4_CTRADT == "1"

				// Monta os campos para o título provisório
				aAdd(aVetSE2, {"E2_FILIAL",  FWxFilial("SE2"), Nil})
				aAdd(aVetSE2, {"E2_PREFIXO", "APC", Nil})
				aAdd(aVetSE2, {"E2_NUM",     "PC" + SC7->C7_NUM, Nil})
				aAdd(aVetSE2, {"E2_PARCELA", "", Nil})
				aAdd(aVetSE2, {"E2_TIPO",    "PR", Nil})
				aAdd(aVetSE2, {"E2_NATUREZ", SC7->C7_XNATUR, Nil})
				aAdd(aVetSE2, {"E2_FORNECE", SC7->C7_FORNECE, Nil})
				aAdd(aVetSE2, {"E2_LOJA",    SC7->C7_LOJA, Nil})
				aAdd(aVetSE2, {"E2_EMISSAO", SC7->C7_EMISSAO, Nil})
				aAdd(aVetSE2, {"E2_VENCTO",  SC7->C7_EMISSAO, Nil})
				aAdd(aVetSE2, {"E2_VENCREA", SC7->C7_EMISSAO, Nil})
				aAdd(aVetSE2, {"E2_VALOR",   SC7->C7_TOTAL, Nil})
				aAdd(aVetSE2, {"E2_EMIS1",   SC7->C7_EMISSAO, Nil})
				aAdd(aVetSE2, {"E2_ORIGEM",  "MATA097", Nil})
				aAdd(aVetSE2, {"E2_HIST",    "ADTO OLUC REF PC" + SC7->C7_NUM, Nil})
				aAdd(aVetSE2, {"E2_XFILPED", SC7->C7_FILIAL, Nil})
				aAdd(aVetSE2, {"E2_XPEDIDO", SC7->C7_NUM, Nil})
				aAdd(aVetSE2, {"E2_MOEDA",   1, Nil})

				// Inicia transação
				Begin Transaction
					MSExecAuto({|x,y| FINA050(x,y)}, aVetSE2, 3)

					If lMsErroAuto
						MostraErro()
						DisarmTransaction()
					else
						 Alert("Título provisório Prefixo APC, Nº: PC"+AllTrim(SC7->C7_NUM)+" Incluido com sucesso!",'Atencao !')
					EndIf
				End Transaction

			EndIf
		EndIf
	EndIf

	RestArea(aAreaAnt)
Return

/*---------------------------------------------------------------*
 | Exclusão do título provisório gerado na aprovação             |
 | Executado quando nOperacao == 2 (Estornar)                    |
 *---------------------------------------------------------------*/
User Function FnExcluirTit(_cDoc,_cFil)
    Local aAreaAnt := GetArea()
    Local aArray   := {}
    Local lMsErroAuto := .F.

	_cDoc := Alltrim(_cDoc)

    // Posiciona no pedido
    DbSelectArea("SC7")
    SC7->(DbSetOrder(1))
    If SC7->(DbSeek(_cFil + _cDoc))

		If SC7->C7_XTIPO == "SA" .And. SC7->C7_COND <> "" .and. SC7->C7_XTPDOC == 'O'
			// Monta chave do título provisório
			DbSelectArea("SE2")
			SE2->(DbSetOrder(1)) // Ajuste conforme índice da sua base
			If SE2->(DbSeek(FWxFilial("SE2")+"APC"+"PC"+SC7->C7_NUM+SPACE(3)+"PR"))

				// Prepara array para exclusão
				aArray := { ;
					{ "E2_PREFIXO", SE2->E2_PREFIXO, Nil }, ;
					{ "E2_NUM",     SE2->E2_NUM,     Nil } ;
				}

				// Inicia transação
				Begin Transaction
					MSExecAuto({|x,y,z| FINA050(x,y,z)}, aArray,, 5) // 5 = Exclusão
					If lMsErroAuto
						MostraErro()
						DisarmTransaction()
					Else
						Alert("Título provisório excluído com sucesso!")
					EndIf
				End Transaction

			EndIf
		EndIf
    EndIf

    RestArea(aAreaAnt)
Return

