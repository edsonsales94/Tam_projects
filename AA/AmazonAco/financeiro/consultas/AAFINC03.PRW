//-------------------------------------------------------. 
// Declaração das bibliotecas utilizadas no programa      |
//-------------------------------------------------------' 
#Include 'Protheus.ch'
#include 'totvs.ch'

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Funcao    ¦ AAFINC03   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 15/12/2021 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descricao ¦ Rotina de Cobrança                                            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAFINC03()
 //-------------------------------------------------------. 
 // Declaração das Variaveis Locais                        |
 //-------------------------------------------------------' 
 Local   aCoors    := FwGetDialogSize()
 Local   aFields   := {}//_Fields()
 Local   Ik 
 Local   aColumns := {} 

 //-------------------------------------------------------. 
 // Declaração das Variaveis Privadas                      |
 //-------------------------------------------------------' 
 Private cPerg    := Padr('AAFINC03',Len(SX1->X1_GRUPO))
 Private _adDados := {}
 Private oBrowse  := {}
 Private _adCabec := {}
 PRivate _adPvt   := {}
 Private odProdDe   := Nil
 PRivate odProdAte  := Nil
 PRivate odGrupoDe  := Nil
 PRivate odGrupoAte := Nil
 PRivate odTipoDe   := Nil
 PRivate odTipoAte  := Nil
 PRivate odLocalDe  := Nil
 Private odMeses    := Nil
 PRivate odLocalAte := Nil
 PRivate odFerraDe  := Nil
 PRivate odFerraAte := Nil
 Private _oChk01    := Nil
 Private _oChk02    := Nil
 Private _oChk03    := Nil
 Private _oChk04    := Nil
 Private _oChk05    := Nil
 Private _oChk06    := Nil
 Private _cdProdDe   := '                  '
 PRivate _cdProdAte  := 'zzzzzzzzzzzzzzzzzz'
 PRivate _cdGrupoDe  := '    '
 PRivate _cdGrupoAte := 'zzzz'
 PRivate _cdTipoDe   := '  '
 PRivate _cdTipoAte  := 'zz'
 PRivate _cdLocalDe  := '  '
 PRivate _cdLocalAte := 'zz'
 PRivate _cdMeses    := 10 
 PRivate _cdFerraDe  := Space(Len(SB1->B1_YFERRAM))
 PRivate _cdFerraAte := StrTran(Space(Len(SB1->B1_YFERRAM)),' ','z')
 Private _lChk01    := .T.
 Private _lChk02    := .T.
 Private _lChk03    := .T.
 Private _lChk04    := .T.
 Private _lChk05    := .T.
 Private _lChk06    := .T.
 private cAlias := GetNextAlias()
 Private _ldInclui  := .T.
 Private _cdPed     := ""
 Private _ldChange  := .F.
 Private aFils      := {"",""} 
 private lJob       := IsBlind()
 Private aLinha     := {}
 Private aExport    := {} 
 Private aCabec     := {} 
 Private aItems     := {}
 Private _cTipo     := "Separados"
 Private _cMetodo   := "Consumo"
 Private aMetodos   := {} 

	AADD(aItems,"Separados")
	AADD(aItems,"Unificados")

	AADD(aMetodos,"Consumo")
	AADD(aMetodos,"Pedidos")
    AADD(aMetodos,"Vendas")
	
	aFields   := _Fields()
	GetSql()

	//WWW1->(dbGotop())

	aCoors := FwGetDialogSize(oMainWnd)

	oDlg := MSDialog():New(aCoors[1], aCoors[2],aCoors[3], aCoors[4],'Sugestão de Compras',,,,,CLR_BLACK,CLR_WHITE,,,.T.)	

	oLayer := FWLAYER():New()
	oLayer:Init(oDlg,.T.)

	oLayer:AddLine('UP',12)
	oLayer:AddLine('MIDDLE',88)
	oLayer:AddLine('DOWN',0)

	oLayer:AddColumn('ALL' ,100,,'UP')
	oLayer:AddColumn('ALL' ,100,,'MIDDLE')

	oLayer:AddColumn('ALL2' ,000,,'UP')

	oUp      := oLayer:GetColPanel('ALL','UP')
	oUp2     := oLayer:GetColPanel('ALL2','UP')
	oMiddle  := oLayer:GetColPanel('ALL','MIDDLE')


    @ 20,05 TO 060,790 label "Filtros" OF oDlg	 PIXEL
	
	@ 20,010 + 000 Say "Produto: "                                 Size 50,10 Pixel Of oUp
	@ 30,010 + 000 MsGet odProdDe      Var _cdProdDe  F3 'SB1'     Size 60,08 Pixel of oUp
	@ 30,070 + 000 MsGet odProdAte     Var _cdProdAte F3 'SB1'     Size 60,08 Pixel of oUp

	@ 20,010 + 160 Say "Ferramenta: "                              Size 50,10 Pixel Of oUp
	@ 30,010 + 160 MsGet odFerraDe      Var _cdFerraDe  F3 'SZH'   Size 30,08 Pixel of oUp
	@ 30,040 + 160 MsGet odFerraAte     Var _cdFerraAte F3 'SZH'   Size 30,08 Pixel of oUp

	@ 20,010 + 250 Say "Grupo: "                                   Size 50,10 Pixel Of oUp
	@ 30,010 + 250 MsGet odGrupoDe   Var _cdGrupoDe  F3 'SBM'      Size 30,08 Pixel of oUp
	@ 30,040 + 250 MsGet odGrupoAte  Var _cdGrupoAte F3 'SBM'      Size 30,08 Pixel of oUp
                                                                             
	@ 20,010 + 340 Say "Armazem: "                                 Size 50,10 Pixel Of oUp
	@ 30,010 + 340 MsGet odLocalDe    Var _cdLocalDe   F3 'AL '    Size 30,08 Pixel of oUp
	@ 30,040 + 340 MsGet odLocalAte   Var _cdLocalAte  F3 'AL '    Size 30,08 Pixel of oUp

	@ 20,010 + 430 Say "Tipos: "                                   Size 50,10 Pixel Of oUp
	@ 30,010 + 430 MsGet odTipoDe    Var _cdTipoDe   F3 '02 '      Size 30,08 Pixel of oUp
	@ 30,040 + 430 MsGet odTipoAte   Var _cdTipoAte  F3 '02 '      Size 30,08 Pixel of oUp

	@ 20,010 + 520 Say "Meses Estoque: "                           Size 50,10 Pixel Of oUp
	@ 30,010 + 520 MsGet odMeses    Var _cdMeses                   Size 30,08 Pixel of oUp

	@ 20,010 + 610 Say "Nacional/Importado:"                       Size 60,10 Pixel Of oUp
	@ 30,010 + 610 MSCOMBOBOX oTipo VAR _cTipo ITEMS aItems        SIZE 50,08 Pixel Of oUp

	@ 20,010 + 700 Say "Calculo Por:"                              Size 60,10 Pixel Of oUp
	@ 30,010 + 700 MSCOMBOBOX oMetodo VAR _cMetodo ITEMS aMetodos  SIZE 50,08 Pixel Of oUp

    oBrowse := FWMarkBrowse():New()
        
	For Ik := 02 To Len(aFields)
		AAdd( aColumns, FWBrwColumn():New() )
		aColumns[Len(aColumns)]:SetData( &("{ || " + aFields[Ik][1] + " }") )
		aColumns[Len(aColumns)]:SetTitle(   aFields[Ik][2] )
		aColumns[Len(aColumns)]:SetSize(    aFields[Ik][4] )
		aColumns[Len(aColumns)]:SetDecimal( aFields[Ik][5] )
		aColumns[Len(aColumns)]:SetPicture( aFields[Ik][6] )
		aColumns[Len(aColumns)]:SetID(      aFields[Ik][1] ) 

	Next Ik

	oBrowse:SetColumns( aColumns )
	oBrowse:SetAlias( "WWW1" )
	oBrowse:SetFieldMark( 'MARK' )
	oBrowse:SetAfterMark ( { || fwTroca(), oBrowse:GoTo(oBrowse:At(),.T.),oBrowse:Refresh(.T.)  } )

		//Indica o Code-Block executado no clique do header da coluna de marca/desmarca
	oBrowse:bAllMark := { || fWInvert(oBrowse:Mark(),lMarcar := !lMarcar ), oBrowse:Refresh(.T.)  }
	oBrowse:AddButton("&Detalhes PC", { || u_AACOMEXA(WWW1->COD_NAC)},,,, .F., 2 )
	oBrowse:AddButton("&Consultar"  , { || MsgRun('Filtrando Dados...' ,,{||  _Consulta()  })},,,, .F., 2 )
	oBrowse:AddButton("&Gerar SC"   , { || (fwProcessa(), oDlg:End())},,,, .F., 2 )
	oBrowse:AddButton("&Excel"      , { || (Exporta())},,,, .F., 2 )
	oBrowse:AddButton("&Fechar"     , { || oDlg:End() },,,, .F., 2 )


	oBrowse:Activate(oMiddle)
 
	oDlg:Activate()

