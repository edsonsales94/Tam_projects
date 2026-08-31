#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR63   บAutor  ณSTAN LEE LOPES    				บ Data ณ  03/06/25 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Previa de Producao dos Travesseiros                        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR63()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR63"

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

	oReport := TReport():New(cPerg,"Previa Travesseiros Pelmex",cPerg,{|oReport| PrintReport(oReport,cAlias)}, "Este relatorio gera a previa dos travesseiros")
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Previa Travesseiros Pelmex",{"PED"},aOrdem) 

	TRCell():New(oSection,"PED_DTPREVIA"		    ,"PED","Dt.Previa","@!",11)
	TRCell():New(oSection,"B1_XSETOR"	            ,"PED","Setor","@!",40)
    TRCell():New(oSection,"PED_PRODUTO"	            ,"PED","Codigo","@!",20)
	TRCell():New(oSection,"PED_DESCRI"	            ,"PED","Descricao","@!",100)
	TRCell():New(oSection,"TOTAL"		            ,"PED","Total","@E 999,999,999.99",)
    TRCell():New(oSection,"B1_XDIMENS"	            ,"PED","Dimensao","@!",30)
	

//SELECT DT_PRODUCAO,DT_PREVIA,DT_PEDIDO,DT_NOTA,NOTA,DT_SAIDA,DT_DEV,PEDIDO,CARGA,OP,ITEM, PRODUTO, DESCRICAO, ARMAZEM,
//QTD_PEDIDO*(B1_XCOMPRI*B1_XLARGUR*B1_XALTURA) TOTAL_M3,QTD_PEDIDO,QTD_APONTADA,
//QTD_ENTRADA,QTD_BIPADA,DIFERENCA,PENDENTE_BIPE,CLIENTE,CIDADE,OBSERVACAO




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


SELECT PED_DTPREVIA,B1_XSETOR,PED_PRODUTO,PED_DESCRI,SUM(PED_QUANT)TOTAL,B1_XDIMENS
FROM(
SELECT PED_FILIAL,PED_DTPROPEL,PED_DTPREVIA,PED_NUM,PED_ITEM,PED_PRODUTO,PED_DESCRI,CAST(PED_QUANT AS FLOAT)PED_QUANT,B1_XDIMENS,PED_CLIENTE,PED_NOME,PED_MUN,B1_XSETOR
FROM PED (NOLOCK)
INNE JOIN SB1100 SB1 (NOLOCK) ON PED_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
WHERE PED_STATUS != 'C'
AND B1_XSETOR NOT LIKE 'CAM%'
AND B1_XSETOR NOT LIKE 'COL%'
AND CONVERT(VARCHAR,CAST(PED_DTPREVIA AS DATE),112) BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
)TB
GROUP BY PED_DTPREVIA,B1_XSETOR,PED_PRODUTO,PED_DESCRI,B1_XDIMENS
ORDER BY B1_XSETOR,B1_XDIMENS


		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Data Previa:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data Previa:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02") 
	//u_InPutSX1(cPerg,"02",PADR("Dt Pelmex Ate:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
