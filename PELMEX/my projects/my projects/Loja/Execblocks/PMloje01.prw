#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PMLOJE01   ¦ Autor ¦ Adson Carlos         ¦ Data ¦ 13/03/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Execblock usado na reserva Pelmex					              ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PMLOJE01(nTipo)
	Local nX
	Local _aArea      := GetArea()
	Local cConteudo   := Alltrim(GETMV("MV_XTIPRES"))
	Private nPRes     := AScan( aHeaderDet , {|x| Trim(x[2]) == "LR_RESERVA" })  // Reserva
	Private nPLoj     := AScan( aHeaderDet , {|x| Trim(x[2]) == "LR_LOJARES" })  // Loja Reserva
	Private nPEnt     := AScan( aHeader    , {|x| Trim(x[2]) == "LR_ENTREGA" })  // Entrega
	Private nPPrd     := AScan( aHeader    , {|x| Trim(x[2]) == "LR_PRODUTO" })  // Produto
	Private nPQtd     := AScan( aHeader    , {|x| Trim(x[2]) == "LR_QUANT"   })  // Quantidade
	Private cTipo     := Posicione("SB1",1,xFilial()+aCols[n,nPPrd],"B1_TIPO")
	Private cFilAux   := cFilAnt
	Private cFilInd   := "01"                  // Filial da indústria         
	Private cRese     := GetSxeNum("SC0","C0_NUM",cFilInd+"\DATA\"+RetSqlName("SC0"))
	Private nSaveSX8  := 0       
	Private _Docres   := M->LQ_CLIENTE
	Private _Filres   := ""
	Private _Localc   := ""

	Private _Valida   := Nil
	Private _ObsRet   := "Pedido:"+M->LQ_NUM+" Filial:"+ xFilial()   
	ConfirmSX8()

	DbSelectArea("SLJ")
	SLJ->(dbSetOrder(3))
	SLJ->(dbSeek(XFILIAL("SLJ")+cempant+cfilind))

	_Filres  := SLJ->LJ_RPCFIL
	
	IF M->LQ_XCD == "1"
	_Localc := "15"
	else
	_Localc  := SLJ->LJ_LOCAL
	endif
	
	_Valida   := dDatabase + SLJ->LJ_DIASRES

	If nTipo = 1 .And. (M->LQ_XRES == "1" .OR. M->LQ_XCD == "1" ) .And. cTipo $ cConteudo 
		// Se for Inclusao
		aColsDet[n,nPRes] := cRese
		aColsDet[n,nPLoj] := SLJ->LJ_CODIGO
		aCols[n,nPEnt] := "1"
		GravaSC0(n)
	Endif

	If nTipo = 2 .And. (M->LQ_XRES == "1".OR. M->LQ_XCD == "1" )	//Incluir Tuto
		For nX := 1 to Len(aCols)
			cTipo := Posicione("SB1",1,xFilial()+aCols[nX,nPPrd],"B1_TIPO")
			If cTipo $ cConteudo
				aColsDet[nX,nPRes] := cRese
				aColsDet[nX,nPLoj] := SLJ->LJ_CODIGO
				aCols[nX,nPEnt] := "1"
				GravaSC0(nX)
			EndIf
		Next nX
	EndIf

	If nTipo = 3 .And. (L1->L1_XRES == "1" .OR. M->LQ_XCD == "1" )	//Alterar
		For nX := 1 to Len(aCols)
			cTipo := Posicione("SB1",1,xFilial()+aCols[nX,nPPrd],"B1_TIPO")
			If cTipo $ cConteudo
				AlteraSC0(nX)
			EndIf
		Next nX
	EndIf

	RestArea(_aArea)

Return .T.

Static Function AlteraSC0(nY)
	//validar se ja existe 'nY' gravado
	Local cAlias  := Alias()
	cFilAnt       := cFilInd   // Atualiza para filial de destino do pedido
	dbSelectArea("SC0")
	SC0->(dbSetOrder(1))
	SC0->(dbSeek(cFilInd + SL2->L2_RESERVA + SL2->L2_PRODUTO))
	If Found()
		_Qtd  :=  aCols[nY,nPQtd]-SC0->C0_QUANT
		RecLock("SC0",.F.)
		SC0->C0_QUANT   := aCols[nY,nPQtd]
		SC0->C0_QTDORIG := aCols[nY,nPQtd]
		SC0->C0_QTDORIG := aCols[nY,nPQtd]
		MsUnlock()
	Else
		GravaSC0(nY)
	EndIf
		IF M->LQ_XCD== "1"
	ModiSB2(nY,_Localc,_Qtd)
	Endif
	cFilAnt := cFilAux   // Restaura filial logada
	dbSelectArea(cAlias)

Return

Static Function GravaSC0(nY)
	//validar se ja existe 'nY' gravado
	Local aArea := GetArea()

	nSaveSX8 := GetSx8Len()

	// Calcula o próximo número de pedido
	dbSelectArea("SC0")
	SC0->(dbSetOrder(1))
	SC0->(dbSeek(cFilInd + cRese + aCols[nY,nPPrd] + SLJ->LJ_LOCAL))
	If !Found()
		//grava item
		RecLock("SC0",.T.)
		SC0->C0_FILIAL  := cFilInd
		SC0->C0_NUM     := cRese
		SC0->C0_TIPO    := "LJ"
		SC0->C0_DOCRES  := _Docres
		SC0->C0_SOLICIT := cUserName
		SC0->C0_FILRES  := _Filres
		SC0->C0_PRODUTO := aCols[nY,nPPrd]
		SC0->C0_LOCAL   := _Localc 
		SC0->C0_QUANT   := aCols[nY,nPQtd]
		SC0->C0_VALIDA  := _Valida
		SC0->C0_EMISSAO := dDatabase
		SC0->C0_QTDORIG := aCols[nY,nPQtd]
		SC0->C0_QTDPED  := aCols[nY,nPQtd]
		SC0->C0_OBS     := _ObsRet
		MsUnlock()
			IF M->LQ_XCD == "1"
			AtualSB2(nY,_Localc)

			endif
		
		
		
		//AtualSB2(nY)
	EndIf          

	RestArea(aArea)
Return


Static Function AtualSB2(nY,_Localc)
	Local aArea := GetArea()
	DbSELECTArea("SB2")
	SB2->(DbSetOrder(1))
	SB2->(DbSeek(cFilInd+aCols[nY,nPPrd]+_Localc))

	If Found()
	RecLock("SB2",.F.)
	SB2->B2_RESERVA := SB2->B2_RESERVA + aCols[nY,nPQtd]
	MsUnlock()
	EndIf 

	RestArea(aArea)
Return

Static Function ModiSB2(nY,_Localc,_Localc,_Qtd)
	Local aArea := GetArea()
	DbSELECTArea("SB2")
	SB2->(DbSetOrder(1))
	SB2->(DbSeek(cFilInd+aCols[nY,nPPrd]+_Localc))

	If Found()
	RecLock("SB2",.F.)
	SB2->B2_RESERVA := SB2->B2_RESERVA + _Qtd
	MsUnlock()
	EndIf    

	RestArea(aArea)
Return .T.


