#include "rwmake.ch"
#include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ AAESTR02() ³Autor ³  Asael               ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Imprime etiquetas de c¢digo de barras em impressoras ARGOX ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Espec¡fico para clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AAESTR02()

SetPrvt("CPERG,NRESP")
Private cPerg1 := "ARGOXB"

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
PRIVATE cPerg2 := PADR("AARGOXIT",Len(SX1->X1_GRUPO))

MountTable()
While WHDS->(!Eof())
	VldFolder()
//	aMV_PAR1 := aClone(SetBkp(1))
//	ValidPerg(cPerg2,"2")
//	Pergunte(cPerg2, .T. , WHDS->B1_ESPECIF )
//	aMV_PAR2 := aClone(SetBkp(2))
//	Pergunte(cPerg1, .F.)
	
//	For nK := 1 To MAX(1,aMv_PAR2[04])
//		ArgoxEtq(aMV_PAR2[01],aMV_PAR2[02],aMV_PAR2[03],aMV_PAR2[05])
//	NExt nK
	
	WHDS->(dbSkip())
End

#IFDEF WINDOWS
	Set Device To Screen
	Set Printer To
#ENDIF

DbCloseArea("WHDS")

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
Static Function ArgoxEtq(cComp,cEsp,nPes,cLote,nQuant)//(cX,cY,nZ,_cA)
LOCAL _cZModel,_cZPorta

_cZModel := "OS 214"             //String referente a impressora
_cZPorta := "LPT2"  //"COM1:9600,N,8,2"    //cPorta

MSCBPRINTER(_cZModel,_cZPorta, , , , , , , , ) //Carrega impressora

MSCBCHKStatus(.F.)               //Sem verificação de status


MSCBLOADGRF("SYSTEM\SIGA.BMP")   //Carrega imagem da logo
MSCBLOADGRF("SIGA.BMP")   //Carrega imagem da logo

MSCBBEGIN(1,3)                   //Starta a impressão (primeiro parametro numero de copias)

DDMMAAAA := Right(dtos(dDataBase),2)+"/"+Substr(dtos(dDataBase),5,2)+"/"+Left(dtos(dDataBase),4)

MSCBGRAFIC(06,56,"SIGA")         //Descarrega a imagem na etiqueta


//Impressão dos labels fixos
MSCBSAY   (   05, 48, "ITEM:",		"N","2","1,1")
MSCBSAY   (   05, 30, "COMP:",		"N","2","1,1")
MSCBSAY   (   30, 30, "ESP:",			"N","2","1,1")
MSCBSAY   (   50, 30, "LOTE:",		"N","2","1,1")
MSCBSAY   (   05, 24, "PESO:",		"N","2","1,1")
MSCBSAY   (   60, 24, "QTD:",			"N","2","1,1")
MSCBSAY   (   05, 18, "OC/OP:",		"N","2","1,1")
MSCBSAY   (   29, 18, "FORN:",		"N","2","1,1")

(cComp,cEsp,nPes,cLote,nQuant)//(cX,cY,nZ,_cA)
//Impressão das variaveis
MSCBSAY   (   58, 54, DDMMAAAA,		"N","3","1,1")
MSCBSAY   (   15, 48, WHDS->D1_COD,	"N","3","1,1")
MSCBSAY   (   62, 48, Time(),			"N","2","1,1")
MSCBSAY   (   05, 42, SUBSTR(ALLTRIM(WHDS->B1_ESPECIF),1,40),"N","3","1,1")
MSCBSAY   (   05, 36, SUBSTR(ALLTRIM(WHDS->B1_ESPECIF),41),	"N","3","1,1")
MSCBSAY   (   15, 30, cComp,"N","3","1,1")
MSCBSAY   (   40, 30, cEsp,"N","3","1,1")
MSCBSAY   (   60, 30, cLote,"N","3","1,1")
MSCBSAY   (   15, 24, Transform(nPes,"@RE 999,999.999 KG"),"N","3","1,1")
MSCBSAY   (   68, 24, Transform(nQuant,"@RE 99,999 PC"),"N","3","1,1")
MSCBSAY   (   15, 18, WHDS->D1_PEDIDO,"N","3","1,1")
MSCBSAY   (   42, 18, SubStr(WHDS->A2_NOME,1,35),"N","3","1,1")

MSCBSAYBAR(  20, 02, MSCB128C()+WHDS->D1_COD+DDMMAAAA+StrZero(nPes*1000,9,0)+StrZero(nQuant,5,0)+WHDS->D1_PEDIDO,"N","MB07",10,.F.,.T.,.F.,,3,2,,.F.,.F.,.F.) // Codigo de Barra EAN 128C