Return Nil

//Função para marcar/desmarcar todos os registros do grid
Static Function fWTroca()
    Local cAliasSD1 := 'WWW1'
    Local aAreaSD1  := (cAliasSD1)->( GetArea() )
	Local nwQuant   := (cAliasSD1)->SUGESTAO
    
	dbSelectArea(cAliasSD1)
  //  ALERT("TESTE")
	If !Empty(WWW1->MARK)
		RecLock( (cAliasSD1), .F. )
			(cAliasSD1)->SUGESTAO := AAGETQTD(nwQuant)
		MsUnlock()
	EndIf 
    RestArea( aAreaSD1 )

 	//oBrowse:Refresh()
	
Return .T.

//Função para marcar/desmarcar todos os registros do grid
Static Function fWInvert(cMarca,lMarcar)
  /*  Local cAliasSD1 := 'WWW1'
    Local aAreaSD1  := (cAliasSD1)->( GetArea() )
    dbSelectArea(cAliasSD1)
    (cAliasSD1)->( dbGoTop() )
    While !(cAliasSD1)->( Eof() )
        RecLock( (cAliasSD1), .F. )
        (cAliasSD1)->MARK := IIf( lMarcar, cMarca, '  ' )
        MsUnlock()
        (cAliasSD1)->( dbSkip() )
    EndDo
    RestArea( aAreaSD1 )*/
