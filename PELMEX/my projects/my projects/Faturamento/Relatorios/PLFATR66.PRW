

#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR66  บAutor  ณKledson Oliveira    				บ Data ณ 01/11/24 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Ranking de Produtos mais vendidos                    			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR66()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLFATR66"

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

	oReport := TReport():New(cPerg,"Ranking de Produtos mais vendidos",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Ranking de Produtos mais vendidos",{"SD2"},aOrdem) 


      TRCell():New(oSection,"D2_COD"		      ,"SD2","Codigo","@!",15)
      TRCell():New(oSection,"B1_DESC"		      ,"SB1","Descricao","@!",30)
      TRCell():New(oSection,"QTD"		      ,"SD2","Quantidade","@E 999,999,999,999",)
      //TRCell():New(oSection,"LINHA"		            ,"SB1","Linha","@!",15)
      //TRCell():New(oSection,"CIDADE"		    ,"PED","CIDADE","@!",10)
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


SELECT D2_COD, B1_DESC, SUM(D2_QUANT) QTD
FROM(
SELECT D2_COD, B1_DESC, D2_QUANT, LINHA, TipoPedido
FROM (
        SELECT D2_DOC, D2_PEDIDO, D2_COD, B1_DESC, D2_CLIENTE, D2_QUANT,
                CASE WHEN B1_XEMP = '1' THEN 'PROBEL' 
                WHEN B1_XEMP = '2' THEN 'PELMEX' 
                WHEN B1_XEMP = '3' THEN 'SONOFLEX'
                WHEN B1_XEMP = '4' THEN 'POLISHOP' 
                WHEN B1_XEMP = '5' THEN 'KING STAR'
                WHEN B1_XEMP = '6' THEN 'INOVAR' 
                WHEN B1_XEMP = '7' THEN 'NAMASPET'
                WHEN B1_XEMP = '8' THEN 'ORTOCONFORT' 
                WHEN B1_XEMP = '9' THEN 'PELMEX MAIS'
                ELSE '' END LINHA, 
                	CASE WHEN D2_PEDIDO LIKE 'L%' THEN 1
                	WHEN D2_PEDIDO LIKE 'R%' THEN 2
                	ELSE 3 END TipoPedido                
        FROM SD2100 SD2
                INNER JOIN SB1100 SB1 ON B1_COD = D2_COD 
                AND SB1.D_E_L_E_T_ = ''
        WHERE SD2.D_E_L_E_T_ = ''             
                AND D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
                AND B1_XEMP BETWEEN '' AND 'Z'
                AND B1_GRUPO IN ('5020','5029')
                AND D2_CLIENTE BETWEEN '' AND 'ZZZZZZ'
                AND D2_LOCAL != '30'
                AND D2_TES != '723'
)TB
        WHERE LINHA BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
                AND TipoPedido BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
)TB1
GROUP BY D2_COD, B1_DESC
ORDER BY 3 DESC 



		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Emissao NF   ",20)+"?","","","mv_ch1","D",6,0,0,"G","","","","","mv_par01")  
	u_InPutSX1(cPerg,"02",PADR("Ate Emisao NF  ",20)+"?","","","mv_ch2","D",6,0,0,"G","","","","","mv_par02")
    u_InPutSX1(cPerg,"03",PADR("De linha   ",20)+"?","","","mv_ch3","C",11,0,0,"C","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Ate Linha   ",20)+"?","","","mv_ch4","C",11,0,0,"C","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De Tipo Pedido   ",20)+"?","","","mv_ch5","N",1,0,0,"C","","","","","mv_par05","1 - Loja","","","","","2 - Romaneio","","","","","3 - Fabr/Franq ")
	u_InPutSX1(cPerg,"06",PADR("Ate tipo Pedido    ",20)+"?","","","mv_ch6","N",1,0,0,"C","","","","","mv_par06","1 - Loja", "","","","","2 - Romaneio","","","","","3 - Fabr/Franq ")
	
	
Return
