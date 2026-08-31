#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PLFATR03  ºAutor  ³Microsiga           º Data ³  12/17/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao da nota fiscal da Pelmex                         º±±
±±º          ³ Antigo NTESTE1                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PLFATR03() // incluido pelo assistente de conversao do AP5 IDE em 25/08/00

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,CRESP")
	SetPrvt("NPOSREG,NELEMENTOS,ARETURN,NLASTKEY,CPERG,WNREL")
	SetPrvt("LI,MNUMSELO,MSERIE,CNATUREZA2,CNATUREZA1,CTRANSP")
	SetPrvt("CENDTRANSP,CMUNTRANSP,CESTTRANSP,CCEPTRANSP,CCGCTRANSP,NPESOL")
	SetPrvt("CMENNOTA,DEMISSAO,MDESCD,MDESPD,CFRETE,MDTCONS")
	SetPrvt("RECF2,MPESOT,MVALDESC,CDOCANT,CSERIE,AITENS")
	SetPrvt("NX,MOBS,MDCR,MCOND,MINBM1,MINBM2")
	SetPrvt("MICIF,MUM,MTES,CPEDCLI,MPED,MPESO")
	SetPrvt("MPBRUTO,MDESCPRO,CNFORI,MCOD,MLOCAL,MPRECO")
	SetPrvt("MQUANT,MTOTAL,MCOR,MSAV,ADUP1,ADUP2")
	SetPrvt("ADUP3,ADUP4,MVENCTO,MTOT,NLIREF,I")
	SetPrvt("CL,MVALPRD,MQTOT,MQTOT2,MVALANT,MQTOT1")
	SetPrvt("MTOTDESC,COL,MDESC265,MDESC500,MTESTE,MDESC12")
	SetPrvt("MESPECIE,xCOD_MENS,nDesc,MVOLUMES")

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ TESNF    ³ Autor ³ Ronilton O. Barros    ³ Data ³          ³±±
	±±³Alterado  ³ TESNF    ³ Autor ³ Agnaldo C. Pereira    ³ Data ³ 15.01.02 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Nota Fiscal Saida para uso com RDMAKE.                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Comentario³ Este programa ira emitir a nota fiscal de SAIDA.           ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Vari veis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Titulo    := "NOTA FISCAL DE SAIDA."
	cDesc1    := OemToAnsi("Este programa ira emitir a nota fiscal de saida ")
	cDesc2    := OemToAnsi("de acordo com os parametros solicitados pelo    ")
	cDesc3    := OemToAnsi("usuario.")
	cString   := "SF2"
	cResp     := "N"
	nPosReg   := 0
	nElementos:= 0
	aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
	nLastKey  := 0
	cPerg     := PADR("FATR03",Len(SX1->X1_GRUPO))
	wnrel     := "PLFATR03"
	li        := 0 
	PRIVATE wcol := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas, busca o padrao da NFPARV ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte(cPerg,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01             // De Nota                              ³
	//³ mv_par02             // At‚ a Nota                           ³ 
	//³ mv_par03             // Serie                                ³ 
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"")

	If nLastKey == 27                      
		Set Filter To
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Set Filter To
		Return
	Endif

	RptStatus({|| Corpo2() })
	Return

	******************************
