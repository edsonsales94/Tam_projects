#include "Protheus.ch"
#include "RwMake.ch"

/*/{protheus.doc}HLINVP01
mBrouse utilizado na customização da da rotina de Inventário.  
@author WERMESON GADELHA DO CANTO
@since 17/12/2009
/*/

/*___________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Função    ¦ PLESTP01   ¦ WERMESON GADELHA DO CANTO    ¦ Data ¦ 17/12/2009             ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Descriçäo ¦ mBrouse utilizado na customização da da rotina de Inventário.             ¦¦¦
¦¦+-----------+---------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function HLINVP01(cAlias,nReg,nOpcA)

Local   _cArea  := GetArea()
Local   _nVal   := 0

Local   nOpc    := 4
Local   nwCont  := 0 //iIf(INCLUI,20,Len(acols))
Local   lEdit   := .F.
Local   cwFdel  := "AllwaysFalse"
Local   cwFLin  := "AllwaysTrue"

Local   aRotina := {{"Pesquisar" , "AxPesqui", 0, 1},;
						  {"Visualizar", "AxVisual", 0, 2},;
						  {"Incluir"   , "AxInclui", 0, 3},;
						  {"Alterar"   , "AxAltera", 0, 4},;
						  {"Excluir"   , "AxDeleta", 0, 5}}

Private _nCol1  := 0
Private _nCol2  := 0
Private _nCol3  := 0
Private _nCol4  := 0
Private _nCol5  := 0
Private _nCol6  := 0
Private _nCol7  := 0
Private _nTot   := 0

Private _cNum   := SZ4->Z4_NUM
Private _cEnd   := SZ4->Z4_AREA
Private _cLoc   := SZ4->Z4_OBS
Private _dDat   := SZ4->Z4_DATA
Private _cSta   := SZ4->Z4_STATUS
Private _cdCont := "" //getMv("MV_XINVCON") //Qual Contagem esta 

Private oDlg    := Nil
Private _oTot   := Nil
Private oGet    := Nil

Private _aAlt   := {}
Private aHeader := {}
Private aCols   := {}
Private lBranco

lBranco := ( (SubStr(SZ4->Z4_NUM,1, 1) == "B" ) .And. Empty(SZ4->Z4_OBS) .And. Empty(SZ4->Z4_AREA) ) .Or. GetSZ5(_cNum) = 0
nwCont  := iIf( SZ4->Z4_STATUS  $ "1 " ,20,Len(acols))

_dDat := iIF( Empty(_dDat),dDataBase,_dDat)
_cEnd := IiF(Empty(SZ4->Z4_AREA),Space(30),SZ4->Z4_AREA)
_cLoc := "" //IiF(Empty(SZ4->Z4_LOCAL),Space(02),SZ4->Z4_LOCAL)
cwFdel:= "u_EstP01b()"
cwFLin:= "u_EstP01a()"

If !(CriaHeader(@lEdit, _cNum, _cSta ))
	MsgBox("Já foram informadas todas as contagens para esta cartela!")
	Return Nil
EndIf

//  nwCont  := iIf( lBranco .And. SZ4->Z4_FINAL == "1" ,20,Len(acols))

CarregaAcols(_cNum)

lEdit := Empty(SZ4->Z4_OBS) .And. Empty(SZ4->Z4_AREA)

If Len(aCols) < 1
	MsgBox("Já foram informadas todas as contagens para esta cartela!")
	Return Nil
EndIf

iF _cdCont != _cSta
//   Aviso('Atenção','Somente é Permitido a digitação da Contagem: ' + _cdCont + ' E não da Contagem : ' + _cSta + ', Operação Não poderá Ser Confirmada',{'OK'} )
EndIf


DEFINE MSDIALOG oDlg TITLE "Cartelas de Inventário" From 1,1 To 37.5 ,145  OF oMainWnd
DEFINE FONT oBold NAME "Times New Roman" SIZE 0, -13 BOLD
DEFINE FONT oRED  NAME "Times New Roman" SIZE 0, -18 BOLD

@ 003, 090 SAY " Filial : " + SZ4->Z4_FILIAL  FONT oRed PIXEL OF oDlg Color (CLR_RED)

@ 015, 020 SAY "Num. Cartela :"  FONT oBold PIXEL OF oDlg Color (CLR_BLUE)
@ 015, 070 MSGET _oNum VAR _cNum SIZE 55,8  PIXEL OF oDlg WHEN .F. //lEdit

@ 015, 190 SAY "Dt Geração   :"  FONT oBold PIXEL OF oDlg Color (CLR_BLUE)
@ 015, 240 MSGET _oDat VAR _dDat SIZE 55,8  PIXEL OF oDlg WHEN .F.

@ 015, 400 SAY "Setor     :"  FONT oBold PIXEL OF oDlg Color (CLR_BLUE)
@ 015, 450 MSGET _oEnd VAR _cEnd SIZE 55,8  PIXEL OF oDlg WHEN lEdit Valid fValEnde(_cEnd, _cLoc, "1") //F3 "SBE_W"

/*@ 030, 190 SAY "Armazém      :"  FONT oBold PIXEL OF oDlg Color (CLR_BLUE)
@ 030, 240 MSGET _oLoc VAR _cLoc SIZE 55,8  PIXEL OF oDlg WHEN lEdit Valid fValEnde(_cEnd, _cLoc, "2")
  */
