#INCLUDE "FINA440.CH"
#INCLUDE "PROTHEUS.CH"
Static lFWCodFil	:= FindFunction("FWCodFil")
STATIC nValAbatCom	:= 0
STATIC nSldTitComis	:= 0
STATIC cNatCom
STATIC cComiLiq
STATIC cChaveComis
STATIC cComisCR
STATIC cParComEm
STATIC cMV_1DUP
STATIC lFindPccBx 	:= FindFunction("FPccBxCr")
STATIC lFindIrBx 	:= FindFunction("FIrPjBxCr")
STATIC lFindAtuSld 	:= FindFunction("AtuSldNat")
STATIC lF440BasEm	
STATIC lF440Liq := ExISTBlock("F440LIQ")
STATIC lComiLiq
STATIC lCompensa
STATIC IsBlind
STATIC lFA440VLD :=  ExistBlock("FA440VLD")
STATIC lDevolucao
STATIC lF440DelB
STATIC lGestao
Static lSF2460I := ExistBlock("SF2460I")
Static lF440VEND
Static nTamBascom := TamSX3("E1_BASCOM1")[2]
Static nTamPerc		:= TamSX3("E1_COMIS1")[2]
Static nTamParc  	:= TamSx3("E1_PARCELA")[1]
Static lF440Bases	:= (Existblock("F440aBas"))
Static lF440CVB 		:= ExistBlock("F440CVB")
Static lF440CBase	:= ExistBlock("F440CBASE")
Static lF440JurDes := ExistBlock("F440JurDes")
Static lF440FAL := Existblock("F440FAL")
Static lLj440SbCm:= FindFunction("Lj440SbCom")				//indica se a funcao Lj440SbCom(LOJA440) existe no RPO
Static lPEPerCom := ExistBlock("FIN440PE")
Static cModeAcSE1 := FWModeAccess("SE1",3)
Static cModeAcSF1 := FWModeAccess("SF1",3)
Static cModeAcSF2 := FWModeAccess("SF2",3)
Static cModeAcSF4 := FWModeAccess("SF4",3)
Static cModeAcSE2 := FWModeAccess("SE2",3)
Static cModeAcSE4 := FWModeAccess("SE4",3)
Static cModeAcSD1 := FWModeAccess("SD1",3)
Static cModeAcSD2 := FWModeAccess("SD2",3)
Static nTamE2_NATUR := TamSx3("E2_NATUREZ")[1]
Static aRelImp

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINA440    ³ Autor ³ Eduardo Riera         ³ Data ³ 16.12.97³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ C lculo de comissäes off-line                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FINA440()                                                   ³±±     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±        
±±³ Uso      ³ SIGAFIN                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ DATA   ³ BOPS ³Prograd.³ALTERACAO                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³08.03.01³xxxxxx³Jeniffer³Calculo da Comiss. Vend. conforme imposto inci-³±±
±±³        ³      ³        ³de ou nao na nota.                             ³±±
±±ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/
User Function xFINA440()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local   nOpca := 0

Local aSays:={}, aButtons:={}

Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Private cCadastro := OemToAnsi(STR0003) //"C lculo de Comiss”es Off-Line"

//AjustaSX1()

Pergunte("AFI440",.f.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o log de processamento                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogIni( aButtons )

AADD(aSays,OemToAnsi( STR0004 ) ) //"  Este programa tem como objetivo executar os c lculos das comiss”es dos"
AADD(aSays,OemToAnsi( STR0005 ) ) //"vendedores, conforme os parƒmetros definidos pelo usu rio.              "
If lPanelFin  //Chamado pelo Painel Financeiro			
	aButtonTxt := {}			
	If Len(aButtons) > 0
		AADD(aButtonTxt,{"STR0012","STR0012",aButtons[1][3]}) // Visualizar			
	Endif
	AADD(aButtonTxt,{STR0011,STR0011, {||Pergunte("AFI440",.T. )}}) // Parametros						
	FaMyFormBatch(aSays,aButtonTxt,{||nOpca :=1},{||nOpca:=0})	
Else
	AADD(aButtons, { 5,.T.,{|| Pergunte("AFI440",.T. ) } } )
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	FormBatch( cCadastro, aSays, aButtons ,,,425)
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Parƒmetros:                                                               ³
//³ mv_par01 = Data Inicial       ?                                          ³
//³ mv_par02 = Data Final         ?                                          ³
//³ mv_par03 = Do Vendedor        ?                                          ³
//³ mv_par04 = At‚ o Vendedor     ?                                          ³
//³ mv_par05 = Considera Juros    ? Sim/NÆo                                  ³
//³ mv_par06 = Considera Descontos? Sim/NÆo                                  ³
//³ mv_par07 = Calcula Comiss s/NCC? Sim/NÆo                                 ³
//³ mv_par08 = Calcular           ? Ambas/Emissao/Baixa   				     ³
//³ mv_par09 = Considera Data     ? Data Baixa/Data Disponib.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( nOpcA == 1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("INICIO")
	

	If ExistBlock("FN440COM")
		ExecBlock("FN440COM",.F.,.F.)
	EndIf

	Processa({|lEnd| fa440DelE3(MV_PAR08)},STR0007)  //"Excluindo Comiss”es n„o pagas"
	If ( MV_PAR08 <> 3 )
		Processa({|lEnd| fa440ProcE()},STR0008) //"Calculando Comiss”es pela Emiss„o"
	EndIf
	If ( MV_PAR08 <> 2 )
		Processa({|lEnd| fa440ProcB()},STR0009) //"Calculando Comiss”es pela Baixa"
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("FIM")
		
EndIf

dbSelectArea("SE3")
dbSetOrder(1)

If lPanelFin  //Chamado pelo Painel Financeiro			
	dbSelectArea(FinWindow:cAliasFile)					
	ReCreateBrow(FinWindow:cAliasFile,FinWindow)      		
	INCLUI := .F.
	ALTERA := .F.	
Endif
Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FA440DelE3   ³ Autor ³ Eduardo Riera         ³ Data ³17/12/97³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Zera as comissoes do periodo                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA440                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa440DelE3(nTipo)

Local aArea		:= GetArea()
Local cChave    := ""
Local cArqInd   := ""
Local nValComis	:= ""
Local lAtuSldNat 		:= lFindAtuSld .AND. AliasInDic("FIV") .AND. AliasInDic("FIW")
Local lE3Moeda := SE3->(FieldPos("E3_MOEDA")) > 0
#IFDEF TOP
	Local lDelFisico	:= GetNewPar('MV_FIN440D',.T.)
	Local cQuery		:= ""
	Local nX			:= 0
	Local nMax			:= 0
	Local nMin			:= 0
	Local cNatCom		:= PADR(&(GetNewPar("MV_NATCOM","")),nTamE2_NATUR)
#ELSE
	Local nIndex    := 0
	Local cNatCom		:= PADR(&(GetNewPar("MV_NATCOM","")),nTamE2_NATUR)
#ENDIF

dbSelectArea("SE3")
dbSetOrder(1)
ProcRegua(RecCount())
#IFDEF TOP
	If ( TcSrvType()!="AS/400" ) .And. lDelFisico

		//Atualiza saldo das naturezas antes de deletar as comissoes
		If lAtuSldNat .and. cNatCom != NIL
			cQuery := "SELECT E3_VENCTO, SUM(E3_COMIS) VLRCOMIS , E3_EMISSAO "
			If lE3Moeda
				cQuery += ", E3_MOEDA "
			EndIf
			cQuery += "FROM "+RetSqlName("SE3")+" SE3 "
			cQuery += "WHERE SE3.E3_FILIAL='"+xFilial("SE3")+"' AND "
			cQuery += 	"SE3.E3_EMISSAO>='"+Dtos(mv_par01)+"' AND "
			cQuery += 	"SE3.E3_EMISSAO<='"+Dtos(mv_par02)+"' AND "
			cQuery += 	"SE3.E3_VEND>='"+mv_par03+"' AND "
			cQuery += 	"SE3.E3_VEND<='"+mv_par04+"' AND "
			cQuery += 	"SE3.E3_DATA='"+Dtos(Ctod(""))+"' AND "
			cQuery += 	"SE3.E3_ORIGEM NOT IN(' ','L') AND "
			Do Case
			Case nTipo == 2
				cQuery += "SE3.E3_BAIEMI='E' AND "
			Case nTipo == 3
				cQuery += "SE3.E3_BAIEMI='B' AND "			
			EndCase
			cQuery += 	"SE3.D_E_L_E_T_ = ' ' "
			cQuery += 	"GROUP BY E3_VENCTO , E3_EMISSAO "

			If lE3Moeda
				cQuery += ", E3_MOEDA "
			EndIf			
	
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBNAT")
		
			TCSetField('TRBNAT','E3_VENCTO','D',8,0)
			TCSetField('TRBNAT','VLRCOMIS' ,'N',17,2)
			TCSetField('TRBNAT','E3_EMISSAO','D',8,0)

		   dbSelectArea("TRBNAT")
			While !Eof()
				// Tratamento de outras moedas no controle de saldos do fluxo de caixa por natureza
				If lE3Moeda .AND. VAL(TRBNAT->E3_MOEDA) > 1
					nValComis := NOROUND(XMOEDA(TRBNAT->VLRCOMIS,01,VAL(TRBNAT->E3_MOEDA),TRBNAT->E3_EMISSAO))
				Else
			   		nValComis := TRBNAT->VLRCOMIS		
				EndIf
				
				//Atualizo o valor atual para o saldo da natureza
				//Diminuo pois as comissoes serao recalculadas e somadas posteriormente
				AtuSldNat(cNatCom, TRBNAT->E3_VENCTO, Iif(lE3Moeda,TRBNAT->E3_MOEDA,"01"), "2", "P",nValComis, TRBNAT->VLRCOMIS,"-",,FunName(),"SE3",SE3->(Recno()))
				dbSkip()
			Enddo
			dbCloseArea()
			dbSelectArea("SE3")
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica qual eh o maior e o menor Recno que satisfaca a selecao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "SELECT MIN(R_E_C_N_O_) MINRECNO,"
		cQuery += "       MAX(R_E_C_N_O_) MAXRECNO "
		cQuery += "  FROM "+RetSqlName("SE3")+" SE3 "
		cQuery += " WHERE SE3.E3_FILIAL   = '"+xFilial("SE3")+"'"
		cQuery += "   AND SE3.E3_EMISSAO >= '"+Dtos(mv_par01)+"'"
		cQuery += "   AND SE3.E3_EMISSAO <= '"+Dtos(mv_par02)+"'"
		cQuery += "   AND SE3.E3_VEND    >= '"+mv_par03+"'"
		cQuery += "   AND SE3.E3_VEND    <= '"+mv_par04+"'"
		cQuery += "   AND SE3.E3_DATA     = '"+Dtos(Ctod(""))+"'"
		cQuery += "   AND SE3.E3_ORIGEM NOT IN(' ','L') AND "
		Do Case
			Case nTipo == 2
				cQuery += "SE3.E3_BAIEMI='E' AND "
			Case nTipo == 3
				cQuery += "SE3.E3_BAIEMI='B' AND "			
		EndCase
	
		cQuery += 	" SE3.D_E_L_E_T_<>'*'" 
		cQuery := ChangeQuery(cQuery)

	  	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"FA440DELE3")
		
		nMax := FA440DELE3->MAXRECNO
		nMin := FA440DELE3->MINRECNO
		dbCloseArea()
		dbSelectArea("SE3")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta a string de execucao no banco³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "DELETE FROM "+RetSqlName("SE3")+" "
		cQuery += " WHERE E3_FILIAL   = '"+xFilial("SE3")+"'"
		cQuery += "   AND E3_EMISSAO >= '"+Dtos(mv_par01)+"'"
		cQuery += "   AND E3_EMISSAO <= '"+Dtos(mv_par02)+"'"
		cQuery += "   AND E3_VEND    >= '"+mv_par03+"'"
		cQuery += "   AND E3_VEND    <= '"+mv_par04+"'"
		cQuery += "   AND E3_DATA     = '"+Dtos(Ctod(""))+"'"
		cQuery += "   AND E3_ORIGEM NOT IN(' ','L') AND "

		Do Case
			Case nTipo == 2
				cQuery += "E3_BAIEMI='E' AND "
			Case nTipo == 3
				cQuery += "E3_BAIEMI='B' AND "
		EndCase              
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Executa a string de execucao no banco para os proximos 1024 registro a fim de nao estourar o log do SGBD³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX := nMin To nMax STEP 1024
			cChave := "R_E_C_N_O_>="+Str(nX,10,0)+" AND R_E_C_N_O_<="+Str(nX+1023,10,0)+""
			TcSqlExec(cQuery+cChave)
		Next nX
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³A tabela eh fechada para restaurar o buffer da aplicacao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE3")
		dbCloseArea()
		ChkFile("SE3",.F.)
	Else
#ENDIF
	cQuery := 'E3_FILIAL=="'+xFilial("SE3")+'".And.'
	cQuery += 'Dtos(E3_EMISSAO)>="'+Dtos(mv_par01)+'".And.'
	cQuery += 'Dtos(E3_EMISSAO)<="'+Dtos(mv_par02)+'".And.'
	cQuery += 'E3_VEND>="'+mv_par03+'".And.'
	cQuery += 'E3_VEND<="'+mv_par04+'".And.'
	cQuery += 'Dtos(E3_DATA)=="'+Dtos(cTod(""))+'".And.'
	Do Case
	Case nTipo == 2
		cQuery += "E3_BAIEMI='E'.And."
	Case nTipo == 3
		cQuery += "E3_BAIEMI='B' .And."
	EndCase		
	cQuery += '!(E3_ORIGEM$" #L")'
	cArqInd  := CriaTrab(,.F.)
	cChave   := IndexKey()
	IndRegua("SE3",cArqInd,cChave,,cQuery,OemToAnsi(STR0006))  //"Selecionando Registros..."
	nIndex := RetIndex("SE3")
	dbSelectArea("SE3")
	#IFNDEF TOP
		dbSetIndex(cArqInd+OrdBagExt())
	#ENDIF
	dbSelectArea("SE3")
	dbSetOrder(nIndex+1)
	MsSeek(xFilial("SE3"),.T.)

	While ( ! Eof() .And. xFilial("SE3") == SE3->E3_FILIAL )

		//Atualiza saldo das naturezas antes de deletar as comissoes
		If lAtuSldNat .and. cNatCom != NIL
			// Tratamento de outras moedas no controle de saldos do fluxo de caixa por natureza
			If lE3Moeda .AND. VAL(SE3->E3_MOEDA) > 1
				nValComis := NOROUND(XMOEDA(SE3->E3_COMIS,"01",SE3->E3_MOEDA,SE3->E3_EMISSAO))
			Else
		   		nValComis := SE3->E3_COMIS		
			EndIf
			//Diminuo pois as comissoes serao recalculadas e somadas posteriormente
			AtuSldNat(cNatCom, SE3->E3_VENCTO,Iif(lE3Moeda, SE3->E3_MOEDA, "01"), "2", "P", nValComis, SE3->E3_COMIS,"-",,FunName(),"SE3",SE3->(Recno()) )
		Endif	

		RecLock("SE3",.F.)
		dbDelete()
		MsUnlock()
		dbSelectArea("SE3")
		dbSkip()
		IncProc()
	Enddo
	dbSelectArea("SE3")
	RetIndex("SE3")
	dbClearFilter()
	FErase(cArqInd+OrdBagExt())
	#IFDEF TOP
	EndIf
	#ENDIF
RestArea(aArea)
Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FA440ProcE   ³ Autor ³ Eduardo Riera         ³ Data ³16/12/97³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Processa o c lculo das comissoes pela Emissao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA440                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa440ProcE()

Local cAlias	:= "SE1"
Local cChave	:= ""
Local cQuery	:= ""
Local cArqInd	:= ""
Local nIndex    := 0
#IFDEF TOP
	Local nX			:= 0
#ENDIF	
Local lQuery	:= .F.
Local lComiDev := SuperGetMv("MV_COMIDEV")
Local lDesdobr := .F.
Local lF440COM := ExistBlock("F440COM") 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando Registros                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE1")
dbSetOrder(1)
ProcRegua(RecCount())
#IFDEF TOP
	If ( TcSrvType()!="AS/400" )
		lQuery := .T.
		cAlias := "FA440PROCE"
		
		cQuery := "SELECT R_E_C_N_O_     SE1RECNO,       SE1.E1_TIPO,  SE1.E1_ORIGEM,  "
		cQuery += "       SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM,   SE1.E1_PARCELA, SE1.E1_CLIENTE, SE1.E1_LOJA, "
		cQuery += "       SE1.E1_VEND1,  SE1.E1_VEND2,   SE1.E1_VEND3, SE1.E1_VEND4, SE1.E1_VEND5, SE1.E1_DESDOBR "
		cQuery += "  FROM "+RetSqlName("SE1")+" SE1 "
		cQuery += " WHERE SE1.E1_FILIAL   = '"+xFilial("SE1")+"'"
		cQuery += "   AND SE1.E1_EMISSAO >= '"+DTOS(mv_par01)+"'"
		cQuery += "   AND SE1.E1_EMISSAO <= '"+DTOS(mv_par02)+"'"
		// Filtro para rodar a atualização somente dos vendedores escolhidos no filtro.
		cQuery += " AND ("		
		cQuery += " (SE1.E1_VEND1 >= '"+mv_par03+"'  AND "
		cQuery += "  SE1.E1_VEND1 <= '"+mv_par04+"') OR  "
		cQuery += " (SE1.E1_VEND2 >= '"+mv_par03+"'  AND "
		cQuery += "  SE1.E1_VEND2 <= '"+mv_par04+"') OR  "		
		cQuery += " (SE1.E1_VEND3 >= '"+mv_par03+"'  AND "
		cQuery += "  SE1.E1_VEND3 <= '"+mv_par04+"') OR  "		
		cQuery += " (SE1.E1_VEND4 >= '"+mv_par03+"'  AND "
		cQuery += "  SE1.E1_VEND4 <= '"+mv_par04+"') OR  "		
		cQuery += " (SE1.E1_VEND5 >= '"+mv_par03+"'  AND "
		cQuery += "  SE1.E1_VEND5 <= '"+mv_par04+"')) "		
		cQuery += " AND "
		cQuery += " SE1.E1_TIPO NOT IN('" + MVRECANT + "','NCC'"
		If ( !lComiDev )
			For nX := 1 To Len(MV_CRNEG) STEP 4     
				If SubStr(MV_CRNEG,nX,3)<>'NCC'
					cQuery += ",'"+SubStr(MV_CRNEG,nX,3)+"'"
				EndIf
			Next nX
		EndIf
		cQuery += ") AND SE1.E1_ORIGEM NOT LIKE 'LOJA%' "
		cQuery += "  AND SE1.D_E_L_E_T_<>'*' "
		
		cQuery += "Union All "
		cQuery += "SELECT R_E_C_N_O_     SE1RECNO,       SE1.E1_TIPO,  SE1.E1_ORIGEM,  "
		cQuery += "       SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM,   SE1.E1_PARCELA, SE1.E1_CLIENTE, SE1.E1_LOJA, "
		cQuery += "       SE1.E1_VEND1,  SE1.E1_VEND2,   SE1.E1_VEND3, SE1.E1_VEND4, SE1.E1_VEND5, SE1.E1_DESDOBR "
		cQuery += "  FROM "+RetSqlName("SE1")+" SE1 "
		cQuery += " WHERE SE1.E1_FILIAL   = '"+xFilial("SE1")+"'"
		cQuery += "   AND SE1.E1_EMISSAO >= '"+DTOS(mv_par01)+"'"
		cQuery += "   AND SE1.E1_EMISSAO <= '"+DTOS(mv_par02)+"'"
		If lF440COM
			cQuery += "   AND SE1.E1_TIPO IN " + FormatIn(MVRECANT + "|" + MV_CRNEG, "|")
		Else 
			cQuery += "   AND SE1.E1_TIPO     = 'NCC' "
		EndIf
		cQuery += "   AND SE1.E1_ORIGEM NOT LIKE 'LOJA%' "
		cQuery += "   AND SE1.D_E_L_E_T_<>'*' "
		cQuery += "ORDER BY "+SqlOrder(SE1->(IndexKey()))
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias)
	Else
#ENDIF
	cQuery	:= 'E1_FILIAL=="'+xFilial("SE1")+'".And.'
	cQuery	+= 'DTOS(E1_EMISSAO)>="'+DTOS(mv_par01)+'".And.'
	cQuery	+= 'DTOS(E1_EMISSAO)<="'+DTOS(mv_par02)+'".And.'
	cQuery	+= '!(E1_TIPO $ "' + MVRECANT + If(!lComiDev,'#'+MV_CRNEG,'')+'")'
	cQuery	+= '.And.!("LOJA"$E1_ORIGEM)'
	cArqInd  := CriaTrab(,.F.)
	cChave   := IndexKey()
	IndRegua("SE1",cArqInd,cChave,,cQuery,OemToAnsi(STR0006))  //"Selecionando Registros..."
	nIndex := RetIndex("SE1")
	dbSelectArea("SE1")
	#IFNDEF TOP
		dbSetIndex(cArqInd+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)
	MsSeek(xFilial("SE1"),.T.)
	#IFDEF TOP
	EndIf
	#ENDIF
While ( ! Eof() )
	If !(cAlias)->E1_TIPO $ MVABATIM
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calculo da Comissao na Emissao                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If (cAlias)->E1_DESDOBR == "1"
			lDesdobr := VerBxDsd((cAlias)->E1_PREFIXO, (cAlias)->E1_NUM, (cAlias)->E1_PARCELA, (cAlias)->E1_TIPO, (cAlias)->E1_CLIENTE, (cAlias)->E1_LOJA )
		EndIf
		
		If !lDesdobr
			dbSelectArea("SE1")
			MsGoto(If(lQuery,(cAlias)->(SE1RECNO),RecNo()))
			Fa440CalcE("FINA440",mv_par03,mv_par04)
		EndIf
	EndIf
	dbSelectArea(cAlias)
	dbSkip()
	IncProc(STR0010+":"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA) //"Titulo"
EndDo
If ( lQuery )
	dbSelectArea(cAlias)
	dbCloseArea()
Else
	dbSelectArea("SE1")
	RetIndex("SE1")
	dbClearFilter()
	FErase(cArqInd+OrdBagExt())
EndIf
dbSelectArea("SE1")
Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fa440CalcE³ Autor ³ Eduardo Riera         ³ Data ³ 16/12/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua c lculo das comissoes pela emissao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1: Origem da Comissao			 			          ³±±
±±³			 ³ ExpC2: Vendedor De 										  ³±±
±±³			 ³ ExpC3: Vendedor Ate										  ³±±
±±³			 ³ ExpC4: Sinal da Comissao (+/-) 							  ³±±
±±³			 ³ ExpL5: Indica se a Comissao ira considerar as parcelas do  ³±±
±±³     	    ³        Titulo Financeiro                                ³±±
±±³			 ³ ExpN6: Indica se a Comissao ira considerar as parcelas do  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Fina440                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fa440CalcE(cOrigem,cVendDe,cVendAte,cSinal,lParcela)

Local aArea 	 := GetArea()
Local nCntFor    := 1
Local lPago      := .F.
Local aBases     := {}
Local nBases	 := 0
Local nValor     := 0
Local nVlrProp   := 0
Local cVend      := ""
Local cVendedor  := ""
Local aVendedor  := {}
Local cParcela   := Space(nTamParc)
Local nDia		 := 0
Local nMes		 := 0
Local nAno		 := 0
Local dVencto	 := Ctod("")
Local lComVdBlq  	:= .T.
Local nRecFor, nOrdFor, lBlqFor := .F.
Local nValComis	:= 0
Local nDecimal  	:= nTamBascom
Local lAtuSldNat 	:= lFindAtuSld .AND. AliasInDic("FIV") .AND. AliasInDic("FIW")
Local cNatCom		:= PADR(&(GetNewPar("MV_NATCOM","")),nTamE2_NATUR)
Local nPosVend	:= 0	//posicao do campo E3_VEND
Local nPosBase	:= 0	//posicao do campo E3_BASE
Local aSE3		:= {}	//array com os dados da comissao
Local nI		:= 0	//contador
Local cSuperv	:= ""	//Supervisor do Vendedor (A3_SUPER)
Local cGerente	:= ""	//Gerente do Vendedor (A3_GEREN)
Local cMvTpComLj:= AllTrim( SuperGetMV("MV_TPCOMLJ",,"B") )	//indica se a comissao eh online ou offline (SIGALOJA)
Local lFC_ABATCOM := SFC->(FieldPos("FC_ABATCOM")) > 0

Private nJuros 	:= 0
Private nDescont:= 0
Private nMulta	:= 0

DEFAULT lF440BasEm	:= Existblock("F440BASE")
DEFAULT cParComEm 	:= GetNewPar("MV_PARCOMI","N") // Parcelamento da comissao na emissao
DEFAULT lF440VEND		:= ExistBlock("F440VEND")

If (lParcela == Nil)
	lParcela:= .F.
EndIf
If lParcela
	cParComEm:= "S"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada para validacoes de usuario para calculo de comissao  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lFA440VLD .And. ! ExecBlock( "FA440VLD", .F., .F., 1 )
	Return .F.
EndIf

dbSelectArea("SE3")    // Para Abrir se precisar
dbSelectArea (aArea[1])
cOrigem  := If(Empty(cOrigem),"FINA440",cOrigem)
cVendDe  := If( cVendDe==Nil ,Space(Len(SE3->E3_VEND)),cVendDe)
cVendAte := If( cVendAte==Nil,Repl("z",Len(SE3->E3_VEND)),cVendAte)
cSinal   := If( cSinal  == Nil ,If(SE1->E1_TIPO$MV_CRNEG,"-","+"),cSinal)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria a natureza IRF caso nao exista		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAreaSED  	:= SED->(GetArea())
DbSelectArea("SED")
If ( !DbSeek(XFILIAL("SED")+cNatCom) ) .AND. lAtuSldNat
	RecLock("SED",.T.)
	SED->ED_FILIAL  := XFILIAL("SED")
	SED->ED_CODIGO  := cNatCom
	SED->ED_CALCIRF := "N"
	SED->ED_CALCISS := "N"
	SED->ED_CALCINS := "N"
	SED->ED_CALCCSL := "N"
	SED->ED_CALCCOF := "N"
	SED->ED_CALCPIS := "N"
	SED->ED_DESCRIC := "COMISSOES DE VENDEDORES"
	SED->ED_TIPO	:= "2"
	MsUnlock()
	FKCOMMIT()
Else
	RestArea(aAreaSED)

EndIf


If !(SE1->E1_TIPO$MV_CRNEG+"/"+MVTAXA+"/"+MVPROVIS+"/"+MVRECANT+"/"+MV_CRNEG) .Or. ;
		(SE1->E1_TIPO$MV_CRNEG .And. SuperGetMv("MV_COMIDEV")) .And.;
		!SE1->E1_TIPO $ MVABATIM .And. !"LOJA"$SE1->E1_ORIGEM 
		
	If Alltrim(SE1->E1_FATURA) == "NOTFAT"	
		Return .f.
	EndIf

	aBases   := Fa440Comis(SE1->(Recno()),.T.,.T.)
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada para manipular o tratamento do calculo      ³
	//³ das bases da comissao.                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lF440BasEm
		aBases := ExecBlock("F440BASE",.F.,.F.,aBases)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona vendedores que deverÆo ter comissÆo calculada por t¡tulo. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	For nCntFor := 1 To Len(aBases)
		If lF440VEND
			lRet := ExecBlock("F440VEND",.f.,.f.,{aBases[nCntFor,1],SE1->E1_NUM})
			If lRet == .T.
				cVendedor := aBases[nCntFor,1]
			Else
				cVendedor := ""
			EndIf
		Else
			cVendedor := aBases[nCntFor,1]
		EndIf
		If (!Empty(cVendedor) .And. ;
				cVendedor >= cVendDe .And. ;
				cVendedor <= cVendAte )
			AAdd( aVendedor, { cVendedor })
		EndIf
	Next nCntFor

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Efetua os c lculos para cada vendedor.                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nCntFor := 1 To Len( aVendedor )
		lPago  := .F.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Procura a Base da Comissao                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nBases := aScan(aBases,{|x| x[1] == aVendedor[nCntFor][1] })
		If ( nBases <> 0 )
			nValor := aBases[nBases][5]
			nVlrProp := aBases[nBases][3]
			If cPaisLoc == "PTG" .And. lFC_ABATCOM
				nValor := aBases[nBases,11]
				nVlrProp := aBases[nBases,12]
			EndIf
		Else
			nValor := 0	
		EndIf

		aBases[nBases] := Fa440LjTrc(@nVlrProp,@nValor,aBases[nBases],"E")	

		If ( nValor <> Nil .And. nValor <> 0 )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Caso venha a ser gerada comissao na emissao por cada parcela ³
			//³ definida na comissao de pagto, grava-se a parcela do SE1.    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cParcela := IIF(cParComEm=="S",SE1->E1_PARCELA,Space(nTamParc))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava resultado no arquivo de pgto. de comissäes.            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SA3->(MsSeek(xFilial("SA3")+aVendedor[nCntFor,1]))

			//ponto de entrada para validar se calcula comissao para vendedores bloqueados
			If lF440CVB			//ponto de entrada para validar se calcula comissao para vendedores bloqueados
				lComVdBlq := ExecBlock("F440CVB",.F.,.F.)
			Endif

			If lComVdBlq
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³Verifica se o Fornecedor relacionado ao vendedor estah ou nao bloqueado ³ 
                //³e estando (SA2->A2_MSBLQL == "1") nao eh gerada a comissao              ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
				If !Empty(SA3->A3_FORNECE)
					lBlqFor := .F.
					DbSelectArea("SA2")	
		            nRecFor := Recno()	
		            nOrdFor := IndexOrd()
		            dbSetOrder(1)
		            If DbSeek(xFilial("SA2")+SA3->A3_FORNECE+SA3->A3_LOJA)
		               If Alltrim(SA2->A2_MSBLQL) == "1"
		        		  lBlqFor := .T.	        	   		   
		               Endif	            
		            Endif
		            DbSelectArea("SA2")
		            dbSetOrder(nOrdFor)
		            dbGoto(nRecFor)
				Endif
				
				dbSelectArea("SE3")
				dbSetOrder(3)	//E3_FILIAL + E3_VEND + E3_CODCLI + E3_LOJA + E3_PREFIXO + E3_NUM + E3_PARCELA + E3_TIPO + E3_SEQ
				MsSeek(xFilial("SE3")+aVendedor[nCntFor,1]+;
					SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+cParcela+SE1->E1_TIPO+Space(Len(SE3->E3_SEQ)),.F.)
				If ( Found() )
					If ( !Empty(SE3->E3_DATA) )
						lPago := .T.
						If ( !cOrigem $ "FINA440" ) //.And. cSinal == "-" )
							RecLock("SE3",.T.)
						EndIf
					Else
						lPago := .F.                   
						RecLock("SE3",.F.)
					EndIf
				Else
					lPago := .F.
					If !lBlqFor
					   RecLock("SE3",.T.)
					Endif   					
				EndIf
				If aBases[nBases][5] <> Nil .AND. !lBlqFor
					If ( (!lPago .Or. !cOrigem$"FINA440") .And. aBases[nBases][5] <> 0 )
						SE3->E3_BASE    += (nVlrProp * Iif(cSinal == "-",-1,1) )	// Valor Base da Comissao
						// tratamento para arredondamentos
						If SE3->E3_COMIS == Round(nValor,nDecimal)
							SE3->E3_COMIS   += (Round(nValor,nDecimal) * Iif(cSinal == "-",-1,1) ) // Valor a Pagar ( na EmissÆo )
						Else
							SE3->E3_COMIS   += (nValor * Iif(cSinal == "-",-1,1) ) // Valor a Pagar ( na EmissÆo )
						Endif

						SE3->E3_FILIAL  := xFilial()				// Filial
						SE3->E3_VEND    := aVendedor[nCntFor,1]		// C¢d. Vendedor
						SE3->E3_NUM     := SE1->E1_NUM        		// No. T¡tulo
						SE3->E3_SERIE   := SE1->E1_SERIE
						SE3->E3_PORC    := Abs(Round(SE3->E3_COMIS/SE3->E3_BASE,nDecimal+2)*100)	// % da ComissÆo ( na EmissÆo )
						SE3->E3_CODCLI  := SE1->E1_CLIENTE    		// C¢d. Cliente
						SE3->E3_LOJA    := SE1->E1_LOJA       		// Loja
						SE3->E3_EMISSAO := SE1->E1_EMISSAO    		// Data da emissao do t¡tulo
						SE3->E3_PREFIXO := SE1->E1_PREFIXO    		// Prefixo do T¡tulo
						SE3->E3_PARCELA := cParcela
						SE3->E3_TIPO    := SE1->E1_TIPO       		// Tipo do T¡tulo
						SE3->E3_BAIEMI  := "E"                		// Flag (Pago na Emissao)
						SE3->E3_ORIGEM  := Fa440Origem(If(Empty(SE1->E1_ORIGEM),cOrigem,SE1->E1_ORIGEM))
						SE3->E3_PEDIDO  := SE1->E1_PEDIDO

						If ( aBases[nBases][7] <> 0 )
							SE3->E3_PORC := aBases[nBases][7]
						EndIf

						If Empty( SA3->A3_DIA )
							dVencto := SE1->E1_EMISSAO
						Else
							dVencto := Ctod( strzero(SA3->A3_DIA,2)+"/"+;
								strzero(month(SE1->E1_EMISSAO),2)+"/"+;
								strzero( year(SE1->E1_EMISSAO),4),"ddmmyy")
							nDia := SA3->A3_DIA

							While empty( dVencto)
								nDia -= 1
								dVencto := CtoD(strzero(nDia,2)+"/"+;
									strzero(month(SE1->E1_EMISSAO),2)+"/"+;
									strzero( year(SE1->E1_EMISSAO),4),"ddmmyy")
							EndDo
						EndIf
	
						if SA3->A3_DDD == "F" .or. dVencto < SE1->E1_EMISSAO		//Fora o mes
							nDia := SA3->A3_DIA
							nMes := month(dVencto) + 1
							nAno := year (dVencto)
							If nMes == 13
								nMes := 01
								nAno := nAno + 1
							Endif
							nDia	  := strzero(nDia,2)
							nMes	  := strzero(nMes,2)
							nAno	  := substr(lTrim(str(nAno)),3,2)
							dVencto := CtoD(nDia+"/"+nMes+"/"+nAno,"ddmmyy")
						Else
							nDia	  := strzero(day(dVencto),2)
							nMes	  := strzero(month(dVencto),2)
							nAno	  := substr(lTrim(str(Year(dVencto))),3,2)
						Endif
	
						While empty( dVencto)
							nDia := if(Valtype(nDia)=="C",Val(nDia),nDia)
							nDia -= 1
							dVencto := CtoD(strzero(nDia,2)+"/"+nMes+"/"+nAno,"ddmmyy")
							if !empty( dVencto )
								if dVencto < SE1->E1_EMISSAO
									dVencto += 2
								EndIf
							EndIf
						Enddo
	
						SE3->E3_VENCTO  := dVencto 
	
						If SE3->(FieldPos("E3_MOEDA")) > 0
							If cPaisLoc=="MEX"
								SE3->E3_MOEDA := StrZero(1,TAMSX3("CTO_MOEDA")[1])
							Else
						   		SE3->E3_MOEDA := StrZero(SE1->E1_MOEDA,TAMSX3("CTO_MOEDA")[1])
							EndIf
						EndIf                    
	
						If ExistBlock("MSE3440")
							ExecBlock("MSE3440",.F.,.F.)
						EndIf

						//Controle de Saldo de Naturezas
						If lAtuSldNat .and. cNatCom <> NIL
							//Atualizo o valor atual para o saldo da natureza
							//Diminuo pois as comissoes serao recalculadas e somadas posteriormente
							If SE3->(FieldPos("E3_MOEDA")) > 0 .AND. Val(SE3->E3_MOEDA) > 1
								nValComis := NoRound( XMOEDA(nValor,1, Val(SE3->E3_MOEDA),SE3->E3_EMISSAO) )
							Else
						   		nValComis := nValor		
							EndIf

							cMoeda := IIf( SE3->(FieldPos("E3_MOEDA")) > 0, SE3->E3_MOEDA, "01" )
							AtuSldNat(	cNatCom	, dVencto	, cMoeda	, "2"				,;
										"P"		, nValComis	, nValor	, cSinal			,;
										Nil		, FunName()	, "SE3"		, SE3->(Recno())	)
						EndIf
						MsUnlock()

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Somente gravamos as comissoes para Supervisor e Gerente para as comissoes|
						//|do modulo SIGALOJA. Para outros modulos, eh necessario uma analise		³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lLj440SbCm .AND. SE3->E3_ORIGEM == "L" .AND. cMvTpComLj == "O" .AND. ;
						( !Empty(SA3->A3_SUPER) .OR. !Empty(SA3->A3_GEREN) )

							For nI := 1 to SE3->( FCount() )
								Aadd(aSE3, {FieldName(nI), &(FieldName(nI))} )	//nome do campo, valor do campo
							Next

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica se existe gerente ou supervisor³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							cSuperv	:= SA3->A3_SUPER
							cGerente:= SA3->A3_GEREN
							cVend	:= SA3->A3_COD
							nPosVend:= aScan( aSE3, {|x| x[1] == "E3_VEND"} )
							nPosBase:= aScan( aSE3, {|x| x[1] == "E3_BASE"} )

							If !Empty(cSuperv)	//verifica se o vendedor possui um supervisor cadastrado
								If nPosVend > 0
									aSE3[nPosVend][2] := cSuperv
								EndIf

								If nPosBase > 0	//valor base = valor emissao + valor baixa
									aSE3[nPosBase][2] := aBases[nCntFor][3] + aBases[nCntFor][4]
								EndIf							

								Lj440SbCom(aSE3)	//(LOJA440.PRW)
							EndIf
	
							If !Empty(cGerente)	//verifica se o vendedor possui um gerente cadastrado
								If nPosVend > 0
									aSE3[nPosVend][2] := cGerente
								EndIf
								
								If nPosBase > 0	//valor base = valor emissao + valor baixa
									aSE3[nPosBase][2] := aBases[nCntFor][3] + aBases[nCntFor][4]
								EndIf							
	
								Lj440SbCom(aSE3)	//(LOJA440.PRW)
							EndIf

							aSE3 := {}	//resetamos o array aSE3
						EndIf	//fim do bloco referente a gravacao de comissao dos gerentes e supervisores

					EndIf
				Endif
			Endif
		EndIf
	Next nCntFor
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de entrada do F440COM,	 serve p/ tratar Comis-³
	//³sao dos titulos RA.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SE1->E1_TIPO $ MVRECANT
		IF ExistBlock("F440COM")
			ExecBlock("F440COM",.f.,.f.)
		Endif
	EndIf	
