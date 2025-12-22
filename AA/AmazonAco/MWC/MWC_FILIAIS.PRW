#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include "TBICONN.ch"
#include "fwcommand.ch"


User Function FILIAIS()

Return


WSRESTFUL FILIAIS DESCRIPTION "Servico de Consulta de Filiais"

WSMETHOD GET DESCRIPTION "Retornar filiais do sistema" WSSYNTAX "/FILIAIS || /FILIAIS/"

End WsRestful


WsMethod Get  WSSERVICE FILIAIS
Local oFiliais  := JsonObject():New()
Local aFilsSM0 
Local nX
Local cReturn := ""
lOCAL nItemReg  := 0 
lOCAL nPagReg   := 0

RpcSetType(3)
ldOk := RpcSetEnv('01','01')
//::SetContentType("application/json")
aFilsSM0 := FWLoadSM0()
::SetContentType("application/json")
//conout(ldOk)


oFiliais['items']    := {}
	
For nX := 1 to len(aFilsSM0)
        nItemReg  ++
	
    	Aadd(oFiliais["items"],JsonObject():New())
		aXvector :=  FWSM0Util():GetSM0Data(aFilsSM0[nX,SM0_GRPEMP],aFilsSM0[nX,SM0_FILIAL])

		Atail(oFiliais["items"])['ID Interno']	         := aFilsSM0[nX,SM0_GRPEMP]+aFilsSM0[nX,SM0_FILIAL]
		Atail(oFiliais["items"])['Código da Empresa']    := aFilsSM0[nX,SM0_GRPEMP]
		Atail(oFiliais["items"])['Unidade de Negócio']   := aFilsSM0[nX,SM0_UNIDNEG]
		Atail(oFiliais["items"])['Código Unidade Pai']   := ""
		Atail(oFiliais["items"])['Descrição']	         := aFilsSM0[nX,SM0_NOMRED]
		Atail(oFiliais["items"])['Código da Filial']     := aFilsSM0[nX,SM0_FILIAL]
		Atail(oFiliais["items"])['Título']               := aFilsSM0[nX,SM0_NOME]
		Atail(oFiliais["items"])['CNPJ/CGC']             := aFilsSM0[nX,SM0_CGC]
		Atail(oFiliais["items"])['Inscrição Estadual']   := aXvector[aScan(aXvector, {|x| Alltrim(x[1]) == "M0_INSC"})][2]
		Atail(oFiliais["items"])['Telefone'] 			 := aXvector[aScan(aXvector, {|x| Alltrim(x[1]) == "M0_TEL"})][2]
		Atail(oFiliais["items"])['Rua']	        		 := aXvector[aScan(aXvector, {|x| Alltrim(x[1]) == "M0_ENDENT"})][2]
		Atail(oFiliais["items"])['Complemento']     	 := ""
		Atail(oFiliais["items"])['Bairro']               := aXvector[aScan(aXvector, {|x| Alltrim(x[1]) == "M0_BAIRENT"})][2]
		Atail(oFiliais["items"])['Estado']               := aXvector[aScan(aXvector, {|x| Alltrim(x[1]) == "M0_ESTENT"})][2]
		Atail(oFiliais["items"])['Cidade']               := aXvector[aScan(aXvector, {|x| Alltrim(x[1]) == "M0_CIDENT"})][2]
		Atail(oFiliais["items"])['CEP']                  := aXvector[aScan(aXvector, {|x| Alltrim(x[1]) == "M0_CEPENT"})][2]

		
Next 


cReturn := FWJsonSerialize(oFiliais, .F., .F., .T.)
::SetResponse(EncodeUtf8(cReturn))

MemoWrite("C:\Users\Administrator\Desktop\Jsons\"+Dtos(dDataBase)+"T"+StrTran(Time(),':','-')+".json",cReturn)


Return .T.
