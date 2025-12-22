#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ A140IGRV   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 04/10/2021 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ P. E. p/ ajustes apos a inclusao dos dados na tabela SDS e SDT¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function A140IGRV()
	Local nX
	Local cDoc    := ParamIXB[1]
	Local cSerie  := ParamIXB[2]
	Local cCodigo := ParamIXB[3]
	Local cLoja   := ParamIXB[4]
	Local oXml    := ParamIXB[5]
	Local aItens  := IIF(ValType(oXML:_InfNfe:_Det) == "O",{oXML:_InfNfe:_Det},oXML:_InfNfe:_Det)
	
	// Processa a regravação da UM vinda no XML
	SDT->(dbSetOrder(8))
	SDT->(dbGoTop())
	If SDT->(dbSeek(XFILIAL("SDT")+cCodigo+cLoja+cDoc+cSerie,.T.))
		//u_zConOut("["+FunName()+"] - ACHOU SDT")
		For nX:=1 To Len(aItens)
			RecLock("SDT",.F.)
			SDT->DT_XQTDXML := Val(aItens[nX]:_Prod:_QCom:Text)
			SDT->DT_XUMXML  := aItens[nX]:_Prod:_UCom:Text
			MsUnLock()
			SDT->(dbSkip())
		Next
	Endif
    
Return

