//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"

//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2

//Cores
#Define COR_CINZA   RGB(180, 180, 180)
#Define COR_AZULE    RGB(000, 095, 153)
#Define COR_AZULC    RGB(198, 233, 255)
#Define COR_PRETO   RGB(000, 000, 000)
#Define COR_BRANCO     RGB(255, 255, 255)
#Define COR_BORDA      RGB(190, 205, 212)

//Colunas
#Define COL_GRUPO   0015
#Define COL_DESCR   0095

/*/{Protheus.doc} zTstRel
Exemplos de FWMSPrinter
@author Atilio
@since 27/01/2019
@version 1.0
@type function
/*/

User Function ETNAGE01()
	Local aArea := GetArea()

	//Se a pergunta for confirmada
	If MsgYesNo("Deseja gerar o relatório de grupos de produtos?", "Atenção")
		Processa({|| fMontaRel()}, "Processando...")
	EndIf

	RestArea(aArea)
Return

/*---------------------------------------------------------------------*
 | Func:  fMontaRel                                                    |
 | Desc:  Função que monta o relatório                                 |
 *---------------------------------------------------------------------*/
 
Static Function fMontaRel()
    Local cCaminho    := ""
    Local cArquivo    := ""
    Local cQryAux     := ""
    Local nAtual      := 0
    Local nTotal      := 0
    //Linhas e colunas
    Private nLinAtu   := 000
    Private nTamLin   := 010
    Private nLinFin   := 820
    Private nColIni   := 010
    Private nColFin   := 550
    Private nColMeio  := (nColFin-nColIni)/2
    //Objeto de Impressão
    Private oPrintPvt
    //Variáveis auxiliares
    Private dDataGer  := Date()
    Private cHoraGer  := Time()
    Private nPagAtu   := 1
    Private cNomeUsr  := UsrRetName(RetCodUsr())
    //Fontes
    Private cNomeFont := "Arial"
    Private oFontDet  := TFont():New(cNomeFont, 9, -10, .T., .F., 5, .T., 5, .T., .F.)
    Private oFontDetN := TFont():New(cNomeFont, 9, -10, .T., .T., 5, .T., 5, .T., .F.)
    Private oFontRod  := TFont():New(cNomeFont, 9, -08, .T., .F., 5, .T., 5, .T., .F.)
    Private oFontTit  := TFont():New(cNomeFont, 9, -13, .T., .T., 5, .T., 5, .T., .F.)
    Private oFontTit  := TFont():New("Arial", 0, -16, .T.)
    Private oFontEmpN := TFont():New("Arial", 0, -11, .T.)
    Private oFontDet  := TFont():New("Arial", 0, -9, .F.)
     
    //Definindo o diretório como a temporária do S.O. e o nome do arquivo com a data e hora (sem dois pontos)
    cCaminho  := GetTempPath()
    cArquivo  := "zTstRel_" + dToS(dDataGer) + "_" + StrTran(cHoraGer, ':', '-')
     
    //Criando o objeto do FMSPrinter
    oPrintPvt := FWMSPrinter():New(cArquivo, IMP_PDF, .F., "", .T., , @oPrintPvt, "", , , , .T.)
     
    //Setando os atributos necessários do relatório
    oPrintPvt:SetResolution(72)
    oPrintPvt:SetPortrait()
    oPrintPvt:SetPaperSize(DMPAPER_A4)
    oPrintPvt:SetMargin(60, 60, 60, 60)
     
    //Imprime o cabeçalho
    fImpCab()
    fDadosProgramacao()
    fOrdensServico()
     
     
    //Se ainda tiver linhas sobrando na página, imprime o rodapé final
    If nLinAtu <= nLinFin
        fImpRod()
    EndIf
     
    //Mostrando o relatório
    oPrintPvt:Preview()
Return
 
/*---------------------------------------------------------------------*
 | Func:  fImpCab                                                      |
 | Desc:  Função que imprime o cabeçalho                               |
 *---------------------------------------------------------------------*/
 