Return .T.

Static Function _Consulta()
    GetSql()

 	oBrowse:Refresh()

	oBrowse:At() := 1
	//oBrowse:GoTo(oBrowse:At())
	WWW1->(dbGoTop())
Return Nil

Static Function _Fields()
 Local aFields:= {}
 
   aadd(aFields, Field_("MARK"         ,""            ,"C", {001,00} , "@!") )
   aadd(aFields, Field_("CLIENTE"      ,"Cliente"     ,"C", {006,00} , "@!") )
   aadd(aFields, Field_("LOJA"         ,"Loja"        ,"C", {002,00} , "@!") )
   aadd(aFields, Field_("NOMECLI"      ,"Razão Social","C", {050,00} , "@!") )
   aadd(aFields, Field_("ORIGINAL"     ,"Original"    ,"N", {014,02} , "@E 999,999,999.99") )
   aadd(aFields, Field_("ABERTO"       ,"Em Aberto"   ,"N", {014,02} , "@E 999,999,999.99") )
   aadd(aFields, Field_("EMAIL"        ,"Email"       ,"C", {100,00} , "@!") )
   
   aLinha := {}
   aCabec := {}
		      
   aAdd(aLinha,"Cliente")
   aAdd(aLinha,"Loja")
   aAdd(aLinha,"Razão Social")      	
   aAdd(aLinha,"Original")
   aAdd(aLinha,"Em Aberto")
   aAdd(aLinha,"Email")
   
   aAdd(aCabec,Array(Len(aLinha)))
   
   aCabec[Len(aCabec)] := aClone(aLinha)

   aLinha := {}
		   
Return aFields

Static Function Field_(xCpo, xTitle,xTipo,xTam, xPicture)
Return {xCpo,xTitle, xTipo,xTam[01],xTam[02], xPicture}

