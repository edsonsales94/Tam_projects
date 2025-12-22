#include "Protheus.ch"
#include "Tbiconn.ch"

User Function AAFATC02()
   
   Local aCabec     := {'Filial','Numero','Nota Fiscal','Serie','Dt venda','Cliente','Loja','Nome Cli.','Vendedor','Total Bruto','Desconto', 'Devolução', 'Total Liq','Forma Pag','Num. Entrega','Quem Recebeu','Data Rec.','Hora Rec.','Qtd Entregas'}
   Local aBLine     := {}
   Local _cAls      := ""
   
   If Type("cAcesso") = "U"
      Prepare Environment Empresa '01' Filial '01' Tables 'SZE,SD2,SF2,SL1,SC5,SA3' Modulo 'FAT'
   EndIf
   
   Private _aBrowse   := {}  
   Private _aDados    := {}   
   Private _aInsc     := {}
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
   
   Private _dPerBe  := dDataBase
   Private _dPerTo  := dDataBase
   
   Private _cVend   := Space(TamSX3('A3_COD')[01])
   Private _cNomv   := Space(TamSX3('A3_NOME')[01])
   
   Private _cCliFrom:= Space(TamSX3('A1_COD')[01])
   Private _cLojFrom:= Space(TamSX3('A1_LOJA')[01])
   Private _cCliTo  := Replicate('z', TamSX3('A1_COD')[01] )
   Private _cLojTo  := Replicate('z',TamSX3('A1_LOJA')[01] )
   
   Private lCheck1  := .T.
   Private lCheck2  := .T.
   Private lCheck3  := .F.
   
   Private _oBrw    := Nil
   
   aBLine := { ;
   { {|| IiF( Empty( (_cAls)->D2_PEDIDO) ,(_cAls)->L1_FILIAL,(_cAls)->F2_FILIAL)},"@!"},;
   { {|| IiF( Empty( (_cAls)->D2_PEDIDO) ,(_cAls)->L1_NUM, (_cAls)->D2_PEDIDO)},"@!"},;
   { {|| (_cAls)->F2_DOC},"@!"},;
   { {|| (_cAls)->F2_SERIE},"@!"},; 
   { {|| (_cAls)->F2_EMISSAO}  ,"@!"},;
   { {|| (_cAls)->F2_CLIENTE}  ,"@!"},;
   { {|| (_cAls)->F2_LOJA}     ,"@!"},;
   { {|| (_cAls)->A1_NOME}     ,"@!"},;
   { {|| Posicione('SA3',1,xFIlial('SA3') + (_cAls)->F2_VEND1  ,'A3_NOME') }    ,"@!"},;
   { {|| (_cAls)->F2_VALBRUT + (_cAls)->F2_DESCONT },"@E 999,999,999.99"},;
   { {|| (_cAls)->F2_DESCONT}  ,"@E 999,999,999.99"},;
   { {|| (_cAls)->D2_VALDEV}  ,"@E 999,999,999.99"},;   
   { {|| (_cAls)->F2_VALBRUT - (_cAls)->D2_VALDEV } ,"@E 999,999,999.99"},;
   { {||  AAFATC22(  (_cAls)->L1_FILIAL,(_cAls)->L1_NUM, (_cAls)->F2_COND) },"@!"},;
   { {|| (_cAls)->ZE_ROMAN},"@!"},;
   { {|| (_cAls)->ZE_NOMREC},"@!"},;                              
   { {|| (_cAls)->ZE_DTREC},"@!"},;
   { {|| Transform( (_cAls)->ZE_HORREC, '@R 99:99')},"@!"},; 
   { {|| Transform( (_cAls)->ENTREGAS,'@E 999' )},"@!"}}
      
   _cAls := AAFATC21(, 1)
   DEFINE MSDIALOG oWindow TITLE "Consulta Faturamento" FROM 000, 000  TO 510, 1000 COLORS 0, 16777215 PIXEL
   
   @ 010, 005 SAY "Periodo:" SIZE 040, 009 OF oWindow COLORS 0, 16777215 PIXEL
   @ 010, 040 MSGET _dPerBe  SIZE 040, 010 OF oWindow COLORS 0, 16777215 PIXEL
   @ 010, 090 MSGET _dPerTo  SIZE 040, 010 OF oWindow COLORS 0, 16777215 PIXEL 
   
   @ 025, 005 SAY "Vendedor:" SIZE 040, 009 OF oWindow COLORS 0, 16777215 PIXEL
   @ 025, 040 MSGET _cVend    SIZE 040, 010 OF oWindow COLORS 0, 16777215 PIXEL Valid _cNomV := Posicione('SA3',1,xFIlial('SA3') + _cVend ,'A3_NOME') F3 "SA3"
   @ 025, 090 MSGET _cNomV    SIZE 080, 010 OF oWindow COLORS 0, 16777215 PIXEL When .F.
   
   @ 040, 005 SAY "Cliente De/Ate:"   SIZE 040, 009 OF oWindow COLORS 0, 16777215 PIXEL
   @ 040, 040 MSGET _cCliFrom  SIZE 040, 010 OF oWindow COLORS 0, 16777215 PIXEL F3 "SA1" Valid iIf(Len(Alltrim(_cCliTo)) != 6, _cCliTo := Replicate('z', TamSX3('A1_COD')[01] ),.T.)
// @ 040, 085 MSGET _cLojFrom  SIZE 015, 010 OF oWindow COLORS 0, 16777215 PIXEL
   
   @ 040, 90 MSGET _cCliTo    SIZE 040, 010 OF oWindow COLORS 0, 16777215 PIXEL F3 "SA1"
