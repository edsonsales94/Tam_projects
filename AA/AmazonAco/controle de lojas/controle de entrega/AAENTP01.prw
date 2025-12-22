#include "Rwmake.ch"
#include "TbiConn.ch"
#include "Protheus.ch"

Static cZE_PLACA, cZE_TICKET1

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAENTP01   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 21/01/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Romaneio de entrega                                           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function EAAENTP01()
	Private _cdTpRoman := "E"
	u_AAENTP01()
Return Nil

User Function SAAENTP01()
	Private _cdTpRoman := "S"
	u_AAENTP01()   
Return Nil

User Function AAENTP01()
	Local cCadastro := "Cadastro de Romaneio"
	Private  cBalanca := "" 
	If Type("_cdTpRoman") == "U"
		Private _cdTpRoman := " "
	EndIf
	
	If Right(getcomputername(),2)=="L2" //ALVORADA
		cBalanca :=FormatIn("BAL_ALVORADA,BALANCA-ALVORADA,BAL. ALVORADA",',')
	Else
		cBalanca :=FormatIn("BAL_PURAQ_ENTRADA,BAL_PURAQ_SAIDA",',') 
	EndIf

	Private aRotina := { {"Pesquisar"     ,"AxPesqui"  ,0,1},;
	{"Visualizar"    ,"u_ENTP01A" ,0,2},;
	{"Pré-Romaneio"  ,"u_ENTP01A" ,0,3},;
	{"Alterar"       ,"u_ENTP01A" ,0,4},; // {"Excluir"    ,"u_ENTP01a" ,0,5},;
	{"Romaneio"      ,"u_ENTP01A" ,0,5},; // {"Excluir"    ,"u_ENTP01a" ,0,5},;
	{"Retorno"       ,"u_ENTP01A" ,0,6},;
	{"Canc. Romaneio","u_ENTP01E" ,0,7},;
	{"Histórico"     ,"u_AAFATP04",0,8},;
	{"Lib.ESpecial"  ,"u_ENTP01L" ,0,9},;
	{"Impressão"     ,"u_Imp_Roma(.T.)" ,0,10},;
	{"Legendas"      ,"u_ENTP01D" ,0,11} }

	Private aCores  := { {"Empty(ZE_STATUS)",'ENABLE'     },; // ABERTO
	{'ZE_STATUS = "P" ',"BR_PINK"	   },;	// PRÉ-ROMANEIO
	{'ZE_STATUS = "R" ',"BR_AMARELO" },;	// EM ROMANEIO
	{'ZE_STATUS = "B" ',"BR_CINZA"   },;	// VEM BUSCAR NA LOJA
	{'ZE_STATUS = "E" ',"BR_VERMELHO"},;	// ENTREGUE
	{'ZE_STATUS = "V" ',"BR_LARANJA" },;	// NOVA ENTREGUE
	{'ZE_STATUS = "N" ',"BR_AZUL"    },;	// ENDERECO NAO ENCONTRADO
	{'ZE_STATUS = "F" ',"BR_BRANCO"  },;	// LOCAL FECHADO
	{'ZE_STATUS = "D" ',"BR_PRETO"   },;	// DEVOLUCAO
	{'ZE_STATUS = "S" ',"BR_MARROM"  },; 	// ESTORNO DE VENDA
	{'ZE_STATUS = "X" ',"PMSEDT1"    } } 	// LIBERAÇÃO ESPECIAL

	Private aLegenda  :=  { {"P"  , "Pré-Romaneio"},;
	{"R"  , "Romaneio"    },;
	{"B"  , "Vem Buscar"    },;
	{"E"  , "Entregue"},;
	{"V"  , "Nova Entrega"  },;
	{"N"  , "Endereço não encontrado"},;
	{"F"  , "Local Fechado"},;
	{"F"  , "Venda com Devolução"},;
	{"D"  , "Devolucao"},;
	{"S"  , "Estorno de Venda"},;
	{"X"  , "Liberação Especial"},;
	{" "  , "Aberto"} }

	Private cString    := "SZE"
	Private cBDBalanca
	Private cFilter    := ""

	cFilSQL  := "ZE_TIPO = '" + _cdTpRoman + "'"
	//alert(_cdTpRoman)    
	// Serie empresa 06 - 01,61,

	dbSelectArea(cString)
	dbSetOrder(1)
	/*
	If FwCodEmp() == "06"
	   SZE->( DbSetFilter({|| Alltrim(SZE->ZE_SERIE)$"1,61,62"},'{|| Alltrim(SZE->ZE_SERIE)$"1,61,62" }') )
	ElseIf FwCodEmp() == "01"
	   SZE->( DbSetFilter({|| !Alltrim(SZE->ZE_SERIE)$"1,61,62"},'{|| !Alltrim(SZE->ZE_SERIE)$"1,61,62" }') )
	EndIf
	*/
	mBrowse( 6, 1, 22, 75, cString,,,,,,aCores,,,,,,,,cFilSQL)
	
	SZE->( dbClearFilter( ))
	//MBrowse( 6,1,22,75,'SC5',,,,,,aCores,,,,,,,,cFilSQL)

Return

//*************************************************************************************************************

