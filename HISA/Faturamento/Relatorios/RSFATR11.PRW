#INCLUDE "rwmake.ch"
/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ RSFATR11   ¦ Autor ¦Orismar Silva         ¦ Data ¦ 18/11/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ RELPERC   ¦ Relatório de Faturamento ANVISA                               ¦¦¦
¦¦¦           ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/
User Function RSFATR11()      

	Private oReport, oSection1
	Private nQtd     := 0
	Private nTotQtd  := 0
	Private aDados   := {}

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
	Local cPerg   := "RSFATR11"
	Local cTitulo := 'Relatório de Faturamento ANVISA'

	// Cria as perguntas no SX1                                            
	CriaSx1(cPerg)
	Pergunte(cPerg,.F.)

	oReport := TReport():New("RSFATR11", cTitulo, cPerg , {|oReport| PrintReport(oReport)},"Emitirá Relatório de Faturamento ANVISA")

	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:ShowHeader()

	oSection1 := TRSection():New(oReport,"Relatório de Faturamento ANVISA",{""})
	oSection1:SetTotalInLine(.F.)

	TRCell():new(oSection1, "C_COD"    , "", "CODGGREM"  	   ,,20)
	TRCell():new(oSection1, "C_ANO"    , "", "ANO"           ,,05)
	TRCell():new(oSection1, "C_MES"    , "", "MÊS" 	         ,,05)
	TRCell():new(oSection1, "C_TP"     , "", "TIPO CLIENTE" 	,,105)
	TRCell():new(oSection1, "C_QTD"    , "", "QUANTIDADE" 	,,15)
	TRCell():new(oSection1, "C_VALOR"  , "", "FATURAMENTO"	,,15)		
return (oReport)

