#Include "rwmake.ch"

//----------------------------------------------------------
/*/{Protheus.doc} PE01NFESEFAZ
Ponto de Entrada no momento da geração da transmição da documento de saída para a SEFAZ
@param não possui
@return não possui
@since 01/03/2024
@author claudio franca
@project Implantação magistral
/*/
//----------------------------------------------------------
//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function PE01NFESEFAZ()
	Local aProd     := PARAMIXB[1]
	Local cMensCli  := PARAMIXB[2]
	Local cMensFis  := PARAMIXB[3]
	Local aDest     := PARAMIXB[4]
	Local aNota     := PARAMIXB[5]
	Local aInfoItem := PARAMIXB[6]
	Local aDupl     := PARAMIXB[7]
	Local aTransp   := PARAMIXB[8]
	Local aEntrega  := PARAMIXB[9]
	Local aRetirada := PARAMIXB[10]
	Local aVeiculo  := PARAMIXB[11]
	Local aReboque  := PARAMIXB[12]
	Local aNfVincRur:= PARAMIXB[13]
	Local aEspVol   := PARAMIXB[14]
	Local aNfVinc   := PARAMIXB[15]
	Local aDetPag   := PARAMIXB[16]
	Local aObsCont  := PARAMIXB[17]
	Local aProcRef  := PARAMIXB[18]
	Local aMed      := PARAMIXB[19]
	Local aLote     := PARAMIXB[20]
	Local aRetorno  := {}
	Local aArea     := GetArea()
	Local cLote     := ""
	Local cString   := ""
	Local cTes      := ""
	Local cAux      := ""
	Local aAreaSd2  := SD2->(GetArea())
	Local aAreaSc6  := SC6->(GetArea())
	Local nX
	
	//Valida se é uma nota de Saida
	If aNota[4] == "1"
		
		//Percorre os itens da nota
		For nX := 1 to Len(aProd)
			cString := ""
			
			//Posiciona no Item do vetor aProd para verificar informações de Lote e Validade Lote
			SD2->(dbSetOrder(3))
			SD2->(dbSeek(XFILIAL("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+aProd[nX][02]+aInfoItem[nX][04]))
			
			cLote    := SD2->D2_LOTECTL
			cDFabric := DtoC(SD2->D2_DFABRIC)
			cDtValid := DtoC(SD2->D2_DTVALID)
			
			//Verifica se existe alguma mensagem legal para a TES do Item
			cAux := Alltrim(Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"SF4->F4_XMENFIS"))
			
			//Verifica se a mensagem já foi adicionada anteriormente
			cTes += Iif( !Empty(cAux) .And. !(cAux $ cTes)  , cAux + ", " , "" )
			
			//Verifica se o lote foi preenchido
			If !Empty(cLote)
				cString += " LOTE:"+Alltrim(cLote)+" FAB:"+Alltrim(cDfabric)+" VAL:"+Alltrim(cDtValid)
			EndIf
			
			//Faz a modificação da descrição do produto
			aProd[nX][25] := Alltrim(cString)
		Next nX
		
		// Posiciona no pedido de venda
		SC5->(dbSetOrder(1))    // C5_FILIAL+C5_NUM
		SC5->(dbSeek(XFILIAL("SC5")+SD2->D2_PEDIDO))
		
		If SC5->(FieldPos("C5_XENTREG")) > 0 .And. !Empty(SC5->C5_XENTREG)
			// Adiciona as informações da data e hora de entrega
			aNota[03] := SC5->C5_XENTREG
			aNota[06] := "00:00"
		Endif
	EndIf
	
	//Faz a impressão da mensagem das TES
	If !Empty(cTes)
		cMensFis += " "+cTes
	EndIf
	
	aadd(aRetorno,aProd)
	aadd(aRetorno,cMensCli)
	aadd(aRetorno,cMensFis)
	aadd(aRetorno,aDest)
	aadd(aRetorno,aNota)
	aadd(aRetorno,aInfoItem)
	aadd(aRetorno,aDupl)
	aadd(aRetorno,aTransp)
	aadd(aRetorno,aEntrega)
	aadd(aRetorno,aRetirada)
	aadd(aRetorno,aVeiculo)
	aadd(aRetorno,aReboque)
	aadd(aRetorno,aNfVincRur)
	aadd(aRetorno,aEspVol)
	aadd(aRetorno,aNfVinc)
	aadd(aRetorno,aDetPag)
	aadd(aRetorno,aObsCont)
	aadd(aRetorno,aProcRef)
	aadd(aRetorno,aMed)
	aadd(aRetorno,aLote)
	
	RestArea(aArea)
	RestArea(aAreaSd2)
	RestArea(aAreaSc6)
	
RETURN aRetorno
