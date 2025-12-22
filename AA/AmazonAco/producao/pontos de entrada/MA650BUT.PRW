#include "Protheus.ch"
#include "rwmake.ch"

User Function MA650BUT()

aAdd(aRotina,{"Data Prevista ","u_AALOGE2B",0, 2, 0, nil}) 	//"Reprioriza"

//Não declarar o array aRotina
//Adiciona um novo item no menu principal do MATA650

aAdd(aRotina,{'ORDEM DE CORTE - EXC','U__ExcOPCort()',0,5 })

Return aRotina

/*/
_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ _ExcOPCort  ¦ Autor ¦ Wladimir Vieria     ¦ Data ¦ 07/12/20181¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Excluir OP de corte                                           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function _ExcOPCort()


    If Empty(C2_XCORTE)
       _mMsg := MsgBox("ATENÇÃO! Esta não é uma OP de Corte, por isso não poderá ser excluida por essa Opção ","Exclusão Ordem de Produção","ALERT" ) 
		Return
    Endif

	lContinue := .T.
	_mMsg := MsgBox("ATENÇÃO! Será excluída a OP: "+SC2->C2_NUM,"Exclusão Ordem de Produção","YESNO" )
	If !_mMsg 
		Return
	Endif


	If Reclock("SC2")
		dbDelete()
	Endif

Return 
