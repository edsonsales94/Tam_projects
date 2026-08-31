#INCLUDE "Protheus.ch"
#Include "vkey.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MGFATA01   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 06/03/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Manutenção das Vendas Pendentes                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
User Function MGFATA01()
	Local aCores      := {	{"Z6_STATUS=='1'","ENABLE"    },; // INTEGRAÇÃO PENDENTE
							{"Z6_STATUS=='2'","BR_AMARELO"},; // INTEGRAÇÃO COM ERRO
							{"Z6_STATUS=='3'","DISABLE"   }}  // INTEGRAÇÃO PROCESSADA
	
	Private cCadastro := "Manutenção das Vendas Pendentes"
	Private cAlias1   := "SZ6"
	Private cAlias2   := "SZ7"
	Private cAlias3   := "SZ8"
	Private aRotina   := {	{"Pesquisar" ,"AxPesqui"     ,0,1} ,;
							{"Visualizar","u_FAT01Inclui",0,2} ,;
							{"Incluir"   ,"u_FAT01Inclui",0,3} ,;
							{"Alterar"   ,"u_FAT01Inclui",0,4} ,;
							{"Processar" ,"u_FAT01Proces",0,6} ,;
							{"Processar Lote" ,"u_FAT01Proces",0,7} /*, {"Excluir"   ,"u_FAT01Inclui",0,5}*/ }
	
	dbSelectArea(cAlias1)
	dbSetOrder(1)
	
	mBrowse( 6,1,22,75,cAlias1,,,,,,aCores)
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦FAT01Inclui ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 06/03/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Edição das Vendas Pendentes                                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FAT01Inclui(cAlias, nRecNo, nOpc )
	Local aPosObj, aSize, aPosGet
	Local nX         := 0
	Local nOpcA      := 0
	Local oMainWnd   := Nil
	Local oFolder    := Nil
	Local aAltera2   := {}
	Local aAltera3   := {}
	
	Private oDlg     := Nil
	Private oGet1    := Nil
	Private oGet2    := Nil
	Private aTela    := {}
	Private aGets    := {}
	Private aHeader  := {}
	Private aCols    := {}
	Private aHeader2 := {}
	Private aHeader3 := {}
	Private aCols2   := {}
	Private aCols3   := {}
	Private bCampo   := { |nField| Field(nField) }
	Private Inclui   := .F.
	Private Altera   := .T.
	Private nPD      := 1
	Private cFilSZ7  := xFilial(cAlias2)
	Private cFilSZ8  := xFilial(cAlias3)
	
	If nOpc == 3 .Or. nOpc == 5
		FWAlertError("Não é permitido acessar essa opção da rotina !")
		Return
	Endif
	
	//+----------------------------------
	//| Inicia as variaveis para Enchoice
	//+----------------------------------
	dbSelectArea(cAlias1)
	dbSetOrder(1)
	dbGoTo(nRecNo)
	For nX:= 1 To FCount()
		If Inclui
			M->&(Eval(bCampo,nX)) := CriaVar(FieldName(nX),.T.)
		Else
			M->&(Eval(bCampo,nX)) := FieldGet(nX)
		Endif
	Next nX
	
	//+----------------
	//| Monta os aCols
	//+----------------
	MontaaCols(@aAltera2,@aAltera3)
	
	//+----------------------------------
	//| Inicia as posições dos objetos
	//+----------------------------------
	PosObjetos(@aSize,@aPosObj,@aPosGet)
	
	If (cAlias1)->Z6_TIPONF == "D"
		SetKey(VK_F4,{|| F4NForig() })
	Endif

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 TO aSize[6],aSize[5] PIXEL OF oMainWnd
	
	EnChoice(cAlias, nRecNo, nOpc,,,,,aPosObj[1],, 3,,,,oDlg)
	
	@ aPosObj[2,1],aPosObj[2,2] FOLDER oFolder OF oDlg PROMPT "&Itens","&Parcelas" PIXEL SIZE aPosObj[2,4]-aPosObj[2,2], aPosObj[2,3]-aPosObj[2,1]
	
	// Objetos do Folder Parcelas
	aHeader := aClone(aHeader3)
	aCols   := aClone(aCols3)
	oGet2   := MSGetDados():New(aPosGet[1,1],aPosGet[1,2],aPosGet[1,3],aPosGet[1,4],nOpc,"u_FAT01LinOk(,2)","u_FAT01TudOk(2)",,.T.,,,,Len(aCols),,,,"u_FAT01DelIt()",oFolder:aDialogs[2])
	oGet2:oBrowse:lDisablePaint := .T.
	
	// Objetos do Folder Itens
	aHeader := aClone(aHeader2)
	aCols   := aClone(aCols2)
	oGet1   := MSGetDados():New(aPosGet[1,1],aPosGet[1,2],aPosGet[1,3],aPosGet[1,4],nOpc,"u_FAT01LinOk(,1)","u_FAT01TudOk(1)",,.T.,,,,Len(aCols),,,,"u_FAT01DelIt()",oFolder:aDialogs[1])
	oGet1:oBrowse:lDisablePaint := .F.
	
	oFolder:bSetOption := {|nAtu| FAT01Folder(nAtu,oFolder:nOption,{oGet1,oGet2}) }
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT ( FAT01Refresh({oGet1,oGet2}) ,;
												EnchoiceBar(oDlg,;
												{|| nOpcA := If( FAT01Folder(oFolder:nOption,oFolder:nOption,{oGet1,oGet2}) .And.;
												Obrigatorio(aGets,aTela) ,1,0), If(nOpcA==1,oDlg:End(),) },;
												{|| nOpcA:=0,oDlg:End()} ))
	
	If (cAlias1)->Z6_TIPONF == "D"
		SetKey(VK_F4,{|| F4NForig() })
	Endif
	
	If nOpca == 1
		Begin Transaction
		FAT01Grava(nOpc,nRecNo,aAltera2,aAltera3)
		End Transaction
	ElseIf nOpc == 3
		RollBackSX8()
	Endif
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FAT01DelIt ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 06/03/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar delecao dos itens                                     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FAT01DelIt()
	//Local x
	Local lRet := .F.
	/*Local nDel := Len(aCols[1])
	
	If nPD == 2 //.And. aCols[n,nDel] // Na delecao da linha - 2a. passagem
	ElseIf nPD == 1 .And. aCols[n,nDel] // Na recuperacao da linha - 1a. passagem
		For x:=1 To Len(aCols)
			If aCols[x,1] == aCols[n,1] .And. x <> n .And. !aCols[x,nDel]
				If lRet := ExistChav("SX5","01")
					Exit
				Endif
			Endif
		Next
	Endif
	nPD := If( nPD == 2 , 1, nPD + 1)*/
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FAT01Valid ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 06/03/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar os campos da regra de juros                           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FAT01Valid()
	Local cVar := Trim(Upper(ReadVar()))
	Local lRet := .T.
	
	If cVar == "M->Z7_TES"
		If lRet := ExistCpo("SF4")
			If lRet := (M->Z7_TES >= "500")
			Else
				FWAlertError("TES informado não é válido para a saída !")
			Endif
		Endif
	ElseIf cVar == "M->Z7_CF"
		If lRet := ExistCpo("SX5","13"+M->Z7_CF)
			If lRet := (M->Z7_CF >= "5000")
			Else
				FWAlertError("CFOP informado não é válido para a saída !")
			Endif
		Endif
	Endif
	
