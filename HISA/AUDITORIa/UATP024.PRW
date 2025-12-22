#INCLUDE "rwmake.ch"
#INCLUDE "Vkey.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "ExcelCLS.ch"
#INCLUDE "Protheus.ch"

/*==========================================================================
|Funcao     | UATP024   | Autor | Bianca Massarotto    | Data | 14/06/11   |
============================================================================
|Descricao  | Gera planilha excel                                          |
|           | Relatório Auditoria de Notas Fiscais						   |
============================================================================
|Modulo     | Faturamento                                                  |
============================================================================
|Observações|															   |
==========================================================================*/
User Function UATP024()

Local	aArea		:= GetArea()
Local	nOpca		:= 0
Local	aSays		:= {}
Local	aButtons	:= {}
Local	cPerg		:= "UTP024"
Private cCadastro	:= "Geração de Planilha - Relatório Auditoria de Notas Fiscais - Analítico"

// If !u_ChkFunc( Replace( ProcName(), "U_", ""),,,, "a " + cCadastro )
// 	Return                                       
// EndIf

//Configura e Inicializa a rotina
ConfPergs(cPerg)
Pergunte(cPerg, .F.)

aAdd(aSays, "Este programa tem o objetivo de gerar a Planilha em Excel")
aAdd(aSays, "com o Relatório Auditoria de Notas Fiscais no computador" )
aAdd(aSays, "do usuário."                                              )
aAdd(aButtons, {5, .T., {|| Pergunte(cPerg, .T.)   }})
aAdd(aButtons, {1, .T., {|o| nOpca:=1, o:oWnd:End()}})
aAdd(aButtons, {2, .T., {|o| o:oWnd:End()          }})

While .T.
	nOpca := 0
	FormBatch(cCadastro, aSays, aButtons)
	Do Case
		Case nOpcA == 1
			If GeraExcel()
				Exit
			EndIf
		Otherwise
			Exit
	EndCase
EndDo

RestArea( aArea )

Return

/*==========================================================================
| Parametros												   			            |
+--------------------------------------------------------------------------+
| MV_PAR01 // Tipo ?	       											        |
| MV_PAR02 // Filiais ?       											        |
| MV_PAR03 // Data Inicial ?											        |
| MV_PAR04 // Data Final ?												        |
| MV_PAR05 // CFOP ?													   	        |
| MV_PAR06 // NCM ?														        |
| MV_PAR07 // Conta Contabil ?											        |
| MV_PAR08 // Itens de Conta ?											        |
| MV_PAR09 // Impostos ?  												        |
| MV_PAR10 // Fiscal ?    												        |
| MV_PAR11 // Contabil ?  												        |
| MV_PAR12 // Imprime Descrições ?										        |
| MV_PAR13 // Imprime Totalizadores ?									        |
| MV_PAR14 // Ordem ?													        |
| MV_PAR15 // Imprime País ?											        |
| MV_PAR16 // Nome do Arquivo ?											        |
| MV_PAR17 // Diretório Destino ?										        |
| MV_PAR18 // Executa MS Excel ?										        |
==========================================================================*/
/*==========================================================================
|Funcao     | ConfPergs         | Bianca Massarotto     | Data | 14/06/11  |
============================================================================
|Descricao  | Configura automaticamente as perguntas utilizadas			   |
============================================================================
|Observações|  	                                                           |
==========================================================================*/
Static Function	ConfPergs(cPerg)

Local aPerg := {}
Local cOrd1 := "Emissão"
Local cOrd2 := "Conta Contábil"
Local cOrd3 := "Item Contábil"

