#INCLUDE "rwmake.ch"
#INCLUDE "Vkey.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "ExcelCLS.ch"
#INCLUDE "Protheus.ch"

/*==========================================================================
|Funcao     | UATP037   | Autor | Bianca Massarotto    | Data | 27/01/12   |
============================================================================
|Descricao  | Gera planilha excel                                          |
|           | Relatório Notas Fiscais Canceladas						   |
============================================================================
|Modulo     | Faturamento                                                  |
============================================================================
|Observações|															   |
==========================================================================*/
User Function UATP037()
Local	aArea		:= GetArea()
Local	nOpca		:= 0
Local	aSays		:= {}
Local	aButtons	:= {}
Local	cPerg		:= "UTP037"
Private cCadastro	:= "Geração de Planilha - Relatório de Notas Fiscais Canceladas"

// If !u_ChkFunc( Replace( ProcName(), "U_", ""),,,, "a " + cCadastro )
// 	Return
// EndIf

//Configura e Inicializa a rotina
ConfPergs(cPerg)
Pergunte(cPerg, .F.)

aAdd(aSays, "Este programa tem o objetivo de gerar a Planilha em Excel")
aAdd(aSays, "com o Relatório Auditoria de Notas Fiscais Canceladas   " )
aAdd(aSays, "no computador do usuário."                                )
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
		OtherWise
			Exit
	EndCase
EndDo

RestArea( aArea )

Return

/*==========================================================================
| Parametros												   			   |
+--------------------------------------------------------------------------+
| MV_PAR01 // Tipo ?	       											   |
| MV_PAR02 // Filiais ?       											   |
| MV_PAR03 // Data Inicial ?											   |
| MV_PAR04 // Data Final ?												   |
| MV_PAR05 // Nome do Arquivo ?											   |
| MV_PAR06 // Diretório Destino ?										   |
| MV_PAR07 // Executa MS Excel ?										   |
==========================================================================*/
/*==========================================================================
|Funcao     | ConfPergs         | Bianca Massarotto     | Data | 27/01/12  |
============================================================================
|Descricao  | Configura automaticamente as perguntas utilizadas			   |
============================================================================
|Observações|  	                                                           |
==========================================================================*/
Static Function	ConfPergs(cPerg)
Local aPerg := {}

