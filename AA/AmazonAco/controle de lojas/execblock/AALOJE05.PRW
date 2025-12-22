#INCLUDE "Font.ch"
#Include "Protheus.ch" 
#include "rwmake.ch"   
#include "TopConn.ch"
#include "tbiconn.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦AALOJE05    ¦ Autor ¦                      ¦ Data ¦ 29/12/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Inclusão da Opção de Liberação no Ponto de Entrada no Browser ¦¦¦
¦¦¦             da Tela de Venda Assistida.		                              ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/ 

User Function AALOJE05()

Private cCadastro := "Liberação"
Private aRotina   := { {"Pesquisar"  ,"AxPesqui"   ,0,1} ,;
                       {"Legenda"    ,"u_AALJE05L"   ,0,1} ,;
                       {"Liberação"  ,"u_AALJ05V",0,2} }//,;
//                     {"Visualizar" ,"AxVisual",0,2} ,;
//                     {"Alterar"    ,"AxAltera",0,4} ,;
//                     {"Excluir"    ,"AxDeleta",0,5} }
                                                         
Private cAlias0 := "SZ3"
Private aCores  := { {"Z3_TIPO  == '1'","BR_PRETO"    },; // ORCAMENTO LOJA
                     {"Z3_TIPO  == '2'","BR_LARANJA" },; // PEDIDO DE VENDA
                     {"Z3_TIPO  == '3'","BR_AZUL"  }} // ORCAMENTO FATURAMENTO
                     
dbSelectArea(cAlias0)
dbSetOrder(1)

_cdFilter := ''
if __cUserId$GetMv("MV_XLIBORG")
   _cdFilter := 'SZ3->Z3_BLOQUEI <> "  "'
EndIf
if __cUserId$GetMv("MV_XLIBORC")
   _cdFilter += iIf(!EMpty(_cdFilter),' .Or. ','') + 'Left(SZ3->Z3_BLOQUEI,1)="C" '
EndIf
if __cUserId$GetMv("MV_XLIBORD")
   _cdFilter += iIf(!EMpty(_cdFilter),' .Or. ','') + 'Right(SZ3->Z3_BLOQUEI,1)="D" '
EndIf
If Empty(_cdFilter)
   _cdFilter := "SZ3->Z3_BLOQUEI = '**'"
EndIf

dbSetFilter({|| &(_cdFilter)},_cdFilter)


mBrowse( 6,1,22,75,cAlias0,,,,,,aCores)

Return
             

User Function AALJ05V(cTipo)
Local aAreaSL1 := SL1->(GetARea())
Local aAreaSc5 := SC5->(GetARea())
Local cFuncao

If SZ3->Z3_TIPO = "1"
   SL1->(dbSetOrder(1))
   SL1->(dbSeek(SZ3->Z3_FILIAL + SZ3->Z3_VENDA + SZ3->Z3_CLIENTE + SZ3->Z3_LOJA))   
   AALJ05T1()
   SL1->(RestArea(aAreaSL1))
Elseif SZ3->Z3_TIPO = "2"
   SC5->(dbSetOrder(1))
   SC5->(dbSeek(SZ3->Z3_FILIAL + SZ3->Z3_VENDA + SZ3->Z3_CLIENTE + SZ3->Z3_LOJA))
   AALJ05T2()
   SC5->(RestArea(aAreaSC5))
ElseIf SZ3->Z3_TIPO = "3"
   SCJ->(dbSetOrder(1))
   SCJ->(dbSeek(SZ3->Z3_FILIAL + SZ3->Z3_VENDA + SZ3->Z3_CLIENTE + SZ3->Z3_LOJA))
   AALJ05T3()
   SCJ->(RestArea(aAreaSC5))
EndIf


Return


//#################################################      
//Tela de Liberação
//#################################################

