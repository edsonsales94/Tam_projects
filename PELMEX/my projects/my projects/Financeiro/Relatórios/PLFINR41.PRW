#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR41    บAutor  ณjuevan Silva     				บ Data ณ 17/01/2023บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Titulos em Carteira Simplificado          		     			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR41()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR41"

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
   

	oReport := TReport():New(cPerg,"Titulos em Carteira Simplificado",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Titulos em Carteira Simplificado",{"SE1"},aOrdem)
	

	TRCell():New(oSection,"E1_NUM"	          ,"SE1","TITULO","@!",7)	   
	TRCell():New(oSection,"E1_PREFIXO"	       ,"SE1","PREFIXO","@!",3) 
    TRCell():New(oSection,"E1_TIPO"	  	       ,"SE1","TIPO","@!",4)
	TRCell():New(oSection,"E1_VALOR"	  	   ,"SE1","VALOR","@E 9,999,999,999.99",) 
	TRCell():New(oSection,"E1_PARCELA"	  	   ,"SE1","PARCELA","@!",3)     
    TRCell():New(oSection,"E1_EMISSAO"	   	   ,"SE1","DT_EMISSAO","@!",10)
    TRCell():New(oSection,"E1_VENCREA"	   	   ,"SE1","DT_VENCTO","@!",10)
    TRCell():New(oSection,"E1_BAIXA"	   	   ,"SE1","DT_BAIXA","@!",10)
    TRCell():New(oSection,"E1_CLIENTE"	   	   ,"SE1","CLIENTE","@!",10)
    TRCell():New(oSection,"E1_NOMCLI"	   	   ,"SE1","NOME","@!",40)
     TRCell():New(oSection,"A1_EST"	   	  	 ,"SA1","EST CLI","@!",6)
    

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

SELECT E1_NUM,E1_PREFIXO,E1_TIPO,E1_VALOR,E1_PARCELA,
       E1_EMISSAO,
       E1_VENCREA,E1_BAIXA,E1_CLIENTE,E1_NOMCLI,A1_EST
FROM %Table:SE1% SE1
LEFT JOIN SA1100 (NOLOCK) SA1 ON A1_COD = E1_CLIENTE AND E1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
WHERE SE1.D_E_L_E_T_ = ''
AND E1_TIPO IN ('NF')
AND E1_PORTADO = ''
AND E1_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND E1_BAIXA = ''
AND E1_NUMBOR = ''
AND A1_EST = 'AM'
AND A1_COD NOT IN ('002715','0002716','002717','002609','002851','002719','002941','002718','002853','002945','003054','003058','Q28720','003145','003149','Q39348','Q46664','Q46665','Q47276','Q47277','Q47280','Q50746','Q53688','Q55520')
ORDER BY E1_NUM,E1_PREFIXO,E1_PARCELA
    		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
		 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De Emissao"     ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Ate DtEmissao"    ,20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
//u_InPutSX1(cPerg,"03",PADR("De Num Broder๔"     ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
//u_InPutSX1(cPerg,"04",PADR("Ate Num Broder๔"    ,20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
