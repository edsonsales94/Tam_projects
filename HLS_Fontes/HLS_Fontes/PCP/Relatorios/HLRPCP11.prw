#Include "Protheus.ch"
#Include "Parmtype.ch"

/*/{Protheus.doc} HLRPCP11

Relatório da programação das MP do MRP

@author 	Ectore Cecato - Totvs IP Jundiaí
@since 		03/05/2021
@version 	Protheus 12 - PCP

/*/

User Function HLRPCP11()

    Local cPerg	:= "HLRPCP11"

    ValidPerg(cPerg)

    If Pergunte(cPerg, .T.)
        MsgRun("Aguarde, gerando planilha", "", {|| CursorWait(), GerPlan(), CursorArrow()})
    EndIf

Return Nil

Static Function GerPlan()

    Local aStru		:= {}
    Local aRegs		:= {}
    Local cArq		:= "MRP" + SM0->M0_CODIGO + ".CSV"
    Local cLinha    := ""
    Local cQuery    := ""
    Local cAliasQry := GetNextAlias()

    aAdd(aStru, {"PRODUTO",    "C", TamSX3("B1_COD")[1],       TamSX3("B1_COD")[2]})
    aAdd(aStru, {"DESCRICAO",  "C", TamSX3("B1_DESC")[1],      TamSX3("B1_DESC")[2]})
    aAdd(aStru, {"GRUPO",      "C", TamSX3("BM_DESC")[1],     TamSX3("BM_DESC")[2]})
    aAdd(aStru, {"ARMAZEM",    "C", TamSX3("D4_LOCAL")[1],     TamSX3("D4_LOCAL")[2]})
    aAdd(aStru, {"DIA 01",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 02",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 03",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 04",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 05",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 06",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 07",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 08",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 09",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 10",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 11",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 12",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 13",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 14",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 15",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 16",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 17",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 18",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 19",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 20",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 21",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 22",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 23",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 24",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 25",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 26",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 27",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 28",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 29",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 30",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    aAdd(aStru, {"DIA 31",     "N", TamSX3("D4_QTDEORI")[1],   TamSX3("D4_QTDEORI")[2]})
    
    cQuery := "SELECT "
    cQuery += "     * "
    cQuery += "FROM ( "+ CRLF
    cQuery += "     SELECT "+ CRLF
    cQuery += "         SB1MP.B1_COD AS MP, "+ CRLF
    cQuery += "         SB1MP.B1_DESC AS DESC_MP, "+ CRLF
    cQuery += "         SBM.BM_DESC AS GRUPO, "+ CRLF
    cQuery += "         SD4.D4_LOCAL,  "+ CRLF
    cQuery += "         SD4.D4_QTDEORI, "+ CRLF
    cQuery += "         'D'+ SUBSTRING(SC2.C2_DATPRI, 7,2) AS DIA "+ CRLF
    cQuery += "     FROM "+ RetSqlTab("SC2") +" "+ CRLF
    cQuery += "         INNER JOIN "+ RetSqlName("SB1") +" SB1PA "+ CRLF
    cQuery += "		        ON	SB1PA.D_E_L_E_T_ = ' ' "+ CRLF
    cQuery += "			        AND SB1PA.B1_FILIAL = '"+ FWxFilial("SB1") +"' "+ CRLF
    cQuery += "			        AND SB1PA.B1_COD = SC2.C2_PRODUTO "+ CRLF
    cQuery += "         INNER JOIN "+ RetSqlTab("SD4") +" "+ CRLF
    cQuery += "		        ON	SD4.D_E_L_E_T_ = ' ' "+ CRLF
    cQuery += "			        AND SD4.D4_FILIAL = '"+ FWxFIlial("SD4") +"' "+ CRLF
    cQuery += "			        AND SD4.D4_OP = SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN "+ CRLF
    cQuery += "         INNER JOIN "+ RetSqlName("SB1") +" SB1MP "+ CRLF
    cQuery += "		        ON	SB1MP.D_E_L_E_T_ = ' ' "+ CRLF
    cQuery += "			        AND SB1MP.B1_FILIAL = '"+ FWxFilial("SB1") +"' "+ CRLF
    cQuery += "			        AND SB1MP.B1_COD = SD4.D4_COD	 "+ CRLF
    cQuery += "         INNER JOIN "+ RetSqlName("SBM") +" SBM "+ CRLF
    cQuery += "		        ON	SBM.D_E_L_E_T_ = ' ' "+ CRLF
    cQuery += "			        AND SBM.BM_FILIAL = '"+ FWxFilial("SBM") +"' "+ CRLF
    cQuery += "			        AND SBM.BM_GRUPO = SB1MP.B1_GRUPO	 "+ CRLF
    cQuery += "     WHERE  "+ CRLF
    cQuery += "         SC2.D_E_L_E_T_ = ' ' "+ CRLF
    cQuery += "         AND SC2.C2_FILIAL = '"+ FWxFilial("SC2") +"' "+ CRLF
    cQuery += "         AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "+ CRLF
 // cQuery += "         AND SC2.C2_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "'  "+ CRLF
    cQuery += "         AND SC2.C2_DATPRI BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "'  "+ CRLF
    cQuery += ") AS MRP "+ CRLF
    cQuery += "PIVOT ( "+ CRLF
    cQuery += "     SUM(D4_QTDEORI) "+ CRLF
    cQuery += "	    FOR DIA IN ( "+ CRLF
    cQuery += "		    [D01], [D02], [D03], [D04], [D05], [D06], [D07], [D08], [D09], [D10], [D11], [D12], [D13], [D14], [D15], [D16], [D17], [D18], [D19], [D20], [D21], [D22], [D23], [D24], [D25], [D26], [D27], [D28], [D29], [D30], [D31] "+ CRLF
    cQuery += "	    ) "+ CRLF
    cQuery += ") AS MRP2 "

	MemoWrite("\SQL\HLRPCP11.SQL",cQuery)

    MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAliasQry, .F., .T.)

    While !(cAliasQry)->(Eof())
	
		cLinha := Alltrim((cAliasQry)->MP) +";"													
		cLinha += Alltrim((cAliasQry)->DESC_MP) +";"
        cLinha += Alltrim((cAliasQry)->GRUPO) +";"			     								      		
		cLinha += Alltrim((cAliasQry)->D4_LOCAL) +";"	
        cLinha += cValToChar((cAliasQry)->D01) +";"	
        cLinha += cValToChar((cAliasQry)->D02) +";"	
        cLinha += cValToChar((cAliasQry)->D03) +";"	
        cLinha += cValToChar((cAliasQry)->D04) +";"	
        cLinha += cValToChar((cAliasQry)->D05) +";"	
        cLinha += cValToChar((cAliasQry)->D06) +";"	
        cLinha += cValToChar((cAliasQry)->D07) +";"	
        cLinha += cValToChar((cAliasQry)->D08) +";"	
        cLinha += cValToChar((cAliasQry)->D09) +";"	
        cLinha += cValToChar((cAliasQry)->D10) +";"	
        cLinha += cValToChar((cAliasQry)->D11) +";"	
        cLinha += cValToChar((cAliasQry)->D12) +";"	
        cLinha += cValToChar((cAliasQry)->D13) +";"	
        cLinha += cValToChar((cAliasQry)->D14) +";"	
        cLinha += cValToChar((cAliasQry)->D15) +";"	
        cLinha += cValToChar((cAliasQry)->D16) +";"	
        cLinha += cValToChar((cAliasQry)->D17) +";"	
        cLinha += cValToChar((cAliasQry)->D18) +";"	
        cLinha += cValToChar((cAliasQry)->D19) +";"	
        cLinha += cValToChar((cAliasQry)->D20) +";"	
        cLinha += cValToChar((cAliasQry)->D21) +";"	
        cLinha += cValToChar((cAliasQry)->D22) +";"	
        cLinha += cValToChar((cAliasQry)->D23) +";"	
        cLinha += cValToChar((cAliasQry)->D24) +";"	
        cLinha += cValToChar((cAliasQry)->D25) +";"	
        cLinha += cValToChar((cAliasQry)->D26) +";"	
        cLinha += cValToChar((cAliasQry)->D27) +";"	
        cLinha += cValToChar((cAliasQry)->D28) +";"	
        cLinha += cValToChar((cAliasQry)->D29) +";"	
        cLinha += cValToChar((cAliasQry)->D30) +";"	
        cLinha += cValToChar((cAliasQry)->D31) +";"	
        
		aAdd(aRegs, cLinha)
		
	    (cAliasQry)->(DbSkip())
	
    EndDo

    (cAliasQry)->(DbCloseArea())

    CriaExcel(aStru, aRegs, cArq)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³CriaExcel ºAutor  ³Luciano Lamberti    º Data ³  20/04/21   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³Relação de Pedidos sem Saldo                                º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³Generico 								                      º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaExcel(aStru, aRegs, cArq)

    Local cDirDocs 	:= MsDocPath()
    Local cPath		:= AllTrim(GetTempPath())
    Local oExcelApp := Nil
    Local nHandle   := 0
    Local nX        := 0

    //ProcRegua(Len(aRegs)+2)

    nHandle := MsfCreate( "C:\totvs\" + cArq , 0 )

    If nHandle > 0
	
	    // Grava o cabecalho do arquivo
	    //IncProc("Aguarde! Gerando arquivo de integração com Excel...")
	    aEval(aStru, {|e, nX| FWrite(nHandle, e[1] + If(nX < Len(aStru), ";", ""))})
	    
	    FWrite(nHandle, CRLF) // Pula linha
	
        For nX := 1 to Len(aRegs)

            //IncProc("Aguarde! Gerando arquivo de integração com Excel...")
            FWrite(nHandle, aRegs[nX])
            FWrite(nHandle, CRLF) // Pula linha

        Next nX
	
         //IncProc("Aguarde! Abrindo o arquivo..." )
        
        FClose(nHandle)
        
        CpyS2T(cDirDocs +"\totvs\"+ cArq, cPath, .T.)
        
        If ApOleClient("MsExcel")
            
            MsgAlert("Arquivo: "+ AllTrim(cArq) +" criado com sucesso!")
            
            oExcelApp := MsExcel():New()

            oExcelApp:WorkBooks:Open("C:\totvs\"+ cArq) // Abre a planilha
            oExcelApp:SetVisible(.T.)

        Else
            MsgAlert("Excel nao instalado!")
        EndIf

    Else
        MsgAlert( "Falha na criacao do arquivo" )
    Endif

Return Nil

Static Function ValidPerg(cPerg)

    Local aArea     := GetArea()
    Local aAreaSX1  := SX1->(GetArea())
    Local aRegs     := {}
    Local nI        := 0
    Local nJ        := 0

    DbSelectArea("SX1")

    SX1->(DbSetOrder(1))

    cPerg := Padr(cPerg, Len(SX1->X1_GRUPO))

    aAdd(aRegs, {cPerg, "01", "OP de ",         "OP de ",       "OP de ",       "MV_CH1", "C", 09, 0, 0, "G", "", "MV_PAR01", "","","","","","","","","","","","","","","","","","","","","","","","","XM0"})
    aAdd(aRegs, {cPerg, "02", "OP até",         "OP até",       "OP até",       "MV_CH2", "C", 09, 0, 0, "G", "", "MV_PAR02", "","","","","","","","","","","","","","","","","","","","","","","","","XM0"})
    aAdd(aRegs, {cPerg, "03", "Emissão até",    "Emissão até",  "Emissão até",  "MV_CH2", "D", 10, 0, 0, "G", "", "MV_PAR03", "","","","","","","","","","","","","","","","","","","","","","","","","XM0"})
    aAdd(aRegs, {cPerg, "04", "Emissão até",    "Emissão até",  "Emissão até",  "MV_CH2", "D", 10, 0, 0, "G", "", "MV_PAR04", "","","","","","","","","","","","","","","","","","","","","","","","","XM0"})

    For nI := 1 to Len(aRegs)

        If !SX1->(DbSeek( cPerg + aRegs[nI, 2]))

            RecLock("SX1", .T.)
        
            For nJ := 1 to FCount()
                
                If nJ <= Len(aRegs[nI])
                    FieldPut(nJ, aRegs[nI, nJ])
                Endif

            Next nJ
            
            MsUnlock("SX1")

        Endif
    
    Next nI

    //dbSelectArea(_sAlias)

    RestArea(aAreaSX1)
    RestArea(aArea)

Return Nil
