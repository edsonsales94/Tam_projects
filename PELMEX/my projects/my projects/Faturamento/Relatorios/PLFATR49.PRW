
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR49    บAutor  ณJuevan Silva     				บ Data ณ  26/10/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Pesq. Saida de Nota por Pedido										 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR49()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR49"

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

	oReport := TReport():New(cPerg," Pesq. Saida de Nota por Pedido ",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport," Pesq. Saida de Nota por Pedido	",{"SAI"},aOrdem) 

    TRCell():New(oSection,"D2_PEDIDO"    	,"SD2","PEDIDO","@!",8)
    TRCell():New(oSection,"SAI_DOC"  	,"SAI","DOCUMENTO","@!",10)
    TRCell():New(oSection,"SAI_SERIE"   	,"SAI","SERIE","@!",4)
    TRCell():New(oSection,"SAI_EMISSAO"   	,"SAI","EMISSAO","@!",12)
    TRCell():New(oSection,"SAI_PRODUTO"    	,"SAI","CODIGO","@!",30)
    TRCell():New(oSection,"SAI_DESCPROD"    	,"SAI","DESC","@!",60)
    TRCell():New(oSection,"SAI_QUANT"    	,"SAI","QUANTIDADE","@E 999,999,999,999",10)
     TRCell():New(oSection,"SAI_DTEXP"    	,"SAI","DT EXPEDICAO","@!",40)
    TRCell():New(oSection,"SAI_CLIENTE"    	,"SAI","CLIENTE","@!",40)
    TRCell():New(oSection,"SAI_NOME"    	,"SAI","NOME","@!",40)
    

	//Totalizador
	/*                                                                                  
	TRFunction():New(oSection:Cell("L2_VLRITEM"),"TOTAL BASE","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)  
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

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
SELECT D2_PEDIDO,SAI_DOC,SAI_SERIE,SAI_EMISSAO,SAI_ITEM,SAI_PRODUTO,SAI_DESCPROD,SAI_QUANT,SAI_DTEXP,SAI_CLIENTE,SAI_NOME
FROM SAI
INNER JOIN SD2100 SD2 (NOLOCK) ON SAI_FILIAL = D2_FILIAL AND SAI_DOC = D2_DOC AND SAI_SERIE = D2_SERIE AND SAI_ITEM = D2_ITEM AND SAI_PRODUTO = D2_COD AND SD2.D_E_L_E_T_ = ''
WHERE SAI_DOC IN (SELECT D2_DOC
          FROM SD2100 SD2
          WHERE SD2.D_E_L_E_T_ = ''
          AND D2_PEDIDO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR01% )
ORDER BY SAI_DOC,SAI_ITEM

EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return

Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("Pedido ",20)+"?","","","mv_ch1","C",6,0,0,"G","","","","","mv_par01") 



Return
