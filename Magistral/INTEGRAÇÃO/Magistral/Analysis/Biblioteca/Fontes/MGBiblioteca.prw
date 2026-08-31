#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PutSx1    ³ Autor ³Wagner                 ³ Data ³ 14/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria uma pergunta usando rotina padrao                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MGPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,cVar01,;
	cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)
	
	LOCAL aArea := GetArea()
	Local cKey, nX, nPos
	Local lPort := .f.
	Local lSpa  := .f.
	Local lIngl := .f.
	Local aSX1  := {}
	Local cSX1  := "SX1"
	
	Default cDef01   := ""
	Default cDefSpa1 := ""
	Default cDefEng1 := ""
	Default cCnt01   := ""
	Default cDef02   := ""
	Default cDefSpa2 := ""
	Default cDefEng2 := ""
	Default cDef03   := ""
	Default cDefSpa3 := ""
	Default cDefEng3 := ""
	Default cDef04   := ""
	Default cDefSpa4 := ""
	Default cDefEng4 := ""
	Default cDef05   := ""
	Default cDefSpa5 := ""
	Default cDefEng5 := ""
	Default aHelpPor := {}
	Default aHelpEng := {}
	Default aHelpSpa := {}
	Default cHelp    := ""
	
	If .T. //GetVersao(.F.) < "12"
		cKey  := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."
		
		cPyme    := Iif( cPyme 		== Nil, " ", cPyme		)
		cF3      := Iif( cF3 		== NIl, " ", cF3		)
		cGrpSxg  := Iif( cGrpSxg	== Nil, " ", cGrpSxg	)
		cCnt01   := Iif( cCnt01		== Nil, "" , cCnt01 	)
		cHelp	 := Iif( cHelp		== Nil, "" , cHelp		)
		
		dbSelectArea( cSX1 )
		dbSetOrder( 1 )
		
		// Ajusta o tamanho do grupo. Ajuste emergencial para validacao dos fontes.
		// RFC - 15/03/2007
		cGrupo := PadR( cGrupo , Len( Conteudo(cSX1,"X1_GRUPO") ) , " " )
		
		If !( DbSeek( cGrupo + cOrdem ))
			AAdd( aSX1 , { "X1_GRUPO"  , {|| cGrupo   }, {|| .T. } } )
			AAdd( aSX1 , { "X1_ORDEM"  , {|| cOrdem   }, {|| .T. } } )
			AAdd( aSX1 , { "X1_PERGUNT", {|| cPergunt }, {|| .T. } } )
			AAdd( aSX1 , { "X1_PERSPA" , {|| cPerSpa  }, {|| .T. } } )
			AAdd( aSX1 , { "X1_PERENG" , {|| cPerEng  }, {|| .T. } } )
			AAdd( aSX1 , { "X1_VARIAVL", {|| cVar     }, {|| .T. } } )
			AAdd( aSX1 , { "X1_TIPO"   , {|| cTipo    }, {|| .T. } } )
			AAdd( aSX1 , { "X1_TAMANHO", {|| nTamanho }, {|| .T. } } )
			AAdd( aSX1 , { "X1_DECIMAL", {|| nDecimal }, {|| .T. } } )
			AAdd( aSX1 , { "X1_PRESEL" , {|| nPresel  }, {|| .T. } } )
			AAdd( aSX1 , { "X1_GSC"    , {|| cGSC     }, {|| .T. } } )
			AAdd( aSX1 , { "X1_VALID"  , {|| cValid   }, {|| .T. } } )
			AAdd( aSX1 , { "X1_VAR01"  , {|| cVar01   }, {|| .T. } } )
			AAdd( aSX1 , { "X1_F3"     , {|| cF3      }, {|| .T. } } )
			AAdd( aSX1 , { "X1_GRPSXG" , {|| cGrpSxg  }, {|| .T. } } )
			AAdd( aSX1 , { "X1_PYME"   , {|| cPyme    }, {|| cPyme != Nil } } )
			AAdd( aSX1 , { "X1_CNT01"  , {|| cCnt01   }, {|| .T. } } )
			AAdd( aSX1 , { "X1_DEF01"  , {|| cDef01   }, {|| cGSC == "C" } } )
			AAdd( aSX1 , { "X1_DEFSPA1", {|| cDefSpa1 }, {|| cGSC == "C" } } )
			AAdd( aSX1 , { "X1_DEFENG1", {|| cDefEng1 }, {|| cGSC == "C" } } )
			AAdd( aSX1 , { "X1_DEF02"  , {|| cDef02   }, {|| cGSC == "C" } } )
			AAdd( aSX1 , { "X1_DEFSPA2", {|| cDefSpa2 }, {|| cGSC == "C" } } )
			AAdd( aSX1 , { "X1_DEFENG2", {|| cDefEng2 }, {|| cGSC == "C" } } )
			AAdd( aSX1 , { "X1_DEF03"  , {|| cDef03   }, {|| cGSC == "C" } } )
			AAdd( aSX1 , { "X1_DEFSPA3", {|| cDefSpa3 }, {|| cGSC == "C" } } )
			AAdd( aSX1 , { "X1_DEFENG3", {|| cDefEng3 }, {|| cGSC == "C" } } )
			AAdd( aSX1 , { "X1_DEF04"  , {|| cDef04   }, {|| cGSC == "C" } } )
			AAdd( aSX1 , { "X1_DEFSPA4", {|| cDefSpa4 }, {|| cGSC == "C" } } )
			AAdd( aSX1 , { "X1_DEFENG4", {|| cDefEng4 }, {|| cGSC == "C" } } )
			AAdd( aSX1 , { "X1_DEF05"  , {|| cDef05   }, {|| cGSC == "C" } } )
			AAdd( aSX1 , { "X1_DEFSPA5", {|| cDefSpa5 }, {|| cGSC == "C" } } )
			AAdd( aSX1 , { "X1_DEFENG5", {|| cDefEng5 }, {|| cGSC == "C" } } )
			AAdd( aSX1 , { "X1_HELP"   , {|| cHelp    }, {|| .T. } } )
			
			cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
			cPerSpa	:= If(! "?" $ cPerSpa  .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
			cPerEng	:= If(! "?" $ cPerEng  .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)
			
			RecLock( cSX1 , .T. )
			
			For nX:=1 To Len(aSX1)
				If (nPos := (cSX1)->(FieldPos(aSX1[nX,1]))) > 0 .And. Eval( aSX1[nX,3] )
					(cSX1)->( FieldPut( nPos , Eval(aSX1[nX,2]) ) )
				Endif
			Next
			
			PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
		
			MsUnLock()
		Else
		
		lPort := ! "?" $ Conteudo(cSX1,"X1_PERGUNT") .And. ! Empty(Conteudo(cSX1,"X1_PERGUNT"))
		lSpa  := ! "?" $ Conteudo(cSX1,"X1_PERSPA")  .And. ! Empty(Conteudo(cSX1,"X1_PERSPA"))
		lIngl := ! "?" $ Conteudo(cSX1,"X1_PERENG")  .And. ! Empty(Conteudo(cSX1,"X1_PERENG"))
		
		If lPort .Or. lSpa .Or. lIngl
				AAdd( aSX1 , { "X1_PERGUNT", {|| AllTrim(Conteudo(cSX1,"X1_PERGUNT")) }, {|| lPort } } )
				AAdd( aSX1 , { "X1_PERSPA" , {|| AllTrim(Conteudo(cSX1,"X1_PERSPA" )) }, {|| lSpa  } } )
				AAdd( aSX1 , { "X1_PERENG" , {|| AllTrim(Conteudo(cSX1,"X1_PERENG" )) }, {|| lIngl } } )
				
				RecLock(cSX1,.F.)
				For nX:=1 To Len(aSX1)
					If (nPos := (cSX1)->(FieldPos(aSX1[nX,1]))) > 0 .And. Eval( aSX1[nX,3] )
						(cSX1)->( FieldPut( nPos , Eval(aSX1[nX,2]) ) )
					Endif
				Next
				MsUnLock()
			EndIf
		Endif
		
		RestArea( aArea )
	Endif
Return

Static Function Conteudo(cAlias,cCampo)
	Local nPos := (cAlias)->(FieldPos(cCampo))
Return (cAlias)->(FieldGet(nPos))

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MGDispara  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 11/01/2017 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Efetua execução dos gatilhos do campo                         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MGDispara(cCampo,xValor,nPos,lValid)
	Local bValida := Nil
	Local cAlias  := Alias()
	Local cValida := ""
	Local cAux    := __ReadVar
	Local nAuxN   := If( Type("n") == "N" , n, 1)
	Local aArea   := SB1->(GetArea())
	Local lRet    := .T.
	
	Default nPos   := Len(aCols)
	Default lValid := .T.
	
	cCampo := PADR(cCampo,Len(GetSx3Cache(cCampo,'X3_CAMPO')))   // Ajusta o tamanho da variávei para localizar corretamente o campo
	
	If lValid
		If !Empty(GetSx3Cache(cCampo, 'X3_VALID'))
			cValida += Trim(GetSx3Cache(cCampo, 'X3_VALID'))
		Endif
		If !Empty(GetSx3Cache(cCampo, 'X3_VLDUSER'))
			cValida += If( Empty(cValida) , "", ".And.")+Trim(GetSx3Cache(cCampo, 'X3_VLDUSER'))
		Endif
		
		nPos := If( nPos == Nil , Len(aCols), nPos)
		
		bValida := &("{|| "+If(Empty(cValida),".T.",cValida)+" }")
	Endif
	
	__ReadVar := "M->" + Trim(cCampo)
	
	M->&(cCampo) := xValor
	
	n := nPos
	
	If lRet := bValida == Nil .Or. Eval(bValida)
		If ExistTrigger(cCampo)
			(cAlias)->(RunTrigger(2,nPos,,,cCampo))
		Endif
	EndIf
	
	n := nAuxN
	__ReadVar := cAux
	RestArea(aArea)
	
Return lRet

User Function fConOut(cTexto)
    //Local aArea    := GetArea()
    Default cTexto := ""
     
    Conout(cTexto)
	/*FWLogMsg(;
        "INFO",;    //cSeverity      - Informe a severidade da mensagem de log. As opções possíveis são: INFO, WARN, ERROR, FATAL, DEBUG
        ,;          //cTransactionId - Informe o Id de identificação da transação para operações correlatas. Informe "LAST" para o sistema assumir o mesmo id anterior
        "FCONOUT",; //cGroup         - Informe o Id do agrupador de mensagem de Log
        ,;          //cCategory      - Informe o Id da categoria da mensagem
        ,;          //cStep          - Informe o Id do passo da mensagem
        ,;          //cMsgId         - Informe o Id do código da mensagem
        cTexto,;    //cMessage       - Informe a mensagem de log. Limitada à 10K
        ,;          //nMensure       - Informe a uma unidade de medida da mensagem
        ,;          //nElapseTime    - Informe o tempo decorrido da transação
        ;           //aMessage       - Informe a mensagem de log em formato de Array - Ex: { {"Chave" ,"Valor"} }
    )
     
    RestArea(aArea)*/
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CriaHeader ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 15/04/2023 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria a variavel vetor aHeader                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MGCriaHeader(cAlias,lVirtual,aAcho)
	Local nX
	Local aFields := FWSX3Util():GetAllFields(cAlias)     // Retorna todos os campos ativos para a tabela
	Local aRet    := {}
	
	Default aAcho    := {}
	Default lVirtual := .T.
	
	For nX:=1 To Len(aFields)
		If X3USO(GetSx3Cache(aFields[nX], 'X3_USADO')) .And. cNivel >= GetSx3Cache(aFields[nX], 'X3_NIVEL') .And. AScan(aAcho,Trim(aFields[nX])) == 0
			If lVirtual .Or. GetSx3Cache(aFields[nX], 'X3_CONTEXT') <> "V"
				u_MGAdicionaCampo(aFields[nX],@aRet)
			Endif
		Endif
	Next
	
Return aRet

User Function MGAdicionaCampo(cCampo,aCabec)
	Local cField := GetSx3Cache(cCampo, 'X3_CAMPO')
	
	If cField <> Nil
		AAdd(aCabec, {	GetSx3Cache(cCampo, 'X3_TITULO'),;
						GetSx3Cache(cCampo, 'X3_CAMPO'),;
						GetSx3Cache(cCampo, 'X3_PICTURE'),;
						GetSx3Cache(cCampo, 'X3_TAMANHO'),;
						GetSx3Cache(cCampo, 'X3_DECIMAL'),;
						GetSx3Cache(cCampo, 'X3_VALID'),;
						GetSx3Cache(cCampo, 'X3_USADO'),;
						GetSx3Cache(cCampo, 'X3_TIPO'),;
						GetSx3Cache(cCampo, 'X3_F3'),;
						GetSx3Cache(cCampo, 'X3_CONTEXT'),;
						GetSx3Cache(cCampo, 'X3_CBOX'),;
						GetSx3Cache(cCampo, 'X3_RELACAO'),;
						GetSx3Cache(cCampo, 'X3_WHEN'),;
						GetSx3Cache(cCampo, 'X3_VISUAL'),;
						GetSx3Cache(cCampo, 'X3_VLDUSER'),;
						GetSx3Cache(cCampo, 'X3_PICTVAR'),;
						If(GetSx3Cache(cCampo, 'X3_OBRIGAT') == "€", .T., .F.)} )
	Endif
	
Return Len(aCabec)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MGSendMail ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 26/07/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Monta e envia e-mail                                          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MGSendMail(cPara, cAssunto, cCorpo, aAnexos, cErro, lMostraLog, cCCopia, lUsaTLS, lNovo, cUsrEmail, cPswEmail)
	Local aArea        := GetArea()
	Local nAtual       := 0
	Local lRet         := .F.
	Local oMsg         := Nil
	Local oSrv         := Nil
	Local nRet         := 0
	Local cFrom        := If( cUsrEmail == Nil .Or. Empty(cUsrEmail) , Alltrim(GetMV("MV_RELACNT")), cUsrEmail)
	Local cUser        := cFrom   //SubStr(cFrom, 1, At('@', cFrom)-1)
	Local cPass        := If( cPswEmail == Nil .Or. Empty(cPswEmail) , Alltrim(GetMV("MV_RELPSW" )), cPswEmail)
	Local cSrvFull     := Alltrim(GetMV("MV_RELSERV"))
	Local cServer      := ""
	Local nPort        := 0
	Local nTimeOut     := GetMV("MV_RELTIME")
	Local cLog         := ""
	Local cContaAuth   := ""
	Local cPassAuth    := ""
	Local nAtu         := 0
	Local cProcessos   := ""
	
	Default cPara      := ""
	Default cAssunto   := ""
	Default cCorpo     := ""
	Default aAnexos    := {}
	Default lMostraLog := .F.
	Default cCCopia    := ""
	Default lUsaTLS    := .T.
	Default lNovo      := .F.
	
	//Se tiver em branco o destinatário, o assunto ou o corpo do email
	If Empty(cPara) .Or. Empty(cAssunto) .Or. Empty(cCorpo)
		cLog += "001 - Destinatario, Assunto ou Corpo do e-Mail vazio(s)!" + CRLF
	Else
		If lNovo
			cContaAuth := Alltrim(GetMV("MV_X_NCNT"))
			cPassAuth  := Alltrim(GetMV("MV_X_NPSW"))
			cSrvFull   := Alltrim(GetMV("MV_X_NSRV"))
		Else
			cContaAuth := cFrom
			cPassAuth  := cPass
		EndIf
		
		cServer := Iif(':' $ cSrvFull, SubStr(cSrvFull, 1, At(':', cSrvFull)-1), cSrvFull)
		nPort   := Iif(':' $ cSrvFull, Val(SubStr(cSrvFull, At(':', cSrvFull)+1, Len(cSrvFull))), 587)
		
		//Cria a nova mensagem
		oMsg := TMailMessage():New()
		oMsg:Clear()
		
		//Define os atributos da mensagem
		//oMsg:cDate    := cValToChar(Date())
		oMsg:cFrom    := cFrom
		oMsg:cTo      := cPara
		oMsg:cSubject := cAssunto
		oMsg:cBody    := cCorpo
		
		If !Empty(cCCopia)
			oMsg:cCc  := cCCopia
		Endif
		
		//Percorre os anexos
		For nAtual := 1 To Len(aAnexos)
			//Se o arquivo existir
			If File(aAnexos[nAtual])
				//Anexa o arquivo na mensagem de e-Mail
				nRet := oMsg:AttachFile(aAnexos[nAtual])
				If nRet < 0
					cLog += "002 - Nao foi possivel anexar o arquivo '"+aAnexos[nAtual]+"'!" + CRLF
				EndIf
				//Senao, acrescenta no log
			Else
				cLog += "003 - Arquivo '"+aAnexos[nAtual]+"' nao encontrado!" + CRLF
			EndIf
		Next
		
		//Cria servidor para disparo do e-Mail
		oSrv := tMailManager():New()
		
		//Define se irá utilizar o TLS
		If lUsaTLS
			oSrv:SetUseTLS(.T.)
		EndIf
		
		//Inicializa conexão
		nRet := oSrv:Init("", cServer, cUser, cPass, 0, nPort)
		If nRet != 0
			cLog += "004 - Nao foi possivel inicializar o servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
		Else
			//Define o time out
			nRet := oSrv:SetSMTPTimeout(nTimeOut)
			If nRet <> 0
				cLog += "005 - Nao foi possivel definir o TimeOut '"+cValToChar(nTimeOut)+"'" + CRLF
			Else
				//Conecta no servidor
				nRet := oSrv:SMTPConnect()
				If nRet <> 0
					cLog += "006 - Nao foi possivel conectar no servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
				Else
					//Realiza a autenticação do usuário e senha
					nRet := oSrv:SmtpAuth(cContaAuth, cPassAuth)
					If nRet <> 0
						cLog += "007 - Nao foi possivel autenticar no servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
					Else
						//Envia a mensagem
						nRet := oMsg:Send(oSrv)
						If nRet <> 0
							cLog += "008 - Nao foi possivel enviar a mensagem: " + oSrv:GetErrorString(nRet) + CRLF
						Else
							//Disconecta do servidor
							nRet := oSrv:SMTPDisconnect()
							If nRet <> 0
								cLog += "009 - Nao foi possivel disconectar do servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
							Else
								lRet := .T.
							Endif
						Endif
					Endif
				Endif
			Endif
		Endif
	Endif
	
	//Se tiver log de avisos/erros
	If !Empty(cLog)
		//Busca todas as funções
		nAtu := 0
		cProcessos := ""
		
		/*
		While ! (ProcName(nAtu) == '')
			cProcessos += ProcName(nAtu) + "; "
			nAtu++
		EndDo
		*/
		
		cLog := "+======================= EnvMail =======================+" + CRLF + ;
				"EnvMail   - "+dToC(Date())+ " " + Time() + CRLF + ;
				"Funcao    - " + FunName() + CRLF + ;
				"Processos - " + cProcessos + CRLF + ;
				"De        - " + cFrom + CRLF + ;
				"Para      - " + cPara + CRLF + ;
				"Assunto   - " + cAssunto + CRLF + ;
				"Corpo     - " + cCorpo + CRLF + ;
				"Existem mensagens de aviso: "+ CRLF +;
				cLog + CRLF +;
				"+======================= EnvMail =======================+"
		
		//ConOut(cLog)
		//Se for para mostrar o log visualmente e for processo com interface com o usuário, mostra uma mensagem na tela
		//If lMostraLog .And. !IsBlind()
		//	Aviso("Log", cLog, {"Ok"}, 2)
		//EndIf
		cErro := cLog
	EndIf
	RestArea(aArea)

Return lRet

User Function MGSpedXML(cDocumento, cSerie, cArqXML, lMostra)
	Local aArea        := GetArea()
	Local cURLTss      := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local oWebServ
	Local cIdEnt       := RetIdEnti()
	Local cTextoXML    := ""
	Local oFileXML
	Local lOk          := .F.
	
	Default cDocumento := ""
	Default cSerie     := ""
	Default cArqXML    := GetTempPath()+"arquivo_"+cSerie+cDocumento+".xml"
	Default lMostra    := .F.
	
	//Se tiver documento
	If lOk := !Empty(cDocumento)
		cDocumento := PadR(cDocumento, TamSX3('F2_DOC')[1])
		cSerie     := PadR(cSerie,     TamSX3('F2_SERIE')[1])
		
		//Instancia a conexão com o WebService do TSS
		oWebServ:= WSNFeSBRA():New()
		oWebServ:cUSERTOKEN        := "TOTVS"
		oWebServ:cID_ENT           := cIdEnt
		oWebServ:oWSNFEID          := NFESBRA_NFES2():New()
		oWebServ:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()
		aAdd(oWebServ:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
		aTail(oWebServ:oWSNFEID:oWSNotas:oWSNFESID2):cID := (cSerie+cDocumento)
		oWebServ:nDIASPARAEXCLUSAO := 0
		oWebServ:_URL              := AllTrim(cURLTss)+"/NFeSBRA.apw"
		
		//Se tiver notas
		If lOk := oWebServ:RetornaNotas()
			
			//Se tiver dados
			If lOk := Len(oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3) > 0
				
				//Se tiver sido cancelada
				If oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA != Nil
					cTextoXML := oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA:cXML
					
					//Senão, pega o xml normal (foi alterado abaixo conforme dica do Jorge Alberto)
				Else
					cTextoXML := '<?xml version="1.0" encoding="UTF-8"?>'
					cTextoXML += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">'
					cTextoXML += oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXML
					cTextoXML += oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXMLPROT
					cTextoXML += '</nfeProc>'
				EndIf
				
				//Gera o arquivo
				oFileXML := FWFileWriter():New(cArqXML, .T.)
				oFileXML:SetCaseSensitive(.T.)
				oFileXML:SetEncodeUTF8(.T.)
				oFileXML:Create()
				oFileXML:Write(cTextoXML)
				oFileXML:Close()
				
				//Se for para mostrar, será mostrado um aviso com o conteúdo
				If lMostra
					Aviso("SpedXML", cTextoXML, {"Ok"}, 3)
				EndIf
				
				//Caso não encontre as notas, mostra mensagem
			Else
				u_fConOut("SpedXML > Verificar parâmetros, documento e série não encontrados ("+cDocumento+"/"+cSerie+")...")
				
				If lMostra
					Aviso("SpedXML", "Verificar parâmetros, documento e série não encontrados ("+cDocumento+"/"+cSerie+")...", {"Ok"}, 3)
				EndIf
			EndIf
			
			//Senão, houve erros na classe
		Else
			u_fConOut("SpedXML > "+IIf(Empty(GetWscError(3)), GetWscError(1), GetWscError(3))+"...")
			
			If lMostra
				Aviso("SpedXML", IIf(Empty(GetWscError(3)), GetWscError(1), GetWscError(3)), {"Ok"}, 3)
			EndIf
		EndIf
	EndIf
	RestArea(aArea)

Return lOk
