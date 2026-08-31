#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR04    บAutor  ณStan Lee Lopes     				บ Data ณ  13/03/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  RELATORIO ANALISE DE MOVIMENTO VENDAS X ESTOQUE		        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR13()
Local oReport
Local cQuery
Local cAlias      := getNextAlias()
Private cPerg     := "PMPCPR13"

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

oReport := TReport():New(cPerg,"ENTRADA DO ESTOQUE",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
oReport:SetPortrait()      
oReport:SetEnvironment(2)      

//Primeira se็ใo
oSection := TRSection():New(oReport,"Entrada do estoque",{"SB2"},aOrdem)     


TRCell():New(oSection,"B1_CC"				,"SB1","Centro de Custo",/*Mascara*/,/*Tamanho*/) 
TRCell():New(oSection,"CTT_DESC01"			,"CTT","Descri็ใo",/*Mascara*/,)
TRCell():New(oSection,"TOTAL"		        ,"SC2","Total","@E 9,999,999,999.99",)           

TRFunction():New(oSection:Cell("TOTAL"),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

//Totalizador
/*                                                                                  



TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                            MIC
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
 	
 	 	SELECT B1_CC,CTT_DESC01,SUM(1) TOTAL
				
		FROM %Table:SZ1%  SZ1(NOLOCK)
		INNER JOIN %Table:SC2%  SC2 (NOLOCK) ON SUBSTRING(Z1_OP,1,6) = C2_NUM AND SZ1.D_E_L_E_T_ = '' 
		INNER JOIN %Table:SB1%  SB1 (NOLOCK) ON B1_COD = C2_PRODUTO
		INNER JOIN %Table:CTT%  CTT (NOLOCK) ON CTT.CTT_CUSTO = SB1.B1_CC AND CTT.D_E_L_E_T_ = ''
		WHERE SC2.D_E_L_E_T_ = '' 
		AND Z1_DTAPONT BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND C2_LOCAL BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND C2_PRODUTO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%  
		AND C2_CC BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
		
		GROUP BY C2_CC,CTT_DESC01
		ORDER BY 1
	
		
EndSQL 

oSection:EndQuery() 
oSection:SetParentQuery()
oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

PutSX1(cPerg,"01",PADR("Emissใo De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
PutSX1(cPerg,"02",PADR("Emissใo At้   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
PutSX1(cPerg,"03",PADR("Armaz้m De    ",20)+"?","","","mv_ch3","C",2,0,0,"G","","","","","mv_par03") 
PutSX1(cPerg,"04",PADR("Armaz้m At้   ",20)+"?","","","mv_ch4","C",2,0,0,"G","","","","","mv_par04") 
PutSX1(cPerg,"05",PADR("Produto De    ",20)+"?","","","mv_ch3","C",14,0,0,"G","","","","","mv_par05") 
PutSX1(cPerg,"06",PADR("Produto At้   ",20)+"?","","","mv_ch4","C",14,0,0,"G","","","","","mv_par06")
PutSX1(cPerg,"07",PADR("Centro de Custo De    ",20)+"?","","","mv_ch5","C",8,0,0,"G","","","","","mv_par07") 
PutSX1(cPerg,"08",PADR("Centro de Custo At้   ",20)+"?","","","mv_ch6","C",8,0,0,"G","","","","","mv_par08") 

Return