Static Function Libera()
   Local lLibera := .T.
   Local cCodtab  := SuperGetMv("MV_XTABELA",.F.,"")
   Local _ldFin  := .F.
   Local _ldDesc := .F.
   
   _adDescMax := _getDescMax() 
   
   SZ3->(RecLOck('SZ3',.F.))
	If Left(SZ3->Z3_BLOQUEI,1) = 'C'
		If __cUserId$GetMv("MV_XLIBORC") .Or. __cUserId$GetMv("MV_XLIBORG")
			SZ3->Z3_BLOQUEI := ' ' + Right(SZ3->Z3_BLOQUEI,1)
			_ldFin := .T.			
		EndIf
	EndIf
	
	If (__cUserId$GetMv("MV_XLIBORD") .Or. __cUserId$GetMv("MV_XLIBORG"))  .And. Right(SZ3->Z3_BLOQUEI,1) = 'D'
		lLibera := .T.
		_ldDesc := .T.
		
		If SZ3->Z3_TIPO = "1"
			SL2->(dbSetOrder(1))
			SL2->(dbSeek(xFilial("SL2")+SZ3->Z3_VENDA))
			
			lLibera := .T.
			While  !SL2->(EOF()) .And. SL2->L2_NUM == SZ3->Z3_VENDA .And. lLibera
			    _ndPrcTab := Posicione('DA1',1,xFilial('DA1')+cCodTab+SL2->L2_PRODUTO,"DA1_PRCVEN")
			    _ndPerc := (SL1->L1_DESCONT * 100)/SL1->L1_VLRTOT
			    
			    If SL2->L2_DESC > 0
			       _ndPerc := SL2->L2_DESC 
			    EndIf
			    _ndPrcTab := SL2->L2_VRUNIT + 10 
			    If SL2->L2_VRUNIT < _ndPrcTab			        
			       lLibera := .T. 
			       _xdPos := aScan(_adDescMax,{|x| x[01] == __cUserId })
			       If _xdPos > 0
	 		       	  lLibera := _ndPerc < _adDescMax[_xdPos][02]
			       	  If !lLibera
			       	     Aviso('Atencao','Desconto Superior ao Maximo permitido para Liberação por este Usuario',{'OK'})
			       	  EndIf			       	   
			       Else
			       	  Aviso('Atencao','Usuario Sem Acesso a Liberacão de Desconto',{'OK'})			       
			          lLibera := .F.		          
			       EndIf 
			    Else
			       Aviso('Atencao','Preco Maior que o da Tabela de Preco',{'OK'})
			    EndIf 
			    //EndIf
			    
			    SL2->(dbSkip())
			EndDo
						
		ElseIf SZ3->Z3_TIPO = "2"
		
		   _ndTotal := 0
		   _ndPrcTab := Posicione('DA1',1,xFilial('DA1')+cCodTab+SC6->C6_PRODUTO,"DA1_PRCVEN")
			
			SC6->(dbSetOrder(1))
			SC6->(dbSeek(xFilial("SC6")+SZ3->Z3_VENDA))
			SC6->( DBEVAL({|| _ndTotal += SC6->C6_VALOR - SC6->C6_VALDESC },  {||SC6->C6_NUM = SC5->C5_NUM}, {||SC6->C6_NUM = SC5->C5_NUM}, , , ))
			
			SC6->(dbSeek(xFilial("SC6")+SZ3->Z3_VENDA))			
			SC6->( DBEVAL({|| lLibera := lLibera .And. ;
			                 !( SC6->C6_PRCVEN <= _ndPrcTab .Or. ;
			                    SC6->C6_PRUNIT* (100-SC5->C5_DESCONT * 100/_ndTotal )/100 < _ndPrcTab .Or.;
			                    SC6->C6_PRUNIT* (100-SC5->C5_PDESCAB)/100 < _ndPrcTab ) },;
			                  {||SC6->C6_NUM = SC5->C5_NUM},{||SC6->C6_NUM = SC5->C5_NUM} , , , ) )
		EndIf
		
		If !lLibera
			Aviso("Atenção","Desconto Ultrapassa preço do Atacado, Somente Usuario Superior",{"OK"})
		Else
			SZ3->Z3_BLOQUEI := Left(SZ3->Z3_BLOQUEI,1) + " "
		EndIf		
	EndIf
    /*
	If __cUserId$GetMv("MV_XLIBORG").And. Right(SZ3->Z3_BLOQUEI,1) = 'D' .And. lLibera
	   SZ3->Z3_BLOQUEI := Left(SZ3->Z3_BLOQUEI,1) + " "
	EndIf
	*/
	
	iF lLibera		
		SZ3->(MsUnlock())
		UpdPrincipal()	
		
		IF Empty(SZ3->Z3_BLOQUEI)
		   SZ3->(RecLock("SZ3",.F.))		      
		      If _ldDesc
			      If SZ3->(fieldPos('Z3_USRDESC')) > 0
			         SZ3->Z3_USRDESC := __cUserId + '-' + cUserName		      
			      EndIf
			      If SZ3->(fieldPos('Z3_DTDESC')) > 0
			         SZ3->Z3_DTDESC  := Date()
			      EndIF
			      If SZ3->(fieldPos('Z3_HRDESC')) > 0
			         SZ3->Z3_HRDESC  := Time()
			      EndIf
		      EndIf
		      
		      If _ldFin		      
			      If SZ3->(fieldPos('Z3_USRFIN')) > 0
			         SZ3->Z3_USRFIN := __cUserId + '-' + cUserName		      
			      EndIf
			      If SZ3->(fieldPos('Z3_USRFIN')) > 0
			         SZ3->Z3_DTFIN  := Date()
			      EndIf
			      If SZ3->(fieldPos('Z3_USRFIN')) > 0
			         SZ3->Z3_HRFIN  := Time()
			      EndIf
		      EndIf
		     
		   SZ3->(MsUnlock())	
		EndIf	
	EndIf
