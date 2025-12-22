/*---------------------------------------------------------------------------*
 | Data       : 26/03/2024                                                   |
 | Rotina     : ANGTPA05                                                     |
 | Responsável: ENER FREDES                                                  |
 | Descrição  : Rotina de Abastecimento                                      |
 *---------------------------------------------------------------------------*/


#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

#define MB_OK                       0
#define MB_ICONEXCLAMATION          48
#define MB_ICONASTERISK             64

Static cTitulo := "Abastecimento de Combustível"
 
User Function ANGTPA05()
    Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()
     
    SetFunName("ANGTPA05")
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SZD")
    oBrowse:SetDescription(cTitulo)
    oBrowse:AddLegend( "Empty(SZD->ZD_NUMPC)", "GREEN", "CE Aberto" )
    oBrowse:AddLegend( "!Empty(SZD->ZD_NUMPC)", "RED",  "CE com Peddido" )
     
    //Filtrando
    //oBrowse:SetFilterDefault("ZZ1->ZZ1_COD >= '000000' .And. ZZ1->ZZ1_COD <= 'ZZZZZZ'")
    oBrowse:Activate()
    SetFunName(cFunBkp)
    RestArea(aArea)
Return Nil
 
 
Static Function MenuDef()
    Local aRot := {}
     
    ADD OPTION aRot TITLE 'Visualizar'   ACTION 'VIEWDEF.ANGTPA05' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Incluir'      ACTION 'VIEWDEF.ANGTPA05' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'      ACTION 'VIEWDEF.ANGTPA05' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'      ACTION 'VIEWDEF.ANGTPA05' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Legenda'      ACTION 'u_zMod1Leg'       OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Gera PC'      ACTION 'u_GTPA05PC(1)'    OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Excluir PC'   ACTION 'u_GTPA05PC(2)'    OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Importa CE'   ACTION 'u_GTPA05IN'       OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION X

Return aRot

