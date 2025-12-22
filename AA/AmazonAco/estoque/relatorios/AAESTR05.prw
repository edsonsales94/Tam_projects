#include "TOTVS.ch"
#INCLUDE "FWPrintSetup.ch"

User Function AAESTR05()

	Local aButton   := {}
	Local aSay      := {}
	Private _ndPag  := 01
	Private oPrn     := Nil
	Private _cdCont  := 0
	Private cPerg    := Padr('AAESTR05',Len(SX1->X1_GRUPO))
	Private oExcel   := Nil
	Private nOpc     := 0
	Private aColunas := {0,0,0,0,0,0,0,0,0,0,0,}

	ValidPerg(cPerg)

	aAdd( aSay, "Esta Rotina tem Por Objetivo Imprimir as Informações" )
	aAdd( aSay, "de Sugestão de Compra com Base nos Parametros Informados" )

	aAdd( aButton, { 5, .T., {|x| Pergunte(cPerg)         }} )
	aAdd( aButton, { 1, .T., {|x| nOpc := 1, FechaBatch() }} )
	aAdd( aButton, { 2, .T., {|x| nOpc := 2, FechaBatch() }} )

	FormBatch( "Sugestão de Compras", aSay, aButton )
	If nOpc == 1
		_doTask()
	Else
   //_doNothing()
	EndIf

	Return Nil


Static Function _doTask()                                   
 Local   aTotais := {0,0,0,0,0,0,0,0,0,0}

	Pergunte(cPerg,.F.)
	lAdjustToLegacy := .F.
	lDisableSetup  := .T.

//Private oFont1 := TFont():New( "Courier New", , -18, .T.)

