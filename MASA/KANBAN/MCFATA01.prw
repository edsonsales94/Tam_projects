#INCLUDE "Protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MCFATA01   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 31/10/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cadastro de Kanban                                            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
User Function MCFATA01()
	Local aCores      := {	{"Z1_QTDENT == 0","ENABLE" },;    // LISTA ABERTA
									{"Z1_QTDENT > 0 .And. Z1_QTDENT < Z1_QUANT","BR_AMARELO"},; // LISTA VIGENTE
									{"Z1_QTDENT >= Z1_QUANT","DISABLE"}}     // LISTA EXPIRADA
	
	Private cCadastro := "Cadastro de Kanban"
	Private cAlias1   := "SZ1"
	Private aRotina   := {	{"Pesquisar"   ,"AxPesqui"       ,0,1} ,;
									{"Visualizar"  ,"AxVisual"       ,0,2} ,;
									{"Importar"    ,"u_MCFATP01(.F.)",0,3} ,;
									{"Faturar"     ,"u_FATFaturar"   ,0,4} ,;
									{"Excluir"     ,"u_FATExcluir"   ,0,5} ,;
									{"Elim.Resid." ,"u_FATElimResi"  ,0,6} ,;
									{"Legenda"     ,"u_FATLegenda"   ,0,7} }
	
	
	dbSelectArea(cAlias1)
	dbSetOrder(1)
	
	mBrowse( 6,1,22,75,cAlias1,,,,,,aCores)
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATFaturar ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 31/10/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Gera pedido de venda para o kanban                            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FATFaturar(cAlias, nRecNo, nOpc )
	Local nX, aSize, aPosObj, aPosFol, /*oDlg,*/ oFolder, bLine
	Local aFolder   := { "Kanban", "Pedido"}
	Local aCabec    := {}
	Local aSizes    := Nil
	Local cLine     := ""
	Local nOpcA     := 0
	Local oFontOb := TFont():New("Arial",,016,,.T.,,,,,.F.,.F.)
	
	Private oCli, cCliLoja, oLbx, oDlg
	Private aTela   := {}
	Private aGets   := {}
	Private aAcho   := { "Z1_CLIENTE", "Z1_LOJA",  "NOUSER" }//{ "Z1_CLIENTE", "Z1_LOJA", "Z1_DATENT", "NOUSER" }
	Private dData 	:= Criavar('Z1_DATENT',.F.)
	Private oDatEnt,ogDatEnt,lDatEnt
	
	Private aHeader := {}
	Private aCols   := {}
	Private aCampos := { "Z1_PRODUTO", "Z1_QTDENT", "B1_DESC"}
	
	Private aHeaKan := {}
	Private aPedido := { "Z1_PRODUTO", "Z1_DATENT", "Z1_HORENT", "Z1_PEDCLI", "Z1_SETENT", "Z1_KANBAN", "Z1_QUANT", "C6_QTDLIB"}
	Private aMark   := {{}}
	Private nPD     := 1
	
	SX3->(dbSetOrder(2))
	
	For nX:= 1 To Len(aAcho)-1
		If SX3->(dbSeek(aAcho[nX]))
			If nOpc == 4
				M->&( aAcho[nX] ) := CriaVar(aAcho[nX],.F.)
			Else
				M->&( aAcho[nX] ) := (cAlias)->&( If( SX3->X3_CONTEXT <> "V" , aAcho[nX], Trim(SX3->X3_RELACAO) ) )
			Endif
		Endif
	Next nX
	
	//+--------------
	//| Monta o aHeader
	//+--------------
	CriaHeader()
	
	//+----------------
	//| Monta os aCols
	//+----------------
	aColsBlank(@aCols)
	
	
	// Preenche o cabeçalho
	For nX:=1 To Len(aHeaKan)
		AAdd( aCabec   , Trim(aHeaKan[nX,1]) )
		AAdd( aMark[1] , CriaVar(aHeaKan[nX,2]) )
		
		cLine += If( nX > 1 , ", ", "") + "aMark[oLbx:nAt,"+LTrim(Str(nX))+"]"
	Next
	
	cLine := "{|| {"+cLine+"}}"
	bLine := &(cLine)
	
	//+----------------------------------
	//| Inicia as posições dos objetos
	//+----------------------------------
	PosObjetos(@aSize,@aPosObj,@aPosFol)
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL
	
	EnChoice(cAlias, nRecNo, 3,,,,aAcho,aPosObj[1],, 3,,,,oDlg)
	
	@ 035, 260 SAY   oDatEnt PROMPT "Data Entrega:" SIZE 062, 014 OF oDlg FONT oFontOb COLORS 0, 16777215 PIXEL
	@ 043, 260 MSGET ogDatEnt VAR dData     Valid( vDatEnt() ) SIZE 038, 012 OF oDlg COLORS 0, 16777215 FONT oFontOb PIXEL
	 
	oFolder := TFolder():New(aPosObj[2,1],aPosObj[2,2],aFolder,,oDlg,,,,.T.,,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1],)

	oGet := MSGetDados():New(aPosFol[1,1],aPosFol[1,2],aPosFol[1,3]-20,aPosFol[1,4],3,/*"LinOk"*/,,/*"+Z1_ITEM"*/,.T.,/*aAlter*/,,,1000,,,,"u_FATADelIt()",oFolder:aDialogs[1])
	
	oGet:oBrowse:bChange := {|| FAT01CpoAlt(oGet:oBrowse) }
	oGet:oBrowse:bSetGet := {|| FAT01CpoAlt(oGet:oBrowse) }
	
	FAT01CpoAlt(oGet:oBrowse)
	
	oLbx := TWBrowse():New(aPosFol[1,1],aPosFol[1,2],aPosFol[1,4]-aPosFol[1,2],aPosFol[1,3]-aPosFol[1,1]-20,/*Flds*/,aCabec,aSizes /*aColsSizes*/,oFolder:aDialogs[2],,,,/*Change*/,/*DblClick*/,,,,,,,,,.T.,,,,,)
	
	oLbx:SetArray( aMark )
	oLbx:bLine := bLine
	
	//@ aPosObj[3,1],aPosObj[3,2] SAY oCli VAR cCliLoja SIZE 300,10 PIXEL OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| If( FATATudOk() , (nOpcA:=1, oDlg:End()),) }, {||nOpcA:=0,oDlg:End()},, )
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ Gravacao   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 01/11/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Processa a geração do pedido de venda - Cadastro Kanban       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Gravacao()
	Local nX, nPreco, nValor, cNumPed, nSaveSX8, aItem, x
	Local cEnder    := GetMv("MV_XENDKAN",.F.,"FATURAR")
  	Local cLocExp   := Alltrim(GetMV("MV_XLOCEXP"))
	Local cItem     := StrZero(0,Len(SC6->C6_ITEM))
	Local aArrSC5   := {}
	Local aArrSC6   := {}
	Local aPvlNfs   := {}
	Local aBloqueio := {}

	Local vItens    := {}
	Local vAcumu    := {}
	Local vAux      := {}
	Local cTES      := GetMV("MV_XTSBEN")   // TES de Saída de Devolução
	Local cCond     := ""
	Local cSC5Naturez:=""

	lMsErroAuto := .F.
	
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(XFILIAL("SA1")+M->Z1_CLIENTE+M->Z1_LOJA))
	
	DBSelectArea('SZX')
	SZX->(dbSetOrder(1))
	
	BeginTran()
	
	For nX:=1 To Len(aMark)
		
		// Posiciona no Cadastro de Produtos
		SZ1->(dbSetOrder(1))    // Z1_FILIAL+Z1_CLIENTE+Z1_LOJA+Z1_PRODUTO+DTOS(Z1_DATENT)+Z1_HORENT+Z1_SETENT+Z1_KANBAN
		SZ1->(dbSeek(XFILIAL("SZ1")+M->Z1_CLIENTE+M->Z1_LOJA+aMark[nX,1]+DtoS(aMark[nX,2])+aMark[nX,3]+aMark[nX,5]+aMark[nX,6]))
		
		// Posiciona no Cadastro de Produtos
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(XFILIAL("SB1")+SZ1->Z1_PRODUTO))
		
		// Posiciona no Cadastro de Clientes x Produtos
		SA7->(dbSetOrder(1))
		SA7->(dbSeek(XFILIAL("SA7")+SA1->A1_COD+SA1->A1_LOJA+SB1->B1_COD))
		
		nPreco := u_fPrecoTab(SB1->B1_COD,SA1->A1_COD+SA1->A1_LOJA)
		cItem  := Soma1(cItem)
		nValor := a410Arred( aMark[nX,8] * nPreco , "C6_VALOR" , NIL )
		
		// tratativa preco unitario = 0, na gravar pedido.
		if nPreco == 0
			FWAlertError('Não é possivel gravar pedido sem o preco unitario, verifique a tabela de preco do produto '+SB1->B1_COD, 'Error: Prc.Unit')
			Return
		endif

		// grava quantidade entregue
		RecLock("SZ1",.F.)
		SZ1->Z1_QTDENT += aMark[nX,8]
		MsUnLock()
		
		/*gravar quantidade entregue na carteira
		  Edson Sales - 2026
		  edson.pedro@totvs.com.br
		  ZX_FILIAL+ZX_CLIENTE+ZX_LOJA+ZX_PERIODO+ZX_CODMASA+ZX_DATA 
		*/
		IF SZX->(dbSeek(XFILIAL("SZX")+M->Z1_CLIENTE+M->Z1_LOJA+left(DtoS(aMark[nX,2]),6)+aMark[nX,1]+DtoS(aMark[nX,2])))
			RecLock("SZX",.F.)
			SZX->ZX_QTDENT += aMark[nX,8]
			SZX->ZX_SALDO  := Max(0, SZX->ZX_SALDO - SC6->C6_QTDVEN)
			MsUnLock()
		EndIf
		
		aItem  := {}
		aAdd( aItem , { "C6_FILIAL"  , xFilial("SC6") , Nil} )
		aAdd( aItem , { "C6_ITEM"    , cItem          , Nil} )
		aAdd( aItem , { "C6_PRODUTO" , SB1->B1_COD    , Nil} )
		aAdd( aItem , { "C6_DESCRI"  , SB1->B1_DESC   , Nil} )
		aAdd( aItem , { "C6_LOCAL"   , cLocExp        , Nil} )
		aAdd( aItem , { "C6_LOCALIZ" , cEnder         , Nil} )
		aAdd( aItem , { "C6_QTDVEN"  , aMark[nX,8]    , Nil} )
		aAdd( aItem , { "C6_ENTREG"  , SZ1->Z1_DATENT , Nil} )
		aAdd( aItem , { "C6_UM"      , SB1->B1_UM     , Nil} )
		aAdd( aItem , { "C6_OPER"    , mv_par02       , Nil} )
		aAdd( aItem , { "C6_QTDLIB"  , aMark[nX,8]    , Nil} )
		aAdd( aItem , { "C6_CLI"     , SA1->A1_COD    , Nil} )
		aAdd( aItem , { "C6_LOJA"    , SA1->A1_LOJA   , Nil} )
		aAdd( aItem , { "C6_PRCVEN"  , nPreco         , Nil} )
		aAdd( aItem , { "C6_VALOR"   , nValor         , Nil} )
		aAdd( aItem , { "C6_PRUNIT"  , nPreco         , Nil} )
		aAdd( aItem , { "C6_XTIPPED" , SZ1->Z1_TIPPED , Nil} )
		aAdd( aItem , { "C6_XCODITE" , SA7->A7_CODCLI , Nil} )
		aAdd( aItem , { "C6_PEDCLI"  , SZ1->Z1_PEDCLI , Nil} )
		aAdd( aItem , { "C6_XSETENT" , SZ1->Z1_SETENT , Nil} )
		aAdd( aItem , { "C6_XHORENT" , SZ1->Z1_HORENT , Nil} )
		aAdd( aItem , { "C6_XPED"    , SZ1->Z1_XPED   , Nil} )
		aAdd( aItem , { "C6_XLINPED" , SZ1->Z1_LINPED , Nil} )
		aAdd( aItem , { "C6_XKANBAN" , SZ1->Z1_KANBAN , Nil} )
		aAdd( aItem , { "C6_XPSV"    , SZ1->Z1_ITEMPSV, Nil} )
		
		// Dados Adicionais do Kanban Honda
		AAdd( aItem , { "C6_XDATPRD" , DtoS(SZ1->Z1_DATPRD) , Nil} )
		AAdd( aItem , { "C6_XHORPRD" , SZ1->Z1_HORPRD , Nil} )
		AAdd( aItem , { "C6_XMODELO" , SZ1->Z1_MODELO , Nil} )
		AAdd( aItem , { "C6_XPESOBR" , SZ1->Z1_PESOBR , Nil} )
		AAdd( aItem , { "C6_XEMBALA" , SZ1->Z1_EMBALA , Nil} )
		AAdd( aItem , { "C6_XPOSTOS" , SZ1->Z1_POSTOS , Nil} )
		AAdd( aItem , { "C6_XCLASSI" , SZ1->Z1_CLASSI , Nil} )
		AAdd( aItem , { "C6_XTIPENT" , SZ1->Z1_TIPENT , Nil} )
		AAdd( aItem , { "C6_XLOCENT" , SZ1->Z1_LOCENT , Nil} )
		AAdd( aItem , { "C6_XEMPDES" , SZ1->Z1_EMPDES , Nil} )
		
		aAdd( aArrSC6, aClone(aItem) )
		
		//Adicionar itens no vetor para acumulados e retorno de beneficiamento
		AAdd( vItens , { SB1->B1_COD, aMark[nX,8]})
	Next


	cNumPed := GetSXENum("SC5","C5_NUM")   // Pega o próximo pedido de venda
	RollBAckSx8()
	// DE LUCCA 16/05/23 - PARA ATENDER ICMS	
	//	If MV_PAR02 == "X1" .And. SA1->A1_XTIPRET == "1" //Se for industrialização e retornar itens de beneficiamento automaticamente
	If  SA1->A1_XTIPRET == "1" .And. (MV_PAR02 == "X1" .Or. MV_PAR02 == "X6" .Or. MV_PAR02 == "X7" ) //Se for industrialização e retornar itens de beneficiamento automaticamente)
		vAux := MONTAPED(SA1->A1_COD,SA1->A1_LOJA,vItens,@vAcumu,.T.)
			If  !Empty(vAux)  // Se encontrou itens
				For x:=1 To Len(vAux)
					// Posiciona no Cadastro de Produtos
					SB1->(dbSetOrder(1))
					SB1->(dbSeek(XFILIAL("SB1")+vAux[x,1]))
			
					// Posiciona no Item da N.F. de Entrada
					SD1->(dbSetOrder(4))
					SD1->(dbSeek(XFILIAL("SD1")+vAux[x,2]))
				
					// Posiciona no TES de  Retorno
					SF4->(dbSetOrder(1))
					SF4->(dbSeek(XFILIAL("SF4")+cTes))
						
					cItem  := Soma1(cItem)
				
					nValor := a410Arred( vAux[x,3] * vAux[x,4] , "C6_VALOR" , NIL )

					aAdd(aArrSC6, {{ "C6_FILIAL"  , xFilial("SC6") , Nil},;
								{ "C6_NUM"     , cNumPed             , Nil},;
								{ "C6_ITEM"    , cItem               , Nil},;
								{ "C6_PRODUTO" , SB1->B1_COD         , Nil},;
								{ "C6_DESCRI"  , SB1->B1_DESC        , Nil},;
								{ "C6_QTDVEN"  , vAux[x,3]   , Nil},;
								{ "C6_ENTREG"  , dDataBase           , Nil},;
								{ "C6_UM"      , SB1->B1_UM          , Nil},;
								{ "C6_TES"     , cTes       , Nil},;
								{ "C6_CF"      , SF4->F4_CF          , Nil},;
								{ "C6_QTDLIB"  , vAux[x,3]  , Nil},;
								{ "C6_LOCAL"   , SB1->B1_LOCPAD      , Nil},;
								{ "C6_CLI"     , SA1->A1_COD        , Nil},;
								{ "C6_LOJA"    , SA1->A1_LOJA        , Nil},;
								{ "C6_OP"      , "02"                , Nil},;
								{ "C6_TPOP"    , "F"                 , Nil},;
								{ "C6_PRUNIT"  , vAux[x,4]  , Nil},;
								{ "C6_PRCVEN"  , vAux[x,4]   , Nil},;
								{ "C6_VALOR"   , nValor              , Nil},;
								{ "C6_NFORI"   , SD1->D1_DOC         , Nil},;
								{ "C6_SERIORI" , SD1->D1_SERIE       , Nil},;
								{ "C6_ITEMORI" , SD1->D1_ITEM        , Nil},;
								{ "C6_PEDCLI"  , SD1->D1_XPEDCLI        , Nil},;
								{ "C6_IDENTB6" , vAux[x,2]   , Nil}})
				Next
			Endif
	EndIf



	// Variavel que controla numeracao
	nSaveSX8 := GetSx8Len()

   cCond := SA1->A1_COND

   If SA1->A1_COD == "L00634"// Se Cliente Samsung 
   		cCond := U_MCFATE07(dDatabase)
   Endif
	cSC5Naturez:= MV_PAR01
	aArrSC5 := {{ "C5_FILIAL"  , xFilial("SC5")     , Nil}, ;
					{ "C5_NUM"     , cNumPed         	, Nil}, ;
					{ "C5_TIPO"    , "N"             	, Nil}, ;
					{ "C5_CLIENTE" , SA1->A1_COD        , Nil}, ;
					{ "C5_LOJACLI" , SA1->A1_LOJA       , Nil}, ;
					{ "C5_CLIENT"  , SA1->A1_COD     	, Nil}, ;
					{ "C5_LOJAENT" , SA1->A1_LOJA    	, Nil}, ;
					{ "C5_EMISSAO" , dDataBase       	, Nil}, ;
					{ "C5_CONDPAG" , cCond          	, Nil}, ;
					{ "C5_MOEDA"   , 1                  , Nil}, ;
					{ "C5_NATUREZ" , mv_par01           , Nil}, ;
					{ "C5_TIPOCLI" , SA1->A1_TIPO    	, Nil} }
	
	MSExecAuto({|x,y,Z| Mata410(x,y,Z)}, aArrSC5, aArrSC6, 3)
	
	If !lMsErroAuto
		// Liberacao de pedido
		Ma410LbNfs(2,@aPvlNfs,@aBloqueio)
		// Checa itens liberados
		Ma410LbNfs(1,@aPvlNfs,@aBloqueio)
		
		// Caso tenha itens liberados manda faturar
		If Empty(aBloqueio) .And. !Empty(aPvlNfs)
			If (__lSX8)
				// Confirma SX8
				While ( GetSx8Len() > nSaveSX8 )
					ConfirmSX8()
				Enddo
			EndIf
			
			EndTran()
			
			MsgInfo("<strong><font color=BLACK>Pedido de venda <font color=RED>"+cNumPed+"</font> gravado com sucesso !</font></strong>","Pedido Kanban")
		Else
			lMsErroAuto := .T.
		Endif
   	Else
		MostraErro()
	Endif
	
	If lMsErroAuto
		If (__lSX8)
			While ( GetSx8Len() > nSaveSX8 )
				RollBackSx8()
			Enddo
		EndIf
		
		If !Empty(aBloqueio)
			Aviso( "INVÁLIDO", "Ocorreram problemas quanto a liberação de crédito / estoque para o pedido de venda !", {"Ok"} )
			ExibeBloqueio(aPvlNfs,aBloqueio)
		Endif
		RollBackSx8()
		DisarmTransaction()
	Endif
 
