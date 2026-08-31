#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR29    บAutor  ณWylliam Silva     				บ Data ณ 08/04/2022บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio Contas a Receber                  		     			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR32()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR32"

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

	oReport := TReport():New(cPerg,"Relat๓rio Contas a Receber",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Relat๓rio Contas a Receber",{"SE1"},aOrdem)
	
		   
	TRCell():New(oSection,"E1_NSUTEF"	    ,"CCT","NSUTEF","@!",15) 
	TRCell():New(oSection,"DT_VENCTO"	    ,"SE1","DT_VENCIMENTO","@!",10)
	TRCell():New(oSection,"DT_BAIXA"	    ,"SE1","DT_BAIXA","@!",10)
	TRCell():New(oSection,"E1_TIPO"	    	,"SE1","TIPO","@!",5)
	TRCell():New(oSection,"E1_NUM"	  		,"SE1","NUM TITULO","@!",15)
	TRCell():New(oSection,"E1_PREFIXO"	  	,"SE1","PREFIXO","@!",5)
	TRCell():New(oSection,"E1_PARCELA"		,"SE1","PARCELA","@!",4)
	TRCell():New(oSection,"E1_VALOR"	 	,"SE1","VALOR","@E 9,999,999,999.99",)
    TRCell():New(oSection,"E1_DESCONT"		,"SE1","DESCONTO","@E 9,999,999,999.99",)       
	TRCell():New(oSection,"E1_VALLIQ"		,"SE1","VALOR LIQUIDO","@E 9,999,999,999.99",)
	TRCell():New(oSection,"E1_NOMCLI"		,"SE1","CLIENTE","@!",30)  

	//Segunda se็ใo
	//oSection2 := TRSection():New(oReport,"TOTAL GERAL RECEBER X NOTAS FISCAIS",{"SE1"},aOrdem)  

	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("VAL_RECEBER"),"TOTAL Recebido","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("VAL_PAGAR"),"TOTAL Pagar","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("DIFERENCA"),"Diferenca","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//oReport:SetTotalInLine(.F.)

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

			SELECT E1_NSUTEF,CONVERT(VARCHAR,CAST(E1_VENCTO AS DATE),103)DT_VENCTO,CONVERT(VARCHAR,CAST(E1_BAIXA AS DATE),103)DT_BAIXA,
			       E1_TIPO,E1_NUM,E1_PREFIXO,E1_PARCELA,E1_VALOR,E1_DESCONT,E1_VALLIQ,E1_NOMCLI
			FROM SE1100 SE1
			WHERE SE1.D_E_L_E_T_ = ''
			AND E1_TIPO IN ('CC','CD')
			AND E1_BAIXA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
			
			ORDER BY E1_VENCTO,E1_NSUTEF,E1_PARCELA
		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
		 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De DT Baixa "      ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("At้ DT Baixa "     ,20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
//u_InPutSX1(cPerg,"03",PADR("De Filial "       ,20)+"?","","","mv_ch3","C",2,0,0,"G","","","","","mv_par03") 
//u_InPutSX1(cPerg,"04",PADR("At้ Filial "      ,20)+"?","","","mv_ch4","C",2,0,0,"G","","","","","mv_par04")
   

Return