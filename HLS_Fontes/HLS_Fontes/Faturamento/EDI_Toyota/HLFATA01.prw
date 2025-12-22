#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "fileio.ch"
#include "shell.ch"

/*
-----------------------------------------------------------------------------
| FONTE: HLFATA01       | Autor: Mauro Yokota - Kiboo     | Data 19/01/2018 |
|---------------------------------------------------------------------------|
| Descrição | Importação de Pedido diário da Toyota			                |
|           | Este programa tem como objetivo importar os pedidos de compra |
|           | da Toyota a partir de um arquivo padrão TEXTO, efetuando a    |
|           | Inclusão automatica dos Pedidos de Venda situação (Bloqueada) |
|---------------------------------------------------------------------------|
| Sintaxe   | HLFATA01()	 	                                            |
|---------------------------------------------------------------------------|
| Uso       | Módulo Faturamento.                                           |
|===========================================================================|
|           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.               |
|---------------------------------------------------------------------------|
| Programador | Data   | Motivo da Alteração                                |
|---------------------------------------------------------------------------|
|           |          |                                                    |
----------------------------------------------------------------------------|
*/

User Function HLFATA01()

	Private aDoca		:= {}
	Private cArqLOG    	:= "C:\TOYOTADIA.LOG"
	Private cArqTrab   	:= ""
	Private aCamposBrw 	:= {}
	Private cFileName  	:= ""
	Private cCodCli	   	:= "      "
	Private cLojCli	   	:= "  "
	Private cLocDes		:= "     "
	Private cCodItr		:= "        "
	Private dDatPrg		:= CTOD(space(08))
	Private	cDesPro   	:= ""
	Private nPreUni		:= 0
	Private cCodfab		:= "   "
	Private cCodPrd		:= "  "
	Private cTes		:= "   "
	Private	cCf			:= "     "

	//** Cria arquivo de trabalho
	CriaArqTrab()

	//** Pega o arquivo de entrada
	ProcArq()

	//** Mostra tela de dialogo
	@ 50,001 To 600,1330 Dialog oDlg1 Title "Importação de Pedidos da TOYOTA"
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

Return Nil


//******************************************************************************
Static Function SelArquivo()

	Local cTipo := ""
	Local cFile := ""

	cTipo := "Pedidos da TOYOTA (*.TXT)      | *.TXT | "
	cTipo += "Todos os arquivos (*.*)    | *.*     "

	cFile := cGetFile(cTipo, "Selecione o arquivo de pedidos da TOYOTA")

Return(cFile)


//******************************************************************************
Static Function ProcArq()

	Local bAcao 	:= {|| ImportaTmp() }
	Local cTitulo 	:= ""
	Local cMsg 		:= "Lendo arquivo de entrada... Aguarde!"
	Local lAborta 	:= .F.

	cFileName := SelArquivo()

	If cFileName <> ""
		Processa( bAcao, cTitulo, cMsg, lAborta )
	Endif

Return Nil


//******************************************************************************
Static Function ProcImp()

	Local bAcao 	:= {|lFim| ImportaPed(@lFim) }
	Local cTitulo 	:= ""
	Local cMsg 		:= "Gerando pedidos... Aguarde!"
	Local lAborta 	:= .T.

	If MsgBox("Confirma a importação dos pedidos da TOYOTA ?","Escolha","YESNO")

		Processa( bAcao, cTitulo, cMsg, lAborta )

		Close(oDlg1)

	Endif

Return Nil


//******************************************************************************
// Importa o arquivo de pedidos da TOYOTA para o arquivo de trabalho
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

Return Nil


