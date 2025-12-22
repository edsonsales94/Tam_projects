#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include 'TopConn.ch'  
#Include 'font.ch'
#Include 'RPTDEF.CH'    
#Include 'TBICONN.CH'   
#Include "RWMAKE.CH"           
#Include "FWPrintSetup.ch" 
/*/{protheus.doc}HLAFAT01
Impressão de Etiquetas de Produto c/ codigo de Barras (AvPrint) 
@author TEOFILO ALVES MONTEIRO FILHO - TOTVS IP     
@since 05/09/08
/*/

/*
|-----------------------------------------------------------------------------------|
|  Programa : HLETQMAN                                      Data : 05/09/08         |
|-----------------------------------------------------------------------------------|
|  Cliente  : Honda Lock                                                            |
|-----------------------------------------------------------------------------------|
|  Responsável Microsiga no Cliente : Pool                                          |
|  Responsável Microsiga Modulo     : Rodrigo                                       |
|-----------------------------------------------------------------------------------|
|  Uso      : Impressão de Etiquetas de Produto c/ codigo de Barras (AvPrint)       |
|                                                                                   |
|-----------------------------------------------------------------------------------|
|  Autor    : TEOFILO ALVES MONTEIRO FILHO - TOTVS IP                               |
|-----------------------------------------------------------------------------------|
| Tabelas Envolvidas  :Cadastro de Produtos          : SB1                          |
|-----------------------------------------------------------------------------------|
*/ 
  
/**********************/
USER FUNCTION HLETQMAN()
/**********************/

// VARIAVEIS PUBLICAS
PUBLIC O_DIALOG       := NIL

// OBJETOS SAY
PUBLIC O_NOMEPROD    := NIL

Private dDataExp:= ddatabase
Private cLotePro:= Space(15)
Private cDoc	:= Space(6)
Private cSerie	:= Space(3)
Private cSequen := Space(3)
Private cLoteFab:= Space(10)
Private nQuant	:= 0
Private cCodSerp:= Space(10)
Private cCodPeca:= Space(30)
Private cDescPec:= Space(50)
Private cModelo := Space(20) // B1_CODMODE
Private cEndLin := Space(20)
Private cEndEst := Space(20)
Private nQtdEtiq:= 1


// LINHA,COLUNA To LINHA,COLUNA

// DIMENSÕES DA DIALOG
// X JANELA PROTHEUS,Y JANELA PROTHEUS TO ALTURA (CIMA P/ BAIXO), LARGURA (ESQUERDA P/ DIREITA)
@ 115,085 To 550,800 Dialog oDlg Title OemToAnsi("Emissão Etiquetas HONDA Vrs.05.03.14")

// BORDA DA DIALOG
@ 002,002 To 184,359

// BORDA INTERNA (DADOS DO FORNECEDOR)
@ 004,165 To 040,357

// VINCULANDO O OBJETO A UMA VARIAVEL
O_DIALOG := oDlg

@ 010,008 Say OemToAnsi("Data Expedição:")
@ 025,008 Say OemToAnsi("Lote Produção Honda:")
@ 040,008 Say OemToAnsi("No.Doc.Fiscal (NF + Série + Sequência):")
@ 055,008 Say OemToAnsi("Lote Fabricação:")
@ 070,008 Say OemToAnsi("Quantidade:")
@ 085,008 Say OemToAnsi("Código Serpen:")
@ 100,008 Say OemToAnsi("Código da Peça(Honda):")
@ 115,008 Say OemToAnsi("Peça Descrição:")
@ 130,008 Say OemToAnsi("Modelo Tipo Aplicação:")
@ 145,008 Say OemToAnsi("Endereço na Linha:")
@ 160,008 Say OemToAnsi("Endereço de Estoque:")
@ 175,008 Say OemToAnsi("Quantidade de Etiquetas:")