/*
//Impressão dos labels fixos
MSCBSAY   (   61, 67, "FONE:"+Transform(SM0->M0_TEL,"@R (99) 9999-9999"),"N","2","1,1")
MSCBSAY   (   52, 64, "EMAIL: AMAZONACO@AMAZONACO.COM.BR","N","2","1,1")
MSCBSAY   (   10, 48, "ITEM:","N","2","1,1")
MSCBSAY   (   45, 48, "DATA-HORA","N","2","1,1")
MSCBSAY   (   56, 30, "PESO: ","N","2","1,1")
MSCBSAY   (   35, 30, "ESP:","N","2","1,1")
MSCBSAY   (   10, 30, "COMP:","N","2","1,1")
MSCBSAY   (   40, 24, "LOTE:","N","2","1,1")
MSCBSAY   (   10, 24, "OC:","N","2","1,1")
MSCBSAY   (   10, 18, "FORNECEDOR:","N","2","1,1")

//Impressão das variaveis
MSCBSAY   (   20, 48, WHDS->D1_COD,"N","3","1,1")
MSCBSAY   (   60, 48, DDMMAAAA,"N","2","1,1")
MSCBSAY   (   10, 42, SUBSTR(ALLTRIM(WHDS->B1_ESPECIF),1,42),"N","3","1,1")
MSCBSAY   (   10, 36, SUBSTR(ALLTRIM(WHDS->B1_ESPECIF),43,LEN(ALLTRIM(WHDS->B1_ESPECIF))),"N","3","1,1")
MSCBSAY   (   65, 30, Transform(nZ,"@E 999,999.99")+"KG","N","3","1,1")
MSCBSAY   (   42, 30, cY,"N","3","1,1")  //iNFORMAR
MSCBSAY   (   18, 30, cX,"N","3","1,1")
MSCBSAY   (   50, 24, _cA,"N","3","1,1")
MSCBSAY   (   18, 24, WHDS->D1_PEDIDO,"N","3","1,1")
MSCBSAY   (   29, 18, SubStr(WHDS->A2_NOME,1,35) ,"N","3","1,1")

MSCBSAYBAR(   14, 04, MSCB128C()+WHDS->D1_COD+SUBSTR(DDMMAAAA,1,10)+Transform(nZ,"@E 999,999,999.99")+WHDS->D1_PEDIDO,"N","MB07",10,.F.,.T.,.F.,,4,3,,.F.,.F.,.F.) // Codigo de Barra EAN 128C
*/
MSCBEND()    		// Finaliza etiqueta

MSCBClosePrinter()  // Fecha conexão com a porta

Return


Static Function ValidPerg(cPerg,_cTipo)

Local nTam := TamSX3("F1_DOC")[1]

Default _cTipo := "1"

If _cTipo == "1"
	PutSX1(cPerg,"01",PADR("Da Nota ",29)+"?"    ,"","","mv_ch1","C",nTam,0,0,"G","","SF1","","","mv_par01")
	PutSX1(cPerg,"02",PADR("Ate Nota ",29)+"?"   ,"","","mv_ch2","C",nTam,0,0,"G","","SF1","","","mv_par02")
	PutSX1(cPerg,"03",PADR("Da Serie",29)+"?"    ,"","","mv_ch3","C",  03,0,0,"G","","    ","","","mv_par03")
	PutSX1(cPerg,"04",PADR("Ate Serie",29)+"?"   ,"","","mv_ch4","C",  03,0,0,"G","","    ","","","mv_par04")
	PutSX1(cPerg,"05",PADR("Do Item",29)+"?"     , "","","mv_ch5","C", 04,0,0,"G", "",   "","","","mv_par05")
	PutSX1(cPerg,"06",PADR("Ate Item",29)+"?"    , "","","mv_ch6","C", 04,0,0,"G", "",   "","","","mv_par06")
Else
	PutSX1(cPerg,"01",PADR("Comprimento",29)+"?" , "","","mv_ch1","C", 10,0,0,"G", "",   "","","","mv_par01")
	PutSX1(cPerg,"02",PADR("Espessura",29)+"?"   , "","","mv_ch2","C", 10,0,0,"G", "",   "","","","mv_par02")
	PutSX1(cPerg,"03",PADR("Peso",29)+"?"        , "","","mv_ch3","N", 10,0,0,"G", "",   "","","","mv_par03")
	PutSX1(cPerg,"04",PADR("Copias",29)+"?"      , "","","mv_ch4","N", 10,0,0,"G", "",   "","","","mv_par04")
	PutSX1(cPerg,"05",PADR("Lote",29)+"?"        , "","","mv_ch5","C", 12,0,0,"G", "",   "","","","mv_par05")
EndIf

Return


Static Function MountTable()
Local cQry    := ""
Local lRet    := .T.

cQry += " SELECT D1_COD, B1_DESC , B1_ESPECIF, A2_NOME, D1_QUANT, D1_PEDIDO  FROM  " + RetSqlName("SD1")  + "  SD1

