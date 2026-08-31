#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MA650TOK   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 23/06/2023 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ P.E. para executar a validacao do usuario ao confirmar a OP   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MA650TOK()
	Local lConsEst   := (GetMV("MV_CONSEST") == "S")
	Local lNewOpc    := (GetNewPar("MV_REPGOPC","N") == "S")
	Local aOPInt     := {}
	Local nQuantItem := 0
	Local lRet       := (GetMV("MV_XVLSDOP",.F.,"S") == "S")
	//Local aHeadAux   := aClone(aHeader)
	//Local aColsAux   := aClone(aCols)
	//Local nNAux      := n
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Numeracao da OP                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private cC2_PRODUTO := M->C2_PRODUTO
	Private dC2_DATPRI  := M->C2_DATPRI
	Private dC2_DATAJI  := M->C2_DATAJI
	Private nC2_QUANT   := M->C2_QUANT
	Private cC2_NUM     := M->C2_NUM
	Private cC2_ITEM    := M->C2_ITEM
	Private cC2_SEQUEN  := M->C2_SEQUEN
	Private cC2_ITEMGRD := M->C2_ITEMGRD
	Private cC2_GRADE   := M->C2_GRADE
	Private cC2_PRIOR   := M->C2_PRIOR
	Private cC2_REVISAO := M->C2_REVISAO
	Private cMOPC       := CriaVar("C6_MOPC"   ,.T.)
	Private cOPC        := CriaVar("C6_OPC"    ,.T.)
	Private cC2_TPOP    := M->C2_TPOP
	Private lZrHeader   := .T.
	
	// Variaveis compatibilizadoras
	aHeader   := {}
	aCols     := {}
	lProj711  := .F.
	lMata712  := .F.
	lPCPA107  := .F.
	l650Auto  := .F.
	
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(XFILIAL("SB1")+cC2_PRODUTO))
	
	AADD(aOPInt, { cC2_PRODUTO, cC2_NUM+cC2_ITEM+cC2_SEQUEN+cC2_ITEMGRD, (nC2_QUANT - nQuantItem) } )
	
	lRet := !lRet .Or. u_MGMontEstru(cC2_PRODUTO,nC2_QUANT,dC2_DATPRI,,cC2_SEQUEN,cC2_PRIOR,lConsEst,IIf(lNewOpc,cMOPC,cOPC),.F.,cC2_TPOP,cC2_REVISAO,cC2_PRODUTO, @aOPInt)
	
	//aHeader := aClone(aHeadAux)
	//aCols   := aClone(aColsAux)
	//n       := nNAux
	
Return lRet
