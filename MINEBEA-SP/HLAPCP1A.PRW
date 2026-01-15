#include "protheus.ch"

/*/{Protheus.doc} HLAPCP1A

Rotina para permitir a selecao de multiplas OPs.

@type function
@author Fabricio M Vieira 
@since 30/06/10

/*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ HLAPCP1A ³ Autor ³ Fabricio M Vieira     ³ Data ³ 30/06/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ TOTVS IP Campinas³Contato ³ cps.fabriciom@microsiga.com.br ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Rotina para permitir a selecao de multiplas OPs.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GENERICO                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function HLAPCP1A(cNomeTab, cOPIni, cOPFim, dMaiorData)
	Local	oDlgX
	Local	aAlias		:=					GetArea()
	Local	aAliasTAB	:=	(cNomeTab)->(	GetArea())
	Local	cCadastro	:=	FunDesc()
	Local	oSize		:=	SCxSSize():New(50, 5, 0)
	Local	aCoordDLG	:=	oSize:GetCDialog()
	Local	aCoordLBX	:=	oSize:GetCListBox(5, 5)
	Local	aCoordBtn	:=	oSize:GetCGetDados(0, 0)
	Local	cTitBotao1	:=	"Confirmar"
	Local	cTitBotao2	:=	"Cancelar"
	Local	cTitBotao3	:=	"Marcar Todos"
	Local	cTitBotao4	:=	"Inverter Seleção"
	Local	cTitBotao5	:=	"OK"
	Local	dGetData	:=	dDataBase
	Local	oBotao01
	Local	oBotao02
	Local	cAcaBotao1	:=	{|| lOk := .t., oDlgX:End()}
	Local	cAcaBotao2	:=	{|| lOk := .f., oDlgX:End()}
	Local	cAcaBotao3	:=	{|| MarcaTodos(oList, @aList)}
	Local	cAcaBotao4	:=	{|| Inverter(oList, @aList)}
	Local	cAcaBotao5	:=	{|| MarcaData(oList, @aList, dGetData)}
	Local	oOK			:=	LoadBitmap(GetResources(),'BR_VERDE')
	Local	oNO			:=	LoadBitmap(GetResources(),'BR_VERMELHO')
	Local	aList		:=	{}
	Local	aListAux	:=	{}
	Local	nX
	Local	aTitulos	:=	{'',;
							RetTitle("D3_OP"),;
							RetTitle("C2_PRODUTO"),;
							RetTitle("C2_DATPRI"),;
							RetTitle("C2_DATPRF"),;
							}
	Local	cRetorno	:=	""
	Local	lRetorno	:=	.t.
	Local	nContador	:=	0
	Local	nPosicao	:=	0
	Local	lVerde		:=	.f.
	Local	nStyle		:=	nOr(WS_CAPTION, WS_MAXIMIZEBOX, WS_CHILD)
	Local	dDataX		:=	CtoD("")
	Local	oGrp1
	Local	oGetData
			
	Default	cOPIni		:=	""
	Default	cOPFim		:=	""
	Default	dMaiorData	:=	CtoD("")
	
	Private	lOk			:=	.t.
	
	(cNomeTab)->(DbGoTop())
	Do While !(cNomeTab)->(Eof())
		lVerde		:=	.f.
		
		aListAux	:=	{	lVerde,;
							(cNomeTab)->OP,;
							(cNomeTab)->C2_PRODUTO,;
							(cNomeTab)->C2_DATPRI,;
							(cNomeTab)->C2_DATPRF,;
						}
	
		aAdd(aList, aListAux)

		(cNomeTab)->(DbSkip())
	EndDo
	
	If Empty(aList)
		aListAux	:=	{	lVerde,;
							CriaVar("D3_OP",.f.),;
							CriaVar("C2_PRODUTO",.f.),;
							CriaVar("C2_DATPRI",.f.),;
							CriaVar("C2_DATPRF",.f.),;
						}
		
		aAdd(aList, aListAux)
	EndIf
	
	oDlgX:= MSDialog():New(aCoordDLG[1], aCoordDLG[2], aCoordDLG[3], aCoordDLG[4], cCadastro+" - Selecao de OP(s)",,,,nStyle,,,,oMainWnd,.t.)
	oDlgX:lEscClose := .f.
	oDlgX:lCentered := .t.
	
	oList := TCBrowse():New( aCoordLBX[1], aCoordLBX[2], aCoordLBX[3], aCoordLBX[4]-20,, aTitulos,/*{Array Tamanho Colunas}*/,oDlgX,,,,,{||},,/*oFont*/,,,,,.F.,,.T.,,.F.,,, )
	oList:SetArray(aList)
	oList:bLine	:=	{||{If(	aList[oList:nAt,01],oOK,oNO),;
							aList[oList:nAT,02],;
							aList[oList:nAT,03],;
							aList[oList:nAT,04],;
							aList[oList:nAT,05]	}}
	
	oList:bLDblClick := {|| aList[oList:nAt][1] := !aList[oList:nAt][1], oList:DrawSelect() }

	oBotao01	:=	TButton():New(aCoordBtn[3]-17, aCoordBtn[4]-110	,cTitBotao1, oDlgX, cAcaBotao1, 50, 20 ,,,,.T. )
	oBotao02	:=	TButton():New(aCoordBtn[3]-17, aCoordBtn[4]-050	,cTitBotao2, oDlgX, cAcaBotao2, 50, 20 ,,,,.T. )
	oBotao03	:=	TButton():New(aCoordBtn[3]-17, aCoordLBX[1]		,cTitBotao3, oDlgX, cAcaBotao3, 50, 20 ,,,,.T. )
	oBotao04	:=	TButton():New(aCoordBtn[3]-17, aCoordLBX[1]+060	,cTitBotao4, oDlgX, cAcaBotao4, 50, 20 ,,,,.T. )
	oGrp1		:=	TGroup():New(aCoordBtn[3]-20, aCoordLBX[1]+120, aCoordBtn[3]+03, aCoordLBX[1]+200, " Seleciona data ", oDlgX, CLR_BLACK, CLR_WHITE, .T., .F.)
	oGetData	:=	TGet():New(aCoordBtn[3]-12, aCoordLBX[1]+125, {|u| iif(pCount() > 0, dGetData := u,	dGetData)},	oGrp1, 050, 010,,, CLR_BLACK, CLR_WHITE,,,, .T., "",,, .F., .F.,, .F., .F.,, "dGetData")
	oBotao05	:=	TButton():New(aCoordBtn[3]-12, aCoordLBX[1]+180	,cTitBotao5, oGrp1, cAcaBotao5, 15, 12 ,,,,.T. )

	oDlgX:Activate()
	
	If lOk
		cRetorno	:=	""
		For	nContador := 1 To Len(aList)
			If aList[nContador, 1]	//	Selecionado?	Legenda VERDE.
				cRetorno	+=			aList[nContador][aScan(aTitulos, RetTitle("D3_OP"))]+";"
				dDataX		:=			aList[nContador][aScan(aTitulos, RetTitle("C2_DATPRF"))]
				cOPFim		:=			aList[nContador][aScan(aTitulos, RetTitle("D3_OP"))]
				cOPIni		:=	IIf(Empty(cOPIni), cOPFim, cOPIni)
				dMaiorData	:=	dGetData//IIf(dDataX > dMaiorData, dDataX, dMaiorData)
			EndIf
		Next nContador
	Else
		MsgStop("Operacao interrompida pelo usuario. NENHUMA informacao foi alterada.")
	EndIf
	
	RestArea(aAliasTAB)
	RestArea(aAlias)
	