//  @ 109, 10 MSGET oVlrDesconto VAR nVlrDesconto SIZE 50,8 OF oDlg1 PIXEL PICTURE "@E 999,999,999.99"

// @ 240, 190 SAY "TOTAL CARTELA:"  FONT oBold SIZE 200,10 OF oDlg PIXEL Color (CLR_BLUE)
// @ 240, 240 SAY _oTot   var _nTot Picture "@E 999,999,999,999.99" Color (CLR_HRED) Size 100,13 of oDlg Pixel Font oBold


//  .--------------------------------.
//  |     Mostra meta por vendedor   |
//  '--------------------------------'                                     
dbselectArea("SZ5")
//oGet := MsNewGetDados():New(050,020,240,700,3, cwFLin, "u_EstP01a()","u_EstP01a()",.T.,_aAlt,,,nwCont,"u_EstP01a()",,,oDlg,aHeader,aCols)      
oGet :=   MsNewGetDados():New(030,020,240,550,3, cwFLin, "u_EstP01a()",, _aAlt, ,Len(acols),,,,oDlg,aHeader,aCols)      

/*MsNewGetDados(): New ( [ nTop], [ nLeft], [ nBottom], [ nRight ], [ nStyle], [ cLinhaOk], [ cTudoOk], [ cIniCpos], [ aAlter], [ nFreeze], [ nMax], [ cFieldOk], [ cSuperDel], [ cDelOk], [ oWnd], [ aPartHeader], [ aParCols], [ uChange], [ cTela] ) --> Objeto*/



//oGet := MSGetDados():New(050,020,240,700,nOpc, cwFLin, "u_EstP01a()","u_EstP01a()",.T.,  ,,,nwCont,"u_EstP01a()",,,cwFdel)      

//	oGet := MSGetDados():New(nLinha /*75*/, 2,220,425,4,"u_Pco2LOkADMI1()","u_Pco2Ok()",iIf(AllTrim(cConta) == "110903" .Or. AllTrim(cConta) == "320101","","+PB4_ITEM"),.T.,aAlt,,,nwMax,"u_PcoVal2()",,,"u_Pco2DEL()")
//  oGet:oBrowse:bChange := {|| U_EstP01a()}
oGet:oBrowse:Refresh()
@ 245, 020 SAY "Total Cartela:"  FONT oBold PIXEL OF oDlg Color (CLR_BLUE)
@ 245, 070 MSGET _oVal VAR _nVal SIZE 55,8  PIXEL OF oDlg WHEN .T. Valid fValTotal(_nVal, _nTot, 1) PICTURE "@E 999,999,999,999,999.9999"
  
ACTIVATE MSDIALOG oDlg ON INIT;
EnchoiceBar(oDlg,{||  _fGravar(_cNum, _cEnd, _cLoc, _nVal, _nTot, nOpcA), nOpc:= 3,  oDlg:End()  },{||oDlg:End()}) CENTERED

