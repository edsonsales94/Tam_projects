#Include "Totvs.ch"

#Define CHECKBOX	1
#Define ARMAZEM		2
#Define DESCRICAO	3

Static cLocal := Space(50)

/*/{Protheus.doc} HLAPCP03

Rotina responsável pela seleção do armazens para o cálculo do MRP

@author 	Ectore Cecato - Totvs IP Jundiaí
@since 		29/07/2019
@version 	Protheus 12 - PCP

/*/

User Function HLAPCP03()

	Local aArmazem	:= {}
	Local aItem		:= {}
	Local cAliasQry	:= GetNextAlias()
	Local cQuery	:= ""
	Local cArmazem	:= Space(50)
	Local oDlg		:= Nil
	Local oOk 		:= LoadBitmap( GetResources(), "LBOK")
	Local oNo 		:= LoadBitmap( GetResources(), "LBNO")
	
	Private lMarcado	:= .F.

	cQuery := "SELECT "+ CRLF
	cQuery += "		NNR.NNR_CODIGO, NNR.NNR_DESCRI "+ CRLF
	cQuery += "FROM "+ RetSqlTab("NNR") +" "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("NNR") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("NNR") +" "+ CRLF
	cQuery += "ORDER BY "+ CRLF
	cQuery += "		NNR.NNR_CODIGO "
	cQuery := ChangeQuery(cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	While !(cAliasQry)->(Eof())
		
		aItem := {}
		
		aAdd(aItem, .F.)
		aAdd(aItem, AllTrim((cAliasQry)->NNR_CODIGO))
		aAdd(aItem, AllTrim((cAliasQry)->NNR_DESCRI))
		
		aAdd(aArmazem, aItem)

		(cAliasQry)->(DbSkip())
			
	Enddo
	
	(cAliasQry)->(DbCloseArea())
	
	If !Empty(aArmazem)
	
		oDlg := MSDialog():New(10, 10, 300, 310, "Armazéns",,,,,,,,, .T.)

		oBrowse := TCBrowse():New(5, 5, 143, 120,,,, oDlg,,,,, {||},,,,,,, .F.,, .T.,, .F.,,,) 

		oBrowse:SetArray(aArmazem) 
		oBrowse:AddColumn(TCColumn():New(" ", 			{|| If(aArmazem[oBrowse:nAt, CHECKBOX], oOk, oNo)},,,, 	"LEFT", 10, .T., .T.))
		oBrowse:AddColumn(TCColumn():New("Código", 		{|| aArmazem[oBrowse:nAt, ARMAZEM] },,,, 				"LEFT", 18))
		oBrowse:AddColumn(TCColumn():New("Descrição", 	{|| aArmazem[oBrowse:nAt, DESCRICAO] },,,, 				"LEFT", 50))

		oBrowse:bHeaderClick := {|o,x| MarcaTodos(@aArmazem), oBrowse:Refresh()}
		oBrowse:bLDblClick := {|z,x| aArmazem[oBrowse:nAt, 1] := AlteraChk(aArmazem[oBrowse:nAt, 1])}

		TButton():New(130, 79, "Confirmar", oDlg, {|| SelArm(aArmazem, @cArmazem), oDlg:End()}, 30, 12,,,, .T.)
		TButton():New(130, 117, "Fechar", oDlg, {|| oDlg:End()}, 30, 12,,,, .T.)

		oDlg:Activate(,,, .T.)

	Else
		Aviso("Atenção", "Não existem armazém cadastrado", {"Ok"})
	Endif

	cLocal := cArmazem

Return .T.

Static Function SelArm(aArmazem, cArmazem)

	Local nItem := 0

	cArmazem := ""

	For nItem := 1 To Len(aArmazem)

		If aArmazem[nItem, CHECKBOX]

			If !Empty(cArmazem)
				cArmazem += ","
			EndIf
			
			cArmazem += "'"+ aArmazem[nItem, ARMAZEM] +"'" 

		Endif

	Next nItem

Return Nil

Static Function AlteraChk(lChk)

	If lChk == .T.
		lChk := .F.
	Else
		lChk := .T.
	Endif

Return lChk

Static Function MarcaTodos(aArmazem)

	Local nItem := 0

	If lMarcado == .T.

		For nItem := 1 To Len(aArmazem)
			aArmazem[nItem, CHECKBOX] := .F.
		Next nItem

		lMarcado := .F.

	Else

		For nItem := 1 To Len(aArmazem)
			aArmazem[nItem, CHECKBOX] := .T.
		Next nItem 

		lMarcado := .T.

	Endif

Return Nil

User Function RetLoc()

Return cLocal
