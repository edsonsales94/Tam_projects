#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function Pelrec()
	Local aOrd := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	SetPrvt("TITULO,CABEC1,CABEC2,CDESC1,CDESC2,CDESC3")
	SetPrvt("CSTRING,ARETURN,NLASTKEY,CPERG,LI,M_PAG")
	SetPrvt("WNREL,VCOND,MGERAL1,MGERAL2,MGERAL3,MAPAGAR")
	SetPrvt("MTPAGAS,MTOTVAL,MTOTJUR,MTOTGER,MCOND,MCLIENTE,MMUNICIP,MVEND")
	SetPrvt("MMULTA,MJUROS,MTOTAL,")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ PELREC.PRG: EMISSAO DE TITILOS A RECEBER COM VALOR DO JUROS  ³
	//³ DATA       : 04.09.96                                        ³
	//³ AUTOR      : MICROSIGA/EMILIA                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cDesc1   := OemToAnsi("Este programa ir  imprimir os Titulos Vencidos, de acordo")
	cDesc2   := OemToAnsi("com os parametros solicitados pelo usuario.")
	cDesc3   := OemToAnsi("")
	Private cString  := "SE1"
	Private aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
	Private nLastKey := 0
	Private cPerg    := PADR("PELREC",LEN(SX1->X1_GRUPO))
	Private li       := 55
	Private m_pag    := 1
	Private nTipo    := 15
	Private cFilterUser := ""
	Private aDrive   := {}
	Private cCar     := ""

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite           := 132
	Private tamanho          := "M"
	Private nLastKey        := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte(CPERG,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01            // Do Vencimento                         ³
	//³ mv_par02            // Ate o Vencimento                      ³
	//³ mv_par03            // Do Banco                              ³
	//³ mv_par04            // Ate o Banco                           ³
	//³ mv_par05            // Do Cliente                            ³
	//³ mv_par06            // Ate o Cliente                         ³
	//³ mv_par07            // Titulos :  A pagar Pagos Ambos        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Wnrel := SetPrint(cString,"PELREC",cPerg,titulo ,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho    ,,.T.)
	//wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	If nLastKey == 27
		Set Filter To
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Set Filter To
		Return
	Endif
	Titulo   := "POSICAO DE TITULOS A RECEBER"
	cAbec1   := Padc("Do Dia "+dtoc(mv_par01)+" Ate "+dtoc(mv_par02),132)
	cAbec2   := " | Nome Cliente               | Num. Titulo  | Bco |  Emissao |  Vencto  | Pagamnto | Vlr Titulo | Atras | Vlr. Juros | Vlr. Total |"

	RptStatus({|| Corpo1() })
Return
Static Function Corpo1()
	Local x
	cFilterUser := aReturn[7]

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Var.p/calcular acrescimos e descontos no valor do titulo     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	vCond   := { " AND E1_BAIXA = '        '", " AND E1_BAIXA <> '        '", ""}
	mGeral1 := 0
	mGeral2 := 0
	mGeral3 := 0
	mApagar := 0
	mTPagas := 0
	aStruct := SE1->( dbStruct() )

	cCond   := " WHERE E1_FILIAL = '"+XFILIAL("SE1")+"' AND D_E_L_E_T_ <> '*' AND"
	cCond   += " E1_VENCREA BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' AND"
	cCond   += " E1_PORTADO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND"
	cCond   += " E1_CLIENTE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"+vCond[mv_par07]

	cQuery  := "SELECT * FROM "+RetSQLName("SE1")+cCond
	cQuery	+= " ORDER BY E1_CLIENTE, E1_LOJA, E1_NUM, E1_PREFIXO, E1_PARCELA"

	//TCQUERY cQuery NEW ALIAS "TE1"
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TE1",.T.,.T.)

	nRegis  := RecCount()// alterado por adelson em 3/01/08 --> U_ContaQ(@cQuery,"COUNT(*) SOMA","*","E1_CLIENTE, E1_PREFIXO, E1_NUM")

	For x:=1 To Len(aStruct)
		If aStruct[x][2] <> "C" .and.  FieldPos(aStruct[x][1]) > 0
			TcSetField("TE1",aStruct[x][1],aStruct[x][2],aStruct[x][3],aStruct[x][4])
		EndIf
	Next

	dbSelectArea("TE1")
	SetRegua(nRegis)
	TE1->(dbGoTop())

	While ! TE1->(Eof())
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(XFILIAL("SA1")+TE1->E1_CLIENTE)
		mTel     := If( Found() , SA1->A1_TEL, Space(Len(SA1->A1_TEL)))
		mMunicip	:= alltrim(A1_MUN)
		nCont    := 1
		dbSelectArea("TE1")
		mTotval  := 0
		mTotjur  := 0
		mTotger  := 0
		mCond    := .T.
		mCliente := E1_CLIENTE
		mvend	:= E1_VEND1
		While ! Eof() .And. mCliente == E1_CLIENTE

			IncRegua()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera filtro do usuario                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(cFilterUser).and.!(&cFilterUser)
				dbSkip()
				Loop
			Endif

			mvend := E1_VEND1

			If li >= 55
				//@ LI,000 PSAY chr(15)
				If m_pag > 1
					@ li,001 PSAY "+"+repli("-",129)+"+"
				Endif
				Cabec(Titulo,Cabec1,Cabec2,"PELREC",Tamanho,nTipo)
				li := 9
				///         ImprTit()  
				mCond:=.T.
			Endif

			//mMulta := If( Empty(E1_BAIXA) , dDataBase, E1_BAIXA) - E1_VENCREA
			//mJuros := If( mMulta < 0 , 0, E1_VALOR * ((E1_PORCJUR * mMulta) / 100))
			//mMulta := If( mMulta < 0 , 0, mMulta)
			//mTotal := E1_VALOR + (E1_VALOR * ((E1_PORCJUR * mMulta) / 100))

			mMulta := If( Empty(E1_BAIXA) , dDataBase, E1_BAIXA) - E1_VENCREA
			mMulta := If( mMulta < 0 , 0, mMulta)
			mJuros := E1_VALOR * ((E1_PORCJUR * mMulta) / 100)
			mTotal := E1_VALOR + mJuros

			aDrive := ReadDriver()
			cCar   := aDrive[aReturn[4]+2]

			@ li,001 PSAY "| "
			If mCond
				@ li,003 PSAY Left(SA1->A1_NOME,20)
				mCond:=.F.
			ElseIf nCont == 2
				@ li,003 PSAY mTel
			Endif
			nCont := nCont + 1
			@ li,032 PSAY E1_NUM+"-"+E1_PREFIXO+"-"+E1_PARCELA
			@ li,047 PSAY E1_PORTADO
			@ li,053 PSAY E1_EMISSAO
			@ li,064 PSAY E1_VENCREA
			@ li,075 PSAY E1_BAIXA
			@ li,086 PSAY Transform(E1_VALOR,"@E 999,999.99")
			@ li,100 PSAY Transform(mMulta  ,"@E 9999")
			@ li,107 PSAY Transform(mJuros  ,"@e 999,999.99")
			@ li,120 PSAY Transform(mTotal  ,"@e 999,999.99")+" |"
			li:=li+1

			mTotval := mTotval + E1_VALOR
			mTotjur := mTotjur + mJuros
			mTotger := mTotger + mTotal
			If mv_par07 == 3
				mApagar := mApagar + if( Empty(E1_BAIXA) , mTotal, 0)
				mTPagas := mTPagas + if( Empty(E1_BAIXA) , 0, mTotal)
			Endif

			dbSkip()
		Enddo
		If mTotval > 0
			If nCont == 2
				@ li,001 PSAY "| "+mTel+Space(128-Len(mTel))+"|"
			Else
				@ li,001 PSAY "|"+repli("-",129)+"|"
			Endif
			li:=li+1
			@ li,001 PSAY "| Total do Cliente - "+mCliente+"  | Municipio - "+mMunicip+"        |Rep: "+mvend
			@ li,084 PSAY Transform(mTotval,"@e 9,999,999.99")
			@ li,105 PSAY Transform(mTotjur,"@e 9,999,999.99")
			@ li,118 PSAY Transform(mTotger,"@e 9,999,999.99")+" |"
			li:=li+1
			@ li,001 PSAY "|"+repli("-",129)+"|"
			li:=li+1
			mGeral1 := mGeral1 + mTotval
			mGeral2 := mGeral2 + mTotger
			mGeral3 := mGeral3 + mTotjur
		Endif
	Enddo
	If mGeral1 <> 0
		@ li,001 PSAY "| Total Geral"
		@ li,084 PSAY Transform(mGeral1,"@e 9,999,999.99")
		@ li,105 PSAY Transform(mGeral3,"@e 9,999,999.99")
		@ li,118 PSAY Transform(mGeral2,"@e 9,999,999.99")+" |"
		li:=li+1
		If mv_par07 == 3
			If mApagar <> 0
				@ li,001 PSAY "| Total a Pagar"
				@ li,118 PSAY Transform(mApagar,"@e 9,999,999.99")+" |"
				li:=li+1
			Endif
			If mTPagas <> 0
				@ li,001 PSAY "| Total Pagas"
				@ li,118 PSAY Transform(mTpagas,"@e 9,999,999.99")+" |"
				li:=li+1
			Endif
		Endif
		@ li,001 PSAY "+"+repli("-",129)+"+"
		//@ 00,000 PSAY ""
	Endif
	dbCloseArea()

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif


	MS_FLUSH()
Return

Static FUNCTION ImprTit()

	aDrive := ReadDriver()
	cCar   := aDrive[aReturn[4]+2]

	@ LI,000 PSAY chr(15)
	LI++
	@ LI,001 PSAY "+"+Repli("-",129)+"+"
	LI:=LI+1
	@ li,001 PSAY "|"+SM0->M0_NOMECOM
	@ li,055 PSAY "POSICAO DE TITULOS A RECEBER"
	@ li,113 PSAY "Emissao: "+dtoc(ddatabase)+" |"
	LI:=LI+1
	@ li,001 PSAY "|"
	@ li,055 PSAY "Do Dia "+dtoc(mv_par01)+" Ate "+dtoc(mv_par02)
	@ li,131 PSAY "|"
	LI:=LI+1
	@ li,001 PSAY "| Hora: "+Time()
	@ li,113 PSAY "Pagina.: "+StrZero(m_pag,3)+"      |"
	LI:=LI+1
	@ li,001 PSAY "|"+REPLI("-",129)+"|"
	LI:=LI+1
	@ LI,001 PSAY "| Nome Cliente               | Num. Titulo  | Bco |  Emissao |  Vencto  | Pagamnto | Vlr Titulo | Atras | Vlr. Juros | Vlr. Total |"
	//    xxxxxxxxxxxxxxxxxxxxxxxxxx   XXXXXX-XXX-X   XXX   99/99/99   99/99/99   99/99/99   999.999,99    999    999.999,99   999.999,99
	//  000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111111111111111111111
	//  000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112222222222333
	//  123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	li:=li+1
	@ li,001 PSAY "|"+repli("-",129)+"|"
	li:=li+1
	m_pag:=m_pag+1
RETURN