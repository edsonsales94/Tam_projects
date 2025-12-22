//-------------------------------------------------------. 
// Declaração das bibliotecas utilizadas no programa      |
//-------------------------------------------------------'
#include "Protheus.ch"
#include "RwMake.ch"
#include "TBICONN.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATP09   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 16/05/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Consulta Romaneio - alterado por Wermeson Gadelha conforme    ¦¦¦
¦¦¦  (Cont)   ¦ solicitado pelo Sr. Valdeinir em 16/05/2013                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/  /*2013143823091*/
User function AAFATP09()

 //-------------------------------------------------------. 
 // Declaração das variaveis locais                        |
 //-------------------------------------------------------'
	Local _aCabec            := {'', 'Filial','Pedido','Emissao', 'Cliente', 'Razao Social','Produto', 'Descicao Produto', 'Qtde Pedido', 'Qtde Entregue','Saldo','Data OP','Qtde OP', 'Data Produção', 'Qtde Produção','Previsao OP', 'Data Fatura','Vendedor','Residuo', 'Obs OP','Orc. Origem'}
 								
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

    Private _oVendIni := Nil
    Private _oVendFim := Nil
 //-------------------------------------------------------. 
 // Declaração das variaveis privates - Variaveis          |
 //-------------------------------------------------------'		                         
	Private _dDataInicial    := dDataBase
	Private _dDataFinal      := dDataBase
	Private _cVendIni    := Space(Len(SA3->A3_COD))
	Private _cVendFim    := replicate('z',Len(SA3->A3_COD))
	Private _cClienteIni     := Space(Len(SA1->A1_COD))
	Private _cClienteFim     := replicate('z',Len(SA1->A1_COD))
	Private _cTipo           := "Ambas"
	Private _cTipo2          := "Ambos"
	Private _cTipo3          := "Todas"
 
  //-------------------------------------------------------. 
 // Declaração das variaveis privates - Checkbox           |
 //-------------------------------------------------------'		
	Private _oChk01, _lChk01 :=.T.
	Private _oChk02, _lChk02 :=.T.
	Private _oChk03, _lChk03 :=.T.
	Private _oChk04, _lChk04 :=.T.

 //-------------------------------------------------------. 
 // Declaração das variaveis privates - Arrays             |
 //-------------------------------------------------------'		
	Private aItems   := {}
	Private aBalan   := {}
	Private aTipos   := {}
	Private _aBrowse := {}
	Private aLeg     :=  { {"A" , "ENABLE"     },;
		{"E" , "BR_VERMELHO"},;
		{"P" , "BR_AZUL"    },;
		{"R" , "BR_CINZA"   } }
	Private oLayer := Nil
	Private aCoors := FwGetDialogSize(oMainWnd)//MsAdvSize()
 
	cwCabec := 'Staus'            + Chr(9) + 'Filial'      + Chr(9) + 'Pedido'        + Chr(9) +'Emissao'   + Chr(9) + 'Cliente' + Chr(9) + 'Razao Social' + Chr(9) +'Produto'        + Chr(9)
	cwCabec += 'Descicao Produto' + Chr(9) + 'Qtde Pedido' + Chr(9) + 'Qtde Entregue' + Chr(9) +'Saldo'     + Chr(9) + 'Data OP' + Chr(9) + 'Qtde OP'      + Chr(9) + 'Data Produção' + Chr(9)
	cwCabec += 'Qtde Produção'    + Chr(9) + 'Previsao OP' + Chr(9) + 'Data Fatura'   + Chr(9) + 'Vendedor' + Chr(9) + 'Residuo' + Chr(9) + 'Obs OP'       + Chr(13) +Chr(10)
	   
	//-------------------------------------------------------. 
	// Array com as cores das legendas                        |
	//-------------------------------------------------------'		
	_aCores := {{'_aBrowse[oBrowse:nAt][01] = "A" ',"ENABLE"  	 },;	// PEDIDO EM ABERTO
	{'_aBrowse[oBrowse:nAt][01] = "E" ',"BR_VERMELHO"},;	// PEIDO ENCERRADO
	{'_aBrowse[oBrowse:nAt][01] = "P" ',"BR_AZUL"    },;	// ENTREGUE PARCIALMENTE
	{'_aBrowse[oBrowse:nAt][01] = "R" ',"BR_CINZA"   } } 	// RESIDUO
	
	//-------------------------------------------------------. 
	// Array com as cores das legendas                        |
	//-------------------------------------------------------'		
	_aLegenda := {{"ENABLE"     , "Aberto"  },;
		{"BR_VERMELHO", "Entregue"},;
		{"BR_AZUL"    , "Parcial" },;
		{"BR_CINZA"   , "Residuo" }}

	//-------------------------------------------------------. 
	// itens do combobox                                      |
	//-------------------------------------------------------'		
	AADD(aItems,"Filial 06200")
	AADD(aItems,"Filial 06300")
	AADD(aItems,"Ambas")


	//-------------------------------------------------------. 
	// itens do combobox                                      |
	//-------------------------------------------------------'		
	AADD(aTipos,"Varejo")
	AADD(aTipos,"Atacado")
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
	//DEFINE DIALOG _oJanela TITLE "Consulta Romaneio" FROM 001,001 TO 550,1200 PIXEL
	_oJanela  := MSDialog():New(aCoors[1], aCoors[2],aCoors[3], aCoors[4],"Consulta Romaneio",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	oLayer := FWLAYER():New()
	oLayer:Init(_oJanela,.F.,.T.)
	oLayer:AddLine('UP',25)
	oLayer:AddLine('MIDDLE',75)
	oLayer:AddLine('DOWN',00)

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
	
	@ 003,005 TO 55,500 label "Filtros" OF _oUp PIXEL
		
	@ 012,007 Say "Emissao Pedido: " Size 50,10 Pixel Of _oUp
	@ 012,055 MsGet _oDatIni Var _dDataInicial Size 60,08 Pixel of _oUp
	@ 012,120 MsGet _oDatFim Var _dDataFinal   Size 60,08 Pixel of _oUp
		
	@ 027,007 Say "Cliente: " Size 50,10 Pixel Of _oUp
	@ 027,055 MsGet _oClienteIni Var _cClienteIni F3 'SA1' Size 60,08 Pixel of _oUp
	@ 027,120 MsGet _oClienteFim Var _cClienteFim F3 'SA1' Size 60,08 Pixel of _oUp
		                                                     
	@ 042,007 Say "Vendedor: " Size 50,10 Pixel Of _oUp
	@ 042,055 MsGet _oVendIni Var _cVendIni F3 'SA3' Size 60,08 Pixel of _oUp
	@ 042,120 MsGet _oVendFim Var _cVendFim F3 'SA3' Size 60,08 Pixel of _oUp
	
	@ 012,220 Say "Tipo Venda:"  Size 050,10 Pixel Of _oUp
	@ 012,260 MSCOMBOBOX _oTipo2 VAR _cTipo2 ITEMS aTipos SIZE 060,50 OF _oUp PIXEL
		
	@ 027,220 Say "Filial:"  Size 050,10 Pixel Of _oUp
	@ 027,260 MSCOMBOBOX _oTipo  VAR _cTipo  ITEMS aItems SIZE 060,50 OF _oUp PIXEL
				
	@ 008,360 TO 040,460 label "Status Pedidos" OF _oUp PIXEL

	@ 015,370 CHECKBOX _oChk01 VAR _lChk01 PROMPT "Abertos" 	 SIZE 80,9 PIXEL OF _oUp
	@ 015,420 CHECKBOX _oChk02 VAR _lChk02 PROMPT "Parciais"  SIZE 80,9 PIXEL OF _oUp
	@ 025,370 CHECKBOX _oChk03 VAR _lChk03 PROMPT "Atendidos" SIZE 80,9 PIXEL OF _oUp
	@ 025,420 CHECKBOX _oChk04 VAR _lChk04 PROMPT "Residuos"  SIZE 80,9 PIXEL OF _oUp
		                                                     
	@ 010,015 Button "&Consultar" Size 40,13 Pixel of _oUp2 Action MsgRun('Filtrando Dados...' ,,{|| GetInf(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal, 2), oBrowse:Refresh() })
	@ 010,060 Button "&Legenda"   Size 40,13 Pixel of _oUp2 Action BrwLegenda("Cadastro de Romaneio","Legendas",_aLegenda)
	@ 025,015 Button "&Exportar"  Size 40,13 Pixel of _oUp2 Action MsgRun('Exportando Excel...',,{|| ExportaExcel(_aBrowse, cwCabec), oBrowse:Refresh() })
	@ 025,060 Button "&Fechar"    Size 40,13 Pixel of _oUp2 Action _oJanela:End()
				
	//@ 050,005 TO 275,595 label "Dados Pedidos de Chapas Cortadas" OF _oJanela PIXEL
		
	//oBrowse := TcBrowse():New ( 060,010,580,210 , , _aCabec,/*[ aColSizes]*/           , _oJanela, /*[ cField]*/,  , , /*[ bChange]*/, /*[ bLDblClick]*/, /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/,         /*cAlias*/, /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )
	oBrowse := FWBrowse():New()
	oBrowse:SetDataArray()
	oBrowse:AddStatusColumns(  { || _aCores[aScan(_aCores,{|x| &(x[01]) })][02] }, {||} )
	
	_adCabec := {}
				
		
	aAdd(_adCabec,{ _aCabec[02]  , {|| _aBrowse[oBrowse:At()][02] }  , 'C' ,  '@!' , 1 , 02, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[21]  , {|| _aBrowse[oBrowse:At()][21] }  , 'C' ,  '@!' , 1 , 10, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[03]  , {|| _aBrowse[oBrowse:At()][03] }  , 'D' ,  '  ' , 0 , 08, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[04]  , {|| _aBrowse[oBrowse:At()][04] }  , 'C' ,  '@!' , 1 , 05, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[05]  , {|| _aBrowse[oBrowse:At()][05] }  , 'C' ,  '@!' , 1 , 05, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[06]  , {|| _aBrowse[oBrowse:At()][06] }  , 'C' ,  '@!' , 1 , 10, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[07]  , {|| _aBrowse[oBrowse:At()][07] }  , 'C' ,  '@!' , 1 , 06, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[08]  , {|| _aBrowse[oBrowse:At()][08] }  , 'C' ,  '@!' , 1 , 10, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[09]  , {|| _aBrowse[oBrowse:At()][09] }  , 'N' ,  '@E 999,999,999.99' , 2 , 08, 2 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[10]  , {|| _aBrowse[oBrowse:At()][10] }  , 'N' ,  '@E 999,999,999.99' , 2 , 08, 2 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[11]  , {|| _aBrowse[oBrowse:At()][11] }  , 'N' ,  '@E 999,999,999.99' , 2 , 08, 2 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[12]  , {|| _aBrowse[oBrowse:At()][12] }  , 'D' ,  '  ' , 0 , 08, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[13]  , {|| _aBrowse[oBrowse:At()][13] }  , 'N' ,  '@E 999,999,999.99' , 2 , 08, 2 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[14]  , {|| _aBrowse[oBrowse:At()][14] }  , 'D' ,  '@!' , 0 , 08, 2 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[15]  , {|| _aBrowse[oBrowse:At()][15] }  , 'N' ,  '@E 999,999,999.99' , 2 , 08, 2 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[16]  , {|| _aBrowse[oBrowse:At()][16] }  , 'D' ,  '  ' , 1 , 08, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[17]  , {|| _aBrowse[oBrowse:At()][17] }  , 'D' ,  '  ' , 1 , 08, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[18]  , {|| _aBrowse[oBrowse:At()][18] }  , 'C' ,  '@!' , 1 , 08, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[19]  , {|| _aBrowse[oBrowse:At()][19] }  , 'C' ,  '@!' , 1 , 02, 0 ,,,,,,  })
	aAdd(_adCabec,{ _aCabec[20]  , {|| _aBrowse[oBrowse:At()][20] }  , 'C' ,  '@!' , 1 , 10, 0 ,,,,,,  })
	
	oBrowse:SetColumns(_adCabec)
	oBrowse:SetArray(_aBrowse)	
	oBrowse:Refresh()
	//oBrowse:BLDBLCLICK := {||  fTela2(_aBrowse[oBrowse:nAt][03], _aBrowse[oBrowse:nAt][02], _aBrowse[oBrowse:nAt][07] ) }
	oBrowse:SetDoubleClick( {||  fTela2(_aBrowse[oBrowse:nAt][03], _aBrowse[oBrowse:nAt][02], _aBrowse[oBrowse:nAt][07] ) } )
    oBrowse:SetOwner(_oMiddle)
    oBrowse:Activate()
	//oBrowse:nScrollType := 0 // Define a barra de rolagem VCR
		
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
	Local cQry      := ''
	Local cCampos    := ''
	Local cTable     := GetNextALias()
	Local cAuxStatus := "("
         
	_aBrowse := {}
					
	If _lChk01
		cAuxStatus += "'A',"
	EndIf
	If _lChk02
		cAuxStatus += "'P',"
	EndIf
	If _lChk03
		cAuxStatus += "'E',"
	EndIf
	If _lChk04
		cAuxStatus += "'R',"
	EndIf
                                         
	If Len(AllTrim(cAuxStatus)) > 2
		cAuxStatus := SubStr( cAuxStatus, 1, Len(AllTrim(cAuxStatus)) -1 ) + ")"
	EndIf
	
	cQry += "SELECT A.C6_FILIAL              AS FILIAL , " + Chr(13) + Chr(10)
	cQry += "       A.C6_NUM                 AS PEDIDO , " + Chr(13) + Chr(10)
	cQry += "       D.C5_EMISSAO             AS EMISSAO, " + Chr(13) + Chr(10)
	cQry += "       A.C6_CLI                 AS CODCLI , " + Chr(13) + Chr(10)
	cQry += "       E.A1_NOME                AS NOMECLI, " + Chr(13) + Chr(10)
	cQry += "       A.C6_PRODUTO             AS CODPROD, " + Chr(13) + Chr(10)
	cQry += "       C.B1_DESC                AS DESCPRO, " + Chr(13) + Chr(10)
	cQry += "       A.C6_QTDVEN              AS QPEDIDO, " + Chr(13) + Chr(10)
	cQry += "       A.C6_QTDENT              AS QENTREG, " + Chr(13) + Chr(10)
	cQry += " ROUND(A.C6_QTDVEN-A.C6_QTDENT,2) AS SALDO, " + Chr(13) + Chr(10)
	cQry += "       ISNULL(B.C2_EMISSAO, '') AS DATAOP , " + Chr(13) + Chr(10)
	cQry += "       ISNULL(B.C2_QUANT  , 0 ) AS QTDEOP , " + Chr(13) + Chr(10)
	cQry += "       ISNULL(B.DATA_PROD , '') AS DATAPR0, " + Chr(13) + Chr(10)
	cQry += "       ISNULL(B.C2_QUJE   , 0 ) AS QTDEPR0, " + Chr(13) + Chr(10)
	cQry += "       ISNULL(B.C2_DATPRF , '') AS DATPRF , " + Chr(13) + Chr(10)
	cQry += "       ISNULL(B.C2_OBS    , '') AS OBSOP  , " + Chr(13) + Chr(10)
	cQry += "       D.C5_XORCRES             AS ORCORIG, " + Chr(13) + Chr(10)
	cQry += "       A.C6_DATFAT              AS DATAFAT, " + Chr(13) + Chr(10)
	cQry += "       G.A3_NOME                AS NOMVEND, " + Chr(13) + Chr(10)
	cQry += "       D.C5_OK                  AS RESIDUO, " + Chr(13) + Chr(10)
	cQry += "       CASE WHEN C6_OK     = 'R' THEN 'R'   " + Chr(13) + Chr(10)
	cQry += "            ELSE CASE WHEN ROUND(C6_QTDENT,4) = ROUND(C6_QTDVEN,4) THEN 'E'" + Chr(13) + Chr(10)
	cQry += "       		          ELSE CASE WHEN ROUND(C6_QTDENT,4) > 0 AND ROUND(C6_QTDENT,4) <> ROUND(C6_QTDVEN,4) THEN 'P'" + Chr(13) + Chr(10)
	cQry += "       							     ELSE 'A'" + Chr(13) + Chr(10)
	cQry += "       		               END " + Chr(13) + Chr(10)
	cQry += "       		     END " + Chr(13) + Chr(10)
	cQry += "       END AS STATUS " + Chr(13) + Chr(10)
       
	cQry += "  FROM " + RetSqlName("SC6") + " A (NOLOCK)" + Chr(13) + Chr(10)
	
	cQry += "  LEFT JOIN ( SELECT C2_FILIAL, C2_NUM, C2_OBS, C2_PRODUTO, SUM(C2_QUANT) AS C2_QUANT, SUM(C2_QUJE) AS C2_QUJE, "  + Chr(13) + Chr(10)
	cQry += "                     MAX(C2_DATPRF) as C2_DATPRF, MAX(C2_EMISSAO) AS C2_EMISSAO, " + Chr(13) + Chr(10)
	cQry += "                     ISNULL( ( SELECT MAX(D3_EMISSAO) "                + Chr(13) + Chr(10)
	cQry += "                                 FROM " + RetSqlName("SD3") + " F "    + Chr(13) + Chr(10)
	cQry += "                                WHERE F.D_E_L_E_T_ = '' "              + Chr(13) + Chr(10)
	cQry += "                                  AND C2_NUM       = LEFT(F.D3_OP,6) " + Chr(13) + Chr(10)
	cQry += "                                  AND F.D3_COD     = C2_PRODUTO"       + Chr(13) + Chr(10)
	cQry += "                                  AND F.D3_CF      = 'PR0' "           + Chr(13) + Chr(10)
	cQry += "                                  AND F.D3_ESTORNO = ''	"             + Chr(13) + Chr(10)
	cQry += "                              ), '' ) AS DATA_PROD "                   + Chr(13) + Chr(10)

	cQry += "                FROM SC2010 B (NOLOCK) "                               + Chr(13) + Chr(10)
	cQry += "               WHERE B.D_E_L_E_T_ = '' "                               + Chr(13) + Chr(10)
	cQry += "               GROUP BY B.C2_FILIAL, B.C2_NUM, B.C2_PRODUTO, C2_OBS"   + Chr(13) + Chr(10)
	cQry += "            ) AS B    "                                                + Chr(13) + Chr(10)
	cQry += "           ON A.C6_NUM = B.C2_NUM    AND B.C2_PRODUTO = A.C6_PRODUTO AND A.C6_FILIAL = B.C2_FILIAL"    + Chr(13) + Chr(10)

	cQry += " INNER JOIN SB1010 C (NOLOCK) ON C.D_E_L_E_T_ = '' AND A.C6_PRODUTO = C.B1_COD  "                      + Chr(13) + Chr(10)
	cQry += " INNER JOIN SC5010 D (NOLOCK) ON D.D_E_L_E_T_ = '' AND A.C6_FILIAL  = D.C5_FILIAL AND C5_NUM = C6_NUM" + Chr(13) + Chr(10)
	cQry += " INNER JOIN SA1010 E (NOLOCK) ON E.D_E_L_E_T_ = '' AND A.C6_CLI     = E.A1_COD "                       + Chr(13) + Chr(10)
	cQry += " INNER JOIN SA3010 G (NOLOCK) ON G.D_E_L_E_T_ = '' AND G.A3_COD     = D.C5_VEND1 "                     + Chr(13) + Chr(10)

	cQry += " WHERE A.D_E_L_E_T_ = '' "                                                                             + Chr(13) + Chr(10)
	cQry += "   AND B1_GRUPO BETWEEN '23' AND '28'"                                                                 + Chr(13) + Chr(10)
	cQry += "   AND A.C6_CLI     BetWeen '" +      _cClienteIni   + "'And '" +      _cClienteFim + "'"              + Chr(13) + Chr(10)
	cQry += "   AND D.C5_EMISSAO BetWeen '" + DTOS(_dDataInicial) + "'And '" + DTOS(_dDataFinal) + "'"              + Chr(13) + Chr(10)
	cQry += "   And D.C5_VEND1 BetWeen '" + _cVendIni + "' And '" + _cVendFim + "' "
	
	If AllTrim(_cTipo2) == "Atacado"
		cQry += " AND LEN( RTRIM(D.C5_ORCRES) ) = 0  "                                                           + Chr(13) + Chr(10)
	ElseIf AllTrim(_cTipo2) == "Varejo"
		cQry += " AND LEN( RTRIM(D.C5_ORCRES) ) > 0  "                                                           + Chr(13) + Chr(10)
	EndIf
   
	If AllTrim(_cTipo) == "Filial 06200"
		cQry += " AND A.C6_FILIAL = '00' "                                                                       + Chr(13) + Chr(10)
	ElseIf AllTrim(_cTipo) == "Filial 06300"
		cQry += " AND A.C6_FILIAL = '01' "                                                                       + Chr(13) + Chr(10)
	EndIf
   
	If Len(AllTrim(cAuxStatus)) > 2
		cQry += " AND ( CASE WHEN C6_OK     = 'R' THEN 'R'   "                                                      + Chr(13) + Chr(10)
		cQry += "            ELSE CASE WHEN ROUND(C6_QTDENT,4) = ROUND(C6_QTDVEN,4) THEN 'E'"                       + Chr(13) + Chr(10)
		cQry += "       		          ELSE CASE WHEN ROUND(C6_QTDENT,4) > 0 AND ROUND(C6_QTDENT,4) <> ROUND(C6_QTDVEN,4) THEN 'P'" + Chr(13) + Chr(10)
		cQry += "       							     ELSE 'A'"                                                          + Chr(13) + Chr(10)
		cQry += "       		               END "                                                                   + Chr(13) + Chr(10)
		cQry += "       		     END "                                                                             + Chr(13) + Chr(10)
		cQry += "       END ) IN " + cAuxStatus                                                                     + Chr(13) + Chr(10)
   
	EndIf
	
	cQry += "   AND D.C5_TIPO = 'N'
	cQry += "  ORDER BY D.C5_EMISSAO, E.A1_NOME, A.C6_NUM
	
	cArqTrab := ''
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), cTable, .T., .T. )

	TCSetField(cTable,"EMISSAO" ,"D",8,0)
	TCSetField(cTable,"DATAOP"  ,"D",8,0)
	TCSetField(cTable,"DATAPR0" ,"D",8,0)
	TCSetField(cTable,"DATAPRF" ,"D",8,0)
	TCSetField(cTable,"DATAFAT" ,"D",8,0)
	TCSetField(cTable,"DATPRF"  ,"D",8,0)

	dbselectarea(cTable)

	(cTable)->(DBGOTOP())
	
	
	If (cTable)->(EOF())
	   
		aAdd( _aBrowse, { 'A'                  ,; //01
		' '                  ,; //02
		' '                  ,; //03
		DATE()               ,; //04
		' '                  ,; //05
		' '                  ,; //06
		' '                  ,; //07
		' '                  ,; //08
		'0'                  ,; //09
		'0'                  ,; //10
		'0'                  ,; //11
		DATE()               ,; //12
		'0'                  ,; //13
		DATE()               ,; //14
		'0'                  ,; //15
		DATE()               ,; //16
		DATE()               ,; //17
		' '                  ,; //18
		' '                  ,; //19
		' '                  ,;//20
		}) //21
	EndIf
	
	        
	While !(cTable)->(EOF())

		aAdd( _aBrowse, { (cTable)->STATUS            ,; //01
		(cTable)->FILIAL            ,; //02
		(cTable)->PEDIDO            ,; //03
		DTOC( (cTable)->EMISSAO )   ,; //04
		(cTable)->CODCLI            ,; //05
		(cTable)->NOMECLI           ,; //06
		(cTable)->CODPROD           ,; //07
		(cTable)->DESCPRO           ,; //08
		(cTable)->QPEDIDO           ,; //09
		(cTable)->QENTREG           ,; //10
		(cTable)->SALDO              ,; //11
		DTOC( (cTable)->DATAOP )    ,; //12
		(cTable)->QTDEOP             ,; //13
		DTOC( (cTable)->DATAPR0 )   ,; //14
		(cTable)->QTDEPR0            ,; //15
		DTOC( (cTable)->DATPRF  )   ,; //16
		DTOC( (cTable)->DATAFAT )   ,; //17
		(cTable)->NOMVEND           ,; //18
		(cTable)->RESIDUO           ,; //19
		(cTable)->OBSOP             ,;//20
		(cTable)->ORCORIG           }) //21
								
									
		(cTable)->(dbSkip())
	EndDo
	
	If nTipo == 2		
		oBrowse:SetArray(_aBrowse)		
		oBrowse:nLen := Len(_aBrowse)
		oBrowse:Refresh()
	EndIf
	 
	(cTable)->(dbCLoseArea(cTable))

	Return Nil

