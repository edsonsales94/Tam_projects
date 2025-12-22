#Include 'Protheus.ch'

/*/{Protheus.doc} atuPerZJ

Atualiza as perguntas da SZJ caso o marcar todos seja alterado

@type function
@author André Oquendo - TOTVSIP
@since 03/10/2017

@return Lógico, Foi usado uma validação por isso precisamos retornar.

/*/

User Function atuPerZJ()

	For nT := 1 to 16
		M->&("ZJ_PERG"+StrZero(nT,2)) :=  M->ZJ_MARCATO
	Next

Return .T.

