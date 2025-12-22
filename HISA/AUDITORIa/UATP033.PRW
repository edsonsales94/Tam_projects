#INCLUDE "rwmake.ch"
#INCLUDE "Vkey.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "ExcelCLS.ch"
#INCLUDE "Protheus.ch"

/*==========================================================================
|Funcao     | UATP033   | Autor | Bianca Massarotto    | Data | 04/10/11   |
============================================================================
|Descricao  | Gera planilha excel                                          |
|           | Relatório Auditoria de Notas Fiscais Sintético			   |
============================================================================
|Modulo     | Faturamento                                                  |
============================================================================
|Observações|															   |
==========================================================================*/
User Function UATP033()
Local	aArea		:= GetArea()
Local	nOpca		:= 0
Local	aSays		:= {}
Local	aButtons	:= {}
Local	cPerg		:= "UTP033"
Private cCadastro	:= "Geração de Planilha - Relatório Sintético Auditoria de NF's"

If !u_ChkFunc( Replace(ProcName(), "U_", ""),,,, "a " + cCadastro )
	Return
EndIf

//Configura e Inicializa a rotina
ConfPergs(cPerg)
Pergunte(cPerg, .F.)

aAdd( aSays, " Este programa tem o objetivo de gerar a Planilha em " )
aAdd( aSays, " Excel com o Relatório Sintético Auditoria de NFs    " )
aAdd( aSays, " no computador do usuário.                           " )
aAdd( aButtons, { 5, .T., { || Pergunte(cPerg, .T.)    } } )
aAdd( aButtons, { 1, .T., { |o| nOpca:=1, o:oWnd:End() } } )
aAdd( aButtons, { 2, .T., { |o| o:oWnd:End()           } } )

While .T.
	nOpca := 0
	FormBatch(cCadastro, aSays, aButtons)
	Do Case
		Case nOpcA == 1
			If GeraExcel()
				Exit
			EndIf
		OtherWise
			Exit
	EndCase
EndDo

RestArea(aArea)

Return

/*==========================================================================
| Parametros												   			   |
+--------------------------------------------------------------------------+
| MV_PAR01 // Tipo ?	       											   |
| MV_PAR02 // Filiais ?       											   |
| MV_PAR03 // Data Inicial ?											   |
| MV_PAR04 // Data Final ?												   |
| MV_PAR05 // CFOP ?													   |
| MV_PAR06 // Cli./For. De ?											   |
| MV_PAR07 // Cli./For. Ate ?											   |
| MV_PAR08 // Loja De ?													   |
| MV_PAR09 // Loja Ate ?												   |
| MV_PAR10 // Ordem ?													   |
| MV_PAR11 // Nome do Arquivo ?											   |
| MV_PAR12 // Diretório Destino ?										   |
| MV_PAR13 // Executa MS Excel ?										   |
==========================================================================*/
/*==========================================================================
|Funcao     | ConfPergs         | Bianca Massarotto     | Data | 04/10/11  |
============================================================================
|Descricao  | Configura automaticamente as perguntas utilizadas			   |
============================================================================
|Observações|  	                                                           |
==========================================================================*/
Static Function	ConfPergs(cPerg)
Local aPerg := {}
Local cOrd1 := "Nota Fiscal"
Local cOrd2 := "CFOP"

