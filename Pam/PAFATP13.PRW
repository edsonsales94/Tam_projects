#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include 'Totvs.ch'
#include 'topconn.ch'


/*/{Protheus.doc} PAFATP13
//TODO Descricao Rotina MVC para cadastro romaneios
@author Halb
@since 20/10/2025
@version 1.0
@type function
/*/

user function PAFATP13()
	Local aArea   := GetArea()
	Local oBrowse
	Local cFunBkp := FunName()
	//Local aParam := PARAMIXB

	SetFunName("PAFATP13")

	oBrowse:= FWMBrowse():New()
	oBrowse:SetAlias('ZZF')
	oBrowse:SetDescription('Romaneios')
	oBrowse:Activate()

	SetFunName(cFunBkp)

	RestArea(aArea)
Return Nil

/*/{Protheus.doc} MenuDef
//TODO Descricao Rotina MVC que define as opcoes de menu que estao disponiveis
@author Rogerio
@since 17/10/2019
@version 1.0


@type function
/*/
Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.PAFATP13' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.PAFATP13' OPERATION 3 ACCESS 0
	
Return aRotina

/*/{Protheus.doc} ModelDef
//TODO Descricao auto-gerada.
@author Rogerio
@since 17/10/2019
@version 1.0


@type function
/*/
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStrZZFA := FWFormStruct( 1, 'ZZF' ,{ |cCampo| ZZFCABSTRU(cCampo,1) } )
	Local oStrZZFB := FWFormStruct( 1, 'ZZF' ,{ |cCampo| ZZFCABSTRU(cCampo,2) } )
	Local oModel // Modelo de dados que sera construido
	Local aZZFRel := {}

	oModel := MPFormModel():New( 'ZZFMODEL', , , /* */)
	oModel:AddFields( 'ZZFMASTER', /*cOwner*/ , oStrZZFA)
	oModel:AddGrid(   'ZZFGRID'  , 'ZZFMASTER', oStrZZFB)

	aAdd(aZZFRel,{ 'ZZF_FILIAL' , 'xFilial("ZZF")' })
	aAdd(aZZFRel,{ 'ZZF_NUM'    , 'ZZF_NUM'        })
	aAdd(aZZFRel,{ 'ZZF_DATA'   , 'ZZF_DATA'       })
	aAdd(aZZFRel,{ 'ZZF_LOCENT' , 'ZZF_LOCENT'     })
    aAdd(aZZFRel,{ 'ZZF_BAU'    , 'ZZF_BAU'        })
    aAdd(aZZFRel,{ 'ZZF_CLIENT' , 'ZZF_CLIENT '    })
    aAdd(aZZFRel,{ 'ZZF_LOJA'   , 'ZZF_LOJA'       })

	oModel:SetRelation(  'ZZFGRID' , aZZFRel , ZZF->( IndexKey( 1 ) ) )

	oModel:SetDescription( 'Romaneio' )
                                                           
	oModel:SetPrimaryKey( { "ZZF_FILIAL" , "ZZF_NUM" , "ZZF_DATA" , /*"ZZF_LOCENT",*/ "ZZF_CLIENT", "ZZF_LOJA", "ZZF_BAU" })
	oModel:GetModel( 'ZZFMASTER' ):SetDescription( 'Complemento de estruturas' )
	oModel:GetModel( 'ZZFGRID' ):SetDescription( 'Detalhes Posicoes' )

Return oModel

