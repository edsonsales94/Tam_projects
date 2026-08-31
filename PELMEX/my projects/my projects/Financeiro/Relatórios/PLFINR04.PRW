#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 09/08/00
#include "topconn.ch"

User Function Pelnome()        // incluido pelo assistente de conversao do AP5 IDE em 09/08/00

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CABEC1,CABEC2")
	SetPrvt("CSTRING,ARETURN,NLASTKEY,CPERG,LI,M_PAG")
	SetPrvt("WNREL,MTOTGER1,MTOTGER2,MTOTVEN,MTOTALT,MFORNECE")
	SetPrvt("MMULTA,MTOTAL,")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ PAGALF.PRG : EMISSAO DE TITULOS A PAGAR   COM VALOR DO JUROS ³
	//³ DATA       : 04.09.96                                        ³
	//³ AUTOR      : MICROSIGA / EMILIA                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Titulo := "Emissao de Titulos Vencidos"
	cDesc1 := OemToAnsi("Este programa ir  imprimir os Titulos Vencidos, de acordo")
	cDesc2 := OemToAnsi("com os parametros solicitados pelo usuario.")
	cDesc3 := OemToAnsi("")
	cAbec1 := ""
	cAbec2 := ""
	cString  := "SE2"
	aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
	nLastKey := 0
	cPerg    := PADR("PAGALF",LEN(SX1->X1_GRUPO))
	li       := 56
	m_pag    := 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte(CPERG,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01            // Do fornece                            ³
	//³ mv_par02            // Ate o fornece                         ³
	//³ mv_par03            // Do Vencto                             ³
	//³ mv_par04           //  Ate o Vencto                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Wnrel:=SetPrint(cString,"PAGALF",cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,{})

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	RptStatus({|| Corpo1() })// Substituido pelo assistente de conversao do AP5 IDE em 09/08/00 ==>         RptStatus({|| Execute(Corpo) })
Return
// Substituido pelo assistente de conversao do AP5 IDE em 09/08/00 ==>         Function Corpo
Static Function Corpo1()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Var.p/calcular acrescimos e descontos no valor do titulo     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mTotger1 := 0
	mTotger2 := 0

	cQuery := "Select *"
	cQuery += " From " + RetSQLName("SE2") + " As E2"
	cQuery += " Where D_E_L_E_T_ = ''"
	cQuery += " And E2_FILIAL = '" + SE2->(xFilial()) + "'"
	cQuery += " And E2_NOMFOR Between '" + Mv_Par01 + "' And '" + Mv_Par02 + "'"
	cQuery += " And E2_VENCREA Between '" + Dtos(Mv_Par03) + "' And '" + Dtos(Mv_Par04) + "'"
	cQuery += " And E2_BAIXA = ''"

	cQuery += " Order by E2_NOMFOR, E2_VENCREA"

	TCQUERY cQuery NEW ALIAS "TSE2"

	SetRegua(500)

	mFornece := Chr(255)

	While ! TSE2->(Eof())

		IncRegua()

		If TSE2->E2_NomFor <> mFornece
			mTotven  := 0
			mTotalt  := 0
			mFornece := E2_NOMFOR
		End If

		If li > 55
			If m_pag > 1
				@ li,001 PSAY "+"+Repli("-",143)+"+"
			Endif
			ImprTit()
		Endif

		mMulta := dDataBase - Stod(TSE2->E2_VENCREA)
		mMulta := If( mMulta < 0 , 0, mMulta)
		mTotal := TSE2->E2_VALOR + (TSE2->E2_VALOR * ((TSE2->E2_PORCJUR * mMulta) / 100))

		@ li,001 PSAY "| "+LEFT(mFornece,35)
		@ li,044 PSAY TSE2->E2_PREFIXO
		@ li,048 PSAY "-"+TSE2->E2_PARCELA
		@ li,050 PSAY "-"+TSE2->E2_NUM
		@ li,059 PSAY TSE2->E2_HIST
		@ li,103 PSAY Dtoc(Stod(TSE2->E2_EMISSAO))
		@ li,114 PSAY Dtoc(Stod(TSE2->E2_VENCREA))
		@ li,125 PSAY Transform(TSE2->E2_VALOR,"@e 999,999,999,999.99")
		@ li,145 PSAY "|"

		li++

		mTotven += TSE2->E2_VALOR
		mTotalt += mTotal

		TSE2->(dbSkip())

		If TSE2->E2_NomFor <> mFornece .And. mTotven <> 0

			@ li,001 PSAY "|"+Repli("-",143)+"|";										li++
			@ li,001 PSAY "| Total do fornecedor - "+mfornece
			@ li,098 PSAY Transform(mTotven,"@e 999,999,999,999.99")
			@ li,126 PSAY Transform(mTotalt,"@e 999,999,999,999.99")+" |";		li++
			@ li,001 PSAY "|"+Repli("-",143)+"|";										li++

			mTotger1 += mTotven
			mTotger2 += mTotalt

		End If

	End

	If mTotger1 <> 0
		@ li,001 PSAY "| Total Geral"
		@ li,098 PSAY Transform(mTotger1, "@e 999,999,999,999.99")
		@ li,126 PSAY Transform(mTotger2,"@e 999,999,999,999.99")+" |";		li++
		@ li,001 PSAY "+"+Repli("-",143)+"+"
	End If

	If aReturn[5] == 1
		Set Printer TO
		dbCommitAll()
		ourspool(wnrel)
	Endif
	MS_FLUSH()

	TSE2->(dbCloseArea())

Return Nil

// Substituido pelo assistente de conversao do AP5 IDE em 09/08/00 ==>  FUNCTION ImprTit
Static FUNCTION ImprTit()
	li:=1
	@ li,001 PSAY "+"+Repli("-",143)+"+"
	li:=li+1
	@ li,001 PSAY "|"
	@ li,002 PSAY SM0->M0_NOMECOM
	@ li,055 PSAY "EMISSAO DE TITULOS A PAGAR POR ORDEM ALFABETICA"
	@ li,128 PSAY "Emissao:"+dtoc(ddatabase)+" |"
	li:=li+1
	@ li,001 PSAY "|"+Repli("-",143)+"|"
	li:=li+1
	@ li,001 PSAY "|                                                                                                       Data        Data                        |"
	li:=li+1
	@ li,001 PSAY "| Fornecedor                             |   Num.Titulo | Historico                                  | Emissao |   Vencto |       Valor Titulo  |"
	//   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   xxx-x-xxxxxx   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  99/99/99   99/99/99   999.999.999.999,99
	// 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
	//          1         2         3         4         5         6         7         8         9        10        11        12        13   f
	li:=li+1
	@ li,001 PSAY "|"+Repli("-",143)+"|"
	li:=li+1
RETURN
