#INCLUDE "totvs.ch"
#Include "FWMvcDef.ch"

/*/{Protheus.doc} HL010V02

Rotina para realizar manipulação dos WF após a confirmação da alteração no cadastro de produtos. 

Trechos utilizados do fonte original A010TOk, realizando as devidas alterações.

@type function
@author Guilherme Ricci - Totvs IP Jundiaí
@since 06/08/2018
@version Protheus 12 

@param PARAMIXB[1] - Objeto do cadastro de produtos
@param PARAMIXB[2] - Objeto do Workflow do cadastro de produtos

@return lógico

@see MATA010_PE.prw - Ponto de entrada MVC do cadastro de produtos.
@see WFProduto.prw - Classe do Workflow do cadastro de produtos.
@see A010TOK.prw - Fonte legado anterior a migração para MVC.
/*/

User Function HL010V02

Local lRet		:= .T.
Local cNivelZB1	:= ""

Local oModelSB1 := PARAMIXB[1]
Local oWFProd	:= PARAMIXB[2]

If oModelSB1:GetOperation() == MODEL_OPERATION_UPDATE
	
	If !oWFProd:IsContab() .and. !oWFProd:IsMaster()
		If oWFProd:IsFiscal() .and. FwFldGet("B1_MSBLQL") == "2" // Se for do fiscal e o produto estiver já desbloqueado
			If Aviso('Atencao', 'Este Produto deve entrar no Processo de Worflow?', {'Sim', 'Nao'}) == 2
				Return .T.
			Endif
		Endif
				
		cNivelZB1 := oWFProd:CheckWFUpdate(oModelSB1) // Verifica se é um WF em andamento ou se é um processo novo
		
		If Empty(cNivelZB1) // Não é uma atualização do nivel atual do WF em andamento, portanto encerra o WF e inicia um novo
			If FwFldGet("B1_MSBLQL") == "2"
				If Aviso(	'Atencao', 'Se Confirmar a alteração, o Produto será bloqueado, necessitando realizar os fluxos do WorkFlow para liberação.';
							+'. Deseja continuar?', {'Sim', 'Nao'}) == 2
							
					Return .F.		
					
				Endif
			Endif
			
			// Encerra processo atual
			Processa({|| oWFProd:EndProcess(@oModelSB1)}, "Encerrando processo Workflow atual...")
			
			//Inicia um novo
			Processa({|| oWFProd:NewProcess(@oModelSB1)}, "Iniciando novo processo Workflow...")
		Else
			If FwFldGet("B1_ZZNIVWF") <> "5"
				If Aviso('WorkFlow', 'O Produto '+Alltrim(FwFldGet("B1_COD"))+' - '+Alltrim(FwFldGet("B1_DESC"))+' está em processo de Workflow.'+CRLF+CRLF+'Se confirmar, o próximo fluxo de liberação será iniciado!', {'Confirma', 'Cancela'}) == 1
					Processa({|| oWFProd:UpdateWF(@oModelSB1, cNivelZB1)}, "Atualizando processo Workflow...")
				Else
				 	Return .F.
			 	EndIf
			Else
				Processa({|| oWFProd:UpdateWF(@oModelSB1, cNivelZB1)}, "Atualizando processo Workflow...")
			Endif
		Endif
		
	Endif
	
Endif

Return lRet