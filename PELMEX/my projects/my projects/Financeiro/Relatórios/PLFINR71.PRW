#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR71    บAutor  ณKledson Oliveira    				บ Data ณ 21/01/2025บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Relacao de Baixas (Personalizado)               		     			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR71()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR71"

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
   

	oReport := TReport():New(cPerg,"Relacao de Baixas (Personalizado) ",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Relacao de Baixas (Personalizado) ",{"SE2"},aOrdem)
	


    TRCell():New(oSection,"EMPRESA"	    ,"SE5","Empresa","@!",6)
    TRCell():New(oSection,"CONTAS"	     ,"SE5","Tipo","@!",10)
    TRCell():New(oSection,"PREFIXO"	    ,"SE5","Prf","@!",4)
	TRCell():New(oSection,"NUM"	        ,"SE5","Numero","@!",12)
	TRCell():New(oSection,"PARC"	     ,"SE5","Parcela","@!",4)
	TRCell():New(oSection,"TIPO"	     ,"SE5","Tipo","@!",3)  	     	   
	TRCell():New(oSection,"CLI_FOR"	     ,"SE5","Cli/For","@!",7)
	TRCell():New(oSection,"NOME_CLIFOR"	   	  ,"SE5","NomeCli/For","@!",30) 
	TRCell():New(oSection,"NATUREZ"	     ,"SE5","Natureza","@!",10) 
	TRCell():New(oSection,"DESC_NAT"	     ,"SE5","Desc Nat","@!",30) 
	TRCell():New(oSection,"EMISSA"	     ,"SE5","Dt. Emissao","@!",11)
	TRCell():New(oSection,"VCTO"	     ,"SE5","Dt. Vencimento","@!",11)
    TRCell():New(oSection,"HISTO"	     ,"SE5","Historico","@!",30)
    TRCell():New(oSection,"HIS_BAIXA"	     ,"SE5","Historico Baixa","@!",30)
    TRCell():New(oSection,"DT_MOV"	     ,"SE5","Dt. Movimentacao","@!",11)
    TRCell():New(oSection,"DT_BAIXA"	     ,"SE5","Dt. Baixa","@!",11)
	TRCell():New(oSection,"VLR"	     ,"SE2","Valor","@E 9,999,999,999.99",)	
	TRCell():New(oSection,"ACRESC"	     ,"SE2","Acrescimo","@E 9,999,999,999.99",)	
	TRCell():New(oSection,"VALJU"	     ,"SE2","Juros","@E 9,999,999,999.99",)	
	TRCell():New(oSection,"VLR_MULTA"	     ,"SE2","Multa","@E 9,999,999,999.99",)	
	TRCell():New(oSection,"DESCONTO"	     ,"SE2","Desconto","@E 9,999,999,999.99",)	
	TRCell():New(oSection,"TOTAL_BAIXADO"	     ,"SE2","Total Baixado","@E 9,999,999,999.99",)	
	TRCell():New(oSection,"BANCO"	     ,"SE2","Banco.","@!",5) 	 
    TRCell():New(oSection,"DT_DIGIT"	     ,"SE2","DT. Digitacao","@!",11)
    TRCell():New(oSection,"MOT"	   	  ,"SE2","Motivo.","@!",4)
    TRCell():New(oSection,"ORIG"	   	  ,"SE2","Fil Origem","@!",2)
    //TRCell():New(oSection,"VLR_BAIXA"	     ,"SE2","Vlr Baixa","@E 9,999,999,999.99",)
	//TRCell():New(oSection,"FORNECEDOR"	   	  ,"SE2","CodFornec","@!",7)
//	TRCell():New(oSection,"NOME_CLIFOR"	   	  ,"SE5","NomeCli/For","@!",20)
	//TRCell():New(oSection,"RSOCIAL"	   	  ,"SA2","Razao Social","@!",30)
	//TRCell():New(oSection,"HISTORICO"	   	  ,"SE2","Historico","@!",40)
	//TRCell():New(oSection,"ED_DESCRIC"	    	,"SED","Desc.Natureza","@!",30)
	//TRCell():New(oSection,"E1_EMISSAO"	     ,"SE1","EMISSAO","@!",10) 

    //TRCell():New(oSection,"D1_DOC"	   	      ,"SD1","NOTA","@!",10)
	//TRCell():New(oSection,"D1_SERIE"       ,"SD1","SERIE","@!",3)
	//TRCell():New(oSection,"D1_EMISSAO"	    	,"SD1","EMISDEV","@!",10)
    //TRCell():New(oSection,"E1_CLIENTE"	    	,"SE1","CLIENTE","@!",6)
    //TRCell():New(oSection,"E1_NOMCLI"	    	,"SE1","NOME","@!",30)
    //TRCell():New(oSection,"E1_VEND1"	    	,"SE1","CODVEND","@!",6)
    //TRCell():New(oSection,"A3_NOME"	    	,"SA3","NOMVEND","@!",30)
   
    
    

	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	

    //TRFunction():New(oSection:Cell("TOTAL"),"Total Geral","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("DIFERENCA"),"Diferenca","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

	oReport:SetTotalInLine(.F.)

	//Quebra por Se็ใo
	oSection:SetPageBreak(.T.)
	oSection:SetTotalText(" ")

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)
	//Local oSection2  := oReport:Section(2)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ท
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
	%noparser%   