Endif
dbSelectArea("SE3")
dbSetOrder(1)

dbSelectArea("SA3")
dbSetOrder(1)

RestArea(aArea)
Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FA440ProcB ³ Autor ³ Eduardo Riera         ³ Data ³ 16/12/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Processa o c lculo das comissoes pela Baixa                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA440                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa440ProcB()

Local aBaixas 	:= {}
Local aBxEst	:= {}
Local cChave	:= ""
Local cArqInd   := ""
Local cQuebra   := ""
Local cRegPos	:= ""
Local cAliasSE5 := "SE5"   
Local nPos      := 0
#IFDEF TOP
	Local aStruSE5  := {}
	Local cQuery    := ""
#ELSE
	Local nIndex    := 0
#ENDIF

Local nCntFor   := 0
Local cSeekSE5  := ""
Local lQuery    := .F.
Local lGerComNeg := .F.
Local lE5_FORMAPG := SE5->(FieldPos("E5_FORMAPG")) > 0
Local lFA440 	:= FunName() == "FINA440"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³             Array aBaixas             ³
//³                                       ³
//³ 1 : Motivo da Baixa                   ³
//³ 2 : Sequencia da Baixa                ³
//³ 3 : Registro no SE5                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre com outro alias para eliminar o filtro do Top Connect ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( ChkFile("SE5",.F.,"NEWSE5") )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Selecionando Registros.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE5")
	ProcRegua(RecCount())
	If lFA440
		cChave   := "E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ+DTOS(E5_DATA)+E5_MOTBX"
	Else
		cChave   := "E5_FILIAL+DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_MOTBX+E5_SEQ"
	Endif

	#IFDEF TOP
		cAliasSE5 := "FA440PROCB"
		lQuery    := .T.
		aStruSE5  := SE5->(dbStruct())
		
		cQuery := "SELECT SE5.*,SE5.R_E_C_N_O_ SE5RECNO "
		cQuery += "FROM "+RetSqlName("SE5") + " SE5 "
		cQuery += "WHERE "
		cQuery += Fa440ChecF(2,.T.)+" AND "
		cQuery += "D_E_L_E_T_=' ' "
		cQuery += "AND E5_NUMERO='000149382' "
		cQuery += "AND E5_PREFIXO='FT' "
		cQuery += "ORDER BY "+SqlOrder(cChave)
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE5)
		For nCntFor := 1 To Len(aStruSE5)
			If aStruSE5[nCntFor][2] <> "C"
				TcSetField(cAliasSE5,aStruSE5[nCntFor][1],aStruSE5[nCntFor][2],aStruSE5[nCntFor][3],aStruSE5[nCntFor][4])
		    EndIf
		Next nCntFor
	
	#ELSE
		cArqInd  := CriaTrab(,.F.)
		
		IndRegua("SE5",cArqInd,cChave,,Fa440ChecF(2),OemToAnsi(STR0006))  //"Selecionando Registros..."
		nIndex := RetIndex("SE5")
		dbSelectArea("SE5")
		dbSetIndex(cArqInd+OrdBagExt())
		dbSetOrder(nIndex+1)
		MsSeek(xFilial(),.T.)
	#ENDIF
   	
   	If lE5_FORMAPG  .AND.  Alltrim((cAliasSE5)->E5_MOTBX) == "LOJ" // Verifica se possui o campo E5_FORMAPG criado pelo UPDLOJ58.
   		cQuebra := Alltrim((cAliasSE5)->E5_PREFIXO+(cAliasSE5)->E5_NUMERO+(cAliasSE5)->E5_PARCELA+(cAliasSE5)->E5_TIPO+(cAliasSE5)->E5_CLIFOR+(cAliasSE5)->E5_LOJA+(cAliasSE5)->E5_FORMAPG)
   	ElseIf Alltrim((cAliasSE5)->E5_MOTBX) == "LOJ" // Caso nao possua o UPDLOJ58 aplicado utiliza o campo E5_MOEDA. 
   		cQuebra := Alltrim((cAliasSE5)->E5_PREFIXO+(cAliasSE5)->E5_NUMERO+(cAliasSE5)->E5_PARCELA+(cAliasSE5)->E5_TIPO+(cAliasSE5)->E5_CLIFOR+(cAliasSE5)->E5_LOJA+(cAliasSE5)->E5_MOEDA)
   	Else
		cQuebra := Alltrim((cAliasSE5)->E5_PREFIXO+(cAliasSE5)->E5_NUMERO+(cAliasSE5)->E5_PARCELA+(cAliasSE5)->E5_TIPO+(cAliasSE5)->E5_CLIFOR+(cAliasSE5)->E5_LOJA)
    EndIf 

	While ( !Eof() .And. (xFilial("SE5") == (cAliasSE5)->E5_FILIAL .OR. cFilAnt == (cAliasSE5)->E5_FILORIG) )
		If !f440Loja("SE5",cAliasSE5)		// Baixas de Vendas do SIGALOJA nao deve entrar.
			nPos := (TamSx3("E1_PREFIXO")[1]) + (TamSx3("E1_NUM")[1]) + (TamSx3("E1_PARCELA")[1]) + 1			

			If ( (cAliasSE5)->E5_TIPODOC != "ES" .and. !(cAliasSE5)->E5_TIPO $ MVPAGANT .and. (cAliasSE5)->E5_SITUACA != "C" ) .And.;
				 (  ( (mv_par07 == 1 .And. Substr((cAliasSE5)->E5_DOCUMEN,nPos,3)== MV_CRNEG .And. (cAliasSE5)->E5_MOTBX == "CMP" .And. !(cAliasSE5)->E5_TIPO$MV_CRNEG+"|"+MVRECANT) ) .Or. ; 	// SIM - > COMISSÃO NCC
   			   	  	( (mv_par11 == 1 .And. Substr((cAliasSE5)->E5_DOCUMEN,nPos,3)== MVRECANT .And. (cAliasSE5)->E5_MOTBX == "CMP" .And. !(cAliasSE5)->E5_TIPO$MV_CRNEG+"|"+MVRECANT) ) .Or. ;	// SIM - > COMISSÃO RA 
				    ( !(cAliasSE5)->E5_MOTBX == "CMP" .And. !(cAliasSE5)->E5_TIPO$MV_CRNEG+"|"+MVRECANT)	)																					// NAO E COMPENSASAO 	
				aadd(aBaixas,{ (cAliasSE5)->E5_MOTBX,(cAliasSE5)->E5_SEQ,IIF(lQuery,(cAliasSE5)->SE5RECNO,(cAliasSE5)->(Recno())) })
			Elseif ( (cAliasSE5)->E5_TIPODOC == "ES" .or. (cAliasSE5)->E5_SITUACA == "C" ) .And. !( (cAliasSE5)->E5_TIPO $ MVRECANT+"|"+MV_CRNEG )
				aadd(aBxEst, IIF(lQuery,(cAliasSE5)->SE5RECNO,(cAliasSE5)->(Recno())) )
			EndIf
		EndIf

		dbSelectArea(cAliasSE5) 
		//Marca flag para geracao de comissao negativa.
		If (cAliasSE5)->E5_RECPAG=="P".And.(cAliasSE5)->E5_TIPO $ MV_CRNEG
			lGerComNeg := .T.		
		Endif
		(cAliasSE5)->(dbSkip())
		IncProc(STR0010+":"+(cAliasSE5)->E5_PREFIXO+(cAliasSE5)->E5_NUMERO+(cAliasSE5)->E5_PARCELA) //"Titulo"
		
		If lE5_FORMAPG .AND. Alltrim((cAliasSE5)->E5_MOTBX) == "LOJ" // Verifica se possui o campo E5_FORMAPG criado pelo UPDLOJ58.
			cRegPos := Alltrim((cAliasSE5)->E5_PREFIXO+(cAliasSE5)->E5_NUMERO+(cAliasSE5)->E5_PARCELA+(cAliasSE5)->E5_TIPO+(cAliasSE5)->E5_CLIFOR+(cAliasSE5)->E5_LOJA+(cAliasSE5)->E5_FORMAPG)
		ElseIf Alltrim((cAliasSE5)->E5_MOTBX) == "LOJ" // Caso nao possua o UPDLOJ58 aplicado utiliza o campo E5_MOEDA. 
			cRegPos := Alltrim((cAliasSE5)->E5_PREFIXO+(cAliasSE5)->E5_NUMERO+(cAliasSE5)->E5_PARCELA+(cAliasSE5)->E5_TIPO+(cAliasSE5)->E5_CLIFOR+(cAliasSE5)->E5_LOJA+(cAliasSE5)->E5_MOEDA)	
		Else 
			cRegPos := Alltrim((cAliasSE5)->E5_PREFIXO+(cAliasSE5)->E5_NUMERO+(cAliasSE5)->E5_PARCELA+(cAliasSE5)->E5_TIPO+(cAliasSE5)->E5_CLIFOR+(cAliasSE5)->E5_LOJA)
		EndIf
		
		If (cQuebra != cRegPos) .OR. Eof()

			If ( !Empty(aBaixas) )
				
				fa440CalcB(aBaixas,If(MV_PAR05==1,.T.,.F.),;
					If(MV_PAR06==1,.T.,.F.),;
					"FINA440",If(lGerComNeg,"-","+"),mv_par03,mv_par04,,,mv_par09)
			EndIf
			If ( !Empty(aBxEst) )
				For nCntFor := 1 To Len(aBxEst)
					aBaixas := {}
					dbSelectArea("NEWSE5")
					MsGoto(aBxEst[nCntFor])
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Caso tenha desconto o MsGoto ira posicionar numa sequencia do SE5       ³
					//³que ja foi processada por isso a verificao abaixo                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If cSeekSE5 == NEWSE5->E5_PREFIXO+NEWSE5->E5_NUMERO+NEWSE5->E5_PARCELA+NEWSE5->E5_TIPO+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA+NEWSE5->E5_SEQ
						Loop
					EndIf
					cSeekSE5 := NEWSE5->E5_PREFIXO+NEWSE5->E5_NUMERO+NEWSE5->E5_PARCELA+NEWSE5->E5_TIPO+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA+NEWSE5->E5_SEQ
					dbSelectArea("NEWSE5")
					dbSetOrder(7)
					MsSeek(xFilial("SE5")+cSeekSE5)
					While ( !Eof() .And. xFilial("SE5")	== NEWSE5->E5_FILIAL .And.;
							cSeekSE5			== NEWSE5->E5_PREFIXO+;
							NEWSE5->E5_NUMERO+;
							NEWSE5->E5_PARCELA+;
							NEWSE5->E5_TIPO+;
							NEWSE5->E5_CLIFOR+;
							NEWSE5->E5_LOJA+;
							NEWSE5->E5_SEQ )
						If ( NEWSE5->E5_TIPODOC != "ES" )
							aadd(aBaixas,{ NEWSE5->E5_MOTBX,NEWSE5->E5_SEQ,NEWSE5->(Recno()) })
						EndIf
						dbSelectArea("NEWSE5")
						dbSkip()
					EndDo
					dbSelectArea(cAliasSE5)
					fa440DeleB(aBaixas,If(MV_PAR05==1,.T.,.F.),;
						If(MV_PAR06==1,.T.,.F.);
						,"FINA440",mv_par03,mv_par04)
				Next nCntFor
			EndIf
			dbSelectArea(cAliasSE5)
			lGerComNeg := .F. 	//Recarrega como falso a variavel para verificacao do titulo seguinte.
			aBaixas := {}
			aBxEst  := {}
			cQuebra :=  Alltrim((cAliasSE5)->E5_PREFIXO+(cAliasSE5)->E5_NUMERO+(cAliasSE5)->E5_PARCELA+;
				(cAliasSE5)->E5_TIPO+(cAliasSE5)->E5_CLIFOR+(cAliasSE5)->E5_LOJA)
		EndIf
	EndDo
	If lQuery
		dbSelectArea(cAliasSE5)
		dbCloseArea()
		dbSelectArea("SE5")
	Else
		dbSelectArea("SE5")
		RetIndex("SE5")
		dbClearFilter()
		FErase(cArqInd+OrdBagExt())
	EndIf
	dbSelectArea("NEWSE5")
	dbCloseArea()
	dbSelectArea("SE5")
Else
	Help(" ",1,"FA440FALHA")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento com o erro  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("ERRO","FA440FALHA",Ap5GetHelp("FA440FALHA"))
EndIf

Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fa440CalcB³ Autor ³ Eduardo Riera         ³ Data ³ 27/01/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua c lculo das comissoes pela baixa                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aBaixas   : array c/ dados da baixa                        ³±±
±±³          ³ lJuros    : Considera Juros                                ³±±
±±³          ³ lDescont  : Considera Desconto                             ³±±
±±³          ³ lDevolucao: Considera Devolucao                            ³±±
±±³          ³ cOrigem   : Origem da Comissao                             ³±±
±±³          ³ cSinal    : Sinal da Comissao (+/-)                        ³±±
±±³			 ³ cVendDe   : Vendedor Inicial        					      ³±±
±±³			 ³ cVendAte  : Vendedor Final           				      ³±±
±±³			 ³ lGoto     : Se Deve ser posicionado o SE1 (Opcional)       ³±±
±±³			 ³ nSE1Rec   : Registro do SE1 a ser posicionado    	      ³±±
±±³			 ³ nData     : Define se considera E5_DATA ou E5_DTDISPO      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fa440CalcB(aBaixas,lJuros,lDescont,cOrigem,cSinal,cVendDe,cVendAte,lGoto,nSE1Rec,nData)

Local dVencto
Local nRecFor
Local nOrdFor
Local sFilial
Local aArea 		:= GetArea()
Local aAreaSA3  	:= SA3->(GetArea())
Local aAreaSE1  	:= SE1->(GetArea())
Local aAreaSE5  	:= SE5->(GetArea())
Local aLiquid   	:= {}
Local nX        	:= 0
Local nCntFor  		:= 0
Local nCntFor2  	:= 0
Local nVlrRec  		:= 0
Local nCorrec		:= 0
Local nVlrLiq  		:= 0
Local nVlrProp  	:= 0
Local nValor   		:= 0
Local nAbatim		:= 0
Local nQtdVend  	:= 0
Local nRegSE1   	:= 0
Local nVlrFatura	:= 0
Local cQuebra   	:= ""
Local cVendedor 	:= ""
Local cSeq 	   		:= ""
Local cFunName 		:= Alltrim(FUNNAME())
Local cVend     	:= "1"
Local cFatura   	:= ""
Local dData			:= Ctod("") 					
Local lFatura   	:= .F.
Local lLiquid   	:= .F. 
Local lPago     	:= .F.
Local aBases    	:= {}
Local nDecimal  	:= nTamBascom
Local nBaseComis	:= 0
Local nBaseEmis 	:= 0
Local nBaseBaix 	:= 0
Local nVlrEmis  	:= 0
Local nVlrBaix  	:= 0
Local nDia      	:= 0
Local nMes      	:= 0
Local nAno      	:= 0
Local nPerComis 	:= 0
Local nIrrf     	:= 0
LOCAL lCalcComis	:= .F.
Local nINSS     	:= 0
Local lProcess  	:= .T.
Local cPrimParc 	:= " "

Local nPis 			:= 0
Local nCofins 		:= 0
Local nCsll 		:= 0
Local cKeySE1 		:= ""
Local aFatura 		:= {}
Local nISS			:= 0	
Local nValBase  	:=0
Local nValComis 	:= 0
Local nValSldNat	:= 0
Local lComVdBlq 	:= .T.

Local aLojas 		:= {}
Local nLojas 		:= 0
Local lBlqFor 		:= .F.  
Local nK 			:= 0
Local aSeqCont 		:= {} //Controle de calculo de comissoes (Sequencia no SE5)
Local nPosTit 		:= 0
Local nVlLiquid 	:= 0
Local aAreaSM0		:= {}
Local lRecIRRF  	:= .F.
Local nVlrJuros 	:= 0
Local nPerJuros 	:= 0
Local nVlrDesc	 	:= 0
Local nPerDesc		:= 0
Local aRetF440FALI	:= {}


Local nSavRecSE1	:= 0
Local lLjNCC		:= .F.  //Para o Loja nao se deve gerar SE3 para NCC para duplicar a comissao.
Local lAtuSldNat 	:= lFindAtuSld .AND. AliasInDic("FIV") .AND. AliasInDic("FIW")
//Controla o Pis Cofins e Csll na baixa (1-Retem PCC na Baixa ou 2-Retem PCC na Emissão(default))

Local lNaoGera := .F.
Local cChave	:= ""
Local aRetBases:= {}
Local lRet 		:= .T.
Local lMVPar06	:= .F.
Local lMVPar07	:= .F.
Local aRecSE1	:= {}
Local nY 		:= 0
Local cAliasSE1:= GetNextAlias()
Local nPFim    := 0
Local nApuraPis:= 0
Local nApuraCof:= 0
Local nApuraAmb:= 0
Local nApuraIcm:= 0
Local lImpApur := .F.
Local nProp    := 0
Local cFilSA3	:= ""
Local cFilSE3	:= ""
Local nBaseBAK	:= 0
Local nComiBAK	:= 0
Local lNCC 		:= .F.
Local nValIRBx	:= 0
Local nValPis	:= 0
Local nValCof	:= 0
Local nValCsl	:= 0
Local lPccBxCr	:= .F.
Local nValCruz	:= 0
Local nPosVend	:= 0	//posicao do campo E3_VEND
Local nPosBase	:= 0	//posicao do campo E3_BASE
Local aSE3		:= {}	//array com os dados da comissao
Local nI		:= 0	//contador
Local cSuperv	:= ""	//Supervisor do Vendedor (A3_SUPER)
Local cGerente	:= ""	//Gerente do Vendedor (A3_GEREN)
Local cMvTpComLj:= AllTrim( SuperGetMV("MV_TPCOMLJ",,"B") ) //indica se eh comissao online ou offline (SIGALOJA)

Local aTitFat   := {}
Local lTitFat   := .F.
Local ix :=0
Local aTitLiq   := {}
Local lTitLiq   := .F.
Local nFatRetImp := 0
Local cLastPed := ""
Local cWhere := ""
Local lE5_FORMAPG := SE5->(FieldPos("E5_FORMAPG")) > 0
Local lE3_MOEDA   := SE3->(FieldPos("E3_MOEDA")) > 0 
Local lRestPerg := .F.

Private lFina070:= cFunName =="FINA070" .or. (cFunName=="FINA740" .And. isInCallStack("FINA070")) .or. (isInCallStack("FINA070") .AND. lF070Auto)
Private lFina110:= cFunName=="FINA110"
Private lFina200:= cFunName=="FINA200" .or. (IsIncallStack("FINA200"))
Private lFina440	:= cFunName == "FINA440"
Private lFina330	:= cFunName == "FINA330" .Or. (IsIncallStack("FINA330"))
Private nJuros 	:= 0    
Private nDescont:= 0
Private nMulta	:= 0

DEFAULT lGestao   := Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
DEFAULT cNatCom		:= PADR(&(GetNewPar("MV_NATCOM","")),nTamE2_NATUR)
DEFAULT cComiLiq 	:= SuperGetMv("MV_COMILIQ",,"2")
DEFAULT lComiLiq	:= ComisBx("LIQ") .AND. cComiLiq == "1"
DEFAULT cComisCR	:= SuperGetMv("MV_COMISCR")
DEFAULT lCompensa 	:= cComisCR == "S"
DEFAULT lDevolucao	:= SuperGetMv("MV_COMIDEV")
DEFAULT IsBlind		:= isBlind()

// Caso seja uma chamada externa carrega parametricação da rotina de comissões 
IF !IsInCallStack("FINA440")
	SaveInter()
	Pergunte("AFI440",.F.)
	lRestPerg := .T.
ENDIF

DEFAULT cMV_1DUP	:= SuperGetMv("MV_1DUP")

If (lFina330) // Compensação FINA330
	lMVPar06	:= Iif(!IsBlind .AND. MV_PAR06==1,.T.,.F.) // Considera NCC?
	lMVPar13	:= Iif(!IsBlind .AND. MV_PAR13==1,.T.,.F.) // Considera RA ?
ElseIf (lFina440)
	lMVPar07 := Iif(!IsBlind .AND. MV_PAR07==1,.T.,.F.)	 //Considera NCC?
	lMVPar11 := Iif(!IsBlind .AND. MV_PAR11==1,.T.,.F.)	 //Considera RA ?
EndIf

cOrigem   			:= If( cOrigem == Nil ,"FINA440",cOrigem)
cSinal    			:= If( cSinal  == Nil ,"+",cSinal)
cVendDe				:= If( cVendDe==Nil ,Space(Len(SE3->E3_VEND)),cVendDe)
cVendAte  			:= If( cVendAte==Nil,Repl("z",Len(SE3->E3_VEND)),cVendAte)
lGoto     			:= If( lGoto == Nil ,.F.,lGoto)

DEFAULT nData 		:= 1 //Considera Data? Baixa = 1(Default) / Data Dispo. = 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada para validacoes de usuario para calculo de comissao  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lFa440Vld .And. ! ExecBlock( "FA440VLD", .F., .F., 2 )
	Return .F.
EndIf

// Verifica se é a primeira parcela de uma fatura
If nTamParc == 1
	cPrimParc := "1A "
ElseIf nTamparc == 2
	cPrimParc := cMV_1DUP+Space(2-Len(cMV_1DUP))
	cPrimParc += "#1 #A #  #01"
Else	
	cPrimParc := cMV_1DUP+Space(3-Len(cMV_1DUP))
	cPrimParc += "#1  #A  #   #001"
