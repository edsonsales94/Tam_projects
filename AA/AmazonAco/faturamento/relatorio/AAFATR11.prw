#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATR11   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 11/02/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Este programa irá gerar um arquivo em excel com AS contas a   ¦¦¦
¦¦¦  (cont.)  ¦ receber por cliente                                           ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAFATR11()
  Private oObjDlg 
  Private cPerg    := PADR("FATR11",Len(SX1->X1_GRUPO))
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

	 aAdd(aLinha,TMP1->A1_COD   )
	 aAdd(aLinha,TMP1->E4_COND  )
	 aAdd(aLinha,TMP1->A1_NOME  )
	 aAdd(aLinha,Transform(TMP1->A1_CGC,"@R 99.999.999/9999-99") )

	 aAdd(aLinha,TMP1->A1_VEND  )
	 aAdd(aLinha,TMP1->A1_RISCO )

	 aAdd(aLinha,Transform(TMP1->A1_LC     , "@E 999,999,999.99") )
	 aAdd(aLinha,Transform(TMP1->ATRASADO  , "@E 999,999,999.99") )
	 aAdd(aLinha,Transform(TMP1->VENCER    , "@E 999,999,999.99") )
	 aAdd(aLinha,Transform(TMP1->TOT_ABERTO, "@E 999,999,999.99") )
    aAdd(aLinha,Transform(TMP1->PAGO      , "@E 999,999,999.99") )
    
    aAdd(aLinha,DTOC(TMP1->A1_ULTCOM) ) 
    aAdd(aLinha,Transform(TMP1->ULT_COMPRA, "@E 999,999,999.99") )
	aAdd(aLinha,TMP1->A1_EST )
	aAdd(aLinha, dtoc(STOD(TMP1->A1_DTINIV )) )
	aAdd(aLinha, dtoc(STOD(TMP1->PROXPAG)) 	 )

	 TMP1->(dbSkip())
	 
	 aAdd(aExport,Array(Len(aLinha)))
	 aExport[Len(aExport)] := aClone(aLinha)
	 aLinha := {}  
	 
  End
  TMP1->(dbCloseArea())
  
  fwCstExp(cArqDiv)
Return Nil

Static Function  _getNPAg(_xdCod,_xdLoja)
    
    _xQry  := " Select TOP 1 isNull( E1_VENCTO,'') E1_VENCTO from " + RetSqlName('SE1') + " E1 "
    _xQry  += "  Where  E1.D_E_L_E_T_ = ''
    _xQry  += "   And E1_SALDO > 0
    _xQry  += "   order By E1_VENCTO
    
    _xTbl := getNextAlias()
    
    dbUseArea(.t.,"TOPCONN",tcGenQry(,,_xQry),_xTbl,.F.,.F.)
    
    _dtPag := STOD( (_xTbl)->E1_VENCTO )
    
    (_xTbl)->(dbCloseArea(_xTbl))
    
    
Return _dtPag

//************************************************************************************************************************************************

Static Function ValidPerg(cPerg)

 PutSX1(cPerg,"01","Data de    	 ?", "", "", "mv_ch1", "D", 08, 0, 0, "G","","   ","","","mv_par01")
 PutSX1(cPerg,"02","Data Ate   	 ?", "", "", "mv_ch2", "D", 08, 0, 0, "G","","   ","","","Mv_Par02") 
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
                                                            
  cLinha += "Cód Cliente"   + Chr(9) + "Condição"          + Chr(9) + "Razão Social" + Chr(9) + "CNPJ/CPF"      + Chr(9)
  cLinha += "Vendedor"      + Chr(9) + "Risco"         + Chr(9) + "Lim. Credito" + Chr(9) + "ATRASADO"      + Chr(9)  
  cLinha += "A VENCER"      + Chr(9) + "Total Aberto"  + Chr(9) + "Total Pago"   + Chr(9) + "Dt Ult Compra" + Chr(9)  
  cLinha += "Vl Ult Compra"  + Chr(9) + "UF"+Chr(9) + "DTINIV"+Chr(9) + "Proximo Pagamento"+Chr(13)+Chr(10)  
                                                         
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
                           

