#INCLUDE "FINA330.CH"
#INCLUDE "PROTHEUS.CH"

Static __PesqList
Static aRLocks
Static l330Auto := .F.
Static lFWCodFil := FindFunction("FWCodFil")

// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Fina330	³ Autor ³ Mauricio Pequim Jr.   ³ Data ³ 22/09/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Compensação entre títulos e adiantamentos 			  	  ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fina330()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function Fina33Z(nPosArotina,lExecAuto)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis 		  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Local nSavRec	:= Recno()
Local cBrwExp	:= NIL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                  
//³ Vetor com Condicoes para a legenda da mBrowse ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := U_MenuDefZ()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                PARAMETROS  	                    ³
//³                              	                 ³
//³ MV_PAR01 : Considera Loja  Sim/Nao          	  ³
//³ MV_PAR02 : Considera Cliente     Original/Outros ³
//³ MV_PAR03 : Do Cliente                            ³
//³ MV_PAR04 : Ate Cliente                           ³
//³ MV_PAR05 : Compensa Titulos Transferidos S/[N]   ³
//³ MV_PAR06 : Calcula Comissao sobre valores de NCC ³
//³ MV_PAR07 : Mostra Lancto Contabil                ³
//³ MV_PAR08 : Considera abatimentos para compensar  ³
//³ MV_PAR09 : Contabiliza On-Line                   ³
//³ MV_PAR10 : Considera Filiais abaixo              ³
//³ MV_PAR11 : Filial De                             ³
//³ MV_PAR12 : Filial Ate                            ³
//³ MV_PAR13 : Calcula Comissao sobre valores de RA  ³
//³ MV_PAR14 : Reutiliza taxas informadas            ³
//³ Atencao: ao criar mais parametros nesta rotina   ³
//³ observe na funcao fa330comp() logo abaixo que    ³
//³ e necessario setar os defaults caso a chamada    ³
//³ venha de outro programa. (ex.: cOrigem=MATA465)) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabe‡alho da tela de baixas				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := STR0005  //"Compensa‡„o de Titulos a Receber"
PRIVATE cLote			// Utilizado para Contabilizacao
PRIVATE VALOR 	:= 0 	// Utilizada para Contabilizacao
Private lOracle	:= "ORACLE"$Upper(TCGetDB())

PRIVATE nTamTit := TamSX3("E1_PREFIXO")[1]+TamSX3("E1_NUM")[1]+TamSX3("E1_PARCELA")[1]
PRIVATE nTamTip := TamSX3("E1_TIPO")[1]
PRIVATE nTamLoj := TamSX3("E1_LOJA")[1]
Private aTxMoedas	:=	{}
Private cCodDiario	:= ""
Default nPosArotina := 0
Default lExecAuto	:= .F.


l330Auto := lExecAuto

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o numero do Lote 							³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LoteCont( "FIN" )
SetKey (VK_F12,{|a,b| AcessaPerg("FIN330",.T.)})

If ExistBlock("FA330FLT")
	ExecBlock("FA330FLT",.F.,.F.)		
Endif	

Pergunte("FIN330",.F.)

//Garanto a criacao / abertura do SFQ fora da transacao
//Necessária para a verificacao posterior dos campos de impostos da Lei 10925
If FindFunction("ALIASINDIC")
	If AliasIndic("SFQ") 
		dbSelectArea('SFQ')
	Endif
Endif	

If nPosArotina > 0
	dbSelectArea('SE1')
	bBlock := &( "{ |a,b,c,d,e| " + aRotina[ nPosArotina,2 ] + "(a,b,c,d,e) }" )
	Eval( bBlock, Alias(), (Alias())->(Recno()),nPosArotina)
Else
	dbSelectArea("SE1")
	dbSetOrder(1)
	dbSeek(xFilial())

	// Ponto de entrada para incluir botoes na rotina
	If ExistBlock( "FA330MNU" )
		aRotina := ExecBlock( "FA330MNU", .F., .F., { aRotina } )
	EndIf

	// Ponto de entrada para retornar uma expressao SQL para filtro 
	// no mBrowse sem que a opcao de filtro do usuario seja desabilitado.
	cBrwExp	:= NIL
	If ExistBlock( "FA330FBRW" )
		cBrwExp := ExecBlock( "FA330FBRW", .F., .F. )
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endere‡a a Fun‡„o de BROWSE				³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mBrowse( 6, 1,22,75,"SE1",,,,,,Fa330Leg(),,,,,,,, cBrwExp /* 19-SQL Filter */ )
Endif	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey (VK_F12)
dbSelectArea("SE1")
DbClearFilter()
dbSetOrder(1)
dbGoTo( nSavRec )   

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Fa330Comp³ Autor ³ Mauricio Pequim Jr.   ³ Data ³ 18/04/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marca‡„o dos titulos para compensa‡„o					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa330Comp() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function fA330Comp(cAlias,cCampo,nOpcE,oDlgPae,cLoteFat,cOrigem,aNumLay)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis 				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Local nTotal		:= 0
Local nHdlPrv		:= 0
Local nValorComp	:= 0
Local nSeq			:= 0
Local nValBX		:= 0			// Valor da baixa na moeda 1
Local nValBX2		:= 0			// Valor da baixa na moeda do tit principal
Local nX
Local cAdiantamento
Local cDadosTitulo
Local cArquivo
Local cPadrao	:= "596"
Local lContabil	:= .F.
Local lPadrao
Local lDigita
Local dEmissao	:= SE1->E1_EMISSAO
Local lMarcado	:= .F.
Local aBaixas	:= {}
Local nTotAbat	:= 0
Local nTotAbtIni	:= 0		//Abatimento do titulo de Partida
Local nTitIni	:= SE1->(Recno())
Local nDecs		:= 2
Local nSalTit	:= 0
Local nDecs1	:= MsDecimais(1)
Local oOk		:= LoadBitmap( GetResources(), "LBOK" )
Local oNo		:= LoadBitmap( GetResources(), "LBNO" )
Local cVarQ		:= "  "
Local oTitulo
Local oDlg
Local lFa330Cmp	:= ExistBlock( "FA330CMP" )
Local nSldReal	:= 0
Local oGet01
Local nLinha	:= 0
Local nTit		:= 0 
Local nA		:= 0
Local cKeyAbt	:= ""
Local nSe1Rec	:= 0
Local nAcresc	:= 0
Local nDecres	:= 0
Local nIndexAtu	:= SE1->(IndexOrd())
Local nVlrCompe // Criadaa para exibir o conteudo do Help correto quando o usuario
					 // pressionar F1 sobre o campo
Local aSize		:= {}
Local lDeleted	:= .F.
Local lfa330Bx	:= Existblock("FA330BX")
Local oPanel
Local aArea		:={}
Local lACAtivo	:= GetNewPar("MV_ACATIVO", .F.) //Verifica se o cliente utiliza o modulo Educacional
Local lVldDtFin	:= .T.
Local aDiario	:= {}

//Controla o Pis Cofins e Csll na baixa  (1-Retem PCC na Baixa ou 2-Retem PCC na Emissão(default) )
Local lPccBxCr	:= If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)
Local nLoop		:= 0
LOCAL nSalvRec	:= SE1->(Recno())
Local lAplVlMin := .T.
Local nVlMinImp := GetNewPar("MV_VL10925",5000)
Local nTotCsAbt	:= 0	
Local nTotPisAbt	:= 0 
Local	nTotCofAbt	:= 0
Local aImpPcc		:= {0,0,0}
Local nTotAdto		:= 0
Local lBaixaAbat	:= .F.
Local nVlrBaixa	:= 0
Local lBxCec		:= .F.
Local lBxLiq		:= .F.
Local nParciais	:= 0
Local nTamSeq		:= TamSX3("E5_SEQ")[1]
Local cSequencia	:= Replicate("0",nTamSeq)
Local nPosPis		:= 14		//Posicao Pis na Tela
Local nPosCof		:= 15		//Posicao Cofins na Tela
Local nPosCsl		:= 16		//Posicao Csll na Tela
Local nRecnoRA		:= 0
Local lF330BOTON 	:= ExistBlock("F330BOTON")

Local cTipoOr	:= SE1->E1_TIPO
Local lOkTitAb	:= .F.
Local lCompRa	:=	.F.

Default cOrigem :=""
DEFAULT aNumLay := {}

PRIVATE aTitulos:={}
PRIVATE aRecNo := {}
PRIVATE aRegSE1 := {}
PRIVATE aBaixaSE5 := {}
PRIVATE	cPrefixo := SE1->E1_PREFIXO
PRIVATE	cNum		:= SE1->E1_NUM
PRIVATE	cTipoTit := SE1->E1_TIPO
PRIVATE	cCliente := SE1->E1_CLIENTE
PRIVATE	cLoja 	:= SE1->E1_LOJA
PRIVATE	cSaldo	:= CriaVar("E1_SALDO")
PRIVATE	nValor	:= CriaVar("E1_SALDO")
PRIVATE	cParcela := SE1->E1_PARCELA
PRIVATE	nMoeda	:= SE1->E1_MOEDA
PRIVATE	dBaixa	:= dDataBase
PRIVATE	nValTot	:= 0
PRIVATE	nSeqBx 	:= 0
PRIVATE	nPosSaldo:=0
PRIVATE	nPosValor:=0
PRIVATE	cBanco	:= Criavar("E1_PORTADO")
Private lCredito := .F.
Private nPosATit := 0
Private aFlagCTB := {}
Private lUsaFlag := SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)

//PCC Baixa CR
PRIVATE nPis 		:= 0
PRIVATE nCofins   := 0
PRIVATE nCsll		:= 0
PRIVATE aDadosRef :=  {0,0,0,0,0,0,0} //Array(7)
PRIVATE aDadosRet :=  {0,0,0,0,0,0,0} //Array(7)
PRIVATE nVlRetPis	:= 0
PRIVATE nVlRetCof	:= 0
PRIVATE nVlRetCsl	:= 0
PRIVATE nDiferImp	:= 0
PRIVATE nValRec	:= 0
PRIVATE nOldValRec:= 0
PRIVATE lRetParc  := .T.                                                                                  

If cOrigem == "LOJA800"
   nValor   :=  nVlrComp  
EndIf

nVlrCompe	:= nValor

If SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .or. cOrigem =="MATA465"
	lCredito := .T.
Endif

If !FA330Lock(,SE1->(Recno()))
	Return
Endif	

aArea:=GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se vier do mata465 ou da LOCXNF, forca os valores dos parametros ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cOrigem == "MATA465"
	MV_PAR07 := mv_par03		// Mostra Lancto Contabil
	MV_PAR09 := mv_par05		// Contabiliza On-Line                
	MV_PAR01 := 1 				// Considera Loja  Sim/Nao          	
	MV_PAR02 := 1 				// Considera Cliente Original/Outros
	MV_PAR03 :=	SE1->E1_CLIENTE // Do Cliente
	MV_PAR04 :=	SE1->E1_CLIENTE // Ate Cliente
	MV_PAR05 := 2				// Compensa Titulos Transferidos S/[N] 
	MV_PAR06 := 2				// Calcula Comissao sobre valores de NCC
	MV_PAR08 := 2				//Considera abatimentos para compensar 
	MV_PAR10 := 2				//Considera Filiais abaixo             
	MV_PAR11 := "  " 			//Filial De                            
	MV_PAR12 := "zz"			//Filial Ate                         
	MV_PAR13 := 1				// Calcula Comissao sobre valores de RA
	MV_PAR14 := 2				// Reutiliza taxas informadas
    // obs.: nao eh necessario voltar aos valores originais no final, pois a 
    // propria MATA465 recompoe os valores dos mv_parxx depois da chamada fa330comp()
ElseIf cOrigem == "COMPENSANCC"
	Pergunte("FIN330",.F.)	
	MV_PAR03 := SE1->E1_CLIENTE  		// Do Cliente
	MV_PAR04 := SE1->E1_CLIENTE 		// Ate Cliente

	dbSelectArea("SE1")
Endif

If Type("MV_PAR02")<>'N'
	MV_PAR02 := 1 				// Considera Cliente Original/Outros
EndIf

//Caso considere diferentes clientes
If MV_PAR02 == 2
	nPosPis := 17
	nPosCof := 18
	nPosCsl := 19
Endif

RestArea(aArea)


If ExistBlock("F330DTFIN")
	lVldDtFin := ExecBlock("F330DTFIN",.F.,.F.)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se data do movimento n„o ‚ menor que data limite de ³
//³ movimentacao no financeiro    										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lVldDtFin .and. !DtMovFin()
	Return
Endif	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ N„o permite que t¡tulos j  baixados possam ser acessados. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SE1->E1_SALDO <= 0
	Help(" ",1,"FA330JABAI")
	Return (.T.)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso titulos originados pelo SIGALOJA estejam nas carteiras :  ³
//³I = Carteira Caixa Loja                                        ³
//³J = Carteira Caixa Geral                                       ³
//³Nao permitir esta operacao, pois ele precisa ser transferido   ³
//³antes pelas rotinas do SIGALOJA.                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Upper(AllTrim(SE1->E1_SITUACA)) $ "I|J" .AND. Upper(AllTrim(SE1->E1_ORIGEM)) == "LOJA010"
	Help(" ",1,"NOUSACLJ")
	Return
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulos provisorios nao sao compensaveis como titulo principal.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipoTit $ MVPROVIS
	Help(" ",1,"NOCMPPROV",,STR0042+chr(13)+STR0043,1,0 )   //"Nao é permitida a compensacao a partir de"###"um titulo provisorio"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recupera a Integridade dos dados     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE1")
	dbSetOrder(nIndexAtu)
	DeleteObject(oOk)
	DeleteObject(oNo)
	FA330aUnlock()
	Return (.T.)
Endif

//ANGOLA|BRASIL - Nao permitir compensar titulos de adiantamento relacionados a pedido
#IFDEF TOP
	If cPaisLoc $ "ANG|BRA" .and. AliasInDic("FIE")
		If FinAdtSld( "R", SE1->( E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO ) )
			Help(" ",1,"ADTXPED",,"Adiantamento relacionado a um pedido somente poderá ser utilizado no relacionamento com pedidos",1,0)		//"Adiantamento relacionado a um pedido somente poderá ser utilizado no relacionamento com pedidos"
			Return (.T.)
		Endif
	Endif
#ENDIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura aTxMoedas         ³
//³ [1] -> Nome Moeda          	³
//³ [2] -> Taxa a Ser Utilizada	³
//³ [3] -> Picture          	³
//³ [4] -> Taxa do dia atual    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If Type("aTxMoedas") <> "A"  .Or. MV_PAR14 == 2 
	aTxMoedas:={}              
EndIf 

If Len(aTxMoedas) == 0
	Aadd(aTxMoedas,{"",1,PesqPict("SM2","M2_MOEDA1"),1})

	For nA := 2	To MoedFin()
		cMoedaTx :=	Str(nA,IIf(nA <= 9,1,2))
		If !Empty(GetMv("MV_MOEDA"+cMoedaTx))
			nVlMoeda := RecMoeda(dDataBase,nA)
			Aadd(aTxMoedas,{GetMv("MV_MOEDA"+cMoedaTx),nVlMoeda,PesqPict("SM2","M2_MOEDA"+cMoedaTx),nVlMoeda })
		Else
			Exit
		Endif
	Next
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a gravacao dos lancamentos do SIGAPCO          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PcoIniLan("000016")

