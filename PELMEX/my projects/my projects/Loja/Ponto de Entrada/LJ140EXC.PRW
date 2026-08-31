`#Include "Rwmake.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ LJ140EXC   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 29/03/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada de exclusão da nota/cupom no loja            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function LJ140EXC()
	Local cQry, cNumPed
	Local cAlias  := Alias()
	Local cFilAux := cFilAnt
	Local aArrSC5 := {}
	Local aArrSC6 := {}

	
	// Pesquisa o número do pedido de transferência relacionado ao orçamento
	
	cQry := "SELECT C5_FILIAL, C5_NUM"
	cQry += " FROM "+RetSQLName("SC5")
	cQry += " WHERE D_E_L_E_T_ = ' '"
	cQry += " AND C5_XORCRES = '"+SL1->L1_NUM+"'"
	cQry += " AND C5_XFILRES = '"+SL1->L1_FILIAL+"'"

	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "PEDRES", .T., .F. )
	cFilAnt := C5_FILIAL
	cNumPed := C5_NUM
	dbCloseArea()
	dbSelectArea(cAlias)

	// Carrega o cabeçalho do pedido de vend
	SC5->(dbSetOrder(1))
	If SC5->(dbSeek(cFilAnt+cNumPed))
		aArrSC5 := {{ "C5_FILIAL"  , SC5->C5_FILIAL  , Nil}, ;
		{ "C5_NUM"     , SC5->C5_NUM     , Nil}, ;
		{ "C5_TIPO"    , SC5->C5_TIPO    , Nil}, ;
		{ "C5_CLIENTE" , SC5->C5_CLIENTE , Nil}, ;
		{ "C5_LOJACLI" , SC5->C5_LOJACLI , Nil}, ;
		{ "C5_LOJAENT" , SC5->C5_LOJAENT , Nil}, ;
		{ "C5_EMISSAO" , SC5->C5_EMISSAO , Nil}, ;
		{ "C5_CONDPAG" , SC5->C5_CONDPAG , Nil}, ;
		{ "C5_MOEDA"   , SC5->C5_MOEDA   , Nil}, ;
		{ "C5_TIPOCLI" , SC5->C5_TIPO    , Nil}, ;
		{ "C5_VEND1"   , SC5->C5_VEND1   , Nil}}
	Endif

	// Carrega os itens do pedido de venda
	SC6->(dbSetOrder(1))
	SC6->(dbSeek(cFilAnt+cNumPed,.T.))
	While !SC6->(Eof()) .And. cFilAnt+cNumPed == SC6->(C6_FILIAL+C6_NUM)

		aAdd(aArrSC6, {{ "C6_FILIAL"  , SC6->C6_FILIAL      , Nil},;
		{ "C6_NUM"     , SC6->C6_NUM         , Nil},;
		{ "C6_ITEM"    , SC6->C6_ITEM        , Nil},;
		{ "C6_PRODUTO" , SC6->C6_PRODUTO     , Nil},;
		{ "C6_DESCRI"  , SC6->C6_DESCRI      , Nil},;
		{ "C6_QTDVEN"  , SC6->C6_QTDVEN      , Nil},;
		{ "C6_PRUNIT"  , SC6->C6_PRUNIT      , Nil},;
		{ "C6_PRCVEN"  , SC6->C6_PRCVEN      , Nil},;
		{ "C6_VALOR"   , SC6->C6_VALOR       , Nil},;
		{ "C6_ENTREG"  , SC6->C6_ENTREG      , Nil},;
		{ "C6_UM"      , SC6->C6_UM          , Nil},;
		{ "C6_TES"     , SC6->C6_TES         , Nil},;
		{ "C6_CF"      , SC6->C6_CF          , Nil},;
		{ "C6_LOCAL"   , SC6->C6_LOCAL       , Nil},;
		{ "C6_CLI"     , SC6->C6_CLI         , Nil},;
		{ "C6_LOJA"    , SC6->C6_LOJA        , Nil}})

		SC6->(dbSkip())
	Enddo

	// Se tem conteúdo válido para o cabeçalho e itens
	If !Empty(aArrSC5) .And. !Empty(aArrSC6)
		lMsErroAuto := .F.
		lMSHelpAuto := .T.

		// Efetua a exclusão do pedido de venda
		MSExecAuto({|x,y,Z| Mata410(x,y,Z)}, aArrSC5, aArrSC6, 5)

		If lMsErroAuto  // Caso tenha ocorrido erro na rotina padrão
			MostraErro()
		Endif
	Endif

	dbSelectArea(cAlias)
	cFilAnt := cFilAux   // Restaura a filial logada

Return