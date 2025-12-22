//-------------------------------------------------------.
// Declaração das bibliotecas utilizadas no programa      |
//-------------------------------------------------------'
#include "Protheus.ch"
#include "RwMake.ch"
#include "TBICONN.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATC06   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 27/10/2020 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Consulta vendas para os representantes                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/  /*2013143823091*/
User function AAFATC06()

	//-------------------------------------------------------.
	// Declaração das variaveis locais                        |
	//-------------------------------------------------------'
	Local _aCabec    := {'', 'Filial','Numero','Nota Fiscal','Serie','Dt venda','Cliente','Loja','Nome Cli.','Vendedor','Total Bruto','Desconto', 'Devolução', 'Total Liq','Forma Pag','Num. Entrega','Quem Recebeu','Data Rec.','Hora Rec.','Qtd Entregas', 'Num Orc.',"Emp.","Dt. Pedido"}

	If Type("cAcesso") = "U"
		Prepare Environment Empresa '01' Filial '01' Tables 'SZE,SD2,SF2,SL1,SC5,SA3' Modulo 'FAT'
	EndIf

	//-------------------------------------------------------.
	// Declaração das variaveis privates - Objetos            |
	//-------------------------------------------------------'
	Private _oJanela         := Nil
	Private _oDatIni         := Nil
	Private _oDatFim         := Nil
	Private _oTipo           := Nil
	Private _oTipo2          := Nil
	Private oBrowse          := Nil

	//-------------------------------------------------------.
	// Declaração das variaveis privates - Variaveis          |
	//-------------------------------------------------------'
	Private _dDataInicial    := dDataBase
	Private _dDataFinal      := dDataBase
	Private _cClienteIni     := Space(Len(SA1->A1_COD))
	Private _cClienteFim     := replicate('Z',Len(SA1->A1_COD))
	Private _cVendIni        := Space(Len(SA3->A3_COD))
	Private _cVendFim        := replicate('Z',Len(SA3->A3_COD))
	Private _cTipo           := "Ambas"
	Private _cTipo2          := "Faturamento"
	Private _cTipo3          := "Todas"

	//-------------------------------------------------------.
	// Declaração das variaveis privates - Checkbox           |
	//-------------------------------------------------------'
	Private _oChk01, _lChk01 :=.T.
	Private _oChk02, _lChk02 :=.T.
	Private _oChk03, _lChk03 :=.T.
	Private _oChk04, _lChk04 :=.T.
	Private _oChk05, _lChk05 :=.T.
	Private _oChk06, _lChk06 :=.T.
	Private _oChk07, _lChk07 :=.T.
	Private _oChk08, _lChk08 :=.T.
	Private _oChk09, _lChk09 :=.F.

	Private _oChk10, _lChk10 :=.T.
	
	Private _oChk11, _lChk11 :=.T.

	//-------------------------------------------------------.
	// Declaração das variaveis privates - Arrays             |
	//-------------------------------------------------------'
	Private aItems   := {}
	Private aBalan   := {}
	Private aTipos   := {}
	Private _aBrowse := {}
	Private _aInsc     := {}
	Private nTotalDev  := 0
	Private nTotalFat	:= 0
	
	Private nTotalPeso := 0
	Private nTotalDesc := 0
	Private nTotalLiq  := 0
	
	Private _xSerie := Space(99)
	Private _oSerie := Nil


	Private aLeg      := { {"N" , "ENABLE"      },;
	{"R" , "BR_VERMELHO" },;
	{"T" , "BR_AZUL"     } }


	//-------------------------------------------------------.
	// Array com as cores das legendas                        |
	//-------------------------------------------------------'
	_aCores := {{'_aBrowse[oBrowse:At()][01] = "N" ',"ENABLE"     },;	// PRÉ-ROMANEIO
	{'_aBrowse[oBrowse:At()][01] = "R" ',"BR_VERMELHO"},;	// ENTREGUE
	{'_aBrowse[oBrowse:At()][01] = "T" ',"BR_AZUL"    } } 	// ESTORNO DE VENDA

	//-------------------------------------------------------.
	// Array com as cores das legendas                        |
	//-------------------------------------------------------'
	_aLegenda := {{"ENABLE"     , "Normais"        },;
	{"BR_VERMELHO", "Reservas"       },;
	{"BR_AZUL"    , "Transferencias" }}


	_aM0ARea := SM0->(GetArea())

	SM0->(dbGoTop())
	While !SM0->(EOF())
		If SM0->M0_CODIGO = cEmpAnt
			aAdd(_aBrowse,{.T., SM0->M0_CODFIL + ' - ' + SM0->M0_NOME})
			aAdd(_aInsc,{SM0->M0_CGC,SM0->M0_INSC})
		EndIf
		SM0->(dbSKip())
	EndDo

	SM0->(RestArea(_aM0ARea))

	cwCabec := 'Status' +Chr(9)+ 'Empresa'   + Chr(9) +'Numero'  + Chr(9) +'Nota Fiscal'+ Chr(9) +'Serie'   + Chr(9) + 'Dt venda' + Chr(9) + 'Cliente'  + Chr(9) +'Loja'     + Chr(9)
	cwCabec += 'Nome Cli.'+ Chr(9) +'Vendedor'+ Chr(9) +'Total Bruto'+ Chr(9) +'Desconto'+ Chr(9) + 'Devolução'+ Chr(9) + 'Total Liq'+ Chr(9) +'Forma Pag'+ Chr(9)
	cwCabec += 'Num. Entrega'+ Chr(9) +'Quem Recebeu'+ Chr(9) +'Data Rec.'+ Chr(9) +'Hora Rec.'+ Chr(9) +'Qtd Entregas'+ Chr(9) +'Orcamento'+ Chr(9)+'Filial ' + Chr(9)
	cwCabec += 'Emissao'+ Chr(9) +'Peso'+Chr(13) +Chr(10)


	//-------------------------------------------------------.
	// itens do combobox                                      |
	//-------------------------------------------------------'
	AADD(aTipos,"Faturamento")
	AADD(aTipos,"Outros")
	AADD(aTipos,"Ambos")

	//-------------------------------------------------------.
	// Chamada da rotina para filtrar os dados                |
	//-------------------------------------------------------'
	Processa({|| GetInf(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal, 1)},'Filtrando Dados' )

	//-------------------------------------------------------.
	// Cadastrando a fonte que serã utiizada na tela          |
	//-------------------------------------------------------'
	oFont := TFont():New('Courier new',,-12,.T.)

	//-------------------------------------------------------.
	// Montagem da tela de consulta romaneio                  |
	//-------------------------------------------------------'
	//DEFINE DIALOG _oJanela TITLE "Nova Consulta Vendas" FROM 001,001 TO 550,1200 PIXEL



	//-------------------------------------------------------.
	// Verifica o tamanha disponivel da tela                  |
	//-------------------------------------------------------'
	aCoors := FwGetDialogSize(oMainWnd)
	//-------------------------------------------------------.
	// Montagem da tela de consulta romaneio                  |
	//-------------------------------------------------------'
	_oJanela  := MSDialog():New(aCoors[1], aCoors[2],aCoors[3], aCoors[4],"Nova Consulta Vendas",,,,,CLR_BLACK,CLR_WHITE,,,.T.)


	oLayer := FWLAYER():New()
	oLayer:Init(_oJanela,.F.,.T.)
	oLayer:AddLine('UP',20)
	oLayer:AddLine('MIDDLE',75)
	oLayer:AddLine('DOWN',05)

	oLayer:AddColumn('ALL' ,082,,'UP')
	oLayer:AddColumn('ALL' ,100,,'MIDDLE')
	oLayer:AddColumn('ALL' ,100,,'DOWN')

	//oLayer:AddColumn('ALL' ,80,,'UP')
	oLayer:AddColumn('ALL2' ,18,,'UP')

	_oUp      := oLayer:GetColPanel('ALL','UP'    )
	_oUp2     := oLayer:GetColPanel('ALL2','UP'   )

	_oMiddle  := oLayer:GetColPanel('ALL','MIDDLE')
	_oDown    := oLayer:GetColPanel('ALL','DOWN'  )

	aCoors := MsAdvSize()

	@ 003,005 TO 65,aCoors[3]  label "Filtros" OF _oJanela PIXEL

	//-------------------------------------------------------.
	// Objetos para a Filtragem da Data de Faturamento        |
	//-------------------------------------------------------'
	@ 012,007 Say "Periodo: "                               Size 50,10 Pixel Of _oUp
	@ 012,045 MsGet _oDatIni      Var _dDataInicial         Size 60,08 Pixel of _oUp
	@ 012,110 MsGet _oDatFim      Var _dDataFinal           Size 60,08 Pixel of _oUp

	//-------------------------------------------------------.
	// Objetos para a Filtragem de clientes                   |
	//-------------------------------------------------------'
	@ 027,007 Say "Clientes: "                              Size 50,10 Pixel Of _oUp
	@ 027,045 MsGet _oClienteIni  Var _cClienteIni F3 'SA1' Size 60,08 Pixel of _oUp
	@ 027,110 MsGet _oClienteFim  Var _cClienteFim F3 'SA1' Size 60,08 Pixel of _oUp

	//-------------------------------------------------------.
	// Objetos para a Filtragem de Vendedores                 |
	//-------------------------------------------------------'
	@ 042,007 Say "Vendedores: "                            Size 50,10 Pixel Of _oUp
	@ 042,045 MsGet _oVendIni     Var _cVendIni    F3 'SA3' Size 60,08 Pixel of _oUp
	@ 042,110 MsGet _oVendFim     Var _cVendFim    F3 'SA3' Size 60,08 Pixel of _oUp


	//-------------------------------------------------------.
	// Objeto para a Filtragem de CFOP's de Venda             |
	//-------------------------------------------------------'
	@ 010,190-15 TO 053,340 + 20 label "Filiais e Empresa" OF _oJanela PIXEL
	@ 020,200-15 CHECKBOX _oChk01 VAR _lChk01 PROMPT "00 - Matriz 06200" SIZE 80,9 PIXEL OF _oUp
	@ 020,260-15 CHECKBOX _oChk02 VAR _lChk02 PROMPT "01 - Matriz 06300" SIZE 80,9 PIXEL OF _oUp
	@ 030,200-15 CHECKBOX _oChk03 VAR _lChk03 PROMPT "02 - Matriz 04208" SIZE 80,9 PIXEL OF _oUp
	@ 030,260-15 CHECKBOX _oChk04 VAR _lChk04 PROMPT "03 - Filial 04 "   SIZE 80,9 PIXEL OF _oUp
	@ 040,200-15 CHECKBOX _oChk05 VAR _lChk05 PROMPT "04 - Filial 02"    SIZE 80,9 PIXEL OF _oUp
	@ 040,260-15 CHECKBOX _oChk06 VAR _lChk06 PROMPT "05 - Deposito"     SIZE 80,9 PIXEL OF _oUp
	
	@ 030,260+45 CHECKBOX _oChk10 VAR _lChk10 PROMPT "05 - Emp.Silves"   SIZE 80,9 PIXEL OF _oUp
	@ 040,260+45 CHECKBOX _oChk10 VAR _lChk11 PROMPT "06 - Emp.D Pedro"  SIZE 80,9 PIXEL OF _oUp

	//-------------------------------------------------------.
	// Objeto para a Filtragem de CFOP's de Venda            |
	//-------------------------------------------------------'
	@ 027,360+10 TO 053,530 label "Tipo de Vendas" OF _oJanela PIXEL
	@ 037,370+10 CHECKBOX _oChk07 VAR _lChk07 PROMPT "Reservas"	     SIZE 80,9 PIXEL OF _oUp
	@ 037,420+10 CHECKBOX _oChk08 VAR _lChk08 PROMPT "Normais "      SIZE 80,9 PIXEL OF _oUp
	@ 037,470+10 CHECKBOX _oChk09 VAR _lChk09 PROMPT "Transferecias" SIZE 80,9 PIXEL OF _oUp

	//-------------------------------------------------------.
	// Objeto para a Filtragem de CFOP's de Venda             |
	//-------------------------------------------------------'
	@ 012,360+10 Say "Tipo CFOP:"  Size 050,10 Pixel Of _oJanela
	@ 012,400+00 MSCOMBOBOX _oTipo2 VAR _cTipo2 ITEMS aTipos SIZE 060,50 OF _oUp PIXEL
	
	@ 012,465+00 Say "Serie:"  Size 050,10 Pixel Of _oJanela
	@ 012,480+00 MsGet _oSerie     Var _xSerie  Size 40,08 Pixel of _oJanela
	//@ 012,400+00 MSCOMBOBOX _oSerie VAR _cSerie ITEMS aTipos SIZE 060,50 OF _oUp PIXEL

	//-------------------------------------------------------.
	// Botoes de opcoes a serem realizadas na tela           |
	//-------------------------------------------------------'
	//@ 002,550 Button "&Consultar" Size 40,12 Pixel of _oUp Action MsgRun('Filtrando Dados...' ,,{|| GetInf(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal, 2), oBrowse:Refresh() })
	//@ 012,550 Button "&Legenda"   Size 40,12 Pixel of _oUp Action BrwLegenda("Cadastro de Romaneio","Legendas",_aLegenda)
	//@ 024,550 Button "&Exportar"  Size 40,12 Pixel of _oUp Action MsgRun('Exportando Excel...',,{|| ExportaExcel(_aBrowse, cwCabec), oBrowse:Refresh() })
	//@ 036,550 Button "&Fechar"    Size 40,12 Pixel of _oUp Action _oUp:End()

	@ 010,10 Button "&Consultar" Size 40,12 Pixel of _oUp2 Action MsgRun('Filtrando Dados...' ,,{|| GetInf(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal, 2), oBrowse:Refresh() })
	@ 024,10 Button "&Legenda"   Size 40,12 Pixel of _oUp2 Action BrwLegenda("Cadastro de Romaneio","Legendas",_aLegenda)

	@ 010,55 Button "&Exportar"  Size 40,12 Pixel of _oUp2 Action MsgRun('Exportando Excel...',,{|| ExportaExcel(_aBrowse, cwCabec), oBrowse:Refresh() })
	@ 024,55 Button "&Fechar"    Size 40,12 Pixel of _oUp2 Action _oJanela:End()
	//-------------------------------------------------------.
	// Objetos de montagem de acols / Grid                    |
	//-------------------------------------------------------'
	//@ 005,005 TO 240,595 label "Dados Pedidos de Chapas Cortadas" OF _oUp PIXEL


	oBrowse := FWBrowse():New()
	oBrowse:SetDataArray()
	oBrowse:AddStatusColumns(  { || _aCores[aScan(_aCores,{|x| &(x[01]) })][02] }, {||} )

	_adCabec := {}

	aAdd(_adCabec,{ _aCabec[22]  , {|| _aBrowse[oBrowse:At()][22] }  , 'C' ,  '@!' , 1 ,      02,  0    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[02]  , {|| _aBrowse[oBrowse:At()][02] }  , 'C' ,  '@!' , 1 ,      02,  0    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[03]  , {|| _aBrowse[oBrowse:At()][03] }  , 'C' ,  '@!' , 1 ,      06,  0    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[23]  , {|| _aBrowse[oBrowse:At()][23] }  , 'D' ,  '@!' , 1 ,      08,  0    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[04]  , {|| _aBrowse[oBrowse:At()][04] }  , 'C' ,  '@!' , 1 ,      09,  0    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[05]  , {|| _aBrowse[oBrowse:At()][05] }  , 'C' ,  '@!' , 1 ,      03,  0    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[06]  , {|| _aBrowse[oBrowse:At()][06] }  , 'D' ,  '@!' , 1 ,      08,  0    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[07]  , {|| _aBrowse[oBrowse:At()][07] }  , 'C' ,  '@!' , 1 ,      06,  0    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[08]  , {|| _aBrowse[oBrowse:At()][08] }  , 'C' ,  '@!' , 1 ,      02,  0    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[09]  , {|| _aBrowse[oBrowse:At()][09] }  , 'C' ,  '@!' , 1 ,      30,  0    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[10]  , {|| _aBrowse[oBrowse:At()][10] }  , 'C' ,  '@!' , 1 ,      20,  0    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[11]  , {|| _aBrowse[oBrowse:At()][11] }  , 'N' ,  '@!' , 2 ,      12,  2    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[12]  , {|| _aBrowse[oBrowse:At()][12] }  , 'N' ,  '@!' , 2 ,      12,  2    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[13]  , {|| _aBrowse[oBrowse:At()][13] }  , 'N' ,  '@!' , 2 ,      12,  2    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[14]  , {|| _aBrowse[oBrowse:At()][14] }  , 'N' ,  '@!' , 2 ,      12,  2    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[15]  , {|| _aBrowse[oBrowse:At()][15] }  , 'C' ,  '@!' , 1 ,      10,  0    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[16]  , {|| _aBrowse[oBrowse:At()][16] }  , 'N' ,  '@!' , 2 ,      04,  0    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[17]  , {|| _aBrowse[oBrowse:At()][17] }  , 'C' ,  '@!' , 1 ,      06,  0    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[18]  , {|| _aBrowse[oBrowse:At()][18] }  , 'D' ,  '@!' , 1 ,      08,  0    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[19]  , {|| _aBrowse[oBrowse:At()][19] }  , 'C' ,  '@!' , 1 ,      05,  0    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[20]  , {|| _aBrowse[oBrowse:At()][20] }  , 'N' ,  '@!' , 2 ,      04,  0    ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[21]  , {|| _aBrowse[oBrowse:At()][21] }  , 'C' ,  '@!' , 1 ,      06,  0    ,,,,,,  })

	oBrowse:SetColumns(_adCabec)
	oBrowse:SetArray(_aBrowse)
	oBrowse:SetOwner(_oMiddle)
	//oBrowse:SetDoubleClick( { || MsgRun('Filtrando Dados, Aguarde...',,{|| u_FATC23AA(  _aBrowse[oBrowse:nAt][02] , If( Empty(_aBrowse[oBrowse:nAt][21]), _aBrowse[oBrowse:nAt][03], _aBrowse[oBrowse:nAt][21])  , _aBrowse[oBrowse:nAt][04], _aBrowse[oBrowse:nAt][05], !Empty(_aBrowse[oBrowse:nAt][21]), _aBrowse[oBrowse:nAt][22]  ) } )  } )
	oBrowse:SetDoubleClick( { || MsgRun('Filtrando Dados, Aguarde...',,{|| u_FATC06AA(  _aBrowse[oBrowse:nAt][02] , If( Empty(_aBrowse[oBrowse:nAt][21]), _aBrowse[oBrowse:nAt][03], _aBrowse[oBrowse:nAt][21])  , _aBrowse[oBrowse:nAt][04], _aBrowse[oBrowse:nAt][05], !Empty(_aBrowse[oBrowse:nAt][21]), _aBrowse[oBrowse:nAt][22]  ) } )  } )

	oBrowse:Activate()

	//	oBrowse := TcBrowse():New ( 075,010,580,160 , , _aCabec,/*[ aColSizes]*/           , _oMiddle, /*[ cField]*/,  , , /*[ bChange]*/, /*[ bLDblClick]*/, /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/,         /*cAlias*/, /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )

	/*  oBrowse:SetArray(_aBrowse)
	oBrowse:bLine := {|| { LoadBitmap(GetResources(),_aCores[aScan(_aCores,{|x| &(x[01]) })][02] ) ,;
	_aBrowse[oBrowse:nAt][02] ,;
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
	_aBrowse[oBrowse:nAt][18] ,;
	_aBrowse[oBrowse:nAt][19] ,;
	_aBrowse[oBrowse:nAt][20] ,;
	_aBrowse[oBrowse:nAt][21] }}


	oBrowse:Refresh()
	oBrowse:BLDBLCLICK := {||  }
	oBrowse:nScrollType := 0 // Define a barra de rolagem VCR

	*/

	oFont := TFont():New('Courier new',,-12,.T.)
	oFont := TFont():New('Arial',,-12,.T.)

	TSay():New(002,005,{|| "TOTAL R$ :" },_oDown,, ,,,,.T.,CLR_BLACK,CLR_WHITE,90,20)
	Private oSay1:= TSay():New(002,060,{|| 0 },_oDown,"@E 999,999,999.99",oFont,,,,.T.,CLR_RED,CLR_WHITE,80,20)

	TSay():New(002,150,{|| "DEVOLUÇÃO R$ :" },_oDown,, ,,,,.T.,CLR_BLACK,CLR_WHITE,90,20)
	Private oSay2:= TSay():New(002,200,{|| 0 },_oDown,"@E 999,999,999.99",oFont,,,,.T.,CLR_RED,CLR_WHITE,80,20)

	TSay():New(002,300,{|| "TOTAL PESO KG :" },_oDown,, ,,,,.T.,CLR_BLACK,CLR_WHITE,90,20)
	Private oSay3:= TSay():New(002,350,{|| 0 },_oDown,"@E 999,999,999.99",oFont,,,,.T.,CLR_RED,CLR_WHITE,80,20)

	TSay():New(002,430,{|| "TOTAL(-DEVOLUÇÕES) R$ :" },_oDown,, ,,,,.T.,CLR_BLACK,CLR_WHITE,90,20)
	Private oSay4:= TSay():New(002,500,{|| 0 },_oDown,"@E 999,999,999.99",oFont,,,,.T.,CLR_RED,CLR_WHITE,80,20)
	
	TSay():New(002,580,{|| "MÉDIA DE PREÇO R$ :" },_oDown,, ,,,,.T.,CLR_BLACK,CLR_WHITE,90,20)
	Private oSay5:= TSay():New(002,620,{|| 0 },_oDown,"@E 999,999,999.99",oFont,,,,.T.,CLR_RED,CLR_WHITE,80,20)


	oSay1:SetText( nTotalFat )
	oSay2:SetText( nTotalDev )
	oSay3:SetText( nTotalPeso)
	oSay4:SetText( nTotalFat-nTotalDev)
	oSay5:SetText( (nTotalFat-nTotalDev)/nTotalPeso)
	
	Activate Dialog _oJanela Centered

