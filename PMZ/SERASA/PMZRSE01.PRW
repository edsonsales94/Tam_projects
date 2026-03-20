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
	local lAMb      := RpcSetEnv('01','01AM031')

	//Se a pergunta for confirmada
	If MsgYesNo("Deseja gerar o relatório de grupos de produtos?", "Atenção")
		Processa({|| ImpRBas()}, "Processando...")
	else
		Processa({|| ImpRCom()}, "Processando...")
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
    cCaminho  := GetTempPath()
    cArquivo  := "PMZRSE01_" + dToS(dDataGer) + "_" + StrTran(cHoraGer, ':', '-')
     
    //Criando o objeto do FMSPrinter
    oPrintPvt := FWMSPrinter():New(cArquivo, IMP_PDF, .F., "", .T., , @oPrintPvt, "", , , , .T.)
     
    //Setando os atributos necessários do relatório
    oPrintPvt:SetResolution(72)
    oPrintPvt:SetPortrait()
    oPrintPvt:SetPaperSize(DMPAPER_A4)
    oPrintPvt:SetMargin(60, 60, 60, 60)
     
    //Imprime o cabeçalho
    fImpCab()
    ***
    /* inicio bloco PEFIN*/   

    for nY := 1 to 3
        nLinAtu += nTamLin
        cTitBox := 'PEFIN
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

        if nY == 1
            oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, 'DADOS NEGATIVOS - '+cTitBox, oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)
        elseif nY == 2
            if cTipo == 'PF'
                oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, 'DADOS POSITIVOS - '+cTitBox, oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)
            endif
        else
            if cTipo == 'PF'
                cTitBox := 'PROTESTO'
                oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, cTitBox, oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)
                cTitCol2 := 'Cartorio'
                cTitCol3 := 'Cidade'
                cTitCol4 := 'UF'
            else
                oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, 'RESUMO DE DIVIDAS VENCIDAS - (CONVEM)', oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)
            endif
        endif

        nLinAtu += (nTamLin * 2)
        oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
        oPrintPvt:Line(nLinAtu, 90,  nLinAtu + 20, 90, COR_PRETO)
        oPrintPvt:Line(nLinAtu, 170, nLinAtu + 20, 170, COR_PRETO)
        oPrintPvt:Line(nLinAtu, 260, nLinAtu + 20, 260, COR_PRETO)
        cTipo := 'PJ'
        if cTipo =='PF' // PESSOA FISICA
            oPrintPvt:Line(nLinAtu, 410, nLinAtu + 20, 410, COR_PRETO)
            oPrintPvt:Line(nLinAtu, 490, nLinAtu + 20, 490, COR_PRETO)
        Else
            oPrintPvt:Line(nLinAtu, 490, nLinAtu + 20, 490, COR_PRETO)
        endif

        oPrintPvt:SayAlign(nLinAtu, nColIni,     cTitCol1  , oFontTit, 80, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+90,  cTitCol2  , oFontTit, 50, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+170, cTitCol3  , oFontTit, 60, 20, COR_PRETO, PAD_CENTER, 0)

        if cTipo =='PF' // PESSOA FISICA
            oPrintPvt:SayAlign(nLinAtu, nColIni+260, cTitCol4  , oFontTit, 125, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+410, cTitCol5  , oFontTit, 50, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+490, cTitCol6  , oFontTit, 50, 20, COR_PRETO, PAD_CENTER, 0)
        else
            oPrintPvt:SayAlign(nLinAtu, nColIni+260, cTitCol4  , oFontTit, 180, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+490, cTitCol5  , oFontTit, 40, 20, COR_PRETO, PAD_CENTER, 0)
        endif

        aDados := {}

        aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445566223355','Res Var SA','R$ 12.515.251,00', 'NAO'})
        aAdd(aDados,{'01/01/2025','OUTRAS OPER.','556622448789','Res Var SA','R$ 12.515.251,00', 'NAO'})
        aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
        aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
        // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})
            // aAdd(aDados,{'01/01/2025','OUTRAS OPER.','445897663344','Res Var SA','R$ 12.515.251,00', 'NAO'})

        nCont     := 0
        nVlrTotal := 0

        for nx := 1 to len(aDados)
            
            nLinAtu += (nTamLin * 2)

            If nLinAtu + nTamLin > nLinFin
                
                fImpRod()
                fImpCab()

                oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
                oPrintPvt:Line(nLinAtu, 90,  nLinAtu + 20, 90, COR_PRETO)
                oPrintPvt:Line(nLinAtu, 170, nLinAtu + 20, 170, COR_PRETO)
                oPrintPvt:Line(nLinAtu, 260, nLinAtu + 20, 260, COR_PRETO)

                if cTipo =='PF'
                    oPrintPvt:Line(nLinAtu, 410, nLinAtu + 20, 410, COR_PRETO)
                    oPrintPvt:Line(nLinAtu, 490, nLinAtu + 20, 490, COR_PRETO)
                Else
                    oPrintPvt:Line(nLinAtu, 490, nLinAtu + 20, 490, COR_PRETO)
                endif

                oPrintPvt:SayAlign(nLinAtu, nColIni,     cTitCol1  , oFontTit, 80, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+90,  cTitCol2  , oFontTit, 50, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+170, cTitCol3  , oFontTit, 60, 20, COR_PRETO, PAD_CENTER, 0)
                
                if cTipo =='PF' // PESSOA FISICA
                    oPrintPvt:SayAlign(nLinAtu, nColIni+260, cTitCol4  , oFontTit, 125, 20, COR_PRETO, PAD_CENTER, 0)
                    oPrintPvt:SayAlign(nLinAtu, nColIni+410, cTitCol5  , oFontTit, 50, 20, COR_PRETO, PAD_CENTER, 0)
                    oPrintPvt:SayAlign(nLinAtu, nColIni+490, cTitCol6  , oFontTit, 50, 20, COR_PRETO, PAD_CENTER, 0)
                else
                    oPrintPvt:SayAlign(nLinAtu, nColIni+260, cTitCol4  , oFontTit, 180, 20, COR_PRETO, PAD_CENTER, 0)
                    oPrintPvt:SayAlign(nLinAtu, nColIni+490, cTitCol5  , oFontTit, 40, 20, COR_PRETO, PAD_CENTER, 0)
                endif
                nLinAtu += (nTamLin * 2)

            EndIf

            nCont++
            oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
            oPrintPvt:Line(nLinAtu, 90, nLinAtu + 20, 90, COR_PRETO)
            oPrintPvt:Line(nLinAtu, 170, nLinAtu + 20, 170, COR_PRETO)
            oPrintPvt:Line(nLinAtu, 260, nLinAtu + 20, 260, COR_PRETO)

            if cTipo =='PF' // PESSOA FISICA
                oPrintPvt:Line(nLinAtu, 410, nLinAtu + 20, 410, COR_PRETO)
                oPrintPvt:Line(nLinAtu, 490, nLinAtu + 20, 490, COR_PRETO)
            Else  // PESSOA JURIDICA
                oPrintPvt:Line(nLinAtu, 490, nLinAtu + 20, 490, COR_PRETO)
            endif

            oPrintPvt:SayAlign(nLinAtu, nColIni,    aDados[nx,1], oFontDet, 80, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+90, aDados[nx,2], oFontDet, 50, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+170,aDados[nx,3], oFontDet, 60, 20, COR_PRETO, PAD_CENTER, 0)
            
            if cTipo =='PF' // PESSOA FISICA
                oPrintPvt:SayAlign(nLinAtu, nColIni+260,aDados[nx,4], oFontDet, 125, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+410,aDados[nx,5], oFontDet, 70, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+490,aDados[nx,6], oFontDet, 40, 20, COR_PRETO, PAD_CENTER, 0)
            Else // PESSOA JURIDICA
                oPrintPvt:SayAlign(nLinAtu, nColIni+260,aDados[nx,4], oFontDet, 180, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+490,aDados[nx,5], oFontDet, 70, 20, COR_PRETO, PAD_CENTER, 0)
            EndIf

            nValor := Val(StrTran(StrTran(aDados[nx,5],".",""),",","."))
            nVlrTotal += nValor


        next nx

        // Resumo 
        // relatorio basico PF
        if cTipo == 'PF' //
            If nLinAtu + (nTamLin*4) > nLinFin
                fImpRod()
                fImpCab()
            EndIf
            
            nLinAtu += (nTamLin * 2)
            oPrintPvt:SayAlign(nLinAtu, nColIni,'Resumo: '+cTitBox, oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
            nLinAtu += nTamLin
            oPrintPvt:SayAlign(nLinAtu, nColIni,'Quantidade: '+cvaltochar(nCont), oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
            nLinAtu += nTamLin
            oPrintPvt:SayAlign(nLinAtu, nColIni,'Saldo Total: '+Transform(nVlrTotal,"@E 999,999,999,999.99"), oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
        else

            // relatorio basico PJ
            If nLinAtu + (nTamLin*6) > nLinFin
                fImpRod()
                fImpCab()
            EndIf

            nLinAtu += (nTamLin * 2)
            oPrintPvt:SayAlign(nLinAtu, nColIni,'Primeira Ocorrencia: 30/02/2026', oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
            nLinAtu += nTamLin
            oPrintPvt:SayAlign(nLinAtu, nColIni,'Ultima Ocorrencia: 01/02/2026', oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
            nLinAtu += nTamLin
            oPrintPvt:SayAlign(nLinAtu, nColIni,'Quantidade: '+Transform(100,"@E 999,999,999,999.99"), oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
            nLinAtu += nTamLin
            oPrintPvt:SayAlign(nLinAtu, nColIni,'Saldo Total: '+Transform(nVlrTotal,"@E 999,999,999,999.99"), oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
        endif
    next ny

    /* Fim bloco PEFIN*/  

   /* DOCUMENTO ROUBADOS */
    nLinAtu += (nTamLin * 2)
    If nLinAtu + (nTamLin*5) > nLinFin
        fImpRod()
        fImpCab()
    EndIf
    oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, 'DOCUMENTOS ROUBADOS', oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)
    nLinAtu += nTamLin
    oPrintPvt:SayAlign(nLinAtu, nColIni,     'Nenhum documento roubado encontrado'   , oFontDet, 300, 20, COR_PRETO, PAD_LEFT, 0)
    nLinAtu += (nTamLin * 2)
    oPrintPvt:SayAlign(nLinAtu, nColIni, 'Resumo de documentos Roubados', oFontDetN, 240, 20, COR_PRETO, PAD_LEFT, 0)
    nLinAtu += nTamLin
    oPrintPvt:SayAlign(nLinAtu, nColIni,     'Quantidade Total: 0'   , oFontDet, 300, 20, COR_PRETO, PAD_LEFT, 0)
    nLinAtu += (nTamLin * 2)
   /*FIM DOCUMENTO ROUBADOS */


    /* CONSULTAS REALIZADAS */

    if cTipo == 'PF' // PESSOA FISICA
        If nLinAtu + (nTamLin*3) > nLinFin
            fImpRod()
            fImpCab()
        EndIf

        oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, 'CONSULTAS REALIZADAS', oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)
        nLinAtu += (nTamLin * 2)
        oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
        oPrintPvt:Line(nLinAtu, 120, nLinAtu + 20, 120, COR_PRETO)
        oPrintPvt:Line(nLinAtu, 450, nLinAtu + 20, 450, COR_PRETO)
        
        oPrintPvt:SayAlign(nLinAtu, nColIni,     'Data Ocorrencia'  , oFontDetN, 100, 20, COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+120, 'Segmento'         , oFontDetN, 260, 20,  COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+490, 'Dias'             , oFontDetN, 20, 20,   COR_PRETO, PAD_CENTER, 0)
        
        nQtd := 0
        for nX := 1 to 5
            
            If nLinAtu + (nTamLin*2) > nLinFin
                fImpRod()
                fImpCab()
                oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
                oPrintPvt:Line(nLinAtu, 120, nLinAtu + 20, 120, COR_PRETO)
                oPrintPvt:Line(nLinAtu, 450, nLinAtu + 20, 450, COR_PRETO)
                
                oPrintPvt:SayAlign(nLinAtu, nColIni,     'Data Ocorrencia'  , oFontDetN, 100, 20, COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+120, 'Segmento'         , oFontDetN, 260, 20,  COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+490, 'Dias'             , oFontDetN, 10, 20,   COR_PRETO, PAD_CENTER, 0)
            EndIf

            nLinAtu += (nTamLin * 2)
            oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20,  nColFin, "-4")
            oPrintPvt:Line(nLinAtu, 120, nLinAtu + 20, 120, COR_PRETO)
            oPrintPvt:Line(nLinAtu, 450, nLinAtu + 20, 450, COR_PRETO)
    
            oPrintPvt:SayAlign(nLinAtu, nColIni,     '01/03/2026'   , oFontDet, 100, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+120, 'Factorig'     , oFontDet, 260, 20, COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+490, '1'            , oFontDet, 10, 20,  COR_PRETO, PAD_CENTER, 0)
            nQtd += 1
        next nX

        If nLinAtu + (nTamLin*5) > nLinFin
            fImpRod()
            fImpCab()
        EndIf

        nLinAtu += (nTamLin * 2)
        oPrintPvt:SayAlign(nLinAtu, nColIni,'Resumo de consuntas: ', oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
        nLinAtu += nTamLin
        oPrintPvt:SayAlign(nLinAtu, nColIni,'Quantidade Total: '+cvaltochar(nQtd), oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
        nLinAtu += nTamLin

        oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, 'HISTORICO DA CONSULTAS', oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)

        /* HISTORICOS DE CONSULTA */
        nLinAtu += (nTamLin * 2)
        oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
        oPrintPvt:Line(nLinAtu, 275, nLinAtu + 20, 275, COR_PRETO)

        oPrintPvt:SayAlign(nLinAtu, nColIni,     'Mes/Ano'      , oFontDetN, 275, 20,  COR_PRETO, PAD_CENTER, 0)
        oPrintPvt:SayAlign(nLinAtu, nColIni+275, 'Ocorrencia'   , oFontDetN, 275, 20,  COR_PRETO, PAD_CENTER, 0)
        
        For nz := 1 to 8
            nLinAtu += (nTamLin * 2)

            If nLinAtu + nTamLin > nLinFin
                fImpRod()
                fImpCab()

                oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
                oPrintPvt:Line(nLinAtu, 275, nLinAtu + 20, 275, COR_PRETO)

                oPrintPvt:SayAlign(nLinAtu, nColIni,     'Mes/Ano'      , oFontDetN, 275, 20,  COR_PRETO, PAD_CENTER, 0)
                oPrintPvt:SayAlign(nLinAtu, nColIni+275, 'Ocorrencia'   , oFontDetN, 275, 20,  COR_PRETO, PAD_CENTER, 0)
                nLinAtu += (nTamLin * 2)
            EndIf

            oPrintPvt:Box( nLinAtu, nColIni, nLinAtu + 20, nColFin, "-4")
            oPrintPvt:Line(nLinAtu, 275, nLinAtu + 20, 275, COR_PRETO)

            oPrintPvt:SayAlign(nLinAtu, nColIni,     '032026' , oFontDet, 275, 20,  COR_PRETO, PAD_CENTER, 0)
            oPrintPvt:SayAlign(nLinAtu, nColIni+275, '1'      , oFontDet, 275, 20,  COR_PRETO, PAD_CENTER, 0)
        next nz

    /* FIM CONSULTAS REALIZADAS É HISTORICOS DE CONSULTA */
    else // PESSOA JURIDICA
        nLinAtu += (nTamLin * 2)
        oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, 'RESUMO DE CHEQUE SEM FUNDO', oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)

        nLinAtu += (nTamLin * 2)
        oPrintPvt:SayAlign(nLinAtu, nColIni,'Primeira Ocorrencia: 30/02/2026', oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
        nLinAtu += nTamLin
        oPrintPvt:SayAlign(nLinAtu, nColIni,'Ultima Ocorrencia: 01/02/2026', oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
        nLinAtu += nTamLin
        oPrintPvt:SayAlign(nLinAtu, nColIni,'Quantidade: '+Transform(100,"@E 999,999,999,999.99"), oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
        nLinAtu += nTamLin
        oPrintPvt:SayAlign(nLinAtu, nColIni,'Saldo Total: '+Transform(nVlrTotal,"@E 999,999,999,999.99"), oFontDetN, 80, 20, COR_PRETO, PAD_LEFT, 0)
    endif

    //Mostrando o relatório
    oPrintPvt:Preview()
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
    cTitCab := "RELATORIO BASICO PF - v3"
    cSubTit := "DADOS CADASTRAIS"
    oPrintPvt:SayBitMap(nLinCab, nColIni, "\system\lgpmz.bmp", 70, 30)
    oPrintPvt:SayAlign(nLinCab, nColMeio - 120, cTitCab, oFontTit, 240, 20, COR_CINZA, PAD_CENTER, 0)
    oPrintPvt:SayAlign(nLinCab+30, nColMeio - 120, cSubTit, oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)
    oPrintPvt:SayAlign(nLinCab, nColFin - 200, 'Emissão 01/01/2026', oFontSay, 240, 20, COR_PRETO, PAD_CENTER, 0)
    oPrintPvt:SayAlign(nLinCab+10, nColFin - 200, 'Usuario/Horario: Edson - 11:23:01', oFontSay, 240, 20, COR_PRETO, PAD_CENTER, 0)
     
    //Linha Separatória
    nLinCab += (nTamLin * 5)
    oPrintPvt:Line(nLinCab, nColIni, nLinCab, nColFin, COR_CINZA)
    oPrintPvt:SayAlign(nLinCab, nColIni, "CPF:  00100200211",     oFontDetN, 0080, nTamLin, COR_PRETO, PAD_LEFT, 0)
    nLinCab += nTamLin
    oPrintPvt:SayAlign(nLinCab, nColIni, "Nome: Edson pedro da silva sales",     oFontDetN, 0080, nTamLin, COR_PRETO, PAD_LEFT, 0)
    nLinCab += nTamLin
    oPrintPvt:SayAlign(nLinCab, nColIni, "Genero: Masculino",     oFontDetN, 0080, nTamLin, COR_PRETO, PAD_LEFT, 0)
    nLinCab += nTamLin
    oPrintPvt:SayAlign(nLinCab, nColIni, "Data Nascimento: 29/06/1994",     oFontDetN, 0080, nTamLin, COR_PRETO, PAD_LEFT, 0)
    nLinCab += nTamLin
    oPrintPvt:SayAlign(nLinCab, nColIni, "Idade: 31",     oFontDetN, 0080, nTamLin, COR_PRETO, PAD_LEFT, 0)
    nLinCab += nTamLin
    oPrintPvt:SayAlign(nLinCab, nColIni, "Status: Positivo",     oFontDetN, 0080, nTamLin, COR_PRETO, PAD_LEFT, 0)
    nLinCab += nTamLin
    oPrintPvt:SayAlign(nLinCab, nColIni, "Data Status: 10/03/1994",     oFontDetN, 0080, nTamLin, COR_PRETO, PAD_LEFT, 0)

    nLinAtu := nLinCab + 3
    
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
    cCaminho  := GetTempPath()
    cArquivo  := "PMZRSE01_" + dToS(dDataGer) + "_" + StrTran(cHoraGer, ':', '-')
     
    //Criando o objeto do FMSPrinter
    oPrintPvt := FWMSPrinter():New(cArquivo, IMP_PDF, .F., "", .T., , @oPrintPvt, "", , , , .T.)
     
    //Setando os atributos necessários do relatório
    oPrintPvt:SetResolution(72)
    oPrintPvt:SetPortrait()
    oPrintPvt:SetPaperSize(DMPAPER_A4)
    oPrintPvt:SetMargin(60, 60, 60, 60)



Return
