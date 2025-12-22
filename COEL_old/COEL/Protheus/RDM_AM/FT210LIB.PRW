/*
Solicitacao do Sr. Rafael Bocchi em 16/05/13
*/
#Include "PROTHEUS.CH"
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02
#include "TOTVS.CH"
#include "ap5mail.ch"
#INCLUDE "TBICONN.CH"
#include "TbiCode.ch"

User Function FT210LIB()

Local  c_Alias := ALIAS()
Local  aItens  := {}

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
*
dbSelectArea("SC6")
dbSetOrder(1)
dbSeek(xFilial("SC6")+SC5->C5_NUM,.T.)
DO WHILE !EOF().AND.C6_FILIAL==xFilial("SC6").AND.C6_NUM==SC5->C5_NUM

	xProduto := LEFT(SC6->C6_PRODUTO,21)
	xProduto := STRTRAN(xProduto," ","_")
	xDescri  := RTRIM(LEFT(SC6->C6_DESCRI,30))
	nLenDsc  := Len(xDescri)
	xDescri  := xDescri+Replicate("_",30-nLenDsc)
	xQuant   := TRANSF(SC6->C6_QTDVEN,"@E 99999")
	xQuant   := STRTRAN(xQuant," ","_")
	xVUnit   := TRANSF(SC6->C6_PRCVEN,"@E 99,999.9999")
	xVUnit   := STRTRAN(xVUnit," ","_")

	AADD(aItens , SC6->C6_ITEM+"___"+xProduto+xDescri+"__"+xQuant+"__"+xVUnit+"__"+DTOC(SC6->C6_ENTREG) )
		
	dbSkip()

ENDDO

////
////Envia e-mail p/o responsavel da liberacao da regra
////

IF ( Len(aItens) > 0 )
	IF ( f_email(aItens) )
		MsgInfo("Pedido de Venda liberado e e-mail enviado com sucesso.")
	ELSE
		MsgInfo("Pedido de Venda liberado mas com problema no envio do e-mail. Favor verificar o link de internet.")
	ENDIF
ENDIF
	
dbSelectArea(c_Alias)

Return

////////////////////////////////////////////////////
Static Function f_email(aItens)
////////////////////////////////////////////////////
Local cmServer  := GETMV("MV_RELSERV") 
Local cmAccount := GETMV("MV_RELACNT")
Local cmPassw   := GETMV("MV_RELAPSW") 
Local cmSubject := "Liberação de Regra de Pedido de Venda p/Faturamento - PV No.: "+SC5->C5_NUM
Local cLista    := ""
Local cEmpresa  := SM0->M0_CODIGO+SM0->M0_CODFIL
Local lConectou
Local lEnviado
Local lDesConect

//cxPara := "rafael.bocchi@coel.com.br" Modificado por Andre Rodrigues a pedido do Sr. Rafael Bocchi 08/04/15
cxPara := "Guilherme.borcato@coel.com.br"
cxCC   := "Edson@coel.com.br"
*
cmBody := "<html>"+chr(13)+chr(10)
cmBody += "<body>"+chr(13)+chr(10)
cmBody := "Empresa: "+IIF(cEmpresa=="0301","Coelmatic/Manaus",IIF(cEmpresa=="0302","Coelmatic/Jabaquara",RTRIM(SM0->M0_NOME)))+" ===> PV No.: "+SC5->C5_NUM+"  ===> CLIENTE: "+RTRIM(SA1->A1_NOME)+chr(13)+chr(10)
cmBody += "========================================================================================="+chr(13)+chr(10)
cmBody += "Itm__Produto..............................................................................................___Quant.____Prc.Unit.__Entrega"+chr(13)+chr(10)
cmBody += "========================================================================================="+chr(13)+chr(10)
***                 1         2         3         4         5         6         7         8 
***        123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
***        xx   x------------------x x----------------------------x    99999  99,999.9999  99/99/99

For ix:=1 To Len(aItens)
	 cmBody += aItens[ix]+chr(13)+chr(10)
Next

cmBody += "<p>"
cmBody += "</body>"
cmBody += "</html>"

CONNECT SMTP SERVER cmServer ;
		  ACCOUNT  cmAccount   ;
		  PASSWORD cmPassw     ;
		  Result lConectou

IF ( lConectou )

	lConectou := MailAuth(cmAccount, cmPassw)
	
	If !lConectou
		MsgAlert("[Error] Falha de conexão.")
		Return .F.
	Endif	

	SEND MAIL FROM cmAccount TO cxPara  ;
				 CC cxCC                   ;
				 SUBJECT cmSubject         ;
				 BODY cmBody               ;
				 ATTACHMENT cLista         ;
				 RESULT lEnviado

	IF ( !lEnviado )
		MsgAlert("** Falha ao enviar. Favor verificar se houve falha de conexão com a Internet. Se houve e normalizou, favor re-enviar a lista.")
		Return .F.
	ENDIF

ELSE
	///
	///Extrai o resultado envio
	///
	GET MAIL ERROR cmMsgErr
	///
	///Informa a mensagem de envio para o usuario
	///
	MsgAlert( "** Erro ao enviar o e-mail. Motivo: "+cmMsgErr )
	Return .F.
ENDIF
///
///Disconecta o servidor de SMTP
///
DISCONNECT SMTP SERVER Result lDesConect

Return .T.