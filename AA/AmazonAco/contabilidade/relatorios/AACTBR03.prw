#include "Protheus.ch"
#include "totvs.ch"

User Function AACTBR03()
    _cdName := 'CTBR03' + __cUSerId
	If LockByName(_cdName,.T.,.T.)
	   u_XCTBR03()
	   UnLockByName(_cdName,.T.,.T.)
	Else
	   Aviso('Atenção','Relatorio ja Em Execução por Este Usuario',{'OK'})
	EndIf
Return

Static Function ValidPerg(cPerg)
	
	PutSX1(cPerg,"01",PADR("Filial de?",29) ,"","","mv_ch1","C",02,0,0,"G","","   ","","","mv_par01")
	PutSX1(cPerg,"02",PADR("Filial Ate?",29),"","","mv_ch1","C",02,0,0,"G","","   ","","","mv_par02")
	
	PutSX1(cPerg,"03",PADR("Emissao de?",29) ,"","","mv_ch1","D",08,0,0,"G","","   ","","","mv_par03")
	PutSX1(cPerg,"04",PADR("Emissao Ate?",29),"","","mv_ch1","D",08,0,0,"G","","   ","","","mv_par04")
	
	PutSX1(cPerg,"05",PADR("Tipos a Considerar?",29) ,"","","mv_ch1","C",99,0,0,"G","","   ","","","mv_par05")
	PutSX1(cPerg,"06",PADR("Tipo de Relatorio?" ,29) ,"","","mv_ch1","N",01,0,0,"C","","   ","","","mv_par06","Analitico","","","","Sintetico")
	
	PutSX1(cPerg,"07",PADR("Quebra por Pagina?" ,29) ,"","","mv_ch1","N",01,0,0,"C","","   ","","","mv_par07","Sim","","","","Nao")
	
	PutSX1(cPerg,"08",PADR("Tipo de Venda?" ,29) ,"","","mv_ch1","N",01,0,0,"C","","   ","","","mv_par08","Normal","","","","Reserva","","","Ambos")
	
	PutSX1(cPerg,"09", PADR("Gera Excel?" ,29) ,"","","mv_ch1","N",01,0,0,"C","","   ","","","mv_par09","Sim","","","","Não","","","")
	PutSX1(cPerg,"10", Padr("Diretorio ",29) +"?", "", "" , "mv_ch7" , "C" ,99, 0, 0, "G","","","","","mv_par10")
	PutSX1(cPerg,"11", Padr("Nome Arquivo",29) +"?", "", "" , "mv_ch8" , "C" ,99, 0, 0, "G","","","","","mv_par11")
	
