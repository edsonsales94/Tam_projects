#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
 
User Function XPONR02
//
	MsApp():New('SIGAPON')
	oApp:CreateEnv()
	PtSetTheme("OCEAN")
	oApp:cStartProg := 'U_AAPONR02'
	//
	__lInternet := .T.
	oApp:Activate()
	//
Return
      
/*/{Protheus.doc} AAPONR02
Relatório - Previsão de Horas no Periodo por colaborador                     
@author Guilherme
@since 10/04/2024
@version 1.0
    @example
    u_AAPONR02()
Local nQuant   := 0
Local nValor   := 0
aAdd(aPergs, {1, "Qtde",  nQuant,  "@E 9,999",     "Positivo()", "", ".T.", 80,  .F.})
aAdd(aPergs, {1, "Valor", nValor,  "@E 99,999.99", "Positivo()", "", ".T.", 80,  .F.})
/*/
           
User Function AAPONR02()
    Local aArea      := GetArea()
    Local oReport
    Local aPergs   := {}
    Local cDataDe  := FirstDate(Date())
    Local cDataAt  := LastDate(Date())
    Local cMatDe   := Space(TamSX3('PC_MAT')[1])
    Local cMatAte  := StrTran(cMatDe, ' ', 'Z')
    Local cCCDe    := Space(TamSX3('PC_CC')[1])
    Local cCCAte   := StrTran(cCCDe, ' ', 'Z')
    Local cSalMin  := 1412.00
    Local cTxFPAS  := 3.2712
          
    //Adiciona os parâmetros
    aAdd(aPergs, {1, "Data De",        cDataDe,  "", ".T.", "",    ".T.", 80,  .F.})
    aAdd(aPergs, {1, "Data Ate",       cDataAt,  "", ".T.", "",    ".T.", 80,  .T.})
    aAdd(aPergs, {1, "Matricula De",   cMatDe,   "", ".T.", "SRA", ".T.", 100, .F.})
    aAdd(aPergs, {1, "Matricula Ate",  cMatAte,  "", ".T.", "SRA", ".T.", 100, .T.})
    aAdd(aPergs, {1, "C.de Custos De", cCCDe,    "", ".T.", "CTT", ".T.", 80,  .F.})
    aAdd(aPergs, {1, "C.de Custos Ate",cCCAte,   "", ".T.", "CTT", ".T.", 80,  .T.})
    aAdd(aPergs, {1, "Salario Mínimo", cSalMin,  "@E 99,999.99", "Positivo()", "", ".T.", 80,  .F.})
    aAdd(aPergs, {1, "Taxa FPAS",      cTxFPAS,  "@E 999.9999",  "Positivo()", "", ".T.", 80,  .F.})
    
    //Se a pergunta for confirmada
    If ParamBox(aPergs, "Informe os Parametros Abaixo:", , , , , , , , , .F., .F.)
        oReport := RptDef()
        oReport:PrintDialog()
    EndIf
      
    RestArea(aArea)