While .T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Titulo a ser compensado			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOpca  :=0
	
	If mv_par08 == 1
		nTotAbtIni := SumAbatRec(cPrefixo,cNum,cParcela,SE1->E1_MOEDA,"S",dBaixa,,,@nTotCsAbt,@nTotPisAbt,@nTotCofAbt)
		nSaldo := (SE1->E1_SALDO - nTotAbtIni + SE1->E1_SDACRES - SE1->E1_SDDECRE)
	ELSE
		nSaldo := SE1->E1_SALDO + SE1->E1_SDACRES - SE1->E1_SDDECRE
	Endif	
	nRecno := SE1->(Recno())
		   
	cDadostitulo := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO

	////////////////////
	//PCC Baixa CR

	//Se PCC Baixa CR e nao houver abatimento de impostos
	If cPaisLoc == "BRA" .and. lPccBxCr .and. (nTotCsAbt+nTotPisAbt+nTotCofAbt == 0) 
		If (SE1->E1_VALOR > SE1->E1_SALDO) .And. Empty(SE1->E1_TIPOLIQ)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Procura pelas baixas deste titulo ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aBaixa := Sel070Baixa( "VL /V2 /BA /RA /CP /LJ /" + MV_CRNEG, SE1->E1_PREFIXO,SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO,;
				@nTotAdto, @lBaixaAbat, SE1->E1_CLIENTE, SE1->E1_LOJA, @nVlrBaixa, , @lBxCec, @lBxLiq )
			For nX := 1 To Len(aBaixaSE5)
				nParciais += aBaixaSE5[nX][8]
			Next
			nParciais += nTotAdto
		Else
			nParciais 	:= SE1->E1_VALOR-SE1->E1_SALDO
		Endif
		
		If "RA" $ SE1->E1_TIPO
			nParciais 	:= SE1->E1_VALOR-SE1->E1_SALDO
		Endif	

		nValRec := SE1->E1_VALOR - nParciais
		f070TotMes(dBaixa,.T.)	
		//Caso o titulo de partida possua PCC, diminuo do saldo a compensar	
		If nPis+nCofins+nCsll > 0  .And.  SE1->E1_TIPO <> MV_CRNEG 
			aImpPcc [1] := nPis		
			aImpPcc [2] := nCofins
			aImpPcc [3] := nCsll			
			nSaldo -= (nPis+nCofins+nCsll)
		Endif		
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se for chamada da mata465 , nao mostrar a janela de parametros   ³
	//³ e forçar o valor de nOpca con valor 1. (Loc. Arg.).              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cOrigem!="MATA465"
		If lPanelFin  //Chamado pelo Painel Financeiro				
			oPanelDados := FinWindow:GetVisPanel()
			oPanelDados:FreeChildren()
			aDim := DLGinPANEL(oPanelDados)
			DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )							
			oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Observacao Importante quanto as coordenadas calculadas abaixo: ³ 
			//³ -------------------------------------------------------------- ³ 		
			//³ a funcao DlgWidthPanel() retorna o dobro do valor da area do	 ³
			//³ painel, sendo assim este deve ser dividido por 2 antes da sub- ³
			//³ tracao e redivisao por 2 para a centralizacao. 					 ³		
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			nEspLarg := ((DlgWidthPanel(oPanelDados)/2) - 225) /2		 					
			nEspLin  := 0				
	
	   Else   
	   	nEspLarg := 0 
	   	nEspLin  := 0
	   	DEFINE MSDIALOG oDlg FROM	88,	31 TO 275,525 TITLE STR0036 PIXEL  //"Compensa‡„o de Adiantamentos"
	   Endif	 
	   
	   oDlg:lMaximized := .F.
		oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
		oPanel:Align := CONTROL_ALIGN_ALLCLIENT    			   
	   
	   @ 000+nEspLin, 002+nEspLarg TO 030+nEspLin, 245+nEspLarg OF oPanel	PIXEL
		@ 031+nEspLin, 002+nEspLarg TO 062+nEspLin, 245+nEspLarg OF oPanel	PIXEL		  	 		
		
		@ 015+nEspLin, 006+nEspLarg MSGET cPrefixo							SIZE 19, 10 OF oPanel PIXEL
		@ 015+nEspLin, 032+nEspLarg MSGET cNum VALID !EMPTY(cNum)		SIZE 70, 10 OF oPanel PIXEL
		@ 015+nEspLin, 105+nEspLarg MSGET cParcela							SIZE 20, 10 OF oPanel PIXEL
		
		If !lCredito
			@ 015+nEspLin, 129+nEspLarg MSGET cTipoTit PICTURE "@!" VALID !Empty(cTipoTit) .AND.;
				!cTipoTit $ MVABATIM .AND. ;
				!(cTipoTit $ MVRECANT+"/"+MV_CRNEG) SIZE 12, 10 OF oPanel PIXEL
		Else
			@ 015+nEspLin, 129+nEspLarg MSGET cTipoTit PICTURE "@!" VALID !Empty(cTipoTit) .AND.;
				!cTipoTit $ MVABATIM .AND. ;
				(cTipoTit $ MVRECANT+"/"+MV_CRNEG) SIZE 12, 10 OF oPanel PIXEL		
		Endif											
		@ 015+nEspLin, 155+nEspLarg MSGET cCliente F3 "SA1" Valid fa330Cli()	SIZE 70, 10 OF oPanel PIXEL HASBUTTON
		@ 015+nEspLin, 226+nEspLarg MSGET cLoja	 Valid Fa330Loja() SIZE 16, 10 OF oPanel PIXEL

		@ 047+nEspLin, 006+nEspLarg MSGET nSaldo When .F. 	Picture "@E 9999,999,999.99" SIZE 50, 10 OF oPanel PIXEL 
		@ 047+nEspLin, 060+nEspLarg MSGET nMoeda when .F.					SIZE 18, 10 OF oPanel PIXEL 
		@ 047+nEspLin, 085+nEspLarg MSGET nVlrCompe			Picture "@E 9999,999,999.99";
			Valid nVlrCompe >= 0 .AND. STR(nVlrCompe,17,2) <= STR(nSaldo,17,2) ;
			SIZE 52, 10 OF oPanel PIXEL HASBUTTON
		@ 047+nEspLin, 142+nEspLarg MSGET dBaixa	   Valid dBaixa >= SE1->E1_EMISSAO;
			SIZE 41, 10 OF oPanel PIXEL HASBUTTON
		
		@ 007+nEspLin, 006+nEspLarg SAY STR0006  SIZE 21, 7 OF oPanel PIXEL  //"Prefixo"
		@ 007+nEspLin, 032+nEspLarg SAY STR0007  SIZE 22, 7 OF oPanel PIXEL  //"N£mero"
		@ 006+nEspLin, 105+nEspLarg SAY STR0008  SIZE 23, 7 OF oPanel PIXEL  //"Parcela"
		@ 006+nEspLin, 129+nEspLarg SAY STR0009  SIZE 14, 7 OF oPanel PIXEL  //"Tipo"
		@ 006+nEspLin, 155+nEspLarg SAY STR0010  SIZE 34, 7 OF oPanel PIXEL  //"Cliente   "
		@ 006+nEspLin, 226+nEspLarg SAY STR0011  SIZE 14, 7 OF oPanel PIXEL  //"Loja"
		@ 038+nEspLin, 006+nEspLarg SAY STR0012  SIZE 34, 7 OF oPanel PIXEL  //"Saldo"
		@ 038+nEspLin, 060+nEspLarg SAY STR0013  SIZE 21, 7 OF oPanel PIXEL  //"Moeda"
		@ 038+nEspLin, 085+nEspLarg SAY STR0014  SIZE 55, 7 OF oPanel PIXEL  //"Valor a compensar"
		@ 038+nEspLin, 142+nEspLarg SAY STR0015  SIZE 45, 7 OF oPanel PIXEL  //"Data da Baixa"

		If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )                                                        
			SX3->(DbSetorder(2))
			SX3->(DbSeek("E5_DIACTB"))
			cCodDiario  := Criavar("E5_DIACTB",.T.)          
			cTitDiar :=  AllTrim(X3TITULO())
			@ 038+nEspLin, 192+nEspLarg SAY cTitDiar SIZE 45, 7 OF oPanel PIXEL 
			@ 047+nEspLin, 192+nEspLarg MSGET cCodDiario F3 "CVL" SIZE 20, 10 OF oPanel Valid VldCodSeq( cCodDiario ) When CtbWdia() PIXEL HASBUTTON
			SX3->(DbSetorder(1))
		Endif
		
		If lPanelFin  //Chamado pelo Painel Financeiro			
			aButtonTxt := {}
			AADD(aButtonTxt,{STR0037,STR0037, {||Fa330SetMo()}})
			
			ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
			{|| If(Fa330TudOk(),(nOpca:=1,oDLg:End()),)},;
			{|| oDlg:End()},,aButtonTxt)
						
	   Else	
			@ 068+nEspLin, 005+nEspLarg BUTTON STR0037 SIZE 50,18 ACTION (Fa330SetMo()) OF oPanel PIXEL //Taxas Moedas			

			DEFINE SBUTTON FROM 68, 190 TYPE 1 ENABLE ACTION (If(Fa330TudOk(),(nOpca:=1,oDLg:End()),)) OF oPanel
			DEFINE SBUTTON FROM 68, 218 TYPE 2 ENABLE ACTION oDlg:End() OF oPanel
		
			ACTIVATE MSDIALOG oDlg CENTERED
		Endif	
	Else
		nOpca	:=	1
	Endif
	IF nOpca == 0
		dbSelectArea(cAlias)
		dbSetOrder(nIndexAtu)
		deleteObject(oOk)
		deleteObject(oNo)
		FA330aUnlock()
		Return
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Os valores exibidos em tela o serao na Moeda 1   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nValor := nVlrCompe
	Processa({ || Fa330Tit(dEmissao,cOrigem,lCredito,aNumLay)})  // Monta a Matriz com as compensacoes validas
	If Len(aTitulos) == 0
		Help(" ",1,"NOTITSEL")
		DeleteObject(oOk)
		DeleteObject(oNo)
		FA330aUnlock()
		Exit
	Endif


	nQtdTit := 0	 // quantidade de titulos,mostrado no rodape do browse
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Titulos a compensar         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOpca := 0	
	If cOrigem $ "MATA465#COMPENSANCC"
		cLote	:=	cLoteFat
	Endif
	aSize := MsAdvSize(,.F.,400)
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	oDLg:lMaximized := .T.
	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_TOP

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montando cabecalho do list box³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisLoc == "BRA"	
		If mv_par02 == 2
			@ 1.0,1.0 LISTBOX oTitulo	VAR cVarQ Fields;
				HEADER "",STR0006,;  //"Prefixo"
				STR0007,;  //"N£mero"
				STR0008,;  //"Parcela"
				STR0009,;  //"Tipo"
				STR0011,;  //"Loja"
				STR0016,;  //"Saldo do t¡tulo"
				STR0017,;   //"Valor compensado"
				STR0049,; //"Acréscimos"
				STR0050,; //"Decréscimos"
				STR0046,;  //"Cliente/Loja"
				STR0041,;  //"Nome do Cliente"
				Rtrim(RetTitle("A1_CGC")),; //"CGC do Cliente"
				Rtrim(RetTitle("E1_HIST")),; //Historico
				RetTitle("E1_FILIAL"),; //FILIAL
				RetTitle("E1_PIS"),;
				RetTitle("E1_COFINS"),;
				RetTitle("E1_CSLL");
				COLSIZES 12,GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBBBBBB"),;
				GetTextWidth(0,"BBBB"),GetTextWidth(0,"BBB"),GetTextWidth(0,"BBB"),;
				GetTextWidth(0,"BBBBBBBBB"),GetTextWidth(0,"BBBBBBBBB"),;
				GetTextWidth(0,"BBBBBBBBB"),GetTextWidth(0,"BBBBBBBBB"),;
				GetTextWidth(0,"BBBBBBBBB"),GetTextWidth(0,"BBBBBBBBB"),;
				GetTextWidth(0,"BBBBBBBBB"),GetTextWidth(0,"BBBBBBBBBBBBBBBBBBBB"),GetTextWidth(0,REPLICATE("B",IIf( lFWCodFil, FWGETTAMFILIAL, 2 ))),;
  				GetTextWidth(0,"BBBBBB"),GetTextWidth(0,"BBBBBB"),GetTextWidth(0,"BBBBBB");
				SIZE 293,54.5 ON DBLCLICK (aTitulos:=FA330Troca(oTitulo:nAt,aTitulos,oGet01),oTitulo:Refresh()) NOSCROLL
		
				oTitulo:SetArray(aTitulos)
				oTitulo:bLine := { || {If(aTitulos[oTitulo:nAt,8],oOk,oNo),;
					aTitulos[oTitulo:nAt,1],aTitulos[oTitulo:nAt,2],;
					aTitulos[oTitulo:nAt,3],aTitulos[oTitulo:nAt,4],;
					aTitulos[oTitulo:nAt,5],aTitulos[oTitulo:nAt,6],;
					aTitulos[oTitulo:nAt,7],aTitulos[oTitulo:nAt,13],;
					aTitulos[oTitulo:nAt,14],aTitulos[oTitulo:nAt,10],;
					aTitulos[oTitulo:nAt,11],aTitulos[oTitulo:nAt,12],;
					aTitulos[oTitulo:nAt,15],aTitulos[oTitulo:nAt,16],;
					aTitulos[oTitulo:nAt,17],aTitulos[oTitulo:nAt,18],;
					aTitulos[oTitulo:nAt,19]}}

		Else
			@ 1.0,1.0 LISTBOX oTitulo	VAR cVarQ Fields;
				HEADER "",STR0006,;  //"Prefixo"
				STR0007,;  //"N£mero"
				STR0008,;  //"Parcela"
				STR0009,;  //"Tipo"
				STR0011,;  //"Loja"
				STR0016,;  //"Saldo do t¡tulo"
				STR0017,;   //"Valor compensado"
				STR0049,; //"Acréscimos"
				STR0050,; //"Decréscimos"
				Rtrim(RetTitle("E1_HIST")),; //Historico
				RetTitle("E1_FILIAL"),; //FILIAL
				RetTitle("E1_PIS"),;
				RetTitle("E1_COFINS"),;
				RetTitle("E1_CSLL");
				COLSIZES 12,GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBBBBBB"),;
				GetTextWidth(0,"BBBB"),GetTextWidth(0,"BBB"),GetTextWidth(0,"BBB"),;
				GetTextWidth(0,"BBBBBBBBB"),GetTextWidth(0,"BBBBBBBBB"),;
				GetTextWidth(0,"BBBBBBBBB"),GetTextWidth(0,"BBBBBBBBB"),;
			   GetTextWidth(0,"BBBBBBBBBBBBBBBBBBBB"),GetTextWidth(0,REPLICATE("B",IIf( lFWCodFil, FWGETTAMFILIAL, 2 ))),;				
  				GetTextWidth(0,"BBBBBB"),GetTextWidth(0,"BBBBBB"),GetTextWidth(0,"BBBBBB"),;
				SIZE 293,54.5 ON DBLCLICK (aTitulos:=FA330Troca(oTitulo:nAt,aTitulos,oGet01),oTitulo:Refresh()) NOSCROLL
		
				oTitulo:SetArray(aTitulos)
				oTitulo:bLine := { || {If(aTitulos[oTitulo:nAt,8],oOk,oNo),;
					aTitulos[oTitulo:nAt,1],aTitulos[oTitulo:nAt,2],;
					aTitulos[oTitulo:nAt,3],aTitulos[oTitulo:nAt,4],;
					aTitulos[oTitulo:nAt,5],aTitulos[oTitulo:nAt,6],;
					aTitulos[oTitulo:nAt,7],aTitulos[oTitulo:nAt,10],;
					aTitulos[oTitulo:nAt,11],aTitulos[oTitulo:nAt,12],;
					aTitulos[oTitulo:nAt,13],aTitulos[oTitulo:nAt,14],;
					aTitulos[oTitulo:nAt,15],aTitulos[oTitulo:nAt,16]}}
									
		Endif
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se na listagem de titulos nao considerar o cliente original do titulo selecionado, mostra o cgc |
		//|e o nome dos clientes referentes a cada titulo (MV_PAR02==2)                                    |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If MV_PAR02 == 2
			//Adiciona Nome e CGC do cliente ao cabecalho
			@ 1.0,1.0 LISTBOX oTitulo	VAR cVarQ Fields;
				HEADER "",STR0006,;  //"Prefixo"
				STR0007,;  //"N£mero"
				STR0008,;  //"Parcela"
				STR0009,;  //"Tipo"
				STR0011,;  //"Loja"
				STR0016,;  //"Saldo do t¡tulo"
				STR0017,;   //"Valor compensado"
				STR0048,; //"Acréscimos"
				STR0049,; //"Decréscimos"
				STR0038,;   //"Moeda"								
				STR0039,;   //"Emissao"								
				STR0041,;  //"Nome do Cliente"
				Rtrim(RetTitle("A1_CGC")),; //"CGC do Cliente"
				Rtrim(RetTitle("E1_HIST")),; //Historico
				RetTitle("E1_FILIAL"); //FILIAL
				COLSIZES 12,GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBBBBBB"),;
				GetTextWidth(0,"BBBB"),GetTextWidth(0,"BBB"),;
				GetTextWidth(0,"BBB"), GetTextWidth(0,"BBBBBBBBB"),;
				GetTextWidth(0,"BBBBBBBBB"),GetTextWidth(0,"BBBBB"),;
				GetTextWidth(0,"BBBBBBBB"),GetTextWidth(0,"BBBBBBBBB"),GetTextWidth(0,"BBBBBBBBB"),;
				GetTextWidth(0,"BBBBBBBBBBBBBBBBBBBB"),GetTextWidth(0,"BBBBBBBBBBBBBB"), GetTextWidth(0,"BBBBBBBBBBBBBBBBBBBB"),GetTextWidth(0,REPLICATE("B",IIf( lFWCodFil, FWGETTAMFILIAL, 2 )));
				SIZE 293,54.5 ON DBLCLICK (aTitulos:=FA330Troca(oTitulo:nAt,aTitulos,oGet01),oTitulo:Refresh()) NOSCROLL
			oTitulo:SetArray(aTitulos)
			oTitulo:bLine := { || {If(aTitulos[oTitulo:nAt,8],oOk,oNo),;
				aTitulos[oTitulo:nAt,1],aTitulos[oTitulo:nAt,2],;
				aTitulos[oTitulo:nAt,3],aTitulos[oTitulo:nAt,4],;
				aTitulos[oTitulo:nAt,5],aTitulos[oTitulo:nAt,6],;
				aTitulos[oTitulo:nAt,7],aTitulos[oTitulo:nAt,13],;
				aTitulos[oTitulo:nAt,14],aTitulos[oTitulo:nAt,9],;
				aTitulos[oTitulo:nAt,10],aTitulos[oTitulo:nAt,11],;
				aTitulos[oTitulo:nAt,12], aTitulos[oTitulo:nAt,15],aTitulos[oTitulo:nAt,16]}}
			//---
		Else
			//Considera o cliente original do titulo seleionado, nao mostra o nome do cliente
			@ 1.0,1.0 LISTBOX oTitulo	VAR cVarQ Fields;
				HEADER "",STR0006,;  //"Prefixo"
				STR0007,;  //"N£mero"
				STR0008,;  //"Parcela"
				STR0009,;  //"Tipo"
				STR0011,;  //"Loja"
				STR0016,;  //"Saldo do t¡tulo"
				STR0017,;   //"Valor compensado"
				STR0048,; //"Acréscimos"
				STR0049,; //"Decréscimos"
				STR0038,;   //"Moeda"								
				STR0039,;   //"Emissao"
				RetTitle("E1_FILIAL"); //FILIAL								 								 				
				COLSIZES 12,GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBBBBBB"),;
				GetTextWidth(0,"BBBB"),GetTextWidth(0,"BBB"),GetTextWidth(0,"BBB"),;
				GetTextWidth(0,"BBBBBBBBB"),GetTextWidth(0,"BBBBBBBBB"),;					
				GetTextWidth(0,"BBBBBBBBB"),GetTextWidth(0,"BBBBBBBBB"),;					
				GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBBBBBBB"),GetTextWidth(0,REPLICATE("B",IIf( lFWCodFil, FWGETTAMFILIAL, 2 )));
				SIZE 293,54.5 ON DBLCLICK (aTitulos:=FA330Troca(oTitulo:nAt,aTitulos,oGet01),oTitulo:Refresh()) NOSCROLL
				oTitulo:SetArray(aTitulos)
				oTitulo:bLine := { || {If(aTitulos[oTitulo:nAt,8],oOk,oNo),;
				aTitulos[oTitulo:nAt,1],aTitulos[oTitulo:nAt,2],;
				aTitulos[oTitulo:nAt,3],aTitulos[oTitulo:nAt,4],;
				aTitulos[oTitulo:nAt,5],aTitulos[oTitulo:nAt,6],;
				aTitulos[oTitulo:nAt,7],aTitulos[oTitulo:nAt,11],;
				aTitulos[oTitulo:nAt,12],aTitulos[oTitulo:nAt,9],;
				aTitulos[oTitulo:nAt,10],aTitulos[oTitulo:nAt,13]}}
			//---
		EndIf
		//----
	EndIf
	If cPaisLoc == "BRA" .and. lCredito .and. lPccBxCr                                           
		oTitulo:bHeaderClick := {|oObj,nCol| If( nCol==1, FA330Troca(oTitulo:nAt,aTitulos,oGet01,.T.),Nil), oTitulo:Refresh(),oGet01:Refresh()}   
	Else
		oTitulo:bHeaderClick := {|oObj,nCol| If( nCol==1, fMarkAll(@aTitulos, @nValTot),Nil), oTitulo:Refresh(),oGet01:Refresh()}
	Endif
	oTitulo:Align := CONTROL_ALIGN_ALLCLIENT
	//---
	
	@  4, 08 SAY STR0045 PIXEL OF oPanel SIZE 70,7
	@  4, 58 MSGET oGet01 VAR nValTot PICTURE "@E 999,999,999.99" WHEN .F. PIXEL OF oPanel SIZE 70,7

	
	If !lPanelFin  //Chamado pelo Painel Financeiro			
   	
		oPanel2 := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,20,20,.T.,.T. )
		oPanel2:Align := CONTROL_ALIGN_BOTTOM   

	   @  4, 08  BUTTON STR0044 SIZE 50,11 ACTION (F330Invert(lPccBxCr,oTitulo,oGet01)) OF oPanel2 PIXEL 
		@  4, 65  BUTTON STR0001 SIZE 50,11 ACTION PesqListBox(@oTitulo,aTitulos) OF oPanel2 PIXEL 
	           
		If lF330BOTON
		   	ExecBlock("F330BOTON",.F.,.F.)
   		EndIf 		
	
		DEFINE SBUTTON FROM 4,325 TYPE 1 ACTION (nValor := nVlrCompe,nOpca := 1,IF(Fa330OK(),oDlg:End(),nOpca:=0)) ENABLE OF oPanel2 PIXEL
		If cOrigem != "LOJA800"
		   DEFINE SBUTTON FROM 4,360 TYPE 2 ACTION oDlg:End() ENABLE OF oPanel2 PIXEL
		EndIf
			
   Else
	  	aButtonTxt := {}	
		AADD(aButtonTxt,{"STR0061",STR0044, {||F330Invert(lPccBxCr,oTitulo,oGet01)}})
		AADD(aButtonTxt,{STR0001,STR0001, {||PesqListBox(@oTitulo,aTitulos)}})       
   Endif
   
	If lPanelFin  //Chamado pelo Painel Financeiro			
	   If cOrigem != "LOJA800"  
		   ACTIVATE MSDIALOG oDlg ON INIT (oTitulo:Refresh(), FaMyBar(oDlg,;
		   	{||nValor := nVlrCompe,nOpca := 1,IF(Fa330OK(),oDlg:End(),nOpca:=0)},;   					
				{||oDlg:End()},,aButtonTxt))     		
		Else	   
		   ACTIVATE MSDIALOG oDlg ON INIT (oTitulo:Refresh(), FaMyBar(oDlg,;
		   	{||nValor := nVlrCompe,nOpca := 1,IF(Fa330OK(),oDlg:End(),nOpca:=0)},;   					
				,,aButtonTxt))     
		Endif			
	Else		
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT (oTitulo:Refresh())
	Endif
	
	
	If nOpcA == 1
		If lFa330Cmp
			ExecBlock("FA330Cmp",.F.,.F.)
		Endif
		nValTot := 0
		For nX:=1 to Len(aTitulos)
			If aTitulos[nX,8]
				nValtot+=Fa330VTit(aTitulos[nX,7])
			Endif
		Next
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o Vlr. Informado e'igual ao calculado.      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Str(nValtot,17,2) != Str(nValor,17,2) .and. nValor != 0;
				.and. nOpca == 1
			Help(" ",1,"FA330COMP")
			Loop
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o Vlr. Informado e'compativel com o Saldo.  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nValor := nValTot
		If Str(nValor,17,2) > Str(nSaldo,17,2)
			Help(" ",1,"FA330IVAL")
			Loop
		EndIf
		DbSelectArea("SE1")
		nOrdSE1	:= IndexOrd()
		dbGotop()
		lPadrao:=VerPadrao(cPadrao)
		VALOR := 0
		ABATIMENTO := 0
		aRegSE1 := {}
		aBaixaSE5 := {}
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicio da prote‡„o via TTS								  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Begin Transaction
		For nTit := 1 to Len(aTitulos)
	  		nPosATit := nTit  // Variavel de posicao do titulo no array
			If aTitulos[nTit,8]
				lMarcado := .T.
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Caso o titulo esteja selecionado para compensa‡„o...    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF lMarcado
				lMarcado := .F.
				IF lPadrao .and. !lContabil .and. mv_par09 == 1
					nTotal := 0
					lContabil := .t.
					nHdlPrv := HeadProva( cLote,;
					                      "FINA330",;
					                      Substr( cUsuario, 7, 6 ),;
					                      @cArquivo )
				Endif
				dbSelectArea("SE1")
				dbGoTo(aRecNo[nTit])
				aAdd(aRegSE1, aRecNo[nTit])
				cAdiantamento := E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_LOJA
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Caso exista PCC e os impostos estejam sendo considerados³
				//³na compensacao, somar o valor do abatimento ao valor da ³
				//³compensacao, para desconsiderar o abatimento PCC        ³
				//³FNC - 00000003895/2008								   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (nTotCsAbt + nTotPisAbt + nTotCofAbt) # 0 .AND. MV_PAR08 == 2
					If (SE1->E1_TIPO == MV_CRNEG) .and. (SE1->E1_SALDO > aTitulos[nTit,9]) .AND. ((aTitulos[nTit,9]+nTotAbtIni) == F330SldPri(nRecNo))
						//Se o abatimento for composto por algo alem do PCC por ex. um AB-
						If Str(nTotAbtIni,17,2) # Str((nTotCsAbt + nTotPisAbt + nTotCofAbt),17,2)
							//Somar apenas o abatimento a ser desconsiderado (PCC) na compensacao
							aTitulos[nTit,9] := aTitulos[nTit,9] + (nTotCsAbt + nTotPisAbt + nTotCofAbt)
						Else  
							//Somar todo o abatimento (formado pelo PCC)
							aTitulos[nTit,9] := aTitulos[nTit,9] + nTotAbtIni
						Endif
					EndIf
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valor da baixa na moeda 1 							  ³	
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If cPaisLoc == "BRA"
					nValBx := aTitulos[nTit,9]
					If mv_par02 == 1
						nAcresc := Fa330VTit(aTitulos[nTit,10])
						nDecres := Fa330VTit(aTitulos[nTit,11])
					Else
						nAcresc := Fa330VTit(aTitulos[nTit,13])
						nDecres := Fa330VTit(aTitulos[nTit,14])
					Endif					
				Else
					nValBx := Fa330VTit(aTitulos[nTit,7])
					If mv_par02 == 1
						nAcresc := Fa330VTit(aTitulos[nTit,11])
						nDecres := Fa330VTit(aTitulos[nTit,12])
					Else
						nAcresc := Fa330VTit(aTitulos[nTit,13])
						nDecres := Fa330VTit(aTitulos[nTit,14])
					Endif					
				Endif
				IF lPadrao
					If cPaisLoc == "BRA"
						nValorComp += Round(NoRound(xMoeda(nValBX,nMoeda,1,,3,Fa330TxMd(nMoeda,0)),3),2)
					Else
						nValorComp += xMoeda(nValBX,nMoeda,1,aTitulos[nTit,10],,aTxMoedas[aTitulos[nTit,9]][2])										
					EndIf	
				EndIf
				//Definindo o conteudo que sera gravado no campo E1_TITPAI do abatimento, caso exista e a baixa seja integral
				If lCredito                                 
					cDadosTitulo := cPrefixo + cNum + cParcela + cTipoOr + cCliente + cLoja
				Else                               
					cDadosTitulo := SE1->(E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO + E1_CLIENTE + E1_LOJA)
				Endif				
				dbSelectArea("SE1")
				dbGoTo(nRecNo)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Guardo dados do titulo principal para utilizar   ³
				//³ no historico da contabiliza‡Æo                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				STRLCTPAD := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valor da Baixa na moeda do titulo principal 	  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If cPaisLoc == "BRA"
					nValBx2 := aTitulos[nTit,9]
					If mv_par02 == 1
						nAcresc := Fa330VTit(aTitulos[nTit,10])
						nDecres := Fa330VTit(aTitulos[nTit,11])
					Else
						nAcresc := Fa330VTit(aTitulos[nTit,13])
						nDecres := Fa330VTit(aTitulos[nTit,14])
					Endif					
					/////////////////
					//PCC Baixa CR
					If lCredito .and. lPccBxCr
						nPis := Fa330VTit(aTitulos[nTit,nPosPis])
						nCofins := Fa330VTit(aTitulos[nTit,nPosCof])
						nCsll := Fa330VTit(aTitulos[nTit,nPosCsl])						
					Endif	
				Else
					nValBx2 := Fa330VTit(aTitulos[nTit,7])
					If mv_par02 == 1
						nAcresc := Fa330VTit(aTitulos[nTit,11])
						nDecres := Fa330VTit(aTitulos[nTit,12])
					Else
						nAcresc := Fa330VTit(aTitulos[nTit,13])
						nDecres := Fa330VTit(aTitulos[nTit,14])
					Endif					
				Endif

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Efetiva gravacao da compensacao SE1/SE5           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Fa330Grv(lPadrao,nValBx2,cAdiantamento,StrZero(nSeq,nTamSeq),aRecno[nTit],@aBaixas,cOrigem,lCredito,mv_par09,nAcresc,nDecres,aBaixaSE5,nTotAbtIni,aImpPcc,@cSequencia,cDadosTitulo)

				For nX:= 1 To len(aBaixas)
					If aBaixas[nX][1][4] $ MVRECANT + "/" + MV_CRNEG
						nRecnoRa:= aBaixas[nX][1][3]
						lCompRa	:= .T.
					EndIf	
					If lUsaFlag 
						aAdd( aFlagCTB, {"E5_LA", "S", "SE5", aBaixas[nX][1][3], 0, 0, 0} )
					EndIf
				Next nX	 

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Integracao Protheus X RM Classis Net (RM Sistemas)³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If GetNewPar("MV_RMCLASS", .F.) .or. GetNewPar("MV_RMBIBLI",.F.)
					If alltrim(upper(SE1->E1_ORIGEM)) == 'L' .or. alltrim(upper(SE1->E1_ORIGEM)) == 'S' .or. SE1->E1_IDLAN > 0
						//Replica a baixa do titulo para o CorporeRM
						ClsProcBx(SE1->(Recno()),'1',"FIN330")
					Endif
				Endif
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona no adiantamento para contabiliza‡„o    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SE1")
				dbGoTo(aRecNo[nTit])
				If lCredito .and. mv_par08 == 1
					nTotAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,,SE1->E1_CLIENTE)				
				Else
					nTotAbat := 0
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Acerta o saldo do adiantamento	 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Reclock("SE1")
				If cPaisLoc == "BRA"
					If nValBx == Fa330VTit(aTitulos[nTit,6])				
						SE1->E1_SALDO := 0
						SE1->E1_SDACRES := 0
						SE1->E1_SDDECRE := 0						
					Else
						//Na Compensacao de RA para NF posso ter impostos gerados e devem ser abatidos no valor do SALDO. 
						If SE1->E1_TIPO = 'NF' .AND. nTotAbat > 0 .AND. lCompRa
						  nTotAbat	+= (nPis + nCofins + nCsll)
						Endif
												
						SE1->E1_SALDO		-= Round(Noround(xMoeda(nValBx-nAcresc+nDecres,nMoeda,SE1->E1_MOEDA,,3,Fa330Tx2(nMoeda,0),Fa330Tx2(SE1->E1_MOEDA,0)),3),2)
						SE1->E1_SDACRES	-= Round(Noround(xMoeda(nAcresc               ,nMoeda,SE1->E1_MOEDA,,3,Fa330Tx2(nMoeda,0),Fa330Tx2(SE1->E1_MOEDA,0)),3),2)
						SE1->E1_SDDECRE	-= Round(Noround(xMoeda(nDecres               ,nMoeda,SE1->E1_MOEDA,,3,Fa330Tx2(nMoeda,0),Fa330Tx2(SE1->E1_MOEDA,0)),3),2)
					Endif
					SE1->E1_VALLIQ := xMoeda(nValBx,SE1->E1_MOEDA,1,,nDecs1+1,Fa330TxMd(SE1->E1_MOEDA,0))
					If STR(SE1->E1_SALDO,17,2) == STR(nTotAbat,17,2)
						SE1->E1_SALDO := 0
					Endif
					SE1->E1_MOVIMEN:= dDatabase					

					/////////////////
					//PCC Baixa CR
					If lCredito .and. lPccBxCr .and. SE1->E1_SALDO > 0
						SE1->E1_SALDO -= (nPis+nCofins+nCsll)
					Endif	

				Else
					If nValBx == Fa330VTit(aTitulos[nTit,6])				
						SE1->E1_SALDO := 0
						SE1->E1_SDACRES := 0
						SE1->E1_SDDECRE := 0						
					Else
						nDecs := MsDecimais(SE1->E1_MOEDA)
						nSalTit := SE1->E1_SALDO - Round(xMoeda(nValBx-nAcresc+nDecres,nMoeda,SE1->E1_MOEDA,dDatabase,nDecs+1,aTxMoedas[nMoeda][2],aTxMoedas[SE1->E1_MOEDA][2]),nDecs)				
						SE1->E1_SALDO   := Iif(nSalTit <= 0,0,nSalTit)
					EndIf
					SE1->E1_MOVIMEN := dDatabase				
					SE1->E1_VALLIQ  += nValBx
				EndIf
				SE1->E1_BAIXA := dBaixa
				SE1->E1_STATUS:= IIF(SE1->E1_STATUS != "R",Iif(SE1->E1_SALDO > 0.01,"A","B"),"R")
				MsUnlock()
				nSE1Rec := SE1->(Recno())
				cKeyAbt := SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)

				// Efetua a baixa dos titulos de abatimento
				If lCredito .AND. SE1->E1_SALDO - nTotAbat <= 0   //Se nao for titulo de adiantamento
					If Select("__SE1") == 0
						SumAbatRec("","","",1,"")
					Endif	
					dbSelectArea("__SE1")
					__SE1->(dbSetOrder(2))
					__SE1->(dbSeek(xFilial("SE1")+cKeyAbt))
					While !EOF() .And. E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA==xFilial("SE1")+cKeyAbt
						IF E1_TIPO $ MVABATIM+"/"+MVIRABT+"/"+MVINABT+"/"+MVPIABT+"/"+;
							MVCFABT+"/"+MVCSABT
							If __SE1->(FieldPos("E1_TITPAI")) # 0
								If Empty(E1_TITPAI) .OR. (MV_CRNEG $ E1_TITPAI .OR. MVRECANT $ E1_TITPAI)
									lOkTitAb := .T.
								Else 
									lOkTitAb := .F.
								Endif
							Else 
								lOkTitAb := .T.
							Endif
							If lOkTitAb
								RecLock("__SE1")
								Replace E1_SALDO	With 0
								Replace E1_BAIXA	With If(E1_BAIXA <= dBaixa, dBaixa, E1_BAIXA)
								Replace E1_STATUS  With "B"
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Gravar o titulo que baixou o AB- para evitar estornos de ³
								//³abatimentos baixados por outras rotinas. Evita que um AB-³
								//³baixado pelo FINA070 / 110 seja estornado indevidamente  ³
								//³pelo FINA330, que gera erro na composicao do saldo do    ³
								//³titulo principal com abatimento.                         ³
								//³Gravar SEMPRE NCC/RA para identificar a baixa do AB-     ³
								//³pela rotina FINA330										³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If __SE1->(FieldPos("E1_TITPAI")) # 0
									Replace E1_TITPAI	With cDadosTitulo
								Endif                                    
								MsUnlock()
							Endif
						EndIf
						dbSkip()
					Enddo
					__SE1->(dbSetOrder(1))
				Endif
				dbSelectArea("SE1")
				dbGoto(nSE1Rec)
				VALOR2 := 0
				VALOR3 := 0
				VALOR4 := 0
				VALOR5 := 0
				VALOR6 := 0

				If lCredito
					If cPaisLoc == "BRA" .and. lPccBxCr
						VALOR2 := SE1->E1_IRRF
						If EMPTY(SE5->E5_PRETPIS)
							VALOR3 := SE5->E5_VRETPIS
						ENDIF
						If EMPTY(SE5->E5_PRETCOF)
							VALOR4 := SE5->E5_VRETCOF
						Endif
						If EMPTY(SE5->E5_PRETCSL)				
							VALOR5 := SE5->E5_VRETCSL
						Endif
						VALOR6 := SE1->E1_INSS
					Else
						VALOR2 := SE1->E1_IRRF
						VALOR3 := SE1->E1_PIS
						VALOR4 := SE1->E1_COFINS
						VALOR5 := SE1->E1_CSLL
						VALOR6 := SE1->E1_INSS
					Endif

					dbSelectArea("SE1")
					dbGoto(nSE1Rec)
				Endif

				IF lPadrao .and. mv_par09 == 1
					nTotal += DetProva( nHdlPrv,;
					                    cPadrao,;
					                    "FINA330",;
					                    cLote,;
					                    /*nLinha*/,;
					                    /*lExecuta*/,;
					                    /*cCriterio*/,;
					                    /*lRateio*/,;
					                    /*cChaveBusca*/,;
					                    /*aCT5*/,;
					                    /*lPosiciona*/,;
					                    @aFlagCTB,;
					                    {"SE5",nRecnoRA}/*aTabRecOri*/,;
					                    /*aDadosProva*/ )
				Endif

				VALOR2 := 0
				VALOR3 := 0
				VALOR4 := 0
				VALOR5 := 0
				VALOR6 := 0

				dbSelectArea ("SE1")
				dbSetOrder(1)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Integracao Protheus X RM Classis Net (RM Sistemas)³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				if GetNewPar("MV_RMCLASS", .F.) .or. GetNewPar("MV_RMBIBLI",.F.)
					if alltrim(upper(SE1->E1_ORIGEM)) == 'L' .or. alltrim(upper(SE1->E1_ORIGEM)) == 'S' .or. SE1->E1_IDLAN > 0
						//Executa funcao para replicar a baixa para as tabelas do RM Corpore
						ClsProcBx(SE1->(Recno()),'1',"FIN330")
					endif
				endif
				
				If lfa330Bx
					Execblock("FA330BX",.f.,.f.)
				Endif
			Endif
		Next
		nRegSE5 := SE5->(Recno())
		nRegSE1 := SE1->(Recno())
		If GetMv("MV_COMISCR") == "S" .and. GetMv("MV_TPCOMIS") == "O"
			dbSelectArea("SE1")
			dbSetOrder(2)
			dbGoto(nRecNo)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se calcula comissao sobre valores       ³
			//³ de NCC ou RA que compuseram a compenca‡Æo Receb. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par06 == 2 .Or. mv_par13 == 2
				For nLinha:= Len(aBaixas) to 1 Step -1
					lDeleted := .F.
					// Verifica se ha a 5 dimensao na matriz de valores baixados
					If Len(aBaixas[nLinha][1]) >= 5
						If mv_par06 == 2
							If MV_CRNEG $ SubStr(aBaixas[nLinha][1][5],nTamTit+1,nTamTip)
								ADEL(aBaixas,nLinha)
								ASIZE(aBaixas,Len(aBaixas)-1)
								lDeleted := .T.
							Endif
						Endif	
						If mv_par13 == 2 .And. !lDeleted
							If MVRECANT $ SubStr(aBaixas[nLinha][1][5],nTamTit+1,nTamTip)
								ADEL(aBaixas,nLinha)
								ASIZE(aBaixas,Len(aBaixas)-1)
							Endif
						Endif	
					Endif	
				Next
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula comissao, se houver vendedor		  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Len(aBaixas) > 0
				AeVal(aBaixas,{|x|Fa440CalcB(x,.F.,.F.,"FINA070")})
			EndIf
		Endif

		//PCC Baixa CR
		If cPaisLoc == "BRA" .and. lPccBxCr .and. !lCredito
			VALOR2 := SE1->E1_IRRF
			If EMPTY(SE5->E5_PRETPIS)
				VALOR3 := SE5->E5_VRETPIS
			ENDIF
			If EMPTY(SE5->E5_PRETCOF)
				VALOR4 := SE5->E5_VRETCOF
			Endif
			If EMPTY(SE5->E5_PRETCSL)				
				VALOR5 := SE5->E5_VRETCSL
			Endif
			VALOR6 := SE1->E1_INSS

		Else
			VALOR2 := SE1->E1_IRRF
			VALOR3 := SE1->E1_PIS
			VALOR4 := SE1->E1_COFINS
			VALOR5 := SE1->E1_CSLL
			VALOR6 := SE1->E1_INSS
		Endif

		If lPadrao .and. mv_par09 == 1

			SE5->(dbGoBottom())
			SE5->(dbSkip())
			SE1->(dbGoBottom())
			SE1->(dbSkip())
			VALOR := nValorComp
			nSldReal := Round(NoRound(xMoeda(nSaldo,nMoeda,1,,3,Fa330TxMd(nMoeda,0)),3),2)
			ABATIMENTO := IIF(STR(nSldReal,17,2) == STR(nValorComp,17,2),nTotAbat,0)
			REGVALOR := nRecno		// Variavel para usu rio reposicionar o registro do RA  
			nTotal += DetProva( nHdlPrv,;
			                    cPadrao,;
			                    "FINA330",;
			                    cLote,;
			                    /*nLinha*/,;
			                    /*lExecuta*/,;
			                    /*cCriterio*/,;
			                    /*lRateio*/,;
			                    /*cChaveBusca*/,;
			                    /*aCT5*/,;
			                    /*lPosiciona*/,;
			                    @aFlagCTB,;
			                    /*aTabRecOri*/,;
			                    /*aDadosProva*/ )

			RodaProva(  nHdlPrv,;
						nTotal)
			
			If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() ) 
				For nX := 1 To Len(aBaixaSE5)
					AAdd(aDiario,{"SE5",aBaixaSE5[nX],cCodDiario,"E5_NODIA","E5_DIACTB"})
				Next nX
			EndIf	                
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para Lan‡amento Cont bil							  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lDigita := IIF( mv_par07 == 1,.t., .f. )
			cA100Incl( cArquivo,;
			           nHdlPrv,;
			           3,;
			           cLote,;
			           lDigita,;
			           .F.,;
			           /*cOnLine*/,;
			           /*dData*/,;
			           /*dReproc*/,;
			           @aFlagCTB,;
			           /*aDadosProva*/,;
			           aDiario )
			aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento

			VALOR  := 0
			VALOR2 := 0
			VALOR3 := 0
			VALOR4 := 0
			VALOR5 := 0
			VALOR6 := 0

		Endif
		SE5->(dbGoTo(nRegSE5))
		SE1->(dbGoTo(nRegSE1))

		//integracao com modulo PCO
		Fa330IntPco(nRecno, aRegSE1, aBaixaSE5)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Final  da protecao via TTS	                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		End Transaction
		
		If lACAtivo		
			ACFina070() // Realiza as consequencias de uma baixa de titulo com o modulo Gestao Educacional ativo.
		Endif
		
	Endif
	Exit
