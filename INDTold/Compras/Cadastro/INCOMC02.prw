#include 'Protheus.ch'
#include 'RwMake.ch'
#include 'TBICONN.ch'

User Function INVIAC02()

Private cSTring  := 'SZ7'
Private aRotina  :=  { {"Incluir   "    ,"u_INCOMC2I",0,3},;
                       {"Visualizar"    ,"u_INCOMC2V",0,2},;
                       {"Alterar"       ,"u_INCOMC2A",0,4},;
                       {"Excluir"       ,"u_INCOMC2E",0,5},;
                       {"Legenda"       ,"u_PcoC02G" ,0,7},;
                       {"Ver Projeto"   ,"u_PcoC02H" ,0,7}}

Private aCores   := {}

Private aHeaderCC:= {}
Private aHeaderPa:= {}
Private aHeaderHt:= {}
Private aHeaderCa:= {}
Private aHeaderAn:= {}


mBrowse( 6,1,22,75,cString,,,,,,/*aCores*/)
Return Nil

User Function INCOMC2I()
Private aButtons := {}

aAdd(aButtons,{'UPDINFORMATION',{|| u_INCOMC2D(3) }, 'Detalhes', 'Detalhes'})
//AxInclui ( [ cAlias ] [ nReg ] [ nOpc ] [ aAcho ] [ cFunc ] [ aCpos ] [ cTudoOk ] [ lF3 ] [ cTransact ] [ aButtons ] [ aParam ] [ aAuto ] [ lVirtual ] [ lMaximized ] [ cTela ] [ lPanelFin ] [ oFather ] [ aDim ] [ uArea ] )

nResul := AxInclui('SZ7', , , , , , , , , aButtons , , , )
If nResul = 1
	GravaCols()
EndIf

Return

User Function INCOMC2E()
Private aButtons := {}

aAdd(aButtons,{'UPDINFORMATION',{|| u_INCOMC2D(2) }, 'Detalhes', 'Detalhes'})
//AxInclui ( [ cAlias ] [ nReg ] [ nOpc ] [ aAcho ] [ cFunc ] [ aCpos ] [ cTudoOk ] [ lF3 ] [ cTransact ] [ aButtons ] [ aParam ] [ aAuto ] [ lVirtual ] [ lMaximized ] [ cTela ] [ lPanelFin ] [ oFather ] [ aDim ] [ uArea ] )
nResul := AxExclui('SZ7', , , , , , , , , aButtons , , , )
If nResul = 1
	//GravaCols()
EndIf
Return

Static FUnction TakeData(cTbl,aHeader,cKey,cValue)
  Local aData := {}
  Local cQry  := ''
  Local cTable:= GetNextAlias()
  Local nL

  cQRy += " Select * FRom " + RetSqlName(cTbl)
  cQRy += " Where D_E_L_E_T_ = ' '"
  cQRy += " And " + cKey + "= '" + cValue + "'"
  
  dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),cTable,.T.,.T.)
  While !(cTable)->(EOF())
     aAdd(aData,Array(Len(aHeader) + 1))
     For nL := 1 to Len(aHeader)
        aData[len(aData)][nL] := CriaVar(aHeader[nL][02])
        aData[len(aData)][nL] := (cTable)->&(aHeader[nL][02])
     Next
     aData[len(aData)][nL] := .F.
     (cTable)->(dbSkip())
  EndDo
Return aData

User Function INCOMC2V()
Private aButtons  := {}
Private cCadastro := 'Visualizar'

aHeaderCC := aClone(CriaHeader('SZH','ZH_FILIAL/ZH_NUM'))
aHeaderPa := aClone(CriaHeader('SZI','ZI_FILIAL/ZI_NUM'))
aHeaderHt := aClone(CriaHeader('SZJ','ZJ_FILIAL/ZJ_NUM'))
aHeaderCa := aClone(CriaHeader('SZK','ZK_FILIAL/ZK_NUM'))
aHeaderAn := aClone(CriaHeader('SZF','ZF_FILIAL/ZF_NUM/ZF_TIPO/ZF_ARQSRV/ZF_CAMINHO'))

