#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*_____________________________________________________________________________
¦ Função    ¦ IMPSZ2     ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 02/03/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Impressão da Formação de Preços											¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function IMPSZ2()

	LOCAL cString := "SZ2"
	LOCAL cDesc1  := "Este programa tem como objetivo emitir uma relação de"
	LOCAL cDesc2  := "formação de preços, conforme parâmetros informados pelo"
	LOCAL cDesc3  := "usuário."

	Private lEnd
	Private wnrel   := "IMPSZ2"
	Private titulo  := "Formação de Preços"
	Private Tamanho := "M"
	PRIVATE aReturn:= { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
	PRIVATE aLinha := { } , nLastKey := 0
	PRIVATE cPerg  := "IMPSZ2"

	ValidPerg()

	pergunte(cPerg,.F.)

	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

	If nLastKey = 27
		Set Filter To
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey = 27
		Set Filter To
		Return
	Endif

	RptStatus({|lEnd| IMPSZ2a()},titulo)				// Distribuição de Tarefas

Return NIL
/*_____________________________________________________________________________
¦ Função    ¦ IMPSZ2a    ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 02/03/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Distribuição de tarefas														¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function IMPSZ2a

	nTipo := IF (aReturn[4] == 1, 15, 18)

	cbtxt    := SPACE(10)
	cbcont   := 00
	li       := 999
	m_pag    := 01

	IMPSZ2b()													// Criação das tabelas temporárias
	IMPSZ2c()													// Apuração dos Dados
	IMPSZ2f()													// Impressão

	If aReturn[5] = 1
		Set Printer TO
		dbCommitAll()
		ourspool(wnrel)
	Endif

	MS_FLUSH()

	TR1->(dbCloseArea())

Return NIL
/*_____________________________________________________________________________
¦ Função    ¦ IMPSZ2b    ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 02/03/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Criação das Tabelas Temporárias											¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function IMPSZ2b

	local cArqTR1	:= "", cArqTR11 := ""
	local aArqTR1	:= {{"X_Cod",		"C", 15, 0},;		// codigo do Pai
	{"X_DesCod",	"C", 30, 0},;		// Descrição do Pai
	{"X_Ordem",		"C", 01, 0},;		// ordem = 1 - Componente, 2 - Divisor
	{"X_Comp",		"C", 15, 0},;		// codigo do componente
	{"X_DesCmp",	"C", 30, 0},;		// Descrição do Componente
	{"X_UniCmp",	"C", 02, 0},;		// Unidade de Medida
	{"X_DatIni",	"D", 08, 0},;		// Data de Início
	{"X_DatFim",	"D", 08, 0},;		// Data de Fim
	{"X_Quant",		"N", 16, 6},;		// Necessidade
	{"X_Custo",		"N", 16, 6},;		// Custo Unitário
	{"X_TipCst",	"C", 01, 0},;		// Tipo de Custo
	{"X_PerPar",	"N", 06, 2}}		// Participação

	cArqTR1  := CriaTrab(aArqTR1, .T.)
	cArqTR11 := CriaTrab(Nil, .F.)

	dbCreate(cArqTR1, aArqTR1)                  										//Cria o arquivo no caminho especificado
	dbusearea(.t.,,cArqTR1, "TR1",.f.)
	indregua("TR1",cArqTR11,"X_Cod + X_Ordem + X_Comp",,,"Criando Arquivo Temporário...")

Return NIL
/*_____________________________________________________________________________
¦ Função    ¦ IMPSZ2c    ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 02/03/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Apuração dos dados										      				¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function IMPSZ2c

	local cQuery

	// Definição da Query - SQL
	cQUERY := "Select"
	cQUERY += "  (Case
	cQUERY += " 	When Z2_COMP Like 'FATOR%'	Then '2'
	cQUERY += " 	Else				 '1'
	cQUERY += " 	End) As Ordem, *"
	cQUERY += " From " + RetSqlName("SZ2") + " As Z2"
	cQuery += ",	 " + RetSqlName("SB1") + " As B1"
	cQuery += " Where Z2.D_E_L_E_T_ = ''"
	cQUERY += " And B1.D_E_L_E_T_ = ''"
	cQUERY += " And Z2_FILIAL = '" + SZ2->(xFilial()) + "'"
	cQUERY += " And B1_FILIAL = '" + SB1->(xFilial()) + "'"
	cQUERY += " And B1_COD = Z2_COD"
	cQUERY += " And B1_COD BetWeen '" + MV_PAR01 + "' And '" + MV_PAR02 + "'"
	cQUERY += " And B1_GRUPO BetWeen '" + MV_PAR03 + "' And '" + MV_PAR04 + "'"
	cQUERY += " And B1_TIPO BetWeen '" + MV_PAR05 + "' And '" + MV_PAR06 + "'"
	cQUERY += " And B1_CC BetWeen '" + MV_PAR07 + "' And '" + MV_PAR08 + "'"

	cQUERY += " And '" + Dtos(dDataBase) + "' BetWeen Z2_DATINI And Z2_DATFIM"

	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,CHANGEQUERY(cQUERY)),"TM1",.F.,.T.)

	SG1->(dbsetorder(1))

	TM1->(dbgotop())

	while !TM1->(eof())

		RecLock("TR1",.T.)
		TR1->X_Cod		:= TM1->Z2_Cod
		TR1->X_DesCod	:= TM1->Z2_DesCod
		TR1->X_TipCst	:= TM1->Z2_TipCst
		TR1->X_Ordem	:= TM1->Ordem
		TR1->X_Comp		:= TM1->Z2_Comp
		TR1->X_DesCmp	:= TM1->Z2_DesCmp
		TR1->X_UniCmp	:= TM1->Z2_UniCmp
		TR1->X_DatIni	:= Stod(TM1->Z2_DatIni)
		TR1->X_DatFim	:= Stod(TM1->Z2_DatFim)
		TR1->X_Quant	:= TM1->Z2_Quant
		TR1->X_Custo	:= TM1->Z2_Custo
		TR1->X_PerPar	:= TM1->Z2_PerPar

		TM1->(dbskip())

	End

	TM1->(dbCloseArea())

return nil
/*_____________________________________________________________________________
¦ Função    ¦ IMPSZ2f    ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 02/03/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Impressão       																¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function IMPSZ2f

	Local cCodAtu := Chr(255)

	cabec1 := "Componente       Descricao                      UM     Início      Final -Necessidade -------Custo -------Custo -----%"
	cabec2 := "                                                     Validade   Validade              ----Unitário -------Total"
	//         XXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX 99/99/9999 99/99/9999 999,999.9999 999,999.9999 999,999.9999 999.99
	//                   1         2         3         4         5         6         7         8         9        10        11        12        13        14
	//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234

	SetRegua(TR1->(Recno()))

	TR1->(dbGoTop())

	While !TR1->(Eof())

		IF lEnd
			@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
			Exit
		End IF

		IncRegua()

		If Li > Mv_Par09 .Or. TR1->X_Cod <> cCodAtu

			cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)

			@ Li, 000 PSay "Produto: " + TR1->X_Cod + "  " + TR1->X_DesCod

			li += 2

			cCodAtu := TR1->X_Cod

		End If

		If TR1->X_Ordem == "2"
			Li++
		End If

		@ Li,000 PSay TR1->X_Comp

		If TR1->X_Ordem == "1"
			@ Li,017 PSay TR1->X_DesCmp
			@ Li,048 PSay TR1->X_UniCmp
			@ Li,051 PSay TR1->X_DatIni
			@ Li,062 PSay TR1->X_DatFim
		End If

		@ Li,073 PSay TR1->X_Quant		Picture "@E 999,999.9999"
		@ Li,086 PSay TR1->X_Custo		Picture "@E 999,999.9999"
		@ Li,099 PSay TR1->X_Quant * TR1->X_Custo	Picture "@E 999,999.9999"

		If TR1->X_Ordem == "1"
			@ Li,112 PSay TR1->X_PerPar	Picture "@E 999.99"
		End If

		Li++

		TR1->(dbSkip())

	End

Return Nil
/*_____________________________________________________________________________
¦ Função    ¦ ValidPerg  ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 02/03/2009 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Criação das Perguntas        												¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidPerg()

	u_InPutSx1(cPerg, "01", "Produto de",		"","","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01")
	u_InPutSx1(cPerg, "02", "Produto Ate",		"","","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02")
	u_InPutSX1(cPerg, "03", "Grupo de",			"","","mv_ch3","C",04,0,0,"G","","SBM","","","mv_par03")
	u_InPutSX1(cPerg, "04", "Grupo Ate",			"","","mv_ch4","C",04,0,0,"G","","SBM","","","mv_par04")
	u_InPutSX1(cPerg, "05", "Tipo de",			"","","mv_ch5","C",02,0,0,"G","","02",	"","","mv_par05")
	u_InPutSX1(cPerg, "06", "Tipo Ate",			"","","mv_ch6","C",02,0,0,"G","","02",	"","","mv_par06")
	u_InPutSX1(cPerg, "07", "CC de",				"","","mv_ch7","C",09,0,0,"G","","CTT","","","mv_par07")
	u_InPutSX1(cPerg, "08", "CC Ate",				"","","mv_ch8","C",09,0,0,"G","","CTT","","","mv_par08")
	u_InPutSX1(cPerg, "09", "Linhas/Página",	"","","mv_ch9","N", 2,0,0,"G","","",	"","","mv_par09")

Return Nil
