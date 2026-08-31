#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLRHR10    บAutor  ณJuevan Silva     				บ Data ณ  03/05/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rel. Att Salarial													 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLRHR10()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLRHR10"

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

	oReport := TReport():New(cPerg,"Rel. Att Salarial",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      •//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Att Salarial",{"SRA"},aOrdem) 


		TRCell():New(oSection,"FILIAL"	     ,"SRA","FILIAL","@!",01)
	    TRCell():New(oSection,"MAT"	        ,"SRA","MAT","@!",06)
        TRCell():New(oSection,"NOME"	    ,"SRA","NOME","@!",30)
        TRCell():New(oSection,"DATA"	     ,"SRA","DATA","@!",10)
        TRCell():New(oSection,"TIPO"	     ,"SRA","TIPO","@!",03)
        TRCell():New(oSection,"DESCRI"	     ,"SRA","DESCRI","@!",20)
        TRCell():New(oSection,"TIPOPGT"	     ,"SRA","TIPOPGT","@!",02)
        TRCell():New(oSection,"CC"	        ,"SRA","CC","@!",04)
        TRCell():New(oSection,"DESCRI01"	 ,"SRA","DESCRI01","@!",20)
        TRCell():New(oSection,"FUNCAO"	     ,"SRA","FUNCAO","@!",04)
        TRCell():New(oSection,"DESCFUN"	     ,"SRA","DESCFUN","@!",20)
         TRCell():New(oSection,"HR_DIA"	     ,"SRA","HR_DIA","@!",10)
        TRCell():New(oSection,"R3_VALOR"	 ,"SR3","R3_VALOR","@E 9,999,999,999.99",)
         TRCell():New(oSection,"DIAS"	     ,"SR3","DIAS","@E 9,999,999,999.99",)
    
    
    /*TRCell():New(oSection,"E1_VALOR"	     ,"SE1","Valor","@E 9,999,999,999.99",)	   
	TRCell():New(oSection,"E1_EMISSAO"	   ,"SE1","Emissao","@!",10) 
    TRCell():New(oSection,"E1_VENCREA"	     ,"SE1","DtVenc.","@!",10) 
	TRCell():New(oSection,"E1_BAIXA"	   	    ,"SE1","DtBaixa","@!",10)
    TRCell():New(oSection,"E1_CLIENTE"	   	  ,"SE1","Cliente","@!",6)
    TRCell():New(oSection,"A1_NOME"	   	      ,"SA1","Nome.Cliente","@!",30)
	TRCell():New(oSection,"A1_NREDUZ"       ,"SA1","Nome Reduz","@!",15)
	TRCell():New(oSection,"A1_MUN"	    	,"SA1","Munic","@!",15)*/  
	//Totalizador                                                                                  

	/*
	TRFunction():New(oSection:Cell("RD_VALOR"),"Despesas da folha","SUM",,,"@E 9,999,999.999.99",,.F.,.T.)  
	TRFunction():New(oSection:Cell("RD_HORAS"),"Horas Totais","SUM",,,"@E 9,999,999,999.99",,.F.,.T.) 

	TRFunction():New(oSection:Cell("M"),"Masculino","SUM",,,,,.F.,.T.)  
	TRFunction():New(oSection:Cell("F"),"Feminino","SUM",,,,,.F.,.T.)  
	*/
	//TRFunction():New(oSection:Cell("DA1_DESC"),"TOTAL DIFERENวA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)  
	//TRFunction():New(oSection:Cell("DA1_TOTAL"),"TOTAL FABRICA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)  
	/*
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                      MIMIM ท
	//endif      
	Local nTotReg :=0

	oSection:BeginQuery()



	BeginSQL Alias cAlias
		%noparser%   


SELECT RA_FILIAL FILIAL,RA_MAT MAT,RA_NOME NOME,R7_DATA DATA,R7_TIPO TIPO,X5_DESCRI DESCRI,R7_TIPOPGT TIPOPGT,RA_CC CC,CTT_DESC01 DESC01,R7_FUNCAO FUNCAO,R7_DESCFUN DESCFUN,HR_DIA,R3_VALOR,DIAS
FROM(
SELECT RA_FILIAL,RA_MAT,RA_NOME,
       R7_DATA,R7_TIPO,X5_DESCRI,R7_TIPOPGT,RA_CC,CTT_DESC01,R7_FUNCAO,R7_DESCFUN,R3_VALOR/RA_HRSMES HR_DIA, R3_VALOR,
     ISNULL(DATEDIFF(DAY,LAG(R7_DATA) OVER (ORDER BY R7_DATA),R7_DATA),0)DIAS
FROM %Table:SR7100% AS SR7 (NOLOCK)
INNER JOIN %Table:SR3100% AS SR3 (NOLOCK) ON R7_FILIAL = R3_FILIAL AND R7_MAT = R3_MAT AND R3_TIPO = R7_TIPO AND R3_SEQ = R7_SEQ  AND R7_DATA = R3_DATA AND R3_PD = '000' AND SR3.D_E_L_E_T_ = ''
INNER JOIN %Table:SRA100% AS  SRA (NOLOCK) ON R7_FILIAL = RA_FILIAL AND R7_MAT = RA_MAT AND SRA.D_E_L_E_T_ = '' 
INNER JOIN %Table:SX5100% AS  SX5 (NOLOCK) ON X5_TABELA = '41' AND CASE WHEN X5_FILIAL = '' THEN '' ELSE RA_FILIAL END = CASE WHEN X5_FILIAL = '' THEN '' ELSE X5_FILIAL END AND R7_TIPO = X5_CHAVE AND SX5.D_E_L_E_T_ = '' 
INNER JOIN %Table:CTT100% AS  CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
WHERE SR7.D_E_L_E_T_ = ''
AND RA_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND R7_DATA BETWEEN  %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND R7_MAT BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
AND RA_CC BETWEEN '' AND 'ZZZZZZ'
AND R7_FUNCAO BETWEEN '' AND 'ZZZZZZ'
)TB
GROUP BY RA_FILIAL,RA_MAT,RA_NOME,R7_DATA,R7_TIPO,X5_DESCRI,R7_TIPOPGT,RA_CC,CTT_DESC01,R7_FUNCAO,R7_DESCFUN,HR_DIA,R3_VALOR,DIAS
ORDER BY RA_FILIAL,RA_NOME,R7_DATA


	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return



Static Function AjustaSX1(cPerg)            
    u_InPutSX1(cPerg,"01",PADR("De Filial ",20)+"?","","","mv_ch3","C",2,0,0,"G","","SM0","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("At้ Filial",20)+"?","","","mv_ch4","C",2,0,0,"G","","SM0","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("De Data   ",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("At้ Data   ",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De Matricula",20)+"?","","","mv_ch7","C",6,0,0,"G","","SRA","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("At้ Matricula",20)+"?","","","mv_ch8","C",6,0,0,"G","","SRA","","","mv_par06") 

	
Return
