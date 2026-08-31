#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLESTR31    ºAutor  ³Wylliam Silva    	    			º Data ³  26/04/23 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rel. SaldoSistemXInventario     						  					 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLESTR31()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLESTR31"

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

	oReport := TReport():New(cPerg,"Rel. SaldoSistemXInventario",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Rel. SaldoSistemXInventario",{"SB2"},aOrdem)  

	TRCell():New(oSection,"B2_FILIAL"		,"SB2","FILIAL","@!",3)           
	TRCell():New(oSection,"DOCUMENTO" 	    ,"COL","DOC_INVENT","@!",9) 
	TRCell():New(oSection,"DT_INVENTARIO"   ,"COL","DT_INVENT","@!",10)
	TRCell():New(oSection,"B2_COD"  		,"SB2","CODIGO","@!",15)
    TRCell():New(oSection,"B1_DESC"    	    ,"SB1","DESCRI","@!",35) 
    TRCell():New(oSection,"B1_UM"    	    ,"SB1","UM","@!",3)
    TRCell():New(oSection,"B2_LOCAL"    	,"SB2","ARMAZ","@!",3) 
	TRCell():New(oSection,"QTD_SISTEMA"    	,"SB2","QTD_SISTEMA","@E 999,999,999.99",)  
    TRCell():New(oSection,"QTD_INVENTARIO"  ,"COL","QTD_INVENT","@E 999,999,999.99",)
    TRCell():New(oSection,"DIFERENCA"    	,"SB2","DIFERENCA","@E 999,999,999.99",) 
   
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

    SELECT B2_FILIAL,
        ISNULL(COL_DOC,'')DOCUMENTO,
        ISNULL(COL_DATINC,'')DT_INVENTARIO,B2_COD,B1_DESC,B1_UM,B2_LOCAL,B2_QATU QTD_SISTEMA,
        CAST(ISNULL(COL_QUANT,0) AS FLOAT)QTD_INVENTARIO,
        B2_QATU - CAST(ISNULL(COL_QUANT,0) AS FLOAT) DIFERENCA
        FROM %Table:SB2% SB2 (NOLOCK)
        INNER JOIN %Table:SB1% SB1 (NOLOCK) ON B2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
        LEFT JOIN (
            SELECT COL_EMPRESA,COL_FILIAL,COL_DOC,COL_DATINC,COL_COD,COL_DESC,COL_LOCAL,SUM(COL_QUANT)COL_QUANT
            FROM(
                    SELECT COL_EMPRESA,COL_FILIAL,COL_DOC,COL_DATINC,COL_HORINC,
                        COL_COD,COL_DESC,COL_LOCAL,COL_QUANT
                    FROM COLINV
                    WHERE COL_EMPRESA = %Exp:MV_PAR01%
                    AND COL_LOCAL = %Exp:MV_PAR02%
                    AND COL_DOC = %Exp:MV_PAR03%
                    )TB
            GROUP BY COL_EMPRESA,COL_FILIAL,COL_COD,COL_DESC,COL_LOCAL,COL_DOC,COL_DATINC)COL ON B2_FILIAL = COL_FILIAL AND B2_COD = COL_COD AND B2_LOCAL = COL_LOCAL
        WHERE SB2.D_E_L_E_T_ = ''
        AND (B2_QATU > 0
        OR CAST(ISNULL(COL_QUANT,0) AS FLOAT) > 0)
        AND B2_FILIAL = %Exp:MV_PAR04%
        AND B2_LOCAL = %Exp:MV_PAR02%
        ORDER BY DOCUMENTO DESC,B1_DESC

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Empresa:" ,20)+"?","","","mv_ch1","C",2,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Armazem:",20)+"?","","","mv_ch2","C",2,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Doc. Invent:" ,20)+"?","","","mv_ch3","C",9,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Filial:",20)+"?","","","mv_ch4","C",2,0,0,"G","","","","","mv_par04")

Return
