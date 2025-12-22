#INCLUDE 'TOTVS.CH'

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

/*/{Protheus.doc} MBCFGU01
#122977 - CRIACAO DE WORKFLOW PARA ENVIO DE E-MAILS

@type		function
@author	UDTOOLS
@since	22/02/2025

@example	U_MBCFGU01()

@see		http://www.udesenv.com.br/
/*/
User Function MBCFGU01( cEmpAmb, cFilAmb )
Local aMarcadas := {} 

Local oDlg	:= Nil 
Local oSay01	:= Nil 
Local oSay02	:= Nil 
Local oSay03	:= Nil 
Local oSay04	:= Nil 
Local oSay05	:= Nil 
Local oSay06	:= Nil 
Local oSay07	:= Nil 
Local oSay08	:= Nil 

Local oBut01	:= Nil 
Local oBut02	:= Nil 

Local oFont01a	:= TFont():New("Arial",,18,.T.,.F.) 
Local oFont02a	:= TFont():New("Arial",,16,.T.,.F.) 

Local lOk       := .F.
Local lAuto     := ( cEmpAmb <> NIL .or. cFilAmb <> NIL )

Private oProcess  := NIL
Private cErro  	:= ""

#IFDEF TOP
    TCInternal( 5, "*OFF" ) // Desliga Refresh no Lock do Top
#ENDIF

__cInterNet := NIL
__lPYME     := .F.

Set Dele On

If lAuto
	lOk := .T.
Else

	oDlg := MSDialog():New( 000,000,480,750,"ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS",,,.F.,,,,,,.T.,,,.T. ) 

	oSay01 := TSay():New( 010,010,{|| "#122977 - CRIACAO DE WORKFLOW PARA ENVIO DE E-MAILS" },oDlg,,oFont01a,.F.,.F.,.F.,.T.,CLR_BLUE,,550,008) 
	oSay02 := TSay():New( 025,010,{|| "" },oDlg,,oFont01a,.F.,.F.,.F.,.T.,CLR_BLUE,,550,008) 
	oSay03 := TSay():New( 040,010,{|| "Tabelas: SRA" },oDlg,,oFont01a,.F.,.F.,.F.,.T.,CLR_BLUE,,550,008) 


	oSay05 := TSay():New( 085,010,{|| "Esta rotina tem como função fazer  a atualização  dos dicionários do Sistema ( SX?/SIX )" },oDlg,,oFont02a,.F.,.F.,.F.,.T.,,,550,008) 
	oSay06 := TSay():New( 100,010,{|| "Este processo deve ser executado em modo EXCLUSIVO, ou seja não podem haver outros usuários ou jobs utilizando  o sistema" },oDlg,,oFont02a,.F.,.F.,.F.,.T.,,,550,008) 
	oSay07 := TSay():New( 115,010,{|| "É extremamente recomendavél  que  se  faça um BACKUP  dos DICIONÁRIOS  e da  BASE DE DADOS antes desta atualização," },oDlg,,oFont02a,.F.,.F.,.F.,.T.,,,550,008) 
	oSay08 := TSay():New( 130,010,{|| "para que caso ocorra eventuais falhas, esse backup seja ser restaurado" },oDlg,,oFont02a,.F.,.F.,.F.,.T.,,,550,008) 

	oBut01 := TButton():New( 180,210, "Avançar"			, oDlg, {|| lOk := .T., oDlg:End() }, 060, 025, , , .F., .T., .F., , .F., , , .F. ) 
	oBut02 := TButton():New( 180,280, "Fechar"			, oDlg, {|| lOk := .F., oDlg:End() }, 060, 025, , , .F., .T., .F., , .F., , , .F. ) 

	oDlg:Activate(,,,.T.)   

EndIf

