#INCLUDE "rwmake.ch"
/*/{protheus.doc}HLCTBR01
Relatorio analise SD2
@author Diego Rafael
/*/
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ HLCTBR01   ¦ Autor ¦ Diego Rafael         ¦ Data ¦   /  /2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function HLCTBR01()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := ""
	Local cPict          := ""
	Local titulo         := "Analise SD2"
	Local nLin           := 80
	Local Cabec1         := ""
	Local Cabec2         := ""
	Local imprime        := .T.
	Local aOrd           := {}
	Local cPerg          := PadR("ICFATR03",Len(SX1->X1_GRUPO))
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "ICFATR03" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "ICFATR03" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private aCabec       := {}
	Private cString      := ""
	Private aCol         := {01,19,32,48,101,119,138,176,198}

	aCabec := {{"FILIAL",17},{"DOCUMENTO",11},{"SERIE",14},{"NOTA",14},{"CLIENTE",51},{"CODIGO",16},{"PRODUTO",17},{"TIPO",17},{"TES",36},{"PODER",14},{"CFOP",20},{"QUANT",17},{"TOTAL",20},{"CUSTO",20}}
	aEval(aCabec,{|aPrm| Cabec1 += Padc(aPrm[01],aPrm[02]) + "|" })

	CreatePerg(cPerg)
	Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
	Return Nil
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
	Return  Nil
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
	±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  23/02/10   º±±
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
	Local aLinha := {}
	Private aExport := {}

	cTable := CriaTrab(Nil,.F.)
	SetRegua(MountTable(cTable))

	aEval(aCabec,{|aPrm| aAdd(aLinha,aPrm[01])})
	aAdd(aExport,aClone(aLinha))
	aLinha := {}

	While !(cTable)->(EOF())

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
   
		aAdd(aLinha,(cTable)->FILIAL)
		aAdd(aLinha,(cTable)->DOCUMENTO)
		aAdd(aLinha,(cTable)->SERIE)
		aAdd(aLinha,(cTable)->NOTA)
		aAdd(aLinha,(cTable)->CLIENTE)
		aAdd(aLinha,(cTable)->CODIGO)
		aAdd(aLinha,(cTable)->PRODUTO)
		aAdd(aLinha,(cTable)->TIPO)
		aAdd(aLinha,(cTable)->TES)
		aAdd(aLinha,(cTable)->PODER)
		aAdd(aLinha,(cTable)->CFOP)
		aAdd(aLinha,Transform((cTable)->QUANT,"@E 999,999,999.99"))
		aAdd(aLinha,Transform((cTable)->TOTAL,"@E 999,999,999.99"))
		aAdd(aLinha, Transform((cTable)->CUSTO,"@E 999,999,999.99"))
   
		aAdd(aExport,aClone(aLinha))
		aLinha := {}
	
		nLin := nLin + 1 // Avanca a linha de impressao

		(cTable)->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsgRun("Exportando Dados, Aguarde...",,{|| Exporta()})
	
	MS_FLUSH()

Return

Static Function MountTable(cTable)
	Local cQry := ""
	Local cCampos := " * "
      
	cQry +=                     " Select Count(*) CONT From (
	cQry += Chr(13) + Chr(10) + " Select D2_FILIAL FILIAL, D2_DOC DOCUMENTO, D2_SERIE SERIE, D2_TIPO NOTA, CASE WHEN D2_TIPO = 'B' OR D2_TIPO = 'D' THEN A2_NOME ELSE A1_NOME END CLIENTE, D2_COD CODIGO, B1_DESC PRODUTO, B1_TIPO TIPO, D2_TES TES, F4_PODER3 PODER, D2_CF CFOP, D2_QUANT QUANT, D2_TOTAL TOTAL, D2_CUSTO1 CUSTO  From " + RetSqlName("SD2") +" SD2"
	cQry += Chr(13) + Chr(10) + " INNER JOIN " + RetSqlName("SF2") +" SF2 ON F2_DOC = D2_DOC AND D2_SERIE = F2_SERIE AND D2_FILIAL = F2_FILIAL AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA AND SF2.D_E_L_E_T_ = ' ' "
	cQry += Chr(13) + Chr(10) + " LEFT OUTER JOIN " + RetSqlName("SA1") +" SA1 ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA  AND SA1.D_E_L_E_T_ = ' ' "
	cQry += Chr(13) + Chr(10) + " LEFT OUTER JOIN " + RetSqlName("SA2") +" SA2 ON D2_CLIENTE = A2_COD AND D2_LOJA = A2_LOJA  AND SA1.D_E_L_E_T_ = ' ' "
	cQry += Chr(13) + Chr(10) + " INNER JOIN " + RetSqlName("SF4") +" SF4 ON F4_FILIAL = D2_FILIAL AND F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ = ' ' "
	cQry += Chr(13) + Chr(10) + " INNER JOIN " + RetSqlName("SB1") +" SB1 ON B1_COD = D2_COD AND B1_FILIAL = D2_FILIAL AND SB1.D_E_L_E_T_ = ' ' "
	cQry += Chr(13) + Chr(10) + " WHere SD2.D_E_L_E_T_ = ' ' "
	cQry += Chr(13) + Chr(10) + " AND F4_ESTOQUE = 'S' "
	cQry += Chr(13) + Chr(10) + " And D2_EMISSAO BetWeen '" + DTOS(mv_par01) + "' And '" + DTOS(mv_par02) + "' "
                                                    
	cQry += Chr(13) + Chr(10) + " ) A

	MemoWrit("ICFATR03.sql",cQry)
	
	MPSysOpenQuery( cQry, cTable ) // dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),cTable,.T.,.T.)

	nCont := (cTable)->CONT
	(cTable)->(dbCloseArea(cTable))
	cQry := StrTran(cQry,"Count(*) CONT",cCampos)
	cQry += Chr(13) + Chr(10) + " order by FILIAL, SERIE, DOCUMENTO, PRODUTO "
	
	MPSysOpenQuery( cQry, cTable ) // dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),cTable,.T.,.T.)
 
Return nCont

Static Function CreatePerg(cPerg)
	Local nPerg := Len(SX1->X1_PERGUNT)

	PutSX1(cPerg, "01", "Data De?" ,"Data De?","Data De?"   , "mv_ch1", "D",08, 0, 0, "G", "", "", "", "", "mv_par01")
	PutSX1(cPerg, "02", "Data Ate?","Data Ate?","Data Ate?" , "mv_ch2", "D",08, 0, 0, "G", "", "", "", "", "mv_par02")

Return Nil

Static Function Exporta()

	Local cArqTxt    	:= GetTempPath()+"Saidas.xls"
	Local nHdl     	:= fCreate(cArqTxt)
	Local cLinha     	:= "" //Chr(9)+"Relatório"+Chr(13)+Chr(10)

	If !File(cArqTXT)
		MsgStop("O Arquivo " + cArqTXT + " não pode ser Criado!")
	Return nil
	EndIf

	For i:=1 to Len(aExport)
		cLinha := ""
		IncRegua()
		If ValType(aExport[i])<>"A"
			cLinha += aExport[i]
		Else
			For j := 1 to Len(aExport[i])
				cLinha += aExport[i][j]+Chr(9)
			Next
		Endif
	
		cLinha += chr(13)+chr(10)
	
		If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
		EndIf
	Next

	fClose(nHdl)
	RunExcel(cArqTxt)
Return Nil

**********************************************************************************************************************************

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

Return
