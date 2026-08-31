#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR101   บAutor  ณJuevan Silva     				บ Data ณ  18/04/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Produ็ใo X Apontamento                       		                     ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR14()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR14"

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

	oReport := TReport():New(cPerg,"Produ็ใo X Apontamento",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Produ็ใo X Apontamento",{"PED"},aOrdem) 

    TRCell():New(oSection,"PED_PRODUTO"     ,"PED","IMPRESSO","@!",15)
	TRCell():New(oSection,"PED_DESCRI"		,"PED","ENTRADA","@!",30)
	TRCell():New(oSection,"QTD_PEDIDO"	    ,"PED","QTD_PEDIDO","@E 999,999,999.99",)
    TRCell():New(oSection,"QTD_APONTADA"	,"PED","QTD_APONTADA","@E 999,999,999.99",) 
    TRCell():New(oSection,"QTD_NOTA"	    ,"PED","QTD_NOTA","@E 999,999,999.99",) 
    TRCell():New(oSection,"PENDENTE"	    ,"PED","PENDENTE","@E 999,999,999.99",) 
    TRCell():New(oSection,"MICROSIGA"	    ,"SB2","MICROSIGA","@E 999,999,999.99",)
    TRCell():New(oSection,"PED_CLIENTE"	    ,"PED","COD.CLIENTE","@!",6)
    TRCell():New(oSection,"PED_NOME"	    ,"PED","CLIENTE","@!",30)


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

        SELECT PED_PRODUTO,B1_DESC,CAST(SUM(PED_QUANT) AS FLOAT)QTD_PEDIDO,SUM(C2_QUJE)QTD_APONTADA,SUM(D2_QUANT)QTD_NOTA,CAST(SUM(PED_QUANT) AS FLOAT)-SUM(C2_QUJE) PENDENTE,MICROSIGA,PED_CLIENTE,PED_NOME
        FROM(
                SELECT PED_NUM,PED_NOTA,PED_OP,PED_ITEM,PED_PRODUTO,B1_DESC,PED_LOCAL,PED_QUANT,C2_QUJE,ISNULL(D2_QUANT,0)D2_QUANT,B2_QATU MICROSIGA,PED_CLIENTE,PED_NOME,PED_MUN
                FROM PED (NOLOCK)
                LEFT JOIN SC2100 SC2 (NOLOCK) ON PED_OP = C2_NUM AND PED_PRODUTO = C2_PRODUTO AND SC2.D_E_L_E_T_ = ''
                INNER JOIN SB1100 SB1 (NOLOCK) ON PED_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
                LEFT JOIN SB2100 SB2 (NOLOCK) ON PED_FILIAL = B2_FILIAL AND PED_LOCAL = B2_LOCAL AND PED_PRODUTO = B2_COD AND SB2.D_E_L_E_T_ = ''
                LEFT JOIN (SELECT D2_FILIAL,D2_PEDIDO,D2_DOC,D2_SERIE,D2_ITEMPV,D2_COD,D2_QUANT,D2_LOCAL,D2_CLIENTE
                        FROM SD2100 SD2 (NOLOCK)
                    LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
                    LEFT JOIN CNF (NOLOCK) ON D2_FILIAL = CNF_FILIAL AND D2_DOC = CNF_DOC AND D2_SERIE = CNF_SERIE AND D2_CLIENTE = CNF_CLIENTE AND D2_LOJA = CNF_LOJA
                    WHERE SD2.D_E_L_E_T_ = ''
                    AND D2_FILIAL = '01'
                    AND D1_DOC IS NULL
                    AND CNF_DOC IS NOT NULL)SD2 ON PED_FILIAL = D2_FILIAL AND CASE WHEN PED_NOTA = '' THEN PED_NUM ELSE PED_NOTA END = CASE WHEN PED_NOTA = '' THEN D2_PEDIDO ELSE D2_DOC END AND PED_ITEM = D2_ITEMPV AND PED_PRODUTO = D2_COD
                WHERE PED_STATUS != 'C'
                AND CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
                AND PED_PRODUTO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
                AND PED_NOTA BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
                AND PED_SERIE BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
                AND PED_CLIENTE BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%
				AND PED_NUM BETWEEN %Exp:MV_PAR11% AND %Exp:MV_PAR12%
                )TB
        GROUP BY PED_PRODUTO,B1_DESC,MICROSIGA,PED_CLIENTE,PED_NOME
        ORDER BY B1_DESC
		
    EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("DT Ini Prod:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("DT Fim Prod:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Produto:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Produto:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De Nota:" ,20)+"?","","","mv_ch5","C",9,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Ate Nota:",20)+"?","","","mv_ch6","C",9,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("De Serie:" ,20)+"?","","","mv_ch7","C",3,0,0,"G","","","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("Ate Serie:",20)+"?","","","mv_ch8","C",3,0,0,"G","","","","","mv_par08")
	u_InPutSX1(cPerg,"09",PADR("De Cliente:",20)+"?","","","mv_ch9","C",6,0,0,"G","","SA1","","","mv_par09") 
	u_InPutSX1(cPerg,"10",PADR("Ate Cliente:",20)+"?","","","mv_cha","C",6,0,0,"G","","SA1","","","mv_par10")
	u_InPutSX1(cPerg,"11",PADR("De Cliente:",20)+"?","","","mv_chb","C",6,0,0,"G","","","","","mv_par11") 
	u_InPutSX1(cPerg,"12",PADR("Ate Cliente:",20)+"?","","","mv_chc","C",6,0,0,"G","","","","","mv_par12")


Return
