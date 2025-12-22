#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ AAFINP03   ¦ Autor ¦ werneson gadelha     ¦ Data ¦ 22/03/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descrição ¦ Relatório de Faturamento x Liquidez                           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAFINP03()
	Local aSay    := {}
	Local aButton := {}
	Local nOpc    := 0
	Local cTitulo := "Relatório de Faturamento x Liquidez"
	Local cDesc1  := "Essa rotina irá os valores referente as vendas por representante"
	Local cDesc2  := "e vendedores da Industria e Comércio."
	Local cPerg   := PADR("ACPFINPR03",Len(SX1->X1_GRUPO))
	
	If !ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
		//MsgStop( 'MsExcel nao instalado' )
		MsgStop( 'Arquivo Será Gerado no Diretorio Informado e deverá ser aberto manualmente' )
		Return
	EndIf
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	
	aAdd( aButton, { 5, .T., {|x| Pergunte(cPerg)       }} )
	aAdd( aButton, { 1, .T., {|x| nOpc := 1, oDlg:End() }} )
	aAdd( aButton, { 2, .T., {|x| nOpc := 2, oDlg:End() }} )
	
	FormBatch( cTitulo, aSay, aButton )
	
	If nOpc == 1
		Processa({|| RunProc() }, "Gerando dados")
	Endif
	
Return

Static Function RunProc()
	Local cQry, nX
	Local aQry    := {}
	Local aLinha  := {}
	Local aExport := {}
	
	MainQuery()	
		
	While !WWW->(Eof())
			
		aLinha := {}                                        			

		aAdd(aLinha, WWW->E1_VEND1) 	
		aAdd(aLinha, WWW->A3_NOME )
		aAdd(aLinha, WWW->TIPO	  ) 
		aAdd(aLinha, Transform(WWW->FATURAMENTO  , "@E 999,999,999.99") )
		aAdd(aLinha, Transform(WWW->LIQUIDEZ     , "@E 999,999,999.99") )
		aAdd(aLinha, Transform(WWW->EM_ABERTO    , "@E 999,999,999.99") )
		aAdd(aLinha, Transform(WWW->INADIMPLENCIA, "@E 999,999,999.99") )
									
		aAdd(aExport,Array(Len(aLinha)))
		aExport[Len(aExport)] := aClone(aLinha)
		
		WWW->(dbSkip())
	Enddo
	
	WWW->(dbCloseArea())	
	ExportaExcel(aExport)
Return

Static Function MainQuery()
	Local cQry := ""
	 	 
	cQry += " SELECT E1_VEND1, A3_NOME," 
	cQry +=  	   " CASE WHEN SA3.A3_TIPO = 'E' THEN 'REPRESENTANTES'"
	cQry +=  		     " WHEN SA3.A3_TIPO = 'I' THEN 'COMERCIO'"
	cQry +=  			  " WHEN SA3.A3_TIPO = ' ' THEN 'INDUSTRIA'"
	cQry +=  	   " END AS TIPO,"
	cQry +=        " ROUND(SUM(VALORE1     ),2) AS FATURAMENTO,"
	cQry +=        " ROUND(SUM(VALORE5     ),2) AS LIQUIDEZ," 
	cQry +=        " ROUND(SUM(VALOR_ABERTO),2) AS EM_ABERTO,"       
	cQry +=        " ROUND(SUM(VALOR_VENC  ),2) AS INADIMPLENCIA" 
       
	cQry +=   " FROM ( SELECT E1_VEND1, SUM(E1_VALOR) AS VALORE1, 0 AS VALORE5, 0 AS VALOR_VENC, 0 AS VALOR_ABERTO"
	cQry +=  		    " FROM "+RetSQLName("SE1")+"  AS SE1 (NOLOCK)"
	cQry +=           " WHERE SE1.D_E_L_E_T_ = ''"
	cQry +=             " AND SE1.E1_EMIS1   BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'"
	cQry +=             " AND SE1.E1_TIPO NOT IN ('NCC', 'RA')"
	cQry +=  			  " AND LEFT(SE1.E1_ORIGEM, 4) <> 'FINA'"
	cQry += 		      " GROUP BY E1_VEND1"
         
	cQry +=           " UNION"
		 
	cQry +=  		  " SELECT E1_VEND1, 0 AS VALORE1, 0 AS VALORE5, 0 AS VALOR_VENC, SUM(E1_SALDO) AS VALOR_ABERTO"
	cQry +=  		    " FROM "+RetSQLName("SE1")+"  AS SE1 (NOLOCK)"
	cQry +=           " WHERE SE1.D_E_L_E_T_ = ''"
