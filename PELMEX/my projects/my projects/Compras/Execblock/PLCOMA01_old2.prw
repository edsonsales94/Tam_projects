#Include "PROTHEUS.CH"


//--------------------------------------------------------------
/*/{Protheus.doc} ImpXML
Rotina de importação de nota fiscal no formato XML.
Verifica a existência do Fornecedor, dos Produtos e das Amarrações entre Prod e Forn, além de criar a pré-nota de entrada.
@since 13/07/2015 MTCOMA05()
/*/
//--------------------------------------------------------------
User Function PLCOMA01()
	Local aSize, aPosGet, oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, nI, oTFont12, oTFont14
	Local nPosLin := 2
	Local aAlter  := { "CY_PENDEN","D1_TES" }
	
	// -------------------
	// Erros
	// -------------------
	Private cMsgErro	:= "" //Campo de mensagem de erro padrão
	Private cFornErro	:= "O fornecedor do Arquivo XML não está cadastrado no sistema."
	Private cNotaErro	:= "Nota Fiscal já cadastrada no sistema."
	Private cProdErro	:= "Existe(m) produto(s) não cadastrado(s) no sistema."
	// -------------------
		
	// -------------------
	// Variáveis Privadas
	// -------------------
	Private aCampos := {	{"B1_OK"      ,"Status"},;
							{"D1_ITEM"    ,"Item"},;
							{"A5_CODPRF"  ,"Produdo NF"},;
							{"B1_COD"     ,"Produto"},;
							{"B1_DESC"    ,"Descricao"},;
							{"B1_POSIPI"  ,"NCM NF"},;
							{"B1_VEREAN"  ,"Código EAN"},;
							{"D1_LOCAL"   ,"Almox"},;
							{"CY_PENDEN"  ,"Usa 2a UM"},;
							{"D1_UM"      ,"UM"},;
							{"D1_SEGUM"   ,"Segunda UM"},;
							{"D1_QUANT"   ,"Quantidade"},;
							{"D1_QTSEGUM" ,"Qtde 2a UM"},;
							{"D1_VUNIT"   ,"Vlr.Unit"},;
							{"D1_CUSFF2"  ,"Vlr.2a UM"},;
							{"D1_TOTAL"   ,"Vlr. Total"},;
							{"D1_VALDESC" ,"Desconto"},;
							{"D1_BRICMS"  ,"BC Icms"},;
							{"D1_ICMSRET" ,"ICMS ST"},;
							{"D1_TES"     ,"Tes"},;
							{"D1_PEDIDO"  ,"Pedido"},;
							{"D1_ITEMPC"  ,"Item PC"},; 
							{"D1_NFORI"   ,"Nf Origem"},;
							{"D1_SERIORI" ,"Serie Origem"},; 
							{"D1_ITEMORI" ,"Item Origem"},;
							{"D1_IDENTB6" ,"IdentB6 Origem"},;
							{"D1_XDESXML" ,"Descri XML"},;
							{"D1_XUMXML"  ,"UM XML"},;
							{"D1_XQTDXML" ,"Qtd. XML"}}
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
	/*
	Fim do cabeçalho
	*/
	
	Private lNFCad   := .F. //Controla se a nota fiscal em questão já consta cadastrada no sistema (impede o recadastro)
	Private lGrava   := .T.
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
									SX3->X3_VALID,;
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
	aCols[1][1] := LoadBitmap( GetResources(), "BR_VERMELHO" )
	
	//Cria espaços no aCols com base nos campos do array "aHeader" (começa da 2a pos pelo mesmo motivo acima /\)
	For nI := 2 To nUsado
		aCols[1][nI] := CriaVar(aHeader[nI][2])
	Next
	
	aCols[1][nUsado+1] := .F.   // Flag de produto ok
	aCols[1][nUsado+2] := .F.   // Flag de deleção
	
	//----------------------------------------------------------------
	
	oTFont12 := TFont():New('Times New Roman',,-12,.T.,.T.)
	oTFont14 := TFont():New('Times New Roman',,-14,.T.,.T.)
	aSize    := MsAdvSize(.T.,.F.)
	aPosGet  := MsObjGetPos(aSize[3]-aSize[1], aSize[4]-aSize[2],{{003,073,103}} )
	
	oDlg     := MSDialog():New(aSize[7],aSize[1],aSize[6],aSize[5],'Importação de Arquivo XML',,,,,CLR_BLACK,CLR_WHITE,,,.T.)  // Ativa diálogo centralizado
	
	oSay1    := TSay():New(nPosLin,aPosGet[1,1] ,{||"Arquivo de importação"},    oDlg, , , , ,,.T., CLR_BLUE,CLR_WHITE,200,20)
	
	oArquivo := TGet():New(nPosLin+8,aPosGet[1,1],{|| M->ARQUIVO } ,oDlg,200,009,/*acPict*/,/*abValid*/,0,/*anClrBack*/,/*aoFont*/,.F.,/*oPar13*/,.T.,/*cPar15*/,.F.,/*abWhen*/,.F.,.F.,,.T.,.F.,,M->ARQUIVO,,,,)
	
	oButArq    := TButton():New(nPosLin+8,aPosGet[1,2]+50    , "Arquivo"       ,oDlg,{|| fSelArq()            },40,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	oButCar    := TButton():New(nPosLin+8,aPosGet[1,2]+95    , "Carregar"      ,oDlg,{|| MsgRun("Carregando XML"  ,"Processando",{|| fCarrArq()     }) },40,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	oButGrv    := TButton():New(nPosLin+8,aPosGet[1,3]+90    , "Gerar Pré-Nota",oDlg,{|| MsgRun("Gerando Pre Nota","Processando",{|| fGeraPreNota() }) },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	oButClear  := TButton():New(nPosLin+8,aPosGet[1,3]+(2*90), "Limpar tela"   ,oDlg,{|| fLimpaTela(0)        },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	oButFechar := TButton():New(nPosLin+8,aPosGet[1,3]+(3*90), "Fechar"        ,oDlg,{|| fFechar()            },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	
	
	nPosLin += 23
	oSay2    := TSay():New(nPosLin  ,aPosGet[1,1] ,{|| "Data da Entrada"                   }, oDlg, ,        , , ,,.T., CLR_BLUE ,CLR_WHITE,200,20)
	oDtEnt   := TSay():New(nPosLin+8,aPosGet[1,1] ,{|| Alltrim(cDtEnt)                     }, oDlg, ,oTFont12, , ,,.T., CLR_BLACK,CLR_WHITE,200,20)
	oSay3    := TSay():New(nPosLin  ,aPosGet[1,2] ,{|| "Nota Fiscal/Série"                 }, oDlg, ,        , , ,,.T., CLR_BLUE ,CLR_WHITE,200,20)
	oDoc     := TSay():New(nPosLin+8,aPosGet[1,2] ,{|| Alltrim(cDoc)+" / "+Alltrim(cSerie) }, oDlg, ,oTFont12, , ,,.T., CLR_BLACK,CLR_WHITE,200,20)
	oSay4    := TSay():New(nPosLin  ,aPosGet[1,3] ,{|| "Data Emissão"                      }, oDlg, ,        , , ,,.T., CLR_BLUE ,CLR_WHITE,200,20)
	oDtEmiss := TSay():New(nPosLin+8,aPosGet[1,3] ,{|| Alltrim(cDtEmiss)                   }, oDlg, ,oTFont12, , ,,.T., CLR_BLACK,CLR_WHITE,200,20)
	
	oButCad  := TButton():New(nPosLin,aPosGet[1,3]+(1*90), "Cadastrar Produto",oDlg,{|| fCadProd()   },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	oButPxF  := TButton():New(nPosLin,aPosGet[1,3]+(2*90), "Cad Prod x Forn"  ,oDlg,{|| fCadPxf()    },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	oButPed  := TButton():New(nPosLin,aPosGet[1,3]+(3*90), "Pedido Compra"    ,oDlg,{|| Documentos() },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	
	nPosLin += 23
	oButAtuXml := TButton():New(nPosLin+8,aPosGet[1,3]+(1*90), "Atu. NF"       ,oDlg,{|| fDadosForn()         },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)

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
	oItens := MsGetDados():New( nPosLin ,aPosGet[1,1], aSize[4]-aSize[2], aSize[3]-5, 4, "U_fLinhaOK", "U_fTudoOK", /*"+"D1_ITEM"*/, .F., aAlter,/*Reservado*/, .T., Len(aCols), "u_COMP01Valid", , , , oDlg)
	
	nPosLin += 53
	
	oDlg:Activate(,,,.T.,,,)
	
Return

/*/{Protheus.doc} fSelArq
Tela de Pesquisa do Arquivo XML.
@author Everson Dantas - eversoncdantas@gmail.com
@since 13/07/2015
/*/
Static Function fSelArq()
	
	cType := "eXtensible Markup Languague" +" (*.xml) |*.xml|"
	M->ARQUIVO := cGetFile(cType, "Selecione o arquivo")
	
	oArquivo:Refresh()
Return

/*/{Protheus.doc} fCarrArq
Carrega Arquivo XML.
@author Everson Dantas - eversoncdantas@gmail.com
@since 13/07/2015
@version 1.0
/*/
Static Function fCarrArq()
	Local nX
	Local cWarning := ""
	Local cError   := ""
	Local cFDest   := Substr(M->ARQUIVO,Rat("\",M->ARQUIVO)+1,Len(M->ARQUIVO))
	Local cDest    := '\xmlnfe'
	
	//Copia o arquivo do local informado para pasta do sistema Protheus
	If ":" $ M->ARQUIVO //Checa se não está na pasta do sistema (se não está, então contém ":")
		If File(cFDest)
			FErase(cDest+'\'+cFDest) // Se existir, apaga
		Endif
		CpyT2S(M->ARQUIVO, cDest)
		M->ARQUIVO := cDest+'\'+cFDest
	Endif
	
	Private cCNPJ, cUF, aDet
	Private nAbre := fOpen(M->ARQUIVO,0)
	
	lGrava   := .T.
	cMsgErro := ""
	
	If nAbre == -1
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
	
	SA2->(dbSetOrder(3))
	
	cCNPJ   := PADR(AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_cnpj:text ),Len(SA2->A2_CGC))
	cNomFor := PADR(AllTrim(oXML:_nfeproc:_nfe:_infnfe:_emit:_xnome:text),Len(SA2->A2_NOME))
	
	//Checa existência ou não do Fornecedor
	If fExistForn()
		cCodFor := SA2->A2_COD
		cLojFor := SA2->A2_LOJA
	Else
		cCodFor := ""
		cLojFor := ""
	Endif
	
	// -------------------
	// Preenche Cabeçalho
	// -------------------
	cDoc     := Strzero(Val(oXML:_nfeproc:_nfe:_infnfe:_ide:_nnf:text)  ,Len(SF1->F1_DOC)) //Número do Doc (F1_DOC)
	cSerie   := PADR(AllTrim(oXML:_nfeproc:_nfe:_infnfe:_ide:_serie:text),Len(SF1->F1_SERIE)) //Série do Doc (F1_SERIE)
	cDtEmiss := dtoc(Stod(StrTran(substr(oXML:_nfeproc:_nfe:_infnfe:_ide:_dhEmi:text,1,10),"-",""))) //Data de Emissão (F1_EMISSAO)
	aDet     := oXML:_nfeproc:_nfe:_infnfe:_det //Detalhes da nota (produtos, etc)
	cChave   := AllTrim(oXML:_nfeproc:_protNfe:_infProt:_chNFe:TEXT) //Chave Doc (F1_CHVNFE)
	aCols    := {}
	
	// -------------------
	
	//Preenche o K com os detalhes dos produtos da NF
	If ValType(aDet) <> "O"  // Se tiver vários itens
		aEval( aDet , {|x| CriaNos(@x), fPreencItens(x,@cCodFor,@cLojFor, cNomFor) } )
	Else
		CriaNos(@aDet)
		fPreencItens(aDet,@cCodFor,@cLojFor, cNomFor)
	EndIf
	
	If cTipo == 'B' .and. fExistCli()
		cCodFor := SA1->A1_COD
		cLojFor := SA1->A1_LOJA
	EndIf
	
	oDoc:Refresh()
	oDtEmiss:Refresh()
	oCodFor:Refresh()
	oNomFor:Refresh()
	oItens:Refresh()
	oMsgErro:Refresh()
	
	If Empty(cCodFor)
		lGrava:= .F.
		
		If cTipo <> "B"
			//Caso o usuário não deseje cadastrar fornecedor, desativa os botões de cadastro de produto e gravação de nota
			If Aviso("Problemas com fornecedor", cFornErro+"Cadastrar fornecedor?", {"Sim", "Não"}, 1) == 1
				fIncluiForn()
			Else
				fErroForn()
			EndIf
		Else
			//Caso o usuário não deseje cadastrar fornecedor, desativa os botões de cadastro de produto e gravação de nota
			If Aviso("Problemas com Cliente", cFornErro+"Cadastrar Cliente?", {"Sim", "Não"}, 1) == 1
				fIncluiCli()
			Else
				fErroForn()
			EndIf
		EndIf
		
		If lGrava
			oButGrv:Enable()
		EndIf
	Else
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
	EndIf
	
	//Ativa o botão de gravação, caso não tenha ocorrido erro.
	If lGrava
		oButGrv:Enable()
		//oButAtuXml:Disable()
	Else
		//oButAtuXml:Enable()
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
	Endif
Return


/*/{Protheus.doc} fExistForn
Verifica se já existe o fornecedor.
@author Everson Dantas - eversoncdantas@gmail.com
@since 13/07/2015
@version 1.0
/*/
Static Function fExistForn()
	SA2->(dbSetOrder(3))
	lRet := SA2->(dbSeek(XFILIAL("SA2")+cCNPJ))
Return lRet

/*/{Protheus.doc} fExistCli
Verifica se já existe o fornecedor.
@author Everson Dantas - eversoncdantas@gmail.com
@since 13/07/2015
@version 1.0
/*/
Static Function fExistCli()
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
	Local nOpc    := 0
	Local aAcho   := {}
	Local cTudoOk := ".T."
	
	SA2->(dbSetOrder(1))
	
	cCadastro := "Cadastro de Fornecedor - Importação de Arquivo XML"
	
	fAchaCampos("SA2",@aAcho,"")
	
	nOpc := AxInclui ("SA2", Recno(), 3,aAcho,"U_CrgSA2Cpo()",aAcho,cTudoOk,,,,)
	
	If nOpc <> 3 .And. nOpc <> 0
		fCarrArq()
	Else
		fErroForn()
	EndIf
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
		//Caso não tenha cadastrado, já garante que não será possível criar a pré-nota de entrada (SF1 e SD1)
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
	Local cDesXprod := RTrim(oDet:_prod:_xprod:text)
	Local cNCM_NF  := PADR(AllTrim(oDet:_prod:_ncm:text)  ,Len(SB1->B1_POSIPI))
	Local cUM      := PADR(AllTrim(oDet:_prod:_uCom:text) ,Len(SB1->B1_UM))
	Local cUmXML   := PADR(AllTrim(oDet:_prod:_uCom:text) ,Len(SB1->B1_UM))
	Local cSEGUM   := PADR("" ,Len(SB1->B1_SEGUM))
	Local cEAN     := AllTrim(oDet:_prod:_cean:text)
	Local cPedido  := Space(Len(SD1->D1_PEDIDO))
	Local cItemPC  := Space(Len(SD1->D1_ITEMPC))
	Local cNCM_PRO := Space(Len(SB1->B1_POSIPI))
	Local cST_PRO  := Space(Len(SB1->B1_CLASFIS))
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
	AADD(aItens, {"B1_COD"    , cProduto})
	AADD(aItens, {"B1_DESC"   , iif(!empty(cDesc),cDesc,cDescri)})
	AADD(aItens, {"B1_POSIPI" , cNCM_NF})
	AADD(aItens, {"CY_PENDEN" , "N"})
	AADD(aItens, {"D1_UM"     , cUM})
	AADD(aItens, {"D1_SEGUM"  , cSEGUM})
	AADD(aItens, {"D1_QUANT"  , nQtd})
	AADD(aItens, {"D1_X_DESCR" , iif(!empty(cDesc),Left(cDesc,tamsx3("D1_X_DESCR")[1]),left(cDescri,tamsx3("D1_X_DESCR")[1]))})
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
	AADD(aItens, {"D1_SERIORI", cSeriori})
	AADD(aItens, {"D1_ITEMORI", cItemori})
	AADD(aItens, {"D1_IDENTB6", cIdentb6})
	AADD(aItens, {"D1_XDESXML" , cDesXprod})
	AADD(aItens, {"D1_XUMXML"  , cUmXML})
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
	Local nTotal := 0
	
	cMsgErro := ""
	If fAllProdOK(.T.)
		
		aCabec := {	{"F1_TIPO"   ,cTipo         ,NIL},;
					{"F1_FORMUL" ,"N"           ,NIL},;
					{"F1_DOC"    ,cDoc          ,NIL},;
					{"F1_SERIE"  ,cSerie        ,NIL},;
					{"F1_EMISSAO",cTod(cDtEmiss),NIL},;
					{"F1_FORNECE",cCodFor       ,NIL},;
					{"F1_LOJA"   ,cLojFor       ,NIL},;
					{"F1_ESPECIE","SPED"        ,NIL},;
					{"F1_CHVNFE" ,cChave        ,NIL},;
					{"F1_COND"   ,"001"         ,NIL} }
		
		For nX:=1 To Len(aCols)
			aLinha := {}
			
			//aAdd(aLinha, {"LINPOS"    ,aCols[nX][fGetIndice("D1_ITEM"   , aHeader)]		, NIL})	
			aAdd(aLinha, {"D1_ITEM"   ,aCols[nX][fGetIndice("D1_ITEM"   , aHeader)]		, NIL})	
			aAdd(aLinha, {"D1_COD"    ,aCols[nX][fGetIndice("B1_COD"    , aHeader)]		, NIL})
			aAdd(aLinha, {"D1_XDESCR" ,aCols[nX][fGetIndice("B1_DESC"   , aHeader)]		, NIL})
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

			aAdd(aLinha, {"D1_XDESXML" , aCols[nX][fGetIndice("D1_XDESXML", aHeader)]	, NIL})
			aAdd(aLinha, {"D1_XUMXML"  , aCols[nX][fGetIndice("D1_XUMXML", aHeader)]	, NIL})
			aAdd(aLinha, {"D1_XQTDXML" , aCols[nX][fGetIndice("D1_XQTDXML", aHeader)]	, NIL})

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
			
			nTotal += aCols[nX][fGetIndice("D1_TOTAL", aHeader)] - aCols[nX][fGetIndice("D1_VALDESC", aHeader)]
			
			AADD(aItNFE,aLinha)

		Next
		/*
		If !Duplicatas(nTotal)
			Return
		Endif
		*/
		Private lMsErroAuto := .F.
		
		Begin Transaction
			MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItNFE, 3 /*Opção (Inclusão)*/)
		End Transaction
		
		If lMsErroAuto
			MostraErro()
		Else
			Aviso("Sucesso", "Pré-Nota de Entrada gerada com sucesso.",{"Fechar"}, 1)
			fLimpaTela(1)
		EndIf
	ElseIf !Empty(cMsgErro)
		Aviso("Impossível gerar Pré-Nota", cMsgErro, {"Fechar"}, 1)
	Endif
Return

//atualiza nota fiscal de entrada com informacoes do fornecedor. obrigatorio sped fiscal
Static Function fDadosForn()
	Local nLinAtu := 0
	SF1->(DbSetOrder(1))

	If !MsgYesNo("Para atualizar os dados do xml a entrada deve ter sido realizada na mesma ordem do xml, caso contrário ajuste as informações manualmente. Desesa continuar?", "Atenção")
		return
	EndIf

	If SF1->(DbSeek(xFilial("SF1")+cDoc+cSerie+cCodFor+cLojFor)) 
		SD1->(DbSetOrder(1))
		If SD1->(DbSeek(xFilial("SF1")+cDoc+cSerie+cCodFor+cLojFor))
			nLinAtu := 0
			While !SD1->(EOF()) .and. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == xFilial("SF1")+cDoc+cSerie+cCodFor+cLojFor
				nLinAtu++
				If aCols[nLinAtu,fGetIndice("B1_COD", aHeader)] == SD1->D1_COD
					RecLock("SD1", .F.)
						SD1->D1_XDESXML := aCols[nLinAtu][fGetIndice("D1_XDESXML", aHeader)]	
						SD1->D1_XUMXML  := aCols[nLinAtu][fGetIndice("D1_XUMXML" , aHeader)]	
						SD1->D1_XQTDXML := aCols[nLinAtu][fGetIndice("D1_XQTDXML", aHeader)]	
					MsUnlock()
				EndIf
				SD1->(DbSkip())
			Enddo
			Aviso("Sucesso", "Documento atualizado com sucesso.",{"Fechar"}, 1)
		Else
			Aviso("Erro", "Pré-Nota de Entrada gerada não encontrada.",{"Fechar"}, 1)
		EndIf
	ElseIf SF1->(DbSeek(xFilial("SF1")+cDoc+PADL(val(cSerie),tamsx3("F1_SERIE")[1],"0")+cCodFor+cLojFor)) 
		SD1->(DbSetOrder(1))
		If SD1->(DbSeek(xFilial("SF1")+cDoc+PADL(val(cSerie),tamsx3("F1_SERIE")[1],"0")+cCodFor+cLojFor))
			nLinAtu := 0
			While !SD1->(EOF()) .and. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == xFilial("SF1")+cDoc+PADL(val(cSerie),tamsx3("F1_SERIE")[1],"0")+cCodFor+cLojFor
				nLinAtu++
				If aCols[nLinAtu,fGetIndice("B1_COD", aHeader)] == SD1->D1_COD
					RecLock("SD1", .F.)
						SD1->D1_XDESXML := aCols[nLinAtu][fGetIndice("D1_XDESXML", aHeader)]	
						SD1->D1_XUMXML  := aCols[nLinAtu][fGetIndice("D1_XUMXML" , aHeader)]	
						SD1->D1_XQTDXML := aCols[nLinAtu][fGetIndice("D1_XQTDXML", aHeader)]	
					MsUnlock()
				EndIf
				SD1->(DbSkip())
			Enddo
			Aviso("Sucesso", "Documento de Entrada atualizado com sucesso.",{"Fechar"}, 1)
		Else
			Aviso("Erro", "Pré-Nota de Entrada gerada não encontrada.",{"Fechar"}, 1)
		EndIf
	Else
		Aviso("Erro", "Pré-Nota de Entrada gerada não encontrada.",{"Fechar"}, 1)
	EndIf
		
Return



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
			MSExecAuto({|x,y| MATA060(x,y)}, aCampAmarr, 3)
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
		Aviso("Impossível cadastrar produto", "O produto " + CValToChar(n) + " já está cadastrado.", {"Fechar"}, 1)
	//Else
	//	Aviso("Impossível cadastrar produto", "Produto inválido.", {"Fechar"}, 1)
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
			//Caso não tenha cadastrado, já garante que não será possível criar a pré-nota de entrada (SF1 e SD1)
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
Procedimento realizado caso o Fornecedor não esteja cadastrado (desabilita cadastro de produto e geração de pré-nota, além de mostrar
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
	
	cCadastro := "Vínculo com Pedido de Compra"
	
	//-- Monta interface para selecao do pedido
	Define MsDialog oDlg Title cCadastro From nlTl1,nlTl2 To nlTl3,nlTl4 Pixel //-- Vínculo com Pedido de Compra
	
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
				/*ElseIf !lInforma
					AVISO("Atenção","Para os itens do pedido com quantidade inferior aos itens correspondentes da nota utilize a opção de vínculo por Item.",{"OK"})
					lInforma := .T.*/
				EndIf
				SC7->(dbSkip())
			ENDDO
		Next nY
		
	Next nX

	RestArea(aArea)
	
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
/*
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
*/
