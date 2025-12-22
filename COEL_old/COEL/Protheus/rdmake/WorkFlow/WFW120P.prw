#INCLUDE "PROTHEUS.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICODE.CH"                                
#INCLUDE "TBICONN.CH"
#DEFINE  ENTER CHR(13)+CHR(10) 
                                                                             
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ºWFW120Pº Autor º Gustavo Markx    º Data ³  01/02/2014    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³Ponto de Entrada na Confirmação do Pedido de Compra, onde   º±±
±±º          ³verifica o grupo de aprovação e prepara o Wf de envio e     º±±
±±º          ³retorno, disparando para o proximo até finalizar a alçada.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nil                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*----------------------------*
User Function WFW120P(lNivel)
*----------------------------*
Local oProcess  := Nil
Local lAprovado := .T.
Local xpedido   := SC7->C7_NUM
Local cxxpath   := GetPvProfString(getenvserver(),"ROOTPATH","ERROR", GETADV97())
Local n         := 0               
Local dVencPr   := Ctod("  /  /  ")

Local   aUser        := AllUsers()
Private cmailto      := ''
Private nAt          := 1
Private cXmail       := ''
Private cNomeApr     := '' 
Private cMailSuporte := 'teddy.pereira@coel.com.br' 

Private nRecnoSCR  := 0
Private _nVlBudget := 0
Private _nSLBudget := 0

Private _lAnexo    := .F.

lNivel	:= IIF(lNivel == nil, .F., lNivel)

CONOUT("____________________ NIVEL: "+iIF(lNivel,".T.=01",".F.=02")+" ______________________")

//
IF lNivel
	// Para proximo nivel de aprovacao, necessario posicionamento correto do aprovador	
	DBSelectarea("SCR") // Posiciona a Liberacao
	SCR->(DBSetorder(1))
	If DBSeek(xFilial("SCR")+"PC" + xPedido )
		While !eof() .and. SCR->(CR_FILIAL+"PC"+CR_NUM) = xFilial("SCR")+"PC" + xPedido
			If SCR->CR_STATUS = "02"
				//Usuario visto não eh aprovador, ignora entao
				IF POSICIONE("SAL",3,XFILIAL("SAL")+SC7->C7_APROV+SCR->CR_APROV,"AL_LIBAPR") <> "V"
					N := ASCAN(aUser, {|x| x[1,1] = SCR->CR_USER })
					
					If n > 0
						cMailTo := aUser[n,1,14]
						cNomeApr:= aUser[n,1,4]
						nRecnoSCR := SCR->( RECNO() )
					Else
						CONOUT("**************** Não encontrou o usuário, erro! **************** ")
					Endif					
					Exit					
				EndIf
			Endif			
			SCR->(DBSKIP())
		EndDo
	Else
		cMailto := cMailSuporte
	endif
	
	If Empty(cMailto)
		cMailto := cMailSuporte
	EndIF
	
	WF1->(DBSEEK(XFILIAL("WF1") + "PEDCOM" ))
	
ELSE
	// Verifica se e necessario enviar e-mail de aprovacao do pedido de compras
	SC7->(DBSETORDER(1))
	SC7->(dbSeek(xFilial('SC7')+xPedido))
	While ! SC7->(Eof()) .and. SC7->C7_NUM = xPedido .AND.  XFILIAL("SC7") = SC7->C7_FILIAL
		If   SC7->C7_CONAPRO <> 'L'
			lAprovado := .F.
			Exit
		Endif
		SC7->(DBSKIP())
	EndDo
	If lAprovado // Pedido esta totalmente aprovado e nao e necessario enviar workflow de aprovacao
		Return // sai da rotina de workflow
	Endif
	
	//Monta a lista de e-mails dos aprovadores 
	WF1->(DBSEEK(XFILIAL("WF1") + "PEDCOM" ))
	DBSelectarea("SCR")  // Posiciona a Liberacao
	DBSetorder(1)
	If DBSeek(xFilial("SCR")+"PC" + xPedido )
		
		If SCR->CR_STATUS = "02"
			N := ASCAN(aUser, {|x| x[1,1] = SCR->CR_USER })
			If n > 0
				cMailTo := aUser[n,1,14]
				cNomeApr:= aUser[n,1,4]
				nRecnoSCR := SCR->(RECNO())
			endif
		EndIf
	Else
		cMailto := cMailSuporte
	Endif
	If Empty(cMailto)
		cMailto := cMailSuporte
	EndIF	
ENDIF

CONOUT("**************** [X] Nome do Aprovador: " + cNomeApr)  

dbSelectArea('SC7')
dbSetOrder(1)
dbSeek(xFilial('SC7')+ xpedido)

ConOut("**************** Iniciando Processo - Aprovacao do Pedido "  +xpedido )

oProcess := TWFProcess():New( "PEDCOM", "Pedido de Compras" )

oProcess:NewTask( "Aprovação", "/workflow/WfAprovaPc.htm" )  // abre um processo com esse html

oProcess:Track("100100",,"","PROCESSO")

oProcess:Track("100200",,"","DECISAO")

ConOut("**************** INI_PC")

FwMsgRun(,{|| U_INI_PC2(oProcess,nat,cMailto)}, "Aguarde Processamento...","Montando WorkFlow nº: "+xPedido)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ºWFW120Pº Autor º Gustavo Markx    º Data ³  01/02/2014      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³Ponto de Entrada na Confirmação do Pedido de Compra, onde   º±±
±±º          ³verifica o grupo de aprovação e prepara o Wf de envio e     º±±
±±º          ³retorno, disparando para o proximo até finalizar a alçada.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nil                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*--------------------------------------*
User Function RET_PC2(oProcess)
*--------------------------------------*
Local lNovoAprov := .f.

private cNumero   := oProcess:oHtml:RetByName('PEDIDO')
private ca097User := Alltrim(oProcess:oHtml:RetByName('c7aprova'))
private cNumSCR   := Alltrim(cNumero) + space(50 - len(Alltrim(cNumero)))

Private _cRetInf  := Alltrim(oProcess:oHtml:RetByName('lbmotivo'))

RpcSetType(3)
//RpcSetEnv("03","01",,,,GetEnvServer(,{}))
RpcSetEnv("03",CFILANT,,,,GetEnvServer(,{}))
RpcSetType(3)

ConOut('**************** [RET - WF]**************'+_cRetInf)
ConOut('**************** [RET - WF]**************'+oProcess:oHtml:RetByName('WFMailTo'))

ConOut('[001]**************[ INICIO - RETORNO WF ]******************** ')

