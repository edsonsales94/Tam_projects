#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ SPDFIS04   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 04/10/2021 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada para enviar a Descrição da NF no SPED FISCAL ¦¦¦
¦¦¦ Descr     ¦ Alterado por Adson em 15/03/23 p buscar a Desc da SDT         ¦¦¦
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
	Local aArea       := GetArea()
	
	If cFT_TIPOMOV == "E"
		//u_zConOut("["+FunName()+"] - ENTROU")
		SDT->(dbSetOrder(8))   // DT_FILIAL+DT_FORNECE+DT_LOJA+DT_DOC+DT_SERIE+DT_ITEM
		If SDT->(dbSeek(cFT_FILIAL+cFT_CLIEFOR+cFT_LOJA+cFT_NFISCAL+cFT_SERIE+cFT_ITEM))
			//u_zConOut("["+FunName()+"] - ACHOU SDT")
			if !empty(SDT->DT_DESCFOR)
				cRet := SDT->DT_DESCFOR
			endif 
		Endif
	Endif
	
	RestArea(aArea)

Return cRet
