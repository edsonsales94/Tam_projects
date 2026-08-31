#include "rwmake.ch"
#Include "Protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ EEXTRATO   ¦ Autor ¦ Stan Lee Lopes    ¦ Data ¦ 31/10/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Exporta arquivo de venda para o e-Extrato  		      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function EEXTRATO()

	Private oDlg
	Private cPerg := PADR("EEXTRATO", Len(SX1->X1_GRUPO))

	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)

	@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Arquivo e-Extrato")
	@ 05,05 TO 084,188
	@ 15,018 Say " Este programa tem a finalidade de gerar o arquivo de integração "
	@ 28,018 Say " para que seja feita a conciliação das vendas feitas nos cartões."
	@ 60,056 BMPBUTTON TYPE 05 ACTION Pergunte("EEXTRATO",.T.)
	@ 60,088 BMPBUTTON TYPE 01 ACTION Ok()
	@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oDlg)
	Activate Dialog oDlg Centered

Return

/*/
+---------------------------------------------------------------------------------------------+
| Programa     | OK               | Autor | Stan Lee Lopes        | Data | 31/10/2018      |
+--------------+------------------------------------------------------------------------------+
| Descricao    | Chama a funcao de exportacao e gravacao dos registros para o arquivo texto.  |
+---------------------------------------------------------------------------------------------+
/*/
Static Function Ok()

	Processa({|| Exportacao() },"Gerando arquivo e-Extrato...")
	Close(oDlg)

Return

