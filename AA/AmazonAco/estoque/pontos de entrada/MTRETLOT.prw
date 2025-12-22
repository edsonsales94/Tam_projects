#INCLUDE "TOPCONN.CH"

User Function MTRETLOT()
Local cCodPro	 := PARAMIXB[1]
Local cLocal	 := PARAMIXB[2]
Local nQtd		 := PARAMIXB[3]
Local nQtd2UM	 := PARAMIXB[4]
Local nEmpenho   := PARAMIXB[5]
Local nEmpenho2  := PARAMIXB[6]
Local cLote		 := PARAMIXB[7]
Local cSBLote	 := PARAMIXB[8]
Local cEndere	 := PARAMIXB[9]
Local cNumSer	 := PARAMIXB[10]
Local cQuery := ""
Local cAliasQRY  := "MTRETLOT" 
Local lexec     := GetMv("MV_XBLQARM",.F.,1)

If lexec 
	If AllTrim(FunName()) $ "MATA440|MATA450||MATA455|MATA456"
		cQuery += "	SELECT * FROM "+RetSQLName("PA1")+" PA1 "
		cQuery += "		INNER JOIN "+RetSQLName("PA2")+" PA2 "
		cQuery += "		ON PA2.D_E_L_E_T_='' "
		cQuery += "		AND PA2_NUM=PA1.PA1_NUM "
		cQuery += "		INNER JOIN "+RetSqlName("CB8")+" CB8 ON  "
		cQuery += "		CB8.D_E_L_E_T_='' "
		cQuery += "		AND CB8.CB8_ORDSEP=PA2.PA2_NUM "
		cQuery += "		AND CB8.CB8_PEDIDO=PA1.PA1_PEDIDO "
		cQuery += "		AND CB8_ITEM=PA2.PA2_ITEM "
		cQuery += "		AND CB8.CB8_PROD=PA2.PA2_COD "
		cQuery += "		AND CB8.CB8_SALDOS=0 "
		cQuery += "		WHERE PA1.D_E_L_E_T_='' "
		cQuery += "		AND PA1.PA1_PEDIDO='"+SC6->C6_NUM+"' "
		cQuery += "		AND PA2.PA2_COD='"+cCodPro+"' "
		cQuery += "		AND PA2.PA2_ITEMPD='"+SC6->C6_ITEM+"' "  
		If !Empty( cEndere )
			cQuery += "		AND CB8.CB8_LCALIZ='"+cEndere+"' "  
		EndIf
		cQuery += "		AND CB8.CB8_LOTECT='"+cLote+"' "  
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQRY,.T.,.T.)
		
		If !(cAliasQRY)->(Eof())    
			nEmpenho := (cAliasQRY)->CB8_QTDORI 
			nEmpenho2 := ConvUM((cAliasQRY)->CB8_PROD,(cAliasQRY)->CB8_QTDORI ,0,2)	
		EndIf
		(cAliasQRY)->(DbCloseArea())
	EndIf
EndIf
Return {nEmpenho, nEmpenho2}