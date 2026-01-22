#INCLUDE 'Totvs.ch'
#INCLUDE 'ParmType.ch'
#INCLUDE 'FWBrowse.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/*/User Function EDAFRMM
Tela de coltrole de AFRMM
@author Edson Sales
@since 28/01/2025
/*/

User Function EDAFRMM()
	Local aArea := FWGetArea()
	Local aPergs   := {}
	local _cCE 	   := Space(6)
	local _cManif   := Space(6)
	local _cProcesso := Space(17)
	local dDataDe  := FirstDate(Date())
	local dDataAte := LastDate(Date())
	local _cStatus := 'XX'

	//Adicionando os parametros do ParamBox
	aAdd(aPergs, {1, "Data Inicial",  dDataDe,     "", ".T.", "   ", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Data Final",    dDataAte,    "", ".T.", "   ", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "CE Mercante",   _cCE,        "", ".T.", "   ", ".T.", 80, .F.})
	aAdd(aPergs, {1, "Manifesto",   _cManif,        "", ".T.", "   ", ".T.", 80, .F.})
	aAdd(aPergs, {1, "Processo",      _cProcesso,  "", ".T.", "   ", ".T.", 80,  .F.})
	aAdd(aPergs, {2, "Considerar Somente",  _cStatus, {'AB=ABERTO','EP=EM PROCESSO','IN=INDEFERIDO','PG=PAGO','PP=PAGO PARCIAL','DF=DEFERIDO','XX=TODOS'},80, ".T.", .F.})

	If ParamBox(aPergs, "Informe os parametros")
		fMontaTela()
	EndIf
	FWRestArea(aArea)
Return

/*/{Protheus.doc} fMontaTela
Monta a tela com a marcação de dados
@author Edson Sales
@since 28/01/2025
/*/

Static Function fMontaTela()
	Local aCampos := {}
	Local aColunas := {}
	Local cFontPad    := 'Tahoma'
	Local oFontGrid   := TFont():New(cFontPad,,-14)
	//Janela e componentes
	Private aAreaTela         := GetArea()
	Private oTempTable := Nil
	Private oDlgMark
	Private oPanGrid
	Private oMarkBrowse
	Private cAliasTmp := GetNextAlias()
	Private aRotina   := MenuDef()
	//Tamanho da janela
	Private aTamanho := MsAdvSize()
	Private nJanLarg := aTamanho[5]
	Private nJanAltu := aTamanho[6]

	//Adiciona as colunas que serão criadas na temporária
	// aAdd(aCampos, { 'OK', 'C', 2, 0}) //Flag para marcação
	AAdd(aCampos, {"E1_FILIAL"  , "C", TamSX3("E1_FILIAL")[01]  , TamSX3("E1_FILIAL")[02]})
	AAdd(aCampos, {"F2_DOC" 	, "C", TamSX3("F2_DOC")[01]  , TamSX3("F2_DOC")[02]})
	AAdd(aCampos, {"E1_FILORIG"  , "C", TamSX3("E1_FILORIG")[01]  , TamSX3("E1_FILORIG")[02]})
	AAdd(aCampos, {"F2_VALBRUT" , "N", TamSX3("F2_VALBRUT")[01]  , TamSX3("F2_VALBRUT")[02]})
	AAdd(aCampos, {"F2_VALMERC" , "N", TamSX3("F2_VALMERC")[01]  , TamSX3("F2_VALMERC")[02]})
	AAdd(aCampos, {"E1_XCEMERC" , "C", TamSX3("E1_XCEMERC")[01] , TamSX3("E1_XCEMERC")[02]})
	AAdd(aCampos, {"E1_XMANIFE" , "C", TamSX3("E1_XMANIFE")[01] , TamSX3("E1_XMANIFE")[02]})
	AAdd(aCampos, {"E1_XNUMPRO" , "C", TamSX3("E1_XNUMPRO")[01] , TamSX3("E1_XNUMPRO")[02]})
	AAdd(aCampos, {"E1_XDTPRO"  , "D", TamSX3("E1_XDTPRO")[01] , TamSX3("E1_XDTPRO")[02]})
	AAdd(aCampos, {"E1_XSTATUS" , "C", TamSX3("E1_XSTATUS")[01] , TamSX3("E1_XSTATUS")[02]})
	AAdd(aCampos, {"DT6_VALIMP" , "N", TamSX3("DT6_VALIMP")[01]  , TamSX3("DT6_VALIMP")[02]})
	AAdd(aCampos, {"DT6_VALTOT" , "N", TamSX3("DT6_VALTOT")[01]  , TamSX3("DT6_VALTOT")[02]})
	AAdd(aCampos, {"E1_CLIENTE" , "C", TamSX3("E1_CLIENTE")[01]  , TamSX3("E1_CLIENTE")[02]})
	AAdd(aCampos, {"E1_LOJA"    , "C", TamSX3("E1_LOJA")[01] , TamSX3("E1_LOJA")[02]})
	AAdd(aCampos, {"E1_NOMCLI"  , "C", TamSX3("E1_NOMCLI")[01] , TamSX3("E1_NOMCLI")[02]})
	AAdd(aCampos, {"E1_PREFIXO" , "C", TamSX3("E1_PREFIXO")[01] , TamSX3("E1_PREFIXO")[02]})
	AAdd(aCampos, {"E1_NUM"     , "C", TamSX3("E1_NUM")[01] , TamSX3("E1_NUM")[02]})
	AAdd(aCampos, {"E1_PARCELA" , "C", TamSX3("E1_PARCELA")[01] , TamSX3("E1_PARCELA")[02]})
	AAdd(aCampos, {"E1_TIPO"    , "C", TamSX3("E1_TIPO")[01] , TamSX3("E1_TIPO")[02]})
	AAdd(aCampos, {"E1_EMISSAO" , "D", TamSX3("E1_EMISSAO")[01] , TamSX3("E1_EMISSAO")[02]})
	AAdd(aCampos, {"E1_BAIXA"   , "D", TamSX3("E1_BAIXA")[01] , TamSX3("E1_BAIXA")[02]})
	AAdd(aCampos, {"BASE"       , "N", 14 , 2})
	AAdd(aCampos, {"E1_VALOR"   , "N", TamSX3("E1_VALOR")[01] , TamSX3("E1_VALOR")[02]})
	AAdd(aCampos, {"E1_XOBS"    , "C", TamSX3("E1_XOBS")[01] , TamSX3("E1_XSTATUS")[02]})
	//Cria a tabela temporária
	oTempTable:= FWTemporaryTable():New(cAliasTmp)
	oTempTable:SetFields( aCampos )
	oTempTable:AddIndex("1", {"F2_DOC"} )
	oTempTable:AddIndex("2", {"E1_XCEMERC"} )
	oTempTable:AddIndex("3", {"E1_XMANIFE"} )
	oTempTable:AddIndex("4", {"E1_XNUMPRO"} )
	oTempTable:AddIndex("5", {"E1_XDTPRO"} )
	oTempTable:Create()

	//Popula a tabela temporária
	Processa({|| fPopula()}, 'Processando...')

	//Adiciona as colunas que serão exibidas no FWMarkBrowse
	aColunas := fCriaCols()

	aSeek   := {}
	aFields := {}

	aAdd(aSeek,{GetSX3Cache('F2_DOC', "X3_TITULO"), {{"", GetSX3Cache('F2_DOC', "X3_TIPO"), GetSX3Cache('F2_DOC', "X3_TAMANHO"), GetSX3Cache('F2_DOC', "X3_DECIMAL"), AllTrim(GetSX3Cache('F2_DOC', "X3_TITULO")), AllTrim(GetSX3Cache('F2_DOC', "X3_PICTURE"))}} } )
	aAdd(aSeek,{GetSX3Cache('E1_XCEMERC', "X3_TITULO"), {{"", GetSX3Cache('E1_XCEMERC', "X3_TIPO"), GetSX3Cache('E1_XCEMERC', "X3_TAMANHO"), GetSX3Cache('E1_XCEMERC', "X3_DECIMAL"), AllTrim(GetSX3Cache('E1_XCEMERC', "X3_TITULO")), AllTrim(GetSX3Cache('E1_XCEMERC', "X3_PICTURE"))}} } )
	aAdd(aSeek,{GetSX3Cache('E1_XMANIFE', "X3_TITULO"), {{"", GetSX3Cache('E1_XMANIFE', "X3_TIPO"), GetSX3Cache('E1_XMANIFE', "X3_TAMANHO"), GetSX3Cache('E1_XMANIFE', "X3_DECIMAL"), AllTrim(GetSX3Cache('E1_XMANIFE', "X3_TITULO")), AllTrim(GetSX3Cache('E1_XMANIFE', "X3_PICTURE"))}} } )
	aAdd(aSeek,{GetSX3Cache('E1_XNUMPRO', "X3_TITULO"), {{"", GetSX3Cache('E1_XNUMPRO', "X3_TIPO"), GetSX3Cache('E1_XNUMPRO', "X3_TAMANHO"), GetSX3Cache('E1_XNUMPRO', "X3_DECIMAL"), AllTrim(GetSX3Cache('E1_XNUMPRO', "X3_TITULO")), AllTrim(GetSX3Cache('E1_XNUMPRO', "X3_PICTURE"))}} } )
	aAdd(aSeek,{GetSX3Cache('E1_XDTPRO', "X3_TITULO"), {{"", GetSX3Cache('E1_XDTPRO', "X3_TIPO"), GetSX3Cache('E1_XDTPRO', "X3_TAMANHO"), GetSX3Cache('E1_XDTPRO', "X3_DECIMAL"), AllTrim(GetSX3Cache('E1_XDTPRO', "X3_TITULO")), AllTrim(GetSX3Cache('E1_XDTPRO', "X3_PICTURE"))}} } )

	aAdd(aFields,{GetSX3Cache('F2_DOC',     "X3_CAMPO"),GetSX3Cache('F2_DOC',     "X3_TITULO"), GetSX3Cache('F2_DOC', "X3_TIPO"), GetSX3Cache('F2_DOC', "X3_TAMANHO"),     GetSX3Cache('F2_DOC', "X3_DECIMAL"), AllTrim(GetSX3Cache('F2_DOC', "X3_PICTURE"))})
	aAdd(aFields,{GetSX3Cache('E1_XCEMERC', "X3_CAMPO"),GetSX3Cache('E1_XCEMERC', "X3_TITULO"), GetSX3Cache('E1_XCEMERC', "X3_TIPO"), GetSX3Cache('E1_XCEMERC', "X3_TAMANHO"), GetSX3Cache('E1_XCEMERC', "X3_DECIMAL"), AllTrim(GetSX3Cache('E1_XCEMERC', "X3_PICTURE"))})
	aAdd(aFields,{GetSX3Cache('E1_XMANIFE', "X3_CAMPO"),GetSX3Cache('E1_XMANIFE', "X3_TITULO"), GetSX3Cache('E1_XMANIFE', "X3_TIPO"), GetSX3Cache('E1_XMANIFE', "X3_TAMANHO"), GetSX3Cache('E1_XMANIFE', "X3_DECIMAL"), AllTrim(GetSX3Cache('E1_XMANIFE', "X3_PICTURE"))})
	aAdd(aFields,{GetSX3Cache('E1_XDTPRO', "X3_CAMPO"),GetSX3Cache('E1_XDTPRO', "X3_TITULO"), GetSX3Cache('E1_XNUMPRO', "X3_TIPO"), GetSX3Cache('E1_XNUMPRO', "X3_TAMANHO"), GetSX3Cache('E1_XNUMPRO', "X3_DECIMAL"), AllTrim(GetSX3Cache('F2_XNUMPRO', "X3_PICTURE"))})

	//Criando a janela
	DEFINE MSDIALOG oDlgMark TITLE 'Titulos de AFRMM' FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
	//Dados
	oPanGrid := tPanel():New(001, 001, '', oDlgMark, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2)-1,     (nJanAltu/2 - 1))
	oMarkBrowse:= FWMarkBrowse():New()
	oMarkBrowse:SetDescription("Titulos a Receber - AFRMM") //Titulo da Janela
	oMarkBrowse:SetAlias(cAliasTmp)
	oMarkBrowse:oBrowse:SetDBFFilter(.T.)
	oMarkBrowse:oBrowse:SetUseFilter(.F.) //Habilita a utilização do filtro no Browse
	oMarkBrowse:oBrowse:SetFixedBrowse(.T.)
	oMarkBrowse:oBrowse:SetFieldFilter(aFields)
	oMarkBrowse:SetWalkThru(.F.) //Habilita a utilização da funcionalidade Walk-Thru no Browse
	oMarkBrowse:SetAmbiente(.T.) //Habilita a utilização da funcionalidade Ambiente no Browse
	oMarkBrowse:SetTemporary(.T.) //Indica que o Browse utiliza tabela temporária
	oMarkBrowse:oBrowse:SetSeek(.T.,aSeek) //Habilita a utilização da pesquisa de registros no Browse
	oMarkBrowse:oBrowse:SetFilterDefault("") //Indica o filtro padrão do Browse
	// oMarkBrowse:SetFieldMark('OK')
	oMarkBrowse:SetFontBrowse(oFontGrid)
	oMarkBrowse:SetOwner(oPanGrid)
	oMarkBrowse:SetColumns(aColunas)
	oMarkBrowse:Activate()
	ACTIVATE MsDialog oDlgMark CENTERED

	//Deleta a temporária e desativa a tela de marcação
	oTempTable:Delete()
	oMarkBrowse:DeActivate()

	RestArea(aAreaTela)
Return

/*/{Protheus.doc} MenuDef
Botões usados no Browse
@author Edson Sales
@since 28/01/2025
/*/

Static Function MenuDef()
	Local aRotina := {}

	//Criação das opções
	ADD OPTION aRotina TITLE 'Alterar'  ACTION 'u_fTitAfrm(1)'   OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar'  ACTION 'u_fTitAfrm(2)'   OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir Relatório'  ACTION 'u_EDAFRMR01()'   OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Indeferir'  ACTION 'u_fIndeferi(1)'   OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Cancelar indeferimento'  ACTION 'u_fIndeferi(2)'   OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Deferir'  ACTION 'u_fIndeferi(3)'   OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Cancelar deferimento'  ACTION 'u_fIndeferi(4)'   OPERATION 1 ACCESS 0
Return aRotina

/*/{Protheus.doc} fPopula
Executa a query SQL e popula essa informação na tabela temporária usada no browse
@author Edson Sales
@since 28/01/2025
/*/

Static Function fPopula()
	Local cQuery := ''
	Local nTotal := 0
	Local nAtual := 0
	Local cAliasQry := ''

	cAliasQry := GetNextAlias()
	//Monta a consulta
	cQuery := " SELECT E1_NUM,E1_FILIAL,E1_FILORIG,E1_CLIENTE,E1_LOJA,E1_NOMCLI,"
	cQuery += " E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_EMISSAO,E1_BAIXA,E1_VALOR,"
	cQuery += " E1_XCEMERC,E1_XMANIFE,E1_XNUMPRO,E1_XDTPRO,E1_XSTATUS,E1_XOBS,"
	cQuery += " F2_DOC,F2_VALMERC,F2_VALBRUT,DT6_VALTOT,DT6_VALIMP "
	cQuery += " FROM " + RetSqlName("SE1") + " E1 "
	cQuery += " LEFT JOIN " + RetSqlName("SF2") + " F2 ON F2.D_E_L_E_T_ = ' ' "
	cQuery += " AND F2_DOC=E1_NUM "
	cQuery += " LEFT JOIN " + RetSqlName("DT6") + " T6 ON T6.D_E_L_E_T_ = ' ' "
	cQuery += " AND F2_DOC=DT6_DOC AND F2_SERIE = DT6_SERIE AND F2_CLIENTE=DT6_CLIDEV AND F2_LOJA=DT6_LOJDEV "
	cQuery += " WHERE E1.E1_FILIAL = '" + FWxFILIAL("SE1") + "' "
	if !Empty(mv_par01) .and. !Empty(mv_par02)
		cQuery += " AND E1_EMISSAO between '" +DTOS(mv_par01)+ "' and '"+DTOS(mv_par02) +"' "
	EndIf
	cQuery += "  AND E1.E1_TIPO = 'AFR' "
	cQuery += "  AND E1.E1_CLIENTE = '000000' "
	cQuery += "  AND E1.E1_LOJA = '02' "
	cQuery += "  AND E1.D_E_L_E_T_ = ' ' "
	if !Empty(mv_par03)
		cQuery += "  AND E1.E1_XCEMERC=  '" +mv_par03 + "'"
	EndIf
	if !Empty(mv_par04)
		cQuery += "  AND E1.E1_XMANIFE=  '" +mv_par04 + "'"
	EndIf
	if !Empty(mv_par05)
		cQuery += "  AND E1.E1_XNUMPRO=  '" +mv_par05 + "'"
	Endif
	If mv_par06 != 'XX' // se for diferente de todos
		cQuery += "  AND E1.E1_XSTATUS=  '" +mv_par06 + "'"
	EndIf
	// cQuery += "  ORDER BY E1_EMISSAO = '02' "

	cQuery := ChangeQuery(cQuery)
	PLSQuery(cQuery, cAliasQry)

	//Definindo o tamanho da régua
	DbSelectArea(cAliasQry)
	Count to nTotal
	ProcRegua(nTotal)
	(cAliasQry)->(DbGoTop())

	//Enquanto houver registros, adiciona na temporária
	While ! (cAliasQry)->(EoF())
		DbSelectArea('SE1')
		DbSetOrder(1)
		cSeek := (cAliasQry)->E1_FILIAL+(cAliasQry)->E1_PREFIXO+(cAliasQry)->E1_NUM+(cAliasQry)->E1_PARCELA+(cAliasQry)->E1_TIPO
		if DbSeek(cSeek) .AND. !SE1->E1_XSTATUS $ 'IN|DF'
			// Se estiver atualizando o status (desde que não esteja indeferido ou deferido)
			if EMPTY(SE1->E1_BAIXA) // EM ABERTO
				if EMPTY(SE1->E1_XNUMPRO)
					_cStatusAtual := "AB"
				Else
					_cStatusAtual := "EP"
				endif
			elseif !EMPTY(SE1->E1_BAIXA) .AND. SE1->E1_SALDO == 0     // BAIXADO
				_cStatusAtual := "PG"
			elseif SE1->E1_SALDO <> SE1->E1_VALOR .AND. SE1->E1_SALDO <> 0    // BAIXA PARCIAL
				_cStatusAtual := "PP"
			EndIf
			IF SE1->E1_XSTATUS != _cStatusAtual
				RecLock('SE1', .F.)
				SE1->E1_XSTATUS := _cStatusAtual
				SE1->(MsUnlock())
			EndIf
		Else
			_cStatusAtual := (cAliasQry)->E1_XSTATUS
		EndIf

		nAtual++

		dDataBaixa  := Posicione("SE5",10,(cAliasQry)->(E1_NUM),"E5_DATA")
		nValorBaixa := Alltrim(Transform(Posicione("SE5",10,(cAliasQry)->(E1_NUM),"E5_VALOR"), "@E 999,999,999.99"))
		IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')

		RecLock(cAliasTmp, .T.)
		(cAliasTMP)->E1_FILIAL      := (cAliasQry)->E1_FILIAL
		(cAliasTMP)->F2_DOC         := (cAliasQry)->F2_DOC
		(cAliasTMP)->E1_FILORIG      := (cAliasQry)->E1_FILORIG
		(cAliasTMP)->F2_VALBRUT     := (cAliasQry)->F2_VALBRUT
		(cAliasTMP)->F2_VALMERC     := (cAliasQry)->F2_VALMERC
		(cAliasTMP)->DT6_VALIMP     := (cAliasQry)->DT6_VALIMP
		(cAliasTMP)->DT6_VALTOT		:= (cAliasQry)->DT6_VALTOT
		(cAliasTMP)->E1_CLIENTE     := (cAliasQry)->E1_CLIENTE
		(cAliasTMP)->E1_LOJA        := (cAliasQry)->E1_LOJA
		(cAliasTMP)->E1_NOMCLI      := (cAliasQry)->E1_NOMCLI
		(cAliasTMP)->E1_PREFIXO     := (cAliasQry)->E1_PREFIXO
		(cAliasTMP)->E1_NUM         := (cAliasQry)->E1_NUM
		(cAliasTMP)->E1_PARCELA     := (cAliasQry)->E1_PARCELA
		(cAliasTMP)->E1_TIPO        := (cAliasQry)->E1_TIPO
		(cAliasTMP)->E1_EMISSAO     := (cAliasQry)->E1_EMISSAO
		(cAliasTMP)->E1_BAIXA       := dDataBaixa
		(cAliasTMP)->BASE     		:= (cAliasQry)->DT6_VALTOT
		(cAliasTMP)->E1_VALOR       := (cAliasQry)->E1_VALOR
		(cAliasTMP)->E1_XCEMERC     := (cAliasQry)->E1_XCEMERC
		(cAliasTMP)->E1_XMANIFE     := (cAliasQry)->E1_XMANIFE
		(cAliasTMP)->E1_XNUMPRO     := (cAliasQry)->E1_XNUMPRO
		(cAliasTMP)->E1_XDTPRO      := (cAliasQry)->E1_XDTPRO
		(cAliasTMP)->E1_XSTATUS     := _cStatusAtual
		(cAliasTMP)->E1_XOBS        := (cAliasQry)->E1_XOBS
		(cAliasTmp)->(MsUnlock())

		(cAliasQry)->(DbSkip())
	EndDo
	(cAliasQry)->(DbCloseArea())
	(cAliasTmp)->(DbGoTop())
Return

/*/{Protheus.doc} fCriaCols
Função que gera as colunas usadas no browse (similar ao antigo aHeader)
@author Edson Sales
@since 28/01/2025
/*/

Static Function fCriaCols()
	Local nAtual   := 0
	Local aColunas := {}
	Local aEstrut  := {}
	Local oColumn

	//Adicionando campos que serão mostrados na tela
	//[1] - Campo da Temporaria
	//[2] - Titulo
	//[3] - Tipo
	//[4] - Tamanho
	//[5] - Decimais
	//[6] - Máscara]
	AAdd(aEstrut, {"E1_FILIAL" ,'Filial' , "C", TamSX3("E1_FILIAL")[01]  , TamSX3("E1_FILIAL")[02],''})
	AAdd(aEstrut, {"F2_DOC" ,   'CTE', "C", TamSX3("F2_DOC")[01]  , TamSX3("F2_DOC")[02],''})
	AAdd(aEstrut, {"E1_FILORIG" ,'FILIAL CTE', "C", TamSX3("E1_FILORIG")[01]  , TamSX3("E1_FILORIG")[02],''})
	AAdd(aEstrut, {"F2_VALBRUT",'Vlr bruto CTE' , "N", TamSX3("F2_VALBRUT")[01]  , TamSX3("F2_VALBRUT")[02],'@E 99,999,999,999.99'})
	AAdd(aEstrut, {"F2_VALMERC" ,'Vlr. Merc', "N", TamSX3("F2_VALMERC")[01]  , TamSX3("F2_VALMERC")[02],'@E 99,999,999,999.99'})
	AAdd(aEstrut, {"E1_XCEMERC",'CE Mercante' ,"C", TamSX3("E1_XCEMERC")[01] , TamSX3("E1_XCEMERC")[02],''})
	AAdd(aEstrut, {"E1_XMANIFE",'Manifesto' ,"C", TamSX3("E1_XMANIFE")[01] , TamSX3("E1_XMANIFE")[02],''})
	AAdd(aEstrut, {"E1_XNUMPRO", 'Num. Processo',"C", TamSX3("E1_XNUMPRO")[01] , TamSX3("E1_XNUMPRO")[02],''})
	AAdd(aEstrut, {"E1_XDTPRO", 'Dt. Processo',"D", TamSX3("E1_XDTPRO")[01] , TamSX3("E1_XDTPRO")[02],''})
	AAdd(aEstrut, {"E1_XSTATUS", 'Status Processo',"C", TamSX3("E1_XSTATUS")[01] , TamSX3("E1_XSTATUS")[02],''})
	AAdd(aEstrut, {"DT6_VALIMP" ,'Icms', "N", TamSX3("DT6_VALIMP")[01]  , TamSX3("DT6_VALIMP")[02],'@E 99,999,999,999.99'})
	AAdd(aEstrut, {"DT6_VALTOT" , 'Frete',"N", TamSX3("DT6_VALTOT")[01]  , TamSX3("DT6_VALTOT")[02],'@E 99,999,999,999.99'})
	AAdd(aEstrut, {"E1_CLIENTE" ,'Cod.cliente', "C", TamSX3("E1_CLIENTE")[01]  , TamSX3("E1_CLIENTE")[02],''})
	AAdd(aEstrut, {"E1_LOJA",'Loja', "C", TamSX3("E1_LOJA")[01] , TamSX3("E1_LOJA")[02],''})
	AAdd(aEstrut, {"E1_NOMCLI",'Nome Cliente', "C", TamSX3("E1_NOMCLI")[01] , TamSX3("E1_NOMCLI")[02],''})
	AAdd(aEstrut, {"E1_PREFIXO",'Prefixo', "C", TamSX3("E1_PREFIXO")[01] , TamSX3("E1_PREFIXO")[02],''})
	AAdd(aEstrut, {"E1_NUM", 'Titulo Afrmm',"C", TamSX3("E1_NUM")[01] , TamSX3("E1_NUM")[02],''})
	AAdd(aEstrut, {"E1_PARCELA",'Parcela', "C", TamSX3("E1_PARCELA")[01] , TamSX3("E1_PARCELA")[02],''})
	AAdd(aEstrut, {"E1_TIPO", 'Tipo',"C", TamSX3("E1_TIPO")[01] , TamSX3("E1_TIPO")[02],''})
	AAdd(aEstrut, {"E1_EMISSAO", 'Emissão',"D", TamSX3("E1_EMISSAO")[01] , TamSX3("E1_EMISSAO")[02],''})
	AAdd(aEstrut, {"E1_BAIXA", 'Venc. Real',"D", TamSX3("E1_BAIXA")[01] , TamSX3("E1_BAIXA")[02],''})
	AAdd(aEstrut, {"BASE", 'Base Afrmm',"N", 14 , 2,'@E 99,999,999,999.99'})
	AAdd(aEstrut, {"E1_VALOR", 'Valor Afrmm',"N", TamSX3("E1_VALOR")[01] , TamSX3("E1_VALOR")[02],'@E 99,999,999,999.99'})
	AAdd(aEstrut, {"E1_XOBS", 'Observações',"C", TamSX3("E1_XOBS")[01] , TamSX3("E1_XSTATUS")[02],''})

	//Percorrendo todos os campos da estrutura
	For nAtual := 1 To Len(aEstrut)
		//Cria a coluna
		oColumn := FWBrwColumn():New()
		oColumn:SetData(&('{|| ' + cAliasTmp + '->' + aEstrut[nAtual][1] +'}'))
		oColumn:SetTitle(aEstrut[nAtual][2])
		oColumn:SetType(aEstrut[nAtual][3])
		oColumn:SetSize(aEstrut[nAtual][4])
		oColumn:SetDecimal(aEstrut[nAtual][5])
		oColumn:SetPicture(aEstrut[nAtual][6])

		//Adiciona a coluna
		aAdd(aColunas, oColumn)
	Next
Return aColunas

User Function fTitAfrm(nOpc)
	Local cSeek := ''
//	Local nContFlds := 0
	//Private aBrowseLotes:= {{space(20),0}}
	Private aColunas:= {"Volume","Quantidade","NÂº do Lote"}
	//Objetos e componentes
	Private aBrowse :={}
	Private  oDlg
	Private oFwLayer
	Private oPanTitulo
	Private oPanGridSE5
	//CabeÃ§alho
	Private oSayTitulo, cSayTitulo := 'Titulo AFRMM '
	//Tamanho da janela
	Private aSize := MsAdvSize(.F.)
	Private nJanLarg := aSize[5]
	Private nJanAltu := aSize[6]
	//Fontes
	Private cFontUti    := "Tahoma"
	Private oFontMod    := TFont():New(cFontUti, , -38)
	Private oFontSub    := TFont():New(cFontUti, , -12)
	Private oFontSubN   := TFont():New(cFontUti, , -12, , .T.)
	Private oFontBtn    := TFont():New(cFontUti, , -12)
	Private oFontSay    := TFont():New(cFontUti, , -10)
	Private aCoors         := FwGetDialogSize()

	cTitPanel := iiF(nOpc==1,'Alterar- Titulos','Visualiza- Titulos')
	lReadOnly := iiF(nOpc==1,.F.,.T.)
	AADD(aBrowse,{(cAliasTMP)->F2_DOC,(cAliasTMP)->E1_EMISSAO,(cAliasTMP)->E1_BAIXA,(cAliasTMP)->E1_XNUMPRO,(cAliasTMP)->E1_XDTPRO,(cAliasTMP)->E1_XCEMERC,(cAliasTMP)->E1_XMANIFE,(cAliasTMP)->E1_XSTATUS,(cAliasTMP)->E1_XOBS})
	cSeek := (cAliasTMP)->E1_FILIAL+(cAliasTMP)->E1_PREFIXO+(cAliasTMP)->E1_NUM+(cAliasTMP)->E1_PARCELA+(cAliasTMP)->E1_TIPO

	// //atualizar o status
	// u_fAtuStat(3)

	//Cria a janela
	DEFINE MSDIALOG oDlg TITLE cSayTitulo  FROM 200, 280 TO nJanAltu, nJanLarg PIXEL
	oPanGET := tPanel():New(020, 001,cTitPanel, oDlg, , , , RGB(000,000,000), RGB(235, 245, 251), (nJanLarg/2)-1,     (nJanAltu/2 - 1),,.T.)
	// Define MsDialog oDlg Title 'Teste' From aCoors[1], aCoors[2] To aCoors[3] / 2, aCoors[4] / 2 Pixel Style DS_MODALFRAME

	//Criando a camada
	oFwLayer := FwLayer():New()
	oFwLayer:init(oDlg,.F.)

	//Adicionando 3 linhas, a de tÃ­tulo, a superior e a do calendÃ¡rio
	oFWLayer:addLine("TIT", 20, .F.)
	oFWLayer:addLine("PAR", 40, .F.)
	oFWLayer:addLine("COR", 40, .F.)

	//Adicionando as colunas das linhas
	oFWLayer:addCollumn("HEADERTEXT",   050, .T., "TIT")
	oFWLayer:addCollumn("BLANKBTN",     050, .T., "TIT")

	oFWLayer:addCollumn("COLGET",       100, .T., "PAR")

	oFWLayer:addCollumn("COLGRID",      100, .T., "COR")

	//Criando os paineis
	oPanHeader := oFWLayer:GetColPanel("HEADERTEXT", "TIT")
	oPanBut    := oFWLayer:GetColPanel("BLANKBTN",    "TIT")
	oPanPar    := oFWLayer:GetColPanel("COLGET"	, 	 "PAR")
	oPanGridSE5   := oFWLayer:GetColPanel("COLGRID",    "COR")

	//TÃ­tulos e SubTÃ­tulos
	oSayTitulo := TSay():New(004, 05, {|| cSayTitulo},oPanHeader, "",oFontSub,  , , , .T., RGB(031, 073, 125), , 120, 30, , , , , , .F., , )

	//Parametros para preenchimento das etiquetas
	oSayCTAC := TSay():New(013, 005, {|| "CTAC :"}, oPanPar, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 120, 30, , , , , , .F., , )
	cCTAC := aBrowse[1,1]
	oTGet1 := TGet():New( 010,35,{|u|if(PCount()==0,cCTAC,cCTAC:=u)},oPanPar,30,10,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cCTAC,,,, )

	oSayEmissao := TSay():New(013, 100, {|| "Data Emissão"}, oPanPar, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 120, 30, , , , , , .F., , )
	dDtEMI := aBrowse[1,2]
	oTGet2 := TGet():New( 010, 150, { | u | If( PCount() == 0, dDtEMI, dDtEMI := u)},oPanPar, 060, 015, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F. ,,"dDtEMI",,,,.T.  )

	oSayDTbx := TSay():New(013, 220, {|| "Pagamento:"}, oPanPar, "", oFontSub, , , , .T., RGB(031, 073, 125), , 120, 30, , , , , , .F., , )
	dDtPG := aBrowse[1,3]
	oTGet3 := TGet():New( 010, 260, { | u | If( PCount() == 0, dDtPG, dDtPG := u)},oPanPar, 060, 015, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F. ,,"dDtPG",,,,.T.  )

	oSayNPro := TSay():New(013, 340, {|| "Num. Processo:"}, oPanPar, "", oFontSub, , , , .T., RGB(031, 073, 125), , 120, 30, , , , , , .F., , )
	cNumPro := aBrowse[1,4]
	oTGet4 := TGet():New( 010,400,{|u|if(PCount()==0,cNumPro,cNumPro:=u)},oPanPar,50,10,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,lReadOnly,.F.,,cNumPro,,,, )

	oSayDTProc := TSay():New(038, 005, {|| "Data Processo"}, oPanPar, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 120, 30, , , , , , .F., , )
	dDtPro := aBrowse[1,5]
	oTGet5 := TGet():New( 035, 060, { | u | If( PCount() == 0, dDtPro, dDtPro := u)},oPanPar, 060, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,lReadOnly,.F. ,,"dDtPro",,,,.T.  )

	oSayCEMerc := TSay():New(038, 130, {|| "CE Mercante "}, oPanPar, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 120, 30, , , , , , .F., , )
	cCEMerc := aBrowse[1,6]
	oTGet5 := TGet():New( 035,170,{|u|if(PCount()==0,cCEMerc,cCEMerc:=u)},oPanPar,50,10,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,lReadOnly,.F.,,cCEMerc,,,, )

	oSayManif := TSay():New(038, 260, {|| "Manifesto "}, oPanPar, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 120, 30, , , , , , .F., , )
	cManif := aBrowse[1,7]
	oTGet5 := TGet():New( 035,300,{|u|if(PCount()==0,cManif,cManif:=u)},oPanPar,50,10,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,lReadOnly,.F.,,cManif,,,, )

	oSayStat := TSay():New(038, 390, {|| "Status:"}, oPanPar, "", oFontSub, , , , .T., RGB(031, 073, 125), , 120, 30, , , , , , .F., , )
	aItems:= {'ABERTO','EM PROCESSO','INDEFERIDO','PAGO','PAGO PARCIAL'}
	cStatus:=   IIF(aBrowse[1,8]=='AB','ABERTO'      ,;
		IIF(aBrowse[1,7]=='EP','EM PROCESSO' ,;
		IIF(aBrowse[1,7]=='IN','INDEFERIDO'  ,;
		IIF(aBrowse[1,7]=='PG','PAGO'        ,;
		IIF(aBrowse[1,7]=='PP','PAGO PARCIAL',;
		IIF(aBrowse[1,7]=='DF','DEFERIDO','';
		))))))
	oCombo := TComboBox():New(035,425,{|u|if(PCount()>0,cStatus:=u,cStatus)},aItems,60,10,oPanPar,,/*{||Alert('Mudou item da combo')}*/,,,,.T.,,,,{|| .F.},,,,,'cStatus')
	// cTGet7 := aBrowse[1,7]
	// oTGet7 := TGet():New( 35,270,{|u|if(PCount()==0,cTGet7,cTGet7:=u)},oPanPar,50,10,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,lReadOnly,.F.,,cTGet7,,,, )

	oSayObs := TSay():New(063, 005, {|| "Observações:"}, oPanPar, "", oFontSub, , , , .T., RGB(031, 073, 125), , 120, 30, , , , , , .F., , )
	cObs := aBrowse[1,9]
	// oTGet8 := TMultiGet():New(35,400, {|u| Iif(PCount() > 0 , cObs := u, cObs)}, oPanPar,70,20, oFontPadrao, , , , , .T., , , /*bWhen*/, , , /*lReadOnly*/, /*bValid*/, , , /*lNoBorder*/, .T.)
	oTGet8 := TGet():New( 060, 050,{|u|if(PCount()==0,cObs,cObs:=u)},oPanPar,80,10,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,lReadOnly,.F.,,cObs,,,, )

	//Criando os botÃµes
	// oBtnRep := TButton():New(006, 001, "Replicar",  oPanBut, {|| replicar()}, 30, 012, , oFontBtn, , .T., , , , , , )
	oBtnSel := TButton():New(006, 100, "Cancelar", oPanBut , {|| oDlg:End()}, 50, 012, , oFontBtn, , .T., , , , , , )
	oBtnSair := TButton():New(006, 160, "Salvar",  oPanBut , {|| FGravar(nOpc,cSeek)},  30, 012, , oFontBtn, , .T., , , , , , )

	//dialog com browse para com os titulos pagos
	// oBrowseSE5 := fwBrowse():New()
	// _cAlias := GetNextAlias()

	// 	cQryS := " SELECT * FROM  " + RetSQLName('SE5')+" SE5 "
	// 	cQryS += " WHERE E5_FILIAL = '"+FWxFilial('SE5')+"' "
	// 	cQryS += " AND SE5.D_E_L_E_T_ = ' ' "
	// 	cQryS += " AND E5_NUMERO ='"+(cAliasTMP)->E1_NUM +"'"
	// 	cQryS += " AND E5_TIPO = '"+(cAliasTMP)->E1_TIPO +"'"

	// 	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQryS)), _cAlias, .T., .F. )
	// 	DbGotop()

	// oBrowseSE5 := FWBrowse():New()
	// oBrowseSE5:disableConfig()
	// oBrowseSE5:disableReport()
	// oBrowseSE5:SetDataQuery()
	// oBrowseSE5:SetAlias(_cAlias)
	// oBrowseSE5:SetQuery(cQryS)
	// oBrowseSE5:setOwner( oPanGridSE5 )
	// oBrowseSE5:SetDescription("Mov. Bancario")
	// //-------------------------------------------------------------------
	// // Adiciona as colunas do Browse
	// //-------------------------------------------------------------------
	// aColumns    := {}
	// aFields     := {}

	// aAdd( aFields, "E5_FILIAL" )
	// aAdd( aFields, "E5_NUMERO" )
	// aAdd( aFields, "E5_TIPO" )
	// aAdd( aFields, "E5_DATA" )
	// aAdd( aFields, "E5_VALOR"  )
	// aAdd( aFields, "E5_BANCO"  )


	// For nContFlds := 1 To Len( aFields )

	// 	AAdd( aColumns, FWBrwColumn():New() )

	// 	aColumns[Len(aColumns)]:SetData( &("{ || " + aFields[nContFlds] + " }") )
	// 	aColumns[Len(aColumns)]:SetTitle( aFields[nContFlds] )
	// 	aColumns[Len(aColumns)]:SetSize( 15 )
	// 	aColumns[Len(aColumns)]:SetID( aFields[nContFlds] )
	// Next nContFlds

	// oBrowseSE5:SetColumns(aColumns)
	// oBrowseSE5:Activate()

	Activate MsDialog oDlg Centered