/*******************************************************
*** FONTE = NOME DA FONTE                            ***
*** T = TAMANHO DA FONTE                             ***
*** N = NEGRITO( DEFINE SE A FONTE SERA EM NEGRITO)  ***
*** S = SUBLINHADO ( DEFINE SE A FONTE SERA SUBLINHA)***
*** I = ITALICO                                      ***
********************************************************/
//                                  FONTE              T       N            S   I
	PRIVATE oFont10N   := TFont():New("Times New Roman",08,08, ,.T., , , , , .F.,.F.)// 1
	
	PRIVATE oFont07N   := TFont():New("Times New Roman",06,06, ,.T., , , , , .F.,.F.)// 2
	PRIVATE oFont07    := TFont():New("Times New Roman",06,06, ,.F., , , , , .F.,.F.)// 3
	PRIVATE oFont07C    := TFont():New("Courier New"   ,06,06, ,.F., , , , , .F.,.F.)// 3
	
	PRIVATE oFont08    := TFont():New("Times New Roman",07,07, ,.F., , , , , .F.,.F.)// 4
	PRIVATE oFont08N   := TFont():New("Times New Roman",07,07, ,.T., , , , , .F.,.F.)// 5
	PRIVATE oFont08c   := TFont():New("Courier New"     ,07,07, ,.F., , , , , .F.,.F.)// 5
	
	PRIVATE oFont09N   := TFont():New("Times New Roman",08,08, ,.T., , , , , .F.,.F.)// 6
	PRIVATE oFont09    := TFont():New("Times New Roman",08,08, ,.F., , , , , .F.,.F.)// 7
	PRIVATE oFont09c   := TFont():New("Courier New"     ,08,08, ,.F., , , , , .F.,.F.)// 7
	
	PRIVATE oFont10    := TFont():New("Times New Roman",09,09, ,.F., , , , , .F.,.F.)// 8
	PRIVATE oFont10n   := TFont():New("Times New Roman",09,09, ,.T., , , , , .F.,.F.)// 8
	
	PRIVATE oFont11    := TFont():New("Times New Roman",10,10, ,.T., , , , , .F.,.F.)// 9
	PRIVATE oFont12    := TFont():New("Times New Roman",11,11, ,.F., , , , , .F.,.F.)// 10
	PRIVATE oFont12c   := TFont():New("Courier New    ",11,11, ,.F., , , , , .F.,.F.)// 10
	PRIVATE oFont12n   := TFont():New("Times New Roman",11,11, ,.T., , , , , .F.,.F.)// 10
	PRIVATE oFont11N   := TFont():New("Times New Roman",10,10, ,.T., , , , , .F.,.F.)// 11
	PRIVATE oFont15N   := TFont():New("Times New Roman",14,14, ,.T., , , , , .F.,.F.)// 12
	PRIVATE oFont18N   := TFont():New("Times New Roman",17,17, ,.T., , , , , .F.,.F.)// 12
	PRIVATE OFONT12N   := TFont():New("Times New Roman",11,11, ,.T., , , , , .F.,.F.)// 12

	oPrn := TMSPrinter():New("AAESTR05.REL")//, , .F., , .F.)// Ordem obrigátoria de configuração do relatório
	//oPrn:SetResolution(72)
	//oPrn:SetPaperSize(DMPAPER_A4)
	//oPrn:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior
	oPrn:Setup()
	//oPrn:cPathPDF:="c:\bkp_drv"
	oPrn:SetLandScape()
    //_ndLin := _doCabec(.T.)
	oPrn:StartPage()
    
	_cdTab := getSql()
    
	_cdSheet := 'Sug.Produção'
	_cdTb     := 'Sugestao de Produção'
    
	If !(_cdTab)->(Eof())
		_ndLin   := _doCabec(.T.) + 20
		_odExcel := FWMSEXCEL():New()
		
		_odExcel:AddWorkSheet(_cdSheet)
		_odExcel:AddTable(_cdSheet,_cdTb)
       	
		_odExcel:AddColumn(_cdSheet,_cdTb, "Ferramenta"     , 1 , 1 , .F.)
		_odExcel:AddColumn(_cdSheet,_cdTb, "Produto"        , 1 , 1 , .F.)
		_odExcel:AddColumn(_cdSheet,_cdTb, "Especificação" , 1 , 1 , .F. )
       	
		_odExcel:AddColumn(_cdSheet,_cdTb, "MES 01"   , 3 , 2 , .F. )
		_odExcel:AddColumn(_cdSheet,_cdTb, "MES 02"   , 3 , 2 , .F. )
		_odExcel:AddColumn(_cdSheet,_cdTb, "MES 03"   , 3 , 2 , .F. )
		_odExcel:AddColumn(_cdSheet,_cdTb, "MES 04"   , 3 , 2 , .F. )
		_odExcel:AddColumn(_cdSheet,_cdTb, "MES 05"   , 3 , 2 , .F. )
		_odExcel:AddColumn(_cdSheet,_cdTb, "MES 06"   , 3 , 2 , .F. )
		
		_odExcel:AddColumn(_cdSheet,_cdTb, "Saldo Puraquequara"   , 3 , 2 , .F. )
		_odExcel:AddColumn(_cdSheet,_cdTb, "Saldo 06.300"   , 3 , 2 , .F. )
		_odExcel:AddColumn(_cdSheet,_cdTb, "Saldo 04.208"   , 3 , 2 , .F. )
		
		_odExcel:AddColumn(_cdSheet,_cdTb, "Saldo Total "   , 3 , 2 , .F. )
		_odExcel:AddColumn(_cdSheet,_cdTb, "Total em Pedidos"     , 3 , 2 , .F. )
		_odExcel:AddColumn(_cdSheet,_cdTb, "Consumo Medio"         , 3 , 2 , .F. )
		_odExcel:AddColumn(_cdSheet,_cdTb, "Sugestão de Produção"   , 3 , 2 , .F. )
       	
       	    
		oPrn:Line(_ndLin,010,_ndLin , 3400 )//,,"-4")
		_ndLin += 10
	    
		While !(_cdTab)->(Eof())
			_cdDescri := If( Empty(ALltrim((_cdTab)->B1_ESPECIF)),(_cdTab)->B1_DESC,(_cdTab)->B1_ESPECIF)
	        
			oPrn:Say( _ndLin + 5, aColunas[01]     , (_cdTab)->ZH_DESC                                , oFont07 )
			oPrn:Say( _ndLin + 5, aColunas[02]     , (_cdTab)->B1_COD                                 , oFont07 )
			oPrn:Say( _ndLin + 5, aColunas[03]     , _cdDescri                                        , oFont07 )
			oPrn:Say( _ndLin + 5, aColunas[04] - 50, Transform((_cdTab)->MES01   ,"@E 999,999,999.99"), oFont07c)
			oPrn:Say( _ndLin + 5, aColunas[05] - 50, Transform((_cdTab)->MES02   ,"@E 999,999,999.99"), oFont07c)
			oPrn:Say( _ndLin + 5, aColunas[06] - 30, Transform((_cdTab)->MES03   ,"@E 999,999,999.99"), oFont07c)
			oPrn:Say( _ndLin + 5, aColunas[07] - 30, Transform((_cdTab)->MES04   ,"@E 999,999,999.99"), oFont07c)
			oPrn:Say( _ndLin + 5, aColunas[08] - 30, Transform((_cdTab)->MES05   ,"@E 999,999,999.99"), oFont07c)
			oPrn:Say( _ndLin + 5, aColunas[09] - 30, Transform((_cdTab)->MES06   ,"@E 999,999,999.99"), oFont07c)
			oPrn:Say( _ndLin + 5, aColunas[10] - 30, Transform((_cdTab)->B2_QATU ,"@E 999,999,999.99"), oFont07c)
			oPrn:Say( _ndLin + 5, aColunas[11] - 10, Transform((_cdTab)->PEDIDO  ,"@E 999,999,999.99"), oFont07c)
			oPrn:Say( _ndLin + 5, aColunas[12] - 10, Transform((_cdTab)->MEDIA   ,"@E 999,999,999.99"), oFont07c)
			oPrn:Say( _ndLin + 5, aColunas[13] - 10, Transform((_cdTab)->SUGESTAO,"@E 999,999,999.99"), oFont07c)
	        
			oPrn:Line(_ndLin,010,_ndLin , 3400 )
	       
	  		aTotais[01] += (_cdTab)->MES01
	  		aTotais[02] += (_cdTab)->MES02	      
	  		aTotais[03] += (_cdTab)->MES03
	  		aTotais[04] += (_cdTab)->MES04
	  		aTotais[05] += (_cdTab)->MES05
	  		aTotais[06] += (_cdTab)->MES06
	  		aTotais[07] += (_cdTab)->B2_QATU
	  		aTotais[08] += (_cdTab)->PEDIDO
	  		aTotais[09] += (_cdTab)->MEDIA
	  		aTotais[10] += (_cdTab)->SUGESTAO
	      
	        
			_adRow := {}
			aAdd(_adRow, (_cdTab)->ZH_DESC )
			aAdd(_adRow, (_cdTab)->B1_COD  )
			aAdd(_adRow, (_cdTab)->B1_ESPECIF )
			aAdd(_adRow, (_cdTab)->MES01)
			aAdd(_adRow, (_cdTab)->MES02)
			aAdd(_adRow, (_cdTab)->MES03)
			aAdd(_adRow, (_cdTab)->MES04)
			aAdd(_adRow, (_cdTab)->MES05)
			aAdd(_adRow, (_cdTab)->MES06)
			
			aAdd(_adRow, (_cdTab)->_00)
			aAdd(_adRow, (_cdTab)->_01)
			aAdd(_adRow, (_cdTab)->_02)
			
			aAdd(_adRow, (_cdTab)->B2_QATU)
			aAdd(_adRow, (_cdTab)->PEDIDO )
			aAdd(_adRow, (_cdTab)->MEDIA )
			aAdd(_adRow, (_cdTab)->SUGESTAO )
			_odExcel:addRow(_cdSheet,_cdTb,_adRow)
			_ndLin += 040
			
			If _ndLin > 2200
			    
				oPrn:Line(_ndLin,010,_ndLin , 3400 )//,,"-4")
				oPrn:EndPage()
				oPrn:StartPage()
				_ndPag++
				oPrn:Line(_ndLin,010,_ndLin , 3200 )//,,"-4")
				_ndLin := _doCabec(.T.) + 20
				oPrn:Line(_ndLin,010,_ndLin , 3400 )//,,"-4")
				_ndLin += 10
			EndIF
			(_cdTab)->(dbSkip())
		EndDo
	Else
		_ndLin   := _doCabec(.T.)
	EndIF
	
	
	oPrn:Line(_ndLin+25,010,_ndLin+25 , 3400 )//,,"-4")

  	oPrn:Say( _ndLin +35, aColunas[01]     , " T O T A L    G E R A L", oFont07 )
	oPrn:Say( _ndLin +35, aColunas[04] - 50, Transform(aTotais[01], "@E 999,999,999.99"), oFont07c)
	oPrn:Say( _ndLin +35, aColunas[05] - 50, Transform(aTotais[02], "@E 999,999,999.99"), oFont07c)
	oPrn:Say( _ndLin +35, aColunas[06] - 30, Transform(aTotais[03], "@E 999,999,999.99"), oFont07c)
	oPrn:Say( _ndLin +35, aColunas[07] - 30, Transform(aTotais[04], "@E 999,999,999.99"), oFont07c)
	oPrn:Say( _ndLin +35, aColunas[08] - 30, Transform(aTotais[05], "@E 999,999,999.99"), oFont07c)
	oPrn:Say( _ndLin +35, aColunas[09] - 30, Transform(aTotais[06], "@E 999,999,999.99"), oFont07c)
	oPrn:Say( _ndLin +35, aColunas[10] - 30, Transform(aTotais[07], "@E 999,999,999.99"), oFont07c)
	oPrn:Say( _ndLin +35, aColunas[11] - 10, Transform(aTotais[08], "@E 999,999,999.99"), oFont07c)
	oPrn:Say( _ndLin +35, aColunas[12] - 10, Transform(aTotais[09], "@E 999,999,999.99"), oFont07c)
	oPrn:Say( _ndLin +35, aColunas[13] - 10, Transform(aTotais[10], "@E 999,999,999.99"), oFont07c)

	oPrn:Line(_ndLin+60,010,_ndLin+60 , 3400 )//,,"-4")

	//_doCoor()
    
    /*
	if oPrn:nModalResult == PD_OK
		oPrn:Preview()
	EndIf
	*/
	//oPrn:Print()	
	oPrn:Preview()
	
	if mv_par11 == 01 .And. !Empty(Alltrim(mv_par09))
		If Empty(Alltrim(mv_par10))
			mv_par10 := 'AAESTR03'
		EndIf
		_odExcel:Activate()
		_odExcel:GetXMLFile(mv_par09 + mv_par10 + '.xls' )
		
		RunExcel( mv_par09 + mv_par10 + '.xls')
	EndIF