Endif
If (Len(aBaixas) > 0 )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posicionando Registros.                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE5")
	For nCntFor := 1 To Len(aBaixas)
		//quando titulo sofre baixa com juros/multa/desconto o aBaixas vem com os recnos de todos esses registros da SE5
		//Tratamento para posicionar na SE5 da baixa  
		MsGoto(aBaixas[nCntFor][3])
		If Alltrim(SE5->E5_TIPODOC) $ 'VL|BA' 
			Exit
		EndIf
		
	Next nCntFor	
	dbSelectArea("SE1")
	dbSetOrder(2)
	If ( !lGoto )
		If Type("aTitulos") == "A" 
			If Len(aTitulos[1])>=23
				If cPaisLoc == "BRA"
					nPosTit := aScan(aTitulos,{|x| x[1] == SE5->E5_PREFIXO .and. x[2] == SE5->E5_NUMERO .and. x[3] == SE5->E5_PARCELA .and. x[4] == SE5->E5_TIPO .and. x[10] == SE5->E5_CLIFOR+"-"+SE5->E5_LOJA })
				Else
					nPosTit := aScan(aTitulos,{|x| x[1] == SE5->E5_PREFIXO .and. x[2] == SE5->E5_NUMERO .and. x[3] == SE5->E5_PARCELA .and. x[4] == SE5->E5_TIPO .and. x[11] == SE5->E5_CLIFOR+"-"+SE5->E5_LOJA })				
				Endif
			Else
				nPosTit := aScan(aTitulos,{|x| x[1] == SE5->E5_PREFIXO .and. x[2] == SE5->E5_NUMERO .and. x[3] == SE5->E5_PARCELA .and. x[4] == SE5->E5_TIPO })		
			EndIf 
		Else
			nPosTit := 0
		EndIf	
		
		If nPosTit > 0
			If isInCallStack('FINA330')
				If MV_PAR02 == 2
					If isInCallStack('FA330Desc')
						sFilial := aTitulos[nPosTit][12]
					Else
						sFilial := aTitulos[nPosTit][16]
					EndIf
				Else
					If isInCallStack('FA330Desc')
						sFilial := aTitulos[nPosTit][12]
					Else
						sFilial := aTitulos[nPosTit][13]
					EndIf
				Endif
			Else
				sFilial := aTitulos[nPosTit][Len(aTitulos[nPosTit])]			
			Endif
		Else 
			sFilial := xFilial("SE1",SE5->E5_FILORIG)
		EndIf		
		SE1->(MsSeek(sFilial+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_PREFIXO+;
			SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO))
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se devo mover para o registro fisico. Isto se d  em ³
		//³ virtude de no SQL o registro sair do filtro quando deixar de ³
		//³ atender a alguma das condicoes do mesmo.                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MsGoto(nSE1Rec)
	EndIf

	If lF440Liq
		lProcess := ExecBlock("F440LIQ",.F.,.F.)
	EndIf
	
	If (( SE1->(Found()) .Or. lGoto ) .and. lProcess ) 
		
		//Verifica se o cliente e responsavel pelo recolhimento do IR ou nao.
		If cPaisloc == "BRA"	

			dbSelectArea("SED")       
			SED->(dbSetOrder(1))
			
			dbSelectArea("SA1")       
			SA1->(dbSetOrder(1))
			
			If SED->(FieldPos("ED_RECIRRF")) > 0 .AND. SED->(dbSeek(xFilial("SED") + SED->ED_CODIGO ) ) .And. SED->ED_RECIRRF == "1"
				lRecIRRF := .T.
			ElseIf SA1->(dbSeek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA))) .And. SA1->A1_RECIRRF == "1"
				lRecIRRF := .T.
			Endif
						
		Endif	
		lFatura	 := If(alltrim(SE1->E1_FATURA)=="NOTFAT",.T.,.F.)
	
		If lComiLiq
			//Se calcula comissao pelo metodo antigo (na geracao da liquidacao)
			lLiquid := .F.
		Else
			//Se calcula comissao pelo metodo novo (na baixa do titulo gerado pela liquidacao)
			lLiquid  := !Empty(SE1->E1_NUMLIQ)
		Endif

		If ( !lFatura .And. !lLiquid )
			If (!(SE1->E1_TIPO$MVPAGANT+"/"+MVTAXA+"/"+MVPROVIS+"/"+MVRECANT+"/"+MVABATIM+"/"+MV_CPNEG+"/"+MV_CRNEG) .And. (cFunName=="FINA070") .Or. ;
					(IF(lFina330,lMvPar06,.F.) .Or. If(lFina440 .And. SE1->E1_TIPO $ MV_CRNEG , lMvPar07, .F. )) ) .Or. ; // Comissão NCC - BRASIL
					(IF(lFina330,lMvPar13,.F.) .Or. If(lFina440 .And. SE1->E1_TIPO $ MVRECANT , lMvPar11, .F. )) .Or. ;   // Comissão RA - BRASIL
					(cPaisLoc<>"BRA" .And. SE1->E1_TIPO $ MV_CRNEG)
				aBases   := Fa440Comis(SE1->(Recno()),cOrigem$Iif(!lSF2460I .or.(lSF2460I .And. "MATA460"$SE1->E1_ORIGEM) ,"FINA440#FINA087A#FINA070#FINA110","FINA440#FINA087A"),cOrigem$Iif(!lSF2460I .or.(lSF2460I .And. "MATA460"$SE1->E1_ORIGEM),"FINA440#FINA087A#FINA070#FINA110","FINA440#FINA087A"))
			ElseIf (!(SE1->E1_TIPO$MVPAGANT+"/"+MVTAXA+"/"+MVPROVIS+"/"+MVRECANT+"/"+MVABATIM+"/"+MV_CPNEG+"/"+MV_CRNEG)) .or. ;
					(cPaisLoc<>"BRA" .And. SE1->E1_TIPO $ MV_CRNEG)
				aBases   := Fa440Comis(SE1->(Recno()),cOrigem$Iif(!lSF2460I .or.(lSF2460I .And. "MATA460"$SE1->E1_ORIGEM),"FINA440#FINA087A#FINA070#FINA110","FINA440#FINA087A"),cOrigem$Iif(!lSF2460I .or.(lSF2460I .And. "MATA460"$SE1->E1_ORIGEM),"FINA440#FINA087A#FINA070#FINA110","FINA440#FINA087A"))     
			EndIf
		   
			nQtdVend := Len(aBases)
			cVend := "1"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de entrada para manipular o tratamento do calculo      ³
			//³ das bases da comissao.                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lF440Bases
				aBases := ExecBlock("F440aBas",.F.,.F.,aBases)
			Endif
			nQtdVend := Len(aBases)
			cVend := "1"
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aqui e' verificado os vendedores para os titulo aglutinados  ³
			//³ na fatura a receber.                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			nRegSE1 := SE1->(Recno())
			If Select("__SE1") == 0
				ChkFile("SE1",.F.,"__SE1")
			Endif						
			nVlLiquid := SE1->E1_VLCRUZ
			#IFDEF TOP
				If lFatura
					lFatura := ValidaFat()
				Endif
			#ENDIF

			If lFatura                      
				//Guarda todas as lojas do cliente em um array, pois uma fatura pode conter títulos de todas as lojas.
			   #IFDEF TOP
					cWhere  := ""	
					If SE1->E1_ORIGEM <> "FINA280M" // Se fatura com multiplas filiais
						cWhere  +=  "SE1.E1_FILIAL = '"+ xFilial("SE1",SE1->E1_FILORIG) +"' AND "
					EndIf
					cWhere +=  "SE1.E1_FATPREF = '" + SE1->E1_PREFIXO + "' AND "
					cWhere +=  "SE1.E1_FATURA = '" + SE1->E1_NUM + "' "
					cWhere := "%"+cWhere+"%"
					BeginSql Alias cAliasSE1
						SELECT 
							SE1.R_E_C_N_O_ RECSE1 
						FROM 
							%Table:SE1% SE1
						WHERE 
							%Exp:cWhere% AND
							SE1.%NotDel%							
						ORDER BY
							E1_FILIAL,E1_CLIENTE,E1_LOJA,E1_FATPREF,E1_FATURA
					EndSql

					(cAliasSE1)->(dbGoTop())
					
					While !(cAliasSE1)->(Eof())
						aAdd(aRecSE1,(cAliasSE1)->RECSE1)
						(cAliasSE1)->(dbSkip())
					EndDo
					
					(cAliasSE1)->(dbCloseArea())
					
					If !Empty(aRecSE1)
						__SE1->(dbGoTo(aRecSE1[1]))
						nRegSE1Orig := __SE1->(Recno())
					EndIf
					
					If Empty(__SE1->(E1_VEND1+E1_VEND2+E1_VEND3+E1_VEND4+E1_VEND5))						
						If !Empty(__SE1->E1_NUMLIQ)
							dbSelectArea("SE5")
							dbSetOrder(10)						
							If dbSeek(xFilial("SE5")+__SE1->E1_NUMLIQ)			   			
								dbSelectArea("SE1")
								dbSetOrder(1)
								If dbSeek(xFilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)
									nRegSE1Orig := SE1->(Recno())
								Endif
								SE1->(dbGoto(nRegSE1))
						    Endif    			   			   
						Endif   
				    Endif			   
				   	Fa440LiqFat(@aRecSE1, @aTitLiq)
				   	
					For nY := 1 To Len(aRecSE1) 

						lTitLiq := .F.
						cLastPed := ""
						dbSelectArea("__SE1")
						__SE1->(dbGoTo(aRecSE1[nY]))
						nRegSE1Orig := __SE1->(Recno())
						If Alltrim(__SE1->E1_FATURA) == "NOTFAT"
							Loop
						EndIf
                        
						aFatura := Fa440Comis(__SE1->(Recno()),cOrigem$"FINA440",cOrigem$"FINA440",,,nRegSE1Orig)
						nQtdVend := Len(aFatura)
						cVend := "1"
						aAreaSE5 := SE5->(GetArea())
						If !__SE1->E1_TIPO $ MVABATIM
							nVlrProp   := 1
							nAbatim := SomaAbat(__SE1->E1_PREFIXO,__SE1->E1_NUM,__SE1->E1_PARCELA,"R",__SE1->E1_MOEDA,__SE1->E1_EMISSAO,__SE1->E1_CLIENTE)
							__SE1->(dbGoTo(nRegSE1Orig))
							SE5->(dbSetOrder(7))
							cKeySe1 := __SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
							If SE5->(MsSeek(xFilial("SE5")+cKeySe1))
								While !SE5->(Eof()) .and. SE5->E5_FILIAL == xFilial("SE5") .and. ;
									cKeySe1 == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
									If Len(aTitLiq) > 0 .and. (Ascan(aTitLiq, aRecSE1[nY]) > 0 )
										lTitLiq := .T.
									EndIf
									//Ignora a NCC pois já foi feito o abatimento na geração da fatura.
									If (SE5->E5_MOTBX == "FAT" .and. SE5->E5_SITUACA != "C" .And. SE5->E5_TIPO != MV_CRNEG) .or. lTitliq
										nFatRetImp := 0
										If !(SE5->E5_PRETPIS	$	"1;2")
											nFatRetImp += SE5->E5_VRETPIS
										EndIf	
										If !(SE5->E5_PRETCOF	$	"1;2")
											nFatRetImp += SE5->E5_VRETCOF
										EndIf	
										If !(SE5->E5_PRETCSL	$	"1;2")
											nFatRetImp += SE5->E5_VRETCSL
										EndIf	
										nFatRetImp := SE5->E5_VRETIRF + SE1->(E1_INSS+If(SuperGetMV("MV_DESCISS",,.F.),SE1->(E1_ISS),0))
										nVlrFatura += If( nFatRetImp > 0, SE5->E5_VALOR+nFatRetImp, SE5->E5_VALOR)
										nVlrProp := (((nVlrFatura  + nAbatim)*1000)/__SE1->E1_VLCRUZ)/1000
										If nVlrProp+0.01 >= 1
											nVlrProp := 1
										EndIf
										Exit
									Endif
									SE5->(dbSkip())
								Enddo	
							Else					
								nVlrFatura += __SE1->E1_VLCRUZ
								nVlrProp   := 1
							Endif
							For nCntFor := 1 To Len(aFatura)
								aFatura[nCntFor,2]:= Round(NoRound(aFatura[nCntFor,2]*nVlrProp,nDecimal+1),nDecimal)
								aFatura[nCntFor,3]:= Round(NoRound(aFatura[nCntFor,3]*nVlrProp,nDecimal+1),nDecimal)
								aFatura[nCntFor,4]:= Round(NoRound(aFatura[nCntFor,4]*nVlrProp,nDecimal+1),nDecimal)
								aFatura[nCntFor,5]:= Round(NoRound(aFatura[nCntFor,5]*nVlrProp,nDecimal+1),nDecimal)
								aFatura[nCntFor,6]:= Round(NoRound(aFatura[nCntFor,6]*nVlrProp,nDecimal+1),nDecimal)
							Next nCntFor
						EndIf
						RestArea(aAreaSE5)
						For nCntFor := 1 To Len(aFatura)
							If __SE1->E1_PEDIDO == cLastPed
								cLastPed := __SE1->E1_PEDIDO
								nPerComis := aScan(aBases,{|x| x[1] == aFatura[nCntFor,1]})
								If nPerComis <> 0
									nPerComis := aBases[nPerComis,7]
									If nPerComis <> aFatura[nCntFor,7]
										nPerComis := -1
									EndIf
								Else						
									cLastPed := __SE1->E1_PEDIDO
									nPerComis := aFatura[nCntFor,7]
								EndIf
							Else
								nPerComis := aFatura[nCntFor,7]								
							EndIf
							aadd(abases,{	aFatura[nCntFor,1],;
								aFatura[nCntFor,2],;
								aFatura[nCntFor,3],;
								aFatura[nCntFor,4],;
								aFatura[nCntFor,5],;
								aFatura[nCntFor,6],;
								Max(0,nPerComis)  ,;
								aFatura[nCntFor,8],;	// PIS
								aFatura[nCntFor,9],;	// COFINS
								aFatura[nCntFor,10],;	// CSLL
								Iif(Len(aFatura[nCntFor]) > 10,aFatura[nCntFor,11],0),; // IRRF
								__SE1->E1_VALOR,;		// Valor Original do título filho.
								__SE1->(Recno()) })		// Recno do título filho
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Ponto de entrada para manipular o aBases na Fatura ou/e Liquidação      ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    	            If lF440FAL
		        	        	aRetF440FALI := ExecBlock("F440FAL",.F.,.F.,{abases,lFatura,lLiquid})
		        	        	If(ValType(aRetF440FALI)=="A")
		        	        		abases := aRetF440FALI
		        	        	EndIf
		            	    Endif
						Next nCntFor
						dbSelectArea("__SE1")
						dbSkip()
					Next nY       
			   #ELSE
				   aLojas := LojasSA1(SE1->E1_CLIENTE)
				   	For nLojas := 1 To Len(aLojas)
				   		aRecSE1 := {}
						cFatura := SE1->E1_CLIENTE+aLojas[nLojas]+SE1->E1_PREFIXO+SE1->E1_NUM
				   
			   			dbSelectArea("__SE1")
						dbSetOrder(10)
						MsSeek(xFilial("SE1")+cFatura,.F.)

						nRegSE1Orig := __SE1->(Recno())
	
						If Empty(__SE1->(E1_VEND1+E1_VEND2+E1_VEND3+E1_VEND4+E1_VEND5))						
							If !Empty(__SE1->E1_NUMLIQ)
								dbSelectArea("SE5")
								dbSetOrder(10)						
								If dbSeek(xFilial("SE5")+__SE1->E1_NUMLIQ)			   			
									dbSelectArea("SE1")
									dbSetOrder(1)
									If dbSeek(xFilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)
										nRegSE1Orig := SE1->(Recno())
									Endif
									SE1->(dbGoto(nRegSE1))
							    Endif    			   			   
							Endif   
					    Endif			   
					   						
						While ( !Eof() .And. xFilial("SE1") == __SE1->E1_FILIAL .And.;
								__SE1->(E1_CLIENTE+E1_LOJA+E1_FATPREF+E1_FATURA)==;
								cFatura )
							dbSelectArea("__SE1")
							aFatura := Fa440Comis(__SE1->(Recno()),cOrigem$"FINA440",cOrigem$"FINA440",,,nRegSE1Orig)
							nQtdVend := Len(aFatura)
							cVend := "1"
							If !__SE1->E1_TIPO $ MVABATIM
								nVlrProp   := 1
								nAbatim := SomaAbat(__SE1->E1_PREFIXO,__SE1->E1_NUM,__SE1->E1_PARCELA,"R",__SE1->E1_MOEDA,__SE1->E1_EMISSAO,__SE1->E1_CLIENTE)
								__SE1->(dbGoTo(nRegSE1Orig))
								SE5->(dbSetOrder(7))
								cKeySe1 := __SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
								If SE5->(MsSeek(xFilial("SE5")+cKeySe1))
									While !SE5->(Eof()) .and. SE5->E5_FILIAL == xFilial("SE5") .and. ;
										cKeySe1 == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
										//Ignora a NCC pois já foi feito o abatimento na geração da fatura.
										If SE5->E5_MOTBX == "FAT" .and. SE5->E5_SITUACA != "C" .And. SE5->E5_TIPO != MV_CRNEG
											nFatRetImp := SE1->(E1_PIS+E1_COFINS+E1_CSLL+E1_IRRF+E1_INSS+If(SuperGetMV("MV_DESCISS",,.F.),SE1->(E1_INSS),0))
											nVlrFatura += If( nFatRetImp > 0, SE5->E5_VALOR+nFatRetImp, SE5->E5_VALOR)
											nVlrProp := (((nVlrFatura + nAbatim)*1000)/__SE1->E1_VLCRUZ)/1000
											If nVlrProp+0.01 >= 1
												nVlrProp := 1
											EndIf
											Exit
										Endif
										SE5->(dbSkip())
									Enddo	
								Else					
									nVlrFatura += __SE1->E1_VLCRUZ
									nVlrProp   := 1
								Endif
								For nCntFor := 1 To Len(aFatura)
									aFatura[nCntFor,2]:= Round(NoRound(aFatura[nCntFor,2]*nVlrProp,nDecimal+1),nDecimal)
									aFatura[nCntFor,3]:= Round(NoRound(aFatura[nCntFor,3]*nVlrProp,nDecimal+1),nDecimal)
									aFatura[nCntFor,4]:= Round(NoRound(aFatura[nCntFor,4]*nVlrProp,nDecimal+1),nDecimal)
									aFatura[nCntFor,5]:= Round(NoRound(aFatura[nCntFor,5]*nVlrProp,nDecimal+1),nDecimal)
									aFatura[nCntFor,6]:= Round(NoRound(aFatura[nCntFor,6]*nVlrProp,nDecimal+1),nDecimal)
								Next nCntFor
							EndIf				
							For nCntFor := 1 To Len(aFatura)
								If __SE1->E1_PEDIDO == cLastPed
									cLastPed := __SE1->E1_PEDIDO
									nPerComis := aScan(aBases,{|x| x[1] == aFatura[nCntFor,1]})
									If nPerComis <> 0
										cLastPed := __SE1->E1_NUM
										nPerComis := aBases[nPerComis,7]
										If nPerComis <> aFatura[nCntFor,7]
											nPerComis := -1
										EndIf
									Else						
										cLastPed := __SE1->E1_PEDIDO
										nPerComis := aFatura[nCntFor,7]
									EndIf
								Else
									nPerComis := aFatura[nCntFor,7]									
								EndIf
								aadd(abases,{	aFatura[nCntFor,1],;
									aFatura[nCntFor,2],;
									aFatura[nCntFor,3],;
									aFatura[nCntFor,4],;
									aFatura[nCntFor,5],;
									aFatura[nCntFor,6],;
									Max(0,nPerComis)  ,;
									aFatura[nCntFor,8],;	// PIS
									aFatura[nCntFor,9],;	// COFINS
									aFatura[nCntFor,10],;	// CSLL
									Iif(Len(aFatura[nCntFor]) > 10,aFatura[nCntFor,11],0),; // IRRF
									__SE1->E1_VALOR,;		// Valor Original do título filho.
									__SE1->(Recno()) })		// Recno do título filho
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Ponto de entrada para manipular o aBases na Fatura ou/e Liquidação      ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			    	            If lF440FAL
			        	        	aRetF440FALI := ExecBlock("F440FAL",.F.,.F.,{abases,lFatura,lLiquid})
			        	        	If(ValType(aRetF440FALI)=="A")
			        	        		abases := aRetF440FALI
			        	        	EndIf
			            	    Endif
							Next nCntFor
							dbSelectArea("__SE1")
							dbSkip()
						EndDo
					Next
				#ENDIF	
			ElseIf ! SE1->E1_TIPO $ MV_CRNEG // Titulo gerado pela liquidacao porem eh uma nota de credito (nao calcula comissao)
				Fa440LiqSe1(SE1->E1_NUMLIQ,@aLiquid,,@aSeqCont,,,@aTitFat)
				nK += 1
				nVlLiquid := 0
				lTitFat := .f.
				dbSelectArea("__SE1")
				For nX := 1 To Len(aLiquid)					
					__SE1->(MsGoto(aLiquid[nX]))					            	
					aFatura := Fa440Comis(__SE1->(Recno()),cOrigem$"FINA440",cOrigem$"FINA440")
					nQtdVend := Len(aFatura)
					cVend := "1"
					//FNC 00000029183/2009					
					nVlrJuros := 0
					nPerJuros := 0
					nVlrDesc  := 0
					nPerDesc  := 0
					//
					nVlrProp   := 1					
					nVlLiquid += __SE1->E1_VLCRUZ
					nValCruz	 += __SE1->E1_VLCRUZ
					If !__SE1->E1_TIPO $ MVABATIM
						SE5->(dbSetOrder(7))
						cKeySe1 := __SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
						// Qdo a liquidação originou de fatura
						If Len(atitFat) > 0
							For iX := 1 to len(aTitFat)
								If aTitFat[iX][1] == __SE1->(Recno()) 
									lTitFat := .T.
									exit
								EndIf
							Next
						EndIf
						// Proporcionaliza baixas por liquidacao
						If SE5->(MsSeek(xFilial("SE5")+cKeySe1))
							While !SE5->(Eof()) .and. SE5->E5_FILIAL == xFilial("SE5") .and. ;
								cKeySe1 == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
								If (SE5->E5_MOTBX == "LIQ" .and. SE5->E5_SITUACA != "C" .And. SE5->E5_TIPODOC == "BA";
									.And. SE5->E5_SEQ == aSeqCont[nK]) .or. lTitFat
									nVlrFatura 	+= SE5->E5_VALOR
									//FNC 00000029183/2009
									//Não acumular mais a variavel, o juros vai ser passado para a array aBase
									If lJuros
										nVlrJuros	:= f440JurLiq(__SE1->(recno()))
									EndIf
									If nVlrJuros > 0
										nPerJuros 	:= ((nVlrJuros*1000)/__SE1->E1_VLCRUZ)/1000
									Endif
									nVlrDesc	:= f440DesLiq(__SE1->(recno()))																		
									If lDescont .And. nVlrDesc > 0
										nPerDesc 	:= ((nVlrDesc*1000)/__SE1->E1_VLCRUZ)/1000
									Endif
									nVlrProp 	:= ( ;
													 ( ;
													   ( SE5->E5_VALOR - ;
														  IF(lJuros .AND. nVlrJuros > 0, SE5->E5_VLJUROS,0) + ;
														  IF( nVlrDesc > 0, SE5->E5_VLDESCO,0) ;
													   ) * 1000 ;
													 ) / __SE1->E1_VLCRUZ ;
												   ) / 1000

									nK++
									If nVlrProp+0.01 >= 1
										nVlrProp := 1
									EndIf
									Exit
								Endif
								SE5->(dbSkip())
							Enddo	
						Else					
							nVlrFatura += __SE1->E1_VLCRUZ
							nVlrProp   := 1
						Endif
					EndIf
					
					For nCntFor := 1 To Len(aFatura)
						nPerComis := aScan(aBases,{|x| x[1] == aFatura[nCntFor,1]})
						If nPerComis <> 0
							nPerComis := aBases[nPerComis,7]
							If nPerComis <> aFatura[nCntFor,7]
								if aFatura[nCntFor,7] > 0
									nPerComis := aFatura[nCntFor,7]
								Endif
							EndIf
						Else						
							nPerComis := aFatura[nCntFor,7]
						EndIf			                                                                                 
						//FNC 00000029183/2009
						//Incluido o calculo do perc. do juros (nPerJuros) e desconto (nPerDesc) sobre os elementos da array para o ajuste do calculo
						aadd(aBases,{aFatura[nCntFor,1],;
							(aFatura[nCntFor,2]*nVlrProp)+(aFatura[nCntFor,2]*nPerJuros)-(aFatura[nCntFor,2]*nPerDesc),;
							aFatura[nCntFor,3]*nVlrProp+(aFatura[nCntFor,3]*nPerJuros)-(aFatura[nCntFor,2]*nPerDesc),;
							aFatura[nCntFor,4]*nVlrProp+(aFatura[nCntFor,4]*nPerJuros)-(aFatura[nCntFor,2]*nPerDesc),;	
							aFatura[nCntFor,5]*nVlrProp+(aFatura[nCntFor,5]*nPerJuros)-(aFatura[nCntFor,2]*nPerDesc),;
							aFatura[nCntFor,6]*nVlrProp+(aFatura[nCntFor,6]*nPerJuros)-(aFatura[nCntFor,2]*nPerDesc),;
							Max(0,nPerComis),;
							aFatura[nCntFor,8],;	// PIS
							aFatura[nCntFor,9],;	// COFINS
							aFatura[nCntFor,10],;	// CSLL
							Iif(Len(aFatura[nCntFor]) > 10,aFatura[nCntFor,11],0),;	// IRRF
							__SE1->E1_VALOR,;		// Valor Original do título filho.
							__SE1->(Recno()) })		// Recno do título filho
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Ponto de entrada para manipular o aBases na Fatura ou/e Liquidação      ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lF440FAL
	        	        	aRetF440FALI := ExecBlock("F440FAL",.F.,.F.,{aBases,lFatura,lLiquid})
	        	        	If(ValType(aRetF440FALI)=="A")
	        	        		aBases := aRetF440FALI
	        	        	EndIf
						Endif						
					Next nCntFor
				Next nX
			EndIf

			If lF440CBase
				aRetBases := ExecBlock("F440CBASE",.F.,.F.,{aBases})
				If !Empty(aRetBases) .And. ValType(aRetBases) == "A"
					aBases := aClone(aRetBases)				
				EndIf
			EndIf			

			dbSelectArea("SE1")
			dbSetOrder(1)
			MsGoto(nRegSE1)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aqui e' feito o ajuste das bases em relacao ao titulo.       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			dbSelectArea("SE1")
			If lFatura  
				nVlrProp := Min(((SE1->E1_VLCRUZ*10000)/nVlrFatura)/10000,1)
			Else
				nVlrProp := Min(((SE1->E1_VLCRUZ*10000)/nVlLiquid)/10000,1) 			
			Endif	                                                         			
			aBases := aSort(aBases,,,{|x,y| x[1] < y[1] })
			cVendedor := ""
			For nCntFor := 1 To Len(aBases)
				nBaseComis:= aBases[nCntFor,2]*nVlrProp
				nBaseEmis := aBases[nCntFor,3]*nVlrProp
				nBaseBaix := (aBases[nCntFor,4]+IIf(Len(aBases[nCntFor]) > 10, aBases[nCntFor,11], 0))*nVlrProp
				nVlrEmis  := aBases[nCntFor,5]*nVlrProp
				nVlrBaix  := aBases[nCntFor,6]*nVlrProp
				If ( cVendedor <> aBases[nCntFor][1] )
					//--> Base da Comissao
					nBaseDif := NoRound(aBases[nCntFor,2]*(1-nVlrProp),nDecimal+1)
					nBaseDif := aBases[nCntFor,2]-nBaseDif-nBaseComis
					aBases[nCntFor,2] := nBaseComis+nBaseDif

					//--> Base da Comissao na Emissao
					nBaseDif := NoRound(aBases[nCntFor,3]*(1-nVlrProp),nDecimal+1)
					nBaseDif := aBases[nCntFor,3]-nBaseDif-nBaseEmis
					aBases[nCntFor,3] := nBaseEmis+nBaseDif

					//--> Base da Comissao na Baixa
					nBaseDif := NoRound((aBases[nCntFor,4]+IIf(Len(aBases[nCntFor]) > 10, aBases[nCntFor,11], 0)) *(1-nVlrProp),nDecimal+1)
					nBaseDif := (aBases[nCntFor,4]+IIf(Len(aBases[nCntFor]) > 10, aBases[nCntFor,11], 0))-nBaseDif-nBaseBaix
					aBases[nCntFor,4] := nBaseBaix+nBaseDif

					//--> Valor da Comissao na Emissao
					nBaseDif := NoRound(aBases[nCntFor,5]*(1-nVlrProp),nDecimal+1)
					nBaseDif := aBases[nCntFor,5]-nBaseDif-nVlrEmis
					aBases[nCntFor,5] := nVlrEmis+nBaseDif

					//--> Valor da Comissao na Baixa
					nBaseDif := NoRound(aBases[nCntFor,6]*(1-nVlrProp),nDecimal+1)
					nBaseDif := aBases[nCntFor,6]-nBaseDif-nVlrBaix
					aBases[nCntFor,6] := nVlrBaix+nBaseDif
				Else
					aBases[nCntFor,2] := nBaseComis
					aBases[nCntFor,3] := nBaseEmis
					aBases[nCntFor,4] := nBaseBaix
					aBases[nCntFor,5] := nVlrEmis
					aBases[nCntFor,6] := nVlrBaix
				EndIf
				cVendedor := aBases[nCntFor][1]
			Next nCntFor
		EndIf
		nDescont  := 0
		nVlrRec   := 0
		nJuros    := 0
		nCorrec   := 0
		nMulta    := 0
		cQuebra   := ""
		cSeq		 := ""
		aadd(aBaixas,{"zzz","zz",0}) // Controle de Saida
		// CASOS DE SE1 COMPARTILHADO E SA3 ESCLUSIVA
		If lGestao
			cFilSA3 := Iif(Empty(FwFilial("SA3")) , xFilial("SA3") , FwxFilial("SE1",SE1->E1_FILORIG) )
			cFilSE3 := Iif(Empty(FwFilial("SE3")) , xFilial("SE3") , FwxFilial("SE3",SE1->E1_FILORIG) )
		Else
			cFilSA3 := Iif(Empty(xFilial("SA3")) , xFilial("SA3") , SE1->E1_FILORIG )
			cFilSE3 := Iif(Empty(xFilial("SE3")) , xFilial("SE3") , SE1->E1_FILORIG )
		EndIf
		lPccBxCr	:= lFindPccBx .and. FPccBxCr()
		For nCntFor := 1 To Len(aBaixas)
			
			If lE5_FORMAPG //Verifica se possui aplicado o UPDLOJ58 senao utiliza o campo E5_MOEDA. 
				If Alltrim(aBaixas[nCntFor][1]) == "LOJ" .AND. IsMoney(SE5->E5_FORMAPG) // Trata recebimento em dinheiro realizado pelo SIGALOJA. 
					Loop
				EndIf
			ElseIf Alltrim(aBaixas[nCntFor][1]) == "LOJ" .AND. IsMoney(SE5->E5_MOEDA) // Trata recebimento em dinheiro realizado pelo SIGALOJA. 
				Loop
			EndIf
			
			If ( If(!lDevolucao,aBaixas[nCntFor,1]!="DEV",.T.) .And. ;
					If(!lCompensa ,aBaixas[nCntFor,1]!="CMP",.T.))
				dbSelectArea("SE5")
				If ( aBaixas[nCntFor,3] != 0 )
					MsGoto(aBaixas[nCntFor,3])
				Else
					cQuebra := ""	
				EndIf
				lCalcComis := ComisBx(SE5->E5_MOTBX)
				If ( cQuebra != aBaixas[nCntFor,1]+aBaixas[nCntFor,2] )
					If ( !Empty(cQuebra) .Or. aBaixas[nCntFor,3] == 0 )
						For nCntFor2 := 1 To Len(aBases)
							If ( aBases[nCntFor2,1] >= cVendDe  .And.;
									aBases[nCntFor2,1] <= cVendAte )

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Calcula o Valor Recebido sobre o Principal       ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							    IF lF440Bases .and. lF440JurDes
							    	lRet:= MsgYesNo("STR0013")		    			
							    Else
							    	lRet := .T.
								EndIf
								
								If lRet
									nVlrLiq :=  nVlrRec - If(lJuros,0,nJuros+nMulta)
									nVlrLiq +=  If(lDescont,0,nDescont)
								Else
									nVlrLiq :=  nVlrRec
								EndIF

								SA3->(MsSeek(cFilSA3+aBases[nCntFor2,1]))
								//backup antes da alteração do aBases para proporcionalização
								nBaseBAK	:= aBases[nCntFor2,4]
								nComiBAK	:= aBases[nCntFor2,6]

								If !lFina440
									F070Fator(nVlrRec,nVlrLiq,aBases,aBases[nCntFor2,2],nCntFor2,lJuros,lDescont, !Empty(SE1->E1_NUMLIQ) .Or. lFatura)
								Else
									F440Fator(nVlrRec,nVlrLiq,aBases,nCntFor2,nValIRBx,nValPis,nValCof,nValCsl,lJuros,lDescont,nDescont,nJuros+nMulta,nCntFor==Len(aBaixas),  !Empty(SE1->E1_NUMLIQ) .Or. lFatura)
								Endif

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Calcula o Valor Proporcional - Base da Comissao  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 						
							   nVlrProp := aBases[nCntFor2,4]
							   nValor   := aBases[nCntFor2,6]  
                                              	
								aBases[nCntFor2] := Fa440LjTrc(@nVlrProp,@nValor,aBases[nCntFor2],"B")
								If AllTrim(Upper(SE1->E1_ORIGEM))$"LOJA010/LOJA701" .AND. AllTrim(SE1->E1_TIPO)  == "CR"
								 	lLjNCC := .T. 
								EndIf 	
								If ( aBases[nCntFor2,6] != 0 .And. nVlrProp > 0 ) .OR. ( aBases[nCntFor2,6] != 0 .AND. !Empty(SE1->E1_NUMLIQ) )
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³ Grava resultado no arquivo de pgto. de comissäes.    ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									SA3->(MsSeek(cFilSA3+aBases[nCntFor2,1]))
                                    
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Verifica se o Fornecedor relacionado ao vendedor estah ou nao bloqueado ³ 
									//³e estando (SA2->A2_MSBLQL == "1") nao eh gerada a comissao              ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
									
									If !Empty(SA3->A3_FORNECE)
									
										lBlqFor := .F.			
					   					DbSelectArea("SA2")	
								        nRecFor := Recno()	
			    	    				nOrdFor := IndexOrd()
								        dbSetOrder(1)
								        If DbSeek(xFilial("SA2")+SA3->A3_FORNECE+SA3->A3_LOJA)
			        					   If Alltrim(SA2->A2_MSBLQL) == "1" .and. mv_par10 == 2		   
							    	          lBlqFor := .T.	        	   		   
			        					   Endif								        
								        Endif
			    	    				DbSelectArea("SA2")
								        dbSetOrder(nOrdFor)
			        					dbGoto(nRecFor)	 																
									
									Endif

									//ponto de entrada para validar se calcula comissao para vendedores bloqueados
									If lF440CVB	
										lComVdBlq := ExecBlock("F440CVB",.F.,.F.)
									Endif

									If lComVdBlq

										dbSelectArea("SE3")
										dbSetOrder(3)
										MsSeek(cFilSE3+aBases[nCntFor2,1]+;
											SE1->E1_CLIENTE+SE1->E1_LOJA+;
											SE1->E1_PREFIXO+;
											SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+cSeq)
											
										// Validação para que seja verificada existencia do título negativo na base.
										// Caso já exista e já esteja pago, não deverá gerar mais nenhum registro negativo na SE3
										If cSinal == "-"
											cChave := cFilSE3+aBases[nCntFor2,1]+ SE1->E1_CLIENTE+SE1->E1_LOJA+ SE1->E1_PREFIXO+ SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+(cSeq)
											
											While SE3->(!EOF()) .AND. cFilSE3+SE3->(E3_VEND+E3_CODCLI+E3_LOJA+E3_PREFIXO+E3_NUM+E3_PARCELA+E3_TIPO+E3_SEQ)==cChave
												If "-" $ STR(E3_BASE)
													If !Empty(E3_DATA)
														lPago 	:= .T.
														lNaoGera := .T.
													Endif
												Endif
												SE3->(dbSkip())
											Enddo
										Endif

										If !lNaoGera
											If ( Found() )
												If ( !Empty(SE3->E3_DATA) )
													lPago := .T.
													If (! cOrigem $ "FINA440" )  .Or. (cOrigem $ "FINA440" .And. cSinal == "-")
														RecLock("SE3",.T.)
														nValBase 		:= 0
														nValComis 		:= 0
													EndIf
												Else
													lPago := .F.
													RecLock("SE3",.F.)
												EndIf
											Else
												lPago := .F.
												If !lBlqFor
												   RecLock("SE3",.T.)
												Endif
												nValBase 		:= 0
												nValComis 		:= 0	
											EndIf
										Endif
										
										If (((!lPago .Or. !(cOrigem $ "FINA440")) .Or. (lPago .And. (cSinal == '-' .and. !lNaoGera)) .And. nValor!=0) .And. !lBlqFor) .AND. !lLjNCC											

											nValBase  += (nVlrProp * Iif( cSinal == "-" .Or.( SE1->E1_TIPO $ MV_CRNEG  .And. cPaisLoc <>"BRA"),-1,1))
											nValComis += (nValor* Iif( cSinal == "-" .Or.( SE1->E1_TIPO $ MV_CRNEG  .And. cPaisLoc <>"BRA"),-1,1))   
											
											If lE3_MOEDA .And. !lNaoGera
												SE3->E3_MOEDA := StrZero(SE1->E1_MOEDA,TAMSX3("CTO_MOEDA")[1])
											EndIf
											
       
											If cPaisLoc=="MEX" 
												nValBase:= xMoeda(nValBase,SE1->E1_MOEDA,iif(lE3_MOEDA,VAL(SE3->E3_MOEDA),SE1->E1_MOEDA),dDataBase)
												nValComis:= xMoeda(nValComis,SE1->E1_MOEDA,iif(lE3_MOEDA,VAL(SE3->E3_MOEDA),SE1->E1_MOEDA),dDataBase)
											EndIf
											If !lNaoGera
											SE3->E3_BASE    := Round(nValBase,TamSX3("E3_BASE")[2] )
											SE3->E3_COMIS   := Round(nValComis,TamSX3("E3_COMIS")[2] )
											SE3->E3_PORC    := Abs((nValComis/nValBase)*100)
											SE3->E3_FILIAL  := cFilSE3
											SE3->E3_VEND    := aBases[nCntFor2,1]
											SE3->E3_SERIE   := SE1->E1_SERIE
											SE3->E3_NUM     := SE1->E1_NUM    
											SE3->E3_CODCLI  := SE1->E1_CLIENTE
											SE3->E3_LOJA    := SE1->E1_LOJA
											SE3->E3_EMISSAO := (Iif( cSinal == "-", dDatabase, dData))
											SE3->E3_PREFIXO := SE1->E1_PREFIXO
											SE3->E3_PARCELA := SE1->E1_PARCELA
											SE3->E3_TIPO    := SE1->E1_TIPO
											SE3->E3_BAIEMI  := "B"
											SE3->E3_ORIGEM  := Fa440Origem(cOrigem)
											SE3->E3_PEDIDO  := SE1->E1_PEDIDO
											SE3->E3_SEQ     := cSeq
											
											If ( aBases[nCntFor2,7] != 0 ) .And. Empty(SE3->E3_PORC)
												SE3->E3_PORC    := aBases[nCntFor2,7]
											EndIf
											If Empty( SA3->A3_DIA )
												dVencto := dData
											Else
												dVencto := Ctod( strzero(SA3->A3_DIA,2)+"/"+;
													strzero(Month(dData),2)+"/"+;
													strzero( Year(dData),4),"ddmmyy")
												nDia := SA3->A3_DIA
												While empty( dVencto)
													nDia -= 1
													dVencto := CtoD(strzero(nDia,2)+"/"+;
														strzero(month(dData),2)+"/"+;
														strzero( year(dData),4),"ddmmyy")
												endDo
											EndIf
	
											if SA3->A3_DDD == "F" .or. dVencto < dData		//Fora o mes
												nDia := SA3->A3_DIA
												nMes := month(dVencto) + 1
												nAno := year (dVencto)
												If nMes == 13
													nMes := 01
													nAno := nAno + 1
												Endif
												nDia	  := strzero(nDia,2)
												nMes	  := strzero(nMes,2)
												nAno	  := substr(lTrim(str(nAno)),3,2)
												dVencto := CtoD(nDia+"/"+nMes+"/"+nAno,"ddmmyy")
											Else
												nDia	  := strzero(day(dVencto),2)
												nMes	  := strzero(month(dVencto),2)
												nAno	  := substr(lTrim(str(Year(dVencto))),3,2)
											Endif
	
											While empty( dVencto)
												nDia := if(Valtype(nDia)=="C",Val(nDia),nDia)
												nDia -= 1
												dVencto := CtoD(strzero(nDia,2)+"/"+nMes+"/"+nAno,"ddmmyy")
												if !empty( dVencto )
													if dVencto < dData
														dVencto += 2
													EndIf
												EndIf
											EndDo
	
											SE3->E3_VENCTO  := dVencto

											If ExistBlock("MSE3440")
												ExecBlock("MSE3440",.F.,.F.,{nDescont,nJuros,cOrigem})
											EndIf

											//Controle de Saldo de Naturezas
											If lAtuSldNat .and. cNatCom <> NIL
												// Tratamento de outras moedas no controle de saldos do fluxo de caixa por natureza
												If lE3_MOEDA .AND. VAL(SE3->E3_MOEDA) > 1
													nValSldNat := NOROUND(XMOEDA(SE3->E3_COMIS,1,VAL(SE3->E3_MOEDA),SE3->E3_EMISSAO))
												Else
											   		nValSldNat := SE3->E3_COMIS		
												EndIf
											
												//Atualizo o valor atual para o saldo da natureza
												AtuSldNat(cNatCom, dVencto, Iif(lE3_MOEDA, SE3->E3_MOEDA, "01"), "2", "P", nValSldNat, SE3->E3_COMIS,"+",,FunName(),"SE3",SE3->(Recno()))
											EndIf
					
											MsUnlock()										
                                      EndIf
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³Somente gravamos as comissoes para Supervisor e Gerente para as comissoes|
											//|do modulo SIGALOJA. Para outros modulos, eh necessario uma analise		³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											If lLj440SbCm .AND. SE3->E3_ORIGEM == "L" .AND. cMvTpComLj == "O" .AND. ;
											( !Empty(SA3->A3_SUPER) .OR. !Empty(SA3->A3_GEREN) )

												For nI := 1 to SE3->( FCount() )
													Aadd(aSE3, {FieldName(nI), &(FieldName(nI))} )	//nome do campo, valor do campo
												Next

												cSuperv	:= SA3->A3_SUPER
												cGerente:= SA3->A3_GEREN
												cVend	:= SA3->A3_COD
												nPosVend:= aScan( aSE3, {|x| x[1] == "E3_VEND"} )
												nPosBase:= aScan( aSE3, {|x| x[1] == "E3_BASE"} )
	
												If !Empty(cSuperv)
													If nPosVend > 0
														aSE3[nPosVend][2] := cSuperv
													EndIf
													
													If nPosBase > 0
														//valor base = valor emissao + valor baixa
														aSE3[nPosBase][2] := aBases[nCntFor2][3] + aBases[nCntFor2][4]
													EndIf

													Lj440SbCom(aSE3)	//(LOJA440.PRW)
												EndIf
						
												If !Empty(cGerente)
													If nPosVend > 0
														aSE3[nPosVend][2] := cGerente
													EndIf

													If nPosBase > 0
														//valor base = valor emissao + valor baixa
														aSE3[nPosBase][2] := aBases[nCntFor2][3] + aBases[nCntFor2][4]
													EndIf

													Lj440SbCom(aSE3)	//(LOJA440.PRW)
												EndIf

												aSE3 := {}	//resetamos o array aSE3
											EndIf	//fim do bloco referente a gravacao de comissao dos gerentes e supervisores

										EndIf
									EndIf
								Endif
							EndIf
							aBases[nCntFor2,4] := nBaseBAK
							aBases[nCntFor2,6] := nComiBAK
						Next nCntFor2
						nDescont  := 0
						nVlrRec   := 0
						nJuros    := 0
						nCorrec   := 0
						nMulta    := 0
						If aBaixas[nCntFor,3] == 0
							Exit
						EndIf
					EndIf
					cQuebra   := aBaixas[nCntFor,1]+aBaixas[nCntFor,2]
					cSeq		 := SE5->E5_SEQ
					dData     := If(nData == 1,SE5->E5_DATA,SE5->E5_DTDISPO)
				EndIf
				If ( SE5->E5_TIPODOC $ "VL#BA#V2#CP#LJ" )  .and. lCalcComis
					nVlrRec  += SE5->E5_VALOR
					//Valores Acessórios Compensação
					If SE5->E5_MOTBX == "CMP"
						nDescont += SE5->E5_VLDESCO
						nJuros += SE5->E5_VLJUROS
						nMulta += SE5->E5_VLMULTA
					EndIf
					//Cancelamento de baixa de C.Receber
					If Procname(2) == "FA070CAN"
						nMulta += SE5->E5_VLMULTA
						nCorrec += SE5->E5_VLCORRE
						nDescont += SE5->E5_VLDESCO					
						nJuros += SE5->E5_VLJUROS
					Endif
				Endif
				If ( SE5->E5_TIPODOC$"CM#C2#CX" ) .and. lCalcComis
					nCorrec += SE5->E5_VALOR
				Endif
				If ( SE5->E5_TIPODOC$"DC#D2" ) .and. lCalcComis
					nDescont += SE5->E5_VALOR
				Endif
				If ( SE5->E5_TIPODOC$"MT#M2" ) .and. lCalcComis
					nMulta  += SE5->E5_VALOR
				Endif
				If ( SE5->E5_TIPODOC$"JR#J2" ) .and. lCalcComis
					nJuros  += SE5->E5_VALOR
				EndIf
				nValIRBx := SE5->E5_VRETIRF
				If lPccBxCr
					If !(SE5->E5_PRETPIS	$	"1;2")
						nValPis	:= SE5->E5_VRETPIS
					Else
						nValPis	:= 0
					EndIf
					If !(SE5->E5_PRETCOF	$	"1;2")
						nValCof 	:= SE5->E5_VRETCOF
					Else
						nValCof 	:= 0
					EndIf
					If !(SE5->E5_PRETCSL	$	"1;2")
						nValCsl 	:= SE5->E5_VRETCSL
					Else
						nValCsl 	:= 0
					EndIf
				Endif

			EndIf
		Next nCntFor
	EndIf
