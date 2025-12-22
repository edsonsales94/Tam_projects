#Include "Rwmake.ch"

/*___________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Função    ¦ MT250TOk   ¦ WERMESON GADELHA DO CANTO    ¦ Data ¦ 23/09/2009             ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada para validar no apontamento de producao para verificar   ¦¦¦
¦¦¦ (cont)    ¦ se existe saldo suficiente.                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------------------+¦¦
¦¦¦ Retorno   ¦ .T. ou .F.                                                                ¦¦¦
¦¦+-----------+---------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/    

User Function MT250TOK()
 Local lRet := ParamIXB
  
  //lRet := u_PLESTE06(M->D3_OP, M->D3_EMISSAO)
  
/*  If lRet 
    SC2->(dbSetOrder(1))
 	If SC2->(dbSeek (xFilial("SC2") + M->D3_OP ) )
 		If (M->D3_QUANT > (SC2->C2_QUANT - SC2->C2_QUJE) )
 			lRet := .F.
 			MsgStop("Não pode ser realizado apontamento maior que o Saldo da OP!")
 		EndIf 
 	EndIf 
     //lRet := u_fwTelPr0(1) 
  EndIf   */

  //If lRet
     //u_AAPCPW01(M->D3_OP,M->D3_QUANT) 
  //EndIf
  
  If lRet
  	SC2->(dbSetOrder(1))
 	If SC2->(dbSeek (xFilial("SC2") + M->D3_OP ) ) .And. !Empty(SC2->C2_RECURSO)
 			fwQrySD4(M->D3_OP)
 			If !(TMP1->(Eof())) .aND. !Empty(TMP1->H1_XENDE)
 				fwDelSDC(M->D3_OP)
 				
 				While !(TMP1->(Eof())) .And. lRet
 					fwValidaBF(TMP1->D4_COD, TMP1->D4_LOCAL, TMP1->H1_XENDE)
 					
 					If GetMv("MV_XVALMAQ") .AND. TMP2->BF_QUANT < TMP1->D4_QTDEORI * (M->D3_QUANT / SC2->C2_QUANT)
 						lRet := .F.
 					EndIf 
 					
 					TMP2->(dbCloseArea())
 					
 					If lRet
	 						Reclock("SDC", .T.)
	 							SDC->DC_FILIAL  := xFilial("SDC")
		 						SDC->DC_ORIGEM  := "SD3" 
		 						SDC->DC_PRODUTO := TMP1->D4_COD
		 						SDC->DC_LOCAL   := TMP1->D4_LOCAL
		 						SDC->DC_LOCALIZ := TMP1->H1_XENDE
		 						SDC->DC_QUANT	:= TMP1->D4_QUANT
		 						SDC->DC_OP  	:= TMP1->D4_OP 
		 						SDC->DC_TRT   	:= TMP1->D4_TRT
		 						SDC->DC_QTDORIG := TMP1->D4_QTDEORI	 
		 						SDC->DC_QTSEGUM	:= TMP1->D4_QTSEGUM 
	 						MsUnlock()
	 					Else 
	 						MsgStop("O produto " + Alltrim(TMP1->D4_COD) + " nao tem saldo suficiente no endereco " +TMP1->H1_XENDE +"!" )
 					EndIf 
 					TMP1->(dbSkip())
 				End 
 			EndIf
 			
 			TMP1->(dbCloseArea())
		
 	EndIf  
 	
  EndIf 
  
Return lRet     

Static Function fwQrySD4(cwOP)
  Local cQry := ""

  cQry += " SELECT D4_COD, D4_LOCAL, D4_QUANT, D4_QTDEORI, D4_OP, D4_TRT, D4_QTSEGUM, H1_XENDE "
  cQry += "   FROM SD4010 AS SD4 (NOLOCK) "
  cQry += "  INNER JOIN SC2010 AS SC2 ON SC2.D_E_L_E_T_ = '' AND C2_NUM = LEFT(D4_OP, 6) AND C2_ITEM = SUBSTRING(D4_OP, 7, 2) AND C2_SEQUEN = SUBSTRING(D4_OP, 9, 3) "
  cQry += "  INNER JOIN SH1010 AS SH1 ON SH1.D_E_L_E_T_ = '' AND H1_CODIGO = C2_RECURSO "
 
  cQry += "  WHERE SD4.D_E_L_E_T_ = '' "
  cQry += "    AND SD4.D4_OP  = '" + cwOp  +"' "
  cQry += "    AND SD4.D4_QUANT  > 0 "
  cQry += "  Order by SD4.D4_COD DESC " 
  
  
  dbUseArea(.T.,"TOPCONN",TcGenQry(,,(cQry)),"TMP1",.T.,.T.)
                                           
Return Nil 

Static Function fwValidaBF(cwCod, cwLoc, cwEnd  )

  Local cQry := ""

  cQry += " SELECT ISNULL(SUM(BF_QUANT), 0) AS BF_QUANT "
  cQry += "   FROM SBF010 AS SBF (NOLOCK) "
  cQry += "  WHERE SBF.D_E_L_E_T_ = '' "
  cQry += "    AND SBF.BF_PRODUTO  = '" + cwCod  +"' "
  cQry += "    AND SBF.BF_LOCAL    = '" + cwLoc  +"' "
  cQry += "    AND SBF.BF_LOCALIZ  = '" + cwEnd  +"' "  
  cQry += "    AND SBF.BF_QUANT   <> 0 "
  
  dbUseArea(.T.,"TOPCONN",TcGenQry(,,(cQry)),"TMP2",.T.,.T.)
                                           
Return Nil 

Static Function fwDelSDC(cwOp)
 Local cSql := ""

 cSql := "Update SDC010 SET D_E_L_E_T_ = '*' "
 cSql +=  " FROM SDC010 (NOLOCK)"
 cSql += " WHERE DC_FILIAL = '"+xFilial("SDC")+"' "
 cSql +=   " AND DC_OP = '"+cwOp+"' "

 TcSqlExec(cSql)

Return Nil 
