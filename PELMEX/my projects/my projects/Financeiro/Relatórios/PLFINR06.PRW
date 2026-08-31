#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 09/08/00
#include "topconn.ch"

User Function Numop1()        // incluido pelo assistente de conversao do AP5 IDE em 09/08/00

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
	SetPrvt("NLASTKEY,CPERG,LI,M_PAG,WNREL,LCONTINUA")
	SetPrvt("MVALP1,MEXTENSO,NLIN,EXTENSO1,EXTENSO2,TAM1")
	SetPrvt("TAM2,NDIFER,")

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ NUMOP    ³ Autor ³ Ronilton O. Barros    ³ Data ³ 20/09/96 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Emissao de Ordem de Pagamento  RDMAKE.                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Gen‚rico                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Titulo   := "EMISSAO DE ORDEM DE PAGAMENTO"
	cDesc1   := OemToAnsi("Este programa ir  emitir as Ordem de Pagamento")
	cDesc2   := OemToAnsi("utilizando recursos do SIGA Advanced.")
	cDesc3   := OemToAnsi("")
	cString  := "SE2"
	aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
	nLastKey := 0
	cPerg    := PADR("NUMOP1",LEN(SX1->X1_GRUPO))
	li       := -13
	m_pag    := 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas, busca o padrao da NFPARV ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte(CPERG,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01             // Da Duplicata                         ³
	//³ mv_par02             // At‚ a Duplicata                      ³
	//³ mv_par03             // Serie                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel:=SetPrint(cString,"NUMOP1",cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"")

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	RptStatus({|| Corpo3() })// Substituido pelo assistente de conversao do AP5 IDE em 09/08/00 ==>         RptStatus({|| Execute(Corpo) })
Return
// Substituido pelo assistente de conversao do AP5 IDE em 09/08/00 ==>         Function Corpo
Static Function Corpo3()

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

	cQuery := "Select *"
	cQuery += " From " + RetSQLName("SE2") + " As E2"
	cQuery += " Where D_E_L_E_T_ = ''"
	cQuery += " And E2_FILIAL = '" + SE2->(xFilial()) + "'"
	cQuery += " And E2_VENCREA Between '" + Dtos(Mv_Par01) + "' And '" + Dtos(Mv_Par02) + "'"
	cQuery += " And E2_NUM Between '" + Mv_Par03 + "' And '" + Mv_Par04 + "'"

	cQuery += " Order by E2_VENCREA, E2_NUM"

	TCQUERY cQuery NEW ALIAS "TSE2"

	SetRegua(500)

	li := 1

	While ! TSE2->(Eof())

		IncRegua()

		If LastKey() == 286 .Or. LastKey() == 27
			lContinua:= .F.
			Exit
		Endif

		ImpOP()

		li := If (li > 60 , 1, li)

		TSE2->(dbSkip())

	End

	If aReturn[5] == 1
		Set Printer TO
		dbcommitAll()
		ourspool(wnrel)
	Endif

	MS_FLUSH()

	TSE2->(dbCloseArea())

Return Nil

// Substituido pelo assistente de conversao do AP5 IDE em 09/08/00 ==>  Function ImpOP
Static Function ImpOP()

	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(XFILIAL("SA2")+TSE2->E2_FORNECE,.T.)

	mValp1   := TSE2->E2_VALOR
	mExtenso := Extenso(If( mValp1 > 0 , mValp1, TSE2->E2_VALOR),.F.,1)
	mExtenso := Extenso(TSE2->E2_VALOR)

	If Left(AllTrim(Str(TSE2->E2_VALOR)),1) == "1" .And.;
	Len(AllTrim(Str(TSE2->E2_VALOR))) >= 7
		mExtenso := "R$ "+mExtenso+" "+Repli("*",102-Len(mExtenso))
	Else
		mExtenso := mExtenso+" "+Repli("*",105-Len(mExtenso))
	End if

	Extenso1 := Left(mExtenso,53)
	Extenso2 := Right(mExtenso,53)
	Tam1     := 53
	Tam2     := 53

	If Right(Extenso1,1) <> " " .And. Right(Extenso1,1) <> "*" .And. Left(Extenso2,1) <> " "

		While Right(Extenso1,1) <> " "
			Tam1--
			Extenso1 := Left(Extenso1,Tam1)
			Tam2++
		End

		nDifer := 53 - Tam1

		If nDifer <> 0
			Extenso1 := Extenso1 + Repli("*",nDifer)
		Endif

		Extenso2 := Left(Right(mExtenso,Tam2),53)

	End If

	@ li,001 PSAY "+-----------------------------------------------------------------------------+" ;	li++
	@ li,001 PSAY "|          ORDEM  DE  PAGAMENTO  - "
	@ li,037 PSAY " PELMEX DA AMAZONIA LTDA                  |";													li++
	@ li,001 PSAY "|-----------------------------------------------------------------------------|" ;	li++
	@ li,001 PSAY "|" + Space(63) + "R$ "+Transform(TSE2->E2_VALOR,"@e 999,999.99")+" |";					li++
	@ li,001 PSAY "|"+Repli(" ",77)+"|";																					li++
	@ li,001 PSAY "|" + Space(15) + Extenso1
	@ li,079 PSAY "|";																											li++
	@ li,001 PSAY "|" + Space(15) + AllTrim(Extenso2)
	@ li,079 PSAY "|";																											li++
	@ li,001 PSAY "|"+Repli(" ",77)+"|";																					li++
	@ li,001 PSAY "| CODIGO                                                                      |";	li++
	@ li,001 PSAY "|-------------+                                                               |";	li++
	@ li,001 PSAY "| "+TSE2->E2_NATUREZ+"  |" + Space(31) + "Manaus, " + StrZero(Day(Stod(TSE2->E2_VENCTO)),2)+" de " + MesExtenso(Month(Stod(TSE2->E2_VENCTO)))+" de "+Str(Year(Stod(TSE2->E2_VENCTO)),4)
	@ li,079 PSAY "|";																											li++
	@ li,001 PSAY "|-----------------------------------------------------------------------------|";	li++
	@ li,001 PSAY "|                       NOME DO FAVORECIDO                                    |";	li++
	@ li,001 PSAY "|                                                                             |";	li++
	@ li,001 PSAY "| " + TSE2->E2_FORNECE+"   "+SA2->A2_NOME
	@ li,079 PSAY "|";																											li++
	@ li,001 PSAY "|-----------------------------------------------------------------------------|";	li++
	@ li,001 PSAY "| DOCUMENTO        | TIPO       |  NUMERO        | N.CHEQUE                   |";	li++
	@ li,001 PSAY "| "+TSE2->E2_NUM+Space(8)+"| "+TSE2->E2_TIPO+Space(08)+"|                |                            |";	li++
	@ li,001 PSAY "|-----------------------------------------------------------------------------|";	li++
	@ li,001 PSAY "| VALOR            | VENCIMENTO | DESC.          | DESCONTOS |                |";	li++
	@ li,001 PSAY "|                  |            |                | JUROS     |                |"
	@ li,002 PSAY Transform(TSE2->E2_VALOR,"@e 99,999,999,999.99")
	@ li,023 PSAY Stod(TSE2->E2_VENCTO)
	@ li,059 PSAY Transform(TSE2->E2_VALJUR,"@e 999,999,999,999.99");												li++
	@ li,001 PSAY "|                  |            |                | LIQUIDO   |                |"
	@ li,059 PSAY Transform(TSE2->E2_VALOR,"@e 999,999,999,999.99");												li++
	@ li,001 PSAY "|-----------------------------------------------------------------------------|";	li++
	@ li,001 PSAY "|                      PORTADOR                  |EMITIDO POR| AUTORIZADO POR |";	li++
	@ li,001 PSAY "| "  + TSE2->E2_NUMBCO  +   Space(31)   +      " |           |                |";	li++
	@ li,001 PSAY "|------------------------------------------------|----------------------------|";	li++
	@ li,001 PSAY "|          NOME DO BANCO SACADO                  | HISTORICO                  |";	li++
	@ li,001 PSAY "|                                                | " + TSE2->E2_HIST  +    "  |";	li++
	@ li,001 PSAY "+-----------------------------------------------------------------------------+";	li += 4

Return Nil
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³    Fim do Programa NUMOP.PRX, Obrigado pela Aten‡Æo !                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
