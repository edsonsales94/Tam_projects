#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR47    บAutor  ณjuevan Silva     				บ Data ณ 08/03/2023บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณFinanceiro X Faturamento Baruf        		     			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR47()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR47"

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
	Local aOrdem      := {"FILIAL"}
   

	oReport := TReport():New(cPerg,"Financeiro X Faturamento Baruf",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Financeiro X Faturamento Baruf",{"SE1"},aOrdem)
	
	TRCell():New(oSection,"D2_EMISSAO"	        ,"SD2","DT_EMISSAO","@!",10)	   
	TRCell():New(oSection,"BANCO"	  		    ,"SE1","BANCO","@!",10) 
    TRCell():New(oSection,"E1_AGEDEP"	  	    ,"SE1","E1_AGEDEP","@!",4)
	TRCell():New(oSection,"D2_DOC"	  	    ,"SD2","D2_DOC","@!",10)
	TRCell():New(oSection,"D2_SERIE"	   	   ,"SD2","D2_SERIE","@!",3)
	TRCell():New(oSection,"E1_PARCELA"	  	 ,"SDE1","E1_PARCELA","@!",4)     
    TRCell():New(oSection,"E1_VALOR"	   	   ,"SE1","VALOR","@E 9,999,999,999.99",) 
    TRCell():New(oSection,"DT_SAIDA"	   	   ,"CNF","DT_SAIDA","@!",10)
    TRCell():New(oSection,"E1_VENCREA"	   	   ,"SE1","E1_VENCREA","@!",10)
    TRCell():New(oSection,"E1_BAIXA"	   	   ,"SE1","E1_BAIXA","@!",10)
    TRCell():New(oSection,"A1_COD"	   	   ,"SE1","A1_COD","@!",3)
    TRCell():New(oSection,"LOJA"	   	   ,"SA1","LOJA","@!",3)
    TRCell():New(oSection,"A1_NOME"	   	   ,"SA1","A1_NOME","@!",40)
    TRCell():New(oSection,"A1_MUN"	   	   ,"SA1","A1_MUN","@!",10)
    TRCell():New(oSection,"A3_NOME"	   	   ,"SA3","A3_NOME","@!",40)
    //TRCell():New(oSection,"VENDEDOR"	   	,"SA3","VENDEDOR","@!",30)
    //TRCell():New(oSection,"VENCIMENTO"	   	,"SE1","VENCIMENTO","@!",10)
    //TRCell():New(oSection,"DT_BAIXA"	   	,"SE1","DT_BAIXA","@!",10)

    
    

	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	/*TRFunction():New(oSection:Cell("TOTAL_DUPLICATA"),"Total Duplicata:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("JUROS"),"Total Juros:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("VAL_IOF_DIA"),"Total IOF Dia","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("VAL_IOF_ADICIONAL"),"Total IOF Adicional:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("TOTAL_IOF"),"Total IOF:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("VAL_OPERACAO"),"Total Taxa Inclusใo:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("TOTAL_DESCONTADO"),"Total Lํquido:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("TOTAL_LIQUIDO"),"Total a Receber:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
	
    /*oFunction1 := TRFunction():New(oSection:Cell("TOTAL_DUPLICATA") ,"Total Duplicata :","SUM",oBreak,"","@E 999,999,999.99",,.F.,.F.,.F.)
    oFunction1 := TRFunction():New(oSection:Cell("TOTAL_IOF") ,"Total IOF :","SUM",oBreak,"","@E 999,999,999.99",,.F.,.F.,.F.)
    oFunction1 := TRFunction():New(oSection:Cell("VAL_OPERACAO") ,"Total IOF :","SUM",oBreak,"","@E 999,999,999.99",,.F.,.F.,.F.)
    oFunction1 := TRFunction():New(oSection:Cell("GERAL") ,"A Receber:","ONPRINT",oBreak,"","@E 999,999,999.99",{||oSection:aFunction[1]:GetValue() - oSection:aFunction[2]:GetValue() - oSection:aFunction[3]:GetValue()},.F.,.F.,.F.)
    */
    //TRFunction():New(oSection:Cell("VAL_PAGAR"),"TOTAL Pagar","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("DIFERENCA"),"Diferenca","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	oReport:SetTotalInLine(.T.)

	//Quebra por Se็ใo
	//oSection1:SetPageBreak(.T.)
	//oSection1:SetTotalText(" ")

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

SELECT D2_EMISSAO,E1_PORTADO BANCO,E1_AGEDEP,D2_DOC,D2_SERIE,E1_PARCELA,E1_VALOR,
     ISNULL(CNF_EXPEDICAO,'')DT_SAIDA,E1_VENCREA,E1_BAIXA,A1_COD,A1_LOJA,A1_NOME,A1_MUN,ISNULL(A3_NOME,'')A3_NOME
FROM(
  SELECT D2_EMISSAO,E1_PARCELA,D2_DOC,D2_SERIE,E1_VALOR,
      CNF_EXPEDICAO,A1_COD,A1_LOJA,A1_NOME,A1_MUN,
      ISNULL(E1_PORTADO,'')E1_PORTADO,ISNULL(E1_AGEDEP,'')E1_AGEDEP,E1_VENCREA,E1_BAIXA,C5_COMIS1,A3_NOME
  FROM SE1100 SE1 (NOLOCK)
  INNER JOIN SD2100 SD2 (NOLOCK) ON  D2_DOC = E1_NUM AND D2_SERIE = E1_PREFIXO AND D2_CLIENTE = E1_CLIENTE AND D2_LOJA = E1_LOJA AND SD2.D_E_L_E_T_ = ''
  INNER JOIN SA1100 SA1 (NOLOCK) ON E1_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
  LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
  INNER JOIN SC5100 SC5 (NOLOCK) ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.D_E_L_E_T_ = ''
  INNER JOIN SC6100 SC6 (NOLOCK) ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND D2_COD = C6_PRODUTO AND SC6.D_E_L_E_T_ = ''
  LEFT JOIN SA3100 SA3 (NOLOCK) ON C5_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ''
  LEFT JOIN CNF (NOLOCK) ON D2_FILIAL = CNF_FILIAL AND D2_DOC = CNF_DOC AND D2_SERIE = CNF_SERIE
  WHERE SE1.D_E_L_E_T_ = ''
  AND C6_CONTRAT = ''
  AND D1_DOC IS NULL
  AND D2_SERIE = '2'
  AND D2_DOC BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
  AND D2_LOCAL = '20'
  AND D2_FILIAL = '01'
  AND A1_NREDUZ LIKE 'ORTOCONFORT%'
  AND E1_VENCREA BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
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
)TB
GROUP BY D2_EMISSAO,E1_PORTADO,E1_AGEDEP,D2_DOC,D2_SERIE,E1_PARCELA,E1_VALOR,
       CNF_EXPEDICAO,E1_VENCREA,E1_BAIXA,A1_COD,A1_LOJA,A1_NOME,A1_MUN,A3_NOME
    		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
		 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De Nota"     ,20)+"?","","","mv_ch1","C",9,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Ate Nota"    ,20)+"?","","","mv_ch2","C",9,0,0,"G","","","","","mv_par02")
u_InPutSX1(cPerg,"03",PADR("De Vencimento"     ,20)+"?","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03") 
u_InPutSX1(cPerg,"04",PADR("Ate DtVencimento"    ,20)+"?","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")
//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
