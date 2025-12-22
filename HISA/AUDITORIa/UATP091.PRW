// #INCLUDE "fivewin.ch"
#INCLUDE "rwmake.ch"   
#INCLUDE "TOPCONN.CH"                                                                            
#INCLUDE "ExcelCLS.ch"

#DEFINE FOLDER_PRODUTO "P"
#DEFINE FOLDER_NOTA    "N"
#DEFINE FOLDER_PO	   "O"           

#DEFINE TP_FOLDER FOLDER_PRODUTO+FOLDER_NOTA+FOLDER_PO
                                
#DEFINE ITEM_ARQ_FOLDER	  1
#DEFINE ITEM_ARQ_ALIAS	  2
#DEFINE ITEM_ARQ_FILENAME 3

#DEFINE BM_NONE  0
#DEFINE BM_TOT1  1
#DEFINE BM_TOT2  2
#DEFINE BM_TOT3  4

#DEFINE BM_BIT_NONE  0
#DEFINE BM_BIT_TOT1  1
#DEFINE BM_BIT_TOT2  2
#DEFINE BM_BIT_TOT3  3

/*=========================================================================\
|Funcao    | UATP091            | Flávia Rocha          | Data | 06/07/15  |
============================================================================
|Descricao | Relatório Estoque em Dólar									   |
|	       | 												   			   |
|          |                                                               |
============================================================================
|Observações: Gera planilha excel dos Saldos em Estoque x NFs Importação   |
|																		   |
\=========================================================================*/
User Function UATP091
	Local _nOpca	:= 0
	Local _aSays    := {}
	Local _aButtons := {}   
	Local _cPerg    := "UTP091"
	
	Private cCadastro:= "Geração da Planilha Estoque em US$"
	Private xTabNvNPE:= {|cVar,bFiltro| GetTabNPE(cVar) }
	
	If !u_ChkFunc(Replace(ProcName(),"U_",""),,,,'a '+cCadastro)
		Return
	EndIf
	
	//Configura e Inicializa a rotina	
	ConfPergs(_cPerg)
		
	pergunte(_cPerg,.T.)
	
	aAdd(_aSays," Este programa tem como objetivo gerar planilha excel com os saldos em estoque " )
	aAdd(_aSays," versus NFs entrada Importação, compondo o saldo com as Entradas e demonstrando" )
	aAdd(_aSays," valores e Taxas Dólar utilizadas.")
	aAdd(_aButtons, { 5,.T.,{|| Pergunte(_cPerg,.T.) } } )
	aAdd(_aButtons, { 1,.T.,{|o| _nOpca:=1, o:oWnd:End() } } )
	aAdd(_aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	
	Do While .T.
		_nOpca := 0
		
		FormBatch( cCadastro, _aSays, _aButtons )
	             
		Do Case
			Case _nOpcA == 1
				If GeraExcel()
					Exit
				Endif
			OtherWise
				Exit
		EndCase
	EndDo
	
Return                   

/*==============================================================+
| Parametros												   	|
+---------------------------------------------------------------+
|MV_PAR01 - Filiais												|
|MV_PAR02 - Mostra Saldos                                       |
|MV_PAR03 - Seleção de Abas                                     |
|MV_PAR04 - Nome do Arquivo                                     |
|MV_PAR05 - Diretório Destino                                   |
|MV_PAR06 - Executa MS Excel                                    |
+==============================================================*/

/*=========================================================================\
|Funcao    | GeraExcel          | Flavia Rocha          | Data | 06/07/15  |
============================================================================
|Descricao | Executa a geração da planilha excel						   |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
Static Function GeraExcel   
	Local _lRet
	Local _cFile
	Local _cFolders
	Local _cItemCCDe
	Local _cItemCCAte
	Local _cSrvPath
	Local _cRmtPath
	Local _cFiliais
	Local _lAudit
	Local _dDataUso
	
	_cFiliais  	:= AllTrim(mv_par01)
	_lAudit  	:= ( mv_par02==1 )         
	_cFolders	:= Alltrim(mv_par03)
	_cItemCCDe	:= Alltrim(mv_par04)
	_cItemCCAte := Alltrim(mv_par05)
	_cFile 		:= AllTrim(mv_par06)
	_cRmtPath 	:= AllTrim(mv_par07)
	_dDataUso	:= dDatabase
	
	If Empty(_cFolders)
		Alert("Favor Preencher a Pergunta: 'Seleção de Abas'")
		Return .F.
	EndIf	
	
	If Empty(_cFile)
		_cFile := "Estoque em Dolar "
		_cFile += GetDescFil(_cFiliais)
		_cFile := U_ToFName(_cFile)
	EndIf
	
	If !U_ChkFiliais(_cFiliais,.F.)
		Return .F.	
	EndIf         
	
	If !U_ChkFName(_cFile)
		Return .F.	
	EndIf
			
	If !U_ChkPName(_cRmtPath,2,.T.)
		Return .F.	
	EndIf                            
		
	_cFile += ".xls"
		
	If Right(_cRmtPath,1) != "\"
	  _cRmtPath += "\"
	EndIf
		
	_cSrvPath := "/relato/"
		
	_lRet := CriaXLS(_cFiliais,_cFile,_cSrvPath,@_cRmtPath,_cFolders,_dDataUso,_cItemCCDe,_cItemCCAte,_lAudit)
	
	If _lRet
		If mv_par08==1
			_lRet := U_OpenXLSFile(_cRmtPath+_cfile)
		Else 
			Aviso( 'Atenção!', "Arquivo excel ["+_cfile+"] criado com sucesso no diretório ["+_cRmtPath+"]!", {'ok'} )
		EndIf
	EndIf     
	
Return _lRet	

/*=========================================================================\
|Funcao    | DefWrkSht          | Flavia Rocha          | Data | 06/07/15  |
============================================================================
|Descricao | Define as colunas da planilha								   |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
Static Function DefWrkSht(_cFiliais,_aArq,_dDataUso,_lAudit)
	Local aWrkSht := {}
	Local _cDescFil
	Local nCt
	Local _cFolder

	_cDescFil  	:= GetDescFil(_cFiliais)
	
	For nCt:=1 To Len(_aArq)
		_cFolder := _aArq[nCt][ITEM_ARQ_FOLDER]  

		Do Case
			Case _cFolder == FOLDER_PRODUTO
				AAdd(aWrkSht,WrkShtPrd(_aArq[nCt][ITEM_ARQ_ALIAS],_cDescFil,_dDataUso,_lAudit))
			Case _cFolder == FOLDER_NOTA
				AAdd(aWrkSht,WrkShtNFe(_aArq[nCt][ITEM_ARQ_ALIAS],_cDescFil,_dDataUso))
			Case _cFolder == FOLDER_PO
				AAdd(aWrkSht,WrkShtPO(_aArq[nCt][ITEM_ARQ_ALIAS],_cDescFil,_dDataUso))
		End Case
	Next     

Return aWrkSht   

Static Function MontWrkSht( _dDatauso,_cTitulo,_cAlias,_cDescFil,_aDefCols,_cTab,cHeader,nRowFreeze,nHeightHdr,;
							nHeightRow,nHeaders,cPgHeader,cPgFooter,nPgOrienta,nPrtScale,;
							nMgrHeader,nMgrFooter,nPgTop,nPgBottom,nPgLeft,nPgRight,lHidden,;
							cLinRepSup,cColRepEsq,nStyles,nColFreeze)
	Local aDefWrkSht := {} 
                                
	Default nRowFreeze  := 4
	Default nHeaders    := 2
	Default nPgOrienta  := XLS_PAGE_LANDSCAPE
	Default nPrtScale	:= 100
	Default nMgrHeader 	:= 0.5
	Default nMgrFooter	:= 0.3
	Default nPgTop		:= 1
	Default nPgBottom	:= 0.5
	Default nPgLeft 	:= 1.2
	Default nPgRight	:= 1.2            
	Default cLinRepSup  := "R3:R4"
	Default cColRepEsq  := "C1:C4"

	AAdd(aDefWrkSht,_cTitulo)
	AAdd(aDefWrkSht,_cAlias)                          
	AAdd(aDefWrkSht,_cDescFil)
	AAdd(aDefWrkSht,_aDefCols)
	AAdd(aDefWrkSht,_cTab)
	AAdd(aDefWrkSht,cHeader)
	AAdd(aDefWrkSht,nRowFreeze)
	AAdd(aDefWrkSht,nHeightHdr)
	AAdd(aDefWrkSht,nHeightRow)
	AAdd(aDefWrkSht,nHeaders)
	AAdd(aDefWrkSht,cPgHeader)
	AAdd(aDefWrkSht,cPgFooter)
	AAdd(aDefWrkSht,nPgOrienta)
	AAdd(aDefWrkSht,nPrtScale)
	AAdd(aDefWrkSht,nMgrHeader)
	AAdd(aDefWrkSht,nMgrFooter)
	AAdd(aDefWrkSht,nPgTop)
	AAdd(aDefWrkSht,nPgBottom)
	AAdd(aDefWrkSht,nPgLeft)
	AAdd(aDefWrkSht,nPgRight)
	AAdd(aDefWrkSht,lHidden)
	AAdd(aDefWrkSht,cLinRepSup)
	AAdd(aDefWrkSht,cColRepEsq)
	AAdd(aDefWrkSht,nStyles)
	AAdd(aDefWrkSht,nColFreeze)
	Aadd(aDefWrkSht,_dDataUso)

Return aDefWrkSht

Static Function WrkShtPrd(_cAlias,_cDescFil,_dDataUso,_lAudit)
	Local _cPgHeader
	Local _cNameWrk
	Local _cTitulo   

	_cNameWrk  := "Produto" 

	_cTitulo   := "Estoque em Dolar - "+_cNameWrk

	_cPgHeader := "&amp;L"+U_OemToUTF8(_cTitulo)
	_cPgHeader += "&amp;C"
	_cPgHeader += _cDescFil + " - " + GetDtDesc(_dDataUso) 
	//_cPgHeader += " " + GetDtDesc(_dDataUso, _dDataUso) 
	_cPgHeader += "&amp;RPagina &amp;P de &amp;N"    

Return MontWrkSht( _dDataUso, _cTitulo,_cAlias,_cDescFil,DefColsPrd(_lAudit),FOLDER_PRODUTO,_cNameWrk,,,,,_cPgHeader)	

Static Function WrkShtNfe(_cAlias,_cDescFil,_dDataUso)
	Local _cPgHeader
	Local _cNameWrk
	Local _cTitulo 

	_cNameWrk  := "Notas" 

	_cTitulo   := "Estoque em Dolar - "+_cNameWrk

	_cPgHeader := "&amp;L"+U_OemToUTF8(_cTitulo)
	_cPgHeader += "&amp;C"
	_cPgHeader += _cDescFil + " - " + GetDtDesc(_dDataUso) 
	_cPgHeader += "&amp;RPagina &amp;P de &amp;N"
	
Return MontWrkSht( _dDataUso, _cTitulo,_cAlias,_cDescFil,DefColsNFe(),FOLDER_NOTA,_cNameWrk,,,,,_cPgHeader)	

Static Function WrkShtPO(_cAlias,_cDescFil,_dDataUso)
	Local _cPgHeader
	Local _cNameWrk
	Local _cTitulo

	_cNameWrk  := "PO" 

	_cTitulo   := "Estoque em Dolar - "+_cNameWrk

	_cPgHeader := "&amp;L"+U_OemToUTF8(_cTitulo)
	_cPgHeader += "&amp;C"
	_cPgHeader += _cDescFil + " - " + GetDtDesc(_dDataUso) 
	_cPgHeader += "&amp;RPagina &amp;P de &amp;N"
	
Return MontWrkSht( _dDataUso, _cTitulo,_cAlias,_cDescFil,DefColsPO(),FOLDER_PO,_cNameWrk,,,,,_cPgHeader)	
	
/*=========================================================================\
|Funcao    | DefCols            | Flavia  Rocha      | Data | 06/07/15     |
============================================================================
|Descricao | Define as colunas da planilha para a aba de produtos		   |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
Static Function DefColsPrd(_lAudit)       
	Local nCt
	Local aCampos	:= {}
	Local nNumCols	:= 0
	
		
	//As colunas abaixo ficam dentro de uma célula mesclada chamada: "Identificação"
	aAdd( aCampos, { "FILIAL",  	"C", TamSX3("B1_FILIAL")[1], TamSX3("B1_FILIAL")[2], { { 1,"Identificação",5 },;
										       { 2,"FL" } },.T., 20.00, .F., .T. } )
	aAdd( aCampos, { "ITEMCC",  	"C", TamSX3("B1_ITEMCC")[1],TamSX3("B1_ITEMCC")[2], { { 2, "Item Cont." } }	, .T., 065.00, BM_NONE, .T. } )
	aAdd( aCampos, { "CODIGO",  	"C", TamSX3("B1_COD")[1], 	TamSX3("B1_COD")[2], 	{ { 2, "Código" 	} } , .T., 065.00, BM_NONE, .T. } )
	aAdd( aCampos, { "DESCRICAO",	"C", TamSX3("B1_DESC")[1], 	TamSX3("B1_DESC")[2], 	{ { 2, "Descrição" 	} }	, .T., 258.00, BM_NONE, .T. } )
	aAdd( aCampos, { "MODELO",	  	"C", TamSX3("B1_MODELO")[1],TamSX3("B1_MODELO")[2], { { 2, "Modelo" 	} }	, .T., 100.00, BM_NONE, .T. } )
	aAdd( aCampos, { "TP",		  	"C", TamSX3("B1_TIPO")[1],	TamSX3("B1_TIPO")[2], 	{ { 2, "TP" 		} }	, .T., 20.00 , BM_NONE, .T. } )
	aAdd( aCampos, { "UM",		  	"C", TamSX3("B1_UM")[1], 	TamSX3("B1_UM")[2], 	{ { 2, "UM" 		} }	, .T., 20.00 , BM_NONE, .T. } )  

	//As colunas abaixo ficam dentro de uma célula mesclada chamada: "Saldos"
	If _lAudit    //Se Auditoria = Sim, mostra estas colunas
		aAdd(aCampos, {"SLDINTERNO"		, "N" , TamSX3("B2_QATU")[1]	,TamSX3("B2_QATU")[2]	, {{ 1 , "Saldos" , 5 } , { 2 , "Estoque Próprio" }} , .T. , 095.00 , BM_NONE , .T.  })
		aAdd(aCampos, {"SLDEMTER"		, "N" , TamSX3("B6_QUANT")[1]	,TamSX3("B6_QUANT")[2]	, {{ 2 , "Estoque em Terc."						  }} , .T. , 095.00 , BM_NONE , .T.  })
		aAdd(aCampos, {"SLDTRANSIT"		, "N" , TamSX3("B2_QATU")[1]	,TamSX3("B2_QATU")[2] 	, {{ 2 , "Estoque Em Transito"					  }} , .T. , 100.00 , BM_NONE , .T.  })
		aAdd(aCampos, {"SLDTOTAL"		, "N" , TamSX3("B2_QATU")[1]	,TamSX3("B2_QATU")[2] 	, {{ 2 , "Estoque Total"						  }} , .T. , 095.00 , BM_NONE , .T.  })
		aAdd(aCampos, {"SLDPROC"		, "N" , TamSX3("B2_QATU")[1]	,TamSX3("B2_QATU")[2] 	, {{ 2 , "Estoque Decomposto"					  }} , .T. , 100.00 , BM_NONE , .T.  })
		aAdd(aCampos, {"SLDPED"			, "N" , TamSX3("B2_QATU")[1]	,TamSX3("B2_QATU")[2] 	, {{ 2 , "Saldo em P.O."	  					  }} , .T. , 095.00 , BM_NONE , .T.  })
	Endif
	
	//As colunas abaixo ficam dentro de uma célula mesclada chamada: "Última DI"
	aAdd(aCampos, {"DTULTDI"		, "D" , 8						,0						, {{ 1 , "Última DI" , 1 } , { 2 , "Data"         }} , .T. , 065.00 , BM_NONE , .T.  })
	aAdd(aCampos, {"ULTDI"    		, "C" , TamSX3("W6_DI_NUM")[1]	,TamSX3("W6_DI_NUM")[2]	, {{ 2 , "Número"				    	          }} , .T. , 065.00 , BM_NONE , .T.  })
	
	//As colunas abaixo ficam dentro de uma célula mesclada chamada: "Valores em US$"
	aAdd(aCampos, {"VLSLDPROC"		, "N" , TamSX3("W9_FOB_TOT")[1]	,TamSX3("W9_FOB_TOT")[2]	, {{ 1 , "Valores em US$" , 3 } , { 2 , "Val. Est. Decomp."}} , .T. , 100.00 , BM_TOT1+BM_TOT2+BM_TOT3 , .T.  })	
	aAdd(aCampos, {"VLUNIPROC"		, "N" , TamSX3("W9_FOB_TOT")[1]	,TamSX3("W9_FOB_TOT")[2]	, {{ 2 , "Val. Unit. Decomp."                              }} , .T. , 100.00 , BM_NONE , .T.  })	
	aAdd(aCampos, {"VLSLDPED"		, "N" , TamSX3("W9_FOB_TOT")[1]	,TamSX3("W9_FOB_TOT")[2]	, {{ 2 , "Val. Saldo P.O"                                  }} , .T. , 100.00 , BM_TOT1+BM_TOT2+BM_TOT3 , .T.  })	
	aAdd(aCampos, {"VLUNIPED"		, "N" , TamSX3("W8_PRECO")[1]	,TamSX3("W8_PRECO")[2]		, {{ 2 , "Valor Unit. Rep."                                }} , .T. , 100.00 , BM_NONE , .T.  })	
	
	//As colunas abaixo ficam dentro de uma célula mesclada chamada: "Conversão Moeda"
	aAdd(aCampos, {"DTTXDOLAR"  	, "D" , 8						,0						, {{ 1 , "Conversão Moeda" , 1 } , { 2 , "Dt. Taxa"      }} , .T. , 085.00 , BM_NONE , .T.  })	
	aAdd(aCampos, {"TXDOLAR"   		, "N" , TamSX3("W9_TX_FOB")[1]	,TamSX3("W9_TX_FOB")[2]	, {{ 2 , "Taxa"                                          }} , .T. , 085.00 , BM_NONE , .T.  })	
	
	//As colunas abaixo ficam dentro de uma célula mesclada chamada: "Valores em R$"
	aAdd(aCampos, {"VLSLDPROCR"		, "N" , TamSX3("W8_FOBTOTR")[1]	,TamSX3("W8_FOBTOTR")[2]	, {{ 1 , "Valores em R$" , 3 } , { 2 , "Val. Est. Decomp."}} , .T. , 100.00 , BM_TOT1+BM_TOT2+BM_TOT3 , .T.  })	
	aAdd(aCampos, {"VLUNIPROCR"		, "N" , TamSX3("W8_PRECO_R")[1]	,TamSX3("W8_PRECO_R")[2]	, {{ 2 , "Val. Unit. Decomp."                             }} , .T. , 100.00 , BM_NONE , .T.  })	
	aAdd(aCampos, {"VLSLDPEDR"		, "N" , TamSX3("W8_FOBTOTR")[1]	,TamSX3("W8_FOBTOTR")[2]	, {{ 2 , "Val. Saldo P.O"                                 }} , .T. , 100.00 , BM_TOT1+BM_TOT2+BM_TOT3 , .T.  })	
	aAdd(aCampos, {"VLUNIPEDR"		, "N" , TamSX3("W8_PRECO_R")[1]	,TamSX3("W8_PRECO_R")[2]	, {{ 2 , "Valor Unit. Rep."                               }} , .T. , 100.00 , BM_NONE , .T.  })	


	Aeval( aCampos,{|aItem| IIF(aItem[9],nNumCols++,NIL) } )
Return { nNumCols, aCampos }

/*=========================================================================\
|Funcao    | DefCols            | Flavia  Rocha         | Data | 06/07/15  |
============================================================================
|Descricao | Define as colunas da planilha para a aba de Notas Entrada     |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
Static Function DefColsNFe()       
	Local nCt
	Local aCampos	:= {}
	Local nNumCols	:= 0
	
	//As colunas abaixo ficam dentro de uma célula mesclada chamada: "Identificação"
	aAdd( aCampos, { "FILIAL",  	"C", TamSX3("B1_FILIAL")[1], TamSX3("B1_FILIAL")[2], { { 1,"Identificação",6 },;
										       { 2,"FL" } },.T., 20.00, .F., .T. } )
	aAdd( aCampos, { "ITEMCC",  	"C", TamSX3("B1_ITEMCC")[1],TamSX3("B1_ITEMCC")[2], { { 2, "Item Cont." } }, .T., 065.00, BM_NONE, .T. } )
	aAdd( aCampos, { "CODIGO",  	"C", TamSX3("B1_COD")[1], 	TamSX3("B1_COD")[2], 	{ { 2, "Código" 	} }, .T., 065.00, BM_NONE, .T. } )
	aAdd( aCampos, { "DESCRICAO",	"C", TamSX3("B1_DESC")[1], 	TamSX3("B1_DESC")[2], 	{ { 2, "Descrição" 	} }, .T., 258.00, BM_NONE, .T. } )
	aAdd( aCampos, { "MODELO",	  	"C", TamSX3("B1_MODELO")[1],TamSX3("B1_MODELO")[2], { { 2, "Modelo" 	} }, .T., 100.00, BM_NONE, .T. } )
	aAdd( aCampos, { "TP",		  	"C", TamSX3("B1_TIPO")[1],	TamSX3("B1_TIPO")[2], 	{ { 2, "TP" 		} }, .T., 020.00, BM_NONE, .T. } )
	aAdd( aCampos, { "UM",		  	"C", TamSX3("B1_UM")[1], 	TamSX3("B1_UM")[2], 	{ { 2, "UM" 		} }, .T., 020.00, BM_NONE, .T. } )  

	//As colunas abaixo ficam dentro de uma célula mesclada chamada: "Itens da NF de Entrada"
	aAdd(aCampos, {"EMISSAO"		, "D" , 8						,0						, {{ 1 , "Itens da NF de Entrada" , 8 } , { 2 , "Dt.Emissão" }} , .T. , 090.00 , BM_NONE , .T.  })
	aAdd(aCampos, {"ENTRADA"	 	, "D" , 8						,0						, {{ 2 , "Dt.Entrada" 		   	   	}} , .T. , 075.00 , BM_NONE , .T.  })
	aAdd(aCampos, {"NOTA"	 		, "C" , TamSX3("D1_DOC")[1]		,TamSX3("D1_DOC")[2]	, {{ 2 , "Nota" 		   			}} , .T. , 075.00 , BM_NONE , .T.  })
	aAdd(aCampos, {"SERIE"	 		, "C" , TamSX3("D1_SERIE")[1]	,TamSX3("D1_SERIE")[2]	, {{ 2 , "Série" 		   			}} , .T. , 075.00 , BM_NONE , .T.  })
	aAdd(aCampos, {"FORNEC"	 		, "C" , TamSX3("D1_FORNECE")[1]	,TamSX3("D1_FORNECE")[2], {{ 2 , "Fornecedor"	   			}} , .T. , 075.00 , BM_NONE , .T.  })
	aAdd(aCampos, {"LOJA"	 		, "C" , TamSX3("D1_LOJA")[1]	,TamSX3("D1_LOJA")[2]	, {{ 2 , "Loja" 		   			}} , .T. , 055.00 , BM_NONE , .T.  })
	aAdd(aCampos, {"ITEMNF"	 		, "C" , TamSX3("D1_ITEM")[1]	,TamSX3("D1_ITEM")[2]	, {{ 2 , "Item NF" 		   			}} , .T. , 055.00 , BM_NONE , .T.  })
	aAdd(aCampos, {"QUANT"		 	, "N" , TamSX3("D1_QUANT")[1]	,TamSX3("D1_QUANT")[2]	, {{ 2 , "Quantidade"				}} , .T. , 085.00 , BM_TOT1 , .T.  })
	aAdd(aCampos, {"QTDUSADA"	 	, "N" , TamSX3("D1_QUANT")[1]	,TamSX3("D1_QUANT")[2]	, {{ 2 , "Quantidade Processada"	}} , .T. , 095.00 , BM_TOT1 , .T.  })
	
	//As colunas abaixo ficam dentro de uma célula mesclada chamada: Itens da NF de Importação
	aAdd(aCampos, {"PEDIDO"	 		, "C" , TamSX3("D1_PEDIDO")[1]	,TamSX3("D1_PEDIDO")[2]	, {{ 1 , "Itens da NF de Importação" , 3 }, { 2 , "PO" }} , .T. , 085.00 , BM_NONE , .T.  })
	aAdd(aCampos, {"ITEMPC"	 		, "C" , TamSX3("D1_ITEMPC")[1]	,TamSX3("D1_ITEMPC")[2]	, {{ 2 , "Posição" 					}} , .T. , 055.00 , BM_NONE , .T.  })
	aAdd(aCampos, {"HAWB"	 		, "C" , TamSX3("D1_CONHEC")[1]	,TamSX3("D1_CONHEC")[2]	, {{ 2 , "Hawb" 					}} , .T. , 085.00 , BM_NONE , .T.  })
	aAdd(aCampos, {"INVOICE" 		, "C" , TamSX3("WN_INVOICE")[1]	,TamSX3("WN_INVOICE")[2], {{ 2 , "Invoice"			   		}} , .T. , 085.00 , BM_NONE , .T.  })
	
	//As colunas abaixo ficam dentro de uma célula mesclada chamada: Declaração de Importação	
	aAdd(aCampos, {"MOEFOBW9"   	, "C" , TamSX3("W9_MOE_FOB")[1]	,TamSX3("W9_MOE_FOB")[2], {{ 1 , "Declaração de Importação" , 4 } , { 2 , "Moeda" }} , .T. , 085.00 , BM_NONE , .T.  })       
	aAdd(aCampos, {"PRECOW7" 		, "N" , TamSX3("W7_PRECO")[1]	,TamSX3("W7_PRECO")[2]	, {{ 2 , "Preço Unit."	   			}} , .T. , 085.00 , BM_NONE , .T.  })
	aAdd(aCampos, {"TXFOBW9"   		, "N" , TamSX3("W9_TX_FOB")[1]	,TamSX3("W9_TX_FOB")[2]	, {{ 2 , "Taxa Moeda"				}} , .T. , 085.00 , BM_NONE , .T.  })
	aAdd(aCampos, {"NUMDI"    		, "C" , TamSX3("W6_DI_NUM")[1]	,TamSX3("W6_DI_NUM")[2]	, {{ 2 , "Num. da DI/DA"			}} , .T. , 085.00 , BM_NONE , .T.  })
	aAdd(aCampos, {"DTREGDI" 		, "D" , 8						,0, 					  {{ 2 , "Dt. Registro DI" 	   		}} , .T. , 085.00 , BM_NONE , .T.  })       
	
	//As colunas abaixo ficam dentro de uma célula mesclada chamada: Conversão US$
	aAdd(aCampos, {"DTTXDOLAR" 		, "D" , 8						,0,						  {{ 1 , "Conversão US$" 		, 1 }, { 2 , "Dt. Taxa"  }} , .T. , 075.00 , BM_NONE , .T.  })
	aAdd(aCampos, {"TXDOLAR"   		, "N" , TamSX3("W9_TX_FOB")[1]	,TamSX3("W9_TX_FOB")[2]	, {{ 2 , "Taxa Dolar"				}} , .T. , 085.00 , BM_NONE , .T.  })       
	
	//As colunas abaixo ficam dentro de uma célula chamada: Valor Total Proc.
	aAdd(aCampos, {"VLTOTDOLAR"	 	, "N" , TamSX3("W9_FOB_TOT")[1],TamSX3("W9_FOB_TOT")[2], 	  {{ 1 , "Valor Total Proc." }, { 2 , "US$"	}} , .T. , 085.00 , BM_TOT1+BM_TOT2+BM_TOT3 , .T.  })

	Aeval( aCampos,{|aItem| IIF(aItem[9],nNumCols++,NIL) } )
Return { nNumCols, aCampos }

/*=========================================================================\
|Funcao    | DefCols            | Flavia  Rocha         | Data | 06/07/15  |
============================================================================
|Descricao | Define as colunas da planilha para a aba P.O.				   |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
Static Function DefColsPO()       
	Local nCt
	Local aCampos	:= {}
	Local nNumCols	:= 0
	
	//As colunas abaixo ficam dentro de uma célula mesclada chamada: "Identificação"
	aAdd( aCampos, { "FILIAL",  	"C", TamSX3("B1_FILIAL")[1], TamSX3("B1_FILIAL")[2], { { 1,"Identificação",5 },;
										       { 2,"FL" } },.T., 20.00, .F., .T. } )
	aAdd( aCampos, { "ITEMCC",  	"C", TamSX3("B1_ITEMCC")[1],TamSX3("B1_ITEMCC")[2], { { 2, "Item Cont." } }, .T., 065.00, BM_NONE, .T. } )
	aAdd( aCampos, { "CODIGO",  	"C", TamSX3("B1_COD")[1], 	TamSX3("B1_COD")[2], 	{ { 2, "Código" 	} }, .T., 065.00, BM_NONE, .T. } )
	aAdd( aCampos, { "DESCRICAO",	"C", TamSX3("B1_DESC")[1], 	TamSX3("B1_DESC")[2], 	{ { 2, "Descrição" 	} }, .T., 258.00, BM_NONE, .T. } )
	aAdd( aCampos, { "MODELO",	  	"C", TamSX3("B1_MODELO")[1],TamSX3("B1_MODELO")[2], { { 2, "Modelo" 	} }, .T., 100.00, BM_NONE, .T. } )
	aAdd( aCampos, { "TP",		  	"C", TamSX3("B1_TIPO")[1],	TamSX3("B1_TIPO")[2], 	{ { 2, "TP" 		} }, .T., 020.00, BM_NONE, .T. } )
	aAdd( aCampos, { "UM",		  	"C", TamSX3("B1_UM")[1], 	TamSX3("B1_UM")[2], 	{ { 2, "UM" 		} }, .T., 020.00, BM_NONE, .T. } )  

	//As colunas abaixo ficam dentro de uma célula mesclada chamada: Itens do PO
	aAdd(aCampos, {"PEDIDO"	 		, "C" , TamSX3("D1_PEDIDO")[1]	,TamSX3("D1_PEDIDO")[2]	, {{ 1 , "Itens do PO" , 9 }, { 2 , "Número" }} , .T. , 085.00 ,BM_NONE , .T. })
	aAdd(aCampos, {"ITEMPC"	 		, "C" , TamSX3("D1_ITEMPC")[1]	,TamSX3("D1_ITEMPC")[2]	, {{ 2 , "Item" 				}} , .T. , 055.00 , BM_NONE , .T. })
	aAdd(aCampos, {"FORNEC"	 		, "C" , TamSX3("D1_FORNECE")[1]	,TamSX3("D1_FORNECE")[2], {{ 2 , "Cod.Forn"	   			}} , .T. , 055.00 , BM_NONE , .T. })
	aAdd(aCampos, {"LOJA"	 		, "C" , TamSX3("D1_LOJA")[1]	,TamSX3("D1_LOJA")[2]	, {{ 2 , "Loja Forn"   			}} , .T. , 055.00 , BM_NONE , .T. })
	aAdd(aCampos, {"EMISSAO"	 	, "D" ,8						,0						, {{ 2 , "Emissão" 		   	   	}} , .T. , 075.00 , BM_NONE , .T. })
	aAdd(aCampos, {"QUANT"		 	, "N" , TamSX3("W8_QTDE")[1]	,TamSX3("W8_QTDE")[2]	, {{ 2 , "Qtd.Original"			}} , .T. , 085.00 , BM_NONE , .T. })
	aAdd(aCampos, {"QUJE"		 	, "N" , TamSX3("W8_QTDE")[1]	,TamSX3("W8_QTDE")[2]	, {{ 2 , "Qtd.Entregue"			}} , .T. , 085.00 , BM_NONE , .T. })
	aAdd(aCampos, {"SALDO"		 	, "N" , TamSX3("W8_QTDE")[1]	,TamSX3("W8_QTDE")[2]	, {{ 2 , "Saldo Pendente"		}} , .T. , 085.00 , BM_TOT1 , .T. })
	aAdd(aCampos, {"PRECOW3"		, "N" , TamSX3("W3_PRECO")[1]	,TamSX3("W3_PRECO")[2]	, {{ 2 , "Vl.Unit."             }} , .T. , 085.00 , BM_NONE , .T. })	
	aAdd(aCampos, {"VLSLDW3"		, "N" , TamSX3("W9_FOB_TOT")[1]	,TamSX3("W9_FOB_TOT")[2]  , {{ 2 , "Vl.Saldo Pendente"  }} , .T. , 095.00 , BM_NONE , .T. })	
	
	//As colunas abaixo ficam dentro de uma célula chamada: Data Ref. Conv
	aAdd(aCampos, {"DTTXMOEW3"	 	, "D" ,8						,0						, {{ 1 , "Data Ref.Conv.",,1 }} , .T. , 085.00 , .F. , .T. })


	//As colunas abaixo ficam dentro de uma célula mesclada chamada: "Moeda P.O."
	aAdd(aCampos, {"MOEDAW2"   		, "N" , TamSX3("W2_MOEDA")[1]	,TamSX3("W2_MOEDA")[2]  , {{ 1 , "Moeda P.O." , 1 } , { 2 , "Moeda"        }} , .T. , 085.00 , BM_NONE , .T. })	
	aAdd(aCampos, {"DTTXCNVW3"  	, "D" ,8						,0						, {{ 1 , "Conversão US$" , 1 } , { 2 , "Dt. Taxa"  }} , .T. , 085.00 , BM_NONE , .T. })	
	aAdd(aCampos, {"TXFOBW3"   		, "N" , TamSX3("YE_VLCON_C")[1]	,TamSX3("YE_VLCON_C")[2], {{ 2 , "Taxa"                                    }} , .T. , 085.00 , BM_NONE , .T. })	
	
	//As colunas abaixo ficam dentro de uma célula mesclada chamada: "Conversão US$"
	aAdd(aCampos, {"DTTXDOLAR"  	, "D" ,8						,0						, {{ 1 , "Conversão US$" , 1 } , { 2 , "Dt. Taxa"  }} , .T. , 085.00 , BM_NONE , .T. })	
	aAdd(aCampos, {"TXDOLAR"   		, "N" , TamSX3("W9_TX_FOB")[1]	,TamSX3("W9_TX_FOB")[2], {{ 2 , "Taxa"                                     }} , .T. , 085.00 , BM_NONE , .T. })	
	
	//As colunas abaixo ficam dentro de uma célula mesclada chamada: "Valor Pendente P.O."
	aAdd(aCampos, {"VLSLDDOLAR"  	, "N" , TamSX3("W9_FOB_TOT")[1]	,TamSX3("W9_FOB_TOT")[2]  , {{ 1 , "Valor Pendente P.O." , 1 } , { 2 , "Vl. Saldo US$" }} , .T. , 085.00 , BM_TOT1+BM_TOT2+BM_TOT3 , .T. })	
	aAdd(aCampos, {"VLUNIDOLAR"     , "N" , TamSX3("W3_PRECO")[1]	,TamSX3("W3_PRECO")[2]	, {{ 2 , "Vl. Unit. US$"                                     }}   , .T. , 085.00 , BM_NONE , .T. })	

	Aeval( aCampos,{|aItem| IIF(aItem[9],nNumCols++,NIL) } )
Return { nNumCols, aCampos }

Static Function ExecSPProc(_cFiliais,_cRelCod,_dDataUso,_cItemCCDe,_cItemCCAte)
	Local _cQuery
	Local _lRet     
	
	_cQuery := "SP_PROCESSA_SALDO_ESTOQUE_DOLAR_UPD '"+_cFiliais+"','"+_cRelCod+"'"

	IncProc()
	IncProc()
	
	_lRet := ( TCSQLExec( _cQuery ) >= 0)

	IncProc()
	IncProc()
	IncProc()
	IncProc()
	IncProc()
	
	If !_lRet          
		Alert("Erro no processamento dos dados: " + TCSQLError())
	EndIf

Return _lRet

/*=========================================================================\
|Funcao    | SelDados           | Flavia  Rocha         | Data | 06/07/15  |
============================================================================
|Descricao | Executa a seleção dos dados na base de dados SQL 			   |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
Static Function SelDados(_cFiliais,_cFolders,_cRelCod,_aArq,_dDataUso,_cItemCCDe,_cItemCCAte,_lAudit)
	Local _lRet		:= .T.
	Local _cAlias
	Local _cArq
	Local nCt
	Local _cFolder
                          
	ProcRegua( 5*(Len(_cFolders)+1)+2 )
	
	_lRet := ExecSPProc(_cFiliais,_cRelCod,_dDataUso,_cItemCCDe,_cItemCCAte)
	
	If _lRet
		For nCt:=1 To Len(_cFolders)
			_cFolder := SubStr(_cFolders,nCt,1)
			
			_lRet := SelDadTab(_cFolder,_cRelCod,@_cAlias,@_cArq,_lAudit)
			
			If !_lRet
				Exit
			EndIf			
	
			AAdd(_aArq,{_cFolder,_cAlias,_cArq})					
		Next
	EndIf
	
Return _lRet       

Static Function SelDadTab(_cFolder,_cRelCod,_cAlias,_cArq,_lAudit)
	Local _cQuery   := ''              
	Local _aCpoDef	:= {}
	Local nCt
	Local _cNumMes
	Local _aTabPrd
	
	Do Case
		Case _cFolder == FOLDER_PRODUTO
			_aTabPrd := SelTabPrd(_cRelCod,_lAudit)
		Case _cFolder == FOLDER_NOTA
			_aTabPrd := SelTabNfe(_cRelCod)
		Case _cFolder == FOLDER_PO
			_aTabPrd := SelTabPO(_cRelCod)
	End Case
	
	_cQuery  := _aTabPrd[1]
	_aCpoDef := _aTabPrd[2]
			
	IncProc()

	_cArq 	:= CriaTrab(,.F.)
	_cAlias := SubStr( _cArq, 1, 8 )

	IncProc()

	TCQUERY _cQuery NEW ALIAS (_cAlias)
	dbSelectArea( _cAlias )

	IncProc()

	U_fSetField( _aCpoDef, _cAlias, .f. )	 

	IncProc()

	Copy To &_cArq
	(_cAlias)->( dbCloseArea() )

	dbUseArea(.T.,,_cArq,_cAlias, .t. )

	IncProc()                      

Return .T.        

Static Function SelTabPrd(_cRelCod, _lAudit)  
	Local _aCpoDef	:= {}
	Local _cQuery
	
	_cQuery := "EXEC SP_PLANILHA_SALDO_ESTOQUE_DOLAR_PRODUTO_SEL '"+_cRelCod+"'"

	//Identificação
	U_AddCpoDf(_aCpoDef,"FILIAL","B1_FILIAL")
	U_AddCpoDf(_aCpoDef,"TPLANC",,"C",2,0)              
	U_AddCpoDf(_aCpoDef,"ITEMCC","B1_ITEMCC")
	U_AddCpoDf(_aCpoDef,"CODIGO","B1_COD")	
	U_AddCpoDf(_aCpoDef,"DESCRICAO","B1_DESC") 
	U_AddCpoDf(_aCpoDef,"MODELO","B1_MODELO")
	U_AddCpoDf(_aCpoDef,"TP","B1_TIPO")	 
	U_AddCpoDf(_aCpoDef,"UM","B1_UM")

	//Saldos 
	//If _lAudit  //se Auditoria = Sim, mostra estas colunas	 	
		U_AddCpoDf(_aCpoDef,"SLDINTERNO","B2_QATU") 
		U_AddCpoDf(_aCpoDef,"SLDEMTER","B6_QUANT")  
		U_AddCpoDf(_aCpoDef,"SLDTRANSIT","B2_QATU") 
		U_AddCpoDf(_aCpoDef,"SLDTOTAL","B2_QATU")  
		U_AddCpoDf(_aCpoDef,"SLDPROC","B2_QATU")  
		U_AddCpoDf(_aCpoDef,"SLDPED","B2_QATU")
	//Endif 
	
	//Última DI 	  
	U_AddCpoDf(_aCpoDef,"DTULTDI","W6_DTREG_D") 
	U_AddCpoDf(_aCpoDef,"ULTDI","W6_DI_NUM")
	
	//Valores em US$
	U_AddCpoDf(_aCpoDef,"VLSLDPROC","W9_FOB_TOT") 
	U_AddCpoDf(_aCpoDef,"VLUNIPROC","W8_PRECO") 
	U_AddCpoDf(_aCpoDef,"VLSLDPED","W9_FOB_TOT")  
	U_AddCpoDf(_aCpoDef,"VLUNIPED","W8_PRECO")  
	
	//Conversão Moeda
	U_AddCpoDf(_aCpoDef,"DTTXDOLAR","YE_DATA")   
	U_AddCpoDf(_aCpoDef,"TXDOLAR","W9_TX_FOB")
	 	 	   
	//Valores em R$
	U_AddCpoDf(_aCpoDef,"VLSLDPROCR","W8_FOBTOTR")
	U_AddCpoDf(_aCpoDef,"VLUNIPROCR","W8_PRECO_R") 
	U_AddCpoDf(_aCpoDef,"VLSLDPEDR","W8_FOBTOTR")  
	U_AddCpoDf(_aCpoDef,"VLUNIPEDR","W8_PRECO_R")

Return {_cQuery,_aCpoDef}

Static Function SelTabNfe(_cRelCod)  
	Local _aCpoDef	:= {}
	Local _cQuery
	
	_cQuery := "EXEC SP_PLANILHA_SALDO_ESTOQUE_DOLAR_NOTA_SEL '"+_cRelCod+"'"
	
	//Identificação
	U_AddCpoDf(_aCpoDef,"FILIAL","B1_FILIAL")
	U_AddCpoDf(_aCpoDef,"TPLANC",,"C",2,0)              
	U_AddCpoDf(_aCpoDef,"ITEMCC","B1_ITEMCC")
	U_AddCpoDf(_aCpoDef,"CODIGO","B2_COD")	
	U_AddCpoDf(_aCpoDef,"DESCRICAO","B1_DESC") 
	U_AddCpoDf(_aCpoDef,"MODELO","B1_MODELO")
	U_AddCpoDf(_aCpoDef,"TP","B1_TIPO")	 
	U_AddCpoDf(_aCpoDef,"UM","B1_UM")
	
	//Itens das NF Entrada
	U_AddCpoDf(_aCpoDef,"EMISSAO"	,"D1_EMISSAO") 
	U_AddCpoDf(_aCpoDef,"ENTRADA"	,"D1_DTDIGIT")
	U_AddCpoDf(_aCpoDef,"NOTA"		,"D1_DOC")
	U_AddCpoDf(_aCpoDef,"SERIE"		,"D1_SERIE")
	U_AddCpoDf(_aCpoDef,"FORNEC"	,"D1_FORNECE")
	U_AddCpoDf(_aCpoDef,"LOJA"		,"D1_LOJA")
	U_AddCpoDf(_aCpoDef,"ITEMNF"	,"D1_ITEM")
	U_AddCpoDf(_aCpoDef,"QUANT"		,"D1_QUANT")
	U_AddCpoDf(_aCpoDef,"QTDUSADA"	,"D1_QUANT")

	//Itens da NF de Importação
	U_AddCpoDf(_aCpoDef,"PEDIDO"	,"D1_PEDIDO")
	U_AddCpoDf(_aCpoDef,"ITEMPC"	,"D1_ITEMPC")
	U_AddCpoDf(_aCpoDef,"HAWB"		,"D1_CONHEC")
	U_AddCpoDf(_aCpoDef,"INVOICE"	,"WN_INVOICE")

	//Declaração de Importação
	U_AddCpoDf(_aCpoDef,"MOEFOBW9" 	,"W9_MOE_FOB")
	U_AddCpoDf(_aCpoDef,"PRECOW7"	,"W7_PRECO")    
	U_AddCpoDf(_aCpoDef,"TXFOBW9" 	,"W9_TX_FOB")
	U_AddCpoDf(_aCpoDef,"NUMDI" 	,"W6_DI_NUM")  
	U_AddCpoDf(_aCpoDef,"DTREGDI"   ,"W6_DTREG_D")

	//Conversão US$
	U_AddCpoDf(_aCpoDef,"DTTXDOLAR"	,"YE_DATA")
	U_AddCpoDf(_aCpoDef,"TXDOLAR" 	,"W9_TX_FOB")
	//Valor total Proc. 
	U_AddCpoDf(_aCpoDef,"VLTOTDOLAR","W9_FOB_TOT") 
	
Return {_cQuery,_aCpoDef}

Static Function SelTabPO(_cRelCod)  
	Local _aCpoDef	:= {}
	Local _cQuery
	
	_cQuery := "EXEC SP_PLANILHA_SALDO_ESTOQUE_DOLAR_PO_SEL '"+_cRelCod+"'"
                                                                              
	//Identificação
	U_AddCpoDf(_aCpoDef,"FILIAL","B1_FILIAL")
	U_AddCpoDf(_aCpoDef,"TPLANC",,"C",2,0)              
	U_AddCpoDf(_aCpoDef,"ITEMCC","B1_ITEMCC")
	U_AddCpoDf(_aCpoDef,"CODIGO","B1_COD")	
	U_AddCpoDf(_aCpoDef,"DESCRICAO","B1_DESC") 
	U_AddCpoDf(_aCpoDef,"MODELO","B1_MODELO")
	U_AddCpoDf(_aCpoDef,"TP","B1_TIPO")	 
	U_AddCpoDf(_aCpoDef,"UM","B1_UM")

	//As colunas abaixo ficam dentro de uma célula mesclada chamada: Itens do PO
	U_AddCpoDf(_aCpoDef,"PEDIDO","D1_PEDIDO")
	U_AddCpoDf(_aCpoDef,"ITEMPC","D1_ITEMPC")
	U_AddCpoDf(_aCpoDef,"FORNEC","D1_FORNECE")
	U_AddCpoDf(_aCpoDef,"LOJA","D1_LOJA")
	U_AddCpoDf(_aCpoDef,"EMISSAO","W9_DTLANC")
	U_AddCpoDf(_aCpoDef,"QUANT","W8_QTDE")
	U_AddCpoDf(_aCpoDef,"QUJE","W8_QTDE")
	U_AddCpoDf(_aCpoDef,"SALDO","W8_QTDE")
	U_AddCpoDf(_aCpoDef,"PRECOW3","W3_PRECO")
	U_AddCpoDf(_aCpoDef,"VLSLDW3","W9_FOB_TOT")
	U_AddCpoDf(_aCpoDef,"DTTXMOEW3","YE_DATA") 
	U_AddCpoDf(_aCpoDef,"MOEDAW2","W2_MOEDA")
	U_AddCpoDf(_aCpoDef,"DTTXCNVW3","YE_DATA")
	U_AddCpoDf(_aCpoDef,"TXFOBW3","YE_VLCON_C")
	U_AddCpoDf(_aCpoDef,"DTTXDOLAR","YE_DATA")
	U_AddCpoDf(_aCpoDef,"TXDOLAR","W9_TX_FOB")
	U_AddCpoDf(_aCpoDef,"VLSLDDOLAR","W9_FOB_TOT")
	U_AddCpoDf(_aCpoDef,"VLUNIDOLAR","W3_PRECO")                                            
	
Return {_cQuery,_aCpoDef}

/*=========================================================================\
|Funcao    | CriaXLS            | Flavia  Rocha         | Data | 06/07/15  |
============================================================================
|Descricao | Processa a criação do arquivo excel no servidor selecionando  |
|          | os dados segundo os parametros passados					   |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
Static Function CriaXLS(_cFiliais,_cFile,_cSrvPath,_cRmtPath,_cFolders,_dDataUso,_cItemCCDe,_cItemCCAte,_lAudit)
	Local _lRet
	Local oExcelCLS    
	Local aWrkSht
	Local _aArq		:= {}
	Local _aMatriz	:= {}
		
	oExcelCLS := TExcelCLS():New()
	
	If !oExcelCLS:Create(_cSrvPath+_cFile)
		MsgStop('Não foi possível criar o arquivo excel!' )
		Return .F.
	EndIf
	
	Processa( {|| _lRet := SelDados(_cFiliais,_cFolders,U_CdSysLog(),_aArq,_dDataUso,_cItemCCDe,_cItemCCAte,_lAudit) },"Selecionando dados..." )
	
	If _lRet
		_lRet := ExistDados(_aArq)
		
		If !_lRet
			MsgStop('Não existem dados para criar o arquivo excel no servidor!' )
		EndIf
	EndIf
	
	If _lRet
		aWrkSht := DefWrkSht(_cFiliais,_aArq,_dDataUso,_lAudit)
		
		Processa( {|| _lRet := GeraXLS(oExcelCLS,aWrkSht,_lAudit) },"Gerando planilha..." )
	EndIf
	
	CloseAlias(_aArq)
	
	oExcelCLS:Close()                  
	
	If _lRet
		Processa( {|| _lRet := U_CpyXLS2Rmt(_cSrvPath,_cFile,@_cRmtPath) }, "Transferindo planilha Excel..." )
	EndIf
	
	fErase(_cSrvPath+_cFile)      
Return _lRet

Static Function CloseAlias(_aArq)
	Local nCt

	For nCt:=1 To Len(_aArq)
		If Select(_aArq[nCt][ITEM_ARQ_ALIAS]) > 0
			(_aArq[nCt][ITEM_ARQ_ALIAS])->(dbCloseArea())
		EndIf
		
		fErase(_aArq[nCt][ITEM_ARQ_FILENAME])
	Next
Return	

Static Function ExistDados(_aArq)
	Local _lRet := .F.
	Local nCt
	
	For nCt:=1 To Len(_aArq)
		 If !( Select(_aArq[nCt][ITEM_ARQ_ALIAS]) == 0 .Or. (_aArq[nCt][ITEM_ARQ_ALIAS])->( RecCount() ) == 0 )
		 	_lRet := .T.
		 EndIf
	Next

Return _lRet

/*=========================================================================\
|Funcao    | GeraXLS            | Flavia  Rocha         | Data | 06/07/15  |
============================================================================
|Descricao | Gera o arquivo excel no servidor 							   |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
Static Function GeraXLS(oExcelCLS,aWrkSht,_lAudit)
	Local _nRecCount 	:= 0                      
	Local _aRowTotal	:= {}                        
	Local _aGrupos		:= {}
	Local _cTitulo
	Local _cAlias
	Local _cDescFil
	Local _cTab
	Local _dDataUso
	Local _nNumCols
	Local aCampos       
	Local nHeader
	Local nColIndex
	Local bGetData         
	Local nArea
//	Local _aRowForm
//	Local _nRowIni
	Local oStyleTit
	Local oStyleFil
	Local _nWrk
	Local nCt  
	Local nTot 
	Local nBit
	Local nToTabP    	//sub total da tab Produto
	Local nToGerTabP    //total geral da tab Produto
	Local nToTabN       //sub total da tab Notas
	Local nToGerTabN    //total geral da tab Notas
	Local nToTabO       //sub total da tab PO
	Local nToGerTabO    //total geral da tab PO
	
	
	//Define estilos para os cabeçalhos	
	oStyleTit := oExcelCLS:AddStyle("D0")
	
	oStyleTit:GetFont():cFontName	:= "Swiss"
	oStyleTit:GetFont():nSize		:= 20
	oStyleTit:GetFont():nAttrib 	:= XLS_FONT_BOLD
	
	oStyleFil := oExcelCLS:AddStyle("D1")
	oStyleFil:GetFont():cFontName	:= "Swiss"
	oStyleFil:GetFont():nSize		:= 14
	oStyleFil:GetFont():nAttrib 	:= XLS_FONT_BOLD
	
	//Subtotais do folder = Produto
	nToTabP1   :=  0
	nToTabP2   :=  0
	nToTabP3   :=  0
	nToTabP4   :=  0
		   			
	//Totalizadores GERAIS do Folder = Produto
	nTGTabP1   :=  0
  	nTGTabP2   :=  0
	nTGTabP3   :=  0
	nTGTabP4   :=  0
		
	nToTabN    	:= 0 	//Subtotal do folder = Notas	
	nTGTabN		:= 0	//Total GERAL do folder = Notas
	
	nToTabO 	:= 0	//Subtotal do folder = PO
	nTGTabO		:= 0    //Total GERAL do folder = PO
	
	For _nWrk:=1 To Len(aWrkSht)
		oExcelCLS:AddWrkSheet( aWrkSht[_nWrk][6],; 		//cHeader
		                       aWrkSht[_nWrk][7],;     	//nRowFreeze
		                       aWrkSht[_nWrk][8],;     	//nHeightHdr
		                       aWrkSht[_nWrk][9],;     	//nHeightRow
		                       aWrkSht[_nWrk][10],;     	//nHeaders
		                       aWrkSht[_nWrk][11],;     	//cPgHeader
		                       aWrkSht[_nWrk][12],;    	//cPgFooter
		                       aWrkSht[_nWrk][13],;    	//nPgOrienta
		                       aWrkSht[_nWrk][14],;    	//nPrtScale
		                       aWrkSht[_nWrk][15],;    	//nMgrHeader
		                       aWrkSht[_nWrk][16],;    	//nMgrFooter
		                       aWrkSht[_nWrk][17],;    	//nPgTop
		                       aWrkSht[_nWrk][18],;    	//nPgBottom
		                       aWrkSht[_nWrk][19],;    	//nPgLeft
		                       aWrkSht[_nWrk][20],;    	//nPgRight
		                       aWrkSht[_nWrk][21],;    	//lHidden
		                       aWrkSht[_nWrk][22],;    	//cLinRepSup
		                       aWrkSht[_nWrk][23],;    	//cColRepEsq
		                       aWrkSht[_nWrk][24],;    	//nStyles
		                       aWrkSht[_nWrk][25];     	//nColFreeze
						    )
	
		_cAlias  := aWrkSht[_nWrk][2]	  	//cAlias
		aCampos  := aWrkSht[_nWrk][4][2] 	//aDefCols -> aCampos
		_cTab    := aWrkSht[_nWrk][5]	  	//cTab
        
		nArea := Select(_cAlias)
		
		_nRecCount += (_cAlias)->( RecCount() )
	
		AAdd( _aRowTotal, {{},{},{}} ) //Adiciona 3 totalizadores (T1 a T3) para a WorkSheet
		
		nColIndex := 0
		For nCt=1 To Len(aCampos)                                    
			If aCampos[nCt][9]  
				nColIndex ++
	
				If ValType(aCampos[nCt][1])=="C" .And. Left(aCampos[nCt][1],1)=="="
					oExcelCLS:GetWrkSheet():AddFormula(IIF(ValType(aCampos[nCt][5])=="C",aCampos[nCt][5],""),aCampos[nCt][2],aCampos[nCt][1],aCampos[nCt][3],aCampos[nCt][4],,,,,IIF(Len(aCampos[nCt])>=7,aCampos[nCt][7],NIL))
				Else			
					If ValType(aCampos[nCt][6])=="L" .And. aCampos[nCt][6]
						If ValType(aCampos[nCt][1])=="B"
							bGetData := aCampos[nCt][1]
						Else	
							bGetData := FieldWBlock(aCampos[nCt][1],nArea)
						EndIf
					Else        
						bGetData := NIL
					EndIf                            

					oExcelCLS:GetWrkSheet():AddColumn(IIF(ValType(aCampos[nCt][5])=="C",aCampos[nCt][5],""),aCampos[nCt][2],aCampos[nCt][3],aCampos[nCt][4],,,,,IIF(Len(aCampos[nCt])>=7,aCampos[nCt][7],NIL),bGetData)
				Endif					
	
				If ValType(aCampos[nCt][5])=="A"			
					For nHeader:=1 To Len(aCampos[nCt][5])
						oExcelCLS:GetWrkSheet():GetColumn(nColIndex):SetHeader(aCampos[nCt][5][nHeader][1],;
																   			   aCampos[nCt][5][nHeader][2],;
																		 	   IIF(Len(aCampos[nCt][5][nHeader])>=3,aCampos[nCt][5][nHeader][3],NIL),;
																		 	   IIF(Len(aCampos[nCt][5][nHeader])>=4,aCampos[nCt][5][nHeader][4],NIL) )
					Next
				EndIf
					
				oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleHdr:lWrapText := .T.
				oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleHdr:nAlignH := XLS_ALIGNH_CENTER 

				//oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleCol:SetBorders(XLS_BORDER_MSK_NONE)   //FR - totalizador sem borda
				oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleHdr:GetBorder(1):nWeight := 2           //FR - totalizador com borda
				

				oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleTot:xColor := "#CCFFCC"
				oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleTot:SetBorders(XLS_BORDER_MSK_NONE)
				oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleTot:GetFont():cFontName := "Swiss"
				oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleTot:GetFont():nAttrib   := XLS_FONT_BOLD
				
				//oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleTot:SetBorders(XLS_BORDER_MSK_NONE)
	
				If Len(aCampos[nCt])>=10 .And. !aCampos[nCt][10]
					oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleCol:GetFont():xColor := "BLUE"
					oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleTot:GetFont():xColor := "BLUE"
				EndIf
						
				If aCampos[nCt][2]=="N"
					oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleTot:SetBorders(XLS_BORDER_MSK_NONE)
				EndIf     
				
				For nTot:=1 To 3	//Totalizadores T1 a T3      
					Do Case
						Case nTot==1
							nBit := BM_BIT_TOT1
						Case nTot==2
							nBit := BM_BIT_TOT2
						Case nTot==3
							nBit := BM_BIT_TOT3
						OtherWise
							nBit := BM_BIT_NONE
					EndCase
							
					//Utiliza totalizador somente se o campo for númerico, ignora configuração
					If aCampos[nCt][2]=="N" .And. Len(aCampos[nCt]) >= 8 .And. BitAtivo(aCampos[nCt][8],nBit)
						If ValType(aCampos[nCt][6])=="L" .And. aCampos[nCt][6]
							If ValType(aCampos[nCt][1])=="B"
								bGetData := aCampos[nCt][1]
							Else	
								bGetData := FieldWBlock(aCampos[nCt][1],nArea)
							EndIf
						Else        
							bGetData := NIL
						EndIf                            
						//bGetData := {|| GetStrForm(_cAlias,_aGrupos) }
					Else
						bGetData := NIL
					EndIf

		   			AAdd(_aRowTotal[_nWrk][nTot],bGetData)
				Next	
			EndIf
		Next     
	Next

	ProcRegua(_nRecCount)
	
	For _nWrk:=1 To Len(aWrkSht)
		_cTitulo  := aWrkSht[_nWrk][1]	  	//cTitulo
		_cAlias   := aWrkSht[_nWrk][2]	  	//cAlias
		_cDescFil := aWrkSht[_nWrk][3]	  	//cDescFil
		_nNumCols := aWrkSht[_nWrk][4][1] 	//aDefCols -> nNumCols
		_cTab     := aWrkSht[_nWrk][5]	  	//cTab
	    _dDataUso := aWrkSht[_nWrk][26]		//cPageHeader (Cabeçalho da página: contém String da Filial e data utilizada para seleção de dados)
		If _nWrk==1
			oExcelCLS:SetWrkSht(_nWrk)
		Else
			oExcelCLS:NextWrkSht()
		EndIf
	
		oExcelCLS:GetWrkSheet():NewRow()
		oExcelCLS:GetWrkSheet():NewCell(_cTitulo,,oStyleTit:GetCodigo())
		oExcelCLS:GetWrkSheet():EndRow()
	    
		//nova linha
		oExcelCLS:GetWrkSheet():NewRow()
		oExcelCLS:GetWrkSheet():NewCell(_cDescFil,,oStyleFil:GetCodigo())
		oExcelCLS:GetWrkSheet():EndRow()
		
		//nova linha
		oExcelCLS:GetWrkSheet():NewRow()
		oExcelCLS:GetWrkSheet():NewCell("Data: "+DtoC(_dDataUso),,oStyleFil:GetCodigo())  
		oExcelCLS:GetWrkSheet():EndRow()
	
		oExcelCLS:GetWrkSheet():WrtHdrCols()
	
	    (_cAlias)->( DbGoTop() )
		    
		Do While (_cAlias)->(!Eof())
		    	    
		    If Left((_cAlias)->TPLANC,1)=="T"                                                                     
		    	Do Case 
		    		Case (_cAlias)->TPLANC=="T1"
		    			nCt := 1                 
		    			_aRowTotal[_nWrk][nCt][1]:=IIF(_cTab==FOLDER_PRODUTO,"Total Item Contábil "+(_cAlias)->ITEMCC,"Total Produto "+(_cAlias)->CODIGO)  		    		
		    			///FR		    			
		    			If _cTab == FOLDER_PRODUTO
			    			If _lAudit
				    			_aRowTotal[_nWrk][nCt][16]:= nToTabP1  //VLSLDPROC
				    			_aRowTotal[_nWrk][nCt][18]:= nToTabP2  //VLSLDPED
				    			_aRowTotal[_nWrk][nCt][22]:= nToTabP3  //VLSLDPROCR
				    			_aRowTotal[_nWrk][nCt][24]:= nToTabP4  //VLSLDPEDR
				    		Else
				    			_aRowTotal[_nWrk][nCt][10]:= nToTabP1  //VLSLDPROC
				    			_aRowTotal[_nWrk][nCt][12]:= nToTabP2  //VLSLDPED
				    			_aRowTotal[_nWrk][nCt][16]:= nToTabP3  //VLSLDPROCR
				    			_aRowTotal[_nWrk][nCt][18]:= nToTabP4  //VLSLDPEDR
			    			Endif
			    			//zera os subtotais
			    			nToTabP1 := 0   	
			    			nToTabP2 := 0
			    			nToTabP3 := 0
			    			nToTabP4 := 0
			    		Elseif _cTab == FOLDER_NOTA
			    			_aRowTotal[_nWrk][nCt][28] := nToTabN  	//subtotal
				   		    nToTabN := 0 							//zera o subtotal				   		    
			    		Else 	//FOLDER_PO
			    			_aRowTotal[_nWrk][nCt][24] := nToTabO 	//subtotal
			    			nToTabO := 0							//zera o subtotal			    			
			    		Endif			    		
			    		///FR
		    		Case (_cAlias)->TPLANC=="T2"
		    			nCt := 2
		    			_aRowTotal[_nWrk][nCt][1]:="Total Filial "+(_cAlias)->FILIAL
		    			///FR		    			
		    			If _cTab == FOLDER_PRODUTO
		    				If _lAudit
				    			_aRowTotal[_nWrk][nCt][16]:= nTGTabP1  		//VLSLDPROC				    		
				    			_aRowTotal[_nWrk][nCt][24]:= nTGTabP4  		//VLSLDPEDR 
				    		Else
				    			_aRowTotal[_nWrk][nCt][10]:= nTGTabP1  		//VLSLDPROC				    		
				    			_aRowTotal[_nWrk][nCt][18]:= nTGTabP4  		//VLSLDPEDR
				    		Endif
			    		
			    		Elseif _cTab == FOLDER_NOTA
			    			_aRowTotal[_nWrk][nCt][28] := nTGTabN  	//subtotal				   		 
			    		Else 	//FOLDER_PO
			    			_aRowTotal[_nWrk][nCt][24] := nTGTabO 	//subtotal			    		
			    		Endif		    		
			    		///FR
		    		Case (_cAlias)->TPLANC=="T3"
		    			nCt := 3               
		    			_aRowTotal[_nWrk][nCt][1]:="Total Geral"
		    		OtherWise
		    			nCt := 0
		    	EndCase 
		    	
   				oExcelCLS:GetWrkSheet():AddRowForm(_aRowTotal[_nWrk][nCt],, -3)

		    	If nCt==2 //Totalizador por filial
					oExcelCLS:GetWrkSheet():NewRow()
				EndIf
			Else
				oExcelCLS:GetWrkSheet():AddRowData()
				///FR
				If (_cAlias)->TPLANC == "MV"
					If _cTab == FOLDER_PRODUTO
						//subtotais 
			   			nToTabP1   +=  Round( (_cAlias)->VLSLDPROC , 2 )
			   			nToTabP2   +=  Round( (_cAlias)->VLSLDPED , 2 )
			   			nToTabP3   +=  Round( (_cAlias)->VLSLDPROCR , 2 )
			   			nToTabP4   +=  Round( (_cAlias)->VLSLDPEDR , 2 )
			   			
			   			//totalizadores GERAL
			   			nTGTabP1   +=  Round( (_cAlias)->VLSLDPROC , 2 )
					   	nTGTabP2   +=  Round( (_cAlias)->VLSLDPED , 2 )
			   			nTGTabP3   +=  Round( (_cAlias)->VLSLDPROCR , 2 )
			   			nTGTabP4   +=  Round( (_cAlias)->VLSLDPEDR , 2 )
			   		Elseif _cTab == FOLDER_NOTA
			   			nToTabN    	+= Round( (_cAlias)->VLTOTDOLAR , 2 )  //subtotal
			   		    nTGTabN		+= Round( (_cAlias)->VLTOTDOLAR , 2 )  //total geral
			   		Else //FOLDER_PO
			   			nToTabO 	+= Round( (_cAlias)->VLSLDDOLAR , 2 )  //Subtotal do folder = PO
						nTGTabO		+= Round( (_cAlias)->VLSLDDOLAR , 2 )  //Total GERAL do folder = PO
			   		Endif
				Endif							
				///FR
		    EndIf	                      
		    
		    (_cAlias)->( DbSkip() )    
	
		    IncProc()
		EndDo
	Next
	
Return .T.

/*==========================================================================
|Funcao     | ConfPergs         | Flávia Rocha         | Data | 06/07/15   |
============================================================================
|Descricao  | Configura automaticamente as perguntas utilizadas			   |
============================================================================
|Observações|  	                                                           |
==========================================================================*/

Static Function	ConfPergs(cPerg)  
	Local aPerg := {}
	
	aAdd(aPerg,{"Filiais ?"				,"mv_ch1","C",80,0,0,"G","U_VldSelFil()"			,"MV_PAR01","","","","","","SELFIL",Space(80)										,""})
	aAdd(aPerg,{"Auditoria?"			,"mv_ch2","N",01	,0,1,"C",""						,"MV_PAR02","Sim","Nao","","","","",""												,""})	
	aAdd(aPerg,{"Seleção de Abas ?"   	,"mv_ch3","C",03	,0,0,"G",""						,"MV_PAR03","","","","","","SELNPE",TP_FOLDER		   								,""})
	
	aAdd(aPerg,{"Item Contábil De ?"    ,"mv_ch4","C",09,0,0,"G",""	 			  		 	,"MV_PAR04",""			,""			,""			,"","","CTD"	,Space(9)			,""})
	aAdd(aPerg,{"Item Contábil Até ?"   ,"mv_ch5","C",09,0,0,"G",""	 				  		,"MV_PAR05",""	        ,""			,""			,"","","CTD"	,Replicate("Z",9)	,""})
	
	aAdd(aPerg,{"Nome do Arquivo ?"   	,"mv_ch6","C",40	,0,0,"G",""						,"MV_PAR06","","","","","","",Space(40)												,""})
	aAdd(aPerg,{"Diretório Destino ?" 	,"mv_ch7","C",80	,0,0,"G","U_ChkPName(,2,.T.)"	,"MV_PAR07",""            ,""            ,"","","","SELDIR",PadR("C:\TEMP\",80)		,""})
	aAdd(aPerg,{"Executa MS Excel ?"  	,"mv_ch8","N",01	,0,1,"C",""						,"MV_PAR08","Sim","Não"         ,"","","",""      ,""				   				,""})
	
	//Ajusta o dicionario SX1 corrigindo ou inserido as perguntas necessárias
	U_ConfigSx1(cPerg, aPerg)
Return .T.

/*=========================================================================\
|Funcao    | GetDtDesc          | Flavia  Rocha         | Data | 06/07/15  |
============================================================================
|Descricao | Pega data de seleção para o cabeçalho da planilha			   |
|          |                                                               |
============================================================================
|Observações:															   |
|																		   |
\=========================================================================*/
Static Function GetDtDesc(_dDataIni,_dDataFim)
	Local cRet
	Local lDeAte := .F.
	Local lSoUmaD:= .F.
	
	If Day(_dDataIni) != 1
		lDeAte := .T.
	EndIf
	
	If !Empty(_dDataFim)
		If LastDay(_dDataFim) != _dDataFim
			lDeAte := .T.
		EndIf
	Endif
	
	If Empty(_dDataFim)
		lSoUmaD := .T.   //se foi passado apenas uma data nos parâmetros
	Endif
	
	If !lSoUmaD	
		If lDeAte
			cRet := DtoC(_dDataIni)+" a "+DtoC(_dDataFim)		
		Else
			If Year(_dDataIni) != Year(_dDatafim)
				cRet := U_fNomeMes(Month(_dDataIni),.F.)+"/"+AllTrim(Str(Year(_dDataIni)))+" a "+U_fNomeMes(Month(_dDataFim),.F.)+"/"+AllTrim(Str(Year(_dDataFim)))
			Else
				cRet := U_fNomeMes(Month(_dDataIni),.F.)+" a "+U_fNomeMes(Month(_dDataFim),.F.)+" de "+AllTrim(Str(Year(_dDataIni)))
			EndIf
		EndIf
	Else
		cRet := DtoC(_dDataIni)			
	Endif	
		
Return cRet

Static Function GetDescFil(_cFiliais)
	Local cRet  
	Local nCt
		
	cRet := IIF(At(",",_cFiliais) > 0,"Filiais","Filial")+" "+_cFiliais
		
	nCt := Rat(",",cRet)
	If nCt > 0
		cRet := Left(cRet,nCt-1)+" e "+SubStr(cRet,nCt+1)
	EndIf    
		
Return cRet

/*==========================================================================
|Funcao    | GetTabNPE | Autor  | Flávia Rocha         | Data | 06/07/2015 |
============================================================================
|Descricao | Definicao do lista do F3 do parametro                         |
============================================================================
|Parametros| cVar      -> variavel do parametro (mv_parXX)                 |
============================================================================
|Retorno   | aRet      -> array com as imformacoes a serem exibidas no F3  |
|          |              do parametro                                     |
==========================================================================*/
Static Function GetTabNPE(cVar)
	Local aRet := {}
	
	Do Case
		Case cVar == "MV_PAR03"
			aRet := { { FOLDER_PRODUTO , 'Produto' 		},;
					  { FOLDER_NOTA , 'Notas Fiscais' 	},;
					  { FOLDER_PO , 'P.O.' 			} }
		End Case
		
Return aRet

Static Function BitAtivo(nMask,nBit)
	Local lRet := .F.
	Local nCt
	Local nExp           
	
	nBit++

	If nBit > 0 .And. nBit <= 15 .And. nMask > 0	
		nCt := 1
		Do While nBit <= 15
			nRest:=nMask % 2

			If nCt == nBit 
				lRet  := (nRest > 0)
				Exit
			EndIf   
			nMask := (nMask-nRest)/2
			nCt++
		End Do
    EndIf
Return lRet