EndIf

// Caso seja uma chamada externa restaura parametricação da rotina chamadora 
IF lRestPerg
	RestInter()
ENDIF

nValAbatCom		:= 0
cChaveComis		:= ""
nSldTitComis	:= 0
RestArea(aAreaSE5)
RestArea(aAreaSE1)
RestArea(aAreaSA3)
RestArea(aArea)

Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fa440DeleE³ Autor ³ Eduardo Riera         ³ Data ³ 28/01/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua descalculo da comissao na emissao do SE1 corrente   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cOrigem   : Origem da Comissao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generio                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fa440DeleE(cOrigem,lParcela)

Local aArea     := GetArea()
Local aAreaSA3  := SA3->(GetArea())
Local aAreaSE1  := SE1->(GetArea())
Local aVendedor := {}
Local cVendedor := ""
Local cVend     := ""
Local nQtdVend  := Fa440CntVen()
Local nCntFor   := 0
Local cParcela  := Space(nTamParc)
Local cSinal    := If(SE1->E1_TIPO $ MV_CRNEG,"+","-")
Local aAux      := {}

DEFAULT lDevolucao:= SuperGetMv("MV_COMIDEV")
DEFAULT cParComEm 	:= GetNewPar("MV_PARCOMI","N") // Parcelamento da comissao na emissao
lParcela := IIF(lParcela == NIL, .F., .T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona vendedores que deverÆo ter comissÆo descalculada.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cVend := "1"
If ( SE1->E1_TIPO $ MV_CRNEG .And. lDevolucao )
	aAux := Fa440Comis(SE1->(RecNo()),.F.,.F.) // Verifica os vendedores apenas
	For nCntFor := 1 To Len(aAux)
		aadd(aVendedor,aAux[nCntFor,1])
	Next nCntFor
Else
	For nCntFor := 1 to nQtdVend
		cVendedor := SE1->(FieldGet(FieldPos("E1_VEND"+cVend)))
		If ( !Empty(cVendedor) )
			AAdd( aVendedor, cVendedor )
		EndIf
		cVend := Soma1(cVend,1)
	Next nCntFor
EndIf
//Verifica se foi parcelada a comissao na emissao
If cParComEm == "S" .or. lParcela
	cParcela := SE1->E1_PARCELA
Endif

For nCntFor := 1 To Len(aVendedor)
	lFound := .F.
	dbSelectArea("SE3")
	dbSetOrder(3)
	MsSeek(xFilial("SE3")+aVendedor[nCntfor]+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+cParcela+SE1->E1_TIPO)
	If Found() .And. ( cParComEm == "S" .Or. lParcela )
		If ( Empty(SE3->E3_DATA) ) // Nao esta pago
			RecLock("SE3")
			dbDelete()
			MsUnlock()
		Else
			Fa440CalcE(cOrigem,aVendedor[nCntFor],aVendedor[nCntFor],cSinal)
		EndIf
	Else
		Fa440CalcE(cOrigem,aVendedor[nCntFor],aVendedor[nCntFor],cSinal)
		dbSelectArea("SE3")
		dbSetOrder(3)
		If MsSeek(xFilial("SE3")+aVendedor[nCntfor]+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+cParcela+SE1->E1_TIPO)
			If SE3->E3_COMIS == 0 .And. Empty(SE3->E3_DATA)
				RecLock("SE3")
				dbDelete()
				MsUnlock()		
			EndIf		
		EndIf
	EndIf

	If (Existblock("F440DEL"))
		ExecBlock("F440DEL",.F.,.F., aVendedor[nCntFor])
	EndIf
Next nCntFor
RestArea(aAreaSE1)
RestArea(aAreaSA3)
RestArea(aArea)

Return(.F.)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fa440DeleB³ Autor ³ Eduardo Riera         ³ Data ³ 27/01/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua descalculo da comissao na baixa                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aBaixas   : array c/ dados da baixa : [MOTBX,SEQ,REGISTRO] ³±±
±±³          ³ lJuros    : Considera Juros                                ³±±
±±³          ³ lDescont  : Considera Desconto                             ³±±
±±³          ³ cOrigem   : Origem da Comissao                             ³±±
±±³          ³ cVendDe   : Vendedor de ?                                  ³±±
±±³          ³ cVendAte  : Vendedor ate?                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generio                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fa440DeleB(aBaixas,lJuros,lDescont,cOrigem,cVendDe,cVendAte)

Local aArea 		:= GetArea()
Local aAreaSA3 	:= SA3->(GetArea())
Local aAreaSE1 	:= SE1->(GetArea())
Local aAreaSE5 	:= SE5->(GetArea())
Local aVendedor	:= {}
Local aLiquid  	:= {}
Local aSeqCont	:= {} //Controle de calculo de comissoes (Sequencia no SE5)
Local aLojas	:= {}
Local aRecSE1		:= {}
Local aTitLiq		:= {}
Local nCntFor  	:= 0
Local nCntFor2 	:= 0
Local nX		:= 0
Local nY			:= 0
Local nLoja		:= 0
Local nRecSE1	:= 0
Local nValComis	:= 0
Local nQtdVend 	:= Fa440CntVen()
Local cQuebra  	:= ""
Local cSeq     	:= ""
Local cTitulo  	:= ""
Local cFatura  	:= ""
Local cVendedor	:= ""
Local cAliasSE1	:= ""
Local cWhere		:= ""
Local cWhile		:= ""
Local lLiquid   := .F. 
Local lFatura  	:= .F.
Local cNatCom	:= PADR(&(GetNewPar("MV_NATCOM","")),nTamE2_NATUR)
Local lAtuSldNat:= lFindAtuSld .AND. AliasInDic("FIV") .AND. AliasInDic("FIW")
Local cFilSA3	:= ''
Local cFilSE3	:= ''
Local lE3_MOEDA := SE3->(FieldPos("E3_MOEDA")) > 0
Local cVendNx	:= ""
Local cSoma1	:= "9" 
DEFAULT lDevolucao:= SuperGetMv("MV_COMIDEV")
DEFAULT cComisCR:= GetMv("MV_COMISCR")
DEFAULT lCompensa:= cComisCR == "S"
DEFAULT lF440DelB:= Existblock("F440DELB")
DEFAULT lGestao	:= Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa

PRIVATE cKeySE1 	:= ""

If cPaisLoc == "MEX"
	cFilSE3 := xFilial("SE3")
Else
	If lGestao
		cFilSE3 := Iif(Empty(FwFilial("SE3")) , xFilial("SE3") , SE1->E1_FILORIG )
	Else
		cFilSE3 := Iif(Empty(xFilial("SE3")) , xFilial("SE3") , SE1->E1_FILORIG )
	EndIf
Endif

If (Alltrim(SE1->E1_FATURA)=="NOTFAT" ) .AND. !( ValidaFat() )
	Return (.F.)
Endif

If ( Len(aBaixas) > 0 )
	dbSelectArea("SE3")
	aadd(aBaixas,{"zzz","zz",0}) // Controle de Saida
	For nCntFor := 1 To Len(aBaixas)
		If ( If(!lDevolucao,aBaixas[nCntFor,1]!="DEV",.T.) .And. ;
				If(!lCompensa ,aBaixas[nCntFor,1]!="CMP",.T.) )
			dbSelectArea("SE5")
			If ( aBaixas[nCntFor,3] != 0 )
				MsGoto(aBaixas[nCntFor,3])
			Else
				cQuebra := ""	
			EndIf	
			If ( cQuebra != aBaixas[nCntFor,1]+aBaixas[nCntFor,2] .OR. FunName()=="FINA088")
				If ( !Empty(cQuebra) .Or. aBaixas[nCntFor,3] == 0 )
					dbSelectArea("SE1")
					dbSetOrder(2)			
					If !(MsSeek(xFilial("SE1")+cTitulo)) .and. cOrigem == "FINA330

						MsSeek(SE5->E5_FILORIG+cTitulo)
					EndIf
					lFatura   := If(alltrim(SE1->E1_FATURA)=="NOTFAT",.T.,.F.)
					lLiquid  := !Empty(SE1->E1_NUMLIQ)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Adiciona vendedores que deverÆo ser descalculados  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ( !lFatura .And. !lLiquid)
						aVendedor := {}
						For nCntFor2 := 1 to nQtdVend
							If nCntFor2 > 9
								cSoma1 := Soma1(cSoma1,1)	// Converte para "A" e assim por diante
								cVendNx := cSoma1
							Else
								cVendNx := Str(nCntFor2)
							EndIf
							cVendedor := &("SE1->E1_VEND"+Alltrim(cVendNx))
							If ( !Empty(cVendedor) )
								AAdd( aVendedor , cVendedor)
							EndIf
						Next nCntFor2
					Else
						If lFatura
							aVendedor := {}
							//Guarda todas as lojas do cliente em um array, pois uma fatura pode conter títulos de todas as lojas.
							aLojas := LojasSA1(SE1->E1_CLIENTE)
							nRecSE1 := SE1->(Recno())
							
							For nLoja := 1 TO Len(aLojas)
								cFatura := SE1->E1_CLIENTE+aLojas[nLoja]+SE1->E1_PREFIXO+SE1->E1_NUM
								cKeySE1 := cFatura
								#IFDEF TOP	
									cWhere  := ""	
									If SE1->E1_ORIGEM <> "FINA280M" // Se fatura com multiplas filiais
										cWhere  +=  "SE1.E1_FILIAL = '"+ xFilial("SE1") +"' AND "
									EndIf
									cWhere +=  "SE1.E1_FATPREF = '" + SE1->E1_PREFIXO + "' AND "
									cWhere +=  "SE1.E1_FATURA = '" + SE1->E1_NUM + "' "
									cWhere := "%"+cWhere+"%"
									cAliasSE1 := GetNextAlias()
									BeginSql Alias cAliasSE1
										SELECT 
											SE1.R_E_C_N_O_ RECSE1 
										FROM 
											%Table:SE1% SE1
										WHERE 
											%Exp:cWhere% AND
											SE1.%NotDel%							
										ORDER BY
											E1_FILIAL,E1_CLIENTE,E1_LOJA,E1_FATPREF,E1_FATURA
									EndSql
									
									(cAliasSE1)->(dbGoTop())
						
									While !(cAliasSE1)->(Eof())
										aAdd(aRecSE1,(cAliasSE1)->RECSE1)
										(cAliasSE1)->(dbSkip())
									EndDo
				
									(cAliasSE1)->(dbCloseArea())
								#ELSE
									dbSelectArea("SE1")
									dbSetOrder(10)
									MsSeek(xFilial("SE1")+cFatura,.F.)
									While ( !Eof() .And. xFilial("SE1") == SE1->E1_FILIAL .And.;
											SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_FATPREF+SE1->E1_FATURA==;
											cFatura )
										aAdd(aRecSE1,SE1->(Recno()))
										SE1->(dbSkip())
									EndDo
								#ENDIF
								Fa440LiqFat(@aRecSE1, @aTitLiq)
								
								For nY := 1 To Len(aRecSE1) 
									dbSelectArea("SE1")
									SE1->(dbGoTo(aRecSE1[nY]))
									For nCntFor2 := 1 to nQtdVend
										If nCntFor2 > 9
											cSoma1 := Soma1(cSoma1,1)	// Converte para "A" e assim por diante
											cVendNx := cSoma1
										Else
											cVendNx := Str(nCntFor2)
										EndIf
										cVendedor := &("SE1->E1_VEND"+Alltrim(cVendNx))
										If ( !Empty(cVendedor) )
											If ( aScan(aVendedor,{|x| x == cVendedor}) == 0 )
												AAdd( aVendedor , cVendedor)
											EndIf
										EndIf
									Next nCntFor2
								Next nY
								//volta ao registro original antes de procurar o vendedor da proxima loja
								dbSelectArea("SE1")
								SE1->(dbGoto(nRecSE1))
							Next nLoja
						Else
							Fa440LiqSE1(SE1->E1_NUMLIQ,@aLiquid,,@aSeqCont)
							For nX := 1 To Len(aLiquid)							
								SE1->(MsGoto(aLiquid[nX]))
								For nCntFor2 := 1 to nQtdVend
									If nCntFor2 > 9
										cSoma1 := Soma1(cSoma1,1)	// Converte para "A" e assim por diante
										cVendNx := cSoma1
									Else
										cVendNx := Str(nCntFor2)
									EndIf
									cVendedor := &("SE1->E1_VEND"+Alltrim(cVendNx))
									If ( !Empty(cVendedor) )
										If ( aScan(aVendedor,{|x| x == cVendedor}) == 0 )
											AAdd( aVendedor , cVendedor)
										EndIf
									EndIf
								Next nCntFor2
							Next nX
						EndIf
					EndIf
					If !Empty(SE1->E1_FILORIG)
						cFilSE3 := FwxFilial("SE3", SE1->E1_FILORIG)
					EndIf
					For nCntFor2 := 1 To Len(aVendedor)
						If ( If(cVendDe==Nil.Or.cVendAte==Nil,.T.,;
								aVendedor[nCntFor2]>=cVendDe.And.;
								aVendedor[nCntFor2] <= cVendAte ) )
								
							dbSelectArea("SE3")
							dbSetOrder(3)
							MsSeek(cFilSE3+aVendedor[nCntFor2]+cTitulo+cSeq,.F.)
							If ( Found() )
								If ( Empty(SE3->E3_DATA) ) // Nao esta pago
									If lAtuSldNat .and. cNatCom != NIL
										// Tratamento de outras moedas no controle de saldos do fluxo de caixa por natureza
										If lE3_MOEDA .AND. VAL(SE3->E3_MOEDA) > 1
											nValComis := NOROUND(XMOEDA(SE3->E3_COMIS,1,VAL(SE3->E3_MOEDA),SE3->E3_EMISSAO))
										Else
									   		nValComis := SE3->E3_COMIS		
										EndIf
									
										//Atualizo o valor atual para o saldo da natureza
										AtuSldNat(cNatCom, SE3->E3_VENCTO, Iif(lE3_MOEDA, SE3->E3_MOEDA, "01"), "2", "P", nValComis, SE3->E3_COMIS,"-",,FunName(),"SE3",SE3->(Recno()))
									Endif
																					
									RecLock("SE3")
									dbDelete()
									MsUnlock()
								Else
									If (SE5->E5_MOTBX <> 'LIQ' .AND. SE5->E5_SITUACA <> 'C')
										// não gerar comissao negativa para liquidacao cancelada, pois a comissao gerada é excluida no cancelamento
										Fa440CalcB({aBaixas[nCntFor-1]},lJuros,lDescont,cOrigem,"-",aVendedor[nCntFor2],aVendedor[nCntFor2])
									EndIf	
								EndIf
							Else
								If ( SE1->E1_SALDO != SE1->E1_VALOR )
									If (SE5->E5_MOTBX <> 'LIQ' .AND. SE5->E5_SITUACA <> 'C')
										// não gerar comissao negativa para liquidacao cancelada, pois a comissao gerada é excluida no cancelamento
										Fa440CalcB({aBaixas[nCntFor-1]},lJuros,lDescont,cOrigem,"-",aVendedor[nCntFor2],aVendedor[nCntFor2])
									EndIF	
								EndIf
							EndIf
						EndIf
						If lF440DelB
							ExecBlock("F440DELB",.F.,.F., aVendedor[nCntFor2])
						EndIf
					Next nCntFor2
					If aBaixas[nCntFor,3] == 0
						Exit
					Else
						aLiquid := {} 
					EndIf
				EndIf
				cQuebra   := aBaixas[nCntFor,1]+aBaixas[nCntFor,2]
				cTitulo   := SE5->E5_CLIFOR+SE5->E5_LOJA+;
					SE5->E5_PREFIXO+SE5->E5_NUMERO+;
					SE5->E5_PARCELA+SE5->E5_TIPO
				cSeq		 := SE5->E5_SEQ
			EndIf
		EndIf
	Next nCntFor
EndIf
RestArea(aAreaSE5)
RestArea(aAreaSE1)
RestArea(aAreaSA3)
RestArea(aArea)
Return(.F.)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FA440ChecF³ Autor ³ Eduardo Riera         ³ Data ³ 01/10/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua sele‡„o dos T¡tulos.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA440                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fa440Checf(nFiltro,lQuery)

Local cFiltro		:= ""
Local cQuery		:= ""

DEFAULT lQuery := .F.
DEFAULT cComiLiq 	:= SuperGetMv("MV_COMILIQ",,"2")
DEFAULT lDevolucao:= SuperGetMv("MV_COMIDEV")
DEFAULT lComiLiq	:= ComisBx("LIQ") .AND. cComiLiq == "1"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso motivo da baixa seja DEVOLUCAO e lCalcComis = .F.	³
//³ NO calcula a comiss„o . O Valor de lCalcComis vem do 	³
//³ parƒmetro MV_COMIDEV									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If ( nFiltro == 1 )
	cFiltro := 'E1_FILIAL=="'+xFilial("SE1")+'".And.'
	cFiltro += 'DTOS(E1_EMISSAO)>="'+DTOS(mv_par01)+'".And.'
	cFiltro += 'DTOS(E1_EMISSAO)<="'+DTOS(mv_par02)+'".And.'
	cFiltro += '!(E1_TIPO $ "' + MVRECANT + If(!lDevolucao,'#'+MV_CRNEG,'')+'")'
EndIf
If ( nFiltro == 2 )
	cFiltro := 'E5_FILIAL=="'+xFilial("SE5")+'".And.'
	cQuery  := "((E5_FILIAL = '" + xFilial("SE5") + "') OR (E5_FILORIG = '" + cFilAnt +"' AND E5_MOTBX = 'CMP')) AND "
   //Verifica se considera a data da baixa ou a data de disponibilidade do titulo 
	If mv_par09 == 1
		cFiltro += 'Dtos(E5_DATA)>="' + Dtos(mv_par01) + '".And.'
		cQuery  += "E5_DATA >= '"+dtos(mv_par01) + "' AND "
		cFiltro += 'Dtos(E5_DATA)<="' + Dtos(mv_par02) + '".And.'
		cQuery  += "E5_DATA <= '"+Dtos(mv_par02) + "' AND "
	Else
		cFiltro += 'Dtos(E5_DTDISPO)>="' + Dtos(mv_par01) + '".And.'
		cQuery  += "E5_DTDISPO >= '"+dtos(mv_par01) + "' AND "
		cFiltro += 'Dtos(E5_DTDISPO)<="' + Dtos(mv_par02) + '".And.'
		cQuery  += "E5_DTDISPO <= '"+Dtos(mv_par02) + "' AND "                                                  
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso parƒmetro MV_COMIDEV = .F.	, desconsidera o baixa de³
	//³ titulo por devolucao para fins de recalculo de comissao. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lDevolucao
		cFiltro += 'E5_MOTBX!="DEV".And.'
		cQuery  += "E5_MOTBX<>'DEV' AND "
	Endif
	cFiltro += 'E5_MOTBX != "'+Space(Len(SE5->E5_MOTBX))+'".And.'

	//NAO permitir que se faca calculo de comissao pela geracao da liquidacao e sim pelo metodo novo
	If !lComiLiq
		cQuery  += "E5_MOTBX NOT IN('   ','LIQ') AND "
		cFiltro += 'E5_MOTBX <> "LIQ" .And.'
	Endif

	cFiltro += '(E5_RECPAG=="R".Or.(E5_RECPAG=="P".And.(E5_TIPODOC=="ES" .Or. E5_TIPO $ MV_CRNEG))) .And. !(E5_TIPODOC$"BD#TR")'
	cQuery  += "(E5_RECPAG='R' OR (E5_RECPAG='P' AND (E5_TIPODOC='ES' Or E5_TIPO IN "+FormatIN(MV_CRNEG,,3)+"))) AND E5_TIPODOC NOT IN('BD','TR') "

EndIf
If ( nFiltro == 3 )
	cFiltro := 'E3_FILIAL=="'+xFilial("SE3")+'".And.'
	cFiltro += 'Dtos(E3_EMISSAO)>="'+Dtos(mv_par01)+'".And.'
	cFiltro += 'Dtos(E3_EMISSAO)<="'+Dtos(mv_par02)+'".And.'
	cFiltro += 'E3_VEND>="'+mv_par03+'".And.'
	cFiltro += 'E3_VEND<="'+mv_par04+'".And.'
	cFiltro += 'Dtos(E3_DATA)=="'+Dtos(cTod("//"))+'".And.'
	cFiltro += 'E3_ORIGEM!=" "'
EndIf

Return IIF(lQuery,cQuery,cFiltro)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FA440Comis³ Autor ³ Eduardo Riera         ³ Data ³ 16/12/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua o calculo das bases da comissao de um determinado   ³±±
±±³          ³ t¡tulo financeiro.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 : Numero do Registro do SE1 ( Contas a Receber )     ³±±
±±³			 ³ ExpL2 : .T. : Atualiza baseS da comissao do SE1.			  ³±±
±±³			 ³ ExpL3 : .F. : Retorna bases do SE1 ou (.T.) recalcula(Defa)³±±
±±³			 ³ ExpN4 : Numero do Registro do SD2 para Devol.de Vendas     ³±±
±±³			 ³ ExpL5 : .F. : Nao calcula array de bases por parcela da NF ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Retorna um Array com as bases da comissao. na seguinte     ³±±
±±³          ³ estrutura [C¢digo do Vendedor]                             ³±±
±±³          ³           [Base da Comissao]                               ³±±
±±³          ³           [Base na Emissao ]                               ³±±
±±³          ³           [Base na Baixa   ]                               ³±±
±±³          ³           [Vlr  na Emissao ]                               ³±±
±±³          ³           [Vlr  na Baixa   ]                               ³±±
±±³			 ³ 			 [% da Comissao/Se "Zero" diversos %'s]           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Fina440                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa440Comis(nRegistro,lGrava,lRefaz,nRegDevol,lCalcParc,nRecnoOrig)

Local aArea 	 := GetArea()
Local aAreaSE4  := {}
Local aAreaSF2  := {}
Local aAreaSF4  := {}
Local aAreaSD2  := {}
Local aAreaSA1  := {}
Local aAreaSA3  := {}
Local aAreaSD1  := {}
Local aAreaSF1  := {}
Local aAreaSE1  := {}
Local aAux      := {}
Local aSD2Vend  := {} // Array c/ as Bases dos Vend. por item de nota
Local aBaseNCC  := {} // Array c/ as Bases dos Vend.
Local aBaseSE1  := {} // Array c/ as Bases dos Vend. do Titulo em questao
Local aBaseSD1  := {} // Array c/ as Bases dos Vend. do Item da NFE
Local aImp			:= {}  // Recebe o array de TesImpInf
Local aSemNota		:=	{}
Local aVendPed  	:= {}

Local nCntFor   	:= 0
Local nMaxFor   	:= 0
Local nBaseSe1  	:= 0 // Base da Comissao
Local nBaseDif  	:= 0
Local nPerComis 	:= 0 // Percentual da Comissao
Local nBaseEmis 	:= 0 // Base da Comissao na Emissao
Local nBaseBaix 	:= 0 // Base da Comissao na Baixa                  s
Local nVlrEmis  	:= 0 // Valor da Comissao na Emissao
Local nVlrBaix  	:= 0 // Valor da Comissao na Baixa
Local nFrete    	:= 0 // Valor do Frete
Local nIcmFrete 	:= 0 // Valor do Icms sobre frete
Local nTotal    	:= 0 // Total das mercadorias pelo item
Local nRatFrete 	:= 0 // Valor rateado do Frete por item
Local nRatIcmFre	:= 0 // Valor rateado do icms s/ frete por item
Local nSF2IcmRet	:= 0 // Valor do Icms Retido
Local nVlrFat   	:= 0 // Valor faturado
Local nVlrTit   	:= 0 // valor do titulo em questao
Local nProp     	:= 0
Local nPos      	:= 0
Local nAlEmissao	:= 0
Local nAlBaixa  	:= 0
Local nRatINSS  	:= 0
Local nRatIRRF  	:= 0
Local nX        	:= 0
Local nRatCOF		:= 0
Local nRatCSL		:= 0
Local nRatPIS  	:= 0
Local nScanPis  	:= 0
Local nScanCof  	:= 0
Local nPosFldPis	:= 0
Local nPosFldCof	:= 0
Local nImp      	:= 0
Local nDescImp  	:= 0 
Local nFreteAux 	:= 0 
Local nPis 			:= 0
Local nCofins 		:= 0
Local nCsll 		:= 0
Local nValPis		:= 0
Local nValCof		:= 0
Local nValCsl		:= 0
Local nValIrf		:= 0

Local nDecimal  	:= nTamBascom // N@ de decimais considerados no calculo
Local nDecimalP		:= nTamPerc   // N@ de decimais considerados no percentual de comissão 
Local cVend     	:= "1"
Local cVendedor 	:= ""
Local cSerie    	:= ""
Local cPrefixo  	:= "" // Prefixo da Duplicata
Local cFilialSD1	:= ""
Local cFilialSD2	:= ""
Local cFilialSE1	:= ""
Local cFilialSE2	:= ""
Local cFilialSE4	:= ""
Local cFilialSF1	:= ""
Local cFilialSF2	:= ""
Local cFilialSF4	:= ""
Local cFieldPis 	:= ""
Local cFieldCof 	:= ""                              
Local lD2_ICMSCOM := SD2->(FieldPos("D2_ICMSCOM")) > 0
Local lD2_DIFAL   := SD2->(FieldPos("D2_DIFAL")) > 0
Local cCposSD2  	:= "D2_FILIAL#D2_DOC#D2_SERIE#D2_CLIENTE#D2_LOJA#D2_TES#D2_ICMFRET#D2_TOTAL#D2_VALICM#D2_VALIPI#D2_IPI#D2_ICMSRET#D2_VALACRS#D2_ITEM#D2_COD#D2_DESCICM"
Local cAliasSD1 	:= "SD1"
Local cAliasSD2 	:= "SD2"
Local cAliasDev 	:= "SD1"
Local cAliasSF4 	:= "SF4"
Local cImp			:= "N"	 // Se A3_COMIMP nao existe, cImp = N, senao pega valor em A3_COMIMP
Local cEspSes		:= " "
Local lQuery    	:= .F.
Local lContinua 	:= .T.
Local cPrimParc 	:= " "
Local lRecIRRF  	:= .F.
Local lMata460  	:= Alltrim(SE1->E1_ORIGEM) == "MATA460"
//Controla o Pis Cofins e Csll na baixa  (1-Retem PCC na Baixa ou 2-Retem PCC na Emissão(default) )
Local lPccBxCr		:= If (lFindPccBx,FPccBxCr(),.F.)

Local nIrPjBx 		:= 0
Local lIrPjBxCr		:= If (lFindIrBx,FIrPjBxCr(),.F.)
Local lCalEmis		:= IsInCallStack("FA440CALCE")
Local lCOMIPIS		:= GetNewPar("MV_COMIPIS","N") == "N"
Local lCOMICOF		:= GetNewPar("MV_COMICOF","N") == "N"
Local lCOMICSL		:= GetNewPar("MV_COMICSL","N") == "N"
Local lCOMISIR		:= GetNewPar("MV_COMISIR","N") == "N"
Local lCOMISIN		:= GetNewPar("MV_COMIINS","N") == "N"
Local lMultVend := SuperGetMv("MV_LJTPCOM",,"1" ) == "2"
Local nTotCsAbt  := 0 
Local nTotPisAbt := 0 
Local nTotCofAbt := 0
Local nImpComis		:= 0
Local nTotIrAbt	:= 0
Local nIrrf     	:= 0
Local cFunName := FunName()
Local lFC_ABATCOM := SFC->(FieldPos("FC_ABATCOM")) > 0
Local nCntForOld := 0
Local cLastVend	:= ""
Local cLastItem	:= ""
Local nPosITEM	:= 0
Local nRedIcms	:= 0
Local cEstado		:= SuperGetMv("MV_ESTADO")
Local lCalcIssBx	:= GetNewPar("MV_MRETISS","1") == "2"
Local nValISS		:= 0
Local lLoja       := IsInCallStack("LjGrvFin") .Or. cFunName == "LOJA701" //Funcoes chamadas pelo Loja 

//Variável usadas como aux ao P.E F440BASE, para não gerar.
//divergência na gravação do valor base da comissão.
Local nF440BasEm := 0

#IFDEF TOP
	Local cQuery    := ""
#ENDIF	
Static aStruSD1
Static aStruSD2
Static aStruSF4


Default lCalcParc := .T.
DEFAULT nRecnoOrig := nRegistro
DEFAULT cMV_1DUP	:= SuperGetMv("MV_1DUP")   
DEFAULT cComiLiq 	:= SuperGetMv("MV_COMILIQ",,"2")
DEFAULT lComiLiq	:= ComisBx("LIQ") .AND. cComiLiq == "1"
DEFAULT lF440BasEm	:= Existblock("F440BASE")

nVend     	:= fa440CntVen() // Numero M ximo de Vendedores
If aRelImp == nil 
	aRelImp		:= MaFisRelImp("MT100",{ "SD2" })
EndIf	
// Abertura dos arquivos pois no Loja alguns nao sao utilizados

dbSelectArea("SE4")
aAreaSE4  := SE4->(GetArea())
cFilialSE4:= xFilial("SE4")

dbSelectArea("SF2")
aAreaSF2  := SF2->(GetArea())
cFilialSF2:= xFilial("SF2")
                 
dbSelectArea("SF4")
aAreaSF4  := SF4->(GetArea())
cFilialSF4:= xFilial("SF4")

dbSelectArea("SD2")
aAreaSD2  := SD2->(GetArea())
cFilialSD2:= xFilial("SD2") 

dbSelectArea("SA1")
aAreaSA1  := SA1->(GetArea())

dbSelectArea("SA3")
aAreaSA3  := SA3->(GetArea())
                 
dbSelectArea("SD1")
aAreaSD1  := SD1->(GetArea())
cFilialSD1:= xFilial("SD1")

dbSelectArea("SF1")
aAreaSF1  := SF1->(GetArea())
cFilialSF1:= xFilial("SF1")

dbSelectArea("SE1")
aAreaSE1  := SE1->(GetArea())
cFilialSE1:= xFilial("SE1")

dbSelectArea("SE2")
cFilialSE2:= xFilial("SE2")

RestArea(aArea)  
If lD2_ICMSCOM
	cCposSD2 += "#D2_ICMSCOM"
EndIf
If lD2_DIFAL
	cCposSD2 += "#D2_DIFAL"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se é a primeira parcela de uma fatura               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTamParc == 1
	cPrimParc := "1A "
ElseIf nTamparc == 2
	cPrimParc := cMV_1DUP+Space(2-Len(cMV_1DUP))
	If cPrimParc == "00"
		cPrimParc += "#1 #A #  "
	Else
		cPrimParc += "#1 #A #  #01"
	Endif
Else	
	cPrimParc := cMV_1DUP+Space(3-Len(cMV_1DUP))
	If cPrimParc == "000"
		cPrimParc += "#1  #A  #   "
	Else
		cPrimParc += "#1  #A  #   #001"
	EndIf
Endif


If nTamParc == 1
	cSegparc := "2B "
ElseIf nTamparc == 2
	cSegparc := soma1(cMV_1DUP,1)+Space(2-Len(cMV_1DUP))
	cSegparc += "#2 #B #  #02"
Else	
	cSegparc := soma1(cMV_1DUP,1)+Space(3-Len(cMV_1DUP))
	cSegparc += "#2  #B  #   #002"
Endif

if cPaisLoc<>"BRA"
	cEspSes	:= GetSesNew("NDC","1")
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento de Parametros Default da funcao                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lRefaz := If( lRefaz == Nil , .T. , lRefaz )
lGrava := If( lGrava == Nil , .T. , lGrava )
If ( aStruSD1 == Nil )
	aStruSD1 := {}
	dbSelectArea("SD1")
	aAux := dbStruct()
	For nCntFor := 1 To Len(aAux)
		If ( FieldName(nCntFor)$"D1_FILIAL#D1_DOC#D1_SERIE#D1_FORNECE#D1_LOJA" .Or.;
				FieldName(nCntFor)$"D1_NFORI#D1_SERIORI#D1_COD#D1_ITEMORI#D1_TOTAL#D1_VALDESC#D1_ITEM" )
			aadd(aStruSD1,{aAux[nCntFor,1],aAux[nCntFor,2],aAux[nCntFor,3],aAux[nCntFor,4]})
		EndIf
	Next nCntFor
EndIf
If ( aStruSD2 == Nil )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se os campos que gravam o valor do PIS/COFINS para  ³
	//³ abater da base conforme configurado                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If !Empty( nScanPis := aScan(aRelImp,{|x| x[1]=="SD2" .And. x[3]=="IT_VALPS2"} ) )
		cFieldPis  := aRelImp[nScanPis,2]
	EndIf
	
	If !Empty( nScanCof := aScan(aRelImp,{|x| x[1]=="SD2" .And. x[3]=="IT_VALCF2"} ) )
		cFieldCof := aRelImp[nScanCof,2]
	EndIf 	

	aStruSD2 := {}
	dbSelectArea("SD2")
	aAux := dbStruct()
	For nCntFor := 1 To Len(aAux)
		If ( FieldName(nCntFor)$cCposSD2 .Or.;
			FieldName(nCntFor)$cFieldPis .Or.;
			FieldName(nCntFor)$cFieldCof .Or.;
			"D2_COMIS"$FieldName(nCntFor) )			
			aadd(aStruSD2,{aAux[nCntFor,1],aAux[nCntFor,2],aAux[nCntFor,3],aAux[nCntFor,4]})
		EndIf
	Next nCntFor
EndIf
If ( aStruSF4 == Nil )
	aStruSF4 := {}
	dbSelectArea("SF4")
	aAux := dbStruct()
	For nCntFor := 1 To Len(aAux)
		If ( FieldName(nCntFor)$"F4_DUPLIC#F4_INCIDE#F4_IPIFRET#F4_INCSOL#F4_ISS" )
			aadd(aStruSF4,{aAux[nCntFor,1],aAux[nCntFor,2],aAux[nCntFor,3],aAux[nCntFor,4]})	
		EndIf
	Next nCntFor
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no Registro do SE1 a ser calculado                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE1")
MsGoto(nRegistro)
//Verifica se o cliente e responsavel pelo recolhimento do IR ou nao.
		If cPaisloc == "BRA"	

			dbSelectArea("SED")       
			SED->(dbSetOrder(1))
			
			dbSelectArea("SA1")       
			SA1->(dbSetOrder(1))
			
			If SED->(FieldPos("ED_RECIRRF")) > 0 .AND. SED->(dbSeek(xFilial("SED") + SED->ED_CODIGO ) ) .And. SED->ED_RECIRRF == "1"
				lRecIRRF := .T.
			ElseIf SA1->(dbSeek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA))) .And. SA1->A1_RECIRRF == "1"
				lRecIRRF := .T.
			Endif
						
		Endif	
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o titulo foi gerado pelo faturamento e for neces-³
//³ sario recalcular suas bases.                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( SE1->E1_TIPO $ MVNOTAFIS+cEspSes ) .and. (!lSF2460I .or.(lSF2460I .And. "MATA460"$SE1->E1_ORIGEM))
	For nCntFor := 1 To nVend 	
		cVendedor := SE1->(FieldGet(SE1->(FieldPos("E1_VEND"+cVend))))
		nPerComis := SE1->(FieldGet(SE1->(FieldPos("E1_COMIS"+cVend))))
		If ( nPerComis == 0 .And. !Empty(cVendedor) )
			lRefaz := .T.
			Exit
		EndIf
		cVend := Soma1(cVend,1)
	Next nCntFor
