#INCLUDE "MATA310.ch"
#include "TBICONN.ch"
#include "Protheus.ch"
#include 'tbiconn.ch'
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ AAFATP01   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 17/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Transferência entre filiais                                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦+---------------------------------------------------------------------------+¦¦
¦¦¦                          ALTERAÇÕES NO PROGRAMA 			 		      ¦¦¦
¦¦+-----------+------------+-------+------------------------------------------+¦¦
¦¦¦ Usuário   ¦ Marcio     ¦ Autor ¦ DXRCOVRB             ¦ Data ¦ 30/03/2011 ¦¦¦
¦¦+-----------+------------+-------+------------------------------------------+¦¦
¦¦¦ Descriçäo ¦ Adicionar Filial de Origem e Destino nos Parametros e Colocar ¦¦¦
¦¦¦           ¦ As Colunas Filial Origem e Destino no aCols como Visualizar   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
-¦¦+-----------+------------+-------+------------------------------------------+¦¦
¦¦¦ Usuário   ¦ Marcio     ¦ Autor ¦ Wermeson             ¦ Data ¦ 31/03/2011 ¦¦¦
¦¦+-----------+------------+-------+------------------------------------------+¦¦
¦¦¦ Descriçäo ¦ Modificar a busca de clientes e fornecedores metros e Colocar ¦¦¦
¦¦¦           ¦ As Colunas Filial Origem e Destino no aCols como Visualizar   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static __aPedRes := {}

User Function _XDRTT()
	//Prepare Environment Empresa '01' Filial '01'
	Local adRet := {}
	Local nI := 0
	Local cSerie := "3  "
	Local cNotaFeita := "000204883"
	RpcSetEnv("01","01")
	//cRetorno := u_TransNfe("3  ","000204883")
	While Len(adRet) == 0 .And. nI <= 8/*Limite de 8 tentativas de consulta*/
	    adRet := u_getAuthNFE(cSerie,cNotaFeita)
        if Len(adRet)==0
           U_ZCONOUT('Nenhum retorno,Aguardando 1 Segundo antes de consultar de novo')
           Sleep(1000)
               //Aguarda 1Segundo antes de consultar de novo               
        EndIf
        nI++
    EndDo
	RpcClearEnv()
Return Nil

User Function TransNfe(cSer,cDoc)
	local cError := ""
	lUsaColab   := UsaColaboracao("1")	
	cIdEnt      := Iif (lUsaColab, "000000", getCfgEntidade() )
	cModelo     := "55"
	cAmbiente   := getCfgAmbiente(@cError, cIdEnt, cModelo)
	cModalidade := getCfgModalidade(@cError, cIdEnt, cModelo)
	cVersao	    := getCfgVersao(@cError, cIdEnt, cModelo)
	cUrl	    := Padr( GetNewPar("MV_SPEDURL",""), 250 )

	lEnd := .F.
	lCte := cModelo == "57"
	lAutomato := .F.

	cRetorno := SpedNFeTrf("SF2",cSer,cDoc,cDoc,cIdEnt,cAmbiente,cModalidade,cVersao,@lEnd,lCte,.T.,nil,nil,lAutomato)

Return cRetorno


User Function getANFS(aNFS)
	Local xParam := {}       
	Local nI
	Default aNFS := {}

	lUsaColab   := UsaColaboracao("1")	
	cIdEnt      := Iif (lUsaColab, "000000", getCfgEntidade() )
	cModelo     := "55"
	cUrl   := Padr( GetNewPar("MV_SPEDURL",""), 250 )
	lCte := cModelo == "57"

	//aAdd(xParam, aSer)
	U_ZCONOUT("[getANFS] - Montando xParam para : " + Alltrim(Str(Len(aNFS))) + " Notas  ")
	For nI := 01 to Len(aNFS)
	   aAdd(xParam, {aNFS[nI][01] + aNFS[nI][02]})
	Next
	U_ZCONOUT("[getANFS] - xParam Montado")
	nTpMonitor := 2
	cAviso  := ""
	U_ZCONOUT("[getANFS] - Chamando ProcMonitor")
	
	cLogText := VarInfo("",xParam,NIL,.F.,.F.)
    cLogText := Left(cLogText,Len(cLogText)-2)
    U_ZCONOUT("[getANFS] - " + cLogText)

	aRet := procMonitorDoc(cIdEnt, cUrl, xParam, nTpMonitor, cModelo, lCte, @cAviso ,lUsaColab)
	U_ZCONOUT("Aviso Retornado => " + cAviso)
	U_ZCONOUT("[getANFS] Aviso - " + cAviso)

Return aRet

User Function getAuthNFE(cSer,cDoc)
	Local xParam := {}       
	Local aSer := {cSer + cDoc}

	lUsaColab   := UsaColaboracao("1")	
	cIdEnt      := Iif (lUsaColab, "000000", getCfgEntidade() )
	cModelo     := "55"
	cUrl   := Padr( GetNewPar("MV_SPEDURL",""), 250 )
	lCte := cModelo == "57"

	aAdd(xParam, aSer)
	nTpMonitor := 2
	cAviso  := ""
	aRet := procMonitorDoc(cIdEnt, cUrl, xParam, nTpMonitor, cModelo, lCte, @cAviso ,lUsaColab)
	U_ZCONOUT("Aviso Retornado => " + cAviso)
Return aRet

User Function AAFATP01()

	//Local nX
	Local nOpcA     := 0
	Local oMainWnd  := Nil
	Local nOpc      := 3
	Local aEdit     := {}  // Vetor com os campos a serem editados
	Local cPerg     := ""//PADR("AAFATP01",10)
	Local aPar      := {}
	Local aParam310 := Array(30)
	Local aAreaSM0  := {}//SM0->(GetArea())
	Local aButtons  := {}
	Local lTelaPed  := .F.
	Local lR5       := GetRpoRelease("R5")   // Indica se o release e 11.5
	Local MOFILIAL  := ""

	Private _cdPed    := ""
	Private _adPed    := {}
	Private _ldInclui := .T.
	Private _ldChange := .T.
	Private cAlmCont  := GetMv("Mv_XALMCTR")
	Private cLogName  := "TRF-"+cUsername+"-"+StrTran(Time(),':','')

	Private _cdItem   := "" // Para Controlar qual Item do Novo Produto caso seja Adicionado um Novo Item

	lC_01 := .F.

	If Type("cAcesso") = "U"
		Prepare Environment Empresa "01" FILIAL "01" Tables "SA1,SZE" MODULO "FIS"
		lC_01 := .T.
	EndIf

	cPerg     := PADR("AAFATP01",10)
	aAreaSM0  := SM0->(GetArea())
	//u_AAFVNX01(cLogName,"Iniciando Transferência")
	//ValidPerg(cPerg)
	If Pergunte(cPerg,.T.)
		aPar := { mv_par01, mv_par02, mv_par03, mv_par04, mv_par05, mv_par06, mv_par07}
		If lC_01
			mv_par08 := '01'
			mv_par09 := '01'
		EndIf
		Private aFils   := {mv_par08,mv_par09} //Diego
	Else
		Return
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                                 ³

	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                               ³
	//³ mv_par01        // De  Produto                                     ³
	//³ mv_par02        // Ate Produto                                     ³
	//³ mv_par03        // De  filial                                      ³
	//³ mv_par04        // Ate filial                                      ³
	//³ mv_par05        // De  Armazem                                     ³
	//³ mv_par06        // Ate Armazem                                     ³
	//³ mv_par07        // De  Tipo                                        ³
	//³ mv_par08        // Ate Tipo                                        ³
	//³ mv_par09        // De  Grupo                                       ³
	//³ mv_par10        // Ate Grupo                                       ³
	//³ mv_par11        // Filtra Categorias  1 Sim  2 Nao                 ³
	//³ mv_par12        // Quebra informacoes 1 Por produto 2 Por Armazem  ³
	//³ mv_par13        // Codigo da TES utilizada nas NFs de saida        ³
	//³ mv_par14        // Indica como deve gerar o documento              ³
	//³ mv_par15        // Codigo da TES utilizada nas NFs de entrada      ³
	//³ mv_par16        // Codigo da condicao de pagamento                 ³
	//³ mv_par17        // Sugere preco 1 Tab 2 Custo STD 3 Ult Pr 4 CM    ³
	//³ mv_par18        // Dados origem - somente filial corrente / todas  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("MTA310",.F.)
	CarregaParam(@aParam310,aPar)

	// Valida se os TES são válidos para a transferência
	//u_AAFVNX01(cLogName,"Validando TES")
	If !FATP01VldTes(Nil,Nil,Empty(xFilial("SF4")),aParam310)
		Return
	Endif

	// Caso os destinos sejam 00 e 02 se trata de retorno de venda com reserva
	If lTelaPed := (aFils[2] $ "00,01,02") .and. !FWIsInCallStack("U_AAFATP12")
		lTelaPed := TelaPed()   // Exibe tela de seleção dos pedidos para preenchimento dos itens a transferir
	Endif

	Private cCadastro := "Transferência entre Filiais"
	Private aRotina   := { {"Pesquisar" ,"AxPesqui",0,1}, {"Alterar" ,"AxVisual",0,2}, {"Incluir" ,"AxInclui",0,3}}

	Private oDlg     := Nil
	Private oGet     := Nil
	Private aHeader  := {}
	Private aCols    := {}
	Private Inclui   := (nOpc == 3)
	Private Altera   := (nOpc == 4)
	Private nPD      := 1	
	Private vCampos  := { "C9_PRODUTO", "B1_ESPECIF", "LJ_RPCFIL", "C6_LOCAL", "LJ_RPCFIL", "C9_LOCAL", "D3_QUANT", "B2_QATU","C6_LOTECTL","B8_DTVALID","C6_LOCALIZ"} //, "Saldo"}
	Private vLegend  := { "Produto", "Descricao", "Filial Origem", "Arm. Origem", "Filial Dest.", "Arm. Dest.", "Qtde. Transf.", "Saldo Atual","Lote","Validade Lote","Endereco"} //, "Saldo"}
	Private aFiliais := {}

	// Inicializa todas colunas como fixas
	Private nPPrd    := 1
	Private nPDes    := 2
	Private nPFOri   := 3
	Private nPLOri   := 4
	Private nPFDes   := 5
	Private nPLDes   := 6
	Private nPQtd    := 7
	Private nPSdo    := 8
	Private nPosLote := 9
	Private nPosDtLo := 10
	Private nPosEnd  := 11
	Private nPDel    := 12
	Private aSize 	 := {}
	Private aPosObj  := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega filiais da empresa corrente                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SM0")
	dbSeek(cEmpAnt)
	While ! Eof() .And. SM0->M0_CODIGO == cEmpAnt
		// Adiciona filial
		MOFILIAL := Padr(SM0->M0_CODFIL,FWSizeFilial() )
		If MOFILIAL>= aParam310[03] .And. MOFILIAL <= aParam310[04]
			Aadd( aFiliais , {MOFILIAL , SM0->M0_CODIGO, SM0->M0_CGC, SM0->M0_INSC, SM0->M0_FILIAL})
		EndIf
		dbSkip()
	Enddo
	RestArea(aAreaSM0)

	//+----------------
	//| Monta os aCols
	//+----------------
	MontaaCols()

	If lTelaPed
		prenAcols()
	EndIf

	aAdd(aEdit,"C9_PRODUTO")
	aAdd(aEdit,"B1_ESPECIF")
	aAdd(aEdit,"C6_LOCAL")
	aAdd(aEdit,"C9_LOCAL")
	aAdd(aEdit,"D3_QUANT")
	aAdd(aEdit,"B2_QATU")

	// Adiciona botões auxiliares a tela
	AAdd( aButtons,{"HISTORIC" ,{|| Processa({|lEnd| FATP01Facil() },"Facilitador de Transferência","Buscando registros...",.F.) },"Facilitador"})
	//If !lTelaPed - Wermeson
		AAdd( aButtons,{"HISTORIC" ,{|| Processa({|lEnd| u_FATP10PED(@oGet) },"Importa Pedido","Buscando registros...",.F.) },"Pedido"})
	//EndIf
	// Habilita a tecla de consulta do estoque
	SetKey( VK_F7 , {|| u_FATP01Stok() })

	nLIni := If( lR5 , 5, 15)
	PosObjetos(@aSize,@aPosObj)

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	oPanelAll:= tPanel():New(aPosObj[1,1],aPosObj[1,2],"",oDlg,,,,,,aPosObj[1,3],aPosObj[1,4])
	oPanelAll:align:= CONTROL_ALIGN_ALLCLIENT

	oGet := MSGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3]-20,aPosObj[1,4],nOpc,"u_FATP01LinOk()",,,.T.,aEdit,,,999,,,,"u_FATP01DelIt()",oPanelAll)
	//MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_ASE01LinOk()","AlwaysTrue","+PA2_ITEM",.T.,,,,999,,,, "u_ASE01DelOk()",)
	oGet:oBrowse:bChange := {|| FATP01CpoAlt(oGet:oBrowse) }
	FATP01CpoAlt(oGet:oBrowse)

	//u_AAFVNX01(cLogName,"Abrindo Tela")
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| nOpcA := If( u_FATP01TudOk(),1,0),;
	iIf(nOpcA==1,oDlg:End(),) }, {||nOpcA:=0,oDlg:End()},, aButtons)

	// Desabilita a tecla de consulta do estoque
	SetKey( VK_F7 , {|| Nil })

	If nOpca == 1
		//Begin Transaction

		FATP01Grava(aParam310)

		//End Transaction
	Endif

Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATP01DelIt¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 17/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar delecao dos itens                                     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FATP01DelIt()
	Local x
	Local lRet := .T.

	If nPD == 2 .And. aCols[n,nPDel] // Na delecao da linha - 2a. passagem

		if n == Len(aCols)
			if n != 1
				aDel(aCols,n)
				_adPed := _delPed(n,_adPed)
				aSize(aCols,Len(aCols)-1)
				n := n - 1
			else
				LimpaCampos(1)
				aCols[n,nPDel] := .F.
				_adPed := {}
			EndIf
		Else
			aDel(aCols,n)
			_adPed := _delPed(n,_adPed)
			aSize(aCols,Len(aCols)-1)
		EndIf
		oGet:nMax := Len(aCols)
		oGet:Refresh()

	ElseIf nPD == 1
		If aCols[n,nPDel] // Na recuperacao da linha - 1a. passagem
			If lRet := (AScan( aCols , {|x| !x[nPDel] .And. x[nPPrd] == aCols[n,nPPrd] .And.;
			x[nPFori]+x[nPLOri]+x[nPFDes]+x[nPLDes] == aCols[n,nPFori]+aCols[n,nPLori]+aCols[n,nPFDes]+aCols[n,nPLDes] }) == 0)

				If (_nLin := GetFUndel(aCols) )> 0 //Proxima linha do primeiro registro deletado
					If lRet := (aCols[_nLin,nPLDes] = "13"  .And. ( aCols[n,nPFDes]!="01" .And. aCols[n,nPLDes] = "13") .Or. ( aCols[n,nPFOri]!="01" .And. aCols[n,nPLOri] = "13"))
						Alert("O Almoxarifado 13 Somente pode ser Adicionado como Filial 06300(01)")
						lRet := .F.
					Elseif lRet:= ( aCols[_nLin,nPLDes] = "13" .And. aCols[n,nPLDes] != '13' ) .Or. ( aCols[_nLin,nPLOri] != "13" .And. aCols[n,nPLOri] = '13' )
						Alert("Somente o Almoxarifado 13 Pode Ser Adicionado nesta Transferencia !!!")
						lRet := .F.
					Elseif lRet:= ( aCols[_nLin,nPLDes] != "13" .And. aCols[n,nPLDes] = '13' ) .Or. ( aCols[_nLin,nPLOri] != "13" .And. aCols[n,nPLOri] = '13' )
						Alert("O Almoxarifado 13 Nao Pode Ser Adicionado nesta Transferencia !!!")
						lRet := .F.
					ElseIf !(lRet := (aCols[n,nPQtd] <= SaldoProduto(aCols[n,nPFOri],aCols[n,nPPrd],aCols[n,nPLOri])))
						Alert("Quantidade é maior que o saldo disponível !")
					Endif

				EndIf
			Else
				Alert("Essa informação já foi digitada na transferência !")
			Endif
		Endif
	Endif
	nPD := If( nPD == 2 , 1, nPD + 1)

