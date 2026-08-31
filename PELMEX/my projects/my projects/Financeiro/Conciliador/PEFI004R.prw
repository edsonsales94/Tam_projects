#Include "RwMake.ch"
#Include "Protheus.ch"    
#include "TOPCONN.CH" 

/*/{Protheus.doc} PEFI004R
@author Ricardo
@since 16/05/2016
@version P12 R1 
@description Baixa de titulos RedeCard com lançamento bancario
@type function
/*/

User Function PEFI004R

	//Declaracao de Variaveis                                             
	Private cPerg	:= PadR("PEFI004R",10)
	Private oGeraTxt := Nil
	Private oGeraTxt1 := Nil
	Private aHead 	:= {}
	Private aAnt	:= {}
	Private aLiq    := {}
	Private aErros 	:= {}
	Private nContErr := 0
	Private aBanco := {}
	Private _Prefixo := "RED"

	Private _Rv := ''
	Private _Parc := ''
	Private _Banco := ''
	Private _Agencia := ''
	Private _Conta := ''
	Private _Valor := 0

	AjustaSx1(cPerg)

	Pergunte(cPerg,.T.)

	// Montagem da tela de processamento.                                  
	@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Conciliação Baixas REDECARD")
	@ 05,035 TO 080,185 PIXEL OF oGeraTxt
	@ 20,055 Say " Este programa irá Ler um arquivo texto         " PIXEL OF oGeraTxt
	@ 28,055 Say " conforme os parâmetros definidos  pelo usuário " PIXEL OF oGeraTxt
	@ 36,055 Say " para BAIXAR os titulos REDECARD atraves de uma " PIXEL OF oGeraTxt
	@ 44,055 Say " fatura com Lançamento Bancário.                " PIXEL OF oGeraTxt
	@ 74,090 BMPBUTTON TYPE 01 ACTION MsgRun("Aguarde ..  "+MV_PAR02,"Aviso",{||OkLerTxt()})
	@ 74,120 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
	@ 74,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

	Activate Dialog oGeraTxt Centered

Return()

