#include "Protheus.ch"
#include "Rwmake.ch"
#include "Font.ch"
#include "RPTDEF.CH"
#include "FWPrintSetup.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ SNFATR01   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 28/12/2021 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Impressão da Nota Fiscal de Serviço da Itacol                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AMFATR02(cNumNF,cSerNF,cPathFile,cFilePrint,lMultiImp)
	Local aArea := SF2->(GetArea())
	Local cPerg := PADR("SNFATR01",Len(SX1->X1_GRUPO))
	Local lOk   := .F.
	
	Default cNumNF     := ""
	Default cSerNF     := ""
	Default cPathFile  := ""
	Default cFilePrint := ProcName(0)
	Default lMultiImp  := .F.
	
	If IsBlind()
		__SetCentury("on")
	Endif
	
	If Type("cThreadID") == "U" .Or. Empty(cThreadID)
		cThreadID := StrZero(ThreadID(),6)
	Endif
	Conout("["+Dtoc(dDataBase)+" "+Time()+"]["+cThreadID+"] >>> Iniciando geracao do PDF " + cFilePrint )
	
	ValidPerg(cPerg)
	
	If Empty(cNumNF)
		lOk := Pergunte(cPerg,.T.)
	Else
		lOk      := .T.
		mv_par01 := cNumNF
		mv_par02 := cSerNF
	Endif
	
	If lOk
		lOk := ReportDef(@cPathFile,@cFilePrint,lMultiImp)
	Endif
	SF2->(RestArea(aArea))
	
Return lOk