User Function ENTP01A(cAlias,nRecno,nOpc)
	Local cArq, cInd, oDlg, oBtn1, oBtn2, oBusca, oFonte1, oFonte2
	Local cAlias    := Alias()
	Local aCpoBrw   := {}
	Local aStruct   := {}
	Local nOpcA     := 0
	Local cBusca    := Space(30)
	Local cMarca    := "x"	
	Local nTotalB   := 0
	Local nTotalP   := 0	
	Local nTot      := 0
	Local nPer      := 0
	Local cCbx      := space(30)
	Local aCbx      := {"Bairro", "Pedido", "Cliente", "Nome Cliente", "Nota Fiscal"}
	Local oCbx      := Nil	
	Local aCby      := {"Empresa", "Cliente"}
	Local oCby      := Nil
	Local lMoto     := .T.
	Private _cdTipo   := ""
	Private cCby      := space(30)
	Private lSemPeso := .F.
	Private cTmp      := "TMP"
	Private nMarca    := 0
	Private cRomaneio := Nil
	Private cCodMoto  := If( INCLUI, Space(06)                   ,SZE->ZE_MOTOR  )
	Private cNomMoto  := If( INCLUI, Space(30)                   ,SZE->ZE_NOMOTOR)
	Private nPeso     := If( INCLUI,                             ,SZE->ZE_PESO   )
	Private nPesoB    := If( INCLUI,                             ,SZE->ZE_PBRUTO )
	Private cObsRoma  := If( INCLUI, Space(100)                  ,SZE->ZE_OBSERV )
	Private cAjuda1   := If( INCLUI, Space(030)                  ,SZE->ZE_AJUDA01)
	Private cAjuda2   := If( INCLUI, Space(030)                  ,SZE->ZE_AJUDA02)

	Private cPlaca  := If( INCLUI, Space(TamSX3("ZF_PLACA")[1]),SZE->ZE_PLACA  )

	Private oMark, oTkt1, oTkt2
	Private oCodMoto:= Nil
	Private _nPesoAnt := 0


	If Type("aLegenda") != "A"
		Private aLegenda  :=  { {"P"  , "Pré-Romaneio"},;
		{"R"  , "Romaneio"    },;
		{"B"  , "Vem Buscar"    },;
		{"E"  , "Entregue"},;
		{"V"  , "Nova Entrega"  },;
		{"N"  , "Endereço não encontrado"},;
		{"F"  , "Local Fechado"},;
		{"F"  , "Venda com Devolução"},;
		{"D"  , "Devolucao"},;
		{"S"  , "Estorno de Venda"},;
		{"X"  , "Liberação Especial"},;
		{" "  , "Aberto"} }
	EndIf

	cBDBalanca  := GetMV("MV_XBCOGUAR")  //"Guardian110TST.dbo.RegTick"
	cZE_TICKET1 := If( Inclui .And. !_cdTpRoman == "E" , CriaVar("ZE_TICKET1"), SZE->ZE_TICKET1)

	DEFINE FONT oFonte1 NAME "Arial" SIZE 08,17 BOLD
	DEFINE FONT oFonte2 NAME "Arial" SIZE 10,20 BOLD

	If nOpc = 5 .And. SZE->ZE_STATUS <> "P"
		MsgStop("Favor escolher um Pré-Romaneio")
		Return Nil
	EndIf

	If nOpc = 4 .And. SZE->ZE_STATUS <> "P"
		MsgStop("Somente pode ser alterado o pré-romaneio!")
		Return Nil
	EndIf

	If nOpc = 4 .And. !(__CUSERID $ SUPERGETMV("MV_XALTROM") )
		MsgStop("Usuário sem permissão para utilização desta rotina!!!")
		Return Nil
	EndIf

	If nOpc = 6 .And. SZE->ZE_STATUS <> "R"
		MsgStop("Somente pode ser retornado um Romaneio!")
		Return Nil
	EndIf

	If nOpc == 5   .Or. _cdTpRoman == "E"// Se for Romaneio
		nPeso  := BuscaPeso(cZE_TICKET1)   // Busca o peso no Guardian
		nPesoB := nPeso
	Endif

	If _cdTpRoman == "E"
		cPlaca      := SZE->ZE_PLACA
		cZE_TICKET1 := SZE->ZE_TICKET1
		nPeso  := BuscaPeso(cZE_TICKET1)   // Busca o peso no Guardian
		nPesoB := nPeso
	EndIf
	
	If INCLUI
		While (cRomaneio := getSx8Num("SZE","ZE_ROMAN")) < ProxNum("SZE","ZE_ROMAN")
			ConfirmSX8()
		Enddo
	Else
		cRomaneio := SZE->ZE_ROMAN
	EndIf
	
	//cRomaneio := If( INCLUI, GetSX8Num("SZE", "ZE_ROMAN"), SZE->ZE_ROMAN)
	//cRomaneio := If( INCLUI, _GetNum("SZE","ZE_ROMAN") , SZE->ZE_ROMAN)
    If Inclui .And. Empty(cRomaneio)
       Alert('Nao Foi Possivel Selecionar o numero do romaneio!')
       Return
    EndIf
	// Cria tabela temporária para marcação dos itens

	AAdd( aStruct , { "TMP_ORCAM"  , "C", 006, 0} )  // Pedido de venda //Orçamento do Loja
	AAdd( aStruct , { "TMP_DOC"    , "C", 009, 0} )  // Nota Fiscal
	AAdd( aStruct , { "TMP_SERIE"  , "C", 003, 0} )  // Serie da N.F.
	AAdd( aStruct , { "TMP_BAIRRO" , "C", 015, 0} )  // Bairro para entregue
	AAdd( aStruct , { "TMP_CLIENT" , "C", 006, 0} )  // Código Cliente
	AAdd( aStruct , { "TMP_LOJA"   , "C", 002, 0} )  // Loja Cliente
	AAdd( aStruct , { "TMP_NOMCLI" , "C", 030, 0} )  // Nome Cliente
	AAdd( aStruct , { "TMP_DTVEND" , "D", 008, 0} )  // Data da venda
	AAdd( aStruct , { "TMP_NOMREC" , "C", 030, 0} )  // Nome receptor
	AAdd( aStruct , { "TMP_DATREC" , "D", 008, 0} )  // Data da Entrega da mercadoria para o cliente
	AAdd( aStruct , { "TMP_HORREC" , "C", 005, 0} )  // Hora da Entrega da mercadoria para o cliente
	AAdd( aStruct , { "TMP_STATUS" , "C", 001, 0} )  // Hora da Entrega da mercadoria para o cliente
	AAdd( aStruct , { "TMP_RECNO"  , "N", 006, 0} )  // Identificador único
	AAdd( aStruct , { "TMP_PBRUTO" , "N", 016, 6} )  // Identificador único
	AAdd( aStruct , { "TMP_PLIQUI" , "N", 016, 6} )  // Identificador único
	AAdd( aStruct , { "TMP_OBSENT" , "C", 100, 0} )  // Identificador único
	AAdd( aStruct , { "TMP_OK"	   , "C", 001, 0} )    // Item para marcação
	AAdd( aStruct , { "TMP_TIPO"   , "C", 001, 0} )    //Tipo do Item Entrada / Saida

	cArq := CriaTrab(aStruct,.T.)
	cInd := Criatrab(Nil,.F.)
	//  .--------------------------------------------
	// |     Criacão do alias e do indice temporário
	//  '--------------------------------------------
	Use &cArq Alias TMP New Exclusive
	IndRegua("TMP", cInd, "TMP_BAIRRO",,, "Aguarde selecionando registros....")
	//  .---------------------------------------------
	// |     Query para alimentar a tabela temporária
	//  '---------------------------------------------
	fTabTmp(nOpc)
	//  .------------------------------------------------
	// |     Gravação da tabela temporária para marcação
	//  '------------------------------------------------
	While !WWW->(EOF())
		RecLock("TMP",.T.)
		TMP->TMP_ORCAM   := WWW->ZE_ORCAMEN
		TMP->TMP_DOC     := WWW->ZE_DOC
		TMP->TMP_SERIE   := WWW->ZE_SERIE
		TMP->TMP_BAIRRO  := WWW->ZE_BAIRRO
		TMP->TMP_CLIENT  := WWW->ZE_CLIENTE
		TMP->TMP_LOJA    := WWW->ZE_LOJACLI
		TMP->TMP_NOMCLI  := WWW->ZE_NOMCLI
		TMP->TMP_DTVEND  := sTod(WWW->ZE_DTVENDA)
		TMP->TMP_RECNO   := WWW->R_E_C_N_O_
		TMP->TMP_NOMREC  := WWW->ZE_NOMREC
		TMP->TMP_DATREC  := sTod(WWW->ZE_DTREC)
		TMP->TMP_HORREC  := WWW->ZE_HORREC
		TMP->TMP_PLIQUI  := WWW->ZE_PLIQUI
		TMP->TMP_STATUS  := WWW->ZE_STATUS
		TMP->TMP_PBRUTO  := WWW->ZE_PBRUTO
		TMP->TMP_OBSENT  := WWW->ZE_OBSENT
		TMP->TMP_TIPO    := WWW->ZE_TIPO

		If !Inclui .And. nOpc <> 6 .And. !Empty(WWW->ZE_ROMAN)
			TMP->TMP_OK := cMarca
			nMarca++
			nTotalP += TMP->TMP_PLIQUI
			nTotalB += TMP->TMP_PBRUTO
		EndIf
		MsunLock()
		WWW->(dbSkip())
	End

	WWW->(dbCloseArea())

	dbSelectArea("TMP")
	dbGoTop()

	If !TMP->(Eof()) //.And. !TMP->(Bof())
		lSemPeso := (nOpc <> 5 .Or. nPeso <= 0)

		//  .--------------------------------------------------------------
		// |     Adiciona os campos a serem exibidos no Browsed de Seleção
		//  '--------------------------------------------------------------
		aAdd( aCpoBrw, { "TMP_OK"     ,, ""            , "@!" 			 	     } )
		aAdd( aCpoBrw, { "TMP_TIPO"   ,, "Tipo"        , "@!" 			 	     } )
		aAdd( aCpoBrw, { "TMP_ORCAM"  ,, "Pedido"      , "@!" 			 	     } )
		aAdd( aCpoBrw, { "TMP_DOC"    ,, "Nota Fiscal" , "@!" 			 	     } )
		aAdd( aCpoBrw, { "TMP_SERIE"  ,, "Serie N.F."  , "@!" 			 	     } )
		aAdd( aCpoBrw, { "TMP_BAIRRO" ,, "Bairro"      , "@!" 			 	     } )
		aAdd( aCpoBrw, { "TMP_CLIENT" ,, "Cliente"     , "@!" 		  	 	     } )
		aAdd( aCpoBrw, { "TMP_LOJA"   ,, "Loja Cli"    , "@!" 			 	     } )
		aAdd( aCpoBrw, { "TMP_NOMCLI" ,, "Nome Cli"    , "@!" 			 	     } )
		aAdd( aCpoBrw, { "TMP_DTVEND" ,, "Data Venda"  , "@!" 			 	     } )
		aAdd( aCpoBrw, { "TMP_NOMREC" ,, "Receptor  "  , "@!"                  } )
		aAdd( aCpoBrw, { "TMP_DATREC" ,, "Data Entrega", "@!"                  } )
		aAdd( aCpoBrw, { "TMP_HORREC" ,, "Hora Entrega", "@E 99:99"            } )
		aAdd( aCpoBrw, { "TMP_STATUS" ,, "Status"      , "@!"			           } )
		aAdd( aCpoBrw, { "TMP_PLIQUI" ,, "Peso Liquido", "@E 9,999,999.999999" } )
		aAdd( aCpoBrw, { "TMP_PBRUTO" ,, "Peso Bruto"  , "@E 9,999,999.999999" } )
		aAdd( aCpoBrw, { "TMP_OBSENT" ,, "Peso Bruto"  , "@E 9,999,999.999999" } )
		aAdd( aCpoBrw, { "TMP_RECNO"  ,, "Cod Interno" , "@E 9999999"          } )

		DEFINE MSDIALOG oDlg TITLE "Seleção de itens para Romaneio" FROM 00,00 TO 407,900 PIXEL

		@ 010,005 SAY "Romaneio"     PIXEL OF oDlg
		@ 010,080 SAY "Placa"        PIXEL OF oDlg
		@ 010,170 SAY "Motorista"    PIXEL OF oDlg
		@ 010,250 SAY "Nome"         PIXEL OF oDlg

		@ 005,400 SAY oTkt1 VAR "TICKET"    PIXEL OF oDlg FONT oFonte1 COLOR CLR_HBLUE
		@ 015,397 SAY oTkt2 VAR cZE_TICKET1 PIXEL OF oDlg FONT oFonte2 COLOR CLR_HRED
		Ticket()

		@ 010,030 GET cRomaneio SIZE 030,20 PICTURE "@!"          OBJECT oRomaneio  WHEN .F.

		//@ 010,105 GET cCodMoto  SIZE 030,20 PICTURE "@!"          OBJECT oCodMoto   WHEN lMoto .And. nOpc<>6 .And. nOpc <> 2 .And. nOpc <> 6 F3 "SZF" Valid fValMoto(cCodMoto)
		//@ 010,190 GET cNomMoto  SIZE 100,20 PICTURE "@!"          OBJECT oNomMoto   WHEN .F.
		//@ 010,360 GET cPlaca    SIZE 040,20 PICTURE "@R AAA-9999" OBJECT oPlaca     WHEN lMoto .And. nOpc<>6 .And. nOpc <> 2 .And. nOpc <> 6

		@ 010,105 GET cPlaca    SIZE 040,20 PICTURE "@R AAA-9999" OBJECT oPlaca     F3 "TKTGUA" WHEN lMoto .And. nOpc <> 2 .And. nOpc <> 6 .And. lSemPeso
		@ 010,200 GET cCodMoto  SIZE 030,20 PICTURE "@!"          OBJECT oCodMoto   WHEN lMoto .And. nOpc <> 2 .And. nOpc <> 6 .And. lSemPeso F3 "SZFPLC" Valid fValMoto(cCodMoto)
		@ 010,270 GET cNomMoto  SIZE 100,20 PICTURE "@!"          OBJECT oNomMoto   WHEN .F.

		@ 025,005 SAY "Ajudante 1" PIXEL OF oDlg
		@ 025,125 SAY "Ajudante 2" PIXEL OF oDlg
		@ 025,250 SAY "Obs "       PIXEL OF oDlg

		@ 025,040 GET cAjuda1   SIZE 060,20 PICTURE "@!"          OBJECT oAjuda1    WHEN (nOpc <> 2 .And. nOpc <> 6)
		@ 025,160 GET cAjuda2   SIZE 060,20 PICTURE "@!"          OBJECT oAjuda2    WHEN (nOpc <> 2 .And. nOpc <> 6)
		@ 025,270 GET cObsRoma  SIZE 130,20 PICTURE "@!"          OBJECT oObsRoma   WHEN (nOpc <> 2 .And. nOpc <> 6)

		If nOpc == 5 .Or. nOpc == 2
			@ 040,005 SAY "Responsável" PIXEL OF oDlg COLOR CLR_HRED
			@ 040,050 MSCOMBOBOX oCby VAR cCby ITEMS aCby SIZE 050, 65 OF oDlg PIXEL ON CHANGE fValRespo(cCby, @cCodMoto, @cNomMoto, @cPlaca, @lMoto) When (nOpc <> 2)

			@ 040,120 SAY "Peso :" PIXEL OF oDlg COLOR CLR_HRED
			@ 040,150 GET nPeso    SIZE 050,20 PICTURE "@E 9,999,999.999"  OBJECT oPeso WHEN (nOpc == 5 .And. nPeso == 0) Valid AAENTP1V(nPeso,cTmp)
		EndIf

		@ 040,220 SAY "Ordenar" PIXEL OF oDlg
		@ 040,255 MSCOMBOBOX oCbx VAR cCbx ITEMS aCbx SIZE 050, 65 OF oDlg PIXEL ON CHANGE fValCombo(cInd, cCbx)

		@ 040,315 SAY "Pesquisar " PIXEL OF oDlg
		@ 040,350 GET cBusca SIZE 050,20 PICTURE "@!" VALID BuscaItem(@oMark,@cBusca, cCbx) OBJECT oBusca

		oMark:= MsSelect():New( cTmp, "TMP_OK",,aCpoBrw,, cMarca, { 060, 005, 185, 400 } ,,, )
		oMark:oBrowse:Refresh()
		oMark:bAval               := { || (Marcar(cTmp,cMarca,@nMarca,.F., @nTotalB, @nTotalP,nOPc), oMark:oBrowse:Refresh() ) }
		oMark:oBrowse:lHasMark    := .T.
		oMark:oBrowse:lCanAllMark := nOpc <> 6 //.T.
		oMark:oBrowse:bAllMark    := { || ( MarcaTudo(cTmp,cMarca,@nMarca,.F., @nTotalB, @nTotalP,nOPc), oMarca:Refresh(),  oMark:oBrowse:Refresh(.T.) ) }

		@ 190,050 SAY "Marcados: " PIXEL OF oDlg
		@ 190,090 GET nMarca SIZE 30,20 PICTURE "@E 999999"             OBJECT oMarca WHEN .F.

		@ 190,130 SAY "Peso Liquido: "    PIXEL OF oDlg
		@ 190,170 GET nTotalP SIZE 90,20 PICTURE "@E 999,999,999.999999" OBJECT oTotalP WHEN .F.

		@ 190,270 SAY "Peso Bruto: "    PIXEL OF oDlg
		@ 190,310 GET nTotalB SIZE 90,20 PICTURE "@E 999,999,999.999999" OBJECT oTotalB WHEN .F.

		DEFINE SBUTTON oBtn1 FROM 035,420 TYPE 1 ACTION (nOpcA := _doOk(nOpc), iIF(nOpcA == 1 , oDlg:End() , 0) )  ENABLE
		DEFINE SBUTTON oBtn2 FROM 060,420 TYPE 2 ACTION (nOpcA := 0,oDlg:End()) ENABLE

		oMark:oBrowse:SetFocus()

		ACTIVATE MSDIALOG oDlg CENTERED

		//FreeUsedCode()
		If nOpcA == 1
			//  		Begin Transaction                              
			If nOpc <> 2
				If INCLUI
					ConfirmSX8()
				Endif
				fGerAcols(cRomaneio, cCodMoto, cPlaca, cNomMoto, cCby, nPeso, nOpc, cAjuda1,cAjuda2, cObsRoma )
			EndIf

			//	If INCLUI
			//		ConfirmSX8()
			//	Endif
			//	End Transaction			
		Else 
			RollBackSX8()
		Endif

	Else
		MsgStop("Não foram encontrados dados para seleção!")
	Endif

	TMP->(dbCloseArea())
	FErase(cArq+GetDBExtension())
	FErase(cInd+OrdBagExt())
	dbSelectArea(cAlias)

	If ExistBLock("ETP01FIM")
		ExecBlock("ETP01FIM",.F.,.F.,{nOpc,_cdTpRoman})
	EndIf

