#include "rwmake.ch"
#INCLUDE "TOPCONN.ch"

/*/{protheus.doc}HSCHREFSAL
Relatorio dos produtos sem movimento
@author VINICIUS VENDEMIATTI
@since 28/01/15
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³  NOMOV   ³ Autor ³ VINICIUS VENDEMIATTI  ³ Data ³ 28/01/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Relatorio dos produtos sem movimento                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NOMOV()
	PRIVATE QUERYd         := ""
	PRIVATE QUERYULTSAI    := ""
	PRIVATE QUERYSB1       := ""
	WD3_EMISSAO := ctod("  /  /  ")
	wZo_DATA    := ctod("  /  /  ")
	wProximaEnt := ctod("  /  /  ")
	warq1       := ""
	wQtdMes     := 12
	wDtAtual    := ctod("  /  /  ")
	wUltimaMov  := ctod("  /  /  ")
	wQtTotal    := 0
	w11MeTotal  := 0
	w1AnoTotal  := 0
	w2AnoTotal  := 0
	w3AnoTotal  := 0
	wNoAno      := space(04)
	wNoMes      := space(02)
	wGrupoDe    := space(04)
	wGrupoAte   := space(04)
	wCodigode   := space(15)
	wCodigoAte  := space(15)

	cNomeArqDb  := space(00)
	wm1cdmat    := space(15)
	_cB1_GRUPO  := space(04)
	wDtIni11Me  := ctod("  /  /  ")
	wDtFin2Ano  := ctod("  /  /  ")
	wDtIni2Ano  := ctod("  /  /  ")
	wDtFin3Ano  := ctod("  /  /  ")
	wDtIni3Ano  := ctod("  /  /  ")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Tamanho  := "G"
	nTipo    := 18
	titulo   := "RELATORIO DE MATERIAS SEM MOVIMENTO"
	cDesc1   := "Emite relacao de materiais sem movimento no periodo"
	cDesc2   := ""
	cDesc3   := ""
	Cabec1   := ""
	Cabec2   := ""
	cString  := "SD2"
	aOrd     := {}
	nomeprog := "NOMOV"
	Li       := 80
	m_pag    := 1
	cPerg    := "NOMOV"
	wlin     := 0
	aSalatu  := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01             // Ano da Emissao                       ³
	//³ mv_par02             // Mes da Emissao                       ³
	//³ mv_par03             // Grupo de Material De                 ³
	//³ mv_par04             // Grupo de Material Ate                ³
	//³ mv_par05             // Modelo 1 ou modelo 2                 ³
	//³ mv_par06             // Moeda 1 ou Moeda 5                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRegs           := {}
	Aadd(aRegs,{cPerg,"01","Ano           ?","","","mv_ch1","C",004,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"02","Mes           ?","","","mv_ch2","C",002,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"03","Grupo de      ?","","","mv_ch3","C",004,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"04","Grupo Ate     ?","","","mv_ch4","C",004,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"05","Modelo        ?","","","mv_ch5","N",001,0,1,"C","","mv_par05",;
		"Previsao","","","","",;
		"Oficial ","","","","","","","","","","" } )
	Aadd(aRegs,{cPerg,"06","Moeda         ?","","","mv_ch6","N",001,0,1,"C","","mv_par06",;
		"Moeda 1","","","","",;
		"Moeda 2","","","","",;
		"Moeda 3","","","","",;
		"Moeda 4","","","","",;
		"Moeda 5","","","","","","","","","","" } )
	Aadd(aRegs,{cPerg,"07","Mes Encerrado ?","","","mv_ch7" ,"N",001,0,1,"C","","mv_par07","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","","","" })
	Aadd(aRegs,{cPerg,"08","Codigo de     ?","","","mv_ch9" ,"C",015,0,0,"G","","mv_par09","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"09","Codigo Ate    ?","","","mv_ch10","C",015,0,0,"G","","mv_par10","","","","","","","","","","","","","","",""})

	ValidPerg(aRegs,cPerg)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis tipo Private padrao de todos os relatorios         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aReturn := { "Zebrado", 1,"Administracao",  1, 2, 1, "",1 }
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	pergunte(cPerg,.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel:=SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

	If LastKey() == 27
		Return
	Endif

	DbSelectArea("SF4")
	dbSetOrder(1)
	dbSelectArea("SB2")
	dbSetOrder(1)
	//dbSetOrder(4)
	dbSelectArea("SD3") // arquivo Kardex de Saida de Material
	dbSetOrder(7)
	dbSelectArea("SD1") // arquivo Kardex de Saida de Material
	dbSetOrder(7)
	dbSelectArea("SB1") // Arquivo Cadastro de Material
	dbSetOrder(1)
	dbSelectArea("SD2") // arquivo Kardex de Saida de Material
	dbSetOrder(6)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)
	RptStatus({|| R010IMP(Cabec1,Cabec2,Titulo,) },Titulo)

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R010IMP  ³ Autor ³ Vinicius Vendemiatti  ³ Data ³ 28/01/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FIFR010                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function R010imp()
	Processa({||FNoMovImp ()})
	Set Device To Screen
	If aReturn[5] == 1
		Set Printer To
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FNoMovImp³ Autor ³ Vinicius Vendemiatti  ³ Data ³ 28/01/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FIFR010                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function FNoMovImp()
	Private _cFilB9, _cFilB1, _cFilB2, _cTmp

	_cFilB9 := xFilial("SB9")
	_cFilB1 := xFilial("SB1")
	_cFilB2 := xFilial("SB2")

	wUltimaMov 		:= ctod("  /  /  ")
	WDtEntr         := ctod("  /  /  ")
	wQtTotal   		:= 0
	w11MeTotal 		:= 0
	w1AnoTotal 		:= 0
	w2AnoTotal 		:= 0
	w3AnoTotal 		:= 0
	wNoAno     		:= mv_par01
	wNoMes     		:= mv_par02
	wGrupoDe   		:= mv_par03
	wGrupoAte  		:= mv_par04
	wCodigode       := mv_par08
	wCodigoAte      := mv_par09
	_cMesEncerrado	:= IIF(mv_par07=2,"N","S")


	IF mv_par05 = 1
		Cabec1   := "  CODIGO                        DESCRICAO                               GRUPO     SALDO          CUSTO       11 MESES          1 ANO    1 ANO 11 MES.  + DE 2 ANOS  DT.B.CALC      SAIDA    ENTRADA"
	ELSE
		Cabec1   := "  CODIGO                        DESCRICAO                               GRUPO     SALDO          CUSTO                         1 ANO                   + DE 2 ANOS  DT.B.CALC      SAIDA    ENTRADA"
	ENDIF

	Titulo  := Titulo + "( PERIODO " + wNoAno  + "/" + wNoMes +" ) MOEDA " + STR(mv_par06,1,0)

	w11MeTemMov := "N"
	w1AnoTemMov := "N"
	w2AnoTemMov := "N"
	w3AnoTemMov := "N"

	wDtAtual   := ctod( "01/" + wNoMes + "/" + wNoAno )
	wDtAtual   := U_FimMes(wDtAtual)
	wDtIni     := U_SomaMes(wDtAtual,-wQtdMes)
	wDtIni     := wDtIni + 1

	wDtIni11Me := U_SomaMes(wDtAtual, -11 )
	wDtIni11Me := wDtIni11Me + 1

	wDtFin2Ano := wDtIni     - 1
	wDtIni2Ano := U_SomaMes(wDtFin2Ano,-wQtdMes)
	wDtIni2Ano := wDtIni2Ano + 1

	wDtFin3Ano := wDtIni2Ano - 1
	wDtIni3Ano := U_SomaMes(wDtFin3Ano,-wQtdMes)
	wDtIni3Ano := wDtIni3Ano + 1

	if _cMesEncerrado = "S"
		_cTmp := wNoAno+wNoMes
		*********************** SB9 ******************
		QUERYd := "SELECT B1_FILIAL, B9_FILIAL, B1_COD,B1_DESC,B1_GRUPO,B9_QINI,B9_VINI1,B9_VINI2,B9_VINI3,B9_VINI4,B9_VINI5,B9_DATA "
		QUERYd += "  FROM "+RetSqlName("SB1")+" AS SB1,"+RetSqlName("SB9")+" AS SB9 "
		QUERYd += " WHERE B1_COD=B9_COD AND SUBSTRING(B9_DATA,1,6) = '"+_cTmp+"' "
		QUERYd += "   AND B9_FILIAL = '"+_cFilB9+"' "
		QUERYd += "   AND B9_LOCAL  = '"+MV_PAR11+"' "
		QUERYd += "   AND B1_FILIAL = '"+_cFilB1+"' "
		QUERYd += "   AND B9_QINI > 0 "
		QUERYd += "   AND SB1.D_E_L_E_T_ <> '*' "
		QUERYd += "   AND SB9.D_E_L_E_T_ <> '*' "
		QUERYd += "   AND B1_GRUPO >= '"+wGrupoDe+"' AND B1_GRUPO <= '"+wGrupoAte+"' "
		QUERYd += "   AND B1_COD >= '"+wCodigode+"' AND B1_COD <= '"+wCodigoate+"' "
		//	QUERYd += "   AND B1_COD = '09000631760135 '"
		//	QUERYd += "   AND B1_GRUPO <> '7999' AND B1_GRUPO <> '8999' AND B1_COD <> 'P ' "
		QUERYd += "ORDER BY B1_COD"
		//	MemoWrit("WRESTR01.SQL",QUERYd)
		TcQuery QUERYd NEW ALIAS QUERYSB1
	else
		*********************** SB2 ******************
		QUERYd := "SELECT B1_COD,B1_DESC,B1_GRUPO,B2_QATU,B2_CM1,B2_CM2,B2_CM3,B2_CM4,B2_CM5 FROM "+RetSqlName("SB1")+" AS SB1,"+RetSqlName("SB2")+" AS SB2 "
		QUERYd += "WHERE B1_COD=B2_COD "
		QUERYd += "   AND B2_LOCAL  = '"+MV_PAR11+"' "
		QUERYd += "   AND B2_FILIAL = '"+_cFilB2+"' "
		QUERYd += "   AND B1_FILIAL = '"+_cFilB1+"' "
		QUERYd += "   AND SB1.D_E_L_E_T_ <> '*' "
		QUERYd += "   AND SB2.D_E_L_E_T_ <> '*' "
		QUERYd += "   AND B1_COD >= '"+wCodigode+"' AND B1_COD <= '"+wCodigoate+"' "
		QUERYd += "   AND B1_GRUPO BETWEEN '"+wGrupoDe+"' AND '"+wGrupoAte+"' "
		//	QUERYd += "   AND B1_GRUPO <> '7999' AND B1_GRUPO <> '8999' AND B1_COD <> 'P ' "
		QUERYd += "ORDER BY B1_COD"
		//	MemoWrit("WRESTR01.SQL",QUERYd)
		TcQuery QUERYd NEW ALIAS QUERYSB1
	endif

	fRelNoMCriaAtrq() // Cria aquivo temporario

	dbSelectArea("QUERYSB1")
	PROCREGUA(5000) // 5000 = quantidade de registros
	dBGotop()

	do while ! eof()
		INCPROC("Imprimindo... No Moving")
		w11MeTemMov := "N"
		w1AnoTemMov := "N"
		w2AnoTemMov := "N"
		w3AnoTemMov := "N"

		wUltimaMov  := ctod("  /  /  ")
		wm1cdmat    := B1_COD
		_cB1_GRUPO  := B1_GRUPO


	enddo
	// VERIFICA SE HA APROPRIACOES
	dbSelectArea("SB2")
	dbseek(xfilial( "SB2" ) + wm1cdmat)
	IF B2_QEMP <> 0
		dbSelectArea("QUERYSB1")
		DbSkip()
		//		LOOP
	ENDIF

	fRelNoM11Me()  // verifica se teve movimentacao em 11 meses
	if w11MeTemMov = "S"  // se teve movimentacao no 1§ Ano
		dbSelectArea("QUERYSB1")
		DbSkip()
		//		loop
	endif
	wUltimaMov  := ctod("  /  /  ")
	fRelNoM1Ano()  // verifica se teve movimentacao no 1§ Ano
	IF w1AnoTemMov = "N"
		wUltimaMov  := ctod("  /  /  ")
		fRelNoM2Ano()  // verifica se teve movimentacao no 2§ Ano
	ENDIF

	IF w2AnoTemMov = "N" .and. w1AnoTemMov = "N"
		wUltimaMov  := ctod("  /  /  ")
		fRelNoM3Ano()  // verifica se teve movimentacao no 3§ Ano
		w3AnoTemMov = "S"
	ENDIF

	// VERIFICA SE O MATERIAL FOI CADASTRADO APOS A DATA INICIAL
	//	wZo_DATA    := ctod("  /  /  ")
	WD3_EMISSAO := ctod("  /  /  ")

	******************* Movimentacao no Arquivo SD3 ************************
	dbSelectArea("SD3") // arquivo Kardex de Saida de Material
	dbseek(xfilial( "SD3" ) + wm1cdmat +mv_par11+ dtos(wUltimaMov) ,.T.)

	do while ! eof();
			.AND. D3_COD         == wm1cdmat       ;
			.AND. D3_EMISSAO     <= wUltimaMov     ;
			.AND. xFilial("SD3") == SD3->D3_FILIAL ;
			.AND. D3_LOCAL == mv_par11

		/*	if D3_TM >  "500" .OR. D3_TM == "650" .OR.	D3_TM == "651" .OR.	D3_TM == "652"
				DbSkip()
				loop
		endif */

		WD3_EMISSAO := D3_EMISSAO
		EXIT
	enddo

	IF ! EMPTY(WD3_EMISSAO)
		if WD3_EMISSAO >= wDtIni
			dbSelectArea("QUERYSB1")
			DbSkip()
			//				loop
		Endif
	ENDIF


	dbSelectArea("SD1")
	aSalatu         := CalcEst(wm1cdmat,SB2->B2_LOCAL,wUltimaMov+1)
	wProximaEnt     := ctod("  /  /  ")
	if aSalatu[01] <= 0
		dbSelectArea("SD1") // arquivo Kardex de Saida de Material
		dbseek(xfilial("SD1")+ wm1cdmat +mv_par11+ dtos(wUltimaMov+1) ,.T.)
		do while ! eof()                          ;
				.AND. D1_COD         == wm1cdmat      ;
				.AND. xFilial("SD1") == SD1->D1_FILIAL;
				.AND. D1_LOCAL       == mv_par11
			wProximaEnt  		 := D1_DTDIGIT
			exit
		enddo
	endif
	******************* Movimentacao no Arquivo SD3 ************************
	dbSelectArea("SD3") // arquivo Kardex de Saida de Material
	dbseek(xfilial( "SD3" ) + wm1cdmat +mv_par11+ dtos(wUltimaMov+1) ,.T.)

	do while ! eof() .AND. D3_COD == wm1cdmat .AND. xFilial("SD3") == SD3->D3_FILIAL .AND. D3_LOCAL == mv_par11
		if D3_TM == "350" .OR. D3_TM >= "500"
			DbSkip()
			loop
		endif

		if wProximaEnt > D3_EMISSAO .or. wProximaEnt = ctod("  /  /  ")
			wProximaEnt := D3_EMISSAO
		endif
		EXIT
	enddo

	******************* Movimentacao no Arquivo  ************************

	WDtEntr         := ctod("  /  /  ")
	dbSelectArea("SD1") // arquivo Kardex de Saida de Material
	dbseek(xfilial("SD1")+ wm1cdmat +mv_par11+ dtos(wUltimaMov+1) ,.T.)
	do while ! eof()                          ;
			.AND. D1_COD         == wm1cdmat      ;
			.AND. xFilial("SD1") == SD1->D1_FILIAL;
			.AND. D1_LOCAL       == mv_par11
		WDtEntr:=D1_DTDIGIT
		exit
	enddo

	******************* Movimentacao no Arquivo SD3 ************************
	dbSelectArea("SD3") // arquivo Kardex de Saida de Material
	dbseek(xfilial( "SD3" ) + wm1cdmat +mv_par11+ dtos(wUltimaMov+1) ,.T.)

	do while ! eof()                           ;
			.AND. D3_COD         == wm1cdmat       ;
			.AND. xFilial("SD3") == SD3->D3_FILIAL ;
			.AND. D3_LOCAL       == mv_par11
		if D3_TM == "350" .OR. D3_TM >= "500"
			DbSkip()
			loop
		endif
		if WDtEntr > D3_EMISSAO .or. wDtEntr = ctod("  /  /  ")
			WDtEntr:= D3_EMISSAO
		endif
		EXIT
	enddo

	******************* Movimentacao no Arquivo  ************************

	IF wProximaEnt >= wDtIni11Me
		dbSelectArea("QUERYSB1")
		DbSkip()
		//		loop
	ENDIF

	IF EMPTY(WD3_EMISSAO) .AND. EMPTY(wUltimaMov) //SE NUNCA TEVE MOVIMENTO
		dbSelectArea("QUERYSB1")
		DbSkip()
		//		loop
	ENDIF

	dbSelectArea (warq1)

	append blank
	replace NoAnoMes  with wNoAno + wNoMes
	replace NoCdMat   with wm1cdmat
	replace NoGrupo   with _cB1_GRUPO


	replace NoPent    with wProximaEnt
	replace NoUSaida  with wUltimaMov
	replace NoUMov    with iif(wProximaEnt>wUltimaMov,wProximaEnt,wUltimaMov)
	replace No3Ini    with wDtIni3Ano
	replace No3Fin    with wDtFin3Ano
	replace No2Ini    with wDtIni2Ano
	replace No2Fin    with wDtFin2Ano
	replace No1Ini    with wDtIni
	replace No1Fin    with wDtAtual
	replace NoEntr    with WDtEntr

	if NoUMov >= wDtIni2Ano
		w3AnoTemMov = "N"
		w2AnoTemMov = "S"  // se nao teve movimentacao no 2§ Ano
		w1AnoTemMov = "N"  // se nao teve movimentacao no 1§ Ano
		w11MeTemMov = "N"  // se nao teve movimentacao nos 11 meses
	endif

	if w3AnoTemMov == "S"      // se nao teve movimentacao no 3§ Ano
		replace NoAnoM    with 3
	elseif w2AnoTemMov == "S"  // se nao teve movimentacao no 2§ Ano
		replace NoAnoM    with 2
	elseif w1AnoTemMov == "S"  // se nao teve movimentacao no 1§ Ano
		replace NoAnoM    with 1
	elseif w11MeTemMov == "S"  // se nao teve movimentacao nos 11 meses
		replace NoAnoM    with 0
	endif

	dbSelectArea("QUERYSB1")
	dbSkip()


	//dbUSEAREA(.T.,,cNomeArqDb,"InoMovA",.T.,.F.)
	dbSelectArea (warq1)

	seek wNoAno + wNoMes
	do while ! eof() .and. NoAnoMes = wNoAno + wNoMes

		if wlin = 0
			wlin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		endif

		IF mv_par05 = 2  // SE FOR MODELO 2 NAO E NECESSARIO OS 11 MESES
			IF NoAnoM = 0     //  11 meses
				DbSkip()
				LOOP
			ENDIF
		ENDIF

		fRelNoMDet()

		IF WLIN >=60
			@WLIN,000 SAY REPLICATE("-",169)
			WLIN := 0
		ENDIF

		DbSkip()
	enddo

	fRelNoMTot()

	//dbCloseAll()
	dbSelectArea("QUERYSB1")
	DbCloseArea()

	Ferase("QUERYSB1")
	//Ferase("QUERYSZO")

