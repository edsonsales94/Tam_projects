#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR29    บAutor  ณWylliam Silva     				บ Data ณ 08/04/2022บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Diferen็a extrato Boa Vista e Protheus         		     			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR31()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR31"

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

	oReport := TReport():New(cPerg,"Diferen็a extrato Boa Vista e Protheus",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Diferen็a extrato Boa Vista e Protheus",{"CCT"},aOrdem)
	
		   
	TRCell():New(oSection,"CCT_NSU"	 	    ,"CCT","NSU","@!",10)
	TRCell():New(oSection,"CCT_AUTORIZ"	    ,"CCT","AUTORIZACAO","@!",10) 
	TRCell():New(oSection,"CCT_PARCELA"	    ,"CCT","PARCELA","@!",4)
	TRCell():New(oSection,"CCT_VALOR"	    ,"CCT","VALOR","@E 9,999,999,999.999",)
	TRCell():New(oSection,"CCT_EMISSAO"	    ,"CCT","EMISSAO","@!",10)
	TRCell():New(oSection,"CCT_VENCTO"	  	,"CCT","VENCIMENTO","@!",10)
	TRCell():New(oSection,"E1_BAIXA"	  	,"SE1","BAIXA SISTEMA","@!",10)
	TRCell():New(oSection,"CCT_BANCO"	  	,"CCT","BANCO","@!",5)
	TRCell():New(oSection,"CCT_AGENCIA"		,"CCT","AGENCIA","@!",8)
	TRCell():New(oSection,"CCT_CONTA"	 	,"CCT","CONTA","@!",10)
	TRCell():New(oSection,"E1_PORTADO"	  	,"SE1","BANCO SISTEMA","@!",5)
	TRCell():New(oSection,"E1_AGEDEP"		,"SE1","AGENCIA SISTEMA","@!",8)
	TRCell():New(oSection,"E1_CONTA"	 	,"SE1","CONTA SISTEMA","@!",10)
            
	

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
SELECT CCT_NSU,CCT_AUTORIZ,CCT_PARCELA,CCT_VALOR,
       CONVERT(VARCHAR,CAST(CCT_EMISSAO AS DATE),103) CCT_EMISSAO,
       CONVERT(VARCHAR,CAST(CCT_VENCTO AS DATE),103) CCT_VENCTO,
       E1_BAIXA,E1_PORTADO,E1_AGEDEP,E1_CONTA,CCT_BANCO,CCT_AGENCIA,CCT_CONTA
FROM CCT (NOLOCK)
LEFT JOIN SE1100 SE1 (NOLOCK) ON CCT_NSU = REPLACE(REPLACE(E1_NSUTEF,CHAR(10),''),CHAR(13),'') AND CCT_PARCELA = E1_PARCELA AND SE1.D_E_L_E_T_ = ''
WHERE ISNULL(REPLACE(REPLACE(E1_NSUTEF,CHAR(10),''),CHAR(13),''),'') = ''	
ORDER BY CCT_NSU,CCT_PARCELA
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
		 
Return


Static Function AjustaSX1(cPerg)

/*u_InPutSX1(cPerg,"01",PADR("De Emissใo "      ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("At้ Emissใo "     ,20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
u_InPutSX1(cPerg,"03",PADR("De Filial "       ,20)+"?","","","mv_ch3","C",2,0,0,"G","","","","","mv_par03") 
u_InPutSX1(cPerg,"04",PADR("At้ Filial "      ,20)+"?","","","mv_ch4","C",2,0,0,"G","","","","","mv_par04")*/
   

Return