Static Function GetSql()
    Local aCampos   := {}
    Local cArqTrb   := Nil
    Local cIndice1  := "" 
	Local cIndice2  := ""
    Local nI        := 0
	Local cwAglu    := if(_cTipo   == "Separados", "'N'", "'S'")
	Local cwTipo    := if(_cMetodo == "Consumo", "'D'",if(_cMetodo == "Vendas", "'V'", "'P'"))
    //Declarar variáveis privadas
    Private oBrowse     := Nil
    Private cCadastro     := "Usuários do Sistema"
    Private aRotina         := Menudef() //Se for criar menus via MenuDef
    
    //Criar a tabela temporária
    AAdd(aCampos,{"MARK"         ,"C",002                  , 0}) //Este campo será usado para marcar/desmarcar
    AAdd(aCampos,{"CLIENTE"      ,"C",TamSX3("A1_COD"  )[1], 0})
	AAdd(aCampos,{"LOJA"         ,"C",TamSX3("A1_LOJA" )[1], 0})
    AAdd(aCampos,{"NOMECLI"      ,"C",TamSX3("A1_NOME" )[1], 0})
    AAdd(aCampos,{"EMAIL"        ,"C",100, 0})
    AAdd(aCampos,{"ORIGINAL"     ,"N",TamSX3("E1_VALOR" )[1], TamSX3("E1_VALOR"    )[2]})
    AAdd(aCampos,{"ABERTO"       ,"N",TamSX3("E1_VALOR" )[1], TamSX3("E1_VALOR"    )[2]})

    //Se o alias estiver aberto, fechar para evitar erros com alias aberto
    If (Select("WWW1") <> 0)
        dbSelectArea("WWW1")
        WWW1->(dbCloseArea ())
    Endif
    //A função CriaTrab() retorna o nome de um arquivo de trabalho que ainda não existe e dependendo dos parâmetros passados, pode criar um novo arquivo de trabalho.
    cArqTrb   := CriaTrab(aCampos,.T.)
    
    //Criar indices
    cIndice1 := Alltrim(CriaTrab(,.F.))
    cIndice2 := cIndice1
    
    cIndice1 := Left(cIndice1,5) + Right(cIndice1,2) + "A"
    cIndice2 := Left(cIndice2,5) + Right(cIndice2,2) + "B"
    
    //Se indice existir excluir
    If File(cIndice1+OrdBagExt())
        FErase(cIndice1+OrdBagExt())
    EndIf
    If File(cIndice2+OrdBagExt())
        FErase(cIndice2+OrdBagExt())
    EndIf
  
    //A função dbUseArea abre uma tabela de dados na área de trabalho atual ou na primeira área de trabalho disponível
    dbUseArea(.T.,,cArqTrb,"WWW1",Nil,.F.)
  
    //A função IndRegua cria um índice temporário para o alias especificado, podendo ou não ter um filtro
    //IndRegua("WWW1", cIndice1, "B1_CODNAC" ,,, "Indice Nome...")
    IndRegua("WWW1", cIndice2, "NOMECLI",,, "Indice Login...")
    
    //Fecha todos os índices da área de trabalho corrente.
  //  dbClearIndex()
    //Acrescenta uma ou mais ordens de determinado índice de ordens ativas da área de trabalho.
   // dbSetIndex(cIndice1+OrdBagExt())
   // dbSetIndex(cIndice2+OrdBagExt())
    
	_cdTbl := GetNextAlias()

	_cdMes := Right(Left(dtos(dDataBase),6),2)
	_cdMes := Val(_cdMes) //-1
	For nI := 01 To 06
		If _cdMes <= 0
			_cdMes := 12
		Else
			_cdMes -= 01 
			iF _cdMes = 0
				_cdMes := 12
			EndIf 
		EndIf
		&("cMes" + StrZero(nI,2)) := "B3_Q" + StrZero(_cdMes,2)
	Next

   //-------------------------------------------------------. 
   // Montagem consulta sql com os cliente devedores         |
   //-------------------------------------------------------' 
   _cdQry := " select ''             AS MARK, " 
    _cdQry += "        E1_CLIENTE    AS CLIENTE, "
    _cdQry += " 	   E1_LOJA       AS LOJA,"
    _cdQry += " 	   A1_NOME       AS NOMECLI,"
    _cdQry += " 	   A1_EMAIL      AS EMAIL, "
    _cdQry += " 	   SUM(E1_VALOR) AS ORIGINAL, "
    _cdQry += " 	   SUM(E1_SALDO) AS ABERTO"
    _cdQry += "  FROM "+RetSqlName("SE1")+" AS SE1 (NOLOCK)"
    _cdQry += "  INNER JOIN "+RetSqlName("SA1")+" AS SA1 (NOLOCK) ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA"
    _cdQry += "  WHERE SE1.D_E_L_E_T_ = '' AND E1_FILIAL = '' AND E1_TIPO  IN ('BO', 'BOL')" 
    _cdQry += "   AND E1_SALDO > 0 "
    _cdQry += " GROUP BY  E1_CLIENTE, E1_LOJA, A1_NOME, A1_EMAIL"
     
	Memowrite('AAFINC03.SQL',_cdQry)

	dbUseArea(.T., "TOPCONN", tcGenQry(,,_cdQry), _cdTbl , .T., .T.)

	While !(_cdTbl)->(Eof())
		//Popular tabela temporária, irei colocar apenas um unico registro
		RecLock("WWW1",.t.)
			WWW1->MARK     := (_cdTbl)->MARK
			WWW1->CLIENTE  := (_cdTbl)->CLIENTE
			WWW1->LOJA     := (_cdTbl)->LOJA
			WWW1->NOMECLI  := (_cdTbl)->NOMECLI
			WWW1->EMAIL    := (_cdTbl)->EMAIL
			WWW1->ORIGINAL := (_cdTbl)->ORIGINAL
			WWW1->ABERTO   := (_cdTbl)->ABERTO
		MsUnLock()

		(_cdTbl)->(dbSkip())
	End 
    
    WWW1->(DbGoTop())
	
	(_cdTbl)->(dbCloseArea())

