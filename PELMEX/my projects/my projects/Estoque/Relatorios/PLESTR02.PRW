#INCLUDE "MATR850.CH"
#INCLUDE "PROTHEUS.CH"
/*_______________________________________________________________________________
¦ Função    ¦ PLESTR02   ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 09/01/2008 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Relação das Ordens de Produção                                    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLESTR02()
	Local titulo 	:= "Relacao Das Ordens de Producao"
	Local cString	:= "SC2"
	Local wnrel		:= "MATR850"
	Local cDesc		:= "Este programa ira imprimir a Relacao das Ordens de Producao."
	Local aOrd    	:= {"Por O.P.       ","Por Produto    "}
	Local tamanho	:= "M"
	Local lRet      := .T.                                
	Private aReturn := {"Zebrado",2,"Administracao", 1, 2, 1, "",1 }
	Private cPerg   := Padr("MTR850",Len(SX1->X1_GRUPO))
	Private nLastKey:= 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("MTR850",.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01        	// Da OP                                 ³
	//³ mv_par02        	// Ate a OP                              ³
	//³ mv_par03        	// Do Produto                            ³
	//³ mv_par04        	// Ate o Produto                         ³
	//³ mv_par05        	// Do Centro de Custo                    ³
	//³ mv_par06        	// Ate o Centro de Custo                 ³
	//³ mv_par07        	// Da data                               ³
	//³ mv_par08        	// Ate a data                            ³
	//³ mv_par09        	// 1-EM ABERTO 2-ENCERRADAS  3-TODAS     ³
	//³ mv_par10        	// 1-SACRAMENTADAS 2-SUSPENSA 3-TODAS    ³
	//³ mv_par11            // Impr. OP's Firmes, Previstas ou Ambas ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,aOrd,.F.,Tamanho)

	If aReturn[4] == 1
		Tamanho := "M"
	EndIf
	If nLastKey == 27
		Set Filter To
		lRet := .F.
	EndIf

	If lRet
		SetDefault(aReturn,cString)
	EndIf

	If lRet .And. nLastKey == 27
		Set Filter To
		lRet := .F.
	EndIf

	If lRet
		RptStatus({|lEnd| R850Imp(@lEnd,wnRel,titulo,tamanho)},titulo)
	EndIf
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R850Imp  ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 13.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR850			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R850Imp(lEnd,wnRel,titulo,tamanho)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local CbTxt
	Local CbCont,cabec1,cabec2
	Local limite   := If(aReturn[4] == 1,132,180)
	Local nomeprog := "MATR850"
	Local nTipo    := 0
	Local cProduto := Space(Len(SC2->C2_PRODUTO))
	Local cStatus,nOrdem,cSeek
	Local cTotal   := "",nTotOri:= 0,nTotSaldo:=0 // Totalizar qdo ordem for por produto
	Local cQuery   := "",cIndex := CriaTrab("",.F.),nIndex:=0
	Local lQuery   := .F.
	Local aStruSC2 := {}
	Local cAliasSC2:= "SC2"
	Local cTPOP    := ""
	Local lTipo    := .F.
	Local aDriver := ReadDriver()
	Local cCarac  := aDriver[aReturn[4]+2]
	Local oSection

	#IFDEF TOP
	Local nX
	#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cbtxt  := Space(10)
	cbcont := 0
	li     := 80
	m_pag  := 1

	nTipo  := IIf(aReturn[4]==1,15,18)
	nOrdem := aReturn[8]
	lTipo  := IIf(aReturn[4]==1,.T.,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta os Cabecalhos                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	titulo += If(nOrdem = 1," - Por O.P."," - Por Produto")                              
	cabec1 := "NUMERO   P R O D U T O                                                    INICIO DA   ENTREGA DA QUANTIDADE  OBSERVAÇÃO"
	cabec2 := "                                                                           PRODUÇÃO    PRODUÇÃO        "
	//					   1234567890123  123456789012345  1234567890123456789012345678901234567890  1234567890   1234567890    1234567890  1234567890  123456789012345  123456789012345       1  1
	//                               1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17
	//                     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	// 1a Linha Posicoes:000/015/032/074/086/098/110/122/139/161/164

	dbSelectArea("SC2")
	dbSetOrder(nOrdem)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa variavel para controle do filtro                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If mv_par10 == 1
		cStatus := "'S'"
	ElseIf mv_par10 == 2
		cStatus := "'U'"
	ElseIf mv_par10 == 3
		cStatus := "'S','U','D','N',' '"
	EndIf
	If mv_par11 == 1
		cTPOP := "'F'"
	ElseIf mv_par11 == 2
		cTPOP := "'P'"
	ElseIf mv_par11 == 3
		cTPOP := "'F','P'"
	EndIf	
	lQuery 	  := .T.
	aStruSC2  := SC2->(dbStruct())
	cAliasSC2 := "R850IMP"
	cQuery    := "SELECT SC2.C2_FILIAL,SC2.C2_PRODUTO,SC2.C2_NUM,SC2.C2_ITEM,SC2.C2_SEQUEN,SC2.C2_ITEMGRD, "
	cQuery    += "SC2.C2_DATRF,SC2.C2_CC,SC2.C2_EMISSAO,SC2.C2_DATPRF,SC2.C2_QUANT,SC2.C2_QUJE,SC2.C2_PERDA, "
	cQuery    += "SC2.C2_STATUS,SC2.C2_TPOP, SC2.C2_OBS,SC2.C2_DATPRI, "
	cQuery    += "SC2.R_E_C_N_O_ SC2RECNO "
	cQuery    += "FROM "
	cQuery    += RetSqlName("SC2")+" SC2 "
	cQuery    += "WHERE "
	cQuery    += "SC2.C2_FILIAL = '"+xFilial("SC2")+"' AND "

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿        
	//³ Condicao para filtrar OP's                           		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery += 	  "SC2.C2_NUM >= '"+Left(mv_par01,6)+"' AND "
	If !Empty( Substr(mv_par01,7,2) )
		cQuery += "SC2.C2_ITEM >= '"+Substr(mv_par01,7,2)+"' AND "
	EndIf
	If !Empty( Substr(mv_par01,9,3) )
		cQuery += "SC2.C2_SEQUEN >= '"+Substr(mv_par01,9,3)+"' AND "
	EndIf
	If !Empty( Substr(mv_par01,12,2) )
		cQuery += "SC2.C2_ITEMGRD >= '"+Substr(mv_par01,12,2)+"' AND "
	EndIf

	cQuery += 	  "SC2.C2_NUM <= '"+Left(mv_par02,6)+"' AND "
	If !Empty( Substr(mv_par02,7,2) )
		cQuery += "SC2.C2_ITEM <= '"+Substr(mv_par02,7,2)+"' AND "
	EndIf
	If !Empty( Substr(mv_par02,9,3) )
		cQuery += "SC2.C2_SEQUEN <= '"+Substr(mv_par02,9,3)+"' AND "
	EndIf
	If !Empty( Substr(mv_par02,12,2) )
		cQuery += "SC2.C2_ITEMGRD <= '"+Substr(mv_par02,12,2)+"' AND "
	EndIf

	cQuery    += "SC2.C2_PRODUTO >= '"+mv_par03+"' And SC2.C2_PRODUTO <= '"+mv_par04+"' And "
	cQuery    += "SC2.C2_CC  >= '"+mv_par05+"' And SC2.C2_CC  <= '"+mv_par06+"' And "
	cQuery    += "SC2.C2_EMISSAO  >= '"+DtoS(mv_par07)+"' And SC2.C2_EMISSAO  <= '"+DtoS(mv_par08)+"' And "
	cQuery    += "SC2.C2_STATUS IN ("+cStatus+") And "
	cQuery    += "SC2.C2_TPOP IN ("+cTPOP+") And "
	cQuery    += "SC2.D_E_L_E_T_ = ' ' "

	cQuery    += "ORDER BY "+SqlOrder(SC2->(IndexKey()))

	cQuery    := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC2,.T.,.T.)

	For nX := 1 To Len(aStruSC2)
		If ( aStruSC2[nX][2] <> "C" ) .And. FieldPos(aStruSC2[nX][1]) > 0
			TcSetField(cAliasSC2,aStruSC2[nX][1],aStruSC2[nX][2],aStruSC2[nX][3],aStruSC2[nX][4])
		EndIf
	Next nX

	SetRegua(RecCount())		// Total de Elementos da regua
	dbGoTop()

	@ 00,00 Psay &cCarac
	While !Eof()
		IncRegua()
		If lEnd
			@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
			Exit
		EndIf

		If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD < xFilial('SC2')+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD > xFilial('SC2')+mv_par02
			dbSkip()
			Loop
		EndIf

		If mv_par09 = 1  // O.P.s EM ABERTO
			If !Empty(C2_DATRF)
				dbSkip()
				Loop
			EndIf
		ElseIf mv_par09 = 2 //O.P.S ENCERRADAS
			If Empty(C2_DATRF)
				dbSkip()
				Loop
			EndIf
		EndIf

		//-- Valida se a OP deve ser Impressa ou n„o
		If	! Empty(aReturn[7])
			SC2->(MsGoTo((cAliasSC2)->SC2RECNO))
			If SC2->( ! &(aReturn[7]) )
				(cAliasSC2)->(DbSkip())
				Loop
			EndIf
		EndIf			

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Termina filtragem e grava variavel p/ totalizacao            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cTotal  := If(nOrdem = 2,xFilial("SC2")+C2_PRODUTO,xFilial("SC2"))
		nTotOri := nTotSaldo:=0
		While !Eof() .And. cTotal = If(nOrdem = 2,C2_FILIAL+C2_PRODUTO,C2_FILIAL)
			IncRegua()

			If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD < xFilial('SC2')+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD > xFilial('SC2')+mv_par02
				dbSkip()
				Loop
			EndIf

			If mv_par09 = 1  // O.P.s EM ABERTO
				If !Empty(C2_DATRF)
					dbSkip()
					Loop
				EndIf
			Elseif mv_par09 = 2 //O.P.S ENCERRADAS
				If Empty(C2_DATRF)
					dbSkip()
					Loop
				EndIf
			EndIf

			//-- Valida se a OP deve ser Impressa ou n„o

			If !Empty(aReturn[7])
				SC2->(MsGoTo((cAliasSC2)->SC2RECNO))
				If SC2->( ! &(aReturn[7]) )
					(cAliasSC2)->(DbSkip())
					Loop
				EndIf
			EndIf

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+(cAliasSC2)->C2_PRODUTO))

			If li > 54//58
				Cabec(titulo,cabec1,cabec2,nomeprog,tamanho)//,nTipo)
				li++
			EndIf

			// 1a Linha Posicoes:000/015/032/074/086/098/110/122/139/161/164
			@Li ,000 PSay C2_NUM //+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
			@Li ,008 PSay C2_PRODUTO
			@Li ,025 PSay Alltrim(SubStr(SB1->B1_DESC,1,48))+Space(03)+If(!Empty(SB1->B1_XDIMENS),Alltrim(SB1->B1_XDIMENS),"")
			@Li ,075 PSay C2_DATPRI//060   
			@Li ,087 PSay C2_DATPRF//060   
			@Li ,092 PSay C2_QUANT Picture PesqPictQt("C2_QUANT",15)		
			@Li ,110 PSay C2_OBS
			//		@Li ,092 PSay C2_QUANT Picture PesqPictQt("C2_QUANT",15)//069
			//		@Li ,107 PSay IIf(Empty(C2_DATRF),aSC2Sld(cAliasSC2),0) Picture PesqPictQt("C2_QUANT",15)//084
			//		@Li ,124 PSay SB1->B1_COR//C2_STATUS//101
			//C2_TPOP//108

			Li++
			If nOrdem # 2 .And. !lTipo
				@Li ,  0 PSay __PrtThinLine()
				Li++
			Else
				nTotOri	 += C2_QUANT
				nTotSaldo+= IIf(Empty(C2_DATRF),aSC2Sld(cAliasSC2),0)
			EndIf
			If nOrdem = 1
				@ li,00 Psay Replicate("-",130)
				li++
			EndIf

			dbSkip()
		End
		If nOrdem = 2
			Li++
			@Li ,000 PSay "Total ---->"
			@Li ,015 PSay Substr(cTotal,3)
			If lTipo
				@Li ,069 PSay nTotOri	Picture PesqPictQt("C2_QUANT",15)//097
				@Li ,084 PSay nTotSaldo	Picture PesqPictQt("C2_QUANT",15)//112
				Li++
				@Li ,  0 PSay __PrtThinLine()
			Else
				@Li ,089 PSay nTotOri	Picture PesqPictQt("C2_QUANT",15)//125
				@Li ,106 PSay nTotSaldo	Picture PesqPictQt("C2_QUANT",15)//142
				Li++
				@Li ,  0 PSay __PrtThinLine()
			EndIf
			Li++
		EndIf
	End

	If lQuery
		dbSelectArea(cAliasSC2)
		dbCloseArea()
	EndIf

	dbSelectArea("SC2")
	Set Filter To
	SC2->(dbSetOrder(1))

	If File(cIndex+OrdBagExt())
		Ferase(cIndex+OrdBagExt())
	EndIf

	If aReturn[5] == 1
		Set Printer To
		OurSpool(wnrel)
	EndIf

	MS_FLUSH()
Return NIL

