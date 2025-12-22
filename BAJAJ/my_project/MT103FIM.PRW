#include "PROTHEUS.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  MT103FIM  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 08/07/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descricao ¦ Ponto de Entrada após gravação do documento de entrada        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MT103FIM()
	Local oDlgE, aCmpEnc, nX, nValor
	Local aCampos := {}
	Local aTAB    := {}
	Local nDec    := TamSX3("E2_VALOR")[2]
	Local nOpcA   := 0
	
	If SF1->F1_EST <> "EX"
		Return
	Endif
	
	// Regrava o valor do contas a pagar pelo valor da mercadoria
	SE2->(dbSetOrder(6))    // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
	SE2->(dbSeek(XFILIAL("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC,.T.))
	While !SE2->(Eof()) .and. SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXOE+SE2->E2_NUM == XFILIAL("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC
		//SUPERGETMV("Parâmetro", [Help .T. ou .F.], "Conteúdo padrão", "Filial do sistema")
		
		// regra de entrada em real x titulo em dolar
		// MV_XRECICM na filial 02 e 03 == .T. para para pegar o valor tatol em dola e tx la da SF1 e atualizar SE2.
		lValDolar := SuperGetMV("MV_XRECICM",.F.,.F.,cFilAnt)

		// atualiza a SE2 com o vlor dolar e tx doloar da SF1.
		if lValDolar 
			RecLock("SE2",.F.)
			SE2->E2_VALOR  := SF1->F1_XVLDLR
			SE2->E2_TXMOEDA := SF1->F1_XTXDLR
			SE2->E2_VLCRUZ := Round(SF1->F1_XVLDLR * SF1->F1_XTXDLR,nDec)
			SE2->E2_SALDO  := SF1->F1_XVLDLR
			MsUnLock()
		else
			
			If SE2->E2_MOEDA <> 1 .And. SE2->E2_TXMOEDA > 0
				nValor := Round( SF1->F1_VALMERC / SE2->E2_TXMOEDA, nDec )
			Else
				nValor := SF1->F1_VALMERC
			EndIf
		
			RecLock("SE2",.F.)
			SE2->E2_VALOR  := nValor
			SE2->E2_VLCRUZ := SF1->F1_VALMERC
			SE2->E2_SALDO  := nValor
			MsUnLock()
		EndIf
		SE2->(dbSkip())
	Enddo
	
	Private aTela := {}
	Private aGets := {}
	
	// Carrega os campos a serem lidos para a tabela
	// Adiciona os campos a serem exibidos na tela
	//                 Nome         Obrg Edit  F3    When       CBox
	AAdd( aCampos , { "F1_DOC"    , .T., .F., "   ", {|| .F. }, Nil} )
	AAdd( aCampos , { "F1_SERIE"  , .T., .F., "   ", {|| .F. }, Nil} )
	AAdd( aCampos , { "F1_FORNECE", .T., .F., "SA2", {|| .F. }, Nil} )
	AAdd( aCampos , { "F1_LOJA"   , .T., .F., "   ", {|| .F. }, Nil} )
	AAdd( aCampos , { "F1_XDI"    , .F., .T., "   ", {|| .T. }, Nil} )
	AAdd( aCampos , { "F1_XDTDI"  , .F., .T., "   ", {|| .T. }, Nil} )
	AAdd( aCampos , { "F1_XTPMAN" , .F., .T., "   ", {|| .T. }, Nil} )
	AAdd( aCampos , { "F1_XMANIFE", .F., .T., "   ", {|| .T. }, Nil} )
	AAdd( aCampos , { "F1_XRECINT", .F., .T., "   ", {|| .T. }, Nil} )
	AAdd( aCampos , { "F1_XARMAZE", .F., .T., "   ", {|| .T. }, Nil} )
	AAdd( aCampos , { "F1_XEMBALA", .F., .T., "   ", {|| .T. }, Nil} )
	AAdd( aCampos , { "F1_XQTDVOL", .F., .T., "   ", {|| .T. }, Nil} )
	AAdd( aCampos , { "F1_XPESBRU", .F., .T., "   ", {|| .T. }, Nil} )
	AAdd( aCampos , { "F1_XPESLIQ", .F., .T., "   ", {|| .T. }, Nil} )
	
	aEval( aCampos , {|x| AAdd( aTAB , PADR(x[1],10) ) } )
	
	aCmpEnc := ConfigCampos(aCampos)
	
	// Inicializa o conteúdo das variáveis
	RegToMemory("SF1", .F., .F. )
	
	cCadastro := "Documento de Entrada"
	
	//Mostra tela de cadastro padrão no formato Enchoice
	DEFINE MSDIALOG oDlgE TITLE "Dados Complementares" From 0,0 TO 455,650 Style DS_MODALFRAME PIXEL OF oMainWnd
	
	oEnc := Msmget():New(,,3,,,,aTAB,{30,0,228,328},Nil,3,,,,oDlgE,,.T.,,,,,aCmpEnc,,,.F.)
	
	ACTIVATE MSDIALOG oDlgE CENTERED ON INIT EnchoiceBar(oDlgE,{|| nOpcA:=If(Obrigatorio(aGets,aTela),1,0),If(nOpcA==1,oDlgE:End(),) },{||oDlgE:End()})
	
	If nOpcA == 1
		RecLock("SF1",.F.)
		For nX:=5 To Len(aCampos)
			If (nPos := FieldPos(aCampos[nX,1])) > 0
				FieldPut( nPos , M->&(aCampos[nX,1]) )
			Endif
		Next
		MsUnLock()
		
		FWAlertSuccess("Dados Complementares gravados com sucesso !")
		
		If SF1->F1_FORMUL == 'S' 
			fatualiza()
		ENDIF
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
						&( "{|| "+Trim(GetSx3Cache(aCampos[nX,1],'X3_VLDUSER'))+"}" ), ;
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

User Function TELATESTE()
	Local cNota := "0000000012"
	
	SF1->(dbSetOrder(1))
	If SF1->(dbSeek(XFILIAL("SF1")+cNota))
		u_MT103FIM()
	Endif

Return

static function fatualiza()  
	Local aArea := GetArea()
	
	SD1->(dbSetOrder(1))
	SD1->(dbSeek(SF1->(F1_FILIAL + F1_DOC + F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))   
	
	CD5->(DbsetOrder(4))
	
	While SD1->(!EOF()) .And. SF1->F1_FILIAL == SD1->D1_FILIAL;
		.AND. SF1->F1_DOC == SD1->D1_DOC .AND. SF1->F1_SERIE == SD1->D1_SERIE .AND. SF1->F1_FORNECE == SD1->D1_FORNECE
		
		iF !CD5->(DbSeek(xFilial("CD5")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+SD1->D1_ITEM))
			RecLock("CD5",.T.)
			CD5->CD5_FILIAL := XFILIAL("CD5")
			CD5->CD5_DOC    := SF1->F1_DOC
			CD5->CD5_SERIE  := SF1->F1_SERIE
			CD5->CD5_ESPEC  := SF1->F1_ESPECIE
			CD5->CD5_FORNECE:= SF1->F1_FORNECE
			CD5->CD5_LOJA   := SF1->F1_LOJA
			CD5->CD5_DOCIMP := SF1->F1_XDI
			CD5->CD5_NDI    := SF1->F1_XDI
			CD5->CD5_DTDI   := SF1->F1_XDTDI
			CD5->CD5_DTDES  := SF1->F1_XDTDI
			CD5->CD5_NADIC  := SubStr(SD1->D1_ITEM, 2,4)//SD1->D1_ITEM
			CD5->CD5_SQADIC := SubStr(SD1->D1_ITEM, 2,4)//SD1->D1_ITEM
			CD5->CD5_UFDES  := "AM"
			CD5->CD5_LOCDES := "MANAUS"
			CD5->CD5_ITEM   := SD1->D1_ITEM
			CD5->CD5_SDOC   := SF1->F1_SERIE 
			CD5->CD5_TPIMP  := "0" 
			CD5->CD5_LOJEXP := SF1->F1_LOJA
			CD5->CD5_VTRANS	:= "1"
			CD5->CD5_LOJFAB := SF1->F1_LOJA	
			CD5->CD5_CODEXP := SF1->F1_FORNECE
			CD5->CD5_CODFAB := SF1->F1_FORNECE
			CD5->CD5_INTERM := "1"
			CD5->CD5_VAFRMM := SD1->D1_AFRMIMP
			
			If SD1->(FieldPos("D1_XII")) > 0 .And. SD1->D1_XII > 0
				CD5->CD5_BCIMP  := SD1->D1_TOTAL
			ElseIf SD1->(FieldPos("D1_II")) > 0 .And. SD1->D1_II > 0
				CD5->CD5_BCIMP  := SD1->D1_TOTAL
			Endif
			//CD5->CD5_VTRANS := ALLTRIM(SD1->D1_LOCPAD)
			MsUnlock()
		ENDIF
		
		SD1->(dbSkip())
	EndDo

	RestArea(aArea)

Return