RestArea(_cArea)
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CriaHeader ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 17/11/2008 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina onde será montado o cabecalho do acols (aHeader)       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CriaHeader(lEdit, cwNum, cwSta)

Local cAlias 	:= "SZ5"
Local cCAcols := "Z5_COD|Z5_DESC|Z5_LOCAL|Z5_UM|Z5_OBS"
Local lRet    := .T.

/*SZ5->(dbSetorder(1))
If SZ5->(dbSeek(xFilial("SZ5")+cwNum) )
	*/
	If !lBranco //.Or. ALTERA
		If cwSta == "1" .Or. Empty(cwSta)  //Empty(SZ5->Z5_DIRV1)
			aAdd(_aAlt, "Z5_QTDE1" )
			cCAcols += "Z5_QTDE1|"
		ElseIf cwSta == "2" //Empty(SZ5->Z5_DIRV2)
			aAdd(_aAlt, "Z5_QTDE2" )
			cCAcols += "Z5_QTDE2|"
		ElseIf cwSta == "3" //Empty(SZ5->Z5_DIRV3)
			aAdd(_aAlt, "Z5_QTDE3" )
			cCAcols += "Z5_QTDE3|"
		EndIf
		lEdit := .F.
	EndIf
//EndIf

If lBranco .Or. cwSta = "1"
	aAdd(_aAlt, "Z5_COD" )
	aAdd(_aAlt, "Z5_QTDE1" )       
	
	cCAcols += "Z5_QTDE1|"
	lEdit := .T.
EndIf

nUsado  := 0
aHeader := {}

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)        

aadd(aHeader, {"Item"           , "Z5_ITEM"  , "@!"              , 03       , 0         ,""       , ""      , "C"    , ""        ,,})


While ( !Eof() .And. SX3->X3_ARQUIVO == cAlias )
	If (  cNivel >= SX3->X3_NIVEL .And. AllTrim(SX3->X3_CAMPO) $ cCAcols)
		aAdd(aHeader,{ Trim(X3Titulo()), ;  //1  Titulo do Campo
		SX3->X3_CAMPO   , ;  //2  Nome do Campo
		SX3->X3_PICTURE , ;  //3  Picture Campo
		SX3->X3_TAMANHO , ;  //4  Tamanho do Campo
		SX3->X3_DECIMAL , ;  //5  Casas decimais
		SX3->X3_VALID   , ;  //6  Validacao do campo
		SX3->X3_USADO   , ;  //7  Usado ou naum
		SX3->X3_TIPO    , ;  //8  Tipo do campo
		SX3->X3_ARQUIVO , ;  //9  Arquivo
		SX3->X3_CONTEXT } )  //10 Visualizar ou alterar
	Endif
	dbSkip()
End
return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦CarregaAcols¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 17/11/2008 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina onde serão carregados os dados para o acols            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

Static Function CarregaAcols(cwNum)
Local   lRet := .T.
Private aAux := {}

_nCol1 := Ascan( aHeader , {|x| Trim(x[2]) == "Z5_COD"})
_nCol2 := Ascan( aHeader , {|x| Trim(x[2]) == "Z5_DESC"})
_nCol3 := Ascan( aHeader , {|x| Trim(x[2]) == "Z5_QTDE1"})
_nCol4 := Ascan( aHeader , {|x| Trim(x[2]) == "Z5_QTDE2"})
_nCol5 := Ascan( aHeader , {|x| Trim(x[2]) == "Z5_QTDE3"})
_nCol6 := Ascan( aHeader , {|x| Trim(x[2]) == "Z5_FINAL"})
_nCol7 := Ascan( aHeader , {|x| Trim(x[2]) == "Z5_QATU"})      
_nCol8 := Ascan( aHeader , {|x| Trim(x[2]) == "Z5_GRUPO"})    
_nCol9 := Ascan( aHeader , {|x| Trim(x[2]) == "Z5_DESCGRP"})    
_nColA := Ascan( aHeader , {|x| Trim(x[2]) == "Z5_UM"})    
_nColB := Ascan( aHeader , {|x| Trim(x[2]) == "Z5_TIPO"})    
_nColC := Ascan( aHeader , {|x| Trim(x[2]) == "Z5_OBS"})    
_nColD := Ascan( aHeader , {|x| Trim(x[2]) == "Z5_LOCAL"})    

