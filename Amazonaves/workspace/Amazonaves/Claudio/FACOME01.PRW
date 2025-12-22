#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FACOME01   ¦ Autor ¦ Marcel R. Grosselli  ¦ Data ¦ 02/09/2021 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Execblock para calcular o proximo numero cadastro de produtos ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function FACOME01(cGrupo)
Local cQry    := ""
Local _SB1    := RetSqlName("SB1")
Local cAliasT := Alias() 
Local nSeq    := 0
Local cRet    := ""

cQry := " SELECT MAX(SB1.B1_COD) B1_COD"
cQry += " FROM "+_SB1+" SB1"
cQry += " WHERE SB1.D_E_L_E_T_ = ' ' "
cQry += " AND B1_GRUPO = '"+cGrupo+"'"
cQry += " AND B1_FILIAL = '"+XFILIAL("SB1")+"'"

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TMP", .T., .F. )
dbSelectArea("TMP")

nSeq := AllTrim(TMP->B1_COD)  
dbCloseArea("TMP")

IF LEN(ALLTRIM(nSeq))<8
    cRet:= cGrupo+"0001"
Else
    cRet := SOMA1(nSeq,8)
Endif

dbSelectArea(cAliasT)

Return cRet
