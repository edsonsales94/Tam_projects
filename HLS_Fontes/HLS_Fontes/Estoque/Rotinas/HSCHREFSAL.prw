#include "ap5mail.ch"
#include "Protheus.Ch"
#include "TopConn.Ch"
#include "TBIConn.Ch"

/*/{protheus.doc}HSCHREFSAL
Job Refaz Saldos
@author Alessandro Freire
@since 24/10/08
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHSCHREFSAL  บAutor  ณAlessandro Freire   บ Data ณ  24/10/08  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRefaz - Saldos                                              บฑฑ
ฑฑบ          ณHonda Lock                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณProtheus 11                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿   
*/                        

/*
MATA300 - Saldo Atual = Ok
MATA215 - Refaz Acumulados = Ok 
MATA216 - Refaz Poder Terceiros  ?
MATA330 - Recalculo do Custo M้dio = Ok
MATA190 - Refaz Custo de Entrada ?
*/

User Function HSCHREFSAL()
                                                                         
 //ConOut(VarInfo("ParamIxb", ParamIxb))              
                                                          
 RPCSetType(3)                              
 
 Prepare Environment EMPRESA "01" FILIAL "01" MODULO "04"
 
 ConOut("Inicio Job Refaz Saldos - Data [" + DToC(dDataBase) + "] Hora [" + Time() + "]")

 FS_HLRSALDO()

 ConOut("Final Job Refaz Saldos - Data [" + DToC(dDataBase) + "] Hora [" + Time() + "]") 

 Reset Environment
 
Return(Nil)   

Static Function FS_HLRSALDO()

Local aArea		      := GetArea()
Local cAssunto        := "Monitoramento Job Refaz Saldos em " + DtoC(dDataBase) + " เs " + SubStr( Time(),1,5 ) + "-"
Local cBody           := ""
Local cBodyLoop       := ""
Local cLogConsole     := ""
//Local CRLF            := Chr(13) + Chr(10)

Private lEnd      	:= .F.											// ABORTA ROTINA
Private _lAbort   	:= .F.											// HABILITA BOTAO CANCELA
Private cQry		:= ""

//PutMv("HL_DTULIDE", dDataBase )
//PutMv("HL_HRULIDE", SubStr(Time(),1,5))

//PutMv("HL_DTULRFS", dDataBase )
//PutMv("HL_HRULRFS", SubStr(Time(),1,5))

//ConOut("Processando [" + cLogConsole + "]")

Alert("Executando...")

Sleep( 5000 )   // aguarda 5 segundo para que as jobs IPC subam.
SetHideInd(.T.) // evita problemas com indices temporarios

Mata300()// Saldo Atual 

ConOut("Executada Mata 300 - Saldo Atual!")

/*	
If Empty( cBodyLoop )
	cBodyLoop := "SEM ARQUIVOS A ENVIAR"
	cAssunto  += "SEM ARQUIVOS A ENVIAR"
Endif
            
MonitMail( cAssunto, cBody + cBodyLoop )
*/

Return( nil )
           

****************************************************************************************

static Function MonitMail( cAssunto, cMensagem )

Local cMailServer := GETMV("MV_RELSERV") 
Local cMailContX  := GETMV("MV_RELACNT")
Local cMailSenha  := GETMV("MV_RELAPSW") 
Local cMailDest   := GETMV("MV_HLEDIM" )
Local lConnect    := .f.
Local lEnv        := .f.
Local lFim        := .f.

CONNECT SMTP SERVER cMailServer ACCOUNT cMailContX PASSWORD cMailSenha RESULT lConnect

IF GetMv("MV_RELAUTH")
	MailAuth( cMailContX, cMailSenha )
EndIF

If (lConnect)  // testa se a conexใo foi feita com sucesso
	SEND MAIL FROM cMailContX TO cMailDest SUBJECT cAssunto BODY cMensagem RESULT lEnv
Endif

If ! lEnv
	GET MAIL ERROR cErro
EndIf

DISCONNECT SMTP SERVER RESULT lFim


Return(nil)

/*
RPCSetType(3)
RPCSETENV("02", "09", "ADMIN", "", "SIGAEST", "WF",{})
Sleep( 5000 )     // aguarda 5 segundo para que as jobs IPC subam.
SetHideInd(.T.) // evita problemas com indices temporarios
Mata300()// Saldo Atual 
ConOut("Executada Mata 300 - Saldo Atual!")
Mata215(.T.) // Refaz Acumulados // Demora muito // Ligar Microsiga
ConOut("Executada Mata215 - Refaz Acumulados!")
Mata216() // Poder de 3บ
ConOut("Executada Mata216 - Poder de 3บ!")
Mata330() // Custo M้dio
ConOut("Executada Mata330 - Custo M้dio !")
//MATA280() // Virada de Saldos
//ConOut("Executada Mata280 - Virada de Saldos !")
RpcClearEnv()
*/