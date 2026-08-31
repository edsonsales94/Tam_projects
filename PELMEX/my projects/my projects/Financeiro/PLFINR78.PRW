#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFINR78    ºAutor  ³Juevan Silva   				º Data ³ 04/08/2025º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rel. Contas a Pagar por Grupo                  		     			 	 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLFINR78()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR78"

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
   

	oReport := TReport():New(cPerg,"Rel. Contas a Pagar por Grupo",cPerg,{|oReport| PrintReport(oReport,cAlias)})


	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Rel. Contas a Pagar por Grupo",{"SE2"},aOrdem)
	
    
TRCell():New(oSection,"Periodo"	        ,"SE2","Periodo","@!",10)
TRCell():New(oSection,"Empresa"	        ,"SE2","Empresa","@!",10)
TRCell():New(oSection,"Filial_Origem"	    ,"SE2","Filial_Origem","@!",2)
TRCell():New(oSection,"Natureza"	    ,"SE2","Natureza","@!",8)
TRCell():New(oSection,"Descricao"	    ,"SE2","Descricao","@!",20)
TRCell():New(oSection,"Data_Emissao"	        ,"SE2","Data_Emissao","@!",10)
TRCell():New(oSection,"Banco"	     ,"SE5","Banco","@!",3)
TRCell():New(oSection,"Agencia"	    ,"SE5","Agencia","@!",3)  
TRCell():New(oSection,"Conta"	    ,"SE5","Conta","@!",3)
TRCell():New(oSection,"Tipo_Documento"	    ,"SE2","Tipo_Documento","@!",3) 
TRCell():New(oSection,"Motivo_Baixa"	    ,"SE5","Motivo_Baixa","@!",3)
TRCell():New(oSection,"Titulo"	     ,"SE5","Titulo","@!",10)
TRCell():New(oSection,"Prefixo"	    ,"SE5","Prefixo","@!",3)
TRCell():New(oSection,"Tipo"	    ,"SE5","Tipo","@!",2)
TRCell():New(oSection,"Parcela"	    ,"SE2","Parcela","@!",3)
TRCell():New(oSection,"Valor"	   	 ,"SE2","Valor","@E 9,999,999,999.99")
TRCell():New(oSection,"Saldo"	   	 ,"SE2","Saldo","@E 9,999,999,999.99")
TRCell():New(oSection,"Valor_Liquido"	   	 ,"SE2","Valor_Liquido","@E 9,999,999,999.99")
TRCell():New(oSection,"Acrescimo"	   	 ,"SE2","Acrescimo","@E 9,999,999,999.99")
TRCell():New(oSection,"Decrecimo"	   	 ,"SE2","Decrecimo","@E 9,999,999,999.99")
TRCell():New(oSection,"Valor_Corrigido"	   	 ,"SE2","Valor_Corrigido","@E 9,999,999,999.99")
TRCell():New(oSection,"Valor_Baixa"	   	 ,"SE2","Valor_Baixa","@E 9,999,999,999.99")
TRCell():New(oSection,"Data_Vencimento","SE2","Data_Vencimento","@!",10)
TRCell():New(oSection,"Status"	   	,"SE2","Status","@!",9)
TRCell():New(oSection,"Data_Baixa"	    ,"SE2","Data_Baixa","@!",10)
TRCell():New(oSection,"Fornecedor"	   	,"SE2","Fornecedor","@!",6)
TRCell():New(oSection,"Historico"	    ,"SE2","Historico","@!",30)
TRCell():New(oSection,"Historico_Baixa"	    ,"SE2","Historico_Baixa","@!",10)
TRCell():New(oSection,"Grupo"	    ,"SE2","Grupo","@!",20)
    

//SELECT 'PELMEX' Empresa,E2_NUM,E2_PREFIXO,E2_PARCELA,E2_TIPO,E2_VALOR,E2_VALLIQ,E2_SALDO,
    //CONVERT(VARCHAR,CAST(E2_EMISSAO AS DATE),103)DT_EMISSAO,
    //CONVERT(VARCHAR,CAST(E2_VENCTO AS DATE),103)DT_VENCTO,
    //CASE WHEN E2_BAIXA = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E2_BAIXA AS DATE),103) END DT_BAIXA,
    //E2_FORNECE,E2_LOJA,E2_NOMFOR,
	//E2_NATUREZ,ED_DESCRIC,E2_HIST	

	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	

    //TRFunction():New(oSection:Cell("E2_VALOR"),"Total valor","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
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



