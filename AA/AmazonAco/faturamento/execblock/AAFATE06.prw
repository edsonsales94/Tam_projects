#include "TOTVS.ch"

User Function AAFATE06(_ndLinha)
   Local lRet    := .T.
   Local _ndPosV := aScan(aHeader,{|x| ALltrim(x[02]) == "C6_QTDAUX" })
   Local _ndPosA := aScan(aHeader,{|x| ALltrim(x[02]) == "C6_QTDVEN" })
   Local _nPosPro:= aScan(aHeader,{|x| Alltrim(x[02]) == "C6_PRODUTO"})
   
   if (__CUSERID $ SUPERGETMV("MV_XUSREXP") ) .And. iIf(INCLUI,.F.,Empty(SC5->C5_ORCRES))
      If Abs((aCols[_ndLinha][_ndPosA] - aCols[_ndLinha][_ndPosV])) * 100 / aCols[_ndLinha][_ndPosV] > 10 //.And. lInclui
         Aviso('Atencao','Não e Possivel altera a Quantidade com diferenca maior que 10%',{'OK'},2)
         lRet := .F.
      EndIf 
   EndIf
  
   If !Empty(SC5->C5_ORCRES)
	   If ((aCols[_ndLinha][_ndPosA] - aCols[_ndLinha][_ndPosV])) * 100 / aCols[_ndLinha][_ndPosV] > 00 //.And. lInclui
	   	  Aviso('Atencao','Não e Possivel altera a Quantidade de Pedidos com Reserva',{'OK'},2)
          lRet := .F.
       EndIf 
   EndIF
   
   /*Atendendo a ordem de separacao */
  /* lTransf := ISINCALLSTACK("U_AAFATP01") .Or. cEmpAnt $ "05/06" .Or. (cEmpAnt=="01" .And. cFilAnt<>"01" )
   If !lTransf 
	   If aCols[_ndLinha][_ndPosA]<Posicione("SB1",1,xFilial("SB1")+aCols[_ndLinha][_nPosPro],"B1_XMPEMB")
	   		M->C6_QTDVEN :=aCols[_ndLinha][_ndPosA] :=SB1->B1_XMPEMB
	   Else
	   		M->C6_QTDVEN :=aCols[_ndLinha][_ndPosA] := Abs(Round((M->C6_QTDVEN/SB1->B1_XMPEMB),0) * SB1->B1_XMPEMB)-M->C6_QTDVEN+M->C6_QTDVEN  
	   EndIf
   EndIf*/
   
   
   
Return lRet

User Function AAFTE06A()
  Local lRet := .T.
  If Inclui
      lRet  := !(__CUSERID $ SUPERGETMV("MV_XUSREXP") ) 
  EndIf
  If Altera
     If !Empty( SC5->C5_ORCRES ) .And. (__CUSERID $ SUPERGETMV("MV_XUSREXP") ) 
        lRet := .F.
     EndIf
  EndIf
Return lRet