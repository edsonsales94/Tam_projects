#include 'Protheus.ch'

/*
Autor     : Diego Rafael
Descricao : Executar a Regra de desconto
*/

User Function VLDESCPRD(cCodPrd,nPercDesc,cCodVend)

Local aArea      := GetArea()
Local aB1Area    := SB1->(GetArea())
Local nResult    := .F.
Local nPerMax    := 0

_nPercMax := Posicione("SA3", 1, xFilial("SA3") + cCodVend, "A3_PERDESC")

Default cCodPrd  := ''
Default nPercDesc:= 0
 
nPerMax := _nPercMax
nResult := nPercDesc > _nPercMax

If !Empty(cCodPrd)
	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial('SB1')+cCodPrd))
		
		If SB1->B1_XMAXDES != 0
			nPerMax  := SB1->B1_XMAXDES
			If nResult := nPercDesc > SB1->B1_XMAXDES
      //         Aviso('ATENCAO','Desconto Concedido Maior que o Maximo Permitido para o Item : ' + cCodPrd,{'Ok'})
			EndIf
		else
			SBM->(dbSetOrder(1))
			If SBM->(dbSeek(xFilial('SBM')+SB1->B1_GRUPO))
				If SBM->(FieldPos('BM_XDESCON')) > 0 // Verifica se o Campo Existe no SX3
					If SBM->BM_XDESCON != 0
						nPerMax  := SBM->BM_XDESCON
						If nResult := nPercDesc > SBM->BM_XDESCON
	//					   Aviso('ATENCAO','Desconto Concedido Maior que o Maximo Permitido para o Grupo : ' + SB1->B1_GRUPO,{'Ok'})
						EndIf
					EndIf
				else
				   If nResult := nPercDesc > _nPercMax
//					  Aviso('ATENCAO','Desconto Concedido Maior que o Maximo Permitido para o Vendedor' ,{'Ok'})
				   EndIf
				EndIf
			else				
				If nResult := nPercDesc > _nPercMax
  //				   Aviso('ATENCAO','Desconto Concedido Maior que o Maximo Permitido para o Vendedor' ,{'Ok'})
				EndIf
			EndIf
		EndIf
		
	EndIf
EndIf

SB1->(RestArea(aB1Area))
RestArea(aArea)

Return {nResult,nPerMax}



/* powered by DXRCOVRB*/