aAdd( aPerg,{ "Tipo ?" 	           ,"mv_ch1","N",01,0,0,"C",""				    ,"MV_PAR01","Saída","Entrada","Ambos","","",""      ,""				    ,"" } )
aAdd( aPerg,{ "Filial ?"           ,"mv_ch2","C",80,0,0,"G","U_VldSelFil()"	    ,"MV_PAR02",""     ,""       ,""     ,"","","SELFIL",Space(80)			,"" } )
aAdd( aPerg,{ "Data Inicio ?"      ,"mv_ch3","D",08,0,0,"G",""				    ,"MV_PAR03",""     ,""       ,""     ,"","",""      ,""				    ,"" } )
aAdd( aPerg,{ "Data Fim ?"         ,"mv_ch4","D",08,0,0,"G",""				    ,"MV_PAR04",""     ,""       ,""     ,"","",""      ,""				    ,"" } )
aAdd( aPerg,{ "CFOP ?"             ,"mv_ch5","C",80,0,0,"G",""	 			    ,"MV_PAR05",""     ,""       ,""     ,"","",""      ,Space(80)			,"" } )
aAdd( aPerg,{ "Cli./For. De ?"     ,"mv_ch6","C",06,0,0,"G",""	 			    ,"MV_PAR06",""     ,""       ,""     ,"","",""      ,Space(06)			,"" } )
aAdd( aPerg,{ "Cli./For. Ate ?"    ,"mv_ch7","C",06,0,0,"G",""	 			    ,"MV_PAR07",""     ,""       ,""     ,"","",""      ,"ZZZZZZ"			,"" } )
aAdd( aPerg,{ "Loja De ?"          ,"mv_ch8","C",02,0,0,"G",""	 			    ,"MV_PAR08","Sim"  ,"Nao"    ,""     ,"","",""      ,Space(02)			,"" } )
aAdd( aPerg,{ "Loja Até ?"         ,"mv_ch9","C",02,0,0,"G",""	 			    ,"MV_PAR09","Sim"  ,"Nao"    ,""     ,"","",""      ,"ZZ"				,"" } )
aAdd( aPerg,{ "Ordem Por ?"	       ,"mv_cha","N",01,0,0,"C",""	 			    ,"MV_PAR10",cOrd1  ,cOrd2    ,""     ,"","",""      ,""				    ,"" } )
aAdd( aPerg,{ "Nome do Arquivo ?"  ,"mv_chb","C",40,0,0,"G",""                  ,"MV_PAR11",""     ,""       ,""     ,"","",""      ,""				    ,"" } )
aAdd( aPerg,{ "Diretório Destino ?","mv_chc","C",80,0,0,"G","U_ChkPName(,2,.T.)","MV_PAR12",""     ,""       ,""     ,"","","SELDIR",PadR("C:\TEMP\",80),"" } )
aAdd( aPerg,{ "Executa MS Excel ?" ,"mv_chd","N",01,0,1,"C",""                  ,"MV_PAR13","Sim"  ,"Não"    ,""     ,"","",""      ,""				    ,"" } )

//Ajusta o dicionario SX1 corrigindo ou inserido as perguntas necessárias
U_ConfigSx1(cPerg, aPerg)

Return .T.

/*==========================================================================
|Funcao     | GeraExcel         | Bianca Massarotto     | Data | 04/10/11  |
============================================================================
|Descricao  | Executa a geração da planilha excel						   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function GeraExcel()
Local lRet, lAbreExl
Local dDataIni, dDataFim
Local cFiliais, cCFOP, cClFrIni, cClFrFim, cLojaIni, cLojaFim
Local cOrdem, cTipo, cFile, cRmtPath, cSrvPath

//Guarda parametros em variáveis
cTipo		:= IIf(MV_PAR01 != 1, IIf(MV_PAR01 != 2, "A", "E"), "S")
cFiliais  	:= Alltrim(MV_PAR02)
dDataIni	:= MV_PAR03
dDataFim 	:= MV_PAR04
cCFOP		:= Alltrim(MV_PAR05)
cClFrIni	:= Alltrim(MV_PAR06)
cClFrFim	:= Alltrim(MV_PAR07)
cLojaIni	:= Alltrim(MV_PAR08)
cLojaFim	:= Alltrim(MV_PAR09)
cOrdem		:= IIf(MV_PAR10 == 1, StrZero(1,1), StrZero(2,1) )
cFile		:= AllTrim(MV_PAR11)
cRmtPath	:= AllTrim(MV_PAR12)
lAbreExl	:= IIf(MV_PAR13 == 1, .T., .F.)

If dDataIni > dDataFim
	Aviso("Atenção!","A Data Inicial não pode ser maior que a Data Final!",{"Ok"})
	Return .F.
EndIf

If Empty(cFiliais)
	Aviso("Atenção!","Nenhuma Filial foi selecionada!",{"Ok"})
	Return .F.
EndIf

If Empty(dDataIni)
	Aviso("Atenção!","Data Inicial em branco!",{"Ok"})
	Return .F.
EndIf

If Empty(dDataFim)
	Aviso("Atenção!","Data Final em branco!",{"Ok"})
	Return .F.
EndIf

If !U_ChkFiliais(cFiliais, .F.)
	Return .F.
EndIf

If Empty(cFile)
	cFile := "Auditoria de NFs Sintetico"
	cFile += " " + GetDtDesc(dDataIni, dDataFim) + " " + GetDescFil(cFiliais)
	cFile := U_ToFName(cFile)
EndIf

If !U_ChkFName(cFile)
	Return .F.
EndIf

If !U_ChkPName(cRmtPath, 2, .T.)
	Return .F.
EndIf

cFile += ".xls"

If Right(cRmtPath, 1) != "\"
	cRmtPath += "\"
EndIf

cSrvPath := "/relato/"

lRet := CriaXLS(cFile, cSrvPath, @cRmtPath, cFiliais, dDataIni, dDataFim, cCFOP, cClFrIni, cClFrFim, cLojaIni, cLojaFim, cOrdem, cTipo)

If lRet
	If lAbreExl
		lRet := U_OpenXLSFile(cRmtPath+cFile)
	Else
		Aviso("Atenção", "O arquivo Excel [" + cFile + "] foi criado com sucesso no diretório [" + cRmtPath + "]!", {"Ok"})
	EndIf
EndIf

Return lRet

/*==========================================================================
|Funcao     | CriaXLS           | Bianca Massarotto     | Data | 03/03/10  |
============================================================================
|Descricao  | Processa a criação do arquivo excel no servidor selecionando |
|           | os dados segundo os parametros passados					   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function CriaXLS(cFile, cSrvPath, cRmtPath, cFiliais, dDataIni, dDataFim, cCFOP, cClFrIni, cClFrFim, cLojaIni, cLojaFim, cOrdem, cTipo)
Local lRet
Local oExcelCLS
Local aCampos
Local aWrkSht	 := {}

oExcelCLS := TExcelCLS():New()

If !oExcelCLS:Create(cSrvPath+cFile)
	MsgStop("Não foi possível criar o arquivo excel!")
	Return .F.
EndIf

//Seleção de dados
Processa({|| lRet := SelDados(@aWrkSht, cFiliais, dDataIni, dDataFim, cCFOP, cClFrIni, cClFrFim, cLojaIni, cLojaFim, cOrdem, cTipo)}, "Selecionando Dados...")

//Criação da planilha
If lRet
	Processa({|| lRet := GeraXLS(oExcelCLS, aWrkSht, cOrdem)}, "Criando planilha...")
EndIf

oExcelCLS:Close()

//Transfere planilha excel
If lRet
	Processa({|| lRet := U_CpyXLS2Rmt(cSrvPath, cFile, @cRmtPath)}, "Transferindo Planilha Excel...")
EndIf

fErase(cSrvPath+cFile)

Return lRet

/*==========================================================================
|Funcao     | SelDados          | Bianca Massarotto     | Data | 04/10/11  |
============================================================================
|Descricao  | Executa a seleção dos dados na base de dados SQL 			   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function SelDados(aWrkSht, cFiliais, dDataIni, dDataFim, cCFOP, cClFrIni, cClFrFim, cLojaIni, cLojaFim, cOrdem, cTipo)
Local cQuery     := ""
Local cIndice	 := ""
Local cAlias	 := ""
Local cArq       := ""
Local cNameWrk	 := ""
Local cPgHeader	 := ""
Local cTitulo	 := ""
Local nMgrFooter := 0.3
Local nMgrHeader := 0.5
Local nPgBottom	 := 0.5
Local nPgLeft 	 := 1.2
Local nPgRight	 := 1.2
Local nPrtScale	 := 80
Local nPgTop	 := 1
Local aCpoDef	 := {}

ProcRegua(5)

aCpoDef	:= {}
aAdd( aCpoDef, { "FILIAL"	, "C" , 002 , 0 } )
aAdd( aCpoDef, { "TIPO"		, "C" , 001 , 0 } )
aAdd( aCpoDef, { "DOC"		, "C" , 009 , 0 } )
aAdd( aCpoDef, { "SERIE"  	, "C" , 003 , 0 } )
aAdd( aCpoDef, { "EMISSAO"	, "C" , 008 , 0 } )
aAdd( aCpoDef, { "CLIFOR"	, "C" , 006 , 0 } )
aAdd( aCpoDef, { "LOJA"		, "C" , 002 , 0 } )
aAdd( aCpoDef, { "CGC"	 	, "C" , 014 , 0 } )
aAdd( aCpoDef, { "NOME"		, "C" , 040 , 0 } )
If cOrdem == "2"
	aAdd( aCpoDef, { "CFOP"	, "C" , 004 , 0 } )
EndIf
aAdd( aCpoDef, { "TOTAL"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "VALDESC"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "VLRSEG"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "VLRFRE"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "VLRDES"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "BASEISS"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "VALISS"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "BASEINS"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "VALINS"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "BASEIRR"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "VALIRR"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "BASEICM"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "VALICM"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "ICMSRET"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "BASEIPI"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "VALIPI"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "BASIMP5"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "VALIMP5"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "BASECOF"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "VALCOF"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "BASIMP6"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "VALIMP6"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "BASEPIS"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "VALPIS"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "BASECSL"	, "N" , 018 , 2 } )
aAdd( aCpoDef, { "VALCSL"	, "N" , 018 , 2 } )

cIndice := IIf( cOrdem == "1" , "FILIAL+CLIFOR+LOJA+DOC+SERIE" , "FILIAL+DOC+SERIE+CLIFOR+LOJA+CFOP" )

If cTipo == "A" .Or. cTipo == "S" //Saídas

	IncProc()
	cArq    := CriaTrab(,.F.)
	cAlias  := SubStr(cArq, 1, 8)
	
	//Chamada da Stored Procedure
	IncProc()
	cQuery  := "EXEC SP_PLANILHA_NOTAS_FISCAIS_AUDITORIA_SINTETICO_SEL '" + cFiliais + "','" + DtoS(dDataIni) + "','" + DtoS(dDataFim) + "','" +;
	                                                                        cClFrIni + "','" + cClFrFim       + "','" +;
	                                                                        cLojaIni + "','" + cLojaFim       + "','" +;
	                                                                        "S"      + "','" + cOrdem         + "','" + cCFOP + "'"
	TCQUERY cQuery NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	
	IncProc()
	U_fSetField(aCpoDef, cAlias, .F.)
	
	IncProc()
	Copy To &cArq
	(cAlias)->( dbCloseArea() )
	
	dbUseArea(.T.,, cArq, cAlias, .T. )
	Index on &cIndice To (cAlias)
	
	If !(cAlias)->(Eof())
		cTitulo  := "Auditoria de Notas Fiscais - Saídas"
		cNameWrk := "NF Saídas"
		
		AAdd(aWrkSht, { cNameWrk,cTitulo,cAlias,4,3,cPgHeader,XLS_PAGE_LANDSCAPE,nPrtScale,nMgrHeader,nMgrFooter,;
		                nPgTop,nPgBottom,nPgLeft,nPgRight,,,DefCols(cOrdem,1),cArq,"S" } )
	EndIf
EndIf

If cTipo == "A" .Or. cTipo == "E" //Entradas

	IncProc()
	cArq    := CriaTrab(,.F.)
	cAlias  := SubStr(cArq, 1, 8)
	
	//Chamada da Stored Procedure
	IncProc()
	cQuery  := "EXEC SP_PLANILHA_NOTAS_FISCAIS_AUDITORIA_SINTETICO_SEL '" + cFiliais + "','" + DtoS(dDataIni) + "','" + DtoS(dDataFim) + "','" +;
	                                                                        cClFrIni + "','" + cClFrFim       + "','" +;
	                                                                        cLojaIni + "','" + cLojaFim       + "','" +;
	                                                                        "E"      + "','" + cOrdem         + "','" + cCFOP + "'"
	TCQUERY cQuery NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	
	IncProc()
	U_fSetField(aCpoDef, cAlias, .F.)
	
	IncProc()
	Copy To &cArq
	(cAlias)->( dbCloseArea() )
	
	dbUseArea(.T.,, cArq, cAlias, .T. )
	Index on &cIndice To (cAlias)
    
	If !(cAlias)->(Eof())
		cTitulo  := "Auditoria de Notas Fiscais - Entradas"
		cNameWrk := "NF Entradas"
		
		AAdd(aWrkSht, { cNameWrk,cTitulo,cAlias,4,3,cPgHeader,XLS_PAGE_LANDSCAPE,nPrtScale,nMgrHeader,nMgrFooter,;
		                nPgTop,nPgBottom,nPgLeft,nPgRight,,,DefCols(cOrdem,2),cArq,"E" } )
	EndIf
EndIf

If Len(aWrkSht) == 0
	MsgStop('Não existem dados para criar o arquivo excel no servidor!' )
	Return .F.
EndIf

Return .T.

/*==========================================================================
|Funcao     | DefCols           | Bianca Massarotto     | Data | 04/10/11  |
============================================================================
|Descricao  | Define as colunas da planila								   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function DefCols(cOrdem, nOpcx)
Local aCampos := {}

aAdd( aCampos, { "FILIAL"				, "C" , 002 , 0 , { { 1 , "Fl." ,,2						 } } , .T. , 025.00 , .F. , .T. , .F. } )
aAdd( aCampos, { {||fDefCpo("TIPO")}	, "C" , 015 , 0 , { { 1 , "Tp" ,,2	 	 	 			 } } , .T. , 090.00 , .F. , .T. , .F. } )
aAdd( aCampos, { "DOC"					, "C" , 009 , 0 , { { 1 , "NF" ,,2  	  			 	 } } , .T. , 060.00 , .F. , .T. , .F. } )
aAdd( aCampos, { "SERIE"				, "C" , 003 , 0 , { { 1 , "Serie" ,,2  			 		 } } , .T. , 035.00 , .F. , .T. , .F. } )
aAdd( aCampos, { {||fDefCpo("EMISSAO")}	, "D" , 008 , 0 , { { 1 , "Emissão" ,,2 				 } } , .T. , 050.00 , .F. , .T. , .F. } )
If nOpcx == 1
	aAdd( aCampos, { "CLIFOR"			, "C" , 006 , 0 , { { 1 , "Cód."+Chr(10)+"Cliente" ,,2	 } } , .T. , 045.00 , .F. , .T. , .F. } )
	aAdd( aCampos, { "LOJA"				, "C" , 002 , 0 , { { 1 , "Loja"+Chr(10)+"Cliente" ,,2	 } } , .T. , 045.00 , .F. , .T. , .F. } )
Else
	aAdd( aCampos, { "CLIFOR"			, "C" , 006 , 0 , { { 1 , "Cód."+Chr(10)+"Fornec." ,,2	 } } , .T. , 045.00 , .F. , .T. , .F. } )
	aAdd( aCampos, { "LOJA"				, "C" , 002 , 0 , { { 1 , "Loja"+Chr(10)+"Fornec." ,,2	 } } , .T. , 045.00 , .F. , .T. , .F. } )
EndIf
aAdd( aCampos, { "CGC"					, "C" , 014 , 0 , { { 1 , "CNPJ" ,,2					 } } , .T. , 070.00 , .F. , .T. , .F. } )
aAdd( aCampos, { "NOME"					, "C" , 040 , 0 , { { 1 , "Nome" ,,2					 } } , .T. , 250.00 , .F. , .T. , .F. } )
If cOrdem == "2"
	aAdd( aCampos, { "CFOP"				, "C" , 004 , 0 , { { 1 , "CFOP" ,,2				   	 } } , .T. , 040.00 , .F. , .T. , .F. } )
EndIf
aAdd( aCampos, { "TOTAL"				, "N" , 018 , 2 , { { 1 , "Valor"+Chr(10)+"Mercad." ,,2	 } } , .T. , 080.00 , .T. , .T. , .F. } )
aAdd( aCampos, { "VALDESC"				, "N" , 018 , 2 , { { 1 , "Valor"+Chr(10)+"Desconto" ,,2 } } , .T. , 080.00 , .T. , .T. , .F. } )
aAdd( aCampos, { "VLRSEG"				, "N" , 018 , 2 , { { 1 , "Valor"+Chr(10)+"Seguro" ,,2	 } } , .T. , 080.00 , .T. , .T. , .F. } )
aAdd( aCampos, { "VLRFRE"				, "N" , 018 , 2 , { { 1 , "Valor"+Chr(10)+"Frete" ,,2	 } } , .T. , 080.00 , .T. , .T. , .F. } )
aAdd( aCampos, { "VLRDES"				, "N" , 018 , 2 , { { 1 , "Valor"+Chr(10)+"Despesa" ,,2	 } } , .T. , 080.00 , .T. , .T. , .F. } )

aAdd( aCampos, { "BASEISS"	  			, "N" , 018 , 2 , { { 1 , "ISS" ,1,1 } , { 3 , "Base" 	 } } , .T. , 070.00 , .T. , .T. , .F. } )
aAdd( aCampos, { "VALISS"				, "N" , 018 , 2 , { { 3 , "Valor"	 					 } } , .T. , 070.00 , .T. , .T. , .F. } )

aAdd( aCampos, { "BASEINS"	  			, "N" , 018 , 2 , { { 1 , "INSS" ,1,1 } , { 3 , "Base" 	 } } , .T. , 070.00 , .T. , .T. , .F. } )
aAdd( aCampos, { "VALINS"				, "N" , 018 , 2 , { { 3 , "Valor"	 					 } } , .T. , 070.00 , .T. , .T. , .F. } )

aAdd( aCampos, { "BASEIRR"	  			, "N" , 018 , 2 , { { 1 , "IRRF" ,1,1 } , { 3 , "Base" 	 } } , .T. , 070.00 , .T. , .T. , .F. } )
aAdd( aCampos, { "VALIRR"				, "N" , 018 , 2 , { { 3 , "Valor"	 					 } } , .T. , 070.00 , .T. , .T. , .F. } )

aAdd( aCampos, { "BASEICM"   			, "N" , 018 , 2 , { { 1 , "ICMS" ,2,1 } , { 3 ,	"Base"	 } } , .T. , 070.00 , .T. , .T. , .F. } )
aAdd( aCampos, { "VALICM"				, "N" , 018 , 2 , { { 3 , "Valor"						 } } , .T. , 070.00 , .T. , .T. , .F. } )
aAdd( aCampos, { "ICMSRET"				, "N" , 018 , 2 , { { 3 , "Valor Ret."					 } } , .T. , 070.00 , .T. , .T. , .F. } )

aAdd( aCampos, { "BASEIPI"   			, "N" , 018 , 2 , { { 1 , "IPI" ,1,1 } , { 3 ,	"Base"	 } } , .T. , 070.00 , .T. , .T. , .F. } )
aAdd( aCampos, { "VALIPI"				, "N" , 018 , 2 , { { 3 , "Valor IPI"				  	 } } , .T. , 070.00 , .T. , .T. , .F. } )

aAdd( aCampos, { "BASIMP5"				, "N" , 018 , 2 , { { 1 , "COFINS" ,3 } , { 2 , "Apuração" , 1 } , { 3 , "Base" } } , .T. , 070.00 , .T. , .T. , .F. })
aAdd( aCampos, { "VALIMP5"				, "N" , 018 , 2 , { { 3 , "Valor"						 } } , .T. , 070.00 , .T. , .T. , .F. } )
aAdd( aCampos, { "BASECOF"				, "N" , 018 , 2 , { { 2 , "Retenção" , 1 } ,{ 3 , "Base" } } , .T. , 070.00 , .T. , .T. , .F. } )
aAdd( aCampos, { "VALCOF"				, "N" , 018 , 2 , { { 3 , "Valor"						 } } , .T. , 070.00 , .T. , .T. , .F. } )

aAdd( aCampos, { "BASIMP6"				, "N" , 018 , 2 , { { 1 , "PIS" ,3 } , { 2 , "Apuração" , 1 } , { 3 , "Base" } } , .T. , 070.00 , .T. , .T. , .F. })
aAdd( aCampos, { "VALIMP6"				, "N" , 018 , 2 , { { 3 , "Valor"						 } } , .T. , 070.00 , .T. , .T. , .F. } )
aAdd( aCampos, { "BASEPIS"				, "N" , 018 , 2 , { { 2 , "Retenção" , 1 } ,{ 3 , "Base" } } , .T. , 070.00 , .T. , .T. , .F. } )
aAdd( aCampos, { "VALPIS"				, "N" , 018 , 2 , { { 3 , "Valor"						 } } , .T. , 070.00 , .T. , .T. , .F. } )

aAdd( aCampos, { "BASECSL" 				, "N" , 018 , 2 , { { 1 , "CSLL" ,1,1 } , { 3 , "Base"	 } } , .T. , 070.00 , .T. , .T. , .F. } )
aAdd( aCampos, { "VALCSL"				, "N" , 018 , 2 , { { 3 , "Valor"				 		 } } , .T. , 070.00 , .T. , .T. , .F. } )

Return { Nil , aCampos }

/*==========================================================================
|Funcao     | GeraXLS           | Bianca Massarotto     | Data | 04/10/11  |
============================================================================
|Descricao  | Gera o arquivo excel no servidor 							   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function GeraXLS(oExcelCLS, aWrkSht, cOrdem)
Local aCampos
Local bGetData
Local nArea := 0
Local nColIndex
Local nCt
Local nHeader
Local nWrk
Local oStyleFil
Local oStyleTit
Local cAlias
Local cArq
Local cTpArq

//Define estilos para os cabeçalhos
oStyleTit := oExcelCLS:AddStyle("D0")
oStyleTit:GetFont():cFontName	:= "Swiss"
oStyleTit:GetFont():nSize		:= 20
oStyleTit:GetFont():nAttrib 	:= XLS_FONT_BOLD

ProcRegua( Len(aWrkSht) )

For nWrk:=1 To Len(aWrkSht)

	IncProc()

	cAlias := aWrkSht[nWrk][3]
	cArq   := aWrkSht[nWrk][18]

	nArea  := Select(aWrkSht[nWrk][3])
	
	//Cria planilha
	oExcelCLS:AddWrkSheet( aWrkSht[nWrk][1],aWrkSht[nWrk][4],,,aWrkSht[nWrk][5],aWrkSht[nWrk][6],,aWrkSht[nWrk][7],;
							aWrkSht[nWrk][8],aWrkSht[nWrk][9],aWrkSht[nWrk][10],aWrkSht[nWrk][11],aWrkSht[nWrk][12],;
							aWrkSht[nWrk][13],aWrkSht[nWrk][14],,,aWrkSht[nWrk][15],,aWrkSht[nWrk][16] )
	
	nNumCols  := aWrkSht[nWrk][17][1]
	aCampos   := aWrkSht[nWrk][17][2]
	nColIndex := 0
	
	For nCt := 1 To Len(aCampos)
		If aCampos[nCt][9]
			nColIndex ++
			
			If ValType(aCampos[nCt][6]) == "L" .And. aCampos[nCt][6]
				If ValType(aCampos[nCt][1]) == "B"
					bGetData := aCampos[nCt][1]
				Else
					bGetData := FieldWBlock(aCampos[nCt][1],nArea)
				EndIf
			Else
				bGetData := Nil
			EndIf
			
			oExcelCLS:GetWrkSheet():AddColumn(IIf(ValType(aCampos[nCt][5]) == "C",aCampos[nCt][5],""),aCampos[nCt][2],aCampos[nCt][3],aCampos[nCt][4],,,,,IIf(Len(aCampos[nCt])>=7,aCampos[nCt][7],Nil),bGetData)
			
			If ValType(aCampos[nCt][5]) == "A"
				For nHeader := 1 To Len(aCampos[nCt][5])
					oExcelCLS:GetWrkSheet():GetColumn(nColIndex):SetHeader(aCampos[nCt][5][nHeader][1],aCampos[nCt][5][nHeader][2],;
																			IIf(Len(aCampos[nCt][5][nHeader])>=3,aCampos[nCt][5][nHeader][3],Nil),;
																			IIf(Len(aCampos[nCt][5][nHeader])>=4,aCampos[nCt][5][nHeader][4],Nil) )
				Next nHeader
			EndIf
			
			If aCampos[nCt][2] == "C"
				oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleCol:cFormat := "@"
			ElseIf aCampos[nCt][2] == "D"
				oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleCol:cFormat := "dd/mm/yyyy"
			ElseIf aCampos[nCt][2] == "N"
				oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleCol:nAlignH := XLS_ALIGNH_RIGHT
			EndIf
			
			If aCampos[nCt][10]
				oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleHdr:GetBorder(1):nWeight := 2
				oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleHdr:GetBorder(2):nWeight := 2
				oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleHdr:GetBorder(3):nWeight := 2
				oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleHdr:GetBorder(4):nWeight := 2
			EndIf
			
			oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleHdr:lWrapText := .T.
			oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleHdr:nAlignH := XLS_ALIGNH_CENTER
			oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleHdr:nAlignV := XLS_ALIGNV_CENTER
			
			oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleTot:xColor := "#CCFFCC"
			oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleTot:SetBorders(XLS_BORDER_MSK_TOP+XLS_BORDER_MSK_BOTTOM)
			oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleTot:GetFont():cFontName := "Swiss"
			oExcelCLS:GetWrkSheet():GetColumn(nColIndex):oStyleTot:GetFont():nAttrib   := XLS_FONT_BOLD
			
		EndIf
	Next nCt
Next nWrk

ProcRegua( Len(aWrkSht) )

//Imprime detalhes
For nWrk:=1 To Len(aWrkSht)
	
	IncProc()
	
	If nWrk==1
		oExcelCLS:SetWrkSht(nWrk)
	Else
		oExcelCLS:NextWrkSht()
	EndIf

	cAlias  := aWrkSht[nWrk][3]
	cArq    := aWrkSht[nWrk][18]
	aCampos := aWrkSht[nWrk][17][2]
	cTpArq  := aWrkSht[nWrk][19]
	
	oExcelCLS:GetWrkSheet():NewRow()
	oExcelCLS:GetWrkSheet():NewCell(aWrkSht[nWrk][2],,oStyleTit:GetCodigo())
	oExcelCLS:GetWrkSheet():EndRow()
	oExcelCLS:GetWrkSheet():WrtHdrCols()
	
	DbSelectArea(cAlias)
	(cAlias)->( DbGoTop() )
	
	//Imprime detalhes
	fImpDet(oExcelCLS, cAlias, aCampos, cOrdem, cTpArq)
	
	//Fecha tabela temporaria da Filial
	(cAlias)->( dbCloseArea() )
	fErase( cArq + GetDbExtension() )

Next nWrk

Return .T.

/*==========================================================================
|Funcao     | GetDtDesc         | Bianca Massarotto     | Data | 04/10/11  |
============================================================================
|Descricao  | Pega data de seleção para o cabeçalho da planilha			   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function GetDtDesc(dDataIni, dDataFim)
Local cRet
Local lDeAte := .F.

If Day(dDataIni) != 1
	lDeAte := .T.
EndIf

If LastDay(dDataFim) != dDataFim
	lDeAte := .T.
EndIf

If lDeAte
	cRet := DtoC(dDataIni) + " a " + DtoC(dDataFim)
Else
	If Year(dDataIni) != Year(dDatafim)
		cRet := U_fNomeMes(Month(dDataIni), .F.) + "/" + AllTrim(Str(Year(dDataIni))) + " a " + U_fNomeMes(Month(dDataFim), .F.) + "/" + AllTrim(Str(Year(dDataFim)))
	Else
		If Month(dDataIni) != Month(dDatafim)
			cRet := U_fNomeMes(Month(dDataIni), .F.) + " a " + U_fNomeMes(Month(dDataFim), .F.) + " de " + AllTrim(Str(Year(dDataIni)))
		Else
			cRet := U_fNomeMes(Month(dDataIni), .F.) + " de " + AllTrim(Str(Year(dDataIni)))
		EndIf
	EndIf
EndIf

Return cRet

/*==========================================================================
|Funcao     | GetDescFil        | Bianca Massarotto     | Data | 04/10/11  |
============================================================================
|Descricao  | Pega filiais de seleção para o cabeçalho da planilha		   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function GetDescFil(cFiliais)
Local cRet := IIF(At(",", cFiliais) > 0, "Filiais" , "Filial") + " " + cFiliais
Local nCt  := Rat(",", cRet)

If nCt > 0
	cRet := Left(cRet, nCt-1) + " e " + SubStr(cRet, nCt+1)
EndIf

Return cRet

/*==========================================================================
|Funcao     | fTipoNF           | Bianca Massarotto     | Data | 04/10/11  |
============================================================================
|Descricao  | Descrição do Tipo de NF									   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function fDefCpo(cCampo)
Local cRetorno := ""

Do Case
	Case cCampo == "EMISSAO"
		cRetorno := StoD(&cCampo)
	Case cCampo == "TIPO"
		If &cCampo == "N"
			cRetorno := "Normal"
		ElseIf &cCampo == "C"
			cRetorno := "Compl.Preço/Frete"
		ElseIf &cCampo == "P"
			cRetorno := "Compl.IPI"
		ElseIf &cCampo == "I"
			cRetorno := "Compl.ICMS"
		ElseIf &cCampo == "D"
			cRetorno := "Devolução"
		ElseIf &cCampo == "B"
			cRetorno := "Beneficiamento"
		EndIf
EndCase

Return cRetorno

/*==========================================================================
|Funcao     | fImpDet           | Bianca Massarotto     | Data | 04/10/11  |
============================================================================
|Descricao  | Imprime Detalhes											   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function fImpDet(oExcelCLS, cAlias, aCampos, cOrdem, cTpArq)
Local cFilFat, cTDesc, cDFilFat
Local nRowIni, nRowAtu
Local bSeek, cSeek
Local aRowOrd := Array(Len(aCampos))
Local aRowFil := Array(Len(aCampos))
Local aRowTot := Array(Len(aCampos))


(cAlias)->(DbGoTop())
While (cAlias)->(!Eof())
	
	//Quebra por Filial
	cFilFat	   := (cAlias)->FILIAL
	cDFilFat   := Upper(GetAdvFVal("SM0", "M0_NOME", cEmpAnt+cFilFat, 1, ""))
    aRowFil    := Array(Len(aCampos))
    aRowFil[1] := "TOTAL DA FILIAL ["+cFilFat+"-"+cDFilFat+"]:"

	While (cAlias)->(!Eof()) .And. cFilFat == (cAlias)->FILIAL

		//Quebra pela Ordem
		cSeek      := IIf( cOrdem == "1" , (cAlias)->(FILIAL+CLIFOR+LOJA) , (cAlias)->(FILIAL+DOC+SERIE+CLIFOR+LOJA) )
		bSeek      := IIf( cOrdem == "1" , {||(cAlias)->(FILIAL+CLIFOR+LOJA) == cSeek} , {||(cAlias)->(FILIAL+DOC+SERIE+CLIFOR+LOJA) == cSeek} )
   	    cTDesc     := IIF( cOrdem == "1" , IIf( cTpArq == "S","TOTAL POR CLIENTE","TOTAL POR FORNECEDOR")+"  ["+(cAlias)->CLIFOR+"-"+(cAlias)->LOJA+"]:",;
   	                                       "TOTAL DA NF:" )
   	    aRowOrd    := Array(Len(aCampos))
   	    aRowOrd[1] := cTDesc

		While (cAlias)->(!Eof()) .And. Eval(bSeek)
			//Soma Totais
			For nCt := 1 To Len(aCampos)
				If aCampos[nCt][8]
					aRowOrd[nCt] := IIf( aRowOrd[nCt] == Nil, (cAlias)->&(aCampos[nCt][1]), aRowOrd[nCt]+(cAlias)->&(aCampos[nCt][1]) )
					aRowFil[nCt] := IIf( aRowFil[nCt] == Nil, (cAlias)->&(aCampos[nCt][1]), aRowFil[nCt]+(cAlias)->&(aCampos[nCt][1]) )
					aRowTot[nCt] := IIf( aRowTot[nCt] == Nil, (cAlias)->&(aCampos[nCt][1]), aRowTot[nCt]+(cAlias)->&(aCampos[nCt][1]) )
				EndIf
			Next nCt
			//Adiciona Linha
			oExcelCLS:GetWrkSheet():AddRowData()
			(cAlias)->(DbSkip())
		EndDo
		//Total por Ordem
		oExcelCLS:GetWrkSheet():AddRowForm(aRowOrd,, -3)
		oExcelCLS:GetWrkSheet():AddRowsBlk()
	EndDo
	//Total por Filial
	oExcelCLS:GetWrkSheet():AddRowForm(aRowFil,, -3)
	oExcelCLS:GetWrkSheet():AddRowsBlk()
	oExcelCLS:GetWrkSheet():AddRowsBlk()
EndDo
//Total GERAL
aRowTot[1] := "TOTAL GERAL:"
oExcelCLS:GetWrkSheet():AddRowForm(aRowTot,, -3)

Return