Static Function ReportDef(cPathFile,cFilePrint,lMultiImp)
	Local cDescri
	Local lAutoGeracao    := ( IsBlind() .Or. IsInCallStack("FISA022") )
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
		
		If Empty(cServico) .And. !Empty(SD2->D2_CODISS)
		//	cDescri  := Trim(Posicione("CCQ",1,XFILIAL("CCQ")+Trim(SD2->D2_CODISS),"CCQ_XDESTE"))
			cServico += If( Empty(cDescri) .Or. cDescri $ cServico , "", Trim(SD2->D2_CODISS) + " - " + cDescri)
		Endif
		
		SD2->(dbSkip())
	Enddo
	
	While !SF3->(Eof()) .And. XFILIAL("SF3")+SF2->F2_DOC+SF2->F2_SERIE == SF3->F3_FILIAL+SF3->F3_NFISCAL+SF3->F3_SERIE
		
		If SF3->F3_CLIEFOR+SF3->F3_LOJA == SF2->F2_CLIENTE+SF2->F2_LOJA .And. Empty(SF3->F3_DTCANC)
			nTOTAL   += SF3->F3_VALCONT
			nDEDUCAO += SF3->F3_ISSSUB + SF3->F3_ISSMAT
			nBASEISS += SF3->F3_BASEICM
			nALIQISS := SF3->F3_ALIQICM
		Endif
		
		SF3->(dbSkip())
	Enddo
	
	If (SF2->F2_VALPIS + SF2->F2_VALCOFI + SF2->F2_VALCSLL) > nMinPCC
		nValPis  := If( SA1->A1_RECPIS  == "S" , SF2->F2_VALPIS , 0)
		nValCof  := If( SA1->A1_RECCOFI == "S" , SF2->F2_VALCOFI, 0)
		nValCSLL := If( SA1->A1_RECCSLL == "S" , SF2->F2_VALCSLL, 0)
	EndIf 
	
	Private oPrn, oFont13, oFont14, oFont17, oFont13N, oFont15N, oFont16N
	Private aCarac := MontaTamanho()
	
	cFilePrint := "NFS_" + Trim(SF2->F2_NFELETR)
	
	If File(cPathFile+cFilePrint+".pdf")
		FErase(cPathFile+cFilePrint+".pdf")
	Endif
	
	Conout("["+Dtoc(dDataBase)+" "+Time()+"]["+cThreadID+"] >>> Gerando PDF para a NF " + cPathFile+cFilePrint+".pdf" )
	
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
	
	oFont11 := TFontEx():New(oPrn,"Arial",11,11,.F.,.T.,.F.)
	oFont12 := TFontEx():New(oPrn,"Arial",12,12,.F.,.T.,.F.)
	oFont13 := TFontEx():New(oPrn,"Arial",13,13,.F.,.T.,.F.)
	oFont14 := TFontEx():New(oPrn,"Arial",14,14,.F.,.T.,.F.)
	oFont15 := TFontEx():New(oPrn,"Arial",15,15,.F.,.T.,.F.)
	oFont16 := TFontEx():New(oPrn,"Arial",16,16,.F.,.T.,.F.)
	oFont17 := TFontEx():New(oPrn,"Arial",17,17,.F.,.T.,.F.)
	oFont20 := TFontEx():New(oPrn,"Arial",20,20,.F.,.T.,.F.)
	oFont22 := TFontEx():New(oPrn,"Arial",22,22,.F.,.T.,.F.)
	
	oFont13N := TFontEx():New(oPrn,"Arial",13,13,.T.,.T.,.F.)
	oFont15N := TFontEx():New(oPrn,"Arial",15,15,.T.,.T.,.F.)
	oFont16N := TFontEx():New(oPrn,"Arial",18,18,.T.,.T.,.F.)
	
	Cabecalho()
	RodapeRel()
	
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
	Local aLinha := LinhaTexto(SC5->C5_XMSGNFS,oFont12:oFont,2440)
	
	//ImpCarac(MontaTamanho(),oFont12:oFont)
	
	oPrn:SetPortrait() // Estilo retrato
	oPrn:StartPage()   // Inicia uma nova página
	
	// DADOS DE IDENTIFICAÇÃO DA NOTA
	oPrn:Box (0,30,290,2465)
	oPrn:SayBitmap(20,65,GetSrvProfString("Startpath","")+"PMMANAUS.PNG",250,250)
	oPrn:Say(100,850,"PREFEITURA DE MANAUS",oFont22:oFont,,,,3)
	oPrn:Say(170,650,"Secretaria Municipal de Finanças e Tecnologia da",oFont20:oFont,,,,3)
	oPrn:Say(240,950,"Informação - SEMEF",oFont20:oFont,,,,3)
	oPrn:SayBitmap(5,2120,GetSrvProfString("Startpath","")+"LOGONOTA.PNG",280,280)
	oPrn:Box (305,30,535,2465)
	oPrn:Say(350,50,"Nota Fiscal de Serviços Eletrônica - NFS-e",oFont13N:oFont,,,,3)
	oPrn:Say(400,50,"A autenticidade desta nota pode ser confirmada",oFont17:oFont,,,,3)
	oPrn:Say(450,50,"em:",oFont17:oFont,,,,3)
	oPrn:Say(450,150,"nota.manaus.am.gov.br",oFont16N:oFont,,,,3)
	oPrn:Say(500,50,"informando o código de verificação.",oFont17:oFont,,,,3)
	oPrn:Box (305,1455,395,1955)
	oPrn:Line(305,1455,535,1455)
	oPrn:Say(330,1470,"Código de Verificação",oFont11:oFont,,,,3)
	oPrn:Say(380,1470,Trim(SF2->F2_CODNFE),oFont16:oFont,,,,3)
	oPrn:Say(17,0,"",,,,,3)
	oPrn:Say(330,1970,"Data e Hora da Emissão",oFont11:oFont,,,,3)
	oPrn:Say(380,1970,DtoC(SF2->F2_EMINFE)+" "+SF2->F2_HORNFE,oFont16:oFont,,,,3)
	oPrn:Box (395,1960,535,2465)
	oPrn:Say(420,1470,"Natureza da Operação",oFont11:oFont,,,,3)
	oPrn:Say(420,1970,"Número da Nota",oFont11:oFont,,,,3)
	oPrn:Say(510,1470,"Retenção do ISSQN",oFont16:oFont,,,,3)
	oPrn:Say(510,2150,Trim(SF2->F2_NFELETR),oFont22:oFont,,,,3)

	// DADOS DO PRESTADOR DE SERVIÇOS
	oPrn:Box (555,30,625,2465)
	oPrn:Say(605,1000,"Prestador de Serviços",oFont16:oFont,,,,3)
	oPrn:Box (623,30,963,2465)
  //oPrn:SayBitmap(660,80,GetSrvProfString("Startpath","")+"LGMID010101.PNG",300,250)
	oPrn:SayBitmap(660,80, "\system\lgrl"+cEmpAnt+cFilAnt+".bmp" , 300, 250)
	oPrn:Line(623,430,963,430)
	oPrn:Say(680,460,Trim(SM0->M0_NOMECOM),oFont15N:oFont,,,,3)
	oPrn:Say(730,460,Trim(SM0->M0_ENDCOB),oFont15:oFont,,,,3)
	oPrn:Say(780,460,Trim(SM0->M0_BAIRCOB) + ", Telefone: " + Trim(SM0->M0_TEL),oFont15:oFont,,,,3)
	oPrn:Say(830,460,"CEP "+Transform(SM0->M0_CEPCOB,"@R 99999-999")+" - "+Trim(SM0->M0_CIDCOB)+" - "+Trim(SM0->M0_ESTCOB)+" - BRASIL",oFont15:oFont,,,,3)
	oPrn:Say(880,460,"CPF/CNPJ " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),oFont15:oFont,,,,3)
	oPrn:Say(880,1670,"Inscrição Municipal",oFont15:oFont,,,,3)
	oPrn:Say(880,2140,Trim(SM0->M0_INSCM),oFont15:oFont,,,,3)
	oPrn:Say(930,460,"Email NACONTEC@HOTMAIL.COM",oFont15:oFont,,,,3)
	oPrn:Say(930,1670,"Inscrição Estadual",oFont15:oFont,,,,3)
	oPrn:Say(930,2140,Trim(SM0->M0_INSC),oFont15:oFont,,,,3)
	oPrn:Box (973,30,1053,2465)

	// DADOS DO TOMADOR DE SERVIÇOS
	oPrn:Say(1025,1040,"Tomador do Serviço",oFont16:oFont,,,,3)
	oPrn:Box (1053,30,1443,2465)
	oPrn:Say(1095,40,"Razão Social",oFont15:oFont,,,,3)
	oPrn:Say(1095,530,Trim(SA1->A1_NOME),oFont15:oFont,,,,3)
	oPrn:Say(1150,40,"CPF/CNPJ",oFont15:oFont,,,,3)
	oPrn:Say(1150,530,Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont15:oFont,,,,3)
	oPrn:Say(1205,40,"Endereço",oFont15:oFont,,,,3)
	oPrn:Say(1205,530,Trim(SA1->A1_END),oFont15:oFont,,,,3)
	oPrn:Say(1260,40,"Bairro",oFont15:oFont,,,,3)
	oPrn:Say(1260,530, Trim(SA1->A1_BAIRRO) + ", Telefone: " + Trim(SA1->A1_TEL),oFont15:oFont,,,,3)
	oPrn:Say(1315,40,"CEP",oFont15:oFont,,,,3)
	oPrn:Say(1315,530,Transform(SA1->A1_CEP,"@R 99999-999"),oFont15:oFont,,,,3)
	oPrn:Say(1370,40,"Cidade",oFont15:oFont,,,,3)
	oPrn:Say(1370,530,Trim(SA1->A1_MUN) + " - " +SA1->A1_EST+ " - BRASIL",oFont15:oFont,,,,3)
	oPrn:Say(1370,1570,"Inscrição Municipal",oFont15:oFont,,,,3)
	oPrn:Say(1370,2140,Trim(SA1->A1_INSCRM),oFont15:oFont,,,,3)
	oPrn:Say(1425,40,"Email",oFont15:oFont,,,,3)
	oPrn:Say(1425,530,Trim(SA1->A1_EMAIL),oFont15:oFont,,,,3)
	oPrn:Say(1425,1570,"Inscrição Estadual",oFont15:oFont,,,,3)
	oPrn:Say(1425,2140,Trim(SA1->A1_INSCR),oFont15:oFont,,,,3)
	
	// DADOS DO DISCRIMINAÇÃO DOS SERVIÇOS
	oPrn:Box (1460,30,1540,2465)
	oPrn:Say(1510,800,"Discriminação do Serviço / Dados Adicionais",oFont16:oFont,,,,3)
	oPrn:Box (1540,30,1808,2465)
	
	For nX:=1 To Len(aLinha)
		oPrn:Say(1530+nX*50,40,aLinha[nX],oFont12:oFont,,,,3)
	Next
	
	oPrn:Box (1810,30,1930,2465)
	oPrn:Say(1860,420,QuebraLinha(AllTrim(cServico),oFont15:oFont,1530,1),oFont15:oFont,,,,3)
	oPrn:Say(1880,40,"Serviço",oFont14:oFont,,,,3)
	oPrn:Say(1900,420,QuebraLinha(AllTrim(cServico),oFont15:oFont,1530,2),oFont15:oFont,,,,3)
	