If lOk 
	If lAuto 
		aMarcadas :={{ cEmpAmb, cFilAmb, "" }}
	Else 
 		aMarcadas := EscEmpresa()
 	EndIf

	If !Empty( aMarcadas )
 		If lAuto .OR. MsgNoYes( "Confirma a atualização dos dicionários ?", "MBCFGU01" )
 			oProcess := MsNewProcess():New( { | lEnd | lOk := UPDProc( @lEnd, aMarcadas ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
 			oProcess:Activate()

 			If lAuto
 				If lOk
 					Conout( "Atualização Realizada" )
 				Else
 					Conout( "Atualização não Realizada: "  + cErro )
 				EndIf
				dbCloseAll()
 			Else
 				If lOk
 					ShowLog( "Atualização Concluída" )
 				Else
 					ShowLog( "Atualização não Realizada: " + cErro  )
 				EndIf
 			EndIf

 		Else
 			ShowLog( "Atualização Cancelada" )
 		EndIf

 	Else
 		ShowLog( "Atualização Cancelada" )
 	EndIf

EndIf
Return( Nil )

/*/{Protheus.doc} UPDProc
Função principal de processamento

@type		function
@author	UDTOOLS
@since		22/02/2025

@param		@lEnd, Boolean, Final
@param		aMarcadas, Array, Array

@example		UPDProc()

@see		http://www.udesenv.com.br/
/*/
Static Function UPDProc( lEnd, aMarcadas )
Local   aInfo     := {}
Local   aRecnoSM0 := {}
Local   cAux      := ""
Local   cTCBuild  := "TCGetBuild"
Local   cTexto    := ""
Local   cTopBuild := ""
Local   lOpen     := .F.
Local   lRet      := .T.
Local   nI        := 0
Local   nPos      := 0
Local   nRecno    := 0
Local   nX        := 0
Local   oDlg      := NIL
Local   oFont     := NIL
Local   oMemo     := NIL

Private aArqUpd   := {}

If ( lOpen := MyOpenSm0(.T.) )

	dbSelectArea( "SM0" )
	dbGoTop()

	Do While !SM0->( EOF() )
 		// So adiciona no aRecnoSM0 se a empresa for diferente
 		If aScan( aRecnoSM0, { |x| x[2] == SM0->M0_CODIGO } ) == 0 ;
 		   .AND. aScan( aMarcadas, { |x| x[1] == SM0->M0_CODIGO } ) > 0 
 			aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO } )
 		EndIf
 		SM0->( dbSkip() )
 	EndDo

 	SM0->( dbCloseArea() )

 	If lOpen

 		For nI := 1 To Len( aRecnoSM0 )

 			If !( lOpen := MyOpenSm0(.T.) )
 				MsgStop( "Atualização da empresa " + aRecnoSM0[nI][2] + " não efetuada." )
 				Exit
 			EndIf 

 			SM0->( dbGoTo( aRecnoSM0[nI][1] ) )

 			RpcSetType( 3 )
 			RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

 			lMsFinalAuto := .F.
 			lMsHelpAuto  := .F.

 			aArqUpd	:= {}

 			If TCCanOpen( RetSQLName( "SRA" ) ) 

 				SRA->( dbCloseArea() )

 				dbUseArea( .T.,"TOPCONN", RetSqlName("SRA"), "TMPER", .F., .F. ) 
 				If Empty( Select( "TMPER" ) )
 					cErro := "Tabela SRA está em uso " 
 					Return( .F. )
 				Else
 					TMPER->( dbCloseArea() )
 				EndIf

 			Endif 


 			AutoGrLog( Replicate( "-", 128 ) )
 			AutoGrLog( "Empresa : " + SM0->M0_CODIGO + "/" + SM0->M0_NOME ) 

 			oProcess:SetRegua1( 8 )

 			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 			//³Atualiza o dicionário SX3         ³
 			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
 			UPDSX3()

 			oProcess:IncRegua1( "Dicionário de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
 			oProcess:IncRegua2( "Atualizando campos/índices" )

 			// Alteracao fisica dos arquivos
 			__SetX31Mode( .F. )

 			If FindFunction(cTCBuild)
 				cTopBuild := &cTCBuild.()
 			EndIf

 			For nX := 1 To Len( aArqUpd )

 				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
 					If ( ( aArqUpd[nX] >= "NQ " .AND. aArqUpd[nX] <= "NZZ" ) .OR. ( aArqUpd[nX] >= "O0 " .AND. aArqUpd[nX] <= "NZZ" ) ) .AND.;
 						!aArqUpd[nX] $ "NQD,NQF,NQP,NQT"
 						TcInternal( 25, "CLOB" )
 					EndIf
 				EndIf

 				If Select( aArqUpd[nX] ) > 0
 					dbSelectArea( aArqUpd[nX] )
 					dbCloseArea()
 				EndIf

 				X31UpdTable( aArqUpd[nX] )

 				If __GetX31Error()
 					Alert( __GetX31Trace() )
 					MsgStop( "Ocorreu um erro desconhecido durante a atualização da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicionário e da tabela.", "ATENÇÃO" )
 					AutoGrLog( __GetX31Trace() + aArqUpd[nX] + CRLF + cTexto ) 
 				EndIf

 				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
 					TcInternal( 25, "OFF" )
 				EndIf

 			Next nX 

		    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 			//³Atualiza o dicionário SX6         ³
 			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 			oProcess:IncRegua1( "Dicionário de parâmetros" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
 			UPDSX6()


 			dbSelectArea("SRA")

 			RpcClearEnv()

 		Next nI

 		If MyOpenSm0(.T.)

 			ShowLog( LeLog() )

 		EndIf

 	EndIf

Else

 	lRet := .F.

EndIf

Return lRet


/*/{Protheus.doc} ShowLog 
Log"

@type		function
@author		Eurai Rapelli
@since		22/02/2025
/*/
Static Function ShowLog(cTexto)
Local   cFile     := ""
Local   cMask     := "Arquivos Texto" + "(*.TXT)|*.txt|"

Define Font oFont Name "Mono AS" Size 5, 12 

Define MsDialog oDlg Title "Atualizacao" From 3, 0 to 440, 517 Pixel

@ 5, 5 Get oMemo Var cTexto Memo Size 245, 185 Of oDlg Pixel
oMemo:bRClicked := { || AllwaysTrue() }
oMemo:oFont     := oFont

Define SButton From 200, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga 
Define SButton From 200, 145 Type 13 Action ( cFile := cGetFile( cMask, "" ), If( cFile == "", .T., ;
MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel

Activate MsDialog oDlg Center

Return( Nil )

/*/{Protheus.doc} UPDSX3
Atualiza SX3

@type			function
@author		UDTOOLS
@since		22/02/2025

@example		UPDSX3()
/*/
Static Function UPDSX3()
Local aEstrut   := {}
Local aSX3      := {}
Local aTmp	  := {}
Local aOrdem	  := {}
Local cAlias    := ""
Local cAliasAtu := ""
Local cMsg      := ""
Local cSeqAtu   := ""
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0
Local nPosArq   := 0
Local nPosCpo   := 0
Local nPosOrd   := 0
Local nPosSXG   := 0
Local nPosTam   := 0
Local nSeqAtu   := 0
Local nTamSeek  := Len( SX3->X3_CAMPO )

AutoGrLog( "Inicio da Atualizacao SX3" + CRLF ) 

aAdd( aEstrut, "X3_ARQUIVO" )
aAdd( aEstrut, "X3_ORDEM" )
aAdd( aEstrut, "X3_CAMPO" )
aAdd( aEstrut, "X3_TIPO" )
aAdd( aEstrut, "X3_TAMANHO" )
aAdd( aEstrut, "X3_DECIMAL" )
aAdd( aEstrut, "X3_TITULO" )
aAdd( aEstrut, "X3_TITSPA" )
aAdd( aEstrut, "X3_TITENG" )
aAdd( aEstrut, "X3_DESCRIC" )
aAdd( aEstrut, "X3_DESCSPA" )
aAdd( aEstrut, "X3_DESCENG" )
aAdd( aEstrut, "X3_PICTURE" )
aAdd( aEstrut, "X3_VALID" )
aAdd( aEstrut, "X3_USADO" )
aAdd( aEstrut, "X3_RELACAO" )
aAdd( aEstrut, "X3_F3" )
aAdd( aEstrut, "X3_NIVEL" )
aAdd( aEstrut, "X3_RESERV" )
aAdd( aEstrut, "X3_CHECK" )
aAdd( aEstrut, "X3_TRIGGER" )
aAdd( aEstrut, "X3_PROPRI" )
aAdd( aEstrut, "X3_BROWSE" )
aAdd( aEstrut, "X3_VISUAL" )
aAdd( aEstrut, "X3_CONTEXT" )
aAdd( aEstrut, "X3_OBRIGAT" )
aAdd( aEstrut, "X3_VLDUSER" )
aAdd( aEstrut, "X3_CBOX" )
aAdd( aEstrut, "X3_CBOXSPA" )
aAdd( aEstrut, "X3_CBOXENG" )
aAdd( aEstrut, "X3_PICTVAR" )
aAdd( aEstrut, "X3_WHEN" )
aAdd( aEstrut, "X3_INIBRW" )
aAdd( aEstrut, "X3_GRPSXG" )
aAdd( aEstrut, "X3_FOLDER" )
aAdd( aEstrut, "X3_PYME" )
aAdd( aEstrut, "X3_CONDSQL" )
aAdd( aEstrut, "X3_CHKSQL" )
aAdd( aEstrut, "X3_IDXSRV" )
aAdd( aEstrut, "X3_ORTOGRA" )
aAdd( aEstrut, "X3_IDXFLD" )
aAdd( aEstrut, "X3_TELA" )
aAdd( aEstrut, "X3_PICBRV" )
aAdd( aEstrut, "X3_AGRUP" )
aAdd( aEstrut, "X3_POSLGT" )
aAdd( aEstrut, "X3_MODAL" )

aTmp := {}
aAdd( aTmp, { 'SRA', .T. } )														//X3_ARQUIVO
aAdd( aTmp, { '58', .T. } )														//X3_ORDEM
aAdd( aTmp, { 'RA_XWKF', .T. } )											//X3_CAMPO
aAdd( aTmp, { 'C', .T. } )														//X3_TIPO
aAdd( aTmp, { 2, .T. } )															//X3_TAMANHO
aAdd( aTmp, { 0, .T. } )															//X3_DECIMAL
aAdd( aTmp, { 'Workflow', .T. } )											//X3_TITULO
aAdd( aTmp, { 'Workflow', .T. } )											//X3_TITSPA
aAdd( aTmp, { 'Workflow', .T. } )											//X3_TITENG
aAdd( aTmp, { 'Workflow', .T. } )										//X3_DESCRIC
aAdd( aTmp, { 'Workflow', .T. } )										//X3_DESCSPA
aAdd( aTmp, { 'Workflow', .T. } )										//X3_DESCENG
aAdd( aTmp, { '', .T. } )															//X3_PICTURE
aAdd( aTmp, { '', .T. } )															//X3_VALID
aAdd( aTmp, { 'x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x', .T. } )//X3_USADO
aAdd( aTmp, { '', .T. } )															//X3_RELACAO
aAdd( aTmp, { '', .T. } )															//X3_F3
aAdd( aTmp, { 1, .T. } )															//X3_NIVEL
aAdd( aTmp, { 'xxxxxx x', .T. } )												//X3_RESERV
aAdd( aTmp, { '', .T. } )															//X3_CHECK
aAdd( aTmp, { '', .T. } )															//X3_TRIGGER
aAdd( aTmp, { 'U', .T. } )															//X3_PROPRI
aAdd( aTmp, { 'S', .T. } )														//X3_BROWSE
aAdd( aTmp, { 'V', .T. } )															//X3_VISUAL
aAdd( aTmp, { 'R', .T. } )															//X3_CONTEXT
aAdd( aTmp, { '', .T. } )														//X3_OBRIGAT
aAdd( aTmp, { '', .T. } )															//X3_VLDUSER
aAdd( aTmp, { '', .T. } )															//X3_CBOX
aAdd( aTmp, { '', .T. } )															//X3_CBOXSPA
aAdd( aTmp, { '', .T. } )															//X3_CBOXENG
aAdd( aTmp, { '', .T. } )															//X3_PICTVAR
aAdd( aTmp, { '', .T. } )															//X3_WHEN
aAdd( aTmp, { '', .T. } )															//X3_INIBRW
aAdd( aTmp, { '', .T. } )															//X3_GRPSXG
aAdd( aTmp, { '', .T. } )														//X3_FOLDER
aAdd( aTmp, { '', .T. } )														//X3_PYME
aAdd( aTmp, { '', .T. } )															//X3_CONDSQL
aAdd( aTmp, { '', .T. } )															//X3_CHKSQL
aAdd( aTmp, { '', .T. } )														//X3_IDXSRV
aAdd( aTmp, { '', .T. } )														//X3_ORTOGRA
aAdd( aTmp, { '', .T. } )														//X3_IDXFLD
aAdd( aTmp, { '', .T. } )															//X3_TELA
aAdd( aTmp, { '', .T. } )															//X3_PICBRV
aAdd( aTmp, { '', .T. } )														//X3_AGRUP
aAdd( aTmp, { '', .T. } )														//X3_POSLGT
aAdd( aTmp, { '', .T. } )														//X3_MODAL
aAdd( aSX3, aTmp )

//
// Atualizando dicionário
//

nPosArq := aScan( aEstrut, { |x| AllTrim( x ) == "X3_ARQUIVO" } )
nPosOrd := aScan( aEstrut, { |x| AllTrim( x ) == "X3_ORDEM"   } )
nPosCpo := aScan( aEstrut, { |x| AllTrim( x ) == "X3_CAMPO"   } )
nPosTam := aScan( aEstrut, { |x| AllTrim( x ) == "X3_TAMANHO" } )
nPosSXG := aScan( aEstrut, { |x| AllTrim( x ) == "X3_GRPSXG"  } )

aSort( aSX3,,, { |x,y| x[nPosArq][1]+x[nPosOrd][1]+x[nPosCpo][1] < y[nPosArq][1]+y[nPosOrd][1]+y[nPosCpo][1] } )

oProcess:SetRegua2( Len( aSX3 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )
cAliasAtu := ""

For nI := 1 To Len( aSX3 )

	//
	// Verifica se o campo faz parte de um grupo e ajsuta tamanho
	//
	If !Empty( aSX3[nI][nPosSXG][1] )
		SXG->( dbSetOrder( 1 ) )
		If SXG->( dbSeek( aSX3[nI][nPosSXG][1] ) )
			If aSX3[nI][nPosTam][1] <> SXG->XG_SIZE
				aSX3[nI][nPosTam][1] := SXG->XG_SIZE
				AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo][1] + " nao atualizado e foi mantido em [" + ;
							AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF + ;
							"por pertencer ao grupo de campos [" + SXG->XG_GRUPO + "]" + CRLF ) 
			EndIf
		EndIf
	EndIf

	SX3->( dbSetOrder( 2 ) )

	If !( aSX3[nI][nPosArq][1] $ cAlias )
		cAlias += aSX3[nI][nPosArq][1] + "/"
		aAdd( aArqUpd, aSX3[nI][nPosArq][1] )
	EndIf

	If !SX3->( dbSeek( PadR( aSX3[nI][nPosCpo][1], nTamSeek ) ) )

		//
		// Busca ultima ocorrencia do alias
		//
		If ( aSX3[nI][nPosArq][1] <> cAliasAtu )
			cSeqAtu   := "00"
			cAliasAtu := aSX3[nI][nPosArq][1]

			dbSetOrder( 1 )
			SX3->( dbSeek( cAliasAtu + "ZZ", .T. ) )
			dbSkip( -1 )

			If ( SX3->X3_ARQUIVO == cAliasAtu )
				cSeqAtu := SX3->X3_ORDEM
			EndIf

			nSeqAtu := Val( RetAsc( cSeqAtu, 3, .F. ) )
		EndIf

		nSeqAtu++
		cSeqAtu := RetAsc( Str( nSeqAtu ), 2, .T. )

		RecLock( "SX3", .T. )
		For nJ := 1 To Len( aSX3[nI] )
			If nJ == nPosOrd  // Ordem
				SX3->( FieldPut( FieldPos( aEstrut[nJ] ), cSeqAtu ) )

			ElseIf FieldPos( aEstrut[nJ] ) > 0
				SX3->( FieldPut( FieldPos( aEstrut[nJ] ), aSX3[nI][nJ][1] ) )

			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

		AutoGrLog( "Criado o campo " + aSX3[nI][nPosCpo][1] ) 

	Else

		//
		// Verifica se o campo faz parte de um grupo e ajsuta tamanho
		//
		If !Empty( SX3->X3_GRPSXG ) .AND. SX3->X3_GRPSXG <> aSX3[nI][nPosSXG][1]
			SXG->( dbSetOrder( 1 ) )
			If SXG->( dbSeek( SX3->X3_GRPSXG ) )
				If aSX3[nI][nPosTam][1] <> SXG->XG_SIZE
					aSX3[nI][nPosTam][1] := SXG->XG_SIZE
					AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo][1] + " nao atualizado e foi mantido em [" + ; 
								AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF + ; 
								" por pertencer ao grupo de campos [" + SX3->X3_GRPSXG + "]" + CRLF + CRLF )
				EndIf
			EndIf
		EndIf

		//
		// Verifica todos os campos
		//
		For nJ := 1 To Len( aSX3[nI] )

			//
			// Se o campo estiver diferente da estrutura
			//
			If aSX3[nI][nJ][2] ;

				cX3Campo := AllTrim( SX3->( FieldName( nJ ) ) )
				cX3Dado  := SX3->( FieldGet( nJ ) )

				If aEstrut[nJ] == SX3->( FieldName( nJ ) ) .AND. ;
					PadR( StrTran( AllToChar( cX3Dado ), " ", "" ), 250 ) <> ;
					PadR( StrTran( AllToChar( aSX3[nI][nJ][1] )           , " ", "" ), 250 ) .AND. ;
					cX3Campo <> "X3_ORDEM"

						AutoGrLog( "Alterado o campo " + aSX3[nI][nPosCpo][1] ) 
						AutoGrLog( "   " + PadR( cX3Campo, 10 ) + " de [" + AllToChar( cX3Dado ) + "]" ) 
						AutoGrLog( "            para [" + AllToChar( aSX3[nI][nJ][1] )          + "]" + CRLF ) 

						RecLock( "SX3", .F. )
						FieldPut( FieldPos( aEstrut[nJ] ), aSX3[nI][nJ][1] )
						
						MsUnLock()

				EndIf

			EndIf

		Next

	EndIf

	oProcess:IncRegua2( "Atualizando Campos de Tabelas (SX3)..." )

Next nI

AutoGrLog( "Final da Atualizacao SX3" + CRLF + Replicate( "-", 128 ) + CRLF ) 

Return( Nil )



/*/{Protheus.doc} UPDSX6
Atualiza SX6

@type			function
@author		UDTOOLS
@since		22/02/2025

@example		UPDSX6()
/*/
Static Function UPDSX6()
Local aEstrut   := {}
Local aSX6      := {}
Local aTmp	  := {}
Local cAlias    := ""
Local cMsg      := ""
Local lContinua := .T.
Local lReclock  := .T.
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nX        := 0
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0
Local nTamFil   := Len( SX6->X6_FIL )
Local nTamVar   := Len( SX6->X6_VAR )
Local aFilProc	:= {} 

AutoGrLog( "Inicio da Atualizacao SX6" + CRLF ) 

aAdd( aEstrut, "X6_FIL" )
aAdd( aEstrut, "X6_VAR" )
aAdd( aEstrut, "X6_TIPO" )
aAdd( aEstrut, "X6_DESCRIC" )
aAdd( aEstrut, "X6_DSCSPA" )
aAdd( aEstrut, "X6_DSCENG" )
aAdd( aEstrut, "X6_DESC1" )
aAdd( aEstrut, "X6_DSCSPA1" )
aAdd( aEstrut, "X6_DSCENG1" )
aAdd( aEstrut, "X6_DESC2" )
aAdd( aEstrut, "X6_DSCSPA2" )
aAdd( aEstrut, "X6_DSCENG2" )
aAdd( aEstrut, "X6_CONTEUD" )
aAdd( aEstrut, "X6_CONTSPA" )
aAdd( aEstrut, "X6_CONTENG" )
aAdd( aEstrut, "X6_PROPRI" )
aAdd( aEstrut, "X6_PYME" )
aAdd( aEstrut, "X6_VALID" )
aAdd( aEstrut, "X6_INIT" )
aAdd( aEstrut, "X6_DEFPOR" )
aAdd( aEstrut, "X6_DEFSPA" )
aAdd( aEstrut, "X6_DEFENG" )
aAdd( aEstrut, "X6_EXPDEST" )

aAdd( aFilProc, "" )

aTmp := {}
aAdd( aTmp, '' )																		//X6_FIL
aAdd( aTmp, 'MB_GPEA01A' )														//X6_VAR
aAdd( aTmp, 'C' )																	//X6_TIPO
aAdd( aTmp, 'Envio de workflow de admissão e demissão' )	//X6_DESCRIC
aAdd( aTmp, '' )	//X6_DSCSPA
aAdd( aTmp, '' )	//X6_DSCENG
aAdd( aTmp, 'de funcionário' )																		//X6_DESC1
aAdd( aTmp, '' )																		//X6_DSCSPA1
aAdd( aTmp, '' )																		//X6_DSCENG1
aAdd( aTmp, 'MBGPEA01' )																		//X6_DESC2
aAdd( aTmp, '' )																		//X6_DSCSPA2
aAdd( aTmp, '' )																		//X6_DSCENG2
aAdd( aTmp, 'eurai.rapelli@logithink.it' )											//X6_CONTEUD
aAdd( aTmp, 'ambulatorio@minebea-as.com; sesmt_mas-s@minebea-as.com; rh_mas-s@minebea-as.com; ti_mas-s@minebea-as.com; portaria_mas-s@minebea-as.com' )											//X6_CONTSPA
aAdd( aTmp, 'ambulatorio@minebea-as.com; sesmt_mas-s@minebea-as.com; rh_mas-s@minebea-as.com; ti_mas-s@minebea-as.com; portaria_mas-s@minebea-as.com' )											//X6_CONTENG
aAdd( aTmp, 'U' )																	//X6_PROPRI
aAdd( aTmp, '' )																		//X6_PYME
aAdd( aTmp, '' )																		//X6_VALID
aAdd( aTmp, '' )																		//X6_INIT
aAdd( aTmp, '' )																		//X6_DEFPOR
aAdd( aTmp, '' )																		//X6_DEFSPA
aAdd( aTmp, '' )																		//X6_DEFENG
aAdd( aTmp, '' )																		//X6_EXPDEST
aAdd( aSX6, aTmp )

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX6 ) )

