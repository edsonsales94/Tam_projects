#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWCOMMAND.CH"
/*_______________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ FunÁ?o    ¶ AAESTR19   ¶ Autor ¶ ANDERSON GADELHA     ¶ Data ¶ 09/07/2019 ¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ DescriÁ?o ¶ Relatório de Analise de tranferencia.                         ¶¶¶
¶¶+-----------+---------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ*/ 

User Function AAESTR19()

local oReport   
local cPerg   := 'AAESTR19'
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
//Local cCondicao := ""

oSecao1:BeginQuery()

		BeginSql alias "AAESTR19"
		
					
					SELECT * 
  FROM ( SELECT D1_FILIAL, D1_FORNECE, D1_LOJA, D1_DOC, D1_SERIE, D1_COD, D1_DTDIGIT, D1_TIPO, D1_TES , D1_LOTECTL, A2_FILTRF, F1_FILORIG,
                SUM(D1_QUANT) AS D1_QUANT, SUM(D1_CUSTO) AS D1_CUSTO
		   FROM SD1010 SD1 (nolock)
		   inner join SF4010 AS SF4 (NOLOCK) ON SF4.D_E_L_E_T_ = '' AND  F4_CODIGO = D1_TES AND F4_ESTOQUE = 'S'
		   INNER JOIN SF1010 AS SF1 (NOLOCK) ON SF1.D_E_L_E_T_ = '' AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA
		   INNER JOIN SA2010 AS SA2 (NOLOCK) ON SA2.D_E_L_E_T_ = '' AND A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA
		  
		  WHERE SD1.D_E_L_E_T_ = ''
		    AND D1_DTDIGIT BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% 
		    AND  Substring(D1_CF, 2, 3) In ('151','152','408','409','905','906')
		   GROUP BY D1_FILIAL, D1_FORNECE, D1_LOJA, D1_DOC, D1_SERIE, D1_COD, D1_DTDIGIT, D1_TIPO, D1_TES, D1_LOTECTL , A2_FILTRF, F1_FILORIG
	  ) AS SD1 
 FULL JOIN ( SELECT D2_FILIAL, D2_EMISSAO, D2_CLIENTE, D2_LOJA, D2_DOC, D2_SERIE, D2_COD, D2_TES, D2_CF , D2_TIPO, A1_FILTRF, F2_FILDEST, 
                    SUM(D2_QUANT) AS D2_QUANT , SUM(D2_CUSTO1) AS D2_CUSTO1
               From SD2010 AS SD2 (nolock)
			   inner join SA1010 AS SA1 (NOLOCK) ON SA1.D_E_L_E_T_ = '' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA
			   INNER JOIN SF2010 AS SF1 (NOLOCK) ON SF1.D_E_L_E_T_ = '' AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA
			  inner join SF4010 AS SF4 (NOLOCK) ON SF4.D_E_L_E_T_ = '' AND F4_CODIGO = D2_TES AND  F4_ESTOQUE = 'S'
              Where SD2.D_E_L_E_T_ = ''
                And left(D2_EMISSAO, 6) = '202106' 
				AND  Substring(D2_CF, 2, 3) In ('151','152','408','409','905','906')
				GROUP BY D2_FILIAL, D2_EMISSAO, D2_CLIENTE, D2_LOJA, D2_DOC, D2_SERIE, D2_COD, D2_TES, D2_CF , D2_TIPO, A1_FILTRF, F2_FILDEST
           ) SD2
On  D1_DOC = D2_DOC AND D2_SERIE = D1_SERIE AND D2_COD = D1_COD AND ROUND(D1_QUANT, 2) = ROUND(D2_QUANT, 2) 


  
					
							      		  
		EndSql

		
cAlias:="AAESTR19"
oSecao1:EndQuery()
oReport:SetMeter((cAlias)->(RecCount()))
oSecao1:Print()

return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Relatório de Analise de tranferencia"
local cHelp   := "Relatório de Analise de tranferencia - Especifico Amazon Aço"
local oReport
local oSection1