Return 1900

Static Function LinhaTexto(cTexto,oFont,nTam)
	Local cLinha
	Local aRet := {}
	
	cTexto := AllTrim(cTexto)
	While !Empty( cLinha := QuebraLinha(cTexto,oFont,nTam,Len(aRet)+1) )
		AAdd( aRet , cLinha )
	Enddo

Return aRet

Static Function RodapeRel()
	Local nLin
	Local nBRUTO  := nTOTAL
	Local nISSQN  := If( SF2->F2_RECISS == "1" , nVALISS, 0)
	Local nTOTRET := nISSQN + nValINSS + nValPis + nValCof + nValCSLL + nValIR
	Local cQrCode := "https://nfse-prd.manaus.am.gov.br/nfse/servlet/wvalidarautenticidadenfse?" +Trim(SM0->M0_CGC)+ ","+;
						LTrim(Str(nBRUTO,14,2))+","+AllTrim(SF2->F2_NFELETR)+","+Trim(SF2->F2_CODNFE)
	
	nTOTAL := nBRUTO - nTOTRET
	
	oPrn:Box (1928,30,2013,430)
	oPrn:Say(1958,40,"Valor do Serviço (R$)",oFont11:oFont,,,,3)
	ImprimeValor(1995,70,Transform(nBRUTO,"@E 999,999,999.99"),oFont14:oFont)
	//oPrn:Say(1995,155,"4.000,00",oFont14:oFont,,,,3)
	oPrn:Box (1928,428,2013,708)
	oPrn:Say(1958,438,"Qtd",oFont11:oFont,,,,3)
	oPrn:Say(1995,570,"1",oFont14:oFont,,,,3)
	oPrn:Box (1928,710,2013,985)
	oPrn:Say(1958,720,"Desconto (R$)",oFont11:oFont,,,,3)
	ImprimeValor(1995,620,Transform(nDesconto,"@E 999,999,999.99"),oFont14:oFont)
	//oPrn:Say(1995,830,"0,00",oFont14:oFont,,,,3)
	oPrn:Box (1928,985,2013,1260)
	oPrn:Say(1958,995,"Dedução (R$)",oFont11:oFont,,,,3)
	ImprimeValor(1995,900,Transform(nDEDUCAO,"@E 999,999,999.99"),oFont14:oFont)
	//oPrn:Say(1995,1105,"0,00",oFont14:oFont,,,,3)
	oPrn:Box (1928,1258,2013,1638)
	oPrn:Say(1958,1268,"Base de Cálculo (R$)",oFont11:oFont,,,,3)
	ImprimeValor(1995,1300,Transform(nBASEISS,"@E 999,999,999.99"),oFont14:oFont)
	//oPrn:Say(1995,1383,"4.000,00",oFont14:oFont,,,,3)
	oPrn:Box (1928,1640,2013,1850)
	oPrn:Say(1958,1650,"Alíquota (%)",oFont11:oFont,,,,3)
	oPrn:Say(1995,1600,Transform(nALIQISS,"@E 999,999,999.99"),oFont14:oFont,,,,3)
	//oPrn:Say(1995,1730,"5,00",oFont14:oFont,,,,3)
	oPrn:Box (1928,1850,2013,2125)
	oPrn:Say(1958,1860,"Valor do ISS (R$)",oFont11:oFont,,,,3)
	ImprimeValor(1995,1800,Transform(nVALISS,"@E 999,999,999.99"),oFont14:oFont)
	//oPrn:Say(1995,1940,"200,00",oFont14:oFont,,,,3)
	oPrn:Box (1928,2123,2013,2463)
	oPrn:Say(1958,2133,"Total (R$)",oFont11:oFont,,,,3)
	ImprimeValor(1995,2150,Transform(nBRUTO,"@E 999,999,999.99"),oFont14:oFont)
	//oPrn:Say(1995,2240,"4.000,00",oFont14:oFont,,,,3)
	
	oPrn:Box (2030,30,2110,2465)
	oPrn:Say(2080,900,"VALOR TOTAL DA NOTA = R$ " + LTrim(Transform(nBRUTO,"@E 999,999,999.99")),oFont16:oFont,,,,3)
	
	oPrn:Box (2125,30,2195,2465)
	oPrn:Say(2175,1100,"Retenções",oFont16:oFont,,,,3)
	oPrn:Box (2195,30,2325,515)
	oPrn:Say(2225,40,"INSS (R$)",oFont11:oFont,,,,3)
	ImprimeValor(2310,100,Transform(nValINSS  ,"@E 999,999,999.99"),oFont14:oFont)
	//oPrn:Say(2310,210,"440,00",oFont14:oFont,,,,3)
	oPrn:Box (2195,515,2325,1005)
	oPrn:Say(2225,525,"PIS (R$)",oFont11:oFont,,,,3)
	ImprimeValor(2310,650,Transform(nValPis  ,"@E 999,999,999.99"),oFont14:oFont)
	//oPrn:Say(2310,720,"26,00",oFont14:oFont,,,,3)
	oPrn:Box (2195,1005,2325,1490)
	oPrn:Say(2225,1015,"COFINS (R$)",oFont11:oFont,,,,3)
	ImprimeValor(2310,1100,Transform(nValCof  ,"@E 999,999,999.99"),oFont14:oFont)
	//oPrn:Say(2310,1190,"120,00",oFont14:oFont,,,,3)
	oPrn:Box (2195,1490,2325,1975)
	oPrn:Say(2225,1500,"C.S.L.L (R$)",oFont11:oFont,,,,3)
	ImprimeValor(2310,1600,Transform(nValCSLL,"@E 999,999,999.99"),oFont14:oFont)
	//oPrn:Say(2310,1685,"40,00",oFont14:oFont,,,,3)
	oPrn:Box (2195,1975,2325,2465)
	oPrn:Say(2225,1985,"IRRF (R$)",oFont11:oFont,,,,3)
	ImprimeValor(2310,2000,Transform(nValIR  ,"@E 999,999,999.99"),oFont14:oFont)
	//oPrn:Say(2310,2170,"40,00",oFont14:oFont,,,,3)
	
	oPrn:Box (2325,30,2415,637)
	oPrn:Say(2355,40,"ISSQN (R$)",oFont11:oFont,,,,3)
	ImprimeValor(2395,150,Transform(nISSQN    ,"@E 999,999,999.99"),oFont14:oFont)
	//oPrn:Say(2395,280,"200,00",oFont14:oFont,,,,3)
	
	oPrn:Box (2325,637,2415,1247)
	oPrn:Say(2355,647,"Outras Deduções (R$)",oFont11:oFont,,,,3)
	oPrn:Say(2395,905,"0,00",oFont14:oFont,,,,3)
	
	oPrn:Box (2325,1247,2415,1847)
	oPrn:Say(2355,1257,"Total das Retenções (R$)",oFont11:oFont,,,,3)
	ImprimeValor(2395,1400,Transform(nTOTRET  ,"@E 999,999,999.99"),oFont14:oFont)
	//oPrn:Say(2395,1490,"866,00",oFont14:oFont,,,,3)
	
	oPrn:Box (2325,1847,2415,2467)
	oPrn:Say(2355,1857,"Valor Líquido da Nota (R$)",oFont11:oFont,,,,3)
	ImprimeValor(2395,1950,Transform(nTOTAL  ,"@E 999,999,999.99"),oFont14:oFont)
	//oPrn:Say(2395,2080,"3.134,00",oFont14:oFont,,,,3)
	
	oPrn:Box (2428,30,2943,2465)
	oPrn:Say(2475,1000,"Outras Informações",oFont16:oFont,,,,3)
	
	nLin := 2550
	oPrn:Say(nLin,40,"- Competência: " +MesExtenso(Month(SF2->F2_EMISSAO))+ "/" + Str(Year(SF2->F2_EMISSAO),4),oFont16:oFont,,,,3)
	nLin += 40
	oPrn:Say(nLin,40,"- ISS de responsabilidade do: " +If( SF2->F2_RECISS == "1" , "Tomador", "Prestador")+ " de serviço",oFont16:oFont,,,,3)
	nLin += 40
	oPrn:Say(nLin,40,"- Serviço Tributado no Município: MANAUS",oFont16:oFont,,,,3)
	If SF2->F2_RECISS == "1"
		nLin += 40
		oPrn:Say(nLin,40,"- Data do vencimento do ISS desta NFSE: " + DtoC( VencimentoISS(SF2->F2_EMISSAO) ),oFont16:oFont,,,,3)
	Endif
	nLin += 40
	oPrn:Say(nLin,40,"- Esta NFS-e substitui o RPS Nº "+SF2->F2_DOC+", série: "+AllTrim(SF2->F2_SERIE)+", emitido em " + DtoC(SF2->F2_EMISSAO),oFont16:oFont,,,,3)
	If SF2->F2_RECISS == "1"
		nLin += 40
		oPrn:Say(nLin,40,"- Operação com retenção de ISS por Substituição Tributária.",oFont16:oFont,,,,3)
	Endif
	oPrn:QRCode(2880,2020,cQrCode,100)
	
	oPrn:EndPage()     // Finaliza a página

