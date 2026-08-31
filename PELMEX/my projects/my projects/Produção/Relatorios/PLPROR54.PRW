#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR54  ºAutor  ³Stan Lee    				º Data ³  28/10/24 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   EMPENHO OPS X SALDO ARMAZEM                     			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR54()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR54"

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

	oReport := TReport():New(cPerg,"EMPENHO OPS X SALDO ARMAZEM",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"EMPENHO OPS X SALDO ARMAZEM",{"SD4"},aOrdem) 

    TRCell():New(oSection,"CODIGO"   	    ,"SD4","Codigo","@!",20)
	TRCell():New(oSection,"DESCPI"		    ,"SD4","Descricao","@!",120)
	TRCell():New(oSection,"UM"		        ,"SD4","UM","@!",10)
    TRCell():New(oSection,"QTD_EMPENHO"		,"SD4","Qtd. Empenho","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_01"		    ,"SD4","Qtd. 01","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_10"		    ,"SD4","Qtd. 10","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_SALDO"		,"SD4","Saldo","@E 999,999,999.999",)
	TRCell():New(oSection,"DIFERENCA"		,"SD4","Diferenca","@E 999,999,999.999",)
	//TRCell():New(oSection,"CTT_DESC01"		  ,"CTT","Centrousto","@!",20)		
    //TRCell():New(oSection,"R8_TIPOAFA"	      ,"SR8","R8_TIPOAFA","@!",4) 
	//TRCell():New(oSection,"DESCRICAO"  	     ,"SRA","DESCRICAO","@!",40)
	//TRCell():New(oSection,"R8_CID"		 ,"SR8","R8_CID","@!",3)
	//TRCell():New(oSection,"DIAS"  			,"SRA","DIAS","@!",3)
    //TRCell():New(oSection,"R8_OBSAFAS"  	,"SR8","R8_OBSAFAS","@!",100)
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

SELECT D4_COD CODIGO,DESCPI,UM,SUM(D4_QUANT)QTD_EMPENHO,ISNULL(QTD_01,0)QTD_01,ISNULL(QTD_10,0)QTD_10,ISNULL(QTD_01,0)+ISNULL(QTD_10,0)QTD_SALDO,(ISNULL(QTD_01,0)+ISNULL(QTD_10,0))-SUM(D4_QUANT) DIFERENCA
FROM(
SELECT D4_OP,D4_PRODUTO,SB1.B1_DESC DESCPA,D4_TRT,D4_COD, SB12.B1_DESC DESCPI, SB12.B1_UM UM,D4_QUANT,QTD_01,QTD_10
FROM SD4100 SD4 (NOLOCK)
INNER JOIN SB1100 SB1 (NOLOCK) ON D4_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB12 (NOLOCK) ON D4_COD = SB12.B1_COD AND SB12.D_E_L_E_T_ = ''
LEFT JOIN (SELECT B2_COD,B2_QATU QTD_01
           FROM SB2100 SB2 (NOLOCK)
		   WHERE SB2.D_E_L_E_T_ = ''
		   AND B2_FILIAL = '01'
		   AND B2_LOCAL = '01'
		   )SB201 ON D4_COD = SB201.B2_COD
LEFT JOIN (SELECT B2_COD,B2_QATU QTD_10
           FROM SB2100 SB2 (NOLOCK)
		   WHERE SB2.D_E_L_E_T_ = ''
		   AND B2_FILIAL = '01'
		   AND B2_LOCAL = '10'
		   )SB210 ON D4_COD = SB210.B2_COD
WHERE SD4.D_E_L_E_T_ = ''
AND D4_DATA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND D4_COD NOT LIKE 'MOD%'
AND D4_QUANT > 0
AND (ISNULL(QTD_01,0)+ISNULL(QTD_10,0)) < D4_QUANT
)TB
GROUP BY D4_COD,DESCPI,UM,QTD_01,QTD_10
ORDER BY DESCPI

		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

    u_InPutSX1(cPerg,"01",PADR("Dt.Emprenho de:" ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Dt.Emprenho ate:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par04")
	
	
	
	
Return