//******************************************************************************
// Le o arquivo sequencialmente do inicio ao fim para incluir os
// pedidos da GM no arquivo de trabalho
Static Function LeArquivo()

	//Local nTamLin := 128
	//Local nLidos  := 0
	Local xBuffer := ""
	//Local NrPed   := 0

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
			cCodItr := substr(xBuffer, 54, 08)
			lRet 	:= PegaCli(SubStr(xBuffer, 26, 14))

			IF lRet

				dbSelectArea("ITPV0")

				RecLock("ITPV0",.T.)
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
		IF Substr(xBuffer,1,3) $ "PD1" .and. AllTrim(xBuffer) <> ""

			cIteCli	:= Substr(xBuffer, 006, 22)
			cTpVen	:= Substr(xBuffer, 121, 01)
			cLocDes := Substr(xBuffer, 065, 05)
			cCodPrd	:= Substr(xBuffer, 004, 02)

		ENDIF

		//** Carrega o arquivo temporario para o segmento PE2V1
		IF Substr(xBuffer,1,3) $ "EP1" .and. AllTrim(xBuffer) <> ""

			cLocEnt 	:= Substr(xBuffer, 04, 03)	//"B  "-São Bernardo do Campo / "I  "-Indaiatuba / "S  "-Sorocaba
			cIdentAtu	:= Substr(xBuffer, 07, 09) 	//Ident. Programa Atual
			//cDataAtu 	:= Substr(xBuffer, 16, 06) 										- ALTERADO POR LUCIANO LAMBERTI - 18/05/2018
			//dDataAtu 	:= ctod(substr(cDataAtu,5,2)+"/"+substr(cDataAtu,3,2)+"/"+substr(cDataAtu,1,2))
			cIdentAnt	:= Substr(xBuffer, 22, 09) 	//Ident. Programa Anterio
			cDataAnt 	:= Substr(xBuffer, 31, 06)
			dDataAnt 	:= ctod(substr(cDataAnt,5,2)+"/"+substr(cDataAnt,3,2)+"/"+substr(cDataAnt,1,2))
			cIteHon 	:= ""
			cCodFab		:= Substr(xBuffer,  4, 03)	//Codigo da Fábrica
			lRet		:= .T.

			PegaProd(cIteCli)

		ENDIF

		IF Substr(xBuffer,1,3) $ "PD5" .and. AllTrim(xBuffer) <> ""

			cDataAtu 	:= Substr(xBuffer, 30, 06) 														//ALTERADO LUCIANO LAMBERTI - 18/05/2018
			dDataAtu 	:= ctod(substr(cDataAtu,5,2)+"/"+substr(cDataAtu,3,2)+"/"+substr(cDataAtu,1,2)) //ALTERADO LUCIANO LAMBERTI - 18/05/2018
			cKamBam 	:= Substr(xBuffer, 18, 12)
			cDatkam 	:= Substr(xBuffer, 40, 06)
			dDatKam		:= ctod(substr(cDATKAM,5,2)+"/"+substr(cDATKAM,3,2)+"/"+substr(cDATKAM,1,2))
			cQtdKam 	:= Substr(xBuffer, 50, 09)
			cItens		:= Substr(xBuffer, 59, 09)
			nQtdade		:= Val(Substr(xBuffer, 59, 09))

			IF lRet

				dbSelectArea("PE3V0")

				RecLock("PE3V0",.T.)
				IDSEGPE1 	:= Substr(xBuffer,1,3)
				CODPRD   	:= cCodPrd
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
				XKAMBAN 	:= cKamBam
				XDATKAM 	:= dDatKam
				XQTDKAM 	:= cQtdKam
				XITENS 		:= cItens
				XDOCA 		:= cLocDes
				MsUnlock()

				If aScan(aDoca, {|x| x[1] == cLocDes .And. x[2] == DToS(dDataAtu)}) == 0
					aAdd(aDoca, {cLocDes, DToS(dDataAtu)})
				EndIf

			Endif

		Endif

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

	//Ordena doca por data de entrega
	aDoca := aSort(aDoca,,, {|x, y| x[1]+y[2] < x[1]+y[2]})

Return Nil


