#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWCOMMAND.CH"
/*_______________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ FunÁ?o    ¶ AAIMPORT01 ¶ Autor ¶ ANDERSON GADELHA     ¶ Data ¶ 25/07/2019 ¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ DescriÁ?o ¶ Relatório de DCR-E.                                           ¶¶¶
¶¶+-----------+---------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ*/ 

User Function AAIMPORT01()

local oReport   
local cPerg   := 'AAIMPORT01'
local cAlias  := getNextAlias()


criaSx1(cPerg)
Pergunte(cPerg, .F.)

oReport := reportDef(cAlias, cPerg)
oReport:printDialog()

return
       
//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relatório.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport,cAlias) 

Local oSecao1   := oReport:Section(1)
Local cCondicao := ""

oSecao1:BeginQuery()

		BeginSql alias "AAIMPORT01"
		
					
				 SELECT 
						D2_FILIAL, 
						D2_COD, 
						B1_ESPECIF,  
						C6_XDCRE,
						B1_XDCRE, 
						D2_TP, 
						D2_DOC, 
						D2_SERIE, 
						D2_QUANT, 
						D2_PRCVEN, 
						D2_CF, 
						D2_UM, 
						D2_TOTAL, 
						D2_EMISSAO, 
						D2_EST						
						 
		          FROM %table:SD2% (NOLOCK) A
				  INNER JOIN %table:SC6% (NOLOCK) B 
											      ON D2_COD = C6_PRODUTO 
											      AND D2_FILIAL = C6_FILIAL 
											      AND D2_PEDIDO = C6_NUM 
											      AND D2_ITEMPV = C6_ITEM 
											      AND B.D_E_L_E_T_ =''
		                                        
				  INNER JOIN %table:SB1% (NOLOCK) C 
											      ON D2_COD = B1_COD 
											      AND C.D_E_L_E_T_ =''
		WHERE A.D_E_L_E_T_=''
		and D2_EMISSAO between %Exp:mv_par01% AND %Exp:mv_par02%
		and D2_FILIAL  between %Exp:mv_par03% AND %Exp:mv_par04%  
		AND B1_XDCRE  <> ''
					
							      		  
		EndSql

		
cAlias:="AAIMPORT01"
oSecao1:EndQuery()
oReport:SetMeter((cAlias)->(RecCount()))
oSecao1:Print()

return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Relatório de DCR-E."
local cHelp   := "Relatório de DCR-E - Especifico Amazon Aço"
local oReport
local oSection1

oReport := TReport():New('AAIMPORT01',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
oReport:SetLandScape()
	  				  
//Primeira seção
oSection1 := TRSection():New(oReport,"Relatório de DCR-E.",{"AAIMPORT01"})

TRCell():New(oSection1,"D2_FILIAL"      , "AAIMPORT01",  "D2_FILIAL"               ,PesqPict("SD2","D2_FILIAL")    ,TamSX3("D2_FILIAL")  [1])
TRCell():New(oSection1,"D2_COD"         , "AAIMPORT01", RetTitle("D2_COD")         ,PesqPict("SD2","D2_COD")       ,TamSX3("D2_COD")  [1])
TRCell():New(oSection1,"B1_ESPECIF"     , "AAIMPORT01", RetTitle("B1_ESPECIF")     ,PesqPict("SB1","B1_ESPECIF")   ,TamSX3("B1_ESPECIF")  [1])
TRCell():New(oSection1,"C6_XDCRE"       , "AAIMPORT01", RetTitle("C6_XDCRE")       ,PesqPict("SC6","C6_XDCRE")     ,TamSX3("C6_XDCRE")[1])
TRCell():New(oSection1,"B1_XDCRE"       , "AAIMPORT01", RetTitle("B1_XDCRE")       ,PesqPict("SB1","C6_XDCRE")     ,TamSX3("B1_XDCRE")[1])
TRCell():New(oSection1,"D2_TP"          , "AAIMPORT01", RetTitle("D2_TP")          ,PesqPict("SD2","D2_TP")        ,TamSX3("D2_TP")  [1])
TRCell():New(oSection1,"D2_DOC"         , "AAIMPORT01", RetTitle("D2_DOC")         ,PesqPict("SD2","D2_DOC")       ,TamSX3("D2_DOC")[1])
TRCell():New(oSection1,"D2_SERIE"       , "AAIMPORT01", RetTitle("D2_SERIE")       ,PesqPict("SD2","D2_SERIE")     ,TamSX3("D2_SERIE")[1])
TRCell():New(oSection1,"D2_QUANT"       , "AAIMPORT01", RetTitle("D2_QUANT")       ,PesqPict("SD2","D2_QUANT")     ,TamSX3("D2_QUANT")  [1])
TRCell():New(oSection1,"D2_PRCVEN"      , "AAIMPORT01", RetTitle("D2_PRCVEN")      ,PesqPict("SD2","D2_PRCVEN")    ,TamSX3("D2_PRCVEN")  [1])
TRCell():New(oSection1,"D2_CF"          , "AAIMPORT01", RetTitle("D2_CF")          ,PesqPict("SD2","D2_CF")        ,TamSX3("D2_CF")   [1])
TRCell():New(oSection1,"D2_UM"          , "AAIMPORT01", RetTitle("D2_UM")          ,PesqPict("SD2","D2_UM")        ,TamSX3("D2_UM")   [1])
TRCell():New(oSection1,"D2_TOTAL"       , "AAIMPORT01", RetTitle("D2_TOTAL")       ,PesqPict("SD2","D2_TOTAL")     ,TamSX3("D2_TOTAL")[1])
TRCell():New(oSection1,"D2_EMISSAO"     , "AAIMPORT01", RetTitle("D2_EMISSAO")     ,PesqPict("SD2","D2_EMISSAO")   ,TamSX3("D2_EMISSAO")[1])
TRCell():New(oSection1,"D2_EST"         , "AAIMPORT01", RetTitle("D2_EST")         ,PesqPict("SD2","D2_EST")       ,TamSX3("D2_EST")[1])
					   
	
Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+

Static function criaSX1(cPerg)

	U_PIPutSx1(cPerg, '01', 'Da Data?'          , '', '', 'mv_ch1', 'D', 6, 0, 0, 'G', '',      '',  '', '', 'mv_par01')
	U_PIPutSx1(cPerg, '02', 'Até Data?'         , '', '', 'mv_ch2', 'D', 6, 0, 0, 'G', '',      '',  '', '', 'mv_par02')
	U_PIPutSx1(cPerg, '03', 'Da Filial?'        , '', '', 'mv_ch2', 'F', 2, 0, 0, 'G', '',      '',  '', '', 'mv_par03')
	U_PIPutSx1(cPerg, '04', 'Até Filial?'       , '', '', 'mv_ch2', 'F', 2, 0, 0, 'G', '',      '',  '', '', 'mv_par04')
	
Return