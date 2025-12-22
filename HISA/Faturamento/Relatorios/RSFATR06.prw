#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//=================================================================================
// Funcao    | RSFATR06  | Autor | Orismar Silva         | Data | 10/02/2014
//=================================================================================
// Descricao | Relatorio de Faturamento Diario
//=================================================================================
//  Uso      | Generico                                                   
//=================================================================================

User Function RSFATR06()

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
Local cPerg   := "RSFATR06"
Local cTitulo := 'Relatório de Faturamento Diário'

CriaSx1(cPerg)

Pergunte(cPerg,.F.)

oReport := TReport():New("RSFATR06", cTitulo, cPerg , {|oReport| PrintReport(oReport)},"Emitirá Relatório de Faturamento Diário")

oReport:SetPortrait()
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()

oSection1 := TRSection():New(oReport,"Relatório de Faturamento Diário.",{""})
oSection1:SetTotalInLine(.F.)
TRCell():New(oSection1, "C_PED"	    , "", "PEDIDO HFB"         ,,10)
TRCell():new(oSection1, "C_CLI"     , "", "CLIENTE"            ,,50)
TRCell():new(oSection1, "C_TRANSP"  , "", "TRANSPORTADORA"     ,,15)
TRCell():new(oSection1, "C_NF"      , "", "NOTA FISCAL"        ,,15)
TRCell():new(oSection1, "C_VOL"     , "", "VOLUME"             ,,15)
TRCell():New(oSection1, "C_DTEMIS"	, "", "DATA EMISSÃO"       ,,15)
TRCell():new(oSection1, "C_PEDCLI"  , "", "PEDIDO DO CLIENTE"  ,,25)
TRCell():new(oSection1, "C_EST"     , "", "ESTADO"             ,,10)
TRCell():new(oSection1, "C_MUN"     , "", "MUNICIPIO"          ,,25)
//TRCell():new(oSection1, "C_VLR"     , "", "VALOR NF"           ,,10)
TRCell():New(oSection1, "C_VENC"	   , "", "DATA DO VENCIMENTO" ,,15)
TRCell():new(oSection1, "C_PARC"    , "", "VALOR DA PARCELA"   ,,10)
TRCell():new(oSection1, "C_CVEND"   , "", "CÓDIGO"             ,,10)
TRCell():new(oSection1, "C_NVEND"   , "", "NOME VENDEDOR"      ,,40)
TRCell():new(oSection1, "C_BASPIS"  , "", "BASE PIS"           ,,10)
TRCell():new(oSection1, "C_ALQPIS"  , "", "ALIQ. PIS"          ,,10)
TRCell():new(oSection1, "C_VALPIS"  , "", "VALOR PIS"          ,,10)
TRCell():new(oSection1, "C_BASCOF"  , "", "BASE COFINS"        ,,10)
TRCell():new(oSection1, "C_ALQCOF"  , "", "ALIQ. COFINS"       ,,10)
TRCell():new(oSection1, "C_VALCOF"  , "", "VALOR COFINS"       ,,10)
TRCell():new(oSection1, "C_BASICM"  , "", "BASE ICM"           ,,10)
TRCell():new(oSection1, "C_ALQICM"  , "", "ALIQ. ICM"          ,,10)
TRCell():new(oSection1, "C_VALICM"  , "", "VALOR ICM"          ,,10)
TRCell():new(oSection1, "C_ICMSST"  , "", "ICMS ST"            ,,10)

return (oReport)

