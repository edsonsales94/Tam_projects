#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02
#include "fina360.ch"

User Function Fina360()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NOPCA,CSAVSCR1,CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1")
SetPrvt("ODLG,ABUTTONS,ASAYS,CCADASTRO,NVALFORTE,I")
SetPrvt("LFLAG,NPARORIG,MV_PAR01,CCPOTP,CTPDOC,CHISTMOV")
SetPrvt("CALIAS,APERG,CPERG,")

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINA360    ³ Autor ³ Wagner Xavier         ³ Data ³ 07.04.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reprocessamento arquivos do Financeiro.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FINA360()                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOpca := 0

#IFNDEF WINDOWS
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Salva a Integridade dos dados de Entrada                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSavScr1 := SaveScreen(3,0,24,79)
	cSavCur1 := SetCursor(0)
	cSavRow1 := Row()
	cSavCol1 := Col()
	cSavCor1 := SetColor("bg+/b,,,")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Salva a linha que mostrara' o cursor                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DispBegin()
	ScreenDraw("SMT250", 3, 0, 0, 0)
	SetColor( "w+/w" )
	@3,10 Clear To 3,25
	SetColor("n/w,,,")
	@ 17,05 SAY Space(71)
	DispEnd()
#ELSE
        oDlg     := ""
        aButtons := {}
        aSays    := {}
#ENDIF

cCadastro := "Refaz Acumulados"

AjustaSx1()

Pergunte("AFI360",.T.)

/*
#IFDEF WINDOWS

        AADD(aSays, "Este programa tem como objetivo recalcular e analisar os arquivos do  ")
        AADD(aSays, "m¢dulo financeiro, verificando sua integridade e se poss¡vel refazendo")
        AADD(aSays, "seus acumulados.                                                      ")

	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	FormBatch( cCadastro, aSays, aButtons )
#ENDIF
*/

Processa({|lEnd| fa360Processa()})  // Chamada da funcao de recalculos
	
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fa360Process³ Autor ³ Wagner Xavier         ³ Data ³ 07.04.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Reprocessamento arquivos do Financeiro.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fa360Processa()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nao ha'                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function Fa360Processa
Static Function Fa360Processa()
	
nValForte := 0
i         := 0
lFlag     := .F.
nParOrig  := mv_par01 // Valor original do mv_par01
	