Return lRet

Static Function F4NForig()
	Local nX
	Local aCampos  := {}
	Local aColAux  := aClone(aCols)
	Local aHeaAux  := aClone(aHeader)
	Local nPNFOri  := GDFieldPos("Z7_NFORIG" )
	Local nPSeOri  := GDFieldPos("Z7_SERIORI")
	Local nPItOri  := GDFieldPos("Z7_ITEMORI")
	Local cProduto := GDFieldGet("Z7_PRODUTO")
	//Local cError   := ""
	//Local bError   := ErrorBlock({ |oError| cError := oError:Description })
	
	SetKey(VK_F4,{|| Nil } )
	
	// Cria variáveis do pedido de venda para compatibilizar com a consulta
	M->C5_NUM     := CriaVar("C5_NUM",.F.)
	M->C5_TIPO    := M->Z6_TIPONF
	M->C5_CLIENTE := M->Z6_CLIENTE
	M->C5_LOJACLI := M->Z6_LOJA
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³F4 para Complementos e Devolucao                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( "Z7_NFORI" $ ReadVar() .And. M->C5_TIPO $ "D" )    // Nf de Origem
		// Monta o cabeçalho dos itens do pedido de venda para compatibilizar com a consulta
		AAdd( aCampos , { "C6_ITEM"   , {|| StrZero(1,TamSX3("C6_ITEM")[1]) }} )
		AAdd( aCampos , { "C6_PRODUTO", {|| cProduto }} )
		AAdd( aCampos , { "C6_QTDVEN" , Nil } )
		AAdd( aCampos , { "C6_PRCVEN" , Nil } )
		AAdd( aCampos , { "C6_PRUNIT" , Nil } )
		AAdd( aCampos , { "C6_VALOR"  , Nil } )
		AAdd( aCampos , { "C6_SEGUM"  , Nil } )
		AAdd( aCampos , { "C6_TES"    , Nil } )
		AAdd( aCampos , { "C6_CF"     , Nil } )
		AAdd( aCampos , { "C6_VALDESC", Nil } )
		AAdd( aCampos , { "C6_DESCONT", Nil } )
		AAdd( aCampos , { "C6_CLASFIS", Nil } )
		AAdd( aCampos , { "C6_QTDLIB" , Nil } )
		AAdd( aCampos , { "C6_NFORI"  , Nil } )
		AAdd( aCampos , { "C6_SERIORI", Nil } )
		AAdd( aCampos , { "C6_ITEMORI", Nil } )

		aHeader := {}
		For nX:=1 To Len(aCampos)
			u_MGAdicionaCampo(aCampos[nX,1] ,aHeader)
		Next
		
		// Monta os itens do pedido de venda para compatibilizar com a consulta
		aCols := {}
		AAdd( aCols , {} )
		For nX:=1 To Len(aCampos)
			AAdd( aCols[1] , If( ValType(aCampos[nX,2]) <> "U" , Eval(aCampos[nX,2]), CriaVar(aCampos[nX,1],.F.)) )
		Next
		AAdd( aCols[1] , .F. )
		
		//Begin Sequence
			
			If F4NfOri(,,,M->C5_CLIENTE,M->C5_LOJACLI,cProduto,"A440")
				aColAux[n,nPNFOri] := aCols[1,Len(aHeader)-2]
				aColAux[n,nPSeOri] := aCols[1,Len(aHeader)-1]
				aColAux[n,nPItOri] := aCols[1,Len(aHeader)-0]
			Endif

		//End Sequence
		
		//Restaurando bloco de erro do sistema
		//ErrorBlock(bError)
		
		aCols   := aClone(aColAux)
		aHeader := aClone(aHeaAux)
		
		//If !Empty(cError)
		//	FWAlertError(cError)
		//Endif
	Endif
	
	SetKey(VK_F4,{|| F4NForig() })

Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FAT01LinOk ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 06/03/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar a linha do item                                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FAT01LinOk(nPos,nFolder)
	Local nDel  := Len(aCols[1])
	Local nPCFO := AScan( aHeader , {|x| Trim(x[2]) == "Z7_CF"      } )
	Local nPCFC := AScan( aHeader , {|x| Trim(x[2]) == "Z7_CFORI"   } )
	Local nPPrd := AScan( aHeader , {|x| Trim(x[2]) == "Z7_PRODUTO" } )
	Local nPNFO := AScan( aHeader , {|x| Trim(x[2]) == "Z7_NFORIG"  } )
	Local nPSeO := AScan( aHeader , {|x| Trim(x[2]) == "Z7_SERIORI" } )
	Local nPItO := AScan( aHeader , {|x| Trim(x[2]) == "Z7_ITEMORI" } )
	Local lRet  := .T.
	
	nPos := If( nPos == Nil , n, nPos)
	
	If nFolder == 1 .And. /*nPos > 1 .And.*/ !aCols[nPos,nDel]  // Se for o Folder Itens
		If M->Z6_TIPONF == "D" .And. (!Empty(aCols[n,nPNFO]) .Or. !Empty(aCols[n,nPNSeO]) .Or. !Empty(aCols[n,nPNItO]))
			SD1->(dbSetOrder(1))   // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
			If lRet := SD1->(dbSeek(XFILIAL("SD1")+aCols[n,nPNFO]+aCols[n,nPSeO]+M->Z6_CLIENTE+M->Z6_LOJA+aCols[n,nPPrd]+aCols[n,nPItO]))
				If lRet := ( SD1->D1_QTDEDEV < SD1->D1_QUANT )
				Else
					FWAlertError("Não existe saldo para devolução na NF origem !")
				Endif
			Else
				FWAlertError("Os dados informados na NF origem não existem !")
			Endif
		Endif
		
		If lRet .And. aCols[n,nPCFO] <> aCols[n,nPCFC]
			lRet := .F.
			FWAlertError("O CFOP do item não pode ser diferente do CFOP da venda !")
		Endif
	Endif
	
