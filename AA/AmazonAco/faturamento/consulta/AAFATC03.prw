 
#Include "Protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ PACOMP02   ¦ Autor ¦ Henrique Cavalcante  ¦ Data ¦ 13/07/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Tela de Consulta de Pedidos de Venda						  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

//************************************************************************************************************************************************
// Tela Inicial / Pedidos de Venda
//************************************************************************************************************************************************

User Function AAFATC03()

Local oDlg
Local oBtnOk
Local oBtnCancel
Local aButtons
Local oFont

Private oChkV, lChkV:=.T.
Private oChkA, lChkA:=.T.
Private oChkT, lChkT:=.T.
Private oChkPA, lChkPA:=.T.
Private oChkPF, lChkPF:=.T.
Private oChkF0, lChkF0:=.T.
Private oChkF1, lChkF1:=.T.
Private oChkF2, lChkF2:=.T.

Private cPerIni := Date(), cPerFim := Date()
Private cClientIni := Space(6), cClientFim := Space(6)
Private cVendedor := Space(6)
Private _cVendTo  := Space(TAMSX3("A3_COD")[01])

Private nTotalR := 0
Private nTotalK := 0

DEFINE FONT oFont NAME "Arial" SIZE 0,-12 Bold

aButtons := {{ "BMPPERG" , {|| MsgInfo("Pergunte") }, "Pergunte..."},;
{"BMPCALEN", {|| MsgInfo("Calendario") }, "Calendario..."}}

DEFINE MSDIALOG oDlg TITLE "Consulta de Pedidos de Venda" FROM 0,0 TO 270,390 PIXEL

@20,10 SAY "Período Inicial: " PIXEL OF oDlg
@17,50 MsGET cPerIni SIZE 40,10 PIXEL OF oDlg

@40,10 SAY "Período Final:" PIXEL OF oDlg
@37,50 MsGET cPerFim SIZE 40,10 PIXEL OF oDlg

@60,10 SAY "Cliente de:" PIXEL OF oDlg
@57,50 MsGET cClientIni SIZE 30,10 PIXEL OF oDlg F3 "SA1"

@80,10 SAY "Cliente até:" PIXEL OF oDlg
@77,50 MsGET cClientFim SIZE 30,10 PIXEL OF oDlg F3 "SA1"

@100,10 SAY "Vendedor de:" PIXEL OF oDlg
@097,50 MSGET cVendedor SIZE 30,10 OF oDlg PIXEL F3 "SA3"

@120,10 SAY "Vendedor Ate:" PIXEL OF oDlg
@117,50 MSGET _cVendTo SIZE 30,10 OF oDlg PIXEL F3 "SA3"

@19,129 SAY "Tipo:" PIXEL OF oDlg
@29,129 CHECKBOX oChkV VAR lChkV PROMPT "Varejo" SIZE 70,9 PIXEL OF oDlg
@39,129 CHECKBOX oChkA VAR lChkA PROMPT "Atacado" SIZE 70,9 PIXEL OF oDlg
@49,129 CHECKBOX oChkT VAR lChkT PROMPT "Transferências" SIZE 70,9 PIXEL OF oDlg

@61,129 SAY "Filiais:" PIXEL OF oDlg
@71,129 CHECKBOX oChkF0 VAR lChkF0 PROMPT "00" SIZE 70,9 PIXEL OF oDlg
@71,149 CHECKBOX oChkF1 VAR lChkF1 PROMPT "01" SIZE 70,9 PIXEL OF oDlg
@71,169 CHECKBOX oChkF2 VAR lChkF2 PROMPT "02" SIZE 70,9 PIXEL OF oDlg

@83,129 SAY "Status:" PIXEL OF oDlg
@93,129 CHECKBOX oChkPA VAR lChkPA PROMPT "Pedidos Abertos" SIZE 70,9 PIXEL OF oDlg
@103,129 CHECKBOX oChkPF VAR lChkPF PROMPT "Pedidos Faturados" SIZE 70,9 PIXEL OF oDlg

@oDlg:nHeight/2-30,oDlg:nClientWidth/2-70 BUTTON oBtnOk PROMPT "&Consultar" SIZE 30,15 PIXEL ACTION IIf ((!(lChkV) .And. !(lChkA) .And. !(lChkT)),Alert('Selecione o tipo do Pedido'), MontaB()) MESSAGE "Clique aqui para Confirmar" OF oDlg
@oDlg:nHeight/2-30,oDlg:nClientWidth/2-35 BUTTON oBtnCancel PROMPT "&Fechar" SIZE 30,15 PIXEL ACTION oDlg:End() MESSAGE "Clique aqui para Cancelar" OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| , oDlg:End() }, {|| oDlg:End() },,aButtons)

