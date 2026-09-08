//Bibliotecas
#Include "Totvs.ch"

/*/{Protheus.doc} User Function KAIMP01
Importa Dados para Protheus
@author Matheus Freitas
@since 
@version 
@type function

/*/

User Function KAIMP01()
	Local aArea := FWGetArea()
	Local cDirIni := "c:\temp\"//GetTempPath()
	Local cTipArq := 'Arquivos com separaÁıes (*.csv) | Arquivos texto (*.txt) | Todas extensıes (*.*)'
	Local cTitulo := 'SeleÁ„o de Arquivos para Processamento'
	Local lSalvar := .F.
	Local cArqSel := ''
 
	//Se n„o estiver sendo executado via job
	If ! IsBlind()
		cArqSel := cGetFile('Arquivos CSV|*.CSV' , 'Selecione o Arquivo a ser importado, formato CSV',1,'C:\temp\',.F.,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE)
	    //Chama a funÁ„o para buscar arquivos
	    // cArqSel := tFileDialog(;
	    //     cTipArq,;  // Filtragem de tipos de arquivos que ser„o selecionados
	    //     cTitulo,;  // TÌtulo da Janela para seleÁ„o dos arquivos
	    //     ,;         // Compatibilidade
	    //     cDirIni,;  // DiretÛrio inicial da busca de arquivos
	    //     lSalvar,;  // Se for .T., ser· uma Save Dialog, sen„o ser· Open Dialog
	    //     ;          // Se n„o passar par‚metro, ir· pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT ser· possÌvel pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY ser· possÌvel selecionar o diretÛrio
	    // )

	    //Se tiver o arquivo selecionado e ele existir
	    If ! Empty(cArqSel) .And. File(cArqSel)
	        Processa({|| fImporta(cArqSel) }, 'Importando...')
	    EndIf
	EndIf
	
	FWRestArea(aArea)
Return
	
/*/{Protheus.doc} fImporta
FunÁ„o que processa o arquivo e realiza a importaÁ„o para o sistema
@author Raphael Rage
@since 15/04/2024
@version 
@type function

/*/

Static Function fImporta(cArqSel)
	Local cDirTmp    := GetTempPath()
	Local cArqLog    := 'importacao_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
	Local nTotLinhas := 0
	Local cLinAtu    := ''
	Local nLinhaAtu  := 0
	Local aLinha     := {}
	Local oArquivo
	Local cLog       := ''
	Local lIgnor01   := FWAlertYesNo('Deseja ignorar a linha 1 do arquivo?', 'Ignorar?')
	Local lExist
	Local cCodProd
	Local aErros	:={}
	Local aSucess	:={}
	//Vari·veis da ImportaÁ„o
	Private cAliasImp  := 'SB1'
	Private cSeparador := ';'

	//Abre as tabelas que ser„o usadas
	DbSelectArea(cAliasImp)
	(cAliasImp)->(DbSetOrder(1))
	(cAliasImp)->(DbGoTop())

	//Definindo o arquivo a ser lido
	oArquivo := FWFileReader():New(cArqSel)

	//Se o arquivo pode ser aberto
	If (oArquivo:Open())

		//Se n„o for fim do arquivo
		If ! (oArquivo:EoF())

			//Definindo o tamanho da rÈgua
			aLinhas := oArquivo:GetAllLines()
			nTotLinhas := Len(aLinhas)
			ProcRegua(nTotLinhas)

			//MÈtodo GoTop n„o funciona (dependendo da vers„o da LIB), deve fechar e abrir novamente o arquivo
			oArquivo:Close()
			oArquivo := FWFileReader():New(cArqSel)
			oArquivo:Open()

			//Caso vocÍ queira, usar controle de transaÁ„o, descomente a linha abaixo (e a do End Transaction), mas tem algumas rotinas que podem ser impactadas via ExecAuto
			//Begin Transaction

				//Enquanto tiver linhas
				While (oArquivo:HasLine())

					//Incrementa na tela a mensagem
					nLinhaAtu++
					IncProc('Analisando linha ' + cValToChar(nLinhaAtu) + ' de ' + cValToChar(nTotLinhas) + '...')

					//Pegando a linha atual e transformando em array
					cLinAtu := oArquivo:GetLine()
					aLinha  := Separa(cLinAtu, cSeparador)

					//Se estiver configurado para pular a linha 1, e for a linha 1 
					If lIgnor01 .And. nLinhaAtu == 1
						Loop

					//Se houver posiÁıes no array
					ElseIf Len(aLinha) > 0 
						
						/*
						//Transformando de caractere para data (exemplo '19930712' para 12/07/1993 -OU- '12/07/1993' para 12/07/1993)
						If ('/' $ aLinha[12])
							aLinha[12] := cToD(aLinha[12])
						Else
							aLinha[12] := sToD(aLinha[12])
						EndIf
						
						*/
						
						//Transformando de caractere para numÈrico (exemplo '1.234,56' para 1234.56)


												
						cLog += '+ Processando a linha ' + cValToChar(nLinhaAtu) + ';' + CRLF

						lExist := .F.
						//Verifica se o cÛdigo j· existe
						(cAliasImp)->(DbSetOrder(1))
						cCodProd:= RemoveAcentos(aLinha[1])
						cCodProd:= Padr(cCodProd,TamSX3("B1_COD")[1])
						
						//Verifica se o cÛdigo j· existe na tabela de Produtos SB1
						if (cAliasImp)->(DbSeek(cCodProd))
							cMsgProc  :="Erro :Produto " + cCodProd + " j· existe na SB1, linha ignorada. linha : "+cValToChar(nLinhaAtu)
							cDocProc  :="-Arq.:"+cArqSel
							aadd(aErros,{"IMPPROD"/*Rotina*/,cDocProc/*Doc*/,cMsgProc/*Mensagem*/,FwTimeStamp(3)/*Data Hora*/})
							lExist := .T.
						Endif

						//Verifica se o cÛdigo j· existe na tabela de Produtos/Fornecedor SA5
						SA5->(DbSetOrder(2))//A5_FILIAL, A5_PRODUTO, A5_FORNECE, A5_LOJA, R_E_C_N_O_, D_E_L_E_T_
						if SA5->(DbSeek(+cCodProd)) //Filial + Produto + Fornecedor + Loja
							cMsgProc  :="Erro :Produto " + cCodProd + " j· existe na Tabels SA5 Produto/Fornecedor, linha ignorada. linha : "+cValToChar(nLinhaAtu)
							cDocProc  :="-Arq.:"+cArqSel
							aadd(aErros,{"IMPPROD"/*Rotina*/,cDocProc/*Doc*/,cMsgProc/*Mensagem*/,FwTimeStamp(3)/*Data Hora*/})
							lExist := .T.
						Endif

						if !lExist 
							if RecLock(cAliasImp, .T.)
								B1_COD := cCodProd
								B1_DESC := RemoveAcentos(aLinha[2])
								B1_TIPO  := aLinha[3]
								B1_UM := aLinha[4]
								B1_LOCPAD := aLinha[5]
								B1_GRUPO := aLinha[6]
								B1_POSIPI := aLinha[7]
								B1_ORIGEM := aLinha[8]
								B1_RASTRO  := aLinha[09]
								B1_LOCALIZ := aLinha[10]

								(cAliasImp)->(MsUnlock())

								cMsgProc  :="SUCESSO :Filial/Produto " +aLinha[1]+"/"+ cCodProd + " cadastrado com sucesso , linha : "+cValToChar(nLinhaAtu)
								cDocProc  :="-Arq.:"+cArqSel
								aadd(aSucess,{"IMPPROD"/*Rotina*/,cDocProc/*Doc*/,cMsgProc/*Mensagem*/,FwTimeStamp(3)/*Data Hora*/})
							else 
								cMsgProc  :="Erro :Produto " + cCodProd + " n„o foi possÌvel processar o reclock na tabela SB1, linha ignorada. linha : "+cValToChar(nLinhaAtu)
								cDocProc  :="-Arq.:"+cArqSel
								aadd(aErros,{"IMPPROD"/*Rotina*/,cDocProc/*Doc*/,cMsgProc/*Mensagem*/,FwTimeStamp(3)/*Data Hora*/})
							Endif 
						Endif 

					EndIf

				EndDo
			//End Transaction
			if Len(aErros)>0
				BoxMsgErro(aErros,"ATENCAO")
			endif
			if Len(aSucess)>0
				BoxMsgErro(aSucess,"ATENCAO")
			endif

			//Se tiver log, mostra ele
			If ! Empty(cLog)
				MemoWrite(cDirTmp + cArqLog, cLog)
				//ShellExecute('OPEN', cArqLog, '', cDirTmp, 1)
			EndIf

		Else
			FWAlertError('Arquivo n„o tem conte˙do!', 'AtenÁ„o')
		EndIf

		//Fecha o arquivo
		oArquivo:Close()
	Else
		FWAlertError('Arquivo n„o pode ser aberto!', 'AtenÁ„o')
	EndIf

Return


Static Function RemoveAcentos(cString)
  Local cRet := cString
  Local i,ix
  Local aTabela := {{"∞","O"},{"É",''},{"<",''},{">",''},{"á",''},{"ù",''}}
  
  //Elimina os caracters de controle
  For ix :=1 to 31 
  	aadd(aTabela,{Chr(ix),''})
  Next 

  //Elimina os caracters 
  For ix :=126 to 197
  	aadd(aTabela,{Chr(ix),''})
  Next 

aadd(aTabela,{chr(63),'?'})
aadd(aTabela,{'"',''})
aadd(aTabela,{'#',''})
aadd(aTabela,{'$',''})
aadd(aTabela,{'%',''})
aadd(aTabela,{'&',''})
aadd(aTabela,{"'",''})
//aadd(aTabela,{'¡','A'})
//aadd(aTabela,{'¬','A'})
//aadd(aTabela,{'√','A'})
aadd(aTabela,{'ƒ','A'})
aadd(aTabela,{'≈','A'})
aadd(aTabela,{'∆',''})
//aadd(aTabela,{'«','C'})
//aadd(aTabela,{'»','E'})
//aadd(aTabela,{'…','E'})
//aadd(aTabela,{' ','E'})
aadd(aTabela,{'À','E'})
//aadd(aTabela,{'Ã','I'})
//aadd(aTabela,{'Õ','I'})
aadd(aTabela,{'Œ','I'})
aadd(aTabela,{'œ','I'})
aadd(aTabela,{'–',''})
aadd(aTabela,{'—','N'})
//aadd(aTabela,{'“','O'})
//aadd(aTabela,{'”','O'})
//aadd(aTabela,{'‘','O'})
//aadd(aTabela,{'’','O'})
aadd(aTabela,{'÷','O'})
aadd(aTabela,{'◊',''})
aadd(aTabela,{'ÿ','0'})
//aadd(aTabela,{'Ÿ','U'})
//aadd(aTabela,{'⁄','U'})
aadd(aTabela,{'€','U'})
aadd(aTabela,{'‹','U'})
aadd(aTabela,{'›','Y'})
aadd(aTabela,{'ﬁ',''})
aadd(aTabela,{'ﬂ',''})
//aadd(aTabela,{'‡','a'})
//aadd(aTabela,{'·','a'})
//aadd(aTabela,{'‚','a'})
//aadd(aTabela,{'„','a'})
aadd(aTabela,{'‰','a'})
aadd(aTabela,{'Â','a'})
aadd(aTabela,{'Ê',''})
//aadd(aTabela,{'Á','c'})
//aadd(aTabela,{'Ë','e'})
//aadd(aTabela,{'È','e'})
//aadd(aTabela,{'Í','e'})
aadd(aTabela,{'Î','e'})
//aadd(aTabela,{'Ï','i'})
//aadd(aTabela,{'Ì','i'})
aadd(aTabela,{'Ó','i'})
aadd(aTabela,{'Ô','i'})
//aadd(aTabela,{'','o'})
aadd(aTabela,{'Ò','n'})
//aadd(aTabela,{'Ú','o'})
//aadd(aTabela,{'Û','o'})
//aadd(aTabela,{'Ù','o'})
//aadd(aTabela,{'ı','o'})
aadd(aTabela,{'ˆ','o'})
aadd(aTabela,{'˜','+'})
aadd(aTabela,{'¯','0'})
//aadd(aTabela,{'˘','u'})
//aadd(aTabela,{'˙','u'})
aadd(aTabela,{'˚','u'})
aadd(aTabela,{'¸','u'})
aadd(aTabela,{'˝','y'})
aadd(aTabela,{'˛',''})
aadd(aTabela,{'ˇ','y'})

  For i := 1 to Len(aTabela)
    cRet := StrTran(cRet, aTabela[i][1], aTabela[i][2])
  Next

Return cRet


/* Tela Final de Processamento em caso de erro
   Lista os erros ocorridos no final do processo--
*/

Static Function BoxMsgErro( xMsg, cTitulo, cLabel, aButtons, bValid, lQuebraLinha )
    Local ix 
    local oDlg
    local oMemo
    local oFont             := TFont():New("Courier New",09,15)
    local cMsg              := ""

    Local nJanAltu   := 350
    Local nJanLarg   := 250

    default xMsg            := ""
    default cTitulo         := ""
    default cLabel          := ""
    default aButtons        := {}
    default bValid          := {|| .T. }
    default lQuebraLinha    := .F.

    cMsg += " GeraÁ„o Realizada Por    : "+Alltrim(UsrFullName(RetCodUsr()))+CRLF
    cMsg += "__________________________________________________________________ " + CRLF

    If ValType(xMsg) = "C"
        cMsg := xMsg
    ElseIf ValType(xMsg) = "A"
        for ix:=1 to len(xMsg)
            cMsg += " GeraÁ„o Realizada Em     : "+xMsg[ix][4]+CRLF
            cMsg += " Rotina                   : "+xMsg[ix][1]+CRLF
            cMsg += " Documento                : "+xMsg[ix][2]+CRLF
            cMsg += " Mensagem                 : "+xMsg[ix][3]+CRLF
            cMsg += "__________________________________________________________________ " + CRLF
        Next
    EndIf

    oDlg:= FWDialogModal():New()
    oDlg:SetEscClose(.F.)
    oDlg:setTitle(cTitulo)
    oDlg:setSubTitle(cLabel )

    //Seta a largura e altura da janela em pixel
    oDlg:setSize(nJanLarg,nJanAltu)

    oDlg:createDialog()
    oDlg:addCloseButton(nil, "Fechar")
    oDlg:AddButton( 'Salvar', {||openNotePa( .f., cMsg, "log.txt" )}, 'Salvar', , .T., .F., .T., )

    oPanel := TPanel():New( ,,, oDlg:getPanelMain() )
    oPanel:Align:= CONTROL_ALIGN_ALLCLIENT

    @ 05,05 To 190,330 Label cLabel Pixel Of oPanel
    @ 10,10 Get oMemo Var cMsg MEMO HSCROLL FONT oFont Size 315,175 READONLY Of oPanel  Pixel

    oMemo:lWordWrap := lQuebraLinha
    oMemo:EnableVScroll(.t.)
    oMemo:EnableHScroll(.t.)

    oDlg:Activate()


return

/*gera log txt no temp e abre no notepad*/
Static Function openNotePa(lApaga,cMsg,cFile)

    Local lRet:=.t., cDir:=GetWinDir()+"\Temp\",hFile

    Default lApaga := .f. // Se .t. apaga arquivo tempor·rio.
    Default cFile  := "log.txt"

    Begin Sequence

        If !lApaga
            hFile := fCreate(cDir+cFile)

            fWrite(hFile,cMsg,Len(cMsg))

            fClose(hFile)

            WinExec("NotePad "+cDir+cFile)
        Else
            If File(cDir+cFile)
                fErase(cDir+cFile)
            EndIf
        EndIf

    End Sequence

Return lRet
