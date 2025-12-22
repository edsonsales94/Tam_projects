/*_________________________________________________________________
¦ Função    ¦ GP670ARR  ¦ Leirene Araujo    ¦ Data ¦ 14/05/2014   ¦
+-----------+------------+-------------------+------+--------------+
¦ Descriçäo ¦ Ponto de entrada para atualizar o historico (e2_hist)¦
¦           ¦ na integracao do titulo com o financeiro.            ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
#Include "rwmake.ch"

User Function GP670ARR() 
  Local aRet := {}

  aaDD(aRet,{"E2_HIST"	, RC1->RC1_DESCRI	,   Nil})
Return aRet