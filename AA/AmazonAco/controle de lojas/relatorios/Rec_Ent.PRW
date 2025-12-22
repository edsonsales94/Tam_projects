#INCLUDE "Rwmake.ch"

User Function Rec_Ent()

Local   mMensagem
Local   mMensProd 	:= ""
Local   aRet  		:= {.F.,'',''} // Retorno da Funcao
Local   aArea 		:= GetArea()
Local   cImpCEnt 	:= GETMV("MV_IMPCENT")  // Parâmetro que define se será impresso o comprovante de Entrega no ECF
Private vProdEnt := {}

DbSelectArea("SA1")
DbSetOrder(1)

DbSelectArea("SB1")
DbSetOrder(1)

DbSelectArea("SL2")
DbSetOrder(1)
DbGotop()

DbSelectArea("SL1")

If cImpCEnt == "S"  // Imprime Comprovante no ECF
	
	If SL1->L1_ENTREGA == "S"  // Se há itens para entrega de produtos
		
		SL2->(DbSeek(xFilial("SL2")+SL1->L1_NUM))
		
		SA1->(DbSeek(xFilial()+SL1->L1_CLIENTE+SL1->L1_LOJA))
		
		//	cNome        := SA1->A1_NOME
		
		mMensagem := CHR(13)+CHR(10)+'------------------------------------------------'+CHR(13)+CHR(10)+;
		'        RECIBO DE ENTREGA DE MERCADORIAS '+CHR(13)+CHR(10)+;
		'------------------------------------------------'+CHR(13)+CHR(10)+;
		'             DADOS DA ENTREGA'+CHR(13)+CHR(10)+;
		'------------------------------------------------'+CHR(13)+CHR(10)+;
		'NOME : ' +SL1->L1_RECENT+CHR(13)+CHR(10)+;
		'FONE : ' +SL1->L1_FONEENT+CHR(13)+CHR(10)+;
		'END. ENT.: '+SL1->L1_ENDENT+CHR(13)+CHR(10)+;
		'REFERENCIA:'+SL1->L1_REFEREN+CHR(13)+CHR(10)+;
		'BAIRRO: '+SL1->L1_BAIRROE+CHR(13)+CHR(10)+;
		'CIDADE: '+SL1->L1_MUNE+'   ESTADO : '+SL1->L1_ESTE+CHR(13)+CHR(10)+;
		'OBS 1 : ' +SL1->L1_OBSENT1+CHR(13)+CHR(10)+;
		'OBS 2 : ' +SL1->L1_OBSENT2+CHR(13)+CHR(10)+;
		'------------------------------------------------'+CHR(13)+CHR(10)+;
		'             PRODUTOS           '+CHR(13)+CHR(10)+;
		'---------------------------------------------'+CHR(13)+CHR(10)+;
		'DOC. FISCAL: '+SL1->L1_DOC+' / '+ SL1->L1_SERIE+CHR(13)+CHR(10)+;
		''+CHR(13)+CHR(10)
		Do While !SL2->(Eof()) .And. SL2->(L2_FILIAL+L2_NUM) == SL1->(L1_FILIAL+L1_NUM)
			
			SB1->(DbSeek(xFilial("SB1")+SL2->L2_PRODUTO))
			
			mMensProd := mMensProd + ALLTRIM(SL2->L2_PRODUTO)+" - "+ ALLTRIM(SL2->L2_DESCRI) +CHR(13)+CHR(10)+;
			'REFERENCIA: '+ALLTRIM(SB1->B1_REFEREN) + '  QUANT.: '+ALLTRIM(STR(SL2->L2_QUANT)) +CHR(13)+CHR(10)
			
			SL2->(DbSkip())
			
		EndDo
		
		mMensagem:= (mMensagem +mMensProd)+CHR(13)+CHR(10)+'VALOR DOS PRODUTOS: R$ '+ALLTRIM(Transform(SL1->L1_VALBRUT,"@E 999,999,999.99"))+' '+;
		''+IIf(SL1->L1_RECLOC=="S","RECEBER NO LOCAL","PAGO NA LOJA")+CHR(13)+CHR(10)+;
		'------------------------------------------------'+CHR(13)+CHR(10)+;
		'             TEXTO OBRIGATORIO'+CHR(13)+CHR(10)+;
		'------------------------------------------------'+CHR(13)+CHR(10)+;
		'Declaro que recebi as mercadorias listadas'+CHR(13)+CHR(10)+;
		'acima, e estão de acordo com  o solicitado '+CHR(13)+CHR(10)+;
		'ao PILOTO '+CHR(13)+CHR(10)+;
		'------------------------------------------------'+CHR(13)+CHR(10)+;
		'              ASSINATURA'+CHR(13)+CHR(10)+;
		'------------------------------------------------'+CHR(13)+CHR(10)+;
		''+CHR(13)+CHR(10)+;
		'Assinatura: _____________________________'+CHR(13)+CHR(10)+;
		''+CHR(13)+CHR(10)+;
		'Manaus-AM, ________/_________/________'+CHR(13)+CHR(10)
		
		// Impressão do Relatório Gerencial
		nRet         := IFRelGer(nHdlECF, mMensagem,1)
		If nRet <> 0
			aRet[3]:="Existem problemas com a sua impressora fiscal. erro -19. Contate o Administrador"
			Return(aRet)
		EndIf
		
	Endif

EndIf
RestArea(aArea)

Return