//	PutSX1(cPerg,"12", PADR("Tipo de Baixa?" ,29) ,"","","mv_ch1","N",01,0,0,"C","","   ","","","mv_par12","Normal","","","","Reserva","","","Ambos","Ambos")
	
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO12    º Autor ³ AP6 IDE            º Data ³  09/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function XCTBR03()
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := ""
	Local cPict          := ""
	Local titulo         := "Vendas por Tipo"
	Local nLin           := 80
	
	//                                 1         2         3         4         5         6         7         8         9         10        11        12        13
	//                       01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	Local Cabec1         := "      Fil.  Doc/Serie         Banco   Cliente/Loja-Nome          Emissao             Valor        Vlr.Real      Vlr. Taxa     Cupom    BX_RESERVA"
	Local Cabec2         := ""
	
	Local imprime        := .T.
	Local aOrd           := {}
	
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 132
	Private tamanho      := "G"
	Private nomeprog     := "AACTBR03" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "AACTBR03" // Coloque aqui o nome do arquivo usado para impressao em disco
	
	Private cString := ""
	Private cPerg   := PADR("AACTBR03",Len(SX1->X1_GRUPO))
	
	
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
	_cdTitulo := "Vendas Por Tipo"
	_cdFile   := ""
	_adDados  := {}
	
	if Mv_par09 == 01
		_cdFile   := AllTrim(mv_par10) + "\" + AllTrim(mv_par11) + ".xls"
		Processa( {|| _Excel(_cdTbl , _aCab , _cdTitulo  , _cdFile ) }, "Gerando Arquivo em Excel..." )
	EndIf
	
	(_cdTbl)->(dbGoTop())
	SetRegua( (_cdTbl)->(RecCount()) )
	(_cdTbl)->(dbGoTop())
	
	If mv_par06 == 02
	   //                           1         2         3         4         5         6         7         8         9         10        11        12        13        14
	   //                 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
		Cabec1         := "                              |-------------- NORMAL --------------|    |------------- RESERVA ------------|    |--------- BAIXA RESERVA ----------|
		Cabec2         := " TIPO  DESCRICAO               VALOR             VLRREAL       TAXA      VALOR         VLRREAL         TAXA      VALOR         VLRREAL         TAXA
	EndIf
	//Local Cabec2         := ""
	
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
		_ldAtivo := .F.
		_adTotal := {0,0,0,0,0,0}
		While !(_cdTbl)->(Eof())
			If MV_PAR06 == 01
				_cdTipo    := (_cdTbl)->TIPO
				_cdReserva := (_cdTbl)->RESERVA
			
				If mv_par07 == 1 .And. _ldAtivo
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Else
					_ldAtivo := .T.
				EndIf
			
				_ndTipo := 0
			
				@nLin,05 PSAY "Imprimindo Tipo: " + _cdTipo
				nLin := nLin + 1 // Avanca a linha de impressao
				While _cdTipo  == (_cdTbl)->TIPO
				
					_cdReserva := (_cdTbl)->RESERVA
					_ndTotal   := 0
					@nLin,10 PSAY iIF(_cdReserva=="S","Reserva" , "Normal")
					nLin := nLin + 1 // Avanca a linha de impressao
				
					While _cdReserva == (_cdTbl)->RESERVA .And. _cdTipo  == (_cdTbl)->TIPO
						If MV_PAR06 == 01
							@nLin,01 + 05 PSAY (_cdTbl)->FILIAL
							@nLin,08 + 05 PSAY (_cdTbl)->DOCUMENTO + '/' + (_cdTbl)->SERIE
							@nLin,26 + 05 PSAY (_cdTbl)->BANCO
							@nLin,33 + 05 PSAY Left( (_cdTbl)->CLIENTE+'/'+(_cdTbl)->LOJA+'-'+(_cdTbl)->NOME_CLI ,25)
							@nLin,62 + 05 PSAY (_cdTbl)->EMISSAO
						//@nLin,76 + 05 PSAY (_cdTbl)->VENCTO
							@nLin,76 + 00 PSAY Transform( (_cdTbl)->VALOR    , "@E 999,999,999.99")
							@nLin,92 + 00 PSAY Transform( (_cdTbl)->VLRREAL , "@E 999,999,999.99")
							@nLin,105 + 00 PSAY Transform( (_cdTbl)->TAXA    , "@E 999,999,999.99")
							@nLin,123 + 00 PSAY (_cdTbl)->ORIGINAL
						    @nLin,134 + 00 PSAY (_cdTbl)->BX_RESERVA
						    
							nLin := nLin + 1 // Avanca a linha de impressao
							If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
								Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
								nLin := 8
							Endif
						
						EndIf
						_ndTotal += (_cdTbl)->VALOR
						(_cdTbl)->(dbSkip())
					EndDo
					If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 8
					Endif
					nLin := nLin + 1 // Avanca a linha de impressao
					@nLin,10 PSAY "Total " + iIF(_cdReserva=="S","Reserva" , "Normal")
					@nLin,30 PSAY Replicate('-',45)
					@nLin,89 + 00 PSAY transForm(_ndTotal, "@E 999,999,999.99")
				
					_ndTipo += _ndTotal
					nLin := nLin + 1 // Avanca a linha de impressao
					@ nLin,000 PSAY __PrtThinLine()
					nLin := nLin + 1 // Avanca a linha de impressao
				EndDo
				nLin := nLin + 1 // Avanca a linha de impressao
				@nLin,05 PSAY "Total do Tipo " + _cdTipo
				@nLin,30 PSAY Replicate('-',45)
				@nLin,89 + 00 PSAY transForm(_ndTipo, "@E 999,999,999.99")
				_ndTotGeral += _ndTipo
				nLin := nLin + 1 // Avanca a linha de impressao
				@ nLin,000 PSAY __PrtThinLine()
			//_ndTotGeral += _ndTipo
				nLin := nLin + 3 // Avanca a linha de impressao
			Else
				
				@nLin,01  PSAY (_cdTbl)->TIPO
				@nLin,08  PSAY (_cdTbl)->X5_DESCRI
				
				@nLin,30 + 00 PSAY transForm( (_cdTbl)->NORMAL_VALOR   , "@E 999,999,999.99")
				@nLin,43 + 00 PSAY transForm( (_cdTbl)->NORMAL_VLRREAL , "@E 999,999,999.99")
				@nLin,54 + 00 PSAY transForm( (_cdTbl)->NORMAL_TAXA    , "@E 999,999,999.99")
				
				@nLin,74 + 00 PSAY transForm( (_cdTbl)->RESERVA_VALOR    , "@E 999,999,999.99")
				@nLin,86 + 00 PSAY transForm( (_cdTbl)->RESERVA_VLRREAL  , "@E 999,999,999.99")
				@nLin,96 + 00 PSAY transForm( (_cdTbl)->RESERVA_TAXA     , "@E 999,999,999.99")
				nLin := nLin + 1 
				
				_adTotal[01] += (_cdTbl)->NORMAL_VALOR
				_adTotal[02] += (_cdTbl)->NORMAL_VLRREAL
				_adTotal[03] += (_cdTbl)->NORMAL_TAXA
				
				_adTotal[04] += (_cdTbl)->RESERVA_VALOR
				_adTotal[05] += (_cdTbl)->RESERVA_VLRREAL
				_adTotal[06] += (_cdTbl)->RESERVA_TAXA
								
				(_cdTbl)->(dbSkip())
			EndIf
			
		EndDo
		
		
		If MV_PAR06 == 01
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,000 PSAY __PrtThinLine()
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,01 PSAY "Total Geral "
			@nLin,30 PSAY Replicate('-',45)
			@nLin,89 + 00 PSAY transForm(_ndTotGeral , "@E 999,999,999.99")
			nLin := nLin + 1 // Avanca a linha de impressao
		Else
		   
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,000 PSAY __PrtThinLine()
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,01 PSAY "Total Geral "
		    //@nLin,30 PSAY Replicate('-',45)
			
			@nLin,30 + 00 PSAY transForm( _adTotal[01]  , "@E 999,999,999.99")
			@nLin,43 + 00 PSAY transForm( _adTotal[02]  , "@E 999,999,999.99")
			@nLin,54 + 00 PSAY transForm( _adTotal[03]  , "@E 999,999,999.99")
				
			@nLin,74 + 00 PSAY transForm( _adTotal[04]  , "@E 999,999,999.99")
			@nLin,86 + 00 PSAY transForm( _adTotal[05]  , "@E 999,999,999.99")
			@nLin,96 + 00 PSAY transForm( _adTotal[06]  , "@E 999,999,999.99")
				
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,000 PSAY __PrtThinLine()
		EndIf
		
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
	_cdQryS := ""
	
	_cdQryS += " Select TIPO,X5_DESCRI,
	_cdQryS += "        isNUll( Sum( Case When RESERVA = 'S' THEN VALOR   END ),0) RESERVA_VALOR,
	_cdQryS += " 		isNUll( Sum( Case When RESERVA = 'S' THEN VLRREAL END ),0) RESERVA_VLRREAL,
	_cdQryS += " 		isNUll( Sum( Case When RESERVA = 'S' THEN TAXA    END ),0) RESERVA_TAXA,
	
	_cdQryS += " 		isNUll( Sum( Case When RESERVA = 'N' And BX_RESERVA = 'N' THEN VALOR   END ),0) NORMAL_VALOR  ,
	_cdQryS += " 		isNUll( Sum( Case When RESERVA = 'N' And BX_RESERVA = 'N' THEN VLRREAL END ),0) NORMAL_VLRREAL,
	_cdQryS += " 		isNUll( Sum( Case When RESERVA = 'N' And BX_RESERVA = 'N' THEN TAXA    END ),0) NORMAL_TAXA   ,   
	
	_cdQryS += " 		isNUll( Sum( Case When RESERVA = 'N' And BX_RESERVA = 'S' THEN VALOR   END ),0) BXRESERVA_VALOR  ,
	_cdQryS += " 		isNUll( Sum( Case When RESERVA = 'N' And BX_RESERVA = 'S' THEN VLRREAL END ),0) BXRESERVA_VLRREAL,
	_cdQryS += " 		isNUll( Sum( Case When RESERVA = 'N' And BX_RESERVA = 'S' THEN TAXA    END ),0) BXRESERVA_TAXA   
	
	_cdQryS += " from  DROR_VENDASPORTIPO" + cEmpAnt + "('" + DTOS(mv_par03) + "','" + DTOS(mv_par04) + "','" + mv_par01 + "','" + mv_par02 + "','" + mv_par05 + "','" + Alltrim(str(mv_par08)) +  "' )"
	_cdQryS += " Left Join " + RetSqlName('SX5') + " SX5 WITH (NOLOCK) ON X5_TABELA = '24' AND X5_CHAVE = TIPO AND SX5.D_E_L_E_T_ = ''
	_cdQryS += " GROUP BY TIPO,X5_DESCRI
	_cdQryS += " order by TIPO
	
	_cdQry := " SELECT * FROM "
	_cdQry += " DROR_VENDASPORTIPO" + cEmpAnt + "('" + DTOS(mv_par03) + "','" + DTOS(mv_par04) + "','" + mv_par01 + "','" + mv_par02 + "','" + mv_par05 + "','" + Alltrim(str(mv_par08)) +  "' )"
	_cdQry += " Order By TIPO,RESERVA,FILIAL,DOCUMENTO "
	
	If MV_PAR06 == 01
	    if .T.
	       //_cdQry := GETSQL()
	       //_cdQry := StrTRan(_cdQry , "@CDDATA01" , " '" + DTOS(MV_PAR03) + "' ")
	       //_cdQry := StrTRan(_cdQry , "@CDDATA02" , " '" + DTOS(MV_PAR04) + "' ")
	       
	       //_cdQry := StrTRan(_cdQry , "@CDFILIAL01" ," '" + mv_par01 + "' " )
	       //_cdQry := StrTRan(_cdQry , "@CDFILIAL02" ," '" + mv_par02 + "' " )
	       
	       //_cdQry := StrTRan(_cdQry , "@CDTIPOS" , " '" + mv_par05 + "' " )
	       //_cdQry := StrTRan(_cdQry , "@CDTIPO"  , " '" + Alltrim(str(mv_par08)) + "' " )
	    EndIf
	    MemoWrite('AACTBR03.sql',_cdQry)
	    //tcSqlExec(" Exec P_DROR_VENDASPORTIPO '" + DTOS(mv_par03) + "','" + DTOS(mv_par04) + "','" + mv_par01 + "','" + mv_par02 + "','" + mv_par05 + "','" + Alltrim(str(mv_par08)) +  "' , TBL" + __cUserId ) >= 0 
	    //_cdQry := ""
	      //  _cdQry := " Select * from TBL" + __cUserId
			dbUseArea(.T., "TOPCONN", TCGenQry(,,_cdQry), _cdTbl , .F., .T.)
			TCSetField(_cdTbl,"EMISSAO","D",8,0)
			TCSetField(_cdTbl,"EMISSAO_ORIGINAL","D",8,0)

			TCSetField(_cdTbl,"VENCTO" ,"D",8,0)
		/*Else
		   Aviso('ERRO','ERRO ao Gerar o Relatório, Contate o Administrador do Sistema' +Chr(13) +CHr(10)+ ;
		                " TCSQLError() " + TCSQLError() ,{'OK'})
		   MsFinal()
		EndIf
        */		
	   
	Else
		dbUseArea(.T., "TOPCONN", TCGenQry(,,_cdQryS), _cdTbl , .F., .T.)
	EndIf
	
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
		_ldTotal  := iIf(_aStru[_ndI][01] $ 'VALOR',.T.,.F. )
		oExcel:AddColumn(_cWork, _cdTbl, _cAdd , _ndAlign, _ndFormat, _ldTotal )
		aAdd(_aCol,_cAdd)
	Next
	
	ProcRegua(0)
	
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
	aviso('','Arquivo Gerado',{'OK'})
	//RunExcel(alltrim(mv_par03) + "\" +alltrim(mv_par04) + ".xls")
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