Static Function ModelDef()
    Local oModel := Nil
    Local oStSZD := FWFormStruct(1, "SZD")

    oStSZD:SetProperty('ZD_NUMCE',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'U_VGTPA05CE()'))   //Validação de Campo
    oStSZD:SetProperty('ZD_NUMVOO', MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'U_VGTPA05VO()'))   //Validação de Campo

    //Editando características do dicionário
    /*
    oStZZ1:SetProperty('ZZ1_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edição
    oStZZ1:SetProperty('ZZ1_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZZ1", "ZZ1_COD")'))         //Ini Padrão
    oStZZ1:SetProperty('ZZ1_DESC',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->ZZ1_DESC), .F., .T.)'))   //Validação de Campo
    oStZZ1:SetProperty('ZZ1_DESC',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigatório
     */
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("ANGTP05M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
    oModel:AddFields("FORMSZD",/*cOwner*/,oStSZD)
    oModel:SetPrimaryKey({'ZD_FILIAL','ZD_NUMCE'})
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
    oModel:GetModel("FORMSZD"):SetDescription("Formulário do Cadastro "+cTitulo)
Return oModel
 
Static Function ViewDef()
    Local oModel := FWLoadModel("ANGTPA05")
    Local oStSZD := FWFormStruct(2, "SZD")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZZ1_NOME|SZZ1_DTAFAL|'}
    Local oView := Nil

    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_SZD", oStSZD, "FORMSZD")
    oView:CreateHorizontalBox("TELA",100)
    oView:EnableTitleView('VIEW_SZD', 'Dados - '+cTitulo )  
    oView:SetCloseOnOk({||.T.})
    oView:SetOwnerView("VIEW_SZD","TELA")
     
    /*
    //Tratativa para remover campos da visualização
    For nAtual := 1 To Len(aStruZZ1)
        cCampoAux := Alltrim(aStruZZ1[nAtual][01])
         
        //Se o campo atual não estiver nos que forem considerados
        If Alltrim(cCampoAux) $ "ZZ1_COD;"
            oStZZ1:RemoveField(cCampoAux)
        EndIf
    Next
    */
Return oView
 
User Function zMod1Leg()
    Local aLegenda := {}

    AADD(aLegenda,{"BR_VERDE",     "CE Aberto"  })
    AADD(aLegenda,{"BR_VERMELHO",  "CE com Pedido de Compra"})
    BrwLegenda(cTitulo, "Status", aLegenda)
Return

User Function VGTPA05CE()
    Local lRet := .t.
    SZD->(DbsetOrder(2))
    If SZD->(DbSeek(xFilial("SZD")+M->ZD_NUMCE)) 
        Alert("ERROR - CE já foi Cadastrada")
        lRet := .F.
    EndIf
Return lRet

User Function VGTPA05VO()
    Local lRet := .t.
    SZA->(DbsetOrder(1))
    If !SZA->(DbSeek(xFilial("SZA")+M->ZD_NUMVOO))
        Alert("ERROR - Voo não localizado")
        lRet := .F.
    EndIf
Return lRet

User Function GTPA05PC(nOpc)
    Local aPergs   := {}
    Local xPar0 := Space(6)
    Local xPar1 := Space(2)
    Local xPar2 := Ctod(Space(8))
    Local xPar3 := Ctod(Space(8))
    Local cNomeFor := ""
    Local cFonte:= "Tahoma"
    Local oFontSay    := TFont():New(cFonte, , -14)
    Local oFontSayN   := TFont():New(cFonte, , -14, , .T.)
 
    Private oDlgGeraPC,oPnMaster,oGeraPCBrw,oSay
    Private lMarker     := .T.
    Private aAbastece := {}
    //Adicionando os parametros do ParamBox
    aAdd(aPergs, {1, "Forcedor", xPar0,  "", ".T.", "SA2", ".T.", 60,  .F.})
    aAdd(aPergs, {1, "Loja"    , xPar1,  "", ".T.", ""   , ".T.", 20,  .T.})
    aAdd(aPergs, {1, "Data de" , xPar2,  "", ".T.", ""   , ".T.", 60,  .T.})
    aAdd(aPergs, {1, "Data Ate", xPar3,  "", ".T.", ""   , ".T.", 60,  .T.})
     
    //Se a pergunta for confirma, chama a tela
    If ParamBox(aPergs, "Informe os parametros")
        fCargaSZB(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,nOpc)
    Else
        Return
    EndIf
    
    cNomeFor := Posicione("SA2",1,xFilial("SA2")+MV_PAR01+MV_PAR02,"A2_NOME")
    DEFINE MsDIALOG oDlgGeraPC  TITLE 'Selecione os CE para Gerar Pedido de Compra' From 0, 4 To 650, 800 Pixel

        oSay := TSay():New(005, 005, {|| 'Fornecedor:'}, oDlgGeraPC, "", oFontSay,  , , , .T., RGB(0,0,0), , 200, 30, , , , , , .F., , )
        oSay := TSay():New(005, 050, {|| MV_PAR01+" - "+MV_PAR02+" "+cNomeFor}, oDlgGeraPC, "", oFontSayN,  , , , .T., RGB(031, 073, 125), , 200, 30, , , , , , .F., , )
        oSay := TSay():New(020, 005, {|| 'Período:'}, oDlgGeraPC, "", oFontSay,  , , , .T., RGB(0,0,0), , 200, 30, , , , , , .F., , )
        oSay := TSay():New(020, 050, {|| Dtoc(MV_PAR03)+" - "+Dtoc(MV_PAR04)}, oDlgGeraPC, "", oFontSayN,  , , , .T., RGB(031, 073, 125), , 200, 30, , , , , , .F., , )
        If nOpc == 1
           TButton():New( 005, 252, "Gerar PC"  , oDlgGeraPC,{|| Processa({||fGravaPC(aAbastece,MV_PAR01,MV_PAR02)},"Processando") } ,40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
        Else
           TButton():New( 005, 252, "Excluir PC", oDlgGeraPC,{|| Processa({||fExcluiPC(aAbastece,MV_PAR01,MV_PAR02)},"Processando") },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
        EndIf
        TButton():New( 020, 252, "Cancelar", oDlgGeraPC,{|| oDlgGeraPC:End() },40,010,,,.F.,.T.,.F.,,.F.,,,.F.)
        
        oPnMaster := tPanel():New(043,002,,oDlgGeraPC,,,,,,390,280)
 ///       oPnMaster:Align := CONTROL_ALIGN_BOTTOM
    
        oGeraPCBrw := fwBrowse():New()
        oGeraPCBrw:setOwner( oPnMaster )
    
        oGeraPCBrw:setDataArray()
        oGeraPCBrw:setArray( aAbastece )
        oGeraPCBrw:disableConfig()
        oGeraPCBrw:disableReport()
    
        oGeraPCBrw:SetLocate() // Habilita a Localização de registros
    
        //Create Mark Column
        oGeraPCBrw:AddMarkColumns({|| IIf(aAbastece[oGeraPCBrw:nAt,01], "LBOK", "LBNO")},; //Code-Block image
            {|| SelectOne(oGeraPCBrw, aAbastece)},; //Code-Block Double Click
            {|| SelectAll(oGeraPCBrw, 01, aAbastece) }) //Code-Block Header Click
        If nOpc == 1
            oGeraPCBrw:addColumn({"Data"           , {||aAbastece[oGeraPCBrw:nAt,02]}, "D", "@D"                , 1,  9, , .T. , , .F.,, "aAbastece[oGeraPCBrw:nAt,02]",, .F., .T., , "ETDESPES1"})
            oGeraPCBrw:addColumn({"Nro CE"         , {||aAbastece[oGeraPCBrw:nAt,03]}, "C", "@!"                , 1,  9, , .T. , , .F.,, "aAbastece[oGeraPCBrw:nAt,02]",, .F., .T., , "ETDESPES1"})
            oGeraPCBrw:addColumn({"Nro Voo"        , {||aAbastece[oGeraPCBrw:nAt,04]}, "C", "@!"                , 1,  6, , .T. , , .F.,, "aAbastece[oGeraPCBrw:nAt,03]",, .F., .T., , "ETDESPES2"})
            oGeraPCBrw:addColumn({"Quantidade"     , {||aAbastece[oGeraPCBrw:nAt,05]}, "N", "@E 999,999,999.99" , 1, 15, , .T. , , .F.,, "aAbastece[oGeraPCBrw:nAt,04]",, .F., .T., , "ETDESPES3"})
            oGeraPCBrw:addColumn({"Vlr Unitário"   , {||aAbastece[oGeraPCBrw:nAt,06]}, "N", "@E 999,999.9999"   , 1, 15, , .T. , , .F.,, "aAbastece[oGeraPCBrw:nAt,05]",, .F., .T., , "ETDESPES4"})
            oGeraPCBrw:addColumn({"Vlr Total"      , {||aAbastece[oGeraPCBrw:nAt,07]}, "N", "@E 999,999,999.99" , 1, 15, , .T. , , .F.,, "aAbastece[oGeraPCBrw:nAt,06]",, .F., .T., , "ETDESPES5"})
            oGeraPCBrw:addColumn({"Produto"        , {||aAbastece[oGeraPCBrw:nAt,08]}, "C", "@!"                , 1, 15, , .T. , , .F.,, "aAbastece[oGeraPCBrw:nAt,07]",, .F., .T., , "ETDESPES6"})
        Else
            oGeraPCBrw:addColumn({"Nro PC"           , {||aAbastece[oGeraPCBrw:nAt,02]}, "C", "@!"                , 1,  9, , .T. , , .F.,, "aAbastece[oGeraPCBrw:nAt,02]",, .F., .T., , "ETDESPES1"})
            oGeraPCBrw:addColumn({"Cod. Fornecedor"  , {||aAbastece[oGeraPCBrw:nAt,03]}, "C", "@!"                , 1,  6, , .T. , , .F.,, "aAbastece[oGeraPCBrw:nAt,03]",, .F., .T., , "ETDESPES2"})
            oGeraPCBrw:addColumn({"loja"             , {||aAbastece[oGeraPCBrw:nAt,04]}, "C", "@!"                , 1,  2, , .T. , , .F.,, "aAbastece[oGeraPCBrw:nAt,04]",, .F., .T., , "ETDESPES3"})
            oGeraPCBrw:addColumn({"Nome Fornecedor"  , {||aAbastece[oGeraPCBrw:nAt,05]}, "C", "@!"                , 1, 40, , .T. , , .F.,, "aAbastece[oGeraPCBrw:nAt,05]",, .F., .T., , "ETDESPES4"})
            oGeraPCBrw:addColumn({"Valor"            , {||aAbastece[oGeraPCBrw:nAt,06]}, "N", "@E 999,999,999.99" , 1, 15, , .T. , , .F.,, "aAbastece[oGeraPCBrw:nAt,05]",, .F., .T., , "ETDESPES5"})
        EndIf         
   
        //oDespesBrw:setEditCell( .T. , { || .T. } ) //activa edit and code block for validation
    
        /*
        oDespesBrw:acolumns[2]:ledit     := .T.
        oDespesBrw:acolumns[2]:cReadVar:= 'aDespes[oBrowse:nAt,2]'*/
    
        oGeraPCBrw:Activate(.T.)
    
    Activate MsDialog oDlgGeraPC
 
return .t.
  
Static Function SelectOne(oBrowse, aArquivo)
    aArquivo[oBrowse:nAt,1] := !aArquivo[oBrowse:nAt,1]
    oBrowse:Refresh()
Return .T.
  
Static Function SelectAll(oBrowse, nCol, aArquivo)
    Local _ni := 1
    For _ni := 1 to len(aArquivo)
        aArquivo[_ni,1] := lMarker
    Next
    oBrowse:Refresh()
    lMarker:=!lMarker
Return .T.
 
//Alimenta a tabela temporaria
Static Function fCargaSZB(cCodFor,cLojFor,dDatIni,dDatFim,nOpc)
    Local cQry := ""
    
    cQry      := ""
    aAbastece := {}
    If nOpc == 1
        cQry += " SELECT * FROM " + RetSqlName("SZD")
        cQry += " WHERE D_E_L_E_T_='' AND ZD_NUMPC = ''"
        cQry += " AND ZD_CODFOR ='"+cCodFor+"'" + CRLF
        cQry += " AND ZD_LOJFOR ='"+cLojFor+"'"  + CRLF
        cQry += " AND ZD_DATA >='"+Dtos(dDatIni)+"' AND ZD_DATA <='"+Dtos(dDatFim)+"'"   + CRLF
        cQry:=ChangeQuery(cQry)
        dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry ) , "TMPQRY", .T., .F. )
        TCSetField("TMPQRY","ZD_DATA","D") 
        
        TMPQRY->(DbGoTop())
        While TMPQRY->(!EOF())
            ///             1   2               3                4                 5                6                7                8                    
            aadd(aAbastece,{.f.,TMPQRY->ZD_DATA,TMPQRY->ZD_NUMCE,TMPQRY->ZD_NUMVOO,TMPQRY->ZD_QUANT,TMPQRY->ZD_VUNIT,TMPQRY->ZD_TOTAL,TMPQRY->ZD_CODPRO})
        
            TMPQRY->(dbSkip())
        EndDo
    Else
        cQry += " SELECT ZD_NUMPC,ZD_CODFOR,ZD_LOJFOR,ZD_NOMEFOR,SUM(ZD_TOTAL) AS VALOR FROM " + RetSqlName("SZD")
        cQry += " WHERE D_E_L_E_T_='' AND ZD_NUMPC <> ''"
        cQry += " AND ZD_CODFOR ='"+cCodFor+"'" + CRLF
        cQry += " AND ZD_LOJFOR ='"+cLojFor+"'"  + CRLF
        cQry += " AND ZD_DATA >='"+Dtos(dDatIni)+"' AND ZD_DATA <='"+Dtos(dDatFim)+"'"   + CRLF
        cQry += " GROUP BY ZD_NUMPC,ZD_CODFOR,ZD_LOJFOR,ZD_NOMEFOR "
        cQry += " ORDER BY ZD_NUMPC"
        cQry:=ChangeQuery(cQry)
        dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQry ) , "TMPQRY", .T., .F. )
        
        TMPQRY->(DbGoTop())
        While TMPQRY->(!EOF())
        
            aadd(aAbastece,{.f.,TMPQRY->ZD_NUMPC,TMPQRY->ZD_CODFOR,TMPQRY->ZD_LOJFOR,TMPQRY->ZD_NOMEFOR,TMPQRY->VALOR})
        
            TMPQRY->(dbSkip())
        EndDo
    EndIf
    TMPQRY->(dbCloseArea())
    DbSelectArea('SZD')
    
