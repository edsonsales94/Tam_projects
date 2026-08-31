#Include "RwMake.ch"
#Include "Protheus.ch"    
#include "TOPCONN.CH"

/*/{Protheus.doc} PEFI002E
@author RICARDO
@since 10/08/2015
@version P12 R1 
@description Funcao para leitura de arquivo de cartao e geracao de titulos de credito no financeiro - LAYOUT NOVO
@type function
/*/

User Function PEFI002E

	//Declaracao de Variaveis                                             
	Private cPerg := PadR("PEFI002E",10)
	Private oGeraTxt := Nil
	Private aHead 	:= {}
	Public  aRO		:= {}
	Public aCV      := {}
	Private lVerif := .T.
	Private lGerou  := .F.
	Private _VlrTotal := 0
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

	Private cLojaoper := Posicione("SA1",1,xFilial("SA1")+cClioper,"A1_LOJA")
	Private cNomeOper  := Posicione("SA1",1,xFilial("SA1")+cClioper,"A1_NOME")	

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
	@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geração de titulos de cartao CIELO - LAYOUT NOVO")
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

	Private _VlrLiq := 0
	Private _VlrBruto := 0
	Private _GeraNDC := .t.
	Private _Tipo := ""
	Private _Cont := 0
	Private cVencto := ""
	Private cCliente := ""
	Private cNomCli := ""
	Private cLojaCli := ""
	Private _Natureza := ""
	Private cE1Num   := ""

	// Abre o arquivon
	Handle := FT_FUse(mv_par02)

	// Se houver erro de abertura abandona processamento
	if Handle == -1  
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
			Alert("Arquivo Invalido. Processo cancelado ! (Posicao 48 header # '03P')")
			Return
		Else			
			If Alltrim(aHead[1])!=Alltrim(MV_PAR01)
				Alert("Codigo do estabelecimento invalido. Processo Cancelado. ")
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
			Case Substr(cLine,1,1)=="0" .and. Substr(cLine,48,3) == "03P"
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

	//aAdd(aRO,SubStr(cLine, 002 , 000 )) // 0 - Estabelecimento Submissor 
	aAdd(aRO,SubStr(cLine, 012 , 007 )) // 1 - Número do RO 
	aAdd(aRO,SubStr(cLine, 019 , 002 )) // 2 - Parcela 
	aAdd(aRO,SubStr(cLine, 021 , 001 )) // 3 - Filter 
	aAdd(aRO,SubStr(cLine, 022 , 002 )) // 4 - Plano 
	aAdd(aRO,SubStr(cLine, 024 , 002 )) // 5 - Tipo de Transação 
	aAdd(aRO,SubStr(cLine, 026 , 006 )) // 6 - Data de apresentação 
	aAdd(aRO,SubStr(cLine, 032 , 006 )) // 7 - Data prevista de pagamento
	aAdd(aRO,SubStr(cLine, 038 , 006 )) // 8 - Data de envio 
	aAdd(aRO,SubStr(cLine, 044 , 001 )) // 9 - Sinal valor bruto valor a crédito.
	aAdd(aRO,SubStr(cLine, 045 , 013 )) // 10- Valor bruto  
	aAdd(aRO,SubStr(cLine, 058 , 001 )) // 11- Sinal da comissão 
	aAdd(aRO,SubStr(cLine, 059 , 013 )) // 12- Valor da comissão 
	aAdd(aRO,SubStr(cLine, 072 , 001 )) // 13- Sinal do valor rejeitado 
	aAdd(aRO,SubStr(cLine, 073 , 013 )) // 14- Valor rejeitado 
	aAdd(aRO,SubStr(cLine, 086 , 001 )) // 15- Sinal do valor líquido
	aAdd(aRO,SubStr(cLine, 087 , 013 )) // 16- Valor líquido 
	aAdd(aRO,SubStr(cLine, 100 , 004 )) // 17- Banco 
	aAdd(aRO,SubStr(cLine, 104 , 005 )) // 18- Agência
	aAdd(aRO,SubStr(cLine, 109 , 014 )) // 19- Conta-corrente 
	aAdd(aRO,SubStr(cLine, 123 , 002 )) // 20- Status do pagamento
	aAdd(aRO,SubStr(cLine, 125 , 006 )) // 21- Quantidade de CVs aceitos 
	aAdd(aRO,SubStr(cLine, 131 , 002 )) // 22- Identificador do Produto
	aAdd(aRO,SubStr(cLine, 133 , 006 )) // 23- Quantidades de CVs rejeitados 
	aAdd(aRO,SubStr(cLine, 139 , 001 )) // 24- Identificador de revenda/aceleração
	aAdd(aRO,SubStr(cLine, 140 , 006 )) // 25- Data da captura de transação 
	aAdd(aRO,SubStr(cLine, 146 , 002 )) // 26- Origem do ajuste 
	aAdd(aRO,SubStr(cLine, 148 , 013 )) // 27- Valor complementar 
	aAdd(aRO,SubStr(cLine, 161 , 001 )) // 28- Identificador de produto financeiro 
	aAdd(aRO,SubStr(cLine, 162 , 009 )) // 29- Número da operação financeira 
	aAdd(aRO,SubStr(cLine, 171 , 001 )) // 30- Sinal do valor Bruto antecipado crédito.
	aAdd(aRO,SubStr(cLine, 172 , 013 )) // 31- Valor Bruto Antecipado 
	aAdd(aRO,SubStr(cLine, 185 , 003 )) // 32- Código da Bandeira 
	aAdd(aRO,SubStr(cLine, 188 , 022 )) // 33- Número Único do RO 
	aAdd(aRO,SubStr(cLine, 210 , 004 )) // 34- Taxa de Comissão 
	aAdd(aRO,SubStr(cLine, 214 , 005 )) // 35- Tarifa 
	aAdd(aRO,SubStr(cLine, 219 , 004 )) // 36- Taxa de Garantia 
	aAdd(aRO,SubStr(cLine, 223 , 002 )) // 37- Meio de Captura 
	aAdd(aRO,SubStr(cLine, 225 , 008 )) // 38- Número lógico do terminal 
	aAdd(aRO,SubStr(cLine, 233 , 003 )) // 39- Identificador do Produto 
	aAdd(aRO,SubStr(cLine, 236 , 010 )) // 40- Matriz de Pagamento 
	aAdd(aRO,SubStr(cLine, 246 , 005 )) // 41- Uso Cielo Uso Cielo.

