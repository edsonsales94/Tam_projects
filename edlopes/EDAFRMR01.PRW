#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Include "Ap5Mail.ch"
#Include "fileio.ch"
#Include "TbiConn.ch"

//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2

//Variáveis estáticas
Static nTamFundo  := 15
// Static cEmpEmail  := Alltrim(SuperGetMV('MV_X_EMAIL', .F., ""))
// Static cEmpSite   := Alltrim(SuperGetMV('MV_X_HPAGE', .F., ""))

//Static nCorAzul   := RGB(062,179,206)
Static nCorBranco   := RGB(255,255,255)
Static nCorAzul     := RGB(011,021,133)
Static nCorAzulClaro:= RGB(204, 224, 254)
Static nCorVermelho := RGB(231,028,043)

Static nPos0 := 001 //SuperGetMV('MV_XPOSIN0', .F., 001)
Static nPos1 := 110 //SuperGetMV('MV_XPOSIN1', .F., 110)
Static nPos2 := 210 //SuperGetMV('MV_XPOSIN2', .F., 210)
Static nPos3 := 310 //SuperGetMV('MV_XPOSIN3', .F., 310)
Static nPos4 := 410 //SuperGetMV('MV_XPOSIN4', .F., 400)
Static nPos5 := 510 //SuperGetMV('MV_XPOSIN5', .F., 563)
Static nPos6 := 610 //SuperGetMV('MV_XPOSIN5', .F., 563)
Static nPos7 := 710 //SuperGetMV('MV_XPOSIN5', .F., 563)
Static nPos8 := 820 //SuperGetMV('MV_XPOSIN5', .F., 563)


********        RELATÒRIO EDAFRMR01      **********
******** Cotrole de titulos de AFRMM    **********
******** @author Edson Sales 31/01/2025 **********

