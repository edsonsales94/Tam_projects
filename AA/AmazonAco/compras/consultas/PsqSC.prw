#include "Protheus.CH"
#include "font.CH"
#include "Topconn.ch"
#include "RwMake.ch"

/*---------------------------------------------------------------------------------------------------------------------------------------------------
OBJETIVO 1: Montagem da Tela de Pesquisa de Produto por DESCRIÇÃO, FABRICANTE, REFERENCIA e GERAL na Solicitação de Compras
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/

*------------------------------------------------------------------------------------------*
User Function PsqSC()
*------------------------------------------------------------------------------------------*
Local cVar     := Nil
Local oGet     := Nil

Private cAlias := Alias()
Private nOpc     := 0
Private lMark    := .F.
Private oOk      := LoadBitmap( GetResources(), "LBOK" )
Private oNo      := LoadBitmap( GetResources(), "LBNO" )
Private _cPesquisa := Space(40)
Private oDlg     := Nil

Private oSay1
Private oSay2
Private oSay3
Private oSay4
Private oSay5
Private oSay6
Private oSay7
Private oSay8
Private oSay9
Private oSay10
Private oSay11
Private oSay12
Private oSay13
Private oSay14
Private oSay15
Private oSay16
Private oSay17
Private oSay18
Private oSay19
Private oSay20
Private oSay21
Private oSay22
Private oSay23
Private oSay24
Private oSay25
Private oSay26
Private oSay27
Private oSay28
Private oSay29
Private oSay30
Private oSay31
Private oSay32
Private oSay34
Private oSay35
Private oSay36
Private oSay37
Private oSay38
Private oSay39
Private oSay40
Private oSay41
Private oSay42
Private oSay43
Private oSay44
Private oSay45
Private oSay46
Private oSay47
Private oSay48
Private oSay49
Private oSay50

Private oLbx
Private aVetor      := {}
Private cModApl1, cModApl2, cModApl3
Private aItems      := {}
Private oTipo       := NIL
Private _cTipo      := Space(30)
Private oPesquisa   := NIL
Private oMedCons    := NIL
Private nQtdSc      := 0
Private nMedCons    := 0
Private nNumCons    := 0
Private nQtMesAtual := 0
Private nQtMes1     := 0
Private nQtMes2     := 0
Private nVlMesAtual := 0
Private nVlMesAnt1  := 0
Private nVlMesAnt2  := 0
Private nVlMesAnt3  := 0
Private nVlMesAnt4  := 0
Private nVlMesAnt5  := 0
Private nVlMesTotal := 0
Private nVlMedCons  := 0
Private nMesAtual 	:= StrZero(Month(dDataBase),2)
Private nMesAnt1   	:= StrZero(Month(dDataBase),2)
Private nMesAnt2   	:= StrZero(Month(dDataBase),2)
Private nMesAnt3   	:= StrZero(Month(dDataBase),2)
Private nMesAnt4   	:= StrZero(Month(dDataBase),2)
Private nMesAnt5   	:= StrZero(Month(dDataBase),2)
Private cMesAtual   := Space(10)
Private cMesAnt1    := Space(10)
Private cMesAnt2    := Space(10)
Private cMesAnt3    := Space(10)
Private cMesAnt4    := Space(10)
Private cMesAnt5    := Space(10)
Private aNFE        := {}
Private nTotEnt     := 0
Private nMedEnt     := 0
Private cEnt10      // Documento de Entrada 1
Private cEnt11      // Documento de Entrada 1
Private cEnt12      // Documento de Entrada 1
Private cEnt13      // Documento de Entrada 1
Private cEnt14      // Documento de Entrada 1
Private cEnt15      // Documento de Entrada 1
Private cEnt16      // Documento de Entrada 1

Private cEnt20 		// Documento de Entrada 2
Private cEnt21 		// Documento de Entrada 2
Private cEnt22 		// Documento de Entrada 2
Private cEnt23 		// Documento de Entrada 2
Private cEnt24 		// Documento de Entrada 2
Private cEnt25 		// Documento de Entrada 2
Private cEnt26 		// Documento de Entrada 2

Private cEnt30 		// Documento de Entrada 3
Private cEnt31 		// Documento de Entrada 3
Private cEnt32 		// Documento de Entrada 3
Private cEnt33 		// Documento de Entrada 3
Private cEnt34 		// Documento de Entrada 3
Private cEnt35 		// Documento de Entrada 3
Private cEnt36 		// Documento de Entrada 3

Private cEnt37 		// Documento de Entrada 4
Private cEnt38 		// Documento de Entrada 4
Private cEnt39 		// Documento de Entrada 4
Private cEnt40 		// Documento de Entrada 4
Private cEnt41 		// Documento de Entrada 4
Private cEnt42 		// Documento de Entrada 4
Private cEnt43 		// Documento de Entrada 4

Private cEnt44 		// Documento de Entrada 5
Private cEnt45 		// Documento de Entrada 5
Private cEnt46 		// Documento de Entrada 5
Private cEnt47 		// Documento de Entrada 5
Private cEnt48 		// Documento de Entrada 5
Private cEnt49 		// Documento de Entrada 5
Private cEnt50 		// Documento de Entrada 5
Private cEstGeral := Space(1)
Private nTotEst   := 0
Private nPrv1     := 0
Private nPrv2     := 0

//                                                     1                         2                     3                     4                     5
//                1      2   3   4    5  6  7  8   9   0  1 2 3  4 5  6  7 8  9  0 1  2  3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8  9  0 1  2  3 4 5 6 7 8 9 0 1
aAdd( aVetor , { lMark, "" , "", "" , 0, 0, 0, "", "", 0, 0,0,0, 0,"","",0,"","",0,"","",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"","",0,"","",0,0,0,0,0,0,0,0,0} )

Define Font oFnt3 Name "Ms Sans Serif" Bold
DEFINE FONT oFont NAME "MS Sans Serif" SIZE 0, -9 BOLD

DEFINE MSDIALOG oDlg TITLE "Consulta de Produtos"  From 5,15 To 55,175 OF oMainWnd

AADD(aItems,"Fabricante"); AADD(aItems,"Descricao"); AADD(aItems,"Codigo"); AADD(aItems,"Grupo"); AADD(aItems,"Referencia")//; AADD(aItems,"")

@ 015,15 Say "Tipo : "  Size 35,8 Of oDlg Pixel Font oFnt3
@ 015,50 MSCOMBOBOX oTipo VAR _cTipo ITEMS aItems SIZE 100,50 OF  oDlg PIXEL

@030, 15 Say "Pesquisar : "  Size 35,8 Of oDlg Pixel Font oFnt3

@030, 50 MSGET oPesquisa Var _cPesquisa Picture "@!" Size 150,10 Pixel of oDlg VALID ;
Pesquisa(IIf(Alltrim(_cTipo)=="Codigo","Codigo",IIf(Alltrim(_cTipo)=="Descricao","Descricao",IIf(Alltrim(_cTipo)=="Fabricante","Fabricante",;
IIf(Alltrim(_cTipo)=="Referencia","Referencia",IIf(Alltrim(_cTipo)=="Grupo","Grupo",IIf(Alltrim(_cTipo)=="Geral","Geral","")))))))

@030, 220 Say "Media de Consumo (em MESES) : "  Size 95,8 Of oDlg Pixel Font oFnt3
@030, 320 MSGET oMedCons Var nNumCons Picture "@E 99" Size 70,10 Pixel of oDlg VALID;
Pesquisa(IIf(Alltrim(_cTipo)=="Codigo","Codigo",IIf(Alltrim(_cTipo)=="Descricao","Descricao",IIf(Alltrim(_cTipo)=="Fabricante","Fabricante",;
IIf(Alltrim(_cTipo)=="Referencia","Referencia",IIf(Alltrim(_cTipo)=="Grupo","Grupo",IIf(Alltrim(_cTipo)=="Geral","Geral","")))))))

//											 1      2            3         4        5       6              7            8              9          10         11          12          13            14         15          16       17         18        19        20       21          22        23       24        25        26       27      28        29       30          31          32         33         34          35       36            37          38          39        40       41          42        43       44         45       46       47       48          49          50        51
@ 45,05 LISTBOX oLbx VAR cVar FIELDS HEADER " ","Referencia", "Código","Descrição","UM","Est.Disp.","Qtd. Solic", "Custo NFE","Fabrica","Med.Cons.","Mes Atual","Mes Ant 1","Mes Ant 2","Mes Ant 3","Doc/Serie","Dt_Digit","Quant","Doc/Serie","Dt_Digit","Quant","Doc/Serie","Dt_Digit","Quant","CstNFE1","CstNFE2","CstNFE3","Total1","Total2","Total3","Unit Aq1", "Unit Aq2","Unit Aq1", "Tot.Aq1", "Tot.Aq2", "Tot.Aq3","Mes Ant 4", "Mes Ant 5","Doc/Serie","Dt_Digit","Quant","Doc/Serie","Dt_Digit","Quant","CstNFE4","CstNFE5","Total4","Total5","Unit Aq4", "Unit Aq4", "Tot.Aq4", "Tot.Aq5";
SIZE 625,160 OF oDlg PIXEL ON CHANGE Apertou() ON dblClick( Inverter(oLbx:nAt,@aVetor,@oLbx),oLbx:Refresh(.F.))

oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
aVetor[oLbx:nAt,2],;
aVetor[oLbx:nAt,3],;
aVetor[oLbx:nAt,4],;
aVetor[oLbx:nAt,5],;
Transform(aVetor[oLbx:nAt,6],PesqPict("SB2","B2_QATU",12,2)),;
Transform(aVetor[oLbx:nAt,7],PesqPict("SB2","B2_QATU",12,2)),;
Transform(aVetor[oLbx:nAt,8],"@E 999,999.99"),;
aVetor[oLbx:nAt,9],;
Transform(aVetor[oLbx:nAt,10],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,11],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,12],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,13],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,14],"@E 999,999.99"),;
aVetor[oLbx:nAt,15],;
aVetor[oLbx:nAt,16],;
Transform(aVetor[oLbx:nAt,17],"@E 999,999.99"),;
aVetor[oLbx:nAt,18],;
aVetor[oLbx:nAt,19],;
Transform(aVetor[oLbx:nAt,20],"@E 999,999.99"),;
aVetor[oLbx:nAt,21],;
aVetor[oLbx:nAt,22],;
Transform(aVetor[oLbx:nAt,23],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,24],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,25],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,26],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,27],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,28],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,29],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,30],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,31],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,32],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,33],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,34],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,35],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,36],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,37],"@E 999,999.99"),;
aVetor[oLbx:nAt,38],;
aVetor[oLbx:nAt,39],;
aVetor[oLbx:nAt,40],;
aVetor[oLbx:nAt,41],;
aVetor[oLbx:nAt,42],;
aVetor[oLbx:nAt,43],;
Transform(aVetor[oLbx:nAt,44],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,45],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,46],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,47],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,48],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,49],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,50],"@E 999,999.99"),;
Transform(aVetor[oLbx:nAt,51],"@E 999,999.99")}}

oPesquisa:SetFocus()

@220, 015 Say "    C O N S U M O   M E D I O   M E N S A L"  Of oDlg Pixel Font oFnt3
@220, 015 SAY oSay49 PROMPT "EST. DISP. : "+cEstGeral+" = "+Transform(nTotEst,"@E 999,999,999.99") SIZE 400,10 OF oDlg PIXEL RIGHT COLOR CLR_BLUE FONT oFont

@ 240,015 SAY oSAY1 PROMPT cMesAtual+"-"+Transform(nVlMesAtual,"@E 999,999,999.99") SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont

@ 240,080 SAY oSAY5  PROMPT "Media de Consumo nos ÚLTIMOS "+StrZero(nNumCons,2)+" meses -"+Transform(nVlMedCons,"@E 999,999,999.99") SIZE 200,10 OF oDlg PIXEL RIGHT COLOR CLR_BLUE FONT oFont
@ 240,200 SAY oSAY17 PROMPT "Documentos de Entrada " SIZE 200,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 250,250 SAY oSAY24 PROMPT " Documento       Dt.Digit.            Quant           Custo NFE         Total Custo             Aq.Form.PR.        Total Aq." SIZE 350,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont

@ 250,015 SAY oSAY2 PROMPT cMesAnt1+"-"+Transform(nVlMesAnt1,"@E 999,999,999.99") SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont

@ 260,250 SAY oSAY7  PROMPT cEnt10 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 260,280 SAY oSAY8  PROMPT cEnt11 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 260,320 SAY oSAY9  PROMPT cEnt12 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 260,370 SAY oSAY18 PROMPT cEnt13 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 260,420 SAY oSAY21 PROMPT cEnt14 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 260,470 SAY oSAY26 PROMPT cEnt15 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 260,520 SAY oSAY27 PROMPT cEnt16 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont

@ 260,015 SAY oSAY3  PROMPT cMesAnt2+"-"+Transform(nVlMesAnt2,"@E 999,999,999.99") SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont

@ 270,250 SAY oSAY10 PROMPT cEnt20 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 270,280 SAY oSAY11 PROMPT cEnt21 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 270,320 SAY oSAY12 PROMPT cEnt22 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 270,370 SAY oSAY19 PROMPT cEnt23 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 270,420 SAY oSAY22 PROMPT cEnt24 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 270,470 SAY oSAY28 PROMPT cEnt25 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 270,520 SAY oSAY29 PROMPT cEnt26 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont

@ 270,015 SAY oSAY6  PROMPT cMesAnt3+"-"+Transform(nVlMesAnt3,"@E 999,999,999.99") SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont

@ 280,250 SAY oSAY13 PROMPT cEnt30 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 280,280 SAY oSAY14 PROMPT cEnt31 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 280,320 SAY oSAY15 PROMPT cEnt32 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 280,370 SAY oSAY20 PROMPT cEnt33 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 280,420 SAY oSAY23 PROMPT cEnt34 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 280,470 SAY oSAY30 PROMPT cEnt35 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 280,520 SAY oSAY31 PROMPT cEnt36 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont

@ 280,015 SAY oSAY32 PROMPT cMesAnt4+"-"+Transform(nVlMesAnt4,"@E 999,999,999.99") SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont

@ 290,250 SAY oSAY34 PROMPT cEnt37 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 290,280 SAY oSAY35 PROMPT cEnt38 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 290,320 SAY oSAY36 PROMPT cEnt39 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 290,370 SAY oSAY37 PROMPT cEnt40 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 290,420 SAY oSAY38 PROMPT cEnt41 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 290,470 SAY oSAY39 PROMPT cEnt42 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 290,520 SAY oSAY40 PROMPT cEnt43 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont

@ 290,015 SAY oSAY33 PROMPT cMesAnt5+"-"+Transform(nVlMesAnt5,"@E 999,999,999.99") SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont

@ 300,250 SAY oSAY41 PROMPT cEnt44 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 300,280 SAY oSAY42 PROMPT cEnt45 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 300,320 SAY oSAY43 PROMPT cEnt46 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 300,370 SAY oSAY44 PROMPT cEnt47 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 300,420 SAY oSAY45 PROMPT cEnt48 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 300,470 SAY oSAY46 PROMPT cEnt49 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont
@ 300,520 SAY oSAY47 PROMPT cEnt50 SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFont

@ 310,015 SAY oSAY4  PROMPT "TOT.QT-"+Transform(nVlMesTotal,"@E 999,999,999.99") SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_BLUE FONT oFont
@ 310,320 SAY oSAY16 PROMPT "TOT.QT-"+Transform(nTotEnt,"@E 999,999,999.99") SIZE 80,10 OF oDlg PIXEL RIGHT COLOR CLR_BLUE FONT oFont

@ 330,015 SAY oSAY48 PROMPT "PREÇO DE VENDA 1 - "+Transform(nPrv1,"@E 999,999,999.99") SIZE 120,10 OF oDlg PIXEL RIGHT COLOR CLR_BLUE FONT oFont
@ 340,015 SAY oSAY50 PROMPT "PREÇO DE VENDA 2 - "+Transform(nPrv2,"@E 999,999,999.99") SIZE 120,10 OF oDlg PIXEL RIGHT COLOR CLR_BLUE FONT oFont

ACTIVATE MSDIALOG oDlg ON INIT;
EnchoiceBar(oDlg,{|| IIf(ValidMarK(aVetor),(nOpc:=1,oDlg:End()), ) },{||oDlg:End()}) CENTERED

//Return(M->C1_PRODUTO)
Return(.T.)

*------------------------------------------------------------------------------------------*
Static Function Pesquisa(cTipo)
*------------------------------------------------------------------------------------------*
Local cQry

If !Empty(_cPesquisa)
	
	cQry := "SELECT  * "
	
	If Alltrim(cTipo) $ "Grupo#Geral"
		cQry += "FROM "+RetSQLName("SB1")+" B1, "+RetSQLName("SBM")+" BM "
	Else
		cQry += "FROM "+RetSQLName("SB1")+" B1 "
	Endif
	
	Do Case
		Case cTipo     == "Referencia"
			cQry += "WHERE B1.B1_REFEREN LIKE '"+Alltrim(_cPesquisa)+"%' AND "
		Case cTipo     == "Codigo"
			cQry += "WHERE B1.B1_COD =  	  '"+Left(_cPesquisa,15)+"' AND "
		Case cTipo     == "Descricao"
			cQry += "WHERE B1.B1_DESC LIKE    '"+Alltrim(_cPesquisa)+"%' AND "
		Case cTipo     == "Fabricante"
			cQry += "WHERE B1.B1_NOMFAB LIKE  '"+Alltrim(_cPesquisa)+"%' AND "
		Case cTipo     == "Grupo"
			cQry += "WHERE BM.BM_DESC  LIKE  '"+Alltrim(_cPesquisa)+"%' AND "
			cQry += "BM.BM_GRUPO = B1.B1_GRUPO AND "
		Case cTipo     == "Geral"
			cQry += "WHERE (B1.B1_DESC    LIKE '%"+Alltrim(_cPesquisa)+"%' OR "
			cQry += "B1.B1_NOMFAB LIKE '%" +Alltrim(_cPesquisa)+"%' OR "
			cQry += "(BM.BM_DESC LIKE '%"+Alltrim(_cPesquisa)+"%' AND BM.BM_GRUPO = B1.B1_GRUPO ) OR "
			cQry += "B1.B1_REFEREN LIKE '%"+Alltrim(_cPesquisa)+"%') AND "
			
	EndCase
	
	cQry += "B1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
	cQry += "B1.B1_MSBLQL <> '1' AND "
	cQry += "B1.D_E_L_E_T_ <> '*' "
	
	Do Case
		Case cTipo     == "Referencia"
			cQry += "ORDER BY B1.B1_REFEREN, B1.B1_DESC "
		Case cTipo     == "Descricao"
			cQry += "ORDER BY B1.B1_DESC, B1.B1_NOMFAB "
		Case cTipo     == "Codigo"
			cQry += "ORDER BY B1.B1_COD, B1.B1_DESC "
		Case cTipo     == "Grupo"
			cQry += "ORDER BY BM.BM_DESC, B1.B1_DESC "
		Case cTipo     == "Fabricante"
			cQry += "ORDER BY B1.B1_NOMFAB, B1.B1_DESC "
		Case cTipo     == "Geral"
			cQry += "ORDER BY B1_DESC,B1.B1_NOMFAB, B1.B1_REFEREN "
			
	EndCase
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "QRY", .T., .F. )
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	
	DbSelectArea("SB2")
	DbSetOrder(1)
	
	DbSelectArea("SB3")  //Consumo Medio
	DbSetOrder(1)
	
	
	dbSelectArea("QRY")
	dbGoTop()
	
	aDel(aVetor,Len(aVetor))
	aSize(aVetor,0)
	nPreco := 0
	
	While !QRY->(Eof())
		
		lTemSB1 := SB1->(DbSeek(xFilial("SB1")+QRY->B1_COD))
		
		If lTemSB1
			nPreco := SB1->B1_UPRC
		EndIf
		
		SB2->(DbSeek(xFilial("SB2")+QRY->B1_COD+QRY->B1_LOCPAD))
		SB3->(DbSeek(xFilial("SB3")+QRY->B1_COD))
		
		//		Verifica os Meses para demonstrar o Consumo da Tela
		nMesAtual := StrZero(Month(dDataBase),2)  								// Mes Atual
		nConsAtual:= u_Consumo(QRY->B1_COD,Val(nMesAtual),Year(dDataBase))  	// Consumo do Mes Atual - FUNÇÕES GENERICAS.PRW
		
		nMesAnt1  := StrZero(Val(nMesAtual)-1,2) 						// Mês Anterior
		If Val(nMesAnt1) < 1    										// Se o mês Atual for Janeiro, o anterior deverá ser Dezembro do ano anterior
			nMesAnt1 := "12"
			nAno     := Year(dDataBase)-1
		Else
			If Month(dDatabase) < Val(nMesAnt1)  						// Se o mes de Anterior 1 for maior que a data base significa dizer que eh o mes do ano anterior - Ex.: Mes Atual = 2/2009 e MesCons = 11/2008
				nAno     := Year(dDataBase)-1
			Else
				nAno     := Year(dDataBase)   							// O mes de consumo pertence ao ano atual
			EndIf
		Endif
		nConsAnt1 := u_Consumo(QRY->B1_COD,Val(nMesAnt1),nAno)  		// Consumo do Mes Anterior - FUNÇÕES GENERICAS.PRW
		
		nMesAnt2  := StrZero(Val(nMesAnt1)-1,2)
		If Val(nMesAnt2) < 1											// Se o mês Anterior 1 for Janeiro, o anterior 2 deverá ser Dezembro do ano anterior
			nMesAnt2 := "12"
			nAno     := Year(dDataBase)-1
		Else
			If Month(dDatabase) < Val(nMesAnt2)  		   				// Se o mes de Anterior 2 for maior que a data base significa dizer que eh o mes do ano anterior - Ex.: Mes Atual = 2/2009 e MesCons = 11/2008
				nAno     := Year(dDataBase)-1
			Else
				nAno     := Year(dDataBase)   							// O mes de consumo pertence ao ano atual
			EndIf
		Endif
		nConsAnt2 := u_Consumo(QRY->B1_COD,Val(nMesAnt2),nAno)  		// Consumo do Mes Anterior 2 - FUNÇÕES GENERICAS.PRW
		
		nMesAnt3  := StrZero(Val(nMesAnt2)-1,2)
		If Val(nMesAnt3) < 1   											// Se o mês Anterior 2 for Janeiro, o anterior 3 deverá ser Dezembro do ano anterior
			nMesAnt3 := "12"
			nAno     := Year(dDataBase)-1
		Else
			If Month(dDatabase) < Val(nMesAnt3)  		   				// Se o mes de Anterior 3 for maior que a data base significa dizer que eh o mes do ano anterior - Ex.: Mes Atual = 2/2009 e MesCons = 11/2008
				nAno     := Year(dDataBase)-1
			Else
				nAno     := Year(dDataBase)   							// O mes de consumo pertence ao ano atual
			EndIf
		Endif
		nConsAnt3 := u_Consumo(QRY->B1_COD,Val(nMesAnt3),nAno)  		// Consumo do Mes Anterior 3 - FUNÇÕES GENERICAS.PRW
		
		nMesAnt4  := StrZero(Val(nMesAnt3)-1,2)
		If Val(nMesAnt4) < 1   											// Se o mês Anterior 3 for Janeiro, o anterior 4 deverá ser Dezembro do ano anterior
			nMesAnt4 := "12"
			nAno     := Year(dDataBase)-1
		Else
			If Month(dDatabase) < Val(nMesAnt4)  		   				// Se o mes de Anterior 4 for maior que a data base significa dizer que eh o mes do ano anterior - Ex.: Mes Atual = 2/2009 e MesCons = 11/2008
				nAno     := Year(dDataBase)-1
			Else
				nAno     := Year(dDataBase)   							// O mes de consumo pertence ao ano atual
			EndIf
		Endif
		nConsAnt4 := u_Consumo(QRY->B1_COD,Val(nMesAnt4),nAno)  		// Consumo do Mes Anterior 4 - FUNÇÕES GENERICAS.PRW
		
		nMesAnt5  := StrZero(Val(nMesAnt4)-1,2)
		If Val(nMesAnt5) < 1   											// Se o mês Anterior 4 for Janeiro, o anterior 5 deverá ser Dezembro do ano anterior
			nMesAnt5 := "12"
			nAno     := Year(dDataBase)-1
		Else
			If Month(dDatabase) < Val(nMesAnt5)  		   				// Se o mes de Anterior 5 for maior que a data base significa dizer que eh o mes do ano anterior - Ex.: Mes Atual = 2/2009 e MesCons = 11/2008
				nAno     := Year(dDataBase)-1
			Else
				nAno     := Year(dDataBase)   							// O mes de consumo pertence ao ano atual
			EndIf
		Endif
		nConsAnt5 := u_Consumo(QRY->B1_COD,Val(nMesAnt5),nAno)  		// Consumo do Mes Anterior 5 - FUNÇÕES GENERICAS.PRW
		
		// Fim
		
		//Calcula a Média de Consumo referente aos número de meses definido pelo usuário - DESCONSIDERA O MÊS ATUAL
		nMesCons 	:= Val(nMesAtual)
		nTotCons 	:= 0
		nQtdSC      := 0
		
		For I:=1 to nNumCons
			
			nMesCons := nMesCons - 1
			
			If nMesCons  < 1                				 // Se o mes de consumo for menor 1(JAN), significa que eh Dez do ano anterior
				nMesCons := 12
				nAno     := Year(dDataBase)-1
			Else
				If Month(dDatabase) < nMesCons  			// Se o mes de consumo for maior que a data base significa dizer que eh o mes do ano anterior - Ex.: Mes Atual = 2/2009 e MesCons = 11/2008
					nAno     := Year(dDataBase)-1
				Else
					nAno     := Year(dDataBase)   			// O mes de consumo pertence ao ano atual
				EndIf
			EndIf
			
			nTotCons +=  u_Consumo(QRY->B1_COD,nMesCons,nAno)  //- FUNÇÕES GENERICAS.PRW
		Next
		
		nMedCons := nTotCons / nNumCons
		// FIM
		
		aNFE := u_NFE(QRY->B1_COD)  // Busca as últimas 5 NFEs do Produto - FUNÇÕES GENERICAS.PRW
		
		//                1            2              3             4          5                     6                                7                  8                          9                 10          11        12          13          14
		aAdd( aVetor , {lMark, QRY->B1_REFEREN, QRY->B1_COD, QRY->B1_DESC, QRY->B1_UM, SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QEMP), nQtdSC, Iif(Len(aNFE)>1,aNFE[1][4],0), Left(QRY->B1_NOMFAB,10), nMedCons, nConsAtual, nConsAnt1 , nConsAnt2, nConsAnt3,;
		Iif(Len(aNFE) >=1,aNFE[1][1],""),Iif(Len(aNFE) >=1,aNFE[1][2],""),Iif(Len(aNFE) >=1,aNFE[1][3],0),;  	// 15 A 17  Document1 - DT Digitação - QUANT
		Iif(Len(aNFE) >=2,aNFE[2][1],""),Iif(Len(aNFE) >=2,aNFE[2][2],""),Iif(Len(aNFE) >=2,aNFE[2][3],0),;  	// 18 A 20  Document2 - DT Digitação - QUANT
		Iif(Len(aNFE) >=3,aNFE[3][1],""),Iif(Len(aNFE) >=3,aNFE[3][2],""),Iif(Len(aNFE) >=3,aNFE[3][3],0),;		// 21 A 23  Document3 - DT Digitação - QUANT
		Iif(Len(aNFE) >=1,aNFE[1][4],0 ),Iif(Len(aNFE) >=2,aNFE[2][4],0 ),Iif(Len(aNFE) >=3,aNFE[3][4],0),;     // 24 A 26  CstUntNF1 - CstUntNF2    - CstUntNF3
		Iif(Len(aNFE) >=1,aNFE[1][5],0 ),Iif(Len(aNFE) >=2,aNFE[2][5],0 ),Iif(Len(aNFE) >=3,aNFE[3][5],0),;     // 27 A 29  TotCstNF1 - TotCstNF2    - TotCstNF3
		Iif(Len(aNFE) >=1,aNFE[1][6],0 ),Iif(Len(aNFE) >=2,aNFE[2][6],0 ),Iif(Len(aNFE) >=3,aNFE[3][6],0),;     // 30 A 32  CstUntAq1 - CstUntAq2    - CstUntAq3
		Iif(Len(aNFE) >=1,aNFE[1][7],0 ),Iif(Len(aNFE) >=2,aNFE[2][7],0 ),Iif(Len(aNFE) >=3,aNFE[3][7],0),;  	// 33 A 35  TotCstAq1 - TotCstAq2    - TotCstAq3
		nConsAnt4 , nConsAnt5,;																					// 36 e 37  Mês Ant 4 - Mês Ant 5
		Iif(Len(aNFE) >=4,aNFE[4][1],""),Iif(Len(aNFE) >=4,aNFE[4][2],""),Iif(Len(aNFE) >=4,aNFE[4][3],0),;  	// 38 A 40  Document4 - DT Digitação - QUANT
		Iif(Len(aNFE) >=5,aNFE[5][1],""),Iif(Len(aNFE) >=5,aNFE[5][2],""),Iif(Len(aNFE) >=5,aNFE[5][3],0),;	  	// 41 A 43  Document5 - DT Digitação - QUANT
		Iif(Len(aNFE) >=4,aNFE[4][4],0 ),Iif(Len(aNFE) >=5,aNFE[5][4],0 ),;     								// 44 A 45  CstUntNF4 - CstUntNF5
		Iif(Len(aNFE) >=4,aNFE[4][5],0 ),Iif(Len(aNFE) >=5,aNFE[5][5],0 ),;      								// 46 A 47  TotCstNF4 - TotCstNF5
		Iif(Len(aNFE) >=4,aNFE[4][6],0 ),Iif(Len(aNFE) >=5,aNFE[5][6],0 ),;									    // 48 A 49  CstUntAq1 - CstUntAq2    - CstUntAq3
		Iif(Len(aNFE) >=4,aNFE[4][7],0 ),Iif(Len(aNFE) >=5,aNFE[5][7],0 )} )								  	// 50 A 51  TotCstAq1 - TotCstAq2    - TotCstAq3
		
		QRY->(DbSkip())
		
	Enddo
	
	QRY->(DbCloseArea())
	
	If Len(aVetor) = 0
		//                                                     1                         2                     3                     4                     5
		//                1      2   3   4    5  6  7  8   9   0  1 2 3  4 5  6  7 8  9  0 1  2  3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8  9  0 1  2  3 4 5 6 7 8 9 0 1
		aAdd( aVetor , { lMark, "" , "", "" , 0, 0, 0, "", "", 0, 0,0,0, 0,"","",0,"","",0,"","",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"","",0,"","",0,0,0,0,0,0,0,0,0} )
		
		MsgAlert("Não existe dados para seleção!!!",OemToAnsi("ATENCAO")  )
	EndIf
	oLbx:Refresh()
	oLbx:SetFocus()
EndIf

Return

*------------------------------------------------------------------------------------------*
Static Function Inverter(nPos,aVetor,oLbx)
*------------------------------------------------------------------------------------------*
aVetor[nPos][1] := !aVetor[nPos][1]

If aVetor[nPos][1]
	nQtdSC := QuantSC()
Else
	nQtdSC := 0
EndIf

aVetor[nPos][7] := nQtdSC
oLbx:Refresh()

Return


*------------------------------------------------------------------------------------------*
Static Function ValidMarK(aVetor)
*------------------------------------------------------------------------------------------*
Local lRet := .T.

If Ascan(aVetor,{|x| x[1] }) == 0
	Help("",1,"","FORMACAO","Nao foi marcado nenhuma nota !",1,0)
	lRet := .F.
Else
	GravaMark(aVetor)
Endif

Return(lRet)


*------------------------------------------------------------------------------------------*
Static Function GravaMark(aVetor)
*------------------------------------------------------------------------------------------*
Local i
Local nQtItem := Len(aVetor)

aStru  := {{"WK_MARCA"   , "L", 01,0},{"WK_UM"   , "C", 2,0},{"WK_FABRICA"  , "C", 20,0},;
{"WK_COD"     , "C", 15,0},{"WK_DESC"    , "C", 50,0},{"WK_REFEREN" , "C", 15,0},;
{"WK_UPRC" , "N", 18,2},{"WK_QTSC" , "N", 14,2}}

cFile:= CriaTrab(aStru,.T.)
Use &cFile Alias wMark New Exclusive

DbSelectArea("wMark")

For i := 1 to nQtItem
	If aVetor[i][1]
		RecLock("wMark",.T.)
		wMark->WK_MARCA   := aVetor[i][1]
		wMark->WK_REFEREN := aVetor[i][2]
		wMark->WK_COD     := aVetor[i][3]
		wMark->WK_UM   	  := aVetor[i][4]
		wMark->WK_DESC    := aVetor[i][5]
		wMark->WK_QTSC    := aVetor[i][7]
		MsUnLock()
	EndIf
	
Next

Grava_Item()

Return


*----------------------------------------------------------------------------------------------*
Static Function Grava_Item()
*----------------------------------------------------------------------------------------------*
Local nUsado := 0

Local aColsAux := {}

Private nTam   := 1
Private n_ColProduto,n_ColDescri,n_ColQuant,n_ColVrunit,n_ColVlritem
Private n_ColLocal,n_ColUm,n_ColDesc,n_ColValdesc,n_ColTes
Private n_ColCF,n_ColDescpro,n_ColTabela,n_ColPctab
Private n_ColBaseIcm,n_ColValIPI,n_ColValIcm,n_ColValIss

aStru:= {{"WK_COD"     , "C", 15,0},;    //-> Arquivo temporario de consulta
{"WK_DESC"    , "C", 50,0},;
{"WK_QATU"    , "N", 14,2},;
{"WK_FABRICA" , "C", 20,0},;
{"WK_UM"  , "C", 2,0},;
{"WK_REFEREN" , "C", 15,0},;
{"WK_UPRC"    , "N", 18,2},;
{"WK_QTSC"    , "N", 18,2}}

cFile := CriaTrab(aStru,.T.)
Use &cFile Alias wItem New Exclusive

dbSelectArea("SF4")
dbSetOrder(1)

dbSelectArea("SB0")
dbSetOrder(1)

dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("wMark")

If Eof()
	wMark->(DbCloseArea())
	wItem->(DbCloseArea())
	Return
Endif

nUsado:= Len(aCols[1])-1

n_ColItem    := AScan( aHeader , {|x| Trim(x[2]) == "C1_ITEM" })
n_ColProduto := AScan( aHeader , {|x| Trim(x[2]) == "C1_PRODUTO" })
n_ColDescri  := AScan( aHeader , {|x| Trim(x[2]) == "C1_DESCRI" })
n_ColQuant   := AScan( aHeader , {|x| Trim(x[2]) == "C1_QUANT" })
n_ColLocal   := AScan( aHeader , {|x| Trim(x[2]) == "C1_LOCAL" })
n_ColUm      := AScan( aHeader , {|x| Trim(x[2]) == "C1_UM" })
n_DtNec      := AScan( aHeader , {|x| Trim(x[2]) == "C1_DATPRF" })
n_Tela       := AScan( aHeader , {|x| Trim(x[2]) == "C1_TELA" })
n_Referen    := AScan( aHeader , {|x| Trim(x[2]) == "C1_REFEREN" })

// Se o último item for vazio ou deletado, elimina esse ítem
If Len(aCols) > 1 .And. (Empty(aCols[Len(aCols),n_ColProduto]) .Or. aCols[Len(aCols),nUsado+1])
	aColsAux := aClone(aCols[Len(aCols)])
Endif

dbGoTop()

While !Eof()
	
	If SB1->(dbSeek(xFilial("SB1")+wMark->WK_COD))
		
		/* Preenche o aCols utilizando os registros em brancos, incluido mais itens */
		If N = 1 .And. Empty(aCols[N,n_ColProduto])
			nTam 	:= N
		Else
			nTam 	:= Len(Acols)+1
			N 		:= nTam
		EndIf
		
		
		If N > 1
			
			Aadd(aCols, Array(nUsado+1) )
			
			For c:=1 To nUsado
				If aHeader[c,8] == "C"
					aCols[nTam,c]:= Space(aHeader[c,4])
				Elseif aHeader[c,8] == "N"
					aCols[nTam,c]:= 0
				Elseif aHeader[c,8] == "D"
					aCols[nTam,c]:= Ctod("  /  /  ")
				Elseif aHeader[c,8] == "M"
					aCols[nTam,c]:= ""
				Else
					aCols[nTam,c]:= .F.
				Endif
			Next
			
			aCols[nTam,nUsado+1] := .F.
			
		EndIf
		
		aCols[nTam,n_ColItem] 		:= StrZero(nTam,4)
		aCols[nTam,n_ColProduto] 	:= SB1->B1_COD
		aCols[nTam,n_Referen]   	:= SB1->B1_REFEREN
		Acols[nTam][n_ColLocal]		:= SB1->B1_LOCPAD
		Acols[nTam][n_ColUM]		:= SB1->B1_UM
		Acols[nTam][n_DtNec]		:= dDataBase
		Acols[nTam][n_ColDescri]	:= SB1->B1_DESC
		Acols[nTam][n_ColQuant]		:= wMark->WK_QTSC
		Acols[nTam][n_Tela]			:= .T.
		
		M->C1_ITEM					:= aCols[nTam][n_ColItem]
		M->C1_PRODUTO 				:= aCols[nTam][n_ColProduto]
		
		dbSelectArea("wMark")
		
	Endif
	
	dbSkip()