Return Nil

//************************************************************************************************************************************************
// Função para montar a estrutura do Browse
//************************************************************************************************************************************************

Static Function MontaB()

Local aCabec := {'Filial','Pedido','Orcamento','Emissão', 'Cliente', 'Loja Cli.','Nome Cliente', 'Vendedor', 'Val. Brut.', 'Desconto', 'Val. Liq.', 'Cond. Pag.', 'Num. OS'}
Local aCampos := {}
Local cAls := ""
Local cPedido := ""

Private _oBrw := Nil

DEFINE FONT oFont NAME "Arial" SIZE 0,-12 Bold

aButtons := {{ "BMPPERG" , {|| MsgInfo("Pergunte") }, "Pergunte..."},;
{"BMPCALEN", {|| MsgInfo("Calendario") }, "Calendario..."}}

DEFINE MSDIALOG oWindow TITLE "Pedidos de Venda" FROM 0,0 TO 430,920 PIXEL

aCampos	 := {;
{ {|| (cAls)->C5_FILIAL}  ,"@!"},;
{ {|| (cAls)->C5_NUM}     ,"@!"},;
{ {|| (cAls)->C5_XORCRES} ,"@!"},;
{ {|| (cAls)->C5_EMISSAO} ,"@!"},;
{ {|| (cAls)->C5_CLIENTE} ,"@!"},;
{ {|| (cAls)->C5_LOJACLI} ,"@!"},;
{ {|| (cAls)->C5_XNOMCLI} ,"@!"},;
{ {|| (cAls)->C5_VEND1}   ,"@!"},;
{ {|| (cAls)->VBRUT}      ,"@E 999,999,999.99"},;
{ {|| (cAls)->DES}        ,"@E 999,999,999.99"},;
{ {|| (cAls)->VLIQ }      ,"@E 999,999,999.99"},;
{ {|| (cAls)->E4_DESCRI}  ,"@!"},;
{ {|| (cAls)->C5_XNUMOS}  ,"@!"}}

cAls := Consulta()

_oBrw := TcBrowse():New ( 12,00,463,175 , , /*aCabec*/,/*[ aColSizes]*/, oWindow , /*[ cField]*/,  , , /*[ bChange]*/, /*[ bLDblClick]*/, /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/,  cAls, /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )

For nI := 1 To Len(aCampos)
	_oBrw:AddColumn(TCColumn():New(aCabec[nI], aCampos[nI][01], aCampos[nI][02] ,,, iIf( (aCampos[nI][02]) != "@!","RIGTH", "LEFT")  ,,.F.,.F.,,,,.F.,) )
Next
_oBrw:BLDBLCLICK := {|| MsgRun('Filtrando Dados, Aguarde...'),TelaDet(AllTrim((cAls)->C5_NUM))} //chamar funcao com o grid grid(tmp->c5_num)
_oBrw:nScrollType := 1 // Define a barra de rolagem VCR

@oWindow:nHeight/2-35,oWindow:nClientWidth/2-80 SAY "Total em R$: " PIXEL OF oWindow
@oWindow:nHeight/2-35,oWindow:nClientWidth/2-45 SAY nTotalR PICTURE "@E 999,999,999.99" PIXEL OF oWindow

@oWindow:nHeight/2-25,oWindow:nClientWidth/2-80 SAY "Total em KG: " PIXEL OF oWindow
@oWindow:nHeight/2-25,oWindow:nClientWidth/2-45 SAY nTotalK PICTURE "@E 999,999,999.99" PIXEL OF oWindow

ACTIVATE MSDIALOG oWindow CENTERED ON INIT EnchoiceBar(oWindow,{|| , oWindow:End() }, {|| oWindow:End() },,aButtons)

Return

//************************************************************************************************************************************************
// Função que retorna os dados na tabela temporária para o Browse
//************************************************************************************************************************************************

Static Function Consulta()

Local cQry     := ""
Local cQryW    := ""
Local cQryH    := ""
Local _cAlias  := ""
Local _cTbl    := ""
Local cFiliais := "", cFil := ""

If Empty(_cAlias)
	_cAlias := CriaTrab(NIL,.F.)
Else
	(_cAlias)->(dbCloseArea(_cAlias))
	If File(_cAlias)
		fErase(_cAlias)
	EndIf
EndIf

// Tudo em branco
cQryW:=" WHERE SC5.D_E_L_E_T_ = '' "

//DATA
cQryW += " AND C5_EMISSAO BETWEEN "
cQryW += IIf(!Empty(cPerIni), " '" + AllTrim(dToS(cPerIni)) + "' AND ", " '        ' AND ")
cQryW += IIf(!Empty(cPerFim), " '" + AllTrim(dToS(cPerFim)) + "' ", " 'ZZZZZZZZ' ")

