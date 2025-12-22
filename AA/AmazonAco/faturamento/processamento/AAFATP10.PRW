//-------------------------------------------------------. 
// Declaração das bibliotecas utilizadas no programa      |
//-------------------------------------------------------'
#include "Protheus.ch"
#include "RwMake.ch"
#include "TBICONN.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATP10   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 17/01/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Consulta Romaneio - criado por Wermeson Gadelha conforme      ¦¦¦
¦¦¦  (Cont)   ¦ solicitado pelo Sr. Valdenir em 15/01/2014                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/  /*2013143823091*/
User function AAFATP10()

 //-------------------------------------------------------. 
 // Declaração das variaveis locais                        |
 //-------------------------------------------------------'
	Local _aCabec            := {'' ,'Romaneio','Dt. Romaneio','Balança Ini', 'Data Ent', 'Hora Ent','Balança Fim', 'Data Sai', 'Hora Sai','Peso Nota','Peso Balanca', 'Dif.', 'Dev.','Observacao', 'Ticket', 'Operador', 'Motorista','Placa Veiculo','Ajudante 1','Ajudante 2', 'Placa Carro','Tp Rom','Empresa'}
								
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
	Private _odTpRoman       := Nil 
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
	Private _cPlacaIni       := Space(Len(SZE->ZE_PLACA))
	Private _cPlacaFim       := replicate('z',Len(SZE->ZE_PLACA))
	Private _adTpRoman       := {}
	Private _cdTpRoman       := "Ambos"
	Private _cTipo           := "Sim"
	Private _cTipo2          := "Ambos"
	Private _cTipo3          := "Todas"
	Private nPesoTotal       := 0             
	Private nPesoDevol       := 0 
	Private nPesoEntrada     := 0            	
	Private nPesoVarejo      := 0
	Private nPesoAtacado     := 0
	Private nPesoSilves      := 0
	Private nPesoPuraca      := 0
	Private nPesoDistrito    := 0
    Private _cdCompany := "00"
    Private _odCompany := ""
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
	Private _oChk10, _lChk10 :=.T.

 //-------------------------------------------------------. 
 // Declaração das variaveis privates - Arrays             |
 //-------------------------------------------------------'		
	Private aItems     := {}
	Private _adCompany := {}
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
			
	AADD(_adCompany,"00=Ambos"    )
	AADD(_adCompany,"01=Industria")
	AADD(_adCompany,"05=Comercio" )	
	
	AADD(aTipos,"Varejo")
	AADD(aTipos,"Atacado")
	AADD(aTipos,"Ambos")
	
	aAdd(_adTpRoman,"Ambos")
	aAdd(_adTpRoman,"Entrada")
	aAdd(_adTpRoman,"Saida")
	
	
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
	Processa({|| GetInf(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal, 1, _cPlacaIni, _cPlacaFim)},'Filtrando Dados' )
		
	//-------------------------------------------------------. 
	// Inicializando as variaveis de pesagem                  |
	//-------------------------------------------------------'		
	nPesoTotal    := 0
	nPesoVarejo   := 0
	nPesoEntrada  := 0
	nPesoAtacado  := 0
	nPesoSilves   := 0
	nPesoPuraca   := 0
	nPesoDistrito := 0
	
	//-------------------------------------------------------. 
	// Calculo de peso                                        |
	//-------------------------------------------------------'		
	CalcPesoDiv( _cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal, "", _cPlacaIni, _cPlacaFim )
	
	//-------------------------------------------------------. 
	// PesoTotal                                              |
	//-------------------------------------------------------'		
	nPesoTotal := PesoTotal(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal, "", _cPlacaIni, _cPlacaFim)
	
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

	oLayer:AddColumn('ALL2' ,20,,'UP')

	_oUp      := oLayer:GetColPanel('ALL','UP'    )
	_oUp2     := oLayer:GetColPanel('ALL2','UP'    )

	_oMiddle  := oLayer:GetColPanel('ALL','MIDDLE')
	_oDown    := oLayer:GetColPanel('ALL','DOWN'  )

	aCoors := MsAdvSize()
		
	@ 003,005 TO 70,420 label "Filtros" OF _oUp PIXEL
		
	@ 015,007 Say "Data de Saida" Size 50,10 Pixel Of _oUp
	@ 015,057 MsGet _oDatIni Var _dDataInicial Size 60,08 Pixel of _oUp
	@ 015,130 MsGet _oDatFim Var _dDataFinal   Size 60,08 Pixel of _oUp
		
	@ 030,007 Say "Cliente" Size 50,10 Pixel Of _oUp
	@ 030,057 MsGet _oClienteIni Var _cClienteIni F3 'SA1' Size 60,08 Pixel of _oUp
	@ 030,130 MsGet _oClienteFim Var _cClienteFim F3 'SA1' Size 60,08 Pixel of _oUp

 	@ 045,007 Say "Placa" Size 50,10 Pixel Of _oUp
	@ 045,057 MsGet _oPlacaIni Var _cPlacaIni Size 60,08 Pixel of _oUp
	@ 045,130 MsGet _oPlacaFim Var _cPlacaFim Size 60,08 Pixel of _oUp

    @ 058,007 Say "Tipo Romaneio" Size 50,10 Pixel Of _oUp 
	@ 058,057 MSCOMBOBOX _odTpRoman VAR _cdTpRoman ITEMS _adTpRoman SIZE 060,50 OF _oUp PIXEL
	
	@ 008,220 Say "Considerar AmazonAço :"  Size 090,10 Pixel Of _oUp
	@ 015,220 MSCOMBOBOX _oTipo  VAR _cTipo  ITEMS aItems SIZE 060,50 OF _oUp PIXEL
	
	@ 028,220 Say "Tipo Venda  :"  Size 090,10 Pixel Of _oUp
	@ 035,220 MSCOMBOBOX _oTipo2 VAR _cTipo2 ITEMS aTipos SIZE 060,50 OF _oUp PIXEL
	
	@ 048,220 Say "Balancas    :"  Size 090,10 Pixel Of _oUp
	@ 055,220 MSCOMBOBOX _oTipo3 VAR _cTipo3 ITEMS aBalan SIZE 060,50 OF _oUp PIXEL
	
	@ 008,300 Say "Empresa" Size 50,10 Pixel Of _oUp 
	@ 015,300 MSCOMBOBOX _odCompany VAR _cdCompany ITEMS _adCompany SIZE 060,50 OF _oUp PIXEL
	
	
	@ 010,300 + 060 CHECKBOX _oChk02 VAR _lChk02 PROMPT "Pré-Romaneio" 				SIZE 80,9 PIXEL OF _oUp
	@ 020,300 + 060 CHECKBOX _oChk03 VAR _lChk03 PROMPT "Romaneio"     				SIZE 80,9 PIXEL OF _oUp
	@ 030,300 + 060 CHECKBOX _oChk05 VAR _lChk05 PROMPT "Entregue"                SIZE 80,9 PIXEL OF _oUp	
	@ 040,300 + 060 CHECKBOX _oChk04 VAR _lChk04 PROMPT "Vem Buscar"              SIZE 80,9 PIXEL OF _oUp
	
	@ 020,360 + 060 CHECKBOX _oChk06 VAR _lChk06 PROMPT "End não encontrado"      SIZE 80,9 PIXEL OF _oUp
	@ 030,360 + 060 CHECKBOX _oChk07 VAR _lChk07 PROMPT "Nova Entrega"            SIZE 80,9 PIXEL OF _oUp			
	@ 010,360 + 060 CHECKBOX _oChk08 VAR _lChk08 PROMPT "Devolução"               SIZE 80,9 PIXEL OF _oUp
	@ 040,360 + 060 CHECKBOX _oChk09 VAR _lChk09 PROMPT "Local Fechado"           SIZE 80,9 PIXEL OF _oUp
		        
	@ 050,300 + 060 CHECKBOX _oChk10 VAR _lChk10 PROMPT "Liberacao Especial"      SIZE 80,9 PIXEL OF _oUp
                                             
	@ 010,015 Button "&Consultar" Size 40,13 Pixel of _oUp2 Action MsgRun('Filtrando Dados...' ,,{|| GetInf(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal, 2, _cPlacaIni , _cPlacaFim), oBrowse:Refresh() })
	@ 025,015 Button "&Legenda"   Size 40,13 Pixel of _oUp2 Action BrwLegenda("Cadastro de Romaneio","Legendas",_aLegenda)
	@ 010,060 Button "&Exportar"  Size 40,13 Pixel of _oUp2 Action MsgRun('Exportando Excel...',,{|| ExportaExcel(_aBrowse), oBrowse:Refresh() })
	@ 025,060 Button "&Fechar"    Size 40,13 Pixel of _oUp2 Action _oJanela:End()
		
		
		//@ 075,005 TO 215,600 label "Dados" OF _oJanela PIXEL
		
	//	oBrowse := TcBrowse():New ( 080,007,490,160 , , _aCabec,/*[ aColSizes]*/           , _oJanela, /*[ cField]*/,  , , /*[ bChange]*/, /*[ bLDblClick]*/, /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/,  cAlias /*cAlias*/, /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )	   
