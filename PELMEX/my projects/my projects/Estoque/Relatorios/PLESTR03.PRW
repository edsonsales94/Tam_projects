#include "rwmake.ch"
#include "topconn.ch"

/*______________________________________________________________________________
¦ Programa  ¦ PLESTR03   ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 14/02/2008 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Relatório de Disponibilidade de Estoque							¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLESTR03()

	SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,ARETURN,NLASTKEY")
	SetPrvt("CPERG,CSTRING,LI,M_PAG,WNREL")

	titulo    := "Disponibilidade de estoque"
	cDesc1    := OemToAnsi("Este programa ir  emitir a relatorio de")
	cDesc2    := OemToAnsi("disponibilidade de estoque.")
	cDesc3    := OemToAnsi("")
	aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
	nLastKey  := 0
	cPerg     := PADR("ESTR03",Len(SX1->X1_GRUPO))
	cString  := "SB1"
	li       := 59
	m_pag    := 1

	ValidPerg(cPerg)
	pergunte(cPerg,.F.)

	wnrel:=SetPrint(cString,"PLESTR03",cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"")

	if nLastKey = 27
		Set Filter To
		Return
	endif
	SetDefault(aReturn,cString)
	if nLastKey = 27
		Set Filter To
		Return
	endif

	RptStatus({|| Estr01a() })
	Return       

	*******************************
Static Function Estr01a()
	*******************************
	Local cQuery, nSaldoPR, nSaldoOP
	Local nC2_SALDO := 0
	/*
	cQuery := " SELECT B1_COD,B1_DESC,B1_UM,B1_COR,ISNULL(SUM(B2_QATU),0) AS B2_QATU, "
	cQuery += " ISNULL(SUM(C6_QTDVEN)- SUM(C6_QTDENT),0) C6_SALDO, "
	cQuery += " ISNULL(SUM(C2_QUANT) - SUM(C2_QUJE),0) C2_SALDO "
	cQuery += " FROM "+RetSqlName("SB1")+" B1, "+RetSqlName("SB2")+" B2, "
	cQuery += RetSqlname("SC2")+" C2, "+RetSqlName("SC6")+" C6 "
	cQuery += " WHERE B1.D_E_L_E_T_ <> '*' AND B2.D_E_L_E_T_ <> '*' "
	cQuery += " AND C2.D_E_L_E_T_ <> '*' AND C6.D_E_L_E_T_ <> '*' "
	cQuery += " AND B1_COD *= B2_COD "
	cQuery += " AND B1_COD *= C2_PRODUTO "
	cQuery += " AND B1_COD *= C6_PRODUTO "
	cQuery += " AND B1_GRUPO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += " AND B1_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += " AND B1_TIPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
	cQuery += " GROUP BY B1_COD,B1_DESC,B1_UM,B1_COR "
	cQuery += " ORDER BY B1_COD "
	*/                                                                 


	/*cQuery := " SELECT QR0.B1_COD AS B1_COD, QR0.B1_DESC AS B1_DESC, QR0.B1_UM AS B1_UM, "
	cQuery += " QR0.B1_COR AS B1_COR, QR1.B2_QATU AS B2_QATU, QR2.C6_SALDO AS C6_SALDO, "
	cQuery += " QR3.C2_SALDO AS C2_SALDO "
	cQuery += " FROM "+RetSqlName("SB1")+" QR0, "*/

	cQuery := " SELECT QR0.B1_COD AS B1_COD, QR0.B1_DESC AS B1_DESC, QR0.B1_UM AS B1_UM, "
	cQuery += " QR0.B1_COR AS B1_COR, QR1.B2_QATU AS B2_QATU, QR2.C6_SALDO AS C6_SALDO "
	cQuery += " FROM "+RetSqlName("SB1")+" QR0, "

	cQuery += " (SELECT B1_COD,B1_DESC,B1_UM,B1_COR,ISNULL(SUM(B2_QATU),0) AS B2_QATU "
	cQuery += " FROM "+RetSqlName("SB1")+" B1
	cQuery += " Left Outer Join "+RetSqlName("SB2")+" B2 on B1_COD = B2_COD"
	cQuery += " WHERE B2.D_E_L_E_T_ <> '*' "
	cQuery += " AND B1.D_E_L_E_T_ <> '*' "
	cQuery += " AND B1_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += " GROUP BY B1_COD,B1_DESC,B1_UM,B1_COR) QR1, "

	cQuery += " (SELECT B1_COD,B1_DESC,B1_UM,B1_COR,ISNULL(SUM(C6_QTDVEN)- SUM(C6_QTDENT),0) AS C6_SALDO "
	cQuery += " FROM "+RetSqlName("SB1")+" B1
	cQuery += " Left Outer Join "+ RetSqlName("SC6")+" C6 on B1_COD = C6_PRODUTO"
	cQuery += " WHERE C6.D_E_L_E_T_ <> '*' "
	cQuery += " AND B1.D_E_L_E_T_ <> '*' "
	cQuery += " AND B1_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += " GROUP BY B1_COD,B1_DESC,B1_UM,B1_COR) QR2 " //,
	/*
	cQuery += " (SELECT B1_COD,B1_DESC,B1_UM,B1_COR,ISNULL(SUM(C2_QUANT) - SUM(C2_QUJE),0) C2_SALDO "
	cQuery += " FROM "+RetSqlName("SB1")+" B1
	cQuery += " Left Outer Join " +RetSqlName("SC2")+" C2 on B1_COD = C2_PRODUTO"
	cQuery += " WHERE C2.D_E_L_E_T_ <> '*' "
	cQuery += " AND B1.D_E_L_E_T_ <> '*' "
	cQuery += " AND C2_DATRF = '' "
	cQuery += " AND B1_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += " GROUP BY B1_COD,B1_DESC,B1_UM,B1_COR) QR3 "
	*/
	cQuery += " WHERE QR0.D_E_L_E_T_ <> '*' "
	cQuery += " AND QR0.B1_COD = QR1.B1_COD "
	cQuery += " AND QR0.B1_COD = QR2.B1_COD "
	//cQuery += " AND QR0.B1_COD = QR3.B1_COD "
	cQuery += " AND QR0.B1_GRUPO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += " AND QR0.B1_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += " AND QR0.B1_TIPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
	cQuery += " ORDER BY QR0.B1_COD "

	TCQUERY cQuery ALIAS Tmp New

	Tmp->(dbGoTop())
	SetRegua(Tmp->(RecCount()))

	While !Tmp->(Eof())

		IncRegua()

		If Tmp->B2_QATU = 0 .and. Tmp->C6_SALDO = 0 //.and. Tmp->C2_SALDO = 0
			Tmp->(dbSkip())
			Loop
		EndIf

		If li >= 58
			If m_pag > 1
				@ li,001 PSAY Repli("-",132)
			EndIf
			Imprtit()
		EndIf                               

		SC2->(dbSetorder(2)) //FILIAL + PRODUTO
		SC2->(dbSeek(xFilial("SC2") + ALLTRIM(Tmp->B1_COD))) 

		While !SC2->(EOF()) .AND. SC2->C2_PRODUTO == Tmp->B1_COD 
			IF EMPTY(SC2->C2_DATRF)
				nC2_SALDO += (SC2->C2_QUANT - SC2->C2_QUJE)
			ENDIF
			SC2->(dbSkip())
		End


		nSaldoPR := Tmp->B2_QATU - Tmp->C6_SALDO
		nSaldoOP := nSaldoPR + nC2_SALDO

		@ li,001 PSAY Tmp->B1_COD
		@ li,018 PSAY Left(Tmp->B1_DESC,40)
		@ li,060 PSAY Tmp->B1_UM
		@ li,064 PSAY Tmp->B1_COR
		@ li,069 PSAY Tmp->B2_QATU	PICTURE "@E 9,999,999"// Qtd Estoque
		@ li,080 PSAY Tmp->C6_SALDO	PICTURE "@E 9,999,999"// Saldo de pedido
		@ li,091 PSAY nSaldoPR  		PICTURE "@E 9,999,999"// Saldo Estoque Real
		@ li,102 PSAY nC2_SALDO	      PICTURE "@E 9,999,999"// OP's Abertas
		@ li,113 PSAY If(nSaldoOP < 0,abs(nSaldoOP), 0 )	PICTURE "@E 9,999,999"// Saldo OP's
		@ li,124 PSAY If(nSaldoOP > 0,abs(nSaldoOP), 0 )	PICTURE "@E 9,999,999"// Saldo OP's
		li:=li+1      

		nC2_SALDO := 0
		Tmp->(dbSkip())
	End

	Tmp->(dbCloseArea())

	if m_pag > 1
		@ li,001 PSAY repli("-",132)
	endif
	If aReturn[5] == 1
		Set Printer TO 
		dbcommitAll()
		ourspool(wnrel)  
	EndIf
	MS_FLUSH()
	Return                    

	**************************
