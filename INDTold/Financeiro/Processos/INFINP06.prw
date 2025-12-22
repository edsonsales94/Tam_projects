#include "Protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ INFINP06   ¦ Autor ¦ Nelio Jorio          ¦ Data ¦ 20/04/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de ajuste de lançamentos contábeis para o MCT          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function INFINP06()
	Local oOk      := LoadBitmap( GetResources(), "LBOK" )
	Local oNo      := LoadBitmap( GetResources(), "LBNO" )
	Local oSim     := LoadBitmap( GetResources(), "BR_VERDE" )
	Local oNao     := LoadBitmap( GetResources(), "BR_VERMELHO" )
	
	Local oDlg, oVar, oDat, oVal, oLP, oSer, oFor, oLoj, oTip, oPar, oLg1, oLg2
	
	Private obtnPesq, oBtnOk, oBtnCancel
	Private cHis, dDat, nVal, cDoc, cSer, cFor, cLoj, cTip, cPar, cLP, cChave, nTot:=0
	Private lSE2      := .T.
	Private lLPDiff   := .T.
	Private aVetor    := {}
	Private oLbx      := Nil
	Private cCadastro := OemToAnsi("Ajuste de Despesas - Vincular contas contábeis")
	Private aTrocaF3 := {{"cDoc","SF1P06"}}
	
	AAdd( aVetor, { .F., 0, Ctod(""), 0, "", "", "", "", "", "", "", "", .F.} )  // Carrega o vetor com vazio
	
	IniciaVar()   // Inicializa as variáveis de leitura
	
	//   .--------------------------------
	//  |     
	//  |     Tela de Ajuste Contábil
	//  |     
	//   '--------------------------------
	DEFINE MSDIALOG oDlg FROM 0,0 TO 440,700 TITLE cCadastro PIXEL
      
	//   .--------------------------------------
	//  |     Tela: Dados para consulta CT2
	//   '--------------------------------------

	//Label
	@02,003 TO 125,347 LABEL "Consulta CT2" OF oDlg PIXEL


	//Say/Get
	@15,007 Say "Histórico" Pixel Of oDlg
	@15,037 MSGet oHis Var cHis Picture "@!" Size 100,10 Pixel Of oDlg

	@15,147 Say "Data" Pixel Of oDlg
	@15,162 MSGet oDat Var dDat Picture "99/99/9999" Size 40,10 Pixel Of oDlg

	@15,217 Say "Valor" Pixel Of oDlg
	@15,242 MSGet oVal Var nVal Picture "@E 999,999,999.99" Valid Vazio() .Or. Positivo() Size 60,10 Pixel Of oDlg
	
	//Button
	@15,310 Button obtnPesq Prompt "&Filtrar" Size 30,15 Pixel Action Filtrar() Of oDlg

	//   .-----------------------
	//  |     Tela: Grid CT2
	//   '-----------------------
	//1		2			3		4			5			6			7		8			9		10		11
	
	//Say / Lbx
	@30,007 Say "Lista CT2" Pixel Of oDlg
	@40,007 LISTBOX oLbx FIELDS HEADER "","","Registro","Data","Valor","Projeto","MCT","Histórico","Conta Deb","Item CTB","Conta Crd","Manual","LP";
	SIZE 335,070 OF oDlg PIXEL ON DBLCLICK(Marcacao())
	
	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {	Iif( aVetor[oLbx:nAt,1],oOk,oNo),;
								Iif( aVetor[oLbx:nAt,13],oSim,oNao),;
								aVetor[oLbx:nAt,2],;
								Transform(aVetor[oLbx:nAt,3],"@E 999,999,999.99"),;
								aVetor[oLbx:nAt,4],;
								aVetor[oLbx:nAt,5],;
								aVetor[oLbx:nAt,6],;
								aVetor[oLbx:nAt,7],;
								aVetor[oLbx:nAt,8],;
								aVetor[oLbx:nAt,9],;
								aVetor[oLbx:nAt,10],;
								aVetor[oLbx:nAt,11],;
								aVetor[oLbx:nAt,12]}}
	
	@ 115,007 SAY "Total de registros"  SIZE 50,10 Pixel Of oDlg COLOR CLR_HBLUE
	@ 115,055 SAY oTot VAR nTot Picture "@E 9,999,999" SIZE 40,10 Pixel Of oDlg COLOR CLR_HRED
	
	//   .-------------------------------------
	//  |
	//  |     Tela: Digitacao do Documento
	//  |
	//   '-------------------------------------

	//Label
	@125,003 TO 190,347 LABEL "Dados do Documento" OF oDlg PIXEL

	//Say/Get
	@138,007 Say "LP" Pixel Of oDlg
	@138,037 MSGet oLP Var cLP F3 "CTL" valid Vazio() .Or. ValidaCTL() Picture "@!" Size 20,10 Pixel Of oDlg //When lLPDiff
	
	@155,007 Say "Documento" Pixel Of oDlg
	@155,037 MSGet oDoc Var cDoc F3 "SF1P06" Picture "@!" Size 45,10 Pixel Of oDlg

	@155,087 Say "Série" Pixel Of oDlg
	@155,102 MSGet oSer Var cSer Picture "@!" Size 20,10 Pixel Of oDlg
   
	@155,128 Say "Fornecedor" Pixel Of oDlg
	@155,158 MSGet oFor Var cFor Picture "@!" Size 35,10 Pixel Of oDlg

	@155,198 Say "Loja" Pixel Of oDlg
	@155,211 MSGet oLoj Var cLoj Picture "@!" Size 15,10 Pixel Of oDlg

	@155,231 Say "Tipo" Pixel Of oDlg
	@155,244 MSGet oTip Var cTip Picture "@!" Size 20,10 Pixel Of oDlg When lSE2
	
	@155,270 Say "Parc" Pixel Of oDlg
	@155,284 MSGet oPar Var cPar Picture "@!" Size 20,10 Pixel Of oDlg When lSE2
	
	@155,310 Button obtnPesq Prompt "&Pesquisar" Size 30,15 Pixel Action Pesquisar() Of oDlg
	
	@170,007 Say "Chave" Pixel Of oDlg
	@170,037 MSGet oVar Var cChave Picture "@!" Size 200,10 Pixel Of oDlg When .F.
	
	@197,003 BITMAP oLg1 RESNAME "BR_VERDE"    Size 20,10 Pixel Of oDlg NOBORDER
	@197,015 Say "com chave" Pixel Of oDlg Size 40,10
	@207,003 BITMAP oLg2 RESNAME "BR_VERMELHO" Size 20,10 Pixel Of oDlg NOBORDER
	@207,015 Say "sem chave" Pixel Of oDlg Size 40,10
	
	//   .-------------------------------
	//  |     Tela: Botoes do Rodape
	//   '-------------------------------
	//Button
	@200,130 Button oBtnOk Prompt "&Salvar" Size 30,15 Pixel Action GravaChave() Of oDlg   
	@200,190 Button oBtnCancel Prompt "&Cancelar" Size 30,15 Pixel Action oDlg:End() Of oDlg

	Activate Dialog oDlg Centered	
	
