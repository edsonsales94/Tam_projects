#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATR06   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 08/09/2008 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Este programa irá gerar um arquivo em excel uma relação de    ¦¦¦
¦¦¦  (cont.)  ¦ pedido de vendas, de acordo com os parametros fornecidos.     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Alterações
26/12/2018 - Wladimir Vieira - ncluido campo C5_OBSENT1
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAFATR06()
	Private oObjDlg
	Private cPerg    := PADR("AAFATR001",Len(SX1->X1_GRUPO))
	Private cProduto := ""
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	@ 200,1 TO 380,380 DIALOG oObjDlg TITLE "Excel de Pedido de Vendas"
	@ 02,005 TO 090,190
	@ 10,010 Say "Este programa irá gerar um arquivo em excel uma relação de pedido de vendas"
	@ 18,010 Say "de acordo com os parametros fornecidos pelo usuário."
	@ 65,098 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg)
	@ 65,128 BMPBUTTON TYPE 01 ACTION ESTP01a()
	@ 65,158 BMPBUTTON TYPE 02 ACTION Close(oObjDlg)
	
	Activate Dialog oObjDlg Centered
Return Nil

//************************************************************************************************************************************************

Static Function ESTP01a()
	Local   cArqDiv := AllTrim(Mv_Par14)+AllTrim(Mv_Par15)+".xls"
	Private aFile   := {}
	
	Processa( {|| fTabTemp() }, "Gerando Arquivo temporário..." )
	Processa( {|| fGeraxls(cArqDiv) }, "Gerando Arquivo xls de pedidos..." )
	
	Close(oObjDlg)
Return Nil

//***************************************************************************************************
//	Função para ler um arquivo txt e preencher a matriz aFile com todos os dados do txt
//***************************************************************************************************
Static Function fGeraxls(cArqDiv)
	Local   lDiverg := .F.
	Local   cwMsg   := ""
	Local   aLinha  := {}
	Private aExport := {}
	
	While !TMP1->(EOF())
		
		aAdd(aLinha,TMP1->C5_FILIAL  )
		aAdd(aLinha,TMP1->C5_NUM     )
		aAdd(aLinha,dtoc(stod(TMP1->C5_EMISSAO)) )
		aAdd(aLinha,dtoc(stod(TMP1->C6_ENTREG )) )
		aAdd(aLinha,TMP1->A1_RISCO   )
		aAdd(aLinha,TMP1->C5_CLIENTE )
		aAdd(aLinha,TMP1->A1_NOME    )
	    aAdd(aLinha,TMP1->A1_EST   )
	    aAdd(aLinha,TMP1->A1_MUN   )
		aAdd(aLinha,TMP1->C5_VEND1   )
		aAdd(aLinha,TMP1->A3_NOME    )
		aAdd(aLinha,TMP1->C6_PRODUTO )
		aAdd(aLinha,TMP1->B1_ESPECIF )
		aAdd(aLinha,TMP1->B1_XDCRE   )
		aAdd(aLinha,Transform(TMP1->C6_QTDVEN, "@E 999,999,999.99") )
		aAdd(aLinha,Transform(TMP1->C6_QTDENT, "@E 999,999,999.99") )
		aAdd(aLinha,Transform(TMP1->C6_QTDVEN - TMP1->C6_QTDENT, "@E 999,999,999.99") )
		aAdd(aLinha,Transform(TMP1->C6_PRCVEN, "@E 999,999,999.99") )
		aAdd(aLinha,TMP1->E4_DESCRI )
		aAdd(aLinha,TMP1->C5_MENNOTA )
		aAdd(aLinha,TMP1->C5_OBSENT1 )
		aAdd(aLinha,Transform(TMP1->B2_QATU  , "@E 999,999,999.99") )
		aAdd(aLinha,Transform(TMP1->B2_QATUX , "@E 999,999,999.99") )
		aAdd(aLinha,Transform(TMP1->A1_LC    , "@E 999,999,999.99") )
		aAdd(aLinha,Transform(TMP1->E1_SALDO , "@E 999,999,999.99") )
		aAdd(aLinha,Transform(TMP1->SALDO_LC , "@E 999,999,999.99") )
		aAdd(aLinha,TMP1->C6_TES )  
		aAdd(aLinha,TMP1->C6_LOCAL )
		aAdd(aLinha,dtoc(stod(TMP1->E1_VENCREA)) )
		
		TMP1->(dbSkip())
		
		aAdd(aExport,Array(Len(aLinha)))
		aExport[Len(aExport)] := aClone(aLinha)
		aLinha := {}
		
	End
	TMP1->(dbCloseArea())
	
	u_fwCstExp(cArqDiv)