cArea   := GetArea()

If lBranco
	fCriaVar()
	Return nil
EndIf

fwGetSZ5 (cwNum)  
nItem := 1

	While !TMP1->(EOF()) 
		If Empty(TMP1->Z5_FINAL)
			fCriaVar()
			aCols[Len(aCols)][1]        := strzero(nItem, 3)
			aCols[Len(aCols)][_nCol1] := TMP1->Z5_COD
			aCols[Len(aCols)][_nCol2] := TMP1->Z5_DESC     
			aCols[Len(aCols)][_nColC] := TMP1->Z5_OBS
			aCols[Len(aCols)][_nColD] := TMP1->Z5_LOCAL     
			aCols[Len(aCols)][_nColA] := TMP1->Z5_UM
			      
			
			If _nCol3 > 0
				aCols[Len(aCols)][_nCol3] := TMP1->Z5_QTDE1
				_nTot += TMP1->Z5_QTDE1
			EndIf
			If _nCol4 > 0
				aCols[Len(aCols)][_nCol4] := TMP1->Z5_QTDE2
				_nTot += TMP1->Z5_QTDE2
			EndIf
			If _nCol5 > 0
				aCols[Len(aCols)][_nCol5] := TMP1->Z5_QTDE3
				_nTot += TMP1->Z5_QTDE3
			EndIf
		EndIf
		TMP1->(dbSkip())         
		
		nItem++
	End                       
	
	
	TMP1->(dbCloseArea())

Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fCriaVar   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 24/11/2008 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Valida o campo do acols                                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fCriaVar()
aAdd(aCols,Array(Len(aHeader)+1))

For i:= 2 to Len(aHeader)
	aCols[Len(aCols)][i] := CriaVar(Trim(aHeader[i][2]),.T.)
Next

aCols[Len(aCols)][len(aHeader)+1] := .F.
Return nil

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fGravar    ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 18/12/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Grava os dados das contagens de inventario                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function _fGravar(cwNum, cwEnd, cwLoc, nwVal, nwTot, nOpcA)
Local lRet  := .T.
Local cStat := ""

/*iF _cdCont != _cSta
   Aviso('Atenção','Somente é Permitido a digitação da Contagem: ' + _cdCont + ' E não da Contagem : ' + _cSta + ', Operação Não será Concluida',{'OK'} )
   Return .F.
EndIf                     */

If /*!INCLUI .And. !ALTERA .And. */ nOpcA <> 4
//	oDlg:End()
  //	Return .T.
EndIf

If Len(oGet:aCols) = 1 .And. Len(Alltrim(oGet:aCols[01][01])) = 0
	Aviso("ERRO","Nenhum Produto Informado"+Chr(13)+Chr(10)+"Favor Informar Pelo Menos um Produto",{"Ok"},3)
	Return .F.
EndIf

If !fValTotal(nwVal, nwTot, 2)
//	Return .F.
EndIf
/*If !fValEnde(cwEnd, cwLoc, "3S")
	Return .F.
EndIf */
//  dbSelectArea("SZ5")
//  dbSetOrder(1)
// If dbSeek(xFilial("SZ5") + SZ4->Z4_NUM)
If _nCol3 > 0
	lRet := fValAcols(_nCol3)
ELseIf _nCol4 > 0
	lRet := fValAcols(_nCol4)
ElseIf _nCol5 > 0
	lRet := fValAcols(_nCol5)
EndIf
// EndIf

If !lRet
	Return .F.
EndIf

/*If lBranco
	dbSelectARea("SZ4")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ4")+cwNum)
		RecLock("SZ4",.F.)
		SZ4->Z4_OBS   := cwLoc
		SZ4->Z4_AREA := cwEnd
		SZ4->(MsunLock())
	EndIf
EndIf
  */