Static Function ImprTit()
	**************************
	@ 00,000 PSAY chr(15)
	li:=1
	@ li,001 PSAY Repli("-",132)
	li:=li+1
	@ li,001 PSAY "| "+SM0->M0_NOMECOM
	@ li,116 PSAY "Pagina.: "+StrZero(m_pag,3)
	li:=li+1
	@ li,001 PSAY "SIGA /PLESTR03 /v.8.11 SQL                         DISPONIBILIDADE DE ESTOQUE PARA VENDAS"
	@ li,116 PSAY "DT.Ref.: "+dtoc(ddatabase)
	li:=li+1
	@ li,001 PSAY "Hora...: "+Time()
	@ li,116 PSAY "Emissao: "+dtoc(Date())
	li:=li+1
	@ li,001 PSAY Repli("-",132)
	li:=li+1
	@ li,001 PSAY "CODIGO           D  E  S  C  R  I  C  A  O                 UM  COR  SLD. ESTQ  PED.PEND.  DISPONIV.  OP.ABERTA     FALTAS     SOBRAS"
	li:=li+1   //  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX  XXX  9,999,999  9,999,999  9,999,999  9,999,999  9,999,999  9,999,999
	//  0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111111
	//  0000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333
	//  1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
	@ li,001 PSAY Repli("-",132)
	li:=li+1
	m_pag:=m_pag+1
	Return

	*****************************************
Static Function ValidPerg(cPerg)
	*****************************************

	u_InPutSX1(cPerg,"01","   Grupo de		: ","","","mv_ch1","C",04,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02","   Grupo Ate		: ","","","mv_ch2","C",04,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03","   Produto de	: ","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04","   Produto Ate	: ","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05","   Tipo de		: ","","","mv_ch5","C",02,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06","   Tipo Ate		: ","","","mv_ch6","C",02,0,0,"G","","","","","mv_par06")

Return Nil