STATIC FUNCTION GETSQL()
_CDSQL := ""
_CDSQL += CHR(13) + CHR(10) + " SELECT FILIAL, "
_CDSQL += CHR(13) + CHR(10) + "       DOCUMENTO, 
_CDSQL += CHR(13) + CHR(10) + "       SERIE, 
_CDSQL += CHR(13) + CHR(10) + "       TIPO, 
_CDSQL += CHR(13) + CHR(10) + "       BANCO, 
_CDSQL += CHR(13) + CHR(10) + "       CLIENTE, 
_CDSQL += CHR(13) + CHR(10) + "       LOJA, 
_CDSQL += CHR(13) + CHR(10) + "       NOME_CLI, 
_CDSQL += CHR(13) + CHR(10) + "       EMISSAO,         
_CDSQL += CHR(13) + CHR(10) + "       RESERVA, 
_CDSQL += CHR(13) + CHR(10) + "       ORIGINAL,
_CDSQL += CHR(13) + CHR(10) + "       EMISSAO_ORIGINAL,
 
_CDSQL += CHR(13) + CHR(10) + "       SUM(VALOR)   VALOR, 
_CDSQL += CHR(13) + CHR(10) + "       SUM(VLRREAL) VLRREAL, 
_CDSQL += CHR(13) + CHR(10) + "       SUM(TAXA)    TAXA   ,
_CDSQL += CHR(13) + CHR(10) + "	   BX_RESERVA
_CDSQL += CHR(13) + CHR(10) + "FROM   (SELECT E1_FILORIG                 FILIAL, 
_CDSQL += CHR(13) + CHR(10) + "               E1_NUM                     DOCUMENTO , 
_CDSQL += CHR(13) + CHR(10) + "               E1_PREFIXO                 SERIE, 
_CDSQL += CHR(13) + CHR(10) + "               CASE 
_CDSQL += CHR(13) + CHR(10) + "                 WHEN E1_TIPO = 'NF' 
_CDSQL += CHR(13) + CHR(10) + "                      AND F2_DOC IS NOT NULL THEN 'FI-' 
_CDSQL += CHR(13) + CHR(10) + "                 ELSE E1_TIPO 
_CDSQL += CHR(13) + CHR(10) + "               END         TIPO, 
_CDSQL += CHR(13) + CHR(10) + "               E1_PORTADO  BANCO, 
_CDSQL += CHR(13) + CHR(10) + "               E1_CLIENTE  CLIENTE, 
_CDSQL += CHR(13) + CHR(10) + "               E1_LOJA     LOJA, 
_CDSQL += CHR(13) + CHR(10) + "               E1_NOMCLI   NOME_CLI , 
_CDSQL += CHR(13) + CHR(10) + "               E1_EMISSAO  EMISSAO, 
_CDSQL += CHR(13) + CHR(10) + "               E1_VALOR    VALOR, 
_CDSQL += CHR(13) + CHR(10) + "               CASE 
_CDSQL += CHR(13) + CHR(10) + "	                 WHEN CONT IS NULL THEN 'N' 
_CDSQL += CHR(13) + CHR(10) + "                 ELSE 'S' 
_CDSQL += CHR(13) + CHR(10) + "               END         RESERVA, 
_CDSQL += CHR(13) + CHR(10) + "               CASE 
_CDSQL += CHR(13) + CHR(10) + "                   WHEN E1_VLRREAL > 0 THEN E1_VLRREAL
_CDSQL += CHR(13) + CHR(10) + "                   ELSE E1_VALOR
_CDSQL += CHR(13) + CHR(10) + "				END VLRREAL, 
_CDSQL += CHR(13) + CHR(10) + "               E1_VLRREAL - CASE 
_CDSQL += CHR(13) + CHR(10) + "                              WHEN E1_VLRREAL > 0 THEN E1_VALOR 
_CDSQL += CHR(13) + CHR(10) + "                              ELSE 0 
_CDSQL += CHR(13) + CHR(10) + "                            END    TAXA, 
_CDSQL += CHR(13) + CHR(10) + "               ISNULL(B.L1_FILIAL + '-' + B.L1_DOCPED + '/' + B.L1_SERPED, '')  ORIGINAL,
_CDSQL += CHR(13) + CHR(10) + "               ISNULL(B.L1_EMISSAO,'') AS EMISSAO_ORIGINAL,
_CDSQL += CHR(13) + CHR(10) + "			   'N'  BX_RESERVA
_CDSQL += CHR(13) + CHR(10) + "        FROM   SE1010 E1 WITH(NOLOCK) 
_CDSQL += CHR(13) + CHR(10) + "               LEFT OUTER JOIN (SELECT D2_FILIAL, 
_CDSQL += CHR(13) + CHR(10) + "                                       D2_PEDIDO, 
_CDSQL += CHR(13) + CHR(10) + "                                       D2_DOC, 
_CDSQL += CHR(13) + CHR(10) + "                                       D2_SERIE, 
_CDSQL += CHR(13) + CHR(10) + "                                       D2_CLIENTE, 
_CDSQL += CHR(13) + CHR(10) + "                                       D2_LOJA 
_CDSQL += CHR(13) + CHR(10) + "                                FROM   SD2010 D2 WITH(NOLOCK) 
_CDSQL += CHR(13) + CHR(10) + "                                WHERE  D_E_L_E_T_ = '' 
_CDSQL += CHR(13) + CHR(10) + "                                GROUP  BY D2_FILIAL, 
_CDSQL += CHR(13) + CHR(10) + "                                          D2_PEDIDO, 
_CDSQL += CHR(13) + CHR(10) + "                                          D2_DOC, 
_CDSQL += CHR(13) + CHR(10) + "                                          D2_SERIE, 
_CDSQL += CHR(13) + CHR(10) + "                                          D2_CLIENTE, 
_CDSQL += CHR(13) + CHR(10) + "                                          D2_LOJA) D2 
_CDSQL += CHR(13) + CHR(10) + "                            ON D2_DOC = E1_NUM 
_CDSQL += CHR(13) + CHR(10) + "                               AND D2_SERIE = E1_PREFIXO 
_CDSQL += CHR(13) + CHR(10) + "                               AND D2_FILIAL = E1_FILORIG 
_CDSQL += CHR(13) + CHR(10) + "               LEFT OUTER JOIN SF2010 F2 WITH(NOLOCK) 
_CDSQL += CHR(13) + CHR(10) + "                            ON F2_DOC = D2_DOC 
_CDSQL += CHR(13) + CHR(10) + "                               AND D2_FILIAL = F2_FILIAL 
_CDSQL += CHR(13) + CHR(10) + "                               AND F2_SERIE = D2_SERIE 
_CDSQL += CHR(13) + CHR(10) + "                               AND F2_COND = '178' 
_CDSQL += CHR(13) + CHR(10) + "               LEFT OUTER JOIN SL1010 A WITH(NOLOCK) 
_CDSQL += CHR(13) + CHR(10) + "                            ON L1_PEDRES = D2_PEDIDO 
_CDSQL += CHR(13) + CHR(10) + "                               AND D2_FILIAL = L1_FILIAL 
_CDSQL += CHR(13) + CHR(10) + "                               AND L1_PEDRES != ' ' 
_CDSQL += CHR(13) + CHR(10) + "               LEFT OUTER JOIN SL1010 B WITH(NOLOCK) 
_CDSQL += CHR(13) + CHR(10) + "                            ON B.L1_NUM = A.L1_ORCRES 
_CDSQL += CHR(13) + CHR(10) + "                               AND B.L1_FILIAL = A.L1_FILRES 
_CDSQL += CHR(13) + CHR(10) + "               LEFT OUTER JOIN SL1010 D WITH(NOLOCK) 
_CDSQL += CHR(13) + CHR(10) + "                            ON D.L1_DOCPED = E1_NUM 
_CDSQL += CHR(13) + CHR(10) + "                               AND D.L1_SERPED = E1_PREFIXO 
_CDSQL += CHR(13) + CHR(10) + "                               AND E1_FILORIG = D.L1_FILIAL 
_CDSQL += CHR(13) + CHR(10) + "                               AND D.D_E_L_E_T_ = '' 
_CDSQL += CHR(13) + CHR(10) + "               LEFT OUTER JOIN (SELECT L1_ORCRES, 
_CDSQL += CHR(13) + CHR(10) + "                                       L1_FILRES, 
_CDSQL += CHR(13) + CHR(10) + "                                       COUNT(*) CONT 
_CDSQL += CHR(13) + CHR(10) + "                                FROM   SL1010 WITH(NOLOCK) 
_CDSQL += CHR(13) + CHR(10) + "                                WHERE  L1_ORCRES != ' ' 
_CDSQL += CHR(13) + CHR(10) + "                                       AND D_E_L_E_T_ = '' 
_CDSQL += CHR(13) + CHR(10) + "                                GROUP  BY L1_ORCRES, 
_CDSQL += CHR(13) + CHR(10) + "                                          L1_FILRES)E 
_CDSQL += CHR(13) + CHR(10) + "                            ON D.L1_NUM = E.L1_ORCRES 
_CDSQL += CHR(13) + CHR(10) + "                               AND D.L1_FILIAL = E.L1_FILRES 
_CDSQL += CHR(13) + CHR(10) + "        WHERE  E1_EMISSAO BETWEEN @CDDATA01 AND @CDDATA02 
_CDSQL += CHR(13) + CHR(10) + "               AND E1_FILORIG BETWEEN @CDFILIAL01 AND @CDFILIAL02 
_CDSQL += CHR(13) + CHR(10) + "               AND E1.D_E_L_E_T_ = ' ' 