/*/{Protheus.doc} ViewDef
//TODO Descricao auto-gerada.
@author Rogerio
@since 17/10/2019
@version 1.0


@type function
/*/
Static Function ViewDef()
	Local oModel := FWLoadModel( 'PAFATP13' )
	Local oStrZZFA := FWFormStruct( 2, 'ZZF' ,{ |cCampo| ZZFCABSTRU(cCampo,1) } )
	Local oStrZZFB := FWFormStruct( 2, 'ZZF' ,{ |cCampo| ZZFCABSTRU(cCampo,2) } )
	Local oView

	oView := FWFormView():New()

	oView:SetModel( oModel )
	oView:AddField( 'VIEW_ZZFMASTER', oStrZZFA, 'ZZFMASTER' )
	oView:AddGrid( 'VIEW_ZZFDETAIL', oStrZZFB, 'ZZFGRID' )

	oView:AddUserButton( 'Carregar', 'CLIPS', {|oView| fatp13get()} )  

	oView:CreateHorizontalBox( 'SUPERIOR' , 25)
	oView:CreateHorizontalBox( 'INFERIOR' , 75)
	
	oView:SetOwnerView( 'VIEW_ZZFMASTER', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZZFDETAIL', 'INFERIOR' )

	oView:EnableTitleView( 'VIEW_ZZFMASTER', 'Romaneio')
	oView:EnableTitleView( 'VIEW_ZZFDETAIL', 'Detalhes' )

Return  oView

/*/{Protheus.doc} 
//TODO Descricao defini a lista de campos que serao do cabecalho ou do gride
@author Rogerio
@since 17/10/2019
@version 1.0

@param cCampo, characters, descricao
@param nop, numeric, descricao
@type function
/*/
Static Function ZZFCABSTRU( cCampo,nop )
	Local lRet     := .F.
    Local cxCabFld := { "ZZF_NUM", "ZZF_DATA", /*"ZZF_LOCENT",*/"ZZF_CLIENT","ZZF_LOJA","ZZF_CLINOM","ZZF_BAU","ZZF_STATUS"}
    Local cxIteFld := { "ZZF_PEDIDO", "ZZF_ITEM", "ZZF_LOCENT", "ZZF_PROD","ZZF_PRODNM","ZZF_QUANT","ZZF_VOLUME","ZZF_QUANT","ZZF_HORAE","ZZF_PEDCLI","ZZF_EMB","ZZF_EMBNOM","ZZF_QTDPAD","ZZF_AGRUP"}
    Local nPos     := 0
    Local aVector  := iif(nop=1,aclone(cxCabFld),aclone(cxIteFld))

    nPos := AScan( aVector , {|x| x == Alltrim(cCampo) } )
	
    lRet := nPos > 0 

Return lRet


static function fatp13get()
	Local aArea := FWGetArea()
    Local aPergs   := {}
    Local xPar0 := ddatabase
    Local xPar1 := ddatabase
	Local xPar2 := Space(3)
    Local xPar3 := "ZZZ"
	Local xPar4 := Space(6)
    Local xPar5 := "ZZZZZZ"
    
    //Adicionando os parametros do ParamBox
    aAdd(aPergs, {1, "Entrega De ", xPar0,  "", ".T.", "", ".T.", 80,  .F.})
    aAdd(aPergs, {1, "Entrega Até", xPar1,  "", ".T.", "", ".T.", 80,  .T.})
	
    //Se a pergunta for confirma, chama a tela
    If ParamBox(aPergs, "Informe os parametros")
        fMontaTela()
    EndIf
     
    FWRestArea(aArea)
Return
 

 
Static Function fMontaTela()
    Local aArea         := GetArea()
    Local aCampos       := {}
    Local aSeek         := {}
    Local oTempTable    := Nil
    Local aColunas      := {}
    Local cFontPad      := 'Tahoma'
    Local oFontGrid     := TFont():New(cFontPad,,-14)
    //Janela e componentes
    Private oDlgMark
    Private oPanGrid
    Private oMarkBrowse
    Private cAliasTmp := GetNextAlias()
    Private aRotina   := DefMenu()
    //Tamanho da janela
    Private aTamanho := MsAdvSize()
    Private nJanLarg := aTamanho[5]
    Private nJanAltu := aTamanho[6]
      
    //Adiciona as colunas que serão criadas na temporária
    aAdd(aCampos, { 'OK'        , 'C', 2, 0})  //Flag para marcação
    aAdd(aCampos, { 'C6_XLOCENT', 'C', 12, 0}) //Local
	aAdd(aCampos, { 'C6_ENTREG' , 'D', 8, 0})  //Data
	aAdd(aCampos, { 'C6_XHORENT', 'C', 9, 0})  //Hora 
	aAdd(aCampos, { 'C6_PEDCLI' , 'C', 15, 0}) //PedCli
	aAdd(aCampos, { 'C6_PRODUTO', 'C', 15, 0}) //Produto
    aAdd(aCampos, { 'C6_DESCRI' , 'C', 80, 0}) //Descri
	aAdd(aCampos, { 'C6_QTDVEN' , 'N', 14, 6}) //Quant
	aAdd(aCampos, { 'C5_NUM'    , 'C', 6, 0})  //Pedido
    aAdd(aCampos, { 'C6_ITEM'   , 'C', 2, 0})  //Item
	
    //Cria a tabela temporária
    oTempTable:= FWTemporaryTable():New(cAliasTmp)
    oTempTable:SetFields( aCampos )
    oTempTable:AddIndex("local"  , {"C6_XLOCENT"} )
    oTempTable:AddIndex("hora"   , {"C6_XHORENT"} )
    oTempTable:AddIndex("pedido" , {"C5_NUM"}     )
    oTempTable:Create()  
 
    //Popula a tabela temporária
    Processa({|| fPopula()}, 'Processando...')
 
    //Adiciona as colunas que serão exibidas no FWMarkBrowse
    aColunas := fCriaCols()

    aAdd(aSeek,{"Local"   ,{{"","C",TAMSX3("C6_XLOCENT")[1] ,0,"C6_XLOCENT","@!"}} } )
    aAdd(aSeek,{"Hora"    ,{{"","C",TAMSX3("C6_XHORENT")[1],0,"C6_XHORENT" ,"@!"}} } )
    aAdd(aSeek,{"Pedido"  ,{{"","C",TAMSX3("C5_NUM")[1],0,"C5_NUM" ,"@!"}} } )

    //Criando a janela
    DEFINE MSDIALOG oDlgMark TITLE 'Tela para Marcação de pedidos para romaneio' FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        //Dados
        oPanGrid := tPanel():New(001, 001, '', oDlgMark, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2)-1,     (nJanAltu/2 - 1))
        oMarkBrowse := FWMarkBrowse():New()
        oMarkBrowse:SetAlias(cAliasTmp)                
        oMarkBrowse:SetDescription('Romaneio')
        oMarkBrowse:SetUseFilter()
        oMarkBrowse:SetSeek(.T.,aSeek)
        oMarkBrowse:SetFontBrowse(oFontGrid)
        oMarkBrowse:SetFieldMark('OK')
        oMarkBrowse:SetTemporary(.T.)
        oMarkBrowse:SetColumns(aColunas)
        oMarkBrowse:AllMark() 
        oMarkBrowse:SetOwner(oPanGrid)
        oMarkBrowse:Activate()
    ACTIVATE MsDialog oDlgMark CENTERED
     
    //Deleta a temporária e desativa a tela de marcação
    oTempTable:Delete()
    oMarkBrowse:DeActivate()
     
    RestArea(aArea)
