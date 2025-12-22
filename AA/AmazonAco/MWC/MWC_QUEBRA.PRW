#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include 'tbiconn.ch'

user function MWC_QUEBRA()
	Local cdJson :=""

	Prepare Environment Empresa '01' Filial '01'

return


Static Function Quebrar(cdJson)

	Local i,j, odQuebra
	Local aErros := {}
	local _Etqs  := ''
	Local lSucesso := .F.

	Default cdJson := ''

	lOK := .T.
	cMessage := ""
	If FWJsonDeserialize(cdJson,@odQuebra)

		If .F.
			cMessage := "Mensagem j� processada"
			//CONOUT(cMessage)
		Else
				lOK := .T.
				//CONOUT("Esta no for")
				
				ccModo    := odQuebra:modo     
				cdLabel   := odQuebra:etiqueta     
				ndQty     := odQuebra:quantidade   
				
				if ccModo = "2"  
					CB0->(dbSetOrder(1))
					If !CB0->(dbSeek(xFilial('CB0') + cdLabel ))
						lOK := .F.
						cMessage := "Etiqueta informada nao encontrado na Base de Dados"
						aAdd(aErros,{"400",cMessage})    
						RETURN {aErros,lSucesso}          
					EndIf    
					QOUT(cMessage)
					
					If ndQty >= CB0->CB0_QTDE
						lOK := .F.
						cMessage := "Quantidade informada superior a etiqueta"
						aAdd(aErros,{"400",cMessage}) 
						RETURN {aErros,lSucesso}          
					ENDIF 
					QOUT(cMessage)
					
					nxOrig := CB0->CB0_QTDE
					nxSequ := CB0->CB0_NUMSER
					If lOk 
						
						CBGrvEti('01',{CB0->CB0_CODPRO,ndQty       ,CB0->CB0_USUARI,CB0->CB0_NFENT,CB0->CB0_SERIEE,CB0->CB0_FORNEC,CB0->CB0_LOJAFO,CB0->CB0_PEDCOM,CB0->CB0_LOCALI,CB0->CB0_LOCAL,CB0->CB0_OP,CB0->CB0_NUMSEQ,NIL,NIL,CB0->CB0_CODET2,CB0->CB0_LOTE,CB0->CB0_SLOTE,CB0->CB0_DTVLD,CB0->CB0_CC,CB0->CB0_LOCORI,NIL,NIL,nxSequ,CB0->CB0_ORIGEM})					
						fxPrint(CB0->CB0_CODETI,ndQty)
						_Etqs := CB0->CB0_CODETI + ","
						CBGrvEti('01',{CB0->CB0_CODPRO,nxOrig-ndQty,CB0->CB0_USUARI,CB0->CB0_NFENT,CB0->CB0_SERIEE,CB0->CB0_FORNEC,CB0->CB0_LOJAFO,CB0->CB0_PEDCOM,CB0->CB0_LOCALI,CB0->CB0_LOCAL,CB0->CB0_OP,CB0->CB0_NUMSEQ,NIL,NIL,CB0->CB0_CODET2,CB0->CB0_LOTE,CB0->CB0_SLOTE,CB0->CB0_DTVLD,CB0->CB0_CC,CB0->CB0_LOCORI,NIL,NIL,nxSequ,CB0->CB0_ORIGEM})					
						fxPrint(CB0->CB0_CODETI,nxOrig-ndQty)
						_Etqs += CB0->CB0_CODETI + ","
						
						CB0->(dbSeek(xFilial('CB0') + cdLabel ))
						Reclock("CB0",.F.) 
						DBDELETE()
						MSUNLOCK()   
							
						lOK := .T.
						cMessage := "Operacao Executada com Sucesso! 2 Etiquetas geradas! " + _Etqs
						lSucesso := .T.  		
						aAdd(aErros,{"200",cMessage})  
						
					EndIf    
				else
					QOUT("Entrou no modo 1")	
					CB0->(dbSetOrder(1))
					If !CB0->(dbSeek(xFilial('CB0') + cdLabel ))
						lOK := .F.
						cMessage := "Etiqueta informada nao encontrado na Base de Dados"
						aAdd(aErros,{"400",cMessage})    
						RETURN {aErros,lSucesso}          
					EndIf    
					QOUT(cMessage)
					
					If CB0->CB0_QTDE % ndQty <> 0 
						lOK := .F.
						cMessage := "Nao e possivel quebrar a etiqueta nessa quantidade."
						aAdd(aErros,{"400",cMessage}) 
						RETURN {aErros,lSucesso}          
					ENDIF 
					QOUT(cMessage)
					
					nxOrig := CB0->CB0_QTDE
					nxRaiz := CB0->CB0_NUMSER
			
					If lOk 
					    FOR i := 1 to ndQty
							CBGrvEti('01',{CB0->CB0_CODPRO,(nxOrig/ndQty)       ,CB0->CB0_USUARI,CB0->CB0_NFENT,CB0->CB0_SERIEE,CB0->CB0_FORNEC,CB0->CB0_LOJAFO,CB0->CB0_PEDCOM,CB0->CB0_LOCALI,CB0->CB0_LOCAL,CB0->CB0_OP,CB0->CB0_NUMSEQ,NIL,NIL,CB0->CB0_CODET2,CB0->CB0_LOTE,CB0->CB0_SLOTE,CB0->CB0_DTVLD,CB0->CB0_CC,CB0->CB0_LOCORI,NIL,NIL,nxRaiz,CB0->CB0_ORIGEM,CB0->CB0_ITNFE})					
							fxPrint(CB0->CB0_CODETI,ndQty,nxRaiz)
						Next 						              
						
						CB0->(dbSeek(xFilial('CB0') + cdLabel ))
						Reclock("CB0",.F.) 
						DBDELETE()
						MSUNLOCK()   
							
						lOK := .T.
						cMessage := "Operacao Executada com Sucesso! "+Alltrim(Str(ndQty))+" Etiquetas geradas! "
						lSucesso := .T.  		
						aAdd(aErros,{"200",cMessage})  
						
					EndIf    
				endif
		EndIf
	Else
		lOK := .F.
		cMessage := "Falha ao Efetuar a Leitura do JSON"
		aAdd(aErros,{"400",cMessage})
		RETURN {aErros,lSucesso}          
	EndIf
	//u_fGeraLog(odEnderecar[1]:imei,odEnderecar[1]:uuid,Iif(lSucesso,"1","2"),odEnderecar[1]:usuario,cdJson,"E",cMessage)
	//CONOUT(cMessage)
