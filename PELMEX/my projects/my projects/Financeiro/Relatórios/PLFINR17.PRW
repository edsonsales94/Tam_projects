#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR12    บAutor  ณStan Lee Lopes     				บ Data ณ  05/11/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de Titulos X Notas	           								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR17()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR17"

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

	oReport := TReport():New(cPerg,"TOTAL GERAL RECEBER X NOTAS FISCAIS",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"TOTAL GERAL RECEBER X NOTAS FISCAIS",{"SE1"},aOrdem) 


	TRCell():New(oSection,"M0_FILIAL"		,"SM0","Filial",/*Mascara*/,25) 
	TRCell():New(oSection,"E1_TIPO"		,"SE1","Tipo",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"E1_BASCOM1"     ,"SE1","Total","@E 9,999,999,999.99",)        

	//Segunda se็ใo
	//oSection2 := TRSection():New(oReport,"TOTAL GERAL RECEBER X NOTAS FISCAIS",{"SE1"},aOrdem)  

	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("E1_BASCOM1"),"TOTAL GERAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

	//oReport:SetTotalInLine(.F.)

	//Quebra por Se็ใo
	//oSection1:SetPageBreak(.T.)
	//oSection1:SetTotalText(" ")

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)
	//Local oSection2  := oReport:Section(2)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ท
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%   

		SELECT TB.M0_FILIAL,TB.E1_TIPO,
		SUM(CASE WHEN TB.E1_TIPO = 'CR ' THEN TB.E1_BASCOM1*0 ELSE TB.E1_BASCOM1 END) E1_BASCOM1
		FROM(
		SELECT M0_FILIAL,E1_NSUTEF,E1_NUM,E1_PREFIXO,E1_EMISSAO,E1_TIPO,SUM(E1_BASCOM1)E1_BASCOM1,
		CASE WHEN C5_NOTA IS NULL THEN SL1.L1_DOC ELSE C5_NOTA END C5_NOTA,
		CASE WHEN C5_SERIE IS NULL THEN SL1.L1_SERIE ELSE C5_SERIE END C5_SERIE,
		SL1.L1_CLIENTE L1_CLIENTE,SL1.L1_LOJA,
		CASE WHEN (L1_CLIENTE = '001041' AND A1_NOME IS NULL) THEN 'CLIENTE PADRAO MANAUS'
		WHEN (L1_CLIENTE = '003067' AND A1_NOME IS NULL) THEN 'CLIENTE PADRAO BELEM'
		ELSE A1_NOME END A1_NOME,
		SL1.L1_CGCCLI,SA3.A3_NOME
		FROM %Table:SE1% SE1 (NOLOCK)
		INNER JOIN %Table:SL1% SL1 ON SE1.E1_NUM = CASE WHEN SL1.L1_DOC = '' THEN SL1.L1_DOCPED ELSE SL1.L1_DOC END
		AND SE1.E1_PREFIXO = CASE WHEN SL1.L1_SERIE = '' THEN SL1.L1_SERPED ELSE SL1.L1_SERIE END AND SE1.D_E_L_E_T_ = ''
		LEFT JOIN %Table:SC5% SC5 (NOLOCK) ON SL1.L1_FILIAL = CASE WHEN SC5.C5_XFILRES = '' THEN SC5.C5_FILIAL ELSE SC5.C5_XFILRES END 
		AND SL1.L1_NUM = CASE WHEN SC5.C5_XORCRES = '' THEN SC5.C5_ORCRES ELSE SC5.C5_XORCRES END AND SC5.D_E_L_E_T_ = ''								  
		LEFT JOIN %Table:SA1% SA1 (NOLOCK) ON SL1.L1_CGCCLI = SA1.A1_CGC AND SL1.L1_DOC != '' AND SA1.D_E_L_E_T_ = '' AND SA1.A1_MSBLQL != '1'
		INNER JOIN %Table:SA3% SA3 (NOLOCK) ON SL1.L1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = '' 
		INNER JOIN SIGAMAT SM ON SE1.E1_MSFIL = SM.M0_CODFIL AND SM.M0_CODIGO = '10'
		AND SE1.E1_MSFIL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND SE1.E1_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND SL1.L1_VEND BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%  
		AND SL1.D_E_L_E_T_ = ''
		AND SL1.L1_SERIE != '20'
		GROUP BY M0_FILIAL,E1_NSUTEF,E1_NUM,E1_PREFIXO,E1_EMISSAO,E1_TIPO,C5_NOTA,C5_SERIE,L1_DOC,L1_SERIE,L1_CLIENTE,L1_LOJA,SA1.A1_NOME,L1_CGCCLI,A3_NOME


		)TB LEFT JOIN %Table:SA1% SA1 ON TB.L1_CLIENTE = SA1.A1_COD AND TB.L1_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
		GROUP BY TB.M0_FILIAL,TB.E1_TIPO
		ORDER BY 1,2

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	PutSX1(cPerg,"01",PADR("Filial De    ",20)+"?","","","mv_ch1","C",2,0,0,"G","","SM0","","","mv_par01") 
	PutSX1(cPerg,"02",PADR("Filial At้   ",20)+"?","","","mv_ch2","C",2,0,0,"G","","SM0","","","mv_par02") 
	PutSX1(cPerg,"03",PADR("Emissao De    ",20)+"?","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03") 
	PutSX1(cPerg,"04",PADR("Emissao At้   ",20)+"?","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04")   
	PutSX1(cPerg,"05",PADR("Vendedor De    ",20)+"?","","","mv_ch5","C",6,0,0,"G","","SA3","","","mv_par05") 
	PutSX1(cPerg,"06",PADR("Vendedor At้   ",20)+"?","","","mv_ch6","C",6,0,0,"G","","SA3","","","mv_par06") 

Return
