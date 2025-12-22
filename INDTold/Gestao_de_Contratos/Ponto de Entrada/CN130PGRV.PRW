#include "ap5mail.CH"                  
#include "PROTHEUS.CH"
#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CN130PGRV  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 24/02/2004 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada d  restauracao dos alias pre-definidos       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/



User Function CN130PGRV(cTipo)
	Local cEmail := "" 
	Local lRet   := .T.
	Local aAlias := { "CND", "SCR", Alias()}
	Local cAprov := ""
	Local cFilSAL := SAL->(XFILIAL("SAL"))
	Local cFilSAK := SAK->(XFILIAL("SAK"))
	Local nValor  := CND->CND_VLTOT
	Local cNivel  := StrZero(0,TamSX3("CR_NIVEL")[1])
	Local cCodUsr := ""
	 
	If (!INCLUI .AND. !ALTERA) .And. Empty(cTipo)
		Return Nil
	EndIf 
	   
	If (INCLUI .OR. ALTERA) .And. Empty(cTipo)
		Reclock("CND", .F.)
		CND->CND_XUSER := __CUSERID     
		MsUnlock()
	EndIf   
	  	     	
	IF ALTERA
		Reclock("CND", .F.)
		CND->CND_FLREAJ := "1"     
		MsUnlock()
	ENDIF
	  
	aAlias := u_SalvaRest(aAlias)
	If Empty(cTipo)	  
		// Posicina no Controle de alçadas
		SCR->(dbSetOrder(1))
		SCR->(dbSeek(xFilial("CND")+"MD"+Trim(CND->CND_NUMMED),.T.)) 
		
		While !SCR->(Eof()) .And. xFilial("CND")+"MD"+Trim(CND->CND_NUMMED) == SCR->CR_FILIAL+SCR->CR_TIPO+Trim(SCR->CR_NUM)
			RecLock("SCR",.F.)
			SCR->(dbDelete())
			SCR->(MsUnlock())
			SCR->(dbSkip())
		Enddo
		
		// Percorre a tabela de grupo de aprovadores de acordo com o grupo do centro de custo
		SAL->(DbSetOrder(2))
		SAL->(DbSeek(cFilSAL+CND->CND_APROV,.T.)) 
		nLimAnt := 0
		While !SAL->(Eof()) .And. SAL->(AL_FILIAL+AL_COD) == cFilSAL+CND->CND_APROV
					
			// Posiciona no usuário aprovador
			SAK->(dbSeek(cFilSAK+SAL->AL_APROV))
					
			// O gerente, controller e pay sempre entram na aprovação ou
			// O Valor for acima do limite máximo ou
			// Se está dentro do limite de cada aprovador
			If SAL->AL_CATAPRV $ "GDOPT" .AND. (nValor > SAK->AK_LIMMAX .Or. (nValor >= nLimAnt .And. nValor <= SAK->AK_LIMMAX) .Or. SAL->AL_AUTOLIM == 'N')
				// Inclui controle de alçadas para o grupo de aprovação
				IncluiAlcada(CND->CND_NUMMED,SAL->AL_USER,@cNivel,SAL->AL_APROV,nValor)
			Endif
			nLimAnt := SAK->AK_LIMMAX
					
			SAL->(DbSkip())
		Enddo
	EndIf	
	SCR->(dbSetOrder(1))
	SCR->(dbSeek(xFilial("CND")+"MD"+Trim(CND->CND_NUMMED),.T.)) 
	  
	While !SCR->(Eof()) .And. xFilial("CND")+"MD"+Trim(CND->CND_NUMMED) == SCR->CR_FILIAL+SCR->CR_TIPO+Trim(SCR->CR_NUM)
		If SCR->CR_STATUS == "02"/// .And. !(SCR->CR_NIVEL $ "04")  // Se encontrou o próximo a liberar e o nível não for 03  //AL_CATAPRV <> C
			If Empty(cTipo)
//				cEmail += If( Empty(cEmail) , "", ";") + AllTrim(UsrRetMail(SCR->CR_USER  ) )
				cEmail += If( Empty(cEmail) , "", ";") + AllTrim(UsrRetMail(CND->CND_XUSER) )
				cAprov := UsrRetName(SCR->CR_USER)
				cCodUsr := SCR->CR_USER
				Exit
			Else                                                                                                                                            	
				SCR->(dbSkip())
				If !SCR->(Eof()) .And. xFilial("CND")+"MD"+Trim(CND->CND_NUMMED) == SCR->CR_FILIAL+SCR->CR_TIPO+Trim(SCR->CR_NUM)
//					cEmail += If( Empty(cEmail) , "", ";") + AllTrim(UsrRetMail(SCR->CR_USER  ) )                  
					cEmail += If( Empty(cEmail) , "", ";") + AllTrim(UsrRetMail(CND->CND_XUSER) )
					cAprov := UsrRetName(SCR->CR_USER)
					cCodUsr := SCR->CR_USER
				Else 
					cEmail += If( Empty(cEmail) , "", ";") + AllTrim(UsrRetMail(CND->CND_XUSER) )                 
					cAprov := ""                
				EndIf    
				Exit  
			EndIf  
		Endif   
		SCR->(dbSkip())
	End
	
	If Empty(cEmail)
		SCR->(dbSetOrder(1))
		SCR->(dbSeek(xFilial("CND")+"MD"+Trim(CND->CND_NUMMED),.T.)) 
		RecLock("SCR",.F.)
		SCR->CR_STATUS := "02"
		SCR->(MsUnlock())       
		While !SCR->(Eof()) .And. xFilial("CND")+"MD"+Trim(CND->CND_NUMMED) == SCR->CR_FILIAL+SCR->CR_TIPO+Trim(SCR->CR_NUM)
			If SCR->CR_STATUS == "02" .And. !(SCR->CR_NIVEL $ "04")  // Se encontrou o próximo a liberar e o nível não for 03  //AL_CATAPRV <> C
				If Empty(cTipo)