SELECT SUBSTRING(Data_Emissao,4,7)Periodo,TB1.*,
       CASE WHEN Historico LIKE '%ICMS%' THEN 'IMPOSTO'
            WHEN Historico LIKE '%COMISSAO REPRESENTANTE/PROMOTO%'  THEN 'COMISSÃO'
			WHEN Historico LIKE '%ENCARGOS,FPP E TAXA CONDOMINIO%'  THEN 'ALUGUEL'
			WHEN Historico LIKE '%DESPESA%TRANS%'  THEN 'DESPESA COM TRANSPORTE'
			WHEN Historico LIKE '%FRETE%VEBDA%'  THEN 'FRETE SOBRE VENDA'
			WHEN Historico LIKE '%IRF%'  THEN 'IMPOSTO'
			WHEN Historico LIKE '%ISS%'  THEN 'IMPOSTO'
			WHEN Historico LIKE '%IRF%'  THEN 'IMPOSTO'
			WHEN Historico LIKE '%INSS%'  THEN 'IMPOSTO'
			WHEN Historico LIKE '%FGTS%' THEN 'IMPOSTO'
			WHEN Historico LIKE '%IPTU%'  THEN 'IMPOSTO'
			WHEN Historico LIKE '%CSLL%'  THEN 'IMPOSTO'
			WHEN Historico LIKE '%PIS%'  THEN 'IMPOSTO'
			WHEN Historico LIKE '%IRPJ%'  THEN 'IMPOSTO'
			WHEN Historico LIKE '%COFINS%'  THEN 'IMPOSTO'
			WHEN Historico LIKE '%GNRE%'  THEN 'IMPOSTO'
			WHEN Historico LIKE '%ALPHA MOTION-INDUSTRIA NF%'  THEN 'IMPOSTO'
			WHEN Historico LIKE '%SUFRAMA%'  THEN 'IMPOSTO'
			WHEN Historico LIKE '%IMPOSTO%'  THEN 'IMPOSTO'
			WHEN Historico LIKE '%CONTRIB%' THEN 'IMPOSTO'
			WHEN Natureza LIKE '%ICMS%' THEN 'IMPOSTO'
			WHEN Historico LIKE '%TAXA%'  THEN 'IMPOSTO'
			WHEN Fornecedor LIKE 'LOPES%'  THEN 'ASSESSORIA'
			WHEN Historico LIKE '%SERVICOS AVULSO T.I (STAN)%'  THEN 'ASSESSORIA'
			WHEN Historico LIKE '%DOMINIO DE EMAIL PELMEX%'  THEN 'ASSESSORIA'
			WHEN Historico LIKE '%SERVICOS CONSULTORIA SISTEMA%'  THEN 'ASSESSORIA'
			WHEN Historico LIKE '%MATERIA%PRIMA%'  THEN 'MATERIA PRIMA'
			WHEN Historico LIKE '%FRETE%'  THEN 'FRETE'
			WHEN Historico LIKE '%DESPESAS C/ DESCARGAS%'  THEN 'FRETE'
			WHEN Historico LIKE '%DESPESAS DIRETORIA%'  THEN 'DESPESAS DIRETORIA'
			WHEN Historico LIKE '%DESP%JURI%'  THEN 'DESPESAS JURIDICAS'
			WHEN Historico LIKE '%EXAMES%'  THEN 'EXAMES'
			WHEN Historico LIKE '%SEGURO%'  THEN 'SEGURO'
			WHEN Historico LIKE '%EMPRESTIMO%'  THEN 'EMPRESTIMOS'
			WHEN Historico LIKE '%ENERGIA%'  THEN 'ENERGIA'
			WHEN Historico LIKE '%ALUGUE%'  THEN 'ALUGUEL'
			WHEN Historico LIKE '%ALVARA%'  THEN 'ALVARA'
			WHEN Historico LIKE '%TRANSPORTE%'  THEN 'TRANSPORTE'
			WHEN Historico LIKE '%SERVICO%'  THEN 'SERVIÇOS'
			WHEN Historico LIKE '%PUBLICIDADE%'  THEN 'PUBLICIDADE'
			WHEN Historico LIKE '%FINANCIAMENTO%'  THEN 'FINANCIAMENTO'
			WHEN Historico LIKE '%FINAN%'  THEN 'FINANCIAMENTO'
			WHEN Descricao LIKE '%FORNECEDORES%' AND Historico LIKE '%REFEICOES%' THEN 'DESPESA COM PESSOAL'
			WHEN Descricao LIKE '%FORNECEDORES%' AND Historico LIKE '%DROGARIA%' THEN 'DESPESA COM PESSOAL'
			WHEN Descricao LIKE '%FORNECEDORES%' AND Historico LIKE '%ALIMENTACAO%' THEN 'DESPESA COM PESSOAL'
			WHEN Descricao LIKE '%FORNECEDORES%' AND Historico LIKE '%CONVENIO%' THEN 'DESPESA COM PESSOAL'
			WHEN Descricao LIKE '%FORNECEDORES%' AND Historico LIKE '%OTICA%' THEN 'DESPESA COM PESSOAL'
			WHEN Descricao LIKE '%FORNECEDORES%' AND Historico LIKE '%MATERIA PRIMA%' THEN 'MATERIA PRIMA'
			WHEN Descricao LIKE '%FORNECEDORES%' AND Historico LIKE '%MAT%PRIMA%' THEN 'MATERIA PRIMA'
			WHEN Descricao LIKE '%FORNECEDORES%' AND Historico LIKE '%FRETE%' THEN 'FRETE'
			WHEN Historico LIKE '%FORNECEDORES%'  THEN 'FORNECEDORES'
			
			WHEN Historico LIKE '%AGUA%'  THEN 'AGUA/ESGOTO'
			WHEN Historico LIKE '%MANUTENCAO%'  THEN 'MANUTENÇÃO'
			WHEN Historico LIKE '%ALIMENTACAO%'  THEN 'ALIMENTAÇÃO'
			WHEN Fornecedor LIKE 'V V REFEICOES%'  THEN 'ALIMENTAÇÃO'
			WHEN Historico LIKE '%DESEMBARACO%'  THEN 'DESEMBARAÇO'
			WHEN Historico LIKE '%CREDITO%'  THEN 'CREDITO'
			WHEN Historico LIKE '%ADIANTAMENTO%SALARIO%'  THEN 'DESPESA COM PESSOAL'
			WHEN Historico LIKE '%RESCISAO%'  THEN 'DESPESA COM PESSOAL'
			WHEN Historico LIKE '%FERIAS%'  THEN 'DESPESA COM PESSOAL'
			
			WHEN Descricao LIKE '%SALARIO%' AND Historico NOT LIKE '%ADIANTAMENTO%'  THEN 'DESPESA COM PESSOAL'
			WHEN Descricao LIKE '%HORAS%EXTRA%' THEN 'DESPESA COM PESSOAL'
			WHEN Descricao LIKE '%PROCESSO%' THEN 'DESPESA JUDICIAL'
			WHEN Descricao LIKE '%INTERNET%' THEN 'TECNOLOGIA'
			WHEN Descricao LIKE '%INFORMA%' THEN 'TECNOLOGIA'
			WHEN Descricao LIKE '%REEMBOLSO%' THEN 'REEMBOLSO'
			WHEN Descricao LIKE '%MAQ%EQUI%' THEN 'MAQUINAS'
			WHEN Descricao LIKE '%COMBUSTIVEL%' THEN 'FRETE'
			WHEN Descricao LIKE '%MAT%CONSUMO%' THEN 'MATERIAL USO E CONSUMO'
			WHEN Descricao LIKE '%MEDICAMENTO%' THEN 'MEDICAMENTO'
			WHEN Descricao LIKE '%LOCACAO%' THEN 'LOCAÇÃO'
			WHEN Descricao LIKE '%SERV%PRESTA%' THEN 'ASSESSORIA'
			WHEN Descricao LIKE '%EVENTO%' THEN 'PUBLICIDADE'
			WHEN Descricao LIKE '%DESCONTO%' THEN 'DESCONTOS'
		ELSE Descricao END Grupo
    
