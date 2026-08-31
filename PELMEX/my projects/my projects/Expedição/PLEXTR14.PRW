#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLEXTR14    บAutor  ณWylliam Silva     				บ Data ณ  31/05/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ DIVERGENCIA DE CARGA POR NOTA			   	  							 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLEXTR14()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLEXTR14"

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

	oReport := TReport():New(cPerg,"DIVERGENCIA DE CARGA POR NOTA",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"DIVERGENCIA DE CARGA POR NOTA",{"SAI"},aOrdem)  
	
	TRCell():New(oSection,"C2_XCARGA"    		,"SC2","CARGA","@!",9)
	TRCell():New(oSection,"SAI_DOC"  			,"SAI","NOTA","@!",15)
	TRCell():New(oSection,"TOTAL"  			    ,"SAI","TOTAL","@E 999,999,999,999.99",)
	/*TRCell():New(oSection,"NOTA"   		    ,"SD2","Nota","@!",20)
	TRCell():New(oSection,"SERIE"   		    ,"SD2","Serie","@!",6)
	TRCell():New(oSection,"QTD_NOTA"            ,"SD2","Qtd.Nota","@E 999,999,999,999",)
	TRCell():New(oSection,"TOTAL"               ,"SD2","Total Nota","@E 999,999,999,999.99",)
	TRCell():New(oSection,"QTD_BIPE"            ,"SD2","Qtd.Bipe","@E 999,999,999,999",)
	TRCell():New(oSection,"DIFERENCA"           ,"SD2","Diferenca","@E 999,999,999,999",)
	TRCell():New(oSection,"DT_SAIDA"   		    ,"CNF","Dt.Saida","@!",15)
	TRCell():New(oSection,"DT_BIPE"   		    ,"SAI","Dt.Bipe","@!",15)
	TRCell():New(oSection,"NOME"   		        ,"SA1","Nome","@!",50)
	TRCell():New(oSection,"CIDADE"   		    ,"SA1","Cidade","@!",30)*/
		
	
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

    SELECT C2_XCARGA,SAI_DOC,SUM(SAI_QUANT)TOTAL
    FROM SAI
    INNER JOIN SC2100 SC2 (NOLOCK) ON SUBSTRING(SAI_CPRODUC,1,11) = C2_NUM+C2_ITEM+C2_SEQUEN AND SAI_PRODUTO = C2_PRODUTO AND SC2.D_E_L_E_T_ = ''
    WHERE SAI_DOC BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
    GROUP BY C2_XCARGA,SAI_DOC
    ORDER BY C2_XCARGA,SAI_DOC


	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Nota:",20)+"?","","","mv_ch1","C",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Nota:",20)+"?","","","mv_ch2","C",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("Usuario:" ,20)+"?","","","mv_ch3","C",4,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	

Return
