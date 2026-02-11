#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PRTOPDEF.CH'
#Include "TOTVS.CH"
#Include "FWMVCDef.ch"
/*/{Protheus.doc} M261BCHOI

/*/
#DEFINE CRLF ( chr(13)+chr(10) )

User Function MTBAIXA()

	Local aArea         := GetArea()
	Local aCampos := {}
	Local oTempTable := Nil
	Local aColunas := {}
	Local cFontPad    := 'Tahoma'
	Local oFontGrid   := TFont():New(cFontPad,,-14)
	//Janela e componentes
	Private oPanGrid
	Private oMarkBrowse
	Private cAliasTmp := GetNextAlias()
	Private aRotina   := MenuDef()
	//Tamanho da janela
	Private aTamanho := MsAdvSize()
	Private nJanLarg := aTamanho[5]
	Private nJanAltu := aTamanho[6]
	//Fontes
	Private cFontUti    := "Tahoma"
	Private oFontMod    := TFont():New(cFontUti, , -38)
	Private oFontSub    := TFont():New(cFontUti, , -12)
	Private oFontSubN   := TFont():New(cFontUti, , -12, , .T.)
	Private oFontBtn    := TFont():New(cFontUti, , -12)
	Private oFontSay    := TFont():New(cFontUti, , -10)
	Private oFont := TFont():New('Courier new',,-18,.T.,.F.)
	Private oFont2 := TFont():New('Courier new',,-18,.T.,.T.)

	//Adiciona as colunas que serão criadas na temporária
	aAdd(aCampos, { 'OK', 			'C', 2, 0}) //Flag para marcação
	aAdd(aCampos, { 'CP_NUM', 		'C', TamSX3("CP_NUM")[1], 0}) 		// NUM S.A
	aAdd(aCampos, { 'CP_X_OP', 		'C', TamSX3("CP_X_OP")[1], 0}) 		// OP
	aAdd(aCampos, { 'CP_ITEM', 		'C', TamSX3("CP_ITEM")[1], 0}) 		// ITEM
	aAdd(aCampos, { 'CP_PRODUTO',	'C', TamSX3("CP_PRODUTO")[1], 0}) 	// PRODUTO
	aAdd(aCampos, { "CP_DESCRI", 	'C', TamSX3("CP_DESCRI")[1], 0})  	// Pedido
	aAdd(aCampos, { 'CP_UM', 		'C', TamSX3("CP_UM")[1], 0}) 		// Produto
	aAdd(aCampos, { 'CP_QUANT', 	'N', TamSX3("CP_QUANT")[1], TamSX3("CP_QUANT")[2]}) // QUANTIDADE
	aAdd(aCampos, { 'CP_SOLICIT', 	'C', TamSX3("CP_SOLICIT")[1], 0})  // SOLICITANTE

	//Cria a tabela temporária
	oTempTable:= FWTemporaryTable():New(cAliasTmp)
	oTempTable:SetFields( aCampos )
	oTempTable:AddIndex("1", {"BF_PRODUTO","B8_LOTECTL"} )
	oTempTable:Create()

	//Popula a tabela temporária
	Processa({|| fPopula()}, 'Processando...')

	//Adiciona as colunas que serão exibidas no FWMarkBrowse
	aColunas := fCriaCols()

	aSeek := {}
	cCampoAux := "BF_PRODUTO"
	aAdd(aSeek,{GetSX3Cache(cCampoAux, "X3_TITULO"), {{"", GetSX3Cache(cCampoAux, "X3_TIPO"), GetSX3Cache(cCampoAux, "X3_TAMANHO"), GetSX3Cache(cCampoAux, "X3_DECIMAL"), AllTrim(GetSX3Cache(cCampoAux, "X3_TITULO")), AllTrim(GetSX3Cache(cCampoAux, "X3_PICTURE"))}} } )
	cCampoAux := "BF_LOTECTL"
	aAdd(aSeek,{GetSX3Cache(cCampoAux, "X3_TITULO"), {{"", GetSX3Cache(cCampoAux, "X3_TIPO"), GetSX3Cache(cCampoAux, "X3_TAMANHO"), GetSX3Cache(cCampoAux, "X3_DECIMAL"), AllTrim(GetSX3Cache(cCampoAux, "X3_TITULO")), AllTrim(GetSX3Cache(cCampoAux, "X3_PICTURE"))}} } )

	//Criando a janela
	DEFINE MSDIALOG oDlgMark TITLE 'Tela para Marcação de dados - Autumn Code Maker' FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
	//Dados
	oPanGrid := tPanel():New(001, 001, '', oDlgMark, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2)-1,     (nJanAltu/2 - 1))
	oMarkBrowse:= FWMarkBrowse():New()
	oMarkBrowse:SetDescription("Armazem 20 - Recebimento") //Titulo da Janela
	oMarkBrowse:SetAlias(cAliasTmp)
	oMarkBrowse:oBrowse:SetDBFFilter(.T.)
	oMarkBrowse:oBrowse:SetUseFilter(.F.) //Habilita a utilização do filtro no Browse
	oMarkBrowse:oBrowse:SetFixedBrowse(.T.)
	oMarkBrowse:SetWalkThru(.F.) //Habilita a utilização da funcionalidade Walk-Thru no Browse
	oMarkBrowse:SetAmbiente(.T.) //Habilita a utilização da funcionalidade Ambiente no Browse
	oMarkBrowse:SetTemporary(.T.) //Indica que o Browse utiliza tabela temporária
	oMarkBrowse:oBrowse:SetSeek(.T.,aSeek) //Habilita a utilização da pesquisa de registros no Browse
	oMarkBrowse:oBrowse:SetFilterDefault("") //Indica o filtro padrão do Browse
	oMarkBrowse:SetFieldMark('OK')
	oMarkBrowse:SetFontBrowse(oFontGrid)
	oMarkBrowse:SetOwner(oPanGrid)
	oMarkBrowse:SetColumns(aColunas)

	oMarkBrowse:Activate()
	ACTIVATE MsDialog oDlgMark CENTERED

	//Deleta a temporária e desativa a tela de marcação
	oTempTable:Delete()
	oMarkBrowse:DeActivate()

	RestArea(aArea)
