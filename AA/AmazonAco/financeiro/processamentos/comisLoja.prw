#INCLUDE "LOJA440.CH"
#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ LOJA440    ³ Autor ³ Vendas Clientes       ³ Data ³ 21/06/06³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calculo de comissoes off-line Sigaloja                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ LOJA440()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGALOJA                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function xLOJA440
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 													     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
Local nDecs 		:= MsDecimais(1)	// Informa qual o numero de casas decimais de acordo com o tipo de moeda informada: fonte original MATXFUNC.PRX
Local lSe1Exclusivo	:= .F.				// Flag que indica se SE1 esta EXCLUSIVO ou COMPARTILHADO (no SX2).
Local cFunction     := "LOJA440"
Local cPerg         := "LOJ440"  		//Perguntas relacionadas ao CRDA030
Local cTitle        := STR0003
Local cDescription  := STR0004 + STR0005
Local bProcess      := { |lEnd| Lj440DelE3(lEnd) , Lj440EComis(nDecs, lEnd), Lj440BComis(nDecs, lSe1Exclusivo, lEnd) }
Local aInfoCustom   := {}
Local nOpca 		:= 0				// Flag de confirmacao para OK ou CANCELA							
Local aSays			:= {} 		   		// Array com as mensagens explicativas da rotina
Local aButtons		:= {}		   		// Array com as perguntes (parametros) da rotina
Local aArea			:= GetArea()  		// Salva a area atual
Local cCadastro		:= STR0003 	   		//"C lculo de Comiss”es Off-Line"
Local lR1_1		    := GetRpoRelease() == "R1.1" //Verifica se o Release e' o R1.1 do Protheus 10
Local lComissOff		:= SuperGetMV("MV_TPCOMLJ",,"B") == "B" //Flag para verificacao do tipo de comissao utilizada

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Parametros: 																 ³
//³ MV_PAR01 = Data Inicial?		 										 ³
//³ MV_PAR02 = Data Final?			  										 ³
//³ MV_PAR03 = Do Vendedor? 		  										 ³
//³ MV_PAR04 = At‚ o Vendedor? 	  											 ³
//³ MV_PAR05 = Calcula Para? Emissao, Baixas ou Ambas?                       ³
//³ MV_PAR06 = Considera Juros?	  Sim/NÆo									 ³
//³ MV_PAR07 = Considera Descontos? Sim/NÆo									 ³
//³ MV_PAR08 = Prioriade de calculo? Cliente/Produto/Vendedor/Venda			 ³
//³ MV_PAR09 = Filtro por filial ? Sim/Nao                          		 ³
//³ MV_PAR10 = Filial de:                                           		 ³
//³ MV_PAR11 = Filial ate:                                          		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³Conversao de variaveis PRIVATE                                     ³
  ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³ANTES          ³                 DEPOIS                            ³
  ³PRIVATE        ³                 LOCAL                             ³
  ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³nDecs          ³                 nDecs                             ³
  ³lSEExc		  ³                 lSe1Exclusivo                     ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

If !LjxEMod("SE1")
	lSe1Exclusivo := .T.		
Endif

If lR1_1
	tNewProcess():New(cFunction,cTitle,bProcess,cDescription,cPerg,aInfoCustom )