//	  	oBrowse := TcBrowse():New ( 080,007,490,160 , , _aCabec,/*[ aColSizes]*/           , _oJanela, /*[ cField]*/,  , , /*[ bChange]*/, /*[ bLDblClick]*/, /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/,         /*cAlias*/, /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )
	oBrowse := FWBrowse():New()
	oBrowse:SetDataArray()
	oBrowse:AddStatusColumns(  { || _aCores[aScan(_aCores,{|x| &(x[01]) })][02] }, {||} )

	_adCabec := {}
	
	aAdd(_adCabec,{ _aCabec[23]  , {|| _aBrowse[oBrowse:At()][23] }  , 'C' ,  '@!' , 1 , 02, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[22]  , {|| _aBrowse[oBrowse:At()][22] }  , 'C' ,  '@!' , 1 , 02, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[02]  , {|| _aBrowse[oBrowse:At()][02] }  , 'C' ,  '@!' , 1 , 06, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[03]  , {|| _aBrowse[oBrowse:At()][03] }  , 'D' ,  '  ' , 0 , 08, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[04]  , {|| _aBrowse[oBrowse:At()][04] }  , 'C' ,  '@!' , 1 , 05, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[05]  , {|| _aBrowse[oBrowse:At()][05] }  , 'D' ,  '  ' , 0 , 08, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[06]  , {|| _aBrowse[oBrowse:At()][06] }  , 'C' ,  '@!' , 1 , 05, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[07]  , {|| _aBrowse[oBrowse:At()][07] }  , 'C' ,  '@!' , 1 , 06, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[08]  , {|| _aBrowse[oBrowse:At()][08] }  , 'D' ,  '@!' , 0 , 08, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[09]  , {|| _aBrowse[oBrowse:At()][09] }  , 'C' ,  '@!' , 1 , 05, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[10]  , {|| _aBrowse[oBrowse:At()][10] }  , 'N' ,  '@E 999,999,999.99' , 2 , 12, 2 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[11]  , {|| _aBrowse[oBrowse:At()][11] }  , 'N' ,  '@E 999,999,999.99' , 2 , 12, 2 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[12]  , {|| _aBrowse[oBrowse:At()][12] }  , 'N' ,  '@E 999,999,999.99' , 2 , 12, 2 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[13]  , {|| _aBrowse[oBrowse:At()][13] }  , 'N' ,  '@E 999,999,999.99' , 2 , 12, 2 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[14]  , {|| _aBrowse[oBrowse:At()][14] }  , 'C' ,  '@!' , 1 , 25, 2 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[15]  , {|| _aBrowse[oBrowse:At()][15] }  , 'C' ,  '@!' , 1 , 10, 2 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[16]  , {|| _aBrowse[oBrowse:At()][16] }  , 'C' ,  '@!' , 1 , 10, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[17]  , {|| _aBrowse[oBrowse:At()][17] }  , 'C' ,  '@!' , 1 , 25, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[18]  , {|| _aBrowse[oBrowse:At()][18] }  , 'C' ,  '@!' , 1 , 10, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[19]  , {|| _aBrowse[oBrowse:At()][19] }  , 'C' ,  '@!' , 1 , 10, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[20]  , {|| _aBrowse[oBrowse:At()][20] }  , 'C' ,  '@!' , 1 , 10, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[21]  , {|| _aBrowse[oBrowse:At()][21] }  , 'C' ,  '@!' , 1 , 10, 0 ,,,,,,  })

	oBrowse:SetArray(_aBrowse)
	oBrowse:SetColumns(_adCabec)
	oBrowse:SetBlkBackColor( {|| If( _aBrowse[oBrowse:At()][13] > 0 ,CLR_YELLOW,If( _aBrowse[oBrowse:At()][11]>_aBrowse[oBrowse:At()][10], RGB(255, 100, 100) , )  )  } )

	oBrowse:Refresh()
	oBrowse:SetDoubleClick(   {||  _dblClick()  }  )
	oBrowse:setOwner(_oMiddle)
	oBrowse:Activate()
	//oBrowse:nScrollType := 0 // Define a barra de rolagem VCR
		
	//@ 240,005 TO 270,500 label "Totais" OF _oJanela PIXEL
		
	@ 005,010 Say "Total Peso Balanca" Size 70,10 Pixel Of _oDown
	oPesoT:= TSay():New(015,010   ,{|| AllTrim(Transform(nPesoTotal                ,"@E 999,999,999,999,999.99") )},_oDown,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
		
	@ 005,085 Say "Total Notas"  Size 70,10 Pixel Of _oDown
	oPesoN:= TSay():New(015,085   ,{|| AllTrim(Transform(nPesoVarejo + nPesoAtacado + nPesoEntrada,"@E 999,999,999,999,999.99") )},_oDown,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
		
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

	@ 005,530 Say "Total Devolucao"  Size 70,10 Pixel Of _oDown
	oPesoD:= TSay():New(015,530   ,{|| AllTrim(Transform(nPesoDevol                ,"@E 999,999,999,999,999.99") )},_oDown,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
    
    @ 005,605 Say "Total Entradas"  Size 70,10 Pixel Of _oDown
	oPesoE:= TSay():New(015,605   ,{|| AllTrim(Transform(nPesoEntrada              ,"@E 999,999,999,999,999.99") )},_oDown,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
	
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
Static Function GetInf(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal,nTipo,_cPlacaIni, _cPlacaFim)
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
	
	_cQry := " SELECT ZE_ROMAN     ,ZE_TIPO, ZE_STATUS    , " + Chr(13) + Chr(10)
	_cQry += "        MAX(TPLACA   ) AS TPLACA    , MAX(ZE_DTSAIDA) AS ZE_DTSAIDA , MAX(BALANCA_I) AS BALANCA_I , MAX(DPESOINI  ) AS DPESOINI   , " + Chr(13) + Chr(10)
	_cQry += "        MAX(ZE_PLACA ) AS ZE_PLACA  , MAX(ZE_NOMOTOR) AS ZE_NOMOTOR , MAX(ZE_DTPESO) AS ZE_DTPESO , MAX(ZE_TICKET1) AS ZE_TICKET1 , " + Chr(13) + Chr(10)
	_cQry += "        MAX(ZE_PESO  ) AS ZE_PESO   , MAX(BALANCA_F ) AS BALANCA_F  , SUM(ZE_PLIQUI) AS ZE_PLIQUI , SUM(DEVOLUCAO ) AS DEVOLUCAO  , " + Chr(13) + Chr(10)
	_cQry += "        MAX(ZE_OBSERV) AS ZE_OBSERV , MAX(ZE_AJUDA01) AS ZE_AJUDA01 , MAX(OPERADOR ) AS OPERADOR  , MAX(ZE_AJUDA02) AS ZE_AJUDA02 , " + Chr(13) + Chr(10)
	_cQry += "        MAX(DPESOFIM ) AS DPESOFIM  , MAX(ZE_HRPESO ) AS ZE_HRPESO  , MAX(HPESOINI ) AS HPESOINI  , MAX(HPESOFIM  ) AS HPESOFIM     " + Chr(13) + Chr(10)
	   
	_cQry += "   FROM ( SELECT ZE_ROMAN  ,ZE_TIPO, ZE_PLACA   , ZE_NOMOTOR , ZE_DTPESO , ZE_AJUDA01 , ZE_AJUDA02   , ZE_PLIQUI , ZE_PESO , "   + Chr(13) + Chr(10)
	_cQry += " 			         ZE_OBSERV , ZE_TICKET1 , ZE_HRPESO  , DPESOFIM  , HPESOINI   , HPESOFIM     , BALANCA_F , OPERADOR, "   + Chr(13) + Chr(10)
	_cQry += " 			         ZE_DTSAIDA, case WHEN ZE_STATUS = 'D' THEN ZE_PLIQUI ELSE 0 END AS DEVOLUCAO, BALANCA_I , DPESOINI, "   + Chr(13) + Chr(10)
	_cQry += " 			         COALESCE( ( SELECT TOP 1 ZE1.ZE_STATUS "                                                                + Chr(13) + Chr(10)
	_cQry += " 							           FROM "  + RetSqlName("SZE") + " AS ZE1 (NOLOCK) "                                         + Chr(13) + Chr(10)
	_cQry += " 							          WHERE ZE1.D_E_L_E_T_ = '' AND ZE1.ZE_ROMAN = AUX.ZE_ROMAN AND ZE_STATUS <> 'D'), 'D' "     + Chr(13) + Chr(10)
	_cQry += " 					             )  AS ZE_STATUS, TPLACA "                                                                     + Chr(13) + Chr(10)
		       
	_cQry += " 		       FROM ( SELECT ZE_ROMAN,ZE_TIPO, case WHEN ZE_STATUS IN ('P','R','B','E', 'X') THEN ZE_STATUS ELSE 'D' END AS ZE_STATUS, " + Chr(13) + Chr(10)
	_cQry += " 					            MAX(ZE_DTSAIDA) AS ZE_DTSAIDA,"                                                                + Chr(13) + Chr(10) 			   
	_cQry += " 					            MAX(ZE_PLACA  ) AS ZE_PLACA  ,"                                                                + Chr(13) + Chr(10)
	_cQry += " 					            MAX(ZE_NOMOTOR) AS ZE_NOMOTOR,"                                                                + Chr(13) + Chr(10)
	_cQry += " 					            MAX(ZE_DTPESO ) AS ZE_DTPESO ,"                                                                + Chr(13) + Chr(10)
	_cQry += " 					            MAX(ZE_AJUDA01) AS ZE_AJUDA01,"                                                                + Chr(13) + Chr(10)
	_cQry += " 					            MAX(ZE_AJUDA02) AS ZE_AJUDA02,"                                                                + Chr(13) + Chr(10)
	_cQry += " 					            SUM(ZE_PLIQUI ) AS ZE_PLIQUI ,"                                                                + Chr(13) + Chr(10)
	_cQry += " 					            MAX(ZE_PESO   ) AS ZE_PESO   ,"                                                                + Chr(13) + Chr(10)
	_cQry += " 					            MAX(ZE_OBSERV ) AS ZE_OBSERV ,"                                                                + Chr(13) + Chr(10)
	_cQry += " 					            MAX(ZE_TICKET1) AS ZE_TICKET1,"                                                                + Chr(13) + Chr(10)
	_cQry += " 					            MAX (ZE_HRPESO) as ZE_HRPESO ,"                                                                + Chr(13) + Chr(10)
	_cQry += " 					            MAX(COALESCE(TICK_BALPESOINICIAL,' ')) AS BALANCA_I, "                                         + Chr(13) + Chr(10)
	_cQry += " 					            MAX(COALESCE(TICK_PLACAVEICULO  ,' ')) AS TPLACA   , "                                         + Chr(13) + Chr(10)
	_cQry += " 					            MAX(COALESCE(TICK_BALPESOFINAL  ,' ')) AS BALANCA_F, "                                         + Chr(13) + Chr(10)
	_cQry += " 					            MAX(COALESCE(TICK_OPPESOFINAL   ,' ')) AS OPERADOR , "                                         + Chr(13) + Chr(10)
	_cQry += " 					            MAX(CONVERT(CHAR(10),TICK_DTHRPESOINICIAL,112)) AS DPESOINI,MAX(CONVERT(CHAR(10),TICK_DTHRPESOFINAL,112)) AS DPESOFIM,"                                       + Chr(13) + Chr(10)
	_cQry += " 					            MAX(RIGHT('0'+CONVERT(VARCHAR,DATEPART(HOUR,TICK_DTHRPESOINICIAL)),2 )+':'+RIGHT('0'+CONVERT(VARCHAR,DATEPART(MINUTE,TICK_DTHRPESOINICIAL)),2)) AS HPESOINI," + Chr(13) + Chr(10)
	_cQry += " 					            MAX(RIGHT('0'+CONVERT(VARCHAR,DATEPART(HOUR,TICK_DTHRPESOFINAL  )),2 )+':'+RIGHT('0'+CONVERT(VARCHAR,DATEPART(MINUTE,TICK_DTHRPESOFINAL  )),2)) AS HPESOFIM"  + Chr(13) + Chr(10)
					   		 
	_cQry += " 				          FROM "  + RetSqlName("SZE") + " SZE (NOLOCK)" + Chr(13) + Chr(10)
                             
	_cQry += " 				         Left Join "  + RetSqlName("SC5") + " SC5 (NOLOCK) ON SC5.D_E_L_E_T_ = '' AND SC5.C5_NUM = SZE.ZE_ORCAMEN AND SC5.C5_FILIAL = SZE.ZE_FILORIG " + Chr(13) + Chr(10)
	_cQry += " 				         Left Join GUARDIAN110.DBO.REGTICK (NOLOCK) AS BAL  ON TICK_SEQUENCIAL = ZE_TICKET1 COLLATE LATIN1_GENERAL_BIN  "          + Chr(13) + Chr(10)

	_cQry += " 				         WHERE  SZE.D_E_L_E_T_ = ' ' "                                                                + Chr(13) + Chr(10)     		           
	_cQry += "                      AND SZE.ZE_CLIENTE  BetWeen '" +       _cClienteIni   + "'And '" +      _cClienteFim + "'"   + Chr(13) + Chr(10)
	_cQry += "                      AND SZE.ZE_PLACA    BetWeen '" +       _cPlacaIni     + "'And '" +      _cPlacaFim   + "'"   + Chr(13) + Chr(10)
	
	_cQry += "                      AND SZE.ZE_DTSAIDA BetWeen '" + DTOS(_dDataInicial) + "'And '" + DTOS(_dDataFinal) + "'"   + Chr(13) + Chr(10)

	If Len(AllTrim(cAuxStatus)) > 2
		_cQry += "                   AND ZE_STATUS  In " + cAuxStatus                                                           + Chr(13) + Chr(10)
	EndIf
    
	If AllTrim(_cTipo) == "Nao"
			_cQry += "                AND ZE_CLIENTE NOT IN "+FormatIn(GetMV("MV_XCLIAA"),",")                                   + Chr(13) + Chr(10)
		ElseIf AllTrim(_cTipo) == "Somente"
			_cQry += "                AND ZE_CLIENTE     IN "+FormatIn(GetMV("MV_XCLIAA"),",")		                              + Chr(13) + Chr(10)
	EndIf
    //
	If AllTrim(_cTipo2) == "Atacado"
			_cQry += "                AND LEN( RTRIM(C5_ORCRES) ) = 0  "                                                         + Chr(13) + Chr(10)
		ElseIf AllTrim(_cTipo2) == "Varejo"
			_cQry += "                AND LEN( RTRIM(C5_ORCRES) ) > 0  "                                                         + Chr(13) + Chr(10)
	EndIf

	If AllTrim(_cTipo3) == "Silves"
			_cQry += "                AND      ISNULL(Tick_BalPesoFinal, '')    = 'BAL_SILVES'   "                               + Chr(13) + Chr(10)
		ElseIf AllTrim(_cTipo3) == "Puraquequara"
			_cQry += "                AND LEFT(ISNULL(Tick_BalPesoFinal, ''),9) = 'BAL_PURAQ'    "                               + Chr(13) + Chr(10)
		ElseIf AllTrim(_cTipo3) == "Distrito"
			_cQry += "                AND      ISNULL(Tick_BalPesoFinal, '')    = 'BAL_DISTRITO' "                               + Chr(13) + Chr(10)
	EndIf
    If AllTrim(_cdTpRoman) == "Entrada"
        _cQry += "                AND      ZE_TIPO    = 'E' "  + Chr(13) + Chr(10)
    ElseIf AllTrim(_cdTpRoman) == "Saida"
        _cQry += "                AND      ZE_TIPO    = 'S' "  + Chr(13) + Chr(10)
    EndIf
	_cQry += " 				    GROUP BY ZE_ROMAN,ZE_TIPO, case WHEN ZE_STATUS IN ('P', 'R', 'B', 'E', 'X') THEN ZE_STATUS ELSE 'D' END " + Chr(13) + Chr(10)
	_cQry += "  			      ) AS AUX "                                                                                      + Chr(13) + Chr(10)
	_cQry += "  	   ) AS TEMP"                                                                                               + Chr(13) + Chr(10)
	_cQry += "  GROUP BY ZE_ROMAN, ZE_STATUS,ZE_TIPO"                                                                                  + Chr(13) + Chr(10)
 	   
 	   
	//
	
	cArqTrab := ''

    _xdQry  := _cQry
    
    _xdCompany := Left(_cdCompany,2)
    _xdCompany := If(_xdCompany == "00","01,05",_xdCompany)     
    _xdQry2 := ""
    
    If "01"$_xdCompany
       _xdQry2 := "Select '01' EMPRESA, A.* FROM (" + _xdQry + ")A"     
    EndIf
    
    If "05"$_xdCompany
        _xdQry := StrTran(_xdQry,"010","050")
        _xdQry := StrTran(_xdQry,"Inner JOIN GUARDIAN110.","Left JOIN GUARDIAN110.")
        If Len(Alltrim(_xdQry2)) == 0
           _xdQry2 := " Select '05' EMPRESA, B.* FROM (" + _xdQry + ")B"
        Else
           _xdQry2 += " Union All Select '05' EMPRESA, B.* FROM (" + _xdQry + ")B"
        EndIf     
    EndIf
    
    _cQry += "  ORDER BY  EMPRESA,ZE_DTSAIDA, ZE_ROMAN"                                                                                + Chr(13) + Chr(10)
    
	MemoWrite("AAFATP10.sql",_cQry )
	MemoWrite("AAFATP102.sql",_xdQry2 )
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,_xdQry2), cTable, .T., .T. )

	TCSetField(cTable,"ZE_DTSAIDA" ,"D",8,0)
	TCSetField(cTable,"ZE_DTPESO"  ,"D",8,0)
	TCSetField(cTable,"DPESOINI"   ,"D",8,0)
	TCSetField(cTable,"DPESOFIM"   ,"D",8,0)

	dbselectarea(cTable)

	(cTable)->(DBGOTOP())
	
	
	If (cTable)->(EOF())
	   
		aAdd( _aBrowse, { 'R'                  ,; //01
								' '                  ,; //02
								STOD('')             ,; //03
								' '                  ,; //04
								STOD('')             ,; //05
								' '                  ,; //06
								' '                  ,; //07
								STOD('')             ,; //08
								' '                  ,; //09
								0                    ,; //10
								0                    ,; //11
								0                    ,; //12
								0                    ,; //13
								' '                  ,; //14
								' '                  ,; //15
								' '                  ,; //16
								' '                  ,; //17
								' '                  ,; //18
								' '                  ,; //19
								' '                  ,; //20
								' '                  ,; //21
								' ' ,;//22 Tipo do Romaneio Entrada / Saida
								''})// 23 Empresa

	EndIf
	
	nPesoDevol := 0 
	
	While !(cTable)->(EOF())
	   
	   aAdd( _aBrowse, {(cTable)->ZE_STATUS          ,; //01
		                (cTable)->ZE_ROMAN           ,; //02
		                DTOC( (cTable)->ZE_DTSAIDA)  ,; //03
                  		(cTable)->BALANCA_I          ,; //04
                  		DTOC((cTable)->DPESOINI)     ,; //05
                  		(cTable)->HPESOINI           ,; //06
                  		(cTable)->BALANCA_F          ,; //07
                  		DTOC((cTable)->DPESOFIM)     ,; //08
                  		(cTable)->HPESOFIM           ,; //09
                  		(cTable)->ZE_PLIQUI          ,; //10
                  		(cTable)->ZE_PESO            ,; //11
                  		(cTable)->(ZE_PLIQUI-ZE_PESO),; //12                  		
                  		(cTable)->DEVOLUCAO          ,; //13
                  		(cTable)->ZE_OBSERV          ,; //14
                  		(cTable)->ZE_TICKET1         ,; //15
                  		(cTable)->OPERADOR  	        ,; //16
                  		(cTable)->ZE_NOMOTOR         ,; //17
                  		(cTable)->ZE_PLACA           ,; //18
                  		(cTable)->ZE_AJUDA01         ,; //19
                  		(cTable)->ZE_AJUDA02         ,; //20
                  		(cTable)->TPLACA             ,;//21
                  		(cTable)->ZE_TIPO            ,;//22
                  		(cTable)->EMPRESA            }) //23
	   	   
		nPesoDevol  += (cTable)->DEVOLUCAO

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

	CalcPesoDiv( _cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal, cAuxStatus, _cPlacaIni, _cPlacaFim )

	nPesoTotal := PesoTotal(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal, cAuxStatus, _cPlacaIni, _cPlacaFim)
	
	If Type("oPesoT") != "U"
		oPesoT:SetText    ( AllTrim( Transform(nPesoTotal                ,"@E 999,999,999,999,999.99") ) )
	EndIF
	If Type("oPesoV") != "U"
		oPesoV:SetText    ( AllTrim( Transform(nPesoVarejo               ,"@E 999,999,999,999,999.99") ) )
	EndIF
	If Type("oPesoE") != "U"
		oPesoE:SetText    ( AllTrim( Transform(nPesoEntrada              ,"@E 999,999,999,999,999.99") ) )
	EndIF
	If Type("oPesoA") != "U"
		oPesoA:SetText    ( AllTrim( Transform(nPesoAtacado              ,"@E 999,999,999,999,999.99") ) )
	EndIF
	If Type("oPesoN") != "U"
		oPesoN:SetText    ( AllTrim( Transform(nPesoAtacado + nPesoVarejo + nPesoEntrada,"@E 999,999,999,999,999.99") ) )
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
Static Function CalcPesoDiv(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal, cAuxStatus, _cPlacaIni, _cPlacaFim)
	Local _cQry := ''
	
	_cQry += " select C5_ORCRES, SUM(PesoTotal)  PESOTOTAL From ("
	_cQry += " select case"
	_cQry += "           When C5_ORCRES is Null And ZE_TIPO = 'E' then '0'
	_cQry += "           When Len(RTRIM(C5_ORCRES)) = 0 Then '1'"
	_cQry += "           else '2'"
	_cQry += "        End C5_ORCRES, Sum(B1_PESO * Coalesce(D2_QUANT,D1_QUANT,0) ) PesoTotal"
	_cQry += "    from " + RetSqlName('SZE') + " A"
	_cQry += "   INNER JOIN Guardian110.dbo.RegTick as BAL (NOLOCK) ON Tick_Sequencial = ZE_TICKET1  COLLATE Latin1_General_BIN  "
	_cQry += "    Left Outer Join " +  RetSqlName('SD2') + " D2 WITH(NOLOCK) On D2_FILIAL = ZE_FILORIG and D2_DOC = ZE_DOC and ZE_SERIE = D2_SERIE And ZE_TIPO In('S',' ')"
	_cQry += "    Left Outer Join " +  RetSqlName('SD1') + " D1 WITH(NOLOCK) On D1_FILIAL = ZE_FILORIG and D1_DOC = ZE_DOC and ZE_SERIE = D1_SERIE And ZE_CLIENTE = D1_FORNECE And ZE_LOJACLI = D1_LOJA And ZE_TIPO = 'E'"
	_cQry += "    Left Outer Join " +  RetSqlName('SC5') + " C5 WITH(NOLOCK) on C5_NUM = D2_PEDIDO and D2_FILIAL = C5_FILIAL AND C5.D_E_L_E_T_ = ''"
	_cQry += "    Left Outer Join " +  RetSqlName('SB1') + " B1 WITH(NOLOCK) on B1_COD = isNull(D2_COD,D1_COD)"

	_cQry += " WHERE A.D_E_L_E_T_ = '' "
	_cQry += " ANd ZE_CLIENTE BetWeen '" + _cClienteIni + "'And '" + _cClienteFim + "'"
	_cQry += " AND ZE_PLACA   BetWeen '" + _cPlacaIni   + "'And '" + _cPlacaFim   + "'" 
	_cQry += " And ZE_DTSAIDA BetWeen '" + DTOS(_dDataInicial) + "'And '" + DTOS(_dDataFinal) + "'"
	//_cQry += " And ZE_STATUS in ('R','E','B')"

	If AllTrim(_cTipo2) == "Atacado"
		_cQry += " AND LEN( RTRIM(C5_ORCRES) ) = 0  And ZE_TIPO iN('S',' ')"                                                                 + Chr(13) + Chr(10)
	ElseIf AllTrim(_cTipo2) == "Varejo"
		_cQry += " AND LEN( RTRIM(C5_ORCRES) ) > 0  And ZE_TIPO iN('S',' ')"                                                                 + Chr(13) + Chr(10)
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
    If AllTrim(_cdTpRoman) == "Entrada"
        _cQry += " AND      ZE_TIPO    = 'E' "  + Chr(13) + Chr(10)
    ElseIf AllTrim(_cdTpRoman) == "Saida"
        _cQry += " AND      ZE_TIPO    = 'S' "  + Chr(13) + Chr(10)
    EndIf
	If Len(AllTrim(cAuxStatus)) > 2
		_cQry += " And ZE_STATUS  In " + cAuxStatus
	EndIf
    
    
                                             
	_cQry += " group by case 
	_cQry += "           When C5_ORCRES is Null And ZE_TIPO = 'E' then '0' 
	_cQry += "           When Len(RTRIM(C5_ORCRES)) = 0 Then '1' 
	_cQry += "           else '2' End "
	_cQry += " )A"
	_cQry += " group by C5_ORCRES"
	//AViso('',_cQry ,{'ok'} ,3)
	cTable := GetNextAlias()
	dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQry), cTable, .T., .T. )
	nPesoEntrada := 0
	nPesoVarejo  := 0
	nPesoAtacado := 0
	While !(cTable)->(EOF())
	    If (cTable)->C5_ORCRES == '0'
	        nPesoEntrada += (cTable)->PESOTOTAL
		Elseif (cTable)->C5_ORCRES == '2'
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
Static Function PesoTotal(cCliIni, cCliFim, dDtIni, dDtFim, cAuxStatus, _cPlacaIni, _cPlacaFim)
	Local _cQry  := ''
	Local cTable := GetNextAlias()
	Local _aArea := GetArea()
	
	_cQry += " Select BALANCA, SUM(ZE_PESO) ZE_PESO   "                                                        + Chr(13) + Chr(10)
	_cQry += " From (  "                                                                                       + Chr(13) + Chr(10)
	_cQry += " select ZE_ROMAN, ISNULL(Tick_BalPesoFinal, '') as BALANCA, MAX(ZE_PESO) ZE_PESO from " + RetSqlName("SZE") + " SZE (NOLOCK)"  + Chr(13) + Chr(10)

	_cQry += "  Left Outer JOIN "  + RetSqlName("SC5") + " SC5 (NOLOCK)"                                            + Chr(13) + Chr(10)
	_cQry += "     ON SC5.D_E_L_E_T_ = '' AND SC5.C5_NUM = SZE.ZE_ORCAMEN AND SC5.C5_FILIAL = SZE.ZE_FILORIG " + Chr(13) + Chr(10)

	_cQry += " INNER JOIN Guardian110.dbo.RegTick as BAL (NOLOCK) ON Tick_Sequencial = ZE_TICKET1  COLLATE Latin1_General_BIN  "
   
	_cQry += " WHere SZE.D_E_L_E_T_ = '' "                                                                     + Chr(13) + Chr(10)
	_cQry += " ANd SZE.ZE_CLIENTE BetWeen '" + _cClienteIni + "'And '" + _cClienteFim + "'"                    + Chr(13) + Chr(10)
	_cQry += " AND SZE.ZE_PLACA   BetWeen '" + _cPlacaIni   + "'And '" + _cPlacaFim   + "'"                    + Chr(13) + Chr(10)
	_cQry += " And SZE.ZE_DTSAIDA BetWeen '" + DTOS(_dDataInicial) + "'And '" + DTOS(_dDataFinal) + "'"        + Chr(13) + Chr(10)
	    
	If AllTrim(_cTipo) == "Nao"
		_cQry += " AND ZE_CLIENTE NOT IN "+FormatIn(GetMV("MV_XCLIAA"),",")                                     + Chr(13) + Chr(10)
	ElseIf AllTrim(_cTipo) == "Somente"
		_cQry += " AND ZE_CLIENTE IN "+FormatIn(GetMV("MV_XCLIAA"),",")		                                   + Chr(13) + Chr(10)
	EndIf

	If AllTrim(_cTipo2) == "Atacado"
		_cQry += " AND LEN( RTRIM(C5_ORCRES) ) = 0  "                                                           + Chr(13) + Chr(10)
	ElseIf AllTrim(_cTipo2) == "Varejo"
		_cQry += " AND LEN( RTRIM(C5_ORCRES) ) > 0  "                                                           + Chr(13) + Chr(10)
	EndIf
   
	If AllTrim(_cTipo3) == "Silves"
		_cQry += " AND ISNULL(Tick_BalPesoFinal, '') = 'BAL_SILVES'   "                                         + Chr(13) + Chr(10)
	ElseIf AllTrim(_cTipo3) == "Puraquequara"
		_cQry += " AND LEFT(ISNULL(Tick_BalPesoFinal, ''),9) = 'BAL_PURAQ'   "                                  + Chr(13) + Chr(10)
	ElseIf AllTrim(_cTipo3) == "Distrito"
		_cQry += " AND ISNULL(Tick_BalPesoFinal, '') = 'BAL_DISTRITO' "                                         + Chr(13) + Chr(10)
	EndIf
                                                                                          	
	If Len(AllTrim(cAuxStatus)) > 2
		_cQry += " And ZE_STATUS  In " + cAuxStatus
	EndIf
	
	If AllTrim(_cdTpRoman) == "Entrada"
        _cQry += " AND      ZE_TIPO    = 'E' "  + Chr(13) + Chr(10)
    ElseIf AllTrim(_cdTpRoman) == "Saida"
        _cQry += " AND      ZE_TIPO    = 'S' "  + Chr(13) + Chr(10)
    EndIf
    
	_cQry += " group by ZE_ROMAN, Tick_BalPesoFinal "                                                          + Chr(13) + Chr(10)
	_cQry += " ) A "
	_cQry += " group by BALANCA"                                                                               + Chr(13) + Chr(10)

	
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