Return(lRet)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATP01Valid¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 17/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar os campos das transferências                          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FATP01Valid(nCol, _cVar )
	Local cVar := iIf(ValType(_cVar) == "U" , Upper(Trim(ReadVar())) ,_cVar)
	Local lRet := .T.
	Local xArmDest := GetMv("MV_XLOCRE",.F.,"75")

	//If nCol == 0
		nCol := oGet:obrowse:colpos
		
	//EndIf 

	If cVar == "M->LJ_RPCFIL" .And. ValType(_cVar) == "U" .And. (M->LJ_RPCFIL <> aFils[ iIF(nCol == nPFOri,1,2) ])
		Aviso('Atencao','Nao e Possivel Alterar a Filial',{'Ok'})
		Return .F.
	elseif cVar == "M->LJ_RPCFIL" .And. ValType(_cVar) == "U"
		Return .T.
	EndIF

	If cVar == "M->C9_PRODUTO"
		If lRet := ExistCpo("SB1")
			LimpaCampos(nCol+2)

			aCols[n,nPDes] := PADR(Posicione("SB1",1,XFILIAL("SB1")+M->C9_PRODUTO,"B1_ESPECIF"),TamSX3("B1_ESPECIF")[1])
			M->LJ_RPCFIL := aFils[01]
			lRet := u_FATP01Valid(nPFOri , "M->LJ_RPCFIL" )
			If lRet
				aCols[n,nPFOri]:= M->LJ_RPCFIL
				M->LJ_RPCFIL := aFils[02]
				lRet := u_FATP01Valid(nPFDes, "M->LJ_RPCFIL" )
				if lRet
					aCols[n,nPFDes]:= M->LJ_RPCFIL
				else
					M->LJ_RPCFIL := ""
				EndIf
			else
				M->LJ_RPCFIL := ""
			EndIf
		Endif
	ElseIf cVar == "M->LJ_RPCFIL"
		If lRet := ExistCpo("SLJ",SubStr(cNumEmp,1,2)+M->LJ_RPCFIL,3)
			SLJ->(dbSetOrder(3))
			SLJ->(dbSeek(XFILIAL("SLJ")+SubStr(cNumEmp,1,2)+M->LJ_RPCFIL))

			nPos := AScan( aFiliais , {|x| x[1] == M->LJ_RPCFIL } )

			If nCol == nPFOri  // Se estiver lendo a origem
				If lRet := u_AAVldCliFor("SA1",M->LJ_RPCFIL)
					LimpaCampos(nCol+1)
				Endif
			Else
				If lRet := u_AAVldCliFor("SA2",M->LJ_RPCFIL)
					// Verifica se as filiais são diferentes, se não for, só permite se for a filial 00 (depósito)
					If lRet := (M->LJ_RPCFIL <> aCols[n,nPFOri] .Or. M->LJ_RPCFIL == "01")
						//aCols[n,nPLOri] := "13"   // Almoxarifado padrão de transferência do depósito
						//aCols[n,nPLDes] := "13"   // Almoxarifado padrão de transferência do depósito
						LimpaCampos(nCol+1,.F.)
						LimpaCampos(nCol+2,.F.)
					Else
						Alert("Filiais origem e destino não podem ser iguais !")
					Endif
				Endif
			EndIf
		Endif
	ElseIf cVar == "M->C9_LOCAL" .or. cVar == "M->C6_LOCAL"
		If !aCols[n,nPDel]

			If lRet
				If nCol == nPLOri  .and.  cVar == "M->C6_LOCAL" // Se estiver lendo a origem
					SB2->(dbSetOrder(1))
					lRet := SB2->(dbSeek(aCols[n,nPFOri] + aCols[n,nPPrd]+M->C6_LOCAL ))
					if !lRet
						Aviso('ERRO','ARMAZEN NÃO ENCONTRADO',{'OK'})
					EndIf
					SB1->(dbGoTop())
					SB1->(dBSetORder(1))
					lRet := SB1->(dbSeek(xFilial("SB1") + aCols[n,nPPrd] ))
					if !lRet
						Aviso('ERRO','PRODUTO NÃO ENCONTRADO',{'OK'})
					EndIf

					If (_nLin := GetFUndel(aCols) ) > 0 .And. lRet
						If lRet := (aCols[_nLin,nPLOri] = "13" .And. M->C6_LOCAL != "13" .And. n != _nLin )
							Alert("Almoxarifado invalido, Somente Almoxarifado 13 Nesta Transferencia !!!")
							lRet := !lRet
						elseif lRet := ( aCols[_nLin,nPLOri] != "13" .And. M->C6_LOCAL = "13"  .And. n != _nLin )
							Alert("Almoxarifado invalido, O Almoxarifado 13 Nao Pode Ser Adicionado Nesta Transferencia !!!")
							lRet := !lRet
						elseif lRet := (( ( (aCols[n,nPLOri] = "13" .Or.M->C6_LOCAL = "13" ) .And. aCols[n,nPFOri] != "01") .Or. (aCols[n,nPLDes] = "13" .And. aCols[n,nPFDes] != "01")  ) )
							Alert("Almoxarifado invalido, O Almoxarifado 13 Somente Pode ser Adicionado como Filial 06300(01) !!!")
							lRet := !lRet
						elseif lRet := .T.
							LimpaCampos(nCol+2)
							aCols[n,nPSdo] := SaldoProduto(aCols[n,nPFOri],aCols[n,nPPrd],M->C6_LOCAL)
						EndIf

						// Checa se o endereço do Produto esta habilitado
						If lRet .And. nPosEnd > 0 .And. SB1->B1_LOCALIZ == "S" .And. GETMV("MV_LOCALIZ") == "S"
							iF SuperGetMv("MV_XLOCALI",.T.)
								If aCols[_nLin,nPLOri]==xArmDest .Or. M->C6_LOCAL==xArmDest
									aCols[n][nPosEnd] := PADR("SEPARA",TamSX3("BF_LOCALIZ")[1])
								Else
									aCols[n][nPosEnd] := Alltrim(GetMv("MV_XLOCALI"))//_xdGetLocaliz(aCols[n,nPFOri],aCols[n,nPPrd],M->C9_LOCAL,_xdLote[01])
								EndIf
							Else
								lRet := .F.
								Alert("Endereço Padrão não Informado no Parametro! MV_XLOCALI")
							EndIF
						EndIf

						If lRet .And. nPosLote > 0 .And. Rastro(aCols[n,nPPrd],"L")
							// Checa se Tem Endereço para Retornar o Saldo do Endereco, Ou não caso so Exista Lote 
							If SB1->B1_LOCALIZ == "S" .And. GETMV("MV_LOCALIZ") == "S"
								_xdLote := _xdGetLote(aCols[n,nPFOri],aCols[n,nPPrd],M->C6_LOCAL, aCols[n][nPosEnd] )
							Else
								_xdLote := _xdGetLote(aCols[n,nPFOri],aCols[n,nPPrd],M->C6_LOCAL, "" )
							EndIf

							If Len(_xdLote) > 0
								aCols[n][nPosLote] := _xdLote[01]
								aCols[n][nPosDtLo] := _xdLote[02]
								aCols[n][nPSdo]    := _xdLote[03]
							Else
								lRet := .F.
							EndIf 
						ElseIf nPosEnd > 0 .And. SB1->B1_LOCALIZ == "S" .And. GETMV("MV_LOCALIZ") == "S" // Não Tem Lote, Mas tem Endereco 
							aCols[n][nPSdo]  := _xdGetLocaliz(aCols[n,nPFOri],aCols[n,nPPrd],M->C6_LOCAL, aCols[n][nPosEnd] )
						EndIf
					EndIf
				Else
					If lRet := (AScan( aCols , {|x| !x[nPDel] .And. x[nPPrd] == aCols[n,nPPrd] .And.	x[nPFori]+x[nPLOri]+x[nPFDes]+x[nPLDes] == aCols[n,nPFori]+aCols[n,nPLori]+aCols[n,nPFDes]+M->C9_LOCAL }) == 0)
						SB2->(dbSetOrder(1))
						lRet := SB2->(dbSeek(aCols[n,nPFDes] + aCols[n,nPPrd]+M->C9_LOCAL ))
						if !lRet
							Aviso('ERRO','ARMAZEN NÃO ENCONTRADO',{'OK'})
						EndIf
						If (_nLin := GetFUndel(aCols) ) > 0 .And. lRet
							If lRet := (aCols[_nLin,nPLDes] = "13" .And. M->C9_LOCAL != "13" .And. n != _nLin )
								Alert("Almoxarifado invalido, Somente Almoxarifado 13 Nesta Transferencia !!!")
								lRet := !lRet
							elseif lRet := ( aCols[_nLin,nPLDes] != "13" .And. M->C9_LOCAL = "13"  .And. n != _nLin )
								Alert("Almoxarifado invalido, O Almoxarifado 13 Nao Pode Ser Adicionado Nesta Transferencia !!!")
								lRet := !lRet
							elseif lRet := ((  ( (aCols[n,nPLDes] = "13" .Or. M->C9_LOCAL = "13" ).And. aCols[n,nPFDes] != "01") .Or. ( (aCols[n,nPLOri] = "13" ) .And. aCols[n,nPFOri] != "01")  ) ) //.And. n != _nLin)
								Alert("Almoxarifado invalido, O Almoxarifado 13 Somente Pode ser Adicionado como Filial 06300(01) !!!")
								lRet := !lRet
							else
								If lRet :=( aCols[n,nPFOri] <> aCols[n,nPFDes] .Or. "13" $ aCols[n,nPLOri]+"%"+aCols[n,nPLDes] .Or. "13" $ aCols[n,nPLOri]+"%"+M->C9_LOCAL)
									// Diego
									If _ldInclui
										LimpaCampos(nCol+1,.F.)
									EndIf
								Else
									Alert("Almoxarifado inválido para transferência na mesma filial !")
								Endif
							EndIf

						EndIf
					Else
						Alert("Essa informação já foi digitada na transferência !")
					Endif
				Endif
			Endif
		  //  acols[n][oGet:obrowse:colpos] := &(ReadVar())
		EndIF
	ElseIf cVar == "M->D3_QUANT"
		If lRet := Positivo(M->D3_QUANT)
			If lRet := (M->D3_QUANT <= SaldoProduto(aCols[n,nPFOri],aCols[n,nPPrd],aCols[n,nPLOri]))
				If Len(_adPed) > 0
					If lRet := M->D3_QUANT <= _adPed[n][04]
					Else
						Alert("Quantidade é maior que o saldo disponível no Pedido de Venda!") 
					EndIf
				EndIF
			Else
				Alert("Quantidade é maior que o saldo disponível !")
			Endif
		Endif
	Endif
	oGet:REfresh()
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ LimpaCampos¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 17/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina para zerar os campos                                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function LimpaCampos(nPos,lAll)
	Local x

	For x:=nPos To If( lAll == Nil .Or. lAll , Len(aHeader), nPos)
		aCols[n,x] := CriaVar(Trim(aHeader[x,2]))
	Next

Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦SaldoProduto¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 17/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de cálculo do saldo atual do produto                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function SaldoProduto(cCodFil,cProduto,cLocal)
	Local nRet := 0

	SB2->(dbSetOrder(1))
	If SB2->(dbSeek(cCodFil+cProduto+cLocal))
		// Pega o saldo atual em estoque
		nRet := SB2->(B2_QATU - If( B2_RESERVA > 0 , B2_RESERVA, 0))
		// Subtrai do que já foi digitado para o Produto + Almoxarifado
		aEval( aCols , {|x| If( !x[nPDel] .And. x[nPPrd]+x[nPLOri] == cProduto+cLocal , nRet -= x[nPQtd], 0) } )
		// Soma o conteúdo atual digitado para Produto + Almoxarifado
		nRet += aCols[n,nPQtd]
	Endif

