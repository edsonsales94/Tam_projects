#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR61   ºAutor  ³kLEDSON OLIVEIRA    				º Data ³  18/04/23 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Erro saldo Amazon                        			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR61()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR61"

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

	oReport := TReport():New(cPerg,"Erro saldo Amazon",cPerg,{|oReport| PrintReport(oReport,cAlias)}, "Este relatorio...")
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Erro saldo Amazon",{"SZ4"},aOrdem) 

	TRCell():New(oSection,"C2_NUM"		    ,"SC2","Op","@!",6)
	TRCell():New(oSection,"ARMAZEM"	    ,"SB2","MAT PRIMA","@!",2)
	TRCell():New(oSection,"COD"	    ,"SB2","COD","@!",20)
	TRCell():New(oSection,"DESCRI"		    ,"SB2","DESCRI","@!",40)
	TRCell():New(oSection,"QTD_ATUAL"	    ,"SB2","SALDO","@E 999,999,999.999",)
	TRCell():New(oSection,"CM1"	    	,"SB2","Custo Moeda 1","@E 999,999,999.999",)
	TRCell():New(oSection,"CM2"	    	,"SB2","Custo Moeda 2","@E 999,999,999.999",)
	TRCell():New(oSection,"CM3"	    	,"SB2","Custo Moeda 3","@E 999,999,999.999",)
	TRCell():New(oSection,"VATU1"	    ,"SB2","Valor Atual moeda 1","@E 999,999,999.999",)
	TRCell():New(oSection,"VATU2"	    ,"SB2","Valor Atual moeda 2","@E 999,999,999.999",)
	TRCell():New(oSection,"VATU3"	    ,"SB2","Valor Atual moeda 3","@E 999,999,999.999",)





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

SELECT C2_NUM, ARMAZEM, COD, DESCRI, QTD_ATUAL, CM1, CM2, CM3, VATU1, VATU2, VATU3
FROM (
SELECT B2_LOCAL ARMAZEM, 
        B2_COD COD, 
        B1_DESC DESCRI, 
        B2_QATU QTD_ATUAL,
        B2_CM1 CM1,
        B2_CM2 CM2,
        B2_CM3 CM3, 
        B2_VATU1 VATU1, 
        B2_VATU2 VATU2,
        B2_VATU3 VATU3
FROM SB2200 SB2
INNER JOIN SB1200 SB1 ON B2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
            AND B1_MSBLQL = '2'
WHERE SB2.D_E_L_E_T_ = ''
    AND (LEN(B2_CM1) > 10
        OR LEN(B2_CM2) >10
        OR LEN(B2_CM3) >10
        OR LEN(B2_VATU1) >10
        OR LEN(B2_VATU2) >10
        OR LEN(B2_VATU3) >10)
        //--AND B2_COD IN ('BLOD20REAL','BLOD26LONG')
)SB2 
INNER JOIN SC2200 SC2 ON C2_PRODUTO = COD AND SC2.D_E_L_E_T_ = ''
WHERE C2_NUM = %Exp:mv_par01%


		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("Op:",20)+"?","","","mv_ch1","C",6,0,0,"G","","","","","mv_par01") 
	//u_InPutSX1(cPerg,"02",PADR("Dt Pelmex Ate:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
