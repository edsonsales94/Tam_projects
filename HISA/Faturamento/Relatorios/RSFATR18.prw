#INCLUDE "rwmake.ch"
/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ RSFATR18   ¦ Autor ¦Orismar Silva         ¦ Data ¦ 11/03/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ RELPERC   ¦ Relatório de Faturamento por cliente x produto no período.    ¦¦¦
¦¦¦           ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/
User Function RSFATR18()      

	Private oReport, oSection1
	Private nQtd     := 0
	Private nTotQtd  := 0

	oReport := ReportDef()
	If !Empty(oReport:uParam)
		Pergunte(oReport:uParam,.F.)
	EndIf
	oReport:PrintDialog()


Return

//=================================================================================
// relatorio de produtividade - formato personalizavel
//=================================================================================
Static Function ReportDef()
	Local cPerg   := "RSFATR18"
	Local cTitulo := 'Relatório de Faturamento por Cliente x Produto'

	// Cria as perguntas no SX1                                            
	CriaSx1(cPerg)
	Pergunte(cPerg,.F.)

	oReport := TReport():New("RSFATR18", cTitulo, cPerg , {|oReport| PrintReport(oReport)},"Emitirá Relatório de Faturamento por Cliente x Produto")

	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:ShowHeader()

	oSection1 := TRSection():New(oReport,"Relatório de Faturamento por cliente x produto",{""})
	oSection1:SetTotalInLine(.F.)

	TRCell():new(oSection1, "C_ANOMES" , "", "DATA"  	     ,,10)
	TRCell():new(oSection1, "C_CNPJ"   , "", "CNPJ"          ,,25)
	TRCell():new(oSection1, "C_CLIENTE", "", "CLIENTE"       ,,10)
	TRCell():new(oSection1, "C_CONTA"  , "", "CONTA"         ,,15)
	TRCell():new(oSection1, "C_CODGLB" , "", "CÓDIGO GLOBAL" ,,10)
	TRCell():new(oSection1, "C_COD"    , "", "PRODUTO"   	 ,,10)      
    TRCell():new(oSection1, "C_QTD"    , "", "QUANTIDADE"    ,,15)			
	TRCell():new(oSection1, "C_VALOR"  , "", "VALOR"         ,,15)		
return (oReport)

