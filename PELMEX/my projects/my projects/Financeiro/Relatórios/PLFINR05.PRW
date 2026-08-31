#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 09/08/00
#include "topconn.ch"

User Function Pelfor()        // incluido pelo assistente de conversao do AP5 IDE em 09/08/00

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
	//³ PELFOR.PRG : EMISSAO DE TITULOS A RECEBER COM VALOR DO JUROS ³
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
	cPerg    := PADR("PELFOR",Len(SX1->X1_GRUPo))
	li       := 56
	m_pag    := 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte(cPerg,.F.)

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
	Wnrel := SetPrint(cString,"PELFOR",cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,{})

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	RptStatus({|| Corpo1() })
Return
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
	cQuery += " And E2_FORNECE Between '" + Mv_Par01 + "' And '" + Mv_Par02 + "'"
	cQuery += " And E2_VENCREA Between '" + Dtos(Mv_Par03) + "' And '" + Dtos(Mv_Par04) + "'"
	cQuery += " And E2_BAIXA = ''"

	cQuery += " Order by E2_FORNECE, E2_VENCREA"

	TCQUERY cQuery NEW ALIAS "TSE2"

	SetRegua(500)

	mFornece := Chr(255)

	While ! TSE2->(Eof())

		IncRegua()

		If TSE2->E2_Fornece <> mFornece
			mTotven  := 0
			mTotalt  := 0
			mFornece := E2_FORNECE
		End If

		mMulta := dDataBase - Stod(TSE2->E2_VENCREA)
		mMulta := If( mMulta < 0 , 0, mMulta)
		mTotal := TSE2->E2_VALOR + (TSE2->E2_VALOR * ((TSE2->E2_PORCJUR * mMulta) / 100))

		If li > 55

			If m_pag > 1
				@ li,01 PSAY "+"+repli("-",130)+"+"
			Endif
			IMPRTIT()

		End If

		@ li,000 PSAY "| "+SubStr(TSE2->E2_NOMFOR,1,37)
		@ li,041 PSAY TSE2->E2_PREFIXO+"-"+TSE2->E2_PARCELA+"-"+TSE2->E2_NUM
		@ li,056 PSAY SubStr(TSE2->E2_HIST,1,36)
		@ li,094 PSAY Dtoc(Stod(TSE2->E2_EMISSAO))
		@ li,105 PSAY Dtoc(Stod(TSE2->E2_VENCREA))
		@ li,117 PSAY Transform(TSE2->E2_VALOR,"@e 99,999,999.99")+" |"

		li++

		mTotven += TSE2->E2_VALOR
		mTotalt += mTotal

		TSE2->(dbSkip())

		If TSE2->E2_Fornece <> mFornece .And. mTotven <> 0

			@ li,000 PSAY "|"+repli("-",130)+"|";									li++
			@ li,000 PSAY "| Total do fornecedor - "+mFornece
			@ li,102 PSAY Transform(mTotven,"@e 99,999,999.99")
			@ li,117 PSAY Transform(mTotalt,"@e 99,999,999.99")+" |";		li++
			@ li,000 PSAY "|"+repli("-",130)+"|";									li++

			mTotger1 += mTotven
			mTotger2 += mTotalt

		End If

	End

	If mTotger1 <> 0
		@ li,000 PSAY "| Total Geral"
		@ li,102 PSAY Transform(mTotger1,"@e 99,999,999.99")
		@ li,117 PSAY Transform(mTotger2,"@e 99,999,999.99")+" |";	li++
		@ li,000 PSAY "+"+repli("-",130)+"+"
	Endif

	If aReturn[5] == 1
		Set Printer TO
		dbCommitAll()
		ourspool(wnrel)
	Endif

	MS_FLUSH()

	TSE2->(dbCloseArea())

Return Nil

Static FUNCTION ImprTit()

	li:=1

	@ li,000 PSAY "+"+repli("-",130)+"+";								li++
	@ li,000 PSAY "|"
	@ li,002 PSAY SM0->M0_NOMECOM
	@ li,055 PSAY "EMISSAO DE TITULOS A PAGAR POR FORNECEDOR"
	@ li,128 PSAY "Emissao:"+dtoc(ddatabase)+" |";					li++
	@ li,000 PSAY "|"+repli("-",130)+"|";								li++
	@ li,000 PSAY "|                                                                                               Data        Data                   |";		li++
	@ li,000 PSAY "| Fornecedor                            |  Num.Titulo | Historico                            |  Emissao |   Vencto |  Valor Titulo |";		li++
	//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxx-x-xxxxxx   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  99/99/9999 99/99/9999  99.999.999,99
	//  012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	//            1         2         3         4         5         6         7         8         9        10        11        12        13
	@ li,000 PSAY "|"+repli("-",130)+"|";								li++

RETURN Nil