cQry += " INNER JOIN " + RetSqlName("SB1")  + " SB1 ON B1_COD = D1_COD
cQry += " AND SB1.D_E_L_E_T_ = ' '

cQry += " INNER JOIN " + RetSqlName("SA2")  + " SA2 ON D1_FORNECE = A2_COD
cQry += " AND SA2.D_E_L_E_T_ = ' ' AND D1_LOJA = A2_LOJA

cQry += " WHERE SD1.D_E_L_E_T_ = ' '
cQry += " AND SD1.D1_DOC BETWEEN '" + MV_PAR01  + "' AND '" + MV_PAR02 +"'
cQry += " AND SD1.D1_SERIE BETWEEN '" + MV_PAR03  + "' AND '" + MV_PAR04 +"'
cQry += " AND SD1.D1_ITEM BETWEEN '" + MV_PAR05  + "' AND '" + MV_PAR06 +"'
cQry += " ORDER BY D1_COD, B1_DESC , A2_NOME "

dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "WHDS", .T., .F. )
dbSelectArea("WHDS")

Return Nil


Static Function SetBkp(_cTipo)
Local nI := 1
Local aMV_PAR := {}
Default _cTipo := 1
If _cTipo == 1
	aAdd(aMv_PAR, mv_par01)
	aAdd(aMv_PAR, mv_par02)
	aAdd(aMv_PAR, mv_par03)
	aAdd(aMv_PAR, mv_par04)
	aAdd(aMv_PAR, mv_par05)
	aAdd(aMv_PAR, mv_par06)
else
	aAdd(aMv_PAR, mv_par01)
	aAdd(aMv_PAR, mv_par02)
	aAdd(aMv_PAR, mv_par03)
	aAdd(aMv_PAR, mv_par04)
	aAdd(aMv_PAR, mv_par05)
EndIf
Return aMV_PAR

Static Function GetBkp(aMv_Par,_cTipo)
Default _cTipo = 1
If _cTipo == 1
	mv_par01 := aMv_par[01]
	mv_par02 := aMv_par[02]
	mv_par03 := aMv_par[03]
	mv_par04 := aMv_par[04]
	mv_par05 := aMv_par[05]
	mv_par06 := aMv_par[06]
else
	mv_par01 := aMv_par[01]
	mv_par02 := aMv_par[02]
	mv_par03 := aMv_par[03]
	mv_par04 := aMv_par[04]
	mv_par05 := aMv_par[05]
EndIf
Return Nil


/* Valida a entrada que sao informacoes confidenciais */
Static Function VldFolder()

Local oTela
Private cComp := Space(10), cEsp := Space(10) , nPes := Space(10), cLote := Space(12), nCopias := "  0", nOpc := 0, nQuant := Space(5)

DEFINE MSDIALOG oTela TITLE "Informacoes Item "From 8,70 To 27,100 OF oMainWnd

@ 05,010 SAY  SubStr(Alltrim(WHDS->B1_ESPECIF),1,40)  PIXEL OF oTela
@ 20,010 SAY  SubStr(Alltrim(WHDS->B1_ESPECIF),41,len(Alltrim(WHDS->B1_ESPECIF)))  PIXEL OF oTela
@ 35,010 SAY "Comprimento" PIXEL OF oTela
@ 35,050 GET cComp SIZE 30,10 PIXEL OF oTela
@ 50,010 SAY "Espessura" PIXEL OF oTela
@ 50,050 GET cEsp SIZE 30,10 PIXEL OF oTela
@ 65,010 SAY "Peso" PIXEL OF oTela
@ 65,050 GET nPes SIZE 30,10 PIXEL OF oTela
@ 80,010 SAY "Lote" PIXEL OF oTela
@ 80,050 GET cLote SIZE 45,10 PIXEL OF oTela
@ 95,010 SAY "Copias" PIXEL OF oTela
@ 95,050 GET nCopias SIZE 20,10 PIXEL OF oTela
@ 110,010 SAY "Quant" PIXEL OF oTela
@ 110,050 GET nQuant SIZE 30,10 PIXEL OF oTela

@ 123,010 BUTTON oBut1 PROMPT "&Ok" SIZE 30,12 OF oTela PIXEL;
Action IIF(VldSenha(),(nOpc:=1,oTela:End()),(nOpc:=1,oTela:End()))
@ 123,060 BUTTON oBut2 PROMPT "&Cancela" SIZE 30,12 OF oTela PIXEL;
Action oTela:End()

ACTIVATE MSDIALOG oTela

lRet := (nOpc == 1)

Return(lRet)


STATIC FUNCTION VldSenha()
Local lRetu := .F.

If Val(nCopias) >= 1
	For nK := 1 To Val(nCopias)
		ArgoxEtq(cComp,cEsp,Val(nPes),cLote,Val(nQuant))
	NExt nK
	lRetu := .T.
EndIf

RETURN lRetu
