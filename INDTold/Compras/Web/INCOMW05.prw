#INCLUDE "rwmake.ch"
#include 'Protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ INCOMW05 º Autor ³ PEDRO AUGUSTO      º Data ³  05/09/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Follow Up do Pedido de Compra somente para aprovadores     º±±
±±º          ³ ENVIO                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ INDT                                                       º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function INCOMW05(_cFilial,_cNum, _cCodUsr, _cEmail, lErro)
	Local cQry, cDescFil, cBusca, i
	Local cAlias      := "SC7"
	Local cJustifica  := ""
	Local cJustExcl   := ""
	Local aAnexosI    := {}
	Local aAnexosE    := {}
	Local aAprova     := {}
	Local cServerHttpI:= Getmv("MV_WFHTTPI")
	Local cServerHttpE:= Getmv("MV_WFHTTPE")
	Local _lSenha	  := .F.
	Default lErro 	  := .F.
	
	Private nTamDoc  := TamSX3("F1_DOC")[1]
	
	_cNum := StrZero(Val(_cNum),TamSX3("C7_NUM")[1])
	cQry := " SELECT ISNULL(CTT_DESC01,' ') AS CTT_DESC01, ISNULL(CT1_DESC01,' ') AS CT1_DESC01, B1_TE,ISNULL(C1_CCAPRV,'') AS C1_CCAPRV, SC7.*"
	cQry += " FROM "+RetSQLName("SC7")+" SC7"
	cQry += " INNER JOIN "+RetSQLName("SB1")+" SB1 ON C7_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ' '"
	cQry += " LEFT OUTER JOIN "+RetSQLName("CTT")+" CTT ON C7_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ' '"
	cQry += " LEFT OUTER JOIN "+RetSQLName("CT1")+" CT1 ON C7_CONTA = CT1_CONTA AND CT1.D_E_L_E_T_ = ' '"
	cQry += " LEFT OUTER JOIN "+RetSQLName("SC1")+" SC1 ON C7_FILIAL = C1_FILIAL AND C7_NUMSC = C1_NUM AND C7_ITEMSC = C1_ITEM AND SC1.D_E_L_E_T_ = ' '"
	cQry += " WHERE SC7.D_E_L_E_T_ = ' ' AND C7_FILIAL = '"+_cFilial+"' AND C7_NUM = '"+_cNum+"'"
	
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQry)),"TMPSC7",.F.,.T.)
	
	If TMPSC7->(Eof())
		dbCloseArea()
		DbSelectArea(cAlias)
		Return "Pedido de Compra não localizado !"
	Endif
	
	TcSetField("TMPSC7","C7_EMISSAO","D")
	
	If _cFilial = "01"
		cDescFil := "Manaus"
	ElseIf _cFilial = "02"
		cDescFil := "Brasilia"
	ElseIf _cFilial = "03"
		cDescFil := "Recife"
	Else
		cDescFil := "São Paulo"
	EndIf
	
	// Pesquisa a justificativa
	SZ6->(DbSetOrder(1))
	If SZ6->(DbSeek(TMPSC7->(C7_FILIAL+"1"+PADR(C7_NUM,nTamDoc))))
		cJustifica := SZ6->Z6_JUSTIFI
	EndIf
	
	// Pesquisa a justificativa do Fornecedor Exclusivo
	SZ6->(DbSetOrder(1))
	If SZ6->(DbSeek(TMPSC7->(C7_FILIAL+"E"+PADR(C7_NUM,nTamDoc))))
		cJustExcl := SZ6->Z6_JUSTIFI
	EndIf
	
	// Posiciona no Follow up
	SZD->(dbSetOrder(1))
	SZD->(dbSeek(TMPSC7->(C7_FILIAL+C7_NUM)))
	
	// Posiciona no Cadastro de Comprador
	SY1->(dbSetOrder(1))
	SY1->(dbSeek(XFILIAL("SY1")+SZD->ZD_COMP))
	
	cBusca := TMPSC7->(C7_FILIAL+"2"+PADR(C7_NUM,nTamDoc))
	
	// Pesquisa os anexos para o pedido de compra
	SZF->(DbSetOrder(1))
	SZF->(DbSeek(cBusca,.T.))
	While !SZF->(Eof()) .And. SZF->ZF_FILIAL+SZF->ZF_TIPO+SZF->ZF_NUM == cBusca
		AAdd( aAnexosI , '<a href="'+Alltrim(cServerHttpI)+'/web/followup/'+SZF->ZF_ARQSRV+'"  target=”_blank” title="ARQUIVO">'+SZF->ZF_ARQSRV+'</a>')
		AAdd( aAnexosE , '<a href="'+Alltrim(cServerHttpE)+'/web/followup/'+SZF->ZF_ARQSRV+'"  target=”_blank” title="ARQUIVO">'+SZF->ZF_ARQSRV+'</a>')
		SZF->(DbSkip())
	Enddo
	
	// Pesquisa os aprovadores
	
	cQry := " SELECT * FROM " + RetSqlName("SCR")
	cQry += " WHERE D_E_L_E_T_ = ''
	cQry += " AND CR_FILIAL = '"+_cFilial+"'
	cQry += " AND CR_NUM = '"+_cNum+"'
	cQry += " ORDER BY R_E_C_N_O_
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"SCRTMP",.T.,.T.)
	TcSetField("SCRTMP","CR_DATALIB","D")
	
	SCRTMP->(DbGotop())
	While !SCRTMP->(Eof())
		AAdd( aAprova , { Dtoc(SCRTMP->CR_DATALIB), Posicione("SAK",2,XFILIAL("SAK")+SCRTMP->CR_USER,"AK_NOME")})
		SCRTMP->(DbSkip())
	End
	DbCloseArea()
	DbSelectArea(cAlias)
	
	_cChave := _cFilial+"PC"+Padr(_cNum,TamSX3("CR_NUM")[1])+ _cCodUsr
	
	oProcess:= TWFProcess():New( "000001", "Envio Aprovacao PC :" + _cFilial + "/" +  TRIM(_cNum) )
	oProcess:NewTask( "Envio PC : "+_cFilial + _cNum, "\WORKFLOW\HTML\PCAPROV_IN.HTM" )
	oProcess:bReturn  	:= "U_INCOMWR5()"
	
	oProcess:cTo      	:= nil
	oHtml     			:= oProcess:oHTML
	
	//Campos HIDDEN
	oHtml:ValByName( "CHAVE"	   , _cChave)
	oHtml:ValByName( "WFID"		   , oProcess:fProcessId)
	oHtml:ValByName( "CR_USER"	   , _cCodUsr)
	
	oHtml:ValByName( "C7_NUM"	   		, TMPSC7->C7_NUM)
	oHtml:ValByName( "C7_COMPRADOR"	   	, IIf(Empty(SY1->Y1_NOME),"Comprador não alocado",SY1->Y1_NOME))
	oHtml:ValByName( "C7_FILIAL"	   	, TMPSC7->C7_FILIAL)
	oHtml:ValByName( "C7_NFILIAL"	   	, cDescFil)
	oHtml:ValByName( "C7_EMISSAO"	   	, Dtoc(TMPSC7->C7_EMISSAO))
	oHtml:ValByName( "C7_NUMSC"	   		, TMPSC7->C7_NUMSC)
	oHtml:ValByName( "C7_REQUIS"	   	, Posicione('SC1',1,_cFilial+TMPSC7->C7_NUMSC,"C1_SOLICIT"))
	oHtml:ValByName( "C7_FORNECE"	   	, TMPSC7->C7_FORNECE + '/' + TMPSC7->C7_LOJA + " - " + Posicione("SA2",1,_cFilial+TMPSC7->(C7_FORNECE + C7_LOJA),"A2_NOME"))
	
	If Empty(TMPSC7->C1_CCAPRV)
		oHtml:ValByName( "CCAPROV"	   	, TMPSC7->C7_CC+" - "+Posicione("CTT",1,xFilial("CTT")+TMPSC7->C7_CC,"CTT_DESC01"))
	Else
		oHtml:ValByName( "CCAPROV"	   	, TMPSC7->C1_CCAPRV+" - "+Posicione("CTT",1,xFilial("CTT")+TMPSC7->C1_CCAPRV,"CTT_DESC01"))
	EndIf
	
	oHtml:ValByName( "MOEDA"	   		, SuperGetMv("MV_MOEDA"+AllTrim(Str(TMPSC7->C7_MOEDA,2))))
	
	While !TMPSC7->(Eof())
		
		SC1->(dbSetOrder(1))
		SC1->(dbSeek(TMPSC7->(C7_FILIAL+C7_NUMSC+C7_ITEMSC)))
		AAdd( (oHtml:ValByName( "t.1" )), TMPSC7->C7_CLVL)
		AAdd( (oHtml:ValByName( "t.2" )), TMPSC7->C7_DESCRI)
		AAdd( (oHtml:ValByName( "t.3" )), TMPSC7->B1_TE )
		AAdd( (oHtml:ValByName( "t.4"  )), TMPSC7->C7_CONTA)
		AAdd( (oHtml:ValByName( "t.5"  )), Posicione('SC1',1,TMPSC7->(C7_FILIAL+C7_NUMSC+C7_ITEMSC),"SC1->C1_DETALH"))
		AAdd( (oHtml:ValByName( "t.6"  )), Transform(TMPSC7->C7_QUANT,"@E 999,999,999.99"))
		AAdd( (oHtml:ValByName( "t.7"  )), Transform(TMPSC7->C7_PRECO,"@E 999,999,999.99"))
		AAdd( (oHtml:ValByName( "t.8"  )), Transform(TMPSC7->C7_TOTAL,"@E 999,999,999.99"))
		AAdd( (oHtml:ValByName( "t.9"  )), TMPSC7->C7_CC)
		AAdd( (oHtml:ValByName( "t.10" )), TMPSC7->C7_OBS)
		
		TMPSC7->(DbSkip())
	Enddo
	
	If Len(aAnexosI) > 0
		For i:= 1 to Len(aAnexosI)
			AAdd( (oHtml:ValByName( "t1.1" )), aAnexosI[i])
			AAdd( (oHtml:ValByName( "t1.2" )), aAnexosE[i])
		Next i
	EndIf
	
	oHtml:ValByName( "JUSTIFIC1", cJustifica)
	
	If !Empty(cJustExcl)
		oHtml:ValByName( "JUSTIFIC2", cJustExcl)
	EndIf
	
	// Pesquisa os aprovadores
	nIndex  := SCR->(IndexOrd())
	nRecno  := SCR->(Recno())
	cCR_NUM := PADR(cNum,TamSX3("CR_NUM")[1])
	
	SCR->(dbSetOrder(1))
	SCR->(dbSeek(cFil+"PC"+cCR_NUM,.T.))
	While !SCR->(Eof()) .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == cFil+"PC"+cCR_NUM
		
		PswOrder(1)
		cText1 := UserName(SCR->CR_USER)
		cText2 := POSICIONE("SAK",1,"  "+SCR->CR_APROV,"AK_NOME")
		
		AAdd( (oHtml:ValByName( "ta.1"    )), SCR->CR_NIVEL)
		AAdd( (oHtml:ValByName( "ta.2"    )), If( Empty(cText1) , "<font color=#e8eae8>n</font>", cText1))
		AAdd( (oHtml:ValByName( "ta.3"    )), nome(SCR->CR_STATUS)    )
		AAdd( (oHtml:ValByName( "ta.4"    )), cText2)
		AAdd( (oHtml:ValByName( "ta.5"    )), ToStr(SCR->CR_DATALIB))
		AAdd( (oHtml:ValByName( "ta.6"    )), If( Empty(SCR->CR_OBS) , "<font color=#e8eae8>n</font>", SCR->CR_OBS))
		
		SCR->(DbSkip())
	Enddo               
	SCR->(dbSetOrder(nIndex))
	SCR->(dbGoTo(nRecno))
	
	oProcess:nEncodeMime := 0
	
	oProcess:NewVersion(.T.)
	oHtml     				:= oProcess:oHTML
	oProcess:nEncodeMime := 0
	cMailID := oProcess:Start("\workflow\emp"+cEmpAnt+"\wfpc\")   //Faz a gravacao do e-mail no cPath
	
	chtmlfile  := cMailID + ".htm"
	If lErro
		cSubj := "REENVIO por senha incorreta - Pedido de compra "+_cNum + " pendente de aprovação"
		oProcess:newtask("Link", "\workflow\html\INLink.htm")  //Cria um novo processo de workflow que informara o Link ao usuario
	Else
		cSubj := "Pedido de compra "+_cNum + " pendente de aprovação"
		oProcess:newtask("Link", "\workflow\html\INLink.htm")  //Cria um novo processo de workflow que informara o Link ao usuario
	Endif
	oHtml:ValByName( "descproc"	  ,"O pedido de compra abaixo aguarda sua aprovação:")
	
	oHtml:ValByName( "cDoctoI"	  ,"Pedido de compra No. "+_cNum )
	oProcess:oHtml:ValByName("cNomeProcessoI", Alltrim(GetMv("MV_WFDHTTP"))+"/workflow/emp"+cempant+"/wfpc/"+chtmlfile ) // envia o link onde esta o arquivo html
	
	oProcess:cTo 	   := usrretmail(_cCodUsr)
	oProcess:cSubject := cSubj
	oProcess:Start()
	
	DbSelectArea("TMPSC7")
	DbCloseArea()
	
	DbSelectArea(cAlias)
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ INCOMWR5 º Autor ³ PEDRO AUGUSTO      º Data ³  05/09/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Follow Up do Pedido de Compra somente para aprovadores     º±±
±±º          ³ RETORNO                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ INDT                                                       º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function INCOMWR5(oProcess)
	Local _lSenha	 := .F.
	Conout("2 - Processa O RETORNO DO EMAIL")
	Conout("2 - EmpFil:" + cEmpAnt + cFilAnt)
	
	_cChaveSCR  := alltrim(oProcess:oHtml:RetByName("CHAVE"))
	cOpc        := alltrim(oProcess:oHtml:RetByName("OPC"))
	cObs        := alltrim(oProcess:oHtml:RetByName("OBS"))
	cWFID       := alltrim(oProcess:oHtml:RetByName("WFID"))
	cFilial     := alltrim(oProcess:oHtml:RetByName("C7_FILIAL"))
	cNum        := alltrim(oProcess:oHtml:RetByName("C7_NUM"))
	//cNumsc      := alltrim(oProcess:oHtml:RetByName("C7_NUMSC"))
	cFileHTML   := alltrim(oProcess:oHtml:RetByName("WFMAILID"))
	cFileHTML   := Substr(cFileHTML,3)
	cCodUsr     := alltrim(oProcess:oHtml:RetByName("CR_USER"))
	Conout("cCodUsr (Retorno):"+cCodUsr)
	cApvdor     := oProcess:oHtml:RetByName("CR_USER")
	
	If PswSeek(cApvdor)
		_cSenha  := oProcess:oHtml:RetByName("SENHA")
		If PswName(_cSenha)
			_lSenha := .T.
		EndIf
	EndIf
	
	oProcess:Finish() // FINALIZA O PROCESSO
	
	Conout("2 - cFilial    :" + cFilial)
	Conout("2 - _cChaveSCR :" + _cChaveSCR)
	Conout("2 - Opc        :" + cOpc)
	Conout("2 - Obs        :" + cObs)
	Conout("2 - WFId       :" + cWFID)
	Conout("2 - cCodUsr    :" + cCodUsr)
	If _lSenha
		__cCurrAprov := cCodUsr
		Conout("__cCurrAprov (Retorno):"+__cCurrAprov)
		IF cOpc $ "S|N"  // Aprovacao S-Sim N-Nao
			DBSelectArea("SCR")
			DBSetOrder(2)
			IF !DBSeek(_cChaveSCR)  // BR153301PC000014                                      000000
				Conout("2 - Processo nao encontrado : Not Found")
				Return .T.
			Endif
			
			If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#04#05"
				Conout("2 - Processo ja respondido via sistema :" + cWFID)
				Return .T.
			EndIf
			
			// Verifica se o pedido de compra esta aprovado
			// Se estiver, finaliza o processo
			dbSelectArea("SC7")
			dbSetOrder(1)
			SC7->(dbSeek(cFilial+LEFT(SCR->CR_NUM,6)))
			
			IF SC7->C7_CONAPRO <> "B"  // NAO ESTIVER BLOQUEADO
				Conout("2C - Processo ja respondido via sistema :" + cWFID)
				Return .T.
			ENDIF
			
			DBSelectArea("SCR")
			DBSetOrder(2)
			DBSeek(_cChaveSCR)
			
			nTotal := SCR->CR_TOTAL
			
			lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,SCR->CR_APROV,,SC7->C7_APROV,,,,,cObs},msdate(),If(cOpc=="S",4,6))
			
			Conout("2 - Liberado :" + IIF(lLiberou, "Sim", "Nao"))
			
			_lProcesso := .T.
			
			dbSelectArea("SC7")
			dbSetOrder(1)
			dbSeek(xFilial("SC7")+LEFT(SCR->CR_NUM,6))
			_cNumSC7 := SC7->C7_NUM
			_cNumSC1 := SC7->C7_NUMSC
			
			If lLiberou
				While !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM == SCR->CR_FILIAL+LEFT(SCR->CR_NUM,6)
					Reclock("SC7",.F.)
					SC7->C7_CONAPRO 	:= "L"
					MsUnlock()
					dbSkip()
				EndDo
				Conout("U_INEnviaEmail - Enviando Aviso de pedido aprovado")
				U_INEnviaEmail(xFilial("SC7"),_cNumSC7,_cNumSC1,1,nil, .F.)
			Else
				IF cOpc == "S"
					Conout("U_INEnviaEmail - Enviando para o proximo aprovador")
					U_INEnviaEmail(xFilial("SC7"),_cNumSC7,_cNumSC1,1,nil, .T.)
				Else // Pedido reprovado
					Conout("U_INEnviaEmail - Enviando Aviso de pedido reprovado")
					U_INEnviaEmail(xFilial("SC7"),_cNumSC7,_cNumSC1,3,cObs, .F.)
				Endif
			Endif
			
			// Aprovador, sua resposta foi processada pelo protheus //
			_cwTit 	:= 'Pedido de compra '+_cNumSC7+Iif(cOpc == "S", " Aprovado"," Reprovado")
			_cEmail	:= UsrRetMail(__cCurrAprov)
			_cMsg := '<html>
			_cMsg += '<head>
			_cMsg += u_INCOMWST(.F.)
			_cMsg += '<meta http-equiv="Content-Language" content="en-us">
			_cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
			_cMsg += '<BODY>
			_cMsg += '<form method="POST" action="">
			_cMsg += '<font face="Arial" size=2>Pedido de compra '+_cNumSC7+', filial '+xFilial("SC7")+Iif(cOpc == "S", " Aprovado com sucesso"," Reprovado com sucesso")
			_cMsg += '</font>'
			_cMsg += '</form>
			_cMsg += '</body>
			_cMsg += '</html>
			u_INMEMAIL(_cwTit,_cMsg,_cEmail)
			
		Endif
	Else
		// Enviar aviso de senha invalida
		// Setar SCR para novo envio
		
		DBSelectArea("SCR")
		DBSetOrder(2)
		If SCR->(DBSeek(_cChaveSCR))  // BR153301PC000014                                      000000
			dbSelectArea("SC7")
			dbSetOrder(1)
			dbSeek(xFilial("SC7")+LEFT(SCR->CR_NUM,6))
			_cNumSC7 := SC7->C7_NUM
			_cNumSC1 := SC7->C7_NUMSC
			
			// Envia novo e-mail
			Conout("Senha invalida, enviando novo e-mail")
			U_INEnviaEmail(xFilial("SC7"),_cNumSC7,_cNumSC1,1,nil, .T., .T.)
		ENDIF
	EndIf
	fErase("\workflow\emp"+cEmpAnt+"\wfpc\" + cFileHTML+".htm")
	__Copyfile("\workflow\HTML\INErro.htm","\workflow\emp"+cEmpAnt+"\wfpc\" + cFileHTML+".htm")
	
Return

Static Function ToStr(dDat)
Return If( Empty(dDat) , "", PADR(Dtoc(dDat),6)+Str(Year(dDat),4))

Static Function nome(cPa)
	If cPa = "01" .Or. cPa="1"
		Return "Nivel Bloqueado"
	Endif
	If cPa = "02" .Or. cPa="2"
		Return  "Aguardando Liberação"
	Endif
	If cPa = "03" .Or. cPa="3"
		Return "Pedido Aprovado"
	Endif
	If cPa = "04" .Or. cPa="4"
		Return "Pedido Bloqueado"
	Endif
	If cPa = "05" .Or. cPa="5"
		Return "Nivel Liberado"
	Endif
Return

Static Function UserName(cCodUsr)
	Local aUser, cUserAnt := " "
	PswOrder(1)               // (1) Codigo , (2) Nome
	If PswSeek(Alltrim(cCodUsr)) // Pesquisa usuário
		aUser := PswRet(1)        // Retorna Matriz com detalhes, acessos do Usuário
		cUserAnt := aUser[1][2]   // Retorna codigo do usuário [1] ou o Nome [2]
	Endif
Return cUserAnt