If oProcess:oHtml:RetByName('RBAPROVA') <> 'Sim' //foi reprovado
	DBSelectarea("SCR")                   // Posiciona a Liberacao
	DBSetorder(2)
	If DBSeek(xFilial("SCR")+"PC" + cNumSCR + ca097User)
		RecLock("SCR",.F.)
		Replace SCR->CR_DataLib With dDataBase
		Replace SCR->CR_STATUS  With "04"  //Bloqueado
		Replace SCR->CR_OBS     With Alltrim(oProcess:oHtml:RetByName('lbmotivo'))
		MsUnLock()
	EndIf
	
	ConOut('**************** >> EMAIL INFORMATIVO DE REJEICAO ')
	//U_WFW120P(.T.)
	
	Return .T.
EndIf

//Acerto o pedido
oProcess:Track("100500",,"","APROVACAO")
dbselectarea("SC7")
DBSETORDER(1)
DBSeek(xFilial("SC7")+cNumero)      // Posiciona o Pedido

ConOut("[002]**************[ APROVACAO DO PEDIDO "+SC7->C7_NUM+" ]********************")

DBSelectarea("SCR")                   // Posiciona a Liberacao
DBSetorder(2)
DBSeek(xFilial("SCR")+"PC" + cNumSCR + ca097User)

U_xLibera2(cNumero,SCR->(RECNO()),,_cRetInf)

dbSelectArea('SC7')
dbSetOrder(1)
dbSeek(xFilial('SC7')+cNumero)

oProcess:Track("100700",,"","TERMINADO")
                                                                    
ConOut("[999]**************[ FIM - RETORNO WF ]********************")

Return .T.                                                                

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ºWFW120Pº Autor º Gustavo Markx    º Data ³  01/02/2014      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³Ponto de Entrada na Confirmação do Pedido de Compra, onde   º±±
±±º          ³verifica o grupo de aprovação e prepara o Wf de envio e     º±±
±±º          ³retorno, disparando para o proximo até finalizar a alçada.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nil                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*-------------------------------------------*
User Function INI_PC2(oProcess,nAt, cMailTo)
*-------------------------------------------*
Local aUser := AllUsers()
Local aCond:={},nTotal := 0,_nVlDesc:=0,cMailID,cSubject ,nfrete := 0, nipi := 0, NVALICMS := 0,NDESPESA:=0,NSEGURO:=0,NBASEICMS:= 0

oProcess:Track("100300",,"","ENVIAR MENSAGEM")
oProcess:cSubject := "Aprovacao de Pedido de Compra"
oProcess:bReturn := "U_RET_PC2"
oProcess:bTimeOut := {{"U_TIME_PC2(1)",0, 2, 2 },{"U_TIME_PC2(2)",0, 2, 4 }}

cSubject := "APROVACAO DO PEDIDO No " + SC7->C7_NUM