Return Nil


Static Function _doOk(nOpc)
	_ndOpc := 1

	If nMarca > 0 .OR. !INCLUI
		If Empty(Alltrim(cObsRoma))
			Aviso('Atenção','Necessario Informar Observação do Romaneio',{'OK'})
			_ndOpc := 0
		Endif
		If lSemPeso .Or. AAENTP1V(nPeso,cTmp)
			_ndOpc := _fValMotor(cCodMoto, cPlaca, cNomMoto, cCby, nOpc, nPeso)
		Else
			_ndOpc := 0
		EndIf
	Else
		_ndOpc := 0
		Alert("Não foi selecionado nenhum item!")
	Endif
	//If( nMarca > 0 .OR. !INCLUI,nOpcA := ,)
Return _ndOpc
//*********************************************************************************************************
//  .-----------------------------------------------------------------------------------
// |     Valida dados do motorista antes de gravar os dados e fechar a tela de inclusão
//  '-----------------------------------------------------------------------------------
Static Function _fValMotor(cCodMoto, cPlaca, cNomMoto, cTipo, nwOpc, nPeso)

Local _ldTicket := .F.

	conout(Left(GetClientIP(),11))
	conout(FwFilial())
	conout(getcomputername())
	_ldTicket := Empty(cZE_TICKET1) .And. !cEmpAnt$'05' .And. !(cEmpAnt$'01' .And.  (FwFilial()$"01" .And. Alltrim(getcomputername())$"AAPCALMOX001L/AAPCEXP001L/AAPCEXP002L/AAPCEXP004L/AAPCBAL001P2/AAPCEXPED002L2/AASRVPROTHEUS" /*Left(GetClientIP(),11)=='192.168.16.'*/) .Or. (Alltrim(cPlaca)=="RET0000" .And. Alltrim(cCodMoto)=="000009") ) 
	If (Empty(cCodMoto) .or. Empty(cPlaca) .or. Empty(cNomMoto) .Or. _ldTicket )  .Or.  (nwOpc == 5 .And. nPeso <= 0)  //AllTrim(cTipo) <> "Cliente"
			MsgStop("Informe todos os dados do motorista, veículo, placa, peso! " + If(_ldTicket," e ticket","") )
			Return 0
	EndIf
	


Return 1
//*********************************************************************************************************

Static Function BuscaItem(oMark,cBusca, cCbx )
	TMP->(dbSeek(AllTrim(cBusca),.T.))
	cBusca := Space(30)
	oMark:oBrowse:SetFocus()
	oMark:oBrowse:Refresh()
Return

//*********************************************************************************************************

Static Function MarcaTudo(cAlias,cMarca,nMarca, nTotalB, nTotalP, nwOpc )
	Local nReg  := (cAlias)->(Recno())
	Local lTudo := (nMarca <> (cAlias)->(RecCount()))   // Identifica se todos os itens estão marcados

	// Se nem todos os itens estiverem marcados, então marca tudo. Senão, desmarca tudo
	nMarca  := If( lTudo , 0, nMarca )
	nTotalB := If( lTudo , 0, nTotalB)
	nTotalP := If( lTudo , 0, nTotalP)

	dbSelectArea(cAlias)
	dbGoTop()
	While !Eof()
		Marcar(cAlias,cMarca,@nMarca,lTudo,@nTotalB,@nTotalP, nwOpc )
		dbSkip()
	Enddo
	dbGoTo(nReg)

Return .T.

//*********************************************************************************************************

Static Function Marcar(cAlias,cMarca,nMarca,lTudo, nTotalB, nTotalP, nwOpc )

	If nwOpc == 2 .Or. nwOpc == 5
		Return Nil
	EndIf

	RecLock(cAlias,.F.)

	//Diego Rafael
	/*
	_ldMarca := Empty ( (cAlias)->TMP_OK )

	If _ldMarca 
	If nMarca <= 0
	_cdTipo := (cAlias)->TMP_TIPO
	_ldMarca := .T.
	Else
	_ldMarca := _cdTipo == (cAlias)->TMP_TIPO
	EndIF	
	EndIf
	*/
	(cAlias)->TMP_OK := If( lTudo .Or. Empty(TMP_OK) , cMarca, Space(Len(TMP_OK)))

	If Empty((cAlias)->TMP_OK)
		nMarca--
		nTotalB -= (cAlias)->TMP_PBRUTO
		nTotalP -= (cAlias)->TMP_PLIQUI
	Else
		nMarca++
		nTotalB += (cAlias)->TMP_PBRUTO
		nTotalP += (cAlias)->TMP_PLIQUI
		If nwOpc == 6
			DadosRet(cAlias, .T.)
		EndIf
	Endif

	MsUnLock()

	nMarca  := If( nMarca  < 0, 0, nMarca)
	nTotalB := If( nTotalB < 0, 0, nTotalB)
	nTotalP := If( nTotalP < 0, 0, nTotalP)

	oMarca:Refresh()
	oTotalB:Refresh()
	oTotalP:Refresh()
Return

//*********************************************************************************************************

Static Function LimpaTudo(cAlias,cMarca,nMarca)
	Local nReg  := (cAlias)->(Recno())
	Local lTudo := (nMarca <> (cAlias)->(RecCount()))   // Identifica se todos os itens estão marcados

	// Se nem todos os itens estiverem marcados, então marca tudo. Senão, desmarca tudo
	nMarca := 0

	dbSelectArea(cAlias)
	dbGoTop()

	While !Eof()
		RecLock(cAlias,.F.)
		(cAlias)->TMP_OK := Space(Len(TMP_OK))
		MsUnLock()

		dbSkip()
	Enddo

	dbGoTo(nReg)

Return .T.

//**************************************************************************************

