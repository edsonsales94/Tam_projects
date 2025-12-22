#include "Protheus.CH"
#include "font.CH"
#include "Topconn.ch"
#include "RwMake.ch"

Static aCabec := {" ", "Puxada", "Num PacList", "Num NF", "Serie NF", "Quant NF", "Quant Puxada", "Saldo Transito", "Loja", "Fornecedor", "Valor",;
						"Dt.Puxada", "Hr.Puxada"}
Static aItems := {}

/*__________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+----------------------+-------------+---------------+¦
¦¦¦ Programa |  AAESTA01   Autor ¦ ADRIANO LIMA | Data | 01/03/12 ¦¦¦
¦¦+-----------+----------------------+-------------+---------------+¦
¦¦¦ Descrição:| Montagem da Tela de Pesquisa de Puxadas por Produto ¦
¦¦¦  por PRODUTO,DESCRIÇÃO, e GERAL 							  ¦¦¦
¦¦+------------+----------------------+-------------+---------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAESTC01(cProduto,aPos,oConsPux,lTudo,lCriaTela)
	Local aArea := GetArea()
	Local lRet  := .T.
	
	If aPos == Nil
		ViewProduto()
	Else
		lRet := ViewPuxada(cProduto,aPos,oConsPux,lTudo,lCriaTela)
	Endif
	
	RestArea(aArea)
Return lRet

Static Function ViewProduto()
Local cVar     := Nil
Local nOpc     := 0
Local oLbx
Local aItens   := {}

Private _cPesquisa := Space(40)
Private oTipo       := NIL
Private _cTipo      := Space(30)
Private oPesquisa   := NIL
Private aProds      := {}

Pesquisa("Produto")

DEFINE FONT oFnt3 NAME "MS Sans Serif" SIZE 0, -9 BOLD

DEFINE MSDIALOG oDlg2 TITLE "Consulta Puxadas por Produtos"  From 5,15 To 45,145 OF oMainWnd

AADD(aItens,"Produto")
AADD(aItens,"Descricao")
AADD(aItens,"Geral")

@ 015,15 Say "Tipo : "  Size 35,8 Of oDlg2 Pixel Font oFnt3
@ 015,50 MSCOMBOBOX oTipo VAR _cTipo ITEMS aItens SIZE 100,50 OF  oDlg2 PIXEL

@030, 15 Say "Pesquisar : "  Size 35,8 Of oDlg2  Pixel Font oFnt3

@030, 50 MSGET oPesquisa Var _cPesquisa Picture "@!" Size 220,10 Pixel of oDlg2 VALID Pesquisa(Alltrim(_cTipo))

//			 																 1  	    2            3          4    			    5 			      6
@ 45,05 LISTBOX oLbx VAR cVar FIELDS HEADER  "Código","Descrição","UM","Estoque Disp.","Saldo Puxada","Saldo Transito";
SIZE 500,230 OF oDlg2 PIXEL ON dblClick( ViewPuxada(aProds[oLbx:nAt,1]),oLbx:Refresh(.F.))

oLbx:SetArray( aProds )
oLbx:bLine := {||	{aProds[oLbx:nAt,1],;						// Código do Produto
						alltrim(aProds[oLbx:nAt,2]),;                                   // Descrição
						Transform(aProds[oLbx:nAt,3],PesqPict("SB1","B1_UM",18,0)),;    // UM
						Transform(aProds[oLbx:nAt,4],PesqPict("SB2","B2_QATU",18,2)),;  // Estoque
						Transform(aProds[oLbx:nAt,5],PesqPict("SZW","ZW_SALDO",18,2)),; // Saldo Puxada
						Transform(aProds[oLbx:nAt,6],PesqPict("SZW","ZW_SALDO",18,2))} }  //Saldo Transito

oLbx:SetFocus()

ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2,{|| nOpc:=1,oDlg2:End(),  },{||oDlg2:End()}) CENTERED

Return .T.



*------------------------------------------------------------------------------------------*
Static Function Pesquisa(cTipo)
*------------------------------------------------------------------------------------------*
Local cQry,cQuery

cQry := " SELECT B1.B1_COD, B1.B1_DESC, B1.B1_LOCPAD, B1.B1_FABRIC, B1.B1_UM,  SUM(B.ZW_SALDO) TRANSITO "
cQry += " FROM  "+RetSQLName("SB1")+" B1 "
cQry += "INNER JOIN   "+RetSQLName("SZW")+" B ON B1.B1_COD = B.ZW_CODPRO "

//-----------------------------------------------------------------------------
//-		   	  Rotina executada quando o campo pesquisa for vazio              -
//-			Desenvolvida por: Matheus da Silva Santos		Data: 23/03/2012  -
//-----------------------------------------------------------------------------

cQry += " INNER JOIN "+RetSQLName("SZY")+" SZY  ON B.ZW_FILIAL = SZY.ZY_FILIAL "
cQry += " AND B.ZW_SERIE 	 = SZY.ZY_SERIE "
cQry += " AND B.ZW_LOJA	 = SZY.ZY_LOJA "
cQry += " AND B.ZW_DOC     = SZY.ZY_DOC "
cQry += " AND B.ZW_CODPRO	 = SZY.ZY_CODPRO "

If !Empty(_cPesquisa)
	Do Case
		Case cTipo     == "Produto"
			cQry += "WHERE B1.B1_COD LIKE '%"+Alltrim(_cPesquisa)+"%'"
		Case cTipo     == "Descricao"
			cQry += "WHERE B1.B1_DESC LIKE    '%"+Alltrim(_cPesquisa)+"%'"
		Case cTipo     == "Geral"
			cQry += "WHERE (B1.B1_DESC    LIKE '%"+Alltrim(_cPesquisa)+"%' OR "
			cQry += "B1.B1_COD LIKE '%"+Alltrim(_cPesquisa)+"%')"
	EndCase
EndIF

cQry += "AND B1.B1_FILIAL = '"+xFilial("SB1")+"'"
cQry += "AND B1.B1_MSBLQL <> '1' AND "


cQry += "B1.D_E_L_E_T_ = '' "
cQry += "AND B.D_E_L_E_T_ = '' "


cQry += "AND SZY.D_E_L_E_T_ = '' "
cQry += " GROUP BY B1.B1_COD, B1.B1_DESC, B1.B1_LOCPAD, B1.B1_UM,  B1.B1_FABRIC "

If !Empty(_cPesquisa)
	Do Case
		Case cTipo     == "Produto"
			cQry += "ORDER BY B1.B1_COD, B1.B1_DESC "
		Case cTipo     == "Descricao"
			cQry += "ORDER BY B1.B1_DESC "
		Case cTipo     == "Geral"
			cQry += "ORDER BY B1_DESC, B1.B1_COD "
	EndCase
EndIF

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "QRY", .T., .F. )

DbSelectArea("SB0")
DbSetOrder(1)

DbSelectArea("SB2")
DbSetOrder(1)

dbSelectArea("QRY")
dbGoTop()

//aDel(aProds,Len(aProds))
//aSize(aProds,0)
aProds := {}

While !QRY->(Eof())
	
	SB2->(DbSeek(xFilial("SB2")+QRY->B1_COD+QRY->B1_LOCPAD))
	
	nSaldoDisp := SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QEMP)
	
	aAdd( aProds , {  QRY->B1_COD, QRY->B1_DESC, QRY->B1_UM, nSaldoDisp, (nSaldoDisp + QRY->TRANSITO), QRY->TRANSITO})
	QRY->(DbSkip())
	
Enddo

QRY->(DbCloseArea())

If Empty(aProds)
	aAdd( aProds , {  "", "", "", 0, 0, 0 } )
	//MsgAlert("Não existe dados para seleção!!!",OemToAnsi("ATENCAO")  )
EndIf

Return

Static Function CriaItems(cProd,aItems,lTudo)
	Local cPuxada, nValor
	Local cAlias := Alias()
	Local cQry   := ""
	
	aItems := {}
	
	//-------------------------------------------------------------------
	//-		  	   Criação do Vetor com os itens para o ListBox         -
	//-------------------------------------------------------------------
	cQry := " SELECT ZX_CODIGO, ZW_DOC, ZY_QUANT SALDO, ZW_QTDORI QUANT, ZW_SALDO, ZW_PACLIS, ZW_CODPRO, ZW_LOJA, ZW_SERIE, ZW_FORNECE, ZX_VALOR,"
	cQry += " ZX_DATA, ZX_HORA"
	cQry += " FROM "+RetSQLName("SZW")+" SZW "
	cQry += " INNER JOIN "+RetSQLName("SZY")+" SZY ON SZY.D_E_L_E_T_ = ' '"
	cQry += " AND SZW.ZW_FILIAL = SZY.ZY_FILIAL"
	cQry += " AND SZW.ZW_SERIE = SZY.ZY_SERIE "
	cQry += " AND SZW.ZW_LOJA = SZY.ZY_LOJA  "
	cQry += " AND SZW.ZW_DOC = SZY.ZY_DOC "
	cQry += " AND SZW.ZW_CODPRO = SZY.ZY_CODPRO "
	cQry += " INNER JOIN " + RetSQLName("SZX") + " SZX ON SZX.D_E_L_E_T_ = ' '" 
	cQry += " AND SZX.ZX_FILIAL = SZY.ZY_FILIAL"
	cQry += " AND SZX.ZX_CODIGO = SZY.ZY_CODIGO"
	cQry += " WHERE SZW.D_E_L_E_T_ = ' '"
	cQry += " AND SZW.ZW_CODPRO = '"+cProd+"' "
	
	If lTudo <> Nil .And. !lTudo   // Se filtra só com saldo
		cQry += " AND SZW.ZW_SALDO > 0"
	Endif
	
	cQry += " ORDER BY ZX_CODIGO, ZX_DATA, ZX_HORA, ZW_DOC, ZW_SERIE"
	
	dbUseArea(.T.,  'TOPCONN', TCGENQRY(,,ChangeQuery(cQry)), 'MSP', .T., .F.)
	While !MSP->(EOF())
		nValor  := MSP->ZX_VALOR
		cPuxada := MSP->ZX_CODIGO
		While !MSP->(EOF()) .And. cPuxada == MSP->ZX_CODIGO
			aAdd(aItems, {	MSP->ZX_CODIGO, MSP->ZW_PACLIS, MSP->ZW_DOC, MSP->ZW_SERIE, MSP->QUANT, MSP->SALDO, MSP->ZW_SALDO, MSP->ZW_LOJA, MSP->ZW_FORNECE,;
								nValor, Stod(MSP->ZX_DATA), MSP->ZX_HORA, !Empty(MSP->ZW_SALDO)})
			nValor := 0
			MSP->(dbSkip())
		Enddo
	EndDo
	MSP->(dbCloseArea())
	dbSelectArea(cAlias)
	
	If Empty(aItems)
		aAdd(aItems, { "", "", "", "", 0, 0, 0, "", "", 0, Ctod(""), "00:00", .F.})
	EndIf
	
Return .T.

*------------------------------------------------------------------------------------------*
Static Function ViewPuxada(cProd,aPos,oConsPux,lTudo,lCriaTela)
*------------------------------------------------------------------------------------------*
	Local cNome    := Posicione("SB1",1,XFILIAL("SB1")+cProd,"B1_DESC")
	Local lTelaCon := (aPos <> Nil)
	Local cLegenda := "Puxadas do Produto: " + RTrim(cNome) + " Cód.: "+ RTrim(cProd)
	Local aButtons := {}
	Local oOk      := LoadBitmap(GetResources(), "BR_VERDE" )
	Local oNo      := LoadBitmap(GetResources(), "BR_VERMELHO" )
	
	Static oLstPux, oLeg
	
	If !CriaItems(cProd,@aItems,lTudo)
		Return .F.
	Endif
	
	Aadd( aButtons, { "", {|| U_AAESTR01(cProd,aItems)  }, "Imprimir"  ,"Imprimir"  , {|| .T.}} )
	Aadd( aButtons, { "", {|| ValidExp(cProd,aItems)    }, "Exp. Excel","Exp. Excel", {|| .T.}} ) //Adicionado por Matheus Santos
	
	If !lTelaCon
		aPos := { 35, 10, 550, 250}
		
		DEFINE MSDIALOG oDlg FROM 12,20 TO 051,164 TITLE "Saldos de Trânsito"  OF oMainWnd
	Endif
	
	If lCriaTela == Nil .Or. lCriaTela
		@aPos[1]-15,012 SAY oLeg VAR cLegenda OF oConsPux PIXEL SIZE 200,010
		
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
		ACTIVATE MSDIALOG oDlg 	CENTERED ON INIT EnchoiceBar(oDlg,{||  , oDlg:End()} , {|| oDlg:End() },,aButtons)
	Else
		oLstPux:Refresh()
		oLeg:cCaption := cLegenda
		oLeg:cTitle := cLegenda
	Endif
	
Return

User Function GetProdPuxada(lCabec)
	Local nX
	Local aRet := {}
	
	If !Empty(aItems) .And. !Empty(aItems[1,1])
		If lCabec <> Nil .And. lCabec
			AAdd( aRet , aClone(aCabec) )   // Adiciona o cabeçalho
		Endif
		
		AEval( aItems , {|nX| AAdd( aRet , aClone(nX) ) } )  // Adiciona os itens
	Endif
	
Return aRet

//-----------------------------------------------------------------------------
//-		   	  Rotina executada para exportar para Excel         -
//-			Desenvolvida por: Matheus da Silva Santos		Data: 23/03/2012  -
//-----------------------------------------------------------------------------
                                     
Static Function ValidExp(cProd,aItems)
   Local aLinha  := {}
	Local aExport := {} 

	aAdd(aLinha, "Produto: "+AllTrim(cProd)+" - "+Posicione("SB1",1,XFILIAL("SB1")+cProd,"B1_DESC") )

	aAdd(aExport,Array(Len(aLinha)))
	aExport[Len(aExport)] := aClone(aLinha)
	aLinha := {}       
	
	aAdd(aLinha,"Puxada" + Chr(9) + "Num PacList " + Chr(9) + " Num NF  " + Chr(9) + "Serie NF  " + Chr(9) + "Quant NF " + Chr(9) + "Quant Puxada" + Chr(9) +;
					" Saldo Transito " + Chr(9) + "   Loja  " + Chr(9) + "    Fornecedor   " + Chr(9) + " Dt.Puxada " + Chr(9) + " Hr.Puxada " )
			
	aAdd(aExport,Array(Len(aLinha)))
	aExport[Len(aExport)] := aClone(aLinha)
	aLinha := {}
	
	For x:=1 To Len(aItems)
		aAdd(aLinha, aItems[x][1])
		aAdd(aLinha, aItems[x][2])
		aAdd(aLinha, aItems[x][3])
		aAdd(aLinha, aItems[x][4])
		aAdd(aLinha, Transform(aItems[x][5],"@E 999,999,999.99"))
		aAdd(aLinha, Transform(aItems[x][6],"@E 999,999,999.99"))
		aAdd(aLinha, Transform(aItems[x][7],"@E 999,999,999.99"))   
		aAdd(aLinha, aItems[x][8])
		aAdd(aLinha, aItems[x][9])
		aAdd(aLinha, aItems[x][11])
		aAdd(aLinha, aItems[x][12])
		
		aAdd(aExport,Array(Len(aLinha)))
		aExport[Len(aExport)] := aClone(aLinha)
		aLinha := {}
	Next 
	Exporta(aExport)
	
Return                    


Static Function Exporta(aExport)
Local cArqTxt    := "Uploadados.xls"
Local cPath      := AllTrim(GetTempPath())+"Uploadados.xls"
Local nHdl       := fCreate(cPath)
Local cLinha     := "" //Chr(9)+"Relatório"+Chr(13)+Chr(10)      

If !File(cPath)
	MsgStop("O Arquivo " + cPath + " não pode ser Criado!")
	Return nil
EndIf

If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
EndIf

For i:=1 to Len(aExport)
	cLinha := ""
	//IncRegua()
	If ValType(aExport[i])<>"A"
		cLinha += aExport[i]
	Else
		For j := 1 to Len(aExport[i])  
			cLinha += aExport[i][j]+Chr(9)
		Next
	Endif
	
	cLinha += chr(13)+chr(10)
	
	If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
	EndIf
Next
fClose(nHdl)
RunExcel(cPath)
Return Nil

//******************************************************************************************
//*****************************CHAMADA DO APLICATIVO MS EXCEL*******************************
//******************************************************************************************

Static Function RunExcel(cwArq)
Local oExcelApp
Local aNome := {}

If ! ApOleClient( 'MsExcel' ) //Verifica se o Excel esta instalado
	MsgStop( 'MsExcel nao instalado' )
	Return
EndIf
oExcelApp := MsExcel():New()  // Cria um objeto para o uso do Excel
oExcelApp:WorkBooks:Open(cwArq)
oExcelApp:SetVisible(.T.)     // Abre o Excel com o arquivo criado exibido na Primeira planilha.

Return