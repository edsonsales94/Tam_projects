#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include "TBICONN.ch"

user function MWC_TRANSFERENCIA()

	Prepare Environment Empresa '01' Filial '01'
return

Static Function _GetProp(cProp,cValue)
	Local cRet := ""

	cRet := '"' + Alltrim(cProp) + '":' 
	If ValType(cValue) == "C"
		cRet += '"' + cValue + '"'
	ElseIf ValType(cValue) == "N"
		cRet += Alltrim(Str(cValue))
	Else
		cRet += 'null'
	EndIf
Return cRet

Static Function _Transfere(cdJson)

	Local aAuto := {}
	Local odTransferencia  := Nil
	Local aErros := {}
	local _XdI, nX
	Local lSucesso := .F.
	Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
	Private lMsErroAuto := .f. //necessario a criacao


	lOK := .T.
	cMessage := ""
	//RpcSetType(3)
	//RpcSetEnv('01','01')
	//::SetContentType("application/json")


	If FWJsonDeserialize(cdJson,@odTransferencia)
		ConOut("["+Dtoc(date())+" "+Time()+"] Iniciando integracao da rotina de Tranferencia mensagem:"+odTransferencia:uuid)

		/*If u_FExistMsg(odTransferencia:imei,odTransferencia:uuid) 
			cMessage := "Mensagem já processada"
			Conout(cMessage)
		Else*/
			cDocumento := NextNumero("SD3",4,"D3_DOC",.T.)
			ConfirmSx8()
			aAdd(aAuto,{cDocumento,dDataBase})

			SB1->(dbSetOrder(1))            

			For _XdI := 01 To Len(odTransferencia:Produtos)

				SB1->(dbGoTop())
				SB1->(dbSeek(xFilial('SB1') + odTransferencia:Produtos[_xdI]:produto))

				

				nPos := 0
				If _XdI>1
					cSeek := SB1->B1_COD+odTransferencia:Produtos[_xdI]:local+odTransferencia:Produtos[_xdI]:endereco+;
					odTransferencia:Transferencia:armazemDestino+odTransferencia:Transferencia:Destino+odTransferencia:Produtos[_xdI]:Lote
					For nX :=2 To Len(aAuto)
						If aAuto[nX,1]+aAuto[nX,4]+aAuto[nX,5]+aAuto[nX,9]+aAuto[nX,10]+aAuto[nX,12]==cSeek
							nPos := nX
							Exit
						EndIf
					Next
				EndIf
				//Conout(alltrim(str(nPos)))
				If nPos>0
					Conout("Produto existente no vetor:"+SB1->B1_COD)		
					aAuto[nPos,16]+=odTransferencia:Produtos[_xdI]:Quantidade
					aAuto[nPos,17]+=ConvUm(SB1->B1_COD,odTransferencia:Produtos[_xdI]:Quantidade,0,2)
				Else
					Conout("Produto Novo:"+SB1->B1_COD)
					
					aAdd(aAuto, {SB1->B1_COD,;  //Prod Origem
					SB1->B1_DESC,;  //Descrição
					SB1->B1_UM,;  //Unid Medida
					odTransferencia:Produtos[_xdI]:local,;  //Armazem origem
					odTransferencia:Produtos[_xdI]:endereco,;  //End. Origem
					SB1->B1_COD,;  //Prod Dest.
					SB1->B1_DESC,;  //Descrição
					SB1->B1_UM,;  //Unid Medida
					odTransferencia:Transferencia:armazemDestino,;  //Armazem Destino
					odTransferencia:Transferencia:Destino,;  //End. Destino
					"",;  //Num. Serie
					odTransferencia:Produtos[_xdI]:Lote ,;  //Lote
					"",;  //Sub-Lote
					POSICIONE("SB8",3,XFILIAL('SB8')+SB1->B1_COD+odTransferencia:Produtos[_xdI]:local+odTransferencia:Produtos[_xdI]:Lote,"B8_DTVALID"),;  //Validade
					0,;  //Potencia
					odTransferencia:Produtos[_xdI]:Quantidade,;  //Quantidade
					ConvUm(SB1->B1_COD,odTransferencia:Produtos[_xdI]:Quantidade,0,2),;  //Qtde 2ª UM
					"",;  //Estornado
					"",;  //Seq.
					odTransferencia:Produtos[_xdI]:Lote,;  //Lote Dest. `
					POSICIONE("SB8",3,XFILIAL('SB8')+SB1->B1_COD+odTransferencia:Produtos[_xdI]:local+odTransferencia:Produtos[_xdI]:Lote,"B8_DTVALID"),;  //Valid Dest.
					"",;
					""})  //Documento da transferencia
				EndIf
			Next 

			Conout('Efetuando Chamada Rotina Automatica'+time())
			MSExecAuto({|x,y| mata261(x,y)},aAuto,3)  // inclusão

			If lMsErroAuto 
				cMessage := u_MDResumeErro(MostraErro("\","Error.log"))
				aAdd(aErros,{"400",cMessage})
				conout(cMessage)
				DisarmTransaction()			
			Else
				CONOUT("sucesso!")
				alterarLocali(odTransferencia:Produtos,	odTransferencia:Transferencia:armazemDestino, odTransferencia:Transferencia:Destino,cDocumento,odTransferencia:usuario)
				lSucesso := .T.
				cMessage := "Operação Executada com Sucesso"
				aAdd(aErros,{"200",cMessage})
			EndIf
		//EndIf
	Else
		lOK := .F.
		cMessage := "Falha ao Efetuar a Leitura do JSON"
		conout(cMesagem)
		aAdd(aErros,{"400",cMessage})
	EndIf
//u_fGeraLog(odTransferencia:imei,odTransferencia:uuid,Iif(lSucesso,"1","2"),odTransferencia:usuario,cdJson,"T",cMessage)
ConOut("["+Dtoc(dDataBase)+" "+Time()+"] Concluindo a integracao da rotina de Tranferencia, mensagem:"+odTransferencia:uuid)
Return {aErros,lSucesso}


WSRESTFUL TRANSFERIR DESCRIPTION "Serviço de Transferencia "

WSDATA count AS INTEGER

//WSMETHOD GET DESCRIPTION "Retornar o Batch Solicitada" WSSYNTAX "/BATCH_OP || /BATCH_OP/{cdCodOP}"
WSMETHOD POST DESCRIPTION "Inserir a Transferencia Solicitada" WSSYNTAX "/TRANSFERIR || /TRANSFERIR/"
//WSMETHOD PUT DESCRIPTION "Inseri a Estrutura Solicitada" WSSYNTAX "/ESTRUTURA || /ESTRUTURA/"

End WsRestful


WSMETHOD POST WSSERVICE TRANSFERIR
	Local lPost := .T.
	Local cBody
	// Exemplo de retorno de erro

	// recupera o body da requisição
	/*If ::cFormat <> "json"
	lRetorno := .F.
	SetRestFault(002,"Somente o formato json é permitido") //"Somente o formato json é permitido"
	EndIf
	*/
	cBody := ::GetContent()



	aRetornos := _Transfere(cBody)
	cReturn :=FWJsonSerialize(u_FJsonRetorno(aRetornos[1],aRetornos[2]), .F., .F., .T.)
	::SetResponse(EncodeUtf8(cReturn))
Return lPost


Static Function alterarLocali(odTransfere, cdLocal, cdEndereco,cxDocumento,cxuser)

	Local _XdI,aErros   := {}
	Local lSucesso := .F.


	lOK := .T.

    
	For _XdI := 1 To Len(odTransfere)
			lOK := .T.
			CB0->(dbSetOrder(1))

			If !CB0->(dbSeek(xFilial('CB0') + odTransfere[_XdI]:etiqueta))
				lOK := .F.
				cMessage := "Codigo Etiqueta informado nao encontrado na Base de Dados"
				aAdd(aErros,{"400",cMessage})
			Else
				RecLock("CB0", .F.)
				CB0->CB0_LOCALI := cdEndereco    
				CB0->CB0_LOCAL  := cdLocal    
				MsUnLock() // Confirma e finaliza a operaï¿½ï¿½o
				lOK := .T.
				cMessage := "Operação Executada com Sucesso"
				lSucesso := .T.
			EndIf
	Next 
	
Return {aErros,lSucesso}