Enddo

wItem->(DbCloseArea())
wMark->(DbCloseArea())

DbSelectArea(cAlias)

Return

*----------------------------------------------------------------------------------------------*
Static Function Apertou()
*----------------------------------------------------------------------------------------------*

nVlMesAtual := aVetor[oLbx:nAt,11]  // Consumo do Mês Atual
nVlMesAnt1  := aVetor[oLbx:nAt,12]  // Consumo do Mês Anterior 1
nVlMesAnt2  := aVetor[oLbx:nAt,13]  // Consumo do Mês Anterior 2
nVlMesAnt3  := aVetor[oLbx:nAt,14]  // Consumo do Mês Anterior 3
nVlMesAnt4  := aVetor[oLbx:nAt,36]  // Consumo do Mês Anterior 4
nVlMesAnt5  := aVetor[oLbx:nAt,37]  // Consumo do Mês Anterior 5

nVlMesTotal := nVlMesAtual+nVlMesAnt1+nVlMesAnt2+nVlMesAnt3+nVlMesAnt4+nVlMesAnt5

nTotEnt     := aVetor[oLbx:nAt,17]+aVetor[oLbx:nAt,20]+aVetor[oLbx:nAt,23]+aVetor[oLbx:nAt,40]+aVetor[oLbx:nAt,43]   // Total de Entradas no mes