//************************************************************************************************************

Static Function ExportaExcel(aExport, cwCabec)
	Local i, j, nHdl, oExcelApp
	Local cArqTxt := GetTempPath()+"\aafatp08.xls"
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


//*******************************************************************************************************
//**************SEGUNDA******TELA************************************************************************
//*******************************************************************************************************/
                                                                                                                                                       

Static function fTela2(cwPedido,cwFilial, cwProd)

 //-------------------------------------------------------. 
 // Declaração das variaveis locais                        |
 //-------------------------------------------------------'
	Local _aCabec            := {'','Romaneio','Documento', 'Serie', 'Cliente', 'Razao Social','Hora Receb', 'Data Recebi', 'Ticket', 'Balanca Final','Operador','Dt Pesagem','Hr Pesagem'}
								
 //-------------------------------------------------------. 
 // Declaração das variaveis privates - Objetos            |
 //-------------------------------------------------------'		
	Private owJanela         := Nil
	Private owBrowse         := Nil
	Private _awBrowse        := {}
	Private lwContinua       := .T.
	                      
	Private awLeg            :=  { {"P" , "BR_PINK"    },;
		{"R" , "BR_AMARELO" },;
		{"B" , "BR_CINZA"   },;
		{"E" , "BR_VERMELHO"},;
		{"V" , "BR_LARANJA" },;
		{"N" , "BR_AZUL"    },;
		{"F" , "BR_BRANCO"  },;
		{"D" , "BR_PRETO"   },;
		{"S" , "BR_MARROM"  },;
		{" " , "ENABLE"     }}
	   
	//-------------------------------------------------------. 
	// Array com as cores das legendas                        |
	//-------------------------------------------------------'		
	_awCores := {{'_awBrowse[owBrowse:nAt][01] = "P" ',"BR_PINK"	 },;	// PRÉ-ROMANEIO
	{'_awBrowse[owBrowse:nAt][01] = "R" ',"BR_AMARELO" },;	// EM ROMANEIO
	{'_awBrowse[owBrowse:nAt][01] = "B" ',"BR_CINZA"   },;	// VEM BUSCAR NA LOJA
	{'_awBrowse[owBrowse:nAt][01] = "E" ',"BR_VERMELHO"},;	// ENTREGUE
	{'_awBrowse[owBrowse:nAt][01] = "V" ',"BR_LARANJA" },;	// NOVA ENTREGUE
	{'_awBrowse[owBrowse:nAt][01] = "N" ',"BR_AZUL"    },;	// ENDERECO NAO ENCONTRADO
	{'_awBrowse[owBrowse:nAt][01] = "F" ',"BR_BRANCO"  },;	// LOCAL FECHADO
	{'_awBrowse[owBrowse:nAt][01] = "D" ',"BR_PRETO"   },;	// DEVOLUCAO
	{'_awBrowse[owBrowse:nAt][01] = "S" ',"BR_MARROM"  } } 	// ESTORNO DE VENDA
	
	//-------------------------------------------------------. 
	// Array com as cores das legendas                        |
	//-------------------------------------------------------'		
	_awLegenda := {{"BR_PINK"    , "Pré-Romaneio"},;
		{"BR_AMARELO" , "Romaneio"    },;
		{"BR_VERMELHO", "Entregue"    },;
		{"BR_LARANJA" , "Nova Entrega"},;
		{"BR_CINZA"   , "Vem Buscar"  },;
		{"BR_AZUL"    , "Endereço não encontrado"},;
		{"BR_PRETO"   , "Venda com Devolução"},;
		{"BR_MARROM"  , "Venda Estornada do Romaneio"},;
		{"BR_BRANCO"  , "Local Fechado"}}
					   	
	
	cwCabec := 'Staus'       + Chr(9) + 'Romaneio' + Chr(9) + 'Documento'     + Chr(9) +'Serie'    + Chr(9) + 'Cliente'    + Chr(9) + 'Razao Social' + Chr(9) +'Hora Receb' + Chr(9)
	cwCabec += 'Data Recebi' + Chr(9) + 'Ticket'   + Chr(9) + 'Balanca Final' + Chr(9) +'Operador' + Chr(9) + 'Dt Pesagem' + Chr(9) + 'Hr Pesagem'   + Chr(13) +Chr(10)
	
	//-------------------------------------------------------. 
	// Chamada da rotina para filtrar os dados                |
	//-------------------------------------------------------'		
	Processa({|| fwGetInf(cwPedido,cwFilial, cwProd, 1)},'Filtrando Dados' )
  	
	If !lwContinua
		MsgStop("Nenhum Romaneio encontrada para este pedido!")
		Return Nil
	EndIf
			
	//-------------------------------------------------------. 
	// Cadastrando a fonte que serã utiizada na tela          |
	//-------------------------------------------------------'		
	oFont := TFont():New('Courier new',,-12,.T.)
	
	//-------------------------------------------------------. 
	// Montagem da tela de consulta romaneio                  |
	//-------------------------------------------------------'		
	DEFINE DIALOG owJanela TITLE "Consulta Romaneio" FROM 001,001 TO 550,1000 PIXEL
		                                                     
	@ 260,305 Button "&Histórico" Size 40,13 Pixel of owJanela Action MsgRun('Filtrando Dados...' ,,{|| historic(_awBrowse[owBrowse:nAt][03],_awBrowse[owBrowse:nAt][04]), owJanela:Refresh() })
	@ 260,355 Button "&Legenda"   Size 40,13 Pixel of owJanela Action BrwLegenda("Cadastro de Romaneio","Legendas",_awLegenda)
	@ 260,405 Button "&Exportar"  Size 40,13 Pixel of owJanela Action MsgRun('Exportando Excel...',,{|| ExportaExcel(_awBrowse, cwCabec), owBrowse:Refresh() })
	@ 260,455 Button "&Fechar"    Size 40,13 Pixel of owJanela Action owJanela:End()
				
	@ 005,005 TO 255,500 label "Dados dos Romaneio de Entrega" OF owJanela PIXEL
		
	owBrowse := TcBrowse():New ( 015,010,485,230 , , _aCabec,/*[ aColSizes]*/           , owJanela, /*[ cField]*/,  , , /*[ bChange]*/, /*[ bLDblClick]*/, /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/,         /*cAlias*/, /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )
	                              	   		       
	owBrowse:SetArray(_awBrowse)
	
	owBrowse:bLine := {|| { LoadBitmap(GetResources(),_awCores[aScan(_awCores,{|x| &(x[01]) })][02] ) ,;
		_awBrowse[owBrowse:nAt][02] ,;
		_awBrowse[owBrowse:nAt][03] ,;
		_awBrowse[owBrowse:nAt][04] ,;
		_awBrowse[owBrowse:nAt][05] ,;
		_awBrowse[owBrowse:nAt][06] ,;
		_awBrowse[owBrowse:nAt][07] ,;
		_awBrowse[owBrowse:nAt][08] ,;
		_awBrowse[owBrowse:nAt][09] ,;
		_awBrowse[owBrowse:nAt][10] ,;
		_awBrowse[owBrowse:nAt][11] ,;
		_awBrowse[owBrowse:nAt][12] ,;
		_awBrowse[owBrowse:nAt][13] }}
	
	owBrowse:Refresh()