EndDo

cPrefixo := CriaVar("E1_PREFIXO")
cNum		:= CriaVar("E1_NUM")
cTipoTit := CriaVar("E1_TIPO")
cCliente := CriaVar("E1_CLIENTE")
cLoja 	:= CriaVar("E1_LOJA")
cSaldo	:= CriaVar("E1_SALDO")
nValor	:= CriaVar("E1_SALDO")
cParcela := CriaVar("E1_PARCELA")
nMoeda	:= 1
nValor	:= 0
nValTot	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a gravacao dos lancamentos do SIGAPCO            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PcoFinLan("000016")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE1")
dbSetOrder(nIndexAtu)
dbGoTo(nTitIni)

DeleteObject(oOk)
DeleteObject(oNo)	
FA330aUnlock()
Return (.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ fa330Cli ³ Autor ³ Mauricio Pequim Jr.   ³ Data ³ 21/03/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica validade do Cliente								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fa330Cli()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA330													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fa330Cli( )
Local cAlias := Alias( )
dbSelectArea("SA1")
dbSeek(xFilial("SA1")+cCliente)
IF !Found()
	Help(" ",1,"A330CLI")
	Return .F.
Else
	cLoja:=Iif(Empty(cLoja),SA1->A1_LOJA,cLoja)
EndIF
dbSelectArea(cAlias)
Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ fa330Loja³ Autor ³ Mauricio Pequim Jr.   ³ Data ³ 21/03/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica validade da Loja do Cliente						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fa330Loja() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA330													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FuncTion fa330Loja()
LOCAL cAlias:=Alias()
LOCAL nOrdSe1 := 0
LOCAL lRet := .T.

dbSelectArea("SA1")
dbSeek(xFilial()+cCliente+cLoja)
IF !Found()
	Help(" ",1,"A330LOJA")
	lRet := .F.
Endif
If lRet
	dbSelectArea("SE1")
	nOrdSe1 := IndexOrd()
	dbSetOrder(2)
	If dbSeek(xFilial()+cCliente+cLoja+cPrefixo+cNum+cParcela+cTipoTit)
		If mv_par05 == 2 .and. !(E1_SITUACA $ "0FG")
			Help(" ",1,"F330CARTE")
			lRet := .F.
		Endif
	Else
		Help(" ",1,"NOTIT")
		lRet := .F.
	Endif
	dbSetOrder(nOrdSe1)
Endif
dbSelectArea(cAlias)
Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa330Tit	³ Autor ³ Mauricio Pequim Jr.   ³ Data ³ 22/09/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera Tabela com os titulos 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fina330													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function Fa330Tit(dEmissao,cOrigem,lCredito,aNumLay)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a Integridade dos dados de Entrada 						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cSavArea := alias()
Local cAliasSE1:= "SE1"      
LOCAL lMarca	:=.T.
LOCAL lF330RIO  := ExistBlock("F330RIO")
Local lQuery    := .F.
LOCAL nSavOrd	:= IndexOrd()
LOCAL nRecNo	:= RecNo()
LOCAL nTotComp	:=0
LOCAL nVlBasico :=0
Local nDecs     := MsDecimais(nMoeda)
Local bWhile    := {|| .T.}
LOCAL nRecEmp  := SM0->(RecNo())
LOCAL cEmpAnt  := SM0->M0_CODIGO
LOCAL cFilDe
LOCAL cFilAte
Local cCgcClie, cNomclie 
Local nX := 0
Local nPosNumLay:= 0
Local lFa330Qry := Existblock("FA330QRY")    
Local cOrdemSE1

//Controla o Pis Cofins e Csll na baixa  (1-Retem PCC na Baixa ou 2-Retem PCC na Emissão(default) )
Local lPccBxCr	:= If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)
Local nVlMinImp	:= GetNewPar("MV_VL10925",5000)
Local nTotCsAbt	:= 0	
Local nTotPisAbt	:= 0 
Local	nTotCofAbt	:= 0
Local nPccBxCr		:= 0
Local lAplVlMin	:= .T.
Local nValorPcc	:= 0
Local aCamposKey := {}

#IFDEF TOP
	Local cSep	:=	IIf("|"$MV_CRNEG,"|",",")
	Local cQuery   := ""
	Local cAliasSA1:= "SA1"
	Local aStruQry := {}
	Local cUserKey	:= SE1->(IndexKey())
	Local cSelect	:= "E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_MOEDA,E1_TIPO,E1_SALDO,E1_EMISSAO,E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_SDACRES,E1_SDDECRE,E1_HIST,E1_PIS,E1_COFINS,E1_CSLL"

	//Incluo na chave do select os campos do usuario que possam estar na chave de indice.
	//Exemplo: Cliente possui uma chave de indice E1_FILIAL,E1_MSFIL,E1_NUM,E1_PARCELA
	//				Como o E1_MSFIL nao esta na expressao do SELECT padrao ele adiciona o campo
	//				evitando error.log
	aCamposKey := STRTOKARR(cUserKey,"+")
#ENDIF

For nX := 1 to Len(aCamposKey)
	If AT("(",aCamposKey[nX]) > 0 .Or. AT(")",aCamposKey[nX]) > 0 //Removo da String potenciais chamadas de funcao
		aCamposKey[nX] := Substr(aCamposKey[nX], AT("(",aCamposKey[nX])+1, AT(")",aCamposKey[nX])-AT("(",aCamposKey[nX])-1)
	EndIf		
	If !(aCamposKey[nX] $ cSelect)
		cSelect += ","+aCamposKey[nX]
	Endif
Next	
	
dBaixa := If (Type("dBaixa") != "D",dDataBase,dBaixa)

//Verificar ou nao o limite de 5000 para Pis cofins Csll
// 1 = Verifica o valor minimo de retencao
// 2 = Nao verifica o valor minimo de retencao
If !Empty( SE1->( FieldPos( "E1_APLVLMN" ) ) ) .and. SE1->E1_APLVLMN == "2"
	lAplVlMin := .F.
Endif	  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada permite alterar o indice que sera aplicado no Markbrowse ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("FA330ORD")
	dbSetOrder(ExecBlock("FA330ORD",.F.,.F.))
Endif
cOrdemSE1 := SE1->(IndexKey())
SE1->(dbSetOrder(1))

If cOrigem == "COMPENSANCC"
	mv_par10 := 2
EndIf	
If mv_par10 == 2
	cFilDe := cFilAnt
	cFilAte:= cFilAnt
Else
	cFilDe := mv_par11
	cFilAte:= mv_par12
Endif


#IFDEF TOP
	If TcSrvType() <> "AS/400"     

		dbSelectArea("SX3")
		dbSetOrder(2)
	
		MsSeek("E1_SALDO")
		aadd(aStruQry,{"E1_SALDO",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})			

		MsSeek("E1_EMISSAO")
		aadd(aStruQry,{"E1_EMISSAO",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})			

		MsSeek("E1_MOEDA")
		aadd(aStruQry,{"E1_MOEDA",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})			

		dbSelectArea("SE1")
		dbSetOrder(2)
		
		lQuery    := .T.
		cAliasSE1 := "QRYSE1"
		cAliasSA1 := "QRYSE1"
		
		cQuery := "SELECT DISTINCT "+cSelect+","
		cQuery += "SE1.R_E_C_N_O_ RECSE1, A1_CGC,A1_PESSOA FROM "
		cQuery += RetSqlName("SE1") + " SE1 LEFT JOIN "
		cQuery += RetSqlName("SA1") + " SA1 ON (SE1.E1_LOJA = SA1.A1_LOJA) AND (SE1.E1_CLIENTE = SA1.A1_COD) "		
		cQuery += " WHERE "       
		If mv_par10 == 2
			cQuery += "SE1.E1_FILIAL = '"+ xFilial("SE1")+"' AND "
		Else 
			cQuery += "SE1.E1_FILIAL >= '"+ cFilDe +"' AND "
			cQuery += "SE1.E1_FILIAL <= '"+ cFilAte+"' AND "
		Endif
		If mv_par02 == 1
			cQuery += "SE1.E1_CLIENTE = '"+cCliente+"' AND "
		Else
			cQuery += "SE1.E1_CLIENTE >= '"+mv_par03+"' AND "
			cQuery += "SE1.E1_CLIENTE <= '"+mv_par04+"' AND "
		Endif	
		If mv_par01 == 1 .And. mv_par02 == 1
			cQuery += "SE1.E1_LOJA = '"+cLoja+"' AND "
		Endif	

		If mv_par05 == 2                              
			cQuery += "SE1.E1_SITUACA IN ('0','F','G') AND "
		Endif					
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso titulos originados pelo SIGALOJA estejam nas carteiras :  ³
		//³I = Carteira Caixa Loja                                        ³
		//³J = Carteira Caixa Geral                                       ³
		//³Nao permitir a selecao destes titulos                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery += "SE1.E1_SITUACA NOT IN ('I','J') AND "

		If cPaisLoc <> "BRA"
			If lCredito
				cQuery += "SE1.E1_TIPO NOT IN " + FormatIn( MV_CRNEG+cSep+MVRECANT,cSep) + " AND "				
			Else 
				cQuery += "SE1.E1_TIPO IN " + FormatIn( MV_CRNEG+cSep+MVRECANT,cSep) + " AND "				
			Endif
		Else
			If lCredito                                                                             
				cQuery += "SE1.E1_TIPO NOT IN " + FormatIn( MV_CRNEG+cSep+MVRECANT+cSep+MVPROVIS,cSep) + " AND "				
			Else   
				If (cTipoTit $ MVRECANT .And. cTipoTit $ MV_CRNEG )
					cQuery += " (SE1.E1_TIPO NOT IN " + FormatIn(MVRECANT,",") + " OR  "
					cQuery += "SE1.E1_TIPO NOT IN " + FormatIn( MV_CRNEG,cSep) + ") AND "
				ElseIf !(cTipoTit $ MVRECANT) .And. !(cTipoTit $ MV_CRNEG )
					cQuery += " ( SE1.E1_TIPO IN " + FormatIn(MVRECANT,",") + " OR  "
					cQuery += "SE1.E1_TIPO IN " + FormatIn( MV_CRNEG,cSep) + ") AND "
				Endif	
			Endif
		Endif
                  
		cQuery += "SE1.E1_TIPO NOT IN " + FormatIn(MVABATIM,"|") + " AND "
		cQuery += "SE1.E1_SALDO > 0 AND "
		cQuery += "SE1.E1_EMISSAO <= '"+DtoS(dDatabase)+ "' AND "
		cQuery += "SE1.D_E_L_E_T_ = ' ' AND "
		If mv_par10 == 2 						
			cQuery += "SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "
		EndIf	
		cQuery += "SA1.D_E_L_E_T_ = ' ' "
		
		cQuery += "ORDER BY " + SqlOrder(cOrdemSE1)             

		If lFa330Qry
			cQuery := Execblock("FA330QRY",.f.,.f.,{ cQuery }  )			// permite manipualção das query
		Endif

		cQuery := ChangeQuery(cQuery)
 		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasSE1,.f.,.t.)		
		
		For nX := 1 To Len(aStruQry)
			If ( aStruQry[nX][2] <> "C" )
				TcSetField(cAliasSE1,aStruQry[nX][1],aStruQry[nX][2],aStruQry[nX][3],aStruQry[nX][4])
			EndIf
		Next nX
		

		bWhile := {|| (cAliasSE1)->(!Eof()) }

		ProcRegua((cAliasSE1)->(Reccount()),STR0032 )

	Else
	
#ENDIF		

			dbSelectArea(cAliasSE1)
			dbSetOrder(2)
			cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

			dbSeek( xFilial()+If(MV_PAR02==1,cCliente,mv_par03)+If(MV_PAR01==1 .and. MV_PAR02 == 1,cLoja,""), .T.)
	
			bWhile := { || !Eof() .and. (cAliasSE1)->E1_FILIAL == xFilial() .And.;
							If(MV_PAR02==1,(cAliasSE1)->E1_CLIENTE == cCliente,(cAliasSE1)->E1_CLIENTE <= mv_par04)  .and. ;
							If(MV_PAR01==1 .AND. MV_PAR02 == 1 ,(cAliasSE1)->E1_LOJA == cLoja,.T.) }
							
			ProcRegua(SE1->(Reccount())/IIf(mv_par02==2,1,SA1->(Reccount()) ),STR0032 )


#IFDEF TOP
	Endif
#ENDIF	

dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

aTitulos := {}
aRecNo := {}        