Else
	Pergunte("LOJ440",.F.)
	
	AADD(aSays, STR0004 ) //"Este programa tem como objetivo executar os c lculos das comiss”es dos"
	AADD(aSays, STR0005 ) //"Vendedores, conforme os parƒmetros definidos pelo usu rio.              "
	
	AADD(aButtons, { 5,.T.,{|| Pergunte("LOJ440",.T. ) } } )
	AADD(aButtons, { 1,.T.,{|o| nOpca := 1 , o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	
	
	FormBatch( cCadastro, aSays, aButtons )
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se o usuario confirmou a operacao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( nOpcA == 1)
		If lComissOff //Verifica se parametro Comissao OffLine configurado corretamente
			If AllTrim(SuperGetMV("MV_TPCOMLJ",,"B")) == AllTrim(SuperGetMV("MV_TPCOMISS",,"B")) //Compara parametro comissao Varejo e Financeiro
				Processa({|lEnd| Lj440DelE3()},STR0007)  //"Excluindo Comiss”es n„o pagas"
				
				If MV_PAR05 == 1 .OR. MV_PAR05 == 3					//calcula comissao para Emissao ou Ambas
					Processa({|lEnd| Lj440ProcE(nDecs)},STR0008) //"Calculando Comiss”es pela Emiss„o"
				Endif
				
				If MV_PAR05 == 2 .OR. MV_PAR05 == 3
					
					If MV_PAR08 == 2
						// "A comissão por baixa nao esta adaptada para trabalhar com prioridade por produto. 
						// Sera utilizado a comissao em prioridade por vendedor. Deseja mesmo assim utiliza-la?"
						If MsgYesNo( STR0010 )
							Processa({|lEnd| Lj440ProcB(nDecs, lSe1Exclusivo)}, STR0009) //"Calculando Comiss”es pela Baixa"
						Endif
					Else
						Processa({|lEnd| Lj440ProcB(nDecs, lSe1Exclusivo)},STR0009) //"Calculando Comiss”es pela Baixa"
					Endif				
				Endif
			Else
				//"Divergência entre os parâmetros do tipo de cálculo de comissão varejo MV_TPCOMLJ"
				//"e o tipo de cáculo de comissão financeiro MV_TPCOMIS"
				//"devem estar configurados com o mesmo conteúdo."
				Alert("Divergência entre os parâmetros do tipo de cálculo de comissão varejo MV_TPCOMLJ")
			EndIf
		Else
			Alert("Sistema não está configurado para calcular comissão de vendedor Off-line, verifique o conteúdo do parâmetro MV_TPCOMLJ") //#"Sistema não está configurado para calcular comissão de vendedor Off-line, verifique o conteúdo do parâmetro MV_TPCOMLJ"
		EndIf
	Endif
	
	RestArea(aArea)
EndIf	

Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³Lj440EComis ³ Autor ³ Vendas Clientes       ³ Data ³ 21/06/06³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chama funcao para calcular comissoes pela emissao           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ LOJA440()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGALOJA                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Lj440EComis(nDecs, lEnd)

lEnd:IncRegua1(STR0025)	//"Calculo de comissões"
If MV_PAR05 == 1 .OR. MV_PAR05 == 3
	Lj440ProcE(nDecs, lEnd)
Endif                      

lEnd:SetRegua2(1)
lEnd:IncRegua2(STR0026)	//"Calculando Comissões pela Emissão"

Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³Lj440BComis ³ Autor ³ Vendas Clientes       ³ Data ³ 21/06/06³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chama funcao para calcular comissoes pela Baixa	           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ LOJA440()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGALOJA                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Lj440BComis(nDecs, lSe1Exclusivo, lEnd)

lEnd:IncRegua1(STR0025)	//"Calculo de comissões"
If MV_PAR05 == 2 .OR. MV_PAR05 == 3
	
	If MV_PAR08 == 2
		// "A comissão por baixa nao esta adaptada para trabalhar com prioridade por produto. 
		// Sera utilizado a comissao em prioridade por vendedor. Deseja mesmo assim utiliza-la?"
		If MsgYesNo( STR0010 )
			Lj440ProcB(nDecs, lSe1Exclusivo, NIL, lEnd) //"Calculando Comiss”es pela Baixa"
		Endif
	Else
		Lj440ProcB(nDecs, lSe1Exclusivo, NIL, lEnd) //"Calculando Comiss”es pela Baixa"
	Endif
Else
	lEnd:SetRegua2(1)
	lEnd:IncRegua2(STR0027)	//"Calculando Comiss”es pela Baixa"
Endif

Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡„o    ³lj440DelE3   ³ Autor ³ Vendas Cliente        ³ Data ³21/06/06³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Zera as comissoes do periodo                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA440                                                     ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function lj440DelE3(lEnd)
Local aArea      := GetArea() // Armazena a area atual
Local cQuery     := ""        // Filtro que sera realizado na query
Local cArqInd    := ""
Local cChave     := ""
Local lR1_1		 := GetRpoRelease() == "R1.1" //Verifica se o Release e' o R1.1 do Protheus 10

#IFDEF TOP
	Local lQuery     := .F.       //Indica se sera executada a query
	Local nMax       := 0         //Variavel para utilizacao do controle na exclusao de registros
	Local nMin       := 0         //Variavel para utilizacao do controle na exclusao de registros
	Local cAliasSE3  := "SE3"     //Alias da query
	Local nX         := 0         //Variavel For
#ELSE
	Local nIndex     := ""
#ENDIF

ProcRegua(SE3->(RecCount()))

If lR1_1
	lEnd:SetRegua1(3)
	lEnd:IncRegua1(STR0025)		//"Calculo de comissões"
	lEnd:SetRegua2(3)
	lEnd:IncRegua2(STR0028)		//"Excluindo Comissões não pagas"
EndIf
#IFDEF TOP
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verificar se eh AS/400, pois a coluna R_E_C_N_O_ nao existe em AS/400³
	//³dessa forma a condicao ira ser a do codebase                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If ( TcSrvType()<>"AS/400" )
		
		lQuery := .T.
		
		cAliasSE3 := "QRYSE3"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica qual eh o maior e o menor Recno que satisfaca a selecao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "SELECT 	MIN(R_E_C_N_O_) MINRECNO,"
		cQuery += "MAX(R_E_C_N_O_) MAXRECNO 		 "
		cQuery += "FROM " 			+ RetSqlName("SE3")						+ " SE3 "
		cQuery += " WHERE "
		cQuery += "E3_FILIAL = '" 	+ xFilial( "SE3" ) 						+ "' AND "
		cQuery += "E3_EMISSAO >= '"	+ DtoS( MV_PAR01 ) 						+ "' AND "
		cQuery += "E3_EMISSAO <= '"	+ DtoS( MV_PAR02 ) 						+ "' AND "
		cQuery += "E3_VEND	>= '"   + MV_PAR03                              + "' AND "
		cQuery += "E3_VEND	<= '"   + MV_PAR04                              + "' AND "
		cQuery += "E3_DATA  =  '" 	+ Space( Len( DToS( SE3->E3_DATA ) ) ) + "' AND "
		cQuery += "E3_ORIGEM = 'L' AND "
		cQuery += "SE3.D_E_L_E_T_ = ' '"
		
		cQuery := ChangeQuery(cQuery)
		
		DbUseArea(.T., "TOPCONN", TcGenQry( , , cQuery), "FA440DELE3")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Armazena o registro minimo e o maximo para executar a selecao correta³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nMax := FA440DELE3->MAXRECNO
		nMin := FA440DELE3->MINRECNO
		
		DbCloseArea()
		DbSelectArea("SE3")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Executa o delete fisico diretamente no banco, dessa forma a exclusao  ³
		//³ficara mais rapida e aumentara a performance de qualquer processo que ³
		//³execute o SE3 pois a tabela nao ficara saturada.                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		cQuery := "DELETE FROM "        + RetSqlName("SE3") 					+ " "
		cQuery += "WHERE E3_FILIAL = '" + xFilial("SE3")    					+ "' AND "
		cQuery += "E3_EMISSAO >= '"     + DtoS( MV_PAR01 )  					+ "' AND "
		cQuery += "E3_EMISSAO <= '"     + DtoS( MV_PAR02 )  					+ "' AND "
		cQuery += "E3_VEND	>= '"    	+ MV_PAR03                              + "' AND "
		cQuery += "E3_VEND	<= '"		+ MV_PAR04                              + "' AND "		
		cQuery += "E3_DATA = '"         + Space( Len( DToS( SE3->E3_DATA ) ) )	+ "' AND "
		cQuery += "E3_ORIGEM = 'L' AND "
		cQuery += "D_E_L_E_T_ = ' '"
        
		If lR1_1
			lEnd:IncRegua2(STR0028)		//"Excluindo Comissões não pagas"
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Executa a string de execucao no banco para os proximos 1024 registro a fim de nao estourar o log do SGBD³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		For nX := nMin To nMax STEP 1024
			IncProc()
			cChave := " AND R_E_C_N_O_>=" + Str(nX, 10, 0) + " AND R_E_C_N_O_<=" + Str(nX + 1023, 10, 0) + ""
			TcSqlExec(cQuery+cChave) 
		Next nX
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³A tabela eh fechada para restaurar o buffer da aplicacao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SE3")
		DbCloseArea()
		ChkFile("SE3",.F.)
	Else
#ENDIF
		DbSelectArea("SE3")
		DbSetOrder(1)
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso for Codebase ou for AS/400³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := 'E3_FILIAL=="'		+ xFilial("SE3") 	+ '".AND. '
		cQuery += 'Dtos(E3_EMISSAO)>="'	+ Dtos(MV_PAR01) 	+ '".AND. '
		cQuery += 'Dtos(E3_EMISSAO)<="'	+ Dtos(MV_PAR02) 	+ '".AND. '
		cQuery += 'E3_VEND	>= "'    	+ MV_PAR03			+ '".AND. '
		cQuery += 'E3_VEND	<= "'		+ MV_PAR04			+ '".AND. '		
		cQuery += 'Dtos(E3_DATA)=="'	+ Dtos(cTod(""))	+ '".AND. '
		cQuery += 'E3_ORIGEM == "L"'
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Filtra com Indregua os registros que atenderem a solicitacao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cArqInd  := CriaTrab(,.F.)
		cChave   := IndexKey()
		IndRegua("SE3",cArqInd,cChave,,cQuery,STR0006)  //"Selecionando Registros..."
		nIndex := RetIndex("SE3")
		DbSelectArea("SE3")
		#IFNDEF TOP
			DbSetIndex(cArqInd+OrDbagExt())
		#ENDIF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Prepara a delecao dos registros³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SE3")
		DbSetOrder(nIndex+1)
		DbSeek(xFilial("SE3"),.T.)
		
		While ( ! Eof() .AND. xFilial("SE3") == SE3->E3_FILIAL )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Executa a delecao dos registros³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RecLock("SE3",.F.)
			DbDelete()
			MsUnlock()
			DbSelectArea("SE3")
			DbSkip()
			IncProc()
		End
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Restaura os indices padroes da tabela SE3³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SE3")
		RetIndex("SE3")
		DbClearFilter()
		FErase(cArqInd + OrDbagExt())
#IFDEF TOP
	Endif
#ENDIF

If lR1_1
	lEnd:IncRegua2(STR0028)		//"Excluindo Comissões não pagas"
EndIf	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a area de trabalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea( aArea )

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³lj440ProcB   ³ Autor ³ Vendas Clientes       ³ Data ³21/06/06³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Processa o c lculo das comissoes pelas Baixas                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Casas decimais                                      ³±±
±±³			 ³ ExpL2 = Se o SE1 eh exclusivo.      					       ³±±
±±³			 ³ ExpL3 = Se a chamada eh do FINA070  					       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³LOJA440                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LJ440ProcB( nDecs, lSe1Exclusivo, lFina070, lEnd )

Local lVendaLoja	:= .F.											// Verifica se vai gerar SE3
Local cChaveSE5		:= ""											// Chave a ser utilizada no SE5
Local nComissao		:= 0											// Valor da comissao
Local lDevolucao	:= SuperGetMv("MV_COMIDEV")						// Verifica se considera devolucao
Local lSE3found		:= .F.											// Valida se encontrou o registro no SE3
Local nSe5Valor		:= 0											// Valor do E5_VALOR
Local nMoeda		:= 1											// Moeda utilizada
Local cSerie		:= ""											// Serie do titulo gerado
Local cPrefixo		:= ""											// Prefixo do titulo gerado
Local nPerc 		:= 0											// Percentual de comissao
Local lComisCC		:= ( Upper(SuperGetMV( "MV_COMISCC" )) == "S" )// Valida se considera valor inteiro ou valor real
Local nReg			:= 0											// Recno do SE5
Local nPercFret		:= 0											// Se nao calcular comissao com frete, calcula proporcional
Local cFilDe    	:= ""											// Filial De
Local cFilAte   	:= ""											// Filial Ate
Local cFilSE5   	:= ""											// Filial do SE5
Local cFilOriE5 	:= ""											// Filial de origem do SE5
Local cGerente		:= ""											// Gerente do vendedor
Local cSupervisor	:= ""											// Supervisor do vendedor
Local cQuery    	:= ""											// Utilizada para montagegem da query
Local lTop      	:= .F.				    						// Indica se utiliza BD
Local cAliasSE5		:= "TMPE5"										// Alias SE5 quando utiliza Query
Local cCond			:= ""	    									// Variavel utilizada para compor o While do arquivo SL1
Local cCondic		:= ""	    									// Variavel utilizada para compor o While do arquivo S
Local aStrutSE5 	:= {}											// Array utilizada para guardar a estrutura de alguns campos do SE5
Local nX 			:= 0											// Variavel para FOR
Local cAliasSL1		:= "TMPL1"										// Alias SL1 quando utiliza Query
Local aStrutSL1		:= {}											// Array utilizada para guardar a estrutura de alguns campos do SL1
Local nOpca			:= 0											// Opcao escolhida
Local nCheck1		:= 0											// Check1
Local nCheck2		:= 0											// Check2
Local nCheck3		:= 0											// Check3
Local lCont			:= .T.											// Se continua operacao
Local nMV_PAR01														// Primeiro parametro default do FINA070
Local nMV_PAR02														// Segundo parametro default do FINA070
Local nMV_PAR03														// Terceiro parametro default do FINA070
Local nMV_PAR04														// Quarto parametro default do FINA070
Local nMV_PAR05														// Quinto parametro default do FINA070
Local nMV_PAR06														// Sexto parametro default do FINA070
Local nMV_PAR07														// Setimo parametro default do FINA070
Local nMV_PAR08														// Oitavo parametro default do FINA070
Local nMV_PAR09            											// Nono parametro default do FINA070
Local oDlgBx														// Objeto para baixa
Local oFont															// Fonte para letras
Local oCheck1                        								// Objeto para o Check1
Local oCheck2                                                     	// Objeto para o Check2
Local oCheck3            											// Objeto para o Check3
Local lR1_1			:= GetRpoRelease() == "R1.1"					// Verifica se o Release e' o R1.1 do Protheus 10
Local aAreaSe5		:= {}
Local aVendedor		:= {}											// Lista de vendedores da venda
Local nVend			:= 0											// Numero do vendedor atual
Local nTamA3_COD	:= TamSX3("A3_COD")[1]							// Tamanho do campo A3_COD
Local cTpComiss		:= SuperGetMv("MV_LJTPCOM",,"1")				// Tipo de calculo de comissao utilizado (1-Para toda a venda (padrao),2-Por item)
Local nComRep		:= 0                   							// Valor que a comissao representa no total da venda
Local nDifComis		:= 0											// Diferenca na Comissao 
Local nTotComis		:= 0											// Total ja baixado
Local nDecimal  	:= TamSX3("E3_BASE")[2]							// Numero de casas decimais 
Local lPedido 		:= .F.  										// Indica se o orçamento gerou Pedido
Local nValPgNCC 	:= 0 											// Valor pago utilizando NCC
Local lUsouNcc  	:= .F.                                          // Usou NCC como forma de pagamento
Local aBasesVend    := {}											// Array com os dados de comissao do vendedor.  
Local nValEmissao   := 0
Local nPosVend		:= 0 											// posicao do campo E3_VEND no array aSE3
Local nI			:= 0											// contador
Local aSE3			:= {}											// array com os dados do orcamento a serem gravados
Local cAliasTmp		:= GetNextAlias()										//Alias da Consulta de devolução
Local aAreaSF1		:= {} 											
Local aAreaSD1		:= {}
Local aAreaSE5		:= {}

Default nDecs 	 	  := MsDecimais(1)
Default lSe1Exclusivo := If(!LjxEMod("SE1"),.T.,.F.)
Default lFina070      := .F.

If lR1_1 .AND. ValType(lEnd) == "O"
	lEnd:SetRegua2(5)
	lEnd:IncRegua2(STR0034)		//"Iniciando o cálculo de comissões pela baixa"
EndIf  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtro por filial (caso o usuario selecione)                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lFina070
	If MV_PAR09 == 1
		cFilDe  := MV_PAR10
		cFilAte := MV_PAR11
	Else
		cFilDe := cFilAte := SE5->( xFilial( "SE5" ) )
	Endif
Else
	If Funname() == "FINA070" //No caso de outra rotina, chamar "FINA070" via execauto
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicializa a tela³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DEFINE MSDIALOG oDlgBx FROM 39,85 TO 450,340 TITLE STR0011 PIXEL OF oMainWnd  								//"Calculo de comissao OnLine" 
		DEFINE FONT oFont NAME "Ms Sans Serif" BOLD
		//ÚÄÄÄÄÄÄÄÄÄÄ¿
		//³Introducao³
		//ÀÄÄÄÄÄÄÄÄÄÄÙ
		@ 7, 4 TO 50, 121 LABEL STR0012 OF oDlgBx  PIXEL 															// Objetivo
		@ 19, 15 SAY (STR0013) SIZE 100, 40 OF oDlgBx PIXEL FONT oFont   											//"Definir a regra do calculo de comissão Online"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Primeira opcao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@ 55,4 TO 83,121 LABEL STR0014 OF oDlgBx  PIXEL 															//"Considera juros ? "
		@ 62,10 RADIO oCheck1 VAR nCheck1 3D SIZE 60,10 PROMPT STR0015, STR0016 OF oDlgBx PIXEL 					//"Sim", "Não"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Segunda opcao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@ 86,4 TO 115,121 LABEL STR0017 OF oDlgBx  PIXEL 															//"Considera descontos ? "
		@ 94,10 RADIO oCheck2 VAR nCheck2 3D SIZE 60,10 PROMPT STR0015, STR0016 OF oDlgBx PIXEL 					// "Sim", "Não"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Terceira opcao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@ 120,4 TO 167,121 LABEL STR0018 OF oDlgBx  PIXEL //"Prioridade : "
		@ 128,10 RADIO oCheck3 VAR nCheck3 3D SIZE 60,10 PROMPT STR0019, STR0020, STR0021, STR0022 OF oDlgBx PIXEL 	//"Cliente", "Produto", "Vendedor", "Venda"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Botao para "Confirmar"³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DEFINE SBUTTON FROM 190, 65 TYPE 1;		
		ACTION (nOpca := 1,IF(MsgYesNo(STR0023,STR0024),oDlgBx:End(),nOpca:=0)) ENABLE OF oDlgBx  				// "Confirma o processamento da comissão?","Atenção"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Botao para "Cancelar"³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DEFINE SBUTTON FROM 190, 94 TYPE 2;
		ACTION ( oDlgBx:End(), lCont := .F. ) ENABLE OF oDlgBx
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Finaliza tela³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ACTIVATE MSDIALOG oDlgBx CENTERED
	
		If !lCont
			Return NIL	
		EndIf
		
	EndIf	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Armazena os parametros do FINA070 para depois³
	//³restaurar                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nMV_PAR01 := MV_PAR01
	nMV_PAR02 := MV_PAR02
	nMV_PAR03 := MV_PAR03
	nMV_PAR04 := MV_PAR04
	nMV_PAR05 := MV_PAR05
	nMV_PAR06 := MV_PAR06
	nMV_PAR07 := MV_PAR07
	nMV_PAR08 := MV_PAR08
	nMV_PAR09 := MV_PAR09
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define os parametros para gerar comissao online³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cFilDe 		:= cFilAte := SE5->( xFilial( "SE5" ) )
	MV_PAR01 	:= SE1->E1_EMISSAO
	MV_PAR02 	:= SE1->E1_EMISSAO
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se for comissao por venda, assume apenas o vendedor do titulo,³
	//³caso contrario (por item), seleciona todos os vendedores      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cTpComiss == "1"
		MV_PAR03	:= SE1->E1_VEND1
		MV_PAR04	:= SE1->E1_VEND1
	Else
		MV_PAR03	:= Space(nTamA3_COD)
		MV_PAR04	:= Replicate("z",nTamA3_COD)
	EndIf
	MV_PAR05	:= 2
	MV_PAR06	:= nCheck1
	MV_PAR07	:= nCheck2		
	MV_PAR08	:= nCheck3
	MV_PAR09	:= 2
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ A rotina esta considerando o vendedor pricipal da venda (L1_VEND)   ³
//³ pois nao ha identificacao de valor baixado em relacao a um item ven-³
//³ dido. - Nao alterar ***                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lR1_1 .AND. ValType(lEnd) == "O"
	lEnd:IncRegua2(STR0035)		//"Filtrando dados para o cálculo de comissões pela baixa"
EndIf
#IFDEF TOP
		lTop := .T.
		cQuery := "SELECT 	E5_PREFIXO , E5_NUMERO , E5_PARCELA, E5_TIPO  , "
		cQuery += 			"E5_CLIFOR , E5_LOJA   , E5_FILORIG, E5_DATA  , "
		cQuery += 			"E5_RECPAG , E5_DOCUMEN, E5_TIPODOC, E5_SEQ   , "
		cQuery += 			"E5_MOTBX  , E5_BANCO  , E5_AGENCIA, E5_CONTA , "
		cQuery += 			"E5_VALOR  , E5_FILIAL"
		cQuery += " FROM " + RetSqlName("SE5")
		cQuery += " WHERE	E5_DATA >= '" + DtoS(MV_PAR01) + "' AND E5_DATA <= '" + DtoS(MV_PAR02) + "'"		
		If lSe1Exclusivo 
			cQuery += " AND E5_FILIAL >= '" + cFilDe + "'"
			cQuery += " AND E5_FILIAL <= '" + cFilAte + "'"
		EndIf
		cQuery += 	" AND D_E_L_E_T_ <> '*'"
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T., "TOPCONN", TcGenQry( , , cQuery), cAliasSE5)
#ENDIF

If lR1_1 .AND. ValType(lEnd) == "O"
	lEnd:IncRegua2(STR0036)		//"Montando estrutura para o comissões pela baixa"
EndIf
If lTop
	AADD(aStrutSE5, {"E5_VALOR"	, "", "", ""} )
	AADD(aStrutSE5, {"E5_DATA"	, "", "", ""} )
	LJ440Stru(@aStrutSE5, "SE5")
	If (cAliasSE5)->(!Eof())
		For nX := 1 To Len(aStrutSE5)
			TcSetField(cAliasSE5, aStrutSE5[nX,1], aStrutSE5[nX,2], aStrutSE5[nX,3], aStrutSE5[nX,4])
		Next nX
	EndIf
	AADD(aStrutSL1, {"L1_MOEDA"		, "", "", ""} )
	AADD(aStrutSL1, {"L1_EMISNF"	, "", "", ""} )
	AADD(aStrutSL1, {"L1_JUROS"		, "", "", ""} )
	AADD(aStrutSL1, {"L1_FRETE"		, "", "", ""} )
	AADD(aStrutSL1, {"L1_SEGURO"	, "", "", ""} )
	AADD(aStrutSL1, {"L1_DESPESA"	, "", "", ""} )
	AADD(aStrutSL1, {"L1_ABTOPCC"	, "", "", ""} )
	AADD(aStrutSL1, {"L1_CARTAO"	, "", "", ""} )
	LJ440Stru(@aStrutSL1, "SL1")

	cCond := "!Eof()"  // Se o banco estiver em TOP a selecao sera somente ate EOF porque ja existe uma QUERY antes
	DbSelectArea(cAliasSE5)
Else
	cAliasSL1 := "SL1"
	cAliasSE5 := "SE5"
	DbSelectArea(cAliasSE5)
	DbSeek(If( lSe1Exclusivo, cFilDe, xFilial( "SE5" ) ) + DtoS( MV_PAR01 ) , .T. )
	cCond := "!Eof() .AND. SE5->E5_DATA <= MV_PAR02"
Endif

If lR1_1 .AND. ValType(lEnd) == "O"
	lEnd:IncRegua2(STR0037)		//"Buscando dados para o cálculo de comissões pela baixa"
EndIf
While &cCond
	If !lTop .AND. lSe1Exclusivo
		If (cAliasSE5)->E5_FILIAL > cFilAte
			Exit
		Endif			
	Endif	
	
	If ( !lSe1Exclusivo .AND. ! ( (cAliasSE5)->E5_FILORIG >= cFilDe .AND. (cAliasSE5)->E5_FILORIG <= cFilAte ) )
		DbSkip()
		Loop
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chama ponto de entrada LJ440VLD³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*If ExistBlock( "LJ440VLD" ) .AND. ! ExecBlock( "LJ440VLD", .F., .F., 2 )
		DbSkip()
		Loop
	Endif*/
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe estorno para esta baixa                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If TemBxCanc(	(cAliasSE5)->E5_PREFIXO + (cAliasSE5)->E5_NUMERO + ;
					(cAliasSE5)->E5_PARCELA + (cAliasSE5)->E5_TIPO   + ;
					(cAliasSE5)->E5_CLIFOR  + (cAliasSE5)->E5_LOJA   + ;
					(cAliasSE5)->E5_SEQ )                       
					
		DbSkip()
		Loop
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra somente as baixas a Receber                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !((cAliasSE5)->E5_TIPODOC $ "VL/BA/LJ") .OR. (cAliasSE5)->E5_RECPAG == "P"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Trata Trocas da Loja para aplicar NCC na Comissao  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cAliasSE5)->E5_TIPODOC == "CP"
			// Se o Documento for referente a uma NCC
			If SubStr((cAliasSE5)->E5_DOCUMEN,11,3) == "NCC"
				// Localiza a NCC para validar este Credito
				cNumero := GetAdvFval("SE5", "E5_NUMERO", SubStr((cAliasSE5)->E5_DOCUMEN, 14, 02) + ;
										SubStr( (cAliasSE5)->E5_DOCUMEN, 01, 13), 7, "Erro" )
				If Empty(cNumero)
					DbSkip()
					Loop
				Endif
			Endif
		Else
			// Mantido Tratamento Inicial
			If !((cAliasSE5)->E5_TIPODOC $ "VL/BA/LJ") .OR. (cAliasSE5)->E5_RECPAG == "P"
				DbSkip()
				Loop
			Endif
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se foi gerado titulo e se foi baixado                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( (cAliasSE5)->E5_TIPODOC $ "BA" )
		nReg := Recno()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca o registro no E1 para verificar se foi gerado título no Financeiro pois o ³
		//³usuário pode transformar 1 ou mais vendas em um único título e editar o prefixo ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SE1->( DbSetOrder( 1 ) )
		If SE1->( DbSeek ( (cAliasSE5)->E5_FILIAL + (cAliasSE5)->E5_PREFIXO + (cAliasSE5)->E5_NUMERO ) )
			If AllTrim( SE1->E1_FATURA ) <> ""
				SE5->( DbSetOrder( 7 ) )
				If SE5->( DbSeek( SE1->E1_FILIAL + SE1->E1_FATPREF	+ SE1->E1_FATURA ) )
					If TemBxCanc(	(cAliasSE5)->E5_PREFIXO	+ (cAliasSE5)->E5_NUMERO + (cAliasSE5)->E5_PARCELA	+ ;
									(cAliasSE5)->E5_TIPO	+ (cAliasSE5)->E5_CLIFOR + (cAliasSE5)->E5_LOJA	+ ;
									(cAliasSE5)->E5_SEQ )
					
						DbSelectArea( cAliasSE5 )
						If !lTop
							DbSetOrder( 1 )
							DbGoTo( nReg )
						EndIf
						DbSkip()
						Loop
					Else
						If !lTop
							DbSelectArea( cAliasSE5 )
							DbGoTo( nReg )
						EndIf
				    EndIf
				Else
					If !lTop
						SE5->( DbSetOrder( 1 ) )
						DbGoTo( nReg + 1 )
					Else
						(cAliasSE5)->(dbSkip())
					EndIf
					Loop
				Endif
			Endif
		Endif
	Endif
	
	If !lDevolucao
		If (cAliasSE5)->E5_MOTBX == "DEV"
			(cAliasSE5)->( DbSkip() )
			Loop
		Endif
	Endif
	
	cChaveSe5:=	(cAliasSE5)->E5_PREFIXO	+ (cAliasSE5)->E5_NUMERO 		+ (cAliasSE5)->E5_PARCELA + ;
				(cAliasSE5)->E5_TIPO 	+ Dtos( (cAliasSE5)->E5_DATA ) + (cAliasSE5)->E5_CLIFOR

	cSerie		:= LJSE5SERIE( If(MV_PAR09 == 1, (cAliasSE5)->E5_FILIAL, Nil), cAliasSE5 )
	cFilSE5		:= (cAliasSE5)->E5_FILIAL
	
	lVendaLoja := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se trata-se de um venda via SIGALOJA                    ³
	//³ Verifica o intervalo de vendedor selecionado                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca o registro no E1 para verificar se foi gerado título no Financeiro pois o ³
	//³usuário pode transformar 1 ou mais vendas em um único título e editar o prefixo ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SE1->( DbSetOrder( 1 ) )
	SE1->( DbSeek( (cAliasSE5)->E5_FILIAL 	+ (cAliasSE5)->E5_PREFIXO + (cAliasSE5)->E5_NUMERO + ;
					(cAliasSE5)->E5_PARCELA	+ (cAliasSE5)->E5_TIPO ) )
	
	
	If !Empty( xFilial( "SL1" ) )
		cFilOriE5 := SE1->E1_FILORIG
	Else
		cFilOriE5 := Space(FWGETTAMFILIAL)
	Endif
	If !lTop
		DbSelectArea("SL1")
		DbSetOrder( 2 )			//L1_FILIAL+L1_SERIE+L1_DOC+L1_PDV

		lOkSL1 := ( DbSeek( cFilOriE5 + cSerie + (cAliasSE5)->E5_NUMERO )	.AND. ;
						 	(cAliasSL1)->L1_VEND >= MV_PAR03 			    .AND. ;
							(cAliasSL1)->L1_VEND <= MV_PAR04 )
	Else
		lOkSL1 := LJ440ExeQryL1(@cQuery, aStrutSL1, cAliasSL1, cFilOriE5, ;
								cSerie, (cAliasSE5)->E5_NUMERO, 2, Nil, ;
								Nil   , cTpComiss)
	EndIf
	If lOkSL1  
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se foi gerado Pedido				           			 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lPedido:= (AllTrim((cAliasSL1)->L1_SERPED+(cAliasSL1)->L1_DOCPED) <> "")  
		If lPedido
			cCondic := "'" + cFilOriE5 + "' == '" + (cAliasSL1)->L1_FILIAL + "' "
			cCondic += ".AND. '" + cSerie + "' == '" + (cAliasSL1)->L1_SERPED + "' "
			cCondic += ".AND. '" + (cAliasSE5)->E5_NUMERO + "' == '" + (cAliasSL1)->L1_DOCPED + "'"
		Else
			cCondic := "'" + cFilOriE5 + "' == '" + (cAliasSL1)->L1_FILIAL + "' "
			cCondic += ".AND. '" + cSerie + "' == '" + (cAliasSL1)->L1_SERIE + "' "
			cCondic += ".AND. '" + (cAliasSE5)->E5_NUMERO + "' == '" + (cAliasSL1)->L1_DOC + "'"
		EndIf           
		
		While (cAliasSL1)->(!Eof()) .AND. !lVendaloja .AND. &cCondic
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifico se o orcamento possui devolucao total³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If LJ440DevTotal( If( cPaisLoc == "BRA", (cAliasSE5)->E5_FILORIG, cFilOriE5 ), (cAliasSL1)->L1_NUM, cAliasSE5 )
				(cAliasSL1)->( DbSkip() )
				Loop
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Testamos CC de maneira separada em virtude dessa  forma de pgto gerar um codigo de cliente com o mesmo   ³
			//³ mesmo codigo da Adm. de Cartao, isso se deve ao fato do titulo nessa forma ser contra essa Administradora³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ      
			If ( (cAliasSE5)->E5_CLIFOR == (cAliasSL1)->L1_CLIENTE .AND. (cAliasSE5)->E5_LOJA == (cAliasSL1)->L1_LOJA) .OR. ;
				AllTrim( (cAliasSE5)->E5_TIPO ) $ "CC/CD/FI/VA/CO"
				lVendaLoja := .T.
			Else
				(cAliasSL1)->( DbSkip() )
            EndIf
		End
		
		If lVendaloja
			If cPaisLoc <> "BRA"
				SA6->( DbSetOrder( 1 ) )
				SA6->( DbSeek( xFilial( "SA6" ) + (cAliasSE5)->E5_BANCO + (cAliasSE5)->E5_AGENCIA + (cAliasSE5)->E5_CONTA ) )
				nMoeda	:= Max( SA6->A6_MOEDA, 1 )
				nSe5Valor:= Round( xMoeda( (cAliasSE5)->E5_VALOR, nMoeda, 1, (cAliasSE5)->E5_DATA, nDecs + 1 ),nDecs )
			Else
				nSe5Valor := (cAliasSE5)->E5_VALOR
							
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Caso o usuario nao esteja utilizando o parametro MV_COMISCC  ³
			//³para venda com cartao, utilizar o valor inteiro para comissao³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lComisCC .AND. (cAliasSL1)->L1_CARTAO > 0
				nSe5Valor := Posicione(	"SE1", 1, xFilial( "SE1" ) 	+ 	(cAliasSE5)->E5_PREFIXO + ;
										(cAliasSE5)->E5_NUMERO		+	(cAliasSE5)->E5_PARCELA	+ ;
										(cAliasSE5)->E5_TIPO, "SE1->E1_VLRREAL")
			Endif

			nComissao := nSe5Valor					 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Carrega o(s) vendedor(es) da venda³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aVendedor := Lj440Vnd((cAliasSL1)->L1_NUM)
			
			For nVend := 1 to Len(aVendedor)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Proporcionaliza o valor da baixa em relacao ao total vendido pelo vendedor³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nComissao := nSe5Valor * (aVendedor[nVend][2]/(cAliasSL1)->L1_VLRTOT)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Desconsidera na base da comissao o Acrescimo Financeiro			    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea( "SA3" )
				DbSetOrder( 1 )
				If DbSeek( xFilial( "SA3" ) + aVendedor[nVend][1] )
					If SA3->A3_ACREFIN == "N"
						nComissao := nComissao / ( ( (cAliasSL1)->L1_JUROS / 100 ) + 1 )
					Endif
				Endif
				
				DbSelectArea( cAliasSE5 )
				If !lTop
					nRegSe5 := RecNo()
				EndIf
				If MV_PAR06 == 2
					DbSelectArea( "SE5" )
					DbSetOrder( 2 )
					If DbSeek( cFilSE5 + "JR" + cChaveSe5 )
						If cPaisLoc <> "BRA"
							SA6->( DbSetOrder( 1 ) )
							SA6->( DbSeek( 	xFilial( "SA6" ) + SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA ) )
							nMoeda	:= Max( SA6->A6_MOEDA, 1 )
							nSe5Valor:= Round( xMoeda( SE5->E5_VALOR, nMoeda, 1, SE5->E5_DATA, nDecs + 1 ), nDecs )
						Else
							nSe5Valor := SE5->E5_VALOR
						Endif
						nComissao -= nSe5Valor
					Endif
					If !lTop
						(cAliasSE5)->( DbGoto( nRegSe5 ) )
						(cAliasSE5)->( DbSetOrder( 1 ) )
					EndIf
				Endif
				
				If MV_PAR07 == 2
					DbSelectArea( "SE5" )
					DbSetOrder( 2 )
					If DbSeek( cFilSE5 + "DC" + cChaveSe5 )
						If cPaisLoc <> "BRA"
							SA6->( DbSetOrder( 1 ) )
							SA6->( DbSeek( xFilial("SA6") + SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA ) )
							nMoeda	:= Max( SA6->A6_MOEDA, 1 )
							nSe5Valor:= Round( xMoeda( SE5->E5_VALOR, nMoeda, 1, SE5->E5_DATA, nDecs + 1 ), nDecs )
						Else
							nSe5Valor := SE5->E5_VALOR
						Endif
						If AllTrim(UPPER(SE5->E5_MOEDA)) == "TC"
							nComissao -= nSe5Valor
						Else
							nComissao += nSe5Valor
						EndIf
					Endif
					If !lTop
						SE5->( DbGoto( nRegSe5 ) )
						SE5->( DbSetOrder( 1 ) )
					EndIf
				Endif
				
				If SA3->A3_FRETE <> "S"		//Brancos e 'N'
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³No caso de venda parcelada e necessario verificar o percentual  ³
					//³da parcela sobre o total, para excluir o frete proporcionalmente³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nPercFret := ( ( SE5->E5_VALOR * 100 ) / ( (cAliasSL1)->L1_VLRTOT + (cAliasSL1)->L1_FRETE + (cAliasSL1)->L1_SEGURO + (cAliasSL1)->L1_DESPESA ) ) / 100
					nComissao -= ( (cAliasSL1)->L1_FRETE + (cAliasSL1)->L1_SEGURO + (cAliasSL1)->L1_DESPESA ) * nPercFret
				Endif
				
				If SA3->( DbSeek( xFilial( "SA3" ) + aVendedor[nVend][1] ))
					If MV_PAR08 == 1					// Cliente
						SA1->( DbSetOrder( 1 ) )
						SA1->( DbSeek( xFilial("SA1") + (cAliasSL1)->L1_CLIENTE ) )
						nPerc := SA1->A1_COMIS
						
					ElseIf MV_PAR08 == 4 //Venda
						SE1->( DbSetOrder( 1 ) )
						SE1->( DbSeek( (cAliasSE5)->E5_FILIAL + (cAliasSE5)->E5_PREFIXO + (cAliasSE5)->E5_NUMERO ) )
						
						If SE1->E1_VEND1 == aVendedor[nVend][1] .AND. SE1->E1_COMIS1 > 0
							nPerc := SE1->E1_COMIS1
						ElseIf SE1->E1_VEND2 == aVendedor[nVend][1] .AND. SE1->E1_COMIS2 > 0
							nPerc := SE1->E1_COMIS2
						ElseIf SE1->E1_VEND3 == aVendedor[nVend][1] .AND. SE1->E1_COMIS3 > 0
							nPerc := SE1->E1_COMIS3
						ElseIf SE1->E1_VEND4 == aVendedor[nVend][1] .AND. SE1->E1_COMIS4 > 0
							nPerc := SE1->E1_COMIS4
						ElseIf SE1->E1_VEND5 == aVendedor[nVend][1] .AND. SE1->E1_COMIS5 > 0
							nPerc := SE1->E1_COMIS5
						Endif
					Else
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Para qualquer outra Prioridade pegar o percentual a partir do       ³
						//³ Vendedor.No caso da Prioridade ser Produto temos a mesma dificuldade³
						//³ de contemplar a Troca (L1_CREDITO) na comissao da Emissao, ou seja, ³
						//³ nao conseguimos chegar no percentual exato.                         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nPerc := SA3->A3_COMIS
					Endif
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Posiciona no SL1³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea("SL1")
					DbSetOrder(1)
					DbSeek((cAliasSL1)->L1_FILIAL + (cAliasSL1)->L1_NUM)
					
					If SL1->( FieldPos( "L1_TROCO1" ) ) > 0 .AND. (cAliasSL1)->L1_TROCO1 > 0
						If FindFunction("Fa440LjTrc")  
						    aBasesVend := {}
						    Aadd(aBasesVend ,aVendedor[nVend][1] )
						    Aadd(aBasesVend , nComissao )
						    Aadd(aBasesVend , nComissao )
						    Aadd(aBasesVend , nComissao )
						    Aadd(aBasesVend , nValEmissao )
						    Aadd(aBasesVend , nValEmissao )
						    Aadd(aBasesVend , nPerc )
					    	aBasesVend  := Fa440LjTrc(nComissao,nValEmissao,aBasesVend,"B")
						    nComissao   := aBasesVend[3]
						    nValEmissao := aBasesVend[5]
						Else	  
							nComRep 	:= nComissao / ((cAliasSL1)->L1_VLRTOT+(cAliasSL1)->L1_TROCO1)
							nComissao	-= ((cAliasSL1)->L1_TROCO1 * nComRep)
							nComissao	:= Round(nComissao,nDecimal)
	
							nTotComis := 0						
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica se encontra problema de arredondamento                     ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							DbSelectArea( "SE3" )
							DbSetOrder( 3 ) //E3_VEND+E3_CODCLI+E3_LOJA+E3_PREFIXO+E3_NUM+E3_PARCELA+E3_TIPO+E3_SEQ
							If  DbSeek(xFilial("SE3")+aVendedor[nVend][1]+(cAliasSL1)->L1_CLIENTE+(cAliasSL1)->L1_LOJA+(cAliasSL1)->L1_SERIE+(cAliasSL1)->L1_DOC)
								While(xFilial("SE3")+aVendedor[nVend][1]+(cAliasSL1)->L1_CLIENTE+(cAliasSL1)->L1_LOJA+(cAliasSL1)->L1_SERIE	+(cAliasSL1)->L1_DOC == ;
									  SE3->E3_FILIAL+SE3->E3_VEND		+ SE3->E3_CODCLI		+ SE3->E3_LOJA		 +SE3->E3_PREFIXO		+ SE3->E3_NUM		)
			                        
									nTotComis += SE3->E3_BASE
									SE3->(DbSkip())
								End
								
								nDifComis := (cAliasSL1)->L1_VLRTOT - (nTotComis+nComissao)
								
								If Abs(nDifComis) <= ((1/(10^nDecimal))*3)	// Ajusta a diferenca de ate 0,03 centavos
									nComissao += nDifComis
								EndIf
							Endif  
						EndIf							
					EndIf
					
					// Verifica se utilizou NCC como forma de pagamento 
	   				If (cAliasSL1)->L1_CREDITO > 0  
						nValPgNCC := (cAliasSL1)->L1_CREDITO
						lUsouNcc := .T.
					Else
						lUsouNcc := .F.
					EndIf   
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Caso tenha sido utilizada NCC como forma de pagamento, somente gera comissao sobre o excedente.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
					If lUsouNcc 
						If cTpComiss == "1"
							If (cAliasSL1)->L1_VLRTOT  >  nValPgNcc   
								nComissao := (cAliasSL1)->L1_VLRTOT - nValPgNcc
							Else
								nComissao := 0
							EndIf
						Else
							nProporcional := Round((aVendedor[nVend][2]/(cAliasSL1)->L1_VLRTOT ),nDecs) 
			
							If (cAliasSL1)->L1_VLRTOT  >  nValPgNcc   
								nComissao := 	aVendedor[nVend][2] - (nValPgNcc * nProporcional) 
							Else
								nComissao := 0
							EndIf  
						EndIf	  
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Caso o orcamento tenha sofrido DEVOLUCAO somente exclui a comissao do vendedor:     ³ 
					//³Caso a devolucao tenha sido em dinheiro ou o tipo de comissao for por item de venda.³
	   				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aAreaSE5 := SE5->(GetArea())
					SE5->(DbSetOrder(7)) //E5_FILIAL+E5_PREFIXO+E5_NUM+E5_PARCELA
					If lTop                                              
						cQuery := "SELECT DISTINCT"		+ Chr(10)
						cQuery += "	SD1.D1_NFORI,"		+ Chr(10)
						cQuery += "	SD1.D1_SERIORI,"	+ Chr(10)
						cQuery += "	SD1.D1_SERIE,"		+ Chr(10)
						cQuery += "	SD1.D1_DOC"		+ Chr(10)
						
						cQuery += "FROM"												+ Chr(10)
						cQuery += "	" + RetSqlName("SD1") + " (NOLOCK) SD1"						+ Chr(10)
						
						
						//JOIN com a tabela SL1
						cQuery += "JOIN "												+ Chr(10)
						cQuery += "	" + RetSqlName("SL1") + " (NOLOCK) SL1"						+ Chr(10)
						cQuery += "ON SD1.D1_NFORI = SL1.L1_DOC"						+ Chr(10)
						cQuery += "	AND SD1.D1_SERIORI = SL1.L1_SERIE"					+ Chr(10)						+ Chr(10)
						cQuery += "	AND SD1.D_E_L_E_T_ <> '*'"							+ Chr(10)
						cQuery += "	AND SD1.D1_FILIAL = '" + xFilial("SD1") + "'"	+ Chr(10)
						cQuery += "	AND SL1.L1_NUM = '" + (cAliasSL1)->L1_NUM + "'"	+ Chr(10)
						cQuery += "	AND SL1.L1_FILIAL = '" + (cAliasSL1)->L1_FILIAL + "'"	+ Chr(10)
						cQuery += "	AND SL1.D_E_L_E_T_ <> '*'"

					
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TcGenQry( , , cQuery), cAliasTmp)
					
						While (cAliasTmp)->(!Eof())
							
							If SE5->(DbSeek(xFilial("SE5")+ (cAliasTmp)->D1_SERIE + (cAliasTmp)->D1_DOC )) 
								If IsMoney(SE5->E5_TIPO)
									nComissao := 0
									Exit
								EndIf 	 
							EndIf
							
							(cAliasTmp)->(DbSkip(1))
					
						EndDo
						(cAliasTmp)->(DbCloseArea())
					Else
						aAreaSF1		:= SF1->(GetArea()) 											
						aAreaSD1		:= SD1->(GetArea())				
						SD1->( DbSetOrder(1) ) //D1_FILIAL + D1_DOC

						
						SF1->( DbSetOrder(2)) //f1_FILIAL + f1_FORNECE +  f1_LOJA
						SF1->( DbSeek(xFilial("SF1") + (cAliasSL1)->L1_CLIENTE + (cAliasSL1)->L1_LOJA) )
					
						While SF1->( !Eof()  .AND. F1_FILIAL + F1_FORNECE +  F1_LOJA == xFilial("SF1") + (cAliasSL1)->( L1_CLIENTE + L1_LOJA) )
						
							If SF1->F1_TIPO = "D"
									SD1->( DbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE)) 
							
									Do While SD1->(!Eof() .AND. D1_FILIAL + D1_DOC + D1_SERIE == xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE)
									
										If SD1->D1_TIPO = 'D'  .AND. SD1->D1_SERIORI = (cAliasSL1)->L1_SERIE  .AND.  SD1->D1_NFORI = (cAliasSL1)->L1_DOC
										
											If SE5->(DbSeek(xFilial("SE5")+ SD1->(D1_SERIE + D1_DOC) )) 
												If IsMoney(SE5->E5_TIPO) 
													nComissao := 0
													Exit
												EndIf 	 
											EndIf
										EndIf
										SD1->(DbSkip(1))
									EndDo
		
		
							EndIf
									
							SF1->( DbSkip() )
							
						End                               
						RestArea(aAreaSF1)											
						RestArea(aAreaSD1)					
					EndIf
						
					RestArea(aAreaSE5)

					nPerc		:= nPerc * SA3->A3_ALBAIXA / 100
					nValEmissao	:= (nComissao*(nPerc/100))

					cPrefixo := LJPREFIXO( If(MV_PAR09 == 1, (cAliasSL1)->L1_FILIAL, Nil) )
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o registro já existe no SE3                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea( "SE3" )
					DbSetOrder( 3 )
					lSE3found := .F.
					If  DbSeek( xFilial( "SE3" )  + aVendedor[nVend][1]     + (cAliasSL1)->L1_CLIENTE + (cAliasSE5)->E5_LOJA + cPrefixo +;
						   	(cAliasSE5)->E5_NUMERO+ (cAliasSE5)->E5_PARCELA + (cAliasSE5)->E5_TIPO 	)
	
							If ( SE3->E3_ORIGEM == "L" ) .AND. ( SE3->E3_BAIEMI == "B" )
								lSE3found := .T.
							Endif
					Endif
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Grava o Registro no SE3                                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nValEmissao > 0 .AND. !lSE3found .AND. (cAliasSE5)->E5_TIPO <> "CR"
						Aadd( aSE3, {"E3_BASE"		, nComissao} )
						Aadd( aSE3, {"E3_COMIS"		, nValEmissao} )
						Aadd( aSE3, {"E3_FILIAL"	, xFilial("SE3")} )
						Aadd( aSE3, {"E3_VEND"		, aVendedor[nVend][1]} )
						Aadd( aSE3, {"E3_SERIE"		, cSerie} )
						Aadd( aSE3, {"E3_PORC"		, nPerc} )
						Aadd( aSE3, {"E3_CODCLI"	, (cAliasSL1)->L1_CLIENTE} )
						Aadd( aSE3, {"E3_LOJA" 		, (cAliasSL1)->L1_LOJA} )
						Aadd( aSE3, {"E3_EMISSAO"	, (cAliasSE5)->E5_DATA} )
						Aadd( aSE3, {"E3_VENCTO" 	, (cAliasSL1)->L1_EMISNF} )
						Aadd( aSE3, {"E3_PREFIXO"	, cPrefixo} )
						Aadd( aSE3, {"E3_BAIEMI" 	, "B"} )
						Aadd( aSE3, {"E3_ORIGEM"	, "L"} )
						Aadd( aSE3, {"E3_PEDIDO" 	, (cAliasSL1)->L1_NUM} )
						Aadd( aSE3, {"E3_PARCELA"	, (cAliasSE5)->E5_PARCELA} )
						Aadd( aSE3, {"E3_TIPO"		, (cAliasSE5)->E5_TIPO} )
						Aadd( aSE3, {"E3_SEQ"		, (cAliasSE5)->E5_SEQ} )
						If lPedido
							Aadd( aSE3, {"E3_NUM" 	, (cAliasSL1)->L1_DOCPED} )
						Else
							Aadd( aSE3, {"E3_NUM" 	, (cAliasSL1)->L1_DOC} )
						EndIf
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Gravamos a comissao³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						RecLock("SE3", .T.)
						For nI := 1 to Len(aSE3)
							Replace &( aSE3[nI][1] ) with aSE3[nI][2]	//Nome do Campo[1] | Valor do Campo[2]
						Next
						SE3->( MsUnlock() )

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se existe gerente ou supervisor³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cSupervisor := SA3->A3_SUPER
						cGerente    := SA3->A3_GEREN
						
						//Trecho colocado, pois tinha um cliente que queria dois vendedores no cabecalho (ANTONIO AUTOPECAS)
						//Nesse caso o cliente preenchendo o campo (customizado) L1_VEND2 e considera na comissao
						If (cAliasSL1)->(FieldPos("L1_VEND2")) > 0 .AND. Empty(cSupervisor)  			
							cSupervisor := (cAliasSL1)->L1_VEND2
						EndIf
						If (cAliasSL1)->(FieldPos("L1_VEND3")) > 0 .AND. Empty(cGerente)	
							cGerente    := (cAliasSL1)->L1_VEND3
						EndIf	
				
						If !Empty( cSupervisor )			
							nPosVend := aScan( aSE3, {|x| x[1] == "E3_VEND"} )
							If nPosVend > 0
								aSE3[nPosVend][2] := cSupervisor
							EndIf
				
							Lj440SbCom(aSE3)
						EndIf
				
						If !Empty( cGerente )
							nPosVend := aScan( aSE3, {|x| x[1] == "E3_VEND"} )						
							If nPosVend > 0
								aSE3[nPosVend][2] := cGerente
							EndIf
				
							Lj440SbCom(aSE3)
						EndIf

						aSE3 := {}	//resetamos o array aSE3
					EndIf	//fim do bloco de gravacao da comissao

				Endif
			Next nVend
		Endif
	Endif
	If lTop
		(cAliasSL1)->(DbCloseArea())
	EndIf
	DbSelectArea( cAliasSE5 )
	DbSkip()