//oPrn:cPathPDF := "c:\directory\" // Caso seja utilizada impressão em IMP_PDF    

	Return
	
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
	oExcelApp:Destroy()
	Return


Static Function _doCoor()
	_ndI := 01
	While _ndI <= 4000
		_ndX := 01
		While _ndX <=4000
			oPrn:Say( _ndI, _ndX, StrZero(_ndI,4)+','+StrZero(_ndX,4) , oFont08,,CLR_HRED)// 1400, CLR_HRED)
			oPrn:Line(_ndI,_ndX,_ndI , _ndX + 40)
			oPrn:Line(_ndI,_ndX,_ndI + 300 , _ndX)
			_ndX += 40
		EndDo
		_ndI += 30
	EndDo
	Return Nil

//************************************************************

Static Function _doCabec()
 Private awDesc := {"", "", "", "", "", ""}

	_ndLin := 030

   _cdMes := Right(Left(dtos(dDataBase),6),2)
	_cdMes := Val(_cdMes) + 00 //-1

	For nI := 01 To 06
		If _cdMes <= 0
			_cdMes := 12
		Else
			_cdMes -= 01 
			iF _cdMes = 0
				_cdMes := 12
			EndIf 
		EndIf
		&("cMes" + StrZero(nI,2)) := "B3_Q" + StrZero(_cdMes,2)      
		
		If _cdMes = 1 
		 		awDesc[nI] := "Janeiro"
			ElseIf _cdMes = 2
		 		awDesc[nI] := "Fevereiro"			
			ElseIf _cdMes = 3
		 		awDesc[nI] := "Março"			
			ElseIf _cdMes = 4
		 		awDesc[nI] := "Abril"			
			ElseIf _cdMes = 5
		 		awDesc[nI] := "Maio"			
			ElseIf _cdMes = 6
		 		awDesc[nI] := "Junho"			
			ElseIf _cdMes = 7
		 		awDesc[nI] := "Julho"
			ElseIf _cdMes = 8
		 		awDesc[nI] := "Agosto"			
			ElseIf _cdMes = 9
		 		awDesc[nI] := "Setembro"			
			ElseIf _cdMes = 10
		 		awDesc[nI] := "Outubro"			
			ElseIf _cdMes = 11
		 		awDesc[nI] := "Novembro"			
			Else
		 		awDesc[nI] := "Dezembro"			
		ENdIf 
	Next
	

	oPrn:Box(_ndLin, 10, 120 ,  3400 )// "-1")
		
	cLogo      	:= "AA_GRF.bmp"
	oPrn:SayBitmap (_ndLin + 10, 30, cLogo, 180, 80)
	    
	oPrn:Say(_ndLin + 00,0250,"Usuario: " + cUserName,oFont07,,,,3)
	oPrn:Say(_ndLin + 30,0250,"Fonte: AAESTR05.PRW",oFont07,,,,3)
        
        
	oPrn:Say(_ndLin + 00,3000,"Emissão: " + dtoc(dDataBase) + " " + substr(Time(), 1, 5),oFont07,,,,3)
	oPrn:Say(_ndLin + 30,3000,"Página : " + strzero(_ndPag,3) ,oFont07)
                
	oPrn:Say( _ndLin + 20 ,1300, "S U G E S T Ã O        D E        P R O D U Ç Ã O ", oFont15n)//, , CLR_HRED)
        
	_ndLin += 100
	aColunas  := {}
	aAdd(aColunas ,0015)
	aAdd(aColunas ,0400)
	aAdd(aColunas ,0550)
	aAdd(aColunas ,1250)
	aAdd(aColunas ,aColunas[Len(aColunas)] + 200) //1350 + 350)
	aAdd(aColunas ,aColunas[Len(aColunas)] + 200)
	aAdd(aColunas ,aColunas[Len(aColunas)] + 200)
	aAdd(aColunas ,aColunas[Len(aColunas)] + 200)
	aAdd(aColunas ,aColunas[Len(aColunas)] + 200)
	aAdd(aColunas ,aColunas[Len(aColunas)] + 200)
	aAdd(aColunas ,aColunas[Len(aColunas)] + 200)
	aAdd(aColunas ,aColunas[Len(aColunas)] + 200)
	aAdd(aColunas ,aColunas[Len(aColunas)] + 200)
        
	oPrn:Say( _ndLin, 2000, "Movimentacao", oFont12n)
		
	oPrn:Say( _ndLin, aColunas[11] + 30, "Total Em", oFont10n)
	oPrn:Say( _ndLin, aColunas[12] + 30, "Consumo", oFont10n)
	oPrn:Say( _ndLin, aColunas[13] + 50, "Sugestao", oFont10n)
        
	_ndLin += 040
		
	oPrn:Say( _ndLin, aColunas[01], "Ferramenta"    , oFont10n)
	oPrn:Say( _ndLin, aColunas[02], "Produto"        , oFont10n)
	oPrn:Say( _ndLin, aColunas[03], "Especificação" , oFont10n)
	oPrn:Say( _ndLin, aColunas[04] + 40, awDesc[1], oFont10n)
	oPrn:Say( _ndLin, aColunas[05] + 40, awDesc[2], oFont10n)
	oPrn:Say( _ndLin, aColunas[06] + 40, awDesc[3], oFont10n)
	oPrn:Say( _ndLin, aColunas[07] + 50, awDesc[4], oFont10n)
	oPrn:Say( _ndLin, aColunas[08] + 50, awDesc[5], oFont10n)
	oPrn:Say( _ndLin, aColunas[09] + 50, awDesc[6], oFont10n)
	oPrn:Say( _ndLin, aColunas[10] + 50, "Saldo" , oFont10n)
	oPrn:Say( _ndLin, aColunas[11] + 50, "Pedidos" , oFont10n)
	oPrn:Say( _ndLin, aColunas[12] + 50, "Medio" , oFont10n)
	oPrn:Say( _ndLin, aColunas[13] + 50, "Producao" , oFont10n)
        
        
	_ndLin += 20

	Return _ndLin

