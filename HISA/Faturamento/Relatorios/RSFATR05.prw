#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//=================================================================================
// Funcao    | RSFATR05  | Autor | Orismar Silva         | Data | 02/02/2014
//=================================================================================
// Descricao | Relatorio de Faturamento Mensal
//=================================================================================
//  Uso      | Generico                                                   
//=================================================================================

User Function RSFATR05()

Private oReport, oSection1

oReport := ReportDef()                         
If !Empty(oReport:uParam)
	Pergunte(oReport:uParam,.F.)
EndIf
oReport:PrintDialog()

Return

//=================================================================================
// relatorio de producao - formato personalizavel
//=================================================================================
Static Function ReportDef()
Local cPerg   := "RSFATR05"
Local cTitulo := "Faturamento Mensal "

CriaSx1(cPerg)

Pergunte(cPerg,.F.)

oReport := TReport():New("RSFATR05", cTitulo, cPerg , {|oReport| PrintReport(oReport)},"Emitirá Relatório de Faturamento Mensal")

oReport:SetPortrait()
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()

oSection1 := TRSection():New(oReport,"Relatório de Faturamento Mensal.",{""})
oSection1:SetTotalInLine(.F.)
TRCell():New(oSection1, "C_COD"	   , "", "CÓDIGO"            ,,10)
TRCell():new(oSection1, "C_DESCRI"  , "", "PRODUTO"           ,,60)
TRCell():new(oSection1, "C_QDT"     , "", "QUANTIDADE SAÍDA"  ,,15)
TRCell():new(oSection1, "C_VALOR"   , "", "VALOR TOTAL"       ,,15)
return (oReport)

//=================================================================================
// definicao para impressao do relatorio personalizado 
//=================================================================================
Static Function PrintReport(oReport)
   Local nTotQdt   := 0
	Local nTotTotal := 0
	Local nTotIcms  := 0 
	Local nTotTotg  := 0 
	Local nTotN     := 0
	Local nTotI     := 0

   oReport:SetTitle(oReport:Title() + "Relatório de Faturamento Mensal - Periodo: "+dtoc(mv_par01) +"  a  "+dtoc(mv_par02))
   
   oSection1 := oReport:Section(1)

   oSection1:Init()
   oSection1:SetHeaderSection(.T.)

   _cQuery :=" SELECT D2_COD,SUM(D2_QUANT) D2_QUANT,SUM(D2_VALBRUT) D2_VALBRUT, SUM(D2_ICMSRET) D2_ICMSRET "
   _cQuery +=" FROM "+ RetSqlName("SD2")
   _cQuery +=" WHERE D_E_L_E_T_ = '' "
   //_cQuery +=" AND D2_FILIAL = '"+XFILIAL("SD2")+"' " 
   //_cQuery +=" AND D2_FILIAL IN ('01','02','04')
   _cQuery +=" AND D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' " 
   _cQuery +=" AND D2_FILIAL BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' " 
   cCFOP := ALLTRIM(mv_par03)+","+ALLTRIM(mv_par04)+","+ALLTRIM(mv_par05)
   _cQuery +=" AND D2_CF IN " + FormatIn(  cCFOP, ",")
   _cQuery +=" GROUP BY D2_COD "
   _cQuery +=" ORDER BY D2_COD "
 

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQuery)),"TNP",.T.,.F.)

   If	!USED()
	   MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
   EndIf

   TNP->(DbGoTop())
   oReport:SetMeter(TNP->(RecCount()))
   While TNP->( ! Eof() )
      If oReport:Cancel()
	      Exit
      EndIf	
	   oReport:IncMeter()
	   oSection1:Cell("C_COD"):SetValue(TNP->D2_COD)
	   oSection1:Cell("C_DESCRI" ):SetValue(Posicione("SB1",1,XFILIAL("SB1")+TNP->D2_COD,"B1_DESC"))
	   oSection1:Cell("C_QDT"):SetValue(TNP->D2_QUANT)
	   oSection1:Cell("C_VALOR"):SetValue(TNP->D2_VALBRUT-TNP->D2_ICMSRET)

	   oReport:SkipLine()
	   oSection1:PrintLine() 
      nTotQdt   += TNP->D2_QUANT
      nTotTotal += TNP->D2_VALBRUT-TNP->D2_ICMSRET
      nTotIcms  += TNP->D2_ICMSRET
      nTotTotg  += TNP->D2_VALBRUT
      if ALLTRIM(TNP->D2_COD) $ ('41100|41200|45100')
         nTotI += TNP->D2_ICMSRET
      elseif ALLTRIM(TNP->D2_COD) $ ('42100|42200')
         nTotN += TNP->D2_ICMSRET
      endif
	   TNP->(dbSkip())
  Enddo  
  Sal_linha(1)
  oReport:IncMeter()
  oSection1:Cell("C_COD"):SetValue("TOTAL GERAL")
  oSection1:Cell("C_DESCRI" ):SetValue("")
  oSection1:Cell("C_QDT"):SetValue(nTotQdt)
  oSection1:Cell("C_VALOR"):SetValue(nTotTotal)
  oReport:SkipLine()
  oSection1:PrintLine() 
  Sal_linha(2)
  oReport:IncMeter()
  oSection1:Cell("C_COD"):SetValue("Periodo:")
  oSection1:Cell("C_DESCRI" ):SetValue(dtoc(mv_par01) +"  a  "+dtoc(mv_par02))
  oSection1:Cell("C_QDT"):SetValue("")
  oSection1:Cell("C_VALOR"):SetValue("")
  oReport:SkipLine()
  oSection1:PrintLine()     
  *
  TNP->(dbCloseArea())
  oSection1:Finish()      

