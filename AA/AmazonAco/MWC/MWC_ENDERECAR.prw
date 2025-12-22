#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include 'tbiconn.ch'

user function MWC_ENDERECAR()

	//FwAlertInfo("Iniciando","OK")
	//Prepare Environment Empresa '01' Filial '01'

	MemoWrite("C:\Users\Administrator\Desktop\Jsons\"+Dtos(dDataBase)+"T"+StrTran(Time(),':','-')+".json",_GetSEnderecoJson())
	Endereca()
	//FwAlertInfo("Donne","Atencao")
	Conout('Donne')
return

Static Function SEndereco(cdProduto,cdLocal,cdEndereco)

	Local lOK := .T.
	Local cdJson := ""

	Default cdLocal    := ""
	Default cdEndereco := ""
	Default cdProduto  := ""

	cdLocal    := Padr(cdLocal,TamSx3('BF_LOCAL')[01])
	cdEndereco := Padr(cdLocal,TamSx3('BF_LOCALIZ')[01])
	cdProduto  := Padr(cdLocal,TamSx3('BF_PRODUTO')[01])


	If lOK

		xdTbl := MpSysOpenQUery("Exec GetSaldoEndereco @cdProduto = '" + cdProduto + "', @cdEndereco = '" + cdEndereco + "',@cdLocal = '" + cdLocal + "'")
		cdJson += "["
		//nItem := 01
		//conout('Item' + StrZero(nItem,4))
		While !(xdTbl)->(Eof())
			If Len(cdJson) > 1
				cdJson += ","
			EndIf

			cdJson += "{"
			cdJson += '"Filial":"' + SBF->BF_FILIAL + '",'
			cdJson += '"Produto":"' + SBF->BF_PRODUTO + '",'
			cdJson += '"Armazen":"' + SBF->BF_LOCAL + '",'
			cdJson += '"Endereco":"' + SBF->BF_LOCALIZ + '",'
			cdJson += '"Lote":"' + SBF->BF_LOTECTL + '",'
			cdJson += '"Saldo":' + Alltrim(Str(SBF->BF_QUANT - SBF->BF_EMPENHO - SBF->BF_QEMPPRE)) + ','
			cdJson += '"Empenho":' + Alltrim(Str(SBF->BF_EMPENHO + SBF->BF_QEMPPRE)) + ''
			//cdJson += '"":"' + + '"'
			cdJson += "}"	       

			(xdTbl)->(dbSkip())
			//nItem++
			//conout('Item' + StrZero(nItem,4))
		EndDo
		cdJson += "]"
	EndIf

Return {lOk,cdJson}

Static Function _GetSEnderecarJson(cdDocumento,cdProduto,cdLote)

	Default cdDocumento = ""
	Default cdProduto   = ""

	_xdReturn := ""
	xdTbl := MpSysOpenQUery("Exec GetSEnderecar @cdDocumento='" + cdDocumento + "', @cdProduto = '" + cdProduto + "', @cdLote ='"+cdLote+"' ")
	_xdReturn += "["
	While !(xdTbl)->(Eof())

		If Len(_xdReturn) > 1
			_xdReturn += ","
		EndIf

		_xdReturn += "{"
		_xdReturn += '"Filial":"' + (xdTbl)->DA_FILIAL + '",'
		_xdReturn += '"Produto":"' + Alltrim(Alltrim((xdTbl)->DA_PRODUTO)) + '",'
		_xdReturn += '"Descricao":"' +  STRTRAN(AllTrim(EnCodeUtf8(NoAcento(Posicione("SB1",1,xFilial("SB1")+(xdTbl)->DA_PRODUTO,"B1_DESC")))),'"','') + '",'
		_xdReturn += '"Saldo":' + Alltrim(Str((xdTbl)->DA_SALDO)) + ","
		_xdReturn += '"QtOriginal":' + Alltrim(Str((xdTbl)->DA_QTDORI)) + ','
		_xdReturn += '"Lote":"' + Alltrim((xdTbl)->DA_LOTECTL) + '",'
		_xdReturn += '"Local":"' + Alltrim((xdTbl)->DA_LOCAL) + '",'
		_xdReturn += '"Serie":"' + (xdTbl)->DA_SERIE + '",' 
		_xdReturn += '"Documento":"' + (xdTbl)->DA_DOC + '",'
		_xdReturn += '"UM":"' + (xdTbl)->B1_UM + '",' 
		_xdReturn += '"Tipo":"' + (xdTbl)->B1_TIPO + '",'
		_xdReturn += '"NumSeq":"' + (xdTbl)->DA_NUMSEQ + '"'
		_xdReturn += "}"

		(xdTbl)->(dbSkip())
	EndDo

	_xdReturn += "]"
Return _xdReturn

Static Function Endereca(cdJson,cdDocumento,cdEndereco)	

	Local odEnderecar
	Local aCabSDA    	:= {}
	Local aItSDB     	:= {}
	Local _aItensSDB	:= {} 
	Local aErros 		:= {}
	Local lSucesso 		:= .F.
	Local cUUID 		:= ""
	Local cImei			:= ""
	Local CUSERDISP		:= ""
	local _xdReturn := ""
	LOCAL _XdI, _YdI, _XqTYE  := 0

	Default cdJson := ''

	lOK := .T.
	conoUt(cdJson)
	cMessage := ""
	If FWJsonDeserialize(cdJson,@odEnderecar)
			For _XdI := 01 To Len(odEnderecar:Etiquetas)
				lOK := .T.
				Conout("Esta no for")
				Private	lMsErroAuto := .F.
				cdProduto 	:= PAdr(odEnderecar:Etiquetas[_XdI]:Produto  , TamSx3("DA_PRODUTO")[01])
				cdLocal   	:= PAdr(odEnderecar:Etiquetas[_XdI]:Armazem  , TamSx3("DA_LOCAL")[01])
				cdNumSeq  	:= PAdr(odEnderecar:Etiquetas[_XdI]:NumSeq   , TamSx3("DA_NUMSEQ")[01])
				cdDoc     	:= PAdr(odEnderecar:Etiquetas[_XdI]:Documento, TamSx3("DA_DOC")[01])
				cdSerie   	:= PAdr(odEnderecar:Etiquetas[_XdI]:Serie    , TamSx3("DA_SERIE")[01])
				cdEndereco	:= PAdr(odEnderecar:Etiquetas[_XdI]:Endereco , TamSx3("DB_LOCALIZ")[01])
				cImei 		:= odEnderecar:imei
				cUUID		:= odEnderecar:uuid
				CUSERDISP	:= odEnderecar:usuario
				SBE->(dbSetOrder(1))
				If !SBE->(dbSeek(xFilial('SBE') + cdLocal + cdEndereco))
					lOK := .F.
					cMessage := "Endereco informado nao encontrado na Base de Dados"
					aAdd(aErros,{"400",cMessage})
					Return {aErros,lSucesso}
				EndIf

				//Cabeçalho com a informação do item e NumSeq que sera endereçado.
				SDA->(dbSetOrder(1))
				SDA->(DBGOTOP())
				If lOk
					lSDA := SDA->(dbSeek(alltrim(xFilial('SDA') + cdProduto + cdLocal + cdNumseq + cdDoc + cdSerie) ))
					
					qout(lSDA)
					qout(RetSQLName("SDA") )
					qout(alltrim(xFilial('SDA') + cdProduto + cdLocal + cdNumseq + cdDoc + cdSerie) )

					If !lSDA
						lOK := .F.
						cMessage := " Registro a Enderecar Nao Encontrado"
						aAdd(aErros,{"400",cMessage})
						Return {aErros,lSucesso}
					EndIf

					If lOK .And. SDA->DA_SALDO < odEnderecar:Etiquetas[_XdI]:Quantidade
						lOK := .F.
						cONOUT(str(SDA->DA_SALDO))
						cONOUT(str(odEnderecar:Etiquetas[_XdI]:Quantidade))
						cMessage := "Saldo para Enderecamento inferior a quantidade solicitada"
						aAdd(aErros,{"400",cMessage})
						Return {aErros,lSucesso}
					EndIf
				EndIf

				If lOk
					aAreaSDA := SDA->(GetArea())
					aAreaSDB := SDB->(GetArea())
					aCabSDA := {;
					{"DA_PRODUTO" ,cdProduto,Nil},;	  
					{"DA_NUMSEQ"  ,cdNumSeq,Nil}}
					_aItensSDB := {}
					SDB->(dbSetOrder(1))
					SDB->(dbSeek(xFilial('SDB') + cdProduto +  cdLocal + cdNumSeq))

					_xdItem := 1
					While SDB->DB_FILIAL + SDB->DB_PRODUTO + SDB->DB_LOCAL + SDB->DB_NUMSEQ == xFilial('SDB') + cdProduto + cdLocal + cdNumSeq
						_xdItem := Val(SDB->DB_ITEM) + 01
						SDB->(dbSkip())
					EndDo
					RestArea(aAreaSDB)

					//qout(odEnderecar:Etiquetas[_XdI]:quantidade)

					//_XqTYE := odEnderecar:Etiquetas[_XdI]:quantidade
				
					//Dados do item que será endereçado
					aItSDB := {{"DB_ITEM"	  ,StrZero(_xdItem,4)  ,Nil},;                   
					{"DB_ESTORNO"  ," "	      ,Nil},;                   
					{"DB_LOCALIZ"  ,cdEndereco ,Nil},;                   
					{"DB_DATA"	  ,dDataBase  ,Nil},;                   
					{"DB_QUANT"    ,odEnderecar:Etiquetas[_XdI]:quantidade,Nil}}       

					aadd(_aItensSDB,aitSDB)
					//Executa o endereçamento do item
					MSExecAuto({|x,y,z| mata265(x,y,z)},aCabSDA, _aItensSDB,3) //Distribui

					If lMsErroAuto 
						
						cMessage := u_MDResumeErro(MostraErro("\","Error.log"))
						aAdd(aErros,{"400",cMessage})
						DisarmTransaction()			
					Else
						alterarLocali( odEnderecar:Etiquetas[_XdI], cdEndereco)
						lOK := .T.
						cMessage := "Operação Executada com Sucesso"
						aAdd(aErros,{"200",cMessage})
						lSucesso := .T.
					EndIf

					RestArea(aAreaSDA)
					RestArea(aAreaSDB)

				EndIf
			Next _XdI
		//EndIf
	Else
		lOK := .F.
		cMessage := "Falha ao Efetuar a Leitura do JSON"
		aAdd(aErros,{"400",cMessage})
	EndIf
	//u_fGeraLog(cImei,cUUID,Iif(lSucesso,"1","2"),CUSERDISP,cdJson,"E",cMessage)
CONOUT(cMessage)
Return {aErros,lSucesso}

WSRESTFUL SENDERECO DESCRIPTION "Serviço de Saldos"

WSDATA count     AS Integer
WSDATA Documento AS String
WSDATA Produto   AS String

WSMETHOD GET DESCRIPTION "Retornar os Itens em Saldo" WSSYNTAX "/SENDERECO || /SENDERECO/{Produto}/{Armazen}/"

End WsRestful

WSRESTFUL ENDERECAR DESCRIPTION "Serviço de Enderecamento"

WSDATA count     AS Integer
WSDATA Documento AS String
WSDATA Produto   AS String
WSDATA Lote   AS String

WSMETHOD GET DESCRIPTION "Retornar os Itens a Endereçar" WSSYNTAX "/ENDERECAR || /ENDERECAR/{Documento}/{Lote}/{Produto}"
//WSMETHOD GET DESCRIPTION "Retornar os Itens a Endereçar" WSSYNTAX "/ENDCOD || /ENDCOD/{cdProduto}"
WSMETHOD POST DESCRIPTION "Efetua Enderecamento de um Item" WSSYNTAX "/ENDERECAR/{Documento}/{Endereco} "
//WSMETHOD PUT DESCRIPTION "Inseri a Estrutura Solicitada" WSSYNTAX "/ESTRUTURA || /ESTRUTURA/"

End WsRestful


WsMethod Get WSRECEIVE Documento,Produto,Lote WSSERVICE ENDERECAR
	Local cdProduto :=""
	Local  cdDocumento := ""
	Local cdLote := ""
	//::SetContentType("application/json")
	//RpcSetType(3)
	//RpcSetEnv('01','01')
	::SetContentType("application/json")

	If Len(::aURLParms) > 0
		cdDocumento := ::aURLParms[01]
	// Else
	// 	cdDocumento := If(ValType(Documento)!="C","",Documento)
	EndIf
	
	If Len(::aURLParms) > 1
		cdLote := ::aURLParms[02]
	// Else
	// 	cdLote := If(ValType(Lote)!="C","",Lote)
	EndIf		

	IF Len(::aURLParms) > 2
			cdProduto := ::aURLParms[03]
	EndIf
	//cdProduto :=""


	::SetResponse(EncodeUtf8(_GetSEnderecarJson(cdDocumento,cdProduto,cdLote)) )
Return .T.

WSMETHOD POST WSRECEIVE Documento WSSERVICE ENDERECAR

	Local lPost := .T. 
	Local cBody
	Private cdDocumento := ""
	Private cdEndereco := ""
	// Exemplo de retorno de erro

	// recupera o body da requisição
	/*If ::cFormat <> "json"
	lRetorno := .F.
	SetRestFault(002,"Somente o formato json é permitido") //"Somente o formato json é permitido"
	EndIf
	*/
	//RpcSetType(3)
	//RpcSetEnv('01','01')
	::SetContentType("application/json")

	If Len(::aURLParms) > 0
		cdDocumento := ::aURLParms[01]
	Else
		cdDocumento := If(ValType(Documento)!="C","",Documento)
	EndIf

	cBody := ::GetContent()
	cONOUT(cdDocumento)
	cONOUT(cdEndereco)
	cONOUT(cBody)
	
	aRetornos := Endereca(cBody,cdDocumento)

	cReturn := FWJsonSerialize(u_FJsonRetorno(aRetornos[1],aRetornos[2]), .F., .F., .T.)
	::SetResponse(EncodeUtf8(cReturn))


Return lPost



Static Function alterarLocali(odEnderecar, cdEndereco)

	Local _XdI,aErros := {}
	Local lSucesso := .F.

	lOK := .T.
    
	///For _XdI := 1 To Len(odEnderecar)
	   //	oEtiquetas := odEnderecar[_XdI]:etiquetas
		//For _XdJ :=1 To Len(oEtiquetas)
			lOK := .T.
			CB0->(dbSetOrder(1))
			//QOUT("FOR2")
			If !CB0->(dbSeek(xFilial('CB0') + odEnderecar:etiqueta))
				lOK := .F.
				cMessage := "Codigo Etiqueta informado nao encontrado na Base de Dados"
				aAdd(aErros,{"400",cMessage})
			Else
				//	QOUT(cdEndereco)
				//		QOUT(odEnderecar:etiqueta)
				RecLock("CB0", .F.)
				CB0->CB0_LOCALI := cdEndereco
				MsUnLock() // Confirma e finaliza a operação

				lOK := .T.

				cMessage := "Operação Executada com Sucesso"
				aAdd(aErros,{"200",cMessage})
				lSucesso := .T.
			EndIf
		//Next _XdJ 
	//Next _XdI

	//CONOUT(cMessage)
Return {aErros,lSucesso}




WsMethod Get WSSERVICE SENDERECO
	
	Local oEnderecos := JsonObject():New()
	Local nX   := 0
	Local cProduto := ""
    Local cQry :=""
    Local cEndereco := ""

	If Len(::aURLParms) > 0
		cEndereco := ::aURLParms[01]
	Else
		cEndereco := "" 
	EndIf

    If Len(::aURLParms) > 1
		cProduto := ::aURLParms[02]
	Else
		cProduto := "" 
	EndIf

	cReturn := ""

	//RpcSetType(3)
	//ldOk := RpcSetEnv('01','01')
	::SetContentType("application/json")
	conout(xFilial("SBF"))
	conout(cfilant)

	//Query para listar todos os relacionamentos produto x fornecedor
	cQry += " SELECT BE_LOCALIZ,BE_LOCAL,BE_DESCRIC,BF_PRODUTO,BF_LOTECTL,BF_QUANT FROM "+RetSQLName("SBE")+" (NOLOCK) SBE "
    cQry += " INNER JOIN "+RetSQLName("SBF")+" (NOLOCK) SBF "
    cQry += " ON  SBF.D_E_L_E_T_='' AND SBF.BF_FILIAL = '"+xFilial("SBF")+ "'"
    cQry += " AND SBF.BF_LOCAL=SBE.BE_LOCAL "
    cQry += " AND SBF.BF_LOCALIZ=SBE.BE_LOCALIZ "
    cQry += " WHERE SBE.D_E_L_E_T_='' AND BE_FILIAL = '"+XFILIAL("SBE")+"'"
    If !Empty(cEndereco)
        cQry += " AND SBE.BE_LOCALIZ='"+cEndereco+"' "
    EndIf
    If !Empty(cProduto)
        cQry += " AND SBF.BF_PRODUTO='"+cProduto+"' "
    EndIf

	qout(cQry)
    
    
    xdTbl :=MpSysOpenQUery(cQry)
	oEnderecos["enderecos"] :={}
	//Percorre todos os produtos
	While !(xdTbl)->(Eof())
		nX++
		Aadd(oEnderecos["enderecos"],JsonObject():New())
		
		oEnderecos["enderecos"][nX]['codigo']	:= Alltrim((xdTbl)->BE_LOCALIZ)
		oEnderecos["enderecos"][nX]['local']	    := Alltrim((xdTbl)->BE_LOCAL)
        oEnderecos["enderecos"][nX]['descricao']	:= Alltrim((xdTbl)->BE_DESCRIC)
		
		cSeek :=(xdTbl)->BE_LOCAL+(xdTbl)->BE_LOCALIZ 
		oEnderecos["enderecos"][nX]['produtos'] := {}
		//percorre todos os fornecedores que ja ganharam p aquele produto
		While  cSeek ==(xdTbl)->BE_LOCAL+(xdTbl)->BE_LOCALIZ
			Aadd(oEnderecos["enderecos"][nX]['produtos'],JsonObject():New())
			Atail(oEnderecos["enderecos"][nX]['produtos'])['codigo']	:= (xdTbl)->BF_PRODUTO
			Atail(oEnderecos["enderecos"][nX]['produtos'])['descricao']	:= Posicione("SB1",1,xFilial("SB1")+(xdTbl)->BF_PRODUTO,"B1_DESC")
			Atail(oEnderecos["enderecos"][nX]['produtos'])['lote']	    := Alltrim((xdTbl)->BF_LOTECTL)
			Atail(oEnderecos["enderecos"][nX]['produtos'])['quantidade']:= (xdTbl)->BF_QUANT
			
			(xdTbl)->(dbSkip())
		EndDo
	EndDo
	cReturn := FWJsonSerialize(oEnderecos, .F., .F., .T.)
	//ConOut( cReturn)
	::SetResponse(EncodeUtf8(cReturn))

	MemoWrite("C:\Users\Administrator\Desktop\Jsons\"+Dtos(dDataBase)+"T"+StrTran(Time(),':','-')+".json",cReturn)

Return .T.
