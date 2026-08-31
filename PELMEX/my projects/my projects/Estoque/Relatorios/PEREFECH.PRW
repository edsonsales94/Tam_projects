#include "rwmake.ch"                  
#include "topconn.ch"

/*_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-------------------------------------------------------------------------+¦¦
¦¦¦Função    ¦ PEREFECH 	¦ Autor ¦   ¦ Data ¦PEREFECH                     ¦¦
¦¦+----------+--------------------------------------------------------------+¦¦
¦¦¦Descrição ¦ Relatório - Diferenças Fechamento Custo Médio       		    ¦¦¦
¦¦¦          ¦                                                              ¦¦¦
¦¦+----------+--------------------------------------------------'-----------+¦¦
¦¦¦Parametros¦	                                        	     		    ¦¦¦
¦¦¦          ¦                                                              ¦¦¦
¦¦+----------+--------------------------------------------------------------+¦¦
¦¦¦Uso       ¦                                                              ¦¦¦
¦¦+----------------------------------- --------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PEREFECH()
Local oReport 	              // Objeto relatorio TReport
Private _cQrbPag:= ""



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
Local cNomeRel 	 := "PEREFECH"+cUserName             // Nome do relatorio
Local cTitulo 	 := "Relatório Diferenças Fechamento "   	    // Titulo do relatorio
Local cDescri 	 := "Relatório Diferenças Fechamento " 		// Descricao do relatorio
Local aOrdem	 := {}							    	   	        // Ordem de impressao do relatorio
Local cCabec1    := "Relatório "



/*========================================
| Cria o Objeto de impressao             |
========================================*/
oReport := TReport():New(cNomeRel, cTitulo, "", {|oReport| RunReport(oReport)}, cDescri)

/*========================================
| Define o tamanho da fonte.             |
========================================*/
oReport:nFontBody	:= 10

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
   
oSection1 := TRSection():New( oReport , cCabec1 , {}, aOrdem )	// Dados    
oSection1:SetTotalInLine(.T.)      
 //DISTINCT B2_FILIAL AS FILIAL,B2_COD AS CODIGO,B1_DESC AS DESCRICAO,B1_TIPO AS TIPO,B2_LOCAL AS ARMAZEM,B2_QFIM AS QTD_FIM,B2_VFIM1 AS VLR_FIM                  

TRCell():New( oSection1, "FILIAL"    	, "", "Filial"			,"@!"   , 02 , .F., /*{|| code-block de impressao }*/)   
TRCell():New( oSection1, "CODIGO"    	, "", "Codigo"			,"@!"   , 15 , .F., /*{|| code-block de impressao }*/)   
TRCell():New( oSection1, "DESCRICAO"    , "", "Descricao"		,"@!"   , 30 , .F., /*{|| code-block de impressao }*/)   
TRCell():New( oSection1, "TIPO"    		, "", "Tipo"			,"@!"   , 02 , .F., /*{|| code-block de impressao }*/)   
TRCell():New( oSection1, "ARMAZEM"	    , "", "Armazem"			,"@!"   , 02 , .F., /*{|| code-block de impressao }*/)   
TRCell():New( oSection1, "QTD_FIM" 	 	, "", "Qtd.Fim"			,"@E 999,999,999.9999"   , 14 , .F., /*{|| code-block de impressao }*/)   
TRCell():New( oSection1, "VLR_FIM"	   	, "", "Vlr.Fim"			,"@E 999,999,999.9999"   , 14 , .F., /*{|| code-block de impressao }*/)   
//oBreak := TRBreak():New(oSection1,{ || oSection1:Cell("VLR_FIM"):uPrint },"SubTotal",.T.,"Total ")  

//TRFunction():New(oSection1:Cell( "VLR_FIM" ), " TOTAL ", "SUM" ,oBreak,"Total","@E 999,999,999.99"   ,,.T.,.F.,.F.,,)       


//oBreak:Execute()

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

