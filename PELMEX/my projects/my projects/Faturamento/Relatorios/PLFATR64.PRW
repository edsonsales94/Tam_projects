
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR64  บAutor  ณJuevan Silva     				บ Data ณ 28/05/24 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Entrada Portaria x Entrada NFE                    			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR64()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLFATR64"

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

	oReport := TReport():New(cPerg,"Entrada Portaria x Entrada NFE",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Entrada Portaria x Entrada NFE",{"SD2"},aOrdem) 

     TRCell():New(oSection,"EMPRESA"   	      ,"PO1","EMPRESA","@!",02)
     TRCell():New(oSection,"FILIAL"		    ,"PO1","FILIAL","@!",02)
     TRCell():New(oSection,"INCLUSAO"	   ,"PO1","INCLUSAO","@!",10)
     TRCell():New(oSection,"HORA"		    ,"PO1","HORA","@!",10)
     TRCell():New(oSection,"CNPJ"  			,"PO1","CNPJ","@!",12)
     TRCell():New(oSection,"DOC"		    ,"PO1","DOC","@!",10)
	 TRCell():New(oSection,"SERIE"		    ,"PO1","SERIE",,03)
    TRCell():New(oSection,"CHAVE"		    ,"PO1","CHAVE","@!",50)
    TRCell():New(oSection,"NOME"		    ,"PO1","NOME","@!",30)
    TRCell():New(oSection,"STATUS"		    ,"PO1","STATUS","@!",20)
    TRCell():New(oSection,"USUARIO"		    ,"PO1","USUARIO","@!",30)
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


SELECT P01_EMPRESA EMPRESA,P01_FILIAL FILIAL,P01_DATINC INCLUSAO ,P01_HORINC HORA,P01_CNPJ CNPJ,P01_DOC DOC,
       P01_SERIE SERIE, P01_CHAVE CHAVE,A2_NOME NOME,
       CASE WHEN F1_CHVNFE IS NULL THEN 'PENDENTE DE ENTRADA' ELSE 'ENTRADA REALIZADA' END STATUS,
     P01_USERINC USUARIO
FROM P01 (NOLOCK)
LEFT JOIN SF1100 SF1 (NOLOCK) ON P01_FILIAL = F1_FILIAL AND P01_DOC = F1_DOC AND CASE WHEN (P01_SERIE != 'UNR' OR P01_SERIE != 'UNI') THEN CAST(P01_SERIE AS INT) ELSE P01_SERIE END = CASE WHEN (P01_SERIE != 'UNR' OR P01_SERIE != 'UNI') THEN CAST(F1_SERIE AS INT) ELSE P01_SERIE END AND SF1.D_E_L_E_T_ = '' AND F1_SERIE NOT IN ('UNI')
LEFT JOIN SD1100 SD1 (NOLOCK) ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND SD1.D_E_L_E_T_ = ''
LEFT JOIN SA2100 SA2 (NOLOCK) ON CASE WHEN P01_CNPJ != '' THEN P01_CNPJ ELSE F1_FORNECE END = CASE WHEN P01_CNPJ != '' THEN A2_CGC ELSE A2_COD END AND A2_MSBLQL != '1' AND SA2.D_E_L_E_T_ = ''
WHERE CONVERT(VARCHAR,CAST(P01_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND F1_CHVNFE IS NULL
AND P01_DOC != ''
GROUP BY P01_EMPRESA,P01_FILIAL,P01_DATINC,P01_HORINC,P01_CNPJ,P01_DOC,P01_SERIE,P01_CHAVE,A2_NOME,F1_CHVNFE,P01_USERINC



		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Entrada:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Entrada:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
