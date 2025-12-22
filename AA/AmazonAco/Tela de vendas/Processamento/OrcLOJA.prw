#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include "RestFul.CH"

User Function AALOJP90()	
   /*
   ujd = GetData("000374","20200801","20210304",{"01","05"})
   conout(ujd)
   ujd := GetDataPedido("047318","000374",{"01","05"})//
   conout(ujd)
   */
   RpcClearEnv()
   RpcSetEnv('01','04',,,"LOJA","LOJA701",{"SL1","SL2","SLR","SLQ","SD2","SF2","SL4"})
   /*
   xdBody := '{"CLIENTE":"005740","LOJA":"01","CONDPAGAMENGO":"001","VENDEDOR":"000002","LQ_DESCONT":0,"LQ_ENDENT":"AV.TOQUATO TAPAJOS N.7900","LQ_BAIRROE":"","LQ_MUNE":"","LQ_ESTE":"","Recebedor":"","Telefone":"","Complemento":"","Observacao":"","LQ_ENTREGA":"N"'
   xdBody += ',"ITENS":[
       xdBody += ' {"Empresa":"01","LR_PRODUTO":"02000010","LR_DESCRI":"BARRA CHATA 1/2POL  SERRALHEIRO","LR_QUANT":4,"LR_VRUNIT":16.2,"LR_VLRITEM":64.8,"Peso":1}'
       xdBody += ']'
   xdBody += ',"PAGAMENTO":[{"L4_FORMA":"R$","L4_VALOR":64.8}]}'
   */
   //xBody := '{"Empresa":"01","Filial":"04","CLIENTE":"066131","LOJA":"01","CONDPAGAMENGO":"001","VENDEDOR":"000083","LQ_VLRTOT":69.99,"LQ_DESCONT":0,"LQ_VLRLIQ":69.99,"LQ_DINHEIR":69.99,"Observacao":"","LQ_ENTREGA":"S","LQ_ENDENT":"AV: TORQUATO TAPAJOS 11901","LQ_BAIRROE":"TARUMA ACU","LQ_MUNE":"MANAUS","LQ_ESTE":"AM","Recebedor":".","Telefone":"98126-0229","Complemento":"","ITENS":[{"EmpresaFilial":"IND ALVORADA","Empresa":"01","Filial":"04","LR_PRODUTO":"48000350","LR_DESCRI":"PERFIL U 25 X 25 X 2.00 X 6.000 (6,71)","LR_QUANT":1,"LR_UM":"PC","LR_VRUNIT":69.99,"LR_VLRITEM":69.99,"LR_ENTREGA":"3","Peso":1}],"PAGAMENTO":[{"L4_FORMA":"R$","L4_VALOR":69.99,"L4_ADMINIS":"","L4_NUMCART":"","L4_FORMAID":"","L4_MOEDA":0,"Parcelas":1,"ValorParcela":69.99}]}'
   //xBody := '{"Empresa":"01","Filial":"04","CLIENTE":"066131","LOJA":"01","VENDEDOR":"000083","LQ_DESCONT":0,"Observacao":"","LQ_ENTREGA":"S","LQ_ENDENT":"AV: TORQUATO TAPAJOS 11901","LQ_BAIRROE":"TARUMA ACU","LQ_MUNE":"MANAUS","LQ_ESTE":"AM","Recebedor":".","Telefone":"98126-0229","Complemento":"","ITENS":[{"EmpresaFilial":"IND ALVORADA","Empresa":"01","Filial":"04","LR_PRODUTO":"48000350       ","LR_DESCRI":"PERFIL U 25 X 25 X 2.00 X 6.000 (6,71)                           ","LR_QUANT":1,"LR_UM":"PC","LR_VRUNIT":69.99,"LR_VLRITEM":69.99,"LR_ENTREGA":"3","Peso":1}],"PAGAMENTO":[{"L4_DATA":"20210912","L4_FORMA":"CC","L4_VALOR":34.99,"L4_ADMINIS":"","L4_NUMCART":"","L4_FORMAID":"","Parcelas":1,"ValorParcela":34.99},{"L4_DATA":"20211012","L4_FORMA":"CC","L4_VALOR":35,"L4_ADMINIS":"","L4_NUMCART":"","L4_FORMAID":"","Parcelas":1,"ValorParcela":35}]}'
   //xBody := '{"NomeEmpresa":"IND ALVORADA","Empresa":"01","Filial":"04","LQ_XNUMOS":"*","USERNAME":"david.praia","CODUSER":"000626","CLIENTE":"066131","LOJA":"01","CONDPAGAMENGO":"001","VENDEDOR":"000083","LQ_DESCONT":0,"Observacao":"","LQ_ENTREGA":"S","LQ_ENDENT":"AV: TORQUATO TAPAJOS 11901","LQ_BAIRROE":"TARUMA ACU","LQ_MUNE":"MANAUS","LQ_ESTE":"AM","Recebedor":",","Telefone":"98126-0229","Complemento":"","ITENS":[{"EmpresaFilial":"IND ALVORADA","Empresa":"01","Filial":"04","LR_PRODUTO":"48000350       ","LR_DESCRI":"PERFIL U 25 X 25 X 2.00 X 6.000 (6,71)                           ","LR_QUANT":2,"LR_UM":"PC","LR_VRUNIT":69.9853,"LR_VALDESC":9.97,"LR_VLRITEM":139.97,"LR_ENTREGA":"3","Peso":1,"BM_XEXIGOS":"N"}],"PAGAMENTO":[],"tentativas":0}'
   xBody := '{"NomeEmpresa":"IND ALVORADA","Empresa":"01","Filial":"04","LQ_XNUMOS":"*","USERNAME":"david.praia","CODUSER":"000626","CLIENTE":"066131","LOJA":"01","CONDPAGAMENGO":"","VENDEDOR":"000083","LQ_DESCONT":0,"LQ_ENTREGA":"S","LQ_ENDENT":".","LQ_BAIRROE":".","LQ_MUNE":"MANAUS","LQ_ESTE":"AM","LQ_OBSENT2":"","LQ_OBSENT3":"","LQ_OBSENT4":"","LQ_RECENT":"","LQ_FONEENT":"98126-0229","LQ_REFEREN":"N","LQ_OBSERV":"","LQ_TPFRET":"","LQ_XORCORI":"      ","ITENS":[{"EmpresaFilial":"IND ALVORADA","Empresa":"01","Filial":"04","LR_UM":"KG","LR_UM2":"PC","LR_PRODUTO":"47000302       ","LR_DESCRI":"TUBO QUADRADO (METALON) 70 X 70 X 2.00 X 6.000 FQ (NAC)                                             ","LR_QUANT":53.68,"LR_QUANT2":2,"LR_VRUNIT":10.71,"LR_VLRITEM":574.9128000000001,"LR_VLRITEMLIQ":574.9128000000001,"LR_ENTREGA":"3","LR_VALDESC":0,"LR_TES":"704","Peso":0,"BM_XEXIGOS":"N","focus":0,"focusDesc":0,"ICMS":0,"index":0}],"PAGAMENTO":[{"L4_FORMA":"R$","L4_VALOR":574.91,"ValorBruto":574.91,"L4_DATA":"20210825","Parcelas":1,"ValorParcela":574.91,"ValorBrutoParcela":574.91}],"valorTotal":574.91,"tentativas":0}'
   //xRet := _Post(xBody)
   xRet := _Post(xBody,'828525')
   ConOUt(xRet:ToJson())
   xdf := xRet:ToJson()

