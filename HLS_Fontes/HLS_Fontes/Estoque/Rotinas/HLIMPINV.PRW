#include 'protheus.ch'
#include 'rwmake.ch'
#include 'topconn.ch'
#include 'colors.ch'
#include 'font.ch'

/*/{protheus.doc}HLIMPINV
Rotina que importa a para o inventário tendo como base planilhas do Excel (*.csv)
@author TEOFILO ALVES MONTEIRO FILHO - TOTVS IP Alterado Por Junior
@since 01/07/2010
/*/

/*
Programa 	: HLIMPINV.PRW
Data 		: 01/07/2010
Cliente  	: Honda Lock
Uso      	: Rotina que importa a para o inventário tendo como base planilhas do Excel (*.csv)
Autor    	: TEOFILO ALVES MONTEIRO FILHO - TOTVS IP Alterado Por Junior
Tabelas Env : SB1, SB2, SB8, SB7
*/

User Function HLIMPINV()   &&  U_HLIMPINV()

	Private oLeTxt                         && Janela de Dialogo
	Private Arquivo := Space(40)           && Arquivo Texto Selecionado
	Private cArqTRB := ""                  && Arquivo de Trabalho Temporario
	Private cArqEdi := ""                  && Arquivo Texto a Processar
	Private cArqCop := ""                  && Arquivo de Copia
	Private cPerg   := "HLIMPINV01"        && Pergunta Padrao Especificada
	Private dData	:= CToD( cValToChar(Day(dDataBase)) + "/" + cValToChar(month(dDataBase)) + "/" + cValToChar(year(dDataBase)) )
	Private cDoc	:= cValToChar(StrZero(Day(dDataBase),2)) + cValToChar(StrZero(month(dDataBase),2)) + Right(cValToChar(year(dDataBase)),2) + "01"
	Private lGeraprv, dDataprv
	Private lExec	:= .T.
	Private _lImpOK := .T.
	Private cGetLOC := ""
	Private aGetLOC	:= {}
	Public _cNroImp := ""

	// Distincts de Armazen do SB2
	IncProc("Processando Armazém....")
	cQuery	:=	"SELECT "
	cQuery	+=		"Distinct(B2_LOCAL) AS B2LOCAL "
	cQuery	+=	"FROM "
	cQuery	+=		RETSQLNAME("SB2") + " SB2 "
	cQuery	+=	"WHERE "
	cQuery	+=		"SB2.D_E_L_E_T_ = ' ' "
	//cQuery	+=		"SB2.B2_FILIAL = '"+xFILIAL()+"' "
	cQuery	+=	"ORDER BY "
	cQuery	+=		"B2LOCAL "

	TCQUERY cQuery ALIAS "QrySB2" NEW
	AAdd( aGetLOC, "Selecione" )
	While QrySB2->( !Eof() )
		AAdd( aGetLOC, QrySB2->B2LOCAL  )
		QrySB2->(dbSkip())
	End
	QrySB2->(DBCloseArea())

	@ 200, 001 To 450, 400 Dialog oLeTxt Title OemToAnsi("Importação do inventário")
	@ 002, 004 To 050, 200 Title OemToAnsi("Comentário : ")
	@ 009, 020 Say "Este programa tem como objetivo fazer a importação de um         "
	@ 019, 020 Say "arquivo texto, gerado em Planilha Excel (extensão .csv)          "
	@ 029, 020 Say "contendo movimentos de Inventário descartando Produtos Bloqueados"
	@ 039, 020 Say "o diretório de exportação padrão é o c:\inventario 				 "
	@ 052, 004 To 085, 200 Title OemToAnsi("Propriedades : ")
	@ 059, 010 Say "Diretório : "
	@ 069, 010 Say "Armazém : "
	@ 069, 040 COMBOBOX oCbx1 VAR cGetLOC ITEMS aGetLOC SIZE 030, 010 OF oLeTxt PIXEL
	@ 069, 080 Say "Dt/Doc: "
	@ 069, 100 Get dData Size 40, 10
	@ 069, 140 Get cDoc Size 40, 10
	@ 085, 004 To 115, 200 Title OemToAnsi("Opções : ")
	@ 095, 025 BUTTON "Exp Excel" Size 38,10 ACTION ExportEXL()
	@ 095, 065 BUTTON "Sel Arquivo" Size 38,10 ACTION SelecArq()
	@ 095, 105 BUTTON "Imp Excel" Size 38,10 ACTION Close(oLeTxt)
	@ 095, 145 BUTTON "Sair" Size 38,10 ACTION (lExec := .F.,Close(oLeTxt))

	Activate Dialog oLeTxt Centered

	If !lExec
		return(.t.)
	Endif

	If MsgBox("Confirma a Importação das Digitações Movimentos?", "Atenção !!!", "YESNO")
		_cNomeTXT := Iif(Empty(MV_PAR03),"C:\INVENTARIO.CSV", MV_PAR03 )
		Processa({|| Converte()}, "Conversão das Digitações (.csv)")
	Endif

