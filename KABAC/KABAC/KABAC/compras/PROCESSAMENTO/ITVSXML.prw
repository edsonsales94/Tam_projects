#Include "PROTHEUS.CH"

/*/{Protheus.doc} ITVSXML
	Rotina de importação de nota fiscal no formato XML.
	Verifica a existência do Fornecedor, dos Produtos e das Amarrações entre Prod e Forn, 
	além de criar a pré-nota de entrada.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 13/07/2015
/*/
User Function ITVSXML()
	Local aSize, aInfo, aPosGet, aPosRdp, oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, nI, oTFont12, oTFont14
	Local nPosLin  := 2
	Local aAlter   := { "CY_PENDEN","D1_TES","D1_COD" }
	Local aObjects := {}
	
	// -------------------
	// Erros
	// -------------------
	Private cMsgErro	:= "" //Campo de mensagem de erro padrão
	Private cFornErro	:= "O fornecedor do Arquivo XML não estão cadastrado no sistema."
	Private cNotaErro	:= "Nota Fiscal já cadastrada no sistema."
	Private cProdErro	:= "Existe(m) produto(s) não cadastrado(s) no sistema."
		
	// -------------------
	// Variáveis Privadas
	// -------------------
	Private aCampos := {	{"B1_OK"      ,"Status"    },;
							{"D1_ITEM"    ,"Item"      },;
							{"A5_CODPRF"  ,"Produto NF"},;
							{"D1_COD"     ,"Produto"   },;
							{"B1_DESC"    ,"Descricao" },;
							{"B1_POSIPI"  ,"NCM NF"    },;
							{"B1_VEREAN"  ,"Código EAN"},;
							{"B1_CLASFIS" ,"CST NF"    },;
							{"B1_CLASFIS" ,"CST Prod"  },;
							{"D1_LOCAL"   ,"Almox"     },;
							{"CY_PENDEN"  ,"Usa 2a UM" },;
							{"D1_UM"      ,"UM"        },;
							{"D1_SEGUM"   ,"Segunda UM"},;
							{"D1_QUANT"   ,"Quantidade"},;
							{"D1_QTSEGUM" ,"Qtde 2a UM"},;
							{"D1_VUNIT"   ,"Vlr.Unit"  },;
							{"D1_CUSFF2"  ,"Vlr.2a UM" },;
							{"D1_TOTAL"   ,"Vlr. Total"},;
							{"D1_VALDESC" ,"Desconto"  },;
							{"D1_BRICMS"  ,"BC Icms"   },;
							{"D1_ICMSRET" ,"ICMS ST"   },;
							{"D1_PEDIDO"  ,"Pedido"    },;
							{"D1_ITEMPC"  ,"Item PC"   },; 
							{"D1_NFORI"   ,"Nf Origem"      },;
							{"D1_SERIORI" ,"Serie Origem"   },; 
							{"D1_ITEMORI" ,"Item Origem"    },;
							{"D1_IDENTB6" ,"IdentB6 Origem" },;
							{"D1_XDESXML" ,"Descr. Fornecec"},;
							{"D1_XUMXML"  ,"UM. Fornecec"   },;
							{"D1_XQTDXML" ,"Qtd. Fornec"    },;
							{"D1_XDI"     ,"Numero DI"      }}
							/*{"D1_TES"     ,"Tes"},;*/
	Private cOrig  := ""
	Private oXml
	Private nUsado := 0
	Private oDlg
	Private oArquivo,oDtEnt,oDoc,oSerie,oDtEmiss,oCodFor,oLojFor,oNomFor,oItens,oMsgErro,oChkCor
	
	//Botões:
	Private oButArq      //Botão de Seleção de Arquivo
	Private oButCar      //Botão de Carregamento de Arquivo
	Private oButGrv      //Botão de Geração de Pré-Nota
	Private oButFechar   //Botão de Fechar Tela
	Private oButCad      //Botão de Cadastro de Produto
	Private oButClear    //Botão para Limpar Tela
	Private oButPxF      //Botão para Cadastrar Produto X Fornecedor
	Private oButPed      //Botão para vincular o pedido de compra
	
	//Cabeçalho da NF (Dados de SF1(Cabeçalho das NF de entrada)  e SA2(Fornecedores))
	Private cDoc     := Space(TamSx3("F1_DOC"    )[1])
	Private cSerie   := Space(TamSx3("F1_SERIE"  )[1])
	Private cDtEmiss := Space(TamSx3("F1_EMISSAO")[1])
	Private cCodFor  := Space(TamSx3("A2_COD"    )[1])
	Private cLojFor  := Space(TamSx3("A2_LOJA"   )[1])
	Private cNomFor  := Space(TamSx3("A2_NOME"   )[1])
	Private cDtEnt   := Dtoc(DdataBase)
	Private cChave   := Space(TamSx3("F1_CHVNFE" )[1])
	Private cTxDolar := ""
	Private cDINumer := ""
	Private nPsBruto := 0
	Private nPsLiqui := 0
	Private nTotMerc := 0
	
	Private lNFCad   := .F. //Controla se a nota fiscal em questão já consta cadastrada no sistema (impede o recadastro)
	Private lGrava   := .T.
	Private lImport  := .F. //controla se é importacao
	Private lCte     := .F.
	Private aHeader  := {}
	Private aCols    := {}
	Private aRotina  := {	{"Pesquisar" , "AxPesqui", 0, 1},;
							{"Visualizar", "AxVisual", 0, 2},;
							{"Incluir"   , "AxInclui", 0, 3},;
							{"Alterar"   , "AxAltera", 0, 4},;
							{"Excluir"   , "AxDeleta", 0, 5}}
	Private cTipo    := 'N'
	Private Inclui   := .T.
	Private Altera   := .F. 
	Private cTes 	 := ""
	
	//Parâmetros para Cad de Produto
	Private cDescXml
	Private cCodBarXml
	Private cUnidXml
	
	M->ARQUIVO := Space(100)
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	
	//Legenda
	Aadd(aHeader,{ "","B1_OK","@BMP",1,0,"",,"C","","","",""})
	nUsado++
	
	//Monta aHeader com base nos campos do array "aCampos" (Começa da 2a pos, pois a primeira é o botão de status)
	For nI:=2 To Len(aCampos)
		If SX3->(DbSeek(aCampos[nI][1]))
			nUsado++
			AADD( aHeader , { Trim(aCampos[nI][2]),;
									aCampos[nI][1],;
									SX3->X3_PICTURE,;
									SX3->X3_TAMANHO,;
									SX3->X3_DECIMAL,;
									if(rtrim(SX3->X3_CAMPO) $ 'A2_COD_MUN,D1_COD','u_ImpXmlVld()',SX3->X3_VALID),;
									"",;
									SX3->X3_TIPO,;
									SX3->X3_F3,;
									SX3->X3_CONTEXT, ;
									SX3->X3_CBOX, ;
									SX3->X3_RELACAO } )
		EndIf
	Next
	
	//--------------------------------------------------------------
	//Linha em branco do aCols na tela inicial da rotina
	Aadd(aCols,Array(nUsado+2))
	
	//Adiciona bolinha vermelha de "Não cadastrado"
	aCols[1][1] := LoadBitmap( GetResources(), "BR_VERMELHO" )Â 
	
	//Cria espaços no aCols com base nos campos do array "aHeader" (começa da 2a pos pelo mesmo motivo acima /\)
	For nI := 2 To nUsado
		aCols[1][nI] := CriaVar(aHeader[nI][2])
	Next
	
	aCols[1][nUsado+1] := .F.   // Flag de produto ok
	aCols[1][nUsado+2] := .F.   // Flag de deleção
	
	oTFont12 := TFont():New('Times New Roman',,-12,.T.,.T.)
	oTFont14 := TFont():New('Times New Roman',,-14,.T.,.T.)
	aSize    := MsAdvSize(.T.,.F.)
	
	AAdd( aObjects, { 100,  40, .t., .f. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100,  30, .t., .f. } )
	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosGet  := MsObjGetPos(aSize[3]-aSize[1], aSize[4]-aSize[2],{{003,073,103}} )
	aPosRdp  := MsObjSize(aInfo, aObjects )
	
	oDlg     := MSDialog():New(aSize[7],aSize[1],aSize[6],aSize[5],'Importação de Arquivo XML',,,,,CLR_BLACK,CLR_WHITE,,,.T.)  // Ativa diálogo centralizado
	
	oSay1    := TSay():New(nPosLin,aPosGet[1,1] ,{||"Arquivo de importação"},    oDlg, , , , ,,.T., CLR_BLUE,CLR_WHITE,200,20)
	
	oArquivo := TGet():New(nPosLin+8,aPosGet[1,1],{|| M->ARQUIVO } ,oDlg,200,009,/*acPict*/,/*abValid*/,0,/*anClrBack*/,/*aoFont*/,.F.,/*oPar13*/,.T.,/*cPar15*/,.F.,/*abWhen*/,.F.,.F.,,.T.,.F.,,M->ARQUIVO,,,,)
	
	oButArq    := TButton():New(nPosLin+8,aPosGet[1,2]+50    , "Arquivo"       ,oDlg,{|| fSelArq()            },40,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	oButCar    := TButton():New(nPosLin+8,aPosGet[1,2]+95    , "Carregar"      ,oDlg,{|| MsgRun("Carregando XML"  ,"Processando",{|| fCarrArq()     }) },40,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	
	oButGrv    := TButton():New(nPosLin+8,aPosGet[1,3]+(2*90), "Gerar Pré-Nota",oDlg,{|| MsgRun("Gerando Pre Nota","Processando",{|| fGeraPreNota() }) },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	oButClear  := TButton():New(nPosLin+8,aPosGet[1,3]+(3*90), "Limpar tela"   ,oDlg,{|| fLimpaTela(0)        },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	oButFechar := TButton():New(nPosLin+8,aPosGet[1,3]+(4*90), "Fechar"        ,oDlg,{|| fFechar()            },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	
	nPosLin += 23
	oSay2    := TSay():New(nPosLin  ,aPosGet[1,1] ,{|| "Data da Entrada"                   }, oDlg, ,        , , ,,.T., CLR_BLUE ,CLR_WHITE,200,20)
	oDtEnt   := TSay():New(nPosLin+8,aPosGet[1,1] ,{|| Alltrim(cDtEnt)                     }, oDlg, ,oTFont12, , ,,.T., CLR_BLACK,CLR_WHITE,200,20)
	oSay3    := TSay():New(nPosLin  ,aPosGet[1,2] ,{|| "Nota Fiscal/Série"                 }, oDlg, ,        , , ,,.T., CLR_BLUE ,CLR_WHITE,200,20)
	oDoc     := TSay():New(nPosLin+8,aPosGet[1,2] ,{|| Alltrim(cDoc)+" / "+Alltrim(cSerie) }, oDlg, ,oTFont12, , ,,.T., CLR_BLACK,CLR_WHITE,200,20)
	oSay4    := TSay():New(nPosLin  ,aPosGet[1,3] ,{|| "Data Emissão"                      }, oDlg, ,        , , ,,.T., CLR_BLUE ,CLR_WHITE,200,20)
	oDtEmiss := TSay():New(nPosLin+8,aPosGet[1,3] ,{|| Alltrim(cDtEmiss)                   }, oDlg, ,oTFont12, , ,,.T., CLR_BLACK,CLR_WHITE,200,20)
	
	oButCad  := TButton():New(nPosLin,aPosGet[1,3]+(2*90), "Cadastrar Produto",oDlg,{|| fCadProd()   },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	oButPxF  := TButton():New(nPosLin,aPosGet[1,3]+(3*90), "Cad Prod x Forn"  ,oDlg,{|| fCadPxf()    },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	oButPed  := TButton():New(nPosLin,aPosGet[1,3]+(4*90), "Pedido Compra"    ,oDlg,{|| Documentos() },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	
	oButGrv:Disable()
	oButCad:Disable()
	oButPxF:Disable()
	oButPed:Disable()
	
	nPosLin += 23
	oSay5    := TSay():New(nPosLin  ,aPosGet[1,1]     ,{|| "Código/Loja Fornecedor"                }, oDlg, ,        , , ,,.T., CLR_BLUE ,CLR_WHITE,200,20)
	oCodFor  := TSay():New(nPosLin+8,aPosGet[1,1]     ,{|| Alltrim(cCodFor)+" / "+Alltrim(cLojFor) }, oDlg, ,oTFont12, , ,,.T., CLR_BLACK,CLR_WHITE,200,20)
	oSay6    := TSay():New(nPosLin  ,aPosGet[1,2]     ,{|| "Nome Fornecedor"                       }, oDlg, ,        , , ,,.T., CLR_BLUE ,CLR_WHITE,200,20)
	oNomFor  := TSay():New(nPosLin+8,aPosGet[1,2]     ,{|| Alltrim(cNomFor)                        }, oDlg, ,oTFont12, , ,,.T., CLR_BLACK,CLR_WHITE,200,20)
	oMsgErro := TSay():New(nPosLin+8,aPosGet[1,2]+180 ,{|| cMsgErro                                }, oDlg, ,oTFont14, , ,,.T., CLR_HRED ,CLR_WHITE,200,20)
	
	nPosLin += 23
	oTxDolar := TSay():New(nPosLin+8,aPosGet[1,2]     ,{|| cTxDolar                                }, oDlg, ,oTFont14, , ,,.T., CLR_HRED ,CLR_WHITE,200,20)
	
	oItens := MsGetDados():New(aPosRdp[2,1],aPosRdp[2,2], aPosRdp[2,3], aPosRdp[2,4], 4, "U_fLinhaOK", "U_fTudoOK", /*"+"D1_ITEM"*/, .F., aAlter,/*Reservado*/, .T., Len(aCols), "u_COMP01Valid", , , , oDlg)
	
	oSay7  := TSay():New(aPosRdp[3,1]+0,aPosRdp[3,2],{|| "Valor Total dos Itens"  }, oDlg, ,oTFont12, , ,,.T., CLR_BLUE ,CLR_WHITE,200,20)
	oMerc  := TGet():New(aPosRdp[3,1]+8,aPosRdp[3,2],{|u| nTotMerc := If(PCount() == 0, nTotMerc, u) } ,oDlg,80,10,"@E 999,999,999.99",/*abValid*/,0,/*anClrBack*/,oTFont12,.F.,/*oPar13*/,.T.,/*cPar15*/,.F.,/*abWhen*/,.F.,.F.,/*bChange*/,.T.,.F.,,"nTotMerc",,,,)
	
	oDlg:Activate(,,,.T.,,,)
	
Return

/*/{Protheus.doc} ImpXmlVld
	Funcao para validacao de campos da grid de importacao de xml.
	@author matheus.vinicius
	@since 31/01/2023
/*/
User Function ImpXmlVld()
	Local lret := .T.
	Local cReadVar := ReadVar()

	if !lImport
		lRet := .F.
	else
		if cReadVar == "M->D1_COD" 
			SB1->(DbSetOrder(1))
			if SB1->(DbSeek(xFilial("SB1")+&(cReadVar))) .and. !empty(&(cReadVar))
				aCols[n][fGetIndice("D1_COD"  ,aHeader)]   := SB1->B1_COD
				aCols[n][fGetIndice("D1_LOCAL",aHeader)]   := SB1->B1_LOCPAD
				aCols[n][fGetIndice("D1_UM"   ,aHeader)]   := SB1->B1_UM
				aCols[n][fGetIndice("D1_SEGUM",aHeader)]   := SB1->B1_SEGUM
				aCols[n][fGetIndice("D1_QTSEGUM",aHeader)] := aCols[n][fGetIndice("D1_QUANT"  , aHeader)]	* SB1->B1_CONV
				oItens:Refresh()
				
				//Deixa a legenda verde (produto cadastrado)
				aCols[n][1]        := LoaDbitmap( GetResources(), "BR_VERDE" )
				aCols[n][nUsado+1] := .T.
				
				if fAllDIOK()
					oButGrv:Enable()
					oButCad:Disable()
				else
					oButGrv:Disable()
					oButPxF:Disable()
					oButPed:Disable()
					oButCad:Enable()
				endif

			elseif !empty(&(cReadVar))
				MsgStop('Produto não cadastrado!', 'Atenção')
				lRet := .F.
			else
				aCols[n][fGetIndice("D1_COD"  ,aHeader)]   := space(len(SB1->B1_COD))
				aCols[n][fGetIndice("D1_LOCAL",aHeader)]   := space(len(SB1->B1_LOCPAD))
				aCols[n][fGetIndice("D1_UM"   ,aHeader)]   := space(len(SB1->B1_UM))
				aCols[n][fGetIndice("D1_SEGUM",aHeader)]   := space(len(SB1->B1_SEGUM))
				aCols[n][fGetIndice("D1_QTSEGUM",aHeader)] := 0
				oItens:Refresh()
				
				//Deixa a legenda verde (produto cadastrado)
				aCols[n][1]        := LoaDbitmap( GetResources(), "BR_VERMELHO" )
				aCols[n][nUsado+1] := .F.
				
				oButGrv:Disable()
				oButCad:Enable()
				oButPxF:Disable()
				oButPed:Disable()				
			endif
		endif
	endif

Return lRet

Static Function fAllDIOK
	Local lRet := .T.
	Local nI   := NIL

	For nI := 1 to len(aCols)
		if aCols[nI,1] == LoaDbitmap( GetResources(), "BR_VERMELHO" )
			lRet := .F.
			exit
		endif
	Next
Return lRet

/*/{Protheus.doc} fSelArq
	Tela de Pesquisa do Arquivo XML.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 13/07/2015
/*/
Static Function fSelArq()
   Local cDirIni := GetTempPath()
   Local cTipArq := "eXtensible Markup Languague" +" (*.xml) |*.xml|"
   Local cTitulo := "Selecione o Arquivo para Processamento"
   Local lSalvar := .F.
   //cType := "eXtensible Markup Languague" +" (*.xml) |*.xml|"
   //M->ARQUIVO := cGetFile(cType, "Selecione o arquivo")
   M->ARQUIVO := tFileDialog(;
            cTipArq,;  // Filtragem de tipos de arquivos que serão selecionados
            cTitulo,;  // Tí­tulo da Janela para seleção dos arquivos
            ,;         // Compatibilidade
            cDirIni,;  // Diretório inicial da busca de arquivos
            lSalvar,;  // Se for .T., será uma Save Dialog, senão será Open Dialog
            ;          // Se não passar parâmetro, irá pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT será possí­vel pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY será possí­vel selecionar o diretório
        )
   oArquivo:Refresh()
Return

/*/{Protheus.doc} fCarrArq
	Carrega Arquivo XML.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 13/07/2015
	@version 1.0
/*/
Static Function fCarrArq()
	Local nX, nI, aAdicao
	Local cWarning := ""
	Local cError   := ""
	Local cFDest   := Substr(M->ARQUIVO,Rat("/",M->ARQUIVO)+1,Len(M->ARQUIVO))
	Local cDest    := '/xmlnfe/'
	Local aDet     := {}
	Local cFornDI  := ""
	Local nTxDolar := 0
	Local nPosDolar:= 0
	Local cCodPais := ""
	Local cDesPais := ""
	
	//Copia o arquivo do local informado para pasta do sistema Protheus
	If ":" $ M->ARQUIVO //Checa se não está na pasta do sistema (se não está, então contém ":")
		If !ExistDir(cDest)
			MakeDir(cDest)
		EndIf
		If File(cFDest)
			FErase(cDest+'/'+cFDest) // Se existir, apaga
		Endif
		If CpyT2S(M->ARQUIVO, cDest,.F.)
			M->ARQUIVO := cDest+'/'+cFDest
		EndIf
	Endif
		
	lGrava   := .T.
	cMsgErro := ""
	
	If fOpen(M->ARQUIVO,0) == -1
		If Empty(M->ARQUIVO)
			Aviso("Problema ao abrir arquivo", "Por favor, selecione um arquivo.", {"Fechar"}, 1)
		Else
			Aviso("Problema ao abrir arquivo", "O arquivo de nome " + M->ARQUIVO + " não pode ser aberto. Verifique os parâmetros.",;
				{"Fechar"}, 1)
		Endif
		Return
	Endif
	
	//Efetua abertura do arquivo XML
	oXML := XmlParserFile( M->ARQUIVO, "_", @cError, @cWarning )
	
	If !Empty(cError) //Caso tenha ocorrido erro:
		cMsgErr := cError
		Alert(cMsgErr)
		Return
	Else
		oButGrv:Enable()
		oButCad:Enable()
		oButPxF:Enable()
		oButPed:Enable()
		SetKey(115,{||Documentos(aCols[n,GDFieldPos("B1_COD")]) })
	EndIf

	If XmlChildEx(oXML,"_LISTADECLARACOES") != Nil
		lImport := .T.
		lGrava  := .F.
		If ValType(oXML:_ListaDeclaracoes:_declaracaoImportacao:_adicao) == "A"
			cFornDI := oXML:_ListaDeclaracoes:_declaracaoImportacao:_adicao[1]:_fornecedorNome:text
		ElseIf ValType(oXML:_ListaDeclaracoes:_declaracaoImportacao:_adicao) == "O"
			cFornDI := oXML:_ListaDeclaracoes:_declaracaoImportacao:_adicao:_fornecedorNome:text
		EndIf

		oButGrv:Disable()
		oButCad:Enable()
		oButPxF:Disable()
		oButPed:Disable()
		
		If SelFornImp(cFornDI)
			cCodFor  := SA2->A2_COD
			cLojFor  := SA2->A2_LOJA
			cNomFor  := SA2->A2_NOME
			cDtEmiss := dtoc(ddatabase)
			aCols    := {}	
			aAdicao  := oXML:_ListaDeclaracoes:_declaracaoImportacao:_adicao	

			nPsBruto := val(left(oXML:_ListaDeclaracoes:_declaracaoImportacao:_cargaPesoBruto:text,10)+"."+right(oXML:_ListaDeclaracoes:_declaracaoImportacao:_cargaPesoBruto:text,5))
			nPsLiqui := val(left(oXML:_ListaDeclaracoes:_declaracaoImportacao:_cargaPesoLiquido:text,10)+"."+right(oXML:_ListaDeclaracoes:_declaracaoImportacao:_cargaPesoLiquido:text,5))

			//taxa dolar
			//xdSearch := "DOLAR"
			If fwCodFil() == "01"
			xdSearch := FwNoAccent("TAXA DE CAMBIO")

			Else
			xdSearch := FwNoAccent("TAXA CAMBIAL")
			EndIf

			
			nPosDolar := At(xdSearch,FwNoAccent(UPPER(oXML:_ListaDeclaracoes:_declaracaoImportacao:_informacaoComplementar:TEXT)))

			if nPosDolar == 0 
				xdSearch := FwNoAccent("TAXA DO DOLAR")
			Endif
			nPosDolar := At(xdSearch,FwNoAccent(UPPER(oXML:_ListaDeclaracoes:_declaracaoImportacao:_informacaoComplementar:TEXT)))
			If nPosDolar > 0
			    nEndDolar := At(Chr(10),FwNoAccent(UPPER(oXML:_ListaDeclaracoes:_declaracaoImportacao:_informacaoComplementar:TEXT)), nPosDolar+len(xdSearch))
				If nEndDolar >  0
				   cDolar := Rtrim( SubStr(oXML:_ListaDeclaracoes:_declaracaoImportacao:_informacaoComplementar:TEXT,nPosDolar+len(xdSearch) , nEndDolar-nPosDolar-len(xdSearch)) )
				   cDolar := SubStr(cDolar,Rat(" ",cDolar) )
				Else
				   cDolar := Right(SubStr(oXML:_ListaDeclaracoes:_declaracaoImportacao:_informacaoComplementar:TEXT, nPosDolar, 14),7)
				EndIf
				cDolar := replace(cDolar,",",".")
				nTxDolar := Val(cDolar)
			EndIf
			cTxDolar := "Taxa do dólar: "+Transform(nTxDolar,"@E 999.999999")
			
			aDet := {}
			If ValType(aAdicao) == "O"  // Se tiver vários itens
				AAdd( aDet , aAdicao )
			Else
				aDet := aClone(aAdicao)
			Endif
			
			For nI := 1 to len(aDet)
				
				cCodPais := aDet[nI]:_paisAquisicaoMercadoriaCodigo:TEXT
				cDesPais := aDet[nI]:_paisAquisicaoMercadoriaNome:TEXT
				cDINumer := aDet[nI]:_numeroDI:TEXT
				aMercado := {}
				
				If ValType(aDet[nI]:_mercadoria) == "O"
					AAdd( aMercado , aDet[nI]:_mercadoria )
				Else
					aMercado := aClone(aDet[nI]:_mercadoria)
				Endif
				
				For nX := 1 To Len(aMercado)
					fItensDI(nX,;
						aMercado[nX]:_descricaoMercadoria:text,;
						aDet[nI]:_dadosMercadoriaCodigoNcm:text,;
						aMercado[nX]:_unidadeMedida:text,;
						val(left(aMercado[nX]:_quantidade:text,9)+"."+right(aMercado[nX]:_quantidade:text,5)),;
						val(left(aMercado[nX]:_valorUnitario:text,13)+"."+right(aMercado[nX]:_valorUnitario:text,7)),;
						cCodFor,;
						cLojFor,;
						nTxDolar ) 
				Next
			Next nI
			
			If fAllDIOK()
				oButGrv:Enable()
				oButCad:Disable()
			Endif
			
			RecLock("SA2", .F.)
				SA2->A2_NREDUZ  := SA2->A2_NOME
				SA2->A2_END     := 'ESTRANGEIRO'
				SA2->A2_BAIRRO  := 'ESTRANGEIRO'
				SA2->A2_EST     := 'EX'
				SA2->A2_MUN     := 'ESTRANGEIRO'
				SA2->A2_TIPO    := 'X'
				SA2->A2_PAIS    := cCodPais
				//SA2->A2_PAISDES := cDesPais
			MsUnlock()

		Else
			cCodFor  := Space(TamSx3("A2_COD")[1])
			cLojFor  := Space(TamSx3("A2_LOJA")[1])
			cNomFor  := Space(TamSx3("A2_NOME")[1])
			cDtEmiss := ""
		Endif

	ElseIf XmlChildEx(oXML,"_NFEPROC") != Nil
		// -------------------
		// Preenche Cabeçalho
		// -------------------
		cDoc     := Strzero(Val(oXML:_nfeproc:_nfe:_infnfe:_ide:_nnf:text)  ,Len(SF1->F1_DOC)) //Número do Doc (F1_DOC)
		cSerie   := PADR(AllTrim(oXML:_nfeproc:_nfe:_infnfe:_ide:_serie:text),Len(SF1->F1_SERIE)) //Série do Doc (F1_SERIE)
		cDtEmiss := dtoc(Stod(StrTran(substr(oXML:_nfeproc:_nfe:_infnfe:_ide:_dhEmi:text,1,10),"-",""))) //Data de Emissão (F1_EMISSAO)
		cNomFor  := PADR(AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_xnome:text),Len(SA2->A2_NOME))

		cChave   := AllTrim(oXML:_nfeproc:_protNfe:_infProt:_chNFe:TEXT) //Chave Doc (F1_CHVNFE)
		aCols    := {}	
		aDet     := oXML:_nfeproc:_nfe:_infnfe:_det //Detalhes da nota (produtos, etc)
		lImport  := .F.

		If XmlChildEx(oXML:_nfeproc:_nfe:_infnfe:_emit,"_CNPJ") != Nil
			cCgc := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_cnpj:text ) 
		ElseIf XmlChildEx(oXML:_nfeproc:_nfe:_infnfe:_emit,"_CPF") != Nil != Nil
			cCgc := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_cpf:text ) 
		EndIf
		//Checa existência ou não do Fornecedor
		If cTipo == 'N' .and. fExistForn( PADR( cCgc , Len(SA2->A2_CGC) ) , .F. )
			cCodFor := SA2->A2_COD
			cLojFor := SA2->A2_LOJA
		ElseIf cTipo == 'B' .and. fExistCli( PADR( cCgc , Len(SA2->A2_CGC) ) )
			cCodFor := SA1->A1_COD
			cLojFor := SA1->A1_LOJA
		Else
			cCodFor := ""
			cLojFor := ""
		Endif

		//Preenche o K com os detalhes dos produtos da NF
		If ValType(aDet) <> "O"  // Se tiver vários itens
			aEval( aDet , {|x| CriaNos(@x), fPreencItens(x,@cCodFor,@cLojFor, cNomFor) } )
		Else
			CriaNos(@aDet)
			fPreencItens(aDet,@cCodFor,@cLojFor, cNomFor)
		EndIf
		
		SA5->(dbSetOrder(14))
		For nX := 1 To Len(aCols)
			fCheckProd(nX) //Verifica se o produto corrente existe
		Next

		If fAllProdOK()
			//Busca no banco de dados pela nota fiscal representada pelo XML
			SF1->(dbSetOrder(1))
			If SF1->(dbSeek(XFILIAL("SF1")+cDoc+cSerie+cCodFor))
				lGrava   := .F.
				lNFCad   := .T.
				cMsgErro := cNotaErro
				
				Aviso("Atenção", cMsgErro, {"Fechar"}, 1 )
				
				oButGrv:Disable()
			Endif
		Endif	
	ElseIf XmlChildEx(oXML,"_CTEPROC") != Nil
		// -------------------
		// Preenche Cabeçalho
		// -------------------
		cDoc     := Strzero(Val(oXML:_cteproc:_cte:_infcte:_ide:_nct:text)  ,Len(SF1->F1_DOC)) //Número do Doc (F1_DOC)
		cSerie   := PADR(AllTrim(oXML:_cteproc:_cte:_infcte:_ide:_serie:text),Len(SF1->F1_SERIE)) //Série do Doc (F1_SERIE)
		cDtEmiss := dtoc(Stod(StrTran(substr(oXML:_cteproc:_cte:_infcte:_ide:_dhEmi:text,1,10),"-",""))) //Data de Emissão (F1_EMISSAO)
		cNomFor  := PADR(AllTrim(oXML:_cteproc:_cte:_infcte:_emit:_xnome:text),Len(SA2->A2_NOME))

		cChave   := AllTrim(oXML:_cteproc:_protCte:_infProt:_chCTe:TEXT) //Chave Doc (F1_CHVNFE)
		aCols    := {}	
		oDet     := oXML:_cteproc:_cte:_infcte 
		lImport  := .F.
		lCte     := .T.

		//Checa existência ou não do Fornecedor
		If fExistForn( PADR( AllTrim(oXML:_cteproc:_cte:_infcte:_emit:_cnpj:text ) , Len(SA2->A2_CGC) ) , .F. )
			cCodFor := SA2->A2_COD
			cLojFor := SA2->A2_LOJA
		Else
			cCodFor := ""
			cLojFor := ""
		Endif
		SB1->(DbSetOrder(1))
		fItensCTE(oDet,cCodFor,cLojFor,cNomFor)
		
		If fAllProdOK()
			//Busca no banco de dados pela nota fiscal representada pelo XML
			SF1->(dbSetOrder(1))
			If SF1->(dbSeek(XFILIAL("SF1")+cDoc+cSerie+cCodFor))
				lGrava   := .F.
				lNFCad   := .T.
				cMsgErro := cNotaErro
				
				Aviso("Atenção", cMsgErro, {"Fechar"}, 1 )
				
				oButGrv:Disable()
			Endif
		Endif

	Else
		MsgStop('Estrutura do xml não corresponde a NF-e, DI ou CTE.', 'Atenção')
		return
	EndIf	
	
	oDoc:Refresh()
	oDtEmiss:Refresh()
	oCodFor:Refresh()
	oNomFor:Refresh()
	oItens:Refresh()
	oMsgErro:Refresh()
	oTxDolar:Refresh()
	
	If Empty(cCodFor)
		lGrava:= .F.
		fErroForn()
	EndIf
	
	//Ativa o botão de gravação, caso não tenha ocorrido erro.
	If lGrava
		oButGrv:Enable()
	EndIf
	
Return

Static Function CriaNos(oDet)
	XmlNewNode(oDet:_prod,'_VDESC','VDESC','NOD')
	XmlNewNode(oDet,'_INFADPROD','INFADPROD','NOD')   
Return

/*/{Protheus.doc} fCheckProd
	Realiza todo o procedimento de checar se os produtos da NF já constam no sistema e, em caso negativo, oferece  opção de cadastrá-lo.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 14/07/2015
	@version 1.0
/*/
Static Function fCheckProd(nX)
	If fExistAmarr(nX)
		aCols[nX][1] := LoadBitmap( GetResources(), "BR_VERDE" )
		aCols[nX][nUsado+1] := .T.   // Flag de produto ok
	Endif
Return

/*/{Protheus.doc} fLimpaTela
	Limpa dados da tela.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 14/07/2015
	@version 1.0
/*/
Static Function fLimpaTela(nOp)
	Local nI
	Local lResposta := 1
	
	If nOp == 0
		lResposta := Aviso("Limpar tela", "A tela voltará para seu estado original. Prosseguir com ação?", {"Sim", "Não"}, 1)
	Endif
	
	If lResposta == 1
		aCols := {}
		
		//Cria casca do aCols vazio
		Aadd(aCols,Array(nUsado+2))
		For nI := 1 To nUsado
			aCols[1][nI] := CriaVar(aHeader[nI][2])
		Next
		
		//Esvazia campos da tela
		aCols[1][nUsado+1] := .F.  // Flag de produto ok
		aCols[1][nUsado+2] := .F.  // Flag de deleção
		
		cDoc       := ""
		cSerie     := ""
		cDtEmiss   := ""
		cCodFor    := ""
		cLojFor    := ""
		cNomFor    := ""
		cMsgErro   := ""
		cTxDolar   := ""
		M->ARQUIVO := Space(100)
		
		oButGrv:Disable()
		oButCad:Disable()
		oButPxF:Disable()
		oButPed:Disable()
		
		//Atualiza campos na tela
		oDoc:Refresh()
		oDtEmiss:Refresh()
		oCodFor:Refresh()
		oNomFor:Refresh()
		oItens:Refresh()
		oMsgErro:Refresh()
		oArquivo:Refresh()
		oTxDolar:Refresh()
	Endif
Return

/*/{Protheus.doc} fExistForn
	Verifica se já existe o fornecedor.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 13/07/2015
	@version 1.0
/*/
Static Function fExistForn(cChaveBusca,lImportacao)
	Default lImportacao := .F.

	if !lImportacao
		SA2->(dbSetOrder(3))
		lRet := SA2->(dbSeek(XFILIAL("SA2")+cChaveBusca))
	else
		SA2->(DbOrderNickName('impDi'))
		lRet := SA2->(dbSeek(XFILIAL("SA2")+cChaveBusca))
	endif

Return lRet

/*/{Protheus.doc} fExistCli
	Verifica se já existe o fornecedor.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 13/07/2015
	@version 1.0
/*/
Static Function fExistCli(cCNPJ)
	SA1->(dbSetOrder(3))
	lRet := SA1->(dbSeek(XFILIAL("SA1")+cCNPJ))
Return lRet

/*/{Protheus.doc} fIncluiForn
	Abre o rotina padrão de cadastro de fornecedor, caso o fornecedor exibido na nota não esteja cadastrado no sistema.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 13/07/2015
	@version 1.0
/*/
Static Function fIncluiForn()
	Local cFunBkp := FunName()

	SA2->(dbSetOrder(1))

	SetFunName("MATA020")
	FWExecView('Cadastro de Fornecedor', 'MATA020', MODEL_OPERATION_INSERT)
	SetFunName(cFunBkp)

Return

/*/{Protheus.doc} fIncluiCli
	Abre o rotina padrão de cadastro de fornecedor, caso o fornecedor exibido na nota não esteja cadastrado no sistema.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 13/07/2015
	@version 1.0
/*/
Static Function fIncluiCli()
	Local nOpc    := 0
	Local aAcho   := {}
	Local cTudoOk := ".T."
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	
	cCadastro := "Cadastro de Cliente - Importação de Arquivo XML"
	
	fAchaCampos("SA1",@aAcho,"")
	
	nOpc := AxInclui ("SA1", Recno(), 3,aAcho,"U_CrgSA1Cpo()",aAcho,cTudoOk,,,,)
	
	If nOpc <> 3 .And. nOpc <> 0
		fCarrArq()
	Else
		fErroForn()
	EndIf
Return

/*/{Protheus.doc} fExistAmarr
	Checa pela existência da amarração entre prod e forn.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 13/07/2015
	@version 1.0
/*/
Static Function fExistAmarr(nX)
	Local lRet := .F.
	
	If cTipo <> "B"         
		dbSelectArea("SA5")
		SA5->(dbSetOrder(14))
		lRet := dbSeek(xFilial("SA5")+cCodFor+cLojFor+aCols[nX][3])
		SA5->(DbCloseArea()) 
	Else
		SA7->(dbSetOrder(3))
		lRet := SA7->(dbSeek(xFilial("SA7")+cCodFor+cLojFor+aCols[nX][fGetIndice("A5_CODPRF", aHeader)]))
	EndIf 
	
Return lRet

/*/{Protheus.doc} fIncProd
	Realiza o processo de montagem de tela de cadastro de produto (traz os campos e monta a tela padrão AxInclui).
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 14/07/2015
	@version 1.0
/*/
Static Function fIncProd(cDescXml,cCodBarXml,cUnidXml,cNcm,cEAN)
	Local nOpc     := 0
	Local aAchoSB1 := {}
	Local cTudoOk  := ".T."
	
	Private aSb1Det := {cDescXml,cCodBarXml,cUnidXml,cNcm,cEAN}
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	
	cCadastro := "Cadastro de Produtos"
	
	//Traz os campos que serão exibidos e os coloca no vetor aAchoSB1
	fAchaCampos("SB1",@aAchoSB1,"")
	
	//Mostra tela de cadastro padrão no formato Enchoice
	nOpc := AxInclui("SB1", Recno(), 3,aAchoSB1,"U_CrgCpoSB1()",aAchoSB1,cTudoOk,,,,)
	
	//Retorna o Código do Produto cadastrado para o aCols e o atualiza, em seguida cria a amarração Prod x Forn (SA5).
	If nOpc <> 3 .And. nOpc <> 0
		aCols[n][fGetIndice("B1_COD"  ,aHeader)] := SB1->B1_COD
		aCols[n][fGetIndice("D1_LOCAL",aHeader)] := SB1->B1_LOCPAD
		oItens:Refresh()
		
		//Deixa a legenda verde (produto cadastrado)
		aCols[n][1] 			:= LoaDbitmap( GetResources(), "BR_VERDE" )
		aCols[n][nUsado+1]	:= .T.    // Flag de produto ok
		
		If fAllProdOK() .And. !lNFCad
			oButGrv:Enable()
		Endif
		
		//Cria a amarração Prod x Forn
		fIncAmarr(cCodFor,cLojFor,aCols[n][fGetIndice("B1_COD", aHeader)],aCols[n][fGetIndice("A5_CODPRF", aHeader)],cNomFor,aCols[n][fGetIndice("B1_DESC", aHeader)])
	Else
		//Caso não tenha cadastrado, já garante que não será possí­vel criar a pré-nota de entrada (SF1 e SD1)
		lGrava := .F.
	EndIf
	
Return

/*/{Protheus.doc} fAchaCampos
	Carrega todos os campos do dicionário de dados da tabela passada como parâmetro.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 14/07/2015
	@version 1.0
	@param cAliasParam, character, (Alias da tabela.)
	@param aAcho, array, (Array com o nome dos campos que serão exibidos na interface.(tela))
	@param aCpoXml, array, (Array com o nome dos campos que poderão ser editados.)
/*/
Static Function fAchaCampos(cAliasParam,aAcho,aCpoXml)
	SX3->(dbSetOrder(1))
	SX3->(dbSeek(cAliasParam,.T.))
	
	While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == cAliasParam
		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. !(Trim(SX3->X3_CAMPO) $ aCpoXml))
			AAdd( aAcho , Trim(SX3->X3_CAMPO) )
		Endif
		SX3->(dbSkip())
	Enddo
Return

/*/{Protheus.doc} CrgCpoSB1
	Pré-carrega alguns campos, diretamente do arquivo .xml, para ser utilizado pela Enchoice do AxInclui em questão.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 15/07/2015
	@version 1.0
/*/
User Function CrgCpoSB1()
	M->B1_DESC   := aSb1Det[1]	//cDescXml
	M->B1_CODBAR := aSb1Det[2]	//cCodBarXml
	M->B1_POSIPI := aSb1Det[4]	//cCodBarXml
	//M->B1_CODBAR :=
	
	If !Empty(ALLTRIM(aSb1Det[3]))
		M->B1_UM := ALLTRIM(aSb1Det[3])	//UnidXml
	Endif
Return

/*/{Protheus.doc} CrgSA5Cpo
	Pré-carrega alguns campos, diretamente do arquivo .xml, para ser utilizado pela Enchoice do AxInclui em questão.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 15/07/2015
	@version 1.0
/*/
User Function CrgSA5Cpo()
	M->A5_FORNECE := aSA5Det[1]
	M->A5_LOJA    := aSA5Det[2]
	M->A5_CODPRF  := aSA5Det[3]
	M->A5_NOMEFOR := SA2->A2_NOME
Return

/*/{Protheus.doc} CrgSA7Cpo
	Pré-carrega alguns campos, diretamente do arquivo .xml, para ser utilizado pela Enchoice do AxInclui em questão.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 15/07/2015
	@version 1.0
/*/
User Function CrgSA7Cpo()
	M->A7_CLIENTE	:= aSA5Det[1]
	M->A7_LOJA		:= aSA5Det[2]
	M->A7_CODCLI	:= aSA5Det[3]
Return

/*/{Protheus.doc} CrgSA2Cpo
	Pré-carrega alguns campos, diretamente do arquivo .xml, para ser utilizado pela Enchoice do AxInclui em questão.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 15/07/2015
	@version 1.0
/*/
User Function CrgSA2Cpo()
	M->A2_CGC    := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_cnpj:text)
	M->A2_NOME   := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_xnome:text)
	M->A2_END    := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_enderEmit:_xLgr:text + " "+oXML:_nfeproc:_nfe:_infnfe:_emit:_enderEmit:_nro:text)
	M->A2_BAIRRO := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_enderEmit:_xBairro:text)
	M->A2_NREDUZ := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_xnome:text)
	M->A2_CEP    := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_enderEmit:_CEP:text)
	M->A2_INSCR  := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_IE:text)
	M->A2_EST    := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_enderEmit:_UF:text)
	M->A2_MUN    := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_enderEmit:_xMun:text)
	
	CC2->(DbSetOrder(2))
	If CC2->(DbSeek(xFilial("CC2")+M->A2_MUN))
		M->A2_COD_MUN := CC2->CC2_CODMUN
	EndIf
	
