#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLESTR35    ºAutor  ³Kledson Oliveira    				º Data ³  12/02/24 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Incentivos ICMS Detalhados 						  					 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLESTR35()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLESTR35"

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

	oReport := TReport():New(cPerg,"Incentivos ICMS Detalhados",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Incentivos ICMS Detalhados",{"CDA"},aOrdem)  


	TRCell():New(oSection,"F1_ESPECIE"		,"SF1","Especie","@!",4)             
	TRCell():New(oSection,"D1_FILIAL" 		,"SD1","Filial","@!",2) 
	TRCell():New(oSection,"D1_DOC"   		,"SD1","Nota","@!",12)
	TRCell():New(oSection,"D1_SERIE"    	,"SD1","Serie","@!",5)
    TRCell():New(oSection,"D1_ITEM"    		,"SD1","Item","@!",3)
	TRCell():New(oSection,"D1_COD"    		,"SD1","Cod.Produto","@!",20)
	TRCell():New(oSection,"D1_QUANT"    	,"SD1","Quantidade","@!",4)
	TRCell():New(oSection,"D1_CF"    		,"SD1","CFOP","@!",4)
	TRCell():New(oSection,"CDA_CLIFOR"    	,"CDA","Cli/Forn","@!",6)
	TRCell():New(oSection,"CDA_LOJA"    	,"CDA","Loja","@!",2)
	TRCell():New(oSection,"D1_PICM"    		,"SD1","Aliq. ICMS","@!",2)
	TRCell():New(oSection,"D1_VALICM"    	,"SD1","Val. ICMS","@E 999,999,999,999",)
    TRCell():New(oSection,"D1_BASEICM"    	,"SD1","Base ICMS","@E 999,999,999,999",)
	TRCell():New(oSection,"CDA_BASE"    	,"CDA","Val. Base Lanc","@E 999,999,999,999",)
	TRCell():New(oSection,"CDA_VALOR"    	,"CDA","Val. Lanc","@E 999,999,999,999",)
	TRCell():New(oSection,"D1_TOTAL"    	,"SD1","Total nota","@E 999,999,999,999",)
	TRCell():New(oSection,"CDA_TPMOVI"    	,"CDA","Tipo Mov","@!",1)
	TRCell():New(oSection,"CDA_CODLAN"    	,"CDA","Cod. Lanc","@!",15)

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

	SELECT F1_ESPECIE,D1_FILIAL,D1_DOC,D1_SERIE,D1_ITEM,D1_COD,D1_QUANT,D1_CF,CDA_CLIFOR,CDA_LOJA,D1_PICM,D1_VALICM,D1_BASEICM,CDA_BASE,CDA_VALOR,D1_TOTAL,CDA_TPMOVI,CDA_CODLAN 
	FROM CDA100 CDA (NOLOCK) 
	INNER JOIN SD1100 SD1 (NOLOCK) ON CDA_FILIAL = D1_FILIAL AND CDA_NUMERO = D1_DOC AND CDA_SERIE = D1_SERIE AND CDA_NUMITE = D1_ITEM AND CDA_CLIFOR = D1_FORNECE AND CDA_LOJA = D1_LOJA AND SD1.D_E_L_E_T_ = '' 
	INNER JOIN SF1100 SF1 (NOLOCK) ON D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND SF1.D_E_L_E_T_ = '' 
	WHERE CDA.D_E_L_E_T_ = '' 
	AND D1_FILIAL = '01' 
	AND D1_BASEICM > 0 
	AND D1_CF NOT IN ('5914','5916') 
	AND D1_DTDIGIT BETWEEN %Exp:MV_PAR01%  AND %Exp:MV_PAR02% 
	AND F1_ESPECIE IN ('SPED','CTE') 
	GROUP BY F1_ESPECIE,D1_FILIAL,D1_DOC,D1_SERIE,D1_ITEM,D1_COD,D1_QUANT,D1_CF,CDA_CLIFOR,CDA_LOJA,D1_PICM,D1_VALICM,D1_BASEICM,CDA_BASE,CDA_VALOR,D1_TOTAL,CDA_TPMOVI,CDA_CODLAN 
	UNION 
	SELECT F2_ESPECIE,D2_FILIAL,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,D2_QUANT,D2_CF,CDA_CLIFOR,CDA_LOJA,D2_PICM,D2_VALICM,D2_BASEICM,CDA_BASE,CDA_VALOR,D2_TOTAL,CDA_TPMOVI,CDA_CODLAN 
	FROM CDA100 CDA (NOLOCK) 
	INNER JOIN SD2100 SD2 (NOLOCK) ON CDA_FILIAL = D2_FILIAL AND CDA_NUMERO = D2_DOC AND CDA_SERIE = D2_SERIE AND CDA_NUMITE = D2_ITEM AND CDA_CLIFOR = D2_CLIENTE AND CDA_LOJA = D2_LOJA AND SD2.D_E_L_E_T_ = '' 
	INNER JOIN SF2100 SF2 (NOLOCK) ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA AND SF2.D_E_L_E_T_ = '' 
	WHERE CDA.D_E_L_E_T_ = '' 
	AND D2_FILIAL = '01' 
	AND D2_BASEICM > 0  
	AND D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%  
	AND F2_ESPECIE IN ('SPED') 
	GROUP BY F2_ESPECIE,D2_FILIAL,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,D2_QUANT,D2_CF,CDA_CLIFOR,CDA_LOJA,D2_PICM,D2_VALICM,D2_BASEICM,CDA_BASE,CDA_VALOR,D2_TOTAL,CDA_TPMOVI,CDA_CODLAN
    ORDER BY D1_FILIAL, D1_DOC, D1_SERIE, D1_ITEM, D1_COD ASC 



	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Dt. Emissao/Digitacao De    ? ",20)+"","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Dt. Emissao/Digitacao Ate   ? ",20)+"","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")

Return
