#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110CON  º Autor ³ ENER FREDES        º Data ³  02/02/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  PE executado após a confirmação da SC depois da gravação  º±±
±±º          ³  das tabelas. será usado para:                             º±±
±±º          ³  * Executar a rotina INCOME04.prw para mostrar a tela para º±±
±±º          ³    a gravação dos anexos                                   º±±
±±º          ³  * Executar a rotina INCOME02.prw                          º±±
±±º          ³    para mostrar a tela de Objetivo e Justificativa         º±±
±±º          ³  * Mostrar a tela para seleção do Centro de Custo Aprovadorº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COMPRAS - Solicitação de Compra                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/        

              
User function MT110CON()  
	Local aRegs_SZF := {}
	Local cJustific := ""
	Local cCCAprv := ""  
	Local cQuery := ""
	Local cAlias := ALIAS()
	Local nRecno := RECNO()   

	If INCLUI
		cCodCompr := ""
	EndIf

	cJustific := GetGlbValue("SC_JUST_"+CA110NUM)
	cCCAprv := GetGlbValue("SC_CCAPRV_"+CA110NUM)
	If Empty(cJustific) .Or. Empty(cCCAprv)
		U_INCOME02("Justificativa da Compra","2","",CA110NUM,"","","",.T.,.T.,"",cJustific,.T.,{.T.,'SC1','C1_CCAPRV',"",cCCAprv})
	Else
		U_INCOME02("Justificativa da Compra","2","",CA110NUM,"","","",.F.,.T.,"",cJustific,.T.,{.T.,'SC1','C1_CCAPRV',"",cCCAprv})
	EndIf
	cCCAprv := GetGlbValue("SC_CCAPRV_"+CA110NUM)
	ClearGlbValue("SC_JUST_"+CA110NUM)    
	ClearGlbValue("SC_CCAPRV_"+CA110NUM)    
	GetGlbVars("SC_ANEXO_"+CA110NUM,@aRegs_SZF)
   U_INCOME04("1",CA110NUM,.T.,.F.,"",.F.,aRegs_SZF)
	ClearGlbValue("SC_ANEXO_"+CA110NUM) 
	fValdSC(CA110NUM,CCODCOMPR)   

	DbSelectArea(cAlias)
	DbGoto(nRecno)
Return 
                                                            
                                                                    
Static Function fValdSC(cNumSC,cCodCompr)
	Local cGrpInf := "900001"    // Grupo padrão de informática
	Local cAlias := ALIAS()
	SC1->(DbSetOrder(1))
	If SC1->(DbSeek(xFilial("SC1")+cNumSC))
		While !SC1->(Eof()) .And. SC1->(C1_FILIAL+C1_NUM) == xFilial("SC1")+cNumSC
			// Posiciona no centro de custo de aprovação
			CTT->(DbsetOrder(1))
			CTT->(DbSeek(xFilial("CTT")+SC1->C1_CCAPRV))
			
			SAL->(DbSetOrder(2))
			SAL->(DbSeek(xFilial("SAL")+CTT->CTT_APROV,.T.))
			// Se for produto de informática e não tiver analisando o grupo de informática
			If SC1->C1_PROINF == "S" .And. SAL->AL_COD <> cGrpInf  .And. !Empty(cCodCompr)
				// Inclui o gerente de informatica na aprovação pois é obrigatória a aprovação do mesmo
				AprovaExtra(SAL->AL_FILIAL+cGrpInf,cNumSC)
				lAprov := .F.
				Exit
			Endif
			SC1->(DbSkip())	
		Enddo
	EndIf
	dbSelectArea(cAlias)
	
Return

Static Function AprovaExtra(cSeek,cNumSC)
	Local aSAL := SAL->({IndexOrd(),Recno()})
	
	// Pesquisa o usuario gerente do grupo
	SAL->(dbSetOrder(1))
	SAL->(dbSeek(cSeek,.T.))
	While !SAL->(Eof()) .And. cSeek == SAL->(AL_FILIAL+AL_COD)
		If SAL->AL_CATAPRV == "G"   // Se encontrou o gerente do grupo
			// Inclui aprovação extra para o controle de alçadas
			cEmail := AllTrim(UsrRetMail(SAL->AL_USER))
			INSendMail(cEmail,cNumSC)
			Exit
		Endif
		SAL->(dbSkip())
	Enddo
	
	// Restaura configurações da tabela
	SAL->(dbSetOrder(aSAL[1]))
	SAL->(dbGoTo(aSAL[2]))
	
Return
     

Static Function INSendMail(cEmail,cNumSC)
   Local cMens := ""
	cMens := '<html>
	cMens += '<head>
	cMens += '<meta http-equiv="Content-Language" content="en-us">
	cMens += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
	cMens += '<title>Solicitação de Compra</title>
	cMens += u_INCOMWST(.F.)
	cMens += '</head>
	cMens += '<form method="POST" action="">
	cMens += '<body>
	cMens += "<P>A solicitação "+cNumSC+", filial "+NomeFilial(xFilial("SC1"))+" possui Material de Informática. Avaliar a necessidade de Compra  </p>" 
	cMens += U_INCOMW02(xFilial("SC1"),cNumSC)
	cMens += '</body>
	cMens += '</form>
	cMens += "</html> 
   MsgRun("Enviando e-mail para "+cEmail," Marial de Informatica..",{|| u_INMEMAIL("Solicitacão  solicitação "+cNumSC+", filial "+NomeFilial(xFilial("SC1"))+" com Material de Informática",cMens,cEmail) })

   
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
