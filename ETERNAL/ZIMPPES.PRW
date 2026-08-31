#Include "PROTHEUS.CH"
#Include "RPTDEF.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWPrintSetup.ch"

/*/{Protheus.doc} ZImpPes
Imprime o ticket de entrada da pesagem posicionada na tabela SZ3.
O leiaute ocupa somente a metade superior de uma folha A4 em retrato.

@type       User Function
@author     Edson Sales
@since      28/08/2026
/*/

//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2

User Function ZImpPes()

    Local aArea       := FWGetArea()
    Local aAreaSZ3    := {}
    Local oPrint      := Nil
    Local cArq        := "ticket_pesagem_" + DToS(Date()) + StrTran(Time(), ":", "")
    Local cProduto    := ""
    Local cCliente    := ""
    Local cLeitura    := ""
    Local cObs        := ""
    Local cPesoBruto    := ""
    Local cPesoNF     := ""
    Local cDataHora   := ""
    Local nPesoNF     := 0

    // RPCSetType(3)
	// RPCSetEnv('01','01',,,)

    // dbSelectArea('SZ3')
    // dbSetOrder(3)
    // msSeek(xFilial('SZ3')+'000002E')

    If Select("SZ3") == 0
        FWAlertError("A tabela SZ3 nao esta aberta.", "Ticket de pesagem")
        FWRestArea(aArea)
        Return
    EndIf

    aAreaSZ3 := SZ3->(FWGetArea())

    If SZ3->(Eof()) .Or. SZ3->(Bof())
        FWAlertError("Nao existe uma pesagem posicionada para impressao.", ;
            "Ticket de pesagem")
        FWRestArea(aAreaSZ3)
        FWRestArea(aArea)
        Return
    EndIf

    cProduto  := AllTrim(SZ3->Z3_PRODUTO)
    cCliente  := AllTrim(SZ3->Z3_CLIENTE)
    cLeitura  := Z3TipoLeit(SZ3->Z3_TIPLEIT)
    cObs      := '' //AllTrim(SZ3->Z3_LOG)
    nPesoNF   := SZ3->Z3_DIFNF
    cPesoBruto  := Transform(SZ3->Z3_PESO,   "@E 999,999,999.9999") + " kg"
    cPesoNF   := Transform(nPesoNF,        "@E 999,999,999.9999") + " kg"
    cPesoLiq  := Transform(SZ3->Z3_PESLIQ, "@E 999,999,999.9999") + " kg"
    cDataHora := DToC(SZ3->Z3_DATAPES) + "  " + AllTrim(SZ3->Z3_HRPESO)

    If !Empty(SZ3->Z3_PRODUTO)
        cProduto := AllTrim(SZ3->Z3_PRODUTO) + " - " + ;
            AllTrim(Posicione("SB1", 1, xFilial("SB1") + SZ3->Z3_PRODUTO, "B1_DESC"))
    EndIf

    If !Empty(SZ3->Z3_CLIENTE)
        cCliente := AllTrim(SZ3->Z3_CLIENTE) + "/" + AllTrim(SZ3->Z3_LOJA) + " - " + ;
            AllTrim(Posicione("SA1", 1, xFilial("SA1") + ;
                SZ3->Z3_CLIENTE + SZ3->Z3_LOJA, "A1_NOME"))
    EndIf

    oPrint := FWMSPrinter():New(cArq, IMP_PDF, .F.,, .T., ,, "", , , , .T.)
    // oPrint := FWMSPrinter():New(cArq, IMP_PDF, .F., "", .T.)
    //Setando os atributos necessários do relatório
    oPrint:SetResolution(72)
    oPrint:SetPortrait()
    oPrint:SetPaperSize(DMPAPER_A4)
    oPrint:SetMargin(0, 0, 0, 0)
    oPrint:StartPage()
    
    cMov := SZ3->Z3_MOVIMEN
    if cMov == 'E'
        fTickEnt(oPrint,cProduto,cCliente,cLeitura,cObs,nPesoNF,cPesoBruto,cPesoNF,cDataHora)
    else
        fTickSai(oPrint,cProduto,cCliente,cLeitura,cObs,nPesoNF,cPesoBruto,cPesoLiq,cPesoNF,cDataHora)
    endif

    oPrint:EndPage()
    oPrint:Setup()
    oPrint:Print()

    FWRestArea(aAreaSZ3)
    FWRestArea(aArea)

