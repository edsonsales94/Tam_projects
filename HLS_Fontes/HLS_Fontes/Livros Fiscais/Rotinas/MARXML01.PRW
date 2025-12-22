#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.Ch"
#INCLUDE "TopConn.Ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "XMLXFUN.CH"

/*/{Protheus.doc} GERACD5

Grava o campo FT_CHVNFE de acordo com o XML lido.

@type function
@author Honda Lock
@since 01/10/2017

/*/

User Function MARXML01()

Local cError   := ""
Local cWarning := ""
Local cArq		:= ""
Local cLer		:= "J:\XML\" //"J:\XML\" //"E:\XML\"
Local cArqDest	:= ""
Local cDrivers := "Arquivos XML       (*.XML) | *.XML |"
Local cLidos 	:= "\Lido\"
Local aArqs		:= {} // Array com os nomes dos arquivos encontrados no diretorio para leitura.
Local lGravou	:= .f.
Local lSa2     := .F.
Local lSa1     := .F.

Private lErro	:= .F.
Private oXml	:= Nil

ADIR(cLer+"*.XML",aArqs) // Busca todos os arquivos XML do diretorio

If len(aArqs) == 0 // Verificando se nao foram encontrados arquivos para leitura
	Alert("Não existem arquivos a serem lidos no diretorio "+cLer)
	Return
Endif

// Chamando a rotina de importação para todos os arquivos do diretorio.
For nx := 1 to len(aArqs)
	
	cArquivo := cLer+aArqs[nx]
	cArqDest := cLer+cLidos+aArqs[nx]
	
	oXml := XmlParserFile( cArquivo, "_", @cError, @cWarning )
	
	CREATE oXML XMLFILE cArquivo SETASARRAY _LTAPX
	
	if Type("oXML:_NFEPROC") == "U"
		loop
	endif
	
	cCNPJ	:= oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
	cNFiscal:= oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT
	cSerie  := oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT
	cChave  := oXML:_NFEPROC:_NFE:_INFNFE:_ID:TEXT
	
	cNotaFis:= PadL(AllTrim(cNFiscal), 9, "0")
	cSeriFis:= IIf(AllTrim(cSerie) == "0", Space(3), PadR(AllTrim(cSerie), 3))
	//		MsgStop("Nro NF [" + cNotaFis + "]  Serie [" + cSeriFis + "]")
	
	dbSelectArea("SA1")
	dbSetOrder(3)
	
	dbSelectArea("SA2")
	dbSetOrder(3)
	if   (lSa2 := SA2->(dbSeek(xFilial("SA2")+Alltrim(cCNPJ)))) .Or. (lSa1 := SA1->(dbSeek(xFilial("SA1")+Alltrim(cCNPJ))))
		
		If     lSa2
			cFornece:= SA2->A2_COD
			cLoja	:= SA2->A2_LOJA
		ElseIf lSa1
			cFornece:= SA1->A1_COD
			cLoja	:= SA1->A1_LOJA
		EndIf
        		
		cSeriFb := "%"+Alltrim(cSeriFis)+"%"

		cQuery := "SELECT FT_NFISCAL, FT_SERIE, FT_CLIEFOR, FT_LOJA "
		cQuery += "FROM " + RetSqlName("SFT") + " "
		cQuery += "WHERE FT_FILIAL = '" + xFilial("SFT") + "' AND "
		cQuery += "FT_CLIEFOR = '" + cFornece + "' AND "
		cQuery += "FT_LOJA = '" + cLoja + "' AND "
		cQuery += "FT_NFISCAL = '" + cNotaFis + "' AND "
		cQuery += "FT_SERIE LIKE '" + Alltrim(cSeriFb) + "' AND "
		cQuery += "FT_TIPOMOV = 'E' AND "
		cQuery += "D_E_L_E_T_ <> '*' "
		cQuery += "ORDER BY FT_NFISCAL, FT_SERIE, FT_CLIEFOR, FT_LOJA "
		
		TcQuery cQuery Alias TSFT New
		
		DbSelectArea("TSFT")
		TSFT->(DbGoTop())
		
		//dbSelectArea("SFT")
		//if dbSeek(xFilial("SFT")+"E"+cSeriFis+cNotaFis+cFornece+cLoja)
		If !TSFT->(Eof())
			//While !TSFT->(Eof()) .and. SFT->FT_NFISCAL == cNotaFis .and. TSFT->FT_SERIE == cSeriFis .and. SFT->FT_CLIEFOR == cFornece .and. SFT->FT_LOJA == cLoja
			While !TSFT->(Eof()) //.and. TSFT->FT_NFISCAL == cNotaFis .and. TSFT->FT_SERIE $ cSeriFis .and. TSFT->FT_CLIEFOR == cFornece .and. TSFT->FT_LOJA == cLoja
				
				dbSelectArea("SFT")
				if dbSeek(xFilial("SFT")+"E"+TSFT->FT_SERIE+TSFT->FT_NFISCAL+TSFT->FT_CLIEFOR+TSFT->FT_LOJA)
					While !TSFT->(Eof()) .and. SFT->FT_NFISCAL == TSFT->FT_NFISCAL .and. SFT->FT_SERIE == TSFT->FT_SERIE .and. SFT->FT_CLIEFOR == TSFT->FT_CLIEFOR .and. SFT->FT_LOJA == TSFT->FT_LOJA
						if Empty(SFT->FT_CHVNFE)
							RecLock("SFT",.f.)
							SFT->FT_CHVNFE:= Substr(cChave,5,44)
							MsUnlock()
							lGravou:= .t.
						endif
						SFT->(dbSkip())
					EndDo	
				EndIf
			TSFT->(dbSkip())
			enddo
		TSFT->(dbCloseArea())	
		Else
			MsgAlert("NF não econtrada [" + "E"+cSeriFis+cNotaFis+cFornece+cLoja + "]")
		TSFT->(dbCloseArea())			
		EndIf
	else
		MsgAlert("CNPJ "+Alltrim(cCNPJ)+" Não Encontrado no Cadastro de Fornecedores! O Número da Nota Fiscal é "+Alltrim(cNotaFis)+"/"+Alltrim(cSeriFis),"Atenção")
	endif
	
	if lGravou
		// Move arquivo para pasta Lidos e apaga da pasta leitura | Paulo Romualdo - 05/12/2008
		_CopyFile(cArquivo,cArqDest)
		Ferase(cArquivo)
		lGravou:= .f.
	endif
Next nx

MsgAlert("Finalizado leitura dos Arquivos XML")

Return