//					cEmail += If( Empty(cEmail) , "", ";") + AllTrim(UsrRetMail(SCR->CR_USER  ) )
					cEmail += If( Empty(cEmail) , "", ";") + AllTrim(UsrRetMail(CND->CND_XUSER) )
					cAprov := UsrRetName(SCR->CR_USER)
					cCodUsr := SCR->CR_USER
					Exit
				Else 
					SCR->(dbSkip())
					If !SCR->(Eof()) .And. xFilial("CND")+"MD"+Trim(CND->CND_NUMMED) == SCR->CR_FILIAL+SCR->CR_TIPO+Trim(SCR->CR_NUM)
//						cEmail += If( Empty(cEmail) , "", ";") + AllTrim(UsrRetMail(SCR->CR_USER  ) )                  
						cEmail += If( Empty(cEmail) , "", ";") + AllTrim(UsrRetMail(CND->CND_XUSER) )
						cAprov := UsrRetName(SCR->CR_USER)
						cCodUsr := SCR->CR_USER
					Else 
						cEmail += If( Empty(cEmail) , "", ";") + AllTrim(UsrRetMail(CND->CND_XUSER) )                 
						cAprov := ""                
					EndIf    
					Exit  
				EndIf  
			Endif   
				      
			SCR->(dbSkip())
		End
			  
	EndIf  
	            
	If Empty(cEmail)
	
		SAL->(dbSetOrder(1))
		SAL->(dbSeek(xFilial("SAL")+Trim(CND->CND_APROV),.T.)) 
		     
		cEmail := AllTrim(UsrRetMail(SAL->AL_USER))   
		cEmail += If( Empty(cEmail) , "", ";") + AllTrim(UsrRetMail(CND->CND_XUSER) )                 
	     
	EndIf  
	
	If lRet := !Empty(StrTran(cEmail,";",""))
		MsgRun("Enviando e-mail aos usuários","",{|| INSendMail(cEmail, cAprov) }) 
//		INGCTW02(_cFilial,_cNum, _cCodUsr, lErro)
		U_INGCTW02(CND->CND_FILIAL, CND->CND_NUMMED, CND->CND_CONTRA, cCodUsr, .F.)
	Endif
	
	u_SalvaRest(aAlias,.F.)   
	
Return lRet

Static Function INSendMail(cEmail,cAprov)
	Local cMsg := ''
	Local cwTit := "Medição "+CND->CND_NUMMED+" enviada para aprovação"
	Local cRotina := FunName()
	
	cMsg := '<html>
	cMsg += '<head>
	cMsg += u_INCOMWST(.F.)
	cMsg += '<meta http-equiv="Content-Language" content="en-us">
	cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
	cMsg += '<BODY>     
	cMsg += '<form method="POST" action="">
	cMsg += '<font face="Arial" size=2>A medição '+CND->CND_NUMMED+','
	                                                                                
	If !Empty(cAprov)
		cMsg += " foi enviada para o aprovador: "+ cAprov +".<BR><BR> " 
		IF ALLTRIM(CND->CND_FLREAJ) == "1"
			cMsg += " E-mail reencaminhado automaticamente devido alteração dos dados da medição " 
		ENDIF
	Else 
		cMsg += " foi aprovado com sucesso!"
		cwTit := "Medição "+CND->CND_NUMMED+" aprovada com sucesso"
	EndIf
	  
	cMsg += '</font>'
	cMsg += U_INGCTW01(xFilial("CND"),CND->CND_NUMMED, CND->CND_CONTRA)
	cMsg += '</form>
	cMsg += '</body>
	cMsg += '</html>
	   
	u_INMEMAIL(cwTit,cMsg,cEmail)
	
Return Nil 

//***********************************************************************************************************************
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

Static Function IncluiAlcada(cNumPC,cUser,cNivel,cAprov,nValor)
	RecLock("SCR",.T.)
	SCR->CR_FILIAL := xFilial("SCR")
	SCR->CR_NUM    := cNumPC
	SCR->CR_USER   := cUser
	SCR->CR_NIVEL  := cNivel := Soma1(cNivel) //SAL->AL_NIVEL
	SCR->CR_APROV  := cAprov
	
	If SCR->CR_NIVEL == "01"   // Se for o 1o nível
		SCR->CR_STATUS := "02"  // Aguardando liberação do usuário
	Else
		SCR->CR_STATUS := "01"  // Bloqueado pelo sistema
	EndIf
	
	SCR->CR_TOTAL   := nValor
	SCR->CR_EMISSAO := Date()  // Data da alçada
	SCR->CR_MOEDA   := 1       // Moeda Real
	SCR->CR_TIPO    := "MD"    // Pedido de compra
	MsUnLock()
Return