Return Nil

User Function FATC06AA(_cdFil,_cdNum,_cdNota,_cdSerie,_ldOrc,_cdEmp)
	Local _odBrw := Nil
	Local _xdQry := Nil

	Local _xdDados := {}
	Local _xdCab   := {}

	Default _cdFil := '01'
	Default _cdNum := ''
	Default _cdNota := '000001327'
	Default _cdSerie := '1'
	Default _cdEmp   := '05'

	If Type("cAcesso") = "U"
		Prepare Environment Empresa '01' Filial '01' Tables 'SZE,SD2,SF2,SL1,SC5,SA3' 
	EndIf

	oLayer   := FwLayer():New()

	aAdd(_xdCab,  {"Produto"     , {|| _xdDados[_odBrw:At()][02]},"C","@!                ",1, 06, 00, .F. })//, {|| .T. } , " "  ,{|| /**/ },.F.,,,,  }   )
	aAdd(_xdCab,  {"Descricao"   , {|| _xdDados[_odBrw:At()][03]},"C","@!                ",1, 25, 00, .F. })//, {|| .T. } , " "  ,{|| /**/ },.F.,,,,  }   )
	aAdd(_xdCab,  {"U.M."        , {|| _xdDados[_odBrw:At()][08]},"C","@!                ",1, 02, 00, .F. })//, {|| .T. } , " "  ,{|| /**/ },.F.,,,,  }   )
	aAdd(_xdCab,  {"Quantidade"  , {|| _xdDados[_odBrw:At()][04]},"N","@E 999,999,999.99 ",2, 06, 00, .F. })//, {|| .T. } , " "  ,{|| /**/ },.F.,,,,  }   )
	//aAdd(_xdCab,  {"2 U.M."      , {|| _xdDados[_odBrw:At()][09]},"C","@!                ",1, 02, 00, .F. })//, {|| .T. } , " "  ,{|| /**/ },.F.,,,,  }   )
	//aAdd(_xdCab,  {"2 Qt Segum"  , {|| _xdDados[_odBrw:At()][10]},"N","@E 999,999,999.99 ",2, 06, 00, .F. })//, {|| .T. } , " "  ,{|| /**/ },.F.,,,,  }   )
	aAdd(_xdCab,  {"Unitario"    , {|| _xdDados[_odBrw:At()][05]},"N","@E 999,999,999.99 ",2, 06, 00, .F. })//, {|| .T. } , " "  ,{|| /**/ },.F.,,,,  }   )
	aAdd(_xdCab,  {"Total"       , {|| _xdDados[_odBrw:At()][06]},"N","@E 999,999,999.99 ",2, 06, 00, .F. })//, {|| .T. } , " "  ,{|| /**/ },.F.,,,,  }   )
	//aAdd(_xdCab,  {"ICMS RETIDO" , {|| _xdDados[_odBrw:At()][07]},"N","@E 999,999,999.99 ",2, 06, 00, .F. })//, {|| .T. } , " "  ,{|| /**/ },.F.,,,,  }   )

	_xdQry := " Select B.*,ROUND( TOTAL / QUANT,2) UNITARIO from (" 
	_xdQry += " Select D2_COD PRODUTO ,D2_UM UM,D2_SEGUM SEGUM,B1_ESPECIF DESCRICAO,SUM(D2_QUANT) QUANT,SUM(D2_QTSEGUM) QTSEGUM,SUM(D2_TOTAL) TOTAL,SUM(D2_ICMSRET) ICMSRET"
	_xdQry +=  " From SD2" + _cdEmp + "0 D2 With(nolock)"
	_xdQry +=  "    INNER JOIN SB1" + _cdEmp + "0 B1 With(nolock) on B1_COD = D2_COD and B1.D_E_L_E_T_ = ' ' "
	_xdQry +=  " Where D2_DOC = '" + _cdNota + "'"
	_xdQry +=  "  And D2_SERIE = '"+ _cdSerie + "'"
	_xdQry +=  "  And D2.D_E_L_E_T_ = '' "
	_xdQry +=  " GROUP BY D2_COD,D2_UM,B1_ESPECIF,D2_SEGUM
	_xdQry += " )B

	_xTbl := MPSysOpenQuery( _xdQry )
	_xdDados := {}
	_xdTotal := 0
	While !(_xTbl)->(EOF())

		_xdLin := {}
		aAdd(_xdLin,Nil)
		aAdd(_xdLin, (_xTbl)->PRODUTO   )
		aAdd(_xdLin, (_xTbl)->DESCRICAO )
		aAdd(_xdLin, (_xTbl)->QUANT     )
		aAdd(_xdLin, (_xTbl)->UNITARIO  )
		aAdd(_xdLin, (_xTbl)->TOTAL     )
		aAdd(_xdLin, (_xTbl)->ICMSRET   )
		aAdd(_xdLin, (_xTbl)->UM   )
		aAdd(_xdLin, (_xTbl)->SEGUM )
		aAdd(_xdLin, (_xTbl)->QTSEGUM   )
		aAdd(_xdDados,_xdLin)

		_xdTotal += (_xTbl)->TOTAL

		(_xTbl)->(dbSkip())
	EndDo

	Define Msdialog _odDlg Title "" From 050,050 to 490,900 COLORS 0, 16777215 Pixel STYLE WS_CLIPCHILDREN  //DS_MODALFRAME
	oLayer:Init(_odDlg)

	oLayer:AddLine('TOP'   ,010)
	oLayer:AddLine('MIDDLE',070)
	oLayer:AddLine('BOTTOM',020)

	oLayer:addCollumn('FULL',100,.F.,'TOP')
	oLayer:addCollumn('FULL',100,.F.,'MIDDLE')
	oLayer:addCollumn('FULL',100,.F.,'BOTTOM')

	_xdFul0 := oLayer:getColPanel('FULL','TOP')
	_xdFull := oLayer:getColPanel('FULL','MIDDLE')
	_xdFul2 := oLayer:getColPanel('FULL','BOTTOM')
	oFont := TFont():New('Courier new',,-18,.T.)
	TSay():New(01,01,{||'Total da NF  R$ ' + Alltrim(Transform(_xdTotal,"@E 999,999,999.99")) },_xdFul0,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,200,20)

	_odBrw := FwBrowse():New()
	_odBrw:SetOwner(_xdFull)
	_odBrw:SetDataArray()
	_odBrw:SetColumns(_xdCab)
	_odBrw:SetArray(_xdDados)

	_odBrw:Refresh()
	_odBrw:Activate()

	//_odBrw := TcBrowse():New ( 010,007,390,100 , , /*aCabec*/ , /*[ aColSizes]*/, oDialog, /*[ cField]*/,  , , /*[ bChange]*/, /*[ bLDblClick]*/, /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/,  _cdAls, /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ ,  .T. /*[lVScroll]*/ )
	//_odBrw:bLine := _aBline
	//For _nK := 1 To Len(_aBline)
	//      _odBrw:AddColumn(TCColumn():New(aCabec[_nK], _aBline[_nK][01], _aBLine[_nK][02] ,,, iIf( (_aBLine[_nK][02]) != "@!","RIGTH", "LEFT")  ,,.F.,.F.,,,,.F.,) )
	//Next
	//_odBrw:blDblClick := {|| oDialog:End() }

	TButton():New(01,01,'&Retornar'   ,_xdFul2,{|| _odDlg:End() } ,40,12,,,,.T.)
	TButton():New(01,46,'&Old'   ,_xdFul2,{|| u_FATC23AA(  _cdFil , _cdNum , _cdNota, _cdSerie, _ldOrc, _cdEmp  )  } ,40,12,,,,.T.)

	_odDlg:SetCSS("MsDialog{ border:1px; }")  
	Activate MSDIALOG _odDlg Centered



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
	Local cQry      := ''
	Local cCampos    := ''
	Local cTable     := GetNextALias()
	Local cAuxStatus := "("
	Local _xQry := " "

	xCRLF := cHR(13) + cHR(10)

	_aBrowse := {}

	If _lChk01
		cAuxStatus += "'00',"
	EndIf
	If _lChk02
		cAuxStatus += "'01',"
	EndIf
	If _lChk03
		cAuxStatus += "'02',"
	EndIf
	If _lChk04
		cAuxStatus += "'03',"
	EndIf

	If _lChk05
		cAuxStatus += "'04',"
	EndIf

	If _lChk06
		cAuxStatus += "'05',"
	EndIf

	If Len(AllTrim(cAuxStatus)) > 2
		cAuxStatus := SubStr( cAuxStatus, 1, Len(AllTrim(cAuxStatus)) -1 ) + ")"
	EndIf
	
	cNameTemp := StrTran(cUserName,'.','')

	_xTmp01 := "##"+cNameTemp+"01"
	_xTmp05 := "##"+cNameTemp+"05"
	_xTmp06 := "##"+cNameTemp+"06"

	_xQry :=         " Select 
	_xQry += xCRLF + " D2_FILIAL,
	_xQry += xCRLF + " D2_DOC,
	_xQry += xCRLF + " D2_SERIE,
	_xQry += xCRLF + " D2_CLIENTE,
	_xQry += xCRLF + " D2_LOJA,
	_xQry += xCRLF + " D2_PEDIDO,	
	_xQry += xCRLF + " D2_VALBRUT,
	_xQry += xCRLF + " D2_EMISSAO,
	_xQry += xCRLF + " F2_VEND1,
	_xQry += xCRLF + " F2_VALBRUT,
	_xQry += xCRLF + " F2_DESCONT,
	_xQry += xCRLF + " F2_COND,
	_xQry += xCRLF + " D2_VALDEV,
	_xQry += xCRLF + " D2_QUANT,
	_xQry += xCRLF + " B1_PESO,
	_xQry += xCRLF + " (D2_QUANT - D2_QTDEDEV) AS PESO
	_xQry += xCRLF + " Into " + _xTmp01 + " From SD2010 SD2 "

	_xQry += xCRLF + " INNER JOIN SB1010 SB1 (NOLOCK) " 
	_xQry += xCRLF + "    ON SB1.D_E_L_E_T_ = '' AND SD2.D2_COD=SB1.B1_COD"

	_xQry += xCRLF + " INNER JOIN SF2010 SF2 (NOLOCK) "        
	_xQry += "    ON SF2.D_E_L_E_T_ = '' "                                
	_xQry += "   AND SD2.D2_FILIAL  = SF2.F2_FILIAL "                     
	_xQry += "   AND SD2.D2_DOC     = SF2.F2_DOC "                        
	_xQry += "   AND SD2.D2_SERIE   = SF2.F2_SERIE "                      
	

	_xQry += xCRLF + " INNER JOIN SA3010 AS SA3 (NOLOCK) " 
	_xQry += xCRLF + "    ON SA3.D_E_L_E_T_ = '' AND SF2.F2_VEND1 = SA3.A3_COD AND A3_CODUSR = '" + __CUSERID + "' "
	
	_xQry += xCRLF + " INNER JOIN SF4010 SF4 (NOLOCK) "        
	_xQry += "    ON SF4.D_E_L_E_T_ = '' "                                
	_xQry += "   AND SD2.D2_TES  = SF4.F4_CODIGO "                     
	
	_xQry += xCRLF + " WHERE SD2.D_E_L_E_T_ = '' "                                                             + Chr(13) + Chr(10)
	_xQry += xCRLF + "   AND SD2.D2_EMISSAO BetWeen '" + dToS(_dDataInicial) +"' And '"+ dToS(_dDataFinal) +"'"+ Chr(13) + Chr(10)
	_xQry += xCRLF + "   AND SD2.D2_CLIENTE BetWeen '" +      _cClienteIni   +"' And '"+      _cClienteFim +"'"+ Chr(13) + Chr(10)
	_xQry += xCRLF + "   AND SF2.F2_VEND1   BetWeen '" +      _cVendIni      +"' And '"+      _cVendFim    +"'"+ Chr(13) + Chr(10)

	_xFil := ""
	If !Empty(_xSerie)
	   _xQry += xCRLF + "   AND SD2.D2_SERIE In  " + FormatIn(_xSerie,",")
	EndIf    

	If Len(AllTrim(cAuxStatus)) > 2
		_xQry += xCRLF + "   AND SD2.D2_FILIAL IN " + cAuxStatus
		_xFil := "   AND SD2.D2_FILIAL IN " + cAuxStatus
	ElseIf _lChk10 .Or. _lChk11 
		_xQry += xCRLF + "   AND SD2.D2_FILIAL IN ('01') " 
		_xFil := "   AND SD2.D2_FILIAL IN ('01') "
	EndIf
