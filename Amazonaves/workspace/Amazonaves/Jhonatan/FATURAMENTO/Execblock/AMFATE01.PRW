#Include "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ AMFATE01   ¦ Autor ¦ Jhonatan S. Lobato   ¦ Data ¦ 06/06/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar campo quantidade inteiro se a Unid. contem MV_XESP01  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function AMFATE01()

Local lRet    := .T.
Local cQuery  := ""
Local aArea   := GetArea()
Local cQuant  := 0

    cQuery := " SELECT B1_COD AS PROD, B1_UM AS UM"
	cQuery += " FROM "+RetSQLName("SB1")
	cQuery += " WHERE "
	cQuery += " 	D_E_L_E_T_ = '' "
	cQuery += " AND B1_COD = '"+CK_PRODUTO+"'"
   	cQuery += " AND B1_FILIAL = '"+xFilial("SB1")+"'"
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"QTDVEN",.F.,.T.)

    If !QTDVEN->(EOF()) .AND. Trim(QTDVEN->UM) $ GetMV("MV_XESP01")
        cQuant += CK_QTDVEN
            IF Int(cQuant) <> cQuant
                lRet := .F.
                MsgInfo("Por favor, insira um numero inteiro.", "Erro de Validacao")
	        Else
	            lRet := .T.
	        EndIf
    EndIf        

    QTDVEN->(DbCloseArea())

    RestArea(aArea)

Return(lRet)