Return nRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATP01LinOk¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 17/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar a linha do item                                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FATP01LinOk(nPos)
	Local lRet := .T.

	nPos := If( nPos == Nil , n, nPos)

	If !aCols[n,nPDel]  // Se não estiver deletado
		nPos := AScan( aCols[nPos] , {|x| Empty(x) },,nPosLote - 1 )

		If nPos > 0 .And. nPos < Len(aCols[1])
			lRet := .F.
			Alert("Existem campos obrigatórios vazios !")
		Endif
		If lRet
			M->D3_QUANT := aCols[n,nPQtd]
			lRet := u_FATP01Valid(nPQtd,"M->D3_QUANT")		      
		EndIf
	Endif

Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATP01TudOk¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 17/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar todas as linhas dos itens                             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FATP01TudOk()
	Local x
	Local nCnt := 0
	Local lRet := .T.

	For x:=1 To Len(aCols)
		If !(lRet := u_FATP01LinOk(x))
			Exit
		Endif
	Next

	If lRet
		// Conta o número de itens deletados
		aEval( aCols , {|x| nCnt += If( x[nPDel] , 1, 0) } )

		If lRet := (nCnt <> Len(aCols))
		Else
			Aviso( "INVÁLIDO", "Não podem ser excluídos todos os itens. Utilize a opção EXCLUIR !", {"Ok"} )
		Endif

	Endif

Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATP01Grava¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 17/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Grava os dados da transferência                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function FATP01Grava(aParam310)
	Local x, aDadosTransf, cFil
	// Array com dados para transferencia
	// [1] Filial  origem
	// [2] Produto origem
	// [3] Armazem origem
	// [4] Quantidade origem
	// [5] Quantidade origem 2a UM
	// [6] Filial  destino
	// [7] Armazem destino
	// [8] Cliente na Origem
	// [9] Loja na Origem
	// [10] Fornecedor no destino
	// [11] Loja no destino
	// [12] Documento na origem
	// [13] Serie do documento na origem


	// Ordena os itens por Filial + Produto + Armazem
	//ASort( aCols ,,, {|x,y| x[nPFOri]+x[nPPrd]+x[nPLOri] < y[nPFOri]+y[nPPrd]+y[nPLOri] })

	x := 1
	_xdPed := Len(_adPed)
	//u_AAFVNX01(cLogName,"Analisando aCols para Definir Dados de Transferência")
	While x <= Len(aCols)
		aDadosTransf := {}
		cFil := aCols[x,nPFOri]
		While x <= Len(aCols) .And. cFil == aCols[x,nPFOri]
			//nPDel := 9
			If !aCols[x,nPDel]   // Se não tiver deletado

				//u_AAFVNX01(cLogName,"Posicionando no Cliente")
				u_AAVldCliFor("SA1",aCols[x,nPFDes],aCols[x,nPLDes] = "13")   // Posiciona no cliente
				//u_AAFVNX01(cLogName,"Posicionando no Fornecedor")
				u_AAVldCliFor("SA2",aCols[x,nPFOri])   // Posiciona no fornecedor


				//u_AAFVNX01(cLogName,"Adicionando Dados ao Vetor a DadosTransf")
				//u_AAFVNX01(cLogName,"Dados("// + + ")")
				AADD( aDadosTransf , { aCols[x,nPFOri] /**/ ,;
				aCols[x,nPPrd] ,;//02
				aCols[x,nPLOri],;//03
				aCols[x,nPQtd],;//04
				0,;//05
				aCols[x,nPFDes],;//06
				aCols[x,nPLDes],;//07
				SA1->A1_COD,;//08
				SA1->A1_LOJA,;//09
				SA2->A2_COD,;//10
				SA2->A2_LOJA,;//11
				"",;//12
				"" ,;//13
				iIf(_xdPed >= x,_adPed[x],{ 0 ,"", 0, 0 , "" ,0,0 } ) ,;//14
				IIf( nPosLote > 0, aCols[x,nPosLote],""),;//15
				IIf( nPosDtLo > 0, aCols[x,nPosDtLo],""),;//16
				IIf( nPosEnd > 0, aCols[x,nPosEnd],"")})//17

				n_xdPo := Len(aDadosTransf)
				cdPrint := "{"
				cdPrint += '"FilOrig":"' + aDadosTransf[n_xdPo][01] + '" ,'
				cdPrint += '"Produto":"' + aDadosTransf[n_xdPo][02] + '" ,'
				cdPrint += '"LocOrig":"' + aDadosTransf[n_xdPo][03] + '" ,'
				cdPrint += '"Quantidade":' + Alltrim(Str(aDadosTransf[n_xdPo][04])) + ' ,'
				cdPrint += '"Pos05":' + Alltrim(Str(aDadosTransf[n_xdPo][05])) + ' ,'
				cdPrint += '"FilDest":' + aDadosTransf[n_xdPo][06] + ' ,'
				cdPrint += '"LocDest":' + aDadosTransf[n_xdPo][07] + ' ,'
				cdPrint += '"Cliente":' + aDadosTransf[n_xdPo][08] + ' ,'
				cdPrint += '"LojCli":' + aDadosTransf[n_xdPo][09] + ' ,'
				cdPrint += '"Fornecedor":' + aDadosTransf[n_xdPo][10] + ' ,'
				cdPrint += '"LojFor":' + aDadosTransf[n_xdPo][11]
				cdPrint += "}"

				//u_AAFVNX01(cLogName, cdPrint)					
			Endif

			x++

			// Caso tenha chegado ao limite de 359 itens, sai para gerar a nota
			If Len(aDadosTransf) == 359
				Exit
			Endif
		Enddo

		If !Empty(aDadosTransf)
			//u_AAFVNX01(cLogName,"Processando Transferencia")
			Processa({|lEnd| FATP01Proc(aDadosTransf,aParam310) },OemToAnsi(STR0019),OemToAnsi(STR0020),.F.)
		Endif
	Enddo

Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦FATP01CpoAlt¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 17/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Habilita a leitura dos campos conforme condicao               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function FATP01CpoAlt(oGet)
	Local vVar := { "C9_PRODUTO", "LJ_RPCFIL", "D3_QUANT"}  // Vetor com os campos a serem editados

	// Se as filiais forem iguais, o almoxarifado não poderá ser alterado
	If .T. //aCols[oGet:nAt,nPFOri] <> aCols[oGet:nAt,nPFDes]
		AAdd( vVar , "C9_LOCAL" )   // Adiciona o almoxarifado para leitura
	Endif

	oGet:aAlter := vVar
	oGet:oMother:aAlter := vVar

Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MontaaCols ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 17/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria a variavel vetor aCols                                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function MontaaCols()
	Local nCols, nX

	//+--------------
	//| Monta o aHeader
	//+--------------
	CriaHeader()

	//+--------------
	//| Monta o aCols com os dados referentes os ITENS DA TRANSFERÊNCIA
	//+--------------
	nCols  := 0
	nUsado := Len(aHeader)

	If !Inclui
		dbSelectArea(cAlias2)
		dbSetOrder(1)
		dbSeek(PA4->(PA4_FILIAL+PA4_NUM),.T.)
		While !Eof() .And. PA4->(PA4_FILIAL+PA4_NUM) == C6_FILIAL+C6_NUM

			aAdd(aCols,Array(nUsado+1))
			nCols ++

			For nX := 1 To nUsado
				If ( aHeader[nX][10] != "V")
					aCols[nCols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
				Endif
			Next nX
			aCols[nCols][nUsado+1] := .F.

			dbSkip()
		Enddo
	Endif

	If Empty(aCols)  // Caso nao tenha itens na transferência
		//+--------------
		//| Monta o aCols com uma linha em branco
		//+--------------
		aColsBlank(@aCols,nUsado)
	Endif

Return .T.

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CriaHeader ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 17/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria a variavel vetor aHeader                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CriaHeader()
	Local i
	// Cria aHeader com os dados das TRANSFERÊNCIAS
	/*
	SX3->(dbSetOrder(2))

	For x:=1 To Len(vCampos)
		If SX3->(dbSeek(vCampos[x]))
			If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL

				aAdd(aHeader,{ vLegend[x]       , ;  //Trim(X3Titulo())
				SX3->X3_CAMPO    , ;
				SX3->X3_PICTURE  , ;
				SX3->X3_TAMANHO  , ;
				SX3->X3_DECIMAL  , ;
				"u_FATP01Valid("+LTrim(Str(x,2))+")", ;
				SX3->X3_USADO    , ;
				SX3->X3_TIPO     , ;
				SX3->X3_ARQUIVO  , ;
				SX3->X3_CONTEXT  } )

			Endif
		Endif
	Next
	*/

	//-----------------------------------------------------
	// Tratativa Code Analysis - Kodigos - 14/07/2023
	//-----------------------------------------------------
	For i:=1 to len(vCampos)
   		If cNivel >= GetSX3Cache(vCampos[i],"X3_NIVEL") .And. X3USO(GetSX3Cache(vCampos[i],"X3_USADO")) 
		   	aAdd(aHeader,{; 
            Trim(GetSX3Cache(vCampos[i],"X3_TITULO") ), ;
			GetSX3Cache(vCampos[i],"X3_CAMPO")   , ; 
			GetSX3Cache(vCampos[i],"X3_PICTURE")  ,;  
			GetSX3Cache(vCampos[i],"X3_TAMANHO") , ; 
			GetSX3Cache(vCampos[i],"X3_DECIMAL") , ;
			"u_FATP01Valid("+LTrim(Str(i,2))+")", ;
			GetSX3Cache(vCampos[i],"X3_USADO")    , ; 
			GetSX3Cache(vCampos[i],"X3_TIPO")    , ; 
			GetSX3Cache(vCampos[i],"X3_ARQUIVO")    , ; 
			GetSX3Cache(vCampos[i],"X3_CONTEXT")     ; 
			} )
		ENDIF
	Next

Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ aColsBlank ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 17/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria array de itens em branco                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function aColsBlank(aArray,nUsado)
	//Local x := 0
	Local i
	aArray := {}
	aAdd(aArray,Array(nUsado+1))
	nUsado := 0
	/*
	SX3->(dbSetOrder(2))

	For x:=1 To Len(vCampos)
		If SX3->(dbSeek(vCampos[x]))
			If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
				nUsado++
				aArray[1][nUsado] := CriaVar(Trim(SX3->X3_CAMPO),.T.)
			Endif
		Endif
		aArray[1][nUsado+1] := .F.
	Next
	*/

	//-----------------------------------------------------
	// Tratativa Code Analysis - Kodigos - 14/07/2023
	//-----------------------------------------------------
	For i:=1 to len(vCampos)
   		If cNivel >= GetSX3Cache(vCampos[i],"X3_NIVEL") .And. X3USO(GetSX3Cache(vCampos[i],"X3_USADO")) 
		   	nUsado++
			aArray[1][nUsado] := CriaVar(Trim(GetSX3Cache(vCampos[i],"X3_CAMPO")),.T.)
		ENDIF
		aArray[1][nUsado+1] := .F.
	Next

Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦CarregaParam¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 25/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Atualiza os parâmetros da rotina padrão                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CarregaParam(aParam310,aPar)
	aParam310[01] := mv_par01 := Repli(" ",TamSX3("B1_COD"   )[1])
	aParam310[02] := mv_par02 := Repli("Z",TamSX3("B1_COD"   )[1])
	aParam310[03] := mv_par03 := Repli(" ",TamSX3("B1_FILIAL")[1])
	aParam310[04] := mv_par04 := Repli("Z",TamSX3("B1_FILIAL")[1])
	aParam310[05] := mv_par05 := Repli(" ",TamSX3("B1_LOCPAD")[1])
	aParam310[06] := mv_par06 := Repli("Z",TamSX3("B1_LOCPAD")[1])
	aParam310[07] := mv_par07 := Repli(" ",TamSX3("B1_TIPO"  )[1])
	aParam310[08] := mv_par08 := Repli("Z",TamSX3("B1_TIPO"  )[1])
	aParam310[09] := mv_par09 := Repli(" ",TamSX3("B1_GRUPO" )[1])
	aParam310[10] := mv_par10 := Repli("Z",TamSX3("B1_GRUPO" )[1])
	aParam310[11] := mv_par11 := 2  // Não
	aParam310[12] := mv_par12 := 1  // Produto
	aParam310[13] := mv_par13 := aPar[1]
	aParam310[14] := mv_par14 := aPar[2]
	aParam310[15] := mv_par15 := aPar[3]
	aParam310[16] := mv_par16 := aPar[4]
	aParam310[17] := mv_par17 := aPar[5]
	aParam310[18] := mv_par18 := aPar[6]
	aParam310[19] := mv_par19 := aPar[7]
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAVldCliFor¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 25/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Valida o cliente e fornecedor da transferência                ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAVldCliFor(cAlias,cCodFil,_lArm13)

	Local nPos
	Local aAreaSM0 := SM0->(GetArea())
	Local lRet     := .F.
	//Tratativa Code Analysis - Kodigos -  14/07/2023
	xyXCLIDEP:= Alltrim(SuperGetMv("MV_XCLIDEP",.F.,""))

	Default _lArm13 := .F.

	If Type("aFiliais") == "U"  // Caso não tenha carregado as filiais
		aFiliais := {}
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega filiais da empresa corrente                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SM0")
		dbSeek(cEmpAnt)
		xyPARAM310 := Type("aParam310")
		While !Eof() .And. SM0->M0_CODIGO == cEmpAnt
			// Adiciona filial
			MOFILIAL := Padr(SM0->M0_CODFIL,FWSizeFilial() )
			If xyPARAM310 == "U" .Or. MOFILIAL >= aParam310[03] .And. MOFILIAL <= aParam310[04]
				Aadd( aFiliais , { MOFILIAL , SM0->M0_CODIGO, SM0->M0_CGC, SM0->M0_INSC, SM0->M0_FILIAL})
			EndIf
			dbSkip()
		Enddo
		RestArea(aAreaSM0)
	Endif

	nPos := AScan( aFiliais , {|x| x[1] == cCodFil } )

	If _lArm13 .And. cAlias == "SA1"
		SA1->(dbSetOrder(1))
		If SA1->(dbSeek(xFilial(cAlias) + Alltrim(SuperGetMv("MV_XCLIDEP",.F.,"")) + Alltrim(SuperGetMv("MV_XLOJDEP",.F.,""))  ))
			lRet := .T.
			Return lRet
		else
			Help(" ",1,"A310DATFL1")
		EndIf
	EndIf

	(cAlias)->(dbSetOrder(3))

	cwFil := xFilial(cAlias)
	cwCgc := Padr( aFiliais[nPos,3],TAMSX3("A1_CGC")[01]  )
	cwIns := Padr( aFiliais[nPos,4],TAMSX3("A1_INSCR")[01] )

	cwCp1 := cAlias+"->"+SubStr(cAlias,2,2) + "_INSCR"
	cwCp2 := cAlias+"->"+SubStr(cAlias,2,2) + "_FILIAL"
	cwCp3 := cAlias+"->"+SubStr(cAlias,2,2) + "_CGC"
	cwCp4 := cAlias+"->"+SubStr(cAlias,2,2) + "_COD"
	cwCp5 := cAlias+"->"+SubStr(cAlias,2,2) + "_LOJA"

	//If lRet := (nPos > 0 .And. (cAlias)->(dbSeek(xFilial(cAlias)+Substr(aFiliais[nPos,3],1,Len(SA1->A1_CGC)))) )
	If lRet := ( nPos > 0 .And. (cAlias)->(  dbSeek( cwFil + cwCgc )  ) )
		// adicionado por wermeson
		lwRet := .F.
		While !(cAlias)->(Eof()) .And. (cwFil + cwCgc == &cwCp2+ &cwCp3) .And. !lwRet
			If cwIns == &cwCp1 .And. xyXCLIDEP != (cAlias)->&cwCp4
				lwRet := .T.
			Else
				(cAlias)->(dbSkip())
			EndIf
		EndDo

		If !lwRet
			If cAlias == "SA1"
				// Nao existem dados da filial destino cadastrados como cliente na filial origem. A transferencia nao sera realizada
				Help(" ",1,"A310DATFL1")
			Else
				// Nao existem dados da filial origem cadastrados como fornecedor na filial destino. A transferencia nao sera realizada
				Help(" ",1,"A310DATFL2")
			Endif
		else
			lRet := lwRet
		EndIf

	Else
		If cAlias == "SA1"
			// Nao existem dados da filial destino cadastrados como cliente na filial origem. A transferencia nao sera realizada
			Help(" ",1,"A310DATFL1")
		Else
			// Nao existem dados da filial origem cadastrados como fornecedor na filial destino. A transferencia nao sera realizada
			Help(" ",1,"A310DATFL2")
		Endif
	Endif

Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ ValidPerg  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 25/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria perguntas para a rotina                                  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
/*
Static Function ValidPerg(cPerg)
	Local x, y, nTam
	Local cStr    := "0"
	Local vPerg   := {}
	Local cOrigem := PADR("MTA310",10)

	// Pesquisa somente essas perguntas da rotina padrão
	//Code Analysis - manipulação de perguntes não permitida -  Kodigos - 14/07/2023
	SX1->(dbSeek(cOrigem+"13",.T.))
	While !SX1->(Eof()) .And. cOrigem == SX1->X1_GRUPO
		AAdd( vPerg , {} )
		nTam := Len(vPerg)
		For x:=1 To SX1->(FCount())
			AAdd( vPerg[nTam] , SX1->(FieldGet(x)) )
		Next
		SX1->(dbSkip())
	Enddo

	// Processa a gravação das perguntas da rotina
	For x:=1 To Len(vPerg)
		cStr := Soma1(cStr)  // Calcula a próxima ordem
		If !SX1->(dbSeek(cPerg+StrZero(x,2)))
			RecLock("SX1",.T.)
			For y:=1 To SX1->(FCount())
				FieldPut( y , vPerg[x,y] )
			Next
			SX1->X1_GRUPO   := cPerg
			SX1->X1_ORDEM   := StrZero(x,2)
			SX1->X1_VARIAVL := "mv_ch" + cStr
			SX1->X1_VAR01   := "mv_par" + SX1->X1_ORDEM
			MsUnLock()
		Endif
	Next
	nTot := Len(vPerg) + 1
	//Adicionado por Diego
	putSX1(cPerg,"08", "Filial Origem? ","","","mv_ch8","C",02,0,0,"G","","SLJ","","","mv_par08");nTot++
	putSX1(cPerg,"09", "Filial Destino?","","","mv_ch9","C",02,0,0,"G","","SLJ","","","mv_par09")
	
Return
*/

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A310VldTes ³ Autor ³Marcos V. Ferreira   ³ Data ³ 10/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao da TES                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ A310VldTes(cFilOrig,cFilDest)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cFilOrig  = Codigo da Filial Origem                        ³±±
±±³          ³ cFilDest  = Codigo da Filial Destin                        ³±±
±±³          ³ lValida   = Verifica se valida Tes                         ³±±
±±³          ³ aParam310 = Parametros do MATA310                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA310                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FATP01VldTes(cFilOrig,cFilDest,lValida,aParam310)
	Local aAreaAnt  := GetArea()
	Local aAreaSF4  := SF4->(GetArea())
	Local lRet      := .T.

	Default lValida := .T.

	// Carrega Filial Origem e Destino
	cFilOrig := IIf(Empty(xFilial("SF4")),"  ",cFilOrig)
	cFilDest := IIf(Empty(xFilial("SF4")),"  ",cFilDest)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida TES de Transferencia entre Filiais                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF4")
	If lValida
		// Verifica se a Tes esta cadastrada na Filial Origem
		If lRet .And. !MsSeek(cFilOrig+aParam310[13])
			Aviso(STR0037,STR0038 + aParam310[13] + STR0060 + cFilOrig + STR0061, {"Ok"}) //"A TES XXX de saida não esta cadastrada na filial ##. Favor verificar se a TES esta cadastrada."
			lRet := .F.
		EndIf
		// Verifica se a Tes esta cadastrada na Filial Destino
		If lRet .And. !MsSeek(cFilDest+aParam310[15])
			Aviso(STR0037,STR0038 + aParam310[15] + STR0062 + cFilOrig + STR0061, {"Ok"}) //"A TES XXX de entrada não esta cadastrada na filial ##. Favor verificar se a TES esta cadastrada."
			lRet := .F.
		EndIf
		// Verifica se o TES pode ser utilizada na operacao
		If lRet .And. !(MAAVALTES("S",aParam310[13]) .And. MAAVALTES("E",aparam310[15]))
			lRet := .F.
		EndIf
		// Validacao para o campo F4_TRANSFIL
		If lRet .And. FieldPos("F4_TRANFIL") > 0
			If MsSeek(cFilOrig+aParam310[13]) .And. SF4->F4_TRANFIL == "2"
				If Aviso(STR0037,STR0038 + aParam310[13] + STR0039, {STR0040,STR0041}) == 2 //"A TES XXX não esta configurada para ser utilizada no processo de transferencia entre filiais. Favor verificar se o campo 'Trans. Filial' esta ativado no cadastro de TES."
					lRet := .F.
				EndIf
			EndIf
		EndIf
		If lRet .And. FieldPos("F4_TRANFIL") > 0
			If MsSeek(cFilDest+aParam310[15]) .And. SF4->F4_TRANFIL == "2"
				If Aviso(STR0037,STR0038 + aParam310[15] + STR0039, {STR0040,STR0041}) == 2  //"A TES XXX não esta configurada para ser utilizada no processo de transferencia entre filiais. Favor verificar se o campo 'Trans. Filial' esta ativado no cadastro de TES."
					lRet := .F.
				EndIf
			EndIf
		EndIf
		// Validacao para os campos de impostos F4_CREDICM e F4_CREDIPI
		If lRet .And. MsSeek(cFilOrig+aParam310[13]) .And. (SF4->F4_CREDICM == 'S' .Or. SF4->F4_CREDIPI == 'S')
			If Aviso(STR0037,STR0038+ aParam310[13] + STR0055, {STR0040,STR0041}) == 2 // "A TES " ### " de saida selecionada possue configuração de impostos o que podera causar divergencia nos custos. Deseja continua ?"
				lRet := .F.
			EndIf
		EndIf
		If lRet .And. MsSeek(cFilDest+aParam310[15]) .And. (SF4->F4_CREDICM == 'S' .Or. SF4->F4_CREDIPI == 'S')
			If Aviso(STR0037,STR0038+ aParam310[15] + STR0056, {STR0040,STR0041}) == 2 // "A TES " ### " de entrada selecionada possue configuração de impostos o que podera causar divergencia nos custos. Deseja continua ?"
				lRet := .F.
			EndIf
		EndIf
		// Validacao para o campo F4_ESTOQUE
		If lRet .And. MsSeek(cFilOrig+aParam310[13]) .And. SF4->F4_ESTOQUE == 'N'
			If Aviso(STR0037,STR0038+ aParam310[13] + STR0058, {STR0040,STR0041}) == 2 // "A TES " ### " de entrada selecionada possue configuração para não atualizar estoque o que pode causar divergencia nos movimentos de transferencia. Deseja continua ?"
				lRet := .F.
			EndIf
		EndIf
		If lRet .And. MsSeek(cFilDest+aParam310[15]) .And. SF4->F4_ESTOQUE == 'N'
			If Aviso(STR0037,STR0038+ aParam310[15] + STR0057 , {STR0040,STR0041}) == 2 // "A TES " ### " de saida selecionada possue configuração para não atualizar estoque o que pode causar divergencia nos movimentos de transferencia. Deseja continua ?"
				lRet := .F.
			EndIf
		EndIf
	EndIf
	RestArea(aAreaSF4)
	RestArea(aAreaAnt)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ A310Proc                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Rodrigo de Almeida Sartorio              ³ Data ³ 16/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Processa transferencia                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³aDadosTransf Array com dados para transferencia             ³±±
±±³           ³aParam310    Array com as perguntas selecionadas            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Uso      ³ MATA310                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FATP01Proc(aDadosTransf,aParam310)
	// Variavel com a filial origem
	Local cFilOri   := cFilAnt
	// Array com os parametros do programa
	Local aParam460:=Array(30)
	Local cPedido   := ""
	Local cWhile    := ""
	Local cSerie    := ""
	Local cNotaFeita:= ""
	Local aCabec    := {}
	Local aItens    := {}
	Local aPvlNfs   := {}
	Local aBloqueio := {{"","","","","","","",""}}
	Local aNotas    := {}
	Local aDadosAux := {}
	Local nItemNf   := 0
	Local nSaveSX8  := 0
	Local nAchoSerie:= 0
	Local nPrcVen   := 0
	Local nPosLocal := 0
	Local ni        := 1
	Local nx        := 1
//	Local nZ        := 1
	Local aSeries   :={}
	Local _ndI      := 0

	// Array com notas geradas
	Local aNotaFeita:= {}

	// Variaveis para rotina automatica
	Local lMostraErro   := .F.
	Local cGrade        := "N"
	Local aColsAux      := { }
	Local lReferencia   := .F.
	Local nItGrd        := 0
	// Verifica se existe ponto para manipulacao de itens
	Local lExecItens:=ExistBlock("M310ITENS")
	Local aBackItens:={}
	Local lExecCabec:=ExistBlock("M310CABEC")
	Local aBackCabec:={}

	Private lMsErroAuto := .F.
	Private cNumero     := ""
	// Variavel utilizada para verificar se o numero da nota foi alterado pelo usuario (notas de saida e entrada
	// com formulario proprio).
	Private lMudouNum := .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                               ³
	//³ mv_par01        // De  Produto                                     ³
	//³ mv_par02        // Ate Produto                                     ³
	//³ mv_par03        // De  filial                                      ³
	//³ mv_par04        // Ate filial                                      ³
	//³ mv_par05        // De  Armazem                                     ³
	//³ mv_par06        // Ate Armazem                                     ³
	//³ mv_par07        // De  Tipo                                        ³
	//³ mv_par08        // Ate Tipo                                        ³
	//³ mv_par09        // De  Grupo                                       ³
	//³ mv_par10        // Ate Grupo                                       ³
	//³ mv_par11        // Filtra Categorias  1 Sim  2 Nao                 ³
	//³ mv_par12        // Quebra informacoes 1 Por produto 2 Por Armazem  ³
	//³ mv_par13        // Codigo da TES utilizada nas NFs de saida        ³
	//³ mv_par14        // Indica como deve gerar o documento              ³
	//³ mv_par15        // Codigo da TES utilizada nas NFs de entrada      ³
	//³ mv_par16        // Codigo da condicao de pagamento                 ³
	//³ mv_par17        // Sugere preco 1 Tab 2 Custo STD 3 Ult Pr 4 CM    ³
	//³ mv_par18        // Dados origem - somente filial corrente / todas  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Array com dados para transferencia
	// [1] Filial  origem
	// [2] Produto origem
	// [3] Armazem origem
	// [4] Quantidade origem
	// [5] Quantidade origem 2a UM
	// [6] Filial  destino
	// [7] Armazem destino
	// [8] Cliente na Origem
	// [9] Loja na Origem
	// [10] Fornecedor no destino
	// [11] Loja no destino
	// [12] Documento na origem
	// [13] Serie do documento na origem
	// Varre array para efetuar gravacoes
	//u_AAFVNX01(cLogName,"Procura Serie e NF")

	//TRatativa Code Analysis - Kodigos - 14/07/2023
	xyTPNRNFS:= SuperGetMV("MV_TPNRNFS")
	For nx :=1 to Len(aDadosTransf)
		If nx == 1 .Or. (aDadosTransf[nx,1] # aDadosTransf[nx-1,1])
			// Atualiza para a filial origem
			cFilant:=aDadosTransf[nx,1]
			// Obtem serie para as notas desta filial
			cSerie  :=""
			cNumero := ""
			//u_AAFVNX01(cLogName,"Selecionando Serie / NF")
			Sx5NumNota(@cSerie,xyTPNRNFS,cFilAnt)
			// Caso tenha selecionado numero		    
			If !Empty(cNumero)
				AADD(aSeries,{cFilAnt,cSerie,cNumero})
				//u_AAFVNX01(cLogName,'{"Serie":"'+ cSerie +'" , "Numero":"' + cNumero + '" }')
			EndIf
		EndIf
	Next nx


	//Tratativa Code Analysis	
	xyLocaliz:= GetMv("MV_LOCALIZ")

	If Pergunte("MT460A",.T.)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta regua de processamento                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcRegua(Len(aDadosTransf)*2)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processa geracao de documentos de saida                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega parametros do programa                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nx := 1 to 30
			aParam460[nx] := &("mv_par"+StrZero(nx,2))
		Next nx
		// Sorteia array para aglutinar por filial origem e destino
		ASORT(aDadosTransf,,,{|x,y| x[1]+x[6]+x[2]+x[3] < y[1]+y[6]+y[2]+y[3] })
		// Varre array para efetuar gravacoes
		While (ni <= Len(aDadosTransf))

			// Variavel para rotina automatica
			lMsErroAuto := .F.
			// Array auxiliar
			aDadosAux   := {}
			// Atualiza para a filial origem
			cFilant:=aDadosTransf[ni,1]
			// Array para geracao de notas
			aNotas   := {}
			// Arrays com itens e bloqueios
			aPvlNfs  := {}
			aBloqueio:= {}
			// Cabecalho do pedido
			aCabec   := {}
			// Itens do pedido
			aItens   := {}
			// Variavel que controla numeracao
			nSaveSX8 := GetSx8Len()
			// Variavel para processamento
			cWhile:=aDadosTransf[ni,1]+aDadosTransf[ni,6]
			// Obtem serie para as notas desta filial
			nAchoSerie:=ASCAN(aSeries,{|x| x[1] == cFilAnt})
			// Caso tenha selecionado serie para esta filial
			If nAchoSerie > 0
				// Atualiza para a filial destino
				cFilant:=aDadosTransf[ni,6]
				// Verifica se Numero e serie já foram cadastrados
				dbSelectArea("SF1")
				dbSetOrder(1)
				If MsSeek(xFilial("SF1")+aSeries[nAchoSerie,3]+aSeries[nAchoSerie,2]+aDadosTransf[ni,10])
					Aviso(STR0037,STR0042,{"Ok"}) //"A numeração informada para esta transferencia já possui um documento registrado com a mesma numeração, favor informar uma nova numeração. "
					Exit
				EndIf
				// Atualiza para a filial origem
				cFilant:=aDadosTransf[ni,1]
				// Serie para geracao da nota
				cSerie:=aSeries[nAchoSerie,2]
				// Cabecalho do pedido
				//cPedido := GetSxeNum("SC5","C5_NUM")

				cPedido := iIF(_ldInclui,GetSxeNum("SC5","C5_NUM"),_cdPed)

				//u_AAFVNX01(cLogName,"Pega Numero do Pedido" + cPedido)

				RollBAckSx8()
				//u_AAFVNX01(cLogName,"Preenche Cabecalho do Pedido")
				If _ldInclui .Or. _ldChange
					//u_AAFVNX01(cLogName,"Incluindo Novo Pedido")
					aadd(aCabec,{"C5_NUM",cPedido,Nil})
					aadd(aCabec,{"C5_TIPO","N",Nil})
					aadd(aCabec,{"C5_CLIENTE",aDadosTransf[ni,8],Nil})
					aadd(aCabec,{"C5_LOJACLI",aDadosTransf[ni,9],Nil})
					aadd(aCabec,{"C5_LOJAENT",aDadosTransf[ni,9],Nil})
					aadd(aCabec,{"C5_CONDPAG",aParam310[16],Nil})
				Else
					//u_AAFVNX01(cLogName,"Alterando o Pedido Selecionado")
					IF SC5->(dbSeek(xFilial('SC5') + cPedido))
						aadd(aCabec,{"C5_NUM"    ,cPedido,Nil})
						aadd(aCabec,{"C5_TIPO"   ,SC5->C5_TIPO,Nil})
						aadd(aCabec,{"C5_CLIENTE",SC5->C5_CLIENTE,Nil})
						aadd(aCabec,{"C5_LOJACLI",SC5->C5_LOJACLI,Nil})
						aadd(aCabec,{"C5_LOJAENT",SC5->C5_LOJAENT,Nil})
						aadd(aCabec,{"C5_CONDPAG",SC5->C5_CONDPAG,Nil})

					Else 
						MsgStop("Pedido Não localizado! ")
						Return Nil
					EndIf 

				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de entrada para ALTERAR os dados do cabecalho do pedido de vendas  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lExecCabec
					aBackCabec:=ACLONE(aCabec)
					aCabec:=ExecBlock("M310CABEC",.F.,.F.,{"MATA410",aCabec})
					If ValType(aCabec) # "A"
						aCabec:=ACLONE(aBackCabec)
					EndIf
				EndIf
				// Contador dos itens
				nx:=0
				cItemPed := StrZero(0,TamSX3("C6_ITEM")[1])
				nItGrd:=0
				// ATENCAO - VARIAVEL CRIADAS POR CAUSA DA QUEBRA NO FATURAMENTO
				aNotaFeita:={}
				_adReg := {}
				_adReg2:= {}
				If !_ldInclui
					SC6->(dbSetOrder(1))
					SC6->(dbSeek(xFilial('SC6') + cPedido))
					cItemPed := ""
					aItens := {}
					//u_AAFVNX01(cLogName,"Preenchendo os Itens")
					While xFilial('SC6') + cPedido == SC6->C6_FILIAL + SC6->C6_NUM
						aLinha := {}
						aadd(aLinha,{"C6_ITEM"   ,SC6->C6_ITEM    ,Nil})
						aadd(aLinha,{"C6_PRODUTO",SC6->C6_PRODUTO ,Nil})
						aadd(aLinha,{"C6_LOCAL"  ,SC6->C6_LOCAL   ,Nil})
						aadd(aLinha,{"C6_QTDVEN" ,SC6->C6_QTDVEN  ,Nil})
						aadd(aLinha,{"C6_PRCVEN" ,SC6->C6_PRCVEN  ,Nil})
						aadd(aLinha,{"C6_PRUNIT" ,SC6->C6_PRUNIT  ,Nil})
						aadd(aLinha,{"C6_VALOR"  ,SC6->C6_VALOR   ,Nil})
						aadd(aLinha,{"C6_TES"    ,SC6->C6_TES     ,Nil})
						aadd(aLinha,{"C6_GRADE"  ,SC6->C6_GRADE   ,Nil})
						aadd(aLinha,{"C6_ITEMGRD",SC6->C6_ITEMGRD ,Nil})
						aadd(aLinha,{"C6_QTDLIB" ,0               ,Nil})

						If Rastro(SC6->C6_PRODUTO,"L")
							aadd(aLinha,{"C6_LOTECTL",SC6->C6_LOTECTL  ,Nil})
							aadd(aLinha,{"C6_DTVALID",SC6->C6_DTVALID  ,Nil})
						EndIf
						If Rastro(SC6->C6_PRODUTO,"S")
							aadd(aLinha,{"C6_NUMLOTE",SC6->C6_NUMLOTE ,Nil})
							aadd(aLinha,{"C6_DTVALID",SC6->C6_DTVALID,Nil})
						EndIf

						aadd(aItens,aLinha)
						//aadd(aLinha,{"C6_QTDLIB" ,aDadosTransf[ni,4],Nil})
						If cItemPed < SC6->C6_ITEM
							cItemPed := SC6->C6_ITEM
						EndIf
						SC6->(dbSkip())
					EndDo
				EndIf

				While (ni <= Len(aDadosTransf)) .And. (aDadosTransf[ni,1]+aDadosTransf[ni,6] == cWhile)
					// Incrementa regua de processamento
					IncProc()
					aLinha := {}
					cGrade:="N"
					// Obtem preco de venda do produto
					If aParam310[17] == 1
						SA1->(dbSetOrder(1))
						SA1->(dbSeek(xFilial("SA1")+aDadosTransf[ni,8]+aDadosTransf[ni,9]))
						nPrcVen := MaTabPrVen(SA1->A1_TABELA,aDadosTransf[ni,2],aDadosTransf[ni,4],aDadosTransf[ni,8],aDadosTransf[ni,9],1,dDataBase)
						// Obtem preco - custo standard
					ElseIf aParam310[17] == 2
						nPrcVen := Posicione("SB1",1,xFilial("SB1")+aDadosTransf[ni,2],"B1_CUSTD")
						// Obtem preco - ultimo preco de compra
					ElseIf aParam310[17] == 3
						nPrcVen := Posicione("SB1",1,xFilial("SB1")+aDadosTransf[ni,2],"B1_UPRC")
						// Obtem preco - custo medio unitario do armazem
					ElseIf aParam310[17] == 4
						SB2->(dbSetOrder(1))
						If SB2->(dbSeek(xFilial("SB2")+aDadosTransf[ni,2]+aDadosTransf[ni,3]))
							nPrcVen:=SB2->B2_CM1
						EndIf
					EndIf
					// Senao encontrou nenhum valor assume 1				
					If !Empty(_cdPed)
						_ndPos := aScan(_adPed, {| x | Alltrim(x[02]) == Alltrim(aDadosTransf[ni,2]) } )
						If _ndPos != 0
							//nPrcVen := _adPed[_ndPos][03]
						EndIf
					EndIf

					If QtdComp(nPrcVen,.T.) == QtdComp(0,.T.)
						nPrcVen := 1
					EndIf
					cProdRef:=aDadosTransf[ni,2]
					lReferencia:=MatGrdPrrf(@cProdRef,.T.)
					If lReferencia
						nAchou:=AScan(aColsAux,{|x|x[1]==cProdRef.and. x[2]==aDadosTransf[ni,3]})
						If nAchou >0
							nx:=AcolsAux[nAchou,3]
							nItGrd ++
							cItemPed := StrZero(0,TamSX3("C6_ITEM")[1])
						Else
							nx++
							nItGrd:=1
							aadd(aColsAux,{cProdref,aDadosTransf[ni,3],nx,nItGrd})
						Endif
						cGrade:="S"
					Else
						nx++
					Endif

					_xdPos := aScan(aItens,{|x| x[ aScan(x,{|y| Alltrim(y[01])=="C6_PRODUTO"}) ][02] == aDadosTransf[ni,2] .And.;
					x[ aScan(x,{|y| Alltrim(y[01])=="C6_ITEM"}) ][02] == aDadosTransf[ni,14][05] } )

					If !_ldInclui .And. _xdPos > 0
						_ydPos := aScan( aItens[_xdPos], {|x|  x[01] == "C6_LOCAL"} )
						aItens[_xdPos][_ydPos][02] := aDadosTransf[ni,3]
						_ydPos := aScan( aItens[_xdPos], {|x|  x[01] == "C6_QTDVEN"} )
						_ndQuant := aItens[_xdPos][_ydPos][02]

						_ydPos := aScan( aItens[_xdPos], {|x|  x[01] == "C6_VALOR"} )
						aItens[_xdPos][_ydPos][02] := A410Arred((_ndQuant*nPrcVen),"C6_VALOR")

						_ydPos := aScan( aItens[_xdPos], {|x|  x[01] == "C6_PRCVEN"} )
						aItens[_xdPos][_ydPos][02] := nPrcVen

						_ydPos := aScan( aItens[_xdPos], {|x|  x[01] == "C6_PRUNIT"} )
						aItens[_xdPos][_ydPos][02] := nPrcVen

						_ydPos := aScan( aItens[_xdPos], {|x|  x[01] == "C6_TES"} )
						aItens[_xdPos][_ydPos][02] := aParam310[13]

						_ydPos := aScan( aItens[_xdPos], {|x|  x[01] == "C6_QTDLIB"} )
						aItens[_xdPos][_ydPos][02] := aDadosTransf[ni,4]

						SC6->(dbGoTo(aDadosTransf[ni,14][07]))
						aAdd(_adReg , SC6->(Recno()) )
						aAdd(_adReg2,{SC6->(Recno()), aDadosTransf[ni,4] } )

					Else
						aadd(aLinha,{"C6_ITEM"   ,cItemPed:=Soma1(cItemPed),Nil})
						aadd(aLinha,{"C6_PRODUTO",aDadosTransf[ni,2],Nil})
						aadd(aLinha,{"C6_LOCAL"  ,aDadosTransf[ni,3],Nil})
						aadd(aLinha,{"C6_QTDVEN" ,aDadosTransf[ni,4],Nil})
						_ndTotal := A410Arred((aDadosTransf[ni,4]*nPrcVen),"C6_VALOR")
						aadd(aLinha,{"C6_PRCVEN" ,nPrcVen  ,Nil})
						aadd(aLinha,{"C6_PRUNIT" ,nPrcVen  ,Nil})
						aadd(aLinha,{"C6_VALOR"  ,_ndTotal ,Nil})
						aadd(aLinha,{"C6_TES"    ,aParam310[13],Nil})
						aadd(aLinha,{"C6_GRADE"   ,cGrade,Nil})
						aadd(aLinha,{"C6_ITEMGRD",If(cGrade=="S",Strzero(nItGrd,2)," "),Nil})
						aadd(aLinha,{"C6_QTDLIB" ,Iif(_ldInclui .Or. aFils[1]=="01" ,0 ,aDadosTransf[ni,4]) ,Nil})

						SB1->(dbSetOrder(1))
						SB1->(dbSeek(xFilial('SB1') + aDadosTransf[ni,2] ))

						//If Rastro(SB1->B1_COD,"L") .And. GetMv("MV_RASTRO")
						//_xdLote := _xdGetLote(SB1->B1_COD,aDadosTransf[ni,3] )
						If Rastro(SB1->B1_COD,"L")
							aadd(aLinha,{"C6_LOTECTL",aDadosTransf[ni,15] ,Nil})
							aadd(aLinha,{"C6_DTVALID",aDadosTransf[ni,16] ,Nil})
						EndIF
						If Rastro(SB1->B1_COD,"S")
							aadd(aLinha,{"C6_NUMLOTE",aDadosTransf[ni,15] ,Nil})
							aadd(aLinha,{"C6_DTVALID",aDadosTransf[ni,16] ,Nil})
						EndIF
						If xyLocaliz == 'S'
							aadd(aLinha,{"C6_LOCALIZ",aDadosTransf[ni,17] ,Nil})
						EndIf
						//EndIf
						/*
						If Rastro(SB1->B1_COD ,"S")
						aadd(aLinha,{"C6_NUMLOTE",SC6->C6_NUMLOTE ,Nil})
						aadd(aLinha,{"C6_DTVALID",SC6->C6_DTVALID,Nil})
						EndIf
						*/
						//u_AAFVNX01(cLogName,"Salvando no Vetor Auxiliar: LocDest:" + aDadosTransf[ni,7])
						aadd(aItens,aLinha)
						aadd(aDadosAux,{cPedido,StrZero(nx,2),aDadosTransf[ni,7]})
						/*
						If _ldInclui

						Else
						aadd(aLinha,{"C6_QTDVEN" ,aDadosTransf[ni,14][06],Nil})
						aadd(aLinha,{"C6_QTDLIB" ,aDadosTransf[ni,4],Nil})
						_ndTotal := A410Arred((aDadosTransf[ni,14][06]*nPrcVen),"C6_VALOR")				   				  
						SC6->(dbGoTo(aDadosTransf[ni,14][07]))
						If !SC6->(Eof())
						SC6->(RecLock('SC6',.F.))
						SC6->C6_QTDLIB := aDadosTransf[ni,4]
						SC6->C6_PRCVEN := nPrcVen
						SC6->C6_PRUNIT := nPrcVen
						SC6->C6_VALOR  := A410Arred((aDadosTransf[ni,14][06]*nPrcVen),"C6_VALOR")
						aAdd(_adReg , SC6->(Recno()) )
						aAdd(_adReg2,{SC6->(Recno()), aDadosTransf[ni,4] } )
						SC6->(MsUnlock())
						Else
						Aviso('Atenção','ERRO CATASTROFICO, Houve Uma manutenção no Pedido enquanto ocorria a transferencia',{'OK'} )
						MsFinal()
						EndIf

						EndIf
						*/

					EndIf
					// Incrementa contadores
					//nx++
					ni++
				End
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de entrada para ALTERAR os dados do pedido de vendas   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lExecItens
					aBackItens:=ACLONE(aItens)
					aItens:=ExecBlock("M310ITENS",.F.,.F.,{"MATA410",aItens})
					If ValType(aItens) # "A"
						aItens:=ACLONE(aBackItens)
					EndIf
				EndIf

				//Exclui o Pedido antes de Inclui-lo Novamente
				If !_ldInclui

					//U_ZCONOUT('Parada 001')
					//u_AAFVNX01(cLogName,"Alterando Pedido - " + cPedido)
					//Essa parte do Fonte estava comentada no dia 21/01/2020 - As transfências da Matriz para as Filiais não estavam funcionando.
					//Retirei o comentário para que a rotina efetuasse a alteração do Pedido....e gerou normalmente a Nota Após isso.
					//Williams Messa.
					MATA410(aCabec,aItens,4 ) 

					If !aFils[1]=="01"
						//if ! lMsErroAuto
						lLiber := .T.
						lTransf := .F.
						lLiberOk := .F.
						//U_ZCONOUT('Parada 002')
						//u_AAFVNX01(cLogName,"Liberando Pedido" + cPedido)
						MaAvLibPed( cPedido,lLiber,lTransf,@lLiberOk,_adReg)//,,lEstLib,lAvCred,Nil,@nVlrCred)
						//if
						If !lMsErroAuto
							SC5->(dbSetOrder(1))
							If SC5->(dbSeek(cFilAnt + cPedido))
								SC5->(RecLock('SC5',.F.))
								//SC5->C5_LIBEROK := 'S'
								SC5->(MsUnlock())
							EndIf
							For _ndI := 01 to Len(_adReg2)
								SC6->(dbGoTo(_adReg2[_ndI][01] ))
								
								//MaAvLibPed( SC5->C5_NUM,lLiber,lTransf,@lLiberOk,_adReg2)

								SC9->(dbSetOrder(2))
								SC9->(dbSeek(xFilial('SC9') + SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_NUM + SC6->C6_ITEM))
								
								While SC9->(Eof()) .And. xFilial('SC9') + SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_NUM + SC6->C6_ITEM ==;
								SC9->C9_FILIAL + SC9->C9_CLIENTE + SC9->C9_LOJA + SC9->C9_PEDIDO + SC9->C9_ITEM
									If SC9->C9_QTDLIB == _adReg2[_ndI][02] .And. SC9->C9_DATALIB = dDataBase .And. Len(Rtrim(C9_NFISCAL)) == 0
										lHelp := .T.
										//u_AAFVNX01(cLogName,"Liberando Item do Pedido para Faturamento ")
									    a450Grava(1,.T.,.T.,@lHelp)
									//	SC9->(RecLock('SC9',.F.))
									//		SC9->C9_BLCRED := ""
									//		SC9->C9_BLEST  := ""
									//	SC9->(MsUnlock())									 
									 
										SC9->(dbGoTo(SC9->( lastrec() )))
									EndIf
									//SC9->(RecLock('SC9',.F.))
									//	SC9->C9_BLCRED := ""
									//	SC9->C9_BLEST  := ""
									//SC9->(MsUnlock())
									SC9->(dbSkip())
								EndDo
							Next
						Else
							Aviso('Atenção','Liberação de Pedido Não Efetuada',{'OK'})
							lMsErroAuto := .T.
						EndIf
					EndIf

				Else
					//u_AAFVNX01(cLogName,"Incluindo Pedido")
					MATA410(aCabec,aItens,3 )
				EndIf

				// Inclusao do pedido			
				// Checa erro de rotina automatica
				If lMsErroAuto
					lMostraErro	:=.T.
				Else
					// Confirma SX8
					While ( GetSx8Len() > nSaveSX8 )
						ConfirmSX8()
					Enddo
					// Liberacao de pedido
					If _ldInclui
						//u_AAFVNX01(cLogName,"Liberando Pedido para Faturamento")
						Ma410LbNfs(2,@aPvlNfs,@aBloqueio)				
					EndIf
					// Checa itens liberados
					Ma410LbNfs(1,@aPvlNfs,@aBloqueio)
					// Caso tenha itens liberados manda faturar
					If Empty(aBloqueio) .And. !Empty(aPvlNfs)
						nItemNf  := a460NumIt(cSerie)
						aadd(aNotas,{})
						// Efetua as quebras de acordo com o numero de itens
						For nX := 1 To Len(aPvlNfs)
							If Len(aNotas[Len(aNotas)])>=nItemNf
								aadd(aNotas,{})
							EndIf
							aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[nX]))
						Next nX
						// Gera as notas de acordo com a quebra
						For nX := 1 To Len(aNotas)
							//u_AAFVNX01(cLogName,"Efetuando Faturamento")
							cNotaFeita := MaPvlNfs(aNotas[nX],cSerie,aParam460[01]==1,aParam460[02]==1,aParam460[03]==1,aParam460[04]==1,aParam460[05]==1,aParam460[07],aParam460[08],aParam460[16]==1,aParam460[16]==2)
							
							If Empty(cNotaFeita)

								MsgStop("Problemas na geracao da nota!")
							Else 

								AADD(aNotaFeita,cNotaFeita)
								//u_AAFVNX01(cLogName,"Nota de Saida Gerada: " + cNotaFeita)
								u_TransNfe(cSerie,cNotaFeita)
								u_getAuthNFE(cSerie,cNotaFeita)
							EndIf 
						Next nX
						// Varre notas fiscais de saida geradas para gerar notas fiscais de entrada
						//u_AAFVNX01(cLogName,"Gerando Entrada dos  dados de Saida Gerado")
						For nx:=1 to Len(aNotaFeita)
							aColsAux:={}
							nItem   :=0
							nItGrd  :=0

							//Diego em 21/06/2018 Atualizar os Campos referente a Transferência
							//de Filiais padrões do sistema
							SF2->(dbSetOrder(1))
							If SF2->(dbSeek(xFilial('SF2') + aNotaFeita[nx] + cSerie + aDadosTransf[ni-1,8] + aDadosTransf[ni-1,9] ))
								SF2->(RecLock('SF2',.F.))							   
								SF2->F2_FILDEST := aDadosTransf[ni-1,6]
								SF2->F2_FORDES  := aDadosTransf[ni-1,10]
								SF2->F2_LOJADES := aDadosTransf[ni-1,11]
								SF2->F2_FORMDES := "N"
								SF2->(MsUnlock())
							EndIf

							dbSelectArea("SD2")
							dbSetOrder(21)							
							If dbSeek(xFilial("SD2")+aNotaFeita[nx]+cSerie+aDadosTransf[ni-1,8]+aDadosTransf[ni-1,9])

								// Cabecalho da nota fiscal de entrada
								aCabec   := {}
								aadd(aCabec,{"F1_TIPO"   ,"N"})
								aadd(aCabec,{"F1_FORMUL" ,"N"})
								aadd(aCabec,{"F1_DOC"    ,aNotaFeita[nx]})
								aadd(aCabec,{"F1_SERIE"  ,cSerie})
								aadd(aCabec,{"F1_EMISSAO",dDataBase})
								aadd(aCabec,{"F1_FORNECE",aDadosTransf[ni-1,10]})
								aadd(aCabec,{"F1_LOJA"   ,aDadosTransf[ni-1,11]})
								aadd(aCabec,{"F1_ESPECIE","SPED"}) //aadd(aCabec,{"F1_ESPECIE","NFE"}) Alterado Por Hely para grava a ESPECIE correta (SPED)
								aadd(aCabec,{"F1_COND",aParam310[16]})
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Ponto de entrada para ALTERAR os dados do cabecalho do Documento Entrada ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If lExecCabec
									aBackCabec:=ACLONE(aCabec)
									aCabec:=ExecBlock("M310CABEC",.F.,.F.,{If(aParam310[14] == 1,"MATA140","MATA103"),aCabec})
									If ValType(aCabec) # "A"
										aCabec:=ACLONE(aBackCabec)
									EndIf
								EndIf
								// Itens da nota fiscal de entrada
								aItens   := {}
								//u_AAFVNX01(cLogName,"Posicionando nos Itens de Saida")
								While !Eof() .And. xFilial("SD2")+aNotaFeita[nx]+cSerie+aDadosTransf[ni-1,8]+aDadosTransf[ni-1,9] == D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA
									// Incrementa regua de processamento
									IncProc()
									cGrade:="N"
									aLinha := {}
									cProdRef:=SD2->D2_COD
									/*lReferencia:=MatGrdPrrf(@cProdRef,.T.)
									If lReferencia
										nAchou:=AScan(aColsAux,{|x|x[1]==cProdRef.and. x[2]==aDadosTransf[ni-1,7]})
										If nAchou >0
											nItem:=AcolsAux[nAchou,3]
											nItgrd ++
										Else
											nItem++
											nItgrd:=1
											aadd(aColsAux,{cProdRef,aDadosTransf[ni-1,7],nItem,nItGrd})
										Endif
										cGrade:="S"
									Else
										nItem++
									Endif*/
									
									nItem := nItem+1

									// ALERT(Strzero(nItem , 4) +" - "+ SD2->D2_ITEM)

									aadd(aLinha,{"D1_ITEM",Strzero(nItem,4),Nil})
									aadd(aLinha,{"D1_COD",SD2->D2_COD,Nil})
									aadd(aLinha,{"D1_QUANT",SD2->D2_QUANT,Nil})
									aadd(aLinha,{"D1_VUNIT",SD2->D2_PRCVEN,Nil})
									aadd(aLinha,{"D1_TOTAL",SD2->D2_TOTAL,Nil})
									//-- Pesquisa armazem destino
									nPosLsocal := Ascan(aDadosAux,{|x| x[1]+x[2] == SD2->D2_PEDIDO+SD2->D2_ITEMPV})
									If nPosLocal > 0
										aadd(aLinha,{"D1_LOCAL"	,aDadosAux[nPosLocal,3]	,Nil})
										//u_AAFVNX01(cLogName,"Adicionando ao aLinha " + aDadosAux[nPosLocal,3] )
									Else
										aadd(aLinha,{"D1_LOCAL"	,aDadosTransf[ni-1,7]	,Nil})
										//u_AAFVNX01(cLogName,"Adicionando ao aLinha " + aDadosTransf[ni-1,7] )
									EndIf

									aadd(aLinha,{"D1_GRADE",cGrade,Nil})
									aadd(aLinha,{"D1_ITEMGRD",If(cGrade=="S",Strzero(nItGrd,2)," "),Nil})
									// Checa geracao de documento
									If aParam310[14] == 2
										aadd(aLinha,{"D1_TES",aParam310[15],Nil})
										// Checa se utiliza rastreabilidade
										cFilBkp := cFilAnt
										cFilant:=aDadosTransf[ni-1,6]
										If Rastro(SD2->D2_COD,"L")
											aadd(aLinha,{"D1_LOTECTL",SD2->D2_LOTECTL,Nil})
											aadd(aLinha,{"D1_DTVALID",SD2->D2_DTVALID,Nil})
										EndIf
										If Rastro(SD2->D2_COD,"S")
											aadd(aLinha,{"D1_NUMLOTE",SD2->D2_NUMLOTE,Nil})
											aadd(aLinha,{"D1_DTVALID",SD2->D2_DTVALID,Nil})
										EndIf
										cFilAnt := cFilBkp
									EndIf
									aadd(aItens,aLinha)

									dbSelectArea("SD2")
									dbSkip()
								End
								// Caso tenha itens e cabecalho definidos
								If Len(aItens) > 0 .And. Len(aCabec) > 0
									// Atualiza para a filial destino
									cFilant:=aDadosTransf[ni-1,6]
									// Reinicializa ambiente para o fiscal
									If MaFisFound()
										MaFisEnd()
									EndIf
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Ponto de entrada para ALTERAR os dados do pedido de vendas   ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If lExecItens
										aBackItens:=ACLONE(aItens)
										aItens:=ExecBlock("M310ITENS",.F.,.F.,{If(aParam310[14] == 1,"MATA140","MATA103"),aItens})
										If ValType(aItens) # "A"
											aItens:=ACLONE(aBackItens)
										EndIf
									EndIf

									// Atribui o módulo 4 (Estoque) para não ocorrer erro nas rotinas abaixo
									nAux := nModulo
									nModulo := 4

									// Checa geracao de documento

									If aParam310[14] == 2
										//u_AAFVNX01(cLogName,"Incluindo NF de Entrada")
										// Inclui nota de entrada
										MATA103(aCabec,aItens,3)
									Else
										//u_AAFVNX01(cLogName,"Incluindo Pre Nota de Entrada")
										// Inclui pre-nota
										MATA140(aCabec,aItens,3)
									EndIf

									// Volta o módulo 4 (Estoque) após a gravação da nota de entrada
									nModulo := nAux

									// Checa erro de rotina automatica
									If lMsErroAuto
										lMostraErro	:=.T.
									EndIf
									// Atualiza para a filial origem
									cFilant:=aDadosTransf[ni-1,1]
								EndIf
							EndIf
						Next nx
					EndIf
				EndIf
			Else
				// A filial XX nao teve uma serie de nota fiscal de saida selecionada para geracao
				Help(" ",1,"A310SERERR",,cFilAnt,1,10)
				// Variavel para processamento
				cWhile:=aDadosTransf[ni,1]
				// Varre todos os itens com esta filial origem
				While (ni <= Len(aDadosTransf)) .And. aDadosTransf[ni,1] == cWhile
					// Incrementa regua de processamento
					IncProc()
					ni++
				End
			EndIf
		End
	EndIf
	// Restaura filial original
	cFilAnt:=cFilOri
	// Mostra erro em rotina automatica
	If lMostraErro
		Mostraerro()
	EndIf