//	cQry +=             " AND SE1.E1_VENCREA BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"'"
  	cQry +=             " AND SE1.E1_VENCREA >= " +dTos(dDataBase) //BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"'"	
	cQry +=             " AND SE1.E1_TIPO NOT IN ('NCC', 'RA')" 
//	cQry +=  			  " AND LEFT(SE1.E1_ORIGEM, 4) <> 'FINA'"
	cQry +=  		   " GROUP BY E1_VEND1"
		 		  
	cQry +=  		   " UNION"
		
	cQry +=  	 	  " SELECT E1_VEND1, 0 AS VALORE1, 0 AS VALORE5, SUM(E1_SALDO) AS VALOR_VENC, 0 AS VALOR_ABERTO"
	cQry +=  		    " FROM "+RetSQLName("SE1")+"  AS SE1 (NOLOCK)"
	cQry +=           " WHERE SE1.D_E_L_E_T_ = ''" 
	cQry +=             " AND SE1.E1_VENCREA < " +dTos(dDataBase) //BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"'"	
	cQry +=             " AND SE1.E1_TIPO NOT IN ('NCC', 'RA')"
//	cQry +=  		     " AND LEFT(SE1.E1_ORIGEM, 4) <> 'FINA'" 
	cQry +=  		     " AND SE1.E1_SALDO > 0"
	cQry +=  		   " GROUP BY E1_VEND1"
		 		 		 
	cQry +=           " UNION"
        
