#Include 'Protheus.ch'
#INCLUDE "TOTVS.CH"

User Function GVerbFer()
	// LOCAL LAMB := RpcSetEnv("03",'01',,,,GetEnvServer(,{}))
	Local aPergs   := {}
	Local cMatric  := Space(TamSX3("RA_MAT")[01])
	Local cMatric1 := Space(TamSX3("RA_MAT")[01])
	Local nper 	   := 1
	Local aPeriodo := {}
	Private XPER

	// monta os periodos para o combobox
	aPeriodo := {LEFT(DTOS(MonthSub(DATE(),2)),6),LEFT(DTOS(MonthSub(DATE(),1)),6),LEFT(DTOS(DATE()),6),LEFT(DTOS(MonthSum(DATE(),1)),6),LEFT(DTOS(MonthSum(DATE(),2)),6)}

	aAdd(aPergs, {1, "Matricula De :",  cMatric,   "", ".T.", "SRA",".T.", 80 , .T.})
	aAdd(aPergs, {1, "Matricula Ate:",  cMatric1,  "", ".T.", "SRA",".T.", 80 , .F.})
	aAdd(aPergs, {2, "Periodo: ", nper,    aPeriodo,     122, ".T.", .F.})

	If ParamBox(aPergs, "Informe os parâmetros")
		XPER := IIF(VALTYPE(MV_PAR03)== "N", VAL(aPeriodo[MV_PAR03]),val(MV_PAR03))
		RptStatus({|| fProssess()}, "Aguarde...", "Executando rotina...")
	endif

Return

/*/{Protheus.doc} fProssess/*/

