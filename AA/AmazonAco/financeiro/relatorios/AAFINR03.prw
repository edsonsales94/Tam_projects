#Include 'Protheus.ch'

User Function AAFINR03()
	Local _adSomas   := {0,0}
	Local _adTotal   := {0,0}
	Private cPerg    := Padr('AAFINR03',Len(SX1->X1_GRUPO))
	Private aColunas := {}

	PRIVATE oFont10N   := TFont():New("Times New Roman",08,08, ,.T., , , , , .F.,.F.)// 1

	PRIVATE oFont07N   := TFont():New("Times New Roman",06,06, ,.T., , , , , .F.,.F.)// 2
	PRIVATE oFont07    := TFont():New("Times New Roman",06,06, ,.F., , , , , .F.,.F.)// 3
	PRIVATE oFont07C   := TFont():New("Courier New"   ,06,06, ,.F., , , , , .F.,.F.)// 3

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
	PRIVATE cVends      := ""

	ValidPerg(cPerg)
	Private _ndPag := 001
	If Pergunte(cPerg,.T.)
	
		oPrn := TMSPrinter():New("AAESTR05.REL")//, , .F., , .F.)// Ordem obrigátoria de configuração do relatório
	//oPrn:SetResolution(72)
	//oPrn:SetPaperSize(DMPAPER_A4)
	//oPrn:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior
		oPrn:Setup()
	//oPrn:cPathPDF:="c:\bkp_drv"
	//oPrn:SetLandScape()
	//oPrn:SetLandScape()
	//_ndLin := _doCabec(.T.)
	
		_cdTbl := getSql(mv_par05)
		_adSomas := {0,0}
		If !(_cdTbl)->(Eof())
		
			oPrn:StartPage()
			cVends := (_cdTbl)->A3_COD + "-" + (_cdTbl)->A3_NOME
			_ndLin := _doCabec(mv_par05)
			_ndLin += 30
			oPrn:Line(_ndLin,010,_ndLin , 2200 )//,,"-4")
			While !(_cdTbl)->(Eof())
			
				If mv_par05 == 01 // Analitico
				//atualiza o subtotal
					_adSomas[1] += (_cdTbl)->VALOR
					_adSomas[2] += (_cdTbl)->COMISSAO
				
				//imprime
				//oPrn:Say( _ndLin, aColunas[01] -20 , Transform( (_cdTbl)->A3_COMIS ,"@E 999,999.99")  , oFont07C)
					oPrn:Say( _ndLin, aColunas[02]     , (_cdTbl)->E5_NUMERO + "-" + (_cdTbl)->E5_PREFIXO  + iIF(Empty(Alltrim((_cdTbl) ->E5_PARCELA)),"" ," / " + (_cdTbl)->E5_PARCELA) , oFont07C)
					oPrn:Say( _ndLin, aColunas[03]     , (_cdTbl)->E1_NOMCLI                              , oFont07c)
					oPrn:Say( _ndLin, aColunas[04]     , DTOC(STOD((_cdTbl)->E5_DATA))                    , oFont07c)
					oPrn:Say( _ndLin, aColunas[05]     , (_cdTbl)->E5_DOCUMEN                             , oFont07c)
					oPrn:Say( _ndLin, aColunas[06]     , (_cdTbl)->D1_DOC + "-" +(_cdTbl)->D1_SERIE       , oFont07C)
					oPrn:Say( _ndLin, aColunas[07] -20 , Transform((_cdTbl)->VALOR,"@E 999,999,999.99")   , oFont07c)
					oPrn:Say( _ndLin, aColunas[08]     , (_cdTbl)->DOC_DEV + "-" + (_cdTbl)->SER_DEV      , oFont07C)
					oPrn:Say( _ndLin, aColunas[09] -20 , Transform((_cdTbl)->COMISSAO,"@E 999,999,999.99"), oFont07c)
					oPrn:Say( _ndLin, aColunas[10] -20 , Transform((_cdTbl)->A3_COMIS,"@E 999.99 %")      , oFont07c)
				
				Else
				
				//imprime
				
					_adSomas[1] += (_cdTbl)->VALOR
					_adSomas[2] += (_cdTbl)->COMISSAO
				
					oPrn:Say( _ndLin, aColunas[01], (_cdTbl)->A3_COD   , oFont07)
					oPrn:Say( _ndLin, aColunas[02], (_cdTbl)->A3_NOME  , oFont07)
					oPrn:Say( _ndLin, aColunas[03] - 20, Transform( (_cdTbl)->A3_COMIS ,"@E 999,999.99")  , oFont07C)
					oPrn:Say( _ndLin, aColunas[04] - 50, Transform((_cdTbl)->VALOR,"@E 999,999,999.99")   , oFont07c)
					oPrn:Say( _ndLin, aColunas[05] - 50, Transform((_cdTbl)->COMISSAO,"@E 999,999,999.99"), oFont07c)
					_adTotal[01] := _adSomas[01]
		            _adTotal[02] := _adSomas[02]
				EndIf
			
			//oPrn:Line(_ndLin,010,_ndLin , 3400 )
				(_cdTbl)->(dbSkip())
				_ndLin += 45
						
			//criterios quebra de pagina
				If _ndLin > 2800 .OR. (cVends <> (_cdTbl)->A3_COD + "-" + (_cdTbl)->A3_NOME .AND. MV_PAR05 = 1)
				
					oPrn:Line(_ndLin,010,_ndLin , 3400 )//,,"-4")
				//imprime o total do vendedor na forma analitica
					If cVends <> (_cdTbl)->A3_COD + "-" + (_cdTbl)->A3_NOME .AND. MV_PAR05 = 1
						_ndLin += 25
						
						_adTotal[01] += _adSomas[01]
		                _adTotal[02] += _adSomas[02]
		            
						oPrn:Say( _ndLin, aColunas[01]     , "SubTotal"  , oFont09N)
						oPrn:Say( _ndLin, aColunas[06] -50 , Transform(_adSomas[1],"@E 999,999,999.99")   , oFont09c)
						oPrn:Say( _ndLin, aColunas[08] -50 , Transform(_adSomas[2],"@E 999,999,999.99")   , oFont09c)
						_adSomas := {0,0}
					EndIf
				//atualiza o flag de quebra
					cVends := (_cdTbl)->A3_COD + "-" + (_cdTbl)->A3_NOME
					oPrn:EndPage()
				
					If !(_cdTbl)->(Eof())
					//inicia nova folha
						oPrn:StartPage()
						_ndPag++
						oPrn:StartPage()
						_ndLin := _doCabec(mv_par05)
						_ndLin += 30
						oPrn:Line(_ndLin,010,_ndLin , 2200 )//,,"-4")
					EndIf
				Else
									
				EndIF
			
			EndDo
			
			_ndLin += 25
			oPrn:Say( _ndLin, aColunas[01]     , "Total --> "  , oFont09N)
			oPrn:Say( _ndLin, aColunas[04] -50 , Transform(_adTotal[1],"@E 999,999,999.99")   , oFont09c)
			oPrn:Say( _ndLin, aColunas[05] -50 , Transform(_adTotal[2],"@E 999,999,999.99")   , oFont09c)
			_adSomas := {0,0}
					
			oPrn:Preview()
		EndIF
	
	EndIf


	Return