Return(lRet)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FAT01TudOk ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 06/03/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar todas as linhas dos itens                             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FAT01TudOk(nFolder)
	Local x
	Local lRet := .T.
	
	For x:=1 To Len(aCols)
		If !(lRet := u_FAT01LinOk(x,nFolder))
			Exit
		Endif
	Next
	
Return(lRet)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FAT01Grava ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 06/03/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Grava os dados da Regra de Descontos                          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦ Parâmetro ¦ nOpc     -> Tipo da função (inclui,altera,exclui)             ¦¦¦
|¦¦           ¦ nRecNo   -> Numero do registro a ser gravado                  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function FAT01Grava(nOpc,nRecNo,aAltera2,aAltera3)
	Local nX, nY, nDel
	Local cFilSZ6 := xFilial(cAlias1)
	
	//+-----------------
	//| Se for inclusão
	//+-----------------
	If nOpc == 3
		//+--------------------------------------
		//| Grava os dados referente a VENDA PENDENTE
		//+--------------------------------------
		dbSelectArea(cAlias1)
		RecLock(cAlias1,.T.)
		For nX := 1 To FCount()
			If "FILIAL" $ FieldName(nX)
				FieldPut(nX,cFilSZ6)
			Else
				FieldPut(nX,M->&(Eval(bCampo,nX)))
			Endif
		Next nX
		MsUnLock()
		
		//+--------------------------------------
		//| Grava os dados referente aos ITENS DA VENDA PENDENTE
		//+--------------------------------------
		nDel := Len(aHeader2) + 1
		dbSelectArea(cAlias2)
		dbSetOrder(1)
		For nX := 1 To Len(aCols2)
			If !aCols2[nX][nDel] .And. !Empty(aCols2[nX][2])
				RecLock(cAlias2,.T.)
				For nY := 1 To Len(aHeader2)
					FieldPut(FieldPos(Trim(aHeader2[nY,2])),aCols2[nX,nY])
				Next nY
				SZ7->Z7_FILIAL := cFilSZ7
				SZ7->Z7_NUM    := M->Z6_NUM
				MsUnLock()
			Endif
		Next nX
		
		//+--------------------------------------
		//| Grava os dados referente as PARCELAS
		//+--------------------------------------
		nDel := Len(aHeader3) + 1
		dbSelectArea(cAlias3)
		dbSetOrder(1)
		For nX := 1 To Len(aCols3)
			If !aCols3[nX][nDel] .And. !Empty(aCols3[nX][1])
				RecLock(cAlias3,.T.)
				For nY := 1 To Len(aHeader3)
					FieldPut(FieldPos(Trim(aHeader3[nY,2])),aCols3[nX,nY])
				Next nY
				SZ8->Z8_FILIAL := cFilSZ8
				SZ8->Z8_NUM    := M->Z6_NUM
				MsUnLock()
			Endif
		Next nX
		
	Endif
	
	//+-----------------
	//| Se for alteracao
	//+-----------------
	If nOpc == 4
		//+--------------------------------------
		//| Grava os dados referente a VENDA PENDENTE
		//+--------------------------------------
		dbSelectArea(cAlias1)
		dbGoTo(nRecNo)
		RecLock(cAlias1,.F.)
		For nX := 1 To FCount()
			If "FILIAL" $ FieldName(nX)
				FieldPut(nX,cFilSZ6)
			Else
				FieldPut(nX,M->&(Eval(bCampo,nX)))
			Endif
		Next nX
		MsUnLock()
		
		//+--------------------------------------
		//| Grava os dados referente aos ITENS DA VENDA
		//+--------------------------------------
		nDel := Len(aHeader2) + 1
		dbSelectArea(cAlias2)
		dbSetOrder(1)
		For nX := 1 To Len(aCols2)
			
			// Caso os itens adicionados à mais estejam deletados, então ignora
			If Empty(aCols2[nX,2]) .Or. nX > Len(aAltera2) .And. aCols2[nX,nDel]
				Loop
			Endif
			
			If nX <= Len(aAltera2)
				dbGoTo(aAltera2[nX])  // Posiciona no registro da Posicao
				RecLock(cAlias2,.F.)
			Else
				RecLock(cAlias2,.T.)
				SZ7->Z7_FILIAL := cFilSZ7
				SZ7->Z7_NUM    := M->Z6_NUM
			Endif
			
			If aCols2[nX,nDel]
				dbDelete()
			Else
				For nY := 1 To Len(aHeader2)
					FieldPut( FieldPos(Trim(aHeader2[nY,2])) , aCols2[nX,nY] )
				Next
			Endif
			
			MsUnLock()
		Next nX
		
		//+--------------------------------------
		//| Grava os dados referente as PARCELAS
		//+--------------------------------------
		nDel := Len(aHeader3) + 1
		dbSelectArea(cAlias3)
		dbSetOrder(1)
		For nX := 1 To Len(aCols3)
			
			// Caso os itens adicionados à mais estejam deletados, então ignora
			If nX > Len(aAltera3) .And. aCols3[nX,nDel]
				Loop
			Endif
			
			If nX <= Len(aAltera3)
				dbGoTo(aAltera3[nX])  // Posiciona no registro da Posicao
				RecLock(cAlias3,.F.)
			Else
				RecLock(cAlias3,.T.)
				SZ8->Z8_FILIAL := cFilSZ8
				SZ8->Z8_NUM    := M->Z6_NUM
			Endif
			
			If aCols3[nX,nDel]
				dbDelete()
			Else
				For nY := 1 To Len(aHeader3)
					FieldPut( FieldPos(Trim(aHeader3[nY,2])) , aCols3[nX,nY] )
				Next
			Endif
			
			MsUnLock()
		Next nX
		
	Endif
	
	//+-----------------
	//| Se for exclusão
	//+-----------------
	If nOpc == 5
		//+--------------------------------------
		//| Exclui os dados referente a REGRA DE DESCONTOS
		//+--------------------------------------
		dbSelectArea(cAlias1)
		dbGoTo(nRecNo)
		RecLock(cAlias1,.F.)
		dbDelete()
		MsUnLock()
		
		//+--------------------------------------
		//| Exclui os dados referente aos ITENS DA REGRA DE DESCONTO
		//+--------------------------------------
		dbSelectArea(cAlias2)
		dbSetOrder(1)
		For nX := 1 To Len(aCols2)
			
			If !Empty(aCols2[nX,2])
				dbGoTo(aAltera2[nX])  // Posiciona no registro da Posicao
				RecLock(cAlias2,.F.)
				dbDelete()
				MsUnLock()
			Endif
		Next nX
		
		//+--------------------------------------
		//| Exclui os dados referente as ADMINISTRADORAS FINANCEIRAS
		//+--------------------------------------
		dbSelectArea(cAlias3)
		dbSetOrder(1)
		For nX := 1 To Len(aCols3)
			
			If !Empty(aCols3[nX,1])
				dbGoTo(aAltera3[nX])  // Posiciona no registro da Posicao
				RecLock(cAlias3,.F.)
				dbDelete()
				MsUnLock()
			Endif
		Next nX
		
	Endif
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CriaHeader ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 06/03/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria a variavel vetor aHeader                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CriaHeader()
	
	aHeader2 := u_MGCriaHeader(cAlias2,.T.,{"Z7_NUM"})    // Cria aHeader com os dados dos ITENS DA VENDA
	aHeader3 := u_MGCriaHeader(cAlias3,.T.,{"Z8_NUM"})    // Cria aHeader com os dados das PARCELAS DA VENDA
	
	aEval( aHeader2 , {|x| x[6] := "u_FAT01Valid()" } )
	aEval( aHeader3 , {|x| x[6] := "u_FAT01Valid()" } )
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MontaaCols ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 06/03/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria a variavel vetor aCols2 e aCols3                         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function MontaaCols(aAltera2,aAltera3)
	Local nCols, nUsado, nX
	
	//+--------------
	//| Monta o aHeader
	//+--------------
	CriaHeader()
	
	//+--------------
	//| Monta o aCols2 com os dados referentes as ITENS DA VENDA
	//+--------------
	nCols  := 0
	nUsado := Len(aHeader2)
	If !Inclui
		dbSelectArea(cAlias2)
		dbSetOrder(1)
		dbSeek(cFilSZ7+SZ6->Z6_NUM,.T.)
		While !Eof() .And. cFilSZ7+SZ6->Z6_NUM == Z7_FILIAL+Z7_NUM
			
			aAdd(aCols2,Array(nUsado+1))
			nCols ++
			
			For nX := 1 To nUsado
				If ( aHeader2[nX][10] != "V")
					aCols2[nCols][nX] := FieldGet(FieldPos(aHeader2[nX][2]))
				Else
					aCols2[nCols][nX] := CriaVar(aHeader2[nX][2],.T.)
				Endif
			Next nX
			aCols2[nCols][nUsado+1] := .F.
			
			AAdd( aAltera2 , Recno() )
			
			dbSkip()
		Enddo
	Endif
	
	If Empty(aCols2)  // Caso nao tenha funcionarios agregados
		//+--------------
		//| Monta o aCols2 com uma linha em branco
		//+--------------
		aColsBlank(@aCols2,aHeader2)
	Endif
	
	//+--------------
	//| Monta o aCols3 com os dados referentes as ADMINISTRADORAS FINANCEIRAS
	//+--------------
	nCols  := 0
	nUsado := Len(aHeader3)
	If !Inclui
		dbSelectArea(cAlias3)
		dbSetOrder(1)
		dbSeek(cFilSZ8+SZ6->Z6_NUM,.T.)
		While !Eof() .And. cFilSZ8+SZ6->Z6_NUM == Z8_FILIAL+Z8_NUM
			
			aAdd(aCols3,Array(nUsado+1))
			nCols ++
			
			For nX := 1 To nUsado
				If ( aHeader3[nX][10] != "V")
					aCols3[nCols][nX] := FieldGet(FieldPos(aHeader3[nX][2]))
				Else
					aCols3[nCols][nX] := CriaVar(aHeader3[nX][2],.T.)
				Endif
			Next nX
			aCols3[nCols][nUsado+1] := .F.
			
			AAdd( aAltera3 , Recno() )
			
			dbSkip()
		Enddo
	Endif
	
	If Empty(aCols3)  // Caso nao tenha Posicoes cadastradas
		//+--------------
		//| Monta o aCols3 com uma linha em branco
		//+--------------
		aColsBlank(@aCols3,aHeader3)
	Endif
	