Static Function fImpCab()

    Local cTexto  := ""
    Local cLogo   := ""
    Local nLinCab := 035
    Local nColLogo := nColIni
    Local nColEmp  := nColIni + 90

    // Inicia uma nova página
    oPrintPvt:StartPage()

     /* O caminho ficará vazio por enquanto.
     * Exemplo futuro:
     * cLogo := "\system\lgmid01.png"
     */
	cLogo := "\system\lgmid01.png"
	If !Empty(cLogo)
		oPrintPvt:SayBitmap(20, 25, cLogo, 70, 60)
	EndIf

	// Razão social
	cTexto := "ETERNAL - INDUSTRIA, COMERCIO, SERV. E TRAT. DE RESIDUOS DA AMAZONIA LTDA"

	oPrintPvt:SayAlign(nLinCab,nColEmp,cTexto,oFontEmpN,nColFin - nColEmp,nTamLin,COR_PRETO,PAD_LEFT,0)

	// Endereço
	nLinCab += nTamLin

	cTexto := "RUA GUIANA FRANCESA, 1 - DISTRITO INDUSTRIAL II"

	oPrintPvt:SayAlign(nLinCab,nColEmp,cTexto,oFontDet,nColFin - nColEmp,nTamLin,COR_PRETO,PAD_LEFT,0)

	// Telefone, CNPJ e site
	nLinCab += nTamLin

	cTexto := "FONE: 92 3616-4700 / 3616-4706 - " +       "CNPJ: 84.527.274/0001-23 - "        +       "WWW.ETERNALAM.COM.BR"

	oPrintPvt:SayAlign(nLinCab,nColEmp,cTexto,oFontDet,nColFin - nColEmp,nTamLin,COR_PRETO,PAD_LEFT,0)

	// Espaço inferior do cabeçalho
	nLinCab += (nTamLin * 2)

	// Linha separadora
	oPrintPvt:Line(nLinCab,nColIni,nLinCab,nColFin,COR_AZULE)

	// Título do relatório
	nLinCab += nTamLin

	cTexto := "PROGRAMACAO DE COLETAS POR CAMINHAO"

	oPrintPvt:SayAlign(nLinCab,nColIni,cTexto,oFontTit,nColFin - nColIni,nTamLin + 5,COR_AZULE,PAD_CENTER,0)

	// Linha depois do título
	nLinCab += (nTamLin * 2)

	oPrintPvt:Line(nLinCab,nColIni,nLinCab,nColFin,COR_AZULE)

	// Primeira linha disponível para o próximo bloco
	nLinAtu := nLinCab + nTamLin

Return

