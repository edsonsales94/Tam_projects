#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR44    บAutor  ณStan Lee Lopes     				บ Data ณ  09/12/21 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Verifica transferencias entre Armazens 						  			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR44()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR44"

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

	oReport := TReport():New(cPerg,"Verifica Transferencia entre Armazens",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Verifica Transferencia entre Armazens",{"SD3"},aOrdem)  


	TRCell():New(oSection,"TM"					,"SD3","Tipo Mov","@!",10)             
	TRCell():New(oSection,"PRODUTO" 			,"SD3","Produto","@!",25) 
	TRCell():New(oSection,"DESCRICAO"   		,"SD3","Descri็ใo","@!",150)
	TRCell():New(oSection,"UM"    	    		,"SD3","UM","@!",10)
	TRCell():New(oSection,"ARMAZEM"     		,"SD3","Armazem","@!",10)
	TRCell():New(oSection,"QTD_TRANSFERIDA"    	,"SD3","Qtd. Transferida","@E 999,999,999,999",14)
	TRCell():New(oSection,"SALDO_ATUAL"    		,"SD3","Saldo Atual","@E 999,999,999,999",14)
	TRCell():New(oSection,"QTD_PICKLIST"    	,"SD3","Qtd. Picklist","@E 999,999,999,999",14)
	TRCell():New(oSection,"DIFERENCA"    		,"SD3","Diferen็a","@E 999,999,999,999",14)
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("ETIQUETA"),"Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)

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

SELECT D3_TM TM,D3_COD PRODUTO,SB12.B1_DESC DESCRICAO,SB12.B1_UM UM,B2_LOCAL ARMAZEM,SUM(D3_QUANT)QTD_TRANSFERIDA,B2_QATU SALDO_ATUAL,TOTAL QTD_PICKLIST,TOTAL - SUM(D3_QUANT) DIFERENCA
FROM SD3100 SD3 (NOLOCK)
INNER JOIN SB1100 SB12 (NOLOCK) ON D3_COD = SB12.B1_COD AND SB12.D_E_L_E_T_ = ''
INNER JOIN SB2100 SB2 (NOLOCK) ON D3_COD = B2_COD AND SB2.D_E_L_E_T_ = '' AND B2_FILIAL = '01' AND B2_LOCAL = '10'
LEFT JOIN ( SELECT G1_COMP,DESCRI,UNIDADE,SUM(TOTAL)TOTAL
            FROM(
					SELECT G1_COMP,SB13.B1_DESC DESCRI,SB13.B1_UM UNIDADE,G1_QUANT,SUM(PED_QUANT)*G1_QUANT TOTAL
					FROM PED
					INNER JOIN PK2 ON PED_CODIGO = PK2_CODIGO AND PED_OP = PK2_OP
					INNER JOIN SG1100 SG1 ON PED_PRODUTO = G1_COD AND SG1.D_E_L_E_T_ = ''
					INNER JOIN SB1100 SB1 ON G1_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
					INNER JOIN SB1100 SB13 ON G1_COMP = SB13.B1_COD AND SB13.D_E_L_E_T_ = ''
					WHERE
					CONVERT(VARCHAR,CAST(PK2_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
					AND G1_COMP NOT LIKE 'MOD%'
					AND G1_COMP NOT LIKE '050%'
					AND G1_COMP NOT LIKE 'SUP%'
					AND G1_COMP BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
					GROUP BY G1_COMP,G1_QUANT,SB13.B1_DESC,SB13.B1_UM
			)TB
			GROUP BY G1_COMP,DESCRI,UNIDADE)PED ON D3_COD = G1_COMP
WHERE SD3.D_E_L_E_T_ = ''
AND D3_COD NOT LIKE '050%'
AND D3_COD NOT LIKE 'SUP%'
AND D3_COD BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND D3_FILIAL = '01'
AND D3_TM = '501'
AND D3_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
GROUP BY D3_TM,D3_COD,SB12.B1_DESC,B2_LOCAL,SB12.B1_UM,B2_QATU,TOTAL
ORDER BY SB12.B1_DESC



	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Emissao:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Emissao:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Produto:",20)+"?","","","mv_ch3","C",15,0,0,"G","","","SB1","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Produto:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","SB1","","mv_par04")

Return