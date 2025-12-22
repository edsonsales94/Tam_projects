#include 'protheus.ch'
#include 'parmtype.ch'

User Function MTA650A()


	If SC2->C2_STATUS == "U"
		Reclock("SC2", .F.)
			 SC2->C2_XSEQUEN := 99
		MsUnlock()
	EndIf
	
Return Nil

//Envia a OP Para
User Function MTA650A0(xTpOp)

    _cdUrl := 'http://192.168.1.8:83/servicebalancas.asmx?WSDL'
    
	oWsdl := TWsdlManager():New()			 

	//xRet := oWsdl:ParseFile( _cdUrl )
	xRet := oWsdl:ParseURL(_cdUrl) 
	If xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	Endif
	If xTpOp == 01
		xRet := oWsdl:SetOperation("carregarOP")
	Else
	   	xRet := oWsdl:SetOperation("suspenderOP")
	EndIf
	
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	Endif
	cData := DTOS(Date())
	cData := Left(cData,4) + "-" + SubStr(cData,5,2) + "-" + Right(cData,2)+"T"+Time()
	
	xRet := oWsdl:SetValue(0, "16G08001001")
	xRet := oWsdl:SetValue(1, "TUBO7")
	xRet := oWsdl:SetValue(2, "47000105")
	xRet := oWsdl:SetValue(3, "TEST2")
	xRet := oWsdl:SetValue(4, "2016-07-14T16:27:30")
	cdSoap := oWsdl:GetSoapMsg()
	cdPar01 := "<dadosOP>"
	cdPar01 += "<Numero_op>" + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + "</Numero_op>"
	cdPar01 += "<Maquina>" + SC2->C2_RECURSO + "</Maquina>"
	cdPar01 += "<Produto>" + SC2->C2_PRODUTO  + "</Produto>"
	cdPar01 += "<Descricao>" + POSICIONE('SB1',1,xFilial('SB1') + SC2->C2_PRODUTO,'B1_DESC') + " </Descricao>"
	cdPar01 += "<Dthr_cadastro> " + cData +" </Dthr_cadastro>"
	cdPar01 += "</dadosOP>
	
	cdSoap := StrTran(cdSoap,"<dadosOP />",cdPar01)
	//Aviso('',cdSoap,{''},3)
	xRet := oWsdl:SendSoapMsg( cdSoap )
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	Endif
	
	_xdRespXml := oWsdl:GetSoapResponse()
	//aviso('',_xdRespXml,{'OK'},3)	
Return Nil

User Function MTA650A1(_xRecurso,_xStatus,_xOp,_xCorte)
    Local aArea := GetArea()
	_ldRet := .T.
	_cdQry := ""	
	
	Default _xRecurso := If(Empty(M->C2_XLINHA),M->C2_RECURSO,M->C2_XLINHA)
	Default _xStatus  := M->C2_STATUS
	Default _xOp      := M->C2_NUM + M->C2_ITEM + M->C2_SEQUEN
	Default _xCorte   := M->C2_XCORTE
		
    Alert(_xRecurso)
	If _xStatus != 'U' .And. !Empty(_xRecurso)
	    
		_cdQry += " Select * From " + RetSqlName('SC2') + " C2 "
		_cdQry += "  Where C2.D_E_L_E_T_ = ' ' "
		_cdQry += "    And C2_STATUS != 'U' "
		_cdQry += "    And C2_RECURSO = '" + _xRecurso + "' "
		_cdQry += "    And C2_TPOP = 'F' "
		_cdQry += "    And C2_DATRF = ' ' "
		_cdQry += "    And C2_FILIAL = '" + xFilial('SC2') + "'"
		_cdQry += "    And C2_NUM+C2_ITEM+C2_SEQUEN != '" + _xOp + "' "
		_cdQry += "    And C2_XCORTE != '" + _xCorte + "'"		

		_xdTbl := MpSysOpenQuery(_cdQry)
		_cdOp  := ""
		If !(_xdTbl)->(Eof())
			_cdOp := (_xdTbl)->C2_NUM + (_xdTbl)->C2_ITEM + (_xdTbl)->C2_SEQUEN
		EndIf       

		_ldRet := Len(Alltrim(_cdOp)) == 0
		If !_ldRet
			Aviso('Atenção','Recurso: ' + Alltrim(_xRecurso) + ' Já alocado para a OP: ' + _cdOP + ' Favor Escolher outro recurso ou Encerrar a Op Em Questão',{'OK'})  
		EndIf
		conout('fechando')
		(_xdTbl)->(dbCloseArea(_xdTbl))
	EndIf
	RestArea(aArea)
Return _ldRet 