End
If lTop
	DbSelectArea(cAliasSE5)
	DbCloseArea()
	DbSelectArea("SE5")
EndIf

If lR1_1 .AND. ValType(lEnd) == "O"
	lEnd:IncRegua2(STR0038)		//"Fim do cálculo de comissões pela emissão"
EndIf

If lFina070

	MV_PAR01 := nMV_PAR01
	MV_PAR02 := nMV_PAR02
	MV_PAR03 := nMV_PAR03
	MV_PAR04 := nMV_PAR04
	MV_PAR05 := nMV_PAR05
	MV_PAR06 := nMV_PAR06
	MV_PAR07 := nMV_PAR07
	MV_PAR08 := nMV_PAR08
	MV_PAR09 := nMV_PAR09

EndIf

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Lj440AdmFiºAutor  ³Vendas Clientes     º Data ³  14/10/2002 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que verifica a taxa da adm. financeira da venda para º±±
±±º          ³calculo do valor base de comissao para o vendedor.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LOJA440                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Lj440AdmFin( cOrcamento, nDecs )
Local nRet 	    := 0                  	//Valor utilizado na adm financeira para retorno
Local aArea    	:= GetArea()           	//Area do arquivo atual
Local aAreaSL4 	:= SL4->(GetArea())    //Area do arquivo SL4
Local aAreaSAE 	:= SAE->(GetArea())    //Area do arquivo SA1
Local cFilSL4  	:= xFilial( "SL4" )    //Filial do arquivo SL4
Local cFilSAE  	:= xFilial( "SAE" )    //Filial do arquivo de administradoras financeiras
Local cAdmFin  	:= ""                  //Codigo da Adm Financeira