dbSelectArea( "SX6" )
dbSetOrder( 1 )

For nX := 1 to Len( aFilProc )

	For nI := 1 To Len( aSX6 )

		aSX6[nI,aScan(aEstrut,{ |UA| UA == "X6_FIL" })] := aFilProc[nX] 

		If !SX6->( dbSeek( PadR( aSX6[nI][1], nTamFil ) + PadR( aSX6[nI][2], nTamVar ) ) )
			lReclock  := .T.
			AutoGrLog( "Foi incluído o parâmetro " + aSX6[nI][1] + aSX6[nI][2] + " Conteúdo [" + AllTrim( aSX6[nI][13] ) + "]"+ CRLF ) 
		Else
			lReclock  := .F.
			AutoGrLog( "Foi alterado o parâmetro " + aSX6[nI][1] + aSX6[nI][2] + " Conteúdo [" + AllTrim( aSX6[nI][13] ) + "]"+ CRLF ) 
		EndIf

		If !( aSX6[nI][1] $ cAlias )
			cAlias += aSX6[nI][1] + "/"
		EndIf

		RecLock( "SX6", lReclock )
		For nJ := 1 To Len( aSX6[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX6[nI][nJ] )
			EndIf
		Next nJ
		dbCommit()
		MsUnLock()

		oProcess:IncRegua2( "Atualizando Arquivos (SX6)..." )

	Next nI

Next nX

AutoGrLog( "Final da Atualizacao SX6" + CRLF + Replicate( "-", 128 ) + CRLF ) 

Return( Nil )



/*/{Protheus.doc} EscEmpresa
Funcao Generica para escolha de Empresa, montado pelo SM0
Retorna vetor contendo as selecoes feitas
Se nao For marcada nenhuma o vetor volta vazio

@type			function
@author		UDTOOLS
@since		22/02/2025

@example		EscEmpresa()
/*/
Static Function EscEmpresa()
Local   aSalvAmb := GetArea()
Local   aSalvSM0 := {}
Local   aRet     := {}
Local   aVetor   := {}
Local   oDlg     := NIL
Local   oChkMar  := NIL
Local   oLbx     := NIL
Local   oMascEmp := NIL
Local   oMascFil := NIL
Local   oButMarc := NIL
Local   oButDMar := NIL
Local   oButInv  := NIL
Local   oSay     := NIL
Local   oOk      := LoadBitmap( GetResources(), "LBOK" )
Local   oNo      := LoadBitmap( GetResources(), "LBNO" )
Local   lChk     := .F.
Local   lOk      := .F.
Local   lTeveMarc:= .F.
Local   cVar     := ""
Local   cNomEmp  := ""
Local   cMascEmp := "??"
Local   cMascFil := "??"

Local   aMarcadas  := {}


If !MyOpenSm0(.T.)
	Return( aRet )
EndIf

dbSelectArea( "SM0" )
aSalvSM0 := SM0->( GetArea() )
dbSetOrder( 1 )
dbGoTop()

Do While !SM0->( EOF() )

	If aScan( aVetor, {|x| x[2] == SM0->M0_CODIGO} ) == 0
		aAdd(  aVetor, { aScan( aMarcadas, {|x| x[1] == SM0->M0_CODIGO .and. x[2] == SM0->M0_CODFIL} ) > 0, SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
 	EndIf

 	SM0->( dbSkip() )
EndDo

RestArea( aSalvSM0 )

Define MSDialog  oDlg Title "" From 0, 0 To 270, 396 Pixel

oDlg:cToolTip := "Tela para Múltiplas Seleções de Empresas/Filiais"

oDlg:cTitle   := "Selecione a(s) Empresa(s) para Atualização"

@ 10, 10 Listbox  oLbx Var  cVar Fields Header " ", " ", "Empresa" Size 178, 095 Of oDlg Pixel
oLbx:SetArray(  aVetor )
oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
aVetor[oLbx:nAt, 2], ;
aVetor[oLbx:nAt, 4]}}
oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
oLbx:cToolTip   :=  oDlg:cTitle
oLbx:lHScroll   := .F. // NoScroll

@ 112, 10 CheckBox oChkMar Var  lChk Prompt "Todos"   Message  Size 40, 007 Pixel Of oDlg;
on Click MarcaTodos( lChk, @aVetor, oLbx )

@ 123, 10 Button oButInv Prompt "&Inverter"  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Inverter Seleção" Of oDlg

// Marca/Desmarca por mascara
@ 113, 51 Say  oSay Prompt "Empresa" Size  40, 08 Of oDlg Pixel
@ 112, 80 MSGet  oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), cMascFil := StrTran( cMascFil, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
Message "Máscara Empresa ( ?? )"  Of oDlg
@ 123, 50 Button oButMarc Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Marcar usando máscara ( ?? )"    Of oDlg
@ 123, 80 Button oButDMar Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando máscara ( ?? )" Of oDlg

Define SButton From 111, 125 Type 1 Action ( RetSelecao( @aRet, aVetor ), oDlg:End() ) OnStop "Confirma a Seleção"  Enable Of oDlg
Define SButton From 111, 158 Type 2 Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) OnStop "Abandona a Seleção" Enable Of oDlg
Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( "SM0" )
dbCloseArea()

