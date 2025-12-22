#include "Protheus.ch"
/*/{protheus.doc}a260ini
Ponto de entrada usado na validação do produto-Rotina de Transferencia Interna	
@author Adson Carlos
@since 04/01/2010
/*/
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ A260INI    ¦ Autor ¦ Adson Carlos 			 ¦ Data ¦ 04/01/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada usado na validação do produto						¦¦¦
¦¦¦  			  ¦ Rotina de Transferencia Interna											¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function A260INI()
Local lRet := .T.
Local cNCMOrig := ""
Local cNCMDest := ""

// Caso codigo de origem seja diferente do destino

If !Empty(cCodOrig) .And. !Empty(cCodDest) .And. cCodOrig <> cCodDest
	
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+ cCodOrig))
	cNCMOrig:=SB1->(B1_POSIPI)
	
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+ cCodDest))
	cNCMDest:=SB1->(B1_POSIPI)
	
/*	If cNCMOrig <> cNCMDest
		
		Alert("Não é possivel realizar a transferência, favor informar produtos com codigos iguais.")
		lRet := .F.
		
	EndIf */
	
	If lRet .And. !( __cUserId $ GetMv("MV_XUSUTRA") )
		
			Alert("Usuário sem permissão para realizar transferencias entre Produtos diferentes!")
			lRet := .F.
		
	EndIf
	
	//    lRet := .F.  // CAIRO
Endif

Return lRet