Return

STATIC function fRelNoMDet
	*******************************************************************************
	*                        funcao para imprimir detalhe                         *
	*******************************************************************************
	Local wVl11Me  := 0
	Local wVl1Ano  := 0
	Local wVl2Ano  := 0
	Local wVl3Ano  := 0
	Local WNoCdMat := space(15)

	if NoAnoM = 0     //  11 meses
		wVl11Me := NoQtd * NoValor
	elseif NoAnoM = 1 //  1§ Ano
		wVl1Ano := NoQtd * NoValor
	elseif NoAnoM = 2 //  2§ Ano
		wVl2Ano := NoQtd * NoValor
	elseif NoAnoM = 3 //  3§ Ano
		wVl3Ano := NoQtd * NoValor
	endif

	WNoCdMat := NoCdMat

	dbSelectArea("SB1") // Arquivo Cadastro de Material
	dbseek(xfilial()+ WNoCdMat)
	wm1descr := B1_DESC

	WDATA=CTOD('  /  /  ')
	dbSelectArea (warq1)
	If cEmpAnt == "01"
		_CWDATA:= NoEntr
	else
		_CWDATA:= NoPent
	ENDIF


	IF mv_par05 = 1
		@wlin,000 PSAY "  "+ NoCdMat +"   "+ wm1descr +"   "+NoGRUPO+"  "+ str(NoQtd,8,2);
			+"   "+ TRANSFORM(NoValor,"@E 9,999,999.99");
			+"   "+ TRANSFORM(wVl11Me,"@E 9,999,999.99");
			+"   "+ TRANSFORM(wVl1Ano,"@E 9,999,999.99");
			+"   "+ TRANSFORM(wVl2Ano,"@E 9,999,999.99");
			+"   "+ TRANSFORM(wVl3Ano,"@E 9,999,999.99");
			+"   "+ dtoc(NoUMov)                        ;
			+"   "+ dtoc(NoUSaida)						;
			+"   "+ dtoc(_cWDATA)

	ELSE
		@wlin,000 PSAY "  "+ NoCdMat +"   "+ wm1descr +"   "+NoGRUPO+"  "+ str(NoQtd,8,2);
			+"   "+ TRANSFORM(NoValor        ,"@E 9,999,999.99");
			+"   "+ SPACE(12)                                   ;
			+"   "+ TRANSFORM(wVl1Ano+wVl2Ano,"@E 9,999,999.99");
			+"   "+ SPACE(12)                                   ;
			+"   "+ TRANSFORM(wVl3Ano        ,"@E 9,999,999.99");
			+"   "+ dtoc(NoUMov)                                ;
			+"   "+ dtoc(NoUSaida)						        ;
			+"   "+ dtoc(_CWDATA)

	ENDIF
	wQtTotal   := wQtTotal   + NoQtd
	w11MeTotal := w11MeTotal + wVl11Me
	w1AnoTotal := w1AnoTotal + wVl1Ano
	w2AnoTotal := w2AnoTotal + wVl2Ano
	w3AnoTotal := w3AnoTotal + wVl3Ano
	wlin := wlin + 1
