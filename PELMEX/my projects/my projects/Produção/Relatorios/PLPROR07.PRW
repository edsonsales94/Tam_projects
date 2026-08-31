#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR07    บAutor  ณWylliam Silva     				บ Data ณ  24/03/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   	Produ็ใo Fechamento X Insp final                        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR07()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR07"

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

	oReport := TReport():New(cPerg,"Produ็ใo Fechamento X Insp final",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Produ็ใo Fechamento X Insp final",{"CLA"},aOrdem)  

	TRCell():New(oSection,"CHIP"			,"CLA","CHIP","@!",15)
	TRCell():New(oSection,"CODIGO"			,"CLA","CODIGO","@!",15) 
	TRCell():New(oSection,"DESCRICAO"		,"CLA","DESCRICAO","@!",30)   
	TRCell():New(oSection,"QTD"				,"CLA","QTD","@E 999,999,999,999",)
	TRCell():New(oSection,"DTFECHADO"  		,"CLA","DTFECHADO","@!",8)
	TRCell():New(oSection,"HORAFECHADA"  	,"CLA","HORAFECHADA","@!",8)
	TRCell():New(oSection,"DTINPFINAL"		,"SGQ","DTINPFINAL","@!",8)         
	TRCell():New(oSection,"SGQ_HORAINC"		,"SGQ","SGQ_HORAINC","@!",8)
	
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

		SELECT CLA_CPRODUC CHIP,CLA_COD CODIGO,B1_DESC DESCRICAO,CAST(CLA_QUANT AS INT) QTD,CLA_DATINC DTFECHADO,CLA_HORINC HORAFECHADA,SGQ_DATINC DTINPFINAL,SGQ_HORAINC
				FROM CLA
				LEFT JOIN (SELECT SGQ_PRODUTO,SGQ_QUANT,SGQ_DATINC,SGQ_DTFECHA,SGQ_CPRODUC,SGQ_HORAINC
				            FROM SGQ
				            WHERE CONVERT(VARCHAR, CAST(SGQ_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% ) SGQ ON SGQ_CPRODUC = CLA_CPRODUC 
				LEFT JOIN SB1100  SB1 ON B1_COD = CLA_COD AND SB1.D_E_L_E_T_ = '' 
				WHERE CONVERT(VARCHAR, CAST(CLA_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
				AND CLA_COD NOT LIKE 'CAM%'
				ORDER BY HORAFECHADA
		
		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt Insp. Final:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("At้ Dt Insp. Final:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	
	
Return