/*
	If !(_lChk07 .And. _lChk08)
		If _lChk07
			_xQry += xCRLF + "  And C5_ORCRES != ''"
		EndIf
		If _lChk08
			_xQry += xCRLF + "  And ISNUll(C5_ORCRES,'') = '' "
		EndIf
	EndIf
*/
	//001190// Somente Cliente da Filial da Industria
	//001184//
	If _lChk09
		//      cQry += " And F2_CLIENTE = '" + SuperGetMv("MV_XCLILOJ",.F.,"001190") + "'"
	Else
		_xQry += xCRLF + "  AND D2_CLIENTE NOT IN " + FormatIn(GetMV("MV_XCLIAA"),",")
	EndIf

	If _cTipo2 == 	"Faturamento"
		_xQry += xCRLF + "   AND ( SD2.D2_CF     IN ('5101', '5102', '5116', '5117', '5118', '5119', '5122', '5123', "
		_xQry += xCRLF +                   " '5124', '5125', '5401', '5405', '6101', '6102', '6107', '6108', "
		_xQry += xCRLF +                   " '6109', '6110', '6116', '6117', '6118', '6119', '6122', '6403') OR SD2.D2_TES = '564' OR ( SD2.D2_CF IN ('5949','6501') AND SF4.F4_DUPLIC='S') )   "  + xCRLF

	ElseIf _cTipo2 == "Outros"
		_xQry += xCRLF + "   AND ( SD2.D2_CF NOT IN ('5101', '5102', '5116', '5117', '5118', '5119', '5122', '5123', "
		_xQry +=                    " '5124', '5125', '5401', '5405', '6101', '6102', '6107', '6108', "
		_xQry +=                    " '6109', '6110', '6116', '6117', '6118', '6119', '6122', '6403') OR SD2.D2_TES = '564')"  + xCRLF
	EndIf
	//Alert(_xTmp01)
	//Aviso('',_xQry,{'OK'})
	//If Len(AllTrim(cAuxStatus)) > 2    
	nRet01 := tcSqlExec(_xQry) 
	//EndIf
	//Alert(nRet01)

	If _lChk10

		_cSD2 := "SD2010"//RetSqlName("SD2")
		_cSF2 := "SF2010"//RetSqlName("SF2")
		_cSB1 := "SB1010"//RetSqlName("SB1")

		_xSD2 := "SD2050"//RetSqlName("SD2")
		_xSF2 := "SF2050"//RetSqlName("SF2")		
		_xSB1 := "SB1050"//RetSqlName("SB1")		


		_xQry05 := _xQry
		_xQry05 := StrTran(_xQry05,_cSD2,_xSD2)
		_xQry05 := StrTran(_xQry05,_cSF2,_xSF2)
		_xQry05 := StrTran(_xQry05,_cSB1,_xSB1)
		_xQry05 := StrTran(_xQry05,_xTmp01,_xTmp05)
		_xQry05 := StrTran(_xQry05,"And ISNUll(C5_ORCRES,'') = ''","")
		_xQry05 := StrTran(_xQry05,"And C5_ORCRES != ''","")

		//Alert(_xTmp01)
		//Aviso('',_xQry05,{'OK'})
		nRet05 := tcSqlExec(_xQry05) 
		//Alert(nRet05)
	EndIf
	
	If _lChk11

		_cSD2 := "SD2010"//RetSqlName("SD2")
		_cSF2 := "SF2010"//RetSqlName("SF2")
		_cSB1 := "SB1010"//RetSqlName("SB1")

		_xSD2 := "SD2060"//RetSqlName("SD2")
		_xSF2 := "SF2060"//RetSqlName("SF2")		
		_xSB1 := "SB1060"//RetSqlName("SB1")		


		_xQry06 := _xQry
		_xQry06 := StrTran(_xQry06,_cSD2,_xSD2)
		_xQry06 := StrTran(_xQry06,_cSF2,_xSF2)
		_xQry06 := StrTran(_xQry06,_cSB1,_xSB1)
		_xQry06 := StrTran(_xQry06,_xTmp01,_xTmp06)
		_xQry06 := StrTran(_xQry06,"And ISNUll(C5_ORCRES,'') = ''","")
		_xQry06 := StrTran(_xQry06,"And C5_ORCRES != ''","")

		//Alert(_xTmp01)
		//Aviso('',_xQry05,{'OK'})
		nRet06 := tcSqlExec(_xQry06) 
		//Alert(nRet05)
	EndIf

	/*
	if nRet01 >= 0
	tcSqlExec("drop table " + _xTmp01)
	EndIf
	if nRet05 >= 0
	tcSqlExec("drop table " + _xTmp05)
	EndIf
	*/

	//-------------------------------------------------------.
	// Campos retornados na consulta SQL                      |
	//-------------------------------------------------------'
	cQry := " SELECT CASE WHEN D2_CLIENTE IN " + FormatIn(GetMV("MV_XCLIAA"),",")	                    + Chr(13) + Chr(10)
	cQry += "  			    THEN 'T' ELSE CASE WHEN C5_ORCRES = '' THEN 'N' ELSE 'R' END " 				  + Chr(13) + Chr(10)
	cQry += "        END AS D2_STATUS, "                                                              + Chr(13) + Chr(10)
	cQry += "        SD2.D2_FILIAL , SD2.D2_PEDIDO ,C5_EMISSAO,L1_EMISSAO, SD2.D2_EMISSAO, SD2.D2_CLIENTE, SD2.D2_LOJA  ,"  + Chr(13) + Chr(10)
	cQry += "        SA1.A1_NOME   , SF2.F2_VEND1  , ISNULL(SL1.L1_NUM, '') AS L1_NUM    , SF2.F2_DOC    , SF2.F2_SERIE ,"  + Chr(13) + Chr(10)
	cQry += "        SF2.F2_VALBRUT, SF2.F2_DESCONT, SF2.F2_COND   , SZE.ZE_ROMAN  , SZE.ZE_NOMREC,"  + Chr(13) + Chr(10)
	cQry += "        SZE.ZE_DTREC  , SZE.ZE_HORREC , SL1.L1_FILIAL , SUM(D2_VALDEV) AS D2_VALDEV  ,"  + Chr(13) + Chr(10)
	cQry += "        SUM( (D2_QUANT - D2_QTDEDEV)) AS PESO, SUM(D2_VALBRUT) AS D2_VALBRUT,"+ Chr(13) + Chr(10)
	cQry += "        ( SELECT CASE WHEN COUNT(*) > 0 THEN COUNT(*) ELSE 1 END "                       + Chr(13) + Chr(10)
	cQry += "            FROM ( SELECT PED.D2_FILIAL,PED.D2_PEDIDO,PED.D2_DOC,PED.D2_SERIE "          + Chr(13) + Chr(10)
	cQry += "                     FROM " + RetSqlName("SD2") + " PED (NOLOCK) "                       + Chr(13) + Chr(10)
	cQry += "                    WHERE PED.D_E_L_E_T_ = '' AND PED.D2_FILIAL = SD2.D2_FILIAL  "       + Chr(13) + Chr(10)
	cQry += "                      AND PED.D2_PEDIDO <> '' AND PED.D2_PEDIDO = SD2.D2_PEDIDO  "	     + Chr(13) + Chr(10)
	cQry += "                    GROUP BY PED.D2_FILIAL,PED.D2_PEDIDO,PED.D2_DOC,PED.D2_SERIE "		  + Chr(13) + Chr(10)
	cQry += "                 ) AS AUX "                                                              + Chr(13) + Chr(10)
	cQry += "        ) AS ENTREGAS"                                                                   + Chr(13) + Chr(10)

	_xNQry := " SELECT CASE WHEN D2_CLIENTE IN " + FormatIn(GetMV("MV_XCLIAA"),",")	                    + Chr(13) + Chr(10)
	_xNQry += "  			    THEN 'T' ELSE CASE WHEN C5_ORCRES = '' THEN 'N' ELSE 'R' END " 				  + Chr(13) + Chr(10)
	_xNQry += "        END AS D2_STATUS, "                                                              + Chr(13) + Chr(10)
	_xNQry += "        SD2.D2_FILIAL , SD2.D2_PEDIDO ,C5_EMISSAO,L1_EMISSAO, SD2.D2_EMISSAO, SD2.D2_CLIENTE, SD2.D2_LOJA  ,"  + Chr(13) + Chr(10)
	_xNQry += "        SA1.A1_NOME   , SF2.F2_VEND1  , ISNULL(SL1.L1_NUM, '') AS L1_NUM    , SF2.F2_DOC    , SF2.F2_SERIE ,"  + Chr(13) + Chr(10)
	_xNQry += "        SF2.F2_VALBRUT, SF2.F2_DESCONT, SF2.F2_COND   , SZE.ZE_ROMAN  , SZE.ZE_NOMREC,"  + Chr(13) + Chr(10)
	_xNQry += "        SZE.ZE_DTREC  , SZE.ZE_HORREC , SL1.L1_FILIAL , SUM(D2_VALDEV) AS D2_VALDEV  ,"  + Chr(13) + Chr(10)
	_xNQry += "        SUM( PESO ) AS PESO, SUM(D2_VALBRUT) AS D2_VALBRUT,"+ Chr(13) + Chr(10)
	_xNQry += "        ( SELECT CASE WHEN COUNT(*) > 0 THEN COUNT(*) ELSE 1 END "                       + Chr(13) + Chr(10)
	_xNQry += "            FROM ( SELECT PED.D2_FILIAL,PED.D2_PEDIDO,PED.D2_DOC,PED.D2_SERIE "          + Chr(13) + Chr(10)
	_xNQry += "                     FROM SD2010 PED (NOLOCK) "                       + Chr(13) + Chr(10)
	_xNQry += "                    WHERE PED.D_E_L_E_T_ = '' AND PED.D2_FILIAL = D2.D2_FILIAL  "       + Chr(13) + Chr(10)
	_xNQry += "                      AND PED.D2_PEDIDO <> '' AND PED.D2_PEDIDO = D2.D2_PEDIDO  "	     + Chr(13) + Chr(10)
	_xNQry += "                    GROUP BY PED.D2_FILIAL,PED.D2_PEDIDO,PED.D2_DOC,PED.D2_SERIE "		  + Chr(13) + Chr(10)
	_xNQry += "                 ) AS AUX "                                                              + Chr(13) + Chr(10)
	_xNQry += "        ) AS ENTREGAS"      

	_xNQry   := StrTran(_xNQry,"SD2.","")
	_xNQry   := StrTran(_xNQry,"SF2.","")
	_xNQry   := StrTran(_xNQry,"F2_DOC"," D2_DOC F2_DOC")
	_xNQry   := StrTran(_xNQry,"F2_SERIE"," D2_SERIE F2_SERIE")
	    
	_xNQry05 := cQry

	_xNQry   += " From " + _xTmp01 + " D2 "   
	//-------------------------------------------------------.
	// Tabela principal - Itens de notas fiscais de saida     |
	//-------------------------------------------------------'
	cQry += "  FROM " + RetSqlName("SD2") + " SD2 (NOLOCK) "                                          + Chr(13) + Chr(10)

	//-------------------------------------------------------.
	// Relacionamento com o Cabeçalho das notas fiscais Saida |
	//-------------------------------------------------------'
	cQry += " INNER JOIN " + RetSqlName("SF2") + " SF2 (NOLOCK) "                                     + Chr(13) + Chr(10)
	cQry += "    ON SF2.D_E_L_E_T_ = '' "                                                             + Chr(13) + Chr(10)
	cQry += "   AND SD2.D2_FILIAL  = SF2.F2_FILIAL "                                                  + Chr(13) + Chr(10)
	cQry += "   AND SD2.D2_DOC     = SF2.F2_DOC "                                                     + Chr(13) + Chr(10)
	cQry += "   AND SD2.D2_SERIE   = SF2.F2_SERIE "                                                   + Chr(13) + Chr(10)

	//-------------------------------------------------------.
	// Relacionamento com o cadastro de Clientes              |
	//-------------------------------------------------------'
	cQry += " INNER JOIN " + RetSqlName("SA1") + " SA1 (NOLOCK) "                                     + Chr(13) + Chr(10)
	cQry += "    ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD=SF2.F2_CLIENTE AND SA1.A1_LOJA=SF2.F2_LOJA"    + Chr(13) + Chr(10)

	_xNQry += " INNER JOIN SA1010 SA1 (NOLOCK) "                                                + Chr(13) + Chr(10)
	_xNQry += "    ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD=D2_CLIENTE AND SA1.A1_LOJA=D2_LOJA"    + Chr(13) + Chr(10)

	//-------------------------------------------------------.
	// Relacionamento com o cadastro de Produtos              |
	//-------------------------------------------------------'
	cQry += " INNER JOIN " + RetSqlName("SB1") + " SB1 (NOLOCK) "                                     + Chr(13) + Chr(10)
	cQry += "    ON SB1.D_E_L_E_T_ = '' AND SD2.D2_COD=SB1.B1_COD"                                    + Chr(13) + Chr(10)

	//-------------------------------------------------------.
	// Relacionameto com as tabelas de Romaneios              |
	//-------------------------------------------------------'
	cQry += "  LEFT JOIN " + RetSqlName("SZE") + " SZE (NOLOCK) "                                     + Chr(13) + Chr(10)
	cQry += "    ON SZE.ZE_FILORIG = SF2.F2_FILIAL "                                                  + Chr(13) + Chr(10)
	cQry += "   AND SF2.F2_DOC = SZE.ZE_DOC AND SF2.F2_SERIE = SZE.ZE_SERIE "                         + Chr(13) + Chr(10)
	cQry += "   AND SZE.D_E_L_E_T_= '' AND SZE.ZE_STATUS IN ('R','P','B','E') "                       + Chr(13) + Chr(10)

	_xNQry += "  LEFT JOIN SZE010 SZE (NOLOCK) "                                     + Chr(13) + Chr(10)
	_xNQry += "    ON SZE.ZE_FILORIG = D2_FILIAL "                                                  + Chr(13) + Chr(10)
	_xNQry += "   AND D2_DOC = SZE.ZE_DOC AND D2_SERIE = SZE.ZE_SERIE "                         + Chr(13) + Chr(10)
	_xNQry += "   AND SZE.D_E_L_E_T_= '' AND SZE.ZE_STATUS IN ('R','P','B','E') "                       + Chr(13) + Chr(10)
	//-------------------------------------------------------.
	// Relacionameto com a TABELA DE Orçamentos do SIGALOJA   |
	//-------------------------------------------------------'
	cQry += "  LEFT OUTER JOIN " + RetSqlName("SL1") + " SL1 (NOLOCK) "                               + Chr(13) + Chr(10)
	cQry += "    ON SL1.D_E_L_E_T_ = '' "                                                             + Chr(13) + Chr(10)
	cQry += "   AND SL1.L1_FILIAL  = SF2.F2_FILIAL "                                                  + Chr(13) + Chr(10)
	cQry += "   AND SF2.F2_DOC     = SL1.L1_DOC "                                                     + Chr(13) + Chr(10)
	cQry += "   AND SF2.F2_SERIE   = SL1.L1_SERIE "                                                   + Chr(13) + Chr(10)

	_xNQry += "  LEFT OUTER JOIN SL1010 SL1 (NOLOCK) "                                              + Chr(13) + Chr(10)
	_xNQry += "    ON SL1.D_E_L_E_T_ = '' "                                                         + Chr(13) + Chr(10)
	_xNQry += "   AND SL1.L1_FILIAL  = D2_FILIAL "                                                  + Chr(13) + Chr(10)
	_xNQry += "   AND D2_DOC     = SL1.L1_DOC "                                                     + Chr(13) + Chr(10)
	_xNQry += "   AND D2_SERIE   = SL1.L1_SERIE "                                                   + Chr(13) + Chr(10)
	//-------------------------------------------------------.
	// Relacionameto com a TABELA DE Pedidos do SIGAFAT      |
	//-------------------------------------------------------'
	cQry += "  LEFT OUTER JOIN  " + RetSqlName("SC5") + "  SC5 (NOLOCK) "                             + Chr(13) + Chr(10)
	cQry += "    ON SC5.D_E_L_E_T_ = '' "                                                             + Chr(13) + Chr(10)
	cQry += "   AND SC5.C5_FILIAL  = SD2.D2_FILIAL "                                                  + Chr(13) + Chr(10)
	cQry += "   AND SC5.C5_NUM     = SD2.D2_PEDIDO "                                                  + Chr(13) + Chr(10)

	_xNQry += "  LEFT OUTER JOIN  SC5010  SC5 (NOLOCK) "                             + Chr(13) + Chr(10)
	_xNQry += "    ON SC5.D_E_L_E_T_ = '' "                                                             + Chr(13) + Chr(10)
	_xNQry += "   AND SC5.C5_FILIAL  = D2_FILIAL "                                                  + Chr(13) + Chr(10)
	_xNQry += "   AND SC5.C5_NUM     = D2_PEDIDO "                                                  + Chr(13) + Chr(10)

	cQry += " WHERE SD2.D_E_L_E_T_ = '' "                                                             + Chr(13) + Chr(10)
	cQry += "   AND SD2.D2_EMISSAO BetWeen '" + dToS(_dDataInicial) +"' And '"+ dToS(_dDataFinal) +"'"+ Chr(13) + Chr(10)
	cQry += "   AND SD2.D2_CLIENTE BetWeen '" +      _cClienteIni   +"' And '"+      _cClienteFim +"'"+ Chr(13) + Chr(10)
	cQry += "   AND SF2.F2_VEND1   BetWeen '" +      _cVendIni      +"' And '"+      _cVendFim    +"'"+ Chr(13) + Chr(10)

	_xFil := ""

	If Len(AllTrim(cAuxStatus)) > 2
		cQry += "   AND SD2.D2_FILIAL IN " + cAuxStatus                                                + Chr(13) + Chr(10)
		_xFil := "   AND SD2.D2_FILIAL IN " + cAuxStatus
	ElseIf _lChk10 .Or. _lChk11 
		cQry += "   AND SD2.D2_FILIAL IN ('xx') " + Chr(13) + Chr(10)
		_xFil := "   AND SD2.D2_FILIAL IN ('xx') "
	EndIf	

	If !(_lChk07 .And. _lChk08)
		If _lChk07
			cQry += "  And C5_ORCRES != ''"
			_xNQry += "  And C5_ORCRES != ''"
		EndIf
		If _lChk08
			cQry += "  And ISNUll(C5_ORCRES,'') = ''"
			_xNQry  += "  And ISNUll(C5_ORCRES,'') = ''"
		EndIf
	EndIf

	//001190// Somente Cliente da Filial da Industria
	//001184//
	If _lChk09
		//      cQry += " And F2_CLIENTE = '" + SuperGetMv("MV_XCLILOJ",.F.,"001190") + "'"
	Else
		cQry += "  AND D2_CLIENTE NOT IN " + FormatIn(GetMV("MV_XCLIAA"),",")
	EndIf

	If _cTipo2 == 	"Faturamento"
		cQry += "   AND ( SD2.D2_CF     IN ('5101', '5102', '5116', '5117', '5118', '5119', '5122', '5123', "
		cQry +=                           " '5124', '5125', '5401', '5405', '6101', '6102', '6107', '6108', "
		cQry +=                           " '6109', '6110', '6116', '6117', '6118', '6119', '6122', '6403') OR SD2.D2_TES = '564' OR ( SD2.D2_CF IN ('5949','6501') AND SF4.F4_DUPLIC='S') )"  + Chr(13) + Chr(10)

	ElseIf _cTipo2 == "Outros"
		cQry += "   AND ( SD2.D2_CF NOT IN ('5101', '5102', '5116', '5117', '5118', '5119', '5122', '5123', "
		cQry +=                           " '5124', '5125', '5401', '5405', '6101', '6102', '6107', '6108', "
		cQry +=                           " '6109', '6110', '6116', '6117', '6118', '6119', '6122', '6403') OR SD2.D2_TES = '564')"  + Chr(13) + Chr(10)
	EndIf

	cQry += " GROUP BY SD2.D2_FILIAL , SD2.D2_PEDIDO , SD2.D2_EMISSAO, SD2.D2_CLIENTE, SD2.D2_LOJA  ,"+ Chr(13) + Chr(10)
	cQry += "          SA1.A1_NOME   , SF2.F2_VEND1  , SL1.L1_NUM    , SF2.F2_DOC    , SF2.F2_SERIE ,"+ Chr(13) + Chr(10)
	cQry += "          SF2.F2_VALBRUT, SF2.F2_DESCONT, SF2.F2_COND   , SZE.ZE_ROMAN  , SZE.ZE_NOMREC,"+ Chr(13) + Chr(10)
	cQry += "          SZE.ZE_DTREC  , SZE.ZE_HORREC , SL1.L1_FILIAL , SC5.C5_ORCRES "                + Chr(13) + Chr(10)

	cQry += " ORDER BY SD2.D2_EMISSAO,SD2.D2_FILIAL,SD2.D2_PEDIDO, F2_DOC "                           + Chr(13) + Chr(10)

	_xNQry += " GROUP BY D2_FILIAL , D2_PEDIDO ,C5_EMISSAO,L1_EMISSAO, D2_EMISSAO, D2_CLIENTE, D2_LOJA  ,"+ Chr(13) + Chr(10)
	_xNQry += "          SA1.A1_NOME   , F2_VEND1  , SL1.L1_NUM    , D2_DOC    , D2_SERIE ,"+ Chr(13) + Chr(10)
	_xNQry += "          F2_VALBRUT, F2_DESCONT, F2_COND   , SZE.ZE_ROMAN  , SZE.ZE_NOMREC,"+ Chr(13) + Chr(10)
	_xNQry += "          SZE.ZE_DTREC  , SZE.ZE_HORREC , SL1.L1_FILIAL , SC5.C5_ORCRES "                + Chr(13) + Chr(10)

	_xNQry += " ORDER BY D2_EMISSAO,D2_FILIAL,D2_PEDIDO, D2_DOC "                           + Chr(13) + Chr(10)

	cArqTrab := ''


	//Aviso('',_xNQry,{'OK'}) 
	If _lChk10
		_xNQry05 := _xNQry                 		

		_cSZE := "SZE010"//RetSqlName("SZE")
		_cSL1 := "SL1010"//RetSqlName("SL1")
		_cSC5 := "SC5010"//RetSqlName("SC5")
		
		_cSD2 := "SD2010"//RetSqlName("SC5")

		_xSZE := "SZE050"//RetSqlName("SZE")
		_xSL1 := "SL1050"//RetSqlName("SL1")
		_xSC5 := "SC5050"//RetSqlName("SC5")
		_xSD2 := "SD2050"//RetSqlName("SC5")



		//_xQry05 := _xQry
		_xNQry05 := StrTran(_xNQry05,_cSZE,_xSZE)
		_xNQry05 := StrTran(_xNQry05,_cSL1,_xSL1)
		_xNQry05 := StrTran(_xNQry05,_cSC5,_xSC5)
		_xNQry05 := StrTran(_xNQry05,_cSD2,_xSD2)
		_xNQry05 := StrTran(_xNQry05,_xTmp01,_xTmp05)

		//Alert(_xTmp01)
		//Aviso('',_xNQry05,{'OK'})       
	EndIf
	
	If _lChk11
		_xNQry06 := _xNQry                 		

		_cSZE := "SZE010"//RetSqlName("SZE")
		_cSL1 := "SL1010"//RetSqlName("SL1")
		_cSC5 := "SC5010"//RetSqlName("SC5")
		
		_cSD2 := "SD2010"//RetSqlName("SC5")

		_xSZE := "SZE060"//RetSqlName("SZE")
		_xSL1 := "SL1060"//RetSqlName("SL1")
		_xSC5 := "SC5060"//RetSqlName("SC5")
		_xSD2 := "SD2060"//RetSqlName("SC5")



		//_xQry05 := _xQry
		_xNQry06 := StrTran(_xNQry06,_cSZE,_xSZE)
		_xNQry06 := StrTran(_xNQry06,_cSL1,_xSL1)
		_xNQry06 := StrTran(_xNQry06,_cSC5,_xSC5)
		_xNQry06 := StrTran(_xNQry06,_cSD2,_xSD2)
		_xNQry06 := StrTran(_xNQry06,_xTmp01,_xTmp06)

		//Alert(_xTmp01)
		//Aviso('',_xNQry05,{'OK'})       
	EndIf


	_xdQry := _xNQry
	MEMOWRIT('AAFATC05.SQL',_xdQry)
	//dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), cTable, .T., .T. )
	_xd01 := .F.
	nTotalDev  := 0
	nTotalFat  := 0
	nTotalPeso := 0
	
	
	If Len(AllTrim(cAuxStatus)) > 2
		_xd01 := .T.
		dbUseArea( .T., "TOPCONN", TcGenQry(,,_xdQry), cTable, .T., .T. )	

		tcSetField(cTable,"ZE_DTREC"  ,"D",8,0)
		tcSetField(cTable,"D2_EMISSAO","D",8,0)
		tcSetField(cTable,"C5_EMISSAO","D",8,0)
		tcSetField(cTable,"L1_EMISSAO","D",8,0)

		dbselectarea(cTable)

		(cTable)->(DBGOTOP())
		
		If (cTable)->(EOF())
			_xd01 := .F.
			/*
			aAdd( _aBrowse, { 'R'                  ,; //01
			' '                  ,; //02
			' '                  ,; //03
			' '                  ,; //04
			' '                  ,; //05
			dToc(Date())         ,; //06
			' '                  ,; //07
			' '                  ,; //08
			' '                  ,; //09
			' '                  ,; //10
			' '                  ,; //11
			' '                  ,; //12
			' '                  ,; //13
			' '                  ,; //14
			' '                  ,; //15
			' '                  ,; //16
			' '                  ,; //17
			dToc(Date())         ,; //18
			' '                  ,; //19
			' '                  ,; //20
			' '                  ,; //21
			' '})//22
			*/
		EndIf

		While !(cTable)->(EOF())


			If (cTable)->F2_DOC == "000006317"
				cdDebugStop := "DEBUG STOP" 
			EndIf

			aAdd( _aBrowse, { (cTable)->D2_STATUS                                                            ,; //01
			IiF( Empty( (cTable)->D2_PEDIDO) ,(cTable)->L1_FILIAL,(cTable)->D2_FILIAL ) ,; //02
			IiF( Empty( (cTable)->D2_PEDIDO) ,(cTable)->L1_NUM   ,(cTable)->D2_PEDIDO ) ,; //03
			(cTable)->F2_DOC                                                            ,; //04
			(cTable)->F2_SERIE                                                          ,; //05
			dToc((cTable)->D2_EMISSAO)                                                  ,; //06
			(cTable)->D2_CLIENTE                                                        ,; //07
			(cTable)->D2_LOJA                                                           ,; //08
			(cTable)->A1_NOME                                                           ,; //09
			Posicione('SA3',1,xFIlial('SA3') + (cTable)->F2_VEND1  ,'A3_NOME' )         ,; //10
			Transform( (cTable)->(F2_VALBRUT + F2_DESCONT), "@E 999,999,999.99" )       ,; //11
			Transform( (cTable)->F2_DESCONT               , "@E 999,999,999.99" )       ,; //12
			Transform( (cTable)->D2_VALDEV                , "@E 999,999,999.99" )       ,; //13
			Transform( (cTable)->(F2_VALBRUT - D2_VALDEV) , "@E 999,999,999.99" )       ,; //14
			AAFATC22( "01", (cTable)->L1_FILIAL,(cTable)->L1_NUM,(cTable)->F2_COND ,(cTable)->F2_DOC,(cTable)->F2_SERIE )       ,; //15
			(cTable)->ZE_ROMAN                                                          ,; //16
			(cTable)->ZE_NOMREC                                                         ,; //17
			dToc( (cTable)->ZE_DTREC )                                                  ,; //18
			Transform( (cTable)->ZE_HORREC, '@R 99:99')                                 ,; //19
			Transform( (cTable)->ENTREGAS,'@E 999999' )                                    ,; //20
			(cTable)->L1_NUM                                                            ,;//21
			"01",;//22
			IiF( Empty( (cTable)->D2_PEDIDO), dToc((cTable)->L1_EMISSAO) , dToc((cTable)->C5_EMISSAO) ),;//23
			Transform((cTable)->PESO,"@E 999,999,999.99")}) //23


			nTotalDev  += (cTable)->D2_VALDEV
			nTotalFat  += (cTable)->F2_VALBRUT
			nTotalPeso += (cTable)->PESO

			(cTable)->(dbSkip())
		EndDo
		(cTable)->(dbCloseArea(cTable))
	EndIf
	
	If _lChk10
	/*	_cSD2 := "SD2010"//RetSqlName("SD2")
		_cSF2 := "SF2010"//RetSqlName("SF2")
		_cSA1 := "SA1010"//RetSqlName("SA1")
		_cSB1 := "SB1010"//RetSqlName("SB1")
		_cSZE := "SZE010"//RetSqlName("SZE")
		_cSL1 := "SL1010"//RetSqlName("SL1")
		_cSC5 := "SC5010"//RetSqlName("SC5")


		_xSD2 := "SD2050"//RetSqlName("SD2")
		_xSF2 := "SF2050"//RetSqlName("SF2")
		_xSA1 := "SA1010"//RetSqlName("SA1")
		_xSB1 := "SB1050"//RetSqlName("SB1")
		_xSZE := "SZE050"//RetSqlName("SZE")
		_xSL1 := "SL1050"//RetSqlName("SL1")
		_xSC5 := "SC5050"//RetSqlName("SC5")

		//_xdQry := cQry_xFil
		cQry := Strtran(cQry,_xFil,"")
		cQry := Strtran(cQry,_cSD2,_xSD2)
		cQry := Strtran(cQry,_cSF2,_xSF2)

		cQry := Strtran(cQry,_cSB1,_xSB1)
		cQry := Strtran(cQry,_cSZE,_xSZE)
		cQry := Strtran(cQry,_cSL1,_xSL1)
		cQry := Strtran(cQry,_cSC5,_xSC5)
*/

		_xdQry := _xNQry05
		cTable     := GetNextALias()
		MEMOWRIT('AAFATC05B.SQL',_xdQry)
		//dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), cTable, .T., .T. )
		dbUseArea( .T., "TOPCONN", TcGenQry(,,_xdQry), cTable, .T., .T. )

		//MEMOWRIT('AAFATC05B.SQL',cQry)
		//cTable     := GetNextALias()
		//dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), cTable, .T., .T. )

		tcSetField(cTable,"ZE_DTREC"  ,"D",8,0)
		tcSetField(cTable,"D2_EMISSAO","D",8,0)
		tcSetField(cTable,"C5_EMISSAO","D",8,0)
		tcSetField(cTable,"L1_EMISSAO","D",8,0)

		dbselectarea(cTable)

		(cTable)->(DBGOTOP())
