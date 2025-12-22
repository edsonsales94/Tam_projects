#include 'protheus.ch'
#include 'parmtype.ch'

User Function FVGPEE02()

	Private _xdMat    := Space(Len(SRA->RA_MAT))
	Private _xdNome   := ""
	Private _xdData   := dDataBase
	Private _xdVerba  := Space(Len(SRV->RV_COD))
	Private _xdCodV   := Space(Len(SRV->RV_COD))
	Private _xdCodFol := Space(Len(SRV->RV_CODFOL))
	Private _xdDescr  := ""
    Private _xdTipo1  := Space(Len(SRC->RC_TIPO1))
    Private _xdNTipo1 := Space(Len(SRC->RC_TIPO1))		
    Private _xdTipo2  := Space(Len(SRC->RC_TIPO2))
    Private _xdNTipo2 := Space(Len(SRC->RC_TIPO2))
	Private _xdValor  := 0
	Private _xdNValor := 0
	Private _xdDif    := 0

	Private odMat    := Nil
	Private odNome   := Nil
	Private odData   := Nil
	Private odVerba  := Nil
    Private odDescr  := Nil
    Private odTipo1  := Nil	
    Private odNTipo1 := Nil	
    Private odTipo2  := Nil
    Private odNTipo2 := Nil	
	Private odValor  := Nil	    
	Private odNValor := Nil
	Private odDif    := Nil

	oDlg     := TDialog():New(050,050,550,700,'....',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1    := TSay():New(005, 005,{||'Matricula'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odMat    := TGet():New(015, 005,{ | u | If( PCount() == 0, _xdMat, _xdMat := u ) },oDlg,060, 012, "@!",{|| _xdNome := Posicione('SRA',1,xFilial('SRA') + _xdMat,'RA_NOME') ,_getValue() }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdMat",,,,.T.)
	odMat    :cF3 := "SRA"

	oSay1    := TSay():New(005, 065,{||'Nome Funcionario'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odNom    := TGet():New(015, 065,{ | u | If( PCount() == 0, _xdNome, _xdNome := u ) },oDlg,260, 012, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdNome",,,,.T.)
	odNom    :bWhen := {|| .F.}
	/* oSay1 := TSay():New(035, 005,{||'Data'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odData:= TGet():New(045, 005,{ | u | If( PCount() == 0, _xdData, _xdData := u ) },oDlg,060, 012, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdData",,,,.T.)
	*/

	oSay1    := TSay():New(065, 005,{||'Verba'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odVerba  := TGet():New(075, 005, { | u | If( PCount() == 0, _xdVerba, _xdVerba := u ) },oDlg,060, 010, "@!",{|| _xdDescr := Posicione('SRV',1,xFilial('SRV') + _xdVerba,'RV_DESC'), _getValue() }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdVerba",,,,.T.)
	odVerba  :cF3 := "SRV"

	oSay1    := TSay():New(065, 065,{||'Descrição'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odDescr  := TGet():New(075, 065,{ | u | If( PCount() == 0, _xdDescr, _xdDescr := u ) },oDlg,260, 012, "@!",{|| _getValue() }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdDescr",,,,.T.)
	odDescr  :bWhen := {|| .F.}

	oSay1    := TSay():New(095, 005,{||'Valor'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odValor  := TGet():New(105, 005, { | u | If( PCount() == 0, _xdValor, _xdValor := u ) },oDlg,060, 010, "@E 999,999,999.99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdValor",,,,.T.)
	odValor  :bWhen := {|| .F.}

	oSay1    := TSay():New(095, 065,{||'Origem'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odTipo2  := TGet():New(105, 065, { | u | If( PCount() == 0, _xdTipo2, _xdTipo2 := u ) },oDlg,060, 010, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdTipo2",,,,.T.)
	odTipo2  :bWhen := {|| .F.}

	oSay1    := TSay():New(095, 125,{||'Tipo'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odTipo1  := TGet():New(105, 125, { | u | If( PCount() == 0, _xdTipo1, _xdTipo1 := u ) },oDlg,060, 010, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdTipo1",,,,.T.)
	odTipo1  :bWhen := {|| .F.}

	oSay1    := TSay():New(125, 005,{||'* Valor'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odNValor := TGet():New(135, 005, { | u | If( PCount() == 0, _xdNValor, _xdNValor := u ) },oDlg,060, 010, "@E 999,999,999.99",{||  _xdDif := _xdNvalor - _xdvalor }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdNValor",,,,.T.)

	oSay1    := TSay():New(125, 065,{||'* Origem'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odNTipo2 := TGet():New(135, 065, { | u | If( PCount() == 0, _xdNTipo2, _xdNTipo2 := u ) },oDlg,060, 010, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdNTipo2",,,,.T.)

	oSay1    := TSay():New(125, 125,{||'* Tipo'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odNTipo1 := TGet():New(135, 125, { | u | If( PCount() == 0, _xdNTipo1, _xdNTipo1 := u ) },oDlg,060, 010, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdNTipo1",,,,.T.)

	oSay1    := TSay():New(155, 005,{||'Diferenca ( * Valor - Valor)'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,10)
	odDif    := TGet():New(165, 005, { | u | If( PCount() == 0, _xdDif, _xdDif := u ) },oDlg,060, 010, "@E 999,999,999.99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_xdDif",,,,.T.)
	odDif    :bWhen := {|| .F.}

	odOk := TButton():New( 185, 005, "Alterar",oDlg,{|| _doChange() }, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )   

	// ativa diálogo centralizado
	oDlg:Activate(,,,.T.,{||.T.},,{|| /*msgstop('iniciando')*/ } )

Return 

Static Function _doChange()

	SRC->(dbSetOrder(1))
	If SRC->(dbSeek(xFilial('SRC') + _xdMat + _xdVerba ))
		SRC->(RecLock('SRC',.F.))
		SRC->RC_VALOR := _xdNValor
		SRC->RC_TIPO1 := _xdNTipo1
		SRC->RC_TIPO2 := _xdNTipo2
		SRC->(MsUnlock())
	EndIf

	If _xdCodFol == "0064" // desconto inss folha
        _xdCodV := ""
	    SRV->(dbSetOrder(2))
	    If SRV->(dbSeek(xFilial('SRV') + "0167" )) // Pesquisa qual é a verba de ded inss ir fol
		    _xdCodV  := SRV->RV_COD
	    EndIf
		If SRC->(dbSeek(xFilial('SRC') + _xdMat + _xdCodV )) // Atualiza valor da verba de ded inss ir fol
			SRC->(RecLock('SRC',.F.))
		    SRC->RC_TIPO2 := _xdNTipo2
			SRC->RC_VALOR := _xdNValor
			SRC->(MsUnlock())
		EndIf

        _xdCodV := ""
	    If SRV->(dbSeek(xFilial('SRV') + "0015" )) // Pesquisa qual é a verba de bs ir fol
		    _xdCodV  := SRV->RV_COD
	    EndIf                                                                               
		
		If SRC->(dbSeek(xFilial('SRC') + _xdMat + _xdCodV )) // Atualiza valor da verba de bs ir fol
			SRC->(RecLock('SRC',.F.))
		    SRC->RC_TIPO2 := _xdNTipo2
			SRC->RC_VALOR := SRC->RC_VALOR - _xdDif
			SRC->(MsUnlock())
		EndIf

        _xdCodV := ""
	    If SRV->(dbSeek(xFilial('SRV') + "0059" )) // Pesquisa qual é a verba de ded dep fol/adt
		    _xdCodV  := SRV->RV_COD
	    EndIf                                                                               
		
		If SRC->(dbSeek(xFilial('SRC') + _xdMat + _xdCodV )) // Atualiza tipo da verba de ded dep fol/adt
			SRC->(RecLock('SRC',.F.))
		    SRC->RC_TIPO2 := _xdNTipo2
			SRC->(MsUnlock())
		EndIf		

        _xdCodV := ""
//	    If SRV->(dbSeek(xFilial('SRV') + "0047" )) // Pesquisa qual é a verba de liquido da folha
	    If SRV->(dbSeek(xFilial('SRV') + "0043" )) // Pesquisa qual é a verba de arred da folha
		    _xdCodV  := SRV->RV_COD
	    EndIf                                                                               
		
		If SRC->(dbSeek(xFilial('SRC') + _xdMat + _xdCodV ))// Atualiza valor da verba de arred folha //liquido da folha
			SRC->(RecLock('SRC',.F.)) 
		    SRC->RC_TIPO2 := _xdNTipo2
//			SRC->RC_VALOR := SRC->RC_VALOR - _xdDif
			SRC->RC_VALOR := SRC->RC_VALOR + _xdDif
			SRC->(MsUnlock())
		EndIf

	EndIf

	If _xdCodFol == "0066" // Desconto ir folha
        _xdCodV := ""
	    If SRV->(dbSeek(xFilial('SRV') + "0015" )) // Pesquisa qual é a verba de bs ir fol
		    _xdCodV  := SRV->RV_COD
	    EndIf                                                                               
		
		If SRC->(dbSeek(xFilial('SRC') + _xdMat + _xdCodV )) // Atualiza o tipo da verba de bs ir fol
			SRC->(RecLock('SRC',.F.))
		    SRC->RC_TIPO2 := _xdNTipo2
			SRC->(MsUnlock())
		EndIf

        _xdCodV := ""
	    If SRV->(dbSeek(xFilial('SRV') + "0059" )) // Pesquisa qual é a verba de ded dep fol/adt
		    _xdCodV  := SRV->RV_COD
	    EndIf                                                                               
		
		If SRC->(dbSeek(xFilial('SRC') + _xdMat + _xdCodV )) // Atualiza tipo da verba de ded dep fol/adt
			SRC->(RecLock('SRC',.F.))
		    SRC->RC_TIPO2 := _xdNTipo2
			SRC->(MsUnlock())
		EndIf		

        _xdCodV := ""
//	    If SRV->(dbSeek(xFilial('SRV') + "0047" )) // Pesquisa qual é a verba de liquido da folha
	    If SRV->(dbSeek(xFilial('SRV') + "0043" )) // Pesquisa qual é a verba de arred da folha
		    _xdCodV  := SRV->RV_COD
	    EndIf                                                                               
		
		If SRC->(dbSeek(xFilial('SRC') + _xdMat + _xdCodV ))// Atualiza valor da verba de arred folha // liquido da folha
			SRC->(RecLock('SRC',.F.))
		    SRC->RC_TIPO2 := _xdNTipo2
			SRC->RC_VALOR := SRC->RC_VALOR - _xdDif
			SRC->(MsUnlock())
		EndIf

	EndIf

	If _xdCodFol == "0007" // desconto adt sal
        _xdCodV := ""
	    SRV->(dbSetOrder(2))
	    If SRV->(dbSeek(xFilial('SRV') + "0008" )) // Pesquisa qual é a verba de desc arred adt sal
		    _xdCodV  := SRV->RV_COD
	    EndIf
		If SRC->(dbSeek(xFilial('SRC') + _xdMat + _xdCodV )) // Atualiza valor da verba de desc adt sal
			SRC->(RecLock('SRC',.F.))
		    SRC->RC_TIPO2 := _xdNTipo2
			SRC->RC_VALOR := SRC->RC_VALOR - _xdDif
			SRC->(MsUnlock())
		EndIf

        _xdCodV := ""
	    If SRV->(dbSeek(xFilial('SRV') + "0010" )) // Pesquisa qual é a verba de bs ir adt
		    _xdCodV  := SRV->RV_COD
	    EndIf                                                                               
		
		If SRC->(dbSeek(xFilial('SRC') + _xdMat + _xdCodV )) // Atualiza valor da verba de bs ir adt
			SRC->(RecLock('SRC',.F.))
		    SRC->RC_TIPO2 := _xdNTipo2
			SRC->RC_VALOR := SRC->RC_VALOR + _xdDif
			SRC->(MsUnlock())
		EndIf

	EndIf
	
	If _xdCodFol == "0012" // desconto IR adt sal
        _xdCodV := ""
	    SRV->(dbSetOrder(2))
	    If SRV->(dbSeek(xFilial('SRV') + "0008" )) // Pesquisa qual é a verba de desc arred adt sal
		    _xdCodV  := SRV->RV_COD
	    EndIf
		If SRC->(dbSeek(xFilial('SRC') + _xdMat + _xdCodV )) // Atualiza valor da verba de desc adt sal
			SRC->(RecLock('SRC',.F.))
		    SRC->RC_TIPO2 := _xdNTipo2
			SRC->RC_VALOR := SRC->RC_VALOR + _xdDif
			SRC->(MsUnlock())
		EndIf

	EndIf	
	
	_xdCodV   := ""
	_xdCodFol := ""                                                                             
	
	_xdDescr  := ""
    _xdTipo1  := ""
    _xdNTipo1 := ""		
    _xdTipo2  := ""
    _xdNTipo2 := "I"
	_xdValor  := 0
	_xdNValor := 0
	_xdDif    := 0

Return Nil

Static Function _getValue()     
    xdCodFol := ''
	SRV->(dbSetOrder(1))
	If SRV->(dbSeek(xFilial('SRV') + _xdVerba ))
		_xdCodFol  := SRV->RV_CODFOL
	EndIf

	SRC->(dbSetOrder(1))
	If SRC->(dbSeek(xFilial('SRC') + _xdMat + _xdVerba ))
		_xdTipo1   := SRC->RC_TIPO1
		_xdTipo2   := SRC->RC_TIPO2
		_xdValor   := SRC->RC_VALOR

		_xdNTipo1  := _xdTipo1
		_xdNTipo2  := "I"
		_xdNValor  := _xdValor
		_xdDif     := _xdValor

		odTipo1:Refresh()
		odNTipo1:Refresh()
		odTipo2:Refresh()
		odNTipo2:Refresh()
		odValor:Refresh()
		odNValor:Refresh()
		odDif:Refresh()
	EndIf

	_xdOK := .T.

Return _xdOk 