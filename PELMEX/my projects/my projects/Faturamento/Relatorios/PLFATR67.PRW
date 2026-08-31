

#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR67  บAutor  ณJuevan Silva     				บ Data ณ 02/01/25 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Conhecimento de Transp. X NF Entrada                    			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR67()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLFATR67"

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

	oReport := TReport():New(cPerg,"Conhecimento de Transp. X NF Entrada",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Conhecimento de Transp. X NF Entrada",{"SD2"},aOrdem) 

    TRCell():New(oSection,"TRANSPORTADOR"   	      ,"SF8","TRANSPORTADOR","@!",10)
    TRCell():New(oSection,"NOME_TRANSPORTADOR"		    ,"SF8","NOME_TRANSPORTADOR","@!",30)
    TRCell():New(oSection,"FORNECEDOR"		    ,"SF8","FORNECEDOR","@!",30)
    TRCell():New(oSection,"LOJA"		    ,"SF8","LOJA","@!",03)
    TRCell():New(oSection,"NOME_FORNECEDOR"  			,"SF8","NOME_FORNECEDOR","@!",30)
    TRCell():New(oSection,"CONHECIMENTO"		    ,"SF8","CONHECIMENTO","@!",10)
	TRCell():New(oSection,"SERIE"		    ,"SF8","SERIE","@!",03)
    TRCell():New(oSection,"NOTA"		    ,"SF8","NOTA","@!",10)
    TRCell():New(oSection,"SERIE_ORI"		    ,"SF8","SERIE_ORI","@!",03)
    TRCell():New(oSection,"DT_CONHECIMENTO"		    ,"SF8","T_CONHECIMENTO","@!",10)
    //TRCell():New(oSection,"QTD_PERDA"		    ,"PED","QTD_PERDA","@E 999,999,999,999",)
    //TRCell():New(oSection,"DIFERENCA"		    ,"PED","DIFERENCA","@E 999,999,999,999",)
    //TRCell():New(oSection,"NOME"		    ,"PED","NOME","@!",30)
    //TRCell():New(oSection,"CIDADE"		    ,"PED","CIDADE","@!",10)
    //TRCell():New(oSection,"C6_NUM"		     ,"SC6","C6_NUM","@!",7)
	//TRCell():New(oSection,"C6_ITEM"		  ,"SC6","C6_ITEM","@!",3)
    //TRCell():New(oSection,"C6_PRODUTO"	      ,"SC6","PRODUTO","@!",20) 
	//TRCell():New(oSection,"C6_CLI" 	         ,"SC6","C6_CLI","@!",7)
	//TRCell():New(oSection,"A1_NOME"	    ,"SA1","A1_NOME","@!",20)
	//TRCell():New(oSection,"CLIENTE"     	,"SC2","CLIENTE","@!",30) 

	
    
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("PED_QUANT"),"Total Etiqueta:","SUM",,,"@E 999,999,999.999",,.F.,.T.)

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%


SELECT F8_TRANSP TRANSPORTADOR,ISNULL(A4_NOME,'') NOME_TRANSPORTADOR,F8_FORNECE FORNECEDOR,F8_LOJA LOJA,A2_NOME NOME_FORNECEDOR,
       F8_NFDIFRE CONHECIMENTO,F8_SEDIFRE SERIE,F8_NFORIG NOTA,F8_SERORIG SERIE_ORI,
       CONVERT(VARCHAR,CAST(F8_DTDIGIT AS DATE),103) DT_CONHECIMENTO
FROM SF8100 SF8
LEFT JOIN SA4100 SA4 (NOLOCK) ON F8_TRANSP = A4_COD AND SA4.D_E_L_E_T_ = ''
LEFT JOIN SA2100 SA2 (NOLOCK) ON F8_FORNECE = A2_COD AND F8_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ''
WHERE SF8.D_E_L_E_T_ = ''
AND F8_FILIAL = '01'
AND F8_NFORIG BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
ORDER BY F8_DTDIGIT,F8_NFDIFRE,F8_SEDIFRE,F8_NFORIG,F8_SERORIG




		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Nota:",20)+"?","","","mv_ch1","C",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Nota:",20)+"?","","","mv_ch2","C",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
