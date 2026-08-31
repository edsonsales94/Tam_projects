#Include "RwMake.ch"
#Include "Protheus.ch"    
#include "TOPCONN.CH"

/*/{Protheus.doc} PEFI001E
@author Edinilson
@since 10/08/2015
@version P12 R1 
@description Funcao para leitura de arquivo de cartao e geracao de titulos de credito no financeiro
@type function
/*/

User Function PEFI001E

	//Declaracao de Variaveis                                             
	Private cPerg := PadR("PEFI001E",10)
	Private oGeraTxt := Nil
	Private aHead 	:= {}
	Public  aRO		:= {}
	Public aCV      := {}
	Private lVerif := .T.
	Private lGerou  := .F.
	Private _VlrTotal := 0
	Private _E1Num := ""
	Private _ChProc := ""
	Private _Prefixo := "CIE"
	Private _Arquivo := ""
	Private nContErr := 0
	Private aErros := {}

	Private cClioper  := Padr(AllTrim(Posicione("SAE",1,xFilial("SAE")+"001","AE_CODCLI")),TamSX3("A1_COD")[1],Space(1))

	If Empty(cClioper)
		Alert("Codigo da operadora 001 nao direcionado para nenhum cliente (SAE)")	
		Return	
	EndIf

	Private cLojaoper := Posicione("SA1",3,xFilial("SA1")+cClioper,"A1_LOJA")
	Private cNomeOper  := Posicione("SA1",3,xFilial("SA1")+cClioper,"A1_NOME")	

	if Select('TMPSE') > 0 
		TMPSE->(dBCloseArea())
	EndIf
	if Select('TMPSC') > 0 
		TMPSC->(dBCloseArea())
	EndIf

	If Select('SE1') > 0
		SE1->(DbCloseArea())
	EndIf 

	AjustaSx1(cPerg)

	Pergunte(cPerg,.T.)

	// Montagem da tela de processamento.                                  
	@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geração de titulos de cartao")
	@ 05,035 TO 080,185 PIXEL OF oGeraTxt
	@ 20,055 Say " Este programa irá Ler um arquivo texto       " PIXEL OF oGeraTxt
	@ 28,055 Say " conforme os parâmetros definidos  pelo usuário  " PIXEL OF oGeraTxt
	@ 36,055 Say " e gerar titulos de credito/debito para vendas    " PIXEL OF oGeraTxt
	@ 44,055 Say " em cartao          " PIXEL OF oGeraTxt

	@ 74,090 BMPBUTTON TYPE 01 ACTION MsgRun("Aguarde Processando Arquivo "+MV_PAR02,"Aviso",{||OkLerTxt()})
	@ 74,120 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
	@ 74,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

	Activate Dialog oGeraTxt Centered

Return()