DbSelectArea( "SL4" )
DbSetOrder( 1 )
If !DbSeek( cFilSL4+cOrcamento )
	Return nRet
Endif

While 	(!Eof()) 				.AND.;
 		(cFilSL4 == L4_FILIAL)	.AND.;
 		(cOrcamento == L4_NUM)	
 		
	If ( Alltrim(L4_FORMA) == "CC" )
		cAdmFin := Left(L4_ADMINIS,3)
		
		DbSelectArea( "SAE" )
		DbSetOrder( 1 )
		If ( DbSeek( cFilSAE+cAdmFin ) )
			nRet += Round( ((SL4->L4_VALOR * AE_TAXA) / 100 ),nDecs)
		Endif
	Endif
	
	DbSelectArea( "SL4" )
	DbSkip()
End

//Recuperando areas dos arquivos utilizados na venda
SL4->(RestArea(aAreaSL4))
SAE->(RestArea(aAreaSAE))

//Recuperando area do arquivo atual
RestArea(aArea)

Return nRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LJ440DevToºAutor  ³Vendas Clientes     º Data ³  03/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que determina se o orcamento selecionado possui     º±±
±±º          ³ devolucao total                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LOJA440                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LJ440DevTotal( cFilOrig, cOrcamento, cAliasE5 )
Local aArea      := GetArea()					// GetArea
Local aAreaSL2   := SL2->( GetArea() )			// GetArea do SL2
Local aAreaSE1   := SE1->( GetArea() )			// GetArea do SE1
Local cSeekWhile := ""							// Variavel para busca
Local lRet       := .T.							// Retorno da funcao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica qual o E1_FILORIG para encontrar os itens do orcamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SE1->( DbSetOrder( 1 ) )
If SE1->( DbSeek( (cAliasE5)->E5_FILIAL + (cAliasE5)->E5_PREFIXO + (cAliasE5)->E5_NUMERO + (cAliasE5)->E5_PARCELA + (cAliasE5)->E5_TIPO ) )
	cFilOrig := SE1->E1_FILORIG