Return Nil

//************************************************************************************************************************************************

Static Function ValidPerg(cPerg)

	PutSX1(cPerg,"01","Filial de   	 ?", "", "", "mv_ch1", "C", 02, 0, 0, "G","","   ","","","mv_par01")
	PutSX1(cPerg,"02","Filial ate  	 ?", "", "", "mv_ch2", "C", 02, 0, 0, "G","","   ","","","mv_Par02")
	PutSX1(cPerg,"03","Pedido de   	 ?", "", "", "mv_ch3", "C", 06, 0, 0, "G","","SC5","","","mv_par03")
	PutSX1(cPerg,"04","Pedido ate  	 ?", "", "", "mv_ch4", "C", 06, 0, 0, "G","","SC5","","","mv_Par04")
	PutSX1(cPerg,"05","Vendedor de 	 ?", "", "", "mv_ch5", "C", 06, 0, 0, "G","","SA3","","","mv_par05")
	PutSX1(cPerg,"06","Vendedor ate	 ?", "", "", "mv_ch6", "C", 06, 0, 0, "G","","SA3","","","Mv_Par06")
	PutSX1(cPerg,"07","DCR de        ?", "", "", "mv_ch7", "C", 20, 0, 0, "G","","   ","","","mv_par07")
	PutSX1(cPerg,"08","DCR ate       ?", "", "", "mv_ch8", "C", 20, 0, 0, "G","","   ","","","mv_par08")
	PutSX1(cPerg,"09","Cliente de 	 ?", "", "", "mv_ch9", "C", 06, 0, 0, "G","","SA1","","","mv_par09")
	PutSX1(cPerg,"10","Cliente ate	 ?", "", "", "mv_cha", "C", 06, 0, 0, "G","","SA1","","","Mv_Par10")
	PutSX1(cPerg,"11","Produto de 	 ?", "", "", "mv_chb", "C", 15, 0, 0, "G","","SB1","","","mv_par11")
	PutSX1(cPerg,"12","Produto ate	 ?", "", "", "mv_chc", "C", 15, 0, 0, "G","","SB1","","","Mv_Par12")
	PutSX1(cPerg,"13","Status Pedido ?", "", "", "mv_chd", "N", 01, 0, 0, "C","","   ","","","mv_par13","Em aberto","","","","Atendidos", "","", "Todos")
	PutSX1(cPerg,"14","Diretório  	 ?", "", "", "mv_chb", "C", 20, 0, 0, "G","","   ","","","mv_par14")
	PutSX1(cPerg,"15","Arquivo    	 ?", "", "", "mv_chc", "C", 30, 0, 0, "G","","   ","","","Mv_Par15")
	PutSX1(cPerg,"16","Data de   	 ?", "", "", "mv_che", "D", 08, 0, 0, "G","","   ","","","mv_par16")
	PutSX1(cPerg,"17","Data ate  	 ?", "", "", "mv_chf", "D", 08, 0, 0, "G","","   ","","","mv_Par17")
	
	PutSX1(cPerg,"18","Considera Comercio	 ?", "", "", "mv_chg", "N", 1, 0, 0, "C","","   ","","","mv_Par18","SIM","SIM","SIM","","NAO","NAO","NAO")
	
Return Nil

//************************************************************************************************************                            f

User Function fwCstExp(cArqDiv)
	Local cArqTxt    := cArqDiv //GetTempPath()+"\"+AllTrim(Mv_Par15)+".xls" 
	Local nHdl       := Nil
	Local cLinha     := "" //Chr(9)+"Relatório"+Chr(13)+Chr(10)
	Local oExcelApp
	Local aNome := {}    
	
	//Default cArqDiv := 
		
	If File(cArqTxt)
		FErase(cArqTxt)
	Endif
	
	nHdl := fCreate(cArqTxt)
	
	cLinha += "FILIAL"       + Chr(9)
	cLinha += "PEDIDO"       + Chr(9) + "EMISSÃO"      + Chr(9) + "ENTREGA"       + Chr(9)+ "RISCO" + Chr(9) + "CLIENTE"       + Chr(9)
	cLinha += "NOME CLIENTE" + Chr(9) + "ESTADO" + Chr(9) + "MUNICIPIO" + Chr(9) + "VENDEDOR"     + Chr(9) + "NOME VENDEDOR" + Chr(9) + "PRODUTO"       + Chr(9)
	cLinha += "DESCRIÇÃO"    + Chr(9) + "DCR"          + Chr(9) + "QTDE VENDIDA"  + Chr(9) + "QTDE ENTREGUE" + Chr(9)
	cLinha += "SALDO" 		 + Chr(9) + "PREÇO"        + Chr(9) + "FORMA PAGAM."  + Chr(9) + "OBS. NOTA"     + Chr(9) + "OBS. PEDIDO" + Chr(9)
	cLinha += "ESTOQUE"      + Chr(9) + "ESTOQUE 14"   + Chr(9) + "LIMITE CRED." + Chr(9) + "TIT.ABERTO"    + Chr(9) + "SALDO LIMITE CRED."    + Chr(9) + "TES" + Chr(9) + "ARMAZEM" + Chr(9) + "PROXIMO VENCIMENTO"
	cLinha += Chr(13) +Chr(10)
	
	If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
	EndIf
	
	For i:=1 to Len(aExport)
		cLinha := ""
		//    IncRegua()
		If ValType(aExport[i])<>"A"
			clinha += aExport[i]
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
	
	If !ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
		MsgStop( 'Arquivo Gerado no Relatório informado!' )
		Return
	EndIf
	
	oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
	oExcelApp:WorkBooks:Open(cArqTxt)
	oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.
    oExcelApp:Destroy()
  // Abre o Excel com o arquivo criado exibido na Primeira planilha.
	