Return !lMsErroAuto

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATAValid  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 31/10/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de validação e filtro dos dados                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FATAValid()
	Local nPDes, nPPrd, nPQtd, nQuant
	Local cVar := ReadVar()
	Local lRet := .T.
	
	If cVar $ "M->Z1_CLIENTE,M->Z1_LOJA"
		If lRet := ExistCpo("SA1",M->Z1_CLIENTE+If(Empty(M->Z1_LOJA),"",M->Z1_LOJA))
			cCliLoja := Posicione("SA1",1,XFILIAL("SA1")+M->Z1_CLIENTE+If(Empty(M->Z1_LOJA),"",M->Z1_LOJA),"A1_NOME")
			//oCli:Refresh()
		Endif
	ElseIf cVar == "M->Z1_PRODUTO"
		If lRet := ExistCpo("SB1",M->Z1_PRODUTO) .And. !JaExiste(M->Z1_PRODUTO,aCols)
			nPDes := ASCan( aHeader , {|x| Trim(x[2]) == "B1_DESC" } )
			aCols[n,nPDes] := Posicione("SB1",1,XFILIAL("SB1")+M->Z1_PRODUTO,"B1_DESC")
		Endif
	ElseIf cVar == "M->Z1_QTDENT"
		nPPrd := ASCan( aHeader , {|x| Trim(x[2]) == "Z1_PRODUTO" } )
		nPQtd := ASCan( aHeader , {|x| Trim(x[2]) == "Z1_QTDENT"  } )
		
		If lRet := !Empty(aCols[n,nPPrd])
			If lRet := NaoVazio() .And. Positivo()
				//MsgRun("  Filtrando Kanban   ","Aguarde...",{|| nQuant := FiltraKanban(M->Z1_CLIENTE,M->Z1_LOJA,aCols[n,nPPrd],M->Z1_DATENT,M->Z1_QTDENT) })
				MsgRun("  Filtrando Kanban   ","Aguarde...",{|| nQuant := FiltraKanban(M->Z1_CLIENTE,M->Z1_LOJA,aCols[n,nPPrd],dData,M->Z1_QTDENT) })
				
				If lRet := (nQuant > 0)
					aCols[n,nPQtd] := nQuant
				Endif
			Endif
		Else
			Aviso( "INVÁLIDO", "É necessário informar um produto antes de informar a quantidade !", {"Ok"} )
		Endif
	Endif
	
