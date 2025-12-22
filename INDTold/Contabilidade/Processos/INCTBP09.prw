#include "Protheus.ch"

Static __aRegCT2

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ INCTBP09   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 03/06/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de alteração de conteúdo de campos do contas a pagar   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function INCTBP09()
	Local cArq, nX, oDlg, oMark, oMrk, oPanelT, oDeb, oCrd, cFilAux
	Local aCpoEnch := { "CT2_DATA", "CT2_LOTE", "CT2_SBLOTE", "CT2_DOC", "CT2_LINHA", "CT2_DEBITO", "CT2_CREDIT", "CT2_VALOR", "CT2_HIST","CT2_CCD","CT2_CCC","CT2_KEY"}
	Local cPerg    := PADR("INCTBP09",Len(SX1->X1_GRUPO))
	Local lOk      := .F.
	Local aCpoBrw  := {}
	Local aStruct  := {}
	Local cMarca   := "x"
	Local nOpcA    := 0
	
	ValidPerg(cPerg)
	If !Pergunte(cPerg,.T.)
		Return
	Endif
	
	Private cCadastro := "Transferência de Lançamentos"
	Private nMarca    := 0
	Private nDebito   := 0
	Private nCredit   := 0
	Private cNomeEmp  := ""
	Private cFilDest  := "  "
	Private cCtPonte  := CriaVar("CT2_DEBITO")
	
	// Adiciona o campo de marcação
	AAdd( aStruct, { "TMP_OK", "C", 1, 0} )
	AAdd( aCpoBrw, { "TMP_OK",, "", "@!"} )
	
	// Adiciona o campo de referência do lançamento
	AAdd( aStruct, { "TMP_RECNO", "N", 10, 0} )
	
	SX3->(dbSetOrder(2))
	
	For nX:=1 To Len(aCpoEnch)
		// Adiciona o campo no vetor de exibição
		If SX3->(dbSeek(aCpoEnch[nX]))
			AAdd( aStruct , SX3->({ Trim(X3_CAMPO), X3_TIPO, X3_TAMANHO, X3_DECIMAL}) )
		
			//  .--------------------------------------------------------------
			// |     Adiciona os campos a serem exibidos no Browsed de Seleção
			//  '--------------------------------------------------------------
			AAdd( aCpoBrw, SX3->({ Trim(X3_CAMPO),, Trim(X3_TITULO), Trim(X3_PICTURE)}) )
		Endif
	Next
	
	// Cria tabela temporária para marcação dos itens
	cArq := CriaTrab(aStruct,.T.)
	
	Use &cArq Alias CT2TMP New Exclusive
	
	Processa( {|| FiltraLanc() }, cCadastro,"Processando...", .T. )   // Filtra os títulos a serem modificados
	
	If CT2TMP->(Eof() .And. Bof())
		Alert("Não foram encontrados registros para os parâmetros informados !")
	Else
		cFilAux := cFilAnt    // Salva a filial atual
		cFilAnt := mv_par01   // Define a filial atual conforme o parâmetro
		
		DEFINE MSDIALOG oDlg TITLE "Seleção de Lançamentos a serem transferidos" FROM 00,00 TO 410,1130 PIXEL
		
		@ 0,0 MSPANEL oPanelT PROMPT "" SIZE 200,320 OF oDlg CENTERED LOWERED  // "Botoes"
		oPanelT:Align := CONTROL_ALIGN_TOP
		
		@ 005,005 SAY "Filial Origem" PIXEL OF oPanelT COLOR CLR_HBLUE
		@ 003,040 MSGET cFilAnt  SIZE 20,10 PIXEL OF oPanelT COLOR CLR_HRED WHEN .F.
		@ 005,070 SAY Trim(Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_FILIAL")) SIZE 100,20 PIXEL OF oPanelT COLOR CLR_HBLUE
		
		@ 005,155 SAY "Filial Destino" PIXEL OF oPanelT COLOR CLR_HBLUE
		@ 003,190 MSGET cFilDest SIZE 20,10 VALID Vazio() .Or. ValidEmp() PIXEL OF oPanelT COLOR CLR_HRED
		@ 005,220 SAY oNome VAR cNomeEmp SIZE 100,20 PIXEL OF oPanelT COLOR CLR_HBLUE
		
		@ 005,305 SAY "Conta Ponte" PIXEL OF oPanelT COLOR CLR_HBLUE
		@ 003,340 MSGET cCtPonte F3 "CT1" SIZE 80,10 VALID Vazio() .Or. CTB105CTA() PIXEL OF oPanelT COLOR CLR_HRED
		
		oMark:= MsSelect():New( "CT2TMP", "TMP_OK",,aCpoBrw,, cMarca, { 020, 005, 185, 530 } ,,, )
		oMark:oBrowse:Refresh()
		oMark:bAval               := {|| Marcar(cMarca,.F.), oMrk:Refresh(), oDeb:Refresh(), oCrd:Refresh(), oMark:oBrowse:Refresh() }
		oMark:oBrowse:lHasMark    := .T.
		oMark:oBrowse:lCanAllMark := .T.
		oMark:oBrowse:bAllMark    := {|| Processa( {|| MarcaTudo(cMarca) }, cCadastro), oMrk:Refresh(), oDeb:Refresh(), oCrd:Refresh(), oMark:oBrowse:Refresh(.T.) }
		
		@ 190,005 SAY "Total: " PIXEL OF oPanelT COLOR CLR_HBLUE
		@ 190,030 SAY CT2TMP->(RecCount()) SIZE 30,20 PICTURE "@E 999999" PIXEL OF oPanelT COLOR CLR_HRED
		
		@ 190,060 SAY "Marcados: " PIXEL OF oPanelT COLOR CLR_HBLUE
		@ 190,100 SAY oMrk VAR nMarca SIZE 30,20 PICTURE "@E 999999" PIXEL OF oPanelT COLOR CLR_HRED
		
		@ 190,325 SAY "Total de debitos: " PIXEL OF oPanelT COLOR CLR_HBLUE
		@ 190,385 SAY oDeb VAR nDebito SIZE 100,20 PICTURE "@E 999,999,999.99" PIXEL OF oPanelT COLOR CLR_HRED
		
		@ 190,435 SAY "Total de créditos: " PIXEL OF oPanelT COLOR CLR_HBLUE
		@ 190,495 SAY oCrd VAR nCredit SIZE 100,20 PICTURE "@E 999,999,999.99" PIXEL OF oPanelT COLOR CLR_HRED
		
		DEFINE SBUTTON oBtn1 FROM 020,535 TYPE 1 ACTION (nOpcA := ValidaTela(), If(nOpcA==1,oDlg:End(),)) ENABLE
		DEFINE SBUTTON oBtn2 FROM 035,535 TYPE 2 ACTION (nOpcA := 0,oDlg:End()) ENABLE
		
		ACTIVATE MSDIALOG oDlg CENTERED
	Endif
	
	If nOpcA == 1
		Processa( {|| lOk := Gravacao() } , cCadastro, "Gravando...")
		
		cFilAnt := cFilAux    // Restaura a filial original
	Endif
	
	dbSelectArea("CT2TMP")
	dbCloseArea()
   Ferase(cArq+GetDbExtension())
	
Return

Static Function ValidEmp()
	Local lRet := NaoVazio() .And. cFilDest <> cFilAnt .And. ExistCpo("SM0",cEmpAnt+cFilDest)
	
	If lRet
		cNomeEmp := Posicione("SM0",1,cEmpAnt+cFilDest,"M0_FILIAL")
	Endif
	
Return lRet

Static Function ValidaTela()
	Local lRet := !Empty(cFilDest)
	
	If lRet
		If lRet := (nMarca > 0)
			If Abs(nDebito - nCredit) > 0.009
				If lRet := !Empty(cCtPonte)
					lRet := CTB105CTA(cCtPonte)
				Else
					Alert("Favor informar a conta ponte !")
				Endif
			Endif
			lRet := lRet .And. MsgYesNo("Confirma transferência de lançamentos ?")
		Else
			Alert("Não foi selecionado nenhum item !")
		Endif
	Else
		Alert("Não foi informada a filial destino !")
	Endif
	
Return If( lRet , 1, 0)

Static Function Gravacao()
	Local aCT2, aDst, nX, cFilAux, cLote, aCampos, nDifValor, aHeadCT2, cCtaDeb, cCtaCrd
	Local lOk   := .F.
	Local aAlte := {}
	Local aOrig := {}
	Local aDest := {}
	Local aRegs := {}
	Local aCab  := {;
						{"dDataLanc", LastDay(mv_par03), NIL},;
						{"cLote"    , GetMV("MV_XLOTTRF",.F.,"008830")  , NIL},;
						{"cSubLote" , StrZero(1,Len(CT2->CT2_SBLOTE)), NIL}}
	Local lRet  := .F.
	Local cItem := StrZero(0,Len(CT2->CT2_LINHA))
	
	dbSelectArea("CT2TMP")
	dbGoTop()
	ProcRegua(RecCount())
	While !Eof()
		
		IncProc()
		
		If Empty(CT2TMP->TMP_OK)   // Se foi marcado
			dbSkip()
			Loop
		Endif
		
		CT2->(dbGoTo(CT2TMP->TMP_RECNO))      // Posiciona no registro original
		
		AAdd( aRegs, { CT2->(Recno()), CT2->CT2_KEY} )  // Adiciona os registros a serem atualizados
		
		// Armazena os campos do registro a ser transferido
		aCT2 := {}
		For nX:=1 To CT2->(FCount())
			If !(Trim(CT2->(FieldName(nX))) $ "CT2_FILIAL,CT2_DATA,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_CODPAR")
				AAdd( aCT2 , CT2->({ Trim(FieldName(nX)), FieldGet(nX), Nil}) )
			Endif
 		Next
		
		aDst := aClone(aCT2)
		
		// Calcula as contas contábeis a serem gravadas
		cCtaDeb := If( CT2->CT2_VALOR == 0 , CT2->CT2_DEBITO, If( VldConta("CT2","C") , CT2->CT2_CREDIT, CriaVar("CT2_DEBITO")))
		cCtaCrd := If( CT2->CT2_VALOR == 0 , CT2->CT2_CREDIT, If( VldConta("CT2","D") , CT2->CT2_DEBITO, CriaVar("CT2_CREDIT")))
		
		// Inverte os valores contábeis para gravação do lançamento de estorno na filial corrente
		aCT2[PosCampo(aCT2,"CT2_LINHA" ),2] := cItem := Soma1(cItem)
		aCT2[PosCampo(aCT2,"CT2_DEBITO"),2] := cCtaDeb
		aCT2[PosCampo(aCT2,"CT2_CREDIT"),2] := cCtaCrd
		aCT2[PosCampo(aCT2,"CT2_DCD"   ),2] := If( !Empty(cCtaDeb) , CT2->CT2_DCC   , CriaVar("CT2_DCD"))
		aCT2[PosCampo(aCT2,"CT2_DCC"   ),2] := If( !Empty(cCtaCrd) , CT2->CT2_DCD   , CriaVar("CT2_DCC"))
		aCT2[PosCampo(aCT2,"CT2_CCD"   ),2] := If( !Empty(cCtaDeb) , CT2->CT2_CCC   , CriaVar("CT2_CCD"))
		aCT2[PosCampo(aCT2,"CT2_CCC"   ),2] := If( !Empty(cCtaCrd) , CT2->CT2_CCD   , CriaVar("CT2_CCC"))
		aCT2[PosCampo(aCT2,"CT2_ITEMD" ),2] := If( !Empty(cCtaDeb) , CT2->CT2_ITEMC , CriaVar("CT2_ITEMD"))
		aCT2[PosCampo(aCT2,"CT2_ITEMC" ),2] := If( !Empty(cCtaCrd) , CT2->CT2_ITEMD , CriaVar("CT2_ITEMC"))
		aCT2[PosCampo(aCT2,"CT2_CLVLDB"),2] := If( !Empty(cCtaDeb) , CT2->CT2_CLVLCR, CriaVar("CT2_CLVLDB"))
		aCT2[PosCampo(aCT2,"CT2_CLVLCR"),2] := If( !Empty(cCtaCrd) , CT2->CT2_CLVLDB, CriaVar("CT2_CLVLCR"))
		aCT2[PosCampo(aCT2,"CT2_DC"    ),2] := If( CT2->CT2_VALOR <> 0 , If( !Empty(cCtaDeb) .And. !Empty(cCtaCrd) , "3", If( !Empty(cCtaDeb) , "1", "2")), "4")
		aCT2[PosCampo(aCT2,"CT2_XTRANS"),2] := "S"
		aCT2[PosCampo(aCT2,"CT2_CANC"  ),2] := "N"
		aCT2[PosCampo(aCT2,"CT2_FILORI"),2] := cFilAnt
		
		aCampos := {}
		aEval( aCT2 , {|x| AAdd( aCampos , aClone(x) ) } )
		
		AAdd( aOrig , aClone(aCampos) )
		
		// Atualiza os campos para gravação na filial destino
		aDst[PosCampo(aDst,"CT2_LINHA" ),2] := cItem
		aDst[PosCampo(aDst,"CT2_DEBITO"),2] := cCtaCrd
		aDst[PosCampo(aDst,"CT2_CREDIT"),2] := cCtaDeb
		aDst[PosCampo(aDst,"CT2_DCD"   ),2] := aCT2[PosCampo(aCT2,"CT2_DCC"   ),2]
		aDst[PosCampo(aDst,"CT2_DCC"   ),2] := aCT2[PosCampo(aCT2,"CT2_DCD"   ),2]
		aDst[PosCampo(aDst,"CT2_CCD"   ),2] := aCT2[PosCampo(aCT2,"CT2_CCC"   ),2]
		aDst[PosCampo(aDst,"CT2_CCC"   ),2] := aCT2[PosCampo(aCT2,"CT2_CCD"   ),2]
		aDst[PosCampo(aDst,"CT2_ITEMD" ),2] := aCT2[PosCampo(aCT2,"CT2_ITEMC" ),2]
		aDst[PosCampo(aDst,"CT2_ITEMC" ),2] := aCT2[PosCampo(aCT2,"CT2_ITEMD" ),2]
		aDst[PosCampo(aDst,"CT2_CLVLDB"),2] := aCT2[PosCampo(aCT2,"CT2_CLVLCR"),2]
		aDst[PosCampo(aDst,"CT2_CLVLCR"),2] := aCT2[PosCampo(aCT2,"CT2_CLVLDB"),2]
		aDst[PosCampo(aDst,"CT2_DC"    ),2] := If( aCT2[PosCampo(aCT2,"CT2_DC"),2] $ "12" , If( !Empty(cCtaCrd) , "1", "2"), aCT2[PosCampo(aCT2,"CT2_DC"),2])
		aDst[PosCampo(aDst,"CT2_XTRANS"),2] := "S"
		aDst[PosCampo(aDst,"CT2_CANC"  ),2] := "N"
		aDst[PosCampo(aDst,"CT2_FILORI"),2] := cFilDest
		
		aCampos := {}
		aEval( aDst , {|x| AAdd( aCampos , aClone(x) ) } )
		
		AAdd( aDest , aClone(aCampos) )
		
		dbSkip()
	Enddo
	
	If !Empty(aOrig)
		nDifValor := nDebito - nCredit
	
		If Abs(nDifValor) > 0.009    // Se houve diferença entre débito e crédito
			aCampos  := {}
			For nX:=1 To CT2->(FCount())
				If !(Trim(CT2->(FieldName(nX))) $ "CT2_FILIAL,CT2_DATA,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_CODPAR")
					AAdd( aCampos , CT2->({ Trim(FieldName(nX)), CriaVar(FieldName(nX)), Nil}) )
				Endif
 			Next

			// Inicializa os valores para a conta ponte na filial origem
			aCampos[PosCampo(aCampos,"CT2_LINHA" ),2] := cItem := Soma1(cItem)
			aCampos[PosCampo(aCampos,"CT2_DC"    ),2] := If( nDebito > nCredit , "1", "2")
			aCampos[PosCampo(aCampos,"CT2_DEBITO"),2] := If( nDebito > nCredit , cCtPonte, CriaVar("CT2_DEBITO"))
			aCampos[PosCampo(aCampos,"CT2_CREDIT"),2] := If( nDebito > nCredit , CriaVar("CT2_CREDIT"), cCtPonte)
			aCampos[PosCampo(aCampos,"CT2_VALOR" ),2] := Abs(nDifValor)
			aCampos[PosCampo(aCampos,"CT2_HIST"  ),2] := "VLR. REFERENTE A TRANSF. ENTRE FILIAIS"
			aCampos[PosCampo(aCampos,"CT2_XTRANS"),2] := "S"
			aCampos[PosCampo(aCampos,"CT2_CANC"  ),2] := "N"
			aCampos[PosCampo(aCampos,"CT2_FILORI"),2] := cFilAnt
			
			AAdd( aOrig , aClone(aCampos) )

			// Inicializa os valores para a conta ponte na filial destino
			aCampos[PosCampo(aCampos,"CT2_DC"    ),2] := If( nDebito > nCredit , "2", "1")
			aCampos[PosCampo(aCampos,"CT2_DEBITO"),2] := If( nDebito > nCredit , CriaVar("CT2_DEBITO"), cCtPonte)
			aCampos[PosCampo(aCampos,"CT2_CREDIT"),2] := If( nDebito > nCredit , cCtPonte, CriaVar("CT2_CREDIT"))
			
			AAdd( aDest , aClone(aCampos) )
		Endif
		
		lOk := GravaLanc(aCab,aOrig,aRegs)
		
		If lOk
			cFilAux := cFilAnt
			cFilAnt := cFilDest
			lOk := GravaLanc(aCab,aDest,aRegs)
			cFilAnt := cFilAux
			
			If lOk
				lRet := .T.   // Processou a gravação com sucesso
				For nX:=1 To Len(aRegs)
					CT2->(dbGoTo(aRegs[nX,1])) // Posiciona no registro do CT2
					RecLock("CT2",.F.)
					CT2->CT2_XTRANS := "S"   // Atualiza como transferido
					MsUnLock()
				Next
			Endif
		Endif
		
		dbSelectArea("CT2TMP")
	Endif
	
	If lRet
		MsgInfo("Transferência concluída com sucesso !")
	Endif

Return lRet

Static Function PosCampo(aHead,cCampo)
Return AScan( aHead , {|x| x[1] == cCampo } )

Static Function GravaLanc(aCab,aItem,aRegs)
	Local nX
	Local cAlias := Alias()
	
	__aRegCT2   := {}
	lMsErroAuto := .F.
	lMsHelpAuto := .T.
	
	MsgRun("Gravando lançamentos - Filial: "+cFilAnt+" - Data: "+Dtoc(aCab[1,2])+". Aguarde...","", {|| MsExecAuto({|x,y,z| CTBA102(x,y,z) },aCab,aItem,3) })
	
	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
		
		dbSelectArea(cAlias)
		Return .F.
	Else
		// Grava a chave nos novos registros transferidos
		For nX:=1 To Len(aRegs)
			CT2->(dbGoTo(__aRegCT2[nX]))   // Posiciona no registro
			RecLock("CT2",.F.)
			CT2->CT2_KEY := aRegs[nX,2]
			MsUnLock()
		Next
	Endif
	dbSelectArea(cAlias)
	
Return .T.

Static Function Marcar(cMarca,lTudo)
	
	RecLock("CT2TMP",.F.)
	CT2TMP->TMP_OK := If( lTudo .Or. Empty(TMP_OK) , cMarca, Space(Len(TMP_OK)))
	MsUnLock()
	
	If Empty(CT2TMP->TMP_OK)
		If nMarca > 0
			nMarca--
			
			If VldCusto("CT2TMP","D") .And. VldConta("CT2TMP","D")
				nDebito -= If( !Empty(CT2_DEBITO), CT2_VALOR, 0)
			Endif		
			If VldCusto("CT2TMP","C") .And. VldConta("CT2TMP","C")
				nCredit -= If( !Empty(CT2_CREDIT), CT2_VALOR, 0)
			Endif
		Endif
	Else
		nMarca++
		If VldCusto("CT2TMP","D") .And. VldConta("CT2TMP","D")
			nDebito += If( !Empty(CT2_DEBITO), CT2_VALOR, 0)
		Endif
		If VldCusto("CT2TMP","C") .And. VldConta("CT2TMP","C")
			nCredit += If( !Empty(CT2_CREDIT), CT2_VALOR, 0)
		Endif
	Endif
	
Return

Static Function VldCusto(cAlias,cTpo)
	Local lRet
	If cTpo == "D"
		lRet := (cAlias)->CT2_CCD >= mv_par04 .And. (cAlias)->CT2_CCD <= mv_par05
	Else
		lRet := (cAlias)->CT2_CCC >= mv_par04 .And. (cAlias)->CT2_CCC <= mv_par05
	Endif
Return lRet

Static Function VldConta(cAlias,cTpo)
	Local lRet
	If cTpo == "D"
		lRet := (cAlias)->CT2_DEBITO >= mv_par06 .And. (cAlias)->CT2_DEBITO <= mv_par07
	Else
		lRet := (cAlias)->CT2_CREDIT >= mv_par06 .And. (cAlias)->CT2_CREDIT <= mv_par07
	Endif
Return lRet

Static Function MarcaTudo(cMarca)
	Local nReg  := CT2TMP->(Recno())
	Local lTudo := (nMarca <> CT2TMP->(RecCount()))   // Identifica se todos os itens estão marcados
	
	// Se nem todos os itens estiverem marcados, então marca tudo. Senão, desmarca tudo
	nMarca  := If( lTudo , 0, nMarca )
	nDebito := If( lTudo , 0, nDebito)
	nCredit := If( lTudo , 0, nCredit)
	
	dbSelectArea("CT2TMP")
	dbGoTop()
	ProcRegua(RecCount())
	While !Eof()
		IncProc("Atualizando...")
		Marcar(cMarca,lTudo)
		dbSkip()
	Enddo
	dbGoTo(nReg)
	
Return .T.

Static Function FiltraLanc()
	Local cQry, nPos, nX, nTotal
	Local aStruct := CT2->(dbStruct())
	
	cQry := "SELECT COUNT(*) AS TOTAL"
	cQry += " FROM "+RetSQLName("CT2")+" CT2"
	cQry += " WHERE CT2.D_E_L_E_T_ = ' '"
	cQry += " AND CT2.CT2_FILIAL = '"+mv_par01+"'"
	cQry += " AND CT2.CT2_DATA >= '"+Dtos(mv_par02)+"'"
	cQry += " AND CT2.CT2_DATA <= '"+Dtos(mv_par03)+"'"
	cQry += " AND ((CT2.CT2_CCD >= '"+mv_par04+"'"
	cQry += " AND CT2.CT2_CCD <= '"+mv_par05+"')"
	cQry += " OR (CT2.CT2_CCC >= '"+mv_par04+"'"
	cQry += " AND CT2.CT2_CCC <= '"+mv_par05+"'))"
	cQry += " AND ((CT2.CT2_DEBITO >= '"+mv_par06+"'"
	cQry += " AND CT2.CT2_DEBITO <= '"+mv_par07+"')"
	cQry += " OR (CT2.CT2_CREDIT >= '"+mv_par06+"'"
	cQry += " AND CT2.CT2_CREDIT <= '"+mv_par07+"'))"
	cQry += " AND CT2.CT2_LOTE >= '"+mv_par08+"'"
	cQry += " AND CT2.CT2_LOTE <= '"+mv_par09+"'"
	cQry += " AND CT2.CT2_XTRANS <> 'S'"
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMPQRY",.T.,.T.)
	nTotal := TOTAL
	dbCloseArea()
	
	cQry := StrTran(cQry,"COUNT(*) AS TOTAL"," *, R_E_C_N_O_ AS CT2_RECNO")
	cQry += " ORDER BY "+SQLOrder(CT2->(IndexKey(1)))
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMPQRY",.T.,.T.)
	
	For nX:=1 To Len(aStruct)
		If aStruct[nX,2] <> "C"
			TCSetField("TMPQRY",aStruct[nX,1],aStruct[nX,2],aStruct[nX,3],aStruct[nX,4])
		Endif
	Next
	
	//  .------------------------------------------------
	// |     Gravação da tabela temporária para marcação
	//  '------------------------------------------------
   ProcRegua(nTotal)
	While !TMPQRY->(EOF())
		
		IncProc()
		
		RecLock("CT2TMP",.T.)
		For nX:=1 To FCount()
			If (nPos := TMPQRY->(FieldPos(CT2TMP->(FieldName(nX))))) > 0   // Se o campo existir na tabela de origem
				FieldPut( nX , TMPQRY->(FieldGet(nPos)) )
			Endif
		Next
		CT2TMP->TMP_RECNO := TMPQRY->CT2_RECNO
		MsunLock()
		
		TMPQRY->(dbSkip())
	Enddo
	dbSelectArea("TMPQRY")
	dbCloseArea()
	dbSelectArea("CT2TMP")
	dbGoTop()
	
Return

User Function CTBP09NewReg(nReg)
	AAdd( __aRegCT2 , nReg )
Return

Static Function ValidPerg(cPerg)
   u_INPutSx1(cPerg,"01",PADR("Filial de Origem     ",29)+"?","","","mv_ch1","C", 2,0,0,"G","","   ","","","mv_par01")
   u_INPutSx1(cPerg,"02",PADR("Da Data              ",29)+"?","","","mv_ch2","D", 8,0,0,"G","","   ","","","mv_par02")
   u_INPutSx1(cPerg,"03",PADR("Ate a Data           ",29)+"?","","","mv_ch3","D", 8,0,0,"G","","   ","","","mv_par03")
   u_INPutSx1(cPerg,"04",PADR("Do Centro de Custo   ",29)+"?","","","mv_ch4","C", 9,0,0,"G","","CTT","","","mv_par04")
   u_INPutSx1(cPerg,"05",PADR("Ate o Centro de Custo",29)+"?","","","mv_ch5","C", 9,0,0,"G","","CTT","","","mv_par05")
   u_INPutSx1(cPerg,"06",PADR("Da Conta Contabil    ",29)+"?","","","mv_ch6","C",20,0,0,"G","","CT1","","","mv_par06")
   u_INPutSx1(cPerg,"07",PADR("Ate a Conta Contabil ",29)+"?","","","mv_ch7","C",20,0,0,"G","","CT1","","","mv_par07")
   u_INPutSx1(cPerg,"08",PADR("Do Lote              ",29)+"?","","","mv_ch8","C", 6,0,0,"G","","   ","","","mv_par08")
   u_INPutSx1(cPerg,"09",PADR("Ate o Lote           ",29)+"?","","","mv_ch9","C", 6,0,0,"G","","   ","","","mv_par09")
Return