Static Function fTabTmp(nOpc)
	Local cQry := ""

	cQry := "SELECT * "
	cQry += " FROM "+RetSQLName("SZE")+" A (NOLOCK) "
	cQry += " WHERE A.D_E_L_E_T_ = '' "
	cQry += " AND ZE_FILIAL = '" + xFilial("SZE") + "' "

	//Checa se o Campo Tipo Existe
	If SZE->(FieldPos('ZE_TIPO')) > 0
		cQry += " And ZE_TIPO = '" + _cdTpRoman + "' "
	EndIf

	If INCLUI
		cQry += " AND ZE_ROMAN  = '' "
	ElseIf nOpc == 4
		cQry += " AND ( ZE_ROMAN  = '"+SZE->ZE_ROMAN +"'"
		cQry += "  OR   ZE_ROMAN  = ' ' ) "
		cQry += " AND ZE_STATUS NOT IN ('C', 'E', 'V', 'N', 'D') "
	ElseIf nOpc == 2
		cQry += " AND ZE_ROMAN  = '"+SZE->ZE_ROMAN +"' "
	Else
		cQry += " AND ZE_ROMAN  = '"+SZE->ZE_ROMAN +"' "
		cQry += " AND ZE_STATUS NOT IN ('C', 'E', 'V', 'N', 'D') "
	EndIf	
	cQry += " ORDER BY ZE_BAIRRO "

	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "WWW", .T., .F. )

Return NIL

//*********************************************************************************************************

Static Function fGerAcols(cRomaneio, cMotorista, cPlaca, cNome, cTipo, nPeso, nOpc,cAjuda1,cAjuda2, cObsRoma )
	Local cwDoc    := ""
	Local cwStatus := ""
	Local nwItem   := 0
	Local vNovo    := {}
	Local cAuxDoc  := ""

	TMP->(dbGotop())
	While !TMP->(Eof())

		cwDoc    := ""
		cwStatus := ""

		If AllTrim(cTipo) == "Cliente"
			DadosRet("TMP", .F.)
		EndIf

		SZE->(dbGoto(TMP->TMP_RECNO))

		If !SZE->(Eof())
			//  .-------------------------
			// |    Se o item foi marcado
			//  '-------------------------
			SZE->(Reclock("SZE", .F.))
			If !Empty(TMP->TMP_OK)

				SZE->ZE_ROMAN   := cRomaneio
				SZE->ZE_MOTOR   := cMotorista
				SZE->ZE_NOMOTOR := cNome
				SZE->ZE_PLACA   := cPlaca
				SZE->ZE_DTREC   := TMP->TMP_DATREC
				SZE->ZE_HORREC  := TMP->TMP_HORREC
				SZE->ZE_NOMREC  := TMP->TMP_NOMREC
				SZE->ZE_PESO    := nPeso

				SZE->ZE_AJUDA01 := cAjuda1
				SZE->ZE_AJUDA02 := cAjuda2
				SZE->ZE_OBSERV  := cObsRoma
				SZE->ZE_OBSENT  := TMP->TMP_OBSENT
				SZE->ZE_TICKET1 := cZE_TICKET1

				dPesoFinal := ""
				hPesoFinal := ""

				cAuxDoc += SZE->ZE_DOC +","

				PesoFinal(cZE_TICKET1, @dPesoFinal, @hPesoFinal)
				IF !Empty(dPesoFinal)
					SZE->ZE_DTPESO  := STOD(dPesoFinal)
					SZE->ZE_HRPESO  := hPesoFinal
				EndIf

				If nOpc == 5
					If AllTrim(cTipo) == "Cliente"
						SZE->ZE_STATUS := "B"

						_cStPedido    := "6"
						_cObsPedido   := "Entregue"
					Else
						SZE->ZE_STATUS := "R"
						SZE->ZE_DTSAIDA := Date()

						_cStPedido    := "5"
						_cObsPedido   := "Em Romaneio"
					EndIf
				ElseIf nOpc == 3 .Or. nOpc == 4
					SZE->ZE_STATUS := "P"
					SZE->ZE_DTSAIDA := Date()
				ElseIf nOpc == 6
					SZE->ZE_STATUS := TMP->TMP_STATUS

					If TMP->TMP_STATUS <> "E" .And. TMP->TMP_STATUS <> 'R'
						cwFilial := SZE->ZE_FILIAL
						cwClient := SZE->ZE_CLIENTE
						cwLoja   := SZE->ZE_LOJACLI
						cwNomCli := SZE->ZE_NOMCLI
						cwOrcam  := SZE->ZE_ORCAMEN
						cwSeq    := StrZero(val(SZE->ZE_SEQ)+1, 2)
						cwValor  := SZE->ZE_VALOR
						cwDataV  := SZE->ZE_DTVENDA
						cwBairro := SZE->ZE_BAIRRO
						cwOrigem := SZE->ZE_ORIGEM
						cwVend   := SZE->ZE_VEND
						cwFilOri := SZE->ZE_FILORIG
						cwDoc    := SZE->ZE_DOC
						cwSerie  := SZE->ZE_SERIE
						cwPliqui := SZE->ZE_PLIQUI
						cwPbruto := SZE->ZE_PBRUTO
						cwTicket := SZE->ZE_TICKET1
						cwStatus := SZE->ZE_STATUS

						_cStPedido    := "4"
						_cObsPedido   := "Faturado"

					elseif TMP->TMP_STATUS = "E"
						_cStPedido    := "6"
						_cObsPedido   := "Entregue"

					EndIf
				EndIf

				u_AALOGE01(SZE->ZE_ROMAN,SZE->ZE_DOC,SZE->ZE_SERIE, "Status Modificado para " + SZE->ZE_STATUS + "(" + aLegenda[aScan(aLegenda,{|X| X[01] == SZE->ZE_STATUS})][02] + ")")

			ElseIf !Empty(SZE->ZE_ROMAN) .And. nOpc = 4

				u_AALOGE01(SZE->ZE_ROMAN,SZE->ZE_DOC,SZE->ZE_SERIE, "Excluido de Pre-romaneio, Retorno para Status (Em Aberto)")

				SZE->ZE_ROMAN   := ""
				SZE->ZE_STATUS  := ""
				SZE->ZE_DTSAIDA := cTod("  /  /    ")
				SZE->ZE_MOTOR   := ""
				SZE->ZE_NOMOTOR := ""
				SZE->ZE_PLACA   := ""
				SZE->ZE_DTREC   := cTod("  /  /    ")
				SZE->ZE_HORREC  := ""
				SZE->ZE_NOMREC  := ""
				SZE->ZE_PESO    := 0
				SZE->ZE_AJUDA01 := ""
				SZE->ZE_AJUDA02 := ""
				SZE->ZE_OBSERV  := ""
				SZE->ZE_OBSENT  := ""
				SZE->ZE_TICKET1 := ""
			EndIf

			SZE->(MsUnlock())

			if Type("_cStPedido") != "U"

				SD2->(dbSetOrder(3))
				SD2->(dbSeek(xFilial('SD2') + SZE->ZE_DOC + SZE->ZE_SERIE) )
				While SD2->(D2_FILIAL + D2_DOC + D2_SERIE) ==  xFilial('SD2') + SZE->ZE_DOC + SZE->ZE_SERIE
					If SC5->(dbSeek( SD2->D2_FILIAL + SD2->D2_PEDIDO ))

						//Historico
						//Comentado para compilar na AMAZONACO SEM PROBLEMA
						aDados := {}
						aAdd(aDados,{'Z5_PEDIDO',SC5->C5_NUM})
						aAdd(aDados,{'Z5_PRODUTO',SD2->D2_COD })
						aAdd(aDados,{'Z5_DATA',dDataBase})
						aAdd(aDados,{'Z5_HORA',SubStr(Time(),1,5)})
						aAdd(aDados,{'Z5_USER',cUserName})
						aAdd(aDados,{'Z5_OP',''})
						aAdd(aDados,{'Z5_OBS',_cObsPedido})
						aAdd(aDados,{'Z5_STATUS', _cstPedido})
						aAdd(aDados,{'Z5_ENTREGA', STOD('') }  )

						If ExistBlock("AALOGE02")
							u_AALOGE02(aDados)
						EndIf
					EndIf
					SD2->(dbSkip())
				EndDo
			EndIf

			If !Empty(cwDoc) .and. cwStatus <> "D"
				RecLock("SZE", .T.)
				SZE->ZE_FILIAL  := cwFilial
				SZE->ZE_CLIENTE := cwClient
				SZE->ZE_LOJACLI := cwLoja
				SZE->ZE_NOMCLI  := cwNomCLi
				SZE->ZE_ORCAMEN := cwOrcam
				SZE->ZE_SEQ     := cwSeq
				SZE->ZE_VALOR   := cwValor
				SZE->ZE_DTVENDA := cwDataV
				SZE->ZE_BAIRRO  := cwBairro
				SZE->ZE_ORIGEM  := cwOrigem
				SZE->ZE_VEND    := cwVend
				SZE->ZE_FILORIG := cwFilOri
				SZE->ZE_DOC     := cwDoc
				SZE->ZE_SERIE   := cwSerie
				SZE->ZE_STATUS  := ""
				SZE->ZE_PLIQUI  := cwPliqui
				SZE->ZE_PBRUTO  := cwPbruto
				SZE->ZE_TICKET1 := cZE_TICKET1

				dPesoFinal := ""
				hPesoFinal := ""

				PesoFinal(cZE_TICKET1, @dPesoFinal, @hPesoFinal)
				IF !Empty(dPesoFinal)
					SZE->ZE_DTPESO  := STOD(dPesoFinal)
					SZE->ZE_HRPESO  := hPesoFinal
				EndIf

				u_AALOGE01(SZE->ZE_ROMAN,SZE->ZE_DOC,SZE->ZE_SERIE, "Inclusao de novos Registros")

				MsUnLock()
			EndIf

		EndIf
		TMP->(dbSkip())
	End

	
	If !Empty(cZE_TICKET1) .And. !Empty(cAuxDoc)
		AtuGuardian(cZE_TICKET1, PADR(cAuxDoc, 250), 1  )
	EndIf

Return Nil

Static Function fValCombo(cInd, cCbx)

	dbSelectArea("TMP")
	dbClearIndex()
	FErase(cInd+OrdBagExt())

	If cCbx == "Bairro"
		IndRegua("TMP", cInd, "TMP_BAIRRO",,, "Aguarde selecionando registros....")
	ElseIf cCbx == "Pedido"
		IndRegua("TMP", cInd, "TMP_ORCAM",,, "Aguarde selecionando registros....")
	ElseIf cCbx == "Cliente"
		IndRegua("TMP", cInd, "TMP_CLIENT",,, "Aguarde selecionando registros....")
	ElseIf cCbx == "Nota Fiscal"
		IndRegua("TMP", cInd, "TMP_DOC"	 ,,, "Aguarde selecionando registros....")
	Else
		IndRegua("TMP", cInd, "TMP_NOMCLI",,, "Aguarde selecionando registros....")
	EndIf

	oMark:oBrowse:Refresh()

