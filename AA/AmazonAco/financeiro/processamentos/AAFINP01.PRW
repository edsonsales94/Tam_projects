#include "protheus.ch"
//---------------------------------------------------------------------------------------------------------//
// Programa para preenchimento de commissão referente as vendas com reserva geradas financeiro na Industria//
//---------------------------------------------------------------------------------------------------------//
// Autor: Marcel R. Grosselli     data: 31/05/11                                                           //
//---------------------------------------------------------------------------------------------------------//

user function AAFINP01() 

Local cQry      := ""
Local cTable    := GetNextALias()
Local _adARea   := getArea()
Local _cPerg    := Padr("AAFINP01",Len(SX1->X1_GRUPO))

ValidPerg(_cPerg)
Pergunte(_cPerg)

cQry += " SELECT SE1.E1_PREFIXO, SE1.E1_NUM, E1_TIPO, SE1.E1_CLIENTE, SE1.E1_VEND1, SE1.E1_LOJA, SE1.E1_EMISSAO, SUM(E1_VALOR) BASE, SUM(E1_VALOR)*0.20/100 COMISSAO  FROM" + RetSqlName("SE1") + "  SE1"
cQry += " WHERE D_E_L_E_T_ = ''"
cQry += " AND SE1.E1_VEND1 = '"+MV_par01+"'"
cQry += " AND SE1.E1_EMISSAO BETWEEN '"+Dtos(MV_par02)+"' AND '"+Dtos(MV_par03)+"'"
cQry += " AND SE1.E1_TIPO NOT IN('R$','CC','CD','FI','CH','RE','NCC','CR') "
cQry += " AND SE1.E1_SERIE <> '6' AND SE1.E1_SERIE <> 'A01'"
cQry += " GROUP BY SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_TIPO, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_EMISSAO, SE1.E1_VEND1"
cQry += " ORDER BY SE1.E1_PREFIXO, SE1.E1_NUM"

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), cTable, .T., .F. )
TCSETFIELD(cTable,"E1_EMISSAO","D",8,0)
dbSelectArea(cTable)
dbGoTop()

while !(cTable)->(EOF())
	SE3->(RecLock('SE3',.T.))      
	SE3->E3_VEND = (cTable)->E1_VEND1
	SE3->E3_NUM = (cTable)->E1_NUM
	SE3->E3_EMISSAO = (cTable)->E1_EMISSAO
	SE3->E3_SERIE = (cTable)->E1_PREFIXO
	SE3->E3_CODCLI = (cTable)->E1_CLIENTE
	SE3->E3_LOJA = (cTable)->E1_LOJA
	SE3->E3_BASE = (cTable)->BASE
	SE3->E3_PORC = 0.20
	SE3->E3_COMIS = (cTable)->COMISSAO
	SE3->E3_PREFIXO = (cTable)->E1_PREFIXO
	SE3->E3_TIPO = (cTable)->E1_TIPO
	SE3->E3_BAIEMI = "E"
	SE3->(MSUNLOCK())
(cTable)->(dbSKip())
EndDo

return

Static Function ValidPerg(cPerg)

PutSX1(cPerg,"01",PADR("Vendedor           ?" ,29),PADR("Vendedor           ?" ,29),PADR("Vendedor            ?"   ,29),"mv_ch1","C",06,0,0,"G","","" ,""   ,"","","mv_par01")
PutSX1(cPerg,"02","Da Data"         ,"Da Data"         ,"Da Data"         ,"mv_ch2","D",8,0,0,"G","","","","","mv_par02")
PutSX1(cPerg,"03","Ate Data"        ,"Ate Data"        ,"Ate Data"        ,"mv_ch3","D",8,0,0,"G","","","","","mv_par03")

Return






