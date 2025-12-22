#Include "Protheus.ch"
#Include "Parmtype.ch"

/*/{Protheus.doc} HLREST10

RelatÃ³rio da programaÃ§Ã£o das MP do MRP

@author 	Luciano Lamberti
@since 		19/08/2021
@version 	Protheus 12 - Estoque Custos / Injeção Plástica

/*/

User Function HLREST10()

    Local cPerg	:= "HLREST10"

    ValidPerg(cPerg)

    If Pergunte(cPerg, .T.)
        MsgRun("Aguarde, gerando planilha", "", {|| CursorWait(), GerPlan(), CursorArrow()})
    EndIf

Return Nil

Static Function GerPlan()

    Local aStru		:= {}
    Local aRegs		:= {}
    Local cArq		:= "EST" + SM0->M0_CODIGO + ".CSV"
    Local cLinha    := ""
    Local cQuery    := ""
    Local cAliasQry := GetNextAlias()

    

    aAdd(aStru, {"TIPO_MOVIMENTO",    	"C", TamSX3("D3_TM")[1],          TamSX3("D3_TM")[2]})
    aAdd(aStru, {"PRODUTO",  			"C", TamSX3("D3_COD")[1],         TamSX3("D3_COD")[2]})
    aAdd(aStru, {"DESCRICAO",    		"C", TamSX3("B1_DESC")[1],     	  TamSX3("B1_DESC")[2]})
	aAdd(aStru, {"DESC_INGLES",    		"C", TamSX3("B1_DESCHL")[1],      TamSX3("B1_DESCHL")[2]})
	aAdd(aStru, {"QUANTIDADE",    		"N", TamSX3("D3_QUANT")[1],       TamSX3("D3_QUANT")[2]})
	aAdd(aStru, {"ARMAZEM",    			"C", TamSX3("D3_LOCAL")[1],       TamSX3("D3_LOCAL")[2]})
	aAdd(aStru, {"DATA_EMISSAO",    	"D", TamSX3("D3_EMISSAO")[1],     TamSX3("D3_EMISSAO")[2]})
	aAdd(aStru, {"ORDEM_PRODUCAO",    	"C", TamSX3("D3_OP")[1],     	  TamSX3("D3_OP")[2]})
	aAdd(aStru, {"ESTORNO",    			"C", TamSX3("D3_ESTORNO")[1],     TamSX3("D3_ESTORNO")[2]})
	aAdd(aStru, {"PARCIAL_TOTAL",  		"C", TamSX3("D3_PARCTOT")[1],     TamSX3("D3_PARCTOT")[2]})
	aAdd(aStru, {"PERDA",    			"N", TamSX3("D3_PERDA")[1],       TamSX3("D3_PERDA")[2]})
    aAdd(aStru, {"MOTIVO",    			"C", TamSX3("BC_MOTIVO")[1],       TamSX3("BC_MOTIVO")[2]})
	aAdd(aStru, {"USUARIO",    			"C", TamSX3("D3_USUARIO")[1],     TamSX3("D3_USUARIO")[2]}) 
    aAdd(aStru, {"MOTIVO2",    			"C", TamSX3("D3_NUMSERI")[1],     TamSX3("D3_NUMSERI")[2]}) 

    
    cQuery := "SELECT " + CRLF
	cQuery += "	SD3.D3_TM AS TIPO_MOVIMENTO, " + CRLF
	cQuery += "	SD3.D3_COD AS PRODUTO, " + CRLF
	cQuery += "	SB1.B1_DESC AS DESCRICAO, " + CRLF
	cQuery += "	SB1.B1_DESCHL AS DESC_INGLES, " + CRLF
	cQuery += "	SD3.D3_QUANT AS QUANTIDADE, " + CRLF
	cQuery += "	SD3.D3_LOCAL AS ARMAZEM, " + CRLF
	cQuery += "	SD3.D3_EMISSAO AS DATA_EMISSAO, " + CRLF
	cQuery += "	SD3.D3_OP AS ORDEM_PRODUCAO, " + CRLF
	cQuery += "	SD3.D3_ESTORNO AS ESTORNO, " + CRLF
	cQuery += "	SD3.D3_PARCTOT AS PARCIAL_TOTAL, " + CRLF
	cQuery += "	SD3.D3_PERDA AS PERDA, " + CRLF
    
    cQuery += "	CASE SBC.BC_MOTIVO" + CRLF
    cQuery�+= "WHEN 'AM' THEN 'AMOSTRA' " + CRLF
    cQuery�+= "WHEN 'AS' THEN 'AMASSADO' " + CRLF
    cQuery�+= "WHEN 'BO' THEN 'BORRA' " + CRLF
    cQuery�+= "WHEN 'BR' THEN 'BATIDA/RISCO' " + CRLF
    cQuery�+= "WHEN 'BS' THEN 'BOLHAS SUPERFICIE' " + CRLF
    cQuery�+= "WHEN 'CI' THEN 'CORRENTE INVERSA' " + CRLF
    cQuery�+= "WHEN 'CO' THEN 'CONSEQUENCIA' " + CRLF
    cQuery�+= "WHEN 'DF' THEN 'DEFORMADO' " + CRLF
    cQuery�+= "WHEN 'EB' THEN 'ERRO BOBINAGEM' " + CRLF
    cQuery�+= "WHEN 'EC' THEN 'ERRO CORTE' " + CRLF
    cQuery�+= "WHEN 'EM' THEN 'ERRO MONTAGEM' " + CRLF
    cQuery�+= "WHEN 'ER' THEN 'ERRO CRAVAMENTO' " + CRLF
    cQuery�+= "WHEN 'ES' THEN 'ESPANADO' " + CRLF
    cQuery�+= "WHEN 'FA' THEN 'FIO AMASSADO' " + CRLF
    cQuery�+= "WHEN 'FC' THEN 'FALHA' " + CRLF
    cQuery�+= "WHEN 'FD' THEN 'FORA DIMENSAO' " + CRLF
    cQuery�+= "WHEN 'FH' THEN 'FALHA HUMANA' " + CRLF
    cQuery�+= "WHEN 'FM' THEN 'FALHA MAQUINA' " + CRLF
    cQuery�+= "WHEN 'FP' THEN 'FALHA PINTURA' " + CRLF
    cQuery�+= "WHEN 'FR' THEN 'FERRUGEM' " + CRLF
    cQuery�+= "WHEN 'LE' THEN 'LINHAS DE ENCONTRO' " + CRLF
    cQuery�+= "WHEN 'LM' THEN 'LIMPEZA DE MOLDE' " + CRLF
    cQuery�+= "WHEN 'MN' THEN 'MANCHA' " + CRLF
    cQuery�+= "WHEN 'MU' THEN 'MANCHA UMIDADE' " + CRLF
    cQuery�+= "WHEN 'OU' THEN 'OUTROS' " + CRLF
    cQuery�+= "WHEN 'OX' THEN 'OXIDADO' " + CRLF
    cQuery�+= "WHEN 'PA' THEN 'PROBLEMA NA INJETORA' " + CRLF
    cQuery�+= "WHEN 'PD' THEN 'PECA DERRUBADA' " + CRLF
    cQuery�+= "WHEN 'PI' THEN 'PROBLEMA INJECAO' " + CRLF
    cQuery�+= "WHEN 'PM' THEN 'PROBLEMA NO MOLDE' " + CRLF
    cQuery�+= "WHEN 'PQ' THEN 'PINTA E QUEIMA' " + CRLF
    cQuery�+= "WHEN 'PR' THEN 'PECA RACHADA' " + CRLF
    cQuery�+= "WHEN 'PU' THEN 'PURGA' " + CRLF
    cQuery�+= "WHEN 'QU' THEN 'QUEBRADO' " + CRLF
    cQuery�+= "WHEN 'RA' THEN 'RASGADO' " + CRLF
    cQuery�+= "WHEN 'RB' THEN 'REBARBA' " + CRLF
    cQuery�+= "WHEN 'RC' THEN 'RECHUPE' " + CRLF
    cQuery�+= "WHEN 'RI' THEN 'RISCO' " + CRLF
    cQuery�+= "WHEN 'RL' THEN 'REGULAGEM DO ALICATE DE CORTE' " + CRLF
    cQuery�+= "WHEN 'RN' THEN 'REFUGO INICIAL' " + CRLF
    cQuery�+= "WHEN 'RP' THEN 'REGULAGEM DE PARAMETROS' " + CRLF
    cQuery�+= "WHEN 'RS' THEN 'REGULAGEM DO SERVO' " + CRLF
    cQuery�+= "WHEN 'SC' THEN 'SEM CODIGO' " + CRLF
    cQuery�+= "WHEN 'SU' THEN 'SUJEIRA (POEIRA/OLEO)' " + CRLF
    cQuery�+= "WHEN 'TC' THEN 'TAMANHO CORRENTE' " + CRLF
    cQuery�+= "WHEN 'TE' THEN 'TESTE' " + CRLF
    cQuery�+= "WHEN 'TO' THEN 'TRY OUT' " + CRLF
    cQuery�+= "WHEN 'TR' THEN 'TRINCADO' " + CRLF
    cQuery�+= "WHEN 'TT' THEN 'TORTO' END AS [MOTIVO]," + CRLF
       
	cQuery += "	SD3.D3_USUARIO AS USUARIO, " + CRLF
    cQuery += "	SD3.D3_NUMSERI AS MOTIVO2 " + CRLF
	cQuery += "	FROM SD3010 SD3 LEFT JOIN SB1010 SB1 ON SD3.D3_COD = SB1.B1_COD  LEFT JOIN SBC010 SBC ON D3_OP = BC_OP AND D3_COD = BC_PRODUTO " + CRLF
	
    //cQuery += "	WHERE SD3.D3_EMISSAO = '" + DTOS(MV_PAR03) + "'  " + CRLF
    cQuery += "	WHERE SD3.D3_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "'  " + CRLF
    cQuery += "	AND SD3.D3_TIPO <> 'MO' " + CRLF
	cQuery += "	AND SD3.D_E_L_E_T_ = '' " + CRLF

	MemoWrite("\SQL\HLREST10.SQL",cQuery)

    MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAliasQry, .F., .T.)

    While !(cAliasQry)->(Eof())
	
		cLinha := Alltrim((cAliasQry)->TIPO_MOVIMENTO) +";"													
		cLinha += Alltrim((cAliasQry)->PRODUTO) +";"		     								      		
		cLinha += Alltrim((cAliasQry)->DESCRICAO) +";"	
		cLinha += Alltrim((cAliasQry)->DESC_INGLES) +";"	
		cLinha += Alltrim(Transform((cAliasQry)->QUANTIDADE, "@E 999,999.99")) +";"	
		cLinha += Alltrim((cAliasQry)->ARMAZEM) +";"	
		cLinha += Alltrim((cAliasQry)->DATA_EMISSAO) +";"	
		cLinha += Alltrim((cAliasQry)->ORDEM_PRODUCAO) +";"	
		cLinha += Alltrim((cAliasQry)->ESTORNO) +";"	
		cLinha += Alltrim((cAliasQry)->PARCIAL_TOTAL) +";"	
		cLinha += Alltrim(Transform((cAliasQry)->PERDA, "@E 999,999.99")) +";"		
        cLinha += Alltrim((cAliasQry)->MOTIVO) +";"	
		cLinha += Alltrim((cAliasQry)->USUARIO) +";"	
        cLinha += Alltrim((cAliasQry)->MOTIVO2) +";"	
        
		aAdd(aRegs, cLinha)
		
	    (cAliasQry)->(DbSkip())
	
    EndDo

    (cAliasQry)->(DbCloseArea())

    CriaExcel(aStru, aRegs, cArq)

