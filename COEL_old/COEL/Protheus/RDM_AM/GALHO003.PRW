#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"
#include "TOTVS.CH"
#include "ap5mail.ch"
#INCLUDE "TBICONN.CH"
#include "TbiCode.ch"
#Include "FONT.CH"                              

///#include "TmkMail.ch"

User Function GALHO003()

Local   aStru      := {}
Private aCampos    := {}
Private lParam     := .F.
Private cMarca     := GETMARK()
Private cPastaArq  := "\RELATO\NFE\"+SPACE(48)
Private lInverte   := .F.
Private dEmissao   := ddatabase
Private mEmissao   := CTOD("")
Private nSaida     := 0
Private nRegistros := 0
Private nTotReg    := 0
Private cTotais    := "Total de Notas Selecionados....: "+LTRIM(STR(nTotReg,4))
///Private cmPassw    := "$10203040"             
///Private cmAccount  := "NFE_MAO@COEL.COM.BR"

Private oDlg
Private oWBrowse
Private oBrowse
Private oButton1
Private oButton2
Private oGroup1,oGroup2
Private oSayData,oSayXml,oSayPass,oSayMail,oSayTotais
Private oEmissao,oXml,oPass,oMail

AADD(aStru,{"TB_OK"      , "C" , 02 , 0 } )
AADD(aStru,{"TB_DOC"     , "C" , 09 , 0 } )
AADD(aStru,{"TB_SERIE"   , "C" , 03 , 0 } )
AADD(aStru,{"TB_EMISSAO" , "D" , 08 , 0 } )
AADD(aStru,{"TB_HORA"    , "C" , 08 , 0 } )
AADD(aStru,{"TB_XML"     , "C" , 03 , 0 } )
AADD(aStru,{"TB_NRPROT"  , "C" , 40 , 0 } )
AADD(aStru,{"TB_CHAVE"   , "C" , 44 , 0 } )
AADD(aStru,{"TB_EMAIL"   , "C" , 150, 0 } )
AADD(aStru,{"TB_RAZSOC"  , "C" , 40 , 0 } )
AADD(aStru,{"TB_CGC"     , "C" , 18 , 0 } )
AADD(aStru,{"TB_EST"     , "C" , 02 , 0 } )
AADD(aStru,{"TB_TIPO"    , "C" , 03 , 0 } )
AADD(aStru,{"TB_TPMOV"   , "C" , 07 , 0 } )
AADD(aStru,{"TB_STAT"    , "C" , 03 , 0 } )
AADD(aStru,{"TB_IDENT"   , "C" , 06 , 0 } )
cArqTrab := CriaTrab(aStru,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.F.,.F.)
*
AADD(aCampos , { "TB_OK"      ,                     , "Ok"          } )
AADD(aCampos , { "TB_TPMOV"   ,                     , "Tipo"        } )
AADD(aCampos , { "TB_DOC"     ,                     , "N.Fiscal"    } )
AADD(aCampos , { "TB_SERIE"   ,                     , "Serie"       } )
AADD(aCampos , { "TB_EMISSAO" ,                     , "Emissão"     } )
AADD(aCampos , { "TB_HORA"    ,                     , "Hora"        } )
AADD(aCampos , { "TB_XML"     ,                     , "Xml?"        } )
AADD(aCampos , { "TB_RAZSOC"  ,                     , "Razão Social"} )
AADD(aCampos , { "TB_EST"     ,                     , "UF"          } )
AADD(aCampos , { "TB_CGC"     ,                     , "CPF/CNPJ"    } )
AADD(aCampos , { "TB_NRPROT"  ,                     , "Protocolo"   } )
AADD(aCampos , { "TB_CHAVE"   ,                     , "Chave"       } )
AADD(aCampos , { "TB_EMAIL"   ,                     , "e-mail"      } )
*
	dbSelectArea("TRB")

	DEFINE MSDIALOG oDlg TITLE "Envio Manual de arquivo eletrônico (.xml) da NF-e" FROM 000, 000  TO 440, 880           COLORS 0, 16777215           PIXEL

   @ 001, 003 GROUP oGroup1 TO 032, 340 PROMPT "Parametros"                                 OF oDlg                    COLOR 0, 16777215            PIXEL
   @ 034, 003 GROUP oGroup2 TO 200, 440 PROMPT "Notas Fiscais"                              OF oDlg                    COLOR 0, 16777215            PIXEL

   @ 009, 006 SAY   oSayData        PROMPT "Data Emissão"                     SIZE 060, 007 OF oDlg                    COLORS 16711680, 16777215    PIXEL
   @ 016, 006 MSGET oEmissao        VAR    dEmissao                           SIZE 060, 010 OF oDlg  VALID fl_Select() COLORS 0, 16777215           PIXEL 

   @ 009, 100 SAY   oSayXml         PROMPT "Pasta do arquivo"                 SIZE 060, 007 OF oDlg                    COLORS 16711680, 16777215    PIXEL
   @ 016, 100 MSGET oXml            VAR    cPastaArq                          SIZE 120, 010 OF oDlg                    COLORS 0, 16777215           PIXEL 

   //@ 009, 200 SAY   oSayMail        PROMPT "e-mail"                           SIZE 060, 007 OF oDlg                    COLORS 16711680, 16777215    PIXEL
   //@ 016, 200 MSGET oMail           VAR    cmAccount                          SIZE 080, 010 OF oDlg  VALID cSend $"12" COLORS 0, 16777215           PIXEL 

   //@ 009, 300 SAY   oSayPass        PROMPT "Senha"                            SIZE 060, 007 OF oDlg                    COLORS 16711680, 16777215    PIXEL
   //@ 016, 300 MSGET oPass           VAR    cmPassw                            SIZE 040, 010 OF oDlg  VALID cSend $"12" COLORS 0, 16777215           PIXEL 

   @ 203, 003 SAY    oSayTotais  PROMPT cTotais                               SIZE 100, 007 OF oDlg                    COLORS 255, 16777215         PIXEL

   @ 005, 344 BUTTON oButton1       PROMPT "Envia .xml"                       SIZE 050, 013 OF oDlg  Action IIF(lParam , Processa({||fl_EnviaXml()}) , Nil )    PIXEL
   @ 020, 344 BUTTON oButton2       PROMPT "Sair"                             SIZE 050, 013 OF oDlg  Action fl_Sair()                                           PIXEL

	oMark := MsSelect():New("TRB","TB_OK",,aCampos,@lInverte,@cMarca,{042,006,198,438})
   oMark:oBrowse:bldblclick := { || fl_Mark() }

   ACTIVATE MSDIALOG oDlg CENTERED VALID ( nSaida > 0 )

	TRB->(dbCloseArea())

