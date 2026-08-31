#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR45   บAutor  ณJuevan Silva     				บ Data ณ  02/05/24 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Rel. Produzidos e Faturados                      			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR45()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR45"

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

	oReport := TReport():New(cPerg,"Rel. Produzidos e Faturados",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Produzidos e Faturados",{"PED"},aOrdem) 

    TRCell():New(oSection,"DT_PRODUCAO"   	        ,"PED","DT_PRODUCAO","@!",10)
    TRCell():New(oSection,"DT_PREVIA"	           ,"PED","DT_PREVIA","@!",10)
    TRCell():New(oSection,"DT_PEDIDO"	        ,"PED","DT_PEDIDO","@!",10)
    TRCell():New(oSection,"DT_NOTA"	        ,"SC6","DT_NOTA","@!",10)
    TRCell():New(oSection,"DT_SAIDA"	        ,"PED","TOTAL_EXPEDIDO","@!",10)
    TRCell():New(oSection,"PEDIDO"	        ,"PED","PEDIDO","@!",7)
	TRCell():New(oSection,"CARGA"		    ,"PED","CARGA","@!",9)
    TRCell():New(oSection,"OP"		    ,"PED","OP","@!",7)
    TRCell():New(oSection,"ITEM"		    ,"PED","ITEM","@!",2)
    TRCell():New(oSection,"PRODUTO"		    ,"PED","PRODUTO","@!",15)
    TRCell():New(oSection,"DESCRICAO"		    ,"PED","DESC","@!",30)
    TRCell():New(oSection,"QTD_PEDIDO"		    ,"PED","QTD_PEDIDO","@E 999,999,999,999",)
    TRCell():New(oSection,"QTD_ENTRADA"		    ,"PED","QTD_ENTRADA","@E 999,999,999,999",)
    TRCell():New(oSection,"DIFERENCA"		    ,"PED","DIFERENCA","@E 999,999,999,999",)
	TRCell():New(oSection,"CLIENTE" 	         ,"SA1","CLIENTE","@!",7)
	TRCell():New(oSection,"CIDADE"	    ,"SA1","CIDADE","@!",20)
	TRCell():New(oSection,"OBSERVACAO"     	,"SC2","OBSERVACAO","@!",30) 
    //TRCell():New(oSection,"C6_NUM"		     ,"SC6","C6_NUM","@!",7)

	
    
	
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


SELECT PED_DTPROPEL DT_PRODUCAO,PED_DTPREVIA DT_PREVIA,
       CONVERT(VARCHAR,CAST(C5_EMISSAO AS DATE),103)DT_PEDIDO,
     CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103)DT_NOTA,D2_DOC NOTA,ISNULL(CNF_EXPEDICAO,'') DT_SAIDA,PED_NUM PEDIDO,C2_XCARGA CARGA,PED_OP OP,PED_ITEM ITEM,
     PED_PRODUTO PRODUTO,PED_DESCRI DESCRICAO,
       CAST(PED_QUANT AS FLOAT)QTD_PEDIDO,
     CAST(ISNULL(QTD_ENTRADA,0) AS FLOAT)QTD_ENTRADA,
       CAST(PED_QUANT AS FLOAT)-CAST(ISNULL(QTD_ENTRADA,0) AS FLOAT)DIFERENCA,PED_NOME CLIENTE,PED_MUN CIDADE,
     RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT)OBSERVACAO
FROM PED (NOLOCK)
INNER JOIN SC5100 SC5 (NOLOCK) ON PED_FILIAL = C5_FILIAL AND PED_NUM = C5_NUM AND SC5.D_E_L_E_T_ = ''
LEFT JOIN SD2100 SD2 (NOLOCK) ON PED_FILIAL = D2_FILIAL AND PED_NUM = D2_PEDIDO AND PED_ITEM = D2_ITEMPV AND PED_PRODUTO = D2_COD AND SD2.D_E_L_E_T_ = ''
LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
LEFT JOIN CNF (NOLOCK) ON D2_FILIAL = CNF_FILIAL AND D2_DOC = CNF_DOC AND D2_SERIE = CNF_SERIE AND D2_CLIENTE = CNF_CLIENTE AND D2_LOJA = CNF_LOJA 
LEFT JOIN (SELECT C2_XCARGA,C2_EMISSAO,C2_NUM,C2_PRODUTO,SUM(C2_QUANT)C2_QUANT,SUM(C2_QUJE)C2_QUJE
            FROM(
            SELECT *
            FROM SC2100 SC2 (NOLOCK) 
      WHERE SC2.D_E_L_E_T_ = ''
      )TB 
      GROUP BY C2_XCARGA,C2_EMISSAO,C2_NUM,C2_PRODUTO)SC2 ON PED_OP = SC2.C2_NUM AND PED_PRODUTO = SC2.C2_PRODUTO
LEFT JOIN (SELECT SUBSTRING(Z1_OP,1,6)Z1_OP,Z1_PRODUTO,SUM(Z1_QUANT)QTD_ENTRADA
           FROM(
       SELECT Z1_OP+Z1_CHASSIS Z1_OP,C2_PRODUTO Z1_PRODUTO,CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END Z1_QUANT
           FROM SZ1100 SZ1 (NOLOCK)
       INNER JOIN SC2100 SC2 (NOLOCK) ON Z1_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2.D_E_L_E_T_ = ''
       INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
       WHERE SZ1.D_E_L_E_T_ = ''
       )TB
       GROUP BY SUBSTRING(Z1_OP,1,6),Z1_PRODUTO)SZ1 ON PED_OP = Z1_OP AND PED_PRODUTO = Z1_PRODUTO
WHERE PED_STATUS != 'C'
//AND D1_DOC IS NULL
AND D2_DOC IS NOT NULL
AND CNF_DOC IS NULL
AND CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%NAO PRODUZIR%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%NรO PRODUZIR%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE 'DEVOLUCAO%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE 'DEV%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REF%DEV%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%INVENT%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSFERENCIA%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSF%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REFATURAMENTO%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TESTE%' 
ORDER BY CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112),PED_NOME,
         PED_NUM,PED_ITEM




		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