/*	cQry +=          " SELECT E1_VEND1, 0 AS VALORE1, SUM(VALOR1) AS VALORE5, 0 VALOR_VENC, 0 AS VALOR_ABERTO"
	cQry +=            " FROM ( SELECT E1_VEND1, E5_NUMERO, E5_PREFIXO, E5_PARCELA, E5_CLIFOR, E1_NOMCLI, E5_LOJA, E5_MOTBX, 
	cQry +=                           "CASE WHEN A.E5_RECPAG = 'R'THEN E5_VALOR ELSE (E5_VALOR * (-1)) END AS VALOR1"
	cQry +=                     " FROM "+RetSQLName("SE5")+" as A (nolock)"
	cQry +=   				      " INNER JOIN  "+RetSQLName("SE1")+"  as B (nolock)"
	cQry +=   	 				      " ON B.D_E_L_E_T_ = '' AND A.E5_NUMERO  = B.E1_NUM"
	cQry +=  					     " AND A.E5_PREFIXO = B.E1_PREFIXO AND A.E5_PARCELA = B.E1_PARCELA"
	cQry +=   				  	     " AND A.E5_CLIFOR  = B.E1_CLIENTE AND A.E5_LOJA    = B.E1_LOJA"
	cQry +=   					     " AND A.E5_TIPO    = B.E1_TIPO    AND B.E1_TIPO NOT IN ('NCC', 'RA') AND B.E1_VEND1 <> ''"
// 	cQry +=                      " AND B.E1_VENCREA BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"'"
   cQry +=   				      " WHERE A.D_E_L_E_T_ = '' AND E5_NUMERO <> ''"
	cQry +=   				  	     " AND A.E5_DATA BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"' "
	cQry +=   					     " AND A.E5_RECPAG = 'R'"
	cQry +=   					     " AND A.E5_TIPODOC IN ('TR','V2','VL','CH','DB','EC', 'ES', 'LJ', 'R$','TE')"
	cQry +=  					     " AND A.E5_MOTBX NOT IN ('CMP') "                
	cQry +=   			       " ) TAB1"
	cQry +=  			 " GROUP BY E1_VEND1"     
	*/
	
	cQry +=          " SELECT E1_VEND1, 0 AS VALORE1, VALOR1 AS VALORE5, 0 VALOR_VENC, 0 AS VALOR_ABERTO "
	cQry +=            " FROM ( SELECT E1_VEND1, SUM(isNull(E5_VALOR,0) - isnull(DEV,0)) VALOR1 "
	cQry +=                     " FROM ( SELECT COALESCE(AA.E1_VEND1, DV.VEND, '') AS E1_VEND1, E.A3_COD, E.A3_NOME, E.A3_COMIS, E5_DOCUMEN, E5_RECPAG, ' ' AS E1_NOMCLI, "
	cQry +=                                   " COALESCE(AA.E5_NUMERO, DV.E1_NUM) AS E5_NUMERO, COALESCE(AA.E5_PREFIXO, DV.E1_PREFIXO) AS E5_PREFIXO, COALESCE(AA.E5_PARCELA, '') AS E5_PARCELA, "
	cQry +=                                   " COALESCE(AA.E5_MOTBX , 'NOR'    ) AS E5_MOTBX , COALESCE(AA.E5_CLIFOR, DV.F2_CLIENTE ) AS E5_CLIFOR , COALESCE(AA.E5_LOJA, DV.F2_LOJA) AS E5_LOJA, "
	cQry +=                                   " COALESCE(AA.E5_DATA, DV.E1_EMISSAO)    E5_DATA, "
	cQry +=             			               " 'zzzzzzz' A3_DTEMIS, F.A3_COD VORIG, DV.DOC_DEV, DV.SER_DEV, E5_VALOR, DEV "
	cQry +=            			          " FROM  ( SELECT E1_VEND1, E5_NUMERO, E5_PREFIXO, E5_PARCELA, E5_CLIFOR, E1_NOMCLI,E5_RECPAG,E5_LOJA,E5_MOTBX,E1_VALOR,E5_DOCUMEN,E5_DATA, "
	cQry +=            							             " SUM ( CASE WHEN E5_TIPODOC IN ( 'JR' ) THEN E5_VALOR *- 1 "
	cQry +=            								                     " ELSE E5_VALOR "
	cQry +=            								                 " END ) E5_VALOR "
	cQry +=            					              " FROM SE5010 A with (NOLOCK) "
	cQry +=            							       " INNER JOIN SE1010 B with (NOLOCK) "
	cQry +=            							          " ON B.D_E_L_E_T_ = '' AND A.E5_NUMERO = B.E1_NUM AND A.E5_PREFIXO = B.E1_PREFIXO "
	cQry +=            							         " AND A.E5_PARCELA = B.E1_PARCELA AND A.E5_CLIFOR = B.E1_CLIENTE AND A.E5_LOJA = B.E1_LOJA AND A.E5_TIPO = B.E1_TIPO "
	cQry +=            					             " WHERE A.D_E_L_E_T_ = '' AND E5_NUMERO <> '' And E5_VALOR > 0 
	cQry +=   				  	                        " AND E5_DATA BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"' "
	cQry +=            							         " AND E1_EMISSAO >= '20130901' And E5_VALOR != 0 AND E5_RECPAG = 'R'AND E1_TIPO NOT IN( 'NCC', 'RA' )"
					         
	cQry +=            					             " GROUP BY E1_VEND1, E5_NUMERO, E5_PREFIXO, E5_PARCELA, E5_CLIFOR, E1_NOMCLI,E5_RECPAG,E5_LOJA,E5_MOTBX,E1_VALOR,E5_DOCUMEN,E5_DATA "

	cQry +=            							       " UNION"
					        
	cQry +=                                      " SELECT E1_VEND1,E5_NUMERO,E5_PREFIXO,E5_PARCELA,E5_CLIFOR,E1_NOMCLI,E5_RECPAG,E5_LOJA,E5_MOTBX,E1_VALOR,E5_DOCUMEN,E5_DATA,E5_VALOR * -1"
	cQry +=                                        " FROM SE5010 C with (NOLOCK)"
	cQry +=                                       " INNER JOIN SE1010 D "
	cQry +=                                          " ON C.D_E_L_E_T_ = ''AND C.E5_NUMERO = D.E1_NUM AND C.E5_PREFIXO = D.E1_PREFIXO AND C.E5_PARCELA = D.E1_PARCELA "
	cQry +=                                         " AND C.E5_CLIFOR = D.E1_CLIENTE AND C.E5_LOJA = D.E1_LOJA AND C.E5_TIPO = D.E1_TIPO AND D.E1_VEND1 <> ''"
	cQry +=                                       " WHERE C.D_E_L_E_T_ = '' AND C.E5_NUMERO <> '' AND E5_RECPAG = 'P' AND C.E5_VALOR > 0 
   cQry +=   				  	                        " AND E5_DATA BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"' "
	cQry +=                                    " ) as AA "
	cQry +=            					    " FULL OUTER JOIN ( SELECT D1_NFORI as E1_NUM, D1_SERIORI as E1_PREFIXO, D1_DOC as DOC_DEV, D1_SERIE as SER_DEV,"
	cQry +=            									 	 	           " E1_EMISSAO, VEND,F2_CLIENTE, F2_LOJA, Isnull(Sum(E1_VALOR), 0) DEV"
	cQry +=            									            " FROM ( SELECT DISTINCT D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_NFORI, D1_SERIORI"
	cQry +=            									 		               " FROM SD1010 with (NOLOCK)"
	cQry +=            									 		              " WHERE D_E_L_E_T_ = '' AND D1_TIPO = 'D' AND D1_NFORI != ' ' AND D1_SERIORI != ' '"
	cQry +=   				  	                                           " AND D1_EMISSAO BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"' "
	cQry +=            									 	              " ) as A"
	cQry +=            									            " LEFT OUTER JOIN SE1010  E1 with (NOLOCK)"
	cQry +=            									 	           " ON E1_NUM = D1_DOC AND E1_PREFIXO = D1_SERIE AND E1_CLIENTE = D1_FORNECE AND E1_LOJA = D1_LOJA"
	cQry +=            									 	         " LEFT OUTER JOIN ( SELECT SF2.F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_VEND1 as VEND,Sum(F2_VALBRUT) VAL"
	cQry +=            									 		 			                 " FROM SF2010 SF2 with (NOLOCK)"
	cQry +=            									 		 			                " WHERE SF2.D_E_L_E_T_ = ''"
	cQry +=            									 	                            " GROUP BY F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_VEND1"
	cQry +=            									 		 			              " ) as EA"
	cQry +=            									              " ON EA.F2_DOC = D1_NFORI AND EA.F2_SERIE = D1_SERIORI"
	cQry +=            									           " GROUP BY D1_NFORI, D1_SERIORI, D1_DOC, D1_SERIE, E1_EMISSAO, F2_CLIENTE, F2_LOJA, VEND"
	cQry +=            									        " ) as DV"
	cQry +=            					      " ON DV.E1_NUM = E5_NUMERO AND DV.E1_PREFIXO = E5_PREFIXO"
					 
	cQry +=            					    " LEFT OUTER JOIN ( SELECT E5_NUMERO as E1_NUM,E5_PREFIXO as E1_PREFIXO,E5_CLIFOR as E1_CLIENTE,E5_LOJA as E1_LOJA, Count(*) as PARCELA "
	cQry +=            									            " FROM SE5010 with (NOLOCK)"
	cQry +=            									           " WHERE  D_E_L_E_T_ = ''"
	cQry +=            										          " AND E5_DATA BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"' "	
	cQry +=            										          " And E5_VALOR > 0"
	cQry +=            									           " GROUP BY E5_NUMERO, E5_PREFIXO, E5_CLIFOR, E5_LOJA"
	cQry +=            									        " ) as PA	"
	cQry +=            					      " ON PA.E1_NUM = E5_NUMERO AND E5_PREFIXO = PA.E1_PREFIXO AND E5_CLIFOR = PA.E1_CLIENTE AND PA.E1_LOJA = E5_LOJA"
					
	cQry +=            					    " LEFT OUTER JOIN ( SELECT D1_DOC,D1_SERIE,D1_SERIORI,D1_NFORI,F2_VEND1 "
	cQry +=            									            " FROM SD1010 D1 with(nolock)"
	cQry +=            									            " LEFT OUTER JOIN SF2010 F2 with (NOLOCK) on F2_DOC = D1_NFORI and F2_SERIE = D1_SERIORI AND F2.D_E_L_E_T_ = ''"
	cQry +=            									           " WHERE D1.D_E_L_E_T_ = ''"
	cQry +=            									             " AND D1_TIPO = 'D'"
	cQry +=            									           " GROUP BY D1_DOC,D1_SERIE,D1_NFORI,D1_SERIORI,F2_VEND1"
	cQry +=            									        " ) AS DEV "
	cQry +=            						   " on D1_SERIE+D1_DOC = Left(E5_DOCUMEN,12)"

	cQry +=            					    " LEFT OUTER JOIN SA3010  E with (NOLOCK) ON E.D_E_L_E_T_ = '' AND E.A3_COD = COALESCE(AA.E1_VEND1, DV.VEND) 
	cQry +=            					    " LEFT OUTER JOIN SA3010  F with (NOLOCK) ON F.D_E_L_E_T_ = '' AND F.A3_COD = DEV.F2_VEND1
	cQry +=                          " ) AS AAA
	cQry +=                    " WHERE E1_VEND1 IS NOT NULL AND NOT(E5_MOTBX = 'CMP' AND E5_DATA > A3_DTEMIS AND VORIG != A3_COD)
	cQry +=                    " GROUP BY E1_VEND1, A3_COD,A3_NOME,A3_COMIS 
	cQry +=                  " ) as A
		
	cQry +=      " ) AS TAB2"
	
	cQry +=  " INNER JOIN "+RetSQLName("SA3")+" AS SA3 ON SA3.D_E_L_E_T_ = '' AND SA3.A3_COD = TAB2.E1_VEND1"
 
	cQry +=  " GROUP BY E1_VEND1, SA3.A3_NOME, SA3.A3_TIPO"
	cQry +=  " ORDER BY E1_VEND1, SA3.A3_NOME"                                      
	
	MemoWrite("AAFINP03.sql",cQry)

 	   
 	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), "WWW", .T., .F. ) 
 	