return

Static function GeraCV(cLine)

	aCV := {}

	//aAdd(aCV,Substr(cLine,001 , 001 )) // 00 - Tipo de registro 			
	aAdd(aCV,Substr(cLine,002 , 010 )) // 01 - Estabelecimento Submissor 
	aAdd(aCV,Substr(cLine,012 , 007 )) // 02 - Número do RO 				
	aAdd(aCV,Substr(cLine,019 , 019 )) // 03 - Número do cartão truncado 
	aAdd(aCV,Substr(cLine,038 , 008 )) // 04 - Data de venda /ajuste 	
	aAdd(aCV,Substr(cLine,046 , 001 )) // 05 - Sinal do valor da compra ou valor
	aAdd(aCV,Substr(cLine,047 , 013 )) // 06 - Valor da compra ou valor da parcela
	aAdd(aCV,Substr(cLine,060 , 002 )) // 07 - Parcela 								
	aAdd(aCV,Substr(cLine,062 , 002 )) // 08 - Total de parcelas 					
	aAdd(aCV,Substr(cLine,064 , 003 )) // 09 - Motivo da rejeição 					
	aAdd(aCV,Substr(cLine,067 , 006 )) // 10 - Código de autorização 				
	aAdd(aCV,Substr(cLine,073 , 020 )) // 11 - TID Identificação da transação 		
	aAdd(aCV,Substr(cLine,093 , 006 )) // 12 - NSU/DOC 								
	aAdd(aCV,Substr(cLine,099 , 013 )) // 13 - Valor Complementar 					
	aAdd(aCV,Substr(cLine,112 , 002 )) // 14 - Dig Cartão 							
	aAdd(aCV,Substr(cLine,114 , 013 )) // 15 - Valor total da venda 					
	aAdd(aCV,Substr(cLine,127 , 013 )) // 16 - Valor da próxima parcela 				
	aAdd(aCV,Substr(cLine,140 , 009 )) // 17 - Número da Nota Fiscal 				
	aAdd(aCV,Substr(cLine,149 , 004 )) // 18 - Indicador de cartão 					
	aAdd(aCV,Substr(cLine,153 , 008 )) // 19 - Número lógico do terminal 			
	aAdd(aCV,Substr(cLine,161 , 002 )) // 20 - Identificador de taxa 				
	aAdd(aCV,Substr(cLine,163 , 020 )) // 21 - Referência/código do pedido 			
	aAdd(aCV,Substr(cLine,183 , 006 )) // 22 - Hora da transação 					
	aAdd(aCV,Substr(cLine,189 , 029 )) // 23 - Número único da transação 			
	aAdd(aCV,Substr(cLine,218 , 001 )) // 24 - Indicador Cielo Promo 				
	aAdd(aCV,Substr(cLine,219 , 032 )) // 25 - Uso Cielo Reservado para Cielo.

	GeraTIT() 	

