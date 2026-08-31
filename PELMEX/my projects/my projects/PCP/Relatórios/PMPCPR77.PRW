#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR77    ºAutor  ³Wylliam Silva     				º Data ³  29/05/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Rel. Reabertura de Ordem			                 		  			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR77()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR77"

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

	oReport := TReport():New(cPerg,"Relatório de Reabertura de ordem",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Relatório de Reabertura de ordem",{"SC2"},aOrdem)  
	
	TRCell():New(oSection,"APAGADA"   	 	,"SC2","APAGADA","@!",2)
	TRCell():New(oSection,"DTEMISSAO"    	,"SC2","EMISSAO","@!",10)
	TRCell():New(oSection,"DTPELMEX"    	,"PK2","DTPELMEX","@!",10)
	TRCell():New(oSection,"ORDEM"	 	 	,"SC2","ORDEM","@!",8)
	TRCell():New(oSection,"ITEM"	 	 	,"SC2","ITEM","@!",4)
	TRCell():New(oSection,"PRODUTO"	 	 	,"SC2","PRODUTO","@!",15)
	TRCell():New(oSection,"QUANT"	 	 	,"SC2","QTD_OP","@E 999,999.999",)
	TRCell():New(oSection,"APONTADO"	 	,"SC2","QTD_APONT","@E 999,999.999",)
	TRCell():New(oSection,"NOME"	 		,"SC2","CLIENTE","@!",30)
	TRCell():New(oSection,"CARGA"	 		,"SC2","CARGA","@!",12)
	TRCell():New(oSection,"B1_XSETOR"	 	,"SB1","SETOR","@!",20)
	
	/*TRCell():New(oSection,"C6_FILIAL"	  	,"SC2","FILIAL","@!",2)
	TRCell():New(oSection,"C6_QUANT"    	,"SC6","QUANTIDADE","@E 999,999,999,999",) 
	TRCell():New(oSection,"C6_PRCVEN"    	,"SC6","PREÇO VEND","@E 999,999,999.999",)
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("ETIQUETA"),"Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)*/

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
		
		SELECT SC2.D_E_L_E_T_ APAGADA,CONVERT(VARCHAR,CAST(C2_EMISSAO AS DATE),103) DTEMISSAO,PK2_DTPROPEL DTPELMEX,C2_NUM ORDEM,C2_PRODUTO PRODUTO,C2_QUANT QUANT,C2_QUJE APONTADO,C2_OBS NOME,
				C2_XCARGA CARGA,B1_XSETOR,C2_ITEM ITEM
			FROM SC2100 SC2
			INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
			LEFT JOIN PK2 (NOLOCK) ON PK2_OP = C2_NUM AND PK2_STATUS != 'C' 
			WHERE C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
			AND B1_TIPO IN ('PA','PC')    
			AND C2_QUANT > C2_QUJE
			ORDER BY C2_EMISSAO
		

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De DT Producao:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate DT Producao:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Pedido:",20)+"?","","","mv_ch3","C",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	

Return
