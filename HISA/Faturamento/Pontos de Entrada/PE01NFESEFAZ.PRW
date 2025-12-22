#Include 'Protheus.ch'
#Include 'PRTOPDEF.CH'

User Function PE01NFESEFAZ()
	Local aRet := PARAMIXB
	Local aProd := PARAMIXB[1]
	Local nX := 0
	Local aNota := PARAMIXB[5]
	// Local cMensCli := PARAMIXB[2]
	// Local cMensFis := PARAMIXB[3]
	// Local aDest := PARAMIXB[4]
	// Local aInfoItem := PARAMIXB[6]
	// Local aDupl := PARAMIXB[7]
	// Local aTransp := PARAMIXB[8]
	// Local aEntrega := PARAMIXB[9]
	// Local aRetirada := PARAMIXB[10]
	// Local aVeiculo := PARAMIXB[11]
	// Local aReboque := PARAMIXB[12]
	// Local aNfVincRur:= PARAMIXB[13]
	// Local aEspVol := PARAMIXB[14]
	// Local aNfVinc := PARAMIXB[15]
	// Local aDetPag := PARAMIXB[16]
	// Local aObsCotAux:= PARAMIXB[17]
	// Local cMsg := ""
	Local aAreaAtu	:= GetArea()
	Local aAreaSD2	:= SD2->(GetArea())
	Local aAreaSC6	:= SC6->(GetArea())

	**** TODOS OS PRODUTOS PARA ESSA CUSTOMISAÇÃO PRECIÃO TER OS CAMPOS NO COMPLEMENTOS PREENCHIDOS
	**** B5_UMDIPI E B5_CONVDIP e B5_2CODBAR

	If aNota[4] == "1" .AND. SF2->F2_FILIAL == '01' .AND.; // SOMENTE FILIAL INDUSTRIA 01
		SF2->F2_CLIENTE $ '000032|000038'// NF saida E cliente
		///D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		for nX := 1 to len(aProd)
			IF SD2->(MsSeek(SF2->(F2_FILIAL + F2_DOC + F2_SERIE+F2_CLIENTE+F2_LOJA)+aProd[Nx,2]+StrZero(aProd[Nx,1],2)))
				if AllTrim(aProd[nX,2]) $ SuperGetMV("MV_PRSEGUM") // PARAMETRO QUE CONTEM OS PRODUTOS, PARA ESSA VALIDAÇÃO.
					aProd[nX,11] := POSICIONE('SB5',1,XFILIAL('SF2')+aProd[nX,2],'B5_UMDIPI')
					aProd[nX,12] :=  SD2->D2_QUANT/POSICIONE('SB5',1,XFILIAL('SF2')+aProd[nX,2],'B5_CONVDIP')

					c2CodBar := POSICIONE('SB5',1,XFILIAL('SF2')+aProd[nX,2],'B5_2CODBAR')
					aProd[nX,45] := iif(!Empty(c2CodBar) .OR. c2CodBar <> aProd[nX,45] ,c2CodBar,aProd[nX,45])
					// aProd[nX,3] :=  iif(!Empty(c2CodBar),c2CodBar,aProd[nX,3])
					// aProd[nX,46] := iif(!Empty(c2CodBar),c2CodBar,aProd[nX,46])
				EndIf
			EndIf
		next nX
		aRet[1] := aProd
	Else
		// se entra aqui, precisa tirar do xml o codigo EAN da segunda unidade, usar na podiçao aProd[nX,45] o mesmo codigo da posição aProd[nX,46] que é o EAN da primeira unidade de medida
		for nX := 1 to len(aProd)
			aProd[nX,45] := aProd[nX,46]
		next nX
		aRet[1] := aProd
	EndIf

	RestArea(aAreaSD2)
	RestArea(aAreaSC6)
	RestArea(aAreaAtu)

RETURN aRet