While !Eof() .and. M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte

	dbSelectArea(cAliasSE1)
	If !lQuery
		dbSetOrder(2)
	Endif
	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	If !lQuery
		dbSeek( xFilial()+If(MV_PAR02==1,cCliente,mv_par03)+If(MV_PAR01==1 .and. MV_PAR02 == 1,cLoja,""), .T.)
   Endif
	While Eval(bWhile)
		
	   IncProc()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ PONTO DE ENTRADA F330RIO                                      ³
		//³ Tratamento de "filtragem" de titulos de adiantamento a serem  ³
		//³ considerados ou nÆo no array dos adiantamentos a serem compen-³
		//³ sados. Retorno l¢gico.                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF lF330RIO
			If !(ExecBlock("F330RIO",.F.,.F.))
				dbSkip()
				Loop
			Endif
		Endif		
	                       
		//**********************************************************//
		//* Posiciona o TÍTULO para uso na sumabatrec()  *//
		//**********************************************************//
		dbselectArea("SE1")
		SE1->(dbSetOrder(1))//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		SE1->(dbSeek(xFilial("SE1") + (cAliasSE1)->(E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO)))
		
		dbselectArea(cAliasSE1)
		
		If !lQuery
	
			If MV_PAR02	== 2 .and. (SE1->E1_CLIENTE < mv_par03 .or. SE1->E1_CLIENTE > mv_par04)
				dbSkip()
				Loop
			EndIf
			
			If E1_TIPO $ MVABATIM .or. If(mv_par05 == 2 , !(E1_SITUACA $ "0FG") , .f.) ;
				.or. E1_SALDO == 0 ;
				.or. E1_EMISSAO > dDataBase
				dbSkip()
				Loop
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Caso titulos originados pelo SIGALOJA estejam nas carteiras :  ³
			//³I = Carteira Caixa Loja                                        ³
			//³J = Carteira Caixa Geral                                       ³
			//³Nao permitir a selecao destes titulos                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Upper(AllTrim(SE1->E1_ORIGEM)) == "LOJA010" .AND. Upper(AllTrim(SE1->E1_SITUACA)) $ "I|J"
				(cAliasSE1)->(dbSkip())
				Loop
			Endif			
		Endif
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Vindo do Mata465 vai filtrar so os Tipos compensaveis             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If !lQuery
		
			If cPaisLoc <> "BRA"
				If lCredito
					If E1_TIPO$MV_CRNEG+"/"+MVRECANT
						dbSkip()
						Loop
					EndIf
				Else
					If !(E1_TIPO$MV_CRNEG+"/"+MVRECANT)
						dbSkip()
						Loop
					EndIf
				Endif
			Else
				If lCredito
					If E1_TIPO$MV_CRNEG+"/"+MVRECANT+"/"+MVPROVIS
						dbSkip()
						Loop
					EndIf
				Else
					If ( 	cTipoTit $ MVRECANT .And. E1_TIPO $ MVRECANT .And. ;
						cTipoTit $ MV_CRNEG .And. E1_TIPO $ MV_CRNEG .Or.  ;
						!cTipoTit $ MVRECANT .And. !E1_TIPO $ MVRECANT .And. ;
						!cTipoTit $ MV_CRNEG .And. !E1_TIPO $ MV_CRNEG )
						dbSkip()
						Loop
					Endif	
				Endif
			Endif
			
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Na finalizacao do Lay-Away, seleciona somente os titulos gerados  ³
		//³ pela emissao do mesmo - Loc. EUA|POR                              ³		
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If cOrigem == "LOJA800"		
		   nPosNumLay  := Ascan(aNumLay,AllTrim((cAliasSE1)->E1_NUM))
		   If nPosNumLay == 0 .And. Len(aNumLay) > 0
		       dbSkip()
			   Loop		      
		   EndIf
		EndIf

		//ANGOLA|BRASIL - Nao permitir compensar titulos de adiantamento relacionado a pedido
		#IFDEF TOP
			If cPaisLoc $ "ANG|BRA" .and. AliasInDic("FIE")
				FIE->(dbSetOrder(2))
				If FIE->(MsSeek(xFilial("FIE")+"R"+(cAliasSE1)->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
					dbSkip()
					Loop
				Endif
			Endif
		#ENDIF	

		nVlBasico := IIf (nValor = 0 , nSaldo , nValor)
		lMarca	:=	.F.
	   
	   If ( nVlBasico > nTotComp .or. nTotComp == 0 )  .And. Fa330Lock(, If(lQuery,( cAliasSE1)->RECSE1,(cAliasSE1)->(RecNo())),.F.)	
			lMarca := .T.		// marca para vers„o WIN
			nValPre := IIF (nTotComp == 0 , nVlBasico, nVlBasico - nTotComp)	
			If cPaisLoc == "BRA"
				If mv_par08 == 1  .and.   !((cAliasSE1)->E1_TIPO $ MVRECANT+"/"+MV_CRNEG )
					nTotCsAbt	:= 0	
					nTotPisAbt	:= 0 
					nTotCofAbt	:= 0
					nTotAbat := SumAbatRec((cAliasSE1)->E1_PREFIXO,(cAliasSE1)->E1_NUM,(cAliasSE1)->E1_PARCELA,(cAliasSE1)->E1_MOEDA,"S",dBaixa,,,@nTotCsAbt,@nTotPisAbt,@nTotCofAbt)
//					SomaAbat((cAliasSE1)->E1_PREFIXO,(cAliasSE1)->E1_NUM,(cAliasSE1)->E1_PARCELA,"R",(cAliasSE1)->E1_MOEDA,,(cAliasSE1)->E1_CLIENTE,(cAliasSE1)->E1_LOJA)

					//Se PCC Baixa CR e nao houver abatimento de impostos
					If cPaisLoc == "BRA" .and. lPccBxCR .and. (nTotCsAbt+nTotPisAbt+nTotCofAbt == 0)
						//Se PCC Baixa CR e a compensação partiu de um adiantamento
						//Os titulos nao serao pre-selecionados.
						//Isto se da para que a cada titulo marcado, seja realizado o cálculo do PCC
						lMarca := .F. // 
					Endif
				Else
					nTotAbat := 0
				Endif

				If lMarca
					nValComp := Iif (nValpre > Round(NoRound(xMoeda((cAliasSE1)->E1_SALDO - nTotAbat +(cAliasSE1)->E1_SDACRES-(cAliasSE1)->E1_SDDECRE ,(cAliasSE1)->E1_MOEDA,nMoeda,,3,Fa330Tx2((cAliasSE1)->E1_MOEDA,0),Fa330Tx2(nMoeda,0)),3),2) , ;
										xMoeda((cAliasSE1)->E1_SALDO - nTotAbat +(cAliasSE1)->E1_SDACRES-(cAliasSE1)->E1_SDDECRE,(cAliasSE1)->E1_MOEDA,nMoeda,,5,Fa330Tx2((cAliasSE1)->E1_MOEDA,0),Fa330Tx2(nMoeda,0)),;
										nVlBasico-nTotComp)
				Else
					nValComp := 0
				Endif
			Else
	 	       nValComp := Iif (nValPre > xMoeda((cAliasSE1)->E1_SALDO+(cAliasSE1)->E1_SDACRES-(cAliasSE1)->E1_SDDECRE,(cAliasSE1)->E1_MOEDA,nMoeda,dDatabase,,aTxMoedas[E1_MOEDA][2],aTxMoedas[nMoeda][2]),;
			                Round(xMoeda((cAliasSE1)->E1_SALDO+(cAliasSE1)->E1_SDACRES-(cAliasSE1)->E1_SDDECRE,(cAliasSE1)->E1_MOEDA,nMoeda,dDatabase,nDecs+1,aTxMoedas[E1_MOEDA][2],aTxMoedas[nMoeda][2]),nDecs),;
						    nVlBasico-nTotComp)		
			EndIf				 	  
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ PONTO DE ENTRADA F330CMP                                      ³
			//³ Tratamento de valor a ser compensado em determinado titulo 	³
			//³ permitindo que o usuario possa calcular o valor do titulo NDF ³
			//³ ou PA a ser compensado.                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF ExistBlock("F330CMP")
				nValComp:= ExecBlock("F330CMP",.F.,.F.)
			Endif
			nTotComp += nValComp
		Else
			If cPaisLoc == "BRA"
				If mv_par08 == 1  .and.   !((cAliasSE1)->E1_TIPO $ MVRECANT+"/"+MV_CRNEG )
					nTotCsAbt	:= 0	
					nTotPisAbt	:= 0 
					nTotCofAbt	:= 0
					nTotAbat := SumAbatRec((cAliasSE1)->E1_PREFIXO,(cAliasSE1)->E1_NUM,(cAliasSE1)->E1_PARCELA,(cAliasSE1)->E1_MOEDA,"S",dBaixa,,,@nTotCsAbt,@nTotPisAbt,@nTotCofAbt)
				Else
					nTotAbat := 0
				Endif		
			EndIf
			lMarca := .F.		// desmarca para vers„o WIN
			nValComp := 0
		EndIf
		If cPaisLoc == "BRA"	
			If MV_PAR02 == 2
			   DBSelectArea("SA1")                                    
			   nIndexSA1 := IndexOrd()
			   nPosSA1   := Recno()
				DBSetOrder(1)
			   DBSeek(xFilial()+(cAliasSE1)->E1_CLIENTE+(cAliasSE1)->E1_LOJA)              
				dbSelectArea(cAliasSE1)
				
			   aAdd(aTitulos,{(cAliasSE1)->E1_PREFIXO,;
							   (cAliasSE1)->E1_NUM,;
							   (cAliasSE1)->E1_PARCELA,;
							   (cAliasSE1)->E1_TIPO,;
							   (cAliasSE1)->E1_LOJA,;
							   Transform(xMoeda((cAliasSE1)->E1_SALDO+(cAliasSE1)->E1_SDACRES-(cAliasSE1)->E1_SDDECRE- Iif(  Type("nTotAbat") <> "N" ,0,nTotAbat) - nPccBxCr,(cAliasSE1)->E1_MOEDA,nMoeda,,5,Fa330TxMd((cAliasSE1)->E1_MOEDA,0),Fa330Tx2(nMoeda,0)),"@E 9999,999,999.99"),;
							   Transform(nValComp,"@E 9999,999,999.99"),;
							   lMarca,;
							   nValComp,;
							   (cAliasSE1)->(E1_CLIENTE)+"-"+(cAliasSE1)->(E1_LOJA),;
							   (cAliasSE1)->E1_NOMCLI,;
							   Transform(SA1->A1_CGC,Substr(PicPes(SA1->A1_PESSOA),1,at("%",PicPes(SA1->A1_PESSOA))-1)),;
							   Transform(xMoeda((cAliasSE1)->E1_SDACRES,(cAliasSE1)->E1_MOEDA,nMoeda,,5,Fa330TxMd((cAliasSE1)->E1_MOEDA,0),Fa330Tx2(nMoeda,0)),"@E 9999,999,999.99"),;
							   Transform(xMoeda((cAliasSE1)->E1_SDDECRE,(cAliasSE1)->E1_MOEDA,nMoeda,,5,Fa330TxMd((cAliasSE1)->E1_MOEDA,0),Fa330Tx2(nMoeda,0)),"@E 9999,999,999.99"),;
							   (cAliasSE1)->E1_HIST,;                                                                                              
							   (cAliasSE1)->E1_FILIAL,;
							   Transform(nValorPcc,"@E 9999,999,999.99"),;	//PCC Baixa CR - Pis
							   Transform(nValorPcc,"@E 9999,999,999.99"),;//PCC Baixa CR - Cofins
							   Transform(nValorPcc,"@E 9999,999,999.99"),;//PCC Baixa CR - Csll
							   Transform(nValorPcc,"@E 9999,999,999.99"),;	//PCC Baixa CR - Pis
							   Transform(nValorPcc,"@E 9999,999,999.99"),;//PCC Baixa CR - Cofins
							   Transform(nValorPcc,"@E 9999,999,999.99"),;//PCC Baixa CR - Csll
								If(lQuery,( cAliasSE1)->RECSE1,(cAliasSE1)->(RecNo()))})
							   
				SA1->(DBSetOrder(nIndexSA1))
				SA1->(DBGoto(nPosSA1))

			Else
			   aAdd(aTitulos,{(cAliasSE1)->E1_PREFIXO,;
							   (cAliasSE1)->E1_NUM,;
							   (cAliasSE1)->E1_PARCELA,;
							   (cAliasSE1)->E1_TIPO,;
							   (cAliasSE1)->E1_LOJA,;
							   Transform(xMoeda((cAliasSE1)->E1_SALDO+(cAliasSE1)->E1_SDACRES-(cAliasSE1)->E1_SDDECRE- Iif(  Type("nTotAbat") <> "N" ,0,nTotAbat),(cAliasSE1)->E1_MOEDA,nMoeda,,5,Fa330Tx2((cAliasSE1)->E1_MOEDA,0),Fa330Tx2(nMoeda,0)),"@E 9999,999,999.99"),;
							   Transform(nValComp,"@E 9999,999,999.99"),;
							   lMarca,;
							   nValComp,;
							   Transform(xMoeda((cAliasSE1)->E1_SDACRES,(cAliasSE1)->E1_MOEDA,nMoeda,,5,Fa330Tx2((cAliasSE1)->E1_MOEDA,0),Fa330Tx2(nMoeda,0)),"@E 9999,999,999.99"),;
							   Transform(xMoeda((cAliasSE1)->E1_SDDECRE,(cAliasSE1)->E1_MOEDA,nMoeda,,5,Fa330Tx2((cAliasSE1)->E1_MOEDA,0),Fa330Tx2(nMoeda,0)),"@E 9999,999,999.99"),;
							   (cAliasSE1)->E1_HIST,; 
							   (cAliasSE1)->E1_FILIAL,;
							   Transform(nValorPcc,"@E 9999,999,999.99"),;	//PCC Baixa CR - Pis
							   Transform(nValorPcc,"@E 9999,999,999.99"),;//PCC Baixa CR - Cofins
							   Transform(nValorPcc,"@E 9999,999,999.99"),;//PCC Baixa CR - Csll
							   Transform(nValorPcc,"@E 9999,999,999.99"),;	//PCC Baixa CR - Pis
							   Transform(nValorPcc,"@E 9999,999,999.99"),;//PCC Baixa CR - Cofins
							   Transform(nValorPcc,"@E 9999,999,999.99"),;//PCC Baixa CR - Csll
								If(lQuery,( cAliasSE1)->RECSE1,(cAliasSE1)->(RecNo()))})
			Endif   
			If ExistBlock("FI330ALT")
				aTitulos:=ExecBlock("FI330ALT",.F.,.F.,{aTitulos})			
			EndIF	

		Else	  
	      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	      //³Se na listagem de titulos nao considerar o cliente original do titulo selecionado, mostra o cgc |
	      //|e o nome dos clientes refrentes a cada titulo (MV_PAR02==2)                                     |                   
	      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		   If MV_PAR02 == 2       
		       //Posiciona arquivo de clientes para buscar o CGC e Nome
	
			   DBSelectArea("SA1")                                    
			   nIndexSA1 := IndexOrd()
			   nPosSA1   := Recno()
	           DBSetOrder(1)
			   DBSeek(xFilial()+(cAliasSE1)->E1_CLIENTE+(cAliasSE1)->E1_LOJA)              
			   cCgcClie := SA1->A1_CGC
			   cNomClie := SA1->A1_NOME

     	   	   DBSetOrder(nIndexSA1)
     	   	   DBGoto(nPosSA1)              
  			
	     	   //---
	     	   DBSelectArea(cAliasSE1)
				aAdd(aTitulos,{(cAliasSE1)->E1_PREFIXO,;
									(cAliasSE1)->E1_NUM,;
									(cAliasSE1)->E1_PARCELA,;
									(cAliasSE1)->E1_TIPO,;
									(cAliasSE1)->E1_LOJA,;
									Transform(Round(xMoeda((cAliasSE1)->E1_SALDO+(cAliasSE1)->E1_SDACRES-(cAliasSE1)->E1_SDDECRE,(cAliasSE1)->E1_MOEDA,nMoeda,(cAliasSE1)->E1_EMISSAO,nDecs+1,aTxMoedas[(cAliasSE1)->E1_MOEDA][2],aTxMoedas[nMoeda][2]),nDecs),PesqPict("SE1","E1_SALDO")),;
									Transform(nValComp,PesqPict("SE1","E1_SALDO")),;
									lMarca,;
									(cAliasSE1)->E1_MOEDA,;
									(cAliasSE1)->E1_EMISSAO,;
									cNomClie,;
									Transform(cCgcClie,PesqPict("SA1","A1_CGC")),;
									Transform(xMoeda((cAliasSE1)->E1_SDACRES,(cAliasSE1)->E1_MOEDA,nMoeda,,5),"@E 9999,999,999.99"),;
							     	Transform(xMoeda((cAliasSE1)->E1_SDDECRE,(cAliasSE1)->E1_MOEDA,nMoeda,,5),"@E 9999,999,999.99"),;
	       	               			(cAliasSE1)->E1_HIST,; 
							      	(cAliasSE1)->E1_FILIAL})
							   
	       	   
	       	   //Reposiciona arquivo de clientes
	      	   //---
	       Else
	       	   aAdd(aTitulos,{(cAliasSE1)->E1_PREFIXO,;
	       	                  (cAliasSE1)->E1_NUM,;
	       	                  (cAliasSE1)->E1_PARCELA,;
	       	                  (cAliasSE1)->E1_TIPO,;
	       	                  (cAliasSE1)->E1_LOJA,;
	       	                  Transform(Round(xMoeda((cAliasSE1)->E1_SALDO,(cAliasSE1)->E1_MOEDA,nMoeda,(cAliasSE1)->E1_EMISSAO,nDecs+1,aTxMoedas[(cAliasSE1)->E1_MOEDA][2],aTxMoedas[nMoeda][2]),nDecs),PesqPict("SE1","E1_SALDO")),;
	       	                  Transform(nValComp,PesqPict("SE1","E1_SALDO")),;
	       	                  lMarca,;
	       	                  (cAliasSE1)->E1_MOEDA,;
	       	                  (cAliasSE1)->E1_EMISSAO,;
							  Transform(xMoeda((cAliasSE1)->E1_SDACRES,(cAliasSE1)->E1_MOEDA,nMoeda,,5),"@E 9999,999,999.99"),;
							  Transform(xMoeda((cAliasSE1)->E1_SDDECRE,(cAliasSE1)->E1_MOEDA,nMoeda,,5),"@E 9999,999,999.99"),;
	       	           	      (cAliasSE1)->E1_FILIAL})      
	       EndIf       
	       //---	   
		EndIf  	
		aAdd(aRecNo,If(lQuery,(cAliasSE1)->RECSE1,(cAliasSE1)->(RecNo())))
		(cAliasSE1)->(dbSkip())
	Enddo
	If !lQuery
		dbSelectArea("SM0")
		dbSkip()
		If Empty(xFilial("SE1"))
			Exit
		Endif
	Else
		Exit
	Endif
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SM0")
dbGoto(nRecEmp)
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza valor total dos t¡tulos - Windows	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nValTot := 0
For nX := 1 to Len(aTitulos)
	If aTitulos[nX,8]
		nValtot += Fa330VTit(aTitulos[nX,7])
	Endif
Next

If lQuery
	dbSelectArea(cAliasSE1)
	dbCloseArea()
	dbSelectArea("SE1")
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cSavArea)
dbSetOrder(nSavOrd)
dbGoto(nRecNo)

Return( aTitulos )
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa330VTit ³ Autor ³ Mauricio Pequim Jr.   ³ Data ³ 22/09/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o saldo ou valor do titulo a ser compensado		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fina330													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function Fa330VTit(aTitulo,cTipoTit,cValor)
LOCAL nValor
cValor := IIF (cValor == NIL,aTitulo,cValor)	
nValor := DesTrans(cValor)
Return nValor

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA330Desc³ Autor ³ Wagner Xavier 		³ Data ³ 01/09/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cancelar a Compensa‡„o de Adiantamentos.					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA330Desc() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA330													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function FA330DesC( cAlias, nReg, nOpc )
Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Local nOpcA 		:= 0         		// Indica se a Compesa‡ao sera efetuada
Local dBaixa		:= SE1->E1_BAIXA	// Data da Baixa
Local lCancelou 	:= .F.				// Indica se foi realmente cancelado
Local aRegistros 	:= {}             // Guarda os registros do SE5 a serem cancelados
Local cDocumento  := ""             // Guarda o RA/NCC que efetuou a Bx.
local cArquivo    := ""             // Utilizado na Contabilizacao	
local nTotal		:=0               // Utilizado na Contabilizacao
local nHdlPrv		:=0               // Utilizado na Contabilizacao
local cPadrao		:="588"           // Utilizado na Contabilizacao
local lPadrao		:=.F.					// Utilizado na Contabilizacao
Local lFirst		:=.F.					// Utilizado na Contabilizacao
Local cLojaCmp		:= ""             // Util. para Comp. de Lojas diferentes
local nOrdSE1		:= SE1->(IndexOrd())
local nRegSE1     := 0              // Guarda o Registro do SE1
local nRegSE5     := 0              // Guarda o Registro do SE5
Local lMarcado		:=.F.             // Indica se o item foi marcado
Local nMoeda      := 0              // Moeda do Titulo Principal (SE1)
Local cAdiantamento						// Guarda o RA/NCC que efetuou a Bx.
Local nVlrAbat    := 0
Local aBaixas     := {}             // Guarda o se5 para cancelar comissao
Local oDlg
Local oOk		:= LoadBitmap( GetResources(), "LBOK" )
Local oNo		:= LoadBitmap( GetResources(), "LBNO" )
Local oTitulo
Local nDecs       := 2
Local nTxMoeda    := 0
Local nDecs1      := MsDecimais(1)
Local	aDoctosSE5  := {}
Local nSaldoComp  := 0
Local aArea:={}
Local cChaveSE1
Local nValCtb := 0		// Valor total a ser contabilizado (VALOR)
Local nI := 0
Local nLaco := 0
Local nTotAbat := 0
Local nSE1Rec := 0
Local cKeyAbt := 0
Local nAcresc := 0		//Acrescimo do titulo de adiantamento
Local nDecres := 0		//Decrescimo do titulo de adiantamento
Local nTitAcres := 0		//Acrescimo do titulo principal
Local nTitDecre := 0		//Decrescimo do titulo principal
Local aSE5 := {}
Local nX := 0   
Local nY := 0
Local nT := 0
Local lAchou := .F.
Local cCliAdt := ""
Local cLojAdt := ""
Local lF330FLTC := ExistBlock("F330FLTC")
Local nRecnoSE1 := SE1->(RECNO())
Local lImpComp := SuperGetMv("MV_IMPCMP",,"2") == "1"
Local lIsNcc	:= .F.
//Compensacao de contas a receber, nao necessita verificar o parametro MV_BX10925
Local lPCCBaixa := (cPaisLoc == "BRA")  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local aSize			:= {}
Local oPanel
Local lDigita
LOCAL lACAtivo 		:= GetNewPar("MV_ACATIVO", .F.) //Verifica se o cliente utiliza o modulo Educacional
Local aAcValores	:= {}
Local aAcLayout		:= {} 
Local cAcTitulo		:= "" 
Local cAcPrefixo	:= ""
Local cAcNumero		:= ""
Local cAcParcela	:= "" 
Local cAcTipo		:= ""

Local aDiario		:=	{}
Local lVldDtFin		:= .T.
Local aFlagCTB		:= {}
Local lUsaFlag		:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)

//Controla o Pis Cofins e Csll na baixa  (1-Retem PCC na Baixa ou 2-Retem PCC na Emissão(default) )
Local lPccBxCr	:= If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)
Local nPis		:= 0	
Local nCofins	:= 0 
Local	nCsll		:= 0                 

Local aTitulosTMP	:= {}
Local nPos			:= 0
Local aTamChav		:= {}
Local cREGAnt 		:= ""
Local cREG 			:= ""
Local aLstDOC		:= {}
Local cChaveE1Adt := ""
Local cChaveE5Adt := ""
Local aAreaE5Adt
Local aAreaE1Adt
Local aAdtVen  := {}
Local lAdtVen  := .F.
Local aTipos   := {}
Local cTipos   := ""
Local cTipoAux := ""
Local lVinculo := .F. 
Local lF330Exclui
Local lF330ESE5   := ExistBlock( "F330ESE5" )
Local lF330ExComp := ExistBlock( "F330EXCOMP" )
Local lFi330Est   := ExistBlock( "FI330EST" )
Local lRetAuto	:= .T.
Local cChavePai	:= ''
Local aDtMov	:=	{}
Local lPccComp 	:= .T.
Local aAreaSE5		:=	{}
Local cChaveSE5	:=	''
Local lBxCanc		:= .T.

PRIVATE aTitulos	:={}
PRIVATE cPrefixo	:= SE1->E1_PREFIXO
PRIVATE cNum		:= SE1->E1_NUM
PRIVATE cTipoTit	:= SE1->E1_TIPO
PRIVATE cCliente	:= SE1->E1_CLIENTE
PRIVATE cLoja		:= SE1->E1_LOJA
PRIVATE cParcela	:= SE1->E1_PARCELA
PRIVATE cTipodoc	:= "  "
PRIVATE lCredito	:= .F.
PRIVATE cTipodc		:= " " 
//Guardando a chave do titulo pai.
cChavePai	:= SE1->(E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO + E1_CLIENTE + E1_LOJA)							

If !FA330Lock(,SE1->(Recno()))
	Return
Endif	

If ExistBlock("F330DTFIN")
	lVldDtFin := ExecBlock("F330DTFIN",.F.,.F.)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se data do movimento n„o ‚ menor que data limite de ³
//³ movimentacao no financeiro    										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lVldDtFin .and. !DtMovFin()
	Return(.F.)
Endif	
If SE1->E1_TIPO $MV_CRNEG+"/"+MVRECANT
	cTipodoc := "BA"
	lCredito:= .T.
	cTipodc:="CP"
	lIsNcc := SE1->E1_TIPO $ MV_CRNEG
Else
	cTipodoc := "CP"
	cTipodc:="BA"
Endif
If Substr(SE1->E1_TIPO,3,1) == "-"  
  If !l330Auto 
	 Help(" ",1,"FA030INVAL") 	
  Endif	
  lRetAuto := .F.		
  Return lRetAuto
EndIf

If Select("__SE1") == 0
	SumAbatRec("","","",1,"")
Endif	

