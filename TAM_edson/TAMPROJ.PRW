#Include "Protheus.ch"
#Include "Totvs.ch"
#Include "FWMVCDef.ch"
#INCLUDE "rwmake.ch"
#Include "TOPCONN.CH"
#Include "TopConn.ch"
#Include "Colors.ch"
#Include "Protheus.ch"
#Include "Totvs.ch"
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

User Function TAMPROJ(cProjeto,cCliente,cLoja,cOrigem,nAgdId)
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
	Private cRot	:= 'TAMPROJ'
	Private aRotina   	:= MenuDef()
	Private lInverte 	:= .F.

	ModelDef()
	VIEWDEF()

	// CheckFile('ZP9', 'ZP9050')
//Criando a janela
	DEFINE MSDIALOG oDlgGrp TITLE "Projetos x Contatos" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
//Labels gerais
	@ 004, 003 SAY "PROJETO: " +cProjeto    SIZE 150, 030 FONT oFontSub  OF oDlgGrp COLORS RGB(25, 42, 151) PIXEL
	@ 014, 003 SAY "CLIENTE: " +cCliente    SIZE 150, 030 FONT oFontSub  OF oDlgGrp COLORS RGB(25, 42, 151) PIXEL
	@ 014, 150 SAY "LOJA: "    +cLoja       SIZE 150, 030 FONT oFontSub  OF oDlgGrp COLORS RGB(25, 42, 151) PIXEL

//Botões
	@ 006, (nJanLarg/2-001)-(0052*01) BUTTON oBtnFech  PROMPT "Fechar"        SIZE 050, 018 OF oDlgGrp ACTION (oDlgGrp:End())   FONT oFontBtn PIXEL
// @ 006, (nJanLarg/2-001)-(0052*02) BUTTON oBtnLege  PROMPT "Imp. Boleto"     SIZE 050, 018 OF oDlgGrp ACTION (U_fMoveEST()) PIXEL
// @ 006, (nJanLarg/2-001)-(0052*3) BUTTON oBtnAcao   PROMPT "marca tudo"     SIZE 050, 018 OF oDlgGrp ACTION (MACARTODOS()) PIXEL

//Dados
	@ 024, 003 GROUP oGrpDad TO (nJanAltu/2-003), (nJanLarg/2-003) PROMPT "Grupos (Para imprimir os boletos basta marcar os box desejados, em seguidar clicar em Imp. Boleto): " OF oDlgGrp COLOR 0, 16777215 PIXEL
	oGrpDad:oFont := oFontBtn
	oPanGrid := tPanel():New(033, 006, "", oDlgGrp, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2 - 13),     (nJanAltu/2 - 45))

//Criando o FWMarkBrowse
	ZP8->(DbSelectArea('ZP8'))
	ZP8->(DbSetOrder(5))
	oMark := FWMBrowse():New()
	oMark:SetAlias('ZP8')
	// oMark:SetSemaphore(.T.)
	oMark:SetFilterDefault("ZP8->ZP8_CODPRO=='"+cProjeto+"'")
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
	if TYPE('oMark') == 'O'
		oMark:DeActivate()
		FreeObj(oMark)
	endif
	RestArea(aArea)
Return

Static Function MenuDef()
	Local aRot := {}
	cRot := 'TAMPROJ'
	ADD OPTION aRot Title 'Novo Contato'     Action 'U_AddCont("","","",cRot,"")' Operation 3 Access 0
	// ADD OPTION aRot Title 'Alt/contato'  Action 'U_fVincDesv(2)' Operation 6 Access 0
	ADD OPTION aRot Title 'Alterar'  Action 'VIEWDEF.TAMPROJ' Operation 4 Access 0
	ADD OPTION aRot Title 'Desvincular'  Action 'U_fVincDesv(2)' Operation 6 Access 0

Return aRot