U_AAFATP3A(_aBrowse[oBrowse:nAt][02], .F., _aBrowse[oBrowse:nAt][01], _aBrowse[oBrowse:nAt][23] ) 

oBrowse := _odBrowse
_aBrowse := _adBrowse

oBrowse:SetArray(_aBrowse)
oBrowse:nLen := Len(_aBrowse)
oBrowse:Refresh()
Return Nil

Static Function ExportaExcel(aExport)
	Local i, j, nHdl, oExcelApp
	Local cArqTxt := GetTempPath()+"\aafatp10.xls"
	Local cLinha  := ""
	
	If File(cArqTxt)
		FErase(cArqTxt)
	Endif
	
	nHdl := fCreate(cArqTxt)
	
	cLinha += 'Staus'       + Chr(9) + 'Romaneio'      + Chr(9) + 'Dt. Romaneio'  + Chr(9)  
	cLinha += 'Balança Ini' + Chr(9) + 'DT Peso Ent'   + Chr(9) + 'Hr. Peso Ent'  + Chr(9) 
	cLinha += 'Balança Fim' + Chr(9) + 'DT Peso Sai'   + Chr(9) + 'Hr. Peso Sai'  + Chr(9)
	cLinha += 'Peso Nota'   + Chr(9) + 'Peso Balanca'  + Chr(9) + 'Diferença'     + Chr(9)
	cLinha += 'Devolucao'   + Chr(9) + 'Observacao'    + Chr(9) + 'Ticket'        + Chr(9) 
	cLinha += 'Operador'    + Chr(9) + 'Motorista'     + Chr(9) + 'Placa Veiculo' + Chr(9)
	cLinha += 'Ajudante 1'  + Chr(9) + 'Ajudante 2'    + Chr(9) + 'Placa Carro'   + Chr(13) +Chr(10)

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