Return

/*/{Protheus.doc} MenuDef
Botões usados no Browse
@author EDSON SALES
@since 20/07/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
/*/

Static Function MenuDef()
	Local aRotina := {}

	//Criação das opções
	ADD OPTION aRotina TITLE 'Confirmar'  ACTION 'u_fTranf01'     OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Fechar'  ACTION 'u_fFechar()'     OPERATION 2 ACCESS 0
Return aRotina

/*/{Protheus.doc} FFECHAR/*/
User Function FFECHAR()
	oDlgMark:End()
Return

/*/{Protheus.doc} fPopula
Executa a query SQL e popula essa informação na tabela temporária usada no browse
@author EDSON SALES
@since 20/07/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
/*/

Static Function fPopula()
	Local cQryDados := ''
	Local nTotal := 0
	Local nAtual := 0
	Local cAliasNew := GetNextAlias()

	BeginSql Alias cAliasNew
        SELECT BF_PRODUTO,CP_DESCRI,CP_QUANT,BF_LOCAL,BF_LOCALIZ, B8_SALDO,BF_LOTECTL,B8_LOTECTL,B8_DTVALID FROM SBF010 BF
            inner join SB1010 B1 ON B1.D_E_L_E_T_='' AND B1_COD = BF_PRODUTO
            INNER JOIN SB8010 B8 ON B8.D_E_L_E_T_='' AND BF_PRODUTO=B8_PRODUTO and  BF_LOTECTL=B8_LOTECTL 
            and BF_LOCAL=B8_LOCAL AND B8_SALDO>0
        WHERE BF.D_E_L_E_T_ ='' AND BF_LOCAL = '20'
	EndSql

	//Definindo o tamanho da régua
	DbSelectArea(cAliasNew)
	Count to nTotal
	ProcRegua(nTotal)
	(cAliasNew)->(DbGoTop())

	//Enquanto houver registros, adiciona na temporária
	While ! (cAliasNew)->(EoF())
		nAtual++
		IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')

		RecLock(cAliasTmp, .T.)
		(cAliasTmp)->OK := Space(2)
		(cAliasTmp)->BF_PRODUTO := (cAliasNew)->BF_PRODUTO
		(cAliasTmp)->CP_DESCRI := (cAliasNew)->CP_DESCRI
		(cAliasTmp)->CP_QUANT := (cAliasNew)->CP_QUANT
		(cAliasTmp)->BF_LOCAL := (cAliasNew)->BF_LOCAL
		(cAliasTmp)->BF_LOCALIZ := (cAliasNew)->BF_LOCALIZ
		(cAliasTmp)->B8_LOTECTL := (cAliasNew)->B8_LOTECTL
		(cAliasTmp)->B8_DTVALID := (cAliasNew)->B8_DTVALID

		(cAliasTmp)->(MsUnlock())

		(cAliasNew)->(DbSkip())
	EndDo
	(cAliasNew)->(DbCloseArea())
	(cAliasTmp)->(DbGoTop())
