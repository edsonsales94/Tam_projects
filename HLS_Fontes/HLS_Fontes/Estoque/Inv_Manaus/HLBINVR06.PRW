#INCLUDE "rwmake.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ HLBINVR06  ¦ Autor ¦ WILLIAMS MESSA       ¦ Data ¦ 10/07/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Relatório de Etiquetas do Inventário Faltantes.               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function HLBINVR06()

	Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2        := "de acordo com os parametros informados pelo usuario."
	Local cDesc3        := "Relatório de Etiquetas Pendentes de Entrega        "
	Local cPict         := ""
	Local titulo        := "Relatório de Etiquetas Pendentes de Entrega"
	Local nLin          := 80
	//                      "|   Código HLB   |                 DESCRICAO DO PRODUTO              | Quantidade |      Custo      |     Motivo      "
	//                       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//                                10        20        30        40        50        60        70        80        90       100
	Local Cabec1        :=  "|   NRO.ETIQUETA |                 DESCRICAO DO PRODUTO              | CENTRO CUS.| CONTAGEM01 | CONTAGEM02 | CONTAGEM03"
	Local Cabec2        := ""
	Local imprime       := .T.
	Local aOrd          := {}
	Local cPerg         := "INVR06"
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite      := 80
	Private tamanho     := "M"
	Private nomeprog    := "INVR06" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cbtxt       := Space(10)
	Private cbcont      := 00
	Private CONTFL      := 01
	Private m_pag       := 01
	Private wnrel       := "INVR06" // Coloque aqui o nome do arquivo usado para impressao em disco

	Private cString := "SZ3"

	dbSelectArea("SZ3")
	dbSetOrder(1)

	ValidPerg(cPerg)

	wnrel := SetPrint(cString,NomeProg,"INVR06",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	titulo:= titulo+"-"+ DTOC(MV_PAR01)+ " A "+DTOC(MV_PAR02)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*______________________________________________________________________________
¦ Função    ¦ HLBINVR06  ¦ Autor ¦ Williams Messa       ¦ Data ¦ 19/06/2009    ¦
¦-----------+------------+-------+----------------------+------+---------------¦
¦ Descrição ¦Relatório de Etiquetas do Inventário Faltantes.            	   ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local cQry       := ""
	LOCAL cCentroC   := ""
	Local nTotVlrQtd := 0
	Local nTotQtd    := 0
	LOCAL bImp       := .T.

	cQry  := "SELECT Z3_ETIQUET,Z3_PRODUTO,B1_IDDESEN,B1_DESC,Z3_LOCAL,Z3_CC,Z3_DATA,Z3_COUNT01,Z3_COUNT02,Z3_COUNT03 FROM SZ3010 A "
	cQry  += " INNER JOIN SB1010 B ON B1_COD =Z3_PRODUTO AND B.D_E_L_E_T_ =''  "
	cQry  += " WHERE A.D_E_L_E_T_ ='' AND Z3_DATA BETWEEN '"  + Dtos(Mv_Par01) + "' And '" + Dtos(Mv_Par02) + "'"
	cQry  += " AND Z3_CC BETWEEN '"  + Mv_Par03 + "' And '" + Mv_Par04 + "'"
	If MV_PAR05 == 1
		cQry  += " AND Z3_COUNT01 ='' "
	ElseIf MV_PAR05 == 2
		cQry  += " AND Z3_COUNT02 ='' "
	ElseIf MV_PAR05 == 3
		cQry  += " AND Z3_COUNT03 ='' "
	Else
		cQry  += ""
	EndIf
	cQry  += " ORDER BY Z3_CC,Z3_ETIQUET "

	MPSysOpenQuery( cQry, "TMP" ) // dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TMP", .T., .F. )
	DbSelectArea("TMP")

	cCentroC := TMP->Z3_CC

	dbGoTop()
	While !EOF()

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			//@nLin,002 PSAY "PERIODO DE  "+DTOC(MV_PAR01)+ " A "+DTOC(MV_PAR02)
			//nLin := nLin + 3
		Endif
		If cCentroC == TMP->Z3_CC .and. bImp == .T.
			@nLin,002 PSAY "Centro de Custo: " + TMP->Z3_CC
			bImp := .F.
			nLin := nLin + 2
		ElseIf cCentroC <> TMP->Z3_CC .and. bImp == .F.
			nLin := nLin + 1
			@nLin,002 PSAY "Total :   "
			@nLin,071 PSAY Transform(nTotVlrQtd,"@R 99999999")
			nTotVlrQtd := 0
			nLin := nLin + 2
			@nLin,002 PSAY "Centro de Custo: " + TMP->Z3_CC
			nLin := nLin + 2
			cCentroC := TMP->Z3_CC
		End If
		@nLin,001 PSAY TMP->Z3_ETIQUET
		@nLin,017 PSAY "|"
		@nLin,019 PSAY Left(TMP->B1_DESC,50)
		@nLin,069 PSAY "|"
		@nLin,071 PSAY Alltrim(TMP->Z3_CC)
		If (MV_PAR05 == 1 .OR. MV_PAR05 == 4)
			@nLin,082 PSAY "|"
			If Empty(TMP->Z3_COUNT01)
				@nLin,085 PSAY "Falta"
			Else
				@nLin,085 PSAY "Entregue"
			EndIf
		EndIf
		If (MV_PAR05 == 2 .OR. MV_PAR05 == 4)
			@nLin,096 PSAY "|"
			If Empty(TMP->Z3_COUNT02)
				@nLin,098 PSAY "Falta"
			Else
				@nLin,098 PSAY "Entregue"
			EndIf
		EndIf
		If (MV_PAR05 == 3 .OR. MV_PAR05 == 4)
			@nLin,108 PSAY "|"
			If Empty(TMP->Z3_COUNT03)
				@nLin,110 PSAY "Falta"
			Else
				@nLin,110 PSAY "        "
			EndIf
		EndIf
		nTotVlrQtd := nTotVlrQtd + 1
		nLin := nLin + 1 // Avanca a linha de impressao
		dbSkip() // Avanca o ponteiro do registro no arquivo
	EndDo
	nLin := nLin + 1
	@nLin,002 PSAY "Total de Etiquetas:   "
	@nLin,018 PSAY Transform(nTotVlrQtd,"@R 99999999")

	TMP->(DbCloseArea())
	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return

/*_______________________________________________________________________________
¦ Função    ¦ ValidPerg  ¦ Autor ¦ Williams Messa           ¦ Data ¦ 16/03/2009 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Criação das perguntas da rotina.                                  ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidPerg(cPerg)
	PutSX1(cPerg,"01","Da Emissao           ","","","mv_ch1","D",08,0,0,"G","",""   ,"","","mv_par01")
	PutSX1(cPerg,"02","Ate a Emissao        ","","","mv_ch2","D",08,0,0,"G","",""   ,"","","mv_par02")
	PutSX1(cPerg,"03","Do Centro de Custo   ","","","mv_ch3","C",09,0,0,"G","","CTT","","","mv_par03")
	PutSX1(cPerg,"04","Ate o Centro de Custo","","","mv_ch4","C",09,0,0,"G","","CTT","","","mv_par04")
	PutSx1(cPerg,"05","Verificar ?","","","mv_ch5","N",01,0,3,"C","","","","","mv_par05","Na Primeira","","","","Na Segunda","","","Na Terceira","","","Todas","","","","","","","","","")
Return Nil
