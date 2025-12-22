#include "rwmake.ch"
#include "topconn.ch"

User Function SD1100E()
Local _aArea:= GetArea()
Local cQry
Local	aAreaSD2 := SD2->(GetArea())
Local	aAreaSC6 := SC6->(GetArea())

///
///22/05/2013: Estorna o conteudo dos campos referente a devolucao do item na tabela SD2/SC6.
///

If SD1->D1_TIPO=="D".AND.SD1->D1_TES=="311".AND.SM0->M0_CODIGO=="03"     ///Carlos: 22/05/13 --> Devolucao. Facilitar planilha do Brandao.
	D1NFORI := SD1->D1_NFORI
	IF ( !EMPTY(D1NFORI) )
		IF ( SX3->(dbSeek("D2_X_DDOC")) )
			D1TOTAL := ( SD1->D1_TOTAL - SD1->D1_VALDESC )
			dbSelectArea("SD2")
			dbSetOrder(3)
			dbSeek(SD1->D1_FILIAL+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEMORI)
			IF ( !EOF() )
				RecLock("SD2",.F.)
				IF ( SD1->D1_QUANT == SD2->D2_X_DQTY )
					SD2->D2_X_DDOC  := " "
					SD2->D2_X_DDTA  := CTOD("")
				ENDIF	
				SD2->D2_X_DQTY  -= SD1->D1_QUANT
				SD2->D2_X_DVLR  -= D1TOTAL
				MsUnlock()
				*
				dbSelectArea("SC6")
				dbSetOrder(1)
				dbSeek(SD1->D1_FILIAL+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD1->D1_COD)
				IF ( !EOF() )
					RecLock("SC6",.F.)
					IF ( !EMPTY(SC6->C6_X_DDTA3) )
						SC6->C6_X_DDTA3 := CTOD("")
						SC6->C6_X_DQTY3 := 0
						SC6->C6_X_DVLR3 := 0
					ELSEIF ( !EMPTY(SC6->C6_X_DDTA2) )
						SC6->C6_X_DDTA2 := CTOD("")
						SC6->C6_X_DQTY2 := 0
						SC6->C6_X_DVLR2 := 0
					ELSEIF ( !EMPTY(SC6->C6_X_DDTA1) )
						SC6->C6_X_DDTA1 := CTOD("")
						SC6->C6_X_DQTY1 := 0
						SC6->C6_X_DVLR1 := 0
					ENDIF
					MsUnlock()
				ENDIF
			ENDIF
			RestArea(aAreaSD2)
			RestArea(aAreaSC6)
		ENDIF
	ENDIF
	dbSelectArea("SD1")
EndIf

///
///30/04/2012: Estorno da baixa o pedido de compra do produto beneficiado fora.
///            Se faz necessario porque a entrada da nota fiscal (cfop=1124) ao inves de entrar com o codigo do pedido 
///            entra com o codigo 00000005 amarrado a ordem de producao do codigo do pedido.
///            Somente, até o momento, para a base coelmatic/manaus.
///
IF ( SM0->M0_CODIGO+SM0->M0_CODFIL == "0301" )
	IF ( SD1->D1_CF == '1124 ' .AND. LEFT(SD1->D1_COD,8) == "00000005" .AND. !EMPTY(SD1->D1_PEDIDO) )
		x_Pedido  := SD1->D1_PEDIDO
		x_ItemPc  := SD1->D1_ITEMPC
		x_Fornece := SD1->D1_FORNECE
		x_Loja    := SD1->D1_LOJA
		x_Doc     := SD1->D1_DOC
		x_Serie   := SD1->D1_SERIE
		
		dbSelectArea("SC7")
		dbSetOrder(1)
		dbSeek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC)
		IF ( !EOF() )
			cQry := "SELECT SUM(D1_QUANT) QUJE FROM "+RetSqlName("SD1")
			cQry += " WHERE D1_FILIAL = '"+xFilial("SD1")+"'"
			cQry += " AND   D1_CF  = '1124'"
			cQry += " AND   D1_DOC+D1_SERIE <> '"+x_Doc+x_Serie+"'"
			cQry += " AND   D1_FORNECE = '"+x_Fornece+"' AND D1_LOJA = '"+x_Loja+"'"
			cQry += " AND   D1_PEDIDO = '"+x_Pedido+"' AND D1_ITEMPC = '"+x_ItemPc+"'"
			cQry += " AND   D_E_L_E_T_  = ' ' "

			cQry := ChangeQuery(cQry)

			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TB3', .T., .T.)

			TcSetField("TB3","QUJE","N",12,2)
			
			x_Quant := TB3->QUJE
			
			TB3->(dbCloseArea())
			
			IF ( x_Quant > 0 )
				RecLock("SC7",.F.)
				SC7->C7_QUJE  := x_Quant
				SC7->C7_ENCER := " " 
				MsUnlock()
			ENDIF	
			
		ENDIF	
		
		RestArea(_aArea)
		
		Return
		
	ENDIF
ENDIF

if sm0->m0_codigo != "04"
   return
endif

dbselectarea("SZM")
dbsetorder(2)
   reclock("SZM",.T.)
   SZM->ZM_FILIAL := xFilial()
   SZM->ZM_TM	  := "601"
   SZM->ZM_COD	  := SD1->D1_COD
   SZM->ZM_LOCAL  := "01"
   SZM->ZM_DATA   := SD1->D1_DTDIGIT
   SZM->ZM_QUANT  := SD1->D1_QUANT
   SZM->ZM_DOCSERI:= SD1->D1_DOC + SD1->D1_SERIE
   SZM->ZM_CLIFORN:= SD1->D1_FORNECE + SD1->D1_LOJA
   SZM->ZM_NFES   := "E"
   msunlock()

RestArea(_aArea)

Return