dbSelectArea("SZ5")
dbSetOrder(1)
For i:=1 to Len(oGet:aCols)
	If oGet:aCols[i][Len(aHeader)+1]
		Loop
	EndIf
	
	If !( dbSeek(xFilial("SZ5") + SZ4->Z4_NUM +oGet:aCols[ i ][_nCol1]) )
		RecLock("SZ5",.T.)
		SZ5->Z5_NUM     := SZ4->Z4_NUM
		SZ5->Z5_FILIAL  := SZ4->Z4_FILIAL
		SZ5->Z5_COD     := oGet:aCols[i][_nCol1]
		SZ5->Z5_QTDE1   := -1
		SZ5->Z5_QTDE2   := -1
		SZ5->Z5_QTDE3   := -1
		SZ5->Z5_QATU    := 0
		SZ5->Z5_DESC    := Posicione("SB1",1,xFilial("SB1") + oGet:aCols[i][_nCol1], "B1_DESCHL")
		SZ5->(MsunLock())
	EndIf

	nTercAnt := SZ5->Z5_QTDE3

	RecLock("SZ5",.F.)
	If _nCol3 > 0
		SZ5->Z5_QTDE1 := oGet:aCols[i][_nCol3]
	ElseIf _nCol4 > 0
		SZ5->Z5_QTDE2 := oGet:aCols[i][_nCol4]
	ElseIf _nCol5 > 0
		SZ5->Z5_QTDE3 := oGet:aCols[i][_nCol5]
	EndIf
	
	If Empty(SZ5->Z5_DIRV1)
	  //	If oGet:aCols[i][_nCol3] <> SZ5->Z5_QATU
			SZ5->Z5_DIRV1 := "D"
			If "2" >  cStat
				cStat := "2"
			EndIf
		/*Else
			SZ5->Z5_DIRV1 := "1"
			SZ5->Z5_FINAL := "1"
			If "0" >  cStat
				cStat := "0"
			EndIf
		EndIf        */
	ElseIf Empty(SZ5->Z5_DIRV2)
		If oGet:aCols[i][_nCol4] <> SZ5->Z5_QTDE1 
//			aCols[i][_nCol4] <> SZ5->Z5_QATU 
//			GetCusto(aCols[i][01])*Abs((aCols[i][_nCol4] - SZ5->Z5_QATU)) > GetMv("MV_CSTDINV")  //SZ5->Z5_QATU
			
			SZ5->Z5_DIRV2 := "D"
			If "3" >  cStat
				cStat := "3"
			EndIf
		Else
			SZ5->Z5_DIRV2 := "2"
			SZ5->Z5_FINAL := "2"
			If "0" >  cStat
				cStat := "0"
			EndIf
		EndIf
	ElseIf Empty(SZ5->Z5_DIRV3) .or. ALLTRIM(SZ5->Z5_DIRV3) == 'D'
		If oGet:aCols[i][_nCol5] <> SZ5->Z5_QTDE1 .And. oGet:aCols[i][_nCol5] <> SZ5->Z5_QTDE2 
			if SZ5->Z5_QTDE3 > 0 .And. oGet:aCols[i][_nCol5] == nTercAnt .And. Empty(SZ5->Z5_DIRV3)
					If "0" >  cStat
						cStat := "0"
					EndIf		
					SZ5->Z5_FINAL := "3"
					SZ5->Z5_DIRV3 := "4"
				Else 					
					SZ5->Z5_DIRV3 := "D"
					cStat         := "3"
			EndIf 
		Else
			SZ5->Z5_DIRV3 := "3"
			SZ5->Z5_FINAL := "3"

			If "0" >  cStat
				cStat := "0"
			EndIf		
			
		EndIf


		If "0" >  cStat
			cStat := "0"
		EndIf
	EndIf
	SZ5->(MsUnlock())
Next

dbSelectARea("SZ4")
RecLock("SZ4",.F.)
  SZ4->Z4_STATUS  := cStat
SZ4->(MsunLock())

oDlg:End()   
	
Return .T.

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ EstP01a    ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 18/12/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Valida a digitacao dos Valores do acolls                      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function EstP01a()
//Local cVar := ReadVar()
//Local nAtu := aScan(aHeader,{|x| Trim(x[2]) == SubStr(cVar,4,len(cVar))})
Local lRet := .T.
//Local cArea := GetArea()

