#include "protheus.ch"

User Function MT120GRV
	Local lInclui  := PARAMIXB[2]
	Local lAltera  := PARAMIXB[3]
	Local lExclui  := PARAMIXB[4]
	//Local nTaxa    := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,NTXMOEDA)

 
	/*If lInclui
		U_FIN050INC()
	ElseIf lAltera
		U_FIN050ALT()
	ElseIf lExclui
		U_FIN050EXC()
	 EndIf
    //ALERT("OK")
	//NTXMOEDA := nTaxa */

Return .T.

USER FUNCTION FIN050INC()
	LOCAL aArray    := {}
	Local nPosTotal := aScan(aHeader, {|x| AllTrim(x[2])=="C7_TOTAL"})
	Local nDataPrf  := aScan(aHeader, {|x| AllTrim(x[2])=="C7_DATPRF"})
	Local DataPrf   := aCols[1,nDataPrf]
	Local nTotal    := 0
	Local nValor    := 0
	Local cChar     := ","
	Local _cAux     := ""
	Local nP        := 0
	Local cCondPag  := Array(16)
	Local I         := 0
	Local nLinha    := 0
	Local nCont     := 0
	Local nPrazo	:= 0

	DbSelectArea("SE4") 
	DbSetOrder(1)
	DbSeek(xFilial("SE4")+CCONDICAO)

	_cAux := ALLTRIM(SE4->E4_COND)     

	For I := 1 To 16 Step 1
		If SubStr(_cAux,nP,AT(cChar,_cAux)-1) != ""
			nCont := nCont + 1
		EndIf
		nP := AT(cChar,_cAux) + 1
		_cAux := SubStr(_cAux,nP)
		nP := 1
	Next

	nCont := nCont + 1

	_cAux := ALLTRIM(SE4->E4_COND)

	For I := 1 To nCont Step 1
		cCondPag[I]  := SubStr(_cAux,nP,AT(cChar,_cAux)-1)
		If SubStr(_cAux,nP,AT(cChar,_cAux)-1) == ""
			cCondPag[I] := _cAux
		EndIf
		nP := AT(cChar,_cAux) + 1
		_cAux := SubStr(_cAux,nP)
		nP := 1
	Next

	For nLinha := 1 to Len(aCols)
		// Verifica somente linhas nao deletadas
		If !aCols[nLinha][Len(aHeader)+1]    
			nValor := nValor + aCols[nLinha,nPosTotal]
		Endif
	Next nLinha

	nTotal := nValor/nCont 

	PRIVATE lMsErroAuto := .F.

	For I := 1 To nCont Step 1 
		nPrazo := VAL(cCondPag[I])-1 
		aArray := { { "E2_PREFIXO"  , "CMP"    	, NIL },;
		{ "E2_NUM"      , PARAMIXB[1]       	, NIL },;
		{ "E2_PARCELA"  , I				    	, NIL },;
		{ "E2_TIPO"     , "PR"              	, NIL },;
		{ "E2_NATUREZ"  , "212234"       		, NIL },;
		{ "E2_FORNECE"  , CA120FORN    			, NIL },;
		{ "E2_EMISSAO"  , DDATABASE         	, NIL },;
		{ "E2_VENCTO"   , DataPrf + nPrazo		, NIL },;
		{ "E2_VENCREA"  , DataPrf + nPrazo   	, NIL },;
		{ "E2_VALOR"    , nTotal     					, NIL },;
		{ "E2_HIST"   	, "TITULO INCLUIDO PELO MODULO DE COMPRAS"     		, NIL } }

		MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
		If lMsErroAuto
			MostraErro()
		Endif
	Next 

	If lMsErroAuto
		MostraErro()
	Else
		Alert("Título(s) Provisório(s) incluído(s) com sucesso!")
	Endif

Return

//------------------------------------------------------------------------------------------------------------------------

