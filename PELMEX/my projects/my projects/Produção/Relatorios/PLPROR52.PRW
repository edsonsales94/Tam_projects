#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR52  บAutor  ณKledson Oliveira    				บ Data ณ 16/09/24 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Prod Faixa e colagem x Planejado                    			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR52()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR52"

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

	oReport := TReport():New(cPerg,"Prod Faixa e colagem x Planejado",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Prod Faixa e Colagem x Planejado",{"PED"},aOrdem) 

    TRCell():New(oSection,"CODIGO"   	        ,"SB1","Codigo","@!",15)
    TRCell():New(oSection,"SETOR"	            ,"SB1","Setor","@!",7)
    TRCell():New(oSection,"DESCRICAO"	        ,"SB1","Descricao","@!",30)
    TRCell():New(oSection,"DT_PRODPEL"	        ,"PED","DtProducaoPelmex","@!",10)
    TRCell():New(oSection,"OP"  			    ,"PED","OrdemProducao","@!",6)
    TRCell():New(oSection,"QTD_PRODUZ"		    ,"SB1","QuantProduzi","@!",6)
	TRCell():New(oSection,"QTD_PLAN"		    ,"PED","QuantPlanej","@!",6)
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

SELECT CODIGO, SETOR, DESCRICAO, DT_PRODPEL, OP, QTD_PRODUZ, QTD_PLAN
FROM(    
    SELECT CODIGO, 'FAIXA' SETOR,DESCRICAO, DT_PRODPEL, OP, SUM(QUANTI) AS QTD_PRODUZ, QTD_PLAN
    FROM (    
        SELECT CLE_CPRODUC, B1_COD CODIGO, CLE_COD, CLE_DESCRI DESCRICAO, PED_OP OP, PED_DTPROPEL DT_PRODPEL,
        CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1  END QUANTI, PED_QUANT QTD_PLAN
        FROM CLE 
            INNER JOIN PED ON SUBSTRING(CLE_CPRODUC,1,8) = PED_OP+PED_ITEM 
                AND PED_PRODUTO = CLE_COD
            INNER JOIN SB1100 SB1 ON B1_COD = CLE_COD 
                AND SB1.D_E_L_E_T_ = '' 
                AND B1_MSBLQL = '2'
        WHERE cast(PED_DTPROPEL AS DATE) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
        AND LEN(CLE_CPRODUC) = 17
    )TB2
    GROUP BY CODIGO, DESCRICAO, DT_PRODPEL, OP, QTD_PLAN
    UNION 
    SELECT CODIGO, 'COLAGEM' SETOR,DESCRICAO, DT_PRODPEL, OP, SUM(QUANTI) AS QTD_PRODUZ, QTD_PLAN
    FROM(     
        SELECT CLC_CPRODUC, B1_COD CODIGO, CLC_COD, CLC_DESCRI DESCRICAO, PED_OP OP, PED_DTPROPEL DT_PRODPEL,
        CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1  END QUANTI, PED_QUANT QTD_PLAN
        FROM CLC 
            INNER JOIN PED ON SUBSTRING(CLC_CPRODUC,1,8) = PED_OP+PED_ITEM 
                AND PED_PRODUTO = CLC_COD
            INNER JOIN SB1100 SB1 ON B1_COD = CLC_COD 
                AND SB1.D_E_L_E_T_ = '' 
                AND B1_MSBLQL = '2'
        WHERE cast(PED_DTPROPEL AS DATE) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
        AND LEN(CLC_CPRODUC) = 17
    )TB3
    GROUP BY CODIGO, DESCRICAO, DT_PRODPEL, OP, QTD_PLAN
)TB1
WHERE SETOR = %Exp:MV_PAR03%
ORDER BY DT_PRODPEL ASC 





		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De DtProdPelmex:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate DtProdPelmex:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Setor:" ,20)+"?","","","mv_ch3","C",7,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