Return

WSRESTFUL LOJA DESCRIPTION "Servico para listagem de pedidos de compras a serem aprovados"

WsData Empresa As CHARACTER
WsData Filial  AS CHARACTER
WsData CodCliente AS CHARACTER
WsData Loja    AS CHARACTER
WsData Produto    AS CHARACTER
WsData Solidario    AS CHARACTER
WsData Quantidade    AS Float
WsData Desconto    AS Float

WSMETHOD GET DESCRIPTION "Pegar Informações do Orcametno" WSSYNTAX "/LOJA" 
WSMETHOD POST DESCRIPTION "Inclusao de Orcamentos LOJA" WSSYNTAX "/LOJA" 
WSMETHOD PUT DESCRIPTION "Alteracao de Orcamentos LOJA" WSSYNTAX "/LOJA" 

WSMETHOD GET ID_FISCAL DESCRIPTION ("Retorna informações da Filial solicitada.")  PATH "/FISCAL/{Empresa}/{Filial}" PRODUCES APPLICATION_JSON

END WSRESTFUL

WSMETHOD GET ID_FISCAL PATHPARAM Empresa,Filial;
                      QUERYPARAM Empresa,Filial,CodCLiente,Loja,Produto,Quantidade, Solidario WSREST LOJA

   If Empty(Self:Empresa)
      SetRestFault(400, EncodeUtf8( "Parametro 01(Empresa) não informado!"))
      return .F.
   EndIf

   If Empty(Self:Filial)
      SetRestFault(400, EncodeUtf8( "Parametro 02(Filial) não informado!"))
      return .F.
   EndIf

   If Empty(Self:CodCLiente)
      SetRestFault(400, EncodeUtf8( "Parametro 03(CodCLiente) não informado!"))
      return .F.
   EndIf
   If Empty(Self:Loja)
      SetRestFault(400, EncodeUtf8( "Parametro 04(Loja) não informado!"))
      return .F.
   EndIf
   If Empty(Self:Produto)
      SetRestFault(400, EncodeUtf8( "Parametro 05(Produto) não informado!"))
      return .F.
   EndIf
   If Empty(Self:Quantidade)
      SetRestFault(400, EncodeUtf8( "Parametro 06(Quantidade) não informado!"))
      return .F.
   EndIf

   //DEFAULT Solidario := "N"
   //Default Desconto := 0
   if Self:Desconto == Nil
     Self:Desconto := 0
   EndIf
   if Self:Solidario == Nil
     Self:Solidario := "N"
   EndIf

   ConOut("Empresa => " + Self:Empresa)
   ConOut("Filial => " + Self:Filial)
   ConOut("CodCLiente => " + Self:CodCLiente)
   ConOut("Loja => " + Self:Loja)
   ConOut("Produto => " + Self:Produto)
   ConOut("Quantidade => " + Str(Self:Quantidade))
   ConOut("DEsconto => " + Str(Self:Desconto))
   ConOut("Solidario => " + Self:Solidario)


   RpcSetEnv(Self:Empresa,Self:Filial)

   ad := _GetValores(Self:CodCliente,Self:Loja,Self:Produto,Self:Quantidade,self:Desconto,Self:Solidario)
   ::SetResponse(ad)

