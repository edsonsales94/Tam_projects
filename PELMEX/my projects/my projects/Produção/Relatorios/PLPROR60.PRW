#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR60   ºAutor  ³kLEDSON OLIVEIRA    				º Data ³  18/04/23 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   ERRO PLANO BORDADEIRA                        			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR60()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR60"

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

	oReport := TReport():New(cPerg,"ERRO PLANO BORDADEIRA",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"ERRO PLANO BORDADEIRA",{"SZ4"},aOrdem) 

	TRCell():New(oSection,"C2_EMISSAO"		    ,"SC5","DT_PELMEX","@!",20)
	TRCell():New(oSection,"C2_PRODUTO"	    ,"SC6","COD","@!",15)
	TRCell():New(oSection,"DESCPA"		    ,"SC5","DESC PA","@!",30)
	TRCell():New(oSection,"D4_COD"	    ,"SC6","MAT PRIMA","@!",15)
	TRCell():New(oSection,"DESCPI"	    ,"SC6","DESC PI","@!",30)
	TRCell():New(oSection,"UM"	    ,"SC6","UM","@!",2)
	TRCell():New(oSection,"D4_TRT"	    ,"SC6","SEQ ESTRUT","@!",3)
	TRCell():New(oSection,"C2_QUANT"	    ,"SC6","QTD OP","@E 999,999,999.999")
	TRCell():New(oSection,"G1_QUANT"	    ,"SC6","QTD ESTRUT","@E 999,999,999.999")
	TRCell():New(oSection,"D4_QTDEORI"	    ,"SC6","QTD EMPENHO","@E 999,999,999.999")
	TRCell():New(oSection,"G1_XDIMENS"	    ,"SC6","DIMENS","@!",13)
	TRCell():New(oSection,"G1_XMAQBOR"	    ,"SC6","MAQBORD","@!",3)
	TRCell():New(oSection,"G1_XNBORD"	    ,"SC6","N BORDADO","@!",3)
	TRCell():New(oSection,"LARG"	    ,"SC6","LARGURA","@!",5)
	TRCell():New(oSection,"G1_XDENSID"	    ,"SC6","DENSIDADE","@!",30)
	TRCell():New(oSection,"G1_XTECINV"	    ,"SC6","TECID INVERT","@!",1)
	TRCell():New(oSection,"G1_XESPESS"	    ,"SC6","ESPESSURA","@!",5)



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

SELECT C2_EMISSAO,
		C2_PRODUTO,
		SB1.B1_DESC DESCPA,
		D4_COD,
		SB12.B1_DESC DESCPI,
		SB12.B1_UM UM,
		D4_TRT,
		C2_QUANT,
		G1_QUANT,
		D4_QTDEORI,
		G1_XDIMENS,
		G1_XMAQBOR,
		G1_XNBORD,
		SB12.B1_XLARGUR LARG,
		G1_XDENSID,
		G1_XTECINV,
		G1_XESPESS
FROM SC2100 SC2 (NOLOCK)
INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
INNER JOIN SG1100 SG1 (NOLOCK) ON G1_COD = C2_PRODUTO AND G1_COMP NOT LIKE 'MOD%' AND SG1.D_E_L_E_T_ = ''
LEFT JOIN SD4100 SD4 (NOLOCK) ON C2_NUM+C2_ITEM+C2_SEQUEN = D4_OP AND G1_COMP = D4_COD AND G1_TRT = D4_TRT AND SD4.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB12 (NOLOCK) ON D4_COD = SB12.B1_COD AND SB12.D_E_L_E_T_ = ''
WHERE SC2.D_E_L_E_T_ = ''
AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112)
AND C2_EMISSAO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
AND SUBSTRING(D4_TRT,1,2) IN ('CP','FX','AN','PI')
AND (SB12.B1_DESC LIKE 'ART%TEC%'
OR SB12.B1_DESC LIKE 'ART%ANT%')


		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("Dt Pelmex de:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Dt Pelmex Ate:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
