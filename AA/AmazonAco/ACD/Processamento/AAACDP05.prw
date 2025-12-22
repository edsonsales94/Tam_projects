#include 'protheus.ch'
#include 'parmtype.ch'

User Function AAACDP05()
	//Local aSave := VTSAVE()
	Local aCB8 := CB8->(GetArea())
	Conout("Entrou ")
	If VTYesNo(" Deseja Realmente Finalizar a Separacao do Item:" + Alltrim(CB8->CB8_PROD) + ", Local:" + CB8->CB8_LOCAL + "  ?","Atenção ",.T.)				
		//lContinua := .T.
		CB8->(RecLock('CB8',.F.))
		CB8->CB8_QTDORI :=CB8->CB8_QTDORI-CB8->CB8_SALDOS
		CB8->CB8_SALDOS:=0
		CB8->(MsUnlock())

		PA2->(DbSetOrder(5))
		PA2->(DbSeek(xFilial("PA2")+CB8->CB8_ORDSEP+CB8->CB8_ITEM+CB8->CB8_PROD))
		RecLock("PA2",.F.)
		PA2->PA2_QUANT := CB8->CB8_QTDORI
		MsUnlock()

		nPos :=Ascan(aItens,{|x| x[1]+x[2]+x[3] == CB8->(CB8_PROD+CB8_ITEM+CB8_SEQUEN)})
		If nPos>0
			ADel(aItens,nPos)
			ASize( aItens , Len(aItens) - 1 )
		EndIf
		CB7->(DbSetOrder(1))
		CB7->(DbSeek(xFilial("CB7")+CB8->CB8_ORDSEP))
		Conout("Operador: "+CB7->CB7_CODOPE+" finalizou o Item:" + Alltrim(CB8->CB8_PROD) + ", Local:" + CB8->CB8_LOCAL+" da ordem: "+CB8->CB8_ORDSEP)
		VTKeyBoard(chr(27))		
	Else
		lContinua := .F.
	EndIf


	CB8->(RestArea(aCB8))
	//VtRestore(,,,,aSave)	
Return Nil