/*/{protheus.doc}MA010FIL
Ponto de Entrada no cadastro de produto - realiza filtro
@Author Leandro Nascimento 
@since 30/08/2013
@Obs Leandro Nasc  em 30/08/13 Realizada Validacaoes para WF de Produtos 
/*/

User Function MA010FIL()

Local cFiltro := ""
Local cCodUsr := RetCodUsr()
Local aGrupos := UsrRetGrp(cCodUsr)
Local cUser   := UsrRetName(cCodUsr)

//Grupo que o usuario pertence
Local lCompras 	:= .F.
Local lPcp 		:= .F.
Local lFiscal 	:= .F.
Local lContabilidade 	:= .F.
Local lClassificador	:= .F.
Local lUtilizaWF	:= GetMv( "HL_WFPROD" ) //Indica se Utiliza o WF de Produtos

If lUtilizaWF
	
	For i= 1 to len(aGrupos)
		If aGrupos[i] == "000001" 	//Grupo Compras
			lCompras := .T.
			lClassificador := .T.
			cFiltro := "SB1->B1_ZZNIVWF  == '2' "
		ElseIf 	aGrupos[i] == "000002" 	//Grupo PCP
			lPcp := .T.
			lClassificador := .T.
			cFiltro := "SB1->B1_ZZNIVWF  == '3' "
		ElseIf 	aGrupos[i] == "000003" 	//Grupo Fiscal
			lFiscal := .T.
			lClassificador := .T.
			cFiltro := "SB1->B1_ZZNIVWF  == '4' "
		ElseIf 	aGrupos[i] == "000004" 	//Grupo Cotabilidade
			lContabilidade := .T.
			lClassificador := .T.
			cFiltro := "SB1->B1_ZZNIVWF  == '5' "
		Endif
	Next i
	
	If lClassificador
		If Aviso('Workflow', 'Deseja Filtrar os Produtos pendentes do seu grupo de Classificação WorkFlow?', {'Sim', 'Nao'}) == 1
			Return (cFiltro)
		Endif
	Endif
	
Endif
Return (Nil)
