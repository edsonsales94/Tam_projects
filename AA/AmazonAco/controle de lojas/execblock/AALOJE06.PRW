#INCLUDE "AvPrint.ch"  	
#INCLUDE "Font.ch"
#Include "Protheus.ch" 
#include "rwmake.ch"   
#include "TopConn.ch"
#include "tbiconn.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦AALOJE04    ¦ Autor ¦ ADRIANO LIMA         ¦ Data ¦ 29/12/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Inclusão da Opção de Liberação no Ponto de Entrada no Browser ¦¦¦
¦¦¦             da Tela de Venda Assistida.		                              ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/ 

User Function AALOJE06()

Private cCadastro := "Liberação"
Private aRotina   := { {"Pesquisar"  ,"AxPesqui"   ,0,1} ,;
                       {"Liberação"  ,"u_AALJ06V",0,2} }//,;
//                       {"Visualizar" ,"AxVisual",0,2} ,;
//                       {"Alterar"    ,"AxAltera",0,4} ,;
//                       {"Excluir"    ,"AxDeleta",0,5} }

Private cAlias0 := "SL1"
Private cFilSZ0 := SZ0->(xFilial("SL1"))

dbSelectArea(cAlias0)
dbSetOrder(1)
If __cUserId$GetMv("MV_XLIBORG")
   dbSetFilter({|| (SL1->L1_XBLQORC <> "  " )},'(SL1->L1_XBLQORC <> "  ")')
elseif __cUserId$GetMv("MV_XLIBORC")
   dbSetFilter({|| (SL1->L1_XBLQORC <> "  " .And. Left(SL1->L1_XBLQORC,1)="C" )},'(SL1->L1_XBLQORC <> "  " .And. Left(SL1->L1_XBLQORC,1)="C" )')   
elseif __cUserId$GetMv("MV_XLIBORD")
   dbSetFilter({|| (SL1->L1_XBLQORC <> "  " .And. Right(SL1->L1_XBLQORC,1)="D" )},'(SL1->L1_XBLQORC <> "  " .And. Right(SL1->L1_XBLQORC,1)="D" )')   
EndIf


mBrowse( 6,1,22,75,cAlias0)                   

Return
             

User Function AALJ06V()
Local aAreaSL1 := SL1->(GetARea())

if U_AALJ06T()
  if Aviso('Liberacao','Deseja Liberar o Orcamento',{'Sim','Nao'}) == 1
     Libera()
  EndIf
EndIf
SL1->(RestArea(aAreaSL1))


Return


//#################################################      
//Tela de Liberação
//#################################################

Static Function Libera()
   Local lLibera := .T.
    SL1->(RecLOck('SL1',.F.))
	If Left(SL1->L1_XBLQORC,1) = 'C'
		If __cUserId$GetMv("MV_XLIBORC") .Or. __cUserId$GetMv("MV_XLIBORG")
			SL1->L1_XBLQORC := ' ' + Right(SL1->L1_XBLQORC,1)
		EndIf
	EndIf
	
	If __cUserId$GetMv("MV_XLIBORD")  .And. Right(SL1->L1_XBLQORC,1) = 'D'
		lLibera := .T.
		SL2->(dbSetOrder(1))
		SL2->(dbSeek(xFilial("SL2")+SL1->L1_NUM))
		SL2->( DBEVAL({|| lLibera := lLibera .And. SL2->L2_VRUNIT >= Posicione('DA1',1,xFilial('DA1')+"002"+SL2->L2_PRODUTO,"DA1_PRCVEN") }, {||SL2->L2_NUM = SL1->L1_NUM}, {||SL2->L2_NUM = SL1->L1_NUM}, , , ) )
		SL2->( DBEVAL({|| lLibera := lLibera .And. SL2->L2_VRUNIT* 100-SL1->(L1_DESCONT * L1_VLRTOT)/ 100 >= Posicione('DA1',1,xFilial('DA1')+"002"+SL2->L2_PRODUTO,"DA1_PRCVEN") }, {||SL2->L2_NUM = SL1->L1_NUM}, {||SL2->L2_NUM = SL1->L1_NUM}, , , ) )
		if !lLibera
			Aviso("Atenção","Desconto Ultrapassa preço do Atacado, Somente Usuario Superior",{"OK"})
		else		   
			SL1->L1_XBLQORC := Left(SL1->L1_XBLQORC,1) + " "
		EndIf
	EndIf
	
	If __cUserId$GetMv("MV_XLIBORG").And. Right(SL1->L1_XBLQORC,1) = 'D'
		SL1->L1_XBLQORC := Left(SL1->L1_XBLQORC,1) + " "
	EndIf
	SL1->(MsUnlock())
