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
#Define COR_PRETO   RGB(000, 000, 000)

//Colunas
#Define COL_GRUPO   0015
#Define COL_DESCR   0095

/*/{Protheus.doc} PMZRSE01
Exemplos de FWMSPrinter
@author Edson Sales 
@since 10/03/2026
@version 1.0
@ Relatorio Serasa pessa Fisica.
/*/

User Function PMZRSE01()
	Local aArea := GetArea()
	// local lAMb      := RpcSetEnv('01','01AM009')
	Local cJson := SZ3->Z3_JSON
	Private oJsonSer := JsonObject():New()
	Private cTp_Cli   := iif(SZ3->Z3_TIPO=='1' .OR. SZ3->Z3_TIPO=='3','PF',;
		iif(SZ3->Z3_TIPO=='2' .OR. SZ3->Z3_TIPO=='4','PJ',''))


	If oJsonSer:FromJson(cJson) == NIL
		ConOut("Nome: " )
	Else
		ConOut("Erro ao converter JSON")
	EndIf

	If SZ3->Z3_TIPO=='1' .OR. SZ3->Z3_TIPO=='2' // BASICO
		Processa({|| ImpRBas()}, "Processando...")
	elseIf SZ3->Z3_TIPO=='3' .OR. SZ3->Z3_TIPO=='4' // COMPLETO
		Processa({|| ImpRCom()}, "Processando...")
	else
		Alert('Tipo de relatorio não encontrado')
	EndIf

	RestArea(aArea)
Return
/*---------------------------------------------------------------------*
 | Func:  ImpRBas                                                     |
 | Desc:  Função que monta o relatório Consulta Completa               |
 *---------------------------------------------------------------------*/
 