Return Nil

//*********************************************************************************************************

Static Function fValRespo(cCby, cCodMoto, cNomMoto, cPlaca, lMoto)
	If cCby == "Cliente"
		//	cCodMoto := Space(06)
		//	cNomMoto := Space(30)
		//	cPlaca   := Space(10)
		lMoto    := .T.
	Else
		lMoto    := .T.
	EndIf
	oCodMoto:Refresh()
Return Nil

//*********************************************************************************************************

Static Function fValMoto(cCodMoto)

	If !Vazio(cCodMoto)
		SZF->(dbSetOrder(1))
		If !SZF->(dbSeek( xFilial("SZF") + cCodMoto ))
			MsgStop("Motorista não encontrado!")
			Return .F.
		Endif
	EndIf

Return .T.

//*********************************************************************************************************

User Function ENTP01d()
	BrwLegenda("Cadastro de Romaneio","Legendas",;
	{{"ENABLE"    , "Em aberto"},;
	{"BR_PINK"    , "Pré-Romaneio"},;
	{"BR_AMARELO" , "Romaneio"    },;
	{"BR_VERMELHO", "Entregue"    },;
	{"BR_LARANJA" , "Nova Entrega"},;
	{"BR_CINZA"   , "Vem Buscar"  },;
	{"BR_AZUL"    , "Endereço não encontrado"},;
	{"BR_PRETO"   , "Venda com Devolução"},;
	{"BR_MARROM"  , "Venda Estornada do Romaneio"},;
	{"PMSEDT1"    , "Liberação Especial"},;
	{"BR_BRANCO"  , "Local Fechado"}})

Return Nil

//**************************************************************************************

Static Function DadosRet(cAlias, lwVal)
	Local cNome   := Space(30)
	Local dDtRec  := dDataBase
	Local cHorRec := Time()
	Local lRet    := .T.
	Local cTipo   := Space(30)
	Local aItems  := {"Entregue", "Endereço não Encontrado", "Local Fechado", "Devolução"}
	Local cArea   := GetArea()
	Local cObsEnt := TMP->TMP_OBSENT

	If TMP->TMP_STATUS <> "R" .And. lwVal
		MsgBox("Favor escolher um registro em  Romaneio!")
		Return Nil
	EndIf

	If _cdTpRoman == "E"
		aItems  := {"Entregue", "Devolução"}
	EndIf

	DEFINE Font oFnt3 Name "Ms Sans Serif" Bold

	DEFINE MSDIALOG oDlgMain TITLE "Cabeçalho de Entrega - Nota: " + TMP->TMP_DOC FROM 96,5 TO 320,450 PIXEL

	@ 015,15 SAY "Status Ent.: "  SIZE 35,8 OF oDlgMain PIXEL Font oFnt3
	@ 015,70 MSCOMBOBOX oTipo VAR cTipo ITEMS aItems SIZE 100,50 OF  oDlgMain PIXEL

	@ 030, 015 SAY "Nome Receb. : " SIZE 190,10 OF oDlgMain PIXEL Font oFnt3; @ 030, 070 GET cNome   PICTURE "@!"       SIZE 100,8 PIXEL OF oDlgMain WHEN Alltrim(cTipo) = "Entregue"
	@ 045, 015 SAY "Data Receb. : " SIZE 190,10 OF oDlgMain PIXEL Font oFnt3; @ 045, 070 GET dDtRec  PICTURE "99/99/99" SIZE 040,8 PIXEL OF oDlgMain WHEN !Empty(cNome) //.or. AllTrim(cTipo) <> "Entregue"
	@ 060, 015 SAY "Hora Receb. : " SIZE 220,10 OF oDlgMain PIXEL Font oFnt3; @ 060, 070 GET cHorRec PICTURE "99:99"    SIZE 030,8 PIXEL OF oDlgMain WHEN !Empty(cNome) //.Or. Alltrim(cTipo) <> "Entregue"
	@ 075, 015 SAY "Obs. Entrega: " SIZE 220,10 OF oDlgMain PIXEL Font oFnt3; @ 075, 070 GET cObsEnt PICTURE "@! "      SIZE 100,8 PIXEL OF oDlgMain WHEN !Empty(cNome) //.Or. Alltrim(cTipo) <> "Entregue"
	Ø
	@ 095, 070 BMPBUTTON TYPE 1 ACTION IIF(Empty(cNome) .And. Alltrim(cTipo) == "Entregue" , MsgAlert("Informe o nome de quem recebeu a mercadoria!!!","ATENÇÃO"), oDlgMain:End())
	@ 095, 140 BMPBUTTON TYPE 2 ACTION IIF( lwVal, (lRet := .F., oDlgMain:End()) ,  )

	bCancel := {|| oDlgMain:End() }

	ACTIVATE MSDIALOG oDlgMain CENTERED

	If lRet
		RecLock(cAlias,.F.)
		TMP->TMP_DATREC := dDtRec
		TMP->TMP_HORREC := cHorRec
		TMP->TMP_NOMREC := cNome
		TMP->TMP_OBSENT := cObsEnt

		If AllTrim(cTipo) == "Entregue"
			TMP->TMP_STATUS := "E"
		ElseIf AllTrim(cTipo) == "Endereço não Encontrado"
			TMP->TMP_STATUS := "V"
		ElseIf AllTrim(cTipo) == "Local Fechado"
			TMP->TMP_STATUS := "N"
		ElseIf AllTrim(cTipo) == "Devolução"
			TMP->TMP_STATUS := "D"
		EndIf
		MsUnLock()
	EndIf

Return lRet

User Function ENTP01E()
	Local cArea := GetARea()

	If !(__CUSERID $ SUPERGETMV("MV_XCANROM") )

		MsgStop("Usuário sem permissão para utilização desta rotina!!!")

		RestArea( cArea )

		Return Nil
	EndIf

	If SZE->ZE_STATUS <> "R"
		MsgStop("Favor escolher um romaneio!!!")
	ElseIf MsgNoYes("Deseja cancelar o romaneio? Os registros voltarão para Pré-Romaneio ")

		fVerTmp(SZE->ZE_ROMANT)
		If !TEMP1->(Eof())
			While !TEMP1->(Eof())
				SZE->(dbGoto(TEMP1->R_E_C_N_O_))
				If !SZE->(Eof())
					Reclock("SZE", .F.)
					SZE->ZE_PESO    := 0
					SZE->ZE_STATUS  := "P"
					SZE->ZE_DTSAIDA := cTod("  /  /    ")
					SZE->ZE_DTREC   := cTod("  /  /    ")
					SZE->ZE_HORREC  := ""
					SZE->ZE_NOMREC  := ""
					SZE->ZE_OBSENT  := ""
					u_AALOGE01(SZE->ZE_ROMAN,SZE->ZE_DOC,SZE->ZE_SERIE, "Status Modificado para " + SZE->ZE_STATUS + "(" + aLegenda[aScan(aLegenda,{|X| X[01] == SZE->ZE_STATUS})][02] + ")")
					MsUnlock()
				EndIf
				TEMP1->(dbskip())
			End
		EndIf
		TEMP1->(dbCloseArea('TEMP1'))
	EndIf

	RestArea( cArea )

Return Nil

//**************************************************************************************

Static Function fVerTmp(cRomaneio)
	Local cQry := ""

	cQry := "SELECT * "
	cQry +=  " FROM "+RetSQLName("SZE")+" A (NOLOCK)"
	cQry += " WHERE A.D_E_L_E_T_ = '' "
	cQry +=   " AND ZE_FILIAL  = '" + xFilial("SZE") + "' "
	cQry +=   " AND ZE_ROMANT  = '" + cRomaneio +"' "
	cQry +=   " AND ZE_STATUS  = 'R' "
	cQry += "ORDER BY ZE_BAIRRO "

	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TEMP1", .T., .F. )

Return NIL

Static Function AAENTP1V(_nPeso,_cTmp)
	Local cArea := GetArea()
	Local _lRet := .T.

	Default _nPeso := 0
	Default _cTmp  := ''

	If _nPeso != _nPesoAnt
		If !Empty(_cTmp) .And. _nPeso != 0
			_nPesoT := 0
			(_cTmp)->(dbGoTop())
			While !(_cTmp)->(EOF())

				SZE->(dbGoTo( (_cTmp)->TMP_RECNO ) )

				If !SZE->(EOF())
					//Atualiza Peso da NoAta caso tenha Diferencao para o Total Calculado dos Produtos
					_nPesoR := AtuPeso(SZE->ZE_FILORIG,SZE->ZE_DOC,SZE->ZE_SERIE)
					// Verifica se o Total esta DIvergente do Total da Nota
					If SZE->ZE_PLIQUI != Round(_nPesoR,2) .And. _nPesoR > 0 
						// Atualiza o ZE_PLIQUI pois este tem que estar Igual ao F2_PLIQUI
						u_AALOGE01(SZE->ZE_ROMAN,SZE->ZE_DOC,SZE->ZE_SERIE, "PLIQUI Atualizado de (" + Alltrim(Str(SZE->ZE_PLIQUI)) + ") Para o Valor do Campo F2_PLIQUI que tambem foi Atualizado com a Soma do D2_QUANT * B1_PESO dos Itens da Nota")
						SZE->(RecLock('SZE',.F.))
						SZE->ZE_PLIQUI := _nPesoR
						SZE->(MsUnlock())
					EndIf

					_nPesoT += SZE->ZE_PLIQUI
				EndIf

				(_cTmp)->(dbSkip())
			EndDo
			If cEmpAnt != "05" //.And. !(cEmpAnt$'01' .And.  (FwFilial()$"01" .And. Left(GetClientIP(),11)=='192.168.16.') ) 
				If (_nPeso - _nPesoT) * 100 / _nPeso > SuperGetMv("MV_XPDIFP",.F.,1) 
					If Aviso('Operacao Indevida','Nao e Possivel informar PESO com variacao maior que ' + Alltrim(Str(SuperGetMv("MV_XPDIFP",.F.,1))) + '%, deseja senha do superior para liberacao?' ,{'Sim','Nao'}) == 1
						If _lRet := SenhaAut("MV_XIDUSER")
							_nPesoAnt := _nPeso
						EndIf
					else
						_lRet := .F.
					EndIf
				Else
					If (_nPesoT - _nPeso) * 100 / _nPeso > SuperGetMv("MV_XPDIFPM",.F.,5)
						If Aviso('Operacao Indevida','Nao e Possivel informar PESO com variacao maior que ' + Alltrim(Str(SuperGetMv("MV_XPDIFPM",.F.,5))) + '%, deseja senha do superior para liberacao?' ,{'Sim','Nao'}) == 1
							If _lRet := SenhaAut("MV_XIDLIBE")
								_nPesoAnt := _nPeso
							EndIf
						else
							_lRet := .F.
						EndIf
					EndIf
				Endif
			EndIf
		EndIf
	Endif

	RestArea( cArea )