//   @ 040, 145 MSGET _cLojFrom  SIZE 015, 010 OF oWindow COLORS 0, 16777215 PIXEL 
   
   /*
   @ 040, 005 SAY "Vendedor:" SIZE 020, 009 OF oWindow COLORS 0, 16777215 PIXEL
   @ 040, 030 MSGET _cPV      SIZE 040, 010 OF oWindow COLORS 0, 16777215 PIXEL Valid _cNomV := Posicione('SA3',1,xFIlial('SA3') + _cVend ,'A3_NOME')
   @ 040, 080 MSGET _cNomV    SIZE 080, 010 OF oWindow COLORS 0, 16777215 PIXEL When .F.
   */
   
   TButton():New(010,460,'&Consultar',oWindow,{|| MsgRun('Filtrando Dados, Aguarde...',,{|| _cAls := AAFATC21(_cAls, 2) , IiF( Type("_oBrw")="O",_oBrw:Refresh(),) } )  } ,40,12,,,,.T.) 
   TButton():New(025,460,'&Fechar'   ,oWindow,{|| oWindow:End() } ,40,12,,,,.T.) 
   TButton():New(040,460,'&Excel'    ,oWindow,{|| MsgRun('Exportando Excel...'        ,,{|| ExportaExcel(_aDados) , IiF( Type("_oBrw")="O",_oBrw:Refresh(),) } )  } ,40,12,,,,.T.) 
   
   _oMrk:= TcBrowse():New ( 005,200,80,55 , , {'','Cod. Filial'},/*[ aColSizes]*/, oWindow, /*[ cField]*/,  , , /*[ bChange]*/, /*[ bLDblClick]*/, /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/,  /*cAlias*/, /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )
   _oMrk:SetArray(_aBrowse)
   _oMrk:bLine := {||  {LoadBitmap(GetResources(), iIf(_aBrowse[_oMrk:nAt][01],"LBOK","LBNO" ) ) , _aBrowse[_oMrk:nAt][02] }} 
   _oMrk:blDblClick := {||_aBrowse[_oMrk:nAt][01] := ! _aBrowse[_oMrk:nAt][01]  }
   //_oMrk:nClrBackHead := 1677215
   //_oMrk:nClrForehead := 1987733
   oCheck1 := TCheckBox():New(005,300,'Reserva'       ,{|u| lCheck1 },oWindow,100,10,,,,,,,,.T.,,,)
   oCHeck1:bChange := {||  lCheck1 := !lCheck1, oCheck1:Refresh()}
   oCheck2 := TCheckBox():New(015,300,'Normais'       ,{|u| lCheck2 },oWindow,100,10,,,,,,,,.T.,,,)   
   oCHeck2:bChange := {||  lCheck2 := !lCheck2, oCheck2:Refresh()}
   oCheck3 := TCheckBox():New(025,300,'Transferencias',{|u| lCheck3 },oWindow,100,10,,,,,,,,.T.,,,)
   oCHeck3:bChange := {||  lCheck3 := !lCheck3, oCheck3:Refresh()}

   
   _oBrw := TcBrowse():New ( 060,007,490,140 , , /*aCabec*/,/*[ aColSizes]*/, oWindow, /*[ cField]*/,  , , /*[ bChange]*/, /*[ bLDblClick]*/, /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/,  _cAls, /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )
   
   For _nK := 1 To Len(aBline)
      _oBrw:AddColumn(TCColumn():New(aCabec[_nK], aBline[_nK][01], aBLine[_nK][02] ,,, iIf( (aBLine[_nK][02]) != "@!","RIGTH", "LEFT")  ,,.F.,.F.,,,,.F.,) )
   Next
   _oBrw:aColumns[01]:BACKCOLOR := 1987733
   _oBrw:BLDBLCLICK := {|| MsgRun('Filtrando Dados, Aguarde...',,{|| u_FATC23AA( IiF( Empty( (_cAls)->D2_PEDIDO) ,(_cAls)->L1_FILIAL,(_cAls)->F2_FILIAL) ,    IiF( Empty( (_cAls)->D2_PEDIDO) ,(_cAls)->L1_NUM,(_cAls)->D2_PEDIDO) , (_cAls)->F2_DOC, (_cAls)->F2_SERIE, Empty((_cAls)->D2_PEDIDO) ) } )  }
   //_oBrw:nScrollType := 1 // Define a barra de rolagem padrão. Observe nos exemplo 1 e 2, os tipos de barra de rolagem.
   _oBrw:nScrollType := 1 // Define a barra de rolagem VCR
   
    oFont := TFont():New('Courier new',,-12,.T.)
    oFont := TFont():New('Arial',,-12,.T.)
    
    TSay():New(205,005,{|| "TOTAL R$ :" },oWindow,, ,,,,.T.,CLR_BLACK,CLR_WHITE,90,20)
    Private oSay1:= TSay():New(205,060,{|| 0 },oWindow,"@E 999,999,999.99",oFont,,,,.T.,CLR_RED,CLR_WHITE,80,20)

    TSay():New(220,005,{|| "DEVOLUÇÃO R$ :" },oWindow,, ,,,,.T.,CLR_BLACK,CLR_WHITE,90,20)
    Private oSay3:= TSay():New(220,060,{|| 0 },oWindow,"@E 999,999,999.99",oFont,,,,.T.,CLR_RED,CLR_WHITE,80,20)
    
    TSay():New(235,005,{|| "TOTAL PESO KG :" },oWindow,, ,,,,.T.,CLR_BLACK,CLR_WHITE,90,20)
    Private oSay2:= TSay():New(235,060,{|| 0 },oWindow,"@E 999,999,999.99",oFont,,,,.T.,CLR_RED,CLR_WHITE,80,20)
    
    AAFATC21(_cAls, 2)
   ACTIVATE MSDIALOG oWindow CENTERED
     
   
