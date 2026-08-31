#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR36    บAutor  ณKledson Oliveira    				บ Data ณ  19/03/25 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Coleta RFID x Saldo						  					 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLESTR36()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLESTR36"

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

	oReport := TReport():New(cPerg,"Coleta RFID x Saldo",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Coleta RFID x Saldo",{"SB2"},aOrdem)  


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

SELECT PIK_FILIAL, RA_MAT, PIK_DATINC, PIK_PRODUTO, PIK_DESC, CAST(SUM(QTD) AS FLOAT)QTD, SB2.B2_QATU SALDO_20
FROM (
SELECT PIK_FILIAL, RA_MAT, PIK_CPRODUC, PIK_PRODUTO, PIK_DESC, PIK_DATINC,
    CASE WHEN B1_XJUNCAO = 'S'
THEN 0.5
ELSE 1 END QTD
FROM PIK 
INNER JOIN SB1100 SB1 ON PIK_PRODUTO = B1_COD 
AND SB1.D_E_L_E_T_ = ''
INNER JOIN(
        SELECT RA_NOME, RA_MAT, RA_FILIAL, 
        CASE WHEN RA_DEMISSA = ''
        THEN '1 - NAO'
        ELSE '2 - SIM'
        END DEMITIDO                                    
        FROM SRA100 SRA
        WHERE SRA.D_E_L_E_T_ = ''
    )SRA ON RA_NOME = PIK_USERINC
    AND RA_FILIAL = PIK_FILIAL
            AND RA_MAT = %Exp:mv_par01%
            	AND CAST(SUBSTRING(DEMITIDO,1,1)AS INT) = %Exp:mv_par02%
WHERE CAST(PIK_DATINC AS DATE) BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
	AND PIK_NOTA = %Exp:mv_par05%
GROUP BY PIK_CPRODUC, PIK_PRODUTO, PIK_DESC, B1_XJUNCAO, PIK_FILIAL, RA_MAT, PIK_DATINC
)TB
LEFT JOIN (
SELECT B2_COD, B2_LOCAL, B2_QATU, B2_FILIAL
FROM SB2100 SB2 
WHERE SB2.D_E_L_E_T_ = ''
    AND B2_FILIAL = %Exp:mv_par06%
        AND B2_LOCAL = %Exp:mv_par07%
)SB2 ON PIK_PRODUTO = B2_COD
GROUP BY PIK_PRODUTO, PIK_DESC, SB2.B2_QATU, PIK_FILIAL, RA_MAT, PIK_DATINC



	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Matricula",20)+"","","","mv_ch1","C",8,0,0,"G","","SRA","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Func. Desligado   ? ",20)+"","","","mv_ch2","N",8,0,0,"C","","","","","mv_par02","1 - NAO","","","","2 - SIM")
	u_InPutSX1(cPerg,"03",PADR("Dt. contagem De    ? ",20)+"","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Dt. contagem Ate   ? ",20)+"","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Nota Coleta    ? ",20)+"","","","mv_ch5","C",15,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("Filial Arm  ? ",20)+"","","","mv_ch6","C",2,0,0,"G","","SM0","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Armazem    ? ",20)+"","","","mv_ch7","C",2,0,0,"G","","","","","mv_par07")


Return
