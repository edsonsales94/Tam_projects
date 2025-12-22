ACDV166X#INCLUDE "acdv166.ch" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"


//#define POSENDAUX 06
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ PLANO DE MELHORIA CONTINUA                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ITEM PMC  ³ Responsavel              ³ Data         |BOPS:             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³      01  ³Flavio Luiz Vicco         ³ 05/04/2006   ³00000096388       ³±±
±±³      02  ³Flavio Luiz Vicco         ³ 11/01/2006   ³00000091314       ³±±
±±³      03  ³                          ³              ³                  ³±±
±±³      04  ³                          ³              ³                  ³±±
±±³      05  ³Erike Yuri da Silva       ³ 13/01/2006   ³                  ³±±
±±³      06  ³Flavio Luiz Vicco         ³ 05/04/2006   ³00000096388       ³±±
±±³      07  ³Erike Yuri da Silva       ³ 13/01/2006   ³                  ³±±
±±³      08  ³Flavio Luiz Vicco         ³ 17/05/2006   |00000098404       ³±±
±±³      09  ³Flavio Luiz Vicco         ³ 17/05/2006   |00000098404       ³±±
±±³      10  ³Flavio Luiz Vicco         ³ 11/01/2006   ³00000091314       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static __nSem:=0
Static __PulaItem := .F.
Static __aOldTela :={}                      	

User Function AAACDP02()
	Local aTela
	Local nOpc 

	If ACDGet170()
		Return ACDV166X(0)
	EndIf
	ACDV166A()
Return 1

Static Function ACDV166A()
	ACDV166X(1)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ACDV166X ³ Autor ³ ACD                   ³ Data ³ 12/02/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Separacao                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ACDV166X(nOpc)
	Local ckey04  := VTDescKey(04)
	Local ckey09  := VTDescKey(09)
	Local ckey12  := VTDescKey(12)
	Local cKey16  := VTDescKey(16)
	Local cKey22  := VTDescKey(22)
	Local cKey24  := VTDescKey(24)
	Local cKey21  := VTDescKey(21)
	Local bkey04  := VTSetKey(04)
	Local bkey09  := VTSetKey(09)
	Local bkey12  := VTSetKey(12)
	Local bkey16  := VTSetKey(16)
	Local bKey22  := VTSetKey(22)
	Local bKey24  := VTSetKey(24)
	Local bKey21  := VTSetKey(21)
	Local lRetPE  := .T.
	Local lACD166VL     := ExistBlock("ACD166VL")
	Local lACD166VI     := ExistBlock("ACD166VI")
	Private cCodOpe     := CBRetOpe()
	Private cImp        := CBRLocImp("MV_IACD01")
	Private cNota
	Private lMSErroAuto := .F.
	Private lMSHelpAuto := .t.
	Private lExcluiNF   := .f.
	Private lForcaQtd   := GetMV("MV_CBFCQTD",,"2") =="1"
	Private lEtiProduto := .F.			//Indica se esta lendo etiqueta de produto
	Private cDivItemPv  := Alltrim(GetMV("MV_DIVERPV"))
	Private cPictQtdExp := PesqPict("CB8","CB8_QTDORI")
	Private cArmazem    := Space(Tamsx3("B1_LOCPAD")[1])
	Private cEndereco   := Space(15)
	Private nSaldoCB8   := 0
	Private nTotEtiq	:= 0
	Private nTotItem	:= 0
	Private nLidEtiq	:= 0
	Private cVolume     := Space(10)
	Private cCodSep     := Space(6)

	If Type("cOrdSep")=="U"
		Private cOrdSep := Space(6)
	EndIf

	__aOldTela :={}
	__nSem := 0 // variavel static do fonte para controle de semaforo
	//CBChkTemplate()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Validacoes                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cCodOpe)
		VTAlert(STR0009,STR0010,.T.,4000,3) //"Operador nao cadastrado"###"Aviso"
		Return 10 // valor necessario para finalizar o acv170
	EndIf
	CB5->(DbSetOrder(1))
	If !CB5->(DbSeek(xFilial("CB5")+cImp))  //cadastro de locais de impressao
		VtBeep(3)
		VtAlert(STR0011,STR0010,.t.) //"O conteudo informado no parametro MV_IACD01 deve existir na tabela CB5."###"Aviso"
		Return 10 // valor necessario para finalizar o acv170
	EndIf

	//Verifica se foi chamado pelo programa ACDV170 e se ja foi separado
	If ACDGet170() .AND. CB7->CB7_STATUS >= "2"
		If !A170SLProc()
			//Nao eh necessario  liberar o semaforo pois ainda nao criou nada
			Return 1
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ativa/Destativa a tecla avanca e retrocesa                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		A170ATVKeys(.t.,.f.)	 //Ativa tecla avanca e desativa tecla retrocede
	ElseIf ACDGet170()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Desativa as teclas de retrocede e avanca                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		A170ATVKeys(.f.,.f.)
	EndIf

	VTClear()
	If VtModelo()=="RF"
		@ 0,0 VtSay STR0001 //"Separacao"
	EndIf
	If ! CBSolCB7(nOpc,{|| VldCodSep()})
		Return MSCBASem() // valor necessario para finalizar o acv170 e liberar o semaforo
	EndIf

	If Empty(cOrdSep)
		cCodSep := CB7->CB7_ORDSEP
	Else
		cCodSep := cOrdSep
	EndIf

	If  Separou()
		If CB7->CB7_STATUS == "9"
			VTAlert(STR0012,STR0010,.t.,4000,3) //"Processo de separacao finalizado"###"Aviso"
			If lACD166VL
				lRetPe := ExecBlock("ACD166VL")
				lRetPe := If(ValType(lRetPe)=="L",lRetPe,.T.)
			EndIf

			MSCBASem()
			Return 10
		Else
			SD3->(DbSetOrder(2))
			If !SD3->(DbSeek(xFilial("SD3")+PadR(CB7->CB7_ORDSEP,TamSx3("D3_DOC")[1])))
				Return FimProcesso()
			Else
				Reclock("CB7",.f.)
				CB7->CB7_STATUS := "9"   //  "2" -- separacao finalizada
				CB7->CB7_STATPA := " "
				CB7->CB7_DTFIMS := dDataBase
				CB7->CB7_HRFIMS := StrTran(Time(),":","")
				FAltSta("3")
				iF EMPTY(CB7->CB7_NUMSOL)
					FMudaEtiq(CB7->CB7_ORDSEP)
				ENDIF
				MSCBASem()
				VTAlert(STR0012,STR0010,.t.,4000,3) //"Processo de separacao finalizado"###"Aviso"
				Return 10
			EndIf
		EndIf
		//Return FimProcesso(.T.)
	EndIf

	VTSetKey(09,{|| Informa()},STR0015) //"Informacoes"


	IniProcesso()

	//Fluxo da separacao
	aTela := VTSave()  
	VtClear()
	//Amazon Aco
	acab :={"Produto","Item","Sequencia"} //"Ord.Sep","Arm","Nota","Serie","Operador"
	aSize   := {10,3,2}
	aItens := {}

	ConOut("Separacao:"+cCodSep)
	CB8->(DbSetOrder(7))
	CB8->(DbSeek(xFilial("CB8")+cCodSep))

	While CB8->(! Eof()) .and. xFilial("CB8")+CB8->CB8_ORDSEP ==xFilial("CB8")+cCodSep
		if !Empty(CB8->CB8_SALDOS)
			aadd(aItens,{CB8->CB8_PROD,CB8->CB8_ITEM,CB8->CB8_SEQUEN})	
		EndIf
		CB8->(DbSkip())
	EndDo

	lPrimeira := .T.
	While Len(aItens)>0
		aTela := VTSave()  
		VtClear()
		nPos := 1
		nSele:= npos := VTaBrowse(,,,,aCab,aItens,aSize,,nPos) 
		VtRestore(,,,,aTela)  

		If VTLastkey() == 27    
			MSCBASem() // valor necessario para finalizar o acv170 e liberar o semaforo
			Return 10
		Endif 
		If !lPrimeira
			CB8->(DbSetOrder(1))
			CB8->(DbSeek(xFilial("CB8")+cCodSep+aItens[nPos,2]+aItens[nPos,3]+aItens[nPos,1]))
			While !CB8->(Eof()) .And. CB8->(CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_SEQUEN+CB8_PROD)==xFilial("CB8")+cCodSep+aItens[nPos,2]+aItens[nPos,3]+aItens[nPos,1]

				__PulaItem := .F.
				If Empty(CB8->CB8_SALDOS) // ja separado    
					nPos :=Ascan(aItens,{|x| x[1]+x[2]+x[3] == CB8->(CB8_PROD+CB8_ITEM+CB8_SEQUEN)})
					ADel(aItens,nPos)
					ASize( aItens , Len(aItens) - 1 )
					Exit
				EndIf
				If ! Tela()
					Exit
				EndIf
				If UsaCb0("01") //Quando utiliza codigo interno
					If CBProdUnit(CB8->CB8_PROD) // etiqueta do produto
						If ! EtiProduto()
							Exit
						EndIf
					EndIf
				EndIf
			EndDo
		EndIf
		lPrimeira := .F.
	EndDo
	vtsetkey(04,bkey04,cKey04)
	vtsetkey(09,bkey09,cKey09)
	vtsetkey(12,bkey12,cKey12)
	vtsetkey(16,bkey16,cKey16)
	vtsetkey(22,bkey22,cKey22)
	vtsetkey(21,bkey21,cKey21)
	MSCBASem() // valor necessario para finalizar o acv170 e liberar o semaforo
