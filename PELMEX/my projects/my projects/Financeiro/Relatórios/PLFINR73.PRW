#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR73    บAutor  ณKledson Oliveira    				บ Data ณ 13/03/2025บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Extrato Bancแrio por Banco             		     			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR73()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR73"

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
   

	oReport := TReport():New(cPerg,"Extrato Bancแrio por Banco",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Extrato Bancแrio por Banco",{"SE2"},aOrdem)
	


    TRCell():New(oSection,"EMPRESA"	    ,"SE5","Empresa","@!",6)
	TRCell():New(oSection,"DT_MOV"	     ,"SE5","Dt. Moviment","@!",11)
	TRCell():New(oSection,"E5_BANCO"	     ,"SE5","Banco.","@!",5) 	 
	TRCell():New(oSection,"E5_AGENCIA"	     ,"SE5","Agencia","@!",6) 	 
    TRCell():New(oSection,"A6_NUMCON"	    ,"SA6","Nบ Conta","@!",7)    
	TRCell():New(oSection,"A6_NOME"	        ,"SE5","Nome do Banco","@!",30)
	TRCell():New(oSection,"E5_NATUREZ"	     ,"SE5","Natureza","@!",10) 
	TRCell():New(oSection,"ED_DESCRIC"	     ,"SE5","Desc Nat","@!",30)
	TRCell():New(oSection,"E5_CLIFOR"	     ,"SE5","Cli/For","@!",7)
	TRCell():New(oSection,"NOME_CLI_FOR"	   	  ,"SE5","Nome Cli/For","@!",30) 
	TRCell():New(oSection,"PREFIXOTITULO"	     ,"SE5","Prefixo+Nบ Titulo","@!",15) 
	TRCell():New(oSection,"E5_PARCELA"	     ,"SE5","Parcela","@!",4)
	TRCell():New(oSection,"E5_RECPAG"	     ,"SE5","Rec ou Pag","@!",3)  	     	   
	TRCell():New(oSection,"ENTRADA"	     ,"SE5","Entrada","@E 9,999,999,999.99",)	
	TRCell():New(oSection,"SAIDA"	     ,"SE2","Saํda","@E 9,999,999,999.99",)
	TRCell():New(oSection,"SALDO_ANTERIOR"	     ,"SE2","Saldo Ant","@E 9,999,999,999.99",)		
    TRCell():New(oSection,"E5_HISTOR"	     ,"SE5","Hist๓rico","@!",30)
	
	//TRCell():New(oSection,"CONTAS"	     ,"SE5","Tipo","@!",10)
	//TRCell():New(oSection,"VCTO"	     ,"SE5","Dt. Vencimento","@!",11)
    //TRCell():New(oSection,"HIS_BAIXA"	     ,"SE5","Historico Baixa","@!",30)
    //TRCell():New(oSection,"DT_MOV"	     ,"SE5","Dt. Movimentacao","@!",11)
    //TRCell():New(oSection,"DT_BAIXA"	     ,"SE5","Dt. Baixa","@!",11)
	//TRCell():New(oSection,"ACRESC"	     ,"SE2","Acrescimo","@E 9,999,999,999.99",)	
	//TRCell():New(oSection,"VALJU"	     ,"SE2","Juros","@E 9,999,999,999.99",)	
	//TRCell():New(oSection,"VLR_MULTA"	     ,"SE2","Multa","@E 9,999,999,999.99",)	
	//TRCell():New(oSection,"DESCONTO"	     ,"SE2","Desconto","@E 9,999,999,999.99",)	
	//TRCell():New(oSection,"TOTAL_BAIXADO"	     ,"SE2","Total Baixado","@E 9,999,999,999.99",)	
    //TRCell():New(oSection,"DT_DIGIT"	     ,"SE2","DT. Digitacao","@!",11)
    //TRCell():New(oSection,"MOT"	   	  ,"SE2","Motivo.","@!",4)
    //TRCell():New(oSection,"ORIG"	   	  ,"SE2","Fil Origem","@!",2)
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

SELECT EMPRESA, DT_MOV, E5_BANCO, E5_AGENCIA, A6_NUMCON, A6_NOME, E5_NATUREZ, ED_DESCRIC, E5_CLIFOR, NOME_CLI_FOR, PREFIXOTITULO, E5_PARCELA, E5_RECPAG, 
ENTRADA, SAIDA, ISNULL(SALDO_ANTERIOR,0)SALDO_ANTERIOR, E5_HISTOR  
FROM(
SELECT '10 - PELMEX' EMPRESA, CONVERT(VARCHAR, CAST(E5_DATA AS DATE),103)DT_MOV, E5_BANCO, E5_AGENCIA, A6_NUMCON, A6_NOME, E5_NATUREZ, ED_DESCRIC, (E5_PREFIXO + '-' + E5_NUMERO)PREFIXOTITULO,
E5_HISTOR, E5_RECPAG,
CASE WHEN E2_FORNECE IS NULL AND E5_RECPAG = 'R'
THEN E5_VALOR ELSE 0 END ENTRADA,
CASE WHEN E1_CLIENTE IS NULL AND E5_RECPAG = 'P'
THEN E5_VALOR ELSE 0 END SAIDA, 
CASE WHEN E5_RECPAG = 'R'
        THEN E1_SALDO
    WHEN E5_RECPAG = 'P'
        THEN E2_SALDO
    ELSE 0
    END SALDO_ANTERIOR,
E5_PARCELA, E5_CLIFOR,
CASE WHEN E5_CLIFOR = A1_COD AND E5_LOJA = A1_LOJA 
THEN A1_NOME 
WHEN E5_CLIFOR = A2_COD AND E5_LOJA = A2_LOJA 
THEN A2_NOME 
END NOME_CLI_FOR
FROM SE5100 SE5
LEFT JOIN SA6100 SA6 ON A6_COD = E5_BANCO
    AND SA6.D_E_L_E_T_ = ''
        AND E5_AGENCIA = A6_AGENCIA
          AND E5_CONTA = A6_NUMCON
LEFT JOIN SED100 SED ON ED_CODIGO = E5_NATUREZ
          AND SED.D_E_L_E_T_ = ''
LEFT JOIN SE1100 SE1 ON E1_PREFIXO = E5_PREFIXO
    AND E1_NUM = E5_NUMERO
        AND E1_PARCELA = E5_PARCELA
            AND E1_TIPO = E5_TIPO 
              AND SE1.D_E_L_E_T_ = ''
            AND E1_LOJA = E5_LOJA
        AND E1_CLIENTE = E5_CLIFOR
    AND E1_NATUREZ = E5_NATUREZ
LEFT JOIN SE2100 SE2 ON E2_PREFIXO = E5_PREFIXO
    AND E2_NUM = E5_NUMERO
        AND E2_PARCELA = E5_PARCELA
            AND E2_TIPO = E5_TIPO 
              AND SE2.D_E_L_E_T_ = ''
            AND E2_LOJA = E5_LOJA
        AND E2_FORNECE = E5_CLIFOR
    AND E2_NATUREZ = E5_NATUREZ
LEFT JOIN SA1100 SA1 ON A1_COD = E5_CLIFOR 
          AND A1_LOJA = E5_LOJA 
            AND SA1.D_E_L_E_T_ = ''
LEFT JOIN SA2100 SA2 ON A2_COD = E5_CLIFOR 
          AND A2_LOJA = E5_LOJA
            AND SA2.D_E_L_E_T_ = ''
WHERE E5_DATA BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%
    AND SE5.D_E_L_E_T_ = ''
		AND E5_SITUACA != 'C'
			AND E5_TIPODOC NOT IN ('MT','DC','JR','V2','M2')

UNION 

SELECT '20 - AMAZON' EMPRESA, CONVERT(VARCHAR, CAST(E5_DATA AS DATE),103)DT_MOV, E5_BANCO, E5_AGENCIA, A6_NUMCON, A6_NOME, E5_NATUREZ, ED_DESCRIC, (E5_PREFIXO + '-' + E5_NUMERO)PREFIXOTITULO,
E5_HISTOR, E5_RECPAG,
CASE WHEN E2_FORNECE IS NULL AND E5_RECPAG = 'R'
THEN E5_VALOR ELSE 0 END ENTRADA,
CASE WHEN E1_CLIENTE IS NULL AND E5_RECPAG = 'P'
THEN E5_VALOR ELSE 0 END SAIDA,
CASE WHEN E5_RECPAG = 'R'
        THEN E1_SALDO
    WHEN E5_RECPAG = 'P'
        THEN E2_SALDO
    END SALDO_ANTERIOR,
E5_PARCELA, E5_CLIFOR,
CASE WHEN E5_CLIFOR = A1_COD AND E5_LOJA = A1_LOJA 
THEN A1_NOME 
WHEN E5_CLIFOR = A2_COD AND E5_LOJA = A2_LOJA 
THEN A2_NOME 
END NOME_CLI_FOR
FROM SE5200 SE5
LEFT JOIN SA6200 SA6 ON A6_COD = E5_BANCO
    AND SA6.D_E_L_E_T_ = ''
        AND E5_AGENCIA = A6_AGENCIA
          AND E5_CONTA = A6_NUMCON
LEFT JOIN SED200 SED ON ED_CODIGO = E5_NATUREZ
          AND SED.D_E_L_E_T_ = ''
LEFT JOIN SE1200 SE1 ON E1_PREFIXO = E5_PREFIXO
    AND E1_NUM = E5_NUMERO
        AND E1_PARCELA = E5_PARCELA
            AND E1_TIPO = E5_TIPO 
              AND SE1.D_E_L_E_T_ = ''
            AND E1_LOJA = E5_LOJA
        AND E1_CLIENTE = E5_CLIFOR
    AND E1_NATUREZ = E5_NATUREZ
LEFT JOIN SE2200 SE2 ON E2_PREFIXO = E5_PREFIXO
    AND E2_NUM = E5_NUMERO
        AND E2_PARCELA = E5_PARCELA
            AND E2_TIPO = E5_TIPO 
              AND SE2.D_E_L_E_T_ = ''
            AND E2_LOJA = E5_LOJA
        AND E2_FORNECE = E5_CLIFOR
    AND E2_NATUREZ = E5_NATUREZ
LEFT JOIN SA1200 SA1 ON A1_COD = E5_CLIFOR 
          AND A1_LOJA = E5_LOJA 
            AND SA1.D_E_L_E_T_ = ''
LEFT JOIN SA2200 SA2 ON A2_COD = E5_CLIFOR 
          AND A2_LOJA = E5_LOJA
            AND SA2.D_E_L_E_T_ = ''
WHERE E5_DATA BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%
    AND SE5.D_E_L_E_T_ = ''
		AND E5_SITUACA != 'C'
			AND E5_TIPODOC NOT IN ('MT','DC','JR','V2','M2')
)TB 
WHERE CAST(SUBSTRING(EMPRESA,1,1) AS INT) = %EXP:MV_PAR03% 
	AND E5_BANCO = %EXP:MV_PAR04% 
		AND E5_AGENCIA = %EXP:MV_PAR05%
			AND A6_NUMCON = %EXP:MV_PAR06% 
	
                                           		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt Movimentacao",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Dt Movimentacao",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Empresa ",20)+"?","","","mv_ch3","N",2,0,0,"C","","","","","mv_par03","10 - Pelmex","","","","20 - Amazon")
	u_InPutSX1(cPerg,"04",PADR("Banco"         ,20)+"?","","","mv_ch4","C",3,0,0,"G","","SA6","","","mv_par04") 
	u_InPutSX1(cPerg,"05",PADR("Agencia",20)+"?","","","mv_ch5","C",5,0,0,"G","","SA6","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Conta",20)+"?","","","mv_ch6","C",10,0,0,"G","","SA6","","","mv_par06")
	//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
	//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
