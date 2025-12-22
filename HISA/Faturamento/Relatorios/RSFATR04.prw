#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//=================================================================================
// Funcao    | RSFATR04  | Autor | Orismar Silva         | Data | 01/02/2014
//=================================================================================
// Descricao | Relatorio de Saida de Material
//=================================================================================
//  Uso      | Generico                                                   
//=================================================================================

User Function RSFATR04()

Private oReport, oSection1
Private nTotQtd   := 0
Private nTotCust  := 0
Private ntotCusto := 0
Private aDetalhe  := {0,0,0,0}

//If FindFunction("TRepInUse") .And. TRepInUse()	// Interface de impressao   
	oReport := ReportDef()                         
	If !Empty(oReport:uParam)
		Pergunte(oReport:uParam,.F.)
	EndIf
	oReport:PrintDialog()
//Else
//    Return ApRelRN() // Executa versão nao personalizada
//Endif

Return

//=================================================================================
// relatorio de producao - formato personalizavel
//=================================================================================
Static Function ReportDef()
Local cPerg   := "RSFATR04"
local cTitulo := 'Relatório de Saída de Material'

CriaSx1(cPerg)

Pergunte(cPerg,.F.)

oReport := TReport():New("RSFATR04", cTitulo, cPerg , {|oReport| PrintReport(oReport)},"Emitirá Relatório de Saída de Material")

oReport:SetPortrait()
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()

oSection1 := TRSection():New(oReport,"Relatório de Saída de Material.",{""})
oSection1:SetTotalInLine(.F.)
TRCell():New(oSection1, "C_COD"	   , "", "CÓDIGO"            ,,10)
TRCell():new(oSection1, "C_DESCRI"  , "", "PRODUTO"           ,,60)
TRCell():new(oSection1, "C_QDT"     , "", "QUANTIDADE SAÍDA"  ,,15)
TRCell():new(oSection1, "C_VALOR"   , "", "VALOR TOTAL"       ,,15)
TRCell():New(oSection1, "C_ICMS"	   , "", "ICMS TOTAL"        ,,15)
TRCell():new(oSection1, "C_PB"      , "", "PESO BRUTO"        ,,15)
TRCell():new(oSection1, "C_PL"      , "", "PESO LIQUIDO"      ,,15)
TRCell():New(oSection1, "C_VOL"	   , "", "VOLUME"            ,,15)
TRCell():new(oSection1, "C_QDTNF"   , "", "QDT. NF"           ,,10)
return (oReport)

//=================================================================================
// definicao para impressao do relatorio personalizado 
//=================================================================================
Static Function PrintReport(oReport)
   Local nTotQdt   := 0
	Local nTotTotal := 0
	Local nTotIcms  := 0  

   oSection1 := oReport:Section(1)

   oSection1:Init()
   oSection1:SetHeaderSection(.T.)

   _cQuery :=" SELECT D2_COD,SUM(D2_QUANT) D2_QUANT,SUM(D2_TOTAL) D2_TOTAL, SUM(D2_VALICM) D2_VALICM "
   _cQuery +=" FROM "+ RetSqlName("SD2")
   _cQuery +=" WHERE D_E_L_E_T_ = '' "
   _cQuery +=" AND D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
   cCfop := ALLTRIM(mv_par03)+","+ALLTRIM(mv_par04)+","+ALLTRIM(mv_par05)
   /*
   if  SM0->M0_CODFIL = "01"
       _cQuery +=" AND D2_CF IN " + FormatIn(  mv_par03, ",")
       _cQuery +=" AND D2_FILIAL = '01'
   elseif SM0->M0_CODFIL = "02"
       _cQuery +=" AND D2_CF IN " + FormatIn(  mv_par04, ",")
       _cQuery +=" AND D2_FILIAL = '02'
   elseif SM0->M0_CODFIL = "04"
       _cQuery +=" AND D2_CF IN " + FormatIn(  mv_par05, ",")
       _cQuery +=" AND D2_FILIAL = '04'       
   endif
   */
   _cQuery +=" AND D2_CF IN " + FormatIn(  cCfop, ",")
   _cQuery +=" AND D2_FILIAL IN ('01','02','04')
   
   _cQuery +=" GROUP BY D2_COD "
 

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQuery)),"TML",.T.,.F.)

   If	!USED()
	   MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
   EndIf

   TML->(DbGoTop())
   oReport:SetMeter(TML->(RecCount()))
   While TML->( ! Eof() )
      If oReport:Cancel()
	      Exit
      EndIf	
	   oReport:IncMeter()
	   oSection1:Cell("C_COD"):SetValue(TML->D2_COD)
	   oSection1:Cell("C_DESCRI" ):SetValue(Posicione("SB1",1,XFILIAL("SB1")+TML->D2_COD,"B1_DESC"))
	   oSection1:Cell("C_QDT"):SetValue(TML->D2_QUANT)
	   oSection1:Cell("C_VALOR"):SetValue(TML->D2_TOTAL)
  	   oSection1:Cell("C_ICMS"):SetValue(TML->D2_VALICM)
 	   oSection1:Cell("C_PB"):SetValue("")
  	   oSection1:Cell("C_PL"):SetValue("")
 	   oSection1:Cell("C_VOL"):SetValue("")
 	   oSection1:Cell("C_QDTNF"):SetValue("")

	   oReport:SkipLine()
	   oSection1:PrintLine() 
      nTotQdt   += TML->D2_QUANT
      nTotTotal += TML->D2_TOTAL
      nTotIcms  += TML->D2_VALICM
	   TML->(dbSkip())
  Enddo  
  TML->(dbCloseArea())
  
  oReport:IncMeter()
  oSection1:Cell("C_COD"):SetValue("")
  oSection1:Cell("C_DESCRI" ):SetValue("")
  oSection1:Cell("C_QDT"):SetValue("")
  oSection1:Cell("C_VALOR"):SetValue("")
  oSection1:Cell("C_ICMS"):SetValue("")
  oSection1:Cell("C_PB"):SetValue("")
  oSection1:Cell("C_PL"):SetValue("")
  oSection1:Cell("C_VOL"):SetValue("")
  oSection1:Cell("C_QDTNF"):SetValue("")
  oReport:SkipLine()
  oSection1:PrintLine()     
  Detalhe()
  oReport:IncMeter()
  oSection1:Cell("C_COD"):SetValue("TOTAL")
  oSection1:Cell("C_DESCRI" ):SetValue("")
  oSection1:Cell("C_QDT"):SetValue(nTotQdt)
  oSection1:Cell("C_VALOR"):SetValue(nTotTotal)
  oSection1:Cell("C_ICMS"):SetValue(nTotIcms)
  oSection1:Cell("C_PB"):SetValue(aDetalhe[1])
  oSection1:Cell("C_PL"):SetValue(aDetalhe[2])
  oSection1:Cell("C_VOL"):SetValue(aDetalhe[3])
  oSection1:Cell("C_QDTNF"):SetValue(aDetalhe[4])
  oReport:SkipLine()
  oSection1:PrintLine()     
  oSection1:Finish() 
  