Return FimProcesso()

//============================================================================================
// FUNCOES REVISADAS
//============================================================================================
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ Separou  ³ Autor ³ ACD                   ³ Data ³ 06/02/05      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica se todos os itens da Ordem de Separacao foram separados³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAACD                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Separou()
	Local lRet:= .t.
	Local lV166SPOK
	Local aCB8	:= CB8->(GetArea('CB8'))

	CB8->(DBSetOrder(1))
	CB8->(DbSeek(xFilial("CB8")+cOrdSep))
	While CB8->(! Eof() .and. CB8_FILIAL+CB8_ORDSEP == xFilial("CB8")+cOrdSep)
		If !Empty(CB8->CB8_OCOSEP) .AND. Alltrim(CB8->CB8_OCOSEP) == cDivItemPv
			CB8->(DbSkip())
			Loop
		EndIf
		If CB8->CB8_SALDOS > 0
			lRet:= .f.
			Exit
		EndIf
		CB8->(DbSkip())
	EndDo
	If ExistBlock("V166SPOK")
		lV166SPOK:= ExecBlock("V166SPOK",.f.,.f.)
		If(ValType(lV166SPOK)=="L",lRet:= lV166SPOk,lRet)
	EndIf	
	CB8->(RestArea(aCB8))
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ IniProcesso³ Autor ³ ACD                 ³ Data ³ 03/02/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Expedicao                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IniProcesso()
	RecLock("CB7",.f.)
	// AJUSTE DO STATUS
	If CB7->CB7_STATUS == "0" .or. Empty(CB7->CB7_STATUS) // nao iniciado
		CB7->CB7_STATUS := "1"  // em separacao
		CB7->CB7_DTINIS := dDataBase
		CB7->CB7_HRINIS := StrTran(Time(),":","")
	EndIf
	CB7->CB7_STATPA := " "  // se estiver pausado tira o STATUS  de pausa
	CB7->CB7_CODOPE := cCodOpe
	CB7->(MsUnlock())      
	FAltSta("2") 

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ FimProcesso³ Autor ³ ACD                 ³ Data ³ 03/02/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Finaliza o processo de separacao                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FimProcesso(lEstorno)
	Local lDiverg := .f.
	Local lRet    := .t.
	Local nSai    := 1
	Local nX 	  := 0
	Local cStatus := "2"
	Local aEmp	  := {}
	Private aTransferencia := {}
	Default lEstorno :=.F.
	//  fim  esta implemntacao dever ser melhor analisada
	BEGIN TRANSACTION 
		If Separou()
			//Amazon Aco
			if !lEstorno
				CB8->(DbSetOrder(1))
				CB8->(DbSeek(xFilial("CB8")+CB7->CB7_ORDSEP))

				iF EMPTY(CB7->CB7_NUMSOL)
				
				While !CB8->(Eof()) .and. (CB8->CB8_ORDSEP == CB7->CB7_ORDSEP)
					lFinanceiro := CB8->CB8_XULTRA=="N"
					SC6->(DbSetOrder(1))
					aEmpenho :={}
					If SC6->(DbSeek(xFilial("SC6")+CB8->CB8_PEDIDO+CB8->CB8_XITPED+CB8->CB8_PROD))
						SC9->(DbSetOrder(1))
						SC9->(DbSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM)))
						While SC9->(! Eof() .and. C9_FILIAL+C9_PEDIDO+C9_ITEM==xFilial("SC9")+SC6->(C6_NUM+C6_ITEM))
							If ! Empty(SC9->C9_NFISCAL)
								SC9->(DbSkip())
								Loop
							EndIf
							if  SC9->C9_ORDSEP != CB7->CB7_ORDSEP
								SC9->(DbSkip())
								Loop
							EndIf
							SC9->(a460Estorna())      //estorna o que estava liberado no sdc e sc9
							SC9->(DbSkip())
						Enddo

						CB9->(DbSetOrder(10))
						CB9->(DbSeek(xFilial("CB9")+CB8->CB8_ORDSEP+CB8->CB8_ITEM+CB8->CB8_PROD))
						While !CB9->(Eof()) .And. xFilial("CB9")+CB9->CB9_ORDSEP+CB9->CB9_ITESEP+CB9->CB9_PROD==xFilial("CB8")+CB8->CB8_ORDSEP+CB8->CB8_ITEM+CB8->CB8_PROD
							nX++

							_xdPos := aScan(aTransferencia, {|x| x[01] == CB9->CB9_PROD .And. x[02] == CB9->CB9_LOCAL .And. x[03]==CB9->CB9_LCALIZ .And. x[06]==CB9->CB9_LOTECT } )
							If _xdPos>0
								aTransferencia[_xdPos,7] += CB9->CB9_QTESEP
								aTransferencia[_xdPos,11]+= ConvUM(CB9->CB9_PROD,CB9->CB9_QTESEP,0,2)									
							Else
								aAdd(aTransferencia,{CB9->CB9_PROD  ,;//1
													 CB9->CB9_LOCAL ,;//2
													 CB9->CB9_LCALIZ,;
													 "75"           ,;
													 "SEPARA"       ,;
													 CB9->CB9_LOTECT,;
													 CB9->CB9_QTESEP,;
													 SC6->C6_NUM    ,;
													 .F.            ,;
													 CB9->CB9_ORDSEP,;
													 ConvUM(CB9->CB9_PROD,CB9->CB9_QTESEP,0,2),;
													 lFinanceiro    ,;
													 SC6->(Recno()) ,;
													 CB9->CB9_ITESEP})
							EndIf	
							CB9->(DbSkip())
						EndDo
					EndIf

					CB8->(Dbskip())
					//EndIf
				EndDo

				ENDIF

				//Amazon Aco
				iF EMPTY(CB7->CB7_NUMSOL)
					lFinaliza := FFinaliza(aTransferencia)
				else
					lFinaliza := .T.	
				ENDIF

				If !lFinaliza
					Reclock("CB7",.f.)
					CB7->CB7_STATUS := "1"  // separando
					CB7->CB7_STATPA := "1"  // Em pausa
					CB7->CB7_DTFIMS := Ctod("  /  /  ")
					CB7->CB7_HRFIMS := "     "
					nSai := 10
				Else
					//Placa()
					If lRet
						Reclock("CB7",.f.)
						CB7->CB7_STATUS := "9"   //  "2" -- separacao finalizada
						CB7->CB7_STATPA := " "
						CB7->CB7_DTFIMS := dDataBase
						CB7->CB7_HRFIMS := StrTran(Time(),":","")
					EndIf


					//Amazon Aco
					//Amazon Aco
					//-- Ponto de entrada no final da separacao
					If ExistBlock("ACD166FM")
						ExecBlock("ACD166FM")
					EndIf
					If CB7->CB7_STATUS == "2" .OR. CB7->CB7_STATUS == "9"
						IF 	UsaCb0("01") 
							CB8->(DbSetOrder(1))
							CB8->(DbGotop())
							If CB8->(DbSeek(xFilial("CB8")+CB7->CB7_ORDSEP))
								CB9->(Dbsetorder(1))
								CB9->(Dbgotop())
								CB9->(Dbseek(xFilial('CB9')+CB7->CB7_ORDSEP))
								while !CB9->(EOF()) .and. CB9->CB9_FILIAL+CB9->CB9_ORDSEP == xfilial('CB9')+CB7->CB7_ORDSEP
									CB0->(Dbsetorder(1))
									CB0->(Dbgotop())
									If CB0->(Dbseek(xFilial('CB0')+CB9->CB9_CODETI))
										Reclock("CB0",.F.)
										CB0->CB0_NFSAI := CB8->CB8_NOTA
										CB0->CB0_SERIES:= CB8->CB8_SERIE
										CB0->(MsUnlock())
									EndIf
									CB9->(Dbskip())
								endDo	
							EndIF
						EndIf		   		
						FAltSta("3")
						iF EMPTY(CB7->CB7_NUMSOL)
							FMudaEtiq(CB7->CB7_ORDSEP)
						endif
						VTAlert(STR0012,STR0010,.t.,4000)  //"Processo de separacao finalizado"###"Aviso"
					EndIf
				EndIf
			EndIf	

		Else
			If !lDiverg .AND. ACDGet170() .AND. ;
			VTYesNo(STR0023,STR0014,.T.) //"Ainda existem itens nao separados. Deseja separalos agora?"###"Atencao"
				nSai := 0
			Else
				Reclock("CB7",.f.)
				CB7->CB7_STATUS := "1"  // separando
				CB7->CB7_STATPA := "1"  // Em pausa
				CB7->CB7_DTFIMS := Ctod("  /  /  ")
				CB7->CB7_HRFIMS := "     "
				nSai := 10
			EndIf
		EndIf
		CB7->(MsUnlock())


		CBLogExp(cOrdSep)

		If	ExistBlock("ACD166FI")
			ExecBlock("ACD166FI",.F.,.F.)
		Endif


	END TRANSACTION
