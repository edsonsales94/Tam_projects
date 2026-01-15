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
#Define COL_INI     0015
#Define COL_INI1    0080
#Define COL_GRUPO   0015
#Define COL_DESCR   0095
#Define COL_QTD     0380
#Define COL_LOT     0480
#Define COL_DTFAB   0520
#Define COL_DTVAL   0580
#Define COL_TOT     0680
#Define COL_CAI     0780

/*/{Protheus.doc} zTstRel
Exemplos de FWMSPrinter
@author Atilio
@since 27/01/2019
@version 1.0
@type function
/*/

User Function HISPED01()
// Local lAmb := RpcSetEnv('02', '01',,,"FAT")
	Local aArea := GetArea()
	Local cPerg       := "RSFATR20"
	Private oPrintPvt
	Private dDataGer  := Date()
	Private cHoraGer  := Time()
	Private cArquivo  := "HISPED01" + dToS(dDataGer) + "_" + StrTran(cHoraGer, ':', '-')

	CriaSx1(cPerg)
	if Pergunte(cPerg,.T.)

		//Criando o objeto do FMSPrinter
		oPrintPvt := FWMSPrinter():New(cArquivo, IMP_PDF, .F., cPerg, .F., , @oPrintPvt, "", , , ,.T.)

		// oPrintPvt:Setup()
		//Setando os atributos necessários do relatório
		oPrintPvt:SetResolution(72)
		oPrintPvt:SetPortrait()
		oPrintPvt:SetPaperSize(DMPAPER_A4)
		oPrintPvt:SetLandscape()
		oPrintPvt:SetMargin(10, 10, 10, 10)

		Processa({|| fMontaRel()}, "Processando...")

	endif
	RestArea(aArea)
Return

/*---------------------------------------------------------------------*
 | Func:  fMontaRel                                                    |
 | Desc:  Função que monta o relatório                                 |
 *---------------------------------------------------------------------*/
 