While ( .T. )
	aTitulos   := {}
	aRegistros := {}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Titulo a ser cancelado a compensa‡„o		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOpca := 0

	If !l330Auto
		If lPanelfin
			oPanelDados := FinWindow:GetVisPanel()
			oPanelDados:FreeChildren()
			aDim := DLGinPANEL(oPanelDados)
			DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )							
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Observacao Importante quanto as coordenadas calculadas abaixo: ³ 
			//³ -------------------------------------------------------------- ³ 		
			//³ a funcao DlgWidthPanel() retorna o dobro do valor da area do	 ³
			//³ painel, sendo assim este deve ser dividido por 2 antes da sub- ³
			//³ tracao e redivisao por 2 para a centralizacao. 					 ³		
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			nEspLarg := ((DlgWidthPanel(oPanelDados)/2) - 225) /2		 					
			nEspLin  := 20			
	   Else   
	   	nEspLarg := 0 
	   	nEspLin  := 2  	
			DEFINE MSDIALOG oDlg FROM	88,31 TO 187,525 TITLE STR0019 PIXEL  //"Compensa‡„o CR"
		Endif
		oDlg:lMaximized := .F.
		oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
		oPanel:Align := CONTROL_ALIGN_ALLCLIENT    			
		
	   @ 000+nEspLin, 002+nEspLarg TO 030+nEspLin, 245+nEspLarg OF oPanel	PIXEL
		
		@ 014+nEspLin, 006+nEspLarg MSGET cPrefixo							SIZE 19, 10 OF oPanel PIXEL
		@ 014+nEspLin, 032+nEspLarg MSGET cNum 	 Valid !Empty(cNum)	SIZE 70, 10 OF oPanel PIXEL
		@ 014+nEspLin, 105+nEspLarg MSGET cParcela							SIZE 20, 10 OF oPanel PIXEL
		@ 014+nEspLin, 129+nEspLarg MSGET cTipoTit  Picture "@!" Valid  !Empty(cTipoTit) .And.;
			Subs(cTipoTit,3)!="-" SIZE 16, 10 OF oPanel PIXEL
		@ 014+nEspLin, 155+nEspLarg MSGET cCliente F3 "SA1" Valid fa330Cli() SIZE 70, 10 OF oPanel Hasbutton PIXEL
		@ 014+nEspLin, 226+nEspLarg MSGET cLoja	Valid Fa330Loja() 	SIZE 16, 10 OF oPanel PIXEL
		
		@ 006+nEspLin, 006+nEspLarg SAY STR0006  SIZE 21, 7 OF oPanel PIXEL  //"Prefixo"
		@ 006+nEspLin, 032+nEspLarg SAY STR0007  SIZE 22, 7 OF oPanel PIXEL  //"N£mero"
		@ 006+nEspLin, 105+nEspLarg SAY STR0008  SIZE 23, 7 OF oPanel PIXEL  //"Parcela"
		@ 006+nEspLin, 129+nEspLarg SAY STR0009  SIZE 14, 7 OF oPanel PIXEL  //"Tipo"
		@ 006+nEspLin, 155+nEspLarg SAY STR0025  SIZE 34, 7 OF oPanel PIXEL  //"Cliente   "
		@ 006+nEspLin, 226+nEspLarg SAY STR0011  SIZE 14, 7 OF oPanel PIXEL  //"Loja"

		If lPanelFin  //Chamado pelo Painel Financeiro			
			oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])			
			ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
			{||nOpca:=1,oDLg:End()},;
			{||nOpca:=0,oDlg:End()})
			
	   Else		
			DEFINE SBUTTON FROM 34, 190 TYPE 1 ENABLE ACTION (nOpca:=1,oDLg:End()) OF oDlg
			DEFINE SBUTTON FROM 34, 218 TYPE 2 ENABLE ACTION oDlg:End() OF oDlg
			ACTIVATE MSDIALOG oDlg CENTERED
	
		Endif	
		
		If lFi330Est .And. nOpca == 1
			nOpca := ExecBlock("FI330EST",.F.,.F.,{ nOpc, { cPrefixo, cNum, cParcela, cTipoTit, cCliente, cLoja }})
			If ValType(nOpca) != "N"
				nOpca := 0			
			EndIf				
		EndIf
		
		If ( nOpca == 0 )
			DeleteObject(oOk)
			DeleteObject(oNo)

			Exit
		Endif

	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o t¡tulo existe. 	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE1")
	dbSetOrder(2)
	dbSeek(xFilial("SE1")+cCliente+cLoja+cPrefixo+cNum+cParcela+cTipoTit)
	If !Found()	 	
	  If !l330Auto 
		 Help(" ",1,"NOTIT") 
	  Endif
	  DeleteObject(oOk)
	  DeleteObject(oNo)
	  FA330aUnlock()
	  lRetAuto := .F.
	  Exit
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o t¡tulo nao foi compensado.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( SE1->E1_SALDO == SE1->E1_VALOR ) .and. ;
		(SE1->E1_ACRESC == SE1->E1_SDACRES) .and. ;
		(SE1->E1_DECRESC == SE1->E1_SDDECRE)				
		
		If ! l330Auto
		  Help(" ",1,"A330NAOCOMP")
		Endif
		
		DeleteObject(oOk)
		DeleteObject(oNo)		
		lRetAuto := .F.		
		Exit //Loop 	
		
	EndIf

	//ANGOLA - Nao permitir compensar titulos de adiantamento relacionado a pedido				
	#IFDEF TOP
		If cPaisLoc == "ANG" .and. AliasInDic("FIE")
			FIE->(dbSetOrder(2))
			If FIE->(MsSeek(xFilial("FIE")+"R"+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
				Help(" ",1,"NOCANCMP",,"STR0063",1,0)
				DeleteObject(oOk)
				DeleteObject(oNo)
				Loop
			Endif
		Endif
	#ENDIF	

	nMoeda 		:= SE1->E1_MOEDA 				// Moeda do tit original
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Guardo dados do titulo principal para utilizar   ³
	//³ no historico da contabiliza‡Æo                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	STRLCTPAD := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Procura adiantamentos do titulo original para      ³
	//³ montar lista de titulos compensados para apresentar³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("SE5")
	dbSetOrder(2)
	dbSeek(xFilial("SE5")+cTipoDoc+cPrefixo+cNum+cParcela+cTipoTit)
	While (!Eof() .and. xFilial("SE5") == SE5->E5_FILIAL .And.	;
			SE5->E5_TIPODOC == cTipoDoc .And. 				;
			SE5->E5_PREFIXO == cPrefixo .And.				;
			SE5->E5_NUMERO == cNum .And.						;
			SE5->E5_PARCELA == cParcela )
		
		If (SE5->E5_MOTBX != "CMP" .Or. SE5->E5_RECPAG != "R" )
			dbSkip( )
			Loop
		Endif

		//Verifica se tem baixa cancelada
		If TemBxCanc(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ),.T.)
			SE5->(dbskip())
			Loop
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica Cliente se considerar Cliente Original 			³
		//³ na selecao de titulos 												³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par02 == 1 .and.  SE5->E5_CLIFOR != SE1->E1_CLIENTE
			dbSkip( )
			Loop
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica loja caso considere loja na selecao de titulos	  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par01 == 1 .and. mv_par02 == 1 .and.  SE5->E5_LOJA != SE1->E1_LOJA
			dbSkip( )
			Loop
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a baixa e anterior a data do sistema    	  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SE5->E5_DATA >dDatabase
			dbSkip( )
			Loop
		EndIf     
		
		//ANGOLA - Nao permitir compensar titulos de adiantamento relacionado a pedido				
		#IFDEF TOP
			If cPaisLoc == "ANG" .and. AliasInDic("FIE")
				FIE->(dbSetOrder(2))
				If FIE->(MsSeek(xFilial("FIE")+"R"+SE5->(E5_CLIFOR+E5_LOJA+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)))
					dbSkip()
					Loop
				Endif
			Endif
		#ENDIF	

		#IFDEF TOP
			If cPaisLoc == "BRA" .and. AliasInDic("FR3") .and. AliasInDic("FIE")
				// se estorno da compensacao nao estah partindo do titulo de credito
				If !lCredito
					If SE1->E1_ORIGEM = "MATA460" .and. SE1->E1_TIPO = MVNOTAFIS
						// checa se condicao de pagamento eh relacionado com adiantamento
						If FaNfsRAdt(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_EMISSAO)
							lAdtVen := .T.
							// checa se eh a primeira baixa para o titulo principal, pois a primeira baixa eh realizada no momento da geracao do documento de saida, quando hah adiantamento relacionado ao documento.
							If FaBxEmisDoc(SE5->E5_FILIAL,SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_TIPO,SE5->E5_DATA,SE5->E5_SEQ,"R",SE5->E5_DOCUMEN)
								dbSelectArea("SE5")
								aAdd(aAdtVen,{SE5->E5_DATA,SE5->E5_VALOR,SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_SEQ}) // grava array com registros que foram compensados no momento da geracao do documento de saida e que nao podem ser excluidos na compensacao do Fina330. Grava campos que sao iguais entre o registro principal da baixa e o do adiantamento.
								dbSkip()
								Loop
							Endif
						Endif
					Endif       
				// se estorno da compensacao estah partindo do titulo de credito
				Else	
					// posiciona no titulo principal e na baixa principal para checar se eh adiantamento e se esta baixa foi gerada no momento da emissao do documento de saida. 
					aAreaE5Adt := SE5->(GetArea())
					cChaveE5Adt := SE5->E5_FILIAL+cTipoDc+Subs(SE5->E5_DOCUMEN,1,nTamTit+nTamTip)+dTos(SE5->E5_DATA)+SE5->(E5_CLIFOR+E5_LOJA+E5_SEQ)
					aAreaE1Adt := SE1->(GetArea())					
					cChaveE1Adt := SE5->E5_FILIAL+SE5->(E5_CLIFOR+E5_LOJA)+Subs(SE5->E5_DOCUMEN,1,nTamTit+nTamTip)
					// posiciona no titulo principal
					SE1->(dbSetOrder(2))
					If SE1->(dbSeek(cChaveE1Adt))
						// posiciona na baixa principal					
						SE5->(dbSetOrder(2))
						If SE5->(dbSeek(cChaveE5Adt))
							If SE1->E1_ORIGEM = "MATA460" .and. SE1->E1_TIPO = MVNOTAFIS
								// checa se condicao de pagamento eh relacionado com adiantamento
								If FaNfsRAdt(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_EMISSAO)
									lAdtVen := .T.
									// checa se eh a primeira baixa para o titulo principal, pois a primeira baixa eh realizada no momento da geracao do documento de saida, quando hah adiantamento relacionado ao documento.
									If FaBxEmisDoc(SE5->E5_FILIAL,SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_TIPO,SE5->E5_DATA,SE5->E5_SEQ,"R",SE5->E5_DOCUMEN)
										RestArea(aAreaE1Adt)
										RestArea(aAreaE5Adt)
										dbSelectArea("SE5")
										aAdd(aAdtVen,{SE5->E5_DATA,SE5->E5_VALOR,SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_SEQ}) // grava array com registros que foram compensados no momento da geracao do documento de saida e que nao podem ser excluidos na compensacao do Fina330.
										dbSkip()
										Loop
									Endif
								Endif
							Endif       
						Endif	
					Endif	
					RestArea(aAreaE1Adt)
					RestArea(aAreaE5Adt)
					dbSelectArea("SE5")
				Endif
			Endif		
		#ENDIF	

		//Ponto de entrada para dispensar do cancelamento
		If lF330FLTC .and. ExecBlock("F330FLTC",.F.,.F.)		
			dbSkip( )
			Loop
		Endif	
		
  		aAdd(aLstDOC,{SE5->E5_FILIAL,SE5->E5_DOCUMEN})    
		dbSelectArea( "SE5" )
		dbSkip()
	Enddo
	If Len(aLstDOC) == 0	
	  If ! l330Auto 
		 Help(" ",1,"NOTITSEL")
	  Endif		
	  DeleteObject(oOk)
	  DeleteObject(oNo)
	  FA330aUnlock()		
	  lRetAuto := .F.		
	  Exit
	Endif

	If SE1->E1_TIPO $MV_CRNEG+"/"+MVRECANT
		cTipodoc := "CP"
	Else
		cTipodoc := "BA"
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Procura adiantamentos do titulo original para      ³
	//³ montar lista de apresentacao                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("SE5")
	SE5->(dbSetOrder(2))
	For nI := 1 to Len(aLstDOC)
		SE5->(dbSeek(aLstDoc[nI][1] + cTipoDoc + Substr(aLstDoc[nI][2],1,nTamTit+nTamTip)))
		If (lF330ESE5)
			//-- Ponto de entrada para que o registro na SE5 seja posicionado corretamente
			//-- quando existir diferenças no tamanho dos campos envolvidos no indice do SEEK.
			ExecBlock("F330ESE5",.F.,.F.,{aLstDOC,cTipoDoc,nTamTit,nTamTip,nI})
		EndIf
		While !SE5->(Eof()) .AND. SE5->E5_FILIAL == aLstDoc[nI][1] .AND.	;
				SE5->(E5_TIPODOC + E5_PREFIXO + E5_NUMERO + E5_PARCELA) == cTipoDoc + Substr(aLstDoc[nI][2],1,nTamTit)
          
			// se for compensacao gerado no momento da geracao do documento de saida, nao pode ser excluido na compensacao do Fina330.
			#IFDEF TOP
				If lAdtVen
					If aScan(aAdtVen,{|x| x[1] = SE5->E5_DATA .and. ;
					x[2] = SE5->E5_VALOR .and. ;
					x[3] = SE5->E5_CLIFOR .and. ;
					x[4] = SE5->E5_LOJA.and. ;
					x[5] = SE5->E5_SEQ}) > 0
						dbSkip()
						Loop
					Endif
				Endif
			#ENDIF			

			If (SE5->E5_MOTBX != "CMP" .Or. SE5->E5_RECPAG != "R")
				dbSkip( )
				Loop
			Endif
   	                  
			//Verifica se tem baixa cancelada-
			If TemBxCanc(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ),.T.)
				SE5->(dbskip())
				Loop
			EndIf
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica Cliente se considerar Cliente Original 			³
			//³ na selecao de titulos 												³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par02 == 1 .and.  SE5->E5_CLIFOR != SE1->E1_CLIENTE
				dbSkip( )
				Loop
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica loja caso considere loja na selecao de titulos	  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par01 == 1 .and. mv_par02 == 1 .and.  SE5->E5_LOJA != SE1->E1_LOJA
				dbSkip( )
				Loop
			EndIf
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a baixa e anterior a data do sistema    	  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SE5->E5_DATA >dDatabase
				dbSkip( )
				Loop
			EndIf     
	
			//ANGOLA - Nao permitir compensar titulos de adiantamento relacionado a pedido				
			#IFDEF TOP
				If cPaisLoc == "ANG" .and. AliasInDic("FIE")
					FIE->(dbSetOrder(2))
					If FIE->(MsSeek(xFilial("FIE")+"R"+SE5->(E5_CLIFOR+E5_LOJA+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)))
						dbSkip()
						Loop
					Endif
				Endif
			#ENDIF	
			
			//Ponto de entrada para dispensar do cancelamento
			If lF330FLTC .and. ExecBlock("F330FLTC",.F.,.F.)		
				dbSkip( )
				Loop
			Endif	
        	
			If cTipoTit $ MV_CRNEG + "/" + MVRECANT
				If (lIsNCC .AND. !Substr(SE5->E5_DOCUMEN,nTamTit+1,nTamTip) $ MV_CRNEG) .OR. (!lIsNCC .AND. !Substr(SE5->E5_DOCUMEN,nTamTit+1,nTamTip) $ MVRECANT)
			 		SE5->(dbSkip())
					Loop	
				Else
					If Substr(SE5->E5_DOCUMEN,1,nTamTit) # SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA)
						SE5->(dbSkip())
						Loop
					Endif
				Endif
			Endif
			
			If !(cTipoTit $ MV_CRNEG + "/" + MVRECANT) 
				IF Substr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip+nTamLoj) != cPrefixo+cNum+cParcela+cTipoTit+cLoja
					SE5->(dbSkip())
					Loop
				Endif
			Endif
        	
			nOrdSE1	:= SE1->(IndexOrd())		
			nRegSE1	:= SE1->(Recno())
			nTAbat := SumAbatRec(cPrefixo,cNum,cParcela,SE1->E1_MOEDA,"V",dBaixa)
			SE1->(dbSetOrder(nOrdSE1))
			SE1->(dbGoto(nRegSE1))
			nVlLiqTit:= SE1->E1_VALOR - nTAbat		// Valor do titulo - Abatimentos
			Aadd( aTitulos,{ SE5->E5_PREFIXO,;
				SE5->E5_NUMERO,;
				SE5->E5_PARCELA,;
				SE5->E5_TIPO,;
				SE5->E5_LOJA,;
				DtoC(SE5->E5_DATA),;
				Substr(SE5->E5_DOCUMEN,1,nTamTit),;
				SE5->E5_SEQ,;
				Transform(nVlLiqTit,"@E 9999,999,999.99"),;
				Transform(SE5->E5_VLMOED2,"@E 9999,999,999.99"),;
				.T.,;
		    	SE1->E1_FILIAL})
			dbSelectArea( "SE5" )
			dbSkip()
		Enddo
	Next nI
	
	If Len(aTitulos) == 0
	  If !l330Auto 
		 Help(" ",1,"NOTITSEL")
	  Endif		
	  DeleteObject(oOk)      
	  DeleteObject(oNo)
	  FA330aUnlock()         		
	  lRetAuto := .F.		
	  Exit
	Else
		//Remove titulos duplicados, caso existam
		// Primeiro ordena o array para que a lógica faça mais sentido
		aSort( aTitulos , , , { |a,b| a[1]+a[2]+a[3]+a[4]+a[6]+a[8] > b[1]+b[2]+b[3]+b[4]+b[6]+b[8] } )
		If Len(aTitulos) > 1
			For nI := Len(aTitulos) to 1 Step -1
				For nX := 1 to Len(aTitulos[nI])
					cREG += IIf(!cValtoChar(nX) $ "6,8,11",IIf(ValType(aTitulos[nI,nX]) # "C",cValtoChar(aTitulos[nI,nX]),aTitulos[nI,nX]),"")
				Next nX
				If cREGAnt == cREG
					aTitulos[nI,11] := .F.
				Endif
    			cREGAnt := cREG
       			cREG := ""
			Next nI
			For nI := 1 to Len(aTitulos) 
				If aTitulos[nI,11]
					aAdd(aTitulosTMP,aTitulos[nI])
					If !DtMovFin(CtoD(aTitulosTMP[Len(aTitulosTMP)][06]),.F.)
						aTitulosTMP[Len(aTitulosTMP)][11] := .F.
					Endif
				Endif
			Next nI
			aTitulos := aClone(aTitulosTMP)
			aTitulosTMP := Array(0)       
		Else
			If !DtMovFin(CtoD(aTitulos[Len(aTitulos)][06]),.F.)
				aTitulos[Len(aTitulos)][11] := .F.
			Endif
		Endif
	Endif
	
	nOpcA := 0
	If !l330Auto
      
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Mostra Titulos Compensados			 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSize := MsAdvSize(,.F.,400)
		DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
		oDLg:lMaximized := .T.
	
		@ 01.0,.5 LISTBOX oTitulo VAR cVarQ Fields;
			HEADER "",	STR0006,;  //"Prefixo"
			STR0007,;  //"N£mero"
			STR0008,;  //"Parcela"
			STR0009,;  //"Tipo"
			STR0011,;  //"Loja"
			STR0020,;  //"Data"
			STR0021,;  //"Documento"
			STR0022,;  //"Seq"
			STR0023,;  //"Valor do t¡tulo"
			STR0017 ;  //"Valor compensado"												
			COLSIZES 12,GetTextWidth(0,"BBBBB")	,;
			GetTextWidth(0,"BBBBBBBBB")		   ,;
			GetTextWidth(0,"BBBBB")					,;
			GetTextWidth(0,"BBB")					,;
			GetTextWidth(0,"BBB")					,;
			GetTextWidth(0,"BBBBBB")				,;
			GetTextWidth(0,"BBBBBBBBBB")  		,;
			GetTextWidth(0,"BBB")					,;
			GetTextWidth(0,"BBBBBBBBBB")			,;
			GetTextWidth(0,"BBBBBBBBBB")			;
			SIZE 293,54.5 ON DBLCLICK (aTitulos := FA330marca(oTitulo:nAt,aTitulos),oTitulo:Refresh())NOSCROLL
		
		oTitulo:SetArray(aTitulos)
		oTitulo:bLine := { || {If(aTitulos[oTitulo:nAt,11],oOk,oNo),;
			aTitulos[oTitulo:nAt,1],aTitulos[oTitulo:nAt,2],;
			aTitulos[oTitulo:nAt,3],aTitulos[oTitulo:nAt,4],;
			aTitulos[oTitulo:nAt,5],aTitulos[oTitulo:nAt,6],;
			aTitulos[oTitulo:nAt,7],aTitulos[oTitulo:nAt,8],;
			aTitulos[oTitulo:nAt,9],aTitulos[oTitulo:nAt,10]}}
		
		oTitulo:Align := CONTROL_ALIGN_ALLCLIENT
		//---
		oPanel := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,20,20,.T.,.T. )
		oPanel:Align := CONTROL_ALIGN_BOTTOM
		
		If lPanelFin  //Chamado pelo Painel Financeiro					
			ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
			{||nOpca:=1,oDLg:End()},;
			{||nOpca:=0,oDlg:End()})
	   Else	
			DEFINE SBUTTON FROM 4,325 TYPE 1 ACTION (nOpca := 1,oDlg:End())  ENABLE OF oPanel PIXEL
			DEFINE SBUTTON FROM 4,360 TYPE 2 ACTION (nOpca := 0,oDlg:End())  ENABLE OF oPanel PIXEL
			ACTIVATE MSDIALOG oDlg CENTERED ON INIT (oTitulo:Refresh())
			If ( nOpca == 0 )
				DeleteObject(oOk)
				DeleteObject(oNo)
				Exit
			Endif
		Endif		    
	Else
		nOpcA := 1
	EndIf
	
	If ( nOpcA == 1 )

		//Desinvertendo a selecao NF-Antecipacao
		If SE1->E1_TIPO $MV_CRNEG+"/"+MVRECANT
			cTipodoc := "BA"
		Else
			cTipodoc := "CP"
		Endif
		aTitulosTMP := aClone(aTitulos)
		aTitulos := Array(0)
		aAdd(aTamChav,TamSX3("E5_PREFIXO")[1])
		aAdd(aTamChav,TamSX3("E5_NUMERO")[1])
		aAdd(aTamChav,TamSX3("E5_PARCELA")[1])

		dbSelectArea("SE5")
		SE5->(dbSetOrder(2))
		SE5->(dbSeek(xFilial("SE5") + cTipoDoc + cPrefixo + cNum + cParcela + cTipoTit))
       	While !SE5->(Eof()) .AND. xFilial("SE5") == SE5->E5_FILIAL .AND.	;
			SE5->E5_TIPODOC == cTipoDoc .AND. ;
			SE5->E5_PREFIXO == cPrefixo .AND. ;
			SE5->E5_NUMERO == cNum .AND. ;
			SE5->E5_PARCELA == cParcela 
              
			// se for compensacao gerado no momento da geracao do documento de saida, nao pode ser excluido na compensacao do Fina330.
			#IFDEF TOP
				If lAdtVen
					If aScan(aAdtVen,{|x| x[1] = SE5->E5_DATA .and. ;
					x[2] = SE5->E5_VALOR .and. ;
					x[3] = SE5->E5_CLIFOR .and. ;
					x[4] = SE5->E5_LOJA.and. ;
					x[5] = SE5->E5_SEQ}) > 0
						dbSkip()
						Loop
					Endif
				Endif
			#ENDIF			
	
			If (SE5->E5_MOTBX != "CMP" .Or. SE5->E5_RECPAG != "R")
				dbSkip( )
				Loop
			Endif           
			
			//Verifica se tem baixa cancelada
			If TemBxCanc(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ),.T.)
				SE5->(dbskip())
				Loop
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica Cliente se considerar Cliente Original 			³
			//³ na selecao de titulos 												³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par02 == 1 .and.  SE5->E5_CLIFOR != SE1->E1_CLIENTE
				dbSkip()
				Loop
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica loja caso considere loja na selecao de titulos	  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par01 == 1 .and. mv_par02 == 1 .and.  SE5->E5_LOJA != SE1->E1_LOJA
				dbSkip( )
				Loop
			EndIf
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a baixa e anterior a data do sistema    	  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SE5->E5_DATA >dDatabase
				dbSkip( )
				Loop
			EndIf     
			
			//Lista de tipos de Adiantamento e Notas de Crédito
			cTipos := MV_CRNEG + "," + MVRECANT 
			nT := 0 //Step do nX
			
			For nX := 1 To Len(cTipos)
				
				For nY := nX to Len(cTipos)
					If IsAlpha(SubStr(cTipos,nY,1))
						cTipoAux += SubStr(cTipos,nY,1)
						nT++
					Else
						Exit
					Endif
			Next nY	
				
				If Len(aTipos) == 0 .Or. aScan(aTipos,{|x| x == cTipoAux}) == 0	
					aAdd(aTipos, cTipoAux)  
				Endif
				
				cTipoAux := ""
				nX += nT      
				nT := 0
				
			Next nX
			 
			If !cTipoTit $ cTipos	//Nota fiscal
				//Caso seja uma NF vinculada a uma NCC ou RA
				For nX := 1 to Len(aTipos)
					If aTipos[nX] $ SE5->E5_DOCUMEN
						lVinculo := .T.
						Exit
					Endif 			
				Next nX
				
				If lVinculo
					If aScan(aTitulosTMP,{|x|(AllTrim(x[4]) $ cTipos) .AND. ;		//Tipo
						x[1] == Substr(SE5->E5_DOCUMEN,1,aTamChav[1]) .AND. ;				//Prefixo
						x[2] == Substr(SE5->E5_DOCUMEN,aTamChav[1]+1,aTamChav[2]) .AND. ;	//Numero
						x[3] == Substr(SE5->E5_DOCUMEN,aTamChav[1]+aTamChav[2]+1,aTamChav[3]) .AND. ;	//Parcela
						x[11] == .T.}) == 0												//Selecionado
						SE5->(dbSkip())
						Loop
					Endif
				Endif			
			Else        //Antecipacao
				//Caso o titulo original seja de atencipacao e o tipo do registro atual seja diferente, sair
				If SE5->E5_TIPO # cTipoTit
					SE5->(dbSkip())
					Loop
				Else                         
					//Caso o titulo NF listado nao esteja marcado, ignorar a operacao com a compensacao
					If aScan(aTitulosTMP,{|x| 	x[1] == Substr(SE5->E5_DOCUMEN,1,aTamChav[1]) .AND.;
						 x[2] == Substr(SE5->E5_DOCUMEN,aTamChav[1]+1,aTamChav[2]) .AND.;
						 x[3] == Substr(SE5->E5_DOCUMEN,aTamChav[1]+aTamChav[2]+1,aTamChav[3]) .AND. x[11]==.T.}) == 0
						SE5->(dbSkip())
						Loop
					Endif			
				Endif
			Endif
			nOrdSE1	:= SE1->(IndexOrd())		
			nRegSE1	:= SE1->(Recno())
			nTAbat := SumAbatRec(cPrefixo,cNum,cParcela,SE1->E1_MOEDA,"V",dBaixa)
			SE1->(dbSetOrder(nOrdSE1))
			SE1->(dbGoto(nRegSE1))
			nVlLiqTit:= SE1->E1_VALOR - nTAbat		// Valor do titulo - Abatimentos
			aDtMov	:=	{}
			aDtMov	:= {'','','','','',Dtoc(SE5->E5_DATA)}
			
			aAdd(aTitulos,{SE5->E5_PREFIXO,;
				SE5->E5_NUMERO,;
				SE5->E5_PARCELA,;
				SE5->E5_TIPO,;
				SE5->E5_LOJA,;
				DtoC(SE5->E5_DATA),;
				Substr(SE5->E5_DOCUMEN,1,nTamTit),;
				SE5->E5_SEQ,;
				Transform(nVlLiqTit,"@E 9999,999,999.99"),;
				Transform(SE5->E5_VLMOED2,"@E 9999,999,999.99"),;			
				Iif(Fa330VldDt(aDtMov),.T.,.F.),;
 				    SE1->E1_FILIAL})
			aAdd(aRegistros, SE5->(Recno()))
			SE5->(dbSkip())
		Enddo	
  	
  		IF lF330ExComp
			lF330Exclui := (ExecBlock( "F330EXCOMP", .F., .F.,{aTitulos,aRegistros,nOpc}))
			If lF330Exclui = .F.
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Recupera a Integridade dos dados           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "SE1" )
				dbSetOrder( 1 )
				dbSelectArea( "SE5" )
				dbSetOrder( 1 )
				dbGoTo( nReg )
				DeleteObject(oOk)
				DeleteObject(oNo)
				FA330aUnlock()
				Return			
			Endif
		Endif

		Begin Transaction 

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicializa a gravacao dos lancamentos do SIGAPCO          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PcoIniLan("000016")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Volta o valor aos RAs/NCCs	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE5")
		dbSetOrder( 2 )
		nRegSE1 := SE1->(Recno())
		nValorBaix := 0
		nValBaix2 := 0
		nValCtb	:= 0
		lPadrao := VerPadrao(cPadrao)
		If lPadrao
			lFirst := .T.
		EndIf
		For nLaco := 1 to Len(aRegistros)
			If (aTitulos[nLaco,11])
				lMarcado := .T.
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Caso o titulo esteja selecionado para compensa‡„o...    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( lMarcado )
				lMarcado := .F.
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ So monta o cabecalho do LP se acha pelo menos um³
				//³ registro marcado 										 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lFirst 
					nHdlPrv := HeadProva( cLote,;
					                      "FINA330",;
					                      Substr( cUsuario, 7, 6 ),;
					                      @cArquivo )

					VALOR := 0
					lFirst:= .F.
				EndiF
				dbSelectArea("SE5")
				dbGoTo(aRegistros[nLaco])
				cDocumento	:= SubStr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip)
				cSeq			:= SE5->E5_SEQ
				cCliAdt		:= SE5->E5_FORNADT
				cLojAdt		:= SE5->E5_LOJAADT
				
				//Acrescimos e Decrescimos do titulo principal
				If SE5->E5_VLJUROS > 0
					nTitAcres	+= Round(NoRound(xMoeda(SE5->E5_VLJUROS,1,nMoeda,SE5->E5_DATA,3,,Fa330TxMd(nMoeda,nTxMoeda)),3),2)
				Endif
				If SE5->E5_VLDESCO > 0
					nTitDecre	+= Round(NoRound(xMoeda(SE5->E5_VLDESCO,1,nMoeda,SE5->E5_DATA,3,,Fa330TxMd(nMoeda,nTxMoeda)),3),2)
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Localiza o t¡tulo RA/NCC correspondente			 ³
				//³ Para cancelar a baixa									 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializa a chave de pesquisa com  ³
				//³ a filial padrÆo. Caso seja utilizada³
				//³ compensa‡Æo em outras filiais, ir   ³
				//³ utilizar-se do campo E5_FILORIG.    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cChaveSe1 := xFilial("SE1")+SubStr( SE5->E5_DOCUMEN ,1,nTamTit+nTamTip )
				If !Empty(SE5->E5_FILORIG) .and. !Empty( xFilial( "SE1" ) )
					cChaveSe1 := SE5->E5_FILORIG+SubStr( SE5->E5_DOCUMEN ,1,nTamTit+nTamTip )
				Endif

				aDoctosSE5 := {}
				dbSelectArea("SE1")
				dbSetOrder(1)
				dbSeek(cChaveSe1)
				lAchou := .F.
				// Localiza titulo referente ao cliente correto
				While !Eof() .And. Left(&(IndexKey()), Len(cChaveSe1)) == cChaveSe1
					// Encontrou o titulo do cliente
					If !Empty(cCliAdt) .and. mv_par02 == 1
						If (cCliAdt == SE1->E1_CLIENTE .And. ;
								cLojAdt == SE1->E1_LOJA)
							lAchou := .T.
							Exit
						EndIf
					Else
						lAchou := .T.
						Exit
					Endif	
					DbSkip()
				Enddo

				// Se encontrou o titulo referente ao cliente correto, desfaz a compensacao
				If lAchou
					if lAcAtivo
						//verifica se permite realizar o estorno da compensação do titulo no GE  
						If !AcFinCanc1()
							Exit
						EndIf	
					EndIf
					cAdiantamento := Substr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip)
					cLojaCmp      := If( Empty(Substr(SE5->E5_DOCUMEN,nTamTit+nTamTip+1,nTamLoj)),;
												SE5->E5_LOJA,Substr(SE5->E5_DOCUMEN,nTamTit+nTamTip+1,nTamLoj))

					RecLock("SE1", .F.)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ a Verificacao da moeda ‚ feita para que caso o  ³
					//³ RA tenha moeda diferente do titulo principal, 	 ³
					//³ volte o valor correto ao saldo.               	 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					nSe5Rec := SE5->( RECNO() )
					SE5->( dbSetOrder(7) )
					SE5->( dbSeek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA+cSeq) )
	
					VALOR3 := 0
					VALOR4 := 0
					VALOR5 := 0
					
					If cPaisLoc == "BRA"

						//Se o cancelamento da compensacao NAO partiu do Titulo de Credito				
						If !lCredito
							lIsNcc := SE5->E5_TIPO $ MV_CRNEG
						Else
							// Desfaz comissoes calculadas para adiantamentos ou notas de credito
							If (MV_PAR06 == 1 .And. Substr(SE5->E5_DOCUMEN,nTamTit+1,nTamTip) $ MV_CRNEG) .Or.;
								(MV_PAR13 == 1 .And. Substr(SE5->E5_DOCUMEN,nTamTit+1,nTamTip) $ MVRECANT)
								If cPaisLoc<>"BRA"
									aadd(aBaixas,{{SE5->E5_MOTBX,SE5->E5_SEQ,SE5->(Recno())}})
								else
									aadd(aBaixas,{SE5->E5_MOTBX,SE5->E5_SEQ,SE5->(Recno())})
								Endif
							Endif
						Endif
					
						//Cancelamento partiu de um adiantamento
						If lImpComp .and. lIsNcc .and. lPccBaixa
							nRecnoSE1 := IIF(!lCredito, nRecnoSE1,SE1->(RECNO()))
							//Acerto valor dos impostos - Tecnofibras
							F330ActImp(nRecnoSE1,SE5->E5_VALOR,0,0,.F.,lCredito,0)
						Endif														

						RecLock("SE1", .F.)
						
						//******************************************
						// Caso o titulo esteja totalmente baixado *
						// recupera os impostos para o saldo.      *
						//******************************************
						nTotAbat := 0	
						If lCredito .and. SE1->E1_SALDO==0
							//Tratamento de retorno do Pis Cofins - Tecnofibras
							nTotAbat := SumAbatRec(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_MOEDA,"V",dBaixa)
						EndIf

						If (SE1->E1_MOEDA > 1 .AND. nMoeda == 1) .or. (SE1->E1_MOEDA == 1 .AND. nMoeda > 1) .or. (SE1->E1_MOEDA > 1 .AND. nMoeda > 1) // nMoeda > 1
							SE1->E1_SALDO += SE5->E5_VLMOED2 + nTotAbat 
						Else
							SE1->E1_SALDO += SE5->E5_VALOR + nTotAbat 
						Endif
						nTotAbat := 0	
						//Cancelamento partiu de um adiantamento
						If lCredito

							/////////////////////
							//PCC Baixa CR          to do
							//Retorna para o saldo do titulo o valor retido do PCC
							If cPaisLoc == "BRA" .and. lPccBxCr .and. !lIsNcc
								If EMPTY(SE5->E5_PRETPIS)
									SE1->E1_SALDO += SE5->E5_VRETPIS
									VALOR3 := SE5->E5_VRETPIS
								ENDIF
								If EMPTY(SE5->E5_PRETCOF)
									SE1->E1_SALDO += SE5->E5_VRETCOF
									VALOR4 := SE5->E5_VRETCOF
								Endif
								If EMPTY(SE5->E5_PRETCSL)				
									SE1->E1_SALDO += SE5->E5_VRETCSL
									VALOR5 := SE5->E5_VRETCSL
								Endif								
								//cancelar SFQ
								//Escluir titulos PCC
								FaDelSFQCR()								
							Endif

							If (SE1->E1_VALOR+SE1->E1_ACRESC-SE1->E1_DECRESC) < (SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE)
								SE1->E1_SALDO := SE1->E1_VALOR
							Endif
				
						Endif
						//QUESTAO DE ARREDONDAMENTO
						If ABS(SE1->E1_VALOR - xMoeda(SE5->E5_VLMOED2,nMoeda,SE1->E1_MOEDA,SE5->E5_DATA,3) - (nTotAbat + nDecres - nAcresc)) <= 0.0099999
							SE1->E1_SALDO := SE1->E1_VALOR
						Endif
						SE1->E1_VALLIQ:= 0
					Else
						RecLock("SE1", .F.)
						nDecs := MsDecimais(nMoeda)
						nTxMoeda := Round(SE5->E5_VALOR/SE5->E5_VLMOED2,2)
						If cPaisLoc == "BRA" .or. Empty(SE5->E5_MOEDA)
							SE1->E1_SALDO  += Round(xMoeda(SE5->E5_VLMOED2,nMoeda,SE1->E1_MOEDA,SE5->E5_DATA,nDecs+1,nTxMoeda),nDecs)
							SE1->E1_VALLIQ -= Round(xMoeda(SE5->E5_VLMOED2,nMoeda,1,SE5->E5_DATA,nDecs1+1,nTxMoeda),nDecs1)							
					    Else
					    
					    	If (SE1->E1_MOEDA > 1 .AND. nMoeda == 1) .or. (SE1->E1_MOEDA == 1 .AND. nMoeda > 1) .or. (SE1->E1_MOEDA > 1 .AND. nMoeda > 1) // nMoeda > 1
								SE1->E1_SALDO += SE5->E5_VLMOED2
							Else
								SE1->E1_SALDO += SE5->E5_VALOR
							Endif
					    EndIf
						If cPaisLoc<>"BRA" .And. nMoeda <> SE1->E1_MOEDA   .And.  Abs(SE1->E1_SALDO - SE1->E1_VALOR) <= 0.01
							SE1->E1_SALDO := SE1->E1_VALOR
							SE1->E1_VALLIQ:= 0
						EndIf 						
					EndIf
					se5->( dbGoto(nSE5Rec) )
					If SUBSTR(SE5->E5_LA,1,1) == "S"	
		      			nValCtb += SE5->E5_VALOR
					Endif
					nValorBaix	  += SE5->E5_VALOR + nTitDecre - nTitAcres
					nValBaix2	  += SE5->E5_VLMOED2 + Round(NoRound(xMoeda(SE5->E5_VLDESCO - SE5->E5_VLJUROS,1,nMoeda,SE5->E5_DATA,3,,Fa330TxMd(nMoeda,nTxMoeda)),3),2)

					If lImpComp .and. lPccBaixa
						If !lCredito .and. SE1->E1_SALDO == 0
							nValorBaix	+= SE5->E5_VRETPIS + SE5->E5_VRETCOF + SE5->E5_VRETCSL
							nValBaix2	+= SE5->E5_VRETPIS + SE5->E5_VRETCOF + SE5->E5_VRETCSL
						Endif
					Endif
					MsUnlock()

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Grava lançamento no PCO ref titulo compensado apos canc. da compensacao   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					PCODetLan("000016","02","FINA330") //alteracao do titulo compensado

					nSe1Rec := SE1->(RECNO())
					cKeyAbt := SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)
					//Cancelamento da baixa dos abatimentos do titulo principal
					//quando cancelamento partiu do titulo de adiantamento	
					If lCredito   //Se nao for titulo de adiantamento
						dbSelectArea("__SE1")
						__SE1->(dbSetOrder(2))
						__SE1->(dbSeek(xFilial("SE1")+cKeyAbt))
						While !EOF() .And. E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA==xFilial("SE1")+cKeyAbt
							
							lPccComp := .T. //Verificando IR,INSS e ISS gerados na emissao ou PCC gerado na compensacao.
							If lPccBaixa
								aAreaSE5 	:= SE5->(GetArea()) 
								aAreaSE1		:=	SE1->(GetArea())

								cChaveSE5	:= xFilial("SE5") + If(SE1->E1_TIPO $ "COF/CSL/PIS","CP",Subst(SE1->E1_TITPAI,14,2)) + Subst(SE1->E1_TITPAI,1,3) + Subst(SE1->E1_TITPAI,4,9) +Subst(SE1->E1_TITPAI,13,1)		
								If SE5->(dbSeek(cChaveSE5))
									IF SE1->E1_TIPO $ "IR-/IN-/IS-" .AND. Alltrim(SE1->E1_SEQBX) <> Alltrim(SE5->E5_SEQ)									
						  	  			lPccComp := .F. 
									ElseIf SE1->E1_TIPO $ "COF/CSL/PIS" .AND. lPccBaixa //PCC gerado na compensacao.
										lBxCanc	:= TemBxCanc(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ),.T.)
										If (lBxCanc .AND. Alltrim(SE1->E1_SEQBX) == Alltrim(SE5->E5_SEQ)) .OR. (!lBxCanc .AND. Alltrim(SE1->E1_SEQBX) <> Alltrim(SE5->E5_SEQ))
							 				lPccComp := .F.							
							 			Endif	
									Endif
								Endif
									
								SE5->(RestArea(aAreaSE5))
								SE1->(RestArea(aAreaSE1))
							Endif							
							
							If (((E1_TIPO $ "COF/CSL/PIS/IR-/IN-/IS-/CF-/CS-/PI-/" .AND. lPccBaixa .AND. lPccComp) .OR. E1_TIPO $ MVABATIM ) .And. Alltrim(cCliente+cLoja) == Alltrim(SE1->E1_CLIENTE+SE1->E1_LOJA) ) 							
								//Tornar o abatimento aberto novamente somente caso o abatimento tenha sido baixado pela rotina
								If __SE1->(FieldPos("E1_TITPAI")) # 0
									If Empty(E1_TITPAI) .OR. (MV_CRNEG $ E1_TITPAI .OR. MVRECANT $ E1_TITPAI)
										lOkTitAb := .T.
									Else 
										lOkTitAb := .F.
									Endif
								Else 
									lOkTitAb := .T.
								Endif
								If lOkTitAb								
									nVlrAbat += E1_VALOR
									RecLock("__SE1")
									Replace E1_SALDO	With E1_VALOR
									Replace E1_BAIXA	With CtoD("  /  /  ")
									Replace E1_STATUS	With "A"
									Replace E1_VALLIQ  With 0               
									If __SE1->(FieldPos("E1_TITPAI")) # 0
										Replace E1_TITPAI	With ""
									Endif                         
									MsUnlock()
								Endif									
							Endif
							dbSkip()
						Enddo
						__SE1->(dbSetOrder(1))
					Endif
					If lAcAtivo
						//Realiza a consequencia do cancelamento da baixa do titulo no GE
						AcFinCanc2()
					EndIf
					dbSelectArea("SE1")
					dbGoto(nSE1Rec)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Deleta a baixa do SE5	-  RA		³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SE5")
					dbSetOrder(2)
					
					If (dbSeek(xFilial()+cTipodc+cDocumento))
						While ( 	!Eof() .And. SE5->E5_FILIAL == xFilial("SE5") .And. ;
								cDocumento ==	SE5->E5_PREFIXO+SE5->E5_NUMERO+;
								SE5->E5_PARCELA+SE5->E5_TIPO )
							If (  cSeq == SE5->E5_SEQ .And. cLojaCmp == SE1->E1_LOJA .And. ;
									SE1->E1_CLIENTE == SE5->E5_CLIFOR .and. ;
									Substr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip)==cPrefixo+cNum+cParcela+cTipoTit )
								AADD(aDoctosSE5,{SE5->E5_DOCUMEN,SE1->E1_CLIENTE,SE1->E1_LOJA,SE5->E5_SEQ})

								//Atualiza dados do Cliente - Adiantamento
								dbSelectArea("SA1")
								DbSetOrder(1)
								If dbSeek(xFilial("SA1")+SE5->E5_CLIFOR+SE5->E5_LOJA)
									RecLock("SA1")
									nSaldoComp:=Round(xMoeda(SE5->E5_VLMOED2,nMoeda,SE1->E1_MOEDA,SE5->E5_DATA,nDecs+1,Fa330TxMd(nMoeda,nTxMoeda),Fa330TxMd(SE1->E1_MOEDA,nTxMoeda)),nDecs)
									If SE1->E1_TIPO $ MVRECANT +"/"+ MV_CRNEG
										AtuSalDup("-",nSaldoComp,nMoeda,SE1->E1_TIPO,,SE1->E1_EMISSAO)
									Else
						   		   AtuSalDup("+",nSaldoComp,nMoeda,SE1->E1_TIPO,,SE1->E1_EMISSAO)
		   							EndIf
								EndIf
								
								//Dados do titulo de adiantamento
								dbSelectArea("SE1")
								dbGoto(nSE1Rec)
								RecLock("SE1")
								nAcresc := Round(NoRound(xMoeda(SE5->E5_VLJUROS,1,SE1->E1_MOEDA,SE5->E5_DATA,3,,Fa330TxMd(SE1->E1_MOEDA,nTxMoeda)),3),2)
								nDecres := Round(NoRound(xMoeda(SE5->E5_VLDESCO,1,SE1->E1_MOEDA,SE5->E5_DATA,3,,Fa330TxMd(SE1->E1_MOEDA,nTxMoeda)),3),2)
								SE1->E1_SALDO += nDecres - nAcresc
								//QUESTAO DE ARREDONDAMENTO
								If ABS(SE1->E1_VALOR - xMoeda(SE5->E5_VLMOED2,nMoeda,SE1->E1_MOEDA,SE5->E5_DATA,3) - (nTotAbat + nDecres - nAcresc)) <= 0.0099999
									SE1->E1_SALDO := SE1->E1_VALOR
								Endif
								SE1->E1_STATUS:= IIF(SE1->E1_STATUS != "R",Iif(SE1->E1_SALDO > 0.01,"A","B"),"R")
								SE1->E1_SDACRES += nAcresc
								SE1->E1_SDDECRE += nDecres					
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ So limpa a data da baixa se nao houver mais 	 ³
								//³ nenhum movimento para este titulo					 ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If NoRound( SE1->E1_VALOR, 2 ) == NoRound( SE1->E1_SALDO, 2 )
									SE1->E1_BAIXA := CtoD("  /  /  ")
								EndIf
								MsUnlock()			

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Integracao Protheus X RM Classis Net (RM Sistemas)³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								if GetNewPar("MV_RMCLASS", .F.) .or. GetNewPar("MV_RMBIBLI",.F.)
									if alltrim(upper(SE1->E1_ORIGEM)) == 'L' .or. alltrim(upper(SE1->E1_ORIGEM)) == 'S' .or. SE1->E1_IDLAN > 0
										//Executa funcao para replicar manutencao nas tabelas do CorporeRM
										ClsProcCan(SE1->(Recno()),'1',"FIN330")
									endif		
								endif
				
								If nOpc == 4  //Exclusao
									Reclock("SE5")
									dbDelete()
									MsUnlock()
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Grava lançamento no PCO ref canc. baixa do titulo compensado (Mov.Bancaria-SE5) ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									PCODetLan("000016","06","FINA330")

								Else
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Obtem os dados do registro tipo RA para gerar um	  ³
									//³ registro de estorno 										  ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									aSE5 := {}
									dbSetOrder( 1 )
									For nX := 1 to SE5->( Fcount() )
										AAdd( aSE5, SE5->( FieldGet(nX) ) )
									NEXT
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Grava o registro de estorno                     	  ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									RecLock("SE5" ,.T.)
									For nX := 1 to SE5->(Fcount())
										SE5->( FieldPut( nX,aSE5[nX]))
									Next
									SE5->E5_TIPODOC := "ES"
									SE5->E5_RECPAG  := "P"
									SE5->E5_HISTOR	 := STR0055 //"Cancel. de Compensacao"
									SE5->E5_DATA    := dDatabase
									SE5->E5_DTDIGIT := dDataBase
									SE5->E5_DTDISPO := dDataBase

									If MV_PAR09 == 2
										If lUsaFlag
											aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
										Else
											SE5->E5_LA	:= "N"
										EndIf
									EndIf
									
  							  		If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
										SE5->E5_NODIA := ""
							 		EndIf	
	 								MsUnlock()
	 								
	 								If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
				 						AAdd(aDiario,{"SE5",SE5->(Recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"})
				  					EndIf	
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Grava lançamento no PCO ref canc. baixa do titulo compensado (Mov.Bancaria-SE5) ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									PCODetLan("000016","06","FINA330")
								Endif
							EndIF
							dbSkip()
						EndDo
					Endif
					DbSelectArea("SE1")
					DbSetOrder(1)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Restaura o t¡tulo abatimento qdo houver    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If dbSeek(xFilial("SE1")+cPrefixo+cNum+cParcela,.F.)
						While (xFilial("SE1")+cPrefixo+cNum+cParcela ==;
								SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA ) .OR.;
								(Alltrim(SE1->E1_TITPAI) == Alltrim(cChavePai))								
							
							lPccComp := .T. //Verificando IR,INSS e ISS gerados na emissao ou PCC gerado na compensacao.
							If lPccBaixa
								aAreaSE5 	:= SE5->(GetArea()) 
								aAreaSE1		:=	SE1->(GetArea())

								cChaveSE5	:= xFilial("SE5") + If(SE1->E1_TIPO $ "COF/CSL/PIS","CP",Subst(SE1->E1_TITPAI,14,2)) + Subst(SE1->E1_TITPAI,1,3) + Subst(SE1->E1_TITPAI,4,9) +Subst(SE1->E1_TITPAI,13,1)		
								If SE5->(dbSeek(cChaveSE5))
									IF SE1->E1_TIPO $ "IR-/IN-/IS-" .AND. Alltrim(SE1->E1_SEQBX) <> Alltrim(SE5->E5_SEQ)
						  	  			lPccComp := .F.
									ElseIf SE1->E1_TIPO $ "COF/CSL/PIS" .AND. lPccBaixa //PCC gerado na compensacao.
										lBxCanc	:= TemBxCanc(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ),.T.)
										If (lBxCanc .AND. Alltrim(SE1->E1_SEQBX) == Alltrim(SE5->E5_SEQ)) .OR. (!lBxCanc .AND. Alltrim(SE1->E1_SEQBX) <> Alltrim(SE5->E5_SEQ))
							 				lPccComp := .F.							
							 			Endif	
									Endif
								Endif	
								
								SE5->(RestArea(aAreaSE5))
								SE1->(RestArea(aAreaSE1))
							Endif							
							
							If (((SE1->E1_TIPO $ "COF/CSL/PIS/IR-/IN-/IS-/CF-/CS-/PI-/" .AND. lPccBaixa .AND. lPccComp) .OR. E1_TIPO $ MVABATIM ) .And. Alltrim(cCliente+cLoja) == Alltrim(SE1->E1_CLIENTE+SE1->E1_LOJA) ) 
								//Tornar o abatimento aberto novamente somente caso o abatimento tenha sido baixado pela rotina
								If SE1->(FieldPos("E1_TITPAI")) # 0
										If Empty(SE1->E1_TITPAI) .OR. (MV_CRNEG $ SE1->E1_TITPAI .OR. MVRECANT $ SE1->E1_TITPAI) .OR.;
											(!Empty(SE1->E1_TITPAI) .AND. Alltrim(SE1->E1_TITPAI) == Alltrim(cChavePai)) 																				
										lOkTitAb := .T.
									Else 
										lOkTitAb := .F.
									Endif
								Else 
									lOkTitAb := .T.
								Endif
								If lOkTitAb									
										//Caso os impostos do PCC sejam gerados na baixa devo exclui-los.
										If SE1->E1_TIPO $ ("COF/CSL/PIS") .AND. lPccBxCr
											RecLock("SE1")
											dbDelete()
											MsUnlock()									
										Else
									RecLock("SE1")
									SE1->E1_SALDO := SE1->E1_VALOR
									SE1->E1_VALLIQ:= 0
									If NoRound( SE1->E1_VALOR, 2 ) == NoRound( SE1->E1_SALDO, 2 )
										SE1->E1_BAIXA := CtoD("  /  /  ")
										nVlrAbat += SE1->E1_VALOR
									Else
										nVlrAbat += SE1->E1_VALOR-SE1->E1_SALDO
									EndIf
									SE1->E1_STATUS:= Iif(SE1->E1_SALDO>0.01,"A","B")
									If SE1->(FieldPos("E1_TITPAI")) # 0
										SE1->E1_TITPAI:= ""
									Endif
									MsUnlock()									
								Endif									
							EndIf
							EndIf
							dbSelectArea("SE1")
							dbSkip()
						EndDo
					Endif
				Else				
					Exit				
				EndIf
				
				dbSelectArea("SE1")
				dbGoto(nSE1Rec)
				
				dbSelectArea("SE5")
				dbGoTo(aRegistros[nLaco])
				// Desfaz comissoes calculadas para adiantamentos ou notas de credito
				If (MV_PAR06 == 1 .And. Substr(SE5->E5_DOCUMEN,nTamTit+1,nTamTip) $ MV_CRNEG) .Or.;
					(MV_PAR13 == 1 .And. Substr(SE5->E5_DOCUMEN,nTamTit+1,nTamTip) $ MVRECANT)
					If cPaisLoc<>"BRA"
						aadd(aBaixas,{{SE5->E5_MOTBX,SE5->E5_SEQ,SE5->(Recno())}})
					else
						aadd(aBaixas,{SE5->E5_MOTBX,SE5->E5_SEQ,SE5->(Recno())})
					Endif
				Endif
				
				IF lPadrao .and. SUBSTR(SE5->E5_LA,1,1) == "S"	
					nTotal += DetProva( nHdlPrv,;
					                    cPadrao,;
					                    "FINA330",;
					                    cLote,;
					                    /*nLinha*/,;
					                    /*lExecuta*/,;
					                    /*cCriterio*/,;
					                    /*lRateio*/,;
					                    /*cChaveBusca*/,;
					                    /*aCT5*/,;
					                    /*lPosiciona*/,;
					                    @aFlagCTB,;
					                    /*aTabRecOri*/,;
					                    /*aDadosProva*/ )
				EndIF
		 	 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³  Apaga registro da movimenta‡„o  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SE5")
				Reclock("SE5",.F.,.T.)
				If lACAtivo
					If E5_TIPO == "NCC"
						ACFina070(aTitulos[1][1], aTitulos[1][2], aTitulos[1][3], aTitulos[1][4]) // Realiza as consequencias de uma baixa de titulo com o modulo Gestao Educacional ativo.
					EndIf
				EndIf
				If E5_TIPO == "NF "
					AADD(aDoctosSE5,{SE5->E5_DOCUMEN,SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_SEQ})		
				EndIf	

				/////////////////////
				//PCC Baixa CR    
				//Obtem valor dos impostos PCC retidos na compensacao
				If cPaisLoc == "BRA" .and. lPccBxCr .and. !lIsNcc .and. !lCredito 
					If EMPTY(SE5->E5_PRETPIS)
						nPis += SE5->E5_VRETPIS
					ENDIF
					If EMPTY(SE5->E5_PRETCOF)
						nCofins += SE5->E5_VRETCOF
					Endif
					If EMPTY(SE5->E5_PRETCSL)				
						nCsll += SE5->E5_VRETCSL
					Endif								
					//Excluir relacionamentos SFP
					//Exclui titulos gerados
					FaDelSFQCR()
				Endif
	
				If nOpc == 4  //Exclusao				
					Reclock("SE5",.F.,.T.)
					dbDelete()
					MsUnlock()
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Grava lançamento no PCO ref baixa (Mov.Bancaria-SE5) do titulo principal apos canc.da compensacao³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					PCODetLan("000016","05","FINA330")
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Obtem os dados do registro tipo RA para gerar um	  ³
					//³ registro de estorno 										  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aSE5 := {}
					dbSetOrder( 1 )
					For nX := 1 to SE5->( Fcount() )
						AAdd( aSE5, SE5->( FieldGet(nX) ) )
					NEXT
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Grava o registro de estorno                     	  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					RecLock("SE5" ,.T.)
					For nX := 1 to SE5->(Fcount())
						SE5->( FieldPut( nX,aSE5[nX]))
					Next
					SE5->E5_TIPODOC := "ES"
					SE5->E5_RECPAG  := "P"
					SE5->E5_HISTOR	 := STR0055 //"Cancel. de Compensacao"
					SE5->E5_DATA    := dDatabase
					SE5->E5_DTDIGIT := dDataBase
					SE5->E5_DTDISPO := dDataBase
					If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
 						SE5->E5_NODIA := ""
  					EndIf	
					MsUnlock()
					If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
 						AAdd(aDiario,{"SE5",SE5->(Recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"})
  					EndIf	                
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            		//³ PONTO DE ENTRADA NA ALTERACAO DO HISTORICO NA SE5 NO ESTORNO         ³
            		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            		If ExistBlock( "F330AE5E" )             		    
            		   ExecBlock("F330AE5E",.F.,.F.)
               		EndIf
										
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Grava lançamento no PCO ref baixa (Mov.Bancaria-SE5) do titulo principal apos canc.da compensacao³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					PCODetLan("000016","05","FINA330")
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ PONTO DE ENTRADA DE VALIDACAO DE EXCLUSAO/ESTORNO ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            	If ExistBlock( "F330VEEX" )             		    
                   ExecBlock("F330VEEX",.F.,.F.,{nOpc})
                EndIf
								
				lCancelou := .T.
			Endif
		Next nLaco
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se foi gerado comiss„o e caso tenha sido, exclui     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc<>"BRA"
			AeVal(aBaixas,{|x|Fa440DeleB(x,.F.,.F.,"FINA330")})
		Else
			Fa440DeleB(aBaixas,.F.,.F.,"FINA330")	
		EndIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ PONTO DE ENTRADA NA EXCLUSAO ANTES DA CONTABILIZACAO         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (ExistBlock( "FA330EAC" ) )
			ExecBlock("FA330EAC",.F.,.F.)
		EndIf
		If lPadrao .and. lCancelou .and. !lFirst .and. nValCtb > 0
			VALOR := nValCtb
			VALOR3 := nPis
			VALOR4 := nCofins
			VALOR5 := nCsll

			dbSelectArea("SE1")
			dbGoBottom()
			dbSkip()
			dbSelectArea("SE5")
			dbGoBottom()
			dbSkip()
			nTotal += DetProva( nHdlPrv,;
			                    cPadrao,;
			                    "FINA330",;
			                    cLote,;
			                    /*nLinha*/,;
			                    /*lExecuta*/,;
			                    /*cCriterio*/,;
			                    /*lRateio*/,;
			                    /*cChaveBusca*/,;
			                    /*aCT5*/,;
			                    /*lPosiciona*/,;
			                    @aFlagCTB,;
			                    /*aTabRecOri*/,;
			                    /*aDadosProva*/ )

			RodaProva(  nHdlPrv,;
						nTotal)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para Lan‡amento Cont bil							  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lDigita := IIF( mv_par07 == 1,.t., .f. )
			cA100Incl( cArquivo,;
			           nHdlPrv,;
			           3,;
			           cLote,;
			           lDigita,;
			           .F.,;
			           /*cOnLine*/,;
			           /*dData*/,;
			           /*dReproc*/,;
			           @aFlagCTB,;
			           /*aDadosProva*/,;
			           aDiario )
			aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento

			dbSelectArea("SE1")
			dbGoTo(nRegSE1)
			dbSelectArea("SE5")
			dbGoTo(nRegSE5)
		EndiF	
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Volta valor do titulo.			³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nValorBaix # 0 .or. nTitDecre # 0 .or. nTitAcres # 0 
			SE5->(dbGoTo(nRegSE5))
			SE1->(dbGoTo(nRegSE1))
			Reclock("SE1")
			SE1->E1_SALDO  += nValBaix2 
			SE1->E1_SALDO  += Iif(mv_par08==1,nVlrAbat,0)
			SE1->E1_VALLIQ := 0
			SE1->E1_SDDECRE += nTitDecre
			SE1->E1_SDACRES += nTitAcres
			nTotAbat := SumAbatRec(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_MOEDA,"V",dBaixa)
			If STR(SE1->(E1_VALOR - E1_SALDO),17,2) == STR(nTotAbat,17,2)
				SE1->E1_SALDO += nTotAbat
			Endif

			/////////////////////
			//PCC Baixa CR          
			//Retorna para o saldo do titulo o valor retido do PCC
			If lPccBaixa .and. !lIsNcc .and. !lCredito
				SE1->E1_SALDO += nPis+nCofins+nCsll
			Endif
			SE1->E1_STATUS:= IIF(SE1->E1_STATUS != "R",Iif(SE1->E1_SALDO > 0.01,"A","B"),"R")
			If SE1->E1_SALDO > SE1->E1_VALOR		// garantir que o saldo nao seja maior
				Replace E1_SALDO With E1_VALOR
			Endif
			If NoRound( SE1->E1_VALOR, 2 ) == NoRound( SE1->E1_SALDO, 2 )
				SE1->E1_BAIXA := CtoD("  /  /  ")
			EndIf

			MsUnlock()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Integracao Protheus X RM Classis Net (RM Sistemas)³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			if GetNewPar("MV_RMCLASS", .F.) .or. GetNewPar("MV_RMBIBLI",.F.)
				dbSelectArea("SE5")
				aAreaSE5 := SE5->(GetArea())
				for nLaco:=1 to len(aRegistros)
					dbSelectArea("SE5")
					dbGoTo(aRegistros[nLaco])					

					if alltrim(upper(SE1->E1_ORIGEM)) == 'L' .or. alltrim(upper(SE1->E1_ORIGEM)) == 'S'
					    //Executa a funcao que replica o cancelamento para as tabelas do CorporeRM
						ClsProcCan(SE1->(Recno()),'1',"FIN330")
					endif
				next nLaco
				RestArea(aAreaSE5)
				dbSelectArea("SE1")
			endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava lançamento no PCO ref titulo principal apos a cancelamento   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PCODetLan("000016","01","FINA330")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza Saldo do Cliente /  DP/NF  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aArea:=GetArea()
			dbSelectArea("SA1")
			DbSetOrder(1)
			If dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
				RecLock("SA1")
				nSaldoComp:=Round(xMoeda(nValBaix2,nMoeda,SE1->E1_MOEDA,SE5->E5_DATA,nDecs+1,Fa330TxMd(nMoeda,nTxMoeda),Fa330TxMd(SE1->E1_MOEDA,nTxMoeda)),nDecs)
				If lCredito  
					AtuSalDup("-",nSaldoComp,nMoeda,SE1->E1_TIPO,,SE1->E1_EMISSAO)
				Else
	   		   AtuSalDup("+",nSaldoComp,nMoeda,SE1->E1_TIPO,,SE1->E1_EMISSAO)
  				EndIf
				MsUnlock()
			EndIf
			RestArea(aArea)
			SE1->(dbGoTo(nRegSE1))
		
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ PONTO DE ENTRADA 															 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (ExistBlock( "FA330EXC" ) )
			ExecBlock("FA330EXC",.F.,.F.)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Finaliza a gravacao dos lancamentos do SIGAPCO            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PcoFinLan("000016")		              

		End Transaction		
		Exit
	Endif
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura o valor da l330Auto para False³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
l330Auto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SE1" )
dbSetOrder( 1 )
dbSelectArea( "SE5" )
dbSetOrder( 1 )
dbGoTo( nReg )
DeleteObject(oOk)
DeleteObject(oNo)
FA330aUnlock()
Return lRetAuto
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa330Marca³ Autor ³ Alice Y Yamamoto 	  ³ Data ³ 08/04/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marca os itens a serem excluidos 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa330Marca																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function fa330Marca(nIt,aArray)

If (aArray[nIt,11] )
	aArray[nIt,11] := .F.
Else
	If Fa330VldDt(aArray[nIt])
		aArray[nIt,11] := .T.
	Endif
Endif

Return aArray


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa330OK	³ Autor ³ Marcos Patricio		  ³ Data ³ 19/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Confirma a marcacao dos titulos para compensacao.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa330OK																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA330OK()
Local lMarcado := .T.,nX
Local lRet	:=	.F.
//Quando chamada da MATA465 se nao existe nada marcado da erro
If cPaisLoc <> "BRA"
	lMarcado	:=	.F.
	For nX	:=1 	To Len(aTitulos)
		If aTitulos[nX][8]
			//Forcar a saida do FOR
			lMarcado	:=	.T.
			nX	:=	Len(aTitulos)+1
		Endif	
	Next
Endif
If lMarcado
	lRet	:=	MsgYesNo(STR0024,STR0018)
Else
	MsgAlert(STR0040,STR0018)
	lRet	:=	.F.
Endif

If ExistBlock("Fa330Vld") .and. lRet
	lRet := ExecBlock("Fa330Vld")
EndIf

If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() ) 
	If !CTBvldDiario(cCodDiario,dDataBase)
		Return(.f.)
	EndIf
EndIf


Return lRet  //"Confirma marca‡„o de T¡tulos ?"###"Aten‡„o"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa330Troca³ Autor ³ Marcos Patricio		³ Data ³ 19/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Troca o flag para marcado ou nao,aceitando valor.		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa330Troca												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA330Troca(nIt,aArray,oGet,lTodos)

Local oDlg
Local nOpca 	:= 0
Local nX := 0
Local nAcresc := 0
Local nY			:= 0
Local nVezes	:= 1
Local nOldIt	:= nIt

DEFAULT lTodos := .F.

cValor  := Fa330VTit(aTitulos[nIt,6])
cSaldo  := Fa330VTit(aTitulos[nIt,6])
nVezes  := If(lTodos,Len(aArray),1)

If cPaisLoc == "BRA"
	If mv_par02 == 1
		nAcresc := Fa330VTit(aTitulos[nIt,10])
	Else
		nAcresc := Fa330VTit(aTitulos[nIt,13])
	Endif					
Else
	If mv_par02 == 1
		nAcresc := Fa330VTit(aTitulos[nIt,11])
	Else
		nAcresc := Fa330VTit(aTitulos[nIt,13])
	Endif					
Endif

nValtot := 0

For nY := 1 to nVezes

	If nVezes > 1
		nIt := nY
		cValor  := Fa330VTit(aTitulos[nIt,6])
		cSaldo  := Fa330VTit(aTitulos[nIt,6])
	Endif
	
	aArray[nIt,8] := !aArray[nIt,8]
	
	If aArray[nIt,8]
		
		If FA330Lock(aArray[nIt,1]+aArray[nIt,2]+aArray[nIt,3]+aArray[nIt,4],,,aArray[nIt,Iif(MV_PAR02== 2, 16,13)])
	
			If !lTodos		
				DEFINE MSDIALOG oDlg FROM  69,70 TO 160,331 TITLE STR0048 PIXEL //"Compensa‡„o CR"
				
				@ -3, 2 TO 22, 128 OF oDlg	PIXEL
				@ 7, 68 MSGET cValor Picture "@E 9999,999,999.99" VALID cValor <= cSaldo .and. cValor > 0 .and. cValor >= nAcresc  SIZE 54, 10 OF oDlg PIXEL hasbutton
				@ 8, 9 SAY STR0014  SIZE 54, 7 OF oDlg PIXEL  //"Valor a compensar"
		
				DEFINE SBUTTON FROM 29, 71 TYPE 1 ENABLE ACTION (nOpca:=1,If((cValor <= cSaldo .AND. cValor > 0 .AND. cValor >= nAcresc ),oDLg:End(),nOpca:=0)) OF oDlg
				DEFINE SBUTTON FROM 29, 99 TYPE 2 ENABLE ACTION (aArray[nIt,8]:=.F.,oDlg:End()) OF oDlg
				
				ACTIVATE MSDIALOG oDlg
			Else
				nOpca := 1
			Endif
						
			IF	nOpca == 1
				//Pcc Baixa CR
				//Caso a compensacao tenha partido de um Adiantamento
				If lCredito .And. (SE1->E1_TIPO <> MV_CRNEG)
					F330CalcPCC(nIt,aArray,@cValor)
				Endif
				aArray[nIt,7]:=Transf(cValor,"@E 9999,999,999.99")
				If cPaisLoc == "BRA"
					aArray[nIt,9] := cValor
				Endif
			Endif
	    Else
			aArray[nIt,8] := !aArray[nIt,8]	
		Endif
	Else
		If  !aArray[nIt,8]
			aArray[nIt,7]:=Transf(0,"@E 9999,999,999.99")
			If cPaisLoc == "BRA"
				aArray[nIt,9] := 0
				If lCredito
					F330CalcPCC(nIt,aArray,@cValor)
				Endif		
			Endif			
		Endif
	
		FA330UnLock(aArray[nIt,1]+aArray[nIt,2]+aArray[nIt,3]+aArray[nIt,4],,aArray[nIt,Iif(MV_PAR02== 2, 16,13)])
	
	Endif
Next
	
For nX:=1 to Len(aArray)
	If	aArray[nX,8]
		nValtot+=Fa330VTit(aArray[nX,7])
	Endif
Next

nIt := nOldIt

If oGet != Nil
	oGet:Refresh()
Endif
Return aArray

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa330SetMo³ Autor ³ Fernando Machima      ³ Data ³ 19/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Tela de taxas de moedas                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa330SetMo												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function Fa330SetMo()
Local oDlg
Local nLenMoedas	:= Len(aTxMoedas)
Local nI            := 1
Local nLinTelaF  							//altura da tela de fora
Local nLinTelaD								// altura da tela de dentro	     
Local nLinButton
Local aSay := {}
Local aGet := {}
Local cBlKMoeda    

nLinTelaD	:=  05 + ((nLenMoedas-1) * 16)			// altura da tela de dentro	-> 14-tamanho de cada linha -> 5-sobra em cima e em baixo    
nLinTelaF  	:= 200 + ((nLenMoedas-1) * 30.5) + 50	// altura da tela de fora -> 200-onde comecou a tela -> 30,5-equivalente por linha -> 35-botao e sobras da tela 

nLinButton  :=  03 + nLinTelaD

If nLenMoedas > 1
	DEFINE MSDIALOG oDlg From 200,0 TO nLinTelaF,230 TITLE STR0037 PIXEL  //Taxas Moedas			
		@ 005,005  To nLinTelaD,110 OF oDlg PIXEL

		For nI := 1 To nLenMoedas-1              
			cBlKMoeda := "{|| aTxMoedas["+AllTrim(Str(ni+1))+",1]}"
			aAdd(aSay, TSay():New(1+(ni*12),010,&cBlKMoeda,oDlg,,, .F., .F., .T.,.T.,,,,, .F., .F., .F., .F.)) 
		    aAdd(aGet, TGet():New((ni*12)-2,060,&("{|x| If(x <> NIL,aTxMoedas["+AllTRim(Str(ni+1))+",2] := x,aTxMoedas["+Str(ni+1)+",2])}"),oDlg,45,,aTxMoedas[nI+1,3],,,,,,,.T.,,,,.F.,.T.,,.F.,.F.,,,,.F.,,.T.))
		Next nI
				
	DEFINE  SButton FROM (nLinTelaD + 5),80 TYPE 1 Action (oDlg:End() ) ENABLE OF oDlg  PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	Help("",1,"NoMoneda")
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³Fa330TudOkºAutor  ³Claudio D. de Souza º Data ³  29/11/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validar os campos informados na compensacao                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Fina330                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa330TudOk
Local lRet := .T.

Do Case
Case EMPTY(cNum)
	lRet := .F.
Case !fa330Cli()
	lRet := .F.
Case !Fa330Loja()
	lRet := .F.
Case !(nValor >= 0 .AND. STR(nValor,17,2) <= STR(nSaldo,17,2))
	lRet := .F.
Case !(dBaixa >= SE1->E1_EMISSAO)
	lRet := .F.
Case !lCredito
	If Empty(cTipoTit) .Or.	!(!cTipoTit $ MVABATIM .AND. 	!(cTipoTit $ MVRECANT+"/"+MV_CRNEG))
		lRet := .F.
	Endif	
Case lCredito
	If Empty(cTipoTit) .Or. !(!cTipoTit $ MVABATIM .AND. (cTipoTit $ MVRECANT+"/"+MV_CRNEG))
		lRet := .F.
	Endif	

EndCase	

//Possibilita novas validacoes
If ExistBlock("F300VALID")
	lRet := ExecBlock	("F300VALID",.F.,.F.)
EndIf

REturn lRet


Static Function fMarkAll(aTit, nValor)

Local nI := 0
Local bReturn:=.T.

If Len(aTit) > 0
	For nI := 1 to Len(aTit)
		If aTit[nI][8] == .F.
			bReturn:=.F.
		EndIf
	Next
EndIf

nValTot := 0
aEval(@aTit, {|e| e[8] := !bReturn, If(e[8],(If(Fa330VTit(e[7])=0,e[7]:=e[6],Nil),nValTot += Fa330VTit(e[7]), Iif(cPaisLoc=="BRA",e[9]:=DesTrans(e[7]),e[11]:=DesTrans(e[7]))),(e[7]:=Transf(0,"@E 9999,999,999.99"), Iif(cPaisloc=="BRA",e[9]:=e[7],e[11]:=e[7]) ))})

Return bReturn


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fa330Leg   ³ Autor ³ Mauricio Pequim Jr   ³ Data ³ 20.07.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria uma janela contendo a legenda da mBrowse              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function Fa330Leg(nReg)
Local uRetorno := .T.
Local aLegenda := {	{"ENABLE"		, 	STR0051	},; //"Titulo nao Compensado"
				   	{"DISABLE"		, 	STR0052	},; //"Titulo Compensado Totalmente"
					{"BR_AZUL"		,  STR0053	}} //"Titulo Compensado Parcialmente"


If nReg = Nil	// Chamada direta da funcao onde nao passa, via menu Recno eh passado
	uRetorno := {}
	Aadd(uRetorno, {'E1_SALDO =  0', aLegenda[2][1]})			// Titulo Compensado Totalmente 
	Aadd(uRetorno, {'E1_SALDO =  E1_VALOR', aLegenda[1][1]}) // Titulo nao Compensado
	Aadd(uRetorno, {'E1_SALDO <> 0', aLegenda[3][1]})			// Titulo Compensado Parcialmente
Else
	BrwLegenda(cCadastro,STR0047,aLegenda)  //"Legenda"
Endif

Return uRetorno

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PesqListBox³ Autor ³ Edson Maricate       ³ Data ³ 09.02.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta uma pesquisa de texto em um listBox.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Geral                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function PesqListBox(oListBox,aListBox)

Local nFound
Local aParam	:= {}

PRIVATE mv_par01 // Declara as variaveis private para não conflitar com as variaveis da pergunte
PRIVATE mv_par02
PRIVATE mv_par03

If ParamBox( { { 1,STR0001 ,Padr(__PesqList,200),"@" 	 ,""  ,""    ,"" ,120 ,.T. },;
				{5,STR0056,.F.,90,,.F.},;
				{5,STR0057,.F.,90,,.F.} }, STR0001 , aParam, , , , , , , , .F. )

	__PesqList := aParam[1]
	If aParam[2]
		If aParam[3]
			nFound := aScan(aListBox,{|x| aScan(x,{|x| AllTrim(aParam[1])$AllTrim(x) } )>0 },oListBox:nAt+1)
		Else
			nFound := aScan(aListBox,{|x| aScan(x,{|x| AllTrim(aParam[1])$AllTrim(x) } )>0 })
		EndIf
	Else
		If aParam[3]
			nFound := aScan(aListBox,{|x| aScan(x,{|x| UPPER(AllTrim(aParam[1]))$UPPER(AllTrim(x)) } )>0 },oListBox:nAt+1)
		Else
			nFound := aScan(aListBox,{|x| aScan(x,{|x| UPPER(AllTrim(aParam[1]))$UPPER(AllTrim(x)) } )>0 })
		EndIf
	EndIf
	If nFound <= 0
		Aviso(STR0058, STR0059,{"Ok"},2) 
	Else
		oListBox:nAt := nFound
		oListBox:Refresh()
	EndIf
	
EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fa330IntPco ºAutor ³Paulo Carnelossi    º Data ³  22/11/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³funcao que gera os lancamentos no sigapco (PcoDetLan())     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Fa330IntPco(nRecSE1, aRecnoSE1, aBaixasSE5)
Local aArea := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local aAreaSE5 := SE5->(GetArea())
Local nX

If SuperGetMV("MV_PCOINTE",.F.,"2")=="1"

	dbSelectArea("SE1")
	dbGoto(nRecSE1) //titulo principal apos a compensacao
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava lançamento no PCO ref titulo principal apos a compensacao    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PCODetLan("000016","01","FINA330")
	
	For nX := 1 TO Len(aRecnoSE1) // ARRAY COM REGISTROS TITULOS COMPENSADOS
	
		//grava lcto ref. titulo compensado
		dbSelectArea("SE1")	
		dbGoto(aRecnoSE1[nX])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava lançamento no PCO ref titulo compensado apos a compensacao   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PCODetLan("000016","02","FINA330")
	
		//grava lctos das baixas referente titulo principal e titulo compensado
		dbSelectArea("SE5")
		
		dbGoto(aBaixasSE5[(nX*2)-1])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava lançamento no PCO ref baixa (Mov.Bancaria-SE5) do titulo principal apos a compensacao   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PCODetLan("000016","03","FINA330")
	
		dbGoto(aBaixasSE5[(nX*2)])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava lançamento no PCO ref baixa do titulo compensado (Mov.Bancaria-SE5)  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PCODetLan("000016","04","FINA330")
	
	Next

EndIf
	
RestArea(aAreaSE5)
RestArea(aAreaSE1)
RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Ana Paula N. Silva     ³ Data ³23/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados     ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function MenuDefZ()
Local lFA330LIB := Existblock("FA330LIB")
Local aRetorno  := {}
Local aRotina   := { {STR0001,"AxPesqui"  , 0 , 1,,.F. },;  // "Pesquisar"
	                  {STR0002,"AxVisual"  , 0 , 2 },;        // "Visualizar"
	                  {STR0003,"Fa330Comp" , 0 , 4 },;        // "Compensar"
 	                  {STR0004,"Fa330DesC" , 0 , 4 },;        // "Excluir"
                  	{STR0054,"Fa330DesC" , 0 , 4 },;        //"Estornar"
                  	{STR0047 , "Fa330Leg"  ,0,2, ,.F.} }    //"Legenda"
                  	                  	
 If lFA330LIB
  aRetorno := ExecBlock("FA330LIB",.F.,.F.,{aRotina})	
  aRotina  := AClone(aRetorno)  		
 Endif	
                  	
Return(aRotina)


//------------------------------------------------------------------------------------------------------------------------------------------------

Static Function FA330aUnlock()
Local aArea := GetArea()
If aRLocks == Nil
	aRLocks:={}
Endif	
//**********************************************
// Retirado para permitir utilizacao de rotina *
// automatica dentro de transacao no banco     *
//**********************************************
//AEval(aRLocks,{|x,y| SE1->(MsRUnlock(x))})  
AEval(aRLocks,{|x,y| SE1->(DbGoTo(x)),MsUnLock() })   
aRLocks:={}
RestArea(aArea)
Return

//------------------------------------------------------------------------------------------------------------------------------------------------


Static Function FA330Unlock(cChave,nRecno,cfilorig)
Local aArea
Local nPosRec
If aRLocks == Nil
	aRLocks:={}
Endif	
If nRecno <> Nil             
	SE1->(MsGoto(nRecno))
Else                               
	aArea	:=	getArea()
	SE1->(DbSetOrder(1))
	SE1->(MsSeek(cfilorig+cChave))	
Endif

//**********************************************
// Retirado para permitir utilizacao de rotina *
// automatica dentro de transacao no banco     *
//**********************************************
//SE1->(MsRUnlock(SE1->(Recno())))
SE1->(MsUnlock())


If (nPosRec:=Ascan(aRLOCKS,SE1->(REcno()))) > 0
	Adel(aRlocks,nPosRec)
	aSize(aRlocks,Len(aRlocks)-1)
Endif

If aArea <> Nil
	RestArea(aArea)
Endif	

Return

//------------------------------------------------------------------------------------------------------------------------------------------------

Static Function FA330Lock(cChave,nRecno,lHelp,cfilOrig)
Local aArea
Local lRet	:=	.F.                           
DEFAULT lHelp	:=	.T.

If aRLocks == Nil
	aRLocks:={}
Endif	          
   
If nRecno <> Nil             
	SE1->(MsGoto(nRecno))
Else                               
	aArea	:=	getArea()
	SE1->(DbSetOrder(1))
	SE1->(MsSeek(cfilorig+cChave))
Endif                         
	
//**********************************************
// Retirado para permitir utilizacao de rotina *
// automatica dentro de transacao no banco     *
//**********************************************	
//If SE1->(MsRLock())
If  SE1->(RecLock("SE1",.F.))
	AAdd(aRLocks, SE1->(Recno()))
	lRet	:=	.T.
ElseIf lHelp                                       
	MsgAlert("STR0060")
Endif	
If aArea <> Nil
	RestArea(aArea)
Endif	

Return lRet


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FinA330T   ³ Autor ³ Marcelo Celi Marques ³ Data ³ 27.03.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada semi-automatica utilizado pelo gestor financeiro   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function FinA330T(aParam)

	cRotinaExec := "FINA330"
	ReCreateBrow("SE1",FinWindow)      		
	FinA330(aParam[1])	
	FinVisual(FinWindow:cAliasFile,FinWindow,(FinWindow:cAliasFile)->(Recno()),.T.)
	ReCreateBrow("SE1",FinWindow)      	
	dbSelectArea("SE1")
	
	INCLUI := .F.
	ALTERA := .F.
	
Return .T.	

//------------------------------------------------------------------------------------------------------------------------------------------------

STATIC Function F330SldPri(nRecNo)
Local aArea := SE1->(GetArea())
Local nSaldo := 0

SE1->(DbGoTo(nRecNo))
nSaldo := SE1->E1_SALDO

RestArea(aArea)

Return nSaldo

//------------------------------------------------------------------------------------------------------------------------------------------------

STATIC Function F330CalcPCC(nIt,aArray,cValor)

Local nPosPis := 14		//Posicao Pis na Tela
Local nPosCof := 15		//Posicao Cofins na Tela
Local nPosCsl := 16		//Posicao Csll na Tela
Local nPVRPis := 17		//Posicao Valor Retido Pis na Tela
Local nPVRCof := 18		//Posicao Valor Retido Cofins na Tela
Local nPVRCsl := 19		//Posicao Valor Retido Csll na Tela
Local nPosRec := 20		//Posicao Recno na Tela
Local	nPisJaRet := 0
Local	nPisARet := 0
Local nCofJaRet := 0
Local nCofARet := 0
Local nCslJaRet := 0
Local nCslARet := 0
Local nX	:= 0
Local cRetCli := "1" 	
Local lPccBxCr	:= If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)

If cPaisLoc == "BRA" .and. lPccBxCr
	//Caso considere diferentes clientes
	If MV_PAR02 == 2
		nPosPis := 17
		nPosCof := 18
		nPosCsl := 19
		nPVRPis := 20		//Posicao Valor Retido Pis na Tela
		nPVRCof := 21		//Posicao Valor Retido Cofins na Tela
		nPVRCsl := 22		//Posicao Valor Retido Csll na Tela
		nPosRec := 23
	Endif
	
	SE1->(DbGoTo(aArray[nIt,nPosRec]))
	nValrec := cValor 	//Esta variaves esta numerica apesar da notacao.
	nOldValRec := 	nValRec
	
	If SA1->(FieldPos("A1_ABATIMP")) > 0 
		cRetCli := Iif(Empty(SA1->A1_ABATIMP),"1",SA1->A1_ABATIMP) 
	Endif

	If aArray[nIt,8]	
		If cRetCli == "1"  //Calculo do sistema
			nValRecAtu := nValRec
			For nX:=1 to Len(aArray)
				If	aArray[nX,8]
					nValRec+=Fa330VTit(aArray[nX,7])
					nValRec+=Fa330VTit(aArray[nX,nPosPis])
					nValRec+=Fa330VTit(aArray[nX,nPosCof])				
					nValRec+=Fa330VTit(aArray[nX,nPosCsl])				
					nPisJaRet+= Fa330VTit(aArray[nX,nPosPis])
					nPisARet+= Fa330VTit(aArray[nX,nPVRPis])
					nCofJaRet+= Fa330VTit(aArray[nX,nPosCof])
					nCofARet+= Fa330VTit(aArray[nX,nPVRCof])
					nCslJaRet+= Fa330VTit(aArray[nX,nPosCsl])	  
					nCslARet+= Fa330VTit(aArray[nX,nPVRCsl])	    				
				Endif
			Next
	
			f070TotMes(dBaixa,.T.)	
	
			nValRec := nValRecAtu
			nPis := nPis + nPisARet - nPisJaRet
			nCofins := nCofins + nCofARet - nCofJaRet		
			nCsll := nCsll + nCslARet - nCslJaRet
			
		ElseIf cRetCli == "2"	//Sempre calcula		
			nPropPcc := nValrec/SE1->E1_VLCRUZ
			nPis		:= Round(NoRound(SE1->E1_PIS * nPropPCC,3),2)
			nCofins	:= Round(NoRound(SE1->E1_COFINS * nPropPCC,3),2)
			nCsll		:= Round(NoRound(SE1->E1_CSLL * nPropPCC,3),2)		
			nVlRetPis	:= nPis
			nVlRetCof	:= nCofins
			nVlRetCsl	:= nCsll
			nValRec	-= (nPis+nCofins+nCsll)
		Else                                
			nPis		:= 0
			nCofins	:= 0		
			nCsll		:= 0
			nVlRetPis:= 0
			nVlRetCof:= 0
			nVlRetCsl:= 0
		Endif
	Else
		nPis		:= 0
		nCofins	:= 0		
		nCsll		:= 0
		nVlRetPis:= 0
		nVlRetCof:= 0
		nVlRetCsl:= 0		
	Endif
	
	cValor	:= nValRec
	aArray[nIt,nPosPis] := Transform(nPis,"@E 99,999,999.99")
	aArray[nIt,nPosCof] := Transform(nCofins,"@E 99,999,999.99")
	aArray[nIt,nPosCsl] := Transform(nCsll,"@E 99,999,999.99")  
	aArray[nIt,nPVRPis] := Transform(nVlRetPis,"@E 99,999,999.99")
	aArray[nIt,nPVRCof] := Transform(nVlRetCof,"@E 99,999,999.99")
	aArray[nIt,nPVRCsl] := Transform(nVlRetCsl,"@E 99,999,999.99")  

Endif	

Return


//------------------------------------------------------------------------------------------------------------------------------------------------


STATIC Function F330GrvSFQ(cSequencia,nRecnoSE1)

Local nLoop		 := 0
Local nVlMinImp	 := GetNewPar("MV_VL10925",5000)
Local aRecnos	 := {}
Local cModRetPIS := SA1->A1_ABATIMP   
Local nBaseRet	 := 0
Local lAplVlMin	 := .T.
Local nTamSeq		:= TamSX3("FQ_SEQORI")[1]

DEFAULT cSequencia := Replicate("0",nTamSeq)
DEFAULT nRecnoSE1	:= 0 

nIss     := If(Type("nIss") != "N",0,nIss)
nIrrf    := If(Type("nIrrf") != "N",0,nIrrf)
nValComp := If(Type("nValComp") != "N",0,nValComp)
nValLiq  := If(Type("nValLiq") != "N",0,nValLiq)
dBaixa	:= If(Type("dBaixa") != "D",dDataBase,dBaixa)
nTotAbat := If(Type("nTotAbat") != "N",SumAbatRec( SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_MOEDA, "S"  ,dBaixa,,,@nTotCsAbt,@nTotPisAbt,@nTotCofAbt,),nTotAbat)
nDescont := If(Type("nDescont") != "N",0,nDescont)
nMulta   := If(Type("nMulta") != "N",0,nMulta)
nJuros   := If(Type("nJuros") != "N",0,nJuros)
nAcresc  := If(Type("nAcresc") != "N",0,nAcresc)
nDecresc := If(Type("nDecresc") != "N",0,nDecresc)
lRetParc := If(Type("lRetParc") != "L",.T.,lRetParc)

nBaseRet		:= nValRec+nDescont+nTotAbat-nJuros-nMulta

//Verificar ou nao o limite de 5000 para Pis cofins Csll
// 1 = Verifica o valor minimo de retencao
// 2 = Nao verifica o valor minimo de retencao
If !Empty( SE1->( FieldPos( "E1_APLVLMN" ) ) ) .and. SE1->E1_APLVLMN == "2"
	lAplVlMin := .F.
Endif

If nRecnoSE1 > 0 .AND. AllTrim(cSequencia) != Replicate("0",nTamSeq)
	
	//Pcc Baixa CR
	//Gravar SFQ
	Reclock( "SE5" )		
	SE5->E5_VRETPIS := nPis
	SE5->E5_VRETCOF := nCofins
	SE5->E5_VRETCSL := nCsll								
	MsUnlock()		
	
	
	Do Case 
	Case cModRetPIS == "1" 
		If aDadosRet[ 1 ] + nBaseRet > nVlMinImp .or. !lAplVlMin
			nSalvRec := SE5->( Recno() ) 
			lRetParc := .T.                                                                                  									
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exclui a Marca de "pendente recolhimento" dos demais registros   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aDadosRet[1] > 0
				aRecnos := aClone( aDadosRet[ 6 ] ) 
		
				cPrefOri  := SE5->E5_PREFIXO
				cNumOri   := SE5->E5_NUMERO
				cParcOri  := SE5->E5_PARCELA
				cTipoOri  := SE5->E5_TIPO
				cCfOri    := SE5->E5_CLIFOR
				cLojaOri  := SE5->E5_LOJA
						       
				For nLoop := 1 to Len( aRecnos )
					
					SE5->( dbGoto( aRecnos[ nLoop ] ) )
						
					RecLock( "SE5", .F. ) 
					
					If !Empty(SE5->E5_PRETPIS) .And. !Empty(SE5->E5_PRETCOF) .And. !Empty(SE5->E5_PRETCSL)
						SE5->E5_PRETPIS := "2"
						SE5->E5_PRETCOF := "2"
						SE5->E5_PRETCSL := "2"
					EndIf
																	
					SE5->( MsUnlock() )
		
					If FindFunction("ALIASINDIC")
						If AliasIndic("SFQ") 
							If nSalvRec <> aRecnos[ nLoop ] 
								dbSelectArea("SFQ")
								RecLock("SFQ",.T.)
								SFQ->FQ_FILIAL  := xFilial("SFQ")
								SFQ->FQ_ENTORI  := "E1B"
								SFQ->FQ_PREFORI := cPrefOri
								SFQ->FQ_NUMORI  := cNumOri
								SFQ->FQ_PARCORI := cParcOri
								SFQ->FQ_TIPOORI := cTipoOri										
								SFQ->FQ_CFORI   := cCfOri
								SFQ->FQ_LOJAORI := cLojaOri
								SFQ->FQ_SEQORI  := cSequencia
								
								SFQ->FQ_ENTDES  := "E1B"
								SFQ->FQ_PREFDES := SE5->E5_PREFIXO
								SFQ->FQ_NUMDES  := SE5->E5_NUMERO
								SFQ->FQ_PARCDES := SE5->E5_PARCELA                             
								SFQ->FQ_TIPODES := SE5->E5_TIPO
								SFQ->FQ_CFDES   := SE5->E5_CLIFOR
								SFQ->FQ_LOJADES := SE5->E5_LOJA
								SFQ->FQ_SEQDES  := SE5->E5_SEQ
		
								//Grava a filial de destino caso o campo exista
								If !Empty( SFQ->( FieldPos( "FQ_FILDES" ) ) ) 
									SFQ->FQ_FILDES := SE5->E5_FILIAL 
								EndIf 											
		
								MsUnlock()
							Endif								
						Endif					
					Endif	
				Next nLoop 
			EndIf
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Retorna do ponteiro do SE1 para a parcela         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SE5->( MsGoto( nSalvRec ) ) 
			Reclock( "SE5", .F. )
		Else 	                                
			If nVlRetPis + nVlRetCof + nVlRetCsl > 0
				Reclock( "SE5", .F. ) 
				SE5->E5_VRETPIS := nVlRetPis
				SE5->E5_VRETCOF := nVlRetCof
				SE5->E5_VRETCSL := nVlRetCsl
				SE5->E5_PRETPIS := "1"
				SE5->E5_PRETCOF := "1"
				SE5->E5_PRETCSL := "1"
		
				SE5->( MsUnlock() )  																								
			EndIf	
			lRetParc := .F.
		
		EndIf
	
	Case cModRetPIS == "2" 
		lRetParc := .T.

	Case cModRetPIS == "3" 			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava a Marca de "pendente recolhimento" dos demais registros    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		If nVlRetPis + nVlRetCof + nVlRetCsl > 0
			Reclock( "SE5", .F. ) 
			SE5->E5_VRETPIS := nVlRetPis
			SE5->E5_VRETCOF := nVlRetCof
			SE5->E5_VRETCSL := nVlRetCsl
			SE5->E5_PRETPIS := "1"
			SE5->E5_PRETCOF := "1"
			SE5->E5_PRETCSL := "1"
	
			SE5->( MsUnlock() )  																								
		EndIf	
		lRetParc := .F.
	EndCase 				
	
	//Grava os titulos de PCC Baixa CR
	//Gravo os titulos de impostos Pis Cofins Csll quando controlados pela baixa
	If lRetParc
		nPis		:= SE5->E5_VRETPIS
		nCofins	:= SE5->E5_VRETCOF
		nCsll		:= SE5->E5_VRETCSL
		FGrvPccRec(@nPis,@nCofins,@nCsll,nRecnoSE1,.F.,lRetParc,@cSequencia,"FINA070",SE1->E1_MOEDA)
	Endif					
Endif

Return

//--------------------------------------------------------------------------

STATIC Function FaDelSFQCR()

Local nI := 0
Local aRecSE5 := {}
Local lPccBxCr	:= If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)
Local aArea := GetArea()
Local nRecSE5 := 0

If cPaisLoc == "BRA" .and. lPccBxCR
	nRecSe5  := SE5->(RecNo())
				
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclui os registros de relacionamentos do SFQ                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRecSE5 := FImpDelTit("E1B",SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO,SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_SEQ)
	For nI := 1 to Len(aRecSE5)
		SE5->(MSGoto(aRecSE5[nI]))	
		RecLock("SE5",.F.)          					

		If ((!SE5->E5_TIPO $ MVPAGANT) .Or. (SE5->E5_TIPO $ MVPAGANT .And.;
			!Empty(SE5->E5_PRETPIS) .And. !Empty(SE5->E5_PRETCOF) .And. !Empty(SE5->E5_PRETCSL)))					
			SE5->E5_PRETPIS := "1"
			SE5->E5_PRETCOF := "1"
			SE5->E5_PRETCSL := "1"
		Endif	
		MsUnlock()
	Next 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclui os registros de relacionamentos do SFQ                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SE5->(dbGoto(nRecSe5))
	FImpDelSFQ("E1B",SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO,SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_SEQ)
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga os registros de impostos gerados na Baixa                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	F070DelTxBx()			

EndIf
RestArea(aArea)

Return

//--------------------------------------------------------------------------------

STATIC Function F330Invert(lPccBxCr,oTitulo,oGet01)

nValTot := 0

If (cPaisLoc == "BRA" .and. lPccBxCr .and. lCredito) .Or. cPaisLoc <> "BRA"
	aTitulos:=FA330Troca(oTitulo:nAt,aTitulos,oGet01,.T.)
Else
 	aEval(aTitulos, {|e| IIf(!e[8].And.Fa330Lock(e[1]+e[2]+e[3]+e[4],,,Iif(MV_PAR02== 2, e[16],e[13]),.F.), (e[8] := .T.) , If(e[8], (Fa330UnLock(e[1]+e[2]+e[3]+e[4],,Iif(MV_PAR02== 2, e[16],e[13]),.F.),e[8] := .F. ),Nil)       ), If(e[8],(If(Fa330VTit(e[7])=0,e[7]:=e[6],Nil),nValTot += Fa330VTit(e[7]),e[9]:=DesTrans(e[7])),(e[7]:=Transf(0,"@E 9999,999,999.99"), e[9]:=e[7]))})
Endif

oTitulo:Refresh()
oGet01:Refresh()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FaNfsRAdt   ³ Autor ³Totvs                ³ Data ³10.05.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Checa se condicao de pagamento do documento de saida usa    ³±±
±±³          ³adiantamento.                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se Condicao de Pagamento gera Adiantamento    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Prefixo do titulo                                    ³±±
±±³          ³ExpC2: Numero do titulo                                     ³±±
±±³          ³ExpC3: Codigo do cliente                                    ³±±
±±³          ³ExpC4: Loja do cliente                                      ³±±
±±³          ³ExpD5: Data de Emissao do Documento                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FaNfsRAdt(cPrefixo,cNum,cCliente,cLoja,dDataEmis)

Local aArea := GetArea()
Local cQ := ""
Local lRet := .F.

cQ	:= "SELECT F2_COND "
cQ += "FROM "+RetSqlName("SF2")+" "
cQ += "WHERE F2_FILIAL = '"+xFilial("SF2")+"' "
cQ += "AND F2_PREFIXO = '"+cPrefixo+"' "
cQ += "AND F2_DUPL = '"+cNum+"' "
cQ += "AND F2_CLIENTE = '"+cCliente+"' "
cQ += "AND F2_LOJA = '"+cLoja+"' "
cQ += "AND F2_EMISSAO = '"+dTos(dDataEmis)+"' "
cQ += "AND D_E_L_E_T_= ' ' "

cQ := ChangeQuery(cQ)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"TRBSF2",.T.,.T.)

If !Eof()
	If A410UsaAdi(TRBSF2->F2_COND)
		lRet := .T.
	Endif
Endif

TRBSF2->(dbCloseArea())

RestArea(aArea)

Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FaBxEmisDoc ³ Autor ³Totvs                ³ Data ³10.05.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Checa se a compensacao do titulo foi gerada no momento da   ³±±
±±³          ³emissao do documento.Parametros devem ser o do titulo       ³±±
±±³          ³principal (Tipo de titulo = MVNOTAFIS).                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se a Compensacao foi realizada na geracao do  ³±±
±±³          ³Documento                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Filial do SE5                                        ³±±
±±³          ³ExpC2: Prefixo do titulo                                    ³±±
±±³          ³ExpC3: Numero do titulo                                     ³±±
±±³          ³ExpC4: Parcela do titulo                                    ³±±
±±³          ³ExpC5: Cliente/Fornecedor do titulo                         ³±±
±±³          ³ExpC6: Loja do titulo                                       ³±±
±±³          ³ExpC7: Tipo da baixa                                        ³±±
±±³          ³ExpD8: Data de emissao do titulo                            ³±±
±±³          ³ExpC9: Sequencia da baixa                                   ³±±
±±³          ³ExpC10: Carteira da baixa "R"/"P"                           ³±±
±±³          ³ExpC11: Numero do documento                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Esta rotina eh usada no contas a receber a pagar.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function FaBxEmisDoc(cFilSE5,cPrefixo,cNum,cParcela,cCliFor,cLoja,cTipo,dDataE,cSeq,cCarteira,cDocumen)

Local aArea := GetArea()
Local cQ := ""
Local lRet := .F.
Local nCountFR3 := 0
Local nTamPref := IIf(cCarteira = "R",TamSX3("E1_PREFIXO")[1],IIf(cCarteira = "P",TamSX3("E2_PREFIXO")[1],0))
Local nTamNum := IIf(cCarteira = "R",TamSX3("E1_NUM")[1],IIf(cCarteira = "P",TamSX3("E2_NUM")[1],0))
Local nTamParc := IIf(cCarteira = "R",TamSX3("E1_PARCELA")[1],IIf(cCarteira = "P",TamSX3("E2_PARCELA")[1],0))

// localiza quantas vezes o adiantamento foi utilizado neste documento de saida
cQ	:= "SELECT COUNT(*) AS NREG "
cQ += "FROM "+RetSqlName("FR3")+" "
cQ += "WHERE FR3_FILIAL = '"+xFilial("FR3")+"' "
cQ += "AND FR3_CART = '"+cCarteira+"' "
cQ += "AND FR3_DATAE = '"+dTos(dDataE)+"' "
cQ += "AND FR3_NUM = '"+Subs(cDocumen,nTamPref+1,nTamNum)+"' "
cQ += "AND FR3_PREFIX = '"+Subs(cDocumen,1,nTamPref)+"' "
cQ += "AND FR3_PARCEL = '"+Subs(cDocumen,nTamPref+nTamNum+1,nTamParc)+"' "
If cCarteira = "R"
	cQ += "AND FR3_CLIENT = '"+cCliFor+"' "
Elseif cCarteira = "P"
	cQ += "AND FR3_FORNEC = '"+cCliFor+"' "
Endif	
cQ += "AND FR3_LOJA = '"+cLoja+"' "
If cCarteira = "R"
	cQ += "AND FR3_TIPO IN "+FormatIn(MVRECANT,"/")+" "
Elseif cCarteira = "P"
	cQ += "AND FR3_TIPO IN "+FormatIn(MVPAGANT,"/")+" "
Endif	
cQ += "AND FR3_DOC = '"+cNum+"' "
cQ += "AND EXISTS( SELECT * " // busca somente os registros que tenham o mesmo documento que estah sendo comparado, para evitar problema de titulos com mais de uma parcela, gerando divergencia na comparacao entre as parcelas.
cQ += "	FROM "+RetSqlName("FR3")+" "
cQ += "	WHERE FR3_FILIAL = '"+xFilial("FR3")+"' "
cQ += "	AND FR3_CART = '"+cCarteira+"' "
cQ += "	AND FR3_DATAE = '"+dTos(dDataE)+"' "
cQ += "	AND FR3_NUM = '"+cNum+"' "
cQ += "	AND FR3_PREFIX = '"+cPrefixo+"' "
cQ += "	AND FR3_PARCEL = '"+cParcela+"' "
If cCarteira = "R"
	cQ += "	AND FR3_CLIENT = '"+cCliFor+"' "
Elseif cCarteira = "P"
	cQ += "	AND FR3_FORNEC = '"+cCliFor+"' "
Endif	
cQ += "	AND FR3_LOJA = '"+cLoja+"' "
cQ += "	AND FR3_TIPO = '"+MVNOTAFIS+"' "
cQ += "	AND FR3_DOC = '"+cNum+"' "
cQ += "	AND D_E_L_E_T_= ' ') "
cQ += "AND D_E_L_E_T_= ' ' "

cQ := ChangeQuery(cQ)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"TRBFR3",.T.,.T.)

