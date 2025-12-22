#Include 'Protheus.ch'
#include 'totvs.ch'


/*
Execblock para validar a alteração do campo B1_FATOR quando houver produção aberto ou saldo a endereçar 

*/
User Function AACOME04()
Local lRet := .T.
Local cQry := ""

cQry+=" SELECT C2_PRODUTO "
cQry+=" FROM "+RetSQLName("SC2")+" (NOLOCK) SC2 						"
cQry+=" WHERE "
cQry+=" SC2.D_E_L_E_T_ = '' "
cQry+=" AND C2_QUJE < C2_QUANT AND C2_DATRF='' " 
cQry+=" AND C2_PRODUTO='"+M->B1_COD+"'"
dbUseArea(.T., "TOPCONN", tcGenQry(,,cQry), "QRY" , .T., .T.)

cQry := ""

cQry+=" SELECT DA_PRODUTO FROM "+RetSQLName("SDA")+" (NOLOCK) SDA "
cQry+=" WHERE D_E_L_E_T_='' "
cQry+=" AND SDA.DA_PRODUTO='"+M->B1_COD+"' "
cQry+=" AND SDA.DA_SALDO>0"
dbUseArea(.T., "TOPCONN", tcGenQry(,,cQry), "QRY2" , .T., .T.)

lRet :=(QRY2->(Eof()) .And. QRY->(Eof())) 
QRY2->(DbCloseArea())
QRY->(DbCloseArea()) 
Return lRet