Return Nil

Static Function AAFATC21(_cAlias, nTipo)
   
   Local _cQry     := ""
   Local _cWhere   := ""
   Local _cTbl     := ""
   Default _cAlias := ""   
   
   If Empty(_cAlias)
      _cAlias := CriaTrab(NIL,.F.)
   Else
   	_nItens := Nil
      (_cAlias)->(dbCloseArea(_cAlias))
      iF File(_cAlias)
         fErase(_cAlias)
      EndIf
   EndIf
   
   _cTbl := GetNextAlias()   

   _cQry += " SELECT " +If(nTipo ==  1, "TOP 1 ", "")+ " F2_FILIAL,D2_PEDIDO,F2_EMISSAO,F2_CLIENTE,F2_LOJA,A1_NOME,F2_VEND1,L1_NUM,F2_DOC,F2_SERIE,F2_VALBRUT,"

   _cQry += "        F2_DESCONT,F2_COND,B.ZE_ROMAN,B.ZE_NOMREC,B.ZE_DTREC,B.ZE_HORREC,L1_FILIAL, SUM(D2_VALDEV) D2_VALDEV, "
   
   _cQry += "     ( SELECT COUNT(*) 
   _cQry += "         FROM ( SELECT PED.D2_FILIAL,PED.D2_PEDIDO,PED.D2_DOC,PED.D2_SERIE
   _cQry += "                  FROM SD2010 PED (NOLOCK)     
   _cQry += "                  INNER JOIN SZE010 Z (NOLOCK) ON Z.D_E_L_E_T_ = ' ' AND Z.ZE_FILORIG = PED.D2_FILIAL AND Z.ZE_DOC = PED.D2_DOC AND Z.ZE_SERIE = PED.D2_SERIE
   _cQry += "                 WHERE PED.D_E_L_E_T_ = ' '      	   
   _cQry += "                   AND PED.D2_FILIAL = A.F2_FILIAL AND PED.D2_PEDIDO = D.D2_PEDIDO      	   
	_cQry += "				 GROUP BY PED.D2_FILIAL,PED.D2_PEDIDO,PED.D2_DOC,PED.D2_SERIE
	_cQry += "			) AS AUX     
   _cQry += "     ) AS ENTREGAS    
                        
   _cQry += "   FROM " + RetSqlName('SF2') + " A (NOLOCK) "
   _cQry += "   LEFT OUTER JOIN " + RetSqlName('SZE') + " B (NOLOCK) ON ZE_FILORIG = F2_FILIAL AND F2_DOC = ZE_DOC AND F2_SERIE = ZE_SERIE "
   _cQry += "                            AND B.D_E_L_E_T_= '' AND ZE_STATUS IN ('R','P','B','E') "

   _cQry += "   LEFT OUTER JOIN " + RetSqlName('SL1') + " C (NOLOCK) ON C.D_E_L_E_T_ = '' AND L1_FILIAL = F2_FILIAL AND "
   _cQry += "                                F2_DOC = L1_DOC And F2_SERIE = L1_SERIE"  //Or (F2_DOC = L1_DOCPED ANd F2_SERIE = L1_SERPED))"

   _cQry += "  INNER JOIN "       + RetSqlName('SD2') + " D (NOLOCK) ON D.D_E_L_E_T_ = '' AND D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE"
   _cQry += "    And D2_CF IN ('5101', '5102', '5116', '5117', '5118','5119','5122','5123','5124','5125','5401','5405','6101','6102','6107','6108','6109','6110','6116','6117','6118','6119','6122','6403') "

   _cQry += "   LEFT OUTER JOIN " + RetSqlName('SC5') + " F (NOLOCK) ON F.D_E_L_E_T_ = '' AND C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO"
   _cQry += "  INNER JOIN "       + RetSqlName('SA1') + " E (NOLOCK) ON E.D_E_L_E_T_ = '' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA"
   
   _cWhere += "  Where A.D_E_L_E_T_ = ''"
   _cWhere += "    And F2_EMISSAO >= '20110501'"
   _cWhere += "    And F2_EMISSAO BetWeen '" + dToS(_dPerBe) + "' And '" + dToS(_dPerTo) + "'"
   _cWhere += "    And F2_CLIENTE BetWeen '" + _cCliFrom + "' And '" + _cCliTo + "'"