Endif
If Empty( xFilial( "SL2" ) )
	cFilOrig := Space(FWGETTAMFILIAL)
Endif

DbSelectArea( "SL2" )
DbSetOrder( 1 )
DbSeek( cSeekWhile := cFilOrig + cOrcamento )

While !Eof() .AND. cSeekWhile == SL2->L2_FILIAL + SL2->L2_NUM
	If SL2->L2_STATUS <> "D" .AND. (SL2->L2_VENDIDO == "S" .OR. AllTrim(SL2->L2_ORCRES) <> "")
		lRet := .F.
		Exit
	Endif
	DbSkip()
End

RestArea( aAreaSE1 )
RestArea( aAreaSL2 )
RestArea( aArea )

Return (lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOJA440   ºAutor  ³Vendas Clientes     º Data ³  20/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao retorna dados dos campos do arquivo SL1 do SX3.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ ExpA1: Array contendo os campos a serem pesquisados no SX3 º±±
±±º          ³ ExpC1: Alias do arquivo para verificacao de campo		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LJ440Stru(aStrut, cAlias)
Local nX  := 0    		// Variavel do FOR
Local lOk := .T.  		// Retorno da Funcao

SX3->( DbSetOrder(2) )
For nX := 1  to Len(aStrut)
	If Upper(aStrut[nX, 1]) == "L1_ABTOPCC" .AND. cAlias == "SL1"
		If SL1->(FieldPos(aStrut[nX, 1])) > 0
			lOk := .T.
		Else
			lOk := .F.
		Endif
	Endif
	If SX3->( DbSeek(aStrut[nX, 1])  )
		lOk := .T.
	Else
		lOk := .F.
	Endif
	
	If lOk
		aStrut[nX, 2] := SX3->X3_TIPO
		aStrut[nX, 3] := SX3->X3_TAMANHO
		aStrut[nX, 4] := SX3->X3_DECIMAL
	Endif
Next nX

Return(aStrut)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³LJ440ExeQryL1 ºAutor  ³Vendas Clientes º Data ³  22/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Funcao que cria e executa a query do SL1                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ ExpC1: Variavel deve ser passada por referencia, para ser  º±±
±±º          ³ utilizada na query.                              		  º±±
±±º          ³ ExpA1: Array contendo os campos do arquivo para utilizacao º±±
±±º          ³ da funcao TcSetField.                                      º±±
±±º          ³ ExpC2: Variavel utilizada para criacao da area temporaria  º±±
±±º          ³ da query.                                                  º±±
±±º          ³ ExpC3: Filial de origem do titulo.                         º±±
±±º          ³ ExpC4: Serie da venda                                      º±±
±±º          ³ ExpN1: Define qual condicional a ser utilizada			  º±±
±±º          ³ ExpC5: Filial inicial									  º±±
±±º          ³ ExpC6: Filial Final										  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function LJ440ExeQryL1(	cQuery, aStrutSL1, cAliasSL1, cFilOriE5, ;
								cSerie, cE5numero, nQuery   , cFilDe   , ;
								cFilAte,cTpComiss)

Local nX   		:= 0 				//Variavel do For
Local lRet 		:= .F.				//Retorno da funcao
Local cCampo	:= ""
Local lL1Vend2	:= SL1->(FieldPos("L1_VEND2")) > 0
Local lL1Vend3	:= SL1->(FieldPos("L1_VEND3")) > 0

DEFAULT cTpComiss := "1"

If SL1->( FieldPos( "L1_TROCO1" ) ) > 0
	cCampo := " , L1_TROCO1"
EndIf

If SL1->(FieldPos("L1_RECISS")) > 0
	cCampo += " , L1_RECISS"
EndIf

If SL1->(FieldPos("L1_VALISS")) > 0
	cCampo += " ,L1_VALISS"
EndIf

If SL1->(FieldPos("L1_ABTOPCC")) > 0
	cCampo += ", L1_ABTOPCC "
EndIf

cQuery := "SELECT L1_FILIAL, L1_SERIE, L1_DOC, L1_NUM, L1_VEND, "
cQuery += 		IIf(lL1Vend2, "L1_VEND2 ,", "")
cQuery += 		IIf(lL1Vend3, "L1_VEND3 ,", "")
cQuery +=		"L1_MOEDA, L1_LOJA	  , L1_EMISNF	, "
cQuery +=		"L1_JUROS  , L1_FRETE, L1_SEGURO , L1_DESPESA	, "
cQuery +=		"L1_CREDITO ,L1_CLIENTE, L1_LOJA , L1_TXMOEDA,	L1_VLRTOT, "
cQuery +=		"L1_CARTAO	, L1_DOCPED , L1_SERPED, L1_ORCRES"	+	cCampo
cQuery += " FROM " + RetSqlName("SL1")
If nQuery = 1
	cQuery += " WHERE	L1_EMISNF  >= '"  	+ DtoS(MV_PAR01)	+ "' AND "
	cQuery += 			"L1_EMISNF <= '"  	+ DtoS(MV_PAR02)	+ "' AND "
	cQuery +=          	"L1_FILIAL  >= '"	+ cFilDe 			+ "' AND "
	cQuery +=          	"L1_FILIAL  <= '"	+ cFilAte 			+ "' AND "
	cQuery += 			"(L1_DOC <> '' OR L1_DOCPED <> '') AND L1_VEND <> '' AND "
	cQuery += 			"D_E_L_E_T_ <> '*'"
Else
	cQuery += " WHERE	L1_FILIAL  = '" + cFilOriE5  + "' AND "
	cQuery += 			"(L1_SERIE  = '" + cSerie	 + "' OR L1_SERPED  = '" 	+ cSerie	 	+ "') AND "
	cQuery +=          	"(L1_DOC    = '" + cE5numero + "' OR L1_DOCPED  = '" 	+ cE5numero 	+ "') AND "
	If cTpComiss == "1"
		cQuery +=	"L1_VEND >= '"   + MV_PAR03  + "' AND L1_VEND <= '" 	+ MV_PAR04		+ "' AND "
	Else
		cQuery += 	"L1_VEND <> '' AND "
	EndIf	
	cQuery += " D_E_L_E_T_ <> '*' "
EndIf	

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSL1)
If (cAliasSL1)->(!Eof())
	For nX := 1 To Len(aStrutSL1)
		TcSetField( cAliasSL1, aStrutSL1[nX,1], aStrutSL1[nX,2], aStrutSL1[nX,3], aStrutSL1[nX,4] )
	Next nX
