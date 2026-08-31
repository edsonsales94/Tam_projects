#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLEXTR13    บAutor  ณJuevan Carvalho da Silva     				บ Data ณ  14/12/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Confere Manifesto				   	  							 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLEXTR13()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLEXTR13"

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

	oReport := TReport():New(cPerg,"Confere Manifesto",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Confere Manifesto",{"CNF"},aOrdem)  
	
	TRCell():New(oSection,"MANIFESTO"     ,"MAN","MANIFESTO","@!",15)
	TRCell():New(oSection,"PEDIDO"     ,"SC6","PEDIDO","@!",7)
    TRCell():New(oSection,"NOTA"  	   ,"CNF","NOTA","@!",10)
    TRCell():New(oSection,"SERIE"      ,"CNF","SERIE","@!",4)
    TRCell():New(oSection,"QUANTIDADE"      ,"MAN","QUANTIDADE","@E 999,999,999,999",)
    TRCell():New(oSection,"TOTAL"      ,"MAN","TOTAL","@E 999,999,999,999.99",)
    TRCell():New(oSection,"LACRE"      ,"CNF","LACRE","@!",9)
    TRCell():New(oSection,"DTMANI"     ,"MAN","DTMANI","@!",10)
    TRCell():New(oSection,"PLACA"     ,"CNF","PLACA","@!",9)
    TRCell():New(oSection,"MOTORISTA"   ,"CNF","MOTORISTA","@!",60)
    TRCell():New(oSection,"CLIENTE"      ,"CNF","CLIENTE","@!",12)
    TRCell():New(oSection,"NOME"      ,"CNF","NOME","@!",30)
    TRCell():New(oSection,"CIDADE"    ,"MAN","CIDADE","@!",30)

		
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("ETIQUETA"),"Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)

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
		
SELECT MAN_CODMAN MANIFESTO, C6_NUM PEDIDO,CNF_DOC NOTA, CNF_SERIE SERIE, MAN_QUANT QUANTIDADE, MAN_TOTAL TOTAL, CNF_LACRE LACRE, CONVERT(VARCHAR,CAST(MAN_DATINC AS DATE),112) DTMANI, CNF_PLACA PLACA, CNF_MOTORISTA MOTORISTA, A1_COD CLIENTE, CNF_NOME NOME, MAN_CIDADE CIDADE
 FROM CNF
 LEFT JOIN MAN ON MAN_DOC = CNF_DOC AND MAN_SERIE = CNF_SERIE AND MAN_CLIENTE = CNF_CLIENTE
 INNER JOIN SA1100 SA1 ON A1_COD = CNF_CLIENTE AND SA1.D_E_L_E_T_ = ''
 INNER JOIN SC6100 SC6 ON C6_NOTA = CNF_DOC AND C6_SERIE = CNF_SERIE AND C6_FILIAL = CNF_FILIAL AND C6_CLI = CNF_CLIENTE AND C6_LOJA = CNF_LOJA AND SC6.D_E_L_E_T_ = ''
 WHERE MAN_CLIENTE  BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
 GROUP BY MAN_CODMAN,C6_NUM,CNF_DOC, CNF_SERIE , MAN_QUANT, MAN_TOTAL, CNF_LACRE,MAN_DATINC, CNF_PLACA, CNF_MOTORISTA, A1_COD, CNF_NOME, MAN_CIDADE
 

 
			
	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)
u_InPutSX1(cPerg,"01",PADR("De Cliente    ",20)+"?","","","mv_ch1","C",6,0,0,"G","","","","","mv_par01")  
u_InPutSX1(cPerg,"02",PADR("Ate Cliente   ",20)+"?","","","mv_ch2","C",6,0,0,"G","","","","","mv_par02") 
	

Return
