#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


 User Function PLPROR08()

 	Local oScroll
	Local nGrafico := BARCOMPCHART

 
 
	Static oMonitor

	DEFINE MSDIALOG oMonitor TITLE "Grafico" FROM 0,0  TO 600,900 COLORS 0, 16777215 PIXEL 
	oScroll := TScrollArea():New(oMonitor,01,01,500,800)
	oScroll:Align := CONTROL_ALIGN_ALLCLIENT    
	
	Grafico(oScroll,nGrafico)
	
	oMenu := TBar():New( oMonitor, 48, 48, .T., , ,"CONTEUDO_BODY-FUNDO", .T. )
	DEFINE BUTTON RESOURCE "FW_PIECHART_1"		OF oMenu	ACTION Grafico(oScroll,PIECHART) 	 PROMPT " "	TOOLTIP "PRODUÇÃO"			
	//DEFINE BUTTON RESOURCE "FW_LINECHART_1"		OF oMenu	ACTION Grafico(oScroll,LINECHART) 	 PROMPT " "	TOOLTIP "Linha"			
	DEFINE BUTTON RESOURCE "FW_BARCHART_1"		OF oMenu	ACTION Grafico(oScroll,BARCHART) 	 PROMPT " "	TOOLTIP "Barra"			
	//DEFINE BUTTON RESOURCE "FW_BARCOMPCHART_2"	OF oMenu	ACTION Grafico(oScroll,BARCOMPCHART) PROMPT " "	TOOLTIP "Barra"			
	
	ACTIVATE MSDIALOG oMonitor CENTERED
Return
 
  Static Function Grafico(oScroll,nGrafico)
	Local oChart
	Local cQuery:= ""
	Local oDlg
	
	If Valtype(oChart)=="O"
		FreeObj(@oChart) //Usando a função FreeObj liberamos o objeto para ser recriado novamente, gerando um novo gráfico
	Endif
	
	oChart := FWChartFactory():New()
	oChart := oChart:getInstance( nGrafico ) 
	oChart:init( oScroll )
	oChart:SetTitle("Insp. Final", CONTROL_ALIGN_LEFT)
	//oChart:SetMask( "R$ *@*")
	oChart:SetPicture("@E 999,999,999.99")
	oChart:setColor("Random") //Deixamos o protheus definir as cores do gráfico
	If nGrafico == PIECHART //se o gráfico tipo pizza, deixamos a legenda no rodapé
		oChart:SetLegend( CONTROL_ALIGN_BOTTOM )
	Endif	
	oChart:nTAlign := CONTROL_ALIGN_ALLCLIENT
 
	//Uma consulta bem Simples
	cQuery := "SELECT CAST(SUM(RETRAB) AS INT) PRODUTO_NC, CAST(SUM(PROD_OK) AS INT) PRODUTO_OK  "
	 cQuery += "FROM ("
	 cQuery += "      SELECT COUNT(SGQ_NOME) INSP,CASE WHEN SGQ_AVARIA = 'S' THEN COUNT(SGQ_AVARIA) ELSE 0 END RETRAB,CASE WHEN SGQ_AVARIA != 'S' THEN COUNT(SGQ_AVARIA) ELSE 0 END PROD_OK "
	 cQuery += "      FROM SGQ "
	 cQuery += "      WHERE CONVERT(VARCHAR,CAST(SGQ_DATINC AS DATE),112)= '20220404' "
	 cQuery += "      GROUP BY SGQ_AVARIA"
	 cQuery += ")TB "
	
	oChart := FWChartPie():New()
	oChart:init( oDlg, .T. ) 
	  
	 oChart:addSerie( "QTD PRODUTO_NC = "+cValToChar(nDados1),nDados1)
	 oChart:addSerie( "QTD PRODUTO_OK = "+cValToChar(nDados2),nDados2)
	 //oChart:addSerie( "Votos C", 20 ) 
	 oChart:setLegend( CONTROL_ALIGN_LEFT ) 
	 oChart:Build()
 ACTIVATE MSDIALOG oDlg
 
