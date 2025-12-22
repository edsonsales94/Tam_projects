#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "fileio.ch"
#include "shell.ch"

/*
-----------------------------------------------------------------------------
| FONTE: HLFATA02       | Autor: Mauro Yokota - Kiboo     | Data 19/01/2018 |
|---------------------------------------------------------------------------|
| Descrição | Importação de Previsão de Venda Mensal da Toyota	            |
|           | Este programa tem como objetivo importar os pedidos de compra |
|           | da Toyota a partir de um arquivo padrão TEXTO, efetuando a    |
|           | Inclusão automatica dos Previsão de Venda situação (Bloqueada)|
|---------------------------------------------------------------------------|
| Sintaxe   | HLFATA02()	 	                                            |
|---------------------------------------------------------------------------|
| Uso       | Módulo Faturamento.                                           |
|===========================================================================|
|           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.               |
|---------------------------------------------------------------------------|
| Programador | Data   | Motivo da Alteração                                |
|---------------------------------------------------------------------------|
|             |        |                                                    |
----------------------------------------------------------------------------|
*/

User Function HLFATA02()

	Private cArqLOG    	:= "C:\TOYOTADIA.LOG"
	Private cArqTrab   	:= ""
	Private aCamposBrw 	:= {}
	Private cFileName  	:= ""
	Private cCodCli	   	:= "      "
	Private cLojCli	   	:= "  "
	Private cLocDes		:= "     "
	Private dDatPrg		:= CTOD(space(08))
	Private dDataAtu	:= CTOD(space(08))

	//** Cria arquivo de trabalho
	CriaArqTrab()

	//** Pega o arquivo de entrada
	ProcArq()

	//** Mostra tela de dialogo
	@ 50,001 To 600,1330 Dialog oDlg1 Title "Importação de Previsão de Venda Mensal da TOYOTA"
	@ 265,055 Say "Honda Lock SP - Indústria e Comércio de Peças Ltda."
	@ 005,005 To 250,660 Browse "PE3V0" Fields aCamposBrw Enable "OK<>'S'"
	//@ 135,155 BmpButton Type 5 Action ProcArq()
	@ 260,005 Button "Arquivo..." Size 40,14 Action ProcArq()
	@ 260,595 BmpButton Type 1 Action ProcImp()
	@ 260,625 BmpButton Type 2 Action Close(oDlg1)
	Activate Dialog oDlg1 Centered


	//** Fecha arquivos temporarios
	dbSelectArea("ITPV0")
	dbCloseArea("ITPV0")

	dbSelectArea("PE3V0")
	dbCloseArea("PE3V0")

	dbSelectArea("TE1V0")
	dbCloseArea("TE1V0")

	dbSelectArea("FTPV0")
	dbCloseArea("FTPV0")
	FErase(cArqTrab+".*")

	dbSelectArea("SA1")

Return


//******************************************************************************
Static Function SelArquivo()

	Local cTipo := ""
	Local cFile := ""

	cTipo := "Previsão de Venda da TOYOTA (*.TXT)      | *.TXT | "
	cTipo += "Todos os arquivos (*.*)    | *.*     "

	cFile := cGetFile(cTipo, "Selecione o arquivo de Previsão de Venda da TOYOTA")

Return(cFile)


//******************************************************************************
Static Function ProcArq()

	Local bAcao := {|| ImportaTmp() }
	Local cTitulo := ""
	Local cMsg := "Lendo arquivo de entrada... Aguarde!"
	Local lAborta := .F.

	cFileName := SelArquivo()
	If cFileName <> ""
		Processa( bAcao, cTitulo, cMsg, lAborta )
	Endif

Return


//******************************************************************************
Static Function ProcImp()

	Local bAcao := {|lFim| ImportaPed(@lFim) }
	Local cTitulo := ""
	Local cMsg := "Gerando Previsão de Venda... Aguarde!"
	Local lAborta := .T.

	If MsgBox("Confirma a importação da Previsão de Venda da TOYOTA ?","Escolha","YESNO")
		Processa( bAcao, cTitulo, cMsg, lAborta )
		Close(oDlg1)
	Endif

Return


