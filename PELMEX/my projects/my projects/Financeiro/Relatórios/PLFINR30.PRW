#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFINR29    ºAutor  ³Wylliam Silva     				º Data ³ 08/04/2022º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Titulos nao Conciliados SITEF                		     			 	 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLFINR30()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR30"

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

	oReport := TReport():New(cPerg,"Titulos nao Conciliados SITEF",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Titulos nao Conciliados SITEF",{"CCT"},aOrdem)
	
		   
	TRCell():New(oSection,"CCT_NSU"	 	    ,"CCT","NSU","@!",6) 
	TRCell():New(oSection,"CCT_AUTORIZ"	 	,"CCT","AUTORIZ","@!",15) 
	TRCell():New(oSection,"CCT_PARCELA"	    ,"CCT","PARCELA","@!",4)
	TRCell():New(oSection,"CCT_VALOR"	    ,"CCT","VALOR","@E 9,999,999,999.999",)
	TRCell():New(oSection,"CCT_EMISSAO"	    ,"CCT","EMISSAO","@!",10)
	TRCell():New(oSection,"CCT_VENCTO"	  	,"CCT","VENCIMENTO","@!",10)
	TRCell():New(oSection,"CCT_BANCO"	  	,"CCT","BANCO","@!",5)
	TRCell():New(oSection,"CCT_AGENCIA"		,"CCT","AGENCIA","@!",8)
	TRCell():New(oSection,"CCT_CONTA"	 	,"CCT","CONTA","@!",10)
            
	

	//Segunda seção
	//oSection2 := TRSection():New(oReport,"TOTAL GERAL RECEBER X NOTAS FISCAIS",{"SE1"},aOrdem)  

	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("VAL_RECEBER"),"TOTAL Recebido","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("VAL_PAGAR"),"TOTAL Pagar","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("DIFERENCA"),"Diferenca","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//oReport:SetTotalInLine(.F.)

	//Quebra por Seção
	//oSection1:SetPageBreak(.T.)
	//oSection1:SetTotalText(" ")

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

	SELECT CCT_NSU,CCT_AUTORIZ,CCT_PARCELA,CCT_VALOR,CONVERT(VARCHAR,CAST(CCT_EMISSAO AS DATE),103) CCT_EMISSAO,CONVERT(VARCHAR,CAST(CCT_VENCTO AS DATE),103) CCT_VENCTO,CCT_BANCO,CCT_AGENCIA,CCT_CONTA
			FROM CCT
			LEFT JOIN SE1100 SE1 (NOLOCK) ON CCT_NSU = E1_NSUTEF AND CCT_PARCELA = E1_PARCELA AND SE1.D_E_L_E_T_ = '' AND E1_SALDO > 0
			WHERE E1_NSUTEF IS NOT NULL	
		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
		 
Return


Static Function AjustaSX1(cPerg)

/*u_InPutSX1(cPerg,"01",PADR("De Emissão "      ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Até Emissão "     ,20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
u_InPutSX1(cPerg,"03",PADR("De Filial "       ,20)+"?","","","mv_ch3","C",2,0,0,"G","","","","","mv_par03") 
u_InPutSX1(cPerg,"04",PADR("Até Filial "      ,20)+"?","","","mv_ch4","C",2,0,0,"G","","","","","mv_par04")*/
   

Return
