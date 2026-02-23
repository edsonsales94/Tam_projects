//Bibliotecas
#Include 'Protheus.ch'
#Include "TOTVS.ch"
#Include "TopConn.ch"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "RWMAKE.CH"
#INCLUDE "RPTDEF.CH"

#DEFINE CGETFILE_TYPE GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE
//VariÃ¡veis EstÃ¡ticas
Static cTitulo := "Cadastro de carteira"

/*/{Protheus.doc} MCCART1
FunÃ§Ã£o para cadastros de Carteira
@author Edson Sales
@since 13/09/2026
@version 1.0
    @return Nil, FunÃ§Ã£o nÃ£o tem retorno
    @example
    u_MCCART1()
    @obs Os campos chave usado entre cabeÃ§alho e grid sÃ£o: ZX_CLIENTE (CÃ³digo Sequencial), ZX_NOMCLI (Nota Fiscal), ZX_PERIODO (Valor)
/*/

User Function MCCART1()
	Local aArea   := GetArea()
	Local oBrowse

	DbSelectArea('SZX')
	SZX->(dbSetOrder(1))
	cCondicao := "ZX_SEQ == '00001'"

	//Cria um browse para a SZX
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("SZX")
	oBrowse:SetDescription(cTitulo)
	oBrowse:SetFilterDefault(cCondicao)
	oBrowse:Activate()

	RestArea(aArea)
Return Nil



Static Function MenuDef()
	Local aRot := {}

	//Adicionando opÃ§Ãµes
	ADD OPTION aRot TITLE 'Importar'		ACTION 'U_fnImpCart'	OPERATION 	6	ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Tranfere Saldo'	ACTION 'U_TrfParam'		OPERATION 	6	ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.MCCART1' OPERATION 	MODEL_OPERATION_VIEW  	ACCESS 0 //OPERATION 1
	// ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.MCCART1' OPERATION 	MODEL_OPERATION_UPDATE	ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.MCCART1' OPERATION 	MODEL_OPERATION_DELETE	ACCESS 0 //OPERATION 5

Return aRot