Return .t.
WSMETHOD PUT WSSERVICE LOJA
  Local cBody := ::GetContent()
  Local oRet := JsonObject():New()
  Local xx   := Len(::AURLPARMS)
  Local xEmp 	:= iIf(xx > 0, ::AURLPARMS[1], "")
  Local xFil 	:= iIf(xx > 1, ::AURLPARMS[2], "")
  Local xOrc 	:= iIf(xx > 2, ::AURLPARMS[3], "")
  
  private lError := .F.
  private xError := ""
  oError := ErrorBlock({|e| lError := .T., xError := e:Description })

  conout("URL PUT: " + xEmp + xFil + xOrc)
  
  oRet["succeeded"] := .F.
  oRet["errors"] := {}
  if Empty(xEmp) .Or. Empty(xFil)
     oRet["succeeded"] := .F.
     oRet["errors"] := {}
     oRet := AddError(oRet, "LOJA001","Empresa / Filial em branco")
  Else
    RpcClearEnv()	
    RpcSetEnv(xEmp, xFil,,,,,{"SL1","SL2","SLR","SLQ","SD2","SF2","SL4"})
    ::SetContentType("application/json")
    //ConOUt("Emit NFCE?")
    //lDD := LjEmitNFCe()
    //ConOUt(lDD)
    //ConOUt( iIF(lDD,"SIM","NAO"))

    //begin sequence
    ConOUt("On Put")
    ConOut("PUT - Json Enviado => " +  cBody )
    oRet := _Post(cBody,xOrc)
    /*RECOVER
       ConOUt("On Recover?")       
       ConOUt("On Recover 01?")
       conout(xError)
       ConOUt("On Recover 02?")
       conout(oError:Description)
       */
       /*
    end sequence
    ConOUt("Before ErrorBlock")
    ErrorBlock(oError)
    ConOUt("After ErrorBlock")
    conout(lError)
    if lError
       ConOUt("On Recover 03?")
       conout(xError)
       ConOUt("On Recover 04?")
       oRet := AddError(oRet, "LOJA001",xError)
    Endif
    */
    conout(oRet:ToJson())
  EndIf
  ::SetResponse(oRet:ToJson())
  RpcClearEnv()
return (.T.)