/*/
+---------------------------------------------------------------------------------------------+
| Programa     | Exportacao       | Autor | Stan Lee Lopes        | Data | 31/10/2018      |
+--------------+------------------------------------------------------------------------------+
| Descricao    | Filtra as vendas realizadas nos cartoes de credito ou debito e grava no      |
|              | arquivo texto.                                                               |
+---------------------------------------------------------------------------------------------+
/*/
Static Function Exportacao()

	Local _cQry			:= ""		// Query SQL.
	Local _cReg			:= ""		// Registro a ser gravado no arquivo.
	Local _aNSU			:= {}		// Array responsavel por armazenar as informacoes por NSU.
	Local _lFirst		:= .T.		// Flag para indicar primeiro registro.
	Local _cLoja        := ""       // Filial parametro
	Private _cArqTxt	:= ""		// Caminho + nome do arquivo txt.

	_cArqTxt := Alltrim(mv_par01)+"EXTRATO_PELMEX_"+DtoS(mv_par02)+"_"+DtoS(mv_par03)+".txt"		// Caminho + nome do arquivo (c:\eextrato\ext_ramsons_201501.txt).

	//+---------------------------------------------------------------------+
	//| Checar se o arquivo existe.                                         |
	//+---------------------------------------------------------------------+
	If File(_cArqTxt)
		If MsgBox("O arquivo já existe. Deseja apagá-lo ? ","Arquivo","YESNO")
			Delete File &_cArqTxt
		Else
			Return					// Fechar a rotina.
		Endif
	Endif

	//+---------------------------------------------------------------------+
	//| Grava o cabecalho do arquivo.                                       |
	//+---------------------------------------------------------------------+
	_cReg := "Data;NSU;NSU_TEF;Autorizacao;Valor;Plano;Rede;Bandeira;Loja;Estabelecimento;Cliente;Caixa"
	Grava(_cReg)                                   
	_cReg := ""

	//+---------------------------------------------------------------------+
	//| Filtro das vendas feitas em cartoes de credito ou debito.           |
	//+---------------------------------------------------------------------+

	_cQry := " SELECT	SL1.L1_FILIAL AS FIL, "
	_cQry += "			SL1.L1_EMISNF AS DATA,  "
	//_cQry += " 			SL4.L4_DOCTEF AS NSU,   " 
	_cQry += " 			SL4.L4_NUMCART AS NSU,   "
	_cQry += " 			SL4.L4_NSUTEF AS NSUTEF,  "
	_cQry += " 			SL4.L4_AUTORIZ AS AUT,  "
	_cQry += " 			SUM(SL4.L4_VALOR) AS VALOR, "
	_cQry += " 			COUNT(*) AS PLANO,   "
	_cQry += " 			SL4.L4_ADMINIS AS BANDEIRA,  "
	_cQry += " 			'FIL '+SL1.L1_FILIAL + ' NUM ' + SL1.L1_NUM +' CLI '+ SL1.L1_CLIENTE +'-'+SL1.L1_LOJA AS HISTORICO,  "
	_cQry += " 			SL1.L1_OPERADO AS CAIXA   "
	_cQry += " FROM "+RetSqlName("SL1")+" SL1 (NOLOCK)   "
	_cQry += " INNER JOIN "+RetSqlName("SL4")+" SL4 (NOLOCK) ON SL4.D_E_L_E_T_ = ' ' AND SL1.L1_FILIAL = SL4.L4_FILIAL AND SL1.L1_NUM = SL4.L4_NUM   "
	_cQry += " 						 AND SL4.L4_FORMA IN ('CD','CC') AND SL4.L4_DOCCANC = ' '   "
	_cQry += " INNER JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) ON SA1.D_E_L_E_T_ = ' ' AND SL1.L1_CLIENTE = SA1.A1_COD AND SL1.L1_LOJA = SA1.A1_LOJA   "
	_cQry += " WHERE	SL1.D_E_L_E_T_ = ' '   "
	_cQry += " 		AND SL1.L1_EMISNF BETWEEN '"+dtos(mv_par02)+"' AND '"+dtos(mv_par03)+"'  "
	_cQry += " 		AND (SL1.L1_DOC!='' OR SL1.L1_DOCPED!='')  "
	_cQry += " 		AND SL1.L1_FILRES=''  "
	_cQry += " 		AND SL1.L1_FILIAL BETWEEN '' AND 'ZZ' "
	//_cQry += " 		AND SL1.L1_FILIAL BETWEEN '"+mv_par04+"' AND '"+mv_par05+"' "
	//_cQry += " GROUP BY L1_EMISNF,L4_DOCTEF,L4_NSUTEF,L4_AUTORIZ,L4_ADMINIS,L1_FILIAL,L1_NUM,L1_CLIENTE,L1_LOJA,L1_OPERADO "   
	_cQry += " GROUP BY L1_EMISNF,L4_NUMCART,L4_NSUTEF,L4_AUTORIZ,L4_ADMINIS,L1_FILIAL,L1_NUM,L1_CLIENTE,L1_LOJA,L1_OPERADO "  

	_cQry += " UNION ALL "

	_cQry += " SELECT	E1_FILORIG AS FIL, " 	
	_cQry += " 			E1_EMISSAO AS DATA,  "
	//_cQry += " 			E1_DOCTEF AS NSU,   "
	_cQry += " 			E1_NUMCART AS NSU,   "
	_cQry += " 			E1_NSUTEF AS NSUTEF,  "
	_cQry += " 			'' AS AUT,  "
	_cQry += " 			SUM(E1_VLRREAL) AS VALOR, "
	_cQry += " 			COUNT(*) AS PLANO,   "
	_cQry += " 			E1_CLIENTE AS BANDEIRA,  "
	_cQry += " 			'FIL ' + E1_FILORIG + ' REC TIT '+E1_NUM AS HISTORICO,   "
	_cQry += " 			E1_PORTADO AS CAIXA  		 "
	_cQry += " FROM "+RetSqlName("SE1")+" SE1  "
	_cQry += " WHERE	SE1.D_E_L_E_T_=''  "
	//_cQry += " 		AND E1_FILORIG BETWEEN '"+mv_par04+"' AND '"+mv_par05+"' "
	_cQry += " 		AND E1_FILORIG BETWEEN '' AND 'ZZ' "
	_cQry += " 		AND E1_EMISSAO BETWEEN '"+dtos(mv_par02)+"' AND '"+dtos(mv_par03)+"'  "
	_cQry += " 		AND E1_TIPO IN ('CC','CD')  "      
	_cQry += " 		AND E1_PREFIXO ='REC' "
	//_cQry += " GROUP BY E1_EMISSAO,E1_DOCTEF,E1_NSUTEF,E1_CLIENTE,E1_FILORIG,E1_PORTADO,E1_NUM "
	_cQry += " GROUP BY E1_EMISSAO,E1_NUMCART,E1_NSUTEF,E1_CLIENTE,E1_FILORIG,E1_PORTADO,E1_NUM "
	_cQry += " ORDER BY HISTORICO "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"TMP1",.T.,.T.)
	dbSelectArea("TMP1")
	dbGoTop()
	While !EOF()
		Incproc("Exportando vendas...")

		cFilAnt:= TMP1->FIL
		_cReg  := '' 
		//	_cLoja := iif(AllTrim(GetMv("MV_EMPTEF"))="00000009","09",TMP1->FIL)  // Alterado para filial CHAVES e Rayana devido ao conciliador boa vista.             
		_cLoja := right(AllTrim(GetMv("MV_EMPTEF")),2)  // Alterado para filial CHAVES e RAYANA devido ao conciliador boa vista.            

		_cReg += TMP1->DATA + ";" 													// DATA DE EMISSAO
		_cReg += AllTrim(TMP1->NSU) + ";"                                           // NSU OPERADORA
		_cReg += AllTrim(TMP1->AUT) + ";"                                           // AUTORIZACAO
		_cReg += AllTrim(TMP1->NSUTEF) + ";"                                        // NSU SITEF
		_cReg += cValToChar(AllTrim(Transform(TMP1->VALOR,"@E 9999999.99"))) + ";"  // VALOR
		_cReg += Alltrim(Str(TMP1->PLANO)) + ";"                                    // PLANO
		_cReg += ";"                                                                // REDE
		_cReg += Bandeira(SubStr(AllTrim(TMP1->BANDEIRA),1,3)) + ";"                // BANDEIRA
		_cReg += TMP1->FIL + ";"                                                    // LOJA 
		//_cReg += _cLoja + ";"                                                       // LOJA		
		_cReg += AllTrim(GetMv("MV_EMPTEF"))+";"                                    // ESTABELECIMENTO
		_cReg += AllTrim(TMP1->HISTORICO) + ";"                                     // CLIENTE
		_cReg += TMP1->CAIXA                                                        // CAIXA

		//+---------------------------------------------------------------------+
		//| Gravar as informacoes do registro no arquivo txt.                   |
		//+---------------------------------------------------------------------+
		Grava(_cReg)

		dbSelectArea("TMP1")
		dbSkip()
	Enddo
	dbSelectArea("TMP1")
	dbCloseArea()

	MsgInfo("Arquivo gerado em: " + _cArqTxt)

