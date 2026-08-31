#include "rwmake.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ LJ7002     ¦ Autor ¦ ADSON CARLOS	       ¦ Data ¦ 22/03/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada de finalizacao da Venda                      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function LJ7002()
	QOUT("LJ7002 PASSEI AQUI")	
	If ParamIXB[1] == 1     // Se gravação do orçamento
	
	ElseIf ParamIXB[1] == 2 // Se for finalização de venda
		QOUT("LJ7002 PASSEI AQUI2")
		// Se tiver executando da rotina de subida das vendas do PAF
		If FunName() <> "LOJA701" .And. (SL1->L1_XRES == "1" .OR. SL1->L1_XCD=="1")  // Se gera pedido de transferência    
			QOUT("LJ7002 PASSEI AQUI21")
			u_PMLOJE02()   // Processa a geração do pedido de transferência
		Endif
	Elseif ParamIXB[1] == 3 .And. (SL1->L1_XRES == "1" .OR. SL1->L1_XCD=="1") // Se for Pedido (reserva)    
		QOUT("LJ7002 PASSEI AQUI3")
		u_PMLOJE02()

	Endif        
	

Return