RETURN

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATP01Stok ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 28/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de consulta do saldo em estoque                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FATP01Stok()
	Local cProduto, cLocal, oEstoque
	Local nSaldo := 0

	// Caso algum campo de pesquisa do saldo esteja vazio
	If Empty(aCols[n,nPFOri]) .Or. Empty(aCols[n,nPPrd]) .Or. Empty(aCols[n,nPLOri])
		Return
	Endif

	// Desabilita a tecla de atalho
	SetKey( VK_F7 , {|| Nil })

	If !Empty(aCols[n,nPPrd])
		cProduto := aCols[n,nPPrd]
		cLocal   := aCols[n,nPLOri]

		SB1->(dbSetOrder(1))
		SB1->(dbSeek(XFILIAL("SB1")+cProduto))
		SB0->(dbSetOrder(1))
		SB0->(dbSeek(XFILIAL("SB0")+cProduto))
		SB9->(dbSetOrder(1))
		SB9->(dbSeek(aCols[n,nPFOri]+cProduto+cLocal))

		SB2->(dbSetOrder(1))
		SB2->(dbSeek(aCols[n,nPFOri]+cProduto+cLocal))

		nSaldo := SB2->(B2_QATU - If( B2_RESERVA > 0, B2_RESERVA, 0))
		nSaldo := If( nSaldo < 0 , 0, nSaldo)

		DEFINE MSDIALOG oEstoque FROM 10,16 TO 29,73 TITLE "Consulta Estoque - Filial "+aCols[n,nPFOri];
		STYLE nOr(DS_MODALFRAME, WS_DLGFRAME) OF oMainWnd

		@  8,2 TO  43,187 OF oEstoque PIXEL
		@ 51,2 TO  70,187 OF oEstoque PIXEL
		@ 76,2 TO 135,187 OF oEstoque PIXEL

		@  4,  2 SAY   "Dados do Produto" SIZE  56, 7 OF oEstoque PIXEL
		@ 16,  4 SAY   "Código"           SIZE  21, 7 OF oEstoque PIXEL
		@ 15, 26 MSGET SB1->B1_COD        SIZE  49, 9 OF oEstoque PIXEL WHEN .F.
		@ 16, 83 SAY   "Unidade"          SIZE  25, 7 OF oEstoque PIXEL
		@ 15,110 MSGET SB1->B1_UM         SIZE  14, 9 OF oEstoque PIXEL WHEN .F.
		@ 16,137 SAY   "Grupo"            SIZE  18, 7 OF oEstoque PIXEL
		@ 15,158 MSGET SB1->B1_GRUPO      SIZE  14, 9 OF oEstoque PIXEL WHEN .F.
		@ 30,  4 SAY   "Descrição"        SIZE  32, 7 OF oEstoque PIXEL
		@ 29, 36 MSGET SB1->B1_DESC       SIZE 130, 9 OF oEstoque PIXEL WHEN .F.

		@ 40,335 TO 40,335 OF oEstoque PIXEL
		@ 46,  3 SAY "Estoque - Armazém "+cLocal

		// Saldos
		@ 57,  4 SAY "Inicial" SIZE 21, 7 OF oEstoque PIXEL
		@ 56, 25 MSGET SB9->B9_QINI Picture PesqPict("SB9","B9_QINI") SIZE 49, 9 OF oEstoque PIXEL WHEN .F.
		@ 57, 89 SAY "Atual"   SIZE 18, 7 OF oEstoque PIXEL
		@ 56,107 MSGET nSaldo       Picture PesqPict("SB2","B2_QATU") SIZE 49, 9 OF oEstoque PIXEL WHEN .F.

		// Preços
		@  71, 3 SAY "Preços de Venda:" SIZE 53, 7 OF oEstoque PIXEL
		@  82, 6 SAY "1-"               SIZE 11, 7 OF oEstoque PIXEL
		@  93, 6 SAY "2-"               SIZE 11, 7 OF oEstoque PIXEL
		@ 103, 6 SAY "3-"               SIZE 11, 7 OF oEstoque PIXEL
		@ 122, 6 SAY "5-"               SIZE 11, 7 OF oEstoque PIXEL
		@  83,93 SAY "6-"               SIZE 11, 7 OF oEstoque PIXEL
		@ 103,93 SAY "8-"               SIZE 11, 7 OF oEstoque PIXEL
		@  93,93 SAY "7-"               SIZE 11, 7 OF oEstoque PIXEL
		@ 112,93 SAY "9-"               SIZE 11, 7 OF oEstoque PIXEL
		@ 112, 6 SAY "4-"               SIZE 11, 7 OF oEstoque PIXEL

		@  82, 18 MSGET SB0->B0_PRV1 Picture PesqPict("SB0","B0_PRV1") SIZE 49,9 OF oEstoque PIXEL WHEN .F.
		@  91, 18 MSGET SB0->B0_PRV2 Picture PesqPict("SB0","B0_PRV2") SIZE 49,9 OF oEstoque PIXEL WHEN .F.
		@ 101, 18 MSGET SB0->B0_PRV3 Picture PesqPict("SB0","B0_PRV3") SIZE 49,9 OF oEstoque PIXEL WHEN .F.
		@ 111, 18 MSGET SB0->B0_PRV4 Picture PesqPict("SB0","B0_PRV4") SIZE 49,9 OF oEstoque PIXEL WHEN .F.
		@ 121, 18 MSGET SB0->B0_PRV5 Picture PesqPict("SB0","B0_PRV5") SIZE 49,9 OF oEstoque PIXEL WHEN .F.
		@  82,106 MSGET SB0->B0_PRV6 Picture PesqPict("SB0","B0_PRV6") SIZE 49,9 OF oEstoque PIXEL WHEN .F.
		@  91,106 MSGET SB0->B0_PRV7 Picture PesqPict("SB0","B0_PRV7") SIZE 49,9 OF oEstoque PIXEL WHEN .F.
		@ 101,106 MSGET SB0->B0_PRV8 Picture PesqPict("SB0","B0_PRV8") SIZE 49,9 OF oEstoque PIXEL WHEN .F.
		@ 111,106 MSGET SB0->B0_PRV9 Picture PesqPict("SB0","B0_PRV9") SIZE 49,9 OF oEstoque PIXEL WHEN .F.

		DEFINE SBUTTON FROM 110,192 TYPE 1 ACTION oEstoque:End() ENABLE OF oEstoque

		ACTIVATE MSDIALOG oEstoque CENTERED
	Else
		Aviso("Atenção","Selecione um produto na tela de solicitação e então chame essa rotina novamente.",;
		{"OK"})
	Endif

	SetKey( VK_F7 , {|| u_FATP01Stok() })