Return nSai

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ Tela       ³ Autor ³ ACD                 ³ Data ³ 27/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Somente monta a tela do respectivo produto a separar       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tela()
	Local aTam    := TamSx3("CB8_QTDORI")
	Local cUnidade
	Local nQtdSep := 0

	Local nQtdCX  := 0
	Local nQtdPE  := 0
	Local aInfo   :={}
	static ccodant:=""

	VtClear()
	// posiconando o produto
	SB1->(DbSetOrder(1))
	If ! SB1->(DbSeek(xFilial("SB1")+CB8->CB8_PROD))
		VtAlert(STR0031+CB8->CB8_PROD+STR0032) //"Inconsistencia de Base, produto "###" nao encontrado"
		// isto nao deve acontecer
		Return .f.
	EndIf
	nSaldoCB8   := CB8->(AglutCB8(CB8_ORDSEP,CB8_LOCAL,CB8_PROD,CB8_ITEM))
	aRet 		:= u_FPegaSaldo(CB8->CB8_ORDSEP)                            // ira separar por volume se possivel
	nTotEtiq	:= aRet[2]                             
	nLidEtiq	:= aRet[1]                            
	nTotItem	:= u_FPegaSaldo(CB8->CB8_ORDSEP,CB8->CB8_PROD)[2]                            // ira separar por volume se possivel


	If GetNewPar("MV_OSEP2UN","0") $ "0 " // verifica se separa utilizando a 1 unidade de media
		nQtdSep := nSaldoCB8
		cUnidade:= If(nQtdSep==1,STR0033,STR0034) //"item "###"itens "
	Else                                          // ira separar por volume se possivel
		nQtdCX:= CBQEmb()
		If ExistBlock("CBRQEESP")
			nQtdPE:=ExecBlock("CBRQEESP",,,SB1->B1_COD) // ponto de entrada possibilitando ajustar a quantidade por embalagem
			nQtdCX:=If(ValType(nQtdPE)=="N",nQtdPE,nQtdCX)
		EndIf
		If nSaldoCB8/nQtdCX < 1
			nQtdSep := nSaldoCB8
			cUnidade:= If(nQtdSep==1,STR0033,STR0034) //"item "###"itens "
		Else
			nQtdSep := nSaldoCB8/nQTdCx
			cUnidade:= If(nQtdSep==1,STR0035,STR0036) //"volume "###"volumes "
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de Entrada na montagem da tela de separção de expedição.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If VtModelo()=="RF"
		@ 0,0 VTSay Padr(STR0037+Alltrim(Str(nQtdSep,aTam[1],aTam[2]))+" "+cUnidade,20) // //"Separe "
		@ 1,0 VTSay CB8->CB8_PROD
		@ 2,0 VTSay Left(SB1->B1_DESC,20)
		@ 3,0 VTSay Padr("Peso carga:"+Alltrim(Str(nTotEtiq,aTam[1],aTam[2])),20)
		@ 4,0 VTSay Padr("Etiq. Lidas:"+Alltrim(Str(nLidEtiq,aTam[1],aTam[2])),20)
		@ 5,0 VTSay Padr("Peso Item:"+Alltrim(Str(nTotItem,aTam[1],aTam[2])),20)
		If Rastro(CB8->CB8_PROD,"L")
			//@ 3,0 VTSay STR0038+CB8->CB8_LOTECT //"Lote: "
		ElseIf Rastro(CB8->CB8_PROD,"S")
			@ 3,0 VTSay CB8->CB8_LOTECT+"-"+CB8->CB8_NUMLOT
		EndIf
		If !Empty(CB8->CB8_NUMSER)
			@ 4,0 VTSay CB8->CB8_NUMSER
		EndIf
	EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ AglutCB8   ³ Autor ³ ACD                 ³ Data ³ 27/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao que retorna o valor aglutinado de um produto confor-³±±
