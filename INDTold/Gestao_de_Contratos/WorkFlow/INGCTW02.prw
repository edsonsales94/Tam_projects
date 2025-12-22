#INCLUDE "rwmake.ch"
#include 'Protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ INGCTW02 º Autor ³ PEDRO AUGUSTO      º Data ³  16/09/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Follow Up do medicao de contrato somente para aprovadores  º±±
±±º          ³ ENVIO                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ INDT                                                       º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function INGCTW02(_cFilial,_cNum, _cContra, _cCodUsr, lErro)
	Local cQry, cDescFil, cBusca, cFollowUp
	Local aAlias      	:= { "CND", Alias()}
	Local cAlias      	:= "CND"
	Local cHTML       	:= ""
	Local cJustifica  	:= ""
	Local cJustExcl   	:= ""
	Local aAnexosI    	:= {}
	Local aAnexosE    	:= {}
	Local aAprova     	:= {}
	Local aIdioma     	:= u_INCOMWID("P")
	Local cServerHttp 	:= Getmv("MV_SERHTTP")
	Local cServerHttpI	:= Getmv("MV_WFHTTPI")
	Local cServerHttpE	:= Getmv("MV_WFHTTPE")  
	Local _lSenha	  	:= .F.                                    
	Local _nTotItens	:= 0
	Local _nTotDesc	  	:= 0
	Local _nTotMulta	:= 0
	Local _nTotBonif	:= 0
	Local _nTotAdto		:= 0
	Local _nTotMed	  	:= 0

	Default lErro 	  := .F.
	
	Private nTamDoc  := TamSX3("CND_NUMMED")[1]
	
	_cNum := StrZero(Val(_cNum),6)
	cQry := " SELECT * FROM "+RetSQLName("CND")+" CND"
	cQry += " WHERE CND.D_E_L_E_T_ = ' ' AND CND_FILIAL = '"+_cFilial+"' AND CND_NUMMED = '"+_cNum+"'"
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQry)),"TMPCND",.F.,.T.)
	
	If TMPCND->(Eof() .And. Bof())
		dbCloseArea()
		DbSelectArea(cAlias)
		Return "Medição de contrato não localizada !"
	Endif
	
	TcSetField("TMPCND","CND_DTVENC","D")
	
	If _cFilial = "01"
		cDescFil := "Manaus"
	ElseIf _cFilial = "02"
		cDescFil := "Brasilia"
	ElseIf _cFilial = "03"
		cDescFil := "Recife"
	Else
		cDescFil := "São Paulo"
	EndIf
	
	CND->(DbSetOrder(4))
	CND->(DbSeek(_cFilial+_cNum))
	
	_cObsMed := CND->CND_OBS

	DbSelectArea("CN9")
	DbSeek(xFilial("CN9") + TMPCND->CND_CONTRA + TMPCND->CND_REVISA) 
	_cObjeto := CN9->CN9_XOBJET
	_cJustif := CN9->CN9_XJUSTF

	// Pesquisa os aprovadores
	
	_cChave := _cFilial+"MD"+Padr(_cNum,TamSX3("CR_NUM")[1])+ _cCodUsr	
	
	oProcess:= TWFProcess():New( "000002", "Envio Aprovacao MD :" + _cFilial + "/" +  TRIM(_cNum))
	oProcess:NewTask( "Envio MD : "+_cFilial + _cNum, "\WORKFLOW\HTML\MDAPROV_IN.HTM" )
	oProcess:bReturn  	:= "U_INGCTWR2()"
	
	oProcess:cTo      	:= nil
 	oHtml     			:= oProcess:oHTML

	//Campos HIDDEN
	oHtml:ValByName( "CHAVE"	   , _cChave)
	oHtml:ValByName( "WFID"		   , oProcess:fProcessId)
	oHtml:ValByName( "CR_USER"	   , _cCodUsr)
	Conout("_cCodUsr (Envio):"+_cCodUsr)

	// Cabecalho
	oHtml:ValByName( "CND_FILIAL"	   	, TMPCND->CND_FILIAL	)
	oHtml:ValByName( "cDescFil"	   		, cDescFil)
	oHtml:ValByName( "CND_NUMMED"		, TMPCND->CND_NUMMED)
	oHtml:ValByName( "CND_CONTRA"		, TMPCND->CND_CONTRA)
	oHtml:ValByName( "CND_DTVENC"		, Dtoc(TMPCND->CND_DTVENC))
	oHtml:ValByName( "CND_FORNEC"	   	, TMPCND->CND_FORNEC	)
	oHtml:ValByName( "A2_NOME"			, Posicione('SA2',1,xFIlial('SA2')+TMPCND->(CND_FORNEC+CND_LJFORN) , 'A2_NOME'))

	oHtml:ValByName( "CND_OBS"			, _cObsMed)
	oHtml:ValByName( "CN9_XOBJET"		, _cObjeto)
	oHtml:ValByName( "CN9_XJUSTF"		, _cJustif)

	cQuery := " SELECT CNE_PRODUT, CNE_QUANT, CNE_VLUNIT, CNE_VLTOT, CNE_PERC, CNE_XCLVL, CNE_PEDIDO, CNE_CONTA, CNE_CC " 
	cQuery +=   " FROM " + RetSQLName("CNE")+" CNE"               
	cQuery +=  " INNER JOIN "+RetSQLName("CTT")+" CTT ON CNE_CC = CTT_CUSTO  AND CTT.D_E_L_E_T_ = '' "
	cQuery +=  " INNER JOIN "+RetSQLName("SB1")+" SB1 ON B1_COD  = CNE_PRODUT AND SB1.D_E_L_E_T_ = '' "
	cQuery +=  " WHERE CNE.D_E_L_E_T_ = '' 
	cQuery +=    " AND CNE_NUMMED = '"+_cNum+"'" 
	cQuery +=    " AND CNE_CONTRA = '"+_cContra+"'"
	
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"CNETMP",.F.,.T.)

	CNETMP->(DbGotop())

	//////////////////////
	// ITENS DA MEDIÇÃO //
	//////////////////////
	While !CNETMP->(Eof())

		AAdd( (oHtml:ValByName( "t.1"    )), CNETMP->CNE_XCLVL)
		AAdd( (oHtml:ValByName( "t.2"    )), CNETMP->CNE_PRODUT)
		AAdd( (oHtml:ValByName( "t.3"    )), TRANSFORM(CNETMP->CNE_QUANT	, "@E 999,999.99"))
		AAdd( (oHtml:ValByName( "t.4"    )), TRANSFORM(CNETMP->CNE_VLUNIT	, "@E 999,999.99"))
		AAdd( (oHtml:ValByName( "t.5"    )), TRANSFORM(CNETMP->CNE_VLTOT	, "@E 999,999.99"))
		AAdd( (oHtml:ValByName( "t.6"    )), TRANSFORM(CNETMP->CNE_PERC	, "@E 999,999.99"))
		AAdd( (oHtml:ValByName( "t.7"    )), CNETMP->CNE_CONTA)
		AAdd( (oHtml:ValByName( "t.8"    )), CNETMP->CNE_CC)

		_nTotItens += CNETMP->CNE_VLTOT 
		CNETMP->(DbSkip())
		
	Enddo               

	//////////////////////
	// DESCONTOS        //
	//////////////////////
	cQuery := "SELECT CNQ.* "
	cQuery += "  FROM "+RetSQLName("CNQ")+" CNQ "
	cQuery += " WHERE CNQ.CNQ_FILIAL = '"+xFilial("CNQ")+"'"
	cQuery += "   AND CNQ.CNQ_NUMMED = '"+_cNum+"'"
	cQuery += "   AND CNQ.D_E_L_E_T_ = '' "
	cQuery += " ORDER BY CNQ.CNQ_TPDESC"
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"CNQTMP",.F.,.T.)

	CNQTMP->(DbGotop())

	If !CNQTMP->(Eof())
		While !CNQTMP->(Eof())
			AAdd( (oHtml:ValByName( "tq.1"    )), CNQTMP->CNQ_TPDESC+" - "+Posicione('CNP',1,xFilial('CNP')+CNQTMP->CNQ_TPDESC , 'CNP_DESCRI'))
			AAdd( (oHtml:ValByName( "tq.2"    )), TRANSFORM(CNQTMP->CNQ_VALOR	, "@E 999,999.99"))
			_nTotDesc += CNQTMP->CNQ_VALOR
			CNQTMP->(DbSkip())
		Enddo               
	Else 
		AAdd( (oHtml:ValByName( "tq.1"    )), '-')
		AAdd( (oHtml:ValByName( "tq.2"    )), '-')
	Endif		   

	//////////////////////
	// MULTAS           //
	//////////////////////
	cQuery := "SELECT * "
	cQuery += "  FROM "+RetSqlName("CNR")
	cQuery += " WHERE CNR_FILIAL = '"+xFilial("CNR")+"'"
	cQuery += "   AND CNR_NUMMED = '"+_cNum+"'"
	cQuery += "   AND D_E_L_E_T_ = ' ' " 
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"CNRTMP",.F.,.T.)

	CNRTMP->(DbGotop())

	If !CNRTMP->(Eof())
		While !CNRTMP->(Eof())
			AAdd( (oHtml:ValByName( "tr.1"    )), Iif(CNRTMP->CNR_TIPO == '1','Multa','Bonificação'))
			AAdd( (oHtml:ValByName( "tr.2"    )), TRANSFORM(CNRTMP->CNR_VALOR	, "@E 999,999.99"))
			AAdd( (oHtml:ValByName( "tr.3"    )), Iif(CNRTMP->CNR_MODO == '1','Automatico','Manual'))
			If CNRTMP->CNR_TIPO == '1'
				_nTotMulta += CNRTMP->CNR_VALOR
			Else 
				_nTotBonif += CNRTMP->CNR_VALOR
			Endif	
			CNRTMP->(DbSkip())
		Enddo               
	Else 
		AAdd( (oHtml:ValByName( "tr.1"    )), '-')
		AAdd( (oHtml:ValByName( "tr.2"    )), '-')
		AAdd( (oHtml:ValByName( "tr.3"    )), '-')
	Endif

	//////////////////////
	// ADIANTAMENTO     //               
	//////////////////////
	cQuery := "SELECT CNX.R_E_C_N_O_ as RECNO "
	cQuery += "  FROM "+RetSQLName("CNX")+" CNX "
	cQuery += " WHERE CNX.CNX_FILIAL = '"+xFilial("CNX")+"'"
	cQuery += "   AND CNX.CNX_CONTRA = '"+_cContra+"'"
	cQuery += "   AND CNX.CNX_NUMMED = '"+_cNum+"'"
	cQuery += "   AND CNX.D_E_L_E_T_ = ''"
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"CNXTMP",.F.,.T.)
	TcSetField("CNXTMP","CNX_DTADT","D")
       
	CNXTMP->(DbGotop())

	If !CNXTMP->(Eof())
		While !CNXTMP->(Eof())
			AAdd( (oHtml:ValByName( "tx.1"    )), ToStr(CNXTMP->CNX_DTADT))
			AAdd( (oHtml:ValByName( "tx.2"    )), TRANSFORM(CNXTMP->CNX_VLADT	, "@E 999,999.99"))
			AAdd( (oHtml:ValByName( "tx.3"    )), CNXTMP->CNX_PREFIX)
			AAdd( (oHtml:ValByName( "tx.4"    )), CNXTMP->CNX_NUMTIT)
			_nTotAdto += CNXTMP->CNX_VLADT
			CNXTMP->(DbSkip())
		Enddo               
	Else 
		AAdd( (oHtml:ValByName( "tx.1"    )), '-')
		AAdd( (oHtml:ValByName( "tx.2"    )), '-')
		AAdd( (oHtml:ValByName( "tx.3"    )), '-')
		AAdd( (oHtml:ValByName( "tx.4"    )), '-')
	Endif
	
	oHtml:ValByName( "TOTITENS"		, TRANSFORM(_nTotItens	, "@E 9,999,999.99"))
	oHtml:ValByName( "TOTDESC"		, TRANSFORM(_nTotDesc	, "@E 9,999,999.99"))
	oHtml:ValByName( "TOTMULTA"		, TRANSFORM(_nTotMulta	, "@E 9,999,999.99"))
	oHtml:ValByName( "TOTBONIF"		, TRANSFORM(_nTotBonif	, "@E 9,999,999.99"))
	oHtml:ValByName( "TOTADTO"		, TRANSFORM(_nTotAdto	, "@E 9,999,999.99"))

	_nTotMed := _nTotItens - _nTotDesc - _nTotMulta + _nTotBonif - _nTotAdto
	oHtml:ValByName( "TOTMED"		, TRANSFORM(_nTotMed	, "@E 9,999,999.99"))

	//////////////////////
	// APROVADORES      //
	//////////////////////
	nIndex  := SCR->(IndexOrd())
	nRecno  := SCR->(Recno())
	cCR_NUM := PADR(_cNum,TamSX3("CR_NUM")[1])
	
	SCR->(dbSetOrder(1))
	SCR->(dbSeek(_cFilial+"MD"+cCR_NUM,.T.))
	While !SCR->(Eof()) .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == _cFilial+"MD"+cCR_NUM
		
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

	CNETMP->(DbCloseArea())
	CNQTMP->(DbCloseArea())
	CNRTMP->(DbCloseArea())
	CNXTMP->(DbCloseArea())

	oProcess:nEncodeMime := 0

	oProcess:NewVersion(.T.)
	oHtml     				:= oProcess:oHTML
	oProcess:nEncodeMime := 0
	cMailID := oProcess:Start("\workflow\emp"+cEmpAnt+"\wfmd\")   //Faz a gravacao do e-mail no cPath
	
	chtmlfile  := cmailid + ".htm"
    If lErro
		csubj := "REENVIO por senha incorreta - Medição "+Alltrim(_cNum)+" pendente de aprovação"
		oProcess:newtask("Link", "\workflow\html\INLink.htm")  //Cria um novo processo de workflow que informara o Link ao usuario
    Else
		csubj := "Medição "+Alltrim(_cNum)+" pendente de aprovação"
		oProcess:newtask("Link", "\workflow\html\INLink.htm")  //Cria um novo processo de workflow que informara o Link ao usuario
	Endif
	oHtml:ValByName( "descproc"	  ,"A Medição de contrato abaixo aguarda sua aprovação:")

	oHtml:ValByName( "cDoctoI"	  ,"Medição de contrato No. "+_cNum )
	oProcess:oHtml:ValByName("cNomeProcessoI", Alltrim(GetMv("MV_WFDHTTP"))+"/workflow/emp"+cempant+"/wfmd/"+chtmlfile ) // envia o link onde esta o arquivo html
	oProcess:cTo 	   := usrretmail(_cCodUsr)
	oProcess:cSubject := cSubj
	oProcess:Start()

	DbSelectArea(cAlias)
	
	DbSelectArea("TMPCND")
	DbCloseArea("TMPCND")
	
	DbSelectArea(cAlias)
	
	Return 
                                  
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ INVIAWR2 º Autor ³ PEDRO AUGUSTO      º Data ³  11/09/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Follow Up da requisicao de viagem somente para aprovadores º±±
±±º          ³ RETORNO                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ INDT                                                       º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function INGCTWR2(oProcess)
	Local _lSenha	 := .F.
	Conout("2 - Processa O RETORNO DO EMAIL")
	Conout("2 - EmpFil:" + cEmpAnt + cFilAnt)
	
	_cChaveSCR	:= alltrim(oProcess:oHtml:RetByName("CHAVE"))
	cOpc     	:= alltrim(oProcess:oHtml:RetByName("OPC"))
	cObs     	:= alltrim(oProcess:oHtml:RetByName("OBS"))
	cWFID     	:= alltrim(oProcess:oHtml:RetByName("WFID"))
	cFilial		:= alltrim(oProcess:oHtml:RetByName("CND_FILIAL"))
	cNum		:= alltrim(oProcess:oHtml:RetByName("CND_NUMMED"))
	cFileHTML	:= alltrim(oProcess:oHtml:RetByName("WFMAILID"))
	cFileHTML	:= Substr(cFileHTML,3) // Tira o "WF" do inicio
	cCodUsr		:= alltrim(oProcess:oHtml:RetByName("CR_USER"))
	Conout("cCodUsr (Retorno):"+cCodUsr)
	
	cApvdor		:= oProcess:oHtml:RetByName("CR_USER")
	If PswSeek(cApvdor)
		_cSenha	:= oProcess:oHtml:RetByName("SENHA")
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
	If _lSenha == .T. 
		__cCurrAprov := cCodUsr
		Conout("__cCurrAprov (Retorno):"+__cCurrAprov)
		IF cOpc $ "S|N"  // Aprovacao S-Sim N-Nao
			DBSelectArea("SCR")
			DBSetOrder(2)
			DBSeek(_cChaveSCR)  // BR153301PC000014                                      000000
			IF !FOUND()  
				Conout("2 - Processo nao encontrado : Not Found")
				Return .T.
			Endif
			
			If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#04#05"
				Conout("SCR->CR_DATALIB: "+ Dtoc(SCR->CR_DATALIB))
				Conout("SCR->CR_STATUS : "+SCR->CR_STATUS)
				Conout("2 - Processo ja respondido via sistema :" + cWFID)
				Return .T.
			EndIf
		
			nTotal := SCR->CR_TOTAL
			
			lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,SCR->CR_APROV,,CND->CND_APROV,,,,,cObs},msdate(),If(cOpc=="S",4,6))
			
			Conout("2 - Liberado :" + IIF(lLiberou, "Sim", "Nao"))
		
			_lProcesso := .T.

			dbSelectArea("CND")
			dbSetOrder(4)
			CND->(dbSeek(xFilial("CND")+SCR->CR_NUM))

			cEmail := AllTrim(UsrRetMail(CND->CND_XUSER)) 

			If lLiberou
				Reclock("CND",.F.)
				CND->CND_ALCAPR := "L"
				MsUnlock()
				INSendMail(cEmail, 1)
		    Else
				IF cOpc == "S"  
					Conout("Medicao: Enviando para o proximo aprovador")
					cQuery := " SELECT * FROM " + RetSqlName("SCR")
					cQuery += " WHERE D_E_L_E_T_ = '' "
					cQuery += " AND CR_TIPO = 'MD'"
					cQuery += " AND CR_FILIAL = '"+cFilial+"'"
					cQuery += " AND CR_NUM = '"+cNum+"'"
					cQuery += " AND CR_STATUS = '02' "
					
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"SCRTMP",.T.,.T.)
					SCRTMP->(DbGotop())	
					While !SCRTMP->(Eof())
						cAprovador 	:= Alltrim(Posicione("SAK",2,xFilial("SAK")+SCRTMP->CR_USER,"AK_NOME"))
						cCodUsr    := SCRTMP->CR_USER
						SCRTMP->(DbSkip())
					End
					DbCloseArea("SCRTMP")	      
					U_INGCTW02(CND->CND_FILIAL, CND->CND_NUMMED, CND->CND_CONTRA, cCodUsr, .F.)
					INSendMail(cEmail, 2, cAprovador)

				Else // Pedido reprovado
					Conout("U_INEnviaEmail - Enviando Aviso de pedido reprovado")
					INSendMail(cEmail, 3,,cObs) 
				Endif 
			Endif

			// Aprovador, sua resposta foi processada pelo protheus //
			_cwTit 	:= 'Medição '+Alltrim(CND->CND_NUMMED)+Iif(cOpc == "S", " Aprovada"," Reprovada")
			_cEmail	:= UsrRetMail(__cCurrAprov)
			_cMsg := '<html>
			_cMsg += '<head>
			_cMsg += u_INCOMWST(.F.)
			_cMsg += '<meta http-equiv="Content-Language" content="en-us">
			_cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
			_cMsg += '<BODY>     
			_cMsg += '<form method="POST" action="">
			_cMsg += '<font face="Arial" size=2>Medição '+Alltrim(CND->CND_NUMMED)+' do contrato nº '+Alltrim(CND->CND_CONTRA)+', filial '+CND->CND_FILIAL+Iif(cOpc == "S", " Aprovada com sucesso"," Reprovada com sucesso")
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
			dbSelectArea("CND")
			dbSetOrder(4)
			dbSeek(xFilial("CND")+LEFT(SCR->CR_NUM,6))
	        cNum := CND->CND_NUMMED

		// Envia novo e-mail
			Conout("Senha invalida, enviando novo e-mail")
			U_INGCTW02(CND->CND_FILIAL, CND->CND_NUMMED, CND->CND_CONTRA, cCodUsr, .T.)
		ENDIF
	EndIf				
	fErase("\workflow\emp"+cEmpAnt+"\wfmd\" + cFileHTML+".htm")
	__Copyfile("\workflow\HTML\INErro.htm","\workflow\emp"+cEmpAnt+"\wfmd\" + cFileHTML+".htm")
	Return

Static Function INSendMail(cEmail,nOpc, cAprov)
	Local cMsg := ''
	Local cRotina := FunName()                
	DeFault cAprov := ""               
	Default cObs := ""
	
	cMsg := '<html>
	cMsg += '<head>
	cMsg += u_INCOMWST(.F.)
	cMsg += '<meta http-equiv="Content-Language" content="en-us">
	cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
	cMsg += '<BODY>     
	cMsg += '<form method="POST" action="">
	cMsg += '<font face="Arial" size=2>A medição '+CND->CND_NUMMED+','
	                                                                                
	If nOpc == 1
		cwTit := "Medição "+CND->CND_NUMMED+" aprovada com sucesso"
		cMsg += " foi aprovado com sucesso!"
	ElseIf nOpc == 2
		cwTit := "Medição "+CND->CND_NUMMED+" enviada para aprovação"
		cMsg += " foi enviada para o aprovador: "+ cAprov +" <BR><BR> " 
		IF ALLTRIM(CND->CND_FLREAJ) == "1"
			cMsg += " E-mail reencaminhado automaticamente devido alteração dos dados da medição " 
		ENDIF
	ElseIf nOpc == 3
		cwTit := "Medição "+CND->CND_NUMMED+" reprovada"
		cMsg += " foi reprovada! "+ Iif(cObs<>"","MOTIVO: "+cObs,"")
	EndIf
	  
	cMsg += '</font>'
	cMsg += U_INGCTW01(xFilial("CND"),CND->CND_NUMMED, CND->CND_CONTRA)
	cMsg += '</form>
	cMsg += '</body>
	cMsg += '</html>
	   
	u_INMEMAIL(cwTit,cMsg,cEmail)
	
Return Nil 





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