//=================================================================================
// definicao para impressao do relatorio personalizado 
//=================================================================================
Static Function PrintReport(oReport)
	Local nTotTotal := 0
	Local nFilial   := 0


   oSection1 := oReport:Section(1)

   oSection1:Init()
   oSection1:SetHeaderSection(.T.)
                                             
   _cQuery :=" SELECT DISTINCT F2_FILIAL,C5_NUM,F2_VOLUME1, F2_CLIENTE,F2_LOJA,A1_NOME, F2_TRANSP,A4_NREDUZ,F2_DOC, F2_SERIE, F2_EMISSAO,C5_PEDCLI,A1_MUN,A1_EST,E1_VENCTO,E1_VALOR,F2_VALBRUT, C5_VEND1,A3_NOME, F2_BASIMP5, D2_ALQIMP5, F2_VALIMP5, F2_BASIMP6, D2_ALQIMP6, F2_VALIMP6, F2_BASEICM, D2_PICM, F2_VALICM, F2_ICMSRET "
   _cQuery +=" FROM "+ RetSqlName("SF2") +" SF2"
   _cQuery +=" INNER JOIN "+ RetSqlName("SC5") +" SC5 ON SC5.D_E_L_E_T_ = '' AND F2_FILIAL = C5_FILIAL AND F2_DOC = C5_NOTA AND F2_SERIE = C5_SERIE AND F2_CLIENTE = C5_CLIENTE AND C5_LOJACLI = F2_LOJA "
   _cQuery +=" INNER JOIN "+ RetSqlName("SA1") +" SA1 ON SA1.D_E_L_E_T_ = '' AND F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND A1_FILIAL = '' "
   if mv_par06 == 1 //Filial01
      _cQuery +=" INNER JOIN "+ RetSqlName("SD2") +" SD2 ON SD2.D_E_L_E_T_ = '' AND D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CF IN "+ FormatIn(  mv_par03, ",")
      _cQuery +=" AND F2_FILIAL = '01'"
   elseif mv_par06 == 2 //filial02
      _cQuery +=" INNER JOIN "+ RetSqlName("SD2") +" SD2 ON SD2.D_E_L_E_T_ = '' AND D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CF IN "+ FormatIn(  mv_par04, ",")
      _cQuery +=" AND F2_FILIAL = '02'"
   elseif mv_par06 == 3 //filial04
      _cQuery +=" INNER JOIN "+ RetSqlName("SD2") +" SD2 ON SD2.D_E_L_E_T_ = '' AND D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CF IN "+ FormatIn(  mv_par05, ",")
      _cQuery +=" AND F2_FILIAL = '04'"
   else
      _cQuery +=" INNER JOIN "+ RetSqlName("SD2") +" SD2 ON SD2.D_E_L_E_T_ = '' AND D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CF IN "+ FormatIn(  mv_par03+","+mv_par04+","+mv_par05, ",")   
      _cQuery +=" AND F2_FILIAL IN ('01','02','04') "
   endif
   _cQuery +=" INNER JOIN "+ RetSqlName("SA4") +" SA4 ON SA4.D_E_L_E_T_ = '' AND F2_TRANSP = A4_COD AND A4_FILIAL = '' "
   _cQuery +=" LEFT JOIN  "+ RetSqlName("SE1") +" SE1 ON SE1.D_E_L_E_T_ = '' AND E1_NUM = F2_DOC AND E1_PREFIXO = F2_SERIE  AND E1_CLIENTE = F2_CLIENTE AND E1_LOJA = F2_LOJA "
   _cQuery +=" LEFT JOIN  "+ RetSqlName("SA3") +" SA3 ON SA3.D_E_L_E_T_ = '' AND A3_COD = C5_VEND1 "
   _cQuery +=" WHERE SF2.D_E_L_E_T_ = '' "   
   _cQuery +=" AND F2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
   _cQuery +=" ORDER BY F2_FILIAL,F2_EMISSAO " 

   dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQuery)),"TLP",.T.,.F.)

   If	!USED()
	   MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
   EndIf

   TLP->(DbGoTop())
   oReport:SetMeter(TLP->(RecCount()))

               
   While TLP->(!Eof())
       
       _cFil := TLP->F2_FILIAL      
       nFilial := 0
       
       If oReport:Cancel()
	      Exit
       EndIf	          
      
       While TLP->(!Eof()) .AND. _cFil = TLP->F2_FILIAL 
	         oReport:IncMeter()
	         oSection1:Cell("C_PED"):SetValue(TLP->C5_NUM)
	         oSection1:Cell("C_CLI" ):SetValue(TLP->F2_CLIENTE+"-"+TLP->F2_LOJA+" "+TLP->A1_NOME)
	         oSection1:Cell("C_TRANSP"):SetValue(A4_NREDUZ)
	         oSection1:Cell("C_NF"):SetValue(TLP->F2_DOC+"-"+F2_SERIE)
	         oSection1:Cell("C_VOL"):SetValue(TLP->F2_VOLUME1)
  	         oSection1:Cell("C_DTEMIS"):SetValue(SUBSTR(TLP->F2_EMISSAO,7,2)+"/"+SUBSTR(TLP->F2_EMISSAO,5,2)+"/"+SUBSTR(TLP->F2_EMISSAO,1,4))
 	         oSection1:Cell("C_PEDCLI"):SetValue(TLP->C5_PEDCLI)                     
 	         oSection1:Cell("C_EST"):SetValue(TLP->A1_EST)
  	         oSection1:Cell("C_MUN"):SetValue(ALLTRIM(TLP->A1_MUN))
  	         //oSection1:Cell("C_VLR"):SetValue(TLP->F2_VALBRUT)
            if !EMPTY(TLP->E1_VENCTO)
 	            oSection1:Cell("C_VENC"):SetValue(SUBSTR(TLP->E1_VENCTO,7,2)+"/"+SUBSTR(TLP->E1_VENCTO,5,2)+"/"+SUBSTR(TLP->E1_VENCTO,1,4))
 	         else 
 	            oSection1:Cell("C_VENC"):SetValue("")
 	         endif
 	         oSection1:Cell("C_PARC"):SetValue(TLP->E1_VALOR)
 	         oSection1:Cell("C_CVEND"):SetValue(TLP->C5_VEND1)
 	         oSection1:Cell("C_NVEND"):SetValue(TLP->A3_NOME)
            oSection1:Cell("C_BASPIS"):SetValue(TLP->F2_BASIMP5)
            oSection1:Cell("C_ALQPIS"):SetValue(TLP->D2_ALQIMP5)
            oSection1:Cell("C_VALPIS"):SetValue(TLP->F2_VALIMP5)
            oSection1:Cell("C_BASCOF"):SetValue(TLP->F2_BASIMP6)
            oSection1:Cell("C_ALQCOF"):SetValue(TLP->D2_ALQIMP6)
            oSection1:Cell("C_VALCOF"):SetValue(TLP->F2_VALIMP6)
            oSection1:Cell("C_BASICM"):SetValue(TLP->F2_BASEICM)
            oSection1:Cell("C_ALQICM"):SetValue(TLP->D2_PICM)
            oSection1:Cell("C_VALICM"):SetValue(TLP->F2_VALICM)
            oSection1:Cell("C_ICMSST"):SetValue(TLP->F2_ICMSRET)
	         oReport:SkipLine()
	         oSection1:PrintLine()       
	         nFilial   += TLP->E1_VALOR
            nTotTotal += TLP->E1_VALOR
	         TLP->(dbSkip())
	   Enddo
	   if nFilial > 0 
	      Sal_linha(1)
          oReport:IncMeter()
          oSection1:Cell("C_PED"):SetValue("TOTAL FILIAL"+_cFil)
          oSection1:Cell("C_CLI" ):SetValue("")
          oSection1:Cell("C_TRANSP"):SetValue("")
          oSection1:Cell("C_NF"):SetValue("")
          oSection1:Cell("C_VOL"):SetValue("")
          oSection1:Cell("C_DTEMIS"):SetValue("")
          oSection1:Cell("C_PEDCLI"):SetValue("")
          oSection1:Cell("C_EST"):SetValue("")
          oSection1:Cell("C_MUN"):SetValue("")
          //oSection1:Cell("C_VLR"):SetValue(nFilial)
          oSection1:Cell("C_VENC"):SetValue("")
          oSection1:Cell("C_PARC"):SetValue(nFilial)
          oSection1:Cell("C_CVEND"):SetValue("")
 	       oSection1:Cell("C_NVEND"):SetValue("")
          oSection1:Cell("C_BASPIS"):SetValue("")
          oSection1:Cell("C_ALQPIS"):SetValue("")
          oSection1:Cell("C_VALPIS"):SetValue("")
          oSection1:Cell("C_BASCOF"):SetValue("")
          oSection1:Cell("C_ALQCOF"):SetValue("")
          oSection1:Cell("C_VALCOF"):SetValue("")
          oSection1:Cell("C_BASICM"):SetValue("")
          oSection1:Cell("C_ALQICM"):SetValue("")
          oSection1:Cell("C_VALICM"):SetValue("")
          oSection1:Cell("C_ICMSST"):SetValue("")
          oReport:SkipLine()
          oSection1:PrintLine()  
          Sal_linha(1)
       endif
   Enddo  
   if nTotTotal > 0 
      Sal_linha(1)
      oReport:IncMeter()
      oSection1:Cell("C_PED"):SetValue("TOTAL")
      oSection1:Cell("C_CLI" ):SetValue("")
      oSection1:Cell("C_TRANSP"):SetValue("")
      oSection1:Cell("C_NF"):SetValue("")
      oSection1:Cell("C_VOL"):SetValue("")
      oSection1:Cell("C_DTEMIS"):SetValue("")
      oSection1:Cell("C_PEDCLI"):SetValue("")
      oSection1:Cell("C_EST"):SetValue("")
      oSection1:Cell("C_MUN"):SetValue("")
      //oSection1:Cell("C_VLR"):SetValue(nTotTotal)
      oSection1:Cell("C_VENC"):SetValue("")
      oSection1:Cell("C_PARC"):SetValue(nTotTotal)
      oSection1:Cell("C_CVEND"):SetValue("")
 	   oSection1:Cell("C_NVEND"):SetValue("")
      oSection1:Cell("C_BASPIS"):SetValue("")
      oSection1:Cell("C_ALQPIS"):SetValue("")
      oSection1:Cell("C_VALPIS"):SetValue("")
      oSection1:Cell("C_BASCOF"):SetValue("")
      oSection1:Cell("C_ALQCOF"):SetValue("")
      oSection1:Cell("C_VALCOF"):SetValue("")
      oSection1:Cell("C_BASICM"):SetValue("")
      oSection1:Cell("C_ALQICM"):SetValue("")
      oSection1:Cell("C_VALICM"):SetValue("")
      oSection1:Cell("C_ICMSST"):SetValue("")
      oReport:SkipLine()
      oSection1:PrintLine()  
   endif
   Sal_linha(1)  
   oReport:IncMeter()
   oSection1:Cell("C_PED"):SetValue("Periodo:")
   oSection1:Cell("C_CLI" ):SetValue(dtoc(mv_par01) +"  a  "+dtoc(mv_par02))
   oSection1:Cell("C_TRANSP"):SetValue("")
   oSection1:Cell("C_NF"):SetValue("")
   oSection1:Cell("C_VOL"):SetValue("")
   oSection1:Cell("C_DTEMIS"):SetValue("")
   oSection1:Cell("C_PEDCLI"):SetValue("")
   oSection1:Cell("C_EST"):SetValue("")  
   oSection1:Cell("C_MUN"):SetValue("")
   //oSection1:Cell("C_VLR"):SetValue("")
   oSection1:Cell("C_VENC"):SetValue("")
   oSection1:Cell("C_PARC"):SetValue("")
   oSection1:Cell("C_CVEND"):SetValue("")
   oSection1:Cell("C_NVEND"):SetValue("")
   oSection1:Cell("C_BASPIS"):SetValue("")
   oSection1:Cell("C_ALQPIS"):SetValue("")
   oSection1:Cell("C_VALPIS"):SetValue("")
   oSection1:Cell("C_BASCOF"):SetValue("")
   oSection1:Cell("C_ALQCOF"):SetValue("")
   oSection1:Cell("C_VALCOF"):SetValue("")
   oSection1:Cell("C_BASICM"):SetValue("")
   oSection1:Cell("C_ALQICM"):SetValue("")
   oSection1:Cell("C_VALICM"):SetValue("")
   oSection1:Cell("C_ICMSST"):SetValue("")
   oReport:SkipLine()
   oSection1:PrintLine()     
   * 
   TLP->(dbCloseArea())
   oSection1:Finish()      