return .t.
*fim da function fRelNoMDet

STATIC function fRelNoMTot
	*******************************************************************************
	*                        funcao para imprimir total                           *
	*******************************************************************************
	@wlin,000 PSAY replicate("-",200)

	wlin := wlin + 1

	IF mv_par05 = 1
		@wlin,000 PSAY "  TOTAL                                                                        ";
			+ STR(wQtTotal,8,2)                      				+"   ";
			+ space(12)                              				+"   ";
			+ TRANSFORM(w11MeTotal,"@E 9,999,999.99")				+"   ";
			+ TRANSFORM(w1AnoTotal,"@E 9,999,999.99")				+"   ";
			+ TRANSFORM(w2AnoTotal,"@E 9,999,999.99")				+"   ";
			+ TRANSFORM(w3AnoTotal,"@E 9,999,999.99")				+"   ";
			+ space(08)
		wlin := wlin + 1
		@wlin,000 PSAY "                                                                                                                                       ";
			+ STR(w1AnoTotal+w2AnoTotal,12,2) +"                            "
	ELSE
		@wlin,000 PSAY "  TOTAL                                                                        ";
			+ STR(wQtTotal,8,2)										+"   ";
			+ space(12) 	    									+"   ";
			+ space(12)         									+"   ";
			+ TRANSFORM(w1AnoTotal+w2AnoTotal,"@E 9,999,999.99") 	+"   ";
			+ SPACE(12)                                        		+"   ";
			+ TRANSFORM(w3AnoTotal,"@E 9,999,999.99")            	+"   ";
			+ space(08)
	ENDIF

	wlin := wlin + 1

	@wlin,000 PSAY replicate("-",200)

	wQtTotal   := 0
	w11MeTotal := 0
	w1AnoTotal := 0
	w2AnoTotal := 0
	w3AnoTotal := 0