_cQry := "SELECT A1_DTINIV,A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_EST, A1_VEND, E4_COND, A1_RISCO, A1_LC, SUM(ISNULL(CREC.ATRASADO,0)) AS ATRASADO, 
_cQry += "       SUM(ISNULL(CREC.VENCER,0)) AS VENCER, SUM(ISNULL(CREC.E1_SALDO,0)) AS TOT_ABERTO, SUM(ISNULL(CREC.E1_VALOR,0) - ISNULL(CREC.E1_SALDO,0) ) AS PAGO, A1_ULTCOM, ISNULL(DIAS,0) DIAS,
_cQry += "       ( SELECT B.E1_VALOR 
_cQry += "           FROM " + RetSqlName("SE1") + " B (NOLOCK)
_cQry += "          WHERE D_E_L_E_T_ = '' 
_cQry += "            AND B.R_E_C_N_O_ = ( SELECT MAX(R_E_C_N_O_) 
_cQry += "                                   FROM " + RetSqlName("SE1") + " A (NOLOCK)         
_cQry += "                                  WHERE A.D_E_L_E_T_ = ''
_cQry += "                                    AND A.E1_CLIENTE = SA1.A1_COD AND A.E1_LOJA    = SA1.A1_LOJA
_cQry += "                               ) 
_cQry += "       ) ULT_COMPRA,

_cQry += " ( SELECT ISNULL(MIN(E1_VENCTO),'') FROM " + RetSqlName("SE1") 
_cQry += " WHERE E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND E1_SALDO > 0 AND D_E_L_E_T_ = ''
_cQry += " AND E1_VENCTO >= '" + dtos(dDataBase) + "')PROXPAG "

  
_cQry += "  FROM " + RetSqlName("SA1") + " SA1 (NOLOCK) "

_cQry += "  LEFT JOIN ( SELECT E1_CLIENTE, E1_LOJA, E1_SALDO, E1_VALOR,  
_cQry += "                		 CASE WHEN E1_SALDO > 0 AND E1_VENCORI <  '" + dtos(ddatabase) + "' THEN E1_SALDO ELSE 0 END AS ATRASADO, "
_cQry += "                		 CASE WHEN E1_SALDO > 0 AND E1_VENCORI >= '" + dtos(ddatabase) + "' THEN E1_SALDO ELSE 0 END AS VENCER "
       
_cQry += "           	  FROM " + RetSqlName("SE1") + " SE1 (NOLOCK) "

_cQry += "          		 WHERE SE1.D_E_L_E_T_ = ''                  
_cQry += "                 AND E1_EMISSAO BETWEEN '"+ dtos(mv_par01) +"' AND '"+ dtos(mv_par02) +"' "
_cQry += "            ) CREC

_cQry += "    ON A1_COD = CREC.E1_CLIENTE AND A1_LOJA = CREC.E1_LOJA

_cQry += "   LEFT JOIN (  "
_cQry += "			SELECT E1_LOJA, E1_CLIENTE, SUM(DIAS2)/ COUNT(*) DIAS FROM ("
_cQry += "				SELECT SUM(DIAS)/COUNT(*) DIAS2, E1_NUM, E1_PREFIXO, E1_LOJA, E1_CLIENTE FROM ( "
_cQry += "					SELECT DATEDIFF(DAY,E1_EMISSAO,E1_VENCTO) DIAS , E1_NUM, E1_PREFIXO, E1_CLIENTE, E1_LOJA" 
_cQry += "       				FROM  " + RetSqlName("SE1") + "  SE1 (NOLOCK) "
_cQry += "						WHERE SE1.D_E_L_E_T_ = '' "                 
_cQry += "						AND E1_EMISSAO BETWEEN '"+ dtos(mv_par01) +"' AND '"+ dtos(mv_par02) +"' "
_cQry += "      		    ) X "
_cQry += "    	        GROUP BY E1_NUM, E1_PREFIXO, E1_LOJA, E1_CLIENTE "
_cQry += "            ) Y "
_cQry += "            GROUP BY E1_LOJA, E1_CLIENTE "
_cQry += "	) Z "
_cQry += "    ON Z.E1_CLIENTE = CREC.E1_CLIENTE AND Z.E1_LOJA = CREC.E1_LOJA

_cQry += "  INNER JOIN 
_cQry += "  (Select E4_CODIGO, E4_COND
_cQry += "  	From " + RetSqlName("SE4") + " SE4 (NOLOCK) "
_cQry += "  	Where D_E_L_E_T_ = ''
_cQry += "  ) E4
_cQry += "  ON A1_COND = E4_CODIGO

_cQry += "    WHERE SA1.D_E_L_E_T_ = '' 

_cQry += " GROUP BY A1_DTINIV,A1_COD, A1_LOJA, A1_NOME, A1_EST, A1_CGC, A1_VEND, A1_RISCO, A1_LC, A1_ULTCOM, E4_COND,DIAS

                                                                                                         
  dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQry), "TMP1", .T., .T. )
//  dbUseArea( .T., "TOPCONN", tcGenQry(,,_cQry), "TRB" , .T., .T. )
    
TCSetField("TMP1","A1_ULTCOM" ,"D",8,0)


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