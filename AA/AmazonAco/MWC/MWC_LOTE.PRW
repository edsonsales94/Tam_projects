#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include 'tbiconn.ch'

user function MWC_LOTE()
Prepare Environment Empresa '01' Filial '01'
return                      

WSRESTFUL LOTE DESCRIPTION "Serviço de Etiquetas"

WSDATA Label AS String

WSMETHOD GET DESCRIPTION "Retornar as informações de etiqueta" WSSYNTAX "/LOTE/{Label} || /LOTE/{Label}"  

End WsRestful

WsMethod Get WSRECEIVE Label WSSERVICE LOTE
	
	Local oLote     := JsonObject():New()
	Local CXLOTS    := ""
	Local nX        := 0
	Local _cArmTran := ""
	lOCAL lcontinua := .t.
	Private aErros := {}
	cReturn := ""

	//RpcSetType(3)
	//ldOk := RpcSetEnv('01','01')
	::SetContentType("application/json")
	//CONOUT(label)
	//ChkFile("SZN")
	_cArmTran  := AllTrim( GetMv("MV_XARMTRA") )


	If Len(::aURLParms) > 0
		CXLOTS := ::aURLParms[01]
	Else
		CXLOTS := "" 
	EndIf        
	
	SZZ->(DbSetOrder(2))
	qout(CXLOTS)

    If !SZZ->(DbSeek(xFilial("SZZ")+CXLOTS))
        aAdd(aErros,{"400","Lote invalido"})
        cReturn := FWJsonSerialize(u_FJsonRetorno(aErros), .F., .F., .T.)
        ::SetResponse(EncodeUtf8(cReturn))
		lcontinua := .F.

    Else
        SD1->(DbSetOrder(2))
        If !SD1->(DbSeek(xFilial("SD1")+SZZ->ZZ_COD+SZZ->ZZ_DOC+SZZ->ZZ_SERIE)) .AND. lcontinua
            aAdd(aErros,{"400","NF invalida"})
			lcontinua := .F.
            cReturn := FWJsonSerialize(u_FJsonRetorno(aErros), .F., .F., .T.)
            ::SetResponse(EncodeUtf8(cReturn))
			
		ENDIF
		
		If  !SB2->(dbSeek(XFILIAL("SB2")+SD1->D1_COD+_cArmTran)) .AND. lcontinua
			lcontinua := .F.
 			aAdd(aErros,{"400","Não existe referência para esse produto no saldo em estoque !"})
            cReturn := FWJsonSerialize(u_FJsonRetorno(aErros), .F., .F., .T.)
            ::SetResponse(EncodeUtf8(cReturn))

		ENDIF

		cChave := SD1->D1_XPACLIS+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM
		
		
		If !SZW->(dbSeek(XFILIAL("SZW")+cChave)) .AND. lcontinua
			lcontinua := .F.
            aAdd(aErros,{"400","O Pack-List informado não foi encontrado!"})
            cReturn := FWJsonSerialize(u_FJsonRetorno(aErros), .F., .F., .T.)
            ::SetResponse(EncodeUtf8(cReturn))
		ENDIF
	
		nSaldo := SB2->(B2_QATU - If( B2_RESERVA > 0 , B2_RESERVA,0))  // Calculo do salto atual

		If  !(SZW->ZW_SALDO > 0 .Or. nSaldo > 0) .AND. lcontinua
			lcontinua := .F.
			aAdd(aErros,{"400","O saldo em transito esta zerado ou negativo!"})
            cReturn := FWJsonSerialize(u_FJsonRetorno(aErros), .F., .F., .T.)
            ::SetResponse(EncodeUtf8(cReturn))
		EndIf
				
		If  !(SZZ->ZZ_XPLIQ <= nSaldo) .AND. lcontinua
			lcontinua := .F.
			aAdd(aErros,{"400","Ocorreu uma inconsistencia nos saldos: O saldo do Pack-List esta maior que o saldo em estoque do trï¿½nsito !"})
            cReturn := FWJsonSerialize(u_FJsonRetorno(aErros), .F., .F., .T.)
            ::SetResponse(EncodeUtf8(cReturn))
		
		Endif

		IF lcontinua 

		    oLote['packlist' ]	    := SD1->D1_XPACLIS
			oLote['lote' ] 	        := CXLOTS
			oLote['nota' ] 	        := SD1->D1_DOC
			oLote['serie' ] 	    := SD1->D1_SERIE 
            oLote['produto' ] 	    := SD1->D1_COD
			oLote['descr' ] 	    := Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_DESC")              
			oLote['um' ]    	    := Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_UM")
			oLote['tipo' ] 	        := Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_TIPO")   
            iF SuperGetMv("MV_XCORRI",.F.,.F.) .and. SB1->B1_XCTLCOR == "S"
			    oLote['local' ] 	:= "06"
            Else
                oLote['local' ] 	:= AllTrim( GetMv("MV_XARMMAT") )
            EndIf    
            oLote['quantidade' ] 	:= SZZ->ZZ_XPLIQ
            oLote['fornece' ]	    := SD1->D1_FORNECE
            oLote['loja' ]          := SD1->D1_LOJA
            oLote['item' ]          := SD1->D1_ITEM
            oLote['numdi' ]         := SD1->D1_XDI
			oLote['lotectl']        := SD1->D1_LOTECTL
			oLote['valid']          := dtoc(SD1->D1_DTVALID)

            cReturn := FWJsonSerialize(oLote, .F., .F., .T.)
		    ::SetResponse(EncodeUtf8(cReturn))
	
		ENDIF

	Endif

		         
     		
    

	MemoWrite("C:\Users\Administrator\Desktop\Jsons\"+Dtos(dDataBase)+"T"+StrTran(Time(),':','-')+".json",cReturn)

Return .T.