Return

/*/{Protheus.doc} CrgSA1Cpo
	Pré-carrega alguns campos, diretamente do arquivo .xml, para ser utilizado pela Enchoice do AxInclui em questão.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 15/07/2015
	@version 1.0
/*/
User Function CrgSA1Cpo()
	M->A1_CGC    := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_cnpj:text)
	M->A1_NOME   := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_xnome:text)
	M->A1_END    := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_enderEmit:_xLgr:text + ", "+ oXML:_nfeproc:_nfe:_infnfe:_emit:_enderEmit:_nro:text)
	M->A1_BAIRRO := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_enderEmit:_xBairro:text)
	M->A1_NREDUZ := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_xnome:text)
	M->A1_CEP    := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_enderEmit:_CEP:text)
	M->A1_INSCR  := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_IE:text)
	M->A1_EST    := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_enderEmit:_UF:text)
	M->A1_MUN    := AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_enderEmit:_xMun:text)
	
	CC2->(DbSetOrder(2))
	
	If CC2->(DbSeek(xFilial("CC2")+M->A1_MUN))
		M->A1_COD_MUN  := CC2->CC2_CODMUN
	EndIf
Return

/*/{Protheus.doc} fPreencItens
	Carrega e valida os itens do XML.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 14/07/2015
	@version 1.0
	@param oDet, objeto, (Descrição do parâmetro)
	@param cCodFor, character, (Descrição do parâmetro)
	@param cLojFor, character, (Descrição do parâmetro)
/*/
Static Function fPreencItens(oDet,cCodFor,cLojFor, cNomeFor)
	Local nI, nJ   := Nil
	Local aItens   := {}
	Local aColsAux := Array(Len(aCampos)+2)
	
	/*
	Itens do corpo da NotaFiscal (aCols)
	*/
	Local cItem    := PADL(ALLTRIM(cValToChar(Val(oDet:_nItem:text))),4,"0") 
	Local cProdFor := PADR(AllTrim(oDet:_prod:_cprod:text),Len(SA5->A5_CODPRF))
	Local cProduto := Space(Len(SA5->A5_PRODUTO))
	Local cDesc    := PADR(AllTrim(oDet:_prod:_cprod:text)+" "+AllTrim(oDet:_prod:_xprod:text),Len(SB1->B1_DESC))
	Local cNCM_NF  := PADR(AllTrim(oDet:_prod:_ncm:text)  ,Len(SB1->B1_POSIPI))
	Local cEAN     := AllTrim(oDet:_prod:_cean:text)
	Local cST_PRO  := Space(Len(SB1->B1_CLASFIS))
	Local cUM      := PADR(AllTrim(oDet:_prod:_uCom:text) ,Len(SB1->B1_UM))
	Local cUMXML   := RTRIM(UPPER(AllTrim(oDet:_prod:_uCom:text)))
	Local cSEGUM   := PADR("" ,Len(SB1->B1_SEGUM))
	Local cPedido  := Space(Len(SD1->D1_PEDIDO))
	Local cItemPC  := Space(Len(SD1->D1_ITEMPC))
	Local cNCM_PRO := Space(Len(SB1->B1_POSIPI))
	Local cLocal   := ""  
	Local cNfori   := ""
	Local cSeriori := ""
	Local cItemori := "" 
	Local cIdentb6 := ""
	Local cDescri  := ""
	Local nQtd     := Val(oDet:_prod:_qcom:text)
	Local nQtdSeg  := 0
	Local nVunit   := Val(oDet:_prod:_vuncom:text)
	Local nPrcSeg  := 0
	Local nTotal   := Val(oDet:_prod:_vprod:text)
	Local nValDesc := Val(oDet:_prod:_vdesc:text)
	Local nIcmsSt  := 0
	Local nBCIcmsSt:= 0
	/*
	Fim do corpo da NotaFiscal (aCols)
	*/
	
	If XmlChildEx(oDet:_imposto:_icms,"_ICMS10") != Nil
		If XmlChildEx(oDet:_imposto:_icms:_icms10,"_VICMSST") != Nil
			nIcmsSt  := Val(oDet:_imposto:_icms:_icms10:_vICMSST:text)
		EndIf

		If XmlChildEx(oDet:_imposto:_icms:_icms10,"_VBCST") != Nil
			nBCIcmsSt  := Val(oDet:_imposto:_icms:_icms10:_vBCST:text)
		EndIf
	ElseIf XmlChildEx(oDet:_imposto:_icms,"_ICMS90") != Nil
		If XmlChildEx(oDet:_imposto:_icms:_icms90,"_VICMSST") != Nil
			nIcmsSt  := Val(oDet:_imposto:_icms:_icms90:_vICMSST:text)
		EndIf

		If XmlChildEx(oDet:_imposto:_icms:_icms90,"_VBCST") != Nil
			nBCIcmsSt  := Val(oDet:_imposto:_icms:_icms90:_vBCST:text)
		EndIf
	ElseIf XmlChildEx(oDet:_imposto:_icms,"_ICMS30") != Nil
		If XmlChildEx(oDet:_imposto:_icms:_icms30,"_VICMSST") != Nil
			nIcmsSt  := Val(oDet:_imposto:_icms:_icms30:_vICMSST:text)
		EndIf

		If XmlChildEx(oDet:_imposto:_icms:_icms30,"_VBCST") != Nil
			nBCIcmsSt  := Val(oDet:_imposto:_icms:_icms30:_vBCST:text)
		EndIf
	ElseIf XmlChildEx(oDet:_imposto:_icms,"_ICMSSN201") != Nil
		If XmlChildEx(oDet:_imposto:_icms:_ICMSSN201,"_VICMSST") != Nil
			nIcmsSt  := Val(oDet:_imposto:_icms:_ICMSSN201:_vICMSST:text)
		EndIf

		If XmlChildEx(oDet:_imposto:_icms:_ICMSSN201,"_VBCST") != Nil
			nBCIcmsSt  := Val(oDet:_imposto:_icms:_ICMSSN201:_vBCST:text)
		EndIf
	EndIf
	
	If cTipo == 'N' .and. AllTrim(oDet:_prod:_cfop:text) $ GetMv("MV_XCFIND",.F.,"5901")
		cTipo := "B"
		If fExistCli()
			cCodFor := SA1->A1_COD
			cLojFor := SA1->A1_LOJA
		EndIf
	EndIf
	
	//Verifica se existe a amarração entre Produto e o Fornecedor
	If cTipo <> "B" 
		
		SA5->(dbSetOrder(14))
		If SA5->(dbSeek(xFilial("SA5")+cCodFor+cLojFor+cProdFor))
			cProduto:= SA5->A5_PRODUTO
	   		
			//Verifica se existe o produto contido na amarração, caso exista, traz alguns dados desse produto
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(xFilial("SB1")+cProduto))
				cLocal   := SB1->B1_LOCPAD
				cNCM_PRO := SB1->B1_POSIPI
				cST_PRO  := SB1->B1_CLASFIS
				cUM      := SB1->B1_UM
				cSEGUM   := SB1->B1_SEGUM
				cTes	 := SB1->B1_TE
				cDescri  := SB1->B1_DESC
			EndIf

			aColsAux[Len(aColsAux)-1] := .T.    // Flag de produto ok
			AADD(aItens, {"B1_OK", LoadBitmap( GetResources(), "BR_VERDE" )})

			//se utiliza unidade de medida na sa5
			If SA5->(FieldPos("A5_XFATOR")) > 0
				While !SA5->(EOF()) .AND. SA5->(A5_FILIAL + A5_FORNECE + A5_LOJA + A5_CODPRF) == (xFilial("SA5")+cCodFor+cLojFor+cProdFor)
					If rtrim(cUMXML) == rtrim(SA5->A5_UNID)
						nQtd := if(SA5->A5_XTPCONV=="M",nQtd*SA5->A5_XFATOR,nQtd/SA5->A5_XFATOR)
						nVunit := nTotal / nQtd
					EndIf
					SA5->(DbSkip())
				Enddo
			EndIf
			
			nQtdSeg := if(SB1->B1_TIPCONV=="M",nQtd	* SB1->B1_CONV ,nQtd/SB1->B1_CONV ) 
		Else
			AADD(aItens, {"B1_OK", LoadBitmap( GetResources(), "BR_VERMELHO" )})
			aColsAux[Len(aColsAux)-1] := .F.    // Flag de produto ok
		EndIf
	Else
		SA7->(dbSetOrder(3)) //A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_CODCLI
		If SA7->(dbSeek(xFilial("SA7")+cCodFor+cLojFor+cProdFor))
			cProduto:= SA7->A7_PRODUTO
			
			//Verifica se existe o produto contido na amarração, caso exista, traz alguns dados desse produto
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(xFilial("SB1")+cProduto))
				cLocal   := SB1->B1_LOCPAD
				cNCM_PRO := SB1->B1_POSIPI
				cST_PRO  := SB1->B1_CLASFIS
				cUM      := SB1->B1_UM
				cSEGUM   := SB1->B1_SEGUM 
				cTes	 := SB1->B1_TE
				cDescri  := SB1->B1_DESC
				
			EndIf
			
			aColsAux[Len(aColsAux)-1] := .T.
			AADD(aItens, {"B1_OK", LoadBitmap( GetResources(), "BR_VERDE" )})
		Else
			AADD(aItens, {"B1_OK", LoadBitmap( GetResources(), "BR_VERMELHO" )})
			aColsAux[Len(aColsAux)-1] := .F.
		EndIf
	EndIf

	AADD(aItens, {"D1_ITEM"   , cItem})
	AADD(aItens, {"A5_CODPRF" , cProdFor})
	AADD(aItens, {"D1_COD"    , cProduto})
	AADD(aItens, {"B1_DESC"   , iif(!empty(cDesc),cDesc,cDescri)})
	AADD(aItens, {"B1_POSIPI" , cNCM_NF})
	AADD(aItens, {"CY_PENDEN" , "N"})
	AADD(aItens, {"D1_XUMXML" , cUMXML})
	AADD(aItens, {"D1_UM"     , cUM})
	AADD(aItens, {"D1_SEGUM"  , cSEGUM})
	AADD(aItens, {"D1_QUANT"  , nQtd})
	AADD(aItens, {"D1_XDESCRI", iif(!empty(cDesc),Left(cDesc,tamsx3("D1_XDESCRI")[1]),left(cDescri,tamsx3("D1_XDESCRI")[1]))})
	AADD(aItens, {"D1_QTSEGUM", nQtdSeg})
	AADD(aItens, {"D1_VUNIT"  , nVunit})
	AADD(aItens, {"D1_CUSFF2" , nPrcSeg})
	AADD(aItens, {"D1_FORNECE", cCodFor})
	AADD(aItens, {"D1_LOJA"   , cLojFor})
	AADD(aItens, {"D1_TOTAL"  , nTotal})
	AADD(aItens, {"D1_VALDESC", nValDesc})
	AADD(aItens, {"D1_ICMSRET", nIcmsSt})
	AADD(aItens, {"D1_BRICMS" , nBCIcmsSt})
	AADD(aItens, {"D1_LOCAL"  , cLocal})
	AADD(aItens, {"B1_VEREAN" , cEAN})
	AADD(aItens, {"D1_PEDIDO" , cPedido})
	AADD(aItens, {"D1_ITEMPC" , cItemPC})
	AADD(aItens, {"D1_NFORI"  , RIGHT(cNfori,9)})
	AADD(aItens, {"D1_SERIORI" , cSeriori})
	AADD(aItens, {"D1_ITEMORI" , cItemori})
	AADD(aItens, {"D1_IDENTB6" , cIdentb6})
	AADD(aItens, {"D1_XDESXML" , cDesc})
	AADD(aItens, {"D1_XUMXML"  , cUMXML})
	AADD(aItens, {"D1_XQTDXML" , nQtd})
	
	nTamItens  := Len(aItens)
	nTamCampos := Len(aCampos)
	
	//Faz a correspondência dos itens colhidos do XML com os campos que constam no aCols e gera um vetor correspondente para o aCols
	For nI := 1 To nTamItens
		For nJ := 1 To nTamCampos
			If aItens[nI][1] == aCampos[nJ][1]
				aColsAux[nJ] := aItens[nI][2]
			Endif
		Next nJ
	Next nI
	
	aColsAux[Len(aColsAux)] := .F.    // Flag de deleção
	
	AADD(aCols, aColsAux)