Return Nil

//
//  .-----------------------------------------------------------------------------.
// |     Cria tabela temporária que retorne o tempo para a criacao de um produto  |
//  '-----------------------------------------------------------------------------'
//
Static Function fTabTemp()
	Local _cQry  := ""
	Local nwAux  := 0
	
	_cQry := "SELECT A.C5_FILIAL, A.C5_NUM, A.C5_EMISSAO, B.C6_ENTREG, A.C5_CLIENTE, C.A1_NOME, C.A1_EST,C.A1_MUN, A.C5_VEND1,A.C5_OBSENT1, D.A3_NOME, B.C6_PRODUTO, B.C6_TES, B.C6_LOCAL, "
	_cQry +=        "E.B1_ESPECIF, E.B1_XDCRE, B.C6_QTDVEN, B.C6_QTDENT, A.C5_MENNOTA, B.C6_PRCVEN, F.E4_DESCRI, "
	_cQry += " ISNULL (SB2.B2_QATU, 0) AS B2_QATU, ISNULL(SB2X.B2_QATU, 0) AS B2_QATUX,
	_cQry += " C.A1_RISCO," 
	_cQry += " C.A1_LC,  "
	_cQry += " ISNULL(SE1.E1_VALLIQ,'0') AS E1_VALLIQ," 
	_cQry += " ISNULL(SE1.E1_SALDO,'0') AS E1_SALDO ,"
	_cQry += " C.A1_LC - ISNULL(SE1.E1_SALDO,0) SALDO_LC, ISNULL(E1_VENCREA,'') E1_VENCREA
	
	_cQry +=   "FROM " + RetSqlName("SC5") + " A "
	
	_cQry +=  "INNER JOIN " + RetSqlName("SC6") + " B "
	_cQry +=     "ON B.C6_FILIAL = A.C5_FILIAL "
	_cQry +=    " AND B.C6_NUM    = A.C5_NUM    "
	_cQry +=    " AND B.D_E_L_E_T_=' ' "
	iF mv_par18 == 02
	  _cQry +=    " And C6_LOCAL != '10' "
	EndIf
	                                    	
	_cQry +=  "INNER JOIN " + RetSqlName("SA1") + " C "
	_cQry +=     "ON C.A1_FILIAL = '" + xFilial("SA1") + "' "
	_cQry +=    "AND C.A1_COD    = A.C5_CLIENTE "
	_cQry +=    "AND C.A1_LOJA   = A.C5_LOJACLI "
	_cQry +=    "AND C.D_E_L_E_T_=' ' "
	
	_cQry +=  "INNER JOIN " + RetSqlName("SA3") + " D "
	_cQry +=     "ON D.A3_FILIAL = '" + xFilial("SA3") + "' "
	_cQry +=    "AND D.A3_COD    = A.C5_VEND1 "
	_cQry +=    "AND D.D_E_L_E_T_=' ' "
	
	_cQry +=  "INNER JOIN " + RetSqlName("SB1") + " E "
	_cQry +=     "ON E.B1_FILIAL = '" + xFilial("SB1") + " ' "
	_cQry +=    "AND E.B1_COD    = B.C6_PRODUTO "
	_cQry +=    "AND E.D_E_L_E_T_=' ' "
	
	_cQry +=  "LEFT JOIN " + RetSqlName("SB2") + " SB2 "
	_cQry +=     "ON SB2.B2_FILIAL = B.C6_FILIAL "
	_cQry +=    "AND SB2.B2_COD    = B.C6_PRODUTO "
	_cqry +=    "AND SB2.B2_LOCAL  = '01'"
	_cQry +=    "AND SB2.D_E_L_E_T_=' ' "
	
	_cQry +=  "LEFT JOIN " + RetSqlName("SB2") + " SB2X "
	_cQry +=     "ON SB2X.B2_FILIAL = B.C6_FILIAL "
	_cQry +=    "AND SB2X.B2_COD    = B.C6_PRODUTO "
	_cqry +=    "AND SB2X.B2_LOCAL  = '14'"
	_cQry +=    "AND SB2X.D_E_L_E_T_=' ' "

	_cQry +=  "INNER JOIN " + RetSqlName("SE4") + " F "
	_cQry +=     "ON F.E4_FILIAL = '" + xFilial("SE4") + " ' "
	_cQry +=    "AND F.E4_CODIGO = A.C5_CONDPAG "
	_cQry +=    "AND F.D_E_L_E_T_=' ' "
	
	_cQry +=  "LEFT OUTER JOIN ( "
	_cQry +=    "SELECT SE1.E1_CLIENTE, SE1.E1_LOJA, SUM(SE1.E1_VALLIQ) AS E1_VALLIQ, SUM(SE1.E1_SALDO) AS E1_SALDO "
	_cQry +=    "FROM "+RetSqlName("SE1")+" SE1 "
	_cQry +=    "WHERE SE1.D_E_L_E_T_ = ' ' "
	_cQry +=    "GROUP BY SE1.E1_CLIENTE, SE1.E1_LOJA "
	_cQry +=  ") SE1 ON SE1.E1_CLIENTE = C.A1_COD AND SE1.E1_LOJA = C.A1_LOJA "
	
	_cQry +=  "LEFT OUTER JOIN ( "
	_cQry +=    "SELECT SE1.E1_CLIENTE, SE1.E1_LOJA, MIN(E1_VENCREA) E1_VENCREA"
	_cQry +=    "FROM "+RetSqlName("SE1")+" SE1 "
	_cQry +=    "WHERE SE1.D_E_L_E_T_ = ' ' AND E1_SALDO > 0 "
	_cQry +=    "GROUP BY SE1.E1_CLIENTE, SE1.E1_LOJA "
	_cQry +=  ") SE1X ON SE1X.E1_CLIENTE = C.A1_COD AND SE1X.E1_LOJA = C.A1_LOJA "
	
	_cQry +=  "WHERE A.D_E_L_E_T_=' ' "
	_cQry +=    "AND A.C5_FILIAL  BETWEEN '" + mv_par01 + "' AND '" +mv_par02+ "' "
	_cQry +=    "AND A.C5_NUM     BETWEEN '" + mv_par03 + "' AND '" +mv_par04+ "' "
	_cQry +=    "AND A.C5_VEND1   BETWEEN '" + mv_par05 + "' AND '" +mv_par06+ "' "
	_cQry +=    "AND E.B1_XDCRE   BETWEEN '" + mv_par07 + "' AND '" +mv_par08+ "' "
	_cQry +=    "AND A.C5_CLIENTE BETWEEN '" + mv_par09 + "' AND '" +mv_par10+ "' "
	_cQry +=    "AND E.B1_COD     BETWEEN '" + mv_par11 + "' AND '" +mv_par12+ "' "
	_cQry +=    "AND A.C5_EMISSAO BETWEEN '" + Dtos(mv_par16) + "' AND '" +Dtos(mv_par17)+ "' "
	//	_cQry +=    "AND B.C6_BLQ <> 'R' "
	
	If mv_par13 == 1													// Em aberto
		_cQry += "AND B.C6_QTDVEN > B.C6_QTDENT AND B.C6_BLQ <> 'R' "		
	ElseIf mv_par13 == 2												// Atendidos
		_cQry += "AND (B.C6_QTDVEN <= B.C6_QTDENT Or B.C6_BLQ = 'R') "		
	EndIf
	
	_cQry +=  "ORDER BY A.C5_NUM "
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(_cQry)), "TMP1", .T., .F. ) 
	
	Memowrite("pedido_venda",_cQry)	
Return Nil

/*----------------------------------------------------------------------------------||
||       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||      AAAA       LL         LL         EE         CC        KK    KK   SS         ||
||     AA  AA      LL         LL         EE        CC         KK  KK     SS         ||
||    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   ||
||   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  ||
||  AA        AA   LL         LL         EE         CC        KK    KK          SS  ||
|| AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||----------------------------------------------------------------------------------*/