//   _cWhere += "    And D2_CF IN ('5101', '5102', '5116', '5117', '5118','5119','5122','5123','5124','5125','5401','5405','6101','6102','6107','6109','6110','6116','6117','6118','6119','6122','6403') "
     
   If !(lCheck1 .And. lCheck2)
     If lCheck1
        _cWhere += "  And C5_ORCRES != ''"
     EndIf 
     If lCheck2
        _cWhere += "  And ISNUll(C5_ORCRES,'') = ''"
     EndIf     
   EndIf
   //001190// Somente Cliente da Filial da Industria
   //001184//
   If lCheck3
      _cWhere += " And F2_CLIENTE = '" + SuperGetMv("MV_XCLILOJ",.F.,"001190") + "'"
   Else
     _cInscr := ""
      aEval(_aInsc,{|x| _cInscr += x[01] + "','" })
      _cInscr := SubStr(_cInscr,1,Len(_cInscr) - 3)
      _cWhere += " And A1_CGC not in('" + _cInscr + "') "
   EndIf

   _cdIn := ''
    aEval(_aBrowse, {|x| _cdIn += iIF( x[01], SubStr(x[02],1, Len(SM0->M0_CODFIL) ) += "','" ,"")} )   
   _cdIn := SubStr(_cdIn,1, Len(_cdIn) - 3 )
   _cWhere += "  And F2_FILIAL in ('" + _cdIn + "')"
                                         
   If !Empty(_cVend)
     _cWhere += "  And F2_VEND1 = '" + _cVend + "'
   EndIf   
   _cQry += _cWhere
   _cQry += "  GROUP BY F2_FILIAL,D2_PEDIDO,F2_EMISSAO,F2_CLIENTE,F2_LOJA,A1_NOME,F2_VEND1,L1_NUM,F2_DOC,F2_SERIE,F2_VALBRUT,F2_DESCONT,F2_COND, B.ZE_ROMAN,B.ZE_NOMREC,B.ZE_DTREC,B.ZE_HORREC,L1_FILIAL"
//   _cQry += "  order by F2_FILIAL,D2_PEDIDO,L1_NUM,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA"
   _cQry += "  order by F2_EMISSAO, F2_FILIAL,D2_PEDIDO,L1_NUM,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA"
                               
   MEMOWRIT('AAFATC02.SQL',_cQry)
      
   dbUseArea(.T.,"TopConn",tcGenQry(,,ChangeQuery(_cQry)),_cTbl,.T.,.T.)
   tcSetField(_cTbl,"ZE_DTREC","D",8,0)
   tcSetField(_cTbl,"F2_EMISSAO","D",8,0)
   tcSetField(_cTbl,"F2_VALBRUT","N",15,2)   
  
   //inicio
   dbEval({||AADD(_aDados,{IiF( Empty( (_cTbl)->D2_PEDIDO) ,(_cTbl)->L1_FILIAL,(_cTbl)->F2_FILIAL) , IiF( Empty( (_cTbl)->D2_PEDIDO) ,(_cTbl)->L1_NUM, (_cTbl)->D2_PEDIDO), (_cTbl)->F2_DOC , (_cTbl)->F2_SERIE,DTOC((_cTbl)->F2_EMISSAO),(_cTbl)->F2_CLIENTE,(_cTbl)->F2_LOJA,(_cTbl)->A1_NOME,Posicione('SA3',1,xFIlial('SA3') + (_cTbl)->F2_VEND1  ,'A3_NOME'),Transform((_cTbl)->F2_VALBRUT + (_cTbl)->F2_DESCONT ,"@E 999,999,999.99"),Transform((_cTbl)->F2_DESCONT ,"@E 999,999,999.99"),Transform((_cTbl)->D2_VALDEV  ,"@E 999,999,999.99"),Transform((_cTbl)->F2_VALBRUT - (_cTbl)->D2_VALDEV,"@E 999,999,999.99"),AAFATC22(  (_cTbl)->L1_FILIAL,(_cTbl)->L1_NUM, (_cTbl)->F2_COND),(_cTbl)->ZE_ROMAN,(_cTbl)->ZE_NOMREC,DtoC((_cTbl)->ZE_DTREC),Transform( (_cTbl)->ZE_HORREC, '@R 99:99'),Transform( (_cTbl)->ENTREGAS,'@E 999' )})} )   
   (_cTbl)->(DbGoTop())
   //fim
   copy to &_cAlias
   
   dbUseArea(.T.,,_cAlias,_cAlias,.F.,.F.)
   
   (_cTbl)->(dbCloseArea(_cTbl))
   
   If Type("oSay1") = "O"
	   _cQry := " select ( SUM(F2_VALBRUT) - SUM(ISNULL(D2_VALDEV,0)) ) IT_VALOR from " + RetSqlName("SF2") + " A (NOLOCK) "
	   _cQry += "    Left Outer Join (Select distinct D2_DOC,D2_SERIE,D2_PEDIDO,D_E_L_E_T_,D2_FILIAL FRom " + RetSqlName('SD2') + "  (NOLOCK) )  D ON D.D_E_L_E_T_ = '' AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE And D2_FILIAL = F2_FILIAL
	   _cQry += "    Left Outer Join " + RetSqlName('SC5') + " F  (NOLOCK) ON F.D_E_L_E_T_ = '' AND C5_NUM = D2_PEDIDO AND C5_FILIAL = D2_FILIAL
	   _cQry += "    Left Outer Join " + RetSqlName('SA1') + " E  (NOLOCK) ON E.D_E_L_E_T_ = '' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA
	   _cQry += _cWhere
	   
	   _cQry := " select SUM( (D2_QUANT - D2_QTDEDEV)*B1_PESO) IT_PESOT , (" + _cQry + ") IT_VALORT, SUM(D2_VALDEV) IT_DEVT"   
	   //_cQry := " select SUM(D2_QUANT*B1_PESO) IT_PESOT , SUM(F2_VALBRUT) IT_VALORT "
	   _cQry += " from " + RetSqlName("SD2") + " A  (NOLOCK)  "
	   _cQry += " Left Outer Join " + RetSqlName('SC5') + " F  (NOLOCK) ON F.D_E_L_E_T_ = '' AND C5_NUM = D2_PEDIDO AND C5_FILIAL = D2_FILIAL
	   _cQry += " INNER JOIN " + RetSqlName("SB1") + " B  (NOLOCK) ON B1_COD = D2_COD AND B.D_E_L_E_T_ = ''
	   _cQry += " INNER JOIN " + RetSqlName("SF2") + " C  (NOLOCK) ON F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND C.D_E_L_E_T_ = ''   
	   _cQry += " Left Outer Join " + RetSqlName('SA1') + " E  (NOLOCK) ON E.D_E_L_E_T_ = '' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA
	   _cQry += _cWhere
	   
     dbUseArea(.T.,"TopConn",tcGenQry(,,ChangeQuery(_cQry)),_cTbl,.T.,.T.)

     MEMOWRIT('AAFATC02_2.SQL',_cQry)
     
     oSay1:SetText((_cTbl)->IT_VALORT )
     oSay2:SetText((_cTbl)->IT_PESOT  )                                                                                   
     oSay3:SetText((_cTbl)->IT_DEVT   ) 
     
     (_cTbl)->(dbCloseArea(_cTbl))
   EndIf