//******************************************************************************
// Importa o arquivo de Previsão de Venda da TOYOTA para o arquivo de trabalho
Static Function ImportaTmp()

	Private nTamArq  := 0
	Private nHndEnt  := 0
	Private nNumErros:= 0

	//** Abre o arquivo
	If File(cFileName)
		IF (nHndEnt := FT_FUse(cFileName)) < 0
			MsgBox("Erro ao abrir arquivo " + cFileName)
			Return
		Endif
	Else
		MsgBox("Arquivo não encontrado! - "+ cFileName)
		Return
	End

	//** Pega a quantidade de linhas do arquivo
	nTamArq := FT_FLastRec()

	//** Importa o arquivo da TOYOTA para o arquivo de trabalho
	dbSelectArea("ITPV0")
	Zap

	dbSelectArea("PE3V0")
	Zap

	dbSelectArea("TE1V0")
	Zap

	dbSelectArea("FTPV0")
	Zap

	LeArquivo()
	FT_FUse()
	dbGoTop()

Return


//******************************************************************************
// Le o arquivo sequencialmente do inicio ao fim para incluir os
// Previsão de Venda da Toyota no arquivo de trabalho
Static Function LeArquivo()

	Local nTamLin := 128
	Local nLidos  := 0
	Local xBuffer := ""
	Local NrPed   := 0


	ProcRegua(nTamArq)

	FT_FGoTop()

	While !FT_FEOF()
		//** Le a proxima linha do arquivo
		xBuffer := FT_FReadLn()
		IncProc()
		//** Carrega o arquivo temporario para o segmento ITPV0
		IF Substr(xBuffer,1,3) $ "ITP" .and. AllTrim(xBuffer) <> ""
			cCodCli := "      "
			cLojCli	:= "  "
			cDatPrg := Substr(xBuffer, 14, 06)
			dDatPrg := ctod(substr(cDatPrg,5,2)+"/"+substr(cDatPrg,3,2)+"/"+substr(cDatPrg,1,2))
			lRet := PegaCli(SubStr(xBuffer, 26, 14))
			IF lRet
				dbSelectArea("ITPV0")
				RecLock("ITPV0",.T.)
				//ITP0010800007180220162159591047600012440873500700024434876   120717  TOYOTA SOROCABA          HONDA LOCK HONDA LOCK

				IDSEG   := Substr(xBuffer, 01, 03)
				NUMMSG  := substr(xBuffer, 04, 03)
				NUMVER  := Val(substr(xBuffer, 07, 02))
				CONMOV  := Val(substr(xBuffer, 09, 05))
				GERMOV  := Val(substr(xBuffer, 14, 12))
				IDTRAN  := Val(substr(xBuffer, 26, 14))		//CNPJ - TOYOTA
				IDRECE  := Val(substr(xBuffer, 40, 14))
				CODITR  := substr(xBuffer, 54, 08)
				CODIRE  := substr(xBuffer, 62, 08)
				NOMTRA  := substr(xBuffer, 70, 25)
				NOMREC	:= substr(xBuffer, 95, 25)
				ESPACO  := substr(xBuffer,120, 09)
				MsUnlock()
			Else
				Return
			Endif
		ENDIF

		//** Carrega o arquivo temporario para o segmento PE1V0
		//11122233333333344444455555555566666677888888888888888888888888888899999999999999999999999999999900000000000011111222222222223345
		//PE1S  000000007180301         0000007 69205-0D560-C0                                            000000380428G1              PC0P
		IF Substr(xBuffer,1,3) $ "PE1" .and. AllTrim(xBuffer) <> ""
			cIteCli		:= Substr(xBuffer, 039, 28)
			cTpVen		:= Substr(xBuffer, 128, 01)
			cLocDes 	:= Substr(xBuffer, 109, 05)
			cIdentAtu	:= Substr(xBuffer, 07, 09) 	//Ident. Programa Atual
			cDataAtu 	:= Substr(xBuffer, 16, 06)
			dDataAtu 	:= ctod(substr(cDataAtu,5,2)+"/"+substr(cDataAtu,3,2)+"/"+substr(cDataAtu,1,2))
			cIdentAnt	:= Substr(xBuffer, 22, 09) 	//Ident. Programa Anterio
			cDataAnt 	:= Substr(xBuffer, 31, 06)
			dDataAnt 	:= ctod(substr(cDataAnt,5,2)+"/"+substr(cDataAnt,3,2)+"/"+substr(cDataAnt,1,2))
		ENDIF

		//** Carrega o arquivo temporario para o segmento PE2V1
		IF Substr(xBuffer,1,3) $ "PE2" .and. AllTrim(xBuffer) <> ""
			cLocEnt 	:= Substr(xBuffer, 04, 03)	//"S  "-São Bernardo do Campo / "I  "-Indaiatuba / "S  "-Sorocaba
			nQtdade 	:= Val(Substr(xBuffer, 52, 14))/1000
			cIteHon 	:= ""
			cDesPro   	:= ""
			nPreUni		:= 0
			lRet		:= .T.
			PegaProd(cIteCli)
			IF lRet
				dbSelectArea("PE3V0")
				RecLock("PE3V0",.T.)
				IDSEGPE1 	:= Substr(xBuffer,1,3)
				CODFAB   	:= ""
				IDPROG   	:= cIdentAtu
				DATPRO   	:= dDataAtu
				PROGAN   	:= cIdentAnt
				DATANT   	:= dDataAnt
				ITECLI		:= cIteCli
				ITEHON   	:= cIteHon
				DESITE      := cDesPro
				TPVEN		:= cTpVen
				QTDNEC		:= nQtdade
				PREUNI		:= nPreUni
				VALTOT		:= nQtdade * nPreUni
				XTPFORN     := cTpVen
				MsUnlock()
			Endif
		ENDIF


		//** Carrega o arquivo temporario para o segmento TE1V0
		IF Substr(xBuffer,1,3) $ "TE1" .and. AllTrim(xBuffer) <> ""
			dbSelectArea("TE1V0")
			RecLock("TE1V0",.T.)
			IDSEG	:= Substr(xBuffer, 01, 03)
			TXTLIV1	:= Substr(xBuffer, 04, 40)
			TXTLIV2	:= Substr(xBuffer, 44, 40)
			TXTLIV3	:= Substr(xBuffer, 84, 40)
			ESPACO	:= Substr(xBuffer,124, 05)
			MsUnlock()
		ENDIF


		//** Carrega o arquivo temporario para o segmento FTPV0
		IF Substr(xBuffer,1,3) $ "FTP" .and. AllTrim(xBuffer) <> ""
			dbSelectArea("FTPV0")

			RecLock("FTPV0",.T.)
			IDSEG	:= Substr(xBuffer, 01, 03)
			NUMCON	:= val(Substr(xBuffer, 04, 05))
			QTDSEG	:= val(Substr(xBuffer, 09, 09))
			TOTVAL	:= val(Substr(xBuffer, 18, 17))
			CATOPE	:= Substr(xBuffer, 35, 01)
			ESPACO	:= Substr(xBuffer, 36, 93)
			MsUnlock()
		ENDIF

		FT_FSkip()
	EndDo

	dbSelectArea("PE3V0")
	dbGoTop()

