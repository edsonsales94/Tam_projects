#include "protheus.ch"
//Confirmação do documento de entrada
User Function MT100TOK()
	Local lRet := .T.
    Local cEspecie := ALLTRIM(M->F1_ESPECIE)
	Local cTpFrete := ALLTRIM(M->F1_TPFRETE)
	Local cModal   := ALLTRIM(M->F1_MODAL)


	Alert(cEspecie)
	Alert(cTpFrete)
	Alert(cModal)
	IF alltrim(FUNNAME()) = 'MATA103'
	IF cEspecie = "CTE"
		IF cTpFrete = "" .OR. cModal = ""
			Alert("Por favor, Se a Especie for CTE, preencher os campos Tipo Frete e Modadlidade para continuar.")
			lRet := .F.
		EndIf
	EndIf	
	EndIf
	/*IF alltrim(FUNNAME()) = 'MATA121' .or. alltrim(FUNNAME()) = 'MATA103' 
		U_EXCPROV()
	ENDIF */



Return lRet

User Function EXCPROV()
	Local aArray := {}
	Local nCont  := 0
	Local cChar     := ","
	Local _cAux     := ""
	Local nP        := 0
	Local QtdPed    := 0
	Local aPedAux   := array(200) 
	Local nLinha    := 0
	Local I         := 0
	Local lOK       := .T.
	Local cPedido   := aCols[n,ASCAN(aHeader,{|x| ALLTRIM(x[2]) == "D1_PEDIDO" })]
	Local cEmp      := cEmpAnt
	
	DbSelectArea("SE4") 
	DbSetOrder(1)
	DbSeek(xFilial("SE4")+CCONDICAO)

	_cAux := ALLTRIM(SE4->E4_COND)     

	If AllTrim(cPedido) != ""
		For I := 1 To 16 Step 1
			If SubStr(_cAux,nP,AT(cChar,_cAux)-1) != ""
				nCont := nCont + 1
			EndIf
			nP := AT(cChar,_cAux) + 1
			_cAux := SubStr(_cAux,nP)
			nP := 1
		Next

		nCont := nCont + 1

		PRIVATE lMsErroAuto := .F.

		//Verifica Quantos Pedidos Existem para esse Documento de Entrada
		For nLinha := 1 to Len(aCols)
			If aPedAux[QtdPed+1] != aCols[nLinha,ASCAN(aHeader,{|x| ALLTRIM(x[2]) == "D1_PEDIDO" })]
				QtdPed := QtdPed+1
				aPedAux[QtdPed] := aCols[nLinha,ASCAN(aHeader,{|x| ALLTRIM(x[2]) == "D1_PEDIDO" })]
			EndIf
		Next nLinha

		nLinha := 0

		//Controla o Loop por Pedido
		For nLinha := 1 to QtdPed
			// Verifica somente linhas nao deletadas
			If !aCols[nLinha][Len(aHeader)+1]    
				cPedido   := aPedAux[nLinha]

				//Controla o numero de parcelas
				For I := 1 To nCont Step 1      
					If cEmp == "10"
						cParcela := PadR(cValToChar(I),3)
					else
						cParcela := Trim(PadR(cValToChar(I),3))
					EndIf
					
					DbSelectArea("SE2") 
					DbSetOrder(1)
					If DbSeek(xFilial("SE2")+"CMP"+PadR(cPedido,9)+cParcela+"PR") //Exclusão deve ter o registro SE2 posicionado

						aArray := { { "E2_PREFIXO" , SE2->E2_PREFIXO , NIL },;
						{ "E2_NUM"     , SE2->E2_NUM     , NIL },;
						{ "E2_PARCELA" , SE2->E2_PARCELA , NIL },;
						{ "E2_TIPO"    , SE2->E2_TIPO    , NIL } }

						MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 5)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

						If lMsErroAuto
							MostraErro()
						EndIf
					Else
						lOK := .F.
					EndIf
				Next
			Endif
			I := 0 
		Next nLinha	
		If lOK
			Alert("Exclusão do(s) Título(s) Provisório(s) realizada com sucesso!")
		Endif

	EndIf

Return
