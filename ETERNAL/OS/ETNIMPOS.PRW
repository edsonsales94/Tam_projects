#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#include "Rwmake.ch"
#include "Font.ch"


#Define COR_PRETO  RGB(0, 0, 0)
#Define COR_CINZA  RGB(220, 220, 220)
//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2
/*/{Protheus.doc} ETNIMPOS
Impressão de Ordem de Serviço por registro posicionado ou parâmetros.
@Autor: Edson Pedro
/*/
User Function ETNIMPOS()
	Local aArea      := GetArea()
	Local aAreaAB6   := {}
	Local cMsg       := ""
	Local nOpc       := 0
	Local dEmisDe    := FirstDate(Date())
	Local dEmisAte   := LastDate(Date())
	Local cOsDe      := "      "
	Local cOsAte     := "ZZZZZZ"
	Local lAgend      := .F.
	Local dAgendDe   := FirstDate(Date())
	Local dAgendAte  := LastDate(Date())
	Local lContinua  := .F.
	Local cAliasQry  := ""
	cMsg := "Deseja considerar a Ordem de Serviço posicionada " + ;
		"ou informar os parâmetros para impressão?"
	nOpc := Aviso(;
		"Impressão da Ordem de Serviço",;
		cMsg,;
		{"OK", "Parâmetros", "Cancelar"},;
		2,;
		"Seleção dos dados")
	Do Case
	Case nOpc == 1
		If Select("AB6") == 0
			MsgStop("A tabela de Ordem de Serviço não está aberta.",;
				"Impressão da OS")
		ElseIf AB6->(Eof())
			MsgStop("Não existe uma Ordem de Serviço posicionada.",;
				"Impressão da OS")
		Else
			aAreaAB6 := AB6->(GetArea())
			dEmisDe   := AB6->AB6_EMISSA
			dEmisAte  := AB6->AB6_EMISSA
			cOsDe     := AB6->AB6_NUMOS
			cOsAte    := AB6->AB6_NUMOS
			lAgend    := !Empty(AB6->AB6_XDTAGE)
			dAgendDe  := fDataAge(;
				AB6->AB6_XDTAGE,;
				AB6->AB6_XDTAGE)
			dAgendAte := dAgendDe
			lContinua := .T.
			AB6->(RestArea(aAreaAB6))
		EndIf
	Case nOpc == 2
		lContinua := fParamOS(;
			@dEmisDe,;
			@dEmisAte,;
			@cOsDe,;
			@cOsAte,;
			@lAgend,;
			@dAgendDe,;
			@dAgendAte)
	Otherwise
		lContinua := .F.
	EndCase
	If lContinua
		cAliasQry := fMontaQry(;
			dEmisDe,;
			dEmisAte,;
			cOsDe,;
			cOsAte,;
			lAgend,;
			dAgendDe,;
			dAgendAte)
		If !Empty(cAliasQry)
			If (cAliasQry)->(Eof())
				MsgInfo(;
					"Nenhuma Ordem de Serviço foi encontrada.",;
					"Impressão da OS")
			Else
				// Função que será criada com FWMSPrinter.
				fImprimeOS(cAliasQry)
			EndIf
			(cAliasQry)->(DbCloseArea())
		EndIf
	EndIf
	RestArea(aArea)
