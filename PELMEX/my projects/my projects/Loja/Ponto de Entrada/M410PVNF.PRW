#Include "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ M410PVNF   ¦ Autor ¦ Arlindo Vieira       ¦ Data ¦ 02/04/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada de validação da geração da nota de saida     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function M410PVNF()
	Local cQry
	Local cAlias  := Alias()
	Local lRet    := .T.

	/*
	If !empty(SC5->C5_XORCRES) .And. !empty(SC5->C5_XFILRES)

	cQry:=" SELECT COUNT(*) AS QTDREG "
	cQry+=" FROM "+RetSQLName("SC9")+" SC9 "
	cQry+=" INNER JOIN "+RetSQLName("SC5")+" SC5 ON SC5.D_E_L_E_T_ = ' ' AND SC9.C9_FILIAL = SC5.C5_FILIAL AND SC9.C9_PEDIDO = SC5.C5_NUM "
	cQry+=" AND SC5.C5_TIPO = 'N' "
	cQry+=" INNER JOIN "+RetSQLName("SC6")+" SC6 ON SC6.D_E_L_E_T_ = ' ' AND SC9.C9_FILIAL = SC6.C6_FILIAL AND SC9.C9_PEDIDO = SC6.C6_NUM "
	cQry+=" AND SC9.C9_ITEM = SC6.C6_ITEM AND SC9.C9_PRODUTO = SC6.C6_PRODUTO "
	cQry+=" WHERE SC9.D_E_L_E_T_ = ' ' AND SC9.C9_QTDLIB <> SC6.C6_QTDVEN "
	cQry+=" AND SC9.C9_FILIAL = '"+xFilial("SC5")+"' "
	cQry+=" AND SC5.C5_NUM='"+SC5->C5_NUM+"' "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRB",.T.,.T.)

	If (TRB->QTDREG > 0)
	Alert("Não é permitido faturamento parcial de nota fiscal de vendas com reserva!")
	lRet := .F.
	Endif
	dbCloseArea()
	dbSelectArea(cAlias)
	EndIf

	//Verifica se é uma nota de reserva
	If SC5->C5_ORCRES <> '' .And. lRet

	//Seleciona a nota fiscal e a serie da nota fiscal de transferencia
	cQry :=" SELECT SC9.C9_NFISCAL AS NFISCAL,SC9.C9_SERIENF AS SERIENF "
	cQry +="				FROM "+RetSQLName("SC5")+" SC5 "
	cQry +=" INNER JOIN "+RetSQLName("SC9")+" SC9 ON SC9.C9_PEDIDO=SC5.C5_NUM AND SC9.D_E_L_E_T_=''  "
	cQry +=" WHERE SC5.C5_XFILRES='"+xFilial("SC9")+"' AND SC5.C5_XORCRES= "
	cQry +=" (SELECT SL1.L1_ORCRES FROM "+RetSQLName("SL1")+" SL1 WHERE SL1.L1_NUM= "
	cQry +=" (SELECT SC5.C5_ORCRES FROM "+RetSQLName("SC5")+" SC5 WHERE SC5.C5_FILIAL='"+xFilial("SC5")+"' "
	cQry+="  AND SC5.C5_NUM='"+SC5->C5_NUM+"' AND SC5.D_E_L_E_T_='') "
	cQry +=" AND SL1.D_E_L_E_T_='') "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRS",.T.,.T.)

	SD1->(DbSetorder(1))
	SD1->(DbSeek(xFilial("SD1")+TRS->NFISCAL+TRS->SERIENF))
	While !SD1->(EOF()) .And. SD1->(D1_FILIAL+D1_DOC+D1_SERIE) == xFilial("SD1")+TRS->(NFISCAL+SERIENF) .And. lRet
	//Verifica se a nota tem classificação
	If(empty(SD1->D1_TES))
	Alert("Por favor primeiro classificar a nota de transferencia! "+TRS->NFISCAL)
	lRet:=.F.
	Endif
	SD1->(DBskip())
	Enddo
	dbCloseArea()
	Endif
	*/
	dbSelectArea(cAlias)
Return lRet