SELECT EMPRESA, CONTAS, PREFIXO, NUM, PARC, TIPO, CLI_FOR, NOME_CLIFOR,NATUREZ,  DESC_NAT, 
CONVERT(VARCHAR, CAST(EMISSA AS DATE), 103)EMISSA, 
CONVERT(VARCHAR, CAST(VCTO AS DATE), 103)VCTO, 
HISTO, HIS_BAIXA, 
CONVERT(VARCHAR, CAST(DT_BAIXA AS DATE),103)DT_BAIXA,
CONVERT(VARCHAR, CAST(DT_MOV AS DATE), 103)DT_MOV,
VLR, ACRESC, VALJU, VLR_MULTA, DESCONTO, VALOR TOTAL_BAIXADO, BANCO, 
CONVERT(VARCHAR, CAST(DT_DIGIT AS DATE),103)DT_DIGIT, 
MOT, FILIAL ORIG
FROM (


SELECT *
FROM (
SELECT 'PELMEX' EMPRESA, '1 - A RECEBER' CONTAS, 
E5_PREFIXO PREFIXO, 
E5_NUMERO NUM, 
E5_PARCELA PARC, 
E5_TIPO TIPO, 
E5_CLIFOR CLI_FOR, 
A1_NOME NOME_CLIFOR,
E5_NATUREZ NATUREZ, 
ED_DESCRIC DESC_NAT, 
E1_EMISSAO EMISSA, 
E1_VENCREA VCTO, 
E1_HIST HISTO, 
E5_HISTOR HIS_BAIXA,
E1_BAIXA DT_BAIXA, 
E5_DATA DT_MOV, 
E1_VALOR VLR, 
E1_ACRESC ACRESC, 
E5_VLJUROS VALJU, 
E5_VLMULTA VLR_MULTA, 
E5_VLDESCO DESCONTO, 
E5_VALOR VALOR,
E5_BANCO BANCO, 
E5_DTDIGIT DT_DIGIT, 
E5_MOTBX MOT, 
E5_FILORIG FILIAL
FROM SE5100 SE5
INNER JOIN SE1100 SE1 ON E1_PREFIXO = E5_PREFIXO
    AND E1_NUM = E5_NUMERO
        AND E1_PARCELA = E5_PARCELA
            AND E1_TIPO = E5_TIPO AND SE1.D_E_L_E_T_ = ''
        AND E1_CLIENTE = E5_CLIFOR
    AND E1_NATUREZ = E5_NATUREZ
INNER JOIN SED100 SED ON E1_NATUREZ = ED_CODIGO
    AND SED.D_E_L_E_T_ = ''
INNER JOIN SA1100 SA1 ON A1_COD = E1_CLIENTE 
        AND E1_LOJA = A1_LOJA 
            AND SA1.D_E_L_E_T_ = ''
    WHERE SE5.D_E_L_E_T_ = ''

UNION 

SELECT 'AMAZON' EMPRESA, '1 - A RECEBER' CONTAS, 
E5_PREFIXO PREFIXO, 
E5_NUMERO NUM, 
E5_PARCELA PARC, 
E5_TIPO TIPO, 
E5_CLIFOR CLI_FOR, 
A1_NOME NOME_CLIFOR,
E5_NATUREZ NATUREZ, 
ED_DESCRIC DESC_NAT, 
E1_EMISSAO EMISSA, 
E1_VENCREA VCTO, 
E1_HIST HISTO, 
E5_HISTOR HIS_BAIXA, 
E1_BAIXA DT_BAIXA,
E5_DATA DT_MOV, 
E1_VALOR VLR, 
E1_ACRESC ACRESC, 
E5_VLJUROS VALJU, 
E5_VLMULTA VLR_MULTA, 
E5_VLDESCO DESCONTO, 
E5_VALOR VALOR,
E5_BANCO BANCO, 
E5_DTDIGIT DT_DIGIT, 
E5_MOTBX MOT, 
E5_FILORIG FILIAL
FROM SE5200 SE5
INNER JOIN SE1200 SE1 ON E1_PREFIXO = E5_PREFIXO
    AND E1_NUM = E5_NUMERO
        AND E1_PARCELA = E5_PARCELA
            AND E1_TIPO = E5_TIPO AND SE1.D_E_L_E_T_ = ''
        AND E1_CLIENTE = E5_CLIFOR
    AND E1_NATUREZ = E5_NATUREZ
INNER JOIN SED200 SED ON E1_NATUREZ = ED_CODIGO
    AND SED.D_E_L_E_T_ = ''
INNER JOIN SA1200 SA1 ON A1_COD = E1_CLIENTE 
        AND E1_LOJA = A1_LOJA 
            AND SA1.D_E_L_E_T_ = ''
    WHERE SE5.D_E_L_E_T_ = ''
)RECEBER

UNION

SELECT *
FROM(
SELECT 'PELMEX' EMPRESA, '2 - A PAGAR' CONTAS, 
E5_PREFIXO PREFIXO, 
E5_NUMERO NUM, 
E5_PARCELA PARC, 
E5_TIPO TIPO, 
E5_CLIFOR CLI_FOR, 
A2_NOME NOME_CLIFOR,
CASE WHEN B1_GRUPO IS NULL THEN E5_NATUREZ ELSE B1_GRUPO END NATUREZ, 
CASE WHEN B1_GRUPO IS NULL THEN ED_DESCRIC ELSE BM_DESC END DESC_NAT,
E2_EMISSAO EMISSA, 
E2_VENCREA VCTO, 
E2_HIST HISTO, 
E5_HISTOR HIS_BAIXA, 
E2_BAIXA DT_BAIXA,
E5_DATA DT_MOV, 
E2_VALOR VLR, 
E2_ACRESC ACRESC, 
E5_VLJUROS VALJU, 
E5_VLMULTA VLR_MULTA, 
E5_VLDESCO DESCONTO, 
CASE WHEN E5_HISTOR LIKE 'Multa%' THEN E5_VALOR
     WHEN E5_HISTOR LIKE 'Juros%' THEN E5_VALOR 
ELSE E5_VALOR-E2_MULTA END VALOR,
E5_BANCO BANCO, 
E5_DTDIGIT DT_DIGIT, 
E5_MOTBX MOT, 
E5_FILORIG FILIAL
FROM SE5100 SE5
INNER JOIN SE2100 SE2 ON E2_PREFIXO = E5_PREFIXO AND E2_NUM = E5_NUMERO AND E2_PARCELA = E5_PARCELA AND E2_TIPO = E5_TIPO AND SE2.D_E_L_E_T_ = ''
                         AND E2_FORNECE = E5_CLIFOR AND E2_NATUREZ = E5_NATUREZ
INNER JOIN SED100 SED ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
INNER JOIN SA2100 SA2 ON A2_COD = E2_FORNECE AND E2_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ''
LEFT JOIN (SELECT D1_FILIAL,D1_DOC,D1_SERIE,MAX(B1_GRUPO)B1_GRUPO,MAX(BM_DESC)BM_DESC,D1_FORNECE,D1_LOJA
           FROM SD1100 SD1 (NOLOCK)
		   INNER JOIN SB1100 SB1 (NOLOCK) ON D1_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
		   INNER JOIN SBM100 SBM (NOLOCK) ON B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = ''
		   WHERE SD1.D_E_L_E_T_ = ''
		   GROUP BY D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA)SD1 ON E2_FILORIG = D1_FILIAL AND E2_NUM = D1_DOC AND E2_PREFIXO = D1_SERIE AND E2_FORNECE = D1_FORNECE AND E2_LOJA = D1_LOJA 
WHERE SE5.D_E_L_E_T_ = ''

UNION 

SELECT 'AMAZON' EMPRESA, '2 - A PAGAR' CONTAS, 
E5_PREFIXO PREFIXO, 
E5_NUMERO NUM, 
E5_PARCELA PARC, 
E5_TIPO TIPO, 
E5_CLIFOR CLI_FOR, 
A2_NOME NOME_CLIFOR,
CASE WHEN B1_GRUPO IS NULL THEN E5_NATUREZ ELSE B1_GRUPO END NATUREZ, 
CASE WHEN B1_GRUPO IS NULL THEN ED_DESCRIC ELSE BM_DESC END DESC_NAT,
E2_EMISSAO EMISSA, 
E2_VENCREA VCTO, 
E2_HIST HISTO, 
E5_HISTOR HIS_BAIXA, 
E2_BAIXA DT_BAIXA,
E5_DATA DT_MOV, 
E2_VALOR VLR, 
E2_ACRESC ACRESC, 
E5_VLJUROS VALJU, 
E5_VLMULTA VLR_MULTA, 
E5_VLDESCO DESCONTO, 
CASE WHEN E5_HISTOR LIKE 'Multa%' THEN E5_VALOR
     WHEN E5_HISTOR LIKE 'Juros%' THEN E5_VALOR 
ELSE E5_VALOR-E2_MULTA END VALOR,
E5_BANCO BANCO, 
E5_DTDIGIT DT_DIGIT, 
E5_MOTBX MOT, 
E5_FILORIG FILIAL
FROM SE5200 SE5
INNER JOIN SE2200 SE2 ON E2_PREFIXO = E5_PREFIXO AND E2_NUM = E5_NUMERO AND E2_PARCELA = E5_PARCELA AND E2_TIPO = E5_TIPO AND SE2.D_E_L_E_T_ = ''
                         AND E2_FORNECE = E5_CLIFOR AND E2_NATUREZ = E5_NATUREZ
INNER JOIN SED200 SED ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
INNER JOIN SA2200 SA2 ON A2_COD = E2_FORNECE AND E2_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ''
LEFT JOIN (SELECT D1_FILIAL,D1_DOC,D1_SERIE,MAX(B1_GRUPO)B1_GRUPO,MAX(BM_DESC)BM_DESC,D1_FORNECE,D1_LOJA
           FROM SD1200 SD1 (NOLOCK)
		   INNER JOIN SB1200 SB1 (NOLOCK) ON D1_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
		   INNER JOIN SBM200 SBM (NOLOCK) ON B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = ''
		   WHERE SD1.D_E_L_E_T_ = ''
		   GROUP BY D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA)SD1 ON E2_FILORIG = D1_FILIAL AND E2_NUM = D1_DOC AND E2_PREFIXO = D1_SERIE AND E2_FORNECE = D1_FORNECE AND E2_LOJA = D1_LOJA 
WHERE SE5.D_E_L_E_T_ = ''

)PAGAR
)UNIAO
WHERE DT_MOV BETWEEN %EXP:mv_par01% AND %EXP:mv_par02%
    AND CAST(SUBSTRING(CONTAS,1,1) AS INT) = %EXP:mv_par03%
ORDER BY CAST(DT_MOV AS DATE), NUM, PARC ASC 
                                           		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt Movimentacao",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Dt Movimentacao",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Contas: ",20)+"?","","","mv_ch3","N",1,0,0,"C","","","","","mv_par03","1 - A Receber","","","","2 - A Pagar")
	//u_InPutSX1(cPerg,"04",PADR("Ate Dt. Baixa  ",20)+"?","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")
	//u_InPutSX1(cPerg,"03",PADR("Vendedor De  ",20)+"?","","","mv_ch3","C",6,0,0,"G","","SA3","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Vendedor At้ ",20)+"?","","","mv_ch4","C",6,0,0,"G","","SA3","","","mv_par04")
	//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
	//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