aHeaderCC[02] := aClone(TakeData('SZH',aHeaderCC[01],'ZH_FILIAL+ZH_NUM',xFilial('SZH')+SZ7->Z7_CODIGO))
aHeaderPa[02] := aClone(TakeData('SZI',aHeaderPa[01],'ZI_FILIAL+ZI_NUM',xFilial('SZI')+SZ7->Z7_CODIGO))
aHeaderHt[02] := aClone(TakeData('SZJ',aHeaderHt[01],'ZJ_FILIAL+ZJ_NUM',xFilial('SZJ')+SZ7->Z7_CODIGO))
aHeaderCa[02] := aClone(TakeData('SZK',aHeaderCa[01],'ZK_FILIAL+ZK_NUM',xFilial('SZK')+SZ7->Z7_CODIGO))
aHeaderAn[02] := aClone(TakeData('SZF',aHeaderAn[01],'ZF_FILIAL+ZF_NUM',xFilial('SZF')+SZ7->Z7_CODIGO))

aAdd(aButtons,{'UPDINFORMATION',{|| u_INCOMC2D(2) }, 'Detalhes', 'Detalhes'})
//AxInclui ( [ cAlias ] [ nReg ] [ nOpc ] [ aAcho ] [ cFunc ] [ aCpos ] [ cTudoOk ] [ lF3 ] [ cTransact ] [ aButtons ] [ aParam ] [ aAuto ] [ lVirtual ] [ lMaximized ] [ cTela ] [ lPanelFin ] [ oFather ] [ aDim ] [ uArea ] )
AxVisual('SZ7', SZ7->(recno()), 2, , , , , aButtons)
Return NIL

User Function INCOMC2A()
Private aButtons := {}

aAdd(aButtons,{'UPDINFORMATION',{|| u_INCOMC2D(4) }, 'Detalhes', 'Detalhes'})
//AxInclui ( [ cAlias ] [ nReg ] [ nOpc ] [ aAcho ] [ cFunc ] [ aCpos ] [ cTudoOk ] [ lF3 ] [ cTransact ] [ aButtons ] [ aParam ] [ aAuto ] [ lVirtual ] [ lMaximized ] [ cTela ] [ lPanelFin ] [ oFather ] [ aDim ] [ uArea ] )
AxAltera('SZ7', , , , , , , , , aButtons , , .T. , .T.)
Return

User Function INCOMC2T()
Local lRet := .T.

Return lRet

User Function INCOMC2D(nOpc)
Local nLin      := 20
Local nCol      := 10

//   Prepare environment Empresa '01' Filial '01' Tables 'SZH'

cLinOk   := 'Allwaystrue'
cTudOk   := 'Allwaystrue'
cIniPos  := ''
aAlter   := {}
nFreeze  := 0
nMax     := 999
cFieldOk := 'AllwaysTrue'
cSuperDel:= 'AllwaysTrue'
cDelOk   := 'AllwaysTrue'


aHeaderCC := iIf( Len(aHeaderCC)=0, aClone(CriaHeader('SZH','ZH_FILIAL/ZH_NUM')) ,aHeaderCC )
aHeaderPa := iIF( Len(aHeaderPa)=0, aClone(CriaHeader('SZI','ZI_FILIAL/ZI_NUM')) ,aHeaderPa )
aHeaderHt := iIf( Len(aHeaderHt)=0, aClone(CriaHeader('SZJ','ZJ_FILIAL/ZJ_NUM')) ,aHeaderHt )
aHeaderCa := iIf( Len(aHeaderCa)=0, aClone(CriaHeader('SZK','ZK_FILIAL/ZK_NUM')) ,aHeaderCa )
aHeaderAn := iIf( Len(aHeaderAn)=0, aClone(CriaHeader('SZF','ZF_FILIAL/ZF_NUM/ZF_TIPO/ZF_ARQSRV')) ,aHeaderAn )

aAlterCC := {}
aAlterPa := {}
aAlterHt := {}
aAlterCa := {}
aAlterAn := {}

If nOpc = 3
	aEval(aHeaderCC[01],{ |x|  iIf( !Alltrim(x[02])$'ZH_ITEM' ,aAdd(aAlterCC,x[02]),'')  } )
	aEval(aHeaderPa[01],{ |x|  iIf( !Alltrim(x[02])$'ZI_ITEM' ,aAdd(aAlterPa,x[02]),'')  } )
	aEval(aHeaderHt[01],{ |x|  iIf( !Alltrim(x[02])$'ZJ_ITEM' ,aAdd(aAlterHt,x[02]),'')  } )
	aEval(aHeaderCa[01],{ |x|  iIf( !Alltrim(x[02])$'ZK_ITEM' ,aAdd(aAlterCa,x[02]),'')  } )
	aEval(aHeaderAn[01],{ |x|  iIf( !Alltrim(x[02])$'ZF_ITEM' ,aAdd(aAlterAn,x[02]),'')  } )
