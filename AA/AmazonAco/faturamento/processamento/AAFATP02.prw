//-------------------------------------------------------. 
// Declaração das bibliotecas utilizadas no programa      |
//-------------------------------------------------------'
#include "Protheus.ch"
#include "RwMake.ch"
#include "TBICONN.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATP02   ¦ Autor ¦ Diego Rafael         ¦ Data ¦ 13/07/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Consulta Romaneio - alterado por Wermeson Gadelha conforme    ¦¦¦
¦¦¦  (Cont)   ¦ solicitado pelo Sr. Valdeinir em 16/05/2013                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User function AAFATP02()
	Local cPerg := "AAFATP02"
	Local aCabec:= {'','Romaneio','Documento','Serie','Cliente','Loja','Nome','Dt. Saida', 'Ticket', 'Data Peso', 'Hora Peso', 'Placa Veiculo','Motorista','Ajudante 1','Ajudante 2','Peso','Peso Balanca','Observacao'}
	
	Local _adCab := {}
	
	aCores := { {"Empty(SZE->ZE_STATUS)",'ENABLE'     },; // ABERTO
	{'SZE->ZE_STATUS = "P" ',"BR_PINK"	  },;	// PRÉ-ROMANEIO
	{'SZE->ZE_STATUS = "R" ',"BR_AMARELO" },;	// EM ROMANEIO
	{'SZE->ZE_STATUS = "B" ',"BR_CINZA"   },;	// VEM BUSCAR NA LOJA
	{'SZE->ZE_STATUS = "E" ',"BR_VERMELHO"},;	// ENTREGUE
	{'SZE->ZE_STATUS = "V" ',"BR_LARANJA" },;	// NOVA ENTREGUE
	{'SZE->ZE_STATUS = "N" ',"BR_AZUL"    },;	// ENDERECO NAO ENCONTRADO
	{'SZE->ZE_STATUS = "F" ',"BR_BRANCO"  },;	// LOCAL FECHADO
	{'SZE->ZE_STATUS = "D" ',"BR_PRETO"   },;	// DEVOLUCAO
	{'SZE->ZE_STATUS = "S" ',"BR_MARROM"  } } 	// ESTORNO DE VENDA
	
	aLegenda := {{"ENABLE"     , "Em aberto"},;
		{"BR_PINK"    , "Pré-Romaneio"},;
		{"BR_AMARELO" , "Romaneio"    },;
		{"BR_VERMELHO", "Entregue"    },;
		{"BR_LARANJA" , "Nova Entrega"},;
		{"BR_CINZA"   , "Vem Buscar"  },;
		{"BR_AZUL"    , "Endereço não encontrado"},;
		{"BR_PRETO"   , "Venda com Devolução"},;
		{"BR_MARROM"  , "Venda Estornada do Romaneio"},;
		{"BR_BRANCO"  , "Local Fechado"}}
	
	Private oJanela := Nil
	Private oDatIni := Nil
	Private oDatFim := Nil
	Private oCliIni := Nil
	Private oCliFim := Nil
	Private oPesoT  := Nil
	Private oPesoN  := Nil
	
	Private dDataInicial := dDataBase
	Private dDataFinal := dDataBase
	Private cClienteIni := Space(Len(SA1->A1_COD))
	Private cClienteFim := replicate('z',Len(SA1->A1_COD))
	Private nPesoTotal  := 0
	Private nPesoVarejo := 0
	Private nPesoAtacado:= 0
	
	Private oChk01, lChk01 :=.T.
	Private oChk02, lChk02 :=.T.
	Private oChk03, lChk03 :=.T.
	Private oChk04, lChk04 :=.T.
	Private oChk05, lChk05 :=.T.
	Private oChk06, lChk06 :=.T.
	Private oChk07, lChk07 :=.T.
	Private oChk08, lChk08 :=.T.
	Private oChk09, lChk09 :=.T.
	Private oChk10, lChk10 :=.T.
	Private oChk11, lChk11 :=.T.
	Private oChk12, lChk12 :=.T.
	Private oChk13, lChk13 :=.T.
	
	Private _aBrowse        := {}
	
	
	Private oLayer := Nil
	
	Private aCoors := FwGetDialogSize(oMainWnd)//MsAdvSize()
	 
	cAlias := 'SZE'
	Processa({|| Filtrar(cClienteIni,cClienteFim,dDataInicial,dDataFinal)},'Filtrando Dados' )
	SZE->(dbGoTop())
	nPesoTotal := 0
	nPesoVarejo:= 0
	nPesoAtacado:= 0
	CalcPesoDiv( cClienteIni,cClienteFim,dDataInicial,dDataFinal )
	nPesoTotal := PesoTotal(cClienteIni,cClienteFim,dDataInicial,dDataFinal, "")
	SZE->(dbGoTop())
	
	oFont := TFont():New('Courier new',,-12,.T.)
	
	//DEFINE DIALOG oJanela TITLE "Consulta Romaneio por Nota" FROM 001,001 TO 550,1000 PIXEL
	
	oJanela  := MSDialog():New(aCoors[1], aCoors[2],aCoors[3], aCoors[4],"Consulta Romaneio por Nota",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	oLayer := FWLAYER():New()
	oLayer:Init(oJanela,.F.,.T.)
	oLayer:AddLine('UP',20)
	oLayer:AddLine('MIDDLE',70)
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

	@ 003,005 TO 70,aCoors[3] label "Filtros" OF _oUp PIXEL
	
	@ 018,007 Say "Data de Saida" Size 50,10 Pixel Of _oUp
	@ 018,057 MsGet oDatIni Var dDataInicial Size 60,08 Pixel of _oUp
	@ 018,130 MsGet oDatFim Var dDataFinal   Size 60,08 Pixel of _oUp
	
	@ 033,007 Say "Cliente" Size 50,10 Pixel Of _oUp
	@ 033,057 MsGet oClienteIni Var cClienteIni F3 'SA1' Size 60,08 Pixel of _oUp
	@ 033,130 MsGet oClienteFim Var cClienteFim F3 'SA1' Size 60,08 Pixel of _oUp
	
	@ 020,240 CHECKBOX oChk01 VAR lChk01 PROMPT "Aberto"       				 SIZE 70,9 PIXEL OF _oUp
	@ 027,240 CHECKBOX oChk02 VAR lChk02 PROMPT "Pré-Romaneio" 				 SIZE 70,9 PIXEL OF _oUp
	@ 034,240 CHECKBOX oChk03 VAR lChk03 PROMPT "Romaneio"     				 SIZE 70,9 PIXEL OF _oUp
	@ 041,240 CHECKBOX oChk04 VAR lChk04 PROMPT "Vem Buscar"                  SIZE 70,9 PIXEL OF _oUp
	@ 048,240 CHECKBOX oChk05 VAR lChk05 PROMPT "Entregue"                    SIZE 70,9 PIXEL OF _oUp
	
	@ 010,340 CHECKBOX oChk06 VAR lChk06 PROMPT "Endereço não Encontrado"   SIZE 70,9 PIXEL OF _oUp
	@ 020,340 CHECKBOX oChk07 VAR lChk07 PROMPT "Nova Entrega"                SIZE 70,9 PIXEL OF _oUp
	@ 030,340 CHECKBOX oChk08 VAR lChk08 PROMPT "Devolução"                   SIZE 70,9 PIXEL OF _oUp
	@ 040,340 CHECKBOX oChk09 VAR lChk09 PROMPT "Local Fechado"              SIZE 70,9 PIXEL OF _oUp
	@ 050,340 CHECKBOX oChk10 VAR lChk10 PROMPT "Estorno de Romaneio"       SIZE 70,9 PIXEL OF _oUp
    
    /*                                                 
	@ 010,455 Button "&Consultar" Size 40,13 Pixel of _oUp2 Action MsgRun('Filtrando Dados...' ,,{|| Filtrar(cClienteIni,cClienteFim,dDataInicial,dDataFinal), SZE->(dbGoTop()),oBrowse:Refresh() })
	@ 025,455 Button "&Histórico" Size 40,13 Pixel of _oUp2 Action MsgRun('Filtrando Dados...' ,,{|| historic(SZE->ZE_DOC,SZE->ZE_SERIE), oJanela:Refresh() })
	@ 040,455 Button "&Legenda"   Size 40,13 Pixel of _oUp2 Action BrwLegenda("Cadastro de Romaneio","Legendas",aLegenda)
	@ 055,455 Button "&Fechar"    Size 40,13 Pixel of _oUp2 Action oJanela:End()
	*/
	@ 010,015 Button "&Consultar" Size 40,13 Pixel of _oUp2 Action MsgRun('Filtrando Dados...' ,,{|| Filtrar(cClienteIni,cClienteFim,dDataInicial,dDataFinal), SZE->(dbGoTop()),oBrowse:Refresh() })
	@ 025,015 Button "&Histórico" Size 40,13 Pixel of _oUp2 Action MsgRun('Filtrando Dados...' ,,{|| historic(SZE->ZE_DOC,SZE->ZE_SERIE), oJanela:Refresh() })
	@ 010,060 Button "&Legenda"   Size 40,13 Pixel of _oUp2 Action BrwLegenda("Cadastro de Romaneio","Legendas",aLegenda)
	@ 025,060 Button "&Fechar"    Size 40,13 Pixel of _oUp2 Action oJanela:End()
	
	@ 075,005 TO 215,500 label "Dados" OF oJanela PIXEL
	dbSelectArea('SZE')
	oBrowse := FWBrowse():New()
	oBrowse:SetDataTable()
	oBrowse:AddStatusColumns(  { || aCores[aScan(aCores,{|x| &(x[01]) })][02] }, {||} )

	_adCabec := {}
	/*
    LoadBitmap(GetResources(),aCores[aScan(aCores,{|x| &(x[01]) })][02] )   ,
    (cAlias)->ZE_ROMAN,
    (cAlias)->ZE_DOC,
    (cAlias)->ZE_SERIE,
    (cAlias)->ZE_CLIENTE,
    (cAlias)->ZE_LOJACLI,
    (cAlias)->ZE_NOMCLI,    
    (cAlias)->ZE_DTSAIDA,     
    (cAlias)->ZE_TICKET1, 
    (cAlias)->ZE_DTPESO,     
    (cAlias)->ZE_HRPESO, 
    (cAlias)->ZE_PLACA,    
    (cAlias)->ZE_NOMOTOR,
    (cAlias)->ZE_AJUDA01,    
    (cAlias)->ZE_AJUDA02,
    
    Transform( (cAlias)->ZE_PLIQUI,"@E 9,999,999.99"),
    Transform( (cAlias)->ZE_PESO,"@E 9,999,999.99"),
    (cAlias)->ZE_OBSERV
    */
	aAdd(_adCabec,{ aCabec[02]  , {|x| SZE->ZE_ROMAN    }  , 'C' ,  '@!' , 1 , 04,  0  }  )//,.F.,{||.T.},,{|| },, {|| },.F.,.T.,1 })
	aAdd(_adCabec,{ aCabec[03]  , {|x| SZE->ZE_DOC      }  , 'C' ,  '@!' , 1 , 06,  0   } )//,.F.,{||.T.},,{|| },, {|| },.F.,.T.,1 })
	aAdd(_adCabec,{ aCabec[04]  , {|x| SZE->ZE_SERIE    }  , 'C' ,  '@!' , 1 , 03,  0   } )//,.F.,{||.T.},,{|| },, {|| },.F.,.T.,1 })
	aAdd(_adCabec,{ aCabec[05]  , {|x| SZE->ZE_CLIENTE  }  , 'C' ,  '@!' , 1 , 04,  0   } )//,.F.,{||.T.},,{|| },, {|| },.F.,.T.,1 })
	
	aAdd(_adCabec,{ aCabec[06]  , {|| SZE->ZE_LOJACLI  }  , 'C' ,  '@!' , 1 ,      02,  0 })//    ,,,,,,  })	
	aAdd(_adCabec,{ aCabec[07]  , {|| SZE->ZE_NOMCLI   }  , 'C' ,  '@!' , 1 ,      10,  0 })//   ,,,,,,  })
	aAdd(_adCabec,{ aCabec[08]  , {|| SZE->ZE_DTSAIDA  }  , 'D' ,  '@!' , 1 ,      08,  0 })//   ,,,,,,  })	
	aAdd(_adCabec,{ aCabec[09]  , {|| SZE->ZE_TICKET1  }  , 'C' ,  '@!' , 1 ,      04,  0 })//   ,,,,,,  })
	aAdd(_adCabec,{ aCabec[10]  , {|| SZE->ZE_DTPESO   }  , 'D' ,  '@!' , 1 ,      08,  0 })//   ,,,,,,  })	
	aAdd(_adCabec,{ aCabec[11]  , {|| SZE->ZE_HRPESO   }  , 'C' ,  '@!' , 1 ,      04,  0 })//   ,,,,,,  })
	aAdd(_adCabec,{ aCabec[12]  , {|| SZE->ZE_PLACA    }  , 'C' ,  '@!' , 1 ,      05,  0 })//   ,,,,,,  })	
	aAdd(_adCabec,{ aCabec[13]  , {|| SZE->ZE_NOMOTOR  }  , 'C' ,  '@!' , 1 ,      10,  0 })//   ,,,,,,  })
	aAdd(_adCabec,{ aCabec[14]  , {|| SZE->ZE_AJUDA01  }  , 'C' ,  '@!' , 1 ,      10,  0 })//   ,,,,,,  })
	aAdd(_adCabec,{ aCabec[15]  , {|| SZE->ZE_AJUDA02  }  , 'C' ,  '@!' , 1 ,      10,  0 })//   ,,,,,,  })	
	aAdd(_adCabec,{ aCabec[16]  , {|| SZE->ZE_PLIQUI   }  , 'N' ,  '@E 999,999,999.99' , 2 ,      06,  0    })//,,,,,,  })
	aAdd(_adCabec,{ aCabec[17]  , {|| SZE->ZE_PESO     }  , 'N' ,  '@E 999,999,999.99' , 2 ,      06,  0    })//,,,,,,  })
	aAdd(_adCabec,{ aCabec[18]  , {|| SZE->ZE_OBSERV   }  , 'C' ,  '@!' , 1 ,      20,  0    })//,,,,,,  })
	
	//oBrowse:SetColumns(_adCabec)
	For nI := 1 To Len(_adCabec)
	   oBrowse:AddColumn(_adCabec[nI])
	Next
	oBrowse:setAlias(cAlias)
	//oBrowse:SetArray(_aBrowse)
	oBrowse:SetOwner(_oMiddle)
	oBrowse:SetDoubleClick( {||  u_AAFATP2A() } )
	oBrowse:Activate()

//	oBrowse := TcBrowse():New ( 080,007,490,160 , , aCabec,/*[ aColSizes]*/, oJanela, /*[ cField]*/,  , , /*[ bChange]*/, /*[ bLDblClick]*/, /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/,  cAlias, /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )
//	oBrowse:bLine := {|| { LoadBitmap(GetResources(),aCores[aScan(aCores,{|x| &(x[01]) })][02] )   ,(cAlias)->ZE_ROMAN,(cAlias)->ZE_DOC,(cAlias)->ZE_SERIE,(cAlias)->ZE_CLIENTE,(cAlias)->ZE_LOJACLI,(cAlias)->ZE_NOMCLI,(cAlias)->ZE_DTSAIDA, (cAlias)->ZE_TICKET1, (cAlias)->ZE_DTPESO, (cAlias)->ZE_HRPESO, (cAlias)->ZE_PLACA,(cAlias)->ZE_NOMOTOR,(cAlias)->ZE_AJUDA01,(cAlias)->ZE_AJUDA02,Transform( (cAlias)->ZE_PLIQUI,"@E 9,999,999.99"),Transform( (cAlias)->ZE_PESO,"@E 9,999,999.99"),(cAlias)->ZE_OBSERV } }
//	oBrowse:BLDBLCLICK := {||  u_AAFATP2A() }

//	oBrowse:nScrollType := 0 // Define a barra de rolagem VCR
	
	//@ 240,005 TO 270,aCoors[03] label "Totais" OF oJanela PIXEL
	@ 005,007 Say "Total Peso Balanca" Size 70,10 Pixel Of _oDown
	oPesoT:= TSay():New(015,007,{|| Transform(nPesoTotal,"@E 999,999,999,999,999.99") },_oDown,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
	
	@ 005,157 Say "Total Notas"  Size 70,10 Pixel Of _oDown
	oPesoN:= TSay():New(015,107,{|| Transform(nPesoVarejo + nPesoAtacado,"@E 999,999,999,999,999.99")},_oDown,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
	
	@ 005,257 Say "Varejo"  Size 70,10 Pixel Of _oDown
	oPesoV:= TSay():New(015,207,{|| Transform(nPesoVarejo,"@E 999,999,999,999,999.99")},_oDown,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
	
	@ 005,357 Say "Atacado" Size 70,10 Pixel Of _oDown
	oPesoA:= TSay():New(015,307,{|| Transform(nPesoAtacado,"@E 999,999,999,999,999.99") },_oDown,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,200,20)
	Activate Dialog oJanela Centered
	
	Return Nil

User Function AAFATP2A(_cAlias)
	LOcal oWindow := Nil
	
	Local cAlias  := 'SD2'
	Local _aARea  := SZ3->(GetArea())
	
	Private oBrw    := Nil
	Private oSay1   := Nil
	Private oSay2   := Nil
	Private oSay3   := Nil
	
	Private cSay1   := ''
	Private cSay2   := ''
	Private cSay3   := ''
	Private nPesoRom:= 0
	
	oFont := TFont():New('Courier new',,-12,.T.)
	
	cChave := xFilial('SZE') + (iIf(Empty(_cAlias),"SZE",_cAlias))->ZE_ROMAN
	
	_nRecNo := SZE->(Recno())
	SZE->(dbSetORder(1))
	SZE->(dbGoTop())
	SZE->(dbSeek(cChave ) )
	nPesoRom := 0
	SZE->(DBEVAL({|| nPesoRom += SZE->ZE_PLIQUI} ,{|| SZE->(ZE_FILIAL + ZE_ROMAN) == cChave } ,{|| SZE->(ZE_FILIAL + ZE_ROMAN) == cChave }  ) )
	SZE->(dbgoTo(_nRecno))
	Private _cdNome := ""
	Private _cdCod  := ""
	_cdTipo := iIf(Empty(_cAlias),SZE->ZE_TIPO ,(_cAlias)->ZE_TIPO)
//	If _cdTipo == 'S'
    If _cdTipo == "S" .Or. Empty(_cdTipo)
		_cQry := " Select * from " + RetSqlName('SD2')
		_cQry += " where D_E_L_E_T_ = ''
		_cQry += " And D2_DOC = '" + iIf(Empty(_cAlias),SZE->ZE_DOC,(_cAlias)->ZE_DOC) + "'"
		_cQry += " And D2_SERIE = '" + iIf(Empty(_cAlias),SZE->ZE_SERIE,(_cAlias)->ZE_SERIE) + "'"
		_cQry += " And D2_FILIAL = '" + iIf(Empty(_cAlias),SZE->ZE_FILORIG,(_cAlias)->ZE_FILORIG) + "'"
		
		_cdNome := "{|| Posicione('SA1',1,xFilial('SA1') + (cAlias1)->(D2_CLIENTE + D2_LOJA),'A1_NOME') }"
		_cdCond := "{|| Posicione('SE4',1,xFilial('SE4') + Posicione('SF2',1,xFilial('SF2') + (iIf(Empty(_cAlias),'SZE',_cAlias))->(ZE_DOC + ZE_SERIE),'F2_COND') ,'E4_DESCRI') }"
		
    ElseIf _cdTipo == 'E' 
        _cQry := " Select
        _cQry += " D1_FILIAL D2_FILIAL, 
        _cQry += " D1_PEDIDO D2_PEDIDO,
        _cQry += " D1_COD    D2_COD,
        _cQry += " D1_QUANT  D2_QUANT,
        _cQry += " D1_VUNIT  D2_PRCVEN,
        _cQry += " D1_TOTAL  D2_TOTAL,
        _cQry += " D1_EMISSAO D2_EMISSAO,
        _cQry += " D1_FORNECE D2_CLIENTE,
        _cQry += " D1_LOJA    D2_LOJA
        _cQry += " from " + RetSqlName('SD1')
		_cQry += " where D_E_L_E_T_ = ''
		_cQry += " And D1_DOC = '" + iIf(Empty(_cAlias),SZE->ZE_DOC,(_cAlias)->ZE_DOC) + "'"
		_cQry += " And D1_SERIE = '" + iIf(Empty(_cAlias),SZE->ZE_SERIE,(_cAlias)->ZE_SERIE) + "'"
		_cQry += " And D1_FILIAL = '" + iIf(Empty(_cAlias),SZE->ZE_FILORIG,(_cAlias)->ZE_FILORIG) + "'"
		_cQry += " And D1_FORNECE = '" + iIf(Empty(_cAlias),SZE->ZE_CLIENTE,(_cAlias)->ZE_CLIENTE) + "'"
		_cQry += " And D1_LOJA    = '" + iIf(Empty(_cAlias),SZE->ZE_LOJALI,(_cAlias)->ZE_LOJACLI) + "'"
			
		_cdNome := "{|| Posicione('SA2',1,xFilial('SA2') + (cAlias1)->(D2_CLIENTE + D2_LOJA),'A2_NOME') } "
		_cdCond := "{|| Posicione('SE4',1,xFilial('SE4') + Posicione('SF1',1,xFilial('SF1') + (iIf(Empty(_cAlias),'SZE',_cAlias))->(ZE_DOC + ZE_SERIE),'F1_COND') ,'E4_DESCRI') } " 
	EndIf
	cTable := getNextAlias()
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(_cQry)), cTable, .T., .T. )
	TCSetField(cTable,"D2_EMISSAO","D",8,0)
	
	cAlias1 := CriaTrab(NIL,.f.)
	copy to &cAlias1
	
	dbUseArea(.T.,,cAlias1,cAlias1,.F.,.F.)
	
	DEFINE DIALOG oWindow TITLE "Itens da Nota Saida" FROM 001,001 TO 550,1000 PIXEL
	
	@ 003,005 TO 55,500 label "" OF oWindow PIXEL
	
	@ 018,007 Say "Numero da Entrega:"  Size 70,10 Pixel Of oWindow
	@ 018,077 Say (iIf(Empty(_cAlias),"SZE",_cAlias))->ZE_ROMAN         Size 40,10 Pixel Of oWindow
	@ 030,007 Say "Peso Balanca:  "     Size 40,10 Pixel Of oWindow
	@ 030,077 Say Transform( (iIf(Empty(_cAlias),"SZE",_cAlias))->ZE_PESO,"@E 999,999.99")    COLOR CLR_RED Size 40,10 Pixel Of oWindow
	@ 040,007 Say "Peso Romaneio(Notas):  "     Size 70,10 Pixel Of oWindow
	@ 040,077 Say Transform(nPesoRom,"@E 999,999,999.99")    COLOR CLR_RED Size 40,10 Pixel Of oWindow
	
	@ 018,207 Say "Documento / Serie"              Size 70,10 Pixel Of oWindow
	@ 018,277 Say  (iIf(Empty(_cAlias),"SZE",_cAlias))->(ZE_DOC + '/' + ZE_SERIE)   Size 40,10 Pixel Of oWindow
	@ 030,207 Say "Peso Nota   "     Size 40,10 Pixel Of oWindow
	@ 030,277 Say Transform( (iIf(Empty(_cAlias),"SZE",_cAlias))->ZE_PLIQUI,"@E 999,999,999.99")  COLOR CLR_RED   Size 40,10 Pixel Of oWindow
	
	@ 060,005 TO 225,500 label "Itens" OF oWindow PIXEL
	
	oBrw := BrGetDDB():New( 070,007,490,140,,,,oWindow,,,,,,,,,,,,.F.,cAlias1,.T.,,.F.,,, )
	oBrw:AddColumn(TCColumn():New('Pedido'        ,{||(cAlias1)->D2_PEDIDO}  ,,,,'LEFT' ,,.F.,.F.,,,,.F.,))
	oBrw:AddColumn(TCColumn():New('Produto '      ,{||(cAlias1)->D2_COD},,,,'LEFT' ,,.F.,.F.,,,,.F.,))
	oBrw:AddColumn(TCColumn():New('Descricao'     ,{||Posicione('SB1',1,xFilial('SB1') +(cAlias1)->D2_COD,'B1_ESPECIF')},,,,'LEFT' ,,.F.,.F.,,,,.F.,))
	
	oBrw:AddColumn(TCColumn():New('Quantidade '   ,{||Transform( (cAlias1)->D2_QUANT,"@E 999,999,999.99")},,,,'RIGTH' ,,.F.,.F.,,,,.F.,))
	oBrw:AddColumn(TCColumn():New('Peso'          ,{||Transform( (cAlias1)->D2_QUANT * Posicione('SB1',1,xFilial('SB1') +(cAlias)->D2_COD,'B1_PESO'),"@E 9,999,999.99") },,,,'RIGTH' ,,.F.,.F.,,,,.F.,))
	oBrw:AddColumn(TCColumn():New('Valor Unit.'   ,{||Transform( (cAlias1)->D2_PRCVEN,"@E 999,999,999.99")},,,,'RIGTH' ,,.F.,.F.,,,,.F.,))
	oBrw:AddColumn(TCColumn():New('Valor da Venda',{||Transform( (cAlias1)->D2_TOTAL,"@E 999,999,999.99")}  ,,,,'RIGTH' ,,.F.,.F.,,,,.F.,))
	
	oBrw:AddColumn(TCColumn():New('Data Venda '   ,{||(cAlias1)->D2_EMISSAO} ,,,,'LEFT' ,,.F.,.F.,,,,.F.,))
	oBrw:AddColumn(TCColumn():New('Cliente'       ,{||(cAlias1)->D2_CLIENTE},,,,'LEFT' ,,.F.,.F.,,,,.F.,))
	oBrw:AddColumn(TCColumn():New('Loja'          ,{||(cAlias1)->D2_LOJA}  ,,,,'LEFT' ,,.F.,.F.,,,,.F.,))
	oBrw:AddColumn(TCColumn():New('Nome'          , &(_cdNome)     ,,,,'LEFT' ,,.F.,.F.,,,,.F.,))
	oBrw:AddColumn(TCColumn():New('Forma Pgto.'   , &(_cdCond)     ,,,,'LEFT' ,,.F.,.F.,,,,.F.,))
	
	
	@ 230,005 TO 270,500 label "Rodape" OF oWindow PIXEL
	oSay1:= TSay():New(240,008,{||''},oWindow,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,400,20)
	oSay2:= TSay():New(250,008,{||''},oWindow,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,400,20)
	oSay3:= TSay():New(260,008,{||''},oWindow,,oFont,, ,,.T.,CLR_RED,CLR_WHITE,400,20)
	AtuSC5( (cAlias1)->D2_FILIAL,(cAlias1)->D2_PEDIDO)
	Activate Dialog oWindow Centered
	
	(cAlias1)->(dbCloseArea(cAlias1))
	
	Return Nil

Static Function Filtrar(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal)
	Local aARea      := GetArea()
	Local cAuxStatus := "*"
   
	If lChk01
		cAuxStatus += space(1)
	EndIf
	If lChk02
		cAuxStatus += "P"
	EndIf
	If lChk03
		cAuxStatus += "R"
	EndIf
	If lChk04
		cAuxStatus += "B"
	EndIf
	If lChk05
		cAuxStatus += "E"
	EndIf
	If lChk06
		cAuxStatus += "N"
	EndIf
	If lChk07
		cAuxStatus += "V"
	EndIf
	If lChk08
		cAuxStatus += "D"
	EndIf
	If lChk09
		cAuxStatus += "F"
	EndIf
	If lChk10
		cAuxStatus += "S"
	EndIf
   
	dbSelectArea('SZE')
	Set Filter To SZE->ZE_STATUS $ cAuxStatus .And.;
		Len(Alltrim(SZE->ZE_ROMAN))!= 0 .And.;
		SZE->ZE_CLIENTE>=_cClienteIni .And. SZE->ZE_CLIENTE<= _cClienteFim .And.;
		SZE->ZE_DTSAIDA >= _dDataInicial .And. SZE->ZE_DTSAIDA <= _dDataFinal
	
	SZE->(dbGoTop())
	nPesoTotal   := 0
	nPesoVarejo  := 0
	nPesoAtacado := 0
	CalcPesoDiv( cClienteIni,cClienteFim,dDataInicial,dDataFinal )
	nPesoTotal := PesoTotal(cClienteIni,cClienteFim,dDataInicial,dDataFinal, "")
	SZE->(dbGoTop())
	
	If Type("oPesoT") != "U"
		oPesoT:SetText(Transform(nPesoTotal,"@E 999,999,999,999.99") )
	EndIF
	If Type("oPesoV") != "U"
		oPesoV:SetText(Transform(nPesoVarejo,"@E 999,999,999,999,999.99"))
	EndIF
	If Type("oPesoA") != "U"
		oPesoA:SetText(Transform(nPesoAtacado,"@E 999,999,999,999,999.99"))
	EndIF
	If Type("oPesoN") != "U"
		oPesoN:SetText(Transform(nPesoAtacado + nPesoVarejo,"@E 999,999,999,999,999.99"))
	EndIF
	
	RestArea(aArea)
	Return Nil

Static Function CalcPesoDiv(_cClienteIni,_cClienteFim,_dDataInicial,_dDataFinal)
	Local _cQry := ''
	
	_cQry += " select C5_ORCRES,SUM(PesoTotal) PESOTOTAL From ("
	_cQry += " select case"
	_cQry += "           When Len(RTRIM(C5_ORCRES)) = 0 Then '1'"
	_cQry += "           else '2'"
	_cQry += "        End C5_ORCRES"
	_cQry += "        ,Sum(B1_PESO * D2_QUANT) PesoTotal"
	_cQry += "    from " + RetSqlName('SZE') + " A"
	_cQry += "   Left Outer Join " +  RetSqlName('SD2') + " On D2_FILIAL = ZE_FILORIG and D2_DOC = ZE_DOC and ZE_SERIE = D2_SERIE"
	_cQry += "   Left Outer Join " +  RetSqlName('SC5') + " on C5_NUM = D2_PEDIDO and D2_FILIAL = C5_FILIAL"
	_cQry += "   Left Outer Join " +  RetSqlName('SB1') + " on B1_COD = D2_COD"
	_cQry += " WHERE A.D_E_L_E_T_ = '' "
	_cQry += " ANd ZE_CLIENTE BetWeen '" + cClienteIni + "'And '" + cClienteFim + "'"
	_cQry += " And ZE_DTSAIDA BetWeen '" + DTOS(dDataInicial) + "'And '" + DTOS(dDataFinal) + "'"
	_cQry += " And ZE_STATUS in ('R','E','B')"
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

Static Function PesoTotal()
	Local _cQry  := ''
	Local cTable := GetNextAlias()
	Local _aArea := GetArea()
	
	_cQry += " Select SUM(ZE_PESO) ZE_PESO   "                                                      + Chr(13) + Chr(10)
	_cQry += " From (  "                                                                            + Chr(13) + Chr(10)
	_cQry += " select ZE_ROMAN,MAX(ZE_PESO)  ZE_PESO from " + RetSqlName("SZE")                     + Chr(13) + Chr(10)
	_cQry += " WHere D_E_L_E_T_ = '' "                                                              + Chr(13) + Chr(10)
	_cQry += " ANd ZE_CLIENTE BetWeen '" + cClienteIni + "'And '" + cClienteFim + "'"               + Chr(13) + Chr(10)
	_cQry += " And ZE_DTSAIDA BetWeen '" + DTOS(dDataInicial) + "'And '" + DTOS(dDataFinal) + "'"   + Chr(13) + Chr(10)
	_cQry += " group by ZE_ROMAN "                                                                  + Chr(13) + Chr(10)
	_cQry += " ) A"
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(_cQry)), cTable, .T., .T. )
	
	nPesoTotal := (cTable)->ZE_PESO
	(cTable)->(dbCloseArea(cTable))
	
	RestArea(_aArea)
	
	Return nPesoTotal

