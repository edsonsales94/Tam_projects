#include "rwmake.ch"  // incluido pelo assistente de conversao do AP5 IDE em 09/08/00
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PLFATR01  ºAutor  ³Microsiga           º Data ³  12/17/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Mostra a relacao de notas fiscais vendidas num determinadoº±±
±±º          ³  período antigo IMPNOT                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PLFATR01()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
	SetPrvt("NLASTKEY,CPERG,M_PAG,LI,WNREL,MGERAL")

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³ IMPNOT   ³ Autor ³  Ronilton O. Barros   ³ Data ³ 28.09.98 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Emissao das Notas Fiscais de um determinado periodo        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Gen‚rico                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Titulo   := "Lista de Notas Fiscais emitidas num determinado periodo"
	cDesc1   := OemToAnsi("Este programa emitira todas as notas fiscais resumidamente de")
	cDesc2   := OemToAnsi("um determinado periodo, utilizando recursos do SIGA Advanced.")
	cDesc3   := OemToAnsi("")
	cString  := "SF2"
	aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
	nLastKey := 0
	cPerg    := PADR("FATR01",Len(SX1->X1_GRUPO))
	m_pag    := 1
	li       := 60
	cFilterUser := ""
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas, busca o padrao da NFPARV ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	pergunte(cPerg,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01             // Da Emissao                           ³
	//³ mv_par02             // Ate a Emissao                        ³ 
	//³ mv_par03             // Imprimir ? Faturamento Todos         ³ 
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel:=SetPrint(cString,"PLFATR01",cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"")

	If nLastKey == 27
		Set Filter To
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Set Filter To
		Return
	Endif

	RptStatus({|| Corpo1() },"Notas Fiscais")
	Return                    

	**************************
Static Function Corpo1()  
	**************************
	cFilterUser := aReturn[7]
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicio do Programa                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mGeral  := 0
	cCabec1 := "EMISSAO    N.F.    CODIGO   NOME                           VALOR DA NOTA"
	//       99/99/99   XXXXXX   XXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXX   9,999,999.999,99
	//       0123456789012345678901234567890123456789012345678901234567890123456789012
	//                 1         2         3         4         5         6         7

	//dbSelectArea("SF2")
	//dbSetOrder(8)
	//dbSeek(XFILIAL("SF2")+dtos(mv_par01),.T.)

	GeraArq()
	SetRegua(Wrk->(RecCount()))
	//SA1->(dbSetOrder(1))
	//SD2->(dbSetOrder(3))
	//SF4->(dbSetOrder(1))

	dbSelectArea("Wrk")

	While !Wrk->(Eof())

		IncRegua()

		/*SA1->(dbSeek(XFILIAL("SA1")+Wrk->F2_CLIENTE))
		SD2->(dbSeek(XFILIAL("SD2")+Wrk->F2_DOC+Wrk->F2_SERIE+Wrk->F2_CLIENTE+Wrk->F2_LOJA))
		SF4->(dbSeek(XFILIAL("SF4")+SD2->D2_TES))
		If (mv_par03 == 1 .And. SF4->F4_DUPLIC <> "S")// .Or. !(F2_SERIE $ GetMv("MV_SERPEL"))
		Wrk->(dbSkip())
		Loop
		Endif
		*/
		If !Empty(cFilterUser).and.!(&cFilterUser)
			Wrk->(dbSkip())
			Loop
		Endif

		If li >= 59
			If m_pag > 1
				@ li,000 PSAY repli("-",080)
			Endif
			Imprtit()
		Endif
		@ li,000 PSAY Wrk->F2_EMISSAO
		@ li,011 PSAY Wrk->F2_DOC
		@ li,020 PSAY Wrk->F2_CLIENTE
		@ li,029 PSAY SubStr(Wrk->A1_NOME,1,25)
		@ li,057 PSAY Wrk->D2_TOTAL PICTURE "@E 9,999,999,999.99"
		li:=li+1
		mGeral := mGeral + Wrk->D2_TOTAL

		Wrk->(dbSkip())
	End
	If mGeral <> 0
		li:=li+2
		@ li,000 PSAY "TOTAL GERAL -->>"
		@ li,057 PSAY mGeral PICTURE "@E 9,999,999,999.99"
		li:=li+1
		@ li,000 PSAY repli("-",090)
		@ 65,056 PSAY "-------------------------------"
		//@ 59,046 PSAY "   Departamento Setor Fiscal"
		//@ 00,000 PSAY " "
	Endif
	Wrk->(dbCloseArea())
	If aReturn[5] == 1
		Set Printer TO 
		dbcommitAll()
		ourspool(wnrel)
	Endif
	MS_FLUSH()
Return

Static Function ImprTit()
	li:=1
	@ 00,000 PSAY CHR(18)
	@ li,000 PSAY repli("-",080)
	li:=li+1
	@ li,000 PSAY SM0->M0_NOMECOM      
	li:=li+1
	@ li,028 PSAY "RELACAO DE NOTAS FISCAIS"
	@ li,073 PSAY "Emissao: "+dtoc(ddatabase)
	li:=li+1
	@ li,000 PSAY "Hora..:"+Time()
	@ li,073 PSAY "Pagina.: " +StrZero(m_pag,2)
	li:=li+1 
	@ li,000 PSAY repli("-",80)
	li:=li+1
	@ li,000 PSAY "PERIODO DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02)
	li:=li+1 
	@ li,000 PSAY repli("-",80)
	li:=li+1                                                                                    
	@ li,000 PSAY cCabec1
	li:=li+1
	@ li,000 PSAY repli("-",080)
	li:=li+1
	m_pag:=m_pag+1
	Return
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³    Fim do Programa IMPNOT.PRX, Obrigado pela Aten‡Æo !                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	***********************************
	*Criada por Stan Lee Lopes em 28/01/19*
	***********************************
Static Function GeraArq()
	Local cQry := ""

	cQry := "SELECT F2_EMISSAO,F2_DOC,F2_CLIENTE,A1_NOME,SUM(D2_TOTAL)D2_TOTAL "
	cQry += "FROM "+RetSqlName("SF2")+" SF2 "
	cQry += "INNER JOIN "+RetSqlName("SD2")+" SD2 ON SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.D_E_L_E_T_ = '' AND SD2.D_E_L_E_T_ ='' "
	cQry += "INNER JOIN "+RetSqlName("SF4")+" SF4 ON SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = '' "
	cQry += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON SF2.F2_CLIENTE = SA1.A1_COD AND SF2.F2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = '' "
	cQry += "LEFT JOIN "+RetSqlName("SD1")+" SD1 ON SD2.D2_FILIAL = SD1.D1_FILIAL AND SD2.D2_DOC = SD1.D1_NFORI AND SD2.D2_SERIE = SD1.D1_SERIORI AND SD2.D2_ITEM = SD1.D1_ITEMORI AND SD2.D2_COD = SD1.D1_COD AND SD1.D_E_L_E_T_ = '' "
	cQry += "WHERE F2_FILIAL = '"+xFilial("SF2")+"' "
	cQry += "AND F2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
	//cQry += "AND F4_DUPLIC = 'S' "
	cQry += "AND D1_DOC IS NULL "
	cQry += "GROUP BY F2_EMISSAO,F2_DOC,F2_CLIENTE,A1_NOME "
	cQry += "ORDER BY F2_EMISSAO, F2_DOC "

	TcQuery cQry Alias Wrk New

Return