Return .T.

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ aColsBlank ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 06/03/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria array de itens em branco                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function aColsBlank(aArray,aHeader)
	Local nX
	Local nUsado := Len(aHeader)
	Local nTam   := Len(aArray ) + 1
	
	aAdd(aArray,Array(nUsado+1))
	
	For nX:=1 To nUsado
		aArray[nTam][nX] := CriaVar(aHeader[nX,2],.T.)
	Next
	
	aArray[nTam][nUsado+1] := .F.
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FAT01Refres¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 06/03/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Atualiza a tela dos Gets                                      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function FAT01Refresh(aGet)
	Local x
	Local aSavHead := aClone(aHeader)
	Local aSavCols := aClone(aCols)
	
	For x:=1 To Len(aGet)
		aHeader := aClone( &("aHeader"+Str(x+1,1)) )
		aCols   := aClone( &("aCols"  +Str(x+1,1)) )
		
		aGet[x]:oBrowse:lDisablePaint := .F.
		aGet[x]:oBrowse:Refresh(.T.)
		
	Next
	aHeader := aClone(aSavHead)
	aCols   := aClone(aSavCols)
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FAT01Folder¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 06/03/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Salva e Restaura o MsGetDados dos Folders                     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function FAT01Folder(nFldDst,nFldAtu,aGetDados)
	Local lRet := .F.
	
	If !(Inclui .Or. Altera) .Or. u_FAT01TudOk(nFldAtu)
		lRet := .T.
		aGetDados[nFldAtu]:oBrowse:lDisablePaint := .T.
		Do Case
			Case nFldAtu == 1
				aCols2   := aClone(aCols)
				aHeader2 := aClone(aHeader)
			Case nFldAtu == 2
				aCols3   := aClone(aCols)
				aHeader3 := aClone(aHeader)
		EndCase
		N := Max(aGetDados[nFldDst]:oBrowse:nAt,1)
		Do Case
			Case nFldDst == 1
				aCols   := aClone(aCols2)
				aHeader := aClone(aHeader2)
			Case nFldDst == 2
				aCols   := aClone(aCols3)
				aHeader := aClone(aHeader3)
		EndCase
		aGetDados[nFldDst]:oBrowse:lDisablePaint := .F.
		aGetDados[nFldDst]:oBrowse:Refresh(.T.)
	Endif
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦FAT01Proces ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 12/03/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Edição das Vendas Pendentes                                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FAT01Proces(cAlias, nRecNo, nOpc )
	Local aLinha, cTpoCli, cEstCli, cInsCli, aDadosCfo, nI
	Local aArea   := (cAlias1)->(GetArea())
	Local cPerg   := "MGFATA01"
	Local cDocIni := (cAlias1)->Z6_NUM
	Local cDocFim := (cAlias1)->Z6_NUM
	Local lOk     := .T.
	Local lLote   := (nOpc == 7)
	Local aItens  := {}
	Local aBase   := {}
	
	Private aHeader := u_MGCriaHeader("SC6")
	Private aCols   := Nil
	
	For nI:=1 To Len(aHeader)
		AAdd( aBase , If( aHeader[nI,8] == "M", "", CriaVar(aHeader[nI,2],.T.) ))
	Next
	AAdd( aBase , .F. )
	
	If !lLote   // Processamento único
		If (cAlias1)->Z6_STATUS == "3"    // Processado
			FWAlertError("Essa venda já foi processada !")
		Else
			lOk := FWAlertYesNo("Confirma o processamento dessa venda ?")
		Endif
	Else
		ValidPerg(cPerg)
		If lOk := Pergunte(cPerg,.T.)
			cDocIni := mv_par01
			cDocFim := mv_par02
		Endif
	Endif
	
	If lOk
		(cAlias1)->(dbSetOrder(1))
		(cAlias1)->(dbSeek(XFILIAL(cAlias1)+cDocIni,.T.))
		While !(cAlias1)->(Eof()) .And. (cAlias1)->Z6_FILIAL == XFILIAL(cAlias1) .And. (cAlias1)->Z6_NUM <= cDocFim
			
			If (cAlias1)->Z6_STATUS == "3"    // Processado
				(cAlias1)->(dbSkip())
				Loop
			Endif
			
			// Posiciona nos itens da venda
			(cAlias2)->(dbSetOrder(1))
			(cAlias2)->(dbSeek((cAlias1)->Z6_FILIAL+(cAlias1)->Z6_NUM,.T.))
			
			// Posiciona no Cadastro da Operação por CFOP
			SZ5->(dbSetOrder(1))
			If Empty((cAlias2)->Z7_CFORI) .Or. !SZ5->(dbSeek(XFILIAL("SZ5")+(cAlias2)->Z7_CFORI))
				If !lLote
					FWAlertError("CFOP "+AllTrim((cAlias2)->Z7_CFORI)+" não cadastrado na integração")
				Endif
				(cAlias1)->(dbSkip())
				Loop
			ElseIf SZ5->Z5_TPNOTA $ "DB" .And. SZ5->Z5_ROTINA == "1"
				If !lLote
					FWAlertError("Regra de CFOP "+AllTrim((cAlias2)->Z7_CFORI)+" não importar devolução/beneficiamento pelo Loja")
				Endif
				(cAlias1)->(dbSkip())
				Loop
			Endif
			
			lOk := .T.
			
			If SZ5->Z5_TPNOTA $ "DB"    // Caso seja notas de devolução ou beneficiamento
				// Posiciona no Fornecedor da venda
				SA2->(dbSetOrder(1))
				SA2->(dbSeek(XFILIAL("SA2")+(cAlias1)->Z6_CLIENTE+(cAlias1)->Z6_LOJA))
				
				cTpoCli := "F"
				cEstCli := SA2->A2_EST
				cInsCli := SA2->A2_INSCR
			Else
				// Posiciona no Cliente da venda
				SA1->(dbSetOrder(1))
				SA1->(dbSeek(XFILIAL("SA1")+(cAlias1)->Z6_CLIENTE+(cAlias1)->Z6_LOJA))
				
				cTpoCli := SA1->A1_TIPO
				cEstCli := SA1->A1_EST
				cInsCli := SA1->A1_INSCR
			Endif
			
			aDadosCfo := {}
			AAdd( aDadosCfo , { "OPERNF"  , "S"     })
			AAdd( aDadosCfo , { "TPCLIFOR", cTpoCli })
			AAdd( aDadosCfo , { "UFDEST"  , cEstCli })
			AAdd( aDadosCfo , { "INSCR"   , cInsCli })
			
			aCols := {}
			
			While !(cAlias2)->(Eof()) .And. (cAlias2)->Z7_FILIAL+(cAlias2)->Z7_NUM == (cAlias1)->Z6_FILIAL+(cAlias1)->Z6_NUM
				
				CalcTES(aBase,aDadosCfo) // Tenta novamente gravar o TES ao reprocessar
				
				If lOk := !(Empty((cAlias2)->Z7_TES) .Or. Empty((cAlias2)->Z7_CF))
					If lOk := (Trim((cAlias2)->Z7_CF) == Trim((cAlias2)->Z7_CFORI))
						aLinha := {}
						If (cAlias1)->Z6_TIPO == "1"
							AAdd( aLinha , { "LR_ITEM", (cAlias2)->Z7_ITEM, Nil})
							AAdd( aLinha , { "LR_TES" , (cAlias2)->Z7_TES , Nil})
							AAdd( aLinha , { "LR_CF"  , (cAlias2)->Z7_CF  , Nil})
						Else
							AAdd( aLinha , { "C6_ITEM", (cAlias2)->Z7_ITEM, Nil})
							AAdd( aLinha , { "C6_TES" , (cAlias2)->Z7_TES , Nil})
							AAdd( aLinha , { "C6_CF"  , (cAlias2)->Z7_CF  , Nil})
							If !Empty((cAlias2)->Z7_NFORIG)
								AAdd( aLinha , { "C6_NFORI"  , (cAlias2)->Z7_NFORIG , Nil})
								AAdd( aLinha , { "C6_SERIORI", (cAlias2)->Z7_SERIORI, Nil})
								AAdd( aLinha , { "C6_ITEMORI", (cAlias2)->Z7_ITEMORI, Nil})
							Endif
						Endif
						AAdd( aItens , AClone(aLinha) )
					Else
						FWAlertError("Existem itens onde o CFOP informado é diferente do CFOP da venda: " + (cAlias1)->Z6_DOC + " / " + (cAlias1)->Z6_SERIE)
						Exit
					Endif
				Else
					FWAlertError("Existem itens sem TES ou CFOP informados para essa venda: " + (cAlias1)->Z6_DOC + " / " + (cAlias1)->Z6_SERIE)
					Exit
				Endif
				
				(cAlias2)->(dbSkip())
			Enddo
			
			lOk := lOk .And. ProcVenda(Trim((cAlias1)->Z6_REST),aItens,lLote)
			
			If !lOk .And. (!lLote .Or. !FWAlertYesNo("Processa as demais integrações ?"))
				Exit
			Endif
			
			(cAlias1)->(dbSkip())
		Enddo
		(cAlias1)->(RestArea(aArea))
	Endif