Return

Static Function GetFUndel( aCols )
	_nLin := 1
	lContinua := .T.
	While _nLin != Len(aCols) .And. aCols[_nLin][nPDel]
		_nLin++
	EndDo
Return iIf(aCols[_nLin][nPDel],0,_nLin)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+---------------------------------------------------------------------------+¦¦
¦¦¦                      ROTINAS REFERENTES AO FACILITADOR                    ¦¦¦
¦¦+---------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function FATP01Facil()
	//Local cQry, nTotal, nSalTra, nSalOri, nSalDes, nEstSeg, nFalta, aSM0, cEmp, x, y, aAlm, cFilPrd, cCodPrd, cLocPad, cEspeci
	Local cQry, nTotal, nSalDes, nEstSeg, nFalta, x, y, aAlm, cFilPrd, cCodPrd, cLocPad, cEspeci
//	Local cFilSB2 := SB2->(XFILIAL("SB2"))
//	Local cFilAux := cFilAnt
	Local aAlmox  := {}

	Private aOrigem

	aCols := {}  // Limpa a variável os itens

	cQry := "SELECT ISNULL(COUNT(*),0) AS Z7_COUNT"
	cQry +=  " FROM "      + RetSQLName("SZ7") + " SZ7 "

	cQry += " INNER JOIN " + RetSQLName("SB2") + " SB2 "
	cQry +=    " ON SB2.D_E_L_E_T_ = ' ' AND SZ7.Z7_FILORIG = SB2.B2_FILIAL AND SZ7.Z7_PRODUTO = SB2.B2_COD"
	cQry +=   " AND SZ7.Z7_LOCAL = SB2.B2_LOCAL"

	cQry += " INNER JOIN "+RetSQLName("SB1")+" SB1 ON SB1.D_E_L_E_T_ = ' '"
	cQry +=   " AND SB1.B1_FILIAL = '"+SB1->(XFILIAL("SB1"))+"'"
	cQry +=   " AND SZ7.Z7_PRODUTO = SB1.B1_COD"

	cQry += " WHERE SZ7.D_E_L_E_T_ = ' '
	cQry += "   AND (SB2.B2_QATU - SB2.B2_RESERVA) < SZ7.Z7_ESTSEG "
	cQry += "   AND SB2.B2_LOCAL <> '13' "

	cQry +=   " AND SZ7.Z7_FILORIG = '"+aFils[2]+"'"  // VERIFICAR
	//cQry += "   AND SZ7.Z7_PRODUTO = '02000011'"

	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TMP", .T., .T. )
	nTotal := Z7_COUNT
	dbCloseArea()

	cQry := StrTran(cQry,"ISNULL(COUNT(*),0) AS Z7_COUNT",;
	"SB2.B2_FILIAL, SZ7.Z7_FILORIG, SZ7.Z7_LOCAL, SB2.B2_COD, SB1.B1_ESPECIF, SB2.B2_LOCAL, SB1.B1_LOCPAD, SZ7.Z7_ESTSEG, Z7_PERC")
	cQry += " ORDER BY SB2.B2_FILIAL, SB2.B2_COD, SB2.B2_LOCAL"

	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TMP", .T., .T. )
	ProcRegua(nTotal)

	xyLOCALIZ:= GETMV("MV_LOCALIZ")
	xyZLOCALI:= GETMV("MV_XLOCALI")
	While !Eof()
		aAlm    := {}
		cFilPrd := B2_FILIAL
		cCodPrd := B2_COD
		cLocPad := B1_LOCPAD
		cEspeci := B1_ESPECIF
		While !Eof() .And. cFilPrd+cCodPrd == B2_FILIAL+B2_COD
			IncProc()

			// Calcula o saldo de destino
			nSalDes := SaldoAtu(B2_FILIAL,B2_COD,B2_LOCAL,.F.)
			nEstSeg := EstSeg(B2_FILIAL,B2_COD,B2_LOCAL)

			// Adiciona os itens que tiverem o saldo destino abaixo do estoque de segurança
			If nSalDes < nEstSeg
				AAdd( aAlm , { B2_LOCAL, nSalDes, nEstSeg, Transito(B2_FILIAL,B2_COD,B2_LOCAL)} )
			Endif

			dbSkip()
		Enddo

		If Empty(aAlm)   // Caso não tenha encontrado pendências
			Loop
		Endif

		aOrigem := {}    // Origens dos saldos em estoque para o produto

		// Pesquisa o saldo do almoxarifado padrão
		If cFilPrd == aFils[1] .Or. cFilPrd == aFils[2]
			SaldoMem(cFilPrd,cCodPrd,cLocPad)
		EndIf
		// Pesquisa o saldo em outros almoxarifados da filial
		SaldoFil(cFilPrd,cCodPrd,cLocPad)

		// Pesquisa o saldo disponível em outras filiais
		/*aSM0 := { SM0->(IndexOrd()), SM0->(Recno())}  // Salva as configurações da tabela SM0
		cEmp := SM0->M0_CODIGO

		SM0->(dbSetOrder(1))
		SM0->(dbGoTop())
		SM0->(dbSeek(cEmp,.T.))
		While !SM0->(Eof()) .And. SM0->M0_CODIGO == cEmp
		If SM0->M0_CODFIL <> cFilPrd // Não processa filial destino
		// Pesquisa o saldo em outros almoxarifados da filial
		SaldoFil(SM0->M0_CODFIL,cCodPrd,"XX")
		Endif
		SM0->(dbSkip())
		Enddo

		// Restaura configurações
		SM0->(dbSetOrder(aSM0[1]))
		SM0->(dbGoTo(aSM0[2]))*/
		For x:=0 To 3
			If StrZero(x,2) <> cFilPrd // Não processa filial destino
				// Pesquisa o saldo em outros almoxarifados da filial
				SaldoFil(StrZero(x,2),cCodPrd,"XX")
			Endif
		Next

		For x:=1 To Len(aAlm)

			nSalDes := aAlm[x,2]
			nEstSeg := aAlm[x,3]
			nFalta  := nEstSeg - nSalDes    // Saldo faltante de composição do estoque destino

			If aAlm[x,4] > 0   // Caso tenha encontrado saldo em trânsito
				// DEMONSTRA NA TELA DE SUGESTÃO
				AAdd( aAlmox , { cFilPrd, cCodPrd, aAlm[x,1], nEstSeg, nSalDes, nFalta, aAlm[x,4], "SALDO EM TRANSITO"})   // Adiciona ao vetor para demonstração
				nFalta -= aAlm[x,4]    // Subtrai o saldo em trânsito
			Endif

			If nFalta > 0   // Caso ainda tenha saldo faltante
				// Pesquisa as origens para o produto
				For y:=1 To Len(aOrigem)
					If aOrigem[y,3] > 0 .And. nFalta > 0  // Caso tenha saldo
						nTransf := If( aOrigem[y,3] >= nFalta , nFalta, aOrigem[y,3])  // Calcula quanto pode transferir

						If aOrigem[y,1] == cFilPrd   // Se for a mesma filial do destino
							// Adiciona ao vetor para demonstração
							//AAdd( aAlmox , { aOrigem[y,1], cCodPrd, aOrigem[y,2], aOrigem[y,4], aOrigem[y,3]+aOrigem[y,4], aOrigem[y,3], nTransf, "TRANSFERIR PARA O ALMOXARIFADO "+aAlm[x,1]})
							AAdd( aAlmox , { cFilPrd, cCodPrd, aAlm[x,1], nEstSeg, nSalDes, If(nEstSeg>nSalDes,nEstSeg-nSalDes,0), nTransf, "TRANSFERIR DO ALMOXARIFADO "+aOrigem[y,2]})
						Else
							// DEMONSTRA NA TELA DE TRANSFERÊNCIA
							AAdd( aCols , Array(Len(aHeader)+1) )
							nTam := Len(aCols)
							aCols[nTam,1] := cCodPrd
							aCols[nTam,2] := cEspeci
							aCols[nTam,3] := aOrigem[y,1]
							aCols[nTam,4] := aOrigem[y,2]
							aCols[nTam,5] := aFils[2]
							aCols[nTam,6] := aAlm[x,1]
							aCols[nTam,7] := nTransf
							aCols[nTam,8] := aOrigem[y,3]   // <-- Informar na tela o saldo de origem ou destino?
							aCols[nTam,9] := .F.
						Endif
						nFalta -= nTransf         // Abate a quantidade a transferir
						aOrigem[y,3] -= nTransf   // Abate o saldo usado para transferir
					Endif
				Next
			Endif

			// Se após todas as verificações ainda faltar saldo, ou seja a filial seja diferente da destino, e caso seja igual se o almoxarifado
			// seja diferente do padrão
			If nFalta > 0 .And. (cFilPrd <> aFils[2] .Or. cLocPad <> aAlm[x,1])
				AAdd( aAlmox , { cFilPrd, cCodPrd, cLocPad, nEstSeg, nSalDes, If(nEstSeg>nSalDes,nEstSeg-nSalDes,0), nSalDes, "SEM SALDO SUFICIENTE"})   // Adiciona ao vetor para demonstração
			Endif
		Next

	Enddo
	dbCloseArea()

	If Empty(aCols)  // Caso nao tenha itens na transferência
		//+--------------
		//| Monta o aCols com uma linha em branco
		//+--------------
		aColsBlank(@aCols,Len(aHeader))
	Endif

	oGet:Refresh()   // Atualiza a tela de transferência

	// Caso tenha encontrado itens aptos a ajustes para atender a transferência
	If !Empty(aAlmox)
		// Ordena o vetor por Filial + Produto + Almoxarifado
		ASort( aAlmox ,,, {|x,y| x[1]+x[2]+x[3] < y[1]+y[2]+y[3] })
		Sugestao(aAlmox)
	Endif
