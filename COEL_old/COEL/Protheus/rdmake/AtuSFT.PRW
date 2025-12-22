#include "rwmake.ch"

User Function ATUSFT()

SetPrvt("XCONT,XPRODINI,XPRODFIM,XTIPOINI,XTIPOFIM,CSN")
SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,W,Z")
SetPrvt("M,CCOR,CSAVSCR1,CSAVCUR1,CSAVROW1,CSAVCOL1")
SetPrvt("CSAVCOR1,NOPC,CCHAVE,CINDSB7,NSB7,XCODANT")
SetPrvt("XCODNOVO,XRECPOS,")


/*
®---------------------------------------------------------------------------®
| Programa  | ATUSFT   | Autor |Rogerio Batista       |  Data | 24/02/14    |
®---------------------------------------------------------------------------®
|  Descricao|  Atualiza as aliquotas e os valores do PIS/COFINS com base    |
|           |  no regime de tributacao do cliente                           |
®---------------------------------------------------------------------------®
|              ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL             |
®---------------------------------------------------------------------------®


MV_PAR01   -  NF de:
MV_PAR02   -  NF ate:
*/               

IF SM0->M0_CODFIL <> "01"
	MsgBox("Esta rotina so pode ser executada na filial de Manaus","Atençao","INFO" )

Return
EndIf

//PARAMETROS

xCONT    :=.T.
xNFIni := SPACE(09)
xNFFim := SPACE(09)
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
	@ 150,200 TO 370,406 DIALOG xJANELA TITLE "Alteracao de Aliq PIS/Cofins"
	@ 10,08 Say "NF de : "
	@ 25,08 Say "NF ate: "
	
	@ 10,48 Get  xNFIni //picture "@E 99/99/99"
	@ 25,48 Get  xNFFim //picture "@E 99/99/99" //VALID xPRODFIM >= xPRODINI
	//	@ 40,48 Get  xTIPOINI
	//	@ 55,48 Get  xTIPOFIM VALID xTIPOFIM >= xTIPOINI
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

Dbselectarea("SD2")
DbsetOrder(3) //Data de Emissao
Dbseek(xFILIAL("SD2")+xNFIni)
While !eof() .and. SD2->D2_DOC <= xNFFim
		_cRegTrib:= Posicione("SA1",1,xFilial("SA1")+SD2->D2_CLIENTE,"A1_REGTRIB")
		If _cRegTrib$"1/2/3"
			If SD2->D2_CF$"6401 /5401 /6101 /5101 /6107 "
				Reclock("SD2",.F.)
				SD2->D2_ALQIMP5  := 6    //Cofins
				SD2->D2_ALQIMP6  := 1.30 //Pis
				SD2->D2_VALIMP5  := SD2->D2_BASIMP5*SD2->D2_ALQIMP5/100 //Cofins
				SD2->D2_VALIMP6  := SD2->D2_BASIMP6*SD2->D2_ALQIMP6/100 //Pis
				MsUnlock()
			EndIf
		ElseIf _cRegTrib$"4/5"
			If SD2->D2_CF$"6401 /5401 /6101 /5101 /6107 "
				Reclock("SD2",.F.)
				SD2->D2_ALQIMP5  := 3    //Cofins
				SD2->D2_ALQIMP6  := 0.65 //Pis
				SD2->D2_VALIMP5  := SD2->D2_BASIMP5*SD2->D2_ALQIMP5/100 //Cofins
				SD2->D2_VALIMP6  := SD2->D2_BASIMP6*SD2->D2_ALQIMP6/100 //Pis
				MsUnlock()
			EndIf
		Else
			MsgBox("Cliente sem cadastro de Regime Tributario SD2! "+SD2->D2_CLIENTE,"Atençao","INFO" )
		EndIf

		dbSkip()
		Loop

	Enddo

Dbselectarea("SFT")
DbsetOrder(6) //Data de Entrada
Dbseek(xFILIAL("SFT")+"S"+xNFIni)
	While !eof() .and. SFT->FT_NFISCAL <= xNFFim
//		Dbskip()
//		xRECPOS := RECNO()
//		Dbskip(-1)
		_cRegTrib:= Posicione("SA1",1,xFilial("SA1")+SFT->FT_CLIEFOR,"A1_REGTRIB")
		If _cRegTrib$"1/2/3"
			If SFT->FT_CSTCOF == "02" .AND. SFT->FT_CSTPIS == "02"
				Reclock("SFT",.F.)
				SFT->FT_ALIQCOF  := 6    //Cofins
				SFT->FT_ALIQPIS  := 1.30 //Pis
				SFT->FT_VALCOF  := SFT->FT_BASECOF*SFT->FT_ALIQCOF/100 //Cofins
				SFT->FT_VALPIS  := SFT->FT_BASEPIS*SFT->FT_ALIQPIS/100 //Pis
				MsUnlock()
			EndIf
		ElseIf _cRegTrib$"4/5"
			If SFT->FT_CSTCOF == "02" .AND. SFT->FT_CSTPIS == "02"
				Reclock("SFT",.F.)
				SFT->FT_ALIQCOF  := 3    //Cofins
				SFT->FT_ALIQPIS  := 0.65 //Pis
				SFT->FT_VALCOF  := SFT->FT_BASECOF*SFT->FT_ALIQCOF/100 //Cofins
				SFT->FT_VALPIS  := SFT->FT_BASEPIS*SFT->FT_ALIQPIS/100 //Pis
				MsUnlock()
			EndIf
		Else
			MsgBox("Cliente sem cadastro de Regime Tributario SFT! "+SFT->FT_CLIEFOR,"Atençao","INFO" )
			
		EndIf 
		
		dbSkip()
		Loop

	Enddo

Return


