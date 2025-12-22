#Include "Protheus.ch"
#Include "Parmtype.ch"
#Include "TBIConn.ch"
#Include "TBICode.ch"

/*/{Protheus.doc} HLAPCP05

Rotina responsável pela gravação as informações da matéria-prima para a rotina 'Necessidade de Compras'

@author 	Ectore Cecato - Totvs IP Jundiaí
@since 		28/03/2020
@version 	Protheus 12 - PCP

/*/

User Function HLAPCP05(aParam)

    If IsBlind()
    	
    	If !IsInCallStack("HLAPCP05")

	    	PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
	    	
	   		EstPAMP(.T.)
	    	
	    	RESET ENVIRONMENT

    	EndIf
    	
    Else
		Processa({|| EstPAMP(.F.)}, "Aguarde", "Calculando estrutura")
    EndIf

Return Nil 

Static Function EstPAMP(lJob)
	
	Local cAliasQry		:= GetNextAlias()
	Local cQuery 		:= ""
	Local cTpProd		:= AllTrim(SuperGetMV("ZZ_TPPRD", .F., "'MP', 'EM'")) 
	Local nQtdReg		:= 0

	cQuery := "WITH ESTRUTURA AS "+ CRLF
	cQuery += "( "+ CRLF
	cQuery += "		SELECT "+ CRLF 
	cQuery += "			SG1.G1_COD AS PROD_PA, SG1.G1_COD AS PROD_PI, SG1.G1_COMP AS PROD_MP, SG1.G1_QUANT AS QUANT,  "+ CRLF
	cQuery += "			SG1.G1_PERDA AS PERDA, SG1.G1_INI AS INICIO, SG1.G1_FIM AS FIM "+ CRLF
	cQuery += "		FROM "+ RetSqlTab("SG1") +" "+ CRLF
	cQuery += "		WHERE "+ CRLF
	cQuery += "			"+ RetSqlDel("SG1") +" "+ CRLF  
	cQuery += "			AND "+ RetSqlFil("SG1") +" "+ CRLF 
	cQuery += " "+ CRLF
	cQuery += "		UNION ALL "+ CRLF
	cQuery += " "+ CRLF 
	cQuery += "		SELECT "+ CRLF
	cQuery += "			SG1P.PROD_PA AS PROD_PA, SG1.G1_COD AS PROD_PI, SG1.G1_COMP AS PROD_MP, SG1P.QUANT * SG1.G1_QUANT AS QUANT, "+ CRLF
	cQuery += "			SG1.G1_PERDA AS PERDA, SG1.G1_INI AS INICIO, SG1.G1_FIM AS FIM "+ CRLF
	cQuery += "		FROM "+ RetSqlTab("SG1") +", ESTRUTURA SG1P "+ CRLF
	cQuery += "		WHERE "+ CRLF
	cQuery += "			"+ RetSqlDel("SG1") +" "+ CRLF
	cQuery += "			AND "+ RetSqlFil("SG1") +" "+ CRLF
	cQuery += "			AND SG1P.PROD_MP = SG1.G1_COD "+ CRLF
	cQuery += ") "+ CRLF
	cQuery += "SELECT "+ CRLF
	cQuery += "		ESTRUTURA.* "+ CRLF
	cQuery += "FROM ESTRUTURA "+ CRLF
	cQuery += "		INNER JOIN "+ RetSqlTab("SB1") +" "+ CRLF
	cQuery += "			ON	"+ RetSqlDel("SB1") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("SB1") +" "+ CRLF
	cQuery += "				AND SB1.B1_COD = ESTRUTURA.PROD_MP "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		SB1.B1_TIPO IN ("+ cTpProd +") "
	
	MemoWrite("\SQL\HLAPCP05.sql", cQuery)
		
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	TcSetField(cAliasQry, "INICIO", "D", 08, 00)
	TcSetField(cAliasQry, "FIM", 	"D", 08, 00)

	Count To nQtdReg
	
	If !lJob
	
		ProcRegua(nQtdReg + 1)

		IncProc("Excluindo estrutura")

	EndIf 

	ExcEstrut()

	(cAliasQry)->(DbGoTop())
	
	While !(cAliasQry)->(Eof())

		If !lJob
			IncProc("Produto "+ AllTrim((cAliasQry)->PROD_PA))
		EndIf 

		Z3C->(RecLock("Z3C", .T.))
			Z3C->Z3C_FILIAL	:= FWxFilial("Z3C")
			Z3C->Z3C_PRODPA := (cAliasQry)->PROD_PA
			Z3C->Z3C_PRODPI := (cAliasQry)->PROD_PI
			Z3C->Z3C_PRODMP := (cAliasQry)->PROD_MP
			Z3C->Z3C_QUANT  := (cAliasQry)->QUANT
			Z3C->Z3C_PERDA  := (cAliasQry)->PERDA
			Z3C->Z3C_INI    := (cAliasQry)->INICIO
			Z3C->Z3C_FIM    := (cAliasQry)->FIM
		Z3C->(MsUnlock())

		(cAliasQry)->(DbSkip())

	EndDo 

	(cAliasQry)->(DbCloseArea())

Return Nil 

Static Function ExcEstrut()
	
	Local cQuery := ""

	cQuery := "UPDATE "+ RetSqlName("Z3C") +" "+ CRLF
	cQuery += "SET "+ CRLF
	cQuery += "		D_E_L_E_T_ = '*', "+ CRLF
	cQuery += "		R_E_C_D_E_L_ = R_E_C_N_O_ "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		D_E_L_E_T_ = ' ' "+ CRLF
	
	MemoWrite("\SQL\ExcEstrut.sql", cQuery)
	
	If TcSqlExec(cQuery) != 0
		UserException(TCSQLError())
	Endif		
	
Return Nil
