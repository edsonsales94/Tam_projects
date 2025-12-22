#INCLUDE "PROTHEUS.CH"
#INCLUDE "PRTOPDEF.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
#include 'parmtype.ch'

/*-----------------------------------------------------------------------------
Edson Sales - 02/01/2025
P.E para gravar a tabela de preço de vendas,
ao cadastrar um produto
-----------------------------------------------------------------------------*/
User Function A010TOK()
	Local lRet := .T.

	// grava tabela somente para produtos grupos 0009
	if M->B1_GRUPO == '0009'
		if Empty(M->B1_PRV1)  // Se o preço de venda estiver vazio não deixa salvar
			// FWAlertWarning("Por favor informe o preço de venda...", "Atenção")
	 		Help(, , "Help", , "Por favor informe o preço de venda...", 1, 0, , , , , , {})
			lRet := .F.
			Return lRet
		endif
		lRet := TabPreco()
	endif

Return (lRet)

/*/{Protheus.doc} TabPreco
    (long_description)
    @type  Static Function
    @author Edson Sales
    @since 18/12/2024

***** Ponto de entrada chamado ao gravar o produto ****
/*/
Static Function TabPreco()

	Local cCodTab := "002"
	Local aArea    := GetArea()
	Local aAreaDA1  := DA1->(GetArea())
    Local lRet := .F.

	BEGINSQL ALIAS "TMP1"

	// buscar o ultimo item da tabela
    SELECT MAX(DA1_ITEM) ULTIMO
    FROM %TABLE:DA1%
    WHERE
        DA1_FILIAL = '0102'
        AND DA1_CODTAB = %EXP:cCodTab%
	ENDSQL

	If TMP1->(!EOF())
		// proximo item a ser gravado.
		cProximo := Soma1(TMP1->ULTIMO)
		TMP1->(dbCloseArea())
	Else
	 	Help(, , "Help", , "Tabela de preço não encontrada!", 1, 0, , , , , , {})
		TMP1->(dbCloseArea())
		return
	EndIf
	//Iniciando controle de transações
	if inclui
		dbSelectArea("DA1")
		Begin Transaction
			RecLock("DA1",.T.)
			DA1->DA1_FILIAL     := xFilial("DA1")
			DA1->DA1_TIPPRE     := '1'
			DA1->DA1_CODTAB     := cCodTab
			DA1->DA1_ITEM       := cProximo
			DA1->DA1_CODPROD    := M->B1_COD
			DA1->DA1_PRCVEN     := (M->B1_PRV1 * 1.8) 
			DA1->DA1_DATVIG     := dDataBase
			DA1->DA1_ATIVO      := '1' // Sim
			DA1->DA1_TPOPER     := '4' // todas as operações
			DA1->DA1_QTDLOT     := 999999.99
			DA1->DA1_PERDES     := 1.8
			DA1->DA1_MOEDA := 2
			// DA1->DA1_INDLOT := STRZERO(999999, TamSx3("DA1_INDLOT")[1]-3 ) + ".99"
			lRet := .T.
			MsUnLock()

			FWAlertSucess('O Produto '+M->B1_COD+' foi adicionado na tabela de Preço 002', 'Inclusão de item na tabela de preco')
			//Finalizando controle de transações
		End Transaction
	endif

	if altera
		dbSelectArea("DA1")
		DbSetOrder(2)
		// se localizar o produto e houver alteração no preco
		if DA1->(dbseek(xfilial('DA1')+M->B1_COD+'002'))
			// se houver alteração no preço do produto.
			if (M->B1_PRV1 * 1.8) != DA1->DA1_PRCVEN 
				Begin Transaction
					RecLock("DA1",.F.)
					DA1->DA1_PRCVEN     := (M->B1_PRV1 * 1.8)
					DA1->DA1_PERDES     := 1.8
					MsUnLock()
					//Finalizando controle de transações
					FWAlertSucess('O preço do produto '+M->B1_COD+' foi alterado na tabela de Preço 002', 'Alteração de item na tabela de preco')
				End Transaction
			EndIf
			lRet := .T.
		else // se não localizar cadastra.
			Begin Transaction
				RecLock("DA1",.T.)
				DA1->DA1_FILIAL     := xFilial("DA1")
				DA1->DA1_TIPPRE     := '1'
				DA1->DA1_CODTAB     := cCodTab
				DA1->DA1_ITEM       := cProximo
				DA1->DA1_CODPROD    := M->B1_COD
				DA1->DA1_PRCVEN     := (M->B1_PRV1 * 1.8) 
				DA1->DA1_DATVIG     := dDataBase
				DA1->DA1_ATIVO      := '1' // Sim
				DA1->DA1_TPOPER     := '4' // todas as operações
				DA1->DA1_QTDLOT     := 999999.99
				DA1->DA1_PERDES     := 1.8
				DA1->DA1_MOEDA := 2
				// DA1->DA1_INDLOT := STRZERO(999999, TamSx3("DA1_INDLOT")[1]-3 ) + ".99"
				MsUnLock()
				FWAlertSucess('O Produto '+M->B1_COD+' foi adicionado na tabela de Preço 002', 'Inclusão de item na tabela de preco')
				//Finalizando controle de transações
			End Transaction
			lRet := .T.
		endif
	endif

	if !lRet
		Help(, , "Help", , "Falha no cadastro!", 1, 0, , , , , , {})
	endif

	DA1->(DbCloseArea())
	RestArea(aAreaDA1)
	RestArea(aArea)
Return lRet
