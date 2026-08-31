#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR86   บAutor  ณJuevan Silva     				บ Data ณ  31/10/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   	Modelo de Estrutura Completa                        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR86()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR86"

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

	oReport := TReport():New(cPerg,"Modelo de Estrutura Completa",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Modelo de Estrutura Completa",{"SG1"},aOrdem) 

    TRCell():New(oSection,"G1_FILIAL"		,"SG1","G1_FILIAL","@!",10)
	TRCell():New(oSection,"G1_COD"			,"SG1","G1_COD","@!",10)
	TRCell():New(oSection,"G1_COMP"			,"SG1","G1_COMP","@!",10) 
	TRCell():New(oSection,"G1_TRT"			,"SG1","G1_TRT","@!",30)   
	TRCell():New(oSection,"G1_QUANT"		,"SG1","G1_QUANT","@E 999,999,999,999",)
	TRCell():New(oSection,"G1_PERDA"  		,"SG1","G1_PERDA","@!",30)
	TRCell():New(oSection,"G1_INI"			,"SG1","G1_INI","@!",5)         
	TRCell():New(oSection,"G1_FIM"  		,"SG1","G1_FIM","@!",10)
	TRCell():New(oSection,"G1_OBSERV"		,"SG1","G1_OBSERV","@!",15)
	TRCell():New(oSection,"G1_FIXVAR"  		,"SG1","G1_FIXVAR","@!",30)
	TRCell():New(oSection,"G1_GROPC"  		,"SG1","G1_GROPC","@!",20)
	TRCell():New(oSection,"G1_OPC"			,"SG1","G1_OPC","@!",10)
	TRCell():New(oSection,"G1_REVINI"  		,"SG1","G1_REVINI","@!",20)
	TRCell():New(oSection,"G1_REVFIM"		,"SG1","G1_REVFIM","@!",20) 
	TRCell():New(oSection,"G1_NIV"			,"SG1","G1_NIV","@!",20)
	TRCell():New(oSection,"G1_NIVIN"		,"SG1","G1_NIVIN","@!",8)
    TRCell():New(oSection,"G1_POTENCI"		,"SG1","G1_POTENCI","@!",6)
    TRCell():New(oSection,"G1_OK"			,"SG1","G1_OK","@!",6)
    TRCell():New(oSection,"G1_VLCOMPE"		,"SG1","G1_VLCOMPE","@!",6)
    TRCell():New(oSection,"G1_USERLGI"		,"SG1","G1_USERLGI","@!",10)
    TRCell():New(oSection,"G1_USERLGA"		,"SG1","G1_UGERLGA","@!",10)
    TRCell():New(oSection,"G1_VECTOR"		,"SG1","G1_VECTOR","@!",6)
    TRCell():New(oSection,"G1_TIPVEC"		,"SG1","G1_TIPVEC","@!",6)
    TRCell():New(oSection,"G1_XDIMENS"		,"SG1","G1_XDIMENS","@!",40)
    TRCell():New(oSection,"G1_USAALT"		,"SG1","G1_USAALT","@!",40)
    TRCell():New(oSection,"G1_LOCCONS"		,"SGQ","G1_LOCCONS","@!",6)
    TRCell():New(oSection,"G1_FANTASM"		,"SGQ","G1_FANTASM","@!",6)
    TRCell():New(oSection,"G1_LISTA"		,"SGQ","G1_LISTA","@!",6)
    TRCell():New(oSection,"G1_XMAQBOR"		,"SG1","G1_XMAQBOR","@!",6)
	TRCell():New(oSection,"G1_XNBORD"		,"SG1","G1_XNBORD","@!",6)
	TRCell():New(oSection,"G1_XTECINV"		,"SG1","G1_XTECINV","@!",5)
	TRCell():New(oSection,"G1_XDENSID"		,"SG1","G1_XDENSID","@!",5)
	TRCell():New(oSection,"G1_XESPESS"		,"SG1","G1_XESPESS","@!",5)
	                       

	
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

SELECT G1_COD, G1_COMP, G1_TRT, G1_QUANT, G1_PERDA, G1_INI, G1_FIM, G1_OBSERV, G1_FIXVAR, G1_GROPC, G1_OPC, G1_REVINI, G1_REVFIM, G1_NIV, G1_NIVINV, G1_POTENCI, G1_OK, G1_VLCOMPE, G1_USERLGI, G1_USERLGA, G1_VECTOR, 
	G1_TIPVEC, G1_XDIMENS, G1_USAALT, G1_LOCCONS, G1_FANTASM, G1_LISTA,G1_XMAQBOR,G1_XNBORD,G1_XTECINV,G1_XDENSID,G1_XESPESS
FROM %Table:SG1% (NOLOCK) SG1
WHERE SG1.D_E_L_E_T_ = ''
AND G1_COD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
AND G1_COMP BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% 
ORDER BY G1_COD, G1_COMP
		
		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Codigo:",20)+"?","","","mv_ch1","C",15,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Codigo:",20)+"?","","","mv_ch2","C",15,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