return .t.
*fim da function fRelNoMTot

STATIC function fRelNoM11Me
	*******************************************************************************
	*                 funcao para verificar nos ultimos 11 meses                            *
	*******************************************************************************
	wQtdPeriodo := 0
	******************* Movimentacao no Arquivo SD2 ************************
	dbSelectArea("SD2") // arquivo Kardex de Saida de Material
	dbseek(xfilial()+ wm1cdmat +MV_PAR11+ dtos(wDtIni11Me) ,.T.)
	do while ! eof() .AND. D2_COD = wm1cdmat ;
			.AND. D2_EMISSAO <= wDtAtual ;
			.AND. xFilial("SD2") == SD2->D2_FILIAL;
			.AND. D2_LOCAL == MV_PAR11
		DbSelectArea("SF4")
		dbseek(xfilial("SF4")+SD2->D2_TES)
		dbSelectArea("SD2") // arquivo Kardex de Saida de Material
		IF SF4->F4_ESTOQUE == "S"
			wQtdPeriodo := wQtdPeriodo + D2_QUANT
			wUltimaMov  := D2_EMISSAO
		ENDIF
		DbSkip()
	enddo

	******************* Movimentacao no Arquivo SD3 ************************
	dbSelectArea("SD3") // arquivo Kardex de Saida de Material
	dbseek(xfilial( "SD3" )+ wm1cdmat +MV_PAR11+ dtos(wDtIni11Me) ,.T.)

	do while ! eof() .and. D3_COD = wm1cdmat               ;
			.and. D3_EMISSAO <= wDtAtual           ;
			.AND. xFilial("SD3") == SD3->D3_FILIAL;
			.and. D3_LOCAL == mv_par11


		/*	if D3_TM <  "500" .OR. D3_TM == "650" .OR.	D3_TM == "651" .OR. D3_TM == "652"
		DbSkip()
		loop
		endif*/

		wQtdPeriodo := wQtdPeriodo + D3_QUANT
		if wUltimaMov < D3_EMISSAO
			wUltimaMov := D3_EMISSAO
		endif
		DbSkip()
	enddo

	******************* Movimentacao no Arquivo  ************************

	if wQtdPeriodo = 0    // se Nao deve movimentacao
		w11MeTemMov := "N"
	else
		w11MeTemMov := "S"
	endif
