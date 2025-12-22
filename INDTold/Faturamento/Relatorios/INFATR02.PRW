#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOTVS.CH"
/*/
+---------------------------------------------------------------------------------------------------------------+
|     Programa     |     INFATR02     |     Autor     |     Wagner Correa     |     Data     |     22/07/10     |
+---------------------------------------------------------------------------------------------------------------+
|     Descricao    |     Impressao da Invoice Selecionada                                                       |
+---------------------------------------------------------------------------------------------------------------+
|     Uso          |     Faturamento - Relatório                                                                |
+---------------------------------------------------------------------------------------------------------------+
/*/
User Function INFATR02

Local cPerg := PADR("INFATR02",Len(SX1->X1_GRUPO))

Private oLeTxt
Private nPag  := 1
Private nTPag := 1

ValidPerg(cPerg)

Pergunte(cPerg,.T.)
@ 200,001 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Impressao de Invoice")
@ 002,010 TO 80,190
@ 010,018 SAY " Este programa ira imprimir a Invoice, conforme parâ- "
@ 018,018 SAY " tros informados.                                     "
@ 026,018 SAY "                                                      "
@ 070,098 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
@ 070,128 BMPBUTTON TYPE 01 ACTION FATR02EXEC()
@ 070,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

ACTIVATE DIALOG oLeTxt CENTERED

Return
//
//
//
Static Function FATR02EXEC()
Local nOpc    := 0
Local i 
nOpc := 1
If nOpc == 1
	Processa({|lEnd|FATR02PROC()})
EndIf
Close(oLeTxt)
Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFun‡„o    ³COM01IMP  º Autor ³ Imprime o Pedido   º Data ³  04/10/2002 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³Imprime a Invoice                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AP6                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FATR02PROC()
Local cQuery := ""
Local nRecs 	:= 0
Loca i 
Private oPrn := TMSPrinter():New( "Relatório Gráfico" )
oBrush:= TBrush():New(,CLR_YELLOW)

DEFINE FONT oFont08B NAME "Arial" SIZE 0,08 Bold OF oPrn;	DEFINE FONT oFont08 NAME "Arial" SIZE 0,08 OF oPrn
DEFINE FONT oFont09B NAME "Arial" SIZE 0,09 Bold OF oPrn;	DEFINE FONT oFont09 NAME "Arial" SIZE 0,09 OF oPrn
DEFINE FONT oFont10B NAME "Arial" SIZE 0,10 Bold OF oPrn;	DEFINE FONT oFont10 NAME "Arial" SIZE 0,10 OF oPrn
DEFINE FONT oFont11B NAME "Arial" SIZE 0,11 Bold OF oPrn;	DEFINE FONT oFont11 NAME "Arial" SIZE 0,11 OF oPrn
DEFINE FONT oFont12B NAME "Arial" SIZE 0,12 Bold OF oPrn;	DEFINE FONT oFont12 NAME "Arial" SIZE 0,12 OF oPrn
DEFINE FONT oFont14B NAME "Arial" SIZE 0,14 Bold OF oPrn;	DEFINE FONT oFont14 NAME "Arial" SIZE 0,14 OF oPrn
DEFINE FONT oFont16B NAME "Arial" SIZE 0,16 Bold OF oPrn;	DEFINE FONT oFont16 NAME "Arial" SIZE 0,16 OF oPrn
DEFINE FONT oFont20B NAME "Arial" SIZE 0,20 Bold OF oPrn;	DEFINE FONT oFont20 NAME "Arial" SIZE 0,20 OF oPrn
DEFINE FONT oFont22B NAME "Arial" SIZE 0,22 Bold OF oPrn;	DEFINE FONT oFont22 NAME "Arial" SIZE 0,22 OF oPrn
DEFINE FONT oFont36B NAME "Arial" SIZE 0,36 Bold OF oPrn;	DEFINE FONT oFont36 NAME "Arial" SIZE 0,36 OF oPrn
DEFINE FONT oFont48B NAME "Arial" SIZE 0,48 Bold OF oPrn;	DEFINE FONT oFont48 NAME "Arial" SIZE 0,48 OF oPrn

