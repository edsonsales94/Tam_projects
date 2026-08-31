#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*______________________________________________________________________________
¦ Programa  ¦ PLCOMR02   ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 16/09/2011 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Análise de Ponto de Pedido x Consumo										  ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLCOMR02

	Local cDesc1   := "Emite uma relacao dos itens de compra listando Ponto de"
	Local cDesc2   := "Pedido e Consumo por período."
	Local cDesc3   := ""

	Private wnrel	  := "PLCOMR02"
	Private lEnd     := .f.
	Private limite   := 80
	Private Tamanho  := "P"
	Private nomeprog := "PLCOMR02"
	Private cString  := "SB1"
	Private aReturn  := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 }
	Private nLastKey := 0
	Private cPerg    := padr("PLCOMR02",Len(SX1->X1_GRUPO))
	Private titulo   := "Ponto de Pedido x Consumo"
	Private li       := 80
	Private m_pag    := 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ajusta o grupo de Perguntas                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AjustaSX1()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01             // Produto de                           ³
	//³ mv_par02             // Produto ate                          ³
	//³ mv_par03             // Grupo de                             ³
	//³ mv_par04             // Grupo ate                            ³
	//³ mv_par05             // Tipo de                              ³
	//³ mv_par06             // Tipo ate                             ³
	//³ mv_par07             // Local de                             ³
	//³ mv_par08             // Local ate                            ³
	//³ mv_par09             // Consumo de                           ³
	//³ mv_par10             // Consumo ate                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte(cPerg,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel:=SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho)

	If nLastKey = 27
		dbClearFilter()
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey = 27
		dbClearFilter()
		Return
	Endif

	RptStatus( { || PLCOMR02a() }, Titulo )

Return .T.
/*______________________________________________________________________________
¦ Programa  ¦ PLCOMR02a  ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 16/09/2011 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Análise de Ponto de Pedido x Consumo										  ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PLCOMR02a

	Local cRodaTxt := "PRODUTO(S)"
	Local cabec1   := ""
	Local cabec2   := ""
	Local cQuery	:= ""
	Local nCntImpr := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTipo  := IIf(aReturn[4]==1,15,18)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta os Cabecalhos                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cabec1 := "CODIGO          DESCRICAO               TP GRP  UM       PONTO DE      CONSUMO NO"
	cabec2 := "                                                           PEDIDO         PERIODO"
	*****      123456789012345 12345678901234567890    12 1234 12 999.999.999,99  999.999.999,99
	*****      0         1         2         3         4         5         6         7         8
	*****      012345678901234567890123456789012345678901234567890123456789012345678901234567890

	li := 80 // Reinicia Paginas

	dbSelectArea("SB1")
	ProcRegua(RecCount())

	cQuery := "Select B1_COD, B1_DESC, B1_TIPO, B1_GRUPO, B1_UM, B1_EMIN, D3_QUANT
	cQuery += " From " + RetSQLName("SB1")

	cQuery += " 	Left Join
	cQuery += " 	(Select D3_FILIAL, D3_COD, SUM(D3_QUANT) D3_QUANT
	cQuery += " 		From " + RetSQLName("SD3")
	cQuery += " 		Where D_E_L_E_T_ = ''
	cQuery += " 		And D3_FILIAL = '" + SD3->(xFilial()) + "'
	cQuery += " 		And D3_ESTORNO = ''
	cQuery += " 		And D3_LOCAL Between '" + mv_Par07 + "' And '" + mv_Par08 + "'
	cQuery += " 		And D3_EMISSAO Between '" + Dtos(mv_Par09) + "' And '" + Dtos(mv_Par10) + "'

	cQuery += " 		And D3_CF In ('RE0','RE1','RE2','RE6')
	cQuery += " 		Group by D3_FILIAL, D3_COD
	cQuery += " 	) D3
	cQuery += " 	On B1_COD = D3_COD

	cQuery += " 	Where D_E_L_E_T_ = ''
	cQuery += " 	And B1_FILIAL = '" + SB1->(xFilial()) + "'
	cQuery += " 	And B1_COD Between '" + mv_Par01 + "' And '" + mv_Par02 + "'
	cQuery += " 	And B1_GRUPO Between '" + mv_Par03 + "' And '" + mv_Par04 + "'
	cQuery += " 	And B1_TIPO Between '" + mv_Par05 + "' And '" + mv_Par06 + "'

	cQuery += " 	And B1_TIPO Not In ('PA','PI','MO')
	cQuery += " 	And D3_QUANT > B1_EMIN

	TCQUERY cQuery NEW ALIAS "TB1"

	While !TB1->(Eof())

		If lEnd
			@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
			Exit
		Endif

		Incproc("Imprimindo...")

		If !Empty(aReturn[7])
			If !&(aReturn[7])
				dbSkip()
				Loop
			Endif
		EndIf

		If Li > 65
			Li := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
			lImpCab := .T.
		End If

		@ li,000 PSAY TB1->B1_COD
		@ li,016 PSAY SubStr(TB1->B1_DESC,1,20)
		@ li,040 PSAY TB1->B1_TIPO
		@ li,043 PSAY TB1->B1_GRUPO
		@ li,048 PSAY TB1->B1_UM
		@ li,051 PSAY TB1->B1_EMIN		Picture "@E 999,999,999.99"//PesqPictQt("B1_LE",15)
		@ li,067 PSAY TB1->D3_QUANT	Picture "@E 999,999,999.99"//PesqPictQt("B1_LE",15)

		li++

		TB1->(dbSkip())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adiciona 1 ao contador de registros impressos         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nCntImpr++

	End

	If li != 65
		Li++
		Roda(nCntImpr,cRodaTxt,Tamanho)
	EndIf

	TB1->(dbCloseArea())

	If aReturn[5] = 1
		Set Printer To
		dbCommitAll()
		OurSpool(wnrel)
	EndIf

	MS_FLUSH()

Return .T.
/*______________________________________________________________________________
¦ Programa  ¦ AjustaSX1  ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 16/09/2011 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Grupo de perguntas da rotina												  ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function AjustaSX1()

	u_InPutSX1(cPerg,"01","Do Produto",		"","","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01")
	u_InPutSX1(cPerg,"02","Ate o Produto",	"","","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02")
	u_InPutSX1(cPerg,"03","Do Grupo",			"","","mv_ch3","C",04,0,0,"G","","SBM","","","mv_par03")
	u_InPutSX1(cPerg,"04","Ate o Grupo",		"","","mv_ch4","C",04,0,0,"G","","SBM","","","mv_par04")
	u_InPutSX1(cPerg,"05","Do Tipo",			"","","mv_ch5","C",02,0,0,"G","","02",	"","","mv_par05")
	u_InPutSX1(cPerg,"06","Ate o Tipo",		"","","mv_ch6","C",02,0,0,"G","","02",	"","","mv_par06")
	u_InPutSX1(cPerg,"07","Do Local",			"","","mv_ch7","C",02,0,0,"G","","AL",	"","","mv_par07")
	u_InPutSX1(cPerg,"08","Ate o Local",		"","","mv_ch8","C",02,0,0,"G","","AL",	"","","mv_par08")
	u_InPutSX1(cPerg,"09","Do Período",		"","","mv_ch9","D", 8,0,0,"G","","",	"","","mv_par09")
	u_InPutSX1(cPerg,"10","Ate o Período",	"","","mv_chA","D", 8,0,0,"G","","",	"","","mv_par10")

Return Nil