//******************************************************************************
// Gera os Pedidos de Venda no SIGA a partir do arquivo de trabalho
Static Function ImportaPed(lFim)

	//Local cQuebra := ""
	//Local cMsgPed := ""
	//Local _i := 0
	//Local lOK := .F.
	Local cCodProCli 	:= Replicate("@", 30)
	Local cDtaIniCli 	:= dDataBase
	Local cMarkIteProc 	:= ""
	Local cPedGer		:= ""
	Local nDoca 		:= 0

	Private nSeqItem 	:= 0
	Private aPed     	:= {}  //** Nr Pedidos importados
	Private aLog     	:= {}  //** LOG da importacao
	Private cSeqItem  	:= "00"

	dbSelectArea("PE3V0")
	dbGoTop()

	If EOF()

		MsgBox('Não há dados para importar!')

		Return

	Endif

	ProcRegua(RecCount())

	For nDoca := 1 To Len(aDoca)

		cSeqItem := "00" //Zera a contagem dos itens

		Begin Transaction

			//LimpaPed(dDatPrg)    comentada a função para não apagar os pedidos. Luciano Lamberti - 13/06/2018

			dbSelectArea("SA1")
			dbSetOrder(1)
			MSSeek(xFilial("SA1")+cCodCli+cLojCli)

			dbSelectArea("SC5")

			RecLock("SC5",.T.)  //** Inclui novo registro
			C5_FILIAL  	:= xFilial()
			C5_NUM     	:= GetSX8Num("SC5","C5_NUM")
			C5_TIPO    	:= "N"
			C5_CLIENTE 	:= SA1->A1_COD
			C5_CLIENT 	:= SA1->A1_COD
			C5_LOJACLI 	:= SA1->A1_LOJA
			C5_LOJAENT 	:= SA1->A1_LOJA
			C5_TIPOCLI 	:= SA1->A1_TIPO
			C5_CONDPAG 	:= SA1->A1_COND
			C5_TRANSP  	:= SA1->A1_TRANSP
			C5_TPFRETE 	:= SA1->A1_TPFRET
			//C5_PEDCLI  := GM->GMPED
			C5_EMISSAO 	:= dDataBase
			C5_DESC1   	:= SA1->A1_DESC
			C5_DESC2   	:= 0
			C5_DESC3   	:= 0
			C5_DESC4   	:= 0
			C5_ESPECI1 	:= ""
			C5_ESPECI2 	:= ""
			C5_ESPECI3 	:= ""
			C5_ESPECI4 	:= ""
			C5_MOEDA   	:= 1
			C5_TXMOEDA 	:= 1
			C5_TIPLIB  	:= "1"
			C5_TPCARGA 	:= "2"
			C5_XLOCEMB	:= aDoca[nDoca][1] //cLocDes	//Local de Desembarque
			C5_XCODINT	:= cCodItr	//Codigo Interno
			C5_XCODFAB	:= cCodFab	//Codigo da Fabrica
			C5_INDPRES  := "0"						//INSERIDO POR LUCIANO LAMBERTI EM 15-03-2021
			MsUnlock()  //** Grava a inclusão

			ConfirmSX8()

			//** Percorre os pedidos da TOYOTA para fazer a importação
			dbSelectArea("PE3V0")

			dbGoTop()

			While !EOF()

				cCodProCli 	 := PE3V0->ITECLI
				cDtaIniCli 	 := PE3V0->DATPRO
				cMarkIteProc := GetMark()

				While !Eof() .And. cCodProCli == PE3V0->ITECLI

					//Regra para quebra dos pedidos [Doca + Dt. Entrega]
					If AllTrim(PE3V0->XDOCA) == AllTrim(aDoca[nDoca][1]) .And. DToS(PE3V0->DATPRO) == AllTrim(aDoca[nDoca][2])
						ImportaItem(cCodCli, cLojCli, cMarkIteProc)
					EndIf

					dbSelectArea("PE3V0")

					dbSkip()

					IncProc()

				Enddo

				//    ExcluiPrg(cCodCli, cLojCli, cCodProCli, cDtaIniCli, cMarkIteProc)

			Enddo

			If !Empty(cPedGer)
				cPedGer += ", "
			EndIf

			cPedGer += SC5->C5_NUM

		End Transaction

	Next nDoca

	Alert("Número do Pedido Gerado : "+ AllTrim(cPedGer)/*SC5->C5_NUM*/)

	//GravaLOG()
	//ShellExecute('open',cArqLOG,'','',SW_SHOWNORMAL)  //** Abre o arquivo

Return Nil

//******************************************************************************
// - Inclui um novo PEDIDO - ITEM
Static Function ImportaItem(cCodCli, cLojaCli, cMarkIteProc)

	Default cCodCli 	:= "000077"
	Default cLojaCli 	:= "01"

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

	dbSelectArea("SC6")
	dbSetOrder(1)
	RecLock("SC6",.T.)

	C6_FILIAL  	:= xFilial()
	C6_ITEM    	:= soma1(cSeqItem)
	C6_PRODUTO 	:= SB1->B1_COD
	//C6_ZZCODCL := PE3V0->ITECLI
	//C6_DESCRI  	:= SB1->B1_DESC - alterado pelo Luciano Lamberti em 06-07-2018 (gerar pedido igual HONDA)
	C6_DESCRI	:= AllTrim(SB1->B1_CODMATR) + " " + AllTrim(SB1->B1_DESC) // Descricao do Produto que sairá na nota para Toyota - Luciano Lamberti - 06-07-2018
	C6_FCICOD   := u_GetFCICd( SB1->B1_COD )                              // Codigo da FCI - Inserido por Luciano Lamberti em 06-07-2018
	C6_QTDVEN  	:= PE3V0->QTDNEC
	C6_UM      	:= SB1->B1_UM
	C6_PRCVEN  	:= PE3V0->PREUNI        				//C6_PRUNIT - (C6_PRUNIT * SC5->C5_DESC1 / 100)
	C6_VALOR   	:= PE3V0->QTDNEC * PE3V0->PREUNI  	//C6_PRCVEN
	//C6_PEDCLI  := _nNumPed
	C6_LOCAL   	:= SB1->B1_LOCPAD
	C6_ENTREG  	:= PE3V0->DATPRO
	C6_CLI     	:= cCodCli
	C6_LOJA    	:= cLojCli
	C6_NUM     	:= SC5->C5_NUM
	C6_PRUNIT  	:= PE3V0->PREUNI      	    	//Posicione("SB0",1,xFilial()+ C6_PRODUTO, "B0_PRV1")
	C6_SUGENTR 	:= PE3V0->DATPRO
	C6_OK      	:= cMarkIteProc
	C6_XTPFORN 	:= PE3V0->XTPFORN
	C6_XKAMBAN 	:= PE3V0->XKAMBAN
	C6_XDATKAM 	:= PE3V0->XDATKAM
	C6_XQTDKAM 	:= PE3V0->XQTDKAM
	C6_XITENS 	:= PE3V0->XITENS
	C6_XCODPRD	:= PE3V0->CODPRD
	C6_RATEIO 	:= "2"
	C6_HORA		:= TIME()
	C6_TPOP		:= "F"
	C6_TES     	:= cTes
	C6_CF		:= cCf
	C6_CLASFIS	:= "500"
	cSeqItem	:= StrZero(Val(cSeqItem)+1,2)

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
	aAdd(_aStru,{"CODPRD"    ,"C",02,0})  //Codigo do Produto
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
	aAdd(_aStru,{"XDOCA"     ,"C",12,0})

	// cArqTrab := CriaTrab(_aStru, .T.)
	// dbUseArea(.T.,,cArqTrab,"PE3V0",.F.)
	// Index on itecli + dtos(DATPRO) to &cArqTrab

	// Instancio o objeto
	oTable  := FwTemporaryTable():New( "PE3V0" )
	// Adiciono os campos na tabela
	oTable:SetFields( _aStru )
	// Adiciono os índices da tabela
	// oTable:AddIndex( '01' , { cIndxKEY })
	// Crio a tabela no banco de dados
	oTable:Create()

	//** Definicao dos campos do BROWSE
	aCamposBrw := {}

	aAdd(aCamposBrw,{"ITEHON"   , "Peça Honda Lock" })
	aAdd(aCamposBrw,{"ITECLI"  	, "Peça Cliente" })
	aAdd(aCamposBrw,{"DESITE"   , "Descrição do Produto" })
	aAdd(aCamposBrw,{"XDOCA"   	, "Doca" })
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
Return Nil

