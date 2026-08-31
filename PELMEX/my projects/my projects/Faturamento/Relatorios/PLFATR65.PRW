

#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR64  บAutor  ณJuevan Silva     				บ Data ณ 28/05/24 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Conferencia Ganho x Apontamento Producao                    			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR65()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLFATR65"

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

	oReport := TReport():New(cPerg,"Conferencia Ganho x Apontamento Producao",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Conferencia Ganho x Apontamento Producao",{"SD2"},aOrdem) 

    TRCell():New(oSection,"DT_PRODUCAO"   	      ,"PED","DT_PRODUCAO","@!",10)
    //TRCell():New(oSection,"D3_DOC"		    ,"SD3","DocMov","@!",15)
    TRCell():New(oSection,"PEDIDO"		    ,"PED","PEDIDO","@!",06)
    TRCell():New(oSection,"NOTA"	   ,"PED","NOTA","@!",10)
    TRCell():New(oSection,"OP"		    ,"PED","OP","@!",06)
    TRCell():New(oSection,"ITEM"  			,"PED","ITEM","@!",02)
    TRCell():New(oSection,"PRODUTO"		    ,"PED","PRODUTO","@!",15)
	TRCell():New(oSection,"DESCRICAO"		    ,"PED","DESCRICAO","@!",30)
    TRCell():New(oSection,"QTD_OP"		    ,"PED","QTD_OP","@E 999,999,999,999",)
    TRCell():New(oSection,"QTD_APONTADA"		    ,"PED","QTD_APONTADA","@E 999,999,999,999",)
    TRCell():New(oSection,"QTD_GANHO"		    ,"PED","QTD_GANHO","@E 999,999,999,999",)
    TRCell():New(oSection,"QTD_PERDA"		    ,"PED","QTD_PERDA","@E 999,999,999,999",)
    TRCell():New(oSection,"DIFERENCA"		    ,"PED","DIFERENCA","@E 999,999,999,999",)
    TRCell():New(oSection,"NOME"		    ,"PED","NOME","@!",30)
    TRCell():New(oSection,"CIDADE"		    ,"PED","CIDADE","@!",10)
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

SELECT PED_DTPROPEL DT_PRODUCAO,PED_NUM PEDIDO,PED_NOTA NOTA,PED_OP OP,PED_ITEM ITEM,PED_PRODUTO PRODUTO,PED_DESCRI DESCRICAO,
       CAST(PED_QUANT AS FLOAT)QTD_OP,C2_QUJE QTD_APONTADA,ISNULL(QTD_GANHO,0)QTD_GANHO,ISNULL(QTD_PERDA,0)QTD_PERDA,
     ISNULL(QTD_GANHO,0)+ISNULL(QTD_PERDA,0)DIFERENCA,
     PED_NOME NOME,PED_MUN CIDADE
FROM PED (NOLOCK)
INNER JOIN (SELECT C2_NUM,C2_PRODUTO,SUM(C2_QUANT)C2_QUANT,SUM(C2_QUJE)C2_QUJE
            FROM(
      SELECT C2_NUM,C2_ITEM,C2_PRODUTO,C2_QUANT,C2_QUJE
            FROM SC2100 SC2 (NOLOCK) 
      WHERE SC2.D_E_L_E_T_ = ''
      )TB
      GROUP BY C2_NUM,C2_PRODUTO
      )SC2 ON PED_OP = C2_NUM AND PED_PRODUTO = C2_PRODUTO
LEFT JOIN (
      SELECT D3_XPEDIDO,D3_COD,B1_DESC, 
             SUM(D3_QUANT) QTD_GANHO
      FROM SD3100 SD3 (NOLOCK)
      INNER JOIN SB1100 SB1 (NOLOCK) ON D3_COD = B1_COD AND B1_MSBLQL != '1' AND SB1.D_E_L_E_T_ = ''
      WHERE SD3.D_E_L_E_T_ = ''
      AND D3_TM <= '500'
	AND RTRIM(D3_XPEDIDO) != ''
      AND D3_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
      GROUP BY D3_XPEDIDO,D3_COD,B1_DESC)SD3 ON PED_NUM = D3_XPEDIDO  AND PED_PRODUTO = D3_COD
LEFT JOIN (
      SELECT D3_XPEDIDO,D3_COD,B1_DESC, 
             SUM(D3_QUANT)*-1 QTD_PERDA
      FROM SD3100 SD3 (NOLOCK)
      INNER JOIN SB1100 SB1 (NOLOCK) ON D3_COD = B1_COD AND B1_MSBLQL != '1' AND SB1.D_E_L_E_T_ = ''
      WHERE SD3.D_E_L_E_T_ = ''
      AND D3_TM > '500'
      AND RTRIM(D3_XPEDIDO) != ''
      AND D3_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
      GROUP BY D3_XPEDIDO,D3_COD,B1_DESC)SD32 ON PED_NUM = SD32.D3_XPEDIDO AND PED_PRODUTO = SD32.D3_COD
WHERE PED_STATUS != 'C'
AND CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND ISNULL(QTD_GANHO,0)+ISNULL(QTD_PERDA,0) > 0
GROUP BY PED_DTPROPEL,PED_NUM,PED_NOTA,PED_OP,PED_ITEM,PED_PRODUTO,PED_DESCRI,PED_QUANT,C2_QUJE,QTD_GANHO,QTD_PERDA,PED_NOME,PED_MUN
ORDER BY CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112),PED_NUM,PED_ITEM




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