Return
 
 
Static Function DefMenu()
    Local aRotina := {}
      
    //Criação das opções
    ADD OPTION aRotina TITLE 'Selecionar'  ACTION 'u_fMarkaAbs'     OPERATION 2 ACCESS 0
Return aRotina
 
 
 
Static Function fPopula()
    Local cQuery     := ''
    Local nTotal     := 0
    Local nAtual     := 0
    Local oxModel    := FWModelActive()
    Local _xCliento  := oxModel:GetValue('ZZFMASTER','ZZF_CLIENT')
    Local _xLojo     := oxModel:GetValue('ZZFMASTER','ZZF_LOJA')
	

    cQuery +=" SELECT convert(VARCHAR(10),CAST(C6_ENTREG AS DATE),103) C6_ENTREG, C6_ITEM, C5_CLIENTE, C5_LOJACLI,  "
    cQuery += " left(C6_XHORENT,2)+':'+right(C6_XHORENT,2) AS C6_XHORENT,SC6.C6_NUM C5_NUM,   "
    cQuery+= " SC6.C6_PRODUTO,C6_DESCRI,SC6.C6_TES C6_TES,SC6.R_E_C_N_O_ AS C6RECNO, C6_PEDCLI, 
    cQuery+= " B1_GRUPO,"
    cQuery+= " C6_XLOCENT, "
    cQuery+= " left(CASE WHEN C6_XLOCENT IN  ('HD1-COALI   ','HD1-COALI/MI','HD1-PINT.') THEN 'HD1-COALI' "
    cQuery+= " WHEN C6_XLOCENT IN  ('HD2-DOCA-01','HD2-DOCA-02 ','HD2-DOCA-03 ','HDA2-DOCA-04','HDA2-DOCA-03','L81 HD2-MIUD') THEN 'HD2-DOCA' "
    cQuery+= " WHEN C6_XLOCENT IN  ('ASTEC HD E  ','ASTEC HD F  ') THEN 'ASTEC HD ' "
    cQuery+= " ELSE C6_XLOCENT END ,20) AS C6_XLOCENT,"
    cQuery+= " SC6.C6_XSETENT C6_XSETENT,LTRIM(RTRIM(SB1.B1_DESC)) B1_DESC,SC6.C6_QTDVEN-SC6.C6_QTDENT C6_QTDVEN,SC6.C6_PRCVEN,round(SC6.C6_VALOR,2) C6_VALOR,  B1_XREF C6_XCODITE " 
    cQuery+= " FROM "+RetSQLName("SC6")+" SC6 "
    cQuery+= " INNER JOIN "+RetSQLName("SB1")+" SB1 ON "
    cQuery+= " SB1.D_E_L_E_T_='' "
    cQuery+= " AND SB1.B1_COD=SC6.C6_PRODUTO "
    cQuery+= " INNER JOIN "+RetSQLName("SC5")+" SC5 ON "
    cQuery+= " SC5.D_E_L_E_T_='' "
    cQuery+= " AND SC5.C5_NUM = SC6.C6_NUM AND C5_FILIAL = C6_FILIAL "
    cQuery+= " WHERE SC6.D_E_L_E_T_='' AND C6_QTDVEN - C6_QTDENT > 0  "
    cQuery+= " AND C5_CLIENTE = '"+ _xCliento +"' AND C5_LOJACLI = '"+ _xLojo +"' "
    cQuery+= " AND C6_ENTREG BETWEEN '"+ dtos(MV_PAR01) +"' AND '"+ dtos(MV_PAR02) +"' "

    PLSQuery(cQuery, 'QRYDADTMP')
 
    //Definindo o tamanho da régua
    DbSelectArea('QRYDADTMP')
    Count to nTotal
    ProcRegua(nTotal)
    QRYDADTMP->(DbGoTop())
 
    //Enquanto houver registros, adiciona na temporária
    While ! QRYDADTMP->(EoF())
        nAtual++
        IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')
 
        RecLock(cAliasTmp, .T.)
            (cAliasTmp)->OK := Space(2)
            (cAliasTmp)->C6_XLOCENT     := QRYDADTMP->C6_XLOCENT
            (cAliasTmp)->C6_ENTREG      := QRYDADTMP->C6_ENTREG
            (cAliasTmp)->C6_XHORENT     := QRYDADTMP->C6_XHORENT
            (cAliasTmp)->C6_PEDCLI      := QRYDADTMP->C6_PEDCLI
			(cAliasTmp)->C6_PRODUTO     := QRYDADTMP->C6_PRODUTO		
            (cAliasTmp)->C6_DESCRI      := QRYDADTMP->C6_DESCRI
            (cAliasTmp)->C6_QTDVEN      := QRYDADTMP->C6_QTDVEN
            (cAliasTmp)->C5_NUM         := QRYDADTMP->C5_NUM
			(cAliasTmp)->C6_ITEM        := QRYDADTMP->C6_ITEM		

        (cAliasTmp)->(MsUnlock())
 
        QRYDADTMP->(DbSkip())
    EndDo
    QRYDADTMP->(DbCloseArea())
    (cAliasTmp)->(DbGoTop())