Return lLibera

//------------------------------------------------
Static Function fCols()
//------------------------------------------------
Local nX
Local aHeaderEx := {}
Local aColsEx := {}
Local aFieldFill := {}
Local aFields := {"rrrrrr","ggg","hhhhh"}
Local aAlterFields := {"ttttt","cccc","dddd","eeee","fffff"}
Static oMSNewGe1

  // Define field properties
  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
  Next nX

  // Define field values
  For nX := 1 to Len(aFields)
    If DbSeek(aFields[nX])
      Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
    Endif
  Next nX
  Aadd(aFieldFill, .F.)
  Aadd(aColsEx, aFieldFill)

  oMSNewGe1 := MsNewGetDados():New( 078, 054, 138, 259, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)

Return

/*
//------------------------------------------------
Static Function fCols()
//------------------------------------------------ 
Local nX
Local aHeaderEx := {}
Local aColsEx := {}
Local aFieldFill := {}
Local aFields := {"Código","Descrição","Valor","Vlr Atacado","Varejo"}
Local aAlterFields := {}
Static oMSNewGe1

  // Define field properties
  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
  Next nX

  // Define field values
  For nX := 1 to Len(aFields)
    If DbSeek(aFields[nX])
      Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
    Endif
  Next nX              
  
  Aadd(aFieldFill, .F.)
  Aadd(aColsEx, aFieldFill)

  oMSNewGe1 := MsNewGetDados():New( 082, 012, 142, 277, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)

Return            

  */

