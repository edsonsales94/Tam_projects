#include "Protheus.ch"
#include "totvs.ch"

User Function AACTBR05()
	
	u_XCTBR05()
	
Return

User Function XCTBR05()
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := ""
	Local cPict          := ""
	Local titulo         := "Baixas por Tipo"
	Local nLin           := 80
	
	//                                 1         2         3         4         5         6         7         8         9         10        11
	//                       012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	Local Cabec1         := "      Fil.  Doc/Serie         Banco   Cliente/Loja-Nome          Dt. Baixa           Valor        Vlr.Juros     Vlr. Real     Vlr. Taxa   "
	Local Cabec2         := ""
	
	Local imprime        := .T.
	Local aOrd           := {}
	
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 132
	Private tamanho      := "G"
	Private nomeprog     := "AACTBR05" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "AACTBR05" // Coloque aqui o nome do arquivo usado para impressao em disco
	
	Private cString  := ""
	Private cPerg    := PADR("AACTBR05",Len(SX1->X1_GRUPO))
	
	Private _adSubTot := {}
	Private _adTotais := {}
	
	aAdd(_adTotais , {0,0,0,0} )
	aAdd(_adTotais , {0,0,0,0} )
	aAdd(_adTotais , {0,0,0,0} )
	aAdd(_adTotais , {0,0,0,0} ) 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	ValidPerg(cPerg)
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	Pergunte(cPerg,.F.)
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  09/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	
	Local nOrdem
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	_cdTbl := getTable()
	_aCab := {}
	_cdTitulo := "Baixas Por Tipo"
	_cdFile   := ""
	
	if Mv_par12 == 01
		_cdFile   := AllTrim(mv_par13) + "\" + AllTrim(mv_par14) + ".xls"
		Processa( {|| _Excel(_cdTbl , _aCab , _cdTitulo  , _cdFile ) }, "Gerando Arquivo em Excel..." )
	EndIf
	
	(_cdTbl)->(dbGoTop())
	SetRegua( (_cdTbl)->(RecCount()) )
	(_cdTbl)->(dbGoTop())
	
	While !(_cdTbl)->(EOF())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		_ndTotGeral := 0
		_adTotais[03][01] := 0
		_adTotais[03][02] := 0
		_adTotais[03][03] := 0
		_adTotais[03][04] := 0
				
		_ldAtivo := .F.
		While !(_cdTbl)->(Eof())
			
			_cdTipo    := (_cdTbl)->TIPO
			_cdReserva := (_cdTbl)->RESERVA
			
			If mv_par11 == 1 .And. _ldAtivo
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Else
				_ldAtivo := .T.
			EndIf
			
			_ndTipo := 0
			_adTotais[02][01] := 0
		    _adTotais[02][02] := 0
		    _adTotais[02][03] := 0
		    _adTotais[02][04] := 0
		        
			@nLin,05 PSAY "Imprimindo Tipo: " + _cdTipo
			nLin := nLin + 1 // Avanca a linha de impressao
			While _cdTipo  == (_cdTbl)->TIPO
				
				_cdReserva := (_cdTbl)->RESERVA
				_ndTotal   := 0
				
				_adTotais[01][01] := 0
		        _adTotais[01][02] := 0
		        _adTotais[01][03] := 0
		        _adTotais[01][04] := 0
		
				@nLin,10 PSAY iIF(_cdReserva=="S","Reserva" , "Normal")
				nLin := nLin + 1 // Avanca a linha de impressao
				
				While _cdReserva == (_cdTbl)->RESERVA .And. _cdTipo  == (_cdTbl)->TIPO
					If MV_PAR10 == 01
						@nLin,01 + 05 PSAY (_cdTbl)->FILIAL
						@nLin,08 + 05 PSAY (_cdTbl)->DOCUMENTO + '/' + (_cdTbl)->SERIE
						@nLin,26 + 05 PSAY (_cdTbl)->BANCO
						@nLin,33 + 05 PSAY Left( (_cdTbl)->CLIENTE+'/'+(_cdTbl)->LOJA+'-'+(_cdTbl)->NOME_CLI ,25)
						@nLin,62 + 05 PSAY dtoc( (_cdTbl)->DTBAIXA )
						//@nLin,76 + 05 PSAY (_cdTbl)->VENCTO
						@nLin,76 + 00 PSAY Transform( (_cdTbl)->VALOR    , "@E 999,999,999.99")
						@nLin,92 + 00 PSAY Transform( (_cdTbl)->VLJUROS  , "@E 999,999,999.99")
						@nLin,105 + 00 PSAY Transform( (_cdTbl)->VLRREAL , "@E 999,999,999.99")
						@nLin,123 + 00 PSAY Transform( (_cdTbl)->TAXA    , "@E 999,999,999.99")
						//@nLin,123 + 00 PSAY (_cdTbl)->ORIGINAL
						
						nLin := nLin + 1 // Avanca a linha de impressao
						If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
							Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
							nLin := 8
						Endif
						
					EndIf
					
					_adTotais[01][01] += (_cdTbl)->VALOR
					_adTotais[01][02] += (_cdTbl)->VLJUROS
					_adTotais[01][03] += (_cdTbl)->VLRREAL
					_adTotais[01][04] += (_cdTbl)->TAXA
					
					_ndTotal += (_cdTbl)->VALOR
					(_cdTbl)->(dbSkip())
				EndDo
				nLin := nLin + 1 // Avanca a linha de impressao
				@nLin,10 PSAY "Total " + iIF(_cdReserva=="S","Reserva" , "Normal")
				@nLin,30 PSAY Replicate('-',45)
				//@nLin,89 + 00 PSAY transForm(_ndTotal, "@E 999,999,999.99")
				
				@nLin,76 + 00  PSAY Transform( _adTotais[01][01]    , "@E 999,999,999.99")
				@nLin,92 + 00  PSAY Transform( _adTotais[01][02]    , "@E 999,999,999.99")
				@nLin,105 + 00 PSAY Transform( _adTotais[01][03]   , "@E 999,999,999.99")
				@nLin,123 + 00 PSAY Transform( _adTotais[01][04]   , "@E 999,999,999.99")
				
				_ndTipo += _ndTotal
				
				_adTotais[02][01] += _adTotais[01][01]
				_adTotais[02][02] += _adTotais[01][02]
				_adTotais[02][03] += _adTotais[01][03]
				_adTotais[02][04] += _adTotais[01][04]
				
				nLin := nLin + 1 // Avanca a linha de impressao
				@ nLin,000 PSAY __PrtThinLine()
				nLin := nLin + 1 // Avanca a linha de impressao
			EndDo

			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,05 PSAY "Total do Tipo " + _cdTipo
			@nLin,30 PSAY Replicate('-',45)
			//@nLin,89 + 00 PSAY transForm(_ndTipo, "@E 999,999,999.99")
			
			@nLin,76 + 00 PSAY Transform( _adTotais[02][01]    , "@E 999,999,999.99")
			@nLin,92 + 00 PSAY Transform( _adTotais[02][02]    , "@E 999,999,999.99")
			@nLin,105 + 00 PSAY Transform( _adTotais[02][03]   , "@E 999,999,999.99")
			@nLin,123 + 00 PSAY Transform( _adTotais[02][04]   , "@E 999,999,999.99")
			
			_adTotais[03][01] += _adTotais[02][01]
			_adTotais[03][02] += _adTotais[02][02]
			_adTotais[03][03] += _adTotais[02][03]
			_adTotais[03][04] += _adTotais[02][04]
			
			_ndTotGeral += _ndTipo
			nLin := nLin + 1 // Avanca a linha de impressao
			@ nLin,000 PSAY __PrtThinLine()
			//_ndTotGeral += _ndTipo
			nLin := nLin + 3 // Avanca a linha de impressao
			
		EndDo
		
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin,000 PSAY __PrtThinLine()
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin,01 PSAY "Total Geral "
		@nLin,30 PSAY Replicate('-',45)
		//@nLin,89 + 00 PSAY transForm(_ndTotGeral , "@E 999,999,999.99")
		
		@nLin,76  + 00 PSAY Transform( _adTotais[03][01]   , "@E 999,999,999.99")
		@nLin,92  + 00 PSAY Transform( _adTotais[03][02]   , "@E 999,999,999.99")
		@nLin,105 + 00 PSAY Transform( _adTotais[03][03]   , "@E 999,999,999.99")
		@nLin,123 + 00 PSAY Transform( _adTotais[03][04]   , "@E 999,999,999.99")
		
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin,000 PSAY __PrtThinLine()
		
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SET DEVICE TO SCREEN
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
Return


