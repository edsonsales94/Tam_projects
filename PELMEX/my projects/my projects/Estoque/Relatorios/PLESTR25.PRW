#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLESTR25    ºAutor  ³WYLLIAM Silva    				º Data ³  04/02/23 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  PRODUÇÃO POR EMPENHO						  					 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLESTR25()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLESTR25"

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

	oReport := TReport():New(cPerg,"RELATORIO DE PRODUCAO (PA)",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"RELATORIO DE PRODUCAO (PA)",{"SD3"},aOrdem)  


	TRCell():New(oSection,"EMISSAO"				,"SD3","EMISSAO","@!",12)           
	TRCell():New(oSection,"D3_COD" 	   			,"SD3","PRODUTO","@!",15) 
	TRCell():New(oSection,"B1_DESC" 	   		,"SB1","DESCRICAO","@!",45)
	TRCell():New(oSection,"B1_TIPO" 	   		,"SB1","TIPO","@!",4)
	TRCell():New(oSection,"D3_QUANT"  			,"SD3","QTD","@E 999,999,999.999",)
	TRCell():New(oSection,"D3_QTSEGUM"    	   	,"SD3","QTD2MED","@E 999,999,999.999",)
	TRCell():New(oSection,"D3_OP"    	        ,"SD3","ORDEM PROD","@!",10)   
	TRCell():New(oSection,"D3_GRUPO"        	,"SD3","GRUPO","@!",8)    
	TRCell():New(oSection,"BM_DESC"    	        ,"SBM","DESCGRUPO","@!",15)      
	//TRCell():New(oSection,"D3_CC"           	,"SD3","CENTRO CUSTO","@!",10)
	TRCell():New(oSection,"B1_CONV"           	,"SB1","CONVERSAO","@E 999,999,999.999",)	
	TRCell():New(oSection,"ATU2UM"           	,"SD3","ATU2UM","@E 999,999,999.999",10)
	TRCell():New(oSection,"TURNO"           	,"SD3","TURNO","@!",20)
	//TRCell():New(oSection,"DESCGRUPO"			,"SBM","Grupo","@!",20)  
	
	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("D3_QUANT"),"Quantidade:","SUM",,,"@E 999,999,999.999",,.F.,.T.)
	TRFunction():New(oSection:Cell("D3_QTSEGUM"),"Quantidade:","SUM",,,"@E 999,999,999.999",,.F.,.T.)
	TRFunction():New(oSection:Cell("ATU2UM"),"Quantidade:","SUM",,,"@E 999,999,999.999",,.F.,.T.)

		oReport:SetTotalInLine(.F.)

	//quebra  por seção (.T.) uma seção por pagina
	oSection:SetPageBreak(.F.)
	oSection:SetTotalText(" ")	

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

	SELECT CONVERT(VARCHAR,CAST(D3_EMISSAO AS DATE),103) EMISSAO,D3_COD,B1_DESC,B1_TIPO,D3_QUANT,D3_QTSEGUM,D3_OP,D3_GRUPO,BM_DESC,D3_CC,B1_CONV,
		CASE WHEN D3_QTSEGUM > '0'THEN D3_QTSEGUM ELSE CASE WHEN B1_TIPCONV = 'M' THEN D3_QUANT * B1_CONV ELSE CASE WHEN B1_TIPCONV = 'D' THEN D3_QUANT / B1_CONV END END END ATU2UM,'COMERCIAL' TURNO
    FROM  %Table:SD3% (NOLOCK) SD3
    INNER JOIN %Table:SB1% (NOLOCK) SB1 ON B1_COD = D3_COD AND SB1.D_E_L_E_T_ =''
    INNER JOIN %Table:SBM% (NOLOCK) SBM ON BM_GRUPO = D3_GRUPO AND SBM.D_E_L_E_T_ =''
    WHERE SD3.D_E_L_E_T_ =''
    AND LEFT(D3_CF,2) = 'PR'
    AND D3_TIPO = 'PA'
    AND D3_ESTORNO = ''
    AND D3_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND D3_GRUPO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
    ORDER BY D3_EMISSAO

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Data:" ,20)+"?","","","mv_ch1","D",15,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",15,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Grupo:" ,20)+"?","","","mv_ch3","C",4,0,0,"G","","SBM","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Grupo:",20)+"?","","","mv_ch4","C",4,0,0,"G","","SBM","","","mv_par04")
	
Return