ElseIf	cPaisLoc <>"BRA" .and.( SE1->E1_TIPO $ MV_CRNEG+MVRECANT)
	lRefaz := .T. 
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona Registros                                          ³
//³ Aqui se faz necessaria a cria‡Æo de tratamento de filial de  ³
//³ origem para quando se tem SE1 compartilhado e SF2, SE4 ou SD2³
//³ exclusivos                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SE1->(FieldPos("E1_MSFIL")) > 0
	If !Empty(SE1->E1_MSFIL) .and. !(Empty(cFilialSf1)) .And. cModeAcSE1=="C" .And. cModeAcSF1=="E" 
		cFilialSf1 := SE1->E1_MSFIL
	Endif
	If !Empty(SE1->E1_MSFIL) .and. !(Empty(cFilialSf2)) .And. cModeAcSE1=="C" .And. cModeAcSF2=="E" 
		cFilialSf2 := SE1->E1_MSFIL
	Endif
	If !Empty(SE1->E1_MSFIL) .and. !(Empty(cFilialSf4)) .And. cModeAcSE1=="C" .And. cModeAcSF4=="E" 
		cFilialSf4 := SE1->E1_MSFIL
	Endif	
	If !Empty(SE1->E1_MSFIL) .and. !(Empty(cFilialSe1)) .And. cModeAcSE1=="C" .And. cModeAcSE1=="E" 
		cFilialSe1 := SE1->E1_MSFIL
	Endif
	If !Empty(SE1->E1_MSFIL) .and. !(Empty(cFilialSe2)) .And. cModeAcSE1=="C" .And. cModeAcSE2=="E" 
		cFilialSe2 := SE1->E1_MSFIL
	Endif		
	If !Empty(SE1->E1_MSFIL) .and. !(Empty(cFilialSe4)) .And. cModeAcSE1=="C" .And. cModeAcSE4=="E" 
		cFilialSe4 := SE1->E1_MSFIL
	Endif
	If !Empty(SE1->E1_MSFIL) .and. !(Empty(cFilialSd1)) .And. cModeAcSE1=="C" .And. cModeAcSD1=="E" 
		cFilialSd1 := SE1->E1_MSFIL
	Endif
	If !Empty(SE1->E1_MSFIL) .and. !(Empty(cFilialSd2)) .And. cModeAcSE1=="C" .And. cModeAcSD2=="E" 
		cFilialSd2 := SE1->E1_MSFIL
	Endif
Else
	If SE1->(FieldPos("E1_FILORIG")) > 0
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSf1)) .And. cModeAcSE1=="C" .And. cModeAcSF1=="E" 
			cFilialSf1 := SE1->E1_FILORIG
		Endif	
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSf2)) .And. cModeAcSE1=="C" .And. cModeAcSF2=="E" 
			cFilialSf2 := SE1->E1_FILORIG
		Endif
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSe1)).And. cModeAcSE1=="C" .And. cModeAcSE1=="E"
			cFilialSe1 := SE1->E1_FILORIG
		Endif
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSe2)) .And. cModeAcSE1=="C" .And. cModeAcSE2=="E" 
			cFilialSe2 := SE1->E1_FILORIG
		Endif		
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSe4)) .And. cModeAcSE1=="C" .And. cModeAcSE4=="E" 
			cFilialSe4 := SE1->E1_FILORIG
		Endif
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSd1)) .And. cModeAcSE1=="C" .And. cModeAcSD1=="E" 
			cFilialSd1 := SE1->E1_FILORIG
		Endif	
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSd2)).And. cModeAcSE1=="C" .And. cModeAcSD2=="E" 
			cFilialSd2 := SE1->E1_FILORIG
		Endif
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSf4)) .And. cModeAcSE1=="C" .And. cModeAcSF4=="E" 
			cFilialSf4 := SE1->E1_FILORIG
		Endif
	Endif
EndIf
If ( SE1->E1_TIPO $ MVNOTAFIS+cEspSes .And. lRefaz)
	If Year(SE1->E1_EMISSAO)<2001
		cSerie := If(Empty(SE1->E1_SERIE),SE1->E1_PREFIXO,SE1->E1_SERIE)
	Else               	
		cSerie := SE1->E1_SERIE
	EndIf
	dbSelectArea("SF2")
	dbSetOrder(1)
	If (!MsSeek(cFilialSF2+SE1->E1_NUM+cSerie+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.))
		lContinua := .F.
	EndIf
	dbSelectArea("SE4")
	dbSetOrder(1)
	If (!MsSeek(cFilialSE4+SF2->F2_COND))
		lContinua := .F.
	EndIf
	dbSelectArea("SD2")
	dbSetOrder(3)
	#IFDEF TOP
		If ( TcSrvType()!="AS/400" )
			SD2->(dbCommit())
			lQuery := .T.
			cAliasSD2 := "FA440COMIS"
			cAliasSF4 := "FA440COMIS"
			cQuery := ""
			For nCntFor := 1 To Len(aStruSD2)
				cQuery += ","+aStruSD2[nCntFor][1]
			Next nCntFor
			For nCntFor := 1 To Len(aStruSF4)
				cQuery += ","+aStruSF4[nCntFor][1]
			Next nCntFor
			
			cQuery := "SELECT SD2.R_E_C_N_O_ SD2RECNO,"+SubStr(cQuery,2)
			cQuery += "  FROM "+RetSqlName("SD2")+" SD2,"+RetSqlName("SF4")+" SF4 "
			cQuery += " WHERE SD2.D2_FILIAL   = '"+cFilialSD2+"'"
			cQuery += "   AND SD2.D2_DOC	  = '"+SE1->E1_NUM+"'"
			cQuery += "   AND SD2.D2_SERIE	  = '"+cSerie+"'"
			cQuery += "   AND SD2.D2_CLIENTE  = '"+SE1->E1_CLIENTE+"'"
			cQuery += "   AND SD2.D2_LOJA     = '"+SE1->E1_LOJA+"'"
			cQuery += "   AND SD2.D_E_L_E_T_ <> '*'"
			cQuery += "   AND SF4.F4_FILIAL	  ='"+cFilialSF4+"'"
			cQuery += "   AND SF4.F4_CODIGO   = SD2.D2_TES"
			cQuery += "   AND SF4.D_E_L_E_T_  <> '*' "
			cQuery += " ORDER BY "+SqlOrder(SD2->(IndexKey()))   
			
			//cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2)
			
			lContinua := !(cAliasSD2)->(Eof())
			For nCntFor := 1 To Len(aStruSD2)
				If ( aStruSD2[nCntFor][2]!= "C" )
					TcSetField(cAliasSD2,aStruSD2[nCntFor][1],aStruSD2[nCntFor][2],aStruSD2[nCntFor][3],aStruSD2[nCntFor][4])
				EndIf
			Next nCntFor
			For nCntFor := 1 To Len(aStruSF4)
				If ( aStruSF4[nCntFor][2]!="C" )
					TcSetField(cAliasSF4,aStruSF4[nCntFor][1],aStruSF4[nCntFor][2],aStruSD2[nCntFor][3],aStruSF4[nCntFor][4])
				EndIf
			Next nCntFor
		Else
	#ENDIF	
		If (!MsSeek(cFilialSD2+SE1->E1_NUM+cSerie+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.))
			lContinua := .F.
		EndIf
		#IFDEF TOP
		EndIf	
		#ENDIF
	If ( lContinua )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calculo da comissao por item de nota fiscal                  ³
		//³                                                              ³
		//³1)O Valor do icms s/ frete e adiciona ao campo F2_VALICM, por ³
		//³esta razao deve-se somar o vlr do icms dos itens e subtrair   ³
		//³do total de icms (F2_VALICM) para apurar-se o vlr icms s/frete³
		//³                                                              ³
		//³2)O mesmo ocorre para o valor do IPI sobre frete, Por esta ra-³
		//³zao e' calculado o valor do IPI sobre frete do item multipli- ³
		//³cando-se o valor do frete do item pelo % de ipi do item.      ³
		//³                                                              ³
		//³3)O Valor do Icms Retido pode nÆo estar no total da nota (F2_-³
		//³VALBRUT) por isto deve-se considerar o campo (D2_ICMSRET).    ³
		//³                                                              ³
		//³4)O percentual da comissao dever ser considerado para cada i- ³
		//³tem de nota fiscal pois ela pode ser diferente entre eles. O  ³
		//³percentual gravado no E1_COMIS ‚ sempre um valor aproximado e ³
		//³nao deve ser considerado ser houver nota fiscal para o titulo.³
		//³                                                              ³
		//³5)A Base da Comissao ‚ o valor da mercadoria + o valor do ipi ³
		//³+ o valor das despesas acessorias +  o icms solidario. Como e'³
		//³por item deve-se conhece-lo pelo item a item.                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTotal     := 0
		nFrete     := (SF2->F2_FRETE + SF2->F2_SEGURO + SF2->F2_DESPESA)
		nIcmFrete  := 0
		nSF2IcmRet :=0
		
		If !Empty( nScanPis := aScan(aRelImp,{|x| x[1]=="SD2" .And. x[3]=="IT_VALPS2"} ) )
			cFieldPis  := aRelImp[nScanPis,2]
		EndIf
		
		If !Empty( nScanCof := aScan(aRelImp,{|x| x[1]=="SD2" .And. x[3]=="IT_VALCF2"} ) )
			cFieldCof := aRelImp[nScanCof,2]
		EndIf 	
		
		If  lPccBxCr .and. !lCalEmis
		 	nPis		:= SE1->E1_PIS
		 	nCofins	:= SE1->E1_COFINS
		 	nCofins	:= SE1->E1_CSLL
		Endif
		
		While ( !Eof() .And. (cAliasSD2)->D2_FILIAL == cFilialSD2 .And.;
				(cAliasSD2)->D2_DOC 	 == SE1->E1_NUM .And.;
				(cAliasSD2)->D2_SERIE	 == cSerie .And.;
				(cAliasSD2)->D2_CLIENTE  == SE1->E1_CLIENTE .And.;
				(cAliasSD2)->D2_LOJA	 == SE1->E1_LOJA	)

			If ( !lQuery )
				dbSelectArea("SF4")
				dbSetOrder(1)
				MsSeek(cFilialSF4+(cAliasSD2)->D2_TES)
			Else
				If cPaisLoc<>"BRA"
					SD2->(DbGoto((cAliasSD2)->SD2RECNO))
				Endif
			EndIf
			nRedIcms := 0
			
			If AllTrim(cEstado) == "MG"
				DbSelectArea("SFT")
				SFT->(DbSetOrder(1))
				If SFT->(DbSeek(xFilial("SFT")+'S'+(cAliasSD2)->(D2_SERIE+D2_DOC+D2_CLIENTE+D2_LOJA+PADR((cAliasSD2)->D2_ITEM, TamSX3("FT_ITEM")[1] )+D2_COD)))
					nRedIcms := SFT->FT_DS43080
				EndIF
			EndIf
			
			cVend := "1"
			For nCntFor := 1 To nVend
				cVendedor := SF2->(FieldGet(SF2->(FieldPos("F2_VEND"+cVend))))
				nPerComis := (cAliasSD2)->(FieldGet((cAliasSD2)->(FieldPos("D2_COMIS"+cVend))))
				nImp     := 0
				nDescImp := 0
				If cPaisLoc <> "BRA"
					SA3->(DbSetOrder(1))
					SA3->(DbSeek(xFilial()+cVendedor))
					aImp := TesImpInf(	(cAliasSD2)->D2_TES)
					cImp := IIf(SA3->(FieldPos("A3_COMIMP")) >0,SA3->A3_COMIMP,"N")
					For nX :=1 to Len(aImp)
						If (cImp+aImp[nX][3] == "S1")
							nImp += SD2->(FieldGet(FieldPos(aImp[nX][2])))
						ElseIf (cImp+aImp[nX][3] == "N2")
							nImp -=	SD2->(FieldGet(FieldPos(aImp[nX][2])))
						EndIf
						If cPaisLoc == "PTG" .And. lFC_ABATCOM .And. cImp+aImp[nX][13] == "N1"
							nImpComis -= SD2->(FieldGet(FieldPos(aImp[nX][2]))) 
						EndIf
					Next nX
				Else
					If (cAliasSD2)->(FieldPos("D2_DESCICM"))<>0
						nDescImp -= (cAliasSD2)->D2_DESCICM
					EndIf				
				EndIf
				If ( !Empty(cVendedor) .And. (cAliasSF4)->F4_DUPLIC == "S" )
					aadd(aSD2Vend,{ cVendedor,;
						(cAliasSD2)->D2_TOTAL-nRedIcms+nImp+nDescImp,;
						(cAliasSD2)->(D2_VALICM+If(lD2_ICMSCOM,D2_ICMSCOM,0)+If(lD2_DIFAL,D2_DIFAL,0))+nDescImp,;
						(cAliasSD2)->D2_VALIPI,;
						(cAliasSD2)->D2_IPI,;
						(cAliasSF4)->F4_INCIDE,;
						(cAliasSF4)->F4_IPIFRET,;
						Iif(cPaisLoc<>"BRA".Or.(cAliasSF4)->F4_INCSOL=="N",0,(cAliasSD2)->D2_ICMSRET),;
						nPerComis,;
						(cAliasSD2)->D2_VALACRS,;
						If(lQuery,(cAliasSD2)->SD2RECNO,(cAliasSD2)->(RecNo())),;
						(cAliasSF4)->F4_ISS=="S",;
						cVend,;
						nPis,;
						nCofins,;
						Iif(!Empty(cFieldPis), (cAliasSD2)-> D2_VALIMP5,0) ,; // pis apuração
						Iif(!Empty(cFieldCof), (cAliasSD2)-> D2_VALIMP6,0) }) // cofins apuração
						If cPaisLoc == "PTG" .And. lFC_ABATCOM
							Aadd(aSD2Vend[Len(aSD2Vend)],(cAliasSD2)->D2_TOTAL+nImpComis+nDescImp)
							Aadd(aSD2Vend[Len(aSD2Vend)],(cAliasSD2)->D2_ITEM)
						Else
							Aadd(aSD2Vend[Len(aSD2Vend)],(cAliasSD2)->D2_ITEM)
						EndIf
						nPosITEM := Len(aSD2Vend[Len(aSD2Vend)])
					If aScan(aVendPed, cVendedor) == 0	  // Monta um array com os vendedores para rateio do frete
					   aadd(aVendPed, cVendedor)
					Endif
					//*****************************************************
					// Ajusta a base da comissao da nota para a Moeda 01  *
					//*****************************************************
					If cPaisLoc<>"BRA"
						If  IsInCallStack("FINA087A")
							If cPaisLoc  == "MEX"
								aSD2Vend[Len(aSD2Vend),2]	:=	xMoeda( aSD2Vend[Len(aSD2Vend),2] , SF2->F2_MOEDA , 1 , SF2->F2_EMISSAO , nDecimal ,IIF( aLinSE1[oLBSE1:nAt][44] > 0, aLinSE1[oLBSE1:nAt][44] ,aLinMoed[SE1->E1_MOEDA][2]))
							Else 
								aSD2Vend[Len(aSD2Vend),2]	:= 	xMoeda( aSD2Vend[Len(aSD2Vend),2] , SF2->F2_MOEDA , 1 , SF2->F2_EMISSAO , nDecimal , aLinMoed[SE1->E1_MOEDA][2])
							EndIf
						Else
							aSD2Vend[Len(aSD2Vend),2]	:= 	xMoeda( aSD2Vend[Len(aSD2Vend),2] , SF2->F2_MOEDA , 1 , SF2->F2_EMISSAO , nDecimal , SF2->F2_TXMOEDA )
						EndIf       					
					EndIf 		  
				EndIf							
				cVend := Soma1(cVend,1)
			Next nCntFor
			If ( (cAliasSF4)->F4_ISS != "S" )
				If (cAliasSF4)->(FieldPos("F4_INCSOL"))>0
					nSF2IcmRet += Iif((cAliasSF4)->F4_INCSOL=="N",0,(cAliasSD2)->D2_ICMSRET)
				EndIf
				If (cAliasSD2)->(FieldPos("D2_ICMFRET"))>0
					nIcmFrete  += (cAliasSD2)->D2_ICMFRET
				EndIf
			EndIf
			nTotal	  += (cAliasSD2)->D2_TOTAL-nRedIcms
			dbSelectArea(cAliasSD2)
			dbSkip()
		EndDo
		If ( lQuery )
			dbSelectArea(cAliasSD2)
			dbCloseArea()
			dbSelectArea("SD2")
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calculo da comissao pela nota.                               ³
		//³                                                              ³
		//³1)Apos calculado as bases de cada vendedor por item de nota   ³
		//³deve-se aglutina-las formando uma unica base para toda a nota ³
		//³fiscal.                                                       ³
		//³                                                              ³
		//³2)Como os valores serao aglutinados pode-se haver perda de de-³
		//³cimais por isto deve-se haver um controle para que a perda se-³
		//³ja adicionada a primeira parcela da nota.                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nMaxFor := Len(aSD2Vend)
		nPerComis:=0
		nFreteAux := 0
		For nCntFor := 1 To nMaxFor
			If (lPePercom)
				nPerComis := ExecBlock("FIN440PE",.F.,.F.,{aSD2Vend[nCntFor][1]})
				If ( ValType(nPerComis)<>"N" )
					nPerComis := aSD2Vend[nCntFor][9]
				Else
					aSD2Vend[nCntFor][9] := nPerComis
				EndIf
			Else
				nPerComis := aSD2Vend[nCntFor][9]
			EndIf
			If ( SE1->E1_PARCELA $ cPrimParc )
				nBaseDif  := NoRound(nFrete*(1-(aSD2Vend[nCntFor,2]/nTotal)),nDecimal+1)
				nBaseDif  := nFrete - nBaseDif
				// No ultimo item o valor do rateio do frete é o valor do frete menos o rateio do frete acumulado
				// ate o penultimo item (evitar diferenca de centavos na base da comissao (E1_BASCOM)
				If nCntFor == nMaxFor
				   nRatFrete := (nFrete * If(Len(aVendPed) > 0, Len(aVendPed), 1)) - nFreteAux
				Else
					nFreteAux += nBaseDif
					nRatFrete := nBaseDif
				EndIf
			Else
				nRatFrete := NoRound(nFrete*aSD2Vend[nCntFor,2]/nTotal,nDecimal+1)
			EndIf   
			If cPaisLoc == "BRA"
				// INSS
				If ( SE1->E1_PARCELA $ cPrimParc )
					nBaseDif  := NoRound(SF2->F2_VALINSS*(1-(aSD2Vend[nCntFor,2]/nTotal)),nDecimal+1)
					nBaseDif  := SF2->F2_VALINSS - nBaseDif
					nRatINSS  := nBaseDif
				Else
					nRatINSS := NoRound(SF2->F2_VALINSS*aSD2Vend[nCntFor,2]/nTotal,nDecimal+1)
				EndIf	

				//PIS, COFINS, CSLL
				nValPis := If( SF2->(FieldPos("F2_VALPIS"))  > 0 , SF2->F2_VALPIS , SE1->E1_PIS )
				nValCof := If( SF2->(FieldPos("F2_VALCOFI")) > 0 , SF2->F2_VALCOFI, SE1->E1_COFINS )
				nValCsl := If( SF2->(FieldPos("F2_VALCSLL")) > 0 , SF2->F2_VALCSLL, SE1->E1_CSLL )
				
				If ( SE1->E1_PARCELA $ cPrimParc )
					nBaseDif	:= NoRound(nValPis*(1-(aSD2Vend[nCntFor,2]/nTotal)),nDecimal)
					nBaseDif	:= nValPis - nBaseDif
					nRatPIS		:= nBaseDif
					
					nBaseDif	:= NoRound(nValCof*(1-(aSD2Vend[nCntFor,2]/nTotal)),nDecimal)
					nBaseDif	:= nValCof - nBaseDif
					nRatCOF		:= nBaseDif
					
					nBaseDif	:= NoRound(nValCsl*(1-(aSD2Vend[nCntFor,2]/nTotal)),nDecimal)
					nBaseDif	:= nValCsl - nBaseDif
					nRatCSL		:= nBaseDif
				Else
					nRatPIS	:= NoRound(nValPis*aSD2Vend[nCntFor,2]/nTotal,nDecimal)
					nRatCOF	:= NoRound(nValCof*aSD2Vend[nCntFor,2]/nTotal,nDecimal)
					nRatCSL	:= NoRound(nValCsl*aSD2Vend[nCntFor,2]/nTotal,nDecimal)
				EndIf

				// PCC da BAIXA - FATOR DE PROPORCIONALIZAÇÃO
				If  lPccBxCr .and. !lCalEmis
			 		If !(SE5->E5_PRETPIS	$	"1;2")
						nPis	:= SE5->E5_VRETPIS
					Else
						nPis	:=	0
					EndIf
					If !(SE5->E5_PRETCOF	$	"1;2")
						nCofins	:= SE5->E5_VRETCOF
					Else
						nCofins	:= 0
					EndIf
					If !(SE5->E5_PRETCSL	$	"1;2")
						nCsll	:= SE5->E5_VRETCSL
					Else
						nCsll	:=	0
					EndIf
				EndIf
				
				// IRRF
				nValIrf := If( SF2->(FieldPos("F2_VALIRRF")) > 0 , SF2->F2_VALIRRF, SE1->E1_IRRF )
				If ( SE1->E1_PARCELA $ cPrimParc )
					nBaseDif  := NoRound(nValIrf*(1-(aSD2Vend[nCntFor,2]/nTotal)),nDecimal)
					nBaseDif  := nValIrf - nBaseDif
					nRatIRRF  := nBaseDif
				Else
					nRatIRRF := NoRound(nValIrf*aSD2Vend[nCntFor,2]/nTotal,nDecimal)
				EndIf
				
				// IRRF da BAIXA - FATOR DE PROPORCIONALIZAÇÃO
				If lIrPjBxCr .And. !lCalEmis
					If !(SE5->E5_PRETIRF	$"1;2")
						nIRRF	:= SE5->E5_VRETIRF
					Else
						nIRRF	:= 0
					EndIf
				EndIf
				
			EndIf
			nRatIcmFre:= 0
			nBaseSE1  := 0
			nPos      := 0
			nRatIcmFre:= NoRound(nIcmFrete*aSD2Vend[nCntFor,2]/nTotal,nDecimal)
			nBaseSE1  := aSD2Vend[nCntFor,2]+IIF(SF2->F2_TIPO=='P',0,aSD2Vend[nCntFor,4])+aSD2Vend[nCntFor,8]+nRatFrete //soma-se IPI e ICM Retido
			dbSelectArea("SA3")
			dbSetOrder(1)
			MsSeek(xFilial()+aSD2Vend[nCntFor,1])
			lCOMISIR := IIf( SA3->(FieldPos("A3_BASEIR"))<>0 , SA3->A3_BASEIR != "2" , lCOMISIR )

			If SE1->(FieldPos("E1_ALEMIS"+aSD2Vend[nCntFor,13]))<>0 //Nao criar no dicionario padrao
				nAlEmissao := SE1->(FieldGet(FieldPos("E1_ALEMIS"+aSD2Vend[nCntFor,13])))
			Else
				nAlEmissao := SA3->A3_ALEMISS
			EndIf
			If SE1->(FieldPos("E1_ALBAIX"+aSD2Vend[nCntFor,13]))<>0 //Nao criar no dicionario padrao
				nAlBaixa := SE1->(FieldGet(FieldPos("E1_ALBAIX"+aSD2Vend[nCntFor,13])))
			Else
				nAlBaixa := SA3->A3_ALBAIXA
			EndIf

			If ( SA3->A3_FRETE == "N" )
				nBaseSE1 -=  nRatFrete
				nBaseSE1 +=  nRatIcmFre
			Endif
			If ( SA3->A3_IPI   == "N" )
				nBaseSE1 -= ( aSD2Vend[nCntFor,4] )
			EndIf
			If !aSD2Vend[nCntFor,12]
				If ( SA3->A3_ICM   == "N" )
					nBaseSE1 -= aSD2Vend[nCntFor,3]
				EndIf
			Else                    
				If ( SA3->A3_ISS == "N" ) 				                              
					//Se o valor do ISS calculado for inferior ao minimo de retencao (MV_VRETISS), nao descontar da base de comissao
					If SuperGetMV("MV_VRETISS",.F.,0) < aSD2Vend[nCntFor,3]
						nBaseSE1 -= ( aSD2Vend[nCntFor,3] )
					Endif
				EndIf				
			EndIf				
			If ( SA3->A3_ICMSRET == "N" )
				nBaseSE1 -= ( aSD2Vend[nCntFor,8] )
			EndIf
			If SA3->(FieldPos("A3_ACREFIN")) != 0  // Acrescimo Financeiro
				If ( SA3->A3_ACREFIN == "N" ) .and. aSD2Vend[nCntFor,10] > 0
					nBaseSE1 -= ( aSD2Vend[nCntFor,10] )
				EndIf
			Endif
			
			If SA3->(FieldPos("A3_PISCOF")) != 0  // Abate Pis/Cofins
				Do Case
				Case SA3->A3_PISCOF == "2" //Abate Pis
					nBaseSE1 -=aSD2Vend[nCntFor,16]
				Case SA3->A3_PISCOF == "3" //Abate Cofins
					nBaseSE1 -=aSD2Vend[nCntFor,17]				
				Case SA3->A3_PISCOF == "4" //Abate ambos
					nBaseSE1 -=aSD2Vend[nCntFor,16]
					nBaseSE1 -=aSD2Vend[nCntFor,17]
				EndCase	
			Endif

			// IRRF			
			If lCOMISIR .And. lRecIRRF
				nBaseSE1 -= nRatIRRF
			Endif
			
			// INSS
			If lCOMISIN
				nBaseSE1 -= nRatINSS									    
			EndIf
			
			// PIS, COFINS, CSLL
			If SuperGetMv("MV_COMIPIS",.F.,"N") == "N"
				nBaseSE1 -= nRatPIS
			EndIf
			If SuperGetMv("MV_COMICOF",.F.,"N") == "N"
				nBaseSE1 -= nRatCOF
			EndIf
			If SuperGetMv("MV_COMICSL",.F.,"N") == "N"
				nBaseSE1 -= nRatCSL
			EndIf
			
			nPos := aScan(aBaseSE1,{|x| x[1] == aSD2Vend[nCntFor,1]})
			If Alltrim(SE1->E1_Hist) <> "VENDA EM DINHEIRO"
				nBaseBaix := Round(nBaseSE1*nAlBaixa/100,nDecimal+1)	 	// Base da Comissao na Baixa
			ELSE
				nBaseBaix:= 0
			Endif
			nBaseEmis := nBaseSE1-nBaseBaix                           		// Base da Comissao na Emissao
			If ( nAlEmissao==0 .AND.  Alltrim(SE1->E1_Hist) <> "VENDA EM DINHEIRO" )
				nBaseEmis := 0
			EndIf
			
			nVlrEmis  := nBaseEmis*aSD2Vend[nCntFor,9]/100	// Valor da Comissao na Emissao
			nVlrBaix  := nBaseBaix*aSD2Vend[nCntFor,9]/100	// Valor da Comissao na Baixa
			If ( Empty(nRegDevol) .Or. nRegDevol == aSD2Vend[nCntFor,11] )
				If ( nPos == 0 )
					aadd(aBaseSE1,{ aSD2Vend[nCntFor,1] ,;
						nBaseSE1  				,;
						nBaseEmis 				,;
						nBaseBaix 				,;
						nVlrEmis  				,;
						nVlrBaix				,;
						nPerComis				,;
						nPis						,;
						nCsll						,;
						nCofins				,;
						nIrrf					})
						If cPaisLoc == "PTG" .And. lFC_ABATCOM
							Aadd(aBaseSE1[Len(aBaseSE1)],Round((aSD2Vend[nCntFor,18]*aSD2Vend[nCntFor,9]/100)*SA3->A3_ALEMISS/100,nDecimal))
							Aadd(aBaseSE1[Len(aBaseSE1)],aSD2Vend[nCntFor,18]*SA3->A3_ALEMISS/100)
						EndIf
				Else
					aBaseSE1[nPos,2] += nBaseSE1
					aBaseSE1[nPos,3] += nBaseEmis
					aBaseSE1[nPos,4] += nBaseBaix
					aBaseSE1[nPos,5] += nVlrEmis
					aBaseSE1[nPos,6] += nVlrBaix
					If aBaseSE1[nPos,7] == nPerComis
						aBaseSE1[nPos,7] := nPerComis
					Else
						aBaseSE1[nPos,7] := 0
					EndIf
				EndIf	                                                                       
			EndIf
		Next nCntFor
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calculo da comissao pelas parcelas.                          ³
		//³                                                              ³
		//³1)O SE3 ‚ gravado por parcela e nao pela nota. assim e'neces- ³
		//³ssario calcular a base da comissao para a parcela em questao. ³
		//³                                                              ³
		//³2)Aqui deve-se tomar o maximo cuidado com a Condi‡Æo de pagto ³
		//³pois se o Icms Solidario ou o Ipi for separado de alguma par- ³
		//³cela deve-se considera esta separacao para calcular-se a me-  ³
		//³lhor propor‡ao possivel para a base da parcela.               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lCalcParc
			nMaxFor := Len(aBaseSE1)
			For nCntFor := 1 To nMaxFor
				nProp   := 0   
				           
				If  IsInCallStack("FINA087A")
					If cPaisLoc  == "MEX"
						nVlrFat := xMoeda(SF2->F2_VALFAT,SE1->E1_MOEDA,1,SE1->E1_EMISSAO,,IIF( aLinSE1[oLBSE1:nAt][44] > 0, aLinSE1[oLBSE1:nAt][44] ,aLinMoed[SE1->E1_MOEDA][2]))
					Else
						nVlrFat := xMoeda(SF2->F2_VALFAT,SE1->E1_MOEDA,1,SE1->E1_EMISSAO,,aLinMoed[SE1->E1_MOEDA][2])
					EndIf
				Else
					nVlrFat := xMoeda(SF2->F2_VALFAT,SE1->E1_MOEDA,1,SE1->E1_EMISSAO)
				EndIf       
				
				
				If  IsInCallStack("FINA087A")
					If cPaisLoc  == "MEX"
						nVlrTit :=  xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,1,SE1->E1_EMISSAO,,IIF( aLinSE1[oLBSE1:nAt][44] > 0,aLinSE1[oLBSE1:nAt][44],aLinMoed[SE1->E1_MOEDA][2]))
					Else					
						nVlrTit :=  xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,1,SE1->E1_EMISSAO,,aLinMoed[SE1->E1_MOEDA][2])
					EndIf
				Else                     
					nVlrTit := SE1->E1_VLCRUZ
				EndIf       
				
				nCntForOld := nCntFor
				cLastVend := aBaseSE1[nCntFor,1]
				cLastItem := ""
				dbSelectArea("SA3")
				dbSetOrder(1)
				MsSeek(xFilial()+aBaseSE1[nCntFor,1])
				For nCntFor :=1 To Len(aSD2Vend)
					If cLastVend == aSD2Vend[nCntFor,1] .And. cLastItem != aSD2Vend[nCntFor,nPosITEM]
						If ( SA3->A3_IPI == "N" .Or. SA3->A3_ICMSRET == "N" )
							If ( (SE4->E4_IPI == "S" .And. SF2->F2_VALIPI <> 0) .Or. ( SE4->E4_SOLID=="S" .And. SF2->F2_ICMSRET <> 0 .And. aSD2Vend[nCntFor,08] <> 0 ) ) .And. (SE1->E1_PARCELA $ cPrimParc)
						   		If !Empty(SE1->E1_PARCELA)
									nVlrTit := 0
									nVlrFat := 0
								EndIf
							EndIf
							If ( (SE4->E4_IPI == "S" .Or. SE4->E4_SOLID == "S") .And. !(SE1->E1_PARCELA $ cPrimParc))
								If SE1->E1_PARCELA $ cSegParc .OR. (SE1->E1_PARCELA > cSegParc .And. SE4->E4_SOLID == "S" .And. SE4->E4_IPI $ "N ")
									If SE4->E4_IPI == "S"
										nVlrFat -= aSD2Vend[nCntFor,04]
										If SE4->E4_SOLID == "J"
											nVlrFat	-= aSD2Vend[nCntFor,08]
										EndIf
									EndIf
									If SE4->E4_SOLID == "S"
										nVlrFat -= aSD2Vend[nCntFor,08]
										If SE4->E4_IPI == "J"
											nVlrFat	-= aSD2Vend[nCntFor,04]
										EndIf
									EndIf
								Elseif SE4->E4_IPI == "S" .and. SE4->E4_SOLID == "S"
									nVlrFat -= aSD2Vend[nCntFor,04]
									nVlrFat -= aSD2Vend[nCntFor,08]
								EndIf
							EndIf
							If ( SE4->E4_IPI == "J" .And. SE1->E1_PARCELA $ cPrimParc)
								nVlrFat	-= aSD2Vend[nCntFor,04]
								nVlrTit	-= aSD2Vend[nCntFor,04]
								If SA3->A3_IPI == "S"
									nVlrFat	+= aSD2Vend[nCntFor,04]
									nVlrTit	+= aSD2Vend[nCntFor,04]								
								EndIf
							EndIf
							If ( SE4->E4_IPI == "J" .And. !(SE1->E1_PARCELA $ cPrimParc)) 
								If SA3->A3_IPI == "N"
									nVlrFat	-= aSD2Vend[nCntFor,04]
								EndIf
								If !(SE1->E1_PARCELA $ cSegParc)
									If SE4->E4_SOLID == "S"
										nVlrFat -= aSD2Vend[nCntFor,08]
									EndIf
								EndIf
							EndIf
							If ( SE4->E4_SOLID == "J" .And. SE1->E1_PARCELA $ cPrimParc )
								nVlrFat -= aSD2Vend[nCntFor,08]
								nVlrTit -= aSD2Vend[nCntFor,08]
							EndIf
							If ( SE4->E4_SOLID == "J" .And. !(SE1->E1_PARCELA $ cPrimParc)) 
								nVlrFat -= aSD2Vend[nCntFor,08]
								If SE4->E4_IPI == "S"
									nVlrFat	-= aSD2Vend[nCntFor,04]
								EndIf
							EndIf
						EndIf
						cLastItem := aSD2Vend[nCntFor,nPosITEM]
					EndIf
				Next nCntFor
				nCntFor := nCntForOld
				If ( nVlrTit > 0 )
					nProp := nVlrFat / nVlrTit
				Else
					nProp := 0
				EndIf                           
				If (nProp != 0 )
					nBaseSE1 := aBaseSE1[nCntFor,2]/nProp
					nBaseEmis:= aBaseSE1[nCntFor,3]/nProp
					nBaseBaix:= aBaseSE1[nCntFor,4]/nProp
					nVlrEmis := aBaseSE1[nCntFor,5]/nProp
					nVlrBaix := aBaseSE1[nCntFor,6]/nProp
				Else
					nBaseSE1 := 0
					nBaseEmis:= 0
					nBaseBaix:= 0
					nVlrEmis := 0
					nVlrBaix := 0
				EndIf
				If ( SE1->E1_PARCELA $ cPrimParc .And. nBaseSE1 != 0 )
					//--> Calculo da Proporcao para a Base da Comissao
					nBaseDif := Round(nBaseSE1 * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,2]-nBaseDif
					aBaseSE1[nCntFor,2] := nBaseSE1+nBaseDif
					//--> Calculo da Proporcao para a Base da Comissao pela Emissao
	
					nBaseDif := Round(nBaseEmis * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,3]-nBaseDif
					aBaseSE1[nCntFor,3] := nBaseEmis+nBaseDif
					If cPaisLoc == "PTG" .And. lFC_ABATCOM
						aBaseSE1[nCntFor,12] := NoRound(aBaseSE1[nCntFor,12]/nProp,nDecimal+1)
					EndIf
					//--> Calculo da Proporcao para a Base da Comissao pela Baixa
	
					nBaseDif := Round(nBaseBaix * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,4]-nBaseDif
					aBaseSE1[nCntFor,4] := nBaseBaix+nBaseDif
					//--> Calculo da Proporcao para o Valor da Comissao pela Emissao
	
					nBaseDif := Round(nVlrEmis * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,5]-nBaseDif
					aBaseSE1[nCntFor,5] := nVlrEmis+nBaseDif
					If cPaisLoc == "PTG" .And. lFC_ABATCOM
						aBaseSE1[nCntFor,11] := Round(aBaseSE1[nCntFor,11]/nProp,nDecimal+1)     
					EndIf
					//--> Calculo da Proporcao para o Valor da Comissao pela Baixa
	
					nBaseDif := Round(nVlrBaix * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,6]-nBaseDif
					aBaseSE1[nCntFor,6] := nVlrBaix+nBaseDif
				Else
					aBaseSE1[nCntFor,2] := nBaseSE1
					aBaseSE1[nCntFor,3] := nBaseEmis
					aBaseSE1[nCntFor,4] := nBaseBaix
					aBaseSE1[nCntFor,5] := nVlrEmis
					aBaseSE1[nCntFor,6] := nVlrBaix
					If cPaisLoc == "PTG" .And. lFC_ABATCOM
						aBaseSE1[nCntFor,12] := NoRound(aBaseSE1[nCntFor,12]/nProp,nDecimal+1) 
						aBaseSE1[nCntFor,11] := Round(aBaseSE1[nCntFor,11]/nProp,nDecimal+1)
					EndIf
				EndIf
				
				//--> Calculo da Proporcao para o Percentual de Comissao pela Baixa
				If aBaseSE1[nCntFor,7] == 0
					aBaseSE1[nCntFor,7] :=  (aBaseSE1[nCntFor,6]*100)/aBaseSE1[nCntFor,4]
				EndIf
			Next nCntFor
		EndIf	
	Else
		If ( lQuery .And. Select(cAliasSD2)<>0 )
			dbSelectArea(cAliasSD2)
			dbCloseArea()
			dbSelectArea("SE1")
		EndIf
	EndIf