Return

Static Function SelecArq()

	&& Tipos de Arquivo a Importar
	cTipo :=         "*.CSV           | *.CSV |   "
	cTipo := cTipo + "*.TXT           | *.TXT |   "
	cTipo := cTipo + "Todos os Arquivos *.* | *.* "

	Arquivo := cGetFile(cTipo, "Seleção de Arquivo")
	Arquivo := Alltrim(Arquivo)

	@ 048, 035 Get Arquivo When .F. Size 100, 10

Return (.T.)


Static Function Converte()

	If !Empty(Arquivo)
		cArqTxt := Alltrim(Arquivo)         	// Arquivo Texto Selecionado
	EndIf

	Private	_cCodigo	:= Space(15)
	Private	_cTipo		:= Space(20)
	Private _cGrupo		:= Space(04)
	Private _cUM		:= Space(02)
	Private _cArmazen	:= Space(02)
	Private	_nQuant		:= 0

	If File(cArqTxt)                       				// Se o Arquivo Existir, Processa-lo

		aStruct := {}                       			// Estrutura do Arquivo Temporario
		Aadd(aStruct, {"REGISTRO", "C", 900, 0})

		// cArqTRB := CriaTrab(aStruct, .T.)
		// DbUseArea(.T.,, cArqTRB, "TRB", .T., .F.)
		// Append From &cArqTxt. SDF           			// Converter TXT p/ DBF (Appendar Registros)

		// Instancio o objeto
		oTable  := FwTemporaryTable():New( "TRB" )
		// Adiciono os campos na tabela
		oTable:SetFields( aStruct )
		// Adiciono os índices da tabela
		// oTable:AddIndex( '01' , { cIndxKEY })
		// Crio a tabela no banco de dados
		oTable:Create()

		cNomArq := ""                          			// Arquivo Temporario p/ confirmação da conversão
		cIndArq := ""
		aCampos := {}

		aAdd(aCampos, {"B7_COD"			, "C", 15, 0})  // Quantidade
		aAdd(aCampos, {"B7_LOCAL"		, "C", 02, 0})  // Armazém
		aAdd(aCampos, {"B7_DOC"			, "C", 09, 0})  // Documento
		aAdd(aCampos, {"B7_DESC" 		, "C", 40, 0})  // Descricao do produto
		aAdd(aCampos, {"B7_QUANT"		, "N", 12, 2})  // Quantidade
		aAdd(aCampos, {"B7_DATA"		, "D", 08, 0})  // Data do inventário
		aAdd(aCampos, {"B7_LOTECTL"		, "C", 10, 0})  // Lote
		aAdd(aCampos, {"B7_DTVALID"		, "D", 08, 0})  // Data de Validade

		If Select("INV") > 0
			INV->(DbCloseArea())
		Endif

		// cNomArq := CriaTrab(aCampos, .T.)
		// DbUseArea(.T.,, cNomArq, "INV", .F., .F.)
		// cIndArq  := CriaTrab(Nil, .F.)
		// cChavInd := "DTOC(B7_DATA) + B7_COD + B7_LOTECTL"
		// IndRegua("INV", cIndArq, cChavInd,,, "Selecionando Registros ...")
		// DbSelectArea("INV")
		// DbSetIndex(cIndArq + OrdBagExt())

		// Instancio o objeto
		oTable  := FwTemporaryTable():New( "INV" )
		// Adiciono os campos na tabela
		oTable:SetFields( aCampos )
		// Adiciono os índices da tabela
		oTable:AddIndex( '01' , { "DTOC(B7_DATA) + B7_COD + B7_LOTECTL" })
		// Crio a tabela no banco de dados
		oTable:Create()

		DbSelectArea("TRB")
		ProcRegua(TRB->(LastRec()))
		DbGoTop()

		Do While TRB->(!Eof())
			IncProc("Processando ...."+Str(Recno(),5))

			If Empty(TRB->REGISTRO) .Or. ;
					Left(TRB->REGISTRO,03)="KEY".Or. ;
					Left(TRB->REGISTRO,06)="Codigo" .Or.;
					Left(TRB->REGISTRO,08)=";;;;;;;;" .Or.;
					Left(TRB->REGISTRO,10)="OBSERVACOE" .Or.;
					Left(TRB->REGISTRO,107)="Respons"
				DbSelectArea("TRB")
				DbSkip()
				Loop
			EndIf

			_cCod		:= Space(15)
			_cLocal		:= Space(02)
			_nQuant		:= 0
			_cDesc		:= Space(40)
			_cLoteCTL	:= Space(10)

			AchaCampo(TRB->REGISTRO)    // Encontrar os Campos Necessarios do Registro

			If _cCod <> "Codigo"
				DbSelectArea("INV")
				RecLock("INV",.T.)
				INV->B7_COD			:= _cCod
				INV->B7_LOCAL		:= _cLocal
				INV->B7_DOC			:= cDoc
				INV->B7_DESC		:= _cDesc
				INV->B7_QUANT		:= _nQuant
				INV->B7_DATA		:= dData
				INV->B7_LOTECTL		:= _cLoteCTL
				INV->B7_DTVALID		:= Ctod("31/12/49")
				MsUnLock()
			Endif

			DbSelectArea("TRB")
			DbSkip()

		End Do

		DbSelectArea("TRB")                 // Apagar Arquivos Temporarios

		TRB->(DbCloseArea())
		Ferase(cArqTRB + ".DBF")

	Else
		Alert("Arquivo Texto " + cArqTxt + " Não Encontrado !!!")
	Endif

	lGerado := .F.
	lIntegrado := .F.

	// dBsELECTaREA("INV")
	// Copy To TEOINVDBF.DBF

	DbSelectArea("INV")
	DbGoTop()
	ProcRegua(INV->(LastRec()))
	_nContador := 1
	Do While !Eof()

		DbSelectArea("SB7")
		DbSetOrder(3)
		If DbSeek(xFilial("SB7") + INV->B7_COD  + INV->B7_LOCAL + INV->B7_LOTECTL, .T.)
			If _nContador < 10
				Alert("Achou...."+ INV->B7_COD  + INV->B7_LOCAL + INV->B7_LOTECTL)
				_nContador++
			Endif
			DbSelectArea("INV")
			DbSkip()
			Loop
		Endif
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+INV->B7_COD,.F.)

		DbSelectArea("INV")
		_aInvent := {}
		aAdd(_aInvent,{"B7_FILIAL"  ,xFilial("SB7") ,Nil})
		aAdd(_aInvent,{"B7_COD"     ,INV->B7_COD    ,Nil})
		aAdd(_aInvent,{"B7_LOCAL"   ,INV->B7_LOCAL  ,Nil})
		aAdd(_aInvent,{"B7_DOC"     ,INV->B7_DOC    ,Nil})
		aAdd(_aInvent,{"B7_QUANT"   ,INV->B7_QUANT  ,Nil})
		aAdd(_aInvent,{"B7_DATA"    ,INV->B7_DATA   ,Nil})
		aAdd(_aInvent,{"B7_LOTECTL" ,INV->B7_LOTECTL ,Nil})

		If !Empty(INV->B7_LOTECTL) .Or. SB1->B1_RASTRO # "N"
			aAdd(_aInvent,{"B7_LOTECTL" ,INV->B7_LOTECTL   ,Nil})
			aAdd(_aInvent,{"B7_DTVALID" ,CToD("31/12/2049"),Nil})
		EndIf

		lGerado	:= .T.
		_nOper	:= 3
		If Len(_aInvent) > 0
			lMsErroAuto := .F.
			//		LjMsgRun("Incluindo Inventário automaticamente... "+INV->B7_COD+" "+INV->B7_LOCAL+" "+INV->B7_LOTECTL+" "+Strzero(Recno(),6),,{||MSExecAuto( {|x,y,z,w|	MATA270( x, y, z, w ) }, _aInvent, _nOper, .F. )})
			LjMsgRun("Incluindo Inventário automaticamente... "+INV->B7_COD+" "+INV->B7_LOCAL+" "+INV->B7_LOTECTL+" "+Strzero(Recno(),6),,{||MSExecAuto( {|x,y,z,w|	MATA270( x, y, z, w ) }, _aInvent, .F., 3 )})      //modificado Breda 24/04/2013
			If lMsErroAuto
				DisarmTransaction()
				MostraErro()
				Exit
			Endif
		EndIf

		DbSelectArea("INV")
		DbSkip()

	End do
	//*/
	If lGerado
		MSGBox("Arquivo Gerado com Sucesso","Criação de arquivos","INFO")
	Else
		MSGAlert("Nao ha lancamentos com os parametros selecionados!!")
	Endif

	INV->( DbCloseArea() )