EndIf
aIniPos := {}
aAdd(aIniPos,iIf(nOpc = 3, '+ZH_ITEM' ,'') )
aAdd(aIniPos,iIf(nOpc = 3, '+ZI_ITEM' ,'') )
aAdd(aIniPos,iIf(nOpc = 3, '+ZJ_ITEM' ,'') )
aAdd(aIniPos,iIf(nOpc = 3, '+ZK_ITEM' ,'') )
aAdd(aIniPos,iIf(nOpc = 3, '+ZF_ITEM' ,'') )

nOp := GD_INSERT + GD_UPDATE + GD_DELETE

@ 010,010   TO 900,1350 DIALOG oDlg TITLE OemToAnsi("Requisicao de Viagem")

@ nLin + 000 ,nCol + 000 TO 130,nCol + 330 Title 'Centro de Custo Financiadores'
oGetD1:= MsNewGetDados():New(nLin + 08,nCol + 05,nLin + 100,nCol + 322, nOp,cLinOk,cTudOk,aIniPos[01] ,aAlterCc,/*nFreeze*/,nMax,cFieldOk, cSuperDel,cDelOk, oDLG, aHeaderCC[01], aHeaderCC[02])
//oGetD1:oBrowse:lUseDefaultColors := .F.
//oGetD1:oBrowse:SetBlkBackColor({|| GETDCLR(oGetD1:aCols,oGetD:nAt,aHeaderCC[01])})

nLin += 110
@ nLin + 000 ,nCol + 000 TO nLin + 110,nCol + 330 Title 'Passagens'
oGetD2:= MsNewGetDados():New(nLin + 08,nCol + 05,nLin + 100,nCol + 322, nOP,cLinOk,cTudOk,aIniPos[02],aAlterPa ,/*nFreeze*/,nMax,cFieldOk, cSuperDel,cDelOk, oDLG, aHeaderPa[01], aHeaderPa[02])

nLin := 20
nCol += 330
@ nLin + 000 ,nCol + 000 TO nLin + 110,nCol + 330 Title 'Locacao de Hotel'
oGetD3:= MsNewGetDados():New(nLin + 08,nCol + 05,nLin + 100,nCol + 322, nOP,cLinOk,cTudOk,aIniPos[03], aAlterHt,/*nFreeze*/,nMax,cFieldOk, cSuperDel,cDelOk, oDLG, aHeaderHt[01], aHeaderHt[02])

nLin += 110
@ nLin + 000 ,nCol + 000 TO nLin + 110,nCol + 330 Title 'Locacao de Carro'
oGetD4:= MsNewGetDados():New(nLin + 08,nCol + 05,nLin + 100,nCol + 322, nOP,cLinOk,cTudOk,aIniPos[04], aAlterCa,/*nFreeze*/,nMax,cFieldOk, cSuperDel,cDelOk, oDLG, aHeaderCa[01], aHeaderCa[02])

nLin += 110
nCol := 010
@ nLin + 000 ,nCol + 000 TO nLin + 110,nCol + 660 Title 'Anexo'
oGetD5:= MsNewGetDados():New(nLin + 08,nCol + 05,nLin + 100,nCol + 652, nOP,cLinOk,cTudOk,aIniPos[05], aAlterAn,/*nFreeze*/,nMax,cFieldOk, cSuperDel,cDelOk, oDLG, aHeaderAn[01], aHeaderAn[02])

Activate Dialog oDlg Centered on init;
EnchoiceBar(oDlg,{|| nOpc := 2,oDlg:End() },{||oDlg:End(),nOpcC := 1},,) CENTERED
If nOpc = 2
	aHeaderCC[02] := aClone(oGetD1:aCols)
	aHeaderPa[02] := aClone(oGetD2:aCols)
	aHeaderHt[02] := aClone(oGetD3:aCols)
	aHeaderCa[02] := aClone(oGetD4:aCols)
	aHeaderAn[02] := aClone(oGetD5:aCols)
EndIf
Return Nil

Static Function GravaCols()
Local nK
Local nI

For nI := 1 to Len(aHeaderCC[02])
	SZH->(RecLock('SZH',.T.))
	
	SZH->ZH_FILIAL := xFilial('SZH')
	SZH->ZH_NUM    := SZ7->Z7_CODIGO
	For nK := 1 to Len(aHeaderCC[01])
		If !aHeaderCC[02][nI][Len(aHeaderCc[02][nI])]
			SZH->&(aHeaderCC[01][nK][02]) := aHeaderCC[02][nI][nK]
		EndIf
	Next
	SZH->(MsUnlock())
Next

