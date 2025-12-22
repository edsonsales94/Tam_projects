#include "Protheus.ch"  
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ A250ITOK    ¦ WLADIMIR VIEIRA              ¦ Data ¦  13/2019  ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada para Apontamento de Producao controle de lote ¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ (Cont.)   ¦ de entrada.                                                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+a
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function A250ITOK()
	local _mLote  
	local _mCtrl := "N"

//	local _XGrpcor := SuperGetMv("MV_XGRPCOR",.F.,.F.)    // PARAMETRO GRUPO DE PRODUTOS QUE CONTROLAM CORRIDAS
	//    alert("entrei a250itok")
	// verifica se controla corrida
    
	If SuperGetMv("MV_XCORRI",.F.,.F.) 

		_mNumOP  := M->D3_OP                                                                      // Num Op
		// Procura produto com controle de corrida
		dbSelectArea("SD4")
		dbSetOrder(2)
		dbSeek(xFIlial("SD4")+_mNumOP)
		While !eof() .and. D4_OP == _mNumOP
		
		//_mProd   := Posicione("SD4",2,xFIlial("SD4")+_mNumOP,"D4_COD")                             // Mat Prima
		
		      _mCtrl   := Posicione("SB1",1,xFIlial("SB1")+SD4->D4_COD,"B1_XCTLCOR")                          // Verifica se controla corrida do produto
			  
		      If _mCtrl == "S"
		         _mProd := SD4->D4_COD
		         EXIT
		      Endif
		      dbSkip()
		
		Enddo
		
		
//		_mGrupo  := TRIM(Posicione("SB1",1,xFIlial("SB1")+_mProd,"B1_GRUPO"))                          // Grupo de produtos
//		_mCtrl   := Posicione("SB1",1,xFIlial("SB1")+_mProd,"B1_XCTLCOR")                          // Verifica se controla corrida do produto

		_mSaldo  := 0

//		If  _mGrupo $ _XGrpcor
			// Se controlar corrida pela o lote
			If _mCtrl == "S"
				/*
				cQry := ""
				cQry += "SELECT Min(B8_LOTECTL) AS _MLOTE "
				cQry += "From SB8010 "
				cQry += "WHERE D_E_L_E_T_ = '' "
				cQry += "AND B8_FILIAL = '"+xFilial("SB8")+"' "
				cQry += "AND B8_SALDO > 0 "
				cQry += "AND B8_PRODUTO = '"+_mProd+"' "
				*/
				//Alterado por Williams Messa 31/07/19, mesma validação criada no Programa AAPCP02 para capturar o lote da Corrida.(Padronização)
				cQry := ""
				cQry += "SELECT BF_LOTECTL AS BF_LOTECTL "
				cQry += "FROM SBF010 "
				cQry += "WHERE D_E_L_E_T_ = '' "
				cQry += "AND BF_FILIAL = '"+xFilial("SBF")+"' "
				cQry += "AND BF_QUANT > 0  AND BF_LOCAL= '03' "
				cQry += "AND BF_PRODUTO = '"+_mProd+"' "

				dbUseArea(.T., "TOPCONN",TCGENQRY(,,cQry),"TRB1",.F.,.T.)

				ConOut("Irá gravar....com o Lote Correto. - A250ITOK")
				M->D3_LOTECTL := TRB1->BF_LOTECTL
				Memowrite("A250ITOK.SQL",cQry)
				dbCloseArea("TRB1")
			Endif
//		Endif
	Endif



Return .t.