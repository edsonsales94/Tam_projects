#include "Protheus.ch"
#include "RwMake.ch"
#include "TBICONN.ch"

User function AAFATP03()
	Local aCabec:= {'Tp. Romaneio','Romaneio','Dt. Saida','Placa Veiculo','Motorista','Peso Balanca','Peso Nota','Ajudante 1','Ajudante 2','Observacao'}
	Local aSizes:= {50,50,50,50,30,30,10,100,150}
	
	Private aLeg  :=  { {"P" , "BR_PINK"},;
						{"R" , "BR_AMARELO"},;
						{"B" , "BR_CINZA"},;
						{"E" , "BR_VERMELHO"},;
						{"V" , "BR_LARANJA"},;
						{"N" , "BR_AZUL"},;
						{"F" , "BR_BRANCO"},;
						{"D" , "BR_PRETO"},;
						{"S" , "BR_MARROM"} , ;
						{" " , "ENABLE" } }
	
	If type("cAcesso") = "U"
		Prepare Environment Empresa "01" FILIAL "01" Tables "SA1,SZE" MODULO "FIS"
	EndIf
	
	Private oJanela := Nil
	Private oDatIni := Nil
	Private oDatFim := Nil
	Private oCliIni := Nil
	Private oCliFim := Nil
	Private oPesoT  := Nil
	Private oPesoN  := Nil
	
	Private _odTpRoman  := Nil
	Private _adTpRoman  := {}
	Private _cdTpRoman  := "Ambos"
	
	Private dDataInicial := dDataBase
	Private dDataFinal := dDataBase
	Private cClienteIni := Space(Len(SA1->A1_COD))
	Private cClienteFim := replicate('z',Len(SA1->A1_COD))
	Private nPesoTotal  := 0
	Private nPesoVarejo := 0
	Private nPesoAtacado:= 0
	Private nPesoEntrada:= 0
		
	aAdd(_adTpRoman,"Ambos")
	aAdd(_adTpRoman,"Entrada")
	aAdd(_adTpRoman,"Saida")
	
	cAlias := 'SZE'
	
	Processa({|| cAlias := GetInf(cClienteIni,cClienteFim,dDataInicial,dDataFinal)},'Filtrando Dados' )
	
	(cAlias)->(dbGoTop())
	nPesoTotal := 0
	nPesoVarejo:= 0
	nPesoAtacado:= 0
	CalcPesoDiv( cClienteIni,cClienteFim,dDataInicial,dDataFinal )
	nPesoTotal := PesoTotal()
	(cAlias)->(dbGoTop())
	
	oFont := TFont():New('Courier new',,-12,.T.)
	
	DEFINE DIALOG oJanela TITLE "Consulta Romaneio " FROM 001,001 TO 550,1000 PIXEL
	
	@ 003,005 TO 55,500 label "Filtros" OF oJanela PIXEL
	
	@ 014,007 Say "Data de Saida " Size 70,10 Pixel Of oJanela
	@ 014,077 MsGet oDatIni Var dDataInicial Size 60,08 Pixel of oJanela
	@ 014,150 MsGet oDatFim Var dDataFinal Size 60,08 Pixel of oJanela
	
	@ 029,007 Say "Romaneio " Size 70,10 Pixel Of oJanela
	@ 029,077 MsGet oClienteIni Var cClienteIni F3 'SZE' Size 60,08 Pixel of oJanela
	@ 029,150 MsGet oClienteFim Var cClienteFim F3 'SZE' Size 60,08 Pixel of oJanela
	
	@ 044,007 Say "Tipo Romaneio" Size 50,10 Pixel Of oJanela 
	@ 044,077 MSCOMBOBOX _odTpRoman VAR _cdTpRoman ITEMS _adTpRoman SIZE 060,50 OF oJanela PIXEL
	
	@ 023,230 Button "&Consultar" Size 40,13 Pixel of oJanela Action MsgRun('Filtrando Dados...' ,,{|| GetInf(cClienteIni,cClienteFim,dDataInicial,dDataFinal,cAlias), oBrowse:Refresh() })
	@ 023,280 Button "&Fechar" Size 40,13 Pixel of oJanela Action oJanela:End()
	@ 060,005 TO 215,500 label "Dados" OF oJanela PIXEL
	
	oBrowse := TcBrowse():New ( 070,007,490,140 , , aCabec,aSizes, oJanela, /*[ cField]*/,  , , /*[ bChange]*/, /*[ bLDblClick]*/, /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/,  cAlias, /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )
	oBrowse:bLine := {|| {  (cAlias)->ZE_TIPO,(cAlias)->ZE_ROMAN,(cAlias)->ZE_DTSAIDA,(cAlias)->ZE_PLACA,(cAlias)->ZE_NOMOTOR,Transform( (cAlias)->ZE_PESO,"@E 999,999,999.99"), TRansform( (cAlias)->ZE_PLIQUI ,"@E 999,999,999.99"),(cAlias)->ZE_AJUDA01,(cAlias)->ZE_AJUDA02,(cAlias)->ZE_OBSERV } }
	oBrowse:BLDBLCLICK := {||  MsgRun('Filtrando Dados, Aguarde... ',, {|| u_AAFATP3A( (cAlias)->ZE_ROMAN, .F., '' ) }   ) }
	oBrowse:nScrollType := 0 // Define a barra de rolagem VCR
	
	@ 220,005 TO 270,500 label "Dados" OF oJanela PIXEL
	@ 230,007 Say "Total Peso Balanca" Size 70,10 Pixel Of oJanela
	oPesoT:= TSay():New(240,007,{|| Transform(nPesoTotal,"@E 999,999,999,999,999.99") },oJanela,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
	
	@ 230,157 Say "Total Notas"  Size 70,10 Pixel Of oJanela
	oPesoN:= TSay():New(240,107,{|| Transform(nPesoVarejo + nPesoAtacado + nPesoEntrada,"@E 999,999,999,999,999.99")},oJanela,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
	
	@ 230,257 Say "Venda Loja"  Size 70,10 Pixel Of oJanela
	oPesoV:= TSay():New(240,207,{|| Transform(nPesoVarejo,"@E 999,999,999,999,999.99")},oJanela,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
	
	@ 230,357 Say "Venda Matriz" Size 70,10 Pixel Of oJanela
	oPesoA:= TSay():New(240,307,{|| Transform(nPesoAtacado,"@E 999,999,999,999,999.99") },oJanela,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
	
	@ 230,457 Say "Notas Entrada" Size 70,10 Pixel Of oJanela
	oPesoE:= TSay():New(240,407,{|| Transform(nPesoEntrada,"@E 999,999,999,999,999.99") },oJanela,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
	
	Activate Dialog oJanela Centered
	
Return Nil

Static Function GetInf(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal,cAlias)
	Local _cQry  := ''
	Local cCampos:= ''
	Local cTable := GetNextALias()
	Default cAlias := ''
	cCampos+= ' ZE_ROMAN,ZE_TIPO,MAX(ZE_CLIENTE) ZE_CLIENTE,MAX(ZE_LOJACLI) ZE_LOJACLI ,MAX(ZE_NOMCLI) ZE_NOMCLI, ' + Chr(13) + Chr(10)
	cCampos+= ' MAX(ZE_DTSAIDA) ZE_DTSAIDA,MAX(ZE_PLACA) ZE_PLACA, MAX(ZE_NOMOTOR) ZE_NOMOTOR,            ' + Chr(13) + Chr(10)
	cCampos+= ' MAX(ZE_AJUDA01) ZE_AJUDA01, MAX(ZE_AJUDA02) ZE_AJUDA02, SUM(ZE_PLIQUI) ZE_PLIQUI,         ' + Chr(13) + Chr(10)
	cCampos+= ' MAX(ZE_PESO) ZE_PESO, MAX(ZE_OBSERV) ZE_OBSERV                   ' + Chr(13) + Chr(10)
	
	dbSelectArea('SZE')
	Set Filter To SZE->ZE_STATUS <> 'X' .And. SZE->ZE_CLIENTE>=_cClienteIni .And. SZE->ZE_CLIENTE<= _cClienteFim .And.;
	SZE->ZE_DTSAIDA >= _dDataInicial .And. SZE->ZE_DTSAIDA <= _dDataFinal .And. SZE->ZE_PESO != 0 .And. !( SZE->ZE_CLIENTE $ GETMV("MV_XCLIAA"))
	
	_cQry := " Select " + cCampos + " From "  + RetSqlName("SZE")                           + Chr(13) + Chr(10)
	_cQry += " where D_E_L_E_T_ = '' "                                                      + Chr(13) + Chr(10)
	_cQry += " ANd ZE_ROMAN BetWeen '" + _cClienteIni + "'And '" + _cClienteFim + "'"               + Chr(13) + Chr(10)
	_cQry += " And ZE_DTSAIDA BetWeen '" + DTOS(_dDataInicial) + "'And '" + DTOS(_dDataFinal) + "'"   + Chr(13) + Chr(10)
	_cQry += " And ZE_PESO != 0
	_cQry += " And ZE_STATUS  In ('R','B','E','N','F','D','V')
	_cQry += " AND ZE_CLIENTE not IN "+FormatIn(GetMV("MV_XCLIAA"),",")
	If AllTrim(_cdTpRoman) == "Entrada"
        _cQry += " AND      ZE_TIPO    = 'E' "  + Chr(13) + Chr(10)
    ElseIf AllTrim(_cdTpRoman) == "Saida"
        _cQry += " AND      ZE_TIPO    = 'S' "  + Chr(13) + Chr(10)
    EndIf

	_cQry += " Group by ZE_ROMAN,ZE_TIPO "
	_cQry += " Order By ZE_DTSAIDA,ZE_ROMAN
	
	cArqTrab := ''
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(_cQry)), cTable, .T., .T. )
	TCSetField(cTable,"ZE_DTSAIDA","D",8,0)
	dbselectarea(cTable)
	(cTable)->(DBGOTOP())
	
	If Empty(cAlias)
		cArqTrab := CriaTrab(NIL,.f.)
		copy to &cArqTrab
		dbUseArea(.T.,,cArqTrab,cArqTrab,.F.,.F.)
	else
		(cAlias)->(dbGoTop())
		While !(cAlias)->(EOF())
			If AllTrim(cAlias) <> "SZE"
				(cAlias)->(RecLock(cAlias,.F.))
					(cAlias)->(dbDelete())
				(cAlias)->(MsUnlock())
			EndIf 
			(cAlias)->(dbSkip())
		EndDo
		While !(cTable)->(EOF())
			(cAlias)->(RecLock(cAlias,.T.))
			
			(cAlias)->ZE_ROMAN    := (cTable)->ZE_ROMAN
			(cAlias)->ZE_DTSAIDA  := (cTable)->ZE_DTSAIDA
			(cAlias)->ZE_PLACA    := (cTable)->ZE_PLACA
			(cAlias)->ZE_NOMOTOR  := (cTable)->ZE_NOMOTOR
			(cAlias)->ZE_AJUDA01  := (cTable)->ZE_AJUDA01
			(cAlias)->ZE_AJUDA02  := (cTable)->ZE_AJUDA02
			(cAlias)->ZE_PESO     := (cTable)->ZE_PESO
			(cAlias)->ZE_OBSERV   := (cTable)->ZE_OBSERV
			(cAlias)->ZE_PLIQUI   := (cTable)->ZE_PLIQUI
			(cAlias)->ZE_TIPO     := (cTable)->ZE_TIPO
			
			
			(cAlias)->(MsUnlock())
			(cTable)->(dbSkip())
		EndDo
		(cAlias)->(dbGoTop())
	EndIF
	(cTable)->(dbCLoseArea(cTable))
	
	nPesoTotal := 0
	nPesoVarejo:= 0
	nPesoAtacado:= 0
	nPesoEntrada:= 0
	CalcPesoDiv( cClienteIni,cClienteFim,dDataInicial,dDataFinal )
	nPesoTotal := PesoTotal()
	
	If Type("oPesoT") != "U"
		oPesoT:SetText(Transform(nPesoTotal,"@E 999,999,999,999.99") )
	EndIF
	If Type("oPesoV") != "U"                                                
		oPesoV:SetText(Transform(nPesoVarejo,"@E 999,999,999,999,999.99"))
	EndIF
	If Type("oPesoE") != "U"                                                
		oPesoE:SetText(Transform(nPesoEntrada,"@E 999,999,999,999,999.99"))
	EndIF
	If Type("oPesoA") != "U"
		oPesoA:SetText(Transform(nPesoAtacado,"@E 999,999,999,999,999.99"))
	EndIF
	If Type("oPesoN") != "U"
		oPesoN:SetText(Transform(nPesoAtacado + nPesoVarejo,"@E 999,999,999,999,999.99"))
	EndIF
	
Return cArqTrab

/*
Auto      : Diego
Rotina    : AAFATP3A
Descricao : Tela de Detalhes
*/
User Function AAFATP3A(cRoman, lwNovo, cwStatus,_xdEmp)
	LOcal oWindow := Nil
	
	Local cAlias  := 'SZE'
	Local _aARea  := GetArea()
	Local aCabec  := {'','Vendedor','Documento','Serie','Cliente','Loja','Nome','Dt. Saida','Valor','Peso Nota','Recebedor','DT. Recebimento','Observacao'}
	Local cTable  := GetNextAlias()
	
	Default _xdEmp := FwCompany()
	
	aLegenda := {{"ENABLE"     , "Em aberto"},;
	{"BR_PINK"    , "Pré-Romaneio"},;
	{"BR_AMARELO" , "Romaneio"    },;
	{"BR_VERMELHO", "Entregue"    },;
	{"BR_LARANJA" , "Nova Entrega"},;
	{"BR_CINZA"   , "Vem Buscar"  },;
	{"BR_AZUL"    , "Endereço não encontrado"},;
	{"BR_PRETO"   , "Venda com Devolução"},;
	{"BR_MARROM"  , "Venda Estornada do Romaneio"},;
	{"BR_BRANCO"  , "Local Fechado"}}
	
	Private oBrw    := Nil
	Private oSay1   := Nil
	Private oSay2   := Nil
	Private oSay3   := Nil
	
	Private cSay1   := ''
	Private cSay2   := ''
	Private cSay3   := ''
	Private nPesoRom:= 0
	Private cChave  := ''
	Private aFiliais := FWAllFilial()
	
	oFont := TFont():New('Courier new',,-12,.T.)
	
	cChave := xFilial('SZE') + cRoman
	
	SZE->(dbSetORder(1))
	SZE->(dbGoTop())
	SZE->(dbSeek(cChave) )
	nPesoRom := 0
	
	cFilter := SZE->(dbFilter())
	
	dbSelectArea('SZE')
	
	
	_cQry := " SELECT  ZE_FILIAL,ZE_ROMAN,ZE_DOC,ZE_SERIE,ZE_MOTOR,ZE_NOMOTOR,ZE_PLACA,ZE_CLIENTE,ZE_LOJACLI,ZE_NOMCLI,ZE_FILSAID,ZE_ORCAMEN,ZE_SEQ,ZE_VALOR,ZE_DTVENDA,ZE_DTROMAN,ZE_STATUS,ZE_NOMREC,ZE_HORREC,ZE_DTREC,ZE_BAIRRO,ZE_ORIGEM,ZE_VEND,ZE_FILORIG,ZE_OBSERV,ZE_ITROM,ZE_PEDIDO,ZE_ITPED,ZE_PRODUTO,ZE_DESC,ZE_QTDORIG,ZE_SALDO,ZE_QTDENT,ZE_DTSAIDA,ZE_ROMANT,ZE_ITROMAT,ZE_PESO,ZE_PLIQUI,ZE_PBRUTO,ZE_AJUDA01,ZE_AJUDA02,ZE_OBSENT,ZE_FILLOJ,ZE_USERLGI,ZE_USERLGA,ZE_TICKET1,ZE_DTPESO,ZE_HRPESO,ZE_TIPO,ZE_EMPORIG,MAX(A3_NOME) A3_NOME "
	_cQry += "   FROM ( " 
	
	For nX:=2 To Len(aFiliais)
		_cQry += " 			Select A.*,ISNULL(A3_NOME,'0') A3_NOME  From "+RetSQLName("SZE")+"  A WITH(NOLOCK) "    
		_cQry += " 			Left Outer Join SF2"+Alltrim(aFiliais[nX])+"0 F2 WITH(NOLOCK) ON F2_DOC = ZE_DOC "
		_cQry += " 			AND F2_SERIE = ZE_SERIE AND F2_CLIENTE = ZE_CLIENTE AND F2_LOJA = ZE_LOJACLI /*AND F2_FILIAL = '00'*/ AND F2.D_E_L_E_T_ = '' "     
		_cQry += " 			LEFT OUTER JOIN "+RetSQLName("SA3")+" A3 WITH(NOLOCK) ON A3_COD = F2.F2_VEND1 " 
		_cQry += " 			Where A.D_E_L_E_T_ = '' "
		_cQry += " 			And ZE_FILIAL = '" + SZE->(xFilial('SZE')) + "'"
		_cQry += " 			And ZE_ROMAN = '" + cRoman + "'" 
		If !lwNovo 
			_cQry += " And ZE_PESO != 0 "
		Else 
			_cQry += " And ZE_STATUS = '" + cwStatus + "' "
		EndIf
		If nX<> Len(aFiliais)
			_cQry += " 			UNION ALL " 	
		EndIf
	Next nX

	_cQry += "   ) AS B "
	_cQry += "   GROUP BY  ZE_FILIAL,ZE_ROMAN,ZE_DOC,ZE_SERIE,ZE_MOTOR,ZE_NOMOTOR,ZE_PLACA,ZE_CLIENTE,ZE_LOJACLI,ZE_NOMCLI,ZE_FILSAID,ZE_ORCAMEN,ZE_SEQ,ZE_VALOR,ZE_DTVENDA,ZE_DTROMAN,ZE_STATUS,ZE_NOMREC,ZE_HORREC,ZE_DTREC,ZE_BAIRRO,ZE_ORIGEM,ZE_VEND,ZE_FILORIG,ZE_OBSERV,ZE_ITROM,ZE_PEDIDO,ZE_ITPED,ZE_PRODUTO,ZE_DESC,ZE_QTDORIG,ZE_SALDO,ZE_QTDENT,ZE_DTSAIDA,ZE_ROMANT,ZE_ITROMAT,ZE_PESO,ZE_PLIQUI,ZE_PBRUTO,ZE_AJUDA01,ZE_AJUDA02,ZE_OBSENT,ZE_FILLOJ,ZE_USERLGI,ZE_USERLGA,ZE_TICKET1,ZE_DTPESO,ZE_HRPESO,ZE_TIPO,ZE_EMPORIG " 	   
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQry), cTable, .T., .T. )
	TCSetField(cTable,"ZE_DTSAIDA","D",8,0)
	TCSetField(cTable,"ZE_DTREC","D",8,0)
	
	cAlias := CriaTrab(NIL,.f.)
	copy to &cAlias
	
	dbUseArea(.T.,,cAlias,cAlias,.F.,.F.)
	
	(cAlias)->(dbgoTop())
	
	(cAlias)->(DBEVAL({|| nPesoRom += (cAlias)->ZE_PLIQUI}  ) )
	
	(cAlias)->(dbGoTop())
	
	DEFINE DIALOG oWindow TITLE "Notas no do Romaneio" FROM 001,001 TO 550,1000 PIXEL
	
	@ 003,005 TO 55,500 label "" OF oWindow PIXEL
	
	@ 018,007 Say "Numero da Entrega:"  Size 70,10 Pixel Of oWindow
	@ 018,077 Say (cAlias)->ZE_ROMAN         Size 40,10 Pixel Of oWindow
	@ 030,007 Say "Peso Balanca:  "     Size 40,10 Pixel Of oWindow
	@ 030,077 Say Transform((cAlias)->ZE_PESO,"@E 999,999,999.99")    COLOR CLR_RED Size 40,10 Pixel Of oWindow
	@ 040,007 Say "Peso Romaneio(Notas):  "     Size 70,10 Pixel Of oWindow
	@ 040,077 Say Transform(nPesoRom,"@E 999,999,999.99")    COLOR CLR_RED Size 40,10 Pixel Of oWindow
	
	@ 023,280 Button "&Legenda" Size 40,13 Pixel of owindow Action BrwLegenda("Cadastro de Romaneio","Legendas",aLegenda)
	@ 023,330 Button "&Fechar" Size 40,13 Pixel of oWindow Action oWindow:End()
	
	@ 060,005 TO 225,500 label "Itens" OF oWindow PIXEL
	
	oBrw := TcBrowse():New ( 070,007,490,140 , , aCabec,/*[ aColSizes]*/, oWindow, /*[ cField]*/,  , , /*[ bChange]*/, /*[ bLDblClick]*/, /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/,  cAlias, /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )
	oBrw:bLine := {|| {;
								LoadBitmap(GetResources(),aLeg[ aScan(aLeg,{|x|  x[01] == (cAlias)->ZE_STATUS } ) ][02] ),;
								(cAlias)->A3_NOME,;
								(cAlias)->ZE_DOC,;
								(cAlias)->ZE_SERIE,;
								(cAlias)->ZE_CLIENTE,;
								(cAlias)->ZE_LOJACLI,;
								(cAlias)->ZE_NOMCLI,;
								(cAlias)->ZE_DTSAIDA,;
								Transform( (cAlias)->ZE_VALOR,"@E 999,999,999.99"),;
								Transform( (cAlias)->ZE_PLIQUI,"@E 999,999,999.99"),;
								(cAlias)->ZE_NOMREC,;
								(cAlias)->ZE_DTREC,;
								If( AtuSC5((cAlias)->ZE_FILORIG,(cAlias)->ZE_DOC,(cAlias)->ZE_SERIE) ,;
								(cAlias)->ZE_OBSERV, (cAlias)->ZE_OBSERV) }  } 
	@ 230,450 Button "&Histórico" Size 40,13 Pixel of oWindow Action MsgRun('Filtrando Dados...' ,,{|| historic((cAlias)->ZE_DOC,(cAlias)->ZE_SERIE), oWindow:Refresh() })

	
	oBrw:BLDBLCLICK := {||  MsgRun('Filtrando Dados, Aguarde... '  ,, {|| u_AAFATP2A( cAlias ) } ) }
	@ 230,450 Button "&Histórico" Size 40,13 Pixel of oWindow Action MsgRun('Filtrando Dados...' ,,{|| historic((cAlias)->ZE_DOC,(cAlias)->ZE_SERIE), oWindow:Refresh() })

	@ 230,005 TO 270,500 label "Rodape" OF oWindow PIXEL
	
	oSay1:= TSay():New(240,008,{||''},oWindow,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,400,20)
	oSay2:= TSay():New(250,008,{||''},oWindow,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,400,20)
	oSay3:= TSay():New(260,008,{||''},oWindow,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,400,20)
	AtuSC5((cAlias)->ZE_FILORIG , (cAlias)->ZE_DOC , (cAlias)->ZE_SERIE)
	
	Activate Dialog oWindow Centered
	
	(cAlias)->(dbCloseArea(cAlias))
	
	If File(cAlias)
		fErase(cAlias)
	EndIf
	
	RestArea(_aARea)
Return Nil

//Serie  1  / 2  / 3
//      02 / 00 / 01
Static Function CalcPesoDiv(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal)
	Local _cQry := ''
	
	_cQry += " select C5_ORCRES,SUM(PesoTotal) PESOTOTAL From (
	_cQry += " select case"
	_cQry += "           When C5_ORCRES is Null And ZE_TIPO = 'E' then '0'
	_cQry += "           When Len(RTRIM(C5_ORCRES)) = 0 Then '1'"
	_cQry += "           else '2' End C5_ORCRES"
	_cQry += "        ,Sum(B1_PESO *  Coalesce(D2_QUANT,D1_QUANT,0) ) PesoTotal
	_cQry += "    from " + RetSqlName('SZE') + " A
	_cQry += "   Left Outer Join " +  RetSqlName('SD2') + " On D2_FILIAL = ZE_FILORIG And D2_DOC = ZE_DOC and ZE_SERIE = D2_SERIE 
	_cQry += "   Left Outer Join " +  RetSqlName('SC5') + " on D2_FILIAL = C5_FILIAL And C5_NUM = D2_PEDIDO
	_cQry += "   Left Outer Join " +  RetSqlName('SD1') + " D1 WITH(NOLOCK) On D1_FILIAL = ZE_FILORIG and D1_DOC = ZE_DOC and ZE_SERIE = D1_SERIE And ZE_CLIENTE = D1_FORNECE And ZE_LOJACLI = D1_LOJA And ZE_TIPO = 'E'"
	_cQry += "   Left Outer Join " +  RetSqlName('SB1') + " on B1_COD = isNull(D2_COD,D1_COD)
	_cQry += " WHERE A.D_E_L_E_T_ = '' "
	_cQry += " ANd ZE_CLIENTE BetWeen '" + _cClienteIni + "'And '" + _cClienteFim + "'"               + Chr(13) + Chr(10)
	_cQry += " And ZE_DTSAIDA BetWeen '" + DTOS(_dDataInicial) + "'And '" + DTOS(_dDataFinal) + "'"   + Chr(13) + Chr(10)
	_cQry += " And ZE_STATUS in ('R','E','B')    
    _cQry += " AND ZE_CLIENTE not IN "+FormatIn(GetMV("MV_XCLIAA"),",")
    If AllTrim(_cdTpRoman) == "Entrada"
        _cQry += " AND      ZE_TIPO    = 'E' "  //+ Chr(13) + Chr(10)
    ElseIf AllTrim(_cdTpRoman) == "Saida"
        _cQry += " AND      ZE_TIPO    = 'S' "  //+ Chr(13) + Chr(10)
    EndIf
	//_cQry += " group by C5_ORCRES
	_cQry += " group by case When C5_ORCRES is Null And ZE_TIPO = 'E' then '0' When Len(RTRIM(C5_ORCRES)) = 0 Then '1' else '2' End"
	_cQry += " )A
	_cQry += " group by C5_ORCRES
	
	cTable := GetNextAlias()
	dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQry), cTable, .T., .T. )
	
	While !(cTable)->(EOF())
	    If (cTable)->C5_ORCRES == '0'
	        nPesoEntrada  += (cTable)->PESOTOTAL
		Elseif (cTable)->C5_ORCRES == '2'
			nPesoVarejo  += (cTable)->PESOTOTAL
		Else
			nPesoAtacado += (cTable)->PESOTOTAL
		EndIf
		(cTable)->(dbSkip())
	Enddo
	(cTable)->(dbCloseArea(cTable))
	
