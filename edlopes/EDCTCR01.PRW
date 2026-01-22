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


********            RELATÒRIO EDCTCR01               **********
******** Cotrole de carga e descarga de balsa tanque **********
******** @author Edson Sales  -14/01/2025       **********

User Function EDCTCR01(cViagem)
	// Private cLogoEmp := Alltrim(SuperGetMV("ZZ_LOGO",,FisxLogo("1") ))
	Local aArea := FWGetArea()
	Local nX   := 0
	Local aBalsa   := {}
	Private cLogoEmp := GetSrvProfString('Startpath','') + 'lgrl010101.bmp'
	Private nLinAux0 := 0
	Private nLinAux1 := 0
	Private nLinAux2 := 0
	Private nLinAux3 := 0
	Private nLinCab  := 0
	Private nDens20C := 0
	Private nDens20D := 0
	Private X  := 0
	Private _cViagem  := cViagem /// '000048' 
	Private _cBalsa  := ''
	Private _cCodCarga  := ''
	Private oBrushAzClaro     := TBRUSH():New(,nCorAzulClaro)
	//Adicionando os parametros do ParamBox

	// aAdd(aPergs, {1, "Viagem",   _cViagem,        "", ".T.", "   ", ".T.", 80, .F.})

	// If ParamBox(aPergs, "Informe os parametros")
	// RPCSetType(3)
	// RPCSetEnv('01','0101',,,)
	DbSelectArea('SZA')
	dbSetOrder(2)

	//  buscar as balsas da viagem
	IF MsSeek(xFilial('SZA')+_cViagem)
		while !SZA->(EOF()) .AND. SZA->ZA_VIAGEM == _cViagem
			aAdd(aBalsa, {SZA->ZA_BALSA,SZA->ZA_COD})
			SZA->(DbSkip())
		Enddo
	EndIf


	for nX := 1 to len(aBalsa)
		_cBalsa := aBalsa[nX,1]
		_cCodCarga := aBalsa[nX,2]
		fMontaRel(.T.,nX)
	next nX
	FWRestArea(aArea)

Return

Static Function fMontaRel(lCallMe,nX)
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

	Private cHoraEx    := Time()
	Private nPagAtu    := 1
	Private cNomeRel   := 'EDCTCR01-'+CVALTOCHAR(nX)
	Private cQryIte    := ""

	//Linhas e colunas
	Private nLinAtu    := 0
	Private nLinFin    := 574
	Private nColIni    := 010
	Private nColFin    := 550
	Private nColMeio   := (nColFin-nColIni)/2
	Private oPrintPvt
	Private oBrushAzul := TBRUSH():New(,nCorAzul)
	Private cAlias := GetNextAlias()

	//- Declarando as fontes
	Private cNomeFont  := "Arial"
	Private oFontDet   := TFont():New("Arial", 9, -7,  .T., .F., 5, .T., 5, .T., .F.)
	Private oFontDetN  := TFont():New("Arial", 9, -7,  .T., .T., 5, .T., 5, .T., .F.)
	Private oFontRod   := TFont():New("Arial", 9, -6,  .T., .F., 5, .T., 5, .T., .F.)
	Private oFontTit   := TFont():New("Arial", 14, 14, .T., .T., 5, .T., 5, .T., .F.)
	Private oFontCab   := TFont():New("Arial", 9, -7,  .T., .F., 5, .T., 5, .T., .F.)
	Private oFontCabN  := TFont():New("Arial", 12, -7,  .T., .T., 5, .T., 5, .T., .F.)
	Private oFontObs   := TFont():New("Arial", 10, -10,  .T., .F., 5, .T., 5, .T., .F.)
	Private oFontObsN  := TFont():New("Arial", 10, -10,  .T., .T., 5, .T., 5, .T., .F.)
	Private oFont14    := TFont():New("Arial", 14, 14,  .T., .F., 5, .T., 5, .T., .F.)
	Private oFont09    := TFont():New("Arial", 09, 09,  .T., .F., 5, .T., 5, .T., .F.)

	Private oFont10Cab := TFont():New("Arial", 10, 10,  .T., .F., 5, .T., 5, .T., .F.)
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
	// _cViagem := '000048'
	BEGINSQL ALIAS cAlias
	SELECT  ZB_TIPO,ZA_TIPO,ZA_TPPROD,ZA_VOLPROG,ZA_VIAGEM,ZA_EMPURRA,ZA_BALSA,ZA_VOL20TC,ZA_VOL20TD,ZB_DIFVO20,ZA_VAZAOC,ZA_VAZAOD,
			ZA_DTOPER,ZA_HRSAICA,ZA_DTCHDES,ZA_HRCHDES,ZA_DTINICA,ZA_HRINICA,ZA_DTFIMDE,ZA_HRFIMDE,ZB_TEMPAMO,ZA_HRINIDE,
			ZA_PTEMB,ZA_PTDES,ZA_FATCARG,ZA_FATDESC,ZA_TPERSOB,ZA_DTSAICA,ZA_VALNF,ZA_TXTRAN,ZA_CALRE2C,ZA_CALVA2C,ZA_CALME2C,
			ZA_DTFIMDE,ZA_DTINICA,ZA_DTINIDE,ZB_TANQUE,ZB_REF,ZB_MED,ZA_TXSOB,ZA_CALRE2D,ZA_CALVA2D,ZA_CALME2D,
			ZB_TEMP,ZB_VOL,ZB_VOL20,ZB_PESO,ZB_DENSAMO,ZB_DENS20,ZA_VALTRAN,ZA_VPERSOB,ZA_VALNF,ZA_VALSOB,ZA_VALLIQ,
			ZB_FATOR,ZA_BDAMBC,ZA_BDAMBD,ZA_BD20C,ZA_BD20D,ZA_PERCC,ZA_PERCD,ZA_QTDABS,ZA_QTDCOB,ZB_DIFAL,ZB_DIF,ZB_DIFRE,
			ZB_DIFVOL,ZA_ATRACAC,ZA_ATRACAD,ZA_HORMEDC,ZA_HORMEDD,ZA_INIOPEC,ZA_INIOPED,ZA_LIBERAC,ZA_LIBERAD,ZA_FIMOPEC,ZA_FIMOPED,
			ZA_TEMOPEC,ZA_TEMOPED,ZA_CALREC,ZA_CALRED,ZA_CALMNAC,ZA_CALMNAD,ZA_CALVANC,ZA_CALVAND,ZA_CALMEDC,ZA_CALMEDD,ZA_BANBOMC,ZA_BANBOMD,
			ZA_BANBORC,ZA_BANBORD,ZA_TRIPROC,ZA_TRIPROD,ZA_TRIPOPC,ZA_TRIPOPD,ZA_USRCAR,ZA_DATCAR,ZA_HORCAR,ZA_USRDES,ZA_DATDES,ZA_HORDES,ZA_USRENC,ZA_DATENC,ZA_HORENC
	FROM SZA010 ZA
	INNER JOIN SZB010 ZB ON ZB.D_E_L_E_T_=' ' AND ZA_FILIAL=ZB_FILIAL AND ZA_COD=ZB_COD AND ZA_BALSA=ZB_BALSA
	WHERE ZA.D_E_L_E_T_=' ' AND	ZA_VIAGEM=%exp:_cViagem% AND ZA_BALSA=%exp:_cBalsa% AND ZA_COD=%exp:_cCodCarga%
	order by ZB_TIPO,ZB_TANQUE
	endSql
	(cAlias)->(DbGotop())

	//- Imprime o cabeçalho
	nPagAtu := 1
	fImpCab()
	CarOriDet()
	fApurac()

	// oPrintPvt:Preview()
	// - Enquanto houver itens da invoice
	// Se por acaso atingiu o limite da página, finaliza, e começa uma nova página
	If nLinAtu >= nLinFin

		(cAlias)->(DbGotop())
		fImpCab()
		FbordoAnb()
	EndIf

	nPagAtu++
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
	Local cTitulo:= 'CONTROLE DE CARGA E DESCARGA DE BALSA-TANQUE'
	Local cDataAtual := DtoC(StoD((cAlias)->(ZA_DTOPER)))
	Local cOperAtu := ''

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
	nLinCab += 60

	DbSelectArea('DA3')
	DbSetOrder(1) //- DA3_FILIAL+DA3_COD
	MsSeek(xFilial("DA3")+(cAlias)->(ZA_BALSA))

	*** Cabeçalho Principal ***
	oPrintPvt:Box(nLinCab,nPos0,nLinCab+65,nPos8)

	oPrintPvt:Line( nLinCab, nPos5-15, nLinCab+65, nPos5-15) // LINHA VETICAL
	oPrintPvt:Line( nLinCab, nPos6-5 ,   nLinCab+65, nPos6-5) // LINHA VETICAL

	nLinAux1 := nLinCab
	oPrintPvt:SayAlign(nLinAux1+6,  nPos5-10,    'Resp. Carregamento', oFont11N, 160, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux1+6,  nPos6,    AllTrim(UsrRetName((cAlias)->ZA_USRCAR))+;
		" - "+DtoC(StoD((cAlias)->ZA_DATCAR))+" - "+(cAlias)->ZA_HORCAR  , oFont11N, 160, 05, , PAD_LEFT, )

	nLinAux1 += 21
	oPrintPvt:Line(nLinAux1,nPos5-15,nLinAux1,nPos8)     // LINHA HORISONTAIS
	oPrintPvt:SayAlign(nLinAux1+6, nPos5-10,    'Resp. Descarregamento:', oFont11N, 160, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux1+6,  nPos6,    AllTrim(UsrRetName((cAlias)->ZA_USRDES))+;
		" - "+DtoC(StoD((cAlias)->ZA_DATDES))+" - "+(cAlias)->ZA_HORDES  , oFont11N, 160, 05, , PAD_LEFT, )

	nLinAux1 += 21
	oPrintPvt:Line(nLinAux1,nPos5-15,nLinAux1,nPos8)     // LINHA HORISONTAIS
	oPrintPvt:SayAlign(nLinAux1+6, nPos5-10,    'Resp. Encerramento:', oFont11N, 160, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux1+6,  nPos6,    AllTrim(UsrRetName((cAlias)->ZA_USRENC))+;
		" - "+DtoC(StoD((cAlias)->ZA_DATENC))+" - "+(cAlias)->ZA_HORENC  , oFont11N, 160, 05, , PAD_LEFT, )

	nLinCab += 05
	oPrintPvt:SayBitmap(nLinCab, nPos0+10, cLogoEmp, 074, 054)
	nLinCab += 21
	oPrintPvt:SayAlign(nLinCab, nPos2-40, cTitulo, oFontTit, 400, 05, nCorAzul, PAD_LEFT,  )

	*** Cabeçalho Dados carregamento ***

	nLinCab += 50
	oPrintPvt:SayAlign(nLinCab,  nPos0, 	/*001*/  'Data Atual'            , oFont12N, 070, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos1-40,  /*070*/  'Tipo de Produto'       , oFont12N, 270, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos3+30,	/*340*/  'Volume da Balsa'       , oFont12N, 100, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos4+30,	/*440*/  'Volume Programado'     , oFont12N, 100, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos5+30,	/*540*/  'Operação atual'        , oFont12N, 100, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos6+30,	/*640*/  'Fator de Experiência'  , oFont12N, 100, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos7+30,	/*740*/  'N° Viagem'             , oFont12N, 80, 05, , PAD_CENTER, )

	nLinCab +=15
	cOperAtu := IIF((cAlias)->ZA_TIPO=='C','Carregamento',IIF((cAlias)->ZA_TIPO=='D','Descarregamento','Encerrado'))
	oPrintPvt:SayAlign(nLinCab,  nPos0, 	/*001*/  cDataAtual     															, oFont11N, 070, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos1-40,  /*070*/  Alltrim(Posicione("SB1",1,XFILIAL('SB1')+(cAlias)->(ZA_TPPROD),'B1_DESC'))	, oFont11N, 270, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos3+30,	/*340*/  Alltrim(Transform(DA3->DA3_VOLMAX,"@E 999,999.999"  ))						, oFont11N, 100, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos4+30,	/*440*/  Alltrim(Transform((cAlias)->(ZA_VOLPROG),"@E 999,999,999"  ))				, oFont11N, 100, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos5+30,	/*540*/	 cOperAtu	   																, oFont11N, 100, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos6+30,	/*640*/  Alltrim(Transform(DA3->DA3_XFATEX,"@E 999,999,999"  ))						, oFont11N, 100, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos7+30,	/*740*/	 (cAlias)->(ZA_VIAGEM)    													, oFont11N, 80, 05, , PAD_CENTER, )

	nLinCab += 12
	oPrintPvt:Line(nLinCab,nPos0,nLinCab,nPos8)     // LINHA HORISONTAIS
	nLinCab += 6

	oPrintPvt:SayAlign(nLinCab,  nPos0,	  /*001*/  'Nome do Empurrador' , oFont12N, 110, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos1,   /*110*/  'Nome da Balsa'      , oFont12N, 110, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos2+10,/*220*/  'Local Carregamento' , oFont12N, 145, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos3+65,/*365*/  'Local Descarga'     , oFont12N, 145, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos5   ,/*510*/  'Fator de Carga'     , oFont12N, 110, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos6+10,/*620*/  'Fator de Descarga'  , oFont12N, 110, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos7+20,/*730*/  'Perda/Sobra'        , oFont12N, 100, 05, , PAD_CENTER, )

	nLinCab += 15
	DbSelectArea("SZ1")
	DbSetOrder(1)
	MsSeek(xFilial("SZ1")+(cAlias)->(ZA_PTEMB))

	oPrintPvt:SayAlign(nLinCab,  nPos0,	  /*001*/ 	AllTrim(posicione('DA3',1,xFilial("DA3")+(cAlias)->(ZA_EMPURRA),'DA3_DESC')) , oFont11N, 110, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos1,   /*110*/   AllTrim(posicione('DA3',1,xFilial("DA3")+(cAlias)->(ZA_BALSA)  ,'DA3_DESC')) , oFont11N, 110, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos2+10,/*220*/	Alltrim(Posicione("SZ1",1,XFILIAL('SZ1')+(cAlias)->(ZA_PTEMB),"Z1_PORTO"))   , oFont11N, 145, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos3+65,/*365*/  	Alltrim(Posicione("SZ1",1,XFILIAL('SZ1')+(cAlias)->(ZA_PTDES),"Z1_PORTO"))   , oFont11N, 145, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos5   ,/*510*/  	CVALTOCHAR((cAlias)->(ZA_FATCARG))											 , oFont11N, 110, 05,IIF((cAlias)->(ZA_FATCARG)<0,CLR_HRED,CLR_BLACK), PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos6+10,/*620*/  	CVALTOCHAR((cAlias)->(ZA_FATDESC))											 , oFont11N, 110, 05,IIF((cAlias)->(ZA_FATDESC)<0,CLR_HRED,CLR_BLACK) , PAD_CENTER,)
	oPrintPvt:SayAlign(nLinCab,  nPos7+20,/*730*/  	CVALTOCHAR((cAlias)->(ZA_TPERSOB))											 , oFont11N, 100, 05,IIF((cAlias)->(ZA_TPERSOB)<0,CLR_HRED,CLR_BLACK) , PAD_CENTER,)

	nLinCab += 12

	oPrintPvt:Line(nLinCab,nPos0,nLinCab,nPos8)     // LINHA HORISONTAIS

	nLinCab +=12
	oPrintPvt:FillRect({nLinCab , nPos0, nLinCab + 22, nPos8}, oBrushAzClaro)
	oPrintPvt:SayAlign(nLinCab,  nPos0+4, /*001*/  'Data Saída/Hr: '+dtoc(stod((cAlias)->(ZA_DTSAICA)))+' - '+substr((cAlias)->(ZA_HRSAICA),1,2)+':'+substr((cAlias)->(ZA_HRSAICA),3,2)		  , oFont11N, 180, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab,  nPos2,   /*230*/  'Data Chegada:  '+dtoc(stod((cAlias)->(ZA_DTCHDES)))+ ' - '+substr((cAlias)->(ZA_HRCHDES),1,2)+':'+substr((cAlias)->(ZA_HRCHDES),3,2)		  , oFont12N, 180, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab,  nPos4,   /*470*/  'Data Inicio operação  '+dtoc(stod((cAlias)->(ZA_DTINIDE)))+' - '+substr((cAlias)->(ZA_HRINIDE),1,2)+':'+substr((cAlias)->(ZA_HRINIDE),3,2) , oFont11N, 180, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab,  nPos6,   /*730*/  'Data Termino operação '+dtoc(stod((cAlias)->(ZA_DTFIMDE)))+' - '+substr((cAlias)->(ZA_HRFIMDE),1,2)+':'+substr((cAlias)->(ZA_HRFIMDE),3,2), oFont12N, 220, 05, , PAD_LEFT, )

	nLinCab += 20
