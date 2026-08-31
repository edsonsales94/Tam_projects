#Include "RwMake.ch"
#Include "Protheus.ch"   
#include "TOPCONN.CH"

 
/*/{Protheus.doc} PEFI002R
@author 	Ricardo
@since 10/08/2015
@version P12 R1 
@description Funcao para leitura de arquivo de cartao e geracao de titulos de CREDITO no financeiro
@type function
/*/

User Function PEFI002R

	//Declaracao de Variaveis                                             
	Private cPerg := PadR("PEFI002R",10)
	Private oGeraTxt := Nil
	Private aHead 	:= {}
	Public  aRO		:= {}
	Public aCV      := {}
	Private lGerou  := .F.
	Private _VlrTotal := 0	
	Private _Parc := 0	
	Private cVencto := ""
	Private _ChProc := ""
	Private cClioper  := Padr(AllTrim(Posicione("SAE",1,xFilial("SAE")+"002","AE_CODCLI")),TamSX3("A1_COD")[1],Space(1))			
	Private aErros := {}
	Private nContErr := 0
		
	if Select('TMPSE') > 0 
		TMPSE->(dBCloseArea())
	EndIf
	
	If Select('TMPSE1') > 0 
		TMPSE1->(dBCloseArea())
	EndIf
	
	If Select('TMPSE2') > 0 
		TMPSE2->(dBCloseArea())
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
	@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geração de titulos de REDECARD CREDITO")
	@ 05,035 TO 080,185 PIXEL OF oGeraTxt
	//	@ 02,02 Jpeg FILE "gears.png" Size 024,024 PIXEL OF oGeraTxt
	@ 20,055 Say " Este programa irá Ler um arquivo texto       " PIXEL OF oGeraTxt
	@ 28,055 Say " conforme os parâmetros definidos  pelo usuário  " PIXEL OF oGeraTxt
	@ 36,055 Say " e gerar titulos de credito para vendas    " PIXEL OF oGeraTxt
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
	
	If At("REDECRE",MV_PAR02) == 0
	
		Alert("Arquivo Invalido ! Programa executa somente arquivos REDECARD CREDITO")
		
		Return
		
	EndIf 


	While !FT_FEOF()   

		cLine  := FT_FReadLn() // Retorna a linha corrente  
		nRecno := FT_FRecno()  // Retorna o recno da Linha  
				
		//Processa registro 
		ProcTit(cLine)

		If !Empty(aHead)
			If Alltrim(aHead[1])!=Alltrim(MV_PAR01)
				Alert("Codigo do estabelimento invalido.")
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
		Case Substr(cLine,1,3)=="002" 
			GeraHead(cLine)
		Case Substr(cLine,1,3)=="010" .or. Substr(cLine,1,3) == "006"
			GeraRo(cLine)
		Case Substr(cLine,1,3)=="012" .or. Substr(cLine,1,3) == "008"
			GeraCV(cLine)
		otherwise
			return
	EndCase	

return

Static function GeraHead(cLine)

	aAdd(aHead,SubStr(cLine,78,9)) //Numero do Estabelecimento
	aAdd(aHead,Substr(cLIne,04,8)) //Data do arquivo 

return


Static function GeraRo(cLine)	

	aRO := {}

	aAdd(aRO,SubStr(cLine,004,003)) // 01 - Numero PV
	aAdd(aRO,SubStr(cLine,013,009)) // 02 - Numero RV
	aAdd(aRO,SubStr(cLine,022,003)) // 03 - nro banco
	aAdd(aRO,SubStr(cLine,025,005)) // 04 - nro agencia
	aAdd(aRO,SubStr(cLine,030,011)) // 05 - nro conta corrente
	aAdd(aRO,SubStr(cLine,041,008)) // 06 - data rv 
	aAdd(aRO,SubStr(cLine,049,005)) // 07 - Quantidade CV
	aAdd(aRO,SubStr(cLine,054,015)) // 08 - Valor bruto     
	aAdd(aRO,SubStr(cLine,069,015)) // 09 - Valor Gorjeta 
	aAdd(aRO,SubStr(cLine,084,015)) // 10 - Valor rejeitado
	aAdd(aRO,SubStr(cLine,099,015)) // 11 - Valor desconto
	aAdd(aRO,SubStr(cLine,114,015)) // 12 - Valor liquido
	aAdd(aRO,SubStr(cLine,129,008)) // 13 - data de credito 1a parcela
	aAdd(aRO,SubStr(cLine,137,001)) // 14 - Bandeira

