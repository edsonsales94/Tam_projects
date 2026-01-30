#INCLUDE "Protheus.ch"

User Function MCESTE02(cCodBar)
	Local cPrd := PADR(cCodBar,TamSX3("D3_COD")[1])
	Local cEtq := SubStr(cCodBar,17,TamSX3("D3_XETIQUE")[1])
	Local nQtd := Val(SubStr(cCodBar,25,7)) / 100
	Local cOP  := SubStr(cCodBar,32,TamSX3("C2_NUM")[1]    ) + "01001"
	Local lRet := .F.
	
	M->D3_XCODBAR := ""
	M->D3_OP      := ""
	
	SC2->(DbSetOrder(6))
	If Len(AllTrim(cCodBar)) < 37 .Or. !SC2->(MsSeek(xFilial("SC2")+cOP+cPrd))
		Alert("Etiqueta não é valida para apontamento !")
		Return lRet // Add por Anizio Cunha 27/11/2024
	Endif
	SD3->(DbSetOrder(19)) //SD3->(DbSetOrder(18)) // comentado por Anizio Cunha 27/11/2024
	If SD3->(MsSeek(xFilial("SD3")+cEtq))
		Alert("Etiqueta já utilizada no documento: " + SD3->D3_DOC)
		//Alert("Etiqueta já utilizada no documento: " + SD3->D3_DOC) // Comentado por Anizio Cunha 27/11/2024
		Return lRet // Add por Anizio Cunha 27/11/2024
	Endif
	
	M->D3_OP := cOP
	lRet := A250IniOP()
	M->D3_XETIQUE := cEtq
	M->D3_QUANT   := nQtd
	M->D3_XHORA   := TIME()
	M->D3_XCODBAR := ''
	//M->D3_LOTECTL :=SubStr(ALLTRIM(cCodBar),1,11)    //Claudio franca 2019_07_11
	
	If (SC2->C2_QUANT - SC2->C2_QUJE) > M->D3_QUANT
		M->D3_PARCTOT := "P"
	Else
		M->D3_PARCTOT := "T"
	EndIf
	
	SD3->(DbCloseArea())
Return lRet