Static Function getTable()
	_cdTbl := getNextAlias()
	
	_cdQry := " SELECT * FROM "
	//_cdQry += " DROR_VENDASPORTIPO('" + DTOS(mv_par03) + "','" + DTOS(mv_par04) + "','" + mv_par01 + "','" + mv_par02 + "','" + mv_par05 + "','" + Alltrim(str(mv_par08)) +  "')
	_cdQry += " DROR_BAIXAPORTIPO" + cEmpAnt + "('" + mv_par01 + "','" + mv_par02 + "','" + DTOS(mv_par03) + "','" + DTOS(mv_par04) + "','" + mv_par05 + "','" + mv_par06 + "','" + mv_par07 + "','" + mv_par08 + "','" + iIF(mv_par09 == 1,"R","P") + "', '" + Alltrim(Str(mv_par15)) + "') "
	_cdQry += " Order By TIPO,RESERVA,FILIAL,DOCUMENTO "
	
	memowrite('AACTBR05.sql',_cdQry)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cdQry), _cdTbl , .F., .T.)
	
	TCSetField(_cdTbl,"EMISSAO","D",8,0)
	TCSetField(_cdTbl,"VENCTO","D",8,0)
	TCSetField(_cdTbl,"DTBAIXA","D",8,0)
	
Return _cdTbl