Return {aErros,lSucesso}          


WSRESTFUL QUEBRA DESCRIPTION "Servi�o de Quebra Etiqueta"
	WSDATA Etiqueta    AS String
	WSDATA Quantidade  AS Integer

	WSMETHOD POST DESCRIPTION "Efetua quebra de um Item" WSSYNTAX "/QUEBRA/ || /QUEBRA/" 
	                   

End WsRestful



WSMETHOD POST  WSSERVICE QUEBRA

	Local lPost := .T.
	Local cBody
	//RpcSetType(3)
	//ldOk := RpcSetEnv('01','01')
	
	cBody := ::GetContent()
	aRetornos := Quebrar(cBody)
	
	cReturn := FWJsonSerialize(u_FJsonRetorno(aRetornos[1],aRetornos[2]), .F., .F., .T.)
	::SetResponse(EncodeUtf8(cReturn))
	
	
Return lPost


Static Function fxPrint(cCodID,ndQty)
lOCAL aArea := GetArea()
CBRetEti(cCodID)
cxProduto:= CB0->CB0_CODPRO 
nqtde 	 := CB0->CB0_QTDE
cCodSep  := CB0->CB0_USUARI
cNFEnt   := CB0->CB0_NFENT
cSeriee  := CB0->CB0_SERIEE
cFornec  := CB0->CB0_FORNEC
cLojafo  := CB0->CB0_LOJAFO
cArmazem := CB0->CB0_LOCAL
cOP      := CB0->CB0_OP
cNumSeq  := CB0->CB0_NUMSEQ
cLote    := CB0->CB0_LOTE
cSLote   := CB0->CB0_SLOTE
cCC      := CB0->CB0_CC
cLocOri  := CB0->CB0_LOCORI
cOPReq	 := CB0->CB0_OPREQ
cNumserie:= CB0->CB0_NUMSER
cOrigem  := CB0->CB0_ORIGEM
cEndereco:= CB0->CB0_LOCALI
cPedido  := CB0->CB0_PEDCOM
cNfPed   := CB0->CB0_NFENT
cxFornec := Posicione("SA2",1,XFILIAL("SA2")+cFornec  ,"A2_NOME")
cxDEscr  := Posicione("SB1",1,XFILIAL("SB1")+cxProduto,"B1_DESC")