WSMETHOD POST WSSERVICE LOJA
  Local cBody := ::GetContent()
  Local oRet := JsonObject():New()
  Local xx   := Len(::AURLPARMS)
  Local xEmp 	:= iIf(xx > 0, ::AURLPARMS[1], "")
  Local xFil 	:= iIf(xx > 1, ::AURLPARMS[2], "")
  
  oRet["succeeded"] := .F.
  oRet["errors"] := {}
  if Empty(xEmp) .Or. Empty(xFil)
     oRet["succeeded"] := .F.
     oRet["errors"] := {}
     oRet := AddError(oRet, "LOJA001","Empresa / Filial em branco")
  Else
   ConOut("Inside Post")
   ConOut("Empresa: " + xEmp)
   ConOut("Filial: " + xFil)
	ConOut("Preparando Ambiente")
    
	RpcClearEnv()
	RpcSetEnv(xEmp, xFil,,,,,{"SL1","SL2","SLR","SLQ","SD2","SF2","SL4"})
	
	ConOut("Check Ambiente")
	ConOut("Empresa: " + FwCodEmp())
   ConOut("Filial: " + FwCodFil())
	
	ConOut("Json Enviado => " +  cBody )
	
    ::SetContentType("application/json")
    
    ConOUt("Emit NFCE?")
    lDD := LjEmitNFCe()
    ConOUt(lDD)
    ConOUt( iIF(lDD,"SIM","NAO"))

    oRet := _Post(cBody, "")
    conout(oRet:ToJson())
  EndIf
  ::SetResponse(oRet:ToJson())
  RpcClearEnv()
return (.T.)


Static Function _GetValores(xdCliente,xdLoja,xdProduto,xdQuantidade,xdDesconto,xdSol)
   Local xdTES := "704"
   Local xdValor := 0
   Local ndTotIcms := 0
   Local nVlrItem := 0
   //Local xdDesconto := 0
   //Local xdDesconto := 0
   SA1->(DbSetOrder(1))
   SA1->(dbSeek(xFilial('SA1') + xdCliente + xdLoja))

   SB1->(DbSetOrder(1))
   SB1->(dbSeek(xFilial('SB1') + xdProduto))
   
   SB0->(DbSetOrder(1))
   SB0->(dbSeek(xFilial('SB0') + SB1->B1_COD))

   If xdSol != "S"
      xdTes := SB1->B1_TS
   EndIf
   ConOut("TES => " + xdTes)

   xdValor := SB0->B0_PRV1
   xdVlrItem := A410Arred(xdValor * xdQuantidade, "LR_VLRITEM")

   If .T.//!MaFisFound("NF")
         MaFisIni( SA1->A1_COD, SA1->A1_LOJA, "C" , "S" , ;
		          NIL          , NIL        , NIL , .F., ;
		          "SB1"        , "LOJA701"  )

         MaFisAdd( xdProduto,;			// Produto
				xdTES,;					// Tes
				xdQuantidade,;		// Quantidade
				xdValor,;		// Preco unitario
				xdDesconto,;		// Valor do desconto
				"",; 						// Numero da NF original
				"",; 						// Serie da NF original
				0,;							// Recno da NF original
				0,; 						// Valor do frete do item
				0,; 						// Valor da despesa do item
				0,; 						// Valor do seguro do item
				0,; 					   // Valor do frete autonomo
				xdVlrItem,;		// Valor da mercadoria
				0 )

      nVlrItem := MaFisRet( 1, "IT_TOTAL" )//If( MaFisFound("IT",n), MaFisRet( n, "IT_TOTAL" ), 0 ) 
      ndTotIcms := MaFisRet(1,"IT_VALSOL")
      MaFisEnd()
   EndIf

Return {nVlrItem,ndTotIcms}