_cQry:= " SELECT DISTINCT B2_FILIAL AS FILIAL,B2_COD AS CODIGO,B1_DESC AS DESCRICAO,B1_TIPO AS TIPO,B2_LOCAL AS ARMAZEM,B2_QFIM AS QTD_FIM,B2_VFIM1 AS VLR_FIM "  
_cQry+= " FROM (
_cQry+= " SELECT * FROM "+ RetSQLName("SB2") + "  "
_cQry+= " WHERE D_E_L_E_T_=  ''
_cQry+= " AND B2_QFIM > 0
_cQry+= " AND B2_VFIM1  < =0
_cQry+= " UNION ALL
_cQry+= " SELECT * FROM "+ RetSQLName("SB2") + "  "
_cQry+= " WHERE D_E_L_E_T_ = ''
_cQry+= " AND B2_QFIM <= 0
_cQry+= " AND B2_VFIM1 <> 0
_cQry+= " UNION ALL
_cQry+= " SELECT * FROM "+ RetSQLName("SB2") + "  "
_cQry+= " WHERE D_E_L_E_T_ = ''
_cQry+= " AND B2_QFIM < 0
_cQry+= " UNION ALL
_cQry+= " SELECT * FROM "+ RetSQLName("SB2") + "  "
_cQry+= " WHERE D_E_L_E_T_ = ''
_cQry+= " AND B2_VFIM1 < 0
_cQry+= " ) AS B2_MOVIMENTOS
_cQry+= " INNER JOIN "+ RetSQLName("SB1") + " SB1 "
_cQry+= " ON B1_COD = B2_COD
//_cQry+= " AND B1_FILIAL = B2_FILIAL
_cQry+= " AND SB1.D_E_L_E_T_ = ''
_cQry+= " WHERE SUBSTRING(B2_COD,1,3) NOT IN ('MOD','MDO')


TCQUERY ChangeQuery(_cQry) New Alias "ARQTRB"


/*===================================================
|    Seta o Tamanho da regua                        |
===================================================*/
oReport:SetMeter( ARQTRB->(RecCount()) )

_lLp := .T.

ARQTRB->(DbGotop())
While !ARQTRB->(Eof()) .And. !oReport:Cancel()
	
	oSection1:Init()               
	





	oSection1:Cell("FILIAL")		  	:SetValue( ARQTRB->FILIAL)  
	oSection1:Cell("CODIGO" )			:SetValue( ARQTRB->CODIGO)
	oSection1:Cell("DESCRICAO")			    :SetValue( ARQTRB->DESCRICAO)
	oSection1:Cell("TIPO")	 	   	:SetValue( ARQTRB->TIPO )
	oSection1:Cell("ARMAZEM")			    	:SetValue( ARQTRB->ARMAZEM )
	oSection1:Cell("QTD_FIM")			   	:SetValue( ARQTRB->QTD_FIM )
	oSection1:Cell("VLR_FIM")			   	:SetValue( ARQTRB->VLR_FIM )
	 
	


	                                                
	oSection1:PrintLine()  
	//oSection1:SetHeaderSection(.T.)
	
	oReport:IncMeter()
	
	ARQTRB->(DbSkip(1))
	
EndDo     

	oSection1:Cell("FILIAL" )			   :SetValue( "" ) 
	oSection1:Cell("DESCRICAO")	                     :SetValue( "" ) 
	oSection1:Cell("CODIGO")	                     :SetValue( "" ) 
	oSection1:Cell("TIPO")	 	               :SetValue( "" ) 
	oSection1:Cell("ARMAZEM")		        :SetValue( "" ) 
	oSection1:Cell("QTD_FIM")		  	         :Disable()
	oSection1:Cell("VLR_FIM")		  	         :Disable()
	
	 
oSection1:PrintLine()  
oSection1:Cell("QTD_FIM"):Enable() 
oSection1:Cell("VLR_FIM"):Enable() 

ARQTRB->(dbCloseArea())

Return

