#INCLUDE 'PROTHEUS.CH'
#INCLUDE "rwmake.ch"
#INCLUDE "totvs.ch"
// #INCLUDE "FWMVCDEF.CH"
#Include "TOPCONN.CH"

/* 
CHAMANDA NA VALIDAÇÃO NO CAMPO CP_PRODUTO. EXISTBLOCK("AMESTE01").AND.U_AMESTE01("SCP",.F.,"CP_PRODUTO")  .AND. u_AMNALTER(2)      
CHAMADA NO MENU OUTRAS AÇOES > PROD ANTERNATIVOS (P.E M105BUT)
*/
User Function AMNALTER(nMode)
	Local aArea := GETAREA()
	Local cAlias := getnextalias()
	Local aPergs:= {}
	Local cProd := SPACE(TamSX3("B1_COD")[01])
	Private nitem  := aScan(aCols, {|x| AllTrim(Upper(x[2])) == alltrim(M->CP_PRODUTO)})

	if nitem == 0
		nitem := Len(aCols)
	endif
	
	//Adicionando os parametros do ParamBox
	if nMode == 1
		aAdd(aPergs, {1, "Produto:",  cProd,     "", ".T.", "SB1", ".T.", 80,  .F.})

		If ParamBox(aPergs, "Informe os parametros")
			beginSQL Alias cAlias
                SELECT  SB2.B2_QATU SALDO FROM %table:SB2% SB2
                WHERE SB2.%notDel% AND
                    B2_COD = %EXP:(MV_PAR01)%
			endSQl
			telaAlter(nMode)
		EndIf
	Else
		beginSQL Alias cAlias
        SELECT  SB2.B2_QATU SALDO FROM %table:SB2% SB2
        WHERE SB2.%notDel% AND
            B2_COD = %EXP:(M->CP_PRODUTO)%
		endSQl

		if (cAlias)->SALDO <= 0 .AND. !EMPTY(M->CP_PRODUTO)
			if FWAlertYesNo("Produto com saldo zero, deseja incluir um alternativo ?", "Sem Saldo !!!")
				telaAlter(nMode)
			endif
		endif
	EndIf


	// beginSQL Alias cAlias
	//     SELECT  SB2.B2_QATU FROM %table:SB2% SB2
	//     WHERE B2_FILIAL = %xFilial:SB2% AND
	//         SB2.%notDel%	 AND B2_QATU <= 0 AND
	//         B2_COD = %EXP:(M->B2_COD)%
	// endSQl

	RestArea(aArea)

Return .T.

Static Function telaAlter(nMode)
	Local aArea       := GetArea()
	// Local cFilter :=  iif(mv_par03==1,"EMISSAO","")
	Local cFontUti    := "Tahoma"
	Local oFontAno    := TFont():New(cFontUti,,-30)
	Local oFontSub    := TFont():New(cFontUti,,-16)
	Local oFontSubN   := TFont():New(cFontUti,,-16,,.T.)
	Local oFontBtn    := TFont():New(cFontUti,,-14)
	//Janela e componentes
	Private oDlgGrp
	Private oPanGrid
	Private oGetGrid
	Private aColunas := {}
	Private cAliasTab := "TMPSBM"
	//Tamanho da janela
	Private    aTamanho := MsAdvSize()
	Private    nJanLarg := aTamanho[5]
	Private    nJanAltu := aTamanho[6]
	Private oTempTable
	Private aCores    	:= {}
	Private aSeek    	:= {}
	Private cCadastro 	:= "Título do Cadastro"
	Private aRotina   	:= {}
	Private cAliasTmp     := "TMP"
	Private lInverte 	:= .F.

	//Cria a temporária
	oTempTable := FWTemporaryTable():New(cAliasTmp)

