#include "Rwmake.ch"
/*/{protheus.doc}a261prod
Ponto de entrada usado na validação do produto - transferência de materiais
@author Adson Carlos
@since 04/01/2010
/*/
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ A261PROD   ¦ Autor ¦ Adson Carlos 		    ¦ Data ¦ 04/01/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada usado na validação do produto                ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function A261PROD()
Local lPyme    := Iif(Type("__lPyme") <> "U", __lPyme, .F.)
Local cCodOrig := If( ParamIXB[2] == 1 , ParamIXB[1], aCols[n,1])
Local cCodDest := If( ParamIXB[2] == 2 , ParamIXB[1], aCols[n,If(!lPyme,6,5)])
Local cLocOrig := aCols[n,4]
Local cLocDest := aCols[n,9]
Local cNCMOrig := ""
Local cNCMDest := ""
Local lRet     := .T.
Local cRet     := ParamIXB[1]

If !Empty(cCodOrig) .And. !Empty(cCodDest) .And. cCodOrig <> cCodDest
	
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+ cCodOrig))
	cNCMOrig:=SB1->(B1_POSIPI)
	
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+ cCodDest))
	cNCMDest:=SB1->(B1_POSIPI)
	
/*	If cNCMOrig <> cNCMDest
		Alert("Não é possivel realizar a transferência! Favor informar produtos com codigos iguais.")
		lRet := .F.
		aCols[n,1] := D3_COD
		aCols[n,2] := aCols[n,If(!lPyme,7,6)]
		aCols[n,3] := aCols[n,If(!lPyme,8,7)]
	EndIf
	*/
	If lRet .And. !( __cUserId $ GetMv("MV_XUSUTRA") )
		lRet := .F.
		
		Alert("Usuário sem permissão!")
		
	EndIf
	
Endif

//oGet:Refresh()

Return lRet

//