oReport := TReport():New('AAESTR19',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
oReport:SetLandScape()
	  				  
//Primeira seção
oSection1 := TRSection():New(oReport,"Relatório de Analise de tranferencia",{"AAESTR19"})

TRCell():New( oSection1, "D1_FILIAL"   	, "AAESTR19", RetTitle("D1_FILIAL"		),PesqPict("SD1","D1_FILIAL"	),TamSx3("D1_FILIAL"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D1_FORNECE"   , "AAESTR19", RetTitle("D1_FORNECE"		),PesqPict("SD1","D1_FORNECE"	),TamSx3("D1_FORNECE"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D1_LOJA"   	, "AAESTR19", RetTitle("D1_LOJA"		),PesqPict("SD1","D1_LOJA"		),TamSx3("D1_LOJA"			)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D1_DOC"   	, "AAESTR19", RetTitle("D1_DOC"	    	),PesqPict("SD1","D1_DOC"		),TamSx3("D1_DOC"			)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D1_SERIE"   	, "AAESTR19", RetTitle("D1_SERIE"		),PesqPict("SD1","D1_SERIE"		),TamSx3("D1_SERIE"			)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D1_COD"   	, "AAESTR19", RetTitle("D1_COD"			),PesqPict("SD1","D1_COD"		),TamSx3("D1_COD"			)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D1_DTDIGIT"  	, "AAESTR19", RetTitle("D1_DTDIGIT"		),PesqPict("SD1","D1_DTDIGIT"	),TamSx3("D1_DTDIGIT"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D1_TIPO"   	, "AAESTR19", RetTitle("D1_TIPO"		),PesqPict("SD1","D1_TIPO"		),TamSx3("D1_TIPO"			)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D1_TES"   	, "AAESTR19", RetTitle("D1_TES"			),PesqPict("SD1","D1_TES"		),TamSx3("D1_TES"			)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D1_LOTECTL"  	, "AAESTR19", RetTitle("D1_LOTECTL"		),PesqPict("SD1","D1_LOTECTL"	),TamSx3("D1_LOTECTL"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "A2_FILTRF"   	, "AAESTR19", RetTitle("A2_FILTRF"		),PesqPict("SA2","A2_FILTRF"	),TamSx3("A2_FILTRF"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "F1_FILORIG"  	, "AAESTR19", RetTitle("F1_FILORIG"		),PesqPict("SF1","F1_FILORIG"	),TamSx3("F1_FILORIG"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D1_QUANT"   	, "AAESTR19", RetTitle("D1_QUANT"		),PesqPict("SD1","D1_QUANT"		),TamSx3("D1_QUANT"			)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D1_CUSTO"   	, "AAESTR19", RetTitle("D1_CUSTO"		),PesqPict("SD1","D1_CUSTO"		),TamSx3("D1_CUSTO"			)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D2_FILIAL"   	, "AAESTR19", RetTitle("D2_FILIAL"		),PesqPict("SD2","D2_FILIAL"	),TamSx3("D2_FILIAL"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D2_EMISSAO"  	, "AAESTR19", RetTitle("D2_EMISSAO"		),PesqPict("SD2","D2_EMISSAO"	),TamSx3("D2_EMISSAO"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D2_CLIENTE"  	, "AAESTR19", RetTitle("CT1_DESC01"		),PesqPict("CT1","CT1_DESC01"	),TamSx3("CT1_DESC01"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D2_LOJA"   	, "AAESTR19", RetTitle("D2_LOJA"		),PesqPict("SD2","D2_LOJA"		),TamSx3("D2_LOJA"			)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D2_DOC"   	, "AAESTR19", RetTitle("D2_DOC"			),PesqPict("SD2","D2_DOC"		),TamSx3("D2_DOC"			)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D2_SERIE"   	, "AAESTR19", RetTitle("D2_SERIE"		),PesqPict("SD2","D2_SERIE"		),TamSx3("D2_SERIE"			)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D2_COD"   	, "AAESTR19", RetTitle("D2_COD"			),PesqPict("SD2","D2_COD"		),TamSx3("D2_COD"			)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D2_TES"   	, "AAESTR19", RetTitle("D2_TES"			),PesqPict("SD2","D2_TES"		),TamSx3("D2_TES"			)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D2_CF"   		, "AAESTR19", RetTitle("D2_CF"			),PesqPict("SD2","D2_CF"		),TamSx3("D2_CF"			)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D2_TIPO"   	, "AAESTR19", RetTitle("D2_TIPO"		),PesqPict("SD2","D2_TIPO"		),TamSx3("D2_TIPO"			)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "A1_FILTRF"   	, "AAESTR19", RetTitle("A1_FILTRF"		),PesqPict("SA1","A1_FILTRF"	),TamSx3("A1_FILTRF"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "F2_FILDEST"  	, "AAESTR19", RetTitle("F2_FILDEST"		),PesqPict("SF2","F2_FILDEST"	),TamSx3("F2_FILDEST"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D2_QUANT"   	, "AAESTR19", RetTitle("D2_QUANT"		),PesqPict("SD2","D2_QUANT"		),TamSx3("D2_QUANT"			)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection1, "D2_CUSTO1"   	, "AAESTR19", RetTitle("D2_CUSTO1"		),PesqPict("SD2","D2_CUSTO1"	),TamSx3("D2_CUSTO1"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  

					   
Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+

Static function criaSX1(cPerg)

	U_PIPutSx1(cPerg, '01', 'Data De?'          , '', '', 'mv_ch1', 'D', 8, 0, 0, 'G', '',      '',  '', '', 'mv_par01')
	U_PIPutSx1(cPerg, '02', 'Até Data?'         , '', '', 'mv_ch2', 'D', 8, 0, 0, 'G', '',      '',  '', '', 'mv_par02')
	
Return



 