aAdd(aPerg,{"Tipo ?" 	             ,"mv_ch1","N",01,0,0,"C",""				  ,"MV_PAR01","Saída","Entrada","Ambos","","",""      ,""					,""})
aAdd(aPerg,{"Filial ?"               ,"mv_ch2","C",80,0,0,"G","U_VldSelFil()"	  ,"MV_PAR02",""     ,""       ,""     ,"","","SELFIL",Space(80)			,""})
aAdd(aPerg,{"Data Inicio ?"          ,"mv_ch3","D",08,0,0,"G",""				  ,"MV_PAR03",""     ,""       ,""     ,"","",""      ,""					,""})
aAdd(aPerg,{"Data Fim ?"             ,"mv_ch4","D",08,0,0,"G",""				  ,"MV_PAR04",""     ,""       ,""     ,"","",""      ,""					,""})
aAdd(aPerg,{"Cli/For de ?"           ,"mv_ch5","C",06,0,0,"G",""				  ,"MV_PAR05",""     ,""       ,""     ,"","",""      ,"      "				,""})
aAdd(aPerg,{"Cli/For até ?"          ,"mv_ch6","C",06,0,0,"G",""				  ,"MV_PAR06",""     ,""       ,""     ,"","",""      ,"ZZZZZZ"				,""})
aAdd(aPerg,{"Loja de ?"              ,"mv_ch7","C",02,0,0,"G",""				  ,"MV_PAR07",""     ,""       ,""     ,"","",""      ,"  "					,""})
aAdd(aPerg,{"Loja até ?"          	 ,"mv_ch8","C",02,0,0,"G",""				  ,"MV_PAR08",""     ,""       ,""     ,"","",""      ,"ZZ"					,""})
aAdd(aPerg,{"CFOP ?"                 ,"mv_ch9","C",80,0,0,"G",""	 			  ,"MV_PAR09",""     ,""       ,""     ,"","",""      ,Space(80)			,""})
aAdd(aPerg,{"NCM ?"                  ,"mv_cha","C",10,0,0,"G",""	 			  ,"MV_PAR10",""     ,""       ,""     ,"","","SYD"   ,Space(10)			,""})
aAdd(aPerg,{"Conta Contábil ?"       ,"mv_chb","C",20,0,0,"G",""	 			  ,"MV_PAR11",""     ,""       ,""     ,"","","CT1"   ,Space(20)			,""})
aAdd(aPerg,{"Itens de Conta ?"       ,"mv_chc","C",80,0,0,"G",""	 			  ,"MV_PAR12",""     ,""       ,""     ,"","",""      ,Space(80)			,""})
aAdd(aPerg,{"Impostos ?"             ,"mv_chd","N",01,0,0,"C",""	 			  ,"MV_PAR13","Sim"  ,"Nao"    ,""     ,"","",""      ,""					,""})
aAdd(aPerg,{"Fiscal ?"               ,"mv_che","N",01,0,0,"C",""	 			  ,"MV_PAR14","Sim"  ,"Nao"    ,""     ,"","",""      ,""					,""})
aAdd(aPerg,{"Contabil ?"             ,"mv_chf","N",01,0,0,"C",""	 			  ,"MV_PAR15","Sim"  ,"Nao"    ,""     ,"","",""      ,""					,""})
aAdd(aPerg,{"Imprime Descrições ?"   ,"mv_chg","N",01,0,0,"C",""	 			  ,"MV_PAR16","Sim"  ,"Não"    ,""     ,"","",""      ,""					,""})
aAdd(aPerg,{"Imprime Totalizadores ?","mv_chh","N",01,0,0,"C",""	 			  ,"MV_PAR17","Sim"  ,"Não"    ,""     ,"","",""      ,""					,""})
aAdd(aPerg,{"Ordem ?"			     ,"mv_chi","N",01,0,0,"C",""	 			  ,"MV_PAR18",cOrd1  ,cOrd2    ,cOrd3  ,"","",""      ,""					,""})
aAdd(aPerg,{"Imprime País ?"	     ,"mv_chj","N",01,0,0,"C",""	 			  ,"MV_PAR19","Não"  ,"Sim"    ,""     ,"","",""      ,""					,""})
aAdd(aPerg,{"Nome do Arquivo ?"      ,"mv_chl","C",40,0,0,"G",""                  ,"MV_PAR20",""     ,""       ,""     ,"","",""      ,""					,""})
aAdd(aPerg,{"Diretório Destino ?"    ,"mv_chm","C",80,0,0,"G","U_ChkPName(,2,.T.)","MV_PAR21",""     ,""       ,""     ,"","","SELDIR",PadR("C:\TEMP\",80)	,""})
aAdd(aPerg,{"Executa MS Excel ?"     ,"mv_chn","N",01,0,1,"C",""                  ,"MV_PAR22","Sim"  ,"Não"    ,""     ,"","",""      ,""					,""})
aAdd(aPerg,{"Visualizar Colunas?"    ,"mv_cho","N",01,0,0,"C",""	 			  ,"MV_PAR23","Tipo Ent.Saida"  ,"Vencimentos"  ,""  ,"","",""      ,""	,""})

//Ajusta o dicionario SX1 corrigindo ou inserido as perguntas necessárias
U_ConfigSx1(cPerg, aPerg)

Return .T.

/*==========================================================================
|Funcao     | GeraExcel         | Bianca Massarotto     | Data | 14/06/11  |
============================================================================
|Descricao  | Executa a geração da planilha excel						   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function GeraExcel()

Local lRet		
Local lImposto 
Local lFiscal
Local lContab
Local lImpDesc
Local lTotal
Local dDataIni	:= Ctod("  /  /    ")
Local dDataFim	:= Ctod("  /  /    ")
Local cFiliais	:= ""
Local cCFOP		:= ""
Local cCtaCntb	:= ""
Local cItemCC	:= ""
Local cOrdem	:= ""
Local cNCM		:= ""
Local cCliForD	:= ""
Local cCliForA	:= ""
Local cLojaD	:= ""
Local cLojaA	:= ""
Local nTipo


//Guarda parametros em variáveis
nTipo		:= MV_PAR01
cFiliais  	:= Alltrim(MV_PAR02)
dDataIni	:= MV_PAR03
dDataFim 	:= MV_PAR04    
cCliForD	:= MV_PAR05
cCliForA	:= MV_PAR06
cLojaD		:= MV_PAR07
cLojaA		:= MV_PAR08
cCFOP		:= Alltrim(MV_PAR09)
cNCM		:= Alltrim(MV_PAR10)
cCtaCntb	:= Alltrim(MV_PAR11)
cItemCC		:= Alltrim(MV_PAR12)
lImposto	:= IIf(MV_PAR13 == 1, .T., .F.)
lFiscal		:= IIf(MV_PAR14 == 1, .T., .F.)
lContab		:= IIf(MV_PAR15 == 1, .T., .F.)
lImpDesc	:= IIf(MV_PAR16 == 1, .T., .F.)
lTotal		:= IIf(MV_PAR17 == 1, .T., .F.)
cOrdem		:= IIf(MV_PAR18 != 1, IIf(MV_PAR14 != 2, StrZero(3,1), StrZero(2,1) ), StrZero(1,1))
lPais		:= IIf(MV_PAR19 == 1, .F., .T.)
cFile		:= AllTrim(MV_PAR20)
cRmtPath	:= AllTrim(MV_PAR21)
lAbreExl	:= IIf(MV_PAR22 == 1, .T., .F.)

If dDataIni > dDataFim
	Aviso("Atenção!","A Data Inicial não pode ser maior que a Data Final!",{"Ok"})
	Return .F.
EndIf

If !U_ChkFiliais(cFiliais, .F.)
	Return .F.
EndIf

If Empty(cFile)
	cFile := "Auditoria de Notas Fiscais - Analitico"     //FR
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

lRet := CriaXLS(cFile, cSrvPath, @cRmtPath, cFiliais, dDataIni, dDataFim, cCFOP, cNCM, cCtaCntb, cItemCC, lImposto, lFiscal, lContab, lTotal, lImpDesc, cOrdem, nTipo, lPais, cCliForD, cCliForA, cLojaD, cLojaA)

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
Static Function CriaXLS(cFile, cSrvPath, cRmtPath, cFiliais, dDataIni, dDataFim, cCFOP, cNCM, cCtaCntb, cItemCC, lImposto, lFiscal, lContab, lTotal, lImpDesc, cOrdem, nTipo, lPais, cCliForD, cCliForA, cLojaD, cLojaA)

Local lRet
Local oExcelCLS
Local aCampos
Local aWrkSht	 := {}

oExcelCLS := TExcelCLS():New()
// oExcelCLS := FWMSExcel():New()
If !oExcelCLS:Create(cSrvPath+cFile)
	MsgStop("Não foi possível criar o arquivo excel!")
	Return .F.
EndIf

//Seleção de dados
Processa({|| lRet := SelDados(@aWrkSht, cFiliais, dDataIni, dDataFim, cCFOP, cNCM, cCtaCntb, cItemCC, cOrdem, nTipo, lImposto, lFiscal, lContab, lImpDesc, lPais, cCliForD, cCliForA, cLojaD, cLojaA)}, "Selecionando Dados...")

//Criação da planilha
If lRet
	Processa({|| lRet := GeraXLS(oExcelCLS, aWrkSht, lImposto, lFiscal, lContab, lTotal, cOrdem)}, "Criando planilha...")
EndIf

oExcelCLS:Close()

//Transfere planilha excel
If lRet
	Processa({|| lRet := U_CpyXLS2Rmt(cSrvPath, cFile, @cRmtPath)}, "Transferindo Planilha Excel...")
EndIf

fErase(cSrvPath+cFile)

Return lRet

/*==========================================================================
|Funcao     | SelDados          | Bianca Massarotto     | Data | 14/06/11  |
============================================================================
|Descricao  | Executa a seleção dos dados na base de dados SQL 			   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function SelDados(aWrkSht, cFiliais, dDataIni, dDataFim, cCFOP, cNCM, cCtaCntb, cItemCC, cOrdem, nTipo, lImposto, lFiscal, lContab, lImpDesc, lPais, cCliForD, cCliForA, cLojaD, cLojaA)

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
aAdd(aCpoDef, {"FILIAL"		, "C" , 002 , 0 })
aAdd(aCpoDef, {"TIPO"		, "C" , 001 , 0 })
aAdd(aCpoDef, {"DOC"		, "C" , 009 , 0 })
aAdd(aCpoDef, {"SERIE"  	, "C" , 003 , 0 })
aAdd(aCpoDef, {"ESPECIE" 	, "C" , 005 , 0 })
aAdd(aCpoDef, {"CHAVE"		, "C" , 044 , 0 })
aAdd(aCpoDef, {"ITEM"	 	, "C" , 002 , 0 })
aAdd(aCpoDef, {"EMISSAO"	, "C" , 008 , 0 })
aAdd(aCpoDef, {"DTDIGIT"	, "C" , 008 , 0 })
aAdd(aCpoDef, {"UF"			, "C" , 002 , 0 })
aAdd(aCpoDef, {"CLIFOR"		, "C" , 006 , 0 })
aAdd(aCpoDef, {"LOJA"		, "C" , 002 , 0 })
aAdd(aCpoDef, {"TPCLIFOR"	, "C" , 001 , 0 })
aAdd(aCpoDef, {"NOME"		, "C" , 040 , 0 })
aAdd(aCpoDef, {"CGC"	 	, "C" , 014 , 0 })
aAdd(aCpoDef, {"INSCR"		, "C" , 018 , 0 })
aAdd(aCpoDef, {"PAIS"	 	, "C" , 050 , 0 })
aAdd(aCpoDef, {"COD"	 	, "C" , 015 , 0 })
aAdd(aCpoDef, {"DESCRI"		, "C" , 040 , 0 })
aAdd(aCpoDef, {"FCICOD"		, "C" , 036 , 0 })
aAdd(aCpoDef, {"TPPROD"		, "C" , 002 , 0 })
aAdd(aCpoDef, {"UM"			, "C" , 002 , 0 })
aAdd(aCpoDef, {"NCM"		, "C" , 010 , 0 })
aAdd(aCpoDef, {"NATUREZ"	, "C" , 010 , 0 })
//aAdd(aCpoDef, {"DESCNAT"	, "C" , 030 , 0 })		//FR - 30/06/2015
//novas colunas:
//descrição natureza
//vencto
//valor título
//If MV_PAR23 == 2 //por Vencimento, oculta Tipo Ent. Saída
	aAdd(aCpoDef, {"VENCREA"	, "C" , 008 , 0 })
	aAdd(aCpoDef, {"VALORTIT"	, "N" , 018 , 2 }) 
//Endif

aAdd(aCpoDef, {"TES"		, "C" , 003 , 0 })
aAdd(aCpoDef, {"CFOP"		, "C" , 004 , 0 })
aAdd(aCpoDef, {"ORIGEM"		, "C" , 001 , 0 })
aAdd(aCpoDef, {"CLASFIS"	, "C" , 003 , 0 })
aAdd(aCpoDef, {"QUANT"		, "N" , 018 , 5 })
aAdd(aCpoDef, {"PRCVEN"		, "N" , 018 , 6 })
aAdd(aCpoDef, {"TOTAL"		, "N" , 018 , 2 })
aAdd(aCpoDef, {"VALDESC"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"VALCONT"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"VLRSEG"		, "N" , 018 , 2 })
aAdd(aCpoDef, {"VLRFRE"		, "N" , 018 , 2 })
aAdd(aCpoDef, {"VLRDES"		, "N" , 018 , 2 })
aAdd(aCpoDef, {"INDNTFR"	, "C" , 001 , 0 })
aAdd(aCpoDef, {"NFORIG"	    , "C" , 050 , 0 })
aAdd(aCpoDef, {"SERORIG"	, "C" , 015 , 0 })
aAdd(aCpoDef, {"BASEISS"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"ALQISS"		, "N" , 008 , 2 })
aAdd(aCpoDef, {"VALISS"		, "N" , 018 , 2 })
aAdd(aCpoDef, {"CODISS"		, "C" , 009 , 0 })
aAdd(aCpoDef, {"VENCISS"	, "C" , 008 , 0 }) //VENCTO ISS
aAdd(aCpoDef, {"NATISS"		, "C" , 010 , 2 }) //NATUREZA ISS
aAdd(aCpoDef, {"BASEINS"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"PINS"		, "N" , 008 , 2 })
aAdd(aCpoDef, {"VALINS"		, "N" , 018 , 2 })
aAdd(aCpoDef, {"BASEIRR"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"PIRR"		, "N" , 008 , 2 })
aAdd(aCpoDef, {"VALIRR"		, "N" , 018 , 2 })
aAdd(aCpoDef, {"BASEICM"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"ALQICM"		, "N" , 008 , 2 })
aAdd(aCpoDef, {"VALICM"		, "N" , 018 , 2 })
aAdd(aCpoDef, {"CLASFIS"	, "C" , 002 , 0 })

//#16920 - EF 057
//DIFAL TOTAL
aAdd(aCpoDef, {"DIFALTOT"	, "N" , 018 , 2 })
//% DIFAL ORIGEM               
If SD2->(FieldPos("D2_PDORI")) > 0
	aAdd(aCpoDef, {"PDORI" 		, "N" , TamSX3("D2_PDORI")[1]	,TamSX3("D2_PDORI")[2]	} )
Else
	aAdd(aCpoDef, {"PDORI" 		, "N" , 6, 2 } )
EndIf

//% DIFAL DESTINO
If SD2->(FieldPos("D2_PDDES")) > 0
	aAdd(aCpoDef, {"PDDES" 		, "N" , TamSX3("D2_PDDES")[1]	,TamSX3("D2_PDDES")[2]	} )
Else
	aAdd(aCpoDef, {"PDDES" 		, "N" , 6, 2	} )
EndIf                                      

//VALOR ICMS DIFAL ORIGEM
If SD2->(FieldPos("D2_ICMSCOM")) > 0
	aAdd(aCpoDef, {"VDIFORI" 	, "N" , TamSX3("D2_ICMSCOM")[1]	,TamSX3("D2_ICMSCOM")[2]} )
Else
	aAdd(aCpoDef, {"VDIFORI" 	, "N" , 14, 2 } )
EndIf

//VALOR ICMS DIFAL DESTINO
If SD2->(FieldPos("D2_DIFAL")) > 0
	aAdd(aCpoDef, {"VDIFDST" 	, "N" , TamSX3("D2_DIFAL")[1]	,TamSX3("D2_DIFAL")[2]  } ) 
Else 
	aAdd(aCpoDef, {"VDIFDST" 	, "N" , 14, 2 } ) 
EndIf

//VALOR FECP
If SD2->(FieldPos("D2_VFCPDIF")) > 0
	aAdd(aCpoDef, {"VFECP" 		, "N" , TamSX3("D2_VFCPDIF")[1]	,TamSX3("D2_VFCPDIF")[2]} ) 
Else
	aAdd(aCpoDef, {"VFECP" 		, "N" , 14, 2 } ) 
EndIf

//ICMS DIFAL DEST + FECP
aAdd(aCpoDef, {"VDIFECP"	, "N" , 018 , 2 })
//fim EF 057

aAdd(aCpoDef, {"BRICMS"		, "N" , 018 , 2 })
aAdd(aCpoDef, {"ALQDEST"	, "N" , 008 , 2 })
aAdd(aCpoDef, {"ICMSRET"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"ISENICM"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"OUTRICM"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"MVA"		, "N" , 018 , 2 })
aAdd(aCpoDef, {"BASEIPI"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"ALQIPI"		, "N" , 008 , 2 })
aAdd(aCpoDef, {"VALIPI"		, "N" , 018 , 2 })
aAdd(aCpoDef, {"CSTIPI"		, "C" , 002 , 0 })
aAdd(aCpoDef, {"ISENIPI"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"OUTRIPI"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"BASIMP5"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"ALQIMP5"	, "N" , 008 , 2 })
aAdd(aCpoDef, {"VALIMP5"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"BASECOF"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"ALQCOF"		, "N" , 008 , 2 })
aAdd(aCpoDef, {"VALCOF"		, "N" , 018 , 2 })
aAdd(aCpoDef, {"CSTCOF"		, "C" , 002 , 0 })
aAdd(aCpoDef, {"BASIMP6"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"ALQIMP6"	, "N" , 008 , 2 })
aAdd(aCpoDef, {"VALIMP6"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"BASEPIS"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"ALQPIS"		, "N" , 008 , 2 })
aAdd(aCpoDef, {"VALPIS"		, "N" , 018 , 2 })
aAdd(aCpoDef, {"CSTPIS"		, "C" , 002 , 0 })
aAdd(aCpoDef, {"BASECSL"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"ALQICSL"	, "N" , 008 , 2 })
aAdd(aCpoDef, {"VALCSLL"	, "N" , 018 , 2 })
aAdd(aCpoDef, {"CONTA"		, "C" , 020 , 0 })
aAdd(aCpoDef, {"DESCCTA"	, "C" , 040 , 0 })
aAdd(aCpoDef, {"ITEMCC"		, "C" , 009 , 0 })
aAdd(aCpoDef, {"DESCITEM"	, "C" , 020 , 0 })
aAdd(aCpoDef, {"CCUSTO"		, "C" , 090 , 0 })
aAdd(aCpoDef, {"DESCCUSTO"	, "C" , 090 , 0 })
aAdd(aCpoDef, {"CF"			, "C" , 004 , 0 })
aAdd(aCpoDef, {"TEXTO"		, "C" , 050 , 0 })
aAdd(aCpoDef, {"DUPLIC"		, "C" , 001 , 0 })
aAdd(aCpoDef, {"ESTOQUE"	, "C" , 001 , 0 })
aAdd(aCpoDef, {"PODER3"		, "C" , 001 , 0 })

//FR - 01/07/15 - parâmetro incluído por Flávia Rocha, onde dependendo da opção escolhida
//irá mostrar ou ocultar as colunas abaixo
//If MV_PAR23 == 1 //por Tipo Ent. Saída, oculta Vencimentos

	aAdd(aCpoDef, {"ICM"		, "C" , 001 , 0 })
	aAdd(aCpoDef, {"CREDICM"	, "C" , 001 , 0 })
	aAdd(aCpoDef, {"LFICM"		, "C" , 001 , 0 })
	aAdd(aCpoDef, {"LFICMST"	, "C" , 001 , 0 })
	aAdd(aCpoDef, {"SITTRIB"	, "C" , 002 , 0 })
	
	aAdd(aCpoDef, {"IPI"		, "C" , 001 , 0 })
	aAdd(aCpoDef, {"CREDIPI"	, "C" , 001 , 0 })
	aAdd(aCpoDef, {"LFIPI"		, "C" , 001 , 0 })
	aAdd(aCpoDef, {"DESTACA"	, "C" , 001 , 0 })
	aAdd(aCpoDef, {"CTIPI"		, "C" , 002 , 0 })
//Endif

aAdd(aCpoDef, {"PISCOF"		, "C" , 020 , 0 })
aAdd(aCpoDef, {"PISCRED"	, "C" , 020 , 0 })
aAdd(aCpoDef, {"CTPIS"		, "C" , 002 , 0 })
aAdd(aCpoDef, {"CTCOF"		, "C" , 002 , 0 })
aAdd(aCpoDef, {"CODBCC"		, "C" , 002 , 0 })

If nTipo == 1 .Or. nTipo == 3 //Saídas

	IncProc()
	cArq    := CriaTrab(,.F.)
	cAlias  := SubStr(cArq, 1, 8)

	//Chamada da Stored Procedure
	IncProc()

	cQuery  := "EXEC SP_PLANILHA_FATURAMENTO_AUDITORIA_ANALITICO_SEL '" + cFiliais + "','" + DtoS(dDataIni) + "','" + DtoS(dDataFim) + "','" +;
	                                                                      cCFOP + "','" + cNCM + "','" + cCtaCntb + "','" + cItemCC + "','" +;
	                                                                      cCliForD + "','" + cCliForA + "','" + cLojaD + "','" + cLojaA + "'," + cOrdem

	TCQUERY cQuery NEW ALIAS (cAlias)
	dbSelectArea(cAlias)

	IncProc()
	U_fSetField(aCpoDef, cAlias, .F.)

	IncProc()
	Copy To &cArq
	(cAlias)->( dbCloseArea() )

	dbUseArea(.T.,, cArq, cAlias, .T. )

	If !(cAlias)->(Eof())
		cTitulo  := "Auditoria de Notas Fiscais - Saídas (Analítico)"
		cNameWrk := "NF Saídas"
		cWrk     := "S"

		AAdd(aWrkSht, { cNameWrk,cTitulo,cAlias,5,4,cPgHeader,XLS_PAGE_LANDSCAPE,nPrtScale,nMgrHeader,;
						nMgrFooter,nPgTop,nPgBottom,nPgLeft,nPgRight,,,DefCols(lImposto, lFiscal, lContab, lImpDesc, 1, lPais,nTipo,cWrk),cArq,,.F. } )
	EndIf
EndIf

If nTipo == 2 .Or. nTipo == 3 //Entradas

	IncProc()
	cArq    := CriaTrab(,.F.)
	cAlias  := SubStr(cArq, 1, 8)

	//Chamada da Stored Procedure
	IncProc()

	cQuery  := "EXEC SP_PLANILHA_COMPRAS_AUDITORIA_ANALITICO_SEL '" + cFiliais + "','" + DtoS(dDataIni) + "','" + DtoS(dDataFim) + "','" +;
	                                                                  cCFOP + "','" + cNCM + "','" + cCtaCntb + "','" + cItemCC + "','" +;
	                                                                  cCliForD + "','" + cCliForA + "','" + cLojaD + "','" + cLojaA + "'," + cOrdem


	TCQUERY cQuery NEW ALIAS (cAlias)
	dbSelectArea(cAlias)

	IncProc()
	U_fSetField(aCpoDef, cAlias, .F.)

	IncProc()
	Copy To &cArq
	(cAlias)->( dbCloseArea() )

	dbUseArea(.T.,, cArq, cAlias, .T. )

	If !(cAlias)->(Eof())
		cTitulo  := "Auditoria de Notas Fiscais - Entradas (Analítico)"
		cNameWrk := "NF Entradas"
        cWrk     := "E"
		AAdd(aWrkSht, { cNameWrk,cTitulo,cAlias,5,4,cPgHeader,XLS_PAGE_LANDSCAPE,nPrtScale,nMgrHeader,;
						nMgrFooter,nPgTop,nPgBottom,nPgLeft,nPgRight,,,DefCols(lImposto, lFiscal, lContab, lImpDesc, 2, lPais,nTipo,cWrk),cArq,,.T. } )
	EndIf
EndIf

If Len(aWrkSht) == 0
	MsgStop('Não existem dados para criar o arquivo excel no servidor!' )
	Return .F.
EndIf

Return .T.

/*==========================================================================
|Funcao     | DefCols           | Bianca Massarotto     | Data | 14/06/11  |
============================================================================
|Descricao  | Define as colunas da planila								   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function DefCols(lImposto, lFiscal, lContab, lImpDesc, nOpcx , lPais,nTipo,cWrk)

Local aCampos := {}
Local nCont   := (19 + IIf(lImposto, 42, 0) + IIf(lContab, IIf(!lImpDesc, 3, 6 ) , 0))
Local nCntI   := 0

If nTipo <> 3 //Não é "Ambos"

	//DADOS GERAIS
	aAdd(aCampos, { "FILIAL"						, "C" , 002 , 0 , {{ 1 , "Fl." ,,3							}} , .T. , 025.00 , .F. , .T. , .F. })
	aAdd(aCampos, {{||fDefCpo("TIPO")}				, "C" , 015 , 0 , {{ 1 , "Tp" ,,3	 	 	 				}} , .T. , 090.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"DOC"					 		, "C" , 009 , 0 , {{ 1 , "NF" ,,3  	  			 			}} , .T. , 060.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"SERIE"					 		, "C" , 003 , 0 , {{ 1 , "Serie" ,,3  			 			}} , .T. , 035.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"ESPECIE"				 		, "C" , 005 , 0 , {{ 1 , "Especie" ,,3 			 			}} , .T. , 045.00 , .F. , .T. , .F. })
	aAdd(aCampos, {{||AModNot(ESPECIE)}				, "C" , 005 , 0 , {{ 1 , "Modelo" ,,3 			 			}} , .T. , 040.00 , .F. , .T. , .F. })
	aAdd(aCampos, {{||fDefCpo("EMISSAO")}			, "D" , 008 , 0 , {{ 1 , "Emissão" ,,3 						}} , .T. , 050.00 , .F. , .T. , .F. })
	If nOpcx == 2
		aAdd(aCampos, {{||fDefCpo("DTDIGIT")}		, "D" , 008 , 0 , {{ 1 , "Dt. Digitação da NF" ,,3			}} , .T. , 050.00 , .F. , .T. , .F. })
	EndIf
	If nOpcx == 1
		aAdd(aCampos, {"CLIFOR"						, "C" , 006 , 0 , {{ 1 , "Cód."+Chr(10)+"Cliente" ,,3		}} , .T. , 045.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"LOJA"						, "C" , 002 , 0 , {{ 1 , "Loja"+Chr(10)+"Cliente" ,,3		}} , .T. , 045.00 , .F. , .T. , .F. })
	Else
		aAdd(aCampos, {"CLIFOR"						, "C" , 006 , 0 , {{ 1 , "Cód."+Chr(10)+"Fornec." ,,3		}} , .T. , 045.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"LOJA"						, "C" , 002 , 0 , {{ 1 , "Loja"+Chr(10)+"Fornec." ,,3		}} , .T. , 045.00 , .F. , .T. , .F. })
	EndIf
	aAdd(aCampos, {{||fDefCpo("TPCLIFOR")}			, "C" , 015 , 0 , {{ 1 , "Tp Cli/For" ,,3					}} , .T. , 090.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"NOME"							, "C" , 040 , 0 , {{ 1 , "Nome" ,,3							}} , .T. , 250.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"UF"						 		, "C" , 002 , 0 , {{ 1 , "UF" ,,3	  			 			}} , .T. , 030.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"CGC"							, "C" , 014 , 0 , {{ 1 , "CNPJ" ,,3							}} , .T. , 095.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"INSCR"							, "C" , 018 , 0 , {{ 1 , "Inscrição"+Chr(10)+"Estadual" ,,3	}} , .T. , 100.00 , .F. , .T. , .F. })
	If lPais
		aAdd(aCampos, {"PAIS"						, "C" , 050 , 0 , {{ 1 , "Pais" ,,3							}} , .T. , 180.00 , .F. , .T. , .F. })
	EndIf
	aAdd(aCampos, {"CHAVE"					 		, "C" , 044 , 0 , {{ 1 , "Chave NFE" ,,3 		 			}} , .T. , 255.00 , .F. , .T. , .F. })
	
	//As colunas abaixo ficam dentro de uma célula mesclada chamada "ITENS DAS NOTAS FISCAIS":
	aAdd(aCampos, {"ITEM"							, "C" , 015 , 0 , {{ 1 , "ITENS DAS NOTAS FISCAIS" , nCont },{2, "Item" ,, 2 }} , .T. , 035.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"COD"							, "C" , 015 , 0 , {{ 2 , "Produto" ,,2						}} , .T. , 060.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"DESCRI"							, "C" , 040 , 0 , {{ 2 , "Descrição" ,,2					}} , .T. , 250.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"FCICOD"							, "C" , 036 , 0 , {{ 2 , "Cod. FCI" ,,2						}} , .T. , 210.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"TPPROD"							, "C" , 002 , 0 , {{ 2 , "Tipo" ,,2							}} , .T. , 035.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"UM"								, "C" , 002 , 0 , {{ 2 , "UM" ,,2							}} , .T. , 030.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"NCM"							, "C" , 010 , 0 , {{ 2 , "NCM" ,,2							}} , .T. , 055.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"NATUREZ"						, "C" , 010 , 0 , {{ 2 , "Natureza"+Char(10)+"Financeira",,2}} , .T. , 055.00 , .F. , .T. , .F. })
	//aAdd(aCampos, {"DESCNAT"						, "C" , 030 , 0 , {{ 2 , "Descrição"                     ,,2}} , .T. , 250.00 , .F. , .T. , .F. })  //FR
	If MV_PAR23 == 2 //por Vencimento, oculta Tipo Ent. Saída 
		aAdd(aCampos, {"VENCREA"					, "C" , 008 , 0 , {{ 2 , "Vencto" 					     ,,2}} , .T. , 050.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"VALORTIT"					, "N" , 018 , 2 , {{ 2 , "Valor"+Chr(10)+"Título" 		 ,,2}} , .T. , 080.00 , .T. , .T. , .F. })
	Endif
	
	aAdd(aCampos, {"TES"							, "C" , 003 , 0 , {{ 2 , "TES" ,,2							}} , .T. , 030.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"CFOP"							, "C" , 004 , 0 , {{ 2 , "CFOP" ,,2				   			}} , .T. , 040.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"TRIBUT"							, "C" , 003 , 0 , {{ 2 , "Sit. Trib." ,,2		   			}} , .T. , 040.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"ORIGEM"							, "C" , 001 , 0 , {{ 2 , "Origem" ,,2			   			}} , .T. , 040.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"QUANT"							, "N" , 018 , 5 , {{ 2 , "Quantidade" ,,2		   			}} , .T. , 080.00 , .T. , .T. , .F. })
	aAdd(aCampos, {"PRCVEN"							, "N" , 018 , 6 , {{ 2 , "Preço"+Chr(10)+"Unitario" ,,2		}} , .T. , 080.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"TOTAL"							, "N" , 018 , 2 , {{ 2 , "Valor"+Chr(10)+"Mercad." ,,2		}} , .T. , 080.00 , .T. , .T. , .F. })
	aAdd(aCampos, {"VALDESC"						, "N" , 018 , 2 , {{ 2 , "Valor"+Chr(10)+"Desconto" ,,2		}} , .T. , 080.00 , .T. , .T. , .F. })
	aAdd(aCampos, {"VALCONT"						, "N" , 018 , 2 , {{ 2 , "Valor"+Chr(10)+"Contabil" ,,2		}} , .T. , 080.00 , .T. , .T. , .F. })
	aAdd(aCampos, {"VLRSEG"							, "N" , 018 , 2 , {{ 2 , "Valor"+Chr(10)+"Seguro" ,,2		}} , .T. , 080.00 , .T. , .T. , .F. })
	aAdd(aCampos, {"VLRFRE"							, "N" , 018 , 2 , {{ 2 , "Valor"+Chr(10)+"Frete" ,,2		}} , .T. , 080.00 , .T. , .T. , .F. })
	aAdd(aCampos, {"VLRDES"							, "N" , 018 , 2 , {{ 2 , "Valor"+Chr(10)+"Despesa" ,,2		}} , .T. , 080.00 , .T. , .T. , .F. })
	aAdd(aCampos, {"INDNTFR"   						, "C" , 001 , 0 , {{ 2 , "Ind.Frete" ,,2					}} , .T. , 080.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"NFORIG"   						, "C" , 009 , 0 , {{ 2 , "NF de Origem" ,,2					}} , .T. , 150.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"SERORIG"   						, "C" , 003 , 0 , {{ 2 , "Série de Origem" ,,2				}} , .T. , 090.00 , .F. , .T. , .F. })
	
	//IMPOSTOS
	If lImposto
		//DADOS ISS , uma sub-célula mesclada, abaixo de ITENS DAS NOTAS FISCAIS
		aAdd(aCampos, {"BASEISS"	  				, "N" , 018 , 2 , {{ 2 , "ISS" ,IIF(MV_PAR23 == 2,5,3),1 } , { 4 , "Base" 		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"ALQISS"						, "N" , 008 , 2 , {{ 4 , "Aliq."				 			}} , .T. , 040.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"VALISS"						, "N" , 018 , 2 , {{ 4 , "Valor"				 			}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"CODISS"						, "C" , 009 , 0 , {{ 4 , "Cód. ISS"				 			}} , .T. , 070.00 , .F. , .T. , .F. })
	   If MV_PAR23 == 2 //por Vencimento, oculta Tipo Ent. Saída 
			aAdd(aCampos, {"VENCISS"					, "C" , 010 , 0 , {{ 4 , "Vencto ISS"				 		}} , .T. , 070.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"NATISS"						, "C" , 010 , 2 , {{ 4 , "Natureza ISS"				 		}} , .T. , 070.00 , .F. , .T. , .F. })	
	   EndIf	
		//DADOS INSS
		aAdd(aCampos, {"BASEINS"	  				, "N" , 018 , 2 , {{ 2 , "INSS" ,IIF(MV_PAR23 == 2,4,2),1 } , { 4 , "Base" 		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"PINS"						, "N" , 008 , 2 , {{ 4 , "Aliq."				 			}} , .T. , 040.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"VALINS"						, "N" , 018 , 2 , {{ 4 , "Valor"				 			}} , .T. , 070.00 , .T. , .T. , .F. })
	    If MV_PAR23 == 2 //por Vencimento, oculta Tipo Ent. Saída 
	  		aAdd(aCampos, {"VENCINSS"					, "C" , 010 , 0 , {{ 4 , "Vencto INSS"				 		}} , .T. , 070.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"NATINSS"					, "C" , 010 , 2 , {{ 4 , "Natureza INSS"				 		}} , .T. , 070.00 , .F. , .T. , .F. })	
		EndIf
		//DADOS IRR
		aAdd(aCampos, {"BASEIRR"	  				, "N" , 018 , 2 , {{ 2 , "IRR"  ,IIF(MV_PAR23 == 2,4,2),1 } , { 4 , "Base" 		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"PIRR"						, "N" , 008 , 2 , {{ 4 , "Aliq."				 			}} , .T. , 040.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"VALIRR"						, "N" , 018 , 2 , {{ 4 , "Valor"				 			}} , .T. , 070.00 , .T. , .T. , .F. })
		If MV_PAR23 == 2 //por Vencimento, oculta Tipo Ent. Saída 
		aAdd(aCampos, {"VENCIRR"					, "C" , 010 , 0 , {{ 4 , "Vencto IRR"				 		}} , .T. , 070.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"NATIRR"						, "C" , 010 , 2 , {{ 4 , "Natureza IRR"				 		}} , .T. , 070.00 , .F. , .T. , .F. })	
	    EndIf
	    
	    //DADOS ICMS 
	    If nTipo == 1 //Saídas
			aAdd(aCampos, {"BASEICM"   					, "N" , 018 , 2 , {{ 2 , "ICMS" ,16,1 } , { 4 , "Base" 		}} , .T. , 070.00 , .T. , .T. , .F. })			
		Elseif nTipo == 2 //Entradas
			aAdd(aCampos, {"BASEICM"   					, "N" , 018 , 2 , {{ 2 , "ICMS" ,9,1 } , { 4 , "Base" 		}} , .T. , 070.00 , .T. , .T. , .F. })			
		Endif
		
		aAdd(aCampos, {"ALQICM"						, "N" , 008 , 2 , {{ 4 , "Aliq."					 		}} , .T. , 040.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"VALICM"						, "N" , 018 , 2 , {{ 4 , "Valor"					 		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"CLASFIS"					, "C" , 002 , 0 , {{ 4 , "CST"					 			}} , .T. , 040.00 , .F. , .T. , .F. })
	
		//#16920 - EF 057 - DIFAL
		If nTipo == 1 //Saídas
			aAdd(aCampos, {"DIFALTOT"				, "N" , 018 , 2 , 											{{ 4 , "Difal Total"	   			}} , .T. , 070.00 , .F. , .T. , .F. })
			If SD2->(FieldPos("D2_PDORI")) > 0
				aAdd(aCampos, {"PDORI"	 				, "N" , TamSX3("D2_PDORI")[1]	,TamSX3("D2_PDORI")[2] , 	{{ 4 , "% Difal Ori."				}} , .T. , 070.00 , .F. , .T. , .F. })
			Else
				aAdd(aCampos, {"PDORI"	 				, "N" , 6, 2, 	{{ 4 , "% Difal Ori."				}} , .T. , 070.00 , .F. , .T. , .F. })
			Endif                                                   
			
			If SD2->(FieldPos("D2_PDDES")) > 0
				aAdd(aCampos, {"PDDES"	 				, "N" , TamSX3("D2_PDDES")[1]	,TamSX3("D2_PDDES")[2] , 	{{ 4 , "% Difal Dest."				}} , .T. , 070.00 , .F. , .T. , .F. })
			Else
				aAdd(aCampos, {"PDDES"	 				, "N" , 6, 2, 	{{ 4 , "% Difal Dest."				}} , .T. , 070.00 , .F. , .T. , .F. })
			Endif
						
			If SD2->(FieldPos("D2_ICMSCOM")) > 0
				aAdd(aCampos, {"VDIFORI" 				, "N" , TamSX3("D2_ICMSCOM")[1]	,TamSX3("D2_ICMSCOM")[2] , 	{{ 4 , "ICMS Difal Ori."			}} , .T. , 070.00 , .F. , .T. , .F. })
			Else
				aAdd(aCampos, {"VDIFORI" 				, "N" , 14, 2, 	{{ 4 , "ICMS Difal Ori."			}} , .T. , 070.00 , .F. , .T. , .F. })
			EndIf
						
			If SD2->(FieldPos("D2_DIFAL")) > 0
				aAdd(aCampos, {"VDIFDST" 				, "N" , TamSX3("D2_DIFAL")[1]	,TamSX3("D2_DIFAL")[2] , 	{{ 4 , "ICMS Difal Dest."			}} , .T. , 070.00 , .F. , .T. , .F. })
			Else
				aAdd(aCampos, {"VDIFDST" 				, "N" , 14, 2, 	{{ 4 , "ICMS Difal Dest."			}} , .T. , 070.00 , .F. , .T. , .F. })
			EndIf
						
			If SD2->(FieldPos("D2_VFCPDIF")) > 0
				aAdd(aCampos, {"VFECP" 			   		, "N" , TamSX3("D2_VFCPDIF")[1]	,TamSX3("D2_VFCPDIF")[2] , 	{{ 4 , "Valor FECP"	 				}} , .T. , 070.00 , .F. , .T. , .F. })
			Else
				aAdd(aCampos, {"VFECP" 			   		, "N" , 14, 2, 	{{ 4 , "Valor FECP"	 				}} , .T. , 070.00 , .F. , .T. , .F. })
			EndIf
			
			aAdd(aCampos, {"VDIFECP"				, "N" , 018 , 2 , 											{{ 4 , "ICMS Difal Dest + FECP"		}} , .T. , 070.00 , .F. , .T. , .F. })
		Endif
		//fim EF 057	
		
		aAdd(aCampos, {"BRICMS"						, "N" , 018 , 2 , {{ 4 , "Base  ICMS"+Chr(10)+"Ret." 		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"ALQDEST"					, "N" , 008 , 2 , {{ 4 , "Aliq. ICMS"+Chr(10)+"Ret." 		}} , .T. , 040.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"ICMSRET"					, "N" , 018 , 2 , {{ 4 , "Valor ICMS"+Chr(10)+"Ret."		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"ISENICM"					, "N" , 018 , 2 , {{ 4 , "Valor Isento"				 		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"OUTRICM"					, "N" , 018 , 2 , {{ 4 , "Valor Outros"				 		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"MVA"						, "N" , 018 , 2 , {{ 4 , "MVA"						 		}} , .T. , 070.00 , .T. , .T. , .F. })
		//DADOS IPI
		aAdd(aCampos, {"BASEIPI"					, "N" , 018 , 2 , {{ 2 , "IPI" ,5,1 } , { 4 , "Base"		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"ALQIPI"						, "N" , 008 , 2 , {{ 4 , "Aliq."						 	}} , .T. , 040.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"VALIPI"						, "N" , 018 , 2 , {{ 4 , "Valor"					  		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"ISENIPI"					, "N" , 018 , 2 , {{ 4 , "Valor Isento"				 		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"OUTRIPI"					, "N" , 018 , 2 , {{ 4 , "Valor Outros"				 		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"CSTIPI"						, "C" , 002 , 0 , {{ 4 , "CST"					 			}} , .T. , 040.00 , .F. , .T. , .F. })
	    
		//DADOS COFINS
		If MV_PAR23 = 2
			aAdd(aCampos, {"BASIMP5"					, "N" , 018 , 2 , {{ 2 , "COFINS" , 8 } , { 3 , "Apuração",2}, { 4 , "Base"}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQIMP5"					, "N" , 008 , 2 , {{ 4 , "Aliq."							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALIMP5"					, "N" , 018 , 2 , {{ 4 , "Valor"							}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"BASECOF"					, "N" , 018 , 2 , {{ 3 , "Retenção" ,2 } , { 4 , "Base"		}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQCOF"						, "N" , 008 , 2 , {{ 4 , "Aliq."							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALCOF"						, "N" , 018 , 2 , {{ 4 , "Valor"							}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"CSTCOF"						, "C" , 002 , 0 , {{ 3 , "CST"	,,1					 		}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VENCCOF"					, "C" , 010 , 0 , {{ 4 , "Vencto COFINS"				 		}} , .T. , 070.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"NATCOF"						, "C" , 010 , 2 , {{ 4 , "Natureza COFINS"				 		}} , .T. , 070.00 , .F. , .T. , .F. })	
		Else
	    	aAdd(aCampos, {"BASIMP5"					, "N" , 018 , 2 , {{ 2 , "COFINS" , 6 } , { 3 , "Apuração",2}, { 4 , "Base"}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQIMP5"					, "N" , 008 , 2 , {{ 4 , "Aliq."							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALIMP5"					, "N" , 018 , 2 , {{ 4 , "Valor"							}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"BASECOF"					, "N" , 018 , 2 , {{ 3 , "Retenção" ,2 } , { 4 , "Base"		}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQCOF"						, "N" , 008 , 2 , {{ 4 , "Aliq."							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALCOF"						, "N" , 018 , 2 , {{ 4 , "Valor"							}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"CSTCOF"						, "C" , 002 , 0 , {{ 3 , "CST"	,,1					 		}} , .T. , 040.00 , .F. , .T. , .F. })
		EndIf
		//DADOS PIS
		If MV_PAR23 = 2
			aAdd(aCampos, {"BASIMP6"					, "N" , 018 , 2 , {{ 2 , "PIS" , 8 } , { 3 , "Apuração",2}, { 4 , "Base"   }} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQIMP6"					, "N" , 008 , 2 , {{ 4 , "Aliq."							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALIMP6"					, "N" , 018 , 2 , {{ 4 , "Valor"							}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"BASEPIS"					, "N" , 018 , 2 , {{ 3 , "Retenção" ,2 } , { 4 , "Base"		}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQPIS"						, "N" , 008 , 2 , {{ 4 , "Aliq."							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALPIS"						, "N" , 018 , 2 , {{ 4 , "Valor"							}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"CSTPIS"						, "C" , 002 , 0 , {{ 3 , "CST"	,,1				 			}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VENCPIS"					, "C" , 010 , 0 , {{ 4 , "Vencto PIS"				 		}} , .T. , 070.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"NATPIS"						, "C" , 010 , 2 , {{ 4 , "Natureza PIS"				 		}} , .T. , 070.00 , .F. , .T. , .F. })	
		Else
			aAdd(aCampos, {"BASIMP6"					, "N" , 018 , 2 , {{ 2 , "PIS" , 6 } , { 3 , "Apuração",2}, { 4 , "Base"   }} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQIMP6"					, "N" , 008 , 2 , {{ 4 , "Aliq."							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALIMP6"					, "N" , 018 , 2 , {{ 4 , "Valor"							}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"BASEPIS"					, "N" , 018 , 2 , {{ 3 , "Retenção" ,2 } , { 4 , "Base"		}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQPIS"						, "N" , 008 , 2 , {{ 4 , "Aliq."							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALPIS"						, "N" , 018 , 2 , {{ 4 , "Valor"							}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"CSTPIS"						, "C" , 002 , 0 , {{ 3 , "CST"	,,1				 			}} , .T. , 040.00 , .F. , .T. , .F. })
		EndIf
		//DADOS CSLL
		If MV_PAR23 = 2
			aAdd(aCampos, {"BASECSL"	  				, "N" , 018 , 2 , {{ 2 , "CSLL" ,4,1 } , { 4 , "Base" 		}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQICSL"					, "N" , 008 , 2 , {{ 4 , "Aliq."				 			}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALCSLL"					, "N" , 018 , 2 , {{ 4 , "Valor"				 			}} , .T. , 070.00 , .T. , .T. , .F. })
		    aAdd(aCampos, {"VENCCSL"					, "C" , 010 , 0 , {{ 4 , "Vencto CSLL"				 		}} , .T. , 070.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"NATCSL"						, "C" , 010 , 2 , {{ 4 , "Natureza CSLL"			 		}} , .T. , 070.00 , .F. , .T. , .F. })	
		Else
			aAdd(aCampos, {"BASECSL"	  				, "N" , 018 , 2 , {{ 2 , "CSLL" ,2,1 } , { 4 , "Base" 		}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQICSL"					, "N" , 008 , 2 , {{ 4 , "Aliq."				 			}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALCSLL"					, "N" , 018 , 2 , {{ 4 , "Valor"				 			}} , .T. , 070.00 , .T. , .T. , .F. })
	
		EndIf
	EndIf
	aAdd(aCampos, {"CODBCC"				   	   		, "C" , 002 , 0 , {{ 2 , "Cod."+Chr(10)+"BCC" ,,2 			}} , .T. , 040.00 , .F. , .T. , .F. })
	
	//CONTABIL
	If lContab
		nCont := IIf(!lImpDesc, 2, 5)
		aAdd(aCampos, {"CONTA"				  		, "C" , 020 , 0 , {{ 2 , "Dados Contábeis" ,nCont,1 } , { 4 , "Cta.Contabil" }} , .T. , 070.00 , .F. , .T. , .F. })
		If lImpDesc
			aAdd(aCampos, {"DESCCTA"				, "C" , 040 , 0 , {{ 4 , "Descrição"						}} , .T. , 170.00 , .F. , .T. , .F. })
		EndIf
		aAdd(aCampos, {"ITEMCC"						, "C" , 009 , 0 , {{ 4 , "Item Cta."					 	}} , .T. , 070.00 , .F. , .T. , .F. })
		If lImpDesc
			aAdd(aCampos, {"DESCITEM"	   			, "C" , 020 , 0 , {{ 4 , "Descrição"						}} , .T. , 120.00 , .F. , .T. , .F. })
		EndIf
		aAdd(aCampos, {"CCUSTO"						, "C" , 090 , 0 , {{ 4 , "CC"							 	}} , .T. , 070.00 , .F. , .T. , .F. })
		If lImpDesc
			aAdd(aCampos, {"DESCCUSTO"				, "C" , 090 , 0 , {{ 4 , "Descrição"						}} , .T. , 120.00 , .F. , .T. , .F. })
		EndIf
	EndIf
	
	If lFiscal
	    IF MV_PAR23 == 1
			nCont := IIf(!lImpDesc, 17, 18)
		Else
	   		nCont := IIf(!lImpDesc, 17, 08)  
	   	EndIf	
		nCntI := IIf(!lImpDesc, 3, 4)
		//DADOS FISCAL
		aAdd(aCampos, {"CF"	, "C" , 004 , 0 , {{ 1 , "TIPO DE ENTRADA / SAÍDA" , nCont } , { 2 , "Administração/Financeiro/Custo" ,nCntI,1 } , { 4 , "CFOP" }} , .T. , 040.00 , .F. , .T. , .F. })
		If lImpDesc
			aAdd(aCampos, {{||fDefCpo("TEXTO")}		, "C" , 050 , 0 , {{ 4 , "Descrição"  			 			}} , .T. , 250.00 , .F. , .T. , .F. })
		EndIf
		aAdd(aCampos, {{||fDefCpo("DUPLIC")}   		, "C" , 020 , 0 , {{ 4 , "Duplicata"  						}} , .T. , 050.00 , .F. , .T. , .F. })
		aAdd(aCampos, {{||fDefCpo("ESTOQUE")}		, "C" , 020 , 0 , {{ 4 , "Estoque"	  						}} , .T. , 050.00 , .F. , .T. , .F. })
		aAdd(aCampos, {{||fDefCpo("PODER3")} 		, "C" , 020 , 0 , {{ 4 , "Poder 3º"			  				}} , .T. , 090.00 , .F. , .T. , .F. })
	    
	    //FR - 01/07/15 - parâmetro incluído por Flávia Rocha, onde dependendo da opção escolhida
	    //irá mostrar ou ocultar as colunas abaixo
	   	If MV_PAR23 == 1 //por Tipo Ent. Saída, mostra as colunas abaixo, e oculta Vencimentos
	    	aAdd(aCampos, {{||fDefCpo("ICM")}			, "C" , 020 , 0 , {{ 2 , "ICMS" , 4,1 } , { 4 , "Calcula"	}} , .T. , 045.00 , .F. , .T. , .F. })
			aAdd(aCampos, {{||fDefCpo("CREDICM")}		, "C" , 020 , 0 , {{ 4 , "Credita"							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {{||fDefCpo("LFICM")}			, "C" , 020 , 0 , {{ 4 , "LF"								}} , .T. , 070.00 , .F. , .T. , .F. })
			aAdd(aCampos, {{||fDefCpo("LFICMST")}		, "C" , 020 , 0 , {{ 4 , "LF"+Chr(10)+"ICMS ST"				}} , .T. , 070.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"SITTRIB" 					, "C" , 002 , 0 , {{ 4 , "CST"								}} , .T. , 045.00 , .F. , .T. , .F. })
	
			aAdd(aCampos, {{||fDefCpo("IPI")}			, "C" , 020 , 0 , {{ 2 , "IPI" , 4,1 } , { 4, "Calcula"		}} , .T. , 045.00 , .F. , .T. , .F. })
			aAdd(aCampos, {{||fDefCpo("CREDIPI")}		, "C" , 020 , 0 , {{ 4 , "Credita"							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {{||fDefCpo("LFIPI")}			, "C" , 020 , 0 , {{ 4 , "LF"								}} , .T. , 070.00 , .F. , .T. , .F. })
			aAdd(aCampos, {{||fDefCpo("DESTACA")}		, "C" , 020 , 0 , {{ 4 , "Destaca"							}} , .T. , 050.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"CTIPI"						, "C" , 002 , 0 , {{ 4 , "CST"								}} , .T. , 045.00 , .F. , .T. , .F. })
	   	Endif
	
		aAdd(aCampos, {"PISCOF"						, "C" , 020 , 0 , {{ 2 , "PIS / COFINS" , 3,1 } , { 4 , "Agrega"+Chr(10)+"PIS/COF." }} , .T. , 090.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"PISCRED"					, "C" , 020 , 0 , {{ 4 , "Cred./Deb."+Chr(10)+"PIS/COF."	}} , .T. , 090.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"CTPIS"						, "C" , 002 , 0 , {{ 4 , "CST"+Chr(10)+"PIS"				}} , .T. , 045.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"CTCOF"						, "C" , 002 , 0 , {{ 4 , "CST"+Chr(10)+"COFINS"				}} , .T. , 045.00 , .F. , .T. , .F. })
	EndIf
Else	//nTipo = 3, é "ambos"

	//DADOS GERAIS
	aAdd(aCampos, { "FILIAL"						, "C" , 002 , 0 , {{ 1 , "Fl." ,,3							}} , .T. , 025.00 , .F. , .T. , .F. })
	aAdd(aCampos, {{||fDefCpo("TIPO")}				, "C" , 015 , 0 , {{ 1 , "Tp" ,,3	 	 	 				}} , .T. , 090.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"DOC"					 		, "C" , 009 , 0 , {{ 1 , "NF" ,,3  	  			 			}} , .T. , 060.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"SERIE"					 		, "C" , 003 , 0 , {{ 1 , "Serie" ,,3  			 			}} , .T. , 035.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"ESPECIE"				 		, "C" , 005 , 0 , {{ 1 , "Especie" ,,3 			 			}} , .T. , 045.00 , .F. , .T. , .F. })
	aAdd(aCampos, {{||AModNot(ESPECIE)}				, "C" , 005 , 0 , {{ 1 , "Modelo" ,,3 			 			}} , .T. , 040.00 , .F. , .T. , .F. })
	aAdd(aCampos, {{||fDefCpo("EMISSAO")}			, "D" , 008 , 0 , {{ 1 , "Emissão" ,,3 						}} , .T. , 050.00 , .F. , .T. , .F. })
	If nOpcx == 2
		aAdd(aCampos, {{||fDefCpo("DTDIGIT")}		, "D" , 008 , 0 , {{ 1 , "Dt. Digitação da NF" ,,3			}} , .T. , 050.00 , .F. , .T. , .F. })
	EndIf
	If nOpcx == 1
		aAdd(aCampos, {"CLIFOR"						, "C" , 006 , 0 , {{ 1 , "Cód."+Chr(10)+"Cliente" ,,3		}} , .T. , 045.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"LOJA"						, "C" , 002 , 0 , {{ 1 , "Loja"+Chr(10)+"Cliente" ,,3		}} , .T. , 045.00 , .F. , .T. , .F. })
	Else
		aAdd(aCampos, {"CLIFOR"						, "C" , 006 , 0 , {{ 1 , "Cód."+Chr(10)+"Fornec." ,,3		}} , .T. , 045.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"LOJA"						, "C" , 002 , 0 , {{ 1 , "Loja"+Chr(10)+"Fornec." ,,3		}} , .T. , 045.00 , .F. , .T. , .F. })
	EndIf
	aAdd(aCampos, {{||fDefCpo("TPCLIFOR")}			, "C" , 015 , 0 , {{ 1 , "Tp Cli/For" ,,3					}} , .T. , 090.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"NOME"							, "C" , 040 , 0 , {{ 1 , "Nome" ,,3							}} , .T. , 250.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"UF"						 		, "C" , 002 , 0 , {{ 1 , "UF" ,,3	  			 			}} , .T. , 030.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"CGC"							, "C" , 014 , 0 , {{ 1 , "CNPJ" ,,3							}} , .T. , 095.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"INSCR"							, "C" , 018 , 0 , {{ 1 , "Inscrição"+Chr(10)+"Estadual" ,,3	}} , .T. , 100.00 , .F. , .T. , .F. })
	If lPais
		aAdd(aCampos, {"PAIS"						, "C" , 050 , 0 , {{ 1 , "Pais" ,,3							}} , .T. , 180.00 , .F. , .T. , .F. })
	EndIf
	aAdd(aCampos, {"CHAVE"					 		, "C" , 044 , 0 , {{ 1 , "Chave NFE" ,,3 		 			}} , .T. , 255.00 , .F. , .T. , .F. })
	
	//As colunas abaixo ficam dentro de uma célula mesclada chamada "ITENS DAS NOTAS FISCAIS":
	aAdd(aCampos, {"ITEM"							, "C" , 015 , 0 , {{ 1 , "ITENS DAS NOTAS FISCAIS" , nCont },{2, "Item" ,, 2 }} , .T. , 035.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"COD"							, "C" , 015 , 0 , {{ 2 , "Produto" ,,2						}} , .T. , 060.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"DESCRI"							, "C" , 040 , 0 , {{ 2 , "Descrição" ,,2					}} , .T. , 250.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"FCICOD"							, "C" , 036 , 0 , {{ 2 , "Cod. FCI" ,,2						}} , .T. , 210.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"TPPROD"							, "C" , 002 , 0 , {{ 2 , "Tipo" ,,2							}} , .T. , 035.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"UM"								, "C" , 002 , 0 , {{ 2 , "UM" ,,2							}} , .T. , 030.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"NCM"							, "C" , 010 , 0 , {{ 2 , "NCM" ,,2							}} , .T. , 055.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"NATUREZ"						, "C" , 010 , 0 , {{ 2 , "Natureza"+Char(10)+"Financeira",,2}} , .T. , 055.00 , .F. , .T. , .F. })
	//aAdd(aCampos, {"DESCNAT"						, "C" , 030 , 0 , {{ 2 , "Descrição"                     ,,2}} , .T. , 250.00 , .F. , .T. , .F. })  //FR
	If MV_PAR23 == 2 //por Vencimento, oculta Tipo Ent. Saída 
		aAdd(aCampos, {"VENCREA"					, "C" , 008 , 0 , {{ 2 , "Vencto" 					     ,,2}} , .T. , 050.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"VALORTIT"					, "N" , 018 , 2 , {{ 2 , "Valor"+Chr(10)+"Título" 		 ,,2}} , .T. , 080.00 , .T. , .T. , .F. })
	Endif
	
	aAdd(aCampos, {"TES"							, "C" , 003 , 0 , {{ 2 , "TES" ,,2							}} , .T. , 030.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"CFOP"							, "C" , 004 , 0 , {{ 2 , "CFOP" ,,2				   			}} , .T. , 040.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"TRIBUT"							, "C" , 003 , 0 , {{ 2 , "Sit. Trib." ,,2		   			}} , .T. , 040.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"ORIGEM"							, "C" , 001 , 0 , {{ 2 , "Origem" ,,2			   			}} , .T. , 040.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"QUANT"							, "N" , 018 , 5 , {{ 2 , "Quantidade" ,,2		   			}} , .T. , 080.00 , .T. , .T. , .F. })
	aAdd(aCampos, {"PRCVEN"							, "N" , 018 , 6 , {{ 2 , "Preço"+Chr(10)+"Unitario" ,,2		}} , .T. , 080.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"TOTAL"							, "N" , 018 , 2 , {{ 2 , "Valor"+Chr(10)+"Mercad." ,,2		}} , .T. , 080.00 , .T. , .T. , .F. })
	aAdd(aCampos, {"VALDESC"						, "N" , 018 , 2 , {{ 2 , "Valor"+Chr(10)+"Desconto" ,,2		}} , .T. , 080.00 , .T. , .T. , .F. })
	aAdd(aCampos, {"VALCONT"						, "N" , 018 , 2 , {{ 2 , "Valor"+Chr(10)+"Contabil" ,,2		}} , .T. , 080.00 , .T. , .T. , .F. })
	aAdd(aCampos, {"VLRSEG"							, "N" , 018 , 2 , {{ 2 , "Valor"+Chr(10)+"Seguro" ,,2		}} , .T. , 080.00 , .T. , .T. , .F. })
	aAdd(aCampos, {"VLRFRE"							, "N" , 018 , 2 , {{ 2 , "Valor"+Chr(10)+"Frete" ,,2		}} , .T. , 080.00 , .T. , .T. , .F. })
	aAdd(aCampos, {"VLRDES"							, "N" , 018 , 2 , {{ 2 , "Valor"+Chr(10)+"Despesa" ,,2		}} , .T. , 080.00 , .T. , .T. , .F. })
	aAdd(aCampos, {"INDNTFR"   						, "C" , 001 , 0 , {{ 2 , "Ind.Frete" ,,2					}} , .T. , 080.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"NFORIG"   						, "C" , 009 , 0 , {{ 2 , "NF de Origem" ,,2					}} , .T. , 150.00 , .F. , .T. , .F. })
	aAdd(aCampos, {"SERORIG"   						, "C" , 003 , 0 , {{ 2 , "Série de Origem" ,,2				}} , .T. , 090.00 , .F. , .T. , .F. })
	
	//IMPOSTOS
	If lImposto
		//DADOS ISS , uma sub-célula mesclada, abaixo de ITENS DAS NOTAS FISCAIS
		aAdd(aCampos, {"BASEISS"	  				, "N" , 018 , 2 , {{ 2 , "ISS" ,IIF(MV_PAR23 == 2,5,3),1 } , { 4 , "Base" 		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"ALQISS"						, "N" , 008 , 2 , {{ 4 , "Aliq."				 			}} , .T. , 040.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"VALISS"						, "N" , 018 , 2 , {{ 4 , "Valor"				 			}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"CODISS"						, "C" , 009 , 0 , {{ 4 , "Cód. ISS"				 			}} , .T. , 070.00 , .F. , .T. , .F. })
	   If MV_PAR23 == 2 //por Vencimento, oculta Tipo Ent. Saída 
			aAdd(aCampos, {"VENCISS"					, "C" , 010 , 0 , {{ 4 , "Vencto ISS"				 		}} , .T. , 070.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"NATISS"						, "C" , 010 , 2 , {{ 4 , "Natureza ISS"				 		}} , .T. , 070.00 , .F. , .T. , .F. })	
	   EndIf	
		//DADOS INSS
		aAdd(aCampos, {"BASEINS"	  				, "N" , 018 , 2 , {{ 2 , "INSS" ,IIF(MV_PAR23 == 2,4,2),1 } , { 4 , "Base" 		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"PINS"						, "N" , 008 , 2 , {{ 4 , "Aliq."				 			}} , .T. , 040.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"VALINS"						, "N" , 018 , 2 , {{ 4 , "Valor"				 			}} , .T. , 070.00 , .T. , .T. , .F. })
	    If MV_PAR23 == 2 //por Vencimento, oculta Tipo Ent. Saída 
	  		aAdd(aCampos, {"VENCINSS"					, "C" , 010 , 0 , {{ 4 , "Vencto INSS"				 		}} , .T. , 070.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"NATINSS"					, "C" , 010 , 2 , {{ 4 , "Natureza INSS"				 		}} , .T. , 070.00 , .F. , .T. , .F. })	
		EndIf
		//DADOS IRR
		aAdd(aCampos, {"BASEIRR"	  				, "N" , 018 , 2 , {{ 2 , "IRR"  ,IIF(MV_PAR23 == 2,4,2),1 } , { 4 , "Base" 		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"PIRR"						, "N" , 008 , 2 , {{ 4 , "Aliq."				 			}} , .T. , 040.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"VALIRR"						, "N" , 018 , 2 , {{ 4 , "Valor"				 			}} , .T. , 070.00 , .T. , .T. , .F. })
		If MV_PAR23 == 2 //por Vencimento, oculta Tipo Ent. Saída 
		aAdd(aCampos, {"VENCIRR"					, "C" , 010 , 0 , {{ 4 , "Vencto IRR"				 		}} , .T. , 070.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"NATIRR"						, "C" , 010 , 2 , {{ 4 , "Natureza IRR"				 		}} , .T. , 070.00 , .F. , .T. , .F. })	
	    EndIf
	    
	    //DADOS ICMS
	    If Alltrim(cWrk) = "S" //aba nf saída	    	
			aAdd(aCampos, {"BASEICM"   					, "N" , 018 , 2 , {{ 2 , "ICMS" ,16,1 } , { 4 , "Base" 		}} , .T. , 070.00 , .T. , .T. , .F. })		
	    Elseif Alltrim(cWrk) = "E"
	    	aAdd(aCampos, {"BASEICM"   					, "N" , 018 , 2 , {{ 2 , "ICMS" ,9,1 } , { 4 , "Base" 		}} , .T. , 070.00 , .T. , .T. , .F. })			
		Endif
		
		aAdd(aCampos, {"ALQICM"						, "N" , 008 , 2 , {{ 4 , "Aliq."					 		}} , .T. , 040.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"VALICM"						, "N" , 018 , 2 , {{ 4 , "Valor"					 		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"CLASFIS"					, "C" , 002 , 0 , {{ 4 , "CST"					 			}} , .T. , 040.00 , .F. , .T. , .F. })
	
		//#16920 - EF 057 - DIFAL
		If cWrk = "S" //o tipo é Saída, e a Worksheet é Saída          
			aAdd(aCampos, {"DIFALTOT"				, "N" , 018 , 2 , 											{{ 4 , "Difal Total"	   			}} , .T. , 070.00 , .F. , .T. , .F. })

			If SD2->(FieldPos("D2_PDORI")) > 0
				aAdd(aCampos, {"PDORI"	 				, "N" , TamSX3("D2_PDORI")[1]	,TamSX3("D2_PDORI")[2] , 	{{ 4 , "% Difal Ori."				}} , .T. , 070.00 , .F. , .T. , .F. })
			Else
				aAdd(aCampos, {"PDORI"	 				, "N" , 6, 2 , 	{{ 4 , "% Difal Ori."				}} , .T. , 070.00 , .F. , .T. , .F. })
			EndIf
			
			If SD2->(FieldPos("D2_PDDES")) > 0
				aAdd(aCampos, {"PDDES"	 				, "N" , TamSX3("D2_PDDES")[1]	,TamSX3("D2_PDDES")[2] , 	{{ 4 , "% Difal Dest."				}} , .T. , 070.00 , .F. , .T. , .F. })
			Else
				aAdd(aCampos, {"PDDES"	 				, "N" , 6, 2, 	{{ 4 , "% Difal Dest."				}} , .T. , 070.00 , .F. , .T. , .F. })
			EndIf

			If SD2->(FieldPos("D2_ICMSCOM")) > 0
				aAdd(aCampos, {"VDIFORI" 				, "N" , TamSX3("D2_ICMSCOM")[1]	,TamSX3("D2_ICMSCOM")[2] , 	{{ 4 , "ICMS Difal Ori."			}} , .T. , 070.00 , .F. , .T. , .F. })
			Else
				aAdd(aCampos, {"VDIFORI" 				, "N" , 14, 2, 	{{ 4 , "ICMS Difal Ori."			}} , .T. , 070.00 , .F. , .T. , .F. })
			EndIf

			If SD2->(FieldPos("D2_DIFAL")) > 0
				aAdd(aCampos, {"VDIFDST" 				, "N" , TamSX3("D2_DIFAL")[1]	,TamSX3("D2_DIFAL")[2] , 	{{ 4 , "ICMS Difal Dest."			}} , .T. , 070.00 , .F. , .T. , .F. })
			Else
				aAdd(aCampos, {"VDIFDST" 				, "N" , 14, 2, {{ 4 , "ICMS Difal Dest."			}} , .T. , 070.00 , .F. , .T. , .F. })
			EndIf
			
			If SD2->(FieldPos("D2_VFCPDIF")) > 0
				aAdd(aCampos, {"VFECP" 			   		, "N" , TamSX3("D2_VFCPDIF")[1]	,TamSX3("D2_VFCPDIF")[2] , 	{{ 4 , "Valor FECP"	 				}} , .T. , 070.00 , .F. , .T. , .F. })
			Else
				aAdd(aCampos, {"VFECP" 			   		, "N" , 14, 2, 	{{ 4 , "Valor FECP"	 				}} , .T. , 070.00 , .F. , .T. , .F. })
			EndIf
			
			aAdd(aCampos, {"VDIFECP"				, "N" , 018 , 2 , 											{{ 4 , "ICMS Difal Dest + FECP"		}} , .T. , 070.00 , .F. , .T. , .F. })
		Endif
		//fim EF 057	
		
		aAdd(aCampos, {"BRICMS"						, "N" , 018 , 2 , {{ 4 , "Base  ICMS"+Chr(10)+"Ret." 		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"ALQDEST"					, "N" , 008 , 2 , {{ 4 , "Aliq. ICMS"+Chr(10)+"Ret." 		}} , .T. , 040.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"ICMSRET"					, "N" , 018 , 2 , {{ 4 , "Valor ICMS"+Chr(10)+"Ret."		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"ISENICM"					, "N" , 018 , 2 , {{ 4 , "Valor Isento"				 		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"OUTRICM"					, "N" , 018 , 2 , {{ 4 , "Valor Outros"				 		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"MVA"						, "N" , 018 , 2 , {{ 4 , "MVA"						 		}} , .T. , 070.00 , .T. , .T. , .F. })
		//DADOS IPI
		aAdd(aCampos, {"BASEIPI"					, "N" , 018 , 2 , {{ 2 , "IPI" ,5,1 } , { 4 , "Base"		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"ALQIPI"						, "N" , 008 , 2 , {{ 4 , "Aliq."						 	}} , .T. , 040.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"VALIPI"						, "N" , 018 , 2 , {{ 4 , "Valor"					  		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"ISENIPI"					, "N" , 018 , 2 , {{ 4 , "Valor Isento"				 		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"OUTRIPI"					, "N" , 018 , 2 , {{ 4 , "Valor Outros"				 		}} , .T. , 070.00 , .T. , .T. , .F. })
		aAdd(aCampos, {"CSTIPI"						, "C" , 002 , 0 , {{ 4 , "CST"					 			}} , .T. , 040.00 , .F. , .T. , .F. })
	    
		//DADOS COFINS
		If MV_PAR23 = 2
			aAdd(aCampos, {"BASIMP5"					, "N" , 018 , 2 , {{ 2 , "COFINS" , 8 } , { 3 , "Apuração",2}, { 4 , "Base"}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQIMP5"					, "N" , 008 , 2 , {{ 4 , "Aliq."							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALIMP5"					, "N" , 018 , 2 , {{ 4 , "Valor"							}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"BASECOF"					, "N" , 018 , 2 , {{ 3 , "Retenção" ,2 } , { 4 , "Base"		}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQCOF"						, "N" , 008 , 2 , {{ 4 , "Aliq."							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALCOF"						, "N" , 018 , 2 , {{ 4 , "Valor"							}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"CSTCOF"						, "C" , 002 , 0 , {{ 3 , "CST"	,,1					 		}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VENCCOF"					, "C" , 010 , 0 , {{ 4 , "Vencto COFINS"				 		}} , .T. , 070.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"NATCOF"						, "C" , 010 , 2 , {{ 4 , "Natureza COFINS"				 		}} , .T. , 070.00 , .F. , .T. , .F. })	
		Else
	    	aAdd(aCampos, {"BASIMP5"					, "N" , 018 , 2 , {{ 2 , "COFINS" , 6 } , { 3 , "Apuração",2}, { 4 , "Base"}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQIMP5"					, "N" , 008 , 2 , {{ 4 , "Aliq."							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALIMP5"					, "N" , 018 , 2 , {{ 4 , "Valor"							}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"BASECOF"					, "N" , 018 , 2 , {{ 3 , "Retenção" ,2 } , { 4 , "Base"		}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQCOF"						, "N" , 008 , 2 , {{ 4 , "Aliq."							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALCOF"						, "N" , 018 , 2 , {{ 4 , "Valor"							}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"CSTCOF"						, "C" , 002 , 0 , {{ 3 , "CST"	,,1					 		}} , .T. , 040.00 , .F. , .T. , .F. })
		EndIf
		//DADOS PIS
		If MV_PAR23 = 2
			aAdd(aCampos, {"BASIMP6"					, "N" , 018 , 2 , {{ 2 , "PIS" , 8 } , { 3 , "Apuração",2}, { 4 , "Base"   }} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQIMP6"					, "N" , 008 , 2 , {{ 4 , "Aliq."							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALIMP6"					, "N" , 018 , 2 , {{ 4 , "Valor"							}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"BASEPIS"					, "N" , 018 , 2 , {{ 3 , "Retenção" ,2 } , { 4 , "Base"		}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQPIS"						, "N" , 008 , 2 , {{ 4 , "Aliq."							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALPIS"						, "N" , 018 , 2 , {{ 4 , "Valor"							}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"CSTPIS"						, "C" , 002 , 0 , {{ 3 , "CST"	,,1				 			}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VENCPIS"					, "C" , 010 , 0 , {{ 4 , "Vencto PIS"				 		}} , .T. , 070.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"NATPIS"						, "C" , 010 , 2 , {{ 4 , "Natureza PIS"				 		}} , .T. , 070.00 , .F. , .T. , .F. })	
		Else
			aAdd(aCampos, {"BASIMP6"					, "N" , 018 , 2 , {{ 2 , "PIS" , 6 } , { 3 , "Apuração",2}, { 4 , "Base"   }} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQIMP6"					, "N" , 008 , 2 , {{ 4 , "Aliq."							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALIMP6"					, "N" , 018 , 2 , {{ 4 , "Valor"							}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"BASEPIS"					, "N" , 018 , 2 , {{ 3 , "Retenção" ,2 } , { 4 , "Base"		}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQPIS"						, "N" , 008 , 2 , {{ 4 , "Aliq."							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALPIS"						, "N" , 018 , 2 , {{ 4 , "Valor"							}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"CSTPIS"						, "C" , 002 , 0 , {{ 3 , "CST"	,,1				 			}} , .T. , 040.00 , .F. , .T. , .F. })
		EndIf
		//DADOS CSLL
		If MV_PAR23 = 2
			aAdd(aCampos, {"BASECSL"	  				, "N" , 018 , 2 , {{ 2 , "CSLL" ,4,1 } , { 4 , "Base" 		}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQICSL"					, "N" , 008 , 2 , {{ 4 , "Aliq."				 			}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALCSLL"					, "N" , 018 , 2 , {{ 4 , "Valor"				 			}} , .T. , 070.00 , .T. , .T. , .F. })
		    aAdd(aCampos, {"VENCCSL"					, "C" , 010 , 0 , {{ 4 , "Vencto CSLL"				 		}} , .T. , 070.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"NATCSL"						, "C" , 010 , 2 , {{ 4 , "Natureza CSLL"			 		}} , .T. , 070.00 , .F. , .T. , .F. })	
		Else
			aAdd(aCampos, {"BASECSL"	  				, "N" , 018 , 2 , {{ 2 , "CSLL" ,2,1 } , { 4 , "Base" 		}} , .T. , 070.00 , .T. , .T. , .F. })
			aAdd(aCampos, {"ALQICSL"					, "N" , 008 , 2 , {{ 4 , "Aliq."				 			}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"VALCSLL"					, "N" , 018 , 2 , {{ 4 , "Valor"				 			}} , .T. , 070.00 , .T. , .T. , .F. })
	
		EndIf
	EndIf
	aAdd(aCampos, {"CODBCC"				   	   		, "C" , 002 , 0 , {{ 2 , "Cod."+Chr(10)+"BCC" ,,2 			}} , .T. , 040.00 , .F. , .T. , .F. })
	
	//CONTABIL
	If lContab
		nCont := IIf(!lImpDesc, 2, 5)
		aAdd(aCampos, {"CONTA"				  		, "C" , 020 , 0 , {{ 2 , "Dados Contábeis" ,nCont,1 } , { 4 , "Cta.Contabil" }} , .T. , 070.00 , .F. , .T. , .F. })
		If lImpDesc
			aAdd(aCampos, {"DESCCTA"				, "C" , 040 , 0 , {{ 4 , "Descrição"						}} , .T. , 170.00 , .F. , .T. , .F. })
		EndIf
		aAdd(aCampos, {"ITEMCC"						, "C" , 009 , 0 , {{ 4 , "Item Cta."					 	}} , .T. , 070.00 , .F. , .T. , .F. })
		If lImpDesc
			aAdd(aCampos, {"DESCITEM"	   			, "C" , 020 , 0 , {{ 4 , "Descrição"						}} , .T. , 120.00 , .F. , .T. , .F. })
		EndIf
		aAdd(aCampos, {"CCUSTO"						, "C" , 090 , 0 , {{ 4 , "CC"							 	}} , .T. , 070.00 , .F. , .T. , .F. })
		If lImpDesc
			aAdd(aCampos, {"DESCCUSTO"				, "C" , 090 , 0 , {{ 4 , "Descrição"						}} , .T. , 120.00 , .F. , .T. , .F. })
		EndIf
	EndIf
	
	If lFiscal
	    IF MV_PAR23 == 1
			nCont := IIf(!lImpDesc, 17, 18)
		Else
	   		nCont := IIf(!lImpDesc, 17, 08)  
	   	EndIf	
		nCntI := IIf(!lImpDesc, 3, 4)
		//DADOS FISCAL
		aAdd(aCampos, {"CF"	, "C" , 004 , 0 , {{ 1 , "TIPO DE ENTRADA / SAÍDA" , nCont } , { 2 , "Administração/Financeiro/Custo" ,nCntI,1 } , { 4 , "CFOP" }} , .T. , 040.00 , .F. , .T. , .F. })
		If lImpDesc
			aAdd(aCampos, {{||fDefCpo("TEXTO")}		, "C" , 050 , 0 , {{ 4 , "Descrição"  			 			}} , .T. , 250.00 , .F. , .T. , .F. })
		EndIf
		aAdd(aCampos, {{||fDefCpo("DUPLIC")}   		, "C" , 020 , 0 , {{ 4 , "Duplicata"  						}} , .T. , 050.00 , .F. , .T. , .F. })
		aAdd(aCampos, {{||fDefCpo("ESTOQUE")}		, "C" , 020 , 0 , {{ 4 , "Estoque"	  						}} , .T. , 050.00 , .F. , .T. , .F. })
		aAdd(aCampos, {{||fDefCpo("PODER3")} 		, "C" , 020 , 0 , {{ 4 , "Poder 3º"			  				}} , .T. , 090.00 , .F. , .T. , .F. })
	    
	    //FR - 01/07/15 - parâmetro incluído por Flávia Rocha, onde dependendo da opção escolhida
	    //irá mostrar ou ocultar as colunas abaixo
	   	If MV_PAR23 == 1 //por Tipo Ent. Saída, mostra as colunas abaixo, e oculta Vencimentos
	    	aAdd(aCampos, {{||fDefCpo("ICM")}			, "C" , 020 , 0 , {{ 2 , "ICMS" , 4,1 } , { 4 , "Calcula"	}} , .T. , 045.00 , .F. , .T. , .F. })
			aAdd(aCampos, {{||fDefCpo("CREDICM")}		, "C" , 020 , 0 , {{ 4 , "Credita"							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {{||fDefCpo("LFICM")}			, "C" , 020 , 0 , {{ 4 , "LF"								}} , .T. , 070.00 , .F. , .T. , .F. })
			aAdd(aCampos, {{||fDefCpo("LFICMST")}		, "C" , 020 , 0 , {{ 4 , "LF"+Chr(10)+"ICMS ST"				}} , .T. , 070.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"SITTRIB" 					, "C" , 002 , 0 , {{ 4 , "CST"								}} , .T. , 045.00 , .F. , .T. , .F. })
	
			aAdd(aCampos, {{||fDefCpo("IPI")}			, "C" , 020 , 0 , {{ 2 , "IPI" , 4,1 } , { 4, "Calcula"		}} , .T. , 045.00 , .F. , .T. , .F. })
			aAdd(aCampos, {{||fDefCpo("CREDIPI")}		, "C" , 020 , 0 , {{ 4 , "Credita"							}} , .T. , 040.00 , .F. , .T. , .F. })
			aAdd(aCampos, {{||fDefCpo("LFIPI")}			, "C" , 020 , 0 , {{ 4 , "LF"								}} , .T. , 070.00 , .F. , .T. , .F. })
			aAdd(aCampos, {{||fDefCpo("DESTACA")}		, "C" , 020 , 0 , {{ 4 , "Destaca"							}} , .T. , 050.00 , .F. , .T. , .F. })
			aAdd(aCampos, {"CTIPI"						, "C" , 002 , 0 , {{ 4 , "CST"								}} , .T. , 045.00 , .F. , .T. , .F. })
	   	Endif
	
		aAdd(aCampos, {"PISCOF"						, "C" , 020 , 0 , {{ 2 , "PIS / COFINS" , 3,1 } , { 4 , "Agrega"+Chr(10)+"PIS/COF." }} , .T. , 090.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"PISCRED"					, "C" , 020 , 0 , {{ 4 , "Cred./Deb."+Chr(10)+"PIS/COF."	}} , .T. , 090.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"CTPIS"						, "C" , 002 , 0 , {{ 4 , "CST"+Chr(10)+"PIS"				}} , .T. , 045.00 , .F. , .T. , .F. })
		aAdd(aCampos, {"CTCOF"						, "C" , 002 , 0 , {{ 4 , "CST"+Chr(10)+"COFINS"				}} , .T. , 045.00 , .F. , .T. , .F. })
	EndIf

Endif //não é Ambos
Return { Nil , aCampos }

/*==========================================================================
|Funcao     | GeraXLS           | Bianca Massarotto     | Data | 14/06/11  |
============================================================================
|Descricao  | Gera o arquivo excel no servidor 							   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function GeraXLS(oExcelCLS, aWrkSht, lImposto, lFiscal, lContab, lTotal, cOrdem)

Local aCampos	:= {}
Local bGetData
Local oStyleFil
Local oStyleTit
Local nArea 	:= 0
Local nColIndex	:= 0
Local nCt		:= 0
Local nHeader	:= 0
Local nWrk		:= 0
Local cAlias	:= ""
Local cArq		:= ""

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

	If nWrk==1
		oExcelCLS:SetWrkSht(nWrk)
	Else
		oExcelCLS:NextWrkSht()
	EndIf

	cAlias  := aWrkSht[nWrk][3]
	cArq    := aWrkSht[nWrk][18]
	lSF1	:= aWrkSht[nWrk][20]
	aCampos := aWrkSht[nWrk][17][2]

	oExcelCLS:GetWrkSheet():NewRow()
	oExcelCLS:GetWrkSheet():NewCell(aWrkSht[nWrk][2],,oStyleTit:GetCodigo())
	oExcelCLS:GetWrkSheet():EndRow()
	oExcelCLS:GetWrkSheet():WrtHdrCols()

	DbSelectArea(cAlias)
	(cAlias)->( DbGoTop() )

	//Imprime detalhes
	fImpDet(oExcelCLS, cAlias, lContab, aCampos, lTotal, cOrdem, lSF1)

	//Fecha tabela temporaria da Filial
	(cAlias)->( dbCloseArea() )
	fErase( cArq + GetDbExtension() )

Next nWrk

Return .T.

/*==========================================================================
|Funcao     | GetDtDesc         | Bianca Massarotto     | Data | 14/06/11  |
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
|Funcao     | GetDescFil        | Bianca Massarotto     | Data | 14/06/11  |
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
|Funcao     | fTipoNF           | Bianca Massarotto     | Data | 14/06/11  |
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
	Case cCampo == "DTDIGIT"
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
	Case cCampo == "TEXTO"
		cRetorno := Upper(&cCampo)
	Case cCampo == "DUPLIC"
		cRetorno := IIF(&cCampo == "S", "Sim", "Não")
	Case cCampo == "ESTOQUE"
		cRetorno := IIF(&cCampo == "S", "Sim", "Não")
	Case cCampo == "PODER3"
		cRetorno := IIF(&cCampo == "R", "Remessa", IIF(&cCampo == "D", "Devolução", "Não Controla"))
	Case cCampo == "ICM"
		cRetorno := IIF(&cCampo == "S", "Sim", "Não")
	Case cCampo == "CREDICM"
		cRetorno := IIF(&cCampo == "S", "Sim", "Não")
	Case cCampo == "LFICM"
		If &cCampo == "T"
			cRetorno := "Tributado"
		ElseIf &cCampo == "I"
			cRetorno := "Isento"
		ElseIf &cCampo == "O"
			cRetorno := "Outros"
		ElseIf &cCampo == "N"
			cRetorno := "Não"
		ElseIf &cCampo == "Z"
			cRetorno := "ICMS Zerado"
		ElseIf &cCampo == "B"
			cRetorno := "Observação"
		EndIf
	Case cCampo == "LFICMST"
		If &cCampo == "N"
			cRetorno := "Não"
		ElseIf &cCampo == "I"
			cRetorno := "Isento"
		ElseIf &cCampo == "O"
			cRetorno := "Outros"
		ElseIf &cCampo == "T"
			cRetorno := "Tributado"
		EndIf
	Case cCampo == "IPI"
		cRetorno := IIF(&cCampo == "S", "Sim", "Não")
	Case cCampo == "CREDIPI"
		cRetorno := IIF(&cCampo == "S", "Sim", "Não")
	Case cCampo == "LFIPI"
		If &cCampo == "T"
			cRetorno := "Tributado"
		ElseIf &cCampo == "I"
			cRetorno := "Isento"
		ElseIf &cCampo == "O"
			cRetorno := "Outros"
		ElseIf &cCampo == "N"
			cRetorno := "Não"
		ElseIf &cCampo == "Z"
			cRetorno := "IPI Zerado"
		ElseIf &cCampo == "P"
			cRetorno := "Vl.IPI Outr.ICM"
		EndIf
	Case cCampo == "DESTACA"
		cRetorno := IIF(&cCampo == "S", "Sim", "Não")
	Case cCampo == "TPCLIFOR"		
		If &cCampo == "F"
			cRetorno := "Cons.Final"
		Elseif &cCampo == "J"
			cRetorno := "Jurídico"	
		Elseif &cCampo == "L"
			cRetorno := "Produtor Rural"
		Elseif &cCampo == "R"
			cRetorno := "Revendedor"
		Elseif &cCampo == "S"
			cRetorno := "Solidário"
		Elseif &cCampo == "X"
			cRetorno := "Exportação"
		Else	                    
			cRetorno := "Outros"
		Endif
EndCase

Return cRetorno

/*==========================================================================
|Funcao     | fImpDet           | Bianca Massarotto     | Data | 14/06/11  |
============================================================================
|Descricao  | Imprime Detalhes											   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function fImpDet(oExcelCLS, cAlias, lContab, aCampos, lTotal, cOrdem, lSF1)

Local cFilFat	:= ""
Local cItemCC	:= ""
Local cTDesc	:= ""
Local cDItemCC	:= ""
Local cDFilFat	:= ""
Local cSeek		:= ""
Local nRowIni	:= 0
Local nRowAtu	:= 0
Local lFirst
Local bSeek
Local aRowFil  := {}
Local aRowTot  := {}
Local aRowForm := Array(Len(aCampos))


(cAlias)->(DbGoTop())
While (cAlias)->(!Eof())

	//Quebra por Filial
	aRowFil	 := {}
	cFilFat	 := (cAlias)->FILIAL
	cDFilFat := Upper(GetAdvFVal("SM0", "M0_NOME", cEmpAnt+cFilFat, 1, ""))

	While (cAlias)->(!Eof()) .And. cFilFat == (cAlias)->FILIAL

		//Quebra pela Ordem
		lFirst := .T.
		cDtEms := DtoC(StoD((cAlias)->EMISSAO))
		cSeek  := IIf(cOrdem == "1", (cAlias)->(FILIAL+EMISSAO), IIf(cOrdem == "2", (cAlias)->(FILIAL+CONTA) , (cAlias)->(FILIAL+ITEMCC)))
		bSeek  := IIf(cOrdem == "1", {||(cAlias)->(FILIAL+EMISSAO) == cSeek}, IIf(cOrdem == "2", {||(cAlias)->(FILIAL+CONTA) == cSeek},;
									 {||(cAlias)->(FILIAL+ITEMCC) == cSeek}))
   	    cTDesc := IIF(cOrdem == "1", "TOTAL EMISSÃO ["+cDtEms+"]:", IIf(cOrdem == "2", "TOTAL CONTA CONTABIL ["+Alltrim((cAlias)->(CONTA))+"]:",;
					                 "TOTAL ITEM CONTABIL ["+Alltrim((cAlias)->(ITEMCC))+"]:"))

		While (cAlias)->(!Eof()) .And. Eval(bSeek)
			//Adiciona Linha
			If lSF1
				fNfOrig(cAlias)
			EndIf
			oExcelCLS:GetWrkSheet():AddRowData()
			(cAlias)->(DbSkip())
			nRowAtu := oExcelCLS:GetWrkSheet():GetRowAtu()
			If lFirst
				nRowIni := nRowAtu-1
				lFirst  := .F.
			EndIf
		EndDo
		//Total por Ordem
		If lTotal
			aAdd(aRowFil, { cOrdem , nRowAtu })
			RowFormula(oExcelCLS, aRowForm, aCampos, Nil, nRowIni, nRowAtu, cTDesc)
			oExcelCLS:GetWrkSheet():AddRowsBlk()
		EndIf
	EndDo
	//Total por Filial
	If lTotal
		nRowAtu:= oExcelCLS:GetWrkSheet():GetRowAtu()
		aAdd(aRowTot,{"G",nRowAtu })
		cTDesc := "TOTAL FILIAL [" + Alltrim(cFilFat) + " - " + Alltrim(cDFilFat) + "]:"
		RowFormula(oExcelCLS, aRowForm, aCampos, aRowFil, nRowIni, nRowAtu, cTDesc)
		oExcelCLS:GetWrkSheet():AddRowsBlk()
		oExcelCLS:GetWrkSheet():AddRowsBlk()
	EndIf
EndDo
//Total GERAL
If lTotal
	nRowAtu:= oExcelCLS:GetWrkSheet():GetRowAtu()
	cTDesc := "TOTAL GERAL:"
	RowFormula(oExcelCLS, aRowForm, aCampos, aRowTot, nRowIni, nRowAtu, cTDesc)
EndIf

Return

/*==========================================================================
|Funcao     | RowFormula        | Bianca Massarotto     | Data | 14/06/11  |
============================================================================
|Descricao  | Monta fórmula dos totais                           		   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function RowFormula(oExcelCLS, aRowForm, aCampos, aRowTot, nRowIni, nRowAtu, cTDesc)

Local nCt		:= 0
Local nCtA		:= 0
Local cFormula	:= ""

aRowForm[1] := cTDesc
If aRowTot == Nil
	cFormula    := "@=SUM("
	cFormula    += "R[" + AllTrim(Str(nRowIni-nRowAtu)) + "]C"
	If nRowAtu > nRowIni
		cFormula += ":R[-1]C"
	EndIf
	cFormula += ")"
Else
	cFormula := "@=SUM("
	For nCtA := 1 To Len(aRowTot)
		nRowCalc := aRowTot[nCta][2] - nRowAtu
		cFormula += "R[" + AllTrim(Str(nRowCalc)) + "]C,"
	Next nCtA
	cFormula := Left(cFormula, Len(cFormula)-1)
	cFormula += ")"
EndIf

For nCt := 2 To Len(aCampos)
	If aCampos[nCt][8]
		aRowForm[nCt] := cFormula
	EndIf
Next nCt

oExcelCLS:GetWrkSheet():AddRowForm(aRowForm,, -3)

Return

/*==========================================================================
|Funcao     | fNfOrig        | Thiago Gamito	     | Data | 16/01/2014   |
============================================================================
|Descricao  | Retorna Nota Fiscal de Origem                       		   |
============================================================================
|Observações|															   |
==========================================================================*/

Static Function fNfOrig(cAlias)

Local aArea		:= GetArea()
Local cNfOrig	:= ""
Local cSerOrig	:= ""

If AllTrim((cAlias)->ESPECIE) == 'CTE'

	DbSelectArea("SF8")
	SF8->(DbSetOrder(3))
	If SF8->(DbSeek((cAlias)->FILIAL + (cAlias)->DOC + (cAlias)->SERIE + (cAlias)->CLIFOR + (cAlias)->LOJA))

		While SF8->(!Eof()) .And. (cAlias)->FILIAL + (cAlias)->DOC + (cAlias)->SERIE + (cAlias)->CLIFOR + (cAlias)->LOJA == ;
		SF8->F8_FILIAL + SF8->F8_NFDIFRE + SF8->F8_SEDIFRE + SF8->F8_TRANSP + SF8->F8_LOJTRAN

			cNfOrig += SF8->F8_NFORIG + " / "
			cSerOrig += SF8->F8_SERORIG + " / "

			SF8->(DbSkip())

		EndDo

	EndIf

	cNfOrig := SubStr(cNfOrig, 1, Len(cNfOrig)-3)
	cSerOrig := SubStr(cSerOrig, 1, Len(cSerOrig)-3)

EndIf

If Empty(cNfOrig)

	DbSelectArea("SD1")
	SD1->(DbSetOrder(1))
	If SD1->(DbSeek((cAlias)->FILIAL + (cAlias)->DOC + (cAlias)->SERIE + (cAlias)->CLIFOR + (cAlias)->LOJA + (cAlias)->COD + (cAlias)->ITEM))

		cNfOrig := SD1->D1_NFORI
		cSerOrig := SD1->D1_SERIORI

	EndIf

EndIf

RecLock((cAlias), .F.)
	(cAlias)->NFORIG := cNfOrig
	(cAlias)->SERORIG := cSerOrig
MsUnlock()

RestArea(aArea)

Return