Return _cAlias

Static Function AAFATC22(_cFil,_cOrc,_cCond)

Local _adForm := {}
Local _cForma := ''

if Empty(_cCOnd) .Or. _cCond = 'CN'
	SL4->(dBSetOrder(1))	
	If SL4->(dbSeek(_cFil + _cOrc))
		
		While(!SL4->(EOF()) .And. (_cFil + _cOrc) == SL4->(L4_FILIAL + L4_NUM)  )
			_ndPos := iIf( Len(_adForm) !=0, aScan(_adForm,{|x| x[01] == SL4->L4_FORMA} ),0)
			If _ndPos > 0
				_adForm[_ndPos][02] += SL4->L4_VALOR
				_adForm[_ndPos][03] += 1
			else
				aAdd(_adForm,{SL4->L4_FORMA,SL4->L4_VALOR,1})
			Endif
			SL4->(dbSkip())
		EndDo
		
		_adForma := {""}
		_cdForm  := ''
		_ndItem  := 01
		
		For nI := 1 to Len(_adForm)
			_cdForm := iIf(Empty(_adForma[_ndItem]),"","/") + Alltrim(Str(_adForm[nI][03]) + "x" + Alltrim(_adForm[nI][01]) )
			If Len(_adForma[_ndItem]) + Len(_cdForm) + iIf(Empty(_adForma[_ndItem]),0,1) >= 400
				_ndItem++
			EndIf
			_adForma[_ndItem] += _cdForm
		Next
	Else
		_adForma := {""}
	EndiF
	
	
	For nK := 1 To Len(_adForma)
		_cForma += _adForma[nK] + iIF(nK!=Len(_adForma),'/','')
	Next
	
Else
	_cForma := Posicione('SE4',1, xFilial('SE4') + _cCond,'E4_DESCRI')
EndIf

Return _cForma


User Function FATC23AA(_cdFil,_cdNum,_cdNota,_cdSerie,_ldOrc,_cdEmp)
Local _cQry  := ''
Local _cdTbl := GetNextAlias()
Local _cdAls  := ''
Local _odBrw := Nil
//Local aCabec := {'Produto','Descricao','UM','Quantidade','Unitario','Seg. UM','Qtde. 2 UM','Qtde. Entregue 1UM Doc','Qtde. Entregue 2UM Doc','Qtde. Entregue 1UM','Qtde. Entregue 2UM','Qtde. Saldo 1UM','Qtde. Saldo 2UM'}
Local aCabec := {'Produto','Descricao','UM','Seg. UM','Qtde. Entregue 1UM Doc','Qtde. Entregue 2UM Doc','Qtde. Entregue 1UM','Qtde. Entregue 2UM','Quantidade','Unitario','Qtde. 2UM','Qtde. Saldo 1UM','Qtde. Saldo 2UM'}

/*Local _aBLine := {;
   { { ||  (_cdAls)->IT_PRODUTO } ,"@!" },;
   { { ||  (_cdAls)->IT_DESCPRD } ,"@!" },;
   { { ||  (_cdAls)->IT_UM      } ,"@!" },;
   { { ||  (_cdAls)->IT_QTDVEN  } ,"@E 999,999,999.99" },;
   { { ||  (_cdAls)->IT_VRUNIT  } ,"@E 999,999,999.99" },;
   { { ||  (_cdAls)->IT_SEGUM   } ,"@!" },;
   { { ||  (_cdAls)->IT_QTSEGUM } ,"@E 999,999,999.99"},;
   { { ||  (_cdAls)->IT_QTDENT3 } ,"@E 999,999,999.99" },;
   { { ||  (_cdAls)->IT_QTDENT4 } ,"@E 999,999,999.99" },;
   { { ||  (_cdAls)->IT_QTDENT1 } ,"@E 999,999,999.99" },;
   { { ||  (_cdAls)->IT_QTDENT2 } ,"@E 999,999,999.99" },;
   { { ||  (_cdAls)->IT_SALDO1  } ,"@E 999,999,999.99" },;
   { { ||  (_cdAls)->IT_SALDO2  } ,"@E 999,999,999.99" } ;
   }
  */