FROM(
SELECT Empresa,E2_FILORIG Filial_Origem,E2_NATUREZ Natureza,ISNULL(ED_DESCRIC,'') Descricao,DT_EMISSAO Data_Emissao,
       CASE WHEN E5_DATA IS NULL THEN '' ELSE CONVERT(VARCHAR,CAST(E5_DATA AS DATE),103) END Data_Movimentacao,
       ISNULL(E5_BANCO,'') Banco,ISNULL(E5_AGENCIA,'') Agencia,ISNULL(E5_CONTA,'') Conta,ISNULL(E5_TIPODOC,'') Tipo_Documento,ISNULL(E5_MOTBX,'') Motivo_Baixa,
       E2_NUM Titulo,E2_PREFIXO Prefixo,E2_TIPO Tipo,
       E2_PARCELA Parcela,E2_VALOR Valor,E2_SALDO Saldo,E2_VALLIQ Valor_Liquido,E2_ACRESC Acrescimo,E2_DECRESC Decrecimo,E2_VALOR+E2_ACRESC-E2_DECRESC Valor_Corrigido,
       ISNULL(E5_VALOR,0) Valor_Baixa,DT_VENCTO Data_Vencimento,
       CASE WHEN (DATEDIFF(DAY,DT_VENCTO,GETDATE()) > 0) AND (ISNULL(DT_BAIXA,'') = '') THEN 'VENCIDO' ELSE 'A VENCER' END Status,
       DT_BAIXA Data_Baixa,
       E2_NOMFOR Fornecedor,E2_HIST Historico,ISNULL(E5_HISTOR,'') Historico_Baixa
FROM(
SELECT 'AMAZON' Empresa,E2_FILORIG,E2_NATUREZ,ED_DESCRIC,CONVERT(VARCHAR,CAST(E2_EMISSAO AS DATE),103)DT_EMISSAO,
       E5_DATA,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_TIPODOC,E5_MOTBX,
       E2_NUM,E2_PREFIXO,E2_TIPO,E2_PARCELA,E2_VALOR,E2_SALDO,E2_VALLIQ,E5_VALOR,E2_ACRESC,E2_DECRESC,
       CONVERT(VARCHAR,CAST(E2_VENCTO AS DATE),103)DT_VENCTO,
     ISNULL(CASE WHEN E5_DATA = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E5_DATA AS DATE),103)END,'') DT_BAIXA,E2_NOMFOR,E2_HIST,E5_HISTOR