Return             

//-------------------------------------------------------------------
//  Incluir linha em branco
//-------------------------------------------------------------------
Static Function Sal_linha(nx)
Local x

  for x:=1 to nx
      oReport:IncMeter()
      oSection1:Cell("C_PED"):SetValue("")
      oSection1:Cell("C_CLI" ):SetValue("")
      oSection1:Cell("C_TRANSP"):SetValue("")
      oSection1:Cell("C_NF"):SetValue("")
      oSection1:Cell("C_VOL"):SetValue("")
      oSection1:Cell("C_DTEMIS"):SetValue("")
      oSection1:Cell("C_PEDCLI"):SetValue("")
      oSection1:Cell("C_EST"):SetValue("")      
      oSection1:Cell("C_MUN"):SetValue("")
      //oSection1:Cell("C_VLR"):SetValue("")
      oSection1:Cell("C_VENC"):SetValue("")
      oSection1:Cell("C_PARC"):SetValue("")
      oSection1:Cell("C_CVEND"):SetValue("")
 	   oSection1:Cell("C_NVEND"):SetValue("")
      oSection1:Cell("C_BASPIS"):SetValue("")
      oSection1:Cell("C_ALQPIS"):SetValue("")
      oSection1:Cell("C_VALPIS"):SetValue("")
      oSection1:Cell("C_BASCOF"):SetValue("")
      oSection1:Cell("C_ALQCOF"):SetValue("")
      oSection1:Cell("C_VALCOF"):SetValue("")
      oSection1:Cell("C_BASICM"):SetValue("")
      oSection1:Cell("C_ALQICM"):SetValue("")
      oSection1:Cell("C_VALICM"):SetValue("") 
      oSection1:Cell("C_ICMSST"):SetValue("")   
      oReport:SkipLine()
      oSection1:PrintLine()     
  Next