Local _aBLine := {;
   { { ||  (_cdAls)->IT_PRODUTO } ,"@!" },;
   { { ||  (_cdAls)->IT_DESCPRD } ,"@!" },;
   { { ||  (_cdAls)->IT_UM      } ,"@!" },;
   { { ||  (_cdAls)->IT_SEGUM   } ,"@!" },;   
   { { ||  iIf((_cdAls)->B1_TIPCONV = 'D', (_cdAls)->IT_QTDVEN /(_cdAls)->B1_CONV, (_cdAls)->IT_QTDVEN *(_cdAls)->B1_CONV)  }  ,"@E 999,999,999.99"},;
   { { ||  (_cdAls)->IT_QTDENT3 } ,"@E 999,999,999.99" },;
   { { ||  iIf((_cdAls)->B1_TIPCONV = 'D', (_cdAls)->IT_QTDENT3/(_cdAls)->B1_CONV, (_cdAls)->IT_QTDENT3*(_cdAls)->B1_CONV)  }  ,"@E 999,999,999.99"},;
   { { ||  (_cdAls)->IT_QTDENT1 } ,"@E 999,999,999.99" },;
   { { ||  (_cdAls)->IT_QTDVEN  } ,"@E 999,999,999.99" },;
   { { ||  (_cdAls)->IT_VRUNIT  } ,"@E 999,999,999.99" },;   
   { { ||  iIf((_cdAls)->B1_TIPCONV = 'D', (_cdAls)->IT_QTDENT1/(_cdAls)->B1_CONV, (_cdAls)->IT_QTDENT1*(_cdAls)->B1_CONV)  }  ,"@E 999,999,999.99"},;
   { { ||  (_cdAls)->IT_SALDO1  } ,"@E 999,999,999.99" },;
   { { ||  iIf((_cdAls)->B1_TIPCONV = 'D', (_cdAls)->IT_SALDO1 /(_cdAls)->B1_CONV, (_cdAls)->IT_SALDO1 *(_cdAls)->B1_CONV)  }  ,"@E 999,999,999.99"} }
   
   Default _cdEmp := cEmpAnt 
                       
   If _cdEmp != cEmpAnt
      //RpcSetType(3)
	  //RpcSetEnv(_cdEmp,_cdFil,,,,,{"SC5","SC6"})
   EndIf
   
  /*
Local _aBLine := {;
   { { ||  (_cdAls)->IT_PRODUTO } ,"@!" },;
   { { ||  (_cdAls)->IT_DESCPRD } ,"@!" },;
   { { ||  (_cdAls)->IT_UM      } ,"@!" },;
   { { ||  (_cdAls)->IT_QTDVEN  } ,"@E 999,999,999.99" },;
   { { ||  (_cdAls)->IT_VRUNIT  } ,"@E 999,999,999.99" },;
   { { ||  (_cdAls)->IT_SEGUM   } ,"@!" },;
   { { ||  iIf((_cdAls)->B1_TIPCONV = 'D', (_cdAls)->IT_QTDVEN /(_cdAls)->B1_CONV, (_cdAls)->IT_QTDVEN *(_cdAls)->B1_CONV)  }  ,"@E 999,999,999.99"},;
   { { ||  (_cdAls)->IT_QTDENT3 } ,"@E 999,999,999.99" },;
   { { ||  iIf((_cdAls)->B1_TIPCONV = 'D', (_cdAls)->IT_QTDENT3/(_cdAls)->B1_CONV, (_cdAls)->IT_QTDENT3*(_cdAls)->B1_CONV)  }  ,"@E 999,999,999.99"},;
   { { ||  (_cdAls)->IT_QTDENT1 } ,"@E 999,999,999.99" },;
   { { ||  iIf((_cdAls)->B1_TIPCONV = 'D', (_cdAls)->IT_QTDENT1/(_cdAls)->B1_CONV, (_cdAls)->IT_QTDENT1*(_cdAls)->B1_CONV)  }  ,"@E 999,999,999.99"},;
   { { ||  (_cdAls)->IT_SALDO1  } ,"@E 999,999,999.99" },;
   { { ||  iIf((_cdAls)->B1_TIPCONV = 'D', (_cdAls)->IT_SALDO1 /(_cdAls)->B1_CONV, (_cdAls)->IT_SALDO1 *(_cdAls)->B1_CONV)  }  ,"@E 999,999,999.99"} }   
*/

   If Type("cAcesso") = "U"
      Prepare Environment Empresa '01' Filial '01' Tables 'SZE,SD2,SF2,SL1,SC5,SA3' Modulo 'FAT'
   EndIf
  
