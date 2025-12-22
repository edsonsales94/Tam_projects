#INCLUDE "rwmake.ch"
/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ RSFATR16   ¦ Autor ¦Orismar Silva         ¦ Data ¦ 25/08/2017 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ RELPERC   ¦ Relatório de Faturamento com impostos.                        ¦¦¦
¦¦¦           ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/
User Function RSFATR16()      

	Private oReport, oSection1

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
	Local cPerg   := "RSFATR16"
	Local cTitulo := 'Relatório de Faturamento com impostos'

	// Cria as perguntas no SX1                                            
	CriaSx1(cPerg)
	Pergunte(cPerg,.F.)

	oReport := TReport():New("RSFATR16", cTitulo, cPerg , {|oReport| PrintReport(oReport)},"Emitirá Relatório de Faturamento com impostos")

	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:ShowHeader()

	oSection1 := TRSection():New(oReport,"Relatório de Faturamento ANVISA",{""})
	oSection1:SetTotalInLine(.F.)

	TRCell():new(oSection1, "C_DOC"      , "", "DOCUMENTO"  	                        ,,10)
	TRCell():new(oSection1, "C_DATA"     , "", "DATA DE EMISSÃO"                        ,,10)
	TRCell():new(oSection1, "C_CF"       , "", "CFOP"       	                        ,,15)
	TRCell():new(oSection1, "C_VALOR"    , "", "VALOR DA NOTA" 	                        ,,15)
	TRCell():new(oSection1, "C_BICM"  	 , "", "BASE ICMS" 	                            ,,10)
	TRCell():new(oSection1, "C_AICM"     , "", "ALIQ. ICMS" 	                        ,,10)
	TRCell():new(oSection1, "C_VICM"    , "", "VALOR ICMS"	                            ,,10)		
	TRCell():new(oSection1, "C_BPS2"  	 , "", "BASE PIS/PASEP"                         ,,10)
	TRCell():new(oSection1, "C_APS2"     , "", "ALIQ. PIS/PASEP"                        ,,10)
	TRCell():new(oSection1, "C_VPS2"     , "", "VALOR PIS/PASEP"                        ,,10)	
	TRCell():new(oSection1, "C_BCF2"  	 , "", "BASE COFINS"                            ,,10)
	TRCell():new(oSection1, "C_ACF2"     , "", "ALIQ. COFINS"                           ,,10)
	TRCell():new(oSection1, "C_VCF2"     , "", "VALOR COFINS"                           ,,10)			
	TRCell():new(oSection1, "C_BCMP"  	 , "", "BASE ICMS COMPLEMENTAR"                 ,,10)
	TRCell():new(oSection1, "C_ACMP"     , "", "ALIQ. ICMS COMPLEMENTAR"                ,,10)
	TRCell():new(oSection1, "C_VCMP"     , "", "VALOR ICMS COMPLEMENTAR"                ,,10)		
    TRCell():new(oSection1, "C_BSOL"  	 , "", "BASE ICMS RETIDO"                       ,,10)
	TRCell():new(oSection1, "C_ASOL"     , "", "ALIQ. ICMS RETIDO"                      ,,10)
	TRCell():new(oSection1, "C_VSOL"     , "", "VALOR ICMS RETIDO"                      ,,10)
    TRCell():new(oSection1, "C_BDIF"  	 , "", "BASE ICMS COMPLEMENTAR DEST."           ,,10)
	TRCell():new(oSection1, "C_ADIF"     , "", "ALIQ. ICMS COMPLEMENTAR DEST."          ,,10)
	TRCell():new(oSection1, "C_VDIF"     , "", "VALOR ICMS COMPLEMENTAR DEST."          ,,10)		
return (oReport)