Return Nil 


Static Function _getOpenPc(_xProd)
   Local _xdData := {}
   Local _cdQry  := ""
   
    _cdQry += Chr(13) + Chr(10) + " 					 SELECT  "	
	_cdQry += Chr(13) + Chr(10) + " 					        C7_NUM,                   	    "	
	_cdQry += Chr(13) + Chr(10) + " 					        Sum(C7_QUANT) 	   QUANTIDADE,  "
	_cdQry += Chr(13) + Chr(10) + " 					        Sum(C7_QUJE) 	   ENTREGUE  ,  "
	_cdQry += Chr(13) + Chr(10) + " 					        Sum(C7_QUANT - C7_QUJE)SALDO ,  "
	_cdQry += Chr(13) + Chr(10) + " 					        Sum( (C7_QUANT - C7_QUJE)*C7_PRECO ) TOTAL   "
	
	_cdQry += Chr(13) + Chr(10) + " 					 FROM " + RetSqlName('SC7') + " C7 (nolock)  "
	_cdQry += Chr(13) + Chr(10) + " 					 Where D_E_L_E_T_ = ''                 "
	_cdQry += Chr(13) + Chr(10) + " 					   And C7_QUANT - C7_QUJE > 0          "
	_cdQry += Chr(13) + Chr(10) + " 					   And C7_RESIDUO = ' '                "
	_cdQry += Chr(13) + Chr(10) + " 					   And C7_CONAPRO = 'L'                "
	_cdQry += Chr(13) + Chr(10) + "						   And C7_PRODUTO = '" + _xProd + "' "
	_cdQry += Chr(13) + Chr(10) + "	 Group By C7_NUM
	
	_xkTbl := MpSysOpenQuery(_cdQry)
	
	_xdData := {}
	
	While !(_xkTbl)->(Eof())
	    xLin := {}
	    aAdd(xLin, "" )
	    aAdd(xLin, (_xkTbl)->C7_NUM )  
	   	aAdd( xLin, (_xkTbl)->QUANTIDADE )
	   	aAdd( xLin, (_xkTbl)->ENTREGUE )
	   	aAdd( xLin, (_xkTbl)->SALDO )
	   	aAdd( xLin, Round( (_xkTbl)->TOTAL / (_xkTbl)->QUANTIDADE,2) )
	   	aAdd( xLin, (_xkTbl)->TOTAL )
        
        aAdd(_xdData, xLin)
	    (_xkTbl)->(dbSkip())
	EndDo
		
Return _xdData