Return


//-------------------------------------------------------------------
//  Incluir linha em branco
//-------------------------------------------------------------------
Static Function Sal_linha(nx)
   Local x
  for x:=1 to nx
      oReport:IncMeter()
      oSection1:Cell("C_COD"):SetValue("")
      oSection1:Cell("C_DESCRI" ):SetValue("")
      oSection1:Cell("C_QDT"):SetValue("")
      oSection1:Cell("C_VALOR"):SetValue("")
      oReport:SkipLine()
      oSection1:PrintLine()     
  Next

Return Nil



//-------------------------------------------------------------------
//  Ajusta o arquivo de perguntas SX1
//-------------------------------------------------------------------
Static Function CriaSx1(cPerg)

	u_HMPutSX1(cPerg, "01", PADR("Da Data ",29)+"?"              ,"","", "mv_ch1" , "D", 8 , 0, 0, "G", "",   "", "", "", "mv_par01")
	u_HMPutSX1(cPerg, "02", PADR("Ate Data ",29)+"?"             ,"","", "mv_ch2" , "D", 8 , 0, 0, "G", "",   "", "", "", "mv_par02")
	u_HMPutSX1(cPerg, "03", PADR("Cfop Fil 01",29)+"?"           ,"","", "mv_ch3" , "C", 30, 0, 0, "G", "",   "", "", "", "mv_par03")
	u_HMPutSX1(cPerg, "04", PADR("Cfop Fil 02",29)+"?"           ,"","", "mv_ch4" , "C", 30, 0, 0, "G", "",   "", "", "", "mv_par04")
	u_HMPutSX1(cPerg, "05", PADR("Cfop Fil 04",29)+"?"           ,"","", "mv_ch5" , "C", 30, 0, 0, "G", "",   "", "", "", "mv_par05")	
	u_HMPutSX1(cPerg, "06", PADR("Da Filial  ",29)+"?"           ,"","", "mv_ch6" , "C",  2, 0, 0, "G", "",   "SM0", "", "", "mv_par06")
   u_HMPutSX1(cPerg, "07", PADR("Ate Filial ",29)+"?"           ,"","", "mv_ch7" , "C",  2, 0, 0, "G", "",   "SM0", "", "", "mv_par07")

Return Nil