Static Function _Post(xJson,xNumOrc)
   Local oJson := JsonObject():New()
   Local xRet  := ""
   Local aCabec := {}
   Local aItens := {}
   Local aParcelas := {}
   Local xdCodUsr := ""
   Local xdUserName := ""
   Local _cCond := ""
   
   Default xNumOrc := ""

   Private oRet  := JsonObject():New()
   Private lMsHelpAuto := .T. //Variavel de controle interno do ExecAuto
   Private lMsErroAuto := .F. //Variavel que informa a ocorrência de erros no ExecAuto
   Private INCLUI := .T. //Variavel necessária para o ExecAuto identificar que se trata de uma inclusão
   Private ALTERA := .F. //Variavel necessária para o ExecAuto identificar que se trata de uma inclusão
   

   /*
   _cVendedor := "000001" //Codigo do Vendedor
   _cCodCli := "001243" //Codigo do Cliente
   _cCodLoja := "01" //Codigo da Loja do Cliente
   */
   oRet["succeeded"] := .T.
   oRet["numOrcamento"] := ""
   oRet["errors"] := {}

   xRet := oJson:FromJson(xJson)
   if ValType(xRet) == "C"
      AddError(oRet, "LOJA000",xRet)
   EndIf

   If(oRet["succeeded"] )
      aCabec := GetCabec(oJson,xNumOrc)
   EndIf
   _cCond  := oJson:GetJsonText("CONDPAGAMENGO")

   If(oRet["succeeded"] )
     aItens := GetItens(oJson,SA3->A3_COD, Empty(xNumOrc) )
     if Len(aItens) == 0
        AddError(oRet, "LOJA001","Itens Não Enviado")
     EndIf
   EndIf
   
   If(oRet["succeeded"] )
     aParcelas := GetPagamento(oJson)
     if Len(aParcelas) == 0 .And. Empty(_cCond)
        AddError(oRet, "LOJA001","Pagamento Não Enviado")
     elseIf Len(aParcelas) == 0 .And. !Empty(_cCond)
        ConOut('Condicao de pagamento' + _cCond)
        ConOut('Calculando Parcelas para o valor: ' + Str(oJson["valorTotal"]) )
        // aParcelas := GetParcelas(_cCond, oJson["valorTotal"])
     EndIf
   EndIf

   If(oRet["succeeded"] )
    
     xdCaixa := xNumCaixa()
     xdLojErro := LJGetProfile("LOGERRO")

     ConOut("Old UserId => " + __cUserId)
     ConOut("Old UserName => " + cUserName)
     ConOUt("Old xNumCaixa => " + iIf(xdCaixa==Nil, "Nil", xdCaixa )  )
     ConOUt("Old LOGERRO => " +  iIf(xdLojErro==Nil, "Nil", xdLojErro ) )

     xdUserName:=  oJson["USERNAME"]
     xdCodUsr :=  oJson["CODUSER"]

     __cUserId := iIf(xdCodUsr==Nil,"",xdCodUsr)
     cUserName := iIf(xdUserName==Nil,"",xdUserName)
     ConOut("New UserId => " + __cUserId)
     ConOut("New UserName => " + cUserName)
     ConOUt("New xNumCaixa => " + iIf(xdCaixa==Nil, "Nil", xdCaixa )  )
     ConOUt("New LOGERRO => " +  iIf(xdLojErro==Nil, "Nil", xdLojErro ) )

     xdCaixa := xNumCaixa()
     xdLojErro := LJGetProfile("LOGERRO")


     SetFunName("LOJA701")

     xOpc := iIf( Empty(xNumOrc),3,4)
     xdCaixa := xNumCaixa()
     xdLojErro := LJGetProfile("LOGERRO")
     
     ConOUt("Opx => "+StrZero(xOpc,1))
     
     if !Empty(xNumOrc)
        ConOUt("Cleaning MFT before Update on LOJA701")
        CleanMFT(xNumOrc)
     EndIf
     lMsErroAuto := .F.
     lMsHelpAuto := .T.
     MSExecAuto({|a,b,c,d,e,f,g,h| Loja701(a,b,c,d,e,f,g,h)},.F.,xOpc,"","",{},aCabec,aItens ,aParcelas)

     If lMsErroAuto
       //Alert("Erro no ExecAuto")
       cMsgErro := MostraErro("\","Error.log")
       //DisarmTransaction()
       //if("Atencao"$cMsgErro .And. "Este Orcamento Ser"$cMsgErro .And. "Bloqueado")
       AddError(oREt,"LOJA003",cMsgErro)
       //Alert(cMsgErro)
     Else
        oRet["succeeded"] := .T.
        if Empty(xNumOrc)
           oRet["mensagem"] := "Orcamento Gerado : " + SL1->L1_NUM
           oRet["numOrcamento"] := SL1->L1_NUM
           lCredito := .F.
           if Left(SL1->L1_XBLQORC,1)=="C"
              oRet["mensagem"] += ", Bloqueado Por Credito"
              lCredito := .T.
           EndIf
           if Right(SL1->L1_XBLQORC,1)=="D"
              oRet["mensagem"] += iif(lCredito," | Desconto",", Bloqueado Por Desconto")
           EndIf
        Else
           oRet["mensagem"] := "Orcamento Alterado Com Sucesso " 
        EndIf
       //sAlert("Sucesso na execução do ExecAuto")
     EndIf
   EndIf
Return oRet
/*
Static Function ValidCabec(oJson)

Return oRet
*/
Static Function GetItens(oJson, cVendedor, ldInclui)
  Local aItens := {}
  Local II
  Local adItens := oJson["ITENS"]

  For II := 01 To Len(adItens)
     aAdd(aItens, AddItem(adItens[II], cVendedor, ldInclui ))
  Next
Return aItens

Static Function GetParcelas(xdCond, xValor)
  
  Local aArr :=Condicao(xValor, xdCond, 0, dDatabase, 0)
  Local I
  Local lSE4
  Local aParcelas := {}

  SE4->(DbSetOrder(1))
  lSE4 := SE4->(dbSeek(xFilial('SE4') + xdCond))
  ConOut("Achou SE4 => " + iIf(lSE4,"SIM","NAO") )
  ConOut("E4_FORMA => " + SE4->E4_FORMA)
  For I := 01 To Len(aArr)
     ConOUt("Adicionando SL4 com valor : " + Transform(aArr[I][02],"@E 999,999,999.9999") + "e data " + DTOC(aArr[I][01]) )
     aAdd(aParcelas, AddPagamento(SE4->E4_FORMA, aArr[I][02], aArr[I][01] )  )
  Next

Return aParcelas

Static Function AddPagamento(xForma, xdValor, xdData)
   Local aItem := {}

   aAdd(aItem,{ "L4_DATA", xdData , NIl })
   aAdd(aItem,{ "L4_VALOR",  xdValor , NIl })
   aAdd(aItem,{ "L4_FORMA",  xForma , NIl })
   aAdd(aItem,{ "L4_ADMINIS",  " " , NIl })
   aAdd(aItem,{ "L4_NUMCART",  " " , NIl })
   aAdd(aItem,{ "L4_FORMAID",  " " , NIl })
   aAdd(aItem,{ "L4_MOEDA",  " " , NIl })

Return aItem


Static Function GetPagamento(oJson)
  Local aPag := {}
  Local II := 0

  Local adItens := oJson["PAGAMENTO"]

  For II := 01 To Len(adItens)
    aAdd(aPag, AddPag(adItens[II]))
  Next

Return aPag

Static Function AddPag(oJson)
//  Local xName
  Local aItem := {}
  //Local names := oJson:GetNames()
  //Local OO

  aAdd(aItem,{ "L4_DATA", stod(oJson["L4_DATA"]) , NIl })
  aAdd(aItem,{ "L4_VALOR",  oJson["L4_VALOR"] , NIl })
  aAdd(aItem,{ "L4_FORMA",  oJson["L4_FORMA"] , NIl })
  aAdd(aItem,{ "L4_ADMINIS",  oJson["L4_ADMINIS"] , NIl })
  aAdd(aItem,{ "L4_NUMCART",  oJson["L4_NUMCART"] , NIl })
  aAdd(aItem,{ "L4_FORMAID",  oJson["L4_FORMAID"] , NIl })
  aAdd(aItem,{ "L4_MOEDA",  oJson["L4_MOEDA"] , NIl })
  /*
  For OO := 1 To Len(names)
    xname := Alltrim( names[OO] )
    if xName == "L4_DATA"
      if Left(xName,3)== "L4_"
        aAdd(aItem,{ names[OO], oJson[names[OO]] , NIl })
      Endif
    EndIf
  Next
  */
  
Return aItem

Static Function AddItem(oJson, cVendedor, ldInclui)
  Local aItem := {}
  Local xName
  Local names := oJson:GetNames()
  Local OO
  Local nTamProd := TamSX3("LR_PRODUTO")[1]
  //Local nTamUM := TamSX3("LR_UM")[1]
  Local nTamTabela := TamSX3("LR_TABELA")[1]
  Local xx := .T.
  Local xProduto := Padr(oJson["LR_PRODUTO"],nTamProd)
  Local xQuant := oJson["LR_QUANT"]
  // Local xQuant1 := 0

  SB1->(dbSetOrder(1))
  SB1->(dbSeek(xFilial('SB1') + xProduto))

  SB0->(DbSetOrder(1))
  SB0->(dbSeek(xFilial('SB0') + SB1->B1_COD ))
  
  xQuant1 := ConvUm(SB1->B1_COD,0,xQuant,1)
  if xQuant1 == 0
     xQuant1 := xQuant
  EndIf
  
  aAdd( aItem, {"LR_PRODUTO", xProduto , NIl })
  //aAdd( aItem, {"LR_QUANT", xQuant1 , NIl })
  //aAdd( aItem, {"LR_QUANT", xQuant1 , NIl })
  
  if SB1->B1_SEGUM == oJson["LR_UM"]
     aAdd( aItem, {"LR_QUANT", xQuant1 , NIl })
  Else
     aAdd( aItem, {"LR_QUANT", xQuant , NIl })
  EndIf
  
  aAdd( aItem, {"LR_UM", SB1->B1_UM , NIl })
  aAdd( aItem, {"LR_TABELA" , PadR("1",nTamTabela) , NIL} )

  if !ldInclui
     aAdd( aItem, {"LR_VRUNIT", SB0->B0_PRV1 , NIl })
     aAdd( aItem, {"LR_PRCTAB", SB0->B0_PRV1 , NIl })
  Endif
  //aAdd( aItem, {"LR_DESC" , 0 , NIL} )
  //aAdd( aItem, {"LR_VALDESC", 0 , NIL} )
  
  //aAdd( aItem, {"LR_DESCPRO", 0 , NIL} )
  aAdd( aItem, {"LR_LOCAL", SB1->B1_LOCPAD , NIl })
  aAdd( aItem, {"LR_VEND" , cVendedor , NIL} )
  
  /*
  If 	M->LQ_ENTREGA = 'S' .And. Alltrim(SA1->A1_GRPTRIB) = '005' .And. Alltrim(SB1->B1_GRTRIB) = '001' .And. Alltrim(aCols[n][aPos[02]]) $ "00/01"   
     SF4->(dbSetORder(1))          
     lContinua := SF4->(dbSeek(xFilial('SF4') + SuperGetMv("MV_XTESST",.F.,aColsDet[n][aPos[03]]) ))
  else 
     _ctes := Iif(Empty(SB1->B1_TS),GetMv("MV_TESSAI"),SB1->B1_TS)
     SF4->(dbSetORder(1))     
     lContinua := SF4->(dbSeek(xFilial('SF4') + _cTes ))       
  Endif
  */
  //aAdd( aItem,{"LR_ETNREGA" , cEntrega , NIL} )
  //aAdd( aItem,{"LR_DESC" , 0 , NIL} )
  //aAdd( aItem,{"LR_VALDESC", 0 , NIL} )
  //aAdd( aItem,{"LR_TABELA" , PadR("1",nTamTabela) , NIL} )
  //aAdd( aItem,{"LR_DESCPRO", 0 , NIL} )
  //aAdd( aItem,{"LR_VEND" , cVendedor , NIL} )
  xdEntrega := ""
  For OO := 1 To Len(names)
    xx := .T.
    xName := Alltrim( names[OO] )
    
    If xName$"LR_PRODUTO#LR_QUANT#LR_UM#LR_DESC#LR_TABELA#LR_DESCPRO#LR_VEND#LR_VLRITEM#LR_VRUNIT#LR_QUANT2#LR_VLRITEMLIQ#LR_UM2#"
       xx := .F.
    EndIf

	 If xName=="LR_ENTREGA"
	   xdEntrega := oJson[xName]
	   xx := .F.
	 EndIf

    If Left(names[OO],3)== "LR_" .And. xx
      aAdd(aItem,{ names[OO], oJson[names[OO]] , NIl })
    Endif

  Next
  If !Empty(xdEntrega) .And. !(FwCodEmp()=="06" .And. FwCodFil()=="01")
     aAdd(aItem,{"LR_ENTREGA", xdEntrega , NIl })
  EndIf
  //aAdd(aItem,{"LR_VEND", cVendedor , NIl })
  
Return aItem

Static Function GetCabec(oJson,xNumOrc)
   Local _aCab := {}
   Local _cVendedor := oJson["VENDEDOR"]
   Local _cCodCli   := oJson["CLIENTE"]
   Local _cCodLoja  := oJson["LOJA"]
   Local names := oJson:GetNames()
   Local OW

   Local _cCond  := oJson:GetJsonText("CONDPAGAMENGO")
    

   Default xNumOrc := ""
   if (Empty(_cCodCli) .or. Empty(_cCodLoja))
      AddError(oRet, "LOJA010","Cliente não Informado")
      return _aCab
   EndiF
   _cVendedor := PadR(_cVendedor,TamSX3("A3_COD")[1])
   SA1->(DbSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA
   if !SA1->(MsSeek(xFilial("SA1")+_cCodCli+_cCodLoja))
      AddError(oRet, "LOJA010","Cliente não Encontrado")
      return _aCab
   EndIf

   SA3->(dbSetOrder(1))
   SA3->(dbSeek(xFilial("SA3") +_cVendedor  ))   
   If !Empty(xNumOrc)
       SL1->(DbSetOrder(1))
       xSL1 = SL1->(dbSeek(xFilial('SL1') +  xNumOrc) )
       aAdd( _aCab, {"LQ_NUM"    , xNumOrc , NIL} )
       aAdd( _aCab, {"LQ_CLIENTE" , SA1->A1_COD , NIL} )
	    aAdd( _aCab, {"LQ_LOJA"    , SA1->A1_LOJA , NIL} )
	    aAdd( _aCab, {"LQ_TIPOCLI" , SA1->A1_TIPO , NIL} )
       //aAdd( _aCab, {"LQ_CONDPG"  , "   "     , NIL} )
   Else
       aAdd( _aCab, {"LQ_VEND"    , _cVendedor , NIL} )
      //aAdd( _aCab, {"LQ_COMIS"   , 0 , NIL} )
	    aAdd( _aCab, {"LQ_CLIENTE" , SA1->A1_COD , NIL} )
	    aAdd( _aCab, {"LQ_LOJA"    , SA1->A1_LOJA , NIL} )
	    aAdd( _aCab, {"LQ_TIPOCLI" , SA1->A1_TIPO , NIL} )
	    //aAdd( _aCab, {"LQ_DESCONT" , 0 , NIL} )
	    aAdd( _aCab, {"LQ_DTLIM"   , dDatabase , NIL} )
	    aAdd( _aCab, {"LQ_EMISSAO" , dDatabase , NIL} )
       aAdd( _aCab, {"LQ_NUMMOV"  , "1 " , NIL} )
   EndIf
   
   if !Empty(_cCond)
      aAdd( _aCab, {"LQ_CONDPG"  , _cCond     , NIL} )
   Else
      aAdd( _aCab, {"LQ_CONDPG"  , "   " , NIL} )
   EndIf
   //"CODPAGAMENTO":"003"
   //aAdd( _aCab, {"AUTRESERVA" , "000001" , NIL} ) //Codigo da Loja (Campo SLJ->LJ_CODIGO) que deseja efetuar a reserva quando existir item(s) que for do tipo entrega (LR_ENTREGA = 3)
   xdAutR := ""
   For  OW := 1 To Len(names)
    xName := Alltrim(names[OW])
	
	If(xName=="LQ_ENTREGA" .And. oJson["LQ_ENTREGA"]=="S")
      If FwCodEmp() == "01"
         if FwCodFil() == "04"
            xdAutR := "000007"      
         Elseif FwCodFil() == "03"
            xdAutR := "000006"
         Elseif FwCodFil() == "02"
            xdAutR := "000008"
         else
            xdAutR := "000001"
         EndIf
      ElseIf FwCodEmp() == "06"
         if FwCodFil() == "01"
           oJson["LQ_ENTREGA"] := "N"
           xdAutR := ""
         Elseif FwCodFil() == "03"
            xdAutR := "000003"
         Else
         //Sem Reserva para outra filial
         Endif
      EndIf
	EndIf
	
   If Left(names[OW],3)=="LQ_" .And. !xName$"LQ_VEND#LQ_CLIENTE#LQ_LOJA#LQ_TIPOCLI#LQ_DTLIM#LQ_EMISSAO#LQ_CONDPG#LQ_NUMMOV"
      aAdd( _aCab, { names[OW]  , oJson[names[OW]] , NIL} )
   Endif
   Next
   
   If !Empty(xdAutR)
      aAdd( _aCab, {"AUTRESERVA" , xdAutR , NIL} ) 
   EndIf
   
Return _aCab

Static Function AddError(oJson,Code,Message)
   oJson["succeeded"] := .F.
   aAdd( oJson["errors"] , JsonObject():New() ) 
   nPos := Len( oJson["errors"] )
   oJson["errors"][nPos]["code"] := Code
   oJson["errors"][nPos]["message"] := Message
Return oJson

Static Function CleanMFT(xNumOrc)
   Local lMFT := .F.
   MFT->(dbSetOrder(1))
   lMFT := MFT->(dbSeek(xFilial('MFT') + xNumOrc ))
   If lMFT
      xKey := MFT->MFT_FILIAL + MFT->MFT_NUM
      While MFT->MFT_FILIAL + MFT->MFT_NUM == xKey
         MFT->(RecLock("MFT", .F.))         
         MFT->(dbDelete())
         MFT->(MsUnlock())
         MFT->(dbSkip())
      EndDo 
   Endif
Return Nil
