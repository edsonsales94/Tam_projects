#Include "Rwmake.ch"
#include 'Protheus.ch'

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ SalvaRest  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 24/02/2004 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Efetua salvamento e restauracao dos alias pre-definidos       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function SalvaRest(aAlias,lSalva)
	Local x, aAux := {}
	Local aRet
	
	If If( lSalva == Nil , .T., lSalva)
		For x:=1 To Len(aAlias)
			AAdd( aAux , { aAlias[x] , 0, 0} )
			aAux[x,2] := (aAux[x,1])->( IndexOrd() )
			aAux[x,3] := (aAux[x,1])->( Recno()    )
		Next
		aRet := aClone(aAux)
	Else
		For x:=1 To Len(aAlias)
			dbSelectArea(aAlias[x,1])
			dbSetOrder(aAlias[x,2])
			dbGoTo(aAlias[x,3])
		Next
		aRet := aClone(aAlias)
	Endif
	
Return aRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ INRunExcel ¦ Autor ¦ Nelio Castro Jorio   ¦ Data ¦ 12/09/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Abre um arquivo no Microsoft Excel                            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function INRunExcel(cPath,cArq)
	Local oExcelApp
	
	If !Empty(cArq)
		fClose(nHdl)
		
		If File(cPath+cArq) .And. MsgYesNo("Deseja abrir o arquivo no Excel?")
			oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
			oExcelApp:WorkBooks:Open(cPath+cArq)
			oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.
			oExcelApp:Destroy()
		Endif
	EndIf
	
Return