±±³          ³ parametros informados.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AglutCB8(cOrdSep,cArm,cProd,cItem)
	Local nRecnoCB8:= CB8->(Recno())
	Local nSaldo:=0
	CB8->(DbSetOrder(7))
	CB8->(DbSeek(xFilial("CB8")+cCodSep+cArm))
	While ! CB8->(Eof()) .and. CB8->(CB8_FILIAL+CB8_ORDSEP+CB8_LOCAL==xFilial("CB8")+cCodSep+cArm)
		If ! CB8->(CB8_PROD+CB8_ITEM) ==(cProd+cItem)
			CB8->(DbSkip())
			Loop
		EndIf
		If Empty(CB8->CB8_SALDOS) // ja separado
			CB8->(DbSkip())
			Loop
		EndIf
		nSaldo +=CB8->CB8_SALDOS
		CB8->(DbSkip())
	EndDo
	CB8->(DbGoto(nRecnoCB8))
Return nSaldo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ EtiProduto ³ Autor ³ ACD                 ³ Data ³ 27/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Leitura da etiqueta                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EtiProduto()
	Local cEtiCB0  := Space(TamSx3("CB0_CODET2")[1])
	Local cEtiProd := Space(48)
	Local nQtde    := 1
	Local uRetQtde := 1		
	lEtiProduto := .T.
	While .t.
		If __PulaItem
			Exit
		EndIf
		/*
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		Ponto de entrada permite que o usuário informe o valor da variável nQtde 
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/                 
		If ExistBlock("V166NQTDE")
			uRetQtde :=Execblock("V166NQTDE")
			If(ValType(uRetQtde)=="N" .And. uRetQtde > 0)
				nQtde := uRetQtde
			EndIf			
		EndIf

		If VtModelo()=="RF"
			If UsaCB0("01")
				@ 6,0 VTSay STR0046 //"Leia a etiqueta"
				@ 7,0 VTGet cEtiCB0 pict "@!" Valid VldProduto(cEtiCB0,NIL,NIL)
			EndIf
		Else // para microterminal 44 e 16 teclas
			VtClear()
			If UsaCB0("01")
				@ 0,0 VTSay STR0046 //"Leia a etiqueta"
				@ 1,0 VTGet cEtiCB0 pict "@!" Valid VldProduto(cEtiCB0,NIL,NIL)
			EndIf
		EndIf
		VTRead
		// tratamento de ocorrencia pular o item
		If VTLastkey() == 27
			//Verifica se esta sendo chamado pelo ACDV170 e se existe um avanco
			//ou retrocesso forcado pelo operador
			If ACDGet170() .AND. A170AvOrRet()
				Return .F.
			EndIf
			If VTYesNo(STR0019,STR0014,.T.) //"Confirma a saida?"###"Atencao"
				Return .f.
			Else
				Loop
			Endif
		Endif
		Exit
	Enddo
	lEtiProduto := .F.
Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GravaCB8 ³ Autor ³ ACD                   ³ Data ³ 28/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Expedicao                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GravaCB8(nQtde,cArm,cEnd,cProd,cLote,cSLote,cLoteNew,cSLoteNew,cNumSer,cCodCB0,cNumSerNew)

	Local cEndNew	:= CriaVar("CB8_LCALIZ")
	Local cSequen	:= ""	
	Local aCB8		:= GetArea("CB8")
	Local lACDVCB8 	:= ExistBlock("ACDVCB8")
	Local lRet		:= .F.

	CB8->(DbSetOrder(7))
	CB8->(DbSeek(xFilial("CB8")+cCodSep+cArm))
	While !CB8->(Eof()) .and. CB8->(CB8_FILIAL+CB8_ORDSEP+CB8_LOCAL==xFilial("CB8")+cCodSep+cArm)

		cEndNew := cEnd
		cSequen	:= CB8->CB8_SEQUEN

		If lACDVCB8
			lRet := ExecBlock("ACDVCB8",.F.,.F.,{nQtde,cArm,cEnd,cProd,cLote,cSLote,cLoteNew,cSLoteNew,cNumSer,cCodCB0,cNumSerNew})
			If ValType(lRet)=="L" .and. !lRet
				CB8->(DbSkip())
				Loop
			EndIf
		Endif
		/*If !CB8->(CB8_PROD+CB8_LOTECT+CB8_NUMLOT+CB8_NUMSER==cProd+cLote+cSLote+cNumSer)
		CB8->(DbSkip())
		Loop
		EndIf       */

		If !CB8->(CB8_PROD==cProd)
			CB8->(DbSkip())
			Loop
		EndIf

		/*If Empty(CB7->CB7_PRESEP) .and. (CB8->CB8_LCALIZ <> cEnd .And. !Empty(CB8->CB8_LCALIZ) )
		CB8->(DbSkip())
		Loop
		EndIf*/
		If Empty(CB8->CB8_SALDOS) // ja separado
			CB8->(DbSkip())
			Loop
		EndIf
		If CB7->CB7_ORIGEM == "1" .And. !Empty(CB8->CB8_NUMSER) .And. cNumSerNew # CB8->CB8_NUMSER
			If FindFunction("CBVSUBNSER") .And. SuperGetMV("MV_SUBNSER",.F.,'1') $ '2|3'
				VTMSG(STR0126) //"Processando"
				// Faz a troca do numero de serie
				SubNSer(@cLoteNew,@cSLoteNew,@cEndNew,cNumSerNew,@cSequen)
			EndIf
		EndIF
		RecLock("CB8",.F.)
		If nQtde >= CB8->CB8_SALDOS
			GravaCB9(CB8->CB8_SALDOS,cEndNew,cLoteNew,cSLoteNew,cCodCB0,cNumSerNew,cSequen)
			nQtde -= CB8->CB8_SALDOS
			CB8->CB8_SALDOS := 0
			If "01" $ CB7->CB7_TIPEXP .And. !"02" $ CB7->CB7_TIPEXP
				CB8->CB8_SALDOE := 0
			EndIf
		Else
			CB8->CB8_SALDOS -= nQtde
			If "01" $ CB7->CB7_TIPEXP .And. !"02" $ CB7->CB7_TIPEXP
				CB8->CB8_SALDOE -= nQtde
			EndIf
			GravaCB9(nQtde,cEndNew,cLoteNew,cSLoteNew,cCodCB0,cNumSerNew,cSequen)
			nQtde:=0
		EndIf

		// Atualiza o item da ordem de separação com os dados do novo numero de série
		//If !Empty(CB8->CB8_NUMSER) .And. cNumSerNew # CB8->CB8_NUMSER
		CB8->CB8_LOTECT := cLoteNew
		CB8->CB8_NUMLOT := cSLoteNew	
		CB8->CB8_LCALIZ := cEndNew			
		CB8->CB8_SEQUEN := cSequen
		//EndIf	

		CB8->(MsUnlock())

		If Empty(nQtde)
			Exit
		EndIf
		CB8->(DbSkip())
	EndDo
	RestArea(aCB8)

	Reclock("CB7",.f.)
	CB7->CB7_STATUS := "1"  // inicio separacao
	CB7->(MsUnLock())
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GravaCB9 ³ Autor ³ ACD                   ³ Data ³ 28/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Expedicao                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GravaCB9(nQtde,cEndNew,cLoteNew,cSLoteNew,cCodCB0,cNumSerNew,cSequen)
	Default cCodCB0 := Space(10)

	CB9->(DbSetOrder(10))
	If !CB9->(DbSeek(xFilial("CB9")+CB8->(CB8_ORDSEP+CB8_ITEM+CB8_PROD+CB8_LOCAL+CB8_LCALIZ+cLoteNew+cSLoteNew+CB8_LOTECT+CB8_NUMLOT+CB8_NUMSER+cVolume+cCodCB0+CB8_PEDIDO)))
		RecLock("CB9",.T.)
		CB9->CB9_FILIAL := xFilial("CB9")
		CB9->CB9_ORDSEP := CB7->CB7_ORDSEP
		CB9->CB9_CODETI := cCodCB0
		CB9->CB9_PROD   := CB8->CB8_PROD
		CB9->CB9_CODSEP := CB7->CB7_CODOPE
		CB9->CB9_ITESEP := CB8->CB8_ITEM
		CB9->CB9_SEQUEN := cSequen
		CB9->CB9_LOCAL  := CB8->CB8_LOCAL
		CB9->CB9_LCALIZ := cEndNew
		CB9->CB9_LOTECT := cLoteNew
		CB9->CB9_NUMLOT := cSLoteNew
		CB9->CB9_NUMSER := cNumSerNew
		CB9->CB9_LOTSUG := CB8->CB8_LOTECT
		CB9->CB9_SLOTSU := CB8->CB8_NUMLOT
		If FieldPos("CB9_NSERSU") > 0
			CB9->CB9_NSERSU := CB8->CB8_NUMSER
		EndIf	
		CB9->CB9_PEDIDO := CB8->CB8_PEDIDO

		If '01' $ CB7->CB7_TIPEXP .Or. !Empty(cVolume)
			If !('02' $ CB7->CB7_TIPEXP)
				CB9->CB9_VOLUME := cVolume
			Else
				CB9->CB9_SUBVOL := cVolume
			EndIf
		EndIf

	Else
		RecLock("CB9",.F.)
	EndIf
	CB9->CB9_QTESEP += nQtde
	CB9->CB9_STATUS := "1"  // separado
	CB9->(MsUnlock())

	//permite validar a quantidade separada.
	If ExistBlock("ACDGCB9")
		ExecBlock("ACDGCB9",.F.,.F.,{nQtde})
	EndIf

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Informa    ³ Autor ³ ACD                 ³ Data ³ 31/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Mostra produtos que ja foram lidos                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Informa()
	Local aCab,aSize,aSave := VTSAVE()
	Local aTemp:={}
	Local nTam



	If Empty(cOrdSep)
		Return .f.
	Endif
	VTClear()
	If UsaCB0("01")
		aCab  := {STR0039,STR0052,STR0053,STR0054,STR0042,STR0043,STR0018,STR0055,STR0056,STR0057} //"Produto"###"Quantidade"###"Armazem"###"Endereco"###"Lote"###"Sub-Lote"###"Volume"###"Sub-Volume"###"Num.Serie"###"Id Etiqueta"
	Else
		aCab  := {STR0039,STR0052,STR0053,STR0054,STR0042,STR0043,STR0018,STR0055,STR0056} //"Produto"###"Quantidade"###"Armazem"###"Endereco"###"Lote"###"Sub-Lote"###"Volume"###"Sub-Volume"###"Num.Serie"
	EndIf
	nTam := len(aCab[2])
	If nTam < len(Transform(0,cPictQtdExp))
		nTam := len(Transform(0,cPictQtdExp))
	EndIf
	If UsaCB0("01")
		aSize := {15,nTam,7,10,10,8,10,10,20,12}
	Else
		aSize := {15,nTam,7,10,10,8,10,10,20}
	Endif
	CB9->(DbSetOrder(6))
	CB9->(DbSeek(xFilial("CB9")+cOrdSep))
	While CB9->(! Eof() .and. CB9_FILIAL+CB9_ORDSEP == xFilial("CB9")+cOrdSep)
		If UsaCB0("01")
			aadd(aTemp,{CB9->CB9_PROD,Transform(CB9->CB9_QTESEP,cPictQtdExp),CB9->CB9_LOCAL,CB9->CB9_LCALIZ,CB9->CB9_LOTECT,CB9->CB9_NUMLOT,CB9->CB9_VOLUME,CB9->CB9_SUBVOL,CB9->CB9_NUMSER,CB9->CB9_CODETI})
		Else
			aadd(aTemp,{CB9->CB9_PROD,Transform(CB9->CB9_QTESEP,cPictQtdExp),CB9->CB9_LOCAL,CB9->CB9_LCALIZ,CB9->CB9_LOTECT,CB9->CB9_NUMLOT,CB9->CB9_VOLUME,CB9->CB9_SUBVOL,CB9->CB9_NUMSER})
		Endif
		CB9->(DbSkip())
	EndDo

	VTaBrowse(,,,VtMaxCol(),aCab,aTemp,aSize)
	VtRestore(,,,,aSave)