Return lLibera

//Cria tabela temporária     
Static Function fTabTmp1(cOrc,cFilOrc)
 Local cQry     := "" 
 Local mv_par01 := '000063'
 Local cTable   := GetNextAlias()
 Local aVetor   := {}
 Local cCodtab  := SuperGetMv("MV_XTABELA",.F.,"")
 Local lwRet    := .T. 
 
 cQry += " SELECT * FROM " + RetSqlName("SL1") + " A "
 cQry += "  LEFT OUTER JOIN " + RetSqlName("SL2") + " B "
 cQry += "    ON B.D_E_L_E_T_ = '' AND L1_NUM = L2_NUM AND L1_FILIAL = L2_FILIAL "
 
 cQry += "  LEFT OUTER JOIN " + RetSqlName("DA1") + " C "
 cQry += "    ON C.D_E_L_E_T_ = '' AND DA1_CODPRO = L2_PRODUTO AND DA1_CODTAB = '" + cCodTab + "'
 
 cQry += "  LEFT OUTER JOIN " + RetSqlName("SB1") + " D "
 cQry += "    ON D.D_E_L_E_T_ = '' AND B1_COD = L2_PRODUTO "
 
 cQry += " WHERE A.D_E_L_E_T_ = ''
 cQry += "   And L1_NUM = '" + cOrc + "'"
 cQry += "   And L1_FILIAL = '" + cFilOrc + "'"
         
 dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), cTable, .T., .F. )     
 Memowrite('AALOJE04.sql',cQry)
  
 lwRet := !(cTable)->(EOf())
  While !(cTable)->(EOf()) .And. lwRet  
    If (cTable)->DA1_PRCVEN == Nil 
        Alert("O produto " +(cTable)->L2_PRODUTO+ " não esta cadastrado na tabela de preço!") 
        lwRet := .F.
      Else 
        aAdd(aVetor,{(cTable)->L2_PRODUTO,(cTable)->B1_DESC,(cTable)->B1_UM,(cTable)->L2_QUANT,(cTable)->L2_VRUNIT,(cTable)->L2_VLRITEM,(cTable)->L2_VALDESC,(cTable)->L2_PRCTAB,(cTable)->DA1_PRCVEN})
    EndIf 
    (cTable)->(dbSkip())
  EndDo
  
  If !lwRet          
    aVetor := {}
  EndIf 
  
  (cTable)->(dbCloseArea(cTable))
Return aVetor