Static Function ModelDef()
	//Na montagem da estrutura do Modelo de dados, o cabeçalho filtrará e exibirá somente 3 campos, já a grid irá carregar a estrutura inteira conforme função fModStruct
	Local oModel      := NIL
	Local oStruCab     := FWFormStruct(1, 'ZP8', {|cCampo| AllTRim(cCampo) $ "ZP8_CODPRO;ZP8_DESCPR;ZP8_CLIENT;ZP8_LOJA;"})
	Local oStruGrid := fModStruct()

	//Monta o modelo de dados, e na Pós Validação, informa a função fValidGrid
	oModel := MPFormModel():New('TAMPROJM', /*bPreValidacao*/, /*{|oModel| fValidGrid(oModel)}*/, /*bCommit*/, /*bCancel*/ )

	//Agora, define no modelo de dados, que terá um Cabeçalho e uma Grid apontando para estruturas acima
	oModel:AddFields('MdFieldZP8', NIL, oStruCab)
	oModel:AddGrid('MdGridZP8', 'MdFieldZP8', oStruGrid, , )

	//Monta o relacionamento entre Grid e Cabeçalho, as expressões da Esquerda representam o campo da Grid e da direita do Cabeçalho
	oModel:SetRelation('MdGridZP8', {;
		{'ZP8_FILIAL', 'xFilial("ZP8")'},;
		{"ZP8_CODPRO",  "ZP8_CODPRO"};
		}, ZP8->(IndexKey(1)))

	//Definindo outras informações do Modelo e da Grid
	oModel:GetModel("MdGridZP8"):SetMaxLine(9999)
	oModel:SetDescription("Atualização Controle de Combustível")
	oModel:SetPrimaryKey({"ZP8_FILIAL", "ZP8_CODPRO"})
	//Desativando a exclusão de linhas
	oModel:GetModel("MdGridZP8"):SetNoInsertLine(.T.)

Return oModel

Static Function ViewDef()
	//Na montagem da estrutura da visualização de dados, vamos chamar o modelo criado anteriormente, no cabeçalho vamos mostrar somente 3 campos, e na grid vamos carregar conforme a função fViewStr
	Local oView        := NIL
	Local oModel    := FWLoadModel('TAMPROJ')
	Local oStruCab  := FWFormStruct(2, "ZP8", {|cCampo| AllTRim(cCampo) $ "ZP8_CODPRO;ZP8_DESCPR;ZP8_CLIENT;ZP8_LOJA;"})
	Local oStruGRID := fViewStr()

	//Define que no cabeçalho não terá separação de abas (SXA)
	oStruCab:SetNoFolder()

	//Cria o View
	oView:= FWFormView():New()
	oView:SetModel(oModel)

	//Cria uma área de Field vinculando a estrutura do cabeçalho com MDFieldZP8, e uma Grid vinculando com MdGridZP8
	oView:AddField('VIEW_ZP8', oStruCab, 'MdFieldZP8')
	oView:AddGrid ('GRID_ZP8', oStruGRID, 'MdGridZP8' )

	//O cabeçalho (MAIN) terá 25% de tamanho, e o restante de 75% irá para a GRID
	oView:CreateHorizontalBox("MAIN", 25)
	oView:CreateHorizontalBox("GRID", 75)

	//Vincula o MAIN com a VIEW_ZP8 e a GRID com a GRID_ZP8
	oView:SetOwnerView('VIEW_ZP8', 'MAIN')
	oView:SetOwnerView('GRID_ZP8', 'GRID')
	oView:EnableControlBar(.T.)

	//Define o campo incremental da grid como o ZP8_ITEM
	oView:AddIncrementField('GRID_ZP8', 'ZP8_ORDEM')
Return oView

//Função chamada para montar o modelo de dados da Grid
Static Function fModStruct()
	Local oStruct
	oStruct := FWFormStruct(1, 'ZP8')
Return oStruct

//Função chamada para montar a visualização de dados da Grid
Static Function fViewStr()
	Local cCampoCom := "ZP8_CODPRO;ZP8_DESCPR;ZP8_CLIENT;ZP8_LOJA;"
	Local oStruct

	//Irá filtrar, e trazer todos os campos, menos os que tiverem na variável cCampoCom
	oStruct := FWFormStruct(2, "ZP8", {|cCampo| !(Alltrim(cCampo) $ cCampoCom)})
Return oStruct


