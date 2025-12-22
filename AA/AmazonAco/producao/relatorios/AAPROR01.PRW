#INCLUDE "topconn.ch"
/*
 .---------------------------------------------------------------------------------------------------------------------.
|     Programa     |     AAPROR01      |     Autor     |     Wagner da Gama Corrêa     |     Data     |     08/02/11    |
|-----------------------------------------------------------------------------------------------------------------------|
|     Descricao    |     Programação de Produção                                                                        |
 '---------------------------------------------------------------------------------------------------------------------'
*/
User Function AAPROR01()

Local cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 := "de acordo com os parametros informados pelo usuario."
Local cDesc3 := ""
Local cPict  := ""
Local titulo := "Sugestao de Programacao"
Local _nLin  := 80

Local Cabec1  := "                                  P R O D U T O                                              |                          S A L D O S                          |   T O T A L   |    T O T A L  | C O N S U M O |   SUGESTAO   "
Local Cabec2  := "  Codigo  | Descricao                                                                        |     06.200    |     06.300    |     04.208    | Puraquequara  |   S A L D O   |   P E D I D O |   M E D I O   |   PRODUCAO   "
//                 12345678   12345678901234567890123456789012345678901234567890123456789012345678901234567890   9999.999,9999   9999.999,9999   9999.999,9999   9999.999,9999   9999.999,9999   9999.999,9999   9999.999,9999  9999.999,9999
//                0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111122222222222222222222
//                0000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111
//                0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789

Local imprime := .T.
Local aOrd    := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "AAPROR01"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "AAPROR01"
Private cPerg       := "AAPROR01"

Private cString := "SB1"

ValidPerg(cPerg)
Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,_nLin) },Titulo)
Return

