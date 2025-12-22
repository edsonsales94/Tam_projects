#include "Protheus.ch"
#include "Rwmake.ch"
#include "Font.ch"
#include "RPTDEF.CH"
#include "FWPrintSetup.ch"

#DEFINE COLINI  30
#DEFINE COLFIM  2430
#DEFINE MAXCOLS 1960

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
6¦¦¦ Programa  ¦ DTFATR01  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 08/02/2023 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Impressão da Fatura de Serviço da Dantas                      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AMFATR03(cNumNF,cSerNF,cPathFile,cFilePrint,lMultiImp)
	Local aArea := SF2->(GetArea())
	Local cPerg := "DTFATR01"
	Local lOk   := .F.
	
	Default cNumNF     := ""
	Default cSerNF     := ""
	Default cPathFile  := ""
	Default cFilePrint := ProcName(0)
	Default lMultiImp  := .F.
	
	If IsBlind()
		__SetCentury("on")
	Endif
	
	Private cDocImp := CriaVar("F2_DOC"  ,.F.)
	Private cSerImp := CriaVar("F2_SERIE",.F.)
	
	If IsInCallStack("MATA410") .Or. IsBlind()
		cDocImp := SC5->C5_NOTA
		cSerImp := SC5->C5_SERIE
	ElseIf !Empty(cNumNF)
		cDocImp := cNumNF
		cSerImp := cSerNF
	Endif
	
	If Empty(cDocImp) .Or. cSerImp <> "LOC"
		FWAlertError("O documento para essa venda não é válida para impressão da fatura !")
	Else
		ValidPerg(cPerg)
		If lOk := Pergunte(cPerg,.T.)
			SA6->(dbSetOrder(1))
			If lOk := SA6->(dbSeek(XFILIAL("SA6")+mv_par01+mv_par02+mv_par03))
				SF2->(dbSetOrder(1))
				If lOk := SF2->(dbSeek(XFILIAL("SF2")+cDocImp+cSerImp))
					lOk := ReportDef(@cPathFile,@cFilePrint,lMultiImp)
				Endif
			Else
				FWAlertError("Banco informado não existe no sistema !")
			Endif
		Endif
	Endif
	SF2->(RestArea(aArea))
	
Return lOk