Return
/*/{Protheus.doc} fParamOS
Solicita os filtros para impressão das Ordens de Serviço.
@type Static Function
/*/
Static Function fParamOS(;
		dEmisDe,;
		dEmisAte,;
		cOsDe,;
		cOsAte,;
		lAgend,;
		dAgendDe,;
		dAgendAte)
	Local aPerguntas := {}
	Local aRetorno   := {}
	Local lRet       := .F.
	aAdd(aPerguntas, {1,"Data Emissão",dEmisDe,""  ,".T.",""   ,".T.",80,.T.})
	aAdd(aPerguntas, {1,"Até Emissão",dEmisAte,""  ,".T.",""   ,".T.",80,.T.})
	aAdd(aPerguntas, {1,"Da OS",cOsDe,""  ,".T.",""   ,".T.",80,.F.})
	aAdd(aPerguntas, {1,"Até a OS",cOsAte,""  ,".T.",""   ,".T.",80,.T.})
	aAdd(aPerguntas, {2,"Considerar Agendamento: ",1,{'1=Sim','2=Não'},80,,.T.}) // Tipo caractere
	aAdd(aPerguntas, {1,"Data Agendamento",dAgendDe,""  ,".T.",""   ,".T.",80,.F.})
	aAdd(aPerguntas, {1,"Até Agendamento",dAgendAte,""  ,".T.",""   ,".T.",80,.F.})
	If ParamBox( aPerguntas, "Parâmetros para impressão da OS", @aRetorno )
		dEmisDe   := aRetorno[1]
		dEmisAte  := aRetorno[2]
		cOsDe     := aRetorno[3]
		cOsAte    := aRetorno[4]
		lAgend    := iif(cValToChar(aRetorno[5]) == "1", .T., .F.)
		dAgendDe  := aRetorno[6]
		dAgendAte := aRetorno[7]
		If Empty(dEmisDe) .Or. Empty(dEmisAte)
			MsgStop(;
				"Informe o período de emissão.",;
				"Validação dos parâmetros")
		ElseIf dEmisDe > dEmisAte
			MsgStop(;
				"A data inicial de emissão não pode ser maior que a data final.",;
				"Validação dos parâmetros")
		ElseIf (Empty(cOsDe) .Or. Empty(cOsAte)).And. 'Z' $ Alltrim(cOsAte)
			MsgStop(;
				"Informe a faixa das Ordens de Serviço.",;
				"Validação dos parâmetros")
		ElseIf cOsDe > cOsAte
			MsgStop(;
				"A OS inicial não pode ser maior que a OS final.",;
				"Validação dos parâmetros")
		ElseIf Empty(dAgendDe) .Or. Empty(dAgendAte)
			MsgStop(;
				"Informe o período de agendamento.",;
				"Validação dos parâmetros")
		ElseIf dAgendDe > dAgendAte
			MsgStop(;
				"A data inicial de agendamento não pode ser maior que a data final.",;
				"Validação dos parâmetros")
		Else
			lRet := .T.
		EndIf
	EndIf
Return lRet
/*/{Protheus.doc} fDataAge
Retorna a data efetiva de agendamento da OS.
@type Static Function
/*/
Static Function fDataAge(dDataAge, dDataSol)
	Local dData := CToD("")
	If !Empty(dDataAge)
		dData := dDataAge
	ElseIf !Empty(dDataSol)
		dData := dDataSol
	EndIf