Return


//******************************************************************************
// Gera a Previsão de Venda de Venda no SIGA a partir do arquivo de trabalho
Static Function ImportaPed()

	Local cQuebra := ""
	Local cMsgPed := ""
	Local _i := 0
	Local lOK := .F.
	Local cCodProCli 	:= Replicate("@", 30)
	Local cDtaIniCli 	:= dDataBase
	Local cMarkIteProc 	:= ""

	Private nSeqItem := 0
	Private aPed     := {}  //** Nr Pedidos importados
	Private aLog     := {}  //** LOG da importacao

	dbSelectArea("PE3V0")
	dbGoTop()
	If EOF()
		MsgBox('Não há dados para importar!')
		Return
	Endif

	ProcRegua(RecCount())
	Begin Transaction

		LimpaSC4(dDataAtu)

		dbSelectArea("SA1")
		dbSetOrder(1)
		MSSeek(xFilial("SA1")+cCodCli+cLojCli)

		dbSelectArea("PE3V0")
		While !EOF()

			cCodProCli 	 := PE3V0->ITECLI
			cDtaIniCli 	 := PE3V0->DATPRO
			cMarkIteProc := GetMark()

			While !Eof() .And. cCodProCli == PE3V0->ITECLI

				ImportaItem(cCodCli, cLojCli, cMarkIteProc)

				dbSelectArea("PE3V0")
				dbSkip()
				IncProc()

			Enddo

			//    ExcluiPrg(cCodCli, cLojCli, cCodProCli, cDtaIniCli, cMarkIteProc)

		Enddo
	End Transaction


	//GravaLOG()
	//ShellExecute('open',cArqLOG,'','',SW_SHOWNORMAL)  //** Abre o arquivo

