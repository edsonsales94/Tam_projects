#Include "Rwmake.ch"
#INCLUDE 'FWMVCDEF.CH'

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ CRMA980    ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 06/03/2023 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada da NOVO Cadastro de Clientes                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function CRMA980()
	Local oModel, cIdPonto, cIDModel
	Local aParam  := PARAMIXB
	Local xRet    := .T.
	If aParam <> Nil
		oModel   := aParam[1]
		cIdPonto := aParam[2]
		cIDModel := aParam[3]
		
		If cIdPonto == "MODELCOMMITTTS"
			If oModel:GetOperation() == 3 .Or. oModel:GetOperation() == 4
				GZN->(dbSetOrder(2))
    			GZN->(dbGoTop())
	    		If !GZN->(dbSeek(XFILIAL("GZN")+SA1->A1_COD+SA1->A1_LOJA,.T.))
    				RecLock("GZN",.T.)
					GZN_FILIAL := XFILIAL("GZN")
					GZN_CODIGO := "000001"
					GZN_SEQ	   := STRZERO(GZN->(RecCount()),3)
					GZN_CLIENT := SA1->A1_COD
					GZN_LOJA   := SA1->A1_LOJA
					MsUnLock()
	    		Endif
			Endif
		/*ElseIf cIdPonto == "BUTTONBAR"
			If IsInCallStack("U_MMFATA03")
				xRet := { {'Atualizar', 'Atualizar', {|| u_MMFAT3B(cGrpEmp)} } }
			Endif*/
		Endif
	Endif
	
Return xRet