Return(aBrowse)


/*  Essa função tem como objetivo marcar o processo como:
DEFERIDO/INDEFERIDO
TAMBEM CANCELAR O DEFERIMENTO E INDEFERIMENTO
*/
User Function fIndeferi(nOpt)

	local cSeek := (cAliasTMP)->E1_FILIAL+(cAliasTMP)->E1_PREFIXO+(cAliasTMP)->E1_NUM+(cAliasTMP)->E1_PARCELA+(cAliasTMP)->E1_TIPO
	local lRetMsg := .F.
	Local _cstat := ''

	DbSelectArea('SE1')
	DbSetOrder(1)

	Do Case
	Case nopt==1; cAcao:='indeferimeto' ; _cstat	:= 'IN'
	Case nopt==2; cAcao:='cancelar indeferimeto'
	Case nopt==3; cAcao:='deferimento'  ; _cstat	:= 'DF'
	Case nopt==4; cAcao:='cancelar deferimento' 
	EndCase
	
	lRetMsg := FWAlertYesNo("Continuar: "+cAcao+" de processo Sim / Não", "Atenção Deferir/indeferir ?")
	
	If lRetMsg
		if DbSeek(cSeek,.T.) .and. (nOpt ==1 .or. nOpt ==3)  // indeferimento ou deferimento
			RecLock('SE1', .F.)
			SE1->E1_XSTATUS := _cstat
			SE1->(MsUnlock())
			FWAlertSucess('Processo indeferido com sucesso !!!',   'Gravado')
		elseif (DbSeek(cSeek,.T.) .and. (nOpt == 2 .or. nOpt == 4) .and. SE1->E1_XSTATUS $ ('IN|DF')) // se for cancelamento de indeferimento
			if EMPTY(E1_BAIXA) // EM ABERTO
				if EMPTY(SE1->E1_XNUMPRO)
					_cStatusAtual := "AB"
				Else
					_cStatusAtual := "EP"
				endif
			elseif !EMPTY(E1_BAIXA) .AND. E1_SALDO == 0     // BAIXADO
				_cStatusAtual := "PG"
			elseif E1_SALDO <> E1_VALOR .AND. E1_SALDO <> 0    // BAIXA PARCIAL
				_cStatusAtual := "PP"
			EndIf
			RecLock('SE1', .F.)
			SE1->E1_XSTATUS := _cStatusAtual
			SE1->(MsUnlock())
			FWAlertSucess('Deferimento cancelado com sucesso !!!',   'Gravado')
		endif
	endif

	// DELETAR A TABELA TEMPORARIA PARA POPULAR COM OS DADOS ATUALIZADOS
	cQryUpd := ''
	cQryUpd := " UPDATE "  + CRLF
	cQryUpd += "    " + oTempTable:GetRealName() + " " + CRLF
	cQryUpd += " SET " + CRLF
	cQryUpd += "    D_E_L_E_T_ = '*', " + CRLF
	cQryUpd += "    R_E_C_D_E_L_ = R_E_C_N_O_ " + CRLF

	TCSqlExec(cQryUpd)
	if valtype(oMarkBrowse) == "O"
		oMarkBrowse:DeActivate()
		//Popula a tabela temporária
		Processa({|| fPopula()}, 'Processando...')
		oMarkBrowse:refresh()
	else
		//Popula a tabela temporária
		Processa({|| fPopula()}, 'Processando...')
	EndIf
	SE1->(dbCloseArea())