nPrv1  := Posicione("SB0",1,xFilial("SB0")+aVetor[oLbx:nAt][3],"B0_PRV1")
nPrv2  := Posicione("SB0",1,xFilial("SB0")+aVetor[oLbx:nAt][3],"B0_PRV2")
							
VEstDisp(aVetor[oLbx:nAt,3])									// Função que verifica o Estoque Disponivel em cada Filial

cEnt10 := aVetor[oLbx:nAt,15]								  	// Documento de Entrada 1 - Documento/Serie
cEnt11 := aVetor[oLbx:nAt,16]                                 	// Documento de Entrada 1 - DT DIGITAÇÃO
cEnt12 := Transform(aVetor[oLbx:nAt,17],"@E 999,999,999.99")  	// Documento de Entrada 1 - Quantidade
cEnt13 := Transform(aVetor[oLbx:nAt,24],"@E 999,999.99")  		// Documento de Entrada 1 - Custo Unitário da NFE
cEnt14 := Transform(aVetor[oLbx:nAt,27],"@E 999,999,999.99")  	// Documento de Entrada 1 - Valor Total
cEnt15 := Transform(aVetor[oLbx:nAt,30],"@E 999,999.99")  		// Documento de Entrada 1 - Custo Aquisição da Formação de Preço
cEnt16 := Transform(aVetor[oLbx:nAt,33],"@E 999,999,999.99")  	// Documento de Entrada 1 - Custo Total

