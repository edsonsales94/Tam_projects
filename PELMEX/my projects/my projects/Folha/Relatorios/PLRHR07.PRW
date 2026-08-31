#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFATR18    ºAutor  ³Wilson Junior     				º Data ³  03/05/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  RELATÓRIO Indicadores 													 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLRHR07()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLRHR07"

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

	oReport := TReport():New(cPerg,"Idade X Contribuição ",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      •//Primeira seção
	oSection := TRSection():New(oReport,"Idade X Contribuição",{"SRA"},aOrdem) 


	TRCell():New(oSection,"RA_FILIAL"	        	,"SRA","Filial",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RA_MAT"	       			,"SRA","Matricula",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RA_NOME"	        		,"SRA","Nome",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"IDADE"	       			,"SRA","Idade",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"TEMPO"	       			,"SRA","Tempo de Serviço",,20)
	//Totalizador                                                                                  

	/*
	TRFunction():New(oSection:Cell("RD_VALOR"),"Despesas da folha","SUM",,,"@E 9,999,999.999.99",,.F.,.T.)  
	TRFunction():New(oSection:Cell("RD_HORAS"),"Horas Totais","SUM",,,"@E 9,999,999,999.99",,.F.,.T.) 

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

	oSection:BeginQuery()



	BeginSQL Alias cAlias
		%noparser%   


		SELECT RA_FILIAL,RA_MAT,RA_NOME,
		CASE 
		WHEN 
		MONTH(GETDATE()) > MONTH(RA_NASC)
		OR
		(
		MONTH(GETDATE()) = MONTH(RA_NASC) 
		AND DAY(GETDATE()) >= DAY(RA_NASC) 
		)
		THEN DATEDIFF(YEAR, RA_NASC, GETDATE()) 
		ELSE DATEDIFF(YEAR, RA_NASC, GETDATE()) -1 END AS IDADE,
		CASE 
		WHEN 
		MONTH(GETDATE()) > MONTH(RA_ADMISSA) 
		OR
		(
		MONTH(GETDATE()) = MONTH(RA_ADMISSA) 
		AND DAY(GETDATE()) >= DAY(RA_ADMISSA) 
		)
		THEN DATEDIFF(YEAR, RA_ADMISSA, GETDATE()) 
		ELSE DATEDIFF(YEAR, RA_ADMISSA, GETDATE()) -1 END AS TEMPO
		FROM SRA100

		WHERE RA_DEMISSA = ''
		AND D_E_L_E_T_ = ''
		ORDER BY RA_FILIAL,RA_MAT

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return



Static Function AjustaSX1(cPerg)            

Return