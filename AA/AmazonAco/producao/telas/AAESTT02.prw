#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"
/*/
 .----------------------------------------------------------------------------------------------------------------------.
|     Programa     |     AAESTT02      |     Autor     |     Wagner da Gama Corrêa     |     Data     |     09/12/10     |
|------------------------------------------------------------------------------------------------------------------------|
|     Descricao    |     Informar Codigo do Corte de Slitter para desmontagem de Prod                                    |
 '----------------------------------------------------------------------------------------------------------------------'
/*/
User Function AAESTT02()

Local aPos   := {}

_cArea := GetArea()

Conpad1(,,,"SZ0")
aAdd(aPos, aScan(aHeader,{|x| Alltrim(x[02]) == "D3_COD"     })  )
aAdd(aPos, aScan(aHeader,{|x| Alltrim(x[02]) == "D3_QUANT"   })  )
aAdd(aPos, aScan(aHeader,{|x| Alltrim(x[02]) == "D3_QTSEGUM" })  )
aAdd(aPos, aScan(aHeader,{|x| Alltrim(x[02]) == "D3_LOCAL"   })  )
aAdd(aPos, aScan(aHeader,{|x| Alltrim(x[02]) == "D3_RATEIO"  })  )

SZ1->(dbSetOrder(1))
SZ1->(dbSeek(xFilial('SZ1')+SZ0->Z0_NUM))

aCols         := {}
M->cProduto   := SZ0->Z0_COD
M->cLocOrig   := Posicione('SB1',1,xFilial('SB1')+SZ0->Z0_COD,"B1_LOCPAD")
M->nQtdOrig   := 1
M->nQtdOrigSe := ConvUM( SZ0->Z0_COD, M->nQtdOrig,, 2)
M->cDocumento := SZ0->Z0_NUM

While( !SZ1->(Eof()) .and. SZ1->Z1_NUM = SZ0->Z0_NUM )

  SB1->(dbSetOrder(1))
  SB1->(dbSeek(xFilial('SB1')+SZ1->Z1_CODSLIT))
  ndUse := Len(aHeader)
  aAdd(aCols, Array(ndUse + 1) )
  nAtual := Len(aCols)
  For c:=1 To ndUse
	  If aHeader[c,8] == "C";     aCols[nAtual,c]:= Space(aHeader[c,4])
	  Elseif aHeader[c,8] == "N"; aCols[nAtual,c]:= 0
	  Elseif aHeader[c,8] == "D"; aCols[nAtual,c]:= Ctod("  /  /  ")
  	  Elseif aHeader[c,8] == "M"; aCols[nAtual,c]:= ""
  	  Else
	  	aCols[nAtual,c]:= .F.
      Endif
  Next  
  aCols[nAtual,c]:= .F.
  n      := nAtual
  aCols[nAtual,aPos[01]] := SZ1->Z1_CODSLIT
  aCols[nAtual,aPos[02]] := SZ1->Z1_QUANT
  aCols[nAtual,aPos[03]] := ConvUM( SZ1->Z1_CODSLIT, SZ1->Z1_QUANT,,2)
  //aCols[nAtual,aPos[04]] := SB1->B1_LOCPAD
  aCols[nAtual,aPos[05]] := SZ1->Z1_RATEIO
  
  SZ1->(dbSkip())
EndDo

oGet:Refresh()
oGet:lNewLine := .F.
RestArea(_cArea)
Return Nil