//******************************************************************************
Static Function PegaCli(cNumCNPJ)

	Local cQuery := ""

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

Return lRet

//******************************************************************************
Static Function PegaProd(cBufPro)

	Local cQuery := ""

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

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SQLPRO->A7_PRODUTO)

		IF !Eof()
			cTes	:= SB1->B1_TS
			cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
		Else
			cTes	:= "502"
			cCf		:= "5101
		Endif

		lRet 	:= .T.

	else

		MsgAlert('Amarração Produto x Cliente não encontrada')

		cDesPro   	:= ""
		nPreUni		:= 0
		lRet	:= .F.

	Endif

	SQLPRO->(dbCloseArea())

Return Nil


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

	FWrite(nHndLOG, "SIGA ("+ FunName() +") Importação de pedidos da TOYOTA" +cEOL)
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
/*
Static Function LimpaPed(dDataPrg)

	//Local cAlias    := Alias()
	Local cQuery    := ""

	cQuery := "SELECT SC5.C5_NUM "
	cQuery += "FROM " + RetSQlName("SC5") + " SC5 "
	cQuery += "WHERE SC5.C5_CLIENTE = '"+cCodCli+"' AND SC5.C5_LOJACLI = '"+cLojCli+"' AND SC5.C5_EMISSAO = '"+DTOS(dDatPrg)+"' AND "
	cQuery += "SC5.C5_FILIAL = '"+xFilial('SC5')+"' AND SC5.D_E_L_E_T_ = ' '"

	If Select("TSC5") <> 0
		TSC5->(dbCloseArea())
	Endif

	TCQUERY cQuery NEW ALIAS "TSC5"

	dbGotop()

	IF !Eof()

		While !Eof()

			cQuery := "UPDATE " + RetSqlName("SC5") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = SC5.R_E_C_N_O_ "
			cQuery += "FROM " + RetSqlName("SC5") + " SC5 "
			cQuery += "WHERE SC5.D_E_L_E_T_ = ' ' AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND SC5.C5_NUM = '" + TSC5->C5_NUM + "' "

			IF TCSqlExec(cQuery) < 0
				HS_MsgInf("TCSQLError() " + TCSQLError(), "Atenção", "Exclusão dos Pedidos")
			Else

				cQuery := "UPDATE " + RetSqlName("SC6") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = SC6.R_E_C_N_O_ "
				cQuery += "FROM " + RetSqlName("SC6") + " SC6 "
				cQuery += "WHERE SC6.D_E_L_E_T_ = ' ' AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND SC6.C6_NUM = '" + TSC5->C5_NUM + "' "

				IF TCSqlExec(cQuery) < 0
					HS_MsgInf("TCSQLError() " + TCSQLError(), "Atenção", "Exclusão dos Pedidos")
				Endif

			Endif

			dbSkip()

		Enddo

	Endif

Return Nil
*/
