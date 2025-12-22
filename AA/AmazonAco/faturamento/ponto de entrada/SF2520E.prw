#include "rwmake.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ M521DNFS   ¦ Autor ¦ Arlindo Neto         ¦ Data ¦ 11/03/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada de exclusão da nota de saída                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static aOrdens := {}

User Function M521DNFS()
	Local nX 
	Local aLibera := {}
	For nX:=1 To Len(aOrdens)

		CB9->(DbSetOrder(1))
		CB9->(MsSeek(xFilial("CB9")+aOrdens[nX,1]))

		While !CB9->(Eof()) .And. CB9->CB9_ORDSEP == aOrdens[nX,1]
			PA2->(DbSetOrder(5))
		
			PA2->(DbSeek(xFilial("PA2")+CB9->CB9_ORDSEP+CB9->CB9_ITESEP+CB9->CB9_PROD))

			SC9->(DbSetOrder(1))
			If SC9->(DbSeek(xFilial("SC9")+CB9->CB9_PEDIDO+PA2->PA2_ITEMPD))
				While !SC9->(Eof()) .And. xFilial("SC9")+CB9->CB9_PEDIDO+PA2->PA2_ITEMPD==xFilial("SC9")+SC9->C9_PEDIDO+SC9->C9_ITEM
					If SC9->C9_ORDSEP != aOrdens[nX,1]
						SC9->(DbSkip())
						Loop
					EndIf	
					RecLock("SC9",.F.)
					SC9->C9_ORDSEP := ""
					MsUnlock()
					SC9->(a460Estorna())

					SC9->(DbSkip())
				EndDo
			EndIf
			SC6->(DbSetOrder(1))
			SC6->(MsSeek(xFilial("SC6")+CB9->CB9_PEDIDO+PA2->PA2_ITEMPD))
			_xdPos := aScan(aLibera, {|x| x[01] == CB9->CB9_PROD .And. x[14] == PA2->PA2_ITEMPD} )
			If _xdPos>0
				aLibera[_xdPos,7] += CB9->CB9_QTESEP
				aLibera[_xdPos,11]+= ConvUM(CB9->CB9_PROD,CB9->CB9_QTESEP,0,2)									
			Else
				aAdd(aLibera,{CB9->CB9_PROD,CB9->CB9_LOCAL,CB9->CB9_LCALIZ,"75","SEPARA",CB9->CB9_LOTECT,CB9->CB9_QTESEP,CB9->CB9_PEDIDO,.F.,CB9->CB9_ORDSEP,ConvUM(CB9->CB9_PROD,CB9->CB9_QTESEP,0,2),.T.,SC6->(Recno()),PA2->PA2_ITEMPD})
			EndIf

			CB9->(DbSkip())
		EndDo  
	Next nX


	For nY:=1 To Len(aLibera)
		aEmp := {}
		//aadd(aEmp,{"SEPARA",Space(TamSx3("CB9_NUMLOT")[1]),"SEPARA",Space(TamSx3("CB9_NUMSER")[1]),aLibera[nY,7],aLibera[nY,11],,,,,"75",0})
		aadd(aEmp,{aLibera[nY,6],Space(TamSx3("CB9_NUMLOT")[1]),"SEPARA",Space(TamSx3("CB9_NUMSER")[1]),aLibera[nY,7],aLibera[nY,11],,,,,"75",0})
		
		//aadd(aEmp,{aTransferencia[nY,6],Space(TamSx3("CB9_NUMLOT")[1]),"SEPARA",Space(TamSx3("CB9_NUMSER")[1]),aTransferencia[nY,7],aTransferencia[nY,11],,,,,"75",0})
		cOrdSep := aLibera[nY,10]

		SC6->(DbGoto(aLibera[nY,13])) 
		cOldLoc := aLibera[nY,2]			
		RecLock("SC6",.F.)
		SC6->C6_LOCAL := "75"
		MsUnlock()
		MaLibDoFat(aLibera[nY,13]	,aLibera[nY,7]		 ,.T.        ,.T.     ,.F.    ,.F.   ,.F.    ,.F.     ,NIL,{||SC9->C9_ORDSEP := aLibera[nY,10]},aEmp,,.F.)


		SC6->(DbGoto(aLibera[nY,13])) 				
		RecLock("SC6",.F.)
		SC6->C6_LOCAL := aLibera[nY,2]
		MsUnlock()
	Next nY
	aOrdens := {}
Return

User Function SF2520E() 
	FExcSC9()
Return 



Static Function FExcSC9()
	Local cQuery 	:= ""
	Local aAreaSF2 := SF2->(GetArea())
	Local aAreaSD2 := SD2->(GetArea())
	Local aAreaSC6 := SC6->(GetArea())

	//D2_FILIAL+D2_DOC+D2_SERIE
	cAliasSC9 := "TMP"
	If Select(cAliasSC9)>0
		(cAliasSC9)->(DbCloseArea(cAliasSC9))
	EndIf

	cQuery := "SELECT C9_FILIAL,C9_PEDIDO,C9_ITEM,C9_PRODUTO,C9_BLCRED,C9_BLEST,C9_REMITO,C9_SEQUEN,C9_ITEMREM,C9_ORDSEP,C9_NFISCAL,C9_SERIENF,C9_BLOQUEI"+",C9_IDDCF"+",C9_CARGA,R_E_C_N_O_ SC9RECNO "
	cQuery += "FROM "+RetSqlName("SC9")+" SC9 "
	cQuery += "WHERE SC9.C9_FILIAL='"+xFilial("SC9")+"' AND "
	cQuery += "SC9.C9_PEDIDO='"+SD2->D2_PEDIDO+"' AND "
	cQuery += "SC9.C9_ITEM='"+SD2->D2_ITEMPV+"' AND "
	cQuery += "SC9.C9_PRODUTO='"+SD2->D2_COD+"' AND "
	cQuery += "SC9.C9_NFISCAL='"+SD2->D2_DOC+"' AND "
	cQuery += "SC9.C9_SERIENF='"+SD2->D2_SERIE+"' AND  "
	cQuery += "SC9.C9_ORDSEP<>'' AND  "
	cQuery += "SC9.D_E_L_E_T_=' ' "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC9,.T.,.T.)

	While !(cAliasSC9)->(Eof()) .And. xFilial("SC9") == (cAliasSC9)->C9_FILIAL .And.;
	SD2->D2_PEDIDO == (cAliasSC9)->C9_PEDIDO .And.;
	SD2->D2_ITEMPV == (cAliasSC9)->C9_ITEM

		SC6->(DbSetOrder(1))
		SC6->(DbSeek(xFilial("SC6")+SC9->C9_PEDIDO))
		Aadd(aOrdens,{(cAliasSC9)->C9_ORDSEP})
		(cAliasSC9)->(DbSkip())
	EndDo
	(cAliasSC9)->(DbCloseArea(cAliasSC9))
	RestArea(aAreaSF2)
	RestArea(aAreaSD2)
	RestArea(aAreaSc6)

Return

