#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RGPER02  ³ Autor ³ Eduardo Clemente      ³ Data ³ 19/01/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao de Recibos de Pagamento                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RGPER01(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
//RECPA4
User Function AAGPER01()   
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis Locais (Basicas)                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local cString := "SRA"        // alias do arquivo principal (Base)
	Local aOrd    := {"Matricula","C.Custo + Matr.","Nome","C.Custo + Nome"} 
	Local cDesc1  := "Emiss„o de Recibos de Pagamento."
	Local cDesc2  := "Ser  impresso de acordo com os parametros solicitados pelo"
	Local cDesc3  := "usuario."

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis Locais (Programa)                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local nExtra, cIndCond, cIndRc
	Local Baseaux := "S"
	Local cDemit  := "N"
	Public _oPrint

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis Private(Basicas)                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }	//"Zebrado"###"Administra‡„o"
	Private nomeprog := "RGPER01"
	Private aLinha   := { },nLastKey := 2
	Private cPerg    := "RGPE01"
	Private cSem_De  := "  /  /    "
	Private cSem_Ate := "  /  /    "
	Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe
	Private cCompac , cNormal
	Private aDriver

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis Private(Programa)                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aFunc    := {}
	Private aProve   := {}
	Private aDesco   := {}
	Private aBases   := {}
	Private aInfo    := {}
	Private aCodFol  := {}
	Private li       := _PROW()
	Private Titulo   := "EMISSAO DE RECIBOS DE PAGAMENTOS"
	Private nTamanho := "M"
	Private limite	 := 132

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fValidSX1()
	Pergunte("RGPE01",.T.)
	wnrel  := "RGPER01"            //Nome Default do relatorio em Disco
	wnrel  := SetPrint(cString,wnrel   ,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,   ,nTamanho )
	nOrdem :=  aReturn[8]

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dDataRef   := mv_par01                     	// Data Referencia
	nTipRel    := 1                            	// Tipo de Impressão
	Esc        := mv_par02
	cFilDe     := mv_par03						//Filial De
	cFilAte    := mv_par04						//Filial Ate
	cCcDe      := mv_par05						//Centro de Custo De
	cCcAte     := mv_par06						//Centro de Custo Ate
	cMatDe     := mv_par07						//Matricula Des
	cMatAte    := mv_par08						//Matricula Ate
	cNomDe     := mv_par09						//Nome De
	cNomAte    := mv_par10						//Nome Ate
	Mensag11   := substr(mv_par11,1,1)			//Mensagem 1
	Mensag12   := substr(mv_par11,2,1)			//Mensagem 1
	Mensag21   := substr(mv_par12,1,1)			//Mensagem 2
	Mensag22   := substr(mv_par12,2,1)			//Mensagem 1
	Mensag31   := substr(mv_par13,1,1)			//Mensagem 3
	Mensag32   := substr(mv_par13,2,1)			//Mensagem 1
	Mensag4    := mv_par14						//Mensagem 3
	Mensag5    := mv_par15						//Mensagem 3
	cSituacao  := mv_par16						//Situacoes a Imprimir
	cCategoria := mv_par17						//Categorias a Imprimir
	cBaseAux   := If(mv_par18 == 1,"S","N")	//Imprimir Bases
	cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
	cAnoMesRef := StrZero(Year(dDataRef),4) + StrZero(Month(dDataRef),2)  
	cAnoRef13  := StrZero(Year(dDataRef),4)

	If aReturn[5] == 1 .and. nTipRel == 1
		li	:=  0
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa Impressao                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !fInicia(cString,nTipRel)
		Return
	Endif

	RptStatus({|lEnd| R030ImpL(@lEnd,wnRel,cString,cMesAnoRef)},Titulo)  // Chamada do Relatorio

