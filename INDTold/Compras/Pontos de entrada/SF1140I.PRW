#Include "Rwmake.ch"

/*
#############################################################################
±±ºPrograma  ³SF1140I   ºAutor  ³Microsiga           º Data ³  10/03/11   º±±
#############################################################################
±±ºDesc.     ³ Ponto de Entrada na atualizacao do cabecalho do            º±±
±±º          ³ pre-documento de entrada                                   º±±
#############################################################################
±±ºUso       ³ INDT                                                       º±±
#############################################################################
*/


User Function SF1140I() 
	Local cUser := SubStr(cUsuario,7,15)
	Local nValor := 0 
	SD1->(DbsetOrder(1))
	SD1->(DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
	While SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) .AND. !SD1->(Eof())
		nValor += SD1->D1_TOTAL
		SD1->(DbSkip())
	End
	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA))
	
	U_INCOMT03(SF1->F1_DOC,SF1->F1_SERIE,SA2->A2_NOME,cUser,TIME(),dDataBase,nValor,SF1->F1_EMISSAO)  

Return