Static Function fMontaRel()
    Local cCaminho    := ""
    // Local nLinAtu  := 030
    //Linhas e colunas
    Private nLinAtu   := 030
    Private nTamLin   := 010
    Private nLinFin   := 820
    Private nColIni   := 010
    Private nColFin   := 825
    Private nColMeio  := (nColFin-nColIni)/2
    //Objeto de Impressão
    Private _cFilial := ''
    Private cNumPed := ''
    //Variáveis auxiliares
  
    Private nPagAtu   := 1
    Private cNomeUsr  := UsrRetName(RetCodUsr())
    //Fontes
    Private cNomeFont := "Arial"
    Private oFontDet  := TFont():New(cNomeFont, 9, -11, .T., .F., 5, .T., 5, .T., .F.)
    Private oFont2    := TFont():New(cNomeFont, 9, -09, .T., .F., 5, .T., 5, .T., .F.)
    Private oFontDetN := TFont():New(cNomeFont, 9, -10, .T., .T., 5, .T., 5, .T., .F.)
    Private oFontCabN := TFont():New(cNomeFont, 12, -11, .T., .T., 5, .T., 5, .T., .F.)
    Private oFontIte  := TFont():New(cNomeFont, 10, -11, .T., .F., 5, .T., 5, .T., .F.)
    Private oFontIteN := TFont():New(cNomeFont, 10, -11, .T., .T., 5, .T., 5, .T., .F.)
    Private oFontRod  := TFont():New(cNomeFont, 9, -08, .T., .F., 5, .T., 5, .T., .F.)
    Private oFontTit  := TFont():New(cNomeFont, 9, -13, .T., .T., 5, .T., 5, .T., .F.)
     
    //Definindo o diretório como a temporária do S.O. e o nome do arquivo com a data e hora (sem dois pontos)
    cCaminho  := GetTempPath()
      
    dbSelectArea("SC5")
    dbSetOrder(1)
    dbSeek(xFilial("SC5")+mv_par01)

    While !Eof() .And. SC5->C5_NUM >= mv_par01 .and. SC5->C5_NUM <= mv_par02
    
        If LEFT(DTOS(SC5->C5_EMISSAO),4) = MV_PAR03
            nLinAtu := 030
            //Iniciando Página
            oPrintPvt:StartPage()

            dbSelectArea("SC6")
            dbSetOrder(1)
            dbSeek(xFilial("SC6")+SC5->C5_NUM)

            _nToTal  := 0
            lRet := .T.
            While !Eof() .And. SC5->(C5_FILIAL+C5_NUM) == SC6->(C6_FILIAL+C6_NUM)
            //Imprime o cabeçalho
                titulo   := "Pedido de Venda"
                nTotVal  := 0
                nTotDesc := 0
                nTotVal1 := 0
                nVlrTot  := 0
                titulo   := ALLTRIM(titulo)+" - N. "+SC5->C5_NUM
                if lRet
                    lRet := .F.
                    //Cabeçalho
                    oPrintPvt:Line(nLinAtu, nColIni, nLinAtu, nColFin, COR_CINZA)
                    cCabec := "Pedido de Vendas - Nº "
                    nLinAtu += (nTamLin)
                    oPrintPvt:SayBitmap( nLinAtu-8, COL_INI, "\system\lgrl01.bmp", 50, 30)
                    oPrintPvt:SayAlign(nLinAtu, nColMeio - 120, cCabec + SC5->C5_NUM, oFontTit, 240, 20, COR_PRETO, PAD_CENTER, 0)
                    oPrintPvt:SayAlign(nLinAtu-6, COL_TOT+50, 'Data Emissão: '+dtoc(ddatabase), oFont2, 240, 20, COR_PRETO, PAD_LEFT, 0)
                    oPrintPvt:SayAlign(nLinAtu+4, COL_TOT+50, 'Hora Emissão: '+Time(), oFont2, 240, 20, COR_PRETO, PAD_LEFT, 0)
                    //Linha Separatória
                    nLinAtu += (nTamLin * 2)+2
                    oPrintPvt:Line(nLinAtu, nColIni, nLinAtu, nColFin, COR_CINZA)


                    nQtdCaixa := 0
                    nLinAtu += (nTamLin)

                    oPrintPvt:SayAlign(nLinAtu, COL_INI, "Cliente ", oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    oPrintPvt:SayAlign(nLinAtu, COL_INI1, ": "+ SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+ " - " +POSICIONE("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME"), oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0);nLinAtu += nTamLin

                    oPrintPvt:SayAlign(nLinAtu, COL_INI, "Cidade/UF ", oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    oPrintPvt:SayAlign(nLinAtu, COL_INI1, ": "+ ALLTRIM(POSICIONE("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_MUN"))+"/"+POSICIONE("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST"), oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0);nLinAtu += nTamLin

                    oPrintPvt:SayAlign(nLinAtu, COL_INI, "Ped. Cliente ", oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    oPrintPvt:SayAlign(nLinAtu, COL_INI1, ": "+ ALLTRIM(StrTran(StrTran(StrTran(SC5->C5_PEDCLI,"/",""),"-",""),".","")), oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0);nLinAtu += nTamLin

                    oPrintPvt:SayAlign(nLinAtu, COL_INI, "Cond. Pag ", oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    oPrintPvt:SayAlign(nLinAtu, COL_INI1, ": "+ SC5->C5_CONDPAG+" - " +POSICIONE("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI")     , oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0);nLinAtu += nTamLin

                    oPrintPvt:SayAlign(nLinAtu, COL_INI, "Vendedor ", oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    oPrintPvt:SayAlign(nLinAtu, COL_INI1, ": "+ ALLTRIM(SC5->C5_VEND1)+" - " +POSICIONE("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_NOME")  , oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0);nLinAtu += nTamLin

                    oPrintPvt:SayAlign(nLinAtu, COL_INI, "Tabela ", oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    oPrintPvt:SayAlign(nLinAtu, COL_INI1, ": "+ SC5->C5_TABELA   , oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0);nLinAtu += nTamLin

                    cTransp := POSICIONE("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_TRANSP")
                    oPrintPvt:SayAlign(nLinAtu, COL_INI, "Transportadora " ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    oPrintPvt:SayAlign(nLinAtu, COL_INI1, ": "+  ALLTRIM(POSICIONE("SA4",1,xFilial("SA4")+cTransp,"A4_NOME"))  , oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0);nLinAtu += nTamLin

                    oPrintPvt:SayAlign(nLinAtu, COL_INI, "Peso Bruto " ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    oPrintPvt:SayAlign(nLinAtu, COL_INI1, ": "+  Transform(SC5->C5_PBRUTO,TM(SC5->C5_PBRUTO,TamSX3("C5_PBRUTO")[1],TamSX3("C5_PBRUTO")[2])), oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0);nLinAtu += nTamLin

                    oPrintPvt:SayAlign(nLinAtu, COL_INI, "Peso Liquido " ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    oPrintPvt:SayAlign(nLinAtu, COL_INI1, ": "+  Transform(SC5->C5_PESOL,TM(SC5->C5_PESOL,TamSX3("C5_PESOL")[1],TamSX3("C5_PESOL")[2])), oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0);nLinAtu += nTamLin

                    oPrintPvt:SayAlign(nLinAtu, COL_INI, "Volume " ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    oPrintPvt:SayAlign(nLinAtu, COL_INI1, ": "+  Transform(SC5->C5_VOLUME1,TM(SC5->C5_VOLUME1,TamSX3("C5_VOLUME1")[1],TamSX3("C5_VOLUME1")[2])), oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0);nLinAtu += nTamLin
                    
                    if SC5->C5_PDESCAB > 0
                        oPrintPvt:SayAlign(nLinAtu, COL_INI, "Desconto " ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                        oPrintPvt:SayAlign(nLinAtu, COL_INI1,": "+Transform(SC5->C5_PDESCAB,TM(SC5->C5_PDESCAB,TamSX3("C5_PDESCAB")[1],TamSX3("C5_PDESCAB")[2]))+"%", oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0);nLinAtu += nTamLin
                    endif

                    //Linha Separatória
                    nLinAtu += (nTamLin)
                    // oPrintPvt:Line(nLinAtu, nColIni, nLinAtu, nColFin, COR_CINZA)
                    
                    oPrintPvt:SayAlign(nLinAtu, COL_GRUPO, "Produto " ,oFontCabN, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    oPrintPvt:SayAlign(nLinAtu, COL_DESCR, "Descricao " ,oFontCabN, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    oPrintPvt:SayAlign(nLinAtu, COL_QTD,   "Quantidade " ,oFontCabN, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    oPrintPvt:SayAlign(nLinAtu, COL_LOT,   "Lote " ,oFontCabN, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    oPrintPvt:SayAlign(nLinAtu, COL_DTFAB,   "Data Fab. " ,oFontCabN, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    oPrintPvt:SayAlign(nLinAtu, COL_DTVAL,   "Data Val. " ,oFontCabN, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    // oPrintPvt:SayAlign(nLinAtu, COL_REF,   "Preco Ref. " ,oFontCabN, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    oPrintPvt:SayAlign(nLinAtu, COL_TOT,   "Total " ,oFontCabN, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    // oPrintPvt:SayAlign(nLinAtu, COL_QTD2,   "Quantidade " ,oFontCabN, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    oPrintPvt:SayAlign(nLinAtu, COL_CAI,   "Caixa " ,oFontCabN, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                    nLinAtu += nTamLin+2
                    oPrintPvt:Line(nLinAtu, nColIni, nLinAtu, nColFin, COR_CINZA)
                    nLinAtu += 2
                endif

                oPrintPvt:SayAlign(nLinAtu, COL_GRUPO, SC6->C6_PRODUTO ,oFontIteN, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                oPrintPvt:SayAlign(nLinAtu, COL_DESCR, SC6->C6_DESCRI ,oFontIteN, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                // oPrintPvt:SayAlign(nLinAtu, COL_QTD,   Transform(SC6->C6_QTDVEN,TM(SC6->C6_QTDVEN,TamSX3("C6_QTDVEN")[1],TamSX3("C6_QTDVEN")[2])) ,oFontIte, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                oPrintPvt:SayAlign(nLinAtu, COL_QTD,   Transform(SC6->C6_QTDVEN,"@E 999,999,999.9999") ,oFontIteN, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                oPrintPvt:SayAlign(nLinAtu, COL_LOT,   SC6->C6_LOTECTL ,oFontIte, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                oPrintPvt:SayAlign(nLinAtu, COL_DTFAB, DTOC(SC6->C6_FABRIC) ,oFontIte, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                oPrintPvt:SayAlign(nLinAtu, COL_DTVAL, DTOC(SC6->C6_DTVALID) ,oFontIte, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                nVlrTot := POSICIONE("DA1",1,xFilial("DA1")+SC5->C5_TABELA+SC6->C6_PRODUTO,"DA1_XPRCFI")*SC6->C6_QTDVEN
                oPrintPvt:SayAlign(nLinAtu, COL_TOT,   Transform(nVlrTot,TM(nVlrTot,TamSX3("C6_VALOR")[1],TamSX3("C6_VALOR")[2])) ,oFontIte, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
                nQtdCaixa := POSICIONE("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_XCAIXA") 
                oPrintPvt:SayAlign(nLinAtu, COL_CAI,   Transform(ROUND(SC6->C6_QTDVEN/nQtdCaixa,2),"@E 999,999.99") ,oFontIte, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)

                _nToTal += SC6->C6_VALOR
                SC6->(dbSkip())
                nLinAtu += nTamLin
            EndDo

            nTotVal += _nToTal
            nTotVal += SC5->C5_FRETE
            nTotVal += SC5->C5_SEGURO
            nTotVal += SC5->C5_DESPESA
            nTotVal += SC5->C5_FRETAUT
            nTotDesc += ROUND((nTotVal*SC5->C5_PDESCAB/100),2)

            if SC5->C5_DESC1 > 0

                nTotVal1 += nTotVal-nTotDesc
                nTotDesc += Round((nTotVal1*SC5->C5_DESC1/100),2)

            endif

            nLinAtu += nTamLin
            oPrintPvt:Line(nLinAtu, nColIni, nLinAtu, nColFin, COR_CINZA)

            oPrintPvt:SayAlign(nLinAtu, COL_GRUPO, "Total do Pedido ---->" ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
            oPrintPvt:SayAlign(nLinAtu, COL_QTD-80, Transform(nTotVal ,"@E 999,999,999.99") ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
            oPrintPvt:SayAlign(nLinAtu, COL_LOT, "Desconto: " ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
            oPrintPvt:SayAlign(nLinAtu, COL_DTFAB+20, Transform(nTotDesc  ,"@E 999,999,999.99") ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
            oPrintPvt:SayAlign(nLinAtu, COL_DTVAL +20,  "=" ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
            oPrintPvt:SayAlign(nLinAtu, COL_CAI-20, Transform(nTotVal-nTotDesc  ,"@E 999,999,999.99") ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)

            nLinAtu += nTamLin+30

            dbSelectArea('SD2')
            DbSetOrder(8)
            cNota := ''
            cEmissao := ''
            if MsSeek(xFilial('SC6')+SC6->C6_NUM)
                cNota    := SD2->D2_DOC
                cEmissao := DTOC(SD2->D2_EMISSAO)
            EndIf

            oPrintPvt:SayAlign(nLinAtu, COL_GRUPO, "Separado por :" ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
            oPrintPvt:SayAlign(nLinAtu, COL_GRUPO+50, "________________________________________" ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
            oPrintPvt:SayAlign(nLinAtu, COL_DTFAB, "Nota Fiscal:"        ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
            
            if Empty(cNota)
                oPrintPvt:SayAlign(nLinAtu, COL_DTFAB+50, "________________________________________" ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
            else
                oPrintPvt:SayAlign(nLinAtu, COL_DTFAB+50, +"   "+cNota ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
            endif
            
            nLinAtu += nTamLin+10
            oPrintPvt:SayAlign(nLinAtu, COL_GRUPO, "Conferido por:" ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
            oPrintPvt:SayAlign(nLinAtu, COL_GRUPO+50, "________________________________________" ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
            oPrintPvt:SayAlign(nLinAtu, COL_DTFAB, "Data:" ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
            
            if Empty(cEmissao)
                oPrintPvt:SayAlign(nLinAtu, COL_DTFAB+50, "_____/_____/_______" ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
            else
                oPrintPvt:SayAlign(nLinAtu, COL_DTFAB+50, cEmissao ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
            endif

            nLinAtu += nTamLin+10
            oPrintPvt:SayAlign(nLinAtu, COL_GRUPO, "Responsável  :" ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
            oPrintPvt:SayAlign(nLinAtu, COL_GRUPO+50, "________________________________________" ,oFontDet, 00300, nTamLin, COR_PRETO, PAD_LEFT, 0)
            nLinAtu += nTamLin

            //Se ainda tiver linhas sobrando na página, imprime o rodapé final
            If nLinAtu <= nLinFin
                fImpRod()
            EndIf

            //Finalizando a página e somando mais um
            oPrintPvt:EndPage()
        EndIf
        SC5->(dbSkip())
    EndDo
         
    // //Se ainda tiver linhas sobrando na página, imprime o rodapé final
    // If nLinAtu <= nLinFin
    //     fImpRod()
    // EndIf
     
    //Mostrando o relatório
    oPrintPvt:Preview()
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
     
    nPagAtu++
Return
//-------------------------------------------------------------------
//  Ajusta o arquivo de perguntas SX1
//-------------------------------------------------------------------
Static Function CriaSx1(cPerg)

	u_HMPutSX1(cPerg, "01", PADR("Do Pedido        ",29)+"?" ,"","", "mv_ch1" , "C", 6  , 0, 0, "G", "","SC5", "", "", "mv_par01")
	u_HMPutSX1(cPerg, "02", PADR("Ate Pedido       ",29)+"?" ,"","", "mv_ch2" , "C", 6  , 0, 0, "G", "","SC5", "", "", "mv_par02")  
	u_HMPutSX1(cPerg, "03", PADR("Ano              ",29)+"?" ,"","", "mv_ch2" , "C", 4  , 0, 0, "G", "","   ", "", "", "mv_par03")  

Return
