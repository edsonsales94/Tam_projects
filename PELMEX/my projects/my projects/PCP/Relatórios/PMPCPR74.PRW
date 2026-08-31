#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR74    ºAutor  ³Wylliam Silva     				º Data ³  02/05/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  INSUMOS INSUFICIENTES PARA APONTAMENTO DE OP  				  			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR74()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR74"

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

	oReport := TReport():New(cPerg,"INSUMOS INSUFICIENTES PARA APONTAMENTO DE OP",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"INSUMOS INSUFICIENTES PARA APONTAMENTO DE OP",{"SC2"},aOrdem)  
	
	TRCell():New(oSection,"DT_OP"	  		,"SC2","DATA OP","@!",10)
	TRCell():New(oSection,"OP"	      		,"SC2","ORDEM PROD","@!",8)
	TRCell():New(oSection,"PRODUTO"	        ,"SC2","PRODUTO","@!",15)   
	TRCell():New(oSection,"DESCRIPA"	    ,"SC2","DESCRICAO","@!",30)         
	TRCell():New(oSection,"QTD_OP"  	    ,"SC2","QTD OP","@E 999,999,999,999",) 
	TRCell():New(oSection,"QTD_APONTADA"   	,"SC2","QTD APONTADA","@E 999,999,999,999",)
	TRCell():New(oSection,"QTD_ENTRADA"     ,"SZ1","QTD_ENTRADA","@E 999,999,999,999",)
	TRCell():New(oSection,"A_APONTAR"   	,"SC2","A APONTAR","@E 999,999,999,999",)
	TRCell():New(oSection,"PI"	       		,"SG1","PI","@!",15)
	TRCell():New(oSection,"DESCPI"	 		,"SB1","DESCRICAO PI","@!",30)
	TRCell():New(oSection,"UMPI"	 		,"SB1","UM PI","@!",3)
	TRCell():New(oSection,"QTD_ESTRUTURA"	,"SG1","QTD ESTRUTURA","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_SOLICITADA"	,"SG1","QTD_SOLICITADA","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_10"			,"SB2","QTD_10","@E 999,999,999.999",)
	
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

		
SELECT DT_OP,OP,PRODUTO,DESCRIPA,SUM(QTD_OP)QTD_OP,SUM(QTD_APONTADA)QTD_APONTADA,QTD_ENTRADA,A_APONTAR,PI,DESCPI,UMPI,QTD_ESTRUTURA,QTD_SOLICITADA,QTD_10
FROM(
SELECT CONVERT(VARCHAR,CAST(C2_EMISSAO AS DATE),103)DT_OP,C2_NUM OP,C2_PRODUTO PRODUTO,SB1.B1_DESC DESCRIPA,C2_QUANT QTD_OP,C2_QUJE QTD_APONTADA,ISNULL(Z1_QUANT/2,0)QTD_ENTRADA,C2_QUANT-C2_QUJE A_APONTAR,
G1_COMP PI,SB12.B1_DESC DESCPI,SB12.B1_UM UMPI,G1_QUANT QTD_ESTRUTURA,(C2_QUANT-C2_QUJE)*(G1_QUANT+(G1_QUANT*(G1_PERDA+0.2632))/100) QTD_SOLICITADA,B2_QATU QTD_10
     
FROM SC2100 SC2 (NOLOCK)
INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
INNER JOIN SG1100 SG1 (NOLOCK) ON C2_PRODUTO = G1_COD AND SG1.D_E_L_E_T_ = '' AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND G1_COMP NOT LIKE 'MOD%'
INNER JOIN SB1100 SB12 (NOLOCK) ON G1_COMP = SB12.B1_COD AND SB12.D_E_L_E_T_ = ''
LEFT JOIN SB2100 SB2 (NOLOCK) ON G1_COMP = B2_COD AND B2_FILIAL = '01' AND B2_LOCAL = '10' AND SB2.D_E_L_E_T_ = ''
LEFT JOIN (SELECT SUBSTRING(Z1_OP,1,6)Z1_OP,COUNT(*)Z1_QUANT
		    FROM SZ1100 SZ1 (NOLOCK)
		WHERE SZ1.D_E_L_E_T_ = ''
		GROUP BY SUBSTRING(Z1_OP,1,6))SZ1 ON C2_NUM = SUBSTRING(Z1_OP,1,6)
WHERE SC2.D_E_L_E_T_ = ''

AND C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%

AND C2_QUJE < Z1_QUANT
)TB
WHERE QTD_SOLICITADA > QTD_10

GROUP BY DT_OP,OP,PRODUTO,DESCRIPA,QTD_ENTRADA,A_APONTAR,PI,DESCPI,UMPI,QTD_ESTRUTURA,QTD_SOLICITADA,QTD_10

ORDER BY PI

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt Emissão:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Dt Emissão:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Pedido:",20)+"?","","","mv_ch3","C",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	

Return