STATIC Function AAFINEXA(_xProd)
    
    Local _adCons := {Nil,{} , {} }
    
    _adCons[03] := aClone(_getOpenPc(_xProd))
    
    odPcs := MSDialog():New(0, 0, 430, 920,'Pedidos de Compras',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

    odPLayer := FWLAYER():New()
	odPLayer:Init(odPcs,.T.)

	odPLayer:AddLine('UP',10)
	odPLayer:AddLine('MIDDLE',90)
	//odPLayer:AddLine('DOWN',0)

	odPLayer:AddColumn('ALL' ,100,,'UP')
	odPLayer:AddColumn('ALL' ,100,,'MIDDLE')

	//odPLayer:AddColumn('ALL2' ,020,,'UP')

	oPUp      := odPLayer:GetColPanel('ALL','UP')
	//oPUp2     := odPLayer:GetColPanel('ALL2','UP')
	oPMiddle  := odPLayer:GetColPanel('ALL','MIDDLE')

	
	oFont := TFont():New('Courier new',,-18,.T.)
	TSay():New(01,01,{||'Produto : ' + ALLTRIM(_xProd) + '/' + Posicione('SB1',1,xFilial('SB1') + _xProd, 'B1_DESC') },oPUp,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,200,200)
	
	aAdd(_adCons[02],{ "Pedido "         , {||  _adCons[03][_adCons[01]:At(),02] }  ,"C", "@!" ,  1 , 5 , 0,,,,,,  })
	aAdd(_adCons[02],{ "Quantidade "     , {||  _adCons[03][_adCons[01]:At(),03] }  ,"N", "@e 999,999,999.99" ,  2 , 07 , 4,,,,,,  })
	aAdd(_adCons[02],{ "Qtd.Entregue"    , {||  _adCons[03][_adCons[01]:At(),04] }  ,"N", "@e 999,999,999.99" ,  2 , 07 , 4,,,,,,  })
	aAdd(_adCons[02],{ "Saldo "          , {||  _adCons[03][_adCons[01]:At(),05] }  ,"N", "@e 999,999,999.99" ,  2 , 07 , 4,,,,,,  })
	aAdd(_adCons[02],{ "Valor  "         , {||  _adCons[03][_adCons[01]:At(),06] }  ,"N", "@e 999,999,999.99" ,  2 , 06 , 4,,,,,,  })
	aAdd(_adCons[02],{ "Total "          , {||  _adCons[03][_adCons[01]:At(),07] }  ,"N", "@e 999,999,999.99" ,  2 , 08 , 4,,,,,,  })
	
	_adCons[01] := FWBrowse():New()

	_adCons[01]:SetDataArray()
	_adCons[01]:SetColumns( _adCons[02] )
	_adCons[01]:SetArray( _adCons[03] )
	_adCons[01]:SetOwner( oPMiddle )	
	//_adCons[01]:AddButton("&Fechar"     , { || odPcs:End() },,,, .F., 2 )

	_adCons[01]:Activate()

     odPcs:Activate()   
  //  odPcs:Activate(,,,.T.,{|| },,{|| EnchoiceBar(odPcs,{|| odPcs:End() },{|| odPcs:End() } )  } )
    
    //DEFINE MSDIALOG oWindow TITLE "Pedidos de Venda" FROM 0,0 TO 430,920 PIXEL

Return Nil



/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Funcao    ¦ fwProcessa ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 22/04/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descricao ¦ Processamento da rotina de geracao de SC Padrao Sakura        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fwProcessa()
 //-------------------------------------------------------. 
 // Declaração das variaveis privadas da função            |
 //-------------------------------------------------------'  
 Local cDoc  := ""
 Local lSol  := .F. 

	//-------------------------------------------------------. 
	// Busca o proximo numero de Solicitacao de Compra        |
	//-------------------------------------------------------'  		
	cDoc := GetSXENum("SC1","C1_NUM")		
	
	//-------------------------------------------------------. 
	// Seta o indice 1 para a tabela SC1 - Solic. de Compras  |
	//-------------------------------------------------------'  		
	SC1->(dbSetOrder(1))		
	
	//-------------------------------------------------------. 
	// Repetição para verificar se o Num da SC esta liberado  |
	//-------------------------------------------------------'  		
	While SC1->(dbSeek(xFilial("SC1")+cDoc))			
		//-------------------------------------------------------. 
		// Confirma o uso do numero, pois ja foi usado na SC1     |
		//-------------------------------------------------------'  		
		ConfirmSX8()			                                            
		
		//-------------------------------------------------------. 
		// Busca Novo numero de solicitação de Compras            |
		//-------------------------------------------------------'  		
		cDoc := GetSXENum("SC1","C1_NUM")		

	//-------------------------------------------------------. 
	// Fim da Repetição quando o Numero nao estiver na SC1    |
	//-------------------------------------------------------'  		
	EndDo							

	//-------------------------------------------------------. 
	// Inicialização da variavel de controle dos Itens da SC  |
	//-------------------------------------------------------'  		 					
	cwItem := "000"

	//-------------------------------------------------------. 
	// Posicionando no primeiro registro da tabela Temporaria |
	//-------------------------------------------------------'  
	WWW1->(dbGotop())

	//-------------------------------------------------------. 
	// Percorrendo toda a tabela temporaria de necesssidades  |
	//-------------------------------------------------------'  		
	While !WWW1->(Eof())		
		
		IF WWW1->SUGESTAO > 0 .AND. !Empty(WWW1->MARK)
			//-------------------------------------------------------. 
			// Variavel para Quebra de SC por periodo e fornecedor    |
			//-------------------------------------------------------'  		
			cwItem := StrZero(Val(cwItem) +1, 3)
			lSol   := .T.

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+WWW1->COD_NAC))
			
			//-------------------------------------------------------. 
			// Variavel para quebar as SC's sem fornecedores          |
			//-------------------------------------------------------'  							
			Reclock("SC1", .T.)
				SC1->C1_FILIAL  := xFilial("SC1")
				SC1->C1_NUM     := cDoc
				SC1->C1_EMISSAO := dDataBase
				SC1->C1_SOLICIT := "SUGESTAO"
				SC1->C1_ITEM    := cwItem
				SC1->C1_PRODUTO := WWW1->COD_NAC
				SC1->C1_QUANT   := WWW1->SUGESTAO
				SC1->C1_LOCAL   := SB1->B1_LOCPAD
				SC1->C1_DESCRI  := SB1->B1_DESC
				SC1->C1_UM      := SB1->B1_UM 
				SC1->C1_SEGUM   := SB1->B1_SEGUM
				SC1->C1_CONTA   := SB1->B1_CONTA
				SC1->C1_IMPORT  := "N"
				SC1->C1_DATPRF  := dDataBase + SB1->B1_PE
				SC1->C1_TPOP    := "P"
				SC1->C1_FORNECE := SB1->B1_PROC
				SC1->C1_LOJA    := SB1->B1_LOJPROC								         
				SC1->C1_CC   	:= SB1->B1_CC    
				SC1->C1_MOEDA   := 1 
				If !Empty(SB1->B1_SEGUM) .And. SB1->B1_CONV <> 0 
					If SB1->B1_TIPCONV == "M"
							SC1->C1_QTSEGUM := WWW1->SUGESTAO * SB1->B1_CONV
						Else
							SC1->C1_QTSEGUM := WWW1->SUGESTAO / SB1->B1_CONV
					EndIf 
				EndIf 
			MsUnlock()
		EndIf  

		//-------------------------------------------------------. 
		// Pula para o proximo registro da tabela de Necessidades |
		//-------------------------------------------------------'  			
		WWW1->(dbSkip())
			  
	//-------------------------------------------------------. 
	// Fim da repetição que percorre a tabela de necessidades |
	//-------------------------------------------------------'  							 			
	EndDo   
	
	//-------------------------------------------------------. 
	// Encerra a tabela temporaria com as necessidades        |
	//-------------------------------------------------------'  							 			
	//WTAB1->(dbCloseArea())
		
	//-------------------------------------------------------. 
	// Mensagem em tela para o usuario identificar o fim      |
	//-------------------------------------------------------' 
	If lSol 							 						
		Alert("Solicitacao de Compras "+cDoc+ " incluida!")
	EndIf 
