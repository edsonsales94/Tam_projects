#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATR13   ¦ Autor ¦ Francisco Carlos     ¦ Data ¦ 28/03/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Este programa irá gerar um arquivo em excel com as vendas por ¦¦¦
¦¦¦  (cont.)  ¦ vendedor por Estado                                           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAFATR13()
	Private oObjDlg
	Private cPerg    := PADR("AAFATR13",Len(SX1->X1_GRUPO))
	Private cProduto := ""

	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)

	@ 200,1 TO 380,380 DIALOG oObjDlg TITLE "Vendas x Estado"
	@ 02,005 TO 090,190
	@ 10,010 Say "Este programa irá gerar um arquivo em excel com as vendas por estado "
	@ 18,010 Say "de acordo com os parametros fornecidos pelo usuário."
	@ 65,098 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg)
	@ 65,128 BMPBUTTON TYPE 01 ACTION ESTP01a()
	@ 65,158 BMPBUTTON TYPE 02 ACTION Close(oObjDlg)

	Activate Dialog oObjDlg Centered
	Return Nil

//************************************************************************************************************************************************

Static Function ESTP01a()
	Local   cArqDiv := AllTrim(Mv_Par07)+AllTrim(Mv_Par08)+".xls"
	Private aFile   := {}

	Processa( {|| fTabTemp() }, "Gerando Arquivo temporário..." )
	Processa( {|| fGeraxls(cArqDiv) }, "Gerando Arquivo xls das Vendas..." )

	Close(oObjDlg)
	Return Nil

//***************************************************************************************************
//	Função para ler um arquivo txt e preencher a matriz aFile com todos os dados do txt
//***************************************************************************************************
Static Function fGeraxls(cArqDiv)
	//Local   lDiverg := .F.
	//Local   cwMsg   := ""
	Local   aLinha  := {}
	Private aExport := {}

	While !TMP1->(EOF())

		aAdd(aLinha,TMP1->F2_FILIAL)
		aAdd(aLinha,TMP1->D2_DOC)
		aAdd(aLinha,TMP1->F2_SERIE)
		aAdd(aLinha,TMP1->D2_ITEM)
		aAdd(aLinha,TMP1->D2_PEDIDO)
		aAdd(aLinha,DtoC(TMP1->EMISSAO_PEDIDO))
		aAdd(aLinha,TMP1->D2_GRUPO)
		aAdd(aLinha,TMP1->BM_DESC)
		aAdd(aLinha,TMP1->D2_COD)
		aAdd(aLinha,TMP1->B1_DESC)
		aAdd(aLinha,TMP1->B1_ESPECIF)
		aAdd(aLinha,Transform(TMP1->D2_QUANT,"@E 999,999,999.99"))
		aAdd(aLinha,TMP1->D2_CF)
		aAdd(aLinha,TMP1->F2_CLIENTE)
		aAdd(aLinha,TMP1->A1_NOME)
		aAdd(aLinha,TMP1->D2_EST)
		aAdd(aLinha,TMP1->F2_VEND1)
		aAdd(aLinha,TMP1->A3_NOME)
		aAdd(aLinha,TMP1->Tipo)
		aAdd(aLinha,DtoC(TMP1->EMISSAO_NOTA))
		aAdd(aLinha,TMP1->STATUS_ENTREGA)
		aAdd(aLinha,TMP1->COND_PG)
		aAdd(aLinha,TMP1->FORMA_PG)
		aAdd(aLinha,TMP1->FORMA_PG_ORC)
		aAdd(aLinha,Transform(TMP1->DINHEIRO,"@E 999,999,999.99"))
		aAdd(aLinha,Transform(TMP1->CARTAO,"@E 999,999,999.99")) 
		aAdd(aLinha,Transform(TMP1->VALOR,"@E 999,999,999.99"))
		aAdd(aLinha,Transform(TMP1->VALOR_COM_IMPOSTO,"@E 999,999,999.99"))
		aAdd(aLinha,Transform(TMP1->VALOR_BRUTO,"@E 999,999,999.99"))
		aAdd(aLinha,Transform(TMP1->CUSTO_MEDIO,"@E 999,999,999.99"))
		

		TMP1->(dbSkip())

		aAdd(aExport,Array(Len(aLinha)))
		aExport[Len(aExport)] := aClone(aLinha)
		aLinha := {}

	End
	TMP1->(dbCloseArea())

	fwCstExp(cArqDiv)
	ApMsgInfo("Processo finalizado")
	Return Nil

//************************************************************************************************************************************************

Static Function ValidPerg(cPerg)