// CAMPOS
@ 010,070 Get dDataExp										SIZE 004,10
@ 025,070 Get cLotePro										Size 050,10
@ 040,110 Get cDoc											Size 012,10
@ 040,135 Get cSerie										Size 003,10
@ 040,160 Get cSequen		                  				Size 005,10
@ 055,070 Get cLoteFab										Size 050,10
@ 070,070 Get nQuant         PICTURE "@E 999,999,999.99"	Size 050,10
@ 085,070 Get cCodSerp	                                  	Size 050,10
@ 100,070 Get cCodPeca		 Picture "@!" F3 "HLSB1"        Size 100,10 VALID LOADPROD()
@ 145,070 Get cEndLin										Size 100,10
@ 160,070 Get cEndEst										Size 100,10
@ 175,070 Get nQtdEtiq		 Picture "999" 

// INFORMAÇÕES DO FORNECEDOR
@ 006,170 Say "PRODUTO : " + SPACE(100)                                     OBJECT O_NOMEPROD

@ 200,006 BUTTON "Imprimir" SIZE 030,010 ACTION(IMPETQ())
@ 200,046 BUTTON "Sair" SIZE 030,010 ACTION(CLOSE(O_DIALOG))

ACTIVATE DIALOG ODLG CENTERED

RETURN() // Etiq()


//*****************************************************************************
STATIC FUNCTION LOADPROD()
//*****************************************************************************

Local lReturn := .F.

O_NOMEPROD:SetText( "PRODUTO : " + ALLTRIM(Posicione("SB1",12,xFilial("SB1") + cCodPeca ,"B1_DESCNF" )) )
O_NOMEPROD:Refresh()
cDescPec := IIF(EMPTY(SB1->B1_DESC), SB1->B1_DESCNF, SB1->B1_DESC)
cModelo  := SB1->B1_CODMODE
@ 115,070 Get cDescPec										Size 200,10
@ 130,070 Get cModelo										Size 100,10
SB1->(DbSetOrder(14))
lReturn := SB1->(DbSeek(xFilial('SB1') + m->cCodPeca  ))
If ! lReturn 
	Alert('Codigo '+m->cCodPeca+', nao encotrado !!')
EndIf
cDescPec := SB1->B1_DESC
Return(lReturn)


//*****************************************************************************
STATIC FUNCTION IMPETQ()
//*****************************************************************************

If nQtdEtiq > 0
	U_XGerETQMa()
	//ImpEtiq()
	Alert("Impressao Efetuada c/ Sucesso !",)
Else
	Alert("A Quantidade das etiquetas deve ser obrigatóriamente superior a zero !")
End If

