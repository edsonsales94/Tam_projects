#include "Protheus.ch"
USER Function F200VAR()
	LOCAL cTitulo  
	If cBanco == '341'
		nValRec += nDespes
		nDespes := 0
	ElseIf cBanco == "033"
		_xdArea := SE1->(GetArea())

		cBuffer := ParamIXB[1,16]   // Linha inteira que está sendo lida		
		If SubStr(cBuffer,184,10) == "0290000489"
			cConta := PADR("2900000489",TamSX3("A6_NUMCON")[1])			
		ElseIf SubStr(cBuffer,184,10) == "0290000829"
			cConta := PADR("290000829" ,TamSX3("A6_NUMCON")[1])			
		ElseIf SubStr(cBuffer,184,10) == "0130002217"
			cConta := PADR("13000221-7",TamSX3("A6_NUMCON")[1])			
		Endif
		lFound := _Find(ParamIXB[01][04])//SE1->(dbSeek(ParamIXB[01][01]))
		
		If lFound
			If SE1->E1_SALDO > 0
				SE1->(RecLock('SE1',.F.))
				SE1->E1_CONTA := cConta
				SE1->(MsUnlock())
			EndIf
		EndIf
		SE1->(RestArea(_xdArea))

	EndIf

Return


Static Function _Find(_xdNumBco)
	cQry := "SELECT SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO"
	cQry += " FROM "+RetSQLName("SE1")+" SE1"
	cQry += " WHERE SE1.D_E_L_E_T_ = ' '"
	cQry += " AND SE1.E1_FILIAL = '"+SE1->(XFILIAL("SE1"))+"'"
	cQry += " AND SE1.E1_NUMBCO = '"+_xdNumBco+"'"
	dbUseArea(.T.,"TOPCONN",tcGenQry(,,ChangeQUery(cQry)),"TMPSE1",.T.,.T.)
	If !TMPSE1->(Eof())
		SE1->(dbSetOrder(1))
		xdFound := SE1->(dbSeek(TMPSE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
    Else
        xdFound := .F.
	Endif
	dbCloseArea()
Return xdFound