// Preenche os dados do cabecalho
oProcess:oHtml:ValByName( "EMISSAO"   , SC7->C7_EMISSAO )
oProcess:oHtml:ValByName( "FORNECEDOR", SC7->C7_FORNECE+'/'+SC7->C7_LOJA+' - '+Alltrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")) )

dbSelectArea('SA2')
dbSetOrder(1)
dbSeek(xFilial('SA2')+SC7->C7_FORNECE)

//Pego a condicao de Pagamento
dbSelectArea('SE4')
dbSeek(xFilial('SE4')+SC7->C7_COND)

//Buscar o nome do Comprador
N := ASCAN(aUser, {|x| x[1,1] = SC7->C7_USER })
If n > 0
	cNomeComp:= aUser[n,1,4]
Else
	cNomeComp:= 'Nao identificado'
endif

SCR->(dbGoTo(nRecnoSCR))
oProcess:oHtml:ValByName( "USUARIO"   , cNomeComp )

oProcess:oHtml:ValByName( "c7aprova",SCR->CR_USER )
//oProcess:oHtml:ValByName( "c7nomaprova",cNomeApr )

//oProcess:oHtml:ValByName( "lb_nome", SA2->A2_NOME )
oProcess:oHtml:ValByName( "lb_cond", SC7->C7_COND+' - '+Alltrim(SE4->E4_DESCRI) )

//oProcess:oHtml:ValByName( "lbwfpco",'SC7->C7_XWFPCO')
                   
a111      := 0	
dbSelectArea('SC7')
oProcess:oHtml:ValByName( "PEDIDO", SC7->C7_NUM )
cNum := SC7->C7_NUM
oProcess:fDesc := "Pedido de Compras No "+ cNum
cAssunto := "Pedido de Compras No "+ cNum
dbSetOrder(1)
IF dbSeek(xFilial('SC7')+cNum)
	cAntC7NumCot	:=	SC7->C7_NUMCOT	// ARMAZENA PARA UTILIZAR NAS INFORMACOES DA COTACAO
	While !Eof() .And. SC7->C7_NUM = cNum
		_nVlBudG  := 0
        _nSlBudG  := 0
		nTotal 	  := nTotal   + SC7->C7_TOTAL
		nfrete 	  := nfrete	  + SC7->C7_VALFRE
		nIpi   	  := nIPI     + SC7->C7_VALIPI
		nValICMS  := nValIcms + SC7->C7_VALICM
		nDespesa  := nDespesa + SC7->C7_DESPESA
		nSeguro   := nSeguro  + SC7->C7_SEGURO
		nBaseIcms := nBaseIcms+ SC7->C7_BASEICMS
		_nVlDesc  := _nVlDesc + SC7->C7_VLDESC
		
		dbSelectArea('SB1')
		dbSetOrder(1)
		dbSeek(xFilial('SB1')+SC7->C7_PRODUTO)
		dbSelectArea('SC7')

			AAdd( (oProcess:oHtml:ValByName( "produto.item" )),SC7->C7_ITEM )
			AAdd( (oProcess:oHtml:ValByName( "produto.codigo" )),SC7->C7_PRODUTO )
			
			AAdd( (oProcess:oHtml:ValByName( "produto.descricao" )),SC7->C7_DESCRI ) 
			AAdd( (oProcess:oHtml:ValByName( "produto.unid" )),SB1->B1_UM )
						
			AAdd( (oProcess:oHtml:ValByName( "produto.quant" )),TRANSFORM( SC7->C7_QUANT,'@E 999,999.9999' ) )
			AAdd( (oProcess:oHtml:ValByName( "produto.preco" )),TRANSFORM( SC7->C7_PRECO,'@E 999,999,999.9999' ) )		
			AAdd( (oProcess:oHtml:ValByName( "produto.total" )),TRANSFORM((SC7->C7_TOTAL-SC7->C7_VLDESC),'@E 999,999,999.9999' ) )

			AAdd( (oProcess:oHtml:ValByName( "produto.entrega" )),DTOC(SC7->C7_DATPRF) )
			
 		
		WFSalvaID('SC7','C7_WFID',oProcess:fProcessID)
		
		If a111 == 0					
			dVencPr  := dDataBase//SC7->C7_XDTVENC			
			a111 := 1
		Endif
		
		dbSkip()
	Enddo
	
ENDIF		//IF dbSeek(xFilial('SC7')+cNum)

//oProcess:oHtml:ValByName( "DATA DE VENCIMENTO PREVISTO: " + Transform(dVencPr,"@D" ) )
//oProcess:oHtml:ValByName( "" )

oProcess:oHtml:ValByName( "lbValor"   ,TRANSFORM( nTotal,  '@E 999,999,999.9999' ) )
oProcess:oHtml:ValByName( "lbDespesa" ,TRANSFORM( nDespesa,'@E 999,999,999.9999' ) )
oProcess:oHtml:ValByName( "lbSeguro"  ,TRANSFORM( nSeguro ,'@E 999,999,999.9999' ) )
oProcess:oHtml:ValByName( "lbIpi"     ,TRANSFORM( nIPI    ,'@E 999,999,999.9999' ) )
oProcess:oHtml:ValByName( "lbIcms"    ,TRANSFORM( nValIcms,'@E 999,999,999.9999' ) )
oProcess:oHtml:ValByName( "lbFrete"   ,TRANSFORM( nFrete  ,'@E 999,999,999.9999' ) )

_nVlrTotal := (( nTotal + nDespesa + nSeguro + nIPI + nFrete ) - _nVlDesc)
oProcess:oHtml:ValByName( "lbTotal"   ,TRANSFORM( _nVlrTotal,'@E 999,999,999.9999' ) )                                                 

oProcess:ClientName( Subs(cUsuario,7,15) )
oProcess:UserSiga:=WFCodUser( SUBSTR(cUsuario,7,15))
oProcess:cTo := "PEDCOM1" // "kadrekes@hotmail.com"
//oProcess:cTo := "brandao@coel.com.br"//"PEDCOM"
// monta um processo para cada aprovador 
cMailId := oProcess:Start("\workflow\messenger\emp"+cEmpAnt+"\pedcom")

cHtmlModelo := "/workflow/wflink.htm"

oProcess:NewTask(cAssunto, cHtmlModelo)

oProcess:cSubject := cAssunto


oProcess:cto := "PEDCOM1" //"kadrekes@hotmail.com"
//oProcess:cto := "brandao@coel.com.br" //'pedcom'

oProcess:oHtml:ValByName("usuario","usuario")


CONOUT(GetEnvServer())

//oProcess:oHtml:ValByName("proc_link","http://microsiga:8099/messenger/emp"+cempant+"/pedcom/"+ cMailID + ".htm")
//oProcess:oHtml:ValByName("proc_link","http://localhost:8090/workflow/messenger/emp"+cempant+"/pedcom/"+ cMailID + ".htm")
oProcess:oHtml:ValByName("proc_link","http://189.42.140.163:8090/messenger/emp"+cempant+"/pedcom/"+ cMailID + ".htm")
//oProcess:oHtml:ValByName("proc_link","http://192.168.10.83:8090/messenger/emp"+cempant+"/pedcom/"+ cMailID + ".htm")


If !Empty(cmailto)
	oProcess:cTo :=  ALLTRIM(CMAILTO)//xRastLib(cNum)//'gustavo.oliveira@meliora.com.br;gmarkx.oli@gmail.com' //cMailto 
	ConOut("**************** @@ E-Mail para:  "+cMailto )
ELSE
	oProcess:cTo := cMailSuporte
	ConOut("**************** @@ E-Mail para:  "+cMailSuporte )
ENDIF

oProcess:cCC := "brandao@coel.com.br" //"rbosp@terra.com.br"
oProcess:oHtml:ValByName("referente",cAssunto)

// Apos ter repassado todas as informacoes necessarias para o workflow, solicite a
// a ser executado o método Start() para se gerado todo processo e enviar a mensagem
// ao destinatário.
oProcess:Start()


Return .T.


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ºWFW120Pº Autor º Gustavo Markx    º Data ³  01/02/2014      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³Ponto de Entrada na Confirmação do Pedido de Compra, onde   º±±
±±º          ³verifica o grupo de aprovação e prepara o Wf de envio e     º±±
±±º          ³retorno, disparando para o proximo até finalizar a alçada.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nil                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/                     
*------------------------------*
Static Function xRastLib(_cPedPc)                   
*------------------------------*
Local _cMail := ''
Local _BkSCR := SCR->(RECNO())
Local _aArea := GetArea()
Local aUser  := AllUsers()

DbSelectArea('SC7')
SC7->(DBSETORDER(1))
IF SC7->(dbSeek(xFilial('SC7')+_cPedPc))
	DBSelectarea("SCR")
	DBSetorder(1)
	If DBSeek(xFilial("SCR")+"PC" + SC7->C7_NUM )
		While SCR->(!Eof())
			If SCR->CR_STATUS == "02"
				IF (_nLb:= ASCAN(aUser, {|x| x[1,1] == SCR->CR_USER })) > 0
					IF !Empty(aUser[_nLb,1,14])
						_cMail += AllTrim(aUser[_nLb,1,14])+';'
					ENDIF
				Endif
			EndIf
			SCR->(DbSkip())
		EndDo
	EndIF
EndIF

IF Empty(_cMail)
	_cMail := cMailto
Else 
	_cMail := SubStr(_cMail,01,Len(_cMail)-1)
EndIF

DbSelectArea('SCR')
SCR->(DbGoTo(_BkSCR))
RestArea(_aArea)

Return(_cMail)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ºWFW120Pº Autor º Gustavo Markx    º Data ³  01/02/2014      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³Ponto de Entrada na Confirmação do Pedido de Compra, onde   º±±
±±º          ³verifica o grupo de aprovação e prepara o Wf de envio e     º±±
±±º          ³retorno, disparando para o proximo até finalizar a alçada.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nil                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// FUNCAO DE APROVACAO DO PEDIDO DE COMPRAS
*----------------------------------------------*
User Function  XLibera2(cPedido,nRegSCR,xPrUser,_cRetInf)
*----------------------------------------------*
Local aRetSaldo := {}
Local nSaldo    := 0
Local nTotal    := 0
Local lNovoAprov := .f.
Local aUser     := AllUsers()

Default _cRetInf := ''

dbSelectArea('SC7')
dbSetOrder(1)
dbSeek(xFilial('SC7')+cPedido)

dbSelectArea('SCR')
dbSetOrder(1)
SCR->(dbGoTo(nRegSCR))

ConOut("[003]**************[ INI: MaAlcDoc ]********************")

_lOK := MaAlcDoc({SCR->CR_NUM,"PC",SCR->CR_TOTAL,SCR->CR_APROV,,SC7->C7_APROV},dDatabase,4,nRegSCR) //atualiza os dados das alcadas
//cGrupo := SC7->C7_APROV
ConOut("[009]**************[ FIM: MaAlcDoc ]********************")
// Somente será usado quando o POnto de entrada MT097END for utilizado, esse ponto é para caso a aprovação do pedido for
// feita pelo protheus, ele crie o processo para o aprovador seguinte.
If xPrUser # Nil
	SCR->(DbClearFilter())
EndIf

ConOut("[010]**************[ VERIFICA SE EXISTE MAIS APROVACOES ]********************")
//DBUSearea("SCR")
//VERIFICA SE EXISTE MAIS APROVACOES
dbSelectArea('SCR')
DBSetorder(1)	//2)
If DBSeek(xFilial("SCR")+"PC" + cPedido )
	While !eof() .and. SCR->(CR_FILIAL+"PC"+CR_NUM) = xFilial("SCR")+"PC" + cPedido
		If SCR->CR_STATUS = "02"
			//Renato em 12/04 - na SupportComm , usuario visto não eh aprovador, ignora entao
			//AL_FILIAL+AL_COD+AL_APROV
			// C7_APROV = GRUPO DE APROVADORES , CR_APROV = CODIGO DO APROVADOR
			IF POSICIONE("SAL",3,XFILIAL("SAL")+SC7->C7_APROV+SCR->CR_APROV,"AL_LIBAPR") <> "V"
				lNovoAprov := .T.
			ENDIF
		EndIf
		SCR->(DBSKIP())
	EndDo
EndIf

//[##]VOLTAR
//lNovoAprov := .F.

If lNovoAprov
	dbselectarea("SC7")
	DBSETORDER(1)
	DBSeek(xFilial("SC7")+cPedido)      // Posiciona o Pedido
	ConOut("[011]**************[ Vai executar a nova liberacao ]********************")
	//U_WFW120P(lNovoAprov)	//INICIA OUTRO PROCESSO 
	U_x2WFW120P(_cRetInf)	//INICIA OUTRO PROCESSO
	
Else
	ConOut("[012]**************[ Vai liberar o Pedido de Compra ]********************")
	dbSelectArea('SC7')
	dbSetOrder(1)
	dbSeek(xFilial('SC7')+cPedido)
	While !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedido
		Reclock("SC7",.F.)
			SC7->C7_CONAPRO := "L"
		MsUnlock()
		dbSkip()
	EndDo
	// Envia e-mail para aprovadores tipo "Visto"
	ConOut("[013]**************[ >> EMAIL INFORMATIVO DA APROVACAO (VISTO) ]********************")
	ENV_PC_VISTO(aUser, cPedido)	
Endif

ConOut("[018]**************[ >> EMAIL INFORMATIVO DE CONFIRMACAO) ]********************")
// U_WFW120P(.T.,.T.)

Return .T.


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ºWFW120Pº Autor º Gustavo Markx    º Data ³  01/02/2014      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³Ponto de Entrada na Confirmação do Pedido de Compra, onde   º±±
±±º          ³verifica o grupo de aprovação e prepara o Wf de envio e     º±±
±±º          ³retorno, disparando para o proximo até finalizar a alçada.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nil                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*--------------------------------------*
User Function TIME_PC2(n,oProcess)
*--------------------------------------*
ConOut("Executando TimeOut:"+Str(n))
Return .T.


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ºWFW120Pº Autor º Gustavo Markx    º Data ³  01/02/2014      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³Ponto de Entrada na Confirmação do Pedido de Compra, onde   º±±
±±º          ³verifica o grupo de aprovação e prepara o Wf de envio e     º±±
±±º          ³retorno, disparando para o proximo até finalizar a alçada.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nil                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*-----------------------------------------------------------------------*
Static Function MaAlcDoc(aDocto,dDataRef,nOper,nRegSCR,cDocSF1,lResiduo) 
*-----------------------------------------------------------------------*

Local cDocto := aDocto[1]
Local cTipoDoc := aDocto[2]
Local nValDcto := aDocto[3]
Local cAprov := If(aDocto[4]==Nil,"",aDocto[4])
Local cUsuario := If(aDocto[5]==Nil,"",aDocto[5])
Local nMoeDcto := If(Len(aDocto)>7,If(aDocto[8]==Nil, 1,aDocto[8]),1)
Local nTxMoeda := If(Len(aDocto)>8,If(aDocto[9]==Nil, 0,aDocto[9]),0)
Local cObs      := If(Len(aDocto)>10,If(aDocto[11]==Nil, "",aDocto[11]),"")
Local aArea  := GetArea()
Local aAreaSCS := SCS->(GetArea())
Local aAreaSCR := SCR->(GetArea())
Local aRetPe := {}
Local nSaldo := 0
Local cGrupo := If(aDocto[6]==Nil,"",aDocto[6])
Local lFirstNiv:= .T.
Local cAuxNivel:= ""
Local cNextNiv := ""
Local cNivIgual:= ""
Local cStatusAnt:= ""
Local lAchou := .F.
Local nRec  := 0
Local lRetorno := .T.
Local aSaldo := {}
Local aMTALCGRU := {}
Local lDeletou := .F.
Local dDataLib := IIF(dDataRef==Nil,dDataBase,dDataRef)
DEFAULT dDataRef := dDataBase
DEFAULT cDocSF1 := cDocto
DEFAULT lResiduo := .F.
cDocto := cDocto+Space(Len(SCR->CR_NUM)-Len(cDocto))
cDocSF1:= cDocSF1+Space(Len(SCR->CR_NUM)-Len(cDocSF1))

If lRetorno
	
	If Empty(cUsuario) .And. (nOper != 1 .And. nOper != 6) //nao e inclusao ou estorno de liberacao
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSeek(xFilial()+cAprov)
		cUsuario := AK_USER
		nMoeDcto := AK_MOEDA
		nTxMoeda := 0
	EndIf
	
	If nOper == 1  //Inclusao do Documento
		cGrupo := If(!Empty(aDocto[6]),aDocto[6],cGrupo)
		dbSelectArea("SAL")
		dbSetOrder(2)
		If !Empty(cGrupo) .And. dbSeek(xFilial()+cGrupo)
			While !Eof() .And. xFilial("SAL")+cGrupo == AL_FILIAL+AL_COD
				
				If cTipoDoc <> "NF"
					If SAL->AL_AUTOLIM == "S" .And. !MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda)
						dbSelectArea("SAL")
						dbSkip()
						Loop
					EndIf
				EndIf
				
				If lFirstNiv
					cAuxNivel := SAL->AL_NIVEL
					lFirstNiv := .F.
				EndIf
				
				Do Case
					Case cTipoDoc == "NF"
						SF1->(FkCommit())
					Case cTipoDoc == "PC" .Or.cTipoDoc == "AE"
						SC7->(FkCommit())
					Case cTipoDoc == "CP"
						SC3->(FkCommit())
					Case cTipoDoc == "SC"
						SC1->(FkCommit())
					Case cTipoDoc == "CO"
						SC8->(FkCommit())
					Case cTipoDoc == "MD"
						CND->(FkCommit())
				EndCase
				ConOut("[004]**************[ MaAlcDoc:001 - SCR ]********************")
				Reclock("SCR",.T.)
				SCR->CR_FILIAL := xFilial("SCR")
				SCR->CR_NUM  := cDocto
				SCR->CR_TIPO := cTipoDoc
				SCR->CR_NIVEL := SAL->AL_NIVEL
				SCR->CR_USER := SAL->AL_USER
				SCR->CR_APROV := SAL->AL_APROV
				SCR->CR_STATUS := IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
				SCR->CR_TOTAL := nValDcto
				SCR->CR_EMISSAO:= aDocto[10]
				SCR->CR_MOEDA := nMoeDcto
				SCR->CR_TXMOEDA:= nTxMoeda
				MsUnlock()
				dbSelectArea("SAL")
				dbSkip()
			EndDo
		EndIf
		lRetorno := lFirstNiv
	EndIf
	If nOper == 2  //Transferencia da Alcada para o Superior
		//dbSelectArea("SCR")
		//dbSetOrder(1)
		//dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
		// O SCR deve estar posicionado, para que seja transferido o atual para o Superior
		If !Eof() .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SCR")+cTipoDoc+cDocto
			// Carrega dados do Registro a ser tranferido e exclui
			cTipoDoc := SCR->CR_TIPO
			cAuxNivel:= SCR->CR_STATUS
			nValDcto := SCR->CR_TOTAL
			cUsuario := SAK->AK_USER
			nMoeDcto := SAK->AK_MOEDA
			cNextNiv := SCR->CR_NIVEL
			nTxMoeda := SCR->CR_TXMOEDA
			dDataRef := SCR->CR_EMISSAO
			Reclock("SCR",.F.,.T.)
			dbDelete()
			MsUnlock()
			// Inclui Registro para Aprovador Superior
			ConOut("[005]**************[ MaAlcDoc:002 - SCR ]********************")
			Reclock("SCR",.T.)
			SCR->CR_FILIAL := xFilial("SCR")
			SCR->CR_NUM  := cDocto
			SCR->CR_TIPO := cTipoDoc
			SCR->CR_NIVEL := cNextNiv
			SCR->CR_USER := cUsuario
			SCR->CR_APROV := cAprov
			SCR->CR_STATUS := cAuxNivel
			SCR->CR_TOTAL := nValDcto
			SCR->CR_EMISSAO:= dDataRef
			SCR->CR_MOEDA := nMoeDcto
			SCR->CR_TXMOEDA:= nTxMoeda
			SCR->CR_OBS  := cObs
			MsUnlock()
		EndIf
		lRetorno := .T.
	EndIf
	If nOper == 3  //exclusao do documento
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSelectArea("SCR")
		dbSetOrder(1)
		dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Efetua uma nova busca caso o cDocto nao for encontrado no SCR³
		//³ pois seu conteudo em caso de NF foi alterado para chave unica³
		//³ do SF1, o cDocSF1 sera a busca alternativa com o conteudo ori³
		//³ ginal do lancamento da versao que poderia causar duplicidades³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SCR->( Eof() ) .And. cTipoDoc == "NF"
			dbSeek(xFilial("SCR")+cTipoDoc+cDocSF1)
			cDocto := cDocSF1
		EndIf
		
		While !Eof() .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SCR")+cTipoDoc+cDocto
			If SCR->CR_STATUS == "03"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Reposiciona o usuario aprovador.               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SAK")
				dbSeek(xFilial("SAK")+SCR->CR_LIBAPRO)
				dbSelectArea("SAL")
				dbSetOrder(3)
				dbSeek(xFilial("SAL")+cGrupo+SAK->AK_COD)
				If SAL->AL_LIBAPR == "A"
					dbSelectArea("SCS")
					dbSetOrder(2)                                            
					If dbSeek(xFilial("SCS")+SAK->AK_COD+DTOS(MaAlcDtRef(SCR->CR_LIBAPRO,SCR->CR_DATALIB,SCR->CR_TIPOLIM)))
						RecLock("SCS",.F.)
						SCS->CS_SALDO := SCS->CS_SALDO + SCR->CR_VALLIB
						MsUnlock()
					EndIf
				EndIf
			EndIf
			Reclock("SCR",.F.,.T.)
			dbDelete()
			MsUnlock()
			dbSkip()
		EndDo
	EndIf
	If nOper == 4 //Aprovacao do documento
		
		dbSelectArea("SCS")
		dbSetOrder(2)
		aSaldo := MaSalAlc(cAprov,dDataRef,.T.)
		nSaldo  := aSaldo[1]
		dDataRef := aSaldo[3]
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o saldo do aprovador.                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSeek(xFilial("SAK")+cAprov)
		dbSelectArea("SAL")
		dbSetOrder(3)
		dbSeek(xFilial("SAL")+cGrupo+cAprov)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Libera o pedido pelo aprovador.                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SCR")
		dbSetOrder(1)
		SCR->(dbGoTo(nRegSCR))
		cAuxNivel := CR_NIVEL
		ConOut("[006]**************[ MaAlcDoc:003 - SCR ]********************")
		Reclock("SCR",.F.)
		CR_STATUS  := "03"
		CR_OBS     := cObs
		CR_DATALIB := dDataLib
		CR_USERLIB := SAK->AK_USER
		CR_LIBAPRO := SAK->AK_COD
		CR_VALLIB  := nValDcto
		CR_TIPOLIM := SAK->AK_TIPO
		MsUnlock()
		
		dbSeek(xFilial("SCR")+cTipoDoc+cDocto+cAuxNivel)
		nRec := RecNo()
		While !Eof() .And. xFilial("SCR")+cDocto+cTipoDoc == CR_FILIAL+CR_NUM+CR_TIPO
			If cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"U "
				Exit
			EndIf
			ConOut("[007]**************[ MaAlcDoc:004 - SCR ]********************")
			If cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"NP"
				Reclock("SCR",.F.)
				CR_STATUS := "05"
				CR_DATALIB := dDataLib
				CR_USERLIB := SAK->AK_USER
				CR_APROV  := cAprov
				MsUnlock()
			EndIf
			If CR_NIVEL > cAuxNivel .And. CR_STATUS != "03" .And. !lAchou
				lAchou := .T.
				cNextNiv := CR_NIVEL
			EndIf
			If lAchou .And. CR_NIVEL == cNextNiv .And. CR_STATUS != "03"
				Reclock("SCR",.F.)
				CR_STATUS := If(SAL->AL_TPLIBER=="P","05",;
				iIf(( Empty(cNivIgual) .Or. cNivIgual == CR_NIVEL ) .And. cStatusAnt <> "01" ,"02",CR_STATUS))
				
				If CR_STATUS == "05"
					CR_DATALIB := dDataLib
				EndIf
				MsUnlock()
				cNivIgual := CR_NIVEL
				lAchou    := .F.
			Endif
			
			cStatusAnt := SCR->CR_STATUS
			
			dbSkip()
		End
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Reposiciona e verifica se ja esta totalmente liberado.       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbGoto(nRec)
		While !Eof() .And. xFilial("SCR")+cTipoDoc+cDocto == CR_FILIAL+CR_TIPO+CR_NUM
			If CR_STATUS != "03" .And. CR_STATUS != "05"
				lRetorno := .F.
			EndIf
			dbSkip()
		EndDo
		
		If SAL->AL_LIBAPR == "A"
			dbSelectArea("SCS")
			If dbSeek(xFilial()+cAprov+dToS(dDataRef))
				Reclock("SCS",.F.)
			Else
				Reclock("SCS",.T.)
			EndIf
			CS_FILIAL:= xFilial("SCS")
			CS_SALDO := CS_SALDO - nValDcto
			CS_APROV := cAprov
			CS_USER := cUsuario
			CS_MOEDA := nMoeDcto
			CS_DATA := dDataRef
			MsUnlock()
		EndIf
	EndIf
	If nOper == 5  //Estorno da Aprovacao
		cGrupo := If(!Empty(aDocto[6]),aDocto[6],cGrupo)
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSelectArea("SCR")
		dbSetOrder(1)
		dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
		nMoeDcto := SCR->CR_MOEDA
		nTxMoeda := SCR->CR_TXMOEDA
		While !Eof() .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SCR")+cTipoDoc+cDocto
			If SCR->CR_STATUS == "03"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Reposiciona o usuario aprovador.               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SAK")
				dbSeek(xFilial("SAK")+SCR->CR_LIBAPRO)
				dbSelectArea("SAL")
				dbSetOrder(3)
				dbSeek(xFilial("SAL")+cGrupo+SAK->AK_COD)
				If SAL->AL_LIBAPR == "A"
					dbSelectArea("SCS")
					dbSetOrder(2)
					If dbSeek(xFilial("SCS")+SAK->AK_COD+DTOS(MaAlcDtRef(SAK->AK_COD,SCR->CR_DATALIB)))
						RecLock("SCS",.F.)
						SCS->CS_SALDO := SCS->CS_SALDO + If(nValDcto>0 .And. nValDcto < SCR->CR_VALLIB,nValDcto,SCR->CR_VALLIB)
						If SCS->CS_SALDO > SAK->AK_LIMITE
							SCS->CS_SALDO := SAK->AK_LIMITE
						EndIf
						MsUnlock()
					EndIf
				EndIf
			EndIf
			Reclock("SCR",.F.,.T.)
			If nValDcto > 0 .And. nValDcto < SCR->CR_TOTAL
				SCR->CR_TOTAL := SCR->CR_TOTAL - nValDcto
				SCR->CR_VALLIB := SCR->CR_VALLIB - nValDcto
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³A variavel lResiduo informa se devera ou nao reconstituir um  ³
				//³novo bloqueio SCR  se ainda houver saldo apos a eliminacao de ³
				//³residuos, em caso da opcao de estorno a recosntituicao do SCR ³
				//³e obrigatoria, apos a delecao.                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lResiduo
					lDeletou := IF(SCR->CR_TOTAL - nValDcto > 0,.T.,.F.)
				Else
					lDeletou := .T.
				EndIf
				dbDelete()
			EndIf
			MsUnlock()
			dbSkip()
		EndDo
		
		dbSelectArea("SAL")
		dbSetOrder(2)
		If (!Empty(cGrupo) .And. dbSeek(xFilial("SAL")+cGrupo) .And. nValDcto > 0 .And. lDeletou) .Or. ;
			(!Empty(cGrupo) .And. dbSeek(xFilial("SAL")+cGrupo) .And. cTipoDoc == "NF" .And. lDeletou)
			
			While !Eof() .And. xFilial("SAL")+cGrupo == AL_FILIAL+AL_COD
				
				If cTipoDoc <> "NF"
					If SAL->AL_AUTOLIM == "S" .And. !MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda)
						dbSelectArea("SAL")
						dbSkip()
						Loop
					EndIf
				EndIf
				
				If lFirstNiv
					cAuxNivel := SAL->AL_NIVEL
					lFirstNiv := .F.
				EndIf
				_lNaoFaz:=.f.
				SC7->(DbSetOrder(1))
				If  SC7->(DbSeek(xFilial("SC7")+SCR->CR_NUM) .and. Empty(SC7->C7_NUMSC))
					_lNaoFaz:=.t.
				Endif
				
				Reclock("SCR",.T.)
				SCR->CR_FILIAL := xFilial("SCR")
				SCR->CR_NUM  := cDocto
				SCR->CR_TIPO := cTipoDoc
				SCR->CR_NIVEL := SAL->AL_NIVEL
				If !_lNaoFaz
					ConOut("[008]**************[ MaAlcDoc:005 - SCR ]********************")
					SCR->CR_USER := SAL->AL_USER
					SCR->CR_APROV := SAL->AL_APROV
				Endif
				SCR->CR_STATUS := IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
				SCR->CR_TOTAL := nValDcto
				SCR->CR_EMISSAO:= dDataRef
				SCR->CR_MOEDA := nMoeDcto
				SCR->CR_TXMOEDA:= nTxMoeda
				
				MsUnlock()
				dbSelectArea("SAL")
				dbSkip()
			EndDo
		EndIf
		lRetorno := lFirstNiv
	EndIf
	If nOper == 6  //Bloqueio manual
		Reclock("SCR",.F.)
		CR_STATUS := "04"
		CR_OBS  := If(Len(aDocto)>10,aDocto[11],"")
		CR_DATALIB:= dDataRef
		MsUnlock()
		lRetorno := .F.
	EndIf
	If ExistBlock("MTALCDOC")
		Execblock("MTALCDOC",.F.,.F.,{aDocto,dDataRef,nOper})
	Endif