/*
//#########################################################################
//¦¦¦ Descriçäo ¦ Rotina onde será montado o cabecalho do acols (aHeader)
//#########################################################################
Static Function CriaHeader()
 Local cAlias 	:= "SL2"
 Local cCAcols := "L2_ITEM|L2_DESCRI|L2_VRUNIT"
 Local lRet    := .T.  	
  	      
 nUsado  := 0
 aHeader := {}
 
  dbSelectArea("SX3")
  dbSetOrder(1)
  dbSeek(cAlias) 
	
  While ( !Eof() .And. SX3->X3_ARQUIVO == cAlias )
    If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. AllTrim(SX3->X3_CAMPO) $ cCAcols)
	      aAdd(aHeader,{ Trim(X3Titulo()), ;  //1  Titulo do Campo
	                     SX3->X3_CAMPO   , ;  //2  Nome do Campo
	                     SX3->X3_PICTURE , ;  //3  Picture Campo 
	                     SX3->X3_TAMANHO , ;  //4  Tamanho do Campo
	                     SX3->X3_DECIMAL , ;  //5  Casas decimais 
	                     SX3->X3_VALID   , ;  //6  Validacao do campo
	                     SX3->X3_USADO   , ;  //7  Usado ou naum
	                     SX3->X3_TIPO    , ;  //8  Tipo do campo
	                     SX3->X3_ARQUIVO , ;  //9  Arquivo 
	                     SX3->X3_CONTEXT } )  //10 Visualizar ou alterar
	   Endif
	   dbSkip()
	End                                    
return lRet 
                                                                     
      
//###################################################################
//¦¦¦ Descriçäo ¦ Rotina onde serão carregados os dados para o acols
//###################################################################
Static Function CarregaAcols(cwNum)
 Local   lRet := .T.
 Private aAux := {}

  _nCol1 := Ascan( aHeader , {|x| Trim(x[2]) == "L2_ITEM"})
  _nCol2 := Ascan( aHeader , {|x| Trim(x[2]) == "L2_DESCRI"})
  _nCol3 := Ascan( aHeader , {|x| Trim(x[2]) == "L2_VRUNIT"})

  cArea   := GetArea()  
    
//  PAM->(dbSetorder(1))
//  If PAM->(dbSeek(xFilial("PAM")+cwVar02) )
      While !WWW->(EOF()) //.And. ( PAM->(PAM_FILIAL+ PAM_CODGAR ) == ( xFilial("PAM")+cwVar02 ) ) //SZ4->(Z4_FILIAL + Z4_NUM )
        fCriaVar()
 		  
 		  aCols[Len(aCols)][_nCol1] := WWW->L2_ITEM
 		  aCols[Len(aCols)][_nCol2] := WWW->L2_DESCRI
 		  aCols[Len(aCols)][_nCol3] := WWW->L2_VRUNIT

	  	  WWW->(dbSkip())              
  	   End
//  	 Else 
      fCriaVar()	             
//  EndIf  
Return 
                                                             
                                                      
//###########################################################
//¦¦¦ Descriçäo ¦ Valida o campo do acols
//###########################################################
Static Function fCriaVar()
  aAdd(aCols,Array(Len(aHeader)+1))                	
  For i:= 1 to Len(aHeader)		  
    aCols[Len(aCols)][i] := CriaVar(Trim(aHeader[i][2]),.T.)
  Next    
  aCols[Len(aCols)][len(aHeader)+1] := .F.
Return nil
  
  */                                     

//Cria tabela temporária     
Static Function fTabTmp(cOrc,cFilOrc)
 Local cQry     := "" 
 Local mv_par01 := '000063'
 Local mv_par02 := "002" // PEGAR PARAMETRO PARA TABELA DE PRECO
 Local cTable   := "DROR"
 Local aVetor   := {}
 
 cQry += " SELECT * FROM " + RetSqlName("SL1") + " A
 cQry += "  LEFT OUTER JOIN " + RetSqlName("SL2") + " B ON L1_NUM = L2_NUM AND L1_FILIAL = L2_FILIAL
 cQry += "  LEFT OUTER JOIN " + RetSqlName("DA1") + " C ON DA1_CODPRO = L2_PRODUTO AND DA1_CODTAB = '002'
 cQry += "  LEFT OUTER JOIN " + RetSqlName("SB1") + " D ON B1_COD = L2_PRODUTO 
 cQry += " WHERE A.D_E_L_E_T_ = ''
 cQry += "   AND B.D_E_L_E_T_ = ''
 cQry += "   AND C.D_E_L_E_T_ = ''
 cQry += "   AND D.D_E_L_E_T_ = ''
 cQry += "   And L1_NUM = '" + cOrc + "'" 
 cQry += "   And L1_FILIAL = '" + cFilOrc + "'" 
 
// cQry += "   And L1_NUM = '000063'
         
  dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), cTable, .T., .F. )     
  Memowrite('AALOJE04.sql',cQry)
  
  While !(cTable)->(EOf())
    aAdd(aVetor,{(cTable)->L2_PRODUTO,(cTable)->B1_DESC,(cTable)->B1_UM,(cTable)->L2_QUANT,(cTable)->L2_VRUNIT,(cTable)->L2_PRCTAB,(cTable)->DA1_PRCVEN})
    (cTable)->(dbSkip())
  EndDo         
   (cTable)->(dbCloseArea(cTable))
Return aVetor

User Function AALJ06T()
   
  Local nLinha := 005
  Local nCol   := 015 
   