Return cQry

Static Function ExportaExcel(aExport)
	Local i, j, nHdl, oExcelApp
	Local cArqTxt := GetTempPath()+"\FATXLIQ.xls"
	Local cLinha  := ""
	
	If File(cArqTxt)
		FErase(cArqTxt)
	Endif
	
	nHdl := fCreate(cArqTxt)
	
	cLinha += "VENDEDOR"    + Chr(9) + "NOME VENDEDOR"  + Chr(9) + "TIPO VENDEDOR"  + Chr(9) 
	cLinha += "FATURAMENTO"  + Chr(9) + "LIQUIDEZ"  + Chr(9) + "EM ABERTO" + Chr(9) + "INADIMPLENCIA"
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
	
	oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
	oExcelApp:WorkBooks:Open(cArqTxt)
	oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.
	oExcelApp:Destroy()
Return Nil

Static Function ValidPerg(cPerg)
	PutSx1(cPerg,"01",PADR("Da    Emissao   ",29)+"?","","","mv_ch1","D", 8,0,0,"G","","   ","","","mv_par01")
	PutSx1(cPerg,"02",PADR("Ate a Emissao   ",29)+"?","","","mv_ch2","D", 8,0,0,"G","","   ","","","mv_par02")
	PutSx1(cPerg,"03",PADR("Da    Baixa     ",29)+"?","","","mv_ch1","D", 8,0,0,"G","","   ","","","mv_par03")
	PutSx1(cPerg,"04",PADR("Ate a Baixa     ",29)+"?","","","mv_ch2","D", 8,0,0,"G","","   ","","","mv_par04")
	PutSx1(cPerg,"05",PADR("Do    Vencimento",29)+"?","","","mv_ch1","D", 8,0,0,"G","","   ","","","mv_par05")
	PutSx1(cPerg,"06",PADR("Ate o Vencimento",29)+"?","","","mv_ch2","D", 8,0,0,"G","","   ","","","mv_par06")
	
Return