Return( aRet )

/*/{Protheus.doc} MarcaTodos
Funcao Auxiliar para marcar/desmarcar todos os itens do ListBox ativo

@type			function
@author		UDTOOLS
@since		22/02/2025

@param		lMarca, Boolean, Marca
@param		aVetor, Array, Vetor
@param		oLbx, Objeto, Box

@example		MarcaTodos()
/*/
Static Function MarcaTodos( lMarca, aVetor, oLbx )
Local nI			:= 0
Local nTamArray	:= 0

nTamArray := Len( aVetor )
For nI := 1 To nTamArray
	aVetor[nI][1] := lMarca
Next nI

oLbx:Refresh()

Return( Nil )

/*/{Protheus.doc} InvSelecao
Funcao Auxiliar para inverter selecao do ListBox Ativo

@type			function
@author		UDTOOLS
@since		22/02/2025

@param		aVetor, Array, Vetor
@param		oLbx, Objeto, Box

@example		InvSelecao()
/*/
Static Function InvSelecao( aVetor, oLbx )
Local nI 			:= 0
Local nTamArray	:= 0

nTamArray := Len( aVetor )
For nI := 1 To nTamArray
	aVetor[nI][1] := !aVetor[nI][1]
Next nI

oLbx:Refresh()

Return( Nil )

