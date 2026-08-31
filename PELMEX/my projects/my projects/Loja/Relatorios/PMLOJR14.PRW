#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMLOJR13    บAutor  ณWilson Guedes      				บ Data ณ  29/06/21 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  RELATำRIO DE ESTOQUE DO DEPOSITO	      								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMLOJR14()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMLOJR14"

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

	oReport := TReport():New(cPerg,"RELATำRIO DE SALDO LOJA ",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"SALDO ATUAL",{"SD4"},aOrdem) 

	TRCell():New(oSection,"B2_FILIAL"			,"SB2","Filial",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"B2_COD"				,"SB2","Cod. Produto",/*Mascara*/,26)
	TRCell():New(oSection,"B1_DESC"				,"SB2","Descricใo",/*Mascara*/,50)
	TRCell():New(oSection,"B2_LOCAL"			,"SB1","Armazem",,/*Tamanho*/)
	TRCell():New(oSection,"B2_QATU"		    	,"SB2","Estoque Atual",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"INVENTARIO"		    ,"SB2","Inventariado",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"DIFERENCA"		    ,"SB2","Diferenca",/*Mascara*/,20)
	TRCell():New(oSection,"COL_CONFER"		    ,"SB2","Conferente",/*Mascara*/,50)
	//Totalizador
	/*                                                                                  
	TRFunction():New(oSection:Cell("L2_VLRITEM"),"TOTAL BASE","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)  
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)
	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ท
	//endif      


	oSection:BeginQuery()
BeginSQL Alias cAlias
		%noparser%   

/*		
SELECT B2_FILIAL,COL_CONFER,B2_COD,B1_DESC,B2_LOCAL,B2_QATU,ISNULL(COL_QUANT,0) INVENTARIO,B2_QATU - ISNULL(COL_QUANT,0) DIFERENCA 
FROM %Table:SB2% SB2
INNER JOIN %Table:SB1% SB1 ON B1_COD = B2_COD AND SB1.D_E_L_E_T_ = ''
LEFT JOIN (   SELECT COL_EMPRESA,COL_FILIAL,COL_DOC,COL_CONFER,COL_COD,COL_LOCAL,
             CASE WHEN B1_XJUNCAO = 'S' THEN '0.5' ELSE '1'END COL_QUANT 
		      FROM COLINV
			  LEFT JOIN SB1100 (NOLOCK) SB1 ON COL_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
			  WHERE COL_DOC   = %Exp:MV_PAR01%
			  AND COL_FILIAL  = %Exp:MV_PAR02%
			  AND COL_LOCAL   = %Exp:MV_PAR03%
			  AND COL_EMPRESA = %Exp:MV_PAR04%
			  GROUP BY COL_EMPRESA,COL_FILIAL,COL_DOC,COL_CONFER,COL_COD,COL_LOCAL)CI ON B2_FILIAL = COL_FILIAL AND B2_LOCAL = COL_LOCAL AND B2_COD = COL_COD
WHERE SB2.D_E_L_E_T_ = ''
AND B2_FILIAL = %Exp:MV_PAR02%
AND B2_LOCAL  = %Exp:MV_PAR03%
GROUP BY B2_FILIAL,B2_COD,B1_DESC,B2_LOCAL,B2_QATU,COL_QUANT,COL_CONFER 
ORDER BY B2_COD,B1_DESC
*/

SELECT B2_FILIAL,ISNULL(COL_CONFER,'')COL_CONFER,B2_COD,B1_DESC,B2_LOCAL,B2_QATU,ISNULL(COL_QUANT,0) INVENTARIO,B2_QATU - ISNULL(COL_QUANT,0) DIFERENCA 
FROM SB2100 SB2 (NOLOCK)
INNER JOIN SB1100 SB1 (NOLOCK) ON B1_COD = B2_COD AND SB1.D_E_L_E_T_ = ''
LEFT JOIN (SELECT COL_EMPRESA,COL_FILIAL,COL_DOC,COL_CONFER,COL_COD,COL_LOCAL,SUM(COL_QUANT)COL_QUANT
           FROM(
           SELECT COL_EMPRESA,COL_FILIAL,COL_DOC,COL_CONFER,COL_COD,COL_LOCAL,
              CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END COL_QUANT 
           FROM COLINV (NOLOCK)
       INNER JOIN SB1100 SB1 (NOLOCK) ON COL_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
           WHERE COL_DOC   = %Exp:MV_PAR01%
           AND COL_FILIAL  = %Exp:MV_PAR02%
           AND COL_LOCAL   = %Exp:MV_PAR03%
           AND COL_EMPRESA = %Exp:MV_PAR04%
           )TB
       GROUP BY COL_EMPRESA,COL_FILIAL,COL_DOC,COL_CONFER,COL_COD,COL_LOCAL)CI ON B2_FILIAL = COL_FILIAL AND B2_LOCAL = COL_LOCAL AND B2_COD = COL_COD
WHERE SB2.D_E_L_E_T_ = ''
AND B2_FILIAL = %Exp:MV_PAR02%
AND B2_LOCAL  = %Exp:MV_PAR03%
GROUP BY B2_FILIAL,B2_COD,B1_DESC,B2_LOCAL,B2_QATU,COL_QUANT ,COL_CONFER 
ORDER BY B2_COD,B1_DESC

EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return

Static Function AjustaSX1(cPerg)
	u_InPutSX1(cPerg,"01",PADR("Documento    ",20)+"?","","","mv_ch1","C",9,0,0,"G","","","","","mv_par01")  
	u_InPutSX1(cPerg,"02",PADR("Filial       ",20)+"?","","","mv_ch2","C",2,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Armazem      ",20)+"?","","","mv_ch3","C",2,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Empresa      ",20)+"?","","","mv_ch4","C",2,0,0,"G","","","","","mv_par04")
Return