Return dData
/*/{Protheus.doc} fMontaQry
Monta e executa a consulta das Ordens de Serviço.
@type Static Function
/*/
Static Function fMontaQry(;
		dEmisDe,;
		dEmisAte,;
		cOsDe,;
		cOsAte,;
		lAgend,;
		dAgendDe,;
		dAgendAte)
	Local cQuery := ""
	Local cAlias := GetNextAlias()
	cQuery += " SELECT "
	cQuery += "     AB6.AB6_FILIAL, "
	cQuery += "     AB6.AB6_NUMOS, "
	cQuery += "     AB6.AB6_CODCLI, "
	cQuery += "     AB6.AB6_LOJA, "
	cQuery += "     AB6.AB6_EMISSA, "
	cQuery += "     AB6.AB6_ATEND, "
	cQuery += "     AB6.AB6_HORA, "
	cQuery += "     AB6.AB6_XDTAGE AS DTAGEND, "
	cQuery += "     NVL(TRIM(AB6.AB6_XTURNO), AB6.AB6_XTUSOL) AS TURAGEND, "
	cQuery += "     AB6.AB6_XMOTOR, "
	cQuery += "     AB6.AB6_XSOLIC, "
	cQuery += "     AB6.AB6_XTRANS, "
	cQuery += "     AB6.AB6_XVEICU, "
	cQuery += "     AB6.AB6_XTPVEI , "
	cQuery += "     SA1.A1_COD, "
	cQuery += "     SA1.A1_LOJA, "
	cQuery += "     SA1.A1_NOME, "
	cQuery += "     SA1.A1_NREDUZ, "
	cQuery += "     SA1.A1_CGC, "
	cQuery += "     ABS.ABS_END, "
	cQuery += "     ABS.ABS_CEP, "
	cQuery += "     AB7.AB7_ITEM, "
	cQuery += "     AB7.AB7_CODCON, "
	cQuery += "     SU5.U5_CONTAT, "
	cQuery += "     SU5.U5_CELULAR, "
	cQuery += "     AB7.AB7_MEMO1, "
	cQuery += "     AB8.AB8_SUBITE, "
	cQuery += "     AB8.AB8_CODPRO, "
	cQuery += "     AB8.AB8_DESPRO, "
	cQuery += "     SB1.B1_UM, "
	cQuery += "     AB8.AB8_QUANT "
	cQuery += " FROM " + RetSqlName("AB6") + " AB6 "
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 "
	cQuery += "     ON SA1.A1_COD = AB6.AB6_CODCLI "
	cQuery += "     AND SA1.A1_LOJA = AB6.AB6_LOJA "
	cQuery += "     AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += " INNER JOIN " + RetSqlName("AB7") + " AB7 "
	cQuery += "     ON AB7.AB7_FILIAL = AB6.AB6_FILIAL "
	cQuery += "     AND AB7.AB7_NUMOS = AB6.AB6_NUMOS "
	cQuery += "     AND AB7.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN " + RetSqlName("AB8") + " AB8 "
	cQuery += "     ON AB8.AB8_FILIAL = AB7.AB7_FILIAL AND "
	cQuery += "     AB8.AB8_NUMOS = AB7.AB7_NUMOS AND "
	cQuery += "      AB8.AB8_ITEM = AB7.AB7_ITEM "
	cQuery += "     AND AB8.AB8_CODSER BETWEEN '000000' AND '000000' "
	cQuery += "     AND AB8.D_E_L_E_T_ = ' ' "
	cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 "
	cQuery += "     ON SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery += "     AND SB1.B1_COD = AB8.AB8_CODPRO "
	cQuery += "     AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " INNER JOIN " + RetSqlName("ABS") + " ABS "
	cQuery += "     ON ABS.ABS_CODIGO = SA1.A1_COD "
	cQuery += "     AND ABS.ABS_LOJA = SA1.A1_LOJA "
	cQuery += "     AND ABS.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN " + RetSqlName("SU5") + " SU5 "
	cQuery += "     ON SU5.U5_FILIAL = '" + xFilial("SU5") + "' "
	cQuery += "     AND SU5.U5_CODCONT = AB7.AB7_CODCON "
	cQuery += "     AND SU5.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE AB6.AB6_FILIAL = '" + xFilial("AB6") + "' "
	cQuery += " AND AB6.AB6_EMISSA BETWEEN '" + DToS(dEmisDe) + "' "
	cQuery += " AND '" + DToS(dEmisAte) + "' "
	cQuery += " AND AB6.AB6_NUMOS BETWEEN '" + cOsDe + "' "
	cQuery += " AND '" + cOsAte + "' "
	if lAgend
		cQuery += " AND AB6.AB6_XDTAGE "
		cQuery += " BETWEEN '" + DToS(dAgendDe) + "' "
		cQuery += " AND '" + DToS(dAgendAte) + "' "
	endIf
	cQuery += " AND AB6.AB6_CODCLI BETWEEN ' ' AND 'ZZZZZZ' "
	cQuery += " AND AB6.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY "
	cQuery += "     AB6.AB6_NUMOS, "
	cQuery += "     AB7.AB7_ITEM, "
	cQuery += "     AB8.AB8_SUBITE, "
	cQuery += "     AB8.AB8_CODPRO "
	cQuery := ChangeQuery(cQuery)
	TCQuery cQuery New Alias (cAlias)
