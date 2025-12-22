#include "RwMake.ch"
#include "Protheus.ch"

User Function MT120GRV
/*
	Local cNumPC	:= SC7->C7_NUM            
	Local cCC		:= SC7->C7_CC
	Local cJustific:= ""
	Local cAlias	:= ALIAS()    

	DbSelectArea("SZ6")
	DbSetOrder(1)
	If dbSeek(xFilial("SZ6")+"1"+cNumPC)
		cJustific := SZ6->Z6_JUSTIFI
	EndIf   

///Mostra tela de Objetivo e Justificativa
	U_INCOME02("Justificativa da Compra","1","",aPedido[x],"","","",.T.,.T.,"",cJustific,.T.,{.F.,'','',"",""})


	///Altera o grupo de aprovação dos pedidos de Compra
	fGravaSCR(cNumPC,cCC)
	DbSelectArea(cAlias)

   u_INEnviaEmail(SC8->C8_FILIAL,cNumPC,"",1,"")   // Envia e-mail para os aprovadores
*/  
Return

Static Function fGravaSCR(cNumPC,cCCusto)
	Local cQuery := ""
	Local nvalor := 0             
	Local cGrpAprov := ""
	Local mDetalhe := ""
	Local cTes    := ""
	Local cAlias := ALIAS()
	
	cQuery := " DELETE "+RetSqlName("SCR")
	cQuery += " WHERE D_E_L_E_T_ = ''
	cQuery += " AND CR_FILIAL = '"+xFilial("SCR")+"'
	cQuery += " AND CR_NUM = '"+cNumPC+"'
   TCSQLEXEC(cQuery)
   
  	cQuery := " SELECT * FROM "+RetSqlName("SC7")+ " SC7"
	cQuery += " WHERE SC7.D_E_L_E_T_ = ''
	cQuery += " AND C7_FILIAL = '"+xFilial("SCR")+"'
	cQuery += " AND C7_NUM = '"+cNumPC+"'
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TMPSC7",.T.,.T.)
	While !TMPSC7->(Eof())
		cGrpAprov := Posicione("CTT",1,xFilial("CTT")+cCCusto,"CTT_APROV")
		mTes		 := Posicione("SB1",1,xFilial("SB1")+TMPSC7->C7_PRODUTO,"B1_TE")
		DbSelectArea("SC7")
		DbSetOrder(1)
		If DbSeek(xFilial("SC7")+TMPSC7->C7_NUM+TMPSC7->C7_ITEM)
			RecLock("SC7",.F.)
			SC7->C7_APROV		:= cGrpAprov
			SC7->C7_CONAPRO	:= 'B'
			SC7->C7_DATPRF		:= CTOD('//')
/*
			SC7->C7_DESCCLV	:= TMPSC7->C1_DESCCLV
			SC7->C7_DESCCC		:= TMPSC7->C1_DESCCC
			SC7->C7_DESCCTB	:= TMPSC7->C1_DESCCTB
			SC7->C7_GERENT		:= TMPSC7->C1_GERENTE
			SC7->C7_NOME		:= TMPSC7->C1_NOME
			SC7->C7_DETALH		:= mDetalhe
*/
			SC7->C7_TES			:= mTes
			MsUnLock()
		EndIf
		nValor += TMPSC7->C7_TOTAL
		TMPSC7->(DbSkip())
	End


	DbSelectArea("TMPSC7")
	DbCloseArea("TMPSC7")

	CTT->(DbsetOrder(1))
	If CTT->(DbSeek(xFilial("CTT")+cCCusto))
		DbSelectArea("SAL")
		DbSetOrder(2)
  		If DbSeek(xFilial("SAL")+CTT->CTT_APROV)   
	  		While !SAL->(Eof()) .And. SAL->AL_COD = CTT->CTT_APROV
				SAK->(DbSetOrder(2))
				If SAK->(DbSeek(xFilial("SAK")+SAL->AL_USER))
					If (nValor > SAK->AK_LIMMAX .Or. nValor < SAK->AK_LIMMIN) .And. fValAprov(CTT->CTT_APROV)
						SAL->(DbSkip())
						Loop
					EndIf

					RecLock("SCR",.T.)
					SCR->CR_FILIAL := xFilial("SCR")
					SCR->CR_NUM := cNumPC
					SCR->CR_USER := SAL->AL_USER
					SCR->CR_NIVEL := SAL->AL_NIVEL
					SCR->CR_APROV := SAL->AL_APROV
					If SAL->AL_NIVEL = "01"
						SCR->CR_STATUS := "02"
					Else
						SCR->CR_STATUS := "01"
					EndIf                         
					SCR->CR_TOTAL := nValor
					SCR->CR_EMISSAO := Date()
					SCR->CR_MOEDA := 1
					SCR->CR_TIPO := "PC"
					MsUnLock()
				EndIf
				SAL->(DbSkip())
			End
		EndIf
	EndIf
         
	DbSelectArea(cAlias)
Return




Static Function fValAprov(cGrpAprv)
	Local lReturn := .T.
	Local cAlias := ALIAS()

  	cQuery := " SELECT COUNT(*) TOTREG FROM "+RetSqlName("SAL")
	cQuery += " WHERE D_E_L_E_T_ = ''"
	cQuery += " AND AL_COD = '"+cGrpAprv+"' AND AL_NIVEL IN ('01','02')
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TMPSAL",.T.,.T.)

	If TMPSAL->TOTREG < 2
		lReturn := .F.
	EndIf
	              
	DbCloseArea("TMPSAL")
	DbSelectArea(cAlias)
Return lReturn