_CDSQL += CHR(13) + CHR(10) + "        UNION ALL 
		        
_CDSQL += CHR(13) + CHR(10) + "        SELECT F2_FILIAL                                                 FILIAL, 
_CDSQL += CHR(13) + CHR(10) + "               F2_DOC                                                    DOCUMENTO, 
_CDSQL += CHR(13) + CHR(10) + "               F2_SERIE                                                  SERIE, 
_CDSQL += CHR(13) + CHR(10) + "               CASE WHEN F2_COND = '178' THEN 'FI-' ELSE 'NF' END        TIPO, 
_CDSQL += CHR(13) + CHR(10) + "               ''                                                        BANCO, 
_CDSQL += CHR(13) + CHR(10) + "               F2_CLIENTE                                                CLIENTE , 
_CDSQL += CHR(13) + CHR(10) + "               F2_LOJA                                                   LOJA, 
_CDSQL += CHR(13) + CHR(10) + "               A1_NOME                                                   NOME_CLI, 
_CDSQL += CHR(13) + CHR(10) + "               F2_EMISSAO                                                EMISSAO , 
//_CDSQL += CHR(13) + CHR(10) + "               --F2_VALFAT VALOR,
_CDSQL += CHR(13) + CHR(10) + "               ISNULL(ISNULL(D.E1_VALOR, C.E1_VALOR),F2_VALBRUT)         VALOR, 
_CDSQL += CHR(13) + CHR(10) + "               'N'                                                       RESERVA , 
_CDSQL += CHR(13) + CHR(10) + "               ISNULL(ISNULL(D.E1_VLRREAL, C.E1_VLRREAL),F2_VALBRUT)     VLRREAL, 
_CDSQL += CHR(13) + CHR(10) + "               ISNULL(ISNULL(D.E1_VLRREAL, C.E1_VLRREAL),0) - CASE 
_CDSQL += CHR(13) + CHR(10) + "                              WHEN ISNULL(ISNULL(D.E1_VLRREAL, C.E1_VLRREAL),0) > 0 THEN ISNULL(ISNULL(D.E1_VALOR, C.E1_VALOR),0) 
_CDSQL += CHR(13) + CHR(10) + "                              ELSE 0 
_CDSQL += CHR(13) + CHR(10) + "                            END                                          TAXA, 
_CDSQL += CHR(13) + CHR(10) + "               ISNULL(L1_FILIAL + '-' + L1_DOCPED + '/' + L1_SERPED, '') ORIGINAL ,
_CDSQL += CHR(13) + CHR(10) + "               ISNULL(L1_EMISSAO, '') AS EMISSAO_ORIGINAL,
_CDSQL += CHR(13) + CHR(10) + "			   'S'  BX_RESERVA         
_CDSQL += CHR(13) + CHR(10) + "        FROM   (SELECT D2_FILIAL  F2_FILIAL, 
_CDSQL += CHR(13) + CHR(10) + "                       D2_DOC     F2_DOC, 
_CDSQL += CHR(13) + CHR(10) + "                       D2_SERIE   F2_SERIE, 
_CDSQL += CHR(13) + CHR(10) + "                       D2_CLIENTE F2_CLIENTE, 
_CDSQL += CHR(13) + CHR(10) + "                       D2_LOJA    F2_LOJA, 
_CDSQL += CHR(13) + CHR(10) + "                       D2_EMISSAO F2_EMISSAO, 
_CDSQL += CHR(13) + CHR(10) + "                       F2_COND, 
_CDSQL += CHR(13) + CHR(10) + "                       F2_VALBRUT,
_CDSQL += CHR(13) + CHR(10) + "                       D2_PEDIDO, 
_CDSQL += CHR(13) + CHR(10) + "                       B.L1_FILIAL, 
_CDSQL += CHR(13) + CHR(10) + "                       B.L1_DOCPED, 
_CDSQL += CHR(13) + CHR(10) + "                       B.L1_SERPED, 
_CDSQL += CHR(13) + CHR(10) + "                       B.L1_EMISSAO  
_CDSQL += CHR(13) + CHR(10) + "                FROM   SD2010 SD2 WITH (NOLOCK)                      
_CDSQL += CHR(13) + CHR(10) + "                       LEFT JOIN SF4010 SF4 WITH (NOLOCK) 
_CDSQL += CHR(13) + CHR(10) + "                              ON F4_CODIGO = D2_TES 
_CDSQL += CHR(13) + CHR(10) + "                                 AND SF4.D_E_L_E_T_ = '' 
_CDSQL += CHR(13) + CHR(10) + "                       LEFT OUTER JOIN SF2010 
_CDSQL += CHR(13) + CHR(10) + "                                    ON D2_DOC = F2_DOC 
_CDSQL += CHR(13) + CHR(10) + "                                       AND D2_SERIE = F2_SERIE 
_CDSQL += CHR(13) + CHR(10) + "                                       AND D2_FILIAL = F2_FILIAL 
_CDSQL += CHR(13) + CHR(10) + "                                       AND D2_CLIENTE = F2_CLIENTE 
_CDSQL += CHR(13) + CHR(10) + "                                       AND D2_LOJA = F2_LOJA 
_CDSQL += CHR(13) + CHR(10) + "                       LEFT OUTER JOIN SL1010 A WITH(NOLOCK) 
_CDSQL += CHR(13) + CHR(10) + "                                    ON L1_PEDRES = D2_PEDIDO 
_CDSQL += CHR(13) + CHR(10) + "                                       AND D2_FILIAL = L1_FILIAL 
_CDSQL += CHR(13) + CHR(10) + "                                       AND L1_PEDRES != ' ' 
_CDSQL += CHR(13) + CHR(10) + "                       LEFT OUTER JOIN SL1010 B WITH(NOLOCK) 
_CDSQL += CHR(13) + CHR(10) + "                                    ON B.L1_NUM = A.L1_ORCRES 
_CDSQL += CHR(13) + CHR(10) + "                                       AND B.L1_FILIAL = A.L1_FILRES 
_CDSQL += CHR(13) + CHR(10) + "                WHERE     ( SUBSTRING(D2_CF, 2, 3) IN ( '101', '102', '401', '405', '107', '108', '109', '110', 
_CDSQL += CHR(13) + CHR(10) + "					                                     '403', '404', '122', '118', '119' ) 
_CDSQL += CHR(13) + CHR(10) + "                             OR ( SUBSTRING(D2_CF, 2, 3) IN( '949' ) 
_CDSQL += CHR(13) + CHR(10) + "                                   AND F4_DUPLIC = 'S' ) ) 
_CDSQL += CHR(13) + CHR(10) + "                       AND D2_FILIAL BETWEEN '  ' AND 'ZZ' 
_CDSQL += CHR(13) + CHR(10) + "                       AND SD2.D_E_L_E_T_ = '' 
_CDSQL += CHR(13) + CHR(10) + "                       AND D2_EMISSAO BETWEEN @CDDATA01 AND @CDDATA02 
_CDSQL += CHR(13) + CHR(10) + "                       AND D2_FILIAL BETWEEN @CDFILIAL01 AND @CDFILIAL02 
_CDSQL += CHR(13) + CHR(10) + "                GROUP  BY D2_FILIAL, 
_CDSQL += CHR(13) + CHR(10) + "                          D2_DOC, 
_CDSQL += CHR(13) + CHR(10) + "                          D2_SERIE, 
_CDSQL += CHR(13) + CHR(10) + "                          D2_CLIENTE, 
_CDSQL += CHR(13) + CHR(10) + "                          D2_LOJA, 
_CDSQL += CHR(13) + CHR(10) + "                          D2_EMISSAO, 
_CDSQL += CHR(13) + CHR(10) + "                          F2_COND, 
_CDSQL += CHR(13) + CHR(10) + "                          F2_VALBRUT,
_CDSQL += CHR(13) + CHR(10) + "                          D2_PEDIDO, 
_CDSQL += CHR(13) + CHR(10) + "                          B.L1_FILIAL, 
_CDSQL += CHR(13) + CHR(10) + "                          B.L1_DOCPED, 
_CDSQL += CHR(13) + CHR(10) + "                          B.L1_EMISSAO, 
_CDSQL += CHR(13) + CHR(10) + "                          B.L1_SERPED) F2 