//Adiciona no array das colunas as que serão incluidas (Nome do Campo, Tipo do Campo, Tamanho, Decimais)
	aStruct := {}
	AAdd(aStruct, {"OK"      	  ,"L",  1, 0,''})
	aAdd(aStruct, {"FILIAL"  	  ,"C", TamSX3("B2_FILIAL")[01]    ,TamSX3("B2_FILIAL")[02]  ,''})
	aAdd(aStruct, {"PRODUTO" 	  ,"C", TamSX3("B1_COD")[01]       ,TamSX3("B1_COD")[02]     ,''})
	aAdd(aStruct, {"DESCRI"  	  ,"C", TamSX3("B1_DESC")[01]      ,TamSX3("B1_DESC")[02]    ,''})
	aAdd(aStruct, {"QUANT"   	  ,"N", TamSX3("B2_QATU")[01]      ,TamSX3("B2_QATU")[02]    ,''})
	aAdd(aStruct, {"ARMAZEN" 	  ,"C", TamSX3("B2_LOCAL")[01]     ,TamSX3("B2_LOCAL")[02]   ,''})
	aAdd(aStruct, {"ARM_DESC"     ,"C", TamSX3("NNR_DESCRI")[01]   ,TamSX3("NNR_DESCRI")[02]   ,''})
	aAdd(aStruct, {"ENDER" 		  , "C",TamSX3("BF_LOCALIZ")[01]   ,TamSX3("BF_LOCALIZ")[02]    ,''})
	

	oTempTable:SetFields( aStruct )
	oTempTable:AddIndex('01', {'PRODUTO'})
	oTempTable:Create()

	fMontaHead()

	//Popula a tabela temporária
	Processa({|| fPopula(nMode)}, 'Processando...')


	//Criando a janela
	DEFINE MSDIALOG oDlgGrp TITLE "Dados" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
	//Labels gerais
	@ 004, 003 SAY "*"                                  SIZE 200, 030 FONT oFontAno  OF oDlgGrp COLORS RGB(149,179,215) PIXEL
	@ 004, 050 SAY "Listagem dos produtos alternativos" SIZE 200, 030 FONT oFontSub  OF oDlgGrp COLORS RGB(031,073,125) PIXEL
	@ 014, 050 SAY "Produto Origem: " /*+M->CP_PRODUTO */   SIZE 200, 030 FONT oFontSubN OF oDlgGrp COLORS RGB(031,073,125) PIXEL

	//Botões
	@ 006, (nJanLarg/2-001)-(0052*01) BUTTON oBtnFech  PROMPT "Fechar"        SIZE 050, 018 OF oDlgGrp ACTION (oDlgGrp:End())   FONT oFontBtn PIXEL
	IF nMode == 2
		@ 006, (nJanLarg/2-001)-(120*01) BUTTON oBtnFech  PROMPT "Salvar"        SIZE 050, 018 OF oDlgGrp ACTION (MontaAlcols(nMode))   FONT oFontBtn PIXEL
	EndIf
	//Dados
	@ 024, 003 GROUP oGrpDad TO (nJanAltu/2-003), (nJanLarg/2-003) PROMPT "Browse" OF oDlgGrp COLOR 0, 16777215 PIXEL
	oGrpDad:oFont := oFontBtn
	oPanGrid := tPanel():New(033, 006, "", oDlgGrp, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2 - 13),     (nJanAltu/2 - 45))
	oGetGrid := FWBrowse():New()
	oGetGrid:DisableFilter()
	oGetGrid:DisableConfig()
	oGetGrid:DisableReport()
	oGetGrid:DisableSeek()
	oGetGrid:DisableSaveConfig()
	oGetGrid:SetFontBrowse(oFontBtn)
	oGetGrid:SetAlias(cAliasTmp)
	oGetGrid:SetDataTable()
	oGetGrid:SetEditCell(.T., {|| .T.})
	oGetGrid:lHeaderClick := .F.
	IF nMode == 2
		oGetGrid:AddMarkColumns(;
			{|| Iif((cAliasTmp)->OK, 'LBOK', 'LBNO') },;      //ícones
		{|| (cAliasTmp)->OK := ! (cAliasTmp)->OK})

		// {|| (cAliasTmp)->OK := ! (cAliasTmp)->OK})
	EndIf
	// oGetGrid:AddLegend(cAliasTmp + "->XXQUANTI == 0", "YELLOW", "Quantidade zerada")
	// oGetGrid:AddLegend(cAliasTmp + "->XXQUANTI <  0", "RED",    "Quantidade menor que zero")
	// oGetGrid:AddLegend(cAliasTmp + "->XXQUANTI >  0", "GREEN",  "Quantidade maior que zero")
	oGetGrid:SetColumns(aColunas)
	oGetGrid:SetOwner(oPanGrid)
	oGetGrid:Activate()
	ACTIVATE MsDialog oDlgGrp CENTERED

	//Deleta a temporaria
	oTempTable:Delete()
	RestArea(aArea)

Return

Static Function MontaAlcols(nMode)

	Local nUlt := Len(aCols)
	Local nCont := 0
	Local lOK := .T.

	DbSelectArea(cAliasTmp)
	(cAliasTmp)->(DbGoTop())

	// verificar item marcados.
	while !(cAliasTmp)->(eof())
		if (cAliasTmp)->OK
			nCont++
		endif
		DbSkip()
	EndDo

	// se não marcar nenhum item
	if nCont == 0
		Alert('Selecione um item antes de salvar ou clique em fechar')
		lOK := .F.
	endif

	// se marcar mais de um
	if nCont >1
		Alert('Somente um item deve ser selecionado por vez')
		lOK := .F.
	endif

	// se estiver tudo ok C592001-0206    031-2367-RFX
	if lOK
		(cAliasTmp)->(DbGoTop())
		while !(cAliasTmp)->(eof())
			// if EMPTY(aCols[nUlt,2])
				if (cAliasTmp)->OK
					aCols[nitem,2] := (cAliasTmp)->PRODUTO
					aCols[nitem,3] := (cAliasTmp)->DESCRI
					aCols[nitem,4] := POSICIONE('SB1',1,xFilial('SB1')+(cAliasTmp)->PRODUTO,'B1_UM')
				endif
			// endif
			(cAliasTmp)->(DbSkip())
		EndDo
		oDlgGrp:End()
	endif
	oGetGrid:refresh()
	oDlgGrp:refresh()
