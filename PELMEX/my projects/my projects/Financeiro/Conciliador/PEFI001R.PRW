#Include "RwMake.ch"
#Include "Protheus.ch"    
#include "TOPCONN.CH"

/*/{Protheus.doc} PEFI001R
@author RICARDO
@since 17/11/2015
@version P12 R1 
@description Funcao para leitura de arquivo de cartao e geracao de titulos de DEBITO no financeiro
@type function
/*/

User Function PEFI001R

	//Declaracao de Variaveis                                             
	Private cPerg := PadR("PEFI001R",10)
	Private oGeraTxt := Nil
	Private aHead 	:= {}
	Public  aRO		:= {}
	Public aCV      := {}
	Public _FilSA1 := xFilial("SA1")
	Public _FilSAE := xFilial("SAE")
	Private lGerou  := .F.
	Private _Dtemis := ""
	Private cClioper := Padr(AllTrim(Posicione("SAE",1,xFilial("SAE")+"002","AE_CODCLI")),TamSX3("A1_COD")[1],Space(1))	
	Private aErros := {}
	Private nContErr := 0

	if Select('TMPSE') > 0 
		TMPSE->(dBCloseArea())
	EndIf		

	If Empty(cClioper)
		Alert("Codigo da operadora 002 nao direcionado para nenhum cliente (SAE)")	
		Return	
	EndIf

	Private cLojaoper := Posicione("SA1",3,xFilial("SA1")+cClioper,"A1_LOJA")
	Private cNomeOper  := Posicione("SA1",3,xFilial("SA1")+cClioper,"A1_NOME")	

	AjustaSx1(cPerg)

	Pergunte(cPerg,.T.)

	// Montagem da tela de processamento.                                  
	@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geração de titulos de cartao REDECARD DEBITO ")
	@ 05,035 TO 080,185 PIXEL OF oGeraTxt
	//	@ 02,02 Jpeg FILE "gears.png" Size 024,024 PIXEL OF oGeraTxt
	@ 20,055 Say " Este programa irá Ler um arquivo texto       " PIXEL OF oGeraTxt
	@ 28,055 Say " conforme os parâmetros definidos  pelo usuário  " PIXEL OF oGeraTxt
	@ 36,055 Say " e gerar titulos de debito para vendas    " PIXEL OF oGeraTxt
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

	If At("REDEDEB",MV_PAR02) == 0

		Alert("Arquivo Invalido ! Programa executa somente arquivos REDECARD DEBITO")

		Return

	EndIf 


	While !FT_FEOF()   

		cLine  := FT_FReadLn() // Retorna a linha corrente  
		nRecno := FT_FRecno()  // Retorna o recno da Linha  

		//Processa registro 
		ProcTit(cLine)

		If !Empty(aHead)
			If Alltrim(aHead[1])!=Alltrim(MV_PAR01)
				Alert("Codigo do estabelecimento do arquivo diferente do informado nos parametros")
				exit
			EndIf
		EndIf
		// Pula para próxima linha  
		FT_FSKIP()

	Enddo

	// Fecha o Arquivo
	FT_FUSE()

	If !Empty(aErros) 

		GeraLog()

		Alert("Ocorreram  erros durante o processamento. ")

	Else

		Alert("Titulos gerados com sucesso!!")

	EndIf

	oGeraTxt:End()

return 

Static function ProcTit(cLine)

	Do Case
		Case Substr(cLine,1,2)=="00"
		GeraHead(cLine)
		Case Substr(cLine,1,2)=="01" 
		GeraRo(cLine)
		Case Substr(cLine,1,2)=="05"
		GeraCV(cLine)
		otherwise
		return
	EndCase	

return

Static function GeraHead(cLine)

	aAdd(aHead,SubStr(cLine,4,09)) //Numero do Estabelecimento
	aAdd(aHead,Substr(cLIne,13,8)) //Data do arquivo

return