Static Function GetSql()

	Local _cdTbl := GetNextAlias()
	Local _cdQry := ""
	
	cMES01 := ""
	cMES02 := ""
	cMES03 := ""
	cMES04 := ""
	cMES05 := ""
	cMES06 := ""
	          
	/*_cdMes := Right(Left(dtos(dDataBase),6),2)
	_cdMes := Val(_cdMes) - 1
	For nI := 01 To 06
		If _cdMes <= 0
			_cdMes := 12
		Else
			_cdMes -= 01
		EndIf   
		&("cMes" + StrZero(nI,2)) := "B3_Q" + StrZero(_cdMes+iif(_cdMes=0,1,0),2)		
	Next
   
     */
   _cdMes := Right(Left(dtos(dDataBase),6),2)
   _cdMes := Val(_cdMes)+00  //-1
   //alert(_cdMes)
	For nI := 01 To 06
		If _cdMes <= 0
			_cdMes := 12
		Else			
		    _cdMes -= 01 
			iF _cdMes = 0			    
				_cdMes := 12
			EndIf
		EndIf		
		&("cMes" + StrZero(nI,2)) := "B3_Q" + StrZero(_cdMes,2)		
        _cdMes -= 01
        //alert(_cdMes)	      		
	Next
 
	_cdQry += Chr(13) + Chr(10) + " Select B1_FILIAL, "
	_cdQry += Chr(13) + Chr(10) + "        B1_COD   , "
	_cdQry += Chr(13) + Chr(10) + "        ZH_DESC  , B1_YFERRAM,  "
	_cdQry += Chr(13) + Chr(10) + "        B1_GRUPO , "
	_cdQry += Chr(13) + Chr(10) + "        B1_TIPO  , "
	_cdQry += Chr(13) + Chr(10) + "        B1_DESC  , "
	_cdQry += Chr(13) + Chr(10) + "        B1_ESPECIF, "
	_cdQry += Chr(13) + Chr(10) + "        MES01    , "
	_cdQry += Chr(13) + Chr(10) + "        MES02    , "
	_cdQry += Chr(13) + Chr(10) + "        MES03    , "
	_cdQry += Chr(13) + Chr(10) + "        MES04    , "
	_cdQry += Chr(13) + Chr(10) + "        MES05    , "
	_cdQry += Chr(13) + Chr(10) + "        MES06    , "
	_cdQry += Chr(13) + Chr(10) + "        MEDIA    , "
	_cdQry += Chr(13) + Chr(10) + "        _00      , "
	_cdQry += Chr(13) + Chr(10) + "        _01      , "
	_cdQry += Chr(13) + Chr(10) + "        _02      , "
	_cdQry += Chr(13) + Chr(10) + "        B2_QATU  , "
	_cdQry += Chr(13) + Chr(10) + "        PEDIDO   , "
	_cdQry += Chr(13) + Chr(10) + "        Case When ROUND( PEDIDO - B2_QATU + MEDIA,2 ) < 0  "
	_cdQry += Chr(13) + Chr(10) + "             then 0  "
	_cdQry += Chr(13) + Chr(10) + "             else ROUND( PEDIDO - B2_QATU + MEDIA,2 ) "
	_cdQry += Chr(13) + Chr(10) + "        End SUGESTAO "
	_cdQry += Chr(13) + Chr(10) + " from ( "
	_cdQry += Chr(13) + Chr(10) + " 	Select B1_FILIAL, "
	_cdQry += Chr(13) + Chr(10) + " 	isNull(ZH_DESC , '') ZH_DESC, B1_YFERRAM, "
	_cdQry += Chr(13) + Chr(10) + " 		    B1_COD,  "
	_cdQry += Chr(13) + Chr(10) + " 		    B1_DESC, "
	_cdQry += Chr(13) + Chr(10) + " 		    B1_GRUPO, "
	_cdQry += Chr(13) + Chr(10) + " 		    B1_TIPO, "
	_cdQry += Chr(13) + Chr(10) + " 		    B1_ESPECIF, "
	_cdQry += Chr(13) + Chr(10) + " 		    isNull(" + cMES01 + ",0) MES01, "
	_cdQry += Chr(13) + Chr(10) + " 		    isNull(" + cMES02 + ",0) MES02, "
	_cdQry += Chr(13) + Chr(10) + " 		    isNull(" + cMES03 + ",0) MES03, "
	_cdQry += Chr(13) + Chr(10) + " 		    isNull(" + cMES04 + ",0) MES04, "
	_cdQry += Chr(13) + Chr(10) + " 		    isNull(" + cMES05 + ",0) MES05, "
	_cdQry += Chr(13) + Chr(10) + " 		    isNull(" + cMES06 + ",0) MES06, "
	_cdQry += Chr(13) + Chr(10) + "        _00      , "
	_cdQry += Chr(13) + Chr(10) + "        _01      , "
	_cdQry += Chr(13) + Chr(10) + "        _02      , "
	_cdQry += Chr(13) + Chr(10) + " 		    ROUND((" + cMES01 + " + " + cMES02 + " + " + cMES03 + ") / 03,2) MEDIA,  "
	_cdQry += Chr(13) + Chr(10) + " 		    isNull(B2_QATU,0) B2_QATU,  "
	_cdQry += Chr(13) + Chr(10) + " 		    IsNull(SALDO,0) PEDIDO  "
	_cdQry += Chr(13) + Chr(10) + " 	from " + RetSqlName('SB1') + " B1 (nolock) "
	_cdQry += Chr(13) + Chr(10) + " 	Left Outer Join ("
	_cdQry += Chr(13) + Chr(10) + " 	SELECT CM_PRODUTO B3_COD, "
	_cdQry += Chr(13) + Chr(10) + " 	   IsNull([1], 0)  B3_Q01, "
	_cdQry += Chr(13) + Chr(10) + " 	   IsNull([2], 0)  B3_Q02, "
	_cdQry += Chr(13) + Chr(10) + " 	   isNull([3], 0)  B3_Q03, "
	_cdQry += Chr(13) + Chr(10) + " 	   isNull([4], 0)  B3_Q04, "
	_cdQry += Chr(13) + Chr(10) + " 	   isNull([5], 0)  B3_Q05, "
	_cdQry += Chr(13) + Chr(10) + " 	   isNull([6], 0)  B3_Q06, "
	_cdQry += Chr(13) + Chr(10) + " 	   isNull([7], 0)  B3_Q07, "
	_cdQry += Chr(13) + Chr(10) + " 	   isNull([8], 0)  B3_Q08, "
	_cdQry += Chr(13) + Chr(10) + " 	   isNull([9], 0)  B3_Q09, "
	_cdQry += Chr(13) + Chr(10) + " 	   isNull([10], 0) B3_Q10, "
	_cdQry += Chr(13) + Chr(10) + " 	   isNull([11], 0) B3_Q11, "
	_cdQry += Chr(13) + Chr(10) + " 	   isNull([12], 0) B3_Q12 "
	_cdQry += Chr(13) + Chr(10) + " 	FROM   (SELECT CM_PRODUTO, "
	_cdQry += Chr(13) + Chr(10) + " 	               DATEPART(M, CONVERT(DATE, CM_EMISSAO, 112)) CM_MES, "
	_cdQry += Chr(13) + Chr(10) + " 	               Round(sum(CM_QUANT), 2)                     CM_QUANT "
	_cdQry += Chr(13) + Chr(10) + " 	        FROM   (SELECT COALESCE(D3.EMISSAO, D2.EMISSAO, 'N/A')       CM_EMISSAO, "
	_cdQry += Chr(13) + Chr(10) + " 	                       COALESCE(D3.PRODUTO, D2.PRODUTO, 'N/A')       CM_PRODUTO,"
	_cdQry += Chr(13) + Chr(10) + " 	                       COALESCE(D3.QUANT, 0) + COALESCE(D2.QUANT, 0) CM_QUANT"
	_cdQry += Chr(13) + Chr(10) + " 	                FROM   (SELECT D3_EMISSAO    EMISSAO, "
	_cdQry += Chr(13) + Chr(10) + " 	                               D3_COD        PRODUTO, "
	_cdQry += Chr(13) + Chr(10) + " 	                               Sum(D3_QUANT) QUANT "
	_cdQry += Chr(13) + Chr(10) + " 	                        FROM   " + RetSqlName('SD3') + " D3 (Nolock) "
	_cdQry += Chr(13) + Chr(10) + " 	                        WHERE  D3.D_E_L_E_T_ = '' "
  	_cdQry += Chr(13) + Chr(10) + " 	                               AND (D3_TM IN( '501' ) Or D3_CF In('RE7'))"
	_cdQry += Chr(13) + Chr(10) + " 	                               AND D3_ESTORNO = '' "
	_cdQry += Chr(13) + Chr(10) + " 	                               AND D3_DOC NOT IN( 'INVENT' )"