Return




//******************************************************************************
// - Inclui uma nova Previsão de Venda - ITEM
Static Function ImportaItem(cCodCli, cLojaCli, cMarkIteProc)


	Default cCodCli 	:= "000077"
	Default cLojaCli 	:= "01"

	Private cSeqItem  	:= "00"
	Private nCodIteCli 	:= ""
	Private cFiltro	  	:= "SD2->D2_COD == '"+nCodIteCli+"'"

	//** Posiciona no produto
	If AllTrim(PE3V0->ITECLI) == ""
		aAdd(aLog, "Produto TOYOTA não encontrado: "+ PE3V0->ITECLI )
		nNumErros++
		Return
	Else
		RecLock("PE3V0",.F.)
		PE3V0->OK  := "S"
		MsUnlock()
	Endif

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+PE3V0->ITEHON)

	dbSelectArea("SC4")
	dbSetOrder(1)
	RecLock("SC4",.T.)
	C4_FILIAL  	:= xFilial()
	C4_PRODUTO 	:= SB1->B1_COD
	C4_LOCAL   	:= SB1->B1_LOCPAD
	C4_DOC		:= "TOYOTA"
	C4_QUANT  	:= PE3V0->QTDNEC
	C4_VALOR   	:= PE3V0->QTDNEC * PE3V0->PREUNI  	//C6_PRCVEN
	C4_DATA		:= dDataAtu
	C4_OBS		:= "TOYOTA"
	MsUnlock()

Return