Return
 
 
 
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

    aAdd(aEstrut, { 'C6_XLOCENT'    , 'Local'    , 'C', 12, 0, ''})
    aAdd(aEstrut, { 'C6_ENTREG'     , 'Data'     , 'D', 8, 0, ''})
    aAdd(aEstrut, { 'C6_XHORENT'    , 'Hora'     , 'C', 05, 0, ''})
    aAdd(aEstrut, { 'C6_PEDCLI'     , 'Pedido Cliente' , 'C', 15, 0, ''})
	aAdd(aEstrut, { 'C6_PRODUTO'    , 'Produto'    , 'C', 15, 0, ''})
    aAdd(aEstrut, { 'C6_DESCRI'    , 'Produto Descr' , 'C', 80, 0, ''})
    aAdd(aEstrut, { 'C6_QTDVEN'    , 'Quantidade'    , 'N', 14, 6, ''})
    aAdd(aEstrut, { 'C5_NUM'       , 'Pedido'        , 'C', 06, 0, ''})
    aAdd(aEstrut, { 'C6_ITEM'      , 'Item Pv'       , 'C', 02, 0, ''})

	
	
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
 
 
User Function fMarkaAbs()
    Processa({|| fProcessa()}, 'Processando...')
Return
 
 
Static Function fProcessa()
    Local aArea     := FWGetArea()
    Local cMarca    := oMarkBrowse:Mark()
    Local nAtual    := 0
    Local nTotal    := 0
    Local nTotMarc  := 0
    Local oxModel   := FWModelActive()
     
    //Define o tamanho da régua
    DbSelectArea(cAliasTmp)
    (cAliasTmp)->(DbGoTop())
    Count To nTotal
    ProcRegua(nTotal)
     
    //Percorrendo os registros
    (cAliasTmp)->(DbGoTop())
    SRA->(DbSetOrder(1))

    //oxModel:SetValue('ZZFMASTER','ZZF_LOCENT',(cAliasTmp)->C6_XLOCENT)  

    While ! (cAliasTmp)->(EoF())
        nAtual++
        IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')
     
        //Caso esteja marcado
        If oMarkBrowse:IsMark(cMarca)
            nTotMarc++

            SB1->(DbSetOrder(1))

            If SB1->(Dbseek(xfilial("SB1")+(cAliasTmp)->C6_PRODUTO))

                oxModel:GetModel('ZZFGRID'):AddLine()  
                oxModel:SetValue('ZZFGRID','ZZF_PEDIDO',(cAliasTmp)->C5_NUM)  
                oxModel:SetValue('ZZFGRID','ZZF_ITEM'  ,(cAliasTmp)->C6_ITEM)
                oxModel:SetValue('ZZFGRID','ZZF_PROD'  ,(cAliasTmp)->C6_PRODUTO)
                oxModel:SetValue('ZZFGRID','ZZF_PRODNM', Left(SB1->B1_DESC,30))
                oxModel:SetValue('ZZFGRID','ZZF_QTDPAD', SB1->B1_XQTDEMB)
                oxModel:SetValue('ZZFGRID','ZZF_QUANT' ,(cAliasTmp)->C6_QTDVEN)
                oxModel:SetValue('ZZFGRID','ZZF_PEDCLI',(cAliasTmp)->C6_PEDCLI)
                oxModel:SetValue('ZZFGRID','ZZF_HORAE' , alltrim((cAliasTmp)->C6_XHORENT))

                
      
            EndIf
            

        EndIf
          
        (cAliasTmp)->(DbSkip())
    EndDo

    oxModel:VldData()
    
    //Mostra a mensagem de término e caso queria fechar a dialog, basta usar o método End()
    FWAlertInfo('Dos [' + cValToChar(nTotal) + '] registros, foram processados [' + cValToChar(nTotMarc) + '] registros', 'Atenção')
    //oDlgMark:End()
 
    FWRestArea(aArea)
Return