Static Function fDadosProgramacao()

    Local nAltTit    := 18
    Local nAltLinha  := 28

    Local nLinIni    := nLinAtu
    Local nLinFim    := 0

    Local nCol1      := nColIni
    Local nCol2      := nColIni + 075
    Local nCol3      := nColIni + 290
    Local nCol4      := nColIni + 370
    Local nCol5      := nColFin

    Local oBrushAzul := TBrush():New(, COR_AZULE)

    /*
     * Título do bloco
    */
    nLinFim := nLinIni + nAltTit

    oPrintPvt:FillRect(;
        {nLinIni, nCol1, nLinFim, nCol5},;
        oBrushAzul;
    )

    oPrintPvt:SayAlign(;
        nLinIni + 3,;
        nCol1 + 5,;
        "DADOS DA PROGRAMACAO",;
        oFontDetN,;
        nCol5 - nCol1 - 10,;
        nAltTit - 3,;
        COR_BRANCO,;
        PAD_LEFT,;
        0;
    )

    /*
     * Primeira linha
     * DATA | 15/09/2026 | TURNO | MANHÃ
     */
    nLinIni := nLinFim
    nLinFim := nLinIni + nAltLinha

    fFundoCampo(nLinIni, nLinFim, nCol1, nCol2)
    fFundoCampo(nLinIni, nLinFim, nCol3, nCol4)

    fTextoCelula(nLinIni, nCol1, nCol2, "DATA",       oFontDetN)
    fTextoCelula(nLinIni, nCol2, nCol3, "15/09/2026", oFontDet)
    fTextoCelula(nLinIni, nCol3, nCol4, "TURNO",      oFontDetN)
    fTextoCelula(nLinIni, nCol4, nCol5, "MANHA",      oFontDet)

    fBordaLinha(nLinIni, nLinFim, nCol1, nCol5, ;
        {nCol2, nCol3, nCol4})

    /*
     * Segunda linha
     * CAMINHÃO | JVT-1208 - VW 17.230 | MOTORISTA | JOÃO DA SILVA
     */
    nLinIni := nLinFim
    nLinFim := nLinIni + nAltLinha

    fFundoCampo(nLinIni, nLinFim, nCol1, nCol2)
    fFundoCampo(nLinIni, nLinFim, nCol3, nCol4)

    fTextoCelula(nLinIni, nCol1, nCol2, "CAMINHAO",            oFontDetN)
    fTextoCelula(nLinIni, nCol2, nCol3, "JVT-1208 - VW 17.230", oFontDet)
    fTextoCelula(nLinIni, nCol3, nCol4, "MOTORISTA",           oFontDetN)
    fTextoCelula(nLinIni, nCol4, nCol5, "JOAO DA SILVA",       oFontDet)

    fBordaLinha(nLinIni, nLinFim, nCol1, nCol5, ;
        {nCol2, nCol3, nCol4})

    /*
     * Terceira linha
     * AJUDANTES | CARLOS SOUZA / MARCOS LIMA | TOTAL DE OS | 05
     */
    nLinIni := nLinFim
    nLinFim := nLinIni + nAltLinha

    fFundoCampo(nLinIni, nLinFim, nCol1, nCol2)
    fFundoCampo(nLinIni, nLinFim, nCol3, nCol4)

    fTextoCelula(nLinIni, nCol1, nCol2, "AJUDANTES",                  oFontDetN)
    fTextoCelula(nLinIni, nCol2, nCol3, "CARLOS SOUZA / MARCOS LIMA", oFontDet)
    fTextoCelula(nLinIni, nCol3, nCol4, "TOTAL DE OS",                oFontDetN)
    fTextoCelula(nLinIni, nCol4, nCol5, "05",                         oFontDet)

    fBordaLinha(nLinIni, nLinFim, nCol1, nCol5, ;
        {nCol2, nCol3, nCol4})

    // Atualiza a linha para o próximo bloco
    nLinAtu := nLinFim + 10

    FreeObj(oBrushAzul)

Return