FROM SE2200 SE2 (NOLOCK)
LEFT JOIN SE5200 SE5 (NOLOCK) ON E5_NUMERO = E2_NUM AND E5_PREFIXO = E2_PREFIXO AND E5_PARCELA = E2_PARCELA AND E5_TIPO = E2_TIPO AND E5_CLIFOR = E2_FORNECE AND E5_LOJA = E2_LOJA AND SE5.D_E_L_E_T_ = ''
LEFT JOIN SED200 SED (NOLOCK) ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
LEFT JOIN CTT200 CTT (NOLOCK) ON E2_CCUSTO = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
WHERE SE2.D_E_L_E_T_ = ''
AND E5_DATA BETWEEN SUBSTRING(CONVERT(VARCHAR,GETDATE()-1825,112),1,6)+'01' AND CONVERT(VARCHAR,GETDATE(),112)
)TB
UNION
SELECT Empresa,E2_FILORIG Filial_Origem,E2_NATUREZ Natureza,ISNULL(ED_DESCRIC,'') Descricao,DT_EMISSAO Data_Emissao,
       CASE WHEN E5_DATA IS NULL THEN '' ELSE CONVERT(VARCHAR,CAST(E5_DATA AS DATE),103) END Data_Movimentacao,
       ISNULL(E5_BANCO,'') Banco,ISNULL(E5_AGENCIA,'') Agencia,ISNULL(E5_CONTA,'') Conta,ISNULL(E5_TIPODOC,'') Tipo_Documento,ISNULL(E5_MOTBX,'') Motivo_Baixa,
       E2_NUM Titulo,E2_PREFIXO Prefixo,E2_TIPO Tipo,
       E2_PARCELA Parcela,E2_VALOR Valor,E2_SALDO Saldo,E2_VALLIQ Valor_Liquido,E2_ACRESC Acrescimo,E2_DECRESC Decrecimo,E2_VALOR+E2_ACRESC-E2_DECRESC Valor_Corrigido,
       ISNULL(E5_VALOR,0) Valor_Baixa,DT_VENCTO Data_Vencimento,
       CASE WHEN (DATEDIFF(DAY,DT_VENCTO,GETDATE()) > 0) AND (ISNULL(DT_BAIXA,'') = '') THEN 'VENCIDO' ELSE 'A VENCER' END Status,
       DT_BAIXA Data_Baixa,
       E2_NOMFOR Fornecedor,E2_HIST Historico,ISNULL(E5_HISTOR,'') Historico_Baixa