//  prepare environment Empresa "01" Filial "03" tables 'SL1,SL2,DA1,SB1'
                                            
  Private oOrc  := Nil
  Private _cOrc := SL1->L1_NUM//Space(TamSX3('L1_NUM')[01] - lEN(SL1->L1_NUM))
  
  Private oCli  := Nil
  Private _cCli := SL1->L1_CLIENTE//Space(TamSX3('L1_CLIENTE')[01])
  
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
  
  Private aVetor  := fTabTmp(SL1->L1_NUM,SL1->L1_FILIAL)
  nLinha += 010     
  
  DEFINE MSDIALOG oDlg TITLE "Orcamento"  From nLinha,nCol To nLinha+40, nCol + 140 //OF oMainWnd
//  bob dylan
//   blow in the window
      @ nLinha,015 Say "Orcamento: "  Size 035,08 Of oDlg Pixel //Font oFnt3
      @ nLinha,050 Get oOrc VAR _cOrc  SIZE 100,08 Of oDlg Pixel
      
        nLinha += 20
        
      @ nLinha,015 Say "Cliente: "  Size 035,08 Of oDlg Pixel //Font oFnt3
      @ nLinha,050 Get oCli VAR _cCli  SIZE 100,08 Of oDlg Pixel
//      @ nLinha,151 Say "-"  Size 035,08 Of oDlg Pixel //Font oFnt3
      @ nLinha,153 Get oLoj VAR _cLoj  SIZE 15,08 Of oDlg Pixel      
        nLinha +=10
      @ nLinha,050 Get oDesCli VAR _cDesCli  SIZE 280,08 Of oDlg Pixel
      
//        nLinha += 20

      @ nLinha,350 Say "Data: "  Size 035,08 Of oDlg Pixel //Font oFnt3
      @ nLinha,390 Get oData VAR _cData  SIZE 50,08 Of oDlg Pixel
      
        nLinha += 20
      
      @ nLinha,15 Say "Valor Orcamento : "  Size 035,08 Of oDlg Pixel //Font oFnt3
      @ nLinha,50 Get oVal VAR _cVal  Picture "@E 999,999,999.99" SIZE 100,08 Of oDlg Pixel
        
//        nLinha += 20
        
      @ nLinha,190 Say "Desconto : "  Size 035,08 Of oDlg Pixel //Font oFnt3
      @ nLinha,230 Get oDesc VAR _cDesc Picture "@E 999,999,999.99" SIZE 100,08 Of oDlg Pixel
//        nLinha += 20
      @ nLinha,350 Say "Valor Total : "  Size 035,08 Of oDlg Pixel //Font oFnt3
      @ nLinha,390 Get oVlq VAR _nVlq  Picture "@E 999,999,999.99" SIZE 100,08 Of oDlg Pixel
      
        nLinha += 20
        
      @ nLinha,15 LISTBOX oLbx VAR cVar FIELDS HEADER "Código","Descrição","UM","Quantidade","Preco Unit.","Preco Venda", "Preco Atacado";
        SIZE 465,160 OF oDlg PIXEL
      
      oLbx:SetArray( aVetor )
      oLbx:bLine := {|| {aVetor[oLbx:nAt,1],;
      aVetor[oLbx:nAt,2],;
      aVetor[oLbx:nAt,3],;
      Transform(aVetor[oLbx:nAt,4],PesqPict("SL2","L2_QUANT",18,2)),;
      Transform(aVetor[oLbx:nAt,5],PesqPict("SL2","L2_VRUNIT",18,2)),;      
      Transform(aVetor[oLbx:nAt,6],PesqPict("SL2","L2_PRCTAB",18,2)),;
      Transform(aVetor[oLbx:nAt,7],PesqPict("DA1","DA1_PRCVEN",18,2))}}
      
//    Transform(aVetor[oLbx:nAt,3],PesqPict("SL2","L2_QUANT",18,2)),;
      oLbx:nAt := 1
      
  ACTIVATE MSDIALOG oDlg ON INIT;
  EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()}) CENTERED 
  Libera()
Return Nil