//	_cdQry += Chr(13) + Chr(10) + " 	                               And Convert(date,D3_EMISSAO,112) >  dateadd(year,-1,cast(  cast(datepart(YEAR, GETDATE()) as varchar(4)) + cast(datepart(month, GETDATE()) - 1 as varchar(2)) + '01' as DATE)) "
	_cdQry += Chr(13) + Chr(10) + " 	                               AND Convert(date,D3_EMISSAO,112) >= dateadd(year,-1,cast(  cast(datepart(YEAR, GETDATE()) as varchar(4)) + right('0'+ cast(datepart(month, GETDATE()) as varchar(2)), 2) + '01' as DATE)) "

//_cdQry += Chr(13) + Chr(10) + " 	                               And Convert(date,D3_EMISSAO,112) > dateadd(year,-1,cast(  cast(datepart(YEAR, GETDATE()) as varchar(4)) + cast(datepart(month, GETDATE()) - 1 as varchar(2)) + '01' as DATE)) "
//	_cdQry += Chr(13) + Chr(10) + " 	                               And Convert(date,D3_EMISSAO,112) >= DATEADD(YEAR,-1,CAST(SUBSTRING(CONVERT(VARCHAR(10),GETDATE(),112),1,6)+'01' AS DATE))"

	_cdQry += Chr(13) + Chr(10) + " 	                        GROUP  BY D3_EMISSAO, "
	_cdQry += Chr(13) + Chr(10) + " 	                                  D3_COD, "
	_cdQry += Chr(13) + Chr(10) + " 	                                  D3_LOCAL) D3 "
	_cdQry += Chr(13) + Chr(10) + " 	                       FULL OUTER JOIN (SELECT D2_EMISSAO    EMISSAO, "
	_cdQry += Chr(13) + Chr(10) + " 	                                               D2_COD        PRODUTO, "
	_cdQry += Chr(13) + Chr(10) + " 	                                               Sum(D2_QUANT) QUANT "
	_cdQry += Chr(13) + Chr(10) + " 	                                        FROM   " + RetSqlName('SD2') + " D2 (Nolock) "
	_cdQry += Chr(13) + Chr(10) + " 	                                        WHERE  D2.D_E_L_E_T_ = '' "
	_cdQry += Chr(13) + Chr(10) + " 	                                               AND D2_CF IN ( '5101', '5102', '5116', '5117', "
	_cdQry += Chr(13) + Chr(10) + " 	                                                              '5923', '5122', '5123', '5124', "
	_cdQry += Chr(13) + Chr(10) + " 	                                                              '5125', '5401', '5405', '6101', "
	_cdQry += Chr(13) + Chr(10) + " 	                                                              '6102', '6107', '6108', '6109', "
	_cdQry += Chr(13) + Chr(10) + " 	                                                              '6110', '6116', '6117', '6118', "
	_cdQry += Chr(13) + Chr(10) + " 	                                                              '6119', '6122', '6403' )"
	//_cdQry += Chr(13) + Chr(10) + " 	                                               And Convert(date,D2_EMISSAO,112) > dateadd(year,-1,cast(  cast(datepart(YEAR, GETDATE()) as varchar(4)) + cast(datepart(month, GETDATE()) - 1 as varchar(2)) + '01' as DATE)) "
	//_cdQry += Chr(13) + Chr(10) + " 	                               And Convert(date,D2_EMISSAO,112) >= DATEADD(YEAR,-1,CAST(SUBSTRING(CONVERT(VARCHAR(10),GETDATE(),112),1,6)+'01' AS DATE))"
	_cdQry += Chr(13) + Chr(10) + " 	                                               AND Convert(date,D2_EMISSAO,112) >= dateadd(year,-1,cast(  cast(datepart(YEAR, GETDATE()) as varchar(4)) + right('0'+ cast(datepart(month, GETDATE()) as varchar(2)), 2) + '01' as DATE)) "
	
	_cdQry += Chr(13) + Chr(10) + " 	                                        GROUP  BY D2_EMISSAO, "
	_cdQry += Chr(13) + Chr(10) + " 	                                                  D2_COD) D2 "
	_cdQry += Chr(13) + Chr(10) + " 	                                    ON D2.EMISSAO = D3.EMISSAO "
	_cdQry += Chr(13) + Chr(10) + " 	                                       AND D2.PRODUTO = D3.PRODUTO)CM"
	_cdQry += Chr(13) + Chr(10) + " 	        GROUP  BY CM_PRODUTO, "
	_cdQry += Chr(13) + Chr(10) + " 	                  DATEPART(M, CONVERT(DATE, CM_EMISSAO, 112)))A"
	_cdQry += Chr(13) + Chr(10) + " 	       PIVOT ( SUM(CM_QUANT) "
	_cdQry += Chr(13) + Chr(10) + " 	             FOR CM_MES IN([1],[2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12]) ) AS PVT "
	_cdQry += Chr(13) + Chr(10) + " ) B3 ON B1_COD = B3_COD "