/*
		If (cTable)->(EOF()) .And. _xd01       

			aAdd( _aBrowse, { 'R'                  ,; //01
			' '                  ,; //02
			' '                  ,; //03
			' '                  ,; //04
			' '                  ,; //05
			dToc(Date())         ,; //06
			' '                  ,; //07
			' '                  ,; //08
			' '                  ,; //09
			' '                  ,; //10
			' '                  ,; //11
			' '                  ,; //12
			' '                  ,; //13
			' '                  ,; //14
			' '                  ,; //15
			' '                  ,; //16
			' '                  ,; //17
			dToc(Date())         ,; //18
			' '                  ,; //19
			' '                  ,; //20
			' '                  ,; //21
			' '                  ,;//22
			' '})//23
		EndIf
*/
		While !(cTable)->(EOF())

			aAdd( _aBrowse, { (cTable)->D2_STATUS                                                            ,; //01
			IiF( Empty( (cTable)->D2_PEDIDO) ,(cTable)->L1_FILIAL,(cTable)->D2_FILIAL ) ,; //02
			IiF( Empty( (cTable)->D2_PEDIDO) ,(cTable)->L1_NUM   ,(cTable)->D2_PEDIDO ) ,; //03
			(cTable)->F2_DOC                                                            ,; //04
			(cTable)->F2_SERIE                                                          ,; //05
			dToc((cTable)->D2_EMISSAO)                                                  ,; //06
			(cTable)->D2_CLIENTE                                                        ,; //07
			(cTable)->D2_LOJA                                                           ,; //08
			(cTable)->A1_NOME                                                           ,; //09
			Posicione('SA3',1,xFIlial('SA3') + (cTable)->F2_VEND1  ,'A3_NOME' )         ,; //10
			Transform( (cTable)->(F2_VALBRUT + F2_DESCONT), "@E 999,999,999.99" )       ,; //11
			Transform( (cTable)->F2_DESCONT               , "@E 999,999,999.99" )       ,; //12
			Transform( (cTable)->D2_VALDEV                , "@E 999,999,999.99" )       ,; //13
			Transform( (cTable)->(F2_VALBRUT - D2_VALDEV) , "@E 999,999,999.99" )       ,; //14
			AAFATC22( "05", (cTable)->L1_FILIAL, (cTable)->L1_NUM, (cTable)->F2_COND, (cTable)->F2_DOC, (cTable)->F2_SERIE  )       ,; //15
			(cTable)->ZE_ROMAN                                                          ,; //16
			(cTable)->ZE_NOMREC                                                         ,; //17
			dToc( (cTable)->ZE_DTREC )                                                  ,; //18
			Transform( (cTable)->ZE_HORREC, '@R 99:99')                                 ,; //19
			Transform( (cTable)->ENTREGAS,'@E 9999999' )                                    ,; //20
			(cTable)->L1_NUM                                                            ,; //21
			"05"                                                                        ,;//22
			IiF( Empty( (cTable)->D2_PEDIDO), dToc((cTable)->L1_EMISSAO) , dToc((cTable)->C5_EMISSAO) ),;
			Transform((cTable)->PESO,"@E 999,999,999.99") }) //23


			nTotalDev  += (cTable)->D2_VALDEV
			nTotalFat  += (cTable)->F2_VALBRUT
			nTotalPeso += (cTable)->PESO

			(cTable)->(dbSkip())
		EndDo
		(cTable)->(dbCloseArea(cTable))

	Endif
	
	If _lChk11
	/*	_cSD2 := "SD2010"//RetSqlName("SD2")
		_cSF2 := "SF2010"//RetSqlName("SF2")
		_cSA1 := "SA1010"//RetSqlName("SA1")
		_cSB1 := "SB1010"//RetSqlName("SB1")
		_cSZE := "SZE010"//RetSqlName("SZE")
		_cSL1 := "SL1010"//RetSqlName("SL1")
		_cSC5 := "SC5010"//RetSqlName("SC5")


		_xSD2 := "SD2050"//RetSqlName("SD2")
		_xSF2 := "SF2050"//RetSqlName("SF2")
		_xSA1 := "SA1010"//RetSqlName("SA1")
		_xSB1 := "SB1050"//RetSqlName("SB1")
		_xSZE := "SZE050"//RetSqlName("SZE")
		_xSL1 := "SL1050"//RetSqlName("SL1")
		_xSC5 := "SC5050"//RetSqlName("SC5")

		//_xdQry := cQry_xFil
		cQry := Strtran(cQry,_xFil,"")
		cQry := Strtran(cQry,_cSD2,_xSD2)
		cQry := Strtran(cQry,_cSF2,_xSF2)

		cQry := Strtran(cQry,_cSB1,_xSB1)
		cQry := Strtran(cQry,_cSZE,_xSZE)
		cQry := Strtran(cQry,_cSL1,_xSL1)
		cQry := Strtran(cQry,_cSC5,_xSC5)
*/

		_xdQry := _xNQry06
		cTable     := GetNextALias()
		MEMOWRIT('AAFATC05C.SQL',_xdQry)
		//dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), cTable, .T., .T. )
		dbUseArea( .T., "TOPCONN", TcGenQry(,,_xdQry), cTable, .T., .T. )

		//MEMOWRIT('AAFATC05B.SQL',cQry)
		//cTable     := GetNextALias()
		//dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), cTable, .T., .T. )

		tcSetField(cTable,"ZE_DTREC"  ,"D",8,0)
		tcSetField(cTable,"D2_EMISSAO","D",8,0)
		tcSetField(cTable,"C5_EMISSAO","D",8,0)
		tcSetField(cTable,"L1_EMISSAO","D",8,0)

		dbselectarea(cTable)

		(cTable)->(DBGOTOP())