Static Function fTabTmp2(cOrc,cFilOrc)
 Local cQry     := "" 
 Local mv_par01 := '000063'
 Local cTable   := GetNextAlias()
 Local aVetor   := {}
 Local cCodtab  := SuperGetMv("MV_XTABELA",.F.,"")
 
 cQry += " SELECT * FROM " + RetSqlName("SC5") + " A
 cQry += "  LEFT OUTER JOIN " + RetSqlName("SC6") + " B ON C5_NUM = C6_NUM AND C5_FILIAL = C6_FILIAL
 cQry += "  LEFT OUTER JOIN " + RetSqlName("DA1") + " C ON DA1_CODPRO = C6_PRODUTO AND DA1_CODTAB = '" + cCodTab + "'
 cQry += "  LEFT OUTER JOIN " + RetSqlName("SB1") + " D ON B1_COD = C6_PRODUTO 
 cQry += " WHERE A.D_E_L_E_T_ = ''
 cQry += "   AND B.D_E_L_E_T_ = ''
 cQry += "   AND C.D_E_L_E_T_ = ''
 cQry += "   AND D.D_E_L_E_T_ = ''
 cQry += "   And C5_NUM = '" + cOrc + "'"
 cQry += "   And C5_FILIAL = '" + cFilOrc + "'"
         
 dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), cTable, .T., .F. )     
 Memowrite('AALOJE04.sql',cQry)
  
  While !(cTable)->(EOf())
    aAdd(aVetor,{(cTable)->C6_PRODUTO,(cTable)->B1_DESC,(cTable)->B1_UM,(cTable)->C6_QTDVEN,(cTable)->C6_PRCVEN,(cTable)->C6_VALOR ,(cTable)->C6_VALDESC,(cTable)->C6_PRUNIT,(cTable)->DA1_PRCVEN})
    (cTable)->(dbSkip())
  EndDo         
   (cTable)->(dbCloseArea(cTable))
Return aVetor

Static Function fTabTmp3(cOrc,cFilOrc)
 Local cQry     := "" 
 Local mv_par01 := '000063'
 Local cTable   := GetNextAlias()
 Local aVetor   := {}
 Local cCodtab  := SuperGetMv("MV_XTABELA",.F.,"")
 
 cQry += " SELECT * FROM " + RetSqlName("SCJ") + " A
 cQry += "  LEFT OUTER JOIN " + RetSqlName("SCK") + " B ON CJ_NUM = CK_NUM AND CJ_FILIAL = CK_FILIAL
 cQry += "  LEFT OUTER JOIN " + RetSqlName("DA1") + " C ON DA1_CODPRO = CK_PRODUTO AND DA1_CODTAB = '" + cCodTab + "'
 cQry += "  LEFT OUTER JOIN " + RetSqlName("SB1") + " D ON B1_COD = CK_PRODUTO 
 cQry += " WHERE A.D_E_L_E_T_ = ''
 cQry += "   AND B.D_E_L_E_T_ = ''
 cQry += "   AND C.D_E_L_E_T_ = ''
 cQry += "   AND D.D_E_L_E_T_ = ''
 cQry += "   And CJ_NUM = '" + cOrc + "'"
 cQry += "   And CJ_FILIAL = '" + cFilOrc + "'"
         
 dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), cTable, .T., .F. )     
 Memowrite('AALOJE04.sql',cQry)
  
  While !(cTable)->(EOf())
    aAdd(aVetor,{(cTable)->CK_PRODUTO,(cTable)->B1_DESC,(cTable)->B1_UM,(cTable)->CK_QTDVEN,(cTable)->CK_PRCVEN,(cTable)->CK_VALOR ,(cTable)->CK_VALDESC,(cTable)->CK_PRUNIT,(cTable)->DA1_PRCVEN})
    (cTable)->(dbSkip())
  EndDo         
   (cTable)->(dbCloseArea(cTable))
Return aVetor