U_PIPutSx1(cPerg,"01","Data de    	  ?", "", "", "mv_ch1", "D", 08, 0, 0, "G","","   ","","","mv_par01")
U_PIPutSx1(cPerg,"02","Data Ate   	  ?", "", "", "mv_ch2", "D", 08, 0, 0, "G","","   ","","","Mv_Par02")
U_PIPutSx1(cPerg,"03","Vendedor de    ?", "", "", "mv_ch3", "C", 06, 0, 0, "G","","SA3","","","mv_par03")
U_PIPutSx1(cPerg,"04","Vendedor Ate   ?", "", "", "mv_ch4", "C", 06, 0, 0, "G","","SA3","","","Mv_Par04")
U_PIPutSx1(cPerg,"05","Filial de      ?", "", "", "mv_ch5", "C", 02, 0, 0, "G","","SM0","","","mv_par05")
U_PIPutSx1(cPerg,"06","Filial Ate     ?", "", "", "mv_ch6", "C", 02, 0, 0, "G","","SM0","","","Mv_Par06")
U_PIPutSx1(cPerg,"07","Diretório  	  ?", "", "", "mv_ch7", "C", 90, 0, 0, "G","","   ","","","mv_par07")
U_PIPutSx1(cPerg,"08","Arquivo    	  ?", "", "", "mv_ch8", "C", 90, 0, 0, "G","","   ","","","Mv_Par08")
U_PIPutSx1(cPerg,"09",PADR("Considera?",29),"","", "mv_ch9",'N', 01, 0, 0, "C",""," "	,"","","mv_par09","Faturamento","Faturamento","Faturamento",'',"Carregamento","Carregamento","Carregamento")
U_PIPutSx1(cPerg,"10","Cliente de    ?", "", "", "mv_cha", "C", 06, 0, 0, "G","","SA1","","","mv_par03")
U_PIPutSx1(cPerg,"11","Cliente Ate   ?", "", "", "mv_chb", "C", 06, 0, 0, "G","","SA1","","","Mv_Par04")

Return Nil

//************************************************************************************************************                            f

Static Function fwCstExp(cArqDiv)
	Local cArqTxt    := cArqDiv
	Local nHdl       := fCreate(cArqTxt)
	Local cLinha     := "" //Chr(9)+"Relatório"+Chr(13)+Chr(10)
	Local oExcelApp
	//Local aNome := {}
	Local J           := 0
	Local i           := 0

	cLinha += "Filial"            + Chr(9)        + "Documento"             + Chr(9) + "Série"          + Chr(9) + "Item"         + Chr(9)
	cLinha += "Pedido"            + Chr(9)        + "Emissao Pedido"        + Chr(9) + "Cod Grupo"      + Chr(9) + "Desc Grupo"   + Chr(9)
	cLinha += "Cod Produto"       + Chr(9)        + "Desc Produto"          + Chr(9) + "Produto Ext."   + Chr(9) + "Quantidade"   + Chr(9)
	cLinha += "CF"  + Chr(9)      + "Cod Cliente" + Chr(9) +"Desc Cliente"  + Chr(9) + "Estado"         + Chr(9)
	cLinha += "Cod Vendedor"      + Chr(9)        + "Desc Vendedor"         + Chr(9) + "Tipo"           + Chr(9) + "Emissao Nota" + Chr(9)
	cLinha += "Status_Entrega"    + Chr(9)        + "Cond_PG"               + Chr(9) + "Forma_PG"       + Chr(9) + "Forma_PG_ORC" + Chr(9)
	cLinha += "Dinheiro"          + Chr(9)        + "Cartao"                + Chr(9)
	cLinha += "Vlr sem Impostos"  + Chr(9)        + "Vlr com Impostos"      + Chr(9) + "VALOR_BRUTO"    + Chr(9) + "CUSTO_MEDIO"  + Chr(9)  + Chr(13)+Chr(10)

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
	If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
		MsgStop( 'MsExcel nao instalado' )
		Return
	EndIf
	oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
	oExcelApp:WorkBooks:Open(cArqDiv)
	oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.

	Return Nil