Return

Static Function CarOriDet()

	Local nVolCar := 0
	Local nVolDes := 0

	*** carregamento origem / Descarregamento destino ***

	// oPrintPvt:Box(nLinCab,nPos0,nLinCab+166,nPos4)
	oPrintPvt:Box(nLinCab,nPos0,nLinCab+28,nPos8)
	oPrintPvt:SayAlign(nLinCab,  nPos0, /*001*/  'Carregamento (Origem)', oFont14, 410, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos4, /*001*/  'Descarregamento (Destino)', oFont14, 400, 05, , PAD_CENTER, )

	// oPrintPvt:Box(nLinCab,nPos4,nLinCab+166,nPos8)
	// oPrintPvt:Box(nLinCab,nPos4,nLinCab+28,nPos8)
	// oPrintPvt:SayAlign(nLinCab,  nPos4, /*001*/  'Descarregamento (Destino)', oFont14, 400, 05, , PAD_CENTER, )

	// oPrintPvt:Box(nLinCab,nPos4+10,nLinCab+122,nPos8)
	// oPrintPvt:SayAlign(nLinCab,  nPos4+10, /*001*/  'Apuração Carregamento / Descarregamento', oFont14, 390, 05, , PAD_CENTER, )
	nLinCab += 14
	oPrintPvt:Line(nLinCab,nPos0,nLinCab,nPos8)

	//CARREGAMENTO
	oPrintPvt:Line( nLinCab, nPos0+50,  nLinCab+14, nPos0+50) 	// LINHA VETICAL  nLinCab+152,
	oPrintPvt:Line( nLinCab, nPos0+120, nLinCab+14, nPos0+120)	// LINHA VETICAL  nLinCab+152,
	oPrintPvt:Line( nLinCab, nPos0+190, nLinCab+14, nPos0+190)	// LINHA VETICAL  nLinCab+152,
	oPrintPvt:Line( nLinCab, nPos0+260, nLinCab+14, nPos0+260)	// LINHA VETICAL  nLinCab+152,
	// linha do meio
	oPrintPvt:Line( nLinCab, nPos4,  	nLinCab+14, nPos4)    	// LINHA VETICAL  nLinCab+152,
	// DESCARECAMENTO
	oPrintPvt:Line( nLinCab, nPos4+50,  nLinCab+14, nPos4+50) 	// LINHA VETICAL  nLinCab+152,
	oPrintPvt:Line( nLinCab, nPos4+120, nLinCab+14, nPos4+120)	// LINHA VETICAL  nLinCab+152,
	oPrintPvt:Line( nLinCab, nPos4+190, nLinCab+14, nPos4+190)	// LINHA VETICAL  nLinCab+152,
	oPrintPvt:Line( nLinCab, nPos4+260, nLinCab+14, nPos4+260)	// LINHA VETICAL  nLinCab+152,

	//carregamento
	oPrintPvt:SayAlign(nLinCab,  nPos0+3,   /**/ 'Tsq',		oFont12N, 30, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos0+52,  /**/ 'Ref.',	oFont12N, 70, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos0+122, /**/ 'Medição',	oFont12N, 70, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos0+192, /**/ 'Temp.',	oFont12N, 70, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos0+262, /**/ 'Volume',	oFont12N, 140, 05, , PAD_CENTER, )

	// Descarregamento
	oPrintPvt:SayAlign(nLinCab,  nPos4+3,   /**/ 'Tsq',		oFont12N, 30, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos4+52,  /**/ 'Ref.',	oFont12N, 70, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos4+122, /**/ 'Medição',	oFont12N, 70, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos4+192, /**/ 'Temp.',	oFont12N, 70, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos4+262, /**/ 'Volume',	oFont12N, 140, 05, , PAD_CENTER, )

	nLinCab += 14
	oPrintPvt:Line(nLinCab,nPos0,nLinCab,nPos8)
	// oPrintPvt:Line(nLinCab,nPos4,nLinCab,nPos8)

	nLinAux0 := nLinCab
	nLinAux1 := nLinCab

	(cAlias)->(DbGotop())
	while  !(cAlias)->(EoF())
		if (cAlias)->(ZB_TIPO)=='C'
			*** // layout
			oPrintPvt:Box(nLinAux0,nPos0,nLinAux0+14,nPos8)
			//LINHA DO MEIO antes do TSQ
			oPrintPvt:Line( nLinAux0, nPos4,  nLinAux0 + 14, nPos4 )
			// LINHA VETICAL CARREMENTO
			oPrintPvt:Line( nLinAux0, nPos0+50,  nLinAux0 + 14, nPos0+50 )
			oPrintPvt:Line( nLinAux0, nPos0+120, nLinAux0 + 14, nPos0+120)
			oPrintPvt:Line( nLinAux0, nPos0+190, nLinAux0 + 14, nPos0+190)
			oPrintPvt:Line( nLinAux0, nPos0+260, nLinAux0 + 14, nPos0+260)
			// LINHA VETICAL DESCARREGAMENTO
			oPrintPvt:Line( nLinAux0, nPos4+50,  nLinAux0 + 14, nPos4+50 )
			oPrintPvt:Line( nLinAux0, nPos4+120, nLinAux0 + 14, nPos4+120)
			oPrintPvt:Line( nLinAux0, nPos4+190, nLinAux0 + 14, nPos4+190)
			oPrintPvt:Line( nLinAux0, nPos4+260, nLinAux0 + 14, nPos4+260)
			***
			// Dados carregamento
			oPrintPvt:SayAlign(nLinAux0,  nPos0+3,   /*001*/  (cAlias)->(ZB_TANQUE)			 ,	oFont12N, 30, 05, , PAD_CENTER, )
			oPrintPvt:SayAlign(nLinAux0,  nPos0+52,  /*001*/  ALLTRIM(strtran(TRANSFORM((cAlias)->(ZB_REF),  '@E 999.9'),',','.')) ,	oFont12N, 30, 05, , PAD_CENTER, )
			oPrintPvt:SayAlign(nLinAux0,  nPos0+122, /*001*/  ALLTRIM(strtran(TRANSFORM((cAlias)->(ZB_MED),  '@E 999.9'),',','.')) ,	oFont12N, 70, 05, , PAD_CENTER, )
			oPrintPvt:SayAlign(nLinAux0,  nPos0+192, /*001*/  ALLTRIM(strtran(TRANSFORM((cAlias)->(ZB_TEMP), '@E 999.9'),',','.')),	oFont12N, 70, 05, , PAD_CENTER, )
			oPrintPvt:SayAlign(nLinAux0,  nPos0+262, /*001*/  strtran(Transform((cAlias)->(ZB_VOL),"@E 999,999,999"  ),',','.') ,	oFont12N, 140, 05, ,PAD_CENTER, )
			nVolCar += (cAlias)->(ZB_VOL)
			nLinAux0 += 14
		Elseif (cAlias)->(ZB_TIPO)=='D'
			// Dados Descarregamento
			oPrintPvt:SayAlign(nLinAux1,  nPos4+3,  /*001*/  (cAlias)->(ZB_TANQUE),				oFont12N, 30, 05, , PAD_CENTER, )
			oPrintPvt:SayAlign(nLinAux1,  nPos4+52, /*001*/  ALLTRIM(strtran(TRANSFORM((cAlias)->(ZB_REF),  '@E 999.9'),',','.')),	oFont12N, 30, 05, , PAD_CENTER, )
			oPrintPvt:SayAlign(nLinAux1,  nPos4+122,/*001*/  ALLTRIM(strtran(TRANSFORM((cAlias)->(ZB_MED),  '@E 999.9'),',','.')),	oFont12N, 70, 05, , PAD_CENTER, )
			oPrintPvt:SayAlign(nLinAux1,  nPos4+192,/*001*/  ALLTRIM(strtran(TRANSFORM((cAlias)->(ZB_TEMP), '@E 999.9'),',','.')),	oFont12N, 70, 05, , PAD_CENTER, )
			oPrintPvt:SayAlign(nLinAux1,  nPos4+262,/*001*/  strtran(Transform((cAlias)->(ZB_VOL),"@E 999,999,999"  ),',','.'),	oFont12N, 140, 05, ,PAD_CENTER, )
			nVolDes += (cAlias)->(ZB_VOL)
			nLinAux1 += 14

		EndIf
		(cAlias)->(DbSkip())
	Enddo
	nLinAux0 += 5