Return

Static Function PesoTotal()
	Local _cQry  := ''
	Local cTable := GetNextAlias()
	Local _aArea := GetArea()
	
	_cQry += " Select SUM(ZE_PESO) ZE_PESO   "                                                      + Chr(13) + Chr(10)
	_cQry += " From (  "                                                                            + Chr(13) + Chr(10)
	_cQry += " select ZE_ROMAN,MAX(ZE_PESO)  ZE_PESO from " + RetSqlName("SZE")                     + Chr(13) + Chr(10)
	_cQry += " WHere D_E_L_E_T_ = '' "                                                              + Chr(13) + Chr(10)
	_cQry += " ANd ZE_CLIENTE BetWeen '" + cClienteIni + "'And '" + cClienteFim + "'"               + Chr(13) + Chr(10)
	_cQry += " And ZE_DTSAIDA BetWeen '" + DTOS(dDataInicial) + "'And '" + DTOS(dDataFinal) + "'"   + Chr(13) + Chr(10)
	_cQry += " AND ZE_CLIENTE not IN "+FormatIn(GetMV("MV_XCLIAA"),",")
	_cQry += " And ZE_STATUS In ('R','E','B')
	If AllTrim(_cdTpRoman) == "Entrada"
        _cQry += " AND      ZE_TIPO    = 'E' "  + Chr(13) + Chr(10)
    ElseIf AllTrim(_cdTpRoman) == "Saida"
        _cQry += " AND      ZE_TIPO    = 'S' "  + Chr(13) + Chr(10)
    EndIf
	_cQry += " group by ZE_ROMAN "                                                                  + Chr(13) + Chr(10)
	_cQry += " ) A"
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(_cQry)), cTable, .T., .T. )
	
	nPesoTotal := (cTable)->ZE_PESO
	(cTable)->(dbCloseArea(cTable))
	
	RestArea(_aArea)
	