Return

/*/{Protheus.doc} fCriaCols
Função que gera as colunas usadas no browse (similar ao antigo aHeader)
@author EDSON SALES
@since 20/07/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
/*/

Static Function fCriaCols()
	Local nAtual       := 0
	Local aColunas := {}
	Local aEstrut  := {}
	Local oColumn

	//Adicionando campos que serão mostrados na tela
	//[1] - Campo da Temporaria
	//[2] - Titulo
	//[3] - Tipo
	//[4] - Tamanho
	//[5] - Decimais
	//[6] - Máscara

	aAdd(aEstrut, { 'BF_PRODUTO', 'Produto', 'C',10, 0, ''})
	aAdd(aEstrut, { "CP_DESCRI", 'Descricao', 'C',  25, 0, ''})
	aAdd(aEstrut, { 'CP_QUANT', 'Quantidade', 'N', 8 ,TamSX3("CP_QUANT")[2], ''})
	aAdd(aEstrut, { 'BF_LOCAL', 'Armazen', 'C', TamSX3("BF_LOCAL")[1], 0, ''})
	aAdd(aEstrut, { 'BF_LOCALIZ', 'Endereco', 'C',  TamSX3("BF_LOCALIZ")[1], 0, ''})
	aAdd(aEstrut, { 'B8_LOTECTL', 'Lote', 'C', TamSX3("B8_LOTECTL")[1], 0, ''})
	aAdd(aEstrut, { 'B8_DTVALID', 'Validade', 'D',  TamSX3("B8_DTVALID")[1], 0, ''})

	//Percorrendo todos os campos da estrutura
	For nAtual := 1 To Len(aEstrut)
		//Cria a coluna
		oColumn := FWBrwColumn():New()
		oColumn:SetData(&('{|| ' + cAliasTmp + '->' + aEstrut[nAtual][1] +'}'))
		oColumn:SetTitle(aEstrut[nAtual][2])
		oColumn:SetType(aEstrut[nAtual][3])
		oColumn:SetSize(aEstrut[nAtual][4])
		oColumn:SetDecimal(aEstrut[nAtual][5])
		oColumn:SetPicture(aEstrut[nAtual][6])

		//Adiciona a coluna
		aAdd(aColunas, oColumn)
	Next
Return aColunas

/*/{Protheus.doc} User Function fTranf01
Função acionada pelo botão continuar da rotina
@author EDSON SALES
@since 20/07/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
/*/

User Function fTranf01()
	Processa({|| fProcessa()}, 'Processando...')
Return

/*/{Protheus.doc} fProcessa
Função que percorre os registros da tela
@author EDSON SALES
@since 20/07/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
/*/

Static Function fProcessa()
	Local aArea     := FWGetArea()
	Local cMarca    := oMarkBrowse:Mark()
	Local nAtual    := 0
	Local nTotal    := 0
	Local nTotMarc := 0
	Local aCols := {}

	//Define o tamanho da régua
	DbSelectArea(cAliasTmp)
	(cAliasTmp)->(DbGoTop())
	Count To nTotal
	ProcRegua(nTotal)

	//Percorrendo os registros
	(cAliasTmp)->(DbGoTop())
	While ! (cAliasTmp)->(EoF())
		nAtual++
		IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')

		//Caso esteja marcado
		If oMarkBrowse:IsMark(cMarca)
			nTotMarc++
			aadd(aCols,{;
				(cAliasTmp)->BF_PRODUTO,;
				(cAliasTmp)->CP_DESCRI,;
				(cAliasTmp)->CP_QUANT,;
				(cAliasTmp)->BF_LOCAL,;
				(cAliasTmp)->BF_LOCALIZ,;
				(cAliasTmp)->B8_LOTECTL,;
				dtoc(stod((cAliasTmp)->B8_DTVALID));
				})
		EndIf
		// (cAliasTmp)->B8_SALDO,;
			// (cAliasTmp)->B8_LOTECTL;

		(cAliasTmp)->(DbSkip())

	EndDo

	fTransferencia(aCols)
	u_MTTRANS()
	//Mostra a mensagem de término e caso queria fechar a dialog, basta usar o método End()
	FWAlertInfo('Dos [' + cValToChar(nTotal) + '] registros, foram processados [' + cValToChar(nTotMarc) + '] registros', 'Atenção')
	//oDlgMark:End()

	FWRestArea(aArea)