return

Static function GeraCV(cLine)

	aCV := {}
	
	aAdd(aCV,Substr(cLine,004,009)) //01 - Numero do PV
	aAdd(aCV,Substr(cLine,013,009)) //02 - Numero do RV
	aAdd(aCV,Substr(cLine,022,008)) //03 - data CV
	aAdd(aCV,Substr(cLine,030,008)) //04 - zeros
	aAdd(aCV,Substr(cLine,038,015)) //05 - Valor CV
	aAdd(aCV,Substr(cLine,053,015)) //06 - Valor Gorjeta 
	aAdd(aCV,Substr(cLine,068,016)) //07 - Numero Cartao
	aAdd(aCV,Substr(cLine,084,003)) //08 - Status CV
	aAdd(aCV,Substr(cLine,087,002)) //09 - Numero Parcelas
	aAdd(aCV,Substr(cLine,089,012)) //10 - Numero CV
	aAdd(aCV,Substr(cLine,101,013)) //11 - numero referencia 
	aAdd(aCV,Substr(cLine,114,015)) //12 - Valor desconto 
	aAdd(aCV,Substr(cLine,129,006)) //13 - Nro autorizacao  
	aAdd(aCV,Substr(cLine,135,006)) //14 - hora autorizacao 
	aAdd(aCV,Substr(cLine,141,016)) //15 - Numero bilhete 
	aAdd(aCV,Substr(cLine,157,016)) //16 - Numero bilhete  
	aAdd(aCV,Substr(cLine,173,016)) //17 - Numero bilhete 
	aAdd(aCV,Substr(cLine,189,016)) //18 - Numero Bilhete 
	aAdd(aCV,Substr(cLine,205,001)) //19 - tipo captura
	aAdd(aCV,Substr(cLine,206,015)) //20 - Valor liquido 
	aAdd(aCV,Substr(cLine,221,015)) //21 - Valor liquido 1a parcela
	aAdd(aCV,Substr(cLine,236,015)) //22 - valor liquido demais parcelas
	aAdd(aCV,Substr(cLine,251,008)) //23 - Numero Terminal 
	aAdd(aCV,Substr(cLine,259,003)) //24 - Sigla Pais 
	aAdd(aCV,Substr(cLine,262,001)) //25 - bandeira 
	
	// rotativos...
	
	aAdd(aCV,Substr(cLine,139,016)) //26 - Numero Autorização rotativo
	aAdd(aCV,Substr(cLine,204,015)) //27 - Valor Liquido Rotativo
	aAdd(aCV,Substr(cLine,219,008)) //28 - Numero Terminal Rotativo   
	aAdd(aCV,Substr(cLine,230,001)) //29 - bandeira rotativo 
	
	GeraTIT() 	
	
return