/*/{Protheus.doc} RetSelecao
Funcao Auxiliar que monta o retorno com as selecoes

@type			function
@author		UDTOOLS
@since		22/02/2025

@param		aRet, Array, Retorno
@param		aVetor, Array, Vetor

@example		RetSelecao()
/*/
Static Function RetSelecao( aRet, aVetor )
Local nI			:= 0
Local nTamArray	:= 0

aRet := {}
nTamArray := Len( aVetor )
For nI := 1 To nTamArray
	If aVetor[nI][1]
 		aAdd( aRet, { aVetor[nI][2] , aVetor[nI][3], aVetor[nI][2] +  aVetor[nI][3] } )
 	EndIf
Next nI

Return( Nil )

/*/{Protheus.doc} MarcaMas
Funcao para marcar/desmarcar usando mascaras

@type			function
@author		UDTOOLS
@since		22/02/2025

@param		oLbx, Objeto, Box
@param		aVetor, Array, Vetor
@param		cMascEmp, String, Mascara
@param		lMarDes, Boolean, Marca

@example		MarcaMas()
/*/
Static Function MarcaMas( oLbx, aVetor, cMascEmp, lMarDes )
Local cPos1		:= SubStr( cMascEmp, 1, 1 )
Local cPos2		:= SubStr( cMascEmp, 2, 1 )
Local nPos		:= oLbx:nAt
Local nZ			:= 0
Local nTamArray	:= 0

