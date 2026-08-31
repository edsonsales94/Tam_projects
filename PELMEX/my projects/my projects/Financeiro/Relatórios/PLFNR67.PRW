#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFINR67    ºAutor  ³Juevan Silva     				º Data ³ 06/12/2023º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Total Financeiro em Carteira                		     			 	 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLFINR67()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR67"

	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)  
	oReport := ReportDef(cAlias,cPerg)
	oReport:PrintDialog()
Return


Static Function ReportDef(cAlias,cPerg)
	Local oReport
	Local oSection
	Local oFunction1
    Local oBreak
	Local aOrdem  := {"FILIAL"}
   

	oReport := TReport():New(cPerg,"Total Financeiro em Carteira",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Total Financeiro em Carteira",{"CTT"},aOrdem)

	TRCell():New(oSection,"TOTAL"	         ,"SC6","TOTAL","@E 9,999,999,999.99",)
    //TRCell():New(oSection,"CCT_DTPAG"	        ,"CTT","DATA","@!",10)
	//TRCell():New(oSection,"CCT_BANCO"	        ,"CTT","BANCO","@!",5)
    //TRCell():New(oSection,"CCT_AGENCIA"	    ,"CTT","AGENCIA","@!",20)
    //TRCell():New(oSection,"CCT_CONTA"	     ,"CTT","CONTA","@!",10)
    //TRCell():New(oSection,"CCT_STATUS"	     ,"CTT","STATUS","@!",3)
    
    
    /*TRCell():New(oSection,"E1_VALOR"	     ,"SE1","Valor","@E 9,999,999,999.99",)	   
	TRCell():New(oSection,"E1_EMISSAO"	   ,"SE1","Emissao","@!",10) 
    TRCell():New(oSection,"E1_VENCREA"	     ,"SE1","DtVenc.","@!",10) 
	TRCell():New(oSection,"E1_BAIXA"	   	    ,"SE1","DtBaixa","@!",10)
    TRCell():New(oSection,"E1_CLIENTE"	   	  ,"SE1","Cliente","@!",6)
    TRCell():New(oSection,"A1_NOME"	   	      ,"SA1","Nome.Cliente","@!",30)
	TRCell():New(oSection,"A1_NREDUZ"       ,"SA1","Nome Reduz","@!",15)
	TRCell():New(oSection,"A1_MUN"	    	,"SA1","Munic","@!",15)*/
    
    

	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	

    //TRFunction():New(oSection:Cell("TOTAL"),"Total Geral","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("DIFERENCA"),"Diferenca","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

	oReport:SetTotalInLine(.F.)

	//Quebra por Seção
	oSection:SetPageBreak(.T.)
	oSection:SetTotalText(" ")

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)
	//Local oSection2  := oReport:Section(2)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ·
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
	%noparser%   

