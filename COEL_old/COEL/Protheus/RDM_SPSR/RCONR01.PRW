#INCLUDE "CONR380.CH"
//#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Conr380  ³ Autor ³ Pilar S Albaladejo    ³ Data ³ 27/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete por Centro de Custo Extra Contabil               ³±±
±±³          ³ Obs.: Esse programa substitiui o prg conr130.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Conr380(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RCONR01()

Local cString := "SI3"
Local cDesc1  := OemToAnsi(STR0001) // "Este programa ira imprimir a relacao das Balancete por "
Local cDesc2  := OemToAnsi(STR0002) // "Centro de Custo Extra-Contabil, de acordo com os para-"
Local cDesc3  := OemToAnsi(STR0003) // "metros solicitados pelo usuario."
Local titulo   := OemToAnsi(STR0006) //"Balancete por Centro de Custo Extra-Contabil "

Private aReturn  := {OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 1, 2, 1, "", 1 } // "Zebrado" ###  "Administracao"
Private wnRel    := "CONR380"
Private Tamanho  := "M"
Private nomeprog := "CONR380"
Private cPerg    := "COR380"
Private cbtxt    := ""
Private cbcont   := 0
Private nLastKey := 0
Private li       := 80
Private m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao do Cabecalho.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01	      	// Data inicial do periodo desejado      ³
//³ mv_par02            // A partir da conta                     ³
//³ mv_par03            // Ate a conta                           ³
//³ mv_par04            // A partir do Centro de Custo           ³
//³ mv_par05            // Ate o Centro de Custo                 ³
//³ mv_par06            // Qual Moeda				 					  ³
//³ mv_par07            // Imprime na Lingua Nacional/Estrangeira³
//³ mv_par08            // Imprime sinteticas?                   ³
//³ mv_par09            // Pula Pagina?            	           ³
//³ mv_par10            // Nivel Quebra C.C?                     ³
//³ mv_par11            // Considera Ultm Lanc LP?               ³
//³ mv_par12				// Imprime sinteticas zeradas 			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("COR380", .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus( { |lEnd| R380Imp(@lEnd,wnRel,cString,Tamanho,Titulo)})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ R380Imp  ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 12/03/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Balancete por Centro de Custo Mensal                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ R016Imp(lEnd,wnRel,cString)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Conr380                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros³ lEnd    : A‡Æo do Codeblock                                ³±±
±±³           ³ wnRel   : T¡tulo do relat¢rio                              ³±±
±±³           ³ cString : Mensagem                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R380Imp(lEnd,WnRel,cString,Tamanho,Titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCamposTRB   := {}
Local aDataAnt
Local cCusto
Local cArqTRB
Local cIndTRB
Local aCposTRB1	:= {}
Local cArqTRB1		
Local cIndTRB1
Local cChave
Local nMoeda
Local limite       := 132
Local lEstrang
Local nDecimais	:= 2
Local cCentroCus
Local cConta
Local cPeriodo    := Periodo(mv_par01,1)
Local nTotSal, nDebito, nCredito
Local nTotDeb, nTotCrd
Local cInvMasc := "", nTamMax := 0
Local cMascara		:= GetMv("MV_MASCARA")
Local cMascCus		:= GetMv("MV_MASCCUS")
Local cCtaSup		:= GetMv("MV_CTASUP")
Local cDigVer		:= GetMv("MV_DIGVER")
Local lFirst
Local aTotais, nTotal1 := nTotal2 := 0
Local aDataAtu
Local cCodProcurado
Local nTamCusto	:= Len(CriaVar("I3_CUSTO"))
Local nDif
Local cabec1 := OemToAnsi(STR0008) //"Codigo da Conta        Descricao da Conta                         Saldo Anterior    Debito no Mes   Credito no Mes      Saldo Atual"
Local cabec2 := "" 
Local cMoeda := Str(mv_par06,1)
Local cDescMoeda := SubStr(Getmv("MV_MOEDA"+cMoeda),1,15)
Local cVar     :=""
Local nCont
Local cFilterUser

cMascCus := Alltrim(Substr(cMascCus,1,mv_par10))

For nCont := Len(cMascCus) To 1 Step -1
	cInvMasc += Substr(cMascCus,nCont,1)
	nTamMax	+= Val(Substr(cMascCus,nCont,1))
Next nCont

nDif := Iif((nTamCusto-nTamMax)<0,0,(nTamCusto-nTamMax))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis p/ Data.                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cMesAtu17
Private cMesAnt17

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula datas iniciais e finais							           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMoeda 	:= mv_par06
aDataAtu := CalcData(mv_par01,nMoeda)
aDataAnt	:= CalcAnt(aDataAtu[1],nMoeda)

If !DataMoeda(nMoeda, @cMesAtu17, aDataAtu[1])

	Help(" ",1,"MESINVALID")

	Set Filter To
	Return
EndIf

DataMoeda(nMoeda, @cMesAnt17, aDataAnt[1])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se a moeda escolhida nao esta em uso -> sai do programa.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(GetMv("MV_MOEDA" + Str(nMoeda,1)))
	Set Filter To
	Return
End		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existem contas desatualizadas						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nCont := 1 To Val(cMesAtu17)
	If nCont == Val(cMesAtu17)
		If CheckSint(Val(cMesAtu17),Month(mv_par01))
			Set Filter To
			Return
		EndIf
	Else
		If CheckSint(nCont,nCont,.F.)
			cVar	+= "N"
		Else
			cVar += "S"
		EndIf
	End
Next nCont
If "N" $ cVar
	Help(" ",1,"Cr040SINT",,cVar,5,13)
EndIf
Titulo := 	Titulo + ;
				OemToAnsi(STR0010)+; // " de " 
				Dtoc(aDataAtu[1]) +;
				OemToAnsi(STR0011)+; // " a " 
				Dtoc(aDataAtu[2]) +;
				OemToAnsi(STR0014)  +; // " em "
				cDescMoeda

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array contendo os Campos do Arquivo de Trabalho p/ imp relat ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCamposTRB := {{ "CC"        , "C",  9, 0 },;  // Centro de Custo
					{ "CODIGO"    , "C", 20, 0 },;  // Numero da Conta
					{ "CLASSE"    , "C",  1, 0 },;  // Classe da Conta (Analitica/Sintetica)
					{ "SALDOANT"  , "N", 17, 2 },;  // Saldo Anterior
					{ "DEBITO"    , "N", 17, 2 },;  // Valor do Debito
					{ "CREDITO"   , "N", 17, 2 },;  // Valor do Credito
					{ "SALDOATU"  , "N", 17, 2 },;  // Saldo Atual
					{ "DC"  		  , "C", 01, 2 }}  // Digito Verificador da conta
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria e Abre o Arquivo de Trabalho.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTRB := CriaTrab(aCamposTRB, .T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Poe em uso o arquivo de trabalho.                   		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select( "TRB" ) > 0
	dbSelectArea( "TRB" )
	dbCloseArea()
	dbSelectArea("SI1")
EndIf
dbUseArea( .T.,, cArqTRB, "TRB", .T., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIndTRB := CriaTrab(Nil, .F.)
cChave  := "CC + CODIGO"
IndRegua("TRB",cIndTRB,cChave,,,OemToAnsi(STR0009))			// "Criando Indice..."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Arquivo Temporario com as quebras de sinteticas - SI3		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCposTRB1	:= {{ "CODCC"     , "C", 09, 0 },;  // Centro de Custo
					{ "TIPO"      , "C", 01, 0 },;  // Tipo Analitico / Sintetico
					{ "SALDOANT"  , "N", 17, 2 },;  // Saldo Anterior
					{ "DEBITO"    , "N", 17, 2 },;  // Valor do Debito
					{ "CREDITO"   , "N", 17, 2 },;  // Valor do Credito
					{ "SALDOATU"  , "N", 17, 2 }}	  // Saldo Atual
					
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria e Abre o Arquivo de Trabalho.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTRB1:= CriaTrab(aCposTRB1, .T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Poe em uso o arquivo de trabalho.                    		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select( "TRB1" ) > 0
	dbSelectArea( "TRB1" )
	dbCloseArea()
	dbSelectArea("SI3")
EndIf
dbUseArea( .T.,, cArqTRB1, "TRB1", .T., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIndTRB1 := CriaTrab(Nil, .F.)
cChave1  := "CODCC+TIPO"
IndRegua("TRB1",cIndTRB1,cChave1,,,OemToAnsi(STR0009))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se descricao em outra lingua      	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lEstrang := .F.
dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("I1_DESCEST")
If X3USO(X3_USADO)
	If mv_par07 == 2
		lEstrang := .T.
	EndIf
EndIf		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica numero de decimais informados                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("I1_SALANT")
nDecimais := X3_DECIMAL
dbSetOrder(1)

dbSelectArea("SI3")
dbSetOrder(1)
dbSeek( xFilial() + mv_par04, .T. )
SetRegua(RecCount())

While !Eof() .And. SI3->I3_CUSTO>= mv_par04 .And. SI3->I3_CUSTO <= mv_par05 .And. SI3->I3_FILIAL == xFilial()

	cFilterUser := aReturn[7]
   // Verifica o filtro do usuario
	If !Empty(cFilterUser).and.!(&cFilterUser)
		dbSkip()
		Loop
	Endif

	If SI3->I3_CONTA < mv_par02 .Or. SI3->I3_CONTA > mv_par03 .Or. ;
		SI3->I3_MOEDA == "0" .Or. Empty(SI3->I3_MOEDA) .Or. Empty(SI3->I3_CONTA)
		dbSkip()
		Loop
	EndIf

	cCusto := Substr(SI3->I3_CUSTO,1,nTamMax)+Space(nDif)

	r380CrSI3(cCusto)
	nTotDeb	:= 0
	nTotCrd	:= 0
	nTotSal	:= 0

	While !Eof() .And. SI3->I3_FILIAL == xFilial() .And.;
		Substr(SI3->I3_CUSTO,1,nTamMax)+Space(nDif) == cCusto

		IncRegua()
		cFilterUser := aReturn[7]
	   // Verifica o filtro do usuario
		If !Empty(cFilterUser).and.!(&cFilterUser)
			dbSkip()
			Loop
		Endif

		If VAL(SI3->I3_MOEDA) != mv_par06
			dbSkip()
			Loop
		EndIf	

		If SI3->I3_CONTA < mv_par02 .Or. SI3->I3_CONTA > mv_par03 .Or. ;
			SI3->I3_MOEDA == "0" .Or. Empty(SI3->I3_MOEDA)
			dbSkip()
			Loop
		EndIf

		dbSelectArea("SI1")
		dbSeek(cFilial+SI3->I3_CONTA)
		cDigito := SI1->I1_DC
		dbSelectArea("SI3")
			
		nSalant 	:= 0
		nDebito 	:= 0
		nCredito	:= 0
		nSalAtu 	:= 0

		nSalAnt := SaldoCC(SI3->I3_CUSTO,SI3->I3_CONTA, Val(cMesAnt17), nMoeda)
		nDebito := &("SI3->I3_DEB"+cMesAtu17)
		nCredito:= &("SI3->I3_CRE"+cMesAtu17)
		
		If mv_par11 == 2   // Nao considera os lancamentos de Lucros e Perdas
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ O saldo anterior se mantem.              					 ³
			//³ Debito e Credito devem ser recalculados.  					 ³
			//³ O saldo atual deve ser recalculado pela soma dos saldos acima³
			//³ citados.                                  					 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SI3->I3_PERLP == cPeriodo
				nDebito  := nDebito  - SI3->I3_VLRLPD
				nCredito := nCredito - SI3->I3_VLRLPC
			EndIf
		EndIf	
		
		// Verifica se deve imprimir sinteticas zeradas
		If (Int(nSalant*100)/100) == 0 .And. (Int(nDebito*100)/100) == 0;
			.And. (Int(nCredito*100)/100) == 0
			If SI1->I1_CLASSE = "A"
				dbSkip()
				Loop
			EndIF
			If SI1->I1_CLASSE = "S" .and. mv_par12 = 2
				dbSkip()
				Loop
			EndIf
		Endif	

		// Grava contas de totalizacao (a primeira ‚ a analitica totalizadora
		// dos itens)
		dbSelectArea("TRB")
		cCodProcurado := Substr(SI3->I3_CUSTO,1,nTamMax)
		If !dbSeek(	cCodProcurado+Space(nTamCusto -;
						Len(cCodProcurado))+SI3->I3_CONTA)
			RecLock("TRB", .T.)
			Replace CC			With Substr(SI3->I3_CUSTO,1,nTamMax)
			Replace CODIGO   	With SI3->I3_CONTA
			Replace DC			With cDigito
			Replace CLASSE		With "A"
		Else
			RecLock("TRB", .F.)
		EndIf
		// Grava a totalizadora
		Replace SALDOANT	With SALDOANT + nSalAnt
		Replace DEBITO		With DEBITO + nDebito
		Replace CREDITO 	With CREDITO + nCredito
		Replace SALDOATU With SALDOATU + ((nSalant - nDebito ) + nCredito)
		MsUnLock()

		nTotDeb 	+= nDebito
		nTotCrd	+= nCredito
		nTotSal	+= nSalant
		
		If mv_par08 == 1
			If cCtaSup == "S"
				r380Si1Cta(	nDebito,nCredito,nSalant,;
								cCodProcurado+Space(nTamCusto -;
								Len(cCodProcurado)))			
			Else
				// Atualizacao de sinteticas do SI1 quando nao utiliza conta superior
				r380Si1S(nDebito,nCredito,nSalant,cMascara,;
							cCodProcurado+Space(nTamCusto -;
							Len(cCodProcurado)))							
			EndIf				
		EndIf	

		dbSelectArea("SI3")
		dbSkip()
	EndDo
	
	// Atualizacao de sinteticas do SI3
	r380Si3S(cMascCus,nTotDeb,nTotCrd,nTotSal,cCusto,nTamCusto)
	
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Lˆ o Arquivo de Trabalho.                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbGoTop()
SetRegua(RecCount())

While !Eof()

	If lEnd
		@Prow()+1,0 PSAY OemToAnsi(STR0007)
		Exit
	EndIF

	cCentroCus := TRB->CC

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Quebra por Centro de Custo.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRB")
	cConta := TRB->CODIGO
	nCont	 := 0		
	lFirst := .T.
	
	While TRB->CC == cCentroCus .And. !Eof() .And. !lEnd

		cConta 		:= TRB->CODIGO

		If lEnd
			@Prow()+1,0 PSAY OemToAnsi(STR0007)
			Exit
		EndIF

		IncRegua()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do Cabecalho Padrao e do Centro de Custo.       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If li > 55 
			// quebra pagina pois estourou o numero de linhas
			Cabec1 := OemToAnsi(STR0008)
			ConCgcCabec(Titulo, Cabec1, cabec2, nomeprog, tamanho)
			R380Custo(TRB->CC,limite,.T.,cMascCus)
		ElseIf lFirst .And. mv_par09 == 1
			// Quebrou centro de custo (lfirst) e deseja pular pagina
			Cabec1 := OemToAnsi(STR0008)
			ConCgcCabec(Titulo, Cabec1, cabec2, nomeprog, tamanho)
			R380Custo(TRB->CC,limite,.T.,cMascCus)
		ElseIf lFirst .And. mv_par09 == 2
			// Quebrou centro de custo (lfirst) e nao quer pular pagina
			li++
			R380Custo(TRB->CC,limite,.F.,cMascCus)
		EndIf	
		lFirst := .F.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao da Conta.                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		R380Conta(lEstrang,cDIgVer,nDecimais)

		dbSelectArea("TRB")
		dbSkip()
	
	EndDo
	
	If li > 60
		R380Custo(cCentroCus,limite,.F.,cMascCus)
	EndIf
	
	dbSelectArea("TRB1")
	If	dbSeek(cCentroCus)
		li++
		@ li, 010 pSay OemToAnsi(STR0012) + Mascara(cCentroCus,cMascCus) // "Total - " 
		ValorContab(TRB1->SALDOANT,li,058,17,nDecimais,.T.,lEstrang)
		ValorContab(TRB1->DEBITO,li,078,16,nDecimais,.F.,lEstrang,"D")
		ValorContab(TRB1->CREDITO,li,095,16,nDecimais,.F.,lEstrang,"C")
		ValorContab(TRB1->SALDOATU,li,112,17,nDecimais,.T.,lEstrang)
		li++
		aTotais := r380Quebra(cCentroCus,TRB->CC,cMascCus,cInvMasc,nTamMax,;
									lEstrang,limite,nDecimais)
		nTotal1 += aTotais[1]
		nTotal2 += aTotais[2]
	EndIf
			
	dbSelectArea("TRB")
End 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Total Geral                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If li != 80
	li++
	@li,00 PSAY REPLICATE("*",limite)
	li++
	@li, 39 PSAY OemToAnsi(STR0013)				//TOTAL GERAL
	ValorContab(nTotal1,li,078,17,nDecimais,.F.,lEstrang,"D")
	ValorContab(nTotal2,li,095,17,nDecimais,.F.,lEstrang,"C")
	li++
	@li,00 PSAY REPLICATE("*",limite)
	li++
	@li,0 PSAY " "
	Roda(cbcont,cbtxt,Tamanho)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta o Arquivo de Trabalho e o Indice Temporario.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbCloseArea()
FErase( cArqTRB + GetDBExtension() )
FErase( cIndTRB + OrdBagExt() )

dbSelectArea("TRB1")
dbCloseArea()
FErase( cArqTRB1 + GetDBExtension() )
FErase( cIndTRB1 + OrdBagExt() )

dbSelectAREA("SI1")

Set Filter To
If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
Endif

MS_FLUSH()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ R380Custo³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 22/03/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Impressao do Centro de Custo.                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ R380Custo()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametro ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Conr380                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R380Custo(cCentroCus,limite,lCabec,cMascCus)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa o Arquivo SI3 (Centro de Custo).                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SI3")
dbSetOrder(1)
dbSeek( xFilial() + cCentroCus )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Codigo e Descricao do Centro de Custo.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lCabec
	li++
	@li, 000 pSay Replicate("-",limite)
EndIf	
LI++
@ li, 000 PSAY "CENTRO CUSTO : " + ;
					Mascara(AllTrim(cCentroCus),cMascCus) + " - " + SI3->I3_DESC
li+=2
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ R380Conta³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 22/03/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Impressao da Conta 			                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ R380Conta()		                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Conr380                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R380Conta(lEstrang,cDigVer,nDecimais)

dbSelectArea("TRB")
If TRB->SALDOANT != 0 .Or. TRB->DEBITO != 0 .Or. TRB->CREDITO != 0 .Or.;
	TRB->SALDOATU != 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do Codigo, Nome Reduzido e Descricao da Conta.	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SI1")
	dbSetOrder(1)
	dbSeek( xFilial() + TRB->CODIGO)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao dos Valores.                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cDigVer == "S"
		If Len(Trim(SI1->I1_CODIGO)) > 15
			@li,01 PSAY Rtrim(I1_CODIGO)+I1_DC
		Else		
			@li,01 PSAY Mascara(Alltrim(I1_CODIGO)+I1_DC)
		Endif
	ElseIf Len(Trim(SI1->I1_CODIGO)) > 15
		@li,01 PSAY Trim(I1_CODIGO)
	Else		
		@li,01 PSAY Trim(Mascara(I1_CODIGO))
	EndIf
	If lEstrang
		@ li,25 PSAY Left( Space(Val(I1_NIVEL))+I1_DESCEST , 30 )
	Else
		@ li,25 PSAY Left( Space(Val(I1_NIVEL))+I1_DESC , 30 )
	EndIF
	ValorContab(TRB->SALDOANT,li,058,17,nDecimais,.T.,lEstrang,,TRB->CODIGO)
	ValorContab(TRB->DEBITO,li,078,16,nDecimais,.F.,lEstrang,,TRB->CODIGO)
	ValorContab(TRB->CREDITO,li,095,16,nDecimais,.F.,lEstrang,,TRB->CODIGO)
	ValorContab(TRB->SALDOATU,li,112,17,nDecimais,.T.,lEstrang,,TRB->CODIGO)
	li++
EndIf

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³r380CrSI3 ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 22/03/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Cria registros do SI3 no arquivo temporario                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ r380CrSi3(cCusto)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametro ³cCusto = Codigo do Centro de Custo                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Conr380                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function r380CrSI3(cCusto)

Local cAlias := Alias()

dbSelectArea("TRB1")
dbSetOrder(1)
If !dbSeek(cCusto)
	RecLock("TRB1", .T.)
	Replace CODCC		With cCusto
	Replace TIPO		With "A"
	MsUnLock()
EndIf

dbSelectArea(cAlias)
Return .T.		

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³r380Si1Cta³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 22/03/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Atualiza sint do SI1 quando utiliza Cta Superior		   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ r380Si1Cta()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Conr380                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function r380Si1Cta(nDebito,nCredito,nSalant,cCodCusto)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Conta Contabil Sintetica                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SI1")
dbSeek(xFilial()+SI1->I1_CTASUP)
While ! Eof() 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os Totais do Nivel da Conta Contabil.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRB")
	dbSeek( cCodCusto + SI1->I1_CODIGO )
	If !Found()
		RecLock("TRB", .T.)
		Replace  	CC    	With cCodCusto
		Replace 	CODIGO	With SI1->I1_CODIGO
		Replace 	DC		With cDigito
		Replace 	CLASSE	With "S"
	Else
		RecLock("TRB", .F.)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava o Saldo Anterior no Arquivo de Trabalho.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Replace SALDOANT With (SALDOANT + nSalAnt)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava o Valor de Debito ou Credito no Arquivo de Trabalho.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Replace DEBITO With (DEBITO  + nDebito)
	Replace CREDITO With (CREDITO + nCredito)
						
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava o Saldo Atual no Arquivo de Trabalho.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Replace SALDOATU With ((TRB->SALDOANT - TRB->DEBITO ) + TRB->CREDITO)
	MsUnLock()
	dbSelectArea("SI1")
	If SI1->I1_NIVEL == "1"
		Exit
		EndIf	
	dbSeek(xFilial()+SI1->I1_CTASUP)
EndDo	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ r380SI3S ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 22/03/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Atualiza sinteticas do centro de custo                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³  r380SI3S()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Conr380                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function r380Si3S(cMascCus,nTotDeb,nTotCrd,nTotSal,cCusto,nTamCusto)

Local cAlias := Alias()
Local nCont, nPosicao := 0
Local cCus

For nCont := 1 to Len(cMascCus)
	nPosicao += Val(Substr(cMascCus,nCont,1))
	cCus := 	Substr(cCusto,1,nPosicao) + ;
				Space(Len(cCusto)-Len(Substr(cCusto,1,nPosicao)))
	dbSelectArea("TRB1")

	If !dbSeek(cCus)
		RecLock("TRB1",.T.)
		Replace CODCC		With cCus
		Replace TIPO		With "S"			
	Else
		RecLock("TRB1")
	EndIf		
	// Grava totais do Centro de Custo
	dbSelectArea("TRB1")		
	Replace SALDOANT	With SALDOANT 	 + nTotSal
	Replace DEBITO		With DEBITO 	 + nTotDeb
	Replace CREDITO 	With CREDITO	 + nTotCrd
	Replace SALDOATU 	With SALDOATU	 + ((nTotSal - nTotDeb ) + nTotCrd)
	MsUnLock()

// No caso de mascara maior do que o centro de custo, nao se pode somar
// duas ou mais vezes o valor da analitica!
	If cCusto == cCus
		Exit
	EndIf	
	
Next nCont

dbSelectArea(cAlias)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ r380Quebr³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 22/03/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Efetua a quebra do Centro de Custo                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Conr380                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R380Quebra(cCentroCus,cCusto,cMascCus,cInvMasc,nTamMax,;
									lEstrang,limite,nDecimais)

Local cAlias := Alias()
Local nCont, nPos:=0, cCusAnt, cCusAtu, nPos1 := 0
Local aTotais := {0,0}

For nCont := 1 to Len(cInvMasc)-1
	nPos1		+= Val(Substr(cInvMasc,nCont,1))
	nPos		:= nTamMax - nPos1
	cCusAnt	:= Substr(cCentroCus,1,nPos)+ Space(Len(cCentroCus)-;
					Len(Substr(cCentroCus,1,nPos)))
	cCusAtu	:= Substr(cCusto,1,nPos) ;
					+ Space(Len(cCusto)-Len(Substr(cCusto,1,nPos)))

	If cCusAnt == cCentroCus
		Loop
	EndIf	

	If cCusAnt == cCusAtu
		Return {0,0}
	Endif						

	dbSelectArea("TRB1")
	
	If dbSeek(cCusAnt)
		@ li, 010 pSay OemToAnsi(STR0012) + Mascara(cCusAnt,cMascCus)
		ValorContab(TRB1->SALDOANT,li,058,17,nDecimais,.T.,lEstrang)
		ValorContab(TRB1->DEBITO,li,078,16,nDecimais,.F.,lEstrang,"D")
		ValorContab(TRB1->CREDITO,li,095,16,nDecimais,.F.,lEstrang,"C")
		ValorContab(TRB1->SALDOATU,li,112,17,nDecimais,.T.,lEstrang)
		li++
	EndIf	
	
Next nCont

li++
@li,00 pSay Replicate("-",limite)

dbSelectArea(cAlias)

aTotais := {TRB1->DEBITO,TRB1->CREDITO}

Return aTotais

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³r380Si1S  ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 22/03/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Atualiza sint do SI1 quando NAO utiliza Cta Superior		   ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ r380Si1S()  		                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Conr380                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function r380Si1S(nDebito,nCredito,nSalant,cMascara,cCodCusto)

Local cCodigo, nPosicao := 0, nCont

For nCont := Len(Alltrim(TRB->CODIGO)) To 1 Step -1
	cCodigo := Substr(TRB->CODIGO,1,nCont)
	cCodigo := cCodigo + Space(20-Len(cCodigo))
	dbSelectArea("SI1")
	If	dbSeek(xFilial()+cCodigo) .And. SI1->I1_CLASSE == "S"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza os Totais do Nivel da Conta Contabil.  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("TRB")
		If !dbSeek( cCodCusto + SI1->I1_CODIGO )
			RecLock("TRB", .T.)
			Replace	CC    	With cCodCusto
			Replace 	CODIGO	With SI1->I1_CODIGO
			Replace 	DC			With cDigito
			Replace 	CLASSE	With "S"
		Else
			RecLock("TRB", .F.)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava o Saldo Anterior no Arquivo de Trabalho.               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Replace SALDOANT With (SALDOANT + nSalAnt)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava o Valor de Debito ou Credito no Arquivo de Trabalho.   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Replace DEBITO With (DEBITO  + nDebito)
		Replace CREDITO With (CREDITO + nCredito)
						
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava o Saldo Atual no Arquivo de Trabalho.       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Replace SALDOATU With ((TRB->SALDOANT - TRB->DEBITO ) + TRB->CREDITO)
		MsUnLock()
	EndIf
Next nCont
Return