Return lRet

Static Function FiltraKanban(cCliente,cLoja,cProduto,dDataEnt,nQtdDig)
	Local cQry, nX, nPos, cArq
	Local aArea    := GetArea()
	Local cMarca   := GetMark()
	Local aHeadCpo := {}
	Local aSelect  := { "Z1_DATENT", "Z1_HORENT", "Z1_PEDCLI", "Z1_SETENT", "Z1_KANBAN", "Z1_QUANT", "Z1_QTDENT", "C6_QTDLIB", "B2_QATU"}
	Local cPicture := Trim(Posicione("SX3",2,"Z1_QUANT","X3_PICTURE"))
	Local aStruct  := {}
	
	Private nTotal := 0
	
	// Adiciona o campo de marcação
	AAdd( aHeadCpo , { "Z1_OK",, "", "@!"} )
	AAdd( aStruct ,  { "Z1_OK", "C", 2, 0} )
	
	SX3->(dbSetOrder(2))
	
	For nX:=1 To Len(aSelect)
		If SX3->(dbSeek(aSelect[nX]))
			AAdd( aHeadCpo , { Trim(SX3->X3_CAMPO),, Trim(X3Titulo()), If( SX3->X3_TIPO == "N" , cPicture, Trim(SX3->X3_PICTURE))} )
			AAdd( aStruct  , { Trim(SX3->X3_CAMPO), SX3->X3_TIPO, SX3->X3_TAMANHO, If( SX3->X3_TIPO == "N" , 2, 0)} )
		Endif
	Next
	
	// Cria tabela temporária para marcação dos itens
	cArq := Criatrab(aStruct,.T.)
	Use &(cArq) Alias TMP New Exclusive
	
	cQry := "SELECT SZ1.R_E_C_N_O_ AS Z1_RECNO"
	cQry += " FROM " + RetSQLName("SZ1") + " SZ1"
	cQry += " WHERE SZ1.D_E_L_E_T_ = ' '"
	cQry += " AND SZ1.Z1_FILIAL = '"+SZ1->(XFILIAL("SZ1"))+"'"
	cQry += " AND SZ1.Z1_QTDENT < SZ1.Z1_QUANT"
	cQry += " AND SZ1.Z1_CLIENTE = '"+cCliente+"'"
	cQry += " AND SZ1.Z1_LOJA = '"+cLoja+"'"
	
	If cProduto <> Nil .And. !Empty(cProduto)
		cQry += " AND SZ1.Z1_PRODUTO = '"+cProduto+"'"
	Endif
	If dDataEnt <> Nil .And. !Empty(dDataEnt) // Anizio Cunha 09/01/2025
		cQry += " AND SZ1.Z1_DATENT = '"+DtoS(dDataEnt)+"'"
	Endif
	
	cQry += " ORDER BY " + SZ1->(SQLOrder(IndexKey(1)))
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
	
	TCSetField("TRB","Z1_DATENT","D",8,0)
	
	dbGoTop()
	While !Eof()
		
		SZ1->(dbGoTo(TRB->Z1_RECNO))
		
		RecLock("TMP",.T.)
		For nX:=1 To TMP->(FCount())
			If (nPos := SZ1->(FieldPos( TMP->(FieldName(nX)) ))) > 0
				FieldPut( nX , SZ1->(FieldGet( nPos )) )
			Endif
		Next
		
		nTam := PesqRegistro(cProduto+DtoS(TMP->Z1_DATENT)+TMP->Z1_HORENT+TMP->Z1_SETENT+TMP->Z1_KANBAN)
		
		If nTam > 0
			TMP->Z1_OK     := cMarca
			TMP->C6_QTDLIB := aMark[nTam,8]
			
			nTotal += TMP->C6_QTDLIB
		Endif
		
		TMP->B2_QATU := TMP->Z1_QUANT - TMP->Z1_QTDENT - TMP->C6_QTDLIB
		
		MsUnLock()
		
		dbSelectArea("TRB")
		dbSkip()
	Enddo
	dbCloseArea()
	RestArea(aArea)
	
	TMP->(dbGoTop())
	
	If !( TMP->(Bof()) .And. TMP->(Eof()) )
		Seleciona(aHeadCpo,cMarca,cProduto,nQtdDig)
	Else
		MsgAlert("Não existem registros para faturamento !")
	Endif
	
	TMP->(dbCloseArea())
	FErase(cArq+GetDBExtension())
	