/* Static Function Grafico(oScroll,nGrafico)
	Local oChart
	Local cQuery:= ""
	 Local oChartLocal 
	 Local oDlg  
	 Local nDados1 := 0
	 Local nDados2 := 0
	// Local oMOT 
	
   IF Select("SGQ") <> 0
		DbSelectArea("SGQ")
		DbCloseArea()
	ENDIF
 
 cQuery := "SELECT CAST(SUM(RETRAB) AS INT) PRODUTO_NC, CAST(SUM(PROD_OK) AS INT) PRODUTO_OK  "
 cQuery += "FROM ("
 cQuery += "      SELECT COUNT(SGQ_NOME) INSP,CASE WHEN SGQ_AVARIA = 'S' THEN COUNT(SGQ_AVARIA) ELSE 0 END RETRAB,CASE WHEN SGQ_AVARIA != 'S' THEN COUNT(SGQ_AVARIA) ELSE 0 END PROD_OK "
 cQuery += "      FROM SGQ "
 cQuery += "      WHERE CONVERT(VARCHAR,CAST(SGQ_DATINC AS DATE),112)= '20220404' "
 cQuery += "      GROUP BY SGQ_AVARIA"
 cQuery += ")TB "
  	
 	
	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "SGQ"	

	dbSelectArea("SGQ")
	SGQ->(dbGoTop())

    nDados1 := SGQ->PRODUTO_NC
	
	nDados2 := SGQ->PRODUTO_OK

 oChart := FWChartPie():New()
 oChart:init( oDlg, .T. ) 
  
 oChart:addSerie( "QTD PRODUTO_NC = "+cValToChar(nDados1),nDados1)
 oChart:addSerie( "QTD PRODUTO_OK = "+cValToChar(nDados2),nDados2)
 //oChart:addSerie( "Votos C", 20 ) 
 oChart:setLegend( CONTROL_ALIGN_LEFT ) 
 oChart:SetPicture("@E 999,999,999,99")
 oChart:Build()
 ACTIVATE MSDIALOG oDlg*/

 	
 
 //INICIA SQL DO GRAFICO BARRA
 
  	
 /*
    
	
 cQuery := "SELECT MOTIVO,CAST(QTD AS INT) QTD  "
 cQuery += " FROM ( SELECT SGQ_ITEM MOTIVO,COUNT(SGQ_ITEM) QTD "
 cQuery += "      	FROM SGQ "
 cQuery += "     	WHERE CONVERT(VARCHAR,CAST(SGQ_DATINC AS DATE),112)= '202200404'"
 cQuery += "    	AND SGQ_AVARIA = 'S' "
 cQuery += "   		GROUP BY SGQ_ITEM "
 cQuery += "		)TB "
 cQuery += "GROUP BY MOTIVO,QTD "
 cQuery += "ORDER BY QTD "
 
If ( SELECT("SGQBAR") ) &gt; 0
		dbSelectArea("SGQBAR")
		SGQBAR-&gt;(dbCloseArea())
	EndIf
 
   //crio o novo alias
 TcQuery cQuery Alias "SGQBAR" New
	SGQBAR-&gt; (dbGoTop())
 
 If SGQBAR-&gt;(!EOF())
		While SGQBAR-&gt;(!EOF())
			if nGrafico==LINECHART .OR. nGrafico==BARCOMPCHART 
				//Neste dois tipos de graficos temos:
				//(Titulo, {{ Descrição, Valor }})
				oChart:addSerie( "Conta "  SGQBAR-&gt;MOTIVO   , { { DTOC(STOD(SGQBAR-&gt; MOTIVO)), SGQBAR-&gt;QTD  } } )????????
			Else
				//Aqui temos:
				//(Titulo, Valor)
				oChart:AddSerie(DTOC(STOD(SGQBAR-&gt;MOTIVO)),SGQBAR-&gt;QTD)
			Endif
			SGQBAR-&gt;(dbSkip())
		End
		oChart:build()
	Endif
	
	  		
	oChart := FWChartBarComp():New()
			 oChart:init( oMOT, .T. ) 
			 //oChart:addSerie( cDados3, { { cDados3 ,nDados4 } })
			 //oChart:addSerie( "Votos B", { {"Jan",30}, {"Fev",35}, {"Mar",40} } )
			 //oChart:addSerie( "Votos C", { {"Jan",20}, {"Fev",10}, {"Mar",10} } ) 
			 oChart:setLegend( CONTROL_ALIGN_LEFT ) 
			 oChart:Build()
		 
	ACTIVATE MSDIALOG oMOT*/
	
  
 Return
