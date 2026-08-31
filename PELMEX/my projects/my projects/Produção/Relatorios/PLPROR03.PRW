#include "rwmake.ch"

#include "topconn.ch"
#include "TOTVS.ch"

/*_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-------------------------------------------------------------------------+¦¦
¦¦¦Função    ¦ PLPROR03 	¦ Autor ¦   ¦ Data ¦17/07/15                     ¦¦
¦¦+----------+--------------------------------------------------------------+¦¦
¦¦¦Descrição ¦ Relatório - Analise Compras                      		    ¦¦¦
¦¦¦          ¦                                                              ¦¦¦
¦¦+----------+--------------------------------------------------'-----------+¦¦
¦¦¦Parametros¦	                                        	     		    ¦¦¦
¦¦¦          ¦                                                              ¦¦¦
¦¦+----------+--------------------------------------------------------------+¦¦
¦¦¦Uso       ¦                                                              ¦¦¦
¦¦+----------------------------------- --------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLPROR03()
	Local oReport 	              // Objeto relatorio TReport
	Private cPerg := "PLPROR03" // Nome do grupo de perguntas
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
	Local cNomeRel 	 := "PLPROR03"           // Nome do relatorio
	Local cTitulo 	 := "Relatório Custo por Mes"   	    // Titulo do relatorio
	Local cDescri 	 := "Relatório Custo por Mes" 		// Descricao do relatorio
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

	TRCell():New( oSection1, "CLA_USERINC"    					, "", "Matricula"			 			,, 15 , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "RA_NOME"   						, "", "Nome"							,, 50 , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "TOTAL_PERIODO" 					, "", "Total"      	    				,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "COLCHAO_MOLA_PROBEL" 				, "", "COLCHAO MOLA PROBEL"      	    ,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "COLCHAO_MOLA_PELMEX" 	    		, "", "COLCHAO MOLA PELMEX"      	    ,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "COLCHAO_MOLA_SONOFLEX"   			, "", "COLCHAO MOLA SONOFLEX"			,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "COLCHAO_ESPUMA_PROBEL"   			, "", "COLCHAO ESPUMA PROBEL"			,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "COLCHAO_ESPUMA_PELMEX"  			, "", "COLCHAO ESPUMA PELMEX"			,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "COLCHAO_ESPUMA_SONOFLEX"   	 	, "", "COLCHAO ESPUMA SONOFLEX"			,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "CAMA_BOX_ACOPLADA_PROBEL"   		, "", "CAMA BOX ACOPLADA PROBEL"		,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "CAMA_BOX_ACOPLADA_PELMEX"   		, "", "CAMA BOX ACOPLADA PELMEX"		,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "CAMA_BOX_ACOPLADA_SONOFLEX"   	, "", "CAMA BOX ACOPLADA SONOFLEX"		,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "COLCHAO_ESPUMA_PELMEX_M_ESP"   	, "", "COLCHAO ESPUMA PELMEX M. ESP."	,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)
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

	/*
	TRFunction():New(oSection1:Cell( "JANEIRO" ),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "FEVEREIRO" ),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "MARCO" ),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "ABRIL" ),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "MAIO" ),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "JUNHO" ),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "JULHO" ),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "AGOSTO" ),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "SETEMBRO" ),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "OUTUBRO" ),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "NOVEMBRO" ),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection1:Cell( "DEZEMBRO" ),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	*/
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

	_cQry:= "SELECT * "
	_cQry+= "   FROM("
	_cQry+= "   SELECT PV.CLA_USERINC,PV.RA_NOME,"
	_cQry+= "   ISNULL(SUM([COLCHAO MOLA PROBEL]),0)+"
	_cQry+= "   ISNULL(SUM([COLCHAO MOLA PELMEX]),0)+"
	_cQry+= "   ISNULL(SUM([COLCHAO MOLA SONOFLEX]),0)+"
	_cQry+= "   ISNULL(SUM([COLCHAO ESPUMA PROBEL]),0)+"
	_cQry+= "   ISNULL(SUM([COLCHAO ESPUMA PELMEX]),0)+"
	_cQry+= "   ISNULL(SUM([COLCHAO ESPUMA SONOFLEX]),0)+"
	_cQry+= "   ISNULL(SUM([CAMA BOX ACOPLADA PROBEL]),0)+"
	_cQry+= "   ISNULL(SUM([CAMA BOX ACOPLADA PELMEX]),0)+"
	_cQry+= "   ISNULL(SUM([CAMA BOX ACOPLADA SONOFLEX]),0)+"
	_cQry+= "   ISNULL(SUM([COLCHAO ESPUMA PELMEX M. ESP.]),0) TOTAL_PERIODO, "
	_cQry+= "   ISNULL(SUM([COLCHAO MOLA PROBEL]),0)COLCHAO_MOLA_PROBEL, "
	_cQry+= "   ISNULL(SUM([COLCHAO MOLA PELMEX]),0)COLCHAO_MOLA_PELMEX, "
	_cQry+= "   ISNULL(SUM([COLCHAO MOLA SONOFLEX]),0)COLCHAO_MOLA_SONOFLEX, "
	_cQry+= "   ISNULL(SUM([COLCHAO ESPUMA PROBEL]),0)COLCHAO_ESPUMA_PROBEL, "
	_cQry+= "   ISNULL(SUM([COLCHAO ESPUMA PELMEX]),0)COLCHAO_ESPUMA_PELMEX, "
	_cQry+= "   ISNULL(SUM([COLCHAO ESPUMA SONOFLEX]),0)COLCHAO_ESPUMA_SONOFLEX, "
	_cQry+= "   ISNULL(SUM([CAMA BOX ACOPLADA PROBEL]),0)CAMA_BOX_ACOPLADA_PROBEL, "
	_cQry+= "   ISNULL(SUM([CAMA BOX ACOPLADA PELMEX]),0)CAMA_BOX_ACOPLADA_PELMEX, "
	_cQry+= "   ISNULL(SUM([CAMA BOX ACOPLADA SONOFLEX]),0)CAMA_BOX_ACOPLADA_SONOFLEX, "
	_cQry+= "   ISNULL(SUM([COLCHAO ESPUMA PELMEX M. ESP.]),0)COLCHAO_ESPUMA_PELMEX_M_ESP "
	_cQry+= "   FROM("
	_cQry+= "   SELECT CLA_USERINC,RA_NOME,B1_GRUPO,BM_DESC,SUM(CLA_QUANT)CLA_QUANT"
	_cQry+= "   FROM CLA"
	_cQry+= "   INNER JOIN SB1100 SB1 ON CLA_COD = B1_COD AND SB1.D_E_L_E_T_ = ''"
	_cQry+= "   INNER JOIN SBM100 SBM ON B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = ''"
	_cQry+= "   INNER JOIN SRA100 SRA ON CLA_FILIAL = RA_FILIAL AND CLA_USERINC = RA_MAT AND SRA.D_E_L_E_T_ = ''"
	_cQry+= "   WHERE CONVERT(VARCHAR,CAST(CLA_DATINC AS DATE),112) BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	_cQry+= "   GROUP BY CLA_USERINC,RA_NOME,B1_GRUPO,BM_DESC"
	_cQry+= "   )TB"
	_cQry+= "   PIVOT  (SUM(CLA_QUANT)"
	_cQry+= "   FOR BM_DESC IN ([COLCHAO MOLA PROBEL], [COLCHAO MOLA PELMEX], [COLCHAO MOLA SONOFLEX],"
	_cQry+= "   [COLCHAO ESPUMA PROBEL], [COLCHAO ESPUMA PELMEX], [COLCHAO ESPUMA SONOFLEX],"
	_cQry+= "   [CAMA BOX ACOPLADA PROBEL] ,[CAMA BOX ACOPLADA PELMEX], [CAMA BOX ACOPLADA SONOFLEX],"
	_cQry+= "   [COLCHAO ESPUMA PELMEX M. ESP.])"
	_cQry+= "   ) AS PV"
	_cQry+= "   GROUP BY PV.CLA_USERINC,PV.RA_NOME"
	_cQry+= "   )TB1"
	_cQry+= "   ORDER BY TB1.TOTAL_PERIODO DESC"

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

		oSection1:Cell("CLA_USERINC")		  	    				:SetValue(ARQTRB->CLA_USERINC)
		oSection1:Cell("RA_NOME" )									:SetValue(ARQTRB->RA_NOME)
		oSection1:Cell("TOTAL_PERIODO")			    				:SetValue(ARQTRB->TOTAL_PERIODO)
		oSection1:Cell("COLCHAO_MOLA_PROBEL")	 	   				:SetValue(ARQTRB->COLCHAO_MOLA_PROBEL)
		oSection1:Cell("COLCHAO_MOLA_PELMEX")			    		:SetValue(ARQTRB->COLCHAO_MOLA_PELMEX)
		oSection1:Cell("COLCHAO_MOLA_SONOFLEX")	 	   				:SetValue(ARQTRB->COLCHAO_MOLA_SONOFLEX)
		oSection1:Cell("COLCHAO_ESPUMA_PROBEL")						:SetValue(ARQTRB->COLCHAO_ESPUMA_PROBEL)
		oSection1:Cell("COLCHAO_ESPUMA_PELMEX")	 	   				:SetValue(ARQTRB->COLCHAO_ESPUMA_PELMEX)
		oSection1:Cell("COLCHAO_ESPUMA_SONOFLEX")			    	:SetValue(ARQTRB->COLCHAO_ESPUMA_SONOFLEX)
		oSection1:Cell("CAMA_BOX_ACOPLADA_PROBEL")	 	   			:SetValue(ARQTRB->CAMA_BOX_ACOPLADA_PROBEL)
		oSection1:Cell("CAMA_BOX_ACOPLADA_PELMEX")					:SetValue(ARQTRB->CAMA_BOX_ACOPLADA_PELMEX)
		oSection1:Cell("CAMA_BOX_ACOPLADA_SONOFLEX")	 	   		:SetValue(ARQTRB->CAMA_BOX_ACOPLADA_SONOFLEX)
		oSection1:Cell("COLCHAO_ESPUMA_PELMEX_M_ESP")				:SetValue(ARQTRB->COLCHAO_ESPUMA_PELMEX_M_ESP)

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

	u_InPutSX1(cPerg,"01",PADR("Emissão De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Emissão Até   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")

Return
