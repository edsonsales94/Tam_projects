#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLCOMR12    ºAutor  ³Juevan Silva     				º Data ³  01/08/24 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pedidos de Compra em Aberto		  		                     	 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLCOMR12()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLCOMR12"

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

	oReport := TReport():New(cPerg,"Pedidos de Compra em Aberto",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Pedidos de Compra em Aberto",{"SB1"},aOrdem)  
	
	
	TRCell():New(oSection,"EMPRESA"	  		,"SC7","EMPRESA","@!",6)
	TRCell():New(oSection,"C7_FILIAL"	   	,"SC7","FILIAL","@!",2)
	TRCell():New(oSection,"DT_EMISSAO"	   	,"SC7","EMISSAO","@!",10)
	TRCell():New(oSection,"C7_NUM"	   		,"SC7","PEDIDO","@!",6)   
	TRCell():New(oSection,"C7_ITEM"		    ,"SC7","ITEM","@!",4)         
	TRCell():New(oSection,"C7_PRODUTO"	   	,"SC7","PRODUTO","@!",8)
	TRCell():New(oSection,"C7_DESCRI"	   	,"SC7","DESCRI","@!",2)
	TRCell():New(oSection,"D3_QUANT"  		,"SC7","D3_QUANT","@E 999,999,999.999")
	TRCell():New(oSection,"C7_QUJE"  			,"C7_QUJE","SALDO TOTAL","@E 999,999,999.999")
    TRCell():New(oSection,"C7_FORNECE"	   	,"SC7","FORNECEDOR","@!",6)
    TRCell():New(oSection,"C7_NOME"	   	,"SC7","C7_NOME","@!",30)
    TRCell():New(oSection,"C7_MUNICIPIO"	   	,"SC7","C7_MUNICIPIO","@!",20)

	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("ETIQUETA"),"Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"
	//endif      

//inicia o Sql
	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%

	
SELECT 'AMAZON' EMPRESA,C7_FILIAL,CONVERT(VARCHAR,CAST(C7_EMISSAO AS DATE),103)DT_EMISSAO,C7_NUM,C7_ITEM,C7_PRODUTO,C7_DESCRI,C7_QUANT,C7_QUJE,C7_FORNECE,C7_LOJA,A2_NOME,A2_MUN
FROM SC7200 SC7
INNER JOIN SA2200 SA2 ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA AND A2_MSBLQL != '1' AND SA2.D_E_L_E_T_ = ''
WHERE SC7.D_E_L_E_T_ = ''
AND C7_QUANT > C7_QUJE
AND C7_RESIDUO = ''
AND CONVERT(VARCHAR,CAST(C7_EMISSAO AS DATE),112) BETWEEN '20240431' AND '20240801'
UNION
SELECT 'PELMEX' EMPRESA,C7_FILIAL,CONVERT(VARCHAR,CAST(C7_EMISSAO AS DATE),103)DT_EMISSAO,C7_NUM,C7_ITEM,C7_PRODUTO,C7_DESCRI,C7_QUANT,C7_QUJE,C7_FORNECE,C7_LOJA,A2_NOME,A2_MUN
FROM SC7100 SC7
INNER JOIN SA2100 SA2 ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA AND A2_MSBLQL != '1' AND SA2.D_E_L_E_T_ = ''
WHERE SC7.D_E_L_E_T_ = ''
AND C7_QUANT > C7_QUJE
AND C7_RESIDUO = ''
AND C7_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%

ORDER BY 1,2,C7_NUM,C7_ITEM
				
	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Emissao:" ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") // Inicio de Data
	u_InPutSX1(cPerg,"02",PADR("Ate Emissao:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02") // Fim de Data
	//u_InPutSX1(cPerg,"03",PADR("Periodo :"   ,20)+"?","","","mv_ch3","C",2,0,0,"G","","","","","mv_par03")   
	//u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	

Return
