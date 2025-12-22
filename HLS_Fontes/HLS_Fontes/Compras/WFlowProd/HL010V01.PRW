#INCLUDE "totvs.ch"
#Include "FWMvcDef.ch"

/*/{Protheus.doc} HL010V01

Rotina para realizar validação se o usuário pode realizar a alteração dos campos alterados no cadastro. 

Trechos utilizados do fonte original A010TOk, realizando as devidas alterações.

@type function
@author Guilherme Ricci - Totvs IP Jundiaí
@since 31/07/2018
@version Protheus 12 

@param PARAMIXB[1] - Objeto do cadastro de produtos a ser validado
@param PARAMIXB[2] - Objeto do Workflow do cadastro de produtos

@return lógico

@see MATA010_PE.prw - Ponto de entrada MVC do cadastro de produtos.
@see WFProduto.prw - Classe do Workflow do cadastro de produtos.
@see A010TOK.prw - Fonte legado anterior a migração para MVC.
/*/

User Function HL010V01

Local aArea  	:= GetArea()
Local aAreaSX3 	:= SX3->(GetArea())
Local lRet 		:= .T.
Local cLog		:= ""
Local nX		:= 0
Local cNivelZB1	:= ""

Local oModelSB1 := PARAMIXB[1]
Local oWFProd	:= PARAMIXB[2]

//Campos que foram Alterados
Local lAltCtb 	:= .F.
Local lAltPcp	:= .F.
Local lAltFis 	:= .F.
Local lAltComp 	:= .F.
Local lAltComPcp := .F. 

// Campos do SB1 que pertencem a cada grupo para alteração
Local aCamposCtb	:= StrToKarr( GetMV("HL_B1CTB",,""), "/" )
Local aCamposPCP	:= StrToKarr( GetMV("HL_B1PCP",,""), "/" )
Local aCamposFis	:= StrToKarr( GetMV("HL_B1FIS",,""), "/" )
Local aCamposCom	:= StrToKarr( GetMV("HL_B1COM",,""), "/" )
Local aCamposComPCP	:= StrToKarr( GetMV("HL_B1CMPCP",,""), "/" )

// Campos do obrigatórios do SB1 por área para geração de log
Local aCmpObgCtb	:= StrToKarr( GetMV("HL_OB1CTB",,""), "/" )
Local aCmpObgPCP	:= StrToKarr( GetMV("HL_OB1PCP",,""), "/" )
Local aCmpObgFis	:= StrToKarr( GetMV("HL_OB1FIS",,""), "/" )
Local aCmpObgCom	:= StrToKarr( GetMV("HL_OB1COM",,""), "/" )

