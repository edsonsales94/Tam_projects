
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMLFATR56  บAutor  ณWylliam Silva      				บ Data ณ  15/06/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Ranking de Produtos Saida                                  			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR56()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLFATR56"

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

	oReport := TReport():New(cPerg,"Ranking de Produtos Saida",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Ranking de Produtos Saida",{"SD2"},aOrdem) 

    TRCell():New(oSection,"B1_GRUPO"   	    ,"SC6","Grupo","@!",4)
    TRCell():New(oSection,"EMPRESA"   	    ,"SC6","Empresa","@!",10)
	TRCell():New(oSection,"D2_COD"		    ,"SD2","Codigo","@!",15)
	TRCell():New(oSection,"B1_DESC"		    ,"SB1","Descri็ใo","@!",35)
    TRCell():New(oSection,"QTD"		     ,"SD2","QTD","@E 999,999,999,999",)
	TRCell():New(oSection,"VLR"		      ,"SD2","VLR","@E 999,999,999.99",)
    /*TRCell():New(oSection,"C6_PRODUTO"	      ,"SC6","PRODUTO","@!",20) 
	TRCell():New(oSection,"C6_DESCRI"  	     ,"SC6","C6_DESCRI","@!",40)
	TRCell():New(oSection,"C6_QTDVEN"		 ,"SC6","C6_QTDVEN","@E 999,999,999,999",10)
	TRCell():New(oSection,"C6_LOCAL"         ,"SC6","C6_LOCAL","@!",3)
	TRCell():New(oSection,"C6_CLI" 	         ,"SC6","C6_CLI","@!",7)
	TRCell():New(oSection,"A1_NOME"	    ,"SA1","A1_NOME","@!",20)
	TRCell():New(oSection,"A1_MUN"  			,"SA1","A1_MUN","@!",15)
	TRCell():New(oSection,"CLIENTE"     	,"SC2","CLIENTE","@!",30) */
	
    
	
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

    SELECT B1_GRUPO,EMPRESA,D2_COD,B1_DESC,SUM(D2_QUANT) QTD, SUM(D2_TOTAL) VLR 
FROM(
    SELECT B1_GRUPO,D2_COD,B1_DESC,D2_QUANT,D2_TOTAL,
            CASE WHEN B1_XEMP = '1' THEN 'PROBEL'
                 WHEN B1_XEMP = '2' THEN 'PELMEX'
                 WHEN B1_XEMP = '3' THEN 'SONOFLEX'
                 WHEN B1_XEMP = '4' THEN 'POLISHOP'
                 WHEN B1_XEMP = '5' THEN 'KING STAR'
                 WHEN B1_XEMP = '6' THEN 'INOVAR'
                 WHEN B1_XEMP = '7' THEN 'NAMASPET'
                 WHEN B1_XEMP = '8' THEN 'ORTOCONFORT'
                 ELSE 'SEM FABRICANTE' END EMPRESA
    FROM SD2100 (NOLOCK) SD2
    INNER JOIN SB1100 (NOLOCK) SB1 ON B1_COD = D2_COD AND SB1.D_E_L_E_T_ = ''
    INNER JOIN SC5100 SC5 (NOLOCK) ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.D_E_L_E_T_ = ''
    WHERE SD2.D_E_L_E_T_ =''
    AND D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% // PARAMETRO
    AND B1_GRUPO BETWEEN  %Exp:MV_PAR03% AND %Exp:MV_PAR04% // PARAMETRO
    AND D2_TES NOT IN ('709','915','916','917','723')
    AND D2_LOCAL = '20'
    AND D2_FILIAL = '01'
    AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%INVENT%'
    AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%NAO PRODUZIR%'
    AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%NรO PRODUZIR%'
    AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%REFATURAMENTO%'
    AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%TRANSFERENCIA%'
    AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%TRANSF %'
    AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%DEVOLUCAO%'
    AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE 'DEV %'
    AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE 'REF.%'
    AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE 'REF %'
    AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE 'ESTORNO%' 
) TB
WHERE EMPRESA =  %Exp:MV_PAR05% 
GROUP BY B1_GRUPO,EMPRESA,D2_COD,B1_DESC
ORDER BY B1_GRUPO,QTD DESC



		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("Data Ini:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Data Fim:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Grupo:" ,20)+"?","","","mv_ch3","C",4,0,0,"G","","","SBM","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Grupo:",20)+"?","","","mv_ch4","C",4,0,0,"G","","","","SBM","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Empresa:",20)+"?","","","mv_ch5","C",15,0,0,"G","","","","","mv_par05")
	
	
Return
