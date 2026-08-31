#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR29    บAutor  ณWylliam Silva     				บ Data ณ 08/04/2022บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Rel. Analise de Cliente Detalhado               		     			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR35()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR35"

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
    Local Total_Dupli
    Local Total_IOF
    Local Total_Adesao
    Local Total_Liq
    Local Juros

	oReport := TReport():New(cPerg,"Simula็ใo Taxas Banco",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Simula็ใo Taxas Banco",{"SE1"},aOrdem)
	
	TRCell():New(oSection,"DT_BORDERO"	        ,"SE1","Dt. Bordero","@!",20)	   
	TRCell():New(oSection,"BORDERO"	  		    ,"SE1","Bordero","@!",15) 
    TRCell():New(oSection,"DT_BANCO"	  	    ,"SE1","Dt. Adesใo","@!",20)
	TRCell():New(oSection,"TITULO"	            ,"SE1","Titulo","@!",15)
	TRCell():New(oSection,"PREFIXO"	   		    ,"SE1","Prefixo","@!",3)
    TRCell():New(oSection,"PARCELA"	   		    ,"SE1","Parcela","@!",10)
    TRCell():New(oSection,"CLIENTE"	   		    ,"SE1","Cliente","@!",50)
	TRCell():New(oSection,"VENC_DUPLI"	  	    ,"SE1","Vencto Duplicata","@!",20)
	TRCell():New(oSection,"TOTAL_DUPLICATA"	    ,"SE1","Valor Nominal","@E 9,999,999,999.99",20)
    //TRCell():New(oSection,"DIA_SEMANA"		    ,"SE1","Dia da Semana","@!",10)
	TRCell():New(oSection,"DIAS"	            ,"SE1","Dias","@E 9,999,999,999",4)
	TRCell():New(oSection,"TAXA_BANCO"		    ,"SE1","Taxa Banco","@E 9,999,999,999.99999",)
    TRCell():New(oSection,"JUROS"		        ,"SE1","Juros","@E 9,999,999,999.99",20)      
	TRCell():New(oSection,"IOF_DIA"	            ,"SE1","Taxa IOF Dia","@E 9,999,999,999.99999",)
	TRCell():New(oSection,"VAL_IOF_DIA"			,"SE1","Valor IOF Dia","@E 9,999,999,999.99",20) 
	TRCell():New(oSection,"IOF_ADICIONAL"	    ,"SE1","Taxa IOF Adicional","@E 9,999,999,999.99999",)
	TRCell():New(oSection,"VAL_IOF_ADICIONAL"	,"SE1","Valor IOF Adicional","@E 9,999,999,999.99",20) 
	TRCell():New(oSection,"TOTAL_IOF"			,"SE1","Total IOF","@E 9,999,999,999.99",20) 
    TRCell():New(oSection,"TX_OPERACAO"			,"SE1","Taxa de Adesใo","@E 9,999,999,999.99999",) 
	TRCell():New(oSection,"VAL_OPERACAO"		,"SE1","Valor da Adesใo","@E 9,999,999,999.99",20)
    TRCell():New(oSection,"TOTAL_DESCONTADO"	,"SE1","Total Lํquido","@E 9,999,999,999.99",20)
    TRCell():New(oSection,"TOTAL_LIQUIDO"       ,"SE1","Total a Receber","@E 9,999,999,999.99",20)
    TRCell():New(oSection,"BANCO"			    ,"SE1","Banco","@!",5)
    TRCell():New(oSection,"AGENCIA"			    ,"SE1","Agencia","@!",10)
    TRCell():New(oSection,"CONTA"			    ,"SE1","Conta","@!",20)
    TRCell():New(oSection,"NOME"			    ,"SE1","Nome","@!",70)
	
	//Segunda se็ใo
	//oSection2 := TRSection():New(oReport,"TOTAL GERAL RECEBER X NOTAS FISCAIS",{"SE1"},aOrdem)  
    
    /*Total_Dupli  := oReport:GetFunction("TOTAL_DUPLICATA"):GetValue()
    Juros        := oReport:GetFunction("JUROS"):GetValue()
    Total_IOF    := oReport:GetFunction("TOTAL_IOF"):GetValue()
    Total_Adesao := oReport:GetFunction("VAL_OPERACAO"):GetValue()
    Total_Liq    := Total_Dupli-Juros-Total_IOF-Total_Adessao
    */
	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	TRFunction():New(oSection:Cell("TOTAL_DUPLICATA"),"Total Duplicata:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
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

    SELECT E1_NUMBOR BORDERO,E1_NUM TITULO,E1_PREFIXO PREFIXO,E1_PARCELA PARCELA,E1_NOMCLI CLIENTE,
        CONVERT(VARCHAR,CAST(E1_DATABOR AS DATE),103)DT_BORDERO,
        CONVERT(VARCHAR,CAST(%Exp:MV_PAR01% AS DATE),103)DT_BANCO,
        CONVERT(VARCHAR,CAST(E1_VENCREA AS DATE),103)VENC_DUPLI,UPPER(DATENAME(DW,E1_VENCREA))DIA_SEMANA,
        DIAS,%Exp:MV_PAR02% TAXA_BANCO ,
        SUM(E1_VALOR)TOTAL_DUPLICATA,SUM(JUROS)JUROS,
        SUM(E1_VALOR)-SUM(JUROS) TOTAL_DESCONTADO,
        SUM(E1_VALOR)-SUM(JUROS)-(SUM(E1_VALOR)-SUM(JUROS))*%Exp:MV_PAR03%/100*DIAS+(SUM(E1_VALOR)-SUM(JUROS))*%Exp:MV_PAR04%/100 - SUM(E1_VALOR)*((%Exp:MV_PAR06%*100)/(%Exp:MV_PAR05%)/100) TOTAL_LIQUIDO,
        %Exp:MV_PAR03%/100*100 IOF_DIA,%Exp:MV_PAR04%/100*100 IOF_ADICIONAL,
        (SUM(E1_VALOR)-SUM(JUROS))*%Exp:MV_PAR03%/100*DIAS VAL_IOF_DIA,
        (SUM(E1_VALOR)-SUM(JUROS))*%Exp:MV_PAR04%/100 VAL_IOF_ADICIONAL,
        (SUM(E1_VALOR)-SUM(JUROS))*%Exp:MV_PAR03%/100*DIAS+(SUM(E1_VALOR)-SUM(JUROS))*%Exp:MV_PAR04%/100 TOTAL_IOF,
        (%Exp:MV_PAR06%*100/%Exp:MV_PAR05%) TX_OPERACAO,
        SUM(E1_VALOR)*((%Exp:MV_PAR06%*100)/(%Exp:MV_PAR05%)/100) VAL_OPERACAO,
        E1_PORTADO BANCO,E1_AGEDEP AGENCIA,E1_CONTA CONTA,A6_NOME NOME
    FROM(
    SELECT E1_NUMBOR,E1_DATABOR,E1_NUM,E1_PREFIXO,E1_PARCELA,E1_EMISSAO,E1_VENCTO,E1_VENCREA,E1_VALOR,DIAS,TAXA,(E1_VALOR*TAXA) JUROS,
        E1_VALLIQ,E1_PORTADO,E1_AGEDEP,E1_CONTA,A6_NOME,E1_NOMCLI
    FROM(
    SELECT E1_NUMBOR,E1_DATABOR,E1_NUM,E1_PREFIXO,E1_PARCELA,E1_EMISSAO,E1_VENCTO,E1_VENCREA,E1_VALOR,
        DATEDIFF(DAY,CAST(%Exp:MV_PAR01% AS DATE),E1_VENCREA)DIAS,
        (%Exp:MV_PAR02%/100)/30 * DATEDIFF(DAY,CAST(%Exp:MV_PAR01% AS DATE),E1_VENCREA) TAXA,
        E1_VALLIQ,E1_PORTADO,E1_AGEDEP,E1_CONTA,A6_NOME,E1_NOMCLI
    FROM SE1100 SE1 (NOLOCK)
    LEFT JOIN SA6100 SA6 (NOLOCK) ON E1_PORTADO = A6_COD AND E1_AGEDEP = A6_AGENCIA AND E1_CONTA = A6_NUMCON AND SA6.D_E_L_E_T_ = ''
    WHERE SE1.D_E_L_E_T_ = ''
    AND E1_NUMBOR BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
    )TB
    )TB1
    GROUP BY E1_NUMBOR,E1_NUM,E1_PREFIXO,E1_DATABOR,E1_VENCTO,E1_PARCELA,E1_VENCREA,E1_NOMCLI,DIAS,TAXA,E1_PORTADO,E1_AGEDEP,E1_CONTA,A6_NOME
    ORDER BY E1_DATABOR,E1_NUMBOR,E1_VENCREA			
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
		 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("Dt.Acordo "         ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Taxa Banco "        ,20)+"?","","","mv_ch2","N",10,5,0,"C","","","","","mv_par02")
u_InPutSX1(cPerg,"03",PADR("Tx IOF Dia"         ,20)+"?","","","mv_ch3","N",10,5,0,"C","","","","","mv_par03") 
u_InPutSX1(cPerg,"04",PADR("Tx IOF Adicional"   ,20)+"?","","","mv_ch4","N",10,5,0,"C","","","","","mv_par04")
u_InPutSX1(cPerg,"05",PADR("Total Opera็ใo"     ,20)+"?","","","mv_ch5","N",10,5,0,"C","","","","","mv_par05") 
u_InPutSX1(cPerg,"06",PADR("Valor Tx Opera็ใo"  ,20)+"?","","","mv_ch6","N",10,5,0,"C","","","","","mv_par06")
u_InPutSX1(cPerg,"07",PADR("De Bordero"         ,20)+"?","","","mv_ch7","C",6,0,0,"G","","","","","mv_par07")
u_InPutSX1(cPerg,"08",PADR("At้ Bordero"        ,20)+"?","","","mv_ch8","C",6,0,0,"G","","","","","mv_par08")

Return