return .t.
*fim da function fRelNoM11Me


STATIC function fRelNoM1Ano
	*******************************************************************************
	*                     funcao para verificar no ultimo ano                     *
	*******************************************************************************
	wQtdPeriodo := 0

	******************* Movimentacao no Arquivo SD2 ************************
	dbSelectArea("SD2") // arquivo Kardex de Saida de Material
	dbseek(xfilial()+ wm1cdmat +MV_PAR11+ dtos(wDtIni) ,.T.)
	do while ! eof() .AND. D2_COD = wm1cdmat ;
			.AND. D2_EMISSAO <= wDtAtual;
			.AND. xFilial("SD2") == SD2->D2_FILIAL;
			.AND. D2_LOCAL == MV_PAR11
		DbSelectArea("SF4")
		dbseek(xfilial("SF4")+SD2->D2_TES)
		dbSelectArea("SD2") // arquivo Kardex de Saida de Material
		IF SF4->F4_ESTOQUE == "S"
			wQtdPeriodo := wQtdPeriodo + D2_QUANT
			wUltimaMov  := D2_EMISSAO
		ENDIF
		DbSkip()
	enddo


	******************* Movimentacao no Arquivo SD3 ************************
	dbSelectArea("SD3") // arquivo Kardex de Saida de Material
	dbseek(xfilial( "SD3" ) + wm1cdmat +MV_PAR11+ dtos(wDtIni) ,.T.)

	do while ! eof() .and. D3_COD = wm1cdmat                ;
			.and. D3_EMISSAO <= wDtAtual           ;
			.and. xFilial("SD3") == SD3->D3_FILIAL;
			.and. D3_LOCAL == mv_par11

		/*	if D3_TM <  "500" .OR. D3_TM == "650" .OR.	D3_TM == "651" .OR. D3_TM == "652"
		DbSkip()
		loop
		endif  */

		wQtdPeriodo := wQtdPeriodo + D3_QUANT
		IF wUltimaMov < D3_EMISSAO
			wUltimaMov  := D3_EMISSAO
		ENDIF
		DbSkip()
	enddo

	******************* Movimentacao no Arquivo SZO ************************

	if wQtdPeriodo = 0    // se Nao deve movimentacao
		w1AnoTemMov := "N"
	else
		w1AnoTemMov := "S"
	endif