Return _lRet

Static Function AtuPeso(_cFilial,_cDoc,_cSerie)
	Local aCampo := { "SD2->D2_COD", "SD2->D2_QUANT", "SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE", "SD2->D2_UM"}
	Local nPesoL := 0

	Default _cDoc   := ''
	Default _cSerie := ''
    
	SF2->(dbSetOrder(1))
	If SF2->(dbSeek(_cFilial + _cDoc + _cSerie))
		SD2->(dbSetOrder(3))
		if SD2->(dbSeek( _cFilial + _cDoc + _cSerie))
			nPesoL := u_CalcPeso(,,,,aCampo,"SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE","SD2")
			If nPesoL != SF2->F2_PLIQUI .And. nPesoL != 0
				SF2->(RecLock('SF2',.F.))
				SF2->F2_PLIQUI := nPesoL
				SF2->F2_PBRUTO := nPesoL
				SF2->(MsUnlock())
			EndIf
		EndIf
	EndIf

Return SF2->F2_PLIQUI

/*------------------------------------------------------------------------------------------*/
Static Function SenhaAut(_cParam)
	/*------------------------------------------------------------------------------------------*/
	Local cPassWord := Space(15)
	Local cUsuario  := Space(20)
	Local lRetAut   := .F.

	// Função de Senhas do SUPERIOR

	Define Font oFnt3 Name "Ms Sans Serif" Bold

	Define Msdialog oSenhas Title "AUTORIZACAO" From 190,110 to 300,370 Pixel

	@ 005,004 Say "Usuario   :" Size 220,10 Of oSenhas Pixel Font oFnt3
	@ 005,050 Get cUsuario     Picture "@!" Size 50,08 Pixel of oSenhas

	@ 015,004 Say "Senha   :" Size 220,10 Of oSenhas Pixel Font oFnt3
	@ 015,050 Get cPassWord   Picture "@!"  Size 50,08 Valid .T.  PASSWORD  Object oSenha

	@ 035,042 BmpButton Type 1 Action  iIf(lRetAut := ValSenha(cUsuario,cPassWord,_cParam),oSenhas:End(),'')

	If !Empty(cUsuario)
		oSenha:SetFocus()
	EndIf

	Activate Dialog oSenhas Centered

Return lRetAut

Static Function ValSenha(_cUser,_cPass,_cParam)
	Local _lRet := .T.

	If Upper(_cUser) == 'ADMINISTRADOR/ADMIN'
		Aviso('ATENCAO','Usuario "Administrador" não Autorizado a Efetuar Liberacao de Peso',{'OK'})
		_lRet := .F.
	EndIf

	PswOrder(2)
	If PswSeek(_cUser,.T.) .And. _lRet
		aInfUser := PswRet(1)
		if aInfUser[01][01] $ SuperGetMv(_cParam,.F.,'')
			If !PswName(_cPass)
				Aviso('Atencao','Senha de Usuario Invalida' ,{'Ok'},1)
				_lRet := .F.
			EndIf
		Else
			Aviso('Atencao','Usuario Nao Autorizado a Efetuar a Liberacao' ,{'Ok'},1)
			_lRet := .F.
		EndIf
	elseif _lRet
		Aviso('Atencao','Usuario: ' + _cUser + ' Nao Encontrado',{'Ok'},1)
		_lRet := .F.
	EndIf

Return _lRet

//******************************************************************************************************

Static Function AACONTZE()
	Local cRet   := ""
	Local cAlias := Alias()
	Local cQry   := ""

	cQry += "SELECT ISNULL(MAX( SUBSTRING(ZE_ROMAN,1, 6) ),000000) AS C2_NUM"
	cQry += " FROM "+RetSQLName("SZE")+" (NOLOCK) WHERE D_E_L_E_T_ = ' ' "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)

	cRet := Soma1(C2_NUM)

	TMP->(dbCloseArea())
	dbSelectArea(cAlias)

	//FreeUsedCode()
	Help := .T.	// Nao apresentar Help MayUse

	While !FreeForUse("SZE",cRet,.F.) //!FreeForUse("SZE",cRet,.F.)
		cRet := Soma1(cRet)
		Help := .T.	// Nao apresentar Help MayUse
	End

	Help := .F.	// Habilito o help novamente

	dbSelectArea(cAlias)
	Alert(cRet)

Return cRet

User Function ENTP01TicketF3()
	Local oDlgACE
	Local oLbx1                                                               // Listbox
	Local nPosLbx := 0                                                        // Posicao do List
	Local aItems  := {}                                                       // Array com os itens
	Local nPos    := 0                                                        // Posicao no array
	Local lRet    := .F.                                                      // Retorno da funcao
	Local oGreen  := LoadBitmap( GetResources(), "BR_VERDE" )
	Local oRed    := LoadBitmap( GetResources(), "BR_VERMELHO" )
	Local oBlue   := LoadBitmap( GetResources(), "BR_AZUL" )
	Local cVar    := ReadVar()
	Local cAlias  := Alias()
	Local nDias   := GetMV("MV_XDTROMA")  //quantidade de meses que serão considerados na consulta do guardian 

	CursorWait()

	cQry := "SELECT Tick_Sequencial AS TICKET, Tick_PlacaCarreta AS PLACA,"
	cQry += " CONVERT(Char(10),Tick_DtHrPesoInicial,112) AS DATAPESO, Tick_CampoUsu1 AS MOTORISTA, Tick_BalPesoInicial AS BALANCA"
	cQry += " FROM "+cBDBalanca+" TKT (NOLOCK)"
	//	cQry += " WHERE Tick_SttFim='N' AND Tick_Status<>'F'"
	cQry += " WHERE Tick_Status<>'F'"
	cQry += " AND CONVERT(Char(10),Tick_DtHrPesoInicial,112)>='"+Substr(DtoS(MonthSub(dDataBase,nDias)),1,6)+"01"+"' "
	cQry += " AND Tick_BalPesoInicial IN "+cBalanca+" "
	cQry += " AND NOT EXISTS(SELECT SZE.ZE_FILIAL FROM "+RetSQLName("SZE")+" SZE (NOLOCK) WHERE SZE.D_E_L_E_T_ = ' '"
	cQry += " AND SZE.ZE_TICKET1 = (CAST(TKT.Tick_Sequencial AS VARCHAR(7)) COLLATE Latin1_General_BIN))"
	cQry += " ORDER BY Tick_DtHrPesoInicial DESC, TKT.Tick_PlacaCarreta"

	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TKT", .T., .F. )
	TCSetField("TKT","DATAPESO","D",8,0)  // Converte o tipo DATA
	While !Eof()
		Aadd( aItems , { oBlue, PLACA, TICKET, DATAPESO, MOTORISTA, BALANCA} )
		dbSkip()
	Enddo
	dbCloseArea()
	dbSelectArea(cAlias)

	If Empty(aItems)
		Aadd(aItems,{	oRed, Space(07), Space(10), Ctod(""), Space(30),Space(40)})
	Endif

	CursorArrow()

	DEFINE MSDIALOG oDlgACE FROM  30,003 TO 260,600 TITLE "Ticket de Pesagem - Guardian" PIXEL

	@ 03,10 LISTBOX oLbx1 VAR nPosLbx FIELDS HEADER ;
	" ",;
	"Placa",;
	"Ticket",;
	"Pesagem Inicial",;
	"Motorista",;
	"Balanca",;
	SIZE 283,80 OF oDlgACE PIXEL NOSCROLL
	oLbx1:SetArray(aItems)
	oLbx1:bLine:={|| {aItems[oLbx1:nAt,1],;
	aItems[oLbx1:nAt,2],;
	aItems[oLbx1:nAt,3],;
	aItems[oLbx1:nAt,4],;
	aItems[oLbx1:nAt,5],;
	aItems[oLbx1:nAt,6] }}

	oLbx1:BlDblClick := {||(lRet:= .T.,nPos:= oLbx1:nAt, oDlgACE:End())}
	oLbx1:Refresh()

	DEFINE SBUTTON FROM 88,175 TYPE 1 ENABLE OF oDlgACE ACTION (lRet:= .T.,nPos := oLbx1:nAt,oDlgACE:End())
	DEFINE SBUTTON FROM 88,210 TYPE 2 ENABLE OF oDlgACE ACTION (lRet:= .F.,oDlgACE:End())

	ACTIVATE MSDIALOG oDlgACE CENTERED

	If lRet .And. nPos > 0 .And. nPos <= Len(aItems)
		&(cVar)     := aItems[nPos,2]
		cZE_PLACA   := aItems[nPos,2]
		cZE_TICKET1 := aItems[nPos,3]

		nPeso       := BuscaPeso(cZE_TICKET1)   // Busca o peso no Guardian
		nPesoB      := BuscaPeso2(cZE_TICKET1,"F")
		//If !FunName() $ 'MATA103'
		Ticket() // Atualiza as variáveis do ticket
		//Else
		//   cdZE_PLACA  := cZE_PLACA
		//   cdZE_TICKET := cZE_TICKET1
		//EndIf
	Endif

Return lRet

User Function ENTP01RetVal()
Return cZE_PLACA

