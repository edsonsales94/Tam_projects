#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR80    บAutor  ณJuevan Silva   				บ Data ณ 04/08/2025บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Movimenta็๕es Bancarias a Receber Novo                   		     			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR80()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR80"

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
   

	oReport := TReport():New(cPerg,"Movimenta็๕es Bancarias a Receber Novo ",cPerg,{|oReport| PrintReport(oReport,cAlias)})


	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Movimenta็๕es Bancarias a Receber Novo ",{"SE2"},aOrdem)
	
    
TRCell():New(oSection,"Periodo"	        ,"SE2","Periodo","@!",10)
TRCell():New(oSection,"Empresa"	        ,"SE2","Empresa","@!",10)
TRCell():New(oSection,"Filial_Origem"	    ,"SE2","Filial Origem","@!",2)
TRCell():New(oSection,"Natureza"	    ,"SE2","Natureza","@!",8)
TRCell():New(oSection,"Descricao"	    ,"SE2","Descricao","@!",20)
TRCell():New(oSection,"Data_Emissao"	        ,"SE2","Data Emissao","@!",10)
TRCell():New(oSection,"Bordero"	     ,"SE5","Bordero","@!",8)
TRCell():New(oSection,"Data_Bordero"	    ,"SE5","Data Bordero","@!",10)  
TRCell():New(oSection,"Situacao"	    ,"SE5","Situacao","@!",2)
TRCell():New(oSection,"Banco_Bordero"	    ,"SE2","Banco Bordero","@!",6) 
TRCell():New(oSection,"Agencia_Bordero"	    ,"SE5","Agencia Bordero","@!",6)
TRCell():New(oSection,"Conta_Bordero"	     ,"SE5","Conta Bordero","@!",6)
TRCell():New(oSection,"Banco"	    ,"SE5","Banco","@!",6)
TRCell():New(oSection,"Agencia"	    ,"SE5","Agencia","@!",6)
TRCell():New(oSection,"Conta"	    ,"SE2","Conta","@!",6)
TRCell():New(oSection,"Tipo_Documento"	    ,"SE2","Tipo Documento","@!",3)
TRCell():New(oSection,"Motivo_Baixa"	    ,"SE2","Motivo Baixa","@!",3)
TRCell():New(oSection,"Titulo"	    ,"SE2","Titulo","@!",11)
TRCell():New(oSection,"Prefixo"	    ,"SE2","Prefixo","@!",2)
TRCell():New(oSection,"Tipo"	    ,"SE2","Tipo","@!",3)
TRCell():New(oSection,"Parcela"	    ,"SE2","Parcela","@!",2)
TRCell():New(oSection,"Valor"	   	 ,"SE2","Valor","@E 9,999,999,999.99")
TRCell():New(oSection,"Saldo"	   	 ,"SE2","Saldo","@E 9,999,999,999.99")
TRCell():New(oSection,"Valor_Liquido"	   	 ,"SE2","Valor_Liquido","@E 9,999,999,999.99")
TRCell():New(oSection,"Valor_Baixa"	   	 ,"SE2","Valor Baixa","@E 9,999,999,999.99")
TRCell():New(oSection,"Data_Vencimento","SE2","Data_Vencimento","@!",10)
TRCell():New(oSection,"Data_Baixa"	    ,"SE2","Data Baixa","@!",10)
TRCell():New(oSection,"Cliente"	   	 ,"SE2","Cliente","@!",10)
TRCell():New(oSection,"Historico"	    ,"SE2","Historico","@!",30)
TRCell():New(oSection,"Historico_Baixa"	    ,"SE2","Historico Baixa","@!",10)
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

	//Quebra por Se็ใo
	oSection:SetPageBreak(.T.)
	oSection:SetTotalText(" ")

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)
	//Local oSection2  := oReport:Section(2)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"      
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
	%noparser%   



