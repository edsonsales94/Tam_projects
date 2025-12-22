#Include 'Protheus.ch'
#include 'totvs.ch'

User Function AACOME03()

	Local aCoor := FwGetDialogSize()
	Local aButton   := {}
	Local aSay      := {}
	Local nOpc      := 0

//Pergunta do Relatorio pois o Existe os mesmos parametros e a Mesma Consulta
	Private cPerg    := Padr('AACOMR03',Len(SX1->X1_GRUPO))
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

//StaticCall(AACOMR03, ValidPerg, cPerg)

/*aAdd( aSay, "Esta Rotina tem Por Objetivo Imprimir as Informações" )
aAdd( aSay, "de Sugestão de Compra com Base nos Parametros Informados" )

aAdd( aButton, { 5, .T., {|x| Pergunte(cPerg)         }} )
aAdd( aButton, { 1, .T., {|x| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|x| nOpc := 2, FechaBatch() }} )

FormBatch( "Sugestão de Compras", aSay, aButton )
If nOpc == 1*/
	_doTask()
/*Else
	//_doNothing()
EndIf
  */
	Return

Static Function _doTask()

	GetData()

	aCoors := FwGetDialogSize(oMainWnd)

	oDlg := MSDialog():New(aCoors[1], aCoors[2],aCoors[3], aCoors[4],'Sugestão de Compras',,,,,CLR_BLACK,CLR_WHITE,,,.T.)	

	oLayer := FWLAYER():New()
	oLayer:Init(oDlg,.T.)

	oLayer:AddLine('UP',20)
	oLayer:AddLine('MIDDLE',80)
	oLayer:AddLine('DOWN',0)

	oLayer:AddColumn('ALL' ,080,,'UP')
	oLayer:AddColumn('ALL' ,100,,'MIDDLE')

	oLayer:AddColumn('ALL2' ,020,,'UP')

	oUp      := oLayer:GetColPanel('ALL','UP')
	oUp2     := oLayer:GetColPanel('ALL2','UP')
	oMiddle  := oLayer:GetColPanel('ALL','MIDDLE')

	@ 012 - 08,007 + 000 Say "Produto: "                               Size 50,10 Pixel Of oUp
	@ 012 - 08,045 + 000 MsGet odProdDe      Var _cdProdDe  F3 'SB1'   Size 60,08 Pixel of oUp
	@ 012 - 08,110 + 000 MsGet odProdAte     Var _cdProdAte F3 'SB1'   Size 60,08 Pixel of oUp

	@ 027 - 08,007 + 000 Say "Grupo: "                                 Size 50,10 Pixel Of oUp
	@ 027 - 08,045 + 000 MsGet odGrupoDe   Var _cdGrupoDe  F3 'SBM'    Size 60,08 Pixel of oUp
	@ 027 - 08,110 + 000 MsGet odGrupoAte  Var _cdGrupoAte F3 'SBM'    Size 60,08 Pixel of oUp

	@ 042 - 08,007 + 000 Say "Tipos: "                                 Size 50,10 Pixel Of oUp
	@ 042 - 08,045 + 000 MsGet odTipoDe    Var _cdTipoDe   F3 '02 '    Size 60,08 Pixel of oUp
	@ 042 - 08,110 + 000 MsGet odTipoAte   Var _cdTipoAte  F3 '02 '    Size 60,08 Pixel of oUp

	@ 012 - 08,007 + 190 Say "Ferramenta: "                            Size 50,10 Pixel Of oUp
	@ 012 - 08,045 + 190 MsGet odFerraDe      Var _cdFerraDe  F3 'SZH' Size 60,08 Pixel of oUp
	@ 012 - 08,110 + 190 MsGet odFerraAte     Var _cdFerraAte F3 'SZH' Size 60,08 Pixel of oUp
                                                                                      
	@ 027 - 08,007 + 190 Say "Armazem: "                               Size 50,10 Pixel Of oUp
	@ 027 - 08,045 + 190 MsGet odLocalDe    Var _cdLocalDe   F3 'AL '  Size 60,08 Pixel of oUp
	@ 027 - 08,110 + 190 MsGet odLocalAte   Var _cdLocalAte  F3 'AL '  Size 60,08 Pixel of oUp

	@ 042 - 08,007 + 190 Say "Meses Estoque: "                         Size 50,10 Pixel Of oUp
	@ 042 - 08,045 + 190 MsGet odMeses    Var _cdMeses                 Size 60,08 Pixel of oUp
	//@ 042 - 08,110 + 000 MsGet odTipoAte   Var _cdTipoAte  F3 '02 '    Size 60,08 Pixel of oUp
                                                                                      

	@ 010 - 08,360 + 020 TO 053,510 label "Filiais" OF oDlg	 PIXEL
	@ 020 - 08,200 + 190  CHECKBOX _oChk01 VAR _lChk01 PROMPT "00 - Matriz 06200" SIZE 80,9 PIXEL OF oUp
	@ 020 - 08,260 + 190  CHECKBOX _oChk02 VAR _lChk02 PROMPT "01 - Matriz 06300" SIZE 80,9 PIXEL OF oUp
	@ 030 - 08,200 + 190  CHECKBOX _oChk03 VAR _lChk03 PROMPT "02 - Matriz 04208" SIZE 80,9 PIXEL OF oUp
	@ 030 - 08,260 + 190  CHECKBOX _oChk04 VAR _lChk04 PROMPT "03 - Filial 04 "   SIZE 80,9 PIXEL OF oUp
	@ 040 - 08,200 + 190  CHECKBOX _oChk05 VAR _lChk05 PROMPT "04 - Filial 02"    SIZE 80,9 PIXEL OF oUp
	@ 040 - 08,260 + 190  CHECKBOX _oChk06 VAR _lChk06 PROMPT "05 - Deposito"     SIZE 80,9 PIXEL OF oUp

	@ 010,10 Button "&Consultar" Size 40,12 Pixel of oUp2 Action MsgRun('Filtrando Dados...' ,,{||  _Consulta()  })
	@ 024,10 Button "&Fechar"    Size 40,12 Pixel of oUp2 Action oDlg:End()

	oBrowse := FWBrowse():New()

	oBrowse:SetDataArray()
	oBrowse:SetColumns(_adCabec)
	oBrowse:SetArray(_adDados)
	oBrowse:SetOwner(oMiddle)
	oBrowse:SetDoubleClick( {||  u_AACOME3A(  _adDados[oBrowse:At()][02]  )   } )
	oBrowse:Activate()

	oDlg:Activate()

	Return