Return (.T.)


Static Function AchaCampo(_cStr)

	Local cString    := Alltrim(_cStr)     // String a Desmembrar -> '"XXXXX","99999", '
	Local cRegistro  := cString            // Linha do Registro
	Local cCampoAux  := ""                 // Campo do Resgistro
	Local nCampoAux  := 0                  // Numero do Campo Registro
	Local nIndicePos := 0                  // Posicao da Primeira Ocorrencia de ",
	Local nPosInicio := 0                  // Posicao Inicial do Campo na String
	Local nPosAnteri := 0                  // Posicao Anterior a ",
	Local nPosPoster := 0                  // Posicao Posterior a ",
	Local x          := 0
	Local _lUltimo   := .F.
	Local lVAzio	 := .F.

	For x := 1 To Len(cString)             // Percorrer Toda a String

		nIndicePos := At(';', cRegistro)  // Pesquisa a Posicao da 1a. Ocorrencia de ",

		If nIndicePos > 0                  // Posicao Encontrada do ;

			nCampoAux += 1                  // Identifica o Campo de Acordo c/ a Vez

			If nCampoAux == 1
				nPosInicio := 1
				nPosAnteri := nIndicePos - 1
			Else
				nPosInicio := 1
				nPosAnteri := nIndicePos - 1
			EndIf

			nPosPoster := nIndicePos + 1

			cCampoAux := Alltrim(Substr(cRegistro, nPosInicio, nPosAnteri))
			cRegistro := Substr(cRegistro, nPosPoster)

			//"Codigo;Descrcao;Tipo;Grupo;Unidade;Armazem;Lote;Quantidade;Dt.V.Lote;Endereco;1a. Contagem;2a Contagem;Diferencas;3a Contagem;"
			If nCampoAux == 1
				_cCod		:= Ltrim(cCampoAux)
			ElseIf nCampoAux == 2
				_cDesc		:= Ltrim(cCampoAux)
			ElseIf nCampoAux == 3
				_xNada	:= ""
			ElseIf nCampoAux == 4
				_xNada	:= ""
			ElseIf nCampoAux == 5
				_xNada	:= ""
			ElseIf nCampoAux == 6
				_cLocal		:= StrZero(Val(cCampoAux),02)
			ElseIf nCampoAux == 7
				_cLoteCTL	:= cCampoAux
				//		_cLoteCTL	:= StrZero(Val(cCampoAux),10)
				//		_cLoteCTL		:= ""
			ElseIf nCampoAux == 8
				_nPoint     := IIf(Alltrim(cCampoAux)="", "0", If("."$cCampoAux,StrTran(cCampoAux,".",""),cCampoAux))
				_nQuant		:= If(","$_nPoint,Val(StrTran(_nPoint,",","")),Val(_nPoint))
			ElseIf nCampoAux == 9
				_xNada	:= ""
			Elseif nCampoAux ==  10
				_xNada	:= ""
			Endif

		Else
			If nCampoAux == 09 .And. !_lUltimo
				_lUltimo  := .T.
				cCampoAux := Alltrim(cRegistro)
				_cContaC  := cCampoAux
			EndIf
		EndIf
	Next