Return


//=================================================================================
// Totalizador dos pesos bruto e liquido e volumeo
//=================================================================================
Static Function Detalhe()
    Local  _cQuery := ''
    
   _cQuery :=" SELECT DISTINCT F2_DOC, F2_PBRUTO , F2_PLIQUI, F2_VOLUME1
   _cQuery +=" FROM "+ RetSqlName("SD2")+ " SD2, "+ RetSqlName("SF2")+ " SF2 "
   _cQuery +=" WHERE SD2.D_E_L_E_T_ = '' AND SF2.D_E_L_E_T_ = ''
   _cQuery +=" AND D2_FILIAL = F2_FILIAL
   _cQuery +=" AND D2_DOC = F2_DOC
   _cQuery +=" AND D2_SERIE = F2_SERIE
   _cQuery +=" AND F2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
   cCFOP := ALLTRIM(mv_par03)+","+ALLTRIM(mv_par04)+","+ALLTRIM(mv_par05)

   _cQuery +=" AND D2_CF IN " + FormatIn(  cCFOP, ",")
   _cQuery +=" AND D2_FILIAL IN ('01','02','04')
   
   dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQuery)),"TMA",.T.,.F.)

   If	!USED()
	   MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
   EndIf

   TMA->(DbGoTop())
   oReport:SetMeter(TMA->(RecCount()))
   While TMA->( ! Eof() )
         aDetalhe[1] += TMA->F2_PBRUTO
         aDetalhe[2] += TMA->F2_PLIQUI
         aDetalhe[3] += TMA->F2_VOLUME1
         aDetalhe[4] += 1
         dbSkip()
   Enddo
   TMA->(dbCloseArea())
Return

//-------------------------------------------------------------------
//  Ajusta o arquivo de perguntas SX1
//-------------------------------------------------------------------
Static Function CriaSx1(cPerg)

	u_HMPutSX1(cPerg, "01", PADR("Da Data ",29)+"?"              ,"","", "mv_ch1" , "D", 8 , 0, 0, "G", "",   "", "", "", "mv_par01")
	u_HMPutSX1(cPerg, "02", PADR("Ate Data ",29)+"?"             ,"","", "mv_ch2" , "D", 8 , 0, 0, "G", "",   "", "", "", "mv_par02")
	u_HMPutSX1(cPerg, "03", PADR("Cfop Fil 01",29)+"?"             ,"","", "mv_ch3" , "C", 30, 0, 0, "G", "",   "", "", "", "mv_par03")
	u_HMPutSX1(cPerg, "04", PADR("Cfop Fil 02",29)+"?"             ,"","", "mv_ch4" , "C", 30, 0, 0, "G", "",   "", "", "", "mv_par04")
    u_HMPutSX1(cPerg, "05", PADR("Cfop Fil 04",29)+"?"             ,"","", "mv_ch5" , "C", 30, 0, 0, "G", "",   "", "", "", "mv_par05")

Return Nil