DEFINE FONT oFntCN08B NAME "Courier New" SIZE 0,08 Bold OF oPrn;	DEFINE FONT oFntCN08 NAME "Courier New" SIZE 0,08 OF oPrn
DEFINE FONT oFntCN09B NAME "Courier New" SIZE 0,09 Bold OF oPrn;	DEFINE FONT oFntCN09 NAME "Courier New" SIZE 0,09 OF oPrn
DEFINE FONT oFntCN10B NAME "Courier New" SIZE 0,10 Bold OF oPrn;	DEFINE FONT oFntCN10 NAME "Courier New" SIZE 0,10 OF oPrn
DEFINE FONT oFntCN11B NAME "Courier New" SIZE 0,11 Bold OF oPrn;	DEFINE FONT oFntCN11 NAME "Courier New" SIZE 0,11 OF oPrn
DEFINE FONT oFntCN12B NAME "Courier New" SIZE 0,12 Bold OF oPrn;	DEFINE FONT oFntCN12 NAME "Courier New" SIZE 0,12 OF oPrn
DEFINE FONT oFntCN14B NAME "Courier New" SIZE 0,14 Bold OF oPrn;	DEFINE FONT oFntCN14 NAME "Courier New" SIZE 0,14 OF oPrn
DEFINE FONT oFntCN16B NAME "Courier New" SIZE 0,16 Bold OF oPrn;	DEFINE FONT oFntCN16 NAME "Courier New" SIZE 0,16 OF oPrn
DEFINE FONT oFntCN20B NAME "Courier New" SIZE 0,20 Bold OF oPrn;	DEFINE FONT oFntCN20 NAME "Courier New" SIZE 0,20 OF oPrn
DEFINE FONT oFntCN22B NAME "Courier New" SIZE 0,22 Bold OF oPrn;	DEFINE FONT oFntCN22 NAME "Courier New" SIZE 0,22 OF oPrn
DEFINE FONT oFntCN36B NAME "Courier New" SIZE 0,36 Bold OF oPrn;	DEFINE FONT oFntCN36 NAME "Courier New" SIZE 0,36 OF oPrn
DEFINE FONT oFntCN48B NAME "Courier New" SIZE 0,48 Bold OF oPrn;	DEFINE FONT oFntCN48 NAME "Courier New" SIZE 0,48 OF oPrn

cQry := "SELECT ISNULL(COUNT(*), 0) SOMA "
cQry +=    "FROM " + RetSqlName("SC5") + " "
cQry += "WHERE D_E_L_E_T_=' ' AND C5_INVOICE = '" + mv_par01 + "'"
cQry +=    "AND C5_FILIAL = '" + SM0->M0_CODFIL + "' " 