nCountFR3 := TRBFR3->NREG

TRBFR3->(dbCloseArea())

If !Empty(nCountFR3)
	// localiza as baixa para o titulo principal por ordem de sequencia, para comparar com a quantidade de baixas ocorridas no momento da geracao do documento
	cQ	:= "SELECT R_E_C_N_O_ AS SE5RECNO,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO,E5_CLIFOR,E5_LOJA,E5_SEQ "
	cQ += "FROM "+RetSqlName("SE5")+" "
	cQ += "WHERE E5_FILIAL = '"+cFilSE5+"' "
	cQ += "AND E5_RECPAG = '"+cCarteira+"' "
	cQ += "AND E5_SITUACA <> 'C' "
	cQ += "AND E5_DATA = '"+dTos(dDataE)+"' "
	cQ += "AND E5_NUMERO = '"+cNum+"' "
	cQ += "AND E5_PREFIXO = '"+cPrefixo+"' "
	cQ += "AND E5_PARCELA = '"+cParcela+"' "
	cQ += "AND E5_CLIFOR = '"+cCliFor+"' "
	cQ += "AND E5_LOJA = '"+cLoja+"' "
	cQ += "AND E5_TIPO = '"+cTipo+"' "
	cQ += "AND E5_MOTBX = 'CMP' "
	cQ += "AND E5_TIPODOC = 'CP' "
	cQ += "AND D_E_L_E_T_= ' ' "
	cQ += "AND E5_DOCUMEN = '"+cDocumen+"' " // considera somente as baixas que usaram este mesmo documento, ou seja, as baixas deste adiantamento
	cQ += "ORDER BY E5_FILIAL,E5_SEQ "
	
	cQ := ChangeQuery(cQ)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"TRBSE5",.T.,.T.)
	
	While !Eof()
		If Empty(nCountFR3)
			Exit
		Endif	
		If TemBxCanc(TRBSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ),.T.)
			dbSkip()
			Loop
		Endif
		nCountFR3--
		// se sequencia da baixa for igual a do parametro, esta baixa foi efetuado junto com a emissao do documento
		If TRBSE5->E5_SEQ = cSeq 
			lRet := .T.
		Endif
		dbSkip()
	Enddo
	
	TRBSE5->(dbCloseArea())		
