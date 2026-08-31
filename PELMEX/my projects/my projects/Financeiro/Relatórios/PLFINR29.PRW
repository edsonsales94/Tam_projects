#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR29    บAutor  ณWylliam Silva     				บ Data ณ 08/04/2022บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rel. Livro Fiscal Notas                								 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR29()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR29"

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

	oReport := TReport():New(cPerg,"Rel. Livro Fiscal Notas",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Livro Fiscal Notas",{"SF3"},aOrdem)
	
		   
	TRCell():New(oSection,"FILIAL"	 	    ,"SF3","FILIAL","@!",3) 
	TRCell():New(oSection,"NFISCAL"	        ,"SF3","NOTA FISCAL","@!",9)
	TRCell():New(oSection,"SERIE"		    ,"SF3","SERIE","@!",2)
	TRCell():New(oSection,"DTENTRADA"	    ,"SF3","DTENTRADA","@!",10)
	TRCell():New(oSection,"CFO"	  			,"SF3","CFOP","@!",4)
	TRCell():New(oSection,"UF"	  			,"SF3","UF","@!",3)
	TRCell():New(oSection,"VALORCONT"		,"SF3","VALORCONT","@E 9,999,999,999.999",)
	TRCell():New(oSection,"OBSERV"	 		,"SF3","OBSERVAวรO","@!",30)
	TRCell():New(oSection,"TIPO"	  		,"SF3","TIPO","@!",4)
	TRCell():New(oSection,"DTCANCELADA"		,"SF3","DATA CANCELADA","@!",10)
	TRCell():New(oSection,"CHVNFE"			,"SF3","CHVNFE","@!",30)
	TRCell():New(oSection,"NUMPROTC"		,"SF3","NUM PROTOCOLO","@!",30)            
	

	//Segunda se็ใo
	//oSection2 := TRSection():New(oReport,"TOTAL GERAL RECEBER X NOTAS FISCAIS",{"SE1"},aOrdem)  

	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("VAL_RECEBER"),"TOTAL Recebido","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("VAL_PAGAR"),"TOTAL Pagar","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("DIFERENCA"),"Diferenca","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//oReport:SetTotalInLine(.F.)

	//Quebra por Se็ใo
	//oSection1:SetPageBreak(.T.)
	//oSection1:SetTotalText(" ")

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

	
		SELECT F3_FILIAL FILIAL,F3_NFISCAL NFISCAL,F3_SERIE SERIE,CONVERT(VARCHAR,CAST(F3_ENTRADA AS DATE),103) DTENTRADA,F3_CFO CFO,F3_ESTADO UF,F3_VALCONT VALORCONT,F3_OBSERV OBSERV,F3_TIPO TIPO,
       F3_DTCANC DTCANCELADA,F3_CHVNFE CHVNFE,F3_PROTOC NUMPROTC
		FROM SF3100 SF3
		WHERE SF3.D_E_L_E_T_ =''
		AND F3_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND F3_FILIAL BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		ORDER BY F3_ENTRADA

		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
		 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De Emissใo "      ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("At้ Emissใo "     ,20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
u_InPutSX1(cPerg,"03",PADR("De Filial "       ,20)+"?","","","mv_ch3","C",2,0,0,"G","","","","","mv_par03") 
u_InPutSX1(cPerg,"04",PADR("At้ Filial "      ,20)+"?","","","mv_ch4","C",2,0,0,"G","","","","","mv_par04")
   

Return