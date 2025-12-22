#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATR10   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 11/02/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Este programa irá gerar um arquivo em excel com OS ROMANEIOS  ¦¦¦
¦¦¦  (cont.)  ¦ fechados por motoristas.                                      ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAFATR10()
  Private oObjDlg 
  Private cPerg    := PADR("FATR10",Len(SX1->X1_GRUPO))
  Private cProduto := "" 
  
  ValidPerg(cPerg)
  Pergunte(cPerg,.F.)
 
  @ 200,1 TO 380,380 DIALOG oObjDlg TITLE "Romaneios fechados por motoristas"
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
	 aAdd(aLinha,TMP1->ZE_NOMOTOR    )

	 aAdd(aLinha,Transform(TMP1->CONT_ROMAN, "@E 999,999,999.99") )
	 aAdd(aLinha,Transform(TMP1->CONT_NOTAS, "@E 999,999,999.99") )
	 aAdd(aLinha,Transform(TMP1->CONT_CLI  , "@E 999,999,999.99") )
    
	                    
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

 PutSX1(cPerg,"01","Data de   	 ?", "", "", "mv_ch1", "D", 08, 0, 0, "G","","   ","","","mv_par01")
 PutSX1(cPerg,"02","Data ate   	 ?", "", "", "mv_ch2", "D", 08, 0, 0, "G","","   ","","","Mv_Par02") 
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

  cLinha += "MOTORISTA"  + Chr(9) + "RAMANEIOS"    + Chr(9) + "NOTAS"  + Chr(9) + "CLIENTES" + Chr(13) +Chr(10)
                                                         
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
                           
	_cQry := "SELECT C.ZE_NOMOTOR, C.CONT_ROMAN, D.CONT_NOTAS, E.CONT_CLI
	_cQry += "  FROM ( SELECT ZE_NOMOTOR, COUNT (*) AS CONT_ROMAN 
	_cQry += "           FROM ( SELECT ZE_NOMOTOR, ZE_ROMAN
	_cQry += "                    FROM " + RetSqlName("SZE") + " A "
	_cQry += "                   WHERE A.D_E_L_E_T_ = ''
	_cQry += "                           AND ZE_NOMOTOR NOT LIKE '%CLIENTE RETIRA%'                         
	_cQry += "                           AND ZE_STATUS IN ('R', 'E')
	_cQry += "                           AND ZE_DTSAIDA BETWEEN '"+ dtos(mv_par01) +"' AND '"+ dtos(mv_par02) +"' "
	_cQry += "                   GROUP BY ZE_NOMOTOR, ZE_ROMAN 
	_cQry += "                ) B
	_cQry += "          GROUP BY ZE_NOMOTOR
	_cQry += "        ) C 
	_cQry += "   INNER JOIN  
	_cQry += "       ( SELECT ZE_NOMOTOR, COUNT (*) AS CONT_NOTAS
	_cQry += "           FROM ( SELECT ZE_NOMOTOR, ZE_DOC
	_cQry += "                    FROM " + RetSqlName("SZE") + " A " 
	_cQry += "                   WHERE A.D_E_L_E_T_ = ''
	_cQry += "                           AND ZE_NOMOTOR NOT LIKE '%CLIENTE RETIRA%'                         
	_cQry += "                           AND ZE_STATUS IN ('R', 'E')
	_cQry += "                           AND ZE_DTSAIDA BETWEEN '"+ dtos(mv_par01) +"' AND '"+ dtos(mv_par02) +"' "
	_cQry += "                   GROUP BY ZE_NOMOTOR, ZE_DOC 
	_cQry += "                ) B                
	_cQry += "          GROUP BY ZE_NOMOTOR
	_cQry += "        ) D
	_cQry += "       ON C.ZE_NOMOTOR = D.ZE_NOMOTOR 
	_cQry += "   INNER JOIN  
	_cQry += "       ( SELECT ZE_NOMOTOR, COUNT (*) AS CONT_CLI
	_cQry += "           FROM ( SELECT ZE_NOMOTOR, ZE_CLIENTE
	_cQry += "                    FROM " + RetSqlName("SZE") + " A "
	_cQry += "                   WHERE A.D_E_L_E_T_ = ''
	_cQry += "                           AND ZE_NOMOTOR NOT LIKE '%CLIENTE RETIRA%'
	_cQry += "                           AND ZE_STATUS IN ('R', 'E')
	_cQry += "                           AND ZE_DTSAIDA BETWEEN '"+ dtos(mv_par01) +"' AND '"+ dtos(mv_par02) +"' "
	_cQry += "                   GROUP BY ZE_NOMOTOR, ZE_CLIENTE 
	_cQry += "                ) B                
	_cQry += "          GROUP BY ZE_NOMOTOR
	_cQry += "        ) E
	_cQry += "       ON C.ZE_NOMOTOR = E.ZE_NOMOTOR 
	_cQry += " ORDER BY C.ZE_NOMOTOR
	                                                                                                         
  dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQry), "TMP1", .T., .T. )

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