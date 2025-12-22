/*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ AAFATR08   ¦ Autor ¦Wermeson Gadelha      ¦ Data ¦ 12/04/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Relatório Gráfico de Frete Faturamento                        ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

//  .--------------------------------------.
// |  Inclusao de Bibliotecas e Constantes  |
//  '--------------------------------------' 
#include "Protheus.ch"
#include "rwMake.ch"

//  .--------------------------------------.
// |  Rotina principal							  |
//  '--------------------------------------' 
User Function AAFATR09()                                                         
 //  .--------------------------------------.
 // |  Declaracao de variaveis locais        |
 //  '--------------------------------------' 
 Local   cPerg    := PADR("AAFATR08", Len(SX1->X1_GRUPO)) // nome da pergunta no sx1 
 Local   cTitulo  := "Relatório de Vendas Reserva"        // titulo do relatório 
 Local   oFormIni := Nil                                  // objeto do frame principal 

 //  .--------------------------------------.
 // |  Declaracao de variaveis privadas      |
 //  '--------------------------------------' 
 Private aExc     := {}      										// Vetor que guarda as informações para o Excel 
 Private aTotGer  := {0,0,0}										// Vetor para armazenagem do valor total 


 	//  .-------------------------------------------.
 	// |  Configuração das perguntas do relatório    |
	//  '-------------------------------------------'    
	ValidPerg(cPerg)	
	Pergunte(cPerg, .F.)   

 	//  .-------------------------------------------.
 	// |  Montagem de tela para escolhas do usuário  |
	//  '-------------------------------------------'    	                                                                 
	@96,042 TO 323,505 DIALOG oFormIni TITLE cTitulo
		@08, 010 TO 84,222
		@23, 014 SAY "Esta rotina irá emitir relatório de vendas reserva"
		@33, 014 SAY "(Valores em R$) Conforme parâmetros fornecidos pelo usuário."
		
		@91, 111 BUTTON "Parâmetros"	SIZE 40, 15 ACTION Pergunte(cPerg, .T.)
		@91, 152 BUTTON "OK" 		 	SIZE 30, 15 ACTION (Processa({|| RunProc(), "Selecionando dados...", cTitulo, .T. }), Close(oFormIni))
		@91, 183 BUTTON "Cancelar"		SIZE 40, 15 ACTION Close(oFormIni)	
	ACTIVATE DIALOG oFormIni CENTERED

Return Nil

//  .-------------------------------------------.
// |  Rotina de processamento do relatório       |
//  '-------------------------------------------'    
Static Function RunProc()
	Private oFatFret                                           
	Private hMin, hMax, wMin, wMax, tLinha
	Private nLin, nTotPag, lEntrou, nPrint                   
	Private lRoda   := .F.	                  
	

	oFatFret:= TMSPrinter():New("Relatório  de vendas reserva")
	oFatFret:SetPortrait() // ou SetLandscape()          
	
	hMin := 50
	hMax := 3100
	wMin := 50
	wMax := 3200                          
	
	Define FONT oFontItem   NAME "Arial" 		Size 0,08 Of oFatFret  
	Define FONT oFontCab  	NAME "Arial" BOLD Size 0,08 Of oFatFret
	Define FONT oFontTit    NAME "Arial" BOLD Size 0,12 Of oFatFret       
	Define FONT oFontTit2   NAME "Arial" 		Size 0,10 Of oFatFret
	
	execReport()        
	
	If (mv_par05 == 1)
		oFatFret:Preview()
	 else
	 	GoExcel()
	endif  
	
	oFontCab :End()
	oFontTit :End()
	oFontTit2:End()
	oFatFret :End()
	oFontItem:End()

Return Nil   

//  .-------------------------------------------.
// |  Consulta sql para buscas as informações    |
// |  necessárias para implementação do reltório |   
//  '-------------------------------------------'    
Static Function geraArea()
 Local cQry := ""
   	
	cQry += "SELECT L2_PRODUTO, B1_ESPECIF, B1_UM, L2_FILRES, SUM(L2_QUANT ) L2_QUANT, "
   cQry +=       " ISNULL(SMATRIZ_06200, 0) AS SMATRIZ_06200," 
   cQry +=       " ISNULL(SMATRIZDEP   , 0) AS SMATRIZDEP," 
   cQry +=       " ISNULL(SMATRIZ_06300, 0) AS SMATRIZ_06300, "
	cQry +=       " ISNULL(SMATRIZ_04208, 0) AS SMATRIZ_04208, "
	cQry +=       " ISNULL(SSILVES      , 0) AS SSILVES "

   cQry +=  " FROM " + RetSQLName("SL2") + " A "
   
   cQry += " INNER JOIN " + RetSQLName("SL1") + " B "
   cQry +=    " ON L1_FILIAL = L2_FILIAL "
   cQry +=   " AND L1_NUM = L2_NUM "
   cQry +=   " AND B.D_E_L_E_T_ = '' "
   cQry +=   " AND B.L1_RESERVA = 'S' "
   cQry +=   " AND B.L1_DOCPED <> '' "
           
   cQry += " INNER JOIN " + RetSQLName("SB1") + " C "
   cQry +=    " ON B1_COD=L2_PRODUTO "
   cQry +=   " AND C.D_E_L_E_T_='' "

   cQry += " Left JOIN ( SELECT B2_COD, IsNull([00-MATRIZ-06200],0) SMATRIZ_06200, IsNull([00-MATRIZDEP],0) SMATRIZDEP, 
   cQry +=                    " IsNull([01-MATRIZ 06300],0) SMATRIZ_06300, IsNull([02-MATRIZ 04208],0) SMATRIZ_04208, 
   cQry +=                    " IsNull([03-FILIAL 04],0) SSILVES 
   cQry +=   			    " FROM ( SELECT B2_COD, CASE WHEN B2_LOCAL = '13' THEN '00-MATRIZDEP' 
   cQry +=                                           " ELSE LJ_NOME  END LJ_NOME, B2_QATU 
   cQry +=                         " FROM " + RetSQLName("SB2") + " A "
   cQry +=                         " LEFT OUTER JOIN " + RetSQLName("SLJ") + " B "
   cQry +=                           " ON B2_FILIAL=LJ_RPCFIL AND B.D_E_L_E_T_='' "
   cQry +=                        " WHERE A.D_E_L_E_T_ = '' "
   cQry +=                     " ) A "
   cQry +=               " PIVOT ( SUM ( B2_QATU) "
   cQry +=                 " FOR LJ_NOME IN ([00-MATRIZ-06200], [00-MATRIZDEP], [01-MATRIZ 06300], "
   cQry +=                                 " [02-MATRIZ 04208], [03-FILIAL 04]) ) PVT1 "
   cQry +=            " ) as D "
    
   cQry += " On A.L2_PRODUTO = D.B2_COD "

   cQry += " WHERE A.D_E_L_E_T_ = '' "
   cQry +=   " AND L1_EMISSAO BETWEEN '"+dTos(MV_PAR01)+"' AND '"+dTos(MV_PAR02)+"' "
   cQry +=   " AND L2_FILRES <> '' "

   cQry += " GROUP BY L2_PRODUTO, B1_ESPECIF, B1_UM, L2_FILRES, SMATRIZ_06200, SMATRIZDEP, SMATRIZ_06300, SMATRIZ_04208, SSILVES "                      
   cQry += " ORDER BY L2_PRODUTO, B1_ESPECIF, B1_UM, L2_FILRES "                      
   
   
	MemoWrit("AAFATR09.sql",cQry)

	DbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "AMDG", .T., .T.)	
	
Return Nil
                                                                            
//-------------------------------------------------------------------
//-                  Rotina de geração do relatório                 -
//-			Desenvolvido por: Nilson Neto          Em 02/01         -
//-------------------------------------------------------------------
Static Function ExecReport()
	Local nLinIni
	Local nLin    := 100
	Local lPrint  := .F.  
	Local cCodigo := ""
	Local nLnP    := 45  
	Local nPagin  := 0      
	Local nTFrete := nTQuebra := 0            
	Local cProduto, cCliente
	Local aTotCli  := {0,0,0}
	Local cData := "De " + dtoc(mv_par01) + " até " + dtoc(mv_par02)
	        
	
	geraArea() 
	
	If (AMDG->(EOF()))
		MsgStop("Não há dados a serem exibidos com os parâmetros informados!")
		AMDG->(dbCloseArea())
		Return Nil
	Endif
	
	While (!AMDG->(EOF()))                                           
		oFatFret:StartPage()     
		nPagin++
		nLin := 100 
		//Cabeçalho
	   oFatFret:Line(hMin, wMin, hMin, wMax)        
  	   oFatFret:Line(hMin+1, wMin, hMin+1, wMax)        
	   oFatFret:Say(nLin,1200,"Relatório vendas reserva",oFontTit,,,,2)                           
		oFatFret:Say(nLin,2500,"SIGA/PAFATRR09" ,oFontTit2,,,,1)
		
		nLin += nLnP
	   oFatFret:Say(nLin,1200,"Período: " + cData ,oFontTit2,,,,2)                               
		oFatFret:Say(nLin,2500,"Página " + iif (nPagin < 1000, strzero(nPagin,2), strzero(nPagin,3)),oFontTit2,,,,1)
	   oFatFret:Say(nLin+25,0300,"Emissão: " + dtoc(dDataBase) + " " + substr(Time(), 1, 5),oFontTit2,,,,3)   
		
		oFatFret:SayBitmap (hMin+20, wMin, FisxLogo("1"), 230, 150)  
	   oFatFret:Line(hMin+170, wMin, hMin+170, wMax)
	   oFatFret:Line(hMin+171, wMin, hMin+171, wMax)
		
		nLin   := 250                                                                         
		
	   oFatFret:Say(nLin,0100,"Código"	                , oFontCab)
	   oFatFret:Say(nLin,0300,"Especificação de produto", oFontCab)
		oFatFret:Say(nLin,1100,"U.M."               		 , oFontCab)
		oFatFret:Say(nLin,1200,"Filial" 	                , oFontCab)
		oFatFret:Say(nLin,1500,"Vendido"                 , oFontCab,,,,1)
		oFatFret:Say(nLin,1700,"Dep. Fechado"            , oFontCab,,,,1)
		oFatFret:Say(nLin,1900,"Matriz 06200"            , oFontCab,,,,1)
		oFatFret:Say(nLin,2100,"Matriz 06300"            , oFontCab,,,,1)
		oFatFret:Say(nLin,2300,"Matriz 04208"            , oFontCab,,,,1)
		oFatFret:Say(nLin,2500,"Filial Silves"           , oFontCab,,,,1)

		nLin   += nLnP             
	   nFrete := nQuebra := 0

		While ((!AMDG->(EOF())) .And. (nLin < hMax))
					
			If (mv_par05 == 1)			
					oFatFret:Say(nLin,0100,AMDG->L2_PRODUTO, oFontItem)
					oFatFret:Say(nLin,0300,AMDG->B1_ESPECIF, oFontItem)
					oFatFret:Say(nLin,1100,AMDG->B1_UM     , oFontItem)
					oFatFret:Say(nLin,1200,AMDG->L2_FILRES , oFontItem)
					oFatFret:Say(nLin,1500,AllTrim(Transform(AMDG->L2_QUANT     ,"@E 999,999,999.99")), oFontItem,,,,1)		
					oFatFret:Say(nLin,1700,AllTrim(Transform(AMDG->SMATRIZDEP   ,"@E 999,999,999.99")), oFontItem,,,,1)		
					oFatFret:Say(nLin,1900,AllTrim(Transform(AMDG->SMATRIZ_06200,"@E 999,999,999.99")), oFontItem,,,,1)		
					oFatFret:Say(nLin,2100,AllTrim(Transform(AMDG->SMATRIZ_06300,"@E 999,999,999.99")), oFontItem,,,,1)		
					oFatFret:Say(nLin,2300,AllTrim(Transform(AMDG->SMATRIZ_04208,"@E 999,999,999.99")), oFontItem,,,,1)		
					oFatFret:Say(nLin,2500,AllTrim(Transform(AMDG->SSILVES      ,"@E 999,999,999.99")), oFontItem,,,,1)		

				Else //No caso de exportação para Excel
					aAdd(aExc, array(10))
					aExc[Len(aExc)][01] := AMDG->L2_PRODUTO
					aExc[Len(aExc)][02] := AMDG->B1_ESPECIF
					aExc[Len(aExc)][03] := AMDG->B1_UM
					aExc[Len(aExc)][04] := AMDG->L2_FILRES
					aExc[Len(aExc)][05] := Transform(AMDG->L2_QUANT 	 , "@E 999,999,999.99")					
					aExc[Len(aExc)][06] := Transform(AMDG->SMATRIZDEP   , "@E 999,999,999.99")
					aExc[Len(aExc)][07] := Transform(AMDG->SMATRIZ_06200, "@E 999,999,999.99")
					aExc[Len(aExc)][08] := Transform(AMDG->SMATRIZ_06300, "@E 999,999,999.99")
					aExc[Len(aExc)][09] := Transform(AMDG->SMATRIZ_04208, "@E 999,999,999.99")
					aExc[Len(aExc)][10] := Transform(AMDG->SSILVES		 , "@E 999,999,999.99")					
			Endif
			
			aTotGer[1] += AMDG->L2_QUANT			
			nLin+=nLnP		
			
			AMDG->(dbSkip())
		EndDo		      	
		      	
      
	   If (AMDG->(EOF())) //Caso seja o fim do relatório
			oFatFret:Line(nLin+1, wMin, nLin+1, 3000)      
			nLin += 10                                                                                            
			
			
  	   	oFatFret:Say(nLin,hMin,"TOTAL GERAL:", oFontCab)
			oFatFret:Say(nLin,2250, ALLTRIM(Transform(aTotGer[01], "@E 99,999,999.99")), oFontCab,,,,1)						
		EndIf	

		oFatFret:EndPage() 

	EndDo     
	              
//	oFatFret:EndPage() 
	AMDG->(dbCloseArea())

Return Nil

//------------------------------------------------------------------- 
//-                Rotina de Exportação para o Excel                -
//-             Desenvolvida por: Nilson Neto          Data: 25/10  -
//------------------------------------------------------------------- 
Static Function GoExcel()
	Local nHdl
	Local cDir  := GetTempPath()
	Local cNome := "AAFATR09"
	Local nI,nJ, nTam
	Local oExcelApp

	cArq := AllTrim(cDir)+"\"+AllTrim(cNome)+".xls" 
	nHdl:= fCreate(cArq)
	If (!File(cArq))
		MsgStop("O Arquivo " + cArq + " não pode ser Criado!")
		Return Nil
	EndIf 
     
	//Cria Cabeçalho (Primeira linha)
	cLinha := "Código" + chr(9) + "Especificação de produto" + chr(9) + "U.M." + chr(9) + "Filial" + chr(9) + "Quantidade"  + chr(9) 
	cLinha += "Dep. Fechado" + chr(9) + "Matriz 06200" + chr(9) + "Matriz 06300" + chr(9) + "Matriz 04208" + chr(9) + "Filial Silves" + chr(13)+chr(10)

	If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
	EndIf

	For nI:=1 to Len(aExc)  
		cLinha := ""
		nTam := Len(aExc[nI])
		For nJ := 1 to Len(aExc[nI])
			cLinha += aExc[nI][nJ] + Chr(9)
		NEXT nJ          
		cLinha += chr(13)+chr(10)				
		If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
		EndIf
	Next nI

	cLinha := chr(13)+chr(10)		
	cLinha += chr(13)+chr(10)		
	cLinha += "TOTAL"
	
	For nJ := 1 to nTam-1
		cLinha += Chr(9)		
	Next nJ
			
	For nJ := 1 to 1
		cLinha += Transform(aTotGer[nJ], "@E 999,999,999.99") + Chr(9)                        
	Next nJ
	cLinha += chr(13)+chr(10)

	If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
	EndIf

	fClose(nHdl)
	If (!ApOleClient('MsExcel'))
		MsgStop('Excel não instalado')
		Return Nil
	EndIf
	oExcelApp := MsExcel():New()                    	  
	oExcelApp:WorkBooks:Open(cArq)
	oExcelApp:SetVisible(.T.)     	
	oExcelApp:Destroy()
Return Nil

//------------------------------------------------------------------- 
//-              Rotina de criação das perguntas no SX1             -
//-          Desenvolvida por: Nilson Neto          Data: 23/12     -
//------------------------------------------------------------------- 
Static Function ValidPerg(cPerg)                                            

	PutSX1(cPerg,"01","Emissão de     ?", "", "", "mv_ch1", "D", 08,00,00,"G","","   ","","","mv_par01")   	
	PutSX1(cPerg,"02","Emissão até    ?", "", "", "mv_ch2", "D", 08,00,00,"G","","   ","","","mv_par02")   
		
	PutSX1(cPerg,"03","Produto de     ?", "", "", "mv_ch3", "C", 15,00,00,"G","","SB1","","","mv_par03")   	
	PutSX1(cPerg,"04","Produto Até    ?", "", "", "mv_ch4", "C", 15,00,00,"G","","SB1","","","mv_par04")   
                                        
	PutSX1(cPerg,"05","Tipo Impressao ?", "", "", "mv_ch5", "N", 01,00,00,"C","","   ","","","mv_par05", "Normal", "", "", "", "Excel", "", "")		  
	
Return Nil                                                                            

//************************************************************************************ 
/*----------------------------------------------------------------------------------||
||       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||      AAAA       LL         LL         EE         CC        KK    KK   SS         ||
||     AA  AA      LL         LL         EE        CC         KK  KK     SS         ||
||    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   ||
||   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  ||
||  AA        AA   LL         LL         EE         CC        KK    KK          SS  ||
|| AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||----------------------------------------------------------------------------------*/
//************************************************************************************