//Pegando Informações de Saldo (SB2)
	_cdQry += Chr(13) + Chr(10) + " 	Left Outer Join (
	/*
	_cdQry += Chr(13) + Chr(10) + " 					  Select B2_FILIAL,
	_cdQry += Chr(13) + Chr(10) + " 							  B2_COD,
	_cdQry += Chr(13) + Chr(10) + " 							  SUM(B2_QATU) B2_QATU
	_cdQry += Chr(13) + Chr(10) + " 					   from " + RetSqlName('SB2') + " (NOLOCK) "
	_cdQry += Chr(13) + Chr(10) + " 					   where D_E_L_E_T_ = ''                 "
	_cdQry += Chr(13) + Chr(10) + " 						  and B2_LOCAL BetWeen '" + mv_par07 + "' and '" + mv_par08  + "' "
	_cdQry += Chr(13) + Chr(10) + " 					   GROUP BY B2_FILIAL,B2_COD             "
	*/
	_cdQry += Chr(13) + Chr(10) + "                        Select B2_COD, "
	_cdQry += Chr(13) + Chr(10) + "                            isNull([00],0) '_00', IsNull([01],0) '_01' ,IsNull([02],0) '_02' , "
	_cdQry += Chr(13) + Chr(10) + "                            isNull([00],0) + isNull([01],0) + isNull([02],0) B2_QATU  "
	_cdQry += Chr(13) + Chr(10) + "                         from ( "
	_cdQry += Chr(13) + Chr(10) + "                         Select B2_FILIAL, "
	_cdQry += Chr(13) + Chr(10) + "                          B2_COD, "
	_cdQry += Chr(13) + Chr(10) + "                          SUM(B2_QATU) B2_QATU "
	_cdQry += Chr(13) + Chr(10) + "                         from " + RetSqlName('SB2') + " (NOLOCK)  "
	_cdQry += Chr(13) + Chr(10) + "                         where D_E_L_E_T_ = ''"
	_cdQry += Chr(13) + Chr(10) + " 						      And B2_LOCAL BetWeen '" + mv_par07 + "' and '" + mv_par08  + "' "
	_cdQry += Chr(13) + Chr(10) + "                            AND B2_FILIAL In('01','02','00') "
	_cdQry += Chr(13) + Chr(10) + "                         GROUP BY B2_FILIAL,B2_COD  "
	_cdQry += Chr(13) + Chr(10) + "                         )A PIVOT ( SUM(B2_QATU) FOR B2_FILIAL IN([00],[01],[02],[03],[04],[05]) )AS PVT "
	_cdQry += Chr(13) + Chr(10) + " 					)B2 on B2_COD = B1_COD       "
	//_cdQry += Chr(13) + Chr(10) + " 					   

