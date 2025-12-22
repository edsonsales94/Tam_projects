#include 'protheus.ch'

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ AMESTE01   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 05/06/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Replicar informações de um campo nos itens                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AMESTE01(cAlias,lTodos,cCampo,cFields)
	Local nX, nIni, nC, aCmp
	Local cVar := StrTran(ReadVar(),"M->","")
	Local nPos := AScan( aHeader , {|x| Trim(x[2]) == cVar } )

	Default lTodos  := .F.
	Default cCampo  := ""
	Default cFields := "CP_XNUMOS"
	
	If cCampo == cVar
		// Apartir da 2a linha copia os campos para as demais linhas
		If n > 1
			aCmp := Separa(GetMV("MV_XCPY"+cAlias,.F.,cFields),"|",.F.)
			For nC:=1 To Len(aCmp)
				If (nPos := PosCampo(aCmp[nC])) > 0
					aCols[n,nPos] := aCols[n-1,nPos]
					u_AMDispara(aCmp[nC],aCols[n,nPos],n,.F.)
				Endif
			Next
		Endif
	ElseIf nPos > 0 .And. (lTodos .Or. n < Len(aCols) .And. FWAlertYesNo("Deseja replicar essa informação para os itens abaixo ?"))
		nIni := If( lTodos , 1, n + 1)
		For nX:=nIni To Len(aCols)
			If nX <> n
				aCols[nX,nPos] := M->&( cVar )
				u_AMDispara(cVar,aCols[nX,nPos],nX,.F.)
			Endif
		Next
	Endif

Return .T.

Static Function PosCampo(cCampo)
Return AScan( aHeader , {|x| Trim(x[2]) == cCampo } )
