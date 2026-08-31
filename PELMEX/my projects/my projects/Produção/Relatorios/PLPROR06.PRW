#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR06    บAutor  ณWylliam Silva     				บ Data ณ  24/03/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   	Rel. Nใo Conformidade Insp. Final                         			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR06()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR06"

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

	oReport := TReport():New(cPerg,"Rel. Nใo Conformidade Insp. Final",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Nใo Conformidade Insp. Final",{"SGQ"},aOrdem)  

	TRCell():New(oSection,"SGQ_FILIAL"		,"SGQ","FILAL","@!",6)
	TRCell():New(oSection,"MATRICULA"		,"SGQ","MATRICULA","@!",5) 
	TRCell():New(oSection,"NOMEFUNC"		,"SGQ","NOME FUNC","@!",30)   
	TRCell():New(oSection,"RFID"			,"SGQ","CHIP","@!",20)
	TRCell():New(oSection,"COSTUREIRO"  	,"SGQ","COSTUREIRO","@!",30)
	TRCell():New(oSection,"SGQ_ANTENA"		,"SGQ","ANTENA","@!",5)         
	TRCell():New(oSection,"DTFECHAMENTO"  	,"SGQ","DT FECHAMENTO","@!",10)
	TRCell():New(oSection,"PRODUTO"			,"SGQ","PRODUTO","@!",15)
	TRCell():New(oSection,"DESCRICAO"  		,"SGQ","DESCRICAO","@!",30)
	TRCell():New(oSection,"CENTRO"  		,"SGQ","CENTRO","@!",20)
	TRCell():New(oSection,"SGQ_QUANT"		,"SGQ","QTD","@E 999,999,999,999",)
	TRCell():New(oSection,"ITEM"  			,"SGQ","ITEM","@!",20)
	TRCell():New(oSection,"CONFORMIDADE"	,"SGQ","CONFORMIDADE","@!",20) 
	TRCell():New(oSection,"DISPOSICAO"		,"SGQ","DISPOSICAO","@!",20)
	TRCell():New(oSection,"DTINCLUSA"		,"SGQ","DT INCLUSAO","@!",8)
	
	
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

		SELECT SGQ_FILIAL,SGQ_MAT MATRICULA, SGQ_NOME NOMEFUNC,SGQ_CPRODUC RFID, SGQ_FECHADOR COSTUREIRO, SGQ_ANTENA, SGQ_DTFECHA DTFECHAMENTO, SGQ_PRODUTO PRODUTO,SGQ_DESC DESCRICAO,SGQ_CTRAB CENTRO,
                SGQ_ITEM ITEM, CASE WHEN SGQ_CONFORME = '' THEN 'SIM' ELSE SGQ_CONFORME END CONFORMIDADE, SGQ_DISPOSI DISPOSICAO, SGQ_DATINC DTINCLUSA, SGQ_QUANT
        FROM SGQ
        WHERE CONVERT(VARCHAR,CAST(SGQ_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
        ORDER BY SGQ_DATINC,SGQ_HORAINC
		
		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt Insp. Final:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("At้ Dt Insp. Final:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	
	
Return