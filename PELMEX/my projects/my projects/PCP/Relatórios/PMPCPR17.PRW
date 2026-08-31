#include "rwmake.ch"                  

#include "topconn.ch"
#include "TOTVS.ch"

/*_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-------------------------------------------------------------------------+¦¦
¦¦¦Função    ¦ PELCOMR05 	¦ Autor ¦   ¦ Data ¦17/07/15                     ¦¦
¦¦+----------+--------------------------------------------------------------+¦¦
¦¦¦Descrição ¦ Relatório - Analise de produção Diaria             		    ¦¦¦
¦¦¦          ¦                                                              ¦¦¦
¦¦+----------+--------------------------------------------------'-----------+¦¦
¦¦¦Parametros¦	                                        	     		    ¦¦¦
¦¦¦          ¦                                                              ¦¦¦
¦¦+----------+--------------------------------------------------------------+¦¦
¦¦¦Uso       ¦                                                              ¦¦¦
¦¦+----------------------------------- --------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PMPCPR17()
	Local oReport 	              // Objeto relatorio TReport
	Private cPerg := "PMPCPR17" // Nome do grupo de perguntas
	Private _cQrbPag:= ""

	ValidPerg()
	If !Pergunte(cPerg,.T.)

		Return
	Endif

	/*=================================
	|  Monta a interface de impressao |
	=================================*/
	oReport := RLPRDFDEF()
	oReport:PrintDialog()

Return

