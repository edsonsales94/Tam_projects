#include 'protheus.ch'
#include 'parmtype.ch'

User Function FVGPEE01()

	Private _xdMat    := Space(Len(SRA->RA_MAT))
	Private _xdData   := dDataBase
	Private _xdVerba  := Space(Len(SRV->RV_COD))
	Private _xdDesc   := Space(Len(SRV->RV_DESC))
	Private _xdCodFol := Space(Len(SRV->RV_CODFOL))
	Private _xdValor  := 00
	Private _xdNValor := 00
	Private _xdDif    := 00
	Private _xdNome   := ""

	Private odVerba   := Nil
	Private odDesc    := Nil
	Private odMAt     := Nil
	Private odData    := Nil
	Private odValor   := Nil
	Private odNValor  := Nil
	Private odDif     := Nil
	Private odNom     := Nil

	oDlg := TDialog():New(050,050,550,700,'Exemplo TDialog',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(005, 005,{||'Matricula'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odMat := TGet():New(015, 005,{ | u | If( PCount() == 0, _xdMat, _xdMat := u ) },oDlg,060, 012, "@!",{|| _xdNome := Posicione('SRA',1,xFilial('SRA') + _xdMat,'RA_NOME') ,_getValue() }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdMat",,,,.T.)
	odMat:cF3 := "SRA"

	oSay1 := TSay():New(005, 065,{||'Nome Funcionario'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odNom := TGet():New(015, 065,{ | u | If( PCount() == 0, _xdNome, _xdNome := u ) },oDlg,260, 012, "@!",{|| _getValue() }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdNome",,,,.T.)

	oSay1 := TSay():New(035, 005,{||'Data'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odData:= TGet():New(045, 005,{ | u | If( PCount() == 0, _xdData, _xdData := u ) },oDlg,060, 012, "@d",{|| _getValue() }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdData",,,,.T.)

	oSay1   := TSay():New(065, 005,{||'Verba'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odVerba := TGet():New(075, 005, { | u | If( PCount() == 0, _xdVerba, _xdVerba := u ) },oDlg,060, 010, "@!",{|| _xdDesc := Posicione('SRV',1,xFilial('') + _xdVerba,'RV_DESC') , _getValue() }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdVerba",,,,.T.)
	odVerba:cF3 := "SRV"

	oSay1 := TSay():New(065, 065,{||'Descrição'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odNom := TGet():New(075, 065,{ | u | If( PCount() == 0, _xdDesc, _xdDesc := u ) },oDlg,260, 012, "@!",{|| _getValue() }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdDesc",,,,.T.)

	oSay1 := TSay():New(095, 005,{||'Valor'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odValor := TGet():New( 105, 005, { | u | If( PCount() == 0, _xdValor, _xdValor := u ) },oDlg,060, 010, "@E 999,999,999.99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdValor",,,,.T.)
	odValor:bWhen := {|| .F.}

	oSay1 := TSay():New(125, 005,{||'Novo Valor'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odNValor := TGet():New( 135, 005, { | u | If( PCount() == 0, _xdNValor, _xdNValor := u ) },oDlg,060, 010, "@E 999,999,999.99",{||  _xdDif := _xdNvalor - _xdvalor }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdNValor",,,,.T.)

	oSay1 := TSay():New(155, 005,{||'Diferenca ( Novo Valor - Valor)'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odDif := TGet():New( 165, 005, { | u | If( PCount() == 0, _xdDif, _xdDif := u ) },oDlg,060, 010, "@E 999,999,999.99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdDif",,,,.T.)
	odDif:bWhen := {|| .F.}

	odOk := TButton():New( 185, 005, "Alterar",oDlg,{|| _doChange() }, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )   

	// ativa diálogo centralizado
	oDlg:Activate(,,,.T.,{||.T.},,{|| /*msgstop('iniciando')*/ } )

Return 

Static Function _doChange()

	SRR->(dbSetOrder(1))
	If SRR->(dbSeek(xFilial('SRR') + _xdMat + "R" + DTOS(_xdData) + _xdVerba ))	   
		SRR->(RecLock('SRR',.F.))
		SRR->RR_VALOR := _xdNValor
		SRR->(MsUnlock())	   
	EndIf

	If _xdVerba == "504"

		If SRR->(dbSeek(xFilial('SRR') + _xdMat + "R" + DTOS(_xdData) + "847" ))//SRC->(dbSeek(xFilial('SRC') + _xdMat + "846" ))	   
			SRR->(RecLock('SRR',.F.))
			SRR->RR_VALOR := _xdNValor
			SRR->(MsUnlock())	   
		EndIf
		If SRR->(dbSeek(xFilial('SRR') + _xdMat + "R" + DTOS(_xdData) + "755" ))//SRC->(dbSeek(xFilial('SRC') + _xdMat + "846" ))	   
			SRR->(RecLock('SRR',.F.))
			SRR->RR_VALOR := SRR->RR_VALOR - _xdDif
			SRR->(MsUnlock())	   
		EndIf
		
		If SRR->(dbSeek(xFilial('SRR') + _xdMat + "R" + DTOS(_xdData) + "537" ))//SRC->(dbSeek(xFilial('SRC') + _xdMat + "846" ))	   
			SRR->(RecLock('SRR',.F.))
			SRR->RR_VALOR := SRR->RR_VALOR - _xdDif
			SRR->(MsUnlock())	   
		EndIf

	EndIf
	
	If _xdVerba == "505"

		If SRR->(dbSeek(xFilial('SRR') + _xdMat + "R" + DTOS(_xdData) + "845" ))//SRC->(dbSeek(xFilial('SRC') + _xdMat + "846" ))	   
			SRR->(RecLock('SRR',.F.))
			SRR->RR_VALOR := _xdNValor
			SRR->(MsUnlock())	   
		EndIf
		If SRR->(dbSeek(xFilial('SRR') + _xdMat + "R" + DTOS(_xdData) + "751" ))//SRC->(dbSeek(xFilial('SRC') + _xdMat + "846" ))	   
			SRR->(RecLock('SRR',.F.))
			SRR->RR_VALOR := SRR->RR_VALOR - _xdDif
			SRR->(MsUnlock())	   
		EndIf
		
		If SRR->(dbSeek(xFilial('SRR') + _xdMat + "R" + DTOS(_xdData) + "537" ))//SRC->(dbSeek(xFilial('SRC') + _xdMat + "846" ))	   
			SRR->(RecLock('SRR',.F.))
			SRR->RR_VALOR := SRR->RR_VALOR - _xdDif
			SRR->(MsUnlock())	   
		EndIf

	EndIf	

Return Nil


Static Function _getValue()

	SRR->(dbSetOrder(1))
	If SRR->(dbSeek(xFilial('SRR') + _xdMat + "R" + DTOS(_xdData) + _xdVerba ))
		_xdValor   := SRR->RR_VALOR
		_xdNValor  := 0
		_xdDif     := _xdValor

		odValor:Refresh()
		odNValor:Refresh()
		odDif:Refresh()
	EndIf

	_xdOK := .T.	 
Return _xdOk 