SELECT SUM(C6_VALOR)TOTAL
FROM(
SELECT 0 CHK,C6_FILIAL,C6_NOTA D2_DOC,C6_SERIE D2_SERIE,C6_NUM,C6_CLI,C6_LOJA,A1_NOME,A1_EST,A1_MUN,
       C5_EMISSAO,C6_ENTREG,C6_ITEM,'' D2_ITEM,RTRIM(C6_PRODUTO)C6_PRODUTO,B1_DESC,B1_UM,C6_LOCAL,
       B1_CC,C6_QTDVEN,C6_QTDENT,0.0 D2_QUANT,C6_PRCVEN,C6_VALOR,0.0 D2_TOTAL,C6_NOTA,C6_SERIE,B1_XMODELO,B1_XSETOR,
       (B1_XLARGUR*B1_XALTURA*B1_XCOMPRI)*C6_QTDVEN TOTALM3 
FROM SC6100 SC6 
INNER JOIN SC5100 SC5 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND SC5.D_E_L_E_T_ = '' 
INNER JOIN SB1100 SB1 ON C6_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' 
INNER JOIN SA1100 SA1 ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' 
LEFT JOIN PED ON C6_FILIAL = PED_FILIAL AND C6_NUM = PED_NUM AND C6_ITEM = PED_ITEM AND C6_PRODUTO = PED_PRODUTO 
WHERE SC6.D_E_L_E_T_ = '' 
AND C6_FILIAL = '01' 
AND A1_COD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND A1_NOME NOT LIKE 'PELMEX%' 
AND A1_NOME NOT LIKE 'ITALO DE OLIVEIRA%' 
AND A1_NOME NOT LIKE 'PRO FLORES%' 
AND A1_NOME NOT LIKE 'ANDRE LUIZ BASTOS ARRUDA - ME%' 
AND C6_NUM NOT LIKE 'L%' 
AND C6_LOCAL NOT IN ('30')
AND C6_TES NOT IN ('026','130','521','561','723','731','852','887','891','910','918')
AND PED_OP IS NULL 
AND C6_LOCAL  IN ('20','30') 
AND C6_TES NOT IN ('709','915','916','917') 
AND C6_QTDVEN > C6_QTDENT
AND C5_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND C6_ENTREG BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
AND C6_NUM BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
AND C6_CLI BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%
AND C6_LOJA BETWEEN %Exp:MV_PAR11% AND %Exp:MV_PAR12%
AND A1_EST BETWEEN %Exp:MV_PAR13% AND %Exp:MV_PAR14%
AND A1_MUN BETWEEN %Exp:MV_PAR15% AND %Exp:MV_PAR16%
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%NAO PRODUZIR%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%NÃO PRODUZIR%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE 'DEVOLUCAO%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE 'DEV%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REF%DEV%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%INVENT%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSF%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSFERENCIA%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REFATURAMENTO%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TESTE%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%SUBST%' 
)TB

                                           		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De Vendedor "    ,20)+"?","","","mv_ch01","C",10,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Ate Vendedor "    ,20)+"?","","","mv_ch2","C",10,0,0,"G","","","","","mv_par02")
u_InPutSX1(cPerg,"03",PADR("De Emissao"  ,20)+"?","","","mv_ch3","D",15,0,0,"G","","","","","mv_par03") 
u_InPutSX1(cPerg,"04",PADR("Ate Emissao"  ,20)+"?","","","mv_ch4","D",15,0,0,"G","","","","","mv_par04")
u_InPutSX1(cPerg,"05",PADR("De Entrega"   ,20)+"?","","","mv_ch5","D",15,5,0,"G","","","","","mv_par05") 
u_InPutSX1(cPerg,"06",PADR("Ate Entrega"  ,20)+"?","","","mv_ch6","D",15,5,0,"G","","","","","mv_par06")
u_InPutSX1(cPerg,"07",PADR("De Pedido"  ,20)+"?","","","mv_ch7","C",10,5,0,"G","","","","","mv_par07") 
u_InPutSX1(cPerg,"08",PADR("Ate Pedido" ,20)+"?","","","mv_ch8","C",10,5,0,"G","","","","","mv_par08")
u_InPutSX1(cPerg,"09",PADR("De Cliente"  ,20)+"?","","","mv_ch9","C",10,5,0,"G","","","","","mv_par09") 
u_InPutSX1(cPerg,"10",PADR("Ate Cliente" ,20)+"?","","","mv_ch10","C",10,5,0,"G","","","","","mv_par10")
u_InPutSX1(cPerg,"11",PADR("De Loja" ,20)+"?","","","mv_ch11","C",10,5,0,"G","","","","","mv_par11") 
u_InPutSX1(cPerg,"12",PADR("Ate Loja" ,20)+"?","","","mv_ch12","C",10,5,0,"G","","","","","mv_par12")
u_InPutSX1(cPerg,"13",PADR("De Estado" ,20)+"?","","","mv_ch13","C",10,5,0,"G","","","","","mv_par13") 
u_InPutSX1(cPerg,"14",PADR("Ate Estado" ,20)+"?","","","mv_ch14","C",10,5,0,"G","","","","","mv_par14")
u_InPutSX1(cPerg,"15",PADR("De Municipio"   ,20)+"?","","","mv_ch15","C",10,5,0,"G","","","","","mv_par15") 
u_InPutSX1(cPerg,"16",PADR("Ate Municipio"   ,20)+"?","","","mv_ch16","C",10,5,0,"G","","","","","mv_par16")

Return
