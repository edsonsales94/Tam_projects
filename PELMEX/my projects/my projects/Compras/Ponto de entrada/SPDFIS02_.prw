#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ SPDFIS02   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 04/10/2021 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada para enviar UM e Qtde no SPED FISCAL         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function SPDFIS02()
	Local cAliasIT := ParamIXB[1]           // Recebe o Alias principal
	Local cTipoMov := ParamIXB[2]           // Recebe o tipo de movimento - E = ENTRADA / S = SAIDA, para registros gerados a partir de notas fiscais. Para registros não originados de notas esta posição terá conteúdo Nil.
	//Local cRegSped := If( Len(ParamIXB) > 2, ParamIXB[3], "")    // Recebe o  nome do registro, quando passado(1105, G140, H010, K200).
	Local aRet     := Nil                  // Array para armazenar dados do retorno da função
	Local cPrefix  := If(ValType(cTipoMov)=='C',Iif (cTipoMov$"E","D1","D2"),"")   // Prefixo da tabela - D1_ / D2_
	Local aAreaAnt := GetArea()
	
	If !Empty(cPrefix)
		If cTipoMov == "E" .And. GetMV("MV_XNVSPED",.F.,.T.)    // Novo SPED FISCAL
			//Conout("["+FunName()+"] - ENTROU")
			DKD->(dbSetOrder(1))   // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
			If DKD->(dbSeek(XFILIAL("DKD")+(cAliasIT)->FT_NFISCAL+(cAliasIT)->FT_SERIE+(cAliasIT)->FT_CLIEFOR+(cAliasIT)->FT_LOJA+(cAliasIT)->FT_ITEM))
				SD1->(dbSetOrder(1))   // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
				If SD1->(dbSeek(XFILIAL("SD1")+(cAliasIT)->FT_NFISCAL+(cAliasIT)->FT_SERIE+(cAliasIT)->FT_CLIEFOR+(cAliasIT)->FT_LOJA+(cAliasIT)->FT_PRODUTO+(cAliasIT)->FT_ITEM))
					nFator    :=  DKD->DKD_XQTDXM / SD1->D1_QUANT
					cTpFator := ""
					if DKD->DKD_XQTDXM < SD1->D1_QUANT
						cTpFator := "D"
					elseif DKD->DKD_XQTDXM > SD1->D1_QUANT
						cTpFator := "M"
					endif
					aRet := { If( Empty(DKD->DKD_XUMXML) ,SD1->D1_UM,DKD->DKD_XUMXML), If( Empty(DKD->DKD_XQTDXM) , SD1->D1_QUANT, DKD->DKD_XQTDXM),nFator,cTpFator}
				EndIf
			Endif
		Endif
	Endif
	RestArea(aAreaAnt)

Return aRet