Return

Static Function PrintReport()
	Local lOk := .F.

	cQry := "SELECT SF2.F2_DOC, SF2.F2_SERIE"
	cQry += " FROM "+RetSQLName("SF2")+" SF2"
	cQry += " INNER JOIN "+RetSQLName("SF3")+" SF3 ON SF3.D_E_L_E_T_ = ' '"
	cQry += " AND SF3.F3_FILIAL = SF2.F2_FILIAL"
	cQry += " AND SF3.F3_NFISCAL = SF2.F2_DOC"
	cQry += " AND SF3.F3_SERIE = SF2.F2_SERIE"
	cQry += " AND SF3.F3_CLIEFOR = SF2.F2_CLIENTE"
	cQry += " AND SF3.F3_LOJA = SF2.F2_LOJA"
	cQry += " AND SF3.F3_DTCANC = ' '"
	cQry += " WHERE SF2.D_E_L_E_T_ = ' '"
	cQry += " AND SF2.F2_FILIAL = '"+SF2->(XFILIAL("SF2"))+"'"
	cQry += " AND SF2.F2_DOC = '"+mv_par01+"'"
	cQry += " AND SF2.F2_SERIE = '"+mv_par02+"'"
	cQry += " AND SF2.F2_ESPECIE = 'NFS'"
	//cQry += " AND SF2.F2_NFELETR <> ' '"
	cQry += " GROUP BY SF2.F2_DOC, SF2.F2_SERIE"
	
	DbUseArea(.t.,"TOPCONN",TcGenQry(,,cQry),"QRY")
	
	If QRY->(Bof()) .And. QRY->(Eof())
		If IsBlind()
			Conout(FunName()+": Não foram encontrados dados para os parâmetros informados: " + cFilAnt + " - " + mv_par01 + " - " + mv_par02)
		Else
			FWAlertError("Não foram encontrados dados para os parâmetros informados !")
		Endif
	Else
		lOk := .T.
		
		// Posiciona nos registros das tabelas
		SF2->(dbSetOrder(1))
		SF2->(dbSeek(XFILIAL("SF2")+QRY->F2_DOC+QRY->F2_SERIE))
		SF3->(dbSetOrder(5))
		SF3->(dbSeek(XFILIAL("SF3")+QRY->F2_SERIE+QRY->F2_DOC))
	Endif
	
	QRY->(DbCloseArea())
	
