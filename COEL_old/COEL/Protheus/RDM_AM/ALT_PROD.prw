#include "rwmake.ch"

User Function ALT_PROD()

SetPrvt("XCONT,XPRODINI,XPRODFIM,XTIPOINI,XTIPOFIM,CSN")
SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,W,Z")
SetPrvt("M,CCOR,CSAVSCR1,CSAVCUR1,CSAVROW1,CSAVCOL1")
SetPrvt("CSAVCOR1,NOPC,CCHAVE,CINDSB7,NSB7,XCODANT")
SetPrvt("XCODNOVO,XRECPOS,")


/*
®---------------------------------------------------------------------------®
| Programa  | ALT_PROD  | Autor |Rogerio Batista       |  Data | 31/05/11   |
®---------------------------------------------------------------------------®
|  Descricao|  PROMOVE A TROCA DOS CODIGOS DE PRODUTOS, FOI NECESSARIO      |
|           |  RESTM05 PARA GERAR UM NOVO CÓDIGO ANTES DE TROCAR            |
®---------------------------------------------------------------------------®
|              ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL             |
®---------------------------------------------------------------------------®


MV_PAR01   -  Produto Velho de   :
MV_PAR02   -  Produto Velho Ate  :
MV_PAR03   -  Tipo de            :
MV_PAR04   -  Tipo Ate           :
*/

//PARAMETROS

xCONT    :=.T.
xPRODINI := SPACE(30)
xPRODFIM := SPACE(30)
xTIPOINI := SPACE(2)
xTIPOFIM := SPACE(2)
CSN      := " "
CbTxt    := ""
CbCont   := ""
nOrdem   := 0
Alfa     := 0
W        := 1
Z        := 0
M        := 0
cCor     := "B/BG"

While xCONT == .T.
	@ 150,200 TO 370,406 DIALOG xJANELA TITLE "Alteracao de Produtos"
	@ 10,08 Say "Prod.Velho de   "
	@ 25,08 Say "Prod.Velho Ate  "
	@ 40,08 Say "Tipo de         "
	@ 55,08 Say "Tipo Ate        "
	
	@ 10,48 Get  xPRODINI
	@ 25,48 Get  xPRODFIM VALID xPRODFIM >= xPRODINI
	@ 40,48 Get  xTIPOINI
	@ 55,48 Get  xTIPOFIM VALID xTIPOFIM >= xTIPOINI
	@ 95,32 button "OK" size 35,15 action close(xJANELA)
	//	@ 95,68 button "SAIR" size 35,15 action close(xJANELA)
	ACTIVATE DIALOG xJANELA
	
	IF MsgYesNo("Confirma Processamento")
		nOpc := 1
	Else
		noPC := 2
	Endif
	Do Case
		Case nOpc==1
			xCONT :=.F.
		Case nOpc==2
			xCONT :=.F.
			Return
	EndCase
Enddo



Processa( {|| GRAVACAO() })

Return()

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GRAVACAO ³ Autor ³ MARCIO A ALMENARA     ³ Data ³ 03/06/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava o arquivo de custos                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

Static FUNCTION GRAVACAO()
/*
DbSelectArea("SB7")

cChave  := "B7_FILIAL+B7_COD"
cIndSB7 := CriaTrab(,.F.)
IndRegua("SB7",cIndSB7,cChave,,,"Selecionando Registros...")
nSB7    :=RetIndex("SB7")
DbSelectArea("SB7")
DbSetIndex(cIndSb7+ordbagext())
DbSetOrder(nsb7+1)
*/
Dbselectarea("SB1")
DbsetOrder(1)

ProcRegua(Reccount())

Dbgotop()


While !eof()
	
	
	IF EMPTY(SB1->B1_X_CNEW)
		Dbskip()
		Loop
	Endif
	
	IF SB1->B1_X_MRPAM == "X"
		Dbskip()
		Loop
	Endif
	
	If  SB1->B1_COD < xPRODINI .OR. SB1->B1_COD > xPRODFIM
		Dbskip()
		Loop
	Endif
	
	If SB1->B1_TIPO < xTIPOINI .OR. SB1->B1_TIPO > xTIPOFIM
		Dbskip()
		Loop
	Endif
	
	IncProc("Aguarde... Alteracao do produto - "+SB1->B1_COD)
	
	xCODANT  := SB1->B1_COD
	xCODNOVO := SB1->B1_X_CNEW