Return nTotal

Static Function Seleciona(aHeadCpo,cMarca,cProduto,nQtdDig)
	Local oDlg, oPanelT, oFonte, oBold
	Local lMarcado := (nTotal > 0)
	Local aCores   := {	{"(TMP->Z1_QTDENT+TMP->C6_QTDLIB) == 0","ENABLE"},;
								{"(TMP->Z1_QTDENT+TMP->C6_QTDLIB) > 0 .AND. (TMP->Z1_QTDENT+TMP->C6_QTDLIB) < TMP->Z1_QUANT","BR_AMARELO"},;
								{"(TMP->Z1_QTDENT+TMP->C6_QTDLIB) >= TMP->Z1_QUANT","DISABLE"}}
	Local nOpcA    := 0
	Local aBackup  := aClone(aMark)
	Local nLin     := 5
	
	Private oMark, oTot
	Private nSaldo := nQtdDig - nTotal
	
	oFonte := TFont():New("Arial",10,18,.T.,.F.)
	DEFINE FONT oBold   NAME "Arial" SIZE 0, -13 BOLD
	
	DEFINE MSDIALOG oDlg TITLE "Seleciona Kanban" From 0,0 TO 35,134 OF oMainWnd
	
	@ 0,0 MSPANEL oPanelT PROMPT "" SIZE 10,234 OF oDlg CENTERED LOWERED //"Botoes"
	oPanelT:Align := CONTROL_ALIGN_BOTTOM

	@ nLin,05 SAY Trim(cProduto) + " - " + Posicione("SB1",1,XFILIAL("SB1")+cProduto,"B1_DESC") SIZE 400,10 COLOR CLR_HRED FONT oFonte PIXEL OF oPanelT
	nLin += 15
	
	oMark := MsSelect():New( "TMP", "Z1_OK","",aHeadCpo,, @cMarca, { nLin, 05, 215, 525 } ,,, oPanelT,,aCores)
	
	oMark:oBrowse:Refresh()
	oMark:bAval               := {|| Marcar(cMarca,cProduto), oMark:oBrowse:Refresh(), lMarcado := (nTotal > 0), oTot:Refresh() }
	
	oMark:oBrowse:lHasMark    := .T.
	oMark:oBrowse:lCanAllMark := .F.
	oMark:oBrowse:bAllMark    := {|| lMarcado:=!lMarcado,;
												nRecno:=TMP->(Recno()),;
												TMP->(dbGoTop()),;
												dbEval({|| Marcar(cMarca,cProduto,lMarcado) },,{|| (!lMarcado .Or. nSaldo > 0) .And. !TMP->(Eof()) }),;
												TMP->(dbGoTo(nRecno)),;
												oTot:Refresh(),;
												oMark:oBrowse:Refresh() }
	
	oMark:oBrowse:SetFocus()
	
	@ 220,05 SAY "Quantidade selecionada" COLOR CLR_HRED FONT oBold PIXEL OF oPanelT
	@ 220,95 SAY oTot VAR nTotal Picture "@E 999,999,999.99" COLOR CLR_HRED FONT oBold PIXEL OF oPanelT
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,;
														{||If( nSaldo < 0 , Aviso( "INVÁLIDO", "Quantidade selecionada não pode ser maior que a quantidade informada !", {"Ok"} ),;
															If( nTotal < nQtdDig , Aviso( "INVÁLIDO", "Favor selecionar toda a quantidade informada !", {"Ok"} ), (nOpcA:=1, oDlg:End()))) },;
														{||nOpcA:=0,oDlg:End()},, )
	
	// Caso tenha cancelado a tela
	If nOpcA <> 1
		nTotal := 0
		
		// Volta as marcações anteriores
		aSize(aMark,0)
		aEval( aBackup , {|x| AAdd(aMark,aClone(x)) } )
		
		oLbx:Refresh()
	Endif
	
