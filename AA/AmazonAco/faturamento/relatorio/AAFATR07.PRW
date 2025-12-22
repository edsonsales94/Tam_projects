#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATR07   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 08/09/2008 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Este programa irá gerar um arquivo em excel com os estoques   ¦¦¦
¦¦¦  (cont.)  ¦ e pedidos em aberto de cada filial                            ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAFATR07()
  Private oObjDlg 
  Private cPerg    := PADR("FATR07",Len(SX1->X1_GRUPO))
  Private cProduto := "" 
  
  ValidPerg(cPerg)
  Pergunte(cPerg,.F.)
 
  @ 200,1 TO 380,380 DIALOG oObjDlg TITLE "Excel de Estoque x Pedido em aberto"
  @ 02,005 TO 090,190
  @ 10,010 Say "Este programa irá gerar um arquivo em excel com os estoque e os pedidos em aberto"
  @ 18,010 Say "de acordo com os parametros fornecidos pelo usuário."
  @ 65,098 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg)
  @ 65,128 BMPBUTTON TYPE 01 ACTION ESTP01a()
  @ 65,158 BMPBUTTON TYPE 02 ACTION Close(oObjDlg)
  
  Activate Dialog oObjDlg Centered
Return Nil

//************************************************************************************************************************************************

Static Function ESTP01a()
  Local   cArqDiv := AllTrim(Mv_Par03)+AllTrim(Mv_Par04)+".xls"
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


	 aAdd(aLinha,TMP1->B1_COD        )
	 aAdd(aLinha,TMP1->B1_ESPECIF    )

	 aAdd(aLinha,Transform(TMP1->SMATRIZ_06200, "@E 999,999,999.99") )
	 aAdd(aLinha,Transform(TMP1->SMATRIZ_06300, "@E 999,999,999.99") )
	 aAdd(aLinha,Transform(TMP1->SMATRIZ_04208, "@E 999,999,999.99") )
	 aAdd(aLinha,Transform(TMP1->SMATRIZDEP   , "@E 999,999,999.99") )
    
    nwTotal := TMP1->SMATRIZ_06200 + TMP1->SMATRIZ_06300 + TMP1->SMATRIZ_04208 + TMP1->SMATRIZDEP
    
	 aAdd(aLinha,Transform(nwTotal            , "@E 999,999,999.99") )
	 aAdd(aLinha,Transform(TMP1->SSILVES      , "@E 999,999,999.99") )

	 aAdd(aLinha,Transform(TMP1->PMATRIZ_06200, "@E 999,999,999.99") )
	 aAdd(aLinha,Transform(TMP1->PMATRIZ_06300, "@E 999,999,999.99") )
	 aAdd(aLinha,Transform(TMP1->PMATRIZ_04208, "@E 999,999,999.99") )
	 aAdd(aLinha,Transform(TMP1->TPMATRIZ     , "@E 999,999,999.99") )
	 aAdd(aLinha,Transform(TMP1->PSILVES      , "@E 999,999,999.99") )
	                    
	 TMP1->(dbSkip())
	 
	 aAdd(aExport,Array(Len(aLinha)))
	 aExport[Len(aExport)] := aClone(aLinha)
	 aLinha := {}  
	 
  End
  TMP1->(dbCloseArea())
  
  fwCstExp(cArqDiv)
Return Nil

//************************************************************************************************************************************************

Static Function ValidPerg(cPerg)

 PutSX1(cPerg,"01","Produto de 	 ?", "", "", "mv_ch1", "C", 15, 0, 0, "G","","SB1","","","mv_par01")
 PutSX1(cPerg,"02","Produto ate	 ?", "", "", "mv_ch2", "C", 15, 0, 0, "G","","SB1","","","Mv_Par02") 
 PutSX1(cPerg,"03","Diretório  	 ?", "", "", "mv_ch3", "C", 20, 0, 0, "G","","   ","","","mv_par03")
 PutSX1(cPerg,"04","Arquivo    	 ?", "", "", "mv_ch4", "C", 30, 0, 0, "G","","   ","","","Mv_Par04")  

Return Nil                                    

//************************************************************************************************************                            f