/*
		If (cTable)->(EOF()) .And. _xd01       

			aAdd( _aBrowse, { 'R'                  ,; //01
			' '                  ,; //02
			' '                  ,; //03
			' '                  ,; //04
			' '                  ,; //05
			dToc(Date())         ,; //06
			' '                  ,; //07
			' '                  ,; //08
			' '                  ,; //09
			' '                  ,; //10
			' '                  ,; //11
			' '                  ,; //12
			' '                  ,; //13
			' '                  ,; //14
			' '                  ,; //15
			' '                  ,; //16
			' '                  ,; //17
			dToc(Date())         ,; //18
			' '                  ,; //19
			' '                  ,; //20
			' '                  ,; //21
			' '                  ,;//22
			' '})//23
		EndIf
*/
		While !(cTable)->(EOF())

			aAdd( _aBrowse, { (cTable)->D2_STATUS                                                            ,; //01
			IiF( Empty( (cTable)->D2_PEDIDO) ,(cTable)->L1_FILIAL,(cTable)->D2_FILIAL ) ,; //02
			IiF( Empty( (cTable)->D2_PEDIDO) ,(cTable)->L1_NUM   ,(cTable)->D2_PEDIDO ) ,; //03
			(cTable)->F2_DOC                                                            ,; //04
			(cTable)->F2_SERIE                                                          ,; //05
			dToc((cTable)->D2_EMISSAO)                                                  ,; //06
			(cTable)->D2_CLIENTE                                                        ,; //07
			(cTable)->D2_LOJA                                                           ,; //08
			(cTable)->A1_NOME                                                           ,; //09
			Posicione('SA3',1,xFIlial('SA3') + (cTable)->F2_VEND1  ,'A3_NOME' )         ,; //10
			Transform( (cTable)->(F2_VALBRUT + F2_DESCONT), "@E 999,999,999.99" )       ,; //11
			Transform( (cTable)->F2_DESCONT               , "@E 999,999,999.99" )       ,; //12
			Transform( (cTable)->D2_VALDEV                , "@E 999,999,999.99" )       ,; //13
			Transform( (cTable)->(F2_VALBRUT - D2_VALDEV) , "@E 999,999,999.99" )       ,; //14
			AAFATC22( "05", (cTable)->L1_FILIAL, (cTable)->L1_NUM, (cTable)->F2_COND, (cTable)->F2_DOC, (cTable)->F2_SERIE  )       ,; //15
			(cTable)->ZE_ROMAN                                                          ,; //16
			(cTable)->ZE_NOMREC                                                         ,; //17
			dToc( (cTable)->ZE_DTREC )                                                  ,; //18
			Transform( (cTable)->ZE_HORREC, '@R 99:99')                                 ,; //19
			Transform( (cTable)->ENTREGAS,'@E 999' )                                    ,; //20
			(cTable)->L1_NUM                                                            ,; //21
			"06"                                                                        ,;//22
			IiF( Empty( (cTable)->D2_PEDIDO), dToc((cTable)->L1_EMISSAO) , dToc((cTable)->C5_EMISSAO) ),;//23
			Transform((cTable)->PESO,"@E 999,999,999.99")}) //24


			nTotalDev  += (cTable)->D2_VALDEV
			nTotalFat  += (cTable)->F2_VALBRUT
			nTotalPeso += (cTable)->PESO

			(cTable)->(dbSkip())
		EndDo
		(cTable)->(dbCloseArea(cTable))

	Endif

	If nTipo == 2
		oBrowse:SetArray(_aBrowse)
		//		oBrowse:bLine := {|| { LoadBitmap(GetResources(),_aCores[aScan(_aCores,{|x| &(x[01]) })][02] ) ,;
		//  	oBrowse:bLine := {|| { _aBrowse[oBrowse:nAt][01] ,;

		/*oBrowse:bLine := {|| { LoadBitmap(GetResources(),_aCores[aScan(_aCores,{|x| &(x[01]) })][02] ) ,;
		/*oBrowse:bLine := {|| { LoadBitmap(GetResources(),_aCores[aScan(_aCores,{|x| &(x[01]) })][02] ) ,;
		_aBrowse[oBrowse:nAt][02] ,;
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
		_aBrowse[oBrowse:nAt][18] ,;
		_aBrowse[oBrowse:nAt][19] ,;
		_aBrowse[oBrowse:nAt][20] ,;
		_aBrowse[oBrowse:nAt][21] }}
		*/
		oBrowse:nLen   := Len(_aBrowse)
		oBrowse:nAt    := 1
		oBrowse:Refresh()
	EndIf


	If Type("oSay1") = "O"

		oSay1:SetText( nTotalFat )
		oSay2:SetText( nTotalDev )
		oSay3:SetText( nTotalPeso)
		oSay4:SetText( nTotalFat-nTotalDev)
		oSay5:SetText( (nTotalFat-nTotalDev)/nTotalPeso)
		
		oSay1:Refresh()
		oSay2:Refresh()
		oSay3:Refresh()
		oSay4:Refresh()
		oSay5:Refresh()
	EndIf


	//(cTable)->(dbCLoseArea(cTable))

	tcSqlExec("drop table " + _xTmp01)
	tcSqlExec("drop table " + _xTmp05)
	tcSqlExec("drop table " + _xTmp06)
