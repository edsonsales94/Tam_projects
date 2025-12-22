#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include 'tbiconn.ch'

user function MWC_ETIQUETA()
Prepare Environment Empresa '01' Filial '01'
return                      

WSRESTFUL ETIQUETA DESCRIPTION "Serviço de Etiquetas"

WSDATA Label AS String

WSMETHOD GET DESCRIPTION "Retornar as informações de etiqueta" WSSYNTAX "/ETIQUETA/{Label} || /ETIQUETA/{Label}"  

End WsRestful

WsMethod Get WSRECEIVE Label WSSERVICE ETIQUETA
	
	Local oEtiqueta := JsonObject():New()
	Local lExiste  := .T.             
	Local lLabel   := .F.
	Local cLabel   := ""
	Local nX       := 0
	Private aErros := {}
	cReturn := ""

	
	//RpcSetType(3)
	//ldOk := RpcSetEnv('01','01')
	::SetContentType("application/json")
	//CONOUT(label)
	ChkFile("SZN")

	If Len(::aURLParms) > 0
		cLabel := ::aURLParms[01]
		lLabel := .T.
	Else
		cLabel := "" 
	EndIf        
	
	CB0->(dbSetOrder(1))
	qout(cLabel)

	If lLabel  

		If !CB0->(DbSeek(xFilial("CB0")+cLabel))
			lExiste := .F.
			aAdd(aErros,{"400","Etiqueta invalida"})
			cReturn := FWJsonSerialize(u_FJsonRetorno(aErros), .F., .F., .T.)

			::SetResponse(EncodeUtf8(cReturn))
		EndIf
	EndIf
	
	If lExiste

            SB1->(dbSetOrder(1))
            SB1->(DbSeek(xFilial("SB1")+CB0->CB0_CODPRO))
	
			oEtiqueta['numetiqueta' ]	:= CB0->CB0_CODETI
			oEtiqueta['produto' ] 	    := CB0->CB0_CODPRO
			oEtiqueta['saldo' ] 	    := CB0->CB0_QTDE
			oEtiqueta['nota' ] 	     	:= CB0->CB0_NFENT   
			oEtiqueta['serie' ] 	    := CB0->CB0_SERIEE
            oEtiqueta['lote' ] 	        := CB0->CB0_LOTE
			oEtiqueta['localiz' ] 	    := CB0->CB0_LOCALI  	            
			oEtiqueta['fornece' ] 	    := CB0->CB0_FORNEC
			oEtiqueta['loja' ] 	        := CB0->CB0_LOJAFO    
			oEtiqueta['local' ] 	    := CB0->CB0_LOCAL   
            oEtiqueta['desc' ] 	        := SB1->B1_DESC 
			oEtiqueta['um' ] 	        := SB1->B1_UM
            oEtiqueta['tipo' ] 	        := SB1->B1_TIPO   
			oEtiqueta['valid' ] 	    := dtoc(CB0->CB0_DTVLD )
			oEtiqueta['origem' ] 	    := CB0->CB0_ORIGEM
			oEtiqueta['numseq' ] 	    := IIF(CB0->CB0_ORIGEM='SD3',CB0->CB0_NUMSEQ ,fbusca (CB0->CB0_NFENT+CB0->CB0_SERIEE+CB0->CB0_FORNEC+CB0->CB0_LOJAFO+CB0->CB0_CODPRO+CB0->CB0_LOCAL))
			oEtiqueta['doc' ] 	        := IIF(CB0->CB0_ORIGEM='SD3',fbusca2(CB0->CB0_NFENT+CB0->CB0_SERIEE+CB0->CB0_FORNEC+CB0->CB0_LOJAFO+CB0->CB0_CODPRO+CB0->CB0_LOCAL), CB0->CB0_NFENT  )
			
			cReturn := FWJsonSerialize(oEtiqueta, .F., .F., .T.)
			::SetResponse(EncodeUtf8(cReturn))
	EndIf
	MemoWrite("C:\Users\Administrator\Desktop\Jsons\"+Dtos(dDataBase)+"T"+StrTran(Time(),':','-')+".json",cReturn)

Return .T.



static function fbusca(cxKey)
Local cxNumseq := ""
Local cQry     := ""

cQry := " SELECT DA_NUMSEQ FROM  "+RetSQLName("SDA")+" SDA "
cQry += " WHERE SDA.D_E_L_E_T_ = '' AND DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA+DA_PRODUTO+DA_LOCAL =  '"+cxKey+"' and DA_SALDO  > 0 "

xdTb2 := MpSysOpenQUery(cQry)
DBSELECTAREA(xdTb2)

While !(xdTb2)->(Eof())
	cxNumseq := (xdTb2)->DA_NUMSEQ
	(xdTb2)->( DbSkip() ) 
EndDO
   
return cxNumseq



static function fbusca2(cxKey)
Local cxDocs := ""
Local cQry     := ""

cQry := " SELECT DA_DOC FROM  "+RetSQLName("SDA")+" SDA "
cQry += " WHERE SDA.D_E_L_E_T_ = '' AND DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA+DA_PRODUTO+DA_LOCAL =  '"+cxKey+"' and DA_SALDO  > 0 "

xdTb2 := MpSysOpenQUery(cQry)
DBSELECTAREA(xdTb2)

While !(xdTb2)->(Eof())
	cxDocs := (xdTb2)->DA_DOC
	(xdTb2)->( DbSkip() ) 
EndDO
   
return cxDocs
