/*
Solicitacao do Sr. Guilherme / Brandão em 11/05/15
*/ 

#Include "PROTHEUS.CH"
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02
#include "TOTVS.CH"
#include "ap5mail.ch"
#INCLUDE "TBICONN.CH"
#include "TbiCode.ch"

User Function M410AGRV()

Local  c_Alias := ALIAS()
Local  aItens  := {}
Local  xOrdProd :=""
Local cCodUser  :=retcodusr()

If SC5->C5_TIPO =="N" .and. ALTERA
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek(xFilial("SC6")+SC5->C5_NUM)
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
			iF !EMPTY(SC6->C6_OP)  
				xOrdProd := xOrdProd +SC6->C6_NUMOP+SC6->C6_ITEM+"\"
				AADD(aItens , SC6->C6_ITEM+"___"+xProduto+xDescri+"__"+xQuant+"__"+xVUnit+"__"+DTOC(SC6->C6_ENTREG)+"__"+SC6->C6_NUMOP+SC6->C6_ITEM )
			Elseif DateDiffDay( dDataBase, SC5->C5_EMISSAO ) > 8
				AADD(aItens , SC6->C6_ITEM+"___"+xProduto+xDescri+"__"+xQuant+"__"+xVUnit+"__"+DTOC(SC6->C6_ENTREG))
			Endif	
			dbSkip()
		
		ENDDO
	Endif	
	////
	////Envia e-mail p/o responsavel da liberacao da regra
	////
	
	IF ( Len(aItens) > 0 )
		If !cCodUser $("000241/000386") //Marcos/Vera
			IF ( f_email(aItens,xOrdProd) )
				//MsgInfo("Pedido de Venda Alterado por .")
			ELSE
				MsgInfo("Pedido de Venda Alterado mas com problema no envio do e-mail. Favor verificar o link de internet.")
			ENDIF
		Endif
	ENDIF
Endif		
dbSelectArea(c_Alias)

Return

////////////////////////////////////////////////////
Static Function f_email(aItens,xOrdProd)
////////////////////////////////////////////////////
Local cmServer  := GETMV("MV_RELSERV") 
Local cmAccount := GETMV("MV_RELACNT")
Local cmPassw   := GETMV("MV_RELAPSW")//"perkadre0985" //GETMV("MV_RELAPSW") 
//Local cMail01	:= SUPERGETMV("MV_ALTPD01",,"teddy.pereira@coel.com.br;francisco.silva@coel.com.br;dora@coel.com.br;guilherme.borcato@coel.com.br;brandao@coel.com.br")
//Local cMail02	:= SUPERGETMV("MV_ALTPD02",,"evaldo.marques@coel.com.br;marineide.franca@coel.com.br;guilherme.borcato@coel.com.br;brandao@coel.com.br")               
Local cMail01	:= "rbosp@terra.com.br"
Local cMail02	:= "rogerio@oliminet.com.br"
Local cmSubject := "Alteração de Pedido de Venda p/Faturamento - PV No.: "+SC5->C5_NUM
Local cLista    := ""
Local cEmpresa  := SM0->M0_CODIGO+SM0->M0_CODFIL
Local lConectou
Local lEnviado
Local lDesConect
Local cUser		:=UsrFullName(__cUserID)


cxPara :=IIF(cEmpresa=="0301",cMail01,cMail02)
//cxPara := "andre@oliminet.com.br;brandao@coel.com.br"
cxCC   := ""
cmBody := "<html>"+chr(13)+chr(10)
cmBody += "<body>"+chr(13)+chr(10)
cmBody += "Pedido Alterado por :"+"<b>"+cUser+"</b>"+chr(13)+chr(10)
cmBody += "Empresa: "+IIF(cEmpresa=="0301","Coelmatic/Manaus",IIF(cEmpresa=="0302","Coelmatic/São Paulo",RTRIM(SM0->M0_NOME)))+" ===> PV No.: "+SC5->C5_NUM+"  ===> CLIENTE: "+RTRIM(SA1->A1_NOME)+chr(13)+chr(10)
cmBody += "========================================================================================="+chr(13)+chr(10)
cmBody += "Itm__Produto..............................................................................................___Quant.____Prc.Unit.__Entrega____OP"+chr(13)+chr(10)
cmBody += "========================================================================================="+chr(13)+chr(10)
***                 1         2         3         4         5         6         7         8 
***        123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
***        xx   x------------------x x----------------------------x    99999  99,999.9999  99/99/99

For ix:=1 To Len(aItens)
	 cmBody += aItens[ix]+chr(13)+chr(10)
Next
cmBody += chr(13)+chr(10)
If len(xOrdProd)>0
	cmBody += " <b>Ja existem ordens de produção para esse pedido, favor verificar as OP´s : </b>"+"<b>"+xOrdProd+"</b>"
Else
	cmBody += "<b>Pedido com data de emissão superior a 8 dias foi alterado. </b>"
Endif
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