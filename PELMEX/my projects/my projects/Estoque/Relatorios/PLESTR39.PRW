#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR39    บAutor  ณKledson Oliveira    				บ Data ณ  13/05/25 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ CEIPIM PRODUCAO						  					 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLESTR39()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLESTR39"

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

	oReport := TReport():New(cPerg,"CEIPIM PRODUCAO",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"CEIPIM PRODUCAO",{"SB2"},aOrdem)  


	TRCell():New(oSection,"Resumo" 		,"SD3","Resumo","@!",30) 
	TRCell():New(oSection,"Quantidade"		,"SD3","Quantidade","@E 999,999,999,999.99",15)             
	//TRCell():New(oSection,"Total"   		,"SD2","Total","@E 9,999,999,999.99",)
	//TRCell():New(oSection,"Tributacao"    	,"SD2","Tributacao","@!",20)
    //TRCell():New(oSection,"PIK_DESC"    		,"SD1","Descricao","@!",30)
	//TRCell():New(oSection,"QTD"    		,"SD1","Qtd. Bip","@E 9,999,999,999.99",)
	//TRCell():New(oSection,"SALDO_20"    	,"SD1","Qtd. Saldo","@E 9,999,999,999.99",)

	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("Quantidade"),"Quantidade Total:","SUM",,,"@E 999,999,999,999.99",,.F.,.T.)

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


SELECT GRUPO Resumo,SUM(QTD_SD3)Quantidade
FROM(
SELECT SD3.D3_EMISSAO,SD3.D3_TM,SD3.D3_OP ,B1_GRUPO, BM_DESC,SD3.D3_LOCAL,
       CASE WHEN (BM_DESC LIKE 'CAMA%') THEN 'CAMA'
	        WHEN (BM_DESC LIKE 'COLCHAO%ESPUMA%') AND (BM_DESC NOT LIKE '%VACUO%') THEN 'COLCHAO ESPUMA'
			WHEN (BM_DESC LIKE 'COLCHAO%ESPUMA%') AND (BM_DESC LIKE '%VACUO%') THEN 'COLCHAO ESPUMA ENROLADO'
			WHEN (BM_DESC LIKE 'COLCHAO%MOLA%') AND (BM_DESC NOT LIKE '%VACUO%') THEN 'COLCHAO MOLA'
			WHEN (BM_DESC LIKE 'COLCHAO%MOLA%') AND (BM_DESC LIKE '%VACUO%') THEN 'COLCHAO MOLA ENROLADO'
			WHEN (BM_DESC LIKE 'TRAV%') THEN 'TRAVESSEIRO'
		ELSE BM_DESC END GRUPO,
	   SD3.D3_COD,B1_DESC,B1_UM,B1_TIPO,SD3.D3_QUANT-ISNULL(QTD_SD31,0) QTD_SD3
FROM %Table:SD3% SD3 (NOLOCK)
INNER JOIN %Table:SB1% SB1 (NOLOCK) ON D3_COD = B1_COD AND SD3.D_E_L_E_T_ = ''
INNER JOIN %Table:SBM% SBM (NOLOCK) ON B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = ''
LEFT JOIN (SELECT D3_OP OP,D3_COD CODIGO, D3_LOCAL ARMAZEM,D3_QUANT QTD_SD31
            FROM %Table:SD3% SD3 (NOLOCK)
			WHERE SD3.D_E_L_E_T_ = ''
			AND D3_LOCAL NOT IN ('10','30')
			AND D3_TIPO IN ('PA','PC')
			AND D3_TM IN ('999')
			AND D3_EMISSAO BETWEEN %EXP:Mv_par01% AND %EXP:Mv_par02%//--%Exp:MV_PAR01% AND %Exp:MV_PAR02% 
			)SD31 ON SD3.D3_OP = OP AND SD3.D3_COD = CODIGO AND SD3.D3_LOCAL = ARMAZEM
WHERE SD3.D_E_L_E_T_ = ''
AND B1_TIPO IN ('PA','PC')
AND SD3.D3_LOCAL NOT IN ('10','30')
AND SD3.D3_TM IN ('001')
AND SD3.D3_EMISSAO BETWEEN %EXP:Mv_par01% AND %EXP:Mv_par02%//--%Exp:MV_PAR01% AND %Exp:MV_PAR02%
)TB
GROUP BY GRUPO
ORDER BY 1


	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)


	u_InPutSX1(cPerg,"01",PADR("Dt. Emissao de    ? ",20)+"","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Dt. Emissao ate  ? ",20)+"","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")

Return