Return
 
Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	
	xMsg := "Previsão de Horas no Periodo em Aberto, por colaborador."
	oReport := TReport():New("AAPONR02",xMsg,,{|oReport| ReportPrint(oReport)},"Este relatorio ira imprimir o total de horas extras, por colaborador, no periodo aberto, bem como, a data máxima para sua quitação.") 
    oReport:SetPortrait()    
    oReport:SetTotalInLine(.T.)

	//Primeira seção: Dados da OP
 	oSection1:= TRSection():New(oReport, "C_Custo", {"TMP"},, .F., .T.)
    TRCell():New(oSection1, "c_CC",      "TMP", "C.Custo",      /*Picture*/, 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection1, "c_Desr",    "TMP", "Descricao",    /*Picture*/, 40,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection1, "c_PIni",    "TMP", "Per. Inicial", /*Picture*/, 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection1, "c_PFim",    "TMP", "Per. Final",   /*Picture*/, 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

    //Segunda seção: Relação dos Apontamemtos
   	oSection2:= TRSection():New(oReport, "Colaboradores", {"TMP"}, NIL, .F., .T.)
    TRCell():New(oSection2, "c_Matr",        "TMP", "Matricula",        /*Picture*/, 10,            /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_Nome",        "TMP", "Nome",             /*Picture*/, 40,            /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_Salario",     "TMP", "Salario",          "@E 999,999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_Pericul",     "TMP", "Periculosidade",   /*Picture*/, 20,            /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_Isalubr",     "TMP", "Isalubridade",     /*Picture*/, 20,            /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_Evento",      "TMP", "Evento",           /*Picture*/, 20,            /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_Percente",    "TMP", "Percente",         /*Picture*/, 20,            /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_TotHoras",    "TMP", "TotHoras",         "@E 999,999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_AdcPeri",     "TMP", "AdcPeri",          "@E 999,999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_AdcInsa",     "TMP", "AdcInsa",          "@E 999,999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_SalComp",     "TMP", "SalComposto",      "@E 999,999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_SalHora",     "TMP", "Sal / 220",        "@E 999,999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_ValHrExt",    "TMP", "Valor Hr %",       "@E 999,999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_TotHrExt",    "TMP", "Valor Hr Ext",     "@E 999,999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_VTotHrExt",   "TMP", "Total Horas",      "@E 999,999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_DSR",         "TMP", "DSR ",             "@E 999,999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_TotGeral",    "TMP", "TotGeral",         "@E 999,999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_INSS",        "TMP", "INSSS",            "@E 999,999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_TERC",        "TMP", "TERC",             "@E 999,999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_FPAS",        "TMP", "FPAS",             "@E 999,999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_FGTS",        "TMP", "FGTS",             "@E 999,999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_CUSTOT",      "TMP", "Custo Total",      "@E 999,999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

    oReport:SetTotalInLine(.F.)
       
    //Quebra  por seção
	oSection1:SetPageBreak(.T.)
	oSection1:SetTotalText(" ")				
Return(oReport)
 
Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	Local cQuery    := ""		
    cQuery += " SELECT "
    cQuery += " C_CUSTO, DESCR, MATR, NOME, SALARIO, PERICULOSIDADE, INSALUBRIDADE, PC_PD, PC_PERCENT, TOTHRS, ADCPERI, ADCINSA, SAL_COMPOSTO, SAL_HORA, " 
    cQuery += " VALHREXT, TOTHREXT, VALTOTHE, DSR, TOTGERAL, INSS, TERC, FPAS, FGTS, (TOTGERAL+INSS+TERC+FPAS+FGTS) CUSTO "
    cQuery += " FROM ( SELECT "
    cQuery += " C_CUSTO, DESCR, MATR, NOME, SALARIO, PERICULOSIDADE, INSALUBRIDADE, PC_PD, PC_PERCENT, TOTHRS, ADCPERI, ADCINSA, "
    cQuery += " SAL_COMPOSTO, SAL_HORA, VALHREXT, TOTHREXT, VALTOTHE, DSR, TOTGERAL, "
    cQuery += " (TOTGERAL / 100.0 * 20.0 ) INSS, "
    cQuery += " (TOTGERAL / 100.0 * 5.8 ) TERC, "
    cQuery += " (TOTGERAL / 100.0 * cast('"+cValToChar(mv_par08)+"' as float)) FPAS, "
    cQuery += " (TOTGERAL / 100.0 * 8.0 ) FGTS "
    cQuery += " FROM ( SELECT "
    cQuery += " C_CUSTO, DESCR, MATR, NOME, SALARIO, PERICULOSIDADE, INSALUBRIDADE, PC_PD, PC_PERCENT, TOTHRS, ADCPERI, ADCINSA, SAL_COMPOSTO, SAL_HORA, VALHREXT, TOTHREXT, "
    cQuery += " (TOTHREXT * TOTHRS) VALTOTHE, "
    cQuery += " ((TOTHREXT * TOTHRS) / 26.0 * 4.0 ) DSR, "
    cQuery += " (TOTHREXT * TOTHRS) + ((TOTHREXT * TOTHRS) / 26.0 * 4.0 ) TOTGERAL "
    cQuery += " FROM ( SELECT "
    cQuery += " C_CUSTO, DESCR, MATR, NOME, SALARIO, PERICULOSIDADE, INSALUBRIDADE, PC_PD, PC_PERCENT, TOTHRS, ADCPERI, ADCINSA, "
    cQuery += " (SALARIO+ADCPERI+ADCINSA) SAL_COMPOSTO, "
    cQuery += " (SALARIO+ADCPERI+ADCINSA)/220.0 SAL_HORA, "
    cQuery += " ((SALARIO+ADCPERI+ADCINSA)/220.0)/100.0*PC_PERCENT VALHREXT, "
    cQuery += " (((SALARIO+ADCPERI+ADCINSA)/220.0) + ((SALARIO+ADCPERI+ADCINSA)/220.0)/100.0*PC_PERCENT) TOTHREXT "
    cQuery += " FROM ( SELECT "
    cQuery += " C_CUSTO, DESCR, MATR, NOME, SALARIO, PERICULOSIDADE, INSALUBRIDADE, PC_PD, PC_PERCENT, TOTHRS, "
    cQuery += " CASE WHEN PERICULOSIDADE <> 'NAO' THEN (SALARIO / 100.0 * 30.0 ) ELSE 0.0 END ADCPERI, "
    cQuery += " CASE WHEN INSALUBRIDADE  <> 'NAO' THEN ( cast('"+cValToChar(mv_par07)+"' as float) / 100.0 * 20.0 ) ELSE 0.0 END ADCINSA "
    cQuery += " FROM ( SELECT "
    cQuery += " C_CUSTO, DESCR, MATR, NOME, SALARIO, PERICULOSIDADE, INSALUBRIDADE, PC_PD, PC_PERCENT, (SALARIO/220.0) + (SALARIO/220*PC_PERCENT/100.0) VLHREXT, "
    cQuery += " (HR_QUANT + CONVERT(FLOAT,MN_QUANT)) TOTHRS, "
    cQuery += " ((SALARIO/220.0) + (SALARIO/220.0 * PC_PERCENT / 100.0) * (HR_QUANT + CONVERT(FLOAT,MN_QUANT))) AS CUSTO "
    cQuery += " FROM ( SELECT "
    cQuery += " C_CUSTO, DESCR, MATR, NOME, SALARIO, PERICULOSIDADE, INSALUBRIDADE, PC_PD, "
    cQuery += " HR_QUANT, LEFT(FORMAT(CASE WHEN MN_QUANT >= 60.0 THEN MN_QUANT / 60.0 ELSE 0 END,'0')+'.'+ "
    cQuery += " FORMAT(((MN_QUANT / 60.0)-CONVERT(INT,MN_QUANT / 60.0))*60.0,'00'),5) MN_QUANT, PC_PERCENT "
    cQuery += " FROM ( SELECT " 
    cQuery += " PC_CC C_CUSTO, CTT_DESC01 DESCR, PC_MAT MATR, NOME, SALARIO, PERICULOSIDADE, INSALUBRIDADE, SUM(HR_QUANTC) HR_QUANT, SUM(MN_QUANTC) * 100.0 MN_QUANT, "
    cQuery += " PC_PD, PC_PERCENT "
    cQuery += " FROM ( SELECT "
    cQuery += " PC_CC, CTT_DESC01, PC_MAT, RA_NOME NOME, RA_SALARIO SALARIO, "
    cQuery += " CASE WHEN RA_ADCPERI IN (' ','1') THEN 'NAO' ELSE 'SIM' END PERICULOSIDADE, "
    cQuery += " CASE WHEN RA_ADCINS  IN (' ','1') THEN 'NAO' "
    cQuery += "      WHEN RA_ADCINS = '2' THEN 'INSALUB. MINIMA' "
    cQuery += "      WHEN RA_ADCINS = '3' THEN 'INSALUB. MEDIA' "
    cQuery += " ELSE 'INSALUB. MAXIMA' END INSALUBRIDADE, "
    cQuery += " CAST(PC_DATA  AS DATE) DATA, PC_PD, "
    cQuery += " CONVERT(INT,PC_QUANTC) HR_QUANTC, (PC_QUANTC-CONVERT(INT,PC_QUANTC)) MN_QUANTC, PC_PERCENT "
    cQuery += " FROM "+RetSqlName("SPC") + "(NOLOCK) SPC "
    cQuery += " LEFT JOIN "+RetSqlName("SRA") + " SRA ON RA_MAT = SPC.PC_MAT "
    cQuery += " 	  AND SRA.RA_FILIAL = PC_FILIAL  "
    cQuery += " 	  AND SRA.D_E_L_E_T_ = '' "
    cQuery += " LEFT JOIN "+RetSqlName("CTT") + " CTT ON CTT_CUSTO = SPC.PC_CC "
    cQuery += " WHERE SPC.D_E_L_E_T_ = '' "
    cQuery += "       AND PC_FILIAL = '" + xFilial("SPC") + "' "  
    cQuery += "       AND PC_DATA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' " 
    cQuery += "       AND PC_MAT  BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' " 
    cQuery += "       AND PC_CC   BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' " 
    cQuery += " AND PC_PD  IN ('211','212','213','214','215') "
    cQuery += " ) AS SALDO1 "
    cQuery += " GROUP BY PC_CC, CTT_DESC01, PC_MAT, NOME, PC_PD, PC_PERCENT, SALARIO, PERICULOSIDADE, INSALUBRIDADE "
    cQuery += " ) AS SALDO2 "
    cQuery += " ) AS SALDO3 "
    cQuery += " ) AS SALDO4 "
    cQuery += " ) AS SALDO5 "
    cQuery += " ) AS SALDO6 "
    cQuery += " ) AS SALDO7 "
    cQuery += " ) AS SALDO8 "
    cQuery += " ORDER BY C_CUSTO, MATR "

    dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"TMP",.T.,.T.) 
    TcSetField( "TMP", "PC_DATA", "D", 8, 0 )

    //qout(cQry)
	
	dbSelectArea("TMP")
    TMP->(dbGoTop())
	
    oReport:SetMeter(TMP->(RecCount())) 
 
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection1:Init()
 
		oReport:IncMeter()
					
		xCC	:= TMP->C_CUSTO
        IncProc("Imprimindo C.Custo: "+Alltrim(xCC))
		
		//imprimo a primeira seção: C. de Custos
		oSection1:Cell("c_CC"):SetValue(xCC)
        oSection1:Cell("c_Desr"):SetValue(Tmp->DESCR)
        oSection1:Cell("c_PIni"):SetValue(MV_PAR01)
        oSection1:Cell("c_PFim"):SetValue(MV_PAR02)
		oSection1:Printline()
		
		//inicializo a segunda seção
		oSection2:init()
		
		While !Eof() .And. xCC == TMP->C_CUSTO
			
            oReport:IncMeter()		

            IncProc("Imprimindo Matriculas " + alltrim(TMP->C_CUSTO))

            oSection2:Cell("c_Matr"):SetValue(TMP->MATR)
			oSection2:Cell("c_Nome"):SetValue(TMP->NOME)
            oSection2:Cell("c_Salario"):SetValue(TMP->SALARIO)
			oSection2:Cell("c_Pericul"):SetValue(TMP->PERICULOSIDADE)
            oSection2:Cell("c_Isalubr"):SetValue(TMP->INSALUBRIDADE)
            oSection2:Cell("c_Evento"):SetValue(TMP->PC_PD)
            oSection2:Cell("c_Percente"):SetValue(TMP->PC_PERCENT)
            oSection2:Cell("c_TotHoras"):SetValue(TMP->TOTHRS)
            oSection2:Cell("c_AdcPeri"):SetValue(TMP->ADCPERI)
            oSection2:Cell("c_AdcInsa"):SetValue(TMP->ADCINSA)
            oSection2:Cell("c_SalComp"):SetValue(TMP->SAL_COMPOSTO)
            oSection2:Cell("c_SalHora"):SetValue(TMP->SAL_HORA)
            oSection2:Cell("c_ValHrExt"):SetValue(TMP->VALHREXT)
            oSection2:Cell("c_TotHrExt"):SetValue(TMP->TOTHREXT)
            oSection2:Cell("c_VTotHrExt"):SetValue(TMP->VALTOTHE)
            oSection2:Cell("c_DSR"):SetValue(TMP->DSR)
            oSection2:Cell("c_TotGeral"):SetValue(TMP->TOTGERAL)
            oSection2:Cell("c_INSS"):SetValue(TMP->INSS)
            oSection2:Cell("c_TERC"):SetValue(TMP->TERC)
            oSection2:Cell("c_FPAS"):SetValue(TMP->FPAS)
            oSection2:Cell("c_FGTS"):SetValue(TMP->FGTS)
            oSection2:Cell("c_CUSTOT"):SetValue(TMP->CUSTO)
            oSection2:Printline()
	
 			TMP->(dbSkip())

 		EndDo		
 		oSection2:Finish() //finalizo a segunda seção para que seja reiniciada para o proximo registro
 		oReport:ThinLine() //imprimo uma linha para separar uma seção da outra
        oReport:SkipLine(2)
 		oSection1:Finish() //finalizo a primeira seção
	Enddo
Return
