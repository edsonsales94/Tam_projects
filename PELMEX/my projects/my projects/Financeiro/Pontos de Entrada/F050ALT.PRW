#Include "rwmake.ch"
#Include "Topconn.ch"
/*_______________________________________________________________________________
¦ Função    ¦ F050ALT    ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 07/01/2008 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Ponto de Entrada após alteração do vencimento do título principal ¦
---------------------------------------------------------------------------------
¦ Utilização¦ Atualizar a data de vencimento para o título de PIS, COFINS e CSLL¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function F050ALT()
	Local cChave := SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)
	Local cQry := "", x
	Local nRecno:= SE2->(Recno())
	Local _cArea:= GetArea(), aParc := {}
	Local nOrder := SE2->(IndexOrd())

	SE2->(dbSetOrder(6))
	SE2->(dbGoTop())
	SE2->(dbSeek(cChave))

	While !SE2->(Eof()) .And. SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) = cChave
		aParc := {}

		If !Empty(SE2->E2_PARCPIS)
			aadd(aParc,SE2->E2_PARCPIS)
		EndIf

		If !Empty(SE2->E2_PARCCOF)
			aadd(aParc,SE2->E2_PARCCOF)
		EndIf

		If !Empty(SE2->E2_PARCSLL)
			aadd(aParc,SE2->E2_PARCSLL)
		EndIf

		If day(SE2->E2_EMIS1) > 15
			dDate := LastDay(SE2->E2_EMIS1)+15
		Else 
			dDate := LastDay(SE2->E2_EMIS1)
		EndIf

		While dDate <> DataValida(dDate)
			dDate--
		End

		For x:= 1 to Len(aParc)
			cSql := "UPDATE "+RetSqlName("SE2")+" SET E2_VENCREA = '"+dtos(dDate)+"', E2_VENCTO = '"+dtos(dDate)+"' "
			cSql += "WHERE E2_PREFIXO = '"+SE2->E2_PREFIXO+"' AND E2_NUM = '"+SE2->E2_NUM+"' AND "
			cSql += "E2_FORNECE = '"+GetMv("MV_UNIAO")+"' AND E2_LOJA = '00' AND E2_PARCELA = '"+aParc[x]+"' AND "
			cSql += "E2_FILIAL = '"+xFilial("SE2")+"' AND D_E_L_E_T_ <> '*' "
			TCSqlExec(cSql)
		Next

		SE2->(dbSkip())
	End

	SE2->(dbSetOrder(nOrder))
	SE2->(dbGoTo(nRecno))
	RestArea(_cArea)
Return .T.
