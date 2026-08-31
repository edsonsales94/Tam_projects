#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR69  ºAutor  ³Kledson Oliveira    				º Data ³  24/06/25 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Plano de Produção Molejo                    			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR69()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR69"

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

	oReport := TReport():New(cPerg,"Plano de Produção Molejo",cPerg,{|oReport| PrintReport(oReport,cAlias)}, "Este relatório trás informações sobre o Molejo" )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Plano de Produção Molejo",{"SRA"},aOrdem) 

	TRCell():New(oSection,"Data",		"PED","Data","@!",10)
    TRCell():New(oSection,"Tipo",				"PED","Tipo","@!",15)
	TRCell():New(oSection,"Codigo",		"SRA","Codigo","@!",20)
    TRCell():New(oSection,"Descricao",		"SRA","Descrição","@!",30)
	TRCell():New(oSection,"Quantidade",		"SRA","Quantidade","@E 999,999,999.999")

	//TRCell():New(oSection,"RA_SALARIO",		"SRA","Salario","@E 999,999,999",)

//Data,'COLCHÃO' SETOR,B1_XSETOR,RA_CC ,CTT_DESC01 ,RA_NOME Nome,SUM(CLA_QUANT)
	
	
	//Totalizador                                                                                  
	//SELECT '03/07/2025' Data,Tipo ,G1_COMP Codigo,B1_DESC Descricao,SUM(TOTAL) Quantidade

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

SELECT CONVERT(VARCHAR, CAST(%Exp:MV_PAR01% AS DATE),103) Data,Tipo,G1_COMP Codigo,B1_DESC Descricao,SUM(TOTAL) Quantidade
FROM (
SELECT CASE WHEN B1_DESC LIKE 'SUP%LFK%' THEN 'LFK' 
            WHEN B1_DESC LIKE 'SUP%242%' THEN 'PELMEX MAIS' 
     ELSE 'POCKET' END Tipo,PED_DTPREVIA,PED_NUM,PED_ITEM,PED_PRODUTO,PED_DESCRI,CAST(PED_QUANT AS FLOAT)PED_QUANT,G1_COMP,B1_DESC,G1_QUANT,CAST(PED_QUANT AS FLOAT) * G1_QUANT TOTAL
FROM PED
INNER JOIN SG1100 SG1 ON PED_PRODUTO = G1_COD AND G1_FIM >= %Exp:MV_PAR01% AND SG1.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB1 ON G1_COMP = B1_COD AND SB1.D_E_L_E_T_  = ''
WHERE CONVERT(VARCHAR,CAST(PED_DTPREVIA AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND B1_DESC LIKE 'SUPORTE EL%'
)TB
GROUP BY Tipo,PED_DTPREVIA,G1_COMP,B1_DESC
ORDER BY 2,5 DESC

EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

    u_InPutSX1(cPerg,"01",PADR("Data Previa de" ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Data Previa até:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Filial   ",20)+"?","","","mv_ch3","C",2,0,0,"G","","SM0","","","mv_par03")
	//u_InPutSX1(cPerg,"04",PADR("Ate Filial   ",20)+"?","","","mv_ch4","C",2,0,0,"G","","SM0","","","mv_par04")
	//u_InPutSX1(cPerg,"03",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par04")
	
	
	
	
Return