EndIf

If ExistBlock("MTALCFIM")
	lCalculo := Execblock("MTALCFIM",.F.,.F.,{aDocto,dDataRef,nOper,cDocSF1,lResiduo})
	If Valtype( lCalculo ) == "L"
		lRetorno := lCalculo
	EndIf
Endif

dbSelectArea("SCR")
RestArea(aAreaSCR)
dbSelectArea("SCS")
RestArea(aAreaSCS)
RestArea(aArea)

Return(lRetorno)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄO8¿
//³ENVIO DE EMAIL PARA APROVADOR TIPO VISTO   ³
//³SOMENTE APOS APROVACAO DO PEDIDO DE COMPRAS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄO8Ù

*-------------------------------------------------*
STATIC FUNCTION ENV_PC_VISTO(aUser, cParNumPedido)
*-------------------------------------------------*
lOCAL cMailTo := "" 

//reposiciona no pedido
SC7->(DBSETORDER(1))
SC7->(dbSeek(xFilial('SC7')+cParNumPedido))

dbSelectArea("SAL")
dbSetOrder(2)
If !Empty(SC7->C7_APROV) .And. SAL->( dbSeek(xFilial()+SC7->C7_APROV))
	
	While ! SAL->( Eof()) .And. xFilial("SAL")+SC7->C7_APROV == AL_FILIAL+AL_COD
		
		IF SAL->AL_LIBAPR = "V" // VISTO			
			N := ASCAN(aUser, {|x| x[1,1] = SAL->AL_USER })
			If n > 0
				cMailTo	+= IIF(!EMPTY(cMailTo),";","")	// SE EXISTIR MAIS DE UM APROVADOR TIPO "VISTO"
				cMailTo	+= aUser[n,1,14]
				ConOut("[014]**************[ >> E-MAIL PARA: "+AllTrim(cMailTo)+" ]********************")
			ELSE  
				ConOut("[015]**************[ >> Email de retorno nao cadastrado ]********************")
			ENDIF			
		EndIF
		SAL->( DBSKIP())
	ENDDO
	