ProcRegua(SE1->(RecCount())+SE2->(RecCount()))
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulos a Receber                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SE1" )
dbSeek( cFilial )
While !Eof() .and.E1_FILIAL == cFilial
		
	IncProc()
		

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preve a situacao de :                                                     ³
	//³ SE2 OU SE1 compartilhado e SE5 exclusivo, pois neste caso as baixas nao   ³
	//³poderao se refeitas pois nao se tem a filial original do titulo.           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (Empty(SE1->E1_FILIAL)) .and. !Empty(SE5->E5_FILIAL)
		mv_par01 := 2		// for‡a para nao refazer as baixas
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza Moeda                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If SE1->E1_MOEDA == 0 .Or. Empty(SE1->E1_MOEDA)
                Reclock( "SE1",.f. )
		SE1->E1_MOEDA := 1
		MsUnlock()
	Endif
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza status do titulo					                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        RecLock("SE1",.f.)
	SE1->E1_STATUS := Iif(SE1->E1_SALDO>0.01,"A","B")
	MsUnlock( )
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza situa‡ao, se estiver em branco                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If  SE1->E1_SITUACA == " "
                Reclock( "SE1",.f. )
		SE1->E1_SITUACA := "0"
		MsUnlock( )
	Endif
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valor em Reais                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        IF  SE1->E1_VLCRUZ == 0 .Or. Empty( SE1->E1_VLCRUZ )
                Reclock( "SE1",.f. )
		SE1->E1_VLCRUZ := xMoeda( SE1->E1_VALOR,SE1->E1_MOEDA,1,SE1->E1_EMISSAO )
		MsUnlock( )
	Endif
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza Nome do Cliente                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "SA1" )
	If (dbSeek( cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA ) )
                Reclock( "SE1",.f. )
		SE1->E1_NOMCLI := SA1->A1_NREDUZ
		MsUnlock( )
	Endif
		
	dbSelectArea( "SE1" )
	IF Empty( SE1->E1_BAIXA ) .or. !Empty(SE1->E1_FATURA)
		dbSkip()
		Loop
	Endif
		
	If mv_par01 == 1		// refaz as baixas

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Localiza as baixas                                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For i:=1 To 5
			dbSelectArea( "SE5" )
			IF i==1
				cCpoTp:="SE1->E1_DESCONT"
				cTpDoc:=IIF(SE1->E1_SITUACA$"27","D2","DC")
				cHistMov:="Desconto s/Receb.Titulo"
			Elseif i==2
				cCpoTp:= "SE1->E1_JUROS"
				cTpDoc:=IIF(SE1->E1_SITUACA$"27","J2","JR")
				cHistMov:="Juros s/Receb.Titulo"
			Elseif i==3
				cCpoTp:= "SE1->E1_MULTA"
				cTpDoc:=IIF(SE1->E1_SITUACA$"27","M2","MT")
				cHistMov:="Multa s/Receb.Titulo"
			Elseif i==4
				cCpoTp:= "SE1->E1_CORREC"
				cTpDoc:=IIF(SE1->E1_SITUACA$"27","C2","CM")
				cHistMov:="Correcao Monet s/Receb.Titulo"
			Elseif i==5
				cCpoTp:= "SE1->E1_VALLIQ"
				cTpDoc:=IIF(SE1->E1_SITUACA$"27","V2","VL")
				cHistMov:="Valor recebido s/ Titulo"
			Endif
			
			If &cCpoTp != 0
				dbSetOrder( 2 )
				If !(dbSeek( cFilial+cTpDoc+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+DtoS(SE1->E1_BAIXA)))
					If  cTpDoc == "VL"
						cCpoTp:= "SE1->E1_VALLIQ"
						cTpDoc:=IIF(SE1->E1_SITUACA$"27","B2","BA")
						cHistMov:="Valor recebido s/ Titulo"
						lFlag := !(dbSeek( cFilial+cTpDoc+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+DtoS(SE1->E1_BAIXA)))
					Else
						lFlag := .t.
					Endif
				Else
					lFlag := .f.
				Endif
				
				If lFlag
					If (dbSeek( cFilial+"CP"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+DtoS(SE1->E1_BAIXA)))
						lFlag := .f.
					Endif
					If lFlag
						If (dbSeek( cFilial+"LJ"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+DtoS(SE1->E1_BAIXA)))
							lFlag := .f.
						Endif
					Endif
				Endif
				
				If lFlag
					Reclock( "SE5" , .T. )
					SE5->E5_FILIAL := cFilial
					SE5->E5_NUMERO := SE1->E1_NUM
					SE5->E5_PREFIXO:= SE1->E1_PREFIXO
					SE5->E5_PARCELA:= SE1->E1_PARCELA
					SE5->E5_TIPO   := SE1->E1_TIPO
					SE5->E5_CLIFOR := SE1->E1_CLIENTE
					SE5->E5_LOJA   := SE1->E1_LOJA
					SE5->E5_RECPAG := "R"
					SE5->E5_VALOR  := &cCpoTp
					SE5->E5_VLMOED2:= xMoeda(SE5->E5_VALOR,1,SE1->E1_MOEDA,SE1->E1_BAIXA)
					SE5->E5_DATA   := SE1->E1_BAIXA
					SE5->E5_DTDIGIT:= SE1->E1_BAIXA
					SE5->E5_NATUREZ:= SE1->E1_NATUREZ
					SE5->E5_BANCO  := SE1->E1_PORTADO
					SE5->E5_AGENCIA:= SE1->E1_AGEDEP
					SE5->E5_CONTA	:= SE1->E1_CONTA
					SE5->E5_BENEF  := SE1->E1_NOMCLI
	        	   SE5->E5_HISTOR := chistMov
					SE5->E5_TIPODOC:= cTpDoc
					SE5->E5_MOTBX  := "NOR"
					SE5->E5_DTDISPO:= SE5->E5_DATA
					MsUnlock()
				Endif
			Endif
		Next i
	Endif
	dbSelectArea( "SE1" )
	dbSkip()
Enddo
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preve a situacao de :                                                     ³
//³ SE2 OU SE1 compartilhado e SE5 exclusivo, pois neste caso as baixas nao   ³
//³poderao se refeitas pois nao se tem a filial original do titulo.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mv_par01 := nparorig 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulos a Pagar                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SE2" )
dbSeek( cFilial )
	