Return




//======================================================================================================
// Funcoes de validacoes de gets
//======================================================================================================

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ VldCodSep³ Autor ³ ACD                   ³ Data ³ 25/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Validacao da Ordem de Separacao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldCodSep()
	Local lRet := .T.

	If Empty(cOrdSep)
		VtKeyBoard(chr(23))
		Return .f.
	EndIf

	CB7->(DbSetOrder(1))
	If !CB7->(DbSeek(xFilial("CB7")+cOrdSep))
		VtAlert(STR0072,STR0010,.t.,4000,3) //"Ordem de separacao nao encontrada."###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	If "09*" $ CB7->CB7_TIPEXP
		VtAlert(STR0073,STR0074,.t.,4000,3) //"Ordem de Pre-Separacao "###"Codigo Invalido"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf

	If CB7->CB7_STATUS == "3"
		VtAlert(STR0075,STR0010,.t.,4000,3) //"Ordem de separacao em processo de embalagem"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf

	If CB7->CB7_STATUS == "4"
		VtAlert(STR0076,STR0010,.t.,4000,3) //"Ordem de separacao com embalagem finalizada"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf

	If CB7->CB7_STATUS  == "5" .OR.  CB7->CB7_STATUS  == "6"
		VtAlert(STR0077,STR0010,.t.,4000,3) //"Ordem de separacao possui Nota gerada"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf

	If CB7->CB7_STATUS  == "7"
		VtAlert(STR0078,STR0010,.t.,4000,3) //"Ordem de separacao possui etiquetas oficiais de volumes"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf

	If CB7->CB7_STATUS  == "8"
		VtAlert(STR0079,STR0010,.t.,4000,3) //"Ordem de separacao em processo de embarque"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf

	If !(!Empty(CB7->CB7_OP) .Or. CBUltExp(CB7->CB7_TIPEXP) $ "00*01*") .And. CB7->CB7_STATUS == "9"
		VtAlert(STR0080,STR0010,.t.,4000,3) //"Ordem de separacao ja Embarcada"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf

	If CB7->CB7_STATPA == "1" .AND. CB7->CB7_CODOPE # cCodOpe  // SE ESTIVER EM SEPARACAO E PAUSADO SE DEVE VERIFICAR SE O OPERADOR E" O MESMO
		VtBeep(3)
		If ! VTYesNo(STR0081+CB7->CB7_CODOPE+STR0082,STR0010,.T.) //"Ordem Separacao iniciada pelo operador "###". Deseja continuar ?"###"Aviso"
			VtKeyboard(Chr(20))  // zera o get
			Return .F.
		EndIf
	EndIf

	If ExistBlock("ACD166ST")
		lRet := ExecBlock("ACD166ST",.F.,.F.,{cOrdSep})
		lRet := If(ValType(lRet)=="L",lRet,.T.)
	EndIf

	If lRet .And. !MSCBFSem() //fecha o semaforo, somente um separador por ordem de separacao
		VtAlert(STR0083,STR0010,.t.,4000,3) //"Ordem Separacao ja esta em andamento...!"###"Aviso"
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf

	If lRet .And. ExistBlock("ACD166SP")
		lRet := ExecBlock("ACD166SP",.F.,.F.,{cOrdSep})
		lRet := If(ValType(lRet)=="L",lRet,.T.)
	EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³VldProduto³ Autor ³ ACD                   ³ Data ³ 27/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Validacao da etiqueta de produto com ou sem CB0            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldProduto(cEtiCB0,cEtiProd,nQtde)
	Local cCodCB0
	Local cLote       := Space(10)
	Local cSLote      := Space(6)
	Local cNumSer	  := Space(20)
	Local cV166VLD    := If(UsaCB0("01"),Space(TamSx3("CB0_CODET2")[1]),Space(48))
	Local nP          := 0
	Local nQtdTot     := 0
	Local cEtiqueta
	Local aEtiqueta   := {}
	Local aItensPallet:= {}
	Local lIsPallet   := .T.
	Local cMsg        := ""
	Local nSaldo      := 0
	Local nSaldoLote  := 0
	Local aAux        := {}
	Local aV166VLD		:={}
	Local lErrQTD     := .F.
	Local lACD166BEmp := .T.
	DEFAULT cEtiCB0   := Space(TamSx3("CB0_CODET2")[1])
	DEFAULT cEtiProd  := Space(48)
	DEFAULT nQtde     := 1

	If __PulaItem
		Return .t.
	EndIf

	If Empty(cEtiCB0+cEtiProd)
		Return .f.
	EndIf       

	If UsaCB0("01")
		aItensPallet := CBItPallet(cEtiCB0)
	Else 
		aItensPallet := CBItPallet(cEtiProd)
	EndIf	
	If Len(aItensPallet) == 0
		If UsaCB0("01")
			aItensPallet:={cEtiCB0}
		Else
			aItensPallet:={cEtiProd}
		EndIf
		lIsPallet := .f.
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de entrada para configurar se a consulta ao Saldo por Localizacao³
	//³ sera ou nao considerado o empenho (SaldoSBF)                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("ACD166BEMP")
		lACD166BEmp := ExecBlock("ACD166BEMP",.F.,.F.)
		lACD166BEmp := (If(ValType(lACD166BEmp) == "L",lACD166BEmp,.T.))
	Endif

	//validacao
	Begin Sequence
		For nP:= 1 to Len(aItensPallet)
			cEtiqueta:= aItensPallet[nP]

			If UsaCB0("01")
				aEtiqueta := CBRetEti(cEtiqueta,"01")
				If Empty(aEtiqueta)
					cMsg := STR0067 //"Etiqueta invalida"
					Break
				EndIf
				cLote  := aEtiqueta[16]
				cSLote := aEtiqueta[17]
				cNumSer:= aEtiqueta[23]
				cCodCB0:= CB0->CB0_CODETI
				If CB8->CB8_LOCAL <> aEtiqueta[10] 
					cMsg := STR0127 //"Armazem associado a esta etiqueta esta diferente do item da separacao"
					Break
				EndIf
				/*			If CB8->(CB8_LOCAL+CB8_LCALIZ) <> aEtiqueta[10]+aEtiqueta[9] .and. ! Empty(CB8->CB8_LCALIZ)
				cMsg := STR0087 //"Endereco associado a esta etiqueta esta diferente"
				Break
				EndIf    */
				If Ascan(aAux,{|x| x[4] == CB0->CB0_CODETI}) > 0
					cMsg := STR0088 //"Etiqueta ja lida"
					Break
				EndIf
				If A166VldCB9(aEtiqueta[1], CB0->CB0_CODETI)
					cMsg := STR0088 //"Etiqueta ja lida"
					Break
				EndIf
			EndIf
			If CB8->CB8_PROD <> aEtiqueta[1]
				cMsg := STR0089 //"Produto diferente"
				Break
			EndIf
			If ! CBProdLib(CB8->CB8_LOCAL,aEtiqueta[1])
				cMsg:=""
				Break
			EndIf       

			//-- Permite validacao especifica da etiqueta do produto. 

			If ExistBlock("V166VLD")
				cV166VLD :=If(UsaCB0("01"),cEtiCB0,cEtiProd) 
				aV166VLD:=ExecBlock("V166VLD",,,{cV166VLD,nQtde,nSaldoCB8})    
				If !aV166VLD[1]	
					Return .F.  
				Else
					nSaldoCB8:=aV166VLD[2]
				EndIf
			EndIf      
			If nSaldoCB8 < (aEtiqueta[2]*nQtde)
				cMsg := STR0090 //"Quantidade maior que necessario"
				lErrQTD := .t.
				Break
			EndIf
			If !CBRastro(CB8->CB8_PROD,@cLote,@cSLote)
				cMsg:=""
				Break
			EndIf
			If CB7->CB7_ORIGEM # "2" .and. SuperGetMv("MV_ESTNEG") =="N"
				If Localiza(CB8->CB8_PROD) .And. !EMpty(cEndereco)// Diego Modificação para pegar o SALDOB2
					nSaldo := SaldoSBF(CB8->CB8_LOCAL,cEndereco,CB8->CB8_PROD,cNumSer,cLote,cSLote,lACD166BEmp)
				Else
					SB2->(DbSetOrder(1))
					SB2->(DbSeek(xFilial("SB2")+CB8->CB8_PROD+CB8->CB8_LOCAL))
					nSaldo := SaldoSB2()
				EndIf
				If aEtiqueta[2]*nQtde > nSaldo+CB8->CB8_SALDOS
					cMsg := STR0093  //"Saldo em estoque insuficiente"
					lErrQTD := .t.
					Break
				EndIf
			EndIf
			aAdd(aAux,{aEtiqueta[2]*nQtde,cLote,cSLote,cNumSer,cCodCB0})
			aAdd(aAux[Len(aAux)],aEtiqueta[09])
			nPosEndAux := Len(aAux[Len(aAux)])
			nQtdTot+=aEtiqueta[2]*nQtde
		Next nP
		If nQtdTot > nSaldoCB8
			cMsg := STR0094 //"Pallet excede a quantidade a separar"
			lErrQTD := .t.
			Break
		EndIf
		For nP:= 1 to Len(aAux)
			GravaCB8(nQtde,cArm,cEnd,cProd,cLote,cSLote,cLoteNew,cSLoteNew,cNumSer,cCodCB0,cNumSerNew)
			CB8->(GravaCB8(aAux[nP,1],CB8_LOCAL,aAux[nP,nPosEndAux],CB8_PROD,aAux[nP,2],CB8_NUMLOT,aAux[nP,2],aAux[nP,3],CB8_NUMSER,aAux[nP,5],aAux[nP,4]))
		Next nP
		aAux := {}

		Recover
		If ! Empty(cMsg)
			VtAlert(cMsg,STR0010,.t.,4000,4) //"Aviso"
		EndIf
		VtClearGet("cEtiProd")
		VtGetSetFocus("cEtiProd")
		Return .f.
	End Sequence