Return cAlias
/*/{Protheus.doc} fImprimeOS
Realiza a impressão das Ordens de Serviço.
@type Static Function
/*/
Static Function fImprimeOS(cAliasQry)
	Local cArquivo  := ""
	Local cNumOS    := ""
	Local oPrint    := Nil
	Local oFont6    := TFont():New("Arial",, 6,, .F.)
	Local oFont7    := TFont():New("Arial",, 7,, .F.)
	Local oFont7N   := TFont():New("Arial",, 7,, .T.)
	Local oFont8    := TFont():New("Arial",, 8,, .F.)
	Local oFont8N   := TFont():New("Arial",, 8,, .T.)
	Local oFont9N   := TFont():New("Arial",, 9,, .T.)
	Local oFont11N  := TFont():New("Arial",,11,, .T.)
	Local lImprimiu := .F.
	If Select(cAliasQry) == 0
		MsgStop("A consulta da Ordem de Serviço não está aberta.",;
			"Impressão da OS")
		Return
	EndIf
	If (cAliasQry)->(Eof())
		MsgInfo("Nenhuma Ordem de Serviço foi encontrada.",;
			"Impressão da OS")
		Return
	EndIf
	cArquivo := "ORDEM_SERVICO_" + DToS(Date()) + ;
		StrTran(Time(), ":", "") + ".pdf"

	oPrint := FWMSPrinter():New(cArquivo, IMP_PDF, .F., , .T., ;
		.F., , "", .F., , , .T.)

	// Solicita as configuracoes antes de iniciar as paginas.
	oPrint:Setup()
	If oPrint:nModalResult != PD_OK
		Return
	EndIf

	oPrint:SetResolution(72)
	oPrint:SetPortrait()
	oPrint:SetPaperSize(DMPAPER_A4)
	oPrint:SetMargin(10, 10, 10, 10)

	While !(cAliasQry)->(Eof())
		cNumOS := AllTrim((cAliasQry)->AB6_NUMOS)
		fImpUmaOS(;
			oPrint,;
			cAliasQry,;
			cNumOS,;
			oFont6,;
			oFont7,;
			oFont7N,;
			oFont8,;
			oFont8N,;
			oFont9N,;
			oFont11N)
		lImprimiu := .T.
	EndDo

	If lImprimiu
		oPrint:Preview()
	EndIf

Return
/*/{Protheus.doc} fImpUmaOS
Imprime cabeçalho, transporte, observação e itens de uma OS.
@type Static Function
/*/
Static Function fImpUmaOS(oPrint,cAlias,cNumOS,oFont6,oFont7,oFont7N,oFont8,oFont8N,oFont9N,oFont11N)
	Local nLin       := 20
	Local nLinItem   := 0
	Local nLinFim    := 800
	Local nAltItem   := 15
	// Local cObs       := ""
	Local cProduto   := ""
	Local cDescricao := ""
	Local cUnidade   := ""
	Local cQuant     := ""
	Local cNumAtual  := ""
	Local lPrimeira  := .T.
	// Começa a página da OS.
	oPrint:StartPage()
	nLin := fCabecalhoOS(oPrint,cAlias,nLin,oFont6,oFont7,oFont7N,oFont8,oFont8N,oFont9N,oFont11N)
	nLinItem := nLin
	While !(cAlias)->(Eof())
		cNumAtual := AllTrim((cAlias)->AB6_NUMOS)
		If cNumAtual != cNumOS
			Exit
		EndIf
		If nLinItem + nAltItem > nLinFim
			oPrint:EndPage()
			oPrint:StartPage()
			nLinItem := 25
			// Identificação da continuação.
			oPrint:SayAlign(nLinItem,25,"ORDEM DE SERVIÇO Nº " + cNumOS + " - CONTINUAÇÃO",oFont9N,545,15,COR_PRETO,PAD_CENTER,0)
			nLinItem += 22
			nLinItem := fCabItens(oPrint,nLinItem,oFont8N)
		EndIf
		cProduto   := AllTrim((cAlias)->AB8_CODPRO)
		cDescricao := AllTrim((cAlias)->AB8_DESPRO)
		cUnidade   := AllTrim((cAlias)->B1_UM)
		cQuant     := Transform((cAlias)->AB8_QUANT, "@E 999,999,999.999")
		oPrint:SayAlign(nLinItem,30,cProduto,oFont7,75,nAltItem,COR_PRETO,PAD_LEFT,0)
		oPrint:SayAlign(nLinItem,110,cDescricao,oFont7,290,nAltItem,COR_PRETO,PAD_LEFT,0)
		oPrint:SayAlign(nLinItem,405,cUnidade,oFont7,55,nAltItem,COR_PRETO,PAD_CENTER,0)
		oPrint:SayAlign(nLinItem,465,AllTrim(cQuant),oFont7,95,nAltItem,COR_PRETO,PAD_RIGHT,0)
		nLinItem += nAltItem
		lPrimeira := .F.
		(cAlias)->(DbSkip())
	EndDo
	// Linha inferior da grade.
	oPrint:Line(nLinItem,25,nLinItem,570,COR_PRETO)
	If lPrimeira
		oPrint:SayAlign(nLinItem,25,"Nenhum item de coleta encontrado.",oFont7,545,15,COR_PRETO,PAD_CENTER,0)
	EndIf
	oPrint:EndPage()
