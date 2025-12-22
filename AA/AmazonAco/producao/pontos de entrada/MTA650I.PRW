#include "Protheus.ch"

/*___________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Função    ¦ MTA650I    ¦                              ¦ Data ¦ 23/09/2009             ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada Inserir Historico do Pedido de Vendas caso a OP seja     ¦¦¦
¦¦¦ (cont)    ¦ Referente a algum PV existente, informando a Inclusao do mesmo            ¦¦¦
¦¦+-----------+---------------------------------------------------------------------------+¦¦
¦¦¦ Retorno   ¦ Nil                                                                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/    


//User Function MTA650A()
//Return u_MTA650I()
User Function MTA650I()
	//Historico

	_xdMap := SuperGetMv("MV_XINTMAP",.F.,"N")
	/*
	If _xdMap == "S"
		If SC2->C2_STATUS != 'U'
			u_MTA650A0(01)
		Else
			u_MTA650A0(00)
		EndIf			
	EndIf
    */
    
	aDados := {}
	aAdd(aDados,{'Z5_PEDIDO' ,SC2->C2_XPEDIDO})
	aAdd(aDados,{'Z5_PRODUTO',SC2->C2_PRODUTO})
	aAdd(aDados,{'Z5_DATA'   ,dDataBase})
	aAdd(aDados,{'Z5_HORA'   ,SubStr(Time(),1,5)})
	aAdd(aDados,{'Z5_USER'   ,cUserName})
	aAdd(aDados,{'Z5_OP'     ,SC2->(C2_NUM + C2_ITEM + C2_SEQUEN)})
	aAdd(aDados,{'Z5_OBS'    ,If(SC2->C2_QUJE == SC2->C2_QUANT,"PRODUZIDO", "EM PRODUCAO") })
	aAdd(aDados,{'Z5_STATUS' ,If(SC2->C2_QUJE == SC2->C2_QUANT,"3", "2")})
	aAdd(aDados,{'Z5_ENTREGA',STOD('  /  /  ')}  )

	If ExistBlock("AALOGE02")
		u_AALOGE02(aDados)
	EndIf

	If ExistBlock("AAMAIL02")
		u_AAMAIL02("Produdo em Producao")
	EndIf


	//Fim Historico
Return Nil




/*powered by DXRCOVRB*/