Static Function AALJ05T3()
                  
  Local nLinha     := 005
  Local nCol       := 015 
  Local _ndTotal   := 0
  Local _ndTotDesc := 0  
  SCK->(dbSetOrder(1))
  SCK->(dbSeek(xFilial("SC6")+SZ3->Z3_VENDA))
  SCK->( DBEVAL({|| _ndTotal += SCK->CK_VALOR , _ndTotDesc += SCK->CK_VALDESC },  {||SCK->CK_NUM = SCJ->CJ_NUM}, {||SCJ->CJ_NUM = SCJ->CJ_NUM}, , , ))
  
  Private oOrc  := Nil
  Private _cOrc := SCJ->CJ_NUM
  
  Private oCli  := Nil
  Private _cCli := SCJ->CJ_CLIENTE
              	
  Private oData := Nil
  Private _cData:= SCJ->CJ_EMISSAO
  
  Private oVal  := Nil
  Private _cVal := _ndTotal
  
  Private oDesc := Nil
  Private _cDesc:= Iif(_ndTotDesc!= 0,_ndTotDesc, iIf( SCJ->CJ_DESCONT!= 0,SCJ->CJ_DESCONT, _ndTotal*SCJ->CJ_PDESCAB / 100)  )
  
  Private oVlq  := Nil
  Private _nVlq := _ndTotal - _cDesc //SC5->C5_VLRLIQ
  
  Private oLoj  := Nil
  Private _cLoj := SCJ->CJ_LOJA   
  
  Private oDesCli := Nil
  Private _cDesCli := Posicione('SA1',1,xFilial('SA1')+SCJ->(CJ_CLIENTE+CJ_LOJA   ),"A1_NOME") 
  
  Private oDescFrm := Nil
  Private _cDescFrm := ""
  
  Private oCondPg  := Nil
  Private _cCondPg := ""

  Private oDescCP  := Nil
  Private _cDescCP := ""
  
  Private aVetor  := fTabTmp3(SCJ->CJ_NUM,SCJ->CJ_FILIAL)
  nLinha += 010     
  
  DefineWindow()
  
Return Nil