Return Nil

//-------------------------------------------------------------------
//  Ajusta o arquivo de perguntas SX1
//-------------------------------------------------------------------
Static Function CriaSx1(cPerg)

	u_HMPutSX1(cPerg, "01", PADR("Da Data "   ,29)+"?"             ,"","", "mv_ch1" , "D", 8 , 0, 0, "G", "",   "", "", "", "mv_par01")
	u_HMPutSX1(cPerg, "02", PADR("Ate Data "  ,29)+"?"             ,"","", "mv_ch2" , "D", 8 , 0, 0, "G", "",   "", "", "", "mv_par02")
	u_HMPutSX1(cPerg, "03", PADR("Cfop Fil 01",29)+"?"             ,"","", "mv_ch3" , "C", 20, 0, 0, "G", "",   "", "", "", "mv_par03")
	u_HMPutSX1(cPerg, "04", PADR("Cfop Fil 02",29)+"?"             ,"","", "mv_ch4" , "C", 20, 0, 0, "G", "",   "", "", "", "mv_par04")
	u_HMPutSX1(cPerg, "05", PADR("Cfop Fil 04",29)+"?"             ,"","", "mv_ch5" , "C", 20, 0, 0, "G", "",   "", "", "", "mv_par05")	
	u_HMPutSX1(cPerg, "06", PADR("Filial     ",29)+"?"             ,"","", "mv_ch6" , "N", 1 , 0, 1, "C", "", ""  , "", "", "mv_par06","Filial01","","","","Filial02","","","Filial04","","","Ambas")   	

Return Nil
