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
User Function AMPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
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
¦¦¦ Função    ¦ AMDispara  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 11/01/2017 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Efetua execução dos gatilhos do campo                         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AMDispara(cCampo,xValor,nPos,lValid)
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

User FUNCTION fNoAcento(cString)
Local cChar  := ""
Local nX     := 0 
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ" 
Local cTio   := "ãõÃÕ"
Local cCecid := "çÇ"
Local cMaior := "&lt;"
Local cMenor := "&gt;"

If ValType(cString) <> "C"
	Return cString
Endif

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf		
		nY:= At(cChar,cTio)
		If nY > 0          
			cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
		EndIf		
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next

If cMaior$ cString 
	cString := strTran( cString, cMaior, "" ) 
EndIf
If cMenor$ cString 
	cString := strTran( cString, cMenor, "" )
EndIf

cString := StrTran( cString, CRLF, " " )

Return cString

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CriaHeader ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 15/04/2023 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria a variavel vetor aHeader                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AMCriaHeader(cAlias,lVirtual,aAcho)
	Local nX
	Local aFields := FWSX3Util():GetAllFields(cAlias)     // Retorna todos os campos ativos para a tabela
	Local aRet    := {}
	
	Default aAcho    := {}
	Default lVirtual := .T.
	
	For nX:=1 To Len(aFields)
		If X3USO(GetSx3Cache(aFields[nX], 'X3_USADO')) .And. cNivel >= GetSx3Cache(aFields[nX], 'X3_NIVEL') .And. AScan(aAcho,Trim(aFields[nX])) == 0
			If lVirtual .Or. GetSx3Cache(aFields[nX], 'X3_CONTEXT') <> "V"
				u_AMAdicionaCampo(aFields[nX],@aRet)
			Endif
		Endif
	Next
	
Return aRet

User Function AMAdicionaCampo(cCampo,aCabec)
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
Return Len(aCabec)