User Function EDAFRMR01()
	Local aArea := FWGetArea()
	Local aPergs   := {}
	local _cCE 	 := Space(6)
	local _cManif 	 := Space(6)
	local _cProcesso := Space(17)
	local dDataDe  := FirstDate(Date())
	local dDataAte := LastDate(Date())
	local _cStatus := 'XX'

	// Private cLogoEmp := Alltrim(SuperGetMV("ZZ_LOGO",,FisxLogo("1") ))
	Private cLogoEmp := GetSrvProfString('Startpath','') + 'lgrl010101.bmp'
	Private nLinAux0 := 0
	Private nLinAux1 := 0
	Private nLinAux2 := 0
	Private nLinAux3 := 0
	Private nLinCab  := 0
	Private oBrushAzClaro     := TBRUSH():New(,nCorAzulClaro)

	//Adicionando os parametros do ParamBox
	aAdd(aPergs, {1, "Data Inicial",  dDataDe,     "", ".T.", "   ", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Data Final",    dDataAte,    "", ".T.", "   ", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "CE Mercante",   _cCE,        "", ".T.", "   ", ".T.", 80, .F.})
	aAdd(aPergs, {1, "Manifesto",   _cManif,        "", ".T.", "   ", ".T.", 80, .F.})
	aAdd(aPergs, {1, "Processo",      _cProcesso,  "", ".T.", "   ", ".T.", 80,  .F.})
	aAdd(aPergs, {2, "Considerar Somente",  _cStatus, {'AB=ABERTO','EP=EM PROCESSO','IN=INDEFERIDO','PG=PAGO','PP=PAGO PARCIAL','DF=DEFERIDO','XX=TODOS'},80, ".T.", .F.})

	If ParamBox(aPergs, "Informe os parametros")
		fMontaRel(.T.)
	EndIf
	FWRestArea(aArea)

Return

Static Function fMontaRel(lCallMe)
	// Local   nX         := 0
// Local   nVal1      := 0
	// Local   nVal2      := 0
	// Local   nVolTot    := 0
	// Local   nValAc1    := 0
	// Local   nValAc2    := 0
	// Local   nValAc3    := 0
	// Local   nValAc4    := 0
	// Local   aExtenso   := {}
	// Local   cExtenso   := ""
	Local cQuery := ''
	Local nTotal := 0
	Local nAtual := 0
	Private cAliasQry := ''

	Private cHoraEx    := Time()
	Private nPagAtu    := 1
	Private cNomeRel   := "EDAFRMR01"
	Private cQryIte    := ""

	//Linhas e colunas
	Private nLinAtu    := 0
	Private nLinFin    := 600
	Private nColIni    := 010
	Private nColFin    := 550
	Private nColMeio   := (nColFin-nColIni)/2
	Private oPrintPvt
	Private oBrushAzul := TBRUSH():New(,nCorAzul)

	//- Declarando as fontes
	Private cNomeFont  := "Arial"
	Private oFontDet   := TFont():New("Arial", 9, -7,  .T., .F., 5, .T., 5, .T., .F.)
	Private oFontDetN  := TFont():New("Arial", 9, -7,  .T., .T., 5, .T., 5, .T., .F.)
	Private oFontRod   := TFont():New("Arial", 9, -6,  .T., .F., 5, .T., 5, .T., .F.)
	Private oFontTit   := TFont():New("Arial", 14, 14, .T., .T., 5, .T., 5, .T., .F.)
	Private oFont09Lin   := TFont():New("Arial", 9, -7,  .T., .F., 5, .T., 5, .T., .F.)
	Private oFontCabN  := TFont():New("Arial", 12, -7,  .T., .T., 5, .T., 5, .T., .F.)
	Private oFontObs   := TFont():New("Arial", 10, -10,  .T., .F., 5, .T., 5, .T., .F.)
	Private oFontObsN  := TFont():New("Arial", 10, -10,  .T., .T., 5, .T., 5, .T., .F.)
	Private oFont14    := TFont():New("Arial", 14, 14,  .T., .F., 5, .T., 5, .T., .F.)

	Private oFont10lin := TFont():New("Arial", 10, 10,  .T., .F., 5, .T., 5, .T., .F.)
	Private oFont10N   := TFont():New("Arial", 10, 10,  .T., .T., 5, .T., 5, .T., .F.)
	Private oFont11N   := TFont():New("Arial", 11, 11,  .T., .T., 5, .T., 5, .T., .F.)
	Private oFont12N   := TFont():New("Arial", 12, 12,  .T., .T., 5, .T., 5, .T., .F.)
	Private oFont14N   := TFont():New("Arial", 14, 14,  .T., .T., 5, .T., 5, .T., .F.)
	Private oFont16N   := TFont():New("Arial", 16, 16,  .T., .T., 5, .T., 5, .T., .F.)
	Private oFont18N   := TFont():New("Arial", 18, 18,  .T., .T., 5, .T., 5, .T., .F.)
	Private oFont24N   := TFont():New("Arial", 24, 24,  .T., .T., 5, .T., 5, .T., .F.)

	//- Cadastro de Produtos
	//DbSelectArea('SB1')
	//DbSetOrder(1) //B1_FILIAL+B1_COD

	//- Caso seja chamado pelo menu posiciona na DT6
	If !lCallMe
		return
	Endif
	//- Se for automático por e-Mail
	lAuto := .F.
	If lAuto
		Erase(GetTempPath()+cNomeRel+".pdf")
		oPrintPvt := FWMsPrinter():New(cNomeRel, IMP_PDF, .F., /*cStartPath*/, .T., , , , , .F., , .F.)
		//Senão, gera normalmente
	Else
		oPrintPvt := FWMSPrinter():New(cNomeRel, IMP_PDF, .F., /*cStartPath*/, .T., , @oPrintPvt, , , , , .T.)
	EndIf

	//Setando os atributos necessários
	oPrintPvt:cPathPDF := GetTempPath()
	oPrintPvt:SetResolution(72)
	oPrintPvt:SetLandScape()
	oPrintPvt:SetPaperSize(9)
	oPrintPvt:SetMargin(50, 60, 60, 60)

	cAliasQry := GetNextAlias()
	//Monta a consulta
	cQuery := " SELECT E1_NUM,E1_FILIAL,E1_CLIENTE,E1_LOJA,E1_NOMCLI,"
	cQuery += " E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_EMISSAO,E1_BAIXA,E1_VALOR,E1_SALDO,"
	cQuery += " E1_XCEMERC,E1_XMANIFE,E1_XNUMPRO,E1_XDTPRO,E1_XSTATUS,E1_XOBS,"
	cQuery += " F2_DOC,F2_VALMERC,F2_VALBRUT,DT6_VALTOT,DT6_VALIMP,DT6_VALTOT,DT6_VALIMP "
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


	cQuery := ChangeQuery(cQuery)
	PLSQuery(cQuery, cAliasQry)

	//Definindo o tamanho da régua
	DbSelectArea(cAliasQry)
	Count to nTotal
	ProcRegua(nTotal)
	(cAliasQry)->(DbGoTop())

	//- Imprime o cabeçalho
	nPagAtu := 1
	fImpCab()

	//Enquanto houver registros, adiciona na temporária
	While ! (cAliasQry)->(EoF())
		nAtual++
		IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')

		ImpLin()
		// Se por acaso atingiu o limite da página, finaliza, e começa uma nova página
		If nLinAtu >= nLinFin
			nPagAtu++
			fImpCab()
			ImpLin()
		EndIf
		(cAliasQry)->(DbSkip())
	Enddo
	(cAliasQry)->(DbCloseArea())


	// oPrintPvt:Preview()
	oPrintPvt:EndPage()
	oPrintPvt:Print()

	//Se for automático, gera o pdf e manda por email
//   If lAuto
//      oPrintPvt:Print()
// 	 CpyT2S( GetTempPath()+cNomeRel+".pdf", "\spool", .F. )
// 	 fEnvEmail(cEmails, "Invoice", "Segue a(s) em anexo a invoice", "\spool\"+cNomeRel+".pdf")
//   Else
// 	 oPrintPvt:Preview()
// 	 CpyT2S( GetTempPath()+cNomeRel+".pdf", "\spool", .F. )
//   EndIf
Return()

/*//*/
Static Function fImpCab()
	Local cTitulo:= 'CONTROLE DE CONHECIMENTO DE TRANSPORTE'
	Local cTitulo2:= 'RESUMOS PROTOCOLOS RESSACIMENTOS'

	nLinAux0 := 0
	nLinAux1 := 0
	nLinAux2 := 0
	nLinAux3 := 0
	nLinCab  := 0
	nLinAtu	 := 0
	//Box Dados da Empresa
	// nLinCab += nTamFundo - 5
	//Iniciando Página
	oPrintPvt:StartPage()
	nLinCab += 35

	*** Cabeçalho Principal ***

	oPrintPvt:Box(nLinCab,nPos0,nLinCab+73,nPos8)

	// oPrintPvt:Line( nLinCab, nPos6-10, nLinCab+65, nPos6-10) // LINHA VETICAL
	// oPrintPvt:Line( nLinCab, nPos6+60, nLinCab+65, nPos6+60) // LINHA VETICAL


	oPrintPvt:SayAlign(nLinCab+08,  nPos6, 'Emissão: ' +'31/01/2025'     , oFont12N, 160, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab+08,  nPos7+30, 'Pág.: 149' , oFont12N, 160, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab+25,  nPos6, 'Hora: ' +'10:30'     , oFont12N, 160, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab+25,  nPos7+30, 'CTT460' , oFont12N, 160, 05, , PAD_LEFT, )
	// oPrintPvt:Line(nLinCab+20,nPos6-10,nLinCab+20,nPos8)     // LINHA HORISONTAIS

	nLinCab += 05
	oPrintPvt:SayBitmap(nLinCab, nPos0+10, cLogoEmp, 054, 040)
	oPrintPvt:SayAlign(nLinCab, nPos2, cTitulo, oFont16N, 350, 05, nCorAzul, PAD_CENTER,  )
	nLinCab += 16
	oPrintPvt:SayAlign(nLinCab, nPos2, cTitulo2, oFontTit, 350, 05, nCorAzul, PAD_CENTER,  )

	nLinCab += 28
	*** Cabecalho dos itens ***
	// oPrintPvt:Box(nLinCab,nPos0,nLinCab+24,nPos8)
	oPrintPvt:Line( nLinCab, nPos0, nLinCab, nPos8) 			// LINHA HORIZONTAL PROTOCOLO
	oPrintPvt:SayAlign(nLinCab,  nPos0,    'PROTOCOLO'    	, oFont12N, 210, 05, , PAD_CENTER, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos2,    'VALOR'    		, oFont12N, 160, 05, , PAD_CENTER,   	)
	oPrintPvt:SayAlign(nLinCab,  nPos3+75, 'BASE'    		, oFont12N, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos4+40, 'VALOR'    		, oFont12N, 150, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos5+10, 'SITUAÇÃO'    	, oFont12N, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos6,    'RECEBIMENTO'    , oFont12N, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos7,    'OBSERVAÇÕES'    , oFont12N, 160, 05, , PAD_LEFT, 	)
	nLinCab += 12

	oPrintPvt:SayAlign(nLinCab,  nPos0+5,   'Numero'	, oFont12N, 210, 05, , PAD_LEFT , 	)
	oPrintPvt:SayAlign(nLinCab,  nPos0+100, 'Data'		, oFont12N, 210, 05, , PAD_LEFT,	)
	oPrintPvt:SayAlign(nLinCab,  nPos0+155, 'CTAC'		, oFont12N, 210, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos2, 	'Frete'		, oFont12N, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos2+60,  'Icms'		, oFont12N, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos2+115, 'Total'		, oFont12N, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos3+75,  'Afrmm'		, oFont12N, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos4+40,  'Afrmm'		, oFont12N, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos5+10,  'No DMM'	, oFont12N, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos6, 	'Data'		, oFont12N, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos6+50,  'Valor'		, oFont12N, 160, 05, , PAD_LEFT, 	)

	oPrintPvt:Line( nLinCab, nPos0, nLinCab, nPos3+70) 			// LINHA HORIZONTAL PROTOCOLO
	oPrintPvt:Line( nLinCab, nPos0+95, nLinCab+12, nPos0+95) 	// LINHA VERTICAL DATA
	oPrintPvt:Line( nLinCab, nPos0+150, nLinCab+12, nPos0+150) 	// LINHA VERTICAL CTAC

	oPrintPvt:Line( nLinCab-12, nPos2-5, nLinCab+12, nPos2-5) 	// LINHA VETICAL  FRETE
	oPrintPvt:Line( nLinCab, nPos2+55, nLinCab+12, nPos2+55) 	// LINHA VERTICAL ICMS
	oPrintPvt:Line( nLinCab, nPos2+110, nLinCab+12, nPos2+110) 	// LINHA VERTICAL TOTAL

	oPrintPvt:Line( nLinCab-12, nPos3+70, nLinCab+12, nPos3+70) // LINHA VERTICAL BASE AFRMM
	oPrintPvt:Line( nLinCab-12, nPos4+35, nLinCab+12, nPos4+35) // LINHA VERTICAL VALOR AFRMM

	oPrintPvt:Line( nLinCab-12, nPos6-5, nLinCab+12, nPos6-5) 	// LINHA VERTICAL SITUACAO

	oPrintPvt:Line( nLinCab, nPos6-5, nLinCab, nPos7-5)   		// LINHA HORIZONTAL RECEBIMENTO
	oPrintPvt:Line( nLinCab-12, nPos5+5, nLinCab+12, nPos5+5) 	// LINHA  VERTICAL  DATA
	oPrintPvt:Line( nLinCab, nPos6+45, nLinCab+12, nPos6+45) 	// LINHA VERTICAL VALOR

	oPrintPvt:Line( nLinCab-12, nPos7-5, nLinCab+12, nPos7-5) 	// LINHA VERTICAL OBSERVAÇÃO

Return

Static Function ImpLin()

	*** carregamento origem / Descarregamento destino ***

	// dDataBaixa  := Posicione("SE5",10,(cAliasQry)->(E1_NUM),"E5_DATA")
	// // nValorBaixa := Alltrim(Transform(Posicione("SE5",10,(cAliasQry)->(E1_NUM),"E5_VALOR"), "@E 999,999,999.99"))
	nValorBaixa := (cAliasQry)->E1_VALOR-(cAliasQry)->E1_SALDO

	cStatus:=   IIF((cAliasQry)->E1_XSTATUS=='AB','Aberto'  	,;
		IIF((cAliasQry)->E1_XSTATUS=='EP','Em processo' 		,;
		IIF((cAliasQry)->E1_XSTATUS=='IN','Indeferido'  		,;
		IIF((cAliasQry)->E1_XSTATUS=='PG','Pago'        		,;
		IIF((cAliasQry)->E1_XSTATUS=='PP','Pagamento parcial', ;
		IIF((cAliasQry)->E1_XSTATUS=='DF','Deferido','';
		))))))

		cDataProc := STRZERO(Day((cAliasQry)->E1_XDTPRO),2)+"/"+STRZERO(Month((cAliasQry)->E1_XDTPRO),2)+"/"+STRZERO(Year((cAliasQry)->E1_XDTPRO),4)
		cDataBaix := STRZERO(Day(E1_BAIXA),2)+"/"+STRZERO(Month(E1_BAIXA),2)+"/"+STRZERO(Year(E1_BAIXA),4)

	nLinCab += 12
	oPrintPvt:Box(nLinCab,nPos0,nLinCab+24,nPos8)

	oPrintPvt:SayAlign(nLinCab,  nPos0+5, 	(cAliasQry)->E1_XNUMPRO 	, oFont10lin, 210, 05, , PAD_LEFT , 	)
	oPrintPvt:SayAlign(nLinCab,  nPos0+100, cDataProc, oFont10lin, 210, 05, , PAD_LEFT,	)
	oPrintPvt:SayAlign(nLinCab,  nPos0+155, (cAliasQry)->F2_DOC 		, oFont10lin, 210, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos2, 	Alltrim(Transform((cAliasQry)->DT6_VALTOT, "@E 999,999,999.99")) 	, oFont10lin, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos2+60, 	Alltrim(Transform((cAliasQry)->DT6_VALIMP , "@E 999,999,999.99")) 	, oFont10lin, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos2+115, Alltrim(Transform((cAliasQry)->DT6_VALTOT-(cAliasQry)->DT6_VALIMP , "@E 999,999,999.99")), oFont10lin, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos3+75, 	Alltrim(Transform((cAliasQry)->DT6_VALTOT, "@E 999,999,999.99")) 	, oFont10lin, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos4+40, 	Alltrim(Transform((cAliasQry)->E1_VALOR , "@E 999,999,999.99"))		, oFont10lin, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos5+10, 	cStatus					 	, oFont10lin, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos6, 	cDataBaix 				, oFont10lin, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos6+50,	Alltrim(Transform(nValorBaixa , "@E 999,999,999.99"))				, oFont10lin, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos7, 	(cAliasQry)->E1_XOBS		, oFont10lin, 160, 05, , PAD_LEFT, 	)

	oPrintPvt:Line( nLinCab+12, nPos0, nLinCab+12, nPos8) 		// LINHA HORIZONTAL

	oPrintPvt:Line( nLinCab, nPos0, nLinCab, nPos3+70) 			// LINHA HORIZONTAL PROTOCOLO
	oPrintPvt:Line( nLinCab, nPos0+95, nLinCab+12, nPos0+95) 	// LINHA VERTICAL DATA
	oPrintPvt:Line( nLinCab, nPos0+150, nLinCab+12, nPos0+150) 	// LINHA VERTICAL CTAC

	oPrintPvt:Line( nLinCab, nPos2-5, nLinCab+12, nPos2-5) 		// LINHA VETICAL  FRETE
	oPrintPvt:Line( nLinCab, nPos2+55, nLinCab+12, nPos2+55) 	// LINHA VERTICAL ICMS
	oPrintPvt:Line( nLinCab, nPos2+110, nLinCab+12, nPos2+110) 	// LINHA VERTICAL TOTAL

	oPrintPvt:Line( nLinCab, nPos3+70, nLinCab+12, nPos3+70) 	// LINHA VERTICAL BASE AFRMM
	oPrintPvt:Line( nLinCab, nPos4+35, nLinCab+12, nPos4+35) 	// LINHA VERTICAL VALOR AFRMM

	oPrintPvt:Line( nLinCab, nPos6-5, nLinCab+12, nPos6-5) 		// LINHA VERTICAL SITUACAO
	oPrintPvt:Line( nLinCab, nPos6-5, nLinCab, nPos7-5)   		// LINHA HORIZONTAL RECEBIMENTO
	oPrintPvt:Line( nLinCab, nPos5+5, nLinCab+12, nPos5+5) 		// LINHA  VERTICAL  DATA
	oPrintPvt:Line( nLinCab, nPos6+45, nLinCab+12, nPos6+45)	// LINHA VERTICAL VALOR
	oPrintPvt:Line( nLinCab, nPos7-5, nLinCab+12, nPos7-5) 		// LINHA VERTICAL OBSERVAÇÃO

	// *** Linha do saldo
	nLinCab += 12
	oPrintPvt:SayAlign(nLinCab,  nPos5+10, 	'Saldo '    	, oFont11N, 160, 05, , PAD_LEFT, 	)
	oPrintPvt:SayAlign(nLinCab,  nPos6+50, Alltrim(Transform((cAliasQry)->E1_SALDO, "@E 999,999,999.99")), oFont11N, 160, 05, , PAD_LEFT, 	)

	oPrintPvt:Line( nLinCab, nPos6-5, nLinCab+12, nPos6-5) 		// LINHA VERTICAL SITUACAO
	oPrintPvt:Line( nLinCab, nPos5+5, nLinCab+12, nPos5+5) 		// LINHA  VERTICAL  DATA
	oPrintPvt:Line( nLinCab, nPos6+45, nLinCab+12, nPos6+45)	// LINHA VERTICAL VALOR
	oPrintPvt:Line( nLinCab, nPos7-5, nLinCab+12, nPos7-5) 		// LINHA VERTICAL OBSERVAÇÃO

	nLinAtu := nLinCab

Return