//
//  .-----------------------------------------------------------------------------.
// |     Cria tabela temporária que retorne o tempo para a criacao de um produto  |
//  '-----------------------------------------------------------------------------'
//
Static Function fTabTemp()
	Local _cQry  := ""
	//Local nwAux  := 0
	/* Alterado Para igualar a lógica aplicada na Nova Tela de Venda, - Williams Messa - 10/07/2019	
	Alterado Para igualar a lógica aplicada na Nova Tela de Venda, - Williams Messa - 10/07/2019
	*/
	_cQry := CHR(13)+CHR(10)+ "SELECT F2_FILIAL, D2_DOC, F2_SERIE,D2_ITEM,D2_PEDIDO, CAST (C5_EMISSAO AS date) AS EMISSAO_PEDIDO, "
	_cQry += CHR(13)+CHR(10)+ " D2_GRUPO,BM_DESC , D2_COD,B1_DESC,B1_ESPECIF,D2_QUANT, "
	_cQry += CHR(13)+CHR(10)+ " D2_CF, F2_CLIENTE,A1_NOME,D2_EST,F2_VEND1,A3_COD,A3_NOME, " 
	_cQry += CHR(13)+CHR(10)+ " (CASE"
	_cQry += CHR(13)+CHR(10)+ "	      WHEN A3_TIPO = 'E' THEN 'Representante' "
	_cQry += CHR(13)+CHR(10)+ "       WHEN A3_TIPO = 'I' THEN 'Comercial'  "
	_cQry += CHR(13)+CHR(10)+ "       ELSE 'Industria'  "
	_cQry += CHR(13)+CHR(10)+ " END) AS Tipo, "
	_cQry += CHR(13)+CHR(10)+ " CAST (F2_EMISSAO AS DATE) EMISSAO_NOTA, "
	_cQry += CHR(13)+CHR(10)+ "	(CASE  " 
	_cQry += CHR(13)+CHR(10)+ " 	  WHEN ZE_STATUS ='' THEN 'INCLUSAO DE REGISTRO' "
	_cQry += CHR(13)+CHR(10)+ " 	  WHEN ZE_STATUS ='P' THEN 'PRE-ROMANEIO' "
	_cQry += CHR(13)+CHR(10)+ " 	  WHEN ZE_STATUS ='R' THEN 'ROMANEIO' "
	_cQry += CHR(13)+CHR(10)+ " 	  WHEN ZE_STATUS ='E' THEN 'ENTREGA' "
	_cQry += CHR(13)+CHR(10)+ " 	  WHEN ZE_STATUS ='B' THEN 'CLIENTE RETIRA' "
	_cQry += CHR(13)+CHR(10)+ " 	  ELSE 'NAO CLASSIFICADO' "
	_cQry += CHR(13)+CHR(10)+ " END) AS STATUS_ENTREGA, "
	_cQry += CHR(13)+CHR(10)+ " ISNULL(E4_COND, 'CN') AS COND_PG, "
	_cQry += CHR(13)+CHR(10)+ " ISNULL(E4_FORMA, 'CN') AS FORMA_PG, "
	_cQry += CHR(13)+CHR(10)+ " L1_FORMPG AS FORMA_PG_ORC, "
	_cQry += CHR(13)+CHR(10)+ " SUM(B2_CM1) AS CUSTO_MEDIO, "
	_cQry += CHR(13)+CHR(10)+ " SUM(L1_DINHEIR) AS DINHEIRO, "
	_cQry += CHR(13)+CHR(10)+ " SUM(L1_CARTAO) AS CARTAO, "
	_cQry += CHR(13)+CHR(10)+ " SUM(D2_TOTAL) AS VALOR , "
	_cQry += CHR(13)+CHR(10)+ " SUM(D2_TOTAL + D2_ICMSRET) AS VALOR_COM_IMPOSTO, "
	_cQry += CHR(13)+CHR(10)+ " SUM(D2_VALBRUT) AS VALOR_BRUTO "
	_cQry += CHR(13)+CHR(10)+ " FROM "       + RetSqlName("SF2")+ " (NOLOCK) SF2 "
	_cQry += CHR(13)+CHR(10)+ " LEFT OUTER JOIN SA1010 (NOLOCK) SA1 ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_='' "
	_cQry += CHR(13)+CHR(10)+ " LEFT OUTER JOIN " + RetSqlName("SA3")+ " (NOLOCK) SA3 ON F2_VEND1 = A3_COD   AND SA3.D_E_L_E_T_='' "
	_cQry += CHR(13)+CHR(10)+ " INNER JOIN " + RetSqlName("SD2")+ " (NOLOCK) SD2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND F2_SERIE= D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND SD2.D_E_L_E_T_='' "
	_cQry += CHR(13)+CHR(10)+ " INNER JOIN " + RetSqlName("SB1")+ " (NOLOCK) SB1 ON B1_COD = D2_COD   AND SB1.D_E_L_E_T_='' "
	_cQry += CHR(13)+CHR(10)+ " INNER JOIN " + RetSqlName("SBM")+ " (NOLOCK) SBM ON BM_GRUPO = D2_GRUPO AND SBM.D_E_L_E_T_='' "
	_cQry += CHR(13)+CHR(10)+ " LEFT OUTER JOIN " + RetSqlName("SC5")+ " (NOLOCK) SC5 ON C5_FILIAL = D2_FILIAL AND  D2_PEDIDO = C5_NUM AND SC5.D_E_L_E_T_='' "
	_cQry += CHR(13)+CHR(10)+ " INNER JOIN " + RetSqlName("SF4")+ " (NOLOCK) SF4 ON F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_='' "
	_cQry += CHR(13)+CHR(10)+ " LEFT OUTER JOIN " + RetSqlName("SZE")+ " (NOLOCK) SZE ON ZE_DOC=F2_DOC AND ZE_SERIE=F2_SERIE AND ZE_CLIENTE=F2_CLIENTE AND ZE_LOJACLI=F2_LOJA AND ZE_FILORIG = F2_FILIAL AND SZE.D_E_L_E_T_='' AND ZE_STATUS NOT IN ('V', 'D') "
	_cQry += CHR(13)+CHR(10)+ " LEFT OUTER JOIN " + RetSqlName("SE4")+ " (NOLOCK) SE4 ON F2_COND = E4_CODIGO AND SE4.D_E_L_E_T_='' "
 	_cQry += CHR(13)+CHR(10)+ "	LEFT OUTER JOIN " + RetSqlName("SL1")+ " (NOLOCK) SL1 ON L1_FILIAL = C5_XFILRES AND L1_NUM = C5_XORCRES AND SL1.D_E_L_E_T_=''  "
	_cQry += CHR(13)+CHR(10)+ " INNER JOIN " + RetSqlName("SB2") +" (NOLOCK) SB2 ON D2_FILIAL = B2_FILIAL AND D2_COD = B2_COD AND D2_LOCAL = B2_LOCAL AND SB2.D_E_L_E_T_=''  "
	_cQry += CHR(13)+CHR(10)+ " WHERE F2_FILIAL BETWEEN '"+ mv_par05 +"' AND '"+ mv_par06 +"' "
	_cQry += CHR(13)+CHR(10)+ " And F2_EMISSAO BETWEEN  '"+ dtos(mv_par01) +"' AND '"+ dtos(mv_par02) +"' "
	_cQry += CHR(13)+CHR(10)+ " and F2_VEND1   BETWEEN '"+ mv_par03 +"' AND '"+ mv_par04 +"' "
	_cQry += CHR(13)+CHR(10)+ " and F2_CLIENTE BETWEEN '"+ mv_par10 +"' AND '"+ mv_par11 +"' "

	//Alteraç?o para considerar todos os carregamentos realizados, pela industria.
    If MV_PAR09 == 1 //Faturamento	
		_cQry += CHR(13)+CHR(10)+ "  AND ( SD2.D2_CF     IN ('5101', '5102', '5116', '5117', '5118', '5119', '5122', '5123', " 
		_cQry += CHR(13)+CHR(10)+ " '5124', '5125', '5401', '5405', '6101', '6102', '6107', '6108', "
		_cQry += CHR(13)+CHR(10)+ " '6109', '6110', '6116', '6117', '6118', '6119', '6122', '6403') OR SD2.D2_TES = '564' OR ( SD2.D2_CF IN ('5949','6501') AND SF4.F4_DUPLIC='S') ) "
	Else            //Carregamento somente a série 3	
		_cQry += CHR(13)+CHR(10)+ "  AND ( SD2.D2_CF     IN ('5101', '5102', '5116', '5117', '5118', '5119', '5122', '5123', " 
		_cQry += CHR(13)+CHR(10)+ " '5124', '5125', '5401', '5405', '6101', '6102', '6107', '6108','5905','5906', "
		_cQry += CHR(13)+CHR(10)+ " '6109', '6110', '6116', '6117', '6118', '6119', '6122', '6403') OR SD2.D2_TES = '564' OR ( SD2.D2_CF IN ('5949','6501') ) ) "
		_cQry += CHR(13)+CHR(10)+ " AND F2_SERIE ='3' "
	EndIf 
	
	_cQry += CHR(13)+CHR(10)+ " AND SF2.D_E_L_E_T_=' ' "
	_cQry += CHR(13)+CHR(10)+ " GROUP BY  F2_FILIAL,D2_DOC,F2_SERIE,D2_ITEM,D2_PEDIDO,C5_EMISSAO,D2_GRUPO,BM_DESC,D2_COD,B1_DESC,B1_ESPECIF,D2_QUANT, "	
	_cQry += CHR(13)+CHR(10)+ " D2_CF,F2_CLIENTE,A1_NOME,D2_EST,F2_VEND1,A3_COD,A3_NOME,A3_TIPO,F2_EMISSAO, ZE_STATUS, E4_COND,E4_FORMA,L1_FORMPG "
	
	_cQry += CHR(13)+CHR(10)+ " ORDER BY F2_FILIAL, F2_EMISSAO "
	  	  	
  	//" + RetSqlName("SD2") + " A WITH (NOLOCK) "
  	
  	MemoWrit("AAFATR13.sql",_cQry)

	dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQry), "TMP1", .T., .T. )
	
	TCSetField("TMP1","EMISSAO_PEDIDO" ,"D",8,0)
	TCSetField("TMP1","EMISSAO_NOTA" ,"D",8,0)


	Return Nil