FROM(
SELECT 'PELMEX' Empresa,E2_FILORIG,E2_NATUREZ,ED_DESCRIC,CONVERT(VARCHAR,CAST(E2_EMISSAO AS DATE),103)DT_EMISSAO,
       E5_DATA,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_TIPODOC,E5_MOTBX,
       E2_NUM,E2_PREFIXO,E2_TIPO,E2_PARCELA,E2_VALOR,E2_SALDO,E2_VALLIQ,E5_VALOR,E2_ACRESC,E2_DECRESC,
       CONVERT(VARCHAR,CAST(E2_VENCTO AS DATE),103)DT_VENCTO,

ISNULL(CASE WHEN E5_DATA = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E5_DATA AS DATE),103)END,'') DT_BAIXA,E2_NOMFOR,E2_HIST,E5_HISTOR
FROM SE2100 SE2 (NOLOCK)
LEFT JOIN SE5100 SE5 (NOLOCK) ON E5_NUMERO = E2_NUM AND E5_PREFIXO = E2_PREFIXO AND E5_PARCELA = E2_PARCELA AND E5_TIPO = E2_TIPO AND E5_FORNECE = E2_FORNECE AND E5_LOJA = E2_LOJA AND SE5.D_E_L_E_T_ = ''
LEFT JOIN SED100 SED (NOLOCK) ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
LEFT JOIN CTT100 CTT (NOLOCK) ON E2_CCUSTO = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
WHERE SE2.D_E_L_E_T_ = ''
AND E5_DATA BETWEEN SUBSTRING(CONVERT(VARCHAR,GETDATE()-1825,112),1,6)+'01' AND CONVERT(VARCHAR,GETDATE(),112)
)TB
)TB1
WHERE Motivo_Baixa NOT IN ('DAC','COMP')
ORDER BY 2,1,CONVERT(VARCHAR,CAST(Data_Emissao AS DATE),112),Titulo,Prefixo,Parcela

EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
 
Return


Static Function AjustaSX1(cPerg)

//u_InPutSX1(cPerg,"01",PADR("De Baixa "    ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
//u_InPutSX1(cPerg,"02",PADR("Ate Data Baixa "    ,20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
//u_InPutSX1(cPerg,"03",PADR("De Serie ",20)+"?","","","mv_ch3","C",3,0,0,"G","","","","","mv_par03")
//u_InPutSX1(cPerg,"04",PADR("Ate Serie ",20)+"?","","","mv_ch4","C",3,0,0,"G","","","","","mv_par04")
//u_InPutSX1(cPerg,"05",PADR("De Cliente ",20)+"?","","","mv_ch5","C",30,0,0,"G","","","","","mv_par05")
//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"     ,20)+"?","","","mv_ch6","C",30,0,0,"G","","","","","mv_par06") 
//u_InPutSX1(cPerg,"04",PADR("Ate Dt Baixa"    ,20)+"?","","","mv_ch4","D",15,0,0,"G","","","","","mv_par04")
//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
