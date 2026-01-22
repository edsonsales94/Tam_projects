#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ COLF1D1    ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 04/10/2021 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada para adicionar gravações ao importar o XML   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function COLF1D1()
	Local nX, nPIte
	Local aCabec := ParamIXB[1]
	Local aItens := ParamIXB[2]
	
	SDT->(dbSetOrder(8))
	
	Conout("["+FunName()+"] - ENTROU")
	For nX:=1 To Len(aItens)
		nPIte := AScan( aItens[nX] , {|x| x[1] == "D1_ITEM" } )
		If nPIte > 0 .And. SDT->(dbSeek(XFILIAL("SDT")+SDS->DS_FORNEC+SDS->DS_LOJA+SDS->DS_DOC+SDS->DS_SERIE+aItens[nX][nPIte,2]))
			Conout("["+FunName()+"] - ACHOU SDT")
			AddNovoCampo(@aItens[nX],"D1_XDESXML",SDT->DT_DESCFOR)
			AddNovoCampo(@aItens[nX],"D1_XQTDXML",SDT->DT_XQTDXML)
			AddNovoCampo(@aItens[nX],"D1_XUMXML" ,SDT->DT_XUM)
			AddNovoCampo(@aItens[nX],"D1_XDESCRI",posicione('SB1',1,xFilial('SB1')+SDT->DT_COD,'B1_DESC'))
		Endif

	Next
    
Return { aCabec, aItens}

Static Function AddNovoCampo(aLinha,cCampo,xConteudo)
	Local nPos := AScan( aLinha , {|x| Trim(x[1]) == cCampo } )
	
	If nPos == 0
		AAdd( aLinha , { cCampo, , Nil})
		nPos := Len(aLinha)
	Endif
	aLinha[nPos,2] := xConteudo

Return