aAdd(aPerg,{"Tipo ?" 	             ,"mv_ch1","N",01,0,0,"C",""				  ,"MV_PAR01","Entada","Saída","Ambos","","",""      ,""					,""})
aAdd(aPerg,{"Filial ?"               ,"mv_ch3","C",80,0,0,"G","U_VldSelFil()"	  ,"MV_PAR03",""      ,""     ,""     ,"","","SELFIL",Space(80)				,""})
aAdd(aPerg,{"Data Inicio ?"          ,"mv_ch4","D",08,0,0,"G",""				  ,"MV_PAR04",""      ,""     ,""     ,"","",""      ,""					,""})
aAdd(aPerg,{"Data Fim ?"             ,"mv_ch5","D",08,0,0,"G",""				  ,"MV_PAR05",""      ,""     ,""     ,"","",""      ,""					,""})
aAdd(aPerg,{"Nome do Arquivo ?"      ,"mv_ch6","C",40,0,0,"G",""                  ,"MV_PAR06",""      ,""     ,""     ,"","",""      ,""					,""})
aAdd(aPerg,{"Diretório Destino ?"    ,"mv_ch7","C",80,0,0,"G","U_ChkPName(,2,.T.)","MV_PAR07",""      ,""     ,""     ,"","","SELDIR",PadR("C:\TEMP\",80)	,""})
aAdd(aPerg,{"Executa MS Excel ?"     ,"mv_ch8","N",01,0,1,"C",""                  ,"MV_PAR08","Sim"   ,"Não"  ,""     ,"","",""      ,""					,""})

//Ajusta o dicionario SX1 corrigindo ou inserido as perguntas necessárias
U_ConfigSx1(cPerg, aPerg)

Return .T.

/*==========================================================================
|Funcao     | GeraExcel         | Bianca Massarotto     | Data | 27/01/12  |
============================================================================
|Descricao  | Executa a geração da planilha excel						   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function GeraExcel()
Local cFiliais , lRet , nTipo
Local dDataIni , dDataFim
Local cFile , cRmtPath , cSrvPath

//Guarda parametros em variáveis
nTipo		:= MV_PAR01
cFiliais  	:= Alltrim(MV_PAR02)
dDataIni	:= MV_PAR03
dDataFim 	:= MV_PAR04
cFile		:= AllTrim(MV_PAR05)
cRmtPath	:= AllTrim(MV_PAR06)
lAbreExl	:= IIf(MV_PAR07 == 1, .T., .F.)

If dDataIni > dDataFim
	Aviso("Atenção!","A Data Inicial não pode ser maior que a Data Final!",{"Ok"})
	Return .F.	
EndIf

If !U_ChkFiliais(cFiliais, .F.)
	Return .F.
EndIf

If Empty(cFile)
	cFile := "Notas Fiscais Canceladas"
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

lRet := CriaXLS(cFile, cSrvPath, @cRmtPath, cFiliais, dDataIni, dDataFim, nTipo)

If lRet
	If lAbreExl
		lRet := U_OpenXLSFile(cRmtPath+cFile)
	Else
		Aviso("Atenção", "O arquivo Excel [" + cFile + "] foi criado com sucesso no diretório [" + cRmtPath + "]!", {"Ok"})
	EndIf
EndIf

Return lRet

/*==========================================================================
|Funcao     | CriaXLS           | Bianca Massarotto     | Data | 27/01/12  |
============================================================================
|Descricao  | Processa a criação do arquivo excel no servidor selecionando |
|           | os dados segundo os parametros passados					   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function CriaXLS(cFile, cSrvPath, cRmtPath, cFiliais, dDataIni, dDataFim, nTipo)
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
Processa({|| lRet := SelDados(@aWrkSht, cFiliais, dDataIni, dDataFim, nTipo)}, "Selecionando Dados...")

//Criação da planilha
If lRet
	Processa({|| lRet := GeraXLS(oExcelCLS, aWrkSht)}, "Criando planilha...")
EndIf

oExcelCLS:Close()

//Transfere planilha excel
If lRet
	Processa({|| lRet := U_CpyXLS2Rmt(cSrvPath, cFile, @cRmtPath)}, "Transferindo Planilha Excel...")
EndIf

fErase(cSrvPath+cFile)

Return lRet

/*==========================================================================
|Funcao     | SelDados          | Bianca Massarotto     | Data | 27/01/12  |
============================================================================
|Descricao  | Executa a seleção dos dados na base de dados SQL 			   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function SelDados(aWrkSht, cFiliais, dDataIni, dDataFim, nTipo)
Local cQuery     := ""
Local cIndice	 := ""
Local cAlias	 := ""
Local cArq       := ""
Local cNameWrk	 := ""
Local xFilial    := ""
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
aAdd(aCpoDef, {"TIPOMOV"	, "C" , 010 , 0 })
aAdd(aCpoDef, {"DTCANC"		, "C" , 008 , 0 })
aAdd(aCpoDef, {"NFISCAL"	, "C" , 009 , 0 })
aAdd(aCpoDef, {"SERIE"  	, "C" , 003 , 0 })
aAdd(aCpoDef, {"ESPECIE" 	, "C" , 005 , 0 })
aAdd(aCpoDef, {"EMISSAO"	, "C" , 008 , 0 })
aAdd(aCpoDef, {"CLIEFOR"	, "C" , 006 , 0 })
aAdd(aCpoDef, {"LOJA"		, "C" , 002 , 0 })
aAdd(aCpoDef, {"NOME"		, "C" , 040 , 0 })
aAdd(aCpoDef, {"UF"			, "C" , 002 , 0 })
aAdd(aCpoDef, {"CGC"	 	, "C" , 014 , 0 })
aAdd(aCpoDef, {"CHAVE"		, "C" , 044 , 0 })

IncProc()
cArq    := CriaTrab(,.F.)
cAlias  := SubStr(cArq, 1, 8)
	
//Chamada da Stored Procedure
IncProc()
cQuery  := "EXEC SP_PLANILHA_NOTAS_FICAIS_CANCELADAS_SEL '" + cFiliais + "','" + DtoS(dDataIni) + "','" + DtoS(dDataFim) + "'," + Alltrim(Str(nTipo))
	
TCQUERY cQuery NEW ALIAS (cAlias)
dbSelectArea(cAlias)
	
IncProc()
U_fSetField(aCpoDef, cAlias, .F.)
	
IncProc()
Copy To &cArq
(cAlias)->( dbCloseArea() )
	
dbUseArea(.T.,, cArq, cAlias, .T. )

IncProc()

cTitulo  := "Notas Fiscais Canceladas"

dbSelectArea( cAlias )
(cAlias)->( DbGoTop() )
While !(cAlias)->(Eof())
	
	xFilial := (cAlias)->FILIAL
	cNameWrk := "FILIAL "+(cAlias)->FILIAL+" - "+Alltrim(Upper(GetAdvFVal("SM0","M0_NOME",cEmpAnt+xFilial,1,"")))

	While !(cAlias)->(Eof()) .And. xFilial == (cAlias)->FILIAL
		(cAlias)->(DbSkip())
	EndDo
	
	AAdd(aWrkSht, { cNameWrk,cTitulo,cAlias,3,2,cPgHeader,XLS_PAGE_LANDSCAPE,nPrtScale,nMgrHeader,;
					nMgrFooter,nPgTop,nPgBottom,nPgLeft,nPgRight,,,DefCols(),cArq,xFilial } )
	
EndDo

If Len(aWrkSht) == 0
	(cAlias)->( dbCloseArea() )
	fErase( cArq + GetDbExtension() )
	MsgStop('Não existem dados para criar o arquivo excel no servidor!' )
	Return .F.
EndIf

Return .T.

/*==========================================================================
|Funcao     | DefCols           | Bianca Massarotto     | Data | 27/01/12  |
============================================================================
|Descricao  | Define as colunas da planila								   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function DefCols()
Local aCampos := {}

//DADOS GERAIS
aAdd(aCampos, {"FILIAL"				, "C" , 002 , 0 , {{ 1 , "Fl." ,,1					}} , .T. , 025.00 , .F. , .T. , .F. })
aAdd(aCampos, {"TIPOMOV"			, "C" , 010 , 0 , {{ 1 , "Tp. Movimento" ,,1		}} , .T. , 090.00 , .F. , .T. , .F. })
aAdd(aCampos, {{||StoD(DTCANC)}		, "D" , 008 , 0 , {{ 1 , "Data Cancel." ,,1		 	}} , .T. , 060.00 , .F. , .T. , .F. })
aAdd(aCampos, {"NFISCAL"			, "C" , 009 , 0 , {{ 1 , "Nota Fiscal" ,,1			}} , .T. , 060.00 , .F. , .T. , .F. })
aAdd(aCampos, {"SERIE"				, "C" , 003 , 0 , {{ 1 , "Serie" ,,1  				}} , .T. , 035.00 , .F. , .T. , .F. })
aAdd(aCampos, {"ESPECIE"			, "C" , 005 , 0 , {{ 1 , "Especie" ,,1 				}} , .T. , 045.00 , .F. , .T. , .F. })
aAdd(aCampos, {{||AModNot(ESPECIE)}	, "C" , 005 , 0 , {{ 1 , "Modelo" ,,1 				}} , .T. , 040.00 , .F. , .T. , .F. })
aAdd(aCampos, {{||StoD(EMISSAO)}	, "D" , 008 , 0 , {{ 1 , "Emissão" ,,1 				}} , .T. , 060.00 , .F. , .T. , .F. })
aAdd(aCampos, {"CLIEFOR"			, "C" , 006 , 0 , {{ 1 , "Cliente / Fornec." ,,1	}} , .T. , 045.00 , .F. , .T. , .F. })
aAdd(aCampos, {"LOJA"				, "C" , 002 , 0 , {{ 1 , "Loja" ,,1					}} , .T. , 045.00 , .F. , .T. , .F. })
aAdd(aCampos, {"NOME"				, "C" , 040 , 0 , {{ 1 , "Nome" ,,1					}} , .T. , 250.00 , .F. , .T. , .F. })
aAdd(aCampos, {"UF"					, "C" , 002 , 0 , {{ 1 , "UF" ,,1	  		 		}} , .T. , 030.00 , .F. , .T. , .F. })
aAdd(aCampos, {"CGC"				, "C" , 014 , 0 , {{ 1 , "CNPJ" ,,1					}} , .T. , 095.00 , .F. , .T. , .F. })
aAdd(aCampos, {"CHAVE"			 	, "C" , 044 , 0 , {{ 1 , "Chave NFE" ,,1	 		}} , .T. , 255.00 , .F. , .T. , .F. })

Return { Nil , aCampos }

/*==========================================================================
|Funcao     | GeraXLS           | Bianca Massarotto     | Data | 27/01/12  |
============================================================================
|Descricao  | Gera o arquivo excel no servidor 							   |
============================================================================
|Observações|															   |
==========================================================================*/
Static Function GeraXLS(oExcelCLS, aWrkSht)
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

For nWrk:=1 To Len(aWrkSht)

	If nWrk == 1
		cAlias  := aWrkSht[nWrk][3]
		cArq    := aWrkSht[nWrk][18]
		DbSelectArea(cAlias)
		(cAlias)->( DbGoTop() )
	EndIf
	
	IncProc()
	
	If nWrk==1
		oExcelCLS:SetWrkSht(nWrk)
	Else
		oExcelCLS:NextWrkSht()
	EndIf

	aCampos := aWrkSht[nWrk][17][2]
	
	oExcelCLS:GetWrkSheet():NewRow()
	oExcelCLS:GetWrkSheet():NewCell(aWrkSht[nWrk][2],,oStyleTit:GetCodigo())
	oExcelCLS:GetWrkSheet():EndRow()
	oExcelCLS:GetWrkSheet():WrtHdrCols()

	xFilial := aWrkSht[nWrk][19]
	DbSelectArea(cAlias)
	While (cAlias)->(!Eof()) .And. xFilial == (cAlias)->FILIAL
		//Adiciona Linha
		oExcelCLS:GetWrkSheet():AddRowData()
		(cAlias)->(DbSkip())
	EndDo
	
Next nWrk

Return .T.

/*==========================================================================
|Funcao     | GetDtDesc         | Bianca Massarotto     | Data | 27/01/12  |
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
|Funcao     | GetDescFil        | Bianca Massarotto     | Data | 27/01/12  |
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
