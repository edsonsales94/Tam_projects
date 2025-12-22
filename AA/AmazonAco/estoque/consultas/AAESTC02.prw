#INCLUDE "Protheus.ch"

/*__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+--------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ AAESTC02   ¦ ADRIANO LIMA             ¦ Data ¦13/03/2012 ¦¦¦
¦¦+-----------+------------+--------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Consulta de Saldo de Transito                            ¦¦¦
¦¦+-----------+----------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAESTC02()
	Local oDlg
	Local oOk      := LoadBitmap(GetResources(), "BR_VERDE" )
	Local oNo      := LoadBitmap(GetResources(), "BR_VERMELHO" )
	Local aButtons := {}
	Local aItems   := {}
	Local cNumDI   := CriaVar("ZW_NUMDI")
	Local cNF      := CriaVar("ZW_DOC")
	Local bAtuItem := {|| MsgRun('Filtrando Dados, Aguarde... ',, {|| FiltraPuxada(@aItems,cNumDI,cNF) }), oLbx:Refresh() }
	
	FiltraPuxada(@aItems)   // Filtra as puxadas
	
	If Empty(aItems)
		Alert("Não foram encontradas informações sobre os saldos")
		Return
	Endif
	
	Aadd( aButtons, { "" , {|| oDlg:End(), , U_fConNFEnt(aItems[oLbx:nAt])  }, "Visualizar"} )
	Aadd( aButtons, { "", {|| U_FSLEG01()},"Legenda","Legenda", {|| .T.}} ) //Adicionado por Matheus Santos
	
	DEFINE MSDIALOG oDlg TITLE "Consulta Puxadas por Produtos"  From 0,0 To 38,154 OF oMainWnd
	
	@ 10, 012 SAY "Consulta ao Saldo de Trânsito" OF oDlg PIXEL SIZE 100,007
	
	@ 10,120 SAY "Número DI"  SIZE 050,7  PIXEL OF oDlg COLOR CLR_HBLUE
	@ 10,150 MSGET oDI VAR cNumDI PICTURE "@!" SIZE 50,10  PIXEL OF oDlg COLOR CLR_HBLUE
	oDI:bLostFocus := bAtuItem

	@ 10,240 SAY "Nota"  SIZE 040,7  PIXEL OF oDlg COLOR CLR_HBLUE
	@ 10,260 MSGET oNF VAR cNF    PICTURE "@!" SIZE 50,10  PIXEL OF oDlg COLOR CLR_HBLUE
	oNF:bLostFocus := bAtuItem
	
	@ 25, 010 LISTBOX oLbx VAR cVar ; //14,01
					FIELDS HEADER " ","Filial","Num PacList","Num NF","Serie NF","Emissão","Quant NF", "Saldo Transito","Cod. Produto",;
					"Fornecedor", "DI", "Codigo", "Loja";
					SIZE 590, 250 OF oDlg PIXEL ON dblClick( U_fConNFEnt(aItems[oLbx:nAt]))
	
	oLbx:SetArray(aItems)
	oLbx:bLine := {||{;
							IIF(aItems[oLbx:nAt,01],oNo,oOk),;
							aItems[oLbx:nAt,10],;
							aItems[oLbx:nAt,02],;
							aItems[oLbx:nAt,03],;
							aItems[oLbx:nAt,04],;
							aItems[oLbx:nAt,11],;
							Transform(aItems[oLbx:nAt,05],'@E 99,999,999,999'),;
							Transform(aItems[oLbx:nAt,06],'@E 999,999,999'),;
							aItems[oLbx:nAt,07],;
							aItems[oLbx:nAt,08],;
							aItems[oLbx:nAt,09],;
							aItems[oLbx:nAt,12],;
							aItems[oLbx:nAt,13]}}
	oLbx:nAt := 1
	oLbx:SetFocus()
	
	ACTIVATE MSDIALOG oDlg 	CENTERED ON INIT EnchoiceBar(oDlg,{|| oDlg:End()} , {|| oDlg:End() },,aButtons)
	
Return

//----------------------------------------------------------------
User Function fConNFEnt(aItem)
//----------------------------------------------------------------
	Local cFilAux := cFilAnt
	Local cAlias  := Alias()
	
	Private aRotina := { {"Pesquisar" ,"AxPesqui"   ,0,1} ,;
								{"Visualizar","A103NFiscal",0,2} }
	
	cFilAnt := aItem[10]   // Define a filial do item selecionado
	
	SF1->(dbSetOrder(1))
	If SF1->(dbSeek(xFilial("SF1")+aItem[03]+aItem[04]+aItem[12]+aItem[13]))
		lWhenGet 	:= .F.
		lEstNfClass := Nil
		
		A103NFiscal("SF1",SF1->(Recno()),2,lWhenGet,lEstNfClass)
	Else
		Alert("A nota selecionada não foi encontrada !")
	Endif
	
	cFilAnt := cFilAux    // Restaura a filial original
	dbSelectArea(cAlias)
Return .T.

//-----------------------------------------------------------------------------
//-					   	  Rotina de Legenda				   -
//-			Desenvolvida por: Matheus da Silva Santos		Data: 23/13/2012  -
//-----------------------------------------------------------------------------
User Function FSLEG01()
	BrwLegenda( "Consulta Saldo de Transito",,;
					{{"BR_VERMELHO", "SEM SALDO EM TRANSITO" },;
					 {"BR_VERDE"   , "COM SALDO EM TRANSITO" }})
Return Nil

Static Function FiltraPuxada(aItems,cNumDI,cNF)
	Local cQry
	Local cAlias := Alias()
	
	SZW->(dbSetOrder(1))

	If !Empty(aItems)
		aDel(aItems,Len(aItems))
		aSize(aItems,0)
	Endif
	
	cQry := "SELECT SA2.A2_NOME, SF1.F1_DTDIGIT, SZW.*"
	cQry += " FROM "+RetSQLName("SZW")+" SZW"
	cQry += " INNER JOIN "+RetSQLName("SF1")+" SF1 ON SF1.D_E_L_E_T_ = ' '"
	cQry += " AND SF1.F1_FILIAL = SZW.ZW_FILIAL"
	cQry += " AND SF1.F1_DOC = SZW.ZW_DOC AND SF1.F1_SERIE = SZW.ZW_SERIE"
	cQry += " AND SF1.F1_FORNECE = SZW.ZW_FORNECE AND SF1.F1_LOJA = SZW.ZW_LOJA"
	cQry += " INNER JOIN "+RetSQLName("SA2")+" SA2 ON SA2.D_E_L_E_T_ = ' '"
	cQry += " AND SA2.A2_COD = SZW.ZW_FORNECE AND SA2.A2_LOJA = SZW.ZW_LOJA"
	cQry += " WHERE SZW.D_E_L_E_T_ = ' '"
	//cQry += " AND SZW.ZW_FILIAL = '"+SZW->(XFILIAL("SZW"))+"'"
	
	If cNumDI <> Nil .And. !Empty(cNumDI)
		cQry += " AND SZW.ZW_NUMDI = '"+cNumDI+"'"
	Endif
	
	If cNF <> Nil .And. !Empty(cNF)
		cQry += " AND SZW.ZW_DOC = '"+cNF+"'"
	Endif
	
	cQry += " ORDER BY " + SqlOrder(SZW->(IndexKey()))
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), "TMPSZW", .F., .T.)
	While !EOF()
		
		aAdd( aItems , { ZW_SALDO == 0, ZW_PACLIS, ZW_DOC, ZW_SERIE, ZW_QTDORI, ZW_SALDO, ZW_CODPRO, A2_NOME, ZW_NUMDI, ZW_FILIAL,;
		Stod(F1_DTDIGIT),	ZW_FORNECE, ZW_LOJA})
		
		dbSkip()
	EndDo
	dbCloseArea()
	dbSelectArea(cAlias)
	
Return