cEnt20 := aVetor[oLbx:nAt,18]                                 	// Documento de Entrada 2 - Documento/Serie
cEnt21 := aVetor[oLbx:nAt,19]          		                  	// Documento de Entrada 2 - DT DIGITAÇÃO
cEnt22 := Transform(aVetor[oLbx:nAt,20],"@E 999,999,999.99")  	// Documento de Entrada 2 - Quantidade
cEnt23 := Transform(aVetor[oLbx:nAt,25],"@E 999,999.99")  		// Documento de Entrada 2 - Valor Unitário da NFE
cEnt24 := Transform(aVetor[oLbx:nAt,28],"@E 999,999,999.99")  	// Documento de Entrada 2 - Valor Total
cEnt25 := Transform(aVetor[oLbx:nAt,31],"@E 999,999.99")  		// Documento de Entrada 2 - Custo de Aquisição da Formação de Preço
cEnt26 := Transform(aVetor[oLbx:nAt,34],"@E 999,999,999.99")  	// Documento de Entrada 2 - Custo Total


cEnt30 := aVetor[oLbx:nAt,21]                                 	// Documento de Entrada 3 - Documento/Serie
cEnt31 := aVetor[oLbx:nAt,22]				                  	// Documento de Entrada 3 - DT DIGITAÇÃO
cEnt32 := Transform(aVetor[oLbx:nAt,23],"@E 999,999,999.99")  	// Documento de Entrada 3 - Quantidade
cEnt33 := Transform(aVetor[oLbx:nAt,26],"@E 999,999.99")  		// Documento de Entrada 3 - Valor Unitário da NFE
cEnt34 := Transform(aVetor[oLbx:nAt,29],"@E 999,999,999.99")  	// Documento de Entrada 3 - Valor Total
cEnt35 := Transform(aVetor[oLbx:nAt,32],"@E 999,999.99")  		// Documento de Entrada 3 - Custo de Aquisição da Formação de Preço
cEnt36 := Transform(aVetor[oLbx:nAt,35],"@E 999,999,999.99")  	// Documento de Entrada 3 - Custo Total