/*If nAtu > 0
	If ! ("Z5_COD" $ cVar )
		If &(cVar) < 0               
			&(cVar) := &(cVar) * (-1)
			//lRet := .F.
			//MsgStop("O valor da contagem deve ser maior ou igual a 0 (zero)!")
		EndIf
	Else
		If lRet := fValProd(nAtu, &(cVar), _cEnd, _cLoc,_dDat)
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(xFilial("SB1") + &(cVar)))
				SZ5->(dbSetOrder(1))
				If  ( &(cVar) <> aCols[n][_nCol1] ) .And. SZ5->(dbSeek( xFilial("SZ5") + _cNum + aCols[n][_nCol1] ))
					MsgStop("Este produto não pode ser modificado!")
					lRet := .F.
				Else
					aCols[n][_nCol2] := SB1->B1_DESC
				EndIf
			Else
				MsgStop("Produto não cadastrado!")
				lRet := .F.
			EndIf
		EndIf
	EndIf
EndIf
//ALERT("1")
If lRet
	If lBranco .And. nAtu <= 0
		If lRet := fValProd(_nCol1, aCols[n][_nCol1], _cEnd, _cLoc, _dDat)
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(xFilial("SB1") + aCols[n][_nCol1] ))
				SZ5->(dbSetOrder(1))
				If  ( &(cVar) <> aCols[n][_nCol2] ) .And. SZ5->(dbSeek( xFilial("SZ5") + _cNum + aCols[n][_nCol2] ))
					MsgStop("Este produto não pode ser modificado!")
					lRet := .F.
				Else
					aCols[n][_nCol2] := SB1->B1_DESC
				EndIf
			Else
				MsgStop("Produto não cadastrado!")
				lRet := .F.
			EndIf
		EndIf
	EndIf
	
	iF cVar$"M->Z5_QTDE1|M->Z5_QTDE2|M->Z5_QTDE3"
		_nTot := 0                    
		If &(cVar) < 0 
			&(cVar) := &(cVar) * (-1)
		EndIf 
		For i:=1 to Len(aCols)
			If n <> i
				If _nCol3 > 0
					_nTot += aCols[i][_nCol3]
				ELseIf _nCol4 > 0
					_nTot += aCols[i][_nCol4]
				ElseIf _nCol5 > 0
					_nTot += aCols[i][_nCol5]
				EndIf
			Else
				_nTot +=  &(cVar)
			EndIf
		Next
	EndIf
EndIf

RestArea(cArea)

oGet:Refresh()
// _oTot:Refresh()
oDlg:Refresh()
  */
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fValAcols  ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 18/12/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Valida a digitacao dos Valores do acolls                      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fValAcols(nwCol)
Local lRet  := .T.
Local lProd := .T.

For i:=1 to Len(oGet:aCols)
	If oGet:aCols[i][nwCol] < 0
		lRet := .F.
	EndIf
	If Len(Alltrim(oGet:aCols[i][1])) = 0
		lProd := .F.
	EndIf
Next

If !lRet
	MsgBox("Existem Itens com quantidade ainda nao informada! Favor verificar!")
EndIf

If !(lRet := lProd)
	Aviso("ERRO","Existem Itens Sem Produto Informado"+Chr(13)+Chr(10)+"Favor Informar o Produto ou Deletetar a Linha",{"Ok"},3)
Endif
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fValTotal  ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 22/12/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Valida a digitacao dos Valores do total                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fValTotal(nwVal, nwTot, nTipo )
Local lRet := .T.

/*
If (nTipo == 1 .And. nwTot <> nwVal .And.  nwVal > 0)  .Or.;
	(nTipo == 2 .And. nwTot <> nwVal)
	MsgStop("O valor total não pode ser Diferente dos Itens!")
	lRet := .F.
EndIf
*/

Return lRet
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fValEnde   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 22/12/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Valida a digitacao do endere'co e do armazem                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fValEnde(cwEnd, cwLoc, cTipo)
Local lRet := .T.

SBE->(dbSetOrder(9))
If !SBE->(dbSeek(xFilial("SBE") + cwEnd )) .And. cTipo <> "2" //.And.  !Empty(cwEnd)
//	MsgStop("Endereço não cadastrado!") - Luciano
	lRet := .T.			//Luciano
