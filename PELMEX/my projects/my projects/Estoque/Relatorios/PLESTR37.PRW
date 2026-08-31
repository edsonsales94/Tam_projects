#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR37    บAutor  ณKledson Oliveira    				บ Data ณ  21/03/25 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Coleta RFID x Saida por Valor						  					 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLESTR37()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLESTR37"

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

	oReport := TReport():New(cPerg,"Coleta RFID x Saida por Valor",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Coleta RFID x Saida por Valor",{"SB2"},aOrdem)  


	TRCell():New(oSection,"PIK_FILIAL" 		,"SD1","Filial","@!",2) 
	TRCell():New(oSection,"RA_MAT"		,"SF1","Matricula","@!",4)             
	TRCell():New(oSection,"PIK_DATINC"   		,"SD1","Dt. Inclusao","@!",11)
	TRCell():New(oSection,"PIK_PRODUTO"    	,"SD1","Produto","@!",15)
    TRCell():New(oSection,"PIK_DESC"    		,"SD1","Descricao","@!",30)
	TRCell():New(oSection,"QTD"    		,"SD1","Qtd. Bip","@E 9,999,999,999.99",)
	TRCell():New(oSection,"SALDO_20"    	,"SD1","Qtd. Saldo","@E 9,999,999,999.99",)
	//TRCell():New(oSection,"D1_CF"    		,"SD1","CFOP","@!",4)
	//TRCell():New(oSection,"CDA_CLIFOR"    	,"CDA","Cli/Forn","@!",6)
	//TRCell():New(oSection,"CDA_LOJA"    	,"CDA","Loja","@!",2)
	//TRCell():New(oSection,"D1_PICM"    		,"SD1","Aliq. ICMS","@!",2)
	//TRCell():New(oSection,"D1_VALICM"    	,"SD1","Val. ICMS","@E 999,999,999,999",)
    //TRCell():New(oSection,"D1_BASEICM"    	,"SD1","Base ICMS","@E 999,999,999,999",)
	//TRCell():New(oSection,"CDA_BASE"    	,"CDA","Val. Base Lanc","@E 999,999,999,999",)
	//TRCell():New(oSection,"CDA_VALOR"    	,"CDA","Val. Lanc","@E 999,999,999,999",)
	//TRCell():New(oSection,"D1_TOTAL"    	,"SD1","Total nota","@E 999,999,999,999",)
	//TRCell():New(oSection,"CDA_TPMOVI"    	,"CDA","Tipo Mov","@!",1)
	//TRCell():New(oSection,"CDA_CODLAN"    	,"CDA","Cod. Lanc","@!",15)

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


SELECT PIK_DATINC, PIK_USERINC, CHIP, CODIGO, PRECO, DESCRICAO, QTD, 
       ISNULL(PEDIDO_ORIG, '') PED_ORIG, CARGA, 
       CONVERT(VARCHAR, CAST(ISNULL(ENTRADA, '') AS DATE), 113) DT_ENTRADA, 
       ISNULL(DT_BIP_SAIDA, '') DT_BIP_SAI, 
       CASE WHEN CNF_EXPEDICAO IS NULL THEN '-' ELSE CNF_EXPEDICAO END DT_EXPED, 
       PED_SAI, NOTA_SEC, 
       NOTA_ORIG, ARMAZEM, CLI_ORIG, NOME_CLI_ORIG, MUNICIPIO, CLI_SEC
FROM (
    SELECT PIK_DATINC, PIK_USERINC, PIK_CPRODUC AS CHIP, PIK_PRODUTO AS CODIGO, 
           ISNULL(SD2.D2_PRCVEN, 0) AS PRECO, -- Corre็ใo do nome da coluna
           PIK_DESC AS DESCRICAO, 
           CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END QTD,
           PED_NUM PEDIDO_ORIG, C2_XCARGA CARGA,
           Z1_DTAPONT ENTRADA,
           SAI_DTEXP DT_BIP_SAIDA, CNF_DOC, CNF_EXPEDICAO, SAI_PEDIDO PED_SAI, SAI_DOC NOTA_SEC,
           C6_NOTA NOTA_ORIG, C6_LOCAL ARMAZEM, PED_CLIENTE CLI_ORIG, PED_NOME NOME_CLI_ORIG, 
           PED_MUN MUNICIPIO, SAI_NOME CLI_SEC
    FROM PIK 
        LEFT JOIN (
            SELECT PED_FILIAL, PED_NUM, PED_OP, PED_PRODUTO, PED_ITEM, PED_LOCAL, PED_CLIENTE, PED_NOME, PED_MUN
            FROM PED
            WHERE PED_DTPROPEL != '' AND PED_OP != ''
        ) PED ON SUBSTRING(PIK_CPRODUC,1,6) = PED_OP AND PED_PRODUTO = PIK_PRODUTO 

        INNER JOIN (
            SELECT RA_NOME, RA_MAT, RA_FILIAL
            FROM SRA100 SRA
            WHERE D_E_L_E_T_ = '' AND RA_MAT BETWEEN %Exp:MV_PAR01%  AND %Exp:MV_PAR02% 
        ) SRA ON PIK_USERINC = RA_NOME 
        
        LEFT JOIN (
            SELECT Z1_OP, Z1_CHASSIS, Z1_DTAPONT
            FROM SZ1100 SZ1 
            WHERE D_E_L_E_T_ = ''
        ) SZ1 ON Z1_OP + Z1_CHASSIS = PIK_CPRODUC

        LEFT JOIN (
            SELECT SAI_FILIAL, SAI_PEDIDO, SAI_DOC, SAI_CPRODUC, SAI_PRODUTO, SAI_DESCPROD, SAI_DTEXP, SAI_NOME
            FROM SAI 
        ) SAI ON PIK_CPRODUC = SAI_CPRODUC 

        LEFT JOIN SC6100 SC6 ON PED_NUM = C6_NUM 
            AND SC6.D_E_L_E_T_ = '' 
            AND PED_PRODUTO = C6_PRODUTO 
            AND PED_ITEM = C6_ITEM 
            AND PED_FILIAL = C6_FILIAL
            AND PED_LOCAL = C6_LOCAL
            AND PED_CLIENTE = C6_CLI
        
        LEFT JOIN (
            SELECT C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO, C2_XCARGA
            FROM SC2100
            WHERE D_E_L_E_T_ = ''
        ) SC2 ON SUBSTRING(PIK_CPRODUC,1,11) = (C2_NUM + C2_ITEM + C2_SEQUEN) 
             AND PIK_PRODUTO = C2_PRODUTO 

        INNER JOIN SB1100 SB1 ON B1_COD = PIK_PRODUTO AND SB1.D_E_L_E_T_ = ''

        LEFT JOIN CNF ON SAI_DOC = CNF_DOC
        
        LEFT JOIN (
            SELECT D2_FILIAL, D2_COD, D2_PRCVEN
            FROM SD2100
            WHERE D_E_L_E_T_ = ''
        ) SD2 ON PIK_PRODUTO = SD2.D2_COD
        
    WHERE CAST(PIK_DATINC AS DATE) BETWEEN %Exp:MV_PAR03%  AND %Exp:MV_PAR04% 
) tb
WHERE CODIGO BETWEEN '' AND 'ZZZZZZZZZZZ'
ORDER BY CHIP ASC;




	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("",20)+"","","","mv_ch1","C",8,0,0,"G","","SRA","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Func. Desligado   ? ",20)+"","","","mv_ch2","N",8,0,0,"C","","","","","mv_par02","1 - NAO","","","","2 - SIM")
	u_InPutSX1(cPerg,"03",PADR("Dt. contagem De    ? ",20)+"","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Dt. contagem Ate   ? ",20)+"","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Nota Coleta    ? ",20)+"","","","mv_ch5","C",15,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("Filial Arm  ? ",20)+"","","","mv_ch6","C",2,0,0,"G","","SM0","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Armazem    ? ",20)+"","","","mv_ch7","C",2,0,0,"G","","","","","mv_par07")


Return