Return(  NIL )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R030IMP  ³ Autor ³ Eduardo Clemente      ³ Data ³ 19.01.15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento Para emissao do Recibo                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function R030ImpL(lEnd,WnRel,cString,cMesAnoRef)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis Locais (Basicas)                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local lIgual                 //Vari vel de retorno na compara‡ao do SRC
	Local cArqNew                //Vari vel de retorno caso SRC # SX3
	Local aOrdBag     := {}
	Local cMesArqRef  := If(Esc == 4,"13"+Right(cMesAnoRef,4),cMesAnoRef)
	Local cArqMov     := ""
	Local cNroHoras   := &("{ || If(SRC->RC_QTDSEM > 0, SRC->RC_QTDSEM, SRC->RC_HORAS) }")
	Local nHoras      := 0
	Local nMes, nAno

	Public cCodFunc	  := ""		//-- codigo da Funcao do funcionario
	Public cDescFunc  := ""		//-- Descricao da Funcao do Funcionario
	Public _n         := 1

	Private aCodBenef   := {}
	Private cDtPago
	Private cAliasMov := ""
	Private cPict1	  := "@E 999,999,999.99"
	Private cPict2    := "@E 99,999,999.99"
	Private cPict3    := "@E 999,999.99"

	If MsDecimais(1) == 0
		cPict1	:=	"@E 99,999,999,999"
		cPict2 	:=	"@E 9,999,999,999"
		cPict3 	:=	"@E 99,999,999"
	Endif

	If Esc == 4
		cMesArqRef := "13" + Right(cMesAnoRef,4)
	Else
		cMesArqRef := cMesAnoRef
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Verifica se existe o arquivo de fechamento do mes informado  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, @dDataRef , NIL  )
		Return(  NIL  )
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Selecionando a Ordem de impressao escolhida no parametro.    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "SRA")
	If nOrdem == 1      // RA_FILIAL+RA_MAT
		dbSetOrder(1)
	ElseIf nOrdem == 2  // RA_FILIAL+RA_CC+RA_MAT
		dbSetOrder(2)
	ElseIf nOrdem == 3  // RA_FILIAL+RA_NOME+RA_MAT
		dbSetOrder(3)
	ElseIf nOrdem == 4  // RA_FILIAL+RA_CC + RA_NOME
		dbSetOrder(8)
	Endif
	dbGoTop()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Selecionando o Primeiro Registro e montando Filtro.          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOrdem == 1
		cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
		dbSeek(cFilDe + cMatDe,.T.)
		cFim    := cFilAte + cMatAte
	ElseIf nOrdem == 2
		dbSeek(cFilDe + cCcDe + cMatDe,.T.)
		cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
		cFim     := cFilAte + cCcAte + cMatAte
	ElseIf nOrdem == 3
		dbSeek(cFilDe + cNomDe + cMatDe,.T.)
		cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
		cFim    := cFilAte + cNomAte + cMatAte
	ElseIf nOrdem == 4
		dbSeek(cFilDe + cCcDe + cNomDe,.T.)
		cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
		cFim     := cFilAte + cCcAte + cNomAte
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Regua Processamento                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SRA")
	SetRegua(RecCount())	// Total de elementos da regua

	aFunc      :={}         // Zera Lancamentos
	aProve     :={}         // Zera Lancamentos
	aDesco     :={}         // Zera Lancamentos
	aBases     :={}         // Zera Lancamentos
	aImpos     :={}         // Zera Lancamentos
	DESC_MSG   :={}
	FLAG       := 0
	CHAVE      := 0
	Desc_Fil   := Desc_End := DESC_CC:= DESC_FUNC:= ""
	DESC_MSG1  := DESC_MSG2:= DESC_MSG3:= Space(01)
	DESC_MSG4  := DESC_MSG5:= Space(62)
	cFilialAnt := "  "
	Vez        := 0
	OrdemZ     := 0

	Do While SRA->( !Eof() .And. &cInicio <= cFim )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Movimenta Regua Processamento                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IncRegua()  // Anda a regua

		If lEnd
			@Prow()+1,0 PSAY cCancel
			Exit
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste Parametrizacao do Intervalo de Impressao            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (SRA->RA_NOME < cNomDe) .Or. (SRA->Ra_NOME > cNomAte) .Or. (SRA->RA_MAT < cMatDe) .Or. (SRA->Ra_MAT > cMatAte) .Or. ;
		(SRA->RA_CC < cCcDe)    .Or. (SRA->Ra_CC > cCcAte)
			SRA->(dbSkip(1))
			Loop
		EndIf

		nAteLim   := 0.00 
		nBaseFgts := 0.00
		nFgts     := 0.00
		nBaseIr   := 0.00
		nBaseIrFe := 0.00
		Ordem_rel := 1     // Ordem dos Recibos

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica Data Demissao         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cSitFunc  := SRA->RA_SITFOLH
		dDtPesqAf := CTOD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4))
		If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
			cSitFunc := " "
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste situacao e categoria dos funcionarios			     |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !( cSitFunc $ cSituacao ) .OR. !( SRA->RA_CATFUNC $ cCategoria )
			dbSkip()
			Loop
		Endif
		
		If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
			dbSkip()
			Loop
		Endif

		aArea	:= SRA->(GetArea())
		fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )
		cCodCBO	:= fCodCBO(xFilial("SRJ"),cCodFunc ,dDataRef)
		cDescCC	:= Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01")
		RestArea( aArea ) 


		//Adiciona dados do Funcionario
		aAdd(aFunc,{SRA->RA_MAT, Left(SRA->RA_NOME,28), cCodCBO, SRA->RA_CC, cDescCC,	SRA->RA_Filial, TRANSFORM(strzero(ORDEM_REL,3),"9999"),;
		cCodFunc, cDescFunc, SRA->RA_SALARIO, MONTH(SRA->RA_NASC),	Substr(Sra->Ra_BcDepSal,1,3), SRA->RA_BCDEPSAL, SRA->RA_CTDEPSAL})

		If SRA->RA_Filial # cFilialAnt
			If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
				Exit
			Endif
			Desc_Fil  := aInfo[3]
			Desc_End  := aInfo[4]         // Dados da Filial
			Desc_CGC  := aInfo[8]
			DESC_MSG1 := DESC_MSG2 := DESC_MSG3 := Space(01)
			DESC_MSG4 := DESC_MSG5 := Space(62)

			// MENSAGENS
			dbSelectArea("SRA")
			cFilialAnt := SRA->RA_FILIAL
		Endif

		//Adiciona Mensagens
		aAdd(DESC_MSG,{DESC_MSG1,DESC_MSG2,DESC_MSG3,DESC_MSG4,DESC_MSG5})
		dbSelectArea("SRA")	

		If nTipRel == 1
			If Vez = 0  .and. nTipRel # 3  .and. aReturn[5] # 1
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Descarrega teste de impressao                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Endif
		Endif

		dbSelectArea("SRA")
		SRA->( dbSkip() )
		_TOTDESC := 0
		_TOTVENC := 0
		_n++

	EndDo

	// Impressao do Recibo de Pagamento
	fImpressaoL()   

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty( cAliasMov )
		fFimArqMov( cAliasMov , aOrdBag , cArqMov )
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Termino do relatorio                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SRC")
	dbSetOrder(1)          // Retorno a ordem 1
	dbSelectArea("SRI")
	dbSetOrder(1)          // Retorno a ordem 1
	dbSelectArea("SRA")
	SET FILTER TO
	RetIndex("SRA")

	If !(Type("cArqNtx") == "U")
		fErase(cArqNtx + OrdBagExt())
	Endif


Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fImpressao³ Autor ³ Eduardo Clemente      ³ Data ³ 19.01.14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO DO RECIBO                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fImpressao()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpressaoL()

	Local nConta  	:= nContr := nContrT:=0
	Local aDriver 	:= LEDriver()
	Local _i        := 0
	Local _aPos1    := {2000, 1900, 2100, 2300}
	Local _aPos2    := {2270, 1900, 2340, 2300}
	Local _aBmp 	:= {}
	Local _aEmp 	:= {}
	Local _oFont8   := Nil
	Local _oFont10  := Nil
	Local _oFont12  := Nil
	Local _oFont16  := Nil
	Local _oFont16n := Nil
	Local _oFont24  := Nil
	Local _oBrush   := Nil
	Local cString   := ""
	Local nCol 		:= 0
	Local _lmesmo 	:= .F.
	Local _cont		:= 0
	Local _pag 		:= 0

	Private TOTVENC  := {}
	Private TOTDESC  := {}
	Private aLanca   := {}
	Private aImpos   := {}
	Private nLinhas	 := 30              // Numero de Linhas do Miolo do Recibo
	Private cCompac  := aDriver[1]
	Private cNormal  := aDriver[2]
	Private _tipofol := ""


	Ordem_Rel := 1
	_oPrint   := TMSPrinter():New( "HOLERITEGRAFICO" )
	_oPrint:SetPortrait() // ou SetLandscape()

	// Fontes da Impressão
	_oFont8   := TFont():New("Courier", 09, 08,   ,.F.,  ,   ,  ,    , .F.) //12
	_oFont10  := TFont():New("Courier", 09, 10,.T.,.F., 5,.T., 5, .T., .F.)
	_oFont12  := TFont():New("Courier", 09, 10,.T.,.F., 5,.T., 5, .T., .F.)
	_oFont16  := TFont():New("Courier", 09, 10,.T.,.F., 5,.T., 5, .T., .F.)
	_oFont16n := TFont():New("Courier", 09, 10,.T.,.T., 5,.T., 5, .T., .F.)
	_oFont24  := TFont():New("Courier", 09, 10,.T.,.T., 5,.T., 5, .T., .F.)
	_oFontCP  := TFont():New("Arial", 09, 09,.T.,.T., 5,.T., 5, .T., .F.)
	_oBrush   := TBrush():New("",4)

	DEFINE PEN oPenCP WIDTH 3 COLOR CLR_GRAY

	Z := 2

	For _I := 1 TO Len(aFunc)

		aLanca    := {}  // Zera Lancamentos
		TOTVENC   := {}  // Zera Vencimentos
		TOTDESC   := {}  // Zera Descontos
		aImpos    := {}  // Zera Impostos
		llanca(aFunc[_I][1],aFunc[_I][4],aFunc[_I][6])	
		_nctaz    := 1
		_MaxLin   := 14  // Maximo de Linhas nos Lancamentos
		nDivisao  := (Len(aLanca) / _MaxLin)
		_StopLanc := 0

		If Int(nDivisao) <> nDivisao // Calculo de numeros paginas necessarios para mostrar TODOS os lançamentos
			_pag := Int(nDivisao) + 1
		Else
			_pag := nDivisao
		Endif

		For y := 1 to _pag

			If Z == 1
				Z := 2
			Else
				_cont := -50
				_oPrint:StartPage()   // Inicia uma nova página
				Z := 1
			End If

			//Imprime duas vezes na mesma pagina
			//		For z:= 1 to 2

			//Adiciona dados da Empresa e Filial do Funcionario
			dbSelectArea("SM0")
			dbSetOrder(1)
			dbSeek(cEmpAnt+aFunc[_I][6],.T.)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

			Do Case
				Case MV_PAR02 = 1
				_tipoFol:= "ADI"
				Case MV_PAR02 = 2
				_tipoFol:= "FOLHA"
				Case MV_PAR02 = 3
				_tipoFol:= "13 SAL. PARC. 1"
				Case MV_PAR02 = 4
				_tipoFol:= "13 SAL. PARC. 2"
				Case MV_PAR02 = 5
				_tipoFol:= "VALORES EXTRAS"
			EndCase  

			_oPrint:Box(_cont+0100,0130, _cont+0230, 2250)  																// Primeiro Box
			_oPrint:Say(_cont+100, 0145, Alltrim(SM0->M0_NOMECOM), _oFont8)															// Nome da Empresa
			_oPrint:Say(_cont+100, 0900, "Demonstrativo de Pagamento de " + _tipoFol, _oFont8) 							// Titulo -  tirei 1625 - 625
			_oPrint:Say(_cont+140, 0145, Alltrim(SM0->M0_ENDCOB)+", "+AllTrim(SM0->M0_BAIRCOB)+ "- "+AllTrim(SM0->M0_CIDCOB)+"-"+SM0->M0_ESTCOB, _oFont8)						// Endereco da Empresa
			_oPrint:Say(_cont+140, 1850, "MES : " + MesExtenso(MONTH(dDataRef)) + " de "+ STR(YEAR(dDataRef),4), _oFont8)	// Mes da Folha
			_oPrint:Say(_cont+180, 0145, Transform(SM0->M0_CGC, "@R 99.999.999/9999-99"), _oFont8) 																// CNPJ

			//			If Z == 1
			// 			   _oPrint:Say(_cont+180, 1850, "1 - Via da Empresa ", _oFont8) 	   											// Via 1
			//			Else            
			// 			   _oPrint:Say(_cont+180, 1850, "2 - Via do Funcionario ", _oFont8) 											// Via 2
			//			Endif

			_oPrint:Box(_cont+0230, 0130, _cont+0400, 2250)  																// Segundo Box
			_oPrint:Say(_cont+0250, 0145, "Código", _oFont8)   																// Codigo
			_oPrint:Say(_cont+0250, 0290, "Nome do Funcionário", _oFont8)  													// Nome do Funcionario
			_oPrint:Say(_cont+0250, 0845, "CBO", _oFont8)      																// CBO
			_oPrint:Say(_cont+0250, 0995, "C.Custo", _oFont8)  																// C.Custo
			_oPrint:Say(_cont+0250, 1206, "Descrição C.Custo", _oFont8)  													// Descricao C.Custo
			_oPrint:Say(_cont+0250, 1995, "Emp.", _oFont8)               													// Empresa
			_oPrint:Say(_cont+0250, 2190, "Fl.", _oFont8)                													// Folha
			//----------------------------
			_oPrint:Say(_cont+0300, 0145, aFunc[_I][1], _oFont8)															// Codigo
			_oPrint:Say(_cont+0300, 0290, aFunc[_I][2], _oFont8)															// Nome do Funcionario
			_oPrint:Say(_cont+0300, 0845, aFunc[_I][3], _oFont8)															// CBO
			_oPrint:Say(_cont+0300, 0995, aFunc[_I][4], _oFont8)															// C.Custo
			_oPrint:Say(_cont+0300, 1206, alltrim(aFunc[_I][5]), _oFont8)													// Descricao C. Custo
			_oPrint:Say(_cont+0300, 2005, aFunc[_I][6], _oFont8)															// Empresa
			_oPrint:Say(_cont+0300, 2190, strzero(y,3) , _oFont8)															// Folha

			_oPrint:Say(_cont+0350, 0145, "Função : ", _oFont8)  															// Funcao
			_oPrint:Say(_cont+0350, 0290, aFunc[_I][8]+" - "+aFunc[_I][9], _oFont8)										// Codigo e Descricao

			_oPrint:Box(_cont+0400, 0130, _cont+1700, 2250)         														// Box dos lançamentos
			_oPrint:Line(_cont+0450, 0130, _cont+0450, 2250)        														// Horizontal do cabecalho dos lançamentos
			_oPrint:Say(_cont+0405, 0145, "Cód.", _oFont8) 																	// Codigo
			_oPrint:Line(_cont+0405, 0250, _cont+1100, 0250)        														// Linha Vertical 1
			_oPrint:Say(_cont+0405, 0655, "Descrição", _oFont8)   															// Descricao
			_oPrint:Line(_cont+0405, 1155, _cont+1100, 1155)        														// Linha Vertical 2
			_oPrint:Say(_cont+0405, 1162, "Ref.", _oFont8)        															// Ref.
			_oPrint:Line(_cont+0405, 1300, _cont+1250, 1300)        														// Linha Vertical 3
			_oPrint:Say(_cont+0405, 1450, "Proventos", _oFont8)      														// Vencimentos
			_oPrint:Line(_cont+0405, 1800, _cont+1160, 1800)        														// Linha Vertical 4
			_oPrint:Say(_cont+0405, 1950, "Descontos", _oFont8)    														 	// Descontos

			_W 		:= 1
			_ncont	:= 0
			//			If Z == 1
			If _StopLanc == 0
				_nctaz  := 1   // Comeca imprimindo desde o PRIMEIRO lançamento
			Else
				_nCtaz  := _StopLanc
			Endif
			//			Endif

			For nConta := _nctaz To Len(aLanca)
				If nConta <= iif(Y >= 2,(nlinhas + _nctaz), nlinhas)
					_W      := _W + 45
					cString := Transform(aLanca[nConta,5],cPict2)
					nCol    := If(aLanca[nConta,1] = "P", 1330, If(aLanca[nConta,1] = "D", 1830, 0255))

					_oPrint:Say(_cont+0405+_W, 0155, aLanca[nConta,2] , _oFont8)  											// Codigo da Verba
					_oPrint:Say(_cont+0405+_W, 0255, aLanca[nConta,3] , _oFont8)  											// Nome da Verba

					If aLanca[nConta,1] # "B"        																		// So Imprime se nao for base
						If aLanca[nConta,4] <= 9.99
							_oPrint:Say(_cont+0405+_w, 1160, TRANSFORM(aLanca[nConta,4],"999.99"), _oFont8)  				// Referencia Horas
						Endif
						If aLanca[nConta,4] <= 99.99 .and. aLanca[nConta,4] > 9.99
							_oPrint:Say(_cont+0405+_w, 1160, TRANSFORM(aLanca[nConta,4],"999.99"), _oFont8)  				// Referencia Horas
						Endif
						If aLanca[nConta,4] <= 999.99 .and. aLanca[nConta,4] > 99.99
							_oPrint:Say(_cont+0405+_w, 1160, TRANSFORM(aLanca[nConta,4],"999.99"), _oFont8)  				// Referencia Horas
						Endif
					Endif
					If aLanca[nConta,5] <= 9.99
						_oPrint:Say(_cont+0405+_w, nCol, cString, _oFont8)
					Endif
					If aLanca[nConta,5] <= 99.99 .and. aLanca[nConta,5] > 9.99   											// Referencia Valor
						_oPrint:Say(_cont+0405+_w, nCol, cString, _oFont8)
					Endif
					If aLanca[nConta,5] <= 999.99 .and. aLanca[nConta,5] > 99.99                                          // Referencia Valor
						_oPrint:Say(_cont+0405+_w, nCol, cString, _oFont8)
					Endif
					If aLanca[nConta,5] <= 9999.99 .and. aLanca[nConta,5] > 999.99                                        // Referencia Valor
						_oPrint:Say(_cont+0405+_w, nCol, cString, _oFont8)
					Endif
					If aLanca[nConta,5] <= 99999.99 .and. aLanca[nConta,5] > 9999.99                                      // Referencia Valor
						_oPrint:Say(_cont+0405+_w, nCol, cString, _oFont8)
					Endif

					nContr++
					nContrT++
					_ncont++

					//   --------------------------------------------------------------------------------------------------
					//                                 Tratamento da QUEBRA de PÁGINA
					//   --------------------------------------------------------------------------------------------------
					If _nCont == _MaxLin
						If Len(aLanca) > _nCont
							_W 		  := _W + 45
							_StopLanc := nConta + 1
							_oPrint:Say(_cont+0400+_W, 0255, "CONTINUA !!!", _oFont8)
						Endif
						Exit
					Endif

				Endif

			Next nConta

			If !_lmesmo .or. (Y >= 2 .and. _lmesmo)
				// Impreme Mensagens
				_oPrint:Say(_cont+1290, 0145, DESC_MSG[_I][1], _oFont8)
				_oPrint:Say(_cont+1310, 0145, DESC_MSG[_I][2], _oFont8)
				_oPrint:Say(_cont+1320, 0145, DESC_MSG[_I][3], _oFont8)
				IF MONTH(dDataRef) = aFunc[_I][11]
					_oPrint:Say(_cont+1640, 0215, "F E L I Z   A N I V E R S A R I O  ! !", _oFont12)
					_oPrint:Say(_cont+1470, 0145, DESC_MSG[_I][4], _oFont8)
					_oPrint:Say(_cont+1495, 0145, DESC_MSG[_I][5], _oFont8)

				ELSE
					_oPrint:Say(_cont+1470, 0145, DESC_MSG[_I][4], _oFont8)
					_oPrint:Say(_cont+1495, 0145, DESC_MSG[_I][5], _oFont8)
				ENDIF

				//Mensagens da conta corrente
				If SRA->RA_BCDEPSAL # SPACE(8)
					If aFunc[_I][12] == "237"
						Desc_Bco := "Banco Bradesco  "
					Else
						If aFunc[_I][12] == "341"
							Desc_Bco := "Banco Itau      "
						Endif
					Endif
					Desc_Bco := ALLTRIM(DescBco(Sra->Ra_BcDepSal,Sra->Ra_Filial))
					_oPrint:Say(_cont+1200, 0145, "CRED: "+aFunc[_I][13]+" - "+DESC_BCO+"   CONTA: " + aFunc[_I][14], _oFont8)					
				Endif

				_oPrint:Line(_cont+1100, 0130, _cont+1100, 2250)  // linha horizontal no final dos lançamentos
				_oPrint:Line(_cont+1160, 1300, _cont+1160, 2250)  // linha horizontal antes do Valor liquido
				_oPrint:Say(_cont+1200, 1315, "Valor Liquido      ==>"   , _oFont10)

				//===============> PROVENTOS
				lMostraTot := .T.
				If Y < _Pag
					lMostraTot := .F.
				Endif  

				If TOTVENC[1][2] <= 9.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1350,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif
				If TOTVENC[1][2] <= 99.99 .and. TOTVENC[1][2] > 9.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1350,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif
				If TOTVENC[1][2] <= 999.99 .and. TOTVENC[1][2] > 99.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1350,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif
				If TOTVENC[1][2] <= 9999.99 .and. TOTVENC[1][2] > 999.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1350,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif
				If TOTVENC[1][2] <= 99999.99 .and. TOTVENC[1][2] > 9999.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1350,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif  

				//=================> DESCONTOS
				If TOTDESC[1][2] <= 9.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1800,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif
				If TOTDESC[1][2] <= 99.99 .and. TOTDESC[1][2] > 9.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1800,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif
				If TOTDESC[1][2] <= 999.99 .and. TOTDESC[1][2] > 99.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1800,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif
				If TOTDESC[1][2] <= 9999.99 .and. TOTDESC[1][2] > 999.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1800,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif
				If TOTDESC[1][2] <= 99999.99 .and. TOTDESC[1][2] > 9999.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1800,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif

				//=================> LIQUIDO
				If (TOTVENC[1][2]-TOTDESC[1][2]) >=0
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= 9.99  .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= 99.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 9.99 .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= 999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 99.99  .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= 9999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 999.99 .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
				Else
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= -9.99 .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= -99.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 9.99 .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= -999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 99.99 .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= -9999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 999.99 .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
				Endif

				_oPrint:Box(_cont+1250, 0130, _cont+1350, 2250)  // Box de demonstração do  Salário Base, FGTs, etc.
				_oPrint:Say(_cont+1260, 0150, "Salário-Base"		, _oFont8)
				_oPrint:Say(_cont+1260, 0500, "Sal. Contr. INSS"	, _oFont8)
				_oPrint:Say(_cont+1260, 0920, "Base Cálc. FGTS"		, _oFont8)
				_oPrint:Say(_cont+1260, 1300, "FGTS do Mês"			, _oFont8)
				_oPrint:Say(_cont+1260, 1600, "Base Cálc. IRRF"		, _oFont8)
				_oPrint:Say(_cont+1260, 2000, "Faixa IRRF"			, _oFont8)

				If !Empty( cAliasMov )
					nValSal := 0
					nValSal := fBuscaSal(dDataRef)
					If nValSal == 0
						nValSal := aFunc[_I][10]
					EndIf
				Else
					nValSal := aFunc[_I][10]
				EndIf

				_oPrint:Say(_cont+1300, 0150, Transform(nValSal,cPict2) , _oFont8)

				If Esc = 1  // Bases de Adiantamento
					If cBaseAux = "S" .And. aImpos[1][1] # 0
						_oPrint:Say(_cont+1300, 1600, TRANSFORM(aImpos[1][1],cPict1) , _oFont8)
					Endif
				ElseIf Esc = 2 .Or. Esc = 4  // Bases de Folha e 13o. 2o.Parc.
					If cBaseAux = "S"
						_oPrint:Say(_cont+1300, 0500,Transform(aImpos[1][2],cPict1) , _oFont8)
						If aImpos[1][3] # 0
							_oPrint:Say(_cont+1300, 0800, TRANSFORM(aImpos[1][3],cPict1) , _oFont8)
						Endif
						If aImpos[1][4] # 0
							_oPrint:Say(_cont+1300, 1200,TRANSFORM(aImpos[1][4],cPict2) , _oFont8)
						Endif
						If aImpos[1][1] # 0
							_oPrint:Say(_cont+1300, 1600,TRANSFORM(aImpos[1][1],cPict1) , _oFont8)
						Endif
						_oPrint:Say(_cont+1300, 1900, Transform(aImpos[1][5],cPict1) , _oFont8)
					Endif
				ElseIf Esc = 3 // Bases de FGTS e FGTS Depositado da 1¦ Parcela
					If cBaseAux = "S"
						If aImpos[1][3] # 0
							_oPrint:Say(_cont+1300, 0800,TRANSFORM(aImpos[1][3],cPict1), _oFont8)
						Endif
						If aImpos[1][4] # 0
							_oPrint:Say(_cont+1300, 1200, TRANSFORM(aImpos[1][4],cPict2) , _oFont8)
						Endif
					Endif
				Endif

				_oPrint:Say(_cont+1400, 0200, "DECLARO TER RECEBIDO A IMPORTANCIA LIQUIDA DISCRIMINADA NESTE RECIBO "  , _oFont8)
				_oPrint:Say(_cont+1525, 1320, "_____________________________________"   , _oFont10)
				_oPrint:Say(_cont+1575, 0520, "                     DATA                     "  , _oFont8)
				_oPrint:Say(_cont+1525, 0620, " ________/________/________  ", _oFont10)
				_oPrint:Say(_cont+1575, 1470, aFunc[_I][2]   , _oFont8)

			Endif

			_lmesmo	:= .F.

			_cont  := 1610  
			If Z == 1
				_oPrint:Say(_cont+45, 0000, "...>>>..........................................................................................................................................<<<..."   , _oFont10)
			Endif
			//		Next Z

			If Z == 2
				_oPrint:EndPage()     // Finaliza a página
			End If

		Next      

	Next

	_oPrint:Preview()     // Visualiza antes de imprimir