Return .t.




Static Function MSCBFSem()
	Local nC:= 0
	__nSem := -1
	While __nSem  < 0
		__nSem  := MSFCreate("V166"+cOrdSep+".sem")
		IF  __nSem  < 0
			SLeep(50)
			nC++
			If nC == 3
				Return .f.
			EndIf
		EndIf
	EndDo
	FWrite(__nSem,STR0122+cCodOpe+STR0123+cOrdSep) //"Operador: "###" Ordem de Separacao: "
Return .t.

Static Function MSCBASem()
	If __nSem > 0
		Fclose(__nSem)
		FErase("V166"+cOrdSep+".sem")
	EndIf
Return 10




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ExistCB9Sp³ Autor ³ ACD                   ³ Data ³ 15/02/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica se existe algum produto ja separado para a ordem  ³±±
±±³          ³ de separacao informada.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ cOrdSep : codigo da ordem de separacao a ser analisada.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Logico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ExistCB9Sp(cOrdSep)
	CB9->(DBSetOrder(1))
	CB9->(DbSeek(xFilial("CB9")+cOrdSep))
	While CB9->(! Eof() .and. CB9_FILIAL+CB9_ORDSEP == xFilial("CB9")+cOrdSep)
		If ! Empty(CB9->CB9_QTESEP)
			Return .T.
		EndIf
		CB9->(DbSkip())
	Enddo
