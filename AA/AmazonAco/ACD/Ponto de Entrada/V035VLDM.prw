#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"

User Function V035VLDM()
	Local lRet := .T.
	Local cQry := ""
	Local cCodInv := CBA->CBA_CODINV 
	Local lInvAb := .F.
	Local aArea := GetArea()
	
	//Verifica se existe lançamento de inventário para este mestre
	If !(FVerSB7())
		VtAlert("Existe ajuste de inventário lançado para este mestre!")
		lRet := .F.
	Else

		If CBA->CBA_STATUS>="2"
			If !FContOk()
				If FVerContAb(cCodInv)
					VtAlert("Existem itens com contagem em aberto")
					lRet := .F.
				EndIf
			EndIf
		EndIf
	EndIf 

	RestArea(aArea)
Return lRet


//Verificar se pode ir para a proxima contagem
Static Function FVerContAb(cCodInv)
	Local lRet := .F.
	Local cQry :=""
	Local cQryAlias := "QRY" 
	Local cIn := Iif( FUltCont()>1,'3','0')

	cQry+= " SELECT * FROM "+RetSQLName("CBA")+" CBA "
	cQry+= " INNER JOIN ( "
	cQry+= " SELECT CBB_CODINV,CBB_STATUS FROM "+RetSQLName("CBB")+" CBB "
	cQry+= " WHERE CBB.D_E_L_E_T_=''  "
	cQry+= " AND CBB_STATUS<2       "
	cQry+= " GROUP BY CBB.CBB_CODINV,CBB_STATUS "
	cQry+= " UNION ALL           "
	cQry+= " SELECT CBA_CODINV,CBA_STATUS FROM "+RetSQLName("CBA")+" CBA "
	cQry+= " WHERE CBA.D_E_L_E_T_=''        "
	cQry+= " AND CBA.CBA_DATA='"+DtoS(dDataBase)+"' "
	cQry+= " AND CBA.CBA_STATUS IN ("+cIn+") "
	cQry+= " GROUP BY CBA.CBA_CODINV,CBA_STATUS "
	cQry+= " ) AS CBB "
	cQry+= " ON CBB.CBB_CODINV=CBA.CBA_CODINV "
	cQry+= " WHERE CBA.D_E_L_E_T_='' "
	cQry+= " AND CBA_DATA='"+DtoS(dDataBase)+"' "
	cQry+= " AND CBA.CBA_CODINV='"+cCodInv+"' "

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cQryAlias,.T.,.T.)

	lRet:=(cQryAlias)->(Eof())
	(cQryAlias)->(DbCloseArea(cQryAlias))
Return lRet

//Verificar todas as contagens contadas
Static Function FContOk()
	Local cQry :=""
	Local cQryAlias := "QRY"
	Local nTotREG :=0
	Local lRet := .F.

	cQry+= " SELECT CBA_STATUS FROM "+RetSQLName("CBA")+" CBA "
	cQry+= "  WHERE CBA.D_E_L_E_T_='' "
	cQry+= "  AND CBA_DATA='"+DtoS(dDataBase)+"' "
	cQry+= "  AND CBA_LOCAL="+CBA->CBA_LOCAL+" "
	cQry+= "  GROUP BY CBA_STATUS "
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cQryAlias,.T.,.T.)
	While !(cQryAlias)->(Eof())
		nTotREG++
		(cQryAlias)->(DbSkip())
	EndDo
	If nTotREG>1
		lRet := .F.
	Else
		(cQryAlias)->(DbGoTop())
		If (cQryAlias)->CBA_STATUS=="3"
			lRet := .T.
		EndIf	
	EndIf    
	(cQryAlias)->(DbCloseArea(cQryAlias))
Return lRet

//Verificar a contagem em andamento
Static Function FUltCont()  
	Local cQry :=""
	Local cQryAlias := "QRY"
	Local nRet := 0

	cQry+= " SELECT MAX(CBA_CONTR) AS ULT FROM "+RetSQLName("CBA")+" CBA "
	cQry+= "  WHERE CBA.D_E_L_E_T_=''     " 
	cQry+= "  AND CBA_LOCAL="+CBA->CBA_LOCAL+" "
	cQry+= "  AND CBA_DATA='"+DtoS(dDataBase)+"'" 

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cQryAlias,.T.,.T.)

	nRet := (cQryAlias)->ULT
	(cQryAlias)->(DbCloseArea(cQryAlias))
Return nRet

Static Function FVerSB7()
Local cQry :=""
Local cQryAlias := "QRY"
Local lRet

cQry+= " SELECT * FROM "+RetSQLName("SB7")+" SB7 "
cQry+= " WHERE SB7.D_E_L_E_T_='' "
cQry+= " AND B7_FILIAL='"+xFilial("SB7")+"' "
cQry+= " AND B7_DOC='"+CBA->CBA_CODINV+"' "
cQry+= " AND B7_LOCAL='"+CBA->CBA_LOCAL+"' "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cQryAlias,.T.,.T.)

lRet := (cQryAlias)->(Eof())
(cQryAlias)->(DbCloseArea(cQryAlias))
Return lRet