If _ldOrc
	_cQry += " Select "
	
	_cQry += " B1_TIPCONV, B1_CONV, L2_ITEM  IT_ITEM ,L2_PRODUTO IT_PRODUTO ,L2_UM IT_UM ,L2_QUANT IT_QTDVEN ,L2_VRUNIT IT_VRUNIT ,"
	_cQry += " L2_SEGUM IT_SEGUM,L2_QTSEGUM IT_QTSEGUM ,isnull(SUM(C6_QTDENT), L2_QUANT) IT_QTDENT1, isNull(SUM(C6_QTDENT2),L2_QTSEGUM) IT_QTDENT2,"
	_cQry += " B1_ESPECIF IT_DESCPRD,D2_QUANT IT_QTDENT3 ,D2_QTSEGUM IT_QTDENT4, "
  	_cQry += " (L2_QUANT - isnull(SUM(C6_QTDENT), L2_QUANT)) IT_SALDO1, (L2_QTSEGUM - isNull(SUM(C6_QTDENT2),L2_QTSEGUM)) IT_SALDO2"
	
	_cQry += " from " +  If(_cdEmp == "01","SL2010","SL2050") + " L2 (NOLOCK) "
	If _cdFil $ '04,01'
	   _cQry += "   Left Outer Join " + If(_cdEmp == "01","SC5010","SC5050")  + " (NOLOCK)  C5 ON C5.D_E_L_E_T_ = '' and C5.C5_ORCRES = L2_NUM And C5.C5_FILIAL = L2_FILIAL "
	Else
	   _cQry += "   Left Outer Join " + If(_cdEmp == "01","SC5010","SC5050") + " (NOLOCK)  C5 ON C5.D_E_L_E_T_ = '' and C5.C5_XORCRES = L2_NUM And C5.C5_XFILRES = L2_FILIAL "
	   //_cQry += "   Left Outer Join " + RetSqlName('SC5') + " (NOLOCK)  C5 ON C5.D_E_L_E_T_ = '' and C5.C5_XORCRES = L2_NUM And C5.C5_XFILRES = L2_FILIAL "
	EndIf
	//_cQry += "   Left Outer Join " + RetSqlName('SC5') + " (NOLOCK)  C5 ON C5.D_E_L_E_T_ = '' and C5.C5_XORCRES = L2_NUM And C5.C5_XFILRES = L2_FILIAL "
	//_cQry += "   Left Outer Join " + RetSqlName('SC5') + " (NOLOCK)  C5 ON C5.D_E_L_E_T_ = '' and C5.C5_XORCRES = L2_NUM And C5.C5_XFILRES = L2_FILIAL "
	_cQry += "   Left Outer Join " + If(_cdEmp == "01","SC6010","SC6050") + " (NOLOCK)  C6 On C6.D_E_L_E_T_ = '' aND C6.C6_NUM = C5.C5_NUM AND C6.C6_FILIAL = C5.C5_FILIAL And C6.C6_PRODUTO = L2_PRODUTO "
	_cQry += "   Left Outer Join " + If(_cdEmp == "01","SB1010","SB1050") + " (NOLOCK)  B1 on B1_COD = L2_PRODUTO And B1.D_E_L_E_T_ = '' "
	_cQry += "   Left Outer Join (" 
    _cQry += "    Select D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_COD,D2_PEDIDO,SUM(D2_QUANT) D2_QUANT, SUM(D2_QTSEGUM) D2_QTSEGUM , SUM(D2_TOTAL) D2_TOTAL From  
    _cQry +=           If(_cdEmp == "01","SD2010","SD2050") + " D2 WITH(NOLOCK) Where D2.D_E_L_E_T_ = '' AND D2_DOC = '" + _cdNota + "'"
    _cQry += "    Group By D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_COD,D2_PEDIDO "
    iF _cdEmp == "05"
       _cQry += "  )D2 On D2_COD = L2_PRODUTO And D2_DOC = L2_DOC And D2_SERIE = L2_SERIE And D2_FILIAL = L2_FILIAL "
    Else    
       _cQry += "  )D2 On D2_COD = L2_PRODUTO And D2_PEDIDO = C5_NUM And D2_FILIAL = C5_FILIAL "
    EndIf
	_cQry += " Where L2.D_E_L_E_T_ = '' "
//	_cQry += " AND C5_NUM IS Not NULL
	_cQry += " And L2_FILIAL = '" + _cdFil + "' "
	_cQry += " And L2_NUM = '" + _cdNum + "' "

	If !Empty(_cdNota) .And. _cdFil != '03' "
		_cQry += " And ISNULL(D2_DOC,'"+Space(Len(SD2->D2_DOC))+"') = '"+_cdNota+"' "
	Endif
	If !Empty(_cdSerie) .And. _cdFil != '03'
		_cQry += " And ISNULL(D2_SERIE,'"+Space(Len(SD2->D2_SERIE))+"') = '"+_cdSerie+"'"
	Endif

	_cQry += " GROUP BY B1_TIPCONV, B1_CONV,L2_ITEM,L2_PRODUTO,B1_ESPECIF,L2_UM,L2_QUANT,L2_VRUNIT,L2_SEGUM,L2_QTSEGUM,D2_QUANT,D2_QTSEGUM"
	_cQry += " order by L2_ITEM"