cEnt37 := aVetor[oLbx:nAt,38]                                 	// Documento de Entrada 4 - Documento/Serie
cEnt38 := aVetor[oLbx:nAt,39]				                  	// Documento de Entrada 4 - DT DIGITAÇÃO
cEnt39 := Transform(aVetor[oLbx:nAt,40],"@E 999,999,999.99")  	// Documento de Entrada 4 - Quantidade
cEnt40 := Transform(aVetor[oLbx:nAt,44],"@E 999,999.99")  		// Documento de Entrada 4 - Valor Unitário da NFE
cEnt41 := Transform(aVetor[oLbx:nAt,46],"@E 999,999,999.99")  	// Documento de Entrada 4 - Valor Total
cEnt42 := Transform(aVetor[oLbx:nAt,48],"@E 999,999.99")  		// Documento de Entrada 4 - Custo de Aquisição da Formação de Preço
cEnt43 := Transform(aVetor[oLbx:nAt,50],"@E 999,999,999.99")  	// Documento de Entrada 4 - Custo Total

cEnt44 := aVetor[oLbx:nAt,41]                                 	// Documento de Entrada 5 - Documento/Serie
cEnt45 := aVetor[oLbx:nAt,42]				                  	// Documento de Entrada 5 - DT DIGITAÇÃO
cEnt46 := Transform(aVetor[oLbx:nAt,43],"@E 999,999,999.99")  	// Documento de Entrada 5 - Quantidade
cEnt47 := Transform(aVetor[oLbx:nAt,45],"@E 999,999.99")  		// Documento de Entrada 5 - Valor Unitário da NFE
cEnt48 := Transform(aVetor[oLbx:nAt,47],"@E 999,999,999.99")  	// Documento de Entrada 5 - Valor Total
cEnt49 := Transform(aVetor[oLbx:nAt,49],"@E 999,999.99")  		// Documento de Entrada 5 - Custo de Aquisição da Formação de Preço
cEnt50 := Transform(aVetor[oLbx:nAt,51],"@E 999,999,999.99")  	// Documento de Entrada 5 - Custo Total