Return



Return lRet

/*/{Protheus.doc} fTransferencia
aCols	Realiza transferencia dos produtos empenhados das ops firmadas
	@type  Static Function
	@author matheus.vinicius@tamservice.com.br
	@since 23/08/2023
/*/
Static Function fTransferencia(aCols)
	Local aAuto     := {}
	Local aItem     := {}
	Local nX        := Nil
	Local cLog      := ""
	Local cOps      := ""
	Local cAliasNew := GetNextAlias()
	Local cDocumen  := GetSxeNum("SD3","D3_DOC")
	Local cUsuario  := RETCODUSR()
	Local cTGet1 := space(17)
	Local cTGet2 := space(20)
	LOCAL nOpc1 := 0

	Local cLocaliz  := SPACE(TAMSX3("BE_LOCALIZ")[1])
	Local cNumseri  := SPACE(TAMSX3("D3_NUMSERI")[1])
	Local oDlg,oSay,oSay1
	Private oFwLayer
	Private oPanTitulo
	Private oPanGrid


	aItem := {}
	aAuto     := {}

	for nx := 1 to len(aCols)

		oDlg:= TDialog():New(180,180,550,700,'Tranferir para Armazem 01',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

		oSay1  := TSay():New(10,10,{|| 'Produto: '},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oSay2  := TSay():New(10,103,{|| acols[nx,1]},oDlg,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)
		oSay1  := TSay():New(10,195,{|| 'Saldo: '},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oSay2  := TSay():New(10,235,{|| acols[nx,3]},oDlg,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)

		oSay1 := TSay():New(25,10,{|| 'Armazem Origem:'},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oSay2  := TSay():New(25,103,{|| acols[nx,4]},oDlg,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)

		oSay1 := TSay():New(40,10,{|| 'Endereço Origem:'},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oSay2  := TSay():New(40,103,{|| acols[nx,5]},oDlg,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)

		oSay1 := TSay():New(55,10,{|| 'Lote:'},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oSay2  := TSay():New(55,103,{|| acols[nx,6]},oDlg,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)

		cTGet1 := space(17)
		oSay1 := TSay():New(75,10,{|| 'Quantidade'},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oTGet1 := TGet():New( 75,103,{ |u| If(PCount() > 0, cTGet1 := u, cTGet1) },oDlg,096,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet1,,,, )

		oSay1 := TSay():New(90,10,{|| 'Armazem Destino:'},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oSay2  := TSay():New(90,103,{|| '01'},oDlg,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)

		cTGet2 := space(20)
		oSay1 := TSay():New(110,10,{|| 'Endereço Destino:'},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oTGet2 := TGet():New( 110,103,{ |u| If(PCount() > 0, cTGet2 := u, cTGet2) },oDlg,096,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet2,,,,.T.,.F. )
		oTGet2:CF3 :='SBE'

		oTButton1 := TButton():New( 170, 115, "Transferir"	 ,oDlg,{|| oDlg:end(),nOpc1:=1}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		oTButton2 := TButton():New( 170, 165, "Cancelar"	 ,oDlg,{|| oDlg:end(),nOpc1:=2}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		oTButton3 := TButton():New( 170, 210, "Cancelar Tudo",oDlg,{|| oDlg:end(),nOpc1:=0}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		// ativa diálogo centralizado

		//Adicionando A QUANTIDADE E ENDEREÇO DESTINO

		oDlg:Activate()

		if nOpc1 == 1
			aAdd(aItem,{acols[nx,1],; //codigo
			acols[nx,2],; //descricao
			acols[nx,4],; // amrmazem orig
			acols[nx,5],; // endereco orig
			acols[nx,6],; // lote
			CTOD(acols[nx,7]),; // validade
			Val(cTGet1),;  // quantidade
			'01',;  //armazem destino
			Alltrim(cTGet2)}) // endereço destino
		endif

	next nx

	if nOpc1 == 0
		return
	ElseIf nOpc1 == 1
		excecTranf(aItem)
	endif

Return .T.

/*/{Protheus.doc} excecTranf
/*/
Static Function excecTranf(aItem)
	Local Ny := 0
	Local Ni := 0
	Local  aAuto := {}
	Local  aItExec := {}
	Local CUN := ''
	Local cDocumen  := GetSxeNum("SD3","D3_DOC")
	Private  lMsErroAuto := .F.

	BeginTran()

	if Empty(aAuto)
		aadd(aAuto,{cDocumen,dDataBase})
	endif

	For Ny := 1 TO LEN(aItem)
		CUN := POSICIONE('SB1',1,XFILIAL('SB1')+aItem[Ny,1],'B1_UM')
		aItExec :={}
		//Origem
		aadd(aItExec,{"D3_COD"    , aItem[Ny,1]	, Nil})
		aadd(aItExec,{"D3_DESCRI" , aItem[Ny,2]	, Nil})
		aadd(aItExec,{"D3_UM"     , CUN			, Nil})
		aadd(aItExec,{"D3_LOCAL"  , aItem[Ny,3]	, Nil})
		aadd(aItExec,{"D3_LOCALIZ", aItem[Ny,4]	, Nil})

		//Destino
		aadd(aItExec,{"D3_COD"    ,  aItem[Ny,1]	  , Nil})
		aadd(aItExec,{"D3_DESCRI" ,  aItem[Ny,2]	  , Nil})
		aadd(aItExec,{"D3_UM"     ,  CUN		  , Nil})
		aadd(aItExec,{"D3_LOCAL"  ,  aItem[Ny,8]	  , Nil})
		aadd(aItExec,{"D3_LOCALIZ",  aItem[Ny,9]	  , Nil})

		//origem
		aadd(aItExec,{"D3_NUMSERI", ''				, Nil})
		aadd(aItExec,{"D3_LOTECTL",  aItem[Ny,5]		, Nil})
		aadd(aItExec,{"D3_NUMLOTE", ''				, Nil})
		aadd(aItExec,{"D3_DTVALID", aItem[Ny,6]		, Nil})

		aadd(aItExec,{"D3_POTENCI", 0				, Nil})
		aadd(aItExec,{"D3_QUANT"  ,  aItem[Ny,7]   	, Nil})

		aadd(aItExec,{"D3_QTSEGUM", 0             , Nil})
		aadd(aItExec,{"D3_ESTORNO", ""            , Nil})
		aadd(aItExec,{"D3_NUMSEQ" , ""            , Nil})

		//destino
		aadd(aItExec,{"D3_LOTECTL",  aItem[Ny,5]	  , Nil})
		aadd(aItExec,{"D3_NUMLOTE", ''		      , Nil})
		aadd(aItExec,{"D3_DTVALID", aItem[Ny,6]	  , Nil})

		aadd(aItExec,{"D3_ITEMGRD", ""                      		, Nil})
		aadd(aItExec,{"D3_OBS"    , "Transferencia recebimento" 	, Nil})
		aadd(aItExec,{"D3_CODLAN" , ""                      , Nil}) //cat83 prod origem
		aadd(aItExec,{"D3_CODLAN" , ""                      , Nil}) //cat83 prod destino
		aadd(aItExec,{"D3_USUARIO", UsrRetName(cUsuario)    , Nil})

		aAdd(aAuto,aItExec)
	Next Ny

	MSExecAuto({|x,y| MATA261(x,y)},aAuto, 3)

	If lMsErroAuto
		RollbackSx8()
		aLogAuto := GetAutoGRLog()
		Aviso("ATENCAO", "Nao foi possivel EFETUAR as transferencias.", {"OK"}, 2, "", , , , 1500)
		MostraErro()
		DisarmTransaction()

	EndIf

	If !lMsErroAuto
		EndTran()
		FWAlertSuccess('Transferencia efetivada','Sucesso')
	EndIf

Return