Return
/*/{Protheus.doc} fCabecalhoOS
Imprime os dados gerais da Ordem de Serviço.
@type Static Function
/*/
Static Function fCabecalhoOS(;
		oPrint,;
		cAlias,;
		nLin,;
		oFont6,;
		oFont7,;
		oFont7N,;
		oFont8,;
		oFont8N,;
		oFont9N,;
		oFont11N)
	Local cLogo       := "\system\lgmid01.png"
	Local cRazao      := "ETERNAL - INDUSTRIA, COMERCIO, SERV. E TRAT. DE RESIDUOS DA AMAZONIA LTDA"
	Local cEndereco   := "RUA GUIANA FRANCESA, 1 - DISTRITO INDUSTRIAL II"
	Local cTelefone   := "92 3616-4700 / 3616-4706"
	Local cCNPJEmp    := "84.527.274/0001-23"
	Local cSite       := "WWW.ETERNALAM.COM.BR" // MV_XSITE
	Local cNumOS      := AllTrim((cAlias)->AB6_NUMOS)
	Local cDataAge    := fFormData((cAlias)->DTAGEND)
	Local cTurno      := iif(AllTrim((cAlias)->TURAGEND) == "M", "MANHA", ;
		iif(AllTrim((cAlias)->TURAGEND) == "T", "TARDE", ;
		iif(AllTrim((cAlias)->TURAGEND) == "N", "NOITE", "")))
	Local cSolicitado := AllTrim((cAlias)->AB6_XSOLIC)
	Local cUsuarioOS  := AllTrim((cAlias)->AB6_ATEND)
	Local cUsuImp     := UsrRetName(RetCodUsr())
	Local cCodCliente := AllTrim((cAlias)->A1_COD)
	Local cLoja       := AllTrim((cAlias)->A1_LOJA)
	Local cNome       := AllTrim((cAlias)->A1_NOME)
	Local cFantasia   := AllTrim((cAlias)->A1_NREDUZ)
	Local cCGC        := AllTrim((cAlias)->A1_CGC)
	Local cEndDest    := AllTrim((cAlias)->ABS_END)
	Local cCep        := AllTrim((cAlias)->ABS_CEP)
	Local cContato    := AllTrim((cAlias)->U5_CONTAT)
	Local cCelular    := AllTrim((cAlias)->U5_CELULAR)
	Local cCriacao    := fFormData((cAlias)->AB6_EMISSA)
	Local cTransp     := Alltrim(Posicione("SX5", 1, xFilial("SX5") + "Z1" + AllTrim((cAlias)->AB6_XTRANS), "X5_DESCRI"))
	Local cTipoVeic   := Alltrim(Posicione("SX5", 1, xFilial("SX5") + "Z2" + AllTrim((cAlias)->AB6_XTPVEI), "X5_DESCRI"))
	Local cMotorista  := ""//AllTrim((cAlias)->AB6_XMOTOR)
	Local cVeiculo    := AllTrim((cAlias)->AB6_XVEICU)
	Local cAjud1     := ""
	Local cAjud2     := ""

	// Local cObs        := AllTrim((cAlias)->AB7_MEMO1)
	Local nX          := 0
	Local nQtdLin     := 0
	Local cLinhaObs   := ""
    /*
     * O caminho ficará vazio por enquanto.
     * Exemplo futuro:
     * cLogo := ""\system\lgmid01.png""
     */
	
    //  Buscar equipe, motorista e veiculo da OS
    U_EquipeOS(cNumOS, @cMotorista, @cAjud1, @cAjud2)

	If !Empty(cLogo)
		oPrint:SayBitmap(15, 25, cLogo, 60, 50)
	EndIf
	// Dados da empresa.
	oPrint:SayAlign(nLin, 110, cRazao, oFont9N, 455, 15, COR_PRETO, PAD_LEFT, 0)
	nLin += 15
	oPrint:SayAlign(nLin, 110, cEndereco, oFont8, 455, 14, COR_PRETO, PAD_LEFT, 0)
	nLin += 14
	oPrint:SayAlign(nLin,110,"FONE: " + cTelefone + " - CNPJ: " + cCNPJEmp + " - " + cSite,oFont8,455,14,COR_PRETO,PAD_LEFT,0)
	nLin += 18
	// Serviço, OS e agendamento.
	oPrint:SayAlign(nLin, 25, "SERVIÇO:", oFont8N, 70, 15, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 95, "COLETA", oFont8, 80, 15, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 175, "OS Nº:", oFont8N, 45, 15, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 220, cNumOS, oFont8, 80, 15, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin,335,"DATA/HORA PROGRAMADA:",oFont8N,145,15,COR_PRETO,PAD_LEFT,0)
	oPrint:SayAlign(nLin,480,cDataAge + " " + cTurno,oFont8,85,15,COR_PRETO,PAD_LEFT,0)
	nLin += 20
	oPrint:Line(nLin, 25, nLin, 570, COR_PRETO)
	nLin += 6
	// Solicitação e impressão.
	oPrint:SayAlign(nLin, 25, "SOLICITADO POR:", oFont6, 80, 12, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 110, cSolicitado, oFont7, 190, 12, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 355, "IMPRESSO EM:", oFont6, 75, 12, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 430, DToC(Date()) + " " + Time(), oFont7, 135, 12, COR_PRETO, PAD_LEFT, 0)
	nLin += 14
	oPrint:SayAlign(nLin, 25, "USUÁRIO:", oFont6, 80, 12, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 110, cUsuarioOS, oFont7, 190, 12, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 355, "IMPRESSO POR:", oFont6, 75, 12, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 430, cUsuImp, oFont7, 135, 12, COR_PRETO, PAD_LEFT, 0)
	nLin += 17
	oPrint:Line(nLin, 25, nLin, 570, COR_PRETO)
	nLin += 5
	// Destino.
	oPrint:SayAlign(nLin, 25, "DESTINO", oFont9N, 545, 15, COR_PRETO, PAD_CENTER, 0)
	nLin += 18
	oPrint:SayAlign(nLin, 25, "CÓDIGO:", oFont7N, 55, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 80, cCodCliente + " / " + cLoja + " - " + cNome, oFont7, 300, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 385, "FANTASIA:", oFont7N, 65, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 450, cFantasia, oFont7, 115, 13, COR_PRETO, PAD_LEFT, 0)
	nLin += 10
	oPrint:SayAlign(nLin, 25, "CPF/CNPJ:", oFont7N, 65, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 90, cCGC, oFont7, 185, 13, COR_PRETO, PAD_LEFT, 0)
	nLin += 10
	oPrint:SayAlign(nLin, 25, "ENDEREÇO:", oFont7N, 65, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 90, cEndDest, oFont7, 360, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 455, "CEP:", oFont7N, 35, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 490, cCep, oFont7, 75, 13, COR_PRETO, PAD_LEFT, 0)
	nLin += 10
	oPrint:SayAlign(nLin, 25, "CONTATO:", oFont7N, 65, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 90, cContato, oFont7, 235, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 330, "TELEFONE:", oFont7N, 65, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 395, cCelular, oFont7, 170, 13, COR_PRETO, PAD_LEFT, 0)
	nLin += 10
	oPrint:SayAlign(nLin, 25, "DATA CRIAÇÃO:", oFont7N, 80, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 105, cCriacao, oFont7, 100, 13, COR_PRETO, PAD_LEFT, 0)
	nLin += 10
	oPrint:Line(nLin, 25, nLin, 570, COR_PRETO)
	nLin += 15
	// Transporte.
	oPrint:SayAlign(nLin, 25, "TRANSPORTADOR:", oFont7N, 95, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 120, cTransp, oFont7, 445, 13, COR_PRETO, PAD_LEFT, 0)
	nLin += 15
	oPrint:SayAlign(nLin, 25, "MOTORISTA:", oFont7N, 70, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 95, iif(!Empty(cMotorista),cMotorista,AllTrim((cAlias)->AB6_XMOTOR)), oFont7, 225, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 325, "VEÍCULO:", oFont7N, 60, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 385, cVeiculo, oFont7, 180, 13, COR_PRETO, PAD_LEFT, 0)
	nLin += 15
	// Campos manuais.
	oPrint:SayAlign(nLin, 25, "TIPO VEÍCULO:", oFont7N, 80, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 105, cTipoVeic, oFont7, 175, 13, COR_PRETO, PAD_LEFT, 0)
	// oPrint:SayAlign(nLin, 300, "TIPO ACOND.:", oFont7N, 80, 13, COR_PRETO, PAD_LEFT, 0)
	// oPrint:SayAlign(nLin, 380, "________________________", oFont7, 185, 13, COR_PRETO, PAD_LEFT, 0)
	nLin += 15
	oPrint:SayAlign(nLin, 25, "AJUDANTE 1:", oFont7N, 75, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 100, iif(!Empty(cAjud1),cAjud1,"________________________"), oFont7, 180, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 300, "AJUDANTE 2:", oFont7N, 75, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 375, iif(!Empty(cAjud2),cAjud2,"________________________"), oFont7, 190, 13, COR_PRETO, PAD_LEFT, 0)
	nLin += 15
	oPrint:SayAlign(nLin, 25, "H. SAÍDA:", oFont7N, 60, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 85, "____:____", oFont7, 70, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 165, "H. CHEGADA DESTINO:", oFont7N, 125, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 290, "____:____", oFont7, 70, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 375, "KM DE SAÍDA:", oFont7N, 85, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 460, "____________", oFont7, 105, 13, COR_PRETO, PAD_LEFT, 0)
	nLin += 15
	oPrint:SayAlign(nLin, 25, "H. SAÍDA DESTINO:", oFont7N, 115, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 140, "____:____", oFont7, 70, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 220, "H. CHEGADA EMPRESA:", oFont7N, 135, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 355, "____:____", oFont7, 70, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 430, "KM DE CHEGADA:", oFont7N, 100, 13, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 530, "______", oFont7, 35, 13, COR_PRETO, PAD_LEFT, 0)
	nLin += 15
	// Observação.
	oPrint:SayAlign(nLin, 25, "OBSERVAÇÃO:", oFont7N, 90, 13, COR_PRETO, PAD_LEFT, 0)
	nLin += 15
	// nQtdLin := MLCount(cObs, 95)
	// For nX := 1 To Min(nQtdLin, 4)
	//     cLinhaObs := MemoLine(cObs, 95, nX)
	//     oPrint:SayAlign(nLin,25,cLinhaObs,oFont7,540,13,COR_PRETO,PAD_LEFT,0)
	//     nLin += 13
	// Next nX

	DBSELECTAREA('AB7')
	AB7->(DBSETORDER(1))
	AB7->(DBSEEK(cFilant+(cAlias)->AB6_NUMOS))
	nLen := MlCount(GetMemo(AB7->AB7_MEMO1),125)

	For nX := 1 to nLen
		cLinhaObs := StrTran(Memoline(GetMemo(AB7->AB7_MEMO1),125,nX),'\13\10',' ')
		oPrint:SayAlign(nLin,25,cLinhaObs,oFont7,540,13,COR_PRETO,PAD_LEFT,0)
		nLin += 13
	Next
	// Mantém espaço mínimo para preenchimento.
	If nQtdLin == 0
		nLin += 40
	Else
		nLin += 10
	EndIf
	oPrint:Line(nLin, 25, nLin, 570, COR_PRETO)
	nLin += 5
	nLin := fCabItens(oPrint, nLin, oFont8N)
