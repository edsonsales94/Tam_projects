#Include "Protheus.ch"
#Include "FWMvcDef.ch"

/*/{Protheus.doc} MATA010_PE

Ponto de entrada do cadastro do produto em MVC. User function ITEM (não alterar)

@type function
@author Guilherme Ricci - Totvs IP Jundiaí
@since 31/07/2018
@version Protheus 12 
@return lógico

/*/

User Function ITEM()

	Local aParam 	:= ParamIXB
	Local lRet 		:= .T.
	Local oObj 		
	Local cIdPonto 	:= ""
	Local cIdModel 	:= ""
	Local lIsGrid 	:= .F.
	
	Local lUtilizaWF	:= GetMv( "HL_WFPROD",,.F. ) //Indica se Utiliza o WF de Produtos
	Local oWfProd		:= Iif(lUtilizaWF, WFProduto():New(),Nil)

	If aParam <> Nil

		oObj 		:= aParam[1]
		cIdPonto 	:= aParam[2]
		cIdModel 	:= aParam[3]
		lIsGrid 	:= Len(aParam) > 3

		If Type("lTOK") == "U"
			Public lTOK	:= .F.
		EndIf
		
		If oObj:cID == "SB1MASTER"
			
			If oObj:GetOperation() == MODEL_OPERATION_UPDATE .AND. FWFLDGET("B1_COD") <> SB1->B1_COD // PE padrao esta perdendo posicionamento, portanto força novamente
				Posicione("SB5",1,FwXFilial("SB5") + FWFLDGET("B1_COD"),"")
				Posicione("SB1",1,FwXFilial("SB1") + FWFLDGET("B1_COD"),"")
			Endif
					
			If cIdPonto == "FORMPOS" // Após confirmação da tela no botão OK
							
				If lUtilizaWF
				
					Begin Transaction
				
					If oObj:GetOperation() == MODEL_OPERATION_UPDATE
						oWFProd:SetID(FwFldGet("B1_ZZIDWF"))
					Endif
																											
					If ExistBlock("HL010V01") // Valida se usuário pode alterar os campos da sua área.  	
					
						lRet := ExecBlock("HL010V01", .F., .F., {@oObj, @oWFProd})
						
					Endif
						
					If lRet
						If oObj:GetOperation() == MODEL_OPERATION_INSERT
							If Aviso(	'Atencao', 'Se confirmar a inclusão, o Produto será BLOQUEADO, iniciando os fluxos do WorkFlow para liberação.';
										+CRLF+CRLF+'Deseja continuar?', {'Sim', 'Nao'}) == 1
								
									oWFProd:NewProcess(@oObj)
								
							Else
							
								lRet := .F.
								
							Endif
							
						Elseif oObj:GetOperation() == MODEL_OPERATION_UPDATE
							
							If ExistBlock("HL010V02") // Realiza as verificações após a confirmação da alteração.  	
					
								lRet := ExecBlock("HL010V02", .F., .F., {@oObj, @oWFProd})
								
							Endif
							
							If lRet
								If oWFProd:CheckUnlockRules(oObj)
									oWFProd:UnlockProduct(@oObj)
								Endif
							Endif
							
						Endif
					Endif
					
					End Transaction
					
				Endif
				
				lTOK := lRet								
				
				
			//ElseIf cIdPonto == "FORMCOMMITTTSPOS" // Depois de efetivar a gravação do produto. 

				
			Endif
			
		Endif
		
	EndIf

Return lRet