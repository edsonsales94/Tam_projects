#include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MT241TOK   ¦ Autor ¦ Adson Carlos 		    ¦ Data ¦ 11/01/2010 ¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada usado para validação do produto na D4.        ¦¦¦
|||           | ROTINA INTERNOS												   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MT241TOK()  
Local cRet:= ""
Return (FunName() == "AAESTA01" .Or. U_fw_VerSD3(1, len(aCols)))

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fw_VerSD3  ¦ Autor ¦ Adson Carlos 		    ¦ Data ¦ 11/01/2010 ¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ validação do produto na ROTINA INTERNOS                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function fw_VerSD3(nIni, nFim)
Local lRet     := .T. //.T.
Local nPosOP   := Ascan(aHeader,{|x| Trim(x[2]) == "D3_OP"   }) //aCols[1,1]
Local nPosPN   := Ascan(aHeader,{|x| Trim(x[2]) == "D3_COD"  }) //aCols[1,2]
Local nPosQT   := Ascan(aHeader,{|x| Trim(x[2]) == "D3_QUANT"}) //aCols[1,x]

Local nQuant   := aCols[n][nPosQT]
Local cOrdemP  := aCols[n][nPosOP]	
Local cPartner := aCols[n][nPosPN]

Local nwVal    := 0

Local cPar1    := SuperGetMv("MV_XUSUACE")//Usuarios Acerto de Inventario quanto valorizado
Local cPar2    := SuperGetMv("MV_XUSUMOV")//Usuarios Movimentacoes para o Centro de Custo
Local cPar3    := SuperGetMv("MV_XUSUSCP")//Usuarios Movimentacoes sem Centro de Custo para o Scrap

Local cPar4    := SuperGetMv("MV_XTMMOV")//Acerto de Inventario quanto valorizado
Local cPar5    := SuperGetMv("MV_XTMSCRP")//Movimentacoes sem Centro de Custo para o Scrap
Local cPar6    := SuperGetMv("MV_XTMACER")//Movimentacoes para o Centro de Custo

For i:=nIni To nFim
	If !aCols[i, Len(aHeader)+1 ]
		cOrdemP  := aCols[i][nPosOP]
		cPartner := aCols[i][nPosPN]
		nQuant   := aCols[i][nPosQT]
		
		If !Empty(cOrdemP)
			dbSelectArea("SD4")
			dbSetOrder(1)
			If ( !dbSeek(xFilial("SD4")+cPartner+cOrdemP) ) 
				//Alert("O produto digitada não apresenta saldo de empenho. A operação não pode ser finalizada.")
				lRet:= .T. //.F.
			Else
				lRet:= .F. //.T.
			EndIf
			If lRet .And. CTM < "500"
				dbSelectArea("SC2")
				dbSetOrder(1)
				dbSeek(xFilial("SC2")+cOrdemP)
				
				nwProducao := u_PLESTE08(cOrdemP, SC2->C2_PRODUTO)
				nwVal      := u_fw_Consu(cOrdemP, SC2->C2_PRODUTO, cPartner, nwProducao)
				
				If nQuant <= nwVal
					lRet := .T.
				Else
					MsgStop("A quantidade devolvida é maior que o saldo da O.P., Favor verificar apontamento!")
					lRet := .F.
				EndIf
			EndIf
		Else
			
			If (CTM $ cPar4)
				If !(__cUserId $ cPar2)
					MsgStop("Usuário sem acesso a esta operação!")
					lRet := .F.
				else
					lRet := .T.
				EndIf
			elseif (CTM $ cPar5)
				If !(__cUserId $ cPar3)
					MsgStop("Usuário sem acesso a esta operação!")
					lRet := .F.
				else
					lRet := .T.
				EndIf
			elseif (CTM $ cPar6)
				If !(__cUserId $ cPar1)
					MsgStop("Usuário sem acesso a esta operação!")
					lRet := .F.
				else
					lRet := .T.
				EndIf
			Else
				MsgStop("Nao é possível movimentar material com esse TM sem informar o numero da ordem de producao.")
				lRet := .F.
			EndIf
			/*		If !( __cUserId $ GetMv("MV_XUS1AJU"))
			MsgStop("Usuário sem acesso a esta operação!")
			lRet:=.F.
			Else
			If ((CTM == "100" .Or. CTM == "600") .And. !empty(CCC))
			lRet := .T.
			ElseIf (CTM == "741")
			lRet := .T.
			lRet:=.F.
			Endif
			EndIf
			*/
		EndIf
	EndIf
Next

Return lRet
