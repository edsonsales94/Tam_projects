#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR22    บAutor  ณWylliam Silva     				บ Data ณ  12/07/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   	Produtos Reservados do 80  	    	                     			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR22()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR22"

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

	oReport := TReport():New(cPerg,"Produtos Reservados do 80",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Produtos Reservados do 80",{"PED"},aOrdem)  

    TRCell():New(oSection,"FILIAL"	     ,"EAR","Filial","@!",3) 
	TRCell():New(oSection,"LOC"          ,"EAR","Armazem","@!",3)
    TRCell():New(oSection,"PED"	     ,"EAR","Pedido","@!",6)             
	TRCell():New(oSection,"EAR_ITEM"         ,"EAR","Item","@!",3)
	TRCell():New(oSection,"CODIGO"          ,"EAR","Codigo","@!",15)
	TRCell():New(oSection,"DESCRICAO"       ,"EAR","Descricao","@!",35)
	TRCell():New(oSection,"QNT"        ,"EAR","Quant","@E 999,999,999.999",)
    TRCell():New(oSection,"DATA"        ,"EAR","Data Inclusao","@!",10)
	TRCell():New(oSection,"DOC"            ,"SC6","Nota","@!",10)
	TRCell():New(oSection,"SERIE"        ,"SC6","Serie","@!",3)

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
		
    /*SELECT EAR_FILIAL,EAR_PEDIDO,EAR_ITEM,EAR_COD,EAR_DESCRI,'80' ARMAZEM,EAR_QUANT,EAR_DATINC
    FROM EAR
    WHERE CONVERT(VARCHAR,CAST(EAR_DATINC AS DATE),112) BETWEEN  %Exp:MV_PAR01% AND %Exp:MV_PAR02%*/

	SELECT EAR_FILIAL FILIAL ,C6_LOCAL LOC,EAR_PEDIDO PED,EAR_ITEM,EAR_COD CODIGO,EAR_DESCRI DESCRICAO,EAR_QUANT QNT,EAR_DATINC DATA,C6_NOTA DOC, C6_SERIE SERIE
	FROM EAR
	INNER JOIN SC6100 (NOLOCK) SC6 ON C6_NUM = EAR_PEDIDO AND C6_ITEM = EAR_ITEM AND EAR_COD = C6_PRODUTO AND  EAR_DESCRI = C6_DESCRI AND EAR_FILIAL = C6_FILIAL AND SC6.D_E_L_E_T_=''
	WHERE CONVERT(VARCHAR,CAST(EAR_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND C6_LOCAL IN ('80','20')
	ORDER BY CONVERT(VARCHAR,CAST(EAR_DATINC AS DATE),112)



    EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Data Inc:"     ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data Fim:"    ,20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")


Return