/*	
	Dbselectarea("AB2")
	DbsetOrder(4)
	If Dbseek(xFILIAL("AB2")+xCODANT)
		While !eof() .and. AB2->AB2_CODPRO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("AB2",.F.)
			AB2->AB2_CODPRO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("AB4")
	DbsetOrder(5)
	If Dbseek(xFILIAL("AB4")+xCODANT)
		While !eof() .and. AB4->AB4_CODPRO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("AB4",.F.)
			AB4->AB4_CODPRO := xCODNOVO
			AB4->AB4_CLPROD := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("AB5")
	DbsetOrder(3)
	If Dbseek(xFILIAL("AB5")+xCODANT)
		While !eof() .and. AB5->AB5_CODPRO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("AB5",.F.)
			AB5->AB5_CODPRO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("AB7")
	DbsetOrder(6)
	If Dbseek(xFILIAL("AB7")+xCODANT)
		While !eof() .and. AB7->AB7_CODPRO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("AB7",.F.)
			AB7->AB7_CODPRO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("AB8")
	DbsetOrder(6)
	If Dbseek(xFILIAL("AB8")+xCODANT)
		While !eof() .and. AB8->AB8_CODPRO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("AB8",.F.)
			AB8->AB8_CODPRO := xCODNOVO
			AB8->AB8_CODPRD := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("ABA")
	DbsetOrder(4)
	If Dbseek(xFILIAL("ABA")+xCODANT)
		While !eof() .and. ABA->ABA_CODPRO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("ABA",.F.)
			ABA->ABA_CODPRO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SA5")
	DbsetOrder(2)
	If Dbseek(xFILIAL("SA5")+xCODANT)
		While !eof() .and. SA5->A5_PRODUTO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SA5",.F.)
			SA5->A5_PRODUTO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SA7")
	DbsetOrder(2)
	If Dbseek(xFILIAL("SA7")+xCODANT)
		While !eof() .and. SA7->A7_PRODUTO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SA7",.F.)
			SA7->A7_PRODUTO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SB0")
	DbsetOrder(1)
	If Dbseek(xFILIAL("SB0")+xCODANT)
		While !eof() .and. SB0->B0_COD <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SB0",.F.)
			SB0->B0_COD := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
*/	
	Dbselectarea("SB2")
	DbsetOrder(1)
	
	If Dbseek(xFILIAL("SB2")+xCODANT)
		While !eof() .and. SB2->B2_COD <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SB2",.F.)
			SB2->B2_COD := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	/*
	Dbselectarea("SB3")
	DbsetOrder(1)
	If Dbseek(xFILIAL("SB3")+xCODANT)
		While !eof() .and. SB3->B3_COD <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SB3",.F.)
			SB3->B3_COD := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	EndIf
	
	
	Dbselectarea("SB5")
	DbsetOrder(1)
	If Dbseek(xFILIAL("SB5")+xCODANT)
		While !eof() .and. SB5->B5_COD <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SB5",.F.)
			SB5->B5_COD := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SB6")
	DbsetOrder(1)
	If Dbseek(xFILIAL("SB6")+xCODANT)
		While !eof() .and. SB6->B6_PRODUTO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SB6",.F.)
			SB6->B6_PRODUTO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	/*
	Dbselectarea("SB7")
	DbSetOrder(nsb7+1)
	
	If Dbseek(xFILIAL("SB7")+xCODANT)
	While !eof() .and. SB7->B7_COD <= xCODANT
	Dbskip()
	xRECPOS := RECNO()
	Dbskip(-1)
	Reclock("SB7",.F.)
	SB7->B7_COD := xCODNOVO
	MsUnlock()
	Dbgoto(xRECPOS)
	Enddo
	Endif
	*/
	Dbselectarea("SB8")
	DbsetOrder(1)
	If Dbseek(xFILIAL("SB8")+xCODANT)
		While !eof() .and. SB8->B8_PRODUTO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SB8",.F.)
			SB8->B8_PRODUTO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SB9")
	DbsetOrder(1)
	If Dbseek(xFILIAL("SB9")+xCODANT)
		While !eof() .and. SB9->B9_COD <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)                                              
			Reclock("SB9",.F.)
			SB9->B9_COD := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	EndIf
	
	Dbselectarea("SC1")
	DbsetOrder(2)
	If Dbseek(xFILIAL("SC1")+xCODANT)
		While !eof() .and. SC1->C1_PRODUTO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SC1",.F.)
			SC1->C1_PRODUTO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SC2")
	DbsetOrder(2)
	If Dbseek(xFILIAL("SC2")+xCODANT)
		While !eof() .and. SC2->C2_PRODUTO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SC2",.F.)
			SC2->C2_PRODUTO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SC4")
	DbsetOrder(1)
	If Dbseek(xFILIAL("SC4")+xCODANT)
		While !eof() .and. SC4->C4_PRODUTO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SC4",.F.)
			SC4->C4_PRODUTO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SC6")
	DbsetOrder(2)
	If Dbseek(xFILIAL("SC6")+xCODANT)
		While !eof() .and. SC6->C6_PRODUTO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SC6",.F.)
			SC6->C6_PRODUTO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SC7")
	DbsetOrder(2)
	If Dbseek(xFILIAL("SC7")+xCODANT)
		While !eof() .and. SC7->C7_PRODUTO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SC7",.F.)
			SC7->C7_PRODUTO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SC8")
	DbsetOrder(6)
	If Dbseek(xFILIAL("SC8")+xCODANT)
		While !eof() .and. SC8->C8_PRODUTO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SC8",.F.)
			SC8->C8_PRODUTO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SC9")
	DbsetOrder(7)
	If Dbseek(xFILIAL("SC9")+xCODANT)
		While !eof() .and. SC9->C9_PRODUTO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SC9",.F.)
			SC9->C9_PRODUTO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SD1")
	DbsetOrder(2)
	If Dbseek(xFILIAL("SD1")+xCODANT)
		While !eof() .and. SD1->D1_COD <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SD1",.F.)
			SD1->D1_COD := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SD2")
	DbsetOrder(1)
	If Dbseek(xFILIAL("SD2")+xCODANT)
		While !eof() .and. SD2->D2_COD <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SD2",.F.)
			SD2->D2_COD := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SD3")
	DbsetOrder(3)
	If Dbseek(xFILIAL("SD3")+xCODANT)
		While !eof() .and. SD3->D3_COD <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SD3",.F.)
			SD3->D3_COD := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SD4")
	DbsetOrder(1)
	If Dbseek(xFILIAL("SD4")+xCODANT)
		While !eof() .and. SD4->D4_COD <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SD4",.F.)
			SD4->D4_COD := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SD5")
	DbsetOrder(2)
	If Dbseek(xFILIAL("SD5")+xCODANT)
		While !eof() .and. SD5->D5_PRODUTO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SD5",.F.)
			SD5->D5_PRODUTO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SD8")
	DbsetOrder(1)
	If Dbseek(xFILIAL("SD8")+xCODANT)
		While !eof() .and. SD8->D8_PRODUTO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SD8",.F.)
			SD8->D8_PRODUTO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SFT")
	DbsetOrder(7)
	If Dbseek(xFILIAL("SFT")+xCODANT)
		While !eof() .and. SFT->FT_PRODUTO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SFT",.F.)
			SFT->FT_PRODUTO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