Return (.T.)

Static Function ExportEXL()

	// Verifica se o Diretório Existe
	//	nHdl := MakeDir("C:\")
	//		nHdl := MakeDir("C:\INVENTARIO\") //VFV

	/*	If nHdl <> 0
		MsgInfo("Falha na criacao do diretorio : "+Str(nHdl),"ATENCAO")
		Return()
	EndIf   */


	cDirTTS := "C:\INVENTARIO\"	 //vfv
	//    cDirTTS := "C:\TEMP\"
	If File(cDirTTS + "Export_Execl_"+cGetLOC+".csv")
		//Se existe apaga o arquivo
		fErase(cDirTTS + "Export_Execl_"+cGetLOC+".csv")
	Endif

	// Selecionando Produtos
	IncProc("Processando Armazém....")
	cQuery1	:=	"SELECT "
	cQuery1	+=		"B1_FILIAL, B1_COD, B1_DESC, B1_TIPO, B1_GRUPO, B1_UM, B1_RASTRO, B2_LOCAL, B2_QATU, B1_MSBLQL "
	cQuery1	+=	"FROM "
	cQuery1	+=		RETSQLNAME("SB1") + " SB1 "
	cQuery1	+=	"Inner Join "
	cQuery1	+=		RETSQLNAME("SB2") + " SB2 "
	cQuery1	+=		"ON B2_FILIAL = B1_FILIAL AND "
	cQuery1	+=		"B2_COD = B1_COD "
	cQuery1	+=	"WHERE "
	cQuery1	+=		"SB1.B1_MSBLQL <> '1' AND "
	//cQuery1	+=		"(SB1.B1_TIPO = 'MP' OR SB1.B1_TIPO = 'PI' OR SB1.B1_TIPO = 'PA') AND "
	cQuery1	+=		"SB2.B2_LOCAL = '" + cGetLOC + "' AND "
	cQuery1	+=		"SB1.D_E_L_E_T_ = ' ' AND "
	cQuery1	+=		"SB2.D_E_L_E_T_ = ' ' "
	cQuery1	+=	"ORDER BY "
	cQuery1	+=		"SB1.B1_TIPO, SB1.B1_COD "

	TCQUERY cQuery1 ALIAS "QrySB1" NEW

	// Cria arquivo csv
	nHdl	:=	MSFCreate(cDirTTS + "Export_Execl_"+cGetLOC+".csv")
	fWrite(nHdl, "Codigo;Descricao;Tipo;Grupo;Unidade;Armazem;Lote;Quantidade;Dt.V.Lote;Endereco;1a. Contagem;2a Contagem;Diferencas;3a Contagem;" + Chr(13) + Chr(10))

	While QrySB1->( !Eof() )

		IF QrySB1->B1_RASTRO # "N"  && S=SubLote;L=Lote;N=Nao utiliza

			cQuery2	:=	"Select "
			cQuery2	+=		"B8_LOCAL, B8_LOTECTL, B8_DTVALID, B8_SALDO "
			cQuery2	+=	"FROM "
			cQuery2	+=		RETSQLNAME("SB8") + " SB8 "
			cQuery2	+=	"WHERE "
			cQuery2	+=		"SB8.B8_FILIAL = '"+QrySB1->B1_FILIAL+"' AND "
			cQuery2	+=		"SB8.B8_PRODUTO = '"+QrySB1->B1_COD+"' AND "
			cQuery2	+=		"SB8.B8_LOCAL = '"+  QrySB1->B2_LOCAL +"' AND "
			cQuery2	+=		"SB8.B8_SALDO > 0 AND "
			cQuery2	+=		"SB8.D_E_L_E_T_ = ' ' "
			TCQUERY cQuery2 ALIAS "QrySB8" NEW

			While QrySB8->( !Eof() )

				// Grava dados COM LOTE
				fWrite(nHdl, QrySB1->B1_COD + ";" + QrySB1->B1_DESC + ";" + QrySB1->B1_TIPO + ";" + QrySB1->B1_GRUPO + ";" +  QrySB1->B1_UM + ";" + QrySB1->B2_LOCAL + ";" +  QrySB8->B8_LOTECTL + ";" + (strTran(cValToChar(QrySB8->B8_SALDO), "." , ",")) + ";" + QrySB8->B8_DTVALID + ";;;;" + Chr(13) + Chr(10) )

				QrySB8->(dbSkip())
			End
			QrySB8->(DBCloseArea())

		ELSE

			// Grava dados SEM LOTE
			fWrite(nHdl, QrySB1->B1_COD + ";" + QrySB1->B1_DESC + ";" + QrySB1->B1_TIPO + ";" + QrySB1->B1_GRUPO + ";" + QrySB1->B1_UM + ";" + QrySB1->B2_LOCAL + ";;" + (strTran(cValToChar(QrySB1->B2_QATU), "." , ",")) + ";;;;;;;" + Chr(13) + Chr(10))

		ENDIF

		QrySB1->(dbSkip())
	End

	QrySB1->(DBCloseArea())

	// Nome do arquivo
	alert ( cDirTTS + "Export_Execl_"+cGetLOC+".csv"	)

	// Fecha arquivo csv
	fClose(nHdl)

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open() && Abre uma planilha
	oExcelApp:SetVisible(.T.)

Return