Return

Static Function SaldoFil(cCodFil,cProduto,cLocal)
//	Local nSaldo

	// Pesquisa o saldo em outros almoxarifados
	SB2->(dbSetOrder(1))
	SB2->(dbSeek(cCodFil+cProduto,.T.))
	While !SB2->(Eof()) .And. SB2->(B2_FILIAL+B2_COD) == cCodFil+cProduto
		// Ignora o padrão pois já foi calculado o saldo do mesmo
		If ( SB2->B2_LOCAL <> cLocal ) .And. ( cCodFil == aFils[1] .Or. cCodFil == aFils[2] )
			// Calcula o saldo para o almoxarifado
			SaldoMem(SB2->B2_FILIAL,SB2->B2_COD,SB2->B2_LOCAL)
		Endif
		SB2->(dbSkip())
	Enddo

Return

Static Function SaldoAtu(cCodFil,cProduto,cLocal,lEstSeg)
	Local nRet   := 0
	Local cFil   := cFilAnt
	Local cAlias := Alias()

	cFilAnt := cCodFil    // Posiciona na filial destino

	// Posiciona no Saldo em Estoque
	SB2->(dbSetOrder(1))
	If SB2->(dbSeek(cCodFil+cProduto+cLocal))
		nRet := SB2->B2_QATU
		nRet -= If( SB2->B2_RESERVA > 0 , SB2->B2_RESERVA, 0)  // Abate o Saldo em Reserva
	Endif

	// Se considera o estoque de segurança
	If lEstSeg == Nil .Or. lEstSeg
		nRet -= EstSeg(cCodFil,cProduto,cLocal)  // Abate o Estoque de Segurança
	Endif

	cFilAnt := cFil   // Restaura filial original

	If nRet < 0  // Zera caso esteja negativo
		nRet := 0
	Endif

	dbSelectArea(cAlias)