return .t.
*fim da function fRelNoM1Ano

STATIC function fRelNoM2Ano
	*******************************************************************************
	*                     funcao para verificar no 2§ ano                         *
	*******************************************************************************
	wQtdPeriodo := 0

	******************* Movimentacao no Arquivo SD2 ************************
	dbSelectArea("SD2") // arquivo Kardex de Saida de Material
	dbseek(xfilial()+ wm1cdmat +MV_PAR11+ dtos(wDtIni2Ano) ,.T.)
	do while ! eof() .AND. D2_COD = wm1cdmat ;
			.AND. D2_EMISSAO <= wDtAtual ;
			.AND. xFilial("SD2") == SD2->D2_FILIAL;
			.AND. D2_LOCAL == MV_PAR11
		DbSelectArea("SF4")
		dbseek(xfilial("SF4")+SD2->D2_TES)
		dbSelectArea("SD2") // arquivo Kardex de Saida de Material
		IF SF4->F4_ESTOQUE == "S"

			wQtdPeriodo := wQtdPeriodo + D2_QUANT
			wUltimaMov  := D2_EMISSAO
		ENDIF
		DbSkip()
	enddo

	******************* Movimentacao no Arquivo SD3 ************************
	dbSelectArea("SD3") // arquivo Kardex de Saida de Material
	dbseek(xfilial( "SD3" ) + wm1cdmat +MV_PAR11+ dtos(wDtIni2Ano) ,.T.)
	do while ! eof() .and. D3_COD = wm1cdmat                 ;
			.and. D3_EMISSAO <= wDtAtual            ;
			.and. xFilial("SD3") == SD3->D3_FILIAL ;
			.and. D3_LOCAL == mv_par11

		/*	if D3_TM <  "500" .OR. D3_TM == "650" .OR.	D3_TM == "651" .OR. D3_TM == "652"
		DbSkip()
		loop
		endif  */

		wQtdPeriodo := wQtdPeriodo + D3_QUANT
		IF wUltimaMov < D3_EMISSAO
			wUltimaMov  := D3_EMISSAO
		ENDIF
		DbSkip()

	enddo

	******************* Movimentacao no Arquivo  ************************

	if wQtdPeriodo = 0    // se Nao deve movimentacao
		w2AnoTemMov := "N"
	else
		w2AnoTemMov := "S"
	endif