//-------------------------------------------------------. 
// Retorno da Rotina - Padrao Nil                         |
//-------------------------------------------------------'  							 						
Return Nil

Static Function AAGETQTD(nwQtde)

	Local nQuant  := nwQtde
	Local nSair   := -1
	Local oQuant  := Nil

	Define Font oFnt3 Name "Ms Sans Serif" Bold

	while nSair < 0
		
		DEFINE MSDIALOG oDialog TITLE "Quantidade" FROM 190,110 TO 300,370 PIXEL STYLE nOR(WS_VISIBLE,WS_POPUP)
		@ 005,004 SAY "Quantidade :" SIZE 220,10 OF oDialog PIXEL Font oFnt3
		//@ 005,050 MSGET nQuant         SIZE 50,10  PICTURE "@E 999,999.99" VALID nQuant > 0 OF oDialog //Pixel of oSenhas
		@ 005,050 MsGet oQuant    Var nQuant   Size 50,10 PICTURE "@E 999,999,999.99" VALID nQuant > 0 Pixel of oDialog
	

		@ 035,042 Button "Confirmar"   Size 40,12 Pixel of oDialog Action ( nSair := 0 , nRet := IIF(nQuant >= 0,oDialog:End(), NIL) )

		ACTIVATE DIALOG oDialog CENTERED
	Enddo