Static FUnction ValidPerg(cPerg)
	PutSX1(cPerg,"01","Vendedor de   	 ?", "", "", "mv_ch1", "C", 06, 0, 0, "G","","SA3","","","mv_par01")
	PutSX1(cPerg,"02","Vendedor Ate   	 ?", "", "", "mv_ch2", "C", 06, 0, 0, "G","","SA3","","","mv_par02")

	PutSX1(cPerg,"03","Data Baixa de   	 ?", "", "", "mv_ch3", "D", 08, 0, 0, "G","","   ","","","mv_par03")
	PutSX1(cPerg,"04","Data Baixa Ate 	 ?", "", "", "mv_ch4", "D", 08, 0, 0, "G","","   ","","","mv_par04")

	PutSX1(cPerg,"05","Tipo do Relatorio ?", "", "", "mv_ch5", "N", 01, 0, 0, "C","","   ","","","mv_par05",'Analitico','','','','Sintetico')
	//PutSX1(cPerg,"05","Tipo de Vendedor  ?", "", "", "mv_ch5", "N", 01, 0, 0, "C","","   ","","","mv_par05",'Interno','','','','Externo','','','Loja')

	Return

Static Function _doCabec(_ndTipo)
	_ndLin := 030


	oPrn:Box(_ndLin, 10, 120 ,  3400 )// "-1")

	cLogo      	:= "AA_GRF.bmp"
	oPrn:SayBitmap (_ndLin + 10, 30, cLogo, 180, 80)

	oPrn:Say(_ndLin + 00,0250,"Usuario: " + cUserName,oFont07,,,,3)
	oPrn:Say(_ndLin + 30,0250,"Fonte: AAFINR03.PRW",oFont07,,,,3)


	oPrn:Say(_ndLin + 00,2200,"Emissão: " + dtoc(dDataBase) + " " + substr(Time(), 1, 5),oFont07,,,,3)
	oPrn:Say(_ndLin + 30,2324,"Página : " + strzero(_ndPag,3) ,oFont07)

	oPrn:Say( _ndLin + 20 ,700, "R E L A T O R I O        D E        C O M I S S Õ E S", oFont15n)//, , CLR_HRED)

	_ndLin += 100
	aColunas  := {}

	If _ndTipo == 01 // Analitico
		oPrn:Say( _ndLin, 0010 ,cVends        , oFont10n)
		_ndLin += 50
		oPrn:Line(_ndLin,010,_ndLin , 2200 )//,,"-4")
		_ndLin += 20
	
		aAdd(aColunas ,0015) //% COMISSAO
		aAdd(aColunas ,0015) //NF aColunas[Len(aColunas)] + 250
		aAdd(aColunas ,aColunas[Len(aColunas)] + 250) //CLIENTE
		aAdd(aColunas ,aColunas[Len(aColunas)] + 300) //DATA
		aAdd(aColunas ,aColunas[Len(aColunas)] + 200) //DOCUMENTO
		aAdd(aColunas ,aColunas[Len(aColunas)] + 300) //NF ENT
		aAdd(aColunas ,aColunas[Len(aColunas)] + 250) //VALOR
		aAdd(aColunas ,aColunas[Len(aColunas)] + 250) //NF DEV
		aAdd(aColunas ,aColunas[Len(aColunas)] + 250) //COMISSAO
		aAdd(aColunas ,aColunas[Len(aColunas)] + 250) //COMISSAO

	
	//oPrn:Say( _ndLin, aColunas[01] , "% Comis"      , oFont10n)
		oPrn:Say( _ndLin, aColunas[02] , "NF - SERIE / PARC"             , oFont10n)
		oPrn:Say( _ndLin, aColunas[03] , "Cliente"        , oFont10n)
		oPrn:Say( _ndLin, aColunas[04] , "Data"           , oFont10n)
		oPrn:Say( _ndLin, aColunas[05] , "Documento"      , oFont10n)
		oPrn:Say( _ndLin, aColunas[06] , "NF Ent"         , oFont10n)
		oPrn:Say( _ndLin, aColunas[07] , "Valor"          , oFont10n)
		oPrn:Say( _ndLin, aColunas[08] , "NF Dev"         , oFont10n)
		oPrn:Say( _ndLin, aColunas[09] , "Comissao"       , oFont10n)
		oPrn:Say( _ndLin, aColunas[10] , "% Comissao"     , oFont10n)
	
	Elseif _ndTipo == 02
	
		aAdd(aColunas ,0015) // VENDEDOR
		aAdd(aColunas ,aColunas[Len(aColunas)] + 200) //NOME VENDEDOR
		aAdd(aColunas ,aColunas[Len(aColunas)] + 800) //% COMISSAO
		aAdd(aColunas ,aColunas[Len(aColunas)] + 300) //TOTAL BASE
		aAdd(aColunas ,aColunas[Len(aColunas)] + 300) //VALOR COMISSAO
	
		oPrn:Say( _ndLin, aColunas[01] , "Vendedor"     , oFont10n)
		oPrn:Say( _ndLin, aColunas[02] , "Nome "        , oFont10n)
		oPrn:Say( _ndLin, aColunas[03] , "% Comis"      , oFont10n)
		oPrn:Say( _ndLin, aColunas[04] , "Total Base"   , oFont10n)
		oPrn:Say( _ndLin, aColunas[05] , "Total Comissao" , oFont10n)
	
	EndIF

	_ndLin += 20

	Return _ndLin

