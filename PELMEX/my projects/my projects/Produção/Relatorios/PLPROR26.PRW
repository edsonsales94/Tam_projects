#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR26   ºAutor  ³Juevan Silva     				º Data ³  27/09/23 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Relatorio de Suporte Elastico Apontado                       			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR26()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR26"

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

	oReport := TReport():New(cPerg,"Relatorio de Suporte Elastico Apontado",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Relatorio de Suporte Elastico Apontado",{"SC2"},aOrdem) 


    TRCell():New(oSection,"C2_EMISSAO"   	     ,"SC2","EMISSAO","@!",10)
	TRCell():New(oSection,"C2_PRODUTO"		      ,"SC2","PRODUTO","@!",15)
	TRCell():New(oSection,"B1_DESC"		     ,"SB1","DESCRICAO","@!",30)
    TRCell():New(oSection,"C2_QUANT"		   ,"SC2","QTD","@@E 999,999,999.999",)  
	TRCell():New(oSection,"C2_QUJE"		    ,"SC2","APONTADO","@@E 999,999,999.999",)
    TRCell():New(oSection,"Z1_QUANT"	     ,"SZ1","ANTENA","@@E 999,999,999.999",)    
	TRCell():New(oSection,"DIFERENCA"  	    ,"SC2","DIFERENCA","@@E 999,999,999.999",)
	TRCell():New(oSection,"C2_OBS"			    ,"SC2","OBS","@!",20)
	//TRCell():New(oSection,"G1_XDIMENS"        ,"SG1","G1_XDENSID","@!",30)
	//TRCell():New(oSection,"QTD_SOLICITADA" 	,"SG1","QTDE SOLICITAdA","@E 999,999,999.999",)
	//TRCell():New(oSection,"QTD_EMPENHADA"	,"SG1","QtDE EMPENHADA","@E 999,999,999.999",)
	//TRCell():New(oSection,"CARGA"  			,"SC2","CARGA","@!",12)
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


SELECT C2_EMISSAO,C2_PRODUTO,B1_DESC,C2_QUANT,C2_QUJE,Z1_QUANT,C2_QUANT-Z1_QUANT DIFERENCA,C2_OBS
FROM SC2200 SC2
INNER JOIN SB1200 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
INNER JOIN (SELECT Z1_OP,COUNT(Z1_OP+Z1_CHASSIS)Z1_QUANT
            FROM SZ1200 SZ1 (NOLOCK)
      WHERE SZ1.D_E_L_E_T_ = ''
      GROUP BY Z1_OP)SZ1 ON Z1_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2.D_E_L_E_T_ = ''
WHERE SC2.D_E_L_E_T_ = ''
AND C2_EMISSAO BETWEEN  %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND C2_QUANT > Z1_QUANT
ORDER BY 1

		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("DT Emissao:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("DT Fim Emissao:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