Static Function ModelDef()
	//Na montagem da estrutura do Modelo de dados, o cabeÃ§alho filtrarÃ¡ e exibirÃ¡ somente 3 campos, jÃ¡ a grid irÃ¡ carregar a estrutura inteira conforme funÃ§Ã£o fModStruct
	Local oModel      := NIL
	Local oStruCab     := FWFormStruct(1, 'SZX', {|cCampo| AllTRim(cCampo) $ "ZX_CLIENTE;ZX_LOJA;ZX_NOMCLI;ZX_PERIODO;"})
	Local oStruGrid := fModStruct()

	// LIBERAR CAMPOS

	oStruGrid:SetProperty('ZX_PERIODO',	MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.')) //Modo de Edição
	oStruGrid:SetProperty('ZX_CODMASA',	MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.')) //Modo de Edição
	oStruGrid:SetProperty('ZX_DESC',	MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.')) //Modo de Edição
	oStruGrid:SetProperty('ZX_PEDCLI',	MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.')) //Modo de Edição
	oStruGrid:SetProperty('ZX_QUANT',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.')) //Modo de Edição
	oStruGrid:SetProperty('ZX_DATA',	MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.')) //Modo de Edição
	oStruGrid:SetProperty('ZX_USUARIO',	MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.')) //Modo de Edição

	//Monta o modelo de dados, e na PÃ³s ValidaÃ§Ã£o, informa a funÃ§Ã£o fValidGrid
	oModel := MPFormModel():New('MCCART1M', /*bPreValidacao*/, /*{|oModel| fValidGrid(oModel)}*/, /*bCommit*/, /*bCancel*/ )

	//Agora, define no modelo de dados, que terÃ¡ um CabeÃ§alho e uma Grid apontando para estruturas acima
	oModel:AddFields('MdFieldSZX', NIL, oStruCab)
	oModel:AddGrid('MdGridSZX', 'MdFieldSZX', oStruGrid, , )

	//Monta o relacionamento entre Grid e CabeÃ§alho, as expressÃµes da Esquerda representam o campo da Grid e da direita do CabeÃ§alho
	oModel:SetRelation('MdGridSZX', {;
		{'ZX_FILIAL', 'xFilial("SZX")'},;
		{"ZX_CLIENTE",  "ZX_CLIENTE"},;
		{"ZX_LOJA",  "ZX_LOJA"},;
		{"ZX_NOMCLI", "ZX_NOMCLI"},;
		{"ZX_PERIODO",  "ZX_PERIODO"};
		}, SZX->(IndexKey(2)))

	//Definindo outras informaÃ§Ãµes do Modelo e da Grid
	oModel:GetModel("MdGridSZX"):SetMaxLine(9999)
	oModel:SetDescription("AtualizaÃ§Ã£o Controle de CombustÃ­vel")
	oModel:SetPrimaryKey({"ZX_FILIAL", "ZX_CLIENTE","ZX_LOJA", "ZX_PERIODO","ZX_SEQ"})

Return oModel

Static Function ViewDef()
	//Na montagem da estrutura da visualizaÃ§Ã£o de dados, vamos chamar o modelo criado anteriormente, no cabeÃ§alho vamos mostrar somente 3 campos, e na grid vamos carregar conforme a funÃ§Ã£o fViewStruct
	Local oView        := NIL
	Local oModel    := FWLoadModel('MCCART1')
	Local oStruCab  := FWFormStruct(2, "SZX", {|cCampo| AllTRim(cCampo) $ "ZX_CLIENTE;ZX_LOJA;ZX_NOMCLI;ZX_PERIODO;"})
	Local oStruGRID := fViewStruct()

	//Define que no cabeÃ§alho nÃ£o terÃ¡ separaÃ§Ã£o de abas (SXA)
	oStruCab:SetNoFolder()

	//Cria o View
	oView:= FWFormView():New()
	oView:SetModel(oModel)

	//Cria uma Ã¡rea de Field vinculando a estrutura do cabeÃ§alho com MDFieldSZX, e uma Grid vinculando com MdGridSZX
	oView:AddField('VIEW_SZX', oStruCab, 'MdFieldSZX')
	oView:AddGrid ('GRID_SZX', oStruGRID, 'MdGridSZX' )

	//O cabeÃ§alho (MAIN) terÃ¡ 25% de tamanho, e o restante de 75% irÃ¡ para a GRID
	oView:CreateHorizontalBox("MAIN", 25)
	oView:CreateHorizontalBox("GRID", 75)

	//Vincula o MAIN com a VIEW_SZX e a GRID cofm a GRID_SZX
	oView:SetOwnerView('VIEW_SZX', 'MAIN')
	oView:SetOwnerView('GRID_SZX', 'GRID')
	oView:EnableControlBar(.T.)

	//Define o campo incremental da grid como o ZX_SEQ
	oView:AddIncrementField('GRID_SZX', 'ZX_SEQ')
Return oView

//FunÃ§Ã£o chamada para montar o modelo de dados da Grid
Static Function fModStruct()
	Local oStruct
	oStruct := FWFormStruct(1, 'SZX')
Return oStruct

//FunÃ§Ã£o chamada para montar a visualizaÃ§Ã£o de dados da Grid
Static Function fViewStruct()
	Local cCampoCom := "ZX_CLIENTE;ZX_LOJA;ZX_NOMCLI;ZX_PERIODO;"
	Local oStruct

	//IrÃ¡ filtrar, e trazer todos os campos, menos os que tiverem na variÃ¡vel cCampoCom
	oStruct := FWFormStruct(2, "SZX", {|cCampo| !(Alltrim(cCampo) $ cCampoCom)})
Return oStruct

//FunÃ§Ã£o que faz a validaÃ§Ã£o da grid
Static Function fValidGrid(oModel)
	Local lRet     := .T.
	Local nDeletados := 0
	Local nLinAtual :=0
	Local oModelGRID := oModel:GetModel('MdGridSZX')
	Local oModelMain := oModel:GetModel('MdFieldSZX')
	Local nValorMain := oModelMain:GetValue("ZX_PERIODO")
	Local nValorGrid := 0
	Local cPictVlr   := PesqPict('SZX', 'ZX_PERIODO')

	//Percorrendo todos os itens da grid
	For nLinAtual := 1 To oModelGRID:Length()
		//Posiciona na linha
		oModelGRID:GoLine(nLinAtual)

		//Se a linha for excluida, incrementa a variÃ¡vel de deletados, senÃ£o irÃ¡ incrementar o valor digitado em um campo na grid
		If oModelGRID:IsDeleted()
			nDeletados++
		Else
			nValorGrid += NoRound(oModelGRID:GetValue("SZX_TCOMB"), 4)
		EndIf
	Next nLinAtual

	//Se o tamanho da Grid for igual ao nÃºmero de itens deletados, acusa uma falha
	If oModelGRID:Length()==nDeletados
		lRet :=.F.
		Help( , , 'Dados InvÃ¡lidos' , , 'A grid precisa ter pelo menos 1 linha sem ser excluida!', 1, 0, , , , , , {"Inclua uma linha vÃ¡lida!"})
	EndIf

	If lRet
		If nValorMain != nValorGrid
			//lRet := .F.
			MsgAlert("O valor do cabeÃ§alho (" + Alltrim(Transform(nValorMain, cPictVlr)) + ") tem que ser igual o valor dos itens (" + Alltrim(Transform(nValorGrid, cPictVlr)) + ")!", "AtenÃ§Ã£o")
		EndIf
	EndIf

Return lRet
/*/{Protheus.doc} fnImpCart
Função para importar informações do fornecedor via csv
@author Atilio
@since 07/06/2021
@version 1.0
@type function
/*/
User function fnImpCart()

	Local aArea         := GetArea()
	Local cCliente       := Space(6)
	Local cNomCli     := ''
	Local cLoja       := Space(2)
	// Local cCond       := Space(3)

	Local cCaminho    := Space(100)
	Private oArq
	// RpcSetEnv('01','01')
	@ 275,235 To 496,880 Dialog oArq Title OemToAnsi("Gerar os Itens da planilhas de contatos")
	@ 5,2  To 41,311 Title OemToAnsi("ARQUIVO:")
	@ 45,2 To 74,311 Title OemToAnsi("Cliente:")
	@ 20,10	MSGET cCaminho Size 204,10   PIXEL of oArq WHEN .F.
	@ 57,7	MSGET cCliente F3 "SA1" Size 50,10  OF oArq PIXEL  VALID(Pesquise(cCliente,'SA1',1,@cNomCli, @cLoja))
	@ 57,62	MSGET cLoja   Size 20,10  PIXEL OF oArq WHEN .F.
	@ 57,85	MSGET cNomCli SIZE 200,10 PIXEL OF oArq WHEN .F.

	@ 18,224 Button OemToAnsi("Carregar arquivo CSV") Size 60,16 Action FARQUI01(@cCaminho)
	@ 85,175 Button OemToAnsi("Gerar Itens")          Size 55,20 Action MCProces(cCaminho,cCliente,cLoja,cNomCli)
	@ 85,250 Button OemToAnsi("Fechar")               Size 55,20 Action Close(oArq)

	Activate Dialog oArq  CENTERED

	RestArea(aArea)
	*
Return

	*****************************
Static Function Pesquise(xReadVar,cAlias, NOPC,xNomCli,xLoja)
	*****************************
	cVar := IIF(cAlias=='SB1','Produto','Cliente')
	IF !Empty(xReadVar)
		DBSelectArea(cAlias)
		DBSetOrder(1)
		if !DBSeek(xFilial(cAlias)+xReadVar)
			MsgStop(cVar +" informado não está correto !!!")
			Return (.F.)
		Endif

		//validação para cliente
		if cAlias=='SA1' .AND. NOPC == 1
			xLoja 	:= AllTRim(SA1->A1_LOJA)
			xNomCli := AllTRim(SA1->A1_NOME)
		Else
			xLoja 	:= AllTRim(SA1->A1_LOJA)
		endif

		If Type("oArq") == "O"
			oArq:Refresh()
		endif
		If Type( "oTransf") == "O"
			oTransf:Refresh()
		endif
	ENDIF


Return(.T.)


/*/
	+-------------------------------------------------------------------------------+
	¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
	¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
	¦¦¦ Programa  ¦ FARQUI01    ¦ Autor ¦Edson Sales        	  ¦ Data ¦ 24/11/2025 ¦¦¦
	¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
	¦¦¦           ¦ Rotina para exibir a pasta d arquivo CSV.                     ¦¦¦
	¦¦¦           ¦                                                               ¦¦¦
	¦¦+-----------+---------------------------------------------------------------+¦¦
	¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
	+-------------------------------------------------------------------------------+
/*/
Static Function FARQUI01(cCaminho)
	Local _cTipo       := "Pedido (*.CSV)        | *.CSV | "
	Local cTipo       := _cTipo + "Todos os Arquivos (*.csv)   | *.csv     "
	Local mvpar01     := Space(30)
	Local cxPath      := ""

	cArq := ( cxPath + RTRIM(mvpar01) + ".csv" )
	lArq := .T.

	IF ( !FILE(cArq) )
		lArq := .F.
		cArq := cGetFile( cTipo,"Selecione arquivo...",1  , cxPath , .T. , CGETFILE_TYPE )
		If Empty(cArq).AND.Empty(mvpar01)
			Aviso("Cancelada a Seleção!","Você cancelou a seleção do arquivo.",{"Ok"})
			cCaminho := ''
		Endif
	ENDIF
	IF ( !EMPTY(cArq) )
		cCaminho := cArq
		oArq:Refresh()
	ENDIF

Return(.T.)


/*-------------------------------------------------------------------------------*
 | Func:  MCProces                                                               |
 | Desc:  Função que importa os dados                                            |
 *-------------------------------------------------------------------------------*/
Static function MCProces(cCaminho,cCliente,cLoja,cNomCli)
	******************************
	Local oProcess
	Private aItem       := {}
	Private aItens      := {}
	Private lMsErroAuto := .F.
	Private aLogP	    := {}
	Private aDados      := {}   //Armazena os dados do aquivo .CSV
	*
	if Empty(cCaminho)
		Alert("Necessário informar o arquivo! ")
		Return .F.
	endif
	*
	if .T.
	//Exemplo de Chamada
	oProcess := MsNewProcess():New({|| ProcOK(cCaminho,cCliente,cLoja,cNomCli,oProcess)}, "Processando...", "Aguarde...", .T.)
	oProcess:Activate()
		
	else
		Alert('O contrato precisa está em situação de elaboração, para permitir a importação dos itens')
		Return
	endif

	Close(oArq)
Return

Static Function ProcOK(_cPath,cCliente,cLoja,cNomCli,oObj)
    Local aArea      := GetArea()
    Local cArqLog    := "fnImpCart_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
    Local nTotLinhas := 0
	Local nSeq 		 := 0
    Local nx		 := 0
	// local ny		 := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 0
    Local aLinha     := {}
	local CALIAS := GETNEXTALIAS()
    Local oArquivo
    Local aLinhas
    Private cDirLog    := GetTempPath() + "x_importacao\"
    Private cLog       := ""
    Private cPeriodo       := left(dtos(date()),6)

	// Definir se é inclusão ou alteração
	DBSelectArea('SZX')
	SZX->(DBSetOrder(1))
	iF SZX->(msseek(xFilial('SZX')+cCliente+cLoja+cPeriodo))
		xOper := 4
	else
		xOper := 3
	EndIf
      
    //Se a pasta de log não existir, cria ela
    If ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIf
  
    //Definindo o arquivo a ser lido
    oArquivo := FWFileReader():New(_cPath)
      
    //Se o arquivo pode ser aberto
    If (oArquivo:Open())
  
        //Se não for fim do arquivo
        If ! (oArquivo:EoF())
  
            //Definindo o tamanho da régua
            aLinhas := oArquivo:GetAllLines()
            nTotLinhas := Len(aLinhas)

			// tela de progresso -- processando as linhas do arquivo.
    		oObj:SetRegua1(nTotLinhas)
            
              
            //Método GoTop não funciona (dependendo da versão da LIB), deve fechar e abrir novamente o arquivo
            oArquivo:Close()
            oArquivo := FWFileReader():New(_cPath)
            oArquivo:Open()
  
            //Enquanto tiver linhas
            While (oArquivo:HasLine())
  
                //Incrementa a mensagem na régua
				nLinhaAtu++
				oObj:IncRegua1("Processando Arquivo .CSV" + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")
                  
                //Pegando a linha atual e transformando em array
                cLinAtu := oArquivo:GetLine()
			
				iF ";;" $ cLinAtu
					cLinAtu := StrTran(cLinAtu,';;',';N/A;')
					aLinha  := StrTokArr(cLinAtu, ";")
				Else
					aLinha  := StrTokArr(cLinAtu, ";")
				ENDIF

                dbSelectArea('SB1')
				DBSETORDER(1)
                //Se PRODUTO TIVR CADASTRADO ADICIONA NO ARRAY ADADOS
				cProduto := aLinha[1]
                If SB1->(msseek(xfilial('SB1')+cProduto))

					cCodMasa := aLinha[1]
					cCodClie := aLinha[2]
					// Remove posição maior primeiro
					ADel(aLinha, 1)
					ASize(aLinha, Len(aLinha)-1)

					ADel(aLinha, 1)
					ASize(aLinha, Len(aLinha)-1)
					for nx := 1 to len(aLinha)
						//Incrementando a régua 2
						oObj:SetRegua2(nx)
						oObj:IncRegua2("Verificando os dias " + cValToChar(nx) + " de " + cValToChar(len(aLinha)) + "...")
 
						cData := cPeriodo+strZero(nx,2)
						if xOper==3 // se for uma inclusao
							if aLinha[nx] != '0' .and. !Empty(STOD(cData))
								
								aadd(aDados,{'',StoD(cData),cCodMasa,AllTRim(SB1->B1_DESC),cCodClie,val(aLinha[nx])})
							endif
						Else
							// alteração
							SZX->(DBSetOrder(2))					
							iF SZX->(msseek(xFilial('SZX')+cCliente+cLoja+cPeriodo+left(cCodMasa+Space(10),15)+cData)) // encontra o regitro
								if aLinha[nx] != '0' .and. !Empty(STOD(cData))
									IF cCliente+cLoja+cPeriodo+cCodMasa+cData == SZX->(ZX_CLIENTE+ZX_LOJA+ZX_PERIODO+ALLTRIM(ZX_CODMASA)+DTOS(SZX->ZX_DATA))
										IF cData >= dToS(dDatabase) .and. (SZX->ZX_QUANT > SZX->ZX_QUJE)
											aadd(aDados,{SZX->ZX_SEQ,StoD(cData),cCodMasa,AllTRim(SB1->B1_DESC),cCodClie,val(aLinha[nx])})
										endif
									endif
									// caso exista algum item que foi cancelado.
									if aLinha[nx] == '0' 
										RecLock("SZX",.F.)
											SZX->(dbDelete())
										SZX->(MsUnlock())
									endif
								endif
							Else
								IF aLinha[nx] != '0' .AND.cData >= dToS(dDatabase) .and. !Empty(STOD(cData))
									aadd(aDados,{'',StoD(cData),cCodMasa,AllTRim(SB1->B1_DESC),cCodClie,val(aLinha[nx])})
								endif
							endif
						endif
					next
                Else				
					If aLinha[1] != "N/A"
                    	cLog += "- Linha " + cValToChar(nLinhaAtu) + ", linha nao processada - "+aLinha[1]+';' + CRLF
                	EndIf
                EndIf
                  
            EndDo
			// ordernar por dada e chamar a função para incluir.
			if len(aDados) > 0
				if xOper  == 3
					ASort(aDados,,, {|x,y| x[2] < y[2] })
				Else
					ASort(aDados,,, {|x,y| x[1] < y[1] })
				endif
				RptStatus({|| IncRegs(aDados,xOper,cCliente,cLoja,cNomCli,cPeriodo)}, "Aguarde...", "Gravando carteira...")
			endif

            //Se tiver log, mostra ele
            If ! Empty(cLog)
                cLog := "Processamento finalizado, abaixo as mensagens de log: " + CRLF + cLog
                MemoWrite(cDirLog + cArqLog, cLog)
                ShellExecute("OPEN", cArqLog, "", cDirLog, 1)
            EndIf
  
        Else
            MsgStop("Arquivo não tem conteúdo!", "Atenção")
        EndIf
  
        //Fecha o arquivo
        oArquivo:Close()
    Else
        MsgStop("Arquivo não pode ser aberto!", "Atenção")
    EndIf
  
    RestArea(aArea)
Return


/*/{Protheus.doc} IncRegs
	(long_description)
	@type  Static Function
	@author user
	@since 14/02/2026
	@version version
/*/
Static Function IncRegs(_aDados,_nOper,cCliente,cLoja,cNomCli,cPeriodo)
Local oCab
Local oGrid
Local lOk := .F.
Local lNewSeq := .F.
Local aErro
Local ny := 0
Local nI := 0
Local nAtual := 0
// Local nTotal := 0

//Pegando o modelo de dados, setando a operação de inclusão
// Carrega model da sua rotina

oModel := FWLoadModel("MCCART1")
oModel:SetOperation(_nOper)
oModel:Activate()

// Cabeçalho
oCab := oModel:GetModel("MdFieldSZX")

oCab:SetValue("ZX_CLIENTE", cCliente)
oCab:SetValue("ZX_LOJA"   , cLoja)
oCab:SetValue("ZX_NOMCLI" , cNomCli)
oCab:SetValue("ZX_PERIODO", cPeriodo)

// Grid
oGrid := oModel:GetModel("MdGridSZX")

SetRegua(Len(_aDados))

for ny := 1 to Len(_aDados)

	//Incrementa a mensagem na régua
	nAtual++
	IncRegua()
	
	iF _nOper == 3  // SE INCLUSAO
		cSeq := strZero(ny,5)
		oGrid:AddLine()
	Else // ALTERAÇÃO
		
		dbSetOrder(2)
		if lNewSeq
			if !SZX->(MsSeek(XFILIAL()+cCliente +cLoja+ cPeriodo+LEFT(aDados[ny,3]+SPACE(10),15) + DTOS(aDados[ny,2])))
			// if !oGrid:SeekLine({{"SZX->ZX_SEQ", aDados[ny,1] }})
				oGrid:AddLine() // SE NÃO CRIA NOVA LINHA
				oGrid:GoLine(oGrid:Length())
				cSeq := SOMA1(cSeq)
			Else	
			cSeq := SOMA1(cSeq)
			EndIF
		else
			// reajustar os itens apartir do primeiro no caso de alteração
			// POSICIONA NA LINHA EXISTENTE PELO INDICE
			if SZX->(MsSeek(XFILIAL()+cCliente +cLoja+ cPeriodo+LEFT(aDados[ny,3]+SPACE(10),15) + DTOS(aDados[ny,2]))) // POSICIONA NA LINHA
				cSeq := aDados[ny,1]
				lNewSeq := .T.
			Else
				// if SELECT(CALIAS) >0 
				// 	(CALIAS)->(dbCloseArea())
				// endif

				// // dia anterior
				// cDataAnt := dtos(aDados[ny,2]-1)

				// // maior sequencial do dia anterior
				// BEGINSQL ALIAS CALIAS
				// 	SELECT MAX(ZX_SEQ) ULT FROM %TABLE:SZX% SZX
				// 	WHERE SZX.%NOTDEL% 
				// 	AND ZX_CLIENTE = %EXP:cCliente%
				// 	AND ZX_LOJA = %EXP:cLoja%
				// 	AND ZX_PERIODO = %EXP:cPeriodo%
				// 	AND ZX_PERIODO = %EXP:cPeriodo%
				// 	AND ZX_DATA = %EXP:cDataAnt%
				// ENDSQL
				
				// cSeq := SOMA1((CALIAS)->(ULT))

				// buscar o primeiro item para iniciar o sequencial
				for nI := 1 to Len(_aDados)
					IF !Empty(_aDados[nI,1])
						cSeq := _aDados[nI,1]
						exit
					ENDIF
				next nI
				lNewSeq := .T.
				oGrid:AddLine() // SE NÃO CRIA NOVA LINHA
				oGrid:GoLine(oGrid:Length())
			EndIF
		EndIF
	EndIF

	oGrid:SetValue("ZX_CLIENTE"	, cCliente  )
	oGrid:SetValue("ZX_NOMCLI" 	, cNomCli   )
	oGrid:SetValue("ZX_PERIODO"	, cPeriodo  )
	oGrid:SetValue("ZX_SEQ"    	, cSeq		)
	oGrid:SetValue("ZX_DATA"	, _aDados[NY,2])
	oGrid:SetValue("ZX_CODMASA"	, _aDados[NY,3])
	oGrid:SetValue("ZX_DESC"	, _aDados[NY,4])
	oGrid:SetValue("ZX_PEDCLI"	, _aDados[NY,5])
	oGrid:SetValue("ZX_QUANT"	, _aDados[NY,6])
	oGrid:SetValue("ZX_USUARIO"	, Alltrim( UsrRetName(__cUserId)))
next ny
   
//Se conseguir validar as informações
If oModel:VldData()
       
    //Tenta realizar o Commit
    If oModel:CommitData()
        lOk := .T.
           
    //Se não deu certo, altera a variável para false
    Else
        lOk := .F.
    EndIf
       
//Se não conseguir validar as informações, altera a variável para false
Else
    lOk := .F.
EndIf
   
//Se não deu certo a inclusão, mostra a mensagem de erro
If ! lOk
    //Busca o Erro do Modelo de Dados
    aErro := oModel:GetErrorMessage()
       
    //Monta o Texto que será mostrado na tela
    cMessage := "Id do formulário de origem:"  + ' [' + cValToChar(aErro[01]) + '], '
    cMessage += "Id do campo de origem: "      + ' [' + cValToChar(aErro[02]) + '], '
    cMessage += "Id do formulário de erro: "   + ' [' + cValToChar(aErro[03]) + '], '
    cMessage += "Id do campo de erro: "        + ' [' + cValToChar(aErro[04]) + '], '
    cMessage += "Id do erro: "                 + ' [' + cValToChar(aErro[05]) + '], '
    cMessage += "Mensagem do erro: "           + ' [' + cValToChar(aErro[06]) + '], '
    cMessage += "Mensagem da solução: "        + ' [' + cValToChar(aErro[07]) + '], '
    cMessage += "Valor atribuído: "            + ' [' + cValToChar(aErro[08]) + '], '
    cMessage += "Valor anterior: "             + ' [' + cValToChar(aErro[09]) + ']'
     
    //Mostra mensagem de erro
    lRet := .F.
    ConOut("Erro: " + cMessage)
Else
    lRet := .T.
    ConOut("Produto incluido!")
EndIf
   
//Desativa o modelo de dados
oModel:DeActivate()
Return 

// dbSetOrder(2)
// 	SZX->(msseek(xFilial('SZX')+cCliente+cLoja+cPeriodo+left(cCodMasa+Space(10),15)+cData)) // encontra o regitro

/*/{Protheus.doc} TrfParam
	(Rotina de transferencia de saldo entre as datas da carteira.)
	@type  Static Function
	@author Edson Sales
	@since 18/02/2026

/*/


User Function trfParam()
	Local LAMB := RpcSetEnv('01','01')
	Local aArea	  := GetArea()
	local cCli    := space(TAMSX3('ZX_CLIENTE')[1])
	local cLoj    := space(TAMSX3('ZX_LOJA')[1])
	local cPer    := space(TAMSX3('ZX_PERIODO')[1])
	// local cPro    := space(TAMSX3('ZX_CODMASA')[1])
	// local dData   := ctod('  /  /  ')
	Private oTransf
	// RpcSetEnv('01','01')
	@ 275,235 	To 496,880 Dialog oTransf Title OemToAnsi("Parametros")
	@ 5,2  		To 41,150 Title OemToAnsi("Cliente:")
	@ 5,160  	To 41,311 Title OemToAnsi("Periodo:")
	// @ 47,2  	TO 80,150  TITLE OemToAnsi("Produto:")
	// @ 47,160 	TO 80,311 TITLE OemToAnsi("Data Referência:")
	@ 20,10		MSGET cCli F3 "SA1" Size 60,10   PIXEL of oTransf VALID(Pesquise(@cCli,'SA1',2,'',@cLoj))
	@ 20,80		MSGET cLoj 			Size 30,10   PIXEL of oTransf WHEN .T.
	@ 20,170	MSGET cPer 		    Size 50,10   PIXEL of oTransf WHEN .T.
	// @ 57,10	 	MSGET cPro F3 "SB1" Size 100,10  PIXEL of oTransf  VALID(Pesquise(@cPro,'SB1',2,'',''))
	// @ 57,170 	MSGET dData 		Size 50,10   PIXEL OF oTransf

	@ 85,175 Button OemToAnsi("Buscar")          	Size 55,20 Action TransSld(cCli,cLoj,cPer)
	@ 85,250 Button OemToAnsi("Fechar")             Size 55,20 Action Close(oTransf)

	Activate Dialog oTransf  CENTERED

	RestArea(aArea)
Return 


Static Function TransSld(_cCli,_cLoj,_cPer)
	// Local LAMB := RpcSetEnv('01','01')
	Local nLargBtn      := 50
	Local oDlgLote
	Private aBrwSld := {}
	//Objetos e componentes
	Private oFwLayer
	Private oPanTitulo
	Private oPanGrid
	//CabeÃ§alho
	Private oSayTitulo, cSayTitulo := 'Transferencia de Saldo'
	Private oSaySubTit, cSaySubTit := 'Cliente: ' +Alltrim(_cCli) + '  ||   Periodo: '+ _cPer
	//Tamanho da janela

	//Fontes
	Private cFontUti    := "Tahoma"
	Private oFontMod    := TFont():New(cFontUti, , -38)
	Private oFontSub    := TFont():New(cFontUti, , -12)
	Private oFontSubN   := TFont():New(cFontUti, , -12, , .T.)
	Private oFontBtn    := TFont():New(cFontUti, , -12)
	Private oFontSay    := TFont():New(cFontUti, , -10)

	//Cria a janela
	Private aSize := MsAdvSize(.F.)
	Private nJanLarg := aSize[5] / 2
    Private nJanAltu := aSize[6] / 2

	nJanLarg := 900
	nJanAltu := 400

	if !VldSZX(_cCli,_cLoj,_cPer,'','')
		Return
	endif


	// aBrwSld := {{space(15),ctod('  /  /  '),0,space(15)}}
	aAdd(aBrwSld, { _cCli,_cLoj,_cPer,space(15), ctod('  /  /    '), 0, ctod('  /  /    ') })

	// DEFINE MSDIALOG oDlgLote TITLE "Saldos enderecos/Lotes"  FROM 200, 200 TO 800, 800 PIXEL
    DEFINE MSDIALOG oDlgLote TITLE "Tranferir saldo" ;
        FROM ( (aSize[6] - nJanAltu) ), ( (aSize[5] - nJanLarg) / 2 ) ;
        TO ( (aSize[6] + nJanAltu)  ), ( (aSize[5] + nJanLarg) / 2 ) PIXEL

	//Criando a camada
	oFwLayer := FwLayer():New()
	oFwLayer:init(oDlgLote,.F.)

	//Adicionando 3 linhas, a de tÃ­tulo, a superior e a do calendÃ¡rio
	oFWLayer:addLine("TIT", 10, .F.)
	oFWLayer:addLine("COR", 90, .F.)

	//Adicionando as colunas das linhas
	oFWLayer:addCollumn("HEADERTEXT",   050, .T., "TIT")
	oFWLayer:addCollumn("BLANKBTN",     050, .T., "TIT")

	oFWLayer:addCollumn("COLGRID",      100, .T., "COR")
	//Criando os paineis
	oPanHeader := oFWLayer:GetColPanel("HEADERTEXT", "TIT")
	oPanBut    := oFWLayer:GetColPanel("BLANKBTN",    "TIT")

	oPanGrid   := oFWLayer:GetColPanel("COLGRID",    "COR")

	//TÃ­tulos e SubTÃ­tulos
	oSayTitulo := TSay():New(004, 05, {|| cSayTitulo}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	oSaySubTit := TSay():New(014, 05, {|| cSaySubTit}, oPanHeader, "", oFontSubN, , , , .T., RGB(031, 073, 125), , 250, 30, , , , , , .F., , )

	//Parametros para preenchimento das etiquetas
	// oSayEtiqDe := TSay():New(001, 001, {|| "Volume de :"}, oPanPar, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	// cTGet1 := space(3)
	// oTGet1 := TGet():New( 01,45,{|u|if(PCount()==0,cTGet1,cTGet1:=u)},oPanPar,30,10,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet1,,,, )
	// oSayTitulo := TSay():New(001, 100, {|| "Volume atÃ©:"}, oPanPar, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	// cTGet2 := space(3)
	// oTGet2 := TGet():New( 01,145,{|u|if(PCount()==0,cTGet2,cTGet2:=u)},oPanPar,30,10,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet2,,,, )
	// oSaySubTit := TSay():New(001, 180, {|| "Lote:"}, oPanPar, "", oFontSub, , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	// cTGet3 := space(20)
	// oTGet3 := TGet():New( 01,205,{|u|if(PCount()==0,cTGet3,cTGet3:=u)},oPanPar,50,10,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet3,,,, )

	// //Criando os botÃµes
	// oBtnRep := TButton():New(006, 001, "Replicar",  oPanBut, {|| replicar()}, 30, 012, , oFontBtn, , .T., , , , , , )
	oBtnSel :=  TButton():New(006, 040, "Confirmar",  oPanBut, {|| TranfSaldo()}, 50, 012, , oFontBtn, , .T., , , , , , )
	oBtnSair := TButton():New(006, 100, "Sair",  	  oPanBut, {|| oDlgLote:End()}, 30, 012, , oFontBtn, , .T., , , , , , )


	//dialog com browse para definiÃ§Ã£o dos lotes
	oBrwSld := fwBrowse():New()
	//oBrwSld:SetColumns(aColunas)

	oBrwSld:lHeaderClick:=.F.
	oBrwSld:setDataArray()

	oBrwSld:disableConfig()
	oBrwSld:disableReport()
	oBrwSld:setOwner( oPanGrid )
	
	oBrwSld:addColumn({"Produto"		, {||aBrwSld[oBrwSld:nAt,04]}, "C", "@!" , 0, 10, , .F. ,{ || !Empty(aBrwSld[oBrwSld:nAt,04]), VldSZX(_cCli,_cLoj,_cPer,aBrwSld[oBrwSld:nAt,04],'')                        }, .F.,, ,, .F., .T., , 		"xProd"    })
	oBrwSld:addColumn({"Data Origem" 	, {|| aBrwSld[oBrwSld:nAt,05]},"D", "@D" , 0, 10, , .F. ,{ || !Empty(aBrwSld[oBrwSld:nAt,05]), VldSZX(_cCli,_cLoj,_cPer,aBrwSld[oBrwSld:nAt,04],dtos(aBrwSld[oBrwSld:nAt,05])) }, .F.,,,, .F., .T., , "xDtOri" })
	oBrwSld:addColumn({"Quantidade"		, {||aBrwSld[oBrwSld:nAt,06]}, "N", "@E 999,999.99" , 0, 10 , 2  , .T. , , .F.,, "__ReadVar",, .F., .T., , "xQuant"   })
	oBrwSld:addColumn({"Data Destino"	, {||aBrwSld[oBrwSld:nAt,07]}, "D", "@D"            , 0, 10 ,    , .T. ,{|| !Empty(aBrwSld[oBrwSld:nAt,05]), vldDtBrw(aBrwSld[oBrwSld:nAt,05],aBrwSld[oBrwSld:nAt,07])}, .F.,, "__ReadVar",, .F., .T., , "xDtDest"  })
	
	oBrwSld:setArray( aBrwSld )
	oBrwSld:SetLocate() // Habilita a LocalizaÃ§Ã£o de registros
	oBrwSld:setEditCell( .T. , { || vldLot() } )
	oBrwSld:SetEditCell( .T. )                 // indica que o grid Ã© editavel
	oBrwSld:acolumns[1]:ledit     := .T.
	oBrwSld:acolumns[1]:cReadVar:= 'aBrwSld[oBrwSld:nAt,4]'
	oBrwSld:acolumns[2]:ledit     := .T.
	oBrwSld:acolumns[2]:cReadVar:= 'aBrwSld[oBrwSld:nAt,5]'
	oBrwSld:acolumns[3]:ledit     := .T.
	oBrwSld:acolumns[3]:cReadVar:= 'aBrwSld[oBrwSld:nAt,6]'
	oBrwSld:acolumns[4]:ledit     := .T.
	oBrwSld:acolumns[4]:cReadVar:= 'aBrwSld[oBrwSld:nAt,7]'
	//oBrwSld:setInsert( .F. )
	//oBrwSld:SetDelete( .F., {||DeleteLine()} )
	//oBrwSld:setLineOk( { || chkLineOk() } )
	//oBrwSld:setAfterAddLine( { || posIncLine() } )

	oBrwSld:activate( )

	Activate MsDialog oDlgLote Centered

Return(aBrwSld)

Static Function SelectAll()
	Local i
	Local lMark:= aBrwSld[1,1]
	For i:= 1 to len(aBrwSld)
		aBrwSld[i,1]:= !lMark
	Next
	oBrwSld:refresh()
Return

/*
Static Function posIncLine()
	If oBrwSld:at() == len(aBrwSld)
		aBrwSld[ oBrwSld:at() , oBrwSld:GetColByID("xLote"    ):nOrder ] := space(20)
		aBrwSld[ oBrwSld:at() , oBrwSld:GetColByID("xQtdLote" ):nOrder ] := 0
	Endif
Return
Static Function DeleteLine()
	//Exclui o segundo elemento do Array (Deixa o segundo elemento como Nil)
    aDel(aBrwSld, oBrwSld:at() )
    //Redimensiona o Array
    aSize(aBrwSld, Len(aBrwSld)-1)
	oBrwSld:setArray(aBrwSld)	// ForÃ§o o Browse a ler os novos valores informados.
    oBrwSld:Refresh()				// Refresh do Grid
Return
*/

Static Function VldSZX(_XCLI,_XLOJ,_XPER,_XPROD,_XDATA)
	Local lRet:= .F.
	// VALIDA PRODUTO PARA TRANFERENCIA DE SALDO.
	DBSelectArea('SZX')

	DBSetOrder(2)

	if SZX->(msseek(xFilial('SZX')+_XCLI+_XLOJ+_XPER+_XPROD+_XDATA))
		lRet:= .T.
	Else
		IF Empty(_XDATA)
			FwAlertWarning('Esse produto não foi encontrado para o cliente e Periodo informados, verifique o cliente e o periodo','Atencao !!!')
		elseif Empty(_XPROD)
			FwAlertWarning('não existe carteira para o cliente no Periodo informados, verifique o cliente e o periodo','Atencao !!!')
		else
			FwAlertWarning('Não existe saldo no produto para a data de referencia informada.','Atencao !!!')
		endif
		lRet:= .F.
	endif

Return lRet

Static Function vldDtBrw(dDTOrig, dDTDest)

	if dDTOrig == dDTDest
		FwAlertWarning('As datas origem e destino não podem ser iguais')
		Return .F.
	endif
return .T.

/*/{Protheus.doc} TranfSaldo()
	(long_description)
	@type  Static Function
	@author user
	@since 18/02/2026
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function TranfSaldo()
	Local cCliente := aBrwSld[1][1]
	Local cLoja	   := aBrwSld[1][2]
	Local cNomCli  := AllTRim(Posicione('SA1',1,xFilial('SA1')+aBrwSld[1][1],'A1_NOME'))
	Local cDescri  := AllTRim(Posicione('SB1',1,xFilial('SB1')+aBrwSld[1][4],'B1_DESC'))
	Local cPeriodo := aBrwSld[1][3]

	aDados := {}
	// origem
	nQTDOri :=  posicione('SZX',2, xFilial('SZX')+cCliente+cLoja+cPeriodo+aBrwSld[1][4]+DTOS(aBrwSld[1][5]),'ZX_QUANT')
	nSld := nQTDOri - aBrwSld[1][6]  // quant original - quantidade tranferida

	// data [1]   cod masa [2]   Descricao [3]   pedido [4]   quantidade [5]
	aAdd(aDados,{aBrwSld[1][5],aBrwSld[1][4],cDescri,         '',           nSld     })

	nQTDOri :=  posicione('SZX',2, xFilial('SZX')+cCliente+cLoja+cPeriodo+aBrwSld[1][4]+DTOS(aBrwSld[1][7]),'ZX_QUANT')
	nSld := nQTDOri + aBrwSld[1][6]  // quant original + quantidade tranferida
	// data [1]   cod masa [2]   Descricao [3]   pedido [4]   quantidade [5]
	aAdd(aDados,{aBrwSld[1][7],aBrwSld[1][4],cDescri,         '',           nSld     })

	RptStatus({|| IncRegs(aDados,2,cCliente,cLoja,cNomCli,cPeriodo)}, "Aguarde...", "Transferindo saldo...")

Return