Return

Static Function ProcVenda(cJSon,aItens,lLote)
	Local aArea  := GetArea()
	Local aSZ6   := (cAlias1)->(GetArea())
	Local bError := ErrorBlock({ |oError| cError := oError:Description })
	Local cError := ""
	Local lOk    := .T.
	
	Begin Sequence
		FWMsgRun(Nil, {|oSay| lOk := u_MGVendaUnica(cJSon,aItens,@cError,(cAlias1)->Z6_NUM) }, "Integração com o CONTROL", "Processando a geração da venda...")
	End Sequence
	
	(cAlias1)->(RestArea(aSZ6))
	
	//Restaurando bloco de erro do sistema
	ErrorBlock(bError)
	
	RecLock(cAlias1,.F.)
	(cAlias1)->Z6_STATUS := If( lOk , "3", "2")
	(cAlias1)->Z6_LOG    := cError
	MsUnLock()
	
	If !Empty(cError)
		lOk := .F.
		FWAlertError("Houve um erro na gravação: " + CRLF + CRLF + cError, "Integração com CONTROL")
	EndIf
	
	RestArea(aArea)

Return lOk

Static Function CalcTES(aBase,aDadosCfo)
	Local cTES, cCFOP, nI, nPos
	Local aLinha := {}
	
	If Empty((cAlias2)->Z7_TES)
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(XFILIAL("SB1")+(cAlias2)->Z7_PRODUTO))
		
		// Monta estrutura para cálculo do TES Inteligente
		AAdd( aCols , aClone(aBase) )
		n := Len(aCols)
		
		aLinha := {}
		AAdd( aLinha , { "C6_ITEM"    , (cAlias2)->Z7_ITEM    , Nil} )
		AAdd( aLinha , { "C6_PRODUTO" , (cAlias2)->Z7_PRODUTO , Nil} )
		AAdd( aLinha , { "C6_DESCRI"  , (cAlias2)->Z7_DESCRI  , Nil} )
		AAdd( aLinha , { "C6_QTDVEN"  , (cAlias2)->Z7_QUANT   , Nil} )
		AAdd( aLinha , { "C6_PRCTAB"  , (cAlias2)->Z7_PRECO   , Nil} )
		AAdd( aLinha , { "C6_PRCVEN"  , (cAlias2)->Z7_PRECO   , Nil} )
		AAdd( aLinha , { "C6_VALOR"   , (cAlias2)->Z7_TOTAL   , Nil} )
		AAdd( aLinha , { "C6_ENTREG"  , (cAlias2)->Z7_ENTREGA , Nil} )
		AAdd( aLinha , { "C6_UM"      , (cAlias2)->Z7_UM      , Nil} )
		
		If !Empty(SB1->B1_SEGUM)
			AAdd( aLinha , { "C6_SEGUM"   , SB1->B1_SEGUM   , Nil} )
		Endif
		
		AAdd( aLinha , { "C6_QTDLIB"  , (cAlias2)->Z7_QUANT   , Nil} )
		AAdd( aLinha , { "C6_LOCAL"   , (cAlias2)->Z7_LOCAL   , Nil} )
		AAdd( aLinha , { "C6_CLI"     , (cAlias1)->Z6_CLIENTE , Nil} )
		AAdd( aLinha , { "C6_LOJA"    , (cAlias1)->Z6_LOJA    , Nil} )
		AAdd( aLinha , { "C6_OPER"    , SZ5->Z5_OPER          , Nil} )
		
		If !Empty((cAlias2)->Z7_NFORIG)
			AAdd( aLinha , { "C6_NFORI"   , (cAlias2)->Z7_NFORIG  , Nil} )
			AAdd( aLinha , { "C6_SERIORI" , (cAlias2)->Z7_SERIORI , Nil} )
			AAdd( aLinha , { "C6_ITEMORI" , (cAlias2)->Z7_ITEMORI , Nil} )
		Endif
		
		For nI:=1 To Len(aLinha)
			If (nPos := AScan( aHeader , {|x| Trim(x[2]) == aLinha[nI,1] })) > 0
				aCols[n,nPos] := aLinha[nI,2]
			Endif
		Next
		cTES := MaTesInt(2,SZ5->Z5_OPER,(cAlias1)->Z6_CLIENTE,(cAlias1)->Z6_LOJA,If(SZ5->Z5_TPNOTA$"DB","F","C"),SB1->B1_COD,"LR_TES")
		
		If !Empty(cTES)    // Caso tenha um TES válido
			SF4->(dbSetOrder(1))
			SF4->(MsSeek(xFilial("SF4")+cTES))
			
			If !Empty(cCFOP := MaFisCfo(,SF4->F4_CF,aDadosCfo))    // Caso tenha um CFOP válido
				RecLock(cAlias2,.F.)
				(cAlias2)->Z7_TES := cTES
				(cAlias2)->Z7_CF  := cCFOP
				MsUnLock()
			Endif
		Endif
	Endif

Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PosObjetos ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 06/03/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Inicializa as dimensões da tela para posicionar os objetos    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PosObjetos(aSize,aPosObj,aPosGet)
	Local aInfo1, aInfo2
	Local aObjects := {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	
	// Divide a tela para os objetos ENCHOICE e FOLDER
	AAdd( aObjects, { 100, 050, .t., .t. } )  // ENCHOICE
	AAdd( aObjects, { 100, 100, .t., .f. } )  // FOLDER
	
	// Calcula as coordenadas no MSDIALOG para os objetos (ENCHOICE e FOLDER)
	aInfo1  := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo1, aObjects )
	
	// Calcula as coordenadas no (sub) FOLDER(1) para o objeto MSGETDADOS
	aInfo2  := { 0, aPosObj[2,2], aPosObj[2,4]-aPosObj[2,2]-aInfo1[1], aPosObj[2,3]-aPosObj[2,1]-aInfo1[2], 3, 3 }
	aPosGet := MsObjSize( aInfo2, {{ 100, 100, .t., .t. }}, .T. )
	
Return

Static Function ValidPerg(cPerg)
	u_MGPutSX1(cPerg,"01",PADR("Do ID   ",29)+"?","","","mv_ch1","C",TamSX3("Z7_NUM")[1],0,0,"G","","   ","   ","","mv_par01")
	u_MGPutSX1(cPerg,"02",PADR("Ate o ID",29)+"?","","","mv_ch2","C",TamSX3("Z7_NUM")[1],0,0,"G","","   ","   ","","mv_par02")
Return