Return

//------------------------------------------------
Static Function fl_Sair()
//------------------------------------------------
Local lxRsp := .T.

IF ( !EMPTY(mEmissao) .OR. lParam )
	lxRsp := APMsgYesNo("Lista pendente para Envio. Abandona assim mesmo?")
ENDIF
IF ( lxRsp )
   nSaida := 1
   oDlg:End()
ENDIF
Return

///////////////////////////////////////////////
Static Function fl_Mark()
///////////////////////////////////////////////
RecLock("TRB",.F.)
IF ( EMPTY(TRB->TB_OK) )
   nTotReg++
ELSE
	nTotReg--
ENDIF
TRB->TB_OK := IIF(EMPTY(TRB->TB_OK) , cMarca , "  " )
MsUnlock()
cTotais := "Total de Notas Selecionados....: "+LTRIM(STR(nTotReg,4))
oSayTotais:Refresh()

Return

//------------------------------------------------
Static Function fl_Select()
//------------------------------------------------
Local cLista
Local nCtd   := 0

IF ( EMPTY(dEmissao) )
   MsgStop("** Falta informar a data de emissão das notas fiscais.")
   Return
ENDIF
IF ( dEmissao == mEmissao )
	Return
ENDIF
dbSelectArea("TRB")
dbGoTop()
IF ( !EOF() )
	__dbZap()
