#Include "Protheus.ch"
#Include "Totvs.ch"
#Include "FWMVCDef.ch"
#INCLUDE "rwmake.ch"
#Include "TOPCONN.CH"
#Include "TopConn.ch"
#Include "Colors.ch"
/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ KNFINR02   ¦ Autor ¦Edson Sales           ¦ Data ¦ 12/07/2023 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ RELPERC   ¦ Relatório da situação dos boletos no banco.                   ¦¦¦
¦¦¦           ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/

User Function TCONPROJ(cProjeto,cCliente,cLoja,cOrigem,nAgdId)
	Local aArea       := GetArea()
	//Fontes
	Local cFontUti    := "Tahoma"
	// Local oFontAno    := TFont():New(cFontUti,,-30)
	Local oFontSub    := TFont():New(cFontUti,,-16)
	// Local oFontSubN   := TFont():New(cFontUti,,-16,,.T.)
	Local oFontBtn    := TFont():New(cFontUti,,-14)
	//Janela e componentes
	Private oDlgGrp
	Private oPanGrid
	Private oGetGrid
	Private aColunas := {}
	Private cAliasTab := GetNextAlias()
	//Tamanho da janela
	Private    aTamanho := MsAdvSize()
	Private    nJanLarg := aTamanho[5]
	Private    nJanAltu := aTamanho[6]
	Private oTempTable
	Private aCores    	:= {}
	Private aSeek    	:= {}
	Private cCadastro 	:= "Título do Cadastro"
	Private aRotina   	:= MenuDef()
	Private cTabela     := "TMP"
	Private lInverte 	:= .F.

	//Cria a temporária
	oTempTable := FWTemporaryTable():New(cTabela)

//Adiciona no array das colunas as que serão incluidas (Nome do Campo, Tipo do Campo, Tamanho, Decimais)
	aStruct := {}
	// AAdd(aStruct, {"OK",        "C",  02, 0,''})
	aAdd(aStruct, {"ORDEM",     "C",  03, 0,''})
	aAdd(aStruct, {"IDCONT",    "C",  06, 0,''})
	aAdd(aStruct, {"NOME",      "C",  60, 0,''})
	aAdd(aStruct, {"EMAIL",     "C",  40, 0,''})
	aAdd(aStruct, {"GRUPO",     "C",  4, 2,''})

	oTempTable:SetFields( aStruct )
	oTempTable:AddIndex('01', {'IDCONT'})
	oTempTable:Create()

	fMontaHead()

	BEGINSQL Alias cAliasTab
        SELECT * FROM %TABLE:ZP8% ZP8
        WHERE ZP8.%NotDel% AND ZP8_CODPRO = %EXP:cProjeto%
	ENDSQL

	DbSelectArea(cTabela)
	DbSelectArea(cAliasTab)
	(cAliasTab)->(DBGOTOP())
	// Insiro todos os dados na minha tabela
	while !(cAliasTab)->(EOF())

		RecLock(cTabela, .T.)
		(cTabela)->(IDCONT)     := (cAliasTab)->ZP8_CONTID
		(cTabela)->(ORDEM)      := (cAliasTab)->ZP8_ORDEM
		(cTabela)->(NOME)       := (cAliasTab)->ZP8_NOME
		(cTabela)->(EMAIL)      := (cAliasTab)->ZP8_EMAIL
		(cTabela)->(GRUPO)      := (cAliasTab)->ZP8_GRUPO

		(cTabela)->(MsUnlock())
		(cAliasTab)->(DBSkip())
	EndDo

	(cTabela)->(DbGoTop())

//Criando a janela
	DEFINE MSDIALOG oDlgGrp TITLE "Projetos x Contatos" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
//Labels gerais
	@ 004, 003 SAY "PROJETO: " +cProjeto    SIZE 150, 030 FONT oFontSub  OF oDlgGrp COLORS RGB(25, 42, 151) PIXEL
	@ 014, 003 SAY "CLIENTE: " +cCliente    SIZE 150, 030 FONT oFontSub  OF oDlgGrp COLORS RGB(25, 42, 151) PIXEL
	@ 014, 150 SAY "LOJA: "    +cLoja       SIZE 150, 030 FONT oFontSub  OF oDlgGrp COLORS RGB(25, 42, 151) PIXEL
	// @ 014, 150 SAY DTOC(MV_PAR01) +" - "+ DTOC(MV_PAR02)  SIZE 150, 030 FONT oFontSubN OF oDlgGrp COLORS RGB(031,073,125) PIXEL

	// aAdd(aSeek,{"NUMBCO" ,{{"","C",LEN(cNossoNum),0,"NUMBCO" ,"@!"}}})
//Botões
	@ 006, (nJanLarg/2-001)-(0052*01) BUTTON oBtnFech  PROMPT "Fechar"        SIZE 050, 018 OF oDlgGrp ACTION (oDlgGrp:End())   FONT oFontBtn PIXEL
// @ 006, (nJanLarg/2-001)-(0052*02) BUTTON oBtnLege  PROMPT "Imp. Boleto"     SIZE 050, 018 OF oDlgGrp ACTION (U_fMoveEST()) PIXEL
// @ 006, (nJanLarg/2-001)-(0052*3) BUTTON oBtnAcao   PROMPT "marca tudo"     SIZE 050, 018 OF oDlgGrp ACTION (MACARTODOS()) PIXEL