/*_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-------------------------------------------------------------------------+¦¦
¦¦¦Função    ¦ RLPRDFDEF  ¦ Autor ¦ 					¦ Data ¦ 03/08/2012 ¦¦¦
¦¦+----------+--------------------------------------------------------------+¦¦
¦¦¦Descriçào ¦ Funcao auxiliar para impressao do relatorio                  ¦¦¦
¦¦+----------+--------------------------------------------------------------+¦¦
¦¦¦Parametros¦                                  	     		            ¦¦¦
¦¦¦          ¦                                                              ¦¦¦
¦¦+----------+--------------------------------------------------------------+¦¦
¦¦¦Uso       ¦                                                              ¦¦¦
¦¦+-------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function RLPRDFDEF()
	Local oReport
	Local oSection1
	Local oSection2    
	Local oBreak
	Local cNomeRel 	 := "PMPCPR17"           // Nome do relatorio
	Local cTitulo 	 := "Relatório Analise de Produção diario"   	    // Titulo do relatorio
	Local cDescri 	 := "Relatório Analise de Produção diario" 		// Descricao do relatorio
	Local aOrdem	 := {}							    	   	        // Ordem de impressao do relatorio
	Local cCabec1    := "Relatório "            
	Local cCabec2    := "Relação de "


	/*========================================
	| Cria o Objeto de impressao             |
	========================================*/
	oReport := TReport():New(cNomeRel, cTitulo, cPerg, {|oReport| RunReport(oReport)}, cDescri)

	/*========================================
	| Define o tamanho da fonte.             |
	========================================*/
	oReport:nFontBody	:= 7

	/*========================================
	| Define a altura da linha.              |
	========================================*/
	oReport:nLineHeight	:= 48

	/*========================================
	| Define a posicao da pagina do relatorio|
	========================================*/
	oReport:SetLandScape()     // SetPortrait() Modo Retrato

	/*=====================================================|
	|   Define secao do relatorio                          |
	======================================================*/

	oSection1 := TRSection():New( oReport , cCabec1 , {}, aOrdem )	// Dados da nota       
	oSection1:SetTotalInLine(.T.)      

	TRCell():New( oSection1, "B1_GRUPO"    		, "", "Grupo"				 	,, 15 , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "BM_DESC"   		, "", "Descricao"				,, 50 , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D01"	 			, "", "01"      	  			,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D02" 				, "", "02"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D03" 				, "", "03"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D04" 				, "", "04"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D05" 				, "", "05"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D06" 				, "", "06"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D07" 				, "", "07"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D08" 				, "", "08"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D09" 				, "", "09"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D10" 				, "", "10"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D11" 				, "", "11"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D12" 				, "", "12"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D13" 				, "", "13"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D14" 				, "", "14"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D15" 				, "", "15"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D16" 				, "", "16"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D17" 				, "", "17"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D18" 				, "", "18"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D19" 				, "", "19"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D20" 				, "", "20"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D21" 				, "", "21"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D22" 				, "", "22"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D23" 				, "", "23"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D24" 				, "", "24"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D25" 				, "", "25"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D26" 				, "", "26"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D27" 				, "", "27"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D28" 				, "", "28"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D29" 				, "", "29"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D30" 				, "", "30"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "D31" 				, "", "31"      	        	,,3, .F., /*{|| code-block de impressao }*/)
	/*
	oBreak := TRBreak():New(oSection1,{ || oSection1:Cell("JANEIRO"):uPrint },"SubTotal",.T.,"Total ")
	oBreak := TRBreak():New(oSection1,{ || oSection1:Cell("FEVEREIRO"):uPrint },"SubTotal",.T.,"Total ") 
	oBreak := TRBreak():New(oSection1,{ || oSection1:Cell("MARCO"):uPrint },"SubTotal",.T.,"Total ") 
	oBreak := TRBreak():New(oSection1,{ || oSection1:Cell("ABRIL"):uPrint },"SubTotal",.T.,"Total ") 
	oBreak := TRBreak():New(oSection1,{ || oSection1:Cell("MAIO"):uPrint },"SubTotal",.T.,"Total ") 
	oBreak := TRBreak():New(oSection1,{ || oSection1:Cell("JUNHO"):uPrint },"SubTotal",.T.,"Total ") 
	oBreak := TRBreak():New(oSection1,{ || oSection1:Cell("JULHO"):uPrint },"SubTotal",.T.,"Total ") 
	oBreak := TRBreak():New(oSection1,{ || oSection1:Cell("AGOSTO"):uPrint },"SubTotal",.T.,"Total ") 
	oBreak := TRBreak():New(oSection1,{ || oSection1:Cell("SETEMBRO"):uPrint },"SubTotal",.T.,"Total ") 
	oBreak := TRBreak():New(oSection1,{ || oSection1:Cell("OUTUBRO"):uPrint },"SubTotal",.T.,"Total ") 
	oBreak := TRBreak():New(oSection1,{ || oSection1:Cell("NOVEMBRO"):uPrint },"SubTotal",.T.,"Total ") 
	oBreak := TRBreak():New(oSection1,{ || oSection1:Cell("DEZEMBRO"):uPrint },"SubTotal",.T.,"Total ") 
	*/  


	TRFunction():New(oSection1:Cell( "01" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)  
	TRFunction():New(oSection1:Cell( "02" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)  
	TRFunction():New(oSection1:Cell( "03" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "04" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "05" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "06" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "07" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "08" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "09" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "10" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "11" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "12" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "13" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "14" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "15" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "16" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "17" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "18" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "19" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "20" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "21" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "22" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "23" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "24" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "25" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "26" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "27" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "28" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "29" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "30" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "31" ),"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)


	/*                                    
	oBreak := TRBreak():New(oSection1,{ || oSection1:Cell("CGRUPO"):uPrint },"SubTotal",.T.,"Total ")  

	TRFunction():New(oSection1:Cell( "NSUGES" ), " TOTAL ", "SUM" ,oBreak,"Total Sugestao","@E 999,999,999.99"   ,,.T.,.F.,.F.,,)       


	oBreak:Execute()
	*/
	// Imprime o cabecalho
	//oSection1:SetHeaderSection(.F.)
	//oSection1:SetHeaderSection(.T.)

	//oReport:SetTotalInLine(.F.)


Return oReport

/*_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-------------------------------------------------------------------------+¦¦
¦¦¦Função    ¦ RunReport  ¦ Autor ¦ Alexander Valerio   ¦ Data ¦ 15/04/2010 ¦¦¦
¦¦+----------+--------------------------------------------------------------+¦¦
¦¦¦Descriçào ¦ Funcao auxiliar para impressao do relatorio                  ¦¦¦
¦¦¦          ¦                                                              ¦¦¦
¦¦+----------+--------------------------------------------------------------+¦¦
¦¦¦Parametros¦                                                              ¦¦¦
¦¦¦          ¦                                                              ¦¦¦
¦¦+----------+--------------------------------------------------------------+¦¦
¦¦¦Uso       ¦                                                              ¦¦¦
¦¦+-------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function RunReport(oReport)
	Local _cQry    := ""
	Local oSection1:= oReport:Section(1)		        // Objeto secao 1 do relatorio
	Local aStr     := {}                                // Estrutura do arquivo de trabalho

	/*=================================================================================================
	|   Seleciona a movimentacoes de acordo com os parametros informados                                |
	=================================================================================================*/
	Iif(Select("ARQTRB")<>0, ARQTRB->(DbCloseArea()), Nil)


	_cQry:= " SELECT B1_GRUPO,BM_DESC,"
	_cQry+= "     SUM(ISNULL([01],0)) D01,"
	_cQry+= "     SUM(ISNULL([02],0)) D02,"
	_cQry+= "     SUM(ISNULL([03],0)) D03,"
	_cQry+= "     SUM(ISNULL([04],0)) D04,"
	_cQry+= "     SUM(ISNULL([05],0)) D05,"
	_cQry+= "     SUM(ISNULL([06],0)) D06,"
	_cQry+= "     SUM(ISNULL([07],0)) D07,"
	_cQry+= "     SUM(ISNULL([08],0)) D08,"
	_cQry+= "     SUM(ISNULL([09],0)) D09,"
	_cQry+= "     SUM(ISNULL([10],0)) D10,"
	_cQry+= "     SUM(ISNULL([11],0)) D11,"
	_cQry+= "     SUM(ISNULL([12],0)) D12,"
	_cQry+= "     SUM(ISNULL([13],0)) D13,"
	_cQry+= "     SUM(ISNULL([14],0)) D14,"
	_cQry+= "     SUM(ISNULL([15],0)) D15,"
	_cQry+= "     SUM(ISNULL([16],0)) D16,"
	_cQry+= "     SUM(ISNULL([17],0)) D17,"
	_cQry+= "     SUM(ISNULL([18],0)) D18,"
	_cQry+= "     SUM(ISNULL([19],0)) D19,"
	_cQry+= "     SUM(ISNULL([20],0)) D20,"
	_cQry+= "     SUM(ISNULL([21],0)) D21,"
	_cQry+= "     SUM(ISNULL([22],0)) D22,"
	_cQry+= "     SUM(ISNULL([23],0)) D23,"
	_cQry+= "     SUM(ISNULL([24],0)) D24,"
	_cQry+= "     SUM(ISNULL([25],0)) D25,"
	_cQry+= "     SUM(ISNULL([26],0)) D26,"
	_cQry+= "     SUM(ISNULL([27],0)) D27,"
	_cQry+= "     SUM(ISNULL([28],0)) D28,"
	_cQry+= "     SUM(ISNULL([29],0)) D29,"
	_cQry+= "     SUM(ISNULL([30],0)) D30,"
	_cQry+= "     SUM(ISNULL([31],0)) D31"
	_cQry+= "     FROM ("
	_cQry+= "     SELECT B1_GRUPO,BM_DESC,SUM(1) QTDESTOQUE,SUBSTRING(Z1_DTAPONT,7,2) Z1_DTAPONT"
	_cQry+= "     FROM "+RetSQLName("SZ1")+" SZ1 (NOLOCK)"
	_cQry+= "     LEFT JOIN "+ RetSQLName("SC2")+" SC2  (NOLOCK) ON C2_NUM+C2_ITEM+C2_SEQUEN = Z1_OP"
	_cQry+= "     INNER JOIN "+ RetSQLName("SB1")+" SB1 (NOLOCK) ON B1_COD = C2_PRODUTO AND SB1.D_E_L_E_T_ = ''"
	_cQry+= "     INNER JOIN "+ RetSQLName("SBM")+" SBM (NOLOCK) ON B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = '' "
	_cQry+= "     WHERE "
	_cQry+= "     B1_GRUPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	_cQry+= "     AND B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQry+= "     AND B1_LOCPAD = '20'"
	_cQry+= "     AND Z1_DTAPONT BETWEEN  '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
	_cQry+= "     AND SZ1.D_E_L_E_T_ = ''"
	_cQry+= "     GROUP BY B1_GRUPO,BM_DESC,Z1_DTAPONT"
	_cQry+= "     )TB"
	_cQry+= "     PIVOT("
	_cQry+= "     SUM(QTDESTOQUE)"
	_cQry+= "     FOR [Z1_DTAPONT] IN ([01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31])"
	_cQry+= "     )PV"
	_cQry+= "     GROUP BY  B1_GRUPO,BM_DESC"
	_cQry+= "     ORDER BY BM_DESC"







	Memowrite("An_Compras",_cQry)
	TCQUERY ChangeQuery(_cQry) New Alias "ARQTRB"  

	/*===================================================
	|    Seta o Tamanho da regua                        |
	===================================================*/
	oReport:SetMeter( ARQTRB->(RecCount()) )

	_lLp := .T.

	ARQTRB->(DbGotop())
	While !ARQTRB->(Eof()) .And. !oReport:Cancel()

		oSection1:Init() 


		oSection1:Cell("B1_GRUPO")		  	    :SetValue(ARQTRB->B1_GRUPO)  
		oSection1:Cell("BM_DESC" )				:SetValue(ARQTRB->BM_DESC)
		oSection1:Cell("D01" )					:SetValue(ARQTRB->D01)
		oSection1:Cell("D02" )					:SetValue(ARQTRB->D02)
		oSection1:Cell("D03" )					:SetValue(ARQTRB->D03)
		oSection1:Cell("D04" )					:SetValue(ARQTRB->D04)
		oSection1:Cell("D05" )					:SetValue(ARQTRB->D05)
		oSection1:Cell("D06" )					:SetValue(ARQTRB->D06)
		oSection1:Cell("D07" )					:SetValue(ARQTRB->D07)
		oSection1:Cell("D08" )					:SetValue(ARQTRB->D08)
		oSection1:Cell("D09" )					:SetValue(ARQTRB->D09)
		oSection1:Cell("D10" )					:SetValue(ARQTRB->D10)
		oSection1:Cell("D11" )					:SetValue(ARQTRB->D11)
		oSection1:Cell("D12" )					:SetValue(ARQTRB->D12)
		oSection1:Cell("D13" )					:SetValue(ARQTRB->D13)
		oSection1:Cell("D14" )					:SetValue(ARQTRB->D14)
		oSection1:Cell("D15" )					:SetValue(ARQTRB->D15)
		oSection1:Cell("D16" )					:SetValue(ARQTRB->D16)
		oSection1:Cell("D17" )					:SetValue(ARQTRB->D17)
		oSection1:Cell("D18" )					:SetValue(ARQTRB->D18)
		oSection1:Cell("D19" )					:SetValue(ARQTRB->D19)
		oSection1:Cell("D20" )					:SetValue(ARQTRB->D20)
		oSection1:Cell("D21" )					:SetValue(ARQTRB->D21)
		oSection1:Cell("D22" )					:SetValue(ARQTRB->D22)
		oSection1:Cell("D23" )					:SetValue(ARQTRB->D23)
		oSection1:Cell("D24" )					:SetValue(ARQTRB->D24)
		oSection1:Cell("D25" )					:SetValue(ARQTRB->D25)
		oSection1:Cell("D26" )					:SetValue(ARQTRB->D26)
		oSection1:Cell("D27" )					:SetValue(ARQTRB->D27)
		oSection1:Cell("D28" )					:SetValue(ARQTRB->D28)
		oSection1:Cell("D29" )					:SetValue(ARQTRB->D29)
		oSection1:Cell("D30" )					:SetValue(ARQTRB->D30)
		oSection1:Cell("D31" )					:SetValue(ARQTRB->D31)
		oSection1:PrintLine()  
		//oSection1:SetHeaderSection(.T.)

		oReport:IncMeter()

		ARQTRB->(DbSkip(1))

	EndDo     
	/*
	oSection1:Cell("CCOD")		  	    :SetValue( "" )
	oSection1:Cell("CDESC" )			:SetValue( "" )
	oSection1:Cell("CTIPO")			    :SetValue( "" )
	oSection1:Cell("CGRUPO")	 	   	:SetValue( "" )
	oSection1:Cell("CUM")			    :SetValue( "" )
	oSection1:Cell("NSLATU")	 	   	:Disable()
	oSection1:Cell("NVLATU")			:Disable()
	oSection1:Cell("NSALPED")	 	   	:Disable()
	oSection1:Cell("NPPED")			    :Disable()
	oSection1:Cell("NESSEG")	 	   	:Disable()
	oSection1:Cell("NMEDIA")			:Disable()
	oSection1:Cell("NSUGES")	 	   	:Disable()
	oSection1:Cell("NULPRE")			:Disable()
	oSection1:Cell("DULCOM")			:SetValue( "" )
	oSection1:Cell("NTPRZ")	 	   	    :SetValue( "" )
	oSection1:Cell("CTPPRZ")			:SetValue( "" )
	oSection1:Cell("NPRPED")	 	   	:Disable()
	oSection1:Cell("DPRPED")	 	   	:Disable("")
	oSection1:Cell("NSGPED")			:Disable()
	oSection1:Cell("DSGPED")			:Disable("")

	oSection1:PrintLine()  
	oSection1:Cell("NSUGES"):Enable() 

	*/
	ARQTRB->(dbCloseArea())

Return

/*_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-------------------------------------------------------------------------+¦¦
¦¦¦Função    ¦ ValidPerg   ¦ Autor ¦ 				    ¦ Data ¦ 15/04/2010 ¦¦¦
¦¦+----------+--------------------------------------------------------------+¦¦
¦¦¦Descriçào ¦ Grava as perguntas referente ao Relatorio                    ¦¦¦
¦¦¦          ¦                                                              ¦¦¦
¦¦+----------+--------------------------------------------------------------+¦¦
¦¦¦Uso       ¦                                                              ¦¦¦
¦¦+-------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidPerg()

	U_InPutSX1(cPerg, "01", "Produto De  ?","","","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01")
	U_InPutSX1(cPerg, "02", "Produto Ate ?","","","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02")
	U_InPutSX1(cPerg, "03", "Emissao De  ?","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03")
	U_InPutSX1(cPerg, "04", "Emissao Ate ?","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04")
	U_InPutSX1(cPerg, "05", "Grupo De    ?","","","mv_ch5","C",8,0,0,"G","","SBM","","","mv_par05")
	U_InPutSX1(cPerg, "06", "Grupo Até   ?","","","mv_ch6","C",8,0,0,"G","","SBM","","","mv_par06")

Return