*/	
	Dbselectarea("SG1")
	DbsetOrder(1)
	If Dbseek(xFILIAL("SG1")+xCODANT)
		While !eof() .and. SG1->G1_COD <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SG1",.F.)
			SG1->G1_COD := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SG1")
	DbsetOrder(2)
	If Dbseek(xFILIAL("SG1")+xCODANT)
		While !eof() .and. SG1->G1_COMP <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			Reclock("SG1",.F.)
			SG1->G1_COMP := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
	
	Dbselectarea("SG2")
	DbsetOrder(1)
	If Dbseek(xFILIAL("SG2")+xCODANT)
		While !eof() .and. SG2->G2_PRODUTO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			RecLock("SG2",.F.)
			SG2->G2_PRODUTO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
/*	
	Dbselectarea("SHC")
	DbsetOrder(2)
	If Dbseek(xFILIAL("SHC")+xCODANT)
		While !eof() .and. SHC->HC_PRODUTO <= xCODANT
			Dbskip()
			xRECPOS := RECNO()
			Dbskip(-1)
			RecLock("SHC",.F.)
			SHC->HC_PRODUTO := xCODNOVO
			MsUnlock()
			Dbgoto(xRECPOS)
		Enddo
	Endif
*/	
	
	Dbselectarea("SB1")
	Dbsetorder(1)
	Dbskip()
	xRECPOS := RECNO()
	Dbskip(-1)
	Reclock("SB1",.F.)
	SB1->B1_COD     := xCODNOVO
	SB1->B1_X_CNEW  := xCODANT
	SB1->B1_X_MRPAM := "X"
	MsUnlock()
	Dbgoto(xRECPOS)
Enddo

Return


