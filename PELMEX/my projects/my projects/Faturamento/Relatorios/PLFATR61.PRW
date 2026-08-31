
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR61  บAutor  ณJuevan Silva     				บ Data ณ 28/11/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Notas Protocoladas Sem Emissao                    			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR61()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLFATR61"

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

	oReport := TReport():New(cPerg,"Notas Protocoladas Sem Emissao",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Notas Protocoladas Sem Emissao",{"SD2"},aOrdem) 

    TRCell():New(oSection,"PTC_DOC"   	    ,"PTC","NOTA","@!",10)
     TRCell():New(oSection,"PTC_SERIE"		    ,"PTC","SERIE","@!",3)
     TRCell():New(oSection,"PTC_DTNOTA"		    ,"PTC","DTNOTA","@!",10)
     TRCell():New(oSection,"PTC_DATINC"		    ,"PTC","DTINC","@!",10)
    TRCell():New(oSection,"A1_COD"  			,"SA1","CODIGO","@!",15)
     TRCell():New(oSection,"A1_NOME"		    ,"SA1","NOME","@!",20)
	TRCell():New(oSection,"A1_MUN"		    ,"SA1","CIDADE",,10)
   //TRCell():New(oSection,"C6_VALOR"		    ,"SC6","VALOR","@E 999,999,999,999",)
    //TRCell():New(oSection,"A1_NOME"		    ,"SA1","NOME","@!",20)
    //TRCell():New(oSection,"D2_TES"		    ,"SD2","TES","@!",20)
   //TRCell():New(oSection,"F4_TEXTO"		    ,"SF4","Descricao TES","@!",20)
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

SELECT PTC_DOC,PTC_SERIE,PTC_DTNOTA,PTC_DATINC,A1_COD,A1_NOME,A1_MUN
FROM PTC
INNER JOIN SD2100 SD2 ON PTC_FILIAL = D2_FILIAL AND PTC_EMPRESA = '10' AND PTC_DOC = D2_DOC AND PTC_SERIE = D2_SERIE AND SD2.D_E_L_E_T_ = ''
INNER JOIN SA1100 SA1 ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
LEFT JOIN SD1100 SD1 ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
LEFT JOIN CNF ON PTC_FILIAL = CNF_FILIAL AND PTC_EMPRESA = '10' AND PTC_DOC = CNF_DOC AND PTC_SERIE = CNF_SERIE
WHERE CONVERT(VARCHAR,CAST(PTC_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND CNF_DOC IS NULL
AND D1_DOC IS NULL
GROUP BY PTC_DOC,PTC_SERIE,PTC_DTNOTA,PTC_DATINC,A1_COD,A1_NOME,A1_MUN
ORDER BY A1_MUN,PTC_DOC,PTC_SERIE

		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Emissao:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Dt Emissao:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