Static Function fOrdensServico()

    Local aDados      := {}
    Local aColunas    := {}
    Local nRegistro   := 0
    Local nLinIni     := nLinAtu
    Local nLinFim     := 0
    Local nAltTitulo  := 18
    Local nAltCab     := 28
    Local nAltLinha   := 34
    Local nLargTotal  := nColFin - nColIni

    Local nCol1       := nColIni
    Local nCol2       := nColIni + Round(nLargTotal * 0.08, 0)
    Local nCol3       := nColIni + Round(nLargTotal * 0.19, 0)
    Local nCol4       := nColIni + Round(nLargTotal * 0.42, 0)
    Local nCol5       := nColIni + Round(nLargTotal * 0.58, 0)
    Local nCol6       := nColIni + Round(nLargTotal * 0.83, 0)
    Local nCol7       := nColFin

    Local oBrushAzul  := TBrush():New(, COR_AZULE)
    Local oBrushClaro := TBrush():New(, COR_AZULC)

    /*
     * Dados fixos para montagem do layout.
     *
     * O caractere "|" indica quebra de linha.
     */
    aAdd(aDados, {;
        "01",;
        "000125",;
        "HC PNEUS S/A",;
        "Rafael|(92) 99999-1001",;
        "Coleta programada de residuos oleosos e|materiais contaminados.",;
        "Av. Autaz Mirim, 8500|Distrito Industrial";
    })

    aAdd(aDados, {;
        "02",;
        "000131",;
        "AMAZON SERVICOS LTDA",;
        "Patricia|(92) 98888-2030",;
        "Retirada de tambores e embalagens|armazenadas no patio.",;
        "Rua Rio Jutai, 210|Vieiralves";
    })

    aAdd(aDados, {;
        "03",;
        "000144",;
        "NORTE LOGISTICA",;
        "Andre|(92) 97777-4545",;
        "Coleta de oleo usado na area de manutencao.",;
        "Av. Torquato Tapajos, 5200|Colonia Terra Nova";
    })

    aAdd(aDados, {;
        "04",;
        "000152",;
        "INDUSTRIA MODELO S/A",;
        "Luciana|(92) 96666-7788",;
        "Atendimento referente a solicitacao de coleta|extraordinaria.",;
        "Av. Buriti, 1000|Distrito Industrial";
    })

    aAdd(aDados, {;
        "05",;
        "000159",;
        "COMERCIAL MANAUS",;
        "Eduardo|(92) 95555-9090",;
        "Recolhimento de materiais conforme|programacao do cliente.",;
        "Rua Para, 450|Nossa Senhora das Gracas";
    })

    aColunas := {nCol2, nCol3, nCol4, nCol5, nCol6}

    /*
     * Faixa: ORDENS DE SERVIÇO
     */
    nLinFim := nLinIni + nAltTitulo

    oPrintPvt:FillRect(;
        {nLinIni, nCol1, nLinFim, nCol7},;
        oBrushAzul;
    )

    oPrintPvt:SayAlign(;
        nLinIni + 3,;
        nCol1 + 5,;
        "ORDENS DE SERVICO",;
        oFontDetN,;
        nCol7 - nCol1 - 10,;
        nAltTitulo - 3,;
        COR_BRANCO,;
        PAD_LEFT,;
        0;
    )

    /*
     * Cabeçalho das colunas
     */
    nLinIni := nLinFim
    nLinFim := nLinIni + nAltCab

    oPrintPvt:FillRect(;
        {nLinIni, nCol1, nLinFim, nCol7},;
        oBrushAzul;
    )

    fTextoTab(nLinIni, nCol1, nCol2, "ORDEM",              oFontDetN, COR_BRANCO, PAD_CENTER)
    fTextoTab(nLinIni, nCol2, nCol3, "ORDEM DE|SERVICO",   oFontDetN, COR_BRANCO, PAD_CENTER)
    fTextoTab(nLinIni, nCol3, nCol4, "NOME DO CLIENTE",    oFontDetN, COR_BRANCO, PAD_CENTER)
    fTextoTab(nLinIni, nCol4, nCol5, "CONTATO",            oFontDetN, COR_BRANCO, PAD_CENTER)
    fTextoTab(nLinIni, nCol5, nCol6, "DESCRICAO DA OCORRENCIA", oFontDetN, COR_BRANCO, PAD_CENTER)
    fTextoTab(nLinIni, nCol6, nCol7, "ENDERECO",           oFontDetN, COR_BRANCO, PAD_CENTER)

    fBordaLinha(;
        nLinIni,;
        nLinFim,;
        nCol1,;
        nCol7,;
        aColunas;
    )

    /*
     * Impressão das ordens de serviço
     */
    For nRegistro := 1 To Len(aDados)

        nLinIni := nLinFim
        nLinFim := nLinIni + nAltLinha

        // Fundo azul-claro nas linhas pares
        If (nRegistro % 2) == 0

            oPrintPvt:FillRect(;
                {nLinIni, nCol1, nLinFim, nCol7},;
                oBrushClaro;
            )

        EndIf

        fTextoTab(nLinIni, nCol1, nCol2, aDados[nRegistro][1], oFontDet, COR_PRETO, PAD_LEFT)
        fTextoTab(nLinIni, nCol2, nCol3, aDados[nRegistro][2], oFontDet, COR_PRETO, PAD_LEFT)
        fTextoTab(nLinIni, nCol3, nCol4, aDados[nRegistro][3], oFontDet, COR_PRETO, PAD_LEFT)
        fTextoTab(nLinIni, nCol4, nCol5, aDados[nRegistro][4], oFontDet, COR_PRETO, PAD_LEFT)
        fTextoTab(nLinIni, nCol5, nCol6, aDados[nRegistro][5], oFontDet, COR_PRETO, PAD_LEFT)
        fTextoTab(nLinIni, nCol6, nCol7, aDados[nRegistro][6], oFontDet, COR_PRETO, PAD_LEFT)

        fBordaLinha(;
            nLinIni,;
            nLinFim,;
            nCol1,;
            nCol7,;
            aColunas;
        )

    Next nRegistro

    /*
     * Observação abaixo da tabela
     */
    nLinAtu := nLinFim + 8

    oPrintPvt:SayAlign(;
        nLinAtu,;
        nCol1 + 5,;
        "Observacao: cada caminhao inicia uma nova pagina. " + ;
        "Os dados apresentados neste modelo sao ilustrativos.",;
        oFontDet,;
        nCol7 - nCol1 - 10,;
        14,;
        COR_CINZA,;
        PAD_LEFT,;
        0;
    )

    nLinAtu += 20

    FreeObj(oBrushAzul)
    FreeObj(oBrushClaro)

