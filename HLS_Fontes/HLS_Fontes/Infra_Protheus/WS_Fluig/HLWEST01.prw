#Include "Protheus.ch"
#Include "Restful.ch"
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} HLWEST01

Web service responsável pela integração do cadastro de produto Fluig x Protheus

@type   function
@author Ectore Cecato - Totvs IP
@since  24/05/2021

/*/

WsRestful HLWEST01 Description "Integração Cadastro de Produto Fluig"

    WsData  branch      As String   Optional
    WsData  filter      As String   Optional
    WsData  fields      As String   Optional
    WsData  page        As Integer  Optional
    WsData  pageSize    As Integer  Optional
    WsData  id          As String   Optional
    WsData  item        As String   Optional
    WsData  order       As String   Optional
    WsData  type        As String   Optional

    WsMethod POST IncluiProduto ;   
        Description "Inclusão de produto" ;                
        WsSyntax "products" ;              
        Path "products" ;
        Produces APPLICATION_JSON ;
        TTalk "v1"

    WSMETHOD GET UnidadeMedida ;
        Description "Consulta cadastro da unidade de medida" ; 
        WsSyntax "unit_measurement" ;                         
        Path "unit_measurement" ;
        Produces APPLICATION_JSON ;
        TTalk "v1"

    WSMETHOD GET GrupoProduto ;
        Description "Consulta cadastro de grupo de produto" ; 
        WsSyntax "product_group" ;                         
        Path "product_group" ;
        Produces APPLICATION_JSON ;
        TTalk "v1"

    WSMETHOD GET TipoProduto ;
        Description "Consulta cadastro de tipo de produto" ; 
        WsSyntax "product_type" ;                         
        Path "product_type" ;
        Produces APPLICATION_JSON ;
        TTalk "v1"

    WSMETHOD GET Armazem ;
        Description "Consulta cadastro de armazém" ; 
        WsSyntax "warehouse" ;                         
        Path "warehouse" ;
        Produces APPLICATION_JSON ;
        TTalk "v1"

    WSMETHOD GET NCM ;
        Description "Consulta cadastro de NCM" ; 
        WsSyntax "ncm" ;                         
        Path "ncm" ;
        Produces APPLICATION_JSON ;
        TTalk "v1"

    WSMETHOD GET TES ;
        Description "Consulta cadastro de TES" ; 
        WsSyntax "tes" ;                         
        Path "tes" ;
        Produces APPLICATION_JSON ;
        TTalk "v1"        
        
End WsRestful

WsMethod POST IncluiProduto WsService HLWEST01
    
    //Local aHeader   := {}
    //Local aItem     := {}
    //Local aItems    := {}
    Local aError    := {}
    Local lRet      := .T.
    Local cBody     := ""
    //Local cDoc      := ""
    //Local cError    := ""
    //Local nItem     := 0
    Local oRequest  := Nil
	Local oResponse	:= JsonObject():New()
    Local oModel    := Nil

	Private lMsErroAuto		:= .F. //Determina se houve algum tipo de erro durante a execucao do ExecAuto
	Private lMsHelpAuto		:= .T. //Define se mostra ou não os erros na tela (T= Nao mostra; F=Mostra)
	Private lAutoErrNoFile	:= .T. //Habilita a gravacao de erro da rotina automatica

	cBody := Self:GetContent()
    
    ConOut(cBody)

	If FWJsonDeserialize(cBody , @oRequest) 
        
        If FWFilExist(cEmpAnt, oRequest:branch) //aScan(aSM0, {|x| AllTrim(x[2]) == AllTrim(oRequest:branch)}) > 0

            cFilAnt := oRequest:branch
 
            oModel := FwLoadModel ("MATA010")

            oModel:SetOperation(MODEL_OPERATION_INSERT)
            
            oModel:Activate()

            oModel:SetValue("SB1MASTER", "B1_COD",      oRequest:B1_COD)
            oModel:SetValue("SB1MASTER", "B1_DESC",     oRequest:B1_DESC)
            oModel:SetValue("SB1MASTER", "B1_DESCHL",   oRequest:B1_DESCHL)
            oModel:SetValue("SB1MASTER", "B1_DESCNF",   oRequest:B1_DESCNF)
            oModel:SetValue("SB1MASTER", "B1_UM",       oRequest:B1_UM)
            oModel:SetValue("SB1MASTER", "B1_TIPO",     oRequest:B1_TIPO)
            oModel:SetValue("SB1MASTER", "B1_CODMAT2",  oRequest:B1_CODMAT2)
            oModel:SetValue("SB1MASTER", "B1_POSIPI",   oRequest:B1_POSIPI)
            oModel:SetValue("SB1MASTER", "B1_LOCPAD",   oRequest:B1_LOCPAD)
            oModel:SetValue("SB1MASTER", "B1_PROC",     oRequest:B1_PROC)
            oModel:SetValue("SB1MASTER", "B1_GRUPO",    oRequest:B1_GRUPO)
            oModel:SetValue("SB1MASTER", "B1_TE",       oRequest:B1_TE)
            oModel:SetValue("SB1MASTER", "B1_TS",       oRequest:B1_TS)
            oModel:SetValue("SB1MASTER", "B1_QE",       oRequest:B1_QE)
            oModel:SetValue("SB1MASTER", "B1_LADO",     oRequest:B1_LADO)
            oModel:SetValue("SB1MASTER", "B1_PRV1",     oRequest:B1_PRV1)
            oModel:SetValue("SB1MASTER", "B1_PESO",     oRequest:B1_PESO)
            oModel:SetValue("SB1MASTER", "B1_ESTSEG",   oRequest:B1_ESTSEG)
            oModel:SetValue("SB1MASTER", "B1_GARANT",   oRequest:B1_GARANT)
 
            If oModel:VldData()
                
                oModel:CommitData()
                
                oResponse["code"]               := 200
                oResponse["message"]            := EncodeUTF8("Produto incluso com sucesso")
                oResponse["detailedMessage"]    := EncodeUTF8("Produto incluso com sucesso")

            Else
                
                lRet    := .F.
                aError  := oModel:GetErrorMessage()
                
                oResponse["code"]               := 400
                oResponse["message"]            := EncodeUTF8("Erro na inclusão de produto")
                oResponse['detailedMessage']    := EncodeUTF8(AllTrim(aError[MODEL_MSGERR_MESSAGE]) +"/"+ AllTrim(aError[MODEL_MSGERR_SOLUCTION]))
                
                VarInfo("", oModel:GetErrorMessage())

            EndIf       
                
            oModel:DeActivate()
            oModel:Destroy()
            
            oModel := NIL
            
        Else

            lRet := .F.

            oResponse["code"]               := 400
            oResponse["message"]            := EncodeUTF8("Erro na inclusão de produto")
            oResponse['detailedMessage']    := EncodeUTF8("Filial "+ oRequest:branch +" não encontrada")

        EndIf

    Else

        lRet := .F.

        oResponse["code"]               := 400
		oResponse["message"]            := EncodeUTF8("JSON inválido")
        oResponse['detailedMessage']    := EncodeUTF8("JSON inválido")

	EndIf

	If lRet
   		Self:SetResponse(FwJsonSerialize(oResponse))
	Else
		SetRestFault(oResponse['code'], oResponse['message'], .T., oResponse['code'], oResponse['detailedMessage'])
	EndIf

    FreeObj(oResponse)
    FreeObj(oRequest)

Return lRet

WsMethod GET UnidadeMedida WsReceive branch, id, page, pageSize, fields, filter, order WsService HLWEST01
    
    Local cBranch   := ""
    Local cId       := ""
    Local cFields   := ""
    Local cFilter   := ""
    Local cOrder    := ""
    Local cTag      := "items"
    Local cAliasQry := GetNextAlias()
    Local oJson     := JsonObject():New()
    Local oProd     := Nil
    Local nCount    := 0
    Local nSkip     := 0
    Local nField    := 0
    Local nPage     := 0
    Local nPageSize := 0
    Local nTotReg   := 0

    Default Self:page       := 1
    Default Self:pageSize   := 100 
    Default Self:fields     := ""
    Default Self:filter     := ""
    Default Self:order      := "SAH.AH_FILIAL, SAH.AH_UNIMED"
    Default Self:branch     := "01"
    Default Self:id         := ""

    nPage       := Self:page
    nPageSize   := Self:pageSize
    cFields     := If(!Empty(Self:fields), ",", "") + Self:fields 
    cFilter     := Self:filter
    cOrder      := Self:order
    cBranch     := Self:branch
    cId         := Self:id

    cFilAnt := cBranch

    ::SetContentType("application/json")

    cQuery := "SELECT "+ CRLF
    cQuery += "     SAH.AH_FILIAL, SAH.AH_UNIMED, SAH.AH_DESCPO"+ cFields +" "+ CRLF
    cQuery += "FROM "+ RetSqlTab("SAH") +" "+ CRLF
    cQuery += "WHERE "+ CRLF
    cQuery += "     "+ RetSqlDel("SAH") +" "+ CRLF
    cQuery += "     AND "+ RetSqlFil("SAH") +" "+ CRLF

    If !Empty(cId)
        cQuery += "AND SAH.AH_UNIMED = '"+ cId +"' "
    EndIf 

    If !Empty(cFilter)
        cQuery += "AND "+ cFilter +" "
    EndIf

    If !Empty(cOrder)
        
        cQuery += "ORDER BY "
        cQuery += "     "+ cOrder

    EndIf

    cQuery := ChangeQuery(cQuery)

    MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)

    Count To nTotReg
	
    (cAliasQry)->(DbGoTop())

    oJson[cTag] := {}

	IF !(cAliasQry)->(Eof()) 
		
        nSkip := (nPage - 1) * nPageSize

		If nSkip > 0
		    (cAliasQry)->(DbSkip(nSkip))
		EndIf
		
		While ! (cAliasQry)->(Eof()) .And. nCount < nPageSize

			oProd := JsonObject():New()

            For nField := 1 To (cAliasQry)->(FCount())

                cField := (cAliasQry)->(FieldName(nField))
                
                If !cField $ "D_E_L_E_T_|R_E_C_N_O_|R_E_C_D_E_L_"
                    
                    xValue := (cAliasQry)->(FieldGet(FieldPos((cAliasQry)->(FieldName(nField)))))
                    
                    If FWSX3Util():GetFieldType(cField) != "N"
                        xValue := EncodeUTF8(AllTrim(xValue))
                    EndIf

                    oProd[cField] := xValue

                EndIf	 

            Next nField

		    aAdd(oJson[cTag], oProd)
		
		    (cAliasQry)->(DbSkip())
		    
            nCount += 1

		EndDo
		
		If nCount == nPageSize
		    oJson["hasNext"] := .T.
		Else
		    oJson["hasNext"] := .F.
		EndIf
	Else	
		oJson["hasNext"] := .F.
	EndIf

    oJson["totalRegister"]  := nTotReg
    oJson["totalPage"]      := Ceiling(nTotReg / nPageSize)

    (cAliasQry)->(DbCloseArea())

    Self:SetContentType("application/json")
    Self:SetResponse(FwJsonSerialize(oJson))

    FreeObj(oJson)
    
Return .T.

WsMethod GET GrupoProduto WsReceive branch, id, page, pageSize, fields, filter, order WsService HLWEST01

    Local cBranch   := ""
    Local cId       := ""
    Local cFields   := ""
    Local cFilter   := ""
    Local cOrder    := ""
    Local cTag      := "items"
    Local cAliasQry := GetNextAlias()
    Local oJson     := JsonObject():New()
    Local oProd     := Nil
    Local nCount    := 0
    Local nSkip     := 0
    Local nField    := 0
    Local nPage     := 0
    Local nPageSize := 0
    Local nTotReg   := 0

    Default Self:page       := 1
    Default Self:pageSize   := 100
    Default Self:fields     := ""
    Default Self:filter     := ""
    Default Self:order      := "SBM.BM_FILIAL, SBM.BM_GRUPO"
    Default Self:branch     := "01"
    Default Self:id         := ""

    nPage       := Self:page
    nPageSize   := Self:pageSize
    cFields     := If(!Empty(Self:fields), ",", "") + Self:fields 
    cFilter     := Self:filter
    cOrder      := Self:order
    cBranch     := Self:branch
    cId         := Self:id

    cFilAnt := cBranch

    ::SetContentType("application/json")

    cQuery := "SELECT "+ CRLF
    cQuery += "     SBM.BM_FILIAL, SBM.BM_GRUPO, SBM.BM_DESC"+ cFields +" "+ CRLF
    cQuery += "FROM "+ RetSqlTab("SBM") +" "+ CRLF
    cQuery += "WHERE "+ CRLF
    cQuery += "     "+ RetSqlDel("SBM") +" "+ CRLF
    cQuery += "     AND "+ RetSqlFil("SBM") +" "+ CRLF

    If !Empty(cId)
        cQuery += "AND SBM.BM_GRUPO = '"+ cId +"' "
    EndIf 

    If !Empty(cFilter)
        cQuery += "AND "+ cFilter +" "
    EndIf

    If !Empty(cOrder)
        
        cQuery += "ORDER BY "
        cQuery += "     "+ cOrder

    EndIf

    cQuery := ChangeQuery(cQuery)

    MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)

    Count To nTotReg
	
    (cAliasQry)->(DbGoTop())

    oJson[cTag] := {}

	IF !(cAliasQry)->(Eof()) 
		
        nSkip := (nPage - 1) * nPageSize

		If nSkip > 0
		    (cAliasQry)->(DbSkip(nSkip))
		EndIf
		
		While ! (cAliasQry)->(Eof()) .And. nCount < nPageSize

			oProd := JsonObject():New()

            For nField := 1 To (cAliasQry)->(FCount())

                cField := (cAliasQry)->(FieldName(nField))
                
                If !cField $ "D_E_L_E_T_|R_E_C_N_O_|R_E_C_D_E_L_"
                    
                    xValue := (cAliasQry)->(FieldGet(FieldPos((cAliasQry)->(FieldName(nField)))))
                    
                    If FWSX3Util():GetFieldType(cField) != "N"
                        xValue := EncodeUTF8(AllTrim(xValue))
                    EndIf

                    oProd[cField] := xValue

                EndIf	 

            Next nField

		    aAdd(oJson[cTag], oProd)
		
		    (cAliasQry)->(DbSkip())
		    
            nCount += 1

		EndDo
		
		If nCount == nPageSize
		    oJson["hasNext"] := .T.
		Else
		    oJson["hasNext"] := .F.
		EndIf
	Else	
		oJson["hasNext"] := .F.
	EndIf

    oJson["totalRegister"]  := nTotReg
    oJson["totalPage"]      := Ceiling(nTotReg / nPageSize)

    (cAliasQry)->(DbCloseArea())

    Self:SetContentType("application/json")
    Self:SetResponse(FwJsonSerialize(oJson))

    FreeObj(oJson)

Return .T.

WsMethod GET TipoProduto WsReceive branch, id, page, pageSize, fields, filter, order WsService HLWEST01

    Local cBranch   := ""
    Local cId       := ""
    Local cFields   := ""
    Local cFilter   := ""
    Local cOrder    := ""
    Local cTag      := "items"
    Local cAliasQry := GetNextAlias()
    Local oJson     := JsonObject():New()
    Local oProd     := Nil
    Local nCount    := 0
    Local nSkip     := 0
    Local nField    := 0
    Local nPage     := 0
    Local nPageSize := 0
    Local nTotReg   := 0

    Default Self:page       := 1
    Default Self:pageSize   := 100
    Default Self:fields     := ""
    Default Self:filter     := ""
    Default Self:order      := "SX5.X5_FILIAL, SX5.X5_CHAVE"
    Default Self:branch     := "01"
    Default Self:id         := ""

    nPage       := Self:page
    nPageSize   := Self:pageSize
    cFields     := If(!Empty(Self:fields), ",", "") + Self:fields 
    cFilter     := Self:filter
    cOrder      := Self:order
    cBranch     := Self:branch
    cId         := Self:id

    cFilAnt := cBranch

    ::SetContentType("application/json")

    cQuery := "SELECT "+ CRLF
    cQuery += "     SX5.X5_FILIAL, SX5.X5_CHAVE, SX5.X5_DESCRI"+ cFields +" "+ CRLF
    cQuery += "FROM "+ RetSqlTab("SX5") +" "+ CRLF
    cQuery += "WHERE "+ CRLF
    cQuery += "     "+ RetSqlDel("SX5") +" "+ CRLF
    cQuery += "     AND "+ RetSqlFil("SX5") +" "+ CRLF
    cQuery += "     AND SX5.X5_TABELA = '02' "
    If !Empty(cId)
        cQuery += "AND SX5.X5_CHAVE = '"+ cId +"' "
    EndIf 

    If !Empty(cFilter)
        cQuery += "AND "+ cFilter +" "
    EndIf

    If !Empty(cOrder)
        
        cQuery += "ORDER BY "
        cQuery += "     "+ cOrder

    EndIf

    cQuery := ChangeQuery(cQuery)

    MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)

    Count To nTotReg
	
    (cAliasQry)->(DbGoTop())

    oJson[cTag] := {}

	IF !(cAliasQry)->(Eof()) 
		
        nSkip := (nPage - 1) * nPageSize

		If nSkip > 0
		    (cAliasQry)->(DbSkip(nSkip))
		EndIf
		
		While ! (cAliasQry)->(Eof()) .And. nCount < nPageSize

			oProd := JsonObject():New()

            For nField := 1 To (cAliasQry)->(FCount())

                cField := (cAliasQry)->(FieldName(nField))
                
                If !cField $ "D_E_L_E_T_|R_E_C_N_O_|R_E_C_D_E_L_"
                    
                    xValue := (cAliasQry)->(FieldGet(FieldPos((cAliasQry)->(FieldName(nField)))))
                    
                    If FWSX3Util():GetFieldType(cField) != "N"
                        xValue := EncodeUTF8(AllTrim(xValue))
                    EndIf

                    oProd[cField] := xValue

                EndIf	 

            Next nField

		    aAdd(oJson[cTag], oProd)
		
		    (cAliasQry)->(DbSkip())
		    
            nCount += 1

		EndDo
		
		If nCount == nPageSize
		    oJson["hasNext"] := .T.
		Else
		    oJson["hasNext"] := .F.
		EndIf
	Else	
		oJson["hasNext"] := .F.
	EndIf

    oJson["totalRegister"]  := nTotReg
    oJson["totalPage"]      := Ceiling(nTotReg / nPageSize)

    (cAliasQry)->(DbCloseArea())

    Self:SetContentType("application/json")
    Self:SetResponse(FwJsonSerialize(oJson))

    FreeObj(oJson)

Return .T.

WsMethod GET Armazem WsReceive branch, id, page, pageSize, fields, filter, order WsService HLWEST01

    Local cBranch   := ""
    Local cId       := ""
    Local cFields   := ""
    Local cFilter   := ""
    Local cOrder    := ""
    Local cTag      := "items"
    Local cAliasQry := GetNextAlias()
    Local oJson     := JsonObject():New()
    Local oProd     := Nil
    Local nCount    := 0
    Local nSkip     := 0
    Local nField    := 0
    Local nPage     := 0
    Local nPageSize := 0
    Local nTotReg   := 0

    Default Self:page       := 1
    Default Self:pageSize   := 100
    Default Self:fields     := ""
    Default Self:filter     := ""
    Default Self:order      := "NNR.NNR_FILIAL, NNR.NNR_CODIGO"
    Default Self:branch     := "01"
    Default Self:id         := ""

    nPage       := Self:page
    nPageSize   := Self:pageSize
    cFields     := If(!Empty(Self:fields), ",", "") + Self:fields 
    cFilter     := Self:filter
    cOrder      := Self:order
    cBranch     := Self:branch
    cId         := Self:id

    cFilAnt := cBranch

    ::SetContentType("application/json")

    cQuery := "SELECT "+ CRLF
    cQuery += "     NNR.NNR_FILIAL, NNR.NNR_CODIGO, NNR.NNR_DESCRI"+ cFields +" "+ CRLF
    cQuery += "FROM "+ RetSqlTab("NNR") +" "+ CRLF
    cQuery += "WHERE "+ CRLF
    cQuery += "     "+ RetSqlDel("NNR") +" "+ CRLF
    cQuery += "     AND "+ RetSqlFil("NNR") +" "+ CRLF

    If !Empty(cId)
        cQuery += "AND NNR.NNR_CODIGO = '"+ cId +"' "
    EndIf 

    If !Empty(cFilter)
        cQuery += "AND "+ cFilter +" "
    EndIf

    If !Empty(cOrder)
        
        cQuery += "ORDER BY "
        cQuery += "     "+ cOrder

    EndIf

    cQuery := ChangeQuery(cQuery)

    MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)

    Count To nTotReg
	
    (cAliasQry)->(DbGoTop())

    oJson[cTag] := {}

	IF !(cAliasQry)->(Eof()) 
		
        nSkip := (nPage - 1) * nPageSize

		If nSkip > 0
		    (cAliasQry)->(DbSkip(nSkip))
		EndIf
		
		While ! (cAliasQry)->(Eof()) .And. nCount < nPageSize

			oProd := JsonObject():New()

            For nField := 1 To (cAliasQry)->(FCount())

                cField := (cAliasQry)->(FieldName(nField))
                
                If !cField $ "D_E_L_E_T_|R_E_C_N_O_|R_E_C_D_E_L_"
                    
                    xValue := (cAliasQry)->(FieldGet(FieldPos((cAliasQry)->(FieldName(nField)))))
                    
                    If FWSX3Util():GetFieldType(cField) != "N"
                        xValue := EncodeUTF8(AllTrim(xValue))
                    EndIf

                    oProd[cField] := xValue

                EndIf	 

            Next nField

		    aAdd(oJson[cTag], oProd)
		
		    (cAliasQry)->(DbSkip())
		    
            nCount += 1

		EndDo
		
		If nCount == nPageSize
		    oJson["hasNext"] := .T.
		Else
		    oJson["hasNext"] := .F.
		EndIf
	Else	
		oJson["hasNext"] := .F.
	EndIf

    oJson["totalRegister"]  := nTotReg
    oJson["totalPage"]      := Ceiling(nTotReg / nPageSize)

    (cAliasQry)->(DbCloseArea())

    Self:SetContentType("application/json")
    Self:SetResponse(FwJsonSerialize(oJson))

    FreeObj(oJson)

Return .T.

WsMethod GET NCM WsReceive branch, id, page, pageSize, fields, filter, order WsService HLWEST01

    Local cBranch   := ""
    Local cId       := ""
    Local cFields   := ""
    Local cFilter   := ""
    Local cOrder    := ""
    Local cTag      := "items"
    Local cAliasQry := GetNextAlias()
    Local oJson     := JsonObject():New()
    Local oProd     := Nil
    Local nCount    := 0
    Local nSkip     := 0
    Local nField    := 0
    Local nPage     := 0
    Local nPageSize := 0
    Local nTotReg   := 0

    Default Self:page       := 1
    Default Self:pageSize   := 100
    Default Self:fields     := ""
    Default Self:filter     := ""
    Default Self:order      := "SYD.YD_FILIAL, SYD.YD_TEC"
    Default Self:branch     := "01"
    Default Self:id         := ""

    nPage       := Self:page
    nPageSize   := Self:pageSize
    cFields     := If(!Empty(Self:fields), ",", "") + Self:fields 
    cFilter     := Self:filter
    cOrder      := Self:order
    cBranch     := Self:branch
    cId         := Self:id

    cFilAnt := cBranch

    ::SetContentType("application/json")

    cQuery := "SELECT "+ CRLF
    cQuery += "     SYD.YD_FILIAL, SYD.YD_TEC, SYD.YD_DESC_P"+ cFields +" "+ CRLF
    cQuery += "FROM "+ RetSqlTab("SYD") +" "+ CRLF
    cQuery += "WHERE "+ CRLF
    cQuery += "     "+ RetSqlDel("SYD") +" "+ CRLF
    cQuery += "     AND "+ RetSqlFil("SYD") +" "+ CRLF

    If !Empty(cId)
        cQuery += "AND SYD.YD_TEC = '"+ cId +"' "
    EndIf 

    If !Empty(cFilter)
        cQuery += "AND "+ cFilter +" "
    EndIf

    If !Empty(cOrder)
        
        cQuery += "ORDER BY "
        cQuery += "     "+ cOrder

    EndIf

    cQuery := ChangeQuery(cQuery)

    MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)

    Count To nTotReg
	
    (cAliasQry)->(DbGoTop())

    oJson[cTag] := {}

	IF !(cAliasQry)->(Eof()) 
		
        nSkip := (nPage - 1) * nPageSize

		If nSkip > 0
		    (cAliasQry)->(DbSkip(nSkip))
		EndIf
		
		While ! (cAliasQry)->(Eof()) .And. nCount < nPageSize

			oProd := JsonObject():New()

            For nField := 1 To (cAliasQry)->(FCount())

                cField := (cAliasQry)->(FieldName(nField))
                
                If !cField $ "D_E_L_E_T_|R_E_C_N_O_|R_E_C_D_E_L_"
                    
                    xValue := (cAliasQry)->(FieldGet(FieldPos((cAliasQry)->(FieldName(nField)))))
                    
                    If FWSX3Util():GetFieldType(cField) != "N"
                        xValue := EncodeUTF8(AllTrim(xValue))
                    EndIf

                    oProd[cField] := xValue

                EndIf	 

            Next nField

		    aAdd(oJson[cTag], oProd)
		
		    (cAliasQry)->(DbSkip())
		    
            nCount += 1

		EndDo
		
		If nCount == nPageSize
		    oJson["hasNext"] := .T.
		Else
		    oJson["hasNext"] := .F.
		EndIf
	Else	
		oJson["hasNext"] := .F.
	EndIf

    oJson["totalRegister"]  := nTotReg
    oJson["totalPage"]      := Ceiling(nTotReg / nPageSize)

    (cAliasQry)->(DbCloseArea())

    Self:SetContentType("application/json")
    Self:SetResponse(FwJsonSerialize(oJson))

    FreeObj(oJson)

Return .T.

WsMethod GET TES WsReceive branch, id, page, pageSize, fields, filter, order, type WsService HLWEST01

    Local cBranch   := ""
    Local cId       := ""
    Local cFields   := ""
    Local cFilter   := ""
    Local cOrder    := ""
    Local cType     := ""
    Local cTag      := "items"
    Local cAliasQry := GetNextAlias()
    Local oJson     := JsonObject():New()
    Local oProd     := Nil
    Local nCount    := 0
    Local nSkip     := 0
    Local nField    := 0
    Local nPage     := 0
    Local nPageSize := 0
    Local nTotReg   := 0

    Default Self:page       := 1
    Default Self:pageSize   := 100
    Default Self:fields     := ""
    Default Self:filter     := ""
    Default Self:order      := "SF4.F4_FILIAL, SF4.F4_CODIGO"
    Default Self:branch     := "01"
    Default Self:id         := ""
    Default Self:type       := ""

    nPage       := Self:page
    nPageSize   := Self:pageSize
    cFields     := If(!Empty(Self:fields), ",", "") + Self:fields 
    cFilter     := Self:filter
    cOrder      := Self:order
    cBranch     := Self:branch
    cId         := Self:id
    cType       := Self:type

    cFilAnt := cBranch

    ::SetContentType("application/json")

    cQuery := "SELECT "+ CRLF
    cQuery += "     SF4.F4_FILIAL, SF4.F4_CODIGO, SF4.F4_TEXTO"+ cFields +" "+ CRLF
    cQuery += "FROM "+ RetSqlTab("SF4") +" "+ CRLF
    cQuery += "WHERE "+ CRLF
    cQuery += "     "+ RetSqlDel("SF4") +" "+ CRLF
    cQuery += "     AND "+ RetSqlFil("SF4") +" "+ CRLF

    If Upper(cType) == "ENTRADA"
        cQuery += "     AND SF4.F4_CODIGO <= '500' "
    ElseIf Upper(cType) == "SAIDA"
        cQuery += "     AND SF4.F4_CODIGO > '500' "
    EndIf 

    If !Empty(cId)
        cQuery += "AND SF4.F4_CODIGO = '"+ cId +"' "
    EndIf 

    If !Empty(cFilter)
        cQuery += "AND "+ cFilter +" "
    EndIf

    If !Empty(cOrder)
        
        cQuery += "ORDER BY "
        cQuery += "     "+ cOrder

    EndIf

    cQuery := ChangeQuery(cQuery)

    MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)

    Count To nTotReg
	
    (cAliasQry)->(DbGoTop())

    oJson[cTag] := {}

	IF !(cAliasQry)->(Eof()) 
		
        nSkip := (nPage - 1) * nPageSize

		If nSkip > 0
		    (cAliasQry)->(DbSkip(nSkip))
		EndIf
		
		While ! (cAliasQry)->(Eof()) .And. nCount < nPageSize

			oProd := JsonObject():New()

            For nField := 1 To (cAliasQry)->(FCount())

                cField := (cAliasQry)->(FieldName(nField))
                
                If !cField $ "D_E_L_E_T_|R_E_C_N_O_|R_E_C_D_E_L_"
                    
                    xValue := (cAliasQry)->(FieldGet(FieldPos((cAliasQry)->(FieldName(nField)))))
                    
                    If FWSX3Util():GetFieldType(cField) != "N"
                        xValue := EncodeUTF8(AllTrim(xValue))
                    EndIf

                    oProd[cField] := xValue

                EndIf	 

            Next nField

		    aAdd(oJson[cTag], oProd)
		
		    (cAliasQry)->(DbSkip())
		    
            nCount += 1

		EndDo
		
		If nCount == nPageSize
		    oJson["hasNext"] := .T.
		Else
		    oJson["hasNext"] := .F.
		EndIf
	Else	
		oJson["hasNext"] := .F.
	EndIf

    oJson["totalRegister"]  := nTotReg
    oJson["totalPage"]      := Ceiling(nTotReg / nPageSize)

    (cAliasQry)->(DbCloseArea())

    Self:SetContentType("application/json")
    Self:SetResponse(FwJsonSerialize(oJson))

    FreeObj(oJson)

Return .T.
