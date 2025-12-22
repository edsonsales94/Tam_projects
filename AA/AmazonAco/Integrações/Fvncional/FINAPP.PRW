#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include 'tbiconn.ch'

user function FINAPP()
	Local cdJson :=""
	//Prepare Environment Empresa '05' Filial '01'
return


WSRESTFUL FINAPP DESCRIPTION "Servico de Movimento Financeiro"
	WSMETHOD POST DESCRIPTION "Efetua o lancamento do documento " WSSYNTAX "/FINAPP/ || /FINAPP/" 
End WsRestful


WSMETHOD POST  WSSERVICE FINAPP
	Local lPost := .T.
	Local cBody, NX
	Local oJsonRet := JsonObject():New()

	cBody := ::GetContent()
	qout(cBody)
	aRetornos := Movimenta(cBody)
	
	oJsonRet["sucesso"] := Iif(aRetornos[2],"true","false")

	oJsonRet["erros"] :={}
	//QOUT(Len(aRetornos[1]))

	For nX:=1 To Len(aRetornos[1])
		Aadd(oJsonRet["erros"],JsonObject():New())
		oJsonRet["erros"][nX]['codigoErro'] 	:= aRetornos[1][nX][1]
		oJsonRet["erros"][nX]['descricaoErro'] 	:= aRetornos[1][nX][2]
		oJsonRet["erros"][nX]['parametros'] 	:= aRetornos[1][nX][3]
	Next 

	
	
cReturn :=FWJsonSerialize(oJsonRet, .F., .F., .T.)
::SetResponse(EncodeUtf8(cReturn))
	
	
Return lPost


Static Function Movimenta(cdJson)

	Local i,j, odQuebra
	Local aErros := {}
	local _Etqs  := ''
	local nAux
	Local lSucesso := .F.
	LOCAL cLogTxt    := ""
    lOCAL aLogAuto   := {}
	local cXparam     := ""
	PRIVATE lMsErroAuto := .F. 
    Private lSucesso   := .f.
    private lAutoErrNoFile:= .T.

	Default cdJson := ''

	lOK := .T.
	cMessage := ""
	If FWJsonDeserialize(cdJson,@odQuebra)

		If .F.
			cMessage := "Mensagem ja processada"
			//CONOUT(cMessage)
		Else
				lOK := .T.
				
				For j := 1 to len(odQuebra)

				ccTipo    := odQuebra[j]:tipo    
				cdValor   := odQuebra[j]:valor     
				ndNaturez := odQuebra[j]:natureza   
				ndBanco   := odQuebra[j]:banco
				ndAg      := odQuebra[j]:agencia
				ndConta   := odQuebra[j]:conta
				ndBenef   := odQuebra[j]:beneficiario
				ndHist    := odQuebra[j]:historico
				ndData    := CTOD(odQuebra[j]:data)
				ndMoeda   := "M1" //iif(FWCodEmp() != "06","01","M1")
				cxDocs    := dtos(CTOD(odQuebra[j]:data))

				
				if ccTipo = "pagar"  
					
					aFINA100 := { {"E5_DATA" ,ndData ,Nil},;
					{"E5_MOEDA"    ,ndMoeda ,Nil},;
					{"E5_VALOR"   ,cdValor ,Nil},;
					{"E5_NATUREZ" ,ndNaturez ,Nil},;
					{"E5_BANCO"   ,ndBanco ,Nil},;
					{"E5_AGENCIA" ,ndAg    ,Nil},;
					{"E5_CONTA"   ,ndConta ,Nil},;
					{"E5_BENEF"   ,ndBenef ,Nil},;
					{"E5_DOCUMEN" ,cxDocs  ,Nil},;
					{"E5_XUSUARI" ,"APP"   ,Nil},;
					{"E5_HISTOR"  ,ndHist  ,Nil}}

					cXparam := "FINA100 OPCAO 3  E5_DATA:  " + odQuebra[j]:data + "; " + "E5_MOEDA: " +   ndMoeda + "; " +  "E5_VALOR:"  + "; " + alltrim(str(cdValor)) + "; " + "E5_NATUREZ:" + ndNaturez  + "; " + "E5_BANCO: "   + ndBanco + "; " +"E5_AGENCIA:" + ndAg    + "; " + "E5_CONTA"   + ndConta + "; " +"E5_BENEF"   + ndBenef + "; " +"E5_HISTOR"  + ndHist  + "; " 

					MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,3)

					If lMsErroAuto
						aLogAuto := GetAutoGRLog()

						For nAux := 1 To Len(aLogAuto)
							cLogTxt += aLogAuto[nAux] + CHR(13) + CHR(10)
						Next
						QOUT(cLogTxt) 
						aAdd(aErros,{"400",cLogTxt,cXparam})
					Else
						lOK := .T.
						cMessage := "Movto. Bancario Pagar incluido com sucesso !!!"
						lSucesso := .T.
						aAdd(aErros,{"200",cMessage,cXparam})
						
					EndIf


					
				else
					aFINA100 := { {"E5_DATA" ,ndData ,Nil},;
					{"E5_MOEDA"    ,ndMoeda ,Nil},;
					{"E5_VALOR"   ,cdValor ,Nil},;
					{"E5_NATUREZ" ,ndNaturez ,Nil},;
					{"E5_BANCO"   ,ndBanco ,Nil},;
					{"E5_AGENCIA" ,ndAg    ,Nil},;
					{"E5_CONTA"   ,ndConta ,Nil},;
					{"E5_DOCUMEN" ,cxDocs ,Nil},;
					{"E5_BENEF"   ,ndBenef ,Nil},;
					{"E5_XUSUARI" ,"APP"   ,Nil},;
					{"E5_HISTOR"  ,ndHist  ,Nil}}

					cXparam := "FINA100 OPCAO 4  E5_DATA:  " + odQuebra[j]:data + "; " + "E5_MOEDA: " +   ndMoeda  + "; " +  "E5_VALOR:"  + "; " + alltrim(str(cdValor)) + "; " + "E5_NATUREZ:" + ndNaturez  + "; " + "E5_BANCO: "   + ndBanco + "; " +"E5_AGENCIA:" + ndAg    + "; " + "E5_CONTA"   + ndConta + "; " +"E5_HISTOR"  + ndHist  + "; " 

					MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,4)
					
					If lMsErroAuto
						aLogAuto := GetAutoGRLog()

						For nAux := 1 To Len(aLogAuto)
							cLogTxt += aLogAuto[nAux] + CHR(13) + CHR(10)
						Next
						//QOUT(cLogTxt) 
						aAdd(aErros,{"400",cLogTxt,cXparam})
					Else
						lOK := .T.
						cMessage := "Movto. Bancario Pagar incluido com sucesso !!!"
						lSucesso := .T.
						aAdd(aErros,{"200",cMessage,cXparam})
						
					EndIf
					
					
				endif

				next
		EndIf
	Else
		lOK := .F.
		cMessage := "Falha ao Efetuar a Leitura do JSON"
		aAdd(aErros,{"400",cMessage})
		RETURN {aErros,lSucesso,cXparam}          
	EndIf
	
	
Return {aErros,lSucesso}          