Return(cRetorno)

*************************************************************************************************************************************************************************
// MarcaTodos - Waldir Baldin - 06/07/2010 - Funcao para Marcar todos os itens da Lista.
*************************************************************************************************************************************************************************
Static Function MarcaTodos(oList, aList)
    Local nI	:= 0
    
    for nI := 1 to len(aList)
		aList[nI, 1] := .T.
	next nI
	oList:DrawSelect()
Return

*************************************************************************************************************************************************************************
// Inverter - Waldir Baldin - 06/07/2010 - Funcao para Inverter a o Status da selecao de todos os itens da Lista.
*************************************************************************************************************************************************************************
Static Function Inverter(oList, aList)
    Local nI	:= 0
    
    for nI := 1 to len(aList)
		aList[nI, 1] := !aList[nI, 1]
	next nI
	oList:DrawSelect()
Return

*************************************************************************************************************************************************************************
// MarcaData - Waldir Baldin - 06/07/2010 - Funcao para Marcar os registros com a data selecionada.
*************************************************************************************************************************************************************************
Static Function MarcaData(oList, aList, dGetData)
    Local nI	:= 0
    
    for nI := 1 to len(aList)
		if aList[nI, 4] == dGetData
			aList[nI, 1] := .T.
		endIf
	next nI
	oList:DrawSelect()
Return(.T.)