Static function GeraRO(cLine)

	aRO := {}

	aAdd(aRO,Substr(cLine,004,009)) //01 - Numero da filiação da matriz
	aAdd(aRO,Substr(cLine,014,008)) //02 - Data credito 
	aAdd(aRO,Substr(cLine,023,008)) //03 - data resumo de vendas
	aAdd(aRO,Substr(cLine,032,009)) //04 - numero resumo vendas
	aAdd(aRO,Substr(cLine,042,006)) //05 - Quantidade comprovantes vendas
	aAdd(aRO,Substr(cLine,049,015)) //06 - valor bruto 
	aAdd(aRO,Substr(cLine,065,015)) //07 - valor desconto 
	aAdd(aRO,Substr(cLine,081,015)) //08 - valor liquido       
	aAdd(aRO,Substr(cLine,097,001)) //09 - tipo de resumo      
	aAdd(aRO,Substr(cLine,099,003)) //10 - banco 
	aAdd(aRO,Substr(cLine,103,006)) //11 - agencia
	aAdd(aRO,Substr(cLine,110,011)) //12 - conta corrente
	aAdd(aRO,Substr(cLine,122,001)) //13 - bandeira

return


Static function GeraCV(cLine)	

	aCV := {}

	aAdd(aCV,SubStr(cLine,004,009)) // 01 - Numero da filiação do ponto de venda
	aAdd(aCV,SubStr(cLine,014,009)) // 02 - nro resumo de venda
	aAdd(aCV,SubStr(cLine,024,008)) // 03 - data do cv
	aAdd(aCV,SubStr(cLine,033,015)) // 04 - valor bruto
	aAdd(aCV,SubStr(cLine,049,015)) // 05 - valor desconto
	aAdd(aCV,SubStr(cLine,065,015)) // 06 - valor liquido
	aAdd(aCV,SubStr(cLine,081,019)) // 07 - nro cartao
	aAdd(aCV,SubStr(cLine,101,001)) // 08 - tipo de transação
	aAdd(aCV,SubStr(cLine,103,012)) // 09 - numero CV
	aAdd(aCV,SubStr(cLine,116,008)) // 10 - Data Credito
	aAdd(aCV,SubStr(cLine,125,002)) // 11 - Status da transação
	aAdd(aCV,SubStr(cLine,128,006)) // 12 - hora da transação
	aAdd(aCV,SubStr(cLine,135,008)) // 13 - numero do terminal 
	aAdd(aCV,SubStr(cLine,144,002)) // 14 - tipo de captura
	aAdd(aCV,SubStr(cLine,147,005)) // 15 - reservado
	aAdd(aCV,SubStr(cLine,153,015)) // 16 - valor compra (para o compra e saque)
	aAdd(aCV,SubStr(cLine,169,015)) // 17 - valor do saque (para o compre e saque)
	aAdd(aCV,SubStr(cLine,185,001)) // 18 - bandeira

	GeraTIT() 							

return