SELECT SUBSTRING(Data_Emissao,4,7)Periodo,TB1.*,
       CASE WHEN [Descricao] LIKE '%ICMS%' THEN 'IMPOSTO'
            WHEN [Descricao] LIKE '%COMISSAO REPRESENTANTE/PROMOTO%'  THEN 'DESPESA COM PESSOAL'
      WHEN [Descricao] LIKE '%ENCARGOS,FPP E TAXA CONDOMINIO%'  THEN 'ALUGUEL'
      WHEN [Descricao] LIKE '%IRF%'  THEN 'IMPOSTO'
      WHEN [Descricao] LIKE '%ISS%'  THEN 'IMPOSTO'
      WHEN [Descricao] LIKE '%IRF%'  THEN 'IMPOSTO'
      WHEN [Descricao] LIKE '%INSS%'  THEN 'IMPOSTO'
      WHEN [Descricao] LIKE '%FGTS%' THEN 'IMPOSTO'
      WHEN [Descricao] LIKE '%IPTU%'  THEN 'IMPOSTO'
      WHEN [Descricao] LIKE '%CSLL%'  THEN 'IMPOSTO'
      WHEN [Descricao] LIKE '%PIS%'  THEN 'IMPOSTO'
      WHEN [Descricao] LIKE '%IRPJ%'  THEN 'IMPOSTO'
      WHEN [Descricao] LIKE '%COFINS%'  THEN 'IMPOSTO'
      WHEN [Descricao] LIKE '%GNRE%'  THEN 'IMPOSTO'
      WHEN [Descricao] LIKE '%ALPHA MOTION-INDUSTRIA NF%'  THEN 'IMPOSTO'
      WHEN [Descricao] LIKE '%SUFRAMA%'  THEN 'IMPOSTO'
      WHEN [Descricao] LIKE '%IMPOSTO%'  THEN 'IMPOSTO'
      WHEN [Descricao] LIKE '%CONTRIB%' THEN 'IMPOSTO'
      WHEN Natureza LIKE '%ICMS%' THEN 'IMPOSTO'
      WHEN [Descricao] LIKE '%TAXA%'  THEN 'IMPOSTO'
      WHEN [Descricao] LIKE '%ACESSORIA%'  THEN 'ACESSORIA'
      WHEN [Descricao] LIKE '%SERVICOS AVULSO T.I (STAN)%'  THEN 'ACESSORIA'
      WHEN [Descricao] LIKE '%DOMINIO DE EMAIL PELMEX%'  THEN 'ACESSORIA'
      WHEN [Descricao] LIKE '%SERVICOS CONSULTORIA SISTEMA%'  THEN 'ACESSORIA'
      WHEN [Descricao] LIKE '%MATERIA%PRIMA%'  THEN 'MATERIA PRIMA'
      WHEN [Descricao] LIKE '%FRETE%'  THEN 'FRETE'
      WHEN [Descricao] LIKE '%DESPESAS C/ DESCARGAS%'  THEN 'FRETE'
      WHEN [Descricao] LIKE '%DESPESAS DIRETORIA%'  THEN 'DESPESAS DIRETORIA'
      WHEN [Descricao] LIKE '%DESP%JURI%'  THEN 'DESPESAS JURIDICAS'
      WHEN [Descricao] LIKE '%EXAMES%'  THEN 'EXAMES'
      WHEN [Descricao] LIKE '%SEGURO%'  THEN 'SEGURO'
      WHEN [Descricao] LIKE '%EMPRESTIMO%'  THEN 'EMPRESTIMOS'
      WHEN [Descricao] LIKE '%ENERGIA%'  THEN 'ENERGIA'
      WHEN [Descricao] LIKE '%ALUGUE%'  THEN 'ALUGUEL'
      WHEN [Descricao] LIKE '%ALVARA%'  THEN 'ALVARA'
      WHEN [Descricao] LIKE '%TRANSPORTE%'  THEN 'TRANSPORTE'
      WHEN [Descricao] LIKE '%SERVICO%'  THEN 'SERVIวOS'
      WHEN [Descricao] LIKE '%PUBLICIDADE%'  THEN 'PUBLICIDADE'
      WHEN [Descricao] LIKE '%FINANCIAMENTO%'  THEN 'FINANCIAMENTO'
      WHEN [Descricao] LIKE '%FINAN%'  THEN 'FINANCIAMENTO'
      WHEN [Descricao] LIKE '%FORNECEDORES%' AND Historico LIKE '%REFEICOES%' THEN 'DESPESA COM PESSOAL'
      WHEN [Descricao] LIKE '%FORNECEDORES%' AND Historico LIKE '%DROGARIA%' THEN 'DESPESA COM PESSOAL'
      WHEN [Descricao] LIKE '%FORNECEDORES%' AND Historico LIKE '%ALIMENTACAO%' THEN 'DESPESA COM PESSOAL'
      WHEN [Descricao] LIKE '%FORNECEDORES%' AND Historico LIKE '%CONVENIO%' THEN 'DESPESA COM PESSOAL'
      WHEN [Descricao] LIKE '%FORNECEDORES%' AND Historico LIKE '%OTICA%' THEN 'DESPESA COM PESSOAL'
      WHEN [Descricao] LIKE '%FORNECEDORES%' AND Historico LIKE '%MATERIA PRIMA%' THEN 'MATERIA PRIMA'
      WHEN [Descricao] LIKE '%FORNECEDORES%' AND Historico LIKE '%MAT%PRIMA%' THEN 'MATERIA PRIMA'
      WHEN [Descricao] LIKE '%FORNECEDORES%' AND Historico LIKE '%FRETE%' THEN 'FRETE'
      WHEN [Descricao] LIKE '%FORNECEDORES%'  THEN 'FORNECEDORES'
      
      WHEN [Descricao] LIKE '%AGUA%'  THEN 'AGUA/ESGOTO'
      WHEN [Descricao] LIKE '%MANUTENCAO%'  THEN 'MANUTENวรO'
      WHEN [Descricao] LIKE '%ALIMENTACAO%'  THEN 'ALIMENTAวรO'
      WHEN Cliente LIKE 'V V REFEICOES%'  THEN 'ALIMENTAวรO'
      WHEN [Descricao] LIKE '%DESEMBARACO%'  THEN 'DESEMBARAวO'
      WHEN [Descricao] LIKE '%CREDITO%'  THEN 'CREDITO'
      WHEN [Descricao] LIKE '%ADIANTAMENTO%SALARIO%'  THEN 'DESPESA COM PESSOAL'
      WHEN [Descricao] LIKE '%RESCISAO%'  THEN 'DESPESA COM PESSOAL'
      WHEN [Descricao] LIKE '%FERIAS%'  THEN 'DESPESA COM PESSOAL'

