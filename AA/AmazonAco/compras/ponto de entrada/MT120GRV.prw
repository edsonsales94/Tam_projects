#include "Protheus.ch"
#include "Totvs.ch"
#include "font.ch"
#Include "rwmake.ch"
#INCLUDE "URZUM.CH" 

User Function MT120GRV()

Local _cNum    := PARAMIXB[1]
Local _lInclui := PARAMIXB[2]
Local _lAltera := PARAMIXB[3]
Local _lExclui := PARAMIXB[4] 

Local lRet := .T.

If _lInclui .Or. _lAltera

  _cGrp := AAGETGRP()  
  _nPos := aScan(aHeader,{|x| Alltrim(x[02]) == "C7_APROV"})
  
  If _nPos > 0
	  For _nJ := 1 to len(aCols)
	     aCols[_nJ][_nPos] := _cGrp
	  Next
  EndIf
  
EndIf                         
  
// lRet := Iif(!IsBlind(),U_UZPCGrv(aCabImp),.T.)

Return lRet


Static Function AAGETGRP()


_cdGrpAprov := Space(TamSx3('C7_APROV')[01])
lClose  := .F.
Define Font oFnt3 Name "Ms Sans Serif" Bold

while Empty(_cdGrpAprov) .Or. !lClose
	lClose := .T.
	Define Msdialog oDialog Title "Grupo de Aprovacao" From 190,110 to 300,370 Pixel //STYLE nOR(WS_VISIBLE,WS_POPUP)
	@ 005,004 Say "Grupo de Aprovacao :" Size 220,10 Of oDialog Pixel Font oFnt3
	@ 005,050 MsGet _cdGrpAprov   Size 50,10  Picture "@!" Pixel of oDialog F3 "SAL"
	
	@ 035,042 BmpButton Type 1 Action ( nRet := iIf( !Empty(_cdGrpAprov) ,oDialog:End(),nil) )
	
	Activate Dialog oDialog Centered
	
Enddo

Return _cdGrpAprov