ENDIF
///
///Monta a query para extrair os itens do inventario
///
cQry := "SELECT SP4.ID_ENT,SP4.NFE_ID,SP0.DATE_NFE,SP4.CSTAT_SEFR,SP0.DATE_ENFE,SP0.TIME_NFE,SP0.CNPJDEST,SP4.NFE_CHV,SP4.NFE_PROT,SP0.EMAIL,FT_TIPOMOV,FT_CLIEFOR,FT_LOJA,FT_TIPO "
cQry += "FROM SPED050 SP0,SPED054 SP4,"+RetSqlName("SFT")+" FT "  
cQry += "WHERE FT.D_E_L_E_T_ = ' ' "  
cQry += "AND   SP0.AMBIENTE   = 1 AND SP0.MODELO = '55' AND SP0.STATUSMAIL = 2 AND SP0.STATUS > 5 " //STATUSMAIL = 1
cQry += "AND   DATE_NFE   = '"+DTOS(dEmissao)+"' "
cQry += "AND   SP4.ID_ENT = SP0.ID_ENT "
cQry += "AND   SP4.NFE_ID = SP0.NFE_ID "
cQry += "AND   FT_FILIAL  = '"+xFilial("SFT")+"' "
///cQry += "AND   FT_OBSERV <> 'NF CANCELADA' "
cQry += "AND   FT_SERIE   = SUBSTRING(SP4.NFE_ID,1,3) "
cQry += "AND   FT_NFISCAL = SUBSTRING(SP4.NFE_ID,4,9) "
cQry += "AND   FT_ESPECIE = 'SPED' "
cQry += "AND   FT_ENTRADA = '"+DTOS(dEmissao)+"' "
cQry += "GROUP BY SP4.ID_ENT,SP4.NFE_ID,SP0.DATE_NFE,SP4.CSTAT_SEFR,SP0.DATE_ENFE,SP0.TIME_NFE,SP0.CNPJDEST,SP4.NFE_CHV,SP4.NFE_PROT,SP0.EMAIL,FT_TIPOMOV,FT_CLIEFOR,FT_LOJA,FT_TIPO "
cQry += "ORDER BY SP4.ID_ENT,SP4.NFE_ID,SP4.CSTAT_SEFR "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TB2', .T., .T.)

