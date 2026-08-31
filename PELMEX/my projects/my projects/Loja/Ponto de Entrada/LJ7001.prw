#include "rwmake.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ LJ7001     ¦ Autor ¦ ADSON CARLOS	      ¦ Data ¦ 1X/03/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada de validação da Venda Assistida              ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function LJ7001()
	Local nX
	Local cConteudo := Alltrim(GETMV("MV_XTIPRES"))
	Local cCliente  := Alltrim(GETMV("MV_CLIPAD"))
	Local nPPrd := AScan( aHeader    , {|x| Trim(x[2]) == "LR_PRODUTO" }) // Produto
	Local nLocal := AScan( aHeader    , {|x| Trim(x[2]) == "L2_LOCAL" })
	Local nTES := AScan( aHeader    , {|x| Trim(x[2]) == "L2_TES" })


	If ParamIXB[1] == 1  // Caso seja um orçamento

		if !U_PMLOJE03()  //Valida Cliente padrão estados AM e PA
			return .F.
		endif

		If  (M->LQ_XRES == "1" .OR. M->LQ_XCD =="1")
			If M->LQ_FDENTR  == ''
				M->LQ_FDENTR = DDATABASE+15 
			ENDIF
			If M->LQ_CLIENTE == cCliente
				Alert("Não e permitido fazer reserva para cliente padrao")
				Return .F.	
			EndIf
			


			/*For nX := 1 to Len(aCols)
			//u_ValTES()
			cTipo := Posicione("SB1",1,xFilial()+aCols[nX,nPPrd],"B1_TIPO")  
			If !aCols[nX,LEN(ACOLS[N])]
			//If !(cTipo $ cConteudo)
			//Alert("Não e permitida a inclusao de produtos diferentes de:"+cConteudo)
			//Return .F.
			//EndIf
			EndIf	         
			Next nX */ 

			If INCLUI
				u_PMLOJE01(2)
			EndIf

		EndIf
	ElseIf Inclui
		Alert("Para Finalizar é obrigatorio primeiro salvar o orçamento!")
		Return .F.
	EndIf

Return .T.
