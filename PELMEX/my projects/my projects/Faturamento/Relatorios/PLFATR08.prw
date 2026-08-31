#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PLFATR08 º Autor ³ AP6 IDE            º Data ³  11/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PLFATR08(cNomeProg)
	Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2        := "de acordo com os parametros informados pelo usuario."
	Local cDesc3        := "LISTA DE CARGA PARA PEDIDO"
	Local Titulo        := "LISTA DE CARGA PARA PEDIDO"
	Local nLin          := 80
	Local Cabec1        := ""
	Local Cabec2        := ""
	Local aOrd          := {}
	Local cPerg         := PADR("FATR08",Len(SX1->X1_GRUPO))

	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private limite      := 132
	Private tamanho     := "M"
	Private nomeprog    := If(cNomeProg==Nil,"PLFATR08",cNomeProg) // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo       := 15
	Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey    := 0
	Private m_pag       := 01
	Private wnrel       := If(cNomeProg==Nil,"PLFATR08",cNomeProg) // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cString     := "SC5"

	SC5->(dbSetOrder(1))

	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,cNomeProg) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  11/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,cNomeProg)
	Local cCabPad, aVet, mBruto, mLiquido, mDesconto, mTot, mAcres
	Local cFilSC5 := SC5->(XFILIAL("SC5"))
	Local _nM3:=0
	Local _nTotM3:=0
	cCabPad := "ITEM  CODIGO           DESCRICAO                                    COR      QTDE  1.ENTREGA 2.ENTREGA 3.ENTREGA 4.ENTREGA M3"
	//          XX    XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX               XX   99999,99     999999    999999    999999    999999    999999
	//          012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	//                    1         2         3         4         5         6         7         8         9        10        11        12        13

	SA1->(dbSetOrder(1))
	SB1->(dbSetOrder(1))
	SC5->(dbSetOrder(1))
	SC6->(dbSetOrder(1))
	SE4->(dbSetOrder(1))

	SetRegua(SC5->(RecCount()))

	SC5->(dbSeek(cFilSC5+mv_par01,.T.))
	While !SC5->(Eof()) .And. SC5->C5_NUM <= mv_par02 .And. cFilSC5 == SC5->C5_FILIAL

		IncRegua()

		// Se pedido já foi impresso para o relatório PLFATR09
		If cNomeProg <> Nil .And. SC5->C5_IMPRESS == "S"
			SC5->(dbSkip())
			Loop
		Endif

		Cabec1 := cCabPad   // Atribui cabeçalho padrão
		nLin   := 60
		aVet   := {}

		SA1->(dbSeek(XFILIAL("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI)))

		SC6->(dbSeek(SC5->(C5_FILIAL+C5_NUM),.T.))
		While !SC6->(Eof()) .And. SC5->(C5_FILIAL+C5_NUM) == SC6->(C6_FILIAL+C6_NUM)

			If nLin >= 59
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
				nLin := ImpCab1(nLin)
			Endif

			SB1->(dbSeek(XFILIAL("SB1")+SC6->C6_PRODUTO))
			_nM3:= SB1->B1_XCOMPRI*SB1->B1_XALTURA*SB1->B1_XLARGUR
			@ nLin,000       PSAY SC6->C6_ITEM
			@ nLin,PCol()+04 PSAY SC6->C6_PRODUTO
			@ nLin,PCol()+02 PSAY PADR(If(cNomeProg<>Nil,SB1->B1_DESC,SC6->C6_DESCRI),43)
			@ nLin,PCol()+02 PSAY SB1->B1_COR
			@ nLin,PCol()+03 PSAY SC6->C6_QTDVEN Picture "@E 99999.99"
			@ nLin,PCol()+05 PSAY "______"
			@ nLin,PCol()+04 PSAY "______"    
			@ nLin,PCol()+04 PSAY "______"
			@ nLin,PCol()+04 PSAY "______"
			//@ nLin,PCol()+04 PSAY "______" 
			@ nLin,PCol()+04 PSAY _nM3 Picture "@E 99999.99"
			nLin++

			AAdd( aVet , { SC6->C6_ITEM, SC6->C6_ENTREG, SB1->B1_DCR})
			_nTotM3:=_nTotM3+_nM3
			SC6->(dbSkip())
		Enddo

		ImpRodape(aVet,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,@nLin,_nTotM3)
		_nTotM3:=0
		SE4->(dbSeek(XFILIAL("SE4")+SC5->C5_CONDPAG))

		Cabec1    := ""
		nLin      := 60
		mBruto    := 0
		mLiquido  := 0
		mDesconto := 0
		mTot      := 0
		mAcres    := 0
		aVet      := {}

		SC6->(dbSeek(SC5->(C5_FILIAL+C5_NUM),.T.))
		While !SC6->(Eof()) .And. SC5->(C5_FILIAL+C5_NUM) == SC6->(C6_FILIAL+C6_NUM)

			SB1->(dbSeek(XFILIAL("SB1")+SC6->C6_PRODUTO))

			mTes := SC6->C6_TES
			If cNomeProg == Nil
				mBrutoUni := SC6->C6_PRUNIT
				mDescoUni := mBrutoUni * SC6->C6_QTDVEN

				mBruto   += mBrutoUni * SC6->C6_QTDVEN
				mLiquido += mBrutoUni * SC6->C6_QTDVEN
				mTot     += SC6->C6_VALOR
			Else
				mBrutoUni := SC6->(If( C6_PRUNIT > 0, C6_PRUNIT, (C6_VALDESC / C6_QTDVEN) + C6_PRCVEN))
				mDescoUni := SC6->(If( C6_PRUNIT > 0, If((C6_PRUNIT - C6_PRCVEN) < 0, 0, (C6_PRUNIT - C6_PRCVEN) * C6_QTDVEN),C6_VALDESC))

				mBruto    += mBrutoUni * SC6->C6_QTDVEN
				mDesconto += mDescoUni
				mLiquido  := (mBruto - mDesconto)
				mTot      := (mBruto - mDesconto)
			Endif

			If nLin >= 59
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
				nLin := ImpCab2(nLin)
			Endif

			@ nLin,000      PSAY SC6->C6_ITEM
			@ nLin,PCol()+4 PSAY SC6->C6_PRODUTO
			@ nLin,PCol()+2 PSAY SB1->B1_COR
			@ nLin,PCol()+2 PSAY PADR(If(cNomeProg<>Nil,SB1->B1_DESC,SC6->C6_DESCRI),50)
			@ nLin,PCol()+1 PSAY SC6->C6_QTDVEN     Picture "@E 99999.99"
			@ nLin,PCol()+1 PSAY SC6->C6_VALDESC    Picture "@E 999,999,999.99"
			@ nLin,PCol()+1 PSAY mBrutoUni          Picture "@E 999,999,999.99"
			@ nLin,PCol()+1 PSAY SC6->C6_VALOR      Picture "@E 999,999,999.99"
			nLin++

			AAdd(aVet,{ SC6->C6_ITEM, SC6->C6_ENTREG, SB1->B1_DCR})

			SC6->(dbSkip())
		Enddo

		@ nLin,000 PSAY __PrtThinLine()

		ImpRodape(aVet,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,@nLin)

		nLin += 2
		@ nLin,000 PSAY "TOTAL BRUTO........: "+Transform(mBruto,"@E 999,999,999,999.99")
		nLin++
		@ nLin,000 PSAY "DESC. PROMOCAO.....: "+Transform(mDesconto,"@E 999,999,999,999.99")
		nLin++
		If mTes $ '556,557'
			nLin++
			@ nLin,000 PSAY "DECRETO 5%+2.27%: "
			@ nLin,020 PSAY (mLiquido * 7.27) / 100 Picture "@E 999,999,999,999.99"
		Endif
		nLin++
		@ nLin,000 PSAY "TOTAL LIQUIDO......: "+Transform(mTot,"@E 999,999,999,999.99")
		nLin++
		@ nLin,000 PSAY __PrtThinLine()
		nLin+=2
		@ nLin,000 PSAY "COND.PAGAMENTO: "+SE4->E4_DESCRI
		nLin+=2
		@ nLin,000 PSAY "DESCONTO: "
		@ nLin,010 PSAY Str(SC5->C5_DESC1,5,2)

		If SC5->C5_DESC2 <> 0
			@ nLin,PCol()+1 PSAY "+ "+Str(SC5->C5_DESC2,5,2)
		Endif
		If SC5->C5_DESC3 <> 0
			@ nLin,PCol()+1 PSAY "+ "+Str(SC5->C5_DESC3,5,2)
		Endif
		If SC5->C5_DESC4 <> 0
			@ nLin,PCol()+1 PSAY "+ "+Str(SC5->C5_DESC4,5,2)
		Endif
		@ nLin,PCol() PSAY "%"
		nLin+=2

		@ nLin,000 PSAY "ACRESC.FINANCEIRO: "+Transform(mAcres,"@E 999,999.99")

		If cNomeProg <> Nil  .And. SC5->C5_IMPRESS <> "S"  // Se for PLFATR09, grava flag de já impresso
			RecLock("SC5",.F.)
			SC5->C5_IMPRESS := "S"
			MsUnLock()
		Endif

		SC5->(dbSkip())
	Enddo

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return

Static Function ImpCab1(nLin)
	@ nLin,000 PSAY "Pedido: " +SC5->C5_NUM
	@ nLin,045 PSAY "Cliente: "+SC5->C5_CLIENTE+"   "+SA1->A1_NOME
	nLin++
	@ nLin,000 PSAY "Endereco: "+SA1->A1_END
	nLin++
	@ nLin,000 PSAY "Cidade: "+SA1->A1_MUN
	@ nLin,045 PSAY "Estado: "+SA1->A1_EST
	nLin+=2
Return nLin

Static Function ImpCab2(nLin)
	@ nLin,000 PSAY "Codigo do Cliente: " + SC5->C5_CLIENTE
	nLin++
	@ nLin,000 PSAY "CGC..............: " + SA1->A1_CGC
	nLin++
	@ nLin,000 PSAY "Razao Social.....: " + SA1->A1_NOME
	nLin++
	@ nLin,000 PSAY "Endereco.........: " + SA1->A1_END
	nLin++
	@ nLin,000 PSAY "Cidade...........: " + SA1->A1_MUN
	@ nLin,060 PSAY "Telefone.........: " + SA1->A1_TEL
	nLin++
	@ nLin,060 PSAY "Pedido...........: " + SC5->C5_NUM
	nLin++
	@ nLin,000 PSAY "Vendedor1........: " + SC5->C5_VEND1+"    "+STR(SC5->C5_COMIS1,5,2)
	@ nLin,060 PSAY "Vendedor2........: " + SC5->C5_VEND2+"    "+STR(SC5->C5_COMIS2,5,2)
	nLin++
	@ nLin,000 PSAY "Emissao..........: " + Dtoc(SC5->C5_EMISSAO)
	@ nLin,060 PSAY "Data/Conf........: " + Dtoc(SC5->C5_EMISSAO)
	nLin++
	@ nLin,000 PSAY "Tabela...........: " + SC5->C5_TABELA
	nLin++
	@ nLin,000 PSAY __PrtThinLine()
	nLin++
	@ nLin,000 PSAY "ITEM  CODIGO           COR DESCRICAO                                              QTDE       DESCONTO    PRECO UNIT.    PRECO TOTAL"
	nLin++  //       XX    XXXXXXXXXXXXXXX  XX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99999,99 999,999,999.99 999,999,999.99 999,999,999.99
	//       012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	//                 1         2         3         4         5         6         7         8         9        10        11        12        13
	@ nLin,000 PSAY __PrtThinLine()
	nLin++
Return nLin

Static Function ImpRodape(aVet,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,nLin,_nTotM3)
	Local i

	If !Empty(aVet)
		nLin+=2
		For i:=1 To Len(aVet)
			If nLin >= 59
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
			Endif
			@ nLin,000      PSAY aVet[i][1]
			@ nLin,PCol()+2 PSAY aVet[i][2]
			@ nLin,PCol()+5 PSAY aVet[i][3]
			nLin++
		Next
	Endif

	If !Empty(SC5->C5_MENNOTA) .Or. !Empty(SC5->C5_OBS1) .Or. !Empty(SC5->C5_OBS2)
		nLin++
		@ nLin,000 PSAY "Obs:"
		nLin++
		@ nLin,005 PSAY SC5->C5_MENNOTA
		nLin++
		@ nLin,005 PSAY SC5->C5_OBS1
		nLin++
		@ nLin,005 PSAY SC5->C5_OBS2
		nLin+=2 
		@ nLin,005 PSAY SC5->C5_OBS3
		nLin+=2
		@ nLin,005 PSAY "Total M3: " 
		nLin+=2 
		@ nLin,005 PSAY _nTotM3 Picture "@E 99999.99"
		nLin+=2
	Endif
Return

Static Function ValidPerg(cPerg)
	u_InPutSX1(cPerg,"01",PADR("Do Pedido   ",29)+"?","","","mv_ch1","C",06,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Ate o Pedido",29)+"?","","","mv_ch2","C",06,0,0,"G","","","","","mv_par02")
Return