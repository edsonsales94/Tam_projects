#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR71    บAutor  ณWylliam Silva     				บ Data ณ  20/04/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   	Relat๓rio Notas Assistencia                             			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR71()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR71"

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

	oReport := TReport():New(cPerg,"Relat๓rio Notas Assistencia",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Relat๓rio Notas Assistencia",{"SD1"},aOrdem)  

	TRCell():New(oSection,"FILIAL"			,"SD1","FILIAL","@!",2)
	TRCell():New(oSection,"DTEMISSAO"		,"SD1","DT_EMISSAO","@!",10) 
	TRCell():New(oSection,"PRODUTO"			,"SD1","PRODUTO","@!",15)   
	TRCell():New(oSection,"DESCRICAO"		,"SB1","DESCRICAO","@!",30)
	TRCell():New(oSection,"NFDEV"  			,"SD1","NF DEVOL","@!",9)
	TRCell():New(oSection,"DEVSERIE"		,"SD1","SERIE DEVOL","@!",2)         
	TRCell():New(oSection,"QTD"  			,"SD1","QTD","@E 999,999,999,999",)
	TRCell():New(oSection,"PRECOVEND"		,"SD1","PREวO VENDA","@E 999,999,999.999")
	TRCell():New(oSection,"VLRTTL"  		,"SD1","VALOR TOTAL","@E 999,999,999.999")
	TRCell():New(oSection,"NFSAI"  			,"SD2","NF SAI","@!",9)
	TRCell():New(oSection,"SERISAI"  		,"SD2","SERIE SAI","@!",2)
	TRCell():New(oSection,"CLIENTE"  		,"SA1","CLIENTE","@!",30)
	/*TRCell():New(oSection,"DT_INCLUSAO"		,"CLA","DT INCLUSAO","@!",8) 
	TRCell():New(oSection,"PIDESCAMA"		,"SB1","DESC. PI AMAZ","@!",30)
	TRCell():New(oSection,"PIUMAM"			,"SB1","UM PI AMA","@!",8)
	TRCell():New(oSection,"PIQTDAMA"  		,"SG1","QTD PI AMA","@E 999,999,999.999",)
	TRCell():New(oSection,"PITOTALAMA"  	,"SG1","QTD PI TTL AMA","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_ESTAMA01"  	,"SB2","QTD ESTAMA01","@E 999,999,999.999",)*/
	
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

		
		SELECT D1_FILIAL FILIAL,CONVERT(VARCHAR,CAST(D1_EMISSAO AS DATE),103) DTEMISSAO,D1_COD PRODUTO,B1_DESC DESCRICAO,D1_DOC NFDEV,D1_SERIE DEVSERIE,
				D1_QUANT QTD,D1_VUNIT PRECOVEND,D1_TOTAL VLRTTL,D2_DOC NFSAI,D2_SERIE SERISAI,A1_NOME CLIENTE
		FROM SD1100 SD1
		INNER JOIN SB1100 SB1 ON B1_COD = D1_COD AND SB1.D_E_L_E_T_= ''
		LEFT JOIN SD2100 SD2 ON D1_DOC = D2_NFORI AND D1_SERIE = D2_SERIORI AND SD1.D_E_L_E_T_ =''
		INNER JOIN SA1100 SA1 ON A1_COD = D2_CLIENTE AND SA1.D_E_L_E_T_ =''
		WHERE SD1.D_E_L_E_T_ = ''
		AND D1_LOCAL = '30'
		AND D1_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		ORDER BY 2
		
		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Emissao NF:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("At้ Emissao NF:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	