EndIf
lRet := !Eof()

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³Lj440Vnd  ºAutor  ³Vendas CRM          º Data ³  08/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Recupera a lista de vendedores participantes de uma venda   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³LOJA440                                                     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Lj440Vnd(cOrcamento)

Local aArea		:= GetArea()						// Armazena o posicionamento da area atual
Local aAreaSL1	:= SL1->(GetArea())				// Armazena o posicionamento do SL1
Local aAreaSL2	:= SL2->(GetArea())				// Armazena o posicionamento do SL2
Local aRet		:= {}								// Array de retorno com os vendedores participantes
Local cTpComiss	:= SuperGetMv("MV_LJTPCOM",,"1")	// Tipo de calculo de comissao utilizado (1-Para toda a venda (padrao),2-Por item)
Local nPos		:= 0								// Posicao onde esta o vendedor no array
Local lParceiro	:= 	SuperGetMv("MV_LJINDPA",,.F.) .AND. ;
						Val(GetVersao(.F.)) >= 12 // Habilita comissao de parceiros

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega a lista de vendedores de acordo com o parametro MV_LJTPCOM³
//³1 - Apenas um vendedor por venda (L1_VEND)                        ³
//³2 - Multiplos vendedores (L2_VEND)                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If cTpComiss == "1"

	DbSelectArea("SL1")
	DbSetOrder(1)
	
	If DbSeek(xFilial("SL1")+cOrcamento)
		AAdd(aRet,{SL1->L1_VEND,SL1->L1_VLRTOT})
	EndIf
	
