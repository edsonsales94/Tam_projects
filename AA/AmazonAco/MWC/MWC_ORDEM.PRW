#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include 'tbiconn.ch'

user function MWC_ORDEM()
Prepare Environment Empresa '01' Filial '01'
return                      

WSRESTFUL ORDEM DESCRIPTION "Serviço de OPS"

WSDATA cxOrdem AS String

WSMETHOD GET DESCRIPTION "Retornar as informações das ORDENS" WSSYNTAX "/ORDEM/{cxOrdem} || /ORDEM/{cxOrdem}"  

End WsRestful

WsMethod Get WSRECEIVE cxOrdem WSSERVICE ORDEM
	
	Local oOrdem   := JsonObject():New()
	Local lExiste  := .T.             
	Local lLabel   := .F.
	Local cxOP     := ""
	Local nX       := 0
	Private aErros := {}
	cReturn := ""

	//RpcSetType(3)
	//ldOk := RpcSetEnv('01','01')
	::SetContentType("application/json")

	If Len(::aURLParms) > 0
		cxOP   := ::aURLParms[01]
		lLabel := .T.
	Else
		cxOP   := "" 
	EndIf        
	
	SC2->(dbSetOrder(1))

	If lLabel  

		If !SC2->(DbSeek(xFilial("SC2")+cxOP))
			lExiste := .F.
			aAdd(aErros,{"400","Ordem invalida"})
			cReturn := FWJsonSerialize(u_FJsonRetorno(aErros), .F., .F., .T.)

			::SetResponse(EncodeUtf8(cReturn))
		EndIf

        if SC2->C2_QUANT-SC2->C2_QUJE	<= 0
            lExiste := .F.
            aAdd(aErros,{"400","Ordem sem saldo"})
			cReturn := FWJsonSerialize(u_FJsonRetorno(aErros), .F., .F., .T.)

			::SetResponse(EncodeUtf8(cReturn))
        endif    
	EndIf
	
	If lExiste
            SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
			oOrdem['ordem' ] 	:= SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
			oOrdem['produto' ] 	:= SC2->C2_PRODUTO
			oOrdem['saldo' ] 	:= SC2->C2_QUANT-SC2->C2_QUJE	
            oOrdem['um' ] 	    := SB1->B1_UM	
            oOrdem['tipo' ] 	:= SB1->B1_TIPO
            oOrdem['desc' ] 	:= SB1->B1_DESC
			oOrdem['necessidade'] := SC2->C2_QUANT
			oOrdem['local' ] 	:=  AllTrim( GetMv("MV_LOCPROC") )
			oOrdem['endereco' ] := "PRODUCAO"
		
			//conout(ldOk)
			xdTbl := MpSysOpenQUery("SELECT * FROM "+RetSQLName("SD4")+" SD4 INNER JOIN "+RetSQLName("SB1")+" SB1 ON B1_COD = D4_COD AND SB1.D_E_L_E_T_ = ''  WHERE SD4.D_E_L_E_T_='' AND D4_OP = '"+cxOP+"'AND D4_COD NOT LIKE ('MOD%') ")
			oOrdem["itens"] :={}
			//Percorre todos as condicoes e faz a montagem do array de fornecedores
			While !(xdTbl)->(Eof())
					nX++
					Aadd(oOrdem["itens"],JsonObject():New())

						oOrdem["itens"][nX]['codigo']	     := Alltrim((xdTbl)->D4_COD)
						oOrdem["itens"][nX]['descricao']      := Alltrim((xdTbl)->B1_DESC)
						oOrdem["itens"][nX]['trt']            := Alltrim((xdTbl)->D4_TRT)
						oOrdem["itens"][nX]['UM']             := Alltrim((xdTbl)->B1_UM)
						oOrdem["itens"][nX]['quantidade']     := (xdTbl)->D4_QUANT
				(xdTbl)->(dbSkip())
			EndDo

			
		cReturn := FWJsonSerialize(oOrdem, .F., .F., .T.)
		::SetResponse(EncodeUtf8(cReturn))
	EndIf
	MemoWrite("C:\Users\Administrator\Desktop\Jsons\"+Dtos(dDataBase)+"T"+StrTran(Time(),':','-')+".json",cReturn)

Return .T.



