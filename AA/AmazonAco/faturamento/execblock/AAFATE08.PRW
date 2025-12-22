#include "Protheus.ch"  
#INCLUDE "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATE08   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 09/03/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina para demonstrar títulos em aberto do cliente escolhido ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ (Cont.)   ¦ no pedido de vendas.                                          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAFATE08(cCliente)
 Local   aTitulos   := {}
 Local   aTitulos02 := {}
 Local   cArea      := GetArea()
 Private nTotalPed  := 0
 Private _ldRet := .T. 
 
	// Verifica se o tipo do pedido de venda é "Normal" 
	If !( FunName() $ "MATA410|LOJA701" ) 
		Return .T.
	EndIf                                 
	
	
	If ( FunName() $ "MATA410|" ) 
	
		If (M->C5_TIPO <> "N") .Or. (M->C5_CLIENTE $ GetMv("MV_XAA"))
			Return .T.
		EndIf 	
		
	EndIf                                 
	//Faz a validação se o cliente é distribuidor, e alerta o Vendedor para troca do TES.
	dbSelectArea("SA1") 
	SA1->(dbSetOrder(1))
	If SA1->(dbseek(xFilial("SA1")+cCliente))
		If SA1->A1_XTRBSAI =="D"
			Aviso("Segmento do Cliente","Cliente é Distribuidor, favor atentar ao TES!", {"OK"})
	    EndIf
	//Faz a validação se o cliente é Lucro Real, Presumido, conforme a regra elaborado pelo Sr.Denis/Marcio/Laemilson. - Williams Messa 15/12/2020	
		If SA1->A1_PESSOA == "J" .And. SA1->A1_COD_MUN <>"02603" //Somente para pessoa Juridica e se não for para Manaus.
			If AllTrim(SA1->A1_XTPTRIB) ==""
				Aviso("Tipo de Tributação","Cliente sem informação Tp Tributação, favor complementar o Cadastro de Cliente!", {"OK"})
				Return .F.
			EndIf
		EndIf
	EndIf
	// Fim da Verificação => Williams Messa => 02/09/2020
	           
	// chamada da rotiana que verifica os titulos em aberto para o cliente
	fTabTMP(cCliente) 
	        
	// adicionado em um vetor os titulos em aberto para demosntração ao usuário. 	
		
	While !TMP01->(Eof())
		aadd(aTitulos, {E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO, E1_EMISSAO, E1_VENCTO, E1_VENCREA, E1_VALOR,E1_SALDO}) 		 
		TMP01->(dbSkip())
	End   

	// Verifica se foi encontrado Títulos em aberto para o cliente	
	If !Empty(aTitulos) 	
		// Verifica ao usuário se deve ser mostrado as pendencias financeiras
		If Aviso("Cliente em débito","Cliente com pendência financeiras!", {"Veriricar","Sair"}) == 1 
			// chamada da rotina para demosntrar na tela as pendencias 
			fTelaTit(cCliente, aTitulos)
		Else
		    Aviso("Cliente em débito","Não Será feita a Inclusão do Pedido para este Cliente ", {"OK"}) 
		    _ldRet := .F.
		EndIF 
	EndIf 
	
	// Fechamento da Area temporária criada
	TMP01->(dbCloseArea())	
	
	
	// chamada da rotiana que verifica os titulos em aberto para o cliente
	fTabTMP02(cCliente) 
	        
	// adicionado em um vetor os titulos em aberto para demosntração ao usuário. 	
		
	While !TMP02->(Eof())
	   
		aadd(aTitulos02, {C5_EMISSAO, C5_FILIAL, C5_NUM, C5_LOJACLI, TOTAL}) 		 
		nTotalPed += TMP02->TOTAL
		TMP02->(dbSkip())
	End   

	// Verifica se foi encontrado Títulos em aberto para o cliente	
	If !Empty(aTitulos02) 	
		// Verifica ao usuário se deve ser mostrado as pendencias financeiras
		If Aviso("Verificar Pedidos","Cliente com pedidos em aberto!", {"Veriricar","Sair"}) == 1 
			// chamada da rotina para demosntrar na tela as pendencias 
			fTelaTit02(cCliente, aTitulos02)
		EndIF 
	EndIf 
	
	// Fechamento da Area temporária criada
	TMP02->(dbCloseArea())	

	
	RestArea(cArea)
	
