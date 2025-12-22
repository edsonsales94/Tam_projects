#include "Protheus.CH"
#include "Topconn.ch"
#include "RwMake.ch"

Static aCabec := {" ", "Puxada", "Num PacList", "Num NF", "Serie NF", "Quant NF", "Quant Puxada", "Saldo Transito", "Loja", "Fornecedor", "Valor",;
						"Dt.Puxada", "Hr.Puxada"}
Static aItems := {}

/*____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦|¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+---------+----------------+-------+------------+¦¦
¦¦¦ Programa  ¦ AAESTC04   ¦ Autor   ¦ Nilson Neto    ¦ Data  ¦ 17/03/2012 ¦¦¦
¦¦+-----------+------------+---------+----------------+-------+------------+¦¦
¦¦¦ Descriçäo ¦ Consulta de Puxadas por Motorista                          ¦¦¦
¦¦+-----------+------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAESTC04(cMotor,aPos,oConsPux,lTudo,lCriaTela)
	Local aArea := GetArea()
	Local lRet  := .T.
	
	If aPos == Nil
		ViewMotorista()
	Else
		lRet := ViewPuxadas(cMotor,aPos,oConsPux,lTudo,lCriaTela)
	Endif
	
	RestArea(aArea)
Return lRet

//-------------------------------------------------------------------
//-        Função de Montagem da ConsultaMotorista da Consulta      -
//-      Desenvolvida por: Nilson Neto          Data: 29/07         -
//-------------------------------------------------------------------
Static Function ViewMotorista()
	/*  Objetos  */
	Local oConsMot
	Local oLstBox
	Local oCmbType
	Local oGetSearch
	Local oOk     := LoadBitmap(GetResources(), "BR_VERDE" )
	Local oNo     := LoadBitmap(GetResources(), "BR_VERMELHO" )
	
	/*  Variáveis de ConsultaMotorista  */
	Local aChaves := {}
	Local aItens  := {}
	Local cType   := space(20)
	Local cPesq   := space(20)
	Local cTitle  := "Consulta Puxadas por Motorista"                                               
	
	Private aMotor := {}
	
	aAdd(aItens, "Código do Motorista")
	aAdd(aItens, "Nome do Motorista")
	aAdd(aItens, "Matrícula do Motorista")
	aAdd(aItens, "Placa do Veículo")
	
	SearchMotor("","",aItens)
	
	DEFINE FONT oFontMot NAME "MS Sans Serif" SIZE 0, -9 BOLD
	
	Define MsDialog oConsMot Title cTitle From 5,15 To 45,145 of oMainWnd
		
		@015, 15 Say "Tipo: "      Font oFontMot            Size 035,08 of oConsMot Pixel
		@015, 50 ComboBox oCmbType Var cType Items aItens   Size 100,50 of oConsMot Pixel
		
		@030, 15 Say "Pesquisar: " Font oFontMot	        Size 035,08 of oConsMot Pixel
		@030, 50 MsGet oGetSearch Var cPesq Picture "@!"    Size 220,10 of oConsMot Pixel            
		
		@030, 300 Button "Pesquisar" Font oFontMot	        Size 035,08 of oConsMot Pixel Action SearchMotor(cType,cPesq,aItens)
		
		@020, 001 LISTBOX oLstBox VAR cVar ;
	   FIELDS HEADER " ", "Código", "Nome do Motorista", "Matrícula", "Placa Veic", "Valor Total";
	   SIZE 374, 181 OF oConsMot PIXEL ON dblClick(ViewPuxadas(aMotor[oLstBox:nAt,2]), oLstBox:Refresh())
			    
		oLstBox:SetArray(aMotor)
		oLstBox:bLine := {||{if(aMotor[oLstBox:nAt,01], oOk, oNo),;
										aMotor[oLstBox:nAt,02],;
										aMotor[oLstBox:nAt,03],;
										aMotor[oLstBox:nAt,04],;
										aMotor[oLstBox:nAt,05],;
										Transform(aMotor[oLstBox:nAt,06], '@E 999,999,999.99')}}
		oLstBox:nAt := 1
		oLstBox:SetFocus()			
	Activate MsDialog oConsMot On Init EnchoiceBar(oConsMot,{|| ViewPuxadas(aMotor[oLstBox:nAt,2])},{||oConsMot:End()}) Centered
Return Nil

