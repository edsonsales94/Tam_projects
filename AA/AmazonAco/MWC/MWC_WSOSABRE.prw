#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include "TBICONN.ch"

User Function WSOSABRE()
Return Nil

WSRESTFUL WSOSABRE DESCRIPTION "Serviço REST para Abertura OS"
    WSMETHOD POST DESCRIPTION "Serviço REST para Transferencia de Produto" WSSYNTAX "/WSOSABRE"  
END WSRESTFUL


WSMETHOD Post  WSSERVICE WSOSABRE
  Local lPost := .T.
  Local cBody := ""
  Local cReturn := ""
  Local oRequest := JsonObject():New()  
  Local xError := ""
  Local nX 
  Local itens
  Local xArmazem
  Local xFil
  	RpcSetType(3)
	RpcSetEnv('01','01')
	::SetContentType("application/json")


  cBody := ::GetContent()
  u_SaveRequest(cBody)
  oRequest:FromJson(cBody)

  if lPost
    oReturn := _Post(oRequest)
    cReturn := FWJsonSerialize(oReturn, .F., .F., .T.)
    ::SetContentType("application/json")
    u_SaveResponse(cReturn)
    ::SetResponse(cReturn)

  Endif
Return lPost


Static Function _Post(_oRequest)
    Local oReturn := JsonObject():New()
    Local cProduto := ""
    Local nX
    Local cLocOrigem := ""
    Local cEndOrigem := ""
    Local cLocDestino:= ""
    Local cEndDestino := ""
    Local cxFilial  := ""
    local cxserv     := ""
    LOCAL CXCODSV    := ""
    LOCAL cOSKT      := ""
    Local nQuant := 0
    Local aLinha := {}
    Local aAuto := {}
    local _ndI   
    LOCAL INCLUI 
    LOCAL NZ
     

   qout(valtype(_oRequest["items"]))
   oReturn['items']    := {}
	

    For _ndI := 1 To Len(_oRequest["items"])
         
          oRequest := _oRequest["items"][_ndI]


          cOSKT := oRequest:GetJsonText("ordemservicoKM")
          cDataIni := oRequest:GetJsonText("datainicio")
		    cDataFim := oRequest:GetJsonText("datafim")
          cTecnico := oRequest:GetJsonText("tecnico")
          cxserv   := oRequest:GetJsonText("servico")
		    cxOS     := GetSXENum( "STJ","TJ_ORDEM" )
          cBem     := left(cxserv,9)
          ST4->(dbSetOrder(2))//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		    If ST4->(dbSeek(xFilial("ST4") + ALLTRIM(cxserv) ))
			   CXCODSV := ST4->T4_SERVICO
		    EndIf
          
         //cfilant := cxFilial
      

         RecLock("STJ",.T.)
         STJ->TJ_FILIAL  := XFILIAL("STJ")
         STJ->TJ_ORDEM   := cxOS
         STJ->TJ_DTORIGI := STOD(LEFT(cDataIni,8))
         STJ->TJ_CODBEM  := cBem 
         STJ->TJ_XKITE   := cOSKT
         STJ->TJ_SITUACA := "P"
         STJ->TJ_TIPOOS  := "B"
         STJ->TJ_USUARIO := "KITEMES"
         STJ->TJ_PLANO   := "000000"
         STJ->TJ_SEQRELA := "0"
         STJ->TJ_SERVICO := CXCODSV
         STJ->TJ_TIPO    := "005"
         STJ->TJ_DTPRINI :=  STOD(LEFT(cDataIni,8))
         STJ->TJ_DTPRFIM :=  STOD(LEFT(cDataFim,8))
         STJ->TJ_CODAREA := "000004"
         STJ->TJ_XSERVS  := cxserv
         STJ->TJ_SITUACA := "L"
         MsUnlock()


       Aadd(oReturn['items'],JsonObject():New())
    
		 Atail(oReturn['items'])['OS Protheus'] := cxOS
       Atail(oReturn['items'])['OS Kite']     := cOSKT
		 Atail(oReturn['items'])['status']	    := "true"
		 Atail(oReturn['items'])['mensagem']	 := "Ordem de servico incluida com sucesso"
      		
		//stj := campo kitemes
		
         NEXT 

        lContinua := .F.
      
Return oReturn

static function ValidateJson(oJson)
   Local a := oJson:GetNames()
   Local xError := ""

   if aScan(a,{|x| x == "product"}) = 0
      xError := EncodeUtf8("product é Obrigatório")
   EndIf

   if aScan(a,{|x| x == "sourceWarehouse"}) = 0 .And. Empty(xError)
      xError := EncodeUtf8("sourcewarehouse é Obrigatório")
   EndIf
/*
   if aScan(a,{|x| x == "sourcewarehouseaddress"}) = 0 .And. Empty(xError)
      xError := EncodeUtf8("sourcewarehouse é Obrigatório")
   EndIf
*/
   if aScan(a,{|x| x == "targetWarehouse"}) = 0 .And. Empty(xError)
      xError := EncodeUtf8("sourcewarehouse é Obrigatório")
   EndIf
/*
   if aScan(a,{|x| x == "targetwarehouseaddress"}) = 0 .And. Empty(xError)
      xError := EncodeUtf8("sourcewarehouse é Obrigatório")
   EndIf
*/
   if aScan(a,{|x| x == "Amount"}) = 0 .And. Empty(xError)
      xError := EncodeUtf8("Amount é Obrigatório")
   EndIf
/*
   if Empty(xError) .And. ValType(oJson["items"])!="A"
      xError := EncodeUtf8("items tem que ser um array")
   EndIf
  */ 
Return xError