nVlMedCons    := aVetor[oLbx:nAt,10] 							// Media de Consumo

cMesAtual := u_Mes(Val(nMesAtual))  								// Chama a Função MES para verificar o Nome do MÊS - Ex. JANEIRO - FUNÇÕES GENERICAS.PRW
cMesAnt1  := u_Mes(Val(nMesAnt1))									// Chama a Função MES para verificar o Nome do MÊS - Ex. JANEIRO - FUNÇÕES GENERICAS.PRW
cMesAnt2  := u_Mes(Val(nMesAnt2))									// Chama a Função MES para verificar o Nome do MÊS - Ex. JANEIRO - FUNÇÕES GENERICAS.PRW
cMesAnt3  := u_Mes(Val(nMesAnt3))									// Chama a Função MES para verificar o Nome do MÊS - Ex. JANEIRO - FUNÇÕES GENERICAS.PRW
cMesAnt4  := u_Mes(Val(nMesAnt4))                                   // Chama a Função MES para verificar o Nome do MÊS - Ex. JANEIRO - FUNÇÕES GENERICAS.PRW
cMesAnt5  := u_Mes(Val(nMesAnt5))                                   // Chama a Função MES para verificar o Nome do MÊS - Ex. JANEIRO - FUNÇÕES GENERICAS.PRW