TcSetField("TB2","DATE_NFE","D",08,0)
TcSetField("TB2","DATE_ENFE","D",08,0)
*
nRegistros := 0
dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea("SA2")
dbSetOrder(1)
dbSelectArea("TB2")
dbGoTop()
DO WHILE !EOF()
   IncProc("Extraindo...")
	cCgc := RTRIM(TB2->CNPJDEST)
	IF ( EMPTY(cCgc).OR.LEN(cCgc) == 14 )
		cTipo := "CGC"
		cCgc  := IIF(!EMPTY(cCgc) , TRANSF(cCgc,"@R 99.999.999/9999-XX") , SPACE(14) )
	ELSE
		cTipo := "CPF"
		cCgc  := TRANSF(cCgc,"@R 999.999.999-99")
	ENDIF
	lFornece := IIF( ( TB2->FT_TIPOMOV=="E".AND.!TB2->FT_TIPO $ "BD" ).OR.( TB2->FT_TIPOMOV=="S".AND.TB2->FT_TIPO $ "BD" ) , .T. , .F. )
	IF ( !lFornece )
		SA1->(dbSeek(xFilial("SA1")+TB2->FT_CLIEFOR+TB2->FT_LOJA))
		mNome := SA1->A1_NOME
		mEst  := SA1->A1_EST
	ELSE
		SA2->(dbSeek(xFilial("SA2")+TB2->FT_CLIEFOR+TB2->FT_LOJA))
		mNome := SA2->A2_NOME
		mEst  := SA2->A2_EST
	ENDIF
	cLista := RTRIM(cPastaArq)
	cLista := STRTRAN(cLista,"/","\")
	nx     := RAT("\",cLista)
	cLista := IIF(nx==0 , cLista + "\" , cLista )
	cLista := cLista + TB2->NFE_CHV+IIF(TB2->CSTAT_SEFR=="100" , "-nfe.xml" , "-can.xml" )
	cLista := IIF(!FILE(cLista) , "Não" , "Sim" )
	*
	nRegistros++
	RecLock("TRB",.T.)
  	TRB->TB_OK      := cMarca
	TRB->TB_DOC     := SUBS(TB2->NFE_ID,4,9)              
	TRB->TB_SERIE   := SUBS(TB2->NFE_ID,1,3)
	TRB->TB_EMISSAO := TB2->DATE_NFE
	TRB->TB_HORA    := TB2->TIME_NFE
	TRB->TB_XML     := cLista
	TRB->TB_RAZSOC  := mNome
	TRB->TB_EST     := mEst
   TRB->TB_CGC     := cCgc          
	TRB->TB_TIPO    := cTipo
	TRB->TB_TPMOV   := IIF(TB2->FT_TIPOMOV=="E" , IIF(TB2->CSTAT_SEFR=="100","ENTRADA","ENT-CANC") , IIF(TB2->CSTAT_SEFR=="100","SAIDA","SAI-CANC") )
	TRB->TB_CHAVE   := TB2->NFE_CHV
	TRB->TB_STAT    := TB2->CSTAT_SEFR
  	TRB->TB_NRPROT  := TB2->NFE_PROT   
	TRB->TB_EMAIL   := LOWER(TB2->EMAIL)
	TRB->TB_IDENT   := TB2->ID_ENT
   MsUnlock()
	dbSelectArea("TB2")
  	dbSkip()
ENDDO
TB2->(dbCloseArea())
*
dbSelectArea("TRB")
dbGoTop()
IF ( nRegistros > 0 )
	lParam := .T.
	*
	oMark:oBrowse:GoTop()
	///oMark:oBrowse:SetFocus()
ELSE
	MsgInfo("-- Não existe(m) nota(s) para envio.")
ENDIF
mEmissao := dEmissao
nTotReg  := nRegistros
cTotais  := "Total de Notas Selecionados....: "+LTRIM(STR(nTotReg,4))
oSayTotais:Refresh()
oMark:oBrowse:Refresh()

Return

*******************************
Static Function fl_EnviaXml()
*******************************
Local   lRsp    
Local   nCtd       := 0 
Private cmServer   := "smtp.gmail.com:465"    ///GETMV("MV_WFSMTP") //200.242.114.170
Private cmAccount  := "relatorios@coel.com.br"   ///GETMV("MV_WFMAIL")   NFE_MAO@COEL.COM.BR
Private cmPassw    := "102030ab"             ///GETMV("MV_WFPASSW")  //GETMV("MV_RELPSW")   $10203040
Private cmSubject  := "NFe Nacional"

IF ( EMPTY(cPastaArq) )
	MsgStop("-- Falta informar a pasta onde se encontra o arquivo .xml")
	Return
ENDIF
		///
	   ///Envia e-mail para o Fiscal c/copia para TI, do arquivo enviado
		///
		dbSelectArea("TRB")
		dbGoTop()
		ProcRegua(nRegistros)
		DO WHILE !EOF()
			IncProc()
			IF ( !EMPTY(TRB->TB_OK).AND.!EMPTY(TRB->TB_EMAIL) )
				cNFiscal  := VAL(TRB->TB_DOC)
				cNFiscal  := LTRIM(TRANSF(cNFiscal,"@E 999999999"))
				cNFiscal  := RTRIM(TRB->TB_SERIE)+"/"+cNFiscal
				cmCgc     := IIF(TRB->TB_TIPO=="CGC","CNPJ","CPF")
				cmSubject := IIF(TRB->TB_STAT=="100", "NFe Nacional" , "NFe Nacional - Cancelamento" )
				
				cmBody := '<HTML><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml">'
				cmBody += '<head><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /><title>NFe Nacional</title><style type="text/css"> <!-- body {background-color: rgb(37, 64, 97);} .style1 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;} .style2 {font-family: '
				cmBody += 'Segoe UI,Verdana, Arial;font-size: 12pt;color: rgb(255,0,0)} .style3 {font-family: Segoe UI,Verdana, Arial;font-size: 10pt;color: rgb(37,64,97)} .style4 {font-size: 8pt; color: rgb(37,64,97); font-family: Segoe UI,Verdana, Arial;} .style5 {font-size: 10pt} -->   '
				cmBody += '</style></head><body><table style="background-color: rgb(240, 240, 240); width: 520px; text-align: left; margin-left: auto; margin-right: auto;" id="total" border="0" cellpadding="12">  <tbody>    <tr>      <td colspan="2">      '
				cmBody += '<p class="style1">Esta mensagem refere-se a Nota Fiscal Eletr&ocirc;nica Nacional de serie/n&uacute;mero ['
				cmBody += cNFiscal+'] emitida para:</p>      </td>    </tr>    <tr>      <td style="width: 250px; white-space: nowrap;">      <p class="style1">Raz&atilde;o Social:<br />'
				cmBody += cmCgc+':<br />      <br />      </p>      </td>      <td width="326">      <p class="style1">['
				cmBody += RTRIM(TRB->TB_RAZSOC)+"]<br />["
				cmBody += RTRIM(TRB->TB_CGC)+']				<br />      <br />      </p>      </td>    </tr>    <tr>      <td colspan="2">      '
				cmBody += '<p class="style1">Para verificar a autoriza&ccedil;&atilde;o da SEFAZ referente &agrave; nota acima mencionada, acesse o sitio <a href="http://www.nfe.fazenda.gov.br/portal"><span style="text-decoration: underline;">http://www.nfe.fazenda.gov.br/portal</span></a>'
				cmBody += '</p>      </td>    </tr>    <tr>      <td style="white-space: nowrap;">      <p class="style1">Chave de acesso:&nbsp;<br />Protocolo:</p>      </td>      <td><span class="style1">[NFe'
				cmBody += RTRIM(TRB->TB_CHAVE)+']<br />['+RTRIM(TRB->TB_NRPROT)+ '] </span>'
				cmBody += '</td>    </tr>    <tr>      <td colspan="2">      <p class="style1">Este e-mail foi enviado automaticamente pelo&nbsp;Sistema de Nota Fiscal Eletr&ocirc;nica (NF-e) da&nbsp;'
				cmBody += RTRIM(SM0->M0_NOMECOM)+'</p>      </td>    </tr>    <tr>      <td colspan="2" class="style4">'
				cmBody += '<span class="style5"><em><span style="text-decoration: underline;">powered by TotvsServices - Totvs S/A</span></em><em></em></span></td>    </tr>  </tbody></table><p class="style1">&nbsp;</p></body></html>'
								
				///cAttach := "\SYSTEM\AbrLvr.ini"   ///VALIDO: SOMENTE INFORMATIVO.

				///cAttach := "U:\ESTRCUS.TXT"    <--- INVALIDO

				cxPara := RTRIM(TRB->TB_EMAIL)   
				
				cLista := RTRIM(cPastaArq)
				cLista := STRTRAN(cLista,"/","\")
				nx     := RAT("\",cLista)
				cLista := IIF(nx==0 , cLista + "\" , cLista )
				cLista := cLista + TRB->TB_CHAVE+IIF(TRB->TB_STAT=="100" , "-nfe.xml" , "-can.xml" )

				IF ( !FILE(cLista) )
					MsgStop("** Não existe arquivo .xml para a Nota Fiscal "+RTRIM(TRB->TB_SERIE)+"/"+RTRIM(TRB->TB_DOC)+". Favor informar corretamente a pasta onde se encontra os arquivos .xml")
				ELSE
				
					lRsp := Send2_Mail()  
				
					IF ( !lRsp )
						MsgInfo("-- Nota Fiscal "+RTRIM(TRB->TB_SERIE)+"/"+RTRIM(TRB->TB_DOC)+" não enviada ao Cliente.")
					ELSE
						nCtd++
						///
						/// Altera o flag de STATUSMAIL de 1 para 2
						///
						cQry := "UPDATE SPED050 SET STATUSMAIL = 2 "
						cQry += "WHERE AMBIENTE = 1 AND MODELO = '55' AND STATUSMAIL = 2 AND STATUS > 5 " // STATUSMAIL = 1
						cQry += "AND   DATE_NFE   = '"+DTOS(dEmissao)+"' "
						cQry += "AND   LEFT(NFE_ID,12) = '"+TRB->TB_SERIE+TRB->TB_DOC+"' "
						cQry += "AND   ID_ENT = '"+TRB->TB_IDENT+"' "

						TCSQLEXEC(cQry)

					ENDIF	
					Inkey(2)
				ENDIF

			ENDIF
			dbSkip()
		ENDDO
		MsgInfo("Total de Notas enviadas: "+LTRIM(STR(nCtd,3)))
		nSaida := 1
		oDlg:End()

Return

/////////////////////////////////////////
Static Function Send1_Mail()
////////////////////////////////////////
Local lConectou  := .F.
Local lEnviado   := .F.
Local lDesConect := .F.
      
		CONNECT SMTP SERVER cmServer ;
		        ACCOUNT  cmAccount   ;
	   	     PASSWORD cmPassw     ;
	      	  Result lConectou

		IF ( lConectou )

		   SEND MAIL FROM cmAccount TO cxPara  ;
		   	       SUBJECT cmSubject         ;
						 BODY cmBody               ;
		         	 ATTACHMENT cLista         ;
						 RESULT lEnviado
      	          ///CC cxCC                   ;

   	   lConectou := lEnviado 

	   ELSE
		  	///
	   	///Extrai o resultado envio
	   	///
			GET MAIL ERROR cmMsgErr
   		///
		  	///Informa a mensagem de envio para o usuario
		  	///
			MsgAlert( "** Erro ao enviar o e-mail. Motivo: "+cmMsgErr )
	   ENDIF
   	///
		///Disconecta o servidor de SMTP
   	///
		DISCONNECT SMTP SERVER Result lDesConect

Return(lConectou)
 
////////////////////////////////
Static Function Send2_Mail()
////////////////////////////////
Local   oServer  := Nil
Local   oMessage := Nil
Local   nErr     := 0

   cPopAddr  := "pop.gmail.com"   ///cmServer               // Endereco do servidor POP3
   cSMTPAddr := "smtp.gmail.com"  ///cmServer               // Endereco do servidor SMTP
   cPOPPort  := 995  //110                    // Porta do servidor POP
   cSMTPPort := 465  //25                     // Porta do servidor SMTP
   cUser     := cmAccount              // Usuario que ira realizar a autenticacao
   cPass     := cmPassw                // Senha do usuario
   nSMTPTime := 10                     // Timeout SMTP

   // Instancia um novo TMailManager
   oServer := tMailManager():New()

   /// Usa SSL na conexao
   oServer:setUseSSL(.T.)

   // Inicializa
   ///oServer:init(cPopAddr, cSMTPAddr, cUser, cPass, cPOPPort, cSMTPPort)
   oServer:init("", cSMTPAddr, cUser, cPass, , cSMTPPort)

   // Define o Timeout SMTP
   If oServer:SetSMTPTimeout(nSMTPTime) != 0
   	msginfo("[ERROR]Falha ao definir timeout")
      return .F.
   Endif

   // Conecta ao servidor
   nErr := oServer:smtpConnect()
   If nErr <> 0
   	msginfo("[ERROR]Falha ao conectar: " + oServer:getErrorString(nErr))
      oServer:smtpDisconnect()
      return .F.
   Endif

   // Realiza autenticacao no servidor
   nErr := oServer:smtpAuth(cUser, cPass)

   If nErr <> 0
   	msginfo("[ERROR]Falha ao autenticar: " + oServer:getErrorString(nErr))
      oServer:smtpDisconnect()
      return .F.
   Endif

   // Cria uma nova mensagem (TMailMessage)
   oMessage := tMailMessage():new()
   oMessage:clear()
   oMessage:cFrom    := cmAccount
   oMessage:cTo      := cxPara
   //oMessage:cCC      := cxCC
   //oMessage:cBCC     := "bcc@example.com"
   oMessage:cSubject := cmSubject
   oMessage:cBody    := cmBody

	//Adiciona um attach
	If oMessage:AttachFile( cLista ) < 0
		msginfo( "Erro ao anexar o arquivo" )
		Return .F.
	Else
		//adiciona uma tag informando que é um attach e o nome do arq
		//oMessage:AddAtthTag( 'Content-Disposition: attachment; filename='+cLista)
		oMessage:AddAtthTag( cLista )
	EndIf

   // Envia a mensagem
   nErr := oMessage:send(oServer)

   If nErr <> 0
   	msginfo("[ERROR]Falha ao enviar: " + oServer:getErrorString(nErr))
      ///oServer:smtpDisconnect()
      return .F.
   Endif

   // Disconecta do Servidor
   oServer:smtpDisconnect()

Return(.T.)
/*
//////////////////////////////////////////////
Static Function Send3_Mail()
//////////////////////////////////////////////
Local lResulConn := .T.
Local lResulSend := .T.
Local cError := ""
Local cServer := AllTrim(GetMV("MV_RELSERV"))
Local cEmail := AllTrim(GetMV("MV_RELACNT"))
Local cPass := AllTrim(GetMV("MV_RELPSW"))
Local lRelauth := GetMv("MV_RELAUTH")
Local cDe := cEmail
Local cPara := "arnaldojr@microsiga.com.br"
Local cCc := ""
Local cAssunto := "Teste de envio de e-mail: Curso ADVPL"
Local cAnexo := "\SYSTEM\lgrl99.bmp"
Local cMsg := Space(200)
Default _lJob := .T.
cMsg := "--------------------------------------------------"
cMsg += "CURSO DE ADVPL "
cMsg += "--------------------------------------------------"
cMsg += "Você está recebendo um e-mail do curso de ADVPL avançado"
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
//Se nao conseguiu fazer a Autenticacao usando o E-mail completo, tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
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
SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg
ATTACHMENT cAnexo RESULT lResulSend
ElseIf !Empty(cCc) .And. !Empty(cAnexo)
SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg
ATTACHMENT cAnexo RESULT lResulSend
ElseIf Empty(cCc) .And. Empty(cAnexo)
SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg
RESULT lResulSend
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

Return
*/