Static Function fwCstExp(cArqDiv)
 Local cArqTxt    := cArqDiv
 Local nHdl       := fCreate(cArqTxt)
 Local cLinha     := "" //Chr(9)+"Relatório"+Chr(13)+Chr(10)
 Local oExcelApp                           
 Local aNome := {}

  cLinha += "PRODUTO"  		+ Chr(9) + "DESCRIÇÃO"    + Chr(9) + "SALDO 06.200"  + Chr(9) + "SALDO 06.300" + Chr(9)
  cLinha += "SALDO 04.208" + Chr(9) + "DEP. FECHADO" + Chr(9) + "SALDO MATRIZ"  + Chr(9) + "SALDO SILVES" + Chr(9)
  
  cLinha += "P.V. 06.200"  + Chr(9) + "P.V. 06.300"  + Chr(9) + "P.V. 04.208"   + Chr(9) + "P.V. MATRIZ " + Chr(9)
  cLinha += "P.V. SILVES"  + Chr(13) +Chr(10)
  
                                                         
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
 Local nwAux  := 0                                                                    
                           
 _cQry := "SELECT B1_COD, B1_ESPECIF, "
 _cQry +=        "ISNULL(SMATRIZ_06200,0) SMATRIZ_06200,ISNULL(SMATRIZDEP, 0) SMATRIZDEP, ISNULL(SMATRIZ_06300,0) SMATRIZ_06300, "
 _cQry +=        "ISNULL(SMATRIZ_04208,0) SMATRIZ_04208, "
 _cQry +=        "ISNULL(SMATRIZ_06200,0) + ISNULL(SMATRIZ_06300,0) + ISNULL(SMATRIZ_04208,0) + ISNULL(SMATRIZDEP, 0) TSMATRIZ, "
 _cQry +=        "ISNULL(SSILVES,0) SSILVES, "
 _cQry +=        "ISNULL(PMATRIZ_06200,0) PMATRIZ_06200, ISNULL(PMATRIZ_06300,0) PMATRIZ_06300, "
 _cQry +=        "ISNULL(PMATRIZ_04208,0) PMATRIZ_04208, "
 _cQry +=        "ISNULL(PMATRIZ_06200,0) + ISNULL(PMATRIZ_06300,0) + ISNULL(PMATRIZ_04208,0) TPMATRIZ, "
 _cQry +=        "ISNULL(PSILVES,0) PSILVES  "
 _cQry += "FROM " + RetSqlName("SB1") + " A "
 _cQry += "LEFT OUTER JOIN
 _cQry +=               "( SELECT B2_COD, [00-MATRIZ-06200     ] SMATRIZ_06200, "
 _cQry +=                                "[00-MATRIZDEP        ] SMATRIZDEP, "
 _cQry +=                                "[01-MATRIZ 06300     ] SMATRIZ_06300, "
 _cQry +=                                "[02-MATRIZ 04208     ] SMATRIZ_04208, "
 _cQry +=                                "[03-FILIAL 04        ] SSILVES "
 _cQry +=                    "FROM ( "
 _cQry +=                            "SELECT B2_COD, CASE "
 _cQry +=                                               "WHEN B2_LOCAL = '13' THEN '00-MATRIZDEP        ' "
 _cQry +=                                                                    "ELSE LJ_NOME "
 _cQry +=                                           "END LJ_NOME, B2_QATU "
 _cQry +=                               "FROM " + RetSqlName("SB2") + " A "
 _cQry +=                            "LEFT OUTER JOIN " + RetSqlName("SLJ") + " B "
 _cQry +=                               "ON B2_FILIAL=LJ_RPCFIL AND B.D_E_L_E_T_='' "
 _cQry +=                            "WHERE A.D_E_L_E_T_ = '' " //B2_LOCAL IN ('01','13') "B2_LOCAL IN ('01','13') "
 _cQry +=                          ") A "
 _cQry +=                 "PIVOT ( SUM ( B2_QATU ) FOR LJ_NOME IN ([00-MATRIZ-06200     ], "
 _cQry +=                                                      "[00-MATRIZDEP        ], [01-MATRIZ 06300     ], "
 _cQry +=                                                      "[02-MATRIZ 04208     ], [03-FILIAL 04        ]) ) PVT1 ) C "
 _cQry +=    "ON B1_COD=B2_COD "
 _cQry += "LEFT OUTER JOIN "
 _cQry +=               "( SELECT C6_PRODUTO, C6_LOCAL, [00-MATRIZ-06200     ] PMATRIZ_06200, "
 _cQry +=                                              "[01-MATRIZ 06300     ] PMATRIZ_06300, "
 _cQry +=                                              "[02-MATRIZ 04208     ] PMATRIZ_04208, "
 _cQry +=                                              "[03-FILIAL 04        ] PSILVES "
 _cQry +=                    "FROM ( "
 _cQry +=                            "SELECT C6_PRODUTO, LJ_NOME, C6_LOCAL, (C6_QTDVEN-C6_QTDENT) SALDO "
 _cQry +=                               "FROM " + RetSqlName("SC6") + " A "
 _cQry +=                  "LEFT OUTER JOIN " + RetSqlName("SLJ") + " B "
 _cQry +=                    "ON C6_FILIAL=LJ_RPCFIL AND B.D_E_L_E_T_='' "
 _cQry +=                ") A "
 _cQry +=                "PIVOT ( SUM ( SALDO ) FOR LJ_NOME IN ([00-MATRIZ-06200     ],[01-MATRIZ 06300     ], "
 _cQry +=                                                   "[02-MATRIZ 04208     ],[03-FILIAL 04        ]) ) PVT2 ) D "
 _cQry +=    "ON B1_COD=C6_PRODUTO "

 _cQry += "WHERE A.D_E_L_E_T_='' AND B1_COD BETWEEN '"+ mv_par01 +"' AND '"+ mv_par02 +"' "

 _cQry += "ORDER BY B1_ESPECIF "
                                                                                                         
  dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQry), "TMP1", .T., .T. )
//  dbUseArea( .T., "TOPCONN", tcGenQry(,,_cQry), "TRB" , .T., .T. )

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