Return .t.

Static Function fGravaPC(aCE,cCodFor,cLojFor)

    Local aCabec := {}
    Local aItens := {}
    Local nX := 0
    Local cDoc := ""
    Local nOpc := 3

    Private lMsErroAuto := .F.

    ProcRegua(3)

    dbSelectArea("SC7")

    //Teste de Inclusão
    cDoc := GetSXENum("SC7","C7_NUM")
    SC7->(dbSetOrder(1))
    While SC7->(dbSeek(xFilial("SC7")+cDoc))
        ConfirmSX8()
        cDoc := GetSXENum("SC7","C7_NUM")
    EndDo
    
    IncProc("Gerando Número do PC  (1/3)....")

    aadd(aCabec,{"C7_NUM" ,cDoc})
    aadd(aCabec,{"C7_EMISSAO" ,dDataBase})
    aadd(aCabec,{"C7_FORNECE" ,cCodFor})
    aadd(aCabec,{"C7_LOJA" ,cLojFor})
    aadd(aCabec,{"C7_COND" ,"001"})

    For nX := 1 To Len(aCE)
        If aCE[nX,1]
            aLinha := {}
            aadd(aLinha,{"C7_PRODUTO" ,aCE[nX,8],Nil})
            aadd(aLinha,{"C7_QUANT"   ,aCE[nX,5] ,Nil})
            aadd(aLinha,{"C7_PRECO"   ,aCE[nX,6],Nil})
            aadd(aLinha,{"C7_TOTAL"   ,aCE[nX,7] ,Nil})

            // SE O PRODUTO CORRENTE ESTIVER REPETIDO 
            nPos := aScan(aItens, {|x| AllTrim(Upper(x[1,2])) == ALLTRIM(aLinha[1,2])})
            if nPos > 0 .and. aItens[nPos,3,2] == aLinha[3,2]
                // soma as quantidades e total (aglutinar linhas)
                aItens[nPos,2,2] += aLinha[2,2]
                aItens[nPos,4,2] += aLinha[4,2]
            else
                aadd(aItens,aLinha)
            endif

        EndIf
    Next

    IncProc("Gravando Pedido de Compra  (2/3)....")
    MSExecAuto({|u,v,x,y| MATA120(u,v,x,y)},1,aCabec,aItens,nOpc)

    If !lMsErroAuto
        IncProc("Finalizando a gravação  (3/3)....")
        MessageBox("Pedido de Compra "+Alltrim(cDoc)+" gerado com Sucesso!","Atenção",MB_ICONEXCLAMATION)
        DbSelectArea("SZD")
        DbSetOrder(2)
        For nX := 1 To Len(aCE)
            If aCE[nX,1]
                IF SZD->(DbSeek(xFilial("SZD")+aCE[nX,3]))
                    RecLock("SZD",.F.)
                        SZD->ZD_NUMPC := cDoc 
                    SZD->(MsUnLock())
                EndIf
            EndIf
        Next
    Else
        ConOut("Erro na inclusao!")
        MostraErro()
    EndIf
   oDlgGeraPC:End()
