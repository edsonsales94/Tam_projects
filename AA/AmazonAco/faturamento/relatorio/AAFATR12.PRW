#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATR12   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 09/02/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Este programa irá gerar um arquivo em excel com AS contas a   ¦¦¦
¦¦¦  (cont.)  ¦ receber por cliente                                           ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAFATR12()
  Private oObjDlg 
  Private cPerg    := PADR("AAFATR12",Len(SX1->X1_GRUPO))
  Private cProduto := "" 
  
  ValidPerg(cPerg)
  Pergunte(cPerg,.F.)
 
  @ 200,1 TO 380,380 DIALOG oObjDlg TITLE "Excel de Produção por Vendas"
  @ 02,005 TO 090,190
  @ 10,010 Say "Este programa irá gerar um arquivo em excel com os dados referentes a Produção"
  @ 18,010 Say "e Vendas de acordo com os parametros fornecidos pelo usuário."
  @ 65,098 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg)
  @ 65,128 BMPBUTTON TYPE 01 ACTION FATP01a()
  @ 65,158 BMPBUTTON TYPE 02 ACTION Close(oObjDlg)
  
  Activate Dialog oObjDlg Centered
Return Nil

//************************************************************************************************************************************************

Static Function FATP01a()
  Local   cArqDiv := AllTrim(Mv_Par04)+AllTrim(Mv_Par05)+xfilial("SD2")+DTOS(DDATABASE)+Str(Randomize( 1, 1000 ))+".xls"
  Private aFile   := {}

  Processa( {|| fTabTemp() }, "Gerando Arquivo temporário..." )
  Processa( {|| fGeraxls(cArqDiv) }, "Gerando Arquivo xls..." )
  
  Close(oObjDlg)
Return Nil

//***************************************************************************************************
//	Função para ler um arquivo txt e preencher a matriz aFile com todos os dados do txt              
//***************************************************************************************************
Static Function fGeraxls(cArqDiv)  
 Local   aLinha  := {}
 Local   aTotal  := {'SUB','TOTAL',0,0,0}   
 Private aExport := {}

  While !TMP1->(EOF())

	 aAdd(aLinha,TMP1->B1_XGRPINC   )
	 aAdd(aLinha,TMP1->Z2_DESC  )
	 aAdd(aLinha,Transform(TMP1->QTD_PROD, "@E 999,999,999.99") )
	 aAdd(aLinha,Transform(TMP1->QTD_VEND, "@E 999,999,999.99") )
	 aAdd(aLinha,Transform(TMP1->FATURA, "@E 999,999,999.99") )
	 
	 aTotal[3] += TMP1->QTD_PROD
	 aTotal[4] += TMP1->QTD_VEND
	 aTotal[5] += TMP1->FATURA

	 TMP1->(dbSkip())
	 
	 aAdd(aExport,Array(Len(aLinha)))
	 aExport[Len(aExport)] := aClone(aLinha)
	 aLinha := {}  
	 
  End
  TMP1->(dbCloseArea())
  
 aAdd(aLinha, aTotal[1])
 aAdd(aLinha, aTotal[2] )
 aAdd(aLinha,Transform( aTotal[3], "@E 999,999,999.99") )
 aAdd(aLinha,Transform( aTotal[4], "@E 999,999,999.99") )
 aAdd(aLinha,Transform( aTotal[5], "@E 999,999,999.99") )
 
 aAdd(aExport,Array(Len(aLinha)))
 aExport[Len(aExport)] := aClone(aLinha)
 aLinha := {}  
	 
  
  fwCstExp(cArqDiv)
Return Nil

//************************************************************************************************************************************************

Static Function ValidPerg(cPerg)

 PutSX1(cPerg,"01","Filial    	 ?", "", "", "mv_ch1", "C", 02, 0, 0, "G","","SM0","","","mv_par01")
 PutSX1(cPerg,"02","Data de    	 ?", "", "", "mv_ch2", "D", 08, 0, 0, "G","","   ","","","mv_par02")
 PutSX1(cPerg,"03","Data Ate   	 ?", "", "", "mv_ch3", "D", 08, 0, 0, "G","","   ","","","Mv_Par03") 
 PutSX1(cPerg,"04","Diretório  	 ?", "", "", "mv_ch4", "C", 20, 0, 0, "G","","   ","","","mv_par04")
 PutSX1(cPerg,"05","Arquivo    	 ?", "", "", "mv_ch5", "C", 30, 0, 0, "G","","   ","","","Mv_Par05")  