Return

Static Function Marcar(cMarca,cProduto,lMarcado)
	Local nTam, nX
	
	If lMarcado <> Nil
		// Não processa registros com status igual a marcação
		If (lMarcado .And. TMP->Z1_OK == cMarca) .Or. (!lMarcado .And. TMP->Z1_OK <> cMarca)
			Return
		Endif
	Endif
	
	If TMP->Z1_OK <> cMarca .And. nSaldo == 0
		Aviso( "INVÁLIDO", "Quantidade ultrapassa o total informado no Kanban !", {"Ok"} )
		Return
	Endif
	
	nTotal -= TMP->C6_QTDLIB
	nSaldo += TMP->C6_QTDLIB
	
	RecLock("TMP",.F.)
	TMP->Z1_OK     := If( lMarcado == Nil , If( TMP->Z1_OK <> cMarca , cMarca, Space(Len(TMP->Z1_OK))), If( lMarcado , cMarca, Space(Len(TMP->Z1_OK))))
	TMP->C6_QTDLIB := If( TMP->Z1_OK == cMarca , Min(nSaldo,TMP->Z1_QUANT - TMP->Z1_QTDENT), 0)
	TMP->B2_QATU   := TMP->Z1_QUANT - TMP->Z1_QTDENT - TMP->C6_QTDLIB
	MsUnLock()
	
	nTam := PesqRegistro(cProduto+DtoS(TMP->Z1_DATENT)+TMP->Z1_HORENT+TMP->Z1_SETENT+TMP->Z1_KANBAN)
	
	If TMP->C6_QTDLIB == 0   // Se desmarcou o item então apaga do array de itens marcados
		If nTam > 0
			aDel(aMark,nTam)
			aSize(aMark,Len(aMark)-1)
			
			CriaaMark()   // Caso o vetor esteja vazio, adiciona uma linha pelo menos
		Endif
	Else
		If nTam == 0
			// Caso tenha mais de um item ou já exista um item preenchido, então adiciona uma linha.
			// Caso contrário aproveita a linha existente
			If Len(aMark) > 1 .Or. !Empty(aMark[1,1])
				AAdd( aMark , )
			Endif
			nTam := Len(aMark)
		Endif
		
		aMark[nTam] := {}
		AAdd( aMark[nTam] , cProduto )
		
		For nX:=2 To Len(aHeaKan)
			AAdd( aMark[nTam] , TMP->&( aHeaKan[nX,2] ) )
		Next
	Endif
	
	oLbx:Refresh()
	
	nTotal += TMP->C6_QTDLIB
	nSaldo -= TMP->C6_QTDLIB
	
Return

Static Function PesqRegistro(cSeek)
Return ASCan( aMark , {|x| x[1]+DtoS(x[2])+x[3]+x[5]+x[6] == cSeek } )