Return Nil

//************************************************************************************************************

Static Function ExportaExcel(aExport, cwCabec)
	Local i, j, nHdl, oExcelApp
	Local cArqTxt := GetTempPath()+"\aafatc05.xls"
	Local cLinha  := ""

	If File(cArqTxt)
		FErase(cArqTxt)
	Endif

	nHdl := fCreate(cArqTxt)

	cLinha += cwCabec /*'Staus'            + Chr(9) + 'Filial'      + Chr(9) + 'Pedido'        + Chr(9) +'Emissao' + Chr(9) + 'Cliente' + Chr(9) + 'Razao Social' + Chr(9) +'Produto'        + Chr(9)
	cLinha += 'Descicao Produto' + Chr(9) + 'Qtde Pedido' + Chr(9) + 'Qtde Entregue' + Chr(9) +'Saldo'   + Chr(9) + 'Data OP' + Chr(9) + 'Qtde OP'      + Chr(9) + 'Data Produção' + Chr(9)
	cLinha += 'Qtde Produção'    + Chr(9) + 'Data Fatura' + Chr(9) + 'Vendedor'      + Chr(9) +'Residuo' + Chr(13) +Chr(10)
	*/
	If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
	EndIf

	For i:=1 to Len(aExport)
		cLinha := ""
		//    IncRegua()
		If ValType(aExport[i])<>"A"
			clinha += aExport[i]
		Else
			For j := 1 to Len(aExport[i])
				cLinha += aExport[i][j]+Chr(9)
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