Return


Static Function fPopula(nMode)
	Local nTotal := 0
	Local nAtual := 0
	Local cAliaSGI := getnextalias()
	Local cProdOri := iif(nMode==1,MV_PAR01,M->CP_PRODUTO)

	//Monta a consulta
	beginSQL Alias cAliaSGI
	SELECT B2_FILIAL,GI_PRODALT,B1_DESC,B2_QATU,B2_LOCAL,BF_LOCALIZ,NNR_DESCRI,BF_LOCALIZ
	FROM SGI010 GI 
    INNER JOIN SB1010 B1 ON B1.%notDel% AND B1_COD=GI_PRODALT 
    LEFT JOIN SB2010 B2 ON B2.%notDel% AND B2_COD=GI_PRODALT
    INNER JOIN NNR010 NR ON NR.%notDel% AND B2_LOCAL=NNR_CODIGO 
	LEFT JOIN SBF010 BF ON BF.D_E_L_E_T_='' AND GI_PRODALT=BF_PRODUTO AND BF_LOCAL=B2_LOCAL
    WHERE GI.%notDel% AND  GI_FILIAL = %xFilial:SGI%  AND GI_PRODORI = %EXP:(cProdOri)%

	endSQl

	//Definindo o tamanho da régua
	DbSelectArea(cAliaSGI)
	Count to nTotal
	ProcRegua(nTotal)
	(cAliaSGI)->(DbGoTop())

	DbSelectArea(cAliasTmp)
	//Enquanto houver registros, adiciona na temporária
	While !(cAliaSGI)->(EoF())
		nAtual++
		IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')

		RecLock(cAliasTmp, .T.)
		(cAliasTmp)->OK := .F.
		(cAliasTmp)->FILIAL := (cAliaSGI)->B2_FILIAL
		(cAliasTmp)->PRODUTO := (cAliaSGI)->GI_PRODALT
		(cAliasTmp)->DESCRI  := Alltrim((cAliaSGI)->B1_DESC)
		(cAliasTmp)->QUANT   := (cAliaSGI)->B2_QATU
		(cAliasTmp)->ARMAZEN := (cAliaSGI)->B2_LOCAL
		(cAliasTmp)->ENDER   := (cAliaSGI)->BF_LOCALIZ
		(cAliasTmp)->ARM_DESC := (cAliaSGI)->NNR_DESCRI
		(cAliasTmp)->(MsUnlock())

		(cAliaSGI)->(DbSkip())
	EndDo
	(cAliaSGI)->(DbCloseArea())
	(cAliasTmp)->(DbGoTop())
Return

Static Function fMontaHead()
	Local nAtual
	Local aHeadAux := {}

	//Adicionando colunas
	//[1] - Campo da Temporaria
	//[2] - Titulo
	//[3] - Tipo
	//[4] - Tamanho
	//[5] - Decimais
	//[6] - Máscara
	// aAdd(aHeadAux, { "OK",        'Box'         ,   "C", 2, 0,'' })
	aAdd(aHeadAux, {"FILIAL"  , 'Filial'      , "C", TamSX3("B1_FILIAL")[01]  ,TamSX3("B1_FILIAL")[02]  ,''})
	aAdd(aHeadAux, {"PRODUTO" , 'Produto'     , "C", TamSX3("B1_COD")[01]     ,TamSX3("B1_COD")[02]  ,''})
	aAdd(aHeadAux, {"DESCRI"  , 'Descricao'   , "C", TamSX3("B1_DESC")[01]    ,TamSX3("B1_DESC")[02]     ,''})
	aAdd(aHeadAux, {"QUANT"   , 'Quantidade'  , "C", TamSX3("B2_QATU")[01]    ,TamSX3("B2_QATU")[02]     ,''})
	aAdd(aHeadAux, {"ARMAZEN" , 'Local'       , "C", TamSX3("B2_LOCAL")[01]   ,TamSX3("B2_LOCAL")[02]    ,''})
	aAdd(aHeadAux, {"ARM_DESC", 'Desc. Local' , "C", TamSX3("NNR_DESCRI")[01] ,TamSX3("NNR_DESCRI")[02]    ,''})
	aAdd(aHeadAux, {"ENDER"   , 'Endereco'    , "C", TamSX3("BF_LOCALIZ")[01] ,TamSX3("BF_LOCALIZ")[02]    ,''})

	//Percorrendo e criando as colunas
	For nAtual := 1 To Len(aHeadAux)
		oColumn := FWBrwColumn():New()
		oColumn:SetData(&("{|| " + cAliasTmp + "->" + aHeadAux[nAtual][1] +"}"))
		oColumn:SetTitle(aHeadAux[nAtual][2])
		oColumn:SetType(aHeadAux[nAtual][3])
		oColumn:SetSize(aHeadAux[nAtual][4])
		oColumn:SetDecimal(aHeadAux[nAtual][5])
		oColumn:SetPicture(aHeadAux[nAtual][6])
		aAdd(aColunas, oColumn)
	Next
Return
