
User Function AtuSZB()

DbSelectArea("SB1")
DbSetorder(1)

DbSelectArea("SZB")
DbSetorder(1)

Do While !SB1->(Eof())
	
	CorUltNFE(SB1->B1_COD)
	
	SB1->(DbSkip())
	
EndDo

Alert("Fim do Processamento....")

Return()

*----------------------------------------------------------------------------------------------*
Static Function CorUltNFE(cCod)
*----------------------------------------------------------------------------------------------*
cQRY := "SELECT * "
cQry += "FROM "+RetSqlName("SZB")+" ZB "
cQry += "WHERE ZB_FILIAL = '"+xFilial("SZB")+"' AND "
cQry += "ZB_COD = '"+cCod+"' AND "
cQry += "D_E_L_E_T_ <> '*' "
cQry += "ORDER BY R_E_C_N_O_ DESC"

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "QRY", .T., .F. )

DbSelectArea("QRY")

cDoc 	:= QRY->ZB_DOC
cSerie  := QRY->ZB_SERIE
cFornece:= QRY->ZB_FORNECE
cLoja	:= QRY->ZB_LOJA
cProduto:= QRY->ZB_COD
cItem 	:= QRY->ZB_ITEM

QRY->(DbSkip())

If !QRY->(Eof())
	
	nVUnitAnt := QRY->ZB_CUSTO
	nAquisAnt := QRY->ZB_AQUISIC
	
	If SZB->(DbSeek(xFilial("SZB")+cDOC+cSERIE+cFORNECE+cLOJA+cPRODUTO+cITEM))
		RecLock("SZB")
		SZB->ZB_UNITANT := nVUnitAnt
		SZB->ZB_AQUIANT := nAquisAnt
		MsUnLock()
	Endif
	
EndIf

QRY->(DbCloseArea())

Return()










