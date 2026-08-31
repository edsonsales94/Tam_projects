#include "rwmake.ch"   // incluido pelo assistente de conversao do AP5 IDE em 09/08/00

User Function Numop()
	Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2        := "de acordo com os parametros informados pelo usuario."
	Local cDesc3        := "Ordem de Pagamento"
	Local cPict         := ""
	Local titulo        := "Ordem de Pagamento"
	Local nLin          := -13
	Local Cabec1        := "."
	Local Cabec2        := "."
	Local imprime       := .T.
	Local aOrd          := {}
	Local cPerg         := PADR("NUMOP0",LEN(SX1->X1_GRUPO))

	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite      := 80
	Private tamanho     := "P"
	Private nomeprog    := "NUMOP "
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cbtxt       := Space(10)
	Private cbcont      := 00
	Private CONTFL      := 01
	Private m_pag       := 01
	Private wnrel       := "NUMOP "
	Private cString     := "SE2"

	dbSelectArea("SE2")
	dbSetOrder(1)

	Pergunte(cPerg,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Corpo    ³ Autor ³ Ronilton O. Barros    ³ Data ³ 15.01.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao do corpo do relatorio                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	Local aDriver := ReadDriver()
	li:=1
	dbSelectArea("SE2")
	dbSetOrder(3)
	dbSeek(XFILIAL("SE2")+Dtos(mv_par01),.T.)
	SetRegua(RecCount())
	While ! Eof() .And. E2_VENCREA <= mv_par02 .And. XFILIAL("SE2") == E2_FILIAL

		IncRegua()

		If LastKey() == 286 .Or. lastkey() == 27
			lContinua:= .F.
			Exit
		Endif

		li := If( li > 54 , 1, li)
		If Empty(E2_BAIXA) .Or. E2_SALDO <> 0
			ImpOP(aDriver)
		Endif

		dbSkip()
	Enddo

	If aReturn[5] == 1
		Set Printer TO 
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return

Static Function ImpOP(aDriver)
	mValp1   := E2_VALOR
	mExtenso := Extenso(If( mValp1 > 0 , mValp1, E2_VALOR),.F.,1)     
	mExtenso := Extenso(SE2->E2_VALOR)
	//nlin     := MemoLine
	dbSelectArea("SE2")
	If Left(AllTrim(Str(E2_VALOR)),1) == "1" .and.;
	Len(AllTrim(Str(E2_VALOR))) >= 7
		mExtenso := "R$ "+mExtenso+" "+Repli("*",102-Len(mExtenso))
	Else
		mExtenso := mExtenso+" "+Repli("*",105-Len(mExtenso))
	Endif
	Extenso1 := Left(mExtenso,53)
	Extenso2 := Right(mExtenso,53)
	Tam1     := 53
	Tam2     := 53
	If Right(Extenso1,1) <> " " .And. Right(Extenso1,1) <> "*" .and.;
	Left(Extenso2,1) <> " "
		While Right(Extenso1,1) <> " "
			Tam1     := Tam1 - 1
			Extenso1 := Left(Extenso1,Tam1)
			Tam2     := Tam2 + 1
		Enddo
		nDifer := 53 - Tam1
		If nDifer <> 0
			Extenso1 := Extenso1 + Repli("*",nDifer)
		Endif
		Extenso2 := Left(Right(mExtenso,Tam2),53)
	Endif

	@ 00,000 PSAY &(aDriver[aReturn[8]])
	@ li,001 PSAY "+-----------------------------------------------------------------------------+" ; li:=li+1
	@ li,001 PSAY "|          ORDEM  DE  PAGAMENTO  -  "+Alltrim(SM0->M0_NOMECOM)+Space(42-Len(Alltrim(SM0->M0_NOMECOM)))+"|" ; li:=li+1
	@ li,001 PSAY "|-----------------------------------------------------------------------------|" ; li:=li+1
	@ li,001 PSAY "|                                                               R$ "+Transform(E2_VALOR,"@e 999,999.99")+" |" ; li:=li+1
	@ li,001 PSAY "|"+Repli(" ",77)+"|"
	li:=li+1
	@ li,001 PSAY "|               "+Extenso1
	@ li,079 PSAY "|"
	li:=li+1
	@ li,001 PSAY "|"
	@ li,017 PSAY alltrim(Extenso2)
	@ li,079 PSAY "|"
	li:=li+1
	@ li,001 PSAY "|"+Repli(" ",77)+"|"
	li:=li+1
	@ li,001 PSAY "| CODIGO                                                                      |"         
	li:=li+1
	@ li,001 PSAY "|-------------+                                                               |"        
	li:=li+1
	@ li,001 PSAY "|             |"
	@ li,003 PSAY E2_NATUREZ
	@ li,047 PSAY "Manaus, "+StrZero(Day(E2_VENCTO),2)+" de "+MesExtenso(Month(E2_VENCTO))+" de "+Str(Year(E2_VENCTO),4)
	@ li,079 PSAY "|"
	li:=li+1
	@ li,001 PSAY "|-----------------------------------------------------------------------------|" ; li:=li+1
	@ li,001 PSAY "|                       NOME DO FAVORECIDO                                    |" ; li:=li+1
	@ li,001 PSAY "|                                                                             |" ; li:=li+1
	@ li,001 PSAY "|                                                                             |"
	@ li,003 PSAY E2_FORNECE+"   "+E2_NOMFOR                                                        ; li:=li+1
	@ li,001 PSAY "|-----------------------------------------------------------------------------|" ; li:=li+1
	@ li,001 PSAY "| DOCUMENTO        | TIPO       |  NUMERO        | N.CHEQUE                   |" ; li:=li+1
	@ li,001 PSAY "|                  |            |                |                            |"
	@ li,022 PSAY E2_TIPO
	@ li,004 PSAY E2_NUM
	li:=li+1
	@ li,001 PSAY "|-----------------------------------------------------------------------------|" ; li:=li+1
	@ li,001 PSAY "| VALOR            | VENCIMENTO | DESC.          | DESCONTOS |                |" ; li:=li+1
	@ li,001 PSAY "|                  |            |                | JUROS     |                |"
	@ li,002 PSAY Transform(E2_VALOR,"@e 99,999,999,999.99")
	@ li,023 PSAY E2_VENCTO
	@ li,059 PSAY Transform(E2_VALJUR,"@e 999,999,999,999.99")
	li:=li+1
	@ li,001 PSAY "|                  |            |                | LIQUIDO   |                |"
	@ li,059 PSAY Transform(E2_VALOR,"@e 999,999,999,999.99")  
	li:=li+1
	@ li,001 PSAY "|-----------------------------------------------------------------------------|" ; li:=li+1
	@ li,001 PSAY "|                      PORTADOR                  |EMITIDO POR| AUTORIZADO POR |" ; li:=li+1
	@ li,003 PSAY E2_NUMBCO
	@ li,001 PSAY "|                                                |           |                |" ; li:=li+1
	@ li,001 PSAY "|------------------------------------------------|----------------------------|" ; li:=li+1
	@ li,001 PSAY "|          NOME DO BANCO SACADO                  | HISTORICO                  |" ; li:=li+1
	@ li,001 PSAY "|                                                |                            |"
	@ li,052 PSAY E2_HIST
	li:=li+1
	@ li,001 PSAY "+-----------------------------------------------------------------------------+"
	li:=li+4
Return
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³    Fim do Programa NUMOP.PRG, Obrigado pela Aten‡Æo !                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