Return Nil                                    

//************************************************************************************************************                            f

Static Function fwCstExp(cArqDiv)
 Local cArqTxt    := cArqDiv
 Local nHdl       := fCreate(cArqTxt)
 Local cLinha     := "" 
 Local oExcelApp                           
 Local aNome := {}

  cLinha += "Cód Grp"   + Chr(9) + " Grupo"          + Chr(9) + "Produzida" + Chr(9) + "Vendida"      + Chr(9)    
  cLinha += "Faturamento" + Chr(13) +Chr(10)
                                                         
  If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
  EndIf            
   
  For i:=1 to Len(aExport)
    cLinha := ""
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
 Local nwAux  := 0                                                                    
                           
 _cQry := "SELECT B1_XGRPINC, Z2_DESC, SUM(QTD_PROD) QTD_PROD, SUM(QTD_VEND) QTD_VEND, SUM(FATURA) FATURA FROM ("
 _cQry += "	SELECT B1_XGRPINC, Z2_DESC, SUM(D3_QUANT) QTD_PROD, 0 QTD_VEND, 0 FATURA from " + RetSqlName("SD3") + " SD3 (NOLOCK)"
 _cQry += " 	INNER JOIN " + RetSqlName("SB1") + " SB1 (NOLOCK) ON B1_COD = D3_COD AND SB1.D_E_L_E_T_ = '' "
 _cQry += " 	LEFT OUTER JOIN " + RetSqlName("SZ2") + " SZ2 (NOLOCK) ON B1_XGRPINC = Z2_CODIGO AND SZ2.D_E_L_E_T_ = '' "
 _cQry += "  	WHERE D3_FILIAL = '"+ mv_par01 +"'"
 _cQry += " 	AND SD3.D_E_L_E_T_ = '' AND D3_ESTORNO = '' "
 _cQry += " 	AND D3_EMISSAO BETWEEN '"+ dtos(mv_par02) +"' AND '"+ dtos(mv_par03) +"' "
 _cQry += " 	AND D3_CF IN ('PR0','DE7')"
 _cQry += " 	GROUP BY B1_XGRPINC,Z2_DESC "
 _cQry += " UNION ALL "
 _cQry += " 	SELECT B1_XGRPINC, Z2_DESC,  0 QTD_PROD,  SUM(D2_QUANT) QTD_VEND  , CASE D2_CF WHEN '5401' THEN SUM(D2_BASEICM) ELSE SUM(D2_TOTAL) END  FATURA FROM " + RetSqlName("SD2") + " SD2 (NOLOCK) "
 _cQry += " 	INNER JOIN " + RetSqlName("SB1") + " SB1 (NOLOCK) ON B1_COD = D2_COD AND SB1.D_E_L_E_T_ = ''"
 _cQry += " 	LEFT OUTER JOIN " + RetSqlName("SZ2") + " SZ2 (NOLOCK) ON B1_XGRPINC = Z2_CODIGO AND SZ2.D_E_L_E_T_ = ''"
 _cQry += " 	WHERE D2_FILIAL = '"+ mv_par01 +"'"
 _cQry += " 	AND SD2.D_E_L_E_T_ = ''"
 _cQry += " 	AND D2_EMISSAO BETWEEN '"+ dtos(mv_par02) +"' AND '"+ dtos(mv_par03) +"' "
 _cQry += " 	AND D2_CF IN ( '5101', '5102', '5116', '5117','5118','5119', '5122', '5123', '5124','5125', '5401', '5405','6101','6102', '6107', '6108', '6109', '6110', '6116', '6117', '6118', '6119', '6122', '6403' )"
 _cQry += " 	AND NOT (D2_CF = '6109' and D2_PICM <> 0)"
 _cQry += " 	GROUP BY Z2_DESC, B1_XGRPINC, D2_CF"
 _cQry += " ) X "
 _cQry += " GROUP BY Z2_DESC, B1_XGRPINC "
 _cQry += " ORDER BY B1_XGRPINC"
                                                                                                         
  dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQry), "TMP1", .T., .T. )


Return Nil