return
Static Function FGravar(nOpc,cSeek)
	DbSelectArea('SE1')
	DbSetOrder(1)

	if nOpc == 2
		Alert('Somente de Visualização',   'Atenção')
		Return
	endif

	iF DbSeek(cSeek,.T.)
		RecLock('SE1', .F.)
		SE1->E1_XNUMPRO := cNumPro
		SE1->E1_XCEMERC := cCEMerc
		SE1->E1_XMANIFE := cManif
		SE1->E1_XDTPRO  := dDtPro
		SE1->E1_XOBS    := cObs
		SE1->(MsUnlock())

		FWAlertSucess('Gravado com sucesso !!!',   'Gravado')

		// DELETAR A TABELA TEMPORARIA PARA POPULAR COM OS DADOS ATUALIZADOS
		cQryUpd := ''
		cQryUpd := " UPDATE "  + CRLF
		cQryUpd += "    " + oTempTable:GetRealName() + " " + CRLF
		cQryUpd += " SET " + CRLF
		cQryUpd += "    D_E_L_E_T_ = '*', " + CRLF
		cQryUpd += "    R_E_C_D_E_L_ = R_E_C_N_O_ " + CRLF

		TCSqlExec(cQryUpd)

		SE1->(dbCloseArea())
		oMarkBrowse:DeActivate()
		Close(oDlg)
		fPopula()
		oMarkBrowse:refresh()
	EndIf
return