While !Eof() .and. E2_FILIAL == cFilial
		
	IncProc()
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preve a situacao de :                                                     ³
	//³ SE2 OU SE1 compartilhado e SE5 exclusivo, pois neste caso as baixas nao   ³
	//³poderao se refeitas pois nao se tem a filial original do titulo.           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mv_par01 := nParOrig  // Reconstitui mv_par01 com seu valor original
	If (Empty(SE2->E2_FILIAL)) .and. !Empty(SE5->E5_FILIAL)
		mv_par01 := 2		// for‡a para nao refazer as baixas
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza Moeda                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If SE2->E2_MOEDA == 0 .Or. Empty(SE2->E2_MOEDA)
                Reclock( "SE2",.f. )
		SE2->E2_MOEDA := 1
		MsUnlock()
	Endif
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valor em Reais                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        IF SE2->E2_VLCRUZ == 0 .Or. Empty( SE2->E2_VLCRUZ )
                Reclock( "SE2",.f. )
		SE2->E2_VLCRUZ := xMoeda( SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO )
		MsUnlock( )
	Endif
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza Nome do Fornecedor                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "SA2" )
	If (dbSeek( cFilial+SE2->E2_FORNECE+SE2->E2_LOJA ) )
                Reclock( "SE2",.f. )
		SE2->E2_NOMFOR := SA2->A2_NREDUZ
		MsUnlock( )
	Endif
		
	IF Empty( SE2->E2_BAIXA ) .or. !Empty(SE2->E2_FATURA)
		dbSelectArea( "SE2" )
		dbSkip( )
		Loop
	Endif
		
	If mv_par01 == 1		// Refaz as baixas
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Localiza as baixas                                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For i:=1 To 5
			dbSelectArea( "SE5" )
			IF  i==1
				cCpoTp  :="SE2->E2_DESCONT"
				cTpDoc  :="DC"
				cHistMov:=STR0010  //"Desconto s/Pagto Titulo"
			Elseif i==2
				cCpoTp  := "SE2->E2_JUROS"
				cTpDoc  := "JR"
				cHistMov:=STR0011  //"Juros s/ Pagto Titulo"
			Elseif i==3
				cCpoTp  := "SE2->E2_MULTA"
				cTpDoc  := "MT"
				cHistMov:=STR0012  //"Multa s/ Pagto Titulo"
			Elseif i==4
				cCpoTp  := "SE2->E2_CORREC"
				cTpDoc  := "CM"
				cHistMov:=STR0013  //"Correcao Pagto Titulo"
			Elseif i==5
				cCpoTp  := "SE2->E2_VALLIQ"
				cTpDoc  := "VL"
				cHistMov:=STR0014  //"Valor Pago s/ Titulo"
			Endif
			
			If &cCpoTp != 0
				dbSetOrder( 2 )
				If !(dbSeek( cFilial+cTpDoc+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+DtoS(SE2->E2_BAIXA)+SE2->E2_FORNECE))
					IF cTpDoc == "VL"
						cCpoTp:= "SE2->E2_VALLIQ"
						cTpDoc:="BA"
						cHistMov:=STR0015  //"Valor recebido s/ Titulo"
						lFlag := !(dbSeek( cFilial+cTpDoc+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+DtoS(SE2->E2_BAIXA)+SE2->E2_FORNECE))
						cTpDOc := "VL"
					Else
						lFlag := .t.
					Endif
				Else
					lFlag := .f.
				Endif
				
				If lFlag
					lFlag := !(dbSeek( cFilial+"CP"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+DtoS(SE2->E2_BAIXA)+SE2->E2_FORNECE))
				EndIf
				
				IF lFlag
					Reclock( "SE5" , .T. )
					SE5->E5_FILIAL := cFilial
					SE5->E5_NUMERO := SE2->E2_NUM
					SE5->E5_PREFIXO:= SE2->E2_PREFIXO
					SE5->E5_PARCELA:= SE2->E2_PARCELA
					SE5->E5_TIPO   := SE2->E2_TIPO
					SE5->E5_CLIFOR := SE2->E2_FORNECE
					SE5->E5_LOJA   := SE2->E2_LOJA
					SE5->E5_RECPAG := "P"
					SE5->E5_VALOR  := &cCpoTp
					SE5->E5_VLMOED2:= xMoeda(SE5->E5_VALOR,1,SE2->E2_MOEDA,SE2->E2_BAIXA)
					SE5->E5_DATA   := SE2->E2_BAIXA
					SE5->E5_DTDIGIT:= SE2->E2_BAIXA
					SE5->E5_NATUREZ:= SE2->E2_NATUREZ
					SE5->E5_BANCO  := SE2->E2_BCOPAG
					SE5->E5_BENEF  := SE2->E2_NOMFOR
					SE5->E5_HISTOR := chistMov
					SE5->E5_TIPODOC:= cTpDoc
					SE5->E5_MOTBX  := "NOR"
					SE5->E5_DTDISPO:= SE5->E5_DATA
					MsUnlock( )
				Endif
			Endif
		Next i
	Endif	
	dbSelectArea( "SE2" )
	SE2->( dbSkip( ) )
Enddo
dbSelectArea( "SE1" )
dbSetOrder(1)
dbSelectArea( "SE5" )
dbSetOrder(1)
MsUnlockAll()



Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function AjustaSx1
Static Function AjustaSx1()

cAlias:=Alias()
aPerg:={}
cPerg := "AFI360"
Aadd(aPerg,{"Refaz Baixas (SE5)    ?","N",1})

dbSelectArea("SX1")
If !dbSeek(cPerg+"01")
	RecLock("SX1",.T.)
	Replace X1_GRUPO   	with cPerg
	Replace X1_ORDEM   	with "01"
	Replace X1_PERGUNT 	with aPerg[1][1]
	Replace X1_VARIAVL 	with "mv_ch1"
	Replace X1_TIPO	 	with aPerg[1][2]
	Replace X1_TAMANHO 	with aPerg[1][3]
	Replace X1_PRESEL  	with 2
	Replace X1_GSC	   	with "C"
	Replace X1_VAR01   	with "mv_par01"
	Replace X1_DEF01   	with "Sim"
	Replace X1_DEF02   	with "Nao"
	MsUnlock()
EndIf
dbSelectArea(cAlias)
Return
