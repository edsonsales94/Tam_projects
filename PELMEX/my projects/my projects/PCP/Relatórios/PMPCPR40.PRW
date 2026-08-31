#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR40    ºAutor  ³Sherlania         				º Data ³  22/09/21 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  RELATÓRIO DE CONFERÊNCIA PCP        	        								 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR40()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR40"

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

	oReport := TReport():New(cPerg,"RELATÓRIO DE CONFERÊNCIA PCP",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Conferência",{"SC6"},aOrdem) 

	TRCell():New(oSection,"PED_CODIGO"		  ,"PK2","N CONTROLE","@",/*Tamanho*/)     
	TRCell():New(oSection,"PK2_FILIAL"        ,"PK2","N FILIAL",/*"@E 999,999.99"*/,)  
	TRCell():New(oSection,"PK2_OP"     		  ,"PK2","N OP",/*"@E 999,999.99"*/,)  
	TRCell():New(oSection,"PK2_PRODUTO"		  ,"PK2","CODIGO",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"PK2_DESCRI"		  ,"PK2","PRODUTO",/*"@E 999,999.99"*/,/*Tamanho*/)
	TRCell():New(oSection,"PK2_DTPROPEL"	  ,"PK2","DT PROD PELMEX",/*"@E 999,999.99"*/,/*Tamanho*/) 
	TRCell():New(oSection,"PK2_DTPROAMA"      ,"PK2","DT PROD AMAZON",/*"@E 999,999.99"*/,)   
	TRCell():New(oSection,"PK2_QUANT"		  ,"PK2","QTDE",/*"@E 999,999.99"*/,) 
	TRCell():New(oSection,"PK2_OBS"           ,"PK2","CLIENTE",/*"@E 999,999.99"*/,) 
	TRCell():New(oSection,"B1_XSETOR"         ,"B1","SETOR",/*"@E 999,999.99"*/,) 
	TRCell():New(oSection,"PK2_DATINC"        ,"PK2","DT INCLUSAO",/*"@E 999,999.99"*/,) 
	TRCell():New(oSection,"PED_NUM"	     	  ,"PED","PEDIDO",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"PED_NOTA"		  ,"PED","NOTA",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"PED_EMISSAO"		  ,"PED","DT PEDIDO",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"PED_DTPREVIA"		  ,"PED","DT PREVIA",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"PED_ENTREG"		  ,"PED","DT ENTREGA",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"PED_UF"		      ,"PED","ESTADO",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"PED_MUN"		      ,"PED","MUNICIPIO",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"A1_BAIRRO"	      ,"SZ9","BAIRRO","@",/*Tamanho*/)   
	TRCell():New(oSection,"Z9_ZONA"		      ,"SZ9","ZONA","@",/*Tamanho*/)   
	TRCell():New(oSection,"Z9_REGIAO"		  ,"SZ9","REGIAO","@",/*Tamanho*/)   
	TRCell():New(oSection,"OBSERVACAO"	      ,"SC5","OBSERVAÇÃO",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"CUBAGEM"	          ,"SC6","CUBAGEM",/*"@E 999,999.99"*/,)
	TRCell():New(oSection,"PED_TOTAL"	   	  ,"PED","VALOR TOTAL",/*"@E 999,999,99"*/,)
	

	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("C6_VALOR"),"TOTAL FATURADO","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("CUBAGEM"),"TOTAL CUBAGEM","SUM",,,"@E 999,999,999.999999",,.F.,.T.)  
	//TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)


Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%

SELECT PED_CODIGO,PED_FILIAL PK2_FILIAL,'' PK2_OP,PED_PRODUTO PK2_PRODUTO,PED_DESCRI PK2_DESCRI,A1_BAIRRO, Z9_ZONA, Z9_REGIAO,
       CONVERT(VARCHAR,GETDATE()+2,103) PK2_DTPROPEL,
       CONVERT(VARCHAR,GETDATE(),103) PK2_DTPROAMA,
	   CAST(SUM(PED_QUANT) AS INT)PK2_QUANT,
	   PED_NOME PK2_OBS,B1_XSETOR,
	   CONVERT(VARCHAR,GETDATE(),103) PK2_DATINC,
	   PED_NUM,PED_NOTA,CONVERT(VARCHAR,CAST(PED_EMISSAO AS DATE),103)PED_EMISSAO,CONVERT(VARCHAR,CAST(PED_EMISSAO AS DATE),103)PED_DTPREVIA,CONVERT(VARCHAR,CAST(PED_ENTREG AS DATE),103)PED_ENTREG,PED_UF,PED_MUN,
	   RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) OBSERVACAO,
	   CASE WHEN (C6_QTDVEN-C6_QTDENT)> 0 THEN ((B1_XALTURA*B1_XCOMPRI*B1_XLARGUR)* (C6_QTDVEN-C6_QTDENT)) ELSE ((B1_XALTURA*B1_XCOMPRI*B1_XLARGUR)* C6_QTDVEN) END CUBAGEM,
	   PED_TOTAL
	FROM PED (NOLOCK)
	INNER JOIN SB1100 SB1  (NOLOCK) ON PED_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
	LEFT JOIN PK2  (NOLOCK) ON PED_CODIGO = PK2_CODIGO AND PED_PRODUTO = PK2_PRODUTO
	LEFT JOIN SC5100 SC5(NOLOCK) ON C5_NUM = PED_NUM AND SC5.D_E_L_E_T_ = ''
	LEFT JOIN SC6100 SC6(NOLOCK) ON C6_NUM = PED_NUM AND C6_PRODUTO = PED_PRODUTO AND SC6.D_E_L_E_T_ = ''
	INNER JOIN SA1100 SA1(NOLOCK) ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND A1_MSBLQL != '1' AND SA1.D_E_L_E_T_ = '' 
	LEFT JOIN SZ9100 SZ9(NOLOCK) ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND A1_BAIRRO = Z9_BAIRRO AND SZ9.D_E_L_E_T_ = ''
	WHERE PED_FILIAL = '01'
	AND PED_QUANT > 0
	AND PED_OP = ''
	AND PED_STATUS = ''
	
	//AND CONVERT(VARCHAR,CAST(PED_DATINC AS DATE),112) >= '20210901'
	GROUP BY PED_CODIGO,PED_FILIAL,PED_PRODUTO,PED_DESCRI,B1_XSETOR,PED_NOME,PED_NUM,PED_NOTA,PED_EMISSAO, PED_DTPREVIA,PED_ENTREG,PED_UF,PED_MUN,
	         RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3),B1_XALTURA,B1_XCOMPRI,B1_XLARGUR,C6_QTDVEN,C6_QTDENT,PED_TOTAL,A1_BAIRRO,Z9_ZONA,Z9_REGIAO
	ORDER BY B1_XSETOR,PED_DESCRI,PED_MUN	
		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	//u_InPutSX1(cPerg,"01",PADR("Dt.Prod Pelmex    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	//u_InPutSX1(cPerg,"02",PADR("Dt.Prod Amazon   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
	//u_InPutSX1(cPerg,"03",PADR("Dt.Inclusão    ",20)+"?","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03") 
Return