Static Function ReportDef(cPathFile,cFilePrint,lMultiImp)
	Local cDescri, nLin
	Local lAutoGeracao    := ( IsBlind() .Or. IsInCallStack("FISA022") )
	//Local nUsaPDF         := 6
	Local lVisualPDF      := If( lMultiImp , .F., If( lAutoGeracao , .F., .T.))   //Desabilita a viusalização do PDF (se via job)
	Local lAdjustToLegacy := .T.  //Habilita a compatibilidade com a classe TMSPrinter
	Local lDisableSetup   := If( lMultiImp , .T., If( lAutoGeracao , .T., .F.))   //Desabilita o setup de impressao (se via job)
	Local nMinPCC         := SuperGetMv("MV_VL13137", .F. , 0)
	Local nMinIRF         := SuperGetMv("MV_VLRETIR", .F. , 0)
	
	If !PrintReport()
		Return .F.
	Endif
	
	// Posiciona nas tabelas da nota
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(XFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
	SD2->(dbSetOrder(3))
	SD2->(dbSeek(XFILIAL("SD2")+SF2->F2_DOC+SF2->F2_SERIE,.T.))
	SC5->(dbSetOrder(1))
	SC5->(dbSeek(XFILIAL("SC5")+SD2->D2_PEDIDO))
	SE1->(dbSetOrder(2))
	SE1->(dbSeek(XFILIAL("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_PREFIXO+SF2->F2_DUPL))
	
	Private nDesconto := 0
	Private nTOTAL    := 0
	Private nDEDUCAO  := 0
	Private nBASEISS  := 0
	Private nALIQISS  := 0
	Private nVALISS   := SF2->F2_VALISS
	Private nValPis   := 0
	Private nValCof   := 0
	Private nValCSLL  := 0
	Private nValINSS  := IIf((SA1->A1_RECINSS <> "S" .Or. SF2->F2_VALINSS <= nMinPCC),0,SF2->F2_VALINSS)
	Private nValIR    := IIf((SA1->A1_RECIRRF <> "1" .Or. SF2->F2_VALIRRF <= nMinIRF),0,SF2->F2_VALIRRF)
	Private nValImps  := nVALISS + SF2->F2_VALIMP5 + SF2->F2_VALIMP6
	Private nAlqImps  := 0
	Private cServico  := ""
	
	While !SD2->(Eof()) .And. XFILIAL("SD2")+SF2->F2_DOC+SF2->F2_SERIE == SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE
		
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(XFILIAL("SB1")+SD2->D2_COD))
		
		nDesconto += SD2->D2_DESCON
		nAlqImps  := SD2->D2_ALIQISS + SD2->D2_ALQIMP5 + SD2->D2_ALQIMP6
		
		If Empty(cServico) .And. !Empty(SD2->D2_CODISS) .And. CCQ->(FieldPos("CCQ_XDESTE")) > 0
			cDescri  := Trim(Posicione("CCQ",1,XFILIAL("CCQ")+Trim(SD2->D2_CODISS),"CCQ_XDESTE"))
			cServico += If( Empty(cDescri) .Or. cDescri $ cServico , "", Trim(SD2->D2_CODISS) + " - " + cDescri)
		Endif
		
		SD2->(dbSkip())
	Enddo
	
	nTOTAL := SF2->F2_VALBRUT
	
	/*While !SF3->(Eof()) .And. XFILIAL("SF3")+SF2->F2_DOC+SF2->F2_SERIE == SF3->F3_FILIAL+SF3->F3_NFISCAL+SF3->F3_SERIE
		
		If SF3->F3_CLIEFOR+SF3->F3_LOJA == SF2->F2_CLIENTE+SF2->F2_LOJA .And. Empty(SF3->F3_DTCANC)
			nTOTAL   += SF3->F3_VALCONT
			nDEDUCAO += SF3->F3_ISSSUB + SF3->F3_ISSMAT
			nBASEISS += SF3->F3_BASEICM
			nALIQISS := SF3->F3_ALIQICM
		Endif
		
		SF3->(dbSkip())
	Enddo*/
	
	If (SF2->F2_VALPIS + SF2->F2_VALCOFI + SF2->F2_VALCSLL) > nMinPCC
		nValPis  := If( SA1->A1_RECPIS  == "S" , SF2->F2_VALPIS , 0)
		nValCof  := If( SA1->A1_RECCOFI == "S" , SF2->F2_VALCOFI, 0)
		nValCSLL := If( SA1->A1_RECCSLL == "S" , SF2->F2_VALCSLL, 0)
	EndIf 
	
	Private oPrn, oFont13, oFont13N, oFont14N, oFont15N, oFont16N, oFont18N
	
	cFilePrint := "NFS_" + Trim(SF2->F2_DOC)
	
	If File(cPathFile+cFilePrint+".pdf")
		FErase(cPathFile+cFilePrint+".pdf")
	Endif
	
	Conout(FunName()+" >>> Gerando PDF para a NF " + cPathFile+cFilePrint+".pdf" )
	
	oPrn := FWMSPrinter():New(cFilePrint+".pdf", IMP_PDF, lAdjustToLegacy, cPathFile, lDisableSetup, , , ,.T. , , , lVisualPDF, )
	
	oPrn:SetResolution(78)
	oPrn:SetPortrait()
	oPrn:SetPaperSize(DMPAPER_A4)
	oPrn:SetMargin(50,50,50,50)
	
	If lAutoGeracao .Or. lMultiImp
		oPrn:cPathPDF := cPathFile
	Endif
	cPathFile := oPrn:cPathPDF
	
	oPrn:SetParm("+RFS")
	
	oFont13  := TFontEx():New(oPrn,"Times New Roman",13,13,.F.,.T.,.F.)
	oFont13A := TFontEx():New(oPrn,"Arial",13,13,.F.,.T.,.F.)
	
	oFont13N := TFontEx():New(oPrn,"Arial",13,13,.T.,.T.,.F.)
	oFont14N := TFontEx():New(oPrn,"Times New Roman",14,14,.T.,.T.,.F.)
	oFont15N := TFontEx():New(oPrn,"Times New Roman",15,15,.T.,.T.,.F.)
	oFont16N := TFontEx():New(oPrn,"Times New Roman",16,16,.T.,.T.,.F.)
	oFont18N := TFontEx():New(oPrn,"Arial",18,18,.T.,.T.,.F.)
	
	nLin := Cabecalho()
	nLin := RodapeRel(nLin)
	
	oPrn:Preview()     // Visualiza antes de imprimir
	FreeObj(oPrn)
	oPrn := Nil
	
	//If File(cPathFile+cFilePrint+".rel")
	//	FErase(cPathFile+cFilePrint+".rel")
	//Endif
	
	cFilePrint += ".pdf"
	
Return .T.

Static Function ImprimeValor(nLin,nCol,cValor,oFonte,cSimbolo)
	Local nX
	Local nRet := 0
	
	Default cSimbolo := ""
	
	For nX:=1 To Len(cValor)
		If SubStr(cValor,nX,1) == " "
			nRet += 18
		ElseIf SubStr(cValor,nX,1) $ ".,"
			nRet += 6
		Endif
	Next
	oPrn:Say(nLin,nCol+nRet,cSimbolo + If(Empty(cSimbolo),"",Space(10)) + LTrim(cValor),oFonte,,,,3)

Return

Static Function Cabecalho()
	Local nX
	Local cExtenso := "VALOR R$ "+LTrim(Transform(SF2->F2_VALFAT,"@E 999,999,999.99")) + " (" + Extenso(SF2->F2_VALFAT) + ")"
	Local aLinExt  := LinhaTexto(cExtenso       ,oFont14N:oFont)
	Local aLinMsg  := LinhaTexto(SC5->C5_XMSGNFS,oFont13A:oFont)
	Local nLin     := 30
	
	//ImpCarac(oFont13A:oFont)
	
	oPrn:SetPortrait() // Estilo retrato
	oPrn:StartPage()   // Inicia uma nova página
	
	oPrn:Box (nLin,COLINI,nLin+2220,COLFIM)
	oPrn:SayBitmap(nLin+15,60,GetSrvProfString("Startpath","")+"DANTAS.PNG",650,200)
	oPrn:Line(nLin,750,nLin+220,750)
	nLin += 50
	oPrn:Say(nLin,800,Trim(SM0->M0_ENDENT) + ", " + Trim(SM0->M0_BAIRENT),oFont15N:oFont,,,,3)
	nLin += 50
	oPrn:Say(nLin,800,"MUNICIPIO: " +Trim(SM0->M0_CIDENT)+ " - ESTADO: " + NomeEstado(SM0->M0_ESTENT),oFont15N:oFont,,,,3)
	nLin += 50
	oPrn:Say(nLin,800,"C.N.P. J: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),oFont15N:oFont,,,,3)
	oPrn:Say(nLin,1700,"INSC. ESTADUAL: " + Trim(SM0->M0_INSC),oFont15N:oFont,,,,3)
	nLin += 50
	oPrn:Say(nLin,800,"INSC. MUNICIPAL: " + Transform(SM0->M0_INSCM,"@R 99.999-99"),oFont15N:oFont,,,,3)
	oPrn:Say(nLin,1700,"DATA EMISSAO: " + StrTran(DtoC(SF2->F2_EMISSAO),"/","."),oFont15N:oFont,,,,3)
	nLin += 20
	oPrn:Line(nLin,COLINI,nLin,COLFIM)
	nLin += 50
	oPrn:Say(nLin,80,"CONTA P/ DEPÓSITO: " +Trim(SA6->A6_NOME)+ " AG. "+Trim(SA6->A6_AGENCIA)+If(Empty(SA6->A6_DVAGE),"","-"+SA6->A6_DVAGE)+" CONTA "+Trim(SA6->A6_NUMCON)+If(Empty(SA6->A6_DVCTA),"","-"+SA6->A6_DVCTA),oFont14N:oFont,,,,3)
	nLin += 20
	oPrn:Line(nLin,COLINI,nLin,COLFIM)
	nLin += 50
	oPrn:Say(nLin,  80,"NATUREZA DA OPERAÇÃO: 03.01.1",oFont16N:oFont,,,,3)
	oPrn:Say(nLin,1400,"FATURA DE LOCAÇÃO No. " + SF2->F2_DOC,oFont16N:oFont,,,,3)
	nLin += 50
	oPrn:Say(nLin,80,"LOCAÇÃO DE BENS MÓVEIS",oFont16N:oFont,,,,3)
	nLin += 20
	oPrn:Line(nLin,COLINI,nLin,COLFIM)
	nLin += 50
	oPrn:Say(nLin,1000,"TOMADOR DO SERVIÇO",oFont16N:oFont,,,,3)
	nLin += 20
	oPrn:Line(nLin,COLINI,nLin,COLFIM)
	nLin += 50
	oPrn:Say(nLin,80,"NOME DO SACADO: " + Trim(SA1->A1_NOME),oFont16N:oFont,,,,3)
	nLin += 50
	//oPrn:Say(nLin,515,"AMAZONAS - ADS",oFont16N:oFont,,,,3)
	nLin += 80
	oPrn:Say(nLin,80,"CNPJ: " + Transform(SA1->A1_CGC,"@R 99.999.999/9999-99") ,oFont16N:oFont,,,,3)
	nLin += 80
	oPrn:Say(nLin,80,"ENDEREÇO: " + Trim(SA1->A1_END),oFont16N:oFont,,,,3)
	nLin += 50
	//oPrn:Say(nLin,380,"JAPIIM",oFont16N:oFont,,,,3)
	nLin += 80
	oPrn:Say(nLin,80,"CEP: " + Transform(SA1->A1_CEP,"@R 99999-999"),oFont16N:oFont,,,,3)
	nLin += 80
	oPrn:Say(nLin,80,"MUNICÍPIO: "+Trim(SA1->A1_MUN)+"    ESTADO: " + NomeEstado(SA1->A1_EST),oFont16N:oFont,,,,3)
	nLin += 20
	oPrn:Line(nLin,COLINI,nLin,COLFIM)
	
	nLin += 50
	For nX:=1 To Len(aLinExt)
		oPrn:Say(nLin+(nX-1)*50,80,aLinExt[nX],oFont14N:oFont,,,,3)
	Next
	nLin += 50
	//oPrn:Say(nLin,80,"E NOVENTA E CINCO CENTAVOS)",oFont14N:oFont,,,,3)
	
	nLin += 20
	oPrn:Line(nLin,COLINI,nLin,COLFIM)
	nLin += 50
	oPrn:Say(nLin,80,"RECONHEÇO (EMOS) A EXATIDÃO DESTA FATURA DE PRESTAÇÃO DE SERVIÇOS, NA IMPORTÂNCIA ACIMA, QUE PAGAREMOS A ",oFont13:oFont,,,,3)
	nLin += 50
	oPrn:Say(nLin,80,"DANTAS TRANSPORTES E INSTALACOES LTDA OU A SUA ORDEM NA PRAÇA E VENCIMENTOS INDICADOS.",oFont13:oFont,,,,3)
	nLin += 50
	//oPrn:Say(nLin,80,"INDICADOS.",oFont13:oFont,,,,3)
	
	nLin += 20
	oPrn:Line(nLin,COLINI,nLin,COLFIM)
	nLin += 50
	oPrn:Say(nLin,900,"DISCRIMINAÇÃO DOS SERVIÇOS",oFont15N:oFont,,,,3)
	nLin += 20
	oPrn:Line(nLin,COLINI,nLin,COLFIM)
	
	For nX:=1 To Len(aLinMsg)
		oPrn:Say(nLin+nX*50,40,aLinMsg[nX],oFont13A:oFont,,,,3)
	Next
	
	nLin += 50
	//oPrn:Say(nLin,80,"SERVICO DE LOCACAO DE VEICULOS TIPO CAMINHAO BAU, COM MANUTENCAO, SEM",oFont13:oFont,,,,3)
	nLin += 50
	//oPrn:Say(nLin,80,"FORNECIMENTO DE CONDUTORES E COMBUSTIVEL.",oFont13:oFont,,,,3)
	nLin += 70
	//oPrn:Say(nLin,80,"VEICULOS DE PLACA:",oFont13:oFont,,,,3)
	nLin += 70
	//oPrn:Say(nLin,80,"QZM-8G16 / QZM-8H66 / QZM-8H16 / PHZ-5E02 / PHZ-5E22",oFont13:oFont,,,,3)
	nLin += 50
	//oPrn:Say(nLin,80,"QZM-8H76 / QZM-8F86 / QZM-8I06 / QZM-8F36 / QZM-3J46",oFont13:oFont,,,,3)
	nLin += 70
	
Return nLin

Static Function NomeEstado(cUF)
Return Trim(Posicione("SX5",1,Space(Len(cFilAnt))+"12"+cUF,"X5_DESCRI"))

Static Function LinhaTexto(cTexto,oFont,nTam)
	Local cLinha
	Local aRet := {}
	
	Default nTam := MAXCOLS
	
	Private aCarac := MontaTamanho(oFont)
	
	cTexto := AllTrim(cTexto)
	While !Empty( cLinha := QuebraLinha(cTexto,oFont,nTam,Len(aRet)+1) )
		AAdd( aRet , cLinha )
	Enddo

Return aRet

Static Function RodapeRel(nLin)
	Local nX, nY
	Local nBRUTO  := nTOTAL
	//Local nISSQN  := If( SF2->F2_RECISS == "1" , nVALISS, 0)
	//Local nTOTRET := nISSQN + nValINSS + nValPis + nValCof + nValCSLL + nValIR
	Local aLinha  := {}
	Local aLines  := {}
	Local aTexto  := {}
	
	//nTOTAL := nBRUTO - nTOTRET
	
	AAdd( aTexto , "DADOS ADICIONAIS: OPERACAO NAO SUJEITA A EMISSAO DE NOTA FISCAL DE SERVICO." )
	AAdd( aTexto , "VEDADA A COBRANCA DE I.S. S CONFORME LEI COMPLEMENTAR Nº 116 DE 31.07.2003 E DECRETO MUNICIPAL Nº 043 DE 04 DE MARCO DE 2009." )
	
	For nX:=1 To Len(aTexto)
		aLines := LinhaTexto(aTexto[nX],oFont13A:oFont)
		For nY:=1 To Len(aLines)
			AAdd( aLinha , aLines[nY] )
		Next
	Next
	
	oPrn:Say(nLin,80,"REFERENTE AO PERIODO DE 01 A 31 DE DEZEMBRO DE 2022.",oFont13:oFont,,,,3)
	nLin += 250
	oPrn:Line(nLin,COLINI,nLin,COLFIM)
	nLin += 50
	oPrn:Say(nLin,800,"VALOR TOTAL: R$ " + LTrim(Transform(nBRUTO,"@E 999,999,999.99")),oFont18N:oFont,,,,3)
	nLin += 30
	oPrn:Line(nLin,COLINI,nLin,COLFIM)
	
	For nX:=1 To Len(aLinha)
		oPrn:Say(nLin+nX*50,80,aLinha[nX],oFont13A:oFont,,,,3)
	Next
	
	nLin += 320 + 150
	oPrn:Say(nLin,230,"Andre Luiz Brandao da Silva",oFont14N:oFont,,,,3)
	nLin += 100
	oPrn:Line(nLin,200,nLin,720)
	nLin += 40
	oPrn:Say(nLin,260,"Gerente Administrativo",oFont14N:oFont,,,,3)
	
	oPrn:EndPage()     // Finaliza a página

Return nLin

Static Function PrintReport()
	Local lOk := .F.

	cQry := "SELECT SF2.F2_DOC, SF2.F2_SERIE"
	cQry += " FROM "+RetSQLName("SF2")+" SF2"
	//cQry += " INNER JOIN "+RetSQLName("SF3")+" SF3 ON SF3.D_E_L_E_T_ = ' '"
	//cQry += " AND SF3.F3_FILIAL = SF2.F2_FILIAL"
	//cQry += " AND SF3.F3_NFISCAL = SF2.F2_DOC"
	//cQry += " AND SF3.F3_SERIE = SF2.F2_SERIE"
	//cQry += " AND SF3.F3_CLIEFOR = SF2.F2_CLIENTE"
	//cQry += " AND SF3.F3_LOJA = SF2.F2_LOJA"
	//cQry += " AND SF3.F3_DTCANC = ' '"
	cQry += " WHERE SF2.D_E_L_E_T_ = ' '"
	cQry += " AND SF2.F2_FILIAL = '"+SF2->(XFILIAL("SF2"))+"'"
	cQry += " AND SF2.F2_DOC = '"+cDocImp+"'"
	cQry += " AND SF2.F2_SERIE = '"+cSerImp+"'"
	cQry += " AND SF2.F2_ESPECIE = ' '"
	//cQry += " AND SF2.F2_NFELETR <> ' '"
	cQry += " GROUP BY SF2.F2_DOC, SF2.F2_SERIE"
	
	DbUseArea(.t.,"TOPCONN",TcGenQry(,,cQry),"QRY")
	
	If QRY->(Bof()) .And. QRY->(Eof())
		If IsBlind()
			Conout(FunName()+": Não foram encontrados dados para os parâmetros informados: " + cFilAnt + " - " + cDocImp + " - " + cSerImp)
		Else
			FWAlertError("Não foram encontrados dados para os parâmetros informados !")
		Endif
	Else
		lOk := .T.
		
		// Posiciona nos registros das tabelas
		SF2->(dbSetOrder(1))
		SF2->(dbSeek(XFILIAL("SF2")+QRY->F2_DOC+QRY->F2_SERIE))
		//SF3->(dbSetOrder(5))
		//SF3->(dbSeek(XFILIAL("SF3")+QRY->F2_SERIE+QRY->F2_DOC))
	Endif
	
	QRY->(DbCloseArea())
	
Return lOk

Static Function QuebraLinha(cString,oFont,nMax,nLinha)
	Local nQ, nL, nTam, aPlv, nP, cBkp
	Local aBreak := Separa(AllTrim(cString),Chr(13)+Chr(10),.F.)
	Local cRet   := ""
	Local aLinha := {}
	
	nLinha := If( nLinha == Nil , 1, Max(1,nLinha))
	
	For nQ:=1 To Len(aBreak)
		nTam := 0
		cRet := ""
		aPlv := Separa(aBreak[nQ]," ",.F.)   // Separa as palavras
		For nP:=1 To Len(aPlv)
			cBkp := cRet
			For nL:=1 To Len(aPlv[nP])
				cCar := SubStr(aPlv[nP],nL,1)
				cRet += cCar
				nTam += TamText(cCar,oFont) + 7
				If nTam > nMax
					AAdd( aLinha , If( nL < Len(aPlv[nP]) , cBkp, cRet) )
					nTam := 0
					cRet := ""
					If nL < Len(aPlv[nP])
						nP--
						Exit
					Endif
				Endif
			Next
			If nP < Len(aPlv) .And. !Empty(cRet)
				cRet += " "                      // Adiciona o espaço em branco entre as palavras
				nTam += TamText(" ",oFont) + 7   // Soma o espaço em branco entre as palavras
			Endif
		Next
		If !Empty(cRet)
			AAdd( aLinha , cRet )
		Endif
	Next
	
	If nLinha <= Len(aLinha)
		cRet := AllTrim(aLinha[nLinha])
	Else
		cRet := ""
	Endif
	
Return cRet

Static Function TamText(cString,oFont)
	Local nPos   := AScan( aCarac , {|x| x[1] == cString })
	Local nRet   := 6
	If nPos > 0
		nRet := aCarac[nPos,2]
	Else
		nRet := nRet
	Endif
Return nRet

Static Function MontaTamanho(oFont)
	Local aRet
	
	// Anterior
	/*Local aRet := {	{"A", 15},{"B", 15},{"C", 16},{"D", 16},{"E", 15},{"F", 13},{"G", 17},{"H", 16},{"I",  6},{"J", 11},{"K", 15},{"L", 12},{"M", 19},{"N", 16},{"O", 17},{"P", 15},{"Q", 17},{"R", 16},;
					{"S", 15},{"T", 14},{"U", 16},{"V", 15},{"W", 21},{"X", 15},{"Y", 14},{"Z", 13},{"a", 12},{"b", 12},{"c", 11},{"d", 12},{"e", 12},{"f",  7},{"g", 12},{"h", 11},{"i",  5},{"j",  4},;
					{"k", 10},{"l",  4},{"m", 18},{"n", 11},{"o", 13},{"p", 12},{"q", 12},{"r",  7},{"s", 11},{"t",  6},{"u", 11},{"v", 11},{"w", 15},{"x", 10},{"y", 11},{"z", 11},{"!",  6},{"@", 22},;
					{"#", 12},{"$", 12},{"%", 20},{"¨",  7},{"&", 15},{"*",  9},{"(",  7},{")",  7},{"_", 12},{"+", 13},{"-",  7},{"=", 13},{"|",  6},{"\",  6},{"<", 13},{",",  6},{">", 13},{".",  6},;
					{":",  6},{";",  6},{"?", 12},{"/",  6},{"{",  7},{"[",  6},{"}",  7},{" ",  6},{"'",  6},{'"',  9},;
					{"0", 12},{"1",  8},{"2", 12},{"3", 12},{"4", 12},{"5", 12},{"6", 12},{"7", 12},{"8", 12},{"9", 12},;
					{"Á", 15},{"Ã", 15},{"Â", 15},{"À", 15},{"á", 12},{"ã", 12},{"â", 12},{"à", 12},;
					{"É", 15},{"Ê", 15},{"é", 12},{"è", 12},;
					{"Í",  6},{"Ì",  6},{"Î",  6},{"í",  5},{"ì",  5},{"î",  5},;
					{"Ó", 17},{"Ò", 17},{"Õ", 17},{"Ô", 17},{"ó", 13},{"ò", 13},{"õ", 13},{"ô", 13},;
					{"Ú", 16},{"Ù", 16},{"Û", 16},{"ú", 11},{"ù", 11},{"û", 11},;
					{"Ñ", 16},{"ñ", 11},{"Ç", 16},{"ç", 16}}*/
	// Tamanto 14
	/*Local aRet := { {"A", 15},{"B", 15},{"C", 17},{"D", 17},{"E", 15},{"F", 14},{"G", 18},{"H", 17},{"I",  6},{"J", 12},{"K", 15},{"L", 13},{"M", 19},{"N", 17},{"O", 18},;
					{"P", 15},{"Q", 18},{"R", 17},{"S", 15},{"T", 14},{"U", 17},{"V", 15},{"W", 23},{"X", 15},{"Y", 14},{"Z", 14},{"a", 13},{"b", 12},{"c", 12},{"d", 12},;
					{"e", 13},{"f",  7},{"g", 12},{"h", 12},{"i",  5},{"j",  4},{"k", 11},{"l",  4},{"m", 18},{"n", 12},{"o", 13},{"p", 12},{"q", 12},{"r",  8},{"s", 12},;
					{"t",  6},{"u", 12},{"v", 11},{"w", 15},{"x", 11},{"y", 11},{"z", 11},{"!" , 8},{"@", 23},{"#", 13},{"$", 13},{"%", 20},{"¨",  8},{"&", 15},{"*",  9},;
					{"(",  8},{")",  8},{"_", 13},{"+", 13},{"-",  8},{"=", 13},{"|",  6},{"\",  6},{"<", 13},{",",  6},{">", 13},{".",  6},{":",  6},{";",  6},{"?", 13},;
					{"/",  6},{"{",  8},{"[",  6},{"}",  8},{" ",  6},{"'",  4},{'"',  8},{"0", 13},{"1", 13},{"2", 13},{"3", 13},{"4", 13},{"5", 13},{"6", 13},{"7", 13},;
					{"8", 13},{"9", 13},{"Á", 15},{"Ã", 15},{"Â", 15},{"À", 15},{"á", 13},{"ã", 13},{"â", 13},{"à", 13},{"É", 15},{"Ê", 15},{"é", 13},{"è", 13},{"Í",  6},;
					{"Ì",  6},{"Î",  6},{"í",  6},{"ì",  6},{"î",  6},{"Ó", 18},{"Ò", 18},{"Õ", 18},{"Ô", 18},{"ó", 13},{"ò", 13},{"õ", 13},{"ô", 13},{"Ú", 17},{"Ù", 17},;
					{"Û", 17},{"ú", 13},{"ù", 13},{"û", 13},{"Ñ", 17},{"ñ", 13},{"Ç", 17},{"ç", 12}}*/
	// Tamanho 12
	Local aPadrao := {	{"A",13},{"B",13},{"C",14},{"D",14},{"E",13},{"F",12},{"G",16},{"H",13},{"I", 6},{"J",10},{"K",13},{"L",11},{"M",17},{"N",13},{"O",16},{"P",13},{"Q",16},;
						{"R",14},{"S",13},{"T",12},{"U",13},{"V",13},{"W",19},{"X",13},{"Y",14},{"Z",12},{"a",11},{"b",11},{"c",10},{"d",11},{"e",11},{"f", 6},{"g",11},{"h",10},;
						{"i", 4},{"j", 4},{"k",10},{"l", 4},{"m",16},{"n",10},{"o",11},{"p",11},{"q",11},{"r", 7},{"s",10},{"t", 6},{"u",10},{"v", 9},{"w",15},{"x", 9},{"y",10},;
						{"z", 9},{"!", 6},{"@",20},{"#",11},{"$",11},{"%",18},{"¨", 7},{"&",13},{"*", 8},{"(", 7},{")", 7},{"_",11},{"+",12},{"-", 7},{"=",12},{"|", 6},{"\", 6},;
						{"<",12},{",", 6},{">",12},{".", 6},{":", 6},{";", 6},{"?",11},{"/", 6},{"{", 7},{"[", 6},{"}", 7},{" ", 6},{"'", 4},{'"', 7},{"0",11},{"1",11},{"2",11},;
						{"3",11},{"4",11},{"5",11},{"6",11},{"7",11},{"8",11},{"9",11},{"Á",13},{"Ã",13},{"Â",13},{"À",13},{"á",11},{"ã",11},{"â",11},{"à",11},{"É",13},{"Ê",13},;
						{"é",11},{"è",11},{"Í", 6},{"Ì", 6},{"Î", 6},{"í", 6},{"ì", 6},{"î", 6},{"Ó",16},{"Ò",16},{"Õ",16},{"Ô",16},{"ó",11},{"ò",11},{"õ",11},{"ô",11},{"Ú",14},;
						{"Ù",14},{"Û",14},{"ú",11},{"ù",11},{"û",11},{"Ñ",14},{"ñ",11},{"Ç",14},{"ç",10}}
	
	Local aTNew14N := { {"A",13},{"B",13},{"C",14},{"D",14},{"E",13},{"F",12},{"G",15},{"H",14},{"I", 7},{"J",10},{"K",14},{"L",12},{"M",18},{"N",14},{"O",15},{"P",12},{"Q",15},;
						{"R",14},{"S",11},{"T",13},{"U",13},{"V",13},{"W",19},{"X",13},{"Y",13},{"Z",12},{"a",10},{"b",10},{"c", 9},{"d",10},{"e", 9},{"f", 6},{"g",10},{"h",10},;
						{"i", 5},{"j", 6},{"k",11},{"l", 5},{"m",15},{"n",10},{"o",10},{"p",10},{"q",10},{"r", 8},{"s", 8},{"t", 6},{"u",10},{"v", 9},{"w",14},{"x", 9},{"y", 9},;
						{"z", 8},{"!", 5},{"@",18},{"#",10},{"$",10},{"%",18},{"¨", 8},{"&",16},{"*",10},{"(", 6},{")", 6},{"_",10},{"+",11},{"-", 6},{"=",11},{"|", 3},{"\", 5},;
						{"<",11},{",", 5},{">",11},{".", 5},{":", 5},{";", 5},{"?",10},{"/", 5},{"{", 7},{"[", 6},{"}", 7},{" ", 5},{"'", 5},{'"',11},{"0",10},{"1",10},{"2",10},;
						{"3",10},{"4",10},{"5",10},{"6",10},{"7",10},{"8",10},{"9",10},{"Á",13},{"Ã",13},{"Â",13},{"À",13},{"á",10},{"ã",10},{"â",10},{"à",10},{"É",13},{"Ê",13},;
						{"é", 9},{"è", 9},{"Í", 7},{"Ì", 7},{"Î", 7},{"í", 5},{"ì", 5},{"î", 5},{"Ó",15},{"Ò",15},{"Õ",15},{"Ô",15},{"ó",10},{"ò",10},{"õ",10},{"ô",10},{"Ú",13},;
						{"Ù",13},{"Û",13},{"ú",10},{"ù",10},{"û",10},{"Ñ",14},{"ñ",10},{"Ç",14},{"ç", 9}}
	
	Local aAria13A := { {"A",11},{"B",11},{"C",12},{"D",12},{"E",11},{"F",10},{"G",12},{"H",11},{"I", 5},{"J", 9},{"K",11},{"L", 9},{"M",13},{"N",11},{"O",12},{"P",11},{"Q",12},;
						{"R",11},{"S",11},{"T", 9},{"U",11},{"V",11},{"W",17},{"X",11},{"Y",11},{"Z", 9},{"a", 9},{"b", 9},{"c", 9},{"d", 9},{"e", 9},{"f", 5},{"g", 9},{"h", 9},;
						{"i", 4},{"j", 3},{"k", 8},{"l", 3},{"m",13},{"n", 9},{"o", 9},{"p", 9},{"q", 9},{"r", 6},{"s", 8},{"t", 4},{"u", 9},{"v", 7},{"w",11},{"x", 7},{"y", 9},;
						{"z", 8},{"!", 5},{"@",17},{"#", 9},{"$", 9},{"%",15},{"¨", 6},{"&",11},{"*", 7},{"(", 6},{")", 6},{"_", 9},{"+",10},{"-", 6},{"=",10},{"|", 5},{"\", 5},;
						{"<",10},{",", 5},{">",10},{".", 5},{":", 5},{";", 5},{"?", 9},{"/", 5},{"{", 6},{"[", 5},{"}", 6},{" ", 5},{"'", 3},{'"', 6},{"0", 9},{"1", 9},{"2", 9},;
						{"3", 9},{"4", 9},{"5", 9},{"6", 9},{"7", 9},{"8", 9},{"9", 9},{"Á",11},{"Ã",11},{"Â",11},{"À",11},{"á", 9},{"ã", 9},{"â", 9},{"à", 9},{"É",11},{"Ê",11},;
						{"é", 9},{"è", 9},{"Í", 5},{"Ì", 5},{"Î", 5},{"í", 5},{"ì", 5},{"î", 5},{"Ó",12},{"Ò",12},{"Õ",12},{"Ô",12},{"ó", 9},{"ò", 9},{"õ", 9},{"ô", 9},{"Ú",11},;
						{"Ù",11},{"Û",11},{"ú", 9},{"ù", 9},{"û", 9},{"Ñ",11},{"ñ", 9},{"Ç",12},{"ç", 9}}


	If Trim(oFont:Name) == "Times New Roman"
		aRet := aClone(aTNew14N)
	ElseIf Trim(oFont:Name) == "Arial"
		aRet := aClone(aAria13A)
	Else
		aRet := aClone(aPadrao)
	Endif

Return aRet

Static Function ImpCarac(oFont)
	Local nHdl, nX, cLin
	Local aVetor := MontaTamanho(oFont)
	Local cFile  := "C:\TEMP\CARACTER.TXT"
	If File(cFile)
		FErase(cFile)
	Endif
	nHdl := fCreate(cFile)
	If nHdl == -1
		Conout("Erro na criacao do arquivo "+cFile)
	Else
		For nX:=1 To Len(aVetor)
			aVetor[nX,2] := oPrn:getTextWidth(aVetor[nX,1], oFont, 1)
			cLin := '{"'+aVetor[nX,1] + '"},{' + LTrim(Str(aVetor[nX,2])) + '},' + Chr(13) + Chr(10)
			FWrite(nHdl,cLin,Len(cLin))
		Next
		FClose(nHdl)
	Endif
Return

Static Function ValidPerg(cPerg)
	u_DTPutSX1(cPerg,"01",PADR("Banco  ",29)+"?","","","mv_ch1","C",TamSX3("A6_COD"    )[1],0,0,"G","","SA6","","","mv_par01")
	u_DTPutSX1(cPerg,"02",PADR("Agencia",29)+"?","","","mv_ch2","C",TamSX3("A6_AGENCIA")[1],0,0,"G","","   ","","","mv_par02")
	u_DTPutSX1(cPerg,"03",PADR("Conta  ",29)+"?","","","mv_ch3","C",TamSX3("A6_NUMCON" )[1],0,0,"G","","   ","","","mv_par03")
Return