Static Function CriaaMark()
	// Caso o vetor esteja vazio, adiciona uma linha pelo menos
	If Empty(aMark)
		AAdd( aMark , {} )
		aEval( aHeaKan , {|x| AAdd( aMark[1] , CriaVar(x[2]) ) } )
	Endif
Return

Static Function ExibeBloqueio(aPvlNfs,aBloqueio)
	Local oDlg, oBlq, oPanelT
	Local oOk    := LoadBitmap( GetResources(), "BR_VERDE" )
	Local oEst   := LoadBitmap( GetResources(), "BR_PRETO" )
	Local oCrd   := LoadBitmap( GetResources(), "BR_AZUL"  )
	Local oOut   := LoadBitmap( GetResources(), "BR_VERMELHO"  )
	Local aItens := {}
	Local nOpcA  := 0
	
	aEval( aPvlNfs   , {|x| AAdd( aItens , { "  ", x[2], x[6], Posicione("SB1",1,XFILIAL("SB1")+x[6],"B1_DESC"), x[15], TransForm(x[4],X3Picture("C9_QTDLIB"))} ) } )
	aEval( aBloqueio , {|x| AAdd( aItens , { If(!Empty(x[6]) , x[6], If(!Empty(x[7]) , x[7], x[8])),;
															x[2], x[4], Posicione("SB1",1,XFILIAL("SB1")+x[4],"B1_DESC"),;
															Posicione("SC9",1,XFILIAL("SC9")+x[1]+x[2],"C9_LOCAL"), x[5]} ) } )
	
	ASort( aItens ,,, {|x,y| x[2] < y[2] } )
	
	DEFINE MSDIALOG oDlg TITLE "Status de Liberações" From 0,0 TO 30,84 OF oMainWnd
	
	@ 0,0 MSPANEL oPanelT PROMPT "" SIZE 10,198 OF oDlg CENTERED LOWERED //"Botoes"
	oPanelT:Align := CONTROL_ALIGN_BOTTOM

	oBlq := TWBrowse():New(05,05,320,185,/*Flds*/,{"","Item","Produto","Descrição","Almoxarifado","Quantidade"}, /*aColsSizes*/,oPanelT,,,,/*Change*/,/*DblClick*/,,,,,,,,,.T.,,,,,)
	
	oBlq:SetArray( aItens )
	oBlq:bLine := {|| {If( aItens[oBlq:nAt,1]=="  ",oOk,If( aItens[oBlq:nAt,1]=="02",oEst,If( aItens[oBlq:nAt,1]=="05",oCrd,oOut))),;
							aItens[oBlq:nAt,2],;
							aItens[oBlq:nAt,3],;
							aItens[oBlq:nAt,4],;
							aItens[oBlq:nAt,5],;
							aItens[oBlq:nAt,6]} }
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| nOpcA:=1, oDlg:End() }, {|| oDlg:End() } )
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATALinOk  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 01/11/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar a linha do item                                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function FATALinOk(nPos)
	Local nX
	
	nPos := If( nPos == Nil , n, nPos)
	
	If !aCols[nPos,Len(aCols[nPos])]
		For nX:=1 To Len(aCols[nPos])-1
			If X3Obrigat( AllTrim(aHeader[nX,2]) ) .And. Empty(aCols[nPos,nX])
				Help(1," ","OBRIGAT")
				Return .F.
			Endif
		Next
	Endif
	
Return .T.

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATATudOk  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 01/11/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar todas as linhas dos itens                             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function FATATudOk()
	Local nX
	Local cPerg := PADR("MCFATA01",Len(SX1->X1_GRUPO))
	Local nDel  := Len(aCols[1])
	Local nCnt  := 0
	Local lRet  := .T.
	
	For nX:=1 To Len(aCols)
		If !(lRet := FATALinOk(nX))
			Exit
		Endif
	Next
	
	If lRet
		// Conta o número de itens deletados
		aEval( aCols , {|x| nCnt += If( x[nDel] , 1, 0) } )
		
		If lRet := (nCnt <> Len(aCols))
			ValidPerg(cPerg)
			If lRet := Pergunte(cPerg,.T.)
				MsgRun("  Gerando pedido de venda   ","Aguarde...",{|| lRet := Gravacao() })
			Endif
		Else
			Aviso( "INVÁLIDO", "Favor adicionar pelo menos um item válido ao faturar !", {"Ok"} )
		Endif
	Endif
	
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATADelIt  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 31/10/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar delecao dos itens                                     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FATADelIt()
	Local nPQtd
	Local nDel := Len(aCols[1])
	Local lRet := .T.
	
	If lRet .And. nPD == 1
		If aCols[n,nDel] // Na recuperacao da linha - 1a. passagem
			lRet := !JaExiste(aCols[n,1],aCols)
		Else
			nPQtd := AScan( aHeader , {|x| Trim(x[2]) == "Z1_QTDENT" } )
			If aCols[n,nPQtd] > 0
				If lRet := MsgYesNo("Todos os itens selecionados serão excluídos, confirma exclusão do item ?","EXCLUSÃO")
					ApagaTudo()
					aCols[n,nPQtd] := 0
					oLbx:Refresh()
				Endif
			Endif
		Endif
	Endif
	
	nPD := If( nPD > 1 , 1, 2)
	
Return lRet

Static Function ApagaTudo()
	Local nPos
	Local nPPrd := AScan( aHeader , {|x| Trim(x[2]) == "Z1_PRODUTO" } )
	
	While (nPos := ASCan( aMark , {|x| x[1]+DtoS(x[2]) == aCols[n,nPPrd]+DtoS(M->Z1_DATENT) } )) > 0
		aDel(aMark,nPos)
		aSize(aMark,Len(aMark)-1)
	Enddo
	
	CriaaMark()
	
Return 
	
Return