//CLIENTE
cQryW += " AND C5_CLIENTE BETWEEN "
cQryW += IIf(!Empty(cClientIni), " '" + AllTrim(cClientIni) + "' AND ", " '      ' AND " )
cQryW += IIf(!Empty(cClientFim), " '" + AllTrim(cClientFim) + "' ", " 'ZZZZZZ' " )


//VENDEDOR
cQryW += " AND C5_VEND1 BetWeen '" + cVendedor +"' And '"  + iIF(Empty(_cVendTo),Replicate("z",len(_cVendTo)) , _cVendTo) + "' "
//cQryW += IIf(!Empty(cVendedor), " '" + AllTrim(cVendedor) + "' ", " '' ")

//FILIAIS    cFiliais := "00,01,02" FormatIn(cFiliais,",") -> ('00','01','02')
cFiliais += IIf((lChkF0),"00,","")
cFiliais += IIf((lChkF1),"01,","")
cFiliais += IIf((lChkF2),"02,","")

For i := 1 to len(cFiliais)-1
	cFil += SubStr(cFiliais,i,1)
Next

cQryW += " AND C5_FILIAL IN " + (FormatIn(cFil,",")) + " "

//STATUS DO PEDIDO
If !(lChkPA) .And. !(lChkPF)
	cQryH += " HAVING SUM(C6_QTDVEN-C6_QTDENT) <> 0 AND SUM(C6_QTDVEN-C6_QTDENT) = 0 "
EndIf
If (lChkPA) .And. !(lChkPF)
	cQryH += " HAVING SUM(C6_QTDVEN-C6_QTDENT) <> 0 "
EndIf
If (lChkPF) .And. !(lChkPA)
	cQryH += " HAVING SUM(C6_QTDVEN-C6_QTDENT) = 0 "
EndIf
If lChkPA .And. lChkPF
	cQryH += ""
EndIf

//TIPO COMERCIAL
If (lChkV) .And. (lChkA) .And. (lChkT)
	cQryW += " "
EndIf

If (lChkV) .And. (lChkA) .And. !(lChkT)
	cQryW += " AND (C5_XORCRES <> '' AND C5_XFILRES <> '') OR (C5_XORCRES = '' AND C5_XFILRES = '' AND (C5_CLIENTE <> '001187')) "
EndIf

If (lChkV) .And. !(lChkA) .And. !(lChkT)
	cQryW += " AND C5_XORCRES <> '' AND C5_XFILRES <> '' "
EndIf

If !(lChkV) .And. (lChkA) .And. !(lChkT)
	cQryW += " AND (C5_XORCRES = '' AND C5_XFILRES = '') AND (C5_CLIENTE <> '001187') "
EndIf

If !(lChkV) .And. (lChkA) .And. (lChkT)
	cQryW += " AND (C5_XORCRES = '' AND C5_XFILRES = '') AND (C5_CLIENTE in ('001187','001188','001189') OR C5_CLIENTE <> ('001187','001188','001189')) "
EndIf

If !(lChkV) .And. !(lChkA) .And. (lChkT)
	cQryW += " AND (C5_XORCRES = '' AND C5_XFILRES = '') AND (C5_CLIENTE = ('001187','001188','001189')) "
EndIf

If (lChkV) .And. !(lChkA) .And. (lChkT)
	cQryW += " AND (C5_XORCRES <> '' AND C5_XFILRES <> '') OR (C5_XORCRES = '' AND C5_XFILRES = '' AND (C5_CLIENTE = ('001187','001188','001189'))) "
EndIf

cQry := " SELECT C5_FILIAL, C5_NUM,C5_XORCRES, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI,C5_XNOMCLI, C5_VEND1, C5_XNUMOS,
cQry += " SUM(C6_VALOR) AS VBRUT, SUM(C6_VALDESC) AS DES, SUM(C6_VALOR-C6_VALDESC) AS VLIQ, E4_DESCRI, SUM(C6_QTDVEN*B1_PESO) AS PESOP
cQry += " FROM " + RetSqlName("SC5") + " AS SC5 "
cQry += " INNER JOIN " + RetSqlName("SC6") + " AS SC6 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND SC6.D_E_L_E_T_='' "
cQry += " INNER JOIN " + RetSqlName("SE4") + " AS SE4 ON E4_CODIGO = C5_CONDPAG AND SE4.D_E_L_E_T_='' "
cQry += " LEFT OUTER JOIN " + RetSqlName("SB1") + " AS SB1 ON B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = '' "
cQry += cQryW
cQry += " GROUP BY C5_FILIAL, C5_NUM,C5_XORCRES, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI,C5_XNOMCLI, C5_VEND1, C5_XNUMOS, E4_DESCRI "
cQry += cQryH
cQry += " ORDER BY C5_FILIAL, C5_NUM, C5_EMISSAO"