//	lRet := .F.
EndIf
SBE->(dbSetOrder(1))

If lRet .And. !SBE->(dbSeek(xFilial("SBE") + cwLoc )) .And. cTipo <> "1" //.And. !Empty(cwLoc)
	MsgStop("Local não cadastrado!")
	lRet := .T.		//Luciano
//	lRet := .F.

EndIf

If lRet .And. !SBE->(dbSeek(xFilial("SBE") + cwLoc + cwEnd)) .And. !Empty(cwLoc) .And. !Empty(cwEnd)
	MsgStop("Não há vinculos entre o Endereço e o Armazém!")
	lRet := .T.		//Luciano
//	lRet := .F.
EndIf

Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fValProd   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 22/12/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Valida a digitacao do Produto                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fValProd(nwProd, cwProd, cwEnde, cwLoca,cwData)
Local lRet := .T.
Local cQry := ""

/*For i:=1 to Len(aCols)
	If i <> n .And. aCols[i][nwProd] == cwProd
		MsgStop("O produto escolhido já consta nesta cartela!")
		lRet := .F.
	EndIf
Next

If lRet
	cQry += "SELECT Z4_NUM, Z4_OBS,  Z4_AREA, Z5_COD "
	cQry += "  FROM SZ4010 A, SZ5010 B "
	cQry += " WHERE A.D_E_L_E_T_ = '' "
	cQry += "   and Z4_FILIAL = '" + xFilial("SZ4") + "' "
	cQry += "   and Z5_FILIAL = '" + xFilial("SZ5") + "' "
	cQry += "   AND B.D_E_L_E_T_ = '' "
	cQry += "   AND Z4_NUM  	  = Z5_NUM  "
//	cQry += "   AND Z4_LOCAL   = '" + cwLoca + "' "
	cQry += "   AND Z4_AREA = '" + cwEnde + "' "
	cQry += "   AND Z5_COD     = '" + cwProd + "' "
	cQry += "   AND Z4_DATA    = '" + DTOS(cwData) + "' "
	
	cQry += " Order by Z4_NUM,Z5_COD "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"XXX",.T.,.T.)
	
	If !XXX->(Eof())
		MsgStop("O produto escolhido já existe no endereço do armazém escolhido na cartela "+XXX->Z4_NUM+"!")
		lRet := .F.
	EndIf
	XXX->(dbCloseArea())
EndIf

oGet:Refresh()
oDlg:Refresh()                */

Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ EstP01b    ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 24/12/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Valida a delecao dos Itens                                     ¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function EstP01b()
Local cVar := ReadVar()
Local nAtu := aScan(aHeader,{|x| Trim(x[2]) == SubStr(cVar,4,len(cVar))})
Local lRet := .T.

lRet := fValProd(_nCol1, oGet:aCols[n][_nCol1], _cEnd, _cLoc)
Return lRet


Static Function GetSZ5(cCart)
Local cQry   := ""
Local nTotal := 0

cQry += " Select count(*) TOT From " + RetSqlName("SZ5")
cQry += " Where D_E_L_E_T_ <> '*'
cQry += " And Z5_NUM = '" + cCart + "'"
cQry += " and Z5_FILIAL = '" + xFilial("SZ5") + "' "

MPSysOpenQuery( cQry, "DROR" ) // dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"DROR",.T.,.T.)
nTotal := DROR->TOT
DROR->(dbCLoseArea())

Return nTotal

Static Function fwGetSZ5(cwCartela)  
 
 Local  cQry := ""
 
	cQry += "SELECT * "
	cQry += "  FROM SZ5010 AS  B "
	cQry += " WHERE B.D_E_L_E_T_ = '' "
	cQry += "   and Z5_FILIAL = '" + xFilial("SZ5") + "' "
	cQry += "   AND Z5_NUM = '" + cwCartela + "' "         
	
	cQry += " Order by R_E_C_N_O_  "
	
	MPSysOpenQuery( cQry, "TMP1" ) // dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP1",.T.,.T.)
	
Return Nil 