Static Function _Consulta()
	GetData()
	oBrowse:SetArray(_adDados)
	oBrowse:nLen := Len(_adDados)
  //oBrowse:nAt  := If( Len(_adDados) > 0, 01,0)
	oBrowse:Refresh()
	Return Nil
Static Function GetData()

	Private _cdTab

	_cdTab := getSql()
	_adStr := (_cdTab)->(dbStruct())
	_adCab := {}
	SX3->(dbSetOrder(2))
/*                                      FVNCIONAL
If !(_cdTab)->(Eof())
For nI := 1 To Len(_adStr)
If SX3->(dbSeek(_adStr[nI][01]))
aAdd(_adCab,{ SX3->X3_TITULO  , &("{||  _adDados[oBrowse:At()," + StrZero(nI + 0 ,2) + "] }")  , SX3->X3_TIPO, SX3->X3_PICTURE , 1 , 06 , SX3->X3_DECIMAL,,,,,,  })
Else
_ndPos := aScan(_adPvt,{|x|  Alltrim(StrTran( subStr(_adStr[nI][01],2),'_','') ) $ AllTrim(x[01]) })
If _ndPos > 0
aAdd(_adCab,{  _adPvt[_ndPos][02] , &("{|| _adDados[oBrowse:At()," + StrZero(nI + 0,2) + "] }") , "N", "@E 999,999,999.99" , 1 , 8 ,2 ,,,,,,  })
Else
aAdd(_adCab,{  _adStr[nI][01] , &("{|| _adDados[oBrowse:At()," + StrZero(nI + 0,2) + "] }") , "N", "@E 999,999,999.99" , 1 , 8 ,2 ,,,,,,  })
EndIf
EndIF
Next
EndIF
*/
   

	awDesc := {"", "", "", "", "", ""}

	
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
		
		If _cdMes = 1 
		 		awDesc[nI] := "Janeiro"
			ElseIf _cdMes = 2
		 		awDesc[nI] := "Fevereiro"			
			ElseIf _cdMes = 3
		 		awDesc[nI] := "Março"			
			ElseIf _cdMes = 4
		 		awDesc[nI] := "Abril"			
			ElseIf _cdMes = 5
		 		awDesc[nI] := "Maio"			
			ElseIf _cdMes = 6
		 		awDesc[nI] := "Junho"			
			ElseIf _cdMes = 7
		 		awDesc[nI] := "Julho"
			ElseIf _cdMes = 8
		 		awDesc[nI] := "Agosto"			
			ElseIf _cdMes = 9
		 		awDesc[nI] := "Setembro"			
			ElseIf _cdMes = 10
		 		awDesc[nI] := "Outubro"			
			ElseIf _cdMes = 11
		 		awDesc[nI] := "Novembro"			
			Else
		 		awDesc[nI] := "Dezembro"			
		ENdIf 
	Next