//=================================================================================
// definicao para impressao do relatorio personalizado 
//=================================================================================
Static Function PrintReport(oReport)

	Local nReg, ix
	Local nQtd   := 0
	Local nValor := 0

	oSection1 := oReport:Section(1)

	oSection1:Init()
	oSection1:SetHeaderSection(.T.)   
	
   	if MV_PAR10 = 1
	   _cQuery :=" SELECT D2_CLIENTE CLIENTE,D2_LOJA LOJA,A1_NOME NOME ,A1_CGC CGC,A1_EST EST,A1_MUN MUN,SUBSTRING(D2_EMISSAO,5,2) MES,SUBSTRING(D2_EMISSAO,1,4) ANO,D2_COD COD, SUM(D2_QUANT) QUANT, SUM(D2_TOTAL) VALBRUT, A1_CONTA ,B1_DESC"
	else 
	   _cQuery :=" SELECT SUBSTRING(D2_EMISSAO,5,2) MES,SUBSTRING(D2_EMISSAO,1,4) ANO,D2_COD COD, SUM(D2_QUANT) QUANT, SUM(D2_TOTAL) VALBRUT, A1_CONTA,B1_DESC "
	endiF
	_cQuery +=" FROM "+ RetSqlName("SB1")+ " SB1 (NOLOCK), "+ RetSqlName("SD2")+" SD2 (NOLOCK), "+ RetSqlName("SF4")+" SF4 (NOLOCK), "+ RetSqlName("SA1")+" SA1 (NOLOCK) "
	_cQuery +=" WHERE SB1.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*' AND SF4.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' "
	cCfop := ALLTRIM(mv_par07)+","+ALLTRIM(mv_par08)+","+ALLTRIM(mv_par09)
    _cQuery +=" AND D2_CF IN " + FormatIn(  cCfop, ",")
	_cQuery +=" AND D2_TES = F4_CODIGO AND F4_DUPLIC = 'S' "
   	_cQuery +=" AND D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA "
	_cQuery +=" AND B1_COD = D2_COD "
    _cQuery +=" AND D2_FILIAL = F4_FILIAL "	
	_cQuery +=" AND A1_FILIAL = '' "
    _cQuery +=" AND D2_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
    _cQuery +=" AND D2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"
    _cQuery +=" AND D2_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
    if MV_PAR10 = 1
       _cQuery +=" GROUP BY D2_CLIENTE,D2_LOJA,A1_NOME,A1_CGC,A1_EST,A1_MUN,SUBSTRING(D2_EMISSAO,5,2),SUBSTRING(D2_EMISSAO,1,4),D2_COD, A1_CONTA,B1_DESC "
       _cQuery +=" ORDER BY D2_CLIENTE,D2_LOJA "
    else         
       _cQuery +=" GROUP BY SUBSTRING(D2_EMISSAO,5,2),SUBSTRING(D2_EMISSAO,1,4),D2_COD, A1_CONTA,B1_DESC "
       _cQuery +=" ORDER BY A1_CONTA "
    endif
    *	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQuery)),"TRQ",.T.,.F.)
	
	If	!USED()
		MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
	EndIf

	count to nReg

	dbSelectArea("TRQ")
	dbGoTop()

	oReport:SetMeter(nReg)

	While ! Eof()
	
		If oReport:Cancel()
			Exit
		EndIf
		
		
		nQtd      := 0
	    nValor    := 0
	    
		if MV_PAR10 = 1 //Codigo Cliente
		   cCliente  := TRQ->CLIENTE
		   cLoja     := TRQ->LOJA 
		   		
		   While ! Eof() .and.	cCliente = TRQ->CLIENTE .and. cLoja = TRQ->LOJA		      
              aAdd(aDados,{TRQ->CLIENTE,TRQ->LOJA,ALLTRIM(TRQ->NOME),TRQ->CGC,TRQ->COD,TRQ->ANO,TRQ->MES,TRQ->B1_DESC,TRQ->QUANT,TRQ->VALBRUT,ALLTRIM(TRQ->EST),ALLTRIM(TRQ->MUN)})
		      dbSkip()
		   Enddo

		else // Conta Contabil
		   
		   cContabil := TRQ->A1_CONTA
		   
		   While ! Eof() .and.	cContabil = TRQ->A1_CONTA
		      aAdd(aDados,{TRQ->A1_CONTA,TRQ->COD,TRQ->ANO,TRQ->MES,TRQ->B1_DESC,TRQ->QUANT,TRQ->VALBRUT})
		      dbSkip()		      
		   Enddo
		endif
	Enddo 
	dbSelectArea("TRQ")
	dbCloseArea()     
	*
	if MV_PAR10 = 1
	   _cQuery :=" SELECT D1_FORNECE CLIENTE,D1_LOJA LOJA,A1_NOME NOME ,A1_CGC CGC,A1_EST EST,A1_MUN MUN,SUBSTRING(D1_DTDIGIT,5,2) MES,SUBSTRING(D1_DTDIGIT,1,4) ANO,D1_COD COD, -SUM(D1_QUANT) QUANT, -SUM(D1_TOTAL-D1_VALDESC) VALBRUT, A1_CONTA,B1_DESC "
	else 
	   _cQuery :=" SELECT SUBSTRING(D1_DTDIGIT,5,2) MES,SUBSTRING(D1_DTDIGIT,1,4) ANO,D1_COD COD, -SUM(D1_QUANT) QUANT, -SUM(D1_TOTAL-D1_VALDESC) VALBRUT, A1_CONTA,B1_DESC "
	endif
	_cQuery +=" FROM "+ RetSqlName("SB1")+ " SB1 (NOLOCK), "+ RetSqlName("SD1")+" SD1 (NOLOCK), "+ RetSqlName("SF4")+" SF4 (NOLOCK), "+ RetSqlName("SA1")+" SA1 (NOLOCK) "
	_cQuery +=" WHERE SB1.D_E_L_E_T_ <> '*' AND SD1.D_E_L_E_T_ <> '*' AND SF4.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' "
	cCfop := ALLTRIM(mv_par07)+","+ALLTRIM(mv_par08)+","+ALLTRIM(mv_par09)
    _cQuery +=" AND D1_CF IN " + FormatIn(  cCfop, ",")          
    _cQuery +=" AND D1_TES = F4_CODIGO AND F4_DUPLIC = 'S' "
   	_cQuery +=" AND D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA "
	_cQuery +=" AND B1_COD = D1_COD "
    _cQuery +=" AND D1_FILIAL = F4_FILIAL "	
	_cQuery +=" AND A1_FILIAL = '' "
	_cQuery +=" AND D1_FORNECE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	_cQuery +=" AND D1_DTDIGIT BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"
	_cQuery +=" AND D1_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
    if mv_par10 = 1
       _cQuery +=" GROUP BY D1_FORNECE,D1_LOJA,A1_NOME,A1_CGC,A1_EST,A1_MUN,SUBSTRING(D1_DTDIGIT,5,2),SUBSTRING(D1_DTDIGIT,1,4),D1_COD,A1_CONTA,B1_DESC "
       _cQuery +=" ORDER BY D1_FORNECE,D1_LOJA "   
    else
       _cQuery +=" GROUP BY SUBSTRING(D1_DTDIGIT,5,2),SUBSTRING(D1_DTDIGIT,1,4),D1_COD, A1_CONTA,B1_DESC
       _cQuery +=" ORDER BY A1_CONTA "   
    endif
    *	
    Memowrite("RSFATR11",_cQuery)   //grava a query
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQuery)),"TRQ",.T.,.F.)
	
	If	!USED()
		MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
	EndIf

	count to nReg

	dbSelectArea("TRQ")
	dbGoTop()

	oReport:SetMeter(nReg)

	While ! Eof()
	
		If oReport:Cancel()
			Exit
		EndIf		
		
		nQtd      := 0
	    nValor    := 0
	    
		if MV_PAR10 = 1 //Codigo Cliente
		   cCliente  := TRQ->CLIENTE
		   cLoja     := TRQ->LOJA 
		   
		   While ! Eof() .and.	cCliente = TRQ->CLIENTE .and. cLoja = TRQ->LOJA		      
		      aAdd(aDados,{TRQ->CLIENTE,TRQ->LOJA,ALLTRIM(TRQ->NOME),TRQ->CGC,TRQ->COD,TRQ->ANO,TRQ->MES,TRQ->B1_DESC,TRQ->QUANT,TRQ->VALBRUT,ALLTRIM(TRQ->EST),ALLTRIM(TRQ->MUN)})
		      dbSkip()
		   Enddo

		else // Conta Contabil		   
		   cContabil := TRQ->A1_CONTA
		   
		   While ! Eof() .and.	cContabil = TRQ->A1_CONTA
		      aAdd(aDados,{TRQ->A1_CONTA,TRQ->COD,TRQ->ANO,TRQ->MES,TRQ->B1_DESC,TRQ->QUANT,TRQ->VALBRUT})
		      dbSkip()		      
		   Enddo

		endif
	Enddo 
	dbSelectArea("TRQ")
	dbCloseArea()	
	*       
	if Len(aDados) > 0 
	   *
	   if MV_PAR10 = 1 //Codigo Cliente
	      aSort( aDados,,, { |x,y| x[1]+x[2]+x[5] < y[1]+y[2]+Y[5] } )
	      *
	      For ix:= 1 to Len(aDados) 
		      cCliente  := aDados[ix,1]
		      cLoja     := aDados[ix,2]
		      cNome     := aDados[ix,3]+", CNPJ: "+TRANSFORM(aDados[ix,4],"@R 99.999.999/9999-99")+", "+ALLTRIM(aDados[ix,11])+"-"+ALLTRIM(aDados[ix,12])
		   	  nQtd      += aDados[ix,9]
      		  nValor    += aDados[ix,10]
      		  *
		      oSection1:Cell("C_COD"):SetValue(aDados[ix,5])
		      oSection1:Cell("C_ANO"):SetValue(aDados[ix,6])
      		  oSection1:Cell("C_MES"):SetValue(aDados[ix,7])
      	  	  oSection1:Cell("C_TP"):SetValue(aDados[ix,8])	
      		  oSection1:Cell("C_QTD"):SetValue(aDados[ix,9])
      		  oSection1:Cell("C_VALOR"):SetValue(aDados[ix,10])		
      		  oReport:SkipLine()
      		  oSection1:PrintLine() 
		      oReport:IncMeter() 
		      *
		      if Len(aDados) >= ix+1
		         if cCliente <> aDados[ix+1,1] .or. cLoja <> aDados[ix+1,2]
		            oSection1:Cell("C_COD"):SetValue("TOTAL DO CLIENTE")
	                oSection1:Cell("C_ANO"):SetValue("")
                    oSection1:Cell("C_MES"):SetValue("")
	                oSection1:Cell("C_TP"):SetValue(cCliente+"/"+cLoja+" - "+cNome)	
	                oSection1:Cell("C_QTD"):SetValue(nQtd)
	                oSection1:Cell("C_VALOR"):SetValue(nValor)		
	                oReport:SkipLine()
	                oSection1:PrintLine() 
	                *		            
		            nQtd      := 0
	                nValor    := 0
	                *
		            oSection1:Cell("C_COD"):SetValue("")
	                oSection1:Cell("C_ANO"):SetValue("")
                    oSection1:Cell("C_MES"):SetValue("")
	                oSection1:Cell("C_TP"):SetValue("")	
	                oSection1:Cell("C_QTD"):SetValue("")
	                oSection1:Cell("C_VALOR"):SetValue("")		
	                oReport:SkipLine()
    	            oSection1:PrintLine()	   	                
		         endif		         
		      endif
          Next
          oSection1:Cell("C_COD"):SetValue("TOTAL DO CLIENTE")
          oSection1:Cell("C_ANO"):SetValue("")
          oSection1:Cell("C_MES"):SetValue("")
          oSection1:Cell("C_TP"):SetValue(cCliente+"/"+cLoja+" - "+cNome)	
          oSection1:Cell("C_QTD"):SetValue(nQtd)
          oSection1:Cell("C_VALOR"):SetValue(nValor)		
          oReport:SkipLine()
          oSection1:PrintLine()	          
       
       else
              
          //aAdd(aDados,{TRQ->A1_CONTA,TRQ->COD,TRQ->ANO,TRQ->MES,TRQ->B1_DESC,TRQ->QUANT,TRQ->VALBRUT})
          aSort( aDados,,, { |x,y| x[1] < y[1] } )
          
          For ix:= 1 to Len(aDados) 
              cContabil  = aDados[ix,1]
		   	  nQtd      += aDados[ix,6]
      		  nValor    += aDados[ix,7]
      		  *              
		      oSection1:Cell("C_COD"):SetValue(aDados[ix,2])
		      oSection1:Cell("C_ANO"):SetValue(aDados[ix,3])
      	      oSection1:Cell("C_MES"):SetValue(aDados[ix,4])
      	      oSection1:Cell("C_TP"):SetValue(aDados[ix,5])	
      	      oSection1:Cell("C_QTD"):SetValue(aDados[ix,6])
      	      oSection1:Cell("C_VALOR"):SetValue(aDados[ix,7])		
      	      oReport:SkipLine()
      	      oSection1:PrintLine() 
		      oReport:IncMeter() 
		      *
		      if Len(aDados) >= ix+1
		         if cContabil <> aDados[ix+1,1]
		            oSection1:Cell("C_COD"):SetValue("TOTAL DA C.CONTABIL")
	                oSection1:Cell("C_ANO"):SetValue("")
                    oSection1:Cell("C_MES"):SetValue("")
	                oSection1:Cell("C_TP"):SetValue(ALLTRIM(cContabil)+" - "+QryCliente(cContabil))	
	                oSection1:Cell("C_QTD"):SetValue(nQtd)
	                oSection1:Cell("C_VALOR"):SetValue(nValor)		
	                oReport:SkipLine()
	                oSection1:PrintLine() 
	                *		            
		            nQtd      := 0
	                nValor    := 0
	                *
		            oSection1:Cell("C_COD"):SetValue("")
	                oSection1:Cell("C_ANO"):SetValue("")
                    oSection1:Cell("C_MES"):SetValue("")
	                oSection1:Cell("C_TP"):SetValue("")	
	                oSection1:Cell("C_QTD"):SetValue("")
	                oSection1:Cell("C_VALOR"):SetValue("")		
	                oReport:SkipLine()
    	            oSection1:PrintLine()	   	                
		         endif		         
		      endif
          Next
		  oSection1:Cell("C_COD"):SetValue("TOTAL DA C.CONTABIL")
	      oSection1:Cell("C_ANO"):SetValue("")
          oSection1:Cell("C_MES"):SetValue("")
	      oSection1:Cell("C_TP"):SetValue(ALLTRIM(cContabil)+" - "+QryCliente(cContabil))	
	      oSection1:Cell("C_QTD"):SetValue(nQtd)
	      oSection1:Cell("C_VALOR"):SetValue(nValor)		
	      oReport:SkipLine()
	      oSection1:PrintLine() 
	   endif
    endif
	*	
	oSection1:Finish()

