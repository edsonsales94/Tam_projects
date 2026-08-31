#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR86   ºAutor  ³Juevan Silva     				º Data ³  31/10/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   	Modelo de Estrutura Completa                        			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR87()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR87"

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

	oReport := TReport():New(cPerg,"DIF. SOLICITADO X EMPENHADO",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"DIF. SOLICITADO X EMPENHADO",{"SC2"},aOrdem) 

  CLIENTE
    TRCell():New(oSection,"DT_OP"   	    ,"SC2","DT OP","@!",10)
	TRCell():New(oSection,"OP"		        ,"SC2","OP","@!",8)
	TRCell():New(oSection,"PRODUTO"		    ,"SC2","PRODUTO","@!",15) 
	TRCell():New(oSection,"DESCPA"		    ,"SC2","DESCRICAO","@!",30)   
	TRCell():New(oSection,"QTD_OP"	        ,"SC2","QTDE OP","@E 999,999,999,999",)
	TRCell():New(oSection,"QTD_APONTADA"    ,"SC2","QTDE APONTADA","@E 999,999,999,999",)
	TRCell():New(oSection,"COMPONENTE"	    ,"SG1","COMPONENTE","@!",15)         
	TRCell():New(oSection,"DESCCOMP"  	    ,"SG1","DESC COMPO","@!",30)
	TRCell():New(oSection,"UM"			    ,"SG1","UNIDADE","@!",4)
	TRCell():New(oSection,"QTD_ESTRUTURA"   ,"SG1","QTDE ESTRUTURA","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_SOLICITADA" 	,"SG1","QTDE SOLICITAdA","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_EMPENHADA"	,"SG1","QtDE EMPENHADA","@E 999,999,999.999",)
	TRCell():New(oSection,"CARGA"  			,"SC2","CARGA","@!",12)
	TRCell():New(oSection,"CLIENTE"     	,"SC2","CLIENTE","@!",30) 
	
    
	
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

    
SELECT DT_OP,OP,PRODUTO,DESCPA,QTD_OP,QTD_APONTADA,COMPONENTE,DESCCOMP,UM,QTD_ESTRUTURA,CAST(QTD_SOLICITADA AS FLOAT)QTD_SOLICITADA,CAST(QTD_EMPENHADA AS FLOAT)QTD_EMPENHADA,CARGA,CLIENTE
FROM(
        SELECT CONVERT(VARCHAR,CAST(C2_EMISSAO AS DATE),103)DT_OP,C2_NUM OP,C2_PRODUTO PRODUTO,SB1.B1_DESC DESCPA,C2_QUANT QTD_OP,C2_QUJE QTD_APONTADA,G1_COMP COMPONENTE,SB12.B1_DESC DESCCOMP,SB12.B1_UM UM,G1_QUANT QTD_ESTRUTURA,CAST(C2_QUANT*G1_QUANT AS NUMERIC(15,6)) QTD_SOLICITADA,
            CAST(D4_QTDEORI AS NUMERIC(15,6)) QTD_EMPENHADA,C2_XCARGA CARGA,C2_OBS CLIENTE
        FROM SC2100 SC2 (NOLOCK)
        INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
        INNER JOIN SG1100 SG1 (NOLOCK) ON C2_PRODUTO = G1_COD AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG1.D_E_L_E_T_ = ''
        INNER JOIN SB1100 SB12 (NOLOCK) ON G1_COMP = SB12.B1_COD AND SB12.D_E_L_E_T_ = ''
        INNER JOIN SD4100 SD4 (NOLOCK) ON C2_NUM+C2_ITEM+C2_SEQUEN = D4_OP AND G1_COMP = D4_COD AND G1_TRT = D4_TRT AND SD4.D_E_L_E_T_ = ''
        WHERE SC2.D_E_L_E_T_ = ''
        AND C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
        )TB
WHERE (QTD_SOLICITADA * 2) = QTD_EMPENHADA
//GROUP BY DT_OP,OP
ORDER BY 1,OP

		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De DTOP:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate DTOP:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