Static Function JaExiste(cBusca,aCols)
	Local nX
	Local nDel := Len(aCols[1])
	Local lRet := .F.
	
	For nX:=1 To Len(aCols)
		If nX <> n .And. cBusca == aCols[nX,1] .And. !aCols[nX,nDel]
			lRet := !ExistChav("SX5","01")
			Exit
		Endif
	Next
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CriaHeader ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 17/12/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria a variavel vetor aHeader                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CriaHeader()
	Local nX
	
	SX3->(dbSetOrder(2))
	
	For nX:=1 To Len(aCampos)
		If SX3->(dbSeek(aCampos[nX]))
			aAdd(aHeader,{ Trim(X3Titulo()), ;
								SX3->X3_CAMPO   , ;
								SX3->X3_PICTURE , ;
								SX3->X3_TAMANHO , ;
								SX3->X3_DECIMAL , ;
								"u_FATAValid()" , ;
								SX3->X3_USADO   , ;
								SX3->X3_TIPO    , ;
								SX3->X3_F3      , ;
								SX3->X3_CONTEXT , ;
								SX3->X3_CBOX    , ;
								SX3->X3_RELACAO } )
		Endif
	Next
	
	For nX:=1 To Len(aPedido)
		If SX3->(dbSeek(aPedido[nX]))
			aAdd(aHeaKan,{ Trim(X3Titulo()), ;
								SX3->X3_CAMPO   , ;
								SX3->X3_PICTURE , ;
								SX3->X3_TAMANHO , ;
								SX3->X3_DECIMAL , ;
								SX3->X3_VALID   , ;
								SX3->X3_USADO   , ;
								SX3->X3_TIPO    , ;
								SX3->X3_F3      , ;
								SX3->X3_CONTEXT , ;
								SX3->X3_CBOX    , ;
								SX3->X3_RELACAO } )
		Endif
	Next
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ aColsBlank ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 31/10/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria array de itens em branco                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function aColsBlank(aArray)
	Local nX
	Local nTam   := Len(aArray ) + 1
	Local nUsado := Len(aHeader)
	
	aAdd(aArray,Array(nUsado+1))
	aArray[nTam][nUsado+1] := .F.
	
	SX3->(dbSetOrder(2))
	
	For nX:=1 To Len(aCampos)
		If SX3->(dbSeek(aCampos[nX]))
			aArray[nTam][nX] := CriaVar(SX3->X3_CAMPO,.T.)
		Endif
	Next
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FAT01CpoAlt¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 01/11/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Habilita a leitura dos campos conforme condição               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function FAT01CpoAlt(oGet)
	Local nPQtd := AScan( aHeader , {|x| Trim(x[2]) == "Z1_QTDENT" } )
	Local aVar  := {}

	oGet:aAlter := {}
	oGet:oMother:aAlter := {}
	
	If aCols[oGet:nAt,nPQtd] > 0    // Se já foi informada a quantidade, não permite alterar o produto
		aVar := { "Z1_QTDENT" }
	Else
		aVar := { "Z1_PRODUTO", "Z1_QTDENT"}
	Endif
	
	oGet:aAlter := aVar
	oGet:oMother:aAlter := aVar
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATLegenda ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 31/10/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Legenda do Kanban                                             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FATLegenda( cAlias, nRecNo, nOpc )
	BRWLEGENDA(cCadastro,"Legenda - Cadastro de Kanban",;
								{	{"ENABLE"    ,"Aberta"  },;
									{"BR_AMARELO","Parcial" },;
									{"DISABLE"   ,"Fechada"}})
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PosObjetos ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 31/10/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Inicializa as dimensões da tela para posicionar os objetos    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PosObjetos(aSize,aPosObj,aPosFol)
	Local aInfo1, aInfo2
	Local aObjects := {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	
	// Divide a tela para os objetos ENCHOICE e FOLDER
	AAdd( aObjects, { 100, 060, .t., .f. } )    // ENCHOICE
	AAdd( aObjects, { 100, 100, .t., .t. } )    // FOLDER
	AAdd( aObjects, { 100, 010, .t., .f. } )    // RODAPÉ
	
	// Calcula as coordenadas no MSDIALOG para os objetos (ENCHOICE e FOLDER)
	aInfo1  := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo1, aObjects )
	
	// Calcula as coordenadas para o objeto FOLDER
	aInfo2 := { 0, aPosObj[2,2], aPosObj[2,4]-aPosObj[2,2]-aInfo1[1], aPosObj[2,3]-aPosObj[2,1], 3, 3 }
	
	aObjects := {}
	AAdd( aObjects , { 100, 100, .t., .t.} )
	
	aPosFol := MsObjSize( aInfo2, aObjects, .T. )
	
Return

Static Function ValidPerg(cPerg)
	u_MCPutSX1(cPerg,"01",PADR("Natureza     ",29)+"?","","","mv_ch1","C",10,0,0,"G","","SED","","","mv_par01")
	u_MCPutSX1(cPerg,"02",PADR("Tipo Operacao",29)+"?","","","mv_ch2","C", 2,0,0,"G","","DJ ","","","mv_par02")
Return

/*Static Function LeCoord()
	Local nHdl, nX
	Local cFile := "D:\TOTVS\COORD.TXT"
	Local aRet  := {}
	
	If File(cFile)
		nHdl := FT_FUSE(cFile)
		FT_FGOTOP()
		aRet := Separa(AllTrim(FT_FREADLN()),",",.F.)
		For nX:=1 To Len(aRet)
			aRet[nX] := Val(aRet[nX])
		Next
		FT_FUSE()
	Endif
	
Return aRet*/


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MONTAPED   ¦ Autor ¦    ¦ Data ¦  ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de montagem do pedido de venda de beneficiamento       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