Static Function AtuSC5(_cFilial,_cPedido)
	SC5->(dBSetORder(1))
	SA1->(dBSetORder(1))
	
	SC5->(dBSeek(_cFilial + _cPedido))
	SA1->(dBSeek( xFilial('SA1') + SC5->(C5_CLIENTE + C5_LOJACLI) ))
	
	IF Empty(SC5->C5_ORCRES)
		oSay1:SetText('Endereco: ' + Alltrim(SA1->A1_END) + '    ' + Alltrim(SA1->A1_BAIRRO) + '   ' + Alltrim(SA1->A1_MUN) + '-' + SA1->A1_EST)
		oSay2:SetText('Entregar em: ' + Alltrim(SC5->C5_ENDENT) + '   ' + Alltrim(SC5->C5_BAIRROE)+'  ' + Alltrim(SC5->C5_MUNE) + '-'+Alltrim(SC5->C5_ESTE) )
		oSay3:SetText(Alltrim(SC5->C5_OBSENT1) + Alltrim(SC5->C5_OBSENT2) )
	else
		SL1->(dbSeek(SC5->C5_FILIAL + SC5->C5_ORCRES))
		oSay1:SetText('Endereco: ' + Alltrim(SA1->A1_END) + '    ' + Alltrim(SA1->A1_BAIRRO) + '   ' + Alltrim(SA1->A1_MUN) + '-' + SA1->A1_EST)
		oSay2:SetText('Entregar em: ' + Alltrim(SL1->L1_ENDENT) + '   ' + Alltrim(SL1->L1_BAIRROE)+'  ' + Alltrim(SL1->L1_MUNE) + '-'+Alltrim(SL1->L1_ESTE) )
		oSay3:SetText(Alltrim(SL1->L1_OBSENT1) + Alltrim(SL1->L1_OBSENT2) )
	EndIf
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
