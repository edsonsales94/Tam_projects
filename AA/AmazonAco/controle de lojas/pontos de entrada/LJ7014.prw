#Include "rwmake.ch"
#include "Protheus.CH"

//Chamado na função de análise de crédito.

User Function LJ7014()

Local lRet 	   := .T. 
Local _ldRet   := .F.
Local nSalDup  := 0
Local I

//nSaldo := SomaAber()
If  SA1->A1_RISCO <> "A"

	For I:=1 to Len(aPgtos)
		     
		If ( (aPgtos[I][1] > dDataBase .And. Alltrim(aPgtos[I][3]) == "CH") .Or.  (Alltrim(aPgtos[I][3]) $ GetMv("MV_XFORMC"))  )
		   nSaldup += aPgtos[I][2]
		   _ldRet := .T.
		EndIf
	Next
	lRet := SA1->A1_LC < (Getsaldo(SA1->A1_COD,SA1->A1_LOJA) + nSalDup) .and. !_ldRet .Or. nSalDup = 0
	
EndIf

Return (lRet)

Static Function GetSAldo(cCliente,cLoja)
Local nResult := 0
Local cFilSE1 := SE1->(XFILIAL("SE1"))

SE1->(dbSetOrder(2))
SE1->(dbSeek(cFilSE1+cCliente+cLoja,.T.))
While !SE1->(Eof()) .And. cFilSE1+cCliente+cLoja == SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA)
   If SE1->E1_SALDO > 0 .And. !(Trim(SE1->E1_TIPO) $ "TC,CC,CD,NCC,CR")
      nResult += SE1->E1_SALDO
   Endif
   SE1->(dbSkip())
Enddo

Return nResult