#INCLUDE "TOPCONN.CH"
/*---------------------------------------------------------------------------------------
{Protheus.doc} MTSLDLOT
Seleção de Lotes / Endereços

@class		Nenhum
@from 		Nenhum
@param    	Nenhum
@attrib    	Nenhum
@protected  Nenhum
@return    	Nenhum
@sample   	Nenhum
@obs      	Nenhum
@menu    	Nenhum
@history    Nenhum
---------------------------------------------------------------------------------------*/
User Function MTSLDLOT()

Local lUtiliza	:= .T.
Local lexec     := GetMv("MV_XBLQARM",.F.,1)
Local cAliasQRY := "SLDPOREND"
Local aStruSBF  := SBF->(dbStruct())
Local cQuery  := ""
	
If lexec 	
	If AllTrim(FunName()) $ "MATA440|MATA450||MATA455|MATA456"     

		cQuery := ""
		
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
		cQuery += "		AND PA2.PA2_COD='"+PARAMIXB[1]+"' "
		cQuery += "		AND PA2.PA2_ITEMPD='"+SC6->C6_ITEM+"' "  
		If !Empty( ParamIXB[05] )
			cQuery += "		AND CB8.CB8_LCALIZ='"+PARAMIXB[5]+"' "  
		EndIf
		cQuery += "		AND CB8.CB8_LOTECT='"+PARAMIXB[3]+"' "  
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQRY,.T.,.T.)
		
		lUtiliza := !(cAliasQRY)->(Eof())    
		(cAliasQRY)->(DbCloseArea())
	EndIf
EndIf

Return( lUtiliza )
