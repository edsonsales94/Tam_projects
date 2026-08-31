#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFATR39    ºAutor  ³Stan Lee Lopes     				º Data ³  15/06/21 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  			Pedidos em produção											 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PLFATR39()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR39"

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

	oReport := TReport():New(cPerg,"Pedidos em produção",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()
	oReport:SetEnvironment(2)

	//Primeira seção
	oSection := TRSection():New(oReport,"Pedidos em produção",{"PRO"},aOrdem)
    
   
   
    TRCell():New(oSection,"PED_NUM"         ,"PED","Pedido",/*Mascara*/,20)
    TRCell():New(oSection,"PED_OP"          ,"PED","Ordem Produção",/*Mascara*/,20)
	TRCell():New(oSection,"PED_CLIENTE"	    ,"PED","Cliente",/*Mascara*/,20)
	TRCell():New(oSection,"PED_NOME"        ,"PED","Nome",,80)
	TRCell():New(oSection,"PED_MUN"	        ,"PED","Municipio",/*Mascara*/,10)
	TRCell():New(oSection,"PED_EMISSAO"   	,"PED","Emissao",,15)
	TRCell():New(oSection,"PED_PRODUTO"	    ,"PED","Produto",/*Mascara*/,20)
	TRCell():New(oSection,"PED_DESCRI"      ,"PED","Descrição",,80)
	TRCell():New(oSection,"B1_DCR"      	,"PED","DCRE",,80)
	TRCell():New(oSection,"PED_QUANT"	    ,"PED","Quant",/*Mascara*/,10)
	TRCell():New(oSection,"PED_ENTREG"      ,"PED","Entrega",/*Mascara*/,15)
	TRCell():New(oSection,"PED_QTDENT"      ,"PED","Qtd. Entrega",,10)
	TRCell():New(oSection,"PED_LOCAL"	    ,"PED","Local",/*Mascara*/,10)
	TRCell():New(oSection,"B1_XLARGUR"   	,"PED","Largura","@E 9,999,999,999.999999",)
	TRCell():New(oSection,"B1_XCOMPRI"   	,"PED","Comprimento","@E 9,999,999,999.999999",)
	TRCell():New(oSection,"B1_XALTURA"   	,"PED","Altura","@E 9,999,999,999.999999",)
	TRCell():New(oSection,"CUBAGEM"   	    ,"PED","Cubagem","@E 9,999,999,999.999999",)
	TRCell():New(oSection,"PED_DTPROPEL"    ,"PED","Data Produção",/*Mascara*/,20)
	TRCell():New(oSection,"PED_SETOR"	    ,"PED","Setor",/*Mascara*/,20)
	TRCell():New(oSection,"OBSERVACAO"      ,"PED","Observação",,80)
	
	
	/*TRFunction():New(oSection:Cell("OPNAOPRODUZIDA"),"Total nao produzido","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("EMESTOQUE"),"Total em estoque","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("PRODUZIDO"),"Total produzido"•,"SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("SALDOPREVISTO"),"Total previsto"•,"SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("FATURADO"),"Total faturado"•,"SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("SALDOATUAL"),"Saldo em disponivel"•,"SUM",,,"@E 9,999,999,999",,.F.,.T.)
	//Totalizador
*/
	//
	//TRFunction():New(oSection:Cell("DA1_DESC"),"TOTAL DIFERENÇA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
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
	//	cOrdem := "A1_COD"                       ·
	//endif


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%
		
SELECT PED_NUM,PED_OP,PED_CLIENTE,PED_NOME,PED_ITEM,PED_PRODUTO,PED_DESCRI,
       CAST(C6_QTDVEN - C6_QTDENT AS INT)PED_QUANT,
	   B1_XLARGUR,B1_XCOMPRI,B1_XALTURA,
	   (CAST(C6_QTDVEN - C6_QTDENT AS INT)*(B1_XLARGUR*B1_XCOMPRI*B1_XALTURA)) CUBAGEM,
       CONVERT(VARCHAR,CAST(PED_EMISSAO AS DATE),103)PED_EMISSAO,
	   CONVERT(VARCHAR,CAST(PED_ENTREG AS DATE),103)PED_ENTREG,
	   PED_DTPROPEL,PED_MUN,PED_SETOR,
	   RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) OBSERVACAO,B1_DCR
FROM PED
INNER JOIN SC6100 SC6 (NOLOCK) ON PED_FILIAL = C6_FILIAL AND PED_NUM = C6_NUM AND PED_ITEM = C6_ITEM AND PED_PRODUTO = C6_PRODUTO AND SC6.D_E_L_E_T_ = ''
INNER JOIN SC5100 SC5 ON PED_FILIAL = C5_FILIAL AND PED_NUM = C5_NUM AND SC5.D_E_L_E_T_ = ''
LEFT JOIN SD2100 SD2 ON PED_FILIAL = D2_FILIAL AND PED_NUM = D2_PEDIDO AND SD2.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB1 ON PED_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
WHERE C6_QTDVEN > C6_QTDENT
AND PED_STATUS = ''
AND PED_NUM BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND (CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
OR PED_DTPROPEL = '')
GROUP BY PED_NUM,PED_OP,PED_CLIENTE,PED_NOME,PED_ITEM,PED_PRODUTO,PED_DESCRI,C6_QTDVEN,C6_QTDENT,PED_EMISSAO,PED_ENTREG,PED_DTPROPEL,PED_MUN,
         B1_XLARGUR,B1_XCOMPRI,B1_XALTURA,
         C5_MENNOTA,C5_XMSGNOT,C5_OBS1,C5_OBS2,C5_OBS3,PED_SETOR,B1_DCR
ORDER BY PED_MUN,PED_ENTREG,PED_NUM,PED_ITEM


	EndSQL

	oSection:EndQuery()
	oSection:SetParentQuery()
	oSection:Print()
Return

Static Function AjustaSX1(cPerg)

    u_InPutSX1(cPerg,"01",PADR("Pedido de  ?     ",20)+"","","","mv_ch1","C",6,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Pedido Até ?     ",20)+"","","","mv_ch2","C",6,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Dt.Entrega de  ?     ",20)+"","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Dt.Entrega Até ?     ",20)+"","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04")

Return
