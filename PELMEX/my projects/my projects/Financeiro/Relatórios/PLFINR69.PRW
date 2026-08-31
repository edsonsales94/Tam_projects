#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFINR69    ºAutor  ³Kledson Oliveira    				º Data ³ 05/12/2024º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Titulos a Pagar com Natureza                		     			 	 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLFINR69()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR69"

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
   

	oReport := TReport():New(cPerg,"Titulos a Pagar com Natureza",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Titulos a Pagar com Natureza",{"SE2"},aOrdem)
	


    TRCell():New(oSection,"EMPRESA"	    ,"SE2","Empresa","@!",6)
	TRCell():New(oSection,"M0_CODFIL"	    ,"SE2","Filial","@!",6)
	TRCell():New(oSection,"M0_FILIAL"	    ,"SE2","Descricao Filial","@!",40)
    TRCell():New(oSection,"DT_EMISSAO"	     ,"SE2","Dt.Emissao","@!",11)
    TRCell():New(oSection,"DT_VENCTO"	    ,"SE2","Vencimento","@!",11)
	TRCell():New(oSection,"TITULO"	        ,"SE2","Titulo","@!",9) 	   
	TRCell():New(oSection,"PREFIXO"	     ,"SE2","Prefixo","@!",3) 
	TRCell():New(oSection,"TIPO"	     ,"SE2","Tipo","@!",3) 	 
	TRCell():New(oSection,"PARCELA"	   	    ,"SE2","Parcela","@!",3) 
    TRCell():New(oSection,"VALOR"	     ,"SE2","Valor","@E 9,999,999,999.99",)	
    TRCell():New(oSection,"SALDO"	     ,"SE2","Saldo","@E 9,999,999,999.99",)
	TRCell():New(oSection,"E2_ACRESC"	     ,"SE2","Acrescimo","@E 9,999,999,999.99",)
	TRCell():New(oSection,"E2_DECRESC"	     ,"SE2","Decrescimo","@E 9,999,999,999.99",)
    TRCell():New(oSection,"VALOR_CORRIGIDO"	     ,"SE2","Total a Baixar","@E 9,999,999,999.99",)
	TRCell():New(oSection,"BANCO"	     ,"SE2","Banco","@!",5)
    TRCell():New(oSection,"BAIXA"	   	  ,"SE2","Baixa","@!",11)
	//TRCell():New(oSection,"E2_DESCONT"	     ,"SE2","Total a Baixar","@E 9,999,999,999.99",)
    TRCell():New(oSection,"VLR_BAIXA"	     ,"SE2","Total Baixado","@E 9,999,999,999.99",)
	TRCell():New(oSection,"FORNECEDOR"	   	  ,"SE2","CodFornec","@!",7)
	TRCell():New(oSection,"NOME"	   	  ,"SE2","NomeFornec","@!",20)
	TRCell():New(oSection,"RSOCIAL"	   	  ,"SA2","Razao Social","@!",30)
	TRCell():New(oSection,"HISTORICO"	   	  ,"SE2","Historico","@!",40)
	TRCell():New(oSection,"E2_NATUREZ"	   	  ,"SE2","Natureza","@!",10)
	TRCell():New(oSection,"ED_DESCRIC"	    	,"SED","Desc.Natureza","@!",30)
	TRCell():New(oSection,"E2_CCUSTO"	    	,"SE2","C.Custo","@!",30)
	TRCell():New(oSection,"CTT_DESC01"	    	,"SE2","Descricao C.Custo","@!",30)
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

SELECT EMPRESA,E2_FILORIG,M0_FILIAL, 
       CONVERT(VARCHAR,CAST(DT_EMISSAO AS DATE),103)DT_EMISSAO, 
		CONVERT(VARCHAR,CAST(DT_VENCTO AS DATE),103)DT_VENCTO,
		TITULO, PREFIXO, TIPO, PARCELA, VALOR, SALDO,
		E2_DESCONT,VLR_BAIXA,
		E2_ACRESC,E2_DECRESC, VALOR+E2_ACRESC-E2_DECRESC-VLR_BAIXA VALOR_CORRIGIDO,
		BANCO,BAIXA,
		FORNECEDOR, NOME, RSOCIAL, HISTORICO, E2_NATUREZ, ISNULL(ED_DESCRIC,'')ED_DESCRIC,
		CASE WHEN D1_CC IS NULL THEN E2_CCUSTO ELSE ISNULL(D1_CC,'') END E2_CCUSTO,ISNULL(CTT_DESC01,'')CTT_DESC01
FROM(
SELECT 'PELMEX' EMPRESA,E2_FILORIG,M0_FILIAL,
    	E2_EMISSAO DT_EMISSAO,
     	E2_VENCTO DT_VENCTO,
     	E2_NUM TITULO,E2_PREFIXO PREFIXO,E2_TIPO TIPO,E2_PARCELA PARCELA,
       	E2_VALOR VALOR,
     	E2_SALDO SALDO,E2_ACRESC,E2_DECRESC,
		E2_BCOPAG BANCO,
     CASE WHEN E2_BAIXA = '' THEN '' ELSE CONVERT(VARCHAR, CAST(E2_BAIXA AS DATE),103) END BAIXA,
	 E2_DESCONT,E2_VALLIQ VLR_BAIXA,
     E2_FORNECE FORNECEDOR,E2_NOMFOR NOME,A2_NOME RSOCIAL,E2_HIST HISTORICO,E2_NATUREZ,ED_DESCRIC,E2_CCUSTO,D1_CC,CTT_DESC01
FROM SE2100 SE2 (NOLOCK)
LEFT JOIN SA2100 SA2 (NOLOCK) ON E2_FORNECE = A2_COD AND E2_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ''
LEFT JOIN SED100 SED (NOLOCK) ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
LEFT JOIN (SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,MIN(D1_CC)D1_CC
            FROM SD1100 SD1
			WHERE SD1.D_E_L_E_T_ = ''
			GROUP BY D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA)SD1 ON E2_FILORIG = D1_FILIAL AND E2_NUM = D1_DOC AND E2_PREFIXO = D1_SERIE AND E2_FORNECE = D1_FORNECE AND E2_LOJA = D1_LOJA
LEFT JOIN CTT100 CTT (NOLOCK) ON CASE WHEN D1_CC IS NULL THEN E2_CCUSTO ELSE D1_CC END  = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
INNER JOIN SYS_COMPANY SM (NOLOCK) ON M0_CODIGO = '10' AND E2_FILORIG = M0_CODFIL AND SM.D_E_L_E_T_ = ''
WHERE SE2.D_E_L_E_T_ = ''
AND E2_FORNECE != '001343'
AND E2_LOJA != '02'
AND E2_VENCTO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
AND E2_SALDO > 0
//AND E2_BAIXA BETWEEN '20250101' AND '20250422'--%Exp:mv_par03% AND %Exp:mv_par04%

UNION
SELECT 'AMAZON' EMPRESA,E2_FILORIG,M0_FILIAL,
       E2_EMISSAO DT_EMISSAO,
     	E2_VENCTO DT_VENCTO,
     	E2_NUM TITULO,E2_PREFIXO PREFIXO,E2_TIPO TIPO,E2_PARCELA PARCELA,
       	E2_VALOR VALOR,
     	E2_SALDO SALDO,E2_ACRESC,E2_DECRESC,
		E2_BCOPAG BANCO,
     CASE WHEN E2_BAIXA = '' THEN '' ELSE CONVERT(VARCHAR, CAST(E2_BAIXA AS DATE),103) END BAIXA,
	 E2_DESCONT,E2_VALLIQ VLR_BAIXA,
     E2_FORNECE FORNECEDOR,E2_NOMFOR NOME,A2_NOME RSOCIAL,E2_HIST HISTORICO,E2_NATUREZ,ED_DESCRIC,E2_CCUSTO,D1_CC,CTT_DESC01
FROM SE2200 SE2 (NOLOCK)
LEFT JOIN SA2200 SA2 (NOLOCK) ON E2_FORNECE = A2_COD AND E2_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ''
LEFT JOIN SED200 SED (NOLOCK) ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
LEFT JOIN (SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,MIN(D1_CC)D1_CC
            FROM SD1200 SD1
			WHERE SD1.D_E_L_E_T_ = ''
			GROUP BY D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA)SD1 ON E2_FILORIG = D1_FILIAL AND E2_NUM = D1_DOC AND E2_PREFIXO = D1_SERIE AND E2_FORNECE = D1_FORNECE AND E2_LOJA = D1_LOJA
LEFT JOIN CTT200 CTT (NOLOCK) ON CASE WHEN D1_CC IS NULL THEN E2_CCUSTO ELSE D1_CC END = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
INNER JOIN SYS_COMPANY SM (NOLOCK) ON M0_CODIGO = '20' AND E2_FILORIG = M0_CODFIL AND SM.D_E_L_E_T_ = ''
WHERE SE2.D_E_L_E_T_ = ''
AND E2_VENCTO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
AND E2_SALDO > 0
//AND E2_BAIXA BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
)TB
ORDER BY EMPRESA, DT_VENCTO ,TITULO,PREFIXO,PARCELA


                                           		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Vencimento  ",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Vencimento  ",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Dt. Baixa  ",20)+"?","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Dt. Baixa  ",20)+"?","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")
	//u_InPutSX1(cPerg,"03",PADR("Vendedor De  ",20)+"?","","","mv_ch3","C",6,0,0,"G","","SA3","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Vendedor Até ",20)+"?","","","mv_ch4","C",6,0,0,"G","","SA3","","","mv_par04")
	//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
	//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
