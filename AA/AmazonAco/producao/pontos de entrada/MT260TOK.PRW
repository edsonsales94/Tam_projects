//-------------------------------------------------------.  
// Declaração das bibliotecas utilizadas no programa      |
//-------------------------------------------------------' 
#include "rwmake.ch"
#include "Protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MT260TOK    ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 23/06/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validacao das datas nas telas do D3_EMISSAO.                  ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MT260TOK()
Local lRet := .T.

//cLoclzOrig,cLoclzDest

	If CLOCDEST == GetMv("MV_LOCPROC")

	     If Alltrim(cLoclzDest) <> "CDOBRA" 

			cQry := ""
			cQry += " SELECT C2_RECURSO, D4_COD  "
			cQry +=   " FROM SC2010 AS SC2 (NOLOCK) "
			cQry +=  " INNER JOIN SD4010 AS SD4 (NOLOCK) ON SD4.D_E_L_E_T_ = '' AND SD4.D4_OP     = SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN "
			cQry +=  " INNER JOIN SH1010 AS SH1 (NOLOCK) ON SH1.D_E_L_E_T_ = '' AND SH1.H1_CODIGO = SC2.C2_RECURSO "
			cQry +=  " WHERE SC2.D_E_L_E_T_ = '' AND C2_DATRF = '' AND H1_XENDE = '" + cLoclzDest + "' "
			//cQry +=    " AND C2_STATUS <> 'U' AND C2_QUJE > 0 AND D4_COD = '" + cCodDest + "' " Alterado Williams Messa, desconsiderar a Qtd Produziada??
			cQry +=    " AND C2_STATUS <> 'U' AND D4_COD = '" + cCodDest + "' "
			
			dbUseArea(.T., "TOPCONN",TCGENQRY(,,cQry),"TRB1",.F.,.T.)
			
			If TRB1->(Eof())
				lRet := .F.
				MsgStop(" Não há empenho para o produto " +TRB1->D4_COD+ " na maquina " + TRB1->C2_RECURSO + " !" )
				lMsErroAuto := .T.
			EndIf 
					
			TRB1->(dbCloseArea())
			
			/*
			If lRet
				//Alterado por Williams Messa 26/07/19................................
				//EEE
				cQry2 := " SELECT B1_XCTLCOR, ISNULL(SUM(BF_QUANT),0) BF_QUANT FROM SBF010 SBF "
				cQry2 += " INNER JOIN SB1010 SB1 ON B1_COD = BF_PRODUTO AND SB1.D_E_L_E_T_='' "
				cQry2 += " WHERE BF_LOCAL='" + cLocDest + "' AND  BF_LOCALIZ='" + cLoclzDest + "' AND  BF_PRODUTO='"+cCodDest+"' AND SBF.D_E_L_E_T_='' " 
				cQry2 += " GROUP BY B1_XCTLCOR "

				dbUseArea(.T., "TOPCONN",TCGENQRY(,,cQry2),"TRB2",.F.,.T.)

				//If !TRB2->(Eof())
					CONOUT("VAI ENTRAR SE O PRODUTO--->>> " + TRB2-> B1_XCTLCOR)
					If TRB2-> B1_XCTLCOR == "S"
						conout(cLocDest + cLoclzDest + cCodDest + str(TRB2->BF_QUANT) +"  ---ENTROU!!")
						If TRB2->BF_QUANT > 0
							lRet := .F.
							MsgStop(" O saldo deve estar zerado antes do pagamento!" )
							lMsErroAuto := .T.
						EndIf 
					EndIf
				//EndIf
				TRB2->(dbCloseArea())
				//Alterado por Williams Messa, 26/07/19
				//SBF->(dbSetOrder(1))
				//If SBF->(dbSeek(xFilial("SBF") + cLocDest + cLoclzDest + cCodDest )) .and. SB1->B1_XCTLCOR == "S"
					
					//conout(cLocDest + cLoclzDest + cCodDest + SBF->BF_PRODUTO+str(SBF->BF_QUANT)+ "entrou 1" )
					//If SBF->BF_QUANT > 0
					//	lRet := .F.
					//	MsgStop(" O saldo deve estar zerado antes do pagamento!" )
					//	lMsErroAuto := .T.
					//	conout(cLocDest + cLoclzDest + cCodDest + SBF->BF_PRODUTO+str(SBF->BF_QUANT))
					//EndIf 
					
				//EndIf 
			EndIf 
			*/
		EndIf
	
	EndIf 



Return lRet

/*********************************************************************************** 
*       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   *
*      AAAA       LL         LL         EE         CC        KK    KK   SS         *
*     AA  AA      LL         LL         EE        CC         KK  KK     SS         *
*    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   *
*   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  *
*  AA        AA   LL         LL         EE         CC        KK    KK          SS  *
* AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   * 
************************************************************************************
*         I want to change the world, but nobody gives me the source code!         * 
************************************************************************************/