EndIf
If ( SE1->E1_TIPO $ MV_CRNEG ) .And. !("FINA040" $ SE1->E1_ORIGEM)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a filial de origem das notas de devolucao de Venda  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If SE1->(FieldPos("E1_FILORIG")) > 0
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSF1)) .And. cModeAcSE1=="C" .And. cModeAcSF1=="E"	
			cFilialSF1 := SE1->E1_FILORIG
		Endif	
	EndIf	
	If SE1->(FieldPos("E1_FILORIG")) > 0
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSD1)) .And. cModeAcSE1=="C" .And. cModeAcSD1=="E"		
			cFilialSD1 := SE1->E1_FILORIG
		Endif	
	EndIf                     
	
	If Year(SE1->E1_EMISSAO)<2001
		cSerie := If(Empty(SE1->E1_SERIE),SE1->E1_PREFIXO,SE1->E1_SERIE)
	Else
		cSerie := SE1->E1_SERIE
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona Registros                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF1")
	dbSetOrder(1)
	If (!MsSeek(cFilialSF1+SE1->E1_NUM+cSerie+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.))
		lContinua := .F.
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calculo do Estorno da Comissao.                              ³
	//³                                                              ³
	//³1) Localiza-se a Nota Original                                ³
	//³                                                              ³
	//³2) Calcula a Comissao para a Nota Original                    ³
	//³                                                              ³
	//³3) Faz a Proporcao entre os valor da Mercadoria e os valores  ³
	//³   da comissao.                                               ³
	//³                                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD1")
	dbSetOrder(1)
	#IFDEF TOP
		If ( TcSrvType()!="AS/400" )
			SD1->(dbCommit())
			cAliasSD1 := "BFA440COMIS"
			lQuery := .T.
			cQuery := ""
			For nCntFor := 1 To Len(aStruSD1)
				cQuery += ","+aStruSD1[nCntFor][1]
			Next nCntFor
			
			cQuery := "SELECT "+SubStr(cQuery,2)
			cQuery += "  FROM "+RetSqlName("SD1")+" SD1 "
			cQuery += " WHERE SD1.D1_FILIAL  = '"+cFilialSD1+"'"
			cQuery += "   AND SD1.D1_DOC	 = '"+SE1->E1_NUM+"'"
			cQuery += "   AND SD1.D1_SERIE	 = '"+cSerie+"'"
			cQuery += "   AND SD1.D1_FORNECE = '"+SE1->E1_CLIENTE+"'"
			cQuery += "   AND SD1.D1_LOJA    = '"+SE1->E1_LOJA+"'"
			cQuery += "   AND "
			If cPaisLoc<>"BRA"
				cQuery += "SD1.D_E_L_E_T_<>'*' "
			Else
				cQuery += "    SD1.D_E_L_E_T_<>'*'"
				cQuery += "AND SD1.D1_ITEMORI<>'"+Space(Len(SD1->D1_ITEMORI))+"' "
			EndIF
			cQuery += "ORDER BY "+SqlOrder(SD1->(IndexKey()))
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD1,.T.,.T.)
			
			lContinua := !(cAliasSD1)->(Eof())
			For nCntFor := 1 To Len(aStruSD1)
				If ( aStruSD1[nCntFor][2]!="C" )
					TcSetField(cAliasSD1,aStruSD1[nCntFor][1],aStruSD1[nCntFor][2],aStruSD1[nCntFor][3],aStruSD1[nCntFor][4])
				EndIf
			Next nCntFor
		Else
	#ENDIF
		If (!MsSeek(cFilialSD1+SE1->E1_NUM+cSerie+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.))
			lContinua := .F.
		EndIf
		#IFDEF TOP
		EndIf
		#ENDIF
	aSemNota	:=	{}
	While ( !Eof() .And. cFilialSD1  == (cAliasSD1)->D1_FILIAL  .And.;
			SF1->F1_DOC 	 == (cAliasSD1)->D1_DOC	  .And.;
			SF1->F1_SERIE	 == (cAliasSD1)->D1_SERIE   .And.;
			SF1->F1_FORNECE == (cAliasSD1)->D1_FORNECE .And.;
			SF1->F1_LOJA	 == (cAliasSD1)->D1_LOJA )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Localiza a Nota de Saida - Item                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD2")
		dbSetOrder(3)
		MsSeek(cFilialSD2+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+AllTrim((cAliasSD1)->D1_ITEMORI))
		If !SD2->(FOUND())
			//Carrega os items que nao tem nota original
			AAdd(aSemNota,(cAliasSD1)->D1_ITEM)
		Endif
		aBaseSD1 := {} // Inicializa Bases do Item
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona no Nota Fiscal de Saida - Cabecalho                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SF2")
		dbSetOrder(1)
		MsSeek(cFilialSF2+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
		If Empty(SF2->F2_PREFIXO)			
			cPrefixo := Alltrim(Posicione("SX6",1,cFilialSF2+"MV_1DUPREF","X6_CONTEUD"))
			If Empty(cPrefixo) //Caso não exista o parametro na filial posicionada, pega o coteudo (GetMv)
				cPrefixo := &(GetMV("MV_1DUPREF"))
			EndIf
		Else
			cPrefixo := SF2->F2_PREFIXO
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona no Titulo Financeiro                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE1")
		dbSetOrder(2)
		MsSeek(cFilialSE1+SF2->F2_CLIENTE+SF2->F2_LOJA+cPrefixo+SD2->D2_DOC)
		While ( !Eof() .And. cFilialSE1  == SE1->E1_FILIAL .And.;
				SE1->E1_CLIENTE == SF2->F2_CLIENTE .And.;
				SE1->E1_LOJA    == SF2->F2_LOJA .And.;
				SE1->E1_PREFIXO == cPrefixo .And.;
				SE1->E1_NUM		 == SF2->F2_DOC )
			If ( SE1->E1_TIPO $ MVNOTAFIS+cEspSes )
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Calcula o Valor da Comissao para a Parcela                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aBaseNCC := Fa440Comis(SE1->(Recno()),.F.,.T.,SD2->(RecNo()))
				For nCntFor := 1 To Len(aBaseNCC)
					cVendedor := aBaseNCC[nCntFor,1]
					nPos := aScan(aBaseSD1,{|x| x[1]==cVendedor})
					If ( nPos == 0 )
						aadd(aBaseSD1,{ 	aBaseNCC[nCntFor,1],;
							aBaseNCC[nCntFor,2],;
							aBaseNCC[nCntFor,3],;
							aBaseNCC[nCntFor,4],;
							aBaseNCC[nCntFor,5],;
							aBaseNCC[nCntFor,6],;
							aBaseNCC[nCntFor,7]})
					Else
						aBaseSD1[nPos,2] += aBaseNCC[nCntFor,2]
						aBaseSD1[nPos,3] += aBaseNCC[nCntFor,3]
						aBaseSD1[nPos,4] += aBaseNCC[nCntFor,4]
						aBaseSD1[nPos,5] += aBaseNCC[nCntFor,5]
						aBaseSD1[nPos,6] += aBaseNCC[nCntFor,6]
					EndIf
				Next nCntFor
			EndIf
			dbSelectArea("SE1")
			dbSkip()
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Aqui eh proporcionalizado as Bases da nota de saida com o item devol.  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nCntFor := 1 To Len(aBaseSD1)
			aBaseSD1[nCntFor,2] := NoRound(aBaseSD1[nCntFor,2]*((cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC)/SD2->D2_TOTAL,nDecimal+1)		
			aBaseSD1[nCntFor,3] := Round(aBaseSD1[nCntFor,3]*((cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC)/SD2->D2_TOTAL,nDecimal+1)
			aBaseSD1[nCntFor,4] := NoRound(aBaseSD1[nCntFor,4]*((cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC)/SD2->D2_TOTAL,nDecimal+1)
			aBaseSD1[nCntFor,5] := (aBaseSD1[nCntFor,5]*((cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC)/SD2->D2_TOTAL)
			aBaseSD1[nCntFor,6] := NoRound(aBaseSD1[nCntFor,6]*((cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC)/SD2->D2_TOTAL,nDecimal+1)
		Next nCntFor
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Aqui eh somado as bases ja calculadas e como a NCC estorna os valores   ³
		//³na emissao, adiciona-se a base da baixa na base da emissao.             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nCntFor := 1 To Len(aBaseSD1)
			cVendedor := aBaseSD1[nCntFor,1]
			nPos := aScan(aBAseSE1,{|x| x[1] == cVendedor })
			If ( nPos == 0 )
				aadd(aBaseSE1,{ 	aBaseSD1[nCntFor,1],;
					aBaseSD1[nCntFor,2],;
					aBaseSD1[nCntFor,3]+aBaseSD1[nCntFor,4],0,;
					aBaseSD1[nCntFor,5]+aBaseSD1[nCntFor,6],0,0})
			Else
				aBaseSE1[nPos,2] += aBaseSD1[nCntFor,2]
				aBaseSE1[nPos,3] += aBaseSD1[nCntFor,3]+aBaseSD1[nCntFor,4]
				aBaseSE1[nPos,5] += aBaseSD1[nCntFor,5]+aBaseSD1[nCntFor,6]
			EndIf
		Next nCntFor
		dbSelectArea(cAliasSD1)
		dbSkip()
	EndDo
	If ( (Empty(aBaseSE1).Or. Len(aSemNota) > 0) .And. lRefaz .And. cPaisLoc<>"BRA")
		dbSelectArea("SE1")
		MsGoto(nRegistro)
		cSerie := If(Empty(SE1->E1_SERIE),SE1->E1_PREFIXO,SE1->E1_SERIE)
		dbSelectArea("SF1")
		dbSetOrder(1)
		If (!MsSeek(cFilialSF1+SE1->E1_NUM+cSerie+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.))
			lContinua := .F.
		EndIf
		dbSelectArea("SE4")
		dbSetOrder(1)
		If (!MsSeek(cFilialSE4+SF1->F1_COND))
			lContinua := .F.
		EndIf
		dbSelectArea("SD1")
		dbSetOrder(1)
		#IFDEF TOP
			If ( TcSrvType()!="AS/400" )
				lQuery := .T.
				cAliasDev := "FA440COMIS"
				cAliasSF4 := "FA440COMIS"
				cQuery := ""
				For nCntFor := 1 To Len(aStruSD1)
					cQuery += ","+aStruSD1[nCntFor][1]
				Next nCntFor
				For nCntFor := 1 To Len(aStruSF4)
					cQuery += ","+aStruSF4[nCntFor][1]
				Next nCntFor  
				
				cQuery := "SELECT SD1.R_E_C_N_O_ SD1RECNO,"+SubStr(cQuery,2)
				cQuery += "  FROM "+RetSqlName("SD1")+" SD1,"+RetSqlName("SF4")+" SF4 "
				cQuery += " WHERE SD1.D1_FILIAL   = '"+cFilialSD1+"'"
				cQuery += "   AND SD1.D1_DOC      = '"+SE1->E1_NUM+"'"
				cQuery += "   AND SD1.D1_SERIE    = '"+cSerie+"'"
				cQuery += "   AND SD1.D1_FORNECE  = '"+SE1->E1_CLIENTE+"'"
				cQuery += "   AND SD1.D1_LOJA	  = '"+SE1->E1_LOJA+"'"
				cQuery += "   AND SD1.D_E_L_E_T_  <>'*'"
				cQuery += "   AND SF4.F4_FILIAL   = '"+cFilialSF4+"'"
				cQuery += "   AND SF4.F4_CODIGO   = SD1.D1_TES"
				cQuery += "   AND SF4.D_E_L_E_T_<>'*' "
				cQuery += "ORDER BY "+SqlOrder(SD1->(IndexKey()))
				
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDev)
				
				lContinua := !(cAliasDev)->(Eof())
				For nCntFor := 1 To Len(aStruSD1)
					If ( aStruSD1[nCntFor][2]!= "C" )
						TcSetField(cAliasDev,aStruSD1[nCntFor][1],aStruSD1[nCntFor][2],aStruSD1[nCntFor][3],aStruSD1[nCntFor][4])
					EndIf
				Next nCntFor
				For nCntFor := 1 To Len(aStruSF4)
					If ( aStruSF4[nCntFor][2]!="C" )
						TcSetField(cAliasSF4,aStruSF4[nCntFor][1],aStruSF4[nCntFor][2],aStruSD1[nCntFor][3],aStruSF4[nCntFor][4])
					EndIf
				Next nCntFor
			Else
		#ENDIF	
			If (!MsSeek(cFilialSD1+SE1->E1_NUM+cSerie+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.))
				lContinua := .F.
			EndIf

			#IFDEF TOP
			EndIf	
			#ENDIF
		If ( lContinua )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calculo da comissao por item de nota fiscal 			     ³
			//³																 ³
			//³1)O Valor do icms s/ frete e adiciona ao campo F2_VALICM, por ³
			//³esta razao deve-se somar o vlr do icms dos itens e subtrair   ³
			//³do total de icms (F2_VALICM) para apurar-se o vlr icms s/frete³
			//³																 ³
			//³2)O mesmo ocorre para o valor do IPI sobre frete, Por esta ra-³
			//³zao e' calculado o valor do IPI sobre frete do item multipli- ³
			//³cando-se o valor do frete do item pelo % de ipi do item. 	 ³
			//³																 ³
			//³3)O Valor do Icms Retido pode nÆo estar no total da nota (F2_-³
			//³VALBRUT) por isto deve-se considerar o campo (D2_ICMSRET).	 ³
			//³																 ³
			//³4)O percentual da comissao dever ser considerado para cada i- ³
			//³tem de nota fiscal pois ela pode ser diferente entre eles. O  ³
			//³percentual gravado no E1_COMIS ‚ sempre um valor aproximado e ³
			//³nao deve ser considerado ser houver nota fiscal para o titulo.³
			//³																 ³
			//³5)A Base da Comissao ‚ o valor da mercadoria + o valor do ipi ³
			//³+ o valor das despesas acessorias +  o icms solidario. Como e'³
			//³por item deve-se conhece-lo pelo item a item.				 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotal	  := 0
			nFrete	  := (SF1->F1_FRETE + SF1->F1_SEGURO + SF1->F1_DESPESA)
			nIcmFrete  := 0
			nSF2IcmRet :=0
			While ( !Eof() .And. (cAliasDev)->D1_FILIAL == cFilialSD1 .And.;
					(cAliasDev)->D1_DOC 	 == SE1->E1_NUM .And.;
					(cAliasDev)->D1_SERIE	 == cSerie .And.;
					(cAliasDev)->D1_FORNECE  == SE1->E1_CLIENTE .And.;
					(cAliasDev)->D1_LOJA	 == SE1->E1_LOJA	)

				If Ascan(aSemNota,(cAliasDev)->D1_ITEM) ==0
					(cAliasDev)->(DbSkip())
					Loop
				EndIf

				If ( !lQuery )
					dbSelectArea("SF4")
					dbSetOrder(1)
					MsSeek(cFilialSF4+(cAliasDev)->D1_TES)
				Else
					If cPaisLoc<>"BRA"
						SD1->(DbGoto((cAliasDev)->SD1RECNO))
					Endif
				EndIf
				cVend := "1"

				cVendedor := SF1->F1_VEND1

				nImp := 0				
				If cPaisLoc <> "BRA"
					SA3->(DbSetOrder(1))
					SA3->(DbSeek(xFilial()+cVendedor))
					aImp := TesImpInf(SD1->D1_TES)			
					cImp := IIf(SA3->(FieldPos("A3_COMIMP")) >0,SA3->A3_COMIMP,"N")
					nPerComis := SA3->A3_COMIS
					For nX :=1 to Len(aImp)
						If (cImp+aImp[nX][3] == "S1")
							nImp += SD1->(FieldGet(FieldPos(aImp[nX][2])))
						ElseIf (cImp+aImp[nX][3] == "N2")
							nImp -= SD1->(FieldGet(FieldPos(aImp[nX][2]))	)
						Endif
					Next	
				EndIf

				If ( !Empty(cVendedor) .And. (cAliasSF4)->F4_DUPLIC == "S" )
					If (cAliasDev)->(FieldPos("D1_COMIS"+cVend)) > 0 .And.;
						(cAliasDev)->(FieldGet((cAliasDev)->(FieldPos("D1_COMIS"+cVend)))) > 0 
						nPerComis := (cAliasDev)->(FieldGet((cAliasDev)->(FieldPos("D1_COMIS"+cVend))))
					Endif
					aadd(aSD2Vend,{ cVendedor,;
						(cAliasDev)->D1_TOTAL+nImp,;
						0,;
						0,;
						0,;
						(cAliasSF4)->F4_INCIDE,;
						(cAliasSF4)->F4_IPIFRET,;
						0,;
						nPerComis,;
						0,;
						If(lQuery,(cAliasDev)->SD1RECNO,(cAliasDev)->(RecNo()))})
				EndIf

				nTotal	  += (cAliasDev)->D1_TOTAL
				dbSelectArea(cAliasDev)
				dbSkip()
			EndDo
			If ( lQuery )
				dbSelectArea(cAliasDev)
				dbCloseArea()
				dbSelectArea("SD1")
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calculo da comissao pela nota.							     ³
			//³																 ³
			//³1)Apos calculado as bases de cada vendedor por item de nota   ³
			//³deve-se aglutina-las formando uma unica base para toda a nota ³
			//³fiscal.														 ³
			//³																 ³
			//³2)Como os valores serao aglutinados pode-se haver perda de de-³
			//³cimais por isto deve-se haver um controle para que a perda se-³
			//³ja adicionada a primeira parcela da nota. 					 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nMaxFor := Len(aSD2Vend)
			nPerComis:=0
			For nCntFor := 1 To nMaxFor
				If ( lPeperCom )
					nPerComis := ExecBlock("FIN440PE",.F.,.F.,{aSD2Vend[nCntFor][1]})
					If ( ValType(nPerComis)<>"N" )
						nPerComis := aSD2Vend[nCntFor][9]
					EndIf
				EndIf
				If ( SE1->E1_PARCELA $ cPrimParc )
					nBaseDif  := NoRound(nFrete*(1-(aSD2Vend[nCntFor,2]/nTotal)),nDecimal+1)
					nBaseDif  := nFrete - nBaseDif
					nRatFrete := nBaseDif
				Else
					nRatFrete := NoRound(nFrete*aSD2Vend[nCntFor,2]/nTotal,nDecimal+1)
				EndIf
				nRatIcmFre:= 0
				nBaseSE1  := 0
				nPos		 := 0
				nRatIcmFre:= NoRound(nIcmFrete*aSD2Vend[nCntFor,2]/nTotal,nDecimal+1)
				nBaseSE1  := aSD2Vend[nCntFor,2]+aSD2Vend[nCntFor,4]+aSD2Vend[nCntFor,8]+nRatFrete
				dbSelectArea("SA3")
				dbSetOrder(1)
				MsSeek(xFilial()+aSD2Vend[nCntFor,1])

				nAlEmissao := SA3->A3_ALEMISS
				nAlBaixa := SA3->A3_ALBAIXA

				If ( SA3->A3_FRETE == "N" )
					nBaseSE1 -= ( nRatFrete )
				Endif
				
				If SA3->(FieldPos("A3_ACREFIN")) != 0  // Acrescimo Financeiro
					If ( SA3->A3_ACREFIN == "N" ) .and. aSD2Vend[nCntFor,10] > 0
						nBaseSE1 -= ( aSD2Vend[nCntFor,10] )
					EndIf
				Endif
				nPos := aScan(aBaseSE1,{|x| x[1] == aSD2Vend[nCntFor,1]})
				If Alltrim(SE1->E1_Hist) <> "VENDA EM DINHEIRO"
					nBaseBaix := Round(nBaseSE1*nAlBaixa/100,nDecimal+1) 	// Base da Comissao na Baixa
				Else
					nBaseBaix:= 0
				EndIf
				nBaseEmis := nBaseSE1-nBaseBaix											// Base da Comissao na Emissao
				nVlrEmis  := Round(nBaseEmis*aSD2Vend[nCntFor,9]/100,nDecimal+1) // Valor da Comissao na Emissao
				nVlrBaix  := Round(nBaseBaix*aSD2Vend[nCntFor,9]/100,nDecimal+1) // Valor da Comissao na Baixa
				If ( Empty(nRegDevol) .Or. nRegDevol == aSD2Vend[nCntFor,11] )
					If ( nPos == 0 )
						aadd(aBaseSE1,{ aSD2Vend[nCntFor,1] ,;
							nBaseSE1				,;
							nBaseEmis				,;
							nBaseBaix				,;
							nVlrEmis				,;
							nVlrBaix				,;
							nPerComis		,;
							nPis,;
							nCsll,;
							nCofins,;
							nIrrf})
					Else                	
						aBaseSE1[nPos,2] += nBaseSE1
						aBaseSE1[nPos,3] += nBaseEmis
						aBaseSE1[nPos,4] += nBaseBaix
						aBaseSE1[nPos,5] += nVlrEmis
						aBaseSE1[nPos,6] += nVlrBaix
						If aBaseSE1[nPos,7] == nPerComis
							aBaseSE1[nPos,7] := nPerComis
						Else
							aBaseSE1[nPos,7] := 0
						EndIf
					EndIf
				EndIf
			Next nCntFor
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calculo da comissao pelas parcelas.							 ³
			//³																 ³
			//³1)O SE3 ‚ gravado por parcela e nao pela nota. assim e'neces- ³
			//³ssario calcular a base da comissao para a parcela em questao. ³
			//³																 ³
			//³2)Aqui deve-se tomar o maximo cuidado com a Condi‡Æo de pagto ³
			//³pois se o Icms Solidario ou o Ipi for separado de alguma par- ³
			//³cela deve-se considera esta separacao para calcular-se a me-  ³
			//³lhor propor‡ao possivel para a base da parcela. 				 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nMaxFor := Len(aBaseSE1)
			For nCntFor := 1 To nMaxFor
				nProp   := 0
				nVlrFat := xMoeda(SF1->F1_VALBRUT,SE1->E1_MOEDA,1,SE1->E1_EMISSAO)
				nVlrTit := SE1->E1_VLCRUZ
				dbSelectArea("SA3")
				dbSetOrder(1)
				MsSeek(xFilial()+aBaseSE1[nCntFor,1])
				If ( nVlrTit > 0 )
					nProp := nVlrFat / nVlrTit
				Else
					nProp := 0
				EndIf
				If (nProp != 0 )
					nBaseSE1 := NoRound(aBaseSE1[nCntFor,2]/nProp,nDecimal+1)
					nBaseEmis:= NoRound(aBaseSE1[nCntFor,3]/nProp,nDecimal+1)
					nBaseBaix:= NoRound(aBaseSE1[nCntFor,4]/nProp,nDecimal+1)
					nVlrEmis := Round(aBaseSE1[nCntFor,5]/nProp,nDecimal+1)
					nVlrBaix := Round(aBaseSE1[nCntFor,6]/nProp,nDecimal+1)
				Else
					nBaseSE1 := 0
					nBaseEmis:= 0
					nBaseBaix:= 0
					nVlrEmis := 0
					nVlrBaix := 0
				EndIf
				If ( SE1->E1_PARCELA $ cPrimParc .And. nBaseSE1 != 0 )
					//--> Calculo da Proporcao para a Base da Comissao
					nBaseDif := Round(nBaseSE1 * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,2]-nBaseDif
					aBaseSE1[nCntFor,2] := nBaseSE1+nBaseDif
					//--> Calculo da Proporcao para a Base da Comissao pela Emissao

					nBaseDif := Round(nBaseEmis * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,3]-nBaseDif
					aBaseSE1[nCntFor,3] := nBaseEmis+nBaseDif
					//--> Calculo da Proporcao para a Base da Comissao pela Baixa

					nBaseDif := Round(nBaseBaix * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,4]-nBaseDif
					aBaseSE1[nCntFor,4] := nBaseBaix+nBaseDif
					//--> Calculo da Proporcao para o Valor da Comissao pela Emissao

					nBaseDif := Round(nVlrEmis * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,5]-nBaseDif
					aBaseSE1[nCntFor,5] := nVlrEmis+nBaseDif
					//--> Calculo da Proporcao para o Valor da Comissao pela Baixa

					nBaseDif := Round(nVlrBaix * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,6]-nBaseDif
					aBaseSE1[nCntFor,6] := nVlrBaix+nBaseDif
				Else
					aBaseSE1[nCntFor,2] := nBaseSE1
					aBaseSE1[nCntFor,3] := nBaseEmis
					aBaseSE1[nCntFor,4] := nBaseBaix
					aBaseSE1[nCntFor,5] := nVlrEmis
					aBaseSE1[nCntFor,6] := nVlrBaix
				EndIf
			Next nCntFor
		Else
			If ( lQuery .And. Select(cAliasDev)<>0 )
				dbSelectArea(cAliasDev)
				dbCloseArea()
				dbSelectArea("SE1")
			EndIf
		EndIf
	Endif	
	If ( lQuery .And. Select(cAliasDev)<>0 )
		dbSelectArea(cAliasDev)
		dbCloseArea()
		dbSelectArea("SE1")
	EndIf
	If ( lQuery )
		dbSelectArea(cAliasSD1)
		dbCloseArea()
		dbSelectArea("SD1")
	EndIf
Else
	If Empty(nRegDevol)
		If ( Empty(aBaseSE1) .And. lRefaz )
			cVend := "1"
			For nCntFor := 1 To nVend
				nIRRF := 0
				SE1->(dbGoto(nRecnoOrig)) // pra caso o titulo parta de uma liquidação
				cVendedor := SE1->(FieldGet(SE1->(FieldPos("E1_VEND"+cVend))))
				nPerComis := SE1->(FieldGet(SE1->(FieldPos("E1_COMIS"+cVend))))

				dbSelectArea("SE3")
				dbSetOrder(1)
				If DbSeek(XFilial("SE3")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA) 

					// Verifica se o tipo da comissao bate com o tipo do titulo. Pode ocorrer dois titulos 
					// com o mesmo prefixo/numero/parcela/cliente/loja com tipos diferentes
					Do While 	SE3->( ! EoF() ) .And. ;
								SE3->( xFilial( "SE3" ) + E3_PREFIXO + E3_NUM + E3_PARCELA ) == ;
								SE1->( xFilial( "SE1" ) + E1_PREFIXO + E1_NUM + E1_PARCELA )
						If SE3->E3_TIPO == SE1->E1_TIPO .And.  SE1->(FieldGet(SE1->(FieldPos("E1_VEND"+cVend)))) ==  SE3->E3_VEND
							nPerComis := SE3->E3_PORC
							Exit
						EndIf
						SE3->( dbSkip() )
					EndDo

	            EndIf

	            MsUnLock()
				
				SE1->(dbGoto(nRegistro)) // volta ao recno original
				
				dbSelectArea("SA3")
				dbSetOrder(1)
				MsSeek(xFilial("SA3")+cVendedor)
				lCOMISIR := IIf( SA3->(FieldPos("A3_BASEIR"))<>0 , SA3->A3_BASEIR != "2" , lCOMISIR )
				
				If SE1->(FieldPos("E1_ALEMIS"+cVend))<>0//Nao criar no dicionario padrao
					nAlEmissao := SE1->(FieldGet(FieldPos("E1_ALEMIS"+cVend)))
				Else
					nAlEmissao := SA3->A3_ALEMISS
				EndIf
				If SE1->(FieldPos("E1_ALBAIX"+cVend))<>0//Nao criar no dicionario padrao
					nAlBaixa := SE1->(FieldGet(FieldPos("E1_ALBAIX"+cVend)))
				Else
					nAlBaixa := SA3->A3_ALBAIXA
				EndIf
	
				If ( !Empty(cVendedor) ) .and. !SE1->E1_TIPO $ MVABATIM
					If ( Alltrim(SE1->E1_Hist) <> "VENDA EM DINHEIRO" .AND. !"LOJA"$SE1->E1_ORIGEM ) .OR.;		 //	 - Comissoes
						( Alltrim(SE1->E1_Hist) == "VENDA EM DINHEIRO" .AND. (("LOJA"$SE1->E1_ORIGEM) .OR. "FATA701"$ SE1->E1_ORIGEM)) 
						If lMultVend .OR. (("LOJA"$SE1->E1_ORIGEM) .OR. ("FATA701"$ SE1->E1_ORIGEM))
							nBaseEmis := Round(SE1->(FieldGet(SE1->(FieldPos("E1_BASCOM"+cVend))))*(nAlEmissao/100),nDecimal+1)
							nBaseBaix := Round(SE1->(FieldGet(SE1->(FieldPos("E1_BASCOM"+cVend))))*(nAlBaixa/100),nDecimal+1)
						Else
							nBaseEmis := Round(SE1->E1_VLCRUZ*(nAlEmissao/100),nDecimal+1)
							nBaseBaix := Round(SE1->E1_VLCRUZ*(nAlBaixa/100),nDecimal+1)
						
							If lF440BasEm
								nF440BasEm := Round(IIF(SE1->E1_BASCOM1 > 0, SE1->E1_BASCOM1, SE1->E1_VLCRUZ)*(nAlEmissao/100),nDecimal+1)
								If nBaseEmis <= 0
									lF440BasEm := .F.	
								EndIf  									
							EndIf
						EndIf
					Else
						nBaseEmis := SE1->(FieldGet(SE1->(FieldPos("E1_BASCOM"+cVend))))
						nBaseBaix := nBaseEmis
						If "LOJA"$SE1->E1_ORIGEM .AND. Alltrim(SE1->E1_Hist) <> "VENDA EM DINHEIRO"

							If nAlEmissao > 0
								nBaseEmis := Round( nBaseEmis * ( nAlEmissao / 100 ), nDecimal+1 )
								nBaseBaix := 0
							ElseIf nAlBaixa > 0
								nBaseEmis := 0
								nBaseBaix := Round( nBaseBaix * ( nAlBaixa / 100 ), nDecimal+1 )
							Endif
						Endif
					Endif
					
					// IRRF
					If lCOMISIR .And. lRecIRRF
						If !lIrPjBxCr .And. lCalEmis							
							nBaseEmis -= IIF(nAlEmissao > 0 .And. nAlBaixa > 0,; 
													Iif(nBaseEmis > 0, Round((Round(SE1->E1_IRRF,nDecimal+1)) * ( nAlEmissao / 100 ), nDecimal+1 ), 0),;
													Iif(nBaseEmis > 0, Round(SE1->E1_IRRF,nDecimal+1), 0))							
						ElseIf lIrPjBxCr 
							nBaseBaix -= IIF(nAlEmissao > 0 .And. nAlBaixa > 0,; 
													Iif(nBaseBaix > 0, Round((Round(SE1->E1_IRRF,nDecimal+1)) * (nAlBaixa / 100 ), nDecimal+1 ), 0),;
													Iif(nBaseBaix > 0, Round(SE1->E1_IRRF,nDecimal+1), 0))							 
						Endif
					EndIf
					
					// IRRF da BAIXA - FATOR DE PROPORCIONALIZAÇÃO
					If lIrPjBxCr .And. !lCalEmis 
						If !(SE5->E5_PRETIRF	$"1;2")
							nIRRF	:= SE5->E5_VRETIRF
						Else
							nIRRF	:= 0
						EndIf
					EndIf
					
					// INSS
					If lCOMISIN
						nBaseEmis -= IIF(nAlEmissao > 0 .And. nAlBaixa > 0,;
												Iif(nBaseEmis > 0, Round((Round(SE1->E1_INSS,nDecimal+1)) * ( nAlEmissao / 100 ), nDecimal+1), 0),;							
												Iif(nBaseEmis > 0, Round(SE1->E1_INSS,nDecimal+1), 0))
						
					EndIf
					
					// PIS, COFINS, CSLL
					If lCOMIPIS						
						If lPccBxCr
							nBaseBaix -= IIF(nAlEmissao > 0 .And. nAlBaixa > 0,;
													Iif(nBaseBaix > 0, Round((Round(SE1->E1_PIS,nDecimal+1)) * ( nAlBaixa / 100 ), nDecimal+1), 0),;													
													Iif(nBaseBaix > 0, Round(SE1->E1_PIS,nDecimal+1), 0)) 	
						Else
							nBaseEmis -= IIF(nAlEmissao > 0 .And. nAlBaixa > 0,;
													Iif(nBaseEmis > 0, Round((Round(SE1->E1_PIS,nDecimal+1)) * ( nAlEmissao / 100 ), nDecimal+1), 0),;							
													Iif(nBaseEmis > 0, Round(SE1->E1_PIS,nDecimal+1), 0))
						EndIf
					EndIf
					
					If lCOMICOF
						If lPccBxCr
							nBaseBaix -= IIF(nAlEmissao > 0 .And. nAlBaixa > 0,;													
													Iif(nBaseBaix > 0, Round((Round(SE1->E1_COFINS,nDecimal+1)) * ( nAlBaixa / 100 ), nDecimal+1), 0),;													
													Iif(nBaseBaix > 0, Round(SE1->E1_COFINS,nDecimal+1), 0))
						Else					
							nBaseEmis -= IIF(nAlEmissao > 0 .And. nAlBaixa > 0,;
													Iif(nBaseEmis > 0, Round((Round(SE1->E1_COFINS,nDecimal+1)) * ( nAlEmissao / 100 ), nDecimal+1), 0),;
													Iif(nBaseEmis > 0, Round(SE1->E1_COFINS,nDecimal+1), 0))							
						EndIf
					EndIf
					
					If lCOMICSL
						If lPccBxCr
							nBaseBaix -= IIF(nAlEmissao > 0 .And. nAlBaixa > 0,;													
													Iif(nBaseBaix > 0, Round((Round(SE1->E1_CSLL,nDecimal+1)) * ( nAlBaixa / 100 ), nDecimal+1), 0),;													
													Iif(nBaseBaix > 0, Round(SE1->E1_CSLL,nDecimal+1), 0))
						Else					
							nBaseEmis -= Iif(nAlEmissao > 0 .And. nAlBaixa > 0,;
													Iif(nBaseEmis > 0, Round((Round(SE1->E1_CSLL,nDecimal+1)) * ( nAlEmissao / 100 ), nDecimal+1), 0),;
													Iif(nBaseEmis > 0, Round(SE1->E1_CSLL,nDecimal+1), 0))							
						EndIf
					EndIf
						
					// PCC da BAIXA - FATOR DE PROPORCIONALIZAÇÃO
					If lPccBxCr .and. !lCalEmis
						If !(SE5->E5_PRETPIS	$	"1;2")
						 	nPis	:= SE5->E5_VRETPIS
						Else
						 	nPis	:=	0
						EndIf
						If !(SE5->E5_PRETCOF	$	"1;2")
							nCofins	:= SE5->E5_VRETCOF
						Else
							nCofins	:= 0
						EndIf
						If !(SE5->E5_PRETCSL	$	"1;2")
							nCsll	:= SE5->E5_VRETCSL
						Else
							nCsll	:=	0
						EndIf
					Endif
					
					// ISS
					If ( SA3->A3_ISS == "N" ) 				                              
						nValISS := IIF(lCalcIssBx,SE5->E5_VRETISS,SE1->E1_ISS)
						//Se o valor do ISS calculado for inferior ao minimo de retencao (MV_VRETISS), nao descontar da base de comissao
						If SuperGetMV("MV_VRETISS",.F.,0) < if(!Empty(aSD2Vend),aSD2Vend[nCntFor,3],nValISS)
							nBaseEmis -= Round(SE1->E1_ISS*(nAlEmissao/100),nDecimal+1)
							nBaseBaix -= Round(SE1->E1_ISS*(nAlBaixa/100),nDecimal+1)
						EndIf
					EndIf																	
		  
				    If ((!lComiLiq .and. IsInCallStack("FINA040")) .or. lLoja .or. (cFunName$ "FINA440|FATA701" .and. Empty(SE1->E1_NUMLIQ)))
					     nVlrEmis  := Round(nBaseEmis * (nPerComis/100),nDecimal+1)
					     nVlrBaix  := Round(nBaseBaix * (nPerComis/100),nDecimal+1)   
				    Else 
					     nVlrEmis  := 0
					     nVlrBaix  := Round(nBaseBaix * (nPerComis/100),nDecimal+1) 
				    Endif  
				    
				    If (lComiliq)
					    nVlrEmis  := Round(nBaseEmis * (nPerComis/100),nDecimal+1)
					    nVlrBaix  := Round(nBaseBaix * (nPerComis/100),nDecimal+1)
				    Endif
					
					// --> quer dizer que já comissionou na liquidacao do titulo original
					If ( lComiLiq ) .and. !Empty(SE1->E1_NUMLIQ) 
						IF IsInCallStack("FA460CAN") .or. ( cFunName == "FINA460" )
						// Se "comiliq", considero comissao como se fosse na baixa e nao na emissao
							nVlrEmis := nVlrBaix
							nBaseEmis:= nBaseBaix
						Elseif !( cFunName == "FINA460" )
							nVlrBaix  	:= 0
							nBaseBaix	:= 0
						Endif
					Endif
										
					aadd(aBaseSE1,{ cVendedor,;
						SE1-> E1_VLCRUZ,;
						nBaseEmis ,;
						nBaseBaix ,;
						nVlrEmis  ,;
						nVlrBaix  ,;
						nPerComis ,;
						nPis      ,;
						nCsll     ,;
						nCofins   ,;
						nIRRF     })
				EndIf
				cVend := Soma1(cVend,1)
			Next nCntFor
		EndIf
		If ( lGrava .And. lRefaz ).AND. !"LOJA"$SE1->E1_ORIGEM
			dbSelectArea("SE1")
			RecLock("SE1")
			cVend := "1"
			For nCntFor := 1 To Len(aBaseSE1)
				dbSelectArea("SA3")
				dbSetOrder(1)
				MsSeek(xFilial("SA3")+aBaseSE1[nCntFor,1])
				dbSelectArea("SE1")
				If ( FieldGet(FieldPos("E1_VEND"+cVend)) == aBaseSE1[nCntFor,1] )
					FieldPut(FieldPos("E1_BASCOM"+cVend), IIF(lF440BasEm, nF440BasEm, aBaseSE1[nCntFor,2]))
					If ( aBaseSE1[nCntFor,3] != 0 .Or. aBaseSE1[nCntFor,4] != 0 )
						FieldPut(FieldPos("E1_COMIS"+cVend),aBaseSE1[nCntFor,7])
					Endif
					FieldPut(FieldPos("E1_VALCOM"+cVend),aBaseSE1[nCntFor,5])
					If cPaisLoc == "PTG" .And. SFC->(FieldPos("FC_ABATCOM")) > 0
			   			FieldPut(FieldPos("E1_BASCOM"+cVend),aBaseSE1[nCntFor,12])			   			
			   			FieldPut(FieldPos("E1_VALCOM"+cVend),aBaseSE1[nCntFor,11])	
					EndIf
				Else
					If ( SE1->(FieldPos("E1_VEND"+cVend)) != 0 )
						nCntFor--	
					EndIf
				EndIf
				cVend := Soma1(cVend,1)
			Next nCntFor
			MsUnlock()
		EndIf
		If ( Empty(aBaseSE1) )
			cVend := "1"
			For nCntFor := 1 To nVend
				nIRRF := 0
				cVendedor := SE1->(FieldGet(SE1->(FieldPos("E1_VEND"+cVend))))
				nPerComis := SE1->(FieldGet(SE1->(FieldPos("E1_COMIS"+cVend))))
				dbSelectArea("SA3")
				dbSetOrder(1)
				MsSeek(xFilial("SA3")+cVendedor)
				lCOMISIR := IIf( SA3->(FieldPos("A3_BASEIR"))<>0 , SA3->A3_BASEIR == "1" , lCOMISIR )
				
				If ( !Empty(cVendedor) )                                    
					//Trazer a base gravada na emissao, substituindo o zero, para evitar valores negativos
					If SA3->A3_ALBAIXA > 0
						nBaseSE1  := SE1->(FieldGet(FieldPos("E1_BASCOM" + "1"))) * (SA3->A3_ALBAIXA / 100)
						nBaseEmis := SE1->(FieldGet(FieldPos("E1_BASCOM" + "1"))) - (SE1->(FieldGet(FieldPos("E1_BASCOM" + "1"))) * (SA3->A3_ALBAIXA / 100))
						nBaseBaix := SE1->(FieldGet(SE1->(FieldPos("E1_BASCOM"+cVend)))) * (SA3->A3_ALBAIXA / 100)
						nVlrEmis  := SE1->(FieldGet(FieldPos("E1_BASCOM" + "1"))) - (SE1->(FieldGet(FieldPos("E1_BASCOM" + "1"))) * (SA3->A3_ALBAIXA / 100))
					Else
						nBaseSE1  := SE1->(FieldGet(FieldPos("E1_BASCOM" + "1")))
						nBaseEmis := 0
						nBaseBaix := SE1->(FieldGet(SE1->(FieldPos("E1_BASCOM"+cVend)))) * (SA3->A3_ALBAIXA / 100)
						nVlrEmis  := 0
					EndIf						
					// --> Quando o percentual da comissao estiver no produto o sistema
					// --> arredonda o percentual se for pago na baixa, caso haja muita
					// --> distorcao de valores deve-se alterar o numero de casas
					// --> decimais do campo E1_COMIS1..E1_COMIS(n)

					// PIS, COFINS, CSLL
					If lCOMIPIS .and. !lMata460
						nBaseSE1 -= SE1->E1_PIS
						nBaseEmis -= Round(SE1->E1_PIS,nDecimal+1)
						nBaseBaix -= Round(SE1->E1_PIS,nDecimal+1)
					EndIf
					If lCOMICOF .and. !lMata460
						nBaseSE1 -= SE1->E1_COFINS
						nBaseEmis -= Round(SE1->E1_COFINS,nDecimal+1)
						nBaseBaix -= Round(SE1->E1_COFINS,nDecimal+1)
					EndIf
					If lCOMICSL .and. !lMata460
						nBaseSE1 -= SE1->E1_CSLL
						nBaseEmis -= Round(SE1->E1_CSLL,nDecimal+1)
						nBaseBaix -= Round(SE1->E1_CSLL,nDecimal+1)
					EndIf
					
					// IRRF
					If lCOMISIR .and. !lMata460
						nBaseBaix -= Round(SE1->E1_IRRF,nDecimal+1)
					EndIf
											
					If lCOMISIR .and. !lMata460
						nBaseSE1 -= Round(SE1->E1_IRRF,nDecimal+1)
						nBaseEmis -= Round(SE1->E1_IRRF,nDecimal+1)
						nBaseBaix -= Round(SE1->E1_IRRF,nDecimal+1)
					EndIf

					// PCC da BAIXA - FATOR DE PROPORCIONALIZAÇÃO
					If lPccBxCr .And. !lCalEmis
						If !(SE5->E5_PRETPIS $	"1;2")
							nPis	:= SE5->E5_VRETPIS
						Else
							nPis	:=	0
						EndIf
						If !(SE5->E5_PRETCOF	$	"1;2")
							nCofins	:= SE5->E5_VRETCOF
						Else
							nCofins	:= 0
						EndIf											 
						If !(SE5->E5_PRETCSL $	"1;2")
							nCsll	:= SE5->E5_VRETCSL
						Else
							nCsll	:=	0
						EndIf
					EndIf
					
					// IRRF da BAIXA - FATOR DE PROPORCIONALIZAÇÃO 
					If lIrPjBxCr .and. !lCalEmis
						If !(SE5->E5_PRETIRF	$"1;2")
							nIRRF	:= SE5->E5_VRETIRF
						Else
							nIRRF	:= 0
						EndIf
					EndIf

					If GetNewPar("MV_COMIINS","N") == "N" .and. !lMata460
						nBaseSE1 -= SE1->E1_INSS     
						nBaseBaix -= SE1->E1_INSS    						
					EndIf
					// ISS
					If ( SA3->A3_ISS == "N" ) 				                              
						nValISS := IIF(lCalcIssBx,SE5->E5_VRETISS,SE1->E1_ISS)
						//Se o valor do ISS calculado for inferior ao minimo de retencao (MV_VRETISS), nao descontar da base de comissao
						If SuperGetMV("MV_VRETISS",.F.,0) < if(!Empty(aSD2Vend),aSD2Vend[nCntFor,3],nValISS)
							nBaseEmis -= Round(SE1->E1_ISS*(SA3->A3_ALEMISS/100),nDecimal+1)
							nBaseBaix -= Round(SE1->E1_ISS*(SA3->A3_ALBAIXA/100),nDecimal+1)
						EndIf
					EndIf																	
					
					nVlrBaix  := nBaseBaix * (nPerComis/100)
					//No segundo elemento, a variavel nBaseSE1 foi substituida pelo campo SE1->E1_VLCRUZ (base bruta), pois apenas passava valores
					//negativos
					aadd(aBaseSE1,{ cVendedor,;
						SE1->E1_VLCRUZ,;
						nBaseEmis,;
						nBaseBaix,;
						nVlrEmis,;
						nVlrBaix,;
						nPerComis,;
						nPis		,;
						nCsll		,;
						nCofins, ;
						nIRRF})
				EndIf
				cVend := Soma1(cVend,1)
			Next nCntFor
		EndIf
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a Integridade dos dados de Entrada                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAreaSE1)
RestArea(aAreaSE4)
RestArea(aAreaSF1)
RestArea(aAreaSF2)
RestArea(aAreaSF4)
RestArea(aAreaSD1)
RestArea(aAreaSD2) 
RestArea(aAreaSA1)
RestArea(aAreaSA3)
RestArea(aArea)

Return(aBaseSE1)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FA440CntVe³ Autor ³ Eduardo Riera         ³ Data ³ 16/12/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de Contagem do Numero de Vendedores Utilizados.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Numero de Vendedores                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA440                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fa440CntVen()

Local cCnt     := "1"
Local aStruct  := {} 
Local lContinua:= .T.
Static nVend

If ( Empty(nVend) )
	nVend := 0
	aStruct := SE1->(dbStruct())
	While ( lContinua )
		If ( aScan(aStruct,{|x| Trim(x[1]) == "E1_VEND"+cCnt}) != 0 )
			nVend++
			cCnt := Soma1(cCnt,1)
		Else
			lContinua := .F.
		EndIf
	EndDo
	nVend := Max(nVend,5)
EndIf
Return(nVend)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FA440Orige³ Autor ³Eduardo Riera          ³ Data ³05.08.98  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o Codigo de Origem do SE3                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpC1 := Origem do SE3                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Programa de Chamada                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA440Origem(cOrigem)

Local cRetorno := ""
cOrigem := AllTrim(cOrigem)
Do Case
Case cOrigem $ "FINA040#FINA280"
	cRetorno := "E" //Emissao Financeiro
Case cOrigem $ "FINA070#FINA330#FINA110#FINA087A"
	cRetorno := "B" //Baixa Financeiro
Case cOrigem $ "MATA460#MATA520#MATA467N#MATA465N#MATA468N"
	cRetorno := "F" //Faturamento
Case cOrigem $ "MATA100"
	cRetorno := "D" //Devolucao de Venda
Case cOrigem $ "FINA440"
	cRetorno := "R" //Recalculo quando nao ha origem
Case cOrigem $ "LOJA010#LOJA020#LOJA220#LOJA701#FRTA010#FATA701"
	cRetorno := "L" //SigaLoja
OtherWise
	cRetorno := " " //Desconhecido
EndCase
Return(cRetorno)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ComisBx   ³ Autor ³ Andreia Santos        ³ Data ³ 25/11/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Responde com T ou F se uma comiss„o ser  considerada        ³±±
±±³Descri‡„o ³em fun‡„o de uma baixa                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ComixBx(ExpC1) - Motivo de uma baixa                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ComisBx( cMotBx )
LOCAL nPos,lRet := .F.
Local aMotBx := ReadMotBx()
 nPos := Ascan(aMotBx, {|x| Substr(x,1,3) == Upper(cMotBx) })
If nPos > 0
	lRet := Iif(Substr(aMotBx[nPos],26,1) == "S",.T.,.F.)
Endif
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³F440Loja  ³ Autor ³ Wagner Xavier         ³ Data ³ 05/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Responde com T ou F se uma comiss„o foi gerada pelo SIGALOJA³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³F440LOja(ExpC1) - Sufixo (SE1 ou SE5)							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³Generico																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function f440Loja(cArquivo,cAlias)
Local aArea := GetArea()
LOCAL lRet := .F.

If cArquivo == "SE1"
	dbSelectArea("SL1")
	dbSetOrder(2)	
	If MsSeek(xFilial(cAlias)+(cAlias)->E1_SERIE+(cAlias)->E1_NUM)
		lRet := .T.
	Endif
Else
	If (cAlias)->E5_TIPODOC == "LJ"
		lRet := .T.
	Else	
		dbSelectArea("SL1")
		dbSetOrder(2)
		If MsSeek(xFilial(cAlias)+(cAlias)->E5_PREFIXO+(cAlias)->E5_NUMERO)
			lRet := .T.
		Endif
	Endif
	
	//se for um titulo de CC/CD gerado pelo SIGALOJA, a comissao só deverá ser gerada pelo LOJA440, pois senão haverá duas comissões para a mesma venda
	If !lRet
		dbSelectArea("SE1")
		SE1->( dbSetOrder(1) )	//E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO
		If MsSeek( xFilial("SE1") + (cAlias)->E5_PREFIXO + (cAlias)->E5_NUMERO + (cAlias)->E5_PARCELA + (cAlias)->E5_TIPO )
			If AllTrim(SE1->E1_ORIGEM) $ "LOJA701#FATA701" .AND. AllTrim(SE1->E1_TIPO) $ "CC|CD"
				lRet := .T.	
			EndIf			
		Endif
	EndIf
	
Endif
RestArea(aArea)
Return lRet			


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FA440LIQSE³ Autor ³Eduardo Riera          ³ Data ³21.11.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna um array dos titulos de origem                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Codigo da Liquidacao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³08/12/2008³ FELIPE A.MELO ³Ajuste para localizar titulos de faturas    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa440LiqSe1(cNumLiq,aLiquid,aValLiq,aSeqCont,cNumFat,cFatPref,aTitFat)

Local nPosLiq 
Local aArea    := GetArea()
Local cAliasSE5:= "SE5"
Local lQuery   := .F.
Local aAreaSE1 := SE1->(GetArea())
Local aAreaSE5 := SE5->(GetArea())
Local cCmdSeek := ""     
Local cEstrutPesq := ""  
Local lRelat   := IsInCallStack("MATR540")
#IFDEF TOP
	Local nX       := 0
	Local aStruSE5 := {}
	Local cQuery   := ""
#ENDIF	

DEFAULT aLiquid  := {}
DEFAULT aValLiq  := {}
DEFAULT aSeqCont := {}
DEFAULT cNumFat  := ""
DEFAULT cFatPref := ""
DEFAULT aTitFat := {}

If Select("__SE1") == 0
	ChkFile("SE1",.F.,"__SE1")
Endif

dbSelectArea("SE5")
dbSetOrder(10)
#IFDEF TOP
	lQuery := .T.
	aStruSE5 := SE5->(dbStruct())
	cAliasSE5 := GetNextAlias()
	cQuery := "SELECT E5_FILIAL, E5_MOTBX,   E5_DOCUMEN, E5_CLIFOR, E5_LOJA, E5_PREFIXO, E5_NUMERO, E5_PARCELA, "
	cQuery += "       E5_TIPO,   E5_SITUACA, E5_DATA,    E5_VALOR,  E5_SEQ,  E5_FATPREF, E5_FATURA "
	If lRelat
		cQuery += ",E5_TIPODOC "
	EndIf
	cQuery += "  FROM "+RetSqlName("SE5")+" SE5 "
	cQuery += " WHERE SE5.E5_FILIAL='"+xFilial("SE5")+"' AND "
	If !Empty(cNumLiq)
		cQuery += "SE5.E5_DOCUMEN='"+cNumLiq+"' AND "
		cQuery += "SE5.E5_MOTBX = 'LIQ' AND "
	EndIf
	If !Empty(cNumFat) .And. !Empty(cFatPref)
		cQuery += "SE5.E5_FATURA = '"+cNumFat+"' AND "
		cQuery += "SE5.E5_FATPREF = '"+cFatPref+"' AND "
		cQuery += "SE5.E5_MOTBX = 'FAT' AND "
	EndIf

	cQuery += "SE5.E5_SITUACA <> 'C' AND "
	cQuery += "SE5.D_E_L_E_T_=' ' "
		
	cQuery := ChangeQuery(cQuery)
		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE5)
		
	For nX := 1 To Len(aStruSE5)
		If aStruSE5[nX][2]<>"C" .And. FieldPos(aStruSE5[nX][1])<>0
			TcSetField(cAliasSE5,aStruSE5[nX][1],aStruSE5[nX][2],aStruSE5[nX][3],aStruSE5[nX][4])
		EndIf
	Next nX
#ELSE
	MsSeek(xFilial("SE5")+cNumLiq,.F.)
#ENDIF
While ( !Eof() .And. xFilial("SE5") == (cAliasSE5)->E5_FILIAL .And.;
		SubStr((cAliasSE5)->E5_DOCUMEN,1,Len(cNumLiq)) == cNumLiq )
	If (cAliasSE5)->E5_MOTBX == IIf(!Empty(cNumLiq),"LIQ","FAT") .and. (cAliasSE5)->E5_SITUACA != "C"
		dbSelectArea("__SE1") // Pesquisa no SE1 sem o filtro
		If !Empty(cNumLiq)
			dbSetOrder(2)
			cCmdSeek := xFilial("SE1")+(cAliasSE5)->E5_CLIFOR+(cAliasSE5)->E5_LOJA+(cAliasSE5)->E5_PREFIXO+(cAliasSE5)->E5_NUMERO+(cAliasSE5)->E5_PARCELA+(cAliasSE5)->E5_TIPO
			cEstrutPesq := "xFilial('SE1')+__SE1->E1_CLIENTE+__SE1->E1_LOJA+__SE1->E1_PREFIXO+__SE1->E1_NUM+__SE1->E1_PARCELA+__SE1->E1_TIPO"
		Else
			dbSetOrder(10)
			cCmdSeek := xFilial("SE1")+(cAliasSE5)->E5_CLIFOR+(cAliasSE5)->E5_LOJA+(cAliasSE5)->E5_FATPREF+(cAliasSE5)->E5_FATURA
			cEstrutPesq := "xFilial('SE1')+__SE1->E1_CLIENTE+__SE1->E1_LOJA+__SE1->E1_FATPREF+__SE1->E1_FATURA"
		EndIf
		If MsSeek(cCmdSeek)									
			Do While !Eof() .And. &cEstrutPesq == cCmdSeek				
				If Empty(__SE1->E1_NUMLIQ) .And. Empty(__SE1->E1_BCOCHQ) .And. !Empty(cNumLiq) .And. Empty(__SE1->E1_FATURA)
					nPosLiq := aScan(aLiquid, __SE1->(RecNo()))
					If nPosLiq == 0
						aadd(aLiquid,__SE1->(RecNo()))
						If lRelat
							aAdd(aValLiq,{(cAliasSE5)->E5_DATA,IIf((cAliasSE5)->E5_TIPODOC # "JR",(cAliasSE5)->E5_VALOR,0)})
						Else
							aAdd(aValLiq,{(cAliasSE5)->E5_DATA,(cAliasSE5)->E5_VALOR})						
						EndIf
						aAdd(aSeqCont,(cAliasSE5)->E5_SEQ)
									   																								
						ElseIf Len(aValLiq) > 0 .AND. Len(aValLiq) >= nPosLiq    
							aValLiq[nPosLiq][1]:=(cAliasSE5)->E5_DATA
							aValLiq[nPosLiq][2]+=(cAliasSE5)->E5_VALOR
					Else
						aAdd(aValLiq,{(cAliasSE5)->E5_DATA,(cAliasSE5)->E5_VALOR})
					EndIf	   
					
				ElseIf !Empty(__SE1->E1_FATPREF) .And. !Empty(__SE1->E1_FATURA) .And. Empty(cNumLiq)
					nPosLiq := aScan(aLiquid, __SE1->(RecNo()))
					If nPosLiq == 0
						aadd(aLiquid,__SE1->(RecNo()))
						aAdd(aValLiq,{(cAliasSE5)->E5_DATA,(cAliasSE5)->E5_VALOR})
						aAdd(aSeqCont,(cAliasSE5)->E5_SEQ)
						aAdd(aTitFat,{__SE1->(RecNo()),__SE1->E1_VLCRUZ, __SE1->E1_FATPREF, __SE1->E1_FATURA } )
					Endif				
				ElseIf __SE1->E1_NUMLIQ == cNumLiq .And. __SE1->E1_STATUS == "R" //Reliquidacoes anteriores a versao 811
					Exit				
				Else
					If __SE1->E1_NUMLIQ == cNumLiq
						CONOUT("Erro Titulo : "+__SE1->E1_PREFIXO+__SE1->E1_NUM+__SE1->E1_PARCELA+__SE1->E1_TIPO)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza o log de processamento com o erro  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						ProcLogAtu("ERRO","ERRO_LIQUIDACAO","Erro no processamento de liquidação titulo : "+__SE1->E1_PREFIXO+__SE1->E1_NUM+__SE1->E1_PARCELA+__SE1->E1_TIPO)
					Else
						If !Empty(__SE1->E1_NUMLIQ)
							Fa440LiqSe1(__SE1->E1_NUMLIQ,@aLiquid,@aValLiq,@aSeqCont)
						ElseIf !Empty(__SE1->E1_FATURA)
							Fa440LiqSe1(__SE1->E1_NUMLIQ,@aLiquid,@aValLiq,@aSeqCont,__SE1->E1_NUM,__SE1->E1_PREFIXO, @aTitFat)
						EndIf
					EndIf
				EndIf
			    
			    __SE1->(dbSkip())			
			
			EndDo  
			If __SE1->E1_NUMLIQ == cNumLiq .And. __SE1->E1_STATUS == "R" //Reliquidacoes anteriores a versao 811
				Exit				
			Endif									
		EndIf
	EndIf
	dbSelectArea(cAliasSE5)
	dbSkip()
EndDo
If lQuery
	dbSelectArea(cAliasSE5)
	dbCloseArea()
	dbSelectArea("SE5")
EndIf
RestArea(aAreaSE1)                           
RestArea(aAreaSE5)
RestArea(aArea)
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ChkAbtImp ³ Autor ³ Edson Maricate        ³ Data ³13/01/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Soma titulos de abatimento relacionado aos impostos         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ChkAbtImp()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Prefixo,Numero,Parcela,Moeda,Saldo ou Valor,Data            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³FINA440                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ChkAbtImp(cPrefixo,cNumero,cParcela,nMoeda,cCpo,dData)

Local cAlias:=Alias()
Local nRec:=RecNo()
Local nTotAbImp := 0

dData :=IIF(dData==NIL,dDataBase,dData)
nMoeda:=IIF(nMoeda==NIL,1,nMoeda)

cCampo	:= IIF( cCpo == "V", "E1_VALOR" , "E1_SALDO" )

If Select("__SE1") == 0
	ChkFile("SE1",.F.,"__SE1")
Else
	dbSelectArea("__SE1")
Endif

dbSetOrder( 1 )
dbSeek( xFilial("SE1")+cPrefixo+cNumero+cParcela )

While !Eof() .And. E1_FILIAL == xFilial("SE1") .And. E1_PREFIXO == cPrefixo .And.;
		E1_NUM == cNumero .And. E1_PARCELA == cParcela
	If E1_TIPO != 'AB-' .And. E1_TIPO $ MVCSABT+"/"+MVCFABT+"/"+MVPIABT
		nTotAbImp +=xMoeda(&cCampo,E1_MOEDA, nMoeda,dData) 
	Endif
	dbSkip()
Enddo

dbSetOrder( 1 )

dbSelectArea( cAlias )
dbGoTo( nRec )                     

Return ( nTotAbImp )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSx1    ³ Autor ³ Ricardo A. Canteras	³ Data ³ 03/04/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Insere novas perguntas ao SX1    							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINA440                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()

Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {} 
Local cKey  := ""
Local aArea := GetArea()
Local aAreaSX1 := SX1->( GetArea() )


Aadd( aHelpPor, 'Caso o cálculo da comissão esteja      ')
Aadd( aHelpPor, 'sendo feito pela baixa, selecione se o ')
Aadd( aHelpPor, 'sistema deve considerar a Data de Baixa')
Aadd( aHelpPor, '(E5_DATA) ou a Data de Disponibilidade ') 
Aadd( aHelpPor, '(E5_DTDISPO) para os cálculos.         ')  

Aadd( aHelpSpa, 'Si la comisón si esta efectuando en la ')
Aadd( aHelpSpa, 'cancelación, para el calculo de los    ')
Aadd( aHelpSpa, 'valores determine si el sistema debe   ')
Aadd( aHelpSpa, 'considerar la fecha de cancelación     ') 
Aadd( aHelpSpa, '(E5_DATA) o la fecha de disponibilidad ')  
Aadd( aHelpSpa, '(E5_DTDISPO).                          ')  

Aadd( aHelpEng, 'If the calculation of the comissions is ')
Aadd( aHelpEng, 'being generated from a bill post selects')
Aadd( aHelpEng, 'if the system must consider the Date of ')
Aadd( aHelpEng, 'Decrease (E5_DATA) or the Date of       ') 
Aadd( aHelpEng, 'Availability (E5_DTDISPO) for the       ')    
Aadd( aHelpEng, 'calculations.                           ')    
    
dbSelectArea("SX1")
dbSetOrder(1)
If SX1->( dbSeek(PadR("AFI440",Len(X1_Grupo))+"09") .And. AllTrim(X1_DEF02) != "Data Disponib." )
	SX1->( RecLock("SX1", .F.) )
	SX1->( dbDelete() )
	SX1->( MsUnLock() )
EndIf

PutSx1( "AFI440", "09","Considera Data ?","¿Utiliza Fecha ?","Inform Date ?","mv_ch9","N",1,0,1,"C","","","","","mv_par09","Data Baixa","Fecha de Cancel","Date of Decreas","","Data Disponib.","Fecha de Dispon","Date of Availab","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,".AFI44009.")

cKey  := "P.AFI44010."

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}

Aadd( aHelpPor, 'Informe SIM se desejar que fornecedores')
Aadd( aHelpPor, 'bloqueados tenham comissões calculadas ')
Aadd( aHelpPor, 'Informe NÃO se desejar o contrário. ')
Aadd( aHelpPor, 'Neste caso, as comissões pendentes não  ') 
Aadd( aHelpPor, 'serão excluidas no momento do recálculo.')  
Aadd( aHelpPor, 'OBS: Esta pergunta somente tera efeito ') 
Aadd( aHelpPor, 'se o campo A2_MSBLQL existir na base.')  

Aadd( aHelpEng, 'Enter YES if you wish to calculate the')
Aadd( aHelpEng, 'blocked sales representatives commissions.')
Aadd( aHelpEng, 'Otherwise, enter NO. In this case, pending')
Aadd( aHelpEng, 'commissions will not be deleted at the') 
Aadd( aHelpEng, 'time of the new calculation.')  
Aadd( aHelpEng, 'NOTE: This question will be effective only') 
Aadd( aHelpEng, 'if the field A2_MSBLQL is created in base')  

Aadd( aHelpSpa, 'Informe SI si desea calcular las comisiones')
Aadd( aHelpSpa, 'de los fornecedores bloqueados. ')
Aadd( aHelpSpa, 'Informe NO si desea lo contrario. En este')
Aadd( aHelpSpa, 'caso, las comisiones pendientes no se borraran') 
Aadd( aHelpSpa, 'en el momento del calculo.')  
Aadd( aHelpSpa, 'OBS.: Esta pregunta tendra efecto solamente') 
Aadd( aHelpSpa, 'si el  campo A2_MSBLQL esta creado en la base.')  

PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa) // Ajuste HELP PERGUNTA ("Comis. Vend. Bloqueado?")

/*/
PutSx1( "AFI440", "10","Comis. Vend. Bloqueado?","¿Comis. Vend. Bloqueado??","Comis. Vend. Bloqueado?","mv_cha","N",1,0,1,"C","","","","","mv_par10","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,".AFI44010.")
/*/  

cKey  := "P.AFI44011."

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}

Aadd( aHelpPor, 'Informe "Sim" caso queira que as       ')
Aadd( aHelpPor, 'comissões sobre compensações com       ')
Aadd( aHelpPor, 'titulos de adiantamento do tipo RA     ')
Aadd( aHelpPor, 'sejam calculadas. Informe "Não"        ') 
Aadd( aHelpPor, 'caso contrário.                        ')  

Aadd( aHelpSpa, 'Elija la opcion "Si" cuando desee que  ')
Aadd( aHelpSpa, 'las comisiones sobre las compensaciones')
Aadd( aHelpSpa, 'con titulos de anticipo del tipo RA    ')
Aadd( aHelpSpa, 'sean calculadas, o en caso contrario,  ') 
Aadd( aHelpSpa, 'elija "No".                            ')  
  
Aadd( aHelpEng, 'Inform "Yes" if you want the clearing  ')
Aadd( aHelpEng, 'commissions with advance bills type RA ')
Aadd( aHelpEng, 'to be calculated. Otherwise, select "No"')
    
    
dbSelectArea("SX1")
dbSetOrder(1)
If SX1->( dbSeek(PadR("AFI440",Len(X1_Grupo))+"11") .And. AllTrim(X1_PERGUNT) != "Calc.Comiss.s/ RA" )
	SX1->( RecLock("SX1", .F.) )
	SX1->( dbDelete() )
	SX1->( MsUnLock() )
EndIf

PutSx1( "AFI440", "11","Calc.Comiss.s/ RA","Calc.Comiss.s/ RA","Calc.Comiss.s/ RA","MV_CHB","N",1,0,1,"C","","","","","MV_PAR11","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,".AFI44011.")

RestArea(aAreaSX1)
RestArea(aArea)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LojasSA1     ³ Autor ³Marcel Borges Ferreira ³ Data ³ 23/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carrega todas as lojas do cliente em um Array.	   			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINA440                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LojasSa1(cCliente)
	Local aRet     := {}
	Local aArea    := GetArea()
	Local aAreaSA1 := SA1->(GetArea())
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	
	SA1->(DbGoTop())
	SA1->(MsSeek(xFilial("SA1")+cCliente))
	While SA1->A1_FILIAL == xFilial("SA1") .And.;
			SA1->A1_COD == cCliente
		Aadd(aRet,	SA1->A1_LOJA)
		SA1->(DbSkip())
	End	

	RestArea(aAreaSA1)
	RestArea(aArea)   

Return aRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ f440JurLiq   ³ Autor ³Marcel Borges Ferreira ³ Data ³ 14/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o valor dos juros de um titulo gerado por liquidação   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINA440                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function f440JurLiq(cRecno,cAliasSE1)
	Local aArea    := GetArea()
	Local aAreaSE1 := SE1->(GetArea())
	Local aAreaSE5 := SE5->(GetArea())
	Local nVlrJuros := 0
	Local cKeySE1
	
	Default cAliasSE1 := "SE1"

	(cAliasSE1)->(MsGoTo(cRecno))
	cKeySe1 := (cAliasSE1)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
		
	SE5->(dbSetOrder(7))
	If SE5->(MsSeek(xFilial("SE5")+cKeySe1))
		While !SE5->(Eof()) .and. SE5->E5_FILIAL == xFilial("SE5") .and. ;
			cKeySe1 == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
			If SE5->E5_MOTBX == "LIQ" .and. SE5->E5_SITUACA != "C" .And. SE5->E5_TIPODOC == "JR"
				nVlrJuros += SE5->E5_VALOR
			Endif
			SE5->(dbSkip())
		Enddo	
	Endif
	
	RestArea(aArea)
	RestArea(aAreaSE1)
	RestArea(aAreaSE5)
	
Return nVlrJuros

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ f440DesLiq   ³ Autor ³ Leonardo Castro       ³ Data ³ 13/05/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o valor dos descontos de um titulo gerado              ³±±
±±³          ³ por liquidação                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINA440                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function f440DesLiq(cRecno,cAliasSE1)
	Local aArea    := GetArea()
	Local aAreaSE1 := SE1->(GetArea())
	Local aAreaSE5 := SE5->(GetArea())
	Local nVlrDesc := 0
	Local cKeySE1

	Default cAliasSE1 := "SE1"
	
	(cAliasSE1)->(MsGoTo(cRecno))
	cKeySe1 := (cAliasSE1)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
		
	SE5->(dbSetOrder(7))
	If SE5->(MsSeek(xFilial("SE5")+cKeySe1))
		While !SE5->(Eof()) .and. SE5->E5_FILIAL == xFilial("SE5") .and. ;
			cKeySe1 == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
			If SE5->E5_MOTBX == "LIQ" .and. SE5->E5_SITUACA != "C" .And. SE5->E5_TIPODOC == "DC"
				nVlrDesc += SE5->E5_VALOR
			Endif
			SE5->(dbSkip())
		Enddo	
	Endif
	
	RestArea(aArea)
	RestArea(aAreaSE1)
	RestArea(aAreaSE5)
	
Return nVlrDesc

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Fa440LjTrc   ³ Autor ³ Vendas e CRM          ³ Data ³ 02/06/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ No caso do SIGALOJA faz o tratamento quano a venda possui troco³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINA440                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa440LjTrc(nVlrProp,nValor,aBasesVend,cBaixa)

Local aArea    	:= GetArea()
Local cNumTit	:= SE1->E1_NUM
Local cPrefTit	:= SE1->E1_PREFIXO
Local nComRep	:= 0 			
Local cSl4      := ""
Local nFompg    := 0 
Local lDinh     := .F.
Local nPorcVen  := 0       // Porcentagem de comissao do vendedor.
Local nPercent  := 0    
Local aSL4Forma := {}      // Array contendo os tipos de pagamento e valores
Local nValBE    := 0
Local nVlrBE    := 0 

Local aAreaSL1    	:= SL1->(GetArea())
Local aAreaSL4    	:= SL4->(GetArea())

DEFAULT nVlrProp:= 0	    // Valor do titulo 
DEFAULT nValor	:= 0	    // Valor da comissao
DEFAULT aBasesVend := {}  	// Valores para Calculo do Vendedor
DEFAULT cBaixa := "E"

nValBE := If(cBaixa == "E" , 3, 4 )
nVlrBE := If(cBaixa == "E" , 5, 6 ) 


If Len(aBasesVend) > 0
	nPorcVen := aBasesVend[7]
EndIf
If AllTrim(Upper(SE1->E1_ORIGEM))$"LOJA010/LOJA701"
	DbSelectArea("SL1")
	DbSetOrder(2)	//L1_FILIAL + L1_SERIE + L1_DOC 
	If DbSeek(xFilial("SL1")+cPrefTit+cNumTit)	    
		If SL1->( FieldPos( "L1_TROCO1" ) ) > 0 .AND. SL1->L1_TROCO1 > 0 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe mais de uma forma de pagamento na venda   ³
			//³ para que seja ajustada o valor de comissao de uma forma de   ³
			//³ pagamento													 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SL4->(DbSetorder(1))
			If SL4->(DbSeek(xFilial("SL1") + SL1->L1_NUM ) )
				cSl4 := xFilial("SL1") + SL1->L1_NUM
				while !SL4->(EOF()) .AND. cSl4 == xFilial("SL4") + SL4->L4_NUM
					AADD(aSL4Forma , {SL4->L4_FORMA,SL4->L4_VALOR} )
					If IsMoney(SL4->L4_FORMA) 
						lDinh := .T.
					EndIf           
					SL4->(DbSkip())
				End
			EndIf
			
			If Len(aSL4Forma) > 1  .OR. SL1->L1_CREDITO > 0
				ASort( aSL4Forma,,,{|x,y| x[2] > y[2] } )
				If (lDinh .AND. IsMoney(SE1->E1_TIPO) ) .OR. (!lDinh .AND. (Len(aSL4Forma) >= 1 .AND. SE1->E1_TIPO $ aSL4Forma[1][1]))
				   nPercent := aBasesVend[nValBE] / aBasesVend[2]  
				   If !"CC|CD" $ SE1->E1_TIPO 
				   		aBasesVend[nValBE] := (SE1->E1_VALOR - SL1->L1_TROCO1) * nPercent	
				   Else
				   		aBasesVend[nValBE] := (SE1->E1_VLRREAL - SL1->L1_TROCO1) * nPercent				   
				   EndIf                                                                   
				   aBasesVend[nVlrBE] := aBasesVend[nValBE] * ( nPorcVen /100)				 
				   nVlrProp := aBasesVend[nValBE]
   				   nValor   := aBasesVend[nVlrBE] 
			    EndIf
			Else			
				nComRep := nVlrProp / ( SL1->L1_VLRTOT + SL1->L1_TROCO1)
				nVlrProp:= nVlrProp - ( SL1->L1_TROCO1 * nComRep)
				nValor	:= nVlrProp * (nPorcVen/100)   
				aBasesVend[nValBE] := nVlrProp 
				aBasesVend[nVlrBE] := nValor 				 
			EndIf
		EndIf	
	EndIf
EndIf

RestArea(aArea)
RestArea(aAreaSL1)
RestArea(aAreaSL4)		

Return (aBasesVend)      	
                   
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VerBxDsd   ³ Autor ³ Ramon Teodoro          ³ Data ³ 30/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica o motivo de baixa DSD, para não fazer parte do recalculo³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINA440                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function VerBxDsd(cPrefixo,cNum,cParcela,cTipo,cCliente,cLoja)

Local lBxDSD := .F.

DbSelectArea("SE5")
DbSetOrder(7)
DbGoTop()

If DbSeek(xFilial("SE5")+cPrefixo+cNum+cParcela+cTipo+cCliente+cLoja)
	If SE5->E5_MOTBX == "DSD" .And. SE5->E5_SITUACA <> "C"
		lBxDSD := .T.
	EndIf
EndIf

Return lBxDSD

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ F440Fator  ³ Autor ³ Totvs                   ³ Data ³ 30/10/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Recalculo base de comissão                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINA440                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function F440Fator(nVlrRec,nVlrLiq,aBases,nPosition,nValIRBx,nValPis,nValCof,nValCsl,lJuros, lDescont,nDescont, nJuros,lUltimo, lLiqFat)

Local aArea			:= GetArea()
Local aAreaSE1		:= SE1->(GetArea())
Local lPccBxCr		:= If(lFindPccBx,FPccBxCr(),.F.)
Local lIrPjBxCr		:= If(lFindIrBx,FIrPjBxCr(),.F.)
Local aPRet    		:= If(SE5->E5_MOTBX == "CMP", F440RAComp(),{} )
Local nAbatimento	:= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,SE1->E1_EMISSAO,SE1->E1_CLIENTE,SE1->E1_LOJA)
Local nMoedaBCO		:= If(SE5->E5_MOTBX == "CMP", Val("01"), Val(SE5->E5_MOEDA) )
Local nMoedaTit		:= SE1->E1_MOEDA
Local nVlrTit			:= SE1->E1_VALOR
Local dDataBx			:= If(Empty(SE1->E1_BAIXA), dDataBase, SE1->E1_BAIXA)
Local nTxMoeda 		:= 0
Local nProp			:= 0
Local nProJD		:= 1
Local nJurAux 		:= 0
Local nDescAux		:= 0
Local nJurReneg		:= 0 // Juros de renegociação (Liquidação)
Local nDesReneg		:= 0 // Desconto de renegociação (Liquidação)
Local lIssEmis		:= SuperGetMv("MV_MRETISS",.T.,"2") == "1"  			// .T. = Na emissão
Local lRecIss			:= IIf(cPaisLoc == "BRA", SA1->A1_RECISS == "1", .F.)
Local lBQ10925		:= SuperGetMv("MV_BQ10925",.T.,"2") == "2" 			// .2. = Liquido 1 = Bruto
Local nSomaImp		:= nValPis + nValCof + nValCsl + nValIRBx + IIF(lIssEmis .or. !lRecIss,0,SE5->E5_VRETISS) + nAbatimento
Local lCalcComis		:= ComisBx(SE5->E5_MOTBX)
Local lBxTotal		:= .F.

Default lJuros 		:= .F.
Default lDescont 	:= .F.
Default nDescont	:= 0
Default nJuros		:= 0
Default lUltimo 	:= .F.
Default lLiqFat		:= .F.

nJurAux	 := nJuros
nDescAux := nDescont

// Carrega a Taxa da Moeda a ser utilizada
If SE1->E1_MOEDA > 1
	If SE5->E5_TXMOEDA > 0				// TXMOEDA DA BAIXA
		nTxMoeda := SE5->E5_TXMOEDA
	ElseIf SE1->E1_TXMOEDA > 0			// TXMOEDA CONTRATADA - SE1
		nTxMoeda := SE1->E1_TXMOEDA
	Else								// TXMOEDA DO DIA
		nTxMoeda := RecMoeda(dDataBx,SE1->E1_MOEDA)
	EndIf
EndIf

// Caso os valores estejam em outra moeda converto para REAL afim de proporcionalizar a baixa corretamente.
nVlrRec := If(nMoedaBCO > 1, xMoeda(nVlrRec,nMoedaBCO,1,dDataBx,3,nTxMoeda), nVlrRec)
nVlrTit := If(nMoedaTit > 1, xMoeda(nVlrTit,nMoedaTit,1,dDataBx,3,nTxMoeda), nVlrTit)

// Verifica se é uma Baixa Total.
If ( nVlrRec - nJurAux + nDescAux + nSomaImp == nVlrTit ) .Or. ;
   ( SE1->E1_SALDO - ( nVlrRec + nSomaImp - nJurAux + nDescAux ) == 0 ) .Or. ;
   ( SE1->E1_SALDO == 0 .And. FunName() == "FINA330" ) .Or. ;
   ( SE1->E1_SALDO == 0 .And. lUltimo )
	lBxTotal := .T.
EndIf

// Recompor o Valor Recebido para compor a proporcionalização da Base de Comissão
/*   INICIO   */
nVlrRec := nVlrRec + nDescAux - nJurAux

// Tratamento para impostos na Emissão
nVlrRec += If(lBxTotal .And. lCalcComis, nAbatimento, 0)

// Tratamento para impostos na Baixa
If lPccBxCr .And. (lBQ10925 .Or. lBxTotal)
	nVlrRec += nValPis		// PIS
	nVlrRec += nValCof		// COFINS
	nVlrRec += nValCsl		// CSLL
EndIf

If lIrPjBxCr .And. (lBQ10925 .Or. lBxTotal)
	nVlrRec += nValIRBx		// IRRF
EndIf

/*    FIM    */

// Base de proporção = Valor do Título
nBaseBAK := If(nMoedaTit > 1, SE1->E1_VLCRUZ, nVlrTit)

// Calculo da Proporção
nProp	:= nVlrRec / nBaseBak
If lLiqFat
	If Select("__SE1") > 0 .And. Len(aBases[nPosition]) > 12
		nJurReneg	:= f440JurLiq(aBases[nPosition,13])
		nDesReneg	:= f440DesLiq(aBases[nPosition,13])
	EndIf
	nProJD	:= (If(Len(aBases[nPosition]) > 11, aBases[nPosition,12], aBases[nPosition,2]) + nJurReneg - nDesReneg) / nVlrTit
EndIf

// Base de Comissão
aBases[nPosition,4] := aBases[nPosition,4] * nProp
aBases[nPosition,4] := aBases[nPosition,4] - Iif(lDescont, (nDescAux * nProJD),0) +  Iif(lJuros, (nJurAux*nProJD),0)

// Valor da Comissão
aBases[nPosition,6] := aBases[nPosition,4] * (aBases[nPosition,7]/100)


RestArea(aAreaSE1)
RestArea(aArea)

Return

Static Function F070Fator(nVlrRec,nVlrLiq,aBases,nBaseBAK,nX,lJuros,lDescont,lLiqFat)

Local aArea			:= GetArea()
Local aAreaSE1		:= SE1->(GetArea())
Local nAbatimento	:= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,SE1->E1_EMISSAO,SE1->E1_CLIENTE,SE1->E1_LOJA)
Local nProp			:= 0
Local nProJD		:= 1
Local nMoedaBCO		:= If ( lFina330, Val("01"), Val(SE5->E5_MOEDA) ) // Via compensação os valores da movimentação já estão em MOEDA1
Local nMoedaTit		:= SE1->E1_MOEDA
Local nVlrTit		:= SE1->E1_VALOR
Local dDataBx		:= If (Type("dBaixa") == "D" .And. !Empty(dBaixa), dBaixa , dDataBase)
Local nTaxaMoed		:= 0
Local lPccBxCr		:= If (lFindPccBx,FPccBxCr(),.F.)
Local lIrPjBxCr		:= If (lFindIrBx,FIrPjBxCr(),.F.)
Local nJurAux 		:= If (lFina070 .or. lFina110 .or. lFina200 .or. lFina330,nJuros+nMulta,0)
Local nDescAux		:= If (lFina070 .or. lFina110 .or. lFina200 .or. lFina330,nDescont,0)
Local nJurReneg		:= 0 // Juros de renegociação (Liquidação)
Local nDesReneg		:= 0 // Desconto de renegociação (Liquidação)
Local aPRet    		:= If (lFina330, F440RAComp(), {})
Local lIssEmis		:= SuperGetMv("MV_MRETISS",.T.,"2") == "1" 			// .T. = Na emissão
Local lRecIss			:= IIf(cPaisLoc == "BRA", SA1->A1_RECISS == "1", .F.)
Local lBQ10925		:= SuperGetMv("MV_BQ10925",.T.,"2") == "2" 			// .2. = Liquido 1 = Bruto
Local lBxTotal		:= .F.
Local nSomaImp 		:= iif(cPaisloc == "BRA",aBases[nX,8] + aBases[nX,9] + aBases[nX,10] + aBases[nX,11] + IIF(lIssEmis .or. !lRecIss,0,SE5->E5_VRETISS) + nAbatimento,0) //quando o ISS é na emissão e gerado no CR, o valor dele já está contido em nAbatimento

DEFAULT lLiqFat := .F.

// Carrega a Taxa da Moeda a ser utilizada
If SE1->E1_MOEDA > 1
	If Type("nTxMoeda") == "N" .And. nTxMoeda > 0 		// TXMOEDA DA BAIXA
		nTaxaMoed := nTxMoeda
	ElseIf SE1->E1_TXMOEDA > 0 							// TXMOEDA CONTRATADA - SE1
		nTaxaMoed := SE1->E1_TXMOEDA
	Else												// TXMOEDA DO DIA
		nTaxaMoed := RecMoeda(dDataBx,SE1->E1_MOEDA)
	EndIf
EndIf

// Caso os valores estejam em outra moeda converto para REAL afim de proporcionalizar a baixa corretamente.
nVlrRec := If(nMoedaBCO > 1, xMoeda(nVlrRec,nMoedaBCO,1,dDataBx,3,nTaxaMoed), nVlrRec)
nVlrTit := If(nMoedaTit > 1, xMoeda(nVlrTit,nMoedaTit,1,dDataBx,3,nTaxaMoed), nVlrTit)

// Verifica se é uma Baixa Total.
If ( nVlrRec - nJurAux + nDescAux + nSomaImp >= nVlrTit ) .Or. ;
   ( SE1->E1_SALDO - ( nVlrRec + nSomaImp - nJurAux + nDescAux ) == 0 ) .Or. ;
   ( SE1->E1_SALDO == 0 .And. FunName() == "FINA330" )
	lBxTotal := .T.
EndIf

// Recompor o Valor Recebido para compor a proporcionalização da Base de Comissão
/*   INICIO   */
nVlrRec := nVlrRec +  nDescAux - nJurAux

// Tratamento para impostos na Emissão
nVlrRec += If(lBxTotal, nAbatimento, 0)

// Tratamento para impostos na Baixa
If lPccBxCr .And. (lBQ10925 .Or. lBxTotal)
	nVlrRec += aBases[nX,8]		// PIS
	nVlrRec += aBases[nX,9]		// COFINS
	nVlrRec += aBases[nX,10]		// CSLL
EndIf

If lIrPjBxCr .And. (lBQ10925 .Or. lBxTotal)
	nVlrRec += aBases[nX,11]		// IRRF
EndIf

/*    FIM    */

// Base de proporção = Valor do Título
nBaseBAK := If(nMoedaTit > 1, SE1->E1_VLCRUZ, nVlrTit)
If lLiqFat
	If Select("__SE1") > 0 .And. Len(aBases[nX]) > 12
		nJurReneg	:= f440JurLiq(aBases[nX,13])
		nDesReneg	:= f440DesLiq(aBases[nX,13])
	EndIf
	nProJD	:= (If(Len(aBases[nX]) > 11,aBases[nX,12], aBases[nX,2]) + nJurReneg - nDesReneg) / nVlrTit
EndIf
// Calculo da Proporção
nProp := nVlrRec / nBaseBak

// Base de Comissão
aBases[nX,4] := aBases[nX,4] * nProp 
aBases[nX,4] := aBases[nX,4] - Iif(lDescont, (nDescAux * nProJD),0) + Iif(lJuros, (nJurAux*nProJD),0)

// Valor da Comissão
aBases[nX,6] := aBases[nX,4] * (aBases[nX,7]/100)

RestArea(aAreaSE1)
RestArea(aArea)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ F440LiqFat  ³ Autor ³ Totvs                ³ Data ³ 19/04/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Recupera os recnos e adiciona no array aRecSE1 os recnos dos   ³±±
±± titulos que origens da fatura que vieram de liquidação                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINA440                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa440LiqFat(aRecSE1, aTitLiq)
Local aAreaSE1 := GetArea("SE1")
Local aAreaSE5 := GEtArea("SE5")
Local iX := 1
Local nPos := 0
Local nTamRec := Len(aRecSE1)

If Select("__SE1") == 0
	ChkFile("SE1",.F.,"__SE1")
Endif

While iX <= nTamRec
	__SE1->(dbGoTo(aRecSE1[iX]))
	If !Empty(__SE1->E1_NUMLIQ)
		dbSelectArea("SE5")
		dbSetOrder(10)
		If dbSeek(xFilial("SE5")+__SE1->E1_NUMLIQ)
			While !SE5->(Eof()) .and. xFilial("SE5") == SE5->E5_FILIAL .And. __SE1->E1_NUMLIQ == Substr(SE5->E5_DOCUMEN, 1, Len(__SE1->E1_NUMLIQ))
				If SE5->E5_MOTBX == "LIQ"
					dbSelectArea("SE1")
					dbSetOrder(1)
					If dbSeek(xFilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)
						nPos := aScan(aRecSE1, SE1->(RecNo()))
						If nPos == 0
							Aadd(aRecSE1, SE1->(Recno()) )
							Aadd(aTitLiq, SE1->(Recno()))
						Endif
					EndIf
				EndIf
				SE5->(dbSkip())
			EndDo
			aDel(aRecSE1, iX)
			aSize(aRecSE1, Len(aRecSE1)-1)
			nTamRec := Len(aRecSE1)
			iX -= 1
		Endif
	Endif
	iX++
EndDo

RestArea(aAreaSE1)
RestArea(aAreaSE5)

Return()


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ F440RAComp  ³ Autor ³ Totvs                ³ Data ³ 19/04/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se houve retenção do PCC pela RA                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINA440                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function F440RAComp()
Local aRet := {}
Local aArea := SE5->(GetArea())
Local cTipodoc := "RA"
Local nTamTit := TamSX3("E1_PREFIXO")[1]+TamSX3("E1_NUM")[1]+TamSX3("E1_PARCELA")[1] + TamSX3("E1_TIPO")[1]
Local cChaveE1Adt := ""

//E5_FILIAL, E5_TIPODOC, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_DATA, E5_CLIFOR, E5_LOJA, E5_SEQ, R_E_C_N_O_, D_E_L_E_T_
cChaveE1Adt := SE5->E5_FILIAL+ cTipoDOC + Subs(SE5->E5_DOCUMEN,1,nTamTit)
SE5->(dbSetOrder(2))
If SE5->(MsSeek(cChaveE1Adt))
	Aadd(aRet, {SE5->E5_PRETPIS, SE5->E5_PRETCOF, SE5->E5_PRETCSL})
Else
	Aadd(aRet, {"1", "1","1"})	
EndIf

RestArea(aArea)
Return aREt



Static Function ValidaFat()
Local cQuery	:= ""
Local lRet		:= .T.
Local cSpace	:= Space(TamSx3("E1_VEND1")[1])
Local cAliasX := CriaTrab(,.F.)

cQuery	:= "SELECT SE1.R_E_C_N_O_ FROM "+RetSqlName("SE1")+" SE1 " 
cQuery	+= "WHERE SE1.E1_FILIAL = '"+xFilial("SE1",SE1->E1_FILORIG)+"' "
cQuery	+= "AND SE1.E1_FATPREF = '"+SE1->E1_PREFIXO+"' "	
cQuery	+= "AND SE1.E1_FATURA = '"+SE1->E1_NUM+"' "
cQuery	+= "AND ( SE1.E1_VEND1 <> '"+cSpace+"' "
cQuery	+= "OR SE1.E1_VEND2 <> '"+cSpace+"' "
cQuery	+= "OR SE1.E1_VEND3 <> '"+cSpace+"' "
cQuery	+= "OR SE1.E1_VEND4 <> '"+cSpace+"' "
cQuery	+= "OR SE1.E1_VEND5 <> '"+cSpace+"' ) "
cQuery	+= "AND SE1.D_E_L_E_T_ = ' '"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasX)

(cAliasX)->(dbGoTop())
			
lRet := !(cAliasX)->(Eof())

(cAliasX)->(dbclosearea())

Return lRet
