#Include "PROTHEUS.CH"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ BJCOMP01   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 13/04/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Importação de Nota Fiscal no formato XML                      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function BJCOMP01()
	Local aSize, aPosGet, oSay1, oSay2, oSay3, oSay4, nI, oTFont12, oTFont14, oSay7, oSay8, oSay9, oSay10, oSay11, aPosRdp, nPos, nC
	Local nPosLin := 2
	Local aAlter  := { "CY_PENDEN","D1_CC","D1_CONTA","D1_LOCAL" }
	Local aPerg   := {}
	
	AAdd( aPerg , { "Path arquivo XML", "C", 200, "G", "@!", "   ", "", "", Nil })
	AAdd( aPerg , { "Path XML"        , "C", 200, "G", "@!", "   ", "", "", Nil })
	
	// Carrega perguntas para o perfil do usuário
	CriaPerg(aPerg,.F.)
	
	// -------------------
	// Campos Customizados
	// -------------------
	cFldDesc := "D1_XDESCRI"
	cFldVII  := "D1_XII"
	cFldPII  := "D1_XALIQII"
	
	// -------------------
	// Erros
	// -------------------
	Private cMsgErro  := "" //Campo de mensagem de erro padrão
	Private cFornErro := "O fornecedor do Arquivo XML não está cadastrado no sistema."
	Private cNotaErro := "Nota Fiscal já cadastrada no sistema."
	Private cProdErro := "Existe(m) produto(s) não cadastrado(s) no sistema."
	Private cUniMErro := "Existe(m) unidades de medidas não cadastrado(s) no sistema."
	// -------------------
		
	// -------------------
	// Variáveis Privadas
	// -------------------
	Private aCampos := {}
	
	AAdd( aCampos , {"B1_OK"      ,"Status"} )
	AAdd( aCampos , {"D1_ITEM"    ,"Item"} )
	AAdd( aCampos , {"A5_CODPRF"  ,"Produdo NF"} )
	AAdd( aCampos , {"B1_COD"     ,"Produto"} )
	AAdd( aCampos , {"B1_DESC"    ,"Descricao"} )
	AAdd( aCampos , {"B1_POSIPI"  ,"NCM NF"} )
	AAdd( aCampos , {"B1_CODBAR"  ,"Código EAN"} )
	AAdd( aCampos , {"B1_CLASFIS" ,"CST NF"} )
	AAdd( aCampos , {"B1_CLASFIS" ,"CST Prod"} )
	AAdd( aCampos , {"D1_CC"      ,"CCusto"} )
	AAdd( aCampos , {"D1_CONTA"   ,"Cta.Contabil"} )
	AAdd( aCampos , {"D1_LOCAL"   ,"Almox"} )
	AAdd( aCampos , {"CY_PENDEN"  ,"Usa 2a UM"} )
	AAdd( aCampos , {"D1_UM"      ,"UM"} )
	AAdd( aCampos , {"D1_SEGUM"   ,"Segunda UM"} )
	AAdd( aCampos , {"D1_QUANT"   ,"Quantidade"} )
	AAdd( aCampos , {"D1_QTSEGUM" ,"Qtde 2a UM"} )
	AAdd( aCampos , {"D1_VUNIT"   ,"Vlr.Unit"} )
	AAdd( aCampos , {"D1_CUSFF2"  ,"Vlr.2a UM"} )
	AAdd( aCampos , {"D1_TOTAL"   ,"Vlr. Total"} )
	AAdd( aCampos , {"D1_VALDESC" ,"Desconto"} )
	AAdd( aCampos , {"D1_CLASFIS" ,"CST ICMS"} )
	AAdd( aCampos , {"D1_BASEICM" ,"Base ICMS"} )
	AAdd( aCampos , {"D1_PICM"    ,"% ICMS"} )
	AAdd( aCampos , {"D1_VALICM"  ,"Valor ICMS"} )
	AAdd( aCampos , {"D1_MARGEM"  ,"MVA"} )
	AAdd( aCampos , {"D1_BRICMS"  ,"BC Icms ST"} )
	AAdd( aCampos , {"D1_ICMSRET" ,"ICMS ST"} )
	AAdd( aCampos , {"D1_PEDIDO"  ,"Pedido"} )
	AAdd( aCampos , {"D1_ITEMPC"  ,"Item PC"} )
	AAdd( aCampos , {"D1_NFORI"   ,"Nf Origem"} )
	AAdd( aCampos , {"D1_SERIORI" ,"Serie Origem"} )
	AAdd( aCampos , {"D1_ITEMORI" ,"Item Origem"} )
	AAdd( aCampos , {"D1_IDENTB6" ,"IdentB6 Origem"} )
	AAdd( aCampos , {"D1_VALFRE"  ,"Frete"} )
	AAdd( aCampos , {"D1_SEGURO"  ,"Seguro"} )
	AAdd( aCampos , {"D1_DESPESA" ,"Despesa"} )
	If SD1->(FieldPos("D1_XCSTIPI")) > 0
		AAdd( aCampos , {"D1_XCSTIPI" ,"CST IPI"} )
	Endif
	AAdd( aCampos , {"D1_BASEIPI" ,"Base IPI"} )
	AAdd( aCampos , {"D1_VALIPI"  ,"Valor IPI"} )
	If SD1->(FieldPos("D1_XCSTPIS")) > 0
		AAdd( aCampos , {"D1_XCSTPIS" ,"CST PIS"} )
	Endif
	If SD1->(FieldPos(cFldVII)) > 0
		AAdd( aCampos , {cFldPII  ,"% II"} )
		AAdd( aCampos , {cFldVII  ,"Valor II"} )
	Endif
	If SD1->(FieldPos("D1_AFRMIMP")) > 0
		AAdd( aCampos , {"D1_AFRMIMP" ,"Vlr AFRMM"} )
	Endif
	If SD1->(FieldPos("D1_XSISCOM")) > 0
		AAdd( aCampos , {"D1_XSISCOM" ,"Vlr SISCOMEX"} )
	Endif
	AAdd( aCampos , {"D1_BASIMP6" ,"Base PIS"} )
	AAdd( aCampos , {"D1_ALQIMP6" ,"% PIS"} )
	AAdd( aCampos , {"D1_VALIMP6" ,"Valor PIS"} )
	If SD1->(FieldPos("D1_XCSTCOF")) > 0
		AAdd( aCampos , {"D1_XCSTCOF" ,"CST COFINS"} )
	Endif
	AAdd( aCampos , {"D1_BASIMP5" ,"Base COFINS"} )
	AAdd( aCampos , {"D1_ALQIMP5" ,"% COFINS"} )
	AAdd( aCampos , {"D1_VALIMP5" ,"Valor COFINS"} )
	AAdd( aCampos , {"F1_XDI" ,"Numero DI"} )
	AAdd( aCampos , {"F1_XDTDI" ,"Data DI"} )
	
	AAdd( aCampos , {"B1_CEST"    ,GetSx3Cache("B1_CEST","X3_TITULO")} )
	AAdd( aCampos , {"B1_ORIGEM"  ,"Origem"} )
	AAdd( aCampos , {"D1_DESCZFR" ,"ICMS Deson."} )
	AAdd( aCampos , {cFldDesc     ,"Descricao SD1"} )
	AAdd( aCampos , {"D1_XDESXML" ,"Descricao XML"} )
	AAdd( aCampos , {"D1_XUMXML"  ,"UM XML"} )
	AAdd( aCampos , {"D1_XQTDXML" ,"Qtd XML"} )
	
	Private cOrig     := ""
	Private oXml, oComp, cCNPJ, cINSCR
	Private nFldUse   := 0
	Private cPathFile := ""
	Private oArquivo, oDtEnt, oDoc, oSerie, oDtEmiss, oCodFor, oLojFor, oNomFor, oItens, oMsgErro, oChkCor, oSay5, oSay6, oSayM
	Private oMerc, oDesc, oFrete, oSegur, oDesp, oICMST, oIPI, oDeson, oAFRM, oSCMX, oGeral
	
	//Botões:
	Private oButArq      //Botão de Seleção de Arquivo
	Private oButCar      //Botão de Carregamento de Arquivo
	Private oButGrv      //Botão de Geração de Pré-Nota
	Private oButFechar   //Botão de Fechar Tela
	Private oButPrd      //Botão de Cadastro de Produto
	Private oButClear    //Botão para Limpar Tela
	Private oButPxF      //Botão para Cadastrar Produto X Fornecedor
	Private oButPed      //Botão para vincular o pedido de compra
	Private oButUnM      //Botão de Cadastro de Unidade de Medida
	
	//Cabeçalho da NF (Dados de SF1(Cabeçalho das NF de entrada)  e SA2(Fornecedores))
	Private cDoc     := Space(TamSx3("F1_DOC"    )[1])
	Private cSerie   := Space(TamSx3("F1_SERIE"  )[1])
	Private cDtEmiss := Space(TamSx3("F1_EMISSAO")[1])
	Private cCodFor  := Space(TamSx3("A2_COD"    )[1])
	Private cLojFor  := Space(TamSx3("A2_LOJA"   )[1])
	Private cNomFor  := Space(TamSx3("A2_NOME"   )[1])
	Private cDtEnt   := Dtoc(DdataBase)
	Private cChave   := Space(TamSx3("F1_CHVNFE" )[1])
	Private cTipoNF  := " "
	Private aTipos   := {" ", "Normal","Devolucao","Beneficiamento","Compl. Preco/Frete"}
	Private aAuxTpo  := {" ", "N","D","B","C"}
	Private aPedGer  := {}
	Private __cPedNF := CriaVar("C7_NUM",.F.)
	Private aSA5Pend := {}
	Private lEmite   := .F.
	Private lFile    := .T.
		
	Private cLegCodF := "Código/Loja Fornecedor"
	Private cLegNomF := "Nome Fornecedor"
	
	Private nTotMerc := 0
	Private nTotDesc := 0
	Private nTotFre  := 0
	Private nTotSeg  := 0
	Private nTotDesp := 0
	Private nTotICST := 0
	Private nTotIPI  := 0
	Private nTotDeso := 0
	Private nTotAFR  := 0
	Private nTotSCM  := 0
	Private nTotGer  := 0
	Private nTTdolar := 0
	Private ntxDolar := 0
	
	/*
	Fim do cabeçalho
	*/
	
	Private lNFCad   := .F. //Controla se a nota fiscal em questão já consta cadastrada no sistema (impede o recadastro)
	Private aHeader  := {}
	Private aCols    := {}
	Private bVazio   := {|| Len(aCols) < 1 .Or. Len(aCols) == 1 .And. Empty(aCols[1,3]) }
	Private aRotina  := {	{"Pesquisar" , "AxPesqui", 0, 1},;
							{"Visualizar", "AxVisual", 0, 2},;
							{"Incluir"   , "AxInclui", 0, 3},;
							{"Alterar"   , "AxAltera", 0, 4},;
							{"Excluir"   , "AxDeleta", 0, 5}}
	Private cTipo    := 'N'
	Private Inclui   := .T.
	Private Altera   := .F. 
	Private cFilAux  := cFilAnt
	
	Private cPathMulti := PADR(mv_par02,200)
	
	M->ARQUIVO := Space(200)
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	
	//Legenda
	Aadd(aHeader,{ "" , "B1_OK" , "@BMP" , 1, 0,"",, "C","","","",""})
	nFldUse++
	
	//Monta aHeader com base nos campos do array "aCampos" (Começa da 2a pos, pois a primeira é o botão de status)
	For nI:=2 To Len(aCampos)
		If !Empty( FWTamSX3(aCampos[nI][1]) )
			nFldUse++
			nPos := u_BJAdicionaCampo(aCampos[nI][1],@aHeader)
			aHeader[nPos,1] := Trim(aCampos[nI][2])
		EndIf
	Next
	
	//--------------------------------------------------------------
	//Linha em branco do aCols na tela inicial da rotina
	Aadd(aCols,Array(nFldUse+2))
	
	//Adiciona bolinha vermelha de "Não cadastrado"
	aCols[1][1] := LoadBitmap( GetResources(), "BR_VERMELHO" ) 
	
	//Cria espaços no aCols com base nos campos do array "aHeader" (começa da 2a pos pelo mesmo motivo acima /\)
	For nI := 2 To nFldUse
		aCols[1][nI] := CriaVar(aHeader[nI][2])
	Next
	
	aCols[1][nFldUse+1] := 0     // Flag de PRODUTO e UM ok
	aCols[1][nFldUse+2] := .F.   // Flag de deleção --
	
	//----------------------------------------------------------------
	
	oTFont12 := TFont():New('Times New Roman',,-12,.T.,.T.)
	oTFont14 := TFont():New('Times New Roman',,-14,.T.,.T.)
	
	//aSize    := MsAdvSize(.T.,.F.)
	PosObjetos(@aSize,@aPosRdp)
	
	aPosGet  := MsObjGetPos(aSize[3]-aSize[1], aSize[4]-aSize[2],{{003,073,103}} )
	
	SetKey( VK_F6 ,{|| ListaArquivos() })
	
	oComp    := MSDialog():New(aSize[7],aSize[1],aSize[6],aSize[5],'Importação de Arquivo XML',,,,,CLR_BLACK,CLR_WHITE,,,.T.)  // Ativa diálogo centralizado
	
	oSay1    := TSay():New(nPosLin,aPosGet[1,1] ,{|| "Arquivo de importação" }, oComp, , , , ,,.T., CLR_BLUE,CLR_WHITE,200,20)
	
	oSayM    := TSay():New(nPosLin,aPosGet[1,1]+75 ,{|| If( Empty(cPathMulti) , " ", "Caminho: " + Upper(cPathMulti)) }, oComp, , , , ,,.T., CLR_RED ,CLR_WHITE,200,20)
	
	oArquivo := TGet():New(nPosLin+8,aPosGet[1,1],{|u| M->ARQUIVO := If(PCount() == 0, M->ARQUIVO, u) } ,oComp,200,009,/*cPict*/,/*bValid*/,/*nClrFore*/,/*nClrBack*/,/*oFont*/,/*oPar12*/,/*oPar13*/,.T.,/*cPar15*/,/*oPar16*/,/*bWhen*/,/*cPar18*/,/*cPar19*/,/*bChange*/,Empty(cPathMulti),.F.,/*oPar23*/,M->ARQUIVO,,,,)
	oArquivo:bLostFocus := {|| If(!Empty(M->ARQUIVO),FWMsgRun(Nil, {|oSay| fCarrArq(aPerg) }, "Importando XML", "Carregando XML..."),) }
	
	oButArq  := TButton():New(nPosLin+8,aPosGet[1,2]+50  , "Arquivo"       ,oComp,{|| fSelArq(aPerg) },40,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	oButCar  := TButton():New(nPosLin+8,aPosGet[1,2]+95  , "Carregar"      ,oComp,{|| FWMsgRun(Nil, {|oSay| fCarrArq(aPerg) }, "Importando XML", "Carregando XML...") },40,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	
	@ nPosLin+08,aPosGet[1,2]+140 SAY RetTitle("F1_TIPO") PIXEL OF oComp SIZE 35,09
	@ nPosLin+18,aPosGet[1,2]+140 MSCOMBOBOX oTpoNF VAR cTipoNF ITEMS aTipos SIZE 60,50 PIXEL OF oComp ON CHANGE (cTipo := aAuxTpo[oTpoNF:nAt], PesqCabItens(.T.)) WHEN !(lNFCad .Or. Eval(bVazio))
	
	oButGrv    := TButton():New(nPosLin+8,aPosGet[1,3]+(2*90), "Gerar Pré-Nota",oComp,{|| fGeraPreNota(),SetaFoco() },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	oButClear  := TButton():New(nPosLin+8,aPosGet[1,3]+(3*90), "Limpar tela"   ,oComp,{|| fLimpaTela(0) ,SetaFoco() },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	oButFechar := TButton():New(nPosLin+8,aPosGet[1,3]+(4*90), "Fechar"        ,oComp,{|| If(fFechar(),oComp:End(),) },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	
	nPosLin += 23
	oSay2    := TSay():New(nPosLin  ,aPosGet[1,1] ,{|| "Data da Entrada"                   }, oComp, ,        , , ,,.T., CLR_BLUE ,CLR_WHITE,200,20)
	oDtEnt   := TSay():New(nPosLin+8,aPosGet[1,1] ,{|| Alltrim(cDtEnt)                     }, oComp, ,oTFont12, , ,,.T., CLR_BLACK,CLR_WHITE,200,20)
	oSay3    := TSay():New(nPosLin  ,aPosGet[1,2] ,{|| "Nota Fiscal/Série"                 }, oComp, ,        , , ,,.T., CLR_BLUE ,CLR_WHITE,200,20)
	oDoc     := TSay():New(nPosLin+8,aPosGet[1,2] ,{|| Alltrim(cDoc)+" / "+Alltrim(cSerie) }, oComp, ,oTFont12, , ,,.T., CLR_BLACK,CLR_WHITE,200,20)
	oSay4    := TSay():New(nPosLin  ,aPosGet[1,3] ,{|| "Data Emissão"                      }, oComp, ,        , , ,,.T., CLR_BLUE ,CLR_WHITE,200,20)
	oDtEmiss := TSay():New(nPosLin+8,aPosGet[1,3] ,{|| Alltrim(cDtEmiss)                   }, oComp, ,oTFont12, , ,,.T., CLR_BLACK,CLR_WHITE,200,20)
	
	oButPrd  := TButton():New(nPosLin,aPosGet[1,3]+(2*90), "Cadastrar Produto",oComp,{|| fCadProd()   },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	oButPxF  := TButton():New(nPosLin,aPosGet[1,3]+(3*90), "Cad Prod x Forn"  ,oComp,{|| fCadPxf()    },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	oButPed  := TButton():New(nPosLin,aPosGet[1,3]+(4*90), "Pedido Compra"    ,oComp,{|| Documentos() },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	
	nPosLin += 23
	oSay5    := TSay():New(nPosLin  ,aPosGet[1,1]     ,{|| cLegCodF                                }, oComp, ,        , , ,,.T., CLR_BLUE ,CLR_WHITE,200,20)
	oCodFor  := TSay():New(nPosLin+8,aPosGet[1,1]     ,{|| Alltrim(cCodFor)+" / "+Alltrim(cLojFor) }, oComp, ,oTFont12, , ,,.T., CLR_BLACK,CLR_WHITE,200,20)
	oSay6    := TSay():New(nPosLin  ,aPosGet[1,2]     ,{|| cLegNomF                                }, oComp, ,        , , ,,.T., CLR_BLUE ,CLR_WHITE,200,20)
	oNomFor  := TSay():New(nPosLin+8,aPosGet[1,2]     ,{|| Alltrim(cNomFor)                        }, oComp, ,oTFont12, , ,,.T., CLR_BLACK,CLR_WHITE,200,20)
	oMsgErro := TSay():New(nPosLin+8,aPosGet[1,2]+180 ,{|| cMsgErro                                }, oComp, ,oTFont14, , ,,.T., CLR_HRED ,CLR_WHITE,200,20)
	
	oButPrd  := TButton():New(nPosLin-8,aPosGet[1,3]+(2*90), "Complemento Produto",oComp,{|| fCadCompl() },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	oButUnM  := TButton():New(nPosLin-8,aPosGet[1,3]+(3*90), "Cadastrar Un.Medida",oComp,{|| fCadUnMed() },60,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	
	nPosLin += 23
	oItens := MsGetDados():New( aPosRdp[2,1] ,aPosRdp[2,2], aPosRdp[2,3], aPosRdp[2,4], 4, /*"LinhaOK"*/, /*"TudoOK"*/, /*"+"D1_ITEM"*/, .F., aAlter,/*Reservado*/, .T., Len(aCols), "u_BJCMP01Valid", , , , oComp)
	
	nC := 0
	oSay7    := TSay():New(aPosRdp[3,1],aPosRdp[3,2]+nC*80,{|| "Total dos Produtos"                }, oComp, ,oTFont12, , ,,.T., CLR_BLUE ,CLR_WHITE,200,20) ; nC++
	oSay8    := TSay():New(aPosRdp[3,1],aPosRdp[3,2]+nC*80,{|| "Descontos"                         }, oComp, ,oTFont12, , ,,.T., CLR_BLUE ,CLR_WHITE,200,20) ; nC++
	oSay9    := TSay():New(aPosRdp[3,1],aPosRdp[3,2]+nC*80,{|| "Frete"                             }, oComp, ,oTFont12, , ,,.T., CLR_BLUE ,CLR_WHITE,200,20) ; nC++
	oSay10   := TSay():New(aPosRdp[3,1],aPosRdp[3,2]+nC*80,{|| "Seguro"                            }, oComp, ,oTFont12, , ,,.T., CLR_BLUE ,CLR_WHITE,200,20) ; nC++
	oSay11   := TSay():New(aPosRdp[3,1],aPosRdp[3,2]+nC*80,{|| "Despesas"                          }, oComp, ,oTFont12, , ,,.T., CLR_BLUE ,CLR_WHITE,200,20) ; nC++
	oSay12   := TSay():New(aPosRdp[3,1],aPosRdp[3,2]+nC*80,{|| "ICMS Retido"                       }, oComp, ,oTFont12, , ,,.T., CLR_BLUE ,CLR_WHITE,200,20) ; nC++
	oSay13   := TSay():New(aPosRdp[3,1],aPosRdp[3,2]+nC*80,{|| "Valor do IPI"                      }, oComp, ,oTFont12, , ,,.T., CLR_BLUE ,CLR_WHITE,200,20) ; nC++
	oSay14   := TSay():New(aPosRdp[3,1],aPosRdp[3,2]+nC*80,{|| "Desoneração"                       }, oComp, ,oTFont12, , ,,.T., CLR_BLUE ,CLR_WHITE,200,20) ; nC++
	If SD1->(FieldPos("D1_AFRMIMP")) > 0
		oSay15 := TSay():New(aPosRdp[3,1],aPosRdp[3,2]+nC*80,{|| "Valor AFRMM"                     }, oComp, ,oTFont12, , ,,.T., CLR_BLUE ,CLR_WHITE,200,20) ; nC++
	Endif
	If SD1->(FieldPos("D1_XSISCOM")) > 0
		oSay16 := TSay():New(aPosRdp[3,1],aPosRdp[3,2]+nC*80,{|| "Valor SISCOMEX"                  }, oComp, ,oTFont12, , ,,.T., CLR_BLUE ,CLR_WHITE,200,20) ; nC++
	Endif
	oSay17   := TSay():New(aPosRdp[3,1],aPosRdp[3,2]+nC*80,{|| "Valor Total da Nota"               }, oComp, ,oTFont12, , ,,.T., CLR_BLUE ,CLR_WHITE,200,20) ; nC++
	
	nC := 0
	oMerc    := TGet():New(aPosRdp[3,1]+12,aPosRdp[3,2]+nC*80,{|u| nTotMerc := If(PCount() == 0, nTotMerc, u) } ,oComp,50,10,"@E 999,999,999.99",/*abValid*/,0,/*anClrBack*/,oTFont12,.F.,/*oPar13*/,.T.,/*cPar15*/,.F.,/*abWhen*/,.F.,.F.,/*bChange*/,.T.,.F.,,"nTotMerc",,,,) ; nC++
	oDesc    := TGet():New(aPosRdp[3,1]+12,aPosRdp[3,2]+nC*80,{|u| nTotDesc := If(PCount() == 0, nTotDesc, u) } ,oComp,50,10,"@E 999,999,999.99",/*abValid*/,0,/*anClrBack*/,oTFont12,.F.,/*oPar13*/,.T.,/*cPar15*/,.F.,/*abWhen*/,.F.,.F.,/*bChange*/,.T.,.F.,,"nTotDesc",,,,) ; nC++
	oFrete   := TGet():New(aPosRdp[3,1]+12,aPosRdp[3,2]+nC*80,{|u| nTotFre  := If(PCount() == 0, nTotFre , u) } ,oComp,50,10,"@E 999,999,999.99",/*abValid*/,0,/*anClrBack*/,oTFont12,.F.,/*oPar13*/,.T.,/*cPar15*/,.F.,/*abWhen*/,.F.,.F.,/*bChange*/,.T.,.F.,,"nTotFre" ,,,,) ; nC++
	oSegur   := TGet():New(aPosRdp[3,1]+12,aPosRdp[3,2]+nC*80,{|u| nTotSeg  := If(PCount() == 0, nTotSeg , u) } ,oComp,50,10,"@E 999,999,999.99",/*abValid*/,0,/*anClrBack*/,oTFont12,.F.,/*oPar13*/,.T.,/*cPar15*/,.F.,/*abWhen*/,.F.,.F.,/*bChange*/,.T.,.F.,,"nTotSeg" ,,,,) ; nC++
	oDesp    := TGet():New(aPosRdp[3,1]+12,aPosRdp[3,2]+nC*80,{|u| nTotDesp := If(PCount() == 0, nTotDesp, u) } ,oComp,50,10,"@E 999,999,999.99",/*abValid*/,0,/*anClrBack*/,oTFont12,.F.,/*oPar13*/,.T.,/*cPar15*/,.F.,/*abWhen*/,.F.,.F.,/*bChange*/,.T.,.F.,,"nTotDesp",,,,) ; nC++
	oICMST   := TGet():New(aPosRdp[3,1]+12,aPosRdp[3,2]+nC*80,{|u| nTotICST := If(PCount() == 0, nTotICST, u) } ,oComp,50,10,"@E 999,999,999.99",/*abValid*/,0,/*anClrBack*/,oTFont12,.F.,/*oPar13*/,.T.,/*cPar15*/,.F.,/*abWhen*/,.F.,.F.,/*bChange*/,.T.,.F.,,"nTotICST",,,,) ; nC++
	oIPI     := TGet():New(aPosRdp[3,1]+12,aPosRdp[3,2]+nC*80,{|u| nTotIPI  := If(PCount() == 0, nTotIPI , u) } ,oComp,50,10,"@E 999,999,999.99",/*abValid*/,0,/*anClrBack*/,oTFont12,.F.,/*oPar13*/,.T.,/*cPar15*/,.F.,/*abWhen*/,.F.,.F.,/*bChange*/,.T.,.F.,,"nTotIPI" ,,,,) ; nC++
	oDeson   := TGet():New(aPosRdp[3,1]+12,aPosRdp[3,2]+nC*80,{|u| nTotDeso := If(PCount() == 0, nTotDeso, u) } ,oComp,50,10,"@E 999,999,999.99",/*abValid*/,0,/*anClrBack*/,oTFont12,.F.,/*oPar13*/,.T.,/*cPar15*/,.F.,/*abWhen*/,.F.,.F.,/*bChange*/,.T.,.F.,,"nTotDeso",,,,) ; nC++
	If SD1->(FieldPos("D1_AFRMIMP")) > 0
		oAFRM := TGet():New(aPosRdp[3,1]+12,aPosRdp[3,2]+nC*80,{|u| nTotAFR := If(PCount() == 0, nTotAFR , u) } ,oComp,50,10,"@E 999,999,999.99",/*abValid*/,0,/*anClrBack*/,oTFont12,.F.,/*oPar13*/,.T.,/*cPar15*/,.F.,/*abWhen*/,.F.,.F.,/*bChange*/,.T.,.F.,,"nTotAFR" ,,,,) ; nC++
	Endif
	If SD1->(FieldPos("D1_XSISCOM")) > 0
		oSCMX := TGet():New(aPosRdp[3,1]+12,aPosRdp[3,2]+nC*80,{|u| nTotSCM := If(PCount() == 0, nTotSCM , u) } ,oComp,50,10,"@E 999,999,999.99",/*abValid*/,0,/*anClrBack*/,oTFont12,.F.,/*oPar13*/,.T.,/*cPar15*/,.F.,/*abWhen*/,.F.,.F.,/*bChange*/,.T.,.F.,,"nTotSCM" ,,,,) ; nC++
	Endif
	oGeral    := TGet():New(aPosRdp[3,1]+12,aPosRdp[3,2]+nC*80,{|u| nTotGer := If(PCount() == 0, nTotGer , u) } ,oComp,50,10,"@E 999,999,999.99",/*abValid*/,0,/*anClrBack*/,oTFont12,.F.,/*oPar13*/,.T.,/*cPar15*/,.F.,/*abWhen*/,.F.,.F.,/*bChange*/,.T.,.F.,,"nTotGer" ,,,,) ; nC++
	
	StatusObjetos()
	
	oComp:Activate(,,,.T.,,,)
	
	InicEmpFilSM0(cFilAux)
	
	SetKey( VK_F6 ,{|| Nil })
	
Return

Static Function SetaFoco()
	If !Empty(cPathMulti)
		oArquivo:SetFocus()
	Endif
Return

/*/{Protheus.doc} fSelArq
Tela de Pesquisa do Arquivo XML.
@author Everson Dantas - eversoncdantas@gmail.com
@since 13/07/2015
/*/
Static Function fSelArq(aPerg)
	Local nPos
	
	cType := "eXtensible Markup Languague" +" (*.xml) |*.xml|"
	M->ARQUIVO := cGetFile(cType, "Selecione o arquivo",,AllTrim(mv_par01), .T., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE) 
	M->ARQUIVO := PADR(AllTrim(M->ARQUIVO),200)
	
	oArquivo:Refresh()
	
	// Seleciona somente o caminho do arquivo selecionado
	mv_par01 := AllTrim(M->ARQUIVO)
	nPos     := Len(mv_par01)
	While nPos > 0 .And. SubStr(mv_par01,nPos,1) <> "\"
		nPos--
	Enddo
	
	mv_par01 := PADR(mv_par01,nPos-1)
	mv_par02 := cPathMulti
	
	// Grava perguntas para o perfil do usuário
	CriaPerg(aPerg,.T.)

Return

Static Function ListaArquivos()
	Local oPXML, oPanelT
	Local oFont := TFont():New("COURIER NEW",08,18)
	Local cPath := cPathMulti
	Local nOpcA := 0
	
	SetKey( VK_F6 ,{|| Nil })
	
	DEFINE MSDIALOG oPXML TITLE "Caminho dos arquivos XML" From 0,0 To 07,73 STYLE DS_MODALFRAME STATUS OF oMainWnd
	
	@ 0,0 MSPANEL oPanelT PROMPT "" SIZE 10,22 OF oPXML CENTERED LOWERED //"Botoes"
	oPanelT:Align := CONTROL_ALIGN_BOTTOM
	
	@ 05,005 SAY "Caminho"  SIZE  40,10 PIXEL OF oPanelT COLOR CLR_BLUE FONT oFont
	@ 05,045 MSGET cPath   PICTURE "@!" SIZE 200,10 PIXEL OF oPanelT Valid Vazio(cPath) .Or. ExistDir(cPath) FONT oFont
	@ 05,250 BUTTON "Abrir..." SIZE 30,12 PIXEL OF oPanelT ACTION cPath := ChoiceArq(cPath)
	
	ACTIVATE MSDIALOG oPXML ON INIT EnchoiceBar(oPXML,{|| nOpcA:=1,oPXML:End() },{|| oPXML:End() }) CENTERED
	
	If nOpcA == 1
		mv_par02 := cPathMulti := cPath
	Endif
	
	oArquivo:lReadOnly := Empty(cPathMulti)    // Habilita ou não a digitação do arquivo
	
	SetKey( VK_F6 ,{|| ListaArquivos() })

Return

Static Function ChoiceArq(cPath)
	Local cType := "Extensão do arquivo" +" (*.xml) |*.xml|"
	
	cPath := cGetFile(cType, "Selecione o diretório da NFC-e / NF-e",,,.F.,GETF_OVERWRITEPROMPT+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY)
	cPath := PADR(cPath,Len(cPath))
	
Return cPath

/*/{Protheus.doc} fCarrArq
Carrega Arquivo XML.
@author Everson Dantas - eversoncdantas@gmail.com
@since 13/07/2015
@version 1.0
/*/
Static Function fCarrArq(aPerg)
	Local nX, lGrava, oNFe
	Local cWarning := ""
	Local cError   := ""
	Local cFDest   := ""
	Local cDest    := '\xmlnfe'
	Local cFilInat := GetMV("MV_XFILINA",.F.,"60,99")
	Local lINSCR   := GetMV("MV_XVLDINS",.F.,.T.)    // Se valida a empresa/filial pela Inscrição
	Local aSM0     := FWLoadSM0()
	Local lOk      := .F.

	cPathFile := AllTrim(M->ARQUIVO)
	
	If "\" $ cPathFile .Or. !Empty(cPathMulti)
		// Caso esteja lendo de um local com vários arquivos
		If !Empty(cPathMulti) .And. !(".XML" $ Upper(cPathFile))
			cPathFile := StrTran(AllTrim(cPathMulti) + "\" + cPathFile + ".xml","\\","\")
		Endif
		
		If !File(cPathFile)
			FwAlertError("O arquivo informado ("+cPathFile+") não foi encontrado !")
			Return lOk
		Endif
		
		cFDest := Substr(cPathFile,Rat("\",cPathFile)+1,Len(cPathFile))
		
		//Copia o arquivo do local informado para pasta do sistema Protheus
		If ":" $ cPathFile //Checa se não está na pasta do sistema (se não está, então contém ":")
			If File(cFDest)
				FErase(cDest+'\'+cFDest) // Se existir, apaga
			Endif
			CpyT2S(cPathFile, cDest)
			cPathFile := cDest+'\'+cFDest
		Endif
		
		Private aDet
		Private nAbre := fOpen(cPathFile,0)
		
		cMsgErro := ""
		
		If nAbre == -1
			If Empty(cPathFile)
				FwAlertError("Por favor, selecione um arquivo.","Problema ao abrir arquivo")
			Else
				FwAlertError("O arquivo de nome " + cPathFile + " não pode ser aberto. Verifique os parâmetros.","Problema ao abrir arquivo")
			Endif
			Return lOk
		Else
			fClose(nAbre)
		Endif
	
		//Efetua abertura do arquivo XML
		oNFe := XmlParserFile( cPathFile, "_", @cError, @cWarning )
	//ElseIf PesqXML(@cPathFile)
	//	oNFe  := XmlParser(cPathFile, "_", @cWarning, @cError)
	//	lFile := .F.
	Else
		FWAlertError("A nota fiscal informada não foi localizada ou não possui XML válido !")
		Return lOk
	Endif
	
	If !Empty(cError) //Caso tenha ocorrido erro:
		cMsgErr := cError
		FwAlertError(cMsgErr)
		Return lOk
	EndIf
	
	mv_par02 := cPathMulti
	// Grava perguntas para o perfil do usuário
	CriaPerg(aPerg,.T.)
	
	If lEmite := !XmlNodeExist(oNFe, "_nfeproc")
		oXML := oNFe
	Else
		oXML := oNFe:_nfeproc
	Endif
	
	// Posiciona na filial correta
	If lEmite
		cCNPJ := AllTrim(oXML:_nfe:_infnfe:_emit:_cnpj:text)
		If lINSCR
			cCNPJ += "_"+AllTrim(oXML:_nfe:_infnfe:_emit:_ie:text)
		Endif
	Else
		cCNPJ := AllTrim(oXML:_nfe:_infnfe:_dest:_cnpj:text)
		If lINSCR
			cCNPJ += "_"+AllTrim(oXML:_nfe:_infnfe:_dest:_ie:text)
		Endif
	Endif
	
	nX := AScan( aSM0 , {|x| !(x[5] $ cFilInat) .And. x[1] == cEmpAnt .And. PADR(x[22],Len(cCNPJ)) == cCNPJ } )
	If nX > 0
		InicEmpFilSM0(aSM0[nX,5])    // Posiciona na filial correta da nota
	Else
		FwAlertError("O CNPJ do XML não é uma filial do grupo de empresas " + cEmpAnt + " !")
		Return lOk
	Endif
	
	SA2->(dbSetOrder(3))
	
	If lEmite .And. ExistBlock("BJForImp")
		If lOk := u_BJForImp()
			cCNPJ   := SA2->A2_CGC
			cINSCR  := SA2->A2_INSCR
			cNomFor := SA2->A2_NOME
		Endif
	Endif
	
	If !lOk
		cCNPJ   := PADR(AllTrim(oXML:_nfe:_infnfe:_emit:_cnpj:text ),Len(SA2->A2_CGC  ))
		cINSCR  := PADR(AllTrim(oXML:_nfe:_infnfe:_emit:_ie:text   ),Len(SA2->A2_INSCR))
		cNomFor := PADR(AllTrim(oXML:_nfe:_infnfe:_emit:_xnome:text),Len(SA2->A2_NOME ))
	Endif
	
	//Checa existência ou não do Fornecedor
	If !fExistForn()
		Return lOk
	Endif
	
	// -------------------
	// Preenche Cabeçalho
	// -------------------
	cDoc     := If( lEmite , CriaVar("F1_DOC"  ,.F.), StrZero(Val(oXML:_nfe:_infnfe:_ide:_nnf:text)  ,Len(SF1->F1_DOC))) //Número do Doc (F1_DOC)
	cSerie   := If( lEmite , CriaVar("F1_SERIE",.F.), PADL(AllTrim(oXML:_nfe:_infnfe:_ide:_serie:text),Len(SF1->F1_SERIE),"0")) //Série do Doc (F1_SERIE)
	cDtEmiss := If( lEmite , DtoC(dDataBase), dtoc(Stod(StrTran(substr(oXML:_nfe:_infnfe:_ide:_dhEmi:text,1,10),"-","")))) //Data de Emissão (F1_EMISSAO)
	aDet     := oXML:_nfe:_infnfe:_det //Detalhes da nota (produtos, etc)
	cChave   := If( lEmite , CriaVar("F1_CHVNFE",.F.), AllTrim(oXML:_protNfe:_infProt:_chNFe:TEXT)) //Chave Doc (F1_CHVNFE)
	aCols    := {}
	aSA5Pend := {}	
	// -------------------
	nTotMerc := 0
	nTotDesc := 0
	nTotFre  := 0
	nTotSeg  := 0
	nTotDesp := 0
	nTotICST := 0
	nTotIPI  := 0
	nTotDeso := 0
	nTotAFR  := 0
	nTotSCM  := 0
	nTotGer  := 0
	nTTdolar := 0
	
	//Preenche o K com os detalhes dos produtos da NF
	If ValType(aDet) <> "O"  // Se tiver vários itens
		aEval( aDet , {|x| CriaNos(@x), lOk := fPreencItens(x,@cCodFor,@cLojFor, cNomFor) } )
	Else
		CriaNos(@aDet)
		lOk := fPreencItens(aDet,@cCodFor,@cLojFor, cNomFor)
	EndIf
	
	If cTipo $ "DB" .And. fExistCli()
		cCodFor := SA1->A1_COD
		cLojFor := SA1->A1_LOJA
	EndIf
	
	SetKey(115,{||Documentos(aCols[n,GDFieldPos("B1_COD")]) })
	
	oDoc:Refresh()
	oDtEmiss:Refresh()
	oCodFor:Refresh()
	oNomFor:Refresh()
	oItens:Refresh()
	oMsgErro:Refresh()
	
	If Empty(cCodFor)
		If !(cTipo $ "DB")
			//Caso o usuário não deseje cadastrar fornecedor, desativa os botões de cadastro de produto e gravação de nota
			If FWAlertYesNo(cFornErro+"Cadastrar fornecedor?","Problemas com fornecedor")
				lOk := fIncluiForn(aPerg)
			Else
				fErroForn()
			EndIf
		Else
			//Caso o usuário não deseje cadastrar fornecedor, desativa os botões de cadastro de produto e gravação de nota
			If FWAlertYesNo(cFornErro+"Cadastrar Cliente?","Problemas com Cliente")
				lOk := fIncluiCli(aPerg)
			Else
				fErroForn()
			EndIf
		EndIf
	Else
		SA5->(dbSetOrder(14))
		For nX := 1 To Len(aCols)
			fCheckProd(nX) //Verifica se o produto corrente existe
		Next
		
		If lGrava := fAllProdOK()
			//Busca no banco de dados pela nota fiscal representada pelo XML
			SF1->(dbSetOrder(1))
			If lNFCad := SF1->(dbSeek(XFILIAL("SF1")+cDoc+cSerie+cCodFor))
				cMsgErro := cNotaErro
				
				FWAlertWarning(cMsgErro,"Atenção")
				
				AtuCampos(.F.)    // Verifica se é necessário atualizar os campos customizados
			Endif
		Endif
		
		StatusObjetos(lGrava)
	EndIf
	
	//Ativa o botão de gravação, caso não tenha ocorrido erro.
	If lOk .Or. lNFCad
		nTotGer := nTotMerc - nTotDesc + nTotFre + nTotDesp + nTotICST + nTotIPI - nTotDeso + nTotSeg
		
		oMerc:Refresh()
		oDesc:Refresh()
		oFrete:Refresh()
		oSegur:Refresh()
		oDesp:Refresh()
		oICMST:Refresh()
		oIPI:Refresh()
		oDeson:Refresh()
		oGeral:Refresh()
	EndIf
	
Return

Static Function CriaNos(oDet)
	XmlNewNode(oDet:_prod,'_VDESC' ,'VDESC' ,'NOD')
	XmlNewNode(oDet:_prod,'_VFRETE','VFRETE','NOD')
	XmlNewNode(oDet:_prod,'_VSEG'  ,'VSEG'  ,'NOD')
	XmlNewNode(oDet:_prod,'_VOUTRO','VOUTRO','NOD')
	
	XmlNewNode(oDet,'_INFADPROD','INFADPROD','NOD')   
Return

/*/{Protheus.doc} fCheckProd
Realiza todo o procedimento de checar se os produtos da NF já constam no sistema e, em caso negativo, oferece  opção de cadastrá-lo.
@author Everson Dantas - eversoncdantas@gmail.com
@since 14/07/2015
@version 1.0
/*/
Static Function fCheckProd(nX)
	Local cUMXML := aCols[nX][fGetIndice("D1_XUMXML")]
	Local aCor   := { 0, "BR_VERMELHO"}
	Local lRet   := .F.
	
	If !(cTipo $ "DB")
		lRet := ProdxFornece(cCodFor+cLojFor+aCols[nX][3])
	Else
		lRet := ProdxCliente(cCodFor+cLojFor+aCols[nX][fGetIndice("A5_CODPRF")])
	EndIf
	
	If lRet
		SAH->(dbSetOrder(1))
		
		// Valida a UM caso haja compatibilidade de tamanho entre os campos chaves
		If TamSX3("AH_UNIMED")[1] <> TamSX3("D1_XUMXML")[1] .Or. Empty(cUMXML) .Or. SAH->(dbSeek(XFILIAL("SAH")+cUMXML))
			aCor := { 2, "BR_VERDE"}
		Else
			aCor := { 1, "BR_AMARELO"}
		Endif
	Endif
	
	aCols[nX][1]         := LoadBitmap( GetResources(), aCor[2] )
	aCols[nX][nFldUse+1] := aCor[1]   // Flag de PRODUTO e UM ok

Return

Static Function ProdxFornece(cSeek)
	Local nReg := 0
	
	cSeek := SA5->(xFilial("SA5"))+cSeek
	
	SA5->(dbSetOrder(14))    // A5_FILIAL+A5_FORNECE+A5_LOJA+A5_CODPRF
	If SA5->(dbSeek(cSeek,.T.))
		If StatusProduto(SA5->A5_PRODUTO)
			nReg := SA5->(Recno())   // Salva o 1o registro encontrato
		Endif
		
		// Posiciona no Cadastro do Fornecedor
		SA2->(dbSetOrder(1))
		SA2->(dbSeek(XFILIAL("SA2")+SA5->A5_FORNECE+SA5->A5_LOJA))
		
		While !SA5->(Eof()) .And. SA5->A5_FILIAL+SA5->A5_FORNECE+SA5->A5_LOJA+SA5->A5_CODPRF == cSeek
			If StatusProduto(SA5->A5_PRODUTO,.T. /*SA2->A2_WSERIAL=="1"*/)
				nReg := SA5->(Recno())
				Exit
			Endif
			SA5->(dbSkip())
		Enddo
		
		If nReg > 0
			SA5->(dbGoTo(nReg))  // Posiciona no registro encontrado
		Endif
	Endif

Return nReg > 0

Static Function ProdxCliente(cSeek)
	Local nReg := 0
	
	cSeek := SA7->(xFilial("SA7")) + cSeek
	
	SA7->(dbSetOrder(3))    // A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_CODCLI
	If SA7->(dbSeek(cSeek,.T.))
		If StatusProduto(SA7->A7_PRODUTO)
			nReg := SA7->(Recno())
		Endif
		While !SA7->(Eof()) .And. SA7->A7_FILIAL+SA7->A7_CLIENTE+SA7->A7_LOJA+SA7->A7_CODCLI == cSeek
			If StatusProduto(SA7->A7_PRODUTO,.T.)
				nReg := SA7->(Recno())
				Exit
			Endif
			SA7->(dbSkip())
		Enddo
		If nReg > 0
			SA7->(dbGoTo(nReg))  // Posiciona no registro encontrado
		Endif
	Endif

Return nReg > 0

Static Function StatusProduto(cProduto,lSerial)
	Local lRet := .F.
	
	Default lSerial := .F.
	
	SB1->(dbSetOrder(1))
	If lRet := SB1->(dbSeek(XFILIAL("SB1")+cProduto))
		lRet := (SB1->B1_MSBLQL <> "1") // .And. (!lSerial .Or. /*SB1->B1_XSRIMEI == "E" .Or.*/ !(SubStr(SB1->B1_GRUPO,2,2) $ "AC,AM,PA,RO,RR")))
	Endif
	
Return lRet

/*/{Protheus.doc} fLimpaTela
Limpa dados da tela.
@author Everson Dantas - eversoncdantas@gmail.com
@since 14/07/2015
@version 1.0
/*/
Static Function fLimpaTela(nOp)
	Local nI
	Local lResposta := .T.
	
	If nOp == 0
		lResposta := FWAlertYesNo("A tela voltará para seu estado original. Prosseguir com ação?","Limpar tela")
	Endif
	
	If lResposta
		lEmite   := .F.
		aSA5Pend := {}
		aCols    := {}
		
		//Cria casca do aCols vazio
		Aadd(aCols,Array(nFldUse+2))
		For nI := 1 To nFldUse
			aCols[1][nI] := CriaVar(aHeader[nI][2])
		Next
		
		//Esvazia campos da tela
		aCols[1][nFldUse+1] := 0    // Flag de PRODUTO e UM ok
		aCols[1][nFldUse+2] := .F.  // Flag de deleção
		
		InicEmpFilSM0(cFilAux)
		
		lNFCad     := .F.
		cDoc       := ""
		cSerie     := ""
		cDtEmiss   := ""
		cCodFor    := ""
		cLojFor    := ""
		cNomFor    := ""
		cMsgErro   := ""
		//M->ARQUIVO := Space(200)
		cTipoNF    := " "
		oTpoNF:nAt := 1
		lFile      := .T.
		
		nTotMerc   := 0
		nTotDesc   := 0
		nTotFre    := 0
		nTotSeg    := 0
		nTotDesp   := 0
		nTotICST   := 0
		nTotIPI    := 0
		nTotDeso   := 0
		nTotAFR    := 0
		nTotSCM    := 0
		nTotGer    := 0
		
		StatusObjetos()
		
		//Atualiza campos na tela
		oDoc:Refresh()
		oDtEmiss:Refresh()
		oCodFor:Refresh()
		oNomFor:Refresh()
		oItens:Refresh()
		oMsgErro:Refresh()
		oArquivo:Refresh()
		oTpoNF:Refresh()
		
		oMerc:Refresh()
		oDesc:Refresh()
		oFrete:Refresh()
		oSegur:Refresh()
		oDesp:Refresh()
		oICMST:Refresh()
		oIPI:Refresh()
		oDeson:Refresh()
		oGeral:Refresh()
	Endif
Return


/*/{Protheus.doc} fExistForn
Verifica se já existe o fornecedor.
@author Everson Dantas - eversoncdantas@gmail.com
@since 13/07/2015
@version 1.0
/*/
Static Function fExistForn()
	Local nReg  := 0
	Local nBlq  := 0
	Local lBloq := GetMV("MV_XSA2BLQ",.F.,.T.)    // Define se alerta para fornecedor bloqueado
	Local cSeek := SA2->(XFILIAL("SA2"))+cCNPJ
	
	SA2->(dbSetOrder(3))
	If lRet := SA2->(dbSeek(cSeek,.T.))
		nBlq := SA2->(Recno())
		While !SA2->(Eof()) .And. SA2->A2_FILIAL+SA2->A2_CGC == cSeek
			If SA2->A2_INSCR == cINSCR    // Tenta melhorar a pesquisa considerando a inscrição estadual
				If SA2->A2_MSBLQL <> "1"
					nReg := SA2->(Recno())
					Exit
				Else
					nBlq := SA2->(Recno())
				Endif
			Endif
			SA2->(dbSkip())
		Enddo
		
		SA2->(dbGoTo(If(nReg>0,nReg,nBlq)))    // Posiciona no registro válido
		lRet := (lBloq .Or. SA2->A2_MSBLQL <> "1")
	Endif
	
	If lRet
		cCodFor := SA2->A2_COD
		cLojFor := SA2->A2_LOJA
		If lRet := (SA2->A2_MSBLQL <> "1")
		Else
			FWAlertWarning("O Fornecedor dessa nota encontra-se bloqueado. Favor solicitar o desbloqueio para continuar o processo de importação do XML !")
		Endif
	Else
		cCodFor := CriaVar("A2_COD" ,.F.)
		cLojFor := CriaVar("A2_LOJA",.F.)
	Endif

Return lRet

/*/{Protheus.doc} fExistCli
Verifica se já existe o fornecedor.
@author Everson Dantas - eversoncdantas@gmail.com
@since 13/07/2015
@version 1.0
/*/
Static Function fExistCli()
	Local nReg  := 0
	Local cSeek := SA1->(XFILIAL("SA1"))+cCNPJ
	
	SA1->(dbSetOrder(3))
	If lRet := SA1->(dbSeek(cSeek,.T.))
		nReg := SA1->(Recno())
		While !SA1->(Eof()) .And. SA1->A1_FILIAL+SA1->A1_CGC == cSeek
			If SA1->A1_INSCR == cINSCR    // Tenta melhorar a pesquisa considerando a inscrição estadual
				nReg := SA1->(Recno())
				Exit
			Endif
			SA1->(dbSkip())
		Enddo
		SA1->(dbGoTo(nReg))    // Posiciona no registro válido
	Endif

Return lRet

/*/{Protheus.doc} fIncluiForn
Abre o rotina padrão de cadastro de fornecedor, caso o fornecedor exibido na nota não esteja cadastrado no sistema.
@author Everson Dantas - eversoncdantas@gmail.com
@since 13/07/2015
@version 1.0
/*/
Static Function fIncluiForn(aPerg)
	Local nOpc    := 0
	Local aAcho   := {}
	Local lRet    := .F.
	Local cTudoOk := ".T."
	
	SA2->(dbSetOrder(1))
	
	cCadastro := "Cadastro de Fornecedor - Importação de Arquivo XML"
	
	fAchaCampos("SA2",@aAcho)
	
	nOpc := AxInclui ("SA2", 0, 3,aAcho,"U_CadSA2Cpo()",aAcho,cTudoOk,,,,)
	
	If nOpc <> 3 .And. nOpc <> 0
		lRet := fCarrArq(aPerg)
	Else
		fErroForn()
	EndIf

Return lRet

/*/{Protheus.doc} fIncluiCli
Abre o rotina padrão de cadastro de fornecedor, caso o fornecedor exibido na nota não esteja cadastrado no sistema.
@author Everson Dantas - eversoncdantas@gmail.com
@since 13/07/2015
@version 1.0
/*/
Static Function fIncluiCli(aPerg)
	Local nOpc    := 0
	Local aAcho   := {}
	Local cTudoOk := ".T."
	Local lRet    := .F.
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	
	cCadastro := "Cadastro de Cliente - Importação de Arquivo XML"
	
	fAchaCampos("SA1",@aAcho)
	
	nOpc := AxInclui ("SA1", 0, 3,aAcho,"U_CadSA1Cpo()",aAcho,cTudoOk,,,,)
	
	If nOpc <> 3 .And. nOpc <> 0
		lRet := fCarrArq(aPerg)
	Else
		fErroForn()
	EndIf

Return lRet

/*/{Protheus.doc} fIncProd
Realiza o processo de montagem de tela de cadastro de produto (traz os campos e monta a tela padrão AxInclui).
@author Everson Dantas - eversoncdantas@gmail.com
@since 14/07/2015
@version 1.0
/*/
Static Function fIncProd(cDescXml,cUnidXml,cNCM,cEAN)
	Local nX
	Local aAcho    := {}
	Local nOpc     := 0
	Local aAchoSB1 := {}
	Local cTudoOk  := ".T."
	Local lRet     := .F.
	Local nSaveSX8 := GetSx8Len()   // Variavel que controla numeracao
	
	Private aCampos := CamposProduto()
	Private aSb1Det := {cDescXml,cEAN,cUnidXml,cNCM}
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	
	cCadastro := "Cadastro de Produtos"
	
	//Traz os campos que serão exibidos e os coloca no vetor aAchoSB1
	fAchaCampos("SB1",@aAcho)
	
	// Filtra somente os campos obrigatórios ou solicitados pelo cliente
	For nX:=1 To Len(aAcho)
		If X3Obrigat(aAcho[nX]) .Or. AScan( aCampos , {|x| x[1] == Trim(aAcho[nX]) } ) > 0
			AAdd( aAchoSB1 , aAcho[nX] )
		ElseIf !Empty( CriaVar(aAcho[nX],.T.) )   // Carrega campos com conteúdos pré-preenchidos
			AAdd( aAchoSB1 , aAcho[nX] )
		Endif
	Next
	AAdd( aAchoSB1 , "NOUSER" )
	
	While ( GetSx8Len() > nSaveSX8 )
		RollBackSX8()
	Enddo
	
	//Mostra tela de cadastro padrão no formato Enchoice
	If ExistBlock("RSA010IncPeC")
		lCopia := .F.
		nOpc := u_RSA010IncPeC("SB1", 0, 3,"U_CadCpoSB1()",/*aAchoSB1*/,cTudoOk,/*aButtons*/,/*lVirtual*/,aAchoSB1)
	Else
		nOpc := AxInclui("SB1", 0, 3,aAchoSB1,"U_CadCpoSB1()",/*aAchoSB1*/,cTudoOk,,,,)
	Endif
	
	//Retorna o Código do Produto cadastrado para o aCols e o atualiza, em seguida cria a amarração Prod x Forn (SA5).
	If nOpc <> 3 .And. nOpc <> 0
		aCols[n][fGetIndice("B1_COD"   )] := SB1->B1_COD
		aCols[n][fGetIndice("B1_DESC"  )] := SB1->B1_DESC
		aCols[n][fGetIndice("D1_LOCAL" )] := SB1->B1_LOCPAD
		aCols[n][fGetIndice("B1_ORIGEM")] := SB1->B1_ORIGEM
		oItens:Refresh()
		
		//Deixa a legenda verde (produto cadastrado)
		fCheckProd(n)
		
		If lRet := fAllProdOK()
			//Cria a amarração Prod x Forn
			lRet := fIncAmarr(cCodFor,cLojFor,aCols[n][fGetIndice("B1_COD")],aCols[n][fGetIndice("A5_CODPRF")],cNomFor,aCols[n][fGetIndice("B1_DESC")])
		Endif
	EndIf
	
Return lRet

Static Function fCadCompl()
	Local nOpc  := 0
	Local aAcho := {}
	Local cProd := aCols[n][fGetIndice("B1_COD")]
	Local lRet  := .F.
	
	If !Empty( cProd )
		// Posiciona no Cadastro do Produto
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(XFILIAL("SB1")+cProd))
		
		cCadastro := "Cadastro de Complemento do Produto"
		
		AAdd( aAcho , "B5_COD"      )
		AAdd( aAcho , "B5_CEME"     )
		AAdd( aAcho , "B5_ESPESS"   )
		AAdd( aAcho , "B5_ESTMAT"   )
		AAdd( aAcho , "B5_LARG"     )
		AAdd( aAcho , "B5_CAMPR"    )
		AAdd( aAcho , "B5_LARGLC"   )
		AAdd( aAcho , "B5_ALTURLC " )
		AAdd( aAcho , "B5_FATARMA"  )
		AAdd( aAcho , "B5_COMPRLC " )
		AAdd( aAcho , "B5_CODTRAM"  )
		AAdd( aAcho , "B5_ZFMULTO"  )
		AAdd( aAcho , "B5_ZFMULTS"  )
		AAdd( aAcho , "B5_COMPR"    ) 
		AAdd( aAcho , "B5_AM4PORC"  )
		AAdd( aAcho , "B5_ZF4PORC"  )
		
		//fAchaCampos("SB5",@aAcho)
		SB5->(dbSetOrder(1))
		If SB5->(dbSeek(XFILIAL("SB5")+SB1->B1_COD))
			nOpc := AxAltera("SB5", SB5->(Recno()), 3,aAcho,/*"U_CadSB5Cpo()"*/,aAcho,/*cTudoOk*/,,,,)
		Else
			nOpc := AxInclui("SB5",              0, 3,aAcho,"U_CadSB5Cpo()",aAcho,/*cTudoOk*/,,,,)
		Endif
		
		/*If nOpc <> 3 .And. nOpc <> 0
			lRet := fCarrArq(aPerg)
		Else
			fErroForn()
		EndIf*/
	Else
		FWAlertError("Favor cadastrar o produto antes de complementar os dados !")
	Endif

Return lRet


/*/{Protheus.doc} fAchaCampos
Carrega todos os campos do dicionário de dados da tabela passada como parâmetro.
@author Everson Dantas - eversoncdantas@gmail.com
@since 14/07/2015
@version 1.0
@param cAlias, character, (Alias da tabela.)
@param aAcho, array, (Array com o nome dos campos que serão exibidos na interface.(tela))
@param aCpoXml, array, (Array com o nome dos campos que poderão ser editados.)
/*/
Static Function fAchaCampos(cAlias,aAcho,cCpoXml)
	Local nX
	Local aFields := FWSX3Util():GetAllFields(cAlias)     // Retorna todos os campos ativos para a tabela
	
	Default cCpoXml := ""
	
	For nX:=1 To Len(aFields)
		If X3USO(GetSx3Cache(aFields[nX], "X3_USADO")) .And. /*cNivel >= GetSx3Cache(aFields[nX], "X3_NIVEL") .And.*/ !(Trim(aFields[nX]) $ cCpoXml)
			AAdd( aAcho , Trim(aFields[nX]) )
		Endif
	Next
	
Return

/*/{Protheus.doc} CadCpoSB1
Pré-carrega alguns campos, diretamente do arquivo .xml, para ser utilizado pela Enchoice do AxInclui em questão.
@author Everson Dantas - eversoncdantas@gmail.com
@since 15/07/2015
@version 1.0
/*/
User Function CadCpoSB1()
	Local nX
	
	For nX:=1 To Len(aCampos)
		If aCampos[nX,2] <> Nil
			M->&( aCampos[nX,1] ) := Eval( aCampos[nX,2] )
		Endif
	Next
	
	M->B1_DESC   := aSb1Det[1]
	M->B1_CODBAR := aSb1Det[2]
	M->B1_POSIPI := aSb1Det[4]
	
	If !Empty(aSb1Det[3])
		M->B1_UM := ALLTRIM(aSb1Det[3])
	Endif

Return

/*/{Protheus.doc} CadSA5Cpo
Pré-carrega alguns campos, diretamente do arquivo .xml, para ser utilizado pela Enchoice do AxInclui em questão.
@author Everson Dantas - eversoncdantas@gmail.com
@since 15/07/2015
@version 1.0
/*/

Static Function CadSA5Cpo(cProduto)
	Local aFabric
	
	Default cProduto := ""
	
	M->A5_FORNECE := aSA5Det[1]
	M->A5_LOJA    := aSA5Det[2]
	M->A5_CODPRF  := aSA5Det[3]
	M->A5_NOMEFOR := SA2->A2_NOME
	
	If Empty(cProduto)
		M->A5_FABR    := "999999"
		M->A5_FALOJA  := "99"
	Else
		aFabric := Fabricante(aSA5Det[1]+aSA5Det[2]+cProduto)
		
		M->A5_FABR    := aFabric[1]
		M->A5_FALOJA  := aFabric[2]
	Endif

Return

/*/{Protheus.doc} CadSA7Cpo
Pré-carrega alguns campos, diretamente do arquivo .xml, para ser utilizado pela Enchoice do AxInclui em questão.
@author Everson Dantas - eversoncdantas@gmail.com
@since 15/07/2015
@version 1.0
/*/

Static Function CadSA7Cpo()
	M->A7_CLIENTE	:= aSA5Det[1]
	M->A7_LOJA		:= aSA5Det[2]
	M->A7_CODCLI	:= aSA5Det[3]
Return

/*/{Protheus.doc} CadSA2Cpo
Pré-carrega alguns campos, diretamente do arquivo .xml, para ser utilizado pela Enchoice do AxInclui em questão.
@author Everson Dantas - eversoncdantas@gmail.com
@since 15/07/2015
@version 1.0
/*/
User Function CadSA2Cpo()
	M->A2_CGC    := AllTrim(oXML:_nfe:_infnfe:_emit:_cnpj:text)
	M->A2_NOME   := AllTrim(oXML:_nfe:_infnfe:_emit:_xnome:text)
	M->A2_END    := AllTrim(oXML:_nfe:_infnfe:_emit:_enderEmit:_xLgr:text + " "+oXML:_nfe:_infnfe:_emit:_enderEmit:_nro:text)
	M->A2_BAIRRO := AllTrim(oXML:_nfe:_infnfe:_emit:_enderEmit:_xBairro:text)
	M->A2_NREDUZ := AllTrim(oXML:_nfe:_infnfe:_emit:_xnome:text)
	M->A2_CEP    := AllTrim(oXML:_nfe:_infnfe:_emit:_enderEmit:_CEP:text)
	M->A2_INSCR  := AllTrim(oXML:_nfe:_infnfe:_emit:_IE:text)
	M->A2_EST    := AllTrim(oXML:_nfe:_infnfe:_emit:_enderEmit:_UF:text)
	M->A2_MUN    := AllTrim(oXML:_nfe:_infnfe:_emit:_enderEmit:_xMun:text)
	
	CC2->(DbSetOrder(2))
	If CC2->(DbSeek(xFilial("CC2")+M->A2_MUN))
		M->A2_COD_MUN := CC2->CC2_CODMUN
	EndIf
	
Return

/*/{Protheus.doc} CadSA1Cpo
Pré-carrega alguns campos, diretamente do arquivo .xml, para ser utilizado pela Enchoice do AxInclui em questão.
@author Everson Dantas - eversoncdantas@gmail.com
@since 15/07/2015
@version 1.0
/*/
User Function CadSA1Cpo()
	M->A1_CGC    := AllTrim(oXML:_nfe:_infnfe:_emit:_cnpj:text)
	M->A1_NOME   := AllTrim(oXML:_nfe:_infnfe:_emit:_xnome:text)
	M->A1_END    := AllTrim(oXML:_nfe:_infnfe:_emit:_enderEmit:_xLgr:text + ", "+ oXML:_nfe:_infnfe:_emit:_enderEmit:_nro:text)
	M->A1_BAIRRO := AllTrim(oXML:_nfe:_infnfe:_emit:_enderEmit:_xBairro:text)
	M->A1_NREDUZ := AllTrim(oXML:_nfe:_infnfe:_emit:_xnome:text)
	M->A1_CEP    := AllTrim(oXML:_nfe:_infnfe:_emit:_enderEmit:_CEP:text)
	M->A1_INSCR  := AllTrim(oXML:_nfe:_infnfe:_emit:_IE:text)
	M->A1_EST    := AllTrim(oXML:_nfe:_infnfe:_emit:_enderEmit:_UF:text)
	M->A1_MUN    := AllTrim(oXML:_nfe:_infnfe:_emit:_enderEmit:_xMun:text)
	
	CC2->(DbSetOrder(2))
	
	If CC2->(DbSeek(xFilial("CC2")+M->A1_MUN))
		M->A1_COD_MUN  := CC2->CC2_CODMUN
	EndIf
Return

User Function CadSB5Cpo()
	M->B5_COD    := SB1->B1_COD
Return


/*/{Protheus.doc} fPreencItens
Carrega e valida os itens do XML.
@author Everson Dantas - eversoncdantas@gmail.com
@since 14/07/2015
@version 1.0
@param oDet, objeto, (Descrição do parâmetro)
@param cFornec, character, (Descrição do parâmetro)
@param cLojaFo, character, (Descrição do parâmetro)
/*/
Static Function fPreencItens(oDet,cFornec,cLojaFo, cNomeFor)
	Local nI, nJ
	Local aItens   := {}
	Local lConcDes := .F.
	Local aColsAux := Array(Len(aCampos)+2)
	
	/*
	Itens do corpo da NotaFiscal (aCols)
	*/
	Local cItem    := PADL(ALLTRIM(cValToChar(Val(oDet:_nItem:text))),4,"0") 
	Local cProdFor := PADR(AllTrim(oDet:_prod:_cprod:text),Len(SA5->A5_CODPRF))
	Local cProduto := Space(Len(SA5->A5_PRODUTO))
	Local cDescSD1 := PADR(If(lConcDes,AllTrim(oDet:_prod:_cprod:text)+" ","")+AllTrim(oDet:_prod:_xprod:text),Len(SB1->B1_DESC))
	Local cNCM_NF  := PADR(AllTrim(oDet:_prod:_ncm:text)  ,Len(SB1->B1_POSIPI))
	Local cUM      := PADR(Upper(AllTrim(oDet:_prod:_uCom:text)),Len(SB1->B1_UM))
	Local cSEGUM   := PADR("" ,Len(SB1->B1_SEGUM))
	Local cEAN     := AllTrim(oDet:_prod:_cean:text)
	Local cPedido  := Space(Len(SD1->D1_PEDIDO))
	Local cItemPC  := Space(Len(SD1->D1_ITEMPC))
	Local cLocal   := ""
	Local cNfori   := ""
	Local cSeriori := ""
	Local cItemori := ""
	Local cIdentb6 := ""
	Local cDescSB1 := ""
	Local nQtd     := Val(oDet:_prod:_qcom:text)
	Local nQtd2UM  := 0
	Local nVunit   := Val(oDet:_prod:_vuncom:text)
	Local nPrc2UM  := 0
	Local nTotal   := Val(oDet:_prod:_vprod:text)
	Local nValDesc := Val(oDet:_prod:_vdesc:text)
	Local nFrete   := Val(oDet:_prod:_vfrete:text)
	Local nSeguro  := Val(oDet:_prod:_vseg:text)
	Local nDespesa := Val(oDet:_prod:_voutro:text)
	Local cCSTIPI  := ""
	Local nBaseIPI := 0
	Local nVlrIPI  := 0
	Local cCSTPIS  := ""
	Local nBasePIS := 0
	Local nPPIS    := 0
	Local nVlrPIS  := 0
	Local cCSTCOF  := ""
	Local nBCOFINS := 0
	Local nPCOFINS := 0
	Local nVCOFINS := 0
	Local nBaseII  := 0
	Local nVlrII   := 0
	Local nAFRMM   := 0
	Local nSISCOM  := 0
	Local cCEST    := ""
	Local cDI      := ""
	Local dDtDI    := CtoD("")
	Local cOrigem  := ""
	Local nICMSDes := 0
	Local cCSTICMS := ""
	Local nBaseICM := 0
	Local nPICMS   := 0
	Local nVlrICMS := 0
	Local nMargem  := 0
	Local nBCIcmsSt:= 0
	Local nIcmsSt  := 0
	Local cCusto   := Space(Len(SD1->D1_CC))
	Local cConta   := Space(Len(SD1->D1_CONTA))
	Local cDescrXML:= AllTrim(oDet:_prod:_xprod:text)
	Local cUMXML   := PADR(Upper(AllTrim(oDet:_prod:_uCom:text)),TamSX3("D1_XUMXML")[1])
	Local nQtdXML  := Val(oDet:_prod:_qcom:text)
	Local lItemOk  := .F.
	Local aCodCST  := {}
	Local aTagCST  := {}
	Local aCST     := {}
	Local nVLdolar := val(oDet:_prod:_VLFOBMOEDA:text)
	
	ntxDolar := val(oDet:_prod:_VLTXMOEDAMLE:text)
	XmlNewNode(oDet:_prod,'_CEST' ,'CEST' ,'NOD')
	cCEST := Trim(oDet:_prod:_CEST:text)
	
	XmlNewNode(oDet:_prod,'_DI' ,'DI' ,'NOD')
	XmlNewNode(oDet:_prod:_DI,'_NDI' ,'NDI' ,'NOD')
	XmlNewNode(oDet:_prod:_DI,'_DDI' ,'DDI' ,'NOD')
	
	cDI   := oDet:_prod:_DI:_nDI:text
	dDtDI := StoD(StrTran(oDet:_prod:_DI:_dDI:text,"-",""))
	
	If SD1->(FieldPos("D1_AFRMIMP")) > 0
		XmlNewNode(oDet:_prod:_DI,'_VAFRMM' ,'VAFRMM' ,'NOD')
		
		nAFRMM := Val( oDet:_prod:_DI:_vAFRMM:text )
	Endif
	
	/*
	Fim do corpo da NotaFiscal (aCols)
	*/
	If XmlChildEx(oDet:_imposto,"_ICMS") != Nil
		// Tags referente os CST do ICMS da Nota
		AAdd( aCodCST , "_ICMS00" )
		AAdd( aCodCST , "_ICMS10" )
		AAdd( aCodCST , "_ICMS20" )
		AAdd( aCodCST , "_ICMS30" )
		AAdd( aCodCST , "_ICMS40" )
		AAdd( aCodCST , "_ICMS41" )
		AAdd( aCodCST , "_ICMS50" )
		AAdd( aCodCST , "_ICMS51" )
		AAdd( aCodCST , "_ICMS60" )
		AAdd( aCodCST , "_ICMS70" )
		AAdd( aCodCST , "_ICMS90" )
		
		AAdd( aTagCST , { "cOrigem"  , "_ORIG"})
		AAdd( aTagCST , { "cCSTICMS" , "_ORIG"})
		AAdd( aTagCST , { "cCSTICMS" , "_CST"})
		AAdd( aTagCST , { "nBaseICM" , "_VBC"})
		AAdd( aTagCST , { "nPICMS"   , "_PICMS"})
		AAdd( aTagCST , { "nVlrICMS" , "_VICMS"})
		AAdd( aTagCST , { "nMargem"  , "_PMVAST"})
		AAdd( aTagCST , { "nIcmsSt"  , "_VICMSST"})
		AAdd( aTagCST , { "nBCIcmsSt", "_VBCST"  })
		AAdd( aTagCST , { "nICMSDes" , "_VICMSDESON"} )
		
		If Empty( aCST := ExtraiCST(oDet,aCodCST,aTagCST) )
			aCodCST := {}
			aTagCST := {}
			
			AAdd( aCodCST , "_ICMSSN101" )
			AAdd( aCodCST , "_ICMSSN102" )
			AAdd( aCodCST , "_ICMSSN103" )
			AAdd( aCodCST , "_ICMSSN201" )
			AAdd( aCodCST , "_ICMSSN202" )
			AAdd( aCodCST , "_ICMSSN203" )
			AAdd( aCodCST , "_ICMSSN300" )
			AAdd( aCodCST , "_ICMSSN400" )
			AAdd( aCodCST , "_ICMSSN500" )
			AAdd( aCodCST , "_ICMSSN900" )
			
			AAdd( aTagCST , { "cOrigem"  , "_ORIG"})
			AAdd( aTagCST , { "cCSTICMS" , "_ORIG"})
			AAdd( aTagCST , { "cCSTICMS" , "_CSOSN"})
			//AAdd( aTagCST , { "cOrigem"  , "_PCREDSN"})
			//AAdd( aTagCST , { "cOrigem"  , "_VCREDICMSSN"})
			
			aCST := ExtraiCST(oDet,aCodCST,aTagCST)
		Endif
		
		For nJ:=1 To Len(aCST)
			&( aCST[nJ,1] ) += aCST[nJ,2]
		Next
	Endif
	
	// Adiciona os valores referente ao IPI
	If XmlChildEx(oDet:_imposto,"_IPI") != Nil
		XmlNewNode(oDet:_imposto:_IPI,'_IPITRIB' ,'IPITRIB' ,'NOD')
		XmlNewNode(oDet:_imposto:_IPI:_IPITRIB,'_CST' ,'CST' ,'NOD')
		XmlNewNode(oDet:_imposto:_IPI:_IPITRIB,'_VBC' ,'VBC' ,'NOD')
		XmlNewNode(oDet:_imposto:_IPI:_IPITRIB,'_vIPI','vIPI','NOD')
		
		// DESABILITADO POR SOLICITAÇÃO DA ANNE SOCORRO - 24/07/2024
		cCSTIPI  := ""  //oDet:_imposto:_IPI:_IPITRIB:_CST:text
		nBaseIPI := 0   //Val( oDet:_imposto:_IPI:_IPITRIB:_vBC:text )
		nVlrIPI  := 0   //Val( oDet:_imposto:_IPI:_IPITRIB:_vIPI:text )
		
		If Empty(cCSTIPI)
			XmlNewNode(oDet:_imposto:_IPI,'_IPINT' ,'IPINT' ,'NOD')
			XmlNewNode(oDet:_imposto:_IPI:_IPINT,'_CST' ,'CST' ,'NOD')
			
			XmlNewNode(oDet:_imposto:_IPI,'_VBC' ,'VBC' ,'NOD')
			XmlNewNode(oDet:_imposto:_IPI,'_vIPI','vIPI','NOD')
			
			//cCSTIPI  := oDet:_imposto:_IPI:_PISALIQ:_CST:text
			cCSTIPI  := If( Empty(cCSTIPI) , oDet:_imposto:_IPI:_IPINT:_CST:text, cCSTIPI)
			nBaseIPI := Val( oDet:_imposto:_IPI:_vBC:text )
			nVlrIPI  := Val( oDet:_imposto:_IPI:_vIPI:text )
		Endif
	Endif
	
	// Adiciona os valores referente ao PIS
	If XmlChildEx(oDet:_imposto,"_PIS") != Nil
		XmlNewNode(oDet:_imposto:_PIS,'_PISNT' ,'PISNT' ,'NOD')
		XmlNewNode(oDet:_imposto:_PIS:_PISNT,'_CST' ,'CST' ,'NOD')
		
		XmlNewNode(oDet:_imposto:_PIS,'_PISALIQ' ,'PISALIQ'  ,'NOD')
		XmlNewNode(oDet:_imposto:_PIS:_PISALIQ,'_CST' ,'CST' ,'NOD')
		XmlNewNode(oDet:_imposto:_PIS:_PISALIQ,'_VBC' ,'VBC' ,'NOD')
		XmlNewNode(oDet:_imposto:_PIS:_PISALIQ,'_PPIS','PPIS','NOD')
		XmlNewNode(oDet:_imposto:_PIS:_PISALIQ,'_VPIS','VPIS','NOD')
		
		cCSTPIS  := oDet:_imposto:_PIS:_PISALIQ:_CST:text
		cCSTPIS  := If( Empty(cCSTPIS) , oDet:_imposto:_PIS:_PISNT:_CST:text, cCSTPIS)
		nBasePIS := Val( oDet:_imposto:_PIS:_PISALIQ:_vBC:text )
		nPPIS    := Val( oDet:_imposto:_PIS:_PISALIQ:_pPIS:text )
		nVlrPIS  := Val( oDet:_imposto:_PIS:_PISALIQ:_vPIS:text )
	Endif
	
	// Adiciona os valores referente ao COFINS
	If XmlChildEx(oDet:_imposto,"_COFINS") != Nil
		XmlNewNode(oDet:_imposto:_COFINS,'_COFINSNT','COFINSNT' ,'NOD')
		XmlNewNode(oDet:_imposto:_COFINS:_COFINSNT,'_CST' ,'CST','NOD')
		
		XmlNewNode(oDet:_imposto:_COFINS,'_COFINSALIQ' ,'COFINSALIQ' ,'NOD')
		XmlNewNode(oDet:_imposto:_COFINS:_COFINSALIQ,'_CST' ,'CST' ,'NOD')
		XmlNewNode(oDet:_imposto:_COFINS:_COFINSALIQ,'_VBC' ,'VBC' ,'NOD')
		XmlNewNode(oDet:_imposto:_COFINS:_COFINSALIQ,'_PCOFINS','PCOFINS','NOD')
		XmlNewNode(oDet:_imposto:_COFINS:_COFINSALIQ,'_VCOFINS','VCOFINS','NOD')
		
		cCSTCOF  := oDet:_imposto:_COFINS:_COFINSALIQ:_CST:text
		cCSTCOF  := If( Empty(cCSTCOF) , oDet:_imposto:_COFINS:_COFINSNT:_CST:text, cCSTCOF)
		nBCOFINS := Val( oDet:_imposto:_COFINS:_COFINSALIQ:_vBC:text )
		nPCOFINS := Val( oDet:_imposto:_COFINS:_COFINSALIQ:_pCOFINS:text )
		nVCOFINS := Val( oDet:_imposto:_COFINS:_COFINSALIQ:_vCOFINS:text )
	Endif
	
	// Adiciona os valores referente ao II
	If XmlChildEx(oDet:_imposto,"_II") != Nil
		XmlNewNode(oDet:_imposto:_II,'_vBC','vBC','NOD')
		XmlNewNode(oDet:_imposto:_II,'_vII','vII','NOD')
		
		nBaseII := Val( oDet:_imposto:_II:_vBC:text )
		nVlrII  := Val( oDet:_imposto:_II:_vII:text )
		//nTotal  += nVlrII
		//nVunit  := Round( nTotal / nQtd, TamSX3("D1_VUNIT")[2])
	Endif
	
	If Empty(cTipoNF) .Or. AScan( aTipos , cTipoNF ) == 0
		If SubStr(AllTrim(oDet:_prod:_cfop:text),2,3) $ "201,202,208,209,210,213,214,215,231,232,410,411,412,503,553,555,556,661,662,918,919,921"
			cTipo := "D"
		ElseIf SubStr(AllTrim(oDet:_prod:_cfop:text),2,3) $ "131,414,415,451,501,502,504,505,554,657,663,666,901,904,905,908,910,911,912,914,915,917,920,923,924,934" //"664,665,902,903,906,907,909,913,916,925"
			cTipo := "B"
		Else
			cTipo := "N"
		Endif
	Else
		cTipo := aAuxTpo[AScan( aTipos , cTipoNF )]
	Endif
	
	nSISCOM := Max(0,nDespesa - nVlrPIS - nVCOFINS - nAFRMM)
	
	PesqCabItens(.F.)    // Atualiza os dados do cabeçalho
	
	//Verifica se existe a amarração entre Produto e o Fornecedor
	If !(cTipo $ "DB")
		If lItemOk := ProdxFornece(cFornec+cLojaFo+cProdFor)
			cProduto := SA5->A5_PRODUTO
		Else
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(XFILIAL("SB1")+cProdFor)) .And. AScan( aSA5Pend , {|x| x[1]+x[2]+x[3] == cFornec+cLojaFo+SB1->B1_COD }) == 0
				AAdd( aSA5Pend , { cFornec, cLojaFo, SB1->B1_COD, SB1->B1_DESC, 0})
			Endif
		EndIf
	Else
		If lItemOk := ProdxCliente(cFornec+cLojaFo+cProdFor)
			cProduto := SA7->A7_PRODUTO
		EndIf
	EndIf
	
	If lItemOk
		//Verifica se existe o produto contido na amarração, caso exista, traz alguns dados desse produto
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+cProduto))
			cLocal   := SB1->B1_LOCPAD
			cUM      := SB1->B1_UM
			cSEGUM   := SB1->B1_SEGUM 
			cDescSB1 := SB1->B1_DESC
			cOrigem  := If( Empty(cOrigem) , SB1->B1_ORIGEM, cOrigem)
		EndIf
	Endif
	
	aColsAux[Len(aColsAux)-1] := lItemOk    // Flag de produto ok
	nQtd2UM := ConvUM(cProduto, nQtd, 0, 2)
	
	AADD(aItens, {"B1_OK"     , "" })
	AADD(aItens, {"D1_ITEM"   , cItem})
	AADD(aItens, {"A5_CODPRF" , cProdFor})
	AADD(aItens, {"B1_COD"    , cProduto})
	AADD(aItens, {"B1_DESC"   , If(!Empty(cDescSB1),cDescSB1,cDescSD1)})
	AADD(aItens, {"B1_POSIPI" , cNCM_NF})
	AADD(aItens, {"CY_PENDEN" , "N"})
	AADD(aItens, {"D1_UM"     , cUM})
	AADD(aItens, {"D1_SEGUM"  , cSEGUM})
	AADD(aItens, {"D1_QUANT"  , nQtd})
	AADD(aItens, {cFldDesc    , If(!Empty(cDescSD1),Left(cDescSD1,TamSX3(cFldDesc)[1]),left(cDescSB1,TamSX3(cFldDesc)[1]))})
	AADD(aItens, {"D1_QTSEGUM", nQtd2UM})
	AADD(aItens, {"D1_VUNIT"  , nVunit})
	AADD(aItens, {"D1_CUSFF2" , nPrc2UM})
	AADD(aItens, {"D1_FORNECE", cFornec})
	AADD(aItens, {"D1_LOJA"   , cLojaFo})
	AADD(aItens, {"D1_TOTAL"  , nTotal})
	AADD(aItens, {"D1_VALDESC", nValDesc})
	AADD(aItens, {"D1_CLASFIS", cCSTICMS})
	AADD(aItens, {"D1_BASEICM", nBaseICM})
	AADD(aItens, {"D1_PICM"   , nPICMS})
	AADD(aItens, {"D1_VALICM" , nVlrICMS})
	AADD(aItens, {"D1_MARGEM" , nMargem})
	AADD(aItens, {"D1_BRICMS" , nBCIcmsSt})
	AADD(aItens, {"D1_ICMSRET", nIcmsSt})
	AADD(aItens, {"D1_CC"     , cCusto})
	AADD(aItens, {"D1_CONTA"  , cConta})
	AADD(aItens, {"D1_LOCAL"  , cLocal})
	AADD(aItens, {"B1_CODBAR" , cEAN})
	AADD(aItens, {"D1_PEDIDO" , cPedido})
	AADD(aItens, {"D1_ITEMPC" , cItemPC})
	AADD(aItens, {"D1_NFORI"  , RIGHT(cNfori,9)})
	AADD(aItens, {"D1_SERIORI", cSeriori})
	AADD(aItens, {"D1_ITEMORI", cItemori})
	AADD(aItens, {"D1_IDENTB6", cIdentb6})
	AADD(aItens, {"D1_VALFRE" , nFrete})
	AADD(aItens, {"D1_SEGURO" , nSeguro})
	AADD(aItens, {"D1_DESPESA", nDespesa})
	If SD1->(FieldPos("D1_XCSTIPI")) > 0
		AADD(aItens, {"D1_XCSTIPI", cCSTIPI})
	Endif
	AADD(aItens, {"D1_BASEIPI", nBaseIPI})
	AADD(aItens, {"D1_VALIPI" , nVlrIPI})
	If SD1->(FieldPos("D1_XCSTPIS")) > 0
		AADD(aItens, {"D1_XCSTPIS", cCSTPIS})
	Endif
	If SD1->(FieldPos(cFldVII)) > 0
		AADD(aItens, {cFldPII, Round(nVlrII / nBaseII * 100, TamSX3(cFldPII)[2])})
		AADD(aItens, {cFldVII    , nVlrII})
	Endif
	If SD1->(FieldPos("D1_AFRMIMP")) > 0
		AADD(aItens, {"D1_AFRMIMP", nAFRMM})
	Endif
	If SD1->(FieldPos("D1_XSISCOM")) > 0
		AADD(aItens, {"D1_XSISCOM", nSISCOM})
	Endif
	AADD(aItens, {"D1_BASIMP6", nBasePIS})
	AADD(aItens, {"D1_ALQIMP6", nPPIS})
	AADD(aItens, {"D1_VALIMP6", nVlrPIS})
	If SD1->(FieldPos("D1_XCSTCOF")) > 0
		AADD(aItens, {"D1_XCSTCOF", cCSTCOF})
	Endif
	AADD(aItens, {"D1_BASIMP5", nBCOFINS})
	AADD(aItens, {"D1_ALQIMP5", nPCOFINS})
	AADD(aItens, {"D1_VALIMP5", nVCOFINS})
	AADD(aItens, {"F1_XDI"    , cDI})
	AADD(aItens, {"F1_XDTDI"  , dDtDI})
	AADD(aItens, {"B1_CEST"   , cCEST})
	AADD(aItens, {"B1_ORIGEM" , cOrigem})
	AADD(aItens, {"D1_DESCZFR", nICMSDes})
	AADD(aItens, {"D1_XDESXML", cDescrXML})
	AADD(aItens, {"D1_XUMXML" , cUMXML})
	AADD(aItens, {"D1_XQTDXML", nQtdXML})

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
	
	fCheckProd(Len(aCols))

	nTTdolar += nVLdolar
	nTotMerc += nTotal
	nTotDesc += nValDesc
	nTotFre  += nFrete
	nTotSeg  += nSeguro
	nTotDesp += nDespesa
	nTotICST += nIcmsSt
	nTotIPI  += nVlrIPI
	nTotDeso += nICMSDes
	nTotAFR  += nAFRMM
	nTotSCM  += nSISCOM

Return .T.

Static Function ExtraiCST(oDet,aCodCST,aTagCST)
	Local nI, nJ, oTag, cTag
	Local aRet := {}
	
	For nI:=1 To Len(aCodCST)
		If XmlChildEx(oDet:_imposto:_icms,aCodCST[nI]) != Nil
			
			oTag := &( "oDet:_imposto:_icms:" + aCodCST[nI] )
			
			For nJ:=1 To Len(aTagCST)
				If XmlChildEx(oTag,aTagCST[nJ,2]) != Nil
					cTag := "oDet:_imposto:_icms:" + aCodCST[nI] + ":" + aTagCST[nJ,2] + ":text"
					AAdd( aRet , { aTagCST[nJ,1] , If(Upper(Left(aTagCST[nJ,1],1))=="N",Val(&( cTag )),Trim(&( cTag )))} )
				EndIf
			Next
			
			Exit
		Endif
	Next

Return aRet

Static Function PesqCabItens(lItens)
	Local nX, cProduto
	Local lOk   := .F.
	Local nPPrd := fGetIndice("A5_CODPRF")
	
	If AScan( aAuxTpo , cTipo ) > 0
		cTipoNF := aTipos[AScan( aAuxTpo , cTipo )]
		oTpoNF:Refresh()
	Endif
	
	If cTipo $ "DB"
		cLegCodF := "Código/Loja Cliente"
		cLegNomF := "Nome Cliente"
		
		If lOk := fExistCli()
			cCodFor := SA1->A1_COD
			cLojFor := SA1->A1_LOJA
		EndIf
	Else
		cLegCodF := "Código/Loja Fornecedor"
		cLegNomF := "Nome Fornecedor"
		
		lOk := fExistForn()
	EndIf
	oSay5:Refresh()
	oSay6:Refresh()
	
	If lOk .And. lItens
		For nX:=1 To Len(aCols)
			cProduto := CriaVar("B1_COD",.F.)
			
			//Verifica se existe a amarração entre Produto e o Fornecedor
			If !(cTipo $ "DB")
				If lOk := ProdxFornece(cCodFor+cLojFor+aCols[nX,nPPrd])
					cProduto := SA5->A5_PRODUTO
				EndIf
			ElseIf lOk := ProdxCliente(cCodFor+cLojFor+aCols[nX,nPPrd])
				cProduto := SA7->A7_PRODUTO
			EndIf
			
			aCols[nX,Len(aCols[nX])-1] := lOk    // Flag de produto ok
			
			AtualItem(cProduto,nX)
		Next
		
		oItens:Refresh()
	Endif
	
Return fAllProdOK()

/*/{Protheus.doc} fAllProdOK
Checa se todos os produtos estão cadastrados no sistema.
@author Everson Dantas - eversoncdantas@gmail.com
@since 03/08/2015
@version 1.0
@return ${lRet}, ${True, caso todos os produtos estejam cadastrados. False, caso contrário.}
/*/
Static Function fAllProdOK(lFinal)
	Local nI, nPIte, nPPrd, nPPed, nPItP, nPPrc, nPNCM, nPOri, cOrig, nPQtd, nPTOT, nPDes, nPreco //, nPICD
	Local lRet    := .T.
	Local lPedido := .T.
	Local aMailN  := {}
	Local aMailO  := {}
	Local nTam    := Len(aCols)
	Local nVlrTol := GetMV("MV_XTOLCEN",.F.,0.02)    // Tolerância de diferença de centavos
	Local nDec    := TamSX3("D1_VUNIT")[2]
	
	//Percorre aCols.. caso encontre alguma bolinha vermelha, atribui Falso.
	For nI := 1 To nTam
		If lRet := (aCols[nI][nFldUse+1] == 2)   // Flag de PRODUTO e UM ok
			If lFinal .And. Empty(Alltrim(aCols[nI][fGetIndice("D1_PEDIDO")]))
				lPedido := .F.
			EndIf
		ElseIf aCols[nI][nFldUse+1] == 1   // Caso o Produto esteja OK
			cMsgErro := cUniMErro
			Exit
		Else
			cMsgErro := cProdErro
			Exit
		Endif
	Next nI
	
	If lFinal .And. lRet
		nPIte := fGetIndice("D1_ITEM"   )
		nPPrd := fGetIndice("B1_COD"    )
		nPPed := fGetIndice("D1_PEDIDO" )
		nPItP := fGetIndice("D1_ITEMPC" )
		nPPrc := fGetIndice("D1_VUNIT"  )
		nPNCM := fGetIndice("B1_POSIPI" )
		nPOri := fGetIndice("B1_ORIGEM" )
		
		nPQtd := fGetIndice("D1_QUANT"  )
		nPTot := fGetIndice("D1_TOTAL"  )
		nPICD := fGetIndice("D1_DESCZFR")
		nPDes := fGetIndice("D1_VALDESC")
		
		cMsgErro := ""
		
		For nI:=1 To nTam
			If !Empty(aCols[nI,nPPed])
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(XFILIAL("SB1")+aCols[nI,nPPrd]))
				
				nPreco:= Round((aCols[nI,nPTot] /*- aCols[nI,nPICD] - If( Abs(aCols[nI,nPICD] - aCols[nI,nPDes]) > 0.009 , aCols[nI,nPDes], 0)*/) / aCols[nI,nPQtd],nDec)
				cOrig := Trim(aCols[nI,nPOri])
				cOrig := If(cOrig=="1","2",If(cOrig=="6","7",cOrig))    // Ajusta para o correspondente
				
				If Trim(SB1->B1_POSIPI) <> Trim(aCols[nI,nPNCM])
					cMsgErro += "<br /><strong>Divergência de NCM: A NCM do Produto "+ Trim(aCols[nI,nPPrd]) + " do XML está divergente em relação a NCM do Produto do sistema: </strong>"
					cMsgErro += "<br />NCM do Produto da base: " + Trim(SB1->B1_POSIPI)
					cMsgErro += "<br />NCM do Produto do XML:  " + Trim(aCols[nI,nPNCM])
					cMsgErro += "<br /><strong>Favor entrar em contato com o Setor Fiscal !</strong>"
					
					AAdd( aMailN , { Trim(aCols[nI,nPPrd]), Trim(SB1->B1_DESC), Trim(SB1->B1_POSIPI), Trim(aCols[nI,nPNCM]),})
				Endif
				If Trim(SB1->B1_ORIGEM) <> cOrig
					cMsgErro += "<br /><strong>Divergência de Origem: A Origem do Produto: "+ Trim(aCols[nI,nPPrd]) + " do XML está divergente em relação a Origem do produto do sistema: </strong>"
					cMsgErro += "<br />Origem do Produto da base: " + Trim(SB1->B1_ORIGEM)
					cMsgErro += "<br />Origem do Produto do XML:  " + Trim(aCols[nI,nPOri])
					cMsgErro += "<br /><strong>Favor entrar em contato com o Setor Fiscal !</strong>"
					
					AAdd( aMailO , { Trim(aCols[nI,nPPrd]), Trim(SB1->B1_DESC), Trim(SB1->B1_ORIGEM), Trim(aCols[nI,nPOri]),})
				Endif
				SC7->(dbSetOrder(1))
				If !SC7->(dbSeek(XFILIAL("SC7")+aCols[nI,nPPed]+aCols[nI,nPItP]))
					cMsgErro += "<br /><strong>Item "+aCols[nI,nPIte]+" não existe no pedido</strong>"
				ElseIf Abs(SC7->C7_PRECO - nPreco) > nVlrTol
					cMsgErro += "<br /><strong>Item "+aCols[nI,nPIte]+" com preços divergentes</strong>"
					cMsgErro += "<br />Preço XML R$ " + LTrim(Transform(nPreco,"@E 999,999,999.99"))
					cMsgErro += "<br />Preço Pedido R$ " + LTrim(Transform(SC7->C7_PRECO,"@E 999,999,999.99"))
				Endif
			Endif
		Next
		
		/*If !Empty(cMsgErro)
			cMsgErro := "<strong>Ocorreram divergências na análise dos itens do XML x Pedido de Compras:</strong><br />" + cMsgErro
			
			If lRet := FWAlertYesNo(cMsgErro + "<br /><br />Confirma ?","Divergências Pré-nota")
				If !Empty(aMailO)
					FWMsgRun(Nil, {|oSay| u_ISMailXML(aMailO, 1) }, "Aguarde...", "Enviando e-mail sobre a divergência da Origem")   //Mala direta - ORIGEM
				Endif
				If !Empty(aMailN)
					FWMsgRun(Nil, {|oSay| u_ISMailXML(aMailN, 2) }, "Aguarde...", "Enviando e-mail sobre a divergência do NCM")      //Mala direta - NCM
				Endif
			Endif
			cMsgErro := ""
		Endif*/
	Endif
	
	If lRet
		If !lNFCad
			oButGrv:Enable()
			oButPed:Enable()
		Endif
		cMsgErro := ""
	Endif
	
Return lRet

/*/{Protheus.doc} fGeraPreNota
Função responsável por gravar a pré-nota de entrada (Tabelas 	SF1 e SD1).
@author Everson Dantas - eversoncdantas@gmail.com
@since 21/07/2015
@version 1.0
/*/
Static Function fGeraPreNota()
	If FWAlertYesNo("Confirma geração da Pré-Nota Fiscal ?","Pré-Nota de Entrada")
		FWMsgRun(Nil, {|oSay| PreNotaOk() }, "Pré-Nota de Entrada", "Gerando Pre Nota...")
	Endif
Return

Static Function PreNotaOk()
	Local nX, nY, nN, aLinha, aBackup, nPIte, nPPrd, nPos
	Local aRgvIt  := {}
	Local lEAN    := (SD1->(FieldPos("D1_XCODBAR")) > 0)   // Caso o campo exista
	Local cPedido := ""
	Local cDI     := ""
	Local dDtDI   := CtoD("")
	Local cCond   := "001"
	Local aItNFE  := {}
	Local aCabec  := {}
	//Local nTotal  := 0
	Local cFunName:= FunName()
	Local lIntDoc := GetMV("MV_XINTDOC",.F.,.F.)
	
	Local nMaxItens := GetMV("MV_NUMITEN",.F.,999)
	Local aNotas    := {}
	Local cNotas    := ""
	
	cMsgErro := ""
	If fAllProdOK(.T.)
		
		For nX:=1 To Len(aCols)
			aLinha := {}
			
			//aAdd(aLinha, {"LINPOS"    ,aCols[nX][fGetIndice("D1_ITEM"   )], NIL})
			aAdd(aLinha, {"D1_ITEM"   ,aCols[nX][fGetIndice("D1_ITEM"  )] , NIL})
			aAdd(aLinha, {"D1_COD"    ,aCols[nX][fGetIndice("B1_COD"   )] , NIL})
			aAdd(aLinha, {cFldDesc    ,aCols[nX][fGetIndice(cFldDesc   )] , NIL})
			aAdd(aLinha, {"D1_UM"     ,aCols[nX][fGetIndice("D1_UM"    )] , NIL})
			aAdd(aLinha, {"D1_SEGUM"  ,aCols[nX][fGetIndice("D1_SEGUM" )] , NIL})
			aAdd(aLinha, {"D1_FORNECE",cCodFor                            , NIL})
			aAdd(aLinha, {"D1_LOJA"   ,cLojFor                            , NIL})
			
			If !Empty(Alltrim(aCols[nX][fGetIndice('D1_PEDIDO')]))
				aAdd(aLinha, {"D1_PEDIDO", cPedido:=aCols[nX][fGetIndice("D1_PEDIDO")], NIL})
				aAdd(aLinha, {"D1_ITEMPC", aCols[nX][fGetIndice("D1_ITEMPC")], NIL})
				aAdd(aLinha, {"D1_CC"    , aCols[nX][fGetIndice("D1_CC"    )], NIL})
				aAdd(aLinha, {"D1_CONTA" , aCols[nX][fGetIndice("D1_CONTA" )], NIL})
			EndIf
			
			aAdd(aLinha, {"D1_QUANT"  ,aCols[nX][fGetIndice("D1_QUANT"  )]   , NIL})
			aAdd(aLinha, {"D1_QTSEGUM",aCols[nX][fGetIndice("D1_QTSEGUM")]   , NIL})
			aAdd(aLinha, {"D1_VUNIT"  ,aCols[nX][fGetIndice("D1_VUNIT"  )]   , NIL})
			aAdd(aLinha, {"D1_TOTAL"  ,aCols[nX][fGetIndice("D1_TOTAL"  )]   , NIL})
			
			If !Empty(Alltrim(aCols[nX][fGetIndice('D1_NFORI')]))
				aAdd(aLinha, {"D1_NFORI"  ,	aCols[nX][fGetIndice("D1_NFORI"  )], NIL})
				aAdd(aLinha, {"D1_SERIORI",	aCols[nX][fGetIndice("D1_SERIORI")], NIL})
				aAdd(aLinha, {"D1_ITEMORI",	aCols[nX][fGetIndice("D1_ITEMORI")], NIL})
				aAdd(aLinha, {"D1_IDENTB6",	aCols[nX][fGetIndice("D1_IDENTB6")], NIL})
			EndIf
			
			aAdd(aLinha, {"D1_VALFRE"  ,aCols[nX][fGetIndice("D1_VALFRE" )]    , NIL})
			aAdd(aLinha, {"D1_SEGURO"  ,aCols[nX][fGetIndice("D1_SEGURO" )]    , NIL})
			aAdd(aLinha, {"D1_DESPESA" ,aCols[nX][fGetIndice("D1_DESPESA")]    , NIL})
			aAdd(aLinha, {"D1_VALDESC" ,aCols[nX][fGetIndice("D1_VALDESC")] + aCols[nX][fGetIndice("D1_DESCZFR")] , NIL})
			
			aAdd(aLinha, {"D1_XDESXML" ,aCols[nX][fGetIndice("D1_XDESXML")]    , NIL})
			aAdd(aLinha, {"D1_XUMXML"  ,aCols[nX][fGetIndice("D1_XUMXML" )]    , NIL})
			aAdd(aLinha, {"D1_XQTDXML" ,aCols[nX][fGetIndice("D1_XQTDXML")]    , NIL})
			
			//aAdd(aLinha, {"D1_CLVL"    ,SD1->(XFILIAL("SD1"))                     , NIL})
			//aAdd(aLinha, {"D1_LOCAL"   ,IF(SD1->(xFilial("SD1"))=="01","03","01") , NIL})
			
			aAdd(aLinha, {"D1_SERVIC"  ,WMSValores(aCols[nX][fGetIndice("B1_COD"    )],"B5_SERVENT") , NIL})
			aAdd(aLinha, {"D1_ENDER"   ,WMSValores(aCols[nX][fGetIndice("B1_COD"    )],"B5_ENDENT" ) , NIL})
			
			If lEAN
				aAdd(aLinha, {"D1_XCODBAR", aCols[nX][fGetIndice("B1_CODBAR")] , NIL})
			Endif
			
			//Se possui ICMS ST preenche os campos
			If aCols[nX][fGetIndice("D1_ICMSRET")] > 0
				aAdd(aLinha, {"D1_VLSLXML" ,aCols[nX][fGetIndice("D1_ICMSRET")], NIL})
				aAdd(aLinha, {"D1_BRICMS"  ,aCols[nX][fGetIndice("D1_BRICMS" )], NIL})
				aAdd(aLinha, {"D1_ICMSRET" ,aCols[nX][fGetIndice("D1_ICMSRET")], NIL})
			EndIf
			If SD1->(FieldPos(cFldVII)) > 0
				aAdd(aLinha, {cFldPII  ,aCols[nX][fGetIndice(cFldPII)], NIL})
				aAdd(aLinha, {cFldVII  ,aCols[nX][fGetIndice(cFldVII)], NIL})
			Endif
			If SD1->(FieldPos("D1_AFRMIMP")) > 0
				aAdd(aLinha, {"D1_AFRMIMP" ,aCols[nX][fGetIndice("D1_AFRMIMP")], NIL})
			Endif
			If SD1->(FieldPos("D1_XSISCOM")) > 0
				aAdd(aLinha, {"D1_XSISCOM" ,aCols[nX][fGetIndice("D1_XSISCOM")], NIL})
			Endif
			
			cDI   := aCols[nX][fGetIndice("F1_XDI")]
			dDtDI := aCols[nX][fGetIndice("F1_XDTDI")]
			
			/*nTotal += aCols[nX][fGetIndice("D1_TOTAL"  )]
			nTotal -= aCols[nX][fGetIndice("D1_VALDESC")]
			nTotal += aCols[nX][fGetIndice("D1_VALFRE" )]
			nTotal += aCols[nX][fGetIndice("D1_SEGURO" )]
			nTotal += aCols[nX][fGetIndice("D1_DESPESA")]
			nTotal += aCols[nX][fGetIndice("D1_VALIPI" )]
			nTotal -= aCols[nX][fGetIndice("D1_DESCZFR")]*/
			
			AADD(aItNFE,aLinha)
			
			// Processa a quebra de notas fiscais
			If nX == Len(aCols) .Or. lEmite .And. Len(aItNFE) >= nMaxItens
				AAdd( aNotas , aClone(aItNFE) )
				aItNFE := {}
			Endif
		Next
		
		If !Empty(cPedido)
			// Posiciona no Pedido de Compras
			SC7->(dbSetOrder(1))
			If SC7->(dbSeek(XFILIAL("SC7")+cPedido))
				cCond := SC7->C7_COND     // Pega a condição de pagamento
			Endif
		Endif
		
		// Adiciona campos para regravar o que o padrão não gravou
		AAdd( aRgvIt , "D1_AFRMIMP" )
		AAdd( aRgvIt , "D1_XSISCOM" )
		AAdd( aRgvIt , cFldPII )
		AAdd( aRgvIt , cFldVII )
		
		If lEmite
			cSerie := GetMV("MV_XDISERI",.F.,"2  ")
		Endif
		
		Private lMsErroAuto := .F.
		
		BeginTran()
		
		For nN:=1 To Len(aNotas)
			
			If lEmite
				cDoc := ""
				While Empty(cDoc)
					cDoc   := NxtSx5Nota(cSerie, .T., GetNewPar("MV_TPNRNFS","1"))
				Enddo
			Endif
			
			cNotas += If( Empty(cNotas) , "", ", ") + cDoc + " / " + cSerie
			
			aCabec := {	{"F1_TIPO"   ,cTipo         ,NIL},;
						{"F1_FORMUL" ,If(lEmite,"S","N"),NIL},;
						{"F1_DOC"    ,cDoc          ,NIL},;
						{"F1_SERIE"  ,cSerie        ,NIL},;
						{"F1_EMISSAO",cTod(cDtEmiss),NIL},;
						{"F1_FORNECE",cCodFor       ,NIL},;
						{"F1_LOJA"   ,cLojFor       ,NIL},;
						{"F1_ESPECIE","SPED"        ,NIL},;
						{"F1_XDI"    ,cDI           ,NIL},;
						{"F1_XDTDI"  ,dDtDI         ,NIL},;
						{"F1_CHVNFE" ,cChave        ,NIL},;
						{"F1_XTXDLR" ,ntxDolar      ,NIL},;
						{"F1_XVLDLR" ,nTTdolar      ,NIL},;
						{"F1_COND"   ,cCond         ,NIL} }
			
			aBackup := { aClone(aHeader), aClone(aCols), n, Inclui, Altera}
			
			SetFunName("MATA140")
			
			MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aNotas[nN], 3 /*Opção (Inclusão)*/)
			
			If lMsErroAuto
				DisarmTransaction()
				MostraErro()
				Exit
			Else
				SD1->(dbSetOrder(1))    // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
				
				// Regrava valores não gravados pela rotina padrão
				For nX:=1 To Len(aNotas[nN])
					nPIte := AScan( aNotas[nN][nX] , {|x| Trim(x[1]) == "D1_ITEM" } )
					nPPrd := AScan( aNotas[nN][nX] , {|x| Trim(x[1]) == "D1_COD"  } )
					If SD1->(dbSeek(XFILIAL("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+aNotas[nN][nX][nPPrd,2]+aNotas[nN][nX][nPIte,2]))
						RecLock("SD1",.F.)
						For nY:=1 To Len(aRgvIt)
							nPos := AScan( aNotas[nN][nX] , {|x| Trim(x[1]) == aRgvIt[nY] } )
							If SD1->(FieldPos(aRgvIt[nY])) > 0 .And. nPos > 0
								FieldPut( FieldPos(aRgvIt[nY]) , aNotas[nN][nX][nPos,2] )
							Endif
						Next
						MsUnLock()
					Endif
				Next
				
				If lIntDoc
					// Re-Inicializa variáveis do sistema
					aHeader := {}
					aCols   := {}
					n       := 1
					
					While !MsDocument("SF1",SF1->(Recno()),3)   // Exibe a tela de integração com a base de conhecimento
					Enddo
					
					// Restaura o conteúdo das variáeveis
					aHeader := aClone(aBackup[1])
					aCols   := aClone(aBackup[2])
					n       := aBackup[3]
					Inclui  := aBackup[4]
					Altera  := aBackup[5]
				Endif
			EndIf
		Next
			
		If lMsErroAuto
		Else
			EndTran()
			
			MudaPasta()
			
			FWAlertSuccess("Pré-Nota(s) de Entrada <font face='Arial' size=3 color=RED><strong>"+cNotas+"</strong></font> gerada(s) com sucesso.","Sucesso")
			
			fLimpaTela(1)
		EndIf
		
		SetFunName(cFunName)
	ElseIf !Empty(cMsgErro)
		FWAlertError(cMsgErro,"Impossível gerar Pré-Nota")
	Endif

Return

Static Function WMSValores(cProduto,cCampo)
	Local cRet := CriaVar(cCampo,.F.)
	If IntDL(cProduto)
		cRet := Posicione("SB5",1,XFILIAL("SB5")+cProduto,cCampo)
	Endif
Return CriaVar(cCampo,.F.)  //If( Empty(cRet) , CriaVar(cCampo,.T.), cRet)

/*/{Protheus.doc} fIncAmarr
Função responsável por criar a amarração entre produto e fornecedor, logo após o cadastro do produto (Tabela SA5).
@author Everson Dantas - eversoncdantas@gmail.com
@since 21/07/2015
@version 1.0
@param cFornec, character, Código do Fornecedor
@param cLojaFo, character, Código da Loja
@param cCodProd, character, Código do Produto
@param cCodPF, character, Código do Produto no Fornecedor
/*/
Static Function fIncAmarr(cFornec, cLojaFo, cCodProd, cCodPF, cNomeFor, cNomeProd)
	Local aCampAmarr := {}
	
	Private lMsErroAuto := .F.
	
	If !(cTipo $ "DB")
		AADD(aCampAmarr, {"A5_FORNECE", PADR(cFornec  ,TamSx3("A5_FORNECE")[1]),})
		AADD(aCampAmarr, {"A5_LOJA"   , PADR(cLojaFo  ,TamSx3("A5_LOJA"   )[1]),})
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
		SA7->A7_CLIENTE := cFornec
		SA7->A7_LOJA    := cLojaFo
		SA7->A7_PRODUTO := cCodProd
		SA7->A7_CODCLI  := cCodPF
		SA7->A7_DESCCLI := cNomeProd
		MsUnLock()
	EndIf

Return !lMsErroAuto

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
	
	Default aAlvo := aClone(aHeader)
	
	If !Empty(aAlvo)
		For nIndice := 1 To Len(aAlvo)
			If ALLTRIM(aAlvo[nIndice][2]) == ALLTRIM(cNomeCampo)
				Exit
			Endif
		Next nIndice
	Else
		FWAlertError("Array vazio.","Erro")
	Endif
	
Return nIndice

/*User Function fLinhaOK
Return .T.

User Function fTudoOK
Return .T.*/

/*/{Protheus.doc} fCadProd
Ação do botão "Cadastrar produto". Checa se o produto está cadastrado, não está cadastrado ou é inválido.
@author Everson Dantas - eversoncdantas@gmail.com
@since 27/07/2015
@version 1.0
/*/
Static Function fCadProd()
	Local cDescXml, cUnidXml, cNCM, cEAN
	
	If TestaProduto()
		cDescXml := aCols[n, fGetIndice("B1_DESC"  )]
		cUnidXml := aCols[n, fGetIndice("D1_UM"    )]
		
		SAH->(dbSetOrder(1))
		If SAH->(dbSeek(xFilial("SAH")+cUnidXml))
			//cUnidXml := ""
			cNCM     := aCols[n, fGetIndice("B1_POSIPI")]
			cEAN	 := aCols[n, fGetIndice("B1_CODBAR")]
		Endif
		
		fIncProd(cDescXml, cUnidXml, cNCM, cEAN)
	Endif

Return

/*/{Protheus.doc} fCadUnMed
Ação do botão "Cadastrar Un.Medida". Checa se a unidade de medida está cadastrada, não está cadastrada ou é inválida.
@author Ronilton O. Barros
@since 16/02/2022
@version 1.0
/*/
Static Function fCadUnMed()
	Local nX
	Local nPUMXML  := fGetIndice("D1_XUMXML")
	Local cUnidXml := aCols[n, nPUMXML]
	
	If aCols[n, nFldUse+1] < 2    // Flag de UM ok
		If !Empty(cUnidXml)
			SAH->(dbSetOrder(1))
			If !SAH->(dbSeek(xFilial("SAH")+cUnidXml))
				RecLock("SAH",.T.)
				SAH->AH_FILIAL := XFILIAL("SAH")
				SAH->AH_UNIMED := cUnidXml
				SAH->AH_UMRES  := cUnidXml
				MsUnLock()
			Endif
			
			// Atualiza todos os itens com unidade de medida do XML igual
			For nX:=1 To Len(aCols)
				If aCols[nX,nPUMXML] == cUnidXml
					fCheckProd(nX)    // aAtualiza a legenda
				Endif
			Next
			
			fAllProdOK()
		Endif
	Else
		FWAlertWarning("A unidade de medida já está cadastrada !")
	Endif
	
Return

/*/{Protheus.doc} fCadPxf
Ação do botão "Cadastrar produto x Fornecedor". Checa se o produto está cadastrado, não está cadastrado ou é inválido.
@author Jonathan Wermouth - jonathan.wermouth@totvs.com.br
@since 25/11/2015
@version 1.0
/*/
Static Function fCadPxf(cA5_PRODUTO)
	Local nX, aFabric, oDlgE, oEnc, aCmpEnc
	Local nOpc     := 0
	Local aAchoSA5 := {}
	Local aAchoSA7 := {}
	Local aReplica := {}
	Local nReplica := 0
	Local nPPrd    := fGetIndice("B1_COD"   )
	Local nPPrF    := fGetIndice("A5_CODPRF")
	Local nModAux  := nModulo
	Local aCampos  := {}
	Local aTAB     := {}
	Local lOk      := .T.
	Local lRet     := .F.
	
	Private aSA5Det := {cCodFor,cLojFor,aCols[n][nPPrF]}
	Private aTela   := {}
	Private aGets   := {}
	
	Default cA5_PRODUTO := CriaVar("A5_PRODUTO",.F.)
	
	If !Empty(aSA5Pend)
		If FWAlertYesNo("Existem Itens pendentes de cadastrar na tabela Produto x Fornecedor. Confirma o cadastro agora ?")
			lOk := .F.
			FWMsgRun(Nil, {|oSay| CadProdForn() }, "Produto x Fornecedor", "Gravando novos registros...")
			aSA5Pend := {}
		Endif
	Endif
	
	If lOk .And. TestaProduto(.T.)
		
		If !(cTipo $ "DB")
			SA5->(dbSetOrder(1))
			SA5->(dbgotop())
			
			cCadastro := "Cadastro de Produto x Fornecedor"
			
			//Traz os campos que serão exibidos e os coloca no vetor aAchoSA5
			nModulo := 2    // Define como Compras para exibir o campo FABRICANTE
			fAchaCampos("SA5",@aAchoSA5)
			
			// Carrega os campos a serem lidos para a tabela
			// Adiciona os campos a serem exibidos na tela
			//                 Nome         Obrg Edit  F3    When       CBox
			AAdd( aCampos , { "A5_PRODUTO", .T., .T., "SB1", {|| .T. }, Nil} )
			AAdd( aCampos , { "A5_FORNECE", .T., .F., "SA2", {|| .T. }, Nil} )
			AAdd( aCampos , { "A5_LOJA"   , .T., .F., "   ", {|| .T. }, Nil} )
			AAdd( aCampos , { "A5_CODPRF" , .T., .F., "   ", {|| .T. }, Nil} )
			AAdd( aCampos , { "A5_FABR"   , .F., .T., "   ", {|| .T. }, Nil} )
			AAdd( aCampos , { "A5_FALOJA" , .F., .T., "   ", {|| .T. }, Nil} )
			
			aEval( aCampos , {|x| AAdd( aTAB , PADR(x[1],10) ) } )
			
			aCmpEnc := ConfigCampos(aCampos)
			
			// Inicializa o conteúdo das variáveis
			RegToMemory("SA5", .T., .F. )
			CadSA5Cpo(cA5_PRODUTO)
			
			M->A5_PRODUTO := cA5_PRODUTO    // Atribui codigo do produto sugerido
			
			//Mostra tela de cadastro padrão no formato Enchoice
			DEFINE MSDIALOG oDlgE TITLE "Produto x Fornecedor" From 0,0 TO 490,650 PIXEL OF oMainWnd  Style DS_MODALFRAME
			
			oEnc := Msmget():New(,,3,,,,aTAB,{30,0,228,328},Nil,3,,,,oDlgE,,.T.,,,,,aCmpEnc,,,.F.)
			
			ACTIVATE MSDIALOG oDlgE CENTERED ON INIT EnchoiceBar(oDlgE,{|| nOpc:=If(Obrigatorio(aGets,aTela),1,0),If(nOpc==1,oDlgE:End(),) },{||oDlgE:End()})
			
			nModulo := nModAux
			
			If lRet := (nOpc == 1)
				RecLock("SA5",.T.)
				For nX:=1 To FCount()
					FieldPut( nX , M->&(FieldName(nX)) )
					SA5->A5_FILIAL := XFILIAL("SA5")
				Next
				MsUnLock()
				
				// Posiciona no Cadastro do Produto
				SB1->(dbSetorder(1))
				SB1->(dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))
				
				AAdd( aReplica , { n, .F.} )   // Adiciona para atualização na tela
				
				// Verifica se o fabricante não está preenchido
				If Empty(SA5->A5_FABR)
					aFabric := Fabricante(cCodFor+cLojFor+SB1->B1_COD)
					
					RecLock("SA5",.F.)
					SA5->A5_FABR   := aFabric[1]
					SA5->A5_FALOJA := aFabric[2]
					MsUnlock()
				Endif
				
				If PADR(SB1->B1_COD,2) == "Z0"   // Define se está inserindo um item genérico
					// Identifica os itens a serem ajustados o Produto x Fornecedor
					For nX:=1 To Len(aCols)
						If nX <> n .And. Empty(aCols[nX,nPPrd]) .And. nReplica <> 2
							If nReplica == 1 .Or. (nReplica := If(FWAlertYesNo("Replica esse mesmo produto para os demais itens ?"),1,2)) == 1
								AAdd( aReplica , { nX, .T.} )
							Endif
						Endif
					Next
				Endif
			Endif
		Else
			dbSelectArea("SA7")
			cCadastro := "Cadastro de Produto x Cliente"
			
			//Traz os campos que serão exibidos e os coloca no vetor aAchoSA7
			nModulo := 2    // Define como Compras para exibir o campo FABRICANTE
			fAchaCampos("SA7",@aAchoSA7)
			
			// Carrega os campos a serem lidos para a tabela
			// Adiciona os campos a serem exibidos na tela
			//                 Nome         Obrg Edit  F3    When       CBox
			AAdd( aCampos , { "A7_CLIENTE", .T., .F., "SA1", {|| .T. }, Nil} )
			AAdd( aCampos , { "A7_LOJA"   , .T., .F., "   ", {|| .T. }, Nil} )
			AAdd( aCampos , { "A7_CODCLI" , .T., .F., "   ", {|| .T. }, Nil} )
			AAdd( aCampos , { "A7_PRODUTO", .T., .T., "SB1", {|| .T. }, Nil} )
			
			aEval( aCampos , {|x| AAdd( aTAB , PADR(x[1],10) ) } )
			
			aCmpEnc := ConfigCampos(aCampos)
			
			// Inicializa o conteúdo das variáveis
			RegToMemory("SA7", .T., .F. )
			CadSA7Cpo()
			
			M->A7_PRODUTO := cA5_PRODUTO    // Atribui codigo do produto sugerido
			
			//Mostra tela de cadastro padrão no formato Enchoice
			DEFINE MSDIALOG oDlgE TITLE "Produto x Cliente" From 0,0 TO 490,650 PIXEL OF oMainWnd  Style DS_MODALFRAME
			
			oEnc := Msmget():New(,,3,,,,aTAB,{30,0,228,328},Nil,3,,,,oDlgE,,.T.,,,,,aCmpEnc,,,.F.)
			
			ACTIVATE MSDIALOG oDlgE CENTERED ON INIT EnchoiceBar(oDlgE,{|| nOpc:=If(Obrigatorio(aGets,aTela),1,0),If(nOpc==1,oDlgE:End(),) },{||oDlgE:End()})
			
			nModulo := nModAux
			
			If lRet := (nOpc == 1)
				RecLock("SA7",.T.)
				For nX:=1 To FCount()
					FieldPut( nX , M->&(FieldName(nX)) )
					SA7->A7_FILIAL := XFILIAL("SA7")
				Next
				MsUnLock()
				
				// Posiciona no Cadastro do Produto
				SB1->(dbSetorder(1))
				SB1->(dbSeek(xFilial("SB1")+SA7->A7_PRODUTO))
				
				AAdd( aReplica , { n, .F.} )   // Adiciona para atualização na tela
			Endif
		EndIf
		
		//Retorna o Código do Produto cadastrado para o aCols e o atualiza, em seguida cria a amarração Prod x Forn (SA5).
		If lRet := (nOpc <> 3 .And. nOpc <> 0)
			For nX:=1 To Len(aReplica)
				
				aCols[aReplica[nX,1]][fGetIndice("B1_COD"  )] := SB1->B1_COD
				aCols[aReplica[nX,1]][fGetIndice("B1_DESC" )] := SB1->B1_DESC
				aCols[aReplica[nX,1]][fGetIndice("D1_LOCAL")] := SB1->B1_LOCPAD
				aCols[aReplica[nX,1]][fGetIndice("D1_UM"   )] := SB1->B1_UM
				
				If aReplica[nX,2]   // Se replica o Produto x Fornecedor
					AddProdxFornece(aCols[aReplica[nX,1],nPPrd],aCols[aReplica[nX,1],nPPrF])
				Endif
				
				oItens:Refresh()
				
				//Deixa a legenda verde (produto cadastrado)
				fCheckProd(aReplica[nX,1])
			Next
			
			fAllProdOK()
		EndIf
	Endif
	
Return lRet

Static Function CadProdForn()
	Local nX, nY, nPos
	Local nPPrF := fGetIndice("A5_CODPRF")
	Local nPPrd := fGetIndice("B1_COD"   )
	Local nPDes := fGetIndice("B1_DESC"  )
	Local nPOrg := fGetIndice("B1_ORIGEM")
	Local nPAlm := fGetIndice("D1_LOCAL" )
	
	SB1->(dbSetOrder(1))
	
	BeginTran()
	
	For nY:=1 To Len(aCols)
		
		If !Empty(aCols[nY,nPPrd]) .Or. (nPos := AScan( aSA5Pend , {|x| Trim(x[3]) == Trim(aCols[nY,nPPrF]) } )) == 0
			Loop
		Endif
		
		SB1->(dbSeek(XFILIAL("SB1")+aSA5Pend[nPos,3]))
		
		If aSA5Pend[nPos,5] == 0
			// Inicializa o conteúdo das variáveis
			RegToMemory("SA5", .T., .F. )
			CadSA5Cpo()
			
			M->A5_CODPRF  := aSA5Pend[nPos,3]
			M->A5_PRODUTO := aSA5Pend[nPos,3]
			M->A5_NOMPROD := aSA5Pend[nPos,4]
			
			RecLock("SA5",.T.)
			For nX:=1 To FCount()
				FieldPut( nX , M->&(FieldName(nX)) )
				SA5->A5_FILIAL := XFILIAL("SA5")
			Next
			MsUnLock()
			
			aSA5Pend[nPos,5] := SA5->(Recno())
		Endif
		
		aCols[nY][nPPrd] := SB1->B1_COD
		aCols[nY][nPDes] := SB1->B1_DESC
		aCols[nY][nPAlm] := SB1->B1_LOCPAD
		aCols[nY][nPOrg] := SB1->B1_ORIGEM
		oItens:Refresh()
		
		fCheckProd(nY)    // Atualiza a legenda
	Next
	
	EndTran()

Return

Static Function TestaProduto(lSelec)
	Local oSel, oPF
	Local cSeek := SA5->(XFILIAL("SA5"))+cCodFor+cLojFor+aCols[n,3]
	Local aProd := {}
	Local nOpcA := 0
	Local lRet  := (aCols[n, nFldUse+1] == 0)    // Flag de PRODUTO e UM ok
	
	Default lSelec := .F.
	
	If !lRet
		If lSelec
			// Pesquisa os Produtos Infostore amarrado ao codigo do fornecedor
			SA5->(dbSetOrder(14))    // A5_FILIAL+A5_FORNECE+A5_LOJA+A5_CODPRF
			SA5->(dbSeek(cSeek,.T.))
			While !SA5->(Eof()) .And. SA5->A5_FILIAL+SA5->A5_FORNECE+SA5->A5_LOJA+SA5->A5_CODPRF == cSeek
				AAdd( aProd , { SA5->A5_PRODUTO, SA5->A5_NOMPROD})
				SA5->(dbSkip())
			Enddo
			
			If !Empty(aProd)
				DEFINE MSDIALOG oSel FROM 0,0 TO 280,500 TITLE "Produto x Fornecedor" PIXEL
				
				@ 05, 005 SAY "Item"       OF oSel PIXEL /*FONT oFnt3*/ COLOR CLR_HBLUE
				@ 05, 025 SAY aCols[n,2]   OF oSel PIXEL /*FONT oFnt3*/ COLOR CLR_HRED
				@ 05, 100 SAY "Produto"    OF oSel PIXEL /*FONT oFnt3*/ COLOR CLR_HBLUE
				@ 05, 140 SAY aCols[n,3]   OF oSel PIXEL /*FONT oFnt3*/ COLOR CLR_HRED
				@ 15, 005 SAY "Descrição"  OF oSel PIXEL /*FONT oFnt3*/ COLOR CLR_HBLUE
				@ 15, 045 SAY aCols[n,5]   OF oSel PIXEL /*FONT oFnt3*/ COLOR CLR_HRED SIZE 200,10
				
				@ 25,04 LISTBOX oPF VAR nPosLbx FIELDS HEADER "Produto","Descrição" SIZE 246,090 OF oSel PIXEL NOSCROLL
				oPF:SetArray(aProd)
				oPF:bLine := {|| {aProd[oPF:nAt,1], aProd[oPF:nAt,2] } }
				
				DEFINE SBUTTON FROM 123,073 TYPE 1 ENABLE OF oSel ACTION (nOpcA:=oPF:nAt,lRet:=.T.,oSel:End())
				DEFINE SBUTTON FROM 123,108 TYPE 2 ENABLE OF oSel ACTION (nOpcA:=0      ,lRet:=.F.,oSel:End())
				DEFINE SBUTTON FROM 123,143 TYPE 4 ENABLE OF oSel ACTION (nOpcA:=-1     ,lRet:=.T.,oSel:End())
				
				ACTIVATE MSDIALOG oSel CENTERED
				
				If nOpcA > 0
					AtualItem(aProd[nOpcA,1],n)
					oItens:Refresh()
				Endif
			Endif
			
			lRet := lRet .And. (nOpcA < 0 .Or. Empty(aCols[n,3]))
		Else
			FWAlertError("O produto " + Trim(aCols[n,3]) + " já está cadastrado.","Impossível cadastrar produto")
		Endif
	Endif

Return lRet

Static Function fFechar()
Return FWAlertYesNo("Encerrar sessão?","Confirmação")

Static Function AtualItem(cProduto,nPos)
	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(XFILIAL("SB1")+cProduto))
		aCols[nPos][fGetIndice("B1_COD"  )] := SB1->B1_COD
		aCols[nPos][fGetIndice("B1_DESC" )] := SB1->B1_DESC
		aCols[nPos][fGetIndice("D1_LOCAL")] := SB1->B1_LOCPAD
		aCols[nPos][fGetIndice("D1_UM"   )] := SB1->B1_UM
		aCols[nPos][fGetIndice("D1_SEGUM")] := SB1->B1_SEGUM 
	Else
		aCols[nPos][fGetIndice("B1_COD"  )] := CriaVar("B1_COD",.F.)
	Endif
	
	//Deixa a legenda verde (produto cadastrado)
	fCheckProd(nPos)

Return

Static Function AddProdxFornece(cProduto,cProdFor)
	Local aFabric := Fabricante(cCodFor+cLojFor+cProduto)
	
	RecLock("SA5",.T.)
	SA5->A5_FILIAL  := XFILIAL("SA5")
	SA5->A5_FORNECE := cCodFor
	SA5->A5_LOJA    := cLojFor
	SA5->A5_PRODUTO := cProduto
	SA5->A5_NOMEFOR := Posicione("SA2",1,XFILIAL("SA2")+cCodFor+cLojFor,"A2_NOME")
	SA5->A5_NOMPROD := Posicione("SB1",1,XFILIAL("SB1")+cProduto,"B1_DESC")
	SA5->A5_CODPRF  := cProdFor
	SA5->A5_FABR    := aFabric[1]
	SA5->A5_FALOJA  := aFabric[2]
	MsUnLock()

Return

Static Function Fabricante(cSeek)
	Local aAreaSA2 := SA2->(GetArea())
	Local aAreaSA5 := SA5->(GetArea())
	Local aRet
	
	// Posiciona no 1o registro do Fornecedor
	SA2->(dbsetOrder(1))
	SA2->(dbSeek(XFILIAL("SA2"),.T.))
	
	// Pesquisa um fornecedor (fabricante) sem vínculo com o Produto
	SA5->(dbsetOrder(1)) //A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO+A5_FABR+A5_FALOJA
	While SA5->(dbSeek(XFILIAL("SA5")+cSeek+SA2->A2_COD+SA2->A2_LOJA))
		SA2->(dbSkip())
	Enddo
	
	aRet := { SA2->A2_COD, SA2->A2_LOJA}   // Fabricante encontrado
	
	SA2->(RestArea(aAreaSA2))
	SA5->(RestArea(aAreaSA5))

Return aRet

/*/{Protheus.doc} fErroForn
Procedimento realizado caso o Fornecedor não esteja cadastrado (desabilita cadastro de produto e geração de pré-nota, além de mostrar
erro).
@author Everson Dantas - eversoncdantas@gmail.com
@since 04/08/2015
@version 1.0
/*/
Static Function fErroForn()
	cMsgErro := cFornErro
	StatusObjetos()
	SetKey(115,{||})
Return

Static Function StatusObjetos(lOk)
	
	Default lOk := .T.
	
	If lNFCad .Or. Eval(bVazio)
		oButGrv:Disable()
		oButPrd:Disable()
		oButPxF:Disable()
		oButPed:Disable()
		oButUnM:Disable()
	Else
		If lOk
			oButGrv:Enable()
		Else
			oButGrv:Disable()
		Endif
		oButPrd:Enable()
		oButPxF:Enable()
		oButPed:Enable()
		oButUnM:Enable()
	Endif
	
	If Eval(bVazio)
		oButClear:Disable()
	Else
		oButClear:Enable()
	Endif

Return

/*/{Protheus.doc} Documentos
Procedimento para pesquisar os pedido de compra pra vincular com os itens.
@author Jonathan Wermouth - Jonathan.wermouth@totvs.com.br
@since 25/11/2015
@version 1.0
/*/
Static Function Documentos(cProduto)
	Local aArea   := GetArea()
	Local lRet    := .F.
	Local cSC7Tmp := "SC7TMP"
	Local nPPrd   := GDFieldPos("B1_COD")
	Local lTudo   := (cProduto == Nil)
	Local lMark   := .F.
	
	Default cProduto := ""
	
	If Empty(aCols[n,nPPrd])
		PesqPedido()
		Return .T.
	Endif
	
	While .T.
		cSC7Tmp := FiltraPedidos(cProduto,lTudo)
		
		If (cSC7Tmp)->(Bof()) .And. (cSC7Tmp)->(Eof())
			FWAlertWarning("Não há pedidos de compra para o "+If(lTudo,"fornecedor","produto "+Trim(cProduto))+" do documento " +AllTrim(cDoc)+"/"+AllTrim(cSerie) +".","Atenção")
			
			//If FWAlertYesNo("Deseja criar um Pedido de Compras para os itens dessa nota ?")
			//	FWMsgRun(Nil, {|oSay| lMark := CriaPedido() }, "Pedido de Compras", "Carregando Novo Pedido...")    // Pedido novo trás marcado
			//Endif
			
			If !lMark
				Exit
			Endif
		Else
			lRet := SelecPedido(cProduto,lTudo,cSC7Tmp,lMark)
			Exit
		EndIf
	Enddo
	
	(cSC7Tmp)->(dbCloseArea())
	RestArea(aArea)
	
Return lRet

Static Function FiltraPedidos(cProduto,lTudo)
	Local cQry
	Local nPPrd  := GDFieldPos("B1_COD")
	Local cAlias := "SC7TMP"
	
	If lTudo
		aEval( aCols , {|x| If( !Empty(x[nPPrd]) , cProduto += If( Empty(cProduto) , "", ",") + Trim(x[nPPrd]), "") } )
		
		//If Len(aCols) == 1 .And. !Empty(aCols[n,nPPrd])    // Caso só exista um item na nota
		//	cProduto := aCols[n,nPPrd]
		//Endif
		
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
	
	If !Empty(cProduto)
		cQry += " AND SC7.C7_PRODUTO IN " + FormatIn(cProduto,",")
	EndIf
	
	cQry += " ORDER BY SC7.C7_NUM" + If( lTudo , "", ", SC7.C7_ITEM")
	
	If Select(cAlias) > 0
		(cAlias)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQry)),cAlias,.T.,.T.)
	(cAlias)->(dbGoTop())

Return cAlias

Static Function PesqPedido()
	Local oPed
	Local nPos    := 0
	Local nOpcA   := 0
	Local oOk     := LoadBitmap( GetResources(), "BR_VERDE"   ) 
	Local oNo     := LoadBitmap( GetResources(), "BR_VERMELHO") 
	Local oYl     := LoadBitmap( GetResources(), "BR_AMARELO" ) 
	Local oBk     := LoadBitmap( GetResources(), "BR_PRETO"   ) 
	
	Private oLin, aPedido := {}
	
	ItemVazio()
	
	cCadastro := "Vincular Pedido x Produto x Fornecedor"
	DEFINE MSDIALOG oPed FROM 0,0 TO 480,1160 TITLE "Pedido de Compra" PIXEL
	
	@ 35, 05 SAY "Pedido"    OF oPed PIXEL /*FONT oFnt3*/ COLOR CLR_HBLUE
	@ 35, 35 MSGET __cPedNF F3 "SC7" VALID Vazio(__cPedNF).Or.ExistCpo("SC7",__cPedNF).And.LoadPedido(@nPos) OF oPed PIXEL /*FONT oFnt3*/ COLOR CLR_HRED
	
	@ 55, 04 LISTBOX oLin VAR nPosLbx FIELDS HEADER "","Item","Produto","Descrição","Modelo","Quant.","Preço","Valor Total","Qtd.Entregue" SIZE 575,180 OF oPed PIXEL NOSCROLL
	oLin:SetArray(aPedido)
	oLin:bLine := {|| {	If(aPedido[oLin:nAt,10],If(aPedido[oLin:nAt,7]>0,If(aPedido[oLin:nAt,7]<aPedido[oLin:nAt,4],oYl,oNo),oOk),oBk),;
						aPedido[oLin:nAt,1],;
						aPedido[oLin:nAt,2],;
						aPedido[oLin:nAt,3],;
						aPedido[oLin:nAt,9],;
						Transform(aPedido[oLin:nAt,4],PesqPict("SC7","C7_QUANT")),;
						Transform(aPedido[oLin:nAt,5],PesqPict("SC7","C7_PRECO")),;
						Transform(aPedido[oLin:nAt,6],PesqPict("SC7","C7_TOTAL")),;
						Transform(aPedido[oLin:nAt,7],PesqPict("SC7","C7_QUJE" ))} }
	
	ACTIVATE MSDIALOG oPed CENTERED ON INIT (EnchoiceBar(oPed,{|| If(VldItemPed(aPedido[oLin:nAt]), (nOpcA:=oLin:nAt,oPed:End()),) },{|| nOpcA:=0,oPed:End() }),;
											LoadPedido(@nPos))
	
	If nOpcA > 0
		aPedido[nOpcA,7] += aCols[n,GDFieldPos("D1_QUANT")]
		aPedGer[nPos,2]  := aClone(aPedido)
	Endif

Return nOpcA > 0

Static Function LoadPedido(nPos)
	Local cSeek  := SC7->(XFILIAL("SC7")) + __cPedNF
	Local cMVNFE := SuperGetMV("MV_RESTNFE")
	Local lRet   := .T.
	
	If Empty(__cPedNF)
		Return lRet
	Endif
	
	SC7->(dbSetOrder(1))
	SC7->(dbSeek(cSeek,.T.))
	
	If lRet := (cCodFor+cLojFor == SC7->C7_FORNECE+SC7->C7_LOJA)
		nPos := AScan( aPedGer , {|x| x[1] == cSeek } )
		If nPos == 0   // Caso ainda não tenha sido informado o pedido
			AAdd(aPedGer,{ cSeek, {}})
			nPos := Len(aPedGer)
		Endif
			
		If Empty(aPedGer[nPos,2])    // Caso esteja vazio
			While !SC7->(Eof()) .And. SC7->C7_FILIAL+SC7->C7_NUM == cSeek
				AAdd( aPedGer[nPos,2] , { SC7->C7_ITEM, SC7->C7_PRODUTO, Posicione("SB1",1,XFILIAL("SB1")+SC7->C7_PRODUTO,"B1_DESC"), SC7->C7_QUANT, SC7->C7_PRECO,;
											SC7->C7_TOTAL, SC7->C7_QUJE, SC7->C7_CC, Posicione("SB1",1,XFILIAL("SB1")+SC7->C7_PRODUTO,"B1_MODELO"),;
											/*Empty(SC7->C7_ENCER).And.*/SC7->C7_RESIDUO<>'S'.And.(cMVNFE<>"S".Or.SC7->C7_CONAPRO<>'B'), SC7->C7_CONTA } )
				SC7->(dbSkip())
			Enddo
		Endif
		
		aSize(aPedido,0)
		aEval( aPedGer[nPos,2] , {|x| AAdd( aPedido , aClone(x) ) } )    // Atribui os itens já lidos
		
		If Empty(aPedido)
			ItemVazio()
		Endif
		
		oLin:Refresh()
	Else
		FWAlertError("Esse pedido não pertence ao fornecedor da nota !")
	Endif

Return lRet

Static Function VldItemPed(aItem)
	Local nPPed := GDFieldPos("D1_PEDIDO")
	Local nPIPC := GDFieldPos("D1_ITEMPC")
	Local nPCCu := GDFieldPos("D1_CC")
	Local nPCta := GDFieldPos("D1_CONTA")
	Local nPQtd := GDFieldPos("D1_QUANT")
	Local lRet  := (aItem[7] < aItem[4])
	
	If lRet
		If lRet := ((aItem[4] - aItem[7]) >= aCols[n,nPQtd])
			If lRet := aItem[10]
				If lRet := (AScan( aCols , {|x| x[nPPed]+x[nPIPC] == __cPedNF+aItem[1] } ) == 0)
					If lRet := fCadPxf(aItem[2])
						aCols[n,nPPed] := __cPedNF
						aCols[n,nPIPC] := aItem[1]
						aCols[n,nPCCu] := aItem[8]
						aCols[n,nPCta] := aItem[11]
					Endif
				Else
					FWAlertError("Esse item já foi adicionado na nota !")
				Endif
			Else
				FWAlertError("Esse item possui restrição de uso !")
			Endif
		Else
			FWAlertError("Esse item não possui quantidade suficiente para atender a nota !")
		Endif
	Else
		FWAlertError("Esse item já foi totalmente entregue !")
	Endif

Return lRet

Static Function ItemVazio()
	AAdd( aPedido , {})
	AAdd( aPedido[Len(aPedido)] , CriaVar("C7_ITEM"   ,.F.) )
	AAdd( aPedido[Len(aPedido)] , CriaVar("C7_PRODUTO",.F.) )
	AAdd( aPedido[Len(aPedido)] , CriaVar("B1_DESC"   ,.F.) )
	AAdd( aPedido[Len(aPedido)] , CriaVar("C7_QUANT"  ,.F.) )
	AAdd( aPedido[Len(aPedido)] , CriaVar("C7_PRECO"  ,.F.) )
	AAdd( aPedido[Len(aPedido)] , CriaVar("C7_TOTAL"  ,.F.) )
	AAdd( aPedido[Len(aPedido)] , CriaVar("C7_QUJE"   ,.F.) )
	AAdd( aPedido[Len(aPedido)] , CriaVar("C7_CC"     ,.F.) )
	AAdd( aPedido[Len(aPedido)] , CriaVar("B1_MODELO" ,.F.) )
	AAdd( aPedido[Len(aPedido)] , .F. )
	AAdd( aPedido[Len(aPedido)] , CriaVar("C7_CONTA"  ,.F.) )
Return

/*/{Protheus.doc} SelecPedido
Cria tela para vincular os pedidos que foram encontrados.
@author Jonathan Wermouth - jonathan.wermouth@totvs.com.br
@since 25/11/2015
@version 1.0
/*/
Static Function SelecPedido(cProduto,lTudo,cSC7Tmp,lMark)
	Local lRet      := .F.
	Local oPed      := NIL
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
	
	Default lMark := .F.
	
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
	Else
		aFields := { "", RetTitle("C7_NUM"), RetTitle("C7_EMISSAO")}
		bLine := {|| {	If(aPedidos[oBrowse:nAt,1],oOk,oNo),; //-- Marca
						aPedidos[oBrowse:nAt,2],;             //-- Pedido
						aPedidos[oBrowse:nAt,3] } }           //-- Emissao
	EndIf
	
	MontaSelec(cSC7Tmp,aPedidos,lTudo,lMark)
	
	cCadastro := "Vínculo com Pedido de Compra"
	
	//-- Monta interface para selecao do pedido
	Define MsDialog oPed Title cCadastro From nlTl1,nlTl2 To nlTl3,nlTl4 Pixel //-- Vínculo com Pedido de Compra
	
	//-- Cabecalho
	@(nlTl1+10),nlTl2-15 To (nlTl1+22),(nlTl2+240) Pixel Of oPed
	
	If !lTudo
		@(nlTl1+12),(nlTl2-10) Say "Doc " +cDoc +" - Item" +AllTrim(aCols[n,GDFieldPos("D1_ITEM")]) +" / " +AllTrim(cProduto) + " - " + Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC") Pixel Of oPed 
	Else
		@(nlTl1+12),(nlTl2-10) Say "Doc " +cDoc +" - Fornecedor: " +cCodFor +"/" +cLojFor +" - " +Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojFor,"A2_NOME") Pixel Of oPed 
	EndIf
	
	//-- Itens
	oBrowse := TCBrowse():New(nlTl1+30,nlTl2-20,nlTl4-315,nlTl3-200,,aFields,,oPed,,,,,{|| MarcaPC(@aPedidos,oBrowse:nAt,lTudo),oBrowse:Refresh()},,,,,,,,,.T.)
	oBrowse:SetArray(aPedidos)
	oBrowse:bLine := bLine
	
	//-- Botoes
	TButton():New(nlTl1+134,nlTl2+03,"Visualizar Pedido",oPed,{|| FWMsgRun(Nil, {|oSay| A120Pedido("SC7",GetC7Recno(aPedidos[oBrowse:nAt,2]),2) }, "Visualizar Pedido", "Carregando visualização do pedido " +AllTrim(aPedidos[oBrowse:nAt,2]) +"...") },055,012,,,,.T.) //-- Visualizar pedido # Carregando visualização do pedido
	//TButton():New(nlTl1+134,nlTl2+73,"Novo Pedido"      ,oPed,{|| FWMsgRun(Nil, {|oSay| If(CriaPedido(),(MontaSelec(cSC7Tmp,aPedidos,lTudo,lMark),oBrowse:Refresh()),) }, "Pedido de Compras", "Carregando Novo Pedido...") },055,012,,,,.T.) //-- Visualizar pedido # Carregando visualização do pedido
	
	Define SButton From nlTl1+134,nlTl2+177 Type 1 Action Eval({|| If(lRet := ValidPC(lTudo,aPedidos),oPed:End(),)}) Enable Of oPed
	Define SButton From nlTl1+134,nlTl2+212 Type 2 Action oPed:End() Enable Of oPed
	
	Activate Dialog oPed Centered
	
	RestArea(aArea)
	
Return lRet

Static Function MontaSelec(cAlias,aPedidos,lTudo,lMark)
	Local nPPed := GDFieldPos("D1_PEDIDO")
	Local nPIPC := GDFieldPos("D1_ITEMPC")
	
	aSize(aPedidos,0)
	
	If lTudo
		(cAlias)->(dbGoTop())
		While (cAlias)->(!EOF())
			aAdd(aPedidos, {lMark,;                          //-- Marca
							(cAlias)->C7_NUM,;               //-- Pedido
							StoD((cAlias)->C7_EMISSAO) })    //-- Emissao
			
			//-- Se o pedido ja esta no aCols, marca como usado
			If !Empty(aCols[n,nPPed]) .And. aCols[n,nPPed] == (cAlias)->C7_NUM
				aTail(aPedidos)[1] := .T.
			EndIf
			
			(cAlias)->(dbSkip())
		EndDo
	Else
		(cAlias)->(dbGoTop())
		While (cAlias)->(!EOF())
			aAdd(aPedidos, {lMark,;                             //-- Marca
							(cAlias)->C7_NUM,;                  //-- Pedido
							(cAlias)->C7_ITEM,;                 //-- Item
							StoD((cAlias)->C7_EMISSAO),;        //-- Emissao
							(cAlias)->(C7_QUANT - C7_QTDACLA),; //-- Saldo
							(cAlias)->C7_PRECO })               //-- Preco unitario
			
			//-- Se o pedido ja esta no aCols, marca como usado
			If !Empty(aCols[n,nPPed]) .And. aCols[n,nPPed] == (cAlias)->C7_NUM .And. aCols[n,nPIPC] == (cAlias)->C7_ITEM
				aTail(aPedidos)[1] := .T.
			EndIf
			
			(cAlias)->(dbSkip())
		EndDo
	Endif

Return

Static Function CriaPedido()
	Local nX, aRatCC, aAdtPC, aRatPrj, nTotal  //, cNumPed
	Local aCabec  := {}
	Local aItens  := {}
	Local nOpc    := 3
	Local nDec    := TamSX3("C7_PRECO")[2]
	Local nPPed   := GDFieldPos("D1_PEDIDO")
	Local nPPrd   := GDFieldPos("B1_COD")
	Local nPQtd   := GDFieldPos("D1_QUANT")
	Local nPTot   := GDFieldPos("D1_TOTAL")
	Local nPDes   := GDFieldPos("D1_VALDESC")
	Local nPFre   := GDFieldPos("D1_VALFRE")
	Local nPDpe   := GDFieldPos("D1_DESPESA")
	Local nPICM   := GDFieldPos("D1_ICMSRET")
	Local nPIPI   := GDFieldPos("D1_VALIPI")
	Local nPDso   := GDFieldPos("D1_DESCZFR")
	Local nPSeg   := GDFieldPos("D1_SEGURO")
	
	Private __lPedidoOk := .F.
	
	// Calcula o próximo número do Pedido
	/*cNumPed := GetSXENum("SC7","C7_NUM")
	SC7->(dbSetOrder(1))
	While SC7->(dbSeek(xFilial("SC7")+cNumPed))
		ConfirmSX8()
		cNumPed := GetSXENum("SC7","C7_NUM")
	Enddo
	
	AAdd(aCabec,{"C7_NUM"     , cNumPed                   })*/
	AAdd(aCabec,{"C7_EMISSAO" , M->C7_EMISSAO             })
	AAdd(aCabec,{"C7_FORNECE" , SA2->A2_COD               })
	AAdd(aCabec,{"C7_LOJA"    , SA2->A2_LOJA              })
	AAdd(aCabec,{"C7_COND"    , "001"                     })
	AAdd(aCabec,{"C7_CONTATO" , CriaVar("C7_CONTATO",.F.) })
	AAdd(aCabec,{"C7_FILENT"  , cFilAnt                   })
	
	For nX:=1 To Len(aCols)
		If Empty(aCols[nX,nPPrd])
			FWAlertError("É necessário que todos os itens estejam cadastrados para criar um pedido novo !")
			aItens := {}
			Exit
		ElseIf Empty(aCols[nX,nPPed])    // Caso ainda não tenha pedido de compras informado
			nTotal := aCols[nX,nPTot] - aCols[nX,nPDes] + aCols[nX,nPFre] + aCols[nX,nPDpe] + aCols[nX,nPICM] + aCols[nX,nPIPI] - aCols[nX,nPDso] + aCols[nX,nPSeg]
			
			aLinha := {}
			AAdd(aLinha,{"C7_PRODUTO" ,aCols[nX,nPPrd],Nil})
			AAdd(aLinha,{"C7_QUANT"   ,aCols[nX,nPQtd],Nil})
			AAdd(aLinha,{"C7_PRECO"   ,Round( nTotal  / aCols[nX,nPQtd],nDec),Nil})
			AAdd(aLinha,{"C7_TOTAL"   ,nTotal,Nil})
			//AAdd(aLinha,{"C7_CLVL"    ,aCols[nX,nPCLV],Nil})
			
			AAdd(aItens,aLinha)
		Endif
	Next
	
	If !Empty(aItens)
		MATA120(1,aCabec,aItens,nOpc,.T.,aRatCC,aAdtPC,aRatPrj)
	Endif
	
Return __lPedidoOk

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
	Local nX, nY, cSeek, nPos
	Local aArea	:= GetArea()
	Local cErro := ""
	Local aPed  := {}
	Local nPIte := GDFieldPos("D1_ITEM")
	Local nPPrd := GDFieldPos("B1_COD")
	Local nPQtd := GDFieldPos("D1_QUANT")
	Local nPPed := GDFieldPos("D1_PEDIDO")
	Local nPIPC := GDFieldPos("D1_ITEMPC")
	Local nPCCu := GDFieldPos("D1_CC")
	Local nPCta := GDFieldPos("D1_CONTA")
	Local nIni  := If( lTudo , 1, n)
	Local nFim  := If( lTudo , Len(aCols), n)
	Local lRet  := .T.
	
	SC7->(dbSetOrder(2))
	
	If lTudo
		aEval( aCols , {|x| x[nPPed] := CriaVar("D1_PEDIDO",.F.), x[nPIPC] := CriaVar("D1_ITEMPC",.F.) } )   // Limpa os campos antes de todos os itens
	EndIf
	
	For nY:=nIni To nFim
		
		If lTudo .And. !Empty(aCols[nY,nPPed])   // Se já foi vinculado
			Loop
		Endif
		
		For nX := 1 To Len(aPedidos)
			
			If !aPedidos[nX,1] //-- Ignora os itens não selecionados
				Loop
			Endif
			
			cSeek := xFilial("SC7")+aCols[nY,nPPrd]+cCodFor+cLojFor+aPedidos[nX,2]
			
			// Carrega no vetor o pedido + produto caso ele ainda não exista
			If AScan( aPed , {|x| x[1] == cSeek } ) == 0
				SC7->(dbSeek(cSeek,.T.))
				While !SC7->(Eof()) .And. SC7->C7_FILIAL+SC7->C7_PRODUTO+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_NUM == cSeek
					AAdd( aPed ,  { cSeek, SC7->C7_NUM, SC7->C7_ITEM, SC7->C7_QUANT - SC7->C7_QUJE, SC7->C7_CC, SC7->C7_CONTA} )
					SC7->(dbSkip())
				Enddo
			Endif
			
			nPos := AScan( aPed , {|x| x[1] == cSeek .And. aCols[nY,nPQtd] <= x[4] })
			If nPos > 0
				aCols[nY,nPPed] := aPed[nPos,2]
				aCols[nY,nPIPC] := aPed[nPos,3]
				aCols[nY,nPCCu] := aPed[nPos,5]
				aCols[nY,nPCta] := aPed[nPos,6]
				
				aPed[nPos,4] -= aCols[nY,nPQtd]   // Atualiza os saldos do item
			ElseIf AScan( aPed , {|x| x[1] == cSeek }) > 0
				cErro += "<br />Item " + aCols[nY,nPIte] + " - " + Trim(aCols[nY,nPPrd]) + " Sem saldo no Pedido " + aPedidos[nX,2]
			Else
				cErro += "<br />Item " + aCols[nY,nPIte] + " - " + Trim(aCols[nY,nPPrd]) + " Não localizado no Pedido " + aPedidos[nX,2]
			Endif
		Next nX
		
	Next nY
	
	RestArea(aArea)
	
	If !Empty(cErro)
		FWAlertWarning("<strong>Os itens abaixo não foram atualizado conforme pedido(s) selecionado(s):</strong><br />"+cErro)
	Endif
	
Return lRet

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

User Function BJCMP01Valid()
	Local nX, nPPrd, nPSel, nPQtd, nPQtS, nPPrc, nPPrS, nPDel, nPVal, aFabric, nTotal
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
	ElseIf cVar == "M->A5_PRODUTO"
		If lRet := ExistCpo("SB1")
			aFabric := Fabricante(M->A5_FORNECE+M->A5_LOJA+M->A5_PRODUTO)
			
			If !Empty(aFabric[1])
				M->A5_FABR   := aFabric[1]
				M->A5_FALOJA := aFabric[2]
			Endif
			
			SA5->(dbSetorder(1))   // A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO+A5_FABR+A5_FALOJA
			lRet := ExistChav("SA5",M->A5_FORNECE+M->A5_LOJA+M->A5_PRODUTO+M->A5_FABR+M->A5_FALOJA)
		Endif
	Endif
	
Return lRet

Static Function Calc2aUM(nPos,nPSel,nPPrd,nPQtS,nPQtd,nPPrS,nPPrc,nPTot)
	Local nAux := n
	
	n := nPos
	
	If aCols[n,nPSel] <> M->CY_PENDEN
		If Posicione("SB1",1,XFILIAL("SB1")+aCols[n,nPPrd],"B1_CONV") > 0
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
		Else
			aCols[n,nPSel] := "N"
		Endif
	Endif
	
	n := nAux
	
Return

User Function COMP09Del()
	Local nX, nTotal
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
 
 Static Function MudaPasta()
	Local cArquivo := ""
	Local cCaminho := ""
	Local nError   := 0
	Local nPos     := Len(cPathFile)

	If !lFile     // Caso não seja um arquivo em disco
		Return
	Endif
	
	// Identifica o início do caminho arquivo
	While nPos > 0 .And. SubStr(cPathFile,nPos,1) <> "\"
		nPos--
	Enddo
	
	If nPos > 0
		cCaminho := PADR(cPathFile,nPos-1)
		cArquivo := SubStr(cPathFile,nPos+1,Len(cPathFile))
		
		// Cria o diretório que armazena os XML lidos
		If !ExistDir(cCaminho+"\Lidos")
			If (nError := MakeDir(cCaminho+"\Lidos")) <> 0
				FwAlertError("Não foi possível criar o diretório "+cCaminho+"\Lidos"+". Erro: " + cValToChar( FError() ) )
			Endif
		Endif
		
		// Move o arquivo processado para a pasta LIDOS
		If nError == 0 .And. FRename(cPathFile,cCaminho+"\Lidos\"+cArquivo) < 0
			FwAlertError("Ocorreu um erro ao mover o arquivo " + Str(FError(),4) )
		Endif
	Endif

Return

Static Function AtuCampos(lRefresh)
	Local nPos
	Local aArea := SD1->(GetArea())
	Local lEAN  := (SD1->(FieldPos("D1_XCODBAR")) > 0)   // Caso o campo exista
	Local nPIte := fGetIndice("D1_ITEM")
	Local cSeek := SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
	Local lOk   := .F.
	
	SD1->(dbSetOrder(1))
	SD1->(dbSeek(cSeek,.T.))
	While !SD1->(Eof()) .And. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == cSeek
		
		// Carrega os campos gravados na nota
		nPos := AScan( aCols , {|x| x[nPIte] == SD1->D1_ITEM })
		If nPos > 0
			aCols[nPos,fGetIndice("B1_COD"    )] := SD1->D1_COD
			aCols[nPos,fGetIndice("B1_DESC"   )] := SD1->&( cFldDesc )
			aCols[nPos,fGetIndice("D1_LOCAL"  )] := SD1->D1_LOCAL
			aCols[nPos,fGetIndice("D1_UM"     )] := SD1->D1_UM
			aCols[nPos,fGetIndice("D1_CC"     )] := SD1->D1_CC
			aCols[nPos,fGetIndice("D1_CONTA"  )] := SD1->D1_CONTA
			aCols[nPos,fGetIndice("D1_XDESXML")] := SD1->D1_XDESXML
			aCols[nPos,fGetIndice("D1_XUMXML" )] := SD1->D1_XUMXML
			aCols[nPos,fGetIndice("D1_XQTDXML")] := SD1->D1_XQTDXML
			If lEAN
				aCols[nPos,fGetIndice("D1_XCODBAR")] := SD1->D1_XCODBAR
			Endif
		Endif
		
		If Empty(SD1->D1_XDESXML) .Or. Empty(SD1->D1_XQTDXML) .Or. Empty(SD1->D1_XUMXML) .Or. (SD1->(FieldPos("D1_XITXML")) > 0 .And. Empty(SD1->D1_XITXML))
			lOk := .T.
		Endif
		
		SD1->(dbSkip())
	Enddo
	SD1->(RestArea(aArea))
	
	oItens:Refresh()
	
	If !lRefresh .And. lOk .And. GetMV("MV_XUPDFLD",.F.,.F.)    // Define se atualiza os campos do XML para uma nota já cadastrada
		If FWAlertYesNo("Deseja atualizar para essa nota os campos obrigatórios para o SPED ?")
			u_NEImpXMLNFE(cPathFile,SF1->F1_TIPO)
			AtuCampos(.T.)
		Endif
	Endif

Return

Static Function ConfigCampos(aCampos)
	Local nX
	Local aRet := {}
	
	SX3->(dbSetOrder(2))
	For nX:=1 To Len(aCampos)
		If !Empty( FWTamSX3(aCampos[nX][1]) )
			aAdd(aRet,{	GetSx3Cache(aCampos[nX,1],'X3_TITULO')   , ;
						GetSx3Cache(aCampos[nX,1],'X3_CAMPO')    , ;
						GetSx3Cache(aCampos[nX,1],'X3_TIPO')     , ;
						GetSx3Cache(aCampos[nX,1],'X3_TAMANHO')  , ;
						GetSx3Cache(aCampos[nX,1],'X3_DECIMAL')  , ;
						GetSx3Cache(aCampos[nX,1],'X3_PICTURE')  , ;
						{||u_BJCMP01Valid()}, ;
						aCampos[nX,2]    , ;   // Obrigatório
						GetSx3Cache(aCampos[nX,1],'X3_NIVEL')    , ;
						GetSx3Cache(aCampos[nX,1],'X3_RELACAO')  , ;
						aCampos[nX,4]    , ;   // F3
						aCampos[nX,5]    , ;   // When
						!aCampos[nX,3]   , ;   // Visual
						.F.              , ;   // Chave
						If( aCampos[nX,6]==Nil,GetSx3Cache(aCampos[nX,1],'X3_CBOX'),aCampos[nX,6]), ;
						Val(GetSx3Cache(aCampos[nX,1],'X3_FOLDER')), ;
						.F.              , ;
						GetSx3Cache(aCampos[nX,1],'X3_PICTVAR')  , ;
						GetSx3Cache(aCampos[nX,1],'X3_TRIGGER')  } )
		Endif
	Next

Return aRet

Static Function InicEmpFilSM0(cCodFil)
	cFilAnt := PADR(cCodFil,Len(cFilAnt))
	FWSM0Util():setSM0PositionBycFilAnt()    // Posiciona no registro da tabela de empresas (SM0)
Return

Static Function PesqXML(cXML)
	Local aArea  := GetArea()
	Local cTmp   := GetNextAlias()
	Local nRecno := 0
	Local cQry   := ""
	
	cQry += "SELECT ISNULL(ZZZ.R_E_C_N_O_,0) AS ZZZ_RECNO"
	cQry += " FROM " + RetSqlName("ZZZ") +" ZZZ"
	cQry += " WHERE ZZZ.D_E_L_E_T_ = ' '"
	cQry += " AND ZZZ.ZZZ_CHAVE = '" + Trim(cXML) + "'"
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQry)),cTmp,.T.,.T.)
	nRecno := (cTmp)->ZZZ_RECNO
	dbCloseArea()
	RestArea(aArea)
	
	If nRecno > 0
		dbSelectArea("ZZZ")
		dbGoTo(nRecno)
		cXML := ZZZ->ZZZ_XML
	Endif

Return nRecno > 0 .And. !Empty(cXML)

Static Function CamposProduto()
	Local aRet := {}
	
	AAdd( aRet , { "B1_CODBAR" , Nil       } )
	AAdd( aRet , { "B1_TIPO"   , {|| "PA" }} )
	AAdd( aRet , { "B1_UM"     , {|| "UN" }} )
	AAdd( aRet , { "B1_LOCPAD" , {|| "01" }} )
	AAdd( aRet , { "B1_GRUPO"  , Nil       } )
	//AAdd( aRet , { "B1_MARCA"  , Nil       } )
	//AAdd( aRet , { "B1_TE"     , {|| CondProduto(1) } } )
	//AAdd( aRet , { "B1_YTTE"   , {|| CondProduto(2) } } )
	//AAdd( aRet , { "B1_TS"     , {|| CondProduto(3) } } )
	//AAdd( aRet , { "B1_YTTS"   , {|| CondProduto(4) } } )
	AAdd( aRet , { "B1_CONV"   , {|| 1 }   } )
	AAdd( aRet , { "B1_PESO"   , {|| 1 }   } )
	AAdd( aRet , { "B1_FIELD"  , Nil       } )
	AAdd( aRet , { "B1_CONTA"  , Nil       } )  //{|| "113010" //+  ( OS DOIS ÚLTIMOS DIGITOS, ESTÁ RELACIONADO AO PROMEIRO DIGITO DO GRUPO. 
	//AAdd( aRet , { "B1_FORAEST", {|| If(SA2->A2_EST==GetMV("MV_ESTADO"),"N","S") } } )
	AAdd( aRet , { "B1_LOCAL"  , Nil       } )
	AAdd( aRet , { "B1_PROC"   , {|| SA2->A2_COD } } )
	//AAdd( aRet , { "B1_CODGTIN", Nil       } )
	AAdd( aRet , { "B1_POSIPI" , Nil       } )
	AAdd( aRet , { "B1_ORIGEM" , {|| aCols[n][fGetIndice("B1_ORIGEM")] } } )
	AAdd( aRet , { "B1_GRTRIB" , {|| If( aCols[n][fGetIndice("B1_ORIGEM")] $ "1238" , "001", "002") } } )
	//AAdd( aRet , { "B1_FAMPRO" , Nil       } )
	//AAdd( aRet , { "B1_MKPVARE", Nil       } )
	//AAdd( aRet , { "B1_MKPATAC", Nil       } )
	AAdd( aRet , { "B1_CEST"   , {|| aCols[n][fGetIndice("B1_CEST")] } } )
	//AAdd( aRet , { "B1_FAMPRO" , Nil       } )
	//AAdd( aRet , { "B1_PESBRU" , Nil       } )
	//AAdd( aRet , { "B1_FAXGAR" , Nil       } )
	//AAdd( aRet , { "B1_YFAXGA2", Nil       } )
	//AAdd( aRet , { "B1_REFEREN", Nil       } )
	AAdd( aRet , { "B1_PICM"   , Nil       } )
	//AAdd( aRet , { "B1_GARFABI", Nil       } )
	//AAdd( aRet , { "B1_YGARANT", Nil       } )

Return aRet

Static Function CondProduto(nOpc)
	Local aTES := { "   ", "   ", "   ", "   "}
	
	If aCols[n][fGetIndice("B1_ORIGEM")] == "5"
		If SA2->A2_EST == GetMV("MV_ESTADO")
			If Empty(aCols[n][fGetIndice("B1_CEST")])
				aTES := { "203", "003", "501", "502"}
			Endif
		Else
			If Empty(aCols[n][fGetIndice("B1_CEST")])
				aTES := { "203", "003", "501", "502"}
			Else
				aTES := { "255", "004", "580", "503"}
			Endif
		Endif
	Endif

Return aTES[nOpc]

Static Function CriaPerg(aPerg,lGrv)
	Local aLinha, x, nTam, cLinha
	Local nPos  := 0
	Local aUser := {}
	Local cPerg := GetSrvProfString("StartPath","") + Trim(FunName()) + ".SX1"
	
	If !File(cPerg)
		fHandle := FCREATE(cPerg)
		FCLOSE(fHandle)
	Endif
	
	fHandle := FT_FUSE(cPerg)
	FT_FGOTOP()
	While !FT_FEOF()
		cLinha := FT_FREADLN()
		aLinha := {}
		nTam   := 0
		
		// Adiciona o usuário
		AAdd( aLinha , SubStr(cLinha,1,30) )
		nTam += 30
		
		For x:=1 To Len(aPerg)
			AAdd( aLinha , SubStr(cLinha,nTam+1,aPerg[x,3]) )
			nTam += aPerg[x,3]
		Next
		
		AAdd( aUser , aClone(aLinha) )
		
		// Pesquisa o usuário no arquivo de perguntas
		If cUserName == PADR(cLinha,Len(cUserName))
			nPos := Len(aUser)
		Endif
		
		FT_FSKIP()
	Enddo
	FT_FUSE()
	
	If nPos == 0
		AAdd( aUser , Nil )
		nPos := Len(aUser)
	Endif
	aLinha := {}
	AAdd( aLinha , PADR(cUserName,30) )
	
	If lGrv
		FErase(cPerg)
		fHandle := FCREATE(cPerg)
		
		For x:=1 To Len(aPerg)
			
			If aPerg[x,4] == "C"
				aPerg[x,7] := AScan( aPerg[x,9] , aPerg[x,7] )
			Endif
			
			aPerg[x,7] := &("mv_par"+StrZero(x,2))
			
			aPerg[x,7] := If( aPerg[x,2] == "N" , Str(aPerg[x,7],aPerg[x,3]), If( aPerg[x,2] == "D" , PADR(Dtoc(aPerg[x,7]),10), PADR(aPerg[x,7],aPerg[x,3])))
			
			AAdd( aLinha , aPerg[x,7] )
		Next
		
		aUser[nPos] := aClone(aLinha)
		
		For x:=1 To Len(aUser)
			cLinha := ""
			aEval( aUser[x] , {|y| cLinha += y } )
			FWRITE( fHandle , cLinha+Chr(13)+Chr(10) )
		Next
		
		FCLOSE(fHandle)
	ElseIf nPos > 0
		
		// Caso não existe referência de perguntas para o usuário
		If aUser[nPos] == Nil
			aEval( aPerg , {|x| x[7] := If( x[4] == "C" , "1", If( x[2] == "N" , "0", Space(x[3]))), AAdd( aLinha , x[7] ) })
			aUser[nPos] := aClone(aLinha)
		Endif
		
		For x:=1 To Len(aPerg)
			aPerg[x,7] := If( aPerg[x,2] == "N" , Val(aUser[nPos,x+1]), If( aPerg[x,2] == "D" , Ctod(aUser[nPos,x+1]), aUser[nPos,x+1]))
			
			&("mv_par"+StrZero(x,2)) := aPerg[x,7]
			
			If aPerg[x,4] == "C"
				aPerg[x,7] := aPerg[x,9][If( aPerg[x,7] > 0 .And. aPerg[x,7] <= Len(aPerg[x,9]) , aPerg[x,7], 1)]
				&("mv_par"+StrZero(x,2)) := Ascan(aPerg[x,9],aPerg[x,7])
			Endif
		Next
	Endif
	
Return

Static Function PosObjetos(aSize,aPosObj)
	Local aInfo
	Local aObjects := {}
	
	//aSize    := MsAdvSize(.T.,.F.)
	//aPosGet  := MsObjGetPos(aSize[3]-aSize[1], aSize[4]-aSize[2],{{003,073,103}} )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize(.T.,.F.)
	AAdd( aObjects, { 100,  40, .t., .f. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100,  30, .t., .f. } )
	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
Return

/*Static Function LeCoord()
	Local nHdl, nX, nTam
	Local cFile := "D:\TOTVS\COORD.TXT"
	Local aRet  := {}
	
	If File(cFile)
		nHdl := FT_FUSE(cFile)
		FT_FGOTOP()
		While !FT_FEOF()
			AAdd( aRet , Separa(AllTrim(FT_FREADLN()),",",.F.) )
			nTam := Len(aRet)
			For nX:=1 To Len(aRet[nTam])
				aRet[nTam,nX] := Val(aRet[nTam,nX])
			Next
			FT_FSKIP()
		Enddo
		FT_FUSE()
	Endif
	
Return aRet*/