return .t.
*fim da function fRelNoM2Ano

STATIC function fRelNoM3Ano
	*******************************************************************************
	*                     funcao para verificar no 3§ ano                         *
	*******************************************************************************
	wQtdPeriodo := 0

	******************* Movimentacao no Arquivo SD2 ************************
	dbSelectArea("SD2") // arquivo Kardex de Saida de Material
	dbseek(xfilial()+ wm1cdmat +MV_PAR11+ dtos(wDtIni3Ano) ,.T.)
	do while ! eof() .AND. D2_COD = wm1cdmat ;
			.AND. D2_EMISSAO <= wDtAtual ;
			.AND. xFilial("SD2") == SD2->D2_FILIAL ;
			.AND. D2_LOCAL == MV_PAR11
		DbSelectArea("SF4")
		dbseek(xfilial("SF4")+SD2->D2_TES)
		dbSelectArea("SD2") // arquivo Kardex de Saida de Material
		IF SF4->F4_ESTOQUE == "S"

			wQtdPeriodo := wQtdPeriodo + D2_QUANT
			wUltimaMov  := D2_EMISSAO
		ENDIF
		DbSkip()
	enddo

	******************* Movimentacao no Arquivo SD3 ************************
	dbSelectArea("SD3") // arquivo Kardex de Saida de Material
	dbseek(xfilial( "SD3" ) + wm1cdmat +MV_PAR11+ dtos(wDtIni3Ano) ,.T.)
	do while ! eof() .and. D3_COD         =  wm1cdmat       ;
			.and. D3_EMISSAO     <= wDtAtual       ;
			.and. xFilial("SD3") == SD3->D3_FILIAL ;
			.and. D3_LOCAL       == mv_par11

		/*	if D3_TM <  "500" .OR. D3_TM == "650" .OR. D3_TM == "651" .OR. D3_TM == "652"
		DbSkip()
		loop
		endif*/

		wQtdPeriodo := wQtdPeriodo + D3_QUANT
		IF wUltimaMov < D3_EMISSAO
			wUltimaMov := D3_EMISSAO
		ENDIF
		DbSkip()
	enddo

	******************* Movimentacao no Arquivo  ************************

	if wQtdPeriodo == 0    // se Nao deve movimentacao
		w3AnoTemMov := "N"
	else
		w3AnoTemMov := "S"
	endif