Endif	
	
RestArea(aArea)

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fa330VldDtºAutor  ³ Clovis Magenta     º Data ³  13/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consiste MV_DATAFIN antes de cancelar baixa/compensação  	º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function Fa330VldDt(aArray)
Local lRet := .T.

If lRet .and. SuperGetMv("MV_BXDTFIN",,"1") == "2"	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ A data da baixa deve ser passada como parametro, pois tanto ³
	//³ o cancelamento como a exclusao devem ser validados pela     ³
	//³ data de baixa e nao pela data base do sistema.              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	lRet := DtMovFin(CtoD(aArray[06]),!l330Auto)

Endif

Return lRet


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fa330TxMd  ³ Autor ³ Cristiano Denardi    ³ Data ³ 05.04.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Busca Taxa em aTxMoedas e verifica se foi trocada          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function Fa330TxMd( nMoeda2, nTx )

Local lExistTxMd	:= Type("aTxMoedas")#"U" .And. Len(aTxMoedas) > 0  

Default nTx			:= 0
Default nMoeda2 		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura aTxMoedas         ³
//³ [1] -> Nome Moeda          	³
//³ [2] -> Taxa a Ser Utilizada	³
//³ [3] -> Picture          	³
//³ [4] -> Taxa do dia atual    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nMoeda2 > 0 .And. lExistTxMd .AND. (nMoeda2<>SE1->E1_MOEDA)
	If aTxMoedas[nMoeda2][2] <> aTxMoedas[nMoeda2][4] .and. (aTxMoedas[nMoeda2][2]<>0)
		nTx := aTxMoedas[nMoeda2][2]
	Elseif (nTx <> aTxMoedas[nMoeda2][4]) .and. (aTxMoedas[nMoeda2][4]<>0)
		nTx := aTxMoedas[nMoeda2][4]
	Endif