WHEN [Descricao] LIKE '%SALARIO%' AND [Descricao] NOT LIKE '%ADIANTAMENTO%'  THEN 'DESPESA COM PESSOAL'
      WHEN [Descricao] LIKE '%HORAS%EXTRA%' THEN 'DESPESA COM PESSOAL'
      WHEN [Descricao] LIKE '%PROCESSO%' THEN 'DESPESA JUDICIAL'
      WHEN [Descricao] LIKE '%INTERNET%' THEN 'TECNOLOGIA'
      WHEN [Descricao] LIKE '%INFORMA%' THEN 'TECNOLOGIA'
      WHEN [Descricao] LIKE '%REEMBOLSO%' THEN 'REEMBOLSO'
      WHEN [Descricao] LIKE '%MAQ%EQUI%' THEN 'MAQUINAS'
      WHEN [Descricao] LIKE '%COMBUSTIVEL%' THEN 'FRETE'
      WHEN [Descricao] LIKE '%MAT%CONSUMO%' THEN 'MATERIAL USO E CONSUMO'
      WHEN [Descricao] LIKE '%MEDICAMENTO%' THEN 'MEDICAMENTO'
      WHEN [Descricao] LIKE '%LOCACAO%' THEN 'LOCAวรO'
      WHEN [Descricao] LIKE '%SERV%PRESTA%' THEN 'ACESSORIA'
      WHEN [Descricao] LIKE '%EVENTO%' THEN 'PUBLICIDADE'
      WHEN [Descricao] LIKE '%DESCONTO%' THEN 'DESCONTOS'
    ELSE [Descricao]END Grupo
    
FROM(
SELECT Empresa,E1_FILORIG [Filial_Origem],E1_NATUREZ [Natureza],ISNULL(ED_DESCRIC,'') [Descricao],DT_EMISSAO [Data_Emissao],
       E1_NUMBOR [Bordero],E1_DATABOR [Data_Bordero],E1_SITUACA [Situacao],E1_PORTADO [Banco_Bordero],E1_AGEDEP [Agencia_Bordero],E1_CONTA [Conta_Bordero],
       E5_BANCO Banco,E5_AGENCIA Agencia,E5_CONTA Conta,E5_TIPODOC [Tipo_Documento],E5_MOTBX [Motivo_Baixa],
     E1_NUM Titulo,E1_PREFIXO Prefixo,E1_TIPO Tipo,
       E1_PARCELA Parcela,E1_VALOR Valor,E1_SALDO Saldo,E1_VALLIQ [Valor_Liquido],E5_VALOR [Valor_Baixa],DT_VENCTO [Data Vencimento],DT_BAIXA [Data_Baixa],
     E1_NOMCLI Cliente,E1_HIST [Historico],E5_HISTOR [Historico_Baixa]
FROM(
SELECT 'AMAZON' Empresa,E1_FILORIG,E1_NATUREZ,ED_DESCRIC,CONVERT(VARCHAR,CAST(E1_EMISSAO AS DATE),103)DT_EMISSAO,E1_NUMBOR,
       CASE WHEN E1_DATABOR = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E1_DATABOR AS DATE),103)END E1_DATABOR,E1_SITUACA,
     E1_PORTADO,E1_AGEDEP,E1_CONTA,
       ISNULL(E5_BANCO,'')E5_BANCO,ISNULL(E5_AGENCIA,'')E5_AGENCIA,ISNULL(E5_CONTA,'')E5_CONTA,ISNULL(E5_TIPODOC,'')E5_TIPODOC,ISNULL(E5_MOTBX,'')E5_MOTBX,
       E1_NUM,E1_PREFIXO,E1_TIPO,E1_PARCELA,E1_VALOR,E1_SALDO,E1_VALLIQ,ISNULL(E5_VALOR,0)E5_VALOR,
       CONVERT(VARCHAR,CAST(E1_VENCTO AS DATE),103)DT_VENCTO,
     CASE WHEN ISNULL(E5_DATA,'') = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E5_DATA AS DATE),103)END DT_BAIXA,E1_NOMCLI,E1_HIST,E5_HISTOR
