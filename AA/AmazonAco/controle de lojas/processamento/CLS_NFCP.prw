#Include "rwmake.ch"
#Include "Protheus.ch"

User Function CLS_NFCP()

cCupom := Space(09)
cSerie := Space(03)

Define Font oFnt3 Name "Ms Sans Serif" Bold

Define Msdialog oDlgMain Title "Libera Nota Fiscal para Cupom" From 96,5 to 200,350 Pixel


@005, 15 say "Cupom Fiscal : " Size 100,10 Of oDlgMain Pixel Font oFnt3
@005, 70 Get cCupom    Picture "@!" Size 50,8 Pixel of oDlgMain

@015, 15 say "Serie (A0?)  : " Size 100,10 Of oDlgMain Pixel Font oFnt3
@015, 70 Get cSerie    Picture "@!" Size 50,8 Pixel of oDlgMain

@ 35 ,50 BMPBUTTON TYPE 1 ACTION Limpa()

Activate Msdialog oDlgMain Centered

Return()

Static Function Limpa()

oDlgMain:End()

DbSelectArea("SF2")
DbSetorder(1)

DbSelectArea("SD2")
DbSetorder(3)                // Documento+Serie

DbSelectArea("SE1")
DbSetorder(1)                


If SF2->(DbSeek(xFilial("SF1")+cCupom+cSerie)) // Pesquisa o Cupom Fiscal
	
	nRecSF2 := SF2->(RecNo())
	
	If !Empty(SF2->F2_NFCUPOM) // Verifica se foi gerada a Nota Fiscal Série ÚNICA
		
		If SF2->(DbSeek(xFilial("SF2")+SubStr(SF2->F2_NFCUPOM,4,9)+SubStr(SF2->F2_NFCUPOM,1,3)))  // Pesquisa a Nota Fiscal Série ÚNICA Gerada
			
			If SD2->(DbSeek(xFilial("SF2")+SF2->F2_DOC+SF2->F2_SERIE))
				
				Begin Transaction
				
				Do While !SD2->(Eof()) .And. SF2->(F2_FILIAL+F2_DOC+F2_SERIE) == SD2->(D2_FILIAL+D2_DOC+D2_SERIE)
					
					RecLock("SD2")
					SD2->(DbDelete())
					MsUnLock()
					
					SD2->(DbSkip())
					
				EndDo
				
				
				RecLock("SF2")
				SF2->(DbDelete())
				MsUnLock()
				
				SF2->(DbGoto(nRecSF2)) // Retorna a posição do Cupom Fiscal
				
				//Pesquisa no Contas a Receber para limpar o registro da Nota Fiscal para Cupom
				If SE1->(DbSeek(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC))
					
					Do While !SE1->(Eof()) .And. SF2->(F2_FILIAL+F2_DOC+F2_SERIE) == SE1->(E1_FILIAL+E1_NUM+E1_PREFIXO)
						
						RecLock("SE1")
						SE1->E1_NFPCUP  := Space(09)
						SE1->E1_SERPCUP := Space(03)
						MsUnLock()
						
						SE1->(DbSkip())
						
					EndDo
					
				EndIf
				
				cNFCUPOM := SF2->F2_NFCUPOM
				
				RecLock("SF2")
				SF2->F2_NFCUPOM := Space(12)
				MsUnLock()
				
				End Transaction
				
				Alert("Não esqueça de CANCELAR a Nota Fiscal "+SubStr(cNFCUPOM,4,9)+"/"+SubStr(cNFCUPOM,1,3) )
				
			EndIf
			
		EndIf
		
	Else
		MsgAlert("Não foi gerada Nota Fiscal para este CUPOM FISCAL !!!","ATENÇÃO")
	EndIf
	
Else
	MsgAlert("Cupom Fiscal não encontrado !!!","ATENÇÃO")
EndIf

Return()