For nI := 1 to Len(aHeaderPa[02])
	SZI->(RecLock('SZI',.T.))
	SZI->ZI_FILIAL := xFilial('SZI')
	SZI->ZI_NUM    := SZ7->Z7_CODIGO
	For nK := 1 to Len(aHeaderPa[01])
		If !aHeaderPa[02][nI][Len(aHeaderPa[02][nI])]
			SZI->&(aHeaderPa[01][nK][02]) := aHeaderPa[02][nI][nK]
		EndIf
	Next
	SZI->(MsUnlock())
Next

For nI := 1 to Len(aHeaderHt[02])
	SZJ->(RecLock('SZJ',.T.))
	SZJ->ZJ_FILIAL := xFilial('SZJ')
	SZJ->ZJ_NUM    := SZ7->Z7_CODIGO
	For nK := 1 to Len(aHeaderHt[01])
		If !aHeaderHt[02][nI][Len(aHeaderHt[02][nI])]
			SZJ->&(aHeaderHt[01][nK][02]) := aHeaderHt[02][nI][nK]
		EndIf
	Next
	SZJ->(MsUnlock())
Next


For nI := 1 to Len(aHeaderCa[02])
	SZK->(RecLock('SZK',.T.))
	SZK->ZK_FILIAL := xFilial('SZF')
	SZK->ZK_NUM    := SZ7->Z7_CODIGO
	For nK := 1 to Len(aHeaderCa[01])
		If !aHeaderHt[02][nI][Len(aHeaderCa[02][nI])]
			SZK->&(aHeaderCa[01][nK][02]) := aHeaderCa[02][nI][nK]
		EndIf
	Next
	SZK->(MsUnlock())
Next

cQuery := " DELETE "+RetSQLName("SZF")
cQuery += " WHERE ZF_NUM = '"+SZ7->Z7_CODIGO+"'
cQuery += " AND  ZF_TIPO = '"+'4'+"' AND ZF_FILIAL = '"+xFilial("SZF")+"'"
TcSqlExec(cQuery)

For nI := 1 to Len(aHeaderAn[02])
	
	SZF->(RecLock('SZF',.T.))
	SZF->ZF_FILIAL := xFilial('SZF')
	SZF->ZF_NUM    := SZ7->Z7_CODIGO
	SZF->ZF_TIPO   := '4'
	For nK := 1 to Len(aHeaderAn[01])
		If !aHeaderAn[02][nI][Len(aHeaderAn[02][nI])]
			SZF->&(aHeaderAn[01][nK][02]) := aHeaderAn[02][nI][nK]
		EndIf
	Next
	SZF->(MsUnlock())
	aVetor := StrTokArr ( SZF->ZF_CAMINHO, '\' )
	
	SZF->(RecLock('SZF',.F.))
	IF Len(aVetor) > 1
   	aVetor[Len(aVetor)]
   	SZF->ZF_ARQ := aVetor[Len(aVetor)]
   EndIf	
	lCpyOk := IiF( Empty(SZF->ZF_CAMINHO),.F., CPYT2S(SZF->ZF_CAMINHO,"\web") )
	iF !lCpyOk .Or. Len(aVetor) = 0
		SZF->(dbDelete())
		Alert("Error na Gravacao do anexo. Arquivo nao pode ficar na Unidade principal !")
	else
		cArqSrv := SZ7->Z7_CODIGO+'4'+StrZero(nI,3)+Right(Alltrim(SZF->ZF_ARQ),4)
		FErase("\web\"+cArqSrv)
		FRename("\web\"+SZF->ZF_ARQ,"\web\"+cArqSrv)
		SZF->ZF_ARQSRV := cArqSrv
	EndIf
	SZF->(MsUnlock())
Next

Return Nil

Static Function CriaHeader(cTbl,cCampos)

Local aHeader := {}
Local aAreaSX3:= SX3->(GetArea())
Local aCols   := {}
Local nK

SX3->(dbSetOrder(1))
SX3->(dbSeek(cTbl))

WHile cTbl = SX3->X3_ARQUIVO
	If cNivel >= SX3->X3_NIVEL .And. X3USO(SX3->X3_USADO) .And. !(Alltrim(SX3->X3_CAMPO) $ cCampos)
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
	EndIf
	SX3->(dbSkip())
EndDo
SX3->(GetArea())
aAdd(aCols,Array(Len(aHeader)+1))

For nK := 1 To Len(aHeader)
	aCols[01,nK] := CriaVar(aHeader[nK,02])
Next
aCols[01,nK] := .F.
aCols[01,01] := '001'

Return {aHeader,aCols}
