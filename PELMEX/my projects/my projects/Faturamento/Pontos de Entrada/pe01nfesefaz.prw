#Include "rwmake.ch"
#Include "protheus.ch"

/*/{Protheus.doc}PE01NFESEFAZ
@description
Ponto de Entrada para aglutinar os itens da nota.
@author	Bruno Garcia
@version	1.0
@since		17/03/2016
@return	aRetorno,Array,Retorna os dados modificados.
@param 	PARAMIXB,Array, Contêm os dados da nota fiscal.
/*/
User Function PE01NFESEFAZ()            
	//aParam := {aProd,cMensCli,cMensFis,aDest,aNota,aInfoItem,aDupl,aTransp,aEntrega,aRetirada,
	//aVeiculo,aReboque,aNfVincRur,aEspVol,aNfVinc,aDetPag,aObsCont,aICMS,aIPI,aPIS,aCOFINS}
	Local aProd	 	:= PARAMIXB[1]
	Local cMensCli	:= PARAMIXB[2]
	Local cMensFis	:= PARAMIXB[3]
	Local aDest	 	:= PARAMIXB[4]
	Local aNota   	:= PARAMIXB[5]
	Local aInfoItem	:= PARAMIXB[6]
	Local aDupl		:= PARAMIXB[7]
	Local aTransp	:= PARAMIXB[8]
	Local aEntrega	:= PARAMIXB[9]
	Local aRetirada	:= PARAMIXB[10]
	Local aVeiculo	:= PARAMIXB[11]
	Local aReboque	:= PARAMIXB[12]  
	Local aNfVincRur := PARAMIXB[13]
	Local aEspVol	:= PARAMIXB[14]
	Local aNfVinc	:= PARAMIXB[15]
	Local aDetPag	:= PARAMIXB[16]
	Local aObsCont	:= PARAMIXB[17] 

	//Aglutinação do vetor de itens e impostos
	Local aICMS 	:= PARAMIXB[18]
	Local aIPI 		:= PARAMIXB[19]
	Local aPIS 		:= PARAMIXB[20]
	Local aCOFINS 	:= PARAMIXB[21]

	Local aItensAglu	:= {} 
	Local aICMSAglu		:= {}
	Local aIPIAglu		:= {}               
	Local aPISAglu		:= {}
	Local aCOFINAglu	:= {}
	//########################################

	Local nX			:= 0

	Local nTam			:= 0
	Local nSeqItem	:= 0
	Local aRetorno  	:= {}
	Local aArea     := GetArea()


	//Valida se é uma nota de Saida
	If aNota[4] == "1"
		//Percorre os itens da nota
		For nX := 1 To Len(aProd)

			//Realiza a aglutinaçao dos itens com o mesmo codigo de produto	
			nPos := AScan(aItensAglu, {|x| x[2] == aProd[nX][02] .And. x[7] == aProd[nX][07] .And. x[27] == aProd[nX][27] ;
			.And. x[33] == aProd[nX][33] .And. x[16] == aProd[nX][16] })
			If nPos > 0
				//Realiza as somas do item encontrado
				aItensAglu[nPos][09] += aProd[nX][09]//Quantidade
				aItensAglu[nPos][10] += aProd[nX][10]//Total
				aItensAglu[nPos][12] += aProd[nX][12]//Qtd B5_CONVDIP
				aItensAglu[nPos][13] += aProd[nX][13]//Frete
				aItensAglu[nPos][14] += aProd[nX][14]//Seguro
				aItensAglu[nPos][15] += aProd[nX][15]//Desconto
				//aItensAglu[nPos][16] := Round(aItensAglu[nPos,10] / aItensAglu[nPos,09], TamSX3("D2_PRCVEN")[2]) //Preço Unitario
				aItensAglu[nPos][30] += aProd[nX][30]//Total Imposto carga tributaria
				aItensAglu[nPos][31] += aProd[nX][31]//Desconto Zona Franca PIS
				aItensAglu[nPos][32] += aProd[nX][32]//Desconto Zona Franca CONFINS
				//aItensAglu[nPos][33] += aProd[nX][33]//Percentual de ICMS
				aItensAglu[nPos][35] += aProd[nX][35]//Total carga tributária Federal
				aItensAglu[nPos][36] += aProd[nX][36]//Total carga tributária Estadual
				aItensAglu[nPos][37] += aProd[nX][37]//Total carga tributária Municipal		

				If Len(aICMS[nX]) > 0
					aICMSAglu[nPos][5] += aICMS[aProd[nX][1]][5]
					aICMSAglu[nPos][7] += aICMS[aProd[nX][1]][7]
					aICMSAglu[nPos][9] += aICMS[aProd[nX][1]][9]
				EndIf

				If Len(aIPI[nX]) > 0
					aIPIAglu[nPos][6]  += aIPI[aProd[nX][1]][6]
					aIPIAglu[nPos][10] += aIPI[aProd[nX][1]][10]
					aIPIAglu[nPos][7]  += aIPI[aProd[nX][1]][7]
				EndIf
				If Len(aPIS[nX]) > 0
					aPISAglu[nPos][2] += aPIS[aProd[nX][1]][2]
					aPISAglu[nPos][4] += aPIS[aProd[nX][1]][4]
					aPISAglu[nPos][5] += aPIS[aProd[nX][1]][5]
				EndIf   
				If Len(aCOFINS[nX]) > 0
					aCOFINAglu[nPos][2] += aCOFINS[aProd[nX][1]][2]
					aCOFINAglu[nPos][4] += aCOFINS[aProd[nX][1]][4]
					aCOFINAglu[nPos][5] += aCOFINS[aProd[nX][1]][5]
				EndIf   


			Else
				//Para reorganizar a numeraçao dos itens
				nSeqItem := Len(aItensAglu)

				AAdd(aItensAglu,aProd[nX])

				//Para reorganizar a numeraçao dos itens
				nTam := Len(aItensAglu)
				aItensAglu[nTam][1] := nSeqItem + 1  

				If Len(aICMS[nX]) > 0
					aadd(aICMSAglu,aICMS[nX])
				Else
					aadd(aICMSAglu,{})
				EndIf               

				If Len(aIPI[nX]) > 0
					aadd(aIPIAglu,aIPI[nX])
				Else
					aadd(aIPIAglu,{})    
				EndIf

				If Len(aPIS[nX]) > 0
					aadd(aPISAglu,aPIS[nX])
				Else
					aadd(aPISAglu,{})    
				EndIf

				If Len(aCOFINS[nX]) > 0
					aadd(aCOFINAglu,aCOFINS[nX])
				Else
					aadd(aCOFINAglu,{})    
				EndIf			
			EndIf
		Next nX
	EndIf

	aadd(aRetorno,IIF(EMPTY(aItensAglu),aProd,aItensAglu))
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
	aadd(aRetorno, aNfVinc)
	aadd(aRetorno,aDetPag)
	aadd(aRetorno,aObsCont)
	aadd(aRetorno,IIf(Len(aICMSAglu) > 0,aICMSAglu,aICMS))	//[13]
	aadd(aRetorno,IIf(Len(aIPIAglu) > 0,aIPIAglu,aIPI))		//[14]
	aadd(aRetorno,IIf(Len(aPISAglu) > 0,aPISAglu,aPIS))		//[15]
	aadd(aRetorno,IIf(Len(aCOFINAglu) > 0,aCOFINAglu,aCOFINS))//[16]

	RestArea(aArea)
Return aRetorno