// CARREGAMENTO
	oPrintPvt:SayAlign(nLinAux0,  nPos0+3,  /*001*/  'Litros Ambientes', oFont12N, 100, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinAux0,  nPos0+262,/*001*/  Transform(nVolCar,"@E 999,999,999"), 		 oFont12N, 140, 05, ,PAD_CENTER, )

// DESCARREGAMENTO
	oPrintPvt:Line( nLinCab, nPos4,  nLinCab+14, nPos4 )   // LINHA VETICAL
	oPrintPvt:SayAlign(nLinAux0,  nPos4+3, /*001*/  'Litros Ambientes', oFont12N, 100, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinAux0,  nPos4+262,/*001*/  Transform(nVolDes,"@E 999,999,999"), 		oFont12N, 140, 05, ,PAD_CENTER, )

	nLinAux0 += 14
	oPrintPvt:Line(nLinAux0,nPos0,nLinAux0,nPos8)
	nLinAux0 += 14
	nLinCab := nLinAux0

Return

Static Function fApurac()

	nDens20C := 0
	nDens20D := 0
	**** Apuração do carregamento /  Descarregamento ****


	oPrintPvt:Box(nLinCab,nPos0,nLinCab+28,nPos8)
	oPrintPvt:SayAlign(nLinCab,  nPos0, /*001*/  'Apuração Carregamento (Origem)', oFont14, 410, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinCab,  nPos4, /*001*/  'Apuração Descarregamento (Destino)', oFont14, 400, 05, , PAD_CENTER, )

	// oPrintPvt:Box(nLinCab,nPos4,nLinCab+166,nPos8)
	// oPrintPvt:SayAlign(nLinCab,  nPos4, /*001*/  'Apuração Descarregamento (Destino)', oFont14, 400, 05, , PAD_CENTER, )
	// oPrintPvt:Box(nLinCab,nPos4+10,nLinCab+122,nPos8)
	// oPrintPvt:SayAlign(nLinCab,  nPos4+10, /*001*/  'Apuração Carregamento / Descarregamento', oFont14, 390, 05, , PAD_CENTER, )
	nLinCab += 14
	oPrintPvt:Line(nLinCab,nPos0,nLinCab,nPos8)

	// oPrintPvt:Line( nLinCab, nPos0+30,  nLinCab+12, nPos0+30 )   // LINHA VETICAL   nLinCab+152
	// oPrintPvt:Line( nLinCab, nPos4+30,  nLinCab+12, nPos4+30 )   // LINHA VETICAL   nLinCab+152

	oPrintPvt:Line( nLinCab, nPos0+30,  nLinCab+14, nPos0+30 )	 // LINHA VETICAL   nLinCab+152
	oPrintPvt:Line( nLinCab, nPos0+100, nLinCab+14, nPos0+100)   // LINHA VETICAL   nLinCab+152
	oPrintPvt:Line( nLinCab, nPos0+170, nLinCab+14, nPos0+170)   // LINHA VETICAL   nLinCab+152
	oPrintPvt:Line( nLinCab, nPos0+240, nLinCab+14, nPos0+240)   // LINHA VETICAL   nLinCab+152
	oPrintPvt:Line( nLinCab, nPos0+295, nLinCab+14, nPos0+295)   // LINHA VETICAL   nLinCab+152
	oPrintPvt:Line( nLinCab, nPos0+343, nLinCab+14, nPos0+343)   // LINHA VETICAL   nLinCab+152
	// oPrintPvt:Line( nLinCab, nPos0+363, nLinCab+14, nPos0+363)   // LINHA VETICAL   nLinCab+152

	oPrintPvt:Line( nLinCab, nPos4,  	nLinCab+14, nPos4 )   		// LINHA VETICAL   nLinCab+152
	oPrintPvt:Line( nLinCab, nPos4+30,  nLinCab+14, nPos4+30 )   // LINHA VETICAL   nLinCab+152
	oPrintPvt:Line( nLinCab, nPos4+100, nLinCab+14, nPos4+100)   // LINHA VETICAL   nLinCab+152
	oPrintPvt:Line( nLinCab, nPos4+170, nLinCab+14, nPos4+170)   // LINHA VETICAL   nLinCab+152
	oPrintPvt:Line( nLinCab, nPos4+240, nLinCab+14, nPos4+240)   // LINHA VETICAL   nLinCab+152
	oPrintPvt:Line( nLinCab, nPos4+295, nLinCab+14, nPos4+295)   // LINHA VETICAL   nLinCab+152
	oPrintPvt:Line( nLinCab, nPos4+343, nLinCab+14, nPos4+343)   // LINHA VETICAL   nLinCab+152
	// oPrintPvt:Line( nLinCab, nPos4+363, nLinCab+14, nPos4+363)   // LINHA VETICAL   nLinCab+152


	// oPrintPvt:SayAlign(nLinCab,  nPos0+32 , /*001*/ 'LT Ambientes',  oFontDet, 58, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab,  nPos0+32 , /*001*/ 'Litros a 20°',  oFont10N, 58, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab,  nPos0+102, /*001*/ 'PESO',          oFont10N, 58, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab,  nPos0+172, /*001*/ 'Dens. Obs.',    oFont10N, 58, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab,  nPos0+242, /*001*/ 'Temperatura',   oFont10N, 58, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab,  nPos0+297, /*001*/ 'Dens. A 20°',   oFont10N, 58, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab,  nPos0+345, /*001*/ 'Fator Correção',oFont10N, 58, 05, , PAD_LEFT, )

	// oPrintPvt:SayAlign(nLinCab,  nPos4+32 , /*001*/ 'LT Ambientes',  oFont10N, 58, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab,  nPos4+32 , /*001*/ 'Litros a 20°',  oFont10N, 58, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab,  nPos4+102, /*001*/ 'PESO',          oFont10N, 58, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab,  nPos4+172, /*001*/ 'Dens. Obs.',    oFont10N, 58, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab,  nPos4+242, /*001*/ 'Temperatura',   oFont10N, 58, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab,  nPos4+297, /*001*/ 'Dens. A 20°',   oFont10N, 58, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinCab,  nPos4+345, /*001*/ 'Fator Correção',oFont10N, 58, 05, , PAD_LEFT, )

	oPrintPvt:Line(nLinCab,nPos0,nLinCab,nPos8)
	nLinCab += 14

	nLinAux0 := nLinCab
	nLinAux1 := nLinCab

	(cAlias)->(DbGotop())
	while  !(cAlias)->(EoF())
		if (cAlias)->(ZB_TIPO)=='C'
			oPrintPvt:Box(nLinAux0,nPos0,nLinAux0+14,nPos8)
			oPrintPvt:Line( nLinAux0, nPos0+30,  nLinAux0+14, nPos0+30 )   // LINHA VETICAL
			oPrintPvt:Line( nLinAux0, nPos0+100, nLinAux0+14, nPos0+100)
			oPrintPvt:Line( nLinAux0, nPos0+170, nLinAux0+14, nPos0+170)
			oPrintPvt:Line( nLinAux0, nPos0+240, nLinAux0+14, nPos0+240)
			oPrintPvt:Line( nLinAux0, nPos0+295, nLinAux0+14, nPos0+295)
			oPrintPvt:Line( nLinAux0, nPos0+343, nLinAux0+14, nPos0+343)

			oPrintPvt:Line( nLinAux0, nPos4,  	nLinAux0+14, nPos4 )
			oPrintPvt:Line( nLinAux0, nPos4+30,  nLinAux0+14, nPos4+30 )
			oPrintPvt:Line( nLinAux0, nPos4+100, nLinAux0+14, nPos4+100)
			oPrintPvt:Line( nLinAux0, nPos4+170, nLinAux0+14, nPos4+170)
			oPrintPvt:Line( nLinAux0, nPos4+240, nLinAux0+14, nPos4+240)
			oPrintPvt:Line( nLinAux0, nPos4+295, nLinAux0+14, nPos4+295)
			oPrintPvt:Line( nLinAux0, nPos4+343, nLinAux0+14, nPos4+343)

			oPrintPvt:SayAlign(nLinAux0,  nPos0+3, 	/*001*/ (cAlias)->(ZB_TANQUE), 	oFont12N, 30, 05, , PAD_LEFT, )
			oPrintPvt:SayAlign(nLinAux0,  nPos0+32 , /*001*/ strTran(Transform((cAlias)->(ZB_VOL20),"@E 999,999,999"),',','.'),	 oFont10N, 58, 05, , PAD_LEFT, )
			oPrintPvt:SayAlign(nLinAux0,  nPos0+102, /*001*/ strTran(Transform((cAlias)->(ZB_PESO),"@E 999,999,999"),',','.'), 	 oFont10N, 58, 05, , PAD_LEFT, )
			oPrintPvt:SayAlign(nLinAux0,  nPos0+172, /*001*/ strTran(TRANSFORM((cAlias)->(ZB_DENSAMO),"@E 9.9999"),',','.'), oFont10N, 58, 05, , PAD_LEFT, )
			oPrintPvt:SayAlign(nLinAux0,  nPos0+242, /*001*/ alltrim(strTran(TRANSFORM((cAlias)->(ZB_TEMPAMO),'@E 999.9'),',','.')),	 oFont10N, 58, 05, , PAD_LEFT, )
			oPrintPvt:SayAlign(nLinAux0,  nPos0+297, /*001*/ strTran(TRANSFORM((cAlias)->(ZB_DENS20),"@E 9.9999"),',','.'),	 oFont10N, 58, 05, , PAD_LEFT, )
			oPrintPvt:SayAlign(nLinAux0,  nPos0+345, /*001*/ strTran(TRANSFORM((cAlias)->(ZB_FATOR) ,"@E 9.9999"),',','.'),	 oFont10N, 58, 05, , PAD_LEFT, )

			nDens20C += (cAlias)->(ZB_DENS20)
			nLinAux0 += 14

		elseif (cAlias)->(ZB_TIPO)=='D'

			oPrintPvt:SayAlign(nLinAux1,  nPos4+3, 	/*001*/ (cAlias)->(ZB_TANQUE),	oFont12N, 30, 05, , PAD_LEFT, )
			oPrintPvt:SayAlign(nLinAux1,  nPos4+32 , /*001*/ strTran(Transform((cAlias)->(ZB_VOL20),"@E 999,999,999"),',','.'),	oFont10N, 58, 05, , PAD_LEFT, )
			oPrintPvt:SayAlign(nLinAux1,  nPos4+102, /*001*/ strTran(Transform((cAlias)->(ZB_PESO) ,"@E 999,999,999"),',','.'), 	oFont10N, 58, 05, , PAD_LEFT, )
			oPrintPvt:SayAlign(nLinAux1,  nPos4+172, /*001*/ strTran(TRANSFORM((cAlias)->(ZB_DENSAMO),"@E 9.9999"),',','.'),	oFont10N, 58, 05, , PAD_LEFT, )
			oPrintPvt:SayAlign(nLinAux1,  nPos4+242, /*001*/ alltrim(strTran(TRANSFORM((cAlias)->(ZB_TEMPAMO), '@E 999.9'),',','.')),	oFont10N, 58, 05, , PAD_LEFT, )
			oPrintPvt:SayAlign(nLinAux1,  nPos4+297, /*001*/ strTran(TRANSFORM((cAlias)->(ZB_DENS20),"@E 9.9999"),',','.'),	oFont10N, 58, 05, , PAD_LEFT, )
			oPrintPvt:SayAlign(nLinAux1,  nPos4+345, /*001*/ strTran(TRANSFORM((cAlias)->(ZB_FATOR) ,"@E 9.9999"),',','.'),	oFont10N, 58, 05, , PAD_LEFT, )

			nDens20D += (cAlias)->(ZB_DENS20)
			// oPrintPvt:Line(nLinCab,nPos0,nLinCab,nPos8)
			nLinAux1 += 14
		EndIf
		(cAlias)->(DbSkip())
	Enddo

	nLinCab += nLinAux0
	nLinCab += 14

	// encerrar para imprimir a proxima pagina
	if nLinCab < nLinFin
		nLinAtu := nLinFin
	Else
		nLinAtu := nLinCab
	EndIf
	*
