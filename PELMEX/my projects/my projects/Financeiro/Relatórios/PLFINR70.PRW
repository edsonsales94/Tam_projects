#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFINR70    ºAutor  ³Kledson Oliveira    				º Data ³ 16/01/2025º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Titulos por Data de Digitacao               		     			 	 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLFINR70()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR70"

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
   

	oReport := TReport():New(cPerg,"Titulos por Data de Digitacao",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Titulos por Data de Digitacao",{"SE2"},aOrdem)
	


    TRCell():New(oSection,"EMPRESA"	    ,"SE2","Empresa","@!",6)
    TRCell():New(oSection,"E2_FILORIG"	    ,"SE2","Filial","@!",2)
    TRCell():New(oSection,"M0_FILIAL"	     ,"SE2","Nome Filial","@!",30)
    TRCell():New(oSection,"FORNECEDOR"	     ,"SE2","Fornecedor","@!",30)
    TRCell():New(oSection,"PRF_NUM_PARC"	    ,"SE2","Prf Num Parc","@!",20)
	TRCell():New(oSection,"E2_TIPO"	        ,"SE2","TP","@!",3) 	   
	TRCell():New(oSection,"E2_NATUREZ"	     ,"SE2","Natureza","@!",10) 
	TRCell():New(oSection,"E2_VALOR"	     ,"SE2","Valor","@E 9,999,999,999.99",)	
	TRCell():New(oSection,"VLR_CORRIGIDO"	     ,"SE2","Valor corrigido","@E 9,999,999,999.99",)	
	TRCell():New(oSection,"VLR_NOMINAL"	     ,"SE2","Valor nominal","@E 9,999,999,999.99",)	
	TRCell():New(oSection,"EMISSAO"	     ,"SE2","Emissao.","@!",11) 	 
	TRCell():New(oSection,"VENCTOREAL"	   	    ,"SE2","VenctoReal","@!",11) 
    TRCell():New(oSection,"DT_DIGIT"	     ,"SE2","DT. Digitacao","@!",11)
    TRCell():New(oSection,"E2_HIST"	     ,"SE2","Historico","@!",30)
    TRCell():New(oSection,"STATUS_VCTO"	   	  ,"SE2","Status Vencto.","@!",11)
    TRcell():New(oSection,"STATUS_BAIXA"        ,"SE2","Status Baixa.","@!",12)
    //TRCell():New(oSection,"VLR_BAIXA"	     ,"SE2","Vlr Baixa","@E 9,999,999,999.99",)
	//TRCell():New(oSection,"FORNECEDOR"	   	  ,"SE2","CodFornec","@!",7)
	//TRCell():New(oSection,"NOME"	   	  ,"SE2","NomeFornec","@!",20)
	//TRCell():New(oSection,"RSOCIAL"	   	  ,"SA2","Razao Social","@!",30)
	//TRCell():New(oSection,"HISTORICO"	   	  ,"SE2","Historico","@!",40)
	//TRCell():New(oSection,"E2_NATUREZ"	   	  ,"SE2","Natureza","@!",10)
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

SELECT *
FROM (
SELECT 'PELMEX' EMPRESA, E2_FILORIG, M0_FILIAL, (E2_FORNECE +'-' + A2_NOME)FORNECEDOR, (E2_PREFIXO + '-' +E2_NUM + '-' + E2_PARCELA) PRF_NUM_PARC, E2_TIPO, E2_NATUREZ, E2_VALOR,
	    CASE WHEN CAST(GETDATE()AS DATE) > E2_VENCREA
        THEN E2_SALDO
        ELSE 0
        END VLR_CORRIGIDO,
        CASE WHEN E2_ACRESC > 0
        THEN (E2_VALOR + E2_ACRESC)
        ELSE 0 
        END VLR_NOMINAL,
    CONVERT(VARCHAR, CAST(E2_EMISSAO AS DATE),103)EMISSAO, 
    CONVERT(VARCHAR, CAST(E2_VENCREA AS DATE),103)VENCTOREAL,
    CONVERT(VARCHAR, CAST(E2_EMIS1 AS DATE),103)DT_DIGIT, 
    E2_HIST,
    CASE WHEN CAST(GETDATE()AS DATE) > E2_VENCREA
        THEN 'VENCIDO'
        ELSE 'NO PRAZO'
        END STATUS_VCTO,
        CASE WHEN E2_BAIXA = ''
        THEN 'NÃO BAIXADO'
        ELSE CONVERT(VARCHAR, CAST(E2_BAIXA AS DATE),103)
        END STATUS_BAIXA
FROM SE2100 SE2
LEFT JOIN SF1100 SF1 ON E2_NUM = F1_DOC AND SF1.D_E_L_E_T_ = '' 
    AND F1_FILIAL = E2_FILORIG
        AND E2_FORNECE = F1_FORNECE
            AND F1_PREFIXO = E2_PREFIXO
                AND F1_LOJA = E2_LOJA
                    AND E2_FORNECE != '001343'
INNER JOIN SA2100 SA2 ON E2_FORNECE = A2_COD
    AND A2_LOJA = E2_LOJA
        AND SA2.D_E_L_E_T_ = ''     
INNER JOIN SYS_COMPANY SYS ON M0_CODFIL = E2_FILORIG
        AND M0_CODFIL = E2_FILORIG 
            AND M0_CODIGO = '10'
                AND SYS.D_E_L_E_T_ = ''
WHERE SE2.D_E_L_E_T_ = ''
    AND E2_EMIS1 BETWEEN %EXP:mv_par01% AND %EXP:mv_par02%

UNION

SELECT 'AMAZON' EMPRESA, E2_FILORIG,M0_FILIAL, (E2_FORNECE +'-' + A2_NOME)FORNECEDOR, (E2_PREFIXO + '-' +E2_NUM + '-' + E2_PARCELA) PRF_NUM_PARC, E2_TIPO, E2_NATUREZ, E2_VALOR,
	    CASE WHEN CAST(GETDATE()AS DATE) > E2_VENCREA
        THEN E2_SALDO
        ELSE 0
        END VLR_CORRIGIDO,
        CASE WHEN E2_ACRESC > 0
        THEN (E2_VALOR + E2_ACRESC)
        ELSE 0 
        END VLR_NOMINAL,
    CONVERT(VARCHAR, CAST(E2_EMISSAO AS DATE),103)EMISSAO, 
    CONVERT(VARCHAR, CAST(E2_VENCREA AS DATE),103)VENCTOREAL,
    CONVERT(VARCHAR, CAST(E2_EMIS1 AS DATE),103)DT_DIGIT, 
    E2_HIST,
    CASE WHEN CAST(GETDATE()AS DATE) > E2_VENCREA
        THEN 'VENCIDO'
        ELSE 'NO PRAZO'
        END STATUS_VCTO,
        CASE WHEN E2_BAIXA = ''
        THEN 'NÃO BAIXADO'
        ELSE CONVERT(VARCHAR, CAST(E2_BAIXA AS DATE),103)
        END STATUS_BAIXA
FROM SE2200 SE22
LEFT JOIN SF1200 SF12 ON E2_NUM = F1_DOC AND SF12.D_E_L_E_T_ = '' 
    AND F1_FILIAL = E2_FILORIG
        AND E2_FORNECE = F1_FORNECE
            AND F1_PREFIXO = E2_PREFIXO
                AND F1_LOJA = E2_LOJA
                    AND E2_FORNECE != '001343' 
INNER JOIN SA2200 SA22 ON E2_FORNECE = A2_COD
    AND A2_LOJA = E2_LOJA
        AND SA22.D_E_L_E_T_ = '' 
INNER JOIN SYS_COMPANY SYS ON M0_CODFIL = E2_FILORIG
        AND M0_CODFIL = E2_FILORIG 
            AND M0_CODIGO = '20'
                AND SYS.D_E_L_E_T_ = ''    
WHERE SE22.D_E_L_E_T_ = ''
    AND E2_EMIS1 BETWEEN %EXP:mv_par01% AND %EXP:mv_par02%

)CTPGR
ORDER BY EMPRESA, DT_DIGIT, PRF_NUM_PARC, STATUS_BAIXA ASC     

	EndSQL 
	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt Digitacao ",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Dt Digitacao ",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Dt. Baixa  ",20)+"?","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Dt. Baixa  ",20)+"?","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")
	//u_InPutSX1(cPerg,"03",PADR("Vendedor De  ",20)+"?","","","mv_ch3","C",6,0,0,"G","","SA3","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Vendedor Até ",20)+"?","","","mv_ch4","C",6,0,0,"G","","SA3","","","mv_par04")
	//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
	//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