//Pegando Informações de Pedidos de Compras
	_cdQry += Chr(13) + Chr(10) + " 	Left Outer Join (                                  "
	_cdQry += Chr(13) + Chr(10) + " 					 SELECT  "
	_cdQry += Chr(13) + Chr(10) + " 					        C6_PRODUTO,               	   "
	_cdQry += Chr(13) + Chr(10) + " 					        Sum(C6_QTDVEN - C6_QTDENT) SALDO       "
	_cdQry += Chr(13) + Chr(10) + " 					 FROM " + RetSqlName('SC6') + " C6 (nolock)  "
	_cdQry += Chr(13) + Chr(10) + " 					 Where D_E_L_E_T_ = ''                 "
	_cdQry += Chr(13) + Chr(10) + " 					   And C6_QTDVEN - C6_QTDENT > 0 AND C6_BLQ <> 'R'"
	_cdQry += Chr(13) + Chr(10) + " 					   AND C6_FILIAL In('01','02','00')                "
	_cdQry += Chr(13) + Chr(10) + " 					   AND C6_LOCAL NOT In('10','22')      "//Alterado por Solicitação Francisco, 11/05/2020 -Williams Messa	
	_cdQry += Chr(13) + Chr(10) + " 	                 GROUP BY C6_PRODUTO "
	_cdQry += Chr(13) + Chr(10) + " 					 )C6 On C6_PRODUTO = B1_COD            "
	_cdQry += Chr(13) + Chr(10) + " Left Outer Join " + RetSqlName('SZH') + " ZH (nolock) ON ZH_COD = B1_YFERRAM AND ZH.D_E_L_E_T_ = '' "