Return

/*/{Protheus.doc} fItensDI
	Carrega e valida os itens do XML de DI.
	@author matheus.vinicius
	@since 01/2023
	@version 1.0
	@param oDet, objeto, (Descrição do parâmetro)
	@param cCodFor, character, (Descrição do parâmetro)
	@param cLojFor, character, (Descrição do parâmetro)
/*/
Static Function fItensDI(nItem,cDescDI,cNcmDI,cUmDI,nQtdDI,nVUnitDi,cCodFor,cLojFor,nTxDolar)
	Local nI, nJ   := Nil
	Local aItens   := {}
	Local aColsAux := Array(Len(aCampos)+2)
	
	Local cItem    := PADL(ALLTRIM(cValToChar(nItem)),4,"0") 
	Local cProdFor := PADR(" ",Len(SA5->A5_CODPRF))
	Local cProduto := fPrdxFrnDI(cDescDI,cCodFor,cLojFor)
	Local cDesc    := PADR(cDescDI,Len(SB1->B1_DESC))
	Local cNCM_NF  := PADR(cNcmDI  ,Len(SB1->B1_POSIPI))
	Local cEAN     := Space(Len(SB1->B1_CODBAR))
	Local cUM      := PADR(" " ,Len(SB1->B1_UM))
	Local cUMXML   := RTRIM(UPPER(AllTrim(cUmDI)))
	Local cSEGUM   := PADR("" ,Len(SB1->B1_SEGUM))
	Local cPedido  := Space(Len(SD1->D1_PEDIDO))
	Local cItemPC  := Space(Len(SD1->D1_ITEMPC))
	Local cLocal   := ""  
	Local cNfori   := ""
	Local cSeriori := ""
	Local cItemori := "" 
	Local cIdentb6 := ""
	Local cDescri  := ""
	Local nQtd     := nQtdDI
	Local nQtdSeg  := 0
	Local nVunit   := nVUnitDi*nTxDolar
	Local nPrcSeg  := 0
	Local nTotal   := nQtdDI*nVunit
	Local nValDesc := 0
	Local nIcmsSt  := 0
	Local nBCIcmsSt:= 0
	
	if empty(cProduto)
		AADD(aItens, {"B1_OK", LoadBitmap( GetResources(), "BR_VERMELHO" )})
		aColsAux[Len(aColsAux)-1] := .F.    // Flag de produto ok
	else
		SB1->(DbSetOrder(1))
		if SB1->(dBsEEK(xFilial("SB1")+cProduto))
			cLocal  := SB1->B1_LOCPAD
			cUM     := SB1->B1_UM
			cSEGUM  := SB1->B1_SEGUM
			nQtdSeg := nQtd	* SB1->B1_CONV  // Flag de produto ok
			AADD(aItens, {"B1_OK", LoadBitmap( GetResources(), "BR_VERDE" )})
			aColsAux[Len(aColsAux)-1] := .T. 

			if "TONELADA" $ Upper(cUmDI) .and. SB1->B1_UM == "KG"
				nQtd := nQtdDI * 1000
				nVunit := nTotal / nQtd
			endif
		endif
	EndIf

	AADD(aItens, {"D1_ITEM"   	, cItem})
	AADD(aItens, {"A5_CODPRF" 	, cProdFor})
	AADD(aItens, {"D1_COD"    	, cProduto})
	AADD(aItens, {"B1_DESC"   	, iif(!empty(cDesc),cDesc,cDescri)})
	AADD(aItens, {"B1_POSIPI" 	, cNCM_NF})
	AADD(aItens, {"CY_PENDEN" 	, "N"})
	AADD(aItens, {"D1_UM"     	, cUM})
	AADD(aItens, {"D1_SEGUM"  	, cSEGUM})
	AADD(aItens, {"D1_QUANT"  	, nQtd})
	AADD(aItens, {"D1_XDESCRI" 	, iif(!empty(cDesc),Left(cDesc,tamsx3("D1_XDESCRI")[1]),left(cDescri,tamsx3("D1_XDESCRI")[1]))})
	AADD(aItens, {"D1_QTSEGUM"	, nQtdSeg})
	AADD(aItens, {"D1_VUNIT"  	, nVunit})
	AADD(aItens, {"D1_CUSFF2" 	, nPrcSeg})
	AADD(aItens, {"D1_FORNECE"	, cCodFor})
	AADD(aItens, {"D1_LOJA"   	, cLojFor})
	AADD(aItens, {"D1_TOTAL"  	, nTotal})
	AADD(aItens, {"D1_VALDESC"	, nValDesc})
	AADD(aItens, {"D1_ICMSRET"	, nIcmsSt})
	AADD(aItens, {"D1_BRICMS" 	, nBCIcmsSt})
	AADD(aItens, {"D1_LOCAL"  	, cLocal})
	AADD(aItens, {"B1_VEREAN" 	, cEAN})
	AADD(aItens, {"D1_PEDIDO" 	, cPedido})
	AADD(aItens, {"D1_ITEMPC" 	, cItemPC})
	AADD(aItens, {"D1_NFORI"  	, RIGHT(cNfori,9)})
	AADD(aItens, {"D1_SERIORI" 	, cSeriori})
	AADD(aItens, {"D1_ITEMORI" 	, cItemori})
	AADD(aItens, {"D1_IDENTB6" 	, cIdentb6})
	AADD(aItens, {"D1_XDESXML" 	, cDesc})
	AADD(aItens, {"D1_XUMXML"  	, cUMXML})
	AADD(aItens, {"D1_XQTDXML" 	, nQtd})
	
	nTamItens  := Len(aItens)
	nTamCampos := Len(aCampos)
	
	//Faz a correspondência dos itens colhidos do XML com os campos que constam no aCols e gera um vetor correspondente para o aCols
	For nI := 1 To nTamItens
		For nJ := 1 To nTamCampos
			If aItens[nI][1] == aCampos[nJ][1]
				aColsAux[nJ] := aItens[nI][2]
			Endif
		Next nJ
	Next nI
	
	aColsAux[Len(aColsAux)] := .F.    // Flag de deleção
	
	AADD(aCols, aColsAux)
	
	nTotMerc += nTotal
