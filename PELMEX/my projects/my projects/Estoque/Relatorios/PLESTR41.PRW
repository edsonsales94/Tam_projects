#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLESTR41   ºAutor  ³Juevan Silva   				º Data ³ 22/07/2025º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Novo Picklist por Produção                     		     			 	 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLESTR41()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLESTR41"

	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)

	oReport := ReportDef(cAlias,cPerg)
	oReport:PrintDialog()
Return


Static Function ReportDef(cAlias,cPerg)
	Local oReport
	Local oSection
	Local oFunction1
    Local oBreak
	Local aOrdem  := {"FILIAL"}
   

	oReport := TReport():New(cPerg,"Novo Picklist por Produção",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Novo Picklist por Produção",{"SE2"},aOrdem)
	
    
TRCell():New(oSection,"PED_DTPREVIA"	        ,"PED","PED_DTPREVIA","@!",10)
TRCell():New(oSection,"PED_DTPROPEL"	        ,"PED","PED_DTPROPEL","@!",10)
TRCell():New(oSection,"CODIGO"	        ,"PED","CODIGO","@!",13)
TRCell():New(oSection,"DESCRICAO"	        ,"PED","DESCRICAO","@!",20)
TRCell():New(oSection,"UM"	        ,"PED","UM","@!",3)
TRCell():New(oSection,"QTD_NECESSARIA"	        ,"PED","QTD_NECESSARIA","@E 9,999,999,999.99")
TRCell():New(oSection,"QTD_EMPENHADA"	   	 ,"PED","QTD_EMPENHADA","@E 9,999,999,999.99")
TRCell():New(oSection,"QTD_EMPATUAL"	    ,"PED","TD_EMPATUAL","@E 9,999,999,999.99")
TRCell():New(oSection,"QTD_10"	    ,"PED","QTD_10","@E 9,999,999,999.99")
TRCell():New(oSection,"QTD_01"	    ,"PED","QTD_01","@E 9,999,999,999.99")
TRCell():New(oSection,"SALDO"	    ,"PED","SALDO","@E 9,999,999,999.99") 
TRCell():New(oSection,"SALDO_EMPENHO"	    ,"PED","SALDO_EMPENHO","@E 9,999,999,999.99")

    

//SELECT 'PELMEX' Empresa,E2_NUM,E2_PREFIXO,E2_PARCELA,E2_TIPO,E2_VALOR,E2_VALLIQ,E2_SALDO,
    //CONVERT(VARCHAR,CAST(E2_EMISSAO AS DATE),103)DT_EMISSAO,
    //CONVERT(VARCHAR,CAST(E2_VENCTO AS DATE),103)DT_VENCTO,
    //CASE WHEN E2_BAIXA = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E2_BAIXA AS DATE),103) END DT_BAIXA,
    //E2_FORNECE,E2_LOJA,E2_NOMFOR,
	//E2_NATUREZ,ED_DESCRIC,E2_HIST	

	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	

    //TRFunction():New(oSection:Cell("E2_VALOR"),"Total valor","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("DIFERENCA"),"Diferenca","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

	oReport:SetTotalInLine(.F.)

	//Quebra por Seção
	oSection:SetPageBreak(.T.)
	oSection:SetTotalText(" ")

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)
	//Local oSection2  := oReport:Section(2)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ·
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
	%noparser%   

SELECT PED_DTPREVIA,PED_DTPROPEL,CODIGO,DESCRICAO,UM,SUM(QTD_NECESSARIA)QTD_NECESSARIA,
	   0 QTD_EMPENHADA,
	   0 QTD_EMPATUAL,
       ISNULL(QTD_10,0)QTD_10,ISNULL(QTD_01,0)QTD_01,
	   ISNULL(QTD_01,0)+ISNULL(QTD_10,0)-SUM(ISNULL(QTD_NECESSARIA,0))SALDO,
	   ISNULL(QTD_01,0)+ISNULL(QTD_10,0)- 0 SALDO_EMPENHO
FROM(
SELECT PED_DTPREVIA,PED_DTPROPEL,TB.G1_COMP CODIGO,TB.B1_DESC DESCRICAO,TB.B1_UM UM,
       SUM(QTD_NECESSARIA)QTD_NECESSARIA,QTD_10,QTD_01
FROM( 
SELECT PED_DTPREVIA,PED_DTPROPEL,PED_SETOR,PED_NUM,PED_OP,PED_PRODUTO,PED_DESCRI,G1_TRT,G1_COMP,SB1.B1_DESC,SB1.B1_UM,PED_QUANT, 
        G1_QUANT,PED_QUANT*(G1_QUANT+(G1_QUANT*G1_PERDA/100)) QTD_NECESSARIA 
FROM PED 
INNER JOIN SG1100 SG1 ON PED_PRODUTO = G1_COD AND SG1.D_E_L_E_T_ = '' AND SG1.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) 
INNER JOIN SB1100 SB1 ON G1_COMP = B1_COD AND SB1.D_E_L_E_T_ = '' 
WHERE G1_COMP NOT LIKE 'MOD%' 
AND CONVERT(VARCHAR,CAST(PED_DTPREVIA AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
)TB 
LEFT JOIN (SELECT B2_COD,B2_LOCAL,B2_QATU QTD_01
           FROM SB2100 SB2 (NOLOCK) 
		   WHERE SB2.D_E_L_E_T_ = ''
		   AND B2_FILIAL = '01' 
		   AND B2_LOCAL = '01')SB2 ON G1_COMP = SB2.B2_COD
LEFT JOIN (SELECT B2_COD,B2_LOCAL,B2_QATU QTD_10
           FROM SB2100 SB2 (NOLOCK) 
		   WHERE SB2.D_E_L_E_T_ = ''
		   AND B2_FILIAL = '01' 
		   AND B2_LOCAL = '10')SB21 ON G1_COMP = SB21.B2_COD
GROUP BY PED_DTPREVIA,PED_DTPROPEL,TB.G1_COMP,TB.B1_DESC,TB.B1_UM,QTD_10,QTD_01
)TB2
WHERE DESCRICAO NOT LIKE '%BLOD%'
AND DESCRICAO NOT LIKE '%BLOCO%'
AND DESCRICAO NOT LIKE 'SUPO%ELAS'
AND DESCRICAO NOT LIKE '%AGLO%'
GROUP BY PED_DTPREVIA,PED_DTPROPEL,CODIGO,DESCRICAO,UM,QTD_10,QTD_01
ORDER BY DESCRICAO,CONVERT(VARCHAR,CAST(PED_DTPREVIA AS DATE),112),CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112)

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De Producao "    ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Ate Data Producao "    ,20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
//u_InPutSX1(cPerg,"03",PADR("De Empenho ",20)+"?","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03")
//u_InPutSX1(cPerg,"04",PADR("Ate ata Empenho ",20)+"?","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")
//u_InPutSX1(cPerg,"05",PADR("De Cliente ",20)+"?","","","mv_ch5","C",30,0,0,"G","","","","","mv_par05")
//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"     ,20)+"?","","","mv_ch6","C",30,0,0,"G","","","","","mv_par06") 
//u_InPutSX1(cPerg,"04",PADR("Ate Dt Baixa"    ,20)+"?","","","mv_ch4","D",15,0,0,"G","","","","","mv_par04")
//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