Return

Static Function fFundoCampo(nLinIni, nLinFim, nColIniAux, nColFimAux)

    Local oBrushCampo := TBrush():New(, COR_AZULC)

    oPrintPvt:FillRect(;
        {nLinIni, nColIniAux, nLinFim, nColFimAux},;
        oBrushCampo;
    )

    FreeObj(oBrushCampo)

Return

Static Function fTextoCelula(nLinha, nColIniAux, nColFimAux, cTexto, oFonte)

    Local nMargem := 6

    oPrintPvt:SayAlign(;
        nLinha + 7,;
        nColIniAux + nMargem,;
        cTexto,;
        oFonte,;
        nColFimAux - nColIniAux - (nMargem * 2),;
        14,;
        COR_PRETO,;
        PAD_LEFT,;
        0;
    )

Return

Static Function fTextoTab(;
    nLinha,;
    nColIniAux,;
    nColFimAux,;
    cTexto,;
    oFonte,;
    nCor,;
    nAlinhamento)

    Local aLinhas   := StrTokArr(cTexto, "|")
    Local nItem     := 0
    Local nMargem   := 5
    Local nAltTexto := 12
    Local nLargura  := nColFimAux - nColIniAux
    Local nColTexto := nColIniAux + nMargem

    If nAlinhamento == PAD_CENTER
        nColTexto := nColIniAux
        nMargem   := 0
    EndIf

    For nItem := 1 To Len(aLinhas)

        oPrintPvt:SayAlign(;
            nLinha + 5 + ((nItem - 1) * nAltTexto),;
            nColTexto,;
            aLinhas[nItem],;
            oFonte,;
            nLargura - (nMargem * 2),;
            nAltTexto,;
            nCor,;
            nAlinhamento,;
            0;
        )

    Next nItem

Return

Static Function fBordaLinha(nLinIni, nLinFim, nColIniAux, nColFimAux, aColunas)

    Local nPosicao := 0

    // Linhas horizontais
    oPrintPvt:Line(;
        nLinIni, nColIniAux,;
        nLinIni, nColFimAux,;
        COR_BORDA;
    )

    oPrintPvt:Line(;
        nLinFim, nColIniAux,;
        nLinFim, nColFimAux,;
        COR_BORDA;
    )

    // Bordas externas
    oPrintPvt:Line(;
        nLinIni, nColIniAux,;
        nLinFim, nColIniAux,;
        COR_BORDA;
    )

    oPrintPvt:Line(;
        nLinIni, nColFimAux,;
        nLinFim, nColFimAux,;
        COR_BORDA;
    )

    // Divisões internas das colunas
    For nPosicao := 1 To Len(aColunas)

        oPrintPvt:Line(;
            nLinIni, aColunas[nPosicao],;
            nLinFim, aColunas[nPosicao],;
            COR_BORDA;
        )

    Next nPosicao

Return

/*---------------------------------------------------------------------*
 | Func:  fImpRod                                                      |
 | Desc:  Função que imprime o rodapé                                  |
 *---------------------------------------------------------------------*/
 
Static Function fImpRod()
    Local nLinRod   := nLinFin + nTamLin
    Local cTextoEsq := ''
    Local cTextoDir := ''
 
    //Linha Separatória
    oPrintPvt:Line(nLinRod, nColIni, nLinRod, nColFin, COR_CINZA)
    nLinRod += 3
     
    //Dados da Esquerda e Direita
    cTextoEsq := dToC(dDataGer) + "    " + cHoraGer + "    " + FunName() + "    " + cNomeUsr
    cTextoDir := "Página " + cValToChar(nPagAtu)
     
    //Imprimindo os textos
    oPrintPvt:SayAlign(nLinRod, nColIni,    cTextoEsq, oFontRod, 200, 05, COR_CINZA, PAD_LEFT,  0)
    oPrintPvt:SayAlign(nLinRod, nColFin-40, cTextoDir, oFontRod, 040, 05, COR_CINZA, PAD_RIGHT, 0)
     
    //Finalizando a página e somando mais um
    oPrintPvt:EndPage()
    nPagAtu++
Return