return

// Diferenças de Alturas										Diferenças de Referências										
// 1BB		 0,8		1BE		-2,0	1BB	 	-0,5			1BE			0,0		
// 2BB		-3,5		2BE		-1,1	2BB		 0,1			2BE			0,0		
// 3BB		-6,3		3BE		-2,3	3BB		 0,1			3BE		   -0,5		
// 4BB		-0,5		4BE		 3,4	4BB		 0,0			4BE			0,0		

static function FbordoAnb()

	Local lPula := .F.
	Local nX := 0
	Local aDifVolCar := {}
	Local aDifVolDes := {}
	Local nDifDens20 := 0
	Local nDifVolAmbTT := 0
	Local nDifVol20TT := 0
	local cCidOri := ''
	local cCidDes := ''

	(cAlias)->(DbGotop())

	// POSICIONA NA VIAGEM PARA PEGAR A ROTA
	DbSelectArea('DTQ')
	DbSetOrder(1) //- DTQ_FILIAL+DTQ_FILORI+DTQ_VIAGEM
	MsSeek(xFilial("DTQ")+(cAlias)->ZA_VIAGEM)

	// Posiciona no Cadastro de Rotas
	DA8->(dbSetOrder(1))    // DA8_FILIAL+DA8_COD
	DA8->(dbSeek(XFILIAL("DA8")+DTQ->DTQ_ROTA))

	// Posiciona no Cadastro da Cidade Origem
	DUY->(dbSetOrder(1))    // DUY_FILIAL+DUY_GRPVEN
	If DUY->(dbSeek(XFILIAL("DUY")+DA8->DA8_CDRORI))
		cCidOri := Alltrim(DUY->DUY_DESCRI)
	Endif
	// Posiciona no Cadastro da Cidade Destino
	DUY->(dbSetOrder(1))    // DUY_FILIAL+DUY_GRPVEN
	If DUY->(dbSeek(XFILIAL("DUY")+DA8->DA8_CDRCAL))
		cCidDes := Alltrim(DUY->DUY_DESCRI)
	Endif

	nLinAux0 := nLinCab
	oPrintPvt:SayAlign(nLinCab,  nPos0, /*001*/  'Carregamento (Origem)', oFont14N, 160, 05, , PAD_CENTER, )
	nLinAux0 += 14
	oPrintPvt:Box(nLinAux0,nPos0,nLinAux0+70,nPos2-50)
	oPrintPvt:Line( nLinAux0, nPos1-10,  nLinAux0+70, nPos1-10 )   // LINHA VETICAL
	oPrintPvt:SayAlign(nLinAux0,  nPos0+3, /*001*/  'Bordo Ambiente',					oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos1,   /*001*/  CVALTOCHAR(Alltrim(Transform((cAlias)->(ZA_BDAMBC),"@E 999,999,999"  ))),	oFont10N, 310, 05, , PAD_LEFT, )

	oPrintPvt:Line(nLinAux0,nPos0,nLinAux0,nPos2-50)
	nLinAux0 += 14
	oPrintPvt:SayAlign(nLinAux0,  nPos0+3, /*001*/  'Bordo a 20°', 						oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos1,   /*001*/ Alltrim(Transform((cAlias)->(ZA_BD20C),"@E 999,999,999"  )) , 	oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:Line(nLinAux0,nPos0,nLinAux0,nPos2-50)
	nLinAux0 += 14
	oPrintPvt:SayAlign(nLinAux0,  nPos0+3, /*001*/  'Volume Terra a 20°', 	oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos1,   /*001*/ Alltrim(Transform((cAlias)->(ZA_VOL20TC),"@E 999,999,999"  )) , 	oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:Line(nLinAux0,nPos0,nLinAux0,nPos2-50)
	nLinAux0 += 14
	oPrintPvt:SayAlign(nLinAux0,  nPos0+3, /*001*/  'Percentual (%)', 				 oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos1,   /*001*/ Alltrim(CVALTOCHAR((cAlias)->(ZA_PERCC) )), oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:Line(nLinAux0,nPos0,nLinAux0,nPos2-50)
	nLinAux0 += 14
	oPrintPvt:SayAlign(nLinAux0,  nPos0+3, /*001*/  'Quantidade a Absorver', 			oFont10N, 310, 05,IIF((cAlias)->(ZA_QTDABS)<0,CLR_HRED,CLR_BLACK) , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos1,   /*001*/ CVALTOCHAR(Alltrim(Transform((cAlias)->(ZA_QTDABS),"@E 999,999,999"  ))) ,  oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:Line(nLinAux0,nPos0,nLinAux0,nPos2-50)
	nLinAux0 += 14

	nLinAux0 := nLinCab
	oPrintPvt:SayAlign(nLinCab,  nPos2-50, /*001*/  'Descarregamento (Destino)', oFont14N, 160, 05, , PAD_CENTER, )
	nLinAux0 += 14
	oPrintPvt:Box(nLinAux0,nPos2-50,nLinAux0+70,nPos4-90)
	oPrintPvt:Line( nLinAux0, nPos3-50,  nLinAux0+70, nPos3-50 )   // LINHA VETICAL
	oPrintPvt:SayAlign(nLinAux0,  nPos2-47, /*001*/  'Bordo Ambiente', 					oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3-40, /*001*/  CVALTOCHAR(Alltrim(Transform((cAlias)->(ZA_BDAMBD),"@E 999,999,999"  ))),  oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:Line(nLinAux0,nPos2-50,nLinAux0,nPos4-90)
	nLinAux0 += 14
	oPrintPvt:SayAlign(nLinAux0,  nPos2-47, /*001*/  'Bordo a 20°', 					oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3-40, /*001*/  CVALTOCHAR(Alltrim(Transform((cAlias)->(ZA_BD20D),"@E 999,999,999"  ))),	oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:Line(nLinAux0,nPos2-50,nLinAux0,nPos4-90)
	nLinAux0 += 14
	oPrintPvt:SayAlign(nLinAux0,  nPos2-47, /*001*/   'Volume Terra a 20°', 	oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3-40, /*001*/  CVALTOCHAR(Alltrim(Transform((cAlias)->(ZA_VOL20TD),"@E 999,999,999"  ))), 		oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:Line(nLinAux0,nPos2-50,nLinAux0,nPos4-90)
	nLinAux0 += 14
	oPrintPvt:SayAlign(nLinAux0,  nPos2-47, /*001*/  'Percentual (%)',		 			oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3-40, /*001*/  Alltrim(CVALTOCHAR((cAlias)->(ZA_PERCD) )),	oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:Line(nLinAux0,nPos2-50,nLinAux0,nPos4-90)
	nLinAux0 += 14
	oPrintPvt:SayAlign(nLinAux0,  nPos2-47, /*001*/  'Quantidade a Cobrar', 			oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3-40, /*001*/  CVALTOCHAR(Alltrim(Transform((cAlias)->(ZA_QTDCOB),"@E 999,999,999"  ))), oFont10N, 310, 05,IIF((cAlias)->(ZA_QTDCOB)<0,CLR_HRED,CLR_BLACK), PAD_LEFT, )
	oPrintPvt:Line(nLinAux0,nPos2-50,nLinAux0,nPos4-90)

	/* BOX: DIFERENÇAS */
	***
	nLinAux0:= nLinCab
	oPrintPvt:SayAlign(nLinAux0,  nPos4-80, /*330*/  'Diferença altura', oFont14, 110, 05, , PAD_CENTER, )
	// nLinAux0 +=14
	// oPrintPvt:SayAlign(nLinAux0,  nPos4-80, /*330*/  'Bombordo', oFont09, 110, 05, , PAD_CENTER, )
	nLinAux0 +=12
	oPrintPvt:SayAlign(nLinAux0,  nPos4-80, /*330*/  'Tanq Bomb.', oFont09, 110, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos4-40, /*330*/  'Dif Bomb.', oFont09,  110, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos4-5, /*330*/   'Tanq Bore.', oFont09, 110, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos4+32, /*330*/  'Dif Bore.', oFont09,  110, 05, , PAD_LEFT, )
	nLinAux0 +=10
	// oPrintPvt:Box(nLinAux0,nPos4-80,nLinAux0+70,nPos4+70) // 330 - 490
	***

	nLinAux1 := nLinAux0
	aDifVolCar  := {}
	aDifVolDes  := {}
	aTipoOper := {}
	(cAlias)->(DbGotop())
	while  !(cAlias)->(EoF())
		if (cAlias)->ZB_TIPO=='C'
			aAdd(aDifVolCar,{(cAlias)->(ZB_TANQUE),strtran(AllTrim(Transform((cAlias)->(ZB_DIFAL),"@E 999.9")),',','.')})
		else
			aAdd(aDifVolDes,{(cAlias)->(ZB_TANQUE),strtran(AllTrim(Transform((cAlias)->(ZB_DIFAL),"@E 999.9")),',','.')})
		endif
		(cAlias)->(DbSkip())
	Enddo
	aTipoOper := IIF(len(aDifVolDes)>0,aDifVolDes,aDifVolCar)

	for nX := 1 to len(aTipoOper)
		IF substr(aTipoOper[NX,1],2,2) $ 'BB'
			oPrintPvt:Box(nLinAux0,nPos4-80,nLinAux0+14,nPos4+70)
			oPrintPvt:Line( nLinAux0, nPos4-43,  nLinAux0+14, nPos4-43 )   	// LINHA VETICAL
			oPrintPvt:Line( nLinAux0, nPos4-5,  nLinAux0+14, nPos4-5 )   	// LINHA VETICAL
			oPrintPvt:Line( nLinAux0, nPos4+32,  nLinAux0+14, nPos4+32 )   	// LINHA VETICAL

			oPrintPvt:SayAlign(nLinAux0,  nPos4-80,  aTipoOper[NX,1]  ,oFont12N, 30, 05, , PAD_CENTER, )
			oPrintPvt:SayAlign(nLinAux0,  nPos4-43,aTipoOper[NX,2] ,oFont12N, 30, 05,IIF(VAL(aTipoOper[NX,2])<0,CLR_HRED,CLR_BLACK) , PAD_CENTER, )
			lPula:= .F.
		Else
			oPrintPvt:SayAlign(nLinAux0,  nPos4-5,   aTipoOper[NX,1]	,oFont12N, 30, 05, , PAD_CENTER, )
			oPrintPvt:SayAlign(nLinAux0,  nPos4+32,  aTipoOper[NX,2]	,oFont12N, 30, 05,IIF(VAL(aTipoOper[NX,2])<0,CLR_HRED,CLR_BLACK) , PAD_CENTER, )
			lPula:= .T.
		endif

		if lPula
			nLinAux0 += 14
		endif
	Next

	***
	nLinAux0:= nLinCab
	oPrintPvt:SayAlign(nLinAux0,  nPos4+80, /*001*/  'Diferença Referencia', oFont14, 110, 05, , PAD_CENTER, )
	nLinAux0 +=12
	oPrintPvt:SayAlign(nLinAux0,  nPos4+80, /*330*/  'Tanq Bomb.', oFont09, 110, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos5+20, /*330*/  'Dif Bomb.', oFont09, 110, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos5+63, /*330*/   'Tanq Bore.', oFont09, 110, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos6+3, /*330*/  'Dif Bore.', oFont09, 110, 05, , PAD_LEFT, )
	nLinAux0 +=10
	***
	aDifVolCar  := {}
	aDifVolDes  := {}
	aTipoOper := {}
	(cAlias)->(DbGotop())
	while  !(cAlias)->(EoF())
		if (cAlias)->ZB_TIPO=='C'
			aAdd(aDifVolCar,{(cAlias)->(ZB_TANQUE),strtran(AllTrim(Transform((cAlias)->(ZB_DIFRE),"@E 999.9")),',','.')})
		else
			aAdd(aDifVolDes,{(cAlias)->(ZB_TANQUE),strtran(AllTrim(Transform((cAlias)->(ZB_DIFRE),"@E 999.9")),',','.')})
		endif
		(cAlias)->(DbSkip())
	Enddo

	aTipoOper := IIF(len(aDifVolDes)>0,aDifVolDes,aDifVolCar)

	for nX := 1 to Len(aTipoOper)
		IF substr(aTipoOper[nX,1],2,2) $ 'BB'
			oPrintPvt:Box(nLinAux0,nPos4+80,nLinAux0+14,nPos6+40)
			oPrintPvt:Line( nLinAux0, nPos5+20,  nLinAux0+14, nPos5+20 )   	// LINHA VETICAL
			oPrintPvt:Line( nLinAux0,nPos5+60,  nLinAux0+14,nPos5+60 )   	// LINHA VETICAL
			oPrintPvt:Line( nLinAux0, nPos6,  nLinAux0+14, nPos6 )   	// LINHA VETICAL
			oPrintPvt:SayAlign(nLinAux0,  nPos4+80,aTipoOper[NX,1], oFont12N, 30, 05, , PAD_CENTER, )
			oPrintPvt:SayAlign(nLinAux0,  nPos5+23,aTipoOper[NX,2] , oFont12N, 30, 05,IIF(VAL(aTipoOper[NX,2])<0,CLR_HRED,CLR_BLACK) , PAD_CENTER, )
			lPula := .F.
		Else
			oPrintPvt:SayAlign(nLinAux0,  nPos5+63,	aTipoOper[NX,1], oFont12N, 30, 05, , PAD_CENTER, )
			oPrintPvt:SayAlign(nLinAux0,  nPos6+3,aTipoOper[NX,2] , oFont12N, 30, 05,IIF(VAL(aTipoOper[NX,2])<0,CLR_HRED,CLR_BLACK) , PAD_CENTER, )
			lPula := .T.
		EndIf

		if lPula
			nLinAux0 += 14
		endif
	Next

	***
	nLinAux0:= nLinCab
	oPrintPvt:SayAlign(nLinAux0,  nPos6+50, /*001*/  'Diferença Ref / Alt', oFont14, 110, 05, , PAD_CENTER, )
	nLinAux0 +=12
	oPrintPvt:SayAlign(nLinAux0,  nPos6+50, /*330*/  'Tanq Bomb.', oFont09, 110, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos6+90, /*330*/  'Dif Bomb.', oFont09, 110, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos7+30, /*330*/   'Tanq Bore.', oFont09, 110, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos7+70, /*330*/  'Dif Bore.', oFont09, 110, 05, , PAD_LEFT, )
	nLinAux0 +=10
	// oPrintPvt:Box(nLinAux0,nPos6+50,nLinAux0+70,nPos8)
	***
	aDifVolCar  := {}
	aDifVolDes  := {}
	aTipoOper := {}
	(cAlias)->(DbGotop())
	while  !(cAlias)->(EoF())
		if (cAlias)->ZB_TIPO=='C'
			aAdd(aDifVolCar,{(cAlias)->(ZB_TANQUE),strtran(AllTrim(Transform((cAlias)->(ZB_DIF),"@E 999.9")),',','.')})
		else
			aAdd(aDifVolDes,{(cAlias)->(ZB_TANQUE),strtran(AllTrim(Transform((cAlias)->(ZB_DIF),"@E 999.9")),',','.')})
		endif
		(cAlias)->(DbSkip())
	Enddo

	aTipoOper := IIF(len(aDifVolDes)>0,aDifVolDes,aDifVolCar)
	for nX := 1 to Len(aTipoOper)
		IF substr(aTipoOper[nX,1],2,2) $ 'BB'
			oPrintPvt:Box(nLinAux0,nPos6+50,nLinAux0+14,nPos8)
			oPrintPvt:Line( nLinAux0, nPos6+90,  nLinAux0+14, nPos6+90 )   	// LINHA VETICAL
			oPrintPvt:Line( nLinAux0,nPos7+30,  nLinAux0+14,nPos7+30 )   	// LINHA VETICAL
			oPrintPvt:Line( nLinAux0, nPos7+70,  nLinAux0+14, nPos7+70 )   	// LINHA VETICAL

			oPrintPvt:SayAlign(nLinAux0,  nPos6+50,aTipoOper[NX,1], 	oFont12N, 30, 05, , PAD_CENTER, )
			oPrintPvt:SayAlign(nLinAux0,  nPos6+90, aTipoOper[NX,2], oFont12N, 30, 05,IIF(VAL(aTipoOper[NX,2])<0,CLR_HRED,CLR_BLACK) , PAD_CENTER, )
			lPula := .F.
		else
			oPrintPvt:SayAlign(nLinAux0,  nPos7+30, aTipoOper[NX,1], 	oFont12N, 30, 05, , PAD_CENTER, )
			oPrintPvt:SayAlign(nLinAux0,  nPos7+70, aTipoOper[NX,2], oFont12N, 30, 05,IIF(VAL(aTipoOper[NX,2])<0,CLR_HRED,CLR_BLACK) , PAD_CENTER, )
			lPula := .T.
		EndIf

		if lPula
			nLinAux0 += 14
		endif
	Next
	if nLinAux0<=306
		nLinAux0 := 314
	endif

	nLinCab := nLinAux0

	// Atracação	11:40		  Medição		18:12		 Atracação		 05:30			Final Oper.		11:07
	// Início Oper.	12:58		  Liberação		19:00		 Medição		 07:28			Liberação		13:00
	// Final Oper.	15:58		  Temp. Oper.	03:00		 Início Oper.	 09:12			Temp. Oper.		01:55
	// Cal. Ré		Cal. M. Nau	  Cal Vante		Cal. Médio	 Cal. Ré		 Cal. M. Nau	Cal Vante		Cal. Médio
	// 235			240				 240		  238		   235				240			  240			  238
	(cAlias)->(DbGotop())
	oPrintPvt:SayAlign(nLinAux0,  nPos0, /*001*/  'Carregamento (Origem)', oFont14N, 160, 05, , PAD_CENTER, )
	nLinAux0 += 14
	oPrintPvt:Box(nLinAux0,nPos0,nLinAux0+84,nPos2+20)
	oPrintPvt:Line( nLinAux0, nPos0+60,  nLinAux0+84, nPos0+60 )   // LINHA VETICAL
	oPrintPvt:Line( nLinAux0, nPos0+113,  nLinAux0+84, nPos0+113 )   // LINHA VETICAL
	oPrintPvt:Line( nLinAux0, nPos1+60,  nLinAux0+84, nPos1+60)   // LINHA VETICAL

	oPrintPvt:SayAlign(nLinAux0,  nPos0+3, /*001*/  'Atracação'		, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos0+63, /*001*/ Alltrim(Transform((cAlias)->(ZA_ATRACAC),     "@R 99:99")), oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos0+116, /*001*/'Medição'		, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos1+62, /*001*/ Alltrim(Transform((cAlias)->(ZA_HORMEDC),     "@R 99:99")) , oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:Line(nLinAux0,nPos0,nLinAux0,nPos2+20)
	nLinAux0 += 14
	oPrintPvt:SayAlign(nLinAux0,  nPos0+3, /*001*/  'Início Oper.'	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos0+63, /*001*/ Alltrim(Transform((cAlias)->(ZA_INIOPEC),     "@R 99:99")), oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos0+116, /*001*/'Liberação'		, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos1+62, /*001*/ Alltrim(Transform((cAlias)->(ZA_LIBERAC),     "@R 99:99")), oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:Line(nLinAux0,nPos0,nLinAux0,nPos2+20)
	nLinAux0 += 14
	oPrintPvt:SayAlign(nLinAux0,  nPos0+3, /*001*/  'Final Oper.'	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos0+63, /*001*/ Alltrim(Transform((cAlias)->(ZA_FIMOPEC),     "@R 99:99")), oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos0+116, /*001*/'Temp. Oper.'	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos1+62, /*001*/ Alltrim(Transform((cAlias)->(ZA_TEMOPEC),     "@R 99:99")), oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:Line(nLinAux0,nPos0,nLinAux0,nPos2+20)
	nLinAux0 += 14
	oPrintPvt:SayAlign(nLinAux0,  nPos0+3, /*001*/'Vazao'	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos0+63, /*001*/ IIF((cAlias)->(ZA_VAZAOC)<>0,Transform((cAlias)->(ZA_VAZAOC),     "@R 99:99"),'00:00'), oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:Line(nLinAux0,nPos0,nLinAux0,nPos2+20)
	nLinAux0 += 14

	oPrintPvt:SayAlign(nLinAux0,  nPos0+3, /*001*/  'Cal. Ré'	    , oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos0+116, /*001*/ 'Cal Vante'	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos1+62, /*001*/  'Cal. Médio'	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:Line(nLinAux0,nPos0,nLinAux0,nPos2+20)
	nLinAux0 += 14
	oPrintPvt:SayAlign(nLinAux0,  nPos0+3,  /*001*/  'Bombordo'		, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos0+63, /*001*/  CVALTOCHAR((cAlias)->(ZA_CALREC)) , oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos0+116, /*001*/ CVALTOCHAR((cAlias)->(ZA_CALVANC)) , oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos1+62, /*001*/  CVALTOCHAR((cAlias)->(ZA_CALMEDC))	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:Line(nLinAux0,nPos0,nLinAux0,nPos2+20)
	nLinAux0 += 14
	oPrintPvt:SayAlign(nLinAux0,  nPos0+3,  /*001*/  'Borest'	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos0+63, /*001*/  CVALTOCHAR((cAlias)->(ZA_CALRE2C)) , oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos0+116, /*001*/ CVALTOCHAR((cAlias)->(ZA_CALVA2C)) , oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos1+62, /*001*/  CVALTOCHAR((cAlias)->(ZA_CALME2C))	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:Line(nLinAux0,nPos0,nLinAux0,nPos2+20)
	nLinAux0 += 14
	nLinAux0 := nLinCab
	oPrintPvt:SayAlign(nLinCab,  nPos2+30, /*001*/  'Descarregamento (Destino)', oFont14N, 160, 05, , PAD_CENTER, )
	nLinAux0 += 14

	oPrintPvt:Box(nLinAux0,nPos2+30,nLinAux0+84,nPos4+50)

	oPrintPvt:Line( nLinAux0, nPos2+85,  nLinAux0+84, nPos2+85 )   // LINHA VETICAL
	oPrintPvt:Line( nLinAux0, nPos3+41,  nLinAux0+84, nPos3+40 )   // LINHA VETICAL
	oPrintPvt:Line( nLinAux0, nPos3+99,  nLinAux0+84, nPos3+99 )   // LINHA VETICAL

	oPrintPvt:SayAlign(nLinAux0,  nPos2+33, /*001*/ 'Atracação'		, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos2+88, /*001*/  Alltrim(Transform((cAlias)->(ZA_ATRACAD),     "@R 99:99")), oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3+44,	/*001*/  'Medição'		, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3+102,/*001*/  Alltrim(Transform((cAlias)->(ZA_HORMEDD),     "@R 99:99")), oFont10N, 310, 05, , PAD_LEFT, )
	nLinAux0 += 14
	oPrintPvt:Line(nLinAux0,nPos2+30,nLinAux0,nPos4+50)
	oPrintPvt:SayAlign(nLinAux0,  nPos2+33, /*001*/ 'Início Oper.'	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos2+88, /*001*/ Alltrim(Transform((cAlias)->(ZA_INIOPED),     "@R 99:99")), oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3+44,/*001*/  'Liberação'		, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3+102, /*001*/Alltrim(Transform((cAlias)->(ZA_LIBERAD),     "@R 99:99")), oFont10N, 310, 05, , PAD_LEFT, )
	nLinAux0 += 14
	oPrintPvt:Line(nLinAux0,nPos2+30,nLinAux0,nPos4+50)
	oPrintPvt:SayAlign(nLinAux0,  nPos2+33, /*001*/ 'Final Oper.'	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos2+88, /*001*/  Alltrim(Transform((cAlias)->(ZA_FIMOPED),     "@R 99:99")), oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3+44,/*001*/  'Temp. Oper.'	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3+102, /*001*/ Alltrim(Transform((cAlias)->(ZA_TEMOPED),     "@R 99:99")), oFont10N, 310, 05, , PAD_LEFT, )
	nLinAux0 += 14
	oPrintPvt:SayAlign(nLinAux0,  nPos2+33, /*001*/'Vazao'	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos2+88, /*001*/ IIF((cAlias)->(ZA_VAZAOD)<>0,Transform((cAlias)->(ZA_VAZAOD),     "@R 99:99"),'00:00'), oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:Line(nLinAux0,nPos2+30,nLinAux0,nPos4+50)
	nLinAux0 += 14

	oPrintPvt:Line(nLinAux0,nPos2+30,nLinAux0,nPos4+50)
	oPrintPvt:SayAlign(nLinAux0,  nPos2+88, /*001*/  'Cal. Ré'	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3+44, /*001*/  'Cal Vante'	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3+102, /*001*/ 'Cal. Médio'	, oFont10N, 310, 05, , PAD_LEFT, )
	nLinAux0 += 14
	oPrintPvt:Line(nLinAux0,nPos2+30,nLinAux0,nPos4+50)
	// oPrintPvt:SayAlign(nLinAux0,  nPos2+33,  /*001*/  CVALTOCHAR((cAlias)->(ZA_CALRED))	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos2+33,  /*001*/ 'Bombordo'		, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos2+88, /*001*/   CVALTOCHAR((cAlias)->(ZA_CALRED)), oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3+44, /*001*/   CVALTOCHAR((cAlias)->(ZA_CALVAND)), oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3+102, /*001*/  CVALTOCHAR((cAlias)->(ZA_CALMEDD))	, oFont10N, 310, 05, , PAD_LEFT, )
	nLinAux0 += 14
	oPrintPvt:Line(nLinAux0,nPos2+30,nLinAux0,nPos4+50)
	oPrintPvt:SayAlign(nLinAux0,  nPos2+33,  /*001*/ 'Borest'		, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos2+88, /*001*/   CVALTOCHAR((cAlias)->(ZA_CALRE2D)), oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3+44, /*001*/   CVALTOCHAR((cAlias)->(ZA_CALVA2D)), oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3+102, /*001*/  CVALTOCHAR((cAlias)->(ZA_CALME2D))	, oFont10N, 310, 05, , PAD_LEFT, )
	nLinAux0 += 14

	nLinBkp :=0
	nLinBkp := nLinAux0
	// CARREGAMENTO
	oPrintPvt:Box(nLinAux0,nPos0,nLinAux0+42,nPos2+20)
	oPrintPvt:SayAlign(nLinAux0,  nPos0+3, /*001*/   'BANDA', oFont10N, 105, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinAux0,  nPos0+116, /*001*/ 'TRIM', oFont10N, 105, 05, , PAD_CENTER, )
	nLinAux0 += 14
	oPrintPvt:Line(nLinAux0,nPos0,nLinAux0,nPos2+20)  // linha horizontal
	oPrintPvt:Line( nLinAux0, nPos0+60,  nLinAux0+28, nPos0+60 )   // LINHA VETICAL
	oPrintPvt:Line( nLinAux0-14, nPos0+113,  nLinAux0+28, nPos0+113 )   // LINHA VETICAL
	oPrintPvt:Line( nLinAux0, nPos1+60,  nLinAux0+28, nPos1+60)   // LINHA VETICAL

	oPrintPvt:SayAlign(nLinAux0,  nPos0+3, /*001*/   'BOMBORDO'	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos0+63, /*001*/  'BORESTE' 	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos0+116, /*001*/ 'PROA'		, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos1+63, /*001*/  'POPA' 	, oFont10N, 310, 05, , PAD_LEFT, )
	nLinAux0 += 14
	oPrintPvt:Line(nLinAux0,nPos0,nLinAux0,nPos2+20) // linha Horizontal
	oPrintPvt:SayAlign(nLinAux0,  nPos0+3, /*001*/   Alltrim(Transform((cAlias)->(ZA_BANBOMC),"@E 999,999,999"  )) , oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos0+63, /*001*/  Alltrim(Transform((cAlias)->(ZA_BANBORC),"@E 999,999,999"  )) , oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos0+116, /*001*/ Alltrim(Transform((cAlias)->(ZA_TRIPROC),"@E 999,999,999"  )) , oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos1+63, /*001*/  Alltrim(Transform((cAlias)->(ZA_TRIPOPC),"@E 999,999,999"  )) , oFont10N, 310, 05, , PAD_LEFT, )

	// DESCARREGAMENTO
	nLinAux0 := nLinBkp
	oPrintPvt:Box(nLinAux0,nPos2+30,nLinAux0+42,nPos4+50)
	oPrintPvt:SayAlign(nLinAux0,  nPos2+30, /*001*/  'BANDA', oFont10N, 105, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3+44, /*001*/ 'TRIM', oFont10N, 105, 05, , PAD_CENTER, )
	nLinAux0 += 14
	oPrintPvt:Line(nLinAux0,nPos2+30,nLinAux0,nPos4+50)  // linha Horizontal
	oPrintPvt:Line( nLinAux0, nPos2+85,  nLinAux0+28, nPos2+85 )   // LINHA VETICAL
	oPrintPvt:Line( nLinAux0-14, nPos3+41,  nLinAux0+28, nPos3+41 )   // LINHA VETICAL
	oPrintPvt:Line( nLinAux0, nPos3+99,  nLinAux0+28, nPos3+99 )   // LINHA VETICAL

	oPrintPvt:SayAlign(nLinAux0,  nPos2+33, /*001*/  'BOMBORDO'	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos2+88, /*001*/  'BORESTE'	, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3+44, /*001*/  'PROA'		, oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3+102, /*001*/ 'POPA'		, oFont10N, 310, 05, , PAD_LEFT, )
	nLinAux0 += 14
	oPrintPvt:Line(nLinAux0,nPos2+30,nLinAux0,nPos4+50)  // linha Horizontal
	oPrintPvt:SayAlign(nLinAux0,  nPos2+33, /*001*/  Alltrim(Transform((cAlias)->(ZA_BANBOMD),"@E 999,999,999"  )) ,oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos2+88, /*001*/  Alltrim(Transform((cAlias)->(ZA_BANBORD),"@E 999,999,999"  )) ,oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3+44, /*001*/  Alltrim(Transform((cAlias)->(ZA_TRIPROD),"@E 999,999,999"  )) ,oFont10N, 310, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos3+102,/*001*/  Alltrim(Transform((cAlias)->(ZA_TRIPOPD),"@E 999,999,999"  )) ,oFont10N, 310, 05, , PAD_LEFT, )


	nLinAux0 := nLinCab
	if nDens20C > nDens20D
		nDifDens20 := nDens20C - nDens20D
	Else
		nDifDens20 := nDens20D - nDens20C
	endif
	oPrintPvt:SayAlign(nLinAux0,  nPos4+60, /*001*/  'Dif. Dens. a 20°', oFont14, 110, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos5+70, /*001*/  CVALTOCHAR(nDifDens20), oFont14, 110, 05, , PAD_LEFT, )

	/* VALOR FRETE*/
	oPrintPvt:SayAlign(nLinAux0,  nPos6+50, /*001*/  'Transito Excedido (dias)', oFont14, 110, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos7+50, /*001*/  CVALTOCHAR((cAlias)->ZA_TXTRAN), oFont14, 110, 05, , PAD_LEFT, )
	nLinAux0 += 14
	oPrintPvt:Line(nLinAux0, nPos4+60,nLinAux0,nPos8)
	oPrintPvt:SayAlign(nLinAux0,  nPos6+50, /*001*/  'Sobreestadia (dias)', oFont14, 110, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos7+50, /*001*/  CVALTOCHAR((cAlias)->ZA_TXSOB), oFont14, 110, 05, , PAD_LEFT, )
	nLinAux0 += 14
	oPrintPvt:Line(nLinAux0, nPos4+60,nLinAux0,nPos8)

	***
	nLinAux2 := nLinAux0
	oPrintPvt:SayAlign(nLinAux0,  nPos4+60, /*001*/  'Diferença no Vol. Ambiente', oFont14, 150, 05, , PAD_LEFT, )
	nLinAux0 +=12
	oPrintPvt:SayAlign(nLinAux0,  nPos4+60, /*330*/  'Tanq | dif Bombo |dif bore', oFont09, 110, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos5+48, /*330*/  'Tanq | dif Bombo |dif bore', oFont09, 110, 05, , PAD_LEFT, )
	// oPrintPvt:SayAlign(nLinAux0,  nPos5-20, /*330*/  'Dif Bomb.', oFont09, 110, 05, , PAD_LEFT, )
	// oPrintPvt:SayAlign(nLinAux0,  nPos5+60, /*330*/   'Tanq Bore.', oFont09, 110, 05, , PAD_LEFT, )
	// oPrintPvt:SayAlign(nLinAux0,  nPos6,	/*330*/  'Dif Bore.', oFont09, 110, 05, , PAD_LEFT, )
	nLinAux0 +=10
	***
	***
	aDifVolCar  := {}
	aDifVolDes  := {}
	aTipoOper := {}
	(cAlias)->(DbGotop())
	while  !(cAlias)->(EoF())
		if (cAlias)->ZB_TIPO=='C'
			aAdd(aDifVolCar,{(cAlias)->(ZB_TANQUE),(cAlias)->(ZB_DIFVOL),(cAlias)->(ZB_DIFVO20)})
			aAdd(aDifVolCar,{(cAlias)->(ZB_TANQUE),VAL(strtran(AllTrim(Transform((cAlias)->(ZB_DIFVOL),"@E 999,999,999")),',','.')),VAL(strtran(AllTrim(Transform((cAlias)->(ZB_DIFVO20),"@E 999,999,999")),',','.'))})
		else
			aAdd(aDifVolDes,{(cAlias)->(ZB_TANQUE),(cAlias)->(ZB_DIFVOL),(cAlias)->(ZB_DIFVO20)})
		endif
		(cAlias)->(DbSkip())
	Enddo

	aTipoOper := IIF(len(aDifVolDes)>0,aDifVolDes,aDifVolCar)
	for nX := 1 to Len(aTipoOper)
		IF substr(aTipoOper[nX,1],2,2) $ 'BB'
			oPrintPvt:Box(nLinAux0,nPos4+60,nLinAux0+14,nPos6+40)
			oPrintPvt:Line( nLinAux0, nPos5-15,  nLinAux0+14, nPos5-15 )   	// LINHA VETICAL
			oPrintPvt:Line( nLinAux0, nPos5+15,  nLinAux0+14, nPos5+15 )   	// LINHA VETICAL
			oPrintPvt:Line( nLinAux0, nPos5+45,  nLinAux0+14, nPos5+45 )   	// LINHA VETICAL
			oPrintPvt:Line( nLinAux0,nPos5+70,  nLinAux0+14,nPos5+70 )   	// LINHA VETICAL
			oPrintPvt:Line( nLinAux0, nPos6,  nLinAux0+14, nPos6 )   	// LINHA VETICAL

			oPrintPvt:SayAlign(nLinAux0,  nPos4+62,aTipoOper[NX,1],    oFont10N, 30, 05, , PAD_LEFT, )
			oPrintPvt:SayAlign(nLinAux0,  nPos5-13,strtran(AllTrim(Transform(aTipoOper[NX,2],"@E 999,999,999")),',','.'),    oFont10N, 30, 05,IIF(aTipoOper[NX,2]<0,CLR_HRED,CLR_BLACK) , PAD_LEFT, )
			oPrintPvt:SayAlign(nLinAux0,  nPos5+17,strtran(AllTrim(Transform(aTipoOper[NX,3],"@E 999,999,999")),',','.'),    oFont10N, 30, 05,IIF(aTipoOper[NX,3]<0,CLR_HRED,CLR_BLACK) , PAD_LEFT, )
			lPula := .F.
		else
			oPrintPvt:SayAlign(nLinAux0,  nPos5+47,  aTipoOper[NX,1], oFont10N, 30, 05, , PAD_LEFT, )
			oPrintPvt:SayAlign(nLinAux0,  nPos5+72, strtran(AllTrim(Transform(aTipoOper[NX,2],"@E 999,999,999")),',','.'), oFont10N, 30, 05, IIF(aTipoOper[NX,2]<0,CLR_HRED,CLR_BLACK) , PAD_LEFT, )
			oPrintPvt:SayAlign(nLinAux0,  nPos6+2 , strtran(AllTrim(Transform(aTipoOper[NX,3],"@E 999,999,999")),',','.'), oFont10N, 30, 05,IIF(aTipoOper[NX,3]<0,CLR_HRED,CLR_BLACK) , PAD_LEFT, )
			lPula := .T.
		EndIf

		// nDifVolAmbTT += aTipoOper[NX,2]
		// nDifVol20TT +=   aTipoOper[NX,3]

		if lPula
			nLinAux0 += 14
		endif
	Next

	aEval( aTipoOper , {|x| nDifVolAmbTT  += x[2] } )
	aEval( aTipoOper , {|x| nDifVol20TT   += x[3] } )
	
	oPrintPvt:SayAlign(nLinAux0,  nPos4+60, /*001*/  'Total Ambiente', oFont12N, 70, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinAux0,  nPos5+60, /*001*/  strtran(AllTrim(Transform(nDifVolAmbTT,"@E 999,999,999")),',','.'), oFont12N, 30, 05,IIF(nDifVolAmbTT<0,CLR_HRED,CLR_BLACK), PAD_CENTER, )
	oPrintPvt:Line(nLinAux0,nPos4+60,nLinAux0,nPos6+40)
	nLinAux0 += 14
	oPrintPvt:SayAlign(nLinAux0,  nPos4+60, /*001*/  'Total Vol.20º', oFont12N, 70, 05, , PAD_CENTER, )
	oPrintPvt:SayAlign(nLinAux0,  nPos5+60, /*001*/  strtran(AllTrim(Transform(nDifVol20TT,"@E 999,999,999")),',','.'), oFont12N, 30, 05,IIF(nDifVol20TT<0,CLR_HRED,CLR_BLACK)  , PAD_CENTER, )
	oPrintPvt:Line(nLinAux0,nPos4+60,nLinAux0,nPos6+40)

	***
	nLinAux0:=nLinAux2
	// oPrintPvt:SayAlign(nLinAux0,  nPos6+50, /*001*/  'Diferença Ref / Alt', oFont14, 110, 05, , PAD_CENTER, )
	nLinAux0 += 14
	oPrintPvt:Box(nLinAux0,nPos6+50,nLinAux0+70,nPos8)
	oPrintPvt:Line( nLinAux0, nPos7+55,  nLinAux0+70, nPos7+55 )   // LINHA VETICAL
	***
	(cAlias)->(DbGotop())
	oPrintPvt:Line(nLinAux0,nPos6+50,nLinAux0,nPos8)
	oPrintPvt:SayAlign(nLinAux0,  nPos6+53, /*001*/  'Valor Transito Excedido:', oFont10N, 100, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos7+60, /*001*/  CVALTOCHAR((cAlias)->ZA_VALTRAN), oFont10N, 40, 05, , PAD_LEFT, )
	nLinAux0 += 14
	oPrintPvt:Line(nLinAux0,nPos6+50,nLinAux0,nPos8)
	oPrintPvt:SayAlign(nLinAux0,  nPos6+53, /*001*/  'Perda a Cobrar ou Sobra:', oFont10N, 100, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos7+60, /*001*/  CVALTOCHAR((cAlias)->ZA_VPERSOB), oFont10N, 40, 05,IIF((cAlias)->ZA_VPERSOB<0,CLR_HRED,CLR_BLACK), PAD_LEFT, )
	nLinAux0 += 14
	oPrintPvt:Line(nLinAux0,nPos6+50,nLinAux0,nPos8)
	oPrintPvt:SayAlign(nLinAux0,  nPos6+53, /*001*/  'Valor Unitário da NF:', oFont10N, 100, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos7+60, /*001*/  CVALTOCHAR((cAlias)->ZA_VALNF), oFont10N, 40, 05, , PAD_LEFT, )
	nLinAux0 += 14
	oPrintPvt:Line(nLinAux0,nPos6+50,nLinAux0,nPos8)
	oPrintPvt:SayAlign(nLinAux0,  nPos6+53, /*001*/  'Valor Sobreestadia:', oFont10N, 100, 05, , PAD_LEFT, )
	oPrintPvt:SayAlign(nLinAux0,  nPos7+60, /*001*/  CVALTOCHAR((cAlias)->ZA_VALSOB), oFont10N, 40, 05, , PAD_LEFT, )
	nLinAux0 += 14
	IF (cAlias)->ZA_VALTRAN + (cAlias)->ZA_VPERSOB > (cAlias)->ZA_VALSOB
		oPrintPvt:SayAlign(nLinAux0,  nPos6+53, /*001*/  'Receber Ipiranga:', oFont10N, 100, 05, , PAD_LEFT, )
		oPrintPvt:SayAlign(nLinAux0,  nPos7+60, /*001*/  CVALTOCHAR((cAlias)->ZA_VALLIQ), oFont10N, 40, 05,IIF((cAlias)->ZA_VALLIQ<0,CLR_HRED,CLR_BLACK) , PAD_LEFT, )
	Else
		oPrintPvt:SayAlign(nLinAux0,  nPos6+53, /*001*/  'Pagar Ipiranga:', oFont10N, 100, 05, , PAD_LEFT, )
		oPrintPvt:SayAlign(nLinAux0,  nPos7+60, /*001*/  CVALTOCHAR((cAlias)->ZA_VALLIQ), oFont10N, 40, 05,IIF((cAlias)->ZA_VALLIQ<0,CLR_HRED,CLR_BLACK) , PAD_LEFT, )
	EndIf
	// oPrintPvt:SayAlign(nLinAux0,  nPos6+53, /*001*/  'Val. a Cobrar ou Desc:', oFont10N, 100, 05, , PAD_LEFT, )
	// oPrintPvt:SayAlign(nLinAux0,  nPos7+60, /*001*/  CVALTOCHAR((cAlias)->ZA_VALLIQ), oFont10N, 40, 05, , PAD_LEFT, )
	oPrintPvt:Line(nLinAux0,nPos6+50,nLinAux0,nPos8)
	// oPrintPvt:Line(nLinAux0,nPos6+50,nLinAux0,nPos8)
	// oPrintPvt:SayAlign(nLinAux0,  nPos6+53, /*001*/  'Fator de Correção 20°:', oFont10N, 100, 05, , PAD_LEFT, )
	// oPrintPvt:SayAlign(nLinAux0,  nPos7+60, /*001*/  '1,0233', oFont10N, 30, 05, , PAD_LEFT, )
	// nLinAux0 += 14
	// oPrintPvt:Line(nLinAux0,nPos6+50,nLinAux0,nPos8)
	// oPrintPvt:SayAlign(nLinAux0,  nPos6+53, /*001*/  'Perda a Cobrar ou Sobra:', oFont10N, 100, 05, , PAD_LEFT, )
	// oPrintPvt:SayAlign(nLinAux0,  nPos7+60, /*001*/  '2BE', oFont10N, 30, 05, , PAD_LEFT, )
	// nLinAux0 += 14
	// oPrintPvt:Line(nLinAux0,nPos6+50,nLinAux0,nPos8)
	// oPrintPvt:SayAlign(nLinAux0,  nPos6+53, /*001*/  'Valor Unitário da NF:', oFont10N, 100, 05, , PAD_LEFT, )
	// oPrintPvt:SayAlign(nLinAux0,  nPos7+60, /*001*/  '-4.622', oFont10N, 30, 05, , PAD_LEFT, )
	// nLinAux0 += 14
	// oPrintPvt:Line(nLinAux0,nPos6+50,nLinAux0,nPos8)
	// oPrintPvt:SayAlign(nLinAux0,  nPos6+53, /*001*/  'Valor Total:', oFont10N, 100, 05, , PAD_LEFT, )
	// oPrintPvt:SayAlign(nLinAux0,  nPos7+60, /*001*/  '2,2650', oFont10N, 30, 05, , PAD_LEFT, )
	// nLinAux0 += 14
	// oPrintPvt:SayAlign(nLinAux0,  nPos6+53, /*001*/  'Val. a Cobrar ou Desc:', oFont10N, 100, 05, , PAD_LEFT, )
	// oPrintPvt:SayAlign(nLinAux0,  nPos7+60, /*001*/  '2,3320', oFont10N, 30, 05, , PAD_LEFT, )
	// oPrintPvt:Line(nLinAux0,nPos6+50,nLinAux0,nPos8)
	// nLinAux0 += 14

	nLinAux0 += 70

	oPrintPvt:Line(nLinAux0,nPos0,nLinAux0,nPos2)
	oPrintPvt:SayAlign(nLinAux0,  nPos0, 	/*001*/	 'Comandante da Embarcação', oFont10N, 200, 05, , PAD_CENTER, )
	oPrintPvt:Line(nLinAux0,nPos2+50,nLinAux0,nPos4+50)
	oPrintPvt:SayAlign(nLinAux0,  nPos2+50, 	/*001*/	 'Comandante da Embarcação', oFont10N, 200, 05, , PAD_CENTER, )
	nLinAux0 += 14
	oPrintPvt:Line(nLinAux0,nPos5,nLinAux0,nPos8)
	oPrintPvt:SayAlign(nLinAux0,  nPos5, 	/*001*/	 'Representante do Terminal no Carregamento', oFont10N, 300, 05, , PAD_CENTER, )
	nLinAux0 += 14
	nLinAux0 += 20
	oPrintPvt:Line(nLinAux0,nPos0,nLinAux0,nPos2)
	oPrintPvt:SayAlign(nLinAux0,  nPos0, 	/*001*/	 'Inspetor de Medição', oFont10N, 200, 05, , PAD_CENTER, )
	oPrintPvt:Line(nLinAux0,nPos2+50,nLinAux0,nPos4+50)
	oPrintPvt:SayAlign(nLinAux0,  nPos2+50, 	/*001*/	 'Inspetor de Medição', oFont10N, 200, 05, , PAD_CENTER, )
	nLinAux0 += 14
	oPrintPvt:Line(nLinAux0,nPos5,nLinAux0,nPos8)
	oPrintPvt:SayAlign(nLinAux0,  nPos5, 	/*001*/	 'Representante do Terminal no Descarregamento', oFont10N, 300, 05, , PAD_CENTER, )
	nLinAux0 += 14
	nLinAux0 += 20

	oPrintPvt:Line(nLinAux0,nPos0,nLinAux0,nPos2)
	oPrintPvt:SayAlign(nLinAux0,  nPos0, 		/*001*/	 'Coordenador de Operações', oFont10N, 200, 05, , PAD_CENTER, )
	oPrintPvt:Line(nLinAux0,nPos2+50,nLinAux0,nPos4+50)
	oPrintPvt:SayAlign(nLinAux0,  nPos2+50, 	/*001*/	 'Coordenador de Operações', oFont10N, 200, 05, , PAD_CENTER, )
	nLinAux0 += 14

return


