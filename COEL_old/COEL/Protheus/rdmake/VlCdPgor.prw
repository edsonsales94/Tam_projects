#INCLUDE 'TOTVS.CH'

/*
=========================================================================================================
Programa.: VldCndPg
Autor....: Andre da Silva Rodrigues
Data.....: 13/10/2015
Objetivo.: Ajustar a Tabela do Orçamento  de vendas conforme a condição de pagamento
Descrição: 
Uso......: SIGAFAT
         : Acrescentar no campo Cj_CONDPAG a validação de usuário (X3_VLDUSER) a função: U_VlCdPgor() 
=========================================================================================================
*/

User Function VlCdPgor()
Local lRet			:= .T.
Local aArea			:= GetArea()
Local cOldReadVar	:= ReadVar()
lOCAL cGcond		:= SA1->A1_TABELA

//__ReadVar := ""

If Type('M->CJ_CONDPAG') <> 'U' .and. ! Empty(M->CJ_CONDPAG)
	SE4->(dbSetOrder(1)) //E4_FILIAL+E4_CODIGO
	If SE4->(dbSeek(xFilial('SE4')+M->CJ_CONDPAG))
		DA0->(dbSetOrder(1)) //DA0_FILIAL+DA0_CODTAB
		If DA0->(dbSeek(xFilial('DA0') + SE4->E4_TABELA))
			If Type('M->CJ_TABELA') <> 'U'
				IF cGcond < "500" 
					M->CJ_TABELA := SE4->E4_TABELA
				Else
					M->CJ_TABELA := SA1->A1_TABELA
				Endif
				
				//Valida a nova tabela de Preços
				If MaVldTabPrc(SE4->E4_TABELA,M->CJ_CONDPAG,,M->CJ_EMISSAO)
					//Recalcula a Tabela de Preços
					//If ! 
					A415tabalt()
						//MsgAlert('Não foi possível recalcular o pedido de vendas, altere a tabela de preços para ' + SE4->E4_TABELA + '.')
						//lRet := .F.
					//EndIf
				Else
					//MsgAlert('a Tabela de Preços ' + SE4->E4_TABELA + ' NÃO é valida!')
					//lRet := .F.
				EndIf
			Else
				//MsgAlert('Não foi possível corrigir a Tabela de Preços')
			EndIf
		Else
			//Tabela de Preço inválida
			//MsgAlert('Tabela de Preço ' + SE4->E4_TABELA + ' Não existe, favor corrigir a tabela de preço da condição de pagamento!')
			//lRet := .F.
		EndIf
	Else
		//Condição de pagamento não existe
		//MsgAlert('Condição de pagamento não existe, favor corrigir!')
		//lRet := .F.
	EndIf
Else
	//Não foi possível validar a condição de pagamento
	//Aqui vc pode colocar um MsgAlert se quiser, se definir lRet como falso, o usuário não poderá sair do campo
	//lRet := .F.
EndIf

RestArea(aArea) //Retorna os arquivos na posição em que estavam antes de entrar na função

//__ReadVar := cOldReadVar

Return(lRet) //tem que retornar um valor lógico pois se trata de uma função de validação de campo.