Static Function AALJ05T2()
                  
  Local nLinha     := 005
  Local nCol       := 015 
  Local _ndTotal   := 0
  Local _ndTotDesc := 0  
  SC6->(dbSetOrder(1))
  SC6->(dbSeek(xFilial("SC6")+SZ3->Z3_VENDA))
  SC6->( DBEVAL({|| _ndTotal += SC6->C6_VALOR , _ndTotDesc += SC6->C6_VALDESC },  {||SC6->C6_NUM = SC5->C5_NUM}, {||SC6->C6_NUM = SC5->C5_NUM}, , , ))
  
  Private oOrc  := Nil
  Private _cOrc := SC5->C5_NUM
  
  Private oCli  := Nil
  Private _cCli := SC5->C5_CLIENTE
              	
  Private oData := Nil
  Private _cData:= SC5->C5_EMISSAO
  
  Private oVal  := Nil
  Private _cVal := _ndTotal
  
  Private oDesc := Nil
  Private _cDesc:= Iif(_ndTotDesc!= 0,_ndTotDesc, iIf( SC5->C5_DESCONT!= 0,SC5->C5_DESCONT, _ndTotal*SC5->C5_PDESCAB / 100)  )
  
  Private oVlq  := Nil
  Private _nVlq := _ndTotal - _cDesc //SC5->C5_VLRLIQ
  
  Private oLoj  := Nil
  Private _cLoj := SC5->C5_LOJACLI
  
  Private oDesCli := Nil
  Private _cDesCli := Posicione('SA1',1,xFilial('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_NOME") 
  
  Private oDescFrm := Nil
  Private _cDescFrm := ""
  
  Private oCondPg  := Nil
  Private _cCondPg := SC5->C5_CONDPAG

  Private oDescCP  := Nil
  Private _cDescCP := Posicione('SE4',1,xFilial('SE4')+SL1->L1_CONDPG,"E4_DESCRI" )
  
  Private aVetor  := fTabTmp2(SC5->C5_NUM,SC5->C5_FILIAL)
  nLinha += 010     
  
  DefineWindow()
  
Return Nil

Static Function AALJ05T1()

  Private oOrc  := Nil
  Private _cOrc := SL1->L1_NUM
  
  Private oCli  := Nil
  Private _cCli := SL1->L1_CLIENTE
  
  Private oData := Nil
  Private _cData:= SL1->L1_EMISSAO
  
  Private oVal  := Nil
  Private _cVal := SL1->L1_VLRTOT
  
  Private oDesc := Nil
  Private _cDesc:= SL1->L1_DESCONT
  
  Private oVlq  := Nil
  Private _nVlq := SL1->L1_VLRLIQ
  
  Private oLoj  := Nil
  Private _cLoj := SL1->L1_LOJA
  
  Private oDesCli := Nil
  Private _cDesCli := Posicione('SA1',1,xFilial('SA1')+SL1->(L1_CLIENTE+L1_LOJA),"A1_NOME") 
  
  Private oDescFrm := Nil
  Private _cDescFrm := Posicione('SL4',1,xFilial('SL4')+SL1->L1_NUM,"L4_FORMA" )

  Private oCondPg  := Nil
  Private _cCondPg := SL1->L1_CONDPG

  Private oDescCP  := Nil
  Private _cDescCP := Posicione('SE4',1,xFilial('SE4')+SL1->L1_CONDPG,"E4_DESCRI" )

  Private aVetor  := fTabTmp1(SL1->L1_NUM,SL1->L1_FILIAL)
  
  If Len(aVetor) > 0 
    DefineWindow()
  EndIf 
Return Nil

Static Function DefineWindow()
Local nCol   := 015 
Local aBotao :={} 
Private aSize 	 := {}
Private aPosObj  := {}

     
Private nLinha  := 015

PosObjetos(@aSize,@aPosObj)

SA1->(dbSetOrder(1))
SA1->(dbSeek( xFilial("SA1") + _cCli ))

aadd(aBotao,{"POSCLI"  ,{|| _odLbx := oLbx , If(!Empty(_cCli),a450F4Con() ,.F.),Pergunte("MTA410",.F.), oLbx := _odLbx },"Cliente","Cliente" }) 	//"Posi‡„o de Cliente"
//aadd(aBotao,{"Serasa"  ,{|| _odLbx := oLbx , If(!Empty(_cCli),u_odSerasa() ,.F.),Pergunte("MTA410",.F.), oLbx := _odLbx },"Serasa","Serasa" }) 	//"Posi‡„o de Cliente"


DEFINE MSDIALOG oDlg TITLE "Liberação do Orcamento "  From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL
//  bob dylan
//   blow in the window
	  oPanelAll:= tPanel():New(aPosObj[1,1],aPosObj[1,2],"",oDlg,,,,,,aPosObj[1,3],aPosObj[1,4])
	  oPanelAll:align:= CONTROL_ALIGN_ALLCLIENT
	  
	  nLinha := aPosObj[1,1]
	
      @ nLinha,015 Say "Orcamento: "  Size 035,08 Of oPanelAll Pixel //Font oFnt3
      @ nLinha,050 Get oOrc VAR _cOrc  SIZE 100,08 Of oPanelAll Pixel When .F.
      
      @ nLinha,150 Say "Forma de Pagamento: "  Size 060,08 Of oPanelAll Pixel //Font oFnt3
      @ nLinha,210 Get oDescFrm VAR _cDescFrm  SIZE 30,08 Of oPanelAll Pixel When .F.

      @ nLinha,260 Say "Cond. de Pagamento: "  Size 060,08 Of oPanelAll Pixel //Font oFnt3
      @ nLinha,320 Get oCondPg VAR _cCondPg    SIZE 30,08 Of oPanelAll Pixel When .F.
      @ nLinha,350 Get oDescCP VAR _cDescCP    SIZE 90,08 Of oPanelAll Pixel When .F.
      
        nLinha += 20
        
      @ nLinha,015 Say "Cliente: "  Size 035,08 Of oPanelAll Pixel //Font oFnt3
      @ nLinha,050 Get oCli VAR _cCli  SIZE 100,08 Of oPanelAll Pixel When .F.

      @ nLinha,153 Get oLoj VAR _cLoj  SIZE 15,08 Of oPanelAll Pixel When .F.
        nLinha +=10
      @ nLinha,050 Get oDesCli VAR _cDesCli  SIZE 280,08 Of oPanelAll Pixel When .F.
      

      @ nLinha,350 Say "Data: "  Size 035,08 Of oPanelAll Pixel //Font oFnt3
      @ nLinha,390 Get oData VAR _cData  SIZE 50,08 Of oPanelAll Pixel When .F.
      
        nLinha += 20
      
      @ nLinha,15 Say "Valor Orcamento : "  Size 035,08 Of oPanelAll Pixel //Font oFnt3
      @ nLinha,50 Get oVal VAR _cVal  Picture "@E 999,999,999.99" SIZE 100,08 Of oPanelAll Pixel When .F.
        
        
      @ nLinha,190 Say "Desconto : "  Size 035,08 Of oPanelAll Pixel //Font oFnt3
      @ nLinha,230 Get oDesc VAR _cDesc Picture "@E 999,999,999.99" SIZE 100,08 Of oPanelAll Pixel When .F.
      
      @ nLinha,350 Say "Valor Total : "  Size 035,08 Of oPanelAll Pixel //Font oFnt3
      @ nLinha,390 Get oVlq VAR _nVlq  Picture "@E 999,999,999.99" SIZE 100,08 Of oPanelAll Pixel When .F.
      
        nLinha += 20
      //@ aPosObj[2,1],aPosObj[2,4] - 145 	LISTBOX oPeriodo VAR cPeriodo Fields HEADER Left(Eval(bSx3, "CV1_PERIOD"),3),Eval(bSx3, "CV1_DTINI"),Eval(bSx3, "CV1_DTFIM"),Eval(bSx3, "CV1_VALOR") SIZES 12,30,28,20 SIZE 145,aPosObj[2,3] - aPosObj[2,1] NOSCROLL PIXEL 
      
      @ aPosObj[2,1],aPosObj[2,2] LISTBOX oLbx VAR cVar FIELDS HEADER "Código","Descrição","UM","Quantidade","Preco Unit.","Valor Total","Desconto","Preco Venda", "Preco Atacado";
        SIZE aPosObj[2,4],aPosObj[2,3] OF oPanelAll PIXEL
      
      oLbx:SetArray( aVetor )
      oLbx:bLine := {|| {aVetor[oLbx:nAt,1],;
      aVetor[oLbx:nAt,2],;
      aVetor[oLbx:nAt,3],;
      Transform(aVetor[oLbx:nAt,4],PesqPict("SL2","L2_QUANT",18,2)),;
      Transform(aVetor[oLbx:nAt,5],PesqPict("SL2","L2_VRUNIT",18,2)),;      
      Transform(aVetor[oLbx:nAt,6],PesqPict("SL2","L2_VLRITEM",18,2)),;
      Transform(aVetor[oLbx:nAt,7],PesqPict("SL2","L2_VALDESC",18,2)),;
      Transform(aVetor[oLbx:nAt,8],PesqPict("SL2","L2_PRCTAB",18,2)),;
      Transform(aVetor[oLbx:nAt,9],PesqPict("DA1","DA1_PRCVEN",18,2))}}
      
      oLbx:nAt := 1
      
  ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||Libera(),oDlg:End()},{||oDlg:End()},,aBotao) 
  
