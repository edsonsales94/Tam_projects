#include "rwmake.ch"                                          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ INFATE01 บAutor  ณ Reinaldo Magalhaes บ Data ณ  24/09/07    บฑฑ
ฑฑฬออออออออออุออออออออออสออออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao automatica do codigo do cliente                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Indt                                             บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function INFATE01

Local cCod   := Space(6)
Local cAlias := Select()

cCod := UltimoCliente()
dbSelectArea(cAlias)

Return(cCod)
//
//
//
Static Function UltimoCliente
//  .----------------------------------------------------------------------.
// |     Parametro para definir os "buracos" entre o codigo do cliente.     |
//  '----------------------------------------------------------------------'
Local nSalta:= GetMv("MV_SALTCLI")

Local cQuery,cMaxCli
//  .--------------------------------------------------------.
// |     Verificando a ultima sequencia do rateio gravada     |
//  '--------------------------------------------------------'
cQuery:= "SELECT ISNULL(MAX(A1_COD),0) CONTA FROM "+RetSQLName("SA1")+" WHERE D_E_L_E_T_=' ' AND "
cQuery+= "A1_FILIAL='" + xFilial("SA1") + "'"

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "YYY", .T., .F. )

cMaxCli:= StrZero(Val(CONTA)+nSalta,6)

dbCloseArea()

Return cMaxCli