Return lOk

Static Function VencimentoISS(dEmissao)
	Local nTamData, nDiaUtil, nDia
	Local cFilOrig    := SF2->F2_FILIAL   //SE2->E2_FILORIG
	Local __lLocBRA   := ( cPaisLoc == "BRA" )
	Local lAltera     := .T.
	Local dVctoReal   := dEmissao
	Local cMV_VENCISS := GetNewPar("MV_VENCISS","E")
	Local lVcAntIss   := (SuperGetMV("MV_ANTVISS",.T.,"2") == "1")  //Antecipa ou nao o vencimento do ISS em caso de vencimento em dia nao util
	Local dVenISS     := Ctod("")
	
	Do Case
		Case cMV_VENCISS == "E"
			dVenISS := dEmissao
			dVenISS += 28
			
			If Month(dVenISS) == Month(dEmissao)
				dVenISS := dVenISS + 28
			EndIf
			
			nTamData := Iif(Len(Dtoc(dVenISS)) == 10, 7, 5)
			
			If __lLocBRA .and. lAltera .and. SX6->(dbSeek(cFilOrig+"MV_DIAISS"))
				dVenISS	:= Ctod(SX6->X6_CONTEUD+"/"+Subs(Dtoc(dVenISS),4,nTamData))
			Else
				dVenISS	:= Ctod(StrZero(SuperGetMv("MV_DIAISS"),2)+"/"+Subs(Dtoc(dVenISS),4,nTamData))
			EndIf
			
		Case cMV_VENCISS == "Q" //Ultimo dia util da quinzena subsequente a dEmissao
			If Day(dEmissao) <= 15
				dVenISS	:= LastDay(dEmissao)
				dVenISS := DataValida(dVenISS,.F.)
			Else
				dVenISS := DataValida((LastDay(dEmissao)+1)+14,.F.)
			EndIf
			
		Case cMV_VENCISS == "U" //Ultimo dia util do mes subsequente da dEmissao
			dVenISS := DataValida(LastDay(LastDay(dEmissao)+1),.F.)
		Case cMV_VENCISS == "D"
			dVenISS := LastDay(dEmissao) + 1
			If __lLocBRA .and. lAltera .And. SX6->(dbSeek(cFilOrig+"MV_DIAISS"))
				nDiaUtil := SX6->X6_CONTEUD
			Else
				nDiaUtil := SuperGetMv("MV_DIAISS")
			Endif
			
			For nDia := 1 To nDiaUtil-1
				If !(dVenISS == DataValida(dVenISS,.T.))
					nDia--
				EndIf
				dVenISS++
			Next nDia
		Case cMV_VENCISS == "F" //Qtd de dia do parametro MV_DIAISS apos o fechamento da quinzena.
			If Day(dEmissao) <= 15
				If __lLocBRA .and. lAltera .and. SX6->(dbSeek(cFilOrig+"MV_DIAISS"))
					dVenISS	:= CtoD("15"+SUBSTR(DtoC(dEmissao),3,Len(DtoC(dEmissao))))+SX6->X6_CONTEUD
				Else
					dVenISS := CtoD("15"+SUBSTR(DtoC(dEmissao),3,Len(DtoC(dEmissao))))+SuperGetMv("MV_DIAISS")
				Endif
			Else
				If __lLocBRA .and. lAltera .and. SX6->(dbSeek(cFilOrig+"MV_DIAISS"))
					dVenISS	:= LastDay(dEmissao)+SX6->X6_CONTEUD
				Else
					dVenISS := LastDay(dEmissao)+SuperGetMv("MV_DIAISS")
				Endif
			EndIf
		OtherWise
			dVenISS := dVctoReal
			dVenISS += 28
			
			If Month(dVenISS) == Month(dVctoReal)
				dVenISS += 28
			EndIf
			
			nTamData := Iif(Len(Dtoc(dVenISS)) == 10, 7, 5)
			
			If __lLocBRA .and. lAltera .and. SX6->(dbSeek(cFilOrig+"MV_DIAISS"))
				dVenISS	:= Ctod(SX6->X6_CONTEUD+"/"+Subs(Dtoc(dVenISS),4,nTamData))
			Else
				dVenISS	:= Ctod(StrZero(SuperGetMv("MV_DIAISS"),2)+"/"+Subs(Dtoc(dVenISS),4,nTamData))
			Endif
	EndCase
	
	dVenISS := DataValida(dVenISS,IIF(lVcAntIss,.F.,.T.))