Else
	
	DbSelectArea("SL2")
	DbSetOrder(1)
	DbSeek(xFilial("SL2")+cOrcamento)
	
	While !SL2->(Eof()) .AND. SL2->L2_FILIAL == xFilial("SL2") .AND. SL2->L2_NUM == cOrcamento
		nPos := aScan(aRet,{ |x| Alltrim(x[1]) == AllTrim(SL2->L2_VEND) })
		If nPos == 0
			AAdd(aRet,{SL2->L2_VEND,SL2->L2_VLRITEM})
		Else
			aRet[nPos][2] += SL2->L2_VLRITEM
		EndIf
		SL2->(DbSkip())
	End
	
EndIf

//Comissao de Parceiros que indicam a loja
If lParceiro

	DbSelectArea("SL2")
	DbSetOrder(1)
	DbSeek(xFilial("SL2")+cOrcamento)
	
	If SL2->(FieldPos("L2_INDPAR")) > 0
		While !SL2->(Eof()) .AND. SL2->L2_FILIAL == xFilial("SL2") .AND. SL2->L2_NUM == cOrcamento
			nPos := aScan(aRet, { |x|x[1] == SL2->L2_INDPAR } )
			If nPos == 0
				AAdd(aRet,{SL2->L2_INDPAR,SL2->L2_VLRITEM})
			Else
				aRet[nPos][2] += SL2->L2_VLRITEM
			EndIf
			SL2->(DbSkip())
		EndDo
	EndIf
	
