#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  

User Function PLFINR20()
	Local oScroll
	Local nGrafico := BARCOMPCHART

	Static oMonitor

	DEFINE MSDIALOG oMonitor TITLE "Grafico" FROM 0,0  TO 600,900 COLORS 0, 16777215 PIXEL 
	oScroll := TScrollArea():New(oMonitor,01,01,500,800)
	oScroll:Align := CONTROL_ALIGN_ALLCLIENT    

	Grafico(oScroll,nGrafico)

	oMenu := TBar():New( oMonitor, 48, 48, .T., , ,"CONTEUDO_BODY-FUNDO", .T. )
	DEFINE BUTTON RESOURCE "FW_PIECHART_1"		OF oMenu	ACTION Grafico(oScroll,PIECHART) 	 PROMPT " "	TOOLTIP "Pizza"			
	DEFINE BUTTON RESOURCE "FW_LINECHART_1"		OF oMenu	ACTION Grafico(oScroll,LINECHART) 	 PROMPT " "	TOOLTIP "Linha"			
	DEFINE BUTTON RESOURCE "FW_BARCHART_1"		OF oMenu	ACTION Grafico(oScroll,BARCHART) 	 PROMPT " "	TOOLTIP "Barra"			
	DEFINE BUTTON RESOURCE "FW_BARCOMPCHART_2"	OF oMenu	ACTION Grafico(oScroll,BARCOMPCHART) PROMPT " "	TOOLTIP "Barra"			

	ACTIVATE MSDIALOG oMonitor CENTERED
Return

STATIC Function Grafico(oScroll,nGrafico)
	Local oChart
	Local cQuery:= ""

	If Valtype(oChart)=="O"
		FreeObj(@oChart) //Usando a função FreeObj liberamos o objeto para ser recriado novamente, gerando um novo gráfico
	Endif

	oChart := FWChartFactory():New()
	oChart := oChart:getInstance( nGrafico ) 
	oChart:init( oScroll )
	oChart:SetTitle("Produtos Finalizados", CONTROL_ALIGN_LEFT)
	oChart:SetMask( "*@*")
	oChart:SetPicture("@E 999,999,999")
	oChart:setColor("Random") //Deixamos o protheus definir as cores do gráfico
	If nGrafico == PIECHART //se o gráfico tipo pizza, deixamos a legenda no rodapé
		oChart:SetLegend( CONTROL_ALIGN_BOTTOM )
	Endif  
	oChart:nTAlign := CONTROL_ALIGN_ALLCLIENT

	//Uma consulta bem Simples


	cQuery := " 	 	SELECT C2_CC,CTT_DESC01,SUM(1) TOTAL	"
	cQuery += "		FROM  "+RetSQLName("SZ1")+" SZ1(NOLOCK)"
	cQuery += "		INNER JOIN "+RetSQLName("SC2")+"  SC2 (NOLOCK) ON SUBSTRING(Z1_OP,1,6) = C2_NUM AND SZ1.D_E_L_E_T_ = ''"
	cQuery += "		INNER JOIN "+RetSQLName("CTT")+"  CTT (NOLOCK) ON CTT.CTT_CUSTO = SC2.C2_CC AND CTT.D_E_L_E_T_ = ''"	
	cQuery += "		WHERE SC2.D_E_L_E_T_ = '' "
	cQuery += "		AND Z1_DTAPONT = '20190918' "    
	cQuery += "       AND C2_LOCAL = '20' "
	cQuery += "		AND C2_CC IN ('5000','6000','5090','7000')"
	cQuery += "		GROUP BY C2_CC,CTT_DESC01 "




	IF Select("cAlias") <> 0
		DbSelectArea("cAlias")
		DbCloseArea()
	ENDIF

	TcQuery cQuery Alias "cAlias" New
	cAlias->(dbGoTop())
	//Se a série for unica o tipo de variável deve ser NUMÉRICO Ex.: (cTitle, 10)
	//Se for multi série o tipo de variável deve ser Array de numéricos Ex.: (cTitle, {10,20,30} )
	If cAlias->(!EOF())
		While cAlias->(!EOF())
			if nGrafico==LINECHART .OR. nGrafico==BARCOMPCHART 
				//Neste dois tipos de graficos temos:
				//(Titulo, {{ Descrição, Valor }})
				oChart:addSerie( "Produto " + CTT_DESC01, { { CTT_DESC01, TOTAL   } } )
			Else
				//Aqui temos:
				//(Titulo, Valor)
				oChart:AddSerie(CTT_DESC01,TOTAL)
			Endif
			cAlias->(dbSkip())
		End
		oChart:build()
	Endif

Return