Return

/*{Protheus.doc} fTickEnt*/
/*Função que gerar o tiket de entrada*/
Static Function fTickEnt(oPrint,cProduto,cCliente,cLeitura,cObs,nPesoNF,cPesoBruto,cPesoNF,cDataHora)
    Local oFontIni    := TFont():New("Arial",, -12, .T.)
    Local oFontEmp    := TFont():New("Arial",, -11, .T.)
    Local oFontTitulo := TFont():New("Arial",, -14, .T.)
    Local oFontLabel  := TFont():New("Arial",,  -9, .T.)
    Local oFontDados  := TFont():New("Arial",,  -9, .F.)
    Local oFontRod    := TFont():New("Arial",,  -6, .F.)
    Local oFontRodB   := TFont():New("Arial",,  -6, .T.)
    Local nLinAtu     := 10
    Local nTamLin     := 10
    Local nCol2       := 10
    Local nBkpLin     := 10
    cTipo := 'ENTRADA'

    // 595 x 842 pontos em 72 DPI. O ticket termina antes da linha 421.
    oPrint:SayAlign( nLinAtu,  20, "Modelo de Impressão realizada na Balança ("+cTipo+")", ;
        oFontIni, 555, 15, RGB(64, 64, 64), PAD_CENTER, 0)

    nLinAtu += nTamLin + 15

    oPrint:SayAlign( nLinAtu,  20, "ETERNAL IND COM SERV E TRATAMENTO DE RESIDUOS DA AMAZONIA LTDA", ;
        oFontEmp, 555, 15, CLR_BLACK, PAD_CENTER, 0)

    nLinAtu += nTamLin 

    oPrint:SayAlign( nLinAtu,  20, "(92) 3616-4700", oFontDados, 135, 12, CLR_BLACK, PAD_LEFT, 0)
    oPrint:SayAlign( nLinAtu, 120, "RUA GUIANA FRANCESA 01", oFontDados, 135, 12, CLR_BLACK, PAD_CENTER, 0)
    oPrint:SayAlign( nLinAtu, 440, "MANAUS  -  AM", oFontDados, 135, 12, CLR_BLACK, PAD_RIGHT, 0)

    nLinAtu += nTamLin 
    oPrint:Line(nLinAtu, 20, nLinAtu, 575)
    nLinAtu += nTamLin 
    oPrint:SayAlign(nLinAtu, 20, "TICKET DE ENTRADA", oFontTitulo, 555, 15, CLR_BLACK, PAD_CENTER, 0)
    nLinAtu += nTamLin +20
    nCol2 := nLinAtu
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Pesagem Numero:",      AllTrim(SZ3->Z3_NPESAG)+SPACE(10)+"-"+SPACE(10)+cTipo,; 
    oFontLabel, oFontDados, .T.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Peso de Entrada:",     cPesoBruto,                oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Leitura de Peso:",     cLeitura,                oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Nota Fiscal:",         AllTrim(SZ3->Z3_NFISCAL) + ;
        IIf(Empty(SZ3->Z3_SERIE), "", "/" + AllTrim(SZ3->Z3_SERIE)), oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Peso Nota Fiscal:",    cPesoNF,                 oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Ordem de Servico:",    AllTrim(SZ3->Z3_ORDSERV),oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Data/Hora Entrada:",   cDataHora,               oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Motorista:",           AllTrim(SZ3->Z3_MOTORIS),oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Transportadora:",     ''                       ,oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin

    nBkpLin := nLinAtu
    nLinAtu := nCol2 

    Z3ImpCampo(oPrint, nLinAtu, 250,310, "Produto:",             cProduto,                oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu, 250,310, "Tipo Veiculo:",        AllTrim(SZ3->Z3_TPVEIC), oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu, 250,310, "Placa:",               AllTrim(SZ3->Z3_XPLACA), oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu, 250,310, "Placa carreta:",      ' '                     , oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu, 250,310, "Cliente:",             cCliente,                oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu, 250,310, "Observacoes:",         cObs,                    oFontLabel, oFontDados, .F.)

    nLinAtu := nBkpLin
    nLinAtu += nTamLin +10
    nLinAtu := 215
    oPrint:Line(nLinAtu, 300, nLinAtu, 555) 
    oPrint:SayAlign(nLinAtu, 300, "Assinatura", oFontDados, 255, 12, CLR_BLACK, PAD_CENTER, 0)

    nLinAtu += nTamLin +30
    oPrint:Line(nLinAtu, 20, nLinAtu, 575)
    oPrint:SayAlign(nLinAtu, 20, DToC(Date()) + " " + Time(), oFontRod, 255, 12, RGB(64, 64, 64), PAD_LEFT, 0)
    oPrint:SayAlign(nLinAtu, 175, "TOTVS Protheus integrado com a balança do Sistema de Pesagem de Veiculos", ;
        oFontRodB, 400, 10, RGB(64, 64, 64), PAD_RIGHT, 0)