ENDIF

//Envia e-mail para usuario de Compras / Comprador
If (N := ASCAN(aUser, {|x| x[1,1] = SC7->C7_USER })) > 0								
	cMailTo	+= IIF(!EMPTY(cMailTo),";","")
	cMailTo	+= aUser[n,1,14]	
	ConOut("[016]**************[ >> E-MAIL PARA: "+AllTrim(cMailTo)+" ]********************")	
EndIF
			
// monta o Html do PC aprovador Visto
ConOut("[017]**************[ Monta HTML ]********************")
cXcTexto	:=	MontaHtml()


//[##] VOLTAR / Remover
//cMailTo := "gustavo.olivera@meliora.com.br"

// Envia
ConOut("[018]**************[ ENVIA EMAIL ]********************")
ConOut("[018B]**************[ >> E-MAIL PARA: "+AllTrim(cMailTo)+" ]********************") 
SendMail(.F., cMailTo,,cXcTexto,"APROVACAO DE PEDIDO DE COMPRAS Nº: "+SC7->C7_NUM, "")

RETURN NIL



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ºWFW120Pº Autor º Gustavo Markx    º Data ³  01/02/2014      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³Ponto de Entrada na Confirmação do Pedido de Compra, onde   º±±
±±º          ³verifica o grupo de aprovação e prepara o Wf de envio e     º±±
±±º          ³retorno, disparando para o proximo até finalizar a alçada.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nil                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄM A4¿
//³ENVIA E-MAIL                         ³
//³UTILIZA PARAMETROS DO PROTHEUS COM AS³
//³CONFIGURACOES DA CONTA.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄM A4Ù
*--------------------------------------------------------------------------*
Static FUNCTION SendMail(_lJob, cToEmail, xCC, xTEXTO, xASSUNTO, xcFileLogo)
*--------------------------------------------------------------------------*
Local lResulConn 	:= .T.
Local lResulSend 	:= .T.
Local cError 		:= ""