Return nPesoTotal

Static Function AtuSC5(_cFilial,_cDoc,_cSerie)
	SC5->(dBSetORder(1))
	SA1->(dBSetORder(1))
	SD2->(dbSetOrder(3))
	
	SD2->(dbSeek(_cFilial + _cDoc + _cSerie))
	_cPedido := SD2->D2_PEDIDO
	
	SC5->(dBSeek(_cFilial + _cPedido))
	SA1->(dBSeek( xFilial('SA1') + SC5->(C5_CLIENTE + C5_LOJACLI) ))
	
	IF Empty(SC5->C5_ORCRES)
		oSay1:SetText('Endereco: ' + Alltrim(SA1->A1_END) + '    ' + Alltrim(SA1->A1_BAIRRO) + '   ' + Alltrim(SA1->A1_MUN) + '-' + SA1->A1_EST)
		oSay2:SetText('Entregar em: ' + Alltrim(SC5->C5_ENDENT) + '   ' + Alltrim(SC5->C5_BAIRROE)+'  ' + Alltrim(SC5->C5_MUNE) + '-'+Alltrim(SC5->C5_ESTE) )
		oSay3:SetText(Alltrim(SC5->C5_OBSENT1) + Alltrim(SC5->C5_OBSENT2) )
	else
		SL1->(dbSeek(SC5->C5_FILIAL + SC5->C5_ORCRES))
		oSay1:SetText('Endereco: ' + Alltrim(SA1->A1_END) + '    ' + Alltrim(SA1->A1_BAIRRO) + '   ' + Alltrim(SA1->A1_MUN) + '-' + SA1->A1_EST)
		oSay2:SetText('Entregar em: ' + Alltrim(SL1->L1_ENDENT) + '   ' + Alltrim(SL1->L1_BAIRROE)+'  ' + Alltrim(SL1->L1_MUNE) + '-'+Alltrim(SL1->L1_ESTE) )
		oSay3:SetText(Alltrim(SL1->L1_OBSENT1) + Alltrim(SL1->L1_OBSENT2) )
	EndIf
	