Static Function BuscaPeso(cTicket)
	Local cQry
	Local cAlias := Alias()
	Local nRet   := 0

	If !Empty(cTicket)   // Se o ticket foi informado
		cQry := "SELECT  Coalesce(Tick_PesoLiquido,Tick_PesoFinal,Tick_PesoInicial,0) PESO"
		/*ISNULL(CASE"
		cQry += " WHEN Tick_PesoFinal IS NOT NULL THEN Tick_PesoFinal"
		cQry += " When Tick_PesoInicial it Not Null Then Tick_PesoInicial "
		cQry += " Else Tick_PesoLiquido END"
		cQry += " ,0) AS PESO"*/
		cQry += " FROM "+cBDBalanca+" TKT (NOLOCK)"
		cQry += " WHERE Tick_Sequencial = '"+cTicket + "'"

		dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TKT", .T., .F. )
		nRet := PESO
		dbCloseArea()
		dbSelectArea(cAlias)
	Endif

Return nRet


Static Function BuscaPeso2(cTicket,cTipo)
	Local cQry
	Local cAlias := Alias()
	Local nRet   := 0
	Default cTipo  := "L"

	If !Empty(cTicket)   // Se o ticket foi informado
		cQry := "SELECT  "

		if cTipo == "L"
			cQry += " Coalesce(Tick_PesoLiquido,Tick_PesoFinal,Tick_PesoInicial,0) PESO "
		ElseIf cTipo == "F"
			cQry += " Coalesce(Tick_PesoFinal,Tick_PesoLiquido,Tick_PesoInicial,0) PESO "
		ElseIf cTipo == "I"
			cQry += " Coalesce(Tick_PesoInicial,Tick_PesoFinal,Tick_PesoLiquido,0) PESO "
		Else
			cQry += " Coalesce(Tick_PesoLiquido,Tick_PesoFinal,Tick_PesoInicial,0) PESO "
		EndIf
		/*ISNULL(CASE"
		cQry += " WHEN Tick_PesoFinal IS NOT NULL THEN Tick_PesoFinal"
		cQry += " When Tick_PesoInicial it Not Null Then Tick_PesoInicial "
		cQry += " Else Tick_PesoLiquido END"
		cQry += " ,0) AS PESO"*/
		cQry += " FROM "+cBDBalanca+" TKT (NOLOCK)"
		cQry += " WHERE Tick_Sequencial = "+cTicket

		dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TKT", .T., .F. )
		nRet := PESO
		dbCloseArea()
		dbSelectArea(cAlias)
	Endif

Return nRet

// ********************************************************************************************************************************************
// PEGA DATA E HORA DA PESAGEM FINAL 
Static Function PesoFinal(cTicket, dPesoFinal, hPesoFinal)
	Local cQry
	Local cAlias := Alias()

	If !Empty(cTicket)   // Se o ticket foi informado
		cQry := "SELECT CONVERT(VARCHAR,Tick_DtHrPesoFinal, 112) AS CDATA , "
		cQry += "       CONVERT(VARCHAR,DATEPART(HOUR,Tick_DtHrPesoFinal)) + ':' + CONVERT(VARCHAR,DATEPART(MINUTE,Tick_DtHrPesoFinal)) AS CHORA "
		cQry += "  FROM "+cBDBalanca+" TKT"
		cQry += " WHERE Tick_Sequencial = '"+cTicket + "'"
		cQry += "   AND Tick_DtHrPesoFinal IS NOT NULL "

		dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TKT", .T., .F. )

		If !TKT->(Eof())
			dPesoFinal := TKT->CDATA
			hPesoFinal := TKT->CHORA
		EndIf

		TKT->(dbCloseArea())
		dbSelectArea(cAlias)
	Endif

Return Nil

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ ENTP01L    ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 05/12/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Liberação Especial da Balança                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function ENTP01L()	
	Local oDlg, oBtn1, oBtn2, oRomaneio, oPlaca, oCodMoto, oNomMoto, oAjuda1, oAjuda2, oObsRoma, oFonte1, oFonte2
	Local cNomMoto  := Space(030)
	Local cAjuda1   := Space(030)
	Local cAjuda2   := Space(030)
	Local cDescri   := Space(030)
	Local nOpcA     := 0


	Private oTkt1, oTkt2
	Private cRomaneio := "" //GetSX8Num("SZE", "ZE_ROMAN")//_GetNum("SZE","ZE_ROMAN") //GetSX8Num("SZE", "ZE_ROMAN")
	Private cPlaca    := Space(TamSX3("ZF_PLACA")[1])
	Private cTipoLib  := "  "
	Private cCodMoto  := Space(006)
	Private cObsRoma  := Space(100)
	Private nPeso     := 0
	Private nPesoB    := 0
	Private cUserApr  := ""
	
	While (cRomaneio := getSx8Num("SZE","ZE_ROMAN")) < ProxNum("SZE","ZE_ROMAN")
		ConfirmSX8()
	Enddo
	
	If Empty(cRomaneio)
       Alert('Nao Foi Possivel Selecionar o numero do romaneio!')
       Return
    EndIF

	cBDBalanca  := GetMV("MV_XBCOGUAR")  //"Guardian110TST.dbo.RegTick"
	cZE_TICKET1 := CriaVar("ZE_TICKET1")

	DEFINE FONT oFonte1 NAME "Arial" SIZE 08,17 BOLD
	DEFINE FONT oFonte2 NAME "Arial" SIZE 10,20 BOLD

	DEFINE MSDIALOG oDlg TITLE "Liberação Especial da Balança" FROM 00,00 TO 200,670 PIXEL

	@ 010,005 SAY "Romaneio"     PIXEL OF oDlg COLOR CLR_HBLUE
	@ 010,035 GET cRomaneio SIZE 030,20 PICTURE "@!"          OBJECT oRomaneio  WHEN .F.

	@ 010,080 SAY "Placa"        PIXEL OF oDlg COLOR CLR_HBLUE
	@ 010,105 GET cPlaca    SIZE 040,20 PICTURE "@R AAA-9999" OBJECT oPlaca     F3 "TKTGUA"

	@ 010,160 SAY "Tipo Liberação" PIXEL OF oDlg COLOR CLR_HBLUE
	@ 010,200 GET cTipoLib    SIZE 020,20 PICTURE "@!" OBJECT oLib     F3 "Z1" Valid ExistCpo("SX5","Z1"+cTipoLib)
	oLib:bLostFocus:= { || cDescri := Posicione("SX5",1,XFILIAL("SX5")+"Z1"+cTipoLib,"X5_DESCRI"), oDescri:Refresh() }

	@ 010,225 GET cDescri     SIZE 100,20 PICTURE "@!" OBJECT oDescri  WHEN .F.

	@ 027,245 SAY oTkt1 VAR "TICKET"    PIXEL OF oDlg FONT oFonte1 COLOR CLR_HBLUE
	@ 037,242 SAY oTkt2 VAR cZE_TICKET1 PIXEL OF oDlg FONT oFonte2 COLOR CLR_HRED
	Ticket()

	@ 025,005 SAY "Motorista"    PIXEL OF oDlg COLOR CLR_HBLUE
	@ 025,035 GET cCodMoto  SIZE 030,20 PICTURE "@!"          OBJECT oCodMoto   F3 "SZFPLC" Valid fValMoto(cCodMoto)

	@ 025,085 SAY "Nome"         PIXEL OF oDlg
	@ 025,105 GET cNomMoto  SIZE 100,20 PICTURE "@!"          OBJECT oNomMoto   WHEN .F.

	@ 040,005 SAY "Ajudante 1" PIXEL OF oDlg
	@ 040,040 GET cAjuda1   SIZE 060,20 PICTURE "@!"          OBJECT oAjuda1

	@ 040,125 SAY "Ajudante 2" PIXEL OF oDlg
	@ 040,160 GET cAjuda2   SIZE 060,20 PICTURE "@!"          OBJECT oAjuda2

	@ 055,005 SAY "Obs "       PIXEL OF oDlg COLOR CLR_HBLUE
	@ 055,040 GET cObsRoma  SIZE 230,20 PICTURE "@!"          OBJECT oObsRoma

	@ 070,005 SAY "Peso Liquido: "    PIXEL OF oDlg
	@ 070,045 GET nPeso   SIZE 90,20 PICTURE "@E 999,999,999.999999" OBJECT oTotalP WHEN .F.

	@ 070,145 SAY "Peso Bruto: "    PIXEL OF oDlg
	@ 070,185 GET nPesoB   SIZE 90,20 PICTURE "@E 999,999,999.999999" OBJECT oTotalB WHEN .F.

	DEFINE SBUTTON oBtn1 FROM 035,300 TYPE 1 ACTION If( Libera() , (nOpcA := 1,oDlg:End()), ) ENABLE
	DEFINE SBUTTON oBtn2 FROM 060,300 TYPE 2 ACTION (nOpcA := 0,oDlg:End()) ENABLE

	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpcA == 1
	
			ConfirmSX8()

			RecLock("SZE", .T.)
			SZE->ZE_FILIAL  := xFilial("SZE")
			SZE->ZE_ORIGEM  := "AAENTP01"
			SZE->ZE_FILORIG := xFilial("SZE")
			SZE->ZE_STATUS  := "X"
			SZE->ZE_PLIQUI  := nPeso
			SZE->ZE_PBRUTO  := nPesoB

			SZE->ZE_ROMAN   := cRomaneio
			SZE->ZE_MOTOR   := cCodMoto
			SZE->ZE_NOMOTOR := cNomMoto
			SZE->ZE_PLACA   := cPlaca
			SZE->ZE_DTREC   := Date()
			SZE->ZE_DTSAIDA := Date()
			SZE->ZE_HORREC  := Time()
			SZE->ZE_NOMREC  := cUserName
			SZE->ZE_PESO    := nPesoB - nPeso

			SZE->ZE_AJUDA01 := cAjuda1
			SZE->ZE_AJUDA02 := cAjuda2
			SZE->ZE_OBSERV  := cObsRoma
			SZE->ZE_TICKET1 := cZE_TICKET1

			dPesoFinal := ""
			hPesoFinal := ""

			PesoFinal(cZE_TICKET1, @dPesoFinal, @hPesoFinal)
			IF !Empty(dPesoFinal)
				SZE->ZE_DTPESO  := STOD(dPesoFinal)
				SZE->ZE_HRPESO  := hPesoFinal
			EndIf


			u_AALOGE01(SZE->ZE_ROMAN,SZE->ZE_DOC,SZE->ZE_SERIE, "Inclusao de novos Registros")

			MsUnLock()
			//Alert( Empty(cZE_TICKET1) )
			If !Empty(cZE_TICKET1)
				//alert(cUserApr)
				AtuGuardian(cZE_TICKET1, cUserApr, 2  )
			EndIf

	Else
		RollBackSX8()
	Endif