return

Static function GeraNCC()

	Local aFIN040  := {}
	Local _Existe := .T.

	//cQuery := "SELECT E1_NUM, E1_CLIENTE, E1_PARCELA, E1_NRDOC, E1_TIPO  "
	cQuery := "SELECT COUNT(E1_NUM) AS QUANT "
	cQuery += " FROM "+RetSqlName('SE1') 
	cQuery += " WHERE "
	cQuery += " E1_TIPO = 'NCC'  "
	Cquery += " AND E1_DOCTEF = '" + aCV[10] + "' "	
	cQuery += " AND E1_NSUTEF = '" + aCV[02] + "' "
	cQuery += " AND E1_NRDOC = '" + aCV[12] + "' "
	cQuery += " AND D_E_L_E_T_ = '' "	
	cQuery += " AND E1_ORIGEM = 'PEFI002E' " 

	//	cQuery += " ORDER BY E1_TIPO DESC

	cQuery := ChangeQuery( cQuery )  

	TcQuery cQuery New Alias "TMPSE" 

	dbSelectArea("TMPSE") 

	//If (Alltrim(TMPSE->E1_NRDOC) <> aCV[12]) // Registro nao existe 

	If TMPSE->QUANT == 0 

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

		cCliente := Posicione("ZAE",3,aCV[19],"ZAE_CLIENT")	

		If Empty(cCliente)
			aADD(aErros,{"Maquina de Cartao " + aCV[19] + "  nao cadastrada na tabela. (ZAE010)"})
			nContErr += 1			
			TMPSE->(dBCloseArea())
			Return
		EndIf				

		cLojaCli := Posicione("SA1",3,xFilial("SA1")+cCliente,"A1_LOJA")
		cNomCli  := Posicione("SA1",3,xFilial("SA1")+cCliente,"A1_NOME")

		_Parc := _Cont		

		If _Cont  == 1

			_VLrBruto := val(aCV[06]) / 100	

		Else

			_VlrBruto := val(aCV[15])  / 100	

		End		

		_Tipo := 'NCC'

		_VlrLiq := _VlrBruto	

		cVencto := StoD(aCV[04]) + 1

		_Natureza := "12011"

		If Empty(cNomCli)	
			aADD(aErros,{"Cliente " + cCliente + " nao cadastrado. (SA1) "})				
			nContErr += 1	
		Else

			GeraReceber()

		EndIf

	EndIf		

	TMPSE->(dbSkip())			
	TMPSE->(dBCloseArea())	

return

Static function GeraTIT()
	Local _Parc
	Local aFIN040  := {}
	Local aArea	   := GetArea()
	Local cQuery := ""
	Local _Chproc := ""
	Local _Existe := .T.
	Private _Cont := 0

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

	_Taxa := Val(aRO[34]) / 10000

	_VlrBruto := val(aCV[06]) / 100	

	_VlrLiq := _VlrBruto - (Round(_VlrBruto * _Taxa,2))

	cVencto := Stod(aCV[04])

	cCliente := cCliOper
	cLojaCli := cLojaOper
	cNomCli := cNomeOper

	_Natureza := "CARTAO"

	for _Parc := 1 to _Cont

		cQuery := "SELECT E1_NUM "
		cQuery += " FROM " + RetSqlName('SE1')
		cQuery += " WHERE "
		cQuery += " E1_NRDOC = '" + aCV[12] + "' " 
		cQuery += " AND E1_PARCELA = '" + cValToChar(_Parc) + "' " 
		cQuery += " AND E1_TIPO = '" + _Tipo + "' "
		Cquery += " AND E1_DOCTEF = '" + aCV[10] + "' "
		cQuery += " AND E1_EMISSAO = '" + aCV[04] + "' "
		cQuery += " AND D_E_L_E_T_ = '' "		
		cQuery += " AND E1_ORIGEM = 'PEFI002E' " 

		cQuery := ChangeQuery( cQuery )  

		TcQuery cQuery New Alias "TMPSE" 

		dbSelectArea("TMPSE") 

		if EMPTY(TMPSE->E1_NUM)  

			If _Tipo = 'CC'
				cNumDias := _Parc * 30  			
				cVencto := StoD(aCV[04]) + cNumDias			
			Endif

			GeraReceber()

		EndIf				

		TMPSE->(dbSkip())			
		TMPSE->(dBCloseArea())		

	Next _Parc		

	If !empty(aRO) 
		GeraNCC()
	Endif

	//	EndIf

	RestArea(aArea)
