#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include 'tbiconn.ch'

user function ENDERECO_MWC()

//FwAlertInfo("Iniciando","OK")
Prepare Environment Empresa '01' Filial '01'

Conout('Donne')
return
WSRESTFUL ENDERECOS DESCRIPTION "Serviço de Enderecos"

WSDATA Local AS String

WSMETHOD GET DESCRIPTION "Retornar os Enderecos de estoque" WSSYNTAX "/ENDERECOS || /ENDERECOS/{Local}"

End WsRestful

WsMethod Get WSRECEIVE Local WSSERVICE ENDERECOS
	
	Local oEnderecos := JsonObject():New()
	Local lLocal := .F.
	Local lExiste := .T.
	Local nX   := 0
	Private aErros := {}
	cReturn := ""

	/*
	RpcSetType(3)
	ldOk := RpcSetEnv('01','01')
	*/
	//RpcSetType(3)
	//RpcSetEnv('01','01')
	::SetContentType("application/json")
//	conout(ldOk)


	NNR->(dbSetOrder(1))

	If Len(::aURLParms) > 0
		cLocal := ::aURLParms[01]
		lLocal := .T.
	Else
		cLocal := "" 
	EndIf
	ConOUt(cLocal)

	CONOUT("ENDERECO")
	// Faz a verificacao da existencia do armazem  
	If lLocal 

		If !NNR->(DbSeek(xFilial("NNR")+cLocal))
			lExiste := .F.
			aAdd(aErros,{"400","Armazem Não Encontrado"})
			cReturn := FWJsonSerialize(u_FJsonRetorno(aErros), .F., .F., .T.)

			::SetResponse(EncodeUtf8(cReturn))
		EndIf
	EndIf
	
	If lExiste
	
		//Query para listar todos os enderecos com status diferente de bloqueados
		xdTbl := MpSysOpenQUery("Exec GetEndereco '" + cLocal + "', '"+xfilial("SBE")+"'")

		oEnderecos["enderecos"] :={}
		//Percorre todos os enderecos e faz a montagem do array de enderecos
		While !(xdTbl)->(Eof())
			nX++
			Aadd(oEnderecos["enderecos"],JsonObject():New())
			oEnderecos["enderecos"][nX]['codigoArmazem']	:= (xdTbl)->BE_LOCAL
			oEnderecos["enderecos"][nX]['codigo'] 			:= (xdTbl)->BE_LOCALIZ
			oEnderecos["enderecos"][nX]['descricao'] 		:= (xdTbl)->BE_DESCRIC

			(xdTbl)->(dbSkip())
		EndDo
		cReturn := FWJsonSerialize(oEnderecos, .F., .F., .T.)
		::SetResponse(EncodeUtf8(cReturn))
	EndIf
	MemoWrite("C:\Users\Administrator\Desktop\Jsons\"+Dtos(dDataBase)+"T"+StrTran(Time(),':','-')+".json",cReturn)

Return .T.