Return _ldRet

//******************************************************************************
//Realiza consulta SQL na tebale de contas a receber para obter as informações *
//referente as dívidas dos clientes;                                           *
//******************************************************************************
Static Function fTabTMP(cCliente)
 Local   cQry    := ""

	cQry := " SELECT E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_EMISSAO,E1_VENCTO,E1_VENCREA,E1_VALOR,E1_SALDO"
	cQry += "   FROM "+RetSqlName("SE1")+" A "
	cQry += "  WHERE A.D_E_L_E_T_ <> '*' "
	cQry += "    AND E1_SALDO > 0  "
	cQry += "    AND E1_CLIENTE = '" + cCliente +"' "
	cQry += "    AND E1_FILIAL  = '"+xFilial("SE1")+"'"
	cQry += "    AND E1_VENCREA < '"+dTos( dDataBase )+"'"
	                                                                          
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP01",.T.,.T.)
	dbSelectArea("TMP01")

	TCSetField("TMP01","E1_EMISSAO", "D", 8, 0)
	TCSetField("TMP01","E1_VENCTO", "D", 8, 0)
	TCSetField("TMP01","E1_VENCREA", "D", 8, 0)

Return Nil 

//******************************************************************************
//Realiza consulta SQL na tabela de pedidos de venda para obter as informações *
//referente aos pedidos em aberto;                                             *
//******************************************************************************
Static Function fTabTMP02(cCliente)
 Local   cQry    := ""

	cQry := "SELECT  C5_EMISSAO, C5_FILIAL, C5_NUM, C5_LOJACLI, SUM((C6_QTDVEN-C6_QTDENT)* C6_PRCVEN) AS TOTAL"
	cQry += " FROM    "+RetSqlName("SC5")+" SC5"
	cQry += " INNER JOIN "+RetSqlName("SC6")+" SC6 ON SC6.D_E_L_E_T_ = ' '"
	cQry += " AND C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM"
	cQry += " WHERE SC5.D_E_L_E_T_ = ' '"
	cQry += " AND C5_CLIENTE = '"+cCliente+"'"
	cQry += " AND C5_NOTA = '' AND C5_BLQ = ''"
	cQry += " GROUP BY C5_EMISSAO, C5_FILIAL, C5_NUM, C5_LOJACLI"
	cQry += " ORDER BY C5_EMISSAO"
	                                                                          
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP02",.T.,.T.)
	dbSelectArea("TMP02")

	TCSetField("TMP02","C5_EMISSAO", "D", 8, 0)

Return Nil 

//******************************************************************************
//Realiza consulta SQL na tabela de contas a receber para obter as informações *
//referente ao faturamento;                                                    *
//******************************************************************************
Static Function fTabTMP03(cCliente)
 Local   cQry    := ""
 Local   nRet    := 0

	cQry := "SELECT ISNULL(SUM(E1_SALDO),0) AS TOTAL"
	cQry += " FROM    "+RetSqlName("SE1")
	cQry += " WHERE D_E_L_E_T_ = ' '"
	cQry += " AND E1_CLIENTE = '"+cCliente+"'"
	cQry += " AND E1_SALDO > 0"
	                                                                          
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP03",.T.,.T.)
	dbSelectArea("TMP03")
	nRet := TMP03->TOTAL
	dbCloseArea()
Return nRet


//****************************************************************************************************************************************

