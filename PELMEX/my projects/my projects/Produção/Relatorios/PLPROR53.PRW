#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR52  บAutor  ณKledson Oliveira    				บ Data ณ 16/09/24 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Estrutura Produtos                    			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR53()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR53"

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

	oReport := TReport():New(cPerg,"Estrutura Produtos",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Estrutura Produtos",{"PED"},aOrdem) 
    
    TRCell():New(oSection,"G1_FILIAL"   	    ,"SG1",,,)
    TRCell():New(oSection,"G1_COD"	            ,"SG1",,,)
	TRCell():New(oSection,"DESCPA"	            ,"SB1","Descricใo PA",,100)
    TRCell():New(oSection,"G1_COMP"	            ,"SG1",,,)
	TRCell():New(oSection,"DESCPI"	            ,"SB1","Descricใo PI",,100)
    TRCell():New(oSection,"G1_TRT"	            ,"SG1",,,)
    TRCell():New(oSection,"G1_QUANT"  			,"SG1",,,)
    TRCell():New(oSection,"G1_PERDA"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_INI"		        ,"SG1",,,)
    TRCell():New(oSection,"G1_FIM"		        ,"SG1",,,)
	TRCell():New(oSection,"G1_OBSERV"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_FIXVAR"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_GROPC"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_OPC"		        ,"SG1",,,)
	TRCell():New(oSection,"G1_REVINI"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_REVFIM"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_NIV"		        ,"SG1",,,)
	TRCell():New(oSection,"G1_NIVINV"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_POTENCI"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_OK"		        ,"SG1",,,)
	TRCell():New(oSection,"G1_VLCOMPE"		    ,"SG1",,,)
	TRCell():New(oSection,"D_E_L_E_T_"		    ,"SG1",,,)
	TRCell():New(oSection,"R_E_C_N_O_"		    ,"SG1",,,)
	TRCell():New(oSection,"R_E_C_D_E_L_"		,"SG1",,,)
	TRCell():New(oSection,"G1_USERLGI"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_USERLGA"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_VECTOR"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_TIPVEC"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_XDIMENS"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_USAALT"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_LOCCONS"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_FANTASM"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_LISTA"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_XMAQBOR"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_XNBORD"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_XTECINV"		    ,"SG1",,,)
	TRCell():New(oSection,"G1_XDENSID"		    ,"SG1",,,)
    TRCell():New(oSection,"G1_XESPESS"		    ,"SG1",,,)
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("PED_QUANT"),"Total Etiqueta:","SUM",,,"@E 999,999,999.999",,.F.,.T.)

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

SELECT G1_FILIAL,G1_COD,SB1.B1_DESC DESCPA,G1_COMP,SB12.B1_DESC DESCPI,G1_TRT,G1_QUANT,G1_PERDA,G1_INI,G1_FIM,G1_OBSERV,G1_FIXVAR,G1_GROPC,G1_OPC,G1_REVINI,G1_REVFIM,G1_NIV,G1_NIVINV,
       G1_POTENCI,G1_OK,G1_VLCOMPE,SG1.D_E_L_E_T_,SG1.R_E_C_N_O_,SG1.R_E_C_D_E_L_,G1_USERLGI,G1_USERLGA,G1_VECTOR,G1_TIPVEC,G1_XDIMENS,G1_USAALT,G1_LOCCONS,
	   G1_FANTASM,G1_LISTA,G1_XMAQBOR,G1_XNBORD,G1_XTECINV,G1_XDENSID,G1_XESPESS
FROM SG1100 SG1 (NOLOCK)
INNER JOIN SB1100 SB1 (NOLOCK) ON G1_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB12 (NOLOCK) ON G1_COMP = SB12.B1_COD AND SB12.D_E_L_E_T_ = ''
WHERE SG1.D_E_L_E_T_ = ''
AND G1_COD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
ORDER BY G1_COD,G1_COMP,G1_TRT





		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Produto:",20)+"?","","","mv_ch1","C",15,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Produto:",20)+"?","","","mv_ch2","C",15,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