Return dVenISS

Static Function QuebraLinha(cString,oFont,nMax,nLinha)
	Local nL
	Local nTam   := 0
	Local cAux   := AllTrim(cString)
	Local cRet   := ""
	Local aLinha := {}
	
	nLinha := If( nLinha == Nil , 1, Max(1,nLinha))
	
	For nL:=1 To Len(cAux)
		cRet += SubStr(cAux,nL,1)
		nTam += TamText(SubStr(cAux,nL,1),oFont) + 7
		If nTam > nMax
			AAdd( aLinha , cRet )
			nTam := 0
			cRet := ""
		Endif
	Next
	
	If !Empty(cRet)
		AAdd( aLinha , cRet )
	Endif
	
	If nLinha <= Len(aLinha)
		cRet := AllTrim(aLinha[nLinha])
	Else
		cRet := ""
	Endif
	
Return cRet

Static Function TamText(cString,oFont)
	Local nPos := AScan( aCarac , {|x| x[1] == cString })
	Local nRet := 6  //oPrn:getTextWidth(cString, oFont, 1)  //oFont:Name, oFont:nWidth, oFont:Bold, oFont:Italic )
	If nPos > 0
		nRet := aCarac[nPos,2]
	Else
		nRet := nRet
	Endif*
Return nRet

