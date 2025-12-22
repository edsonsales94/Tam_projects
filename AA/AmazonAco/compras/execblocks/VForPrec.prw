#Include "rwmake.ch"

User Function VForPrec()
/*---------------------------------------------------------------------------------------------------------------------------------------------------
Função chamada pelo Gatilho D1_TES Sequencia 002
OBJETIVO 1: Verificar se o Produtos possui cadastro de Formação de Preço (Documento de Entrada) ;
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/


nPosCod    := AScan( aHeader , {|x| Trim(x[2]) == "D1_COD" })
nPosTES    := AScan( aHeader , {|x| Trim(x[2]) == "D1_TES" })

cTES := Acols[N][nPosTES]

If ! Alltrim(cTES) $ "132#133"
	
	If ! SZC->(DbSeek(xFilial("SZC")+Acols[N][nPosCod]))
		cTES := Space(03)
		MsgAlert("Item sem Cadastro de Produto x Formação de Preço!!!","ATENÇÃO")
	EndIf
	
EndIf

Return(cTes)