Else
	_cQry += " Select "
	
	_cQry += " B1_TIPCONV, B1_CONV,C6_ITEM  IT_ITEM , C6_PRODUTO IT_PRODUTO, C6_UM IT_UM         , C6_QTDVEN  IT_QTDVEN , C6_PRCVEN IT_VRUNIT,"
	_cQry += " C6_SEGUM IT_SEGUM, C6_UNSVEN  IT_QTSEGUM, C6_QTDENT IT_QTDENT1, C6_QTDENT2 IT_QTDENT2,"
	_cQry += " B1_ESPECIF IT_DESCPRD,D2_QUANT IT_QTDENT3 ,D2_QTSEGUM IT_QTDENT4,"
	_cQry += " (C6_QTDVEN - C6_QTDENT) IT_SALDO1, (C6_UNSVEN - C6_QTDENT2) IT_SALDO2"
	
    _cQry += " from " + If(_cdEmp == "01","SC6010","SC6050") + " C6  (NOLOCK) " 
    _cQry += "   Left Outer Join " + If(_cdEmp == "01","SB1010","SB1050") + " B1 (NOLOCK) on B1_COD = C6_PRODUTO And B1.D_E_L_E_T_ = ''"
    //_cQry += "   Left Outer Join " + RetSqlName('SD2') + " D2  (NOLOCK) On D2_COD = C6_PRODUTO And D2_PEDIDO = C6_NUM ANd D2_FILIAL = C6_FILIAL And D2.D_E_L_E_T_ = ''"
    _cQry += "   Left Outer Join (" 
    _cQry += "    Select D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_COD,D2_PEDIDO,SUM(D2_QUANT) D2_QUANT,SUM(D2_QTSEGUM) D2_QTSEGUM, SUM(D2_TOTAL) D2_TOTAL From  
    _cQry +=        If(_cdEmp == "01","SD2010","SD2050") + " D2 WITH(NOLOCK) Where D2.D_E_L_E_T_ = '' AND D2_DOC = '" + _cdNota + "'"
    _cQry += "    Group By D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_COD,D2_PEDIDO )" 
    _cQry += "  D2 On D2_COD = C6_PRODUTO And D2_PEDIDO = C6_NUM ANd D2_FILIAL = C6_FILIAL "
    
	_cQry += " Where C6.D_E_L_E_T_ = ''"
	_cQry += " And C6_NUM = '" + _cdNum + "'"
	_cQry += " And C6_FILIAL = '" + _cdFil + "'"
	
	If !Empty(_cdNota)
		_cQry += " And ISNULL(D2_DOC,'"+Space(Len(SD2->D2_DOC))+"') = '"+_cdNota+"'"
	Endif
	If !Empty(_cdSerie)
		_cQry += " And ISNULL(D2_SERIE,'"+Space(Len(SD2->D2_SERIE))+"') = '"+_cdSerie+"'"
	Endif
EndIf

dbUseArea(.T.,"TopConn",tcGenQry(,,(_cQry)),_cdTbl,.T.,.T.)
_cdAls := CriaTrab(NIL,.F.)
copy to &_cdAls

(_cdTbl)->(dbCloseArea(_cdTbl))
dbUseArea(.T.,,_cdAls,_cdAls,.F.,.F.)
/*
Define Msdialog oDialog Title "" From 050,050 to 400,870 Pixel STYLE WS_CHILD//nOR(WS_VISIBLE,WS_POPUP)
  oColor := tColorTriangle():Create(oDialog )
  TButton():New(100,100,'&Fechar'   ,oDialog,{|| nCOlor := oColor:RetColor(), oDialog:End() } ,40,12,,,,.T.) 
  
Activate Dialog oDialog Centered
*/

//Define Msdialog oDialog Title "" From 050,050 to 400,770 COLORS 0, 16777215 Pixel STYLE nOR(WS_VISIBLE,WS_POPUP) 3306361/ 9935684 / 5080373

//nColor := 5080373
Define Msdialog oDialog Title "" From 050,050 to 330,870 COLORS 0, 16777215 Pixel STYLE WS_CLIPCHILDREN  //DS_MODALFRAME
//oDialog := MsDialog():New( 050, 050, 450, 870, "" , , , , , CLR_BLACK, SetTransparentColor(nColor,80), , , .T. , , , , , )
	_odBrw := TcBrowse():New ( 010,007,390,100 , , /*aCabec*/ , /*[ aColSizes]*/, oDialog, /*[ cField]*/,  , , /*[ bChange]*/, /*[ bLDblClick]*/, /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/,  _cdAls, /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ ,  .T. /*[lVScroll]*/ )
    //_odBrw:bLine := _aBline
    For _nK := 1 To Len(_aBline)
      If !aCabec[_nK] $ "2UM"
         _odBrw:AddColumn(TCColumn():New(aCabec[_nK], _aBline[_nK][01], _aBLine[_nK][02] ,,, iIf( (_aBLine[_nK][02]) != "@!","RIGTH", "LEFT")  ,,.F.,.F.,,,,.F.,) )
      EndIf
    Next
    _odBrw:blDblClick := {|| oDialog:End() }
    TButton():New(120,010,'&Retornar'   ,oDialog,{|| oDialog:End() } ,40,12,,,,.T.) 
    oDialog:SetCSS("MsDialog{ border:1px; }")  
 Activate Dialog oDialog Centered

(_cdAls)->(dbCloseArea(_cdAls))
If File(_cdAls)
   fErase(_cdAls)
EndIf

Return Nil

//White Snake
//Van Halen
//Scorpions
//House Martins
//queens of the stone age
//Stone templo pilots


//************************************************************************************************************

Static Function ExportaExcel(aExport)
	Local i, j, nHdl, oExcelApp
	Local cArqTxt := GetTempPath()+"\aafatC02.xls"
	Local cLinha  := ""
	
	If File(cArqTxt)
		FErase(cArqTxt)
	Endif
	
	nHdl := fCreate(cArqTxt)
	
	cLinha += 'Filial'      	+ Chr(9) + 'Numero'    	+ Chr(9) + 'Nota Fiscal'  + Chr(9) + 'Serie' 			+ Chr(9) +  'Dt venda' 	+ Chr(9) +  'Cliente' 	+ Chr(9)
	cLinha += 'Loja'        	+ Chr(9) + 'Nome Cli.'	+ Chr(9) + 'Vendedor' 	 + Chr(9) + 'Total Bruto'   	+ Chr(9) +  'Desconto'  	+ Chr(9) + 'Devolução' 	+ Chr(9)
	cLinha += 'Total Liq'  	+ Chr(9) + 'Forma Pag' 	+ Chr(9) + 'Num. Entrega' + Chr(9) + 'Quem Recebeu' 	+ Chr(9) +  'Data Rec.' 	+ Chr(9) +  'Hora Rec.'  	+ Chr(9) +  'Qtd Entregas' + Chr(13) +Chr(10)

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