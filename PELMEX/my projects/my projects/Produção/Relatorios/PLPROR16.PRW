#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR16   ºAutor  ³Wylliam Silva     		    		º Data ³  15/06/23 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Pedidos de compras em aberto                 		                     ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR16()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR16"

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

	oReport := TReport():New(cPerg,"Pedidos de compras em aberto",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Pedidos de compras em aberto",{"SC7"},aOrdem) 

    TRCell():New(oSection,"EMPRESA"         ,"SC7","EMPRESA","@!",7)
    TRCell():New(oSection,"C7_NUM"	    	,"SC7","NUM. PC","@!",8)
    TRCell():New(oSection,"C7_FORNECE"	    ,"SC7","COD.FORNEC","@!",15)
    TRCell():New(oSection,"C7_LOJA"	        ,"SC7","LOJA","@!",4)
    TRCell():New(oSection,"A2_NOME"	        ,"SA2","CLIENTE","@!",35)
    TRCell():New(oSection,"A2_TEL"	        ,"SA2","TELEFONE","@!",12)
    TRCell():New(oSection,"C7_ITEM"	        ,"SC7","ITEM","@!",4)
    TRCell():New(oSection,"C7_PRODUTO"	    ,"SC7","PRODUTO","@!",15)
    TRCell():New(oSection,"B1_DESC"	        ,"SB1","DESCRICAO","@!",35)
    TRCell():New(oSection,"B1_UM"	        ,"SB1","UM","@!",3)
    TRCell():New(oSection,"B1_GRUPO"	    ,"SB1","GRUPO","@!",6)
	TRCell():New(oSection,"C7_EMISSAO"		,"SC7","DTEMISSAO","@!",10)
    TRCell():New(oSection,"C7_DATPRF"		,"SC7","DTPREV.ENTREGA","@!",10)
    TRCell():New(oSection,"C7_DTPRSP"		,"SC7","DTPREV.SP","@!",10)
    TRCell():New(oSection,"C7_QUANT"	    ,"SC7","QTDE COMPRA","@E 999,999,999.99",) 
    TRCell():New(oSection,"C7_QUJE"	        ,"SC7","QTDE RECEB","@E 999,999,999.99",)
    TRCell():New(oSection,"C7_PRECO"	    ,"SC7","PREÇO UNIT","@E 999,999,999.99",)
    TRCell():New(oSection,"C7_VLDESC"	    ,"SC7","VLR DESCONT","@E 999,999,999.99",)
    TRCell():New(oSection,"C7_VALIPI"	    ,"SC7","VLR IPI","@E 999,999,999.99",)
    TRCell():New(oSection,"C7_TOTAL"	    ,"SC7","VLR TOTAL","@E 999,999,999.99",)
    TRCell():New(oSection,"QTD_RECEBER"	    ,"SC7","QTD_RECEBER","@E 999,999,999.99",)
    TRCell():New(oSection,"VLR_RECEBER"	    ,"SC7","VLR_RECEBER","@E 999,999,999.99",)
    TRCell():New(oSection,"C7_OBS"	        ,"SC7","OBS","@!",35)
    //TRCell():New(oSection,"CIDADE"          ,"SA1","CIDADE","@!",25)  
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("TOTAL"),"TOTAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)

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

    SELECT 'PELMEX' EMPRESA,C7_NUM,C7_FORNECE,C7_LOJA,A2_NOME,A2_TEL,C7_ITEM,C7_PRODUTO,B1_DESC,B1_UM,B1_GRUPO,C7_EMISSAO,C7_DATPRF,C7_DTPRSP,C7_QUANT,C7_QUJE,
                    C7_PRECO,C7_VLDESC,C7_VALIPI,C7_TOTAL,(C7_QUANT-C7_QUJE) QTD_RECEBER,(C7_TOTAL-(C7_QUJE*C7_PRECO)) VLR_RECEBER,C7_OBS
    FROM SC7100 SC7 (NOLOCK)
    INNER JOIN SA2100 SA2 (NOLOCK) ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA AND A2_MSBLQL != '1' AND SA2.D_E_L_E_T_ = ''
    INNER JOIN SB1100 SB1 (NOLOCK) ON C7_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
    WHERE SC7.D_E_L_E_T_ = ''
    AND C7_FILIAL = '01'
    AND C7_QUANT > C7_QUJE
    AND C7_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
    AND C7_ENCER = ''
    UNION
    SELECT 'AMAZON' EMPRESA,C7_NUM,C7_FORNECE,C7_LOJA,A2_NOME,A2_TEL,C7_ITEM,C7_PRODUTO,B1_DESC,B1_UM,B1_GRUPO,C7_EMISSAO,C7_DATPRF,C7_DTPRSP,C7_QUANT,C7_QUJE,
                    C7_PRECO,C7_VLDESC,C7_VALIPI,C7_TOTAL,(C7_QUANT-C7_QUJE) QTD_RECEBER,(C7_TOTAL-(C7_QUJE*C7_PRECO)) VLR_RECEBER,C7_OBS
    FROM SC7200 SC7 (NOLOCK)
    INNER JOIN SA2200 SA2 (NOLOCK) ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA AND A2_MSBLQL != '1' AND SA2.D_E_L_E_T_ = ''
    INNER JOIN SB1200 SB1 (NOLOCK) ON C7_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
    WHERE SC7.D_E_L_E_T_ = ''
    AND C7_FILIAL = '01'
    AND C7_QUANT > C7_QUJE
    AND C7_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
    AND C7_ENCER = ''
    ORDER BY 1,C7_NUM
		
    EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("Data Ini:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Data Fim:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	/*u_InPutSX1(cPerg,"03",PADR("De Pedido:" ,20)+"?","","","mv_ch3","C",10,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De Emissao:" ,20)+"?","","","mv_ch5","D",10,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Ate Emissao:",20)+"?","","","mv_ch6","D",10,0,0,"G","","","","","mv_par06")*/


Return