Return nQuant

//--------------------------------------------------------------------------------------------
//*******************ROTINAS DE EXPORTAÇÃO PARA EXC*****************************************

Static Function Exporta()
   Local cArqTxt    := GetTempPath()+Str(Randomize(1,1000))+"Suegstao.xls"
   Local nHdl       := fCreate(cArqTxt)
   Local cLinha     := "" //Chr(9)+"Relatório"+Chr(13)+Chr(10)
   Local i          := 0
   Local j          := 0
   Local lTudo      := MsgYesNo(" Deseja imrprimir tudo ou somente marcados?")
   
   If nHdl = -1
      MsgStop("O Arquivo " + cArqTXT + " não pode ser Criado! ERRO:" + FError())  
      WWW->(DbCloseArea())
	  Return nil
	EndIf
	 
    cLinha += "Item"	    + Chr(9) + "Produto"   + Chr(9) + "Descrição" + Chr(9)+"Quantidade"+Chr(9) 
    cLinha += "Preco"    + Chr(9) + "Pagamento" + Chr(9) + "Prazo"	+chr(13)+chr(10) 
	
	aExport := {}
	aAdd(aExport,Array(Len(aCabec[1])))
	aExport[1] := aCabec[1]
    // alert("teste")
	//-------------------------------------------------------. 
	// Posicionando no primeiro registro da tabela Temporaria |
	//-------------------------------------------------------'  
	WWW1->(dbGotop())

	//-------------------------------------------------------. 
	// Percorrendo toda a tabela temporaria de necesssidades  |
	//-------------------------------------------------------'  		
	While !WWW1->(Eof())		
		
		IF (WWW1->SUGESTAO > 0 .AND. !Empty(WWW1->MARK)) .Or. lTudo
		
			aAdd(aLinha,WWW1->COD_NAC)
			aAdd(aLinha,WWW1->COD_IMP)
			aAdd(aLinha,WWW1->B1_ESPECIF)      	
			aAdd(aLinha,Transform(WWW1->MES01   , "@E 999,999,999.99"))
			aAdd(aLinha,Transform(WWW1->MES02   , "@E 999,999,999.99"))
			aAdd(aLinha,Transform(WWW1->MES03   , "@E 999,999,999.99"))
			aAdd(aLinha,Transform(WWW1->MES04   , "@E 999,999,999.99"))                   			  
			aAdd(aLinha,Transform(WWW1->MES05   , "@E 999,999,999.99"))
			aAdd(aLinha,Transform(WWW1->MES06   , "@E 999,999,999.99"))
			aAdd(aLinha,Transform(WWW1->PEDIDO  , "@E 999,999,999.99"))
			aAdd(aLinha,Transform(WWW1->B2_QATU , "@E 999,999,999.99"))
			aAdd(aLinha,Transform(WWW1->SUGESTAO, "@E 999,999,999.99"))
			aAdd(aLinha,WWW1->TEMPO)     
			aAdd(aLinha,Transform(WWW1->MEDIA   , "@E 999,999,999.99"))
			aAdd(aLinha,Transform(WWW1->ORIGINAL, "@E 999,999,999.99"))

			aAdd(aExport,Array(Len(aLinha)))
			aExport[Len(aExport)] := aClone(aLinha)

			aLinha := {}

    	EndIf

		WWW1->(dbSkip()) 
	End          
   
    For i:=1 to Len(aExport)
       cLinha := ""

       If ValType(aExport[i])<>"A"
          cLinha += aExport[i]
       Else
          For j := 1 to Len(aExport[i])
		     //ALERT(aExport[i][j])
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

*****************************************************************************************************************************      

Static Function RunExcel(cwArq)
  Local oExcelApp                           
 
  If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
    MsgStop( 'Arquivo Gerado no Diretorio Informado' )
    //MsExcel nao instalado 
    Return
  EndIf  
  oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
  oExcelApp:WorkBooks:Open(cwArq) 
  oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.  
  
Return

/*********************************************************************************** 
*       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   *
*      AAAA       LL         LL         EE         CC        KK    KK   SS         *
*     AA  AA      LL         LL         EE        CC         KK  KK     SS         *
*    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   *
*   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  *
*  AA        AA   LL         LL         EE         CC        KK    KK          SS  *
* AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   * 
************************************************************************************
*         I want to change the world, but nobody gives me the source code!         * 
************************************************************************************/ 