Return


//-------------------------------------------------------------------
//  Ajusta o arquivo de perguntas SX1
//-------------------------------------------------------------------
Static Function CriaSx1(cPerg)

	u_HMPutSX1(cPerg, "01", PADR("Do Cliente ",29)+"?" ,"","", "mv_ch1" , "C", 8  , 0, 0, "G", "","SA1", "", "", "mv_par01")
	u_HMPutSX1(cPerg, "02", PADR("Ate Cliente",29)+"?" ,"","", "mv_ch2" , "C", 8  , 0, 0, "G", "","SA1", "", "", "mv_par02")  
  	u_HMPutSX1(cPerg, "03", PADR("Da Data    ",29)+"?" ,"","", "mv_ch3" , "D", 8  , 0, 0, "G", "",   "", "", "", "mv_par03")
	u_HMPutSX1(cPerg, "04", PADR("Ate Data   ",29)+"?" ,"","", "mv_ch4" , "D", 8  , 0, 0, "G", "",   "", "", "", "mv_par04")
	u_HMPutSX1(cPerg, "05", PADR("Do Produto ",29)+"?" ,"","", "mv_ch5" , "C", 15 , 0, 0, "G", "","SB1", "", "", "mv_par05")
	u_HMPutSX1(cPerg, "06", PADR("Ate Produto",29)+"?" ,"","", "mv_ch6" , "C", 15 , 0, 0, "G", "","SB1", "", "", "mv_par06")  
	u_HMPutSX1(cPerg, "07", PADR("Cfop Fil 01",29)+"?" ,"","", "mv_ch7" , "C", 40 , 0, 0, "G", "",   "", "", "", "mv_par07")
	u_HMPutSX1(cPerg, "08", PADR("Cfop Fil 02",29)+"?" ,"","", "mv_ch8" , "C", 40 , 0, 0, "G", "",   "", "", "", "mv_par08")
	u_HMPutSX1(cPerg, "09", PADR("Cfop Fil 04",29)+"?" ,"","", "mv_ch9" , "C", 40 , 0, 0, "G", "",   "", "", "", "mv_par09")
    u_HMPutSX1(cPerg, "10", PADR("Ordenar    ",29)+"?" ,"","", "mv_chA" , "N", 1  , 0, 1, "C", "", ""  , "", "", "mv_par10","Cod. Cliente","","","","Conta Contabil")   		

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ QryClieneºAutor³ORISMAR SILVA         º Data ³ 05/09/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Verificar o nome do cliente                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function QryCliente(cContabil)

	Local  _cQuery  := "" 
	Local  cNome    := ""
	Local  _sAlias  := Alias()
    _cQuery :=" SELECT TOP 1 A1_NOME " 
    _cQuery +=" FROM " + RetSqlName("SA1")+"  SA1 (NOLOCK) " 
    _cQuery +=" WHERE D_E_L_E_T_ = ' '  " 
    _cQuery +=" AND A1_CONTA = '"+cContabil+"' "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQuery)),"TMP",.T.,.F.)
	
	dbSelectArea("TMP")
	dbGoTop()
    
    if ! Eof()
       cNome := ALLTRIM(TMP->A1_NOME)
	endif
	dbSelectArea("TMP")
	dbCloseArea()
    dbSelectArea(_sAlias)

Return cNome