Return .F.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A166VldCB9³ Autor ³ Felipe Nunes de Toledo³ Data ³ 15/02/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida se a etiqueta ja foi separada.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A166VldCB9(cProd, cCodEti)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ cProd     = Cod. Produto                                   ³±±
±±³          ³ cCodEti   = Cod. Etiqueta                                  ³±±
±±³          ³ lPreSep   = Verifica Pre-Separacao                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Logico = (.T.) Ja separada  / (.F.) Nao separada           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ACDV166 / ACDV165                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A166VldCB9(cProd, cCodEti, lPreSep)
	Local cSeekCB9  := ""
	Local lRet      := .F.
	Local aArea     := { CB7->(GetArea()), CB9->(GetArea()) }

	Default lPreSep := .F.

	CB9->(DbSetOrder(3))
	If CB9->(DbSeek(cSeekCB9 := xFilial("CB9")+cProd+cCodEti))
		If lPreSep
			lRet := .T.
		EndIf
		Do While !lRet .And. CB9->(CB9_FILIAL+CB9_PROD+CB9_CODETI) == cSeekCB9
			CB7->(DbSetOrder(1))
			If CB7->(DbSeek(xFilial("CB7")+CB9->CB9_ORDSEP)) .And. !("09*" $ CB7->CB7_TIPEXP)
				lRet := .T.
				Exit
			EndIf
			CB9->(dbSkip())
		EndDo
	EndIf

	RestArea(aArea[1])
	RestArea(aArea[2])
Return lRet


Static Function FAltSta(cStatus)
	PA1->(DbSetOrder(1))
	PA1->(DbSeek(xFilial("PA1")+CB7->CB7_ORDSEP))
	RecLock("PA1",.F.)
	PA1->PA1_STATUS := cStatus
	MsUnlock()
Return 


Static Function FFinaliza(aTransferencia)
	Local aAuto 		:= {}
	Local aItem			:= {}
	Local cNumSeq := ProxNum()
	Local nY
	Local lRet := .T.
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.


	Conout("Finalizando o Processo Ordem:"+aTransferencia[1,10])
	AAdd(aAuto,{aTransferencia[1,10],dDataBase}) //Adiciona o cabeçalho da rotina automática
	lMsErroAuto := .F.

	For nY:=1 To Len(aTransferencia)
		aItem := {}
		conout("Transferindo")

		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+aTransferencia[nY,1]))

		SB2->(dbSetOrder(1))
		If ( !SB2->(DbSeek(xFilial("SB2")+SB1->B1_COD+aTransferencia[nY,4])) )
			CriaSB2( SB1->B1_COD,aTransferencia[nY,4] )
		EndIf

		//Origem
		aadd(aItem,SB1->B1_COD)  	//D3_COD
		aadd(aItem,SB1->B1_DESC)    //D3_DESCRI
		aadd(aItem,SB1->B1_UM)  	//D3_UM
		aadd(aItem,aTransferencia[nY,2])   	//D3_LOCAL
		aadd(aItem,aTransferencia[nY,3])		//D3_LOCALIZ

		//Destino
		aadd(aItem,SB1->B1_COD)  	//D3_COD
		aadd(aItem,SB1->B1_DESC)    //D3_DESCRI
		aadd(aItem,SB1->B1_UM)  	//D3_UM
		aadd(aItem,aTransferencia[nY,4])   		//D3_LOCAL
		aadd(aItem,aTransferencia[nY,5])		//D3_LOCALIZ

		aadd(aItem,"")         		//D3_NUMSERI
		aadd(aItem,aTransferencia[nY,6])	//D3_LOTECTL
		aadd(aItem,"")         		//D3_NUMLOTE
		aadd(aItem,CtoD("  /  /  "))	//D3_DTVALID
		aadd(aItem,0)				//D3_POTENCI
		aadd(aItem,aTransferencia[nY,7]) 				//D3_QUANT
		aadd(aItem,aTransferencia[nY,11])				//D3_QTSEGUM
		aadd(aItem,"")   			//D3_ESTORNO
		aadd(aItem,cNumSeq)     		//D3_NUMSEQ
		//aadd(aItem,"SEPARA")//D3_LOTECTL  //Alterado: Williams Messa - 21/01/2020
		//aadd(aItem,"      ")//D3_LOTECTL // Ao invés de passar o Lote como Separa, passando o Lote Original, para gerar o SC9
		aadd(aItem,aTransferencia[nY,6])	//D3_LOTECTL
		aadd(aItem,CtoD("  /  /  "))	//D3_DTVALID
		aadd(aItem,"")				//D3_ITEMGRD
		aadd(aItem,"")				//D3_OBSERVA

		aadd(aAuto,aItem)

	Next nY

	MSExecAuto({|x,y| mata261(x,y)},aAuto,3)

	If lMsErroAuto
		lRet := .F.
		While .T.
			VTALERT("Falha no processo de distribuicao","ERRO",.T.,3000) //"Falha no processo de distribuicao."###"ERRO"
			Conout("Erro na transferencia da Ordem:"+aTransferencia[1,10])
			//conout(MostraErro())
			//VTDispFile(NomeAutoLog(),.t.)
			DisarmTransaction()
			If vtLastKey() == 27
				Loop
			EndIf
		EndDo
	Else
		For nY:=1 To Len(aTransferencia)
			aEmp := {}
			//aAdd(aTransferencia,{CB9->CB9_PROD,CB9->CB9_LOCAL,CB9->CB9_LCALIZ,"70","SEPARA",CB9->CB9_LOTECT,CB9->CB9_QTESEP,SC6->C6_NUM,.F.,CB9->CB9_ORDSEP,ConvUM(CB9->CB9_PROD,CB9->CB9_QTESEP,0,2),lFinanceiro,SC6->(Recno())})
			//aadd(aEmp,{CB9->CB9_LOTECT     ,CB9->CB9_NUMLOT,"SEPARA",CB9->CB9_NUMSER,CB9->CB9_QTESEP,ConvUM(CB9->CB9_PROD,CB9->CB9_QTESEP,0,2),,,,,"70",0})
			//aadd(aEmp,{"SEPARA",Space(TamSx3("CB9_NUMLOT")[1]),"SEPARA",Space(TamSx3("CB9_NUMSER")[1]),aTransferencia[nY,7],aTransferencia[nY,11],,,,,"75",0}) //Antigo do Arlindo
			//Alterado: Williams Messa - 21/01/2020
			aadd(aEmp,{aTransferencia[nY,6],Space(TamSx3("CB9_NUMLOT")[1]),"SEPARA",Space(TamSx3("CB9_NUMSER")[1]),aTransferencia[nY,7],aTransferencia[nY,11],,,,,"75",0})

			SC6->(DbGoto(aTransferencia[nY,13])) 
			cOldLoc := aTransferencia[nY,2]			
			RecLock("SC6",.F.)
			SC6->C6_LOCAL := "75"
			MsUnlock()

			MaLibDoFat(aTransferencia[nY,13],aTransferencia[nY,7],lFinanceiro,.T.     ,.F.    ,.F.   ,    .F.,.F.      ,  ,,aEmp,.F.)


			SC6->(DbGoto(aTransferencia[nY,13])) 				
			RecLock("SC6",.F.)
			SC6->C6_LOCAL := aTransferencia[nY,2]
			MsUnlock()

		
			//Conout("Nro.Ord:"+aTransferencia[1,10]+"Nro.Pedido:"+aTransferencia[1,8]+"Item:"+aTransferencia[1,14])

		Next nY

		Conout("Atualização do SC9, Nro da Ordem: "+aTransferencia[1,10])
		//Chama a Função para Atualizar o SC9.
		FAtuaSC9(aTransferencia[1,10])
		//
		Conout("Concluiu a liberação do faturamento da Ordem:"+aTransferencia[1,10])

	EndIf	

