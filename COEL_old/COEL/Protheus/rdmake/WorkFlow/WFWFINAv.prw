/*
Solicitacao da Sra. Jani (financeiro) / Sr. Alcir Junior (financeiro) em 01/06/16
*/
#Include "PROTHEUS.CH"
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02
#include "TOTVS.CH"
#include "ap5mail.ch"
#INCLUDE "TBICONN.CH"
#include "TbiCode.ch"
#include 'topconn.ch'

User Function WFWFINAV()
	Processa({|| PROCWFIV()},"Aguarde Processando...") 
Return


Static Function PROCWFIV()
Local  c_Alias := ALIAS()
Local  aItens  := {}
Local  xOrdProd :=""
Local cCodUser  :=retcodusr()

            
cSELECT := 	'SA1.A1_NOME,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_VENCREA,SE1.E1_PARCELA,SE1.E1_VALOR,SE1.E1_EMISSAO,SA1.A1_EMAILFI,SE1.E1_SALDO,SE1.E1_TIPO,SA1.A1_NOME '

cFROM  :=	RetSqlName('SE1') + ' SE1'

cINNER := 'INNER JOIN '+ RetSqlName('SA1')+' SA1 ON SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA  ' 

cWHERE :=	'cast(convert(char(8),getdate(),112)as int)- E1_VENCREA  >= 2 AND E1_SALDO> 0 '+;
			'AND E1_TIPO ='+ "'NF'"+ ' AND E1_PREFIXO <>' +'5  '+' AND SE1.E1_VENCREA >='+ " '20161020'"+ ' AND '+;
			'SE1.D_E_L_E_T_ <>    '+CHR(39) + '*'            +CHR(39) + ' AND '+;
			'SA1.D_E_L_E_T_ <>    '+CHR(39) + '*' +CHR(39) +' AND SA1.A1_EST <> ' + "'EX'" + 'AND SE1.E1_SITUACA <> ' + "'F'" 

cORDER  :=	'SE1.E1_PREFIXO,SE1.E1_NUM '

cQuery  :=	' SELECT '   + cSELECT + ;
' FROM '     + cFROM   +" "+ cINNER +" "+ ;
' WHERE '    + cWHERE  + ;
' ORDER BY ' + cORDER

TCQUERY cQuery NEW ALIAS 'TCPA'

If	! USED()
	MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
EndIf

DbSelectArea('TCPA')
Count to _nQtdReg
ProcRegua(_nQtdReg)
TCPA->(DbGoTop())
While 	TCPA->( ! Eof() )
	IncProc("Separando titulos "+TCPA->E1_NUM)
	AADD(aItens , {TCPA->E1_NUM,TCPA->E1_PREFIXO,TCPA->A1_NOME,TCPA->E1_PARCELA,TCPA->E1_VALOR,TCPA->E1_EMISSAO,TCPA->E1_VENCREA,TCPA->A1_EMAILFI,TCPA->A1_NOME} )
	TCPA->(Dbskip())
	
End


	////
	////Envia e-mail p/o responsavel da liberacao da regra
	////
	
	IF ( Len(aItens) > 0 )
		
		IF ( f_email(aItens) )

		ELSE
			MsgInfo("Problema no envio do e-mail. Favor verificar o link de internet.")
		ENDIF
		
	ENDIF
	
dbSelectArea(c_Alias)

Return

////////////////////////////////////////////////////
Static Function f_email(aItens,xOrdProd)
////////////////////////////////////////////////////
Local cmServer  := GETMV("MV_RELSERV") 
Local cmAccount := GETMV("MV_RELACNT")
Local cmPassw   := GETMV("MV_RELAPSW") 
Local cMail01	:= "" 
Local cmSubject := ""
Local cLista    := ""//GetSrvProfString('Startpath','') + 'logo_COELMATIC_cor.JPG'
Local cLogo     := GetSrvProfString('Startpath','') + 'logo_COELMATIC_cor.JPG'
                  
Local cEmpresa  := SM0->M0_CODIGO+SM0->M0_CODFIL
Local lConectou
Local lEnviado
Local lDesConect
Local cUser		:=UsrFullName(__cUserID)



//cxPara := "andre@oliminet.com.br;brandao@coel.com.br"
cxCC   :="Financeiro@coel.com.br"   

***                 1         2         3         4         5         6         7         8 
***        123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
***        xx   x------------------x x----------------------------x    99999  99,999.9999  99/99/99
ProcRegua(Len(aItens))
For ix:=1 To Len(aItens)
	IncProc("Processando Workflow do Titulo Nr. "+aItens[ix][1])	
	If !Empty(aItens[ix][8])
		cxPara := cMail01 := aItens[ix][8] 
		cmSubject := "Aviso de cobrança - Titulo No.: "+aItens[ix][1]
		cmBody := "<html>"+chr(13)+chr(10)
		cmBody += "<body>"+chr(13)+chr(10) 
		cmBody += "<img width= "+'"090px"'+" height= "+'"075px"'+" align="+'"Top "'+" src= "+ '"'+"www.coel.com.br/wp-content/themes/coel/assets/img/logo.png"+ '"'+"/>" +chr(13)+chr(10)
	 	cmBody += "Prezado Cliente, "+"<b>"+aItens[ix][09]+"</b>"+chr(13)+chr(10)
		cmBody += "Informamos que não identificamos o pagamento da NF "+"<b>"+aItens[ix][2]+aItens[ix][1]+"</b>"+chr(13)+chr(10)
		cmBody += "Titulo Nº  : "+"&nbsp;&nbsp;&nbsp;&nbsp;"+"<b>"+aItens[ix][2]+aItens[ix][1]+"</b>"+chr(13)+chr(10)
		cmBody += "Parcela    : "+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+"<b>"+Strzero(Val(aItens[ix][4]),2)+"</b>"+chr(13)+chr(10)
		cmBody += "Valor      : "+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+"<b>"+cValTochar(TransForm(aItens[ix][5],'@E 9999,999.99'))+"</b>"+chr(13)+chr(10)
		cmBody += "Emissão    : "+"&nbsp;&nbsp;&nbsp;&nbsp;"+"<b>"+cValToChar(STOD(aItens[ix][6]))+"</b>"+chr(13)+chr(10)
		cmBody += "Vencimento : "+"<b>"+cValToChar(STOD(aItens[ix][7]))+"</b>"+chr(13)+chr(10)
		cmBody += "Dessa forma pedimos à gentileza que regularize com urgência essa pendência, ou na hípotese de o pagamento já ter sido "
		cmBody += "efetuado, por gentileza, desconsidere essa cobrança."+chr(13)+chr(10)
		cmBody += "Atenciosamente, "+chr(13)+chr(10)
		cmBody += +chr(13)+chr(10)
		cmBody += "<b>"+"COELMATIC LTDA "+"</b>"+chr(13)+chr(10)
		cmBody += "Depto. Financeiro "+chr(13)+chr(10)
		cmBody += "Tel.: 11 - 2066 - 3235  "+chr(13)+chr(10)
		cmBody += "E-mail:" +"financeiro@coel.com.br "+chr(13)+chr(10)
		cmBody += "Site: www.coel.com.br "+chr(13)+chr(10)
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
    Endif
Next




///
///Disconecta o servidor de SMTP
///
DISCONNECT SMTP SERVER Result lDesConect

Return .T.