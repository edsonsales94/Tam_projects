#Include "Protheus.ch"
#Include "TBIConn.ch"
#Include "TBICode.ch"

#Define DATADD    1
#Define HORA    2

#Define CODIGO  1
#Define LOJA    2
#Define NOME    3
#Define ID_CALC 4

/*/{Protheus.doc} HLAPCP06

Rotina respons�vel pelo c�lculo da necessidade de compras via schedule

@type 		function
@author 	Ectore Cecato - Totvs IP Jundia�
@since 		23/02/2021
@version 	Protheus 12 - PCP

/*/

User Function HLAPCP06(aParam)

	Default aParam := {"01", "01"}

	PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]

		CalcNecAuto()

	RESET ENVIRONMENT

Return Nil

Static Function CalcNecAuto()

	Local aDateTime := {}
    Local aFornec   := Fornecedores()
    Local cParDoc   := AllTrim(SuperGetMV("ZZ_PAR01NC", .F., "")) 
    Local cParLoc   := AllTrim(SuperGetMV("ZZ_PAR02NC", .F., "")) 
    Local cParPer   := SuperGetMV("ZZ_PAR03NC", .F., "")
    Local cAssunto  := "Necessidade de Compras"
    Local cTexto    := ""
    Local cPara     := AllTrim(SuperGetMV("ZZ_EMLNC", .F., "ectore.cecato@totvs.com.br")) 
    Local cCC       := ""
    Local cArquivo  := ""
    Local nItem     := 0

    Private aPeriodos   := {}
    Private aProdPA		:= {}	
	Private aCalcNec	:= {} 
	Private cDoc		:= ""
	Private cFornec		:= "" 
	Private cLoja		:= ""
	Private cLocal		:= ""
	Private dDtBase		:= CToD("")
	Private nPeriodos	:= 0
    
	aDateTime := FwTimeUF("SP",, .F.,, .T.)

	ConOut("[Necessidade de Compras] - In�cio: "+ DToC(SToD(aDateTime[DATADD])) +" - "+ aDateTime[HORA])

    cDoc 		:= cParDoc
    cLocal 		:= cParLoc
    //dDtBase		:= MonthSum(SToD(aDateTime[DATAD]), 1)           parametro para calcular o MRP somando 1 m�s adiante
    dDtBase		:= SToD(aDateTime[DATADD])                   //Luciano Lamberti - 01-03-2021
    nPeriodos	:= cParPer
        
    //Calculo periodos
    //StaticCall(HLAPCP01, CalcPeriod)
	&("StaticCall(HLAPCP01, CalcPeriod)")
    For nItem := 1 To Len(aFornec)
            
        cFornec := aFornec[nItem][CODIGO] 
        cLoja	:= aFornec[nItem][LOJA]

        ConOut("[Necessidade de Compras] - Documento: "+ cDoc +" | Fornecedor: "+ cFornec +"/"+ cLoja)

        //Calculo necessidade
        //StaticCall(HLAPCP01, CalcNec)
		&("StaticCall(HLAPCP01, CalcNec)")
        aFornec[nItem][ID_CALC] := IdCalcNec(cFornec, cLoja)

    Next nItem 

    //Monta corpo do email
    cTexto := MontaEmail(cDoc, aFornec)

    //Envia email de notifica��o
    U_EnvMail(cAssunto, cTexto, cPara, cCC, cArquivo)

	aDateTime := FwTimeUF("SP",, .F.,, .T.)

	ConOut("[Necessidade de Compras] - Fim: "+ DToC(SToD(aDateTime[DATADD])) +" - "+ aDateTime[HORA])

Return Nil