USER FUNCTION FIN050ALT()
	LOCAL aArray := {}
	Local nPosTotal := aScan(aHeader, {|x| AllTrim(x[2])=="C7_TOTAL"})
	Local nTotal    := 0
	Local nValor    := 0
	Local cParcela  := ""
	Local cChar     := ","
	Local _cAux     := ""
	Local nP        := 0
	Local nCont     := 0
	Local I         := 0
	Local lOK       := .T.
	Local cEmp      := cEmpAnt

	DbSelectArea("SE4") 
	DbSetOrder(1)
	DbSeek(xFilial("SE4")+CCONDICAO)

	_cAux := ALLTRIM(SE4->E4_COND)     

	For I := 1 To 16 Step 1
		If SubStr(_cAux,nP,AT(cChar,_cAux)-1) != ""
			nCont := nCont + 1
		EndIf
		nP := AT(cChar,_cAux) + 1
		_cAux := SubStr(_cAux,nP)
		nP := 1
	Next

	nCont := nCont + 1

	For nLinha := 1 to Len(aCols)
		// Verifica somente linhas nao deletadas
		If !aCols[nLinha][Len(aHeader)+1]    
			nValor := nValor + aCols[nLinha,nPosTotal]
		Endif
	Next nLinha

	nTotal := nValor/nCont

	PRIVATE lMsErroAuto := .F.

	For I := 1 To nCont Step 1 
		If cEmp == "10"
			cParcela := PadR(cValToChar(I),3)
		else
			cParcela := Trim(PadR(cValToChar(I),3))
		EndIf
		DbSelectArea("SE2") 
		DbSetOrder(1)
		If DbSeek(xFilial("SE2")+"CMP"+PadR(PARAMIXB[1],9)+cParcela+"PR")
			aArray := { { "E2_PREFIXO" , SE2->E2_PREFIXO , NIL },;
			{ "E2_NUM"     , SE2->E2_NUM     , NIL },;
			{ "E2_PARCELA" , SE2->E2_PARCELA , NIL },;
			{ "E2_TIPO"    , SE2->E2_TIPO    , NIL },;
			{ "E2_VALOR"   , nTotal          , NIL } }  

			MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 4)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

			If lMsErroAuto
				MostraErro()
			EndIf
		Else
			alert("CMP"+PadR(PARAMIXB[1],9)+PadR(cValToChar(I),3)+"PR")
			lOK := .F.
			Alert("Título(s) Provisório(s) não Encontrado(s) no Financeiro.")
		EndIf
	Next

	If lOK
		Alert("Título(s) Provisório(s) alterado(s) com sucesso!")
	Endif

Return

//------------------------------------------------------------------------------------------------------------------------

USER FUNCTION FIN050EXC()
	Local aArray := {}
	Local nCont  := 0
	Local cChar     := ","
	Local cParcela  := ""
	Local _cAux     := ""
	Local nP        := 0
	Local lOK       := .T.
    Local cEmp      := cEmpAnt
    
	DbSelectArea("SE4") 
	DbSetOrder(1)
	DbSeek(xFilial("SE4")+CCONDICAO)

	_cAux := ALLTRIM(SE4->E4_COND)     

	For I := 1 To 16 Step 1
		If SubStr(_cAux,nP,AT(cChar,_cAux)-1) != ""
			nCont := nCont + 1
		EndIf
		nP := AT(cChar,_cAux) + 1
		_cAux := SubStr(_cAux,nP)
		nP := 1
	Next

	nCont := nCont + 1

	PRIVATE lMsErroAuto := .F.

	For I := 1 To nCont Step 1      
		If cEmp == "10"
			cParcela := PadR(cValToChar(I),3)
		else
			cParcela := Trim(PadR(cValToChar(I),3))
		EndIf
		
		DbSelectArea("SE2") 
		DbSetOrder(1)
		If DbSeek(xFilial("SE2")+"CMP"+PadR(PARAMIXB[1],9)+cParcela+"PR") //Exclusão deve ter o registro SE2 posicionado

			aArray := { { "E2_PREFIXO" , SE2->E2_PREFIXO , NIL },;
			{ "E2_NUM"     , SE2->E2_NUM     , NIL },;
			{ "E2_PARCELA" , SE2->E2_PARCELA , NIL },;
			{ "E2_TIPO"    , SE2->E2_TIPO    , NIL } }

			MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 5)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

			If lMsErroAuto
				MostraErro()
			EndIf
		Else
			lOK := .F.
		EndIf
	Next 

	If lOK
		Alert("Exclusão do(s) Título(s) Provisório(s) realizada com sucesso!")
	Endif

Return
