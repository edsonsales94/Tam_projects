#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWCOMMAND.CH"
/*_______________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ FunÁ?o    ¶ AACOMR05   ¶ Autor ¶ WILLIAMS MESSA       ¶ Data ¶ 11/11/2020 ¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ DescriÁ?o ¶ Relatório Análise de Compras - Auditoria.                     ¶¶¶
¶¶+-----------+---------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ*/ 

User Function AACOMR05()

Local oReport   
Local cPerg   := 'AACOMR05'
Local cAlias  := getNextAlias()


criaSx1(cPerg)
Pergunte(cPerg, .T.)

oReport := reportDef(cAlias, cPerg)
oReport:printDialog()

return     
//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relatório.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport,cAlias) 

Local oSecao1   := oReport:Section(1)
Local cCondicao := ""
Local cJoin     := ""

oSecao1:BeginQuery()

		BeginSql alias "AACOMR05"
		
					SELECT  C7_FILIAL,
                            C7_NUMSC,
                            SC7.C7_ITEMSC,
                            ISNULL(SC1.C1_EMISSAO,'') AS C1_EMISSAO,
                            ISNULL(C1_SOLICIT,'') AS C1_SOLICIT, 
                            ISNULL(SC1.C1_CC,'')  AS C1_CC,
                            ISNULL(CTT.CTT_DESC01,'') AS CTT_DESC01,
                            ISNULL(C7_EMISSAO,'') AS C7_EMISSAO, 
                            C7_NUM AS C7_NUM,
                            C7_FORNECE AS C7_FORNECE,
                            A2_NOME AS A2_NOME,
                            C7_ITEM AS C7_ITEM,
                            C7_PRODUTO AS C7_PRODUTO,
                            B1_DESC AS B1_DESC,
                            SB1.B1_UM AS B1_UM,
                            C7_QUANT AS C7_QUANT,	
                            C7_PRECO AS C7_PRECO,
                            C7_TOTAL AS C7_TOTAL,
                            C7_NUMCOT AS C7_NUMCOT,
                            ISNULL(C8_EMISSAO,'') AS C8_EMISSAO,
                            D1_DOC AS D1_DOC,
                            ISNULL(D1_EMISSAO,'') AS D1_EMISSAO,
                            ISNULL(D1_DTDIGIT,'') AS D1_DTDIGIT,
                            ISNULL(SD1.D1_QUANT,0) AS D1_QUANT ,
							ISNULL(SD1.D1_VUNIT,0) AS D1_VUNIT ,
							ISNULL(SD1.D1_TOTAL,0) AS D1_TOTAL ,
                            C7_CONTRA AS C7_CONTRA,
                            C7_CONTREV AS C7_CONTREV,
                            ISNULL(D1_CC ,'') AS D1_CC,
                            ISNULL(CTT2.CTT_DESC01,'') AS CTT_DESC02,
                            ISNULL(C7_DATPRF,'') AS C7_DATPRF,
                            (SELECT ISNULL(MAX(CR_DATALIB),'') AS CR_DATALIB FROM %table:SCR% (nolock) F WHERE CR_FILIAL=SUBSTRING(C7_FILIAL,1,2) AND  CR_NUM=C7_NUM AND F.D_E_L_E_T_='' ) AS CR_DATALIB,		 
                            C7_APROV,
                            C7_RESIDUO,
                            AL_DESC
                            FROM %table:SC7% SC7 (NOLOCK)
                                INNER JOIN SA2010 SA2 (NOLOCK) ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND SA2.D_E_L_E_T_=''
                                LEFT OUTER JOIN %table:SC1% SC1 (NOLOCK)  ON C7_FILIAL = C1_FILIAL AND C1_NUM = C7_NUMSC AND C1_ITEM = C7_ITEMSC   AND SC1.D_E_L_E_T_=''
                                LEFT OUTER JOIN %table:SC8% SC8 (NOLOCK)  ON C8_FILIAL = C7_FILIAL AND C8_NUMPED = C7_NUM AND C7_ITEM = C8_ITEMPED AND SC8.D_E_L_E_T_='' 
                                LEFT OUTER JOIN %table:SD1% SD1 (NOLOCK)  ON D1_FILIAL = C7_FILIAL AND D1_PEDIDO = C7_NUM AND D1_ITEMPC = C7_ITEM  AND SD1.D_E_L_E_T_=''
                                LEFT OUTER JOIN CTT010 CTT (NOLOCK)  ON C1_CC = CTT_CUSTO AND CTT.D_E_L_E_T_=''
                                LEFT OUTER JOIN CTT010 CTT2 (NOLOCK) ON D1_CC = CTT2.CTT_CUSTO AND CTT2.D_E_L_E_T_=''
                                LEFT OUTER JOIN %table:SB1% SB1 (NOLOCK)  ON C7_PRODUTO = B1_COD AND SB1.D_E_L_E_T_=''
                                LEFT OUTER JOIN %table:SAL% SAL (NOLOCK)  ON C7_APROV = AL_COD AND SAL.D_E_L_E_T_=''
                            WHERE SC7.D_E_L_E_T_='' AND C7_EMISSAO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%  
		EndSql
		