/*___________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+------------------------------+------+------------------------+¦¦
¦¦¦ Função    ¦INEnviaEmail¦ Ronilton O. Barros           ¦ Data ¦ 05/08/2010             ¦¦¦
¦¦+-----------+------------+------------------------------+------+------------------------+¦¦
¦¦¦ Descriçäo ¦ Rotina para envio de e-mail do compras                                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function INEnviaEmail(cFil,cPC,cSC,nTipo,cMotivo, lRetorno, lErro)
	Local cEmail := ""
	Local lRet
	Local aAlias := { "SC1", "SC7", "SCR", "SY1", Alias()}
	Local cAprovador := ""
	Local cQuery
	Local cAlias := ALIAS()
	Default lRetorno := .F.
	Default lErro 	:= .F.
	
	aAlias := u_SalvaRest(aAlias)
	
	// Posicina no Pedido de Compras
	SC7->(dbSetOrder(1))
	If (SC7->(dbSeek(cFil+cPC)))
		cSC := SC7->C7_NUMSC
	EndIf
	
	// Posicina na Solicitação de Compras
	SC1->(dbSetOrder(1))
	SC1->(dbSeek(cFil+cSC))
	
	// o bloco abaixo devera enviar apenas o aviso (solicitante e comprador)
	cEmail := AllTrim(UsrRetMail(SC1->C1_USER))
	
	// Posiciona no Comprador
	SY1->(dbSetOrder(1))
	If SY1->(dbSeek(XFILIAL("SY1")+SC1->C1_CODCOMP))
		cEmail += If( Empty(cEmail) , "", ";") + AllTrim(SY1->Y1_EMAIL)
	EndIf
	
	cQuery := " SELECT * FROM " + RetSqlName("SCR")
	cQuery += " WHERE D_E_L_E_T_ = ''
	cQuery += " AND CR_FILIAL = '"+cFil+"'
	cQuery += " AND CR_NUM = '"+cPC+"'
	If nTipo == 1
		cQuery += " AND CR_STATUS = '02'
	Else
		cQuery += " AND CR_STATUS = '04'
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"SCRTMP",.T.,.T.)
	SCRTMP->(DbGotop())
	While !SCRTMP->(Eof())
		cAprovador := Alltrim(Posicione("SAK",2,xFilial("SAK")+SCRTMP->CR_USER,"AK_NOME"))
		cCodUsr    := SCRTMP->CR_USER
		SCRTMP->(DbSkip())
	End
	DbCloseArea("SCRTMP")
	DbSelectArea(cAlias) // Posicina no Controle de alçadas
	
	If lRet := !Empty(StrTran(cEmail,";",""))
		If lRetorno
			Conout("Retorno: Enviando e-mail para "+usrretmail(cCodUsr))
			INSendMail(cEmail,cCodUsr,cAprovador,nTipo,cMotivo, lErro)
			INSendMail(cEmail,"",cAprovador,nTipo,cMotivo, lErro)
		Else
			MsgRun("Enviando e-mail para "+cEmail,"",{|| INSendMail(cEmail,cCodUsr,cAprovador,nTipo,cMotivo, lErro) })
			INSendMail(cEmail,"",cAprovador,nTipo,cMotivo, lErro)
		Endif
	Endif
	u_SalvaRest(aAlias,.F.)
	
Return lRet

Static Function INSendMail(cEmail,cCodUsr,cAprovador,nTipo,cMotivo,lErro)
	Local cMens
	
	If nTipo == 1
		If !Empty(cAprovador)
			// Envio via oProcess
			If !Empty(cCodUsr)
				U_INCOMW05(SC7->C7_FILIAL,SC7->C7_NUM, cCodUsr, cEmail, lErro)
			Else
				cMsg := '<html>
				cMsg += '<head>
				cMsg += u_INCOMWST(.F.)
				cMsg += '<meta http-equiv="Content-Language" content="en-us">
				cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
				cMsg += '<BODY>
				cMsg += '<form method="POST" action="">
				cMsg += '<p> O Pedido de Compra '+SC7->C7_NUM+', filial '+NomeFilial(SC7->C7_FILIAL)+' foi enviado para o aprovador: '+cAprovador+'<p>'
				cMsg += U_INCOMW03(SC7->C7_FILIAL,SC7->C7_NUM)
				cMsg += '</form>
				cMsg += '</body>
				cMsg += '</html>
				cTitle := "Pedido de compra "+SC7->C7_NUM+" enviado para o aprovador"
			Endif
		else
			SZD->(dbSetOrder(1))
			If !SZD->(dbSeek(XFILIAL("SZD")+SC7->C7_NUM))
				RecLock("SZD",.T.)
				SZD->ZD_Filial := xFilial("SZD")
				SZD->ZD_Pedido := SC7->C7_NUM
				MsUnlock()
			Endif
			While !SZD->(Eof()) .And. XFILIAL("SZD")+SC7->C7_NUM == SZD->(ZD_FILIAL+ZD_PEDIDO)
				RecLock("SZD",.F.)
				SZD->ZD_Comp := SC1->C1_CODCOMP
				MsUnlock()
				SZD->(dbSkip())
			Enddo
			
			cMsg := '<html>
			cMsg += '<head>
			cMsg += u_INCOMWST(.F.)
			cMsg += '<meta http-equiv="Content-Language" content="en-us">
			cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
			cMsg += '<BODY>
			cMsg += '<form method="POST" action="">
			cMsg += '<p> Pedido de Compra '+SC7->C7_NUM+', filial '+NomeFilial(SC7->C7_FILIAL)+' <b><font face="Arial" size=3 color=##00FF00>APROVADO</font></b> </p>'
			cMsg += U_INCOMW03(SC7->C7_FILIAL,SC7->C7_NUM)
			cMsg += '</form>
			cMsg += '</body>
			cMsg += '</html>
			
			cTitle := "Fluxo de Pedido de compra  "+SC7->C7_NUM+" Concluido"
		EndIf
		
		If Empty(cCodUsr) .and. lErro <> .t.
			u_INMEMAIL("Pedido de compra "+SC7->C7_NUM+" enviado para o aprovador",cMsg,cEmail)
		Endif
		
	ElseIf nTipo == 2
		cMens  := "O Pedido de Compra "+SC7->C7_NUM+", filial "+NomeFilial(SC7->C7_FILIAL)+" foi Bloqueado pelo Sr(a): "+cAprovador+" "
		cTitle := "Pedido de Compra Bloqueado"
		u_INMEMAIL("Pedido de Compra Bloqueado",cMens,cEmail)
	ElseIf nTipo == 3
		cMsg := '<html>
		cMsg += '<head>
		cMsg += u_INCOMWST(.F.)
		cMsg += '<meta http-equiv="Content-Language" content="en-us">
		cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
		cMsg += '<BODY>
		cMsg += '<form method="POST" action="">
		cMsg += '<p> Pedido de Compra '+SC7->C7_NUM+', filial '+NomeFilial(SC7->C7_FILIAL)+'<b><font face="Arial" size=3 color=#FF0000> REPROVADO </font></b> Pelo(s) Aprovador(es) : ' + cAprovador + '</p>'
		cMsg += '  <p> <b>Motivo: '+cMotivo+'</b></p>'
		cMsg += U_INCOMW03(SC7->C7_FILIAL,SC7->C7_NUM)
		cMsg += '</form>
		cMsg += '</body>
		cMsg += '</html>
		
		cTitle := "Pedido de Compra "+SC7->C7_NUM+" Reprovado"
		u_INMEMAIL("Pedido de Compra "+SC7->C7_NUM+" Reprovado",cMsg,cEmail)
	EndIf
Return

Static Function NomeFilial(cFil)
	Local cRet := ""
	
	If cFil == "01"
		cRet := "Manaus"
	ElseIf cFil == "02"
		cRet := "Brasilia"
	ElseIf cFil == "03"
		cRet := "Recife"
	ElseIf cFil == "04"
		cRet := "São Paulo"
	EndIf
	
Return cRet

User Function GetNum(cdAlias,cdChave,cdExcl)
	Local cQry      := ''
	Local cTable    := GetNextAlias()
	Local cdNum     := ''
	
	Default cdAlias := ''
	Default cdChave := ''
	Default cdExcl  := ''
	
	If !Empty(cdAlias) .And. !Empty(cdChave)
		cQry += " Select MAX(" + cdChave + ") CCHAVE FRom " + RetSqlName(cdAlias)
		cQry += " Where " + cdChave + " not in ('" + StrTran(cdExcl,",","' , '") + "') "
		cQry += " And D_E_L_E_T_ = ''"
		cQry += " And " + SubStr(cdChave,1,at('_',cdChave)) + "FILIAL = '" + xFilial(cdAlias) + "'"
		//       aviso('',cqry,{'ok'},3)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),cTable,.T.,.T.)
		cdNum := Soma1((cTable)->CCHAVE)
		(cTable)->(dbCloseArea(cTable))
		
	EndIf
	
Return cdNum

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ INObjJust  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 14/05/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Efetua salvamento e restauracao dos alias pre-definidos       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function INObjJust(cCodFil,cTipo,cSeek,lOficial)
	Local cRet := ""
	
	lOficial := If( lOficial == Nil , .T., lOficial)
	
	// Pesquisa na Base MCT
	SZ4->(dbSetOrder(1)) //Filial + Codigo
	If !lOficial .And. SZ4->(dbSeek(If( cCodFil == Nil , XFILIAL("SZ4"), cCodFil)+cTipo+cSeek))
		cRet := SZ4->Z4_JUSTIFI
	Else
		// Pesquisa na Base Oficial
		SZ6->(dbSetOrder(1)) //Filial + Codigo
		If SZ6->(dbSeek(If( cCodFil == Nil , XFILIAL("SZ6"), cCodFil)+cTipo+cSeek))
			cRet := SZ6->Z6_JUSTIFI
		Endif
	Endif
	
Return AllTrim(cRet)

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
User Function INPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

LOCAL aArea := GetArea()
Local cKey
Local lPort := .f.
Local lSpa  := .f.
Local lIngl := .f. 

If .T. //GetVersao(.F.) < "12"

	cKey  := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."
	
	cPyme    := Iif( cPyme 		== Nil, " ", cPyme		)
	cF3      := Iif( cF3 		== NIl, " ", cF3		)
	cGrpSxg  := Iif( cGrpSxg	== Nil, " ", cGrpSxg	)
	cCnt01   := Iif( cCnt01		== Nil, "" , cCnt01 	)
	cHelp	 := Iif( cHelp		== Nil, "" , cHelp		)
	
	dbSelectArea( "SX1" )
	dbSetOrder( 1 )
	
	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )
	
	If !( DbSeek( cGrupo + cOrdem ))
	
	    cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa	:= If(! "?" $ cPerSpa  .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng	:= If(! "?" $ cPerEng  .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)
	
		Reclock( "SX1" , .T. )
	
		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA  With cPerSpa
		Replace X1_PERENG  With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL  With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid
	
		Replace X1_VAR01   With cVar01
	
		Replace X1_F3      With cF3
		Replace X1_GRPSXG  With cGrpSxg
	
		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif
	
		Replace X1_CNT01   With cCnt01
		If cGSC == "C"			// Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1
	
			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2
	
			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3
	
			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4
	
			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif
	
		Replace X1_HELP  With cHelp
	
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
		MsUnlock()
	Else
	
	   lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
	   lSpa  := ! "?" $ X1_PERSPA  .And. ! Empty(SX1->X1_PERSPA)
	   lIngl := ! "?" $ X1_PERENG  .And. ! Empty(SX1->X1_PERENG)
	
	   If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort 
	         SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa 
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif
	
	RestArea( aArea )
Endif	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ INDispara  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 31/01/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Efetua execução dos gatilhos do campo                         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function INDispara(cCampo,xValor,nPos)
	Local bValida
	Local cAlias  := Alias()
	Local cValida := ""
	Local cAux    := __ReadVar
	Local nAuxN   := If( Type("n") == "N" , n, 1)
	Local aArea   := SB1->(GetArea())
	Local lRet    := .T.
	
	cCampo := PADR(cCampo,Len(SX3->X3_CAMPO))   // Ajusta o tamanho da variávei para localizar corretamente o campo
	
	SX3->(dbSetOrder(2))  // Dispara SX7
	SX3->(dbSeek(cCampo))
	
	// Monta as validações do campo
	If !Empty(SX3->X3_VALID)
		cValida += Trim(SX3->X3_VALID)
	Endif
	If !Empty(SX3->X3_VLDUSER)
		cValida += If( Empty(cValida) , "", ".And.")+Trim(SX3->X3_VLDUSER)
	Endif
	
	nPos := If( nPos == Nil , Len(aCols), nPos)
	
	bValida := &("{|| "+If(Empty(cValida),".T.",cValida)+" }")
	
	__ReadVar := "M->" + Trim(cCampo)
	
	M->&(cCampo) := xValor
	
	n := nPos
	
	If lRet := Eval(bValida)
		If ExistTrigger(cCampo)
			(cAlias)->(RunTrigger(2,nPos,,,cCampo))
		Endif
	EndIf
	
	n := nAuxN
	__ReadVar := cAux
	RestArea(aArea)
	
Return lRet