//		owBrowse:BLDBLCLICK := {||  U_AAFATP3A(_awBrowse[owBrowse:nAt][02], .T., _awBrowse[owBrowse:nAt][01] ) }
	owBrowse:nScrollType := 0 // Define a barra de rolagem VCR
		
	Activate Dialog owJanela Centered
	
	Return Nil

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fwGetInf   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 16/05/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Busca as informacoes a serem filtradas de acordo com os       ¦¦¦
¦¦¦  (Cont)   ¦ parametros da tela de romaneio.                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fwGetInf(cwPedido,cwFilial, cwProd, nTipo)
	Local cQry      := ''
	Local cCampos    := ''
	Local cTable     := GetNextALias()
	Local cAuxStatus := "("
         
	_awBrowse := {}
					
	cQry += "SELECT AUX.STATUS,   "                                                                                                                        + Chr(13) + Chr(10)
	cQry +=       " AUX.ROMAN,    "                                                                                                                        + Chr(13) + Chr(10)
	cQry +=       " AUX.DOC,      "                                                                                                                        + Chr(13) + Chr(10)
	cQry +=       " AUX.SERIE,    "                                                                                                                        + Chr(13) + Chr(10)
	cQry +=       " AUX.CLIENTE,  "                                                                                                                        + Chr(13) + Chr(10)
	cQry +=       " AUX.NOMCLI,   "                                                                                                                        + Chr(13) + Chr(10)
	cQry +=       " AUX.HRREC,    "                                                                                                                        + Chr(13) + Chr(10)
	cQry +=       " AUX.DTREC,    "                                                                                                                        + Chr(13) + Chr(10)
	cQry +=       " AUX.TICKET,   "                                                                                                                        + Chr(13) + Chr(10)
	cQry +=       " AUX.BALANCA_F,"                                                                                                                         + Chr(13) + Chr(10)
	cQry +=       " AUX.OPERADOR, "                                                                                                                         + Chr(13) + Chr(10)
	cQry +=       " CONVERT(Char(10),AUX.DPESOFIM  ,112) AS DPESOFIM,"                                                                                       + Chr(13) + Chr(10)
	cQry +=       " RIGHT('0'+CONVERT(VARCHAR,DATEPART(HOUR,AUX.DPESOFIM)),2 )+':'+RIGHT('0'+CONVERT(VARCHAR,DATEPART(MINUTE,AUX.DPESOFIM)),2) AS HPESOFIM " + Chr(13) + Chr(10)
	cQry +=  " FROM ( SELECT SZE.ZE_STATUS  AS STATUS, "                                                                                                     + Chr(13) + Chr(10)
	cQry +=                " SZE.ZE_ROMAN   AS ROMAN ,SZE.ZE_DOC     AS DOC    , "                                                                           + Chr(13) + Chr(10)
	cQry +=                " SZE.ZE_SERIE   AS SERIE ,SZE.ZE_CLIENTE AS CLIENTE, "                                                                           + Chr(13) + Chr(10)
	cQry +=                " SZE.ZE_LOJACLI AS LOJA  ,SZE.ZE_NOMCLI  AS NOMCLI , "                                                                           + Chr(13) + Chr(10)
	cQry +=                " SZE.ZE_HORREC  AS HRREC ,SZE.ZE_DTREC   AS DTREC  , "                                                                           + Chr(13) + Chr(10)
	cQry +=                " SD2.D2_COD     AS PROD  ,SZE.ZE_TICKET1 AS TICKET , "                                                                           + Chr(13) + Chr(10)
	cQry +=                " SZE.ZE_ORCAMEN AS PEDIDO,SZE.ZE_FILORIG AS FILIAL , "                                                                           + Chr(13) + Chr(10)
	cQry +=                " ISNULL(BAL.Tick_DtHrPesoFinal  , '') AS DPESOFIM  , "                                                                           + Chr(13) + Chr(10)
	cQry +=                " ISNULL(BAL.Tick_BalPesoFinal   , '') AS BALANCA_F , "                                                                           + Chr(13) + Chr(10)
	cQry +=                " ISNULL(BAL.Tick_OpPesoFinal    , '') AS OPERADOR    "                                                                           + Chr(13) + Chr(10)
	cQry +=           " From " + RetSqlName("SZE") + " AS SZE (NOLOCK) "                                                                                     + Chr(13) + Chr(10)
	cQry +=           " INNER JOIN " + RetSqlName("SD2") + " AS SD2 (NOLOCK) "                                                                               + Chr(13) + Chr(10)
	cQry +=             " ON SD2.D_E_L_E_T_  = ' ' "                                                                                                         + Chr(13) + Chr(10)
	cQry +=            " AND SZE.ZE_DOC      = SD2.D2_DOC "                                                                                                  + Chr(13) + Chr(10)
	cQry +=            " AND SZE.ZE_FILORIG  = SD2.D2_FILIAL "                                                                                               + Chr(13) + Chr(10)
	cQry +=            " AND SZE.ZE_CLIENTE  = SD2.D2_CLIENTE "                                                                                              + Chr(13) + Chr(10)
	cQry +=            " AND SZE.ZE_SERIE    = SD2.D2_SERIE "                                                                                                + Chr(13) + Chr(10)
	cQry +=            " AND SZE.ZE_LOJACLI  = SD2.D2_LOJA "                                                                                                 + Chr(13) + Chr(10)
	cQry +=            " AND SD2.D2_GRUPO    BETWEEN '23' AND '28'"                                                                                          + Chr(13) + Chr(10)
	cQry +=            " AND SD2.D2_COD = '" + cwProd + "' "                                                                                                 + Chr(13) + Chr(10)
	cQry +=           " LEFT JOIN Guardian110.dbo.RegTick as BAL (NOLOCK) ON Tick_Sequencial = ZE_TICKET1  COLLATE Latin1_General_BIN "                      + Chr(13) + Chr(10)
	cQry +=          " WHERE SZE.D_E_L_E_T_ = '' "                                                                                                           + Chr(13) + Chr(10)
