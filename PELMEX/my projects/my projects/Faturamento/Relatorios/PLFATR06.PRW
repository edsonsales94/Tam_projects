#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 18/09/00
#IFNDEF  WINDOWS
#DEFINE PSAY SAY
#ENDIF        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PLFATR06  ºAutor  ³Microsiga           º Data ³  12/20/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pedido de Venda Pelmex 1                                   º±±
±±º          ³ Antigo PED                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PLFATR06()        // incluido pelo assistente de conversao do AP5 IDE em 18/09/00

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetPrvt("TITULO,CABEC1,CABEC2,CDESC1,CDESC2,CDESC3")
	SetPrvt("CSTRING,ARETURN,NLASTKEY,CPERG,LI,M_PAG")
	SetPrvt("WNREL,NTOTGER1,NTOTGER2,MCOND,VET,MCONDP")
	SetPrvt("CNOME,MPEDIDO,MACRES,MOBSNOT,MOBS1,MOBS2,MOBS3")
	SetPrvt("MDESC1,MDESC2,MDESC3,MDESC4,MBRUTO,MLIQUIDO")
	SetPrvt("MTLIQUIDO,MDESCONTO,MTES,I,NNUMPAR,")

	#IFNDEF  WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 18/09/00 ==>     #DEFINE PSAY SAY
	#ENDIF        
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ PELPAG    : EMISSAO DE PEDIDOS                               ³
	//³ DATA       : 30.09.96                                        ³
	//³ AUTOR      : MICROSIGA/EMILIA                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Titulo := "Lista de Pedidos"
	cAbec1 := ""
	cAbec2 := ""
	cDesc1 := OemToAnsi("Este programa ir  imprimir os Pedidos, de acordo")
	cDesc2 := OemToAnsi("com os parametros solicitados pelo usuario.")
	cDesc3 := OemToAnsi("")

	// DETERMINA FILTRAGEM
	cString:="SC5"

	aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
	nLastKey := 0

	// IDENTIFICA QUAL PROG QUE IRA BUSCAR NO SX1
	cPerg   := Padr("FATR06",Len(SX1->X1_GRUPO))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Salva a Integridade dos dados de Entrada                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	li       := 55
	m_pag    := 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	pergunte(cPerg,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01            // Do Pedido                             ³
	//³ mv_par02            // Ate o Pedido                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Wnrel:=SetPrint(cString,"PLFATR06",cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,{})

	If nLastKey == 27
		Set Filter To
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Set Filter To
		Return
	Endif

	#IFDEF WINDOWS
	RptStatus({|| Corpo1() })// Substituido pelo assistente de conversao do AP5 IDE em 18/09/00 ==>         RptStatus({|| Execute(Corpo1) })
Return
// Substituido pelo assistente de conversao do AP5 IDE em 18/09/00 ==>         Function Corpo1
Static Function Corpo1()
	Local i
	#ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Var.p/calcular acrescimos e descontos no valor do titulo     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ntotger1 := 0
	ntotger2 := 0
	mCond    := .F.
	vet      := {}
	mCondp   := space(03)
	cnome    := space(25)
	mpedido  := space(06)
	macres   :=0

	@ 00,01 PSAY chr(15)
	Titulo := "PEDIDO DE VENDA"
	Cabec1 := " "
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(XFILIAL("SC5")+mv_par01,.T.)
	SetRegua(RecCount())

	While ! Eof() .And. C5_NUM <= mv_par02 .And. XFILIAL("SC5") == C5_FILIAL
		IncRegua()
		//IF SC5->C5_IMPRESS == "S" .OR. SC5->C5_STAT <> "L"
		//   dbSelectArea("SC5")
		//   dbSkip()
		//   loop
		//ENDIF
		mPedido  :=C5_NUM
		mCondp   :=C5_CONDPAG
		mObsnot  :=C5_MENNOTA//Adicionado Ener
		///    mObsnot  :=C5_obsnot // Ener
		mObs1    :=C5_OBS1
		mObs2    :=C5_OBS2
		//    mObs3    :=C5_OBS3 Retirado Ulisses Jr em 04/01/07 pois será usado na nota fiscal
		mDesc1   :=C5_DESC1
		mDesc2   :=C5_DESC2
		mDesc3   :=C5_DESC3
		mDesc4   :=C5_DESC4
		mBruto   :=0
		mLiquido :=0
		mTLiquido:=0
		mDesconto:=0
		mVbrutUni:=0
		mDescUnit:=0
		if li >= 55
			li:=1
			imprtit()
		endif
		impcab()
		dbSelectarea("SC6")
		dbSetOrder(1)
		dbSeek(XFILIAL("SC6")+mPedido,.T.)
		While mPedido==C6_NUM .And. XFILIAL("SC6") == C6_FILIAL
			if li >= 55
				li:=1
				imprtit()
				impcab()
			endif
			DbSelectArea("SB1")
			SB1->(DbSetoRDER(1))
			SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
			dbSelectArea("SC6")

			mVbrutUni := If(C6_PRUNIT > 0, C6_PRUNIT, (C6_VALDESC/C6_QTDVEN)+C6_PRCVEN)//Ulisses Jr em 02/01/08
			mDescUnit := If(C6_PRUNIT > 0, If((C6_PRUNIT - C6_PRCVEN) < 0,0,(C6_PRUNIT - C6_PRCVEN)*C6_QTDVEN),C6_VALDESC)//Ulisses Jr em 02/01/08

			@ li,01 PSAY C6_ITEM
			@ li,07 PSAY C6_PRODUTO
			@ li,24 PSAY SB1->B1_COR  //Ener
			///       @ li,24 PSAY C6_COR1   //Ener
			@ li,28 PSAY Alltrim(SB1->B1_DESC)//C6_descri
			@ li,85 PSAY C6_QTDVEN
			@ li,90 PSAY mDescUnit Picture "@E 999,999,999.99"//(C6_PRUNIT)*C6_QTDVEN Ulisses Jr em 02/01/08
			///       @ li,90 PSAY (C6_PRUNIT-C6_prdecr)*C6_QTDVEN Picture "@E 999,999,999.99" //Ener
			@ li,107 PSAY mVbrutUni Picture "@E 999,999,999.99"//C6_PRUNIT  Ulisses Jr em 02/01/08
			@ li,122 PSAY C6_VALOR  Picture "@E 999,999,999.99"  
			mBruto:=mBruto+If(C6_PRUNIT > 0, C6_PRUNIT*C6_QTDVEN,(mVbrutUni*C6_QTDVEN)) // (C6_PRUNIT*C6_QTDVEN) Ulisses Jr em 02/01/08
			mDesconto:=mDesconto+mDescUnit  // Ener havia deixado ((C6_PRCVEN)*C6_QTDVEN), alterado para C6_VALDESC por Ulisses Jr em 02/01/08
			mLiquido:=(mBruto - mDesconto)//Ener havia deixado (C6_QTDVEN),  alterado para C6_VALDESC por Ulisses Jr em 02/01/08
			mAcres:= 0 // Ener
			///       mDesconto:=mDesconto+((C6_PRUNIT-C6_prdecr)*C6_QTDVEN)    //Ener
			///       mLiquido:=mLiquido+(C6_prdecr*C6_QTDVEN)  //Ener
			///       mAcres:=sC6->C6_acres // Ener
			mTes:=C6_TES
			LI:=LI+1
			aadd(vet,{C6_ITEM,C6_ENTREG,""})   //Ener
			//       aadd(vet,{C6_ITEM,C6_ENTREG,C6_COR})  //Ener 
			dbSelectArea("SC6")
			dbskip()
		Enddo
		@ li,01 PSAY repli("-",148)   
		if len(vet) > 0
			li:=li+2
			for i:=1 to len(vet)
				@ li,001 PSAY vet[i][1]
				@ li,005 PSAY vet[i][2]
				li:=li+1
			next
			vet:={}
		endif
		dbSelectArea("SC5") 
		///    if !empty(C5_OBSNOT) .or. !empty(C5_OBS1) .or. !empty(C5_OBS2) .or. !empty(C5_OBS3) /Ener
		if !empty(C5_MENNOTA) .or. !empty(C5_OBS1) .or. !empty(C5_OBS2)// .or. !empty(C5_OBS3)
			li:=li+1
			@ li,001 PSAY "Obs:"
			// li:=li+1
			@ li,006 PSAY C5_MENNOTA  //Ener
			///        @ li,006 PSAY C5_OBSNOT // Ener
			li:=li+1
			@ li,006 PSAY C5_OBS1
			li:=li+1
			@ li,006 PSAY C5_OBS2
			li:=li+1
			//       @ li,006 PSAY C5_OBS3
		endif
		li:=li+2
		@ li,01 PSAY "TOTAL BRUTO......: " 
		@ li,21 PSAY mBruto    Picture "@E 999,999,999,999.99"
		li:=li+1
		@ li,01 PSAY "DESC. PROMOCAO...: "    
		@ li,21 PSAY mDesconto Picture "@E 999,999,999,999.99"  
		li:=li+1
		@ li,01 PSAY "DESC. ESPECIAL...: "
		if .F. //mTes $ "502#518#519"  // <-- Retirado p/ Lei Insc. Estadual
			li:=li+1
			@ li,001 PSAY "DECRETO 5%+2.27%.: "
			@ li,021 PSAY (mLiquido*7.27)/100 Picture "@E 999,999,999,999.99"
			mTLiquido:=(mLiquido*7.27)/100
		endif
		li:=li+1
		@ li,01 PSAY "TOTAL LIQUIDO....: "    
		@ li,21 PSAY (mLiquido-mTLiquido)  Picture "@E 999,999,999,999.99"  
		li:=li+1
		@ li,01 PSAY repli("-",148)  
		li:=li+2
		dbSelectArea("SE4")
		dbSetOrder(1)
		dbSeek(XFILIAL("SE4")+mCondp)
		nNumpar:=1
		mCond:=Alltrim(E4_COND)
		For i:=2 To Len(mCond)
			if Substr(mCond,i,1) == ","
				nNumpar:=nNumpar+1
			endif
		Next
		@ li,01 PSAY "COND.PAGAMENTO: "  + e4_descri
		li:=li+2
		@ li,01 PSAY "NR. DE PARCELAS: " + str(nNumpar)
		LI:=LI+2
		@ li,01 PSAY "DESCONTO: " 
		@ li,11 PSAY str(mDesc1,5,2)  
		if mDesc2#0
			@ li,17 PSAY "+" + str(mDesc2,5,2) 
		endif
		if mDesc3#0
			@ li,23 PSAY "+" + str(mDesc3,5,2) 
		endif
		if mDesc4#0
			@ li,29 PSAY "+" + str(mDesc4,5,2)
		endif
		li:=li+2
		@ li,01 PSAY "ACRESC.FINANCEIRO: " 
		@ LI,20 PSAY mAcres
		li:=56
		dbSelectArea("SC5")
		dbSkip()
	Enddo
	//li:=li+1
	//@ li,01 PSAY ""

	If aReturn[5] == 1
		Set Printer TO
		dbCommitAll()
		ourspool(wnrel)
	Endif
	MS_FLUSH()
RETURN

// Substituido pelo assistente de conversao do AP5 IDE em 18/09/00 ==>  FUNCTION ImprTit
Static FUNCTION ImprTit()

	dbSelectArea("SM0")
	cnome:=M0_NOMECOM
	@ LI,01 PSAY repli("-",148)
	LI:=LI+1
	@ li,02 PSAY cnome  
	@ li,127 PSAY "Emissao: "+ dtoc(ddatabase)
	LI:=LI+1
	@ li,01 PSAY " SIGA\PEDIDO.PRG                                   PEDIDO DE VENDA"  
	@ li,127 PSAY "Pag.: "+alltrim(str(m_pag))
	LI:=LI+1
	@ li,01 PSAY repli("-",148)
	m_pag:=m_pag+1
	LI:=LI+1                                                                                                                                                    
RETURN

// Substituido pelo assistente de conversao do AP5 IDE em 18/09/00 ==>  Function impcab
Static Function impcab()

	dbSelectArea("SC5")
	@ li,01 PSAY "Codigo do Cliente: " + SC5->C5_CLIENTE
	li:=li+1
	If SC5->C5_TIPO $ "B,D"
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(XFILIAL("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
		@ li,01 PSAY "CGC..............: " + SA2->A2_CGC  
		li:=li+1
		@ li,01 PSAY "Razao Social.....: " + SA2->A2_NOME
		li:=li+1
		@ li,01 PSAY "Endereco.........: " + SA2->A2_END
		li:=li+1
		@ li,01 PSAY "Cidade...........: " + SA2->A2_MUN
		@ li,60 PSAY "Telefone.........: " + SA2->A2_TEL
	Else
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
		@ li,01 PSAY "CGC..............: " + SA1->A1_CGC  
		li:=li+1
		@ li,01 PSAY "Razao Social.....: " + SA1->A1_NOME
		li:=li+1
		@ li,01 PSAY "Endereco.........: " + SA1->A1_END
		li:=li+1
		@ li,01 PSAY "Cidade...........: " + SA1->A1_MUN
		@ li,60 PSAY "Telefone.........: " + SA1->A1_TEL
	EndIf  
	li:=li+1
	dbSelectArea("SC5")
	//        @ li,01 PSAY "Pedido/Cliente...: " + SC5->C5_PEDCLI // Ener
	@ li,60 PSAY "Pedido...........: " + SC5->C5_NUM
	li:=li+1
	@ li,001 PSAY "Vendedor1.......: " + SC5->C5_VEND1
	@ li,030 PSAY STR(SC5->C5_COMIS1,5,2) 
	@ li,060 PSAY "Vendedor2.......: " + SC5->C5_VEND2
	@ li,075 PSAY STR(SC5->C5_COMIS2,5,2) 
	li:=li+1
	@ li,01 PSAY "Emissao..........: " + dtoc(SC5->C5_EMISSAO)
	//        @ li,60 PSAY "Data/Conf........: " + dtoc(SC5->C5_DTLIB) // Ener
	li:=li+1
	@ li,01 PSAY "Tabela...........: " + SC5->C5_TABELA
	li:=li+1
	@ li,01 PSAY repli("-",148)  
	li:=li+1
	@ LI,01 PSAY "ITEM  CODIGO           COR DESCRICAO                                               QTDE        DESCONTO      PRECO UNIT.     PRECO TOTAL   P.ENTREGA"          
	li:=li+1
	@ li,01 PSAY repli("-",148)  
	li:=li+1
Return