FROM SE1200 SE5 (NOLOCK)
LEFT JOIN SE5200 SE1 (NOLOCK) ON E5_NUMERO = E1_NUM AND E5_PREFIXO = E1_PREFIXO AND E5_PARCELA = E1_PARCELA AND E5_TIPO = E1_TIPO AND E5_CLIFOR = E1_CLIENTE AND E5_LOJA = E1_LOJA AND SE5.D_E_L_E_T_ = ''
LEFT JOIN SED200 SED (NOLOCK) ON E1_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
LEFT JOIN CTT200 CTT (NOLOCK) ON E1_CCUSTO = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
WHERE SE1.D_E_L_E_T_ = ''
AND E5_DATA BETWEEN SUBSTRING(CONVERT(VARCHAR,GETDATE()-1825,112),1,6)+'01' AND CONVERT(VARCHAR,GETDATE(),112)
)TB
UNION
SELECT Empresa,E1_FILORIG [Filial_Origem],E1_NATUREZ [Natureza],ISNULL(ED_DESCRIC,'') [Descricao],DT_EMISSAO [Data_Emissao],
       E1_NUMBOR [Bordero],E1_DATABOR [Data Bordero],E1_SITUACA [Situacao],E1_PORTADO [Banco_Bordero],E1_AGEDEP [Agencia_Bordero],E1_CONTA [Conta_Bordero],
       E5_BANCO Banco,E5_AGENCIA Agencia,E5_CONTA Conta,E5_TIPODOC [Tipo_Documento],E5_MOTBX [Motivo_Baixa],
     E1_NUM Titulo,E1_PREFIXO Prefixo,E1_TIPO Tipo,
       E1_PARCELA Parcela,E1_VALOR Valor,E1_SALDO Saldo,E1_VALLIQ [Valor_Liquido],E5_VALOR [Valor_Baixa],DT_VENCTO [Data Vencimento],DT_BAIXA [Data_Baixa],
     E1_NOMCLI Cliente,E1_HIST [Historico],E5_HISTOR [Historico_Baixa]
FROM(
SELECT 'PELMEX' Empresa,E1_FILORIG,E1_NATUREZ,ED_DESCRIC,CONVERT(VARCHAR,CAST(E1_EMISSAO AS DATE),103)DT_EMISSAO,E1_NUMBOR,
       CASE WHEN E1_DATABOR = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E1_DATABOR AS DATE),103)END E1_DATABOR,E1_SITUACA,
     E1_PORTADO,E1_AGEDEP,E1_CONTA,
       ISNULL(E5_BANCO,'')E5_BANCO,ISNULL(E5_AGENCIA,'')E5_AGENCIA,ISNULL(E5_CONTA,'')E5_CONTA,ISNULL(E5_TIPODOC,'')E5_TIPODOC,ISNULL(E5_MOTBX,'')E5_MOTBX,
       E1_NUM,E1_PREFIXO,E1_TIPO,E1_PARCELA,E1_VALOR,E1_SALDO,E1_VALLIQ,ISNULL(E5_VALOR,0)E5_VALOR,

CONVERT(VARCHAR,CAST(E1_VENCTO AS DATE),103)DT_VENCTO,
     CASE WHEN ISNULL(E5_DATA,'') = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E5_DATA AS DATE),103)END DT_BAIXA,E1_NOMCLI,E1_HIST,E5_HISTOR
FROM SE1100 SE1 (NOLOCK)
LEFT JOIN SE5100 SE5 (NOLOCK) ON E5_NUMERO = E1_NUM AND E5_PREFIXO = E1_PREFIXO AND E5_PARCELA = E1_PARCELA AND E5_TIPO = E1_TIPO AND E5_CLIENTE = E1_CLIENTE AND E5_LOJA = E1_LOJA AND SE5.D_E_L_E_T_ = ''
LEFT JOIN SED100 SED (NOLOCK) ON E1_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
LEFT JOIN CTT100 CTT (NOLOCK) ON E1_CCUSTO = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
WHERE SE1.D_E_L_E_T_ = ''
AND E5_DATA BETWEEN SUBSTRING(CONVERT(VARCHAR,GETDATE()-500,112),1,6)+'01' AND CONVERT(VARCHAR,GETDATE(),112)
)TB
)TB1
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