iF CB0->CB0_ORIGEM = 'NFS'
	DBSELECTAREA("SD1")
	SD1->(DbGoto(VAL(CB0->CB0_NUMSER)))
ENDIF

MsCbPrinter("Z4M","LPT1",,         ,.F., , , , , "01")

MsCbChkStatus(.F.)
MSCBBEGIN(1,6)

MSCBWRITE("CT~~CD,~CC^~CT~^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR6,6~SD25^JUS^LRN^CI0^XZ^XA^MMT^PW559^LL0360^LS0")
MSCBWRITE("^FO4,8^GB545,344,1^FS")
/*
MSCBWRITE("^FO4,8^GB176,88,1^FS")
MSCBWRITE("^FO178,8^GB371,88,1^FS")
MSCBWRITE("^FT12,122^A0N,18,16^FH\^FDCodigo:^FS")
MSCBWRITE("^FT70,130^A0N,34,33^FH\^FD"+cxProduto+"^FS")
MSCBWRITE("^FT12,157^A0N,23,21^FH\^FD"+cxDEscr+"^FS")
MSCBWRITE("^FT189,35^A0N,20,19^FH\^FDFORNECEDOR:^FS")
MSCBWRITE("^FT12,194^A0N,18,16^FH\^FDDATA:^FS")
MSCBWRITE("^FT436,120^A0N,18,16^FH\^FDQUANTIDADE:^FS")
MSCBWRITE("^FT421,189^A0N,40,40^FH\^FD"+Alltrim(Transform(nqtde,"@E 9,999,999.9999"))+"^FS")
MSCBWRITE("^FT189,62^A0N,23,24^FH\^FD"+left(cxFornec,30)+"^FS")
MSCBWRITE("^FT421,352^BQN,2,5")
MSCBWRITE("^FH\^FDLA,"+Alltrim(cCodID)+"^FS")
MSCBWRITE("^FT12,244^A0N,18,16^FH\^FDINVOICE:^FS")
MSCBWRITE("^FT12,289^A0N,18,16^FH\^FDNOTA FISCAL:^FS")
MSCBWRITE("^FT116,298^A0N,34,33^FH\^FD"+cNFEnt+"^FS")
MSCBWRITE("^FT83,252^A0N,34,33^FH\^FD"+SD1->D1_INVOICE+"^FS")
MSCBWRITE("^FT70,199^A0N,31,31^FH\^FD"+DtoC(SD1->D1_DTDIGIT)+"^FS")
MSCBWRITE("^FO420,156^GB163,89,1^FS")//
MSCBWRITE("^FO420,125^GB163,33,1^FS")//LN
MSCBWRITE("^FT12,333^A0N,20,19^FH\^FDUSU\B5RIO:^FS")
MSCBWRITE("^FT111,333^A0N,20,19^FH\^FD"+__cUserID+"/Etq:"+Alltrim(CB0->CB0_CODETI)+"^FS")
MSCBWRITE("^FT21,69^A0N,39,38^FH\^FDHITACHI^FS")
*/
MSCBWRITE("^PQ1,0,1,Y^XZ")

MSCBEND()
MSCBInfoEti("ID0"+Alltrim(cCodID),"")

MSCBCLOSEPRINTER()
sleep(300)

restarea(aArea)



Return	