//aAdd(_adCab,{ "Filial "  , {||  _adDados[oBrowse:At(),01] })  ,"C", "@!" ,  1 , 02 , 0,,,,,,  })
//aAdd(_adCab,{ "Ferramenta "    , {||  _adDados[oBrowse:At(),01] }  ,"C", "@!" ,  1 , 02 , 0,,,,,,  })
	aAdd(_adCab,{ "Produto"         , {||  _adDados[oBrowse:At(),02] }  ,"C", "@!" ,  1 , 02 , 0,,,,,,  })
	aAdd(_adCab,{ "Especificação"  , {||  _adDados[oBrowse:At(),03] }  ,"C", "@!" ,  1 , 02 , 0,,,,,,  })
	aAdd(_adCab,{ awDesc[1]        , {||  _adDados[oBrowse:At(),04] }  ,"N", "@E 999,999,999.99" ,  2 , 08 , 2,,,,,,  })
	aAdd(_adCab,{ awDesc[2]         , {||  _adDados[oBrowse:At(),05] }  ,"N", "@E 999,999,999.99" ,  2 , 08 , 2,,,,,,  })
	aAdd(_adCab,{ awDesc[3]         , {||  _adDados[oBrowse:At(),06] }  ,"N", "@E 999,999,999.99" ,  2 , 08 , 2,,,,,,  })
	aAdd(_adCab,{ awDesc[4]         , {||  _adDados[oBrowse:At(),07] }  ,"N", "@E 999,999,999.99" ,  2 , 08 , 2,,,,,,  })
	aAdd(_adCab,{ awDesc[5]         , {||  _adDados[oBrowse:At(),08] }  ,"N", "@E 999,999,999.99" ,  2 , 08 , 2,,,,,,  })
	aAdd(_adCab,{ awDesc[6]         , {||  _adDados[oBrowse:At(),09] }  ,"N", "@E 999,999,999.99" ,  2 , 08 , 2,,,,,,  })

	aAdd(_adCab,{ "Pedido"            , {||  _adDados[oBrowse:At(),10] }  ,"N", "@E 999,999,999.99" ,  2 , 08 , 2,,,,,,  })
	aAdd(_adCab,{ "Saldo"             , {||  _adDados[oBrowse:At(),11] }  ,"N", "@E 999,999,999.99" ,  2 , 08 , 2,,,,,,  })
	aAdd(_adCab,{ "Sugestão"          , {||  _adDados[oBrowse:At(),12] }  ,"N", "@E 999,999,999.99" ,  2 , 08 , 2,,,,,,  })
	aAdd(_adCab,{ "Projeção Estoque"  , {||  _adDados[oBrowse:At(),13] }  ,"C", "@!"                ,  1 , 08 , 2,,,,,,  })
	aAdd(_adCab,{ "Media"             , {||  _adDados[oBrowse:At(),14] }  ,"N", "@E 999,999,999.99" ,  2 , 08 , 2,,,,,,  })

	_adData := {}
	While !(_cdTab)->(Eof())
	
		_adLin := {}
		For nI := 1 To Len(_adStr)
			aAdd(_adLin, (_cdTab)->&(_adStr[nI][01]) )
		Next
	
		aAdd(_adData, _adLin)
	
		(_cdTab)->(dbSkip())
	EndDo

	_adCabec := aClone(_adCab)
	_adDados := aClone(_adData)

	Return _adData


