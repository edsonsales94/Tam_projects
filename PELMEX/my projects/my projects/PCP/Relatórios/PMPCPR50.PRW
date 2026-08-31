#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR50    ºAutor  ³Wylliam Silva     				º Data ³  04/01/21 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³    Relatório Lista de Ordem     			        			  			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR50()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR50"

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

	oReport := TReport():New(cPerg,"Relatório Lista de Ordem",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Relatório Lista de Ordem",{"SC2"},aOrdem)  
	

	
	TRCell():New(oSection,"G1_COMP"	        ,"SG1","CODIGO","@!",15)             
	TRCell():New(oSection,"B1_DESC"         ,"SB1","DESCRICAO","@!",50) 
	TRCell():New(oSection,"B1_UM"           ,"SB1","UM","@!",4) 
	TRCell():New(oSection,"TOTAL"   	    ,"SG1","TOTAL","@E 999,999,999,999",8)
	TRCell():New(oSection,"QTD_OP"   	    ,"SC2","QTDE QTD","@E 999,999,999,999",8)
	TRCell():New(oSection,"SALDO"   	    ,"SC2","SALDO","@E 999,999,999,999",8)
	
	
	
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

SELECT G1_COMP,B1_DESC,B1_UM,SUM(TOTAL)TOTAL,ISNULL(QTD_OP,0)QTD_OP,ISNULL(QTD_OP,0)-SUM(TOTAL)SALDO
FROM(
SELECT PK2_CODIGO,PK2_DESCRI,PK2_QUANT,G1_COMP,B1_DESC,B1_UM,G1_QUANT, PK2_QUANT * G1_QUANT TOTAL
FROM PK2
INNER JOIN SG1100 SG1 ON PK2_PRODUTO = G1_COD AND SG1.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB1 ON G1_COMP = B1_COD AND SB1.D_E_L_E_T_ = ''
WHERE PK2_DTPROPEL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
)TB
LEFT JOIN (SELECT C2_PRODUTO,C2_LOCAL,SUM(C2_QUANT)QTD_OP
           FROM SC2200 SC2
       WHERE SC2.D_E_L_E_T_ = ''
       AND C2_FILIAL = '01'
       AND C2_LOCAL = '20'
       AND C2_DATPRF = ''
       AND C2_PRODUTO BETWEEN 'SUP' AND 'ZZZZZZZZZZZZZZZ'
       AND C2_QUANT > C2_QUJE
       GROUP BY C2_PRODUTO,C2_LOCAL)SC2 ON G1_COMP = C2_PRODUTO
WHERE G1_COMP BETWEEN 'SUP' AND 'SUPZZZZZZZZZZZZZZZ'
GROUP BY G1_COMP,B1_DESC,B1_UM,QTD_OP
ORDER BY B1_DESC

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt Emissão:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Dt Emissão:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Pedido:",20)+"?","","","mv_ch3","C",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	

Return