Local cServer 		:= AllTrim(GetMV("MV_RELSERV"))
Local cEmail 		:= AllTrim(GetMV("MV_RELACNT"))
Local cPass 		:= AllTrim(GetMV("MV_RELPSW"))
Local lRelauth 		:= GetMv("MV_RELAUTH")

//Local cServer   := "smtp.gmail.com:587"	 //smtp do email 587
Local cAccount  := "relatorios@coel.com.br"	             //colocar email de quem envia
//Local cEmail    := "relatorios@coel.com.br"	 //colocar email de quem envia
//Local cPass := "102030ab" 					//colocar senha de quem manda


Local cDe 			:= cEmail
Local cPara 		:= cToEmail
Local cCc 			:= xCC
Local cAssunto 		:= xASSUNTO
Local cMsg 			:= Space(200)
Local cStartPath	:= GetSrvProfString("Startpath","")
Local cAnexo 		:= xcFileLogo
Local lResult 		:= .T.

Default _lJob := .t.

cMsg := ""

//ENVIA ANEXO ATRAVES DO E-MAIL, CONSULTA ANEXOS VINCULADO AO PEDIDO DE VENDA ( BANCO DE CONHECIMENTO )
/*
_cDirDocs := MsDocPath()
_aArqSC7  := xBcCn('SC7', SC7->C7_FILIAL+SC7->C7_NUM+SC7->C7_ITEM)
For _nAnx:=1 To Len(_aArqSC7)
	_cArqPath := _cDirDocs+'\'+_aArqSC7[_nAnx]
	ConOut("**************** ANEXOS: "  +_cArqPath +"****************" )
	cAnexo := _cArqPath
Next _nAnx
*/