If oWFProd:GetID() <> ""
		
	// Caso esteja bloqueando o produto, encerra WF e nao realiza validacoes
	If SB1->B1_MSBLQL == "2" .And. FwFldGet("B1_MSBLQL") == "1"
		IF SB1->B1_ZZNIVWF <> "6"				
			If Aviso('BLOQUEIO - Em WorkFlow', 'O Produto '+Alltrim(FwFldGet("B1_COD"))+' - '+Alltrim(FwFldGet("B1_DESC"))+' esta aguaradando processos WorkFlow, se continuar os processos atuais serão encerrados.'+CRLF+'Deseja Continuar?', {'Continuar', 'Cancelar'}) == 1
				oWFProd:EndProcess(@oModelSB1)
				Return .T. 
			Endif				
		Else
			Return .T.
		Endif
	Endif
	
	/**************************************************************************
	Verifica se o produto esta em processo de WF, neste ponto pode se
	remover a pergunta, e nao pemritir a alteração de processos em WorkFlow.
	
	Aqui tambem eh verificado se a alteracao eh do nivel atual para atualizar o wf
	***************************************************************************/
	
	If !oWFProd:IsMaster()  //Se for Administrador ou usuario master do cadastro nao Realiza Validacoes
	
		cNivelZB1 := oWFProd:CheckWFUpdate(oModelSB1)
		
		If Empty(cNivelZB1) .and. FwFldGet("B1_ZZNIVWF") < "6"
			If !Aviso('Em WorkFlow', 'O Produto: '+Alltrim(FwFldGet("B1_COD"))+' - '+Alltrim(FwFldGet("B1_DESC"))+' esta aguardando processos WorkFlow, se continuar os processos atuais serão encerrados e um novo fluxo será iniciado.'+CRLF+'Deseja Continuar?', {'Continuar', 'Cancelar'}) == 1
				Return .F.
			Endif
		Endif

		//Filtra direito de Aletracoes do Grupo Compras e PCP
		For nX := 1 To Len(aCamposComPCP)
			If FwFldGet(aCamposComPCP[nX]) <> &("SB1->" + aCamposComPCP[nX])
				If !oWFProd:IsFiscal()			
				   lAltComPcp := .T.
				Endif
			Endif
		Next nX
		
		//Filtra direito de Aletracoes do Grupo Compras
		For nX := 1 To Len(aCamposCom)
			If FwFldGet(aCamposCom[nX]) <> &("SB1->" + aCamposCom[nX])	
				lAltComp := .T.
			Endif
		Next nX
		
		//Filtra direito de Aletracoes do Grupo PCP
		For nX := 1 To Len(aCamposPCP)
			If FwFldGet(aCamposPCP[nX]) <> &("SB1->" + aCamposPCP[nX])	
				lAltPcp := .T.
			Endif
		Next nX
		
		//Filtra direito de Aletracoes do Grupo Fiscal
		For nX := 1 To Len(aCamposFis)
			If FwFldGet(aCamposFis[nX]) <> &("SB1->" + aCamposFis[nX])	
				lAltFis := .T.
			Endif
		Next nX
		
		//Filtra direito de Aletracoes do Grupo Contabilidade
		For nX := 1 To Len(aCamposCtb)
			If FwFldGet(aCamposCtb[nX]) <> &("SB1->" + aCamposCtb[nX])	
				lAltCtb := .T.
			Endif
		Next nX
		
		If lAltCtb
			If !oWFProd:IsContab()
				cLog += " Usuário Sem Permissão para alterar informações Contábeis" +CRLF
				lRet := .F.
			Endif
		Endif
		
		If lAltComp
			If !oWFProd:IsCompras()
				cLog += " Usuário Sem Permissão para alterar informações de Compras" +CRLF
				lRet := .F.
			Endif
		Endif
		
		If lAltFis
			If !oWFProd:IsFiscal()
				cLog += " Usuário Sem Permissão para alterar informações Fiscais"	+CRLF
				lRet := .F.
			Endif
		Endif
		
		If lAltPcp
			If !oWFProd:IsPCP()
				cLog += " Usuário Sem Permissão para alterar informações de PCP" +CRLF
				lRet := .F.
			Endif
		Endif
		
		If lAltComPcp
			If !(oWFProd:IsPCP() .Or. oWFProd:IsCompras())
				cLog += " Usuário Sem Permissão para alterar informações de Compras e/ou PCP" +CRLF
				lRet := .F.
			Endif
		Endif  
	Endif 		
Endif

If oWFProd:IsContab()  // Grupo Contabilidade
	For nX := 1 To Len(aCmpObgCtb)
		If Empty(FwFldGet(aCmpObgCtb[nX]))
			lRet := .F.
			cLog += "Campo: " + Alltrim(Posicione("SX3",2,aCmpObgCtb[nX],"X3_TITULO")) + " - Obrigatório" + CRLF
		Endif
	Next nX
Endif

If oWFProd:IsFiscal() //Grupo Fiscal
	For nX := 1 To Len(aCmpObgFis)
		If Empty(FwFldGet(aCmpObgFis[nX]))
			lRet := .F.
			cLog += "Campo: " + Alltrim(Posicione("SX3",2,aCmpObgFis[nX],"X3_TITULO")) + " - Obrigatório" + CRLF
		Endif
	Next nX
		
Endif

If oWFProd:IsCompras()
	For nX := 1 To Len(aCmpObgCom)
		If Empty(FwFldGet(aCmpObgCom[nX]))
			lRet := .F.
			cLog += "Campo: " + Alltrim(Posicione("SX3",2,aCmpObgCom[nX],"X3_TITULO")) + " - Obrigatório" + CRLF
		Endif
	Next nX
Endif

If oWFProd:IsPCP()
	For nX := 1 To Len(aCmpObgPCP)
		If Empty(FwFldGet(aCmpObgPCP[nX]))
			lRet := .F.
			cLog += "Campo: " + Alltrim(Posicione("SX3",2,aCmpObgPCP[nX],"X3_TITULO")) + " - Obrigatório" + CRLF
		Endif
	Next nX
Endif

If !lRet
	AVISO("Problema", "As seguintes inconsistencias foram encontradas: "+CRLF+CRLF+cLog,{"Ok"},,,,"CRITICA")
Endif

RestArea(aAreaSX3)
RestArea(aArea)

Return lRet