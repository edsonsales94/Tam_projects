#INCLUDE 'PROTHEUS.CH'

User Function M310ITENS()

	Local cProg  := PARAMIXB[1]
	Local aItens := PARAMIXB[2]
	Local nx
	Local oModel  := FWModelActive()
	Local oGrid   := oModel:GetModel("NNTDETAIL")

	dbSelectArea('ZZ2')
	ZZ2->(DbSetOrder(1))
    // posiciona no cadastro de coligadas para tranferecias com filial origem e de destino caso encontre alterar os valores.
	if ZZ2->(msseek(xFilial('ZZ2')+oGrid:GetValue("NNT_FILORI")+oGrid:GetValue("NNT_FILDES")))
		If Alltrim(cProg) == 'MATA410'
			For nx:=1 to Len(aItens)
                nPrcUnit := aItens[nx,6,2] * ZZ2->ZZ2_PERC  // alterar o preco unitario com acrecimo da porcentagem definida na regra 
                nVlrTot  :=  nPrcUnit * aItens[nx,4,2]      // alterar o valor total mutiplincando a quantidade com o valor unitario 

                // mudar no array prcVen, prcUnit e valor
                aItens[nx,5,2]:= nPrcUnit
                aItens[nx,6,2]:= nPrcUnit
                aItens[nx,7,2]:= nVlrTot
				// aadd(aItens[nx],{'C6_CONTA','1110210',Nil})
			Next nx
		EndIf
	EndIf
Return(aItens)