Return .T.

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ Historic   ¦ Autor ¦ Arlindo Neto         ¦ Data ¦ 25/09/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ TELA DE CONSULTA DE HISTÓRICO DAS NOTAS NO ROMANEIO			   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static function historic(cNota,cSerie)
 Local   cVar     := Nil
 Local   oGet     := Nil
 Private cAlias   := Alias()
 Private oDlg     := Nil
 Private oLbx     := Nil
 Private aVetor   := {}
 Private oMainWd  := Nil 
                          
  aAdd( aVetor , { "", "", "", "", "", "", "" } )
  
  
  PesquisaRom(cNota,cSerie) //  Pesquisa("000056963", "2")
  
  DEFINE MSDIALOG oDlg TITLE "Consulta de histórico das notas em romaneio" From 8,0 To 30,120 OF oMainWd

    @ 015,005 LISTBOX oLbx VAR cVar FIELDS HEADER "Romaneio", "Documento","Serie","Data", "Hora","Usuário","Operação";
				  SIZE 450,135 OF oDlg PIXEL
	
	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| { aVetor[oLbx:nAt,1],;
							  aVetor[oLbx:nAt,2],;
							  aVetor[oLbx:nAt,3],;
							  aVetor[oLbx:nAt,4],;
							  aVetor[oLbx:nAt,5],;
							  aVetor[oLbx:nAt,6],;
							  aVetor[oLbx:nAt,7]}}	
	
  ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oDlg:End() },{||oDlg:End()}) CENTERED

