#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
/*/{protheus.doc}MT160OK
Ponto de entrada na confirmacao da cotacao de compras
@author Honda Lock
/*/

User Function MT160OK()

  M->C8_USER := USRRETNAME(RETCODUSR())
  
 Return(.T.)