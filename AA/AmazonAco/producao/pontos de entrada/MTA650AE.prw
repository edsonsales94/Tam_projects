#include "Protheus.ch"

/*___________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Função    ¦ MTA650AE   ¦                              ¦ Data ¦ 23/09/2009             ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada Inserir Historico do Pedido de Vendas caso a OP seja     ¦¦¦
¦¦¦ (cont)    ¦ Referente a algum PV existente, informando a exclusao do mesmo            ¦¦¦
¦¦+-----------+---------------------------------------------------------------------------+¦¦
¦¦¦ Retorno   ¦ Nil                                                                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/    


User Function MTA650AE()
   Local _cdNumOp := alltrim(PARAMIXB[01]+PARAMIXB[02]+PARAMIXB[03])
   
   SZ5->(dbSetORder(2))
   //alert( xFilial('SZ5') + _cdNumOp )
   //ALERT(SZ5->(dBSeek( xFilial('SZ5') + _cdNumOp)))
   If SZ5->(dBSeek(xFilial('SZ5') + _cdNumOp))
      aDados := {}
      aAdd(aDados,{'Z5_PEDIDO' ,SZ5->Z5_PEDIDO})
	  aAdd(aDados,{'Z5_PRODUTO',SZ5->Z5_PRODUTO})
	  aAdd(aDados,{'Z5_DATA'   ,dDataBase})
	  aAdd(aDados,{'Z5_HORA'   ,SubStr(Time(),1,5)})
	  aAdd(aDados,{'Z5_USER'   ,cUserName})
	  aAdd(aDados,{'Z5_OP'     ,_cdNumOp})
	  aAdd(aDados,{'Z5_OBS'    ,"EXCLUSAO DE PRODUCAO"})
	  aAdd(aDados,{'Z5_STATUS' ,GetLastSt(SZ5->Z5_PEDIDO, SZ5->Z5_PRODUTO) })
	  aAdd(aDados,{'Z5_ENTREGA',STOD('  /  /  ')})
      
      If ExistBlock("AALOGE02")
	     u_AALOGE02(aDados)
	  EndIf
      
   EndIf
Return Nil

Static Function GetLastSt(_cPed,_cProd)

    Local _cQry  := ""
    Local cTable := GetNextAlias()
    LOCAL _cdStatus := ""
    
    _cQry += " Select MAX(R_E_C_N_O_) Z5_RECNO from " + RetSqlName("SZ5") 
    _cQry += " Where D_E_L_E_T_ = ''
    _cQry += " And Z5_PEDIDO  = '" + _cPed  + "'"
    _cQry += " And Z5_PRODUTO = '" + _cProd + "'"
    _cQry += " And Z5_STATUS != '2'
    
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),cTable,.T.,.T.)
        SZ5->(dbGoto(  (cTable)->Z5_RECNO ))
       _cdStatus := SZ5->Z5_STATUS
    (cTable)->(dbCloseArea(cTable))

Return _cdStatus




/*powered by DXRCOVRB*/