Return 

/*{Protheus.doc} fTickEnt*/
/*Função que gerar o tiket de entrada*/
Static Function fTickSai(oPrint,cProduto,cCliente,cLeitura,cObs,nPesoNF,cPesoBruto,cPesoLiq,cPesoNF,cDataHora)
    Local oFontIni    := TFont():New("Arial",, -12, .T.)
    Local oFontEmp    := TFont():New("Arial",, -11, .T.)
    Local oFontTitulo := TFont():New("Arial",, -14, .T.)
    Local oFontLabel  := TFont():New("Arial",,  -9, .T.)
    Local oFontDados  := TFont():New("Arial",,  -9, .F.)
    Local oFontRod    := TFont():New("Arial",,  -6, .F.)
    Local oFontRodB   := TFont():New("Arial",,  -6, .T.)
    Local nLinAtu     := 10
    Local nTamLin     := 10
    Local nCol2       := 10
    Local nBkpLin     := 10
    cTipo := 'SAIDA'

    // 595 x 842 pontos em 72 DPI. O ticket termina antes da linha 421.
    oPrint:SayAlign( nLinAtu,  20, "Modelo de Impressão realizada na Balança ("+cTipo+")", ;
        oFontIni, 555, 15, RGB(64, 64, 64), PAD_CENTER, 0)

    nLinAtu += nTamLin + 15

    oPrint:SayAlign( nLinAtu,  20, "ETERNAL IND COM SERV E TRATAMENTO DE RESIDUOS DA AMAZONIA LTDA", ;
        oFontEmp, 555, 15, CLR_BLACK, PAD_CENTER, 0)

    nLinAtu += nTamLin 

    oPrint:SayAlign( nLinAtu,  20, "(92) 3616-4700", oFontDados, 135, 12, CLR_BLACK, PAD_LEFT, 0)
    oPrint:SayAlign( nLinAtu, 120, "RUA GUIANA FRANCESA 01", oFontDados, 135, 12, CLR_BLACK, PAD_CENTER, 0)
    oPrint:SayAlign( nLinAtu, 440, "MANAUS  -  AM", oFontDados, 135, 12, CLR_BLACK, PAD_RIGHT, 0)

    nLinAtu += nTamLin 
    oPrint:Line(nLinAtu, 20, nLinAtu, 575)
    nLinAtu += nTamLin 
    oPrint:SayAlign(nLinAtu, 20, "TICKET DE SAIDA", oFontTitulo, 555, 15, CLR_BLACK, PAD_CENTER, 0)
    nLinAtu += nTamLin +20
    nCol2 := nLinAtu
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Pesagem Numero:",      AllTrim(SZ3->Z3_NPESAG)+SPACE(10)+"-"+SPACE(10)+cTipo,; 
    oFontLabel, oFontDados, .T.)
    cPesoEnt := Transform(Posicione('SZ3',3,xFilial('SZ3')+SZ3->Z3_NPESAG+'E','Z3_PESO'),   "@E 999,999,999.9999") + " kg"
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Peso de Entrada:",     cPesoEnt,                oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 

    cPesoNF := Transform(SZ3->Z3_PESONF,   "@E 999,999,999.9999") + " kg"
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Peso de Saida:",       cPesoBruto,                oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Peso de Liquido:",     cPesoLiq,                oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Nota Fiscal:",         AllTrim(SZ3->Z3_NFISCAL) + ;
        IIf(Empty(SZ3->Z3_SERIE), "", "/" + AllTrim(SZ3->Z3_SERIE)), oFontLabel, oFontDados, .F.)
         nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Ordem de Servico:",    AllTrim(SZ3->Z3_ORDSERV),oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Peso Nota Fiscal:",    cPesoNF,                 oFontLabel, oFontDados, .F.)

    cDifPesoNf := Transform(SZ3->Z3_DIFNF,     "@E 999,999,999.9999") + " kg"
    cDifPesPer := Transform(SZ3->Z3_DIFPERC,   "@E 999,999,999.9999") + " %"

    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Dif. Nota Fiscal:",    cDifPesoNf,                 oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Perc. diferença:",     cDifPesPer,                 oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 

    cDtHrEntr := DToC(Posicione('SZ3',3,xFilial('SZ3')+SZ3->Z3_NPESAG+'E','Z3_DATAPES'))+" "+AllTrim(Posicione('SZ3',3,xFilial('SZ3')+SZ3->Z3_NPESAG+'E','Z3_HRPESO'))
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Data/Hora Entrada:",   cDtHrEntr,               oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Data/Hora Saida:",   cDataHora,               oFontLabel, oFontDados, .F.)

    nLinAtu += nTamLin +5
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Leit. Peso Entrada:", Z3TipoLeit(Posicione('SZ3',3,xFilial('SZ3')+SZ3->Z3_NPESAG+'E','Z3_TIPLEIT'))    ,;
    oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu,  20,100, "Leit. Peso Saida:",      Z3TipoLeit(SZ3->Z3_TIPLEIT),oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin

    nBkpLin := nLinAtu
    nLinAtu := nCol2 

    Z3ImpCampo(oPrint, nLinAtu, 250,310, "Produto:",             cProduto,                oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu, 250,310, "Tipo Veiculo:",        AllTrim(SZ3->Z3_TPVEIC), oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu, 250,310, "Placa:",               AllTrim(SZ3->Z3_XPLACA), oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu, 250,310, "Placa carreta:",      ' '                     , oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu, 250,310, "Motorista",           AllTrim(SZ3->Z3_MOTORIS) , oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu, 250,310, "Transportadora",      '', oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu, 250,310, "Cliente:",             cCliente,                oFontLabel, oFontDados, .F.)
    nLinAtu += nTamLin 
    Z3ImpCampo(oPrint, nLinAtu, 250,310, "Observacoes:",         cObs,                    oFontLabel, oFontDados, .F.)

    nLinAtu := nBkpLin
    nLinAtu += nTamLin +30
    nLinAtu := 215
    oPrint:Line(nLinAtu, 300, nLinAtu, 555) 
    oPrint:SayAlign(nLinAtu, 300, "Assinatura", oFontDados, 255, 12, CLR_BLACK, PAD_CENTER, 0)

    nLinAtu += nTamLin +30
    oPrint:Line(nLinAtu, 20, nLinAtu, 575)
    oPrint:SayAlign(nLinAtu, 20, DToC(Date()) + " " + Time(), oFontRod, 255, 12, RGB(64, 64, 64), PAD_LEFT, 0)
    oPrint:SayAlign(nLinAtu, 175, "TOTVS Protheus integrado com a balança do Sistema de Pesagem de Veiculos", ;
        oFontRodB, 400, 10, RGB(64, 64, 64), PAD_RIGHT, 0)
Return 

/* Imprime um par rotulo/valor em uma linha do ticket. */
Static Function Z3ImpCampo(oPrint, nLin, nColLab,nColVal, cLabel, cValor, oFontLabel, oFontDados, lDestaque)

    Local oFonte := IIf(lDestaque, oFontLabel, oFontDados)

    oPrint:SayAlign(nLin, nColLab,  Alltrim(cLabel), oFontLabel,255, 12, CLR_BLACK, PAD_LEFT, 0)
    oPrint:SayAlign(nLin, nColVal,  Alltrim(cValor), oFonte    ,255, 12, CLR_BLACK, PAD_LEFT, 0)

Return

/* Ajuste aqui os codigos efetivamente utilizados no campo Z3_TIPLEIT. */
Static Function Z3TipoLeit(cTipo)

    Local cRet := AllTrim(cTipo)

    Do Case
    Case cRet $ "A|1"
        cRet := "Automatico"
    Case cRet $ "M|2"
        cRet := "Manual"
    Otherwise
        If Empty(cRet)
            cRet := "Nao informado"
        EndIf
    EndCase

Return cRet