oSay1:Refresh()
oSay2:Refresh()
oSay3:Refresh()
oSay4:Refresh()
oSay5:Refresh()
oSay6:Refresh()
oSay7:Refresh()
oSay8:Refresh()
oSay9:Refresh()
oSay10:Refresh()
oSay11:Refresh()
oSay12:Refresh()
oSay13:Refresh()
oSay14:Refresh()
oSay15:Refresh()
oSay16:Refresh()
oSay17:Refresh()
oSay18:Refresh()
oSay19:Refresh()
oSay20:Refresh()
oSay21:Refresh()
oSay22:Refresh()
oSay23:Refresh()
oSay24:Refresh()
oSay26:Refresh()
oSay27:Refresh()
oSay28:Refresh()
oSay29:Refresh()
oSay30:Refresh()
oSay31:Refresh()
oSay32:Refresh()
oSay33:Refresh()
oSay34:Refresh()
oSay35:Refresh()
oSay36:Refresh()
oSay37:Refresh()
oSay37:Refresh()
oSay38:Refresh()
oSay39:Refresh()
oSay40:Refresh()
oSay41:Refresh()
oSay42:Refresh()
oSay43:Refresh()
oSay44:Refresh()
oSay45:Refresh()
oSay46:Refresh()
oSay47:Refresh()
oSay48:Refresh()
oSay49:Refresh()
oSay50:Refresh()
return(.T.)