Return 

User Function AALJ05GRV(aCampos)

   Local _adPos := {}
   Local cChave := ""
   Default aCampos := {}
   
   aAdd(_adPos , aScan(aCampos,{|x| Alltrim(x[01]) == "Z3_FILIAL"})  )
   aAdd(_adPos , aScan(aCampos,{|x| Alltrim(x[01]) == "Z3_VENDA"})   )
   aAdd(_adPos , aScan(aCampos,{|x| Alltrim(x[01]) == "Z3_TIPO"})    )
   aAdd(_adPos , aScan(aCampos,{|x| Alltrim(x[01]) == "Z3_CLIENTE"}) )
   aAdd(_adPos , aScan(aCampos,{|x| Alltrim(x[01]) == "Z3_LOJA"})    )
   
   aEval(_adPos,{|x| cChave += IiF (x > 0,aCampos[x][02],"")})
   SZ3->(dbSetOrder(1))
   lRecLock := !SZ3->(dBSeek(cChave))   
   SZ3->(RecLock("SZ3",lRecLock))
   
   For _ndPos := 1 to Len(aCampos)
       SZ3->&(aCampos[_ndPos][01]) := aCampos[_ndPos][02]
   Next
   
   SZ3->(MsUnlock())   
   
   UpdPrincipal()
   
Return Nil