return

Static Function GeraReceber()

	Local aFIN040  := {}
	Local aArea	   := GetArea()
	Local lMsErroAuto := .F.	
	Private _Band := aRO[32]

	VerificaE1Num()

	CarregaBand()

	aADD(aFIN040, {"E1_FILIAL" ,xFilial("SE1")	,Nil})
	aAdd(aFIN040, {"E1_PREFIXO",_Prefixo,	nil})
	aAdd(aFIN040, {"E1_NUM"    ,cE1Num,	nil})
	aAdd(aFIN040, {"E1_PARCELA",cValToChar(_Parc),nil})
	aAdd(aFIN040, {"E1_TIPO"   ,_Tipo,	nil})
	aAdd(aFIN040, {"E1_XPAGTO" ,_Tipo,	nil})
	aAdd(aFIN040, {"E1_XBAND" ,_Band,	nil})
	aAdd(aFIN040, {"E1_NATUREZ",_Natureza,nil})
	aAdd(aFIN040, {"E1_CLIENTE",cCliente,	nil})
	aAdd(aFIN040, {"E1_NOMCLI" ,cNomCli,	nil})
	aAdd(aFIN040, {"E1_LOJA"   ,cLojaCli,	nil})
	aAdd(aFIN040, {"E1_EMISSAO",StoD(aCV[04]),nil})
	aAdd(aFIN040, {"E1_VENCTO" ,cVencto,nil})
	aAdd(aFIN040, {"E1_VENCREA",cVencto,nil})				
	aAdd(aFIN040, {"E1_VALOR"  ,_VlrLiq,nil})
	aAdd(aFIN040, {"E1_SALDO"  ,_VlrLiq,nil})
	aAdd(aFIN040, {"E1_VLRREAL" ,_VlrBruto,nil})
	aAdd(aFIN040, {"E1_EMIS1"  ,dDatabase,nil})
	aAdd(aFIN040, {"E1_HIST"   ,aCV[01] + '-' + aCV[18] ,nil})
	aAdd(aFIN040, {"E1_NSUTEF",aCV[02],	nil})
	aAdd(aFIN040, {"E1_XMAQUIN",aCV[19],	nil})
	aAdd(aFIN040, {"E1_SITUACA","0",nil})
	aAdd(aFIN040, {"E1_VENCORI",cVencto,nil})
	aAdd(aFIN040, {"E1_MOEDA"  ,1,	nil})
	aAdd(aFIN040, {"E1_OCORREN","01",nil})
	aAdd(aFIN040, {"E1_STATUS" ,"A",nil})
	aAdd(aFIN040, {"E1_NRDOC" ,aCV[12],nil})
	aAdd(aFIN040, {"E1_DOCTEF" ,aCV[10],nil})
	aAdd(aFIN040, {"E1_ORIGEM" ,"PEFI002E",nil})
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

Return

Static Function VerificaE1num()

	Local _Existe := .T.

	cE1Num   := GetSxeNum("SE1","E1_NUM")

	While _Existe 

		cQuery := ""							
		cQuery := "SELECT E1_NUM "
		cQuery += " FROM "+RetSqlName('SE1') 
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
	TMPSC->(dBCloseArea())	

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

Static Function CarregaBand()

	Do Case
		Case aRO[32] == "001" 			
		_Band := "VISA"
		Case aRO[32] == "002"			
		_Band := "MASTER"	
		Case aRO[32] == "006"
		_Band := "SOROCRED"
		Case aRO[32] == "007"
		_Band := "ELO"
		Case aRO[32] == "009"
		_Band := "DINERS/DISCOVER"	
		Case aRO[32] == "011"
		_Band := "AGIPLAN" 
		Case aRO[32] == "015"
		_Band := "BANESCARD"
		Case aRO[32] == "023"
		_Band := "CABAL" 				
		Case aRO[32] == "029"
		_Band := "CREDSYSTEM" 
		Case aRO[32] == "035"
		_Band := "ESPLANADA" 
		Case aRO[32] == "064"
		_Band := "CREDZ" 
	EndCase	

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