//Dados
	@ 024, 003 GROUP oGrpDad TO (nJanAltu/2-003), (nJanLarg/2-003) PROMPT "Grupos (Para imprimir os boletos basta marcar os box desejados, em seguidar clicar em Imp. Boleto): " OF oDlgGrp COLOR 0, 16777215 PIXEL
	oGrpDad:oFont := oFontBtn
	oPanGrid := tPanel():New(033, 006, "", oDlgGrp, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2 - 13),     (nJanAltu/2 - 45))

//Criando o FWMarkBrowse
	oMark := FWMarkBrowse():New()
	oMark:SetAlias(cTabela)
	// oMark:SetFieldMark( 'OK' )    //Campo que será marcado/descmarcado
	oMark:SetAllMark( { || MACARTODOS() })   //Campo que será marcado TODOS /descmarcado TODOS.
	oMark:SetTemporary(.T.)
	oMark:SetInvert(lInverte)
	oMark:SetColumns(aColunas)
	oMark:DisableReport()
// oMark:SetDataTable()

//Inicializa com todos registros marcados
// oMark:AllMark()
// oGetGrid:SetDelete(.F., { || .F. })
// oGetGrid:lHeaderClick := .F.
// oGetGrid:AddLegend(cTabela + "->STATUS == 'PAGO'", "RED",    "Pago")
// oGetGrid:AddLegend(cTabela + "->STATUS == 'EMABERTO'", "GREEN",  "Emaberto")
// oGetGrid:AddLegend(cTabela + "->STATUS == 'CANCELADO'", "BLACK",  "Cancelado")
// oGetGrid:SetColumns(aColunas)
	oMark:SetOwner(oPanGrid)
	oMark:Activate()
	ACTIVATE MsDialog oDlgGrp CENTERED
	oTempTable:Delete()
	oMark:DeActivate()
	FreeObj(oTempTable)
	FreeObj(oMark)
	RestArea(aArea)

//Deleta a temporaria
// oTempTable:Delete()

	RestArea(aArea)

Return

Static Function MenuDef()
	Local aRot := {}

	ADD OPTION aRot Title 'Novo Contato'     Action 'U_fVincDesv(1)' Operation 3 Access 0
	ADD OPTION aRot Title 'Alt/contato'  Action 'U_fVincDesv(2)' Operation 6 Access 0
	// ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zModel1' OPERATION 4 ACCESS 0
	ADD OPTION aRot Title 'Desvincular'  Action 'U_fVincDesv(3)' Operation 6 Access 0

Return aRot

// User Function MACARTODOS()

// 	Local aAreaTMP  := (cTabela)->( GetArea() )
// 	Private cMarca := oMark:Mark()

// 	DbSelectArea(cTabela)
// 	(cTabela)->( DbSetOrder(1) )
// 	(cTabela)->( DbGoTop() )

// 	lMarca := ((cTabela)->OK == cMarca)
// 	while !(cTabela)->(eof())
// 		IF EMPTY(Alltrim((cTabela)->OK))
// 			RecLock(cTabela, .F.)
// 			(cTabela)->OK := If(lMarca, "", cMarca)
// 			MsUnlock()
// 		Else
// 			RecLock(cTabela, .F.)
// 			(cTabela)->OK := ''
// 			MsUnlock()
// 		EndIf
// 		DBSkip()
// 	EndDo
// 	// oMark:AllMark()
// 	oMark:Gotop()
// 	RestArea( aAreaTMP )
// 	// oMark:Refresh()
// Return nil

Static Function fMontaHead()
	Local nAtual
	Local aHeadAux := {}

	//Adicionando colunas
	//[1] - Campo da Temporaria
	//[2] - IDCONT
	//[3] - Tipo
	//[4] - Tamanho
	//[5] - Decimais
	//[6] - Máscara

	// aAdd(aHeadAux, { "OK",        'Box'         ,   "C", 2, 0,'' })
	aAdd(aHeadAux, {"ORDEM",   'Ordem'          ,   "C",  03, 0,''})
	aAdd(aHeadAux, {"IDCONT",  'Cod. Contato'   ,   "C",  06, 0,''})
	aAdd(aHeadAux, {"NOME",    'Nome Contato'   ,   "C",  60, 0,''})
	aAdd(aHeadAux, {"EMAIL",   'Email'          ,   "C",  40, 0,''})
	aAdd(aHeadAux, {"GRUPO",   'Grupo'          ,   "c",  04, 2,''})


	//Percorrendo e criando as colunas
	For nAtual := 1 To Len(aHeadAux)
		oColumn := FWBrwColumn():New()
		oColumn:SetData(&("{|| " + cTabela + "->" + aHeadAux[nAtual][1] +"}"))
		oColumn:SetTitle(aHeadAux[nAtual][2])
		oColumn:SetType(aHeadAux[nAtual][3])
		oColumn:SetSize(aHeadAux[nAtual][4])
		oColumn:SetDecimal(aHeadAux[nAtual][5])
		oColumn:SetPicture(aHeadAux[nAtual][6])
		aAdd(aColunas, oColumn)
	Next
Return

User Function fVincDesv(nOpc)
	if nOpc == 1
		alert('Vinculando...')
	else
		alert('Devinculando...')
	endif
Return
