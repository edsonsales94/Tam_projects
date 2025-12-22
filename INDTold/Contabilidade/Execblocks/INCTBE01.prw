#INCLUDE "rwmake.ch"


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ INCTBE01   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 02/04/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ ExecBlock para validação do campo CTD_XNKID                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/          
User Function INCTBE01(cNokiaID)
   Local cAlias := Alias()
   Local cQry   := ""
   Local lRet   := .F.

   cQry := " SELECT * FROM " + RetSqlName("CTD") + " AS CTD "
   cQry += " WHERE CTD.D_E_L_E_T_ <> '*' "
   cQry += " AND CTD_XNKID = '" +cNokiaID+ "'  "

   dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"YYY",.T.,.T.)
   lRet := YYY->(EOF())
   YYY->(dbCloseArea())
   dbSelectArea(cAlias)

Return lRet 
