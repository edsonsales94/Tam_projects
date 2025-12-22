#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ SPDFIS02   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 04/10/2021 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada para enviar UM e Qtde no SPED FISCAL         ¦¦¦
¦¦¦ Descr     ¦ Alterado por Adson em 15/03/23 p buscar a UM&QTY da SDT       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function SPDFIS02()
	Local cUMXML
	Local cAliasIT := ParamIXB[1]           // Recebe o Alias principal
	Local cTipoMov := ParamIXB[2]           // Recebe o tipo de movimento - E = ENTRADA / S = SAIDA, para registros gerados a partir de notas fiscais. Para registros não originados de notas esta posição terá conteúdo Nil.
	Local aRet     := Nil                  // Array para armazenar dados do retorno da função
	Local cPrefix  := If(ValType(cTipoMov)=='C',Iif (cTipoMov$"E","D1","D2"),"")   // Prefixo da tabela - D1_ / D2_
	Local aAreaAnt := GetArea()
	
	If !Empty(cPrefix)
		If cTipoMov == "E" 
			
			SDT->(dbSetOrder(8)) // DT_FILIAL+DT_FORNECE+DT_LOJA+DT_DOC+DT_SERIE+DT_ITEM
			If SDT->(dbSeek(XFILIAL("SDT")+(cAliasIT)->FT_CLIEFOR+(cAliasIT)->FT_LOJA+(cAliasIT)->FT_NFISCAL+(cAliasIT)->FT_SERIE+(cAliasIT)->FT_ITEM))
			
				If SDT->DT_XQTDXML > 0
					cUMXML := AllTrim(SDT->DT_XUMXML)
					aRet   := { PADR(cUMXML,Max(TamSX3("B1_UM")[1],Len(cUMXML))), SDT->DT_XQTDXML}
					
					// Posiciona no Cadastro do Produto
					SB1->(dbSetOrder(1))
					If SB1->(dbSeek(XFILIAL("SB1")+SD1->D1_COD)) .And. !(cUMXML == AllTrim(SB1->B1_UM))
						If !(cUMXML == AllTrim(SB1->B1_SEGUM)) .Or. Empty(SB1->B1_TIPCONV)
							AAdd( aRet , (cAliasIT)->FT_QUANT/SDT->DT_XQTDXML   )    // Adiciona o fator de conversão
							AAdd( aRet , "M" )    // Adiciona o tipo de conversão (M=Multiplicador / D=Divisor)
						ElseIf Empty(SB1->B1_CONV)
							AAdd( aRet , (cAliasIT)->FT_QUANT/SDT->DT_XQTDXML    )    // Adiciona o fator de conversão
							AAdd( aRet , SB1->B1_TIPCONV )    // Adiciona o tipo de conversão (M=Multiplicador / D=Divisor)
						Endif
					Endif
				Endif	
			
				
			Endif
		Endif
	Endif
	RestArea(aAreaAnt)

Return aRet