dbUseArea(.T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TMP", .T., .T.)
dbSelectArea("TMP")
dbGoTop()

_nSoma := SOMA

dbSelectArea("TMP")
dbCloseArea()

If _nSoma = 0
	MsgInfo("Invoice inexistente ou nao pertence a esta filial. Favor verificar.")
	Return
EndIf

cQry := StrTran( cQry, "ISNULL(COUNT(*), 0) SOMA", "*")
dbUseArea(.T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TMP", .T., .T.)
dbSelectArea("TMP")
dbGoTop()

dbSelectArea("SZ6")
dbSetOrder(1)
dbSeek( xFilial("SZ6")+'6'+TMP->C5_NUM)
_cMemo := AllTrim(SZ6->Z6_OBJETIV)

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek( xFilial() + TMP->C5_CLIENTE + TMP->C5_LOJACLI )

dbSelectArea("TMP")

oPrn:SetPortrait() // Estilo retrato
oPrn:StartPage()   // Inicia uma nova página

oPrn:Box (  150, 110, 2950, 2360)
oPrn:SayBitmap(155,115,"\SYSTEM\LGRL01.BMP",323,185)

oPrn:Say(190, 880, SM0->M0_NOMECOM,                                                 oFont10,,,,3)
oPrn:Say(230, 880, SM0->M0_ENDCOB ,                                                 oFont10,,,,3)
oPrn:Say(270, 880, SM0->M0_BAIRCOB,                                                 oFont10,,,,3)
oPrn:Say(310, 880, "C.E.P.: " + Transform( SM0->M0_CEPCOB, "@R 99999-999"),         oFont10,,,,3)
oPrn:Say(350, 880, "C.N.P.J.: " + Transform( SM0->M0_CGC, "@R 99.999.999.9999-99"), oFont10,,,,3)

oPrn:Say(430,950,"INVOICE", oFont16B,,,,3)
oPrn:Say(530,150,"B",       oFont14B,,,,3)
oPrn:Say(575,150,"I",       oFont14B,,,,3)
oPrn:Say(620,150,"L",       oFont14B,,,,3)
oPrn:Say(665,150,"L",       oFont14B,,,,3)
oPrn:Say(765,150,"T",       oFont14B,,,,3)
oPrn:Say(810,150,"O",       oFont14B,,,,3)

oPrn:Box(500, 0220, 860, 1220)
oPrn:Say(540, 0250, SA1->A1_NOME, oFont08,,,,3)
oPrn:Say(580, 0250, SA1->A1_END,  oFont08,,,,3)
oPrn:Say(620, 0250, SA1->A1_MUN,  oFont08,,,,3)
oPrn:Say(660, 0250, SA1->A1_CEP,  oFont08,,,,3)
oPrn:Say(540, 1500, "No.              " + AllTrim(TMP->C5_INVOICE) , oFntCN10,,,,3)
oPrn:Say(580, 1500, "Date             " + AllTrim( cMonth(StoD(TMP->C5_EMISINV)) ) +", " + StrZero( Day(StoD(TMP->C5_EMISINV)), 2) + IIF( Day(StoD(TMP->C5_EMISINV)) = 1, "st ", IIF( Day(StoD(TMP->C5_EMISINV))=2, "nd", IIF(Day(StoD(TMP->C5_EMISINV)) = 3, "rd", "th "))) + StrZero( Year(StoD(TMP->C5_EMISINV)), 4), oFntCN10,,,,3)
oPrn:Say(660, 1500, "PO NUMBER        " , oFntCN10B,,,,3)

aPgto := Condicao( 1, TMP->C5_CONDPAG, 0, StoD(TMP->C5_EMISSAO) )
oPrn:Say(800, 1500, "Due:             " + AllTrim( cMonth(aPgto[1, 1]) ) +", " + StrZero( Day(aPgto[1, 1]), 2) + IIF( Day(aPgto[1, 1]) = 1, "st ", IIF( Day(aPgto[1, 1])=2, "nd", IIF(Day(aPgto[1, 1]) = 3, "rd", "th "))) + StrZero( Year(aPgto[1, 1]), 4), oFntCN10,,,,3)


_nBox2 := 0

If TMP->C5_CLIENTE+TMP->C5_LOJACLI <> TMP->C5_CLIENT+TMP->C5_LOJAENT
	_nBox2 := 410
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek( xFilial() + TMP->C5_CLIENT + TMP->C5_LOJAENT )
	
	oPrn:Say( _nBox2 + 530, 150, "S", oFont14B,,,,3)
	oPrn:Say( _nBox2 + 575, 150, "H", oFont14B,,,,3)
	oPrn:Say( _nBox2 + 620, 150, "I", oFont14B,,,,3)
	oPrn:Say( _nBox2 + 665, 150, "P", oFont14B,,,,3)
	oPrn:Say( _nBox2 + 765, 150, "T", oFont14B,,,,3)
	oPrn:Say( _nBox2 + 810, 150, "O", oFont14B,,,,3)
	
	oPrn:Box( _nBox2 + 500, 0220, _nBox2 + 860, 1220)
	oPrn:Say( _nBox2 + 540, 0250, SA1->A1_NOME, oFont08,,,,3)
	oPrn:Say( _nBox2 + 580, 0250, SA1->A1_END,  oFont08,,,,3)
	oPrn:Say( _nBox2 + 620, 0250, SA1->A1_MUN,  oFont08,,,,3)
	oPrn:Say( _nBox2 + 660, 0250, SA1->A1_CEP,  oFont08,,,,3)
	
EndIf

oPrn:Line( _nBox2 +  900, 110, _nBox2 +  900, 2360)
oPrn:Line( _nBox2 + 1000, 110, _nBox2 + 1000, 2360)

oPrn:Say ( _nBox2 + 930, 0500, "Description", oFntCN09,,,,3)
oPrn:Say ( _nBox2 + 930, 1250, "Qty.",        oFntCN09,,,,3)
oPrn:Say ( _nBox2 + 930, 1530, "Unit/" +AllTrim(GetMv( "MV_SIMB"+StrZero( TMP->C5_MOEDA, 1) )), oFntCN09,,,,3)
oPrn:Say ( _nBox2 + 930, 1880, "Total/"+AllTrim(GetMv( "MV_SIMB"+StrZero( TMP->C5_MOEDA, 1) )), oFntCN09,,,,3)
oPrn:Line( _nBox2 + 2750, 0110, _nBox2 + 2750, 2360)

dbSelectArea("SC6")
dbSetOrder(1)
dbSeek( xFilial("SC6") + TMP->C5_NUM, .T.)

_nLinha := _nBox2 + 1010
_nTotal := 0
While !Eof() .and. TMP->C5_NUM = SC6->C6_NUM
	
	_lPrim := .T.
	For i:= 1 To MLCount(_cMemo, 70)
		oPrn:Say ( _nLinha, 0150, Memoline( _cMemo, 70, i),                        oFntCN09,,,,3 )
		If _lPrim
         oPrn:Say( 660, 1780, SC6->C6_PEDCLI, oFntCN10B,,,,3)
			oPrn:Say ( _nLinha, 1150, Transform( SC6->C6_QTDVEN, "999,999,999"),    oFntCN09,,,,3 )
			oPrn:Say ( _nLinha, 1430, Transform( SC6->C6_PRCVEN, "999,999,999.99"), oFntCN09,,,,3 )
			oPrn:Say ( _nLinha, 1780, Transform( SC6->C6_VALOR,  "999,999,999.99"), oFntCN09,,,,3 )
			_lPrim := .F.
		EndIf
		
		_nLinha += 45
	Next
	
	_cMemo := AllTrim(SC6->C6_MOPC)
	
	For i:= 1 To MLCount(_cMemo, 85)
		oPrn:Say ( _nLinha, 0150, Memoline( _cMemo, 85, i),                        oFntCN09,,,,3 )
		If _lPrim
         oPrn:Say( 660, 1750, SC6->C6_PEDCLI, oFntCN10B,,,,3)
			oPrn:Say ( _nLinha, 1150, Transform( SC6->C6_QTDVEN, "999,999,999"),    oFntCN09,,,,3 )
			oPrn:Say ( _nLinha, 1430, Transform( SC6->C6_PRCVEN, "999,999,999.99"), oFntCN09,,,,3 )
			oPrn:Say ( _nLinha, 1780, Transform( SC6->C6_VALOR,  "999,999,999.99"), oFntCN09,,,,3 )
			_lPrim := .F.
		EndIf
		
		_nLinha += 45
	Next
	
	_nTotal += SC6->C6_VALOR
	dbSelectArea("SC6")
	dbSkip()
End

dbSelectArea("TMP")

oPrn:Say(2200, 1530, "Total", oFntCN10B,,,,3)
oPrn:Say(2200, 1780, Transform( _nTotal, "999,999,999.99") , oFntCN10B,,,,3)

dbSelectArea("SZG")
dbSetOrder(1)
dbSeek( xFilial() + StrZero(TMP->C5_MOEDA, 1) )

dbSelectArea("TMP")

oPrn:Say(2350,  130, "Currency: " + GetMv( "MV_SIMB"+StrZero( TMP->C5_MOEDA, 1) ) , oFntCN10,,,,3)
oPrn:Say(2395,  130, "Intermediary Bank: " + AllTrim(SZG->ZG_NOMBANC) + " - " + AllTrim(SZG->ZG_ESTCID) + " - " + AllTrim(SZG->ZG_PAIS), oFntCN08,,,,3)
oPrn:Say(2440,  130, "SWIFT: " + AllTrim(SZG->ZG_SWIFT) + " - Account: " + AllTrim(SZG->ZG_CONTA) + " - ABA: " + AllTrim(SZG->ZG_ABA), oFntCN08,,,,3)

oPrn:Say(2485,  130, "Beneficiary Bank: Banco Itau BBA S/A - Sao Paulo-S.P. - Brazil - Swift code: " + SubStr(SZG->ZG_SWIFT, At( "CODE", SZG->ZG_SWIFT) + 6, 20) ,OFNTCN08,,,,3)
oPrn:Say(2530,  130, "Final Beneficiary: Instituto Nokia de Tecnologia - Brasilia - DF - Brazil",OFNTCN08,,,,3)
oPrn:Say(2575,  130, "Final Beneficiary Account 57091-2 - Agency 0686 - Bank no. 341",OFNTCN08,,,,3)

oPrn:FillRect( {2620, 115, 2680, 2360}, oBrush)
oPrn:Say(2630,  650, "PIs inform the Invoice Number at the wire transfer documents when making a payment.",OFONT09B,,,,3)


oPrn:Say(2830, 1550, "Instituto Nokia de Tecnologia",OFONT10B,,,,3)
oPrn:Say(2875, 1400, AllTrim(GetMv("MV_YGERCON"))+ " / Gerente de Controladoria",OFONT10B,,,,3)

dbSelectArea("TMP")
dbCloseArea("TMP")

oPrn:EndPage() // Finaliza a página
oPrn:Preview() // Visualiza antes de imprimir

Return nil
//
//
//
Static Function ValidPerg(cPerg)
u_INPutSX1(cPerg,"01","Invoice                   ?","Invoices                  ?","Invoice                   ?","mv_ch1","C",15 ,0 ,0 ,"G","","","","","mv_par01","","","","","","","","","","","","","","","")
Return