Static Function Fornecedores()

    Local aItem     := {}
    Local aFornec   := {}
    Local cTpProd	:= AllTrim(SuperGetMV("ZZ_TPPRD", .F., "'MP', 'EM'")) 
    Local cQuery    := ""
    Local cAliasQry := GetNextAlias()

    cQuery := "SELECT "
    cQuery += "     SB1.B1_FILIAL, SB1.B1_PROC, SB1.B1_LOJPROC, SA2.A2_NREDUZ "
    cQuery += "FROM "+ RetSqlTab("SB1") +" "
    cQuery += "     INNER JOIN "+ RetSqlTab("SB5") +" "
    cQuery += "         ON  "+ RetSqlDel("SB5") +" "
    cQuery += "             AND "+ RetSqlFil("SB5") +" "
    cQuery += "             AND SB5.B5_COD = SB1.B1_COD "
    cQuery += "     INNER JOIN "+ RetSqlTab("SA2") +" "
    cQuery += "         ON  "+ RetSqlDel("SA2") +" "
    cQuery += "             AND "+ RetSqlFil("SA2") +" "
    cQuery += "             AND SA2.A2_COD = SB1.B1_PROC "
    cQuery += "             AND SA2.A2_LOJA = SB1.B1_LOJPROC " 
    cQuery += "WHERE "
    cQuery += "     "+ RetSqlDel("SB1") +" "
    cQuery += "     AND "+ RetSqlFil("SB1") +" "
    cQuery += "     AND SB1.B1_PROC <> '' "
    cQuery += "     AND SB1.B1_LOJPROC <> '' "
    cQuery += "     AND (SB1.B1_TIPO IN ("+ cTpProd +") OR SB5.B5_ZZREV = 'T') "
    cQuery += "GROUP BY "
    cQuery += "     SB1.B1_FILIAL, SB1.B1_PROC, SB1.B1_LOJPROC, SA2.A2_NREDUZ "
    cQuery += "ORDER BY ""
    cQuery += "     SB1.B1_FILIAL, SB1.B1_PROC, SB1.B1_LOJPROC "
    cQuery := ChangeQuery(cQuery)

	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	While !(cAliasQry)->(Eof())

        aItem := {}

        aAdd(aItem, AllTrim((cAliasQry)->B1_PROC))
        aAdd(aItem, AllTrim((cAliasQry)->B1_LOJPROC))
        aAdd(aItem, AllTrim((cAliasQry)->A2_NREDUZ))
        aAdd(aItem, "")

        aAdd(aFornec, aItem)
        
        (cAliasQry)->(DbSkip())

    EndDo 

    (cAliasQry)->(DbCloseArea())

Return aFornec

Static Function IdCalcNec(cFornec, cLoja)

    Local cId       := ""
    Local cQuery    := ""
    Local cAliasQry := GetNextAlias()

    cQuery := "SELECT "
    cQuery += "     Z2B.Z2B_FILIAL, Z2B.Z2B_CODIGO "
    cQuery += "FROM "+ RetSqlTab("Z2B") +" "
    cQuery += "WHERE "
	cQuery += "		"+ RetSqlDel("Z2B") +" "
	cQuery += "		AND "+ RetSqlFil("Z2B") +" "
	cQuery += "		AND Z2B.Z2B_STATUS = 'A' "
	cQuery += "		AND Z2B.Z2B_FORNEC = '"+ cFornec +"' "
	cQuery += "		AND Z2B.Z2B_LOJA = '"+ cLoja +"' "
    cQuery += "GROUP BY "
    cQuery += "     Z2B.Z2B_FILIAL, Z2B.Z2B_CODIGO "
    cQuery := ChangeQuery(cQuery)

	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof())
        cId := AllTrim((cAliasQry)->Z2B_CODIGO)
    EndIf 

    (cAliasQry)->(DbCloseArea())

Return cId 

Static Function MontaEmail(cDoc, aFornec)

    Local cTexto := ""
    Local nItem  := 0

    cTexto := "<!DOCTYPE html>"
    cTexto += "<html>"
    cTexto += "<head>"
    cTexto += "<style>"
    cTexto += "table {"
    cTexto += "  font-family: arial, sans-serif;"
    cTexto += "  border-collapse: collapse;"
    cTexto += "  width: 100%;"
    cTexto += "}"
    cTexto += "td, th {"
    cTexto += "  border: 1px solid #dddddd;"
    cTexto += "  text-align: left;"
    cTexto += "  padding: 8px;"
    cTexto += "}"
    cTexto += "tr:nth-child(even) {"
    cTexto += "  background-color: #dddddd;"
    cTexto += "}"
    cTexto += "</style>"
    cTexto += "</head>"
    cTexto += "<body>"
    cTexto += "<h2>Documento: "+ cDoc +"</h2>"
    cTexto += "<table>"
    cTexto += "  <tr>"
    cTexto += "    <th>Fornecedor</th>"
    cTexto += "    <th>Nome</th>"
    cTexto += "    <th>ID C�lculo</th>"
    cTexto += "  </tr>"

    For nItem := 1 To Len(aFornec)

        If !Empty(aFornec[nItem][ID_CALC])

            cTexto += "<tr>"
            cTexto += "<td>"+ aFornec[nItem][CODIGO] +"/"+ aFornec[nItem][LOJA] +"</td>"
            cTexto += "<td>"+ aFornec[nItem][NOME] +"</td>"
            cTexto += "<td>"+ aFornec[nItem][ID_CALC] +"</td>"
            cTexto += "</tr>"
        
        EndIf 

    Next nItem 

    cTexto += "</table>"
    cTexto += "</body>"
    cTexto += "</html>"

Return cTexto