Return

Static Function fExcluiPC(aPCs,cCodFor,cLojFor)
    Local nX
    Local cQryUpd,nErro
    Local aCabec := {}
    Local aItens := {}
    Local cDoc := ""
    Local nOpc := 5
    Private lMsErroAuto := .F.

    ProcRegua(3)

    For nX := 1 To Len(aPCs)
        IncProc("Excluindo Pedido de Compra "+aPCs[nX,2])
        If aPCs[nX,1]
            cDoc := aPCs[nX,2]
            aadd(aCabec,{"C7_NUM" ,cDoc})
            //aadd(aCabec,{"C7_EMISSAO" ,dDataBase})
            aadd(aCabec,{"C7_FORNECE" ,cCodFor})
            aadd(aCabec,{"C7_LOJA" ,cLojFor})
            aadd(aCabec,{"C7_COND" ,"001"})

            For nX := 1 To 2
                aLinha := {}

                aadd(aLinha,{"C7_ITEM" ,StrZero(nX,4) ,Nil})
                aadd(aLinha,{"C7_PRODUTO" ,StrZero(nX,4),Nil})
                aadd(aLinha,{"C7_QUANT" ,1 ,Nil})
                aadd(aLinha,{"C7_PRECO" ,150 ,Nil})
                aadd(aLinha,{"C7_TOTAL" ,150 ,Nil})
                aadd(aItens,aLinha)
            Next nX

            MSExecAuto({|u,v,x,y| MATA120(u,v,x,y)},1,aCabec,aItens,nOpc,.F.)

            If !lMsErroAuto
                MessageBox("Pedido de Compra "+Alltrim(cDoc)+" excluido com Sucesso!","Atenção",MB_ICONEXCLAMATION)
                        //Deleta Encomenda
                Begin Transaction
                    cQryUpd := " UPDATE " + RetSqlName("SZD") + " "
                    cQryUpd += " SET ZD_NUMPC = '' "
                    cQryUpd += " WHERE "
                    cQryUpd += "     ZD_FILIAL = '" + FWxFilial('SZD') + "' "
                    cQryUpd += "     AND ZD_NUMPC = '" +  cDoc + "'"
                    cQryUpd += "     AND D_E_L_E_T_ = ' ' "
                    //Tenta executar o update
                    nErro := TcSqlExec(cQryUpd)
                    //Se houve erro, mostra a mensagem e cancela a transação
                    If nErro != 0
                        MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
                        DisarmTransaction()
                    EndIf
                End Transaction
            Else
                Alert("Erro na exclusao!")
                MostraErro()
            EndIf
        EndIf
    Next
   oDlgGeraPC:End()