RETURN(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GeraEtqMa  ³ Autor ³ Marcos Martins        ³ Data ³ 24.06.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa Impressao de Etiquetas                              ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico HONDA LOCK                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function XGerETQMa()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define Variaveis                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cStartPath := GetSrvProfString("Startpath","")   

Private aBitmap	 := cStartPath+"/LGHONDA.BMP"
Private nPag     := 0		// Contador de Paginas
Private nLin     := 0		// Contador de Linhas
Private lImp     := .F.		// Indica se algo foi impresso
Private oPrint
Private nAltura  := 0
Private nTotal   := 0
Private nPerRet  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seta impressora para BMPs                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oPrint:= FWMSPrinter():New("ETIQUETAS HONDA AUTOMOVEIS")

oPrint:SetPortrait()      // fixa impressao em Retrato
//oPrinter:Setup()
oPrint:SetPaperSize(0, 150, 107)
//oPrinter:SetMargin(001,001,001,001)
//oPrinter:SetViewPDF(.T.)


// Imprime Etiquetas dos Itens Marcados
XImpEtqMan()

//oPrint:EndPage()
oPrint:Preview()  // Visualiza antes de imprimir
                    
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpEtqMan³ Autor ³ Teófilo A. M. Filho   ³ Data ³ 05.09.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Etiquetas (Informações digitadas manualmente)  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico HONDA LOCK                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Inati() // Inativada 
  
Local oFont8
Local oFont10
Local oFont10n
Local oFont16n
Local oFont14
Local oBrush

oFont8   := TFont():New("Arial",9,08,.T.,.F.,5,,,.T.,.F.,,,,,,oPrint)
oFont9   := TFont():New("Arial",9,09,.T.,.F.,5,,,.T.,.F.,,,,,,oPrint)
oFont9n  := TFont():New("Arial",9,09,.T.,.T.,5,,,.T.,.F.,,,,,,oPrint)
oFont10  := TFont():New("Arial",9,10,.T.,.F.,5,,,.T.,.F.,,,,,,oPrint)
oFont10n := TFont():New("Arial",9,10,.T.,.T.,5,,,.T.,.F.,,,,,,oPrint)
oFont11  := TFont():New("Arial",9,11,.T.,.F.,5,,,.T.,.F.,,,,,,oPrint)
oFont11n := TFont():New("Arial",9,11,.T.,.T.,5,,,.T.,.F.,,,,,,oPrint)
oFont12  := TFont():New("Arial",9,12,.T.,.F.,5,,,.T.,.F.,,,,,,oPrint)
oFont12n := TFont():New("Arial",9,12,.T.,.T.,5,,,.T.,.F.,,,,,,oPrint)
oFont13  := TFont():New("Arial",9,13,.T.,.F.,5,,,.T.,.F.,,,,,,oPrint)
oFont14  := TFont():New("Arial",9,14,.T.,.F.,5,,,.T.,.F.,,,,,,oPrint)
oFont14n := TFont():New("Arial",9,14,.T.,.T.,5,,,.T.,.F.,,,,,,oPrint)
oFont16n := TFont():New("Arial",9,16,.T.,.T.,5,,,.T.,.F.,,,,,,oPrint)
oFont17n := TFont():New("Arial",9,17,.T.,.T.,5,,,.T.,.F.,,,,,,oPrint)
oFont18n := TFont():New("Arial",9,18,.T.,.T.,5,,,.T.,.F.,,,,,,oPrint)
oFont24n := TFont():New("Arial",9,24,.T.,.T.,5,,,.T.,.F.,,,,,,oPrint)

oBrush := TBrush():New("",4)

oPrint:StartPage()

_LI   := 20
_CO   := 25

//Primeiro quadro - CLIENTE ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Ricardo - Alterado em: 17/02/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
//oPrint:Say(_LI+3,_CO,OemToAnsi("Cliente"+space(30)+"Data Exp"+space(25)+"Lote Produção Honda"),oFont9n) 
oPrint:Say(_LI+3,_CO+1,OemToAnsi("Cliente"+space(27)+"Data Exp"+space(24)+"Lote Produção Honda"),oFont9n)
_LI+=40 

//Ricardo - Alterado em: 17/02/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
//oPrint:Say(_LI,_CO,space(47)+OemToAnsi(Substr(cLotePro,1,15)),oFont14n) 
oPrint:Say(_LI,_CO+1,space(46)+OemToAnsi(Substr(cLotePro,1,15)),oFont14n)

_LI+=25 

oPrint:Say(_LI+10,_CO,space(2)+OemToAnsi("HONDA"),oFont17n)
oPrint:Say(_LI+20,_CO,space(22)+StrZero(Day(dDataExp),2) +"/"+ StrZero(Month(dDataExp),2) +"/"+ Right(Str(Year(dDataExp)),4),oFont14n)
_LI+=60                                         

//Ricardo - Alterado em: 05/03/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
//oPrint:Say(_LI,_CO,space(1)+OemToAnsi("Automóveis"),oFont12n) 
oPrint:Say(_LI,_CO+2,OemToAnsi("Automóveis"),oFont12n)

cTexto:=Alltrim("L"+AllTrim(cLotePro)) 

//MSBAR("CODE128",1.0,5.6,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.) 
//Ricardo - Alterado em: 17/02/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
MSBAR("CODE128",1.0,5.1,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)
_LI+=120

oPrint:Line(_LI,_CO,_LI,1350)//Linha Horizontal
oPrint:Line(30,310,295,310)  //Primeira Linha Vertical

//oPrint:Line(30,640,295,640)  //Segunda Linha Vertical

//Segundo quadro - NOTA FISCAL ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
_LI+=20

oPrint:Say(_LI,_CO,OemToAnsi("No.Doc. Fiscal (No. + Série + Seqüência)"),oFont9)
_LI+=40

//Ricardo - Alterado em: 05/03/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
//oPrint:Say(_LI,_CO,OemToAnsi(cDoc+space(01)+SubStr(cSerie,1,2)+space(01)+STRZERO(VAL(cSequen),3)),oFont18n) 
oPrint:Say(_LI,_CO+3,OemToAnsi(cDoc+space(01)+SubStr(cSerie,1,2)+space(01)+STRZERO(VAL(cSequen),3)),oFont18n)

cTexto:=Alltrim("N"+cDoc+SubStr(cSerie,1,2)+STRZERO(VAL(cSequen),3))
MSBAR("CODE128",2.5,5.5,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.) 
_LI+=120
oPrint:Line(_LI,_CO,_LI,1350)//Linha Horizontal

//Terceiro quadro - FORNECEDOR / LOTE ////////////////////////////////////////////////////////////////////////////////////////////////////////

oPrint:Say(_LI,_CO,OemToAnsi("Fornecedor"+space(20)+"Lote Fabricação"+space(10)+"Quantidade"+space(20)+"Unid."),oFont9) 

_LI+=40                                                                                               
///oPrint:Say(_LI,_CO,OemToAnsi("HONDA LOCK"+space(06)+cLoteFab+space(6)+AllTrim(Str(nQuant))+space(14)+"PC"),oFont14n) ;;;;

//Ricardo - Alterado em: 05/03/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
If !Empty(cLoteFab)
    //oPrint:Say(_LI,_CO,OemToAnsi("HONDA LOCK"+space(06)+cLoteFab+space(6)+AllTrim(Str(nQuant))+space(14)+"PC"),oFont14n)
    oPrint:Say(_LI,_CO+2,OemToAnsi("HONDA LOCK"+space(04)+cLoteFab+space(04)+AllTrim(Str(nQuant))+space(12)+"PC"),oFont14n)
Else    
    //oPrint:Say(_LI,_CO,OemToAnsi("HONDA LOCK"+space(06)+space(10)+space(6)+AllTrim(Str(nQuant))+space(14)+"PC"),oFont14n) 
    oPrint:Say(_LI,_CO+2,OemToAnsi("HONDA LOCK"+space(04)+space(08)+space(04)+AllTrim(Str(nQuant))+space(12)+"PC"),oFont14n)
EndIf        

cTexto:=Alltrim("X"+"6380987"+cLoteFab+PadL(AllTrim(Str(nQuant)),5,'0')+"PC")
MSBAR("CODE128",4.6,0.9,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)

_LI+=200
oPrint:Line(_LI,_CO,_LI,1350)//Linha Horizontal
 
//Quarto quadro - SEPPEN ////////////
_LI+=20
oPrint:Say(_LI,_CO,OemToAnsi("Código SEPPEN"),oFont10n)
_LI+=40 

//Ricardo - Alterado em: 05/03/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
//oPrint:Say(_LI,_CO,OemToAnsi(cCodSerp),oFont14n) 
oPrint:Say(_LI,_CO+2,OemToAnsi(cCodSerp),oFont14n)

cTexto:=Alltrim("S"+AllTrim(cCodSerp))
MSBAR("CODE128",6.1,3.0,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)
_LI+=120
oPrint:Line(_LI,_CO,_LI,1350)//Linha Horizontal
oPrint:Line(712,930,898,930)  //Primeira Linha Vertical 

//Quinto quadro - PECA HAB ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
_LI+=20
oPrint:Say(_LI,_CO,OemToAnsi("Código da Peça (Honda)"),oFont10n)
_LI+=40 
_cCodHAB:=""

//Ricardo - Alterado em: 05/03/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
//oPrint:Say(_LI,_CO,OemToAnsi(cCodPeca),oFont14n) 
oPrint:Say(_LI,_CO+2,OemToAnsi(cCodPeca),oFont14n)

cTexto:=Alltrim("P"+AllTrim(cCodPEca))
MSBAR( "CODE128",8.3,0.9,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)
_LI+=200
oPrint:Line(_LI,_CO,_LI,1350)//Linha Horizontal

//Sexto quadro - DESCRIÇÃO PECA //////////////////////////////////////////////////////////////////////////////////////////////////////////////
_LI+=50
oPrint:Say(_LI,_CO,OemToAnsi("Peça Descrição"),oFont10n)
_LI+=40 
oPrint:Say(_LI,_CO,OemToAnsi(cDescPec),oFont12n)
_LI+=120
oPrint:Line(_LI,_CO,_LI,1350)//Linha Horizontal

//Setimo quadro - MODELO /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////
_LI+=20
oPrint:Say(_LI,_CO,OemToAnsi("Modelo Tipo Aplicação"),oFont11n)
_LI+=40 
oPrint:Say(_LI,_CO,OemToAnsi(cModelo),oFont16n)
_LI+=120
oPrint:Line(_LI,_CO,_LI,1350)//Linha Horizontal

//Oitavo quadro///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
_LI+=20
oPrint:Say(_LI,_CO,OemToAnsi("Endereço na Linha"+space(50)+"Endereço de Estoque"),oFont10n)
_LI+=40 
oPrint:Say(_LI,_CO,OemToAnsi(cEndLin+space(30)+cEndEst),oFont12n)
_LI+=120
oPrint:Line(_LI,_CO,_LI,1350)//Linha Horizontal
oPrint:Line(1340,650,1700,650)  //Primeira Linha Vertical 

//Final da Impressão da Etiqueta//////////////////////////////////////////////////////////////////////////////////////////////////
oPrint:EndPage()

Return(.T.)



Static Function xImpEtqMan()
	
	Local cLote 	:= ""
	Local oFont10	:= TFont():New("Arial",9,10,.T.,.F.,5,,,.T.,.F.,,,,,,oPrint)
	Local oFont10n	:= TFont():New("Arial",9,10,.T.,.T.,5,,,.T.,.F.,,,,,,oPrint)
	Local oFont11  	:= TFont():New("Arial",9,11,.T.,.F.,5,,,.T.,.F.,,,,,,oPrint)
	Local oFont13n 	:= TFont():New("Arial",9,13,.T.,.T.,5,,,.T.,.F.,,,,,,oPrint)
	Local oFont14n 	:= TFont():New("Arial",9,14,.T.,.T.,5,,,.T.,.F.,,,,,,oPrint)
	Local oFont16n	:= TFont():New("Arial",9,16,.T.,.T.,5,,,.T.,.F.,,,,,,oPrint)


	cQrCode := "Q"

	oPrint:StartPage()

	_LI := 20
	//_CO   :=25
	_CO := 30 // ALTERADO LUCIANO LAMBERTI - 10-03-2020

	//Primeiro quadro - CLIENTE ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//Ricardo - Alterado em: 17/02/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
	//oPrint:Say(_LI+3,_CO,OemToAnsi("Cliente"+space(30)+"Data Exp"+space(25)+"Lote Produção Honda"),oFont10)
	oPrint:Say(_LI + 3, _CO + 001, OemToAnsi("Cliente"), 			 	oFont10n)
	oPrint:Say(_LI + 3, _CO + 165, OemToAnsi("Data Exp"), 			oFont10n)
	oPrint:Say(_LI + 3, _CO + 315, OemToAnsi("Lote Produção Honda"), 	oFont10n)

	//_LI += (40 * 0.25)

	//Ricardo - Alterado em: 17/02/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
	//oPrint:Say(_LI,_CO,space(50)+OemToAnsi(Substr(cLotePro,1,15)),oFont13n) 
	oPrint:Say(_LI + 33, _CO + 295, OemToAnsi(Substr(cLotePro, 1, 15)), oFont13n)

	//_LI += (25 * 0.25)
	
	oPrint:Say(_LI + 48, _CO + 030, OemToAnsi("HONDA"),oFont16n)
	//oPrint:Say(_LI+20,_CO,space(22)+StrZero(Day(ZD2->D2DTEMISS),2) +"/"+ StrZero(Month(ZD2->D2DTEMISS),2) +"/"+ Right(Str(Year(ZD2->D2DTEMISS)),4),oFont13n)
	oPrint:Say(_LI + 57, _CO + 140, DToC(dDataExp), oFont13n) //Luciano 10/08/2020 StrZero(Day(dDataExp),2) +"/"+ StrZero(Month(dDataExp),2) +"/"+ Right(Str(Year(dDataExp)),4)
	
	//_LI += (60 * 0.25)            

	//Ricardo - Alterado em: 05/03/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
	//oPrint:Say(_LI,_CO,space(1)+OemToAnsi("Automóveis"),oFont12n)
	oPrint:Say(_LI + 72, _CO + 20, OemToAnsi("Automóveis"), oFont14n)

	cTexto := Alltrim("L"+ AllTrim(cLotePro)) 

	cQrCode += cTexto +";"

	//Ricardo - Alterado em: 24/02/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
	//oPrint:MSBAR("CODE128",1.0,5.1,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)			//ADD LUCIANO oPrint para barcode - 09-08-21
	//MSBAR("CODE128",1.0,5.1,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)			//ADD LUCIANO oPrint para barcode - 09-08-21
	//oPrint:FWMSBAR("CODE128", 1.0, 5.1, cTexto, oPrint, .F., Nil, Nil, 0.027, 1.2, Nil, Nil, "A", .F.)			//ADD LUCIANO oPrint para barcode - 09-08-21
	//oPrint:FWMSBAR("CODE128", 1, 5, cTexto, oPrint, .F., Nil, Nil, 0.027, 1.2, Nil, Nil, "A", .F.)			//ADD LUCIANO oPrint para barcode - 09-08-21
	oPrint:Code128(_LI + 39, _CO + 260, cTexto, 1, 30, .F.,, 150) 

	//_LI += (120 * 0.25)

	oPrint:Line(_LI + 110, _CO, _LI + 110, _CO + 600)//Linha Horizontal
	oPrint:Line(_LI, _CO + 135, _LI + 110, _CO + 135)  //Primeira Linha Vertical
	//oPrint:Line(30,640,295,640)  //Segunda Linha Vertical

	//Segundo quadro - NOTA FISCAL ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//_LI+=20

	oPrint:Say(_LI + 125, _CO, OemToAnsi("No.Doc. Fiscal (No. + Série + Sequência)"), oFont10)

	//_LI+=40           

	//Ricardo - Alterado em: 05/03/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
	//oPrint:Say(_LI,_CO,OemToAnsi(cDoc+space(01)+SubStr(cSerie,1,2)+space(01)+STRZERO((_Val(cSequen)),3)),oFont14n)
	oPrint:Say(_LI + 148, _CO + 3, OemToAnsi(cDoc +" "+ SubStr(cSerie, 1, 2) +" "+ STRZERO(Val(cSequen), 3)), oFont14n)

	cTexto := Alltrim("N"+ cDoc + SubStr(cSerie, 1, 2) + STRZERO(Val(cSequen), 3))

	cQrCode += Alltrim("N"+ cDoc +" "+ SubStr(cSerie, 1, 2) + STRZERO(Val(cSequen), 3)) +";"

	//MSBAR("CODE128",3.9,8.3,cTexto,oPrint,.F.,NIL,NIL,0.043,1.6,NIL,NIL,"A",.F.)
	//oPrint:MSBAR("CODE128",2.5,5.5,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)			//ADD LUCIANO oPrint para barcode - 09-08-21
	//MSBAR("CODE128",2.5,5.5,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)			//ADD LUCIANO oPrint para barcode - 09-08-21
	//oPrint:FWMSBAR("CODE128",2.5,5.5,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)			//ADD LUCIANO oPrint para barcode - 09-08-21

	oPrint:Code128(_LI + 124, _CO + 280, cTexto, 1, 30, .F.,, 140) 
	
	//_LI+=120

	oPrint:Line(_LI + 190, _CO, _LI + 190, _CO + 600)//Linha Horizontal

	//Terceiro quadro - FORNECEDOR / LOTE ////////////////////////////////////////////////////////////////////////////////////////////////////////
	//oPrint:Say(_LI,_CO,OemToAnsi("Fornecedor"+space(20)+"Lote Fabricação"+space(10)+"Quantidade"+space(20)+"Unid."),oFont10)
	oPrint:Say(_LI + 210, _CO + 003, OemToAnsi("Fornecedor"),		 oFont11)
	oPrint:Say(_LI + 210, _CO + 175, OemToAnsi("Lote Fabricação"), oFont11)
	oPrint:Say(_LI + 210, _CO + 300, OemToAnsi("Quantidade"),		 oFont11)
	oPrint:Say(_LI + 210, _CO + 425, OemToAnsi("Unid."),			 oFont11)

	//_LI+=40 

	//Ricardo - Alterado em: 05/03/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
	If !Empty(cLoteFab)
		cLote := cLoteFab
		//oPrint:Say(_LI,_CO,OemToAnsi("HONDA LOCK"+space(06)+cLoteFab+space(6)+AllTrim(Str(_nQtdEtq))+space(14)+ZD2->D2UM),oFont12n) 
		//oPrint:Say(_LI,_CO+2,OemToAnsi("HONDA LOCK"+space(06)+cLoteFab+space(6)+AllTrim(Str(nQtdEtq))+space(14)+ZD2->D2UM),oFont12n)


	Else    
		cLote := Space(10)
		//oPrint:Say(_LI,_CO,OemToAnsi("HONDA LOCK"+space(06)+space(10)+space(6)+AllTrim(Str(_nQtdEtq))+space(14)+ZD2->D2UM),oFont12n) 
		//oPrint:Say(_LI,_CO+2,OemToAnsi("HONDA LOCK"+space(06)+space(10)+space(6)+AllTrim(Str(nQtdEtq))+space(14)+ZD2->D2UM),oFont12n)


	EndIf        

	oPrint:Say(_LI + 230, _CO + 003, OemToAnsi("HONDA LOCK"),		 		oFont13n)
	oPrint:Say(_LI + 230, _CO + 175, OemToAnsi(cLote), 					oFont13n)
	oPrint:Say(_LI + 230, _CO + 300, OemToAnsi(AllTrim(Str(nQuant))),	oFont13n)
	oPrint:Say(_LI + 230, _CO + 425, OemToAnsi(SB1->B1_UM),			 	oFont13n)

	cTexto := Alltrim("X"+"6380987"+ cLoteFab + PadL(AllTrim(Str(nQuant)), 5, '0') + SB1->B1_UM)
	
	cQrCode += Alltrim("X"+"6380987"+ cLoteFab + PadL(AllTrim(Str(nQuant)), 10, '0') + SB1->B1_UM) +";"

	//oPrint:MSBAR("CODE128",4.6,0.9,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)				//ADD LUCIANO oPrint para barcode - 09-08-21
	//MSBAR("CODE128",4.6,0.9,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)				//ADD LUCIANO oPrint para barcode - 09-08-21
	//oPrint:FWMSBAR("CODE128",4.6,0.9,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)				//ADD LUCIANO oPrint para barcode - 09-08-21
	oPrint:Code128(_LI + 245, _CO + 40, cTexto, 1, 30, .F.,, 250) 

	//_LI += 200

	oPrint:Line(_LI + 310, _CO, _LI + 310, _CO + 600)//Linha Horizontal

	//Quarto quadro - SEPPEN /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//_LI+=20

	oPrint:Say(_LI + 330, _CO, OemToAnsi("Código SEPPEN"), oFont11)

	//_LI+=40         
						
	//Ricardo - Alterado em: 05/03/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
	//oPrint:Say(_LI,_CO,OemToAnsi(ZD2->D2REVISAO),oFont12n)
	oPrint:Say(_LI + 350, _CO + 2, OemToAnsi(cCodSerp), oFont13n)
		  
	cTexto := Alltrim("S"+ AllTrim(cCodSerp))
	
	cQrCode += cTexto +";"

	//oPrint:MSBAR("CODE128",6.1,3.0,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)				//ADD LUCIANO oPrint para barcode - 09-08-21
	//MSBAR("CODE128",6.1,3.0,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)				//ADD LUCIANO oPrint para barcode - 09-08-21
	//oPrint:FWMSBAR("CODE128",6.1,3.0,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)				//ADD LUCIANO oPrint para barcode - 09-08-21
	oPrint:Code128(_LI + 315, _CO + 150, cTexto, 1, 30, .F.,, 100) 

	//_LI+=120
	
	oPrint:Line(_LI + 380, _CO, _LI + 380, _CO + 600)//Linha Horizontal
	oPrint:Line(_LI + 310, _CO + 400, _LI + 380, _CO + 400)  //Primeira Linha Vertical 

	//Quinto quadro - PECA HAB ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//_LI+=20
	
	oPrint:Say(_LI + 400, _CO, OemToAnsi("Código da Peça (Honda)"), oFont11)

	//_LI+=40 
	
	//_cCodHAB:=""    

	//Ricardo - Alterado em: 05/03/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
	//oPrint:Say(_LI,_CO,OemToAnsi(cCodPeca),oFont13n)
	oPrint:Say(_LI + 420, _CO + 2, OemToAnsi(cCodPeca), oFont13n)

	cTexto := Alltrim("P"+ AllTrim(cCodPeca))
	cQrCode += cTexto

	//oPrint:MSBAR( "CODE128",8.3,0.9,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)			//ADD LUCIANO oPrint para barcode - 09-08-21
	//oPrint:FWMSBAR( "CODE128",8.3,0.9,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)			//ADD LUCIANO oPrint para barcode - 09-08-21
	//oPrint:FWMSBAR( "CODE128",_LI - 500, _CO + 200,cTexto,oPrint,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)			//ADD LUCIANO oPrint para barcode - 09-08-21
	//oPrint:Code128(_LI + 427, _CO + 50, cTexto, 1, 30, .F.,, 150) - ajustado LL 13-09-2021
	oPrint:Code128(_LI + 427, _CO + 150, cTexto, 1, 30, .F.,, 200) // ajustado luciano para o cod de barras cliente 13-09-2021

	//_LI+=200
	
	oPrint:Line(_LI + 493, _CO, _LI + 493, _CO + 600)//Linha Horizontal

	//Sexto quadro - DESCRIÇÃO PECA //////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//_LI+=50

	oPrint:Say(_LI + 510, _CO, OemToAnsi("Peça Descrição"), oFont11)
	
	//_LI+=40 
	
	oPrint:Say(_LI + 530, _CO, OemToAnsi(cDescPec), oFont13n)
	
	//_LI+=120
	
	oPrint:Line(_LI + 570, _CO, _LI + 570, _CO + 600) //Linha Horizontal

	//Setimo quadro - MODELO /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//_LI+=20

	oPrint:Say(_LI + 590, _CO, OemToAnsi("Modelo Tipo Aplicação"),oFont11)
	
	//_LI+=40 
	
	oPrint:Say(_LI + 610, _CO , OemToAnsi(cModelo), oFont13n)  
	
	//_LI+=120
	
	//oPrint:Line(_LI,_CO,_LI,1350)//Linha Horizontal

	//Oitavo quadro///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//_LI+=20

	//nLinAtu += 100
	//nPosVert +=500

	//oPrint:Box(nLinAtu,nPosVert,nLinAtu+800,nPosVert+1080)

	

	//oPrint:Say(_LI,_CO,OemToAnsi("Endereço na Linha"+space(50)+"Endereço de Estoque"),oFont9)
	//_LI+=40 
	//oPrint:Say(_LI,_CO,OemToAnsi(ZD2->D2ENDLIN+space(30)+ZD2->D2ENDEST),oFont12n)
	//_LI+=120
	
	//oPrint:Line(_LI,_CO,_LI,1350)//Linha Horizontal
	oPrint:Line(_LI + 570, _CO + 275, _LI + 800, _CO + 275)  //Primeira Linha Vertical 

	//Imprime QRCODE
	oPrint:QRCode(_LI + 750, _CO + 350, cQrCode, 80)

	//oPrinter:QRCode(nLinAtu+010, nPosVert+500, MSBAR, 90)

	//Final da Impressão da Etiqueta//////////////////////////////////////////////////////////////////////////////////////////////////
	oPrint:EndPage()
		
Return .T.