Static Function AAFATC22(_cEmp,_cFil, _cOrc, _cCond, _cDoc, _cSerie)

	Local _adForm := {}
	Local _cForma := ''

	SE1->(dbSetOrder(1))
	_lSE1 := SE1->(dbSeek(xFilial('SE1') + _cSerie + _cDoc))

	if Empty(_cCond) .Or. _cCond = 'CN' .Or. !_lSE1
		_adForm := {}

		_cQry := ""
		_cQry += " Select * From " + "SL4" + _cEmp + "0"
		_cQry += "  Where D_E_L_E_T_ = ' ' "
		_cQry += "  And L4_FILIAL = '" + _cFil + "'"
		_cQry += "  And L4_NUM = '" + _cOrc + "'"			

		If cEmpAnt == _cEmp
			xTbl := "SL4" 
			SL4->(dBSetOrder(1))			
			If SL4->(dbSeek(_cFil + _cOrc))				
			EndIf
		Else
			xTbl := MpSysOpenQuery(_cQry)
		EndIf

		While(!(xTbl)->(EOF()) .And. (_cFil + _cOrc) == (xTbl)->(L4_FILIAL + L4_NUM)  )
			_ndPos := iIf( Len(_adForm) !=0, aScan(_adForm,{|x| Alltrim(x[01]) == Alltrim((xTbl)->L4_FORMA) } ),0)
			If _ndPos > 0
				_adForm[_ndPos][02] += (xTbl)->L4_VALOR
				_adForm[_ndPos][03] += 1
			Else
				aAdd(_adForm,{(xTbl)->L4_FORMA,(xTbl)->L4_VALOR,1})
			Endif
			(xTbl)->(dbSkip())
		EndDo
		(xTbl)->(dbCloseArea(xTbl))
		//EndIf
		//EndIf

		_adForma := {""}
		_cdForm  := ''
		_ndItem  := 01

		For nI := 1 to Len(_adForm)
			
			
			SX5->(dbSetOrder(1))
            lSX5 := SX5->(dbSeek(xFilial('SX5') + '05' + Alltrim(_adForm[nI][01]) )) .And. !Alltrim(_adForm[nI][01]) $ "R$"
			iF lSx5
			   _cdForm := iIf(Empty(_adForma[_ndItem]),"","/") + Alltrim(Str(_adForm[nI][03]) + "x" + SX5->X5_DESCRI )
			Else
			   _cdForm := iIf(Empty(_adForma[_ndItem]),"","/") + Alltrim(Str(_adForm[nI][03]) + "x" + Alltrim(_adForm[nI][01]) )
			EndIf
			
			If Len(_adForma[_ndItem]) + Len(_cdForm) + iIf(Empty(_adForma[_ndItem]),0,1) >= 400
				_ndItem++
			EndIf
			_adForma[_ndItem] += _cdForm
		Next
		//Else
		//		_adForma := {""}
		//	EndiF


		For nK := 1 To Len(_adForma)
			_cForma += _adForma[nK] + iIF(nK!=Len(_adForma),'/','')
		Next
		if  Alltrim(Upper(_cForma)) == "1XR$"
			_cForma := "A Vista Em Dinheiro"
		EndIf
		IF "1X"$Upper(_cForma)
			cdhahaha := " "
		EndIf

	Else
		_cForma := Posicione('SE4',1, xFilial('SE4') + _cCond,'E4_DESCRI')
	EndIf

Return _cForma

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
