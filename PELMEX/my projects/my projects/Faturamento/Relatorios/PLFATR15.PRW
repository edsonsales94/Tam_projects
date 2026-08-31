#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  PLFATR15    ∫Autor  ≥Stan Lee Lopes     				∫ Data ≥  27/12/18 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  RelatÛrio de Notas Fiscais             								 ±
±±∫          ≥                                                            			   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        			   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/


User Function PLFATR15()
Local oReport
Local cQuery
Local cAlias      := getNextAlias()
Private cPerg     := "PLFATR15"

AjustaSX1(cPerg)
Pergunte(cPerg,.F.)

oReport := ReportDef(cAlias,cPerg)
oReport:PrintDialog()
Return
                                                        

Static Function ReportDef(cAlias,cPerg)
Local oReport
Local oSection
Local oBreak
Local aOrdem      := {"FILIAL"}

oReport := TReport():New(cPerg,"RELAT”RIO DE NOTAS FISCAIS DETALHADO",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
oReport:SetPortrait()      
oReport:SetEnvironment(2)      

//Primeira seÁ„o
oSection := TRSection():New(oReport,"FISCAL",{"SFT"},aOrdem) 

TRCell():New(oSection,"FT_FILIAL"	    ,"SFT","Filial",/*Mascara*/)   
TRCell():New(oSection,"D2_XFILRES"	    ,"SD2","Filial Venda",/*Mascara*/)   
TRCell():New(oSection,"M0_FILIAL"		,"SM0","Empresa Venda",/*Mascara*/,40)
TRCell():New(oSection,"FT_ENTRADA"		,"SFT","Dt.Entrada",/*Mascara*/,) 
TRCell():New(oSection,"FT_EMISSAO"   	,"SFT","Dt.Emiss„o",/*Mascara*/,) 
TRCell():New(oSection,"FT_NFISCAL"		,"SFT","Nota",/*Mascara*/,)
TRCell():New(oSection,"FT_SERIE"		,"SFT","Serie",/*Mascara*/,/*Tamanho*/)
TRCell():New(oSection,"D2_PEDIDO"		,"SD2","Pedido",/*Mascara*/,12)
TRCell():New(oSection,"A1_CGC"    	    ,"SA1","CPF/CNPJ",/*Mascara*/,)
TRCell():New(oSection,"FT_CLIEFOR"      ,"SFT","Cod.Cli",/*Mascara*/,)
TRCell():New(oSection,"A1_NOME"		    ,"SA1","Nome",/*Mascara*/,/*Tamanho*/)  
TRCell():New(oSection,"A1_PESSOA"	    ,"SA1","Pessoa",,/*Tamanho*/) 
TRCell():New(oSection,"A1_TIPO"	        ,"SA1","Tipo",,/*Tamanho*/) 
TRCell():New(oSection,"A1_TPTRIBU"	    ,"SA1","Tp.Trib",,/*Tamanho*/)
TRCell():New(oSection,"A1_GRPTRIB"		,"SA1","GRP.Trib",/*Mascara*/,/*Tamanho*/)
TRCell():New(oSection,"A1_CNAE"			,"SA1","CNAE",/*Mascara*/,/*Tamanho*/)
TRCell():New(oSection,"CC3_DESC"		,"CC3","DESC.CNAE",/*Mascara*/,/*Tamanho*/)
TRCell():New(oSection,"A1_MUN"	        ,"SA1","Munic",,/*Tamanho*/)
TRCell():New(oSection,"FT_ESTADO"	    ,"SFT","Estado",,) 
TRCell():New(oSection,"A1_INSCR"		,"SA1","I.E",,/*Tamanho*/)
TRCell():New(oSection,"FT_CFOP"	        ,"SFT","CFOP",/*Mascara*/,/*Tamanho*/) 
TRCell():New(oSection,"B1_COD"		    ,"SB1","Codigo",/*Mascara*/,/*Tamanho*/)   
TRCell():New(oSection,"B1_DESC"			,"SB1","DescriÁ„o",/*Mascara*/,/*Tamanho*/)
TRCell():New(oSection,"FT_QUANT"	    ,"SFT","Quant","@E 999,999.99",/*Tamanho*/)
TRCell():New(oSection,"FT_PRCUNIT"		,"SFT","Vlr.Unit","@E 999,999.99",/*Tamanho*/)
TRCell():New(oSection,"B9_CM1"		    ,"SB9","Prc.Custo","@E 999,999.99",/*Tamanho*/)
TRCell():New(oSection,"FT_DESCONT"		,"SFT","Desconto","@E 999,999.99",/*Tamanho*/)
TRCell():New(oSection,"FT_TOTAL"		,"SFT","Total","@E 999,999.99",/*Tamanho*/)
TRCell():New(oSection,"FT_VALCONT"		,"SFT","Vlr.Cont","@E 999,999.99",/*Tamanho*/)
TRCell():New(oSection,"FT_BASEICM"		,"SFT","Base ICM","@E 999,999.99",/*Tamanho*/)
TRCell():New(oSection,"FT_ALIQICM"		,"SFT","Alq.ICM","@E 999,999.99",/*Tamanho*/)
TRCell():New(oSection,"FT_VALICM"		,"SFT","Vlr.ICM","@E 999,999.99",/*Tamanho*/)
TRCell():New(oSection,"FT_BSICMOR"		,"SFT","Base.ICMS.origem",/*Mascara*/,/*Tamanho*/)
TRCell():New(oSection,"FT_DESCZFR"		,"SFT","Desc.ZFR",/*Mascara*/,/*Tamanho*/)
TRCell():New(oSection,"FT_OBSERV"		,"SFT","ObservaÁ„o",/*Mascara*/,/*Tamanho*/)
TRCell():New(oSection,"FT_DTCANC"		,"SFT","Dt.Cancel",/*Mascara*/,/*Tamanho*/) 
TRCell():New(oSection,"FT_NRLIVRO"		,"SFT","Livro",/*Mascara*/,/*Tamanho*/)
TRCell():New(oSection,"FT_TIPOMOV"		,"SFT","Tp.Mov",/*Mascara*/,/*Tamanho*/)
TRCell():New(oSection,"FT_CLASFIS"		,"SFT","Sit.Trib",/*Mascara*/,/*Tamanho*/)
TRCell():New(oSection,"FT_NFORI"		,"SFT","NF.Orig",/*Mascara*/,/*Tamanho*/)
TRCell():New(oSection,"FT_BASEPIS"		,"SFT","Base Pis","@E 999,999.99",/*Tamanho*/)
TRCell():New(oSection,"FT_ALIQPIS"		,"SFT","Alq.Pis","@E 999,999.99",/*Tamanho*/)
TRCell():New(oSection,"FT_VALPIS"		,"SFT","Vlr.Pis","@E 999,999.99",/*Tamanho*/)
TRCell():New(oSection,"FT_BASECOF"		,"SFT","Base Cofi","@E 999,999.99",/*Tamanho*/)
TRCell():New(oSection,"FT_CSTCOF"		,"SFT","CST COFIN",,/*Tamanho*/)
TRCell():New(oSection,"FT_ALIQCOF"		,"SFT","Alq.Cofi","@E 999,999.99",/*Tamanho*/)
TRCell():New(oSection,"FT_VALCOF"		,"SFT","Vlr.Cofi","@E 999,999.99",/*Tamanho*/) 
TRCell():New(oSection,"FT_CSTPIS"		,"SFT","CST PIS",,/*Tamanho*/)
TRCell():New(oSection,"FT_TES"		    ,"SFT","Tes",/*Mascara*/,/*Tamanho*/)   
TRCell():New(oSection,"D2_LOCAL"		,"SD2","Armazem",/*Mascara*/,/*Tamanho*/)
TRCell():New(oSection,"B1_GRUPO"		,"SB1","Grupo",/*Mascara*/,/*Tamanho*/)
TRCell():New(oSection,"BM_DESC"		,"SB1","Descricao Grupo",/*Mascara*/,/*Tamanho*/)



//Totalizador                                                                                  
//TRFunction():New(oSection:Cell("L2_VLRITEM"),"TOTAL BASE","SUM",,,"@E 999,999,999.99",,.F.,.T.)
//TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)


Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
Local oSection  := oReport:Section(1)

//if oReport:Section(1):GetOrder() == 1
//	cOrdem := "A1_COD"
//endif      


oSection:BeginQuery()
BeginSQL Alias cAlias
 	%noparser%

SELECT FT_FILIAL, ISNULL(D2_XFILRES,'')D2_XFILRES,FT_ENTRADA, FT_EMISSAO, FT_NFISCAL,FT_SERIE,
       ISNULL(D2_PEDIDO,'')D2_PEDIDO,
	   CASE WHEN SM.M0_FILIAL IS NULL THEN SM0.M0_FILIAL
	   ELSE SM.M0_FILIAL END M0_FILIAL,
	   A1_CGC,FT_CLIEFOR,
       A1_NOME,
	   A1_PESSOA,
	   A1_TIPO,
	   A1_TPTRIBU,
	   A1_MUN,A1_INSCR,
	   FT_ESTADO,FT_CFOP,FT_ITEM,B1_COD,B1_DESC,FT_QUANT,FT_PRCUNIT,ISNULL(B9_CM1,0)B9_CM1,FT_DESCONT,FT_TOTAL,FT_VALCONT,
	   FT_BASEICM,FT_ALIQICM,FT_VALICM,FT_BSICMOR,FT_DESCZFR,FT_OBSERV,FT_DTCANC,FT_NRLIVRO,FT_TIPOMOV,
	   FT_CLASFIS,FT_NFORI,FT_BASEPIS,FT_ALIQPIS,FT_VALPIS,FT_BASECOF,FT_ALIQCOF,
	   FT_VALCOF,FT_TES,D2_LOCAL,FT_CSTPIS,FT_CSTCOF,A1_GRPTRIB,A1_CNAE,CC3_DESC,B1_GRUPO,BM_DESC
FROM %Table:SFT% SFT (NOLOCK)
LEFT JOIN %Table:SA1% SA1 (NOLOCK)ON SFT.FT_CLIEFOR = SA1.A1_COD AND SFT.FT_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
LEFT JOIN %Table:SD2% SD2 (NOLOCK) ON SFT.FT_FILIAL = SD2.D2_FILIAL AND SFT.FT_NFISCAL = SD2.D2_DOC AND SFT.FT_SERIE = SD2.D2_SERIE  AND SFT.FT_ITEM = SD2.D2_ITEM AND SFT.FT_PRODUTO = SD2.D2_COD AND SFT.FT_QUANT = SD2.D2_QUANT AND SD2.D_E_L_E_T_ = ''
LEFT JOIN (SELECT B9_FILIAL,B9_LOCAL,B9_COD,MAX(B9_CM1)B9_CM1,MAX(B9_DATA)B9_DATA
			FROM %Table:SB9% SB9 (NOLOCK)
			WHERE SB9.D_E_L_E_T_ = ''
			AND B9_LOCAL = '01'
			GROUP BY B9_FILIAL,B9_LOCAL,B9_COD)SB9 ON SD2.D2_FILIAL = SB9.B9_FILIAL AND SD2.D2_COD = SB9.B9_COD AND SD2.D2_LOCAL = SB9.B9_LOCAL
LEFT JOIN SIGAMAT SM0 (NOLOCK) ON CASE WHEN SD2.D2_XFILRES = '' THEN SD2.D2_FILIAL ELSE SD2.D2_XFILRES END = SM0.M0_CODFIL AND SM0.M0_CODIGO = %Exp:MV_PAR07% AND SM0.D_E_L_E_T_ = ''
FULL JOIN SIGAMAT SM (NOLOCK) ON SD2.D2_XFILRES = SM.M0_CODFIL AND SM.M0_CODIGO = %Exp:MV_PAR07% AND SM.D_E_L_E_T_ = ''
INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SB1.B1_COD = SFT.FT_PRODUTO AND  SB1.D_E_L_E_T_ = ''
INNER JOIN %Table:SBM% SBM (NOLOCK) ON B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = ''
LEFT JOIN CC3200 ON CC3_COD = A1_CNAE
WHERE SFT.D_E_L_E_T_ = ''
AND FT_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND FT_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND FT_TES BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
AND FT_CLIEFOR BETWEEN %Exp:MV_PAR08% AND %Exp:MV_PAR09%
AND FT_LOJA BETWEEN %Exp:MV_PAR10% AND %Exp:MV_PAR11%
AND FT_TIPOMOV = 'S'
                        
UNION

SELECT FT_FILIAL, ISNULL(D2_XFILRES,'')D2_XFILRES,FT_ENTRADA, FT_EMISSAO, FT_NFISCAL,FT_SERIE,
       ISNULL(D2_PEDIDO,'')D2_PEDIDO,
	   M0_FILIAL,
	   A1_CGC,FT_CLIEFOR,
       A1_NOME,
	   A1_PESSOA,
	   A1_TIPO,
	   A1_TPTRIBU,
	   A1_MUN,A1_INSCR,
	   FT_ESTADO,FT_CFOP,FT_ITEM,B1_COD,B1_DESC,FT_QUANT,FT_PRCUNIT,ISNULL(B9_CM1,0)B9_CM1,FT_DESCONT,FT_TOTAL,FT_VALCONT,
	   FT_BASEICM,FT_ALIQICM,FT_VALICM,FT_BSICMOR,FT_DESCZFR,FT_OBSERV,FT_DTCANC,FT_NRLIVRO,FT_TIPOMOV,
	   FT_CLASFIS,FT_NFORI,FT_BASEPIS,FT_ALIQPIS,FT_VALPIS,FT_BASECOF,FT_ALIQCOF,
	   FT_VALCOF,FT_TES,D2_LOCAL,FT_CSTPIS,FT_CSTCOF,A1_GRPTRIB,A1_CNAE,CC3_DESC,B1_GRUPO,BM_DESC
FROM %Table:SFT% SFT (NOLOCK)
INNER JOIN %Table:SA1% SA1 (NOLOCK)ON SFT.FT_CLIEFOR = SA1.A1_COD AND SFT.FT_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
LEFT JOIN %Table:SD2% SD2 (NOLOCK) ON SFT.FT_FILIAL = SD2.D2_FILIAL AND SFT.FT_NFISCAL = SD2.D2_DOC AND SFT.FT_SERIE = SD2.D2_SERIE AND SFT.FT_ITEM = SD2.D2_ITEM AND SFT.FT_PRODUTO = SD2.D2_COD AND SFT.FT_QUANT = SD2.D2_QUANT AND SD2.D_E_L_E_T_ = ''
INNER JOIN %Table:SC5% SC5 (NOLOCK) ON SD2.D2_FILIAL = SC5.C5_FILIAL AND SD2.D2_PEDIDO = SC5.C5_NUM AND SC5.D_E_L_E_T_ = ''
//INNER JOIN %Table:SB2% SB2 (NOLOCK) ON SD2.D2_FILIAL = SB2.B2_FILIAL AND SD2.D2_COD = SB2.B2_COD AND SB2.D_E_L_E_T_ = '' AND SD2.D2_LOCAL = SB2.B2_LOCAL
LEFT JOIN (SELECT B9_FILIAL,B9_LOCAL,B9_COD,MAX(B9_CM1)B9_CM1,MAX(B9_DATA)B9_DATA
			FROM %Table:SB9% SB9 (NOLOCK)
			WHERE SB9.D_E_L_E_T_ = ''
			AND B9_LOCAL = '01'
			GROUP BY B9_FILIAL,B9_LOCAL,B9_COD)SB9 ON SD2.D2_FILIAL = SB9.B9_FILIAL AND SD2.D2_COD = SB9.B9_COD AND SD2.D2_LOCAL = SB9.B9_LOCAL
LEFT JOIN SIGAMAT SM0 (NOLOCK) ON SD2.D2_FILIAL = SM0.M0_CODFIL AND SM0.M0_CODIGO = %Exp:MV_PAR07% AND SM0.D_E_L_E_T_ = ''
INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SB1.B1_COD = SFT.FT_PRODUTO AND  SB1.D_E_L_E_T_ = ''
INNER JOIN %Table:SBM% SBM (NOLOCK) ON B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = ''
LEFT JOIN CC3200 ON CC3_COD = A1_CNAE
WHERE SFT.D_E_L_E_T_ = ''
AND FT_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND FT_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND FT_TES BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
AND FT_CLIEFOR BETWEEN %Exp:MV_PAR08% AND %Exp:MV_PAR09%
AND FT_LOJA BETWEEN %Exp:MV_PAR10% AND %Exp:MV_PAR11%
AND FT_TIPOMOV = 'S'
AND ISNULL(C5_XORCRES,'') = ''   

UNION

SELECT FT_FILIAL, ISNULL(D2_XFILRES,'')D2_XFILRES,FT_ENTRADA, FT_EMISSAO, FT_NFISCAL,FT_SERIE,
       ISNULL(D2_PEDIDO,'')D2_PEDIDO,
	   M0_FILIAL,
	   A1_CGC,FT_CLIEFOR,
       A1_NOME,
	   A1_PESSOA,
	   A1_TIPO,
	   A1_TPTRIBU,
	   A1_MUN,A1_INSCR,
	   FT_ESTADO,FT_CFOP,FT_ITEM,B1_COD,B1_DESC,FT_QUANT,FT_PRCUNIT,ISNULL(B9_CM1,0)B9_CM1,FT_DESCONT,FT_TOTAL,FT_VALCONT,
	   FT_BASEICM,FT_ALIQICM,FT_VALICM,FT_BSICMOR,FT_DESCZFR,FT_OBSERV,FT_DTCANC,FT_NRLIVRO,FT_TIPOMOV,
	   FT_CLASFIS,FT_NFORI,FT_BASEPIS,FT_ALIQPIS,FT_VALPIS,FT_BASECOF,FT_ALIQCOF,
	   FT_VALCOF,FT_TES,D2_LOCAL,FT_CSTPIS,FT_CSTCOF,A1_GRPTRIB,A1_CNAE,CC3_DESC,B1_GRUPO,BM_DESC
FROM %Table:SFT% SFT (NOLOCK)
LEFT JOIN %Table:SA1% SA1 (NOLOCK)ON SFT.FT_CLIEFOR = SA1.A1_COD AND SFT.FT_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
LEFT JOIN %Table:SD2% SD2 (NOLOCK) ON SFT.FT_FILIAL = SD2.D2_FILIAL AND SFT.FT_NFISCAL = SD2.D2_DOC AND SFT.FT_SERIE = SD2.D2_SERIE AND SFT.FT_ITEM = SD2.D2_ITEM AND SFT.FT_PRODUTO = SD2.D2_COD AND SFT.FT_QUANT = SD2.D2_QUANT AND SD2.D_E_L_E_T_ = ''
//INNER JOIN %Table:SB2% SB2 (NOLOCK) ON SD2.D2_FILIAL = SB2.B2_FILIAL AND SD2.D2_COD = SB2.B2_COD AND SB2.D_E_L_E_T_ = '' AND SD2.D2_LOCAL = SB2.B2_LOCAL
LEFT JOIN (SELECT B9_FILIAL,B9_LOCAL,B9_COD,MAX(B9_CM1)B9_CM1,MAX(B9_DATA)B9_DATA
			FROM %Table:SB9% SB9 (NOLOCK)
			WHERE SB9.D_E_L_E_T_ = ''
			AND B9_LOCAL = '01'
			GROUP BY B9_FILIAL,B9_LOCAL,B9_COD)SB9 ON SD2.D2_FILIAL = SB9.B9_FILIAL AND SD2.D2_COD = SB9.B9_COD AND SD2.D2_LOCAL = SB9.B9_LOCAL
LEFT JOIN SIGAMAT SM0 (NOLOCK) ON SD2.D2_FILIAL = SM0.M0_CODFIL AND SM0.M0_CODIGO = %Exp:MV_PAR07% AND SM0.D_E_L_E_T_ = ''
INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SB1.B1_COD = SFT.FT_PRODUTO AND  SB1.D_E_L_E_T_ = ''
INNER JOIN %Table:SBM% SBM (NOLOCK) ON B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = ''
LEFT JOIN CC3200 ON CC3_COD = A1_CNAE
WHERE SFT.D_E_L_E_T_ = ''
AND FT_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND FT_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND FT_TES BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
AND FT_CLIEFOR BETWEEN %Exp:MV_PAR08% AND %Exp:MV_PAR09%
AND FT_LOJA BETWEEN %Exp:MV_PAR10% AND %Exp:MV_PAR11%
AND FT_TIPOMOV = 'S'
AND FT_FILIAL != '01'

UNION ALL        

SELECT FT_FILIAL,'' D2_XFILRES,FT_ENTRADA, FT_EMISSAO, FT_NFISCAL,FT_SERIE,
       ISNULL(D1_PEDIDO,'')D2_PEDIDO,
	   M0_FILIAL,
	   A1_CGC,FT_CLIEFOR,
       A1_NOME,
	   A1_PESSOA,
	   A1_TIPO,
	   A1_TPTRIBU,
	   A1_MUN,A1_INSCR,
	   FT_ESTADO,FT_CFOP,FT_ITEM,B1_COD,B1_DESC,FT_QUANT,FT_PRCUNIT,ISNULL(B9_CM1,0)B9_CM1,FT_DESCONT,FT_TOTAL,FT_VALCONT,
	   FT_BASEICM,FT_ALIQICM,FT_VALICM,FT_BSICMOR,FT_DESCZFR,FT_OBSERV,FT_DTCANC,FT_NRLIVRO,FT_TIPOMOV,
	   FT_CLASFIS,FT_NFORI,FT_BASEPIS,FT_ALIQPIS,FT_VALPIS,FT_BASECOF,FT_ALIQCOF,
	   FT_VALCOF,FT_TES,D1_LOCAL D2_LOCAL,FT_CSTPIS,FT_CSTCOF,A1_GRPTRIB,A1_CNAE,CC3_DESC,B1_GRUPO,BM_DESC
FROM %Table:SFT% SFT (NOLOCK)
INNER JOIN %Table:SA1% SA1 (NOLOCK)ON SFT.FT_CLIEFOR = SA1.A1_COD AND SFT.FT_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = '' AND SA1.A1_MSBLQL !='1'
LEFT JOIN %Table:SD1% SD1 (NOLOCK) ON SFT.FT_FILIAL = SD1.D1_FILIAL AND SFT.FT_CLIEFOR = SD1.D1_FORNECE AND SFT.FT_LOJA = SD1.D1_LOJA AND SFT.FT_NFISCAL = SD1.D1_DOC AND SFT.FT_SERIE = SD1.D1_SERIE AND SFT.FT_ITEM = SD1.D1_ITEM AND SFT.FT_PRODUTO = SD1.D1_COD AND SFT.FT_QUANT = SD1.D1_QUANT AND SD1.D_E_L_E_T_ = ''
//INNER JOIN %Table:SB2% SB2 (NOLOCK) ON SD1.D1_FILIAL = SB2.B2_FILIAL AND SD1.D1_COD = SB2.B2_COD AND SB2.D_E_L_E_T_ = '' AND SD1.D1_LOCAL = SB2.B2_LOCAL
LEFT JOIN (SELECT B9_FILIAL,B9_LOCAL,B9_COD,MAX(B9_CM1)B9_CM1,MAX(B9_DATA)B9_DATA
			FROM %Table:SB9% SB9 (NOLOCK)
			WHERE SB9.D_E_L_E_T_ = ''
			AND B9_LOCAL = '01'
			GROUP BY B9_FILIAL,B9_LOCAL,B9_COD)SB9 ON SFT.FT_FILIAL = SB9.B9_FILIAL AND SFT.FT_PRODUTO = SB9.B9_COD 
LEFT JOIN SIGAMAT SM0 (NOLOCK) ON SD1.D1_FILIAL = SM0.M0_CODFIL AND SM0.M0_CODIGO = %Exp:MV_PAR07% AND SM0.D_E_L_E_T_ = ''
INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SB1.B1_COD = SFT.FT_PRODUTO AND  SB1.D_E_L_E_T_ = ''
INNER JOIN %Table:SBM% SBM (NOLOCK) ON B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = ''
LEFT JOIN CC3200 ON CC3_COD = A1_CNAE
WHERE SFT.D_E_L_E_T_ = ''
AND D1_TIPO IN ('D','B')
AND FT_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND FT_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND FT_TES BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
AND FT_CLIEFOR BETWEEN %Exp:MV_PAR08% AND %Exp:MV_PAR09%
AND FT_LOJA BETWEEN %Exp:MV_PAR10% AND %Exp:MV_PAR11%
AND FT_TIPOMOV = 'E'

UNION ALL
SELECT FT_FILIAL,'' D2_XFILRES,FT_ENTRADA, FT_EMISSAO, FT_NFISCAL,FT_SERIE,
       ISNULL(D1_PEDIDO,'')D2_PEDIDO,
	   M0_FILIAL,
	   A2_CGC A1_CGC,
	   FT_CLIEFOR,
       A2_NOME A1_NOME,
	   '' A1_PESSOA ,
	   A2_TIPO A1_TIPO,
	   '' A1_TPTRIBU,
	   A2_MUN A1_MUN,A2_INSCR,
	   FT_ESTADO,FT_CFOP,FT_ITEM,B1_COD,B1_DESC,FT_QUANT,FT_PRCUNIT,ISNULL(B9_CM1,0)B9_CM1,FT_DESCONT,FT_TOTAL,FT_VALCONT,
	   FT_BASEICM,FT_ALIQICM,FT_VALICM,FT_BSICMOR,FT_DESCZFR,FT_OBSERV,FT_DTCANC,FT_NRLIVRO,FT_TIPOMOV,
	   FT_CLASFIS,FT_NFORI,FT_BASEPIS,FT_ALIQPIS,FT_VALPIS,FT_BASECOF,FT_ALIQCOF,
	   FT_VALCOF,FT_TES,D1_LOCAL D2_LOCAL,FT_CSTPIS,FT_CSTCOF,'' A1_GRPTRIB,''A1_CNAE , ''CC3_DESC,B1_GRUPO,BM_DESC
FROM %Table:SFT% SFT (NOLOCK)
INNER JOIN %Table:SA2% SA2 (NOLOCK)ON SFT.FT_CLIEFOR = SA2.A2_COD AND SFT.FT_LOJA = SA2.A2_LOJA AND SA2.D_E_L_E_T_ = '' AND SA2.A2_MSBLQL !='1'
LEFT JOIN %Table:SD1% SD1 (NOLOCK) ON SFT.FT_FILIAL = SD1.D1_FILIAL AND SFT.FT_CLIEFOR = SD1.D1_FORNECE AND SFT.FT_LOJA = SD1.D1_LOJA AND SFT.FT_NFISCAL = SD1.D1_DOC AND SFT.FT_SERIE = SD1.D1_SERIE AND SFT.FT_ITEM = SD1.D1_ITEM AND SFT.FT_PRODUTO = SD1.D1_COD AND SFT.FT_QUANT = SD1.D1_QUANT AND SD1.D_E_L_E_T_ = ''
//INNER JOIN %Table:SB2% SB2 (NOLOCK) ON SD1.D1_FILIAL = SB2.B2_FILIAL AND SD1.D1_COD = SB2.B2_COD AND SB2.D_E_L_E_T_ = '' AND SD1.D1_LOCAL = SB2.B2_LOCAL
LEFT JOIN (SELECT B9_FILIAL,B9_LOCAL,B9_COD,MAX(B9_CM1)B9_CM1,MAX(B9_DATA)B9_DATA
			FROM %Table:SB9% SB9 (NOLOCK)
			WHERE SB9.D_E_L_E_T_ = ''
			AND B9_LOCAL = '01'
			GROUP BY B9_FILIAL,B9_LOCAL,B9_COD)SB9 ON SFT.FT_FILIAL = SB9.B9_FILIAL AND SFT.FT_PRODUTO = SB9.B9_COD
LEFT JOIN SIGAMAT SM0 (NOLOCK) ON SD1.D1_FILIAL = SM0.M0_CODFIL AND SM0.M0_CODIGO = %Exp:MV_PAR07% AND SM0.D_E_L_E_T_ = ''
INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SB1.B1_COD = SFT.FT_PRODUTO AND  SB1.D_E_L_E_T_ = ''
INNER JOIN %Table:SBM% SBM (NOLOCK) ON B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = ''
WHERE SFT.D_E_L_E_T_ = ''
AND FT_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND FT_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND FT_TES BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
AND FT_CLIEFOR BETWEEN %Exp:MV_PAR08% AND %Exp:MV_PAR09%
AND FT_LOJA BETWEEN %Exp:MV_PAR10% AND %Exp:MV_PAR11%
AND FT_TIPOMOV = 'E'
AND D1_TIPO NOT IN ('D','B')

ORDER BY FT_FILIAL,FT_TIPOMOV,5,6


EndSQL 

oSection:EndQuery() 
oSection:SetParentQuery()
oSection:Print()	 
Return                                                                                              


Static Function AjustaSX1(cPerg)
u_InPutSX1(cPerg,"01",PADR("Filial De  	 ",20)+"?","","","mv_ch1","C",2,0,0,"G","","SA3","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Filial AtÈ 	 ",20)+"?","","","mv_ch2","C",2,0,0,"G","","SA3","","","mv_par02")
u_InPutSX1(cPerg,"03",PADR("Emiss„o De   ",20)+"?","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03") 
u_InPutSX1(cPerg,"04",PADR("Emiss„o AtÈ  ",20)+"?","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04") 
u_InPutSX1(cPerg,"05",PADR("TES De   	 ",20)+"?","","","mv_ch5","C",3,0,0,"G","","","","","mv_par05") 
u_InPutSX1(cPerg,"06",PADR("TES AtÈ  	 ",20)+"?","","","mv_ch6","C",3,0,0,"G","","","","","mv_par06") 
u_InPutSX1(cPerg,"07",PADR("Empresa? 	 ",20)+"?","","","mv_ch7","C",2,0,0,"G","","","","","mv_par07")
u_InPutSX1(cPerg,"08",PADR("Cliente De?	 ",20)+"?","","","mv_ch8","C",6,0,0,"G","","SA1","","","mv_par08")
u_InPutSX1(cPerg,"09",PADR("Cliente Ate? ",20)+"?","","","mv_ch9","C",6,0,0,"G","","SA1","","","mv_par09")
u_InPutSX1(cPerg,"10",PADR("Loja De? 	 ",20)+"?","","","mv_cha","C",2,0,0,"G","","","","","mv_par10")
u_InPutSX1(cPerg,"11",PADR("Loja Ate? 	 ",20)+"?","","","mv_chb","C",2,0,0,"G","","","","","mv_par11")
Return