Return Nil

/*
ÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœ
Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±
Â±Â±Ã‰Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã‘Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã‹Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã‘Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã‹Ã�Ã�Ã�Ã�Ã�Ã�Ã‘Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Â»Â±Â±
Â±Â±ÂºPrograma  Â³CriaExcel ÂºAutor  Â³Luciano Lamberti    Âº Data Â³  20/04/21   ÂºÂ±Â±
Â±Â±ÃŒÃ�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã˜Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�ÃŠÃ�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�ÃŠÃ�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Â¹Â±Â±
Â±Â±ÂºDesc.     Â³RelaÃ§Ã£o de Pedidos sem Saldo                                ÂºÂ±Â±
Â±Â±ÃŒÃ�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã˜Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Â¹Â±Â±
Â±Â±ÂºUso       Â³Generico 								                      ÂºÂ±Â±
Â±Â±ÃˆÃ�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Ã�Â¼Â±Â±
Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±
ÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸ
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
	    //IncProc("Aguarde! Gerando arquivo de integraÃ§Ã£o com Excel...")
	    aEval(aStru, {|e, nX| FWrite(nHandle, e[1] + If(nX < Len(aStru), ";", ""))})
	    
	    FWrite(nHandle, CRLF) // Pula linha
	
        For nX := 1 to Len(aRegs)

            //IncProc("Aguarde! Gerando arquivo de integraÃ§Ã£o com Excel...")
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
    aAdd(aRegs, {cPerg, "02", "OP atÃ©",         "OP atÃ©",       "OP atÃ©",       "MV_CH2", "C", 09, 0, 0, "G", "", "MV_PAR02", "","","","","","","","","","","","","","","","","","","","","","","","","XM0"})
    aAdd(aRegs, {cPerg, "03", "EmissÃ£o atÃ©",    "EmissÃ£o atÃ©",  "EmissÃ£o atÃ©",  "MV_CH2", "D", 10, 0, 0, "G", "", "MV_PAR03", "","","","","","","","","","","","","","","","","","","","","","","","","XM0"})
    aAdd(aRegs, {cPerg, "04", "EmissÃ£o atÃ©",    "EmissÃ£o atÃ©",  "EmissÃ£o atÃ©",  "MV_CH2", "D", 10, 0, 0, "G", "", "MV_PAR04", "","","","","","","","","","","","","","","","","","","","","","","","","XM0"})

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
