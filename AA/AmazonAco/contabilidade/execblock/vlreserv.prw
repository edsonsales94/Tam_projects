#INCLUDE "TopConn.Ch"
#INCLUDE "Protheus.Ch"
#INCLUDE "Rwmake.Ch"


User Function VlReserv(lReserva,cCondition)
Local nValor      := 0
Local aArea       := GetArea()
Local aValor      := {0,0}
Local cBusca      := ""
Local laSituac    := .F.
Local lDeleta     := .T.
Local _cdCond  := SuperGetMv("MV_XBNDES",.F.,"178")
Default lReserva      := .F.
Default cCondition    := "AAa"


cBusca := SF2->(F2_FILIAL+F2_DOC+F2_SERIE)

SD2->(dbSetOrder(3))
SD2->(DbSeek(cBusca))
While !SD2->(Eof()) .And. SD2->(D2_FILIAL+D2_DOC+D2_SERIE) == cBusca
	If ALLTRIM(substr(SD2->D2_CF,2,3)) $ "949" .and. Posicione("SF4",1,XFILIAL("SF4")+SD2->D2_TES,"F4_DUPLIC") = "S" .AND. !(ALLTRIM(SD2->D2_ORIGLAN)$"LO/VD") //Sucata em 240114
		laSituac    := .T.
	EndIf
	If(ALLTRIM(SUBSTR(SD2->D2_CF,2,3))$"101/102/401/405/107/108/109/110/403/404/122/118/119/501" .AND. !(ALLTRIM(SD2->D2_ORIGLAN)$"LO/VD")) .OR. laSituac
		
		SE1->(DBSETORDER(1))
		IF SE1->(DbSeek(XFILIAL("SE1")+SD2->D2_SERIE+SD2->D2_DOC))
			IF Alltrim(cCondition)  == "BOL"
				//aValor[1] :=  LOJABOL() DIEGO
				aValor[1] := iIF( SF2->F2_COND == _cdCond , 0 , LOJABOL() )
			ELSEIF Alltrim(cCondition)  == "CTA"
				aValor[1] := LOJACTA()
			ELSEIF Alltrim(cCondition)  == "DCA"
				aValor[1] := LOJADCA()
			ELSEIF Alltrim(cCondition)  == "REA"
				AValor[1] := LOJAREA()
			ELSE
				aValor[1] := 0
			//ELSEIF Alltrim(cCondition)  == "PIX"
			//	AValor[1] := LOJAPIX()
			ELSE
				aValor[1] := 0
			ENDIF
		ELse
			aValor[2] += SD2->D2_TOTAL + SD2->D2_ICMSRET
		ENDIF
	EndIf
	SD2->(dbSkip())
Enddo

nValor := IIF(lReserva,aValor[1],aValor[2])

RestArea(aArea)

RETURN nValor




Static Function LojaBOL()
Local nValor:= 0.00   
Local cChave:= SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM)

While !SE1->(Eof()) .and. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM) == cChave
	
	If AllTrim(SE1->E1_TIPO) $ "BO#NF#"
		nValor += SE1->E1_VALOR  //- Boleto
	Endif
	
	SE1->(DbSkip())
Enddo

Return nValor

Static Function LojaCTA()
Local nValor:= 0.00
Local cChave:= SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM)

While !SE1->(Eof()) .and. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM) == cChave
	
	If AllTrim(SE1->E1_TIPO) $ "CT#"
		nValor += SE1->E1_VALOR  //- Boleto
	Endif
	
	SE1->(DbSkip())
Enddo

Return nValor


Static Function LojaDCA()
Local nValor:= 0.00
Local cChave:= SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM)

While !SE1->(Eof()) .and. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM) == cChave
	
	If AllTrim(SE1->E1_TIPO) $ "DC#"
		nValor += SE1->E1_VALOR  //- Boleto
	Endif
	
	SE1->(DbSkip())
Enddo

Return nValor

Static Function LojaREA()
Local nValor:= 0.00
Local cChave:= SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM)

While !SE1->(Eof()) .and. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM) == cChave
	
	If AllTrim(SE1->E1_TIPO) $ "RE#"
		nValor += SE1->E1_VALOR  //- Boleto
	Endif
	
	SE1->(DbSkip())
Enddo

Return nValor

/*
Static Function LojaPIX()
Local nValor:= 0.00
Local cChave:= SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM)

While !SE1->(Eof()) .and. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM) == cChave
	
	If AllTrim(SE1->E1_TIPO) $ "PIX#"
		nValor += SE1->E1_VALOR  //- PIX
	Endif
	
	SE1->(DbSkip())
Enddo

Return nValor

*/
STATIC FUNCTION FVARRESL4(caFilial4,caOrcl4,caFormas)
Local lRetorno := .f.
Local cTable := GetNextAlias()
Local cQry   := ""

cQry += " Select Count(*) CONT From " + RetSQlName("SL4") + " SL4 "
cQry += " Where D_E_L_E_T_ = ''
cQry += " And L4_FILIAL = '" + caFilial4 + "'
cQry += " And L4_NUM = '" + caOrcl4 + "'
cQry += " And L4_FORMA in ('" + StrTran(caFormas,"|","','") + "')"

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), cTable, .T., .F. )
nRegs := (cTable)->CONT
(cTable)->(dbCloseArea(cTable))

lRetorno := nRegs > 0

Return lRetorno
