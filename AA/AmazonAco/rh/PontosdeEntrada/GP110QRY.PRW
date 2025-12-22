/*_________________________________________________________________
¦ Função    ¦ GP110QRY   ¦ Leirene Araujo    ¦ Data ¦ 10/03/2016   ¦
+-----------+------------+-------------------+------+--------------+
¦ Descriçäo ¦ Ponto de entrada para disponibilizar campos          ¦
¦           ¦ na contabilizacao da folha                           ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
#Include "rwmake.ch"

User Function GP110QRY() 
  Local aCpos := {}                                         
  
  aAdd( aCpos, { "SRV", { "RV_COD", "RV_DESC", "RV_XDIRETO", "RV_XINDIRE", "RV_XADMMAT", "RV_XADMFIL", "RV_XVENMAT", "RV_XVENFIL" } } ) 
  aAdd( aCpos, { "CTT", { "CTT_CUSTO", "CTT_DESC01", "CTT_DTEXIS" } } ) 
Return aCpos 