Return

User Function GTPA05IN()
    Local aArea     := GetArea()
    Private cArqOri := ""
    Private nPosData := 0
    Private nPosProd := 0
    Private nPosLocal := 0
    Private nPosQuant := 0
    Private nPosEnd := 0
    Private nPosLote := 0

    //Mostra o Prompt para selecionar arquivos
    cArqOri := tFileDialog( "CSV files (*.csv) ", 'Seleção de Arquivos', , , .F., )

    If ! Empty(cArqOri)
        If File(cArqOri) .And. Upper(SubStr(cArqOri, RAt('.', cArqOri) + 1, 3)) == 'CSV'
            Processa({|| fImporta() }, "Importando...")
        Else
            MsgStop("Arquivo e/ou extensão inválida!", "Atenção")
        EndIf
    EndIf
    //Se tiver o arquivo de origem
      
    RestArea(aArea)
Return



  
Static Function fImporta()
    Local aArea      := GetArea()
    Local cArqLog    := "zImpCSV_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
    Local nTotLinhas := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 0
    Local aLinha     := {}
    Local oArquivo
    Local aLinhas
    Local lDados := .F.
    Local lAction := .F.
    Local lGrava := .T.
    Local dData,cNroCE,cHora,cNumVoo,cAeronave,cDescAeron,cAeropor,cDAeropor,cAerprox,cDAeroprox,cCombust,cCNPJFor,nQuant,nVunit,nTotal,cCodFor,cLojFor,cNomeFor


    Private cDirLog    := GetTempPath() + "x_importacao\"
    Private cLog       := ""
    Private lMsErroAuto := .F.
    
     
    If ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIf
  
    oArquivo := FWFileReader():New(cArqOri)
      
    If (oArquivo:Open())
  
        If ! (oArquivo:EoF())
  
            aLinhas := oArquivo:GetAllLines()
            nTotLinhas := Len(aLinhas)
            ProcRegua(nTotLinhas)
              
            oArquivo:Close()
            oArquivo := FWFileReader():New(cArqOri)
            oArquivo:Open()

            While (oArquivo:HasLine())
  
                nLinhaAtu++
                IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")
                  
                cLinAtu := oArquivo:GetLine()
                cLinAtu := StrTran(cLinAtu, ";;", ";-;")
                aLinha  := StrTokArr(cLinAtu, ";")
                  
                If lDados
                    ALINHA[10] := STRTRAN(ALINHA[10],".","",1,LEN(ALINHA[10]))
                    ALINHA[11] := STRTRAN(ALINHA[11],".","",1,LEN(ALINHA[11]))
                    ALINHA[12] := STRTRAN(ALINHA[12],".","",1,LEN(ALINHA[12]))
                    ALINHA[10] := STRTRAN(ALINHA[10],",",".",1,LEN(ALINHA[10]))
                    ALINHA[11] := STRTRAN(ALINHA[11],",",".",1,LEN(ALINHA[11]))
                    ALINHA[12] := STRTRAN(ALINHA[12],",",".",1,LEN(ALINHA[12]))
                    dData     := cTod(aLinha[1])
                    cNroCE    := aLinha[2]
                    cHora     := aLinha[3]
                    cNumRes   := aLinha[4]
                    cNumVoo   := IIf(aLinha[5]=='-',;
                                    Posicione('SZ1',3,xFilial('SZ1')+cNumRes+'P','Z1_NUMVIAG'),aLinha[5])
                    cAeronave := aLinha[6]
                    cAeropor  := aLinha[7]
                    cAerprox  := aLinha[8]
                    cCombust  := aLinha[9]
                    cCNPJFor  := aLinha[10]
                    nQuant    := Val(aLinha[11])
                    nVunit    := Val(aLinha[12])
                    nTotal    := Val(aLinha[13])

                    cHora := StrZero(Val(Left(cHora,2)),2)+StrZero(Val(Right(cHora,2)),2)

                    DbSelectArea("SA2")
                    DbsetOrder(3)
                    If DbSeek(FWxFilial("SA2")+cCNPJFor)
                        cCodFor  := SA2->A2_COD
                        cLojFor  := SA2->A2_LOJA
                        cNomeFor := SA2->A2_NOME
                        lGrava   := .T.
                    Else
                        Alert("ERROR - Fornecedor "+cCNPJFor+" não está Cadastrada!")
                        cLog += "- Lin" + cValToChar(nLinhaAtu) + ", Fornecedor "+cCNPJFor+" não está Cadastrada;" + CRLF
                        lGrava := .F. 
                        Loop                  
                    EndIf

                    ST9->(DbSetOrder(1))
                    If ST9->(DbSeek(xFilial("ST9")+cAeronave))
                        cDescAeron := ST9->T9_NOME
                        lGrava := .T.
                    Else
                        Alert("ERROR - Aeronave "+cAeronave+" não está Cadastrada!")
                        cLog += "- Lin" + cValToChar(nLinhaAtu) + ", Aeronave "+cAeronave+" não está Cadastrada;" + CRLF
                        lGrava := .F. 
                        Loop                  
                    EndIf

                    GI1->(DbSetOrder(1))
                    If GI1->(DbSeek(xFilial("GI1")+cAeropor))
                        cDAeropor := GI1->GI1_DESCRI
                        lGrava := .T.
                    Else
                        Alert("ERROR - Aeroporto "+cAeropor+" não está Cadastrada!")
                        cLog += "- Lin" + cValToChar(nLinhaAtu) + ", Aeroporto "+cAeropor+" não está Cadastrada;" + CRLF
                        lGrava := .F. 
                        Loop                  
                    EndIf

                    GI1->(DbSetOrder(1))
                    If GI1->(DbSeek(xFilial("GI1")+cAerprox))
                        cDAeroprox := GI1->GI1_DESCRI
                        lGrava := .T.
                    Else
                        Alert("ERROR - Aeroporto próximo "+cAerprox+" não está Cadastrada!")
                        cLog += "- Lin" + cValToChar(nLinhaAtu) + ", Aeroporto próximo "+cAerprox+" não está Cadastrada;" + CRLF
                        lGrava := .F. 
                        Loop                  
                    EndIf

                    If lGrava
                        DbSelectArea("SZD")
                        DbSetOrder(2)
                        If !Dbseek(xFilial("SZD")+cNroCE)
                            RecLock("SZD",.T.)
                            ZD_FILIAL  := xFilial("SZD")
                            ZD_DATA    := dData
                            ZD_NUMCE   := cNroCE
                            ZD_HORA    := cHora
                            ZD_RESERVA := cNumRes
                            ZD_NUMVOO  := cNumVoo
                            ZD_CODVEI  := cAeronave
                            ZD_DESCVEI := cDescAeron
                            ZD_AEROPOR := cAeropor
                            ZD_DAEROP  := cDAeropor
                            ZD_AERPROX := cAerprox
                            ZD_DAERPRO := cDAeroprox
                            ZD_TPCOMB  := IIF(cCombust=="JET","1","2")
                            ZD_CODPRO  := IIF(cCombust=="JET","00050002","00050003")
                            ZD_CODFOR  := cCodFor
                            ZD_LOJFOR  := cLojFor
                            ZD_NOMEFOR := cNomeFor
                            ZD_QUANT   := nQuant
                            ZD_VUNIT   := nVunit
                            ZD_TOTAL   := Round(nQuant*nVunit,2)
                            MsUnlock()

                        Else
                            Alert("ERROR - CE "+cNroCE+" já existe cadastrado.")
                            cLog += "- Lin" + cValToChar(nLinhaAtu) + ", CE "+cNroCE+" já existe cadastrado;" + CRLF
                            lGrava := .F.                   
                        Endif
                    EndIf
                Else
                    lDados := .T.
                EndIf
            EndDo
  
            If ! Empty(cLog)
                cLog := "Processamento finalizado, abaixo as mensagens de log: " + CRLF + cLog
                
                Aviso("CE Não Importadas", cLog, {"OK"}, 3, "", , "BR_AZUL")

                MemoWrite(cDirLog + cArqLog, cLog)
                ShellExecute("OPEN", cArqLog, "", cDirLog, 1)
            Else
                MessageBox("CEs Importada com sucesso!","",MB_ICONASTERISK)
            EndIf
  
        Else
            MsgStop("Arquivo não tem conteúdo!", "Atenção")
        EndIf
  
        oArquivo:Close()
    Else
        MsgStop("Arquivo não pode ser aberto!", "Atenção")
    EndIf
    RestArea(aArea)
Return