Static Function GetSql()

	_cdTbl := GetNextAlias()
	_cdQry := ""

	_cdFil := ''
	If _lChk01
		_cdFil += iIF( Empty(_cdFil) ,"", ",") + "00"
	EndIf

	If _lChk02
		_cdFil += iIF( Empty(_cdFil) ,"", ",") + "01"
	EndIf

	If _lChk03
		_cdFil += iIF( Empty(_cdFil) ,"", ",") + "02"
	EndIf

	If _lChk04
		_cdFil += iIF( Empty(_cdFil) ,"", ",") + "03"
	EndIf

	If _lChk05
		_cdFil += iIF( Empty(_cdFil) ,"", ",") + "04"
	EndIf

	If _lChk06
		_cdFil += iIF( Empty(_cdFil) ,"", ",") + "05"
	EndIf

	cMES01 := ""
	cMES02 := ""
	cMES03 := ""
	cMES04 := ""
	cMES05 := ""
	cMES06 := ""

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

   // Modificado para a procedure para deixar mais rapido
    _cdQry := " Exec AA_SUGESTAOCOMPRA 
    _cdQry += " '" + _cdProdDe  + "' , '" + _cdProdAte  + "',"
    _cdQry += " '" + _cdGrupoDe + "' , '" + _cdGrupoAte + "'," 
    _cdQry += " '" + _cdTipoDe  + "' , '" + _cdTipoAte  + "',"
    _cdQry += " '" + _cdFerraDe + "' , '" + _cdFerraAte + "'," + alltrim( STR (_cdMeses)) 
     
	Memowrite('AACOME03.SQL',_cdQry)

	dbUseArea(.T., "TOPCONN", tcGenQry(,,_cdQry), _cdTbl , .T., .T.)

	Return _cdTbl


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

User Function AACOME3A(_xProd)
    
    Local _adCons := {Nil,{} , {} }
    
    _adCons[03] := aClone(_getOpenPc(_xProd))
    
    odPcs := MSDialog():New(0, 0, 430, 920,'Pedidos de Compras',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
    
    
    odPLayer := FWLAYER():New()
	odPLayer:Init(odPcs,.T.)

	odPLayer:AddLine('UP',10)
	odPLayer:AddLine('MIDDLE',80)
	odPLayer:AddLine('DOWN',10)

	odPLayer:AddColumn('ALL' ,080,,'UP')
	odPLayer:AddColumn('ALL' ,100,,'MIDDLE')

	odPLayer:AddColumn('ALL2' ,020,,'UP')

	oPUp      := odPLayer:GetColPanel('ALL','UP')
	oPUp2     := odPLayer:GetColPanel('ALL2','UP')
	oPMiddle  := odPLayer:GetColPanel('ALL','MIDDLE')
	
	oFont := TFont():New('Courier new',,-18,.T.)
	TSay():New(05,05,{||' Produto : ' + _xProd + '/' + Posicione('SB1',1,xFilial('SB1') + _xProd, 'B1_DESC') },oPUp,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,200,20)
	
	aAdd(_adCons[02],{ "Pedido "         , {||  _adCons[03][_adCons[01]:At(),02] }  ,"C", "@!" ,  1 , 08 , 0,,,,,,  })
	aAdd(_adCons[02],{ "Quantidade "     , {||  _adCons[03][_adCons[01]:At(),03] }  ,"N", "@e 999,999,999.99" ,  2 , 12 , 4,,,,,,  })
	aAdd(_adCons[02],{ "Qtd.Entregue"    , {||  _adCons[03][_adCons[01]:At(),04] }  ,"N", "@e 999,999,999.99" ,  2 , 12 , 4,,,,,,  })
	aAdd(_adCons[02],{ "Saldo "          , {||  _adCons[03][_adCons[01]:At(),05] }  ,"N", "@e 999,999,999.99" ,  2 , 12 , 4,,,,,,  })
	aAdd(_adCons[02],{ "Valor  "         , {||  _adCons[03][_adCons[01]:At(),06] }  ,"N", "@e 999,999,999.99" ,  2 , 12 , 4,,,,,,  })
	aAdd(_adCons[02],{ "Total "          , {||  _adCons[03][_adCons[01]:At(),07] }  ,"N", "@e 999,999,999.99" ,  2 , 12 , 4,,,,,,  })
	
	_adCons[01] := FWBrowse():New()

	_adCons[01]:SetDataArray()
	_adCons[01]:SetColumns( _adCons[02] )
	_adCons[01]:SetArray( _adCons[03] )
	_adCons[01]:SetOwner( oPMiddle )	
	_adCons[01]:Activate()
        
    odPcs:Activate(,,,.T.,{|| },,{|| EnchoiceBar(odPcs,{|| odPcs:End() },{|| odPcs:End() } )  } )
    
    //DEFINE MSDIALOG oWindow TITLE "Pedidos de Venda" FROM 0,0 TO 430,920 PIXEL

Return Nil