Return

Static Function IniciaVetor(lMens)
	lLPDiff := .T.   // Define como LP variado
	cLP  := CriaVar("CTL_LP")
	nTot := Len(aVetor)
	
	If Empty(aVetor)
		If lMens == Nil .Or. lMens
			MsgAlert("Não foram encontrados registros para essa consulta")
		Endif
		AAdd( aVetor, { .F., 0, Ctod(""), 0, "", "", "", "", "", "", "", "", .F.} )
		nTot := 0
	ElseIf Len(aVetor) == 1
		cLP := aVetor[1,12]   // Atribui conteúdo do LP
		
		If !Empty(cLP)
			lLPDiff := .F.     // Define como LP único
			ValidaCTL()        // Valida o LP inicializado
		Endif
	Endif
	oTot:Refresh()
Return

Static Function IniciaVar()
	cHis   := CRIAVAR("CT2_HIST")
	dDat   := CTOD("")
	nVal   := 0
	cDoc   := CRIAVAR("D1_DOC")
	cSer   := CRIAVAR("D1_SERIE")
	cFor   := CRIAVAR("D1_FORNECE")
	cLoj   := CRIAVAR("D1_LOJA")
	cTip   := CRIAVAR("E2_TIPO")
	cPar   := CRIAVAR("E2_PARCELA")
	cLP    := CRIAVAR("CTL_LP")
	cChave := CRIAVAR("CT2_KEY")
Return

Static Function Marcacao()
	Static cLPAnt := CRIAVAR("CTL_LP")
	If aVetor[oLbx:nAt,2] > 0   // Caso tenha itens válidos
		// Só permite marcar itens com LP's iguais
		If Empty(cLPAnt) .Or. aVetor[oLbx:nAt,12] $ cLPAnt
			aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1]
			oLbx:Refresh()
			cLPAnt := If( Empty(cLPAnt) .And. !Empty(aVetor[oLbx:nAt,12]) , cLPAnt+","+aVetor[oLbx:nAt,12], cLPAnt)   // Salva o LP válido
		Else
			Alert("Não é possível salvar simultaneamente registros com LP's diferentes !")
		Endif
	Endif
Return