IF ! EMPTY( xTEXTO)
	cMsg += alltrim(xTEXTO)
ENDIF


cMsg += '</p><font face="Arial">'+ "Você está recebendo um e-mail do sistema Totvs Protheus. Favor nao responder esse e-mail" +'</font></p>'
CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn
If !lResulConn
	GET MAIL ERROR cError
	If _lJob
		ConOut(Padc("Falha na conexao "+cError,80))
	Else
		MsgAlert("Falha na conexao "+cError)
	Endif
	Return(.F.)
Endif
// Sintaxe: SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend
// Todos os e-mail terão: De, Para, Assunto e Mensagem, porém precisa analisar se tem: Com Cópia e/ou Anexo
If lRelauth
	lResult := MailAuth(Alltrim(cEmail), Alltrim(cPass))
	//Se nao conseguiu fazer a Autenticacao usando o E-mail completo, tenta fazera autenticacao usando apenas o nome de usuario do E-mail
	If !lResult
		nA := At("@",cEmail)
		cUser := If(nA>0,Subs(cEmail,1,nA-1),cEmail)
		lResult := MailAuth(Alltrim(cUser), Alltrim(cPass))
	Endif
Endif
If lResult
	If Empty(cCc) .And. Empty(cAnexo)
		SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg RESULT lResulSend
	Else
		If Empty(cCc) .And. !Empty(cAnexo)
			SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg	ATTACHMENT cAnexo RESULT lResulSend
		ElseIf !Empty(cCc) .And. !Empty(cAnexo)
			SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg	ATTACHMENT cAnexo RESULT lResulSend
		ElseIf Empty(cCc) .And. Empty(cAnexo)
			SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg RESULT lResulSend
		Endif
	Endif
	If !lResulSend
		GET MAIL ERROR cError
		If _lJob
			ConOut(Padc("Falha no Envio do e-mail "+cError,80))
		Else
			MsgAlert("Falha no Envio do e-mail " + cError)
		Endif
	Endif
