#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR31    บAutor  ณWylliam Silva    	    			บ Data ณ  26/04/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rio Frete               						  					 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLESTR32()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLESTR32"

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

	oReport := TReport():New(cPerg,"Relat๓rio Frete",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Relat๓rio Frete",{"SE2"},aOrdem)  

	TRCell():New(oSection,"EMPRESA"		    ,"SE2","EMPRESA","@!",8)           
	TRCell():New(oSection,"E2_NUM" 	        ,"SE2","NUM_DOC","@!",12) 
	TRCell():New(oSection,"E2_PREFIXO"      ,"COL","PREFIXO","@!",3)
	TRCell():New(oSection,"E2_TIPO"  		,"SB2","TIPO","@!",3)
    TRCell():New(oSection,"E2_PARCELA"      ,"SB1","PARCELA","@!",3) 
    TRCell():New(oSection,"E2_VALOR"        ,"SB1","VALOR","@E 999,999,999.99",)
    TRCell():New(oSection,"E2_EMISSAO"    	,"SB2","EMISSAO","@!",10) 
	TRCell():New(oSection,"E2_VENCTO"    	,"SB2","VENCTO","@!",10)  
    TRCell():New(oSection,"E2_BAIXA"        ,"COL","BAIXA","@!",10)
    TRCell():New(oSection,"E2_FORNECE"    	,"SB2","CODIG_FORNE","@!",8) 
    TRCell():New(oSection,"A2_NOME"    	    ,"SB2","NOME_FORNE","@!",35) 
    TRCell():New(oSection,"E2_NATUREZ"    	,"SB2","NATUREZA","@!",8) 
    TRCell():New(oSection,"E2_HIST"      	,"SB2","HISTORICO","@!",45) 
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

    SELECT 'AMAZON' EMPRESA,E2_NUM,E2_PREFIXO,E2_TIPO,E2_PARCELA,E2_VALOR,E2_EMISSAO,E2_VENCTO,E2_BAIXA,E2_FORNECE,A2_NOME,E2_NATUREZ,E2_HIST
    FROM %Table:SE2% SE2 (NOLOCK)
    INNER JOIN %Table:SA2% SA2 (NOLOCK) ON E2_FORNECE = A2_COD AND E2_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ''
    WHERE SE2.D_E_L_E_T_ = ''
    AND E2_HIST LIKE '%FRETE%'
    AND E2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
    UNION
    SELECT 'PELMEX' EMPRESA,E2_NUM,E2_PREFIXO,E2_TIPO,E2_PARCELA,E2_VALOR,E2_EMISSAO,E2_VENCTO,E2_BAIXA,E2_FORNECE,A2_NOME,E2_NATUREZ,E2_HIST
    FROM %Table:SE2% SE2 (NOLOCK)
    INNER JOIN %Table:SA2% SA2 (NOLOCK) ON E2_FORNECE = A2_COD AND E2_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ''
    WHERE SE2.D_E_L_E_T_ = ''
    AND E2_HIST LIKE '%FRETE%'
    AND E2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%

ORDER BY 1,E2_EMISSAO


	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Data Ini:"  ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Data Fim:"  ,20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	/*u_InPutSX1(cPerg,"03",PADR("Doc. Invent:" ,20)+"?","","","mv_ch3","C",9,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Filial:",20)+"?","","","mv_ch4","C",2,0,0,"G","","","","","mv_par04")*/

Return
