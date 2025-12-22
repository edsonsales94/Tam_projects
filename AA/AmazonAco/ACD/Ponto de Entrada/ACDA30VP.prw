#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"


User Function ACDA30VP()
Local lRet := .T.
Local cQry :=""
Local cQryAlias := "QRY" 


cQry+= " SELECT * FROM "+RetSQLName("CB0")+" CB0 "
cQry+= " WHERE CB0.D_E_L_E_T_='' "
cQry+= " AND CB0_CODPRO='"+SB1->B1_COD+"' "
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cQryAlias,.T.,.T.)

lRet:=!(cQryAlias)->(Eof())
(cQryAlias)->(DbCloseArea(cQryAlias))
Return lRet