Static function GeraNCC()

	Local aFIN040  := {}
	Local cE1Num   := ""
	Local aArea	 := GetArea()
	Local cLoja	 := "" 
	Local _Existe := ""
	Private lMsErroAuto := .F.		

	cQuery := "SELECT COUNT(E1_NUM) AS QUANT "
	cQuery += " FROM  SE1010 " 
	cQuery += " WHERE "
	//cQuery += " E1_ORIGEM = 'PEFI001R' " 
	cQuery += " E1_TIPO = 'NCC' "
	cQuery += " AND E1_NRDOC = '" + cValToChar(_NrDoc) + "' " 
	cQuery += " AND E1_NSUTEF = '" + aRO[04] + "' "	
	cQuerY += " AND E1_EMISSAO = '" + _Dtemis + "' "
	cQuery += " AND D_E_L_E_T_ = '' "

	cQuery := ChangeQuery( cQuery )  

	TcQuery cQuery New Alias "TMPSE" 

	dbSelectArea("TMPSE") 

	If TMPSE->QUANT = 0

		cE1Num   := GetSxeNum("SE1","E1_NUM")			
		_Existe := .T.		

		While _Existe

			DbSelectArea("SE1")
			DbSetOrder(1) 
			_Chproc := xfilial('SE1')+"RED"+cE1Num+"01 "+"NCC"
			if DbSeek(_ChProc) // pesquisa pelo nro do documento
				cE1Num   := GetSxeNum("SE1","E1_NUM")
			else
				_Existe := .F.
				ConfirmSX8()
			EndIf					
		EndDo	

		cLoja := Posicione("SA1",3,xFilial("SA1")+cCliente,"A1_LOJA")
		cNome  := Posicione("SA1",3,xFilial("SA1")+cCliente,"A1_NOME")

		_Dtemis := substr(aCV[3],5,4) + substr(aCV[3],3,2) + substr(aCV[3],1,2)

		aADD(aFIN040,{"E1_FILIAL" ,xFilial('SE1'),Nil})
		aADD(aFIN040,{"E1_PREFIXO","RED",nil})
		aADD(aFIN040,{"E1_NUM"    ,cE1Num,nil})
		aADD(aFIN040,{"E1_PARCELA","01",nil})
		aADD(aFIN040,{"E1_TIPO"   ,"NCC",nil})
		aADD(aFIN040,{"E1_XPAGTO"   ,"NCC",nil})
		aADD(aFIN040,{"E1_NATUREZ","12011",nil})
		aADD(aFIN040,{"E1_CLIENTE",cCliente,nil})
		aADD(aFIN040,{"E1_NOMCLI" ,cNome,nil})
		aADD(aFIN040,{"E1_LOJA"   ,cLoja,nil})
		aADD(aFIN040,{"E1_EMISSAO",StoD(_Dtemis),nil})
		aADD(aFIN040,{"E1_VENCTO" ,StoD(_Dtemis),nil})
		aADD(aFIN040,{"E1_VENCREA",StoD(_Dtemis),nil})
		aADD(aFIN040,{"E1_EMIS1"  ,dDatabase,nil})
		aADD(aFIN040,{"E1_VENCORI",StoD(_Dtemis),nil})
		aADD(aFIN040,{"E1_VALOR",_VlrBruto,nil})
		aADD(aFIN040,{"E1_SALDO"  ,_VlrBruto,nil})
		aADD(aFIN040,{"E1_HIST"   ,aCV[01] + '-' + aCV[13],nil})
		aAdd(aFIN040,{"E1_XMAQUIN",aCV[13],nil})		
		aAdd(aFIN040,{"E1_XBAND",_Band,nil})
		aADD(aFIN040,{"E1_SITUACA","0",nil})
		aADD(aFIN040,{"E1_MOEDA"  ,1,nil})
		aADD(aFIN040,{"E1_OCORREN","01",nil})
		aADD(aFIN040,{"E1_STATUS" ,"A",nil})
		aADD(aFIN040,{"E1_ORIGEM" ,"FINA040",nil})
		aADD(aFIN040,{"E1_FLUXO"  ,"S",nil})
		aADD(aFIN040,{"E1_MULTNAT","2",	nil})
		aADD(aFIN040,{"E1_DESDOBR","2",	nil})
		aADD(aFIN040,{"E1_FLUXO"  ,"S",	nil})
		aADD(aFIN040,{"E1_NSUTEF"  ,aRO[04],nil})
		aADD(aFIN040,{"E1_NRDOC"  ,cValToChar(_Nrdoc),nil})
		aADD(aFIN040,{"E1_CONTRAT",aRO[04],nil})
		aADD(aFIN040,{"E1_LA"     ,"N",	nil})
		aADD(aFIN040,{"E1_FILORIG",xFilial('SE1'),nil})	

		MsExecAuto({|x, y| Fina040(x, y)}, aFIN040, 3)

		If lMsErroAuto
			MostraErro("C:\TEMP\", "ERRO_REDENCC_" + _NrDoc + ".LOG")
		Else
			ConfirmSX8() 
		EndIf
	EndIf		
	TMPSE->(dbSkip())
	TMPSE->(dBCloseArea())

	_Valor := ""
	_Nrodoc := ""

	RestArea(aArea)
return


Static function GeraTIT()

	Local aFIN040  := {}
	Local aArea	   := GetArea()
	Local cE1Num   := ""
	Local _Existe := ""
	Local cFilMaq  := Posicione("ZAE",3,aCV[13],"ZAE_FILIAL")	
	Local _VlrLiq := val(aCV[06]) / 100
	Private _Band := aCV[18]
	Private _VlrBruto := val(aCV[04]) / 100
	Private _Nrdoc := val(aCV[09]) * 1	
	Private cCliente := Posicione("ZAE",3,aCV[13],"ZAE_CLIENT")	
	Private cNome	 := Posicione("SA1",3,xFilial("SA1")+cCliente,"A1_NOME") 

	Private lMsErroAuto := .F.	

	_Dtemis := substr(aCV[03],5,4) + substr(aCV[03],3,2) + substr(aCV[03],1,2)

	If _Dtemis < "20160101" 
		Return
	EndIf

	If !Empty(alltrim(cFilMaq))
		If cFilMaq <> cFilAnt
			Return
		EndIf
	EndIf	

	If Empty(cCliente)
		aADD(aErros,{"Maquina  " + aCV[13] + " do PV " + aCV[01] +"  nao cadastrada. (ZAE010)"})
		nContErr += 1
		Return
	EndIf	

	If Empty(cNome)

		aADD(aErros,{"Cliente " + cCliente + " na maquineta " + aCV[13] + " nao cadastrado. (SA1) "})

		nContErr += 1
		Return
	EndIf

	Do Case
		Case aCV[18] == "1"
		_Band := "MASTERCARD"
		Case aCV[18] == "2"
		_Band := "DINERS" 
		Case aCV[18] == "3" 
		_Band := "VISA" 
		Case aCV[18] == "4"
		_Band := "CABAL" 
		Case aCV[18] == "5"
		_Band := "HIPERCARD" 
		Case aCV[18] == "6"
		_Band := "SOROCRED" 
		Case aCV[18] == "7"
		_Band := "CUP"
		Case aCV[18] == "8"
		_Band := "CREDSYSTEM"
		Case aCV[18] == "9"
		_Band := "SICREDI"
		otherwise	
		_Band := aCV[18]
	End Case

	_Dtemis := substr(aCV[03],5,4) + substr(aCV[03],3,2) + substr(aCV[03],1,2)
	_Nrodoc := aCV[09]

	cQuery := "SELECT COUNT(E1_NUM) AS QUANT "
	cQuery += " FROM  SE1010 " 
	cQuery += " WHERE "
	//cQuery += " E1_ORIGEM = 'PEFI001R' " 
	cQuery += " E1_TIPO = 'CD' "
	cQuery += " AND E1_NRDOC = '" + cValToChar(_Nrdoc) + "' " 
	cQuery += " AND E1_CLIENTE = '" + cClioper + "' "
	cQuery += " AND E1_NSUTEF = '" + aRO[04] + "' "
	cQuerY += " AND E1_EMISSAO = '" + _Dtemis + "' "
	cQuery += " AND D_E_L_E_T_ = '' "

	cQuery := ChangeQuery( cQuery )  

	TcQuery cQuery New Alias "TMPSE" 

	dbSelectArea("TMPSE") 

	If TMPSE->QUANT = 0	

		cE1Num   := GetSxeNum("SE1","E1_NUM")			
		_Existe := .T.		

		While _Existe

			DbSelectArea("SE1")
			DbSetOrder(1) 
			_Chproc := xfilial('SE1')+"RED"+cE1Num+"01 "+"CD "
			if DbSeek(_ChProc) // pesquisa pelo nro do documento
				cE1Num   := GetSxeNum("SE1","E1_NUM")
			else
				_Existe := .F.
				ConfirmSX8()
			EndIf					
		EndDo	

		aADD(aFIN040,{"E1_FILIAL" ,xFilial('SE1'),Nil})
		aADD(aFIN040,{"E1_PREFIXO","RED",nil})
		aADD(aFIN040,{"E1_NUM"    ,cE1Num,	nil})
		aADD(aFIN040,{"E1_PARCELA","01",nil})
		aADD(aFIN040,{"E1_TIPO"   ,"CD",	nil})		
		aADD(aFIN040,{"E1_XPAGTO" ,"CD",	nil})		
		aAdd(aFIN040,{"E1_XBAND",_Band,nil})
		aADD(aFIN040,{"E1_NATUREZ","10701",nil})
		aADD(aFIN040,{"E1_CLIENTE",cClioper,	nil})
		aADD(aFIN040,{"E1_NOMCLI" ,cNomeoper,	nil})
		aADD(aFIN040,{"E1_LOJA"   ,cLojaoper,	nil})
		aADD(aFIN040,{"E1_EMISSAO",StoD(_Dtemis),nil})
		aADD(aFIN040,{"E1_VENCTO" ,StoD(_Dtemis),nil})
		aADD(aFIN040,{"E1_VENCREA",StoD(_Dtemis),nil})	
		aADD(aFIN040,{"E1_VENCORI",StoD(_Dtemis),nil})	
		aADD(aFIN040,{"E1_EMIS1"  ,dDatabase,nil})
		aADD(aFIN040,{"E1_VALOR"  ,_VlrLiq,nil})	
		aADD(aFIN040,{"E1_SALDO"  ,_VlrLiq,nil})
		aADD(aFIN040,{"E1_VLRREAL" ,_VlrBruto,nil})
		aADD(aFIN040,{"E1_HIST"   ,aCV[01] + '-' + aCV[13],nil})
		aAdd(aFIN040,{"E1_XMAQUIN",aCV[13],nil})
		aADD(aFIN040,{"E1_SITUACA","0",	nil})
		aADD(aFIN040,{"E1_MOEDA"  ,1,nil})
		aADD(aFIN040,{"E1_OCORREN","01",nil}) 
		aADD(aFIN040,{"E1_STATUS" ,"A",	nil})
		aADD(aFIN040,{"E1_NRDOC"  ,cValToChar(_Nrdoc),nil})
		aADD(aFIN040,{"E1_NSUTEF"  ,aRO[04],nil})
		aADD(aFIN040,{"E1_ORIGEM" ,"FINA040",nil})
		aADD(aFIN040,{"E1_FLUXO"  ,"S",	nil})
		aADD(aFIN040,{"E1_MULTNAT","2",	nil})
		aADD(aFIN040,{"E1_CONTRAT",aCV[02],	nil})
		aADD(aFIN040,{"E1_DESDOBR","2",	nil})
		aADD(aFIN040,{"E1_FLUXO"  ,"S",	nil})
		aADD(aFIN040,{"E1_LA"     ,"N",	nil})
		aADD(aFIN040,{"E1_FILORIG",xFilial('SE1'),nil})	

		MsExecAuto({|x, y| Fina040(x, y)}, aFIN040, 3)

		If lMsErroAuto
			MostraErro("c:\temp\", "ERRO_REDETIT" + aCV[09] + ".LOG")
		Else
			ConfirmSX8()
		EndIf

		RestArea(aArea)

	EndIf		

	TMPSE->(dbSkip())
	TMPSE->(dBCloseArea())

	GeraNCC()	

return

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

			FWrite(nHandle, aErros[nLinha,1] + CRLF)

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