Static Function fProssess()
	Local NX 	   := 0
	Local nz 	   := 0
	Local nAtual := 0
	Local nTotal := 0
	Local cVerbaJaGravada := ''
	Local cVerbaNaoGrav   := ''
	Local cVbGravProcesso := ''
	Local x778FOL  := 0
	Local xA01FOL  := 0
	Local xA05FOL  := 0
	Local x779TERC := 0
	Local xA02TERC := 0
	Local xA06TERC := 0
	Local x780ACID := 0
	Local xA03ACID := 0
	Local xA07ACID := 0
	Local x732FGT  := 0
	Local xA04FGT  := 0
	Local xA08FGT  := 0
	Local X778BAS  := 0
	Local X779BAS  := 0
	Local X780BAS  := 0
	Local X732BAS  := 0
	Local xB04FGT  :=0
	Local xB08FGT  :=0
	Local x740FGT  :=0
	Local X740BAS  :=0
	Local nValorVerba := 0
	Local aVerba :=  {'A09','A10','A11','A12','B12'}
	Private cAliasSRC := ''

	cAliasSRC := GetNextAlias()

	IF SELECT(cAliasSRC)  > 0
		cAliasSRC->(DBCLOSEAREA())
	endif

	BEGINSQL alias cAliasSRC

		SELECT RC_FILIAL,
				RC_DTREF,
				RC_TIPO2,
				RC_CC,
				RC_DATA,
				RC_PERIODO,
				RC_PROCES,
				RC_VALOR,
				RC_SEMANA,
				RC_MAT,RC_PD,RC_VALORBA
		from %table:SRC% SRC
		WHERE SRC.D_E_L_E_T_='' and 
		RC_MAT BETWEEN  %EXP:MV_PAR01% AND  %EXP:MV_PAR02%
		AND RC_PERIODO = %EXP:XPER% 
	EndSQL

	//Conta quantos registros existem, e seta no tamanho da r�gua
	Count To nTotal
	SetRegua(nTotal)

	(cAliasSRC)->(DBGOTOP())
	while !(cAliasSRC)->(EoF())

		//Incrementa a mensagem na r�gua
		nAtual++
		IncRegua()

		_cFilial  := (cAliasSRC)->RC_FILIAL
		_cMat	  := (cAliasSRC)->RC_MAT
		cRoteiro  := 'FOL'
		dDataRef  := STOD((cAliasSRC)->RC_DTREF)
		cTipo2    := (cAliasSRC)->RC_TIPO2
		cCc       := (cAliasSRC)->RC_CC
		dDataPag  := STOD((cAliasSRC)->RC_DATA)
		cPeriodo  := (cAliasSRC)->RC_PERIODO
		cProcess  := (cAliasSRC)->RC_PROCES
		cSemana   := (cAliasSRC)->RC_SEMANA

		// VERIFICAR SE AS VERBAS JA FORAM GRAVADA PARA NÃO DUPLICAR
		NPOS     := ASCAN(aVerba , { |x| x == (cAliasSRC)->RC_PD } )
		if NPOS > 0
			cVerbaJaGravada += aVerba[NPOS] + ', '
			//Deleta o elemento na posição encontrada (npos) , move os outros para trás
			ADel(aVerba, nPos)
			// Se quiser encurtar removendo o NIL da última posição:
			ASize(aVerba, Len(aVerba)-1)
		endif

		if (cAliasSRC)->RC_PD == '778' .OR.;  // INSS EMPRESA FOLHA
			(cAliasSRC)->RC_PD == 'A01'  .OR.; // INSS EMPRESA FERIAS
			(cAliasSRC)->RC_PD == 'A05'  // INSS EMPRESA  DECIMO

			if (cAliasSRC)->RC_PD == '778'
				x778FOL := (cAliasSRC)->RC_VALOR  // INSS EMPRESA FOLHA
				X778BAS := (cAliasSRC)->RC_VALORBA
			elseif (cAliasSRC)->RC_PD == 'A01'
				xA01FOL := (cAliasSRC)->RC_VALOR  // INSS EMPRESA FERIAS
			else
				xA05FOL := (cAliasSRC)->RC_VALOR  // INSS EMPRESA  DECIMO
			endif

		elseIF (cAliasSRC)->RC_PD == '779'.OR.;  // TERCEIROS EMPRESA FOLHA
			(cAliasSRC)->RC_PD == 'A02'  .OR.; // TERCEIROS EMPRESA FERIAS
			(cAliasSRC)->RC_PD == 'A06'  // TERCEIROS EMPRESA  DECIMO

			if (cAliasSRC)->RC_PD == '779'
				x779TERC := (cAliasSRC)->RC_VALOR  // TERCEIROS EMPRESA FOLHA
				X779BAS := (cAliasSRC)->RC_VALORBA
			elseif (cAliasSRC)->RC_PD == 'A02'
				xA02TERC := (cAliasSRC)->RC_VALOR  // TERCEIROS EMPRESA FERIAS
			else
				xA06TERC := (cAliasSRC)->RC_VALOR  // TERCEIROS EMPRESA  DECIMO
			endif

		elseIF (cAliasSRC)->RC_PD == '780' .OR.;  // ACIDENTE TRAB. FOLHA
			(cAliasSRC)->RC_PD == 'A03'  .OR.; //  ACIDENTE TRAB. FERIAS
			(cAliasSRC)->RC_PD == 'A07'  //  ACIDENTE TRAB.  DECIMO

			if (cAliasSRC)->RC_PD == '780'
				x780ACID := (cAliasSRC)->RC_VALOR  //  ACIDENTE TRAB. FOLHA
				X780BAS := (cAliasSRC)->RC_VALORBA
			elseif (cAliasSRC)->RC_PD == 'A03'
				xA03ACID := (cAliasSRC)->RC_VALOR  //  ACIDENTE TRAB. FERIAS
			else
				xA07ACID := (cAliasSRC)->RC_VALOR  //  ACIDENTE TRAB.  DECIMOX
			endif
		elseIF (cAliasSRC)->RC_PD == '732' .OR.;  // FGTS FOLHA
			(cAliasSRC)->RC_PD == 'A04'  .OR.; //  FGTS FERIAS
			(cAliasSRC)->RC_PD == 'A08'  //  FGTS  DECIMO

			if (cAliasSRC)->RC_PD == '732'
				x732FGT := (cAliasSRC)->RC_VALOR  // FGTS EMPRESA FOLHA
				X732BAS := (cAliasSRC)->RC_VALORBA
			elseif (cAliasSRC)->RC_PD == 'A04'
				xA04FGT := (cAliasSRC)->RC_VALOR  // FGTS EMPRESA FERIAS
			else
				xA08FGT := (cAliasSRC)->RC_VALOR  // FGTS EMPRESA  DECIMO
			endif
		elseIF (cAliasSRC)->RC_PD == '740' .OR.;  // FGTS FOLHA
			(cAliasSRC)->RC_PD == 'B04'  .OR.; //  FGTS FERIAS
			(cAliasSRC)->RC_PD == 'B08'  //  FGTS  DECIMO

			if (cAliasSRC)->RC_PD == '740'
				x740FGT := (cAliasSRC)->RC_VALOR  // FGTS EMPRESA FOLHA
				X740BAS := (cAliasSRC)->RC_VALORBA
			elseif (cAliasSRC)->RC_PD == 'B04'
				xB04FGT := (cAliasSRC)->RC_VALOR  // FGTS EMPRESA FERIAS
			else
				xB08FGT := (cAliasSRC)->RC_VALOR  // FGTS EMPRESA  DECIMO
			endif
		endif
		(cAliasSRC)->(DBSKIP())
	EndDo

	cVerbaJaGravada := substr(cVerbaJaGravada,1,len(cVerbaJaGravada)-2)

	For nz := 1 To Len(aVerba)
		cVerbaNaoGrav += aVerba[nz]
		If nz < Len(aVerba)
			cVerbaNaoGrav += ","
		EndIf
	Next nz
	FWAlertWarning(IIF(!Empty(cVerbaJaGravada),'As Verbas '+cVerbaJaGravada+' ja estao lancadas na folha.','')+	iif(!Empty(cVerbaNaoGrav),'Seram lancadas as verbas '+cVerbaNaoGrav +".",'Nao ha verbas a serem lancadas por essa rotina.'), 'Atencao')


	for nX := 1 to Len(aVerba)
		nValorVerba := 0
		nValorBase  := 0
		cVerba := ''

		if aVerba[nX] == 'A09'
			nValorVerba := (xA01FOL + xA05FOL)  // VERBA INSS EMPRESA
			nValorVerba := IIF((x778FOL - nValorVerba)<=0,x778FOL,(x778FOL - nValorVerba))  // DIFERENCA INSS EMPRESA
			cVerba := aVerba[nX]
			nValorBase := X778BAS    // valor base
		elseif aVerba[nX] == 'A10'
			nValorVerba := (xA02TERC + xA06TERC)  // VERBA TERCEIRO EMPRESA
			nValorVerba := IIF((x779TERC - nValorVerba)<=0,x779TERC,(x779TERC - nValorVerba))  // DIFERENCA TERCEIRO EMPRESA
			cVerba := aVerba[nX]
			nValorBase := X779BAS    // valor base
		elseif aVerba[nX] == 'A11'
			nValorVerba := (xA03ACID + xA07ACID)  // VERBA ACID TRAB EMPRESA
			nValorVerba := IIF((x780ACID - nValorVerba)<=0,x780ACID,(x780ACID - nValorVerba))  // DIFERENCA ACID TRAB EMPRESA
			cVerba := aVerba[nX]
			nValorBase := X780BAS    // valor base
		elseif aVerba[nX] == 'A12'
			nValorVerba :=(xA04FGT + xA08FGT)  // VERBA FGTS EMPRESA
			nValorVerba := IIF((x732FGT - nValorVerba)<=0,x732FGT,(x732FGT - nValorVerba))  // DIFERENCA FGTS EMPRESA
			cVerba := aVerba[nX]
			nValorBase := X732BAS    // valor base
		elseif aVerba[nX] == 'B12'
			nValorVerba :=( xB04FGT + xB08FGT)  // VERBA FGTS EMPRESA			
			nValorVerba := IIF((x740FGT - nValorVerba)<=0,x740FGT,(x740FGT - nValorVerba))  // DIFERENCA FGTS EMPRESA
			cVerba := aVerba[nX]
			nValorBase := X740BAS    // valor base
		endif

		if nValorVerba > 0
			SRC->(DBSETORDER(4))
			if SRC->(MSSEEK(_cFilial+_cMat+cPeriodo+cRoteiro+cSemana))
				Reclock('SRC',.T.)
				SRC->RC_FILIAL  := _cFilial
				SRC->RC_MAT     := _cMat
				SRC->RC_PD      := cVerba
				// SRC->RC_NOME    := (cAliasSRC)->RC_NOME
				SRC->RC_VALOR   := nValorVerba
				SRC->RC_VALORBA := nValorBase
				SRC->RC_TIPO1   := 'V'
				SRC->RC_DTREF  	:= dDataRef
				SRC->RC_TIPO2   := cTipo2
				SRC->RC_PERIODO := cPeriodo
				SRC->RC_ROTEIR  := cRoteiro
				SRC->RC_SEMANA  := '01'
				SRC->RC_DATA 	:= dDataPag
				SRC->RC_CC      := cCc
				SRC->RC_PROCES  := cProcess
				SRC->(MSUNLOCK())

				cVbGravProcesso += aVerba[NX]
				If nX < Len(aVerba)
					cVbGravProcesso += ","
				EndIf

			endif
		endif
	next nX

	if !Empty(cVbGravProcesso)  // se tiver verba gravada
		FWAlertSuccess('As verbas '+cVbGravProcesso+ ' foram lancadas com sucesso.' ,'Sucesso!!!')
	else
		FWAlertWarning('Nenhuma verba foi lancada por essa rotina.' ,'Atencao!!!')
	endif

	(cAliasSRC)->(DBCLOSEAREA())
Return