USER FUNCTION AddCont(_cProj,_cCli,_cLoj,_cRotina,_cAgId)
	local cCodContato := ''
	local aBrwCont := {}
	Private oBrwCont
	Private oDlgCont
	Private CORDEM := ''
	Private CGRUPO := ''
	Private cCli := _cCli
	Private cLoj := _cLoj
	Private cRotina := _cRotina
	Private cProj := iif(cRotina=='TAMPROJ',AF8->AF8_PROJET,_cProj)
	Private cAgId := _cAgId
	// Local oOK := LoadBitmap(GetResources(),'br_verde')
	// Local oNO := LoadBitmap(GetResources(),'br_vermelho')
	// Local aList := {}

	DEFINE DIALOG oDlgCont TITLE "Contatos ..." FROM 180,180 TO 550,700 PIXEL

	DBSELECTAREA('ZP8')
	DBSETORDER(1)
	ZP8->(DBGOTOP())

	cSeek :=  iif(cRotina=='TAMPROJ',AF8->(AF8_PROJET+AF8_CLIENT),cProj+cCli )

	ZP8->(MSSEEK(XFILIAL('ZP8')+cSeek))
	while !ZP8->(eof()) .and. cSeek == ZP8->(ZP8_CODPRO+ZP8_CLIENT)
		cCodContato += "'" + ZP8->ZP8_CONTID +"',"
		if cRotina=='AGENDA' // SE A CHAMADA FOR DA AGENDA.
			AADD(aBrwCont,{ZP8->ZP8_CONTID,posicione('SU5',1,xFilial('SU5')+ZP8->ZP8_CONTID,'U5_CONTAT'),posicione('SU5',1,xFilial('SU5')+ZP8->ZP8_CONTID,'U5_EMAIL')   })
		endif
		ZP8->(dbSkip())
	Enddo

	cCodContato := iif(Empty(cCodContato),'',"("+left(cCodContato,len(cCodContato)-1)+")")
	If cRotina=='TAMPROJ'
		// buscar contato para adicionar
		aBrwCont := BuscCont(cCodContato,cRotina)
	endif

	// // Vetor com elementos do Browse
	if Empty(aBrwCont)
		aBrwCont := { {'','',''}}
	endif
	nTamCod := 30
	nTamNom := 80
	nTamEma := 120

	// Cria Browse
	oBrwCont := TCBrowse():New( 0,0,260,156, , , , oDlgCont )

	oBrwCont:AddColumn( ;
		TCColumn():New( "Codigo", ;
		{|| If(oBrwCont:nAt>0 .and. oBrwCont:nAt<=Len(aBrwCont), aBrwCont[oBrwCont:nAt,1], "" ) }, ;
		"@!", , , "LEFT", nTamCod ) )

	oBrwCont:AddColumn( ;
		TCColumn():New( "Nome", ;
		{|| If(oBrwCont:nAt>0 .and. oBrwCont:nAt<=Len(aBrwCont), aBrwCont[oBrwCont:nAt,2], "" ) }, ;
		"@!", , , "LEFT", nTamNom ) )

	oBrwCont:AddColumn( ;
		TCColumn():New( "Email", ;
		{|| If(oBrwCont:nAt>0 .and. oBrwCont:nAt<=Len(aBrwCont), aBrwCont[oBrwCont:nAt,3], "" ) }, ;
		"@!", , , "LEFT", nTamEma ) )

	// Liga o array
	oBrwCont:SetArray(aBrwCont)
	oBrwCont:Refresh()
	oBrwCont:SetFocus()

	// Monta a linha a ser exibina no Browse
	oBrwCont:bLine := {||{  aBrwCont[oBrwCont:nAt,01],;
		aBrwCont[oBrwCont:nAt,02],;
		aBrwCont[oBrwCont:nAt,03] } }

	// Evento de clique no cabeçalho da browse
	// oBrwCont:bHeaderClick := {|o, nCol| alert('bHeaderClick') }

	// Evento de duplo click na celula
	// oBrwCont:bLDblClick := {|| alert('bLDblClick') }
	cButton := iif(cRotina=='TAMPROJ',"Vincular",'Adicionar')
	// Cria Botoes com metodos básicos
	TButton():New( 160, 002, cButton , oDlgCont,{|| /*oBrwCont:GoUp(),*/ Fvincul(oBrwCont:nAt,aBrwCont,cProj,cRotina) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New( 160, 052, 'Fechar', oDlgCont,{|| /*oBrwCont:GoUp(),*/ oDlgCont:End() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	// TButton():New( 160, 052, "GoDown()" , oDlgCont,{|| oBrwCont:GoDown(), oBrwCont:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	// TButton():New( 160, 102, "GoTop()" , oDlgCont,{|| oBrwCont:GoTop(),oBrwCont:setFocus()}, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F.)
	// TButton():New( 160, 152, "GoBottom()", oDlgCont,{|| oBrwCont:GoBottom(),oBrwCont:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
	// TButton():New( 172, 002, "Linha atual", oDlgCont,{|| alert(oBrwCont:nAt) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	// TButton():New( 172, 052, "Nr Linhas", oDlgCont,{|| alert(oBrwCont:nLen) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	// TButton():New( 172, 102, "Linhas visiveis", oDlgCont,{|| alert(oBrwCont:nRowCount()) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
	// TButton():New( 172, 152, "Alias", oDlgCont,{|| alert(oBrwCont:cAlias) },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)

	ACTIVATE DIALOG oDlgCont CENTERED

RETURN

// buscar os contatos que ainda não estão vinculados
Static Function BuscCont(cCodContato,cRotina)
	Local cAliasCont := GetNextAlias()
	Local aBrw := {}
	Local CCLIENTE := AF8->(AF8_CLIENT+AF8_LOJA)
	local cQry := ''

	cQry += "  SELECT * FROM " + RetSqlName('AC8') + " AC8 (NOLOCK)"
	cQry += " WHERE D_E_L_E_T_='' AND "
	cQry += " AC8_CODENT= '"+CCLIENTE+"' "
	If !Empty(AllTrim(cCodContato)) //.and. cRotina=='TAMPROJ'
		cQry += " AND AC8_CODCON NOT IN "+cCodContato
	EndIf

	//Executando consulta e setando o total da regua
	PlsQuery(cQry, cAliasCont)
	DbSelectArea(cAliasCont)


	While !(cAliasCont)->(EOF())
		AADD(aBrw,{(cAliasCont)->AC8_CODCON,posicione('SU5',1,xFilial('SU5')+(cAliasCont)->AC8_CODCON,'U5_CONTAT'),posicione('SU5',1,xFilial('SU5')+(cAliasCont)->AC8_CODCON,'U5_EMAIL')   })
		(cAliasCont)->(DBSKIP())
	ENDDO
Return aBrw

Static Function Fvincul(nPos,aBrwCont,cProj,cRotina)
	Local cZp8 := GetNextAlias()
	local nq := 0

	CGRUPO := '0001'
	// CASO SEJA CHAMADA DA AGENDA ITVSA010.PRW
	if cRotina =='AGENDA'
		lAchou := iif(aScan(aContatos,{|x| alltrim(x[3]) == alltrim(aBrwCont[nPos,2])})>0,.T.,.F.)
		if !lAchou // SE O CONTATO NHA ESTIVER ASSOCIADO CHAMA A TELA DO GRUPO.
			CGRUPO := TGRUPO()
		endif
	Else
		CGRUPO := TGRUPO()
	endif

	if Empty(aBrwCont[nPos,1])
		MsgStop('Não exitem contatos para serem vinculados.')
		Return
	endif

	if Empty(CGRUPO)
		MsgStop('Para vincular o contato é obrigatorio informar um grupo.')
		Return
	endif

	BeginSql alias cZp8
        SELECT MAX(ZP8_ORDEM) MAX
          FROM %TABLE:ZP8% ZP8
         WHERE %NOTDEL%
           AND ZP8.ZP8_CLIENT = %EXP:AF8->(AF8_CLIENT)%
           AND ZP8.ZP8_LOJA = %EXP:AF8->(AF8_LOJA)%
           AND ZP8.ZP8_GRUPO =  %EXP:CGRUPO%
           AND ZP8.ZP8_CODPRO =  %EXP:cProj%
	EndSql

	if Empty((cZp8)->MAX)
		CORDEM := '001'
	Else
		CORDEM := SOMA1((cZp8)->MAX)
	endif

	if cRotina =='TAMPROJ'
		ZP8->(reclock('ZP8',.T.))
		ZP8->ZP8_CODPRO := AF8->AF8_PROJET
		ZP8->ZP8_DESCPR := AF8->AF8_DESCRI
		ZP8->ZP8_CLIENT := AF8->AF8_CLIENT
		ZP8->ZP8_LOJA 	:= AF8->AF8_LOJA
		ZP8->ZP8_ORDEM 	:=  strzero(val(CORDEM),3)
		ZP8->ZP8_GRUPO 	:= strzero(val(CGRUPO),4)
		ZP8->ZP8_CONTID := aBrwCont[nPos,1]
		ZP8->ZP8_NOME 	:= aBrwCont[nPos,2]
		ZP8->ZP8_EMAIL 	:= aBrwCont[nPos,3]
		ZP8->(MSUNLOCK())

		// Remove o item vinculado do array
		ADel(aBrwCont, nPos)
		ASize(aBrwCont, Len(aBrwCont)-1)

		// Ajusta posição atual
		oBrwCont:nAt := Min(oBrwCont:nAt, Len(aBrwCont))

		// Atualiza a browse
		oBrwCont:SetArray(aBrwCont)
		oBrwCont:Refresh()
		oBrwCont:SetFocus()
	Else
		// ACONTATOS É UMA VARIAVEL PRIVATE VINDO DA ROTINA EXTERNA ITVSA010 CHAMADO NO TBUTTON ALTERAR CONTATOS.
		if empty(aContatos[1,1])
			aContatos := {}
		endif

		// CASO SEJA CHAMADA DA AGENDA ITVSA010.PRW
		if !lAchou // se não existe o contato na grid adiciona
			AADD(aContatos,{CORDEM,CGRUPO,AllTRim(aBrwCont[nPos,2]),AllTrim(aBrwCont[NPOS,3])})
			CORDEM := '000'
			for nq := 1 to len(aContatos)
				CORDEM := SOMA1(CORDEM)
				aContatos[nq,1] := CORDEM
			next nq
		Else
			FwAlertWarning('O contato ja esta associado a agenda, tente associar outro contato.','Atencao!')
		EndIF

		ASort(aContatos,,, {|a,b| ;
			IIf( a[2] == b[2], ;    // Mesmo GRUPO?
		a[1] < b[1], ;         // Ordena pela ORDEM
		a[2] < b[2] ) })       // Senão, ordena pelo GRUPO
		oContatos:SetArray(aContatos)
		oContatos:Refresh()
	endif


Return

Static Function TGRUPO()

	Local oDlgGrupo
	Local oSayGrupo
	Local oGetGrupo
	Local oBtnOk
	Local oBtnCancela

	Local NOPC := 0

	Local cGrupo := '0001'

	DEFINE DIALOG oDlgGrupo TITLE "Informar Grupo"FROM 180,180 TO 350,500 PIXEL

// Cria o Objeto tGet usando o comando @ .. GET
	@ 13,10 SAY oSayGrupo PROMPT "Grupo:" OF oDlgGrupo PIXEL
	@ 10,60 GET oGetGrupo VAR cGrupo SIZE 80,10 OF oDlgGrupo PIXEL VALID ( !Empty(AllTrim(cGrupo)) )

// Botão Confirmar
	@ 60, 40 BUTTON oBtnOk PROMPT "Confirmar" SIZE 40, 10 OF oDlgGrupo ACTION ( NOPC := 1, oDlgGrupo:End() ) PIXEL
	// oBtnOk:setcss()

// Botão Cancelar
	@ 60, 100 BUTTON oBtnCancela PROMPT "Cancelar" SIZE 40, 10 OF oDlgGrupo ACTION oDlgGrupo:End() PIXEL
	ACTIVATE DIALOG oDlgGrupo CENTERED

	if NOPC == 0
		cGrupo := ''
	endif

Return cGrupo
