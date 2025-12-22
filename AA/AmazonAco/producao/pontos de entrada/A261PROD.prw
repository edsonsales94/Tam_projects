#include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ A261PROD   ¦ Autor ¦ Adson Carlos         ¦ Data ¦ 04/01/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada usado na validação do produto                ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function A261PROD()
	Local cCodOrig := If( ParamIXB[2] == 1 , ParamIXB[1], aCols[n,1])
	Local cCodDest := If( ParamIXB[2] == 2 , ParamIXB[1], aCols[n,If(Type("lPyme") <> "U" .And. !lPyme,6,5)])
	Local lRet     := .T.
	Local cRet     := ParamIXB[1]
	Local cUsers   := Alltrim(GetMV("MV_XUMOVME"))//MV_XUMOVME
	

	If !(RetCodUsr()$cUsers)
		If !Empty(cCodOrig) .And. !Empty(cCodDest) .And. cCodOrig <> cCodDest
			lRet := .F.
			aCols[n,1] := D3_COD
			aCols[n,2] := aCols[n,If(Type("lPyme") <> "U" .And. !lPyme,7,6)]
			aCols[n,3] := aCols[n,If(Type("lPyme") <> "U" .And. !lPyme,8,7)]
			Alert("Não é possivel realizar a transferência! Favor informar produtos com codigos iguais.")
		Endif
	EndIf
	
	oGet:Refresh()
	
Return lRet
