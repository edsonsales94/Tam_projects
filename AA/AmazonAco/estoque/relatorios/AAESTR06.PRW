#include "rwmake.ch"
#include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ AAESTR06() ³Autor ³  		              ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Imprime etiquetas de c¢digo de barras em impressoras ARGOX ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Espec¡fico para clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AAESTR06()

SetPrvt("CPERG,NRESP")
Private cPerg1 := "AAESTR06"

ValidPerg(cPerg1)
Pergunte(cPerg1, .T.)

@ 96,042 TO 323,505 DIALOG oDlg TITLE "Impressão de Etiquetas de Código de Barras"

@ 02,005 SAY " Este programa imprimirá etiquetas de código de barras na im-   "
@ 03,005 SAY " pressora ARGOX de acordo com os  parâmetros  definidos  pelo   "
@ 04,005 SAY " usuário.   "

@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg1)
@ 91,168 BMPBUTTON TYPE 1 ACTION ArgoxImp()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg)

Activate Dialog oDlg Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ArgoxImp ³ Autor ³ Asael				    ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Imprime as etiquetas                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ AP                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ArgoxImp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Prepara a porta para impressao                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MsgYesNo("A etiqueta está posicionada e a impressora ligada?")
	RptStatus({|| ArgoxRun() })
EndIf

Return(nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ArgoxRun ³ Autor ³ Asael                 ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Laco para impressao                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ AP                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ArgoxRun() 
               
DbSelectArea("SB1")
DbSetOrder(1)
If SB1->(DbSeek(xFilial("SB1")+MV_PAR01)) 
	If MV_PAR05 >= 1
		For nK := 1 To MV_PAR05
			ArgoxEtq()
		NExt nK
	EndIf      
EndIf

#IFDEF WINDOWS
	Set Device To Screen
	Set Printer To
#ENDIF

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ArgoxEtq ³ Autor ³ Asael			        ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Imprime n etiquetas de codigo de barras conforme solicitado³±±
±±³          ³ nos parametros.                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ArgoxEtq()  
LOCAL _cZModel,_cZPorta

_cZModel := "OS 214"             //String referente a impressora
_cZPorta := "LPT2"  //"COM1:9600,N,8,2"    //cPorta

MSCBPRINTER(_cZModel,_cZPorta, , , , , , , , ) //Carrega impressora

MSCBCHKStatus(.F.)               //Sem verificação de status

MSCBBEGIN(1,3)                   //Starta a impressão (primeiro parametro numero de copias)

If Empty(Mv_Par10)
	DDMMAAAA := Right(dtos(dDataBase),2)+"/"+Substr(dtos(dDataBase),5,2)+"/"+Left(dtos(dDataBase),4)
Else
	DDMMAAAA := Right(dtos(Mv_Par10),2)+"/"+Substr(dtos(Mv_Par10),5,2)+"/"+Left(dtos(Mv_Par10),4)
End If


//Impressão dos labels fixos
MSCBSAY   (   05, 48, "ITEM:",		"N","2","1,1")
MSCBSAY   (   05, 30, "COMP:",		"N","2","1,1")
MSCBSAY   (   30, 30, "ESP:",			"N","2","1,1")
MSCBSAY   (   50, 30, "LOTE:",		"N","2","1,1")
MSCBSAY   (   05, 24, "OC/OP:",		"N","2","1,1")
MSCBSAY   (   29, 24, "F/C:",			"N","2","1,1")
MSCBSAY   (   05, 18, "1a UM:",		"N","2","1,1")

If !Empty(SB1->B1_SEGUM)
	MSCBSAY   (   58, 18, "2a UM:",			"N","2","1,1")
End If

//Impressão das variaveis
MSCBSAY   (   58, 54, DDMMAAAA,										"N","3","1,1")
MSCBSAY   (   15, 48, SB1->B1_COD,									"N","4","1,1")
MSCBSAY   (   62, 50, Time(),									    "N","2","1,1")

If MV_Par11 = 1
	MSCBSAY   (   05, 36, ALLTRIM(SB1->B1_DESC),					"N","5","1,1")
Else
	MSCBSAY   (   05, 42, Left(SB1->B1_ESPECIF, 37),			"N","4","1,1")
	MSCBSAY   (   05, 36, Subs(SB1->B1_ESPECIF, 38),			"N","4","1,1")
End If

MSCBSAY   (   15, 30, Alltrim(MV_PAR02),							"N","2","1,1")
MSCBSAY   (   37, 30, Alltrim(MV_PAR03),							"N","2","1,1")
MSCBSAY   (   60, 30, Alltrim(MV_PAR06),							"N","2","1,1")
MSCBSAY   (   15, 24, Alltrim(MV_PAR07),							"N","2","1,1")
MSCBSAY   (   37, 24, Alltrim(MV_PAR09),							"N","2","1,1")
MSCBSAY   (   15, 16, Transform(MV_PAR04,"@RE 999,999 "+SB1->B1_UM),	"N","5","1,1")

If !Empty(SB1->B1_SEGUM)
	MSCBSAY   (   68, 16, Transform(MV_PAR08,"@RE 99,999 "+SB1->B1_SEGUM),	"N","5","1,1")
End If

MSCBSAYBAR(   20, 02, MSCB128C()+ALLTRIM(SB1->B1_COD)+DDMMAAAA+StrZero(mv_par04*1000,9,0)+StrZero(mv_par08,5,0)+Alltrim(MV_PAR07),"N","MB07",10,.F.,.T.,.F.,,3,2,,.F.,.F.,.F.) // Codigo de Barra EAN 128C

MSCBEND()    		// Finaliza etiqueta

MSCBClosePrinter()  // Fecha conexão com a porta

Return


Static Function ValidPerg(cPerg)

PutSX1(cPerg,"01",PADR("Produto",29)+"?"     , "","","mv_ch1","C", 08,0,0,"G","","SB1","","","mv_par01")
PutSX1(cPerg,"02",PADR("Comprimento",29)+"?" , "","","mv_ch2","C", 10,0,0,"G", "",  "","","","mv_par02")
PutSX1(cPerg,"03",PADR("Espessura",29)+"?"   , "","","mv_ch3","C", 10,0,0,"G", "",  "","","","mv_par03")
PutSX1(cPerg,"04",PADR("Peso",29)+"?"        , "","","mv_ch4","N", 09,3,0,"G", "",  "","","","mv_par04")
PutSX1(cPerg,"05",PADR("Copias",29)+"?"      , "","","mv_ch5","N", 10,0,0,"G", "",  "","","","mv_par05")
PutSX1(cPerg,"06",PADR("Lote",29)+"?"        , "","","mv_ch6","C", 12,0,0,"G", "",  "","","","mv_par06")
PutSX1(cPerg,"07",PADR("OC/OP",29)+"?"       , "","","mv_ch7","C", 11,0,0,"G", "",  "","","","mv_par07")
PutSX1(cPerg,"08",PADR("Quant",29)+"?"       , "","","mv_ch8","N", 05,0,0,"G", "",  "","","","mv_par08")
PutSX1(cPerg,"09",PADR("Forn/Cli",29)+"?"    , "","","mv_ch9","C", 20,3,0,"G", "",  "","","","mv_par09")
PutSX1(cPerg,"10",PADR("Data",29)+"?"  		, "","","mv_cha","D", 08,0,0,"G", "",  "","","","mv_par10")
PutSX1(cPerg,"11",PADR("Descrição",29)+"?"	, "","","mv_chb","N", 01,0,0,"C","","   ","","","mv_par11","Genérica","","","","Específica")

Return Nil