//=================================================================================
// definicao para impressao do relatorio personalizado 
//=================================================================================
Static Function PrintReport(oReport)

	Local nReg, ix
	Local aDoc := {}

	oSection1 := oReport:Section(1)

	oSection1:Init()
	oSection1:SetHeaderSection(.T.)   
	
	_cQuery :=" SELECT DISTINCT F2_FILIAL FIL,F2_DOC DOC, F2_SERIE SERIE,F2_EMISSAO,D2_CF,F2_VALBRUT TOTAL,CD2_IMP,CD2_BC,CD2_ALIQ, CD2_VLTRIB,F3_DIFAL   "
	_cQuery +=" FROM "+ RetSqlName("SF4")+ " SF4, "+ RetSqlName("SF2")+ " SF2 "
   	_cQuery +=" FULL OUTER JOIN "
	_cQuery +=" ( SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_TES,D2_CF,D2_PEDIDO FROM "+ RetSqlName("SD2")+ " WHERE D_E_L_E_T_ = '' ) SD2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE
	_cQuery +=" FULL OUTER JOIN 
	_cQuery +=" ( SELECT CD2_FILIAL,CD2_DOC,CD2_SERIE,CD2_IMP,SUM(CD2_BC) CD2_BC,CD2_ALIQ,SUM(CD2_VLTRIB) CD2_VLTRIB FROM "+ RetSqlName("CD2")+ " WHERE D_E_L_E_T_ = '' AND CD2_TPMOV = 'S' GROUP BY CD2_FILIAL,CD2_DOC,CD2_SERIE,CD2_IMP,CD2_ALIQ ) CD2 ON CD2_FILIAL = F2_FILIAL AND CD2_DOC = F2_DOC AND CD2_SERIE = F2_SERIE "
	_cQuery +=" FULL OUTER JOIN "
	_cQuery +=" ( SELECT F3_FILIAL,F3_DIFAL ,F3_NFISCAL,F3_SERIE FROM "+ RetSqlName("SF3")+ " WHERE D_E_L_E_T_ = '' ) SF3 ON F3_FILIAL = F2_FILIAL AND F3_NFISCAL = F2_DOC AND F3_SERIE = F2_SERIE "
	_cQuery +=" WHERE SF2.D_E_L_E_T_ = '' AND SF4.D_E_L_E_T_ = '' "
	_cQuery +=" AND F4_FILIAL = D2_FILIAL "
	_cQuery +=" AND D2_TES = F4_CODIGO "
	_cQuery +=" AND F4_ESTOQUE = 'S' " 
    if SM0->M0_CODFIL = "01"
	    _cQuery +=" AND D2_CF IN "+ FormatIn(  mv_par05, ",")
	elseif SM0->M0_CODFIL = "02"
	    _cQuery +=" AND D2_CF IN "+ FormatIn(  mv_par06, ",")	   
	elseif SM0->M0_CODFIL = "04"
	    _cQuery +=" AND D2_CF IN "+ FormatIn(  mv_par07, ",")	   	    
	endif
	_cQuery +=" AND D2_PEDIDO != '' "
	_cQuery +=" AND F2_FILIAL = '"+XFILIAL("SD2")+"'"
	_cQuery +=" AND F2_DOC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
   	_cQuery +=" AND F2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"
   	_cQuery +=" GROUP BY F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO,CD2_IMP,CD2_BC,CD2_ALIQ, CD2_VLTRIB,F3_DIFAL ,F2_VALBRUT,D2_CF"
	_cQuery +=" ORDER BY FIL,DOC,SERIE,CD2_IMP "
	*	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQuery)),"TRQ",.T.,.F.)
	
	If	!USED()
		MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
	EndIf

	count to nReg

	dbSelectArea("TRQ")
	dbGoTop()

    ProcRegua(nReg)
	While ! Eof()
	
        IncProc()
      	nPos 	:= Ascan(aDoc,{ |x| x[1] = TRQ->DOC .and. x[2] = TRQ->SERIE })
	    if nPos = 0
		   aAdd(aDoc,{TRQ->DOC,TRQ->SERIE,SUBSTR(TRQ->F2_EMISSAO,7,2)+"/"+SUBSTR(TRQ->F2_EMISSAO,5,2)+"/"+SUBSTR(TRQ->F2_EMISSAO,1,4),TRQ->TOTAL,"ICM",0,0,0,"PS2",0,0,0,"CF2",0,0,0,"CMP",0,0,0,"SOL",0,0,0,"DIF",0,0,0,TRQ->D2_CF})
		endif
		
      	nPos 	:= Ascan(aDoc,{ |x| x[1] = TRQ->DOC .and. x[2] = TRQ->SERIE })
      	if nPos > 0 
      	   if TRQ->CD2_IMP = 'ICM'
      	      aDoc[nPos,6] := TRQ->CD2_BC
      	      aDoc[nPos,7] := TRQ->CD2_ALIQ
      	      aDoc[nPos,8] := TRQ->CD2_VLTRIB
      	   endif
      	
      	   if TRQ->CD2_IMP = 'PS2'      	
      	      aDoc[nPos,10] := TRQ->CD2_BC
      	      aDoc[nPos,11] := TRQ->CD2_ALIQ
      	      aDoc[nPos,12] := TRQ->CD2_VLTRIB      	   
      	   endif
      	
      	   if TRQ->CD2_IMP = 'CF2'      	
      	      aDoc[nPos,14] := TRQ->CD2_BC
      	      aDoc[nPos,15] := TRQ->CD2_ALIQ
      	      aDoc[nPos,16] := TRQ->CD2_VLTRIB      	         	   
      	   endif
      	
      	   if TRQ->CD2_IMP = 'CMP'
      	      aDoc[nPos,18] := TRQ->CD2_BC
      	      aDoc[nPos,19] := TRQ->CD2_ALIQ
      	      aDoc[nPos,20] := TRQ->CD2_VLTRIB      	         	   
      	   endif
      	
      	   if TRQ->CD2_IMP = 'SOL'      	
      	      aDoc[nPos,22] := TRQ->CD2_BC
      	      aDoc[nPos,23] := TRQ->CD2_ALIQ
      	      aDoc[nPos,24] := TRQ->CD2_VLTRIB      	         	   
      	   endif
      	
      	   if TRQ->CD2_IMP = 'DIF'
   	          aDoc[nPos,26] := TRQ->CD2_BC
      	      aDoc[nPos,27] := TRQ->CD2_ALIQ
      	      aDoc[nPos,28] := TRQ->CD2_VLTRIB      	   
      	   endif
        endif

		dbSkip()
	Enddo
    
    if Len(aDoc) > 0  
       oReport:SetMeter(Len(aDoc))
       For ix:=1 to Len(aDoc)
       	   If oReport:Cancel()
			  Exit
		   EndIf

           oSection1:Cell("C_DOC"):SetValue(aDoc[ix,1]+"-"+aDoc[ix,2])
	       oSection1:Cell("C_DATA"):SetValue(aDoc[ix,3])
	       oSection1:Cell("C_CF"):SetValue(aDoc[ix,29])	       
      	   oSection1:Cell("C_VALOR"):SetValue(aDoc[ix,4])
      	   oSection1:Cell("C_BICM"):SetValue(aDoc[ix,6])	
      	   oSection1:Cell("C_AICM"):SetValue(aDoc[ix,7])
      	   oSection1:Cell("C_VICM"):SetValue(aDoc[ix,8])		
      	   oSection1:Cell("C_BPS2"):SetValue(aDoc[ix,10])	
      	   oSection1:Cell("C_APS2"):SetValue(aDoc[ix,11])
      	   oSection1:Cell("C_VPS2"):SetValue(aDoc[ix,12])		
      	   oSection1:Cell("C_BCF2"):SetValue(aDoc[ix,14])	
      	   oSection1:Cell("C_ACF2"):SetValue(aDoc[ix,15])
      	   oSection1:Cell("C_VCF2"):SetValue(aDoc[ix,16])		
      	   oSection1:Cell("C_BCMP"):SetValue(aDoc[ix,18])	
      	   oSection1:Cell("C_ACMP"):SetValue(aDoc[ix,19])
      	   oSection1:Cell("C_VCMP"):SetValue(aDoc[ix,20])		
      	   oSection1:Cell("C_BSOL"):SetValue(aDoc[ix,22])	
      	   oSection1:Cell("C_ASOL"):SetValue(aDoc[ix,23])
      	   oSection1:Cell("C_VSOL"):SetValue(aDoc[ix,24])		
      	   oSection1:Cell("C_BDIF"):SetValue(aDoc[ix,26])	
      	   oSection1:Cell("C_ADIF"):SetValue(aDoc[ix,27])
      	   oSection1:Cell("C_VDIF"):SetValue(aDoc[ix,28])   
      	   oReport:SkipLine()
      	   oSection1:PrintLine() 
		   oReport:IncMeter()
    
       Next
      
    endif    
	
	dbSelectArea("TRQ")
	dbCloseArea()
	oSection1:Finish()

