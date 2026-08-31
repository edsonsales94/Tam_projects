#include "Protheus.ch"   

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ PMLOJE03   ¦ Autor ¦ Marcel R. Groselli   ¦ Data ¦ 30/04/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descrição ¦ Rotina para validar cliente padrão nos estados AM e PA        ¦¦¦ 
¦¦¦ Descr  ¦ Utilizado pela rotina de Venda Assistida no campo LÇQ_CLIENTE    ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function PMLOJE03()

	Local lRet 	   := .T.
	Local cCliente := M->LQ_CLIENTE
	Local cEst     := SM0->M0_ESTCOB

	if cEst == "PA" .and. cCliente =="001041"
		alert("Cliente Padrão inválido, utilize o Código 003067" )
		lRet := .F.

	elseif cEst == "AM" .and. cCliente =="003067"
		alert("Cliente Padrão inválido, utilize o Código 001041" )
		lRet := .F.

	endif

return lRet
