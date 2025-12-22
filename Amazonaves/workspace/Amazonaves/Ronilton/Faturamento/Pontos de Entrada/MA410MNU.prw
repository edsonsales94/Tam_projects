#Include "Protheus.ch"

/*_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+------------------------+-------------------+¦¦
¦¦¦ Programa  ¦ MA410MNU   ¦ Autor ¦ Ronilton O. Barros     ¦ Data ¦ 21/06/2024 ¦¦¦
¦¦+-----------+------------+-------+------------------------+-------------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada para incluir novas opções no pedido de venda   ¦¦¦
¦¦+-----------+-----------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MA410MNU()
	Aadd(aRotina,{ "Pre-Danfe"  ,"u_AMPreDanfe",0,4,0 ,NIL} )
Return

User Function AMPreDanfe()
	Local cSeek  := SD2->(XFILIAL("SD2"))+SC5->C5_NUM
	Local aNotas := {}
	
	SD2->(dbSetOrder(8))    // D2_FILIAL+D2_PEDIDO+D2_ITEMPV
	SD2->(dbSeek(cSeek,.T.))
	While !SD2->(Eof()) .And. SD2->D2_FILIAL+SD2->D2_PEDIDO == cSeek
		If AScan( aNotas , SD2->D2_DOC+SD2->D2_SERIE ) == 0
			AAdd( aNotas , SD2->D2_DOC+SD2->D2_SERIE )
		Endif
		SD2->(dbSkip())
	Enddo
	
	If Empty(aNotas)
		FWAlertError("Não existe nota fiscal emitida para esse pedido de venda !")
	Else
		SF2->(dbSetOrder(1))
		If SF2->(dbSeek(XFILIAL("SF2")+aNotas[Len(aNotas)])) .And. Trim(SF2->F2_ESPECIE) == "SPED"
			mv_par01 := SF2->F2_DOC
			mv_par02 := SF2->F2_SERIE
			
			u_Predanfe()
		Else
			FWAlertError("Esse documento não é uma Nota Fiscal Eletrônica !")
		Endif
	Endif

Return

User Function AMBloqSep()
	If SC5->C5_XBLQSEP == "1" .Or. !Empty(SC5->C5_XENTREG)    // Caso esteja bloqueado
		If FWAlertYesNo("Confirma o Desbloqueio da Separação do pedido " + SC5->C5_NUM + " ?")
			RecLock("SC5",.F.)
			SC5->C5_XBLQSEP := "2"    // Desbloqueia a separação
			SC5->C5_XENTREG := CriaVar("C5_XENTREG",.F.)
			MsUnLock()
			FWAlertSuccess("Desbloqueio realizado com sucesso !")
		Endif
	Else
		FWAlertWarning("Esse pedido não está bloqueado para separação !")
	Endif
Return

User Function AMDtEntrega()
	Local oEnt, oPanelT, dEntrega
	Local oFont := TFont():New("COURIER NEW",08,18)
	Local cSeek := SC6->(XFILIAL("SC6"))+SC5->C5_NUM
	Local nOpcA := 1
	
	If !Empty(SC5->C5_NOTA) .Or. SC5->C5_LIBEROK == 'E' .And. Empty(SC5->C5_BLQ)
		FWAlertError("Não é permitido alterar a data de entrega em pedidos já encerrados !")
		Return
	ElseIf SC5->C5_XBLQSEP == "1"    // Caso esteja bloqueado
		//FWAlertError("Não é permitido alterar a data de entrega de pedidos bloqueados para separação !")
		//FWAlertExitPage("Esse pedido se encontra bloqueado e em processo de separação !","Pedido bloqueado para separação",{|a| nOpcA := a})
		If !FWAlertYesNo("Esse pedido se encontra bloqueado e em processo de separação. Confirma a alteração da data de entrega ?")
			Return
		Endif
	Endif
	
	SC6->(dbSetOrder(1))
	If SC6->(dbSeek(cSeek,.T.))
		dEntrega := SC6->C6_ENTREG
		
		DEFINE MSDIALOG oEnt TITLE "Pedido " + SC5->C5_NUM + " - Nova Data de Entrega" From 0,0 To 07,55 STYLE DS_MODALFRAME STATUS OF oMainWnd
		
		@ 0,0 MSPANEL oPanelT PROMPT "" SIZE 10,22 OF oEnt CENTERED LOWERED //"Botoes"
		oPanelT:Align := CONTROL_ALIGN_BOTTOM
		
		@ 05, 005 SAY "Data de Entrega"  SIZE  80,10 PIXEL OF oPanelT COLOR (CLR_BLUE) FONT oFont
		@ 05, 080 MSGET dEntrega  SIZE 60,10 PIXEL OF oPanelT Valid dEntrega >= dDataBase .And. dEntrega >= SC5->C5_EMISSAO FONT oFont
		
		ACTIVATE MSDIALOG oEnt ON INIT EnchoiceBar(oEnt,{|| nOpcA:=1,oEnt:End() },{|| oEnt:End() } ) CENTERED
		
		If nOpcA == 1
			Begin Transaction
				While !SC6->(Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM == cSeek
					RecLock("SC6",.F.)
					SC6->C6_ENTREG := dEntrega
					MsUnLock()
					SC6->(dbSkip())
				Enddo
				
				RecLock("SC5",.F.)
				SC5->C5_XBLQSEP := "2"    // Desbloqueia a separação
				SC5->C5_XENTREG := dEntrega
				SC5->C5_FECENT  := dEntrega
				MsUnLock()

			End Transaction
		Endif
	Endif

Return

User Function AMMenNota()
	Local oEnt, oPanelT
	Local cMenNota := SC5->C5_MENNOTA
	Local oFont    := TFont():New("COURIER NEW",08,18)
	Local nOpcA    := 0
	
	If !Empty(SC5->C5_NOTA) .Or. SC5->C5_LIBEROK == 'E' .And. Empty(SC5->C5_BLQ)
		FWAlertError("Não é permitido alterar a Mensagem para a Nota em pedidos já encerrados !")
		Return
	Endif
	
	DEFINE MSDIALOG oEnt TITLE "Pedido " + SC5->C5_NUM + " - Mensagem para a Nota" From 0,0 To 07,79 STYLE DS_MODALFRAME STATUS OF oMainWnd
	
	@ 0,0 MSPANEL oPanelT PROMPT "" SIZE 10,22 OF oEnt CENTERED LOWERED //"Botoes"
	oPanelT:Align := CONTROL_ALIGN_BOTTOM
	
	@ 05, 005 SAY "Mensagem"  SIZE  80,10 PIXEL OF oPanelT COLOR (CLR_BLUE) FONT oFont
	@ 05, 045 MSGET cMenNota  SIZE 260,10 PIXEL OF oPanelT FONT oFont
	
	ACTIVATE MSDIALOG oEnt ON INIT EnchoiceBar(oEnt,{|| nOpcA:=1,oEnt:End() },{|| oEnt:End() } ) CENTERED
	
	If nOpcA == 1
		Begin Transaction
			
			RecLock("SC5",.F.)
			SC5->C5_MENNOTA := cMenNota
			MsUnLock()

		End Transaction
	Endif

Return
