#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR19    ºAutor  ³Wylliam Silva     				º Data ³  30/06/23 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   	Analise compra de tecido Pelmex X Amazon    	    	  			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR19()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR19"

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

	oReport := TReport():New(cPerg,"Analise compra de tecido Pelmex X Amazon",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Analise compra de tecido Pelmex X Amazon",{"SB2"},aOrdem)  
	

    TRCell():New(oSection,"COMP_PEL"	     ,"SB2","COMP_PEL","@!",15) 
    TRCell():New(oSection,"DESCRI_PEL"	     ,"SB1","DESCRI_PEL","@!",35)             
	TRCell():New(oSection,"UM_PEL"           ,"SB1","UM_PEL","@!",3)
	TRCell():New(oSection,"QTD_PELMEX"       ,"SB2","QTD_PELMEX","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_AMAZ"         ,"SB2","QTD_AMAZ","@E 999,999,999.999",)
	TRCell():New(oSection,"COMP_AMA"         ,"SB1","COMP_AMA","@!",15)
	TRCell():New(oSection,"DESCRI_AMA"       ,"SB1","DESCRI_AMA","@!",35)
	TRCell():New(oSection,"UM_AMA"           ,"SB1","UM_AMA","@!",3)

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
		
        SELECT SB2.B2_COD COMP_PEL,SB1.B1_DESC DESCRI_PEL,SB1.B1_UM UM_PEL,SB2.B2_QATU QTD_PELMEX,SB22.B2_QATU QTD_AMAZ,SB12.B1_COD COMP_AMA,SB12.B1_DESC DESCRI_AMA,SB12.B1_UM UM_AMA
        FROM SB2100 SB2 (NOLOCK)
        INNER JOIN SB1100 SB1 (NOLOCK) ON SB2.B2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = '' AND SB1.B1_MSBLQL != '1'
        INNER JOIN SG1200 SG1 (NOLOCK) ON SB2.B2_COD = SG1.G1_COD AND SG1.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG1.D_E_L_E_T_ = ''
        INNER JOIN SB1200 SB12 (NOLOCK) ON SG1.G1_COMP = SB12.B1_COD AND SB12.D_E_L_E_T_ = '' AND SB12.B1_DESC LIKE '%TEC%'
        LEFT JOIN SB2200 SB22 (NOLOCK) ON SG1.G1_COMP = SB22.B2_COD AND SB22.B2_LOCAL = '01'
        WHERE SB2.D_E_L_E_T_ = ''
        AND SB2.B2_FILIAL = '01'
        AND SB2.B2_LOCAL = '01'
        AND SB2.B2_COD LIKE '070%'
        AND SB1.B1_DESC LIKE 'ART%TEC%'
        AND SB2.B2_QATU < 200

    EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	/*u_InPutSX1(cPerg,"01",PADR("De Emissao.:"     ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Emissao.:"    ,20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Pedido:"       ,20)+"?","","","mv_ch3","C",6,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Pedido:"      ,20)+"?","","","mv_ch4","C",6,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De UF:"           ,20)+"?","","","mv_ch5","C",2,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Ate UF:"          ,20)+"?","","","mv_ch6","C",2,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("De Municipio:"    ,20)+"?","","","mv_ch7","C",30,0,0,"G","","","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("Ate Municipio:"   ,20)+"?","","","mv_ch8","C",30,0,0,"G","","","","","mv_par08")
	u_InPutSX1(cPerg,"09",PADR("De Cod.Cliente:"  ,20)+"?","","","mv_ch9","C",8,0,0,"G","","SA1","","","mv_par09") 
	u_InPutSX1(cPerg,"10",PADR("Ate Cod.Cliente:" ,20)+"?","","","mv_cha","C",8,0,0,"G","","SA1","","","mv_par10")*/

Return
