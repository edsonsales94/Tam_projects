#include 'totvs.ch'

User Function Mt103fim

Local cNfent := SF1->F1_DOC+SF1->F1_SERIE
Local cTesbn := GETMV("MV_X_TESBN")
Local cTesct := GETMV("MV_X_TESCT")

Local _aVetor :={}
Local _aAreaSd1 := GetArea()
Local nControl  := PARAMIXB[1]
Local nCusto	:= 0
Local cMoedaCus	:= ""
Local lemerg	:= .f.

//If SM0->M0_CODFIL == "01"// So executa na Matriz
	
	If nControl == 5 .and. TYPE("aVetDeOP") == "A"
		For nX := 1 To Len(aVetDeOP)
			dbSelectArea("SC2")
			dbSetOrder(1)
			If dbSeek( xFilial("SC2")+aVetDeOP[nX])  //so entra se o no. da OP se ja existir.
				lMsErroAuto := .f.
				GetSX3Field("SC2")
				MSExecAuto({|x,y| mata650(x,y)},_aVetor,5) //Exclusao
				If lMsErroAuto
					MostraErro()
					MsgAlert("Erro")
				Else
					Alert("OP Numero " + aVetDeOP[nX] + "Excluida com Sucesso")
				Endif
			Endif
		Next nX
		RestArea(_aAreaSd1)
	Else
		if nControl == 3
			dbSelectArea("SD1")
			dbSetOrder(1)
			SD1->(dbgotop())
			If dbSeek( xFilial("SD1")+cNfent )  //so entra se o no. da nfe ja existir.
				while SD1->D1_DOC+SD1->D1_SERIE == cNfent
					If ! Empty(SD1->D1_PEDIDO)
						dbSelectArea("SC7")
						dbSetOrder(1)
						If dbseek(xfilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC)
							If SC7->C7_EMERGEN =="N"
								nCusto 		:= SC7->C7_PRECO
								cMoedaCus	:= cValToChar(SC7->C7_MOEDA)
								lemerg := .F.
							Else
								lemerg := .T.
							Endif
						Endif
					Else
						nCusto		:= SD1->D1_VUNIT
						cMoedaCus	:= cValToChar(SF1->F1_MOEDA)
					Endif
					If ALLTRIM(SD1->D1_TES) $ cTesct .and. !lemerg
						dbSelectArea("SB1")
						dbSetOrder(1)
						If dbSeek( xFilial("SB1")+SD1->D1_COD)
							RECLOCK("SB1",.F.)
							SB1->B1_CUSTD  := nCusto
							SB1->B1_MCUSTD := cMoedaCus
							MSUNLOCK("SB1")
						Endif
					Endif
					SD1->(DBSKIP())
				End
			Endif
		Endif
	Endif
//EndIf

RestArea(_aAreaSd1)
Return

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

Static Function GetSX3Field(cAlias)

Local aAreaSX3 := SX3->(GetArea())

Local aField  := {}

SX3->(DbSetOrder(1))

If SX3->(DbSeek(cAlias))
	
	While SX3->( !Eof() ) .AND. Alltrim(SX3->X3_ARQUIVO) == Alltrim(cAlias)
		
		If SX3->X3_CONTEXT <> "V" .and. !Empty((cAlias)->&(SX3->X3_CAMPO))
			aAdd(aField,{SX3->X3_CAMPO,(cAlias)->&(SX3->X3_CAMPO),Nil})
		Endif
		
		SX3->(DbSkip())
	EndDo
	
	If Len(aField) > 0
		aAdd(aField,{"AUTDELETA","N",Nil})
	Endif
Endif
RestArea(aAreaSx3)
Return(aField)