return .t.
*fim da function fRelNoM3Ano

STATIC function fRelNoMCriaAtrq
	warq1 := "TR"+substr(time(),4,2)+substr(time(),7,2)
	aArqTrb := {}

	AADD(aArqTrb, {"NoAnoMes   ","C",06,0})     // Ano / Mes da movimentacao
	AADD(aArqTrb, {"NoCdMat    ","C",15,0})     // Codigo do material
	AADD(aArqTrb, {"NoQtd      ","N",12,2})     // Quantidade
	AADD(aArqTrb, {"NoGrupo    ","C",04,0})     // Grupo
	AADD(aArqTrb, {"NoValor    ","N",14,2})     // valor
	AADD(aArqTrb, {"NoUMov     ","D",08,0})     // Data da ultima movimentacao
	AADD(aArqTrb, {"NoEntr     ","D",08,0})     // Data da proxima entrada
	AADD(aArqTrb, {"NoPent     ","D",08,0})     // Data da proxima entrada
	AADD(aArqTrb, {"NoUSaida   ","D",08,0})     // Data da proxima entrada
	AADD(aArqTrb, {"NoAnoM     ","N",01,0})     // Ano do que nao movimentol
	AADD(aArqTrb, {"No3Ini     ","D",08,0})     // data inicio do 3 periodo
	AADD(aArqTrb, {"No3Fin     ","D",08,0})     // data final  do 3 periodo
	AADD(aArqTrb, {"No2Ini     ","D",08,0})     // data inicio do 2 periodo
	AADD(aArqTrb, {"No2Fin     ","D",08,0})     // data final  do 2 periodo
	AADD(aArqTrb, {"No1Ini     ","D",08,0})     // data inicio do 1 periodo
	AADD(aArqTrb, {"No1Fin     ","D",08,0})     // data final  do 1 periodo

	// cArqTrb := CriaTrab(aArqTrb,.T.)
	// DbUseArea(.T.,,cArqTrb,warq1,.F.,.F.)
	// cIndTrb := CriaTrab(,.F.)
	// DbCreateIndex(cIndTrb,"NoAnoMes",{|| NoAnoMes },IF(.F., .T., NIL))

	// Instancio o objeto
	oTable  := FwTemporaryTable():New( /* cFileTRB */ )
	// Adiciono os campos na tabela
	oTable:SetFields( aArqTrb )
	// Adiciono os índices da tabela
	oTable:AddIndex( '01' , { "NoAnoMes" })
	// Crio a tabela no banco de dados
	oTable:Create()
	//------------------------------------
	//Pego o alias da tabela temporária
	//------------------------------------
	cArqTrb := oTable:GetAlias()

return .t.
//---------------------------------------------------
User function FimMes(_parm1)
	private _DResp


	_parm1  := U_SomaMes(_parm1,1)  && acrescenta  1 (hum) mes na data
	_DResp  := ctod("01/"+strzero(month(_parm1),2,0)+"/"+strzero( year(_parm1),4,0))
	_DResp  := _DResp - 1           &&  1§ dia do mes seguinte - 1 (hum)
return _DResp

//--------------------------------------------------------
User function SomaMes(_parm1,_parm2)
	private _nDia,_nMes,_nAno,_dSomaAno,_dSomaMes,_DResp


	_dSomaAno := int(_parm2/12)
	_dSomaMes := _parm2 - (_dSomaAno*12)
	_nDia     := day  (_parm1)
	_nMes     := month(_parm1) + _dSomaMes
	_nAno     := year (_parm1) + _dSomaAno
	if _nMes < 1
		_nMes := _nMes + 12
		_nAno := _nAno - 1
	elseif _nMes > 12
		_nMes := _nMes - 12
		_nAno := _nAno + 1
	endif

	if strzero(_nMes,2,0) $ "04.06.09.11" .and. _nDia > 30
		_nDia := 30
	elseif _nMes = 02
		if _nAno/4 = int(_nAno/4) .and. _nDia > 29
			_nDia := 29
		elseif _nDia > 28
			_nDia := 28
		endif
	endif

	set century on
	_DResp := ctod(str(_nDia,2,0)+"/"+str(_nMes,2,0)+"/"+str(_nAno,4,0) )
	set century off
return _DResp