Static Function _Excel(_cTbl,_aCab,_cdTitulo ,_cdFile )
	
	Local _aStru  :=  (_cTbl)->(dbStruct())
	Local oExcel  := FWMSEXCEL():New()
	Local _cWork  := _cdTitulo
	Local _aCol   := {}
	Local _cdTbl  := _cdTitulo
	
	Default _aCab := {{"",""}}
	
	oExcel:AddworkSheet( _cWork )
	oExcel:AddTable( _cWork, _cdTbl)
	
	For _ndI := 1 To Len(_aStru)
		
		_cdCp := _aStru[_ndI][01]
		_nPos := aScan(_aCab,{|y| y[01] == _cdCp })
		
		If _nPos > 0
			_cAdd :=  _aCab[_nPos,02]
		Elseif _ChkCpo(_aStru[_ndI][01])
			_cAdd := SX3->X3_TITULO
		Else
			_cAdd := StrTran(_aStru[_ndI][01],"_"," ")
		EndIf
		
		_ndAlign  := iIf(_aStru[_ndI][02] $ 'N',3, iIf(_aStru[_ndI][02] $ 'D' ,2, 1) )
		_ndFormat := iIf(_aStru[_ndI][02] $ 'N',2, iIf(_aStru[_ndI][02] $ 'D' ,4, 1) )
		_ldTotal  := iIf(_aStru[_ndI][01] $ 'VALOR/VLJUROS/VLRREAL/TAXA',.T.,.F. )
		oExcel:AddColumn(_cWork, _cdTbl, _cAdd , _ndAlign, _ndFormat, _ldTotal )
		aAdd(_aCol,_cAdd)
	Next
	_ndTotal := 0
	While !(_cTbl)->(Eof())
	  _ndTotal++
	   (_cTbl)->(dbSkip())
	EndDo
	//Alert(_ndTotal)
	ProcRegua(_ndTotal)
	
	(_cTbl)->(dbGoTop())
	
	While !(_cTbl)->(Eof())
		
		IncProc()
		_adLinha := {}
		For _ndI := 1 To Len(_aStru)
			If _aStru[_ndI][02] == "D"
				aAdd(_adLinha, DTOC( (_cTbl)->&(_aStru[_ndI][01]) ) )
			Else
				aAdd(_adLinha, (_cTbl)->&(_aStru[_ndI][01])  )
			EndIf
		Next
		oExcel:AddRow(_cWork, _cdTbl, _adLinha )
		
		(_cTbl)->(dbSkip())
	EndDo
	
	oExcel:Activate()
	oExcel:GetXmlFile(_cdFile)
	
	RunExcel(_cdFile)
