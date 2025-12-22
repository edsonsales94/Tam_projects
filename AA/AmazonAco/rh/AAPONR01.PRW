#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
 
User Function xAAPONR01
//
	MsApp():New('SIGAPON')
	oApp:CreateEnv()
	PtSetTheme("OCEAN")
	oApp:cStartProg := 'U_AAPONR01'
	//
	__lInternet := .T.
	oApp:Activate()
	//
Return
      
/*/{Protheus.doc} AAPONR01
Relatório - Saldos do Banco de Horas por colaborador                     
@author Guilherme
@since 22/03/2024
@version 1.0
    @example
    u_AAPONR01()
/*/
           
User Function AAPONR01()
    Local aArea      := GetArea()
    Local oReport
    Local aPergs   := {}
    Local cDataDe  := FirstDate(Date())
    Local cDataAt  := LastDate(Date())
    Local cMatDe   := Space(TamSX3('PI_MAT')[1])
    Local cMatAte  := StrTran(cMatDe, ' ', 'Z')
    Local cCCDe    := Space(TamSX3('PI_CC')[1])
    Local cCCAte   := StrTran(cCCDe, ' ', 'Z')
          
    //Adiciona os parâmetros
    aAdd(aPergs, {1, "Data De",        cDataDe,  "", ".T.", "",    ".T.", 80,  .F.})
    aAdd(aPergs, {1, "Data Ate",       cDataAt,  "", ".T.", "",    ".T.", 80,  .T.})
    aAdd(aPergs, {1, "Matricula De",   cMatDe,   "", ".T.", "SRA", ".T.", 100, .F.})
    aAdd(aPergs, {1, "Matricula Ate",  cMatAte,  "", ".T.", "SRA", ".T.", 100, .T.})
    aAdd(aPergs, {1, "C.de Custos De", cCCDe,    "", ".T.", "CTT", ".T.", 80,  .F.})
    aAdd(aPergs, {1, "C.de Custos Ate",cCCAte,   "", ".T.", "CTT", ".T.", 80,  .T.})
    
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
	
	xMsg := "Saldo acumulado de Banco de Horas por colaborador."
	oReport := TReport():New("AAPONR01",xMsg,,{|oReport| ReportPrint(oReport)},"Este relatorio ira imprimir o Saldo Acumulado de Banco de Horas, por colaborador, no periodo aberto, bem como, a data máxima para sua quitação.") 
    oReport:SetPortrait()    
    oReport:SetTotalInLine(.T.)

	//Primeira seção: Dados da OP
 	oSection1:= TRSection():New(oReport, "C_Custo", {"TMP"},, .F., .T.)
    TRCell():New(oSection1, "c_CC",      "TMP", "C.Custo",      /*Picture*/, 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection1, "c_Desr",    "TMP", "Descricao",    /*Picture*/, 40,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection1, "c_PIni",    "TMP", "Per. Inicial", /*Picture*/, 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection1, "c_PFim",    "TMP", "Per. Final",   /*Picture*/, 20,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

	//Segunda seção: Componentes da OP
    //cAlign          Alinhamento da célula. "LEFT", "RIGHT" e "CENTER"
   	oSection2:= TRSection():New(oReport, "Colaboradores", {"TMP"}, NIL, .F., .T.)
    TRCell():New(oSection2, "c_Matr",       "TMP", "Matricula",     /*Picture*/, 10,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_Nome",       "TMP", "Nome",          /*Picture*/, 40,        /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_SldAnt",     "TMP", "Sld Anterior",  "@E 999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_Debito",     "TMP", "Debito",        "@E 999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_Credito",    "TMP", "Credito",       "@E 999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_Saldo",      "TMP", "Saldo",         "@E 999.99", 20,        /*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_Validade",   "TMP", "Validade",      /*Picture*/, 20,        /*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSection2, "c_Restam",     "TMP", "Restam",        /*Picture*/, 20,        /*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
    cQuery += " C_CUSTO, DESCR, MATR, NOME, "
    cQuery += " HR_ANT  + ((MN_ANT  - CAST(MN_ANT AS INT) )  / 100*60.00) + CAST(MN_ANT AS INT) SLDANT, "
    cQuery += " HR_ANTD + ((MN_ANTD - CAST(MN_ANTD AS INT) ) / 100*60.00) + CAST(MN_ANTD AS INT) SLDANTD, "
    cQuery += " HR_DEB  + ((MN_DEB  - CAST(MN_DEB AS INT) )  / 100*60.00) + CAST(MN_DEB AS INT) DEBITO, "
    cQuery += " HR_CRE  + ((MN_CRE  - CAST(MN_CRE AS INT) )  / 100*60.00) + CAST(MN_CRE AS INT) CREDITO, "
    cQuery += " VALIDADE, RESTAM "
    cQuery += " FROM ( "
    cQuery += "     SELECT "
    cQuery += "     PI_CC C_CUSTO, CTT_DESC01 DESCR, PI_MAT MATR, NOME, "
    cQuery += "     SUM(HR_ANT)  HR_ANT,  SUM(CAST(MN_ANT AS INT)  + (MN_ANT -  CAST(MN_ANT AS INT))  * 100/60.00) MN_ANT, "
    cQuery += "     SUM(HR_ANTD) HR_ANTD, SUM(CAST(MN_ANTD AS INT) + (MN_ANTD - CAST(MN_ANTD AS INT)) * 100/60.00) MN_ANTD, "
    cQuery += "     SUM(HR_DEB)  HR_DEB,  SUM(CAST(MN_DEB AS INT)  + (MN_DEB -  CAST(MN_DEB AS INT))  * 100/60.00) MN_DEB, "
    cQuery += "     SUM(HR_CRE)  HR_CRE,  SUM(CAST(MN_CRE AS INT)  + (MN_CRE -  CAST(MN_CRE AS INT))  * 100/60.00) MN_CRE, "
    cQuery += "     CAST(VALIDADE AS DATE) VALIDADE, DATEDIFF(MONTH, GETDATE(), VALIDADE) RESTAM "
    cQuery += "     FROM ( "
    cQuery += "         SELECT "
    cQuery += "         PI_CC, CTT_DESC01, PI_MAT, RA_NOME NOME, CAST(PI_DATA  AS DATE) DATA, PI_PD, "
    cQuery += "         CASE WHEN PI_DATA < '"+DTOS(mv_par01)+"' AND P9_TIPOCOD IN ('1','3') THEN CONVERT(INT,PI_QUANT) ELSE 0 END AS HR_ANT,
    cQuery += "         CASE WHEN PI_DATA < '"+DTOS(mv_par01)+"' AND P9_TIPOCOD IN ('1','3') THEN (PI_QUANT-CONVERT(INT,PI_QUANT)) ELSE 0 END AS MN_ANT,
    cQuery += "         CASE WHEN PI_DATA < '"+DTOS(mv_par01)+"' AND P9_TIPOCOD = '2' THEN CONVERT(INT,PI_QUANT) ELSE 0 END AS HR_ANTD, "
    cQuery += "         CASE WHEN PI_DATA < '"+DTOS(mv_par01)+"' AND P9_TIPOCOD = '2' THEN (PI_QUANT-CONVERT(INT,PI_QUANT)) ELSE 0 END AS MN_ANTD, "
    cQuery += "         CASE WHEN P9_TIPOCOD = '2' AND PI_DATA >= '"+DTOS(mv_par01)+"' THEN CONVERT(INT,PI_QUANT) ELSE 0 END AS HR_DEB, "
    cQuery += "         CASE WHEN P9_TIPOCOD = '2' AND PI_DATA >= '"+DTOS(mv_par01)+"' THEN (PI_QUANT-CONVERT(INT,PI_QUANT)) ELSE 0 END AS MN_DEB, "
    cQuery += "         CASE WHEN P9_TIPOCOD IN ('1','3')  AND PI_DATA >= '"+DTOS(mv_par01)+"' THEN CONVERT(INT,PI_QUANT) ELSE 0 END AS HR_CRE, "
    cQuery += "         CASE WHEN P9_TIPOCOD IN ('1','3')  AND PI_DATA >= '"+DTOS(mv_par01)+"'  THEN (PI_QUANT-CONVERT(INT,PI_QUANT)) ELSE 0 END AS MN_CRE, "
    cQuery += "         DATEADD(month,6,X6_CONTEUD) AS VALIDADE "
    cQuery += "         FROM " + RetSqlName("SPI") + " SPI (NOLOCK) "
    cQuery += "         INNER JOIN " + RetSqlName("SRA") + " SRA (NOLOCK) ON RA_MAT  = PI_MAT AND RA_FILIAL = PI_FILIAL AND SRA.D_E_L_E_T_ = '' "
    cQuery += "         INNER JOIN " + RetSqlName("CTT") + " CTT (NOLOCK) ON CTT_CUSTO = PI_CC  AND CTT.D_E_L_E_T_ = '' "
    cQuery += "         INNER JOIN " + RetSqlName("SP9") + " SP9 (NOLOCK) ON P9_CODIGO = PI_PD  AND SP9.D_E_L_E_T_ = '' "
    cQuery += "         INNER JOIN SX6" + cEmpAnt + "0 SX6 (NOLOCK) ON SX6.D_E_L_E_T_ = '' AND SX6.X6_VAR='MV_PEINIBH' "
    cQuery += "         WHERE SPI.D_E_L_E_T_ = '' "
    cQuery += "             AND PI_FILIAL = '" + xFilial("SPI") + "' "  
    cQuery += "             AND PI_DATA BETWEEN SX6.X6_CONTEUD AND '"+DTOS(mv_par02)+"' "
    cQuery += "             AND PI_MAT  BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' " 
    cQuery += "             AND PI_CC   BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' " 
    cQuery += "         ) AS SALDO1 "
    cQuery += "         GROUP BY PI_CC, CTT_DESC01, PI_MAT, NOME, VALIDADE "
    cQuery += "     ) AS SALDO2 "
    cQuery += " ORDER BY C_CUSTO, MATR "
    
    dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"TMP",.T.,.T.) 
    TcSetField( "TMP", "PI_DATA", "D", 8, 0 )
	
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

            xRestam := StrZero(TMP->RESTAM,2) + Iif(TMP->RESTAM > 1," Meses","Mes")

            // Calculao do Saldo Anterior
            xHrSldAnt  := INT(TMP->SLDANT) - INT(TMP->SLDANTD)
            xMnSldAntC := ((TMP->SLDANT-INT(TMP->SLDANT)) - (TMP->SLDANTD-INT(TMP->SLDANTD))) 
            xMnSldAntS := Iif(xMnSldAntC<0,Iif((1-xMnSldAntC)>=0.6,xMnSldAntC-0.4,xMnSldAntC),Iif(xMnSldAntC>=0.6,xMnSldAntC+0.4,xMnSldAntC))
            xSaldoAnt  := (xHrSldAnt + xMnSldAntS)

            // Calculo do Saldo Atual
            xHr_Sld  := INT(xSaldoAnt) - INT(TMP->DEBITO) + INT(TMP->CREDITO)
            xMn_SldC := ((xSaldoAnt-INT(xSaldoAnt)) - (TMP->DEBITO-INT(TMP->DEBITO)) + (TMP->CREDITO-INT(TMP->CREDITO))) 
            xMn_SldS := Iif(xMn_SldC<0,Iif((1-xMn_SldC)>=0.6,xMn_SldC-0.4,xMn_SldC),Iif(xMn_SldC>=0.6,xMn_SldC+0.4,xMn_SldC))
            xSaldo   := (xHr_Sld + xMn_SldS)
            //xHr_Sld  := INT(TMP->SLDANT) - INT(TMP->DEBITO) + INT(TMP->CREDITO)
            //xMn_SldC := ((TMP->SLDANT-INT(TMP->SLDANT)) - (TMP->DEBITO-INT(TMP->DEBITO)) + (TMP->CREDITO-INT(TMP->CREDITO))) 
            //xMn_SldS := Iif(xMn_SldC<0,Iif((1-xMn_SldC)>=0.6,xMn_SldC-0.4,xMn_SldC),Iif(xMn_SldC>=0.6,xMn_SldC+0.4,xMn_SldC))
            //xSaldo   := (xHr_Sld + xMn_SldS)
          
            IncProc("Imprimindo Matriculas " + alltrim(TMP->MATR))
			
            oSection2:Cell("c_Matr"):SetValue(TMP->MATR)
			oSection2:Cell("c_Nome"):SetValue(TMP->NOME)
           // oSection2:Cell("c_SldAnt"):SetValue(TMP->SLDANT)
           oSection2:Cell("c_SldAnt"):SetValue(xSaldoAnt)
			oSection2:Cell("c_Debito"):SetValue(TMP->DEBITO)
            oSection2:Cell("c_Credito"):SetValue(TMP->CREDITO)
            oSection2:Cell("c_Saldo"):SetValue(xSaldo)
            oSection2:Cell("c_Validade"):SetValue(TMP->VALIDADE)
            oSection2:Cell("c_Restam"):SetValue(xRestam)

            oSection2:Printline()
	
 			TMP->(dbSkip())

 		EndDo		
 		oSection2:Finish() //finalizo a segunda seção para que seja reiniciada para o proximo registro
 		oReport:ThinLine() //imprimo uma linha para separar uma seção da outra
 		oSection1:Finish() //finalizo a primeira seção
	Enddo
Return