Static Function MONTAPED(cCodCli,cLjCli,vItensPA,vAll,lJunta)
	Local x, y, cQry, nQtdAtu, nQtdAcu, cAlias
	Local vPA  := {}
	Local vBN  := {}
	Local vRet := {}
	Local nDec := TamSX3("C6_VALOR")[2]
	Local cCodLjCli:="L4523001"  //ANIZIO CUNHA 17/11/25
	Local lMONDIAL:= GetMv("TFTMONDIAL")
	
	Private cFilSB1 := SB1->(XFILIAL("SB1"))
	Private cFilSG1 := SG1->(XFILIAL("SG1"))
	
	If ValType(vAll) <> "A"
		vAll := {}
	Endif
	
	// Acumula por Codigo de Produto, caso ainda não tenha sido feito
	If lJunta == Nil .Or. lJunta
		Acumula(vItensPA,@vPA)
	Endif
	
	// Busca os produtos Beneficiamento usados em cada PA
	aEval( vPA , {|x| GetBN(x[1],x[2],@vBN) } )
	
	ASort( vBN ,,, {|x,y| x[1] < y[1] })  // Ordena o vetor por Produto
	
	cAlias := Alias()
	For x:=1 To Len(vBN)
		// Pesquisa o produto no vetor de acumulados para buscar a quantidade acumulada
		If (nPos := AScan( vAll , {|y| y[1] == vBN[x,1] } )) > 0
			nQtdAcu := vAll[nPos,2]
		Else
			nQtdAcu := 0
		Endif
		
		nQtdAtu := vBN[x,2]   // Quantidade do BN no Pedido
		
		If lMONDIAL .And. cCodLjCli == cCodCli+cLjCli
			cQry := "SELECT TOP 1 B6_IDENT, "
		Else 
			cQry := "SELECT B6_IDENT, "
		EndIf 
		cQry += " B6_SALDO - ISNULL((SELECT SUM(C6_QTDVEN) FROM "+RetSQLName("SC6")+"" 
		cQry += " WHERE D_E_L_E_T_ = '' AND C6_PRODUTO = B6_PRODUTO AND C6_IDENTB6 = B6_IDENT AND C6_NOTA = ''),0) AS B6_SALDO, B6_PRUNIT "
		cQry += " FROM "+RetSQLName("SB6")+" SB6"
		cQry += " WHERE SB6.D_E_L_E_T_ = ' ' AND SB6.B6_PRODUTO = '"+vBN[x,1]+"'"
		cQry += " AND SB6.B6_CLIFOR = '"+cCodCli+"' AND SB6.B6_LOJA = '"+cLjCli+"'"
		cQry += " AND (SB6.B6_SALDO - ISNULL((SELECT SUM(C6_QTDVEN) FROM "+RetSQLName("SC6")+" "
		cQry += " WHERE D_E_L_E_T_ = '' AND C6_PRODUTO = B6_PRODUTO AND C6_IDENTB6 = B6_IDENT AND C6_NOTA = ''),0) ) > 0 "
		cQry += " AND SB6.B6_TES < '500'"  // Filtra os TES de entrada
		cQry += " AND SB6.B6_TIPO = 'D'"   // Filtra as notas de terceiros
		cQry += " AND SB6.B6_TPCF = 'C'"   // Filtra as notas do cliente
		cQry += " ORDER BY B6_IDENT"
		
		dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "QRY", .T., .F. )
		While !Eof() .And. nQtdAtu > 0
			// Identifica os itens já usados nos acumulados (anteriores)
			nQtdAcu := If( nQtdAcu > 0 , nQtdAcu - (B6_SALDO ), 0)
			
			// Após identificar todos os itens usados nos acumulados, a quantidade acumula fica zero
			If nQtdAcu <= 0
				// O saldo disponível é o restante do item ou o saldo total do próprio item
				nSalDis := If( nQtdAcu < 0 , Abs(nQtdAcu), (B6_SALDO ))
				
				// Se o saldo disponível é maior que a quantidade atual
				If nSalDis > nQtdAtu
					nSalDis := nQtdAtu   // Atribui a quantidade atual para os saldo disponíveis
				Endif
				
				// Guarda o item encontrado
				AAdd( vRet , { vBN[x,1], B6_IDENT, nSalDis, B6_PRUNIT, Round(nSalDis * B6_PRUNIT,nDec)})
				
				// Subtrai da quantidade atual o saldo disponível do item
				nQtdAtu -= nSalDis
			Endif
			
			dbSkip()
		Enddo
		dbCloseArea()
		
		// Se ainda tem saldo, então não existe saldo suficiente no SB6
		If nQtdAtu > 0 .And. cCodLjCli != cCodCli+cLjCli // VALIDACAO original: If nQtdAtu > 0. Atual PARA CLIENTE MONDIAL ANIZIO CUNHA 17/11/2025
			cTexto := "O produto "+rtrim(vBN[x,1])+" não será incluído no pedido por falta de saldo das notas de origem." +CRLF
			cTexto += "Saldo Devolução:"+cValtoCHar(vBN[x,2]) + CRLF
			cTexto += "Saldo Restante: "+cValtoChar(nQtdAtu)+". Verifique!" 
			Aviso( "Saldo de Terceiros", cTexto , {"Ok"}  ,, "Produto: " + vBN[x,1] )
			vRet := {}   // Limpa o vetor de saldos encontrados
			Exit
		Endif
	Next
	dbSelectArea(cAlias)
	
	// Se conseguiu encontrar saldo para os itens
	If !Empty(vRet)
		Acumula(vBN,@vAll)   // Acumula os itens solicitantes
	Endif
	
Return aClone(vRet)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ GetBN      ¦ Autor ¦    ¦ Data ¦  ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de busca dos itens de beneficiamento da estrutura      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Acumula(vVet1,vVet2)
	Local x, nPos
	
	If vVet2 <> Nil  // Caso o vetor já exista
		For x:=1 To Len(vVet1)
			nPos := AScan( vVet2 , {|y| y[1] == vVet1[x,1] })
			If nPos == 0
				AAdd( vVet2 , { vVet1[x,1], 0})
				nPos := Len(vVet2)
			Endif
			vVet2[nPos,2] += vVet1[x,2]
		Next
	Else
		vVet2 := aClone(vVet1)
	Endif
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ GetBN      ¦ Autor ¦    ¦ Data ¦ ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de busca dos itens de beneficiamento da estrutura      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function GetBN(cProduto,nQuant,vBN)
	Local nReg := SG1->(Recno())
	Local lRet := .F.
	
	If ValType(vBN) <> "A"
		vBN := {}
	Endif
	
	SG1->(dbSetOrder(1))
	If lRet := SG1->(dbSeek(cFilSG1+cProduto,.T.))
		While !SG1->(Eof()) .And. SG1->(G1_FILIAL+G1_COD) == cFilSG1+cProduto
			
			If dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM
				AddItemRet(SG1->G1_COMP,nQuant,@vBN)
				GetBN(SG1->G1_COMP,(SG1->G1_QUANT * nQuant) * ((100 + SG1->G1_PERDA) /100), @vBN)
			Endif
			
			SG1->(dbSkip())
		Enddo
	Endif
	SG1->(dbGoTo(nReg))
	
Return lRet

Static Function AddItemRet(cProduto,nQuant,vBN)
	Local nPos, lRet
	
	// Posiciona no produto
	SB1->(dbSetOrder(1))
	If lRet := SB1->(dbSeek(cFilSB1+cProduto))
		// Se for Material de Beneficiamento e não for FANTASMA
		If lRet := (SB1->B1_TIPO $ "BN" .And. SB1->B1_FANTASM <> "S")
			nPos := AScan( vBN , {|x| x[1] == cProduto })
			If nPos == 0
				AAdd( vBN , { cProduto, 0})
				nPos := Len(vBN)
			Endif
			vBN[nPos,2] += (SG1->G1_QUANT * nQuant) * ((100 + SG1->G1_PERDA) /100)
		EndIf
	Endif
	
Return lRet

/*
Autor: Anizio Cunha em 02/01/2025
Objetivo: Necessidade de informar a data de entrega.
*/
Static Function vDatEnt()
	Local aArea:= GetArea()

	If Empty(dData)
		MsgStop("Preencha a Data de Entrega!!!","DATAENT")
		ogDatEnt:SetFocus()
	EndIf 
RestArea(aArea)
Return 

 