//-------------------------------------------------------------------
//-    Realiza a Pesquisa de acordo com o digitado pelo usuário     -
//-      Desenvolvida por: Nilson Neto          Data: 24/03         -
//-------------------------------------------------------------------
Static Function SearchMotor(cType, cPesq, aItens)
	Local cWhere := ""
	Local cOrder := "ZF_CODIGO"
	
	If !Empty(cPesq)
		Do Case
			Case (cType == aItens[01])
				cWhere := "AND ZF_CODIGO  =  '" + AllTrim(cPesq) + "' "
			Case (cType == aItens[02])
				cWhere := "AND ZF_NOME  like '" + AllTrim(cPesq) +  "%' "
				cOrder := "ZF_NOME"                                  
			Case (cType == aItens[03])
				cWhere := "AND ZF_MATRIC  =  '" + AllTrim(cPesq) + "' "         
				cOrder := "ZF_MATRIC"
			Case (cType == aItens[04])
				cWhere := "AND ZF_PLACA like '" + AllTrim(cPesq) + "%' "         
				cOrder := "ZF_PLACA"
		EndCase
	Endif
	
	cQry := "SELECT ZF_CODIGO, ZF_NOME, ZF_PLACA, ZF_MATRIC, SUM(ZX_VALOR) AS VLR_TOTAL"
	cQry += " FROM "+RetSQLName("SZF")+" AS SZF"
	cQry += " INNER JOIN "+ RetSQLName("SZX") + " AS SZX ON SZX.D_E_L_E_T_ = ' ' AND SZF.ZF_CODIGO = SZX.ZX_CODMOT"
	cQry += " WHERE ZF_FILIAL = '" + xFilial("SZF") + "' AND SZF.D_E_L_E_T_ = ' ' " + cWhere
	cQry += " GROUP BY ZF_CODIGO, ZF_NOME, ZF_PLACA, ZF_MATRIC"
	cQry += " ORDER BY " + cOrder
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "ICHS", .T., .F.)
	
	aMotor := {}
	While (!ICHS->(Eof()))			
		aAdd(aMotor, {.T., ICHS->ZF_CODIGO, ICHS->ZF_NOME, ICHS->ZF_MATRIC, ICHS->ZF_PLACA, ICHS->VLR_TOTAL})
		ICHS->(dbSkip())		
	EndDo
	ICHS->(dbCloseArea())
	
	If Empty(aMotor)
		aAdd(aMotor , { .T., "", "", "", "", 0 } )
	EndIf                    
	
Return Nil
		
//-------------------------------------------------------------------
//-		  	   Criação do Vetor com os itens para o ListBox         -
//-        Desenvolvido por: Nilson Neto           Em: 23/03        -
//-------------------------------------------------------------------
Static Function CriaItems(cCodMot,aItems,lTudo)
	Local cQry, cPuxada, nValor
	
	aItems := {}
	
	cQry := "SELECT ZX_CODIGO, ZW_DOC, ZY_QUANT SALDO, ZW_QTDORI QUANT, ZW_SALDO, ZW_PACLIS, ZW_CODPRO, ZW_LOJA, ZW_SERIE, ZW_FORNECE, ZX_VALOR,"
	cQry += " ZX_DATA, ZX_HORA"
	cQry += " FROM " + RetSQLName("SZW") + " SZW"
	cQry += " INNER JOIN " + RetSQLName("SZY") + " SZY ON SZY.D_E_L_E_T_ = ' '" 
	cQry += "   AND SZW.ZW_FILIAL = SZY.ZY_FILIAL"
	cQry += "   AND SZW.ZW_PACLIS = SZY.ZY_PACLIS"
	cQry += "   AND SZW.ZW_DOC = SZY.ZY_DOC"
	cQry += "   AND SZW.ZW_SERIE = SZY.ZY_SERIE"
	cQry += "   AND SZW.ZW_FORNECE = SZY.ZY_FORNECE"
	cQry += "   AND SZW.ZW_LOJA = SZY.ZY_LOJA" 
	cQry += "   AND SZW.ZW_ITEM = SZY.ZY_ITEM"
	cQry += " INNER JOIN " + RetSQLName("SZX") + " SZX ON SZX.D_E_L_E_T_ = ' '" 
	cQry += "   AND SZX.ZX_FILIAL = SZY.ZY_FILIAL"
	cQry += "   AND SZX.ZX_CODIGO = SZY.ZY_CODIGO"
	cQry += "   AND SZX.ZX_CODMOT = '" + cCodMot + "'"
	cQry += " WHERE SZW.D_E_L_E_T_ = ' '"
	
	If lTudo <> Nil .And. !lTudo   // Se filtra só com saldo
		cQry += " AND SZW.ZW_SALDO > 0"
	Endif
	
	cQry += " ORDER BY ZX_CODIGO, ZX_DATA, ZX_HORA, ZW_DOC, ZW_SERIE"
	
	dbUseArea(.T.,  'TOPCONN', TCGENQRY(,,ChangeQuery(cQry)), 'AMDG', .T., .F.)
	
	While !AMDG->(EOF())
		nValor  := AMDG->ZX_VALOR
		cPuxada := AMDG->ZX_CODIGO
		While !AMDG->(EOF()) .And. cPuxada == AMDG->ZX_CODIGO
			aAdd( aItems, {AMDG->ZX_CODIGO, AMDG->ZW_PACLIS, AMDG->ZW_DOC, AMDG->ZW_SERIE, AMDG->QUANT, AMDG->SALDO, AMDG->ZW_SALDO, AMDG->ZW_LOJA,;
								AMDG->ZW_FORNECE, nValor, Stod(AMDG->ZX_DATA), AMDG->ZX_HORA, !Empty(AMDG->ZW_SALDO)})
			nValor := 0
			AMDG->(dbSkip())
		Enddo
	EndDo
	AMDG->(dbCloseArea())
	
	If Empty(aItems)
		AAdd( aItems , { "", "", "", "", 0, 0, 0, "", "", 0, Ctod(""), "00:00", .F.} )
	Endif
	
