#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR43   บAutor  ณJuevan Silva     				บ Data ณ  21/03/24 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Entrada X Expedicao                      			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR43()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR43"

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

	oReport := TReport():New(cPerg,"Entrada X Expedicao",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Entrada X Expedicao",{"PED"},aOrdem) 

    TRCell():New(oSection,"DATA"   	        ,"SZ1","DATA","@!",10)
    TRCell():New(oSection,"ENTRADA_ESTOQUE"	   ,"SZ1","ENTRADA_ESTOQUE","@E 999,999,999,999",)
    TRCell():New(oSection,"EXPEDIDO"	        ,"SZ1","EXPEDIDO","@E 999,999,999,999",)
   TRCell():New(oSection,"DIFERENCA"	        ,"SZ1","DIFERENCA","@E 999,999,999,999",)
   TRCell():New(oSection,"TOTAL_EXPEDIDO"	        ,"SZ1","TOTAL_EXPEDIDO","@E 999,999,999,999",)
    //TRCell():New(oSection,"EXPEDIDO"	        ,"SZ1","EXPEDIDO","@E 999,999,999,999",)
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

SELECT DATA,SUM(ENTRADA_ESTOQUE)ENTRADA_ESTOQUE,SUM(EXPEDIDO)EXPEDIDO,SUM(DIFERENCA)DIFERENCA,SUM(TOTAL_EXPED)TOTAL_EXPED
FROM(
      SELECT DATA,SUM(ENTRADA_ESTOQUE)ENTRADA_ESTOQUE,SUM(EXPEDIDO)EXPEDIDO,SUM(ENTRADA_ESTOQUE)-SUM(EXPEDIDO) DIFERENCA,TOTAL_EXPED
     FROM(
          SELECT CONVERT(VARCHAR,CAST(Z1_DTAPONT AS DATE),103) DATA,COUNT(Z1_OP)ENTRADA_ESTOQUE,0 EXPEDIDO,0 TOTAL_ENTRADA, 0 TOTAL_EXPED
          FROM SC2100 SC2 (NOLOCK)
          INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' 
          INNER JOIN SZ1100 SZ1 (NOLOCK) ON C2_NUM = SUBSTRING(Z1_OP,1,6) AND SZ1.D_E_L_E_T_ = '' 
          WHERE SC2.D_E_L_E_T_ = '' 
          AND Z1_DTAPONT BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
          GROUP BY Z1_DTAPONT
          UNION
          SELECT CNF_EXPEDICAO DATA,0 ENTRADA_ESTOQUE,SUM(D2_QUANT)EXPEDIDO,0 TOTAL_ENTRADA,0 TOTAL_EXPED
          FROM SD2100 SD2 (NOLOCK)
          LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = '' 
          INNER JOIN CNF (NOLOCK) ON D2_FILIAL = CNF_FILIAL AND D2_DOC = CNF_DOC AND D2_SERIE = CNF_SERIE AND D2_CLIENTE = CNF_CLIENTE AND D2_LOJA = CNF_LOJA 
          WHERE CNF_EXPEDICAO IS NOT NULL
          AND D1_DOC IS NULL
          AND SUBSTRING(CNF_EXPEDICAO,7,4)+SUBSTRING(CNF_EXPEDICAO,4,2)+SUBSTRING(CNF_EXPEDICAO,1,2)BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
          GROUP BY CNF_EXPEDICAO
          UNION
          SELECT CNF_EXPEDICAO DATA,0 ENTRADA_ESTOQUE,0 EXPEDIDO,0 TOTAL_ENTRADA,SUM(D2_TOTAL) VALOR_EXPED
          FROM(
               SELECT CNF_EXPEDICAO,D2_FILIAL,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,D2_TOTAL
               FROM SD2100 SD2 (NOLOCK)
               LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = '' 
               INNER JOIN CNF (NOLOCK) ON D2_FILIAL = CNF_FILIAL AND D2_DOC = CNF_DOC AND D2_SERIE = CNF_SERIE AND D2_CLIENTE = CNF_CLIENTE AND D2_LOJA = CNF_LOJA 
               WHERE CNF_DOC IS NOT NULL
               AND D1_DOC IS NULL
               AND SUBSTRING(CNF_EXPEDICAO,7,4)+SUBSTRING(CNF_EXPEDICAO,4,2)+SUBSTRING(CNF_EXPEDICAO,1,2) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
          )TB
          GROUP BY CNF_EXPEDICAO
     )TB
     GROUP BY DATA,TOTAL_EXPED
)TB1
GROUP BY DATA
ORDER BY CONVERT(VARCHAR,CAST(DATA AS DATE),112)




		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
