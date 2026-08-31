#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR28    ºAutor  ³WILSON GUEDES	    				º Data ³  10/02/21 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Produto X Componente  aprimorado								        			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR29()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR29"

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

	oReport := TReport():New(cPerg,"Produtos sem estrutura",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      •//Primeira seção
	oSection := TRSection():New(oReport,"Produtos sem estrutura",{"SB1"},aOrdem) 



	TRCell():New(oSection,"PED_NUM"	       	    ,"PED","Pedido",/*Mascara*/,30)  
	TRCell():New(oSection,"PED_PRODUTO"	       	,"PED","Produto",/*Mascara*/,60)  
	TRCell():New(oSection,"PED_DESCRI"	       	,"PED","Descricao",/*Mascara*/,10)

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


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%   

		SELECT PED_NUM,PED_PRODUTO,PED_DESCRI
		FROM PED
		INNER JOIN SB1100 SB1 (NOLOCK) ON PED_PRODUTO = B1_COD AND B1_MSBLQL != '1' AND SB1.D_E_L_E_T_ = ''
		LEFT JOIN SG1100 SG1 (NOLOCK) ON PED_PRODUTO = G1_COD AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG1.D_E_L_E_T_ = ''
		WHERE PED_STATUS != 'C'
		AND B1_TIPO IN ('PA','PC')
		AND G1_COD IS NULL
		GROUP BY PED_NUM,PED_PRODUTO,PED_DESCRI
		ORDER BY PED_NUM,PED_DESCRI
		
		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return



Static Function AjustaSX1(cPerg)            

	/*u_InPutSX1(cPerg,"01",PADR("Armazen De ? ",20)+"","","","mv_ch1","C",2,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Armazen Ate? ",30)+"","","","mv_ch2","C",2,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Op de? ",30)+"","","","mv_ch3","C",6,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Op ate? ",30)+"","","","mv_ch4","C",6,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Emissao De? ",30)+"","","","mv_ch5","D",8,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("Emissão Ate? ",30)+"","","","mv_ch6","D",8,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Produto de? ",30)+"","","","mv_ch7","C",15,0,0,"G","","","","","mv_par07")
	u_InPutSX1(cPerg,"08",PADR("Produto Ate? ",20)+"","","","mv_ch8","C",15,0,0,"G","","","","","mv_par08") 
	u_InPutSX1(cPerg,"09",PADR("Componente De? ",20)+"","","","mv_ch9","C",15,0,0,"G","","","","","mv_par09")
	u_InPutSX1(cPerg,"10",PADR("Componente Até ? ",20)+"","","","mv_ch8","C",15,0,0,"G","","","","","mv_par10") 
	u_InPutSX1(cPerg,"11",PADR("Cento de Custo de   ? ",20)+"","","","mv_ch9","C",4,0,0,"G","","","","","mv_par11")
	u_InPutSX1(cPerg,"12",PADR("Centro de Custo ate? ",20)+"","","","mv_cha","C",4,0,0,"G","","","","","mv_par12")
*/
Return