Return nRet

Static Function EstSeg(cCodFil,cProduto,cLocal)
	Local nRet := 0

	SZ7->(dbSetOrder(1))
	// verificar wermeson                                  
	If SZ7->(dbSeek(XFILIAL("SZ7")+cCodFil+Padr(Alltrim(cProduto), Len(SZ7->Z7_PRODUTO) )+cLocal))
		nRet := Round(SZ7->Z7_ESTSEG * (1 + (SZ7->Z7_PERC / 100)),0)
	Endif

Return nRet

Static Function SaldoMem(cCodFil,cProd,cLocal,nAbate)
	Local nQtd, nSeg
	Local nPos := AScan( aOrigem , {|y| y[1]+y[2] == cCodFil+cLocal })

	If nPos == 0
		nQtd := SaldoAtu(cCodFil,cProd,cLocal,.F.)
		nSeg := EstSeg(cCodFil,cProd,cLocal)

		AAdd( aOrigem , { cCodFil, cLocal, nQtd - nSeg, nSeg})
		nPos := Len(aOrigem)
	Endif

	If nAbate <> Nil .And. aOrigem[nPos,3] >= nAbate   // Abate a quantidade encontrada
		aOrigem[nPos,3] -= nAbate
	Endif

Return nPos

Static Function Transito(cCodFil,cProduto,cLocal)
	Local cQry
	Local cAlias := Alias()
	Local nRet   := 0

	cQry := "SELECT ISNULL(SUM(D1_QUANT),0) AS D1_QUANT"
	cQry += " FROM "+RetSQLName("SD1")+" SD1"
	cQry += " WHERE SD1.D_E_L_E_T_ = ' ' AND SD1.D1_FILIAL = '"+cCodFil+"'"
	cQry += " AND SD1.D1_COD = '"+cProduto+"'"
	//cQry += " AND SD1.D1_LOCAL = '"+cLocal+"'"
	cQry += " AND SD1.D1_TES = ' ' AND SD1.D1_QUANT > 0"

	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TMPSD1", .T., .T. )
	nRet := D1_QUANT
	dbCloseArea()
	dbSelectArea(cAlias)

Return nRet

Static Function Sugestao(aAlmox)
	Local cVar := Nil
	Local oDlg := Nil
	Local oLbx := Nil

	DEFINE MSDIALOG oDlg TITLE "Saldos em outras Origens" From 8,0 To 30,120 //OF oMainWd

	@ 015,005 LISTBOX oLbx VAR cVar FIELDS HEADER "Filial", "Produto", "Almox", "Est.Seg.", "Saldo", "Falta", "Transf.", "Observação" SIZE 450,135 OF oDlg PIXEL

	oLbx:SetArray( aAlmox )
	oLbx:bLine := {|| {  aAlmox[oLbx:nAt,1],;
	aAlmox[oLbx:nAt,2],;
	aAlmox[oLbx:nAt,3],;
	aAlmox[oLbx:nAt,4],;
	aAlmox[oLbx:nAt,5],;
	aAlmox[oLbx:nAt,6],;
	aAlmox[oLbx:nAt,7],;
	aAlmox[oLbx:nAt,8]}}

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oDlg:End() },{||oDlg:End()}) CENTERED

Return


/*________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+----------------------+¦¦
¦¦¦ Programa  ¦ telaPed    ¦ Autor ¦ Arlindo Neto         ¦ Data ¦ 14/06/2012           ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+----------------------+¦¦
¦¦¦ Descriçäo ¦ Função para Montar a tela do pedidos em aberto na filial de destino     ¦¦¦
¦¦+-----------+-------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function TelaPed()
	Local oDlgACE, oLbx1, oPesquisa
	Local oOk  := LoadBitmap( GetResources(), "LBOK" )
	Local oNo  := LoadBitmap( GetResources(), "LBNO" )
	Local nOpc := 0
	Local _cPesquisa  := Space(40)

	aAdd( __aPedRes , { .F. , "", "", {}} )

	DEFINE MSDIALOG oDlgACE FROM 30,003 TO 260,600 TITLE "Pedidos Filial: "+aFils[1] PIXEL

	@ 85,15 SAY "Pesquisar : " SIZE 35,8 PIXEL OF oDlgACE

	@ 85,50 MSGET oPesquisa  VAR _cPesquisa PICTURE "@!" Size 220,10 Pixel of oDlgACE VALID Pesquisa(_cPesquisa,@oLbx1)

	@ 03,10 LISTBOX oLbx1 VAR nPosLbx FIELDS HEADER " ",;
	"Pedido",;
	"Cliente",;
	SIZE 283,80 OF oDlgACE PIXEL ON dblClick(__aPedRes[oLbx1:nAt][1]:=!__aPedRes[oLbx1:nAt][1], oLbx1:Refresh())

	oLbx1:SetArray(__aPedRes)
	oLbx1:bLine := {|| {;
	IIF(__aPedRes[oLbx1:nAt,1],oOk,oNo),;
	__aPedRes[oLbx1:nAt,2],;
	__aPedRes[oLbx1:nAt,3] }}

	DEFINE SBUTTON FROM 100,142 TYPE 1 ENABLE OF oDlgACE ACTION (nOpc:= 1, oDlgACE:End())

	ACTIVATE MSDIALOG oDlgACE CENTERED

Return (nOpc == 1)

//
Static Function Pesquisa(_cPesquisa,oLbx1)
	Local cQry
	Local cAlias := Alias()

	If Empty(_cPesquisa)
		Return
	Endif

	aDel(__aPedRes,Len(__aPedRes))
	aSize(__aPedRes,0)

	cQry := " SELECT  SC6.C6_NUM,SA1.A1_NOME, C5_XFILRES "
	cQry += "     FROM "+RetSQLName("SC6")+" SC6 "
	cQry += " INNER JOIN "+RetSQLName("SC5")+" SC5 ON SC6.C6_NUM = SC5.C5_NUM AND SC5.D_E_L_E_T_='' "
	cQry += " INNER JOIN "+RetSQLName("SA1")+" SA1 ON SA1.A1_COD = SC5.C5_CLIENT AND SA1.D_E_L_E_T_='' "
	cQry += " WHERE SC6.D_E_L_E_T_ = ' ' "
	cQry += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT "
	cQry += "   AND SC6.C6_FILIAL = '"+aFils[2]+"' "
	cQry += "   AND SC5.C5_CLIENT = '"+ALLTRIM(_cPesquisa)+"' "
	//	cQry += "   AND SC6.C6_LOCAL = '"+cAlmCont+"'"
	cQry += " AND SC6.C6_LOCAL In " + FormatIn(cAlmCont , '/') + ""
	//cQry += "   AND SC6.C6_LOCAL In('10','22','25')"
	cQry += " GROUP BY SC6.C6_NUM,SA1.A1_NOME, C5_XFILRES ORDER BY SC6.C6_NUM "

	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TKT", .T., .F. )

	While !Eof()
		Aadd(__aPedRes,{ .F., C6_NUM, A1_NOME, {}, C5_XFILRES })
		DbSkip()
	Enddo
	DbCloseArea()
	dbSelectArea(cAlias)

	If Empty(__aPedRes)
		aAdd( __aPedRes , { .F. , "", "", {}} )
		MsgAlert("Não existe dados para seleção!!!",OemToAnsi("ATENCAO")  )
	EndIf

	// Ordena o vetor por: Nome + Pedido
	ASort( __aPedRes,,,{|x,y| x[3]+x[2] < y[3]+y[2] })
	oLbx1:Refresh()

Return

Static Function prenAcols()
	Local nX, nSaldo, nQtdVen

	SC6->(DbSetOrder(1))

	aCols := {}
	xyLocaliz:= GETMV("MV_LOCALIZ")
	zLocali:= SuperGetMv("MV_XLOCALI",.T.)
	For nX:=1 to Len(__aPedRes)

		If !__aPedRes[nX,1]  // Se o item não foi marcado
			Loop
		Endif

		// Filtra os itens do pedido marcado
		SC6->(DbSeek(aFils[2]+__aPedRes[nX,2],.T.))
		//tratativa Code Analysis - Kodigos - 14/07/2023

		While !SC6->(Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM == aFils[2]+__aPedRes[nX,2]
			
			/*If SC9->(dbSeek(xFilial('SC9') + SC5->C5_NUM ))
    			While !SC9->(Eof()) .And. SC9->C9_FILIAL + SC9->C9_PEDIDO == SC5->C5_FILIAL + SC5->C5_NUM
            		SC9->(RecLock('SC9',.F.))
			    		SC9->C9_BLCRED := ""
                		SC9->C9_BLEST  := ""
					SC9->(MsUnlock())
        			SC9->(dbSkip())
    			End 

			EndIf */  
			
			nSaldo  := SaldoAtual(aFils[1],SC6->C6_PRODUTO, if( Alltrim(FWCodEmp()) + AllTrim(aFils[1]) == "0602","41" ,If(__aPedRes[nX,5] == "02","25", aFils[2])) )
			nQtdVen := SC6->C6_QTDVEN - SC6->C6_QTDENT

			// Preenche os itens a transferir
			//msgstop(Alltrim(FWCodEmp()) + AllTrim(aFils[1]) )
			aAdd( aCols , {SC6->C6_PRODUTO,;
			Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_ESPECIF"),;
			aFils[1],;
			if( Alltrim(FWCodEmp()) + AllTrim(aFils[1]) == "0602","41" ,If(__aPedRes[nX,5] == "02","25", aFils[2])),;
			aFils[2],;				
			SC6->C6_LOCAL,;
			nQtdVen,;
			nSaldo,;
			"",;
			"",;
			"",;
			nQtdVen >= nSaldo})

			n := Len(aCols)
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial('SB1') + SC6->C6_PRODUTO))

			lRet := .T.
			// Checa se o endereço do Produto esta habilitado
			If lRet .And. nPosEnd > 0 .And. SB1->B1_LOCALIZ == "S" .And. xyLocaliz == "S"
				iF zLocali
					aCols[n][nPosEnd] := Alltrim(zLocali)//_xdGetLocaliz(aCols[n,nPFOri],aCols[n,nPPrd],M->C9_LOCAL,_xdLote[01])
				Else
					lRet := .F.
					Alert("Endereço Padrão não Informado no Parametro! MV_XLOCALI")
				EndIF
			EndIf

			If lRet .And. nPosLote > 0 .And. Rastro(aCols[n,nPPrd],"L")
				// Checa se Tem Endereço para Retornar o Saldo do Endereco, Ou não caso so Exista Lote 
				If SB1->B1_LOCALIZ == "S" .And. xyLocaliz == "S"
					_xdLote := _xdGetLote(aCols[n,nPFOri],aCols[n,nPPrd],aCols[n][nPLOri], aCols[n][nPosEnd] )
				Else
					_xdLote := _xdGetLote(aCols[n,nPFOri],aCols[n,nPPrd],aCols[n][nPLOri], "" )
				EndIf

				If Len(_xdLote) > 0
					aCols[n][nPosLote] := _xdLote[01]
					aCols[n][nPosDtLo] := _xdLote[02]
					aCols[n][nPSdo]    := _xdLote[03]
				Else
					lRet := .F.
				EndIf
			ElseIf nPosEnd > 0 .And. SB1->B1_LOCALIZ == "S" .And. xyLocaliz == "S" // Não Tem Lote, Mas tem Endereco
				aCols[n][nPSdo]  := _xdGetLocaliz(aCols[n,nPFOri],aCols[n,nPPrd],aCols[n][nPLOri], aCols[n][nPosEnd] )
			EndIf
			// Adiciona os itens dos pedidos no vetor de pedidos selecionados
			AAdd( __aPedRes[nX,4] , { SC6->C6_FILIAL, SC6->C6_ITEM, SC6->C6_PRODUTO, nQtdVen, 0})

			SC6->(DbSkip())
		EndDo
	Next