Static Function Corpo2()
	******************************
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona o SF2 para buscar os dados no Cabecalho da NF       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 00,00 PSAY Chr(18)
	dbSelectArea("SF2")
	SF2->(dbSetOrder(1))
	SF2->(dbSeek(XFILIAL("SF2")+mv_par01+mv_par03,.T.))

	if SM0->M0_CODIGO<>"10"
		Aviso("Atencao","Somente é possivel a impressão de Notas da Pelmex",{"Ok"})
		Return Nil
	Endif


	SA7->(dbSetOrder(2))// Ulisses Jr em 04/04/08

	While !SF2->(Eof()) .And. SF2->F2_DOC <= mv_par02 .And. SF2->F2_SERIE == mv_par03 .And. SF2->F2_FILIAL == XFILIAL("SF2")
		xCOD_MENS := ""
		mEspecie := " "
		If SF2->F2_SERIE <> "UNR"
			dbSelectArea("SX5")
			SX5->(dbSetOrder(1))
			SX5->(dbSeek(xfilial("SX5")+"66"+"AA"))
			mNumselo := Alltrim(SX5->X5_DESCRI)
			mSerie   := AllTrim(SX5->X5_CHAVE)
			If SF2->F2_IMPSELO <> "X"
				mNumselo := AllTrim(SX5->X5_DESCRI)
				mSerie   := AllTrim(SX5->X5_CHAVE)
				mNumselo := Val(mNumselo)+1
				mNumselo := Alltrim(Str(mNumselo))
				dbSelectArea("SF2")
				RecLock("SF2",.F.)
				SF2->F2_IMPSELO := "X"
				SF2->F2_SELOFIS := mNumselo
				SF2->(MsUnLock())
				dbSelectArea("SX5")
				RecLock("SX5",.F.)
				SX5->X5_DESCRI := mNumselo
				SX5->(msunlock())
			Endif
		Endif

		mEspecie := If(SM0->M0_CODIGO == "20",SF2->F2_ESPECI1,mEspecie)

		nDesc := 0
		mVolumes := 0
		dbSelectArea("SF3")
		SF3->(DbSetOrder(5))
		If SF3->(DbSeek(xFilial("SF3")+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA))
			nDesc := SF3->F3_VALOBSE
		EndIf
		dbSelectArea("SD2")
		SD2->(dbSetOrder(3))
		SD2->(dbSeek(XFILIAL("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
		dbSelectArea("SF4")
		SF4->(dbSetOrder(1))
		SF4->(dbSeek(XFILIAL("SF4")+SD2->D2_TES))
		cNatureza2 := SD2->D2_CF
		cNatureza1 := Trim(SF4->F4_TEXTO)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona o SA1(Cliente) ou (SA2)Fornecedor para buscar os Dados  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SF2->F2_TIPO $ "D,B"
			dbSelectArea("SA2")
		Else
			dbSelectArea("SA1")
		Endif
		dbSetOrder(1)
		dbSeek(XFILIAL()+SD2->D2_CLIENTE+SD2->D2_LOJA)


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona o SE4 para buscar a Condicao de pagamento          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		SC5->(dbSeek(XFILIAL("SC5")+SD2->D2_PEDIDO))
		nPESOL   := SC5->C5_PESOL

		dEmissao := SC5->C5_EMISSAO
		mDescd   := ""
		mDespd   := ""
		cCodTransp := SC5->C5_TRANSP
		cPlaca   := Alltrim(SC5->C5_OBS3) //Ulisses Jr em 04/01/08
		cFrete   := " "
		mDtCons  := Ctod(Space(08))
		xCOD_MENS   :=SC5->C5_MENPAD             // Codigo da Mensagem Padrao

		If SC5->C5_TPFRETE == "C"
			cFrete := "2"
		ElseIf SC5->C5_TPFRETE == "F"
			cFrete := "1"
		Endif      
		If SC5->C5_NTCONS <> " "
			dbSelectArea("SF2")
			RecF2 := SF2->(Recno())
			SF2->(dbSetOrder(1))
			mDtCons := ""
			If SF2->(dbSeek(xFilial("SF2")+SC5->C5_NTCONS))
				mDtCons := Dtoc(SF2->F2_EMISSAO)
			EndIf  
			SF2->(dbGoto(RecF2))
		Endif


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona o SA4 para buscar a Transportadora                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SA4")
		SA4->(dbSetOrder(1))
		SA4->(dbSeek(XFILIAL("SA4")+cCodTransp))
		cTransp    := SA4->A4_NOME
		cEndTransp := SA4->A4_END
		cMunTransp := SA4->A4_MUN
		cEstTransp := SA4->A4_EST
		cCEPTransp := SA4->A4_CEP
		cCGCTransp := SA4->A4_CGC

		mPesot   := 0
		mValdesc := 0

		if !Empty(SD2->D2_NFORI)
			dbSelectArea("SD1")
			SD1->(dbSetOrder(1))
			SD1->(dbSeek(XFILIAL("SD1")+SD2->D2_NFORI+SD2->D2_SERIORI))
		EndIf

		dbSelectArea("SC6")
		SC6->(dbSetOrder(4))
		SC6->(dbSeek(XFILIAL("SC6")+SF2->F2_DOC,.T.))
		mValdesc := SC6->C6_VALDESC

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Salva o numero do pedido pelo SD2                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD2")
		cDocant  := SD2->D2_DOC
		cSerie   := SD2->D2_SERIE
		aItens   := {}
		nPosReg  := SD2->(Recno())
		nX       := 0
		mObs     := ""
		mDcr     := ""
		mCond    := .F.
		mInbm1   := ""
		mInbm2   := ""
		mIcif    := .F.
		mUm      := Space(03)
		mTes     := SD2->D2_TES
		cPedcli  := ""
		mPed     := ""
		mPeso    := 0
		mPBruto  := 0
		mDescPro := 0
		cNFori   := If(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI+", DATA "+Dtoc(SD1->D1_EMISSAO))
		mCor     := ""
		aPedCli  := {}
		xCLAS_FIS:= {}
		_CLASFIS := ""

		While !SD2->(Eof()) .And. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE == XFILIAL("SD2")+cDocant+cSerie
			mCod   := SD2->D2_COD
			mLocal := SD2->D2_LOCAL
			mPreco := SD2->D2_PRUNIT
			mQuant := 0
			mTotal := 0
			cCodCli := ""

			dbSelectArea("SC6")
			SC6->(dbSetOrder(2))
			SC6->(dbSeek(XFILIAL("SC6")+SD2->D2_COD+SD2->D2_PEDIDO+SD2->D2_ITEMPV))
			dbSelectArea("SD2")
			While !SD2->(Eof()) .And. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_COD == XFILIAL("SD2")+cDocant+cSerie+mCod;
			.And. SD2->D2_PRUNIT == mPreco
				dbSelectArea("SC6")
				SC6->(dbSetOrder(2))
				SC6->(dbSeek(XFILIAL("SC6")+SD2->D2_COD+SD2->D2_PEDIDO+SD2->D2_ITEMPV))

				mVolumes := mVolumes + SC6->C6_XVOLUME

				If Ascan(aPedCli,SC6->C6_PEDCLI) = 0  //Ulisses Jr em 04/04/08
					AADD(aPedCli,SC6->C6_PEDCLI)
				EndIf

				If SA7->(dbSeek(xFilial("SA7")+SD2->D2_COD+SD2->D2_CLIENTE+SD2->D2_LOJA))
					cCodCli := SA7->A7_CODCLI
				EndIf

				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(XFILIAL("SB1")+SD2->D2_COD))
				mCor := Alltrim(SB1->B1_COR)  //Ener
				mPeso    := mPeso    + (SD2->D2_QUANT * SB1->B1_PESO)
				mPBruto  := mPbruto  + (SD2->D2_QUANT * SB1->B1_PESBRU)
				mQuant   := mQuant   + SD2->D2_QUANT
				mTotal   := mTotal   + SD2->D2_PRUNIT * SD2->D2_QUANT
				mUm      := SB1->B1_UM
				If At(SD2->D2_PEDIDO,mPed) == 0
					mPed := mPed + SD2->D2_PEDIDO + "-"
				Endif
				dbSelectArea("SC5")
				SC5->(dbSetOrder(1))
				SC5->(dbSeek(XFILIAL("SC5")+SD2->D2_PEDIDO))
				// Adicionado Ener {
				If ! Empty(SC5->C5_MENNOTA)
					mObs := AllTrim(SC5->C5_MENNOTA)
				Endif
				// }Adicionado Ener

				// Adicionado por Ulisses Jr em 21/01/10
				npElem := ascan(xCLAS_FIS,{|x| x[1] == SB1->B1_POSIPI})

				If npElem == 0
					AADD(xCLAS_FIS  ,{SB1->B1_POSIPI,""})
				EndIf

				npElem := ascan(xCLAS_FIS,{|x| x[1] == SB1->B1_POSIPI})

				Do Case
					Case npElem == 1
					_CLASFIS := "A"
					Case npElem == 2
					_CLASFIS := "B"
					Case npElem == 3
					_CLASFIS := "C"
					Case npElem == 4
					_CLASFIS := "D"
					Case npElem == 5
					_CLASFIS := "E"
					Case npElem == 6
					_CLASFIS := "F"
				EndCase

				xCLAS_FIS[npElem][2] := _CLASFIS
				//

				dbSelectArea("SD2")                
				mDcr := mDcr + alltrim(SB1->B1_DCR)+"-" 
				If( SC5->C5_DCR     == "S"  , mCond  := .T., ) 
				SD2->(dbSkip())
			Enddo
			dbSelectarea("SD2")
			SD2->(dbSkip(-1))
			dbSelectArea("SD2")
			Aadd(aItens,{SD2->D2_COD,;         // Elemento 01 - C¢digo do Produto
			Alltrim(SB1->B1_DESC),; // Elemento 02 - Descri‡Æo -- SC6->C6_DESCRI
			_CLASFIS,;				// Elemento 03 - Classifica‡Æo
			SB1->B1_ORIGEM+"0",;  // Elemento 04 - Situação Tributária
			SB1->B1_UM,;          // Elemento 05 - Unidade de Med.
			mQuant,;              // Elemento 06 - Quantidade
			SD2->D2_PRUNIT,;//IIF(SD2->D2_TES=="517",SC6->C6_PRDECR,SD2->D2_PRUNIT),;   // Elemento 07 - Valor Unit rio
			mTotal,;              // Elemento 08 - Valor Total // mtotal - Anterior - Diego 07/01/09
			IIF(Empty(SA1->A1_SUFRAMA),SD2->D2_PICM,0),;//IIF(SD2->D2_TES=="517",7,SD2->D2_PICM),;     // Elemento 09 - Al¡quota ICMS
			SD2->D2_IPI,;         // Elemento 10 - Al¡quota IPI
			SD2->D2_VALIPI,;      // Elemento 11 - Valor do IPI
			mCor,;                // Elemento 12 - Cor
			SubStr(SB1->B1_FANTASMA,1,1),; // Elemento 13 - Fantasma
			SB1->B1_CODBAR,;		  // Elemento 14 - EAN
			cCodCli })	  // Elemento 15 - Produto no cliente
			SD2->(dbSkip())
		Enddo

		aPedCli := Asort(aPedCli)//Ulisses Jr em 04/04/08

		mDcr := Left(mDcr,Len(mDcr)-1)
		SD2->(dbGoto(nPosReg))
		nElementos:= 1
		li:=li+1
		@ li,062 PSAY "X"
		@ li,85 PSAY SF2->F2_DOC     ;li:=li+2
		li:=li+2
		@ li,002 PSAY cnatureza1
		@ li,025 PSAY cnatureza2
		li:=li+3
		If SF2->F2_TIPO $ "D,B"
			@ li,002 PSAY SA2->A2_NOME
			@ li,060 PSAY SA2->A2_CGC Picture "@R 99.999.999/9999-99"
			@ li,086 PSAY SD2->D2_EMISSAO
			li:=li+2
			@ li,002 PSAY SA2->A2_END
			@ li,051 PSAY SA2->A2_BAIRRO 
			@ li,069 PSAY SA2->A2_CEP     ;li:=li+2
			@ li,002 PSAY SA2->A2_MUN
			@ li,039 PSAY SA2->A2_TEL
			@ li,056 PSAY SA2->A2_EST
			@ li,062 PSAY SA2->A2_INSCR   ;li:=li+3
		Else
			@ li,002 PSAY SA1->A1_NOME
			@ li,060 PSAY SA1->A1_CGC Picture "@R 99.999.999/9999-99"
			@ li,086 PSAY SD2->D2_EMISSAO
			li:=li+2
			@ li,002 PSAY SA1->A1_END
			@ li,051 PSAY SA1->A1_BAIRRO 
			@ li,069 PSAY SA1->A1_CEP     ;li:=li+2
			@ li,002 PSAY SA1->A1_MUN
			@ li,039 PSAY SA1->A1_TEL
			@ li,056 PSAY SA1->A1_EST
			@ li,062 PSAY SA1->A1_INSCR   ;li:=li+3
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona o SE1 para buscar contas  a receber                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE1")
		SE1->(dbSetOrder(1))
		SE1->(dbSeek(XFILIAL("SE1")+SD2->D2_SERIE+SD2->D2_DOC,.T.))
		adup1 := {} ; adup2 := {} ; adup3 := {} ; adup4 := {}
		mVencto:=SE1->E1_VENCTO
		While !SE1->(Eof()) .And. SD2->D2_SERIE+SD2->D2_DOC == SE1->E1_PREFIXO+SE1->E1_NUM .And. XFILIAL("SE1") == SE1->E1_FILIAL
			Aadd( adup1, SE1->E1_NUM)
			Aadd( adup2, SE1->E1_VALOR)  
			Aadd( adup3, SE1->E1_VENCTO)
			Aadd( adup4, SE1->E1_PARCELA)
			SE1->(dbSkip())
		Enddo

		mTot := 0
		//    @ li,008 PSAY SF2->F2_VALMERC Picture "@e 9,999,999.99"
		//    @ li,032 PSAY SF2->F2_DOC
		//    @ li,060 PSAY SF2->F2_VALMERC Picture "@e 9,999,999.99"

		@ li,008 PSAY SF2->F2_VALFAT Picture "@e 9,999,999.99"
		@ li,032 PSAY SF2->F2_DOC
		@ li,060 PSAY SF2->F2_VALFAT Picture "@e 9,999,999.99"
		If Len(adup1) == 1
			@ li,083 PSAY If( SF2->F2_COND == "887" , "C/ APRESENTACAO", mvencto)
			li:=li+7
		ElseIf Len(adup1) == 0  // JORGE 10/03/2000
			@ li,083 PSAY ""     // JORGE 10/03/2000
			li:=li+7             // JORGE 10/03/2000
		ElseIf Len(adup1) > 1
			@ li,083 PSAY "DIVERSOS"
			li:=li+3
			nLiRef := li+4
			@ li,005 PSAY SF2->F2_DOC
			For i:=1 To Len(adup4)
				@ li,17+((i-1)*2) PSAY adup4[i]+If(i <> Len(adup4),", ","")
				mTot := mTot + adup2[i]
			Next
			If Round(mTot,2) > SF2->F2_VALMERC
				adup2[1] := adup2[1] - (Round(mTot,2) - SF2->F2_VALMERC)
			ElseIf Round(mTot,2) < SF2->F2_VALMERC
				adup2[1] := adup2[1] + (SF2->F2_VALMERC - Round(mTot,2))
			Endif
			cl := 33
			For i:=1 to Len(adup1)
				@ li,cl    PSAY adup4[i]
				@ li,cl+8  PSAY If( SF2->F2_COND == "887" , "C/ APRESENTACAO", adup3[i])
				@ li,cl+19 PSAY Transform(adup2[i],"@E 999,999.99")
				cl := cl + 35
				If cl > 68
					cl := 33
					li := li+1
				Endif
			Next
			li := nLiRef
		Endif
		@ li,00 PSAY Chr(15)
		If SF2->F2_TIPO $ "D,B"
			@ li,005 PSAY SA2->A2_MUN+" "+SA2->A2_CEP
		Else 
			//Alterado por: Rogerio Siqueira 02/04/2009
			cEndCob := Alltrim(SA1->A1_ENDCOB) + "-" + Alltrim(SA1->A1_BAIRROC) + "-" + Alltrim(SA1->A1_MUNC) + "/"  
			cEndCob += Alltrim(SA1->A1_ESTC) + "-CEP: " + Alltrim(SA1->A1_CEPC)
			//@ li,005 PSAY iif(!Empty(),SA1->A1_ENDCOB,"") + SA1->A1_MUN+" "+LEFT(SA1->A1_CEP,5)+"-"+RIGHT(SA1->A1_CEP,3) //Adicionado Ener
			@ li,005 PSAY cEndCob //Alterado por: Rogerio Siqueira 02/04/2009
		Endif
		@ li,00 PSAY Chr(18)
		li:=li+4
		nLiref := li

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Analisa vetor para impressao dos itens para cada linha relacionada³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		mValprd := 0
		mQtot   := 0
		mQtot2  := 0
		mValant := 0
		lMaior  := .F.

		// Verifica se algum item é maior que R$ 999.999,99
		For nx := 1 to Len(aItens)
			If aItens[nx][8] > 999999.99
				lMaior := .T.
				Exit
			Endif
		Next

		For nx := 1 to 20 //ERA 15 MUDEI PARA 20 NO DIA 16/12 - ELOISE
			If Len(aItens) >= nElementos
				@ LI,000 PSAY Chr(15)
				If !lMaior
					If alltrim(aItens[nElementos][1]) == "MDO"
						@ LI,000 PSAY Chr(18)
						@ li,070 PSAY "----------"
						li:=li+1
						@ LI,014 PSAY "TOTAL DA MAT.PRIMA APL. "
						@ LI,068 PSAY mValprd Picture "@E 9,999,999.99"
						li:=li+1
						@ LI,000 PSAY Chr(15)
					Endif
					@ li,001 PSAY aItens[nElementos][1]
					@ li,016 PSAY aItens[nElementos][2]
					cDescAux := ""
					If SM0->M0_CODIGO <> '20' // Se não for Amazon Motion
						cDescAux := "Cor-"
					EndIf
					cDescAux += aItens[nElementos][12]
					@ li,070 PSAY cDescAux//"Cor-"+aItens[nElementos][11]
					@ li,000 PSAY Chr(18)
					@ li,046 PSAY aItens[nElementos][3]
					@ li,048 PSAY aItens[nElementos][4]
					@ li,051 PSAY aItens[nElementos][5]
					If aItens[nElementos][5] $ "MT,LT,M2,M3,ML,KG"  
						@ li,055 PSAY aItens[nElementos][6] Picture "@E 99999.99"// @ li,053 / Diego 07/01/09  999.99
					Else
						@ li,052 PSAY aItens[nElementos][6] Picture "@E 999999" //Picture "@E 99999" / @ li,053 / Diego 07/01/09  
					Endif

					If aItens[nElementos][5] $ "KG" .And. SM0->M0_CODIGO == "20"  // Se não for Amazon Motion 

						@ li,052 PSAY aItens[nElementos][7] Picture "@E 9,999.99"   //999.99 ROMULO 11/08/09
					Else
						if aItens[nElementos][5]$"UN,PC"
							if aItens[nElementos][5]!="PC"//Diego 12/01/09
								@ li,059 PSAY aItens[nElementos][7] Picture "@E 999,999.99"  //.99
							else
								@ li,061 PSAY aItens[nElementos][7] Picture "@E 999,999.99"
							EndIF
						else
							@ li,061 PSAY aItens[nElementos][7] Picture "@E 999,999.99" //59
						EndIf
					endif
					if aItens[nElementos][5]$"UN,PC"
						if aItens[nElementos][5]="PC"//Diego 12/01/09
							@ li,070 PSAY aItens[nElementos][8] Picture "@E 9,999,999.99"   //70
							@ li,082 PSAY aItens[nElementos][9] Picture "@R 99"             //84
							@ li,084 PSAY aItens[nElementos][10] Picture "@R 99"             //86
						else
							@ li,070 PSAY aItens[nElementos][8] Picture "@E 9,999,999.99" //3 casas decimais   //70
							@ li,082 PSAY aItens[nElementos][9] Picture "@R 99"           //84
							@ li,084 PSAY aItens[nElementos][10] Picture "@R 99"           //86
						Endif 
					else
						@ li,070 PSAY aItens[nElementos][8] Picture "@E 9,999,999.99"
						@ li,082 PSAY aItens[nElementos][9] Picture "@R 99"
						@ li,084 PSAY aItens[nElementos][10] Picture "@R 99"
					EndIF                                                
					If aItens[nElementos][11] == 0
						if aItens[nElementos][5]$"UN,PC"
							if aItens[nElementos][5]="PC"
								@ li,088 PSAY "ISENTO"   //90
							else
								@ li,089 PSAY "ISENTO"   //90
							EndIF 
						else
							@ li,089 PSAY "ISENTO"   //88
						EndIF
					Else
						@ li,087 PSAY aItens[nElementos][11] Picture "ww.@E 9,999.99"
					Endif
				Else
					If alltrim(aItens[nElementos][1]) == "MDO"
						@ li,070 PSAY "----------"
						li:=li+1
						@ LI,014 PSAY "TOTAL DA MAT.PRIMA APL. "
						@ LI,069 PSAY mValprd Picture "@E 9,999,999.99" 
						li:=li+1
					Endif
					@ li,001 PSAY SubStr(aItens[nElementos][1],1,10)
					@ li,013 PSAY aItens[nElementos][2]
					cDescAux := ""
					If SM0->M0_CODIGO <> '20' // Se não for Amazon Motion
						cDescAux := "Cor-"
					EndIf
					cDescAux += aItens[nElementos][12]
					@ li,067 PSAY cDescAux//"Cor-"+aItens[nElementos][11]
					@ li,079 PSAY aItens[nElementos][3]
					@ li,081 PSAY aItens[nElementos][4]
					@ li,088 PSAY aItens[nElementos][5]
					If aItens[nElementos][5] $ "MT,KG,LT"
						@ li,092 PSAY aItens[nElementos][6] Picture "@E 99999.99"
					Else
						@ li,095 PSAY aItens[nElementos][6] Picture "@E 99999"
					Endif

					If aItens[nElementos][5] $ "KG" .And. SM0->M0_CODIGO == "20"  // Se não for Amazon Motion 
						@ li,061 PSAY aItens[nElementos][7] Picture "@E 99.999999"
					eLSE
						@ li,061 PSAY aItens[nElementos][7] Picture "@E 9,999,999.99"   //106 ROMULO 10/09/09
					endif          

					@ li,126 PSAY aItens[nElementos][8] Picture "@E 9,999,999.99"
					@ li,139 PSAY aItens[nElementos][9] Picture "@R 99"
					@ li,143 PSAY aItens[nElementos][10] Picture "@R 99"

					If aItens[nElementos][11] == 0 
						@ li,155 PSAY "ISENTO"
					Else
						@ li,155 PSAY aItens[nElementos][11] Picture "@E 999,999.99"
					Endif
				Endif
				@ LI,PCol() PSAY Chr(18)
				li:=li+1

				If !Empty(aItens[nElementos][15]) .or. !Empty(aItens[nElementos][14])
					If !Empty(aItens[nElementos][15])
						@ li, 001 Psay "Cod. Cli.: "+aItens[nElementos][15] //Acrescentado por Ulisses Jr em 04/04/08
					EndIf
					If !Empty(aItens[nElementos][14])	
						@ li, 040 Psay "EAN : "+aItens[nElementos][14] //Acrescentado por Ulisses Jr em 04/04/08
					EndIf
					li:=li+1
				EndIf

				mValprd := mValprd + aItens[nElementos][8]
				mQtot1  := 0
				If aItens[nElementos][13] == "N"
					mQtot1 := aItens[nElementos][6] * 2
				Else
					mQtot1:=aItens[nElementos][6]
				Endif
				mQtot  := mQtot  + mQtot1
				mQtot2 := mQtot2 + aItens[nElementos][6]
			Endif

			nElementos:=nElementos+1
		Next nX
		If nx <> 1
			If !lMaior
				@ li,071 PSAY "----------"
				li:=li+1
				@ li,070 PSAY Transform(mValprd,"@E 9,999,999.99")    
			Else
				@ li,000 PSAY chr(15)
				@ li,125 PSAY "--------------"
				li:=li+1
				@ li,128 PSAY Transform(mValprd,"@E 9,999,999.99")
				@ li,000 PSAY chr(18)
			Endif
			li:=li+1
		Endif
		mTotdesc := 0
		If SC5->C5_DESC1 <> 0
			mTotDesc := mTotdesc + (SC5->C5_DESC1 * mValprd / 100)
			mValprd  := mValprd  - (SC5->C5_DESC1 * mValprd / 100)
			Col:=44    
			cDesconto := "DESCONTO PROMOCIONAL DE "+Alltrim(str(SC5->C5_DESC1,5,2))+"%" // Alterado por: Rogerio Siqueira, 02/04/2009 
			If SC5->C5_DESC2 <> 0
				nDesc526 := (SC5->C5_DESC2 * mValprd / 100)
				mTotDesc := mTotdesc + nDesc526
				mValprd  := mValprd  - nDesc526
				Col := 51
				cDesconto += " + " + Alltrim(str(SC5->C5_DESC2,5,2))+"%"
				If SC5->C5_DESC3 <> 0
					mTotDesc := mTotdesc + (SC5->C5_DESC3 * mValprd / 100)
					mValprd  := mValprd  - (SC5->C5_DESC3 * mValprd / 100)
					Col := 58
					//@ li,051 PSAY "+"+str(SC5->C5_DESC3,5,2) // Alterado por: Rogerio Siqueira, 02/04/2009 
					cDesconto += " + " + Alltrim(str(SC5->C5_DESC3,5,2))+"%"
					If SC5->C5_DESC4 <> 0
						mTotDesc := mTotdesc + (SC5->C5_DESC4 * mValprd / 100)
						mValprd  := mValprd  - (SC5->C5_DESC4 * mValprd / 100)
						Col := 65
						// @ li,058 PSAY "+"+str(SC5->C5_DESC4,5,2) // Alterado por: Rogerio Siqueira, 02/04/2009 
						cDesconto += " + " + Alltrim(str(SC5->C5_DESC4,5,2))+"%"
					Endif
				Endif
			Endif
			//@ li,014 PSAY "DESCONTO PROMOCIONAL DE "+str(SC5->C5_DESC1,5,2)+"%" // Ener
			@ li,009 PSAY cDesconto // Alterado por: Rogerio Siqueira, 02/04/2009 
			@ li,070 PSAY Transform(mTotdesc,"@E 9,999,999.99")//Ener
			li:=li+1
			@ li,070 PSAY "----------"
			li:=li+1
			//alterado dia 28/11/2008 por wendell santana
			IF mTes = "817"
				@ li,070 PSAY Transform(mValPrd,"@E 9,999,999.99")//Diego 21/01/09 SF2->F2_BASIMP5 por mValPrd
			else
				@ li,070 PSAY Transform(mValPrd,"@E 9,999,999.99")//Transform(SF2->F2_valbrut,"@E 9,999,999.99")
			endif              
			//fim da alteração do wendell santana
			li:=li+1
		Endif
		If mValdesc > 0.01
			Col:=44
			@ li,014 PSAY "DESCONTO ESPECIAL..: "+str(mValdesc,14,2)
			li:=li+1
		Endif 

		If mCond
			@ li,001 PSAY Chr(15)
			@ li,014 PSAY "DCR Nro. - " + mDcr
			@ li,087 PSAY Chr(18)
			li:=li+1
		Endif

		//    li := li + 1//nLiref + 14 // COMENTADO POR DIEGO 21/01/09
		If !Empty(SF4->F4_MENS1) .And. !Empty(SF4->F4_MENS2) .And. !Empty(SF4->F4_MENS3) .And. !Empty(cNFori) 
			li := nLiref + 11 
		ElseIf !Empty(SF4->F4_MENS1) .And. !Empty(SF4->F4_MENS2) .And. !Empty(cNFori) 
			li := nLiref + 12
		ElseIf !Empty(SF4->F4_MENS1) .And. !Empty(cNFori) 
			li := nLiref + 13
		ElseIf !Empty(SF4->F4_MENS1) .And. !Empty(SF4->F4_MENS2) .And. !Empty(SF4->F4_MENS3)
			li := nLiref + 12
		ElseIf !Empty(SF4->F4_MENS1) .And. !Empty(SF4->F4_MENS2)
			li := nLiref + 13
		ElseIf !Empty(SF4->F4_MENS1) 
			li := nLiref + 14
		EndIf
		If !Empty(SF4->F4_MENS1) .Or. !Empty(SF4->F4_MENS2) .Or. !Empty(SF4->F4_MENS3) 
			@ li,007 PSAY "OBSERVACAO:"
			li:=li+1
		EndIf
		If !Empty(SF4->F4_MENS1) 
			@ li,007 PSAY Alltrim(SF4->F4_MENS1)
			li:=li+1
		EndIf

		If !Empty(cNFori) 
			li--
			@ li,8+Len(Alltrim(SF4->F4_MENS1)) PSAY cNFori
		EndIf

		If !Empty(SF4->F4_MENS2) 
			@ li,If(Empty(cNFori),007,8+Len(Alltrim(cNFori))+Len(Alltrim(SF4->F4_MENS1))) PSAY Alltrim(SF4->F4_MENS2)
			li:=li+1
		EndIf
		If !Empty(SF4->F4_MENS3)
			@ li,007 PSAY Alltrim(SF4->F4_MENS3)
			li:=li+1
		EndIf    
		//    li := nLiref + 16 // Comentado por diego 21/01/09

		If !Empty(xCOD_MENS)
			@ li,000 PSAY Chr(15)
			//    @ li, 005 PSAY FORMULA(xCOD_MENS)+IIF(!Empty(SA1->A1_SUFRAMA)," Insc.Suframa: "+Alltrim(SA1->A1_SUFRAMA)+", Desconto ICMS: "+Transform(nDesc,"@E 999,999.99"),"")
			//Inicio Modificação Diego 21/01/09
			@ li, 005 PSAY FORMULA(xCOD_MENS);li++
			IF(!Empty(SA1->A1_SUFRAMA))
				@ li, 005 PSay " Insc.Suframa: "+Alltrim(SA1->A1_SUFRAMA)+", Desconto ICMS: "
				@ li, 000 PSAY Chr(18)
				@ li, 068 PSAY Transform(nDesc-SF2->F2_DESCONT,"@E 9,999,999.99");li++//067
				@ li,000 PSAY chr(18)
				@ li,071 PSAY "----------"
				li:=li+1
				@ li,068 PSAY Transform(mValprd - (nDesc-SF2->F2_DESCONT),"@E 9,999,999.99")
				@ li,000 PSAY chr(18)
			Endif
			//Fim Modificação Diego 21/01/09  
			@ li,000 PSAY Chr(18)

			// alterado dia 28/11/2008 po wendell santana
			wcol := 53
			If !Empty(SC5->C5_NTCONS)
				@ li,wcol PSAY alltrim(SC5->C5_NTCONS) //li,089
				@ li,wcol+=len(SC5->C5_NTCONS) PSAY " do dia " //li,095
				@ li,wcol+=8 PSAY mDtCons
				//fim alteração wendell santana
			EndIf
			li++
		Endif
		li := nLiref + 19
		dbSelectArea("SF2")
		@ li,005 PSAY SF2->F2_BASEICM Picture "@E 9,999,999.99"
		@ li,023 PSAY SF2->F2_VALICM  Picture "@E 9,999,999.99"
		@ li,042 PSAY SF2->F2_BRICMS  Picture "@E 9,999,999.99"
		@ li,061 PSAY SF2->F2_ICMSRET Picture "@E 9,999,999.99"

		If SF2->F2_TIPO $ "D,B"
			@ li,083 PSAY SF2->F2_VALMERC Picture "@E 9,999,999.99"
		Else
			If Empty(SA1->A1_SUFRAMA)
				@ li,083 PSAY SF2->F2_VALBRUT Picture "@E 9,999,999.99"
			Else       
				@ li,083 PSAY SF2->F2_VALMERC+nDesc Picture "@E 9,999,999.99"
			EndIf  
		endif

		li:=li+2
		@ li,005 PSAY SF2->F2_FRETE   Picture "@E 9,999,999.99"
		@ li,023 PSAY SF2->F2_SEGURO  Picture "@E 9,999,999.99"
		If SF2->F2_VALIPI == 0
			@ li,061 PSAY "ISENTO"
		Else
			@ li,061 PSAY SF2->F2_VALIPI  Picture "@E 9,999,999.99"
		Endif
		If SF2->F2_TIPO $ "D,B"
			@ li,083 PSAY SF2->F2_VALBRUT Picture "@E 9,999,999.99"
		Else
			If Empty(SA1->A1_SUFRAMA)
				@ li,083 PSAY SF2->F2_VALMERC Picture "@E 9,999,999.99"
			Else
				@ li,083 PSAY SF2->F2_VALBRUT Picture "@E 9,999,999.99"
			EndIf  
		Endif
		li:=li+3
		If ! (SF2->F2_TRANSP $ "01    ,02    ")
			@ li,002 PSAY cTransp
			@ li,055 PSAY cFrete
			@ li,059 PSAY cPlaca
		Endif
		li:=li+2
		If ! (SF2->F2_TRANSP $ "01    ,02    ")
			@ li,002 PSAY cEndTransp
			@ li,099 PSAY cMunTransp
			@ li,068 PSAY cEstTransp
		Endif
		li:=li+2
		IF SM0->M0_CODIGO == "20"  .AND. mUm == "KG"  
			nFator2 := EXECBLOCK("FATOR")  // Para Tratar amazom Motion 
		Endif   

		If mVolumes == 0 //.and. nFator2 > 0  romulo
			@ li,005 PSAY iif(SM0->M0_CODIGO == "20" .and. mUm == "KG",mQtot/nFator2,mQtot) Picture "@R 999999.99"  
		Else
			@ li,005 PSAY mVolumes Picture "@R 999999.99"  
		EndIf

		mEspecie := " "
		nFator2 := 0

		If Empty(mEspecie)
			Do Case
				Case mUm=="PC"
				mEspecie:="PECAS"
				Case mUm=="MT"
				mEspecie:="METROS"
				Case mUm=="M3"
				mEspecie:="M3"
				Case mUm=="KG"
				mEspecie:=iif(SM0->M0_CODIGO == "20" .AND. mUm=="KG","TAMBOR","KILOS") // .and. nFator2 > 0 
				Case mUm=="VL"
				mEspecie:="VOLUMES"
				Case mUm=="BL"
				mEspecie:="BLOCO"
			EndCase
		EndIf

		// nFator2 := 0  romulo 

		For nX := 1 to len(aPedCli)
			cPedCli += If(nX = 1,"",", ")+aPedCli[nX]
		Next nX

		@ li,017 PSAY mEspecie
		@ li,033 PSAY IIF(SM0->M0_CODIGO == "20","A.MOTION","PELMEX")  
		@ li,051 PSAY "01-"+strzero(mQtot2,6)
		@ li,065 PSAY mPBruto Picture "@E 99999.9999"   // Alterado Pesot por Peso
		@ li,086 PSAY mPeso   Picture "@E 99999.9999"   // Alterado Pesot por Peso
		li:=li+2
		@ li,000 PSAY Chr(15) 
		If !Empty(cPedCli)
			@ li,022 PSAY "Pedidos Cliente: "+Alltrim(cPedCli) //SubStr(cPedCli,1,Len(cPedCli)-1)
		EndIf
		li++
		/*  Sera ativado em outro momento, nao retirar
		If Len(xCLAS_FIS) >= 1
		@ li,001 PSAY xCLAS_FIS[1][2]+" - " 
		@ li,005 PSAY xCLAS_FIS[1][1] Picture "@R 9999.99.99"
		EndIf
		*/
		@ li,022 PSAY "RESOLUCAO DA SUFRAMA N. "+If(SM0->M0_CODIGO == "20","202/06","125/90")//64
		@ li,000 PSAY Chr(18)
		If mIcif == .T.
			li:=li+1
			@ li,000 PSAY Chr(15)
			/*  Sera ativado em outro momento, nao retirar
			If Len(xCLAS_FIS) >= 2
			@ li,001 PSAY xCLAS_FIS[2][2]+" - " 
			@ li,005 PSAY xCLAS_FIS[2][1] Picture "@R 9999.99.99"
			EndIf
			*/
			@ li,022 PSAY If(!Empty(mObs),"Obs: "+mObs,"")+Chr(18)
			li:=li+1
		Else
			li:=li+1
			@ li,000 PSAY Chr(15)
			/*  Sera ativado em outro momento, nao retirar
			If Len(xCLAS_FIS) >= 2
			@ li,001 PSAY xCLAS_FIS[2][2]+" - " 
			@ li,005 PSAY xCLAS_FIS[2][1] Picture "@R 9999.99.99"
			EndIf
			*/
			@ li,022 PSAY If(!Empty(mObs),"Obs: "+mObs,"")
			@ li,035 PSAY Chr(18)
			li:=li+1
		Endif
		@ li,000 PSAY Chr(15)
		//    @ li,005 PSAY mInbm1
		/*  Sera ativado em outro momento, nao retirar
		If Len(xCLAS_FIS) >= 3
		@ li,001 PSAY xCLAS_FIS[3][2]+" - " 
		@ li,005 PSAY xCLAS_FIS[3][1] Picture "@R 9999.99.99"
		EndIf
		*/
		dbSelectArea("SX5")
		dbSetOrder(1)
		///    dbSeek(XFILIAL("SX5")+"64"+SC5->C5_VIAT)//Ener
		dbSeek(XFILIAL("SX5")+"Z2"+SC5->C5_VIAT)   // Alterado pelo Ener
		@ li,017 PSAY "Via de Transporte: "+Left(SX5->X5_DESCRI,15)
		@ li,064 PSAY "Codigo do Cliente: "+SA1->A1_COD
		@ li,120 PSAY SF2->F2_DOC 
		li:=li+1
		//    @ li,005 PSAY mInbm2
		/*  Sera ativado em outro momento, nao retirar
		If Len(xCLAS_FIS) >= 4
		@ li,001 PSAY xCLAS_FIS[4][2]+" - " 
		@ li,005 PSAY xCLAS_FIS[4][1] Picture "@R 9999.99.99"
		EndIf
		*/
		If mIcif == .T.
			@ li,020 PSAY "OPERACAO COM CLAUSULA CIF"
		Endif
		If mCond == .T.
			@ li,050 PSAY "ISENTO DE IPI - PRODUZIDO NA ZONA FRANCA DE MANAUS"
		Endif
		li:=li+1
		/*  Sera ativado em outro momento, nao retirar
		If Len(xCLAS_FIS) >= 5
		@ li,001 PSAY xCLAS_FIS[5][2]+" - " 
		@ li,005 PSAY xCLAS_FIS[5][1] Picture "@R 9999.99.99"
		EndIf
		*/
		@ li,017 PSAY "Vendedor: "+SC5->C5_VEND1
		@ li,033 PSAY "Pedido: "+SubStr(mPed,1,Len(mPed)-1)
		@ li,070 PSAY Chr(18)

		If SF2->F2_SERIE <> "UNR"
			@ li,114 PSAY Left(mSerie,02)+" "+Left(SF2->F2_SELOFIS,10)
		Endif

		li:= li+1
		/*  Sera ativado em outro momento, nao retirar
		If Len(xCLAS_FIS) >= 6
		@ li,001 PSAY xCLAS_FIS[6][2]+" - " 
		@ li,005 PSAY xCLAS_FIS[6][1] Picture "@R 9999.99.99"
		EndIf
		*/
		li:=li+4
		@ li,083 PSAY SF2->F2_DOC
		mInbm1:="";mInbm2:=""
		li:=li+6
		dbSelectArea("SF2")




		SF2->(dbSkip())

		WHILE  SF2->F2_SERIE != MV_PAR03 .AND. !SF2->(Eof())

			SF2->(dbSkip())

		ENDDO

	Enddo

	dbSelectArea("SF2")
	SF2->(dbSetOrder(1))
	If aReturn[5] == 1
		Set Printer TO 
		dbcommitAll()
		ourspool(wnrel)
	Endif
	MS_FLUSH()
Return
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³    Fim do Programa TESNF.PRG, Obrigado pela Aten‡Æo !                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