// cQry +=            " AND ZE_DTSAIDA BETWEEN '20130601' AND '20131231' "                                                                                  + Chr(13) + Chr(10)
	cQry +=            " AND SZE.ZE_ORCAMEN = '" + cwPedido + "' "                                                                                           + Chr(13) + Chr(10)
	cQry +=            " AND SZE.ZE_FILORIG = '" + cwFilial + "' "                                                                                           + Chr(13) + Chr(10)
	cQry +=       " ) AS AUX "                                                                                                                               + Chr(13) + Chr(10)

	cArqTrab := ''
		
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), cTable, .T., .T. )

	TCSetField(cTable,"DTREC"    ,"D",8,0)
	TCSetField(cTable,"DPESOFIM","D",8,0)

	dbselectarea(cTable)

	(cTable)->(DBGOTOP())
	
	
	If (cTable)->(EOF())
		lwContinua := .F.
	   
		aAdd( _awBrowse, { 'A'                  ,; //01
		' '                  ,; //02
		' '                  ,; //03
		' '                  ,; //04
		' '                  ,; //05
		' '                  ,; //06
		' '                  ,; //07
		DATE()               ,; //08
		' '                  ,; //09
		' '                  ,; //10
		' '                  ,; //11
		DATE()               ,; //12
		' '                  }) //13
	EndIf
	
	        
	While !(cTable)->(EOF())

		aAdd( _awBrowse, { (cTable)->STATUS         ,; //01
		(cTable)->ROMAN          ,; //02
		(cTable)->DOC            ,; //03
		(cTable)->SERIE          ,; //04
		(cTable)->CLIENTE        ,; //05
		(cTable)->NOMCLI         ,; //06
		(cTable)->HRREC          ,; //07
		DTOC((cTable)->DTREC)    ,; //08
		(cTable)->TICKET         ,; //09
		(cTable)->BALANCA_F      ,; //10
		(cTable)->OPERADOR       ,; //11
		DTOC((cTable)->DPESOFIM) ,; //12
		(cTable)->HPESOFIM       }) //13
									
		(cTable)->(dbSkip())
	EndDo
	
	If nTipo == 2
		owBrowse:AARRAY := {}
		owBrowse:SetArray(_awBrowse)
		owBrowse:bLine := {|| { LoadBitmap(GetResources(),_awCores[aScan(_awCores,{|x| &(x[01]) })][02] ) ,;
			_awBrowse[owBrowse:nAt][02] ,;
			_awBrowse[owBrowse:nAt][03] ,;
			_awBrowse[owBrowse:nAt][04] ,;
			_awBrowse[owBrowse:nAt][05] ,;
			_awBrowse[owBrowse:nAt][06] ,;
			_awBrowse[owBrowse:nAt][07] ,;
			_awBrowse[owBrowse:nAt][08] ,;
			_awBrowse[owBrowse:nAt][09] ,;
			_awBrowse[owBrowse:nAt][10] ,;
			_awBrowse[owBrowse:nAt][11] ,;
			_awBrowse[owBrowse:nAt][12] ,;
			_awBrowse[owBrowse:nAt][13] }}
		

		owBrowse:Refresh()
	EndIf
	 
	(cTable)->(dbCLoseArea(cTable))

	Return Nil


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ Historic   ¦ Autor ¦ Arlindo Neto         ¦ Data ¦ 25/09/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ TELA DE CONSULTA DE HISTÓRICO DAS NOTAS NO ROMANEIO			   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static function historic(cNota,cSerie)
	Local   cVar     := Nil
	Local   oGet     := Nil
	Private cAlias   := Alias()
	Private oDlg     := Nil
	Private oLbx     := Nil
	Private aVetor   := {}
	Private oMainWd  := Nil
                          
	aAdd( aVetor , { "", "", "", "", "", "", "" } )
  
  
	PesquisaRom(cNota,cSerie) //  Pesquisa("000056963", "2")
  
	DEFINE MSDIALOG oDlg TITLE "Consulta de histórico das notas em romaneio" From 8,0 To 30,120 OF oMainWd

	@ 015,005 LISTBOX oLbx VAR cVar FIELDS HEADER "Romaneio", "Documento","Serie","Data", "Hora","Usuário","Operação";
		SIZE 450,135 OF oDlg PIXEL
	
	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| { aVetor[oLbx:nAt,1],;
		aVetor[oLbx:nAt,2],;
		aVetor[oLbx:nAt,3],;
		aVetor[oLbx:nAt,4],;
		aVetor[oLbx:nAt,5],;
		aVetor[oLbx:nAt,6],;
		aVetor[oLbx:nAt,7]}}
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oDlg:End() },{||oDlg:End()}) CENTERED

	Return Nil

