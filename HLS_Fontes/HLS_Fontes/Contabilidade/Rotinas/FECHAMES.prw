#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "AP5MAIL.CH"
/*/{protheus.doc}FechaMes
Fechamento do financeiro e compras
@author Honda Lock
/*/
// Disponibilizacao de alteracao dos Parametros
// MV_DATAFIN = Financeiro
// MV_DATAFIS = FIscal/Compras
// Pelo Usuario Contabil

User Function FECHAMES()

Private _dDataFin	:= _dDataFinAnt:=GETMV("MV_DATAFIN")
Private _dDataFis	:= _dDataFisAnt:=GETMV("MV_DATAFIS")
Private oDlgFecha

SET CENTURY ON
@ 227,199 To 404,629 Dialog oDlgFecha Title OemToAnsi("Fechamentos")
@ 9,5 Say OemToAnsi("Esta Rotina tem por objetivo permitir o fechamento dos modulos Financeiro e Compras,") Size 214,18
@ 23,4 Say OemToAnsi("nao permitindo alteracoes com data inferior ao determinado.") Size 214,14
@ 42,20 Say OemToAnsi("Data Limite  Financeiro") Size 78,8
@ 53,20 Say OemToAnsi("Data Limite  Compras") Size 78,8
@ 41,98 Get _dDataFin Size 76,10
@ 52,98 Get _dDataFis Size 76,10
@ 70,96  BMPBUTTON TYPE 1 ACTION GRVFEC()         OBJECT oButtOK
@ 70,138 BMPBUTTON TYPE 2 ACTION FECHADLG()       OBJECT oButtCc
ACTIVATE DIALOG oDlgFecha CENTERED

Return

Static Function GRVFEC()

Local cPula     := CHR(13) + CHR(10)
Local cCorpoMsg := ""
Local cUsuario 	:= UsrRetName(RetCodUsr())+" - "+UsrFullName(RetCodUsr())

dbSelectArea("SX6")
dbSetOrder(1)
If dbSeek(xFilial("SX6")+"MV_DATAFIN")
	RecLock("SX6",.F.)
	Field->X6_CONTEUD := DTOC(_dDataFin)
	Field->X6_CONTSPA := DTOC(_dDataFin)
	Field->X6_CONTENG := DTOC(_dDataFin)
	SX6->( MsUnlock() )
End
If dbSeek(xFilial("SX6")+"MV_DATAFIS")
	RecLock("SX6",.F.)
	Field->X6_CONTEUD := DTOS(_dDataFis)
	Field->X6_CONTSPA := DTOS(_dDataFis)
	Field->X6_CONTENG := DTOS(_dDataFis)
	SX6->( MsUnlock() )
End

/*
If SM0->M0_CODIGO = "01"
If dbSeek(xFilial("SX6")+"MV_DBLQMOV") //MV_ULMES
RecLock("SX6",.F.)
Field->X6_CONTEUD := DTOS(_dDataFis)
Field->X6_CONTSPA := DTOS(_dDataFis)
Field->X6_CONTENG := DTOS(_dDataFis)
SX6->( MsUnlock() )
End
End
*/

If ( _dDataFin <> _dDataFinAnt .or.  _dDataFis <> _dDataFisAnt) //Verifico se houve alteracoes no parametro
	//Envia notificação de Alteração
	cCorpoMsg := "Prezado Usuário,"+cPula+cPula
	cCorpoMsg += "Segue histórico de atualização dos Parâmetros"+cPula
	cCorpoMsg += cPula+"Filial: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+" - "+SM0->M0_NOMECOM
	cCorpoMsg +=cPula+cPula+'<b <font size="2">Data Limite para Operações Financeiras</font></b>'
	cCorpoMsg += cPula+"(MV_DATAFIN) - Antes: "+dtoc(_dDataFinAnt)+" Agora: "+dtoc(_dDataFin)
	cCorpoMsg +=cPula+cPula+'<b <font size="2">Data Limite para Operações Fiscais</font></b>'
	cCorpoMsg += cPula+"(MV_DATAFIS) - Antes: "+ dtoc(_dDataFisAnt)+" Agora: "+dtoc(_dDataFis)
	cCorpoMsg += cPula+cPula+"Alteração efetuada pelo usuário: "+cUsuario+" em: "+dtoc(Date())+" "+Time()
	cCorpoMsg += cPula+cPula+"Sistema de Notificação de Eventos - Microsiga/Protheus"
	
	MsAguarde({||MsgRun("Enviando Notificação, Aguarde...","",{|| EnvMail(cCorpoMsg) })})
	
	AVISO("Data Limite", "As Datas foram alteradas com Sucesso!",{"Ok"},,,,"PCOFXOK")
	
Else
	AVISO("Sem Alteração", "Não houve alterações nas Datas!",{"Ok"},,,,"PCOFXCANCEL")
	
Endif

Close(oDlgFecha)

Return


***********************
static Function EnvMail(cCorpoMsg)
***********************

Local cMailServer := GETMV("MV_RELSERV")
Local cMailContX  := GETMV("MV_RELACNT")
Local cMailSenha  := GETMV("MV_RELAPSW")
Local cMailDest   := SuperGetMV("HL_MAILABR",,"r.borges@hondalock-sp.com.br")
Local cAssunto	:= "Alteração nas datas (Fecha/Libera Sistema)"
Local lConnect    := .f.
Local lEnv        := .f.
Local lFim        := .f.

CONNECT SMTP SERVER cMailServer ACCOUNT cMailContX PASSWORD cMailSenha RESULT lConnect

IF GetMv("MV_RELAUTH")
	MailAuth( cMailContX, cMailSenha )
EndIF

If (lConnect)  // testa se a conexão foi feita com sucesso
	SEND MAIL FROM cMailContX TO cMailDest SUBJECT cAssunto BODY cCorpoMsg RESULT lEnv
Endif

If ! lEnv
	GET MAIL ERROR cErro
EndIf

DISCONNECT SMTP SERVER RESULT lFim


Return(nil)


Static Function FECHADLG()
SET CENTURY OFF
Close(oDlgFecha)

Return