/*/
//  .----------------------------------------------------------.
// |     RunReport     |     Processa e imprime o relatório     |
//  '----------------------------------------------------------'
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,_nLin)
 Local   aLinha  := {}   
 Private aExport := {}

_cArea := GetArea()


//  .------------------------------------------------------------------------.
// |    Busca dados das filiais para compor o saldo disponivel para venda     |
//  '------------------------------------------------------------------------'

_cQry := "SELECT B1_YFERRAM, ZH_DESC, B1_COD, B1_ESPECIF, "
_cQry +=        "ISNULL(SMAT_06200,0) SMAT_06200, ISNULL(SMATDEP, 0) SMATDEP, "
_cQry +=        "ISNULL(SMAT_06300,0) SMAT_06300, ISNULL(SMAT_04208,0) SMAT_04208, "
_cQry +=        "ISNULL(SMAT_06200,0) + ISNULL(SMAT_06300,0) + ISNULL(SMAT_04208,0) + ISNULL(SMATDEP, 0) TSMATRIZ, "
_cQry +=        "ISNULL(SSILVES,0) SSILVES, "
_cQry +=        "ISNULL(PMAT_06200,0) PMAT_06200, ISNULL(PMAT_06300,0) PMAT_06300, "
_cQry +=        "ISNULL(PMAT_04208,0) PMAT_04208, "
_cQry +=        "ISNULL(PMAT_06200,0) + ISNULL(PMAT_06300,0) + ISNULL(PMAT_04208,0) TPMATRIZ, "
_cQry +=        "ISNULL(PSILVES,0) PSILVES, "
_cQry +=        "ISNULL(CONSUMO,0) CONSUMO "
_cQry += "FROM " + RetSqlName("SB1") + " A "
_cQry += "LEFT OUTER JOIN " + RetSqlName("SZH") + " B ON ZH_COD=B1_YFERRAM AND B.D_E_L_E_T_=' ' "
_cQry += "LEFT OUTER JOIN
_cQry +=               "( SELECT B2_COD, [00-MATRIZ-06200     ] SMAT_06200, "
_cQry +=                                "[00-MATRIZDEP        ] SMATDEP, "
_cQry +=                                "[01-MATRIZ 06300     ] SMAT_06300, "
_cQry +=                                "[02-MATRIZ 04208     ] SMAT_04208, "
_cQry +=                                "[03-FILIAL 04        ] SSILVES "
_cQry +=                    "FROM ( "
_cQry +=                            "SELECT B2_COD, CASE "
_cQry +=                                               "WHEN B2_LOCAL = '14' THEN '00-MATRIZDEP        ' "
_cQry +=                                                                    "ELSE LJ_NOME "
_cQry +=                                           "END LJ_NOME, B2_QATU "
_cQry +=                               "FROM " + RetSqlName("SB2") + " A "
_cQry +=                            "LEFT OUTER JOIN " + RetSqlName("SLJ") + " B "
_cQry +=                               "ON B2_FILIAL=LJ_RPCFIL AND B.D_E_L_E_T_='' "
_cQry +=                            "WHERE B2_LOCAL IN ('01','14') "
_cQry +=                          ") A "
_cQry +=                 "PIVOT ( SUM(B2_QATU) FOR LJ_NOME IN ([00-MATRIZ-06200     ], "
_cQry +=                                                      "[00-MATRIZDEP        ], [01-MATRIZ 06300     ], "
_cQry +=                                                      "[02-MATRIZ 04208     ], [03-FILIAL 04        ]) ) PVT1 ) C "
_cQry +=    "ON B1_COD=B2_COD "
_cQry += "LEFT OUTER JOIN "
_cQry +=               "( SELECT C6_PRODUTO, [00-MATRIZ-06200     ] PMAT_06200, "
_cQry +=                                    "[01-MATRIZ 06300     ] PMAT_06300, "
_cQry +=                                    "[02-MATRIZ 04208     ] PMAT_04208, "
_cQry +=                                    "[03-FILIAL 04        ] PSILVES "
_cQry +=                    "FROM ( "
_cQry +=                            "SELECT C6_PRODUTO, LJ_NOME, (C6_QTDVEN-C6_QTDENT) SALDO "
_cQry +=                              "FROM " + RetSqlName("SC6") + " A "
_cQry +=                              "LEFT OUTER JOIN " + RetSqlName("SLJ") + " B "
_cQry +=                    "ON C6_FILIAL=LJ_RPCFIL AND B.D_E_L_E_T_='' "     
_cQry +=                             "WHERE A.D_E_L_E_T_=''  AND C6_QTDENT < C6_QTDVEN AND C6_BLQ <> 'R' "
_cQry +=                ") A "
_cQry +=                "PIVOT ( SUM(SALDO) FOR LJ_NOME IN ([00-MATRIZ-06200     ],[01-MATRIZ 06300     ], "
_cQry +=                                                   "[02-MATRIZ 04208     ],[03-FILIAL 04        ]) ) PVT2 ) D "
_cQry +=    "ON B1_COD=C6_PRODUTO "
_cQry += "LEFT OUTER JOIN "
_cQry +=               "( SELECT D2_COD, SUM(D2_QUANT) CONSUMO "
_cQry +=                    "FROM " + RetSqlName("SD2") + " A "
_cQry +=                 "LEFT OUTER JOIN " + RetSqlName("SF4") + " B "
_cQry +=                    "ON F4_TESDV=D2_TES AND B.D_E_L_E_T_=' ' AND F4_TRANFIL <> '1' "
_cQry +=                 "WHERE A.D_E_L_E_T_=' ' AND D2_EMISSAO BETWEEN '" + DtoS(dDataBase - 1) + "' AND '" + DtoS(dDataBase - 180)+ "' "
_cQry +=                 "GROUP BY D2_COD "
_cQry +=              ") E "
_cQry +=    "ON B1_COD=D2_COD "
_cQry += "WHERE A.D_E_L_E_T_='' AND NOT B1_YFERRAM='' AND ZH_DESC IS NOT NULL "
_cQry +=       "AND B1_YFERRAM BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
_cQry += "ORDER BY B1_YFERRAM, B1_ESPECIF "

dbUseArea(.T., "TOPCONN", tcGenQry(,,_cQry), "TRB", .T., .T.)

dbSelectArea("TRB")
SetRegua(RecCount())

dbGoTop()
	
_aGerais := {0, 0, 0}

While !Eof()
	
	If lAbortPrint
		@ _nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	_cFerramenta := B1_YFERRAM
	
	_aTotais := {0, 0, 0}
	
	_lPrimeiro   := .T.
	
	While !Eof() .and. B1_YFERRAM = _cFerramenta
		
		If _nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			_nLin := 8
		Endif

		If _lPrimeiro
			_nLin++
			@ _nLin, 001 PSAY ZH_DESC
			_nLin += 2
			_lPrimeiro := .F.
		EndIf
		
		@ _nLin, 001 PSAY B1_COD
		@ _nLin, 012 PSAY Left(B1_ESPECIF, 80)
		@ _nLin, 095 PSAY Transform( Round( SMAT_06200/1000, 3),   "@E 9999,999.999")
		@ _nLin, 111 PSAY Transform( Round( SMAT_06300/1000, 3),   "@E 9999,999.999")
		@ _nLin, 127 PSAY Transform( Round( SMAT_04208/1000, 3),   "@E 9999,999.999")
		@ _nLin, 143 PSAY Transform( Round( SMATDEP/1000, 3),      "@E 9999,999.999")
		@ _nLin, 159 PSAY Transform( Round( TSMATRIZ/1000, 3),        "@E 9999,999.999")
		@ _nLin, 175 PSAY Transform( Round( TPMATRIZ/1000, 3),        "@E 9999,999.999")
		@ _nLin, 191 PSAY Transform( Round( ((CONSUMO / 6)/1000), 3), "@E 9999,999.999")
		If mv_par03 = 1
			_nSugestao := (TPMATRIZ - TSMATRIZ + (CONSUMO/6))/1000
		Else
			_nSugestao := (TPMATRIZ - TSMATRIZ)/1000
		EndIf
		
		_aTotais[1] += Round( TSMATRIZ/1000, 3)
		_aTotais[2] += Round( TPMATRIZ/1000, 3)
		_aTotais[3] += Round( ((CONSUMO / 6)/1000), 3)
		
		_nSugestao := Round(IIF( _nSugestao < 0, 0, _nSugestao), 3)
		
		@ _nLin, 206 PSAY Transform( _nSugestao, "@E 9999,999.999")
		
		_nLin++     
		                 
		If mv_par04 == 1
			aAdd(aLinha,ZH_DESC)
			aAdd(aLinha,B1_COD)
			aAdd(aLinha,Left(B1_ESPECIF, 80))
			aAdd(aLinha,Transform( Round( SMAT_06200/1000, 3),      "@E 9,999,999.999"))
			aAdd(aLinha,Transform( Round( SMAT_06300/1000, 3),      "@E 9,999,999.999"))
			aAdd(aLinha,Transform( Round( SMAT_04208/1000, 3),      "@E 9,999,999.999"))
			aAdd(aLinha,Transform( Round( SMATDEP   /1000, 3),      "@E 9,999,999.999"))
			aAdd(aLinha,Transform( Round( TSMATRIZ  /1000, 3),      "@E 9,999,999.999"))
			aAdd(aLinha,Transform( Round( TPMATRIZ  /1000, 3),      "@E 9,999,999.999"))
			aAdd(aLinha,Transform( Round( ((CONSUMO / 6)/1000), 3), "@E 9,999,999.999"))				
			aAdd(aLinha,Transform( _nSugestao, "@E 9999,999.999"))
			aAdd(aExport,Array(Len(aLinha)))
		 	aExport[Len(aExport)] := aClone(aLinha)
		 	aLinha := {}  
		EndIf	  	
		
		dbSkip()
		
	End
	
	If _aTotais[1] > 0 .or. _aTotais[2] > 0 .or. _aTotais[3] > 0
		_nLin += 2
		@ _nLin, 012 PSAY "TOTAL FERRAMENTA"

		@ _nLin, 159 PSAY Transform( Round( _aTotais[1], 3), "@E 9999,999.999")
		@ _nLin, 175 PSAY Transform( Round( _aTotais[2], 3), "@E 9999,999.999")
		@ _nLin, 191 PSAY Transform( Round( _aTotais[3], 3), "@E 9999,999.999")
		
		_aGerais[1] += _aTotais[1]
		_aGerais[2] += _aTotais[2]
		_aGerais[3] += _aTotais[3]
		
		_nLin += 2
	EndIf
End


	If _aGerais[1] > 0 .or. _aGerais[2] > 0 .or. _aGerais[3] > 0
		_nLin += 2
		@ _nLin, 012 PSAY "TOTAL GERAL"

		@ _nLin, 159 PSAY Transform( Round( _aGerais[1], 3), "@E 9999,999.999")
		@ _nLin, 175 PSAY Transform( Round( _aGerais[2], 3), "@E 9999,999.999")
		@ _nLin, 191 PSAY Transform( Round( _aGerais[3], 3), "@E 9999,999.999")
				
		_nLin += 2
	EndIf

dbCloseArea()   

If mv_par04 == 1
	Exporta()
EndIf 

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

RestArea(_cArea)
Return
//
//
//
Static Function ValidPerg(cPerg)

PutSX1( cPerg, "01", "Da Ferramenta?",  "", "", "mv_ch1", "C", 03, 0, 0, "G","","ZHFERR","","","mv_par01")
PutSX1( cPerg, "02", "Ate Ferramenta?", "", "", "mv_ch2", "C", 03, 0, 0, "G","","ZHFERR","","","mv_par02")
PutSX1( cPerg, "03", "Consumo?",        "", "", "mv_ch3", "N", 01, 0, 0, "C","","      ","","","mv_par03","Considera","","","","Desconsidera", "","", "")                          
PutSX1( cPerg, "04", "Exporta Excel ?" ,"", "", "mv_ch4", "N", 01, 0, 0, "C","","      ","","","mv_par04","Sim","","","","Não", "","", "") 
Return Nil                                    

//*****************************************************
//  .----------------------------------------------.  *
// |     Rotina de geração do arquivo em Excel      | *
//  '----------------------------------------------'  *
//*****************************************************
Static Function Exporta()
   Local cArqTxt    := GetTempPath() + "AAPR0R01.xls"
   Local nHdl       :=  Nil 
   Local cLinha     := "" //Chr(9)+"Relatório"+Chr(13)+Chr(10)   
   
   If File(cArqTxt)
	  FErase(cArqTxt)
   Endif
   
   nHdl := fCreate(cArqTxt)                         
   
   If !File(cArqTXT)
      MsgStop("O Arquivo " + cArqTXT + " não pode ser Criado!")
	  Return nil  
	EndIf	

 	cLinha += "FERRAMENTA"    		+ Chr(9) + "PRODUTO" 	   + Chr(9) + "ESPECIFICAÇÃO" +Chr(9)
   cLinha += "SALDO 06.200"  		+ Chr(9) + "SALDO 06.300"  + Chr(9) + "SALDO 04.208"  +Chr(9) 
   cLinha += "SALDO PURAQUEQUARA"  + Chr(9) + "TOTAL SALDO"   + Chr(9) + "TOTAL PEDIDO"  +Chr(9) 
   cLinha += "CONSUMO MÉDIO" 		+ Chr(9) + "SUGESTAO PRODUCAO" +chr(13)+chr(10) 
   
    If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
    EndIf            
   
    For i:=1 to Len(aExport)
       cLinha := ""
         IncRegua()

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
  RunExcel(cArqTxt)  
Return Nil                                                                                  

//*******************************************************************
//  .------------------------------------------------------------.  *
// |     Rotina de chamada do Excel para abertura do arquivo      | *
//  '------------------------------------------------------------'  *
//*******************************************************************
Static Function RunExcel(cwArq)
  Local oExcelApp                           
  Local aNome := {}

  If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
    MsgStop( 'MsExcel nao instalado' ) 
    Return
  EndIf
    
  oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
  oExcelApp:WorkBooks:Open(cwArq) 
  oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.  
  //oExcelApp:Destroy()
Return                                    

/*----------------------------------------------------------------------------------||
||       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||      AAAA       LL         LL         EE         CC        KK    KK   SS         ||
||     AA  AA      LL         LL         EE        CC         KK  KK     SS         ||
||    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   ||
||   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  ||
||  AA        AA   LL         LL         EE         CC        KK    KK          SS  ||
|| AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||----------------------------------------------------------------------------------*/