Return lRet
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ FunÁ?o    ¦ FAtuaSC9   ¦ Autor ¦ WILLIAMS MESSA       ¦ Data ¦ 10/01/2020 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ DescriÁ?o ¦ Função relacionar o Nro da Ordem com o SC9                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦*/
Static Function FAtuaSC9(cNumOrd)

Local cQry:=""
Local aArea := GETAREA()

cQry := " SELECT CB8_PEDIDO,CB8_PROD,CB8_XITPED,CB8_ORDSEP  FROM " + RetSqlName("CB8") "
cQry += " WHERE D_E_L_E_T_='' AND CB8_QTDORI > 0 AND CB8_ORDSEP='"+Alltrim(cNumOrd)+"'"

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), "TMP1", .T., .T. )

While !TMP1->(EOF())
		cQuery := " UPDATE "+ RetSqlName("SC9")
		cQuery += " SET C9_ORDSEP = '"+Alltrim(TMP1->CB8_ORDSEP)+"'"
		cQuery += " WHERE C9_ORDSEP ='' AND C9_PEDIDO='"+Alltrim(TMP1->CB8_PEDIDO)+"'" 
		cQuery += " AND C9_ITEM='"+Alltrim(TMP1->CB8_XITPED)+"'"  
		TCSQLEXEC(cQuery)
		//Conout(TMP1->CB8_XITPED)	
	TMP1->(dbSkip())
End
TMP1->(dbCloseArea())
RestArea(aArea)		

Return



Static Function Placa()
	Private cPlaca    := Space(TamSX3("CB7_XPLACA")[1])
	Private cLacre   := Space(TamSX3("CB7_XLACRE")[1])
	Private cTransp    := Space(TamSX3("CB7_TRANSP")[1])
	Private lVolta	:= .T.

	While .T.
		VTClear()
		@ 0,0 VTSay "Placa:"
		@ 1,0 VTGet cPlaca pict "@!" when Empty(Alltrim(cPlaca)) .or. VtLastkey()==5 Valid VldPlaca(cPlaca)
		@ 2,0 VTSay "Transportadora:"
		@ 3,0 VTGet cTransp pict "@!" when Empty(Alltrim(cTransp)) .Or. VtLastkey()==5 valid VldTransp(cTransp) F3 "SA4"
		@ 4,0 VTSay "Lacre:"
		@ 5,0 VTGet cLacre pict "@!" when Empty(Alltrim(cLacre)) .Or. VtLastkey()==5 valid VldLacre(cLacre) 
		VtRead

		If vtLastKey() == 27
			If  ! VTYesNo("Confirma as informacoes","Atencao") //'Confirma a saida?'###'Atencao'
				Loop
			Else
				/*If Empty(cPlaca) .Or. Empty(cTransp)
				Loop
				Else*/
				RecLock("CB7",.F.)
				CB7->CB7_XPLACA := cPlaca
				CB7->CB7_XLACRE := cLacre
				CB7->CB7_TRANSP := cTransp
				MsUnlock()
				Exit
				//EndIf
			EndIf
			Exit
		EndIf
	EndDo
Return

Static Function VldPlaca(cPlaca)
	/*If Empty(Alltrim(cPlaca))
	VTBEEP(2)
	VTALERT("Preencha a placa","AVISO",.T.,3000)  //### //"Nota nao encontrada"###"AVISO"
	VTKeyBoard(chr(20))
	Return .f.
	EndIf*/
Return .T.

Static Function VldTransp(cTransp)
	/*If Empty(Alltrim(cTransp))
	VTBEEP(2)
	VTALERT("Preencha a transportadora","AVISO",.T.,3000)  //### //"Nota nao encontrada"###"AVISO"
	VTKeyBoard(chr(20))
	Return .f.
	EndIf*/
Return .T.

Static Function VldLacre(cLacre)
	/*If Empty(cLacre)
	VTBEEP(2)
	VTALERT("Preencha o Lacre","AVISO",.T.,3000)  //### //"Nota nao encontrada"###"AVISO"
	VTKeyBoard(chr(20))
	Return .f.

	EndIf*/
Return .T.

User Function FPegaSaldo(cOrdem,cProduto)
	Local aRet 		:= {}
	Local cQuery	:= ""
	Default cProduto :=""

	cQuery+=" SELECT ISNULL(COUNT(*),0) AS INDIVI,ISNULL(SUM(CB9_QTESEP),0) AS GERAL FROM "+RetSQLName("CB9")+" (NOLOCK) "
	cQuery+=" WHERE D_E_L_E_T_='' "
	cQuery+=" AND CB9_ORDSEP='"+cOrdem+"' "
	If !Empty(cProduto)
		cQuery+=" AND CB9_PROD='"+cProduto+"' "
	EndIf

	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQuery)), "CRG", .T., .F. )


	aRet := {CRG->INDIVI,CRG->GERAL}

	CRG->(DbCloseArea())
Return aRet 


Static Function FMudaEtiq(cOrdem)

	cQry := " UPDATE "+RetSQLName("CB0")+" "
	cQry += " SET CB0_LOCAL='75',CB0_LOCALI='SEPARA',CB0_LOTE='SEPARA' "
	cQry += " FROM "+RetSQLName("CB0")+" CB0 "
	cQry += " INNER JOIN "+RetSQLName("CB9")+" CB9 ON "
	cQry += " CB9.D_E_L_E_T_='' "
	cQry += " AND CB9.CB9_CODETI=CB0.CB0_CODETI "
	cQry += " AND CB9.CB9_PROD=CB0.CB0_CODPRO "
	cQry += " AND CB9.CB9_ORDSEP='"+cOrdem+"' "
	cQry += " WHERE CB0.D_E_L_E_T_='' "

	TCSqlExec( cQry )
Return
