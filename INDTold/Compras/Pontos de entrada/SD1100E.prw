#include "RWMAKE.CH"

/*
#############################################################################
±±ºPrograma  ³SD1100E   ºAutor  ³Microsiga           º Data ³  07.12.10   º±±
#############################################################################
±±ºDesc.     ³ PE executado após a confirmação da Exclusão do Documento deº±±
±±º          ³ entrada e será usado para excluir da tabela SZ6 o Objetivo º±±
±±º          ³ e Justificativa vinculado ao documento de entrada.         º±±
±±º          ³                                                            º±±
#############################################################################
±±ºUso       ³ COMPRAS - Documento de Entrada                             º±±
#############################################################################
*/

User function SD1100E     
	Local cAlias:= Alias()    
	Local nRecno:= Recno()    
	Local nIndex:= IndexOrd() 
	Local cPedido,uChave
	uChave:= SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA 
	dbSelectArea("SZ6")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ6")+"4"+uChave)
		RecLock("SZ6",.F.)
		dbDelete()
		MsUnLock()
	Endif   
	  	  
	dbSelectArea(cAlias)
	dbSetOrder(nIndex)
	dbGoto(nRecno)
	
Return
