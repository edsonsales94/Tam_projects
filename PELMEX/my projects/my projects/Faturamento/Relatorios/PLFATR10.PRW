#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 09/08/00

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PLFATR10  ºAutor  ³Microsiga           º Data ³  02/25/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime a Nota de Credito                                  º±±
±±º          ³ Antigo programa Comven,prx                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PLFATR10()        // incluido pelo assistente de conversao do AP5 IDE em 09/08/00

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
	SetPrvt("NLASTKEY,CPERG,M_PAG,WNREL,ADBF,CARQ")
	SetPrvt("CIDX,CFILIAL,X,CVEND,NIND,CPED")
	SetPrvt("MPERCOM,MVAL,MDEBITO,MTOTVEN,MTOTNOT,MVENDEDOR")
	SetPrvt("LI,MIRRF,MIRF,MSUBT,")

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ COMVEN   ³ Autor ³  Ronilton O. Barros   ³ Data ³ 06/12/96 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Comissao de Vendedor                                       ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Gen‚rico                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	titulo   := "COMISSAO DE VENDEDOR"
	cDesc1   := OemToAnsi("Este programa ir  emitir a Comissao de Vendedor,")
	cDesc2   := OemToAnsi("utilizando recursos do SIGA Advanced.")
	cDesc3   := OemToAnsi("")
	cString  := "SF2"
	aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
	nLastKey := 0
	cPerg    := PADR("FATR10",Len(SX1->X1_GRUPO))
	m_pag    := 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas, busca o padrao da NFPARV ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	pergunte(cPerg,.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01             // Do Vendedor                          ³
	//³ mv_par02             // Ate o Vendedor                       ³
	//³ mv_par03             // Da Data                              ³
	//³ mv_par04             // Ate a Data                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel:=SetPrint(cString,"PLFATR10",cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"")

	if nLastKey == 27
		Set Filter To
		Return
	endif
	SetDefault(aReturn,cString)

	RptStatus({|| Corpo1() })// Substituido pelo assistente de conversao do AP5 IDE em 09/08/00 ==>         RptStatus({|| Execute(Corpo) })
Return
// Substituido pelo assistente de conversao do AP5 IDE em 09/08/00 ==>         Function Corpo
Static Function Corpo1()

	/*aDBF := {}
	AAdd( aDBF, { "VENDEDO", "C" ,  6, 0})
	AAdd( aDBF, { "DOC"    , "C" ,  6, 0})
	AAdd( aDBF, { "SERIE"  , "C" ,  3, 0})
	AAdd( aDBF, { "CLIENTE", "C" ,  6, 0})
	AAdd( aDBF, { "LOJA"   , "C" ,  2, 0})
	AAdd( aDBF, { "PEDIDO" , "C" , 13, 0})
	AAdd( aDBF, { "EMISSAO", "D" ,  8, 0})
	AAdd( aDBF, { "VALMERC", "N" , 14, 2})
	AAdd( aDBF, { "PERC"   , "N" ,  7, 2})
	AAdd( aDBF, { "VALOR"  , "N" , 14, 2})

	cArq := CriaTrab( aDBF, .T.)
	Use &cArq Alias TRB New Exclusive
	cIdx := CriaTrab( NIL, .F.)
	IndRegua("TRB",cIdx,'VENDEDO+DOC+SERIE+CLIENTE+LOJA',,," Criando Indice ...")

	cFilial := SM0->M0_CODFIL
	For x:=1 To 2
	cVend := "SF2->F2_VEND" + Str(x,1)
	nInd  := If( x == 1 , 9, 10)
	dbSelectArea("SF2")
	dbSetOrder(nInd)
	dbSeek(XFILIAL("SF2")+mv_par01+Dtos(mv_par03),.T.)
	SetRegua(RecCount())

	While ! Eof() .And. &cVend <= mv_par02 .And. XFILIAL("SF2") == F2_FILIAL

	IncRegua()

	If F2_EMISSAO < mv_par03 .Or. F2_EMISSAO > mv_par04 .Or.;
	F2_SERIE == "UNR"
	dbSkip()
	Loop
	Endif

	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(XFILIAL("SD2")+SF2->F2_DOC+SF2->F2_SERIE)
	cPed := ""
	While ! Eof() .And. XFILIAL("SD2")+SF2->F2_DOC+SF2->F2_SERIE == D2_FILIAL+D2_DOC+D2_SERIE .and. Len(cPed) < 13
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(XFILIAL("SC5")+SD2->D2_PEDIDO)
	dbSelectArea("SD2")
	//          If ! (SC5->C5_PEDCLI $ cPed) .And. ! Empty(SC5->C5_PEDCLI)
	//             cPed := cPed + SC5->C5_PEDCLI + "/"
	//          Endif
	dbSkip()
	Enddo

	mPercom := SC5->C5_COMIS1
	//       mPercom := if( SF2->F2_COMVEN == 0 , SC5->C5_COMIS1,SF2->F2_COMVEN)
	dbSelectArea("TRB")
	If ! dbSeek(&cVend+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	RecLock("TRB",.T.)
	TRB->VENDEDO := &cVend
	TRB->DOC     := SF2->F2_DOC
	TRB->SERIE   := SF2->F2_SERIE
	TRB->CLIENTE := SF2->F2_CLIENTE
	TRB->LOJA    := SF2->F2_LOJA
	TRB->EMISSAO := SF2->F2_EMISSAO
	TRB->PEDIDO  := Left(cPed,Len(cPed)-1)
	TRB->PERC    := mPercom
	Else
	RecLock("TRB",.F.)
	Endif
	TRB->VALMERC := TRB->VALMERC + SF2->F2_VALMERC
	TRB->VALOR   := TRB->VALOR   + (SF2->F2_VALMERC * TRB->PERC / 100)
	MsUnLock()
	dbSelectArea("SF2")

	IncRegua()
	dbSkip()
	Enddo
	Next*/
	//Adson 05/02/12 - Solicitação devido ao Sr. Eliandro
	SetRegua(MountTable())

	dbSelectArea("TRB")
	dbGoTop()
	//SetRegua(RecCount())
	While ! Eof()
		dbSelectArea("SA3")
		dbSetOrder(1)
		dbSeek(XFILIAL("SA3")+TRB->VENDEDO)
		dbSelectArea("TRB")
		//    mVal      := "SA3->A3_DEBM"+StrZero(Month(mv_par03),2)
		mDebito   := 0//&mVal
		mTotven   := 0
		mTotnot   := 0
		mVendedor := VENDEDO
		While ! Eof() .And. mVendedor == VENDEDO

			IncRegua()

			mTotnot := mTotnot + VALMERC
			mTotven := mTotven + VALOR

			dbSkip()
		Enddo
		If mTotnot <> 0
			li    := 5
			mIRRF := mTotven * 1.5 / 100

			If Alltrim(SA3->A3_COD) == "002"
				If mTotven <= 900
					mIrf := 0
				Elseif mTotven >= 901 .And. mTotven <= 1800
					mIrf  := 15
					mIRRF := mTotven * mIrf / 100
					mIRRF := mIRRF - 135
				Elseif mTotven >= 1801
					mIrf  := 27.5
					mIRRF := mTotven * mIrf / 100
					mIRRF := mIRRF - 360
				Endif
			Endif
			If mv_par05 <> 0 .Or. mv_par06 <> 0
				mTotVen := mv_par05
				mIRRF   := mv_par06
			Endif
			@ li,063 PSAY Str(Month(mv_par03),2)+ "/" + Str(Year(mv_par03),4)
			li:=li+4
			@ li,045 PSAY Str(Day(dDataBase),2) + " " + MesExtenso(Month(dDataBase)) + " " + Str(Year(dDataBase),4)
			li:=li+2
			@ li,009 PSAY SA3->A3_NOME
			li:=li+2
			@ li,013 PSAY SA3->A3_END
			li:=li+4
			@ li,010 PSAY "Ref. comissoes s/ vendas de produtos de n/ fabricacao"
			li:=li+1
			@ li,010 PSAY "durante o mes de " + MesExtenso(month(mv_par03)) + ".............................:"
			@ li,068 PSAY  mTotVen picture "@E 999,999,999.99"
			li:=li+1
			If mIRRF < 10 
				mIRRF := 0
			Endif
			If mIRRF > 0
				@ li,010 PSAY "IRRF..................................................:" 
				@ li,068 PSAY transform(mIRRF,"@E 999,999,999.99")
				li:=li+1
			Endif
			mSubt := mTotVen - mIRRF
			@ li,010 PSAY "Liquido de Comissoes..................................:"
			@ li,068 PSAY transform(mSubt,"@E 999,999,999.99") 
			li:=li+2
			@ li,010 PSAY Subs(RTRIM(SUBS(EXTENSO(mSubt),1,55))   + REPLICATE("*",54),1,54)
			li:= li + 1
			@ li,010 PSAY Subs(RTRIM(SUBS(EXTENSO(mSubt),56,55))  + REPLICATE("*",54),1,54) 
			li:= li + 1
			@ li,010 PSAY Subs(RTRIM(SUBS(EXTENSO(mSubt),112,55)) + REPLICATE("*",54),1,54)
			li:= li + 1
			@ li,010 PSAY Subs(RTRIM(SUBS(EXTENSO(mSubt),168,55))  + REPLICATE("*",54),1,54)         
		Endif
	Enddo

	dbCloseArea()
	//Ferase(cArq+".DBF")
	//Ferase(cIdx+".IDX")
	//@ 00,000 PSAY ""

	if aReturn[5] == 1
		Set Printer TO
		dbcommitAll()
		ourspool(wnrel)
	endif
	MS_FLUSH()
Return
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³    Fim do Programa COMVEN.PRG, Obrigado pela Aten‡Æo !                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//Adson 05/02/12 - Montagem da tabela temporaria usada no relatorio
Static Function MountTable()

	Local cQry    := ""
	Local cCampos := ""
	Local cTable  := CriaTrab(Nil,.F.)

	cQry += " Select Count(*) CONT From ( "
	cQry += " SELECT C5_VEND1 VENDEDO, F2_DOC DOC, F2_SERIE SERIE, F2_CLIENTE CLIENTE, F2_LOJA LOJA, F2_EMISSAO EMISSAO, MAX(C5_NUM) PEDIDO , C5_COMIS1 PERC, F2_VALMERC VALMERC, F2_VALMERC * C5_COMIS1 VALOR "
	cQry += " FROM  " + RetSqlName("SF2") + " SF2 "              
	cQry += " INNER JOIN  " + RetSqlName("SD2") + " SD2 ON D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_FILIAL = F2_FILIAL "
	cQry += " INNER JOIN  " + RetSqlName("SC5") + " SC5 ON D2_PEDIDO = C5_NUM AND C5_FILIAL = F2_FILIAL "
	cQry += " WHERE SF2.D_E_L_E_T_ = '' "
	cQry += " AND SC5.D_E_L_E_T_ = '' "
	cQry += " And C5_VEND1 BetWeen '" + mv_par01 + "' And '" + mv_par02 + "'
	cQry += " AND F2_EMISSAO BETWEEN '" + DTOS(mv_par03) + "' AND '" + DTOS(mv_par04) + "' "
	cQry += " AND F2_SERIE <> 'UNR' "
	cQry += " AND F2_VEND1 <> '' "
	cQry += " GROUP BY C5_VEND1, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_EMISSAO, C5_COMIS1, F2_VALMERC " 
	cQry += " UNION ALL "
	cQry += " SELECT C5_VEND2 VENDEDO, F2_DOC DOC, F2_SERIE SERIE, F2_CLIENTE CLIENTE, F2_LOJA LOJA, F2_EMISSAO EMISSAO, MAX(C5_NUM) PEDIDO , C5_COMIS1 PERC, F2_VALMERC VALMERC, F2_VALMERC * C5_COMIS1 VALOR "
	cQry += " FROM " + RetSqlName("SF2") + " SF2 "
	cQry += " INNER JOIN  " + RetSqlName("SD2") + " SD2 ON D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_FILIAL = F2_FILIAL "
	cQry += " INNER JOIN  " + RetSqlName("SC5") + " SC5 ON D2_PEDIDO = C5_NUM AND C5_FILIAL = F2_FILIAL "
	cQry += " WHERE SF2.D_E_L_E_T_ = '' "
	cQry += " AND SC5.D_E_L_E_T_ = ''"
	cQry += " AND F2_VEND2 <> '' "
	cQry += " AND F2_SERIE <> 'UNR' "
	cQry += " And C5_VEND2 BetWeen '" + mv_par01 + "' And '" + mv_par02 + "'
	cQry += " AND F2_EMISSAO BETWEEN '" + DTOS(mv_par03) + "' AND '" + DTOS(mv_par04) + "' "
	cQry += " GROUP BY C5_VEND2, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_EMISSAO, C5_COMIS1, F2_VALMERC ) A WHERE VENDEDO <> '' "

	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), cTable, .T., .F. )
	nCont := (cTable)->CONT
	(cTable)->(dbCloseArea(cTable))

	cQry := StrTran(cQry,"Count(*) CONT","*")

	cQry += " ORDER BY VENDEDO,DOC,SERIE,CLIENTE,LOJA "

	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TRB", .T., .F. )

Return nCont