Static Function fTelaTit(cCliente, aVetor)
 Local cVar     := Nil
 Local oDlg     := Nil
 Local oLbx     := Nil
 Local oMainWd  := Nil

 // Adiciona as rotina padrões do sistema para montagem da tela de apresentação dos dados
 Private aRotina  := {}
 	
 	aAdd( aRotina ,{"Pesquisar" ,"AxPesqui",0,1})
	aAdd( aRotina ,{"Visualizar","AxVisual",0,2})
	aAdd( aRotina ,{"Incluir"   ,"AxInclui",0,3})
	aAdd( aRotina ,{"Alterar"   ,"AxAltera",0,4})
	aAdd( aRotina ,{"Excluir"   ,"AxDeleta",0,5})      

	DEFINE MSDIALOG oDlg TITLE "Titulos em aberto" From 8,0 To 30,100 OF oMainWd

		@ 015,010 SAY "Cliente: " + cCliente + " " + Posicione("SA1",1,xFilial("SA1")+cCliente,"A1_NOME") OF oDlg PIXEL
		@ 030,005 LISTBOX oLbx VAR cVar FIELDS HEADER;
                                       		"Prefixo",;
		                                       "Título",;
		                                       "Parcela",;
		                                       "Tipo",;
		                                       "Emissão",;
		                                       "Vencimento",;
		                                       "Venc. Real",;
		                                       "Valor",;
		                                       "Saldo",;
		SIZE 400,127 OF oDlg PIXEL
	
		oLbx:SetArray( aVetor )
		oLbx:bLine := {|| { aVetor[oLbx:nAt,1],;
		aVetor[oLbx:nAt,2],;
		aVetor[oLbx:nAt,3],;
		aVetor[oLbx:nAt,4],;
		aVetor[oLbx:nAt,5],;
		aVetor[oLbx:nAt,6],;
		aVetor[oLbx:nAt,7],;
		aVetor[oLbx:nAt,8],;
		aVetor[oLbx:nAt,9]}}
			
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oDlg:End() },{||oDlg:End()}) CENTERED
	
Return Nil 

//****************************************************************************************************************************************

Static Function fTelaTit02(cCliente, aVetor)
 Local cVar     := Nil
 Local oDlg     := Nil
 Local oLbx     := Nil
 Local oMainWd  := Nil

 // Adiciona as rotina padrões do sistema para montagem da tela de apresentação dos dados
 Private aRotina  := {}
 	
 	aAdd( aRotina ,{"Pesquisar" ,"AxPesqui",0,1})
	aAdd( aRotina ,{"Visualizar","AxVisual",0,2})
	aAdd( aRotina ,{"Incluir"   ,"AxInclui",0,3})
	aAdd( aRotina ,{"Alterar"   ,"AxAltera",0,4})
	aAdd( aRotina ,{"Excluir"   ,"AxDeleta",0,5})      

	DEFINE MSDIALOG oDlg TITLE "Pedidos em aberto" From 8,0 To 30,100 OF oMainWd

		SA1->(dbSetOrder(1))
		SA1->(dbseek(xFilial("SA1")+cCliente))
		@ 003,010 SAY "Cliente: " OF oDlg PIXEL 
		@ 003,060 SAY cCliente + " " + SA1->A1_NOME OF oDlg PIXEL
		@ 010,010 SAY "Limite de Crédito: " OF oDlg PIXEL
		@ 010,060 SAY Transform(SA1->A1_LC,"@E 999,999,999.99") OF oDlg PIXEL
		@ 016,010 SAY "Total dos Pedidos: " OF oDlg PIXEL
		@ 016,060 SAY Transform(nTotalPed,"@E 999,999,999.99") OF oDlg PIXEL
		@ 022,010 SAY "Total não Faturado: " OF oDlg PIXEL
		@ 022,060 SAY Transform(fTabTMP03(cCliente),"@E 999,999,999.99") OF oDlg PIXEL
		 
		
		@ 030,005 LISTBOX oLbx VAR cVar FIELDS HEADER;
                                       		"Emissão",;
		                                       "Filial",;
		                                       "Pedido",;
		                                       "Loja",;
		SIZE 400,127 OF oDlg PIXEL
	
		oLbx:SetArray( aVetor )
		oLbx:bLine := {|| { aVetor[oLbx:nAt,1],;
		aVetor[oLbx:nAt,2],;
		aVetor[oLbx:nAt,3],;
		aVetor[oLbx:nAt,4]}}
			
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oDlg:End() },{||oDlg:End()}) CENTERED
	
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