Return

/*/
+---------------------------------------------------------------------------------------------+
| Programa     | Grava            | Autor | Stan Lee Lopes        | Data | 31/10/2018      |
+--------------+------------------------------------------------------------------------------+
| Descricao    | Cria, abre, fecha arquivo.                                                   |
+---------------------------------------------------------------------------------------------+
/*/
Static Function Grava(Texto)

	Local _cString := Texto

	If !File(_cArqTxt)
		fHandle := FCREATE(_cArqTxt)
	Else
		fHandle := FOPEN(_cArqTxt,2)
	Endif

	_cString := Texto+CHR(13)+CHR(10)

	FSEEK(fHandle,0,2)
	FWRITE(fHandle,_cString)
	FCLOSE(fHandle)

Return

/*/
+---------------------------------------------------------------------------------------------+
| Programa     | Bandeira         | Autor | Stan Lee Lopes        | Data | 31/10/2018      |
+--------------+------------------------------------------------------------------------------+
| Descricao    | Retorna o codigo da bandeira do cartao conforme manual de integracao.        |
+---------------------------------------------------------------------------------------------+
/*/
Static Function Bandeira(adm)

	Local _cRet := ""			// Retorno da funcao.  

	SAE->(dbSetOrder(1))
	If SAE->(dbSeek(xFilial('SAE')+adm))
		_cRet := AllTrim(SAE->AE_GRPFRT)
	EndIF
Return _cRet

/*/
+---------------------------------------------------------------------------------------------+
| Programa     | ValidPerg        | Autor | Stan Lee Lopes        | Data | 31/10/2018      |
+--------------+------------------------------------------------------------------------------+
| Descricao    | Cria as perguntas no SX1.                                                    |
+---------------------------------------------------------------------------------------------+
/*/
Static Function ValidPerg()

	Local aArea		:= GetArea()
	Local aHelpP01	:= {}
	Local aHelpE01	:= {}
	Local aHelpS01	:= {}
	Local aHelpP02	:= {}
	Local aHelpE02	:= {}
	Local aHelpS02	:= {}
	Local aHelpP03	:= {}
	Local aHelpE03	:= {}
	Local aHelpS03	:= {}
	Local aHelpP04	:= {}
	Local aHelpE04	:= {}
	Local aHelpS04	:= {}
	Local aHelpP05	:= {}
	Local aHelpE05	:= {}
	Local aHelpS05	:= {}

	Aadd(aHelpP01, "Informe o caminho onde será gerado")
	Aadd(aHelpP01, "o arquivo de integração e-Extrato.")
	Aadd(aHelpE01, ".")
	Aadd(aHelpS01, ".")

	Aadd(aHelpP02, "Informe a data inicial.           ")
	Aadd(aHelpE02, ".")
	Aadd(aHelpS02, ".")

	Aadd(aHelpP03, "Informe a data final.             ")
	Aadd(aHelpE03, ".")
	Aadd(aHelpS03, ".")

	Aadd(aHelpP04, "Informe a filial inicial. Caso for")
	Aadd(aHelpP04, "considerar todas as filiais, deixe")
	Aadd(aHelpP04, "esta pergunta em braco.           ")
	Aadd(aHelpE04, ".")
	Aadd(aHelpS04, ".")

	Aadd(aHelpP05, "Informe a filial final. Caso for  ")
	Aadd(aHelpP05, "considerar todas as filiais, pre- ")
	Aadd(aHelpP05, "encha esta pergunta com ZZ.       ")
	Aadd(aHelpE05, ".")
	Aadd(aHelpS05, ".")

	//u_RMPutSx1("EEXTRATO","01","Caminho geração do arquivo ",".",".","mv_ch1","C",50,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpP01,aHelpE01,aHelpS01)
	//u_RMPutSx1("EEXTRATO","02","Da Emissao                 ",".",".","mv_ch2","D", 8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpP02,aHelpE02,aHelpS02)
	//u_RMPutSx1("EEXTRATO","03","Ate a Emissao              ",".",".","mv_ch3","D", 8,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",aHelpP03,aHelpE03,aHelpS03)

	RestArea(aArea)

Return