Return nLin
/*/{Protheus.doc} fCabItens
Imprime o título e as colunas dos itens da coleta.
@type Static Function
/*/
Static Function fCabItens(oPrint, nLin, oFont8N)
	oPrint:SayAlign(nLin,25,"ITENS DA COLETA",oFont8N,545,15,COR_PRETO,PAD_CENTER,0)
	nLin += 20
	oPrint:SayAlign(nLin, 30, "Código", oFont8N, 75, 15, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 110, "Descrição", oFont8N, 290, 15, COR_PRETO, PAD_LEFT, 0)
	oPrint:SayAlign(nLin, 405, "Unid.", oFont8N, 55, 15, COR_PRETO, PAD_CENTER, 0)
	oPrint:SayAlign(nLin, 465, "Quantidade", oFont8N, 95, 15, COR_PRETO, PAD_RIGHT, 0)
	nLin += 16
	oPrint:Line(nLin, 25, nLin, 570, COR_PRETO)
	nLin += 5
Return nLin
/*/{Protheus.doc} fFormData
Formata datas retornadas pela consulta SQL.
@type Static Function
/*/
Static Function fFormData(xData)
	Local cData := ""
	Do Case
	Case ValType(xData) == "D"
		cData := DToC(xData)
	Case ValType(xData) == "C" .And. Len(AllTrim(xData)) == 8
		cData := DToC(StoD(AllTrim(xData)))
	Otherwise
		cData := ""
	EndCase
