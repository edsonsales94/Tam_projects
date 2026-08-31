#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR39   บAutor  ณStan Lee Lopes     				บ Data ณ  03/01/24 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Rel. Previas Producao                      			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR39()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR39"

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

	oReport := TReport():New(cPerg,"Rel. Previas Producao",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Previas Producao",{"PED"},aOrdem) 


    TRCell():New(oSection,"PED_EMISSAO"   	     ,"PED","Dt.Pedido","@!",15)
	TRCell():New(oSection,"PED_ENTREG"		      ,"PED","Dt.Entrega","@!",15)
	TRCell():New(oSection,"PED_NUM"		     ,"PED","Pedido","@!",30)
    TRCell():New(oSection,"PED_OP"		   ,"PED","OP","@!",15)  
	TRCell():New(oSection,"PED_DTPROPEL"		    ,"PED","Dt.Prooducao","@!",15)
    TRCell():New(oSection,"PED_DTPREVIA"	     ,"PED","Dt.Previa","@!",15)    
	TRCell():New(oSection,"PED_ITEM"			    ,"PED","Item","@!",5)
	TRCell():New(oSection,"PED_PRODUTO"        ,"PED","Produto","@!",15)
	TRCell():New(oSection,"PED_DESCRI" 	,"PED","Descricao","@!",30) 
	TRCell():New(oSection,"PED_QUANT"	,"PED","Quantidade","@@E 999,999,999.999",15) 
	TRCell():New(oSection,"PED_TOTAL"	,"PED","Total","@@E 999,999,999.999",15)
	TRCell():New(oSection,"TOTALM3"	    ,"PED","Total M3","@@E 999,999,999.999",15)  
    TRCell():New(oSection,"PED_CLIENTE"	,"PED","Cliente","@!",10) 
    TRCell():New(oSection,"PED_NOME"	,"PED","Nome","@!",30) 
    TRCell():New(oSection,"PED_MUN"	    ,"PED","Cidade","@!",30) 
	TRCell():New(oSection,"B1_XSETOR"	    ,"PED","Setor","@!",30) 
	//TRCell():New(oSection,"CARGA"  			,"SC2","CARGA","@!",12)
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


SELECT CONVERT(VARCHAR,CAST(PED_EMISSAO AS DATE),103)PED_EMISSAO,CONVERT(VARCHAR,CAST(PED_ENTREG AS DATE),103)C6_ENTREG,
       PED_NUM,PED_OP,PED_DTPROPEL,PED_DTPREVIA,PED_ITEM,PED_PRODUTO,PED_DESCRI,PED_QUANT,PED_TOTAL,PED_CLIENTE,PED_NOME,PED_MUN,
       B1_XLARGUR,B1_XALTURA, B1_XCOMPRI,(B1_XLARGUR*B1_XALTURA*B1_XCOMPRI)*PED_QUANT TOTALM3,B1_XSETOR
FROM PED (NOLOCK)
INNER JOIN SB1100 SB1 (NOLOCK) ON PED_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
WHERE PED_STATUS != 'C'
AND PED_OP = ''
AND CONVERT(VARCHAR,CAST(PED_DTPREVIA AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
ORDER BY PED_NUM,PED_OP,PED_ITEM


		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Dt.Previsao:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Dt.Previsao:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