Static Function UpdPrincipal()
If SZ3->Z3_TIPO = "1"      
      SL1->(dbSetOrder(1))
      If SL1->(dBSeek(SZ3->(Z3_FILIAL + PAdr(Z3_VENDA,Len(SL1->L1_NUM)) + Z3_CLIENTE + Z3_LOJA) ))
         SL1->(RecLock("SL1",.F.))
           SL1->L1_XBLQORC := SZ3->Z3_BLOQUEI
         SL1->(MsUnlock())
      EndIf
            
ElseIf SZ3->Z3_TIPO = "2"
         SC5->(dbSetOrder(1))
      If SC5->(dBSeek(SZ3->(Z3_FILIAL + PAdr(Z3_VENDA,Len(SC5->C5_NUM)) + Z3_CLIENTE + Z3_LOJA) )) .And. SC5->(FieldPos("C5_XBLQORC")) > 0
         SC5->(RecLock("SC5",.F.))
           SC5->C5_XBLQORC := SZ3->Z3_BLOQUEI
         SC5->(MsUnlock())
      EndIf
ElseIf SZ3->Z3_TIPO = "3"
         SCJ->(dbSetOrder(1))
      If SCJ->(dBSeek(SZ3->(Z3_FILIAL + PAdr(Z3_VENDA,Len(SC5->C5_NUM)) + Z3_CLIENTE + Z3_LOJA) )) .And. SCJ->(FieldPos("CJ_XBLQORC")) > 0
         SCJ->(RecLock("SCJ",.F.))
           SCJ->CJ_XBLQORC := SZ3->Z3_BLOQUEI
         SCJ->(MsUnlock())
      EndIf      
EndIf
Return 
User Function AALJE05L
BrwLegenda("Liberacao de Pedido","Legendas",{{"BR_PERTO"   ,"Orcamento Loja"},;
                                             {"BR_LARANJA","Pedido de Venda"},;
                                             {"BR_AZUL"   ,"Orcamento Faturamento"}})

Return Nil

Static Function _getDescMax()

     _xdMax := {{"",0}}
     _xdBase := "MV_XMXDC"
     _xdLim  := SuperGetMv("MV_XMAXLIM",.F.,"MENOR")
          
     //_xdMax := 99
     For _xdK := 99 To 01 Step -1
     
         _xdUSr   := SuperGetMv( _xdBase+StrZero(_xdK,2),.F.,"")                          
         _adUsers := StrTokArr(_xdUSr,';')
         
         For _xdF := 01 to Len(_adUsers)
         
             _xdPos := aScan(_xdMax,{|x|  x[01] == _adUsers[_xdF]} )             
             If _xdPos > 0
                If Upper(Alltrim(_xdLim)) == "MENOR"
                   _xdMax[_xdPos][02] := _xdK  
                EndIf
             Else
                aAdd(_xdMax,{_adUsers[_xdF] , _xdK })
             EndIf
         Next
         
         //SX6->(dbSeek())
     Next
     /*
     SuperGetMv("MV_XMXDS10",.F.,"")
     SuperGetMv("MV_XMXDS20",.F.,"")
     SuperGetMv("MV_XMXDS30",.F.,"")
     SuperGetMv("MV_XMXDS40",.F.,"")
     SuperGetMv("MV_XMXDS50",.F.,"")
     SuperGetMv("MV_XMXDS60",.F.,"")
     SuperGetMv("MV_XMXDS70",.F.,"")
     SuperGetMv("MV_XMXDS80",.F.,"")
     SuperGetMv("MV_XMXDS90",.F.,"")
     SuperGetMv("MV_XMXDS99",.F.,"")
     */
return _xdMax

Static Function PosObjetos(aSize,aPosObj)
	Local aInfo
	Local aObjects := {}

	// Faz o calculo automatico de dimensoes de objetos     
	aSize := MsAdvSize(.F.,.F.)
	
	AAdd( aObjects, { 100 , 083, .T. , .F. } )
	AAdd( aObjects, { 100 , 140, .T. , .F. } )
	//AAdd( aObjects, { 100 , 024, .T. , .F. } )

	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

Return


/*powered by DXRCRVOB*/