nTamArray := Len( aVetor )
For nZ := 1 To nTamArray
	If cPos1 == "?" .or. SubStr( aVetor[nZ][2], 1, 1 ) == cPos1
 		If cPos2 == "?" .or. SubStr( aVetor[nZ][2], 2, 1 ) == cPos2
 			aVetor[nZ][1] :=  lMarDes
 		EndIf
 	EndIf
Next nX

oLbx:nAt := nPos
oLbx:Refresh()

Return( Nil )

/*/{Protheus.doc} VerTodos
Funcao auxiliar para verificar se estao todos marcardos ou nao

@type			function
@author		UDTOOLS
@since		22/02/2025

@param		aVetor, Array, Vetor
@param		lChk, Boolean, Check
@param		oChkMar, Objeto, Check

@example		VerTodos()
/*/
Static Function VerTodos( aVetor, lChk, oChkMar )
Local lTrue		:= .T.
Local nTamArray	:= 0
Local nI			:= 0

nTamArray := Len( aVetor )
For nI := 1 To nTamArray
 	lTrue := IIf( !aVetor[nI][1], .F., lTrue )
Next nI

lChk := IIf( lTrue, .T., .F. )
oChkMar:Refresh()

Return( Nil )

/*/{Protheus.doc} MyOpenSM0
Funcao de processamento abertura do SM0 modo exclusivo

@type			function
@author		UDTOOLS
@since		22/02/2025

@param		lShared, Boolean, Compartilhada

@return		lOpen, Boolean, Abriu?

@example		MyOpenSM0(lShared)
/*/
Static Function MyOpenSM0(lShared)
Local lOpen := .F.
Local nLoop := 0