Return .T.

//-------------------------------------------------------------------
//-    No duplo Clique, mostra uma tela com todos os itens          -
//-      Desenvolvida por: Nilson Neto          Data: 24/03         -
//-------------------------------------------------------------------
Static Function ViewPuxadas(cMotor,aPos,oConsPux,lTudo,lCriaTela)
	Local cType    := "Motorista"
	Local cNome    := Posicione("SZF",1,XFILIAL("SZF")+cMotor,"ZF_NOME")
	Local cLegenda := "Puxadas do Motorista: " + RTrim(cNome) + " Cód.: "+ RTrim(cMotor)
	Local lTelaCon := (aPos <> Nil)
	Local aButtons := {	{"" , {||oConsPux:End(),, U_AAESTC4C(cMotor)}, "Comparar rendimento Motorista"},;
								{"" , {||oConsPux:End(),, U_AAESTR02(cType, cMotor, cNome, aItems, .F.)},   "Imprimir Relatório"},;
								{"" , {||oConsPux:End(),, U_AAESTR02(cType, cMotor, cNome, aItems, .T.)}, "Exportar para Excel"}}
	Local oOk      := LoadBitmap(GetResources(), "BR_VERDE" )
	Local oNo      := LoadBitmap(GetResources(), "BR_VERMELHO" )
	
	Static oLstPux, oLeg
	
	If !CriaItems(cMotor,@aItems,lTudo)
		Return .F.
	Endif
	
	If !lTelaCon
		aPos := { 35, 10, 550, 250}
		
		Define MsDialog oConsPux Title "Puxada por Motorista" From 5,15 To 45,145 of oMainWnd
	Endif
	
	If lCriaTela == Nil .Or. lCriaTela
		@aPos[1]-15,012 SAY oLeg VAR cLegenda OF oConsPux PIXEL SIZE 200,007
		
		oLstPux := TWBrowse():New(aPos[1],aPos[2],aPos[3],aPos[4],,aCabec,,oConsPux,,,,,,,,,,,,,,.T.)
	Endif
	
	oLstPux:SetArray(aItems)
	oLstPux:bLine := {||{If(aItems[oLstPux:nAt,13], oOk, oNo),;
								aItems[oLstPux:nAt,01],;
								aItems[oLstPux:nAt,02],;
								aItems[oLstPux:nAt,03],;
								aItems[oLstPux:nAt,04],;
								Transform(aItems[oLstPux:nAt,05],'@E 99,999,999,999'),;
								Transform(aItems[oLstPux:nAt,06],'@E 999,999,999'),;
								Transform(aItems[oLstPux:nAt,07],'@E 999,999,999'),;
								aItems[oLstPux:nAt,08],;
								aItems[oLstPux:nAt,09],;
								aItems[oLstPux:nAt,10],;
								aItems[oLstPux:nAt,11],;
								aItems[oLstPux:nAt,12]}}
	oLstPux:nAt := 1
	oLstPux:SetFocus()
	
	If !lTelaCon
		Activate MSDialog oConsPux CENTERED ON INIT EnchoiceBar(oConsPux,{|| oConsPux:End()} , {|| oConsPux:End() },,aButtons)	
	Else
		oLstPux:Refresh()
		oLeg:cCaption := cLegenda
		oLeg:cTitle := cLegenda
	Endif
	
Return .T.

User Function GetMotoPuxada(lCabec)
	Local nX
	Local aRet := {}
	
	If !Empty(aItems) .And. !Empty(aItems[1,1])
		If lCabec <> Nil .And. lCabec
			AAdd( aRet , aClone(aCabec) )   // Adiciona o cabeçalho
		Endif
		
		AEval( aItems , {|nX| AAdd( aRet , aClone(nX) ) } )  // Adiciona os itens
	Endif
	
Return aRet
//Sit laus Deo Patri, summo Christo decus, Spiritui Sancto tribus honos unus