//******************************************************************************
// Cria arquivo de trabalho (temporário)
Static Function CriaArqTrab()

	Local _aStru := {}

	//** DEFINIÇÃO DA ESTRUTURA ITPV0 (Campo, Tipo, Tam, Dec)
	aAdd(_aStru,{"IDSEG"     ,"C",03,0})  //Identificação do Tipo de Seguimento
	aAdd(_aStru,{"NUMMSG"    ,"C",03,0})  //Numero de Mensagem Comunicação
	aAdd(_aStru,{"NUMVER"    ,"N",02,0})  //Numero da Versão da Mensagem
	aAdd(_aStru,{"CONMOV"    ,"N",05,0})  //Numero do Controle Movimento
	aAdd(_aStru,{"GERMOV"    ,"N",12,0})  //Identificação Geração Movimento
	aAdd(_aStru,{"IDTRAN"    ,"N",14,0})  //Identificação do Transmissor
	aAdd(_aStru,{"IDRECE"    ,"N",14,0})  //Identificação do Receptor
	aAdd(_aStru,{"CODITR"    ,"C",08,0})  //Código Interno Transmissor
	aAdd(_aStru,{"CODIRE"    ,"C",08,0})  //Código Interno Receptor
	aAdd(_aStru,{"NOMTRA"    ,"C",25,0})  //Nome Transmissor
	aAdd(_aStru,{"NOMREC"    ,"C",25,0})  //Nome Receptor
	aAdd(_aStru,{"ESPACO"    ,"C",09,0})  //Espaços

	// cArqTrab := CriaTrab(_aStru, .T.)
	// dbUseArea(.T.,,cArqTrab,"ITPV0",.F.)

	// Instancio o objeto
	oTable  := FwTemporaryTable():New( "ITPV0" )
	// Adiciono os campos na tabela
	oTable:SetFields( _aStru )
	// Crio a tabela no banco de dados
	oTable:Create()

	_aStru := {}
	//** Definicao da estrutura (Campo, Tipo, Tam, Dec)
	aAdd(_aStru,{"IDSEGPE1"  ,"C",03,0})  //Identificação Tipo Segmento
	aAdd(_aStru,{"CODFAB"    ,"C",03,0})  //Codigo da Fabrica de Entrega
	aAdd(_aStru,{"IDPROG"    ,"C",09,0})  //Identificação do Programa Atual
	aAdd(_aStru,{"DATPRO"    ,"D",08,0})  //Data da Programação Atual
	aAdd(_aStru,{"PROGAN"    ,"C",09,0})  //Identificação do Programa Anterior
	aAdd(_aStru,{"DATANT"    ,"D",06,0})  //Data do Programa Anterior

	aAdd(_aStru,{"ITEHON"    ,"C",30,0})  //*Código do Item da Honda Lock
	aAdd(_aStru,{"ITECLI"  	 ,"C",30,0})  //*Código do Item do Cliente
	aAdd(_aStru,{"DESITE"    ,"C",50,0})  //Descrição do Item do Cliente
	aAdd(_aStru,{"TPVEN"     ,"C",01,0})  //Código Tipo de Fornecimento

	aAdd(_aStru,{"QTDNEC"    ,"N",14,3})  //Quantidade Necessaria
	aAdd(_aStru,{"PREUNI"	 ,"N",14,4})  //*Preço Unitário
	aAdd(_aStru,{"VALTOT"	 ,"N",14,2})  //*Valor Total
	aAdd(_aStru,{"OK"        ,"C",01,0})

	aAdd(_aStru,{"XTPFORN"   ,"C",01,0})
	aAdd(_aStru,{"XKAMBAN"   ,"C",12,0})
	aAdd(_aStru,{"XDATKAM"   ,"D",08,0})
	aAdd(_aStru,{"XQTDKAM"   ,"C",09,0})
	aAdd(_aStru,{"XITENS"    ,"C",09,0})

	// cArqTrab := CriaTrab(_aStru, .T.)
	// dbUseArea(.T.,,cArqTrab,"PE3V0",.F.)

	// Instancio o objeto
	oTable  := FwTemporaryTable():New( "PE3V0" )
	// Adiciono os campos na tabela
	oTable:SetFields( _aStru )
	// Crio a tabela no banco de dados
	oTable:Create()

	Index on itecli + dtos(DATPRO) to &cArqTrab
	//** Definicao dos campos do BROWSE
	aCamposBrw := {}

	aAdd(aCamposBrw,{"ITEHON"   , "Peça Honda Lock" })
	aAdd(aCamposBrw,{"ITECLI"  	, "Peça Cliente" })
	aAdd(aCamposBrw,{"DESITE"   , "Descrição do Produto" })
	aAdd(aCamposBrw,{"DATPRO"   , "Data Programada" })
	aAdd(aCamposBrw,{"QTDNEC"   , "Qtd. Programada" })
	aAdd(aCamposBrw,{"PREUNI"   , "Prç. Unit." })
	aAdd(aCamposBrw,{"VALTOT"   , "Vlr. Total" })



	_aStru := {}
	//** Definicao da estrutura (Campo, Tipo, Tam, Dec)
	aAdd(_aStru,{"IDSEG"     ,"C",03,0})  //Identificação Tipo Segmento
	aAdd(_aStru,{"TXTLIV1"   ,"C",40,0})  //Linha 01 Texto Livre
	aAdd(_aStru,{"TXTLIV2"   ,"C",40,0})  //Linha 01 Texto Livre
	aAdd(_aStru,{"TXTLIV3"   ,"C",40,0})  //Linha 01 Texto Livre
	aAdd(_aStru,{"ESPACO"    ,"C",05,0})  //Espaços

	// cArqTrab := CriaTrab(_aStru, .T.)
	// dbUseArea(.T.,,cArqTrab,"TE1V0",.F.)

	// Instancio o objeto
	oTable  := FwTemporaryTable():New( "TE1V0" )
	// Adiciono os campos na tabela
	oTable:SetFields( _aStru )
	// Crio a tabela no banco de dados
	oTable:Create()

	_aStru := {}
	//** Definicao da estrutura (Campo, Tipo, Tam, Dec)
	aAdd(_aStru,{"IDSEG"     ,"C",03,0})  //Identificação Tipo Segmento
	aAdd(_aStru,{"NUMCON"    ,"N",05,0})  //Linha 01 Texto Livre
	aAdd(_aStru,{"QTDSEG"    ,"N",09,0})  //Linha 01 Texto Livre
	aAdd(_aStru,{"TOTVAL"    ,"N",17,2})  //Linha 01 Texto Livre
	aAdd(_aStru,{"CATOPE"    ,"C",01,0})  //Linha 01 Texto Livre
	aAdd(_aStru,{"ESPACO"    ,"C",93,0})  //Espaços

	// cArqTrab := CriaTrab(_aStru, .T.)
	// dbUseArea(.T.,,cArqTrab,"FTPV0",.F.)

	// Instancio o objeto
	oTable  := FwTemporaryTable():New( "FTPV0" )
	// Adiciono os campos na tabela
	oTable:SetFields( _aStru )
	// Crio a tabela no banco de dados
	oTable:Create()

