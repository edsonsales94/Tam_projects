//-------------------------------------------------------. 
// Declaração das bibliotecas utilizadas no programa      |
//-------------------------------------------------------'
#include "Protheus.ch"
#include "RwMake.ch"
#include "TBICONN.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATP08   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 16/05/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Consulta Romaneio - alterado por Wermeson Gadelha conforme    ¦¦¦
¦¦¦  (Cont)   ¦ solicitado pelo Sr. Valdeinir em 16/05/2013                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/  /*2013143823091*/
User function AAFATP08()

 //-------------------------------------------------------. 
 // Declaração das variaveis locais                        |
 //-------------------------------------------------------'
	Local _aCabec            := {'', 'Romaneio','Dt. Romaneio','Balança Ini', 'DT Peso Ent', 'Hr. Peso Ent','Balança Fim', 'DT Peso Sai', 'Hr. Peso Sai', 'Ticket','Peso Nota','Peso Balanca','Operador', 'Motorista','Placa Veiculo','Observacao','Ajudante 1','Ajudante 2', 'Placa Carro'}

								
 //-------------------------------------------------------. 
 // Declaração das variaveis privates - Objetos            |
 //-------------------------------------------------------'		
	Private _oJanela         := Nil
	Private _oDatIni         := Nil
	Private _oDatFim         := Nil
	Private _oCliIni         := Nil
	Private _oCliFim         := Nil
	Private _oPesoT          := Nil
	Private _oPesoN          := Nil
	Private _oTipo           := Nil
	Private _oTipo2          := Nil
	Private _oTipo3          := Nil
	Private oBrowse          := Nil

 //-------------------------------------------------------. 
 // Declaração das variaveis privates - Variaveis          |
 //-------------------------------------------------------'		                         
	Private _dDataInicial    := dDataBase
	Private _dDataFinal      := dDataBase                  
	Private _cClienteIni     := Space(Len(SA1->A1_COD))
	Private _cClienteFim     := replicate('z',Len(SA1->A1_COD))
	Private _cTipo           := "Sim"
	Private _cTipo2          := "Ambos"
	Private _cTipo3          := "Todas"
	Private nPesoTotal       := 0
	Private nPesoVarejo      := 0
	Private nPesoAtacado     := 0
	Private nPesoSilves      := 0
	Private nPesoPuraca      := 0
	Private nPesoDistrito    := 0
 
  //-------------------------------------------------------. 
 // Declaração das variaveis privates - Checkbox           |
 //-------------------------------------------------------'		
	Private _oChk02, _lChk02 :=.T.
	Private _oChk03, _lChk03 :=.T.
	Private _oChk04, _lChk04 :=.T.
	Private _oChk05, _lChk05 :=.T.
	Private _oChk06, _lChk06 :=.T.
	Private _oChk07, _lChk07 :=.T.
	Private _oChk08, _lChk08 :=.T.
	Private _oChk09, _lChk09 :=.T.
	Private _oChk10, _lChk10 :=.F.

 //-------------------------------------------------------. 
 // Declaração das variaveis privates - Arrays             |
 //-------------------------------------------------------'		
	Private aItems   := {}
	Private aBalan   := {}
	Private aTipos   := {}
	Private _aBrowse := {}
	Private aLeg     :=  { {"P" , "BR_PINK"},;
		{"R" , "BR_AMARELO"},;
		{"B" , "BR_CINZA"},;
		{"E" , "BR_VERMELHO"},;
		{"V" , "BR_LARANJA"},;
		{"N" , "BR_AZUL"},;
		{"F" , "BR_BRANCO"},;
		{"D" , "BR_PRETO"},;
		{"S" , "BR_MARROM"} , ;   
		{"X" , "PMSEDT1"  } , ;   		
		{" " , "ENABLE" } }
	
 
	   
	//-------------------------------------------------------. 
	// Array com as cores das legendas                        |
	//-------------------------------------------------------'		
	_aCores := {{'_aBrowse[oBrowse:nAt][01] = "P" ',"BR_PINK"	 },;	// PRÉ-ROMANEIO
	{'_aBrowse[oBrowse:nAt][01] = "R" ',"BR_AMARELO" },;	// EM ROMANEIO
	{'_aBrowse[oBrowse:nAt][01] = "B" ',"BR_CINZA"   },;	// VEM BUSCAR NA LOJA
	{'_aBrowse[oBrowse:nAt][01] = "E" ',"BR_VERMELHO"},;	// ENTREGUE
	{'_aBrowse[oBrowse:nAt][01] = "V" ',"BR_LARANJA" },;	// NOVA ENTREGUE
	{'_aBrowse[oBrowse:nAt][01] = "N" ',"BR_AZUL"    },;	// ENDERECO NAO ENCONTRADO
	{'_aBrowse[oBrowse:nAt][01] = "F" ',"BR_BRANCO"  },;	// LOCAL FECHADO
	{'_aBrowse[oBrowse:nAt][01] = "D" ',"BR_PRETO"   },;	// DEVOLUCAO
	{'_aBrowse[oBrowse:nAt][01] = "X" ',"PMSEDT1"    },;	// LIBERACAO SPECIAL 
	{'_aBrowse[oBrowse:nAt][01] = "S" ',"BR_MARROM"  } } 	// ESTORNO DE VENDA
	
	//-------------------------------------------------------. 
	// Array com as cores das legendas                        |
	//-------------------------------------------------------'		
	_aLegenda := {{"BR_PINK"    , "Pré-Romaneio"},;
		{"BR_AMARELO" , "Romaneio"    },;
		{"BR_VERMELHO", "Entregue"    },;
		{"BR_LARANJA" , "Nova Entrega"},;
		{"BR_CINZA"   , "Vem Buscar"  },;
		{"BR_AZUL"    , "Endereço não encontrado"},;
		{"BR_PRETO"   , "Venda com Devolução"},;
		{"BR_MARROM"  , "Venda Estornada do Romaneio"},;
		{"PMSEDT1"    , "Liberação Especial"},;		
		{"BR_BRANCO"  , "Local Fechado"}}

	//-------------------------------------------------------. 
	// itens do combobox                                      |
	//-------------------------------------------------------'		
	AADD(aItems,"Sim")
	AADD(aItems,"Nao")
	AADD(aItems,"Somente")


	//-------------------------------------------------------. 
	// itens do combobox                                      |
	//-------------------------------------------------------'		
	AADD(aTipos,"Varejo")
	AADD(aTipos,"Atacado")
	AADD(aTipos,"Ambos")
	
	
	//-------------------------------------------------------. 
	// itens do combobox                                      |
	//-------------------------------------------------------'		
	AADD(aBalan,"Puraquequara")
	AADD(aBalan,"Silves")
	AADD(aBalan,"Distrito")
	AADD(aBalan,"Todas")

	//-------------------------------------------------------. 
	// Chamada da rotina para filtrar os dados                |
	//-------------------------------------------------------'		
	Processa({|| GetInf(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal, 1)},'Filtrando Dados' )
		
	//-------------------------------------------------------. 
	// Inicializando as variaveis de pesagem                  |
	//-------------------------------------------------------'		
	nPesoTotal    := 0
	nPesoVarejo   := 0
	nPesoAtacado  := 0
	nPesoSilves   := 0
	nPesoPuraca   := 0
	nPesoDistrito := 0
	
	//-------------------------------------------------------. 
	// Calculo de peso                                        |
	//-------------------------------------------------------'		
	CalcPesoDiv( _cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal, "" )
	
	//-------------------------------------------------------. 
	// PesoTotal                                              |
	//-------------------------------------------------------'		
	nPesoTotal := PesoTotal(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal, "")
	
	Private oLayer := Nil
	Private aCoors := FwGetDialogSize(oMainWnd)//MsAdvSize()
	//-------------------------------------------------------. 
	// Cadastrando a fonte que serã utiizada na tela          |
	//-------------------------------------------------------'		
	oFont := TFont():New('Courier new',,-12,.T.)
	
	//-------------------------------------------------------. 
	// Montagem da tela de consulta romaneio                  |
	//-------------------------------------------------------'
	_oJanela  := MSDialog():New(aCoors[1], aCoors[2],aCoors[3], aCoors[4],"Consulta Romaneio",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	oLayer := FWLAYER():New()
	oLayer:Init(_oJanela,.F.,.T.)
	oLayer:AddLine('UP',25)
	oLayer:AddLine('MIDDLE',65)
	oLayer:AddLine('DOWN',10)

	oLayer:AddColumn('ALL' ,080,,'UP')
	oLayer:AddColumn('ALL' ,100,,'MIDDLE')
	oLayer:AddColumn('ALL' ,100,,'DOWN')

//oLayer:AddColumn('ALL' ,80,,'UP')
	oLayer:AddColumn('ALL2' ,20,,'UP')

	_oUp      := oLayer:GetColPanel('ALL','UP'    )
	_oUp2     := oLayer:GetColPanel('ALL2','UP'    )

	_oMiddle  := oLayer:GetColPanel('ALL','MIDDLE')
	_oDown    := oLayer:GetColPanel('ALL','DOWN'  )

	aCoors := MsAdvSize()
	//DEFINE DIALOG _oJanela TITLE "Consulta Romaneio" FROM 001,001 TO 550,1000 PIXEL
		
	@ 003,005 TO 70,420 label "Filtros" OF _oUp PIXEL
		
	@ 015,007 Say "Data de Saida" Size 50,10 Pixel Of _oUp
	@ 015,057 MsGet _oDatIni Var _dDataInicial Size 60,08 Pixel of _oUp
	@ 015,130 MsGet _oDatFim Var _dDataFinal   Size 60,08 Pixel of _oUp
		
	@ 030,007 Say "Cliente" Size 50,10 Pixel Of _oUp
	@ 030,057 MsGet _oClienteIni Var _cClienteIni F3 'SA1' Size 60,08 Pixel of _oUp
	@ 030,130 MsGet _oClienteFim Var _cClienteFim F3 'SA1' Size 60,08 Pixel of _oUp
	
	@ 045,007 Say "Considerar cliente AmazonAço :"  Size 090,10 Pixel Of _oUp
	@ 055,057 MSCOMBOBOX _oTipo  VAR _cTipo  ITEMS aItems SIZE 060,50 OF _oUp PIXEL
	
	@ 045,130 Say "Tipo Venda  :"  Size 090,10 Pixel Of _oUp
	@ 055,130 MSCOMBOBOX _oTipo2 VAR _cTipo2 ITEMS aTipos SIZE 060,50 OF _oUp PIXEL
	
	@ 045,210 Say "Balancas    :"  Size 090,10 Pixel Of _oUp
	@ 055,210 MSCOMBOBOX _oTipo3 VAR _cTipo3 ITEMS aBalan SIZE 060,50 OF _oUp PIXEL
			
	@ 010,280 CHECKBOX _oChk02 VAR _lChk02 PROMPT "Pré-Romaneio" 				SIZE 80,9 PIXEL OF _oUp
	@ 020,280 CHECKBOX _oChk03 VAR _lChk03 PROMPT "Romaneio"     				SIZE 80,9 PIXEL OF _oUp
	@ 030,280 CHECKBOX _oChk05 VAR _lChk05 PROMPT "Entregue"                SIZE 80,9 PIXEL OF _oUp	
	@ 040,280 CHECKBOX _oChk04 VAR _lChk04 PROMPT "Vem Buscar"              SIZE 80,9 PIXEL OF _oUp
	
	@ 020,340 CHECKBOX _oChk06 VAR _lChk06 PROMPT "End não encontrado"      SIZE 80,9 PIXEL OF _oUp
	@ 030,340 CHECKBOX _oChk07 VAR _lChk07 PROMPT "Nova Entrega"            SIZE 80,9 PIXEL OF _oUp			
	@ 010,340 CHECKBOX _oChk08 VAR _lChk08 PROMPT "Devolução"               SIZE 80,9 PIXEL OF _oUp
	@ 040,340 CHECKBOX _oChk09 VAR _lChk09 PROMPT "Local Fechado"           SIZE 80,9 PIXEL OF _oUp
	@ 030,390 CHECKBOX _oChk10 VAR _lChk10 PROMPT "Liberacao Especial"      SIZE 80,9 PIXEL OF _oUp
	                                                     
	@ 010,015 Button "&Consultar" Size 40,13 Pixel of _oUp2 Action MsgRun('Filtrando Dados...' ,,{|| GetInf(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal, 2), oBrowse:Refresh() })
	@ 025,015 Button "&Legenda"   Size 40,13 Pixel of _oUp2 Action BrwLegenda("Cadastro de Romaneio","Legendas",_aLegenda)
	@ 010,060 Button "&Exportar"  Size 40,13 Pixel of _oUp2 Action MsgRun('Exportando Excel...',,{|| ExportaExcel(_aBrowse), oBrowse:Refresh() })
	@ 025,060 Button "&Fechar"    Size 40,13 Pixel of _oUp2 Action _oJanela:End()
		
		
		//@ 075,005 TO 215,600 label "Dados" OF _oJanela PIXEL
		
//	oBrowse := TcBrowse():New ( 080,007,490,160 , , _aCabec,/*[ aColSizes]*/           , _oJanela, /*[ cField]*/,  , , /*[ bChange]*/, /*[ bLDblClick]*/, /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/,  cAlias /*cAlias*/, /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )	   
//	oBrowse := TcBrowse():New ( 080,007,490,160 , , _aCabec,/*[ aColSizes]*/           , _oJanela, /*[ cField]*/,  , , /*[ bChange]*/, /*[ bLDblClick]*/, /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/,         /*cAlias*/, /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )
	oBrowse := FWBrowse():New()
	oBrowse:SetDataArray()
	oBrowse:AddStatusColumns(  { || _aCores[aScan(_aCores,{|x| &(x[01]) })][02] }, {||} )

	_adCabec := {}
	
	aAdd(_adCabec,{ _aCabec[02]  , {|| _aBrowse[oBrowse:At()][02] }  , 'C' ,  '@!' , 1 , 02, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[03]  , {|| _aBrowse[oBrowse:At()][03] }  , 'D' ,  '  ' , 0 , 08, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[04]  , {|| _aBrowse[oBrowse:At()][04] }  , 'C' ,  '@!' , 1 , 05, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[05]  , {|| _aBrowse[oBrowse:At()][05] }  , 'D' ,  '  ' , 0 , 08, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[06]  , {|| _aBrowse[oBrowse:At()][06] }  , 'C' ,  '@!' , 1 , 05, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[07]  , {|| _aBrowse[oBrowse:At()][07] }  , 'C' ,  '@!' , 1 , 06, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[08]  , {|| _aBrowse[oBrowse:At()][08] }  , 'D' ,  '@!' , 0 , 08, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[09]  , {|| _aBrowse[oBrowse:At()][09] }  , 'C' ,  '@!' , 1 , 05, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[10]  , {|| _aBrowse[oBrowse:At()][10] }  , 'C' ,  '@!' , 1 , 05, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[11]  , {|| _aBrowse[oBrowse:At()][11] }  , 'N' ,  '@E 999,999,999.99' , 2 , 12, 2 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[12]  , {|| _aBrowse[oBrowse:At()][12] }  , 'N' ,  '@E 999,999,999.99' , 2 , 12, 2 ,,,,,,  })
	aAdd(_adCabec,{ 'Dif. '      , {||  - _aBrowse[oBrowse:At()][12] + _aBrowse[oBrowse:At()][11] }  , 'N' ,  '@E 999,999,999.99' , 2 , 12, 2 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[13]  , {|| _aBrowse[oBrowse:At()][13] }  , 'C' ,  '@!' , 1 , 10, 2 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[14]  , {|| _aBrowse[oBrowse:At()][14] }  , 'C' ,  '@!' , 1 , 10, 2 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[15]  , {|| _aBrowse[oBrowse:At()][15] }  , 'C' ,  '@!' , 1 , 05, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[16]  , {|| _aBrowse[oBrowse:At()][16] }  , 'C' ,  '@!' , 1 , 25, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[17]  , {|| _aBrowse[oBrowse:At()][17] }  , 'C' ,  '@!' , 1 , 10, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[18]  , {|| _aBrowse[oBrowse:At()][18] }  , 'C' ,  '@!' , 1 , 10, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[19]  , {|| _aBrowse[oBrowse:At()][19] }  , 'C' ,  '@!' , 1 , 10, 0 ,,,,,,  })

	oBrowse:SetArray(_aBrowse)
	oBrowse:SetColumns(_adCabec)
	oBrowse:SetBlkBackColor( {|| iIf( _aBrowse[oBrowse:At()][12] > _aBrowse[oBrowse:At()][11]  , CLR_YELLOW ,  )  } )
	/*
	oBrowse:bLine := {|| { LoadBitmap(GetResources(),_aCores[aScan(_aCores,{|x| &(x[01]) })][02] ) ,;
		,;
		_aBrowse[oBrowse:nAt][03] ,;
		_aBrowse[oBrowse:nAt][04] ,;
		_aBrowse[oBrowse:nAt][05] ,;
		_aBrowse[oBrowse:nAt][06] ,;
		_aBrowse[oBrowse:nAt][07] ,;
		_aBrowse[oBrowse:nAt][08] ,;
		_aBrowse[oBrowse:nAt][09] ,;
		_aBrowse[oBrowse:nAt][10] ,;
		_aBrowse[oBrowse:nAt][11] ,;
		_aBrowse[oBrowse:nAt][12] ,;
		_aBrowse[oBrowse:nAt][13] ,;
		_aBrowse[oBrowse:nAt][14] ,;
		_aBrowse[oBrowse:nAt][15] ,;
		_aBrowse[oBrowse:nAt][16] ,;
		_aBrowse[oBrowse:nAt][17] ,;
		_aBrowse[oBrowse:nAt][18] }}
*/
	 oBrowse:Refresh()
	//oBrowse:BLDBLCLICK :=
	oBrowse:SetDoubleClick(   {||  _dblClick()  }  )
	oBrowse:setOwner(_oMiddle)
	oBrowse:Activate()
	//oBrowse:nScrollType := 0 // Define a barra de rolagem VCR
		
	//@ 240,005 TO 270,500 label "Totais" OF _oJanela PIXEL
		
	@ 005,010 Say "Total Peso Balanca" Size 70,10 Pixel Of _oDown
	oPesoT:= TSay():New(015,010   ,{|| AllTrim(Transform(nPesoTotal                ,"@E 999,999,999,999,999.99") )},_oDown,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
		
	@ 005,085 Say "Total Notas"  Size 70,10 Pixel Of _oDown
	oPesoN:= TSay():New(015,085   ,{|| AllTrim(Transform(nPesoVarejo + nPesoAtacado,"@E 999,999,999,999,999.99") )},_oDown,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
		
	@ 005,155 Say "Varejo"  Size 70,10 Pixel Of _oDown
	oPesoV:= TSay():New(015,155   ,{|| AllTrim(Transform(nPesoVarejo               ,"@E 999,999,999,999,999.99") )},_oDown,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
		
	@ 005,230 Say "Atacado" Size 70,10 Pixel Of _oDown
	oPesoA:= TSay():New(015,230   ,{|| AllTrim(Transform(nPesoAtacado              ,"@E 999,999,999,999,999.99") )},_oDown,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)

	@ 005,305 Say "Balanca Silves"   Size 70,10 Pixel Of _oDown
	oPesoBal1:= TSay():New(015,305,{|| AllTrim(Transform(nPesoSilves               ,"@E 999,999,999,999,999.99") )},_oDown,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
		
	@ 005,380 Say "Balanca Puraquequara"   Size 70,10 Pixel Of _oDown
	oPesoBal2:= TSay():New(015,380,{|| AllTrim(Transform(nPesoPuraca               ,"@E 999,999,999,999,999.99") )},_oDown,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
		
	@ 005,455 Say "Balanca Distrito" Size 70,10 Pixel Of _oDown
	oPesoBal3:= TSay():New(015,455,{|| AllTrim(Transform(nPesoDistrito             ,"@E 999,999,999,999,999.99") )},_oDown,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
			
	Activate Dialog _oJanela Centered
	
	
	
	Return Nil

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ GetInf     ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 16/05/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Busca as informacoes a serem filtradas de acordo com os       ¦¦¦
¦¦¦  (Cont)   ¦ parametros da tela de romaneio.                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function GetInf(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal,nTipo)
	Local _cQry      := ''
	Local cCampos    := ''
	Local cTable     := GetNextALias()
	Private  cAuxStatus := "("
         
	_aBrowse := {}
					
	If _lChk02
		cAuxStatus += "'P',"
	EndIf
	If _lChk03
		cAuxStatus += "'R',"
	EndIf
	If _lChk04
		cAuxStatus += "'B',"
	EndIf
	If _lChk05
		cAuxStatus += "'E',"
	EndIf
	If _lChk06
		cAuxStatus += "'N',"
	EndIf
	If _lChk07
		cAuxStatus += "'V',"
	EndIf
	If _lChk08
		cAuxStatus += "'D',"
	EndIf
	If _lChk09
		cAuxStatus += "'F',"
	EndIf
	If _lChk10
		cAuxStatus += "'X',"
	EndIf
                                          
	If Len(AllTrim(cAuxStatus)) > 2
		cAuxStatus := SubStr( cAuxStatus, 1, Len(AllTrim(cAuxStatus)) -1 ) + ")"
	EndIf
	
	cCampos+= ' ZE_ROMAN, ZE_STATUS, MAX(ZE_CLIENTE) ZE_CLIENTE,MAX(ZE_LOJACLI) ZE_LOJACLI ,MAX(ZE_NOMCLI) ZE_NOMCLI, ' + Chr(13) + Chr(10)
	cCampos+= ' MAX(ZE_DTSAIDA) ZE_DTSAIDA,MAX(ZE_PLACA) ZE_PLACA,MAX(ZE_NOMOTOR) ZE_NOMOTOR,MAX(ZE_DTPESO) ZE_DTPESO,' + Chr(13) + Chr(10)
	cCampos+= ' MAX(ZE_AJUDA01) ZE_AJUDA01, MAX(ZE_AJUDA02) ZE_AJUDA02, SUM(ZE_PLIQUI) ZE_PLIQUI,'                      + Chr(13) + Chr(10)
	cCampos+= ' MAX(ZE_PESO) ZE_PESO, MAX(ZE_OBSERV) ZE_OBSERV, max(ZE_TICKET1) ZE_TICKET1, MAX (ZE_HRPESO) ZE_HRPESO,' + Chr(13) + Chr(10)

   // CAMPOS PROVENIENTES DO GUARDIAN 
	cCampos+= " MAX(CONVERT(Char(10),Tick_DtHrPesoInicial,112)) AS DPESOINI,"                                        + Chr(13) + Chr(10)
	cCampos+= " MAX(CONVERT(Char(10),Tick_DtHrPesoFinal  ,112)) AS DPESOFIM,"                                        + Chr(13) + Chr(10)
	cCampos+= " MAX(RIGHT('0'+CONVERT(VARCHAR,DATEPART(HOUR,Tick_DtHrPesoInicial)),2 )+':'+RIGHT('0'+CONVERT(VARCHAR,DATEPART(MINUTE,Tick_DtHrPesoInicial)),2)) AS HPESOINI, " + Chr(13) + Chr(10)
	cCampos+= " MAX(RIGHT('0'+CONVERT(VARCHAR,DATEPART(HOUR,Tick_DtHrPesoFinal  )),2 )+':'+RIGHT('0'+CONVERT(VARCHAR,DATEPART(MINUTE,Tick_DtHrPesoFinal  )),2)) AS HPESOFIM, " + Chr(13) + Chr(10)
	cCampos+= " MAX(ISNULL(Tick_BalPesoInicial,'')) AS BALANCA_I, MAX(ISNULL(Tick_PlacaVeiculo,'')) as TPLACA, MAX(ISNULL(Tick_BalPesoFinal, '')) AS BALANCA_F, MAX(ISNULL(Tick_OpPesoFinal,'')) AS OPERADOR " + Chr(13) + Chr(10)
                 
	                                                                     
	_cQry := " SELECT " + cCampos + " From "  + RetSqlName("SZE") + " SZE (NOLOCK)"                                     + Chr(13) + Chr(10)
   
	_cQry += "  LEFT JOIN "  + RetSqlName("SC5") + " SC5 (NOLOCK)"
	_cQry += "     ON SC5.D_E_L_E_T_ = '' AND SC5.C5_NUM = SZE.ZE_ORCAMEN AND SC5.C5_FILIAL = SZE.ZE_FILORIG "          + Chr(13) + Chr(10)
               
	_cQry += " INNER JOIN Guardian110.dbo.RegTick as BAL (NOLOCK) ON Tick_Sequencial = ZE_TICKET1  COLLATE Latin1_General_BIN  "
           
	_cQry += "  WHERE SZE.D_E_L_E_T_ = '' "                                                                             + Chr(13) + Chr(10)
	_cQry += "    AND ZE_CLIENTE BetWeen '" +       _cClienteIni   + "'And '" +      _cClienteFim + "'"              + Chr(13) + Chr(10)
	_cQry += "    AND SZE.ZE_DTSAIDA BetWeen '" + DTOS(_dDataInicial) + "'And '" + DTOS(_dDataFinal) + "'"              + Chr(13) + Chr(10)

	If Len(AllTrim(cAuxStatus)) > 2
		_cQry += " And ZE_STATUS  In " + cAuxStatus                                                                      + Chr(13) + Chr(10)
	EndIf
    
	If AllTrim(_cTipo) == "Nao"
		_cQry += " AND ZE_CLIENTE NOT IN "+FormatIn(GetMV("MV_XCLIAA"),",")                                           + Chr(13) + Chr(10)
	ElseIf AllTrim(_cTipo) == "Somente"
		_cQry += " AND ZE_CLIENTE     IN "+FormatIn(GetMV("MV_XCLIAA"),",")		                                      + Chr(13) + Chr(10)
	EndIf
   
	If AllTrim(_cTipo2) == "Atacado"
		_cQry += " AND LEN( RTRIM(C5_ORCRES) ) = 0  "                                                                 + Chr(13) + Chr(10)
	ElseIf AllTrim(_cTipo2) == "Varejo"
		_cQry += " AND LEN( RTRIM(C5_ORCRES) ) > 0  "                                                                 + Chr(13) + Chr(10)
	EndIf

	If AllTrim(_cTipo3) == "Silves"
		_cQry += " AND ISNULL(Tick_BalPesoFinal, '') = 'BAL_SILVES'   "                                                      + Chr(13) + Chr(10)
	ElseIf AllTrim(_cTipo3) == "Puraquequara"
		_cQry += " AND LEFT(ISNULL(Tick_BalPesoFinal, ''),9) = 'BAL_PURAQ'   "                                               + Chr(13) + Chr(10)
	ElseIf AllTrim(_cTipo3) == "Distrito"
		_cQry += " AND ISNULL(Tick_BalPesoFinal, '') = 'BAL_DISTRITO' "                                                      + Chr(13) + Chr(10)
	EndIf
              
	_cQry += " Group by ZE_ROMAN, ZE_STATUS  "   																							  + Chr(13) + Chr(10)
	_cQry += " Order By ZE_DTSAIDA, ZE_ROMAN, ZE_STATUS "  																				  + Chr(13) + Chr(10)
	
	cArqTrab := ''
	 
	MemoWrite("AAFATP08.sql",_cQry )

	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(_cQry)), cTable, .T., .T. )

	TCSetField(cTable,"ZE_DTSAIDA" ,"D",8,0)
	TCSetField(cTable,"ZE_DTPESO"  ,"D",8,0)
	TCSetField(cTable,"DPESOINI"   ,"D",8,0)
	TCSetField(cTable,"DPESOFIM"   ,"D",8,0)

	dbselectarea(cTable)

	(cTable)->(DBGOTOP())
	
	
	If (cTable)->(EOF())
	   
		aAdd( _aBrowse, { 'R'                  ,; //01
		' '                  ,; //02
		DATE()               ,; //03
		' '                  ,; //04
		DATE()               ,; //05
		' '                  ,; //06
		' '                  ,; //07
		DATE()               ,; //08
		' '                  ,; //09
		' '                  ,; //10
		0                    ,; //11
		0                    ,; //12
		' '                  ,; //13
		' '                  ,; //14
		' '                  ,; //15
		' '                  ,; //16
		' '                  ,; //17
		' '                  ,; //18
		' '                  }) //19
	EndIf
	
	        
	While !(cTable)->(EOF())



		If (cTable)->ZE_STATUS == "V" .Or.;
			(cTable)->ZE_STATUS == "N" .Or.;
			(cTable)->ZE_STATUS == "F" .Or.;
			(cTable)->ZE_STATUS == "D" .Or.;
			(cTable)->ZE_STATUS == "S"
         
			nwPesoBal := 0
		Else
			nwPesoBal := (cTable)->ZE_PESO
		EndIf

	 /*	aAdd( _aBrowse, { (cTable)->ZE_STATUS         ,; //01
		(cTable)->ZE_ROMAN          ,; //02
		DTOC( (cTable)->ZE_DTSAIDA) ,; //03
		(cTable)->BALANCA_I         ,; //04
		DTOC((cTable)->DPESOINI)    ,; //05
		(cTable)->HPESOINI          ,; //06
		(cTable)->BALANCA_F         ,; //07
		DTOC((cTable)->DPESOFIM)    ,; //08
		(cTable)->HPESOFIM          ,; //09
		(cTable)->ZE_TICKET1        ,; //10
		Transform((cTable)->ZE_PLIQUI,"@E 999,999,999.99")  ,; //11
		Transform(nwPesoBal,"@E 999,999,999.99")  ,; //12
		(cTable)->OPERADOR  	       ,; //13
		(cTable)->ZE_NOMOTOR        ,; //14
		(cTable)->ZE_PLACA          ,; //15
		(cTable)->ZE_OBSERV         ,; //16
		(cTable)->ZE_AJUDA01        ,; //17
		(cTable)->ZE_AJUDA02        ,; //18
		(cTable)->TPLACA            }) //19
	   */             
	   
	   aAdd( _aBrowse, { (cTable)->ZE_STATUS         ,; //01
		                  (cTable)->ZE_ROMAN          ,; //02
		                  DTOC( (cTable)->ZE_DTSAIDA) ,; //03
                  		(cTable)->BALANCA_I         ,; //04
                  		DTOC((cTable)->DPESOINI)    ,; //05
                  		(cTable)->HPESOINI          ,; //06
                  		(cTable)->BALANCA_F         ,; //07
                  		DTOC((cTable)->DPESOFIM)    ,; //08
                  		(cTable)->HPESOFIM          ,; //09
                  		(cTable)->ZE_TICKET1        ,; //10
                  		(cTable)->ZE_PLIQUI         ,; //11
                  		nwPesoBal                   ,; //12
                  		(cTable)->OPERADOR  	       ,; //13
                  		(cTable)->ZE_NOMOTOR        ,; //14
                  		(cTable)->ZE_PLACA          ,; //15
                  		(cTable)->ZE_OBSERV         ,; //16
                  		(cTable)->ZE_AJUDA01        ,; //17
                  		(cTable)->ZE_AJUDA02        ,; //18
                  		(cTable)->TPLACA            }) //19
	   	   
		(cTable)->(dbSkip())
	EndDo
	
	If nTipo == 2
			
		oBrowse:SetArray(_aBrowse)		
		oBrowse:nLen := Len(_aBrowse)

		oBrowse:Refresh()
	EndIf
	 
	(cTable)->(dbCLoseArea(cTable))
	
	//-------------------------------------------------------. 
	// Inicializando as variaveis de pesagem                  |
	//-------------------------------------------------------'		
	nPesoTotal    := 0
	nPesoVarejo   := 0
	nPesoAtacado  := 0
	nPesoSilves   := 0
	nPesoPuraca   := 0
	nPesoDistrito := 0

	CalcPesoDiv( _cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal, cAuxStatus )

	nPesoTotal := PesoTotal(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal, cAuxStatus)
	
	If Type("oPesoT") != "U"
		oPesoT:SetText    ( AllTrim( Transform(nPesoTotal                ,"@E 999,999,999,999,999.99") ) )
	EndIF
	If Type("oPesoV") != "U"
		oPesoV:SetText    ( AllTrim( Transform(nPesoVarejo               ,"@E 999,999,999,999,999.99") ) )
	EndIF
	If Type("oPesoA") != "U"
		oPesoA:SetText    ( AllTrim( Transform(nPesoAtacado              ,"@E 999,999,999,999,999.99") ) )
	EndIF
	If Type("oPesoN") != "U"
		oPesoN:SetText    ( AllTrim( Transform(nPesoAtacado + nPesoVarejo,"@E 999,999,999,999,999.99") ) )
	EndIF

	If Type("oPesoBal1") != "U"
		oPesoBal1:SetText ( AllTrim( Transform(nPesoSilves               ,"@E 999,999,999,999,999.99") ) )
	EndIF
	If Type("oPesoBal2") != "U"
		oPesoBal2:SetText ( AllTrim( Transform(nPesoPuraca               ,"@E 999,999,999,999,999.99") ) )
	EndIF
	If Type("oPesoBal3") != "U"
		oPesoBal3:SetText ( AllTrim( Transform(nPesoDistrito             ,"@E 999,999,999,999,999.99") ) )
	EndIF
		
	Return Nil

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CalcPesoDiv¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 16/05/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Busca as informacoes a serem filtradas de acordo com os       ¦¦¦
¦¦¦  (Cont)   ¦ parametros da tela de romaneio.                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CalcPesoDiv(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal, cAuxStatus)
	Local _cQry := ''
	
	_cQry += " select C5_ORCRES, SUM(PesoTotal)  PESOTOTAL From ("
	_cQry += " select case"
	_cQry += "           When Len(RTRIM(C5_ORCRES)) = 0 Then '1'"
	_cQry += "           else '2'"
	_cQry += "        End C5_ORCRES, Sum(B1_PESO * D2_QUANT) PesoTotal"
	_cQry += "    from " + RetSqlName('SZE') + " A"
	_cQry += "   INNER JOIN Guardian110.dbo.RegTick as BAL (NOLOCK) ON Tick_Sequencial = ZE_TICKET1  COLLATE Latin1_General_BIN  "
	_cQry += "    Left Outer Join " +  RetSqlName('SD2') + " On D2_FILIAL = ZE_FILORIG and D2_DOC = ZE_DOC and ZE_SERIE = D2_SERIE"
	_cQry += "    Left Outer Join " +  RetSqlName('SC5') + " on C5_NUM = D2_PEDIDO and D2_FILIAL = C5_FILIAL"
	_cQry += "    Left Outer Join " +  RetSqlName('SB1') + " on B1_COD = D2_COD"
	_cQry += " WHERE A.D_E_L_E_T_ = '' "
	_cQry += " ANd ZE_CLIENTE BetWeen '" + _cClienteIni + "'And '" + _cClienteFim + "'"
	_cQry += " And ZE_DTSAIDA BetWeen '" + DTOS(_dDataInicial) + "'And '" + DTOS(_dDataFinal) + "'"
	//_cQry += " And ZE_STATUS in ('R','E','B')"

	If AllTrim(_cTipo2) == "Atacado"
		_cQry += " AND LEN( RTRIM(C5_ORCRES) ) = 0  "                                                                 + Chr(13) + Chr(10)
	ElseIf AllTrim(_cTipo2) == "Varejo"
		_cQry += " AND LEN( RTRIM(C5_ORCRES) ) > 0  "                                                                 + Chr(13) + Chr(10)
	EndIf
		
	If AllTrim(_cTipo3) == "Silves"
		_cQry += " AND ISNULL(Tick_BalPesoFinal, '') = 'BAL_SILVES'   "                                                      + Chr(13) + Chr(10)
	ElseIf AllTrim(_cTipo3) == "Puraquequara"
		_cQry += " AND LEFT(ISNULL(Tick_BalPesoFinal, ''),9) = 'BAL_PURAQ'   "                                               + Chr(13) + Chr(10)
	ElseIf AllTrim(_cTipo3) == "Distrito"
		_cQry += " AND ISNULL(Tick_BalPesoFinal, '') = 'BAL_DISTRITO' "                                                      + Chr(13) + Chr(10)
	EndIf
    
	If AllTrim(_cTipo) == "Nao"
		_cQry += " AND ZE_CLIENTE NOT IN "+FormatIn(GetMV("MV_XCLIAA"),",")
	ElseIf AllTrim(_cTipo) == "Somente"
		_cQry += " AND ZE_CLIENTE IN "+FormatIn(GetMV("MV_XCLIAA"),",")
	EndIf

	If Len(AllTrim(cAuxStatus)) > 2
		_cQry += " And ZE_STATUS  In " + cAuxStatus
	EndIf
                                         
	_cQry += " group by C5_ORCRES"
	_cQry += " )A"
	_cQry += " group by C5_ORCRES"
	
	cTable := GetNextAlias()
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(_cQry)), cTable, .T., .T. )
	
	While !(cTable)->(EOF())
		if (cTable)->C5_ORCRES == '2'
			nPesoVarejo  += (cTable)->PESOTOTAL
		Else
			nPesoAtacado += (cTable)->PESOTOTAL
		EndIf
								
		(cTable)->(dbSkip())
	Enddo
	(cTable)->(dbCloseArea(cTable))
	
	Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PesoTotal  ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 16/05/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Busca as informacoes a serem filtradas de acordo com os       ¦¦¦
¦¦¦  (Cont)   ¦ parametros da tela de romaneio.                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PesoTotal(cCliIni, cCliFim, dDtIni, dDtFim, cAuxStatus )
	Local _cQry  := ''
	Local cTable := GetNextAlias()
	Local _aArea := GetArea()
	
	_cQry += " Select BALANCA, SUM(ZE_PESO) ZE_PESO   "                                                        + Chr(13) + Chr(10)
	_cQry += " From (  "                                                                                       + Chr(13) + Chr(10)
	_cQry += " select ZE_ROMAN, ISNULL(Tick_BalPesoFinal, '') as BALANCA, MAX(ZE_PESO) ZE_PESO from " + RetSqlName("SZE") + " SZE (NOLOCK)"  + Chr(13) + Chr(10)

	_cQry += "  INNER JOIN "  + RetSqlName("SC5") + " SC5 (NOLOCK)"                                            + Chr(13) + Chr(10)
	_cQry += "     ON SC5.D_E_L_E_T_ = '' AND SC5.C5_NUM = SZE.ZE_ORCAMEN AND SC5.C5_FILIAL = SZE.ZE_FILORIG " + Chr(13) + Chr(10)

	_cQry += " INNER JOIN Guardian110.dbo.RegTick as BAL (NOLOCK) ON Tick_Sequencial = ZE_TICKET1  COLLATE Latin1_General_BIN  "
   
	_cQry += " WHere SZE.D_E_L_E_T_ = '' "                                                                     + Chr(13) + Chr(10)
	_cQry += " ANd SZE.ZE_CLIENTE BetWeen '" + _cClienteIni + "'And '" + _cClienteFim + "'"                    + Chr(13) + Chr(10)
	_cQry += " And SZE.ZE_DTSAIDA BetWeen '" + DTOS(_dDataInicial) + "'And '" + DTOS(_dDataFinal) + "'"        + Chr(13) + Chr(10)
	    
	If AllTrim(_cTipo) == "Nao"
		_cQry += " AND ZE_CLIENTE NOT IN "+FormatIn(GetMV("MV_XCLIAA"),",")                                  + Chr(13) + Chr(10)
	ElseIf AllTrim(_cTipo) == "Somente"
		_cQry += " AND ZE_CLIENTE IN "+FormatIn(GetMV("MV_XCLIAA"),",")		                                + Chr(13) + Chr(10)
	EndIf

	If AllTrim(_cTipo2) == "Atacado"
		_cQry += " AND LEN( RTRIM(C5_ORCRES) ) = 0  "                                                        + Chr(13) + Chr(10)
	ElseIf AllTrim(_cTipo2) == "Varejo"
		_cQry += " AND LEN( RTRIM(C5_ORCRES) ) > 0  "                                                        + Chr(13) + Chr(10)
	EndIf
   
	If AllTrim(_cTipo3) == "Silves"
		_cQry += " AND ISNULL(Tick_BalPesoFinal, '') = 'BAL_SILVES'   "                                      + Chr(13) + Chr(10)
	ElseIf AllTrim(_cTipo3) == "Puraquequara"
		_cQry += " AND LEFT(ISNULL(Tick_BalPesoFinal, ''),9) = 'BAL_PURAQ'   "                               + Chr(13) + Chr(10)
	ElseIf AllTrim(_cTipo3) == "Distrito"
		_cQry += " AND ISNULL(Tick_BalPesoFinal, '') = 'BAL_DISTRITO' "                                      + Chr(13) + Chr(10)
	EndIf
                                                                                          	
	If Len(AllTrim(cAuxStatus)) > 2
		_cQry += " And ZE_STATUS  In " + cAuxStatus
	EndIf
	
	_cQry += " group by ZE_ROMAN, Tick_BalPesoFinal "                                                          + Chr(13) + Chr(10)
	_cQry += " ) A "
	_cQry += " group by BALANCA"                                                                                + Chr(13) + Chr(10)

	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(_cQry)), cTable, .T., .T. )
   

	nPesoTotal    := 0
	nPesoPuraca   := 0
	nPesoSilves   := 0
	nPesoDistrito := 0
	
	While !(cTable)->(EOF())
	
		nPesoTotal += (cTable)->ZE_PESO
	
		IF SubStr( (cTable)->BALANCA, 1,9 ) == 'BAL_PURAQ'
			nPesoPuraca   += (cTable)->ZE_PESO
				
		ElseIf AllTrim( (cTable)->BALANCA ) == 'BAL_SILVES'
			nPesoSilves   += (cTable)->ZE_PESO

		ElseIf AllTrim( (cTable)->BALANCA ) == 'BAL_DISTRITO'
			nPesoDistrito += (cTable)->ZE_PESO
		EndIf
		
		(cTable)->(dbSkip())
	Enddo
	
	(cTable)->(dbCloseArea(cTable))
	
	RestArea(_aArea)
	
	Return nPesoTotal


//************************************************************************************************************

Static Function _dblClick()
_odBrowse := oBrowse
_adBrowse := _aBrowse

U_AAFATP3A(_aBrowse[oBrowse:nAt][02], .T., _aBrowse[oBrowse:nAt][01] ) 

oBrowse := _odBrowse
_aBrowse := _adBrowse

oBrowse:SetArray(_aBrowse)
oBrowse:nLen := Len(_aBrowse)
oBrowse:Refresh()
Return Nil

Static Function ExportaExcel(aExport)
	Local i, j, nHdl, oExcelApp
	Local cArqTxt := GetTempPath()+"\aafatp08.xls"
	Local cLinha  := ""
	
	If File(cArqTxt)
		FErase(cArqTxt)
	Endif
	
	nHdl := fCreate(cArqTxt)
	
	cLinha += 'Staus'      + Chr(9) + 'Romaneio'      + Chr(9) + 'Dt. Romaneio' + Chr(9) + 'Balança Ini' + Chr(9) + 'DT Peso Ent'  + Chr(9) + 'Hr. Peso Ent'+ Chr(9) + 'Balança Fim' + Chr(9)
	cLinha += 'DT Peso Sai'+ Chr(9) + 'Hr. Peso Sai'  + Chr(9) + 'Ticket'       + Chr(9) + 'Peso Nota'   + Chr(9) + 'Peso Balanca' + Chr(9) + 'Operador'    + Chr(9)
	cLinha += 'Motorista'  + Chr(9) + 'Placa Veiculo' + Chr(9) + 'Observacao'   + Chr(9) + 'Ajudante 1'  + Chr(9) + 'Ajudante 2'   + Chr(9) + 'Placa Carro' + Chr(13) +Chr(10)
                
	If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
	EndIf
	
	For i:=1 to Len(aExport)
		cLinha := ""
		//    IncRegua()
		If ValType(aExport[i])<>"A"
			clinha += aExport[i]
		Else
			For j := 1 to Len(aExport[i])    
				If ValType(aExport[i][j]) == "D"
						cLinha += dToc(aExport[i][j])+Chr(9)
					ElseIf ValType(aExport[i][j]) == "N"
						cLinha += Transform(aExport[i][j], "@E 999,999,999,999,999.99")+Chr(9)
					Else 
						cLinha += aExport[i][j] + Chr(9)
				EndIf 
			Next
		Endif
		cLinha += chr(13)+chr(10)
		If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
		EndIf
	Next
	fClose(nHdl)
	
	oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
	oExcelApp:WorkBooks:Open(cArqTxt)
	oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.
	oExcelApp:Destroy()
	Return Nil

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
***********************************************************************************/