Else
	If _lJob
		ConOut(Padc("Falha na autenticação do e-mail: "+cError,80))
	Else
		MsgAlert("Falha na autenticação do e-mail:" + cError)
	Endif
Endif
DISCONNECT SMTP SERVER
IF lResulSend
	If _lJob
		ConOut(Padc("E-mail enviado com sucesso",80))
	Else
		MsgInfo("E-mail enviado com sucesso" + cError)
	Endif
ENDIF
RETURN lResulSend



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ºWFW120Pº Autor º Gustavo Markx    º Data ³  01/02/2014      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³Ponto de Entrada na Confirmação do Pedido de Compra, onde   º±±
±±º          ³verifica o grupo de aprovação e prepara o Wf de envio e     º±±
±±º          ³retorno, disparando para o proximo até finalizar a alçada.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nil                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
//³ELABORA O  CORPO DO E-MAIL CONTENDO DADOS DO PEDIDO APROVADO        
*--------------------------*
Static Function MontaHtml()
*--------------------------*
Local	XcRetorno	 :=	""
Local	xPedido	     :=	SC7->C7_NUM
Local	nTotal       := 0
Local	nfrete       := 0
Local	nIpi         := 0
Local	nValICMS     := 0
Local	nDespesa     := 0
Local	nSeguro      := 0
Local	nBaseIcms    := 0
Local   _nVlrTotal   := 0

XcRetorno := ' <html> '+ENTER
XcRetorno += '<Pre>
XcRetorno += ' Pedido de Compras: '+SC7->C7_NUM+', encontra-se LIBERADO.'
XcRetorno += '</Pre>
XcRetorno += ' </html> '+ENTER

Return( XcRetorno)
                               
//===============================================================================================================
//===============================================================================================================
//===============================================================================================================
*-------------------------------------*
User Function x2WFW120P(_cRetInf)
*-------------------------------------*
Local oProcess  := Nil
Local lAprovado := .T.
Local xpedido   := SC7->C7_NUM
Local cxxpath   := GetPvProfString(getenvserver(),"ROOTPATH","ERROR", GETADV97())
Local n         := 0               
Local dVencPr   := Ctod("  /  /  ")

Local   aUser     := AllUsers() 
Default _cRetInf := ''
Private cmailto   := ''
Private nAt       := 1
Private cXmail    := ''
Private cNomeApr  := '' 
Private cMailSuporte := ''

Private nRecnoSCR := 0
Private _nVlBudget := 0
Private _nSLBudget := 0

CONOUT("____________________ NIVEL:.F.=02 ______________________")

CONOUT("____________________ "+ SC7->C7_NUM +" ______________________")


// Verifica se e necessario enviar e-mail de aprovacao do pedido de compras
SC7->(DBSETORDER(1))
SC7->(dbSeek(xFilial('SC7')+xPedido))
While ! SC7->(Eof()) .and. SC7->C7_NUM = xPedido .AND.  XFILIAL("SC7") = SC7->C7_FILIAL
	If   SC7->C7_CONAPRO <> 'L'
		lAprovado := .F.
		Exit
	Endif
	SC7->(DBSKIP())
EndDo
If lAprovado // Pedido esta totalmente aprovado e nao e necessario enviar workflow de aprovacao
	Return // sai da rotina de workflow
Endif
	
// -------------------------------------------------------------------------
//Monta a lista de e-mails dos aprovadores 

WF1->(DBSEEK(XFILIAL("WF1") + "PEDCOM" ))
// Monta a lista de Aprovadores  e e-mails
DBSelectarea("SCR")                   // Posiciona a Liberacao
DBSetorder(1)	//2)
If DBSeek(xFilial("SCR")+"PC" + xPedido )
	While !eof() .and. SCR->(CR_FILIAL+"PC"+CR_NUM) = xFilial("SCR")+"PC" + xPedido
		If SCR->CR_STATUS = "02"
			N := ASCAN(aUser, {|x| x[1,1] = SCR->CR_USER })
			If n > 0
				cMailTo := aUser[n,1,14]
				cNomeApr:= aUser[n,1,4]
				nRecnoSCR := SCR->(RECNO())
				
				_cRetInf += ENTER+"[HIST.:]"+DtoC(dDataBase)+'-'+SubStr(Time(),01,05)
				RecLock('SC7',.F.)
					//Replace SC7->C7_XWFPCO With _cRetInf
				SC7->(MsUnLock())
			endif
		EndIf
	SCR->(DbSkip())
	EndDo
Else
	cMailto := cMailSuporte
endif
If Empty(cMailto)
	cMailto := cMailSuporte
EndIF

CONOUT("**************** [X] Nome do Aprovador: "+cNomeApr)  

dbSelectArea('SC7')
dbSetOrder(1)
dbSeek(xFilial('SC7')+ xpedido)

ConOut("**************** Iniciando Processo - Aprovacao do Pedido "  +xpedido )

oProcess := TWFProcess():New( "PEDCOM", "Pedido de Compras" )

oProcess:NewTask( "Aprovação", "/workflow/WfAprovaPc.htm" )

oProcess:Track("100100",,"","PROCESSO")

oProcess:Track("100200",,"","DECISAO")

ConOut("**************** INI_PC **************** ")

U_INI_PC2(oProcess,nat,cMailto)

Return 