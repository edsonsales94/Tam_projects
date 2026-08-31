#include "rwmake.ch"                  

#include "topconn.ch"
#include "TOTVS.ch"

/*_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-------------------------------------------------------------------------+¦¦
¦¦¦Função    ¦ PELCOMR05 	¦ Autor ¦   ¦ Data ¦17/07/15                     ¦¦
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
User Function PLFINR22()
	Local oReport 	              // Objeto relatorio TReport
	Private cPerg := "PLFINR22" // Nome do grupo de perguntas
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
	Local cNomeRel 	 := "PLFINR22"           // Nome do relatorio
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


	TRCell():New( oSection1, "E2_FORNECE"    	, "", "Cod.Prod"			 	,, 15 , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "A2_NOME"   		, "", "Descricao"				,, 50 , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "E2_VALOR" 		, "", "Quantidade"      	    ,,  , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "MEDIA" 			, "", "Media"      	        	,,  , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "JANEIRO" 	    	, "", "Vlr.Janeiro"      	        ,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "FEVEREIRO"   		, "", "Vlr.Fevereiro"				,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)   
	TRCell():New( oSection1, "MARCO"   			, "", "Vlr.Março"					,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)   
	TRCell():New( oSection1, "ABRIL"  			, "", "Vlr.Abril"					,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)   
	TRCell():New( oSection1, "MAIO"   	 		, "", "Vlr.Maio"					,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)   
	TRCell():New( oSection1, "JUNHO"   			, "", "Vlr.Junho"					,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)   
	TRCell():New( oSection1, "JULHO"   			, "", "Vlr.Julho"					,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)   
	TRCell():New( oSection1, "AGOSTO"   		, "", "Vlr.Agosto"					,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)   
	TRCell():New( oSection1, "SETEMBRO"   		, "", "Vlr.Setembro"				,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)   
	TRCell():New( oSection1, "OUTUBRO"   		, "", "Vlr.Outubro"					,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "NOVEMBRO"    		, "", "Vlr.Novembro"				,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/)  
	TRCell():New( oSection1, "DEZEMBRO" 		, "", "Vlr.Dezembro"      	        ,"@E 999,999,999.99" ,  , .F., /*{|| code-block de impressao }*/) 
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



	_cQry:= " SELECT E2_FORNECE,A2_NOME,SUM(E2_VALOR)  E2_VALOR, SUM(MEDIA) MEDIA, "
	_cQry+= " SUM(ISNULL([01],0)) JANEIRO, "
	_cQry+= " SUM(ISNULL([02],0)) FEVEREIRO, "
	_cQry+= " SUM(ISNULL([03],0)) MARCO, "
	_cQry+= " SUM(ISNULL([04],0)) ABRIL, "
	_cQry+= " SUM(ISNULL([05],0)) MAIO, "
	_cQry+= " SUM(ISNULL([06],0)) JUNHO, "
	_cQry+= " SUM(ISNULL([07],0)) JULHO, "
	_cQry+= " SUM(ISNULL([08],0)) AGOSTO, "
	_cQry+= " SUM(ISNULL([09],0)) SETEMBRO, "
	_cQry+= " SUM(ISNULL([10],0)) OUTUBRO, "
	_cQry+= " SUM(ISNULL([11],0)) NOVEMBRO, "
	_cQry+= " SUM(ISNULL([12],0)) DEZEMBRO "
	_cQry+= " FROM ( "
	_cQry+= " SELECT E2_NUM,E2_PREFIXO,E2_PARCELA,E2_FORNECE,A2_NOME,SUM(E2_VALOR) E2_VALOR,SUM(E2_VALOR)/ (CAST(SUBSTRING('20191231',5,2) AS FLOAT)-CAST(SUBSTRING('20190101',5,2) AS FLOAT )+1) MEDIA,SUBSTRING(E2_VENCTO,5,2) E2_EMISSAO,SUM(E2_VALOR)TOTAL "
	_cQry+= " FROM "+RetSQLName("SE2")+" SE2 (NOLOCK) "
	_cQry+= " INNER JOIN "+RetSQLName("SA2")+" SA2 (NOLOCK) ON A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2.D_E_L_E_T_ = '' "
	_cQry+= " WHERE E2_VENCTO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	_cQry+= " AND SE2.D_E_L_E_T_ = '' "
	_cQry+= " GROUP BY E2_NUM,E2_PREFIXO,E2_PARCELA,E2_FORNECE,A2_NOME,E2_VENCTO,E2_VALOR "
	_cQry+= " )TB "
	_cQry+= " PIVOT( "
	_cQry+= " SUM(TOTAL) "
	_cQry+= " FOR [E2_EMISSAO] IN ([01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12]) "
	_cQry+= " )PV "
	_cQry+= " GROUP BY  E2_FORNECE,A2_NOME "
	_cQry+= " ORDER BY  E2_FORNECE "


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

		oSection1:Cell("E2_FORNECE")		  	:SetValue(ARQTRB->E2_FORNECE)  
		oSection1:Cell("A2_NOME" )				:SetValue(ARQTRB->A2_NOME)
		oSection1:Cell("E2_VALOR")			    :SetValue(ARQTRB->E2_VALOR)
		oSection1:Cell("MEDIA")	 	   			:SetValue(ARQTRB->MEDIA)
		oSection1:Cell("JANEIRO")			    :SetValue(ARQTRB->JANEIRO)
		oSection1:Cell("FEVEREIRO")	 	   		:SetValue(ARQTRB->FEVEREIRO )
		oSection1:Cell("MARCO")					:SetValue(ARQTRB->MARCO)
		oSection1:Cell("ABRIL")	 	   			:SetValue(ARQTRB->ABRIL)
		oSection1:Cell("MAIO")			    	:SetValue(ARQTRB->MAIO)
		oSection1:Cell("JUNHO")	 	   			:SetValue(ARQTRB->JUNHO)
		oSection1:Cell("JULHO")					:SetValue(ARQTRB->JULHO)
		oSection1:Cell("AGOSTO")	 	   		:SetValue(ARQTRB->AGOSTO)
		oSection1:Cell("SETEMBRO")				:SetValue(ARQTRB->SETEMBRO)
		oSection1:Cell("OUTUBRO")				:SetValue(ARQTRB->OUTUBRO)
		oSection1:Cell("NOVEMBRO")	 	   	    :SetValue(ARQTRB->NOVEMBRO)
		oSection1:Cell("DEZEMBRO")				:SetValue(ARQTRB->DEZEMBRO)

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

	U_InPutSX1(cPerg, "01", "Vencimento de ?",		"","","mv_ch1","D",8,0,0,"G","","","","","mv_par01")
	U_InPutSX1(cPerg, "02", "Vencimento Ate ?",		"","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")


Return
