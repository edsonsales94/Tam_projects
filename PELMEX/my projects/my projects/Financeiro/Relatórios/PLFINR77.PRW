#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR77    บAutor  ณJuevan Silva   				บ Data ณ 18/07/2025บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Rel. Layout para Envio Banco                      		     			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR77()
	Local oReport
	//Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR77"

	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)

	oReport := ReportDef(cAlias,cPerg)
	oReport:PrintDialog()
Return


Static Function ReportDef(cAlias,cPerg)
	Local oReport
	Local oSection
	//Local oFunction1
    //Local oBreak
	Local aOrdem  := {"FILIAL"}
   

	oReport := TReport():New(cPerg,"Rel. Layout para Envio Banco",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Layout para Envio Banco",{"SE2"},aOrdem)
	
    
	TRCell():New(oSection,"Nome"				,"SA1","Nome","@!",40)
	TRCell():New(oSection,"CNPJ"	     		,"SA1","CNPJ","@!",11)
    TRCell():New(oSection,"A1_END"	 			,"SA1","Endereco","@!",30)
    TRCell():New(oSection,"Bairro"	    		,"SA1","Bairro","@!",10)
    TRCell():New(oSection,"Cidade"	    		,"SA1","Cidade","@!",15)
    TRCell():New(oSection,"UF"	        		,"SA1","UF","@!",2)
    TRCell():New(oSection,"CEP"	        		,"SA1","CEP","@!",11)   
	TRCell():New(oSection,"Nota"	    		,"SF2","Nota","@!",10)
    TRCell():New(oSection,"Data_Emissao"	    ,"SF2","Dt. Emissao","@!",11) 
	TRCell():New(oSection,"Valor"	   	 		,"SE1","Valor","@E 9,999,999,999.99")
	TRCell():New(oSection,"Data_Vencimento"		,"SE1","Vencimento","@!",11)
    TRCell():New(oSection,"Chave"	   			,"SF2","Chave.","@!",45)
	TRCell():New(oSection,"Cedente/Fornecedor"	,"SE2","Cedente/Fornecedor","@!",15)
	TRCell():New(oSection,"Status NFe"	    	,"SE2","Status NFe","@!",10)
    TRCell():New(oSection,"Constata็๕es"	   	,"SE2","Constata็๕es","@!",10)
	TRCell():New(oSection,"Regras Cessใo Extra"	,"SE2","Regras Cessใo Extra","@!",10)
	TRCell():New(oSection,"Valida็ใo"	    	,"SE2","Valida็ใo","@!",10)
    TRCell():New(oSection,"Erros/Observa็๕es"   ,"SE2","Erros/Observa็๕es","@!",10)
    

//SELECT 'PELMEX' Empresa,E2_NUM,E2_PREFIXO,E2_PARCELA,E2_TIPO,E2_VALOR,E2_VALLIQ,E2_SALDO,
    //CONVERT(VARCHAR,CAST(E2_EMISSAO AS DATE),103)DT_EMISSAO,
    //CONVERT(VARCHAR,CAST(E2_VENCTO AS DATE),103)DT_VENCTO,
    //CASE WHEN E2_BAIXA = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E2_BAIXA AS DATE),103) END DT_BAIXA,
    //E2_FORNECE,E2_LOJA,E2_NOMFOR,
	//E2_NATUREZ,ED_DESCRIC,E2_HIST	

	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	

    //TRFunction():New(oSection:Cell("E2_VALOR"),"Total valor","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("DIFERENCA"),"Diferenca","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

	oReport:SetTotalInLine(.F.)

	//Quebra por Se็ใo
	oSection:SetPageBreak(.T.)
	oSection:SetTotalText(" ")

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)
	//Local oSection2  := oReport:Section(2)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ท
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
	%noparser%   


SELECT A1_NOME Nome,A1_CGC CNPJ,A1_END [Endere็o],A1_BAIRRO Bairro,A1_MUN Cidade,A1_EST UF,A1_CEP CEP,
       F2_DOC Nota,CONVERT(VARCHAR,CAST(F2_EMISSAO AS DATE),103)[Data_Emissao],
     E1_VALOR Valor,CONVERT(VARCHAR,CAST(E1_VENCTO AS DATE),103)[Data_Vencimento],F2_CHVNFE Chave,
     '' [Cedente/Fornecedor],'' [Status NFe],'' [Constata็๕es],'' [Regras Cessใo Extra],'' [Valida็ใo],'' [Erros/Observa็๕es]
FROM SF2100 SF2 (NOLOCK)
INNER JOIN SA1100 SA1 (NOLOCK) ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
INNER JOIN SE1100 SE1 (NOLOCK) ON F2_DOC = E1_NUM AND F2_SERIE = E1_PREFIXO AND F2_CLIENTE = E1_CLIENTE AND F2_LOJA = E1_LOJA AND SE1.D_E_L_E_T_ = ''
WHERE SF2.D_E_L_E_T_ = ''
AND F2_DOC BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND F2_SERIE BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND F2_CLIENTE BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
AND F2_EMISSAO BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
ORDER BY F2_DOC,F2_EMISSAO,E1_VENCTO
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De Doc "    ,20)+"?","","","mv_ch1","C",9,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Ate Doc "    ,20)+"?","","","mv_ch2","C",9,0,0,"G","","","","","mv_par02")
u_InPutSX1(cPerg,"03",PADR("De Serie ",20)+"?","","","mv_ch3","C",3,0,0,"G","","","","","mv_par03")
u_InPutSX1(cPerg,"04",PADR("Ate Serie ",20)+"?","","","mv_ch4","C",3,0,0,"G","","","","","mv_par04")
u_InPutSX1(cPerg,"05",PADR("De Cliente ",20)+"?","","","mv_ch5","C",6,0,0,"G","","","","","mv_par05")
u_InPutSX1(cPerg,"06",PADR("Ate Cliente"     ,20)+"?","","","mv_ch6","C",6,0,0,"G","","","","","mv_par06") 
u_InPutSX1(cPerg,"07",PADR("De Emissao NF"    ,20)+"?","","","mv_ch7","D",8,0,0,"G","","","","","mv_par07")
u_InPutSX1(cPerg,"08",PADR("Ate Emissao NF"   ,20)+"?","","","mv_ch8","D",8,0,0,"G","","","","","mv_par08")
//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