Return

Static Function Libera()
	Local nX
	Local aCampos := {}

	AAdd( aCampos , { {|| cRomaneio }, "Romaneio"  } )
	AAdd( aCampos , { {|| cPlaca    }, "Placa"     } )
	AAdd( aCampos , { {|| cTipoLib  }, "Tipo de Liberação" } )
	AAdd( aCampos , { {|| cCodMoto  }, "Motorista" } )
	AAdd( aCampos , { {|| cObsRoma  }, "Observação"} )
	AAdd( aCampos , { {|| nPeso     }, "Peso líquido" } )

	For nX:=1 To Len(aCampos)
		If Empty(Eval(aCampos[nX,1]))
			Alert("O campo "+aCampos[nX,2]+" não pode ficar vazio !")
			Return .F.
		Endif
	Next

Return VldSenha()

Static Function VldSenha()
	Local oUsu, oPsw
	Local cCodUsu := Space(40)
	Local cNome   := Space(30)
	Local lRet    := .F.
	Local oFont1  := TFont():New("Courier New",,-14,.T.,.T.)
	Local cPswFol := Space(15)

	DEFINE MSDIALOG oPsw TITLE "Liberação da Balança" From 0,0 To 13,28 OF oMainWnd

	@ 10,005 SAY "Usuário.:" PIXEL OF oUsu
	@ 10,035 MSGET cCodUsu SIZE 40,10 PIXEL OF oUsu FONT oFont1  F3 "USR" Valid ChkUsuario(cCodUsu,@cNome)

	@ 30,005 SAY "Nome....:" PIXEL OF oUsu
	@ 30,035 MSGET cNome SIZE 70,10 PIXEL OF oUsu FONT oFont1 WHEN .F.

	@ 50,005 SAY "Senha.:" PIXEL OF oPsw
	@ 50,035 GET cPswFol PASSWORD SIZE 70,10 PIXEL OF oPsw FONT oFont1

	@ 80,020 BUTTON oBut1 PROMPT "&Ok"      SIZE 30,12 OF oPsw PIXEL Action If( lRet := ChkSenha(cCodUsu,cPswFol) , oPsw:End(), )
	@ 80,060 BUTTON oBut2 PROMPT "&Cancela" SIZE 30,12 OF oPsw PIXEL Action (lRet := .F., oPsw:End())

	ACTIVATE MSDIALOG oPsw CENTERED

	cUserApr	:= cCodUsu

Return lRet            


Static Function ChkUsuario(cCodUsr,cNome)

	If !Empty(cCodUsr)
		PswOrder(1)
		PswSeek(AllTrim(cCodUsr))
		cNome := PswRet(1)[1][2]   // Retorna o nome do usuário
	EndIf

Return .T.

Static Function ChkSenha(cCodUsr,cPass)
	LocaL lRet := cCodUsr $ GetMV("MV_XUSRLBE")

	If lRet
		lRet := .T.
		/*
		TODO: VERIFICAR CHAMADO COM A TOTVS
		PswOrder(1)
		PswSeek(AllTrim(cCodUsr))
		If !(lRet := PswName(cPass))
			Alert("Senha informada está incorreta !")
		Endif*/
	Else
		Alert("Usuário não tem permissão para liberação !")
	Endif

Return lRet

Static Function Ticket()
	If Empty(cZE_TICKET1)
		oTkt1:Hide()
		oTkt2:Hide()
	Else
		oTkt1:Show()
		oTkt2:Show()
	Endif
	oTkt1:Refresh()
	oTkt2:Refresh()
Return

Static Function AtuGuardian(cTicket, cGravar, nTipo)


	if nTipo == 1 
		cQry := " update Guardian110.dbo.RegTick
		cQry += "    set  Tick_CampoUsu6 = SubString(NOTAS,001,50),
		cQry += "		  Tick_CampoUsu7 = SubString(NOTAS,051,50),
		cQry += "		  Tick_CampoUsu8 = SubString(NOTAS,101,50),
		cQry += "		  Tick_CampoUsu9 = SubString(NOTAS,151,50)
	Else 
		cQry := " update Guardian110.dbo.RegTick
		cQry += "    set Tick_CampoUsu6 = '" + cGravar + "' "
	EndIf

	cQry += "  FROM ( SELECT ZE_TICKET1,
	cQry += "                REPLACE( ( select AUX.ZE_DOC + ',' AS [data()]
	cQry += "                             from ( SELECT SZE.ZE_TICKET1, SZE.ZE_DOC
	cQry += "                                      FROM SZE010 as SZE (NOLOCK)
	cQry += "                                     WHERE SZE.D_E_L_E_T_ = ''
	cQry += "                                       AND SZE.ZE_TICKET1 <> ''
	If nTipo == 01 	   
		cQry += "                                     AND SZE.ZE_STATUS <> '' " 
		cQry += "                                     AND SZE.ZE_DOC <> '' "
	EndIf
	cQry += "                                     GROUP BY SZE.ZE_TICKET1, SZE.ZE_DOC
	cQry += "                                  ) as AUX
	cQry += "                            WHERE AUX.ZE_TICKET1 = SZE1.ZE_TICKET1 FOR XML PATH('')
	cQry += "                         ), ' ', '' ) AS NOTAS
	cQry += "           FROM SZE010 as SZE1 (NOLOCK)
	cQry += "          WHERE SZE1.D_E_L_E_T_ = '' "
	cQry += "          AND SZE1.ZE_TICKET1 <> '' " 

	If nTipo == 01 	   
		cQry += "           AND SZE1.ZE_STATUS <> '' " 
		cQry += "           AND SZE1.ZE_DOC <> '' "
	EndIf

	cQry += "          GROUP BY SZE1.ZE_TICKET1
	cQry += "       ) AS TAB_AUX
	cQry += " INNER JOIN Guardian110.dbo.RegTick AS TICK (NOLOCK) ON Tick_Sequencial = TAB_AUX.ZE_TICKET1 COLLATE Latin1_General_BIN
	cQry += " WHERE TAB_AUX.ZE_TICKET1 = '" +cTicket+ "'"

	TCSQLExec(cQry)

	/*cQry := " UPDATE "+cBDBalanca                              
	cQry += " SET Tick_CampoUsu6  = '" +SubStr(cGravar,001,050)+ "' "
	cQry += " WHERE Tick_Sequencial = '" +cTicket+ "'" 

	TCSQLExec(cQry)            

	cQry := " UPDATE "+cBDBalanca                              
	cQry += " SET Tick_CampoUsu7  = '" +SubStr(cGravar,051,050)+ "' "
	cQry += " WHERE Tick_Sequencial = '" +cTicket+ "'" 

	TCSQLExec(cQry)            

	cQry := " UPDATE "+cBDBalanca                              
	cQry += " SET Tick_CampoUsu8  = '" +SubStr(cGravar,101,050)+ "' "
	cQry += " WHERE Tick_Sequencial = '" +cTicket+ "'" 

	TCSQLExec(cQry)            

	cQry := " UPDATE "+cBDBalanca                              
	cQry += " SET Tick_CampoUsu9  = '" +SubStr(cGravar,151,050)+ "' "
	cQry += " WHERE Tick_Sequencial = '" +cTicket+ "'" 

	TCSQLExec(cQry)            

	cQry := " UPDATE "+cBDBalanca                              
	cQry += " SET Tick_CampoUsu10 = '" +SubStr(cGravar,201,050)+ "' "
	cQry += " WHERE Tick_Sequencial = '" +cTicket+ "'" 

	TCSQLExec(cQry)            

	*/
	//	ALERT (CQRY)

Return Nil
Static Function _GetNum(xTbl,xField)
    Local xQry := " "
    
    xQry += " Select isNull(MAX(" + xField + "),'" + Replicate("0",TAMSX3(xField)[01]) + "') ROMANEIO From " + RetSqlName(xTbl)
    
    xTbl := MpSysOpenQuery(xQry)
    xdRomaneio := Soma1( (xTbl)->ROMANEIO )
    //Sleep( Randomize( 0 , 5000) )
    While !MayIUseCode(xdRomaneio)
        xdRomaneio := Soma1( xdRomaneio )
    EndDo
        
    //xQry += " Where D_E_L_E_T_ = ' '" 
    
Return xdRomaneio


Static Function ProxNum(cTbl,cCampo)
	Local aArea  := GetArea()
	Local cQuery := ""
	
	Private cNumUti := ""
	Private cTbela  := cTbl
	Private cCamp   := cCampo
	
	cQuery += " Select Max("+cCampo+") Prox From " + RetSqlName(cTbl) + " "+ cTbl + " "
	cQuery += " Where D_E_L_E_T_ = '' And " + cCampo + "<> 'ZZZZZZ' "
	
	SX3->(dbSetOrder(2))
	If !SX3->(dbSeek(cCampo))
		Aviso("Erro Fatal!","Campo não existe na Tabela : " + cCampo,{"Ok"})
		MsFinal()
	Else
		dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TAM", .T., .F. )
		cProx := TAM->PROX
		cProx := iIf (ValType(cProx)="C",Soma1(cProx),iIf(ValType(cProx)="N",cProx + 1,""))
		TAM->(dbCloseArea("TAM"))
	Endif
	
	cNumUti := cProx
	RestArea(aArea)
	
Return cProx
/*----------------------------------------------------------------------------------||
||       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||      AAAA       LL         LL         EE         CC        KK    KK   SS         ||
||     AA  AA      LL         LL         EE        CC         KK  KK     SS         ||
||    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   ||
||   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  ||
||  AA        AA   LL         LL         EE         CC        KK    KK          SS  ||
|| AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||----------------------------------------------------------------------------------*/
