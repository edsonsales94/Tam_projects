#Include "RwMake.ch"
/*
	Objetivo: Gatilho para atualizar os campos D1_TES, D1_CF e D1_CLASFIS da pre-nota de D.I. (Exclusivo: Coelmatic/Manaus)
	          Campo disparador D1_TES
	Por.....: Carlos Nina
	Data....: 06/08/2013
*/

User Function CGAT_DI()

Local cx_TES    := M->D1_TES
Local nPosTES   := GdFieldPos("D1_TES", aHeader)
Local nPosCF    := GdFieldPos("D1_CF", aHeader)
Local nPosCla   := GdFieldPos("D1_CLASFIS", aHeader)
Local nx , lValid

IF ( M->cNumEmp == "0301" )
	If n == 1 .And. Len(aCols) > 1
		For nx := 2 to Len(aCols)
			 n:=nx
			 aCols[nx,nPosTES]   := aCols[1,nPosTES]
			 aCols[nx,nPosCF]    := aCols[1,nPosCF]
			 aCols[nx,nPosCla]   := aCols[nx,nPosCla]+Posicione("SF4",1,xFilial("SF4")+aCols[1,nPosTES],"F4_SITTRIB")
			 lValid := MaAvalTes("E",aCols[nx,nPosTES]).And.MaFisRef("IT_TES","MT100",aCols[nx,nPosTES])
		Next
	Endif
	N := 1
	Return(aCols[n,nPosTES])
ELSE
	Return(cx_TES)
ENDIF
