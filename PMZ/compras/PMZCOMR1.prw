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

/*/{Protheus.doc} PMZCOMR1
Exemplos de FWMSPrinter
@author Edson Sales
@since 19/03/2026
@version 1.0
@type function
/*/

User Function PMZCOMR1()
	Local aArea := GetArea()
	local lAMb      := RpcSetEnv('01','01AM031')
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
    Private oFontSay  := TFont():New(cNomeFont, 9, -06, .T., .F., 5, .T., 5, .T., .F.)
    Private oFontSay2 := TFont():New(cNomeFont, 9, -08, .T., .F., 5, .T., 5, .T., .F.)
    Private oFontSayn := TFont():New(cNomeFont, 9, -08, .T., .T., 5, .T., 5, .T., .F.)
    Private oFontTit  := TFont():New(cNomeFont, 9, -13, .T., .T., 5, .T., 5, .T., .F.)
     
    //Definindo o diretório como a temporária do S.O. e o nome do arquivo com a data e hora (sem dois pontos)
    cCaminho  := GetTempPath()
    cArquivo  := "PMZCOMR1_" + dToS(dDataGer) + "_" + StrTran(cHoraGer, ':', '-')
     
    //Criando o objeto do FMSPrinter
    oPrintPvt := FWMSPrinter():New(cArquivo, IMP_PDF, .F., "", .T., , @oPrintPvt, "", , , , .T.)
     
    //Setando os atributos necessários do relatório
    oPrintPvt:SetResolution(72)
    oPrintPvt:SetPortrait()
    oPrintPvt:SetPaperSize(DMPAPER_A4)
    oPrintPvt:SetMargin(60, 60, 60, 60)
     
    //Imprime o cabeçalho
    fImpCab()
     
    //Montando a consulta
    cQryAux := " SELECT "                                       + CRLF
    cQryAux += "     BM_GRUPO, "                                + CRLF
    cQryAux += "     BM_DESC "                                  + CRLF
    cQryAux += " FROM "                                         + CRLF
    cQryAux += "     " + RetSQLName('SBM') + " SBM "            + CRLF
    cQryAux += " WHERE "                                        + CRLF
    cQryAux += "     BM_FILIAL = '" + FWxFilial('SBM') + "' "   + CRLF
    cQryAux += "     AND SBM.D_E_L_E_T_ = ' ' "                 + CRLF
    cQryAux += " ORDER BY "                                     + CRLF
    cQryAux += "     BM_GRUPO "                                 + CRLF
    TCQuery cQryAux New Alias "QRY_SBM"
     
    //Conta o total de registros, seta o tamanho da régua, e volta pro topo
    Count To nTotal
    ProcRegua(nTotal)
    QRY_SBM->(DbGoTop())
    nAtual := 0
     
    //Enquanto houver registros
    While ! QRY_SBM->(EoF()) .or. nAtual <=40
        nAtual++
        IncProc("Imprimindo grupo " + QRY_SBM->BM_GRUPO + " (" + cValToChar(nAtual) + " de " + cValToChar(nTotal) + ")...")
         
        //Se a linha atual mais o espaço que será utilizado forem maior que a linha final, imprime rodapé e cabeçalho
        If nLinAtu + nTamLin > nLinFin
            fImpRod()
            fImpCab()
        EndIf
         
        //Imprimindo a linha atual
        //========================================================
        //- Cabeçalho dos itens
        // It. Produto Descricao Qtde Preco Desc% Desc% Desc% Total
        //========================================================
        oPrintPvt:Box(nLinAtu,  nColIni,     nLinAtu+10, nColFin)
        oPrintPvt:Line(nLinAtu, nColIni+20,  nLinAtu+10, nColIni+20) // linha vertical divisão entre It e produto                 
        oPrintPvt:Line(nLinAtu, nColIni+75,  nLinAtu+10, nColIni+75) // linha vertical divisão entre produto e descrição
        oPrintPvt:Line(nLinAtu, nColIni+235, nLinAtu+10, nColIni+235) // linha vertical divisão entre descrição e qtde
        oPrintPvt:Line(nLinAtu, nColIni+275, nLinAtu+10, nColIni+275) // linha vertical divisão entre qtde e preço
        oPrintPvt:Line(nLinAtu, nColIni+325, nLinAtu+10, nColIni+325) // linha vertical divisão entre preço e desc%
        oPrintPvt:Line(nLinAtu, nColIni+365, nLinAtu+10, nColIni+365) // linha vertical divisão entre desc% e desc%
        oPrintPvt:Line(nLinAtu, nColIni+425, nLinAtu+10, nColIni+425) // linha vertical divisão entre desc% e desc%
        oPrintPvt:Line(nLinAtu, nColIni+465, nLinAtu+10, nColIni+465) // linha vertical divisão entre desc% e total 

        oPrintPvt:SayAlign(nLinAtu, nColIni+5, "1", oFontSay2, 30, 10)
        oPrintPvt:SayAlign(nLinAtu, nColIni+25, "123456", oFontSay2, 50, 10)
        oPrintPvt:SayAlign(nLinAtu, nColIni+80, "Produto Exemplo", oFontSay2, 200, 10)
        oPrintPvt:SayAlign(nLinAtu, nColIni+240, "10,000", oFontSay2, 50, 10)          
        oPrintPvt:SayAlign(nLinAtu, nColIni+280, "5,00", oFontSay2, 50, 10)
        oPrintPvt:SayAlign(nLinAtu, nColIni+330, "0,00", oFontSay2, 50, 10)
        oPrintPvt:SayAlign(nLinAtu, nColIni+370, "0,00", oFontSay2, 50, 10)
        oPrintPvt:SayAlign(nLinAtu, nColIni+430, "50,00", oFontSay2, 50, 10)  
        oPrintPvt:SayAlign(nLinAtu, nColIni+470, "50,00", oFontSay2, 50, 10)  

        nLinAtu += nTamLin
         
        QRY_SBM->(DbSkip())
    EndDo

    //Se a linha atual mais o espaço que será utilizado forem maior que a linha final, imprime rodapé e cabeçalho
    If nLinAtu + (nTamLin+95) > nLinFin
        fImpRod()
        fImpCab()
    EndIf

    //========================================================
    // TOTALIZAÇÃO
    //========================================================
    oPrintPvt:Box(nLinAtu, nColIni, nLinAtu+20, nColFin)

    // Divisões verticais (3 colunas)
    oPrintPvt:Line(nLinAtu, nColIni+200, nLinAtu+20, nColIni+200)
    oPrintPvt:Line(nLinAtu, nColIni+350, nLinAtu+20, nColIni+350)

    // Labels
    oPrintPvt:SayAlign(nLinAtu+2, nColIni+5, "Total de produtos", oFontSay, 180, 10)
    oPrintPvt:SayAlign(nLinAtu+2, nColIni+205, "Total de Peças", oFontSay, 140, 10)
    oPrintPvt:SayAlign(nLinAtu+2, nColIni+355, "Total do pedido", oFontSay, 180, 10)

    // Valores
    oPrintPvt:SayAlign(nLinAtu+10, nColIni+5, "14", oFontSay, 180, 12, , PAD_RIGHT)
    oPrintPvt:SayAlign(nLinAtu+10, nColIni+205, "50", oFontSay, 140, 12, , PAD_RIGHT)
    oPrintPvt:SayAlign(nLinAtu+10, nColIni+355, "7.006,43", oFontSay, 180, 12, , PAD_RIGHT)

    nLinAtu += 20


    //========================================================
    // OBSERVAÇÃO (GRANDE)
    //========================================================
    oPrintPvt:Box(nLinAtu, nColIni, nLinAtu+40, nColFin)

    oPrintPvt:SayAlign(nLinAtu+2, nColIni+5, "Obs", oFontSay, 500, 10)

    nLinAtu += 40


    //========================================================
    // ASSINATURA
    //========================================================
    oPrintPvt:Box(nLinAtu, nColIni, nLinAtu+35, nColFin)

    // Divisão no meio
    oPrintPvt:Line(nLinAtu, nColIni+300, nLinAtu+35, nColIni+300)

    // Nome (esquerda)
    oPrintPvt:SayAlign(nLinAtu+20, nColIni+5, ;
        "MAXIMO EZEQUIEL BOLIVAR ZERPA", ;
        oFontSay, 290, 12)

    // Texto conferência (direita)
    oPrintPvt:SayAlign(nLinAtu+5, nColIni+305, ;
        "Conferi preco e quantidade / embalagens", ;
        oFontSay, 250, 10, , PAD_CENTER)

    // Linha assinatura
    oPrintPvt:Line(nLinAtu+22, nColIni+320, nLinAtu+22, nColFin-20)

    // Data ___/___/___
    oPrintPvt:SayAlign(nLinAtu+25, nColIni+350, "__/__/____", ;
        oFontSay, 150, 10, , PAD_CENTER)

    nLinAtu += 35

    QRY_SBM->(DbCloseArea())
     
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
    Local cTexto   := ""
    Local nLinCab := 30

    oPrintPvt:StartPage()

    //========================================================
    // BOX PRINCIPAL CABEÇALHO
    //========================================================
    oPrintPvt:Box(nLinCab, nColIni, nLinCab+50, nColFin)

    // Divisões principais
    oPrintPvt:Line(nLinCab, nColIni+120, nLinCab+50, nColIni+120) // logo
    oPrintPvt:Line(nLinCab, nColFin-120, nLinCab+50, nColFin-120) // emissão

    // Divisão interna direita
    oPrintPvt:Line(nLinCab+25, nColFin-120, nLinCab+25, nColFin)

    // LOGO
    oPrintPvt:SayBitMap(nLinCab+10, nColIni+10, "\system\lgpmz.bmp", 90, 30)

    // TITULO CENTRAL
    oPrintPvt:SayAlign(nLinCab+18, nColIni+120, ;
        "Pedido de compra", oFontTit, ;
        (nColFin-nColIni-240), 20, , PAD_CENTER, 0)

    // EMISSÃO
    oPrintPvt:SayAlign(nLinCab+2, nColFin-115, "Emissao", oFontSay, 110, 10)
    oPrintPvt:SayAlign(nLinCab+12, nColFin-115, "12/03/2026", oFontSay, 110, 12)

    // NUMERO
    oPrintPvt:SayAlign(nLinCab+27, nColFin-115, "Nr. pedido", oFontSay, 110, 10)
    oPrintPvt:SayAlign(nLinCab+37, nColFin-115, "2514161", oFontSay, 110, 12)

    nLinCab += 50


    //========================================================
    // PARA 
    //========================================================
    oPrintPvt:Box(nLinCab, nColIni, nLinCab+20, nColFin)

    oPrintPvt:Line(nLinCab, nColFin-150, nLinCab+30, nColFin-150)

    oPrintPvt:SayAlign(nLinCab+2, nColIni+5, "Para", oFontSayn, 300, 10)
    oPrintPvt:SayAlign(nLinCab+2, nColFin-145, "a/c Sr.(a)", oFontSay2, 140, 10)

    oPrintPvt:SayAlign(nLinCab+10, nColIni+5, ;
        "2123 - PARTNERS AUTOMOTIVA INDUSTRIA E COMERCIO LTDA", ;
        oFontSay2, nColFin-160, 12)


    nLinCab += 20


    //========================================================
    // NOSSO PEDIDO + PROGRAMADO
    //========================================================
    oPrintPvt:Box(nLinCab, nColIni, nLinCab+25, nColFin)

    oPrintPvt:Line(nLinCab, nColFin-150, nLinCab+25, nColFin-150)

    oPrintPvt:SayAlign(nLinCab+2, nColIni+5, "Nosso pedido", oFontSay, 300, 10)
    oPrintPvt:SayAlign(nLinCab+2, nColFin-145, "Programado", oFontSay, 140, 10)

    oPrintPvt:SayAlign(nLinCab+12, nColIni+5, ;
        "2123 - PARTNERS AUTOMOTIVA INDUSTRIA E COMERCIO LTDA", ;
        oFontSay2, nColFin-160, 12)
    oPrintPvt:SayAlign(nLinCab+10, nColFin-145, "09/11/2023", oFontSay2, 140, 12)

    nLinCab += 25

    //========================================================
    //  OBS
    //========================================================
    oPrintPvt:Box(nLinCab, nColIni, nLinCab+20, nColFin)

    oPrintPvt:SayAlign(nLinCab+2, nColIni+5, "Obs", oFontSay, 300, 10)

    // passar a Observação do pedido.
    oPrintPvt:SayAlign(nLinCab+12, nColIni+5, ;
        "", ;
        oFontSay2, nColFin-160, 12)
    nLinCab += 20


    //========================================================
    // ENTREGA
    //========================================================
    oPrintPvt:Box(nLinCab, nColIni, nLinCab+45, nColFin)

    oPrintPvt:Line(nLinCab, nColIni+250, nLinCab+22, nColIni+250)
    oPrintPvt:Line(nLinCab+22, nColIni+200, nLinCab+45, nColIni+200)
    oPrintPvt:Line(nLinCab+22, nColIni, nLinCab+22, nColFin)
    oPrintPvt:Line(nLinCab+22, nColIni+85, nLinCab+45, nColIni+85)
    oPrintPvt:Line(nLinCab+22, nColIni+375, nLinCab+45, nColIni+375)

    // Labels
    oPrintPvt:SayAlign(nLinCab+2, nColIni+5, "Entrega", oFontSay, 240, 10)
    oPrintPvt:SayAlign(nLinCab+2, nColIni+255, "Endereço", oFontSay, 300, 10)

    // Conteúdo
    oPrintPvt:SayAlign(nLinCab+12, nColIni+5, ;
        "25 - PMZ DISTRIBUIDORA S.A", oFontSay2, 240, 12)

    oPrintPvt:SayAlign(nLinCab+12, nColIni+255, ;
        "AV. GENERAL OSORIO - JESUS DE NAZARE - MACAPA - AP", ;
        oFontSay2, 300, 12)

    // Linha inferior
    oPrintPvt:SayAlign(nLinCab+25, nColIni+5, "CEP", oFontSay, 80, 10)
    oPrintPvt:SayAlign(nLinCab+25, nColIni+90, "C.N.P.J", oFontSay, 150, 10)
    oPrintPvt:SayAlign(nLinCab+25, nColIni+205, "Insc. Estadual", oFontSay, 150, 10)
    oPrintPvt:SayAlign(nLinCab+25, nColIni+380, "Suframa", oFontSay, 150, 10)

    oPrintPvt:SayAlign(nLinCab+35, nColIni+5, "68908127", oFontSay2, 80, 12)
    oPrintPvt:SayAlign(nLinCab+35, nColIni+90, "22763502002827", oFontSay2, 150, 12)
    oPrintPvt:SayAlign(nLinCab+35, nColIni+205, "03.055.423-3", oFontSay2, 150, 12)
    oPrintPvt:SayAlign(nLinCab+35, nColIni+380, "0000", oFontSay2, 150, 12)

    nLinCab += 45


    //========================================================
    // COBRANCA
    //========================================================
    oPrintPvt:Box(nLinCab, nColIni, nLinCab+45, nColFin)

    oPrintPvt:Line(nLinCab, nColIni+250, nLinCab+22, nColIni+250) // linha horizontal superior endereço
    oPrintPvt:Line(nLinCab+22, nColIni, nLinCab+22, nColFin)
    oPrintPvt:Line(nLinCab+22, nColIni+85, nLinCab+45, nColIni+85)
    oPrintPvt:Line(nLinCab+22, nColIni+170, nLinCab+45, nColIni+170) // linha horizontal superior inscrição estadual
    oPrintPvt:Line(nLinCab+22, nColIni+245, nLinCab+45, nColIni+245) // linha horizontal inferior suframa
    oPrintPvt:Line(nLinCab+22, nColIni+340, nLinCab+45, nColIni+340) // linha horizontal inferior 

    // Labels
    oPrintPvt:SayAlign(nLinCab+2, nColIni+5, "Cobrança", oFontSay, 240, 10)
    oPrintPvt:SayAlign(nLinCab+2, nColIni+255, "Endereço", oFontSay, 300, 10)

    // Conteúdo
    oPrintPvt:SayAlign(nLinCab+12, nColIni+5, ;
        "25 - PMZ DISTRIBUIDORA S.A", oFontSay2, 240, 12)

    oPrintPvt:SayAlign(nLinCab+12, nColIni+255, ;
        "AV. PALMEIRA DO MIRITI - GILBERTO MESTRINHO - MANAUS - AM", ;
        oFontSay2, 300, 12)

    // Linha inferior
    oPrintPvt:SayAlign(nLinCab+25, nColIni+5, "CEP", oFontSay, 80, 10)
    oPrintPvt:SayAlign(nLinCab+25, nColIni+90, "C.N.P.J", oFontSay, 150, 10)
    oPrintPvt:SayAlign(nLinCab+25, nColIni+175, "Insc. Estadual", oFontSay, 150, 10)
    oPrintPvt:SayAlign(nLinCab+25, nColIni+250, "Suframa", oFontSay, 150, 10)
    oPrintPvt:SayAlign(nLinCab+25, nColIni+345, "Cond. Pag.", oFontSay, 150, 10)

    oPrintPvt:SayAlign(nLinCab+35, nColIni+5, "68908127", oFontSay2, 80, 12)
    oPrintPvt:SayAlign(nLinCab+35, nColIni+90, "22763502002827", oFontSay2, 150, 12)
    oPrintPvt:SayAlign(nLinCab+35, nColIni+175, "03.055.423-3", oFontSay2, 150, 12)
    oPrintPvt:SayAlign(nLinCab+35, nColIni+250, "0000", oFontSay2, 150, 12)
    oPrintPvt:SayAlign(nLinCab+35, nColIni+345, " F30 - A VISTA FORNECEDOR 30 DIAS", oFontSay2, 150, 12)

    nLinCab += 45

    //========================================================
    // TRANSPORTADORA
    //========================================================
    oPrintPvt:Box(nLinCab, nColIni, nLinCab+20, nColFin)

    oPrintPvt:SayAlign(nLinCab+2, nColIni+5, "Transportadora", oFontSay2, 300, 10)
    oPrintPvt:SayAlign(nLinCab+10, nColIni+5, ;
        "1311 - ENTREGAS JA LOGISTICA", oFontSay2, 400, 12)

    nLinCab += 20


    //========================================================
    // OBSERVAÇÃO
    //========================================================
    oPrintPvt:Box(nLinCab, nColIni, nLinCab+35, nColFin)
    nLinCab += 2
    oPrintPvt:SayAlign(nLinCab, nColIni+5, "Observacoes", oFontSay2, 500, 10)
    nLinCab += 10

    oPrintPvt:SayAlign(nLinCab, nColIni+5, ;
        "VEDADA A NEGOCIACAO C/ENTIDADE DE FACTORING/FOMENTO MERCANTIL DE DUPLICATA", ;
        oFontSay2, 500, 12)
    nLinCab += 10
    oPrintPvt:SayAlign(nLinCab, nColIni+5, ;
        "REDESPACHO POR PMZ DISTRIBUIDORA S.A -", ;
        oFontDetN, 500, 12)
    
    nLinCab += 13
    //========================================================
    // ITENS - Para exemplificar, não foi utilizado loop para impressão dos itens, apenas 2 linhas fixas
    //========================================================
    oPrintPvt:Box(nLinCab, nColIni, nLinCab+18, nColFin)
    nLinCab += 2
    oPrintPvt:SayAlign(nLinCab, nColIni+5, "ITENS", oFontTit, 520, 10, COR_PRETO, PAD_CENTER, 0)
    nLinCab += 16
    
    //========================================================
    //- Cabeçalho dos itens
    // It. Produto Descricao Qtde Preco Desc% Desc% Desc% Total
    //========================================================
    oPrintPvt:Box(nLinCab,  nColIni,     nLinCab+18, nColFin)
    oPrintPvt:Line(nLinCab, nColIni+20,  nLinCab+18, nColIni+20) // linha vertical divisão entre It e produto                 
    oPrintPvt:Line(nLinCab, nColIni+75,  nLinCab+18, nColIni+75) // linha vertical divisão entre produto e descrição
    oPrintPvt:Line(nLinCab, nColIni+235, nLinCab+18, nColIni+235) // linha vertical divisão entre descrição e qtde
    oPrintPvt:Line(nLinCab, nColIni+275, nLinCab+18, nColIni+275) // linha vertical divisão entre qtde e preço
    oPrintPvt:Line(nLinCab, nColIni+325, nLinCab+18, nColIni+325) // linha vertical divisão entre preço e desc%
    oPrintPvt:Line(nLinCab, nColIni+365, nLinCab+18, nColIni+365) // linha vertical divisão entre desc% e desc%
    oPrintPvt:Line(nLinCab, nColIni+425, nLinCab+18, nColIni+425) // linha vertical divisão entre desc% e desc%
    oPrintPvt:Line(nLinCab, nColIni+465, nLinCab+18, nColIni+465) // linha vertical divisão entre desc% e total 

    nLinCab += 2
 
    oPrintPvt:SayAlign(nLinCab, nColIni+5, "It.", oFontSay2, 30, 10)
    oPrintPvt:SayAlign(nLinCab, nColIni+25, "Produto", oFontSay2, 50, 10)
    oPrintPvt:SayAlign(nLinCab, nColIni+80, "Descricao", oFontSay2, 200, 10)
    oPrintPvt:SayAlign(nLinCab, nColIni+240, "Qtde", oFontSay2, 50, 10)          
    oPrintPvt:SayAlign(nLinCab, nColIni+280, "Preco", oFontSay2, 50, 10)
    oPrintPvt:SayAlign(nLinCab, nColIni+330, "Desc%", oFontSay2, 50, 10)
    oPrintPvt:SayAlign(nLinCab, nColIni+370, "Desc%", oFontSay2, 50, 10)
    oPrintPvt:SayAlign(nLinCab, nColIni+430, "Desc%", oFontSay2, 50, 10)
    oPrintPvt:SayAlign(nLinCab, nColIni+470, "Total", oFontSay2, 50, 10)  
    
    nLinAtu := nLinCab + 16
     
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