Return

//-------------------------------------------------------------------
//  Ajusta o arquivo de perguntas SX1
//-------------------------------------------------------------------
Static Function CriaSx1(cPerg)

	u_HMPutSX1(cPerg, "01", PADR("Da Nota    ",29)+"?" ,"","", "mv_ch1" , "C", 9  , 0, 0, "G", "","SF2", "", "", "mv_par01")
	u_HMPutSX1(cPerg, "02", PADR("Ate Nota   ",29)+"?" ,"","", "mv_ch2" , "C", 9  , 0, 0, "G", "","SF2", "", "", "mv_par02")  
  	u_HMPutSX1(cPerg, "03", PADR("Da Data    ",29)+"?" ,"","", "mv_ch3" , "D", 8  , 0, 0, "G", "",   "", "", "", "mv_par03")
	u_HMPutSX1(cPerg, "04", PADR("Ate Data   ",29)+"?" ,"","", "mv_ch4" , "D", 8  , 0, 0, "G", "",   "", "", "", "mv_par04")
	u_HMPutSX1(cPerg, "05", PADR("Cfop Fil 01",29)+"?" ,"","", "mv_ch5" , "C", 30 , 0, 0, "G", "",   "", "", "", "mv_par05")
	u_HMPutSX1(cPerg, "06", PADR("Cfop Fil 02",29)+"?" ,"","", "mv_ch6" , "C", 30 , 0, 0, "G", "",   "", "", "", "mv_par06")
    u_HMPutSX1(cPerg, "07", PADR("Cfop Fil 04",29)+"?" ,"","", "mv_ch7" , "C", 30 , 0, 0, "G", "",   "", "", "", "mv_par07")	

Return Nil