Return Nil

//*************************************************************************************************

Static Function PesquisaRom(cNota,cSerie)
	
  cQry := "SELECT * "
  cQry +=   "FROM "+RetSQLName("SZ4")+" A "	 
  cQry +=  "WHERE A.D_E_L_E_T_ = '' "
  cQry +=    "AND A.Z4_NUMNF   = '" + cNota  +"' "
  cQry +=    "AND A.Z4_SERIE   = '" + cSerie +"' "
  cQry +=  "ORDER BY R_E_C_N_O_ "
 
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "QRY", .T., .F. )
  TCSetField("QRY","Z4_DATAOP","D",8,0)

  aDel(aVetor,Len(aVetor))
  aSize(aVetor,0)
	
  While !QRY->(Eof())	
    aAdd( aVetor, { QRY->Z4_ROMANEI, QRY->Z4_NUMNF, QRY->Z4_SERIE, QRY->Z4_DATAOP, QRY->Z4_HORAOP, QRY->Z4_USUARIO,QRY->Z4_OPERACA } )
	 lMark := .F.
	 QRY->(DbSkip())		
  End
	
  QRY->(DbCloseArea())
	
  If Len(aVetor) = 0
      aAdd( aVetor , { "", "", "", "", "", "", "" } )
		MsgAlert("Não existe dados para consulta!!!",OemToAnsi("ATENCAO")  )
  EndIf
Return Nil