Return Nil



// Lancamentos
//*********************************************
Static Function llanca(_codmat,_codcc,_cFilial)

	Local cNroHoras   := &("{ || If(SRC->RC_QTDSEM > 0, SRC->RC_QTDSEM, SRC->RC_HORAS) }")     // Horas no Mes
	Local cNroHorad   := &("{ || If(SRD->RD_QTDSEM > 0, SRD->RD_QTDSEM, SRD->RD_HORAS) }")     // Horas no Acumulado
	Private cPeriodo  := GetMv("MV_FOLMES")   

	nAteLim   := 0.00
	nBaseFgts := 0.00
	nFgts     := 0.00
	nBaseIr   := 0.00
	nBaseIrFe := 0.00
	_TOTVENC  := 0
	_TOTDESC  := 0
	Esc       := mv_par02

	//dbSelectArea("SRA")
	SRA->(dbgotop())
	SRA->(dbSetOrder(1))
	SRA->(dbSeek(_cFilial+_codmat))

	If Esc == 1 .OR. Esc == 2  // Adto ou Folha

		If cAnoMesRef == cPeriodo  // Dentro do Periodo em Aberto Folha do Mes

			dbSelectArea("SRC")
			dbSetOrder(1)
			If dbSeek(_cFilial+_codmat)

				Do While !Eof() .And. SRC->RC_FILIAL+SRC->RC_MAT == SRA->RA_FILIAL+SRA->RA_MAT

					If (Esc == 1) .And. (Src->Rc_Pd == aCodFol[7,1])      // Desconto de Adto
						fSomaPd("P",aCodFol[6,1],Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
						_TOTVENC+=Src->Rc_Valor
					Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[12,1])
						fSomaPd("D",aCodFol[9,1],Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
						_TOTDESC+=SRC->RC_VALOR
					Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[8,1])
						fSomaPd("P",aCodFol[8,1],Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
						_TOTVENC+=Src->Rc_Valor
					Else
						If PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
							If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
								If cPaisLoc == "PAR" .and. Eval(cNroHoras) == 30
									LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)), Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Strzero(Month(dDataRef),2)+"/"+right(str(Year(dDataRef)),2)),@nHoras)
								Else
									nHoras := Eval(cNroHoras)
								Endif
								fSomaPd("P",SRC->RC_PD,nHoras,SRC->RC_VALOR,SRC->RC_MAT)
								_TOTVENC+=Src->Rc_Valor
							Endif
						Elseif SRV->RV_TIPOCOD == "2"
							If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
								fSomaPd("D",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
								_TOTDESC+=Src->Rc_Valor
							Endif
						Elseif SRV->RV_TIPOCOD == "3"
							If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
								fSomaPd("B",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
							Endif
						Endif
					Endif
					If ESC == 1
						If SRC->RC_PD == aCodFol[10,1]
							nBaseIr := SRC->RC_VALOR
						Endif
					ElseIf SRC->RC_PD == aCodFol[13,1]
						nAteLim += SRC->RC_VALOR
					Elseif SRC->RC_PD$ aCodFol[108,1]+'*'+aCodFol[17,1]
						nBaseFgts += SRC->RC_VALOR
					Elseif SRC->RC_PD$ aCodFol[109,1]+'*'+aCodFol[18,1]
						nFgts += SRC->RC_VALOR
					Elseif SRC->RC_PD == aCodFol[15,1]
						nBaseIr += SRC->RC_VALOR
					Elseif SRC->RC_PD == aCodFol[16,1]
						nBaseIrFe += SRC->RC_VALOR
					Endif

					dbSelectArea("SRC")
					dbSkip()

				Enddo

			Endif

		Else  // Dados das Folhas dos Meses Anteriores Folha Fechado.

			dbSelectArea("SRD")  
			If dbSeek(_cFilial+_codmat+cAnoMesRef)

				Do While !Eof() .And. SRD->RD_FILIAL+SRD->RD_MAT == SRA->RA_FILIAL+SRA->RA_MAT

					If SRD->RD_DATARQ == cAnoMesRef
						If (Esc == 1) .And. (Srd->Rd_Pd == aCodFol[7,1])      // Desconto de Adto
							fSomaPd("P",aCodFol[6,1],Eval(cNroHorad),SRD->RD_VALOR,SRD->RD_MAT)
							_TOTVENC+=Srd->Rd_Valor
						Elseif (Esc == 1) .And. (Srd->Rd_Pd == aCodFol[12,1])
							fSomaPd("D",aCodFol[9,1],Eval(cNroHorad),SRD->RD_VALOR,SRD->RD_MAT)
							_TOTDESC+=SRD->RD_VALOR
						Elseif (Esc == 1) .And. (Srd->Rd_Pd == aCodFol[8,1])
							fSomaPd("P",aCodFol[8,1],Eval(cNroHorad),SRD->RD_VALOR,SRD->RD_MAT)
							_TOTVENC+=Srd->Rd_Valor
						Else
							If PosSrv( Srd->Rd_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
								If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
									If cPaisLoc == "PAR" .and. Eval(cNroHorad) == 30
										LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)), Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Strzero(Month(dDataRef),2)+"/"+right(str(Year(dDataRef)),2)),@nHoras)
									Else
										nHoras := Eval(cNroHorad)
									Endif
									fSomaPd("P",SRD->RD_PD,nHoras,SRD->RD_VALOR,SRD->RD_MAT)
									_TOTVENC+=Srd->Rd_Valor
								Endif
							Elseif SRV->RV_TIPOCOD == "2"
								If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
									fSomaPd("D",SRD->RD_PD,Eval(cNroHorad),SRD->RD_VALOR,SRD->RD_MAT)
									_TOTDESC+=Srd->Rd_Valor
								Endif
							Elseif SRV->RV_TIPOCOD == "3"
								If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
									fSomaPd("B",SRD->RD_PD,Eval(cNroHorad),SRD->RD_VALOR,SRD->RD_MAT)
								Endif
							Endif
						Endif
						If ESC == 1
							If SRD->RD_PD == aCodFol[10,1]
								nBaseIr := SRD->RD_VALOR
							Endif
						ElseIf SRD->RD_PD == aCodFol[13,1]
							nAteLim += SRD->RD_VALOR
						Elseif SRD->RD_PD$ aCodFol[108,1]+'*'+aCodFol[17,1]
							nBaseFgts += SRD->RD_VALOR
						Elseif SRD->RD_PD$ aCodFol[109,1]+'*'+aCodFol[18,1]
							nFgts += SRD->RD_VALOR
						Elseif SRD->RD_PD == aCodFol[15,1]
							nBaseIr += SRD->RD_VALOR
						Elseif SRD->RD_PD == aCodFol[16,1]
							nBaseIrFe += SRD->RD_VALOR
						Endif
					EndIf
					dbSelectArea("SRD")
					SRD->(dbSkip())

				Enddo

			Endif  

		Endif

	Elseif Esc == 3

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Busca os codigos de pensao definidos no cadastro beneficiario³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		fBusCadBenef(@aCodBenef, "131",{aCodfol[172,1]})
		dbSelectArea("SRC")
		dbSetOrder(1)
		If dbSeek(_cFilial+_codmat)
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRC->RC_FILIAL + SRC->RC_MAT
				If SRC->RC_PD == aCodFol[22,1]
					fSomaPd("P",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
					_TOTVENC+=Src->Rc_Valor
				Elseif Ascan(aCodBenef, { |x| x[1] == SRC->RC_PD }) > 0
					fSomaPd("D",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
					_TOTDESC+=SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[108,1] .Or. SRC->RC_PD == aCodFol[109,1] .Or. SRC->RC_PD == aCodFol[173,1]
					fSomaPd("B",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
				Endif

				If SRC->RC_PD == aCodFol[108,1]
					nBaseFgts := SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[109,1]
					nFgts     := SRC->RC_VALOR
				Endif
				dbSelectArea("SRC")
				dbSkip()
			Enddo
		Endif

	Elseif Esc == 4

		If Substr(cPeriodo,1,4) == cAnoRef13     // 2 Parcela 13 Salario do Ano em Vigor.

			dbSelectArea("SRI")
			dbSetOrder(2)
			If dbSeek(_cFilial+_codcc+_codmat)
				While !Eof() .And. SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT == SRI->RI_FILIAL + SRI->RI_CC + SRI->RI_MAT
					If PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
						fSomaPd("P",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR,SRI->RI_MAT)
						_TOTVENC = _TOTVENC + SRI->RI_VALOR
					Elseif SRV->RV_TIPOCOD == "2"
						fSomaPd("D",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR,SRI->RI_MAT)
						_TOTDESC = _TOTDESC + SRI->RI_VALOR
					Elseif SRV->RV_TIPOCOD == "3"
						fSomaPd("B",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR,SRI->RI_MAT)
					Endif

					If SRI->RI_PD == aCodFol[19,1]
						nAteLim += SRI->RI_VALOR
					Elseif SRI->RI_PD$ aCodFol[108,1]
						nBaseFgts += SRI->RI_VALOR
					Elseif SRI->RI_PD$ aCodFol[109,1]
						nFgts += SRI->RI_VALOR
					Elseif SRI->RI_PD == aCodFol[27,1]
						nBaseIr += SRI->RI_VALOR
					Endif
					dbSkip()
				Enddo
			Endif

		Else  // 2 Parcela do 13 Salario nos Acumulados da Folha.

			cAnoMesRef :=cAnoRef13+"13"
			dbSelectArea("SRD")
			If dbSeek(_cFilial+_codmat+cAnoMesRef)
				While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRD->RD_FILIAL + SRD->RD_MAT
					If PosSrv( SRD->RD_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
						fSomaPd("P",SRD->RD_PD,SRD->RD_HORAS,SRD->RD_VALOR,SRD->RD_MAT)
						_TOTVENC = _TOTVENC + SRD->RD_VALOR
					Elseif SRV->RV_TIPOCOD == "2"
						fSomaPd("D",SRD->RD_PD,SRD->RD_HORAS,SRD->RD_VALOR,SRD->RD_MAT)
						_TOTDESC = _TOTDESC + SRD->RD_VALOR
					Elseif SRV->RV_TIPOCOD == "3"
						fSomaPd("B",SRD->RD_PD,SRD->RD_HORAS,SRD->RD_VALOR,SRD->RD_MAT)
					Endif

					If SRD->RD_PD == aCodFol[19,1]
						nAteLim += SRD->RD_VALOR
					Elseif SRD->RD_PD$ aCodFol[108,1]
						nBaseFgts += SRD->RD_VALOR
					Elseif SRD->RD_PD$ aCodFol[109,1]
						nFgts += SRD->RD_VALOR
					Elseif SRD->RD_PD == aCodFol[27,1]
						nBaseIr += SRD->RD_VALOR
					Endif
					dbSkip()
				Enddo
			Endif

		Endif

	Elseif Esc == 5

		dbSelectArea("SR1")
		dbSetOrder(1)
		If dbSeek(_cFilial+_codmat)
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT ==	SR1->R1_FILIAL + SR1->R1_MAT
				If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPd("P",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR,SR1->R1_MAT)
					_TOTVENC = _TOTVENC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD == "2"
					fSomaPd("D",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR,SR1->R1_MAT)
					_TOTDESC = _TOTDESC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD == "3"
					fSomaPd("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR,SR1->R1_MAT)
				Endif
				dbskip()
			Enddo
		Endif

	Endif

	dbSelectArea("SRA")

	aAdd(TOTVENC,{_n, _TOTVENC})
	aAdd(TOTDESC,{_n, _TOTDESC})
	aAdd(aImpos,{nBaseIr, nAteLim, nBaseFgts, nFgts, nBaseIrFe})


Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fSomaPd   ³ Autor ³ Eduardo Clemente      ³ Data ³ 19.01.15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Somar as Verbas no Array                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fSomaPd(Tipo,Verba,Horas,Valor)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fSomaPd(cTipo,cPd,nHoras,nValor,cMat)

	Local Desc_paga
	Desc_paga := DescPd(cPd,Sra->Ra_Filial)  // mostra como pagto

	If cTipo # 'B'
		//--Array para Recibo Pre-Impresso
		nPos := Ascan(aLanca,{ |X| X[2] = cPd })
		If nPos == 0
			Aadd(aLanca,{cTipo,cPd,Desc_Paga,nHoras,nValor,cMat,_n})
		Else
			aLanca[nPos,4] += nHoras
			aLanca[nPos,5] += nValor
		Endif
	Endif

	Return


	//Função Transformada Data
	*-------------------------------------------------------
Static Function Transforma(dData) //Transforma as datas no formato DD/MM/AAAA
	*-------------------------------------------------------
Return(StrZero(Day(dData),2) +"/"+ StrZero(Month(dData),2) +"/"+ Right(Str(Year(dData)),4))


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fInicia   ºAutor  ³Eduardo Clemente    º Data ³  19/01/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inicializa parametros para impressao                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function  fInicia(cString,nTipoRel)

	aDriver := LEDriver()

	If LastKey() = 27 .Or. nLastKey = 27
		Return  .F.
	Endif

	SetDefault(aReturn,cString)

	If LastKey() = 27 .OR. nLastKey = 27
		Return .F.
	Endif

Return .T.


//Funcão Valida SX1
//*************************
Static Function fValidSX1()

	aPergs := {}

	Aadd(aPergs,{"Data de Referencia     ?", "", "","mv_ch1", "D", 8, 0, 0, "G", "naovazio","mv_par01", ""			,"", "", "","" ,"", "","","","", "", "","","", "", "","","", "", "","",""})
	Aadd(aPergs,{ "Imprimir Recibos      ?", "", "","mv_ch2", "N", 1, 0, 0, "C", ""        ,"mv_par02","Adto.","","","","","Folha","","","","","1a.Parc.","","","","","2a.Parc.","","","","","Val.Extras","","","","",""})
	Aadd(aPergs,{ "De Filial             ?", "", "","mv_ch3", "C", 2, 0, 0, "G", "","mv_par03", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","XM0"})
	Aadd(aPergs,{ "Ate Filial            ?", "", "","mv_ch4", "C", 2, 0, 0, "G", "","mv_par04", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","XM0"})
	Aadd(aPergs,{ "De Centro de Custo    ?", "", "","mv_ch5", "C", 9, 0, 0, "G", "","mv_par05", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","CTT"})
	Aadd(aPergs,{ "Ate Centro de Custo   ?", "", "","mv_ch6", "C", 9, 0, 0, "G", "","mv_par06", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","CTT"})
	Aadd(aPergs,{ "De Matricula          ?", "", "","mv_ch7", "C", 6, 0, 0, "G", "","mv_par07", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","SRA"})
	Aadd(aPergs,{ "Ate Matricula         ?", "", "","mv_ch8", "C", 6, 0, 0, "G", "","mv_par08", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","SRA"})
	Aadd(aPergs,{ "De Nome               ?", "", "","mv_ch9", "C", 30, 0, 0, "G", "","mv_par09", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
	Aadd(aPergs,{ "Ate Nome              ?", "", "","mv_chA", "C", 30, 0, 0, "G", "","mv_par10", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
	Aadd(aPergs,{ "Mensagem 1            ?", "", "","mv_chB", "C", 2, 0, 0, "G", ""         ,"mv_par11", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
	Aadd(aPergs,{ "Mensagem 2            ?", "", "","mv_chC", "C", 2, 0, 0, "G", ""         ,"mv_par12", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
	Aadd(aPergs,{ "Mensagem 3            ?", "", "","mv_chD", "C", 2, 0, 0, "G", ""         ,"mv_par13", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
	Aadd(aPergs,{ "Mensagem 4            ?", "", "","mv_chE", "C", 62, 0, 0, "G", ""        ,"mv_par14", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
	Aadd(aPergs,{ "Mensagem 5            ?", "", "","mv_chF", "C", 62, 0, 0, "G", ""        ,"mv_par15", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
	Aadd(aPergs,{ "Situacoes a Imp.      ?", "", "","mv_chG", "C", 5, 0, 0, "G", "fSituacao","mv_par16", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
	Aadd(aPergs,{ "Categorias a Imp.     ?", "", "","mv_chH", "C", 15, 0, 0, "G", "fCategoria","mv_par17", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
	Aadd(aPergs,{ "imprime Bases         ?", "", "","mv_chI", "C", 1, 0, 0, "C", ""         , "mv_par18", "Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","",""})

	AjustaSx1("RGPE01",aPergs)
Return


Static Function AjustaSX1(cPerg, aPergs)
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local cKey		:= ""
Local nj		:= 1
Local aArea		:= GetArea()
Local lUpdHlp	:= .T.

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
			"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
			"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
			"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
			"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
			"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
			"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP", "X1_PICTURE"}

dbSelectArea( "SX1" )
dbSetOrder(1)

cPerg := PadR( cPerg , Len(X1_GRUPO) , " " )

For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek( cPerg + Right( Alltrim( aPergs[nX][11] ) , 2) )

		If ( ValType( aPergs[nX][Len( aPergs[nx] )]) = "B" .And. Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif

	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]		
 		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
 	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(ALLTRIM( aPergs[nX][11] ), 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0 .And. ValType(aPergs[nX][nJ]) != "A"
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
	Endif
	cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

	If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
		aHelpSpa := aPergs[nx][Len(aPergs[nx])]
	Else
		aHelpSpa := {}
	Endif
	
	If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
		aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
	Else
		aHelpEng := {}
	Endif

	If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
		aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
	Else
		aHelpPor := {}
	Endif

	// Caso exista um help com o mesmo nome, atualiza o registro.
	lUpdHlp := ( !Empty(aHelpSpa) .and. !Empty(aHelpEng) .and. !Empty(aHelpPor) )
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa,lUpdHlp)
	
Next
RestArea(aArea)

Return()