//=================================================================================
// definicao para impressao do relatorio personalizado 
//=================================================================================
Static Function PrintReport(oReport)

	Local nReg
	Local nQtd   := 0
	Local nValor := 0

	oSection1 := oReport:Section(1)

	oSection1:Init()
	oSection1:SetHeaderSection(.T.)   
    if mv_par09 = 1//Considera Venda/Devolução - Venda
    
	   _cQuery :=" SELECT D2_COD,B1_CODJP,B1_DESC,D2_CLIENTE,A1_CONTA,RDATA, SUM(D2_QUANT) D2_QUANT, SUM(TOTAL) TOTAL FROM ( "
	   _cQuery +=" SELECT D2_COD,B1_CODJP,B1_DESC,D2_CLIENTE,A1_CONTA,SUBSTRING(D2_EMISSAO,1,6) RDATA, SUM(D2_QUANT) D2_QUANT ,SUM(D2_TOTAL) TOTAL "
       _cQuery +=" FROM "+ RetSqlName("SB1")+ " SB1 (NOLOCK), "+ RetSqlName("SD2")+" SD2 (NOLOCK), "+ RetSqlName("SF4")+" SF4 (NOLOCK), "+ RetSqlName("SA1")+" SA1 (NOLOCK) "	      
	   _cQuery +=" WHERE SB1.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*' AND SF4.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' 
	   _cQuery +=" AND D2_TIPO NOT IN ('B','D') 
	   _cQuery +=" AND D2_TES = F4_CODIGO AND F4_DUPLIC = 'S' AND D2_FILIAL = F4_FILIAL
	   _cQuery +=" AND D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA  AND A1_FILIAL =''
	   _cQuery +=" AND B1_COD = D2_COD      
	   _cQuery +=" AND D2_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	   _cQuery +=" AND LEFT(D2_EMISSAO,6) = '"+mv_par03+"'"
	   _cQuery +=" AND D2_COD BETWEEN '"+mv_par04+"' AND '"+mv_par05+"'"	
	   _cQuery +=" AND D2_FILIAL BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
	   _cQuery +=" AND D2_CF NOT IN "+ FormatIn(  mv_par10, ",")
	   _cQuery +=" GROUP BY D2_COD,B1_CODJP,B1_DESC,D2_CLIENTE,A1_CONTA,SUBSTRING(D2_EMISSAO,1,6) 
	   
	   if mv_par08 = 1//Inclui Devolução - Sim
	   
	      _cQuery +=" UNION ALL 
	      _cQuery +=" SELECT D1_COD,B1_CODJP,B1_DESC,D1_FORNECE AS D2_CLIENTE,A1_CONTA,SUBSTRING(D1_DTDIGIT,1,6) RDATA, -SUM(D1_QUANT) D2_QUANT , -SUM(D1_TOTAL-D1_VALDESC) TOTAL
          _cQuery +=" FROM "+ RetSqlName("SB1")+ " SB1 (NOLOCK), "+ RetSqlName("SD1")+" SD1 (NOLOCK), "+ RetSqlName("SF4")+" SF4 (NOLOCK), "+ RetSqlName("SA1")+" SA1 (NOLOCK) "	      	
	      _cQuery +=" WHERE SB1.D_E_L_E_T_ <> '*' AND SD1.D_E_L_E_T_ <> '*' AND SF4.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' 
	      _cQuery +=" AND D1_TES = F4_CODIGO AND D1_FILIAL = F4_FILIAL 
	      _cQuery +=" AND D1_FORNECE = A1_COD AND A1_FILIAL = '' AND D1_LOJA = A1_LOJA 
   	      _cQuery +=" AND B1_COD = D1_COD 
	      _cQuery +=" AND D1_TIPO = 'D' AND NOT (SD1.D1_TIPODOC >= '50' )  
	      _cQuery +=" AND D1_FORNECE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
   	      _cQuery +=" AND LEFT(D1_DTDIGIT,6) = '"+mv_par03+"'"                 
	      _cQuery +=" AND D1_COD BETWEEN '"+mv_par04+"' AND '"+mv_par05+"'"
	      _cQuery +=" AND D1_FILIAL BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
	      _cQuery +=" AND D1_CF NOT IN "+ FormatIn(  mv_par10, ",")
	      _cQuery +=" GROUP BY D1_COD,B1_CODJP,B1_DESC,D1_FORNECE,A1_CONTA,SUBSTRING(D1_DTDIGIT,1,6)
	   
	   endif
	else
	   _cQuery :=" SELECT D2_COD,B1_CODJP,B1_DESC,D2_CLIENTE,A1_CONTA,RDATA, SUM(D2_QUANT) D2_QUANT, SUM(TOTAL) TOTAL FROM ( "
	   _cQuery +=" SELECT D1_COD AS D2_COD,B1_CODJP,B1_DESC,D1_FORNECE AS D2_CLIENTE,A1_CONTA,SUBSTRING(D1_DTDIGIT,1,6) RDATA, -SUM(D1_QUANT) D2_QUANT , -SUM(D1_TOTAL-D1_VALDESC) TOTAL
       _cQuery +=" FROM "+ RetSqlName("SB1")+ " SB1 (NOLOCK), "+ RetSqlName("SD1")+" SD1 (NOLOCK), "+ RetSqlName("SF4")+" SF4 (NOLOCK), "+ RetSqlName("SA1")+" SA1 (NOLOCK) "	      	
	   _cQuery +=" WHERE SB1.D_E_L_E_T_ <> '*' AND SD1.D_E_L_E_T_ <> '*' AND SF4.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' 
	   _cQuery +=" AND D1_TES = F4_CODIGO AND D1_FILIAL = F4_FILIAL 
	   _cQuery +=" AND D1_FORNECE = A1_COD AND A1_FILIAL = '' AND D1_LOJA = A1_LOJA 
   	   _cQuery +=" AND B1_COD = D1_COD 
	   _cQuery +=" AND D1_TIPO = 'D' AND NOT (SD1.D1_TIPODOC >= '50' )  
	   _cQuery +=" AND D1_FORNECE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
   	   _cQuery +=" AND LEFT(D1_DTDIGIT,6) = '"+mv_par03+"'"                 
	   _cQuery +=" AND D1_COD BETWEEN '"+mv_par04+"' AND '"+mv_par05+"'"
	   _cQuery +=" AND D1_FILIAL BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
	   _cQuery +=" AND D1_CF NOT IN "+ FormatIn(  mv_par10, ",")
	   _cQuery +=" GROUP BY D1_COD,B1_CODJP,B1_DESC,D1_FORNECE,A1_CONTA,SUBSTRING(D1_DTDIGIT,1,6)
	
	endif   
	   _cQuery +=" ) A GROUP BY D2_COD,B1_CODJP,B1_DESC,D2_CLIENTE,A1_CONTA,RDATA
	   _cQuery +=" ORDER BY D2_CLIENTE,A1_CONTA,D2_COD
	
	*	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQuery)),"TRQ",.T.,.F.)
	
	If	!USED()
		MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
	EndIf

	count to nReg

	dbSelectArea("TRQ")
	dbGoTop()

	oReport:SetMeter(nReg)
	nQtd      := 0
    nValor    := 0

	While ! Eof()
	
		If oReport:Cancel()
			Exit
		EndIf		

	    oSection1:Cell("C_ANOMES"):SetValue(TRQ->RDATA)  		
        oSection1:Cell("C_CNPJ"):SetValue(Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"))	    
        oSection1:Cell("C_CLIENTE"):SetValue(TRQ->D2_CLIENTE)
        oSection1:Cell("C_CONTA"):SetValue(Transform(TRQ->A1_CONTA,"@R 9.9.99.99.9999")) 
        oSection1:Cell("C_CODGLB"):SetValue(TRQ->B1_CODJP)
        oSection1:Cell("C_COD"):SetValue(TRQ->D2_COD)
      	oSection1:Cell("C_QTD"):SetValue(TRQ->D2_QUANT)
      	oSection1:Cell("C_VALOR"):SetValue(TRQ->TOTAL)		
      	nQtd   += TRQ->D2_QUANT
      	nValor += TRQ->TOTAL
      	oReport:SkipLine()
      	oSection1:PrintLine() 
		oReport:IncMeter()
		dbSkip()		
	Enddo
	oSection1:Cell("C_ANOMES"):SetValue("")
	oSection1:Cell("C_CNPJ"):SetValue("")
    oSection1:Cell("C_CLIENTE"):SetValue("")
	oSection1:Cell("C_CONTA"):SetValue("")	
	oSection1:Cell("C_CODGLB"):SetValue("")
	oSection1:Cell("C_COD"):SetValue("")		
	oSection1:Cell("C_QTD"):SetValue("")		
	oSection1:Cell("C_VALOR"):SetValue("")		
	oReport:SkipLine()
	oSection1:PrintLine()
	*
	oSection1:Cell("C_ANOMES"):SetValue("")
	oSection1:Cell("C_CNPJ"):SetValue("")
    oSection1:Cell("C_CLIENTE"):SetValue("")
	oSection1:Cell("C_CONTA"):SetValue("")	
	oSection1:Cell("C_CODGLB"):SetValue("")
	oSection1:Cell("C_COD"):SetValue("")		
	oSection1:Cell("C_QTD"):SetValue(nQtd)		
	oSection1:Cell("C_VALOR"):SetValue(nValor)		
	oReport:SkipLine()
	oSection1:PrintLine()

	dbSelectArea("TRQ")
	dbCloseArea()
	oSection1:Finish()

Return

//-------------------------------------------------------------------
//  Ajusta o arquivo de perguntas SX1
//-------------------------------------------------------------------
Static Function CriaSx1(cPerg)

	u_HMPutSX1(cPerg, "01", PADR("Do Cliente        ",29)+"?" ,"","", "mv_ch1" , "C", 6  , 0, 0, "G", "","SA1", "", "", "mv_par01")
	u_HMPutSX1(cPerg, "02", PADR("Ate Cliente       ",29)+"?" ,"","", "mv_ch2" , "C", 6  , 0, 0, "G", "","SA1", "", "", "mv_par02")  
  	u_HMPutSX1(cPerg, "03", PADR("Periodo (AnoMes)  ",29)+"?" ,"","", "mv_ch3" , "C", 6  , 0, 0, "G", "",   "", "", "", "mv_par03")
	u_HMPutSX1(cPerg, "04", PADR("Do Produto        ",29)+"?" ,"","", "mv_ch4" , "C", 15 , 0, 0, "G", "","SB1", "", "", "mv_par04")
	u_HMPutSX1(cPerg, "05", PADR("Ate Produto       ",29)+"?" ,"","", "mv_ch5" , "C", 15 , 0, 0, "G", "","SB1", "", "", "mv_par05")  
	u_HMPutSX1(cPerg, "06", PADR("Da Filial         ",29)+"?" ,"","", "mv_ch6" , "C", 2  , 0, 0, "G", "","SM0", "", "", "mv_par06")
	u_HMPutSX1(cPerg, "07", PADR("Ate Filial        ",29)+"?" ,"","", "mv_ch7" , "C", 2  , 0, 0, "G", "","SM0", "", "", "mv_par07")
    u_HMPutSX1(cPerg, "08", PADR("Inclui Devolução  ",29)+"?" ,"","", "mv_ch8" , "N", 1  , 0, 1, "C", "",   "", "", "", "mv_par08","Sim","","","","Não")   	
    u_HMPutSX1(cPerg, "09", PADR("Considera Venda/Devolução  ",29)+"?" ,"","", "mv_ch9" , "N", 1  , 0, 1, "C", "",   "", "", "", "mv_par09","Venda","","","","Devolução")   	    
    u_HMPutSX1(cPerg, "10", PADR("Não consierda CFOP ",29)+"?" ,"","", "mv_chA" , "C", 30 , 0, 0, "G", "",   "", "", "", "mv_par10")

Return
