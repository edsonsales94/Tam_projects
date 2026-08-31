#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMLOJR15    บAutor  ณWylliam Silva     				บ Data ณ  20/06/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de Venda de Loja	      										 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMLOJR15()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMLOJR15"

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

	oReport := TReport():New(cPerg,"Relat๓rio de Venda de Loja",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Relat๓rio de Venda de Loja",{"SL1"},aOrdem) 

	TRCell():New(oSection,"L1_FILRES"			,"SL1","Filial","!@",4) 
	TRCell():New(oSection,"L1_ORCRES"			,"SL1","Or็amento","!@",10)
	TRCell():New(oSection,"L1_FILDEST"			,"SL1","Filial Dest","!@",4)
	TRCell():New(oSection,"L1_ORCDEST"			,"SL1","Or็amento Dest.","!@",10)
	TRCell():New(oSection,"SC5.C5_NUM"		  	,"SC5","Pedido","!@",8) 
	TRCell():New(oSection,"D2_DOC"		    	,"SD2","NF Saํda","!@",9)
	TRCell():New(oSection,"D2_SERIE"		    ,"SD2","Serie Saํda","!@",3)
	TRCell():New(oSection,"D1_DOC"		 		,"SD1","NF Entrada","!@",9)
	TRCell():New(oSection,"D1_SERIE"			,"SD1","Serie Entrada","!@",3) 
	TRCell():New(oSection,"D1_EMISSAO"			,"SD1","DT Entrada","!@",10) 
	TRCell():New(oSection,"L1_NSUTEF"			,"SL1","NSUTEF","!@",10) 
	TRCell():New(oSection,"L1_DOCPED"			,"SL1","Num.NF","!@",9) 
	TRCell():New(oSection,"L1_SERPED"			,"SL1","Serie NF","!@",3) 
	TRCell():New(oSection,"L1_EMISNF"			,"SL1","DT Emissใo NF","!@",10) 
	TRCell():New(oSection,"C6_ITEM"				,"SC6","Item","!@",3) 
	TRCell():New(oSection,"C6_PRODUTO"			,"SC6","Produto","!@",15) 
	TRCell():New(oSection,"C6_DESCRI"			,"SC6","Descri็ใo","!@",30)
	TRCell():New(oSection,"C6_QTDVEN"			,"SC6","QTD","@E 999,999,99",)
	TRCell():New(oSection,"C6_VALOR"			,"SC6","Filial","@E 999,999,999,99",)
	TRCell():New(oSection,"L1_CLIENTE"			,"SL1","Filial","!@",15)
	TRCell():New(oSection,"A1_NOME"				,"SA1","Filial","!@",30)
	TRCell():New(oSection,"L1_VEND"				,"SL1","Filial","!@",15)
	TRCell():New(oSection,"A3_NOME"				,"SA3","Filial","!@",30)
	
	//Totalizador
	/*                                                                                  
	TRFunction():New(oSection:Cell("L2_VLRITEM"),"TOTAL BASE","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)  
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)
	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ท
	//endif      


	oSection:BeginQuery()
BeginSQL Alias cAlias
		%noparser%   

		SELECT L1_FILRES,L1_ORCRES,L1_FILDEST,L1_ORCDEST,SC5.C5_NUM,
		       ISNULL(D2_DOC,'')D2_DOC,ISNULL(D2_SERIE,'')D2_SERIE,
		       ISNULL(D1_DOC,'')D1_DOC,ISNULL(D1_SERIE,'')D1_SERIE,ISNULL(D1_EMISSAO,'')D1_EMISSAO,
		       L1_NSUTEF,L1_DOCPED,L1_SERPED,L1_EMISNF,
		       C6_ITEM,C6_PRODUTO,C6_DESCRI,
	  	       CASE WHEN D1_DOC IS NULL THEN C6_QTDVEN ELSE C6_QTDVEN * -1 END C6_QTDVEN,
		       CASE WHEN D1_DOC IS NULL THEN C6_VALOR ELSE C6_VALOR * -1 END C6_VALOR,
		       L1_CLIENTE,A1_NOME,L1_VEND,A3_NOME
				FROM(
				SELECT SL11.L1_FILRES,SL11.L1_FILIAL L1_FILDEST,SL1.L1_NUM,SL11.L1_ORCRES,SL11.L1_NUM L1_ORCDEST,SL1.L1_DOC,SL1.L1_SERIE,SL1.L1_NSUTEF,SL1.L1_DOCPED,SL1.L1_SERPED,SL1.L1_EMISNF,SL1.L1_CLIENTE,SL1.L1_VEND
				FROM SL1100 SL1 (NOLOCK)
				LEFT JOIN (SELECT L1_FILIAL,L1_FILRES,L1_NUM,L1_ORCRES,L1_CLIENTE,L1_DOC,L1_SERIE,L1_EMISNF
				           FROM SL1100 SL11 (NOLOCK)
					       WHERE SL11.D_E_L_E_T_ = ''
					       AND ISNULL(SL11.L1_ORCRES,'') != ''
					       )SL11 ON SL1.L1_FILIAL = SL11.L1_FILRES AND SL1.L1_NUM = SL11.L1_ORCRES
				WHERE SL1.D_E_L_E_T_ = ''
				)TB
				LEFT JOIN SC5100 SC5 (NOLOCK) ON  CASE WHEN SC5.C5_XORCRES = '' THEN L1_FILDEST ELSE L1_FILRES END = CASE WHEN SC5.C5_XORCRES = '' THEN SC5.C5_FILIAL ELSE SC5.C5_XFILRES END AND 
				                                  CASE WHEN SC5.C5_XORCRES = '' THEN L1_ORCDEST ELSE L1_ORCRES END = CASE WHEN SC5.C5_XORCRES = '' THEN SC5.C5_ORCRES ELSE SC5.C5_XORCRES END AND 
				                                  L1_NUM = L1_ORCRES AND C5_FILIAL = L1_FILDEST AND C5_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND C5_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% AND SC5.D_E_L_E_T_ = ''
				INNER JOIN SC6100 SC6 (NOLOCK) ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.D_E_L_E_T_ = ''
				LEFT JOIN SD2100 SD2 (NOLOCK) ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV AND C6_PRODUTO = D2_COD AND SD2.D_E_L_E_T_ = ''
				LEFT JOIN (SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_NFORI,D1_SERIORI,D1_ITEMORI,D1_COD,D1_QUANT,D1_FORNECE,D1_EMISSAO
				           FROM SD1100 SD1 (NOLOCK)
				       WHERE SD1.D_E_L_E_T_ = '')SD1 ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD
				INNER JOIN SA1100 SA1 (NOLOCK) ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND SA1.D_E_L_E_T_ = ''
				LEFT JOIN SA3100 SA3 (NOLOCK) ON C5_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ''
				UNION
				SELECT L1_FILRES,L1_ORCRES,L1_FILIAL,L1_NUM,'' C5_NUM,L1_DOC,L1_SERIE,D1_DOC,D1_SERIE,D1_EMISSAO,L1_NSUTEF,L1_DOCPED,L1_SERPED,L1_EMISNF,L2_ITEM,L2_PRODUTO,L2_DESCRI,
				       CASE WHEN D1_DOC IS NULL THEN L2_QUANT ELSE L2_QUANT * -1 END C6_QTDVEN,
				     CASE WHEN D1_DOC IS NULL THEN L2_VLRITEM ELSE L2_VLRITEM * -1 END C6_VALOR,
				     L1_CLIENTE,A1_NOME,L1_VEND,A3_NOME
				FROM SL1100 SL1 (NOLOCK)
				INNER JOIN SL2100 SL2 (NOLOCK) ON L1_FILIAL = L2_FILIAL AND L1_NUM = L2_NUM AND SL2.D_E_L_E_T_ = ''
				LEFT JOIN SD2100 SD2 (NOLOCK) ON L1_FILIAL = D2_FILIAL AND L1_DOC = D2_DOC AND L1_SERIE = D2_SERIE AND SD2.D_E_L_E_T_ = ''
				INNER JOIN SA1100 SA1 (NOLOCK) ON L1_CLIENTE = A1_COD AND L1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
				LEFT JOIN (SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_NFORI,D1_SERIORI,D1_ITEMORI,D1_COD,D1_QUANT,D1_FORNECE,D1_EMISSAO
				           FROM SD1100 SD1 (NOLOCK)
				           WHERE SD1.D_E_L_E_T_ = '')SD1 ON L1_FILIAL = D1_FILIAL AND L1_DOC = D1_NFORI AND L1_SERIE = D1_SERIORI AND L2_ITEM = D1_ITEMORI AND L2_PRODUTO = D1_COD
				LEFT JOIN SA3100 SA3 (NOLOCK) ON L1_VEND = A3_COD AND SA3.D_E_L_E_T_ = ''
				
		WHERE SL1.D_E_L_E_T_ = ''
		AND D2_DOC IS NULL
		AND L1_DOC != ''
		AND L1_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND L1_EMISNF BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
				
		ORDER BY L1_FILRES,C5_NUM,C6_ITEM
		
		

EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return

Static Function AjustaSX1(cPerg)
	u_InPutSX1(cPerg,"01",PADR("De Filial    ",20)+"?","","","mv_ch1","C",4,0,0,"G","","","","","mv_par01")  
	u_InPutSX1(cPerg,"02",PADR("Ate Filial   ",20)+"?","","","mv_ch2","C",4,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Data NF   ",20)+"?","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Ate Data NF  ",20)+"?","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")
Return
