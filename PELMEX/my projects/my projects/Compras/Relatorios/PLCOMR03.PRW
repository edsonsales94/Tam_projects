#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLCOMR03    บAutor  ณWilson Guedes     				บ Data ณ  13/03/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  LISTAGEM PARA PRODUวรO		  						        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLCOMR03()
Local oReport
Local cQuery
Local cAlias      := getNextAlias()
Private cPerg     := "PLCOMR03"

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

oReport := TReport():New(cPerg,"CUSTO ENTRADA X CUSTO STAND",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
oReport:SetPortrait()      
oReport:SetEnvironment(2)      

//Primeira se็ใo
oSection := TRSection():New(oReport,"CUSTO ENTRADA X CUSTO STAND",{"SD1"},aOrdem)     


TRCell():New(oSection,"D1_COD"		        	,"SD1","COD",,)
TRCell():New(oSection,"B1_DESC"	    			,"SB1","Descri็ใo",,)
TRCell():New(oSection,"D1_VUNIT"				,"SD1","Custo Entrada",/*Mascara*/,) 
TRCell():New(oSection,"B1_CUSTD"	        	,"SB1","Custo Stand ",/*Mascara*/,)
TRCell():New(oSection,"D1_DOC"      			,"SD1","Documento",/*Mascara*/,)
TRCell():New(oSection,"D1_SERIE"      			,"SD1","S้rie",/*Mascara*/,4)
TRCell():New(oSection,"D1_EMISSAO"       		,"SD1","Dt. Emissใo",/*Mascara*/,12)


//Totalizador
/*                                                                                  

TRFunction():New(oSection:Cell("D2_TOTAL"),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

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
 	
		SELECT SD1.D1_COD,B1_DESC,D1_VUNIT,B1_CUSTD,D1_DOC,D1_SERIE,D1_EMISSAO 
		FROM FROM %Table:SD1% SD1 (NOLOCK)
		INNER JOINFROM %Table:SB1% SB1 (NOLOCK) ON B1_COD = D1_COD AND SB1.D_E_L_E_T_ =''  AND SB1.B1_MSBLQL != '1'
		WHERE SD1.D_E_L_E_T_ = ''
		AND SD1.R_E_C_N_O_ = (SELECT MAX (SD1.R_E_C_N_O_)
							  FROM SD1200 SD1 (NOLOCK)
							  INNER JOIN SB1200 SB1 (NOLOCK) ON B1_COD = D1_COD AND SB1.D_E_L_E_T_ =''  AND SB1.B1_MSBLQL != '1' AND SB1.B1_TIPO IN ('PA','PI','PC','MA','MI','MN')
							  WHERE SD1.D_E_L_E_T_ = '' 
							  AND SD1.D1_COD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
							  AND SD1.D1_TIPO != 'D'
							  AND SD1.D1_TES NOT IN ('848')
							  AND SD1.D1_SERIE NOT IN ('UNI')
)
	
	
	
		SELECT C2_NUM,C2_PRODUTO,SB1.B1_DESC,C2_QUANT,C2_OBS,C2_DATPRI,C2_DATPRF
		FROM %Table:SC2% AS SC2 (NOLOCK)
			INNER JOIN %Table:SB1% AS SB1 (NOLOCK) ON SB1.B1_COD = SC2.C2_PRODUTO AND SB1.D_E_L_E_T_ = '' AND SB1.B1_MSBLQL != '1'
		WHERE SC2.D_E_L_E_T_ = ''
			AND SC2.C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
			AND SC2.C2_QUANT != SC2.C2_QUJE
			AND SC2.C2_DATRF = ''
		ORDER BY C2_DATPRF,C2_OBS,B1_DESC


		
EndSQL 

oSection:EndQuery() 
oSection:SetParentQuery()
oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)
u_InPutSx1(cPerg, "01", "Produto de",		"","","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01")
u_InPutSx1(cPerg, "02", "Produto Ate",		"","","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02")

Return