Return cData

User Function EquipeOS(cNumOS, cMotorista, cAjud1, cAjud2)

	Local aArea  := GetArea()
	Local cAlias := GetNextAlias()
	Local cQuery := ""
	Local cTipo  := ""
	Local cNome  := ""
	Local lRet   := .F.

	Default cNumOS := ""

	cMotorista := ""
	cAjud1     := ""
	cAjud2     := ""

	If Empty(cNumOS)
		Return .F.
	EndIf

	cNumOS := AllTrim(cNumOS)

	cQuery := " SELECT DISTINCT "
	cQuery += "        ZX1.ZX1_TIPO AS TIPO, "
	cQuery += "        AA1.AA1_CODTEC AS CODIGO, "
	cQuery += "        AA1.AA1_NOMTEC AS NOME "
	cQuery += " FROM " + RetSqlName("ZX3") + " ZX3 "

	cQuery += " INNER JOIN " + RetSqlName("ZX2") + " ZX2 "
	cQuery += "    ON ZX2.ZX2_COD = ZX3.ZX3_ID_ZX2 "
	cQuery += "   AND ZX2.ZX2_VERSAO = ZX3.ZX3_VERSAO "
	cQuery += "   AND ZX2.ZX2_FILIAL = '" + xFilial("ZX2") + "' "
	cQuery += "   AND ZX2.D_E_L_E_T_ = ' ' "

	cQuery += " INNER JOIN " + RetSqlName("ZX1") + " ZX1 "
	cQuery += "    ON ZX1.ZX1_ID_ZX0 = ZX2.ZX2_EQUIPE "
	cQuery += "   AND ZX1.ZX1_FILIAL = '" + xFilial("ZX1") + "' "
	cQuery += "   AND ZX1.D_E_L_E_T_ = ' ' "

	cQuery += " INNER JOIN " + RetSqlName("AA1") + " AA1 "
	cQuery += "    ON AA1.AA1_CODTEC = ZX1.ZX1_ID_AA1 "
	cQuery += "   AND AA1.AA1_FILIAL = '" + xFilial("AA1") + "' "
	cQuery += "   AND AA1.D_E_L_E_T_ = ' ' "

	cQuery += " WHERE ZX3.ZX3_FILIAL = '" + xFilial("ZX3") + "' "
	cQuery += "   AND ZX3.ZX3_ID_OS = '" + StrTran(cNumOS, "'", "''") + "' "
	cQuery += "   AND ZX3.D_E_L_E_T_ = ' ' "
	cQuery += "   AND ZX1.ZX1_TIPO IN ('M', 'A') "
	cQuery += " ORDER BY ZX1.ZX1_TIPO, AA1.AA1_CODTEC "

	cQuery := ChangeQuery(cQuery)

	TCQuery (cQuery) New Alias (cAlias)

	While !(cAlias)->(Eof())

		cTipo := AllTrim((cAlias)->TIPO)
		cNome := AllTrim((cAlias)->NOME)

		If !Empty(cNome)
			Do Case
			Case cTipo == "M"
				If Empty(cMotorista)
					cMotorista := cNome
				EndIf

			Case cTipo == "A"
				If Empty(cAjud1)
					cAjud1 := cNome
				ElseIf Empty(cAjud2)
					cAjud2 := cNome
				EndIf
			EndCase

			lRet := .T.
		EndIf

		(cAlias)->(DbSkip())
	EndDo

	(cAlias)->(DbCloseArea())

	RestArea(aArea)

Return lRet

Static Function GetMemo(cChave)
	Local cArea  := GetArea()
	Local cMemo  := ""
	Local cQuery := " select YP_TEXTO,YP_SEQ from " + RetSqlName("SYP") + " SYP where SYP.D_E_L_E_T_ = ' ' and YP_CHAVE = '" + cChave + "' "

	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQuery)), "WWX", .T., .F. )

	dbSelectArea("WWX")
	dbGoTop()
	While !WWX->(Eof())
		cMemo += ALLTRIM(WWX->YP_TEXTO)
		WWX->(dbSkip())
	Enddo
	WWX->(dbCloseArea())

	RestArea(cArea)

	cMemo := StrTran(cMemo, '\13\10', ' ')
	cMemo := StrTran(cMemo, '\14\10', ' ')

Return cMemo