Static Function proProcedure(_cTipo)
	_cdName := 'GETCOMISSAO'+cEmpAnt + _cTipo
	_cdSql := " "

	if !TCSPExist(_cdName)
		_cdSql +=                       "	Create Procedure " + _cdName + " @EmiFrom Varchar(8), "
		_cdSql += Chr(13) + Chr(10) + "                              @EmiTo Varchar(8)   = '',
		_cdSql += Chr(13) + Chr(10) + "                              @VenFrom Varchar(6) = '',
		_cdSql += Chr(13) + Chr(10) + "                              @VenTo Varchar(6)   = '',
		_cdSql += Chr(13) + Chr(10) + "                              @cdTipo Varchar(01) = '  '
		_cdSql += Chr(13) + Chr(10) + "As
	/*
	--Declare @EmiFrom Varchar(8)
	--Declare @EmiTo   Varchar(8)
	--Declare @VenFrom Varchar(6)
	--Declare @VenTo   Varchar(6)
	
	--Set @EmiFrom = '20130901'
	--Set @EmiTo   = '20130931'
	--Set @VenFrom = '000007'
	--Set @VenTo   = '000007'
	*/
		_cdSql += Chr(13) + Chr(10) + "SELECT
		_cdSql += Chr(13) + Chr(10) + "   *
		_cdSql += Chr(13) + Chr(10) + "FROM (
		_cdSql += Chr(13) + Chr(10) + " SELECT
		If _cTipo == 'A'
			_cdSql += Chr(13) + Chr(10) + " A3_COD,A3_NOME,A3_COMIS,E5_NUMERO,E5_PREFIXO,E5_DATA,ISNULL(E5_PARCELA,'') E5_PARCELA,ISNULL(E5_RECPAG,'') E5_RECPAG,E5_DOCUMEN,isNull(D1_DOC,'') D1_DOC ,isNull(D1_SERIE,'') D1_SERIE,isNull(E5_VALOR,0) - isNull(DEV,0) VALOR , IsNull(DOC_DEV,'') DOC_DEV,isNull(SER_DEV,'') SER_DEV, ((isNUll(E5_VALOR,0)-isnull(DEV,0))*A3_COMIS/100) COMISSAO
		Else
			_cdSql += Chr(13) + Chr(10) + " A3_COD,A3_NOME,A3_COMIS,SUM(isNull(E5_VALOR,0) - isnull(DEV,0)) VALOR ,SUM((isNUll(E5_VALOR,0)-isnull(DEV,0))*A3_COMIS/100) COMISSAO "
		EndIf
	//
		_cdSql += Chr(13) + Chr(10) + " FROM   (
		_cdSql += Chr(13) + Chr(10) + "         SELECT COALESCE(AA.E1_VEND1, DV.VEND)         E1_VEND1,
		_cdSql += Chr(13) + Chr(10) + "                E.A3_COD,
		_cdSql += Chr(13) + Chr(10) + "                E.A3_NOME,
		_cdSql += Chr(13) + Chr(10) + "                E.A3_COMIS,
		_cdSql += Chr(13) + Chr(10) + "                E5_DOCUMEN,
		_cdSql += Chr(13) + Chr(10) + "                E5_RECPAG,
		_cdSql += Chr(13) + Chr(10) + "                COALESCE(AA.E5_NUMERO, DV.E1_NUM)      E5_NUMERO,
		_cdSql += Chr(13) + Chr(10) + "                COALESCE(AA.E5_PREFIXO, DV.E1_PREFIXO) E5_PREFIXO,
		_cdSql += Chr(13) + Chr(10) + "                COALESCE(AA.E5_PARCELA, '')            E5_PARCELA,
		_cdSql += Chr(13) + Chr(10) + "                COALESCE(AA.E1_NOMCLI, DV.A1_NOME)     E1_NOMCLI,
		_cdSql += Chr(13) + Chr(10) + "                COALESCE(AA.E5_CLIFOR, DV.F2_CLIENTE)  E5_CLIFOR,
		_cdSql += Chr(13) + Chr(10) + "                COALESCE(AA.E5_LOJA, DV.F2_LOJA)       E5_LOJA,
		_cdSql += Chr(13) + Chr(10) + "                COALESCE(AA.E5_MOTBX, 'NOR')           E5_MOTBX,
		_cdSql += Chr(13) + Chr(10) + "                COALESCE(AA.E5_DATA, DV.E1_EMISSAO)    E5_DATA,
		_cdSql += Chr(13) + Chr(10) + " 			   DEV.*,
		_cdSql += Chr(13) + Chr(10) + " 			   'zzzzzzz' A3_DTEMIS,
		_cdSql += Chr(13) + Chr(10) + " 			   F.A3_COD VORIG,
		_cdSql += Chr(13) + Chr(10) + " 			   DV.DOC_DEV,
		_cdSql += Chr(13) + Chr(10) + " 			   DV.SER_DEV,
		_cdSql += Chr(13) + Chr(10) + " 			   E5_VALOR,DEV
		_cdSql += Chr(13) + Chr(10) + "         FROM   (SELECT E1_VEND1,
		_cdSql += Chr(13) + Chr(10) + "                        E5_NUMERO,
		_cdSql += Chr(13) + Chr(10) + "                        E5_PREFIXO,
		_cdSql += Chr(13) + Chr(10) + "                        E5_PARCELA,
		_cdSql += Chr(13) + Chr(10) + "                        E5_CLIFOR,
		_cdSql += Chr(13) + Chr(10) + "                        E1_NOMCLI,
		_cdSql += Chr(13) + Chr(10) + "                        E5_RECPAG,
		_cdSql += Chr(13) + Chr(10) + "                        E5_LOJA,
		_cdSql += Chr(13) + Chr(10) + "                        E5_MOTBX,
		_cdSql += Chr(13) + Chr(10) + "                        E1_VALOR,
		_cdSql += Chr(13) + Chr(10) + "                        E5_DOCUMEN,
		_cdSql += Chr(13) + Chr(10) + "                        E5_DATA,
		_cdSql += Chr(13) + Chr(10) + "                        Sum(CASE
		_cdSql += Chr(13) + Chr(10) + "                              WHEN E5_TIPODOC IN ( 'JR' ) THEN E5_VALOR *- 1
		_cdSql += Chr(13) + Chr(10) + "                              ELSE E5_VALOR
		_cdSql += Chr(13) + Chr(10) + "                            END) E5_VALOR
		_cdSql += Chr(13) + Chr(10) + "                 FROM   SE5010 A with (NOLOCK)
		_cdSql += Chr(13) + Chr(10) + "                        LEFT JOIN SE1010 B with (NOLOCK)
		_cdSql += Chr(13) + Chr(10) + "                               ON B.D_E_L_E_T_ = ''
		_cdSql += Chr(13) + Chr(10) + "                                  AND A.E5_NUMERO = B.E1_NUM
		_cdSql += Chr(13) + Chr(10) + "                                  AND A.E5_PREFIXO = B.E1_PREFIXO
		_cdSql += Chr(13) + Chr(10) + "                                  AND A.E5_PARCELA = B.E1_PARCELA
		_cdSql += Chr(13) + Chr(10) + "                                  AND A.E5_CLIFOR = B.E1_CLIENTE
		_cdSql += Chr(13) + Chr(10) + "                                  AND A.E5_LOJA = B.E1_LOJA
		_cdSql += Chr(13) + Chr(10) + "                                  AND A.E5_TIPO = B.E1_TIPO
		_cdSql += Chr(13) + Chr(10) + "                                  And A.E5_VALOR != 0
		_cdSql += Chr(13) + Chr(10) + "                                  AND B.E1_VEND1 BETWEEN @VenFrom AND @VenTo
		_cdSql += Chr(13) + Chr(10) + "                 WHERE  A.D_E_L_E_T_ = ''
		_cdSql += Chr(13) + Chr(10) + "                        AND E5_NUMERO <> ''
		_cdSql += Chr(13) + Chr(10) + "                        And E5_VALOR > 0
		_cdSql += Chr(13) + Chr(10) + "                        AND E5_DATA BETWEEN @EmiFrom AND @EmiTo
		_cdSql += Chr(13) + Chr(10) + "                        AND E1_EMISSAO >= '20130901'
		_cdSql += Chr(13) + Chr(10) + "                        And E5_VALOR != 0
		_cdSql += Chr(13) + Chr(10) + "                        AND E5_RECPAG = 'R'
		_cdSql += Chr(13) + Chr(10) + "                        AND E1_VEND1 IS NOT NULL
		_cdSql += Chr(13) + Chr(10) + "                        AND E1_TIPO NOT IN( 'NCC', 'RA' )
		_cdSql += Chr(13) + Chr(10) + "                 GROUP  BY E1_VEND1,
		_cdSql += Chr(13) + Chr(10) + "                           E5_RECPAG,
		_cdSql += Chr(13) + Chr(10) + "                           E5_DATA,
		_cdSql += Chr(13) + Chr(10) + "                           E5_NUMERO,
		_cdSql += Chr(13) + Chr(10) + "                           E5_PREFIXO,
		_cdSql += Chr(13) + Chr(10) + "                           E5_PARCELA,
		_cdSql += Chr(13) + Chr(10) + "                           E5_CLIFOR,
		_cdSql += Chr(13) + Chr(10) + "                           E5_DATA,
		_cdSql += Chr(13) + Chr(10) + "                           E1_NOMCLI,
		_cdSql += Chr(13) + Chr(10) + "                           E5_LOJA,
		_cdSql += Chr(13) + Chr(10) + "                           E5_MOTBX,
		_cdSql += Chr(13) + Chr(10) + "                           E1_VALOR,
		_cdSql += Chr(13) + Chr(10) + "                           E5_DOCUMEN
		_cdSql += Chr(13) + Chr(10) + "                 UNION
		_cdSql += Chr(13) + Chr(10) + "                 SELECT
		_cdSql += Chr(13) + Chr(10) + "                        E1_VEND1,
		_cdSql += Chr(13) + Chr(10) + "                        E5_NUMERO,
		_cdSql += Chr(13) + Chr(10) + "                        E5_PREFIXO,
		_cdSql += Chr(13) + Chr(10) + "                        E5_PARCELA,
		_cdSql += Chr(13) + Chr(10) + "                        E5_CLIFOR,
		_cdSql += Chr(13) + Chr(10) + "                        E1_NOMCLI,
		_cdSql += Chr(13) + Chr(10) + "                        E5_RECPAG,
		_cdSql += Chr(13) + Chr(10) + "                        E5_LOJA,
		_cdSql += Chr(13) + Chr(10) + "                        E5_MOTBX,
		_cdSql += Chr(13) + Chr(10) + "                        E1_VALOR,
		_cdSql += Chr(13) + Chr(10) + "                        E5_DOCUMEN,
		_cdSql += Chr(13) + Chr(10) + "                        E5_DATA,
		_cdSql += Chr(13) + Chr(10) + "                        E5_VALOR * -1
		_cdSql += Chr(13) + Chr(10) + "                 FROM   SE5010 C with (NOLOCK)
		_cdSql += Chr(13) + Chr(10) + "                        INNER JOIN SE1010 D
		_cdSql += Chr(13) + Chr(10) + "                                ON C.D_E_L_E_T_ = ''
		_cdSql += Chr(13) + Chr(10) + "                                   AND C.E5_NUMERO = D.E1_NUM
		_cdSql += Chr(13) + Chr(10) + "                                   And E5_VALOR > 0
		_cdSql += Chr(13) + Chr(10) + "                                   AND C.E5_PREFIXO = D.E1_PREFIXO
		_cdSql += Chr(13) + Chr(10) + "                                   AND C.E5_PARCELA = D.E1_PARCELA
		_cdSql += Chr(13) + Chr(10) + "                                   AND C.E5_CLIFOR = D.E1_CLIENTE
		_cdSql += Chr(13) + Chr(10) + "                                   AND C.E5_LOJA = D.E1_LOJA
		_cdSql += Chr(13) + Chr(10) + "                                   And C.E5_VALOR != 0
		_cdSql += Chr(13) + Chr(10) + "                                   AND C.E5_TIPO = D.E1_TIPO
		_cdSql += Chr(13) + Chr(10) + "                                   AND D.E1_VEND1 <> ''
		_cdSql += Chr(13) + Chr(10) + "                 WHERE  C.D_E_L_E_T_ = ''
		_cdSql += Chr(13) + Chr(10) + "                        AND C.E5_NUMERO <> ''
		_cdSql += Chr(13) + Chr(10) + "                        AND E5_DATA BETWEEN @EmiFrom AND @EmiTo
		_cdSql += Chr(13) + Chr(10) + "                        AND E5_RECPAG = 'P')AA
	
		_cdSql += Chr(13) + Chr(10) + "                FULL OUTER JOIN (SELECT D1_NFORI                 E1_NUM,
		_cdSql += Chr(13) + Chr(10) + "                                        D1_SERIORI               E1_PREFIXO,
		_cdSql += Chr(13) + Chr(10) + "                                        D1_DOC   DOC_DEV,
		_cdSql += Chr(13) + Chr(10) + "                                        D1_SERIE SER_DEV,
		_cdSql += Chr(13) + Chr(10) + "                                        E1_EMISSAO,
		_cdSql += Chr(13) + Chr(10) + "                                        VEND,
		_cdSql += Chr(13) + Chr(10) + "                                        F2_CLIENTE,
		_cdSql += Chr(13) + Chr(10) + "                                        F2_LOJA,
		_cdSql += Chr(13) + Chr(10) + "                                        A1_NOME,
		_cdSql += Chr(13) + Chr(10) + "                                        Isnull(Sum(E1_VALOR), 0) DEV
		_cdSql += Chr(13) + Chr(10) + "                                 FROM   (SELECT DISTINCT D1_DOC,
		_cdSql += Chr(13) + Chr(10) + "                                                         D1_SERIE,
		_cdSql += Chr(13) + Chr(10) + "                                                         D1_FORNECE,
		_cdSql += Chr(13) + Chr(10) + "                                                         D1_LOJA,
		_cdSql += Chr(13) + Chr(10) + "                                                         D1_NFORI,
		_cdSql += Chr(13) + Chr(10) + "                                                         D1_SERIORI
		_cdSql += Chr(13) + Chr(10) + "                                         FROM   SD1010 with (NOLOCK)
		_cdSql += Chr(13) + Chr(10) + "                                         WHERE  D_E_L_E_T_ = ''
		_cdSql += Chr(13) + Chr(10) + "                                                AND D1_TIPO = 'D'
		_cdSql += Chr(13) + Chr(10) + "                                                AND D1_EMISSAO BETWEEN @EmiFrom AND @EmiTo
		_cdSql += Chr(13) + Chr(10) + "                                                AND D1_NFORI != ' '
		_cdSql += Chr(13) + Chr(10) + "                                                AND D1_SERIORI != ' ')A
		_cdSql += Chr(13) + Chr(10) + "                                        LEFT OUTER JOIN SE1010  E1 with (NOLOCK)
		_cdSql += Chr(13) + Chr(10) + "                                                     ON E1_NUM = D1_DOC
		_cdSql += Chr(13) + Chr(10) + "                                                        AND E1_PREFIXO = D1_SERIE
		_cdSql += Chr(13) + Chr(10) + "                                                        AND E1_CLIENTE = D1_FORNECE
		_cdSql += Chr(13) + Chr(10) + "                                                        AND E1_LOJA = D1_LOJA
		_cdSql += Chr(13) + Chr(10) + "                                        LEFT OUTER JOIN SA1010  A1 with (NOLOCK)
		_cdSql += Chr(13) + Chr(10) + "                                                     ON E1_CLIENTE = A1_COD
		_cdSql += Chr(13) + Chr(10) + "                                                        AND E1_LOJA = A1_LOJA
		_cdSql += Chr(13) + Chr(10) + "                                        LEFT OUTER JOIN (SELECT
		_cdSql += Chr(13) + Chr(10) + "                                                         F2_DOC,
		_cdSql += Chr(13) + Chr(10) + "                                                         F2_SERIE,
		_cdSql += Chr(13) + Chr(10) + "                                                         F2_CLIENTE,
		_cdSql += Chr(13) + Chr(10) + "                                                         F2_LOJA,
		_cdSql += Chr(13) + Chr(10) + "                                                         F2_VEND1        VEND,
		_cdSql += Chr(13) + Chr(10) + "                                                         Sum(F2_VALBRUT) VAL
		_cdSql += Chr(13) + Chr(10) + "                                                         FROM   SF2010 with (NOLOCK)
		_cdSql += Chr(13) + Chr(10) + "                                                         WHERE  D_E_L_E_T_ = ''
		_cdSql += Chr(13) + Chr(10) + "                                                         GROUP  BY F2_DOC,
		_cdSql += Chr(13) + Chr(10) + "                                                                   F2_SERIE,
		_cdSql += Chr(13) + Chr(10) + "                                                                   F2_CLIENTE,
		_cdSql += Chr(13) + Chr(10) + "                                                                   F2_LOJA,
		_cdSql += Chr(13) + Chr(10) + "                                                                   F2_VEND1)EA
		_cdSql += Chr(13) + Chr(10) + "                                                     ON EA.F2_DOC = D1_NFORI
		_cdSql += Chr(13) + Chr(10) + "                                                        AND EA.F2_SERIE = D1_SERIORI
		_cdSql += Chr(13) + Chr(10) + "                                 GROUP  BY D1_NFORI,
		_cdSql += Chr(13) + Chr(10) + "                                           D1_SERIORI,
		_cdSql += Chr(13) + Chr(10) + "                                           D1_DOC,
		_cdSql += Chr(13) + Chr(10) + "                                           D1_SERIE,
		_cdSql += Chr(13) + Chr(10) + "                                           E1_EMISSAO,
		_cdSql += Chr(13) + Chr(10) + "                                           F2_CLIENTE,
		_cdSql += Chr(13) + Chr(10) + "                                           F2_LOJA,
		_cdSql += Chr(13) + Chr(10) + "                                           A1_NOME,
		_cdSql += Chr(13) + Chr(10) + "                                           VEND)DV
		_cdSql += Chr(13) + Chr(10) + "                             ON DV.E1_NUM = E5_NUMERO
		_cdSql += Chr(13) + Chr(10) + "                                AND DV.E1_PREFIXO = E5_PREFIXO
		_cdSql += Chr(13) + Chr(10) + "                LEFT OUTER JOIN(SELECT E5_NUMERO  E1_NUM,
		_cdSql += Chr(13) + Chr(10) + "                                       E5_PREFIXO E1_PREFIXO,
		_cdSql += Chr(13) + Chr(10) + "                                       E5_CLIFOR  E1_CLIENTE,
		_cdSql += Chr(13) + Chr(10) + "                                       E5_LOJA    E1_LOJA,
		_cdSql += Chr(13) + Chr(10) + "                                       Count(*)   PARCELA
		_cdSql += Chr(13) + Chr(10) + "                                FROM   SE5010 with (NOLOCK)
		_cdSql += Chr(13) + Chr(10) + "                                WHERE  D_E_L_E_T_ = ''
		_cdSql += Chr(13) + Chr(10) + "                                       AND E5_DATA BETWEEN @EmiFrom AND @EmiTo
		_cdSql += Chr(13) + Chr(10) + "                                       And E5_VALOR > 0
		_cdSql += Chr(13) + Chr(10) + "                                GROUP  BY E5_NUMERO,
		_cdSql += Chr(13) + Chr(10) + "                                          E5_PREFIXO,
		_cdSql += Chr(13) + Chr(10) + "                                          E5_CLIFOR,
		_cdSql += Chr(13) + Chr(10) + "                                          E5_LOJA) PA
		_cdSql += Chr(13) + Chr(10) + "                             ON PA.E1_NUM = E5_NUMERO
		_cdSql += Chr(13) + Chr(10) + "                                AND E5_PREFIXO = PA.E1_PREFIXO
		_cdSql += Chr(13) + Chr(10) + "                                AND E5_CLIFOR = PA.E1_CLIENTE
		_cdSql += Chr(13) + Chr(10) + "                                AND PA.E1_LOJA = E5_LOJA
		_cdSql += Chr(13) + Chr(10) + "                Left OUter Join
		_cdSql += Chr(13) + Chr(10) + "                                ( Select D1_DOC,D1_SERIE,D1_SERIORI,D1_NFORI,F2_VEND1  from SD1010 D1 with(nolock)
		_cdSql += Chr(13) + Chr(10) + "                                      Left OUter Join SF2010 F2 with(NOLOCK) on F2_DOC = D1_NFORI and F2_SERIE = D1_SERIORI AND F2.D_E_L_E_T_ = ''
		_cdSql += Chr(13) + Chr(10) + "                                      Where D1.D_E_L_E_T_ = ''
		_cdSql += Chr(13) + Chr(10) + "                                      And D1_TIPO = 'D'
		_cdSql += Chr(13) + Chr(10) + "                                      group by D1_DOC,D1_SERIE,D1_NFORI,D1_SERIORI,F2_VEND1)DEV on D1_SERIE+D1_DOC = Left(E5_DOCUMEN,12)
		_cdSql += Chr(13) + Chr(10) + "                LEFT OUTER JOIN SA3010  E with (NOLOCK)
		_cdSql += Chr(13) + Chr(10) + "                             ON E.D_E_L_E_T_ = ''
		_cdSql += Chr(13) + Chr(10) + "                                AND A3_COD = COALESCE(AA.E1_VEND1, DV.VEND) And A3_TIPO = @cdTipo
		_cdSql += Chr(13) + Chr(10) + "                LEFT OUTER JOIN SA3010  F with (NOLOCK)
		_cdSql += Chr(13) + Chr(10) + "                             ON E.D_E_L_E_T_ = ''
		_cdSql += Chr(13) + Chr(10) + "                                AND F.A3_COD = DEV.F2_VEND1
		_cdSql += Chr(13) + Chr(10) + " )AAA
		_cdSql += Chr(13) + Chr(10) + " WHERE  E1_VEND1 BETWEEN @VenFrom AND @VenTo
		_cdSql += Chr(13) + Chr(10) + "        AND E1_VEND1 IS NOT NULL
		_cdSql += Chr(13) + Chr(10) + "        And A3_COD is not null
		_cdSql += Chr(13) + Chr(10) + "        and A3_COMIS > 0
		_cdSql += Chr(13) + Chr(10) + "        AND NOT(E5_MOTBX = 'CMP' AND E5_DATA > A3_DTEMIS AND VORIG != A3_COD)
		If _cTipo == 'A'
		Else
			_cdSql += Chr(13) + Chr(10) + "  GROUP BY A3_COD,A3_NOME,A3_COMIS "
		EndiF
		_cdSql += Chr(13) + Chr(10) + " ) A  WHERE VALOR <> 0
		_cdSql += Chr(13) + Chr(10) + "  ORDER BY A3_COD,A3_NOME,A3_COMIS " + IiF(_cTipo == 'A' , ', E5_NUMERO','')
		
	
		_cdSql := StrTran(_cdSql,'SE1010',RetSqlName('SE1'))
		_cdSql := StrTran(_cdSql,'SE5010',RetSqlName('SE5'))
		_cdSql := StrTran(_cdSql,'SA3010',RetSqlName('SA3'))
		_cdSql := StrTran(_cdSql,'SD1010',RetSqlName('SD1'))
		_cdSql := StrTran(_cdSql,'SF2010',RetSqlName('SF2'))
		
		Memowrite('AAFINR03.SQL',_cdSql)
		_ndRet := tcSqlexec(_cdSql)
	Endif
	Return

Static Function getSql(_ndTipo)

	Local _cdQry   := ""
	Local _cdTbl   := getNextAlias()
	Local cEmiFrom := mv_par01
	Local cEmiTo   := mv_par02
	Local cVenFrom := mv_par03
	Local cVenTo   := mv_par04

	iF _ndTipo == 01
		proProcedure('A')
		_cdName := 'GETCOMISSAO'+cEmpAnt + 'A'
	Else
		proProcedure('S')
		_cdName := 'GETCOMISSAO'+cEmpAnt + 'S'
	EndIf

	_cdQry := " exec " + _cdName + "  '" + DTOS(mv_par03) + "','" + DTOS(mv_par04) + "', '" + mv_par01 + "' , '"  + mv_par02 + "','"+Posicione("SA3",7,xFilial("SA3")+__cUserID,"A3_COD")+"' "

	dbUseArea(.T.,'TOPCONN',tcGenQry(,,_cdQry),_cdTbl,.T.,.T.)

	REturn _cdTbl
