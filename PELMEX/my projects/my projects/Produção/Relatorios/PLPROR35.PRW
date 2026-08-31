
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR35  ºAutor  ³Juevan Silva     				º Data ³ 29/12/23 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Planejados x Produzido                    			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR35()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR35"

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

	oReport := TReport():New(cPerg,"Planejados x Produzido",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Planejados x Produzido",{"SD2"},aOrdem) 

    TRCell():New(oSection,"PERIODO"   	      ,"SD2","PERIODO","@!",10)
     TRCell():New(oSection,"QTD_PROGRAMADA"		    ,"SC2","QTD_PROGRAMADA","@E 999,999,999,999",)
     TRCell():New(oSection,"QTD_PRODUZIDA"	   ,"SC2","QTD_PRODUZIDA","@E 999,999,999,999",)
     TRCell():New(oSection,"QTD_PENDENTE"		    ,"SC2","PENDENTE","@E 999,999,999,999",)
    //TRCell():New(oSection,"A1_COD"  			,"SA1","CODIGO","@!",15)
     //TRCell():New(oSection,"A1_NOME"		    ,"SA1","NOME","@!",20)
	//TRCell():New(oSection,"A1_MUN"		    ,"SA1","CIDADE",,10)
   //TRCell():New(oSection,"C6_VALOR"		    ,"SC6","VALOR","@E 999,999,999,999",)
    //TRCell():New(oSection,"A1_NOME"		    ,"SA1","NOME","@!",20)
    //TRCell():New(oSection,"D2_TES"		    ,"SD2","TES","@!",20)
   //TRCell():New(oSection,"F4_TEXTO"		    ,"SF4","Descricao TES","@!",20)
    //TRCell():New(oSection,"C6_NUM"		     ,"SC6","C6_NUM","@!",7)
	//TRCell():New(oSection,"C6_ITEM"		  ,"SC6","C6_ITEM","@!",3)
    //TRCell():New(oSection,"C6_PRODUTO"	      ,"SC6","PRODUTO","@!",20) 
	//TRCell():New(oSection,"C6_CLI" 	         ,"SC6","C6_CLI","@!",7)
	//TRCell():New(oSection,"A1_NOME"	    ,"SA1","A1_NOME","@!",20)
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

SELECT SUBSTRING(CONVERT(VARCHAR,CAST(C2_EMISSAO AS DATE),103),4,7)PERIODO,SUM(C2_QUANT)QTD_PROGRAMADA,SUM(QTD_ENTRADA)QTD_PRODUZIDA,SUM(PENDENTE)QTD_PENDENTE
FROM(
SELECT C2_EMISSAO,C2_NUM,C2_ITEM,C2_QUANT,CAST(ISNULL(QTD_ENTRADA,0) AS FLOAT)QTD_ENTRADA,C2_QUANT - CAST(ISNULL(QTD_ENTRADA,0) AS FLOAT)PENDENTE
FROM SC2100 SC2 (NOLOCK)
LEFT JOIN (SELECT SUBSTRING(Z1_OP,1,11)Z1_OP,Z1_PRODUTO,SUM(Z1_QUANT)QTD_ENTRADA
           FROM(
       SELECT Z1_OP+Z1_CHASSIS Z1_OP,C2_PRODUTO Z1_PRODUTO,CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END Z1_QUANT
           FROM SZ1100 SZ1 (NOLOCK)
       INNER JOIN SC2100 SC2 (NOLOCK) ON Z1_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2.D_E_L_E_T_ = ''
       INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
       WHERE SZ1.D_E_L_E_T_ = ''
       AND Z1_DTAPONT >= '20230101'
       )TB
       GROUP BY SUBSTRING(Z1_OP,1,11),Z1_PRODUTO)SZ1 ON C2_NUM+C2_ITEM+C2_SEQUEN = Z1_OP AND C2_PRODUTO = Z1_PRODUTO
WHERE SC2.D_E_L_E_T_ = ''
AND C2_EMISSAO BETWEEN  %Exp:MV_PAR01% AND %Exp:MV_PAR02%
)TB
GROUP BY SUBSTRING(CONVERT(VARCHAR,CAST(C2_EMISSAO AS DATE),103),4,7)
ORDER BY 1                                              
                                                                      



		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Emissao:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Emissao:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