dbUseArea(.T., "TOPCONN", TcGenQry(,,cQry), "TMP", .T.,.F.)
nTotalR := 0
nTotalK := 0

While !(TMP->(Eof()))
	nTotalR += TMP->VLIQ
	nTotalK += TMP->PESOP
	TMP->(dbSkip())
End

tcSetField("TMP","C5_EMISSAO","D",8,0)
tcSetField("TMP","VBRUT","N",15,2)
tcSetField("TMP","VLIQ","N",15,2)
tcSetField("TMP","DES","N",15,2)
tcSetField("TMP","PESOP","N",15,6)

copy to &_cAlias

TMP->(dbCloseArea())

dbUseArea(.T.,,_cAlias,_cAlias,.F.,.F.)

Return _cAlias

//************************************************************************************************************************************************
// Tela Auxiliar / Itens do Pedido
//************************************************************************************************************************************************

Static Function TelaDet(cPed)

Local aCabec2 := {'Produto', 'Descrição', 'UM', 'Quantidade', 'Preco Uni.', 'Seg UM', 'Qtde 2UM'}
Local aCampos2 := {}
Local cAls2 := ""
Local cQry2:=""
Local _cAlias2 := ""

Private _oBrw2 := Nil

If Empty(_cAlias2)
	_cAlias2 := CriaTrab(NIL,.F.)
Else
	(_cAlias2)->(dbCloseArea(_cAlias2))
	If File(_cAlias2)
		fErase(_cAlias2)
	EndIf
EndIf

cQry2 := "SELECT C5_NUM, C6_PRODUTO, C6_DESCRI, C6_UM, C6_QTDVEN, C6_PRCVEN, C6_SEGUM, C6_UNSVEN FROM " + RetSqlName("SC6") + " AS SC6 "
cQry2 += "INNER JOIN " + RetSqlName("SC5") + " AS SC5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC5.D_E_L_E_T_='' "
cQry2 += "WHERE SC6.D_E_L_E_T_='' AND C5_NUM = " + cPed + " "
cQry2 += "ORDER BY C6_PRODUTO"

dbUseArea(.T., "TOPCONN", TcGenQry(,,cQry2), "HPC", .T.,.F.)

copy to &_cAlias2

HPC->(dbCloseArea())

dbUseArea(.T.,,_cAlias2,_cAlias2,.F.,.F.)

DEFINE FONT oFont NAME "Arial" SIZE 0,-12 Bold

//	aButtons := {{ "BMPPERG" , {|| MsgInfo("Pergunte") }, "Pergunte..."},;
//				{"BMPCALEN", {|| MsgInfo("Calendario") }, "Calendario..."}}
aButtons  := {}

DEFINE MSDIALOG oWindow2 TITLE "Itens do Pedido de Venda" FROM 0,0 TO 430,920 PIXEL

aCampos2 := {;
{ {|| (cAls2)->C6_PRODUTO} ,"@!"},;
{ {|| Posicione("SB1",1,xFilial('SB1') + (cAls2)->C6_PRODUTO,"B1_ESPECIF") }  ,"@!"},;
{ {|| (cAls2)->C6_UM}      ,"@!"},;
{ {|| (cAls2)->C6_QTDVEN}  ,"@E 999,999,999.99"},;
{ {|| (cAls2)->C6_PRCVEN}  ,"@E 999,999,999.99"},;
{ {|| (cAls2)->C6_SEGUM}   ,"@!"},;
{ {|| (cAls2)->C6_UNSVEN}  ,"@!"}}

cAls2 := _cAlias2

_oBrw2 := TcBrowse():New ( 12,00,463,204 , , /*aCabec*/,/*[ aColSizes]*/, oWindow2 , /*[ cField]*/,  , , /*[ bChange]*/, /*[ bLDblClick]*/, /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/,  cAls2, /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )

For nI2 := 1 To Len(aCampos2)
	_oBrw2:AddColumn(TCColumn():New(aCabec2[nI2], aCampos2[nI2][01], aCampos2[nI2][02] ,,, iIf( (aCampos2[nI2][02]) != "@!","RIGTH", "LEFT")  ,,.F.,.F.,,,,.F.,) )
Next

_oBrw2:nScrollType := 1 // Define a barra de rolagem VCR

ACTIVATE MSDIALOG oWindow2 CENTERED ON INIT EnchoiceBar(oWindow2,{|| , oWindow2:End() }, {|| oWindow2:End() },,aButtons)

(_cAlias2)->(dbCloseArea())

Return

//************************************************************************************************************************************************
// FIM!
//************************************************************************************************************************************************