//*************************************************************************************************

Static Function PesquisaRom(cNota,cSerie)
	
	cQry := "SELECT * "
	cQry +=   "FROM "+RetSQLName("SZ4")+" A "
	cQry +=  "WHERE A.D_E_L_E_T_ = '' "
	cQry +=    "AND A.Z4_NUMNF   = '" + cNota  +"' "
	cQry +=    "AND A.Z4_SERIE   = '" + cSerie +"' "
	cQry +=  "ORDER BY R_E_C_N_O_ "
 
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "QRY", .T., .F. )
	TCSetField("QRY","Z4_DATAOP","D",8,0)

	aDel(aVetor,Len(aVetor))
	aSize(aVetor,0)
	
	While !QRY->(Eof())
		aAdd( aVetor, { QRY->Z4_ROMANEI, QRY->Z4_NUMNF, QRY->Z4_SERIE, QRY->Z4_DATAOP, QRY->Z4_HORAOP, QRY->Z4_USUARIO,QRY->Z4_OPERACA } )
		lMark := .F.
		QRY->(DbSkip())
	End
	
	QRY->(DbCloseArea())
	
	If Len(aVetor) = 0
		aAdd( aVetor , { "", "", "", "", "", "", "" } )
		MsgAlert("Não existe dados para consulta!!!",OemToAnsi("ATENCAO")  )
	EndIf
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