cAlias:="AACOMR05"
oSecao1:EndQuery()
oReport:SetMeter((cAlias)->(RecCount()))
oSecao1:Print()

Return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Relatório de Follow Up de Compras"
local cHelp   := "Relatório de Follow Up de Compras - Especifico Amazon Aço"
local oReport
local oSection1

oReport := TReport():New('AACOMR05',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
oReport:SetLandScape()
	  				  
//Primeira seção
oSection1 := TRSection():New(oReport,"Relatório de Movimentação de Produção",{"AAESTR08"})

TRCell():New(oSection1,"C7_FILIAL"  , "AACOMR05", RetTitle("C7_FILIAL")    ,PesqPict("SC7","C7_FILIAL")   ,TamSX3("C7_FILIAL")[1])
TRCell():New(oSection1,"C7_NUMSC"   , "AACOMR05", RetTitle("C7_NUMSC")     ,PesqPict("SC7","C7_NUMSC")    ,TamSX3("C7_NUMSC")[1])
TRCell():New(oSection1,"C7_ITEMSC"  , "AACOMR05", RetTitle("C7_ITEMSC")    ,PesqPict("SC7","C7_ITEMSC")   ,TamSX3("C7_ITEMSC")[1])
TRCell():New(oSection1,"C1_EMISSAO" , "AACOMR05", RetTitle("C1_EMISSAO")   ,PesqPict("SC1","C1_EMISSAO")  ,TamSX3("B1_DESC")[1])
TRCell():New(oSection1,"C1_SOLICIT" , "AACOMR05", RetTitle("C1_SOLICIT")   ,PesqPict("SC1","C1_SOLICIT")  ,TamSX3("C1_SOLICIT")[1])
TRCell():New(oSection1,"C1_CC"      , "AACOMR05", RetTitle("C1_CC")        ,PesqPict("SC1","C1_CC")       ,TamSX3("C1_CC")[1])
TRCell():New(oSection1,"CTT_DESC01" , "AACOMR05", RetTitle("CTT_DESC01")   ,PesqPict("CTT","CTT_DESC01")  ,TamSX3("CTT_DESC01")[1])
TRCell():New(oSection1,"C7_EMISSAO" , "AACOMR05", RetTitle("C7_EMISSAO")   ,PesqPict("SC7","C7_EMISSAO")  ,TamSX3("C7_EMISSAO")[1])
TRCell():New(oSection1,"C7_NUM"      , "AACOMR05", RetTitle("C7_NUM")      ,PesqPict("SC7","C7_NUM")      ,TamSX3("C7_NUM")[1])
TRCell():New(oSection1,"C7_FORNECE"  , "AACOMR05", RetTitle("C7_FORNECE")  ,PesqPict("SC7","C7_FORNECE")  ,TamSX3("C7_FORNECE")[1])
TRCell():New(oSection1,"A2_NOME "    , "AACOMR05", RetTitle("A2_NOME")     ,PesqPict("SA2","A2_NOME")     ,TamSX3("A2_NOME")[1])
TRCell():New(oSection1,"C7_ITEM "    , "AACOMR05", RetTitle("C7_ITEM")     ,PesqPict("SC7","C7_ITEM")     ,TamSX3("C7_ITEM")[1])
TRCell():New(oSection1,"C7_PRODUTO " , "AACOMR05", RetTitle("C7_PRODUTO")  ,PesqPict("SC7","C7_PRODUTO")  ,TamSX3("C7_PRODUTO")[1])
TRCell():New(oSection1,"B1_DESC "    , "AACOMR05", RetTitle("B1_DESC")     ,PesqPict("SB1","B1_DESC")     ,TamSX3("B1_DESC")[1])
TRCell():New(oSection1,"B1_UM"       , "AACOMR05", RetTitle("B1_UM")       ,PesqPict("SB1","B1_UM")       ,TamSX3("B1_UM")[1])
TRCell():New(oSection1,"C7_QUANT "   , "AACOMR05", RetTitle("C7_QUANT")    ,PesqPict("SC7","C7_QUANT")    ,TamSX3("C7_QUANT")[1])
TRCell():New(oSection1,"C7_PRECO "   , "AACOMR05", RetTitle("C7_PRECO")    ,PesqPict("SC7","C7_PRECO")    ,TamSX3("C7_PRECO")[1])
TRCell():New(oSection1,"C7_TOTAL "   , "AACOMR05", RetTitle("C7_TOTAL")    ,PesqPict("SC7","C7_TOTAL")    ,TamSX3("C7_TOTAL")[1])
TRCell():New(oSection1,"C7_NUMCOT "  , "AACOMR05", RetTitle("C7_NUMCOT")   ,PesqPict("SC7","C7_NUMCOT")   ,TamSX3("C7_NUMCOT")[1])
TRCell():New(oSection1,"C8_EMISSAO"  , "AACOMR05", RetTitle("C8_EMISSAO")  ,PesqPict("SC8","C8_EMISSAO")  ,TamSX3("C8_EMISSAO")[1])
TRCell():New(oSection1,"D1_DOC"      , "AACOMR05", RetTitle("D1_DOC")      ,PesqPict("SD1","D1_DOC")      ,TamSX3("D1_DOC")[1])
TRCell():New(oSection1,"D1_EMISSAO"  , "AACOMR05", RetTitle("D1_EMISSAO")  ,PesqPict("SD1","D1_EMISSAO")  ,TamSX3("D1_EMISSAO")[1])
TRCell():New(oSection1,"D1_DTDIGIT"  , "AACOMR05", RetTitle("D1_DTDIGIT")  ,PesqPict("SD1","D1_DTDIGIT")  ,TamSX3("D1_DTDIGIT")[1])
TRCell():New(oSection1,"D1_QUANT"    , "AACOMR05", RetTitle("D1_QUANT")    ,PesqPict("SD1","D1_QUANT")    ,TamSX3("D1_QUANT")[1])
TRCell():New(oSection1,"D1_VUNIT"    , "AACOMR05", RetTitle("D1_VUNIT")    ,PesqPict("SD1","D1_VUNIT")    ,TamSX3("D1_VUNIT")[1])
TRCell():New(oSection1,"D1_TOTAL"    , "AACOMR05", RetTitle("D1_TOTAL")    ,PesqPict("SD1","D1_TOTAL")    ,TamSX3("D1_TOTAL")[1])
TRCell():New(oSection1,"C7_CONTRA"   , "AACOMR05", RetTitle("C7_CONTRA")   ,PesqPict("SC7","C7_CONTRA")   ,TamSX3("C7_CONTRA")[1])
TRCell():New(oSection1,"C7_CONTREV"  , "AACOMR05", RetTitle("C7_CONTREV")  ,PesqPict("SC7","C7_CONTREV")  ,TamSX3("C7_CONTREV")[1])					   
TRCell():New(oSection1,"D1_CC"       , "AACOMR05", RetTitle("D1_CC")       ,PesqPict("SD1","D1_CC")       ,TamSX3("D1_CC")[1])
TRCell():New(oSection1,"CTT_DESC02"  , "AACOMR05", RetTitle("Centro C.NF") ,PesqPict("CTT","CTT_DESC01")  ,TamSX3("CTT_DESC01")[1])
TRCell():New(oSection1,"CR_DATALIB"  , "AACOMR05", RetTitle("CR_DATALIB")  ,PesqPict("SCR","CR_DATALIB")  ,TamSX3("CR_DATALIB")[1])
TRCell():New(oSection1,"C7_APROV"    , "AACOMR05", RetTitle("D1_CC")       ,PesqPict("SD1","D1_CC")       ,TamSX3("D1_CC")[1])	
TRCell():New(oSection1,"C7_RESIDUO"  , "AACOMR05", RetTitle("C7_RESIDUO")  ,PesqPict("SC7","C7_RESIDUO")  ,TamSX3("C7_RESIDUO")[1])
TRCell():New(oSection1,"AL_DESC"     , "AACOMR05", RetTitle("AL_DESC")     ,PesqPict("SAL","AL_DESC")     ,TamSX3("AL_DESC")[1])	

Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+

Static function criaSX1(cPerg)

U_PIPutSx1(cPerg, '01', 'Da Data?'            , '', '', 'mv_ch1', 'D', 8, 0, 0, 'G', '',      '',  '', '', 'mv_par01')
U_PIPutSx1(cPerg, '02', 'Até Data?'           , '', '', 'mv_ch2', 'D', 8, 0, 0, 'G', '',      '',  '', '', 'mv_par02')

Return