For nLoop := 1 To 10
	If lShared
		OpenSM0()
	Else
		OpenSM0Excl()
	Endif

	If !Empty( Select( "SM0" ) )
 		lOpen := .T.
 		Exit
 	EndIf

 	Sleep( 500 )

Next nLoop

If !lOpen
 	MsgStop( "Não foi possível a abertura da tabela " + ;
 	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENÇÃO" )
EndIf

Return( lOpen )

/*/{Protheus.doc} LeLog 
Função de leitura do LOG gerado com limitacao de string 
 
@type			function
@author		UDTOOLS
@since  		18/05/2015 
/*/ 
Static Function LeLog() 
Local cRet	:= "" 
Local cFile := NomeAutoLog() 
Local cAux	:= ""  
 
FT_FUSE( cFile ) 
FT_FGOTOP() 
 
While !FT_FEOF() 
 
	cAux := FT_FREADLN() 
 
	If Len( cRet ) + Len( cAux ) < 1048000 
		cRet += cAux + CRLF 
	Else 
		cRet += CRLF 
		cRet += Replicate( "=" , 128 ) + CRLF 
		cRet += "Tamanho de exibição maxima do LOG alcançado." + CRLF 
		cRet += "LOG Completo no arquivo " + cFile + CRLF 
		cRet += Replicate( "=" , 128 ) + CRLF 
		Exit 
	EndIf 
 
	FT_FSKIP() 
End 
 
FT_FUSE()
 
Return( cRet ) 
