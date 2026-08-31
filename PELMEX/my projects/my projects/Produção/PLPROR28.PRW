#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR28   ºAutor  ³Juevan Silva     				º Data ³  07/11/23 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Rel. de Apontamento                      			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR28()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR28"

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

	oReport := TReport():New(cPerg,"Rel. de Apontamento",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Rel. de Apontamento",{"SC2"},aOrdem) 


    TRCell():New(oSection,"DT_OP"   	     ,"SC2","DT_OP","@!",10)
	TRCell():New(oSection,"OP"		      ,"SC2","PRODUTO","@!",20)
	TRCell():New(oSection,"PRODUTO"		     ,"SC2","COD","@!",15)
    TRCell():New(oSection,"DESCRICAO"		   ,"SB1","DESC","@!",30) 
	TRCell():New(oSection,"QTD_OP"		    ,"SC2","QNT_OP","@@E 999,999,999.999",)
    TRCell():New(oSection,"QTD_APONTADA"	     ,"SC2","APONTAMENTO","@@E 999,999,999.999",)  
	TRCell():New(oSection,"QTD_ENTRADA"			    ,"SZ1","ENTRADA","@@E 999,999,999.999",) 
	TRCell():New(oSection,"DIFERENCA"        ,"SZ1","DIFERENCA","@@E 999,999,999.999",) 
	TRCell():New(oSection,"CLIENTES" 	,"SA1","CLIENTE","@!",20) 
	//TRCell():New(oSection,"HORA"	,"CLC","HORA","@!",10) 
	//TRCell():New(oSection,"CARGA"  			,"SC2","CARGA","@!",12)
	//TRCell():New(oSection,"CLIENTE"     	,"SC2","CLIENTE","@!",30) 
	
    
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("PED_QUANT"),"Total Etiqueta:","SUM",,,"@E 999,999,999.999",,.F.,.T.)

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



SELECT CONVERT(VARCHAR,CAST(C2_EMISSAO AS DATE),103) DT_OP,C2_NUM+C2_ITEM+C2_SEQUEN OP,C2_PRODUTO PRODUTO,B1_DESC DESCRICAO,C2_QUANT QTD_OP,C2_QUJE QTD_APONTADA,CAST(ISNULL(QTD_ENTRADA,0) AS FLOAT)QTD_ENTRADA,C2_QUANT-C2_QUJE DIFERENCA,C2_OBS CLIENTES
FROM SC2100 SC2 (NOLOCK)
INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
LEFT JOIN (SELECT Z1_OP,Z1_PRODUTO,SUM(Z1_QUANT)QTD_ENTRADA
           FROM(
       SELECT Z1_OP,C2_PRODUTO Z1_PRODUTO,CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END Z1_QUANT
           FROM SZ1100 SZ1 (NOLOCK)
       INNER JOIN SC2100 SC2 (NOLOCK) ON Z1_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2.D_E_L_E_T_ = ''
       INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
       WHERE SZ1.D_E_L_E_T_ = ''
       )TB
       GROUP BY Z1_OP,Z1_PRODUTO)SZ1 ON C2_NUM+C2_ITEM+C2_SEQUEN = Z1_OP AND C2_PRODUTO = Z1_PRODUTO
WHERE SC2.D_E_L_E_T_ = ''
AND B1_TIPO IN ('PA','PC')
AND C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND C2_QUANT > C2_QUJE
AND C2_QUANT > ISNULL(QTD_ENTRADA,0)
ORDER BY C2_EMISSAO,C2_NUM


		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Dt Op:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Dt Op:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