Static Function MontaTamanho()
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
	Local aRet := {	{"A",13},{"B",13},{"C",14},{"D",14},{"E",13},{"F",12},{"G",16},{"H",13},{"I", 6},{"J",10},{"K",13},{"L",11},{"M",17},{"N",13},{"O",16},{"P",13},{"Q",16},;
					{"R",14},{"S",13},{"T",12},{"U",13},{"V",13},{"W",19},{"X",13},{"Y",14},{"Z",12},{"a",11},{"b",11},{"c",10},{"d",11},{"e",11},{"f", 6},{"g",11},{"h",10},;
					{"i", 4},{"j", 4},{"k",10},{"l", 4},{"m",16},{"n",10},{"o",11},{"p",11},{"q",11},{"r", 7},{"s",10},{"t", 6},{"u",10},{"v", 9},{"w",15},{"x", 9},{"y",10},;
					{"z", 9},{"!", 6},{"@",20},{"#",11},{"$",11},{"%",18},{"¨", 7},{"&",13},{"*", 8},{"(", 7},{")", 7},{"_",11},{"+",12},{"-", 7},{"=",12},{"|", 6},{"\", 6},;
					{"<",12},{",", 6},{">",12},{".", 6},{":", 6},{";", 6},{"?",11},{"/", 6},{"{", 7},{"[", 6},{"}", 7},{" ", 6},{"'", 4},{'"', 7},{"0",11},{"1",11},{"2",11},;
					{"3",11},{"4",11},{"5",11},{"6",11},{"7",11},{"8",11},{"9",11},{"Á",13},{"Ã",13},{"Â",13},{"À",13},{"á",11},{"ã",11},{"â",11},{"à",11},{"É",13},{"Ê",13},;
					{"é",11},{"è",11},{"Í", 6},{"Ì", 6},{"Î", 6},{"í", 6},{"ì", 6},{"î", 6},{"Ó",16},{"Ò",16},{"Õ",16},{"Ô",16},{"ó",11},{"ò",11},{"õ",11},{"ô",11},{"Ú",14},;
					{"Ù",14},{"Û",14},{"ú",11},{"ù",11},{"û",11},{"Ñ",14},{"ñ",11},{"Ç",14},{"ç",10}}

Return aRet

/*Static Function ImpCarac(aVetor,oFont)
	Local nHdl, nX, cLin
	Local cFile := "C:\TEMP\CARACTER.TXT"
	If File(cFile)
		FErase(cFile)
	Endif
	nHdl := fCreate(cFile)
	If nHdl == -1
		Conout("Erro na criacao do arquivo "+cFile)
	Else
		For nX:=1 To Len(aVetor)
			aVetor[nX,2] := TamText(aVetor[nX,1],oFont)
			cLin := '{"'+aVetor[nX,1] + '"},{' + LTrim(Str(aVetor[nX,2])) + '},' + Chr(13) + Chr(10)
			FWrite(nHdl,cLin,Len(cLin))
		Next
		FClose(nHdl)
	Endif
Return*/

Static Function ValidPerg(cPerg)
	u_SNPutSX1(cPerg,"01",PADR("Nota ",29)+"?","","","mv_ch1","C",9,0,0,"G","","   ","","","mv_par01")
	u_SNPutSX1(cPerg,"02",PADR("Serie",29)+"?","","","mv_ch2","C",3,0,0,"G","","   ","","","mv_par02")
Return


User Function SNPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

LOCAL aArea := GetArea()
Local cKey
Local lPort := .f.
Local lSpa  := .f.
Local lIngl := .f. 

If .T. //GetVersao(.F.) < "12"

	cKey  := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."
	
	cPyme    := Iif( cPyme 		== Nil, " ", cPyme		)
	cF3      := Iif( cF3 		== NIl, " ", cF3		)
	cGrpSxg  := Iif( cGrpSxg	== Nil, " ", cGrpSxg	)
	cCnt01   := Iif( cCnt01		== Nil, "" , cCnt01 	)
	cHelp	 := Iif( cHelp		== Nil, "" , cHelp		)
	
	dbSelectArea( "SX1" )
	dbSetOrder( 1 )
	
	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )
	
	If !( DbSeek( cGrupo + cOrdem ))
	
	    cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa	:= If(! "?" $ cPerSpa  .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng	:= If(! "?" $ cPerEng  .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)
	
		Reclock( "SX1" , .T. )
	
		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA  With cPerSpa
		Replace X1_PERENG  With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL  With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid
	
		Replace X1_VAR01   With cVar01
	
		Replace X1_F3      With cF3
		Replace X1_GRPSXG  With cGrpSxg
	
		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif
	
		Replace X1_CNT01   With cCnt01
		If cGSC == "C"			// Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1
	
			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2
	
			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3
	
			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4
	
			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif
	
		Replace X1_HELP  With cHelp
	
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
		MsUnlock()
	Else
	
	   lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
	   lSpa  := ! "?" $ X1_PERSPA  .And. ! Empty(SX1->X1_PERSPA)
	   lIngl := ! "?" $ X1_PERENG  .And. ! Empty(SX1->X1_PERENG)
	
	   If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort 
	         SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa 
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif
	
	RestArea( aArea )
Endif	
Return
