#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include 'tbiconn.ch'

user function MWC_RECURSO()
Prepare Environment Empresa '01' Filial '01'
return                      

WSRESTFUL RECURSO DESCRIPTION "Serviço de Recursos"

WSMETHOD GET DESCRIPTION "Retornar as informações dos Recursos " WSSYNTAX "/RECURSO/ || /RECURSO"  

End WsRestful

WsMethod Get  WSSERVICE RECURSO
	
	Local oRecurso := JsonObject():New()
	Local lExiste  := .T.             
	Local cxRecs   := ""
	Local nX       := 0
	Private aErros := {}
	cReturn := ""

	//RpcSetType(3)
	//ldOk := RpcSetEnv('01','01')
	::SetContentType("application/json")

    //conout(ldOk)
    xdTbl := MpSysOpenQUery("SELECT * FROM "+RetSQLName("SH1")+" WHERE D_E_L_E_T_='' AND H1_FILIAL = '"+XFILIAL("SH1")+"' ")
    oRecurso["recurso"] :={}
    //Percorre todos as condicoes e faz a montagem do array de fornecedores
    While !(xdTbl)->(Eof())
            nX++
            
            Aadd(oRecurso["recurso"],JsonObject():New())
                oRecurso["recurso"][nX]['codigo']	        := Alltrim((xdTbl)->H1_CODIGO)
                oRecurso["recurso"][nX]['descricao']      := Alltrim((xdTbl)->H1_DESCRI)
                oRecurso["recurso"][nX]['CC']      := Alltrim((xdTbl)->H1_CCUSTO)
        (xdTbl)->(dbSkip())
    EndDo

    cReturn := FWJsonSerialize(oRecurso, .F., .F., .T.)
        //ConOut( cReturn)
    ::SetResponse(EncodeUtf8(cReturn))

    MemoWrite("C:\Users\Administrator\Desktop\Jsons\"+Dtos(dDataBase)+"T"+StrTran(Time(),':','-')+".json",cReturn)



Return .T.



