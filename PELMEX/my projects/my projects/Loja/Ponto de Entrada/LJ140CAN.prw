#INCLUDE "rwmake.ch"
/*_____________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+-------¦¦
¦¦¦ Programa  ¦LJ140CAN    ¦ Autor ¦ Adson Carlos 	       ¦ Data ¦ 11/09/2012 ¦       ¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+-------¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada verficar se usuario pode Excluir Notas ou Cupom      ¦¦
¦¦+-----------+---------------------------------------------------------------+-------¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function LJ140CAN
Local lRet := .T.
Local lOk

If nModulo == 12
	lRet := fValida()
	
	If !lRet
		Alert("Existe(m) nota(s) fiscal(ais) emitida(s) para este orcamento. Favor cancelá-las primeiro.")
	EndIf
Endif

Return(lRet)

Static Function fValida()
Local _Ret := .F.

Local cAlias := Alias()
Local cQry   := ""

cQry := "SELECT F2_DOC, F2_SERIE"
cQry += " FROM "+RetSQLName("SF2")
cQry += " WHERE D_E_L_E_T_ = ' '"
cQry += " AND F2_XORCRES = '"+SL1->L1_NUM+"'"
cQry += " AND F2_XFILRES = '"+SL1->L1_FILIAL+"'"

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "PEDRES", .T., .F. )

If EOF() .AND. BOF()
	DbCloseArea()
	Return .T.
Endif

dbCloseArea()
dbSelectArea(cAlias)

Return .F.