Return

/*/{Protheus.doc} fItensCTE
	Carrega e valida os itens do XML de CTE.
	@author matheus.vinicius
	@since 31/01/2023
	@version 1.0
	@param oDet, objeto, (Descrição do parâmetro)
	@param cCodFor, character, (Descrição do parâmetro)
	@param cLojFor, character, (Descrição do parâmetro)
/*/
Static Function fItensCTE(oDet,cCodFor,cLojFor,cNomeFor)
	Local nI, nJ   := Nil
	Local aItens   := {}
	Local aColsAux := Array(Len(aCampos)+2)
	Local cItem    := PADL("1",len(SD1->D1_ITEM),"0") 
	Local cProdFor := PADR(AllTrim(oDet:_ide:_CFOP:text),Len(SB1->B1_COD))
	Local cProduto := Space(Len(SA5->A5_PRODUTO))
	Local cDesc    := PADR(AllTrim(oDet:_ide:_natOp:text),Len(SB1->B1_DESC))
	Local cEAN     := ""
	Local cST_PRO  := Space(Len(SB1->B1_CLASFIS))
	Local cUM      := PADR("",Len(SB1->B1_UM))
	Local cUMXML   := PADR("",Len(SB1->B1_UM))
	Local cSEGUM   := PADR("",Len(SB1->B1_SEGUM))
	Local cPedido  := Space(Len(SD1->D1_PEDIDO))
	Local cItemPC  := Space(Len(SD1->D1_ITEMPC))
	Local cNCM_PRO := Space(Len(SB1->B1_POSIPI))
	Local cLocal   := ""  
	Local cNfori   := ""
	Local cSeriori := ""
	Local cItemori := "" 
	Local cIdentb6 := ""
	Local cDescri  := ""
	Local nQtd     := 1
	Local nQtdSeg  := 0
	Local nVunit   := Val(oDet:_vPrest:_vTPrest:text)
	Local nPrcSeg  := 0
	Local nTotal   := nVunit * nQtd
	Local nValDesc := 0
	Local nIcmsSt  := 0
	Local nBCIcmsSt:= 0

	//Verifica se existe o produto contido na amarração, caso exista, traz alguns dados desse produto
	SA5->(dbSetOrder(14))
	If SA5->(dbSeek(xFilial("SA5")+cCodFor+cLojFor+cProdFor))
		SB1->(DbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))
			cLocal   := SB1->B1_LOCPAD
			cNCM_PRO := SB1->B1_POSIPI
			cST_PRO  := SB1->B1_CLASFIS
			cUM      := SB1->B1_UM
			cSEGUM   := SB1->B1_SEGUM
			cTes	 := SB1->B1_TE
			cDescri  := SB1->B1_DESC
			cProduto := SB1->B1_COD

			aColsAux[Len(aColsAux)-1] := .T.    // Flag de produto ok
			AADD(aItens, {"B1_OK", LoadBitmap( GetResources(), "BR_VERDE" )})
		EndIf
	Else
		AADD(aItens, {"B1_OK", LoadBitmap( GetResources(), "BR_VERMELHO" )})
		aColsAux[Len(aColsAux)-1] := .F.    // Flag de produto ok
	EndIf
		
	AADD(aItens, {"D1_ITEM"   	, cItem})
	AADD(aItens, {"A5_CODPRF" 	, cProdFor})
	AADD(aItens, {"D1_COD"    	, cProduto})
	AADD(aItens, {"B1_DESC"   	, cDescri})
	AADD(aItens, {"B1_POSIPI" 	, cNCM_PRO})
	AADD(aItens, {"CY_PENDEN" 	, "N"})
	AADD(aItens, {"D1_XUMXML" 	, cUMXML})
	AADD(aItens, {"D1_UM"     	, cUM})
	AADD(aItens, {"D1_SEGUM"  	, cSEGUM})
	AADD(aItens, {"D1_QUANT"  	, nQtd})
	AADD(aItens, {"D1_XDESCRI" 	, iif(!empty(cDesc),Left(cDesc,tamsx3("D1_XDESCRI")[1]),left(cDescri,tamsx3("D1_XDESCRI")[1]))})
	AADD(aItens, {"D1_QTSEGUM"	, nQtdSeg})
	AADD(aItens, {"D1_VUNIT"  	, nVunit})
	AADD(aItens, {"D1_CUSFF2" 	, nPrcSeg})
	AADD(aItens, {"D1_FORNECE"	, cCodFor})
	AADD(aItens, {"D1_LOJA"   	, cLojFor})
	AADD(aItens, {"D1_TOTAL"  	, nTotal})
	AADD(aItens, {"D1_VALDESC"	, nValDesc})
	AADD(aItens, {"D1_ICMSRET"	, nIcmsSt})
	AADD(aItens, {"D1_BRICMS" 	, nBCIcmsSt})
	AADD(aItens, {"D1_LOCAL"  	, cLocal})
	AADD(aItens, {"B1_VEREAN" 	, cEAN})
	AADD(aItens, {"D1_PEDIDO" 	, cPedido})
	AADD(aItens, {"D1_ITEMPC" 	, cItemPC})
	AADD(aItens, {"D1_NFORI"  	, RIGHT(cNfori,9)})
	AADD(aItens, {"D1_SERIORI" 	, cSeriori})
	AADD(aItens, {"D1_ITEMORI" 	, cItemori})
	AADD(aItens, {"D1_IDENTB6" 	, cIdentb6})
	AADD(aItens, {"D1_XDESXML" 	, cDesc})
	AADD(aItens, {"D1_XUMXML"  	, cUMXML})
	AADD(aItens, {"D1_XQTDXML" 	, nQtd})
	
	nTamItens  := Len(aItens)
	nTamCampos := Len(aCampos)
	
	//Faz a correspondência dos itens colhidos do XML com os campos que constam no aCols e gera um vetor correspondente para o aCols
	For nI := 1 To nTamItens
		For nJ := 1 To nTamCampos
			If aItens[nI][1] == aCampos[nJ][1]
				aColsAux[nJ] := aItens[nI][2]
			Endif
		Next nJ
	Next nI
	
	aColsAux[Len(aColsAux)] := .F.    // Flag de deleção
	
	AADD(aCols, aColsAux)
