#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFINR49    ºAutor  ³Wylliam Silva     				º Data ³ 19/06/2023º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Contas a Receber Simplificado                		     			 	 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLFINR57()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR57"

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
   

	oReport := TReport():New(cPerg,"Contas a Receber Simplificado",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Contas a Receber Simplificado",{"SE1"},aOrdem)
	

	TRCell():New(oSection,"STATUS"	        ,"SE1","STATUS","@!",20)
    TRCell():New(oSection,"NATUREZA"	    ,"SE1","NATUREZA","@!",20)
    TRCell():New(oSection,"DESCRICAO"	     ,"SE1","DESCRICAO","@!",35)
    TRCell():New(oSection,"TOTAL"	         ,"SE1","Tipo","@E 9,999,999,999.99",)
    /*TRCell():New(oSection,"E1_VALOR"	     ,"SE1","Valor","@E 9,999,999,999.99",)	   
	TRCell():New(oSection,"E1_EMISSAO"	   ,"SE1","Emissao","@!",10) 
    TRCell():New(oSection,"E1_VENCREA"	     ,"SE1","DtVenc.","@!",10) 
	TRCell():New(oSection,"E1_BAIXA"	   	    ,"SE1","DtBaixa","@!",10)
    TRCell():New(oSection,"E1_CLIENTE"	   	  ,"SE1","Cliente","@!",6)
    TRCell():New(oSection,"A1_NOME"	   	      ,"SA1","Nome.Cliente","@!",30)
	TRCell():New(oSection,"A1_NREDUZ"       ,"SA1","Nome Reduz","@!",15)
	TRCell():New(oSection,"A1_MUN"	    	,"SA1","Munic","@!",15)*/
    
    

	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	

    TRFunction():New(oSection:Cell("TOTAL"),"Total Geral","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
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

    SELECT STATUS,NATUREZA,DESCRICAO,SUM(E1_VALOR)TOTAL
FROM(
    SELECT 'EM CARTEIRA' STATUS,E1_NATUREZ NATUREZA,ED_DESCRIC DESCRICAO,E1_TIPO,E1_NUM,E1_PREFIXO,E1_PARCELA,E1_VALOR,E1_EMISSAO,E1_VENCTO,E1_BAIXA,E1_NUMBOR,A1_COD,A1_NOME
    FROM %Table:SE1% SE1 (NOLOCK)
    INNER JOIN %Table:SED% SED (NOLOCK) ON E1_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
    INNER JOIN %Table:SA1% SA1 (NOLOCK) ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
    WHERE SE1.D_E_L_E_T_ = ''
    AND E1_SALDO > 0
    AND E1_BAIXA = ''
    AND E1_PREFIXO = '2'
    AND E1_NUMBOR = ''
    AND E1_PORTADO = ''
    AND E1_TIPO IN ('NF','DP','BO','BOL')
    AND E1_EMISSAO BETWEEN 	%Exp:MV_PAR01% AND %Exp:MV_PAR02%	
    AND A1_NOME NOT LIKE 'PRO FLORES%'
    AND A1_NOME NOT LIKE 'ANDRE LUIZ BASTOS ARRUDA - ME'
    AND A1_NOME NOT LIKE 'ITALO DE OLIVEIRA VALERUZ 87447100200'
    )TB
    GROUP BY STATUS,NATUREZA,DESCRICAO
    UNION
    SELECT STATUS,NATUREZA,DESCRICAO,SUM(E1_VALOR)TOTAL
    FROM(
    SELECT 'DESCONTADO' STATUS,E1_NATUREZ NATUREZA,ED_DESCRIC DESCRICAO,E1_TIPO,E1_NUM,E1_PREFIXO,E1_PARCELA,E1_VALOR,E1_EMISSAO,E1_VENCTO,E1_BAIXA,E1_NUMBOR,A1_COD,A1_NOME
    FROM %Table:SE1% SE1 (NOLOCK)
    INNER JOIN %Table:SED% SED (NOLOCK) ON E1_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
    INNER JOIN %Table:SA1% SA1 (NOLOCK) ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
    WHERE SE1.D_E_L_E_T_ = ''
    AND E1_SALDO > 0
    AND E1_PREFIXO = '2'
    AND E1_BAIXA = ''
    AND E1_TIPO IN ('NF','DP','BO','BOL')
    AND E1_NUMBOR != ''
    AND E1_EMISSAO BETWEEN 	%Exp:MV_PAR01% AND %Exp:MV_PAR02%	
    AND A1_NOME NOT LIKE 'PRO FLORES%'
    AND A1_NOME NOT LIKE 'ANDRE LUIZ BASTOS ARRUDA - ME'
    AND A1_NOME NOT LIKE 'ITALO DE OLIVEIRA VALERUZ 87447100200'
    )TB
    GROUP BY STATUS,NATUREZA,DESCRICAO
    UNION
    SELECT STATUS,NATUREZA,DESCRICAO,SUM(E1_VALOR)*-1TOTAL
    FROM(
    SELECT 'DEVOLUCAO' STATUS,E1_NATUREZ NATUREZA,ED_DESCRIC DESCRICAO,E1_TIPO,E1_NUM,E1_PREFIXO,E1_PARCELA,E1_VALOR,E1_EMISSAO,E1_VENCTO,E1_BAIXA,E1_NUMBOR,A1_COD,A1_NOME
    FROM %Table:SE1% SE1 (NOLOCK)
    INNER JOIN %Table:SED% SED (NOLOCK) ON E1_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
    INNER JOIN %Table:SA1% SA1 (NOLOCK) ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
    WHERE SE1.D_E_L_E_T_ = ''
    AND E1_BAIXA = ''
    AND E1_PREFIXO = '2'
    AND E1_TIPO IN ('NCC')
    AND E1_EMISSAO BETWEEN 	%Exp:MV_PAR01% AND %Exp:MV_PAR02%	
    AND A1_NOME NOT LIKE 'PRO FLORES%'
    AND A1_NOME NOT LIKE 'ANDRE LUIZ BASTOS ARRUDA - ME'
    AND A1_NOME NOT LIKE 'ITALO DE OLIVEIRA VALERUZ 87447100200'
    )TB
    GROUP BY STATUS,NATUREZA,DESCRICAO
    UNION
    SELECT STATUS,NATUREZA,DESCRICAO,SUM(E1_VALOR)TOTAL
    FROM(
    SELECT 'EM CARTEIRA' STATUS,E1_NATUREZ NATUREZA,ED_DESCRIC DESCRICAO,E1_TIPO,E1_NUM,E1_PREFIXO,E1_PARCELA,E1_VALOR,E1_EMISSAO,E1_VENCTO,E1_BAIXA,E1_NUMBOR,A1_COD,A1_NOME
    FROM %Table:SE1% SE1 (NOLOCK)
    INNER JOIN %Table:SED% SED (NOLOCK) ON E1_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
    INNER JOIN %Table:SA1% SA1 (NOLOCK) ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
    WHERE SE1.D_E_L_E_T_ = ''
    AND E1_BAIXA = ''

    AND E1_TIPO IN ('CD','CC')
    AND E1_EMISSAO BETWEEN 	%Exp:MV_PAR01% AND %Exp:MV_PAR02%	
    AND A1_NOME NOT LIKE 'PRO FLORES%'
    AND A1_NOME NOT LIKE 'ANDRE LUIZ BASTOS ARRUDA - ME'
    AND A1_NOME NOT LIKE 'ITALO DE OLIVEIRA VALERUZ 87447100200'
    )TB
GROUP BY STATUS,NATUREZA,DESCRICAO
ORDER BY 1,2

                                           		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("Data Ini "    ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Data Fim "    ,20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
//u_InPutSX1(cPerg,"03",PADR("De Baixa"     ,20)+"?","","","mv_ch3","D",15,0,0,"G","","","","","mv_par03") 
//u_InPutSX1(cPerg,"04",PADR("Ate Dt Baixa"    ,20)+"?","","","mv_ch4","D",15,0,0,"G","","","","","mv_par04")
//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