ELSEIF (nMoeda2==SE1->E1_MOEDA)
	// se a moeda do titulo principal é 2 e a do titulo posicionado tb, nao convertemos pois os valores serao expressos em U$
	nTx := 1
Endif

Return( nTx )
             
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fa330Tx2  ³ Autor ³ Clovis Magenta       ³ Data ³ 31.08.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Busca Taxa em aTxMoedas e verifica se foi trocada          ³±±
±±³Descri‡…o ³ Funcao copiada da Fa340TxMd pois a Fa330TxMd() nao obtem   ³±±
±±³Descri‡…o ³ resultado satisfatorio para alguns casos de conversao      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINXATU                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function Fa330Tx2( nMoeda2, nTx )

Local lExistTxMd	:= Type("aTxMoedas")#"U" .And. Len(aTxMoedas) > 0  
Default nTx			:= 0
Default nMoeda2 		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura aTxMoedas         ³
//³ [1] -> Nome Moeda          	³
//³ [2] -> Taxa a Ser Utilizada	³
//³ [3] -> Picture          	³
//³ [4] -> Taxa do dia atual    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/

// Esta função só deve ser chamada pela rotina de compensação a pagar

If nMoeda2 > 0 .And. lExistTxMd 
	If aTxMoedas[nMoeda2][2] <> aTxMoedas[nMoeda2][4] .and. (aTxMoedas[nMoeda2][2]<>0)
		nTx := aTxMoedas[nMoeda2][2]
	Endif
Endif

Return( nTx )
