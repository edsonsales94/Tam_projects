#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ SPDFIS04   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 04/10/2021 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada para enviar a Descrição da NF no SPED FISCAL ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function SPDFIS04()
	Local cFT_FILIAL  := ParamIXB[1]
	Local cFT_TIPOMOV := ParamIXB[2]
	Local cFT_SERIE   := ParamIXB[3]
	Local cFT_NFISCAL := ParamIXB[4]
	Local cFT_CLIEFOR := ParamIXB[5]
	Local cFT_LOJA    := ParamIXB[6]
	Local cFT_ITEM    := ParamIXB[7]
	Local cFT_PRODUTO := ParamIXB[8]
	Local cRet        := Posicione("SB1",1,XFILIAL("SB1")+cFT_PRODUTO,"B1_DESC")
	
	If cFT_TIPOMOV == "E"
		Conout("["+FunName()+"] - ENTROU")
		SD1->(dbSetOrder(1))   // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		If SD1->(dbSeek(cFT_FILIAL+cFT_NFISCAL+cFT_SERIE+cFT_CLIEFOR+cFT_LOJA+cFT_PRODUTO+cFT_ITEM))
			Conout("["+FunName()+"] - ACHOU SD1")
			DKD->(dbSetOrder(1))   // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
			If DKD->(dbSeek(cFT_FILIAL+cFT_NFISCAL+cFT_SERIE+cFT_CLIEFOR+cFT_LOJA+cFT_ITEM))
				if Empty(DKD->DKD_XDESXM)
					SDT->(DbSetOrder(3))
					if SDT->(DbSeek(cFT_FILIAL+cFT_CLIEFOR+cFT_LOJA+cFT_NFISCAL+cFT_SERIE+cFT_PRODUTO))
						if !empty(SDT->DT_DESCFOR)
							cRet := rtrim(SDT->DT_DESCFOR)
						EndIf
					endif
				endif
			cRet := If( Empty(DKD->DKD_XDESXM) , cRet, DKD->DKD_XDESXM)
			EndIf
		Endif
	Endif

Return cRet
