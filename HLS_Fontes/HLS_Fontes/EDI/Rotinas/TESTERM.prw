#include "ap5mail.ch"
#include "Protheus.Ch"
#include "TopConn.Ch"
#include "TBIConn.Ch"

/*/{protheus.doc}TESTERM
EDI-Checagem da programacao de entrega HAB
@author Ricardo M M Borges
@since 06/01/2014
/*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHLEDIAUT  บAutor  ณRicardo M M Borges   บ Data ณ  06/01/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEDI - Checagem da Programa็ใo de Entrega HAB                บฑฑ
ฑฑบ          ณHonda Lock-SP                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 11                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿   
*/
User Function TESTERM()
                                                                         
 //ConOut(VarInfo("ParamIxb", ParamIxb))              
                                                           
 //RPCSetType(3)
 //Prepare Environment EMPRESA "01" FILIAL "01" MODULO "02"
 
 //ConOut("Inicio Checagem EDI HAB - Data [" + DToC(dDataBase) + "] Hora [" + Time() + "]")

 HL_CHECATT()

 //ConOut("Final Checagem EDI HAB - Data [" + DToC(dDataBase) + "] Hora [" + Time() + "]") 

 //Reset Environment
 
Return(Nil)   

Static Function HL_CHECATT()

Local cPathServer     := GetMv( "HL_FOLDEHB" )

Local cArquivo        := ""
Local cLine           := ""
Local nHdl            := -1
Local nHdl2           := -1
Local nQtLines        := 0

Local aArea		      := GetArea()
Local nSValBrut       := 0      
Local cAssunto        := "Monitoramento EDI HAB-PROGRAMACAO DE ENTREGA em " + DtoC(dDataBase) + " เs " + SubStr( Time(),1,5 ) + "-"
Local cBody           := ""
Local cBodyLoop       := ""
Local cLogConsole     := ""    

Local aArqsHON        := {} // Array com os nomes dos arquivos encontrados no diretorio para leitura. 
Local aArqsTXT        := {} // Array com os nomes dos arquivos encontrados no diretorio para leitura.

//Local CRLF            := Chr(13) + Chr(10)

Private lEnd      	:= .F.											// ABORTA ROTINA
Private _lAbort   	:= .F.											// HABILITA BOTAO CANCELA
Private cQry		:= ""

PutMv("HL_DTULCHE", dDataBase )
PutMv("HL_HRULCHE", SubStr(Time(),1,5))
                                                          
cBody += "Arquivos EDI-HAB Checados na pasta " + cPathServer + CRLF

//////////////////////////////////////////////////////////////////	
   ConOut("Processando [" + cLogConsole + "]")                       
///////////////////////////////////////////////////////////////////

ADIR(cPathServer+"*.TXT",aArqsTXT) // Busca todos os arquivos no diretorio ( i:\saida\Programacao de Entrega ) 

ADIR(cPathServer+"*.HON",aArqsHON) // Busca todos os arquivos no diretorio ( i:\saida\Programacao de Entrega )

If len(aArqsTXT) +  len(aArqsHON)  == 0 // Verificando se nao foram encontrados arquivos para Checagem
	cLogConsole += "Nใo existem arquivos a serem lidos no diretorio " + cPathServer
Endif

For nx := 1 to len(aArqsTXT)
	
	cNameFile   := cPathServer + aArqsTXT[nx]
	
	cBodyLoop   += "Arquivo: " + cNameFile + CRLF 
	
	cLogConsole := "Arquivo: " + cNameFile	

Next nx

For nx := 1 to len(aArqsHON)
	
	cNameFile   := cPathServer + aArqsHON[nx]
	
	cBodyLoop   += "Arquivo: " + cNameFile + CRLF 
	
	cLogConsole := "Arquivo: " + cNameFile	

Next nx
                                                                                               
If Empty( cBodyLoop )
	cBodyLoop := "SEM ARQUIVOS EDI-HAB PROGRAMAวรO DE ENTREGA"
	cAssunto  += "SEM ARQUIVOS EDI-HAB PROGRAMAวรO DE ENTREGA NA PASTA := " + cPathServer
Endif

cBodyLoop   += CRLF            

TMonitMail( cAssunto, cBody + cBodyLoop )

Return( nil )
            

****************************************************************************************

static Function TMonitMail( cAssunto, cMensagem )

Local cMailServer := GETMV("MV_RELSERV") 
Local cMailContX  := GETMV("MV_RELACNT")
Local cMailSenha  := GETMV("MV_RELAPSW") 
//Local cMailDest   := GETMV("MV_HLEDIM") 
Local cMailDest   := GETMV("HL_EMACHED")

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