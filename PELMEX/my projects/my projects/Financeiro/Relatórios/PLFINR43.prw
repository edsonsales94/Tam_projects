#include "rwmake.ch"  // incluido pelo assistente de conversao do AP5 IDE em 09/08/00
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  

User Function PLFINR43()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CABEC1,CABEC2")
	SetPrvt("CSTRING,ARETURN,NLASTKEY,CPERG,LI,M_PAG")
	SetPrvt("WNREL,NTOTGER2,MCOND,NTOTGER1,MVENCTO,")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ PELPAG    : EMISSAO DE TITULOS PAGOS /PELMEX               ³
	//³ DATA       : 27.02.23                                        ³
	//³ AUTOR      : STAN LEE LOPES                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Titulo   := "Emissao de Titulos Pagos"
	cDesc1   := OemToAnsi("Este programa ir  imprimir os Titulos Pagos, de acordo")
	cDesc2   := OemToAnsi("com os parametros solicitados pelo usuario.")
	cDesc3   := OemToAnsi("")
	cAbec1   := ""
	cAbec2   := ""
	cString  := "SE2"
	aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
	nLastKey := 0
	cPerg    := PADR("PLFINR43",LEN(SX1->X1_GRUPO))
	li       := 55
	m_pag    := 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte(CPERG,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01            // Data de vencimento                    ³
	//³ mv_par02            // Data de vencimento                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Wnrel:=SetPrint(cString,"PLFINR43",cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,{})

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
	nTotGer2 := 0
	mCond    := .F.

	dbSelectArea("SE2")
	dbSetOrder(3)
	dbSeek(XFILIAL("SE2")+Dtos(mv_par01),.T.)
	SetRegua(RecCount())
	@ 00,000 PSAY chr(15)

	While ! Eof() .And. E2_VENCREA <= mv_par02 .And. XFILIAL("SE2") == E2_FILIAL
		nTotGer1 := 0
		mVencto  := E2_VENCREA
		While mVencto == E2_VENCREA .And. ! Eof() .And. E2_VENCREA <= mv_par02 .And. XFILIAL("SE2") == E2_FILIAL

			IncRegua()

			If Empty(E2_BAIXA)
				dbSkip()
				Loop
			Endif

			If li >= 55
				If m_pag > 1
					@ li,001 PSAY "+"+Repli("-",134)+"+"
				Endif
				ImprTit()
			Endif
			@ li,001 PSAY "|"
			@ li,003 PSAY E2_PREFIXO
			@ li,006 PSAY "-"+E2_PARCELA
			@ li,008 PSAY "-"+E2_NUM
			@ li,017 PSAY E2_NOMFOR
			@ li,059 PSAY SubStr(E2_HIST,1,35)
			@ li,094 PSAY E2_EMISSAO
			@ li,105 PSAY E2_BAIXA
			@ li,116 PSAY Transform(E2_VALOR,"@e 999,999,999,999.99")+"  |"
			li:=li+1
			nTotger1 := nTotger1 + E2_VALOR

			dbSkip()
		Enddo  
		If nTotGer1 <> 0
			@ li,001 PSAY "|"+Repli("-",134)+"|"
			li:=li+1
			@ li,001 PSAY "| Total do Dia "
			@ li,116 PSAY Transform(nTotger1, "@e 999,999,999,999.99")+"  |"
			li:=li+1
			@ li,001 PSAY "+"+Repli("-",134)+"+"
			li:=li+1
			nTotGer2 := nTotGer2 + nTotGer1
		Endif
	Enddo
	If nTotGer1 <> 0
		li:=li+1
		@ li,001 PSAY "| Total Geral"
		@ li,116 PSAY Transform(nTotger2,"@e 999,999,999,999.99")+"  |"
		li:=li+1
		@ li,001 PSAY "+"+Repli("-",134)+"+"
		//@ 00,001 PSAY ""
	Endif

	If aReturn[5] == 1
		Set Printer TO
		dbCommitAll()
		ourspool(wnrel)
	Endif
	MS_FLUSH()
Return

Static FUNCTION ImprTit()
	li:=1
	@ LI,001 PSAY "+" + REPLI("-",134) + "+"
	LI:=LI+1
	@ li,001 PSAY "|"
	@ li,002 PSAY SM0->M0_NOMECOM  
	@ li,117 PSAY "Emissao: "+ dtoc(ddatabase)
	@ LI,136 PSAY "|"
	LI:=LI+1
	@ li,001 PSAY "| SIGA\PLFINR43.PRW                                   EMISSAO DE TITULOS PAGOS"  
	@ li,128 PSAY "Pag.: "+alltrim(str(m_pag))
	@ li,136 PSAY "|"
	LI:=LI+1
	@ li,001 PSAY "|"+REPLI("-",134)+"|"
	LI:=LI+1                                                                                                                                           
	@ li,001 PSAY "|                                                                                              Data        Data                        |"
	li:=li+1
	@ li,001 PSAY "|  Num.Titulo | Fornecedor                              | Historico                         | Emissao |    Baixa  |      Valor Titulo  |"
	//              xxx-x-xxxxxx
	//            12345678901234567890
	//                     1         2
	li:=li+1
	@ li,001 PSAY "|"+repli("-",134)+"|"
	li:=li+1
	m_pag:=m_pag+1
RETURN