Static Function QuantSC()

nQuant := 0

Define Msdialog oDlgMain Title "Quantidade SC" From 96,5 to 200,350 Pixel


@005, 15 say "Quantidade : "Size 100,10 Of oDlgMain Pixel Font oFnt3
@005, 50 Get nQuant    Picture "@E 999,999,999.99" Size 50,8 Pixel of oDlgMain

@ 25 ,50 BMPBUTTON TYPE 1 ACTION oDlgMain:End()

Activate Msdialog oDlgMain Centered

Return(nQuant)


Static Function VEstDisp(cProduto)
// Verifica o Saldo Disponivel nas Filiais cadastradas no SLJ (Identificação da Loja)

DbSelectArea("SLJ")
DbSetOrder(3)
DbGotop()

DbSelectArea("SB2")
DbSetOrder(1)

cEstGeral:= Space(1)
nTotEst  := 0 
nEstDisp := 0

Do While !SLJ->(Eof())
	
	If SB2->(DbSeek(SLJ->LJ_RPCFIL+cProduto))
		
		Do While !SB2->(Eof()) .And. SB2->B2_FILIAL+SB2->B2_COD == SLJ->LJ_RPCFIL+cProduto
			nEstDisp += SB2->B2_QATU-(SB2->B2_QEMP+SB2->B2_RESERVA)
			SB2->(DbSkip())
		EndDo
		cEstGeral += "LOJA "+SLJ->LJ_RPCFIL+"--> "+Transform(nEstDisp,"@E 999,999,999.99")+" + "
		nTotEst   += nEstDisp
		nEstDisp  := 0    
	Endif
	
	SLJ->(DbSkip())
	
EndDo

Return()

