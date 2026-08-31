#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFATR18    ºAutor  ³Wilson Junior     				º Data ³  03/05/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  RELATÓRIO DE Indicadores por Salário									 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLESTR17()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLESTR17"

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

	oReport := TReport():New(cPerg,"Relatorio de Custo",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      •//Primeira seção
	oSection := TRSection():New(oReport,"Relatorio de Custo",{"SG1"},aOrdem) 


	TRCell():New(oSection,"G1_COD"	        			,"SG1","Codigo",/*Mascara*/,17)  
	TRCell():New(oSection,"PRODUTO"	        			,"SB1","Produto",/*Mascara*/,60)  
	TRCell():New(oSection,"CUSTO"	        			,"SG1","Custo",/*Mascara*/,20)
	TRCell():New(oSection,"DA1_PRCVEN"	       			,"SG1","Preco de venda",/*Mascara*/,10)  

	//TRCell():New(oSection,"RA_DTFIMCT"	        		,"SRA","Fim do Contrato",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"RA_DEFIFIS"	       			,"SRA","Deficiente",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"RA_BRPDH"	        		,"SRA","Reabilitado?",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"RA_TPDEFFI"        			,"SRA","Tipo de Deficiencia",/*Mascara*/,/*Tamanho*/)
	//Totalizador                                                                                  


	/*
	TRFunction():New(oSection:Cell("M"),"Masculino","SUM",,,,,.F.,.T.)  
	TRFunction():New(oSection:Cell("F"),"Feminino","SUM",,,,,.F.,.T.)  
	*/
	//TRFunction():New(oSection:Cell("DA1_DESC"),"TOTAL DIFERENÇA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)  
	//TRFunction():New(oSection:Cell("DA1_TOTAL"),"TOTAL FABRICA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)  
	/*
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                      MIMIM ·
	//endif      
	Local nTotReg :=0

	/*
	local par01 :=0
	local par02 :=0
	if %Exp:MV_PAR05% == 1 
	par01 := "M"
	else
	par01 := "F"
	endif 
	if %Exp:MV_PAR06% == 1 
	par02 := "M"
	else
	par02 := "F"
	endif
	*/

	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%   

		
		SELECT G1_COD,PRODUTO,SUM(CUSTO) CUSTO,ISNULL(DA1_PRCVEN,'') DA1_PRCVEN FROM (	
		SELECT G1_COD,SB11.B1_DESC PRODUTO,G1_COMP,SB12.B1_DESC COMPONENTE,G1_QUANT*ISNULL(SB21.B2_CM1,SB22.B2_CM1) CUSTO
		FROM %Table:SG1% SG1 (NOLOCK)
		INNER JOIN %Table:SB1% SB11 (NOLOCK) ON SB11.B1_COD = G1_COD AND SB11.D_E_L_E_T_ ='' AND SB11.B1_MSBLQL != '1'
		INNER JOIN %Table:SB1% SB12 (NOLOCK) ON SB12.B1_COD = G1_COMP AND SB12.D_E_L_E_T_ ='' AND SB12.B1_MSBLQL != '1'
		LEFT JOIN %Table:SB2% SB21 (NOLOCK) ON SB21.B2_COD = G1_COMP AND SB21.D_E_L_E_T_ ='' AND SB21.B2_LOCAL = '01'
		LEFT JOIN %Table:SB2% SB22 (NOLOCK) ON SB22.B2_COD = G1_COMP AND SB22.D_E_L_E_T_ ='' AND SB22.B2_LOCAL = '10'
		WHERE 
	
		SB11.B1_TIPO ='PA'
		AND G1_COMP NOT LIKE 'MOD%'
		AND G1_FIM >= '20210101'
		AND SG1.D_E_L_E_T_ = ''
		GROUP BY G1_COD,SB11.B1_DESC,G1_COMP,SB12.B1_DESC,G1_QUANT,SB22.B2_CM1,SB21.B2_CM1,G1_TRT
		)TB
		INNER JOIN %Table:SD2% SD2 (NOLOCK) ON D2_COD = G1_COD AND SD2.D_E_L_E_T_ = ''
		LEFT JOIN %Table:DA1% DA1 (NOLOCK) ON DA1_CODTAB = %Exp:MV_PAR05% AND DA1_CODPRO = G1_COD
		WHERE D2_EMISSAO >= '20210101'
		AND G1_COD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND D2_CLIENTE BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		GROUP BY G1_COD,PRODUTO,DA1_PRCVEN
		ORDER BY G1_COD
		

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return



Static Function AjustaSX1(cPerg)            

	u_InPutSX1(cPerg,"01",PADR("Produto De    ",20)+"?","","","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Produto Até   ",20)+"?","","","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Cliente De    ",20)+"?","","","mv_ch3","C",6,0,0,"G","","SA1","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Cliente Até   ",20)+"?","","","mv_ch4","C",6,0,0,"G","","SA1","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Tabela de preco   ",20)+"?","","","mv_ch5","C",3,0,0,"G","","","","","mv_par05")

Return