//
	_cdQry += Chr(13) + Chr(10) + " 	where B1.D_E_L_E_T_ = ''                           "
	_cdQry += Chr(13) + Chr(10) + " 	And B1_COD   BetWeen '" + mv_par01 + "' And '"  + mv_par02 + "' "
	_cdQry += Chr(13) + Chr(10) + " 	And B1_GRUPO BetWeen '" + mv_par03 + "' And '"  + mv_par04 + "' "
	_cdQry += Chr(13) + Chr(10) + " 	And B1_TIPO  BetWeen '" + mv_par05 + "' And '"  + mv_par06 + "' "
	_cdQry += Chr(13) + Chr(10) + " And ZH_COD BetWeen '" + mv_par12 + "' And '" + mv_par13 + "'"
	_cdQry += Chr(13) + Chr(10) + " And B1_FILIAL = '" + xFilial('SB1') + "' "
	_cdQry += Chr(13) + Chr(10) + " AND B1_MSBLQL!='1' "
	_cdQry += Chr(13) + Chr(10) + " )A "
	_cdQry += Chr(13) + Chr(10) + " order by B1_YFERRAM, B1_ESPECIF "
	Memowrite('AACOMR03.SQL',_cdQry)

	dbUseArea(.T., "TOPCONN", tcGenQry(,,_cdQry), _cdTbl , .T., .T.)

	Return _cdTbl

	Static Function ValidPerg(cPerg)

	PutSX1(cPerg,"01","Produto de   	 ?", "", "", "mv_ch1", "C", 18, 0, 0, "G","","SB1","","","mv_par01")
	PutSX1(cPerg,"02","Produto ate  	 ?", "", "", "mv_ch2", "C", 18, 0, 0, "G","","SB1","","","mv_Par02")
	PutSX1(cPerg,"03","Grupo de   	 ?", "", "", "mv_ch3", "C", 04, 0, 0, "G","","SBM","","","mv_par03")
	PutSX1(cPerg,"04","Grupo ate  	 ?", "", "", "mv_ch4", "C", 04, 0, 0, "G","","SBM","","","mv_Par04")
	PutSX1(cPerg,"05","Tipo de 	    ?", "", "", "mv_ch5", "C", 02, 0, 0, "G","","02 ","","","mv_par05")
	PutSX1(cPerg,"06","Tipo ate	    ?", "", "", "mv_ch6", "C", 02, 0, 0, "G","","02 ","","","Mv_Par06")
	PutSX1(cPerg,"07","Armazen de 	 ?", "", "", "mv_ch5", "C", 02, 0, 0, "G","","AL ","","","mv_par07")
	PutSX1(cPerg,"08","Armazen ate	 ?", "", "", "mv_ch6", "C", 02, 0, 0, "G","","AL ","","","Mv_Par08")

	PutSX1(cPerg,"09","Diretório  	 ?", "", "", "mv_chb", "C", 99, 0, 0, "G","","DIR_AA","","","mv_par09")
	PutSX1(cPerg,"10","Nome do Arquivo  ?", "", "", "mv_chc", "C", 99, 0, 0, "G","","   ","","","Mv_Par10")
	
	PutSX1(cPerg,"11","Exporta p/ Excel?", "", "", "mv_chc", "N", 1, 0, 0, "C","","   ","","","Mv_Par11",'SIM','','','','NAO')
    
	PutSX1(cPerg,"12","Ferramenta de 	 ?", "", "", "mv_ch5", "C", 03, 0, 0, "G","","SZH","","","mv_par12")
	PutSX1(cPerg,"13","Ferramenta ate	 ?", "", "", "mv_ch6", "C", 03, 0, 0, "G","","SZH","","","Mv_Par13")
    
	Return Nil