Return





//******************************************************************************
Static Function PegaCli(cNumCNPJ)

	cQuery 	:= "SELECT A1_COD, A1_LOJA "
	cQuery 	+= "FROM "+RetSqlName("SA1")
	cQuery	+= " WHERE D_E_L_E_T_ <> '*'"
	cQuery 	+= " AND A1_CGC = '" + cNumCNPJ + "'"
	TCQuery cQuery NEW ALIAS "SQLSA1"
	//** Retorna PRODUTO
	If AllTrim(SQLSA1->A1_COD) <> ""
		cCodCli := SQLSA1->A1_COD
		cLojCli	:= SQLSA1->A1_LOJA
		lRet 	:= .T.
	else
		MsgAlert('CNPJ não encontrada no Cadastro de Clientes !!' )
		lRet	:= .F.
	Endif
	SQLSA1->(dbCloseArea())
Return(lRet)




//******************************************************************************
Static Function PegaProd(cBufPro)
	cBufPro	:= Substr(cBufPro,1,15)
	cQuery 	:= "SELECT A7_PRODUTO, A7_DESCCLI, A7_PRECO01 "
	cQuery 	+= "FROM "+RetSqlName("SA7")
	cQuery	+= " WHERE D_E_L_E_T_ <> '*'"
	cQuery 	+= " AND A7_CLIENTE = '" + cCodCli + "'"
	cQuery 	+= " AND A7_LOJA = '" + cLojCli + "'"
	cQuery  += " AND A7_CODCLI = '" + cBufPro + "'"
	TCQuery cQuery NEW ALIAS "SQLPRO"

	//** Retorna PRODUTO
	If AllTrim(SQLPRO->A7_PRODUTO) <> ""
		cIteHon := Substr(SQLPRO->A7_PRODUTO,1,15)
		nPreUni	:= SQLPRO->A7_PRECO01
		cDesPro := SQLPRO->A7_DESCCLI
		lRet 	:= .T.
	else
		MsgAlert('Amarração Produto x Cliente não encontrada')
		lRet	:= .F.
	Endif
	SQLPRO->(dbCloseArea())
Return()


//******************************************************************************
Static Function GravaLOG()

	Local nHndLOG := 0
	Local cEOL    := Chr(13)+Chr(10)
	Local i

	nHndLOG := FCreate(cArqLOG, FC_NORMAL)
	If nHndLOG == -1
		MsgBox("Erro ao criar arquivo: "+ AllTrim(Str(FError())))
		Return
	EndIf

	FWrite(nHndLOG, "SIGA ("+ FunName() +") Importação da Previsão de Venda da TOYOTA" +cEOL)
	FWrite(nHndLOG, "Usuario: "+ Substr(cUsuario,7,15) +"  "+ DTOC(Date()) +" "+ Time() +cEOL)
	FWrite(nHndLOG, cEOL)

	For i := 1 to Len(aLog)
		FWrite(nHndLOG, aLog[i] +cEOL)
		IF FError() != 0
			MsgBox("Erro ao gravar arquivo: "+ AllTrim(Str(FError())) +", "+ cArqLOG)
			Break
		Endif
	Next

	FClose(nHndLOG)

Return
// Busca pedido de venda
Static Function LimpaSC4(dDatPrg)
	Local cAlias    := Alias()
	Local cQuery    := ""
	cQuery := "UPDATE " + RetSqlName("SC4") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = SC4.R_E_C_N_O_ "
	cQuery += "FROM " + RetSqlName("SC4") + " SC4 "
	cQuery += "WHERE SC4.D_E_L_E_T_ = ' ' AND SC4.C4_FILIAL = '" + xFilial("SC4") + "' AND SC4.C4_DATA >= '"+DTOS(dDataAtu)+"' AND SC4.C4_DOC = 'TOYOTA   '"
	IF TCSqlExec(cQuery) < 0
		HS_MsgInf("TCSQLError() " + TCSQLError(), "Atenção", "Exclusão da Previsão de Venda")
	Endif
Return(Nil)
