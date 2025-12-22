#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include 'tbiconn.ch'

user function MWC_ETQSALDO()

//FwAlertInfo("Iniciando","OK")
//Prepare Environment Empresa '01' Filial '01'

Conout('Donne')
return

WSRESTFUL ETQSALDO DESCRIPTION "Serviço de Saldo por Etiqueta"

WSDATA Local AS String

WSMETHOD GET DESCRIPTION "Retornar os Enderecos de estoque" WSSYNTAX "/ETQSALDO || /ETQSALDO/{Local}"

End WsRestful

WsMethod Get WSRECEIVE Local WSSERVICE ETQSALDO
	
	Local oSaldos := JsonObject():New()
	Local lEtqueta := .F.
	Local lExiste := .T.
	Local nX   := 0
	Private aErros := {}
	cReturn := ""

	::SetContentType("application/json")

	If Len(::aURLParms) > 0
		cEtqueta  := ::aURLParms[01]
		lEtqueta  := .T.
	Else
		cEtqueta  := "" 
	EndIf
	ConOUt(cEtqueta)

	
	If lEtqueta
	
		//Query para listar todos os enderecos com status diferente de bloqueados
		xdTbl := MpSysOpenQUery("Exec [GetEtqSld] '" + cEtqueta + "', '"+xfilial("SBF")+"'")
		dbSelectArea(xdTbl)

		oSaldos["saldo"] :={}
		//Percorre todos os enderecos e faz a montagem do array de enderecos
		While !(xdTbl)->(Eof())
			nX++
			Aadd(oSaldos["saldo"],JsonObject():New())
			oSaldos["saldo"][nX]['Filial']	 := (xdTbl)->BF_FILIAL
			oSaldos["saldo"][nX]['Produto']  := (xdTbl)->BF_PRODUTO
			oSaldos["saldo"][nX]['Armazen']  := (xdTbl)->BF_LOCAL
            oSaldos["saldo"][nX]['Endereco'] := (xdTbl)->BF_LOCALIZ
			oSaldos["saldo"][nX]['Lote']     := (xdTbl)->BF_LOTECTL
			oSaldos["saldo"][nX]['Saldo']    := (xdTbl)->BF_SALDO
            oSaldos["saldo"][nX]['Empenho']  := (xdTbl)->BF_EMPS

			(xdTbl)->(dbSkip())
		EndDo
		cReturn := FWJsonSerialize(oSaldos, .F., .F., .T.)
		::SetResponse(EncodeUtf8(cReturn))
	EndIf
	//MemoWrite("C:\Users\Administrator\Desktop\Jsons\"+Dtos(dDataBase)+"T"+StrTran(Time(),':','-')+".json",cReturn)

Return .T.