Static Function OkLerTxt

	Private cClioper := Padr(AllTrim(Posicione("SAE",1,xFilial("SAE")+"002","AE_CODCLI")),TamSX3("A1_COD")[1],Space(1))	
	Private cNomeOper := Posicione("SA1",3,xFilial("SA1")+cClioper,"A1_NOME")		
	Private _ArqTexto := AllTrim(Substr(mv_par02,Rat("\",mv_par02)+1,99))

	If At("REDEFIN", Upper(MV_PAR02)) == 0

		Alert("Arquivo com formato invalido - Nome REDEFIN " )

		Return

	EndIf

	If Empty(cClioper)
		Alert("Codigo da operadora 002 nao direcionado para nenhum cliente (SAE)")	
		Return	
	EndIf

	if Select('TMPSE') > 0 
		TMPSE->(dBCloseArea())
	EndIf
	if Select('TMPSA') > 0 
		TMPSA->(dBCloseArea())
	EndIf

	If Select('ARQTMP') > 0
		ARQTMP->(dBCloseArea())
	EndIf

	// cria o arquivo temporario 

	CriaArqTemp()

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

	While !FT_FEOF()   

		cLine  := FT_FReadLn() // Retorna a linha corrente  
		nRecno := FT_FRecno()  // Retorna o recno da Linha  

		//Processa registro 
		ProcTit(cLine)

		// Pula para próxima linha  
		FT_FSKIP()

	Enddo

	// Fecha o Arquivo
	FT_FUSE()


	If !Empty(aErros) 		

		GeraLog()	

		Alert("Ocorreram  erros durante o processamento. Processo Cancelado.")		

	Else

		ProcessaTemp() // processa o arquivos temporario	

		Alert("Titulos gerados com sucesso!!")

	EndIf

	oGeraTxt:End()

return 


Static function ProcTit(cLine)

	Do Case
		Case Substr(cLine,1,3)=="034" // Creditos
		MontaCred(cLine)
		Case Substr(cLine,1,3)=="036" // Antecipações 
		MontaAnt(cLine)
	EndCase		
return


Static function MontaAnt(cLine)	

	aAnt := {}

	aAdd(aAnt,SubStr(cLine, 001, 003)) // 01 -  Tipo de registro (“036”)
	aAdd(aAnt,SubStr(cLine, 004, 009)) // 02 -  Número do PV
	aAdd(aAnt,SubStr(cLine, 013, 011)) // 03 -  Número do documento
	aAdd(aAnt,SubStr(cLine, 024, 008)) // 04 -  Data do lançamento (DDMMAAAA)
	aAdd(aAnt,SubStr(cLine, 032, 015)) // 05 -  Valor do lançamento
	aAdd(aAnt,SubStr(cLine, 047, 001)) // 06 -  C (crédito)
	aAdd(aAnt,SubStr(cLine, 048, 003)) // 07 -  Banco
	aAdd(aAnt,SubStr(cLine, 051, 006)) // 08 -  Agência
	aAdd(aAnt,SubStr(cLine, 057, 010)) // 09 -  Conta-corrente
	aAdd(aAnt,SubStr(cLine, 068, 009)) // 10 -  Número do RV correspondente
	aAdd(aAnt,SubStr(cLine, 077, 008)) // 11 -  Data do RV correspondente (DDMMAAAA)
	aAdd(aAnt,SubStr(cLine, 085, 015)) // 12 -  Valor do crédito original
	aAdd(aAnt,SubStr(cLine, 100, 008)) // 13 -  Data do vencimento original (DDMMAAAA)
	aAdd(aAnt,SubStr(cLine, 108, 002)) // 14 -  Número da parcela/total
	aAdd(aAnt,SubStr(cLine, 113, 015)) // 15 -  Valor bruto
	aAdd(aAnt,SubStr(cLine, 128, 015)) // 16 -  Valor da taxa de desconto
	aAdd(aAnt,SubStr(cLine, 143, 009)) // 17 -  Nº PV original
	aAdd(aAnt,SubStr(cLine, 152, 001)) // 18 -  Bandeira

	GeraAnt()

return

Static function MontaCred(cLine)	

	aCred := {}

	aAdd(aCred,SubStr(cLine,001 , 003)) // 01 -  Tipo de registro (“034”)
	aAdd(aCred,SubStr(cLine,004 , 009)) // 02 -  Número do PV centralizador
	aAdd(aCred,SubStr(cLine,013 , 011)) // 03 -  Número do documento
	aAdd(aCred,SubStr(cLine,024 , 008)) // 04 -  Data do lançamento (DDMMAAAA)
	aAdd(aCred,SubStr(cLine,032 , 015)) // 05 -  Valor do lançamento
	aAdd(aCred,SubStr(cLine,047 , 001)) // 06 -  C (crédito)
	aAdd(aCred,SubStr(cLine,048 , 003)) // 07 -  Banco
	aAdd(aCred,SubStr(cLine,051 , 006)) // 08 -  Agência
	aAdd(aCred,SubStr(cLine,057 , 010)) // 09 -  Conta-corrente
	aAdd(aCred,SubStr(cLine,068 , 008)) // 10 -  Data do movimento (DDMMAAAA)
	aAdd(aCred,SubStr(cLine,076 , 009)) // 11 -  Número do RV
	aAdd(aCred,SubStr(cLine,085 , 008)) // 12 -  Data do RV (DDMMAAAA)
	aAdd(aCred,SubStr(cLine,093 , 001)) // 13 -  Bandeira
	aAdd(aCred,SubStr(cLine,094 , 001)) // 14 -  Tipo de transação
	aAdd(aCred,SubStr(cLine,095 , 015)) // 15 -  Valor bruto do RV
	aAdd(aCred,SubStr(cLine,110 , 015)) // 16 -  Valor da taxa de desconto
	aAdd(aCred,SubStr(cLine,125 , 002)) // 17 -  Número da parcela/total
	aAdd(aCred,SubStr(cLine,130 , 002)) // 18 -  Status do crédito - Tabela II
	aAdd(aCred,SubStr(cLine,132 , 009)) // 19 -  Nº PV Original

	GeraCred()

return


Static function GeraAnt()

	_Rv := aAnt[10]
	_Parc := val(aAnt[14]) * 1
	_Banco := aAnt[07]
	_Agencia := val(aAnt[08]) * 1
	_Conta := val(aAnt[09]) * 1
	_Valor := Val(aAnt[05])

	GeraTemp()	

return

Static function GeraCred()

	_Rv := aCred[11]
	_Parc := val(aCred[17]) * 1	
	_Banco := aCred[07]
	_Agencia := val(aCred[08]) * 1
	_Conta := val(aCred[09]) * 1
	_Valor := Val(aCRed[05])

	GeraTemp()

return

Static Function GeraTemp()

	Local aArea	   := GetArea()
	Local cQuery := ""
	Local _Bco := ''
	Local _VlrTotal := 0
	Local lMsErroAuto := .F.

	cQuery := "SELECT E1_FILIAL,E1_PREFIXO ,E1_NUM, "
	cQuery += " E1_PARCELA,E1_TIPO ,E1_CLIENTE,E1_LOJA , E1_VALOR "
	cQuery += " FROM  SE1010 "
	cQuery += " WHERE "
	Cquery += " E1_FILIAL = '" + xFilial("SE1") + "' "
	cQuery += " AND E1_NSUTEF = '" + _Rv + "' "	
	cQuery += " AND E1_PARCELA = '" + cValToChar(_Parc) + "' "
	cQuery += " AND E1_TIPO IN ('CC','CD') "
	cQuery += " AND E1_PREFIXO = 'RED' " 	
	cQuery += " AND E1_BAIXA = '' "
	cQuery += " AND D_E_L_E_T_ = '' "
	cQuery := ChangeQuery( cQuery )  

	TcQuery cQuery New Alias "TMPSE" 

	dbSelectArea("TMPSE") 

	TMPSE->(dbGoTop())

	if !Empty(TMPSE->E1_NUM) 

		While !TMPSE->(Eof())

			_VlrTotal += TMPSE->E1_VALOR

			dbSelectArea("ARQTMP")

			RecLock("ARQTMP",.T.)
			ARQTMP->TP_BANCO := _Banco
			ARQTMP->TP_AGENCIA := cValToChar(_Agencia) 
			ARQTMP->TP_CONTA := cValToChar(_Conta)

			ARQTMP->TP_PREFIXO := TMPSE->E1_PREFIXO
			ARQTMP->TP_NUM := TMPSE->E1_NUM
			ARQTMP->TP_PARCELA:= TMPSE->E1_PARCELA
			ARQTMP->TP_TIPO := TMPSE->E1_TIPO
			ARQTMP->TP_CLIENTE := TMPSE->E1_CLIENTE
			ARQTMP->TP_LOJA := TMPSE->E1_LOJA
			ARQTMP->TP_VALOR := TMPSE->E1_VALOR	
			ARQTMP->(MsUnlock())

			TMPSE->(DbSkip())

		EndDo	

		If (_VlrTotal - (_Valor / 100)) <> 0 		

			aADD(aErros,{"Valores Incorretos: Resumo Venda: " + _Rv + ", Parcela: " +  cValtochar(_Parc) + ". Valor Baixa " + cValtochar(_Valor) + ". Valor Venda " + cValtochar(_VlrTotal) + "."}) 
			nContErr += 1

		EndIf

	EndIf
	TMPSE->(dBCloseArea())
Return

Static Function ProcessaTemp() 

	Local aArea	   := GetArea()
	Local aBaixa := {}	
	Local _ProcAntes := "@"
	Local _Proc := ''
	Local cQuery := ""
	Local lMsErroAuto := .f.
	Private _Banco := ''
	Private _Agencia := ''
	Private _Conta := ''
	Private _VlrTotal := 0	
	Private _Fatura := ""

	dbSelectArea("ARQTMP")
	dbGoTop()

	While !ARQTMP->(Eof()) .or. !Empty(_Proc) 

		_Proc := trim(ARQTMP->TP_BANCO) + trim(ARQTMP->TP_AGENCIA) + trim(ARQTMP->TP_CONTA)

		If !Empty(_proc) 

			If _ProcAntes <> _Proc 

				If _ProcAntes <> "@"

					GeraFatura() // gera e baixa a fatura com lancamento bancário

				EndIf					

				// procura banco, agencia e conta validos

				cQuery := "SELECT A6_AGENCIA, A6_NUMCON  "
				cQuery += " FROM  SA6010 " 
				cQuery += " WHERE "
				cQuery += " A6_COD = '" + trim(ARQTMP->TP_BANCO) + "' "
				Cquery += " AND A6_AGENCIA LIKE '%" + cValToChar(trim(ARQTMP->TP_AGENCIA)) + "%' "
				cQuery += " AND A6_NUMCON LIKE '%" + cValToChar(trim(ARQTMP->TP_CONTA)) + "%' " 

				cQuery := ChangeQuery( cQuery )  

				TcQuery cQuery New Alias "TMPSA" 

				dbSelectArea("TMPSA") 

				TMPSA->(dbGoTop())

				If EMPTY(TMPSA->A6_AGENCIA)				
					Alert("Agencia " + cValToChar(_AgenciaAntes) + ", Conta " + cValToChar(_ContaAntes) + " Nao cadastrada para o banco " + _BancoAntes + " . ")
					TMPSA->(dbCloseArea())
					Return	
				EndIf

				_Banco := ARQTMP->TP_BANCO
				_Agencia := TMPSA->A6_AGENCIA
				_Conta := TMPSA->A6_NUMCON

				_Fatura   := GETSXENUM("SE1","E1_FATURA") //Busca na SXE

				ConfirmSX8()

				_VLrTotal := 0

			EndIf	

			If Empty(_Fatura) 

				Alert("Nao foi possivel gerar o nro de fatura ")

			Else			

				DbSelectArea("SE1")

				DbSetOrder(1) // prefixo+Titulo+Parcela+Tipo

				if DbSeek(cFilAnt+"RED"+ARQTMP->TP_NUM+ARQTMP->TP_PARCELA+ARQTMP->TP_TIPO)  // 

					RecLock("SE1", .F.)  // Alterada Registro incluindo Codigo 

					SE1->E1_FATURA := _Fatura	   											

					SE1->(MsUnlock())

				EndIf

				//->Baixa o titulo
				AADD(aBaixa, {"E1_FILIAL"    	,cFilAnt			,Nil})
				AADD(aBaixa, {"E1_PREFIXO" 		,ARQTMP->TP_PREFIXO 	,Nil})
				AADD(aBaixa, {"E1_NUM"  		,ARQTMP->TP_NUM      	,Nil})
				AADD(aBaixa, {"E1_PARCELA" 		,ARQTMP->TP_PARCELA  	,Nil})
				AADD(aBaixa, {"E1_TIPO"     	,ARQTMP->TP_TIPO    	,Nil})
				AADD(aBaixa, {"E1_CLIENTE"   	,ARQTMP->TP_CLIENTE 	,Nil})
				AADD(aBaixa, {"E1_LOJA"     	,ARQTMP->TP_LOJA    	,Nil})
				AADD(aBaixa, {"AUTJUROS"    	,0       				,Nil})
				AADD(aBaixa, {"AUTMULTA"    	,0        				,Nil})
				AADD(aBaixa, {"AUTMOTBX"    	,"FAT"           		,Nil})
				AADD(aBaixa, {"AUTDTBAIXA" 		,dDataBase        		,Nil})
				AADD(aBaixa, {"AUTDTCREDITO" 	,dDataBase       		,Nil})
				AADD(aBaixa, {"AUTVALREC"		,ARQTMP->TP_VALOR   	,Nil})
				AADD(aBaixa, {"AUTHIST"     	,"PEFI004R " + _Rv 		,Nil})			

				MSExecAuto({|x| FINA070(x)},aBaixa,3)

				If lMsErroAuto
					MostraErro("c:\temp\", "ERRO_BAIXA_" + _BcoAntes + ".LOG")
				EndIf

				_VlrTotal += ARQTMP->TP_VALOR				

				_BancoAntes := ARQTMP->TP_BANCO
				_AgenciaAntes := ARQTMP->TP_AGENCIA
				_ContaAntes := ARQTMP->TP_CONTA
				aBaixa := {}	

			EndIF	

		End

		_ProcAntes := _Proc

		ARQTMP->(dbSkip())

	Enddo

	If _VlrTotal > 0 .AND. !Empty(_Fatura)
		GeraFatura()
	EndIf			

Return

Static Function GeraFatura()

	Local aArea	   := GetArea()
	Local aTit := {}
	Local lMsErroAuto := .f.

	AADD(aTit , {"E1_FILIAL" , cFilAnt			  	, NIL})
	AADD(aTit , {"E1_PREFIXO", "RED"			  	, NIL})
	AADD(aTit , {"E1_NUM"    , _Fatura           	, NIL})
	AADD(aTit , {"E1_PARCELA", "1"				  	, NIL})
	AADD(aTit , {"E1_CLIENTE", cClioper	  			, NIL})
	AADD(aTit , {"E1_LOJA"   , "01"			     	, NIL})
	AADD(aTit , {"E1_NSUTEF" , _Rv		     		, NIL})
	AADD(aTit , {"E1_NOMCLI" , cNomeOper			, NIL})
	AADD(aTit , {"E1_MOEDA"  , 1 			      	, NIL})
	AADD(aTit , {"E1_EMISSAO", dDataBase			, NIL})
	AADD(aTit , {"E1_EMIS1"	 , dDataBase		  	, NIL})
	AADD(aTit , {"E1_VENCTO" , dDatabase            , NIL})
	AADD(aTit , {"E1_VENCREA", dDatabase     		, NIL})
	AADD(aTit , {"E1_VENCORI", dDatabase			, NIL})
	AADD(aTit , {"E1_VALOR"  , _VlrTotal	       	, NIL})
	AADD(aTit , {"E1_SALDO"  , _VlrTotal       		, NIL})
	AADD(aTit , {"E1_VLCRUZ" , _VlrTotal			, NIL})
	AADD(aTit , {"E1_STATUS" , "A"				  	, NIL})
	AADD(aTit , {"E1_OCORREN", "01"				  	, NIL})
	AADD(aTit , {"E1_ORIGEM" , "PEFI004R"			, NIL})
	AADD(aTit , {"E1_TIPO"   , "FI"               	, NIL})
	AADD(aTit , {"E1_NATUREZ", '10702'    	     	, NIL})
	AADD(aTit , {"E1_SITUACA", "0" 			   	  	, NIL})
	AADD(aTit , {"E1_FATURA" , "NOTFAT"           	, NIL})
	AADD(aTit , {"E1_HIST"	 , "PEFI004R-INC.FAT" 	,  NIL})

	MsExecAuto({|x, y| Fina040(x, y)}, aTit, 3)

	If lMsErroAuto
		MostraErro("c:\temp\", "ERRO_GERA_FATURA_" + _cFatura + ".LOG")
	EndIf

	BaixaFatura() 

Return

Static Function BaixaFatura()

	Local aArea	   := GetArea()
	Local aTitulos := Array(8)
	Local aRecno := {} 
	Local lMsErroAuto := .f.
	Local cQuery := ''	

	DbSelectArea("SE1")

	DbSetOrder(1) // prefixo+Titulo+Parcela+Tipo

	if DbSeek(cFilAnt+"RED"+_Fatura+"1  "+"FI ")  // pesquisa pelo CNPJ

		aAdd(aRecno,SE1->(RECNO())) 

	EndIf		

	//// baixa fatura  gerada	

	aTitulos[1] := aRecno
	aTitulos[2] := _Banco			
	aTitulos[3] := _Agencia			
	aTitulos[4] := _Conta
	aTitulos[5] := Nil
	aTitulos[6] := NIl		
	aTitulos[7] := "10702"		
	aTitulos[8] := dDataBase	
	MSExecAuto({|x,y| Fina110(x,y)},3, aTitulos)

	If lMsErroAuto
		MostraErro("c:\temp\", "ERRO_BAIXA_FATURA_" + _Fatura + ".LOG")
	EndIf	

Return

Static Function CriaArqTemp()

	//³Nome do arquivo temporário³
	Local cArqTrab	:= ""
	Local aInd		:= {}
	Local aTamSX3	:= {}
	Local aCampos	:= {}
	Local nA := 0

	//criando campo com base em campo existente no dicionário de dados (SX3)
	//a função TamSX3 retorna um array com as especificações do dicionário para o campo passado como parâmetro
	aTamSX3	:= TamSX3("A6_COD")
	aAdd(aCampos,{"TP_BANCO",aTamSX3[3],aTamSX3[1],aTamSX3[2]})
	aTamSX3	:= TamSX3("A6_AGENCIA")
	aAdd(aCampos,{"TP_AGENCIA",aTamSX3[3],aTamSX3[1],aTamSX3[2]})
	aTamSX3	:= TamSX3("A6_NUMCON")
	aAdd(aCampos,{"TP_CONTA",aTamSX3[3],aTamSX3[1],aTamSX3[2]})

	aTamSX3	:= TamSX3("E1_PREFIXO")
	aAdd(aCampos,{"TP_PREFIXO",aTamSX3[3],aTamSX3[1],aTamSX3[2]})
	aTamSX3	:= TamSX3("E1_NUM")
	aAdd(aCampos,{"TP_NUM",aTamSX3[3],aTamSX3[1],aTamSX3[2]})
	aTamSX3	:= TamSX3("E1_PARCELA")
	aAdd(aCampos,{"TP_PARCELA",aTamSX3[3],aTamSX3[1],aTamSX3[2]})

	aTamSX3	:= TamSX3("E1_TIPO")
	aAdd(aCampos,{"TP_TIPO",aTamSX3[3],aTamSX3[1],aTamSX3[2]})
	aTamSX3	:= TamSX3("E1_VALOR")
	aAdd(aCampos,{"TP_VALOR",aTamSX3[3],aTamSX3[1],aTamSX3[2]})
	aTamSX3	:= TamSX3("E1_CLIENTE")
	aAdd(aCampos,{"TP_CLIENTE",aTamSX3[3],aTamSX3[1],aTamSX3[2]})
	aTamSX3	:= TamSX3("E1_LOJA")
	aAdd(aCampos,{"TP_LOJA",aTamSX3[3],aTamSX3[1],aTamSX3[2]})	

	//Montando o array que irá definir o índice, onde cada registro no array irá representar um dos índices da tabela
	//primeira posição: nome do arquivo temporário para o índice.
	//segunda posicao: nome dos campos que irão compôr o índice. Lembrando que esses nomes de campos tem que ser iguais 
	//ao existente na primeira posição dos registros do array aCampos
	//terceira posicao: nome dos campos que formam o índice
	aAdd(aInd,{CriaTrab(Nil,.F.),"TP_BANCO+TP_AGENCIA+TP_CONTA","Banco+agencia+conta"})

	//Cria o arquivo temporário, passando para o CriaTrab o array com a estrutura de campos da tabela a ser gerada
	//primeiro parâmetro: campos para criar o arquivo de trabalho
	//segundo parâmetro: caso verdadeiro (.T.), cria o arquivo. Caso falso (.F.), somente retorna o nome disponível para o arquivo.
	cArqTrab	:= CriaTrab(aCampos,.T.)        

	//Seleciona o arquivo temporário como uma área de trabalho válida e atribui o Alias "ARQTMP"
	dbUseArea(.T.,"DBFCDX",cArqTrab,"ARQTMP",.T.,.F.)

	dbSelectArea("ARQTMP")

	//Cria os índices utiliando o comando IndRegua
	For nA	:= 1 to Len(aInd)                        
		//Cria os índices utiliando o comando IndRegua
		IndRegua("ARQTMP",aInd[nA,1],aInd[nA,2],,,OemToAnsi("Criando Índice Temporário..."))
	Next nA 
return

Static Function AjustaSX1(cPerg)

	Local aRegs   := {}
	Local _sAlias := Alias()
	Local nX      := 0

	aAdd(aRegs,{cPerg,'01','Estabelecimento ?','Estabelecimento ?','Estabelecimento ?','mv_ch1','C',10,0,0,'G','','mv_par01','','','',''   })
	aAdd(aRegs,{cPerg,'02','Ler Arq. em ?   ','Gerar Arq. em ?   ','Gerar Arq. em ?   ','mv_ch2','C',45,0,0,'G','','mv_par02','','','',''   })

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

Static Function GeraLog()	

	Local nHandle := "", nLinha
	Private cDir    := substr(mv_par02,1,Rat("\",mv_par02))
	Private cArq    := "Erro_"+AllTrim(Substr(mv_par02,Rat("\",mv_par02)+1,99))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FCreate - É o comando responsavel pela criação do arquivo.                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nHandle := FCreate(cDir+cArq)

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





