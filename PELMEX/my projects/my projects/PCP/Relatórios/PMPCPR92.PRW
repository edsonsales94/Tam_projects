#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR92   บAutor  ณJuevan Carvalho da Silva   				บ Data ณ  04/02/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   	Pedidos x Insumos Amazon                      			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR92()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR92"

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

	oReport := TReport():New(cPerg,"Pedidos x Insumos Amazon",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Pedidos x Insumos Amazon",{"SG1"},aOrdem) 

 
    TRCell():New(oSection,"EMPRESA"        ,"SB1","EMPRESA","@!",20)
	TRCell():New(oSection,"CODIGO"		       ,"SB1","COD","@!",10)
	TRCell():New(oSection,"DESCRICAO"		    ,"SB1","DESC","@!",30) 
	TRCell():New(oSection,"UM"	    ,"SB1","UM","@!",3)   
	TRCell():New(oSection,"QTD_EMPENHADA"	,"SD4","EMPENHADO","@E 999,999,999,999.99",)
    TRCell():New(oSection,"QTD_ESTOQUE"	    ,"SB2","ESTOQUE","@E 999,999,999,999.99",)
    TRCell():New(oSection,"SALDO"	    ,"SB2","SALDO","@E 999,999,999,999.99",)
    //TRCell():New(oSection,"DESCOMP"	        ,"SB1","DESCOMP","@!",30)
	//TRCell():New(oSection,"UMCOMP"	        ,"SB1","UMCOMP","@!",3)
	//TRCell():New(oSection,"QTD_EMPENHADA"    ,"SD4","QTD_EMPENHADA","@E 999,999,999,999.99",)
    //TRCell():New(oSection,"QTD_ESTRUTURA"    ,"SG1","QTDESTRUTURA","@E 999,999,999,999.99",)
	/*TRCell():New(oSection,"PENDENTE"	    ,"SC2","PENDENTE","@E 999,999,999,999.99",)      
	TRCell():New(oSection,"QTD_PRODUZIDA"  	,"CLA","QTD_PRODUZIDA","@E 999,999,999,999.99",)
	TRCell():New(oSection,"QTD_ENTRADA"	    ,"SZ1","QTD_ENTRADA","@E 999,999,999.999.99",)
	TRCell():New(oSection,"QTD_SAIDA"       ,"SAI","QTD_SAIDA","@E 999,999,999.999.99",)
	TRCell():New(oSection,"CARGA" 	        ,"SC2","CARGA","@!",15) 
	TRCell():New(oSection,"CLIENTE"	        ,"SC2","CLIENTE","@!",30) 
	TRCell():New(oSection,"SETOR"  			,"SB1","SETOR","@!",12)*/
	 
	
    
	
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
SELECT 'AMAZON' EMPRESA,CODIGO,DESCRICAO,UM,QTD_EMPENHADA,SUM(ISNULL(QTD_ESTOQUE,0))QTD_ESTOQUE,SUM(ISNULL(QTD_ESTOQUE,0))-QTD_EMPENHADA SALDO
FROM(
SELECT CODIGO,B1_DESC DESCRICAO,B1_UM UM,SUM(CAST(QTD_EMPENHADA AS NUMERIC(10,5)))QTD_EMPENHADA,
       CASE WHEN B2_QATU-B2_QEMP < 0 THEN 0 ELSE B2_QATU-B2_QEMP END QTD_ESTOQUE
FROM(
SELECT C6_PRODUTO,SG1.G1_COMP PI,SG12.G1_COMP CODIGO,SB1.B1_DESC,SB1.B1_UM,SG12.G1_QUANT,
       CASE WHEN SB12.B1_QB > 0 THEN C6_QTDVEN*(SG12.G1_QUANT/SB12.B1_QB) ELSE C6_QTDVEN*SG12.G1_QUANT END QTD_EMPENHADA
FROM SC5200 SC5 (NOLOCK)
INNER JOIN SC6200 SC6 (NOLOCK) ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.D_E_L_E_T_ = ''
INNER JOIN SG1200 SG1 (NOLOCK) ON C6_PRODUTO = SG1.G1_COD AND SG1.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG1.D_E_L_E_T_ = '' AND SG1.G1_COMP NOT LIKE 'MOD%'
INNER JOIN SG1200 SG12 (NOLOCK) ON SG1.G1_COMP = SG12.G1_COD AND SG12.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG12.D_E_L_E_T_ = '' AND SG12.G1_COMP NOT LIKE 'MOD%'
INNER JOIN SB1200 SB1 (NOLOCK) ON SG12.G1_COMP = SB1.B1_COD AND SB1.D_E_L_E_T_ = '' AND SB1.B1_MSBLQL != '1'
INNER JOIN SB1200 SB12 (NOLOCK) ON SG1.G1_COMP = SB12.B1_COD AND SB1.D_E_L_E_T_ = '' AND SB12.B1_MSBLQL != '1'
WHERE SC5.D_E_L_E_T_ = ''
AND C5_FILIAL = '01'
AND C6_TES NOT IN ('709','915','917')
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%NAO PRODUZIR%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%NรO PRODUZIR%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE 'DEVOLUCAO%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE 'DEV%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REF%DEV%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%INVENT%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSFERENCIA%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSF%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REFATURAMENTO%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TESTE%'
AND C6_NOTA = ''
AND C6_NUM BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND C6_ENTREG BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND C5_EMISSAO BETWEEN  %Exp:MV_PAR05% AND %Exp:MV_PAR06%
UNION
SELECT C6_PRODUTO,SG1.G1_COMP PI,SG1.G1_COMP CODIGO,SB1.B1_DESC,SB1.B1_UM,SG1.G1_QUANT,C6_QTDVEN*SG1.G1_QUANT QTD_EMPENHADA
FROM SC5200 SC5 (NOLOCK)
INNER JOIN SC6200 SC6 (NOLOCK) ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.D_E_L_E_T_ = ''
INNER JOIN SG1200 SG1 (NOLOCK) ON C6_PRODUTO = SG1.G1_COD AND SG1.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG1.D_E_L_E_T_ = '' AND SG1.G1_COMP NOT LIKE 'MOD%'
INNER JOIN SB1200 SB1 (NOLOCK) ON SG1.G1_COMP = SB1.B1_COD AND SB1.D_E_L_E_T_ = '' AND SB1.B1_MSBLQL != '1'
WHERE SC5.D_E_L_E_T_ = ''
AND C5_FILIAL = '01'
AND C6_TES NOT IN ('709','915','917')
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%NAO PRODUZIR%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%NรO PRODUZIR%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE 'DEVOLUCAO%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE 'DEV%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REF%DEV%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%INVENT%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSFERENCIA%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSF%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REFATURAMENTO%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TESTE%'
AND C6_NOTA = ''
AND C6_DESCRI LIKE 'SUP%'
AND C6_NUM BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND C6_ENTREG BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND C5_EMISSAO BETWEEN  %Exp:MV_PAR05% AND %Exp:MV_PAR06%
)TB
LEFT JOIN SB2200 SB2 (NOLOCK) ON CODIGO = B2_COD AND SB2.B2_LOCAL IN ('01') AND SB2.B2_FILIAL = '01' AND SB2.D_E_L_E_T_  = ''
GROUP BY CODIGO,B1_DESC,B1_UM,B2_QATU,B2_QEMP
)TB1
GROUP BY CODIGO,DESCRICAO,UM,QTD_EMPENHADA
ORDER BY 1,DESCRICAO
EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)


    u_InPutSX1(cPerg,"01",PADR("De Pedido "     ,20)+"?","","","mv_ch1","C",8,0,0,"G","","","","","mv_par01") 
    u_InPutSX1(cPerg,"02",PADR("Ate Pedido "    ,20)+"?","","","mv_ch2","C",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Entrega"     ,20)+"?","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03") 
    u_InPutSX1(cPerg,"04",PADR("Ate Entrega"    ,20)+"?","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De Emissao:",20)+"?","","","mv_ch5","D",10,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Ate Emissao:",20)+"?","","","mv_ch6","D",10,0,0,"G","","","","","mv_par06")
	
	
	
	
Return