_CDSQL += CHR(13) + CHR(10) + "               LEFT OUTER JOIN (SELECT E1_FILIAL,E1_FILORIG,E1_NUM,E1_PREFIXO,E1_CLIENTE,E1_LOJA,E1_PARCELA,E1_TIPO,E1_VALOR,E1_VLRREAL 
_CDSQL += CHR(13) + CHR(10) + "			                    FROM SE1010 (NOLOCK) 
_CDSQL += CHR(13) + CHR(10) + "								WHERE D_E_L_E_T_ ='*'
_CDSQL += CHR(13) + CHR(10) + "			                    GROUP BY E1_FILIAL,E1_FILORIG,E1_NUM,E1_PREFIXO,E1_CLIENTE,E1_LOJA,E1_PARCELA,E1_TIPO,E1_VALOR,E1_VLRREAL) C 
_CDSQL += CHR(13) + CHR(10) + "								ON E1_NUM = F2_DOC 
_CDSQL += CHR(13) + CHR(10) + "                               AND E1_PREFIXO = F2_SERIE 
_CDSQL += CHR(13) + CHR(10) + "                               AND F2_FILIAL = E1_FILORIG 
_CDSQL += CHR(13) + CHR(10) + "			   LEFT OUTER JOIN (SELECT E1_FILIAL,E1_FILORIG,E1_NUM,E1_PREFIXO,E1_CLIENTE,E1_LOJA,E1_PARCELA,E1_TIPO,E1_VALOR,E1_VLRREAL 
_CDSQL += CHR(13) + CHR(10) + "			                    FROM SE1010 (NOLOCK)
_CDSQL += CHR(13) + CHR(10) + "								WHERE D_E_L_E_T_ =' '
_CDSQL += CHR(13) + CHR(10) + "			                    GROUP BY E1_FILIAL,E1_FILORIG,E1_NUM,E1_PREFIXO,E1_CLIENTE,E1_LOJA,E1_PARCELA,E1_TIPO,E1_VALOR,E1_VLRREAL) D
_CDSQL += CHR(13) + CHR(10) + "                            ON D.E1_NUM = F2_DOC 
_CDSQL += CHR(13) + CHR(10) + "                               AND D.E1_PREFIXO = F2_SERIE 
_CDSQL += CHR(13) + CHR(10) + "                               AND F2_FILIAL = D.E1_FILORIG 
//_CDSQL += CHR(13) + CHR(10) + "                               --AND C.D_E_L_E_T_ = '*' 
_CDSQL += CHR(13) + CHR(10) + "               LEFT JOIN SA1010 A1 (NOLOCK)
_CDSQL += CHR(13) + CHR(10) + "                      ON A1_COD = F2_CLIENTE 
_CDSQL += CHR(13) + CHR(10) + "                         AND A1_LOJA = F2_LOJA 
_CDSQL += CHR(13) + CHR(10) + "        WHERE  D.E1_NUM IS NULL ) DADOS 
_CDSQL += CHR(13) + CHR(10) + "       LEFT OUTER JOIN FV_SPLIT (@CDTIPOS, ';') A 
_CDSQL += CHR(13) + CHR(10) + "                    ON A.VALUE = TIPO 
_CDSQL += CHR(13) + CHR(10) + "				   AND LEN(RTRIM(A.VALUE)) > 0
//--LEFT OUTER JOIN FV_SPLIT (@CDTIPOS,';') B ON B.VALUE = TIPO 
_CDSQL += CHR(13) + CHR(10) + "WHERE  ( A.VALUE IS NOT NULL 
_CDSQL += CHR(13) + CHR(10) + "          OR LEN(RTRIM(@CDTIPOS)) = 0 ) 
_CDSQL += CHR(13) + CHR(10) + "       AND ( ( @CDTIPO = '1' 
_CDSQL += CHR(13) + CHR(10) + "               AND RESERVA = 'N' ) 
_CDSQL += CHR(13) + CHR(10) + "              OR ( @CDTIPO = '2' 
_CDSQL += CHR(13) + CHR(10) + "                   AND RESERVA = 'S' ) 
_CDSQL += CHR(13) + CHR(10) + "              OR @CDTIPO = '3' ) 
_CDSQL += CHR(13) + CHR(10) + "GROUP  BY FILIAL, 
_CDSQL += CHR(13) + CHR(10) + "          DOCUMENTO, 
_CDSQL += CHR(13) + CHR(10) + "          SERIE, 
_CDSQL += CHR(13) + CHR(10) + "          TIPO, 
_CDSQL += CHR(13) + CHR(10) + "          BANCO, 
_CDSQL += CHR(13) + CHR(10) + "          CLIENTE, 
_CDSQL += CHR(13) + CHR(10) + "          LOJA, 
_CDSQL += CHR(13) + CHR(10) + "          NOME_CLI, 
_CDSQL += CHR(13) + CHR(10) + "          EMISSAO, 
//          --VENCTO, 
_CDSQL += CHR(13) + CHR(10) + "          RESERVA, 
_CDSQL += CHR(13) + CHR(10) + "          ORIGINAL,
_CDSQL += CHR(13) + CHR(10) + "          EMISSAO_ORIGINAL, 
_CDSQL += CHR(13) + CHR(10) + "		     BX_RESERVA
		  
RETURN _CDSQL