Return

Static Function SaldoAtual(cCodFil,cProduto,cLocal)
	Local nRet := 0

	SB2->(dbSetOrder(1))
	If SB2->(dbSeek(cCodFil+cProduto+cLocal))
		// Pega o saldo atual em estoque
		nRet := SB2->(B2_QATU - If( B2_RESERVA > 0 , B2_RESERVA, 0))
	Endif

Return nRet

User Function FATP01Ped()
Return __aPedRes


User Function FATP10PED(oGet)

	Local _cdPedido := Space(TamSx3("C5_NUM")[01])
	Local _ndOpc := 2
	Local oPedido := Nil
	Local nI := 0

	If Len(aCols) > 1 .And. Len(rTrim(aCols[01][nPPrd])) > 0
		Aviso('Atenção','Pedido Não Será Importado, pois ja Existem Itens na Transferência' + Chr(13) + Chr(10) + ;
		'Caso Deseje Incluir Novos Itens ao Pedido Primeiro Importe o Pedido depois Inclua Itens'+ Chr(13) + Chr(10) + ;
		'Ou Altere o Pedido e em Seguinte Importe Novamente',{'OK'})
		Return ""
	EndIf

	DEFINE FONT oFnt3 NAME "MS Sans Serif" SIZE 0, -9 BOLD
	DEFINE MSDIALOG oPedido TITLE "Pesquisa Pedido de Venda" From 0,0 TO 10,40 OF oMainWnd

	@005 + 05, 15 Say "Pedido : "  Size 35,8 Of oPedido Pixel Font oFnt3
	@005 + 05, 50 MSGET oPed Var _cdPedido Picture "@!" F3 "SC5TRA" Valid EXISTCPO("SC5",_cdPedido) Size 100,10 Pixel of oPedido

	DEFINE SBUTTON FROM 25,40 TYPE 1 ACTION (_ndOpc := 1,oPedido:End()) ENABLE OF oPedido
	DEFINE SBUTTON FROM 25,70 TYPE 2 ACTION (_ndOpc := 0,oPedido:End()) ENABLE OF oPedido

	Activate MsDialog oPedido Centered
	//aFils[01]
	If _ndOpc == 1 .And. Len(Alltrim(_cdPedido)) != 0
		If SC6->(dbSeek(xFilial("SC6") + _cdPedido))
			aCols := {}
			aNewLine(@aCols,Len(aHeader))
			_ldChange := .T.
			While xFilial("SC6") + _cdPedido == SC6->C6_FILIAL + SC6->C6_NUM

				//nPPrd    := 01
				//nPDes    := 02
				//nPFOri   := 03
				//nPLOri   := 04
				//nPFDes   := 05
				//nPLDes   := 06
				//nPVol    := 0//07
				//nPQtd    := 07
				//nPSdo    := 08
				//nPDel    := 09
				IF SC6->C6_QTDVEN - SC6->C6_QTDENT - SC6->C6_QTDEMP > 0
					_nTam := Len(aCols)
					_ndPos := 0
					For nI := 1 to _nTam
						If Len(Alltrim(aCols[nI][nPPrd] )) == 0
							_ndPos := nI
							nI := _nTam + 1
						EndIf
					NEXT
					If _ndPos == 0
						aNewLine(@aCols,Len(aHeader))
						_ndPos := Len(aCols)
					EndIf

					aCols[_ndPos][nPPrd] := SC6->C6_PRODUTO
					n:= _ndPos
					aAdd(_adPed,{ n ,SC6->C6_PRODUTO , SC6->C6_PRCVEN, SC6->C6_QTDVEN - SC6->C6_QTDENT - SC6->C6_QTDEMP , SC6->C6_ITEM,SC6->C6_QTDVEN,SC6->(Recno()) } )
					M->C9_PRODUTO := SC6->C6_PRODUTO
					u_FATP01AA(nPPrd, "M->C9_PRODUTO")

					IF Len(Alltrim(SC6->C6_LOCAL)) != 0
						aCols[_ndPos][nPLORi] := SC6->C6_LOCAL
						M->C9_LOCAL := SC6->C6_LOCAL
						u_FATP01AA(nPLORI, "M->C9_LOCAL" )
					EndIF

					aCols[_ndPos][nPQTD] := SC6->C6_QTDVEN
					M->D3_QUANT := SC6->C6_QTDVEN - SC6->C6_QTDENT - SC6->C6_QTDEMP
					u_FATP01AA(nPQtd, "M->D3_QUANT" )
					If SC6->C6_QTDENT + SC6->C6_QTDEMP != 0
						_ldChange := .F.		           
					EndIF
				EndIf
				SC6->(dbSkip())
			EndDo
			If Len(_adPed) > 0
				SC5->(dbSetOrder(1))
				SC5->(dbSeek(xFilial('SC5') + _cdPedido))

				SA1->(dbSetOrder(1))
				SA1->(dbSeek(xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI))

				_xdPos := aScan(aFiliais,{|x| x[01] == aFils[02] })
				if SA1->A1_CGC != aFiliais[_xdPos][03] .And. !_ldChange
					Aviso('Atenção','Pedido não poderá Ser Utilizado Pois o Mesmo Não se Trata do Cliente Da Filial Destino Já Possui Itens Faturados/Liberados, impedindo a Alteração do mesmo',{'OK'})
					aCols := {}
					aNewLine(@aCols,Len(aHeader))
					n := Len(aCols)
					_cdPedido := ""
				Else
					_ldInclui := .F.	
					_cdPed := _cdPedido
				End

			Else
				Aviso('Atenção','Não é Possivel Utilizar o Pedido pois o Mesmo ja Esta todo Liberado ou Faturado',{'OK'})
			EndIF
		EndIf
	EndIf
	if !_ldInclui
		oGet:nMax := Len(aCols)	
		oGet:refresh()
	Else
		oGet:nMax := 999
	EndIf
Return _cdPedido


User Function FATP01AA(nCol, _cVar )
	Local cVar := iIf(ValType(_cVar) == "U" , Upper(Trim(ReadVar())) ,_cVar)
	Local lRet := .T.

	If cVar == "M->C9_PRODUTO"
		SB1->(dbSetOrder(1))

		If lRet := ExistCpo('SB1',M->C9_PRODUTO)//SB1->(dbSeek( xFilial('SB1') + M->C9_PRODUTO ))
			LimpaCampos(nCol+2)
			aCols[n,nPDes] := PADR(Posicione("SB1",1,XFILIAL("SB1")+M->C9_PRODUTO,"B1_DESC"),TamSX3("B1_DESC")[1])
			aCols[n,npFOri] := aFils[01]
			aCols[n,nPFDes] := aFils[02]
			aCols[n,nPLDes] := Posicione("SB1",1,aFils[02] + M->C9_PRODUTO,"B1_LOCPAD")


		Endif
	ElseIf cVar == "M->LJ_RPCFIL"

		if (nCol == nPFOri .And. &(cVar) != aCols[n][nCol]) .Or. (nCol == nPFDes .And. &(cVar) != aCols[n][nCol])
			Aviso('[ERRO]','Filial Não pode ser Alterada durante a Transferencia',{'Ok'})
			lRet := .F.
		EndIf

	ElseIf cVar == "M->C9_LOCAL"
		If !aCols[n,nPDel]
			If nCol == nPLOri  // Se estiver lendo a origem
				If lRet := (ExistCpo("SB2",aCols[n,nPPrd]+M->C9_LOCAL))
					_cBkp := aCols[n,nPLOri]
					_nBkp := aCols[n,nPQtd]
					aCols[n,nPQtd] := 0
					aCols[n,nPSdo] := SaldoProduto(aCols[n,nPFOri],aCols[n,nPPrd],M->C9_LOCAL)
					aCols[n,nPQtd] := _nBkp
				Endif
			Else
				If lRet := (AScan( aCols , {|x| !x[nPDel] .And. x[nPPrd] == aCols[n,nPPrd] .And.	x[nPFori]+x[nPLOri]+x[nPFDes]+x[nPLDes] == aCols[n,nPFori]+aCols[n,nPLori]+aCols[n,nPFDes]+M->C9_LOCAL }) == 0)
					/*
					if M->C9_LOCAL != '01'
					Alert("Almoxarifado invalido, Somente Almoxarifado 01 Pode receber Produtos !!!")
					lRet := .F.
					Endif
					*/
				Else
					Alert("Essa informação já foi digitada na transferência !")
				Endif
			ENdIF
		EndIF
	ElseIf cVar == "M->D3_QUANT"
		If lRet := Positivo()
			If M->D3_QUANT <= SaldoProduto(aCols[n,nPFOri],aCols[n,nPPrd],aCols[n,nPLOri])
			Elseif getmv("MV_ESTNEG") = 'S'
				Alert("Quantidade é maior que o saldo disponível !")
			Else
				Alert("Não é Premitido Transferencia que deixe o saldo Negativo !")
				lRet := .F.
			Endif
		Endif
	Endif

Return lRet

Static Function _DelPed(_ndPos,_adPed)
    Local nI := 0 
	_ndP := 0
	For nI := 1 To Len(_adPed)
		If _adPed[nI][01] > _ndPos
			_adPed[nI][01] -= 1
		ElseIf _adPed[nI][01] == _ndPos
			_ndP := nI
		EndIF
	Next
	If _ndP > 0
		aDel(_adPed,_ndP)
		aSize(_adPed,Len(_adPed) - 1)
	EndIf
	// Limpa os Campos que define que deve Alterar o Pedido 
	// E Marca para Incluir Um Novo Pedido Pois todos os Itens do Pedido foram Deletados
	if Len(_adPed) == 0
		_ldInclui := .T.
		_cdPed := ""	   
	EndIf
Return _adPed

Static Function aNewLine(aArray,nUsado)
    Local i := 0
	//Local x := 0 
	aAdd(aArray,Array(nUsado+1))
	nUsado := 0

	_nTam := Len(aArray)
	/*
	SX3->(dbSetOrder(2))

	For x:=1 To Len(vCampos)
		If SX3->(dbSeek(vCampos[x]))
			If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
				nUsado++
				aArray[_nTam][nUsado] := CriaVar(Trim(SX3->X3_CAMPO),.T.)
			Endif
		Endif
		aArray[_nTam][nUsado+1] := .F.
	Next
	*/
	//-----------------------------------------------------
	// Tratativa Code Analysis - Kodigos - 14/07/2023
	//-----------------------------------------------------
	For i:=1 to len(vCampos)
   		If cNivel >= GetSX3Cache(vCampos[i],"X3_NIVEL") .And. X3USO(GetSX3Cache(vCampos[i],"X3_USADO")) 
		   	nUsado++
			aArray[_nTam][nUsado] := CriaVar(Trim(GetSX3Cache(vCampos[i],"X3_CAMPO")),.T.)
		ENDIF
		aArray[_nTam][nUsado+1] := .F.
	Next

Return


Static Function _xdGetLote(_xdFilial,_xdProduto,_xdLocal,_xdLocaliz)

	_xdLote  := {}
	_xdOption:= ""
	_xdParm  := ""
	If SuperGetMv("MV_XLOTETR",.T.)
		_xdParm := Alltrim(GetMv("MV_XLOTETR"))
	EndIf

	If SuperGetMv("MV_XOPTLOT",.T.)
		_xdOption := Alltrim(GetMv("MV_XOPTLOT"))
		If !_xdOption$"MAX/MIN/PARM/PARAMETRO "
			Alert(" CONTEUDO DO PARAMETRO 'MV_XOPTLOT' INVALIDO ")
		EndIf
	EndIf

	If _xdOption$"MAX/MIN" .Or. Len(Alltrim(_xdParm)) == 0

		_xdQry   := "" 
		_xdQry   += " Select TOP 1 * From " + RetSqlName("SB8") + " B8 "
		If Len(Alltrim(_xdLocaliz)) > 0
			_xdQry   += "   Inner Join " + RetSqlName("SBF") + " BF ON BF.D_E_L_E_T_ =  ' ' 
			_xdQry   += "      										AND BF_LOTECTL = B8_LOTECTL 
			_xdQry   += " 											AND BF_FILIAL = B8_FILIAL 
			_xdQry   += " 											AND BF_LOCALIZ ='" + _xdLocaliz + "' 
			_xdQry   += " 											And BF_LOCAL = B8_LOCAL  
			_xdQry   += " 											AND BF_PRODUTO = B8_PRODUTO "
		EndIf
		_xdQry   += " Where B8.D_E_L_E_T_ = '' "
		_xdQry   += "  AND B8_DTVALID >= '" + DTOS(dDataBase) + "' "
		_xdQry   += "  And B8_PRODUTO = '" + _xdProduto + "'"
		_xdQry   += "  And B8_LOCAL = '" + _xdLocal + "'"
		_xdQry   += "  And B8_FILIAL = '" + _xdFilial + "'"
		_xdQry   += " Order By B8_DTVALID "  + iIf(_xdOption == "MAX"," DESC "," ASC ")    	    	
	Else    	
		_xdQry   := "" 
		_xdQry   += " Select TOP 1 * From " + RetSqlName("SB8") + " B8 "
		If Len(Alltrim(_xdLocaliz)) > 0
			_xdQry   += "   Inner Join " + RetSqlName("SBF") + " BF ON BF.D_E_L_E_T_ =  ' ' 
			_xdQry   += "      										AND BF_LOTECTL = B8_LOTECTL 
			_xdQry   += " 											AND BF_FILIAL = B8_FILIAL 
			_xdQry   += " 											AND BF_LOCALIZ ='" + _xdLocaliz + "' 
			_xdQry   += " 											And BF_LOCAL = B8_LOCAL  
			_xdQry   += " 											AND BF_PRODUTO = B8_PRODUTO "
		EndIf
		_xdQry   += " Where D_E_L_E_T_ = '' "
		_xdQry   += "  AND B8_DTVALID >= '" + DTOS(dDataBase) + "' "
		_xdQry   += "  And B8_PRODUTO = '" + _xdProduto + "' "
		_xdQry   += "  And B8_LOCAL = '" + _xdLocal + "' "
		_xdQry   += "  And B8_LOTECTL = '" + _xdParm + "'"
		_xdQry   += "  And B8_FILIAL = '" + _xdFilial + "'"
		_xdQry   += " Order By B8_DTVALID "  + iIf(_xdOption == "MAX"," DESC "," ASC ")	
	EndIf    

	_xdAls := MPSysOpenQuery(_xdQry)

	If !(_xdAls)->(EOF())
		aAdd(_xdLote , (_xdAls)->B8_LOTECTL )
		aAdd(_xdLote , STOD( (_xdAls)->B8_DTVALID) )
		If Len(Alltrim(_xdLocaliz)) > 0
			aAdd(_xdLote ,  (_xdAls)->BF_QUANT )
		Else
			aAdd(_xdLote ,  (_xdAls)->B8_SALDO )
		EndIf
	Else
		Alert("Nenhum LOTE Valido Encontrado para esta transferência para o Produto:  " + _xdProduto + " No Armazen " + _xdLocal )
		_xdLote := {}
	EndIf

Return _xdLote

Static Function _xdGetLocaliz(_xdFilial,_xdProduto,_xdLocal,_xdLocaliz)

	_xdLocaliz := {}

	_xdQry := " Select * from " + RetSqlName("SBF") + " BF " 
	_xdQry += "   Where BF.D_E_L_E_T_ = ' ' "
	_xdQry += "     And BF_FILIAL = '" + _xdFilial + "'"
	_xdQry += "     And BF_PRODUTO = '" + _xdProduto + "'"
	_xdQry += "     And BF_LOCAL   = '" + _xdLocal   + "'"
	_xdQry += "     And BF_LOCALIZ = '" + _xdLocaliz + "'"

	_xdAls := MPSysOpenQuery(_xdQry)

	If !(_xdAls)->(EOF())
		_xdLocaliz := (_xdAls)->BF_QUANT 
	Else
		_xdLocaliz := 0
	EndIf
Return _xdLocaliz


Static Function PosObjetos(aSize,aPosObj)
	Local aInfo
	Local aObjects := {}

	// Faz o calculo automatico de dimensoes de objetos     
	aSize := MsAdvSize(.F.,.F.)

	//AAdd( aObjects, { 100 , 083, .T. , .F.} )
	AAdd( aObjects, { 100 , 100, .T. , .T. } )


	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

Return
