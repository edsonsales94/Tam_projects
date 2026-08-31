#include "rwmake.ch"                  
#include "topconn.ch"

/*_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-------------------------------------------------------------------------+¦¦
¦¦¦Função    ¦ PELCOMR03 	¦ Autor ¦   ¦ Data ¦17/07/15                     ¦¦
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
User Function PELCOMR03()
	Local oReport 	              // Objeto relatorio TReport
	Private cPerg := "PELCOMR03" // Nome do grupo de perguntas
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
	Local cNomeRel 	 := "PELCOMR03"+cUserName             // Nome do relatorio
	Local cTitulo 	 := "Relatório Analise de Compras"   	    // Titulo do relatorio
	Local cDescri 	 := "Relatório Analise de Compras" 		// Descricao do relatorio
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

	oSection1 := TRSection():New( oReport , cCabec1 , {}, aOrdem )	// Dados da nota       
	oSection1:SetTotalInLine(.T.)      

	TRCell():New( oSection1, "CCOD"    , "", "Cod.Prod"			 	, "@!" , 15 , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "CDESC"   , "", "Descricao"			, "@!" , 16 , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "CTIPO" 	, "", "Tipo"      	        , "@!" , 02 , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "CGRUPO" 	, "", "Grupo"      	        , "@!" , 04 , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "CUM" 	    , "", "Um"      	        , "@!" , 02 , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "NSLATU"    , "", "Saldo Atual"			,"@E 999,999,999.99"   , 14 , .F., /*{|| code-block de impressao }*/)   
	TRCell():New( oSection1, "NVLATU"    , "", "Vlr. Atual"			,"@E 999,999,999.99"   , 14 , .F., /*{|| code-block de impressao }*/)   
	TRCell():New( oSection1, "NSALPED"    , "", "Sal.Ped"			,"@E 999,999,999.99"   , 14 , .F., /*{|| code-block de impressao }*/)   
	TRCell():New( oSection1, "NPPED"    , "", "P.Pedido"			,"@E 999,999,999.99"   , 14 , .F., /*{|| code-block de impressao }*/)   
	TRCell():New( oSection1, "NESSEG"    , "", "Est.Seg"			,"@E 999,999,999.99"   , 14 , .F., /*{|| code-block de impressao }*/)   
	TRCell():New( oSection1, "NMEDIA"    , "", "Med.Comp"			,"@E 999,999,999.99"   , 14 , .F., /*{|| code-block de impressao }*/)   
	TRCell():New( oSection1, "NSUGES"    , "", "Sug.Comp"			,"@E 999,999,999.99"   , 14 , .F., /*{|| code-block de impressao }*/)   
	TRCell():New( oSection1, "NULPRE"    , "", "Ult.Pre"			,"@E 999,999,999.99"   , 14 , .F., /*{|| code-block de impressao }*/)   
	TRCell():New( oSection1, "DULCOM"    , "", "Ref.Comp"			, "@!" , 08 , .F., /*{|| code-block de impressao }*/)
	TRCell():New( oSection1, "NTPRZ"    , "", "Prazo"			,"@E 99999"   , 5 , .F., /*{|| code-block de impressao }*/)  
	TRCell():New( oSection1, "CTPPRZ" 	    , "", "Tp.Prz"      	        , "@!" , 01 , .F., /*{|| code-block de impressao }*/) 
	TRCell():New( oSection1, "NPRPED"    , "", "Prx.Ped"			,"@E 999,999,999.99"   , 14 , .F., /*{|| code-block de impressao }*/)  
	TRCell():New( oSection1, "DPRPED"    , "", "Dt.Prx.Ped"			,"@!"   , 08 , .F., /*{|| code-block de impressao }*/)   
	TRCell():New( oSection1, "NSGPED"    , "", "Seg.Ped"			,"@E 999,999,999.99"   , 14 , .F., /*{|| code-block de impressao }*/) 
	TRCell():New( oSection1, "DSGPED"    , "", "Dt.Seg.Ped"			,"@!"   , 08 , .F., /*{|| code-block de impressao }*/)  

	oBreak := TRBreak():New(oSection1,{ || oSection1:Cell("CGRUPO"):uPrint },"SubTotal",.T.,"Total ")  

	TRFunction():New(oSection1:Cell( "NSUGES" ), " TOTAL ", "SUM" ,oBreak,"Total Sugestao","@E 999,999,999.99"   ,,.T.,.F.,.F.,,)       


	oBreak:Execute()

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

	_cQry:= " SELECT B1_COD,B1_DESC,B1_TIPO,B1_GRUPO,B1_UM,B2_QATU,B2_VATU1,B2_SALPEDI,B1_EMIN,B1_ESTSEG,B3_MEDIA,	 "
	_cQry+= " B3_MEDIA+ROUND( (B3_MEDIA/30)* 20 ,0) SUGESTAO,B1_UPRC,B1_UCOM,B1_PE,B1_TIPE"
	_cQry+= " ,ISNULL((SELECT TOP 1 C7_QUANT-C7_QUJE FROM "+ RetSQLName("SC7")+" WHERE C7_FILIAL='"+XFILIAL("SC7")+"' AND D_E_L_E_T_ = '' "
	_cQry+= " AND C7_PRODUTO = B1_COD AND C7_QUJE <> C7_QUANT AND C7_EMISSAO >='"+DTOS(MV_PAR07)+"' AND C7_EMISSAO <='"+DTOS(MV_PAR08)+"' "
	_cQry+= " AND C7_FORNECE >='"+MV_PAR09+"' AND C7_FORNECE<= '"+MV_PAR10+"' AND C7_LOJA >= '"+MV_PAR11+"' AND C7_LOJA <= '"+MV_PAR12+"' "
	_cQry+= " AND C7_RESIDUO <> 'S' AND C7_FILIAL = '"+XFILIAL("SC7")+"' ORDER BY R_E_C_N_O_  "
	_cQry+= " ),0) PRIMEIRA_ENTRADA "

	_cQry+= " ,ISNULL((SELECT TOP 1 C7_DATPRF FROM "+ RetSQLName("SC7")+" WHERE C7_FILIAL='"+XFILIAL("SC7")+"' AND D_E_L_E_T_ = '' "
	_cQry+= " AND C7_PRODUTO = B1_COD AND C7_QUJE <> C7_QUANT AND C7_EMISSAO >='"+DTOS(MV_PAR07)+"' AND C7_EMISSAO <='"+DTOS(MV_PAR08)+"' "
	_cQry+= " AND C7_FORNECE >='"+MV_PAR09+"' AND C7_FORNECE<= '"+MV_PAR10+"' AND C7_LOJA >= '"+MV_PAR11+"' AND C7_LOJA <= '"+MV_PAR12+"' "
	_cQry+= " AND C7_RESIDUO <> 'S' AND C7_FILIAL = '"+XFILIAL("SC7")+"' ORDER BY R_E_C_N_O_  "
	_cQry+= " ),'') DT_PRIMEIRA_ENTRADA "




	_cQry+= " ,ISNULL((SELECT TOP 1 C7_QUANT-C7_QUJE FROM "+RetSQLName("SC7")+" WHERE (R_E_C_N_O_ NOT IN (SELECT TOP 1 R_E_C_N_O_ "
	_cQry+= " FROM "+RetSQLName("SC7")+" WHERE " 
	_cQry+= " C7_FILIAL = '"+XFILIAL("SC7")+"' AND D_E_L_E_T_ = '' AND C7_PRODUTO = B1_COD "
	_cQry+= " AND C7_EMISSAO >='"+DTOS(MV_PAR07)+"' AND C7_EMISSAO <='"+DTOS(MV_PAR08)+"' "
	_cQry+= " AND C7_FORNECE >='"+MV_PAR09+"' AND C7_FORNECE<= '"+MV_PAR10+"' AND C7_LOJA >= '"+MV_PAR11+"' AND C7_LOJA <= '"+MV_PAR12+"' "
	_cQry+= " AND C7_FILIAL = '"+XFILIAL("SC7")+"' AND C7_QUJE <> C7_QUANT AND C7_RESIDUO <> 'S' "
	_cQry+= " ORDER BY R_E_C_N_O_ )) AND C7_FILIAL = '"+XFILIAL("SC7")+"' AND D_E_L_E_T_ = ''  "
	_cQry+= " AND C7_PRODUTO = B1_COD AND C7_FILIAL = '"+XFILIAL("SC7")+"' AND C7_QUJE <> C7_QUANT AND C7_RESIDUO <> 'S' "
	_cQry+= " AND C7_EMISSAO >='"+DTOS(MV_PAR07)+"' AND C7_EMISSAO <='"+DTOS(MV_PAR08)+"' "
	_cQry+= " AND C7_FORNECE >='"+MV_PAR09+"' AND C7_FORNECE<= '"+MV_PAR10+"' AND C7_LOJA >= '"+MV_PAR11+"' AND C7_LOJA <= '"+MV_PAR12+"' "
	_cQry+= " ORDER BY R_E_C_N_O_  ),0) SEGUNDA_ENTRADA



	_cQry+= " ,ISNULL((SELECT TOP 1 C7_DATPRF FROM "+RetSQLName("SC7")+" WHERE (R_E_C_N_O_ NOT IN (SELECT TOP 1 R_E_C_N_O_ "
	_cQry+= " FROM "+RetSQLName("SC7")+" WHERE " 
	_cQry+= " C7_FILIAL = '"+XFILIAL("SC7")+"' AND D_E_L_E_T_ = '' AND C7_PRODUTO = B1_COD "
	_cQry+= " AND C7_EMISSAO >='"+DTOS(MV_PAR07)+"' AND C7_EMISSAO <='"+DTOS(MV_PAR08)+"' "
	_cQry+= " AND C7_FORNECE >='"+MV_PAR09+"' AND C7_FORNECE<= '"+MV_PAR10+"' AND C7_LOJA >= '"+MV_PAR11+"' AND C7_LOJA <= '"+MV_PAR12+"' "
	_cQry+= " AND C7_FILIAL = '"+XFILIAL("SC7")+"' AND C7_QUJE <> C7_QUANT AND C7_RESIDUO <> 'S' "
	_cQry+= " ORDER BY R_E_C_N_O_ )) AND C7_FILIAL = '"+XFILIAL("SC7")+"' AND D_E_L_E_T_ = ''  "
	_cQry+= " AND C7_PRODUTO = B1_COD AND C7_FILIAL = '"+XFILIAL("SC7")+"' AND C7_QUJE <> C7_QUANT AND C7_RESIDUO <> 'S' "
	_cQry+= " AND C7_EMISSAO >='"+DTOS(MV_PAR07)+"' AND C7_EMISSAO <='"+DTOS(MV_PAR08)+"' "
	_cQry+= " AND C7_FORNECE >='"+MV_PAR09+"' AND C7_FORNECE<= '"+MV_PAR10+"' AND C7_LOJA >= '"+MV_PAR11+"' AND C7_LOJA <= '"+MV_PAR12+"' "
	_cQry+= " ORDER BY R_E_C_N_O_  ),'') DT_SEGUNDA_ENTRADA



	_cQry+= " FROM "+RetSQLName("SB1")+" A INNER JOIN "+RetSQLName("SB2")+" B ON A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' "
	_cQry+= " INNER JOIN "+RetSQLName("SB3")+" C ON C.D_E_L_E_T_ = '' AND B3_COD = B2_COD AND B1_COD = B2_COD AND B1_FILIAL = '"+XFILIAL("SB1")+"' "
	_cQry+= " AND B3_FILIAL= '"+XFILIAL("SB3")+"' AND B2_FILIAL = '"+XFILIAL("SB2")+"' AND B2_LOCAL = '01' AND B2_QATU <> 0 AND B1_MSBLQL = '2'
	_cQry+= " AND B1_COD >= '"+MV_PAR01+"' AND B1_COD <= '"+MV_PAR02+"'"
	_cQry+= " AND B1_GRUPO >= '"+MV_PAR03+"' AND B1_GRUPO <= '"+MV_PAR04+"' "
	_cQry+= " AND B1_TIPO >= '"+MV_PAR05+"' AND B1_TIPO <= '"+MV_PAR06+"' "
	_cQry+= " ORDER BY B1_COD "

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

		oSection1:Cell("CCOD")		  	    :SetValue( ARQTRB->B1_COD)  
		oSection1:Cell("CDESC" )			:SetValue( ARQTRB->B1_DESC)
		oSection1:Cell("CTIPO")			    :SetValue( ARQTRB->B1_TIPO)
		oSection1:Cell("CGRUPO")	 	   	:SetValue( ARQTRB->B1_GRUPO )
		oSection1:Cell("CUM")			    :SetValue( ARQTRB->B1_UM)
		oSection1:Cell("NSLATU")	 	   	:SetValue( ARQTRB->B2_QATU )
		oSection1:Cell("NVLATU")			:SetValue( ARQTRB->B2_VATU1)
		oSection1:Cell("NSALPED")	 	   	:SetValue( ARQTRB->B2_SALPEDI )
		oSection1:Cell("NPPED")			    :SetValue( ARQTRB->B1_EMIN)
		oSection1:Cell("NESSEG")	 	   	:SetValue( ARQTRB->B1_ESTSEG )
		oSection1:Cell("NMEDIA")			:SetValue( ARQTRB->B3_MEDIA)
		oSection1:Cell("NSUGES")	 	   	:SetValue( ARQTRB->SUGESTAO )
		oSection1:Cell("NULPRE")			:SetValue( ARQTRB->B1_UPRC)
		oSection1:Cell("DULCOM")			:SetValue( STOD(ARQTRB->B1_UCOM))
		oSection1:Cell("NTPRZ")	 	   	    :SetValue( ARQTRB->B1_PE )
		oSection1:Cell("CTPPRZ")			:SetValue( ARQTRB->B1_TIPE)
		oSection1:Cell("NPRPED")	 	   	:SetValue( ARQTRB->PRIMEIRA_ENTRADA )
		oSection1:Cell("DPRPED")	 	   	:SetValue( STOD(ARQTRB->DT_PRIMEIRA_ENTRADA) )
		oSection1:Cell("NSGPED")			:SetValue( ARQTRB->SEGUNDA_ENTRADA)
		oSection1:Cell("DSGPED")			:SetValue( STOD(ARQTRB->DT_SEGUNDA_ENTRADA))

		oSection1:PrintLine()  
		//oSection1:SetHeaderSection(.T.)

		oReport:IncMeter()

		ARQTRB->(DbSkip(1))

	EndDo     

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

	u_InPutSx1(cPerg, "01", "Produto de",		"","","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01")
	u_InPutSx1(cPerg, "02", "Produto Ate",		"","","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02")
	u_InPutSX1(cPerg, "03", "Grupo de",			"","","mv_ch3","C",04,0,0,"G","","SBM","","","mv_par03")
	u_InPutSX1(cPerg, "04", "Grupo Ate",		"","","mv_ch4","C",04,0,0,"G","","SBM","","","mv_par04")
	u_InPutSX1(cPerg, "05", "Tipo de",			"","","mv_ch5","C",02,0,0,"G","","02",	"","","mv_par05")
	u_InPutSX1(cPerg, "06", "Tipo Ate",			"","","mv_ch6","C",02,0,0,"G","","02",	"","","mv_par06")
	u_InPutSX1(cPerg, "07",PADR("Emissao Pedido De?" ,16) ,"","","mv_ch7","D",08,0,0,"G","","","","","mv_par07")
	u_InPutSX1(cPerg, "08",PADR("Emissao Pedido Ate?",16) ,"","","mv_ch8","D",08,0,0,"G","","","","","mv_par08")
	u_InPutSx1(cPerg, "09", "Fornecedor de",		"","","mv_ch9","C",06,0,0,"G","","SA2","","","mv_par09")
	u_InPutSx1(cPerg, "10", "Fornecedor Ate",		"","","mv_chA","C",06,0,0,"G","","SA2","","","mv_par10")
	u_InPutSX1(cPerg, "11", "Loja de",			"","","mv_chB","C",02,0,0,"G","","","","","mv_par11")
	u_InPutSX1(cPerg, "12", "Loja Ate",			"","","mv_chC","C",02,0,0,"G","","","","","mv_par12")

Return