Static Function OkLerTxt

	Private cDir    := substr(mv_par02,1,Rat("\",mv_par02))
	Private cArq    := "Erro_"+AllTrim(Substr(mv_par02,Rat("\",mv_par02)+1,99))

	// Abre o arquivon
	Handle := FT_FUse(mv_par02)

	// Se houver erro de abertura abandona processamento
	if Handle = -1  
		return
	endif

	// Posiciona na primeria linha
	FT_FGoTop()

	// Retorna o número de linhas do arquivon
	Last := FT_FLastRec()

	_Arquivo := AllTrim(Substr(mv_par02,Rat("\",mv_par02),99))


	While !FT_FEOF()   

		cLine  := FT_FReadLn() // Retorna a linha corrente  
		nRecno := FT_FRecno()  // Retorna o recno da Linha  

		//Processa registro 
		ProcTit(cLine)

		If Empty(aHead) 
			Alert("Arquivo Invalido. Processo cancelado ! (Posicao 53 header # 'D')")
			Return
		Else			
			If Alltrim(aHead[1])!=Alltrim(MV_PAR01)
				Alert("Codigo do estabelimento invalido. Processo Cancelado. ")
				Return
			EndIf
		End	

		// Pula para próxima linha  
		FT_FSKIP()

	Enddo

	// Fecha o Arquivo
	FT_FUSE()

	If !Empty(aErros) 

		GeraLog()

		Alert("Ocorreram erros (" + cValToChar(nContErr) + ") durante o processamento.")

	Else

		Alert("Titulos gerados com sucesso!!")

	EndIf

	oGeraTxt:End()

return 

Static function ProcTit(cLine)

	If Substr(cLine,2,10) == AllTrim(MV_PAR01)

		Do Case
			Case Substr(cLine,1,1)=="0" .and. Substr(cLine,53,1) == "D"
			GeraHead(cLine)
			Case Substr(cLine,1,1)=="1" .and. (Substr(cLine,19,2) == "01" .or. empty(alltrim(Substr(cLine,19,2))))
			GeraRo(cLine)
			Case Substr(cLine,1,1)=="2" .and. (Substr(cLine,60,2) == "01" .or. Substr(cLine,60,2) == "00")
			GeraCV(cLine)
			otherwise
			return
		EndCase

	EndIf	

return

Static function GeraHead(cLine)

	aAdd(aHead,SubStr(cLine,2,10)) // 1 - Numero do Estabelecimento
	aAdd(aHead,Substr(cLIne,12,8)) // 2 - Data do arquivo
	aAdd(aHead,Substr(cLine,39,7)) // 3 - Nro arquivo

return

Static function GeraRo(cLine)	

	aRO := {}

	aAdd(aRO,SubStr(cLine,002,010)) // 01 - Numero do Estabelecimento
	aAdd(aRO,SubStr(cLine,012,007)) // 02 - Numero do Resumo da Operacao
	aAdd(aRO,SubStr(cLine,019,002)) // 03 - Parcela
	aAdd(aRO,SubStr(cLine,021,001)) // 04 - Filler
	aAdd(aRO,SubStr(cLine,022,002)) // 05 - Plano
	aAdd(aRO,SubStr(cLine,024,013)) // 06 - situacao
	aAdd(aRO,SubStr(cLine,037,002)) // 07 - Status
	aAdd(aRO,SubStr(cLine,039,006)) // 08 - Data de deposito
	aAdd(aRO,SubStr(cLine,045,006)) // 09 - Data prevista de pagamento
	aAdd(aRO,SubStr(cLine,051,006)) // 10 - Data de envio para Banco
	aAdd(aRO,SubStr(cLine,057,001)) // 11 - Sinal (-)debito (+)credito
	aAdd(aRO,SubStr(cLine,058,013)) // 12 - somatorio dos valores de venda EC/Lote
	aAdd(aRO,SubStr(cLine,071,001)) // 13 - Sinal de comissao (-) debito (+)credito
	aAdd(aRO,SubStr(cLine,072,013)) // 14 - Valor da Comissao
	aAdd(aRO,SubStr(cLine,085,001)) // 15 - Sinal do valor rejeitado (-) debito (+) credito
	aAdd(aRO,SubStr(cLine,086,013)) // 16 - Valor Rejeitado
	aAdd(aRO,SubStr(cLine,099,001)) // 17 - Sinal do valor Liquido (-)debito (+) credito
	aAdd(aRO,SubStr(cLine,100,013)) // 18 - Valor Liquido
	aAdd(aRO,SubStr(cLine,113,004)) // 19 - Banco
	aAdd(aRO,SubStr(cLine,117,005)) // 20 - Agencia
	aAdd(aRO,SubStr(cLine,122,014)) // 21 - Conta Corrente
	aAdd(aRO,SubStr(cLine,136,006)) // 22 - Quantidade de Vendas aceitas
	aAdd(aRO,SubStr(cLine,142,001)) // 23 - Identificador do Produto
	aAdd(aRO,SubStr(cLine,143,006)) // 24 - Quantidade de vendas rejeitadas
	aAdd(aRO,SubStr(cLine,149,001)) // 25 - Identificador de revenda
	aAdd(aRO,SubStr(cLine,150,001)) // 26 - Identificador de opcao de extrato
	aAdd(aRO,SubStr(cLine,151,006)) // 27 - Data da captura da transacao
	aAdd(aRO,SubStr(cLine,157,002)) // 28 - Origem do ajuste
	aAdd(aRO,SubStr(cLine,159,001)) // 29 - Uso Cielo
	aAdd(aRO,SubStr(cLine,160,013)) // 30 - Valor Complementar
	aAdd(aRO,SubStr(cLine,173,001)) // 31 - Flag de antecipacao
	aAdd(aRO,SubStr(cLine,174,009)) // 32 - Numero do ARV
	aAdd(aRO,SubStr(cLine,183,001)) // 33 - Sinal de valor Bruto antecipado (-)debito (+)credito
	aAdd(aRO,SubStr(cLine,184,013)) // 34 - Valor Bruto Antecipado
	aAdd(aRO,SubStr(cLine,197,003)) // 35 - Codigo da Bandeira
	aAdd(aRO,SubStr(cLine,200,221)) // 36 - Numero Unico
	aAdd(aRO,SubStr(cLine,222,028)) // 37 - Uso Cielo		

return

Static function GeraCV(cLine)

	aCV := {}

	aAdd(aCV,Substr(cLine,002,010)) //01 - Numero do Estabelecimento
	aAdd(aCV,Substr(cLine,012,007)) //02 - Numero do Resumo da operacao
	aAdd(aCV,Substr(cLine,019,019)) //03 - Numero do Cartao
	aAdd(aCV,Substr(cLine,038,008)) //04 - Data da compra
	aAdd(aCV,Substr(cLine,046,001)) //05 - Identifica debito credito
	aAdd(aCV,Substr(cLine,047,013)) //06 - Valor compra
	aAdd(aCV,Substr(cLine,060,002)) //07 - Parcela
	aAdd(aCV,Substr(cLine,062,002)) //08 - Total Parcelas
	aAdd(aCV,Substr(cLine,064,030)) //09 - Motivo Rejeicao
	aAdd(aCV,Substr(cLine,094,006)) //10 - Codigo autorizacao
	aAdd(aCV,Substr(cLine,100,040)) //11 - Codigo transacao comercio eletronico
	aAdd(aCV,Substr(cLine,140,006)) //12 - Codigo identifica a transacao
	aAdd(aCV,Substr(cLine,146,013)) //13 - Valor Troco Facil
	aAdd(aCV,Substr(cLine,159,002)) //14 - Numero de digitos do cartao
	aAdd(aCV,Substr(cLine,161,026)) //15 - Reservado para a Cielo
	aAdd(aCV,Substr(cLine,187,009)) //16 - Numero da Nota fiscal
	aAdd(aCV,Substr(cLine,196,004)) //17 - Utilizado para ECs (CEF e BB)
	aAdd(aCV,Substr(cLine,200,008)) //18 - Numero Logico do terminal onde foi feito a venda
	aAdd(aCV,Substr(cLine,208,002)) //19 - Identificacao taxa de Embarque
	aAdd(aCV,Substr(cLine,210,016)) //20 - codigo do pedido
	aAdd(aCV,Substr(cLine,226,025)) //21 - Reservado para a Cielo	

	GeraTIT() 	 

return

Static function GeraNCC()

	Local aFIN040  := {}
	Local _NroMaq := 0
	Local aArea	 := GetArea()
	Local cCliente := "" 
	Local cLoja	 := ""
	Local cNome	 := "" 
	Local cQuery := ""
	Local _Hist := ""
	Local _Natureza := "12011"
	Local _Existe := .T.		
	Private lMsErroAuto := .F.		


	cQuery := "SELECT E1_NUM, E1_CLIENTE, E1_PARCELA, E1_NRDOC, E1_TIPO  "
	cQuery += " FROM  SE1010 " 
	cQuery += " WHERE "
	//cQuery += " E1_ORIGEM = 'PEFI001E' " 
	//	cQuery += " AND E1_TIPO IN ('NCC','NDC') "
	cQuery += " E1_TIPO = 'NCC'  "
	Cquery += " AND E1_DOCTEF = '" + aCV[10] + "' "	
	cQuery += " AND E1_NSUTEF = '" + aCV[02] + "' "
	cQuery += " AND D_E_L_E_T_ = '' "
	//	cQuery += " ORDER BY E1_TIPO DESC

	cQuery := ChangeQuery( cQuery )  

	TcQuery cQuery New Alias "TMPSE" 

	dbSelectArea("TMPSE") 

	If !(Alltrim(TMPSE->E1_NRDOC) == aCV[12]) // Registro nao existe 

		/*

		If _GeraNDC 

		cCliente := TMPSE->E1_CLIENTE

		_Tipo := 'NDC'

		_VlrTotal := val(aCV[06]) / 100

		_Hist := 'Venda Cancelada'

		_Cont := TMPSE->E1_PARCELA

		_Natureza := "10732"

		Else

		*/

		cCliente := Posicione("ZAE",3,aCV[18],"ZAE_CLIENT")	

		If Empty(cCliente)
			aADD(aErros,{"Maquina de Cartao " + aCV[18] + "  nao cadastrada na tabela. (ZAE010)"})
			nContErr += 1			
			TMPSE->(dBCloseArea())
			Return
		EndIf

		_Tipo := 'NCC'

		_VlrTotal := val(aCV[06]) * _Cont / 100		

		_Hist := aCV[01] + '-' + aCV[18]

		_Parc := _Cont

		_Cont := cValToChar(_Cont)			

		//EndIf 	

		cLoja := Posicione("SA1",3,xFilial("SA1")+cCliente,"A1_LOJA")
		cNome  := Posicione("SA1",3,xFilial("SA1")+cCliente,"A1_NOME")

		If Empty(cNome)	
			aADD(aErros,{"Cliente " + cCliente + " nao cadastrado. (SA1) "})				
			nContErr += 1			
			TMPSE->(dBCloseArea())
			Return
		EndIf

		ProcuraE1num()

		aADD(aFIN040, {"E1_PREFIXO",_Prefixo,nil})
		aADD(aFIN040, {"E1_NUM"    ,_E1Num,nil})
		aADD(aFIN040, {"E1_PARCELA",_Cont,nil})
		aADD(aFIN040, {"E1_TIPO"   ,_Tipo,nil})
		aAdd(aFIN040, {"E1_XPAGTO" ,"NCC",	nil})
		aADD(aFIN040, {"E1_NATUREZ",_Natureza,nil})
		aADD(aFIN040, {"E1_CLIENTE",cCliente,nil})
		aADD(aFIN040, {"E1_NOMCLI" ,cNome,nil})
		aADD(aFIN040, {"E1_LOJA"   ,cLoja,nil})
		aADD(aFIN040, {"E1_EMISSAO",StoD(aCV[04]),nil})
		aADD(aFIN040, {"E1_VENCTO" ,StoD(aCV[04]),nil})
		aADD(aFIN040, {"E1_VENCREA",StoD(aCV[04]),nil})
		aADD(aFIN040, {"E1_VENCREA",StoD(aCV[04]),nil})
		aADD(aFIN040, {"E1_VALOR"  ,_VlrTotal,nil})
		aADD(aFIN040, {"E1_SALDO"  ,_VlrTotal,nil})
		aADD(aFIN040, {"E1_VLRREAL",_VlrTotal,nil})
		aADD(aFIN040, {"E1_EMIS1"  ,dDatabase,nil})	
		aADD(aFIN040, {"E1_HIST"   ,_Hist,nil})
		aAdd(aFIN040, {"E1_XBAND"  ,_Band ,nil})		
		aADD(aFIN040, {"E1_SITUACA","0",nil})
		aADD(aFIN040, {"E1_VALLIQ" ,0,nil})
		aADD(aFIN040, {"E1_VENCORI",StoD(aCV[04]),nil})
		aADD(aFIN040, {"E1_MOEDA"  ,1,nil})
		aADD(aFIN040, {"E1_VLCRUZ" ,_VlrTotal,nil})
		aADD(aFIN040, {"E1_VLCRUZ" ,_VlrTotal,nil})	
		aADD(aFIN040, {"E1_NSUTEF",aCV[02],	nil})	
		aADD(aFIN040, {"E1_XMAQUIN",aCV[18],nil})			
		aADD(aFIN040, {"E1_OCORREN","01",nil})
		aADD(aFIN040, {"E1_STATUS" ,"A",nil})
		aADD(aFIN040, {"E1_ORIGEM" ,"FINA040",nil})
		aADD(aFIN040, {"E1_FLUXO"  ,"S",nil})
		aADD(aFIN040, {"E1_MULTNAT","2",nil})
		aADD(aFIN040, {"E1_DESDOBR","2",nil})
		aADD(aFIN040, {"E1_FLUXO"  ,"S",nil})
		aADD(aFIN040, {"E1_NRDOC" ,aCV[12],nil})
		aADD(aFIN040, {"E1_DOCTEF" ,aCV[10],nil})
		aADD(aFIN040, {"E1_LA"     ,"N",nil})
		aADD(aFIN040, {"E1_FILORIG",xFilial('SE1'),nil})
		MsExecAuto({|x, y| Fina040(x, y)}, aFIN040, 3)

		If lMsErroAuto
			MostraErro("c:\temp\", "ERRO_CIELONCC_" + aCV[12] + ".LOG")
		Else
			ConfirmSX8()
		EndIf

	EndIf

	TMPSE->(dbSkip())
	TMPSE->(dBCloseArea())

	RestArea(aArea)

return

Static function GeraTIT()
	Local _Parc
	Local aFIN040  := {}
	Local aArea	   := GetArea()
	Local _Lanc := ""	
	Local cQuery := ""
	Local _Chproc := ""
	Local _Existe := .T.
	Local _VlrLiq := 0
	Local _VlrBruto := 0
	Private _Band := aRO[35]
	Private _GeraNDC := .t.
	Private _Tipo := ""
	Private lMsErroAuto := .F.	
	Private _Cont := 0
	Private cVencto := ""

	if aCV[04] < "20151201"

		Return

	End

	/*	

	If aCV[5] == '-'

	GeraCancel()

	If _GeraNDC
	GeraNCC()
	End

	Else	
	*/			

	_Tipo := "CC"	

	Do case

		Case Substr(aCV[02],1,1) == "5" // Debito
		_Cont := 1
		_Tipo := "CD"
		Case Substr(aCV[02],1,1) == "0" // Credito a vista
		_Cont := 1
		Case Substr(aCV[02],1,1) == "3" // Parcelado banco
		_Cont := 1
		otherwise
		_Cont := val(aCV[08]) * 1			
	EndCase	

	// Procura a taxa da Bandeira

	if _Tipo == "CD"
		_Taxa := "0.0160"
	Else
		If _Cont == 1
			_Taxa := "0.0200"
		else
			If _Cont >= 7 
				_Taxa := "0.0305"
			Else
				_Taxa := "0.0255"
			endif
		EndIf
	endIf	

	Do Case
		Case aRO[35] == "001" 			
		_Band := "VISA"
		Case aRO[35] == "002"			
		_Band := "MASTER"	
		Case aRO[35] == "006"
		_Band := "SOROCRED"
		Case aRO[35] == "007"
		_Band := "ELO"
		if _Tipo == "CD"
			_Taxa := "0.0160"
		Else
			If _Cont == 1
				_Taxa := "0.0200"
			else
				If _Cont >= 7 
					_Taxa := "0.0305"
				Else
					_Taxa := "0.0255"
				endif
			EndIf
		endIf
		Case aRO[35] == "009"
		_Band := "DINERS/DISCOVER"			 
		if _Tipo == "CD"
			_Taxa := "0.0200"
		Else
			If _Cont == 1
				_Taxa := "0.0317"
			else
				If _Cont >= 7 
					_Taxa := "0.0305"
				Else
					_Taxa := "0.0255"
				endif
			endIf
		EndIf
		Case aRO[35] == "011"
		_Band := "AGIPLAN" 
		Case aRO[35] == "015"
		_Band := "BANESCARD"
		If _Tipo == "CD"
			_Taxa := "0.0200"
		Else
			If _Cont == 1
				_Taxa := "0.0380"
			Else
				_Taxa := "0.0480"
			EndIf
		EndIf
		Case aRO[35] == "023"
		_Band := "CABAL" 				
		Case aRO[35] == "029"
		_Band := "CREDSYSTEM" 
		Case aRO[35] == "035"
		_Band := "ESPLANADA" 
		Case aRO[35] == "064"
		_Band := "CREDZ" 
	EndCase	

	_VlrBruto := val(aCV[06]) / 100	

	_VlrLiq := _VlrBruto - (Round(_VlrBruto * val(_Taxa),2))

	cVencto := Stod(aCV[04])			
	for _Parc := 1 to _Cont

		cQuery := "SELECT E1_NUM "
		cQuery += " FROM  SE1010 " 
		cQuery += " WHERE "
		cQuery += " E1_NRDOC = '" + aCV[12] + "' " 
		cQuery += " AND E1_PARCELA = '" + cValToChar(_Parc) + "' " 
		cQuery += " AND E1_CLIENTE = '" + cClioper + "' "
		cQuery += " AND E1_TIPO = '" + _Tipo + "' "
		Cquery += " AND E1_DOCTEF = '" + aCV[10] + "' "
		cQuery += " AND E1_EMISSAO = '" + aCV[04] + "' "
		cQuery += " AND D_E_L_E_T_ = '' "

		cQuery := ChangeQuery( cQuery )  

		TcQuery cQuery New Alias "TMPSE" 

		dbSelectArea("TMPSE") 

		if EMPTY(TMPSE->E1_NUM)  

			ProcuraE1num()

			If _Tipo = 'CC'
				cNumDias := _Parc * 30  			
				cVencto := StoD(aCV[04]) + cNumDias			
			Endif

			aADD(aFIN040, {"E1_FILIAL" ,xFilial("SE1")	,Nil})
			aAdd(aFIN040, {"E1_PREFIXO",_Prefixo,	nil})
			aAdd(aFIN040, {"E1_NUM"    ,_E1Num,	nil})
			aAdd(aFIN040, {"E1_PARCELA",cValToChar(_Parc),nil})
			aAdd(aFIN040, {"E1_TIPO"   ,_Tipo,	nil})
			aAdd(aFIN040, {"E1_XPAGTO" ,_Tipo,	nil})
			aAdd(aFIN040, {"E1_NATUREZ","10701",nil})
			aAdd(aFIN040, {"E1_CLIENTE",cClioper,	nil})
			aAdd(aFIN040, {"E1_NOMCLI" ,cNomeoper,	nil})
			aAdd(aFIN040, {"E1_LOJA"   ,cLojaoper,	nil})
			aAdd(aFIN040, {"E1_EMISSAO",StoD(aCV[04]),nil})
			aAdd(aFIN040, {"E1_VENCTO" ,cVencto,nil})
			aAdd(aFIN040, {"E1_VENCREA",cVencto,nil})				
			aAdd(aFIN040, {"E1_VALOR"  ,_VlrLiq,nil})
			aAdd(aFIN040, {"E1_SALDO"  ,_VlrLiq,nil})
			aAdd(aFIN040, {"E1_VLRREAL" ,_VlrBruto,nil})
			aAdd(aFIN040, {"E1_EMIS1"  ,dDatabase,nil})
			aAdd(aFIN040, {"E1_HIST"   ,aCV[01] + '-' + aCV[18] ,nil})
			aAdd(aFIN040, {"E1_XBAND"   ,_Band ,nil})
			aAdd(aFIN040, {"E1_NSUTEF",aCV[02],	nil})
			aAdd(aFIN040, {"E1_XMAQUIN",aCV[18],	nil})
			aAdd(aFIN040, {"E1_SITUACA","0",nil})
			aAdd(aFIN040, {"E1_VENCORI",cVencto,nil})
			aAdd(aFIN040, {"E1_MOEDA"  ,1,	nil})
			aAdd(aFIN040, {"E1_OCORREN","01",		nil})
			aAdd(aFIN040, {"E1_STATUS" ,"A",		nil})
			aAdd(aFIN040, {"E1_NRDOC" ,aCV[12],nil})
			aAdd(aFIN040, {"E1_DOCTEF" ,aCV[10],nil})
			aAdd(aFIN040, {"E1_ORIGEM" ,"FINA040",nil})
			aAdd(aFIN040, {"E1_FLUXO"  ,"S",		nil})
			aAdd(aFIN040, {"E1_MULTNAT","2",		nil})
			aAdd(aFIN040, {"E1_DESDOBR","2",		nil})
			aAdd(aFIN040, {"E1_FLUXO"  ,"S",		nil})
			aAdd(aFIN040, {"E1_LA"     ,"N",		nil})
			aAdd(aFIN040, {"E1_FILORIG",xFilial('SE1'),nil})				

			MsExecAuto({|x, y| Fina040(x, y)}, aFIN040, 3)
			If lMsErroAuto
				MostraErro("c:\temp\", "ERRO_CIELOTIT_" + aCV[12] + ".LOG")
			Else
				ConfirmSX8()
			EndIf
		EndIf	

		TMPSE->(dbSkip())
		TMPSE->(dBCloseArea())	


	Next _Parc	

	If !empty(aRO) 
		GeraNCC()
	Endif

	RestArea(aArea)
return

Static Function ProcuraE1num()

	Local _Existe := .T.
	Private cE1Num := GetSxeNum("SE1","E1_NUM")	

	While _Existe 

		cQuery := ""							
		cQuery := "SELECT E1_NUM "
		cQuery += " FROM  SE1010 " 
		cQuery += " WHERE "
		cQuery += " E1_NUM = '" + cE1Num + "' "
		cQuery += " AND E1_PARCELA = '" + cValToChar(_Parc) + "' " 
		cQuery += " AND E1_FILIAL = '" + xfilial('SE1') + "' "
		cQuery += " AND E1_TIPO = '"+ _Tipo + "' "
		Cquery += " AND E1_PREFIXO = '" + _Prefixo + "' "

		cQuery := ChangeQuery( cQuery )  

		TcQuery cQuery New Alias "TMPSC" 

		dbSelectArea("TMPSC") 
		if EMPTY(TMPSC->E1_NUM)				
			_Existe := .F.
			ConfirmSX8()  
		Else				
			cE1Num  := GetSxeNum("SE1","E1_NUM")								
			TMPSC->(dBCloseArea())		
		EndIf

	Enddo
	if Select('TMPSC') > 0 
		TMPSC->(dBCloseArea())
	EndIf
	_E1Num := cE1Num

	/*
	DbSelectArea("SE1")
	DbSetOrder(1) 
	_Chproc := xfilial('SE1')+_Prefixo+cE1Num+Padr(cValToChar(_Parc),3," ")+padr(_Tipo,3," ")
	if DbSeek(_ChProc) 
	cE1Num   := GetSxeNum("SE1","E1_NUM")
	else
	_Existe := .F.
	ConfirmSX8()
	EndIf
	EndDo
	*/						
	Return


	/*

	Static Function GeraCancel()

	Local cQuery := ''
	Local _Chproc := ''
	_GeraNDC := .t.

	cQuery := "SELECT E1_NUM, E1_BAIXA"
	cQuery += " FROM  SE1010 " 
	cQuery += " WHERE "
	cQuery += " E1_ORIGEM = 'PEFI001E' " 
	cQuery += " AND E1_TIPO = 'NCC' "
	Cquery += " AND E1_DOCTEF = '" + aCV[10] + "' "	
	cQuery += " AND E1_NSUTEF = '" + aCV[02] + "' "
	cQuery += " AND D_E_L_E_T_ = '' "

	cQuery := ChangeQuery( cQuery )  

	TcQuery cQuery New Alias "TMPSC" 

	dbSelectArea("TMPSC") 

	If Empty(TMPSC->E1_NUM)  // Nao existe o registro para cancelamento
	_GeraNDC := .f.	
	Else

	cQuery := "UPDATE SE1010 "
	cQuery += "SET D_E_L_E_T_ = '*', E1_HIST = 'Lancto Cancelado' "
	cQuery += " WHERE "
	cQuery += " E1_ORIGEM = 'PEFI001E' "
	Cquery += " AND E1_DOCTEF = '" + aCV[10] + "' "
	cQuery += " AND E1_NSUTEF = '" + aCV[02] + "' "	 
	If Empty(TMPSC->E1_BAIXA)		
	_GeraNDC := .f.	
	Else
	cQuery += " AND E1_TIPO <> 'NCC' "
	EndIf
	tcSQLExec(cQuery)

	EndIf

	TMPSC->(dbSkip())
	TMPSC->(dBCloseArea())
	/*	
	_Chproc := xfilial('SE1')+Padr(aCV[12],TamSX3("E1_NRDOC")[1],Space(1))+Padr(aCV[10],TamSX3("E1_DOCTEF")[1],Space(1))+Padr(aCV[02],TamSX3("E1_NSUTEF")[1],Space(1))+'NCC'

	DbSelectArea("SE1")
	DbSetOrder(U)
	if !DbSeek(_ChProc) // pesquisa pelo nro do documento + autorização e resumo			
	Return
	Else			
	cQuery := "UPDATE SE1010 "
	cQuery += "SET D_E_L_E_T_ = '*', E1_HIST = 'Lancto Cancelado' "
	cQuery += " WHERE "
	cQuery += " E1_ORIGEM = 'PEFI001E' "
	Cquery += " AND E1_DOCTEF = '" + aCV[10] + "' "
	cQuery += " AND E1_NSUTEF = '" + aCV[02] + "' "	 
	If Empty(SE1->E1_BAIXA)		
	_GeraNDC := .f.	
	Else
	cQuery += " AND E1_TIPO <> 'NCC' "
	EndIf
	tcSQLExec(cQuery)	

	EndIf
	*/

Return	

Static Function GeraLog()
	Local nLinha	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FCreate - É o comando responsavel pela criação do arquivo.                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local nHandle := FCreate(cDir+cArq)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³nHandle - A função FCreate retorna o handle, que indica se foi possível ou não criar o arquivo. Se o valor for     ³
	//³menor que zero, não foi possível criar o arquivo.                                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nHandle < 0
		MsgAlert("Erro durante criação do arquivo de Log.")
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³FWrite - Comando reponsavel pela gravação do texto.                                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nLinha := 1 to nContErr

			FWrite(nHandle, aErros[nLinha,1] + CRLF )

		Next nLinha
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³FClose - Comando que fecha o arquivo, liberando o uso para outros programas.                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FClose(nHandle)
	EndIf
return


Static Function AjustaSX1(cPerg)

	Local aRegs   := {}
	Local _sAlias := Alias()
	Local nX      := 0

	aAdd(aRegs,{cPerg,'01','Estabelecimento ?','Estabelecimento ?','Estabelecimento ?','mv_ch1','C',15,0,0,'G','','mv_par01','','','',''   })
	aAdd(aRegs,{cPerg,'02','Ler Arq. em ?   ','Gerar Arq. em ?   ','Gerar Arq. em ?   ','mv_ch2','C',40,0,0,'G','','mv_par02','','','',''   })

	DbSelectArea('SX1')
	SX1->(DbSetOrder(1))

	For nX:=1 to Len(aRegs)
		If	( !SX1->(DbSeek(aRegs[nx][01]+aRegs[nx][02])) )
			If	RecLock('SX1',.T.)
				Replace X1_GRUPO	With aRegs[nx][01]
				Replace X1_ORDEM   	With aRegs[nx][02]
				Replace X1_PERGUNTE	With aRegs[nx][03]
				Replace X1_PERSPA	With aRegs[nx][04]
				Replace X1_PERENG	With aRegs[nx][05]
				Replace X1_VARIAVL	With aRegs[nx][06]
				Replace X1_TIPO		With aRegs[nx][07]
				Replace X1_TAMANHO	With aRegs[nx][08]
				Replace X1_DECIMAL	With aRegs[nx][09]
				Replace X1_PRESEL	With aRegs[nx][10]
				Replace X1_GSC		With aRegs[nx][11]
				Replace X1_VALID	With aRegs[nx][12]
				Replace X1_VAR01	With aRegs[nx][13]
				Replace X1_DEF01	With aRegs[nx][14]
				Replace X1_DEF02	With aRegs[nx][15]
				Replace X1_DEF03	With aRegs[nx][16]
				Replace X1_F3   	With aRegs[nx][17]
				MsUnlock('SX1')
			Else
				Help('',1,'')
			EndIf
		Endif
	Next nX
Return