Static function GeraNCC()

	Local aFIN040  := {}
	Local cE1Num   := ""
	Local aArea	 := GetArea()	
	Local _Existe := .t.
	Local cLoja := ""
	Local cQuery := ""
	Local _ArqErro := ""	
	Local _Chproc := ""
	Local _VlrCv := val(aCV[05]) / 100
	Private lMsErroAuto := .F.	
	
	if Select('TMPSE1') > 0 
		TMPSE1->(dBCloseArea())
	EndIf
	
	_Dtemis := substr(aCV[3],5,4) + substr(aCV[3],3,2) + substr(aCV[3],1,2)	
		
	cQuery := "SELECT COUNT(E1_NUM) AS QUANT "
	cQuery += " FROM  SE1010 " 
	cQuery += " WHERE "
	//cQuery += " E1_ORIGEM = 'PEFI002R' " 
	cQuery += " E1_TIPO = 'NCC' "
	cQuery += " AND E1_NRDOC = '" + cValToChar(_NrDoc) + "' " 
	cQuerY += " AND E1_NSUTEF = '" + aCV[02] + "' "	
	cQuerY += " AND E1_EMISSAO = '" + _Dtemis + "' "
	cQuery += " AND D_E_L_E_T_ = '' "
	
	cQuery := ChangeQuery( cQuery )  
				
	TcQuery cQuery New Alias "TMPSE1" 
		  		
	dbSelectArea("TMPSE1") 
			
	If TMPSE1->QUANT = 0 // Gerar se nao existir
		
		cLoja := Posicione("SA1",3,xFilial("SA1")+cCliente,"A1_LOJA")	
							
		cE1Num   := GetSxeNum("SE1","E1_NUM")
		
		While _Existe 
				
			DbSelectArea("SE1")
			DbSetOrder(1) 
			_Chproc := xfilial('SE1')+"RED"+cE1Num+Padr(cValToChar(_Cont),3," ")+"NCC"
			if DbSeek(_ChProc) // pesquisa pelo nro do documento
				cE1Num   := GetSxeNum("SE1","E1_NUM")
			else
				_Existe := .F.
				ConfirmSX8()
			EndIf					
		EndDo		
		
		aADD(aFIN040,{"E1_FILIAL" ,xFilial("SE1"),Nil})	
		aADD(aFIN040,{"E1_PREFIXO","RED",nil})
		aADD(aFIN040,{"E1_TIPO"   ,"NCC",	nil})
		aADD(aFIN040,{"E1_LA"     ,"N",		nil})
		aADD(aFIN040,{"E1_OCORREN","01",		nil})
		aADD(aFIN040,{"E1_STATUS" ,"A",		nil})
		aADD(aFIN040,{"E1_ORIGEM" ,"FINA040",nil})
		aADD(aFIN040,{"E1_FLUXO"  ,"S",		nil})
		aADD(aFIN040,{"E1_MULTNAT","2",		nil})
		aADD(aFIN040,{"E1_DESDOBR","2",		nil})
		aADD(aFIN040,{"E1_FLUXO"  ,"S",		nil})
		aADD(aFIN040,{"E1_HIST"   ,aCV[01] + '-' + cMaquin,nil})
		aAdd(aFIN040,{"E1_XMAQUIN",cMaquin,nil})
		aADD(aFIN040,{"E1_SITUACA","0",		nil})
		aADD(aFIN040,{"E1_NUM"    ,cE1Num,	nil})						
		aADD(aFIN040,{"E1_FILORIG",xFilial('SE1'),nil})
		aADD(aFIN040,{"E1_PARCELA",cValToChar(_Cont),nil})
		aADD(aFIN040,{"E1_MOEDA"  ,1,		nil})
		aADD(aFIN040,{"E1_CONTRAT",aRO[01],nil})
		aADD(aFIN040,{"E1_DOCTEF" ,aRO[01],nil})	
		aADD(aFIN040,{"E1_NRDOC"  ,cValToChar(_NrDoc),nil})	
		aADD(aFIN040,{"E1_NSUTEF"  ,aCV[02],nil})			
		aADD(aFIN040,{"E1_NATUREZ","12011",nil})
		aADD(aFIN040,{"E1_CLIENTE",cCliente,	nil})
		aADD(aFIN040,{"E1_NOMCLI" ,cNome,	nil})
		aADD(aFIN040,{"E1_LOJA"   ,cLoja,	nil})				
		aADD(aFIN040,{"E1_XPAGTO" ,"NCC",	nil})		
		aAdd(aFIN040,{"E1_XBAND",_Band,nil})					
		aADD(aFIN040,{"E1_EMISSAO",StoD(_Dtemis),nil})
		aADD(aFIN040,{"E1_VENCTO" ,StoD(_Dtemis),nil})
		aADD(aFIN040,{"E1_VENCREA",StoD(_Dtemis),nil})
		aADD(aFIN040,{"E1_EMIS1"  ,dDatabase,nil})
		aADD(aFIN040,{"E1_VENCORI",StoD(_Dtemis),nil})					
		aADD(aFIN040,{"E1_VALOR"  ,_VlrCv,nil})
		aADD(aFIN040,{"E1_SALDO"  ,_VlrCv,nil})
		aADD(aFIN040,{"E1_VLRREAL" ,_VlrCv,nil})
	
		MsExecAuto({|x, y| Fina040(x, y)}, aFIN040, 3)
		
		If lMsErroAuto
			MostraErro("c:\temp\", "ERRO_REDENCC_" + aCV[10] + ".LOG")
		Else
			ConfirmSX8()
		EndIf
			 			
		TMPSE1->(dbSkip())
		TMPSE1->(dBCloseArea())					
		RestArea(aArea)
			
	EndIf
return

Static function GeraTIT()

	Local aFIN040  := {}
	Local aArea	   := GetArea()
	Local cE1Num   := ""
	Local cQuer := ""	
	Local cQuer1 := ""
	Local _Existe := .t.
	Local _Valor := 0
	Local _VlrBruto := 0
	Local cFilMaq := ""
	Local _Chproc := ""
	Private xBand := aCV[25] 
	Private cMaquin := ""
	Private cCliente := ""			
	Private cNome	 := "" 
	Private _Cont := ""
	Private _Nrdoc := val(aCV[10]) * 1
	
	Private lMsErroAuto := .F.
	
	If Substr(cLine,1,3) == "012"	
		_Valor := val(aCV[21]) / 100
		cMaquin := aCV[23]		
		_Cont := val(aCV[09])
	Else
		_Valor := val(aCV[27]) / 100	
		cMaquin := aCV[28]
		_Cont := 1
	
	EndIf
	
	cFilMaq := Posicione("ZAE",3,cMaquin,"ZAE_FILIAL")
	cCliente := Posicione("ZAE",3,cMaquin,"ZAE_CLIENT")			
	cNome	 := Posicione("SA1",3,xFilial("SA1")+cCliente,"A1_NOME") 
	
	_Dtemis := substr(aCV[3],5,4) + substr(aCV[3],3,2) + substr(aCV[3],1,2)		
		
	If _Dtemis < "20160101" //.or. cFilMaq <> cFilAnt // rodar apartir de 01/2016 ou da mesma filial 
	
		Return
	
	End	
	
	//**************************************************************
		
	If !Empty(alltrim(cFilMaq))
		If cFilMaq <> cFilAnt
			Return
		EndIf
	EndIf	
				
	If Empty(cCliente)
		aADD(aErros,{"Maquineta  " + cMaquin + " do PV " + aCV[01] +", nao cadastrada. (ZAE010)"})
		nContErr += 1
		Return
	EndIf	
	
	If Empty(cNome)	
		aADD(aErros,{"Cliente " + cCliente + " da maquineta " + cMaquin + ",  nao cadastrado. (SA1) "})				
		nContErr += 1
		Return
	EndIf	
	
	//*************************************************************	
				
	Do Case
		Case aCV[25] == "1"
		  	_Band := "MASTERCARD"
		Case aCV[25] == "2"
		 	_Band := "DINERS" 
		Case aCV[25] == "3" 
			_Band := "VISA" 
		Case aCV[25] == "4"
		 	_Band := "CABAL" 
		Case aCV[25] == "5"
		 	_Band := "HIPERCARD" 
		Case aCV[25] == "6"
		 	_Band := "SOROCRED" 
		Case aCV[25] == "7"
		 	_Band := "CUP"
		Case aCV[25] == "8"
		 	_Band := "CREDSYSTEM"
		Case aCV[25] == "9"
			_Band := "SICREDI"
		otherwise	
			_Band := aCV[25]
	End Case
		

	_VlrBruto := (val(aCV[05]) / _Cont) / 100
		
	for _Parc := 1 to _Cont
		
		cQuer := "SELECT COUNT(E1_NUM) AS QUANT "
		cQuer += " FROM  SE1010 " 
		cQuer += " WHERE "
		//cQuer += " E1_ORIGEM = 'PEFI002R' "
		cQuer += " E1_TIPO = 'CC' " 
		//cQuer += " AND E1_NRDOC = '" + cValToChar(_Nrdoc) + "' " 
		cQuer += " AND E1_PARCELA = '" + cValToChar(_Parc) + "' " 
		cQuer += " AND E1_CLIENTE = '" + cClioper + "' "
		cQuer += " AND E1_NSUTEF = '" + aCV[02] + "' "
		//cQuer += " AND E1_EMISSAO = '" + _Dtemis + "' "
		cQuer += " AND D_E_L_E_T_ = '' "
			
	 	cQuer := ChangeQuery( cQuer )  
		 		
	   	TcQuery cQuer New Alias "TMPSE" 
		   		
	 	dbSelectArea("TMPSE") 
		 		
	 	if TMPSE->QUANT = 0	
	
			cE1Num   := GetSxeNum("SE1","E1_NUM")	
				
			While _Existe

				DbSelectArea("SE1")
				DbSetOrder(1) 
				_Chproc := xfilial('SE1')+"RED"+cE1Num+Padr(cValToChar(_Parc),3," ")+"CC "
				if DbSeek(_ChProc) // pesquisa pelo nro do documento
					cE1Num   := GetSxeNum("SE1","E1_NUM")
				else
					_Existe := .F.
					ConfirmSX8()
				EndIf					
			EndDo
			
			_Existe := .t.

			cNumDias := _Parc * 30  			
			cVencto := StoD(_Dtemis) + cNumDias	
				
			aAdd(aFIN040, {"E1_NUM"    ,cE1Num,	nil})
			aADD(aFIN040, {"E1_FILIAL" ,xFilial("SE1")	,Nil})
			aAdd(aFIN040, {"E1_FILORIG",xFilial('SE1'),nil})
			aAdd(aFIN040, {"E1_PARCELA",cValToChar(_Parc),nil})
			aAdd(aFIN040, {"E1_NATUREZ","10701",nil})
			aAdd(aFIN040, {"E1_CLIENTE",cClioper,	nil})
			aAdd(aFIN040, {"E1_NOMCLI" ,cNomeoper,	nil})
			aAdd(aFIN040, {"E1_LOJA" ,cLojaoper,	nil})
			aAdd(aFIN040, {"E1_EMISSAO",StoD(_Dtemis),nil})
			aAdd(aFIN040, {"E1_EMIS1"  ,dDatabase,nil})
			aAdd(aFIN040, {"E1_VENCTO" ,cVencto,nil})
			aAdd(aFIN040, {"E1_VENCREA",cVencto,nil})
			aAdd(aFIN040, {"E1_VENCORI",cVencto,nil})
			aAdd(aFIN040, {"E1_VALOR"  ,_Valor,nil})
			aAdd(aFIN040, {"E1_SALDO"  ,_Valor,nil})
			aAdd(aFIN040, {"E1_VLRREAL" ,_VlrBruto,nil})			
			aAdd(aFIN040, {"E1_NRDOC" ,cValToChar(_NrDoc),nil})
			aADD(aFIN040, {"E1_NSUTEF"  ,aCV[02],nil})
			aAdd(aFIN040, {"E1_XMAQUIN",cMaquin,nil})
			aAdd(aFIN040, {"E1_DOCTEF" ,"001",nil})
			aAdd(aFIN040, {"E1_CONTRAT","001",nil})
			aAdd(aFIN040, {"E1_MOEDA"  ,1,		nil})
			aAdd(aFIN040, {"E1_HIST"   ,aCV[01] + '-' + cMaquin,nil})
			aAdd(aFIN040, {"E1_SITUACA","0",	nil})
			aAdd(aFIN040, {"E1_TIPO"   ,"CC",	nil})
			aAdd(aFIN040, {"E1_XPAGTO" ,"CC",	nil})
			aAdd(aFIN040, {"E1_XBAND",_Band,nil})
			aAdd(aFIN040, {"E1_PREFIXO","RED",	nil})
			aAdd(aFIN040, {"E1_OCORREN","01",	nil})
			aAdd(aFIN040, {"E1_STATUS" ,"A",	nil})
			aAdd(aFIN040, {"E1_ORIGEM" ,"FINA040",nil})
			aAdd(aFIN040, {"E1_FLUXO"  ,"S",	nil})
			aAdd(aFIN040, {"E1_MULTNAT","2",	nil})
			aAdd(aFIN040, {"E1_DESDOBR","2",	nil})
			aAdd(aFIN040, {"E1_FLUXO"  ,"S",	nil})
			aAdd(aFIN040, {"E1_LA"     ,"N",	nil})
						
			MsExecAuto({|x, y| Fina040(x, y)}, aFIN040, 3)
		
			If lMsErroAuto
				MostraErro("c:\temp\", "ERRO_REDETIT_" + aCV[10] + ".LOG")
			Else
				ConfirmSX8()
			EndIf
		EndIf	
				 			
		TMPSE->(dbSkip())
		TMPSE->(dBCloseArea())
		
		_Valor := val(aCV[22]) / 100				
							
	Next _Parc
		
	RestArea(aArea)
		
	If !Empty(aRO)		
		GERANCC()			
	End	
	
return


Static Function GeraLog()
	
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

			