Return

/*/{Protheus.doc} fAllProdOK
	Checa se todos os produtos estão cadastrados no sistema.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 03/08/2015
	@version 1.0
	@return ${lRet}, ${True, caso todos os produtos estejam cadastrados. False, caso contrário.}
/*/
Static Function fAllProdOK(lFinal)
	Local nI
	Local lRet    := .T.
	Local lPedido := .T.
	Local nTam    := Len(aCols)
	Local lSemPed := .F.
	
	If cTipo == 'B'
		//cCodFor	:= SA1->A1_COD
		//cLojFor	:= SA1->A1_LOJA
	//Else
	//	lSemPed := SA2->A2_XPEDIDO == "S"
	Endif

	If !lSemPed
		//Percorre aCols.. caso encontre alguma bolinha vermelha, atribui Falso.
		For nI := 1 To nTam
			If lRet := aCols[nI][nUsado+1]    // Flag de produto ok
				If lFinal .And. Empty(Alltrim(aCols[nI][fGetIndice("D1_PEDIDO",aHeader)]))
					lPedido := .F.
				EndIf
			Else
				cMsgErro := cProdErro
				Exit
			Endif
		Next nI
		
		If lRet
			cMsgErro := ""
		EndIf
		
	Endif
	
Return lRet

/*/{Protheus.doc} fGeraPreNota
	Função responsável por gravar a pré-nota de entrada (Tabelas 	SF1 e SD1).
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 21/07/2015
	@version 1.0
/*/
Static Function fGeraPreNota()
	Local nX, aLinha
	Local aItNFE := {}
	Local aCabec := {}
	//Local nTotal := 0
	Local nMaxIten := SuperGetMv("MV_XITDI",.F.,300)
	Local _adNotas := {}
	Local _anf := 0
	
	cMsgErro := ""
	If (fAllProdOK(.T.) .and. !lImport) .or. lImport
		
		IF lImport
			cSerie := GetMv("MV_XDISERI",.F.,'2')
			//cDoc := ProximoNumero(Padr(cSerie,tamsx3("F1_SERIE")[1]))
			//ProximoNumero(cSerie,cDoc)
			cDoc := NxtSx5Nota(cSerie, .T., GetNewPar("MV_TPNRNFS","1"))
		EndIf
       
		For nX:=1 To Len(aCols)
			aLinha := {}

			If nX == 01 .Or. Len(_adNotas[Len(_adNotas)][02]) > nMaxIten
				nY := 0
			   aAdd(_adNotas, {{},{}, "" } )
			   aAdd(_adNotas[Len(_adNotas)][01],{"F1_TIPO"   ,cTipo                   ,NIL} )
			   aAdd(_adNotas[Len(_adNotas)][01],{"F1_FORMUL" ,if(!lImport,"N","S")    ,NIL} )
			   aAdd(_adNotas[Len(_adNotas)][01],{"F1_DOC"    ,if(!lImport,"" ,cDoc)   ,NIL} )
			   aAdd(_adNotas[Len(_adNotas)][01],{"F1_SERIE"  ,cSerie        		  ,NIL} )
			   aAdd(_adNotas[Len(_adNotas)][01],{"F1_EMISSAO",cTod(cDtEmiss)		  ,NIL} )
			   aAdd(_adNotas[Len(_adNotas)][01],{"F1_FORNECE",cCodFor       		  ,NIL} )
			   aAdd(_adNotas[Len(_adNotas)][01],{"F1_LOJA"   ,cLojFor       		  ,NIL} )
			   aAdd(_adNotas[Len(_adNotas)][01],{"F1_ESPECIE",if(lCte,"CTE","SPED")	  ,NIL} )
			   aAdd(_adNotas[Len(_adNotas)][01],{"F1_CHVNFE" ,cChave        		  ,NIL} )
			   aAdd(_adNotas[Len(_adNotas)][01],{"F1_PESOL"  ,nPsLiqui        		  ,NIL} )
			   aAdd(_adNotas[Len(_adNotas)][01],{"F1_PLIQUI" ,nPsLiqui        		  ,NIL} )
			   aAdd(_adNotas[Len(_adNotas)][01],{"F1_PBRUTO" ,nPsBruto        		  ,NIL} )
			   aAdd(_adNotas[Len(_adNotas)][01],{"F1_COND"   ,"001"         	      ,NIL} )
			   aAdd(_adNotas[Len(_adNotas)][01],{"F1_XDI"    ,cDINumer         	      ,NIL} )
			EndIf
			
			//aAdd(aLinha, {"LINPOS"    ,aCols[nX][fGetIndice("D1_ITEM"   , aHeader)]		, NIL})	
			nY += 1  //Len(_adNotas[Len(_adNotas)][02])+1
			aAdd(aLinha, {"D1_ITEM"   ,PADL(ALLTRIM(cValToChar(nY)),4,"0")    		    , NIL})	
			aAdd(aLinha, {"D1_COD"    ,aCols[nX][fGetIndice("D1_COD"    , aHeader)]		, NIL})
			aAdd(aLinha, {"D1_XDESCRI",aCols[nX][fGetIndice("B1_DESC"   , aHeader)]		, NIL})
			aAdd(aLinha, {"D1_LOCAL"  ,aCols[nX][fGetIndice("D1_LOCAL"  , aHeader)]		, NIL})
			aAdd(aLinha, {"D1_UM"     ,aCols[nX][fGetIndice("D1_UM"     , aHeader)]		, NIL})
			aAdd(aLinha, {"D1_SEGUM"  ,aCols[nX][fGetIndice("D1_SEGUM"  , aHeader)]		, NIL})
			aAdd(aLinha, {"D1_QUANT"  ,aCols[nX][fGetIndice("D1_QUANT"  , aHeader)]		, NIL})
			aAdd(aLinha, {"D1_QTSEGUM",aCols[nX][fGetIndice("D1_QTSEGUM", aHeader)]		, NIL})
			aAdd(aLinha, {"D1_VUNIT"  ,aCols[nX][fGetIndice("D1_VUNIT"  , aHeader)]		, NIL})
			aAdd(aLinha, {"D1_FORNECE",cCodFor											, NIL})
			aAdd(aLinha, {"D1_LOJA"   ,cLojFor											, NIL})
			aAdd(aLinha, {"D1_TOTAL"  ,aCols[nX][fGetIndice("D1_TOTAL"  , aHeader)]		, NIL})
			aAdd(aLinha, {"D1_VALDESC",aCols[nX][fGetIndice("D1_VALDESC", aHeader)]		, NIL})

			//Se possui ICMS ST preenche os campos
			If aCols[nX][fGetIndice("D1_ICMSRET", aHeader)] > 0
				aAdd(aLinha, {"D1_VLSLXML" ,aCols[nX][fGetIndice("D1_ICMSRET" , aHeader)]		, NIL})
				aAdd(aLinha, {"D1_BRICMS"  ,aCols[nX][fGetIndice("D1_BRICMS" , aHeader)]		, NIL})
				aAdd(aLinha, {"D1_ICMSRET" ,aCols[nX][fGetIndice("D1_ICMSRET", aHeader)]		, NIL})	
				aAdd(aLinha, {"D1_ALQSOL"  ,aCols[nX][fGetIndice("D1_ICMSRET", aHeader)]/aCols[nX][fGetIndice("D1_BRICMS" , aHeader)]	, NIL})	
			EndIf
			
			If !Empty(Alltrim(aCols[nX][fGetIndice('D1_PEDIDO',aHeader)]))
				aAdd(aLinha, {"D1_PEDIDO",	aCols[nX][fGetIndice("D1_PEDIDO", aHeader)]	, NIL})
				aAdd(aLinha, {"D1_ITEMPC",	aCols[nX][fGetIndice("D1_ITEMPC", aHeader)]	, NIL})
			EndIf
			
			If !Empty(Alltrim(aCols[nX][fGetIndice('D1_NFORI',aHeader)]))
				aAdd(aLinha, {"D1_NFORI"  ,	aCols[nX][fGetIndice("D1_NFORI", aHeader)]		, NIL})
				aAdd(aLinha, {"D1_SERIORI",	aCols[nX][fGetIndice("D1_SERIORI", aHeader)]	, NIL})
				aAdd(aLinha, {"D1_ITEMORI",	aCols[nX][fGetIndice("D1_ITEMORI", aHeader)]	, NIL})
				aAdd(aLinha, {"D1_IDENTB6",	aCols[nX][fGetIndice("D1_IDENTB6", aHeader)]	, NIL})			
			EndIf	
			//nTotal += aCols[nX][fGetIndice("D1_TOTAL", aHeader)] - aCols[nX][fGetIndice("D1_VALDESC", aHeader)]
			aAdd(_adNotas[Len(_adNotas)][02], aLinha)
			//AADD(aItNFE,aLinha)
			//aAdd(aItem, {"LINPOS" , "D1_ITEM",  StrZero(nX,4)}) //ou SD1->D1_ITEM  se estiver posicionado.
		Next
		/*
		If !Duplicatas(nTotal)
			Return
		Endif
		*/
		Private lMsErroAuto := .F.
		
		Begin Transaction
		For _anf := 01 To Len(_adNotas)
			IF lImport
				cSerie := GetMv("MV_XDISERI",.F.,'2')
				//cDoc := ProximoNumero(Padr(cSerie,tamsx3("F1_SERIE")[1]))
				//ProximoNumero(cSerie,cDoc)
				cDoc := NxtSx5Nota(cSerie, .T., GetNewPar("MV_TPNRNFS","1"))
			EndIf
			aCabec := _adNotas[_anf][01]
			aItNFE := _adNotas[_anf][02]
			aCabec[03][02] := _adNotas[_anf][02] := cDoc
			lMsErroAuto := .F.
			MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItNFE, 3 /*Opção (Inclusão)*/)
			
			If lMsErroAuto
				MostraErro()
				DisarmTransaction()
				_anf := Len(_adNotas)
				Break
			EndIf
		Next
		End Transaction
		
		If !lMsErroAuto
			// Reclock("ZA1",.T.)
			// 	ZA1->ZA1_FILIAL  := xFilial("ZA1")
			// 	ZA1->ZA1_DOC     := cDoc
			// 	ZA1->ZA1_SERIE   := cSerie
			// 	ZA1->ZA1_FORNEC  := cCodFor
			// 	ZA1->ZA1_LOJA    := cLojFor
			// 	ZA1->ZA1_DI      := cDINumer
			// MsUnLock()r

			Aviso("Sucesso", "Pré-Nota de Entrada gerada com sucesso.",{"Fechar"}, 1)

			fLimpaTela(1)
		EndIf
	ElseIf !Empty(cMsgErro)
		Aviso("Impossí­vel gerar Pré-Nota", cMsgErro, {"Fechar"}, 1)
	Endif
Return

Static Function ProximoNumero(cSerie,cNumNF)
	Local cX5Descr := ''
	Local cQuery   := ""

	SX5->(dbSetOrder(1))
	If !SX5->(dbSeek(cFilAnt+"01"+cSerie))
		FwPutSX5(/*cFlavour*/, "01", cSerie, '', '', '')
	Endif

	// a funcao fwgetsx5 considera o compartilhamento da sx2 e nao o pe chgsx5fil
	// aContent := FWGetSX5( "01" )
	// nPos := Ascan(aContent, { |x| x[3] == cSerie })
	// If nPos  > 0
	// 	cX5Descr := aContent[nPos,4]
	// EndIf

	if Select("cAliasSX5") > 0
        cAliasSX5->(DbCloseArea())
    EndIF
    
	cQuery := " SELECT X5_FILIAL AS FILIAL,X5_CHAVE AS CHAVE,X5_DESCRI AS DESCRI"
    cQuery += " FROM " + RetSqlName("SX5")
    cQuery += " WHERE D_E_L_E_T_ = ''"    
    cQuery += "        AND X5_TABELA = '" + '01' + "'"
    cQuery += "        AND X5_CHAVE = '" + cSerie + "'"
    
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cAliasSX5",.T.,.T.)
    
	while ! cAliasSX5->(Eof())
        cX5Descr := cAliasSX5->DESCRI
        cAliasSX5->(DbSkip())
    end
    cAliasSX5->(DbCloseArea())

	If cNumNF == Nil    // Grava numeração
		// Pega o próximo número de nota fiscal
		If Empty(cX5Descr)
			cNumNF := StrZero(1,Len(SF2->F2_DOC))
		Else
			cNumNF := PADR(cX5Descr,Len(SF2->F2_DOC))
		Endif
		
		// Verifica se o número já não foi utilizado em uma nota de saí­da
		SF2->(dbSetOrder(1))
		While SF2->(dbSeek(XFILIAL("SF2")+cNumNF+cSerie))
			cNumNF := Soma1(cNumNF)
		Enddo
		
		// Verifica se o número já não foi utilizado em uma nota de entrada
		SF1->(dbSetOrder(1))
		If SF1->(dbSeek(XFILIAL("SF1")+cNumNF+cSerie))
			While !SF1->(EOF()) .AND. SF1->(F1_FILIAL+F1_DOC+F1_SERIE) == XFILIAL("SF1")+cNumNF+cSerie
				iF SF1->F1_FORMUL == "S"
					cNumNF := Soma1(cNumNF)
					SF1->(dbSeek(XFILIAL("SF1")+cNumNF+cSerie))
				eNDIF
			Enddo
		EndIf
	Else
		cNumNF := Soma1(cNumNF)

		cQuery := " UPDATE " + RetSqlName("SX5")
		cQuery += "    SET X5_DESCRI  = '" + cNumNF + "', "
		cQuery += "        X5_DESCSPA = '" + cNumNF + "', "
		cQuery += "        X5_DESCENG = '" + cNumNF + "' "
		cQuery += "  WHERE NVL(D_E_L_E_T_, ' ') = ' ' "
		cQuery += "    AND X5_TABELA = '01' "
		cQuery += "    AND X5_CHAVE  = '" + cSerie + "' "

		If TCSQLExec(cQuery) < 0
			MsgStop("[" + Dtoc(dDataBase) + " " + Time() + "] >>> Erro: " + TCSQLError(), "Atencao")
			Return .F.
		Endif
	Endif
	
Return cNumNF

/*/{Protheus.doc} fIncAmarr
	Função responsável por criar a amarração entre produto e fornecedor, logo após o cadastro do produto (Tabela SA5).
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 21/07/2015
	@version 1.0
	@param cCodFor, character, Código do Fornecedor
	@param cCodLoja, character, Código da Loja
	@param cCodProd, character, Código do Produto
	@param cCodPF, character, Código do Produto no Fornecedor
/*/
Static Function fIncAmarr(cCodFor, cLojFor, cCodProd, cCodPF, cNomeFor, cNomeProd)
	Local aCampAmarr := {}
	
	Private lMsErroAuto := .F.
	
	If cTipo <> "B"
		AADD(aCampAmarr, {"A5_FORNECE", PADR(cCodFor  ,TamSx3("A5_FORNECE")[1]),})
		AADD(aCampAmarr, {"A5_LOJA"   , PADR(cLojFor  ,TamSx3("A5_LOJA"   )[1]),})
		AADD(aCampAmarr, {"A5_NOMEFOR", PADR(cNomeFor ,TamSx3("A5_NOMEFOR")[1]),})
		AADD(aCampAmarr, {"A5_PRODUTO", PADR(cCodProd ,TamSx3("A5_PRODUTO")[1]),})
		AADD(aCampAmarr, {"A5_CODPRF" , PADR(cCodPF   ,TamSx3("A5_CODPRF" )[1]),})
		AADD(aCampAmarr, {"A5_NOMPROD", PADR(cNomeProd,TamSx3("A5_NOMPROD")[1]),})
		
		Begin Transaction
			MSExecAuto({|x,y| MATA061(x,y)}, aCampAmarr, 3)
		End Transaction
		
		If lMsErroAuto
			MostraErro()
		EndIf
	Else
		RecLock("SA7",.T.)
		SA7->A7_CLIENTE := cCodFor
		SA7->A7_LOJA    := cLojFor
		SA7->A7_PRODUTO := cCodProd
		SA7->A7_CODCLI  := cCodPF
		SA7->A7_DESCCLI := cNomeProd
		MsUnLock()
	EndIf
Return

/*/{Protheus.doc} fGetIndice
	Busca um determinado campo em um vetor cujos campos são gerados automaticamente e não possuem posição fixa.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 23/07/2015
	@version 1.0
	@param cNomeCampo, character, Campo a ser buscado
	@param aAlvo, array, Array contendo o campo a ser buscado
	@return ${nIndice}, ${Índice do campo cNomeCampo no array aAlvo}
/*/
Static Function fGetIndice(cNomeCampo, aAlvo)
	Local nIndice := 0
	
	If !Empty(aAlvo)
		For nIndice := 1 To Len(aAlvo)
			If ALLTRIM(aAlvo[nIndice][2]) == ALLTRIM(cNomeCampo)
				Exit
			Endif
		Next nIndice
	Else
		Aviso("Erro", "Array vazio.", {"Fechar"}, 1)
	Endif
	
Return nIndice

User Function fLinhaOK
Return .T.

User Function fTudoOK
Return .T.

/*/{Protheus.doc} fCadProd
	Ação do botão "Cadastrar produto". Checa se o produto está cadastrado, não está cadastrado ou é inválido.
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 27/07/2015
	@version 1.0
/*/
Static Function fCadProd()
	If !aCols[n, nUsado+1]    // Flag de produto ok
		cDescXml := aCols[n, fGetIndice("B1_DESC"  , aHeader)]
		cUnidXml := aCols[n, fGetIndice("D1_UM"    , aHeader)]
		cNcm     := aCols[n, fGetIndice("B1_POSIPI", aHeader)]
		cEAN	 :=aCols[n, fGetIndice("B1_VEREAN", aHeader)]
		
		SAH->(dbSetOrder(1))
		If SAH->(dbSeek(xFilial("SAH")+cUnidXml))
			fIncProd(cDescXml, cCodBarXml, cUnidXml,cNcm,cEan)
		Else
			fIncProd(cDescXml, cCodBarXml, )
		Endif
		
	Else
		Aviso("Impossí­vel cadastrar produto", "O produto " + CValToChar(n) + " já está cadastrado.", {"Fechar"}, 1)
	//Else
	//	Aviso("Impossí­vel cadastrar produto", "Produto inválido.", {"Fechar"}, 1)
	Endif
Return

/*/{Protheus.doc} fCadPxf
	Ação do botão "Cadastrar produto x Fornecedor". Checa se o produto está cadastrado, não está cadastrado ou é inválido.
	@author Jonathan Wermouth - jonathan.wermouth@totvs.com.br
	@since 25/11/2015
	@version 1.0
/*/
Static Function fCadPxf()
	Local nOpc     := 0
	Local aAchoSA5 := {}
	Local aAchoSA7 := {}
	Local cTudoOk  := ".T."
	
	Private aSA5Det := {cCodFor,cLojFor,aCols[n][fGetIndice("A5_CODPRF", aHeader)]}
	
	If !aCols[n, nUsado+1]
		
		If cTipo <> "B"
			SA5->(dbSetOrder(1))
			SA5->(dbgotop())
			
			cCadastro := "Cadastro de Produto x Fornecedor"
			
			//Traz os campos que serão exibidos e os coloca no vetor aAchoSA5
			fAchaCampos("SA5",@aAchoSA5,"")
			
			//Mostra tela de cadastro padrão no formato Enchoice
			nOpc := AxInclui ("SA5", Recno(), 3,aAchoSA5,"U_CrgSA5Cpo()",aAchoSA5,cTudoOk,,,,)
			
			SB1->(dbSetorder(1))
			SB1->(dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))
		Else
			SA7->(dbSetOrder(1))
			SA7->(dbgotop())
			
			cCadastro := "Cadastro de Produto x Cliente"
			
			//Traz os campos que serão exibidos e os coloca no vetor aAchoSA7
			fAchaCampos("SA7",@aAchoSA7,"")
			
			//Mostra tela de cadastro padrão no formato Enchoice
			nOpc := AxInclui ("SA7", Recno(), 3,aAchoSA7,"U_CrgSA7Cpo()",aAchoSA7,cTudoOk,,,,)
			SB1->(dbSetorder(1))
			SB1->(dbSeek(xFilial("SB1")+SA7->A7_PRODUTO))
		EndIf
		
		//Retorna o Código do Produto cadastrado para o aCols e o atualiza, em seguida cria a amarração Prod x Forn (SA5).
		If nOpc <> 3 .And. nOpc <> 0
			aCols[n][fGetIndice("B1_COD"  ,aHeader)] := SB1->B1_COD
			aCols[n][fGetIndice("D1_LOCAL",aHeader)] := SB1->B1_LOCPAD
			oItens:Refresh()
			
			//Deixa a legenda verde (produto cadastrado)
			aCols[n][1]        := LoaDbitmap( GetResources(), "BR_VERDE" )
			aCols[n][nUsado+1] := .T.
			
			If fAllProdOK() .And. !lNFCad
				oButGrv:Enable()
			Endif
		Else
			//Caso não tenha cadastrado, já garante que não será possí­vel criar a pré-nota de entrada (SF1 e SD1)
			lGrava := .F.
		EndIf
	Else
		Aviso("Impossível cadastrar produto", "O produto " + CValToChar(n) + " já está cadastrado.", {"Fechar"}, 1)
	//Else
	//	Aviso("Impossível cadastrar produto", "Produto inválido.", {"Fechar"}, 1)
	Endif
	
Return

Static Function fFechar()
	If Aviso("Confirmação", "Encerrar sessão?", {"Sim", "Não"}, 1) == 1
		fClose(M->ARQUIVO)
		oDlg:End()
	Endif
Return

/*/{Protheus.doc} fErroForn
	Procedimento realizado caso o Fornecedor não esteja cadastrado (desabilita cadastro de produto e 
	geração de pré-nota, além de mostrar
	erro).
	@author Everson Dantas - eversoncdantas@gmail.com
	@since 04/08/2015
	@version 1.0
/*/
Static Function fErroForn()
	cMsgErro := cFornErro
	oButGrv:Disable()
	oButCad:Disable()
	oButPxF:Disable()
	oButPed:Disable()
	SetKey(115,{||})
Return

/*/{Protheus.doc} Documentos
	Procedimento para pesquisar os pedido de compra pra vincular com os itens.
	@author Jonathan Wermouth - Jonathan.wermouth@totvs.com.br
	@since 25/11/2015
	@version 1.0
/*/
Static Function Documentos(cProduto)
	Local cQry
	Local aArea   := GetArea()
	Local lRet    := .F.
	Local cSC7Tmp := "SC7TMP"
	Local lTudo   := (cProduto == Nil)
	
	If lTudo
		cQry := "SELECT DISTINCT SC7.C7_NUM, SC7.C7_EMISSAO"
	Else
		cQry := "SELECT SC7.C7_NUM, SC7.C7_EMISSAO, SC7.C7_ITEM, SC7.C7_QUANT, SC7.C7_PRECO, SC7.C7_TOTAL, SC7.C7_QTDACLA"
	Endif
	
	cQry += " FROM " +RetSqlName("SC7") +" SC7"
	cQry += " WHERE SC7.D_E_L_E_T_ = ' '"
	cQry += " AND SC7.C7_FILIAL = '" +xFilial("SC7") + "'"
	cQry += " AND SC7.C7_FORNECE = '" +cCodFor + "'"
	cQry += " AND SC7.C7_LOJA = '" +cLojFor + "'"
	cQry += " AND (SC7.C7_QUANT - SC7.C7_QUJE - SC7.C7_QTDACLA) > 0"
	cQry += " AND SC7.C7_ENCER = ' '"
	cQry += " AND SC7.C7_RESIDUO <> 'S'"
	
	If SuperGetMV("MV_RESTNFE") == "S"
		cQry += " AND SC7.C7_CONAPRO <> 'B'"
	EndIf
	
	If !lTudo
		cQry += " AND SC7.C7_PRODUTO = '" +cProduto +"'"
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQry)),cSC7Tmp,.T.,.T.)
	
	(cSC7Tmp)->(dbGoTop())
	If (cSC7Tmp)->(!EOF())
		lRet := Pedidos(cProduto,lTudo,cSC7Tmp)
	Else
		Aviso("Atenção",("Não há pedidos de compra para o fornecedor do documento " +AllTrim(cDoc)+"/"+AllTrim(cSerie) +"."),{"OK"}) 
	EndIf
	(cSC7Tmp)->(dbCloseArea())
	
	RestArea(aArea)
	
Return lRet

/*/{Protheus.doc} Pedidos
	Cria tela para vincular os pedidos que foram encontrados.
	@author Jonathan Wermouth - jonathan.wermouth@totvs.com.br
	@since 25/11/2015
	@version 1.0
/*/
Static Function Pedidos(cProduto,lTudo,cSC7Tmp)
	Local lRet      := .F.
	Local oDlg      := NIL
	Local oBrowse   := NIL
	Local oOk       := LoadBitMap(GetResources(),"LBOK")
	Local oNo       := LoadBitMap(GetResources(),"LBNO")
	Local aPedidos  := {}
	Local aArea     := GetArea()
	Local aFields   := {}
	Local aSize     := MsAdvSize()
	Local nlTl1     := aSize[1]
	Local nlTl2     := aSize[2]
	Local nlTl3     := aSize[1]+300
	Local nlTl4     := aSize[2]+550
	Local nPPed     := GDFieldPos("D1_PEDIDO")
	Local nPIPC     := GDFieldPos("D1_ITEMPC")
	
	// Foi necessario criar essas variaveis para que fosse possivel usar a funcao padrao do sistema A120Pedido()
	Private INCLUI   := .F.
	Private ALTERA   := .F.
	Private nTipoPed := 1
	Private l120Auto := .F.
	
	If !lTudo
		aFields := { "", RetTitle("C7_NUM"), RetTitle("C7_ITEM"), RetTitle("C7_EMISSAO"), "Saldo"} //-- Saldo
		bLine := {|| {	If(aPedidos[oBrowse:nAt,1],oOk,oNo),;                            //-- Marca
							aPedidos[oBrowse:nAt,2],;                                        //-- Pedido
							aPedidos[oBrowse:nAt,3],;                                        //-- Item
							aPedidos[oBrowse:nAt,4],;                                        //-- Emissao
							Transform(aPedidos[oBrowse:nAt,5],PesqPict("SC7","C7_QUANT"))}}  //-- Saldo
			
		(cSC7Tmp)->(dbGoTop())
		While (cSC7Tmp)->(!EOF())
			aAdd(aPedidos, {.F.,;                               //-- Marca
								(cSC7Tmp)->C7_NUM,;                  //-- Pedido
								(cSC7Tmp)->C7_ITEM,;                 //-- Item
								StoD((cSC7Tmp)->C7_EMISSAO),;        //-- Emissao
								(cSC7Tmp)->(C7_QUANT - C7_QTDACLA),; //-- Saldo
								(cSC7Tmp)->C7_PRECO })               //-- Preco unitario
			
			//-- Se o pedido ja esta no aCols, marca como usado
			If !Empty(aCols[n,nPPed]) .And. aCols[n,nPPed] == (cSC7Tmp)->C7_NUM .And.;
				aCols[n,nPIPC] == (cSC7Tmp)->C7_ITEM
				aTail(aPedidos)[1] := .T.
			EndIf
			
			(cSC7Tmp)->(dbSkip())
		EndDo
		
	Else
		aFields := { "", RetTitle("C7_NUM"), RetTitle("C7_EMISSAO")}
		bLine := {|| {	If(aPedidos[oBrowse:nAt,1],oOk,oNo),; //-- Marca
							aPedidos[oBrowse:nAt,2],;             //-- Pedido
							aPedidos[oBrowse:nAt,3] } }           //-- Emissao
		
		(cSC7Tmp)->(dbGoTop())
		While (cSC7Tmp)->(!EOF())
			aAdd(aPedidos, {.F.,;                             //-- Marca
								(cSC7Tmp)->C7_NUM,;                //-- Pedido
								StoD((cSC7Tmp)->C7_EMISSAO) })     //-- Emissao
			
			//-- Se o pedido ja esta no aCols, marca como usado
			If !Empty(aCols[n,nPPed]) .And. aCols[n,nPPed] == (cSC7Tmp)->C7_NUM
				aTail(aPedidos)[1] := .T.
			EndIf
			
			(cSC7Tmp)->(dbSkip())
		EndDo
	EndIf
	
	cCadastro := "Ví­nculo com Pedido de Compra"
	
	//-- Monta interface para selecao do pedido
	Define MsDialog oDlg Title cCadastro From nlTl1,nlTl2 To nlTl3,nlTl4 Pixel //-- Ví­nculo com Pedido de Compra
	
	//-- Cabecalho
	@(nlTl1+10),nlTl2-15 To (nlTl1+22),(nlTl2+240) Pixel Of oDlg
	
	If !lTudo
		@(nlTl1+12),(nlTl2-10) Say "Doc " +cDoc +" - Item" +AllTrim(aCols[n,GDFieldPos("D1_ITEM")]) +" / " +AllTrim(cProduto) + " - " + Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC") Pixel Of oDlg 
	Else
		@(nlTl1+12),(nlTl2-10) Say "Doc " +cDoc +" - Fornecedor" +cCodFor +"/" +cLojFor +" - " +Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_NOME") Pixel Of oDlg 
	EndIf
	
	//-- Itens
	oBrowse := TCBrowse():New(nlTl1+30,nlTl2-20,nlTl4-315,nlTl3-200,,aFields,,oDlg,,,,,{|| MarcaPC(@aPedidos,oBrowse:nAt,lTudo),oBrowse:Refresh()},,,,,,,,,.T.)
	oBrowse:SetArray(aPedidos)
	oBrowse:bLine := bLine
	
	//-- Botoes
	TButton():New(nlTl1+134,nlTl2+3,"Visualizar pedido",oDlg,{|| MsgRun("Carregando visualização do pedido" +AllTrim(aPedidos[oBrowse:nAt,2]) +"..."," Aguarde", {|| A120Pedido("SC7",GetC7Recno(aPedidos[oBrowse:nAt,2]),2)})},055,012,,,,.T.) //-- Visualizar pedido # Carregando visualização do pedido
	
	Define SButton From nlTl1+134,nlTl2+177 Type 1 Action Eval({|| If(lRet := ValidPC(lTudo,aPedidos),oDlg:End(),)}) Enable Of oDlg
	Define SButton From nlTl1+134,nlTl2+212 Type 2 Action oDlg:End() Enable Of oDlg
	
	Activate Dialog oDlg Centered
	
	RestArea(aArea)
	
Return lRet

/*/{Protheus.doc} MarcaPC
 	Executada quando o registro e marcado para desmarcar os demais.
	@author Jonathan Wermouth - jonathan.wermouth@totvs.com.br
	@since 25/11/2015
	@version 1.0
/*/
Static Function MarcaPC(aPedidos,nLinha,lTudo)
	Local nDesmarca := 0
	
	//-- Desmarca o item que ja estava marcado
	If !lTudo
		nDesmarca := aScan(aPedidos,{|x| x[1]})
		If nDesmarca == nLinha
			nDesmarca := aScan(aPedidos,{|x| x[1]},nLinha+1)
		EndIf
		If !Empty(nDesmarca)
			aPedidos[nDesmarca,1] := .F.
		EndIf
	EndIf
	
	aPedidos[nLinha,1] := !aPedidos[nLinha,1]
	
Return  

/*/{Protheus.doc} ValidPC
	Validacao dos campos qtde e preco Unit. do pedido de compra com o documento NFe.	
	@author Jonathan Wermouth - jonathan.wermouth@totvs.com.br
	@since 25/11/2015
	@version 1.0
/*/
Static Function ValidPC(lTudo,aPedidos)	
	Local nX, nY, cSeek, lAchou, cPAnt, cIAnt
	Local aArea	:= GetArea()
	Local nPPrd := GDFieldPos("B1_COD")
	Local nPQtd := GDFieldPos("D1_QUANT")
	Local nPPed := GDFieldPos("D1_PEDIDO")
	Local nPIPC := GDFieldPos("D1_ITEMPC")
	Local nIni  := If( lTudo , 1, n)
	Local nFim  := If( lTudo , Len(aCols), n)
	Local lRet  := .T.
	
	SC7->(dbSetOrder(2))
	
	If lTudo
		aEval( aCols , {|x| x[nPPed] := CriaVar("D1_PEDIDO",.F.), x[nPIPC] := CriaVar("D1_ITEMPC",.F.) } )   // Limpa os campos antes de todos os itens
	EndIf
	
	For nX := 1 To Len(aPedidos)
		
		If !aPedidos[nX,1] //-- Ignora os itens não selecionados
			Loop
		Endif
		
		For nY:=nIni To nFim
			
			If lTudo .And. !Empty(aCols[nY,nPPed])   // Se já foi vinculado
				Loop
			Endif
			
			cPAnt  := aCols[nY,nPPed]
			cIAnt  := aCols[nY,nPIPC]
			lAchou := .F.
			cSeek  := xFilial("SC7")+aCols[nY,nPPrd]+cCodFor+cLojFor+aPedidos[nX,2]
			
			SC7->(dbSeek(cSeek,.T.))
			While !SC7->(Eof()) .And. SC7->(C7_FILIAL+C7_PRODUTO+C7_FORNECE+C7_LOJA+C7_NUM) == cSeek
				
				If aCols[nY,nPQtd] <= SC7->C7_QUANT
					aCols[nY,nPPed] := SC7->C7_NUM
					aCols[nY,nPIPC] := SC7->C7_ITEM
					lAchou := .T.
					Exit
				ElseIf !lInforma
					AVISO("Atenção","Para os itens do pedido com quantidade inferior aos itens correspondentes da nota utilize a opção de ví­nculo por Item.",{"OK"})
					lInforma := .T.
				EndIf
				
				SC7->(dbSkip())
			Enddo
		Next nY
		
	Next nX

	RestArea(aArea)

	if lRet
		MSGINFO( 'Pedido vinculado com sucesso! Confira na grid para mais detalhes.', 'Atenção' )
	endif
Return lRet
*/

/*/{Protheus.doc} GetC7Recno
	Funcao para retornar o recno do pedido.	
	@author Jonathan Wermouth - jonathan.wermouth@totvs.com.br
	@since 25/11/2015
	@version 1.0
/*/
Static Function GetC7Recno(cPedido)
	Local nRet := 0
		
	SC7->(dbSetOrder(1))
	If SC7->(dbSeek(xFilial("SC7")+cPedido))
		nRet := SC7->(Recno())
	EndIf

Return nRet

User Function COMP01Valid()
	Local nX, nPPrd, nPSel, nPQtd, nPQtS, nPPrc, nPPrS, nPDel, nPVal
	Local cVar  := ReadVar()
	Local lRet  := .T.
	
	If cVar == "M->E1_VENCTO"
	ElseIf cVar == "M->E1_VALOR"
		nPDel := Len(oGet:aCols[1])
		nPVal := AScan( oGet:aHeader , {|x| Trim(x[2]) == "E1_VALOR" } )
		
		If lRet := Positivo()
			nTotal := M->E1_VALOR
			For nX:=1 To Len(oGet:aCols)
				If nX <> n .And. !oGet:aCols[nX,nPDel]
					nTotal += oGet:aCols[nX,nPVal]
				Endif
			Next
			oTot:Refresh()
		Endif
	ElseIf cVar == "M->CY_PENDEN"
		nPPrd := AScan( aHeader , {|x| Trim(x[2]) == "B1_COD"     } )
		nPSel := AScan( aHeader , {|x| Trim(x[2]) == "CY_PENDEN"  } )
		nPQtd := AScan( aHeader , {|x| Trim(x[2]) == "D1_QUANT"   } )
		nPQtS := AScan( aHeader , {|x| Trim(x[2]) == "D1_QTSEGUM" } )
		nPPrc := AScan( aHeader , {|x| Trim(x[2]) == "D1_VUNIT"   } )
		nPPrS := AScan( aHeader , {|x| Trim(x[2]) == "D1_CUSFF2"  } )
		nPTot := AScan( aHeader , {|x| Trim(x[2]) == "D1_TOTAL"   } )
		
		// Posiciona no cadastro do produto
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(XFILIAL("SB1")+aCols[n,nPPrd]))
		
		Calc2aUM(n,nPSel,nPPrd,nPQtS,nPQtd,nPPrS,nPPrc,nPTot)
		
		If n < Len(aCols) .And. MsgYesNo("Replica essa informação para os itens baixo ?","ESCOLHA")
			For nX:=n+1 To Len(aCols)
				Calc2aUM(nX,nPSel,nPPrd,nPQtS,nPQtd,nPPrS,nPPrc,nPTot)
			Next
		Endif
	Endif
	
Return lRet

Static Function Calc2aUM(nPos,nPSel,nPPrd,nPQtS,nPQtd,nPPrS,nPPrc,nPTot)
	Local nAux := n
	
	n := nPos
	
	If aCols[n,nPSel] <> M->CY_PENDEN
		If M->CY_PENDEN == "S"
			aCols[n,nPQtS] := aCols[n,nPQtd]
			aCols[n,nPQtd] := ConvUM(aCols[n,nPPrd],0,aCols[n,nPQtd],1)
			aCols[n,nPPrS] := aCols[n,nPPrc]
			aCols[n,nPPrc] := Round(aCols[n,nPTot] / aCols[n,nPQtd],2)
		Else
			aCols[n,nPQtd] := aCols[n,nPQtS]
			aCols[n,nPQtS] := 0
			aCols[n,nPPrc] := aCols[n,nPPrS]
			aCols[n,nPPrS] := 0
		Endif
		
		aCols[n,nPSel] := M->CY_PENDEN
	Endif
	
	n := nAux
	
Return

User Function COMP01Del()
	Local nX
	Local nPDel := Len(oGet:aCols[1])
	Local nPVal := AScan( oGet:aHeader , {|x| Trim(x[2]) == "E1_VALOR" } )
	
	nTotal := If( oGet:aCols[n,nPDel] , oGet:aCols[n,nPVal], 0)
	For nX:=1 To Len(oGet:aCols)
		If nX <> n .And. !oGet:aCols[nX,nPDel]
			nTotal += oGet:aCols[nX,nPVal]
		Endif
	Next
	oTot:Refresh()
	
Return .T.

Static Function GetSB6(cNota,cSerie,cForn,cLoja,cCod,cOpc,nQtd)

	Local nValor
	Local cFil := FWFilial()
	Local cQuery1 := "" 
        

	cQuery1	:= " SELECT D2_FILIAL, D2_ITEM, D2_COD, D2_PRCVEN, D2_DOC, D2_SERIE, D2_IDENTB6, B6_SALDO FROM SD2010 SD2
	cQuery1 += " INNER JOIN SB6010 SB6 ON B6_FILIAL = D2_FILIAL AND B6_PRODUTO = D2_COD AND B6_LOCAL = D2_LOCAL "
	cQuery1 += " AND B6_IDENT = D2_IDENTB6 AND B6_DOC = D2_DOC  AND B6_SERIE = D2_SERIE AND SB6.D_E_L_E_T_ = ' '"
	cQuery1 += " WHERE SD2. D_E_L_E_T_ = ' ' " 
	cQuery1 += " AND D2_DOC =  '"+ALLTRIM(cNota)+"' "
	cQuery1 += " AND D2_SERIE =  '"+ALLTRIM(cSerie)+"'" 
	cQuery1 += " AND D2_FILIAL =  '"+ALLTRIM(cFil)+"' "
	cQuery1 += " AND D2_COD =  '"+ALLTRIM(cCod)+"' "
	cQuery1 += " AND D2_CLIENTE =  '"+ALLTRIM(cForn)+"' "
	cQuery1 += " AND D2_LOJA =  '"+ALLTRIM(cLoja)+"' "
	cQuery1 += " AND B6_SALDO >=  "+cValToChar(nQtd)
	cQuery1 += " ORDER BY D2_IDENTB6 " 
  		
	If Select("TMPSB6") > 0
		TMPSB6->(DbCloseArea())
	EndIF
  			
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery1), "TMPSB6", .F., .T.) 
	TMPSB6->(DbGoTop())
			
	If cOpc == "1"				
		cRet := TMPSB6->D2_ITEM+"/"+TMPSB6->D2_IDENTB6
	EndIf 
	
	If cOpc == "2"				
		nValor := TMPSB6->D2_PRCVEN
		Return nValor
	EndIf				      
Return cRet
 
User Function BJForImp(cFornDI)
Return SelFornImp(cFornDI)

/*/{Protheus.doc} SelFornImp
    Tela para seleçao dos CE's a serem faturados.
    @type  Function
    @author matheus.vinicius
    @since 25/11/2022
    @version version    
/*/
Static Function SelFornImp(cFornDI)
	Local cVar      := Nil
	Local cTitulo   := 'Selecione o fornecedor a ser utilizado'
	Local aString   := {}
	Local nI        := Nil
	Local lRet      := .F.
	
	//define posicao das colunas
	Local aHeadCli  := {" ","Cod", "Razão Social" ,"Endereco","País","Reg.Interno"}

	//variaveis utilizadas pelo listbox
	Local oDlg      := Nil
	Local oLbx      := Nil
	Local aVetor    := {{Nil,Nil,Nil,Nil,Nil,Nil}}
	Local nTotItens := 0

	//variaves posicao de campos
	Local nPosRec   := 6
	Local nPosSel   := 1

    //Variáveis Parâmetros
	Local cNomeCli  := ""

	If !empty(cFornDI)
        aString := strtokarr (cFornDI, " ")
        For nI := 1 to len(aString)
            if trim(aString[nI]) <> "%"
                cNomeCli += "%"+rtrim(aString[nI])+""
            endif
        Next nI   
	Else
		cNomeCli  := Space(TamSx3("A2_NOME")[1]) 
    EndIf

	DEFINE FONT oFnt3 NAME "Arial" BOLD
	DEFINE FONT oFont NAME "Arial" SIZE 0, -9 BOLD
	DEFINE MSDIALOG oDlg TITLE cTitulo  From 5,15 To 40,135 OF oMainWnd

		oGrp1Fld1  := TGroup():New(040,005 ,070,170, 'Pesquisar Razão Social',oDlg ,,,.T.)
        @ 055,008 MSGET cNomeCli  /*F3 "SC5"*/ Picture PesqPict("SA2","A2_NOME") When(.T.) SIZE 125,9 OF oDlg PIXEL
       
		oOrdNome   := TButton():New(055, 135, "Pesquisar"  , oDlg, {|| ListaSA1(@aVetor,cNomeCli,@oLbx)}, 030, 010, , oFont, , .T., , , , , , )

		@ 075,05 LISTBOX oLbx VAR cVar FIELDS HEADER aHeadCli[1],aHeadCli[2],aHeadCli[3],aHeadCli[4],aHeadCli[5],aHeadCli[6] SIZE 465,160 OF oDlg PIXEL ON CHANGE .T. ON dblClick( Seleciona(oLbx:nAt,@aVetor,@oLbx,nPosSel,@nTotItens) )
		
		ListaSA1(@aVetor,cNomeCli,@oLbx)
		
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| IIf(ValidMarK(@aVetor,nPosRec,nPosSel),( lRet := .T.,oDlg:End() ),oDlg:End() )},{||oDlg:End()}) CENTERED

Return lRet

/*/{Protheus.doc} ListaSA1
    Retorna os CEÂ´S encerrados
    @type  Function
    @author matheus.vinicius
    @since 25/11/2022
    @version version    
/*/
Static Function ListaSA1(aVetor,cDescricao,oLbx)
	Local aString := {}
	Local nI      := Nil
	Local cWhere  := "% SA2.D_E_L_E_T_ = '' "

	If !empty(cDescricao)
        aString := strtokarr (cDescricao, "%")
        For nI := 1 to len(aString)
            if trim(aString[nI]) <> "%"
                cWhere += " AND A2_NOME LIKE '%"+rtrim(aString[nI])+"%'"
            endif
        Next nI    
    EndIf
	cWhere += "%"
   
    BeginSql Alias "QRY"
        SELECT *
		FROM  %TABLE:SA2% SA2 
        WHERE %Exp:cWhere%
    EndSql
	
	aVetor    := {}

	If QRY->(EOF())
		aVetor := {{Nil,Nil,Nil,Nil,Nil,Nil}}
        MsgInfo("Nenhum FORNECEDOR encontrado para os parâmetros informados.", "Atenção")
	Else
		While !QRY->(Eof())
			
			//{" ","Cod", "Razão Social" ,"Endereco","Paí­s","Reg.Interno"}
			aAdd( aVetor , {.F.,;
							QRY->A2_COD+QRY->A2_LOJA,;
							QRY->A2_NOME,;
							QRY->A2_END,;
							QRY->A2_PAIS,;
                            QRY->R_E_C_N_O_})	
     			
			QRY->(DbSkip())
		
		Enddo
	EndIf

	QRY->(DbCloseArea())
    oLbx:SetArray( aVetor )
    oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,01],LoadBitmap( GetResources(), "LBOK" ),LoadBitmap( GetResources(), "LBNO" )),;
		aVetor[oLbx:nAt,02],; 
		aVetor[oLbx:nAt,03],;
		aVetor[oLbx:nAt,04],;
		aVetor[oLbx:nAt,05],;
		aVetor[oLbx:nAt,06]}}
    oLbx:Refresh()

Return

Static Function fPrdxFrnDI(cDescDI,cCodFor,cLojFor)
	Local cRet    := PADR(" ",Len(SA5->A5_CODPRF))
	//Local aDescri := strtokarr (cDescDI, "-")
	//Local cNoEspc := aDescri[len(aDescri)]
	Local cWhere  := "% SB1.D_E_L_E_T_ = '' "
	//Local aString := {}
	//Local nI      := Nil
	Local aVetor  := {}
	Local cxPrd   := alltrim(left(cDescDI,len(cDescDI)-1))
	
	//adson
	If fwCodFil() == "01"
		cxProd := alltrim( substr(cxPrd,RAt(" ",cxPrd),9) ) //ULTIMA EXPRESSAO
	Else
		cxProd := alltrim( substr(cxPrd,At(" ",cxPrd),9) ) //PRIMEIRA EXPRESSAO
	Endif
	
	cDescDI := REPLACE(CDESCDI," ","")
	cDescDI := REPLACE(CDESCDI,char(13),"")
	//cWhere += " AND ( B1_COD = '"+Right( cDescDI ,8)+"'"
	cWhere += " AND ( B1_COD = '"+ cxProd +"'"
	cWhere += ")%"

	BeginSql Alias "QRY"
        SELECT *
		FROM  %TABLE:SB1% SB1 
        WHERE %Exp:cWhere% AND B1_FILIAL = %EXp:xFilial("SB1")%
    EndSql

	If !QRY->(EOF())
		aAdd( aVetor , {.F.,;
						QRY->B1_COD,;
						QRY->B1_DESC,;
						QRY->B1_UM,;
						QRY->B1_POSIPI,;
						QRY->R_E_C_N_O_})	
	EndIf
	QRY->(DbCloseArea())

	if len(aVetor) > 1
		cRet := SelProdImp(cDescDI,aVetor)
	elseiF len(aVetor) == 1
		cRet := aVetor[1,2]
	endif

Return cRet

/*/{Protheus.doc} SelProdImp
    Tela para seleçao dos CE's a serem faturados.
    @type  Function
    @author matheus.vinicius
    @since 25/11/2022
    @version version    
/*/
Static Function SelProdImp(cDescri,aVetor)
	Local cVar      := Nil
	Local cTitulo   := 'Selecione o produto a ser utilizado.'
	Local cRet      := PADR(" ",Len(SA5->A5_CODPRF))
	
	//define posicao das colunas
	Local aHeadCli  := {" ","Cod", "Razão Social" ,"Endereco","Paí­s","Reg.Interno"}

	//variaveis utilizadas pelo listbox
	Local oDlg      := Nil
	Local oLbx      := Nil
	Local nTotItens := 0

	DEFINE FONT oFnt3 NAME "Arial" BOLD
	DEFINE FONT oFont NAME "Arial" SIZE 0, -9 BOLD
	DEFINE MSDIALOG oDlg TITLE cTitulo  From 5,15 To 40,135 OF oMainWnd
	
		oSayDescri := TSay():New(040  ,005    ,{|| cDescri }, oDlg, ,        , , ,,.T., CLR_BLUE ,CLR_WHITE,350,50)

		@ 075,05 LISTBOX oLbx VAR cVar FIELDS HEADER aHeadCli[1],aHeadCli[2],aHeadCli[3],aHeadCli[4],aHeadCli[5],aHeadCli[6] SIZE 465,160 OF oDlg PIXEL ON CHANGE .T. ON dblClick( SelecProd(oLbx:nAt,@aVetor,@oLbx,@nTotItens,@cRet) )
		
		oLbx:SetArray( aVetor )
		oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,01],LoadBitmap( GetResources(), "LBOK" ),LoadBitmap( GetResources(), "LBNO" )),;
			aVetor[oLbx:nAt,02],; 
			aVetor[oLbx:nAt,03],;
			aVetor[oLbx:nAt,04],;
			aVetor[oLbx:nAt,05],;
			aVetor[oLbx:nAt,06]}}
		oLbx:Refresh()
		
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oDlg:End() },{|| cRet := PADR(" ",Len(SA5->A5_CODPRF)) , oDlg:End()}) CENTERED

Return cRet

/*/{Protheus.doc} Seleciona
    Marca/desmarca o registro posicionado.
    @type  Function
    @author matheus.vinicius
    @since 25/11/2022
    @version version     
/*/
Static Function SelecProd(nPos,aVetor,oLbx,nTotItens,cRet)
	aVetor[nPos][1] := !aVetor[nPos][1]
	If aVetor[nPos,1]
		nTotItens++
		if nTotItens > 1
			aVetor[nPos][1] := !aVetor[nPos][1]
			MsgStop('Selecione um único registro!', 'Atenção')
			nTotItens--
		else
			cRet := aVetor[nPos][2]
		endif
	Else
		nTotItens--
	EndIf
	oLbx:Refresh()
Return

/*/{Protheus.doc} Seleciona
    Marca/desmarca o registro posicionado.
    @type  Function
    @author matheus.vinicius
    @since 25/11/2022
    @version version     
/*/
Static Function Seleciona(nPos,aVetor,oLbx,nPosSel,nTotItens)
	aVetor[nPos][nPosSel] := !aVetor[nPos][nPosSel]
	If aVetor[nPos,nPosSel]
		nTotItens++
		if nTotItens > 1
			aVetor[nPos][nPosSel] := !aVetor[nPos][nPosSel]
			MsgStop('Selecione um único registro!', 'Atenção')
			nTotItens--
		endif
	Else
		nTotItens--
	EndIf
	oLbx:Refresh()
Return

/*/{Protheus.doc} ValidMarK
    Valida os registros confrmados.
    @type  Function
    @author matheus.vinicius
    @since 25/11/2022
    @version version     
/*/
Static Function ValidMarK(aVetor,nPosRec,nPosSel)
	Local lRet := .T.
	Local i    := Nil

	If (Ascan(aVetor,{|x| x[nPosSel] }) == 0)
		if MsgYesNo('Nenhum registro foi selecionado. Deseja continuar mesmo assim?', 'Atenção')
			lRet := .F.
		endif
	Else
		For i := 1 to len(aVetor)
			If aVetor[i,nPosSel]
				SA2->(DbGoTo(aVetor[i,nPosRec]))
			EndIf
		Next i
	Endif

Return(lRet)