Return Nil


Static Function _ChkCpo(_cCpo)
	Local _lRet := .F.
	
	SX3->(dbgoTop())
	SX3->(dbSetOrder(2))
	_lRet := SX3->(dbSeek(Alltrim(_cCpo)))
	
Return _lRet


Static Function RunExcel(cwArq)
	Local oExcelApp
	Local aNome := {}
	
	If ! ApOleClient( 'MsExcel' ) //Verifica se o Excel esta instalado
		MsgStop( 'MsExcel nao instalado' )
		Return
	EndIf
	oExcelApp := MsExcel():New()  // Cria um objeto para o uso do Excel
	oExcelApp:WorkBooks:Open(cwArq)
	oExcelApp:SetVisible(.T.)     // Abre o Excel com o arquivo criado exibido na Primeira planilha.
	//oExcelApp:Destroy()
	
Return

Static Function ValidPerg(cPerg)
	
	PutSX1(cPerg,"01",PADR("Filial de?",29) ,"","","mv_ch1","C",02,0,0,"G","","   ","","","mv_par01")
	PutSX1(cPerg,"02",PADR("Filial Ate?",29),"","","mv_ch1","C",02,0,0,"G","","   ","","","mv_par02")
	
	PutSX1(cPerg,"03",PADR("Emissao de?",29) ,"","","mv_ch1","D",08,0,0,"G","","   ","","","mv_par03")
	PutSX1(cPerg,"04",PADR("Emissao Ate?",29),"","","mv_ch1","D",08,0,0,"G","","   ","","","mv_par04")
	
	PutSX1(cPerg,"05",PADR("Banco De ?",29) ,"","","mv_ch1","C",99,0,0,"G","","   ","","","mv_par05")
	PutSX1(cPerg,"06",PADR("Banco Ate?",29) ,"","","mv_ch1","C",99,0,0,"G","","   ","","","mv_par06")
		
	PutSX1(cPerg,"07",PADR("Tipos a Considerar?",29) ,"","","mv_ch1","C",99,0,0,"G","","   ","","","mv_par07")
	PutSX1(cPerg,"08",PADR("Tipos a Desconsiderar?",29) ,"","","mv_ch1","C",99,0,0,"G","","   ","","","mv_par08")
	PutSX1(cPerg,"09",PADR("Carteira ?" ,29) ,"","","mv_ch1","N",01,0,0,"C","","   ","","","mv_par09","Receber","","","","Pagar","","","")
	
	PutSX1(cPerg,"10",PADR("Tipo de Relatorio?" ,29) ,"","","mv_ch1","N",01,0,0,"C","","   ","","","mv_par10","Analitico","","","","Sintetico")
	
	PutSX1(cPerg,"11",PADR("Quebra por Pagina?" ,29) ,"","","mv_ch1","N",01,0,0,"C","","   ","","","mv_par11","Sim","","","","Nao")		
	
	PutSX1(cPerg,"12", PADR("Gera Excel?" ,29) ,"","","mv_ch1","N",01,0,0,"C","","   ","","","mv_par12","Sim","","","","Não","","","")
	PutSX1(cPerg,"13", Padr("Diretorio ",29) +"?", "", "" , "mv_ch7" , "C" ,99, 0, 0, "G","","","","","mv_par13")
	PutSX1(cPerg,"14", Padr("Nome Arquivo",29) +"?", "", "" , "mv_ch8" , "C" ,99, 0, 0, "G","","","","","mv_par14")
	
	PutSX1(cPerg,"15", PADR("Tipo de Baixa?" ,29) ,"","","mv_ch1","N",01,0,0,"C","","   ","","","mv_par15","Normal","","","","Reserva","","","Ambos","Ambos")
	
	PutSX1(cPerg,"16",PADR("Baixa de?",29) ,"","","mv_ch1","D",08,0,0,"G","","   ","","","mv_par16")
	PutSX1(cPerg,"17",PADR("Baixa Ate?",29),"","","mv_ch1","D",08,0,0,"G","","   ","","","mv_par17")
Return Nil 