EndIf

RestArea(aAreaSL1)
RestArea(aAreaSL2)
RestArea(aArea)

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Lj440SbComºAutor  ³Vendas CRM          º Data ³  08/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calcula e grava as comissoes do supervisor e gerente		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³aSE3 - array bidimensional, contendo os campos e valores queº±±
±±º			 | serao gravados na tabela SE3								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FINA440 / LOJA440											  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Lj440SbCom(aSE3)
Local lSE3Found := .F.	//indica se o vendedor foi encontrado
Local nPercent	:= 0	//porcentagem da comissao
Local nVlrComis	:= 0	//valor da comissao
Local nI		:= 0	//contador
Local aArea		:= {}	//armazena a Area corrente
Local aSE3Bkp	:= {}	//backup dos dados referente a comissao
Local nPosVend	:= 0	//posicao do campo E3_VEND
Local nPosNum	:= 0	//posicao do campo E3_NUM
Local nPosSerie := 0	//posicao do campo E3_SERIE
Local nPosBxEmi	:= 0	//posicao do campo E3_BAIEMI
Local nPosParc	:= 0	//posicao do campo E3_PARCELA
Local nPosSeq	:= 0	//posicao do campo E3_SEQ
Local nPosBase	:= 0	//posicao do campo E3_BASE
Local nPosComis := 0	//posicao do campo E3_COMIS

Default aSE3	:= {}	//dados dda comissao

If !Empty(aSE3)
	//obtemos as posicoes dos campos
	nPosVend	:= aScan( aSE3, {|x| x[1] == "E3_VEND"} )
	nPosNum		:= aScan( aSE3, {|x| x[1] == "E3_NUM"} )
	nPosSerie 	:= aScan( aSE3, {|x| x[1] == "E3_SERIE"} )
	nPosBxEmi	:= aScan( aSE3, {|x| x[1] == "E3_BAIEMI"} )
	nPosParc	:= aScan( aSE3, {|x| x[1] == "E3_PARCELA"} )
	nPosSeq		:= aScan( aSE3, {|x| x[1] == "E3_SEQ"} )
	nPosBase	:= aScan( aSE3, {|x| x[1] == "E3_BASE"} )
	nPosComis	:= aScan( aSE3, {|x| x[1] == "E3_COMIS"} )
	nPosPorc	:= aScan( aSE3, {|x| x[1] == "E3_PORC"} )

	aSE3Bkp := AClone(aSE3)
	
	DbSelectArea("SA3")
	SA3->( DbSetOrder(1) )	//A3_FILIAL + A3_COD		
	If SA3->( DbSeek(xFilial("SA3") + aSE3[nPosVend][2]) )
	
		If aSE3[nPosBxEmi][2] == "E"
			nPercent := SA3->A3_ALEMISS
		Else
			nPercent := SA3->A3_ALBAIXA
		EndIf
		
		If SA3->A3_COMIS > 0 .AND. nPercent > 0
			
			If nPosPorc > 0
				aSE3[nPosPorc][2] := ( SA3->A3_COMIS * nPercent ) / 100	//% comissao
			EndIf

			If nPosComis > 0
				aSE3[nPosComis][2] := ( aSE3[nPosBase][2] * aSE3[nPosPorc][2] ) / 100	//$ comissao
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o registro ja existe no SE3³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SE3")
			SE3->( DbSetOrder(2) )	//E3_FILIAL + E3_VEND + E3_PREFIXO + E3_NUM + E3_PARCELA + E3_SEQ
			If SE3->( DbSeek(xFilial("SE3") + aSE3[nPosVend][2] + aSE3[nPosSerie][2] + aSE3[nPosNum][2] + aSE3[nPosParc][2]) )
				If ( SE3->E3_ORIGEM == "L" ) .AND. ( SE3->E3_BAIEMI == aSE3[nPosBxEmi][2] ) //comissao gerada pela BAIXA ou EMISSAO
					lSE3found := .T.
				EndIf
			EndIf
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se for Baixa por Emissao, retiramos os campos E3_PARC e E3_SEQ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aSE3[nPosBxEmi][2] == "E"
				ADel( aSE3, nPosParc )
				aSize( aSE3, (Len(aSE3)-1) )
				//como o array foi redimensionado, atualizamos algumas posicoes
				nPosSeq	:= aScan( aSE3, {|x| x[1] == "E3_SEQ"}	)
				ADel( aSE3, nPosSeq )
				aSize( aSE3, (Len(aSE3)-1) )
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava o Registro no SE3³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aSE3[nPosComis][2] > 0 .AND. !lSE3found	//valor da comissao > 0 e registro nao encontrado
				Reclock( "SE3", .T. )	
					For nI := 1 to Len(aSE3)
						Replace &( aSE3[nI][1] ) with aSE3[nI][2]
					Next
				SE3->( MsUnlock() )
			EndIf
	
		EndIf
	EndIf

EndIf

aSE3 := AClone(aSE3Bkp)

Return Nil