Static Function ImpRBas()
    Local cCaminho    := ""
    Local cArquivo    := ""
    // Local cQryAux     := ""
    // Local nAtual      := 0
    // Local nTotal      := 0
    Local nx          := 0
    Local nY          := 0
    Local nz          := 0
    Local nP          := 0
    Private cTp_Rel   := 'BASICO' // ou 'BASICO'
    // Private cTp_Cli   := 'PJ' // PF ou PJ
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
    Private oFontSay  := TFont():New(cNomeFont, 9, -08, .T., .F., 5, .T., 5, .T., .F.)
    Private oFontTit  := TFont():New(cNomeFont, 9, -13, .T., .T., 5, .T., 5, .T., .F.)
     
    //Definindo o diretório como a temporária do S.O. e o nome do arquivo com a data e hora (sem dois pontos)
    cCaminho  := 'C:\Temp\'
    cArquivo  := "PMZRSE01_" + dToS(dDataGer) + "_" + StrTran(cHoraGer, ':', '-')
     
    if !ExistDir(cCaminho)
        MakeDir(cCaminho)
    endif

    //Criando o objeto do FMSPrinter
    oPrintPvt := FWMSPrinter():New(cArquivo, IMP_PDF, .F.,cCaminho, .T., , @oPrintPvt, "", , , , .T.)
     
    //Setando os atributos necessários do relatório
    oPrintPvt:SetResolution(72)
    oPrintPvt:SetPortrait()
    oPrintPvt:SetPaperSize(DMPAPER_A4)
    oPrintPvt:SetMargin(60, 60, 60, 60)
       
    //Imprime o cabeçalho
    fImpCab()
    ***
    /* Inicio bloco PEFIN, REFIN e PROTESTO */   

    for nY := 1 to 3  // 1 - PEFIN, 2 - REFIN, 3 - PROTESTO
        nLinAtu += nTamLin
        cTitBox := 'PEFIN'
        cTitCol1 := 'Data Ocorrencia'
        cTitCol2 := 'Natureza'
        cTitCol3 := 'Contrato'
        cTitCol4 := 'Credor'
        cTitCol5 := 'Valor'
        cTitCol6 := 'Principal'

        If nLinAtu + nTamLin > nLinFin
            fImpRod()
            fImpCab()
        EndIf

        if nY == 1 // PEFIN
            aDados := {}
            oDados := oJsonSer['optionalFeatures']['negativeData']['pefin']['pefinResponse']
            if type("oDados") == 'A'            
                for nP := 1 to Len(oDados)
                    aAdd(aDados,{oDados[nP]['occurrenceDate'],oDados[nP]['legalNature'],oDados[nP]['contractId'],oDados[nP]['creditorName'],oDados[nP]['amount'],iif(oDados[nP]['principal'],'SIM','NAO')})
                next nP
            endif
            oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, 'DADOS NEGATIVOS - '+cTitBox, oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)
            nLinAtu += (nTamLin * 2)
            oPrintPvt:SayAlign(nLinAtu, nColIni,'Resumo PEFIN', oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
        elseif nY == 2 // REFIN
            if cTP_Cli == 'PF'
                cTitBox := 'REFIN'

                aDados := {}
                oDados := oJsonSer['optionalFeatures']['negativeData']['refin']['refinResponse']
                if type("oDados") == 'A'   
                    for nP := 1 to Len(oDados)
                        aAdd(aDados,{oDados[nP]['occurrenceDate'],oDados[nP]['legalNature'],oDados[nP]['contractId'],oDados[nP]['creditorName'],oDados[nP]['amount'],iif(oDados[nP]['principal'],'SIM','NAO')})
                    next nP
                endif
                oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, 'DADOS POSITIVOS - '+cTitBox, oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)
            else
                nLinAtu += (nTamLin * 2)
                oPrintPvt:SayAlign(nLinAtu, nColIni,'Resumo REFIN', oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
            endif
        else // PROTESTO
            if cTP_Cli == 'PF'
                cTitBox := 'PROTESTO'

                aDados := {}
                oDados := oJsonSer['optionalFeatures']['negativeData']['notary']['notaryResponse']
                if type("oDados") == 'A'
                    for nP := 1 to Len(oDados)
                        aAdd(aDados,{oDados[nP]['occurrenceDate'],oDados[nP]['officeNumber'],oDados[nP]['city'],oDados[nP]['federalUnit'],oDados[nP]['amount'],iif(oDados[nP]['dispute']['disputeIndicativeFlag'],'SIM','NAO')})
                    next nP
                endif

                oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, cTitBox, oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)
                cTitCol2 := 'Cartorio'
                cTitCol3 := 'Cidade'
                cTitCol4 := 'UF'
                cTitCol6 := 'Contestacao'
            else
                oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, 'RESUMO DE DIVIDAS VENCIDAS - (CONVEM)', oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)
            endif
        endif

        nLinAtu += (nTamLin * 2)
        oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
        oPrintPvt:Line(nLinAtu, 90,  nLinAtu + 20, 90, COR_PRETO)
        oPrintPvt:Line(nLinAtu, 160, nLinAtu + 20, 160, COR_PRETO)
        oPrintPvt:Line(nLinAtu, 240, nLinAtu + 20, 240, COR_PRETO)
        
        if cTP_Cli =='PF' // PESSOA FISICA
            oPrintPvt:Line(nLinAtu, 410, nLinAtu + 20, 410, COR_PRETO)
            oPrintPvt:Line(nLinAtu, 500, nLinAtu + 20, 500, COR_PRETO)
        Else
            oPrintPvt:Line(nLinAtu, 460, nLinAtu + 20, 460, COR_PRETO)
        endif

        oPrintPvt:SayAlign(nLinAtu, nColIni, cTitCol1  , oFontTit, 80, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+90,  cTitCol2  , oFontTit, 50, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+160, cTitCol3  , oFontTit, 60, 20, COR_PRETO, PAD_CENTER, 0)

        if cTP_Cli =='PF' // PESSOA FISICA
            oPrintPvt:SayAlign(nLinAtu, nColIni+240, cTitCol4  , oFontTit, 125, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+410, cTitCol5  , oFontTit, 50, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+495, cTitCol6  , oFontTit, 50, 20, COR_PRETO, PAD_LEFT, 0)
        else
            oPrintPvt:SayAlign(nLinAtu, nColIni+240, cTitCol4  , oFontTit, 180, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+460, cTitCol5  , oFontTit, 40, 20, COR_PRETO, PAD_CENTER, 0)
        endif

        nCont     := 0
        nVlrTotal := 0
        cPrimeiraCorr := ""
        cultimaCorr   := ""

        for nx := 1 to len(aDados)
            
            nLinAtu += (nTamLin * 2)

            If nLinAtu + nTamLin > nLinFin
                
                fImpRod()
                fImpCab()

                oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
                oPrintPvt:Line(nLinAtu, 90,  nLinAtu + 20, 90, COR_PRETO)
                oPrintPvt:Line(nLinAtu, 160, nLinAtu + 20, 160, COR_PRETO)
                oPrintPvt:Line(nLinAtu, 240, nLinAtu + 20, 240, COR_PRETO)

                if cTP_Cli =='PF'
                    oPrintPvt:Line(nLinAtu, 410, nLinAtu + 20, 410, COR_PRETO)
                    oPrintPvt:Line(nLinAtu, 500, nLinAtu + 20, 500, COR_PRETO)
                Else
                    oPrintPvt:Line(nLinAtu, 460, nLinAtu + 20, 460, COR_PRETO)
                endif

                oPrintPvt:SayAlign(nLinAtu, nColIni, cTitCol1  , oFontTit, 80, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+90,  cTitCol2  , oFontTit, 50, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+160, cTitCol3  , oFontTit, 60, 20, COR_PRETO, PAD_CENTER, 0)
                
                if cTP_Cli =='PF' // PESSOA FISICA
                    oPrintPvt:SayAlign(nLinAtu, nColIni+240, cTitCol4  , oFontTit, 125, 20, COR_PRETO, PAD_CENTER, 0)
                    oPrintPvt:SayAlign(nLinAtu, nColIni+410, cTitCol5  , oFontTit, 50, 20, COR_PRETO, PAD_CENTER, 0)
                    oPrintPvt:SayAlign(nLinAtu, nColIni+495, cTitCol6  , oFontTit, 50, 20, COR_PRETO, PAD_LEFT, 0)
                else
                    oPrintPvt:SayAlign(nLinAtu, nColIni+240, cTitCol4  , oFontTit, 180, 20, COR_PRETO, PAD_CENTER, 0)
                    oPrintPvt:SayAlign(nLinAtu, nColIni+460, cTitCol5  , oFontTit, 40, 20, COR_PRETO, PAD_CENTER, 0)
                endif
                nLinAtu += (nTamLin * 2)

            EndIf

            nCont++
            oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
            oPrintPvt:Line(nLinAtu, 90, nLinAtu + 20, 90, COR_PRETO)
            oPrintPvt:Line(nLinAtu, 160, nLinAtu + 20, 160, COR_PRETO)
            oPrintPvt:Line(nLinAtu, 240, nLinAtu + 20, 240, COR_PRETO)

            if cTP_Cli =='PF' // PESSOA FISICA
                oPrintPvt:Line(nLinAtu, 410, nLinAtu + 20, 410, COR_PRETO)
                oPrintPvt:Line(nLinAtu, 500, nLinAtu + 20, 500, COR_PRETO)
            Else  // PESSOA JURIDICA
                oPrintPvt:Line(nLinAtu, 460, nLinAtu + 20, 460, COR_PRETO)
            endif

            oPrintPvt:SayAlign(nLinAtu, nColIni,aDados[nx,1], oFontDet, 80, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+90, aDados[nx,2], oFontDet, 50, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+160,aDados[nx,3], oFontDet, 60, 20, COR_PRETO, PAD_CENTER, 0)
            
            if cTP_Cli =='PF' // PESSOA FISICA
                oPrintPvt:SayAlign(nLinAtu, nColIni+240,aDados[nx,4], oFontDet, 125, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+410,cValToChar(aDados[nx,5]), oFontDet, 70, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+500,aDados[nx,6], oFontDet, 30, 20, COR_PRETO, PAD_CENTER, 0)
            Else // PESSOA JURIDICA
                oPrintPvt:SayAlign(nLinAtu, nColIni+240,aDados[nx,4], oFontDet, 180, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+460,cValToChar(aDados[nx,5]), oFontDet, 70, 20, COR_PRETO, PAD_CENTER, 0)
            EndIf

            nValor := aDados[nx,5]
            nVlrTotal += nValor

            If Empty(cPrimeiraCorr)
                cPrimeiraCorr := DtoC(StoD(strTRan(aDados[nx][1],'-','')))
            EndIf

            cUltimaCorr := DtoC(StoD(strTRan(aDados[nx][1],'-','')))

        If nLinAtu + nTamLin > nLinFin
            fImpRod()
            fImpCab()
        EndIf

        next nx

        // Resumo 
        // relatorio basico PF
        if cTP_Cli == 'PF' //
            If nLinAtu + (nTamLin*4) > nLinFin
                fImpRod()
                fImpCab()
            EndIf
            
            nLinAtu += (nTamLin * 2)
            oPrintPvt:SayAlign(nLinAtu, nColIni,'Resumo: '+cTitBox, oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
            nLinAtu += nTamLin
            oPrintPvt:SayAlign(nLinAtu, nColIni,'Quantidade: '+cvaltochar(nCont), oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
            nLinAtu += nTamLin
            oPrintPvt:SayAlign(nLinAtu, nColIni,'Saldo Total: '+allTrim(Transform(nVlrTotal,"@E 999,999,999,999.99")), oFontDetN, 180, 20, COR_PRETO, PAD_LEFT, 0)
        else

            // relatorio basico PJ
            If nLinAtu + (nTamLin*6) > nLinFin
                fImpRod()
                fImpCab()
            EndIf

            nLinAtu += (nTamLin * 2)
            oPrintPvt:SayAlign(nLinAtu, nColIni,'Primeira Ocorrencia: '+cPrimeiraCorr, oFontDetN, 250, 20, COR_PRETO, PAD_LEFT, 0)
            nLinAtu += nTamLin
            oPrintPvt:SayAlign(nLinAtu, nColIni,'Ultima Ocorrencia: '+cUltimaCorr, oFontDetN, 250, 20, COR_PRETO, PAD_LEFT, 0)
            nLinAtu += nTamLin
            oPrintPvt:SayAlign(nLinAtu, nColIni,'Quantidade: '+cvaltochar(nCont), oFontDetN, 250, 20, COR_PRETO, PAD_LEFT, 0)
            nLinAtu += nTamLin
            oPrintPvt:SayAlign(nLinAtu, nColIni,'Saldo Total: '+allTrim(Transform(nVlrTotal,"@E 999,999,999,999.99")), oFontDetN, 250, 20, COR_PRETO, PAD_LEFT, 0)
        endif
    next ny

    /* Fim bloco PEFIN, REFIN e PROTESTO */

   /* DOCUMENTO ROUBADOS */
    nLinAtu += (nTamLin * 2)
    If nLinAtu + (nTamLin*5) > nLinFin
        fImpRod()
        fImpCab()
    EndIf
    oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, 'DOCUMENTOS ROUBADOS', oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)
    nLinAtu += nTamLin
    oPrintPvt:SayAlign(nLinAtu, nColIni, 'Nenhum documento roubado encontrado'   , oFontDet, 300, 20, COR_PRETO, PAD_LEFT, 0)
    nLinAtu += (nTamLin * 2)
    oPrintPvt:SayAlign(nLinAtu, nColIni, 'Resumo de documentos Roubados', oFontDetN, 240, 20, COR_PRETO, PAD_LEFT, 0)
    nLinAtu += nTamLin
    oPrintPvt:SayAlign(nLinAtu, nColIni, 'Quantidade Total: 0'   , oFontDet, 300, 20, COR_PRETO, PAD_LEFT, 0)
    nLinAtu += (nTamLin * 2)
   /*FIM DOCUMENTO ROUBADOS */


    /* CONSULTAS REALIZADAS */

    if cTP_Cli == 'PF' // PESSOA FISICA
        If nLinAtu + (nTamLin*3) > nLinFin
            fImpRod()
            fImpCab()
        EndIf

        oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, 'CONSULTAS REALIZADAS', oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)
        nLinAtu += (nTamLin * 2)
        oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
        oPrintPvt:Line(nLinAtu, 120, nLinAtu + 20, 120, COR_PRETO)
        oPrintPvt:Line(nLinAtu, 450, nLinAtu + 20, 450, COR_PRETO)
        
        oPrintPvt:SayAlign(nLinAtu, nColIni, 'Data Ocorrencia'  , oFontDetN, 100, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+120, 'Segmento'     , oFontDetN, 260, 20,  COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+490, 'Dias'         , oFontDetN, 20, 20,   COR_PRETO, PAD_CENTER, 0)
        
        nQtd := 0

        oConsult := iif(valtype(oJsonSer['reports'][1,'facts']['inquiry']['inquiryResponse']) == "U" .or. empty(oJsonSer['reports'][1,'facts']['inquiry']['inquiryResponse']), {}, oJsonSer['reports'][1,'facts']['inquiry']['inquiryResponse'])
        
        for nX := 1 to Len(oConsult)
            
            If nLinAtu + (nTamLin*2) > nLinFin
                fImpRod()
                fImpCab()
                oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
                oPrintPvt:Line(nLinAtu, 120, nLinAtu + 20, 120, COR_PRETO)
                oPrintPvt:Line(nLinAtu, 450, nLinAtu + 20, 450, COR_PRETO)
                
                oPrintPvt:SayAlign(nLinAtu, nColIni, 'Data Ocorrencia'  , oFontDetN, 100, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+120, 'Segmento'         , oFontDetN, 260, 20,  COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+490, 'Dias'             , oFontDetN, 10, 20,   COR_PRETO, PAD_CENTER, 0)
            EndIf

            nLinAtu += (nTamLin * 2)
            oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20,  nColFin, "-4")
            oPrintPvt:Line(nLinAtu, 120, nLinAtu + 20, 120, COR_PRETO)
            oPrintPvt:Line(nLinAtu, 450, nLinAtu + 20, 450, COR_PRETO)
    
            oPrintPvt:SayAlign(nLinAtu, nColIni, oConsult[nX]['occurrenceDate']  , oFontDet, 100, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+120, oConsult[nX]['segmentDescription']         , oFontDet, 260, 20,  COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+490, cValToChar(oConsult[nX]['daysQuantity'])           , oFontDet, 10, 20,  COR_PRETO, PAD_CENTER, 0)
            nQtd += 1
        next nX

        If nLinAtu + (nTamLin*5) > nLinFin
            fImpRod()
            fImpCab()
        EndIf

        nLinAtu += (nTamLin * 2)
        oPrintPvt:SayAlign(nLinAtu, nColIni,'Resumo de consuntas: ', oFontDetN, 140, 20, COR_PRETO, PAD_LEFT, 0)
        nLinAtu += nTamLin
        oPrintPvt:SayAlign(nLinAtu, nColIni,'Quantidade Total: '+cvaltochar(nQtd), oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
        nLinAtu += nTamLin

        oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, 'HISTORICO DA CONSULTAS', oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)

        /* HISTORICOS DE CONSULTA */
        nLinAtu += (nTamLin * 2)
        oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColMeio, "-4")
        oPrintPvt:Line(nLinAtu, nColMeio/2, nLinAtu + 20, nColMeio/2, COR_PRETO)

        oPrintPvt:SayAlign(nLinAtu, nColIni, 'Mes/Ano'      , oFontDetN, nColMeio/2, 20,  COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColMeio/2, 'Ocorrencia'   , oFontDetN, nColMeio/2, 20,  COR_PRETO, PAD_CENTER, 0)
        
        oHistoric :=iif(valtype(oJsonSer['reports'][1,'facts']['inquirySummary']['inquiryQuantity']['creditInquiriesQuantity']) == "U" .or. empty(oJsonSer['reports'][1,'facts']['inquirySummary']['inquiryQuantity']['creditInquiriesQuantity']), {}, oJsonSer['reports'][1,'facts']['inquirySummary']['inquiryQuantity']['creditInquiriesQuantity'])
        For nz := 1 to Len(oHistoric)
            nLinAtu += (nTamLin * 2)

            If nLinAtu + nTamLin > nLinFin
                fImpRod()
                fImpCab()

                oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColMeio, "-4")
                oPrintPvt:Line(nLinAtu, nColMeio/2, nLinAtu + 20, nColMeio/2, COR_PRETO)

                oPrintPvt:SayAlign(nLinAtu, nColIni,'Mes/Ano'      , oFontDetN, nColMeio/2, 20,  COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColMeio/2, 'Ocorrencia'   , oFontDetN, nColMeio/2, 20,  COR_PRETO, PAD_CENTER, 0)
                nLinAtu += (nTamLin * 2)
            EndIf

            oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColMeio, "-4")
            oPrintPvt:Line(nLinAtu, nColMeio/2, nLinAtu + 20, nColMeio/2, COR_PRETO)

            oPrintPvt:SayAlign(nLinAtu, nColIni,oHistoric[nz]['inquiryDate']  , oFontDet, nColMeio/2, 20,  COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColMeio/2, cValToChar(oHistoric[nz]['occurrences'])      , oFontDet, nColMeio/2, 20,  COR_PRETO, PAD_CENTER, 0)
        next nz

    /* FIM CONSULTAS REALIZADAS É HISTORICOS DE CONSULTA */
    else // PESSOA JURIDICA
        
        // RESUMO DE CHEQUE SEM FUNDO
        If nLinAtu + (nTamLin * 8) > nLinFin
            fImpRod()
            fImpCab()
        endIf
        nLinAtu += (nTamLin * 2)
        
        oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, 'RESUMO DE CHEQUE SEM FUNDO', oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)

        nLinAtu += (nTamLin * 2)
        oPrintPvt:SayAlign(nLinAtu, nColIni,'Primeira Ocorrencia: ', oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
        nLinAtu += nTamLin
        oPrintPvt:SayAlign(nLinAtu, nColIni,'Ultima Ocorrencia: ', oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
        nLinAtu += nTamLin
        oPrintPvt:SayAlign(nLinAtu, nColIni,'Quantidade: '+Transform(0,"@E 999,999,999,999.99"), oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
        nLinAtu += nTamLin
        oPrintPvt:SayAlign(nLinAtu, nColIni,'Saldo Total: '+Transform(0,"@E 999,999,999,999.99"), oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)

        // bloco de resumo do Protestos
        If nLinAtu + (nTamLin * 2) > nLinFin
            fImpRod()
            fImpCab()
        endIf

        nLinAtu += (nTamLin * 2)
        oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, 'RESUMO PROTESTOS', oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
        oPrintPvt:Line(nLinAtu, 90,  nLinAtu + 20, 90, COR_PRETO)
        oPrintPvt:Line(nLinAtu, 170, nLinAtu + 20, 170, COR_PRETO)
        oPrintPvt:Line(nLinAtu, 260, nLinAtu + 20, 260, COR_PRETO)
        oPrintPvt:Line(nLinAtu, 410, nLinAtu + 20, 410, COR_PRETO)
        oPrintPvt:Line(nLinAtu, 490, nLinAtu + 20, 490, COR_PRETO)

        oPrintPvt:SayAlign(nLinAtu, nColIni,     'Data'     , oFontTit, 80, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+90,  'Valor'    , oFontTit, 50, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+170, 'Office'   , oFontTit, 60, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+260, 'Cidade'   , oFontTit, 125, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+410, 'UF'       , oFontTit, 50, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+490, 'Cadus'    , oFontTit, 50, 20, COR_PRETO, PAD_CENTER, 0)
        
        cPrimProtesto := ""
        cUltProtesto   := ""
        nVlrTotal:=0
        nCont:=0
        nz:=0

        aProtesto := iif(valtype(oJsonSer["optionalFeatures"]["negativeData"]["notary"]["notaryResponse"]) == "U" .or. empty(oJsonSer["optionalFeatures"]["negativeData"]["notary"]["notaryResponse"]), {}, oJsonSer["optionalFeatures"]["negativeData"]["notary"]["notaryResponse"])
        for nz := 1 to Len(aProtesto)
            If nLinAtu + (nTamLin * 3) > nLinFin
                fImpRod()
                fImpCab()

                nLinAtu += (nTamLin * 2)
                oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
                oPrintPvt:Line(nLinAtu, 90,  nLinAtu + 20, 90, COR_PRETO)
                oPrintPvt:Line(nLinAtu, 170, nLinAtu + 20, 170, COR_PRETO)
                oPrintPvt:Line(nLinAtu, 260, nLinAtu + 20, 260, COR_PRETO)
                oPrintPvt:Line(nLinAtu, 410, nLinAtu + 20, 410, COR_PRETO)
                oPrintPvt:Line(nLinAtu, 490, nLinAtu + 20, 490, COR_PRETO)

                oPrintPvt:SayAlign(nLinAtu, nColIni,     'Data'     , oFontTit, 80, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+90,  'Valor'    , oFontTit, 50, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+170, 'Office'   , oFontTit, 60, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+260, 'Cidade'   , oFontTit, 125, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+410, 'UF'       , oFontTit, 50, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+490, 'Cadus'    , oFontTit, 50, 20, COR_PRETO, PAD_CENTER, 0)
            endIf

            nLinAtu += (nTamLin * 2)
            oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
            oPrintPvt:Line(nLinAtu, 90,  nLinAtu + 20, 90, COR_PRETO)
            oPrintPvt:Line(nLinAtu, 170, nLinAtu + 20, 170, COR_PRETO)
            oPrintPvt:Line(nLinAtu, 260, nLinAtu + 20, 260, COR_PRETO)
            oPrintPvt:Line(nLinAtu, 410, nLinAtu + 20, 410, COR_PRETO)
            oPrintPvt:Line(nLinAtu, 490, nLinAtu + 20, 490, COR_PRETO)

            oPrintPvt:SayAlign(nLinAtu, nColIni,     iif(Empty(aProtesto[nz]["occurrenceDate"]), "  /  /    ", DtoC(StoD(strtran(aProtesto[nz]["occurrenceDate"], "-", "")))), oFontDet, 80, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+90,  cValToChar(aProtesto[nz]["amount"])  , oFontDet, 50, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+170, aProtesto[nz]["officeNumber"]  , oFontDet, 60, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+260, aProtesto[nz]["city"]  , oFontDet, 125, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+410, aProtesto[nz]["federalUnit"]  , oFontDet, 50, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+490, aProtesto[nz]["cadus"]  , oFontDet, 50, 20, COR_PRETO, PAD_CENTER, 0)
            nCont++
            nVlrTotal += aProtesto[nz]["amount"]

            If Empty(cPrimProtesto)
                cPrimProtesto := aProtesto[nz]['occurrenceDate']
            EndIf

            cUltProtesto := aProtesto[nz]['occurrenceDate']
        next nz

        If nLinAtu + (nTamLin * 6) > nLinFin
            fImpRod()
            fImpCab()
        endIf

        nLinAtu += (nTamLin * 2)
        oPrintPvt:SayAlign(nLinAtu, nColIni,'Primeira Ocorrencia: ' + cPrimProtesto, oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
        nLinAtu += nTamLin
        oPrintPvt:SayAlign(nLinAtu, nColIni,'Ultima Ocorrencia: ' + cUltProtesto, oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
        nLinAtu += nTamLin
        oPrintPvt:SayAlign(nLinAtu, nColIni,'Quantidade: '+Transform(nCont,"@E 999,999,999,999.99"), oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
        nLinAtu += nTamLin
        oPrintPvt:SayAlign(nLinAtu, nColIni,'Saldo: '+Transform(nVlrTotal,"@E 999,999,999,999.99"), oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)

        //==============================================
        // BLOCO - EXECUÇÕES JUDICIAIS
        //==============================================
        If nLinAtu + (nTamLin * 2) > nLinFin
            fImpRod()
            fImpCab()
        EndIf

        // Título do bloco
        nLinAtu += (nTamLin * 2)
        oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, 'EXECUÇÕES JUDICIAIS', oFontTit, 200, 20, COR_PRETO, PAD_CENTER, 0)

        // Cabeçalho
        nLinAtu += (nTamLin * 2)
        oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
        oPrintPvt:Line(nLinAtu, 120,  nLinAtu + 20, 120, COR_PRETO)
        oPrintPvt:Line(nLinAtu, 260,  nLinAtu + 20, 260, COR_PRETO)
        oPrintPvt:Line(nLinAtu, 420,  nLinAtu + 20, 420, COR_PRETO)

        oPrintPvt:SayAlign(nLinAtu, nColIni,      'Data'    , oFontTit, 100, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+120,  'Natureza', oFontTit, 120, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+260,  'Valor'   , oFontTit, 120, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+420,  'Cidade'  , oFontTit, 150, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+570,  'Estado'  , oFontTit, 60, 20, COR_PRETO, PAD_CENTER, 0)

        // Loop de dados
        nVlrExec := 0
        nCont := 0
        aExeJudic := iif(valtype(oJsonSer["optionalFeatures"]["facts"]["judgementFilings"]['judgementFilingsResponse']) == "U" .or. empty(oJsonSer["optionalFeatures"]["facts"]["judgementFilings"]['judgementFilingsResponse']), {}, oJsonSer["optionalFeatures"]["facts"]["judgementFilings"]['judgementFilingsResponse'])

        For nx := 1 To Len(aExeJudic)

            If nLinAtu + (nTamLin * 3) > nLinFin
                fImpRod()
                fImpCab()

                nLinAtu += (nTamLin * 2)

                // Reimprime cabeçalho
                oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
                oPrintPvt:Line(nLinAtu, 120,  nLinAtu + 20, 120, COR_PRETO)
                oPrintPvt:Line(nLinAtu, 260,  nLinAtu + 20, 260, COR_PRETO)
                oPrintPvt:Line(nLinAtu, 420,  nLinAtu + 20, 420, COR_PRETO)

                oPrintPvt:SayAlign(nLinAtu, nColIni,      'Data'    , oFontTit, 100, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+120,  'Natureza', oFontTit, 120, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+260,  'Valor'   , oFontTit, 120, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+420,  'Cidade'  , oFontTit, 150, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+570,  'Estado'  , oFontTit, 60, 20, COR_PRETO, PAD_CENTER, 0)
            EndIf

            nLinAtu += (nTamLin * 2)

            oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
            oPrintPvt:Line(nLinAtu, 120,  nLinAtu + 20, 120, COR_PRETO)
            oPrintPvt:Line(nLinAtu, 260,  nLinAtu + 20, 260, COR_PRETO)
            oPrintPvt:Line(nLinAtu, 420,  nLinAtu + 20, 420, COR_PRETO)

            // Dados (mock - você vai trocar pelo real)
            oPrintPvt:SayAlign(nLinAtu, nColIni,      iif(Empty(aExeJudic[nx]["occurrenceDate"]), "  /  /    ", DtoC(StoD(strtran(aExeJudic[nx]["occurrenceDate"], "-", "")))), oFontDet, 100, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+120,  aExeJudic[nx]["legalNature"], oFontDet, 120, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+260,  cValToChar(aExeJudic[nx]["amount"]), oFontDet, 120, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+420,  aExeJudic[nx]["city"], oFontDet, 150, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+570,  aExeJudic[nx]["state"], oFontDet, 60, 20, COR_PRETO, PAD_CENTER, 0)

            nVlrExec += aExeJudic[nx]["amount"]
            nCont++

        Next nX

        // Resumo
        If nLinAtu + (nTamLin * 5) > nLinFin
            fImpRod()
            fImpCab()
        EndIf
        nLinAtu += (nTamLin * 2)
        oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, 'FALENCIA', oFontTit, 200, 20, COR_PRETO, PAD_CENTER, 0)

        nLinAtu += (nTamLin * 2)
        oPrintPvt:SayAlign(nLinAtu, nColIni, 'Quantidade: '+Transform(nCont,"@E 999,999"), oFontDetN, 200, 20, COR_PRETO, PAD_LEFT, 0)

        nLinAtu += nTamLin
        oPrintPvt:SayAlign(nLinAtu, nColIni, 'Saldo: '+Transform(nVlrExec,"@E 999,999,999,999.99"), oFontDetN, 200, 20, COR_PRETO, PAD_LEFT, 0)

        //==============================================
        // BLOCO - RESPOSTA DAS CONSULTAS A SERASA
        //==============================================
        If nLinAtu + (nTamLin * 2) > nLinFin
            fImpRod()
            fImpCab()
        EndIf

        // Título
        nLinAtu += nTamLin
        oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, 'RESPOSTA DAS CONSULTAS A SERASA', oFontTit, 400, 20, COR_PRETO, PAD_CENTER, 0)

        // Cabeçalho
        nLinAtu += (nTamLin * 2)
        oPrintPvt:Box(nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")

        oPrintPvt:Line(nLinAtu, 120, nLinAtu + 20, 120, COR_PRETO)
        oPrintPvt:Line(nLinAtu, 360, nLinAtu + 20, 360, COR_PRETO)
        oPrintPvt:Line(nLinAtu, 520, nLinAtu + 20, 520, COR_PRETO)
        oPrintPvt:Line(nLinAtu, 600, nLinAtu + 20, 600, COR_PRETO)

        oPrintPvt:SayAlign(nLinAtu, nColIni,      'Data Ocorrência', oFontTit, 120, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+120,  'Nome da Empresa', oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+360,  'Documento',       oFontTit, 160, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+515,  'Dias',            oFontTit, 30,  20, COR_PRETO, PAD_LEFT, 0)

        aRespostaSerasa := iif(valtype(oJsonSer["reports"][1]["facts"]["inquiryCompanyResponse"]["results"]) == "U" .or. empty(oJsonSer["reports"][1]["facts"]["inquiryCompanyResponse"]["results"]), {}, oJsonSer["reports"][1]["facts"]["inquiryCompanyResponse"]["results"])
        // Loop
        nQtdSerasa := 0

        For nx := 1 To Len(aRespostaSerasa)

            If nLinAtu + (nTamLin * 3) > nLinFin
                fImpRod()
                fImpCab()

                nLinAtu += (nTamLin * 2)

                // Reimprime cabeçalho
                oPrintPvt:Box(nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")

                oPrintPvt:Line(nLinAtu, 120, nLinAtu + 20, 120, COR_PRETO)
                oPrintPvt:Line(nLinAtu, 360, nLinAtu + 20, 360, COR_PRETO)
                oPrintPvt:Line(nLinAtu, 520, nLinAtu + 20, 520, COR_PRETO)
                oPrintPvt:Line(nLinAtu, 600, nLinAtu + 20, 600, COR_PRETO)

                oPrintPvt:SayAlign(nLinAtu, nColIni,      'Data Ocorrência', oFontTit, 120, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+120,  'Nome da Empresa', oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+360,  'Documento',       oFontTit, 160, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+515,  'Dias',            oFontTit, 30,  20, COR_PRETO, PAD_LEFT, 0)
            EndIf

            nLinAtu += (nTamLin * 2)

            oPrintPvt:Box(nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")

            oPrintPvt:Line(nLinAtu, 120, nLinAtu + 20, 120, COR_PRETO)
            oPrintPvt:Line(nLinAtu, 360, nLinAtu + 20, 360, COR_PRETO)
            oPrintPvt:Line(nLinAtu, 520, nLinAtu + 20, 520, COR_PRETO)
            oPrintPvt:Line(nLinAtu, 600, nLinAtu + 20, 600, COR_PRETO)

            // Dados exemplo (substituir pelo real)
            oPrintPvt:SayAlign(nLinAtu, nColIni,      iif(Empty(aRespostaSerasa[nx]["occurrenceDate"]), "  /  /    ", Dtoc(StoD(strtran(aRespostaSerasa[nx]["occurrenceDate"], '-', '')))),         oFontDet, 120, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+120,  aRespostaSerasa[nx]["companyName"], oFontDet, 240, 20, COR_PRETO, PAD_LEFT, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+360,  aRespostaSerasa[nx]["companyDocumentId"],     oFontDet, 160, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+520,  cValToChar(aRespostaSerasa[nx]["daysQuantity"]),                  oFontDet, 30, 20, COR_PRETO, PAD_LEFT, 0)

            nQtdSerasa++

        Next

        // Rodapé resumo
        // If nLinAtu + (nTamLin * 3) > nLinFin
        //     fImpRod()
        //     fImpCab()
        // EndIf

        // nLinAtu += (nTamLin * 2)
        // oPrintPvt:SayAlign(nLinAtu, nColIni, 'Quantidade: ' + cValToChar(nQtdSerasa), oFontDetN, 200, 20, COR_PRETO, PAD_LEFT, 0)
    endif

    fImpRod()

    //Mostrando o relatório
    oPrintPvt:Setup()
    
    if oPrintPvt:cPathPDF =='c:\'
        oPrintPvt:cPathPDF := cCaminho
        oPrintPvt:Preview()
    else
        cCaminho := oPrintPvt:cPathPDF
        oPrintPvt:Preview()
    endif
    
    cArq := cCaminho + cArquivo + '.pdf'
    If File(cArq)
    //Tenta abrir o arquivo e pegar o conteudo
        oFile := FwFileReader():New(cArq)
        If oFile:Open()
             //Se deu certo abrir o arquivo, pega o conteudo e transforma em base 64
            cConteudo  := oFile:FullRead()
            cString64  := Encode64(cConteudo, , .F., .F.)
        EndIf

        Reclock('SA1', .F.)
            SA1->A1_PDFBAS := cString64
        SA1->(MSUNLOCK())
        oFile:Close()
    EndIf
    
Return
 
/*---------------------------------------------------------------------*
 | Func:  fImpCab                                                      |
 | Desc:  Função que imprime o cabeçalho                               |
 *---------------------------------------------------------------------*/
 
Static Function fImpCab()
    Local cTitCab   := ""
    Local cSubTit   := ""
    Local nLinCab  := 030
     
    //Iniciando Página
    oPrintPvt:StartPage()
     
    //Cabeçalho
    cTitCab := "RELATORIO "+cTp_Rel+" "+cTP_Cli+" - v3"
    cSubTit := iif(cTp_Rel == "BASICO", "DADOS CADASTRAIS", "IDENTIFICACAO / LOCALIZACAO (ATUALIZADO EM 15:16:52)")
    
    // Primeira parte do cabecalho, para tipo de cliente PJ e PF.
    // contempla Logo, Nome Empresa/CNPJ/capital , data de emissao
    // para Relatorio basico ou completo

    // Segunda parte do cabecalho para cliente PF e PJ e para Relatorio basico ou completo
    // Comtempla os dados do cliente seja PF ou PJ.

    if cTp_Rel = "BASICO"
        oRegistration := oJsonSer['reports'][1]['registration']
        if cTp_Cli =='PF' // PESSOA FISICA

            oPrintPvt:SayBitMap(nLinCab, nColIni, "\system\lgpmz.bmp", 70, 30)
            oPrintPvt:SayAlign(nLinCab, nColMeio - 120, cTitCab, oFontTit, 240, 20, COR_CINZA, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinCab+30, nColMeio - 120, cSubTit, oFontDetN, 240, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinCab, nColFin - 200, 'Emissão: '+dtoc(Date()), oFontSay, 240, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinCab+10, nColFin - 200,'Usuario/Horario: '+UsrRetName(RetCodUsr())+' - '+Time(), oFontSay, 240, 20, COR_PRETO, PAD_CENTER, 0)
            //Linha Separatória
            nLinCab += (nTamLin * 5)

            oPrintPvt:Line(nLinCab, nColIni, nLinCab, nColFin, COR_CINZA)
            oPrintPvt:SayAlign(nLinCab, nColIni, "CPF: "+iif(valtype(oRegistration['documentNumber']) == "U" .or. empty(oRegistration['documentNumber']), "", oRegistration['documentNumber']), oFontDetN, 150, nTamLin, COR_PRETO, PAD_LEFT, 0)
            nLinCab += nTamLin
            oPrintPvt:SayAlign(nLinCab, nColIni, "Nome: "+iif(valtype(oRegistration['consumerName']) == "U" .or. empty(oRegistration['consumerName']), "", oRegistration['consumerName']), oFontDetN, 150, nTamLin, COR_PRETO, PAD_LEFT, 0)
            nLinCab += nTamLin
            oPrintPvt:SayAlign(nLinCab, nColIni, "Genero: "+iif(oRegistration['consumerGender']=='F','Feminino','Masculino'), oFontDetN, 150, nTamLin, COR_PRETO, PAD_LEFT, 0)
            nLinCab += nTamLin
            oPrintPvt:SayAlign(nLinCab, nColIni, "Data Nascimento: "+iif(valtype(oRegistration['birthDate']) == "U" .or. empty(oRegistration['birthDate']), "  /  /    ", DtoC(Stod(StrTran(oRegistration['birthDate'], "-", "")))), oFontDetN, 150, nTamLin, COR_PRETO, PAD_LEFT, 0)
            nLinCab += nTamLin
            oPrintPvt:SayAlign(nLinCab, nColIni, "Idade: "+iif(valtype(oRegistration['age']) == "U" .or. empty(oRegistration['age']), "", oRegistration['age']), oFontDetN, 150, nTamLin, COR_PRETO, PAD_LEFT, 0)
            nLinCab += nTamLin
            oPrintPvt:SayAlign(nLinCab, nColIni, "Status: "+iif(valtype(oRegistration['statusRegistration']) == "U" .or. empty(oRegistration['statusRegistration']), "", oRegistration['statusRegistration']), oFontDetN, 150, nTamLin, COR_PRETO, PAD_LEFT, 0)
            nLinCab += nTamLin
            oPrintPvt:SayAlign(nLinCab, nColIni, "Data Status: "+iif(valtype(oRegistration['statusDate']) == "U" .or. empty(oRegistration['statusDate']), "", DtoC(Stod(StrTran(oRegistration['statusDate'], "-", "")))), oFontDetN, 150, nTamLin, COR_PRETO, PAD_LEFT, 0)
        
        else // PESSOA JURIDICA

            oPrintPvt:SayBitMap(nLinCab, nColIni, "\system\lgpmz.bmp", 70, 30)
            oPrintPvt:SayAlign(nLinCab, nColMeio - 120, cTitCab, oFontTit, 240, 20, COR_CINZA, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinCab, nColFin - 200, 'Emissão: '+dtoc(Date()), oFontSay, 240, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinCab+10, nColFin - 200, 'Usuario/Horario: '+UsrRetName(RetCodUsr())+' - '+Time(), oFontSay, 240, 20, COR_PRETO, PAD_CENTER, 0)
            nLinCab += 20
            // Razão Social Centralizada
            oPrintPvt:SayAlign( nLinCab, nColMeio - 250, iif(valtype(oRegistration['companyName']) == "U" .or. empty(oRegistration['companyName']), "", oRegistration['companyName']), oFontTit, 500, nTamLin, COR_PRETO, PAD_CENTER, 0 )
            nLinCab += (nTamLin * 2)
            // CNPJ
            oPrintPvt:SayAlign( nLinCab, nColIni, "CNPJ: " + iif(valtype(oRegistration['documentNumber']) == "U" .or. empty(oRegistration['documentNumber']), "", oRegistration['documentNumber']), oFontDetN, 200, nTamLin, COR_PRETO, PAD_LEFT, 0 )
            // nLinCab += nTamLin
            // Valores em Reais
            oPrintPvt:SayAlign( nLinCab, nColMeio - 100, "VALORES EM REAIS", oFontDetN, 200, nTamLin, COR_PRETO, PAD_CENTER, 0 )
            // Data da consulta
            oPrintPvt:SayAlign( nLinCab, nColFin - 180, DtoC(date()) +'-'+Time(), oFontDetN, 150, nTamLin, COR_PRETO, PAD_RIGHT, 0 )
            nLinCab += (nTamLin * 2)
            oPrintPvt:Line( nLinCab, nColIni, nLinCab, nColFin, COR_CINZA )
            nLinCab += (nTamLin)
            oPrintPvt:SayAlign(nLinCab, nColMeio - 120, cSubTit, oFontDetN, 240, 20, COR_PRETO, PAD_CENTER, 0)
            //Linha Separatória
            nLinCab += (nTamLin * 2)

            oPrintPvt:Line(nLinCab, nColIni, nLinCab, nColFin, COR_CINZA)
            oPrintPvt:SayAlign(nLinCab, nColIni, "CNPJ:  "+iif(valtype(oRegistration['companyDocument']) == "U" .or. empty(oRegistration['companyDocument']), "", oRegistration['companyDocument']), oFontDetN, 150, nTamLin, COR_PRETO, PAD_LEFT, 0)
            nLinCab += nTamLin
            oPrintPvt:SayAlign(nLinCab, nColIni, "Nome Empresarial: "+iif(valtype(oRegistration['companyName']) == "U" .or. empty(oRegistration['companyName']), "", oRegistration['companyName']), oFontDetN, 500, nTamLin, COR_PRETO, PAD_LEFT, 0)
            nLinCab += nTamLin
            // oPrintPvt:SayAlign(nLinCab, nColIni, "Genero: Masculino", oFontDetN, 150, nTamLin, COR_PRETO, PAD_LEFT, 0)
            // nLinCab += nTamLin
            oPrintPvt:SayAlign(nLinCab, nColIni, "Data Fundação: "+iif(valtype(oRegistration['foundationDate']) == "U" .or. empty(oRegistration['foundationDate']), "  /  /    ", DtoC(Stod(StrTran(oRegistration['foundationDate'], "-", "")))), oFontDetN, 150, nTamLin, COR_PRETO, PAD_LEFT, 0)
            nLinCab += nTamLin
            oPrintPvt:SayAlign(nLinCab, nColIni, "Situacao CNPJ: "+iif(valtype(oRegistration['statusRegistration']) == "U" .or. empty(oRegistration['statusRegistration']), "", oRegistration['statusRegistration']), oFontDetN, 500, nTamLin, COR_PRETO, PAD_LEFT, 0)
            // nLinCab += nTamLin
            // oPrintPvt:SayAlign(nLinCab, nColIni, "Status: Positivo", oFontDetN, 150, nTamLin, COR_PRETO, PAD_LEFT, 0)
            nLinCab += nTamLin
            oPrintPvt:SayAlign(nLinCab, nColIni, "Cidade: "+iif(valtype(oRegistration['address']['city']) == "U" .or. empty(oRegistration['address']['city']), "", oRegistration['address']['city']), oFontDetN, 150, nTamLin, COR_PRETO, PAD_LEFT, 0)
            oPrintPvt:SayAlign(nLinCab, nColIni+200, "UF: "+iif(valtype(oRegistration['address']['state']) == "U" .or. empty(oRegistration['address']['state']), "", oRegistration['address']['state']), oFontDetN, 150, nTamLin, COR_PRETO, PAD_LEFT, 0)
        endif
    else  ///  COMPLETO

        if cTp_Cli == 'PF'
            oRegistration := oJsonSer['reports'][1]['registration']
            // Relatorio Completo - exemplo de blocos adicionais no cabeçalho
            // LINHA SUPERIOR
            
            oPrintPvt:SayBitMap(nLinCab, nColIni, "\system\lgpmz.bmp", 70, 30)
            oPrintPvt:SayAlign(nLinCab, nColMeio - 120, cTitCab, oFontTit, 240, 20, COR_CINZA, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinCab+30, nColMeio - 120, cSubTit, oFontDetN, 240, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinCab, nColFin - 200, 'Emissão: '+dtoc(Date()), oFontSay, 240, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinCab+10, nColFin - 200,'Usuario/Horario: '+UsrRetName(RetCodUsr())+' - '+Time(), oFontSay, 240, 20, COR_PRETO, PAD_CENTER, 0)
            //Linha Separatória
            nLinCab += (nTamLin * 5)

            oPrintPvt:Line(nLinCab, nColIni, nLinCab, nColFin, COR_CINZA)
            nLinCab += 10

            // DEFINIÇÃO DAS COLUNAS
            nColEsq := nColIni
            nColDir := nColMeio + 50

            // LINHA 1
            oPrintPvt:SayAlign(nLinCab, nColEsq, "CPF: "+iif(valtype(oRegistration['documentNumber']) == "U" .or. empty(oRegistration['documentNumber']), "", oRegistration['documentNumber']), oFontDetN, 300, nTamLin, COR_PRETO, PAD_LEFT, 0)

            oPrintPvt:SayAlign(nLinCab, nColDir, "DATA NASCIMENTO: "+iif( valtype(oRegistration['birthDate']) == "U" .or. empty(oRegistration['birthDate']), "  /  /    ", DtoC(Stod(StrTran(oRegistration['birthDate'], "-", "")))), oFontDetN, 300, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            // LINHA 2
            oPrintPvt:SayAlign(nLinCab, nColEsq, "NOME: "+iif(valtype(oRegistration['consumerName']) == "U" .or. empty(oRegistration['consumerName']), "", oRegistration['consumerName']), oFontDetN, 400, nTamLin, COR_PRETO, PAD_LEFT, 0)

            oPrintPvt:SayAlign(nLinCab, nColDir, "IDADE: "+iif(valtype(oRegistration['age']) == "U" .or. empty(oRegistration['age']), "", oRegistration['age']), oFontDetN, 200, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            // LINHA 3
            oPrintPvt:SayAlign(nLinCab, nColEsq, "NOME DA MAE: "+iif(valtype(oRegistration['motherName']) == "U" .or. empty(oRegistration['motherName']), "", oRegistration['motherName']), oFontDetN, 400, nTamLin, COR_PRETO, PAD_LEFT, 0)

            oPrintPvt:SayAlign(nLinCab, nColDir, "SITUACAO CPF: "+iif(valtype(oRegistration['statusRegistration']) == "U" .or. empty(oRegistration['statusRegistration']), "", oRegistration['statusRegistration']), oFontDetN, 300, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin
            nScore := iif(valtype(oJsonSer['optionalFeatures']['score']) == "U" .or. empty(oJsonSer['optionalFeatures']['score']),0,oJsonSer['reports'][1]['optionalFeatures']['score']['score'])
            // LINHA 4
            oPrintPvt:SayAlign(nLinCab, nColEsq, "RENDA ESTIMADA: R$ " , oFontDetN, 300, nTamLin, COR_PRETO, PAD_LEFT, 0)

            oPrintPvt:SayAlign(nLinCab, nColDir, "SCORE: " + alltrim(cValToChar(nScore)), oFontDetN, 200, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += (nTamLin * 2)

            // LINHA INFERIOR
            oPrintPvt:Line(nLinCab, nColIni, nLinCab, nColFin, COR_CINZA)

        else // PJ COMPLETO
            oRegistration := oJsonSer['reports'][1]['identificationReport']
            oPrintPvt:SayBitMap(nLinCab, nColIni, "\system\lgpmz.bmp", 70, 30)
            oPrintPvt:SayAlign(nLinCab, nColMeio - 120, cTitCab, oFontTit, 240, 20, COR_CINZA, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinCab, nColFin - 200, 'Emissão: '+dtoc(Date()), oFontSay, 240, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinCab+10, nColFin - 200, 'Usuario/Horario: '+UsrRetName(RetCodUsr())+' - '+Time(), oFontSay, 240, 20, COR_PRETO, PAD_CENTER, 0)
            nLinCab += 20
            // Razão Social Centralizada
            oPrintPvt:SayAlign( nLinCab, nColMeio - 250, iif(valtype(oRegistration['companyName']) == "U" .or. empty(oRegistration['companyName']), "", oRegistration['companyName']), oFontTit, 500, nTamLin, COR_PRETO, PAD_CENTER, 0 )
            nLinCab += (nTamLin * 2)

            // CNPJ
            oPrintPvt:SayAlign( nLinCab, nColIni, "CNPJ: " + iif(valtype(oRegistration['documentNumber']) == "U" .or. empty(oRegistration['documentNumber']), "", oRegistration['documentNumber']), oFontDetN, 200, nTamLin, COR_PRETO, PAD_LEFT, 0 )
            // nLinCab += nTamLin
            // Valores em Reais
            oPrintPvt:SayAlign( nLinCab, nColMeio - 100, "VALORES EM REAIS", oFontDetN, 200, nTamLin, COR_PRETO, PAD_CENTER, 0 )
            // Data da consulta
            oPrintPvt:SayAlign( nLinCab, nColFin - 180, DtoC(date()) +'-'+Time(), oFontDetN, 150, nTamLin, COR_PRETO, PAD_RIGHT, 0 )
            nLinCab += (nTamLin * 2)
            oPrintPvt:Line( nLinCab, nColIni, nLinCab, nColFin, COR_CINZA )
            nLinCab += (nTamLin)
            oPrintPvt:SayAlign(nLinCab, nColMeio - 120, cSubTit, oFontDetN, 240, 20, COR_PRETO, PAD_CENTER, 0)
            //Linha Separatória
            nLinCab += (nTamLin * 2)

            oPrintPvt:Line(nLinCab, nColIni, nLinCab, nColFin, COR_CINZA)

            nLinCab += 10

            nColEsq := nColIni
            nColDir := nColMeio + 50

            oPrintPvt:SayAlign(nLinCab, nColEsq, "CNPJ: "+iif(valtype(oRegistration['documentNumber']) == "U" .or. empty(oRegistration['documentNumber']), "", oRegistration['documentNumber']), oFontDetN, 250, nTamLin, COR_PRETO, PAD_LEFT, 0)

            oPrintPvt:SayAlign(nLinCab, nColDir, iif(valtype(oRegistration['statusRegistration']) == "U" .or. empty(oRegistration['statusRegistration']), "", oRegistration['statusRegistration']), oFontDetN, 350, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "RAZAO SOCIAL: "+iif(valtype(oRegistration['companyName']) == "U" .or. empty(oRegistration['companyName']), "", oRegistration['companyName']), oFontDetN, 700, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "NOME FANTASIA: "+iif(valtype(oRegistration['companyName']) == "U" .or. empty(oRegistration['companyName']), "", oRegistration['companyName']), oFontDetN, 500, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "TIPO DE SOCIEDADE: "+iif(valtype(oRegistration['partnership']) == "U" .or. empty(oRegistration['partnership']), "", oRegistration['partnership']), oFontDetN, 600, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "ANTECESSOR: ", oFontDetN, 450, nTamLin, COR_PRETO, PAD_LEFT, 0)

            oPrintPvt:SayAlign(nLinCab, nColDir + 120, "ATE: 01/05/2022", oFontDetN, 150, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "REGISTRO: "+iif(valtype(oRegistration['companyRegister']) == "U" .or. empty(oRegistration['companyRegister']), "", oRegistration['companyRegister']), oFontDetN, 250, nTamLin, COR_PRETO, PAD_LEFT, 0)

            oPrintPvt:SayAlign(nLinCab, nColDir - 80, "DATA DE REGISTRO: "+iif(valtype(oRegistration['companyRegisterDate']) == "U" .or. empty(oRegistration['companyRegisterDate']), "  /  /    ", DtoC(StoD(StrTran(oRegistration['companyRegisterDate'], "-", "")))), oFontDetN, 250, nTamLin, COR_PRETO, PAD_LEFT, 0)

            oPrintPvt:SayAlign(nLinCab, nColDir + 120, "NIRE: "+iif(valtype(oRegistration['nireNumber']) == "U" .or. empty(oRegistration['nireNumber']), "", oRegistration['nireNumber']), oFontDetN, 180, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "INSCRICAO ESTADUAL: "+iif(valtype(oRegistration['stateRegistration']) == "U" .or. empty(oRegistration['stateRegistration']), "", oRegistration['stateRegistration']), oFontDetN, 350, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "TELEFONE: "+iif(valtype(oRegistration['phone']) == "U" .or. empty(oRegistration['phone']['phoneNumber']), "", oRegistration['phone']['phoneNumber']), oFontDetN, 300, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "ENDERECO: "+iif(valtype(oRegistration['address']) == "U" .or. empty(oRegistration['address']['addressLine']), "", oRegistration['address']['addressLine']), oFontDetN, 600, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "BAIRRO: "+iif(valtype(oRegistration['address']) == "U" .or. empty(oRegistration['address']['district']), "", oRegistration['address']['district']), oFontDetN, 300, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "CIDADE: "+iif(valtype(oRegistration['address']) == "U" .or. empty(oRegistration['address']['city']), "", oRegistration['address']['city']), oFontDetN, 250, nTamLin, COR_PRETO, PAD_LEFT, 0)

            oPrintPvt:SayAlign(nLinCab, nColDir + 120, "CEP: "+iif(valtype(oRegistration['address']) == "U" .or. empty(oRegistration['address']['zipCode']), "", oRegistration['address']['zipCode']), oFontDetN, 150, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "HOME PAGE: "+iif(valtype(oRegistration['companyUrl']) == "U" .or. empty(oRegistration['companyUrl']), "", oRegistration['companyUrl']), oFontDetN, 500, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "FUNDACAO: "+iif(valtype(oRegistration['companyFoundation']) == "U" .or. empty(oRegistration['companyFoundation']), "  /  /    ", DtoC(StoD(StrTran(oRegistration['companyFoundation'], "-", "")))), oFontDetN, 250, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "QTDE FILIAIS: "+iif(valtype(oRegistration['numberBranches']) == "U" .or. empty(oRegistration['numberBranches']), "", oRegistration['numberBranches']), oFontDetN, 250, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "RAMO: "+iif(valtype(oRegistration['economicActivity']) == "U" .or. empty(oRegistration['economicActivity']), "", oRegistration['economicActivity']), oFontDetN, 350, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "QTDE EMPREGADOS: "+iif(valtype(oRegistration['numberEmployees']) == "U" .or. empty(oRegistration['numberEmployees']),'0',cValToChar(oRegistration['numberEmployees'])), oFontDetN, 250, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "OPCAO TRIBUTARIA: "+iif(valtype(oRegistration['taxOption']) == "U" .or. empty(oRegistration['taxOption']),'',cValToChar(oRegistration['taxOption'])), oFontDetN, 350, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "DATA RISKSCORING AUTO:", oFontDetN, 300, nTamLin, COR_PRETO, PAD_LEFT, 0)

            oPrintPvt:SayAlign(nLinCab, nColDir, "CODIGO RISKSCORING AUTO:", oFontDetN, 300, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "MSG RISKSCORING AUTO:", oFontDetN, 400, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "MENSAGEM LIMITE PJ:", oFontDetN, 400, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "MSG RISKSCORING PFNAD:", oFontDetN, 400, nTamLin, COR_PRETO, PAD_LEFT, 0)
            nScore := iif(valtype(oJsonSer['optionalFeatures']['score']['score']) == "U" .or. empty(oJsonSer['optionalFeatures']['score']['score']),0,oJsonSer['optionalFeatures']['score']['score'])
            oPrintPvt:SayAlign(nLinCab, nColDir + 120, "SCORE: " + alltrim(cValToChar(nScore)), oFontDetN, 120, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "DATA RISKSCORING PFNAD:", oFontDetN, 350, nTamLin, COR_PRETO, PAD_LEFT, 0)

            oPrintPvt:SayAlign(nLinCab, nColDir, "HORA RISKSCORING PFNAD:", oFontDetN, 300, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += nTamLin

            oPrintPvt:SayAlign(nLinCab, nColEsq, "FRASE ALERTA: "+iif(valtype(oJsonSer['optionalFeatures']['score']['message']) == "U" .or. empty(oJsonSer['optionalFeatures']['score']['message']),'',oJsonSer['optionalFeatures']['score']['message']), oFontDetN, 700, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinCab += (nTamLin * 2)

            oPrintPvt:Line(nLinCab, nColIni, nLinCab, nColFin, COR_CINZA)                  
            
        endif
    endif

    nLinAtu := nLinCab + 3
Return
 
/*---------------------------------------------------------------------*
 | Func:  fImpRod                                                      |
 | Desc:  Função que imprime o rodapé                                  |
 *---------------------------------------------------------------------*/
 
Static Function fImpRod()
    Local nLinRod   := nLinFin + nTamLin
    Local cEndRod := ''
    Local cPag := ''
    Local cEmail := 'pmz@pmz.com.br
 
    //Linha Separatória
    oPrintPvt:Line(nLinRod, nColIni, nLinRod, nColFin, COR_CINZA)
    nLinRod += 3
     
    //Dados da Esquerda e Direita
    // cEndRodEsq := dToC(dDataGer) + "    " + cHoraGer + "    " + FunName() + "    " + cNomeUsr
    cEndRod := 'RUA PALMEIRA DO MIRITI - DISTRITO INDUSTRIAS - MANAUS - AM'
    cPag := "Página " + cValToChar(nPagAtu)
     
    //Imprimindo os textos
    oPrintPvt:SayAlign(nLinRod, nColMeio - 120, cEndRod, oFontRod, 250, 05, COR_CINZA, PAD_CENTER,  0)
    nLinRod += nTamLin
    oPrintPvt:SayAlign(nLinRod, nColMeio - 120, cEmail, oFontRod, 250, 05, COR_CINZA, PAD_CENTER,  0)
    oPrintPvt:SayAlign(nLinRod, nColFin-40, cPag,   oFontRod, 040, 05, COR_CINZA, PAD_RIGHT, 0)
     
    //Finalizando a página e somando mais um
    oPrintPvt:EndPage()
    nPagAtu++
Return


/*/{Protheus.doc} ImpRCom()
    (long_description)
    @type  Static Function
    @author user
    @since 17/03/2026
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ImpRCom()
    Local cCaminho    := ""
    Local cArquivo    := ""
    // Local cQryAux     := ""
    // Local nAtual      := 0
    // Local nTotal      := 0
    Local nx          := 0
    Local nY          := 0
    Local nz          := 0
    Private cTp_Rel   := 'COMPLETO' // ou 'BASICO'
    // Private cTp_Cli   := 'PF' // ou 'PJ'
    //Linhas e colunas
    Private nLinAtu   := 000
    Private nTamLin   := 010
    Private nLinFin   := 810
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
    Private oFontSay  := TFont():New(cNomeFont, 9, -08, .T., .F., 5, .T., 5, .T., .F.)
    Private oFontTit  := TFont():New(cNomeFont, 9, -13, .T., .T., 5, .T., 5, .T., .F.)
    
    //Definindo o diretório como a temporária do S.O. e o nome do arquivo com a data e hora (sem dois pontos)
    cCaminho  := 'C:\Temp\'
    cArquivo  := "PMZRSE01_" + dToS(dDataGer) + "_" + StrTran(cHoraGer, ':', '-')
    
     if !ExistDir(cCaminho)
        MakeDir(cCaminho)
    endif
    
    oPrintPvt := FWMSPrinter():New(cArquivo, IMP_PDF, .F., cCaminho,.T.,, @oPrintPvt, "", , , , .T.)
     
    //Setando os atributos necessários do relatório
    oPrintPvt:SetResolution(72)
    oPrintPvt:SetPortrait()
    oPrintPvt:SetPaperSize(DMPAPER_A4)
    oPrintPvt:SetMargin(60, 60, 60, 60)

     //Imprime o cabeçalho
    fImpCab()
    ***
        if cTP_Cli =='PF'
            dadosPF()
        else
            dadosPJ()
        endif
    ***
    fImpRod()
    //Mostrando o relatório
    oPrintPvt:Setup()
    
    if oPrintPvt:cPathPDF =='c:\'
        oPrintPvt:cPathPDF := cCaminho
        oPrintPvt:Preview()
    else
        cCaminho := oPrintPvt:cPathPDF
        oPrintPvt:Preview()
    endif
    
    cArq := cCaminho + cArquivo + '.pdf'
    If File(cArq)
    //Tenta abrir o arquivo e pegar o conteudo
        oFile := FwFileReader():New(cArq)
        If oFile:Open()
             //Se deu certo abrir o arquivo, pega o conteudo e transforma em base 64
            cConteudo  := oFile:FullRead()
            cString64  := Encode64(cConteudo, , .F., .F.)
        EndIf

        Reclock('SA1', .F.)
            SA1->A1_PDFCOM := cString64
        SA1->(MSUNLOCK())
        oFile:Close()
    EndIf

Return

/*/{Protheus.doc} dadsoPJ
    (long_description)
    @type  Static Function
    @author user
    @since 08/06/2026
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function dadosPJ()

Local nX := 0
Local nY := 0
    //=================================================================
    // CONTROLE SOCIETARIO
    //=================================================================

    // nLinAtu += (nTamLin * 2)

    // oPrintPvt:Line(nLinAtu, nColIni, nLinAtu, nColFin, COR_CINZA)

    nLinAtu += 5

    oPrintPvt:SayAlign( nLinAtu, nColMeio - 250, "CONTROLE SOCIETARIO (ATUALIZADO EM 14/09/2023) (VALORES EM REAIS)", oFontDetN, 500, nTamLin, COR_PRETO, PAD_CENTER, 0 )
    nLinAtu += (nTamLin * 2)
    oCompanyData := oJsonSer['optionalFeatures']['QSAReport']['companyData']
    // Linha 1
    oPrintPvt:SayAlign( nLinAtu, nColIni + 50, "CAPITAL SOCIAL: R$ " + iif(empty(oCompanyData['socialCapitalValue']), "0,00", alltrim(transform(oCompanyData['socialCapitalValue'] , "@E 999,999,999,999.99"))), oFontDetN, 250, nTamLin, COR_PRETO, PAD_LEFT, 0 )
    oPrintPvt:SayAlign( nLinAtu, nColMeio + 20, "REALIZADO:     R$ " + iif(empty(oCompanyData['accomplishedValue']), "0,00", alltrim(transform(oCompanyData['accomplishedValue'] , "@E 999,999,999,999.99"))), oFontDetN, 250, nTamLin, COR_PRETO, PAD_LEFT, 0 )
    nLinAtu += nTamLin

    // Linha 2
    oPrintPvt:SayAlign( nLinAtu, nColIni + 60,  "ORIGEM:   "+iif(empty(oCompanyData['countryOrigin']), "", oCompanyData['countryOrigin']), oFontDetN, 180, nTamLin, COR_PRETO, PAD_LEFT, 0 )
    oPrintPvt:SayAlign( nLinAtu, nColMeio + 20, "CONTROLE: "+iif(empty(oCompanyData['controlType']), "", oCompanyData['controlType']), oFontDetN, 200, nTamLin, COR_PRETO, PAD_LEFT, 0 )
    oPrintPvt:SayAlign( nLinAtu, nColFin - 120, "NATUREZA: "+iif(empty(oCompanyData['nature']), "", oCompanyData['nature']), oFontDetN, 200, nTamLin, COR_PRETO, PAD_LEFT, 0 )
    nLinAtu += (nTamLin * 2)

    oPrintPvt:Line(nLinAtu, nColIni, nLinAtu, nColFin, COR_CINZA)

    nLinAtu += 5

    //=================================================================
    //  % CAPITAL
    //=================================================================

    oPrintPvt:SayAlign(nLinAtu,nColMeio - 150,"% CAPITAL",oFontDetN,300,nTamLin,COR_PRETO,PAD_CENTER,0 )

    nLinAtu += (nTamLin * 2)

    // Cabeçalho
    oPrintPvt:SayAlign(nLinAtu,nColIni+10 ,"CPF / CNPJ",oFontDetN,80,nTamLin,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColIni+90 ,"SOCIO / ACIONISTA / DIRETOR",oFontDetN,180,nTamLin,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColIni+300,"ENTRADA",oFontDetN,60,nTamLin,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColIni+380,"NACIONALIDADE",oFontDetN,80,nTamLin,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColIni+470,"VOLANTE",oFontDetN,50,nTamLin,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColIni+530,"TOTAL",oFontDetN,50,nTamLin,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColIni+590,"RESTRICAO",oFontDetN,60,nTamLin,COR_PRETO,PAD_LEFT,0)

    nLinAtu += nTamLin

    oPrintPvt:Line(nLinAtu,nColIni,nLinAtu,nColFin,COR_CINZA)

    nLinAtu += 5
   aSocioList := iif(valtype(oJsonSer['optionalFeatures']['QSAReport']['partnerCompleteReport']['partnersList']) == "U" .or. empty(oJsonSer['optionalFeatures']['QSAReport']['partnerCompleteReport']['partnersList']), {}, oJsonSer['optionalFeatures']['QSAReport']['partnerCompleteReport']['partnersList'])

    nX := 0
    For nX := 1 To Len(aSocioList)

        // CPF/CNPJ
        oPrintPvt:SayAlign( nLinAtu, nColIni + 10,IIF(Empty(aSocioList[nX]['documentId']),"",aSocioList[nX]['documentId']),oFontDet,90,nTamLin,COR_PRETO,PAD_LEFT,0)
        // Nome do Sócio
        oPrintPvt:SayAlign( nLinAtu, nColIni + 90,IIF(Empty(aSocioList[nX]['name']),"",aSocioList[nX]['name']),oFontDet,220,nTamLin,COR_PRETO,PAD_LEFT,0)
        // Entrada
        oPrintPvt:SayAlign( nLinAtu, nColIni + 300,IIF(Empty(aSocioList[nX]['informationUpdateDate']),"  /  /    ",DtoC(StoD(StrTran(aSocioList[nX]['informationUpdateDate'],"-","")))),oFontDet,70, nTamLin, COR_PRETO, PAD_LEFT, 0 )
        // Nacionalidade
        oPrintPvt:SayAlign( nLinAtu, nColIni + 390,IIF(Empty(aSocioList[nX]['nationality']),"",aSocioList[nX]['nationality']),oFontDet,60,nTamLin,COR_PRETO,PAD_LEFT,0)
        // Capital Votante
        oPrintPvt:SayAlign( nLinAtu, nColIni + 490,IIF(Empty(aSocioList[nX]['capitalVoterValue']),"0%",AllTrim(Str(aSocioList[nX]['capitalVoterValue'])) + "%" ),oFontDet, 50, nTamLin, COR_PRETO, PAD_RIGHT, 0 )
        // Capital Total
        oPrintPvt:SayAlign( nLinAtu, nColIni + 550,IIF(Empty(aSocioList[nX]['capitalTotalValue']),"0%",AllTrim(Str(aSocioList[nX]['capitalTotalValue'])) + "%" ),oFontDet, 50, nTamLin, COR_PRETO, PAD_RIGHT, 0 )
        // Restrição
        oPrintPvt:SayAlign( nLinAtu, nColIni + 610,IIF(aSocioList[nX]['restrictionSign'],"SIM", "NAO" ),oFontDet, 40, nTamLin, COR_PRETO, PAD_LEFT, 0 )
        nLinAtu += nTamLin

        If nLinAtu + nTamLin > (nLinFin - 20)
            fImpRod()
            oPrintPvt:StartPage()
            nLinAtu := 0
        EndIf
    Next nx

    nLinAtu += (nTamLin * 2)

    //=================================================================
    //  ADMINITRATIVO
    //=================================================================
    nLinAtu += 5
    
    nLinAtu += (nTamLin * 2)
     If nLinAtu + nTamLin > (nLinFin - 20)
        fImpRod()
        oPrintPvt:StartPage()
        nLinAtu := 0
    EndIf

    oPrintPvt:SayAlign(nLinAtu,nColMeio - 180,"ADMINISTRATIVO (ATUALIZADO EM )",oFontDetN,360,nTamLin,COR_PRETO,PAD_CENTER,0 )
    nLinAtu += nTamLin

    // Cabeçalho
    oPrintPvt:SayAlign(nLinAtu,nColIni+10 ,"CPF / CNPJ",oFontDetN,80,nTamLin,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColIni+70 ,"ADMINISTRACAO",oFontDetN,160,nTamLin,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColIni+190,"CARGO",oFontDetN,80,nTamLin,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColIni+260,"NACIONALIDADE",oFontDetN,80,nTamLin,COR_PRETO,PAD_LEFT,0)
    // oPrintPvt:SayAlign(nLinAtu,nColIni+430,"ESTADO CIVIL",oFontDetN,80,nTamLin,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColIni+340,"ENTRADA",oFontDetN,60,nTamLin,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColIni+400,"MANDATO",oFontDetN,60,nTamLin,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColIni+460,"RESTRICAO",oFontDetN,60,nTamLin,COR_PRETO,PAD_LEFT,0)

    nLinAtu += nTamLin

    oPrintPvt:Line(nLinAtu,nColIni,nLinAtu,nColFin,COR_CINZA)

    nLinAtu += 5

    // Registro
   aDirList := iif(valtype(oJsonSer['optionalFeatures']['QSAReport']['directorCompleteReport']['directorsList']) == "U" .or. empty(oJsonSer['optionalFeatures']['QSAReport']['directorCompleteReport']['directorsList']), {}, oJsonSer['optionalFeatures']['QSAReport']['directorCompleteReport']['directorsList'])

    nX := 0
    For nX := 1 To Len(aDirList)

        oPrintPvt:SayAlign(nLinAtu,nColIni+10,IIF(Empty(aDirList[nX]['documentId']),"",aDirList[nX]['documentId']),oFontDet,90,nTamLin,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColIni+70,IIF(Empty(aDirList[nX]['name']),"",aDirList[nX]['name']),oFontDet,220,nTamLin,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColIni+190,IIF(Empty(aDirList[nX]['role']),"",aDirList[nX]['role']),oFontDet,70,nTamLin,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColIni+260,IIF(Empty(aDirList[nX]['nationality']),"",aDirList[nX]['nationality']),oFontDet,70,nTamLin,COR_PRETO,PAD_LEFT,0)
        // oPrintPvt:SayAlign(nLinAtu,nColIni+460,"",oFontDet,60,nTamLin,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColIni+340,IIF(Empty(aDirList[nX]['informationUpdateDate']),"  /  /    ",DtoC(StoD(StrTran(aDirList[nX]['informationUpdateDate'],'-','')))),oFontDet,70,nTamLin,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColIni+400,"",oFontDet,50,nTamLin,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColIni+460,IIF(Empty(aDirList[nX]['restrictionSign']),"",IIF(aDirList[nX]['restrictionSign'],"SIM","NAO")),oFontDet,40,nTamLin,COR_PRETO,PAD_LEFT,0)
        nLinAtu += nTamLin

        If nLinAtu + nTamLin > (nLinFin - 20)
            fImpRod()
            oPrintPvt:StartPage()
            nLinAtu := 0
        EndIf
    Next nX

    //=========================================================
    // PARTICIPACOES
    //=========================================================

    nLinAtu += (nTamLin * 2)

    If nLinAtu + nTamLin > (nLinFin - 20)
        fImpRod()
        oPrintPvt:StartPage()
        nLinAtu := 0
    EndIf
    oPrintPvt:Line(nLinAtu, nColIni, nLinAtu, nColFin, COR_CINZA)

    nLinAtu += 5

    oPrintPvt:SayAlign(nLinAtu,nColMeio - 200,"PARTICIPACOES (ATUALIZADO EM 31/12/1969)",oFontDetN,400,nTamLin,COR_PRETO,PAD_CENTER,0 )

    nLinAtu += (nTamLin * 2)

    // Cabeçalho
    oPrintPvt:SayAlign(nLinAtu, nColIni + 10 , "CPF / CNPJ"        , oFontDetN,  80, nTamLin, COR_PRETO, PAD_LEFT , 0)
    oPrintPvt:SayAlign(nLinAtu, nColIni + 90 , "NOME DO PARTICIPANTE", oFontDetN, 220, nTamLin, COR_PRETO, PAD_LEFT , 0)
    oPrintPvt:SayAlign(nLinAtu, nColIni + 380, "VINCULO"           , oFontDetN,  80, nTamLin, COR_PRETO, PAD_LEFT , 0)
    oPrintPvt:SayAlign(nLinAtu, nColFin - 80 , "% CAPITAL"         , oFontDetN,  60, nTamLin, COR_PRETO, PAD_RIGHT, 0)

    nLinAtu += nTamLin

    oPrintPvt:Line(nLinAtu, nColIni, nLinAtu, nColFin, COR_CINZA)

    nLinAtu += 5

    aPartEmp := IIF( valtype(oJsonSer['optionalFeatures']['companyParticipationsReport']['participateds']) == "U" .or. empty(oJsonSer['optionalFeatures']['companyParticipationsReport']['participateds']), {}, oJsonSer['optionalFeatures']['companyParticipationsReport']['participateds'])
    nX := 1
    For nX := 1 To Len(aPartEmp)
        aPartPes := IIF( valtype(aPartEmp[nX]['participants']) == "U" .or. empty(aPartEmp[nX]['participants']), {}, aPartEmp[nX]['participants'])
        // Empresa participada
        oPrintPvt:SayAlign(nLinAtu,nColIni+10,IIF(valtype(aPartEmp[nX]['participatedDocumentId']) == "U" .or. empty(aPartEmp[nX]['participatedDocumentId']),"",aPartEmp[nX]['participatedDocumentId']),oFontDet,120,nTamLin,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColIni+90,IIF(valtype(aPartEmp[nX]['participatedName']) == "U" .or. empty(aPartEmp[nX]['participatedName']),"",aPartEmp[nX]['participatedName']),oFontDet,250,nTamLin,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColIni+380,IIF(valtype(aPartEmp[nX]['squareCompany']) == "U" .or. empty(aPartEmp[nX]['squareCompany']),"",aPartEmp[nX]['squareCompany']),oFontDet,50,nTamLin,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColFin-80,IIF(valType(aPartEmp[nX]['resume'])<>'J' .AND. valtype(aPartEmp[nX]['resume']['participationPercentageCapitalTotal']) == "U" .or. empty(aPartEmp[nX]['resume']['participationPercentageCapitalTotal']),"",cValToChar(aPartEmp[nX]['resume']['participationPercentageCapitalTotal'])+"%"),oFontDet,50,nTamLin,COR_PRETO,PAD_RIGHT,0)
        nLinAtu += nTamLin

        // Participantes da empresa
        nY := 1
        For nY := 1 To Len(aPartPes)

            oPrintPvt:SayAlign(nLinAtu,nColIni+20,IIF(valtype(aPartPes[nY]['documentId']) == "U" .or. empty(aPartPes[nY]['documentId']),"",aPartPes[nY]['documentId']),oFontDet,110,nTamLin,COR_PRETO,PAD_LEFT,0)
            oPrintPvt:SayAlign(nLinAtu,nColIni+110,IIF(valtype(aPartPes[nY]['participantName']) == "U" .or. empty(aPartPes[nY]['participantName']),"",aPartPes[nY]['participantName']),oFontDet,220,nTamLin,COR_PRETO,PAD_LEFT,0)
            oPrintPvt:SayAlign(nLinAtu,nColIni+380,IIF(valtype(aPartPes[nY]['participationType']) == "U" .or. empty(aPartPes[nY]['participationType']),"",aPartPes[nY]['participationType']),oFontDet,80,nTamLin,COR_PRETO,PAD_LEFT,0)
            oPrintPvt:SayAlign(nLinAtu,nColFin-80,IIF(valtype(aPartPes[nY]['participationPercentageCapital']) == "U" .or. empty(aPartPes[nY]['participationPercentageCapital']),"",cValToChar(aPartPes[nY]['participationPercentageCapital'])+"%"),oFontDet,60,nTamLin,COR_PRETO,PAD_RIGHT,0)
            nLinAtu += nTamLin

            If nLinAtu + nTamLin > (nLinFin - 20)
                fImpRod()
                oPrintPvt:StartPage()
                nLinAtu := 0
            EndIf

        Next nY
    Next nX
    nLinAtu += (nTamLin * 2)

    //=========================================================
    // FINAL DO BLOCO
    //=========================================================

    nColAtual := 0
    nLargCol  := 45

    oPrintPvt:Line(nLinAtu,nColIni,nLinAtu,nColFin,COR_CINZA)
   
    //=========================================================
    // REGISTRO DE CONSULTAS
    //=========================================================

    // Título
     If nLinAtu + nTamLin > (nLinFin - 20)
        fImpRod()
        oPrintPvt:StartPage()
        nLinAtu := 0
    EndIf

    oPrintPvt:SayAlign( nLinAtu + 5, nColMeio - 100, "REGISTRO DE CONSULTAS", oFontDetN, 200, nTamLin, COR_PRETO, PAD_CENTER, 0 )

    nLinAtu += (nTamLin * 3)

    nColAtual := nColIni

    //=========================================================
    // CABEÇALHO DOS MESES
    //=========================================================

    oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + (nTamLin * 4), nColFin, '-4' )

    // OUT/2024
    oPrintPvt:SayAlign(nLinAtu+3,nColAtual,"OUT/2024",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    // NOV/2024
    oPrintPvt:Line(nLinAtu,nColAtual,nLinAtu+(nTamLin*4),nColAtual,COR_PRETO)
    oPrintPvt:SayAlign(nLinAtu+3,nColAtual,"NOV/2024",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    // DEZ/2024
    oPrintPvt:Line(nLinAtu,nColAtual,nLinAtu+(nTamLin*4),nColAtual,COR_PRETO)
    oPrintPvt:SayAlign(nLinAtu+3,nColAtual,"DEZ/2024",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    // JAN/2025
    oPrintPvt:Line(nLinAtu,nColAtual,nLinAtu+(nTamLin*4),nColAtual,COR_PRETO)
    oPrintPvt:SayAlign(nLinAtu+3,nColAtual,"JAN/2025",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    // FEV/2025
    oPrintPvt:Line(nLinAtu,nColAtual,nLinAtu+(nTamLin*4),nColAtual,COR_PRETO)
    oPrintPvt:SayAlign(nLinAtu+3,nColAtual,"FEV/2025",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    // MAR/2025
    oPrintPvt:Line(nLinAtu,nColAtual,nLinAtu+(nTamLin*4),nColAtual,COR_PRETO)
    oPrintPvt:SayAlign(nLinAtu+3,nColAtual,"MAR/2025",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol


    // ABR/2025
    oPrintPvt:Line(nLinAtu,nColAtual,nLinAtu+(nTamLin*4),nColAtual,COR_PRETO)
    oPrintPvt:SayAlign(nLinAtu+3,nColAtual,"ABR/2025",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    // MAI/2025
    oPrintPvt:Line(nLinAtu,nColAtual,nLinAtu+(nTamLin*4),nColAtual,COR_PRETO)
    oPrintPvt:SayAlign(nLinAtu+3,nColAtual,"MAI/2025",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    // JUN/2025
    oPrintPvt:Line(nLinAtu,nColAtual,nLinAtu+(nTamLin*4),nColAtual,COR_PRETO)
    oPrintPvt:SayAlign(nLinAtu+3,nColAtual,"JUN/2025",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    // JUL/2025
    oPrintPvt:Line(nLinAtu,nColAtual,nLinAtu+(nTamLin*4),nColAtual,COR_PRETO)
    oPrintPvt:SayAlign(nLinAtu+3,nColAtual,"JUL/2025",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    // AGO/2025
    oPrintPvt:Line(nLinAtu,nColAtual,nLinAtu+(nTamLin*4),nColAtual,COR_PRETO)
    oPrintPvt:SayAlign(nLinAtu+3,nColAtual,"AGO/2025",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    // SET/2025
    oPrintPvt:Line(nLinAtu,nColAtual,nLinAtu+(nTamLin*4),nColAtual,COR_PRETO)
    oPrintPvt:SayAlign(nLinAtu+3,nColAtual,"SET/2025",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    // // OUT/2025
    // oPrintPvt:Line(nLinAtu,nColAtual,nLinAtu+(nTamLin*4),nColAtual,COR_PRETO)
    // oPrintPvt:SayAlign(nLinAtu+3,nColAtual,"OUT/2025",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)

    // Linha divisória horizontal
    oPrintPvt:Line(nLinAtu+nTamLin+5,nColIni,nLinAtu+nTamLin+5,nColFin,COR_PRETO)

    //=========================================================
    // QUANTIDADES
    //=========================================================

    nColAtual := nColIni

    oPrintPvt:SayAlign(nLinAtu+nTamLin+8,nColAtual,"0",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    oPrintPvt:SayAlign(nLinAtu+nTamLin+8,nColAtual,"0",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    oPrintPvt:SayAlign(nLinAtu+nTamLin+8,nColAtual,"0",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    oPrintPvt:SayAlign(nLinAtu+nTamLin+8,nColAtual,"0",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    oPrintPvt:SayAlign(nLinAtu+nTamLin+8,nColAtual,"0",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    oPrintPvt:SayAlign(nLinAtu+nTamLin+8,nColAtual,"0",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    oPrintPvt:SayAlign(nLinAtu+nTamLin+8,nColAtual,"0",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    oPrintPvt:SayAlign(nLinAtu+nTamLin+8,nColAtual,"0",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    oPrintPvt:SayAlign(nLinAtu+nTamLin+8,nColAtual,"0",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    oPrintPvt:SayAlign(nLinAtu+nTamLin+8,nColAtual,"0",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    oPrintPvt:SayAlign(nLinAtu+nTamLin+8,nColAtual,"0",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)
    nColAtual += nLargCol

    oPrintPvt:SayAlign(nLinAtu+nTamLin+8,nColAtual,"0",oFontDetN,nLargCol,nTamLin,COR_PRETO,PAD_CENTER,0)

    nLinAtu += 50

    //=========================================================
    // DADOS
    //=========================================================

    aConsultas := {}
    nX         := 0
    nLinDet    := 0

    //=========================================================
    // AJUSTE DAS COLUNAS
    //=========================================================

    // DATA MENOR
    nColData    := nColIni
    // CNPJ MENOR
    nColCnpj    := nColData + 80
    // CLIENTE MAIOR
    nColCliente := nColCnpj + 80
    // QTDE FIXA NO FINAL
    nColQtde    := nColFin - 120

    nAltLinha := 15

    //=========================================================
    // EXEMPLO
    //=========================================================

    aConsultas := iiF(valtype(oJsonSer["reports"][1]["facts"]["inquiryCompanyResponse"]["results"]) == "U" .or. empty(oJsonSer["reports"][1]["facts"]["inquiryCompanyResponse"]["results"]), {}, oJsonSer["reports"][1]["facts"]["inquiryCompanyResponse"]["results"])

    //=========================================================
    // TÍTULO DA SEÇÃO
    //=========================================================

    oPrintPvt:Box(nLinAtu,nColIni,nLinAtu + 15,nColFin,"-4" )

     If nLinAtu + nTamLin > (nLinFin - 20)
        fImpRod()
        oPrintPvt:StartPage()
        nLinAtu := 0
    EndIf

    oPrintPvt:SayAlign(nLinAtu + 4,nColIni,"CINCO ULTIMAS CONSULTAS",oFontDetN,nColFin - nColIni,10,COR_PRETO,PAD_CENTER,0 )

    nLinAtu += 15

    //=========================================================
    // CABEÇALHO
    //=========================================================

    oPrintPvt:Box(nLinAtu,nColIni,nLinAtu + 20,nColFin,"-4" )

    //=========================================================
    // LINHAS VERTICAIS
    //=========================================================

    oPrintPvt:Line(nLinAtu,nColCnpj,nLinAtu + 20,nColCnpj,COR_PRETO )

    oPrintPvt:Line(nLinAtu,nColCliente,nLinAtu + 20,nColCliente,COR_PRETO )

    oPrintPvt:Line(nLinAtu,nColQtde,nLinAtu + 20,nColQtde,COR_PRETO )

    //=========================================================
    // TITULOS
    //=========================================================

    oPrintPvt:SayAlign(nLinAtu + 5,nColData,"DATA",oFontDetN,80,10,COR_PRETO,PAD_CENTER,0 )

    oPrintPvt:SayAlign(nLinAtu + 5,nColCnpj,"CNPJ",oFontDetN,80,10,COR_PRETO,PAD_CENTER,0 )

    oPrintPvt:SayAlign(nLinAtu + 5,nColCliente,"CLIENTE CONSULTANTE",oFontDetN,nColQtde - nColCliente,10,COR_PRETO,PAD_CENTER,0 )

    oPrintPvt:SayAlign(nLinAtu + 5,nColQtde,"QTDE CONSULTAS NO DIA",oFontDetN,120,10,COR_PRETO,PAD_CENTER,0 )

    nLinAtu += 20

    //=========================================================
    // DETALHES
    //=========================================================

    For nX := 1 To Len(aConsultas)
        nLinDet := nLinAtu + ((nX-1) * nAltLinha)
        oPrintPvt:Box(nLinDet,nColIni,nLinDet + nAltLinha,nColFin,"-4")

        oPrintPvt:Line(nLinDet,nColCnpj,nLinDet + nAltLinha,nColCnpj,COR_PRETO)
        oPrintPvt:Line(nLinDet,nColCliente,nLinDet + nAltLinha,nColCliente,COR_PRETO)
        oPrintPvt:Line(nLinDet,nColQtde,nLinDet + nAltLinha,nColQtde,COR_PRETO)

        // DATA CONSULTA
        oPrintPvt:SayAlign( nLinDet + 3, nColData, IIF( Empty(aConsultas[nX]["occurrenceDate"]), "  /  /    ", DtoC(StoD(StrTran(aConsultas[nX]["occurrenceDate"],"-",""))) ), oFontDet,80,10,COR_PRETO,PAD_CENTER,0 )

        // CNPJ CONSULTANTE
        oPrintPvt:SayAlign( nLinDet + 3, nColCnpj, IIF( Empty(aConsultas[nX]["companyDocumentId"]), "", aConsultas[nX]["companyDocumentId"] ), oFontDet,80,10,COR_PRETO,PAD_CENTER,0 )

        // CLIENTE CONSULTANTE
        oPrintPvt:SayAlign( nLinDet + 3, nColCliente + 3, PadR( Left( IIF( Empty(aConsultas[nX]["companyName"]), "", aConsultas[nX]["companyName"] ), 55), 55), oFontDet,270,10,COR_PRETO,PAD_LEFT,0 )

        // QTDE CONSULTAS NO DIA
        oPrintPvt:SayAlign( nLinDet + 3, nColQtde, IIF( Empty(aConsultas[nX]["daysQuantity"]), "", cValToChar(aConsultas[nX]["daysQuantity"]) ), oFontDetN,120,10,COR_PRETO,PAD_CENTER,0 )

        If nLinDet + nTamLin > (nLinFin - 20)
            fImpRod()
            oPrintPvt:StartPage()
            nLinAtu := 0
        EndIf
    Next 

    nLinAtu := nLinDet + nAltLinha + 10

    //=========================================================
    // TITULOS
    //=========================================================

     If nLinAtu + nTamLin > (nLinFin - 20)
        fImpRod()
        oPrintPvt:StartPage()
        nLinAtu := 0
    EndIf

    oPrintPvt:SayAlign(nLinAtu,nColIni,"PENDENCIAS FINANCEIRAS",oFontDetN,nColFin-nColIni,10,COR_PRETO,PAD_CENTER,0 )

    nLinAtu += 15

    oPrintPvt:SayAlign(nLinAtu,nColIni,"PEFIN (OCORRENCIAS MAIS RECENTES - ATE 5)",oFontDetN,nColFin-nColIni,10,COR_PRETO,PAD_CENTER,0 )

    nLinAtu += 15

    //=========================================================
    // COLUNAS
    //=========================================================

    nColData   := nColIni + 10
    nColModal  := nColData + 70
    nColAval   := nColModal + 120
    nColValor  := nColAval + 70
    nColCont   := nColValor + 90
    nColOrigem := nColCont + 110

    //=========================================================
    // CABEÇALHO
    //=========================================================

    oPrintPvt:SayAlign( nLinAtu, nColData,  "DATA",      oFontDetN , 80, 10, COR_PRETO, PAD_LEFT, 0 )
    oPrintPvt:SayAlign( nLinAtu, nColModal, "MODALIDADE",oFontDetN , 80, 10, COR_PRETO, PAD_LEFT, 0 )
    oPrintPvt:SayAlign( nLinAtu, nColAval,  "AVALISTA",  oFontDetN , 80, 10, COR_PRETO, PAD_LEFT, 0 )
    oPrintPvt:SayAlign( nLinAtu, nColValor, "VALOR",     oFontDetN , 80, 10, COR_PRETO, PAD_LEFT, 0 )
    oPrintPvt:SayAlign( nLinAtu, nColCont,  "CONTRATO",  oFontDetN , 80, 10, COR_PRETO, PAD_LEFT, 0 )
    oPrintPvt:SayAlign( nLinAtu, nColOrigem,"ORIGEM",    oFontDetN , 80, 10, COR_PRETO, PAD_LEFT, 0 )


    nLinAtu += 10

    aPefinPj := iif(Empty(oJsonSer['reports'][1]['negativeData']['pefin']['pefinResponse']), {}, oJsonSer['reports'][1]['negativeData']['pefin']['pefinResponse'])

    nTotPefPJ := 0

    For nX := 1 To Len(aPefinPj)

        oPrintPvt:SayAlign( nLinAtu, nColData, IIF(Empty(aPefinPj[nX]['occurrenceDate']),"",DtoC(StoD(StrTran(aPefinPj[nX]['occurrenceDate'],'-','')))), oFontDet,80,10,COR_PRETO,PAD_LEFT,0 )
        oPrintPvt:SayAlign( nLinAtu, nColModal, IIF(Empty(aPefinPj[nX]['legalNature']),"",Left(aPefinPj[nX]['legalNature'],15)), oFontDet,80,10,COR_PRETO,PAD_LEFT,0 )
        oPrintPvt:SayAlign( nLinAtu, nColAval, IIF(Empty(aPefinPj[nX]['principal']),"Nao",aPefinPj[nX]['principal']), oFontDet,80,10,COR_PRETO,PAD_LEFT,0 )
        oPrintPvt:SayAlign( nLinAtu, nColValor, "R$ " + IIF(Empty(aPefinPj[nX]['amount']),"0,00",Transform(aPefinPj[nX]['amount'],"@E 999,999,999.99")), oFontDet,80,10,COR_PRETO,PAD_LEFT,0 )
        oPrintPvt:SayAlign( nLinAtu, nColCont, IIF(Empty(aPefinPj[nX]['contractId']),"",aPefinPj[nX]['contractId']), oFontDet,80,10,COR_PRETO,PAD_LEFT,0 )

        // oPrintPvt:SayAlign( nLinAtu, nColOrigem, ;
        //     IIF(Empty(aPefinPj[nX]['creditorName']),"",;
        //         Left(aPefinPj[nX]['creditorName'],30)), ;
        //     oFontDet,80,10,COR_PRETO,PAD_LEFT,0 )

        nTotPefPJ += IIF(Empty(aPefinPj[nX]['amount']),0,aPefinPj[nX]['amount'])
        nLinAtu += 10

    Next

    //=========================================================
    // TOTAIS
    //=========================================================

    oPrintPvt:SayAlign(nLinAtu,nColData,"TOTAL DE OCORRENCIAS: " + cValToChar(Len(aPefinPj)),oFontDetN ,250,10,COR_PRETO,PAD_LEFT,0)

    nLinAtu += 10

    oPrintPvt:SayAlign(nLinAtu,nColData + 60,"TOTAL: R$ " + Transform(nTotPefPJ,"@E 999,999,999.99"),oFontDetN,250,10,COR_PRETO,PAD_LEFT,0 )

    //=========================================================
    // REFIN (OCORRENCIAS MAIS RECENTES - ATE 5)
    //=========================================================

    nLinAtu += 15

     If nLinAtu + nTamLin > (nLinFin - 20)
        fImpRod()
        oPrintPvt:StartPage()
        nLinAtu := 0
    EndIf
    oPrintPvt:SayAlign(nLinAtu,nColIni,"REFIN (OCORRENCIAS MAIS RECENTES - ATE 5)",oFontDetN,nColFin - nColIni,10,COR_PRETO,PAD_CENTER,0 )

    nLinAtu += 15

    //=========================================================
    // COLUNAS
    //=========================================================

    nColData   := nColIni + 10
    nColModal  := nColData + 70
    nColAval   := nColModal + 120
    nColValor  := nColAval + 70
    nColCont   := nColValor + 90
    nColOrigem := nColCont + 110

    //=========================================================
    // CABEÇALHO
    //=========================================================

    oPrintPvt:SayAlign( nLinAtu, nColData,   "DATA",       oFontDetN, 80, 10, COR_PRETO, PAD_LEFT, 0 )
    oPrintPvt:SayAlign( nLinAtu, nColModal,  "MODALIDADE", oFontDetN, 80, 10, COR_PRETO, PAD_LEFT, 0 )
    oPrintPvt:SayAlign( nLinAtu, nColAval,   "AVALISTA",   oFontDetN, 80, 10, COR_PRETO, PAD_LEFT, 0 )
    oPrintPvt:SayAlign( nLinAtu, nColValor,  "VALOR",      oFontDetN, 80, 10, COR_PRETO, PAD_LEFT, 0 )
    oPrintPvt:SayAlign( nLinAtu, nColCont,   "CONTRATO",   oFontDetN, 80, 10, COR_PRETO, PAD_LEFT, 0 )
    oPrintPvt:SayAlign( nLinAtu, nColOrigem, "ORIGEM",     oFontDetN, 80, 10, COR_PRETO, PAD_LEFT, 0 )

    nLinAtu += 10

    //=========================================================
    // DADOS
    //=========================================================

    aRefinPJ := IIF(Empty(oJsonSer['reports'][1]['negativeData']['refin']['refinResponse']),{},oJsonSer['reports'][1]['negativeData']['refin']['refinResponse'] )

    nTotal := 0
    nX := 0
    For nX := 1 To Len(aRefinPJ)

        oPrintPvt:SayAlign( nLinAtu, nColData, IIF( Empty(aRefinPJ[nX]['occurrenceDate']), "", DtoC(StoD(StrTran(aRefinPJ[nX]['occurrenceDate'],'-',''))) ), oFontDet,80,10,COR_PRETO,PAD_LEFT,0 )
        oPrintPvt:SayAlign( nLinAtu, nColModal, IIF( Empty(aRefinPJ[nX]['legalNature']), "", Left(aRefinPJ[nX]['legalNature'],15) ), oFontDet,80,10,COR_PRETO,PAD_LEFT,0 )
        oPrintPvt:SayAlign( nLinAtu, nColAval, IIF( Empty(aRefinPJ[nX]['guarantor']), "Nao", aRefinPJ[nX]['guarantor'] ), oFontDet,80,10,COR_PRETO,PAD_LEFT,0 )
        oPrintPvt:SayAlign( nLinAtu, nColValor, "R$ " + IIF( Empty(aRefinPJ[nX]['amount']), "0,00", Transform(aRefinPJ[nX]['amount'],"@E 999,999,999.99") ), oFontDet,80,10,COR_PRETO,PAD_LEFT,0 )
        oPrintPvt:SayAlign( nLinAtu, nColCont, IIF( Empty(aRefinPJ[nX]['contractId']), "", aRefinPJ[nX]['contractId'] ), oFontDet,80,10,COR_PRETO,PAD_LEFT,0 )

        // oPrintPvt:SayAlign( nLinAtu, nColOrigem, ;
        //     IIF( Empty(aRefinPJ[nX]['creditorName']), "", ;
        //         Left(aRefinPJ[nX]['creditorName'],30) ), ;
        //     oFontDet,80,10,COR_PRETO,PAD_LEFT,0 )

        nTotal += IIF( Empty(aRefinPJ[nX]['amount']), 0, aRefinPJ[nX]['amount'] )

        nLinAtu += 10

        If nLinAtu + nTamLin > (nLinFin - 20)
            fImpRod()
            oPrintPvt:StartPage()
            nLinAtu := 0
        EndIf
    next NX

    //=========================================================
    // TOTALIZADOR
    //=========================================================

    oPrintPvt:SayAlign(nLinAtu,nColData,"TOTAL DE OCORRENCIAS: " + cValToChar(Len(aRefinPJ)),oFontDetN ,250,10,COR_PRETO,PAD_LEFT,0)
    nLinAtu += 10

    oPrintPvt:SayAlign(nLinAtu,nColData + 60,"TOTAL: R$ " + Transform(nTotal,"@E 999,999,999.99"),oFontDetN,250,10,COR_PRETO,PAD_LEFT,0 )
    nLinAtu += 15

    //=========================================================
    // INFORMACOES DO CONCENTRE - ACAO JUDICIAL
    //=========================================================

    nLinAtu += 20

    If nLinAtu + nTamLin > (nLinFin - 20)
        fImpRod()
        oPrintPvt:StartPage()
        nLinAtu := 0
    EndIf

    oPrintPvt:SayAlign(nLinAtu,nColIni,"INFORMACOES DO CONCENTRE - ACAO JUDICIAL",oFontDetN,nColFin-nColIni,10,COR_PRETO,PAD_CENTER,0 )

    nLinAtu += 15

    nColData   := nColIni + 10
    nColNat    := nColIni + 140
    nColValor  := nColIni + 280
    nColCidade := nColIni + 460

    oPrintPvt:SayAlign(nLinAtu,nColData,"DATA ACAO JUDICIAL",oFontDetN,120,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColNat,"NATUREZA",oFontDetN,120,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColValor,"VALOR",oFontDetN,80,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColCidade,"CIDADE / UF",oFontDetN,100,10,COR_PRETO,PAD_LEFT,0)

    nLinAtu += 10

    aAcao := IIF(Empty(oJsonSer["reports"][1]["facts"]["judgementFilings"]["judgementFilingsResponse"]),{},oJsonSer["reports"][1]["facts"]["judgementFilings"]["judgementFilingsResponse"] )
    nTotAcao := 0
    For nX := 1 To Len(aAcao)

        oPrintPvt:SayAlign(nLinAtu,nColData,IIF( Empty(aAcao[nX]['occurrenceDate']), "",DtoC(StoD(StrTran(aAcao[nX]['occurrenceDate'],'-',''))) ),oFontDet,120,10,COR_PRETO,PAD_LEFT,0 )
        oPrintPvt:SayAlign(nLinAtu,nColNat,IIF( Empty(aAcao[nX]['legalNature']), "",Left(aAcao[nX]['legalNature'],25) ),oFontDet,180,10,COR_PRETO,PAD_LEFT,0 )
        oPrintPvt:SayAlign(nLinAtu,nColValor,"R$ " +IIF( Empty(aAcao[nX]['amount']),"0,00",Transform(aAcao[nX]['amount'],"@E 999,999,999.99") ),oFontDet,80,10,COR_PRETO,PAD_LEFT,0 )
        oPrintPvt:SayAlign(nLinAtu,nColCidade,IIF( Empty(aAcao[nX]['city']), "", aAcao[nX]['city'] ) +" / " +IIF( Empty(aAcao[nX]['state']), "", aAcao[nX]['state'] ),oFontDet,120,10,COR_PRETO,PAD_LEFT,0 )
        nLinAtu += 10

        If nLinAtu + nTamLin > (nLinFin - 20)
            fImpRod()
            oPrintPvt:StartPage()
            nLinAtu := 0
        EndIf
        nTotAcao += IIF( Empty(aAcao[nX]['amount']), 0, aAcao[nX]['amount'] )
    Next
    oPrintPvt:SayAlign(nLinAtu,nColIni+10,"TOTAL DE OCORRENCIAS: "+AllTrim(Str(Len(aAcao))),oFontDetN,200,10,COR_PRETO,PAD_LEFT,0)

    nLinAtu += 10

    oPrintPvt:SayAlign(nLinAtu,nColIni+80,"TOTAL: R$ "+Transform(nTotAcao,"@E 999,999,999.99"),oFontDetN,200,10,COR_PRETO,PAD_LEFT,0)

    //=========================================================
    // INFORMACOES DO CONCENTRE PROTESTOS
    //=========================================================

    nLinAtu += 20

    oPrintPvt:SayAlign(nLinAtu,nColIni,"INFORMACOES DO CONCENTRE PROTESTOS (OCORRENCIAS MAIS RECENTES - ATE 5)",oFontDetN,nColFin-nColIni,10,COR_PRETO,PAD_CENTER,0 )

    nLinAtu += 15

    nColData   := nColIni + 40
    nColValor  := nColIni + 190
    nColCidade := nColIni + 360

    oPrintPvt:SayAlign(nLinAtu,nColData,"DATA DO PROTESTO",oFontDetN,120,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColValor,"VALOR CARTORIO",oFontDetN,120,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColCidade,"CIDADE / UF",oFontDetN,120,10,COR_PRETO,PAD_LEFT,0)

    nLinAtu += 10

    aProt := IIF(valtype(oJsonSer['reports'][1]['negativeData']['notary']['notaryResponse']) == "U" .or.Empty(oJsonSer['reports'][1]['negativeData']['notary']['notaryResponse']),{},oJsonSer['reports'][1]['negativeData']['notary']['notaryResponse'] )

    nTotal := 0

    For nX := 1 To Len(aProt)

        // DATA
        oPrintPvt:SayAlign( nLinAtu, nColData, IIF(valtype(aProt[nX]['occurrenceDate']) == "U" .or. Empty(aProt[nX]['occurrenceDate']), "", DtoC(StoD(StrTran(aProt[nX]['occurrenceDate'],'-',''))) ), oFontDet,120,10,COR_PRETO,PAD_LEFT,0 )
        // VALOR
        oPrintPvt:SayAlign( nLinAtu, nColValor, "R$ " + IIF( valtype(aProt[nX]['amount']) == "U" .or. Empty(aProt[nX]['amount']), "0,00", Transform(aProt[nX]['amount'],"@E 999,999,999.99") ), oFontDet,120,10,COR_PRETO,PAD_LEFT,0 )
        // CIDADE / UF
        oPrintPvt:SayAlign( nLinAtu, nColCidade, IIF( valtype(aProt[nX]['city']) == "U" .or. Empty(aProt[nX]['city']), "", aProt[nX]['city'] ) + " / " + IIF( valtype(aProt[nX]['federalUnit']) == "U" .or. Empty(aProt[nX]['federalUnit']), "", aProt[nX]['federalUnit'] ), oFontDet,180,10,COR_PRETO,PAD_LEFT,0 )
        nTotal += IIF( valtype(aProt[nX]['amount']) == "U" .or. Empty(aProt[nX]['amount']), 0, aProt[nX]['amount'] )

        nLinAtu += 10

        If nLinAtu + nTamLin > (nLinFin - 20)
            fImpRod()
            oPrintPvt:StartPage()
            nLinAtu := 0
        EndIf

    Next
    oPrintPvt:SayAlign(nLinAtu,nColIni+10,"TOTAL DE OCORRENCIAS: "+AllTrim(Str(Len(aProt))),oFontDetN,200,10,COR_PRETO,PAD_LEFT,0)

    nLinAtu += 10

    oPrintPvt:SayAlign(nLinAtu,nColIni+80,"TOTAL: R$ "+Transform(nTotal,"@E 999,999,999.99"),oFontDetN,250,10,COR_PRETO,PAD_LEFT,0 )

    //=========================================================
    // PARTICIPACAO EM FALENCIA
    //=========================================================

    nLinAtu += 30

    oPrintPvt:SayAlign(nLinAtu,nColIni,"INFORMACOES DO CONCENTRE - PARTICIPACAO EM FALENCIA",oFontDetN,nColFin-nColIni,10,COR_PRETO,PAD_CENTER,0 )

    nLinAtu += 15

    nColData   := nColIni + 40
    nColTipo   := nColIni + 190
    nColCidade := nColIni + 360

    oPrintPvt:SayAlign(nLinAtu,nColData,"DATA",oFontDetN,80,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColTipo,"TIPO",oFontDetN,150,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColCidade,"CIDADE / UF",oFontDetN,120,10,COR_PRETO,PAD_LEFT,0)

    nLinAtu += 10

    aFal := {}

    aAdd(aFal,{"","",""})

    For nX := 1 To Len(aFal)

        oPrintPvt:SayAlign(nLinAtu,nColData,aFal[nX][1],oFontDet,80,10,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColTipo,aFal[nX][2],oFontDet,180,10,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColCidade,aFal[nX][3],oFontDet,120,10,COR_PRETO,PAD_LEFT,0)

        nLinAtu += 10

    Next

    oPrintPvt:SayAlign(nLinAtu,nColIni+10,"TOTAL DE OCORRENCIAS: "+AllTrim(Str(Len(aFal))),oFontDetN,200,10,COR_PRETO,PAD_LEFT,0 )

    nLinAtu += 15


    //=========================================================
    // INFORMACOES DO CONCENTRE - DIVIDAS VENCIDAS
    //=========================================================

    nLinAtu += 20

    oPrintPvt:SayAlign(nLinAtu,nColIni,"INFORMACOES DO CONCENTRE - DIVIDAS VENCIDAS",oFontDetN,nColFin - nColIni,10,COR_PRETO,PAD_CENTER,0 )

    nLinAtu += 15

    nColData   := nColIni + 10
    nColModal  := nColIni + 90
    nColValor  := nColIni + 230
    nColInst   := nColIni + 350

    // Cabeçalho

    oPrintPvt:SayAlign(nLinAtu,nColData ,"DATA",oFontDetN,80,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColModal,"MODALIDADE",oFontDetN,150,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColValor,"VALOR",oFontDetN,80,10,COR_PRETO,PAD_RIGHT,0)
    oPrintPvt:SayAlign(nLinAtu,nColInst ,"INSTITUICAO FINANCEIRA",oFontDetN,200,10,COR_PRETO,PAD_LEFT,0)

    nLinAtu += 10

    aDividas := {}

    aAdd(aDividas,{"","",0,""})

    nTotal := 0

    For nX := 1 To Len(aDividas)

        oPrintPvt:SayAlign(nLinAtu,nColData,aDividas[nX][1],oFontDet,80,10,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColModal,Left(aDividas[nX][2],35),oFontDet,220,10,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColValor,"R$ "+Transform(aDividas[nX][3],"@E 999,999,999.99"),oFontDet,100,10,COR_PRETO,PAD_RIGHT,0)
        oPrintPvt:SayAlign(nLinAtu,nColInst,Left(aDividas[nX][4],40),oFontDet,220,10,COR_PRETO,PAD_LEFT,0)

        nTotal += aDividas[nX][3]

        nLinAtu += 10

        If nLinAtu + nTamLin > (nLinFin-20) 
            fImpRod()
            //Iniciando Página
            oPrintPvt:StartPage()
            nLinAtu := 0
        EndIf

    Next

    oPrintPvt:SayAlign(nLinAtu,nColIni + 10,"TOTAL DE OCORRENCIAS: "+AllTrim(Str(Len(aDividas))),oFontDetN,200,10,COR_PRETO,PAD_LEFT,0 )

    nLinAtu += 10

    oPrintPvt:SayAlign(nLinAtu,nColIni + 70,"TOTAL: R$ "+Transform(nTotal,"@E 999,999,999.99"),oFontDetN,250,10,COR_PRETO,PAD_LEFT,0 )

    //=========================================================
    // INFORMACOES DE PARTICIPANTES COM ANOTACOES
    //=========================================================

    nLinAtu += 25

    oPrintPvt:SayAlign(nLinAtu,nColIni,"INFORMACOES DE PARTICIPANTES COM ANOTACOES",oFontDetN,nColFin - nColIni,10,COR_PRETO,PAD_CENTER,0 )

    nLinAtu += 15

    nColNome := nColIni + 20
    nColDoc  := nColIni + 200
    nColTipo := nColIni + 300

    // Cabeçalho

    oPrintPvt:SayAlign(nLinAtu,nColNome,"NOME",oFontDetN,250,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColDoc ,"DOCUMENTO",oFontDetN,120,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColTipo,"TIPO",oFontDetN,60,10,COR_PRETO,PAD_LEFT,0)

    nLinAtu += 10

    aPart := {}

    aAdd(aPart,{"","",""})


    For nX := 1 To Len(aPart)

        oPrintPvt:SayAlign(nLinAtu,nColNome,Left(aPart[nX][1],75),oFontDet,520,10,COR_PRETO,PAD_LEFT,0 )
        oPrintPvt:SayAlign(nLinAtu,nColDoc,aPart[nX][2],oFontDet,120,10,COR_PRETO,PAD_LEFT,0 )
        oPrintPvt:SayAlign(nLinAtu,nColTipo,aPart[nX][3],oFontDet,50,10,COR_PRETO,PAD_LEFT,0 )

        nLinAtu += 10

        If nLinAtu + nTamLin > (nLinFin-20) .and. nX < len(aPart)
            fImpRod()
            //Iniciando Página
            oPrintPvt:StartPage()
            nLinAtu := 0
        EndIf

    Next
    nLinAtu += 15

Return 

Static Function dadosPF()

Local nx := 0

    //=========================================================
    // INFORMACOES DE ENDERECOS
    //=========================================================

    nLinAtu += 20

    oPrintPvt:SayAlign( nLinAtu, nColIni, "ENDERECO", oFontDetN, nColFin-nColIni, 10, COR_PRETO, PAD_CENTER, 0 )

    nLinAtu += 15

    nColTipo    := nColIni + 10
    nColEnd     := nColIni + 70
    nColNumero  := nColIni + 280
    nColBairro  := nColIni + 340
    nColCidade  := nColIni + 460

    oPrintPvt:SayAlign(nLinAtu,nColTipo,"TIPO",oFontDetN,80,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColEnd,"ENDERECO",oFontDetN,200,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColNumero,"NUMERO",oFontDetN,60,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColBairro,"BAIRRO",oFontDetN,120,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColCidade,"CIDADE",oFontDetN,100,10,COR_PRETO,PAD_LEFT,0)

    nLinAtu += 10

    aEnd := oJsonSer['optionalFeatures']['registration']['addresses']

    For nX := 1 To Len(aEnd)

        oPrintPvt:SayAlign(nLinAtu,nColTipo,aEnd[nX,'addressTypeDescription'],oFontDet,100,10,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColEnd,Left(aEnd[nX,'addressLine'],45),oFontDet,200,10,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColNumero,aEnd[nX,'addressNumber'],oFontDet,60,10,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColBairro,Left(aEnd[nX,'district'],20),oFontDet,120,10,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColCidade,Left(aEnd[nX,'city'],20),oFontDet,120,10,COR_PRETO,PAD_LEFT,0)

        nLinAtu += 10
    Next

    //=========================================================
    // TELEFONES
    //=========================================================

    nLinAtu += 15

    oPrintPvt:SayAlign( nLinAtu, nColIni, "TELEFONES", oFontDetN, nColFin-nColIni, 10, COR_PRETO, PAD_CENTER, 0 )

    nLinAtu += 15

    nColTipo := nColIni + 10
    nColDDD  := nColIni + 120
    nColFone := nColIni + 280
    nColDtAt := nColIni + 400

    oPrintPvt:SayAlign(nLinAtu,nColTipo,"TIPO",oFontDetN,80,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColDDD,"DDD",oFontDetN,40,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColFone,"NUMERO",oFontDetN,80,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColDtAt,"DATA ATUALIZACAO",oFontDetN,120,10,COR_PRETO,PAD_LEFT,0)

    nLinAtu += 10

    aFone := oJsonSer['optionalFeatures']['registration']['phones']

    For nX := 1 To Len(aFone)

        oPrintPvt:SayAlign(nLinAtu,nColTipo,aFone[nX,'phoneType'],oFontDet,150,10,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColDDD,cValToChar(aFone[nX,'areaCode']),oFontDet,40,10,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColFone,cValToChar(aFone[nX,'phoneNumber']),oFontDet,100,10,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColDtAt,aFone[nX,'updateDate'],oFontDet,100,10,COR_PRETO,PAD_LEFT,0)

        nLinAtu += 10
    Next

    //=========================================================
    // PENDENCIAS FINANCEIRAS (PEFIN)
    //=========================================================

    nLinAtu += 20

    oPrintPvt:SayAlign( nLinAtu, nColIni, "PENDENCIAS FINANCEIRAS (PEFIN)", oFontDetN, nColFin - nColIni, 10, COR_PRETO, PAD_CENTER, 0 )

    nLinAtu += 15

    //=========================================================
    // COLUNAS
    //=========================================================

    nColData   := nColIni + 10
    nColModal  := nColIni + 100
    nColCredor := nColIni + 190
    nColValor  := nColIni + 290
    nColContr  := nColIni + 460

    oPrintPvt:SayAlign(nLinAtu,nColData ,"DATA",oFontDetN,80,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColModal,"MODALIDADE",oFontDetN,120,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColCredor,"CREDOR",oFontDetN,120,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColValor,"VALOR",oFontDetN,100,10,COR_PRETO,PAD_RIGHT,0)
    oPrintPvt:SayAlign(nLinAtu,nColContr,"CONTRATO",oFontDetN,120,10,COR_PRETO,PAD_LEFT,0)

    nLinAtu += 10

    //=========================================================
    // DADOS
    //=========================================================

    aPefin := oJsonSer['optionalFeatures']['negativeData']['pefin']['pefinResponse']

    nQtdPefin := Len(aPefin)
    nTotalPefin := 0
    cPrimeiraPefin := ""
    cUltimaPefin   := ""

    For nX := 1 To Len(aPefin)

        oPrintPvt:SayAlign(nLinAtu,nColData,aPefin[nX,'occurrenceDate'],oFontDet,80,10,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColModal,Left(aPefin[nX,'legalNature'],20),oFontDet,140,10,COR_PRETO,PAD_LEFT,0 )
        oPrintPvt:SayAlign(nLinAtu,nColCredor,Left(aPefin[nX,'creditorName'],30),oFontDet,180,10,COR_PRETO,PAD_LEFT,0 )
        oPrintPvt:SayAlign(nLinAtu,nColValor,"R$ " + cValToChar(aPefin[nX,'amount']),oFontDet,120,10,COR_PRETO,PAD_RIGHT,0 )
        oPrintPvt:SayAlign(nLinAtu,nColContr,aPefin[nX,'contractId'],oFontDet,120,10,COR_PRETO,PAD_LEFT,0 )

        nTotalPefin += aPefin[nX]['amount']

        If Empty(cPrimeiraPefin)
            cPrimeiraPefin := aPefin[nX]['occurrenceDate']
        EndIf

        cUltimaPefin := aPefin[nX]['occurrenceDate']

        nLinAtu += 10

        If nLinAtu + nTamLin > (nLinFin - 20)
            fImpRod()
            fImpCab()
        EndIf

    Next

    //=========================================================
    // RESUMO PEFIN
    //=========================================================

    nLinAtu += 10

    oPrintPvt:SayAlign( nLinAtu, nColIni + 20, "Resumo PEFIN:", oFontDetN, 120, 10, COR_PRETO, PAD_LEFT, 0 )
    nLinAtu += 10
    oPrintPvt:SayAlign( nLinAtu, nColIni + 20, "Quantidade: " + AllTrim(Str(nQtdPefin)), oFontDet, 150, 10, COR_PRETO, PAD_LEFT, 0 )
    nLinAtu += 10
    oPrintPvt:SayAlign( nLinAtu, nColIni + 20, "Saldo Total: R$ " + Transform(nTotalPefin,"@E 999,999,999.99"), oFontDet, 250, 10, COR_PRETO, PAD_LEFT, 0 )
    nLinAtu += 10
    oPrintPvt:SayAlign( nLinAtu, nColIni + 20, "Primeira Ocorrencia: " + cPrimeiraPefin, oFontDet, 250, 10, COR_PRETO, PAD_LEFT, 0 )
    nLinAtu += 10
    oPrintPvt:SayAlign( nLinAtu, nColIni + 20, "Ultima Ocorrencia: " + cUltimaPefin, oFontDet, 250, 10, COR_PRETO, PAD_LEFT, 0 )
    nLinAtu += 20

    //=========================================================
    // PENDENCIAS FINANCEIRAS (REFIN)
    //=========================================================

    nLinAtu += 20

    oPrintPvt:SayAlign( nLinAtu, nColIni, "PENDENCIAS FINANCEIRAS (REFIN)", oFontDetN, nColFin-nColIni, 10, COR_PRETO, PAD_CENTER, 0 )

    nLinAtu += 15

    //=========================================================
    // COLUNAS
    //=========================================================

    nColData    := nColIni + 10
    nColNat     := nColIni + 70
    nColCont    := nColIni + 140
    nColCredor  := nColIni + 260
    nColValor   := nColIni + 320
    nColAval    := nColIni + 450
    nColCadus   := nColIni + 500

    oPrintPvt:SayAlign(nLinAtu,nColData ,"DT. OCOR.",oFontDetN,120,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColNat  ,"NATUREZA",oFontDetN,100,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColCont ,"CONTRATO",oFontDetN,100,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColCredor,"CREDOR",oFontDetN,100,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColValor,"VALOR",oFontDetN,80,10,COR_PRETO,PAD_RIGHT,0)
    oPrintPvt:SayAlign(nLinAtu,nColAval ,"AVALISTA",oFontDetN,70,10,COR_PRETO,PAD_LEFT,0)
    oPrintPvt:SayAlign(nLinAtu,nColCadus,"CADUS",oFontDetN,80,10,COR_PRETO,PAD_LEFT,0)

    nLinAtu += 10

    //=========================================================
    // DADOS
    //=========================================================

    aRefin := oJsonSer['optionalFeatures']['negativeData']['refin']['refinResponse']

    nQtdRefin := Len(aRefin)
    nTotalRefin := 0

    cPrimeiraRefin := ""
    cUltimaRefin   := ""

    For nX := 1 To Len(aRefin)

        oPrintPvt:SayAlign(nLinAtu,nColData,aRefin[nX,'occurrenceDate'],oFontDet,120,10,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColNat,Left(aRefin[nX,'legalNature'],15),oFontDet,120,10,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColCont,Left(aRefin[nX,'contractId'],22),oFontDet,150,10,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColCredor,Left(aRefin[nX,'creditorName'],18),oFontDet,150,10,COR_PRETO,PAD_LEFT,0)
        oPrintPvt:SayAlign(nLinAtu,nColValor,"R$ "+cValToChar(aRefin[nX,'amount']),oFontDet,120,10,COR_PRETO,PAD_RIGHT,0 )
        oPrintPvt:SayAlign(nLinAtu,nColAval,iif(aRefin[nX,'principal'],"Sim","Nao"),oFontDet,30,10,COR_PRETO,PAD_RIGHT,0)
        oPrintPvt:SayAlign(nLinAtu,nColCadus,aRefin[nX]['cadus'],oFontDet,100,10,COR_PRETO,PAD_LEFT,0)

        nTotalRefin += aRefin[nX]['amount']

        If Empty(cPrimeiraRefin)
            cPrimeiraRefin := aRefin[nX]['occurrenceDate']
        EndIf

        cUltimaRefin := aRefin[nX]['occurrenceDate']

        nLinAtu += 10

    Next

    //=========================================================
    // RESUMO REFIN
    //=========================================================

    nLinAtu += 10
    oPrintPvt:SayAlign(nLinAtu,nColIni+20,"Resumo REFIN:",oFontDetN, 120, 10, COR_PRETO, PAD_LEFT, 0)
    nLinAtu += 10
    oPrintPvt:SayAlign(nLinAtu,nColIni+20,"Quantidade: "+AllTrim(Str(nQtdRefin)),oFontDet, 150, 10, COR_PRETO, PAD_LEFT, 0)
    nLinAtu += 10
    oPrintPvt:SayAlign( nLinAtu, nColIni+20, "Saldo Total: R$ "+Transform(nTotalRefin,"@E 999,999,999.99"), oFontDet, 250, 10, COR_PRETO, PAD_LEFT, 0 )
    nLinAtu += 10
    oPrintPvt:SayAlign( nLinAtu, nColIni+20, "Primeira Ocorrencia: "+cPrimeiraRefin, oFontDet, 250, 10, COR_PRETO, PAD_LEFT, 0 )
    nLinAtu += 10
    oPrintPvt:SayAlign( nLinAtu, nColIni+20, "Ultima Ocorrencia: "+cUltimaRefin, oFontDet, 250, 10, COR_PRETO, PAD_LEFT, 0 )

    nLinAtu += 20
Return

static Function QuebraPag()
    If nLinAtu + nTamLin > (nLinFin - 20)
        fImpRod()
        oPrintPvt:StartPage()
        nLinAtu := 0
    EndIf
Return
