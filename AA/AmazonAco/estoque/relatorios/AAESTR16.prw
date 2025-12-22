
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Exemplo de relatorio usando tReport com duas Section
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
user function AAESTR16()
	Local cPerg := PADR("AAESTR16",Len(SX1->X1_GRUPO))
	
	Private oReport, oSection1, oSection

	fValidSX1()
	Pergunte(cPerg,.F.)
	
	oReport := ReportDef(cPerg)
	If !Empty(oReport:uParam)
		Pergunte(oReport:uParam,.F.)
	EndIf
	oReport:PrintDialog()

return
  Static Function ReportDef(cPerg)

local cTitle  := "Composicao De Saldo"
local cHelp   := "Composicao De Saldo"
Local aOrdem  := {"Composicao De Saldo"}
local oReport
local oSection1
local oSection2
local oBreak1
Local nTotal	:= 0
oReport := TReport():New("AAESTR16", cTitle, cPerg , {|oReport| ReportPrint(oReport)},cTitle)
oReport:oPage:SetPaperSize(9)
oReport:SetPortrait(.T.)
oReport:SetTotalInLine(.F.)


//Segunda seção
oSection2:= TRSection():New(oReport,"Saldos Por Centro de Custo",{"TMP"},aOrdem)          
oSection2:AutoSize(.F.)
TRCell():New( oSection2, "B1_COD"               , "", RetTitle("B1_COD"		    ),PesqPict("SB1","B1_COD"	    ),TamSx3("B1_COD"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection2, "B1_MSBLQL"	        , "", RetTitle("B1_MSBLQL"		),PesqPict("SB1","B1_MSBLQL"	),TamSx3("B1_MSBLQL"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection2, "B1_DESC"   	        , "", RetTitle("B1_DESC"		),PesqPict("SB1","B1_DESC"		),TamSx3("B1_DESC"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "B1_TIPO"   	        , "", RetTitle("B1_TIPO"		),PesqPict("SB1","B1_TIPO"		),TamSx3("B1_TIPO"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection2, "B1_UM"   	            , "", RetTitle("B1_UM"		    ),PesqPict("SB1","B1_UM"	    ),TamSx3("B1_UM"		    )[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection2, "B2_LOCAL"		        , "", RetTitle("B2_LOCAL"		),PesqPict("SB2","B2_LOCAL"		),TamSx3("B2_LOCAL"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection2, "QTD_INI"   	        , "", "QTD_INI"  			     ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "CUSTO_INI"   	        , "", "CUSTO_INI"			     ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "QTD_COMPRAS"   	    , "", "QTD_COMPRAS"			     ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "CUSTO_COMPRAS"   	    , "", "CUSTO_COMPRAS"			 ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "QTD_OUTRAS_ENT"   	, "", "QTD_OUTRAS_ENT"			 ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "CUSTO_OUTRAS_ENT"   	, "", "CUSTO_OUTRAS_ENT"		 ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "QTD_CONSUMO"   	    , "", "QTD_CONSUMO"			     ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "CUSTO_CONSUMO"   	    , "", "CUSTO_CONSUMO"			 ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "QTD_PRODUCAO"   	    , "", "QTD_PRODUCAO"			 ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "CUSTO_PRODUCAO"   	, "", "CUSTO_PRODUCAO"			 ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "QTD_OUTRAS_REQ"   	, "", "QTD_OUTRAS_REQ"			 ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "CUSTO_OUTRAS_REQ"   	, "", "CUSTO_OUTRAS_REQ"		 ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "QTD_OUTRAS_DEV"   	, "", "QTD_OUTRAS_DEV"			 ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "CUSTO_OUTRAS_DEV"   	, "", "CUSTO_OUTRAS_DEV"		 ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "QTD_CPV"   	        , "", "QTD_CPV"			         ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "CUSTO_CPV"   	        , "", "CUSTO_CPV"			     ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "QTD_OUTRAS_SAIDAS"   	, "", "QTD_OUTRAS_SAIDAS"		 ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "CUSTO_OUTRAS_SAIDAS"  , "", "CUSTO_OUTRAS_SAIDAS"		 ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "QTD_MODELO7"   	    , "", "QTD_MODELO7"			     ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "CUSTO_MODELO7"   	    , "", "CUSTO_MODELO7"			 ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "QTD_MOEDLO3"   	    , "", "QTD_MOEDLO3"			     ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "CUSTO_MODELO3"   	    , "", "CUSTO_MODELO3"			 ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "DIF_QTD"   	        , "", "DIF_QTD"			         ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "DIF_CUSTO"   	        , "", "DIF_CUSTO"			     ,"@E 999,999,999.99"                                    ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)

  
oSection2:SetTotalInLine(.F.)	

                          	
Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relatório.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport)

local oSection2 := oReport:Section(1)  
local cOrdem 
Local cQry := "" 
Local nTotREG := 0                                                

if oReport:Section(1):GetOrder() == 1
	cOrdem := "B1_COD"
Else
	cOrdem := "B1_COD"		 
endif 


cQry+= "SELECT B1_COD, B1_MSBLQL, B1_DESC, B1_TIPO, B1_UM, B2_LOCAL,"
cQry+=     "ISNULL(QTD_INI            , 0) AS QTD_INI,"
cQry+=	   "ISNULL(CUSTO_INI          , 0) AS CUSTO_INI,"
cQry+=     "ISNULL(QTD_COMPRAS        , 0) AS QTD_COMPRAS," 
cQry+=	   "ISNULL(CUSTO_COMPRAS      , 0) AS CUSTO_COMPRAS,"
cQry+=	   "ISNULL(QTD_OUTRAS_ENT     , 0) AS QTD_OUTRAS_ENT,"
cQry+=	   "ISNULL(CUSTO_OUTRAS_ENT   , 0) AS CUSTO_OUTRAS_ENT,"
cQry+=	   "ISNULL(QTD_CONSUMO        , 0) AS QTD_CONSUMO,"
cQry+=	   "ISNULL(CUSTO_CONSUMO      , 0) AS CUSTO_CONSUMO," 
cQry+=	   "ISNULL(QTD_PRODUCAO       , 0) AS QTD_PRODUCAO,"
cQry+=	   "ISNULL(CUSTO_PRODUCAO     , 0) AS CUSTO_PRODUCAO," 
cQry+=	   "ISNULL(QTD_OUTRAS_REQ     , 0) AS QTD_OUTRAS_REQ,"
cQry+=	   "ISNULL(CUSTO_OUTRAS_REQ   , 0) AS CUSTO_OUTRAS_REQ,"
cQry+=	   "ISNULL(QTD_OUTRAS_DEV     , 0) AS QTD_OUTRAS_DEV,"
cQry+=	   "ISNULL(CUSTO_OUTRAS_DEV   , 0) AS CUSTO_OUTRAS_DEV,"
cQry+=	   "ISNULL(QTD_CPV            , 0) AS QTD_CPV          ,"
cQry+=	   "ISNULL(CUSTO_CPV          , 0) AS CUSTO_CPV          ,"
cQry+=	   "ISNULL(QTD_OUTRAS_SAIDAS  , 0) AS QTD_OUTRAS_SAIDAS,"
cQry+=	   "ISNULL(CUSTO_OUTRAS_SAIDAS, 0) AS CUSTO_OUTRAS_SAIDAS," 
cQry+=	   "ISNULL(QTD_FINAL_2        , QTD_FIMB2) AS QTD_MODELO7        ," 
cQry+=	   "ISNULL(CUSTO_FINAL_2      , CUSTO_FIMB2) AS CUSTO_MODELO7,"
cQry+=     "ISNULL(QTD_INI            , 0) + ISNULL(QTD_COMPRAS        , 0) + ISNULL(QTD_OUTRAS_ENT     , 0) - ISNULL(QTD_CONSUMO        , 0) + ISNULL(QTD_PRODUCAO       , 0) - ISNULL(QTD_OUTRAS_REQ     , 0) + ISNULL(QTD_OUTRAS_DEV     , 0) - ISNULL(QTD_CPV            , 0) - ISNULL(QTD_OUTRAS_SAIDAS  , 0)     AS QTD_MOEDLO3,"
cQry+=     "ISNULL(QTD_INI            , 0) + ISNULL(QTD_COMPRAS        , 0) + ISNULL(QTD_OUTRAS_ENT     , 0) - ISNULL(QTD_CONSUMO        , 0) + ISNULL(QTD_PRODUCAO       , 0) - ISNULL(QTD_OUTRAS_REQ     , 0) + ISNULL(QTD_OUTRAS_DEV     , 0) - ISNULL(QTD_CPV            , 0) - ISNULL(QTD_OUTRAS_SAIDAS  , 0)     AS QTD_MOEDLO3,"
cQry+=     "ISNULL(QTD_INI            , 0) + ISNULL(QTD_COMPRAS        , 0) + ISNULL(QTD_OUTRAS_ENT     , 0) - ISNULL(QTD_CONSUMO        , 0) + ISNULL(QTD_PRODUCAO       , 0) - ISNULL(QTD_OUTRAS_REQ     , 0) + ISNULL(QTD_OUTRAS_DEV     , 0) - ISNULL(QTD_CPV            , 0) - ISNULL(QTD_OUTRAS_SAIDAS  , 0)     AS QTD_MOEDLO3,"
cQry+=     "ISNULL(QTD_INI            , 0) + ISNULL(QTD_COMPRAS        , 0) + ISNULL(QTD_OUTRAS_ENT     , 0) - ISNULL(QTD_CONSUMO        , 0) + ISNULL(QTD_PRODUCAO       , 0) - ISNULL(QTD_OUTRAS_REQ     , 0) + ISNULL(QTD_OUTRAS_DEV     , 0) - ISNULL(QTD_CPV            , 0) - ISNULL(QTD_OUTRAS_SAIDAS  , 0)     AS QTD_MOEDLO3,"
cQry+=	   "ROUND(ISNULL(CUSTO_INI    , 0) + ISNULL(CUSTO_COMPRAS      , 0) + ISNULL(CUSTO_OUTRAS_ENT   , 0) - ISNULL(CUSTO_CONSUMO      , 0) + ISNULL(CUSTO_PRODUCAO     , 0) - ISNULL(CUSTO_OUTRAS_REQ   , 0) + ISNULL(CUSTO_OUTRAS_DEV   , 0) - ISNULL(CUSTO_CPV          , 0) - ISNULL(CUSTO_OUTRAS_SAIDAS, 0), 2) AS CUSTO_MODELO3," 
cQry+=	   "ISNULL(QTD_FINAL_2        , 0) - ( ISNULL(QTD_INI            , 0) + ISNULL(QTD_COMPRAS        , 0) + ISNULL(QTD_OUTRAS_ENT     , 0) - ISNULL(QTD_CONSUMO        , 0) + ISNULL(QTD_PRODUCAO       , 0) - ISNULL(QTD_OUTRAS_REQ     , 0) + ISNULL(QTD_OUTRAS_DEV     , 0) - ISNULL(QTD_CPV            , 0) - ISNULL(QTD_OUTRAS_SAIDAS  , 0)     )  AS DIF_QTD,"
cQry+=	   "ISNULL(CUSTO_FINAL_2      , 0) - ( ROUND(ISNULL(CUSTO_INI    , 0) + ISNULL(CUSTO_COMPRAS      , 0) + ISNULL(CUSTO_OUTRAS_ENT   , 0) - ISNULL(CUSTO_CONSUMO      , 0) + ISNULL(CUSTO_PRODUCAO     , 0) - ISNULL(CUSTO_OUTRAS_REQ   , 0) + ISNULL(CUSTO_OUTRAS_DEV   , 0) - ISNULL(CUSTO_CPV          , 0) - ISNULL(CUSTO_OUTRAS_SAIDAS, 0), 2) ) AS DIF_CUSTO "
cQry+=  "FROM SB1010 SB1 (NOLOCK) "
cQry+=  "INNER JOIN ( SELECT B2_FILIAL, B2_COD, B2_LOCAL, SUM(B2_QFIM) QTD_FIMB2, SUM(B2_VFIM1) CUSTO_FIMB2 "
cQry+=                "FROM SB2010 AS SB9 (NOLOCK) "
cQry+=			   "WHERE SB9.D_E_L_E_T_ = '' "   				 
cQry+=			   "GROUP BY B2_FILIAL, B2_COD, B2_LOCAL "
cQry+=			") SB2A ON B1_COD = SB2A.B2_COD "
cQry+=  "LEFT JOIN ( SELECT B9_FILIAL, B9_COD, B9_LOCAL, SUM(B9_QINI) QTD_INI, SUM(B9_VINI1) CUSTO_INI "
cQry+=                "FROM SB9010 AS SB9 (NOLOCK) "
cQry+=			   "WHERE SB9.D_E_L_E_T_ = '' "   
cQry+=				 "AND B9_DATA ='"+DtoS(mv_par01)+"' " 
cQry+=			   "GROUP BY B9_FILIAL, B9_COD, B9_LOCAL " 
cQry+=			") SB9A ON B1_COD = SB9A.B9_COD AND B2_LOCAL = B9_LOCAL AND B2_FILIAL = B9_FILIAL "
cQry+=  "LEFT JOIN ( SELECT D1_FILIAL, D1_COD, D1_LOCAL, SUM(D1_QUANT) AS QTD_COMPRAS, SUM(D1_CUSTO) AS CUSTO_COMPRAS "
cQry+=                 "FROM SD1010 AS SD1 (NOLOCK) "    
cQry+=				 "INNER JOIN SF4010 SF4 (NOLOCK) ON SF4.D_E_L_E_T_ = ' ' AND F4_CODIGO  = D1_TES AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' "
cQry+=                "WHERE SD1.D_E_L_E_T_ = '' "  
cQry+=                  "AND D1_DTDIGIT >='"+DtoS(mv_par02)+"' "
cQry+=                  "AND D1_DTDIGIT <='"+DtoS(mv_par03)+"' " 
cQry+=				  "AND D1_TIPO IN ('N', 'C') "
cQry+=                "GROUP BY D1_FILIAL, D1_COD, D1_LOCAL "
cQry+=		    ") as SD1 ON D1_COD = B1_COD AND B2_LOCAL = SD1.D1_LOCAL AND D1_FILIAL = B2_FILIAL "
cQry+=  "LEFT JOIN ( SELECT D1_FILIAL AS FILD1, D1_COD AS CODD1, D1_LOCAL, SUM(D1_QUANT) AS QTD_OUTRAS_ENT, SUM(D1_CUSTO) AS CUSTO_OUTRAS_ENT "
cQry+=                "FROM SD1010 AS SD1 (NOLOCK) "    
cQry+=				"INNER JOIN SF4010 SF4 (NOLOCK) ON SF4.D_E_L_E_T_ = ' ' AND F4_CODIGO  = D1_TES AND F4_ESTOQUE = 'S' "
cQry+=               "WHERE SD1.D_E_L_E_T_ = ''  "
cQry+=                  "AND D1_DTDIGIT >='"+DtoS(mv_par02)+"' "
cQry+=                  "AND D1_DTDIGIT <='"+DtoS(mv_par03)+"' " 
cQry+=				 "AND (D1_TIPO NOT IN ('N', 'C') OR F4_DUPLIC <> 'S') "
cQry+=               "GROUP BY D1_FILIAL, D1_COD , D1_LOCAL "
cQry+=			") AS SB1B ON CODD1 = B1_COD AND B2_LOCAL = SB1B.D1_LOCAL AND FILD1 = B2_FILIAL "  
cQry+= "LEFT JOIN ( SELECT D3_FILIAL AS FILIAL_CONSUMO, D3_COD, D3_LOCAL, SUM(D3_QUANT) AS QTD_CONSUMO, SUM(D3_CUSTO1) CUSTO_CONSUMO "
cQry+=			    "FROM SD3010 AS SD3 (NOLOCK) "
cQry+=			   "WHERE SD3.D_E_L_E_T_ = '' "
cQry+=				 "AND D3_EMISSAO  >='"+DtoS(mv_par02)+"' "
cQry+=				 "AND D3_EMISSAO  <='"+DtoS(mv_par03)+"' " 
cQry+=				 "AND LEFT(D3_CF,1) = 'R' "
cQry+=				 "AND D3_OP <> '' "
cQry+=				 "AND D3_ESTORNO = '' "
cQry+=			   "GROUP BY D3_FILIAL, D3_COD , D3_LOCAL) SD31 ON SD31.D3_COD = B1_COD AND B2_LOCAL = SD31.D3_LOCAL AND FILIAL_CONSUMO = B2_FILIAL "
cQry+=  "LEFT JOIN ( SELECT D3_FILIAL AS FILIAL_PRODUCAO, D3_COD, D3_LOCAL, SUM(D3_QUANT) AS QTD_PRODUCAO, SUM(D3_CUSTO1) CUSTO_PRODUCAO "
cQry+=			    "FROM SD3010 AS SD3 (NOLOCK) "
cQry+=			   "WHERE SD3.D_E_L_E_T_ = '' "
cQry+=				 "AND D3_EMISSAO  >='"+DtoS(mv_par02)+"' "
cQry+=				 "AND D3_EMISSAO  <='"+DtoS(mv_par03)+"' " 
cQry+=				 "AND LEFT(D3_CF,1) IN ('P', 'D') "
cQry+=				 "AND D3_OP <> '' "
cQry+=				 "AND D3_ESTORNO = '' "
cQry+=			   "GROUP BY D3_FILIAL, D3_COD, D3_LOCAL ) SD32 ON SD32.D3_COD = B1_COD AND B2_LOCAL = SD32.D3_LOCAL AND FILIAL_PRODUCAO = B2_FILIAL "
cQry+=  "LEFT JOIN ( SELECT D3_FILIAL FILIAL_OUTRAS_REQ, D3_COD, D3_LOCAL, SUM(D3_QUANT) AS QTD_OUTRAS_REQ, SUM(D3_CUSTO1) CUSTO_OUTRAS_REQ "
cQry+=			    "FROM SD3010 AS SD3 (NOLOCK) "
cQry+=			   "WHERE SD3.D_E_L_E_T_ = '' "
cQry+=				 "AND D3_EMISSAO  >='"+DtoS(mv_par02)+"' "
cQry+=				 "AND D3_EMISSAO  <='"+DtoS(mv_par03)+"' " 
cQry+=				 "AND LEFT(D3_CF,1) = 'R'"
cQry+=				 "AND D3_OP  = ''"
cQry+=				 "AND D3_ESTORNO = '' "
//cQry+=				 --AND D3_CF <> 'RE3'
cQry+=			   "GROUP BY D3_FILIAL, D3_COD, D3_LOCAL ) SD33 ON SD33.D3_COD = B1_COD AND B2_LOCAL = SD33.D3_LOCAL "	
cQry+=  "LEFT JOIN ( SELECT D3_FILIAL , D3_COD, CASE WHEN D3_CF = 'RE3'THEN '99' ELSE D3_LOCAL END AS D3_LOCAL, SUM(D3_QUANT) AS QTD_OUTRAS_DEV, SUM(D3_CUSTO1) CUSTO_OUTRAS_DEV "
cQry+=			    "FROM SD3010 AS SD3 (NOLOCK) "
cQry+=			   "WHERE SD3.D_E_L_E_T_ = '' "
cQry+=				 "AND D3_EMISSAO  >='"+DtoS(mv_par02)+"' "
cQry+=				 "AND D3_EMISSAO  <='"+DtoS(mv_par03)+"' " 
cQry+=				 "AND (LEFT(D3_CF,1) = 'D' OR D3_CF = 'RE3') "
cQry+=				 "AND D3_OP  = '' "
cQry+=				 "AND D3_ESTORNO = '' "
cQry+=			   "GROUP BY D3_FILIAL, D3_COD, CASE WHEN D3_CF = 'RE3'THEN '99' ELSE D3_LOCAL END ) SD34 ON SD34.D3_COD = B1_COD AND B2_LOCAL = SD34.D3_LOCAL "
cQry+=  "LEFT JOIN ( SELECT D2_FILIAL SAI_FIL,  D2_COD,D2_LOCAL, SUM(D2_QUANT) AS QTD_CPV, SUM(D2_CUSTO1) AS CUSTO_CPV "
cQry+=                 "FROM SD2010 AS SD2 (NOLOCK) "    
cQry+=				 "INNER JOIN SF4010 SF4 (NOLOCK) ON SF4.D_E_L_E_T_ = ' ' AND F4_CODIGO  = D2_TES AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' "
cQry+=                "WHERE SD2.D_E_L_E_T_ = '' "  
cQry+=                  "AND D2_EMISSAO >='"+DtoS(mv_par02)+"' "
cQry+=                  "AND D2_EMISSAO <='"+DtoS(mv_par03)+"' " 
cQry+=				  "AND D2_TIPO IN ('N', 'C') "
cQry+=                "GROUP BY D2_FILIAL, D2_COD , D2_LOCAL "
cQry+=		    ") as SD2 ON SD2.D2_COD = B1_COD AND B2_LOCAL = SD2.D2_LOCAL AND SAI_FIL = B2_FILIAL "
cQry+=  "LEFT JOIN ( SELECT D2_FILIAL AS OUT_SAI_FIL, D2_COD, D2_LOCAL, SUM(D2_QUANT) AS QTD_OUTRAS_SAIDAS, SUM(D2_CUSTO1) AS CUSTO_OUTRAS_SAIDAS " 
cQry+=                 "FROM SD2010 AS SD2 (NOLOCK) "    
cQry+=				 "INNER JOIN SF4010 SF4 (NOLOCK) ON SF4.D_E_L_E_T_ = ' ' AND F4_CODIGO  = D2_TES AND F4_ESTOQUE = 'S' "
cQry+=                "WHERE SD2.D_E_L_E_T_ = '' "  
cQry+=                  "AND D2_EMISSAO >='"+DtoS(mv_par02)+"' "
cQry+=                  "AND D2_EMISSAO <='"+DtoS(mv_par03)+"' " 
cQry+=				  "AND ( D2_TIPO NOT IN ('N', 'C') OR F4_DUPLIC = 'N' ) " 
cQry+=                "GROUP BY D2_FILIAL, D2_COD, D2_LOCAL  "
cQry+=		    ") as SD21 ON SD21.D2_COD = B1_COD AND B2_LOCAL = SD21.D2_LOCAL AND OUT_SAI_FIL = B2_FILIAL "  
cQry+=  "LEFT JOIN ( SELECT B9_FILIAL AS FIL_FINAL, B9_COD, B9_LOCAL, SUM(B9_QINI) QTD_FINAL_2, SUM(B9_VINI1) CUSTO_FINAL_2 "
cQry+=                "FROM SB9010 AS SB9 (NOLOCK) " 
cQry+=			   "WHERE SB9.D_E_L_E_T_ = '' "   
cQry+=				 "AND B9_DATA ='"+DtoS(mv_par01)+"' " 
cQry+=			   "GROUP BY B9_FILIAL, B9_COD, B9_LOCAL " 
cQry+=			") SB9B ON B1_COD = SB9B.B9_COD AND B2_LOCAL = SB9B.B9_LOCAL AND FIL_FINAL = B2_FILIAL " 
cQry+=             "WHERE SB1.D_E_L_E_T_ = '' "


//Compute Sum(QtdHr), Sum(Saldo)
MemoWrit("AAESTR16.sql",cQry)
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), "TMP", .T., .F. )

TCSETFIELD("TMP","B1_COD","D",8,0)

dbSelectArea("TMP")
TMP->(dbGoTop())
TMP->(dbEval({|| nTotREG++}))
TMP->(dbGoTop())
	
oReport:SetMeter(nTotREG)
	
While !TMP->(Eof())
	If oReport:Cancel()
		Exit
	EndIf		
	oReport:IncMeter()              

	oSection2:Init()	
	oSection2:Cell("B1_COD"):SetValue(TMP->B1_COD)
	oSection2:Cell("B1_MSBLQL"):SetValue(TMP->B1_MSBLQL)
	oSection2:Cell("B1_DESC"):SetValue(TMP->B1_DESC)
	oSection2:Cell("B1_TIPO"):SetValue(TMP->B1_TIPO)
	oSection2:Cell("B1_UM"):SetValue(TMP->B1_UM)
	oSection2:Cell("B2_LOCAL"):SetValue(TMP->B2_LOCAL)
	oSection2:Cell("QTD_INI"):SetValue(TMP->QTD_INI)
	oSection2:Cell("CUSTO_INI"):SetValue(TMP->CUSTO_INI)
	oSection2:Cell("QTD_COMPRAS"):SetValue(TMP->QTD_COMPRAS)
	oSection2:Cell("CUSTO_COMPRAS"):SetValue(TMP->CUSTO_COMPRAS)
	oSection2:Cell("QTD_OUTRAS_ENT"):SetValue(TMP->QTD_OUTRAS_ENT)
	oSection2:Cell("CUSTO_OUTRAS_ENT"):SetValue(TMP->CUSTO_OUTRAS_ENT)
	oSection2:Cell("QTD_CONSUMO"):SetValue(TMP->QTD_CONSUMO)
	oSection2:Cell("CUSTO_CONSUMO"):SetValue(TMP->CUSTO_CONSUMO)
	oSection2:Cell("QTD_PRODUCAO"):SetValue(TMP->QTD_PRODUCAO)
	oSection2:Cell("CUSTO_PRODUCAO"):SetValue(TMP->CUSTO_PRODUCAO)
	oSection2:Cell("QTD_OUTRAS_REQ"):SetValue(TMP->QTD_OUTRAS_REQ)
	oSection2:Cell("CUSTO_OUTRAS_REQ"):SetValue(TMP->CUSTO_OUTRAS_REQ)
	oSection2:Cell("QTD_OUTRAS_DEV"):SetValue(TMP->QTD_OUTRAS_DEV)
	oSection2:Cell("CUSTO_OUTRAS_DEV"):SetValue(TMP->CUSTO_OUTRAS_DEV)                                      
	oSection2:Cell("QTD_CPV"):SetValue(TMP->QTD_CPV)
	oSection2:Cell("CUSTO_CPV"):SetValue(TMP->CUSTO_CPV)
	oSection2:Cell("QTD_OUTRAS_SAIDAS"):SetValue(TMP->QTD_OUTRAS_SAIDAS)
	oSection2:Cell("CUSTO_OUTRAS_SAIDAS"):SetValue(TMP->CUSTO_OUTRAS_SAIDAS)
	oSection2:Cell("QTD_MODELO7"):SetValue(TMP->QTD_MODELO7)
	oSection2:Cell("CUSTO_MODELO7"):SetValue(TMP->CUSTO_MODELO7)
	oSection2:Cell("QTD_MOEDLO3"):SetValue(TMP->QTD_MOEDLO3)
	oSection2:Cell("CUSTO_MODELO3"):SetValue(TMP->CUSTO_MODELO3)
	oSection2:Cell("DIF_QTD"):SetValue(TMP->DIF_QTD)
	oSection2:Cell("DIF_CUSTO"):SetValue(TMP->DIF_CUSTO)


	oSection2:Printline()   
	TMP->(DbSkip())  	                   
EndDo    
oSection2:Finish()
TMP->(dbCloseArea())

Return            

//Funcão Valida SX1
//*************************
Static Function fValidSX1()

	aPergs := {}

	Aadd(aPergs,{ "Fechamento            ?", "", "","mv_ch1", "D", 8, 0, 0, "G", "naovazio","mv_par01", ""			,"", "", "","" ,"", "","","","", "", "","","", "", "","","", "", "","",""})
	Aadd(aPergs,{ "Data De               ?", "", "","mv_ch1", "D", 8, 0, 0, "G", "naovazio","mv_par02", ""			,"", "", "","" ,"", "","","","", "", "","","", "", "","","", "", "","",""})
	Aadd(aPergs,{ "Data Ate              ?", "", "","mv_ch2", "D", 8, 0, 0, "G", "naovazio","mv_par03", ""			,"", "", "","" ,"", "","","","", "", "","","", "", "","","", "", "","",""})
    
	AjustaSx1("AAESTR16",aPergs)
Return

Static Function AjustaSX1(cPerg, aPergs)
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local cKey		:= ""
Local nj		:= 1
Local aArea		:= GetArea()
Local lUpdHlp	:= .T.

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
			"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
			"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
			"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
			"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
			"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
			"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP", "X1_PICTURE"}

dbSelectArea( "SX1" )
dbSetOrder(1)

cPerg := PadR( cPerg , Len(X1_GRUPO) , " " )

For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek( cPerg + Right( Alltrim( aPergs[nX][11] ) , 2) )

		If ( ValType( aPergs[nX][Len( aPergs[nx] )]) = "B" .And. Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif

	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]		
 		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
 	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(ALLTRIM( aPergs[nX][11] ), 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0 .And. ValType(aPergs[nX][nJ]) != "A"
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
	Endif
	cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

	If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
		aHelpSpa := aPergs[nx][Len(aPergs[nx])]
	Else
		aHelpSpa := {}
	Endif
	
	If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
		aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
	Else
		aHelpEng := {}
	Endif

	If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
		aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
	Else
		aHelpPor := {}
	Endif

	// Caso exista um help com o mesmo nome, atualiza o registro.
	lUpdHlp := ( !Empty(aHelpSpa) .and. !Empty(aHelpEng) .and. !Empty(aHelpPor) )
	//PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa,lUpdHlp)
	
Next
RestArea(aArea)

Return()