Static Function ValidaCTL()
	Local lRet := ExistCpo("CTL",cLP)
	
	If lRet
		// Posiciona na tabela de relacionamentos contábeis
		CTL->(dbSetOrder(1))
		CTL->(dbSeek(XFILIAL("CTL")+cLP))
		If lSE2 := (CTL->CTL_ALIAS $ "SE2,SE5")   // Define se lê os dados do financeiro
			If CTL->CTL_ALIAS == "SE2"
				aTrocaF3 := { {"cDoc", "SE2P06"} }
			Else
				aTrocaF3 := { {"cDoc", "SE5P06"} }
			Endif
		Else
			aTrocaF3 := { {"cDoc", "SF1P06"} }             
		EndIf
	Endif
	
Return lRet

/*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ LoadLbx    ¦ Autor ¦ Nelio Jorio          ¦ Data ¦ 20/04/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descrição ¦ Carrega o objeto oLbx com os dados referente a consulta CT2   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function LoadLbx(cQry)
	Local cAlias := Alias()
	
	// Reinicia o vetor de lançamentos
	aDel(aVetor,Len(aVetor))
	aSize(aVetor,0)
	
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQry),"TMPCT2", .F., .T.)
	
	TCSetField("TMPCT2","CT2_DATA","D",8,0)  // Converte o campo CT2_DATA para o tipo data
	
	While !Eof()
		AAdd( aVetor, {.F., TMPCT2->CT2_RECNO, TMPCT2->CT2_DATA, TMPCT2->CT2_VALOR, TMPCT2->CT2_CCD, TMPCT2->CT2_CLVLDB, TMPCT2->CT2_HIST, TMPCT2->CT2_DEBITO,;
						TMPCT2->CT2_ITEMD, TMPCT2->CT2_CREDIT, TMPCT2->CT2_MANUAL, TMPCT2->CT2_LP, !Empty(TMPCT2->CT2_KEY)} )
		dbSkip()
	Enddo
	dbCloseArea()
	dbSelectArea(cAlias)
	
Return

/*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ Filtrar    ¦ Autor ¦ Nelio Jorio          ¦ Data ¦ 20/04/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descrição ¦ Validacao dos parametros para a consulta em CT2               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Filtrar()
	Local cQry := ""
	
	// Limita o mínimo de 6 caracteres para pesquisa pelo histórico
	If !Empty(cHis) .And. Len(AllTrim(cHis)) < 6
		Alert("Histórico muito curto para pesquisa de lançamentos !")
		Return .F.
	Endif
	
	If Empty(cHis) .And. (Empty(nVal) .Or. Empty(dDat))
		Alert("Favor informar os campos data e valor para pesquisa !")
		Return .F.
	Endif
	
	cQry += "SELECT CT2.R_E_C_N_O_ AS CT2_RECNO, CT2.CT2_DATA, CT2.CT2_DEBITO, CT2.CT2_CREDIT, CT2.CT2_MANUAL, CT2.CT2_HIST, CT2.CT2_CCD,"
	cQry += " CT2.CT2_CLVLDB, CT2.CT2_ITEMD, CT2.CT2_VALOR, CT2.CT2_LP, CT2.CT2_KEY"
	cQry += " FROM "+RetSQLName("CT2") + " CT2"
	cQry += " LEFT OUTER JOIN "+RetSQLName("CT1") + " DEB ON DEB.D_E_L_E_T_ = ' ' AND DEB.CT1_CONTA = CT2.CT2_DEBITO"
	cQry += " LEFT OUTER JOIN "+RetSQLName("CT1") + " CRD ON CRD.D_E_L_E_T_ = ' ' AND CRD.CT1_CONTA = CT2.CT2_CREDIT"
	cQry += " WHERE CT2.D_E_L_E_T_ = ' '"
	cQry += " AND CT2.CT2_FILIAL = '"+CT2->(XFILIAL("CT2"))+"'"
	cQry += " AND (CT2.CT2_KEY <> 'XX' OR SUBSTRING(CT2.CT2_ROTINA,1,3) = 'GPE')"
	cQry += " AND CT2.CT2_VALOR <> 0"
	cQry += " AND CT2.CT2_LP NOT IN ('530','532','597','801','805','820',"
	cQry += "'509','512','514','515','531','564','565','581','589','591','656',"
	cQry += "'806','807','814','815','816')"
	cQry += " AND (ISNULL(DEB.CT1_XMCT,'S') = 'S' OR ISNULL(CRD.CT1_XMCT,'S') = 'S')
	cQry += " AND CT2.CT2_TPSALD = '1' AND CT2.CT2_CANC <> 'S'"
	cQry += " AND CT2.CT2_ROTINA <> 'CTBA211'"  // Desconsidera lançamentos de fechamento
	cQry += " AND (CT2.CT2_DEBITO <> ' ' OR CT2.CT2_CREDIT <> ' ')"
	
	If !Empty(cHis)
		cQry += " AND CT2.CT2_HIST LIKE '%" + AllTrim(cHis) + "%'"
	EndIf
	If !Empty(nVal)
		cQry += " AND CT2.CT2_VALOR = " + LTrim(Str(nVal,14,2))
	EndIf
	If !Empty(dDat)
		cQry += " AND CT2.CT2_DATA = '" + Dtos(dDat) +"'"
	EndIf
	
	cQry += " ORDER BY CT2.CT2_DATA, CT2.CT2_LOTE, CT2.CT2_LINHA"
	
	MsgRun("   Filtrando registros   ","Aguarde...", {|| LoadLbx(cQry) })
	
	IniciaVetor(.T.)   // Inicia o vetor de itens
	
	oLbx:Refresh()
	
	// Se encontrou itens válidos
	If Len(aVetor) > 1 .Or. aVetor[1,2] > 0
		oLbx:SetFocus()   // Deixa o foco nos itens filtrados
	Else
		oHis:SetFocus()   // Volta pro histórico
	Endif
	
Return .T.

/*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ Pesquisar  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 24/04/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descrição ¦ Pesquisa a nota informada na tela                             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Pesquisar()
	Local lRet   := .T.
	Local cAlias := CTL->CTL_ALIAS
	Local nOrdem := Val(CTL->CTL_ORDER)
	Local cBusca := ""
	
	If lRet := !Empty(cLP)
		If cAlias == "SE2"
			cBusca := cSer+cDoc+cPar+cTip+cFor+cLoj
		ElseIf cAlias <> "SE5"
			cBusca := cDoc+cSer+cFor+cLoj
		Endif
		
		// Pesquisa a nota nos itens da nota de entrada
		(cAlias)->(dbSetOrder(nOrdem))
		If lRet := (cAlias == "SE5" .Or. (cAlias)->(dbSeek(XFILIAL(cAlias)+cBusca)))
			cChave := &(cAlias+"->("+Trim(CTL->CTL_KEY)+")")
		Else
			Alert("Documento informado não foi encontrado !")
		Endif
	Else
		Alert("É necessário informar um lançamento padrão para vínculo com o documento de origem !")
	Endif
	
	If lRet
		oBtnOk:SetFocus()
	Else
		oDoc:SetFocus()
	Endif
	
Return lRet

/*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ GravaChave ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 24/04/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descrição ¦ Pesquisa a nota informada na tela                             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function GravaChave()
	Local nX
	Local aAux := {}
	
	If AScan( aVetor , {|nX| nX[1] } ) == 0
		Alert("Favor marcar ao menos um item para gravação ! ")
		Return .F.
	Endif
	
	If Empty(cLP)
		Alert("É necessário informar um lançamento padrão para vínculo com o documento de origem !")
		Return .F.
	Endif
	
	If Empty(cChave)
		Alert("É necessário ter uma chave válida para gravar a consulta !")
		Return .F.
	Endif
	
	// Processa a atualização dos registros
	For nX:=1 To Len(aVetor)
		If aVetor[nX,1]
			CT2->(dbGoTo(aVetor[nX,2]))  // Posicionano registro do CT2
			
			// Grava os campos de vínculo com o documento de origem
			RecLock("CT2",.F.)
			CT2->CT2_KEY := cChave
			CT2->CT2_LP  := cLP
			MsUnLock()
		Else
			AAdd( aAux , aClone(aVetor[nX]) )  // Salva os itens não marcados
		Endif
	Next
	
	// Reinicia o vetor de lançamentos
	aDel(aVetor,Len(aVetor))
	aSize(aVetor,0)
	
	For nX:=1 To Len(aAux)
		AAdd( aVetor , aClone(aAux[nX]) )   // Exibe somente os itens não marcados
	Next
	
	IniciaVetor(.F.)   // Inicia o vetor de itens
	
	MsgInfo("Gravação efetuada com sucesso !")
	
	IniciaVar()   // Inicializa as variáveis de leitura
	oLbx:Refresh()
	oHis:SetFocus()
Return

/*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FINP06Entra¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 24/04/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descrição ¦ Consulta padrão para as notas de entrada - SXB -> SF1P06      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FINP06Entra()
	Local   cCadastro  := "Documentos de Entrada"
	Local   aRotOld    := Iif(Type('aRotina') == 'A',AClone(aRotina),{})
	Local   aCampos    := {} 
	Private nOpcSel    := 0  
	
	aRotina := {}
	AAdd( aRotina, { "&Confirmar" ,"OMSConfSel",0,2,,,.T.} )
	
	SF1->(DbSetOrder(1))
	
	MaWndBrowse(0,0,300,600,cCadastro,"SF1",aCampos,aRotina,,,,.T.)
	
